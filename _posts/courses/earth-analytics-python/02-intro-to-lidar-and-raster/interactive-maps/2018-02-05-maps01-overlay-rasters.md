---
layout: single
title: "Layer a raster dataset over a hillshade in Python to create a beautiful basemap that represents topography."
excerpt: "This lesson covers how to overlay raster data on top of a hillshade in Python and layer opacity arguments."
authors: ['Leah Wasser']
modified: 2018-09-04
category: [courses]
class-lesson: ['hw-lidar']
permalink: /courses/earth-analytics-python/lidar-raster-data/overlay-raster-maps
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

You need `Python` and `Jupyer Notebooks` to complete this tutorial. Also you should have an `earth-analytics` directory setup on your computer with a `/data` directory with it.

* [Earth Analytics Conda Environment](/courses/earth-analytics-python/get-started-with-python-jupyter/setup-conda-earth-analytics-environment/)

{% include/data_subsets/course_earth_analytics/_data-colorado-flood.md %}

</div>

### Be sure to set your working directory
`os.chdir("path-to-you-dir-here/earth-analytics/data")`

{:.input}
```python
import rasterio as rio
import numpy as np
import matplotlib.pyplot as plt
import os
import earthpy as et
plt.ion()
```

## Overlay Rasters in `Python`

Here, you will learn about overlaying rasters on top of a hillshade for nicer looking plots in `python`. To overlay a raster will will plot two different raster datasets in the same plot in `matplotlib`. You will use alpha to adjust the transparency of one of your rasters so the terrain hillshade gives the raster texture! Also you will turn of the legend for the hillshade plot as the legend we want to see is the DEM elevation values.

{:.input}
```python
# open raster DTM data
with rio.open("data/colorado-flood/spatial/boulder-leehill-rd/pre-flood/lidar/pre_DTM.tif") as lidar_dem:
    lidar_dem_im = lidar_dem.read(masked = True)[0]
    lidar_dem_im[lidar_dem_im < 0] = np.nan


# open dem hillshade
with rio.open("data/colorado-flood/spatial/boulder-leehill-rd/pre-flood/lidar/pre_DTM_hill.tif") as lidar_dem_hill:
    lidar_dem_hill = lidar_dem_hill.read(masked = True)[0]
```

{:.input}
```python
fig, ax = plt.subplots()
ax.imshow(lidar_dem_hill, cmap='Greys')
fin_plot = ax.imshow(lidar_dem_im, cmap='viridis_r', alpha=.5)
fig.colorbar(fin_plot, fraction=.024, pad=.02)
ax.set_axis_off()
ax.set(title="Lidar Digital Elevation Model (DEM)\n overlayed on top of a hillshade");
```

{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}//images/courses/earth-analytics-python/02-intro-to-lidar-and-raster/interactive-maps/2018-02-05-maps01-overlay-rasters_5_0.png">

</figure>



