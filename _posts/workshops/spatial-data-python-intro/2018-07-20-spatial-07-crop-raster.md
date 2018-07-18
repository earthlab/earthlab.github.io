---
layout: single
category: [courses]
title: "Crop a Spatial Raster Dataset Using a Shapefile in Python"
excerpt: "This lesson covers how to crop a raster dataset and export it as a new raster in Python"
authors: ['Leah Wasser']
modified: 2018-07-18
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

After completing this tutorial, you will be able to:

* Crop a raster dataset in `Python` using a vector extent object derived from a shapefile.
* Open a shapefile in `Python`.

## <i class="fa fa-check-square-o fa-2" aria-hidden="true"></i> What You Need

You will need a computer with internet access to complete this lesson.

If you have not already downloaded the week 3 data, please do so now.
[<i class="fa fa-download" aria-hidden="true"></i> Download the 2013 Colorado Flood Teaching Data (~250 MB)](https://ndownloader.figshare.com/files/12395030){:data-proofer-ignore='' .btn }

</div>

In this lesson, you will learn how to crop a raster dataset in `Python`. Previously,
you reclassified a raster in `Python`, however the edges of your raster dataset were uneven.
In this lesson, you will learn how to crop a raster - to create a new raster
object / file that you can share with colleagues and / or open in other tools such
as QGIS.

## About Spatial Crop

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
import numpy as np
import os
import matplotlib.pyplot as plt
import geopandas as gpd
import earthpy as et
import cartopy as cp
plt.ion()
```

## Open Raster and Vector Layers

Next, you will use `rio.open()` to open a raster layer. Open and plot the canopy height model (CHM) that you created in the previous lesson.

{:.input}
```python
# with rio.open("data/colorado-flood/spatial/boulder-leehill-rd/outputs/lidar_chm.tif") as lidar_chm:
#     lidar_chm_im = lidar_chm.read(masked = True)[0]

with rio.open("data/spatial-vector-lidar/spatial/outputs/lidar_chm.tiff") as lidar_chm:
    lidar_chm_im = lidar_chm.read(masked = True)[0]

fig, ax = plt.subplots()
show(lidar_chm_im, cmap='terrain', ax=ax)
ax.set_title("Lidar Canopy Height Model (CHM)", fontsize = 16);
```

{:.output}
{:.display_data}

![png]({{ site.url }}//images/workshops/spatial-data-python-intro/2018-07-20-spatial-07-crop-raster_5_0.png)




## Open Vector Layer

Next, let's open up a vector layer that contains the crop extent that you want
to use to crop your data. To open a shapefile you use the `gpd.read_file()` function
from geopandas.

{:.input}
```python
# open crop extent
# crop_extent = gpd.read_file('data/colorado-flood/spatial/boulder-leehill-rd/clip-extent.shp')
crop_extent = gpd.read_file('data/spatial-vector-lidar/california/neon-sjer-site/vector_data/SJER_crop2.shp')
# crop_extent = crop_extent.to_crs(epsg='32613')
```

Next, let's explore the coordinate reference system (CRS) of both of your datasets. 
Remember that in order to perform any analysis with these two datasets together,
they will need to be in the same CRS. 

{:.input}
```python
print('crop extent crs: ', crop_extent.crs)
print('lidar crs: ', lidar_chm.crs)
```

{:.output}
    crop extent crs:  {'init': 'epsg:32611'}
    lidar crs:  CRS({'init': 'epsg:32611'})



{:.input}
```python
# plotting with cartopy
crs = cp.crs.epsg('32613')
fig, ax = plt.subplots(subplot_kw={'projection': crs}) 
ax.add_geometries(crop_extent['geometry'], crs=crs)
ax.set(xlim=crop_extent.bounds[['minx', 'maxx']].values[0],
       ylim=crop_extent.bounds[['miny', 'maxy']].values[0])
```

{:.output}
{:.execute_result}



    [(4100300.228412936, 4101133.077965272),
     (297681.1635450043, 298391.45329699665)]





{:.output}
{:.display_data}

![png]({{ site.url }}//images/workshops/spatial-data-python-intro/2018-07-20-spatial-07-crop-raster_10_1.png)




{:.input}
```python
# Or use matplotlib
fig, ax = plt.subplots(figsize = (6, 6))
crop_extent.plot(ax=ax)
ax.set_title("Shapefile imported into Python - crop extent", fontsize = 16);
```

{:.output}
{:.display_data}

![png]({{ site.url }}//images/workshops/spatial-data-python-intro/2018-07-20-spatial-07-crop-raster_11_0.png)




<figure>
    <a href="{{ site.url }}/images/courses/earth-analytics/spatial-data/spatial-extent.png">
    <img src="{{ site.url }}/images/courses/earth-analytics/spatial-data/spatial-extent.png" alt="The spatial extent of a shapefile the geographic edge or location that is the furthest north, south east and west."></a>

    <figcaption>The spatial extent of a shapefile represents the geographic "edge" or location that is the furthest north, south east and west. Thus is represents the overall geographic coverage of the spatial
    object. Image Source: Colin Williams, NEON.
    </figcaption>
</figure>



Now that you have imported the shapefile. You can use the `crop_extent` function from `matplotlib` to crop the raster data using the vector shapefile.

{:.input}
```python
bounds = lidar_chm.bounds
bounds = [bounds.left, bounds.right, bounds.bottom, bounds.top]
```

{:.input}
```python
fig, ax = plt.subplots()
ax.imshow(lidar_chm_im, cmap='terrain', extent=bounds)
crop_extent.plot(ax=ax, alpha=.6, color='g');
```

{:.output}
{:.display_data}

![png]({{ site.url }}//images/workshops/spatial-data-python-intro/2018-07-20-spatial-07-crop-raster_14_0.png)




{:.input}
```python
crop_bounds = crop_extent.total_bounds
```

{:.input}
```python
fig, ax = plt.subplots()
im = ax.imshow(lidar_chm_im, cmap='terrain', extent=bounds)
ax.set(xlim=[crop_bounds[0], crop_bounds[2]], ylim=[crop_bounds[1], crop_bounds[3]])
crop_extent.plot(ax=ax, linewidth=3, alpha=.5, color='green');

# NOTE: you only need to use cartopy to use `add_geometries`.
# If you don't need to use that method, you can just use geopandas/vanilla matplotlib
# ax.add_geometries(crop_extent['geometry'], crs=cp.crs.PlateCarree())
```

{:.output}
{:.display_data}

![png]({{ site.url }}//images/workshops/spatial-data-python-intro/2018-07-20-spatial-07-crop-raster_16_0.png)




If you want to crop the data itself, rather than simply to draw a smaller area in the vizualization, you can use the `mask` function in `rasterio`.

{:.input}
```python
from rasterio.mask import mask
from shapely.geometry import mapping
```

{:.input}
```python
# with rio.open("data/colorado-flood/spatial/boulder-leehill-rd/outputs/lidar_chm.tif") as lidar_chm:
with rio.open("data/spatial-vector-lidar/spatial/outputs/lidar_chm.tiff") as lidar_chm:
    
    #lidar_chm_im = lidar_chm.read(masked = True)[0]
    extent_geojson = mapping(crop_extent['geometry'][0])
    lidar_chm_crop, crop_tf = mask(lidar_chm, shapes=[extent_geojson], crop=True)
    
    # for writing the data
    out_meta = lidar_chm.meta.copy()
```

{:.input}
```python
lidar_chm_crop_ma = np.ma.masked_equal(lidar_chm_crop[0], -9999.0) # mask the nodata
fig, ax = plt.subplots()
# ax.imshow(lidar_chm_crop[0], extent=bounds)
ax.imshow(lidar_chm_crop_ma, extent=crop_bounds)
ax.set_axis_off()

```

{:.output}
{:.display_data}

![png]({{ site.url }}//images/workshops/spatial-data-python-intro/2018-07-20-spatial-07-crop-raster_20_0.png)




{:.input}
```python
crop_prof
lidar
```

{:.output}
{:.execute_result}



    Affine(1.0, 0.0, 297681.0,
           0.0, -1.0, 4101134.0)





{:.input}
```python
# this is failing because it's trying to get the profile - which actually needs to be updated with the new crop extent
# i figured out how to do this i just forget now how it works...
out_meta.update({"driver": "GTiff",
                 "height": lidar_chm_crop_ma.shape[0],
                 "width": lidar_chm_crop_ma.shape[1],
                 "transform": crop_tf})

# Save to disk so you can use later.
path_out = "data/spatial-vector-lidar/spatial/outputs/lidar_chm_cropped.tiff"
with rio.open(path_out, 'w', **out_meta) as ff:
    ff.write(lidar_chm_crop[0], 1)
```

<div class="notice--warning" markdown="1">

## <i class="fa fa-pencil-square-o" aria-hidden="true"></i> Optional Challenge: Crop Change Over Time Layers

In the previous lesson, you created 2 plots:

1. A classified raster map that shows **positive and negative change** in the canopy
height model before and after the flood. To do this you will need to calculate the
difference between two canopy height models.
2. A classified raster map that shows **positive and negative change** in terrain
extracted from the pre and post flood Digital Terrain Models before and after the flood.

Create the same two plots except this time CROP each of the rasters that you plotted
using the shapefile: `data/week-03/boulder-leehill-rd/crop_extent.shp`

For each plot, be sure to:

* Add a legend that clearly shows what each color in your classified raster represents.
* Use proper colors.
* Add a title to your plot.

You will include these plots in your final report due next week.
</div>
