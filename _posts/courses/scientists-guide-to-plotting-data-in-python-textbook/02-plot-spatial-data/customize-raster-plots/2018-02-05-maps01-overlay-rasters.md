---
layout: single
title: "Layer a raster dataset over a hillshade in Python to create a beautiful basemap that represents topography."
excerpt: "A hillshade is a representation of the earth's surface as it would look with shade and shadows from the sun. Learn how to overlay raster data on top of a hillshade in Python."
authors: ['Leah Wasser']
dateCreated: 2018-02-05
modified: 2020-01-30
category: [courses]
class-lesson: ['customize-raster-plots']
permalink: /courses/scientists-guide-to-plotting-data-in-python/plot-spatial-data/customize-raster-plots/overlay-raster-maps/
nav-title: 'Overlay Rasters'
module-title: 'Customize Plots of Raster Data'
module-description: 'This module covers how overlay rasters to create visualizations and how to make interactive plots.'
module-nav-title: 'Customize Raster Plots'
module-type: 'class'
chapter: 4
week: 2
sidebar:
  nav:
author_profile: false
comments: true
order: 1
class-order: 2
course: 'scientists-guide-to-plotting-data-in-python-textbook'
topics:
  reproducible-science-and-programming:
  data-exploration-and-analysis: ['data-visualization']
  spatial-data-and-gis: ['raster-data', 'vector-data']
redirect_from:
  - "/courses/earth-analytics-python/lidar-raster-data/overlay-raster-maps/"
---

{% include toc title="In This Chapter" icon="file-text" %}

<div class='notice--success' markdown="1">

## <i class="fa fa-ship" aria-hidden="true"></i> Chapter Four - Customize Raster Plots

In this chapter, you will learn how to create and customize raster plots in **Python** using **earthpy**, **matplotlib**, and **folium**. 


## <i class="fa fa-graduation-cap" aria-hidden="true"></i> Learning Objectives

After completing this chapter, you will be able to:

* Overlay two rasters in **Python** to create a plot.
* Create interactive map in **Jupyter Notebook** using the **folium** package for **Python**.
* Overlay a raster on an interactive map created with **folium**.
* Customize a raster map in **Python** using **matplotlib**.


## <i class="fa fa-check-square-o fa-2" aria-hidden="true"></i> What You Need

You need **Python** and **Jupyer Notebook** to complete this chapter. You should also have an `earth-analytics` directory setup on your computer with a `data` subdirectory within it. You should have completed the lesson on <a href="{{ site.url }}/workshops/setup-earth-analytics-python/">Setting Up the Earth Analytics Python Conda Environment.</a>.

{% include/data_subsets/course_earth_analytics/_data-colorado-flood.md %}

</div>

## Overlay Rasters in Python

In this lesson, you will learn about overlaying rasters on top of a hillshade for nicer looking plots in **Python**. 

To overlay a raster, you will plot two different raster datasets in the same plot in **matplotlib**. You will use alpha to adjust the transparency of one of your rasters so the terrain hillshade gives the raster texture! 

You will also turn off the legend for the hillshade plot, as the legend we want to see is the DEM elevation values.

### What is a Hillshade?

A hillshade is a representation of the earth's surface as it would look with shade and shadows from the sun. You often render a hillshade using a greyscale colorramp.

Hillshades make nice underlays for other data as they emphasize the topography visually. This adds depth to your map!

To begin, open up both the Digital Terrain Model and the Digital terrain model hillshade files.

{:.input}
```python
import os
import matplotlib.pyplot as plt
import numpy as np
import rasterio as rio
import earthpy as et
import earthpy.plot as ep

# Import data from EarthPy
data = et.data.get_data('colorado-flood')

# Set working directory
os.chdir(os.path.join(et.io.HOME, 'earth-analytics'))
```

{:.output}
    Downloading from https://ndownloader.figshare.com/files/16371473
    Extracted output to /root/earth-analytics/data/colorado-flood/.



{:.input}
```python
# Open raster DTM data
lidar_dem_path = os.path.join("data", "colorado-flood", "spatial", 
                              "boulder-leehill-rd", "pre-flood", 
                              "lidar", "pre_DTM.tif")

with rio.open(lidar_dem_path) as lidar_dem:
    lidar_dem_im = lidar_dem.read(1, masked=True)

# Open dem hillshade
lidar_hs_path = os.path.join("data", "colorado-flood", "spatial", 
                              "boulder-leehill-rd", "pre-flood", 
                              "lidar", "pre_DTM_hill.tif")

with rio.open(lidar_hs_path) as lidar_dem_hill:
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

<img src = "{{ site.url }}/images/courses/scientists-guide-to-plotting-data-in-python-textbook/02-plot-spatial-data/customize-raster-plots/2018-02-05-maps01-overlay-rasters/2018-02-05-maps01-overlay-rasters_6_0.png" alt = "Plot of the Digital Elevation Model overlayed on top of a hillshade.">
<figcaption>Plot of the Digital Elevation Model overlayed on top of a hillshade.</figcaption>

</figure>



