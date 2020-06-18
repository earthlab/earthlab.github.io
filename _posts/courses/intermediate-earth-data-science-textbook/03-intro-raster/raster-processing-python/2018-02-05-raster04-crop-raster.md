---
layout: single
title: "Crop Spatial Raster Data With a Shapefile in Python"
excerpt: "Sometimes a raster dataset covers a larger spatial extent than is needed for a particular purpose. In these cases, you can crop a raster file to a smaller extent. Learn how to crop raster data using a shapefile and export it as a new raster in open source Python"
authors: ['Leah Wasser']
dateCreated: 2018-02-05
modified: 2020-04-07
category: [courses]
class-lesson: ['raster-processing-python']
permalink: /courses/use-data-open-source-python/intro-raster-data-python/raster-data-processing/crop-raster-data-with-shapefile-in-python/
nav-title: 'Crop Raster Data'
week: 3
course: 'intermediate-earth-data-science-textbook'
sidebar:
  nav:
author_profile: false
comments: true
order: 4
topics:
  reproducible-science-and-programming: ['python']
  remote-sensing: ['lidar']
  spatial-data-and-gis: ['raster-data']
redirect_from:
  - "/courses/earth-analytics-python/lidar-raster-data/crop-raster-data-with-shapefile-in-python/"
---

{% include toc title="On This Page" icon="file-text" %}

<div class='notice--success' markdown="1">

## <i class="fa fa-graduation-cap" aria-hidden="true"></i> Learning Objectives

* Crop a raster dataset in **Python** using a vector extent object derived from a shapefile.
* Open a shapefile in **Python**.

</div>

In previous lessons, you reclassified a raster in **Python**; however, the edges of your raster dataset were uneven.

In this lesson, you will learn how to crop a raster - to create a new raster
object / file that you can share with colleagues and / or open in other tools such
as a Desktop GIS tool like QGIS.


## About Spatial Crop

Cropping (sometimes also referred to as clipping), is when you subset or make a dataset smaller, 
by removing all data outside of the crop area or spatial extent. In this case you have a large 
raster - but let's pretend that you only need to work with a smaller subset of the raster. 

You can use the `crop_image` function to remove all of the data outside of your study area.
This is useful as it:

1. Makes the data smaller and 
2. Makes processing and plotting faster

In general when you can, it's often a good idea to crop your raster data!

To begin let's load the libraries that you will need in this lesson. 


## Load Libraries

{:.input}
```python
import os
import matplotlib.pyplot as plt
import seaborn as sns
import numpy as np
from shapely.geometry import mapping
import geopandas as gpd
import rasterio as rio
from rasterio.plot import plotting_extent
from rasterio.mask import mask
import earthpy as et
import earthpy.spatial as es
import earthpy.plot as ep

# Prettier plotting with seaborn
sns.set(font_scale=1.5)

# Get data and set working directory
et.data.get_data("colorado-flood")
os.chdir(os.path.join(et.io.HOME, 'earth-analytics'))
```


## Open Raster and Vector Layers

In the previous lessons, you worked with a raster layer that looked like the one below. Notice that the data have an uneven edge on the left hand side. Let's pretend this edge is outside of your study area and you'd like to remove it or clip it off using your study area extent. You can do this using the `crop_image()` function in `earthpy.spatial`. 


{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}/images/courses/intermediate-earth-data-science-textbook/03-intro-raster/raster-processing-python/2018-02-05-raster04-crop-raster/2018-02-05-raster04-crop-raster_5_0.png" alt = "Canopy height model plot - uncropped.">
<figcaption>Canopy height model plot - uncropped.</figcaption>

</figure>




## Open Vector Layer

To begin your clip, open up a vector layer that contains the crop extent that you want
to use to crop your data. To open a shapefile you use the `gpd.read_file()` function
from geopandas. You will learn more about vector data in Python in a few weeks.


{:.input}
```python
aoi = os.path.join("data", "colorado-flood", "spatial",
                   "boulder-leehill-rd", "clip-extent.shp")

# Open crop extent (your study area extent boundary)
crop_extent = gpd.read_file(aoi)
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
    crop extent crs:  epsg:32613
    lidar crs:  EPSG:32613




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
{:.execute_result}



    Text(0.5, 1.0, 'Shapefile Crop Extent')





{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}/images/courses/intermediate-earth-data-science-textbook/03-intro-raster/raster-processing-python/2018-02-05-raster04-crop-raster/2018-02-05-raster04-crop-raster_12_1.png" alt = "Plot of the shapefile that you will use to crop the CHM data.">
<figcaption>Plot of the shapefile that you will use to crop the CHM data.</figcaption>

</figure>




<figure>
    <a href="{{ site.url }}/images/earth-analytics/spatial-data/spatial-extent.png">
    <img src="{{ site.url }}/images/earth-analytics/spatial-data/spatial-extent.png" alt="The spatial extent of a shapefile the geographic edge or location that is the furthest north, south east and west."></a>
    <figcaption>The spatial extent of a shapefile represents the geographic "edge" or location that is the furthest north, south east and west. Thus is represents the overall geographic coverage of the spatial
    object. Image Source: Colin Williams, NEON.
    </figcaption>
</figure>


Now that you have imported the shapefile. You can use the `crop_image` function from `earthpy.spatial` to crop the raster data using the vector shapefile.

{:.input}
```python
fig, ax = plt.subplots(figsize=(10, 8))

ep.plot_bands(lidar_chm_im, cmap='terrain',
              extent=plotting_extent(lidar_chm),
              ax=ax,
              title="Raster Layer with Shapefile Overlayed",
              cbar=False)

crop_extent.plot(ax=ax, alpha=.8)

ax.set_axis_off()
```

{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}/images/courses/intermediate-earth-data-science-textbook/03-intro-raster/raster-processing-python/2018-02-05-raster04-crop-raster/2018-02-05-raster04-crop-raster_14_0.png" alt = "Canopy height model with the crop shapefile overlayed. Note this image is just an illustration of what the two layers look like together. Below you will learn how to import the data and mask it rather than using the .read() method.">
<figcaption>Canopy height model with the crop shapefile overlayed. Note this image is just an illustration of what the two layers look like together. Below you will learn how to import the data and mask it rather than using the .read() method.</figcaption>

</figure>






## Crop Data Using the `crop_image` Function

If you want to crop the data you can use the `crop_image` function in `earthpy.spatial`. When you crop the data, you can then export it and share it with colleagues. Or use it in another analysis. IMPORTANT: You do not need to read the data in before cropping! Cropping the data can be your first step.

To perform the crop you:

1. Create a connection to the raster dataset that you wish to crop
2. Open your shapefile as a geopandas object. This is what EarthPy needs to crop the data to the extent of your vector shapefile.
3. Crop the data using the `crop_image()` function. 

Without EarthPy, you would have to perform this with a Geojson object. Geojson is a format that is worth becoming familiar with. It's a text, structured format that is used in many online applications. We will discuss it in  more detail later in the class. For now, have a look at the output below. 

{:.input}
```python
lidar_chm_path = os.path.join("data", "colorado-flood", "spatial",
                              "boulder-leehill-rd", "outputs", "lidar_chm.tif")

with rio.open(lidar_chm_path) as lidar_chm:
    lidar_chm_crop, lidar_chm_crop_meta = es.crop_image(lidar_chm,crop_extent)

lidar_chm_crop_affine = lidar_chm_crop_meta["transform"]

# Create spatial plotting extent for the cropped layer
lidar_chm_extent = plotting_extent(lidar_chm_crop[0], lidar_chm_crop_affine)
```

Finally, plot the cropped data. Does it look correct?

{:.input}
```python
# Plot your data
ep.plot_bands(lidar_chm_crop[0],
              extent=lidar_chm_extent,
              cmap='Greys',
              title="Cropped Raster Dataset",
              scale=False)
plt.show()
```

{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}/images/courses/intermediate-earth-data-science-textbook/03-intro-raster/raster-processing-python/2018-02-05-raster04-crop-raster/2018-02-05-raster04-crop-raster_20_0.png" alt = "Final cropped canopy height model plot.">
<figcaption>Final cropped canopy height model plot.</figcaption>

</figure>




<div class="notice--info" markdown="1">
## OPTIONAL -- Export Newly Cropped Raster

Once you have cropped your data, you may want to export it. 
In the subtract rasters lesson you exported a raster that had the same shape and transformation information as the parent rasters. However in this case, you have cropped your data. You will have to update several things to ensure your data export properly:

1. The width and height of the raster: You can get this information from the **shape** of the cropped numpy array and
2. The transformation information of the affine object. The `crop_image()` function provides this inside the metadata object it returns!
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

{:.output}
{:.execute_result}



    {'driver': 'GTiff', 'dtype': 'float64', 'nodata': -999.99, 'width': 3490, 'height': 2000, 'count': 1, 'crs': CRS.from_epsg(32613), 'transform': Affine(1.0, 0.0, 472510.0,
           0.0, -1.0, 4436000.0), 'tiled': False, 'compress': 'lzw', 'interleave': 'band'}





Once you have updated the metadata you can write our your new raster. 

{:.input}
```python
# Write data
path_out = os.path.join("data", "colorado-flood", "spatial", 
                        "outputs", "lidar_chm_cropped.tif")

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
