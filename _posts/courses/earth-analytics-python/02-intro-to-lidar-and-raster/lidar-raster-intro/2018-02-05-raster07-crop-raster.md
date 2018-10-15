---
layout: single
title: "Crop Spatial Raster Data With a Shapefile in Python"
excerpt: "Learn how to crop raster data using a shapefile and export it as a new raster in open source Python"
authors: ['Leah Wasser']
modified: 2018-10-08
category: [courses]
class-lesson: ['intro-lidar-raster-python']
permalink: /courses/earth-analytics-python/lidar-raster-data/crop-raster-data-with-shapefile-in-python/
nav-title: 'Crop Raster Data'
week: 2
course: "earth-analytics-python"
sidebar:
  nav:
author_profile: false
comments: true
order: 7
topics:
  reproducible-science-and-programming: ['python']
  remote-sensing: ['lidar']
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

{% include/data_subsets/course_earth_analytics/_data-colorado-flood.md %}

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
import numpy as np
import os
import matplotlib.pyplot as plt
import rasterio as rio
from rasterio.plot import plotting_extent
from rasterio.mask import mask
from shapely.geometry import mapping
import geopandas as gpd
import earthpy as et
plt.ion()

import seaborn as sns
sns.set(font_scale=1.5)
os.chdir(os.path.join(et.io.HOME, 'earth-analytics'))
```

## Open Raster and Vector Layers

In the previous lessons, you worked with a raster layer that looked like the one below. Notice that the data have an uneven edge on the left hand side. Let's pretend this edge is outside of your study area and you'd like to remove it or clip it off using your study area extent. You can do this using the `mask()` function in `rasterio`. 


{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}//images/courses/earth-analytics-python/02-intro-to-lidar-and-raster/lidar-raster-intro/2018-02-05-raster07-crop-raster_5_0.png" alt = "Canopy height model plot - uncropped.">
<figcaption>Canopy height model plot - uncropped.</figcaption>

</figure>




## Open Vector Layer

To begin your clip, open up a vector layer that contains the crop extent that you want
to use to crop your data. To open a shapefile you use the `gpd.read_file()` function
from geopandas. You will learn more about vector data in Python in a few weeks.

{:.input}
```python
# Open crop extent (your study area extent boundary)
crop_extent = gpd.read_file(
    'data/colorado-flood/spatial/boulder-leehill-rd/clip-extent.shp')
```

Next, view the coordinate reference system (CRS) of both of your datasets. 
Remember that in order to perform any analysis with these two datasets together,
they will need to be in the same CRS. 

{:.input}
```python
print('crop extent crs: ', crop_extent.crs)
print('lidar crs: ', lidar_chm.crs)
```

{:.output}
    crop extent crs:  {'init': 'epsg:32613'}
    lidar crs:  +init=epsg:32613



{:.input}
```python
# Plot the crop boundary layer
# Note this is just an example so you can see what it looks like
# You don't need to plot this layer in your homework!
fig, ax = plt.subplots(figsize=(6, 6))
crop_extent.plot(ax=ax)
ax.set_title("Shapefile Crop Extent",
             fontsize=16)
```

{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}//images/courses/earth-analytics-python/02-intro-to-lidar-and-raster/lidar-raster-intro/2018-02-05-raster07-crop-raster_10_0.png" alt = "Plot of the shapefile that you will use to crop the CHM data.">
<figcaption>Plot of the shapefile that you will use to crop the CHM data.</figcaption>

</figure>




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
fig, ax = plt.subplots(figsize=(10, 8))
ax.imshow(lidar_chm_im, cmap='terrain',
          extent=plotting_extent(lidar_chm))
crop_extent.plot(ax=ax, alpha=.8)
ax.set_title("Raster Layer with Shapefile Overlayed")
ax.set_axis_off()
```

{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}//images/courses/earth-analytics-python/02-intro-to-lidar-and-raster/lidar-raster-intro/2018-02-05-raster07-crop-raster_12_0.png" alt = "Canopy height model with the crop shapefile overlayed. Note this image is just an illustration of what the two layers look like together. Below you will learn how to import the data and mask it rather than using the .read() method.">
<figcaption>Canopy height model with the crop shapefile overlayed. Note this image is just an illustration of what the two layers look like together. Below you will learn how to import the data and mask it rather than using the .read() method.</figcaption>

</figure>




{:.input}
```python
crop_bounds = crop_extent.total_bounds
```

## Crop Data Using the Mask Function

If you want to crop the data you can use the `mask` function in `rasterio`. When you crop the data, you can then export it and share it with colleagues. Or use it in another analysis. IMPORTANT: You do not need to read the data in before cropping! Cropping the data can be your first step.

To perform the crop you:

1. Create a connection to the raster dataset that you wish to crop
2. Create a geojson structured spatial object from your shapefile. This is what rasterio needs to crop the data to the extent of your vector shapefile.
3. Crop the data using the `mask()` function and the `crop = True` argument. 

Geojson is a format that is worth becoming familiar with. It's a text, structured format that is used in many online applications. We will discuss it in  more detail later in the class. For now, have a look at the output below. Notice that you have a polygon that has been converted to sets of coordinates that define each vertex of the polygon and the open and closing vertices. 

{:.input}
```python
# create geojson object from the shapefile imported above
extent_geojson = mapping(crop_extent['geometry'][0])
extent_geojson
```

{:.output}
{:.execute_result}



    {'type': 'Polygon',
     'coordinates': (((472510.46511627914, 4436000.0),
       (476009.76417479065, 4436000.0),
       (476010.46511627914, 4434000.0),
       (472510.46511627914, 4434000.0),
       (472510.46511627914, 4436000.0)),)}





Once you have created this object, you are ready to crop your data. 

{:.input}
```python
with rio.open("data/colorado-flood/spatial/boulder-leehill-rd/outputs/lidar_chm.tif") as lidar_chm:
    lidar_chm_crop, lidar_chm_crop_affine = mask(lidar_chm,
                                                 [extent_geojson],
                                                 crop=True)

# Create spatial plotting extent for the cropped layer
lidar_chm_extent = plotting_extent(lidar_chm_crop[0], lidar_chm_crop_affine)
```

Finally, plot the cropped data. Does it look correct?

{:.input}
```python
# Plot your data
fig, ax = plt.subplots(figsize=(10, 8))
ax.imshow(lidar_chm_crop[0],
          extent=lidar_chm_extent,
          cmap='Greys')
ax.set_title("Cropped Raster Dataset")
ax.set_axis_off()
```

{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}//images/courses/earth-analytics-python/02-intro-to-lidar-and-raster/lidar-raster-intro/2018-02-05-raster07-crop-raster_19_0.png" alt = "Final cropped canopy height model plot.">
<figcaption>Final cropped canopy height model plot.</figcaption>

</figure>




<div class="notice--info" markdown="1">
## OPTIONAL -- Export Newly Cropped Raster

Once you have cropped your data, you may want to export it. 
In the subtract rasters lesson you exported a raster that had the same shape and transformation information as the parent rasters. However in this case, you have cropped your data. You will have to update several things to ensure your data export properly:

1. The width and height of the raster: You can get this information from the **shape** of the cropped numpy array and
2. The transformation information of the affine object. The `mask()` function provides this as one of it's outputs!
3. Finally you may want to update the `nodata` value.

In this case you don't have any `nodata` values in your raster. However you may have them in a future raster!
</div>

{:.input}
```python
# Update with the new cropped affine info and the new width and height
lidar_chm_meta.update({'transform': lidar_chm_crop_affine,
                       'height': lidar_chm_crop.shape[1],
                       'width': lidar_chm_crop.shape[2],
                       'nodata': -999.99})
lidar_chm_meta
```

Once you have updated the metadata you can write our your new raster. 

{:.input}
```python
# Write data
path_out = "data/colorado-flood/spatial/outputs/lidar_chm_cropped.tif"
with rio.open(path_out, 'w', **lidar_chm_meta) as ff:
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
