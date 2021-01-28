---
layout: single
title: "Work with Landsat Remote Sensing Data in Python"
excerpt: "Landsat 8 data are downloaded in tif file format. Learn how to open and manipulate Landsat 8 data in Python. Also learn how to create RGB and color infrared Landsat image composites."
authors: ['Leah Wasser']
dateCreated: 2018-04-14
modified: 2021-01-28
category: [courses]
class-lesson: ['multispectral-remote-sensing-data-python-landsat']
permalink: /courses/use-data-open-source-python/multispectral-remote-sensing/landsat-in-Python/
nav-title: 'About Landsat Data'
module-title: 'Learn How to Work With Landsat Multispectral Remote Sensing Data in Python'
module-description: 'Learn how to work with Landsat multi-band raster data stored in .tif format in Python using rioxarray'
module-nav-title: 'Landsat Data'
module-type: 'class'
week: 5
chapter: 9
class-order: 3
course: "intermediate-earth-data-science-textbook"
sidebar:
  nav:
author_profile: false
comments: true
order: 1
topics:
  remote-sensing: ['landsat']
  reproducible-science-and-programming: ['python']
  spatial-data-and-gis: ['raster-data']
redirect_from:
  - "/courses/earth-analytics-python/multispectral-remote-sensing-in-python/landsat-bands-geotif-in-Python/"
---

{% include toc title="In This Chapter" icon="file-text" %}

<div class='notice--success' markdown="1">

## <i class="fa fa-ship" aria-hidden="true"></i> Chapter Nine - Landsat Data in Open Source Python

In this chapter, you will learn how to work with Landsat multi-band raster data stored in `.tif` format in **Python** using **rioxarray**.

## <i class="fa fa-graduation-cap" aria-hidden="true"></i> Learning Objectives

After completing this chapter, you will be able to:

* Use `glob()` to create a subsetted list of file names within a specified directory on your computer.
* Create a raster stack from a list of `.tif` files in **Python**.
* Crop rasters to a desired extent in **Python**.
* Plot various band combinations using a numpy array in **Python**.

## <i class="fa fa-check-square-o fa-2" aria-hidden="true"></i> What You Need

You will need a computer with internet access to complete this lesson and the Cold Springs Fire data.

{% include /data_subsets/course_earth_analytics/_data-cold-springs-fire.md %}

</div>


In the <a href="http://localhost:4000/courses/use-data-open-source-python/multispectral-remote-sensing/intro-naip/" target="_blank">NAIP data chapter in this textbook,</a> you learned how to 
import a multi-band image into **Python** using
**rioxarray**. You then plotted the data as a composite, 
RGB (and CIR) image using `imshow()` and calculated NDVI. 

In that case, all bands of the data were stored in a single `.tif` file. 
However, sometimes data are downloaded in individual bands rather than a single file.

In this chapter, you will learn how to work with Landsat data in **Python**. 
Each band in a landsat scene is often stored in an individual `.tif` file. 
Thus you will need to grab the bands that you want to work with and then bring 
them into a `xarrray` DataFrame. 


## About Landsat Data

> At over 40 years, the Landsat series of satellites provides the longest temporal record of moderate resolution multispectral data of the Earth’s surface on a global basis. The Landsat record has remained remarkably unbroken, proving a unique resource to assist a broad range of specialists in managing the world’s food, water, forests, and other natural resources for a growing world population.  It is a record unmatched in quality, detail, coverage, and value. Source: <a href="https://www.usgs.gov/land-resources/nli/landsat/about?qt-science_support_page_related_con=2#qt-science_support_page_related_con" target="_blank">USGS</a>


<figure>
    <a href="{{ site.url }}/images/earth-analytics/remote-sensing/timeline-only-for-webRGB.png">
    <img src="{{ site.url }}/images/earth-analytics/remote-sensing/timeline-only-for-webRGB.png" alt="Landsat 40 year timeline source: USGS.">
    </a>
    <figcaption>The 40 year history of landsat missions. Source: USGS - <a href="https://www.usgs.gov/land-resources/nli/landsat/landsat-satellite-missions?qt-science_support_page_related_con=2#qt-science_support_page_related_con" target = "_blank">USGS Landsat Timeline</a>
    </figcaption>
</figure>

Landsat data are spectral and collected using a platform mounted on a satellite in space that orbits the earth. The spectral bands
and associated spatial resolution of the first 9 bands in the Landsat 8 sensor
are listed below.

#### Landsat 8 Bands

| Band | Wavelength range (nanometers) | Spatial Resolution (m) | Spectral Width (nm)| Units | Data Type | Fill Value (no data) |  Range |Valid Range | Scale Factor |
|-------------------------------------|------------------|--------------------|----------------|----------------|----------------|----------------|---------------------| ----------------|----------------|
| Band 1 - Coastal aerosol | 430 - 450 | 30 | 2.0 | Reflectance | 16-bit signed integer (int16) | -9999 | -2000 to 16000 |0 to 10000 | 0.0001 |
| Band 2 - Blue | 450 - 510 | 30 | 6.0 |  Reflectance | 16-bit signed integer (int16) | -9999 | -2000 to 16000 |0 to 10000 | 0.0001 |
| Band 3 - Green | 530 - 590 | 30 | 6.0 |  Reflectance | 16-bit signed integer (int16) | -9999 | -2000 to 16000 |0 to 10000 | 0.0001 |
| Band 4 - Red | 640 - 670 | 30 | 0.03 |  Reflectance | 16-bit signed integer (int16) | -9999 | -2000 to 16000 |0 to 10000 | 0.0001 |
| Band 5 - Near Infrared (NIR) | 850 - 880 | 30 | 3.0 |  Reflectance | 16-bit signed integer (int16) | -9999 | -2000 to 16000 |0 to 10000 | 0.0001 |
| Band 6 - SWIR 1 | 1570 - 1650 | 30 | 8.0  |  Reflectance | 16-bit signed integer (int16) | -9999 | -2000 to 16000 |0 to 10000 | 0.0001 |
| Band 7 - SWIR 2 | 2110 - 2290 | 30 | 18 |  Reflectance | 16-bit signed integer (int16) | -9999 | -2000 to 16000 |0 to 10000 | 0.0001 |

Review the <a href="https://prd-wret.s3.us-west-2.amazonaws.com/assets/palladium/production/atoms/files/LSDS-1368_L8_SurfaceReflectanceCode-LASRC_ProductGuide-v2.pdf" target="_blank">Landsat 8 Surface Reflectance Product Guide</a> for more details.

There are additional collected bands that are not distributed within the Landsat 8 Surface Reflectance Product such as the panchromatic band, which provides a finer resolution, gray scale image of the landscape, and the cirrus cloud band, which is used in the quality assessment process:


| Band | Wavelength range (nanometers) | Spatial Resolution (m) | Spectral Width (nm)|
|-------------------------------------|------------------|--------------------|----------------|
| Band 8 - Panchromatic | 500 - 680 | 15 | 18 |  
| Band 9 - Cirrus | 1360 - 1380 | 30 | 2.0 |  


### Understand Landsat Data

When working with landsat, it is important to understand both the metadata and
the file naming convention. The metadata tell you how the data were processed,
where the data are from and how they are structured.

The file names, tell you what sensor collected the data, the date the data were collected, and more.

<figure>
    <a href="{{ site.url }}/images/earth-analytics/remote-sensing/collection-filename-diffs.png">
    <img src="{{ site.url }}/images/earth-analytics/remote-sensing/collection-filename-diffs.png" alt="landsat file naming convention">
    </a>
    <figcaption>Landsat file names Source: USGS Landsat - <a href="https://www.usgs.gov/faqs/what-naming-convention-landsat-collections-level-1-scenes?qt-news_science_products=0#qt-news_science_products" target = "_blank">Landsat Scene Naming Conventions</a>
    </figcaption>
</figure>

### Landsat File Naming Convention

Landsat and many other satellite remote sensing data is named in a way that tells you a about:

* When the data were collected and processed
* What sensor was used to collect the data
* What satellite was used to collect the data.

And more. 

Here you will learn a few key components of the landsat 8 collection file name. The first scene that you work with below is named:

`LC080340322016072301T1-SC20180214145802`

First, we have LC08

* **L:** Landsat Sensor
* **C:** OLI / TIRS combined platform
* **08:** Landsat 8 (not 7)

* **034032:** The next 6 digits represent the path and row of the scene. This identifies the spatial coverage of the scene

Finally, you have a date. In your case as follows:

* **20160723:** representing the year, month and day that the data were collected.

The second part of the file name above tells you more about when the data were last processed. You can read more about this naming convention using the link below.

<a href="https://www.usgs.gov/faqs/what-naming-convention-landsat-collections-level-1-scenes?qt-news_science_products=0#qt-news_science_products" target="_blank">Learn more about Landsat 8 file naming conventions.</a>

As you work with these data, it is good to double check that you are working with the sensor (Landsat 8) and the time period that you intend. Having this information in the file name makes it easier to keep track of this as you process your data. 

{:.input}
```python
import os
from glob import glob

import matplotlib.pyplot as plt
import numpy as np
import geopandas as gpd
import xarray as xr
import rioxarray as rxr
import earthpy as et
import earthpy.spatial as es
import earthpy.plot as ep

# Download data and set working directory
data = et.data.get_data("cold-springs-fire")
os.chdir(os.path.join(et.io.HOME, 
                      "earth-analytics", 
                      "data"))
```

{:.input}
```python
# Get list of all pre-cropped data and sort the data

# Create the path to your data
landsat_post_fire_path = os.path.join("cold-springs-fire",
                                      "landsat_collect",
                                      "LC080340322016072301T1-SC20180214145802",
                                      "crop")

# Generate a list of jtif files
post_fire_tifs_list = glob(os.path.join(landsat_post_fire_path,
                                        "*band*.tif"))

# Sort the data to ensure bands are in the correct order
post_fire_tifs_list.sort()
post_fire_tifs_list
```

{:.output}
{:.execute_result}



    ['cold-springs-fire/landsat_collect/LC080340322016072301T1-SC20180214145802/crop/LC08_L1TP_034032_20160723_20180131_01_T1_sr_band1_crop.tif',
     'cold-springs-fire/landsat_collect/LC080340322016072301T1-SC20180214145802/crop/LC08_L1TP_034032_20160723_20180131_01_T1_sr_band2_crop.tif',
     'cold-springs-fire/landsat_collect/LC080340322016072301T1-SC20180214145802/crop/LC08_L1TP_034032_20160723_20180131_01_T1_sr_band3_crop.tif',
     'cold-springs-fire/landsat_collect/LC080340322016072301T1-SC20180214145802/crop/LC08_L1TP_034032_20160723_20180131_01_T1_sr_band4_crop.tif',
     'cold-springs-fire/landsat_collect/LC080340322016072301T1-SC20180214145802/crop/LC08_L1TP_034032_20160723_20180131_01_T1_sr_band5_crop.tif',
     'cold-springs-fire/landsat_collect/LC080340322016072301T1-SC20180214145802/crop/LC08_L1TP_034032_20160723_20180131_01_T1_sr_band6_crop.tif',
     'cold-springs-fire/landsat_collect/LC080340322016072301T1-SC20180214145802/crop/LC08_L1TP_034032_20160723_20180131_01_T1_sr_band7_crop.tif']






{:.input}
```python
# Create an output array of all the landsat data stacked
landsat_post_fire_path = os.path.join("cold-springs-fire",
                                      "outputs",
                                      "landsat_post_fire.tif")
```

Below is a function to open and concatenate or combine a list of 
tif files into a final xarray object. The function will be 
explained in more detail in the following lessons.
    

{:.input}
```python
def combine_tifs(tif_list):
    """A function that combines a list of tifs in the same CRS
    and of the same extent into an xarray object

    Parameters
    ----------
    tif_list : list
        A list of paths to the tif files that you wish to combine.
        
    Returns
    -------
    An xarray object with all of the tif files in the listmerged into 
    a single object.

    """

    out_xr=[]
    for i, tif_path in enumerate(tif_list):
        out_xr.append(rxr.open_rasterio(tif_path, masked=True).squeeze())
        out_xr[i]["band"]=i+1
     
    return xr.concat(out_xr, dim="band") 
```

{:.input}
```python
# Open all bands
landsat_post_fire_xr = combine_tifs(post_fire_tifs_list)
landsat_post_fire_xr
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

.xr-attrs dt, dd {
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
</style><pre class='xr-text-repr-fallback'>&lt;xarray.DataArray (band: 7, y: 177, x: 246)&gt;
array([[[ 446.,  476.,  487., ...,  162.,  220.,  260.],
        [ 393.,  457.,  488., ...,  200.,  235.,  296.],
        [ 364.,  393.,  388., ...,  246.,  298.,  347.],
        ...,
        [ 249.,  283.,  363., ...,  272.,  268.,  284.],
        [ 541.,  474.,  364., ...,  260.,  269.,  285.],
        [ 219.,  177.,  250., ...,  271.,  271.,  286.]],

       [[ 515.,  547.,  572., ...,  181.,  233.,  261.],
        [ 440.,  519.,  571., ...,  211.,  251.,  322.],
        [ 411.,  460.,  449., ...,  264.,  326.,  387.],
        ...,
        [ 387.,  326.,  427., ...,  288.,  278.,  301.],
        [ 554.,  654.,  433., ...,  276.,  276.,  293.],
        [ 291.,  174.,  291., ...,  292.,  290.,  304.]],

       [[ 782.,  772.,  843., ...,  335.,  390.,  411.],
        [ 684.,  771.,  836., ...,  363.,  412.,  511.],
        [ 656.,  725.,  706., ...,  425.,  518.,  599.],
        ...,
...
        ...,
        [1900., 1917., 2076., ..., 1722., 1891., 1890.],
        [1779., 1893., 1983., ..., 1645., 1847., 2090.],
        [1553., 1440., 1587., ..., 1562., 1689., 1964.]],

       [[2864., 2974., 3108., ...,  983., 1195., 1271.],
        [2527., 2827., 3008., ..., 1132., 1293., 1546.],
        [2141., 2427., 2433., ..., 1324., 1652., 1922.],
        ...,
        [1662., 1757., 1922., ..., 1463., 1472., 1519.],
        [1786., 1532., 1554., ..., 1374., 1423., 1450.],
        [1071.,  943.,  975., ..., 1524., 1461., 1518.]],

       [[1920., 1979., 2098., ...,  537.,  660.,  687.],
        [1505., 1863., 1975., ...,  651.,  747.,  924.],
        [1240., 1407., 1391., ...,  769., 1018., 1189.],
        ...,
        [1216., 1190., 1398., ...,  877.,  890.,  928.],
        [1517., 1184., 1078., ...,  846.,  810.,  820.],
        [ 660.,  593.,  623., ...,  984.,  909.,  880.]]])
Coordinates:
  * band         (band) int64 1 2 3 4 5 6 7
  * y            (y) float64 4.428e+06 4.428e+06 ... 4.423e+06 4.423e+06
  * x            (x) float64 4.557e+05 4.557e+05 4.557e+05 ... 4.63e+05 4.63e+05
    spatial_ref  int64 0
Attributes:
    STATISTICS_MAXIMUM:  3483
    STATISTICS_MEAN:     297.16466859584
    STATISTICS_MINIMUM:  -57
    STATISTICS_STDDEV:   119.61507774931
    scale_factor:        1.0
    add_offset:          0.0
    grid_mapping:        spatial_ref</pre><div class='xr-wrap' hidden><div class='xr-header'><div class='xr-obj-type'>xarray.DataArray</div><div class='xr-array-name'></div><ul class='xr-dim-list'><li><span class='xr-has-index'>band</span>: 7</li><li><span class='xr-has-index'>y</span>: 177</li><li><span class='xr-has-index'>x</span>: 246</li></ul></div><ul class='xr-sections'><li class='xr-section-item'><div class='xr-array-wrap'><input id='section-e950d9aa-77ee-4a7c-9a16-be3c51bab9fc' class='xr-array-in' type='checkbox' checked><label for='section-e950d9aa-77ee-4a7c-9a16-be3c51bab9fc' title='Show/hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-array-preview xr-preview'><span>446.0 476.0 487.0 499.0 494.0 507.0 ... 565.0 787.0 984.0 909.0 880.0</span></div><div class='xr-array-data'><pre>array([[[ 446.,  476.,  487., ...,  162.,  220.,  260.],
        [ 393.,  457.,  488., ...,  200.,  235.,  296.],
        [ 364.,  393.,  388., ...,  246.,  298.,  347.],
        ...,
        [ 249.,  283.,  363., ...,  272.,  268.,  284.],
        [ 541.,  474.,  364., ...,  260.,  269.,  285.],
        [ 219.,  177.,  250., ...,  271.,  271.,  286.]],

       [[ 515.,  547.,  572., ...,  181.,  233.,  261.],
        [ 440.,  519.,  571., ...,  211.,  251.,  322.],
        [ 411.,  460.,  449., ...,  264.,  326.,  387.],
        ...,
        [ 387.,  326.,  427., ...,  288.,  278.,  301.],
        [ 554.,  654.,  433., ...,  276.,  276.,  293.],
        [ 291.,  174.,  291., ...,  292.,  290.,  304.]],

       [[ 782.,  772.,  843., ...,  335.,  390.,  411.],
        [ 684.,  771.,  836., ...,  363.,  412.,  511.],
        [ 656.,  725.,  706., ...,  425.,  518.,  599.],
        ...,
...
        ...,
        [1900., 1917., 2076., ..., 1722., 1891., 1890.],
        [1779., 1893., 1983., ..., 1645., 1847., 2090.],
        [1553., 1440., 1587., ..., 1562., 1689., 1964.]],

       [[2864., 2974., 3108., ...,  983., 1195., 1271.],
        [2527., 2827., 3008., ..., 1132., 1293., 1546.],
        [2141., 2427., 2433., ..., 1324., 1652., 1922.],
        ...,
        [1662., 1757., 1922., ..., 1463., 1472., 1519.],
        [1786., 1532., 1554., ..., 1374., 1423., 1450.],
        [1071.,  943.,  975., ..., 1524., 1461., 1518.]],

       [[1920., 1979., 2098., ...,  537.,  660.,  687.],
        [1505., 1863., 1975., ...,  651.,  747.,  924.],
        [1240., 1407., 1391., ...,  769., 1018., 1189.],
        ...,
        [1216., 1190., 1398., ...,  877.,  890.,  928.],
        [1517., 1184., 1078., ...,  846.,  810.,  820.],
        [ 660.,  593.,  623., ...,  984.,  909.,  880.]]])</pre></div></div></li><li class='xr-section-item'><input id='section-4eba75a7-3c80-42c4-a010-0e4ed78abcb3' class='xr-section-summary-in' type='checkbox'  checked><label for='section-4eba75a7-3c80-42c4-a010-0e4ed78abcb3' class='xr-section-summary' >Coordinates: <span>(4)</span></label><div class='xr-section-inline-details'></div><div class='xr-section-details'><ul class='xr-var-list'><li class='xr-var-item'><div class='xr-var-name'><span class='xr-has-index'>band</span></div><div class='xr-var-dims'>(band)</div><div class='xr-var-dtype'>int64</div><div class='xr-var-preview xr-preview'>1 2 3 4 5 6 7</div><input id='attrs-6b4f085e-ab51-4074-b05f-e0fee1ebeed5' class='xr-var-attrs-in' type='checkbox' disabled><label for='attrs-6b4f085e-ab51-4074-b05f-e0fee1ebeed5' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-ddbf4412-de23-4588-837f-f918c048e7cc' class='xr-var-data-in' type='checkbox'><label for='data-ddbf4412-de23-4588-837f-f918c048e7cc' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'></dl></div><div class='xr-var-data'><pre>array([1, 2, 3, 4, 5, 6, 7])</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span class='xr-has-index'>y</span></div><div class='xr-var-dims'>(y)</div><div class='xr-var-dtype'>float64</div><div class='xr-var-preview xr-preview'>4.428e+06 4.428e+06 ... 4.423e+06</div><input id='attrs-dd717439-c059-45f9-9260-5b326920ca24' class='xr-var-attrs-in' type='checkbox' disabled><label for='attrs-dd717439-c059-45f9-9260-5b326920ca24' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-9967662e-ac92-4e93-9f40-7c2978b24bb7' class='xr-var-data-in' type='checkbox'><label for='data-9967662e-ac92-4e93-9f40-7c2978b24bb7' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'></dl></div><div class='xr-var-data'><pre>array([4428450., 4428420., 4428390., 4428360., 4428330., 4428300., 4428270.,
       4428240., 4428210., 4428180., 4428150., 4428120., 4428090., 4428060.,
       4428030., 4428000., 4427970., 4427940., 4427910., 4427880., 4427850.,
       4427820., 4427790., 4427760., 4427730., 4427700., 4427670., 4427640.,
       4427610., 4427580., 4427550., 4427520., 4427490., 4427460., 4427430.,
       4427400., 4427370., 4427340., 4427310., 4427280., 4427250., 4427220.,
       4427190., 4427160., 4427130., 4427100., 4427070., 4427040., 4427010.,
       4426980., 4426950., 4426920., 4426890., 4426860., 4426830., 4426800.,
       4426770., 4426740., 4426710., 4426680., 4426650., 4426620., 4426590.,
       4426560., 4426530., 4426500., 4426470., 4426440., 4426410., 4426380.,
       4426350., 4426320., 4426290., 4426260., 4426230., 4426200., 4426170.,
       4426140., 4426110., 4426080., 4426050., 4426020., 4425990., 4425960.,
       4425930., 4425900., 4425870., 4425840., 4425810., 4425780., 4425750.,
       4425720., 4425690., 4425660., 4425630., 4425600., 4425570., 4425540.,
       4425510., 4425480., 4425450., 4425420., 4425390., 4425360., 4425330.,
       4425300., 4425270., 4425240., 4425210., 4425180., 4425150., 4425120.,
       4425090., 4425060., 4425030., 4425000., 4424970., 4424940., 4424910.,
       4424880., 4424850., 4424820., 4424790., 4424760., 4424730., 4424700.,
       4424670., 4424640., 4424610., 4424580., 4424550., 4424520., 4424490.,
       4424460., 4424430., 4424400., 4424370., 4424340., 4424310., 4424280.,
       4424250., 4424220., 4424190., 4424160., 4424130., 4424100., 4424070.,
       4424040., 4424010., 4423980., 4423950., 4423920., 4423890., 4423860.,
       4423830., 4423800., 4423770., 4423740., 4423710., 4423680., 4423650.,
       4423620., 4423590., 4423560., 4423530., 4423500., 4423470., 4423440.,
       4423410., 4423380., 4423350., 4423320., 4423290., 4423260., 4423230.,
       4423200., 4423170.])</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span class='xr-has-index'>x</span></div><div class='xr-var-dims'>(x)</div><div class='xr-var-dtype'>float64</div><div class='xr-var-preview xr-preview'>4.557e+05 4.557e+05 ... 4.63e+05</div><input id='attrs-cddcd29a-f313-413a-a311-78a411c8de18' class='xr-var-attrs-in' type='checkbox' disabled><label for='attrs-cddcd29a-f313-413a-a311-78a411c8de18' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-d15fdb99-fb25-4da8-9947-1e5d9c4ede24' class='xr-var-data-in' type='checkbox'><label for='data-d15fdb99-fb25-4da8-9947-1e5d9c4ede24' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'></dl></div><div class='xr-var-data'><pre>array([455670., 455700., 455730., ..., 462960., 462990., 463020.])</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span>spatial_ref</span></div><div class='xr-var-dims'>()</div><div class='xr-var-dtype'>int64</div><div class='xr-var-preview xr-preview'>0</div><input id='attrs-a9ed2827-4897-4ce2-9495-a1e4377b4015' class='xr-var-attrs-in' type='checkbox' ><label for='attrs-a9ed2827-4897-4ce2-9495-a1e4377b4015' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-575a5c1b-af9b-4d1d-83f7-3f9a9474229b' class='xr-var-data-in' type='checkbox'><label for='data-575a5c1b-af9b-4d1d-83f7-3f9a9474229b' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'><dt><span>crs_wkt :</span></dt><dd>PROJCRS[&quot;WGS 84 / UTM zone 13N&quot;,BASEGEOGCRS[&quot;WGS 84&quot;,DATUM[&quot;World Geodetic System 1984&quot;,ELLIPSOID[&quot;WGS 84&quot;,6378137,298.257223563,LENGTHUNIT[&quot;metre&quot;,1]]],PRIMEM[&quot;Greenwich&quot;,0,ANGLEUNIT[&quot;degree&quot;,0.0174532925199433]],ID[&quot;EPSG&quot;,4326]],CONVERSION[&quot;UTM zone 13N&quot;,METHOD[&quot;Transverse Mercator&quot;,ID[&quot;EPSG&quot;,9807]],PARAMETER[&quot;Latitude of natural origin&quot;,0,ANGLEUNIT[&quot;degree&quot;,0.0174532925199433],ID[&quot;EPSG&quot;,8801]],PARAMETER[&quot;Longitude of natural origin&quot;,-105,ANGLEUNIT[&quot;degree&quot;,0.0174532925199433],ID[&quot;EPSG&quot;,8802]],PARAMETER[&quot;Scale factor at natural origin&quot;,0.9996,SCALEUNIT[&quot;unity&quot;,1],ID[&quot;EPSG&quot;,8805]],PARAMETER[&quot;False easting&quot;,500000,LENGTHUNIT[&quot;metre&quot;,1],ID[&quot;EPSG&quot;,8806]],PARAMETER[&quot;False northing&quot;,0,LENGTHUNIT[&quot;metre&quot;,1],ID[&quot;EPSG&quot;,8807]]],CS[Cartesian,2],AXIS[&quot;easting&quot;,east,ORDER[1],LENGTHUNIT[&quot;metre&quot;,1]],AXIS[&quot;northing&quot;,north,ORDER[2],LENGTHUNIT[&quot;metre&quot;,1]],ID[&quot;EPSG&quot;,32613]]</dd><dt><span>semi_major_axis :</span></dt><dd>6378137.0</dd><dt><span>semi_minor_axis :</span></dt><dd>6356752.314245179</dd><dt><span>inverse_flattening :</span></dt><dd>298.257223563</dd><dt><span>reference_ellipsoid_name :</span></dt><dd>WGS 84</dd><dt><span>longitude_of_prime_meridian :</span></dt><dd>0.0</dd><dt><span>prime_meridian_name :</span></dt><dd>Greenwich</dd><dt><span>geographic_crs_name :</span></dt><dd>WGS 84</dd><dt><span>horizontal_datum_name :</span></dt><dd>World Geodetic System 1984</dd><dt><span>projected_crs_name :</span></dt><dd>WGS 84 / UTM zone 13N</dd><dt><span>grid_mapping_name :</span></dt><dd>transverse_mercator</dd><dt><span>latitude_of_projection_origin :</span></dt><dd>0.0</dd><dt><span>longitude_of_central_meridian :</span></dt><dd>-105.0</dd><dt><span>false_easting :</span></dt><dd>500000.0</dd><dt><span>false_northing :</span></dt><dd>0.0</dd><dt><span>scale_factor_at_central_meridian :</span></dt><dd>0.9996</dd><dt><span>spatial_ref :</span></dt><dd>PROJCRS[&quot;WGS 84 / UTM zone 13N&quot;,BASEGEOGCRS[&quot;WGS 84&quot;,DATUM[&quot;World Geodetic System 1984&quot;,ELLIPSOID[&quot;WGS 84&quot;,6378137,298.257223563,LENGTHUNIT[&quot;metre&quot;,1]]],PRIMEM[&quot;Greenwich&quot;,0,ANGLEUNIT[&quot;degree&quot;,0.0174532925199433]],ID[&quot;EPSG&quot;,4326]],CONVERSION[&quot;UTM zone 13N&quot;,METHOD[&quot;Transverse Mercator&quot;,ID[&quot;EPSG&quot;,9807]],PARAMETER[&quot;Latitude of natural origin&quot;,0,ANGLEUNIT[&quot;degree&quot;,0.0174532925199433],ID[&quot;EPSG&quot;,8801]],PARAMETER[&quot;Longitude of natural origin&quot;,-105,ANGLEUNIT[&quot;degree&quot;,0.0174532925199433],ID[&quot;EPSG&quot;,8802]],PARAMETER[&quot;Scale factor at natural origin&quot;,0.9996,SCALEUNIT[&quot;unity&quot;,1],ID[&quot;EPSG&quot;,8805]],PARAMETER[&quot;False easting&quot;,500000,LENGTHUNIT[&quot;metre&quot;,1],ID[&quot;EPSG&quot;,8806]],PARAMETER[&quot;False northing&quot;,0,LENGTHUNIT[&quot;metre&quot;,1],ID[&quot;EPSG&quot;,8807]]],CS[Cartesian,2],AXIS[&quot;easting&quot;,east,ORDER[1],LENGTHUNIT[&quot;metre&quot;,1]],AXIS[&quot;northing&quot;,north,ORDER[2],LENGTHUNIT[&quot;metre&quot;,1]],ID[&quot;EPSG&quot;,32613]]</dd><dt><span>GeoTransform :</span></dt><dd>455655.0 30.0 0.0 4428465.0 0.0 -30.0</dd></dl></div><div class='xr-var-data'><pre>array(0)</pre></div></li></ul></div></li><li class='xr-section-item'><input id='section-eeba727a-925d-4984-8c35-7cce3040b5ad' class='xr-section-summary-in' type='checkbox'  checked><label for='section-eeba727a-925d-4984-8c35-7cce3040b5ad' class='xr-section-summary' >Attributes: <span>(7)</span></label><div class='xr-section-inline-details'></div><div class='xr-section-details'><dl class='xr-attrs'><dt><span>STATISTICS_MAXIMUM :</span></dt><dd>3483</dd><dt><span>STATISTICS_MEAN :</span></dt><dd>297.16466859584</dd><dt><span>STATISTICS_MINIMUM :</span></dt><dd>-57</dd><dt><span>STATISTICS_STDDEV :</span></dt><dd>119.61507774931</dd><dt><span>scale_factor :</span></dt><dd>1.0</dd><dt><span>add_offset :</span></dt><dd>0.0</dd><dt><span>grid_mapping :</span></dt><dd>spatial_ref</dd></dl></div></li></ul></div></div>





{:.input}
```python
landsat_post_fire_xr.plot.imshow(col="band",
                                 col_wrap=3,
                                 cmap="Greys_r")
plt.show()
```

{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}/images/courses/intermediate-eds-textbook/05-multi-spectral-remote-sensing-python/landsat/2020-03-02-landsat-multispectral-01-about-landsat/2020-03-02-landsat-multispectral-01-about-landsat_9_0.png" alt = "Plot of each individual Landsat 8 band collected by glob. This image is of the Cold Springs Fire shorly after the fire.">
<figcaption>Plot of each individual Landsat 8 band collected by glob. This image is of the Cold Springs Fire shorly after the fire.</figcaption>

</figure>




## Plot RGB image

Just like you did with NAIP data, you can plot 3 band color composite images 
for Landsat using the **earthpy** `ep.plot_rgb()` function. Refer to the 
landsat bands in the table at the top of this page to figure out the red, 
green and blue bands. Or read the
<a href="https://blogs.esri.com/esri/arcgis/2013/07/24/band-combinations-for-landsat-8/" target="_blank">ESRI landsat 8 band combinations</a> post.

`ep.plot_rgb()` requires:

1. the numpy array containing the bands that you wish to plot. You can access this by using `xarray_name.values`
IMPORTANT: this array should be in xarray band order (bands first). 

2. The numeric location of bands that you wish to plot in the array.


{:.input}
```python
ep.plot_rgb(landsat_post_fire_xr.values,
            rgb=[3, 2, 1],
            title="RGB Composite Image\n Post Fire Landsat Data")
plt.show()
```

{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}/images/courses/intermediate-eds-textbook/05-multi-spectral-remote-sensing-python/landsat/2020-03-02-landsat-multispectral-01-about-landsat/2020-03-02-landsat-multispectral-01-about-landsat_11_0.png" alt = "Landsat 8 3 band color RGB composite.">
<figcaption>Landsat 8 3 band color RGB composite.</figcaption>

</figure>




Notice that the image above looks dark. You can stretch the image as you did with the NAIP data, too.
Below you use the stretch argument built into the earthpy `plot_rgb()` function. The `str_clip` argument allows you to specify how much of the tails of the data that you want to clip off. The larger the number, the most the data will be stretched or brightened.

<figure>
    <a href="{{ site.url }}/images/earth-analytics/raster-data/raster-image-stretch-dark.jpg">
    <img src="{{ site.url }}/images/earth-analytics/raster-data/raster-image-stretch-dark.jpg" alt="When the range of pixel brightness values is closer to 0, a
    darker image is rendered by default. You can stretch the values to extend to
    the full 0-255 range of potential values to increase the visual contrast of
    the image.">
    </a>
    <figcaption>When the range of pixel brightness values is closer to 0, a
    darker image is rendered by default. You can stretch the values to extend to
    the full 0-255 range of potential values to increase the visual contrast of
    the image.
    </figcaption>
</figure>

<figure>
    <a href="{{ site.url }}/images/earth-analytics/raster-data/raster-image-stretch-light.jpg">
    <img src="{{ site.url }}/images/earth-analytics/raster-data/raster-image-stretch-light.jpg" alt="When the range of pixel brightness values is closer to 255, a
    lighter image is rendered by default. You can stretch the values to extend to
    the full 0-255 range of potential values to increase the visual contrast of
    the image.">
    </a>
    <figcaption>When the range of pixel brightness values is closer to 255, a
    lighter image is rendered by default. You can stretch the values to extend to
    the full 0-255 range of potential values to increase the visual contrast of
    the image.
    </figcaption>
</figure>

{:.input}
```python
ep.plot_rgb(landsat_post_fire_xr.values,
            rgb=[3, 2, 1],
            title="Landsat RGB Image\n Linear Stretch Applied",
            stretch=True,
            str_clip=1)
plt.show()
```

{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}/images/courses/intermediate-eds-textbook/05-multi-spectral-remote-sensing-python/landsat/2020-03-02-landsat-multispectral-01-about-landsat/2020-03-02-landsat-multispectral-01-about-landsat_13_0.png" alt = "Landsat 3 band RGB color composite with stretch applied.">
<figcaption>Landsat 3 band RGB color composite with stretch applied.</figcaption>

</figure>




{:.input}
```python
# Adjust the amount of linear stretch to futher brighten the image
ep.plot_rgb(landsat_post_fire_xr.values,
            rgb=[3, 2, 1],
            title="Landsat RGB Image\n Linear Stretch Applied",
            stretch=True,
            str_clip=4)
plt.show()
```

{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}/images/courses/intermediate-eds-textbook/05-multi-spectral-remote-sensing-python/landsat/2020-03-02-landsat-multispectral-01-about-landsat/2020-03-02-landsat-multispectral-01-about-landsat_14_0.png" alt = "Landsat 3 band RGB color composite with stretch and more clip applied.">
<figcaption>Landsat 3 band RGB color composite with stretch and more clip applied.</figcaption>

</figure>




## Raster Pixel Histograms

You can create a histogram to view the distribution of pixel values in the rgb bands plotted above. 

{:.input}
```python
# Plot all band histograms using earthpy
band_titles = ["Band 1", 
               "Blue", 
               "Green", 
               "Red",
               "NIR", 
               "Band 6", 
               "Band7"]

ep.hist(landsat_post_fire_xr.values,
        title=band_titles)

plt.show()
```

{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}/images/courses/intermediate-eds-textbook/05-multi-spectral-remote-sensing-python/landsat/2020-03-02-landsat-multispectral-01-about-landsat/2020-03-02-landsat-multispectral-01-about-landsat_16_0.png" alt = "Landsat 8 histogram for each band.">
<figcaption>Landsat 8 histogram for each band.</figcaption>

</figure>





### Plot CIR

Now you've created a red, green blue color composite image. Remember red green and blue are colors that
your eye can see. 

Next, create a color infrared image (CIR) using landsat bands: 4,3,2.

{:.input}
```python
ep.plot_rgb(landsat_post_fire_xr.values,
            rgb=[4, 3, 2],
            title="CIR Landsat Image Pre-Cold Springs Fire",
            figsize=(10, 10))
plt.show()
```

{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}/images/courses/intermediate-eds-textbook/05-multi-spectral-remote-sensing-python/landsat/2020-03-02-landsat-multispectral-01-about-landsat/2020-03-02-landsat-multispectral-01-about-landsat_19_0.png" alt = "Landsat 8 CIR color composite image.">
<figcaption>Landsat 8 CIR color composite image.</figcaption>

</figure>




<div class='notice--success alert alert-info' markdown="1">

<i class="fa fa-star"></i> **Data Tip:** Landsat 8 Pre Collections Data

If you are working with Landsat data downloaded pre USGS collections, your data may be formatted and named slightly differently than the example shown on this page. Below is an explanation of the legacy Landsat 8 naming convention. 

File: `LC08_L1TP_034032_20160707_20170221_01_T1_sr_band1_crop.tif`

| Sensor | Sensor | Satellite | WRS path | WRS row | | | | |
|-------|
| L | C | 8 | 034| 032| 2016 |0707 | 20170221 | 01 |
| Landsat | OLI & TIRS | Landsat 8 | path = 034 | row = 032 | year = 2016 | Month = 7, day = 7 | Processing Date: 2017-02-21 (feb 21 2017) | Archive (second version): 01 |

* L: Landsat
* X: Sensor
  * C = OLI & TIRS
    O = OLI only
    T = IRS only
    E = ETM+
    T = TM
    M = MSS

* S Satelite
* PPP
* RRR
* YYYY = Year
* DDD = Julian DAY of the year
* GSI - Ground station ID
* VV = Archive Version

<a href="http://gisgeography.com/landsat-file-naming-convention/" target="_blank"> More here breaking down the file name.</a>
</div>

## Julian day

We won't spend a lot of time on Julian days. The julian day used to be used in Landsat pre collections file naming. However recently they have switched to a normal year-month-date format

See this link that provide tables to help you <a href="https://landweb.modaps.eosdis.nasa.gov/browse/calendar.html" target="_blank">convert julian days to actual date</a>.
