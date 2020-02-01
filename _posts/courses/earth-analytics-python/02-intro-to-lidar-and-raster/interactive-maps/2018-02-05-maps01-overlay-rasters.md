---
layout: single
title: "Layer a raster dataset over a hillshade in Python to create a beautiful basemap that represents topography."
excerpt: "This lesson covers how to overlay raster data on top of a hillshade in Python and layer opacity arguments."
authors: ['Leah Wasser']
modified: 2020-02-01
category: [courses]
class-lesson: ['hw-lidar']
permalink: /courses/earth-analytics-python/lidar-raster-data/overlay-raster-maps/
nav-title: 'Overlay Rasters'
module-title: 'hw-lidar'
module-description: 'This module covers how overlay rasters to create visualizations and how to make interactive plots.'
module-nav-title: 'Interactive Maps'
module-type: 'class'
week: 2
sidebar:
  nav:
author_profile: false
comments: true
order: 1
class-order: 3
course: "earth-analytics-python"
topics:
  reproducible-science-and-programming:
  data-exploration-and-analysis: ['data-visualization']
  spatial-data-and-gis: ['raster-data', 'vector-data']
---
{% include toc title="In This Lesson" icon="file-text" %}

<div class='notice--success' markdown="1">

## <i class="fa fa-graduation-cap" aria-hidden="true"></i> Learning Objectives


After completing this tutorial, you will be able to:
* Overlay 2 rasters in `Python` to create a plot.


## <i class="fa fa-check-square-o fa-2" aria-hidden="true"></i> What You Need

You need `Python` and `Jupyer Notebook` to complete this tutorial. You should also have an `earth-analytics` directory setup on your computer with a `data` subdirectory within it. You should have completed the lesson on <a href="{{ site.url }}/workshops/setup-earth-analytics-python/">Setting Up the Conda Environment.</a>.

{% include/data_subsets/course_earth_analytics/_data-colorado-flood.md %}

</div>

{:.input}
```python
import os
import numpy as np
import matplotlib.pyplot as plt
import rasterio as rio
import earthpy as et
import earthpy.plot as ep

# Import data from EarthPy
data = et.data.get_data('colorado-flood')
# Set working directory
os.chdir(os.path.join(et.io.HOME, 'earth-analytics'))
```

## Overlay Rasters in `Python`

In this lesson, you will learn about overlaying rasters on top of a hillshade for nicer looking plots in `python`. To overlay a raster will will plot two different raster datasets in the same plot in `matplotlib`. You will use alpha to adjust the transparency of one of your rasters so the terrain hillshade gives the raster texture! Also you will turn of the legend for the hillshade plot as the legend we want to see is the DEM elevation values.

### What is a Hillshade?

A hillshade is a representation of the earth's surface as it would look with shade and shadows from the sun. You often render a hillshade using a greyscale colorramp.

Hillshades make nice underlays for other data as they emphasize the topography visually. This adds depth to your map!

To begin, open up both the Digital Terrain Model and the Digital terrain model hillshade files.


{:.input}
```python
# Open raster DTM data
with rio.open("data/colorado-flood/spatial/boulder-leehill-rd/pre-flood/lidar/pre_DTM.tif") as lidar_dem:
    lidar_dem_im = lidar_dem.read(1, masked=True)

# Open dem hillshade
with rio.open("data/colorado-flood/spatial/boulder-leehill-rd/pre-flood/lidar/pre_DTM_hill.tif") as lidar_dem_hill:
    lidar_dem_hill = lidar_dem_hill.read(1, masked=True)
```

To plot both layers together, you add a alpha value to the dem image. This value makes the image more transparent. Below an alpha of .5 (50%) is applied. Play around with the alpha value to see how it impacts your map.


{:.input}
```python
fig, ax = plt.subplots(figsize=(10, 6))
ep.plot_bands(lidar_dem_im, ax=ax, cmap='viridis_r',
              title="Lidar Digital Elevation Model (DEM)\n overlayed on top of a hillshade")
ax.imshow(lidar_dem_hill, cmap='Greys', alpha=.5)
ax.set_axis_off()
plt.show()
```

{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}/images/courses/earth-analytics-python/02-intro-to-lidar-and-raster/interactive-maps/2018-02-05-maps01-overlay-rasters/2018-02-05-maps01-overlay-rasters_6_0.png" alt = "Plot of the Digital Elevation Model overlayed on top of a hillshade.">
<figcaption>Plot of the Digital Elevation Model overlayed on top of a hillshade.</figcaption>

</figure>



