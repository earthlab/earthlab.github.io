---
layout: single
title: "Open and Crop Landsat Remote Sensing Data in Open Source Python"
excerpt: "Learn how to open up and create a stack of Landsat images and crop them to a certain extent using open source Python."
authors: ['Leah Wasser', 'Nathan Korinek']
dateCreated: 2020-03-25
modified: 2021-06-10
category: [courses]
class-lesson: ['multispectral-remote-sensing-data-python-landsat']
permalink: /courses/use-data-open-source-python/multispectral-remote-sensing/landsat-in-Python/open-and-crop-data/
nav-title: 'Open & Crop Landsat Data'
course: "intermediate-earth-data-science-textbook"
week: 5
sidebar:
  nav:
author_profile: false
comments: true
order: 2
topics:
  remote-sensing: ['landsat', 'modis']
  earth-science: ['fire']
  reproducible-science-and-programming: ['python']
  spatial-data-and-gis: ['raster-data']
---
{% include toc title="On This Page" icon="file-text" %}

<div class='notice--success' markdown="1">

## <i class="fa fa-graduation-cap" aria-hidden="true"></i> Learning Objectives

After completing this lesson, you will be able to:

* Create a list of subsets of landsat `.tif` files using `glob` and `os.path.join`
* Crop xarray objects.
* Stack a list of landsat `.tif` files into a **xarray** object.
* Create a workflow that opens, stacks and cleans landsat data efficiently.

</div>


## Open Landsat .tif Files in Python

It's time to get start processing your data. To begin, load your 
libraries and set up your working directory.

{:.input}
```python
import os
from glob import glob

import matplotlib.pyplot as plt
import geopandas as gpd
import rasterio as rio
import xarray as xr
import rioxarray as rxr
import numpy as np
import numpy.ma as ma
import earthpy as et
import earthpy.spatial as es
import earthpy.plot as ep
from shapely.geometry import mapping


# Download data and set working directory
data = et.data.get_data('cold-springs-fire')
os.chdir(os.path.join(et.io.HOME,
                      'earth-analytics',
                      'data'))
```

You will be working in the `landsat-collect` directory. Notice that the data in that directory are stored by individual band. Each file is a single geotiff (.tif) rather than one tif with all the bands which is what you worked with in the previous lesson with NAIP data.  

### Why Are Landsat Bands Stored As Individual Files?
 
Originally Landsat was stored in a file format called HDF - hierarchical
data format. However that format, while extremely efficient, is a bit more
challenging to work with. In recent years, USGS has started to make each band
of a landsat scene available as a `.tif` file. This makes it a bit easier to use
across many different programs and platforms.

The good news is that you already know how to work with .tif files in **Python**. You just need to learn how to batch process a series of `.tif` files to work with Landsat 8 Collections. 

## Generate a List of Files in Python
 
To begin, explore the Landsat files in your `cs-test-landsat` directory. Start with the data:

`data/cs-test-landsat/`

Landsat scenes are large. In order to make processing your data  more efficient, 
you can subset the data to just the parts that you need. This may include:

1. only opening bands that you need for your final analysis and
2. cropping the data if your study area is small than or not fully covered by the landsat  scene extent.

For the purpose of this lesson, let's pretend that you wish to perform  an 
NDVI analysis of your Landsat data. You also may wish to plot Color infrared
images and an RGB image. To  perform  this you will want  to grab the following
bands:

* Red, green, blue and near infrared 

from your data. This should be bands 2-5 following the landsat documentation.

Below are all of the bands in your landsat data:

```
'LC08_L1TP_034032_20160621_20170221_01_T1_sr_band7.tif',
'LC08_L1TP_034032_20160621_20170221_01_T1.xml',
'LC08_L1TP_034032_20160621_20170221_01_T1_sr_band5.tif',
'LC08_L1TP_034032_20160621_20170221_01_T1_sr_band1.tif',
'LC08_L1TP_034032_20160621_20170221_01_T1_sr_aerosol.tif',
'LC08_L1TP_034032_20160621_20170221_01_T1_sr_band3.tif',
'LC08_L1TP_034032_20160621_20170221_01_T1_ANG.txt',
'LC08_L1TP_034032_20160621_20170221_01_T1_sr_band2.tif',
'crop',
'LC08_L1TP_034032_20160621_20170221_01_T1_sr_band4.tif',
'LC08_L1TP_034032_20160621_20170221_01_T1_sr_band6.tif',
'LC08_L1TP_034032_20160621_20170221_01_T1_pixel_qa.tif',
'LC08_L1TP_034032_20160621_20170221_01_T1_radsat_qa.tif',
'LC08_L1TP_034032_20160621_20170221_01_T1_MTL.txt'

```

Notice that there are some layers that are quality assurance layers. Others have the word band in them. The layers with band in them are the reflectance data that you need to work with. 

To work with these files, you will do the following:

1. You will generate a list of only the files in the directory that contain the word **band** in the name and that only represent the  bands that you need for your analysis. 
2. Crop the data to the extent of the study area.
3. OPTIONAL: stack all of the layers into one rioxarray object: Note that you  may or may not wish to stack the data. If your main goal is to calculate NDVI, or some other vegetation index, then stacking may not be necessary. If you wish to create color plots of your data in RGB or CIR format, or to perform other analytics on the stacked data then it may make sense to stack the  data.

You will use the `glob()` function and library to do this in **Python**. 

Begin exploring your data by grabbing all of the files in the directory using `/*`. 

{:.input}
```python
landsat_post_fire_path = os.path.join("cold-springs-fire",
                                      "landsat_collect",
                                      "LC080340322016072301T1-SC20180214145802",
                                      "crop")

glob(os.path.join(landsat_post_fire_path, "*"))
```

{:.output}
{:.execute_result}



    ['cold-springs-fire/landsat_collect/LC080340322016072301T1-SC20180214145802/crop/LC08_L1TP_034032_20160723_20180131_01_T1_pixel_qa_crop.tif',
     'cold-springs-fire/landsat_collect/LC080340322016072301T1-SC20180214145802/crop/LC08_L1TP_034032_20160723_20180131_01_T1_radsat_qa_crop.tif',
     'cold-springs-fire/landsat_collect/LC080340322016072301T1-SC20180214145802/crop/LC08_L1TP_034032_20160723_20180131_01_T1_sr_aerosol_crop.tif',
     'cold-springs-fire/landsat_collect/LC080340322016072301T1-SC20180214145802/crop/LC08_L1TP_034032_20160723_20180131_01_T1_sr_band1_crop.tif',
     'cold-springs-fire/landsat_collect/LC080340322016072301T1-SC20180214145802/crop/LC08_L1TP_034032_20160723_20180131_01_T1_sr_band2_crop.tif',
     'cold-springs-fire/landsat_collect/LC080340322016072301T1-SC20180214145802/crop/LC08_L1TP_034032_20160723_20180131_01_T1_sr_band3_crop.tif',
     'cold-springs-fire/landsat_collect/LC080340322016072301T1-SC20180214145802/crop/LC08_L1TP_034032_20160723_20180131_01_T1_sr_band4_crop.tif',
     'cold-springs-fire/landsat_collect/LC080340322016072301T1-SC20180214145802/crop/LC08_L1TP_034032_20160723_20180131_01_T1_sr_band5_crop.tif',
     'cold-springs-fire/landsat_collect/LC080340322016072301T1-SC20180214145802/crop/LC08_L1TP_034032_20160723_20180131_01_T1_sr_band6_crop.tif',
     'cold-springs-fire/landsat_collect/LC080340322016072301T1-SC20180214145802/crop/LC08_L1TP_034032_20160723_20180131_01_T1_sr_band7_crop.tif']





### Grab Subsets of File Names Using File Names and Other Criteria 

Above you generated a list of all files in the directory. However, you may want to subset that list to only include:

1. `.tif` files
2. `.tif` files that contain the word "band" in them

Note that it is important that the file **ends with** .tif. So we use an asterisk at the end of the path to tell Python to only grab files that end with .tif.

`path/*.tif` will grab all files in the crop directory that end with the .tif extension. 

{:.input}
```python
glob(os.path.join(landsat_post_fire_path, "*.tif"))
```

{:.output}
{:.execute_result}



    ['cold-springs-fire/landsat_collect/LC080340322016072301T1-SC20180214145802/crop/LC08_L1TP_034032_20160723_20180131_01_T1_pixel_qa_crop.tif',
     'cold-springs-fire/landsat_collect/LC080340322016072301T1-SC20180214145802/crop/LC08_L1TP_034032_20160723_20180131_01_T1_radsat_qa_crop.tif',
     'cold-springs-fire/landsat_collect/LC080340322016072301T1-SC20180214145802/crop/LC08_L1TP_034032_20160723_20180131_01_T1_sr_aerosol_crop.tif',
     'cold-springs-fire/landsat_collect/LC080340322016072301T1-SC20180214145802/crop/LC08_L1TP_034032_20160723_20180131_01_T1_sr_band1_crop.tif',
     'cold-springs-fire/landsat_collect/LC080340322016072301T1-SC20180214145802/crop/LC08_L1TP_034032_20160723_20180131_01_T1_sr_band2_crop.tif',
     'cold-springs-fire/landsat_collect/LC080340322016072301T1-SC20180214145802/crop/LC08_L1TP_034032_20160723_20180131_01_T1_sr_band3_crop.tif',
     'cold-springs-fire/landsat_collect/LC080340322016072301T1-SC20180214145802/crop/LC08_L1TP_034032_20160723_20180131_01_T1_sr_band4_crop.tif',
     'cold-springs-fire/landsat_collect/LC080340322016072301T1-SC20180214145802/crop/LC08_L1TP_034032_20160723_20180131_01_T1_sr_band5_crop.tif',
     'cold-springs-fire/landsat_collect/LC080340322016072301T1-SC20180214145802/crop/LC08_L1TP_034032_20160723_20180131_01_T1_sr_band6_crop.tif',
     'cold-springs-fire/landsat_collect/LC080340322016072301T1-SC20180214145802/crop/LC08_L1TP_034032_20160723_20180131_01_T1_sr_band7_crop.tif']





To only grab files containing the word band AND that end with `.tif` we use `*band*.tif`.
This tells python to look for the word band anywhere before the `.tif` extension AND anywhere within the file name. You can use number ranges to JUST get the bands you need. For this exercise, we will use all of the bands. But if you were just working with RGB images, you could filter this further by specifying `*band[2-5]*.tif`. 


{:.input}
```python
# Only grab bands 2 through 5
all_landsat_post_bands = glob(os.path.join(landsat_post_fire_path,
                                           "*band[2-5]*.tif"))
all_landsat_post_bands
```

{:.output}
{:.execute_result}



    ['cold-springs-fire/landsat_collect/LC080340322016072301T1-SC20180214145802/crop/LC08_L1TP_034032_20160723_20180131_01_T1_sr_band2_crop.tif',
     'cold-springs-fire/landsat_collect/LC080340322016072301T1-SC20180214145802/crop/LC08_L1TP_034032_20160723_20180131_01_T1_sr_band3_crop.tif',
     'cold-springs-fire/landsat_collect/LC080340322016072301T1-SC20180214145802/crop/LC08_L1TP_034032_20160723_20180131_01_T1_sr_band4_crop.tif',
     'cold-springs-fire/landsat_collect/LC080340322016072301T1-SC20180214145802/crop/LC08_L1TP_034032_20160723_20180131_01_T1_sr_band5_crop.tif']





Be sure that your bands are in numerical band order starting at 
1 and ending at 7! If the data are not in order, you can use the `.sort()` 
list method to sort your list alphabetically. The data in this lesson 
are sorted properly; however, we have noticed that this sort doesn't 
happen by default on some machines. The code below will sort your list
of band paths.

{:.input}
```python
all_landsat_post_bands.sort()
all_landsat_post_bands
```

{:.output}
{:.execute_result}



    ['cold-springs-fire/landsat_collect/LC080340322016072301T1-SC20180214145802/crop/LC08_L1TP_034032_20160723_20180131_01_T1_sr_band2_crop.tif',
     'cold-springs-fire/landsat_collect/LC080340322016072301T1-SC20180214145802/crop/LC08_L1TP_034032_20160723_20180131_01_T1_sr_band3_crop.tif',
     'cold-springs-fire/landsat_collect/LC080340322016072301T1-SC20180214145802/crop/LC08_L1TP_034032_20160723_20180131_01_T1_sr_band4_crop.tif',
     'cold-springs-fire/landsat_collect/LC080340322016072301T1-SC20180214145802/crop/LC08_L1TP_034032_20160723_20180131_01_T1_sr_band5_crop.tif']





In the previous lesson, you created a small function that opened up
a single landsat band. You will expand this function to open, crop and clean
your data in this lesson.

{:.input}
```python
def open_clean_band(band_path):
    """A function that opens a Landsat band as an (rio)xarray object

    Parameters
    ----------
    band_path : list
        A list of paths to the tif files that you wish to combine.

    Returns
    -------
    An single xarray object with the Landsat band data.

    """

    return rxr.open_rasterio(band_path, masked=True).squeeze()
```

{:.input}
```python
landsat_post_xr = open_clean_band(all_landsat_post_bands[0])

# Plot the data
f, ax = plt.subplots()
landsat_post_xr.plot.imshow(cmap="Greys_r",
                            ax=ax)
ax.set_title("Plot of Band 2")
ax.set_axis_off()
plt.show()
```

{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}/images/courses/intermediate-eds-textbook/05-multi-spectral-remote-sensing-python/landsat/2020-03-02-landsat-multispectral-02-open-and-crop-all/2020-03-02-landsat-multispectral-02-open-and-crop-all_14_0.png" alt = "Plot of each individual Landsat 8 band collected by glob. This image is of the Cold Springs Fire shorly after the fire.">
<figcaption>Plot of each individual Landsat 8 band collected by glob. This image is of the Cold Springs Fire shorly after the fire.</figcaption>

</figure>




### Crop a Landsat Band Using Rioxarray `rio.clip()`

Above you opened up and plotted a single band. Often, you want to crop
your data to the spatial extent of your study area. Crop, removes data that you 
don't need in your analysis (that that is outside of your area of interest). 
You could chose to open and crop each file individually using the 
`rxr.open_rasterio()` function alongside 
the **rioxarray** `opened_xarray.rio.clip()` function as shown below.

In order to crop a band, you need to have a

1. **GeoPandas** or **shapely** object that represents the extent of the area you want to study in the Landsat image (your crop extent). 
2. The crop extent shapefile and the Landsat data **need to be in the same Coordinate Reference System, or CRS**. 

To clip an **xarray** DataFrame to a **GeoPandas** extent, you need to create the clipped dataframe with the following syntax.

```python
clipped_xarray = xarray_name.rio.clip(geopandas_object_name.geometry)
```

HINT: You can check the CRS of your Landsat data using `xarray_name.rio.crs`. 

Below you crop your stacked data using a shapefile.

{:.input}
```python
# Open up boundary extent using GeoPandas
fire_boundary_path = os.path.join("cold-springs-fire",
                                  "vector_layers",
                                  "fire-boundary-geomac",
                                  "co_cold_springs_20160711_2200_dd83.shp")

fire_boundary = gpd.read_file(fire_boundary_path)
```

{:.input}
```python
# Check the CRS of your data
with rio.open(all_landsat_post_bands[0]) as src:
    landsat_crs = src.crs

print("Landsat crs is:", landsat_crs)
print("Fire boundary crs", fire_boundary.crs)
```

{:.output}
    Landsat crs is: EPSG:32613
    Fire boundary crs epsg:4269



{:.input}
```python
# Reproject data to CRS of raster data
fire_boundary_utmz13 = fire_boundary.to_crs(landsat_crs)
fire_boundary_utmz13.plot()
plt.show()
```

{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}/images/courses/intermediate-eds-textbook/05-multi-spectral-remote-sensing-python/landsat/2020-03-02-landsat-multispectral-02-open-and-crop-all/2020-03-02-landsat-multispectral-02-open-and-crop-all_18_0.png" alt = "Plot of the fire boundary for he Cold Springs Fire. These data were in shapefile format and opened using Geopandas in Python.">
<figcaption>Plot of the fire boundary for he Cold Springs Fire. These data were in shapefile format and opened using Geopandas in Python.</figcaption>

</figure>




You can turn the CRS check into a little function to make your workflow simpler.

{:.input}
```python
def check_crs(raster_path):
    """
    Returns the CRS of a raster file.

    Parameters
    ----------
    raster_path : string
        A path to a raster file that you wish to check the crs of. Assuming
        this is a tif file.

    Returns
    -------
    A crs object

    """

    with rio.open(all_landsat_post_bands[0]) as src:
        return src.crs
```




Once the crs has been checked you can clip the data. The ideal scenario
here is that you clip the data while opening it. Below you use 
`from_disk = True` which tells rioxarray to only open the data within the 
clip extent. This will speed up your workflow a bit.


{:.input}
```python
landsat_post_xr_clip = rxr.open_rasterio(all_landsat_post_bands[0]).rio.clip(
    fire_boundary_utmz13.geometry,
    from_disk=True).squeeze()

# Notice the x and y data dimensions of your data have changed
landsat_post_xr_clip
```

{:.output}
{:.execute_result}



<div><svg style="position: absolute; width: 0; height: 0; overflow: hidden">
<defs>
<symbol id="icon-database" viewBox="0 0 32 32">
<path d="M16 0c-8.837 0-16 2.239-16 5v4c0 2.761 7.163 5 16 5s16-2.239 16-5v-4c0-2.761-7.163-5-16-5z"></path>
<path d="M16 17c-8.837 0-16-2.239-16-5v6c0 2.761 7.163 5 16 5s16-2.239 16-5v-6c0 2.761-7.163 5-16 5z"></path>
<path d="M16 26c-8.837 0-16-2.239-16-5v6c0 2.761 7.163 5 16 5s16-2.239 16-5v-6c0 2.761-7.163 5-16 5z"></path>
</symbol>
<symbol id="icon-file-text2" viewBox="0 0 32 32">
<path d="M28.681 7.159c-0.694-0.947-1.662-2.053-2.724-3.116s-2.169-2.030-3.116-2.724c-1.612-1.182-2.393-1.319-2.841-1.319h-15.5c-1.378 0-2.5 1.121-2.5 2.5v27c0 1.378 1.122 2.5 2.5 2.5h23c1.378 0 2.5-1.122 2.5-2.5v-19.5c0-0.448-0.137-1.23-1.319-2.841zM24.543 5.457c0.959 0.959 1.712 1.825 2.268 2.543h-4.811v-4.811c0.718 0.556 1.584 1.309 2.543 2.268zM28 29.5c0 0.271-0.229 0.5-0.5 0.5h-23c-0.271 0-0.5-0.229-0.5-0.5v-27c0-0.271 0.229-0.5 0.5-0.5 0 0 15.499-0 15.5 0v7c0 0.552 0.448 1 1 1h7v19.5z"></path>
<path d="M23 26h-14c-0.552 0-1-0.448-1-1s0.448-1 1-1h14c0.552 0 1 0.448 1 1s-0.448 1-1 1z"></path>
<path d="M23 22h-14c-0.552 0-1-0.448-1-1s0.448-1 1-1h14c0.552 0 1 0.448 1 1s-0.448 1-1 1z"></path>
<path d="M23 18h-14c-0.552 0-1-0.448-1-1s0.448-1 1-1h14c0.552 0 1 0.448 1 1s-0.448 1-1 1z"></path>
</symbol>
</defs>
</svg>
<style>/* CSS stylesheet for displaying xarray objects in jupyterlab.
 *
 */

:root {
  --xr-font-color0: var(--jp-content-font-color0, rgba(0, 0, 0, 1));
  --xr-font-color2: var(--jp-content-font-color2, rgba(0, 0, 0, 0.54));
  --xr-font-color3: var(--jp-content-font-color3, rgba(0, 0, 0, 0.38));
  --xr-border-color: var(--jp-border-color2, #e0e0e0);
  --xr-disabled-color: var(--jp-layout-color3, #bdbdbd);
  --xr-background-color: var(--jp-layout-color0, white);
  --xr-background-color-row-even: var(--jp-layout-color1, white);
  --xr-background-color-row-odd: var(--jp-layout-color2, #eeeeee);
}

html[theme=dark],
body.vscode-dark {
  --xr-font-color0: rgba(255, 255, 255, 1);
  --xr-font-color2: rgba(255, 255, 255, 0.54);
  --xr-font-color3: rgba(255, 255, 255, 0.38);
  --xr-border-color: #1F1F1F;
  --xr-disabled-color: #515151;
  --xr-background-color: #111111;
  --xr-background-color-row-even: #111111;
  --xr-background-color-row-odd: #313131;
}

.xr-wrap {
  display: block;
  min-width: 300px;
  max-width: 700px;
}

.xr-text-repr-fallback {
  /* fallback to plain text repr when CSS is not injected (untrusted notebook) */
  display: none;
}

.xr-header {
  padding-top: 6px;
  padding-bottom: 6px;
  margin-bottom: 4px;
  border-bottom: solid 1px var(--xr-border-color);
}

.xr-header > div,
.xr-header > ul {
  display: inline;
  margin-top: 0;
  margin-bottom: 0;
}

.xr-obj-type,
.xr-array-name {
  margin-left: 2px;
  margin-right: 10px;
}

.xr-obj-type {
  color: var(--xr-font-color2);
}

.xr-sections {
  padding-left: 0 !important;
  display: grid;
  grid-template-columns: 150px auto auto 1fr 20px 20px;
}

.xr-section-item {
  display: contents;
}

.xr-section-item input {
  display: none;
}

.xr-section-item input + label {
  color: var(--xr-disabled-color);
}

.xr-section-item input:enabled + label {
  cursor: pointer;
  color: var(--xr-font-color2);
}

.xr-section-item input:enabled + label:hover {
  color: var(--xr-font-color0);
}

.xr-section-summary {
  grid-column: 1;
  color: var(--xr-font-color2);
  font-weight: 500;
}

.xr-section-summary > span {
  display: inline-block;
  padding-left: 0.5em;
}

.xr-section-summary-in:disabled + label {
  color: var(--xr-font-color2);
}

.xr-section-summary-in + label:before {
  display: inline-block;
  content: '►';
  font-size: 11px;
  width: 15px;
  text-align: center;
}

.xr-section-summary-in:disabled + label:before {
  color: var(--xr-disabled-color);
}

.xr-section-summary-in:checked + label:before {
  content: '▼';
}

.xr-section-summary-in:checked + label > span {
  display: none;
}

.xr-section-summary,
.xr-section-inline-details {
  padding-top: 4px;
  padding-bottom: 4px;
}

.xr-section-inline-details {
  grid-column: 2 / -1;
}

.xr-section-details {
  display: none;
  grid-column: 1 / -1;
  margin-bottom: 5px;
}

.xr-section-summary-in:checked ~ .xr-section-details {
  display: contents;
}

.xr-array-wrap {
  grid-column: 1 / -1;
  display: grid;
  grid-template-columns: 20px auto;
}

.xr-array-wrap > label {
  grid-column: 1;
  vertical-align: top;
}

.xr-preview {
  color: var(--xr-font-color3);
}

.xr-array-preview,
.xr-array-data {
  padding: 0 5px !important;
  grid-column: 2;
}

.xr-array-data,
.xr-array-in:checked ~ .xr-array-preview {
  display: none;
}

.xr-array-in:checked ~ .xr-array-data,
.xr-array-preview {
  display: inline-block;
}

.xr-dim-list {
  display: inline-block !important;
  list-style: none;
  padding: 0 !important;
  margin: 0;
}

.xr-dim-list li {
  display: inline-block;
  padding: 0;
  margin: 0;
}

.xr-dim-list:before {
  content: '(';
}

.xr-dim-list:after {
  content: ')';
}

.xr-dim-list li:not(:last-child):after {
  content: ',';
  padding-right: 5px;
}

.xr-has-index {
  font-weight: bold;
}

.xr-var-list,
.xr-var-item {
  display: contents;
}

.xr-var-item > div,
.xr-var-item label,
.xr-var-item > .xr-var-name span {
  background-color: var(--xr-background-color-row-even);
  margin-bottom: 0;
}

.xr-var-item > .xr-var-name:hover span {
  padding-right: 5px;
}

.xr-var-list > li:nth-child(odd) > div,
.xr-var-list > li:nth-child(odd) > label,
.xr-var-list > li:nth-child(odd) > .xr-var-name span {
  background-color: var(--xr-background-color-row-odd);
}

.xr-var-name {
  grid-column: 1;
}

.xr-var-dims {
  grid-column: 2;
}

.xr-var-dtype {
  grid-column: 3;
  text-align: right;
  color: var(--xr-font-color2);
}

.xr-var-preview {
  grid-column: 4;
}

.xr-var-name,
.xr-var-dims,
.xr-var-dtype,
.xr-preview,
.xr-attrs dt {
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
  padding-right: 10px;
}

.xr-var-name:hover,
.xr-var-dims:hover,
.xr-var-dtype:hover,
.xr-attrs dt:hover {
  overflow: visible;
  width: auto;
  z-index: 1;
}

.xr-var-attrs,
.xr-var-data {
  display: none;
  background-color: var(--xr-background-color) !important;
  padding-bottom: 5px !important;
}

.xr-var-attrs-in:checked ~ .xr-var-attrs,
.xr-var-data-in:checked ~ .xr-var-data {
  display: block;
}

.xr-var-data > table {
  float: right;
}

.xr-var-name span,
.xr-var-data,
.xr-attrs {
  padding-left: 25px !important;
}

.xr-attrs,
.xr-var-attrs,
.xr-var-data {
  grid-column: 1 / -1;
}

dl.xr-attrs {
  padding: 0;
  margin: 0;
  display: grid;
  grid-template-columns: 125px auto;
}

.xr-attrs dt,
.xr-attrs dd {
  padding: 0;
  margin: 0;
  float: left;
  padding-right: 10px;
  width: auto;
}

.xr-attrs dt {
  font-weight: normal;
  grid-column: 1;
}

.xr-attrs dt:hover span {
  display: inline-block;
  background: var(--xr-background-color);
  padding-right: 10px;
}

.xr-attrs dd {
  grid-column: 2;
  white-space: pre-wrap;
  word-break: break-all;
}

.xr-icon-database,
.xr-icon-file-text2 {
  display: inline-block;
  vertical-align: middle;
  width: 1em;
  height: 1.5em !important;
  stroke-width: 0;
  stroke: currentColor;
  fill: currentColor;
}
</style><pre class='xr-text-repr-fallback'>&lt;xarray.DataArray (y: 44, x: 113)&gt;
array([[-32768, -32768, -32768, ..., -32768, -32768, -32768],
       [-32768, -32768, -32768, ..., -32768, -32768, -32768],
       [-32768, -32768, -32768, ..., -32768, -32768, -32768],
       ...,
       [-32768, -32768, -32768, ..., -32768, -32768, -32768],
       [-32768, -32768, -32768, ..., -32768, -32768, -32768],
       [-32768, -32768, -32768, ..., -32768, -32768, -32768]], dtype=int16)
Coordinates:
  * x            (x) float64 4.577e+05 4.577e+05 4.577e+05 ... 4.61e+05 4.61e+05
  * y            (y) float64 4.426e+06 4.426e+06 ... 4.425e+06 4.425e+06
    band         int64 1
    spatial_ref  int64 0
Attributes:
    STATISTICS_MAXIMUM:  3743
    STATISTICS_MEAN:     337.61331587892
    STATISTICS_MINIMUM:  17
    STATISTICS_STDDEV:   139.84903539903
    scale_factor:        1.0
    add_offset:          0.0
    grid_mapping:        spatial_ref
    _FillValue:          -32768</pre><div class='xr-wrap' hidden><div class='xr-header'><div class='xr-obj-type'>xarray.DataArray</div><div class='xr-array-name'></div><ul class='xr-dim-list'><li><span class='xr-has-index'>y</span>: 44</li><li><span class='xr-has-index'>x</span>: 113</li></ul></div><ul class='xr-sections'><li class='xr-section-item'><div class='xr-array-wrap'><input id='section-6c56490c-3bfb-4b95-a6e4-fb3abaac7835' class='xr-array-in' type='checkbox' checked><label for='section-6c56490c-3bfb-4b95-a6e4-fb3abaac7835' title='Show/hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-array-preview xr-preview'><span>-32768 -32768 -32768 -32768 -32768 ... -32768 -32768 -32768 -32768</span></div><div class='xr-array-data'><pre>array([[-32768, -32768, -32768, ..., -32768, -32768, -32768],
       [-32768, -32768, -32768, ..., -32768, -32768, -32768],
       [-32768, -32768, -32768, ..., -32768, -32768, -32768],
       ...,
       [-32768, -32768, -32768, ..., -32768, -32768, -32768],
       [-32768, -32768, -32768, ..., -32768, -32768, -32768],
       [-32768, -32768, -32768, ..., -32768, -32768, -32768]], dtype=int16)</pre></div></div></li><li class='xr-section-item'><input id='section-efc22a95-74fa-499c-8e5b-bc07252aeed3' class='xr-section-summary-in' type='checkbox'  checked><label for='section-efc22a95-74fa-499c-8e5b-bc07252aeed3' class='xr-section-summary' >Coordinates: <span>(4)</span></label><div class='xr-section-inline-details'></div><div class='xr-section-details'><ul class='xr-var-list'><li class='xr-var-item'><div class='xr-var-name'><span class='xr-has-index'>x</span></div><div class='xr-var-dims'>(x)</div><div class='xr-var-dtype'>float64</div><div class='xr-var-preview xr-preview'>4.577e+05 4.577e+05 ... 4.61e+05</div><input id='attrs-61406b78-b7b9-4b8f-aed9-e4f669da0580' class='xr-var-attrs-in' type='checkbox' ><label for='attrs-61406b78-b7b9-4b8f-aed9-e4f669da0580' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-65f1d67e-98c0-491e-9eae-e8459f336323' class='xr-var-data-in' type='checkbox'><label for='data-65f1d67e-98c0-491e-9eae-e8459f336323' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'><dt><span>axis :</span></dt><dd>X</dd><dt><span>long_name :</span></dt><dd>x coordinate of projection</dd><dt><span>standard_name :</span></dt><dd>projection_x_coordinate</dd><dt><span>units :</span></dt><dd>metre</dd></dl></div><div class='xr-var-data'><pre>array([457680., 457710., 457740., 457770., 457800., 457830., 457860., 457890.,
       457920., 457950., 457980., 458010., 458040., 458070., 458100., 458130.,
       458160., 458190., 458220., 458250., 458280., 458310., 458340., 458370.,
       458400., 458430., 458460., 458490., 458520., 458550., 458580., 458610.,
       458640., 458670., 458700., 458730., 458760., 458790., 458820., 458850.,
       458880., 458910., 458940., 458970., 459000., 459030., 459060., 459090.,
       459120., 459150., 459180., 459210., 459240., 459270., 459300., 459330.,
       459360., 459390., 459420., 459450., 459480., 459510., 459540., 459570.,
       459600., 459630., 459660., 459690., 459720., 459750., 459780., 459810.,
       459840., 459870., 459900., 459930., 459960., 459990., 460020., 460050.,
       460080., 460110., 460140., 460170., 460200., 460230., 460260., 460290.,
       460320., 460350., 460380., 460410., 460440., 460470., 460500., 460530.,
       460560., 460590., 460620., 460650., 460680., 460710., 460740., 460770.,
       460800., 460830., 460860., 460890., 460920., 460950., 460980., 461010.,
       461040.])</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span class='xr-has-index'>y</span></div><div class='xr-var-dims'>(y)</div><div class='xr-var-dtype'>float64</div><div class='xr-var-preview xr-preview'>4.426e+06 4.426e+06 ... 4.425e+06</div><input id='attrs-744ce59b-3b8c-4668-bd05-c9cf4e870b5a' class='xr-var-attrs-in' type='checkbox' ><label for='attrs-744ce59b-3b8c-4668-bd05-c9cf4e870b5a' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-bfbb2b38-6c52-4864-a1a7-6b7141553e74' class='xr-var-data-in' type='checkbox'><label for='data-bfbb2b38-6c52-4864-a1a7-6b7141553e74' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'><dt><span>axis :</span></dt><dd>Y</dd><dt><span>long_name :</span></dt><dd>y coordinate of projection</dd><dt><span>standard_name :</span></dt><dd>projection_y_coordinate</dd><dt><span>units :</span></dt><dd>metre</dd></dl></div><div class='xr-var-data'><pre>array([4426440., 4426410., 4426380., 4426350., 4426320., 4426290., 4426260.,
       4426230., 4426200., 4426170., 4426140., 4426110., 4426080., 4426050.,
       4426020., 4425990., 4425960., 4425930., 4425900., 4425870., 4425840.,
       4425810., 4425780., 4425750., 4425720., 4425690., 4425660., 4425630.,
       4425600., 4425570., 4425540., 4425510., 4425480., 4425450., 4425420.,
       4425390., 4425360., 4425330., 4425300., 4425270., 4425240., 4425210.,
       4425180., 4425150.])</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span>band</span></div><div class='xr-var-dims'>()</div><div class='xr-var-dtype'>int64</div><div class='xr-var-preview xr-preview'>1</div><input id='attrs-1a8896d8-7947-4184-b161-057caf1967bb' class='xr-var-attrs-in' type='checkbox' disabled><label for='attrs-1a8896d8-7947-4184-b161-057caf1967bb' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-a57ecd54-f3cd-4739-a3e3-409771401e86' class='xr-var-data-in' type='checkbox'><label for='data-a57ecd54-f3cd-4739-a3e3-409771401e86' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'></dl></div><div class='xr-var-data'><pre>array(1)</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span>spatial_ref</span></div><div class='xr-var-dims'>()</div><div class='xr-var-dtype'>int64</div><div class='xr-var-preview xr-preview'>0</div><input id='attrs-596bb5ef-0f98-49ea-be2e-e823a11eb539' class='xr-var-attrs-in' type='checkbox' ><label for='attrs-596bb5ef-0f98-49ea-be2e-e823a11eb539' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-adddf995-00ff-4a09-b970-cd59b0612d1d' class='xr-var-data-in' type='checkbox'><label for='data-adddf995-00ff-4a09-b970-cd59b0612d1d' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'><dt><span>crs_wkt :</span></dt><dd>PROJCS[&quot;WGS 84 / UTM zone 13N&quot;,GEOGCS[&quot;WGS 84&quot;,DATUM[&quot;WGS_1984&quot;,SPHEROID[&quot;WGS 84&quot;,6378137,298.257223563,AUTHORITY[&quot;EPSG&quot;,&quot;7030&quot;]],AUTHORITY[&quot;EPSG&quot;,&quot;6326&quot;]],PRIMEM[&quot;Greenwich&quot;,0,AUTHORITY[&quot;EPSG&quot;,&quot;8901&quot;]],UNIT[&quot;degree&quot;,0.0174532925199433,AUTHORITY[&quot;EPSG&quot;,&quot;9122&quot;]],AUTHORITY[&quot;EPSG&quot;,&quot;4326&quot;]],PROJECTION[&quot;Transverse_Mercator&quot;],PARAMETER[&quot;latitude_of_origin&quot;,0],PARAMETER[&quot;central_meridian&quot;,-105],PARAMETER[&quot;scale_factor&quot;,0.9996],PARAMETER[&quot;false_easting&quot;,500000],PARAMETER[&quot;false_northing&quot;,0],UNIT[&quot;metre&quot;,1,AUTHORITY[&quot;EPSG&quot;,&quot;9001&quot;]],AXIS[&quot;Easting&quot;,EAST],AXIS[&quot;Northing&quot;,NORTH],AUTHORITY[&quot;EPSG&quot;,&quot;32613&quot;]]</dd><dt><span>semi_major_axis :</span></dt><dd>6378137.0</dd><dt><span>semi_minor_axis :</span></dt><dd>6356752.314245179</dd><dt><span>inverse_flattening :</span></dt><dd>298.257223563</dd><dt><span>reference_ellipsoid_name :</span></dt><dd>WGS 84</dd><dt><span>longitude_of_prime_meridian :</span></dt><dd>0.0</dd><dt><span>prime_meridian_name :</span></dt><dd>Greenwich</dd><dt><span>geographic_crs_name :</span></dt><dd>WGS 84</dd><dt><span>horizontal_datum_name :</span></dt><dd>World Geodetic System 1984</dd><dt><span>projected_crs_name :</span></dt><dd>WGS 84 / UTM zone 13N</dd><dt><span>grid_mapping_name :</span></dt><dd>transverse_mercator</dd><dt><span>latitude_of_projection_origin :</span></dt><dd>0.0</dd><dt><span>longitude_of_central_meridian :</span></dt><dd>-105.0</dd><dt><span>false_easting :</span></dt><dd>500000.0</dd><dt><span>false_northing :</span></dt><dd>0.0</dd><dt><span>scale_factor_at_central_meridian :</span></dt><dd>0.9996</dd><dt><span>spatial_ref :</span></dt><dd>PROJCS[&quot;WGS 84 / UTM zone 13N&quot;,GEOGCS[&quot;WGS 84&quot;,DATUM[&quot;WGS_1984&quot;,SPHEROID[&quot;WGS 84&quot;,6378137,298.257223563,AUTHORITY[&quot;EPSG&quot;,&quot;7030&quot;]],AUTHORITY[&quot;EPSG&quot;,&quot;6326&quot;]],PRIMEM[&quot;Greenwich&quot;,0,AUTHORITY[&quot;EPSG&quot;,&quot;8901&quot;]],UNIT[&quot;degree&quot;,0.0174532925199433,AUTHORITY[&quot;EPSG&quot;,&quot;9122&quot;]],AUTHORITY[&quot;EPSG&quot;,&quot;4326&quot;]],PROJECTION[&quot;Transverse_Mercator&quot;],PARAMETER[&quot;latitude_of_origin&quot;,0],PARAMETER[&quot;central_meridian&quot;,-105],PARAMETER[&quot;scale_factor&quot;,0.9996],PARAMETER[&quot;false_easting&quot;,500000],PARAMETER[&quot;false_northing&quot;,0],UNIT[&quot;metre&quot;,1,AUTHORITY[&quot;EPSG&quot;,&quot;9001&quot;]],AXIS[&quot;Easting&quot;,EAST],AXIS[&quot;Northing&quot;,NORTH],AUTHORITY[&quot;EPSG&quot;,&quot;32613&quot;]]</dd><dt><span>GeoTransform :</span></dt><dd>457665.0 30.0 0.0 4426455.0 0.0 -30.0</dd></dl></div><div class='xr-var-data'><pre>array(0)</pre></div></li></ul></div></li><li class='xr-section-item'><input id='section-2e2ffca5-0627-4fb3-b5f1-5524ccb96b97' class='xr-section-summary-in' type='checkbox'  checked><label for='section-2e2ffca5-0627-4fb3-b5f1-5524ccb96b97' class='xr-section-summary' >Attributes: <span>(8)</span></label><div class='xr-section-inline-details'></div><div class='xr-section-details'><dl class='xr-attrs'><dt><span>STATISTICS_MAXIMUM :</span></dt><dd>3743</dd><dt><span>STATISTICS_MEAN :</span></dt><dd>337.61331587892</dd><dt><span>STATISTICS_MINIMUM :</span></dt><dd>17</dd><dt><span>STATISTICS_STDDEV :</span></dt><dd>139.84903539903</dd><dt><span>scale_factor :</span></dt><dd>1.0</dd><dt><span>add_offset :</span></dt><dd>0.0</dd><dt><span>grid_mapping :</span></dt><dd>spatial_ref</dd><dt><span>_FillValue :</span></dt><dd>-32768</dd></dl></div></li></ul></div></div>





Now that your data are open, you can plot it.

{:.input}
```python
# Plot the data
f, ax = plt.subplots(figsize=(10, 6))
landsat_post_xr_clip.plot.imshow(cmap="Greys_r",
                                 ax=ax)
ax.set_axis_off()
ax.set_title("Band 1 - Clipped To Your Study Area")
plt.show()
```

{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}/images/courses/intermediate-eds-textbook/05-multi-spectral-remote-sensing-python/landsat/2020-03-02-landsat-multispectral-02-open-and-crop-all/2020-03-02-landsat-multispectral-02-open-and-crop-all_27_0.png" alt = "Plot of the clipped Landsat 8 data with the missing data values rendered as black. These values  can be masked for nicer plotting.">
<figcaption>Plot of the clipped Landsat 8 data with the missing data values rendered as black. These values  can be masked for nicer plotting.</figcaption>

</figure>




The above plot has a large amount of  "black" fill around the outside representing 
fill values. When you clipped the data to the geometry, rioxarray filled all of 
the pixels outside of the geometry extent with a large negative number **-32768**.

For plotting you may wish to clean this up by masking out values.

{:.input}
```python
# Clean the data
valid_range = (0, 10000)
# Only run this step if a valid range tuple is provided
if valid_range:
    mask = ((landsat_post_xr_clip < valid_range[0]) | (
        landsat_post_xr_clip > valid_range[1]))
    landsat_post_xr_clip = landsat_post_xr_clip.where(
        ~xr.where(mask, True, False))
```

{:.input}
```python
f, ax = plt.subplots()
landsat_post_xr_clip.plot(ax=ax)
ax.set_title("Band 1 plot")
ax.set_axis_off()
plt.show()
```

{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}/images/courses/intermediate-eds-textbook/05-multi-spectral-remote-sensing-python/landsat/2020-03-02-landsat-multispectral-02-open-and-crop-all/2020-03-02-landsat-multispectral-02-open-and-crop-all_30_0.png" alt = "Plot of the clipped Landsat 8 data with the missing data values masked.">
<figcaption>Plot of the clipped Landsat 8 data with the missing data values masked.</figcaption>

</figure>




## A  Function to Crop and Clean Landsat Data

It would be nice to combine all of the steps above into a single 
workflow that clips and cleans your landsat data. You can take the 
function that you started in the previous lesson and expand it to  
do all of this for you.

{:.input}
```python
def open_clean_band(band_path, clip_extent, valid_range=None):
    """A function that opens a Landsat band as an (rio)xarray object

    Parameters
    ----------
    band_path : list
        A list of paths to the tif files that you wish to combine.

    clip_extent : geopandas geodataframe
        A geodataframe containing the clip extent of interest. NOTE: this will 
        fail if the clip extent is in a different CRS than the raster data.

    valid_range : tuple (optional)
        The min and max valid range for the data. All pixels with values outside
        of this range will be masked.

    Returns
    -------
    An single xarray object with the Landsat band data.

    """

    try:
        clip_bound = clip_extent.geometry
    except Exception as err:
        print("Oops, I need a geodataframe object for this to work.")
        print(err)

    cleaned_band = rxr.open_rasterio(band_path,
                                     masked=True).rio.clip(clip_bound,
                                                           from_disk=True).squeeze()

    # Only mask the data if a valid range tuple is provided
    if valid_range:
        mask = ((landsat_post_xr_clip < valid_range[0]) | (
            landsat_post_xr_clip > valid_range[1]))
        cleaned_band = landsat_post_xr_clip.where(
            ~xr.where(mask, True, False))

    return cleaned_band
```

{:.input}
```python
cleaned_band = open_clean_band(all_landsat_post_bands[0], fire_boundary_utmz13)

f, ax = plt.subplots()
cleaned_band.plot(ax=ax)
ax.set_title("Band 1 plot")
ax.set_axis_off()
plt.show()
```

{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}/images/courses/intermediate-eds-textbook/05-multi-spectral-remote-sensing-python/landsat/2020-03-02-landsat-multispectral-02-open-and-crop-all/2020-03-02-landsat-multispectral-02-open-and-crop-all_33_0.png" alt = "Plot of the clipped Landsat 8 data with the missing data values masked.">
<figcaption>Plot of the clipped Landsat 8 data with the missing data values masked.</figcaption>

</figure>




## Create  Your Final, Automated Workflow

Great - you now have a workflow that opens, clips and cleans a single band. 
However, remember that your original goal is to open, clip and clean several  
Landsat bands with the goal of calculating NDVI and producing some RGB and 
ColorInfrared (CIR) plots.

Below you build  out the entire workflow using a loop. The vector data step is  
reproduced here

{:.input}
```python
# Open up boundary extent using GeoPandas
fire_boundary_path = os.path.join("cold-springs-fire",
                                  "vector_layers",
                                  "fire-boundary-geomac",
                                  "co_cold_springs_20160711_2200_dd83.shp")

fire_boundary = gpd.read_file(fire_boundary_path)
```

{:.input}
```python
# Get a list of required bands - bands 2 through 5
all_landsat_post_bands = glob(os.path.join(landsat_post_fire_path,
                                           "*band[2-5]*.tif"))
all_landsat_post_bands.sort()
all_landsat_post_bands
```

{:.output}
{:.execute_result}



    ['cold-springs-fire/landsat_collect/LC080340322016072301T1-SC20180214145802/crop/LC08_L1TP_034032_20160723_20180131_01_T1_sr_band2_crop.tif',
     'cold-springs-fire/landsat_collect/LC080340322016072301T1-SC20180214145802/crop/LC08_L1TP_034032_20160723_20180131_01_T1_sr_band3_crop.tif',
     'cold-springs-fire/landsat_collect/LC080340322016072301T1-SC20180214145802/crop/LC08_L1TP_034032_20160723_20180131_01_T1_sr_band4_crop.tif',
     'cold-springs-fire/landsat_collect/LC080340322016072301T1-SC20180214145802/crop/LC08_L1TP_034032_20160723_20180131_01_T1_sr_band5_crop.tif']





{:.input}
```python
# Reproject your vector layer
landsat_crs = check_crs(all_landsat_post_bands[0])

# Reproject fire boundary for clipping
fire_boundary_utmz13 = fire_boundary.to_crs(landsat_crs)
```

Loop through each band path, open the data and add it to a list.

{:.input}
```python
post_all_bands = []
for i, aband in enumerate(all_landsat_post_bands):
    cleaned = open_clean_band(aband, fire_boundary_utmz13)
    # This line below is only needed if you wish to stack and plot your data
    cleaned["band"] = i+1
    post_all_bands.append(cleaned)
```

### Stack Your Final Cleaned Data
If you wish, you can stack all of the bands in your workflow by using the 
`xr.concat` function. Stacking the data will store all bands in one single 
xarray object. This step is optional and may be needed for some workflows
but not for others.

{:.input}
```python
# OPTIONAL - Stack the data
post_fire_stack = xr.concat(post_all_bands, dim="band")
post_fire_stack
```

{:.output}
{:.execute_result}



<div><svg style="position: absolute; width: 0; height: 0; overflow: hidden">
<defs>
<symbol id="icon-database" viewBox="0 0 32 32">
<path d="M16 0c-8.837 0-16 2.239-16 5v4c0 2.761 7.163 5 16 5s16-2.239 16-5v-4c0-2.761-7.163-5-16-5z"></path>
<path d="M16 17c-8.837 0-16-2.239-16-5v6c0 2.761 7.163 5 16 5s16-2.239 16-5v-6c0 2.761-7.163 5-16 5z"></path>
<path d="M16 26c-8.837 0-16-2.239-16-5v6c0 2.761 7.163 5 16 5s16-2.239 16-5v-6c0 2.761-7.163 5-16 5z"></path>
</symbol>
<symbol id="icon-file-text2" viewBox="0 0 32 32">
<path d="M28.681 7.159c-0.694-0.947-1.662-2.053-2.724-3.116s-2.169-2.030-3.116-2.724c-1.612-1.182-2.393-1.319-2.841-1.319h-15.5c-1.378 0-2.5 1.121-2.5 2.5v27c0 1.378 1.122 2.5 2.5 2.5h23c1.378 0 2.5-1.122 2.5-2.5v-19.5c0-0.448-0.137-1.23-1.319-2.841zM24.543 5.457c0.959 0.959 1.712 1.825 2.268 2.543h-4.811v-4.811c0.718 0.556 1.584 1.309 2.543 2.268zM28 29.5c0 0.271-0.229 0.5-0.5 0.5h-23c-0.271 0-0.5-0.229-0.5-0.5v-27c0-0.271 0.229-0.5 0.5-0.5 0 0 15.499-0 15.5 0v7c0 0.552 0.448 1 1 1h7v19.5z"></path>
<path d="M23 26h-14c-0.552 0-1-0.448-1-1s0.448-1 1-1h14c0.552 0 1 0.448 1 1s-0.448 1-1 1z"></path>
<path d="M23 22h-14c-0.552 0-1-0.448-1-1s0.448-1 1-1h14c0.552 0 1 0.448 1 1s-0.448 1-1 1z"></path>
<path d="M23 18h-14c-0.552 0-1-0.448-1-1s0.448-1 1-1h14c0.552 0 1 0.448 1 1s-0.448 1-1 1z"></path>
</symbol>
</defs>
</svg>
<style>/* CSS stylesheet for displaying xarray objects in jupyterlab.
 *
 */

:root {
  --xr-font-color0: var(--jp-content-font-color0, rgba(0, 0, 0, 1));
  --xr-font-color2: var(--jp-content-font-color2, rgba(0, 0, 0, 0.54));
  --xr-font-color3: var(--jp-content-font-color3, rgba(0, 0, 0, 0.38));
  --xr-border-color: var(--jp-border-color2, #e0e0e0);
  --xr-disabled-color: var(--jp-layout-color3, #bdbdbd);
  --xr-background-color: var(--jp-layout-color0, white);
  --xr-background-color-row-even: var(--jp-layout-color1, white);
  --xr-background-color-row-odd: var(--jp-layout-color2, #eeeeee);
}

html[theme=dark],
body.vscode-dark {
  --xr-font-color0: rgba(255, 255, 255, 1);
  --xr-font-color2: rgba(255, 255, 255, 0.54);
  --xr-font-color3: rgba(255, 255, 255, 0.38);
  --xr-border-color: #1F1F1F;
  --xr-disabled-color: #515151;
  --xr-background-color: #111111;
  --xr-background-color-row-even: #111111;
  --xr-background-color-row-odd: #313131;
}

.xr-wrap {
  display: block;
  min-width: 300px;
  max-width: 700px;
}

.xr-text-repr-fallback {
  /* fallback to plain text repr when CSS is not injected (untrusted notebook) */
  display: none;
}

.xr-header {
  padding-top: 6px;
  padding-bottom: 6px;
  margin-bottom: 4px;
  border-bottom: solid 1px var(--xr-border-color);
}

.xr-header > div,
.xr-header > ul {
  display: inline;
  margin-top: 0;
  margin-bottom: 0;
}

.xr-obj-type,
.xr-array-name {
  margin-left: 2px;
  margin-right: 10px;
}

.xr-obj-type {
  color: var(--xr-font-color2);
}

.xr-sections {
  padding-left: 0 !important;
  display: grid;
  grid-template-columns: 150px auto auto 1fr 20px 20px;
}

.xr-section-item {
  display: contents;
}

.xr-section-item input {
  display: none;
}

.xr-section-item input + label {
  color: var(--xr-disabled-color);
}

.xr-section-item input:enabled + label {
  cursor: pointer;
  color: var(--xr-font-color2);
}

.xr-section-item input:enabled + label:hover {
  color: var(--xr-font-color0);
}

.xr-section-summary {
  grid-column: 1;
  color: var(--xr-font-color2);
  font-weight: 500;
}

.xr-section-summary > span {
  display: inline-block;
  padding-left: 0.5em;
}

.xr-section-summary-in:disabled + label {
  color: var(--xr-font-color2);
}

.xr-section-summary-in + label:before {
  display: inline-block;
  content: '►';
  font-size: 11px;
  width: 15px;
  text-align: center;
}

.xr-section-summary-in:disabled + label:before {
  color: var(--xr-disabled-color);
}

.xr-section-summary-in:checked + label:before {
  content: '▼';
}

.xr-section-summary-in:checked + label > span {
  display: none;
}

.xr-section-summary,
.xr-section-inline-details {
  padding-top: 4px;
  padding-bottom: 4px;
}

.xr-section-inline-details {
  grid-column: 2 / -1;
}

.xr-section-details {
  display: none;
  grid-column: 1 / -1;
  margin-bottom: 5px;
}

.xr-section-summary-in:checked ~ .xr-section-details {
  display: contents;
}

.xr-array-wrap {
  grid-column: 1 / -1;
  display: grid;
  grid-template-columns: 20px auto;
}

.xr-array-wrap > label {
  grid-column: 1;
  vertical-align: top;
}

.xr-preview {
  color: var(--xr-font-color3);
}

.xr-array-preview,
.xr-array-data {
  padding: 0 5px !important;
  grid-column: 2;
}

.xr-array-data,
.xr-array-in:checked ~ .xr-array-preview {
  display: none;
}

.xr-array-in:checked ~ .xr-array-data,
.xr-array-preview {
  display: inline-block;
}

.xr-dim-list {
  display: inline-block !important;
  list-style: none;
  padding: 0 !important;
  margin: 0;
}

.xr-dim-list li {
  display: inline-block;
  padding: 0;
  margin: 0;
}

.xr-dim-list:before {
  content: '(';
}

.xr-dim-list:after {
  content: ')';
}

.xr-dim-list li:not(:last-child):after {
  content: ',';
  padding-right: 5px;
}

.xr-has-index {
  font-weight: bold;
}

.xr-var-list,
.xr-var-item {
  display: contents;
}

.xr-var-item > div,
.xr-var-item label,
.xr-var-item > .xr-var-name span {
  background-color: var(--xr-background-color-row-even);
  margin-bottom: 0;
}

.xr-var-item > .xr-var-name:hover span {
  padding-right: 5px;
}

.xr-var-list > li:nth-child(odd) > div,
.xr-var-list > li:nth-child(odd) > label,
.xr-var-list > li:nth-child(odd) > .xr-var-name span {
  background-color: var(--xr-background-color-row-odd);
}

.xr-var-name {
  grid-column: 1;
}

.xr-var-dims {
  grid-column: 2;
}

.xr-var-dtype {
  grid-column: 3;
  text-align: right;
  color: var(--xr-font-color2);
}

.xr-var-preview {
  grid-column: 4;
}

.xr-var-name,
.xr-var-dims,
.xr-var-dtype,
.xr-preview,
.xr-attrs dt {
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
  padding-right: 10px;
}

.xr-var-name:hover,
.xr-var-dims:hover,
.xr-var-dtype:hover,
.xr-attrs dt:hover {
  overflow: visible;
  width: auto;
  z-index: 1;
}

.xr-var-attrs,
.xr-var-data {
  display: none;
  background-color: var(--xr-background-color) !important;
  padding-bottom: 5px !important;
}

.xr-var-attrs-in:checked ~ .xr-var-attrs,
.xr-var-data-in:checked ~ .xr-var-data {
  display: block;
}

.xr-var-data > table {
  float: right;
}

.xr-var-name span,
.xr-var-data,
.xr-attrs {
  padding-left: 25px !important;
}

.xr-attrs,
.xr-var-attrs,
.xr-var-data {
  grid-column: 1 / -1;
}

dl.xr-attrs {
  padding: 0;
  margin: 0;
  display: grid;
  grid-template-columns: 125px auto;
}

.xr-attrs dt,
.xr-attrs dd {
  padding: 0;
  margin: 0;
  float: left;
  padding-right: 10px;
  width: auto;
}

.xr-attrs dt {
  font-weight: normal;
  grid-column: 1;
}

.xr-attrs dt:hover span {
  display: inline-block;
  background: var(--xr-background-color);
  padding-right: 10px;
}

.xr-attrs dd {
  grid-column: 2;
  white-space: pre-wrap;
  word-break: break-all;
}

.xr-icon-database,
.xr-icon-file-text2 {
  display: inline-block;
  vertical-align: middle;
  width: 1em;
  height: 1.5em !important;
  stroke-width: 0;
  stroke: currentColor;
  fill: currentColor;
}
</style><pre class='xr-text-repr-fallback'>&lt;xarray.DataArray (band: 4, y: 44, x: 113)&gt;
array([[[nan, nan, nan, ..., nan, nan, nan],
        [nan, nan, nan, ..., nan, nan, nan],
        [nan, nan, nan, ..., nan, nan, nan],
        ...,
        [nan, nan, nan, ..., nan, nan, nan],
        [nan, nan, nan, ..., nan, nan, nan],
        [nan, nan, nan, ..., nan, nan, nan]],

       [[nan, nan, nan, ..., nan, nan, nan],
        [nan, nan, nan, ..., nan, nan, nan],
        [nan, nan, nan, ..., nan, nan, nan],
        ...,
        [nan, nan, nan, ..., nan, nan, nan],
        [nan, nan, nan, ..., nan, nan, nan],
        [nan, nan, nan, ..., nan, nan, nan]],

       [[nan, nan, nan, ..., nan, nan, nan],
        [nan, nan, nan, ..., nan, nan, nan],
        [nan, nan, nan, ..., nan, nan, nan],
        ...,
        [nan, nan, nan, ..., nan, nan, nan],
        [nan, nan, nan, ..., nan, nan, nan],
        [nan, nan, nan, ..., nan, nan, nan]],

       [[nan, nan, nan, ..., nan, nan, nan],
        [nan, nan, nan, ..., nan, nan, nan],
        [nan, nan, nan, ..., nan, nan, nan],
        ...,
        [nan, nan, nan, ..., nan, nan, nan],
        [nan, nan, nan, ..., nan, nan, nan],
        [nan, nan, nan, ..., nan, nan, nan]]])
Coordinates:
  * x            (x) float64 4.577e+05 4.577e+05 4.577e+05 ... 4.61e+05 4.61e+05
  * y            (y) float64 4.426e+06 4.426e+06 ... 4.425e+06 4.425e+06
  * band         (band) int64 1 2 3 4
    spatial_ref  int64 0
Attributes:
    STATISTICS_MAXIMUM:  3743
    STATISTICS_MEAN:     337.61331587892
    STATISTICS_MINIMUM:  17
    STATISTICS_STDDEV:   139.84903539903
    scale_factor:        1.0
    add_offset:          0.0
    grid_mapping:        spatial_ref</pre><div class='xr-wrap' hidden><div class='xr-header'><div class='xr-obj-type'>xarray.DataArray</div><div class='xr-array-name'></div><ul class='xr-dim-list'><li><span class='xr-has-index'>band</span>: 4</li><li><span class='xr-has-index'>y</span>: 44</li><li><span class='xr-has-index'>x</span>: 113</li></ul></div><ul class='xr-sections'><li class='xr-section-item'><div class='xr-array-wrap'><input id='section-bef1c2e1-c36e-4edf-beec-504ff1c903dc' class='xr-array-in' type='checkbox' checked><label for='section-bef1c2e1-c36e-4edf-beec-504ff1c903dc' title='Show/hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-array-preview xr-preview'><span>nan nan nan nan nan nan nan nan ... nan nan nan nan nan nan nan nan</span></div><div class='xr-array-data'><pre>array([[[nan, nan, nan, ..., nan, nan, nan],
        [nan, nan, nan, ..., nan, nan, nan],
        [nan, nan, nan, ..., nan, nan, nan],
        ...,
        [nan, nan, nan, ..., nan, nan, nan],
        [nan, nan, nan, ..., nan, nan, nan],
        [nan, nan, nan, ..., nan, nan, nan]],

       [[nan, nan, nan, ..., nan, nan, nan],
        [nan, nan, nan, ..., nan, nan, nan],
        [nan, nan, nan, ..., nan, nan, nan],
        ...,
        [nan, nan, nan, ..., nan, nan, nan],
        [nan, nan, nan, ..., nan, nan, nan],
        [nan, nan, nan, ..., nan, nan, nan]],

       [[nan, nan, nan, ..., nan, nan, nan],
        [nan, nan, nan, ..., nan, nan, nan],
        [nan, nan, nan, ..., nan, nan, nan],
        ...,
        [nan, nan, nan, ..., nan, nan, nan],
        [nan, nan, nan, ..., nan, nan, nan],
        [nan, nan, nan, ..., nan, nan, nan]],

       [[nan, nan, nan, ..., nan, nan, nan],
        [nan, nan, nan, ..., nan, nan, nan],
        [nan, nan, nan, ..., nan, nan, nan],
        ...,
        [nan, nan, nan, ..., nan, nan, nan],
        [nan, nan, nan, ..., nan, nan, nan],
        [nan, nan, nan, ..., nan, nan, nan]]])</pre></div></div></li><li class='xr-section-item'><input id='section-52ab398c-8682-4581-b157-551e3f643272' class='xr-section-summary-in' type='checkbox'  checked><label for='section-52ab398c-8682-4581-b157-551e3f643272' class='xr-section-summary' >Coordinates: <span>(4)</span></label><div class='xr-section-inline-details'></div><div class='xr-section-details'><ul class='xr-var-list'><li class='xr-var-item'><div class='xr-var-name'><span class='xr-has-index'>x</span></div><div class='xr-var-dims'>(x)</div><div class='xr-var-dtype'>float64</div><div class='xr-var-preview xr-preview'>4.577e+05 4.577e+05 ... 4.61e+05</div><input id='attrs-153b2767-089f-4d03-abb7-e411636f008d' class='xr-var-attrs-in' type='checkbox' ><label for='attrs-153b2767-089f-4d03-abb7-e411636f008d' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-58164a75-ed02-4453-80b1-9eccf927c0f0' class='xr-var-data-in' type='checkbox'><label for='data-58164a75-ed02-4453-80b1-9eccf927c0f0' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'><dt><span>axis :</span></dt><dd>X</dd><dt><span>long_name :</span></dt><dd>x coordinate of projection</dd><dt><span>standard_name :</span></dt><dd>projection_x_coordinate</dd><dt><span>units :</span></dt><dd>metre</dd></dl></div><div class='xr-var-data'><pre>array([457680., 457710., 457740., 457770., 457800., 457830., 457860., 457890.,
       457920., 457950., 457980., 458010., 458040., 458070., 458100., 458130.,
       458160., 458190., 458220., 458250., 458280., 458310., 458340., 458370.,
       458400., 458430., 458460., 458490., 458520., 458550., 458580., 458610.,
       458640., 458670., 458700., 458730., 458760., 458790., 458820., 458850.,
       458880., 458910., 458940., 458970., 459000., 459030., 459060., 459090.,
       459120., 459150., 459180., 459210., 459240., 459270., 459300., 459330.,
       459360., 459390., 459420., 459450., 459480., 459510., 459540., 459570.,
       459600., 459630., 459660., 459690., 459720., 459750., 459780., 459810.,
       459840., 459870., 459900., 459930., 459960., 459990., 460020., 460050.,
       460080., 460110., 460140., 460170., 460200., 460230., 460260., 460290.,
       460320., 460350., 460380., 460410., 460440., 460470., 460500., 460530.,
       460560., 460590., 460620., 460650., 460680., 460710., 460740., 460770.,
       460800., 460830., 460860., 460890., 460920., 460950., 460980., 461010.,
       461040.])</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span class='xr-has-index'>y</span></div><div class='xr-var-dims'>(y)</div><div class='xr-var-dtype'>float64</div><div class='xr-var-preview xr-preview'>4.426e+06 4.426e+06 ... 4.425e+06</div><input id='attrs-afb83d9f-8512-4814-882f-f7bffa529953' class='xr-var-attrs-in' type='checkbox' ><label for='attrs-afb83d9f-8512-4814-882f-f7bffa529953' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-c63eaa73-3857-4750-adb0-5baf33ddfb63' class='xr-var-data-in' type='checkbox'><label for='data-c63eaa73-3857-4750-adb0-5baf33ddfb63' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'><dt><span>axis :</span></dt><dd>Y</dd><dt><span>long_name :</span></dt><dd>y coordinate of projection</dd><dt><span>standard_name :</span></dt><dd>projection_y_coordinate</dd><dt><span>units :</span></dt><dd>metre</dd></dl></div><div class='xr-var-data'><pre>array([4426440., 4426410., 4426380., 4426350., 4426320., 4426290., 4426260.,
       4426230., 4426200., 4426170., 4426140., 4426110., 4426080., 4426050.,
       4426020., 4425990., 4425960., 4425930., 4425900., 4425870., 4425840.,
       4425810., 4425780., 4425750., 4425720., 4425690., 4425660., 4425630.,
       4425600., 4425570., 4425540., 4425510., 4425480., 4425450., 4425420.,
       4425390., 4425360., 4425330., 4425300., 4425270., 4425240., 4425210.,
       4425180., 4425150.])</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span class='xr-has-index'>band</span></div><div class='xr-var-dims'>(band)</div><div class='xr-var-dtype'>int64</div><div class='xr-var-preview xr-preview'>1 2 3 4</div><input id='attrs-aede2c5d-b39c-4b57-8d55-eb6cbeded9ba' class='xr-var-attrs-in' type='checkbox' disabled><label for='attrs-aede2c5d-b39c-4b57-8d55-eb6cbeded9ba' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-441ea8d5-c03c-4e10-94ff-65065d6ca79e' class='xr-var-data-in' type='checkbox'><label for='data-441ea8d5-c03c-4e10-94ff-65065d6ca79e' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'></dl></div><div class='xr-var-data'><pre>array([1, 2, 3, 4])</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span>spatial_ref</span></div><div class='xr-var-dims'>()</div><div class='xr-var-dtype'>int64</div><div class='xr-var-preview xr-preview'>0</div><input id='attrs-ea5d1526-5ec2-4748-a510-65a7d722c1df' class='xr-var-attrs-in' type='checkbox' ><label for='attrs-ea5d1526-5ec2-4748-a510-65a7d722c1df' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-fe7374d9-d151-4d39-9a31-cb27c22cc4d1' class='xr-var-data-in' type='checkbox'><label for='data-fe7374d9-d151-4d39-9a31-cb27c22cc4d1' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'><dt><span>crs_wkt :</span></dt><dd>PROJCS[&quot;WGS 84 / UTM zone 13N&quot;,GEOGCS[&quot;WGS 84&quot;,DATUM[&quot;WGS_1984&quot;,SPHEROID[&quot;WGS 84&quot;,6378137,298.257223563,AUTHORITY[&quot;EPSG&quot;,&quot;7030&quot;]],AUTHORITY[&quot;EPSG&quot;,&quot;6326&quot;]],PRIMEM[&quot;Greenwich&quot;,0,AUTHORITY[&quot;EPSG&quot;,&quot;8901&quot;]],UNIT[&quot;degree&quot;,0.0174532925199433,AUTHORITY[&quot;EPSG&quot;,&quot;9122&quot;]],AUTHORITY[&quot;EPSG&quot;,&quot;4326&quot;]],PROJECTION[&quot;Transverse_Mercator&quot;],PARAMETER[&quot;latitude_of_origin&quot;,0],PARAMETER[&quot;central_meridian&quot;,-105],PARAMETER[&quot;scale_factor&quot;,0.9996],PARAMETER[&quot;false_easting&quot;,500000],PARAMETER[&quot;false_northing&quot;,0],UNIT[&quot;metre&quot;,1,AUTHORITY[&quot;EPSG&quot;,&quot;9001&quot;]],AXIS[&quot;Easting&quot;,EAST],AXIS[&quot;Northing&quot;,NORTH],AUTHORITY[&quot;EPSG&quot;,&quot;32613&quot;]]</dd><dt><span>semi_major_axis :</span></dt><dd>6378137.0</dd><dt><span>semi_minor_axis :</span></dt><dd>6356752.314245179</dd><dt><span>inverse_flattening :</span></dt><dd>298.257223563</dd><dt><span>reference_ellipsoid_name :</span></dt><dd>WGS 84</dd><dt><span>longitude_of_prime_meridian :</span></dt><dd>0.0</dd><dt><span>prime_meridian_name :</span></dt><dd>Greenwich</dd><dt><span>geographic_crs_name :</span></dt><dd>WGS 84</dd><dt><span>horizontal_datum_name :</span></dt><dd>World Geodetic System 1984</dd><dt><span>projected_crs_name :</span></dt><dd>WGS 84 / UTM zone 13N</dd><dt><span>grid_mapping_name :</span></dt><dd>transverse_mercator</dd><dt><span>latitude_of_projection_origin :</span></dt><dd>0.0</dd><dt><span>longitude_of_central_meridian :</span></dt><dd>-105.0</dd><dt><span>false_easting :</span></dt><dd>500000.0</dd><dt><span>false_northing :</span></dt><dd>0.0</dd><dt><span>scale_factor_at_central_meridian :</span></dt><dd>0.9996</dd><dt><span>spatial_ref :</span></dt><dd>PROJCS[&quot;WGS 84 / UTM zone 13N&quot;,GEOGCS[&quot;WGS 84&quot;,DATUM[&quot;WGS_1984&quot;,SPHEROID[&quot;WGS 84&quot;,6378137,298.257223563,AUTHORITY[&quot;EPSG&quot;,&quot;7030&quot;]],AUTHORITY[&quot;EPSG&quot;,&quot;6326&quot;]],PRIMEM[&quot;Greenwich&quot;,0,AUTHORITY[&quot;EPSG&quot;,&quot;8901&quot;]],UNIT[&quot;degree&quot;,0.0174532925199433,AUTHORITY[&quot;EPSG&quot;,&quot;9122&quot;]],AUTHORITY[&quot;EPSG&quot;,&quot;4326&quot;]],PROJECTION[&quot;Transverse_Mercator&quot;],PARAMETER[&quot;latitude_of_origin&quot;,0],PARAMETER[&quot;central_meridian&quot;,-105],PARAMETER[&quot;scale_factor&quot;,0.9996],PARAMETER[&quot;false_easting&quot;,500000],PARAMETER[&quot;false_northing&quot;,0],UNIT[&quot;metre&quot;,1,AUTHORITY[&quot;EPSG&quot;,&quot;9001&quot;]],AXIS[&quot;Easting&quot;,EAST],AXIS[&quot;Northing&quot;,NORTH],AUTHORITY[&quot;EPSG&quot;,&quot;32613&quot;]]</dd><dt><span>GeoTransform :</span></dt><dd>457665.0 30.0 0.0 4426455.0 0.0 -30.0</dd></dl></div><div class='xr-var-data'><pre>array(0)</pre></div></li></ul></div></li><li class='xr-section-item'><input id='section-ea74db8d-c923-440a-9c23-e3eea360eb4f' class='xr-section-summary-in' type='checkbox'  checked><label for='section-ea74db8d-c923-440a-9c23-e3eea360eb4f' class='xr-section-summary' >Attributes: <span>(7)</span></label><div class='xr-section-inline-details'></div><div class='xr-section-details'><dl class='xr-attrs'><dt><span>STATISTICS_MAXIMUM :</span></dt><dd>3743</dd><dt><span>STATISTICS_MEAN :</span></dt><dd>337.61331587892</dd><dt><span>STATISTICS_MINIMUM :</span></dt><dd>17</dd><dt><span>STATISTICS_STDDEV :</span></dt><dd>139.84903539903</dd><dt><span>scale_factor :</span></dt><dd>1.0</dd><dt><span>add_offset :</span></dt><dd>0.0</dd><dt><span>grid_mapping :</span></dt><dd>spatial_ref</dd></dl></div></li></ul></div></div>





{:.input}
```python
# Plot the final stacked data
post_fire_stack.plot.imshow(col="band",
                            col_wrap=2,
                            cmap="Greys_r")
plt.show()
```

{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}/images/courses/intermediate-eds-textbook/05-multi-spectral-remote-sensing-python/landsat/2020-03-02-landsat-multispectral-02-open-and-crop-all/2020-03-02-landsat-multispectral-02-open-and-crop-all_42_0.png" alt = "Plot of all clipped Landsat 8 bands with the missing data values masked. This plot uses xarray plotting.">
<figcaption>Plot of all clipped Landsat 8 bands with the missing data values masked. This plot uses xarray plotting.</figcaption>

</figure>




### Plot Data Using EarthPy

To save some code, you can plot with `earthpy` instead. `Earthpy` 
will clean up your plot for you a bit, saving the steps of cleaning up axes
and adding titles.

{:.input}
```python
# Plot using earthpy
band_titles = ["Blue",
               "Green",
               "Red",
               "NIR"]

ep.plot_bands(post_fire_stack,
              figsize=(11, 6),
              cols=2,
              title=band_titles,
              cbar=False)
plt.show()
```

{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}/images/courses/intermediate-eds-textbook/05-multi-spectral-remote-sensing-python/landsat/2020-03-02-landsat-multispectral-02-open-and-crop-all/2020-03-02-landsat-multispectral-02-open-and-crop-all_44_0.png" alt = "Plot of all clipped Landsat 8 bands with the missing data values masked. This plot uses earthpy.plot_bands.">
<figcaption>Plot of all clipped Landsat 8 bands with the missing data values masked. This plot uses earthpy.plot_bands.</figcaption>

</figure>




### Create an RGB Plot of Your Landsat Raster Data

If you want to plot your data as a color composit RGB map, you can use earthpy's
`plot_rgb()` function. For this to work, you will need to:

1. Mask `nan` values from your data - these are the values that you cleaned above. 
2. Apply the mask to your xarray object using `ma.masked_array`.

You can create a mask of where `nan` values are with `np.isnan(array_name)`, and apply it with `ma.masked_array(original_array, numpy_mask)`.

{:.input}
```python
# Create nan mask
mask_nan = np.isnan(post_fire_stack)

# Apply nan mask to cropped data - this turns your data into a numpy array
landsat_post_arr_masked = ma.masked_array(post_fire_stack,
                                          mask=mask_nan)

# Plot masked array
ep.plot_rgb(landsat_post_arr_masked,
            rgb=[2, 1, 0],
            title="CIR Image Landsat Post Fire")

plt.show()
```

{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}/images/courses/intermediate-eds-textbook/05-multi-spectral-remote-sensing-python/landsat/2020-03-02-landsat-multispectral-02-open-and-crop-all/2020-03-02-landsat-multispectral-02-open-and-crop-all_46_0.png" alt = "True color plot of the landsat imagery cropped to the Cold Springs Fire boundary.">
<figcaption>True color plot of the landsat imagery cropped to the Cold Springs Fire boundary.</figcaption>

</figure>






{:.input}
```python
def process_bands(paths, crop_layer, stack=False):
    """
    Open, clean and crop a list of raster files using rioxarray.

    Parameters
    ----------
    paths : list
        A list of paths to raster files that could be stacked (of the same 
        resolution, crs and spatial extent).
    
    crop_layer : geodataframe
        A geodataframe containing the crop geometry that you wish to crop your
        data to.
        
    stack : boolean
        If True, return a stacked xarray object. If false will return a list
        of xarray objects.

    Returns
    -------
        Either a list of xarray objects or a stacked xarray object
    """

    all_bands = []
    for i, aband in enumerate(paths):
        cleaned = open_clean_band(aband, crop_layer)
        cleaned["band"] = i+1
        all_bands.append(cleaned)

    if stack:
        print("I'm stacking your data now.")
        return xr.concat(all_bands, dim="band")
    else:
        print("Returning a list of xarray objects.")
        return all_bands
        
```



{:.input}
```python
# Open up boundary extent using GeoPandas
fire_boundary_path = os.path.join("cold-springs-fire",
                                  "vector_layers",
                                  "fire-boundary-geomac",
                                  "co_cold_springs_20160711_2200_dd83.shp")

fire_boundary = gpd.read_file(fire_boundary_path)

# Get a list of required bands - bands 2 through 5
all_landsat_post_bands = glob(os.path.join(landsat_post_fire_path,
                                           "*band[2-5]*.tif"))
all_landsat_post_bands.sort()

# Get CRS of landsat data and reproject fire boundary
landsat_crs = check_crs(all_landsat_post_bands[0])
fire_boundary_utmz13 = fire_boundary.to_crs(landsat_crs)
```

{:.input}
```python
# Process all bands
post_fire_stack = process_bands(all_landsat_post_bands, 
                                fire_boundary_utmz13, 
                                stack=True)
post_fire_stack.shape
```

{:.output}
    I'm stacking your data now.



{:.output}
{:.execute_result}



    (4, 44, 113)





{:.input}
```python
# Plot using earthpy
band_titles = ["Blue Band",
               "Green Band",
               "Red Band",
               "NIR Band"]

# Plot the final data
ep.plot_bands(post_fire_stack,
             cols=2,
             figsize=(10,5))
plt.suptitle("Cleaned and Cropped Landsat Bands")
plt.show()
```

{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}/images/courses/intermediate-eds-textbook/05-multi-spectral-remote-sensing-python/landsat/2020-03-02-landsat-multispectral-02-open-and-crop-all/2020-03-02-landsat-multispectral-02-open-and-crop-all_52_0.png" alt = "Plot of all clipped Landsat 8 bands with the missing data values masked. This plot uses earthpy.plot_bands.">
<figcaption>Plot of all clipped Landsat 8 bands with the missing data values masked. This plot uses earthpy.plot_bands.</figcaption>

</figure>




{:.output}
{:.display_data}

    <Figure size 432x288 with 0 Axes>







