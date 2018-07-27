---
layout: single
category: [courses]
title: "Crop a Spatial Raster Dataset Using a Shapefile in Python"
excerpt: "This lesson covers how to crop a raster dataset and export it as a new raster in Python"
authors: ['Leah Wasser', 'Joe McGlinchy', 'Chris Holdgraf', 'Martha Morrissey', 'Jenny Palomino']
modified: 2018-07-19
permalink: /workshops/gis-open-source-python/crop-raster-data-in-python/
nav-title: 'Crop a Raster'
module-type: 'workshop'
module: "spatial-data-open-source-python"
sidebar:
  nav:
author_profile: false
comments: true
order: 7
topics:
  reproducible-science-and-programming: ['python']
  spatial-data-and-gis: ['raster-data']
---

{% include toc title="In This Lesson" icon="file-text" %}

<div class='notice--success' markdown="1">

## <i class="fa fa-graduation-cap" aria-hidden="true"></i> Learning Objectives

After completing this lesson, you will be able to:

* Crop a raster dataset in `Python` using a vector extent object derived from a shapefile.
* Open a shapefile in `Python`.

## <i class="fa fa-check-square-o fa-2" aria-hidden="true"></i> What You Need

[<i class="fa fa-download" aria-hidden="true"></i> Download spatial-vector-lidar data subset (~172 MB)](https://ndownloader.figshare.com/files/12459464){:data-proofer-ignore='' .btn }

You will need a computer with internet access to complete this lesson. If you are following along online and not using our cloud environment:

[<i class="fa fa-download" aria-hidden="true"></i> Get data and software setup instructions here]({{site.url}}/workshops/gis-open-source-python/){:data-proofer-ignore='' .btn }

You will need the Python 3.x Anaconda distribution, git and bash to set things up.
</div>

In this lesson, you will learn how to crop a raster dataset in `Python`. 

## What Does Crop a Raster Mean?

Cropping (sometimes also referred to as clipping), is when you subset or make a dataset smaller, 
by removing all data outside of the crop area or spatial extent. In this case you have a large 
raster - but let's pretend that you only need to work with a smaller subset of the raster. 

You can use the `crop_extent` function to remove all of the data outside of your study area.
This is useful as it:

1. Makes the data smaller and 
2. Makes processing and plotting faster

In general when you can, it's often a good idea to crop your raster data!

To begin let's load the libraries that you will need in this lesson. 


## Load Libraries

### Be sure to set your working directory
`os.chdir("path-to-you-dir-here/earth-analytics/data")`

{:.input}
```python
import rasterio as rio
from rasterio.plot import show
from rasterio.mask import mask
from shapely.geometry import mapping
import numpy as np
import os
import matplotlib.pyplot as plt
import geopandas as gpd
import earthpy as et
import cartopy as cp
plt.ion()

os.chdir(os.path.join(et.io.HOME, 'earth-analytics'))
# optional - turn off warnings
import warnings
warnings.filterwarnings('ignore')
```

## Open Raster and Vector Layers

Next, you will use `rio.open()` to open a raster layer. Open and plot the canopy height model (CHM) that you created in the previous lesson. Or you can use the CHM provided to you in the data directory here:

`data/spatial-vector-lidar/california/neon-soap-site/2013/lidar/SOAP_lidarCHM.tif`

{:.input}
```python
soap_chm_path = 'data/spatial-vector-lidar/california/neon-soap-site/2013/lidar/SOAP_lidarCHM.tif'
# open the lidar chm
with rio.open(soap_chm_path) as src:
    lidar_chm_im = src.read(masked = True)[0]
    extent = rio.plot.plotting_extent(src)
    soap_profile = src.profile

fig, ax = plt.subplots(figsize = (10,10))
show(lidar_chm_im, 
     cmap='terrain', 
     ax=ax,
      extent = extent)
ax.set_title("Lidar Canopy Height Model (CHM)\n NEON SOAP Field Site", 
             fontsize = 16);
```

{:.output}
{:.display_data}

![png]({{ site.url }}//images/workshops/spatial-data-python-intro/2018-07-20-spatial-07-crop-raster_5_0.png)




## Open Vector Layer

Next, open up a vector layer that contains the crop extent that you want
to use to crop your data. To open a shapefile you use the `gpd.read_file()` function
from geopandas.

{:.input}
```python
# open crop extent
crop_extent_soap = gpd.read_file('data/spatial-vector-lidar/california/neon-soap-site/vector_data/SOAP_crop2.shp')
```

Next, explore the coordinate reference system (CRS) of both of your datasets. 
Remember that in order to perform any analysis with these two datasets together,
they will need to be in the same CRS. 

{:.input}
```python
print('crop extent crs: ', crop_extent_soap.crs)
print('lidar crs: ', soap_profile['crs'])
```

{:.output}
    crop extent crs:  {'init': 'epsg:32611'}
    lidar crs:  +init=epsg:32611



{:.input}
```python
# plot the data
fig, ax = plt.subplots(figsize = (6, 6))
crop_extent_soap.plot(ax=ax)
ax.set_title("Shapefile Imported into Python \nCrop Extent for Soaproot Saddle Field Site", 
             fontsize = 16)
ax.set_axis_off();
```

{:.output}
{:.display_data}

![png]({{ site.url }}//images/workshops/spatial-data-python-intro/2018-07-20-spatial-07-crop-raster_10_0.png)




<figure>
    <a href="{{ site.url }}/images/courses/earth-analytics/spatial-data/spatial-extent.png">
    <img src="{{ site.url }}/images/courses/earth-analytics/spatial-data/spatial-extent.png" alt="The spatial extent of a shapefile the geographic edge or location that is the furthest north, south east and west."></a>
    <figcaption>The spatial extent of a shapefile represents the geographic "edge" or location that is the furthest north, south east and west. Thus is represents the overall geographic coverage of the spatial
    object. Image Source: Colin Williams, NEON.
    </figcaption>
</figure>

Now that you have imported the shapefile. Plot the two layers together to ensure the overlap each other. If the shapefile does not overlap the raster, then you can not use it to crop!

{:.input}
```python
fig, ax = plt.subplots(figsize = (10,10))
ax.imshow(lidar_chm_im, 
          cmap='terrain', 
          extent=extent)
crop_extent_soap.plot(ax=ax, alpha=.6, color='g');
```

{:.output}
{:.display_data}

![png]({{ site.url }}//images/workshops/spatial-data-python-intro/2018-07-20-spatial-07-crop-raster_12_0.png)




To crop the data,use the `mask` function in `rasterio`.

{:.input}
```python
from rasterio.mask import mask
from shapely.geometry import mapping
```

{:.input}
```python
with rio.open(soap_chm_path) as src:
    extent_geojson = mapping(crop_extent_soap['geometry'][0])
    lidar_chm_crop, crop_affine = mask(src, 
                                   shapes=[extent_geojson], 
                                   crop=True)
    # metadata for writing or exporting the data
    soap_lidar_meta = src.meta.copy()
```

{:.input}
```python
# Update the metadata to have the new shape (x and y and affine information)
soap_lidar_meta.update({"driver": "GTiff",
                 "height": lidar_chm_crop.shape[0],
                 "width": lidar_chm_crop.shape[1],
                 "transform": crop_affine})

# generate an extent for the newly cropped object for plotting
cr_ext = rio.transform.array_bounds(soap_lidar_meta['height'], 
                                            soap_lidar_meta['width'], 
                                            soap_lidar_meta['transform'])

bound_order = [0,2,1,3]
cr_extent = [cr_ext[b] for b in bound_order]
cr_extent, crop_extent_soap.total_bounds
```

{:.output}
{:.execute_result}



    ([297349.0, 298062.0, 4101114.0, 4101115.0],
     array([ 297349.82145413, 4100402.84616318,  297923.2856659 ,
            4101114.9500745 ]))





{:.input}
```python
# mask the nodata and plot the newly cropped raster layer
lidar_chm_crop_ma = np.ma.masked_equal(lidar_chm_crop[0], -9999.0) 
fig, ax = plt.subplots(figsize = (8,8))
ax.imshow(lidar_chm_crop_ma, extent = cr_extent)
#crop_extent_soap.plot(ax=ax, alpha=.6, color='g');
#ax.set_axis_off()

```

{:.output}
{:.execute_result}



    <matplotlib.image.AxesImage at 0x12c18fb38>





{:.output}
{:.display_data}

![png]({{ site.url }}//images/workshops/spatial-data-python-intro/2018-07-20-spatial-07-crop-raster_17_1.png)




{:.input}
```python

# Save to disk so you can use the file later.
path_out = "data/spatial-vector-lidar/outputs/soap_lidar_chm_crop.tif"
with rio.open(path_out, 'w', **soap_lidar_meta) as ff:
    ff.write(lidar_chm_crop[0], 1)
```

<div class="notice--warning" markdown="1">

## <i class="fa fa-pencil-square-o" aria-hidden="true"></i> Optional Challenge: Crop the SJER Lidar Data 

Above your cropped the data for the SOaproot Saddle fieldsite. Crop the data using the same approach for the sjer field site located in this folder: `data/spatial-vector-lidar/california/neon-sjer-site`. 
</div>
