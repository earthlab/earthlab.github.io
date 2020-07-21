---
layout: single
title: "Layer a raster dataset over a hillshade in Python to create a beautiful basemap that represents topography."
excerpt: "A hillshade is a representation of the earth's surface as it would look with shade and shadows from the sun. Learn how to overlay raster data on top of a hillshade in Python."
authors: ['Leah Wasser']
dateCreated: 2018-02-05
modified: 2020-07-21
category: [courses]
class-lesson: ['customize-raster-plots']
permalink: /courses/scientists-guide-to-plotting-data-in-python/plot-spatial-data/customize-raster-plots/overlay-raster-maps/
nav-title: 'Overlay Rasters'
week: 2
sidebar:
  nav:
author_profile: false
comments: true
order: 2
course: 'scientists-guide-to-plotting-data-in-python-textbook'
topics:
  reproducible-science-and-programming:
  data-exploration-and-analysis: ['data-visualization']
  spatial-data-and-gis: ['raster-data', 'vector-data']
redirect_from:
  - "/courses/earth-analytics-python/lidar-raster-data/overlay-raster-maps/"
---

{% include toc title="On This Page" icon="file-text" %}

<div class='notice--success' markdown="1">

## <i class="fa fa-graduation-cap" aria-hidden="true"></i> Learning Objectives

* Overlay two rasters in **Python** to create a plot.

</div>


## Overlay Rasters in Python

In this lesson, you will learn about overlaying rasters on top of a hillshade for nicer looking plots in **Python**. 

To overlay a raster, you will plot two different raster datasets in the same plot in **matplotlib** such as a Digital Terrain Model (DTM) and a hillshade raster. 

You will use the `alpha` parameter of `ep.plot_bands` to adjust the transparency of rasters, so that the terrain hillshade gives the DTM raster texture! You will also turn off the legend for the hillshade, as the legend you want to see is the DTM elevation values.


### What is a Hillshade?

A hillshade is a representation of the earth's surface as it would look with shade and shadows from the sun. You often render a hillshade using a greyscale colorramp.

Hillshades make nice underlays for other data as they emphasize the topography visually. This adds depth to your map!

To begin, open up both the Digital Terrain Model (DTM) and the DTM hillshade files.

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
# Open DTM data
lidar_dem_path = os.path.join("data", "colorado-flood", "spatial", 
                              "boulder-leehill-rd", "pre-flood", 
                              "lidar", "pre_DTM.tif")

with rio.open(lidar_dem_path) as lidar_dem:
    lidar_dem_im = lidar_dem.read(1, masked=True)

# Open DTM hillshade
lidar_hs_path = os.path.join("data", "colorado-flood", "spatial", 
                              "boulder-leehill-rd", "pre-flood", 
                              "lidar", "pre_DTM_hill.tif")

with rio.open(lidar_hs_path) as lidar_dem_hill:
    lidar_dem_hill = lidar_dem_hill.read(1, masked=True)
```

To plot both layers together, you use the same `ax` object for the two layers, and then add a `alpha` value to the DTM hillshade image. This value makes the image more transparent. 

Below an` alpha` of 0.5 (50%) is applied. Play around with the alpha value to see how it impacts your map.

{:.input}
```python
fig, ax = plt.subplots(figsize=(10, 6))

ep.plot_bands(lidar_dem_im, 
              ax=ax, 
              cmap='viridis_r',
              title="Lidar Digital Terrain Model (DTM)\n overlayed on top of a hillshade")

ep.plot_bands(lidar_dem_hill, 
              cmap='Greys', 
              alpha=0.5, 
              ax=ax, 
              cbar=False)

ax.set_axis_off()

plt.show()
```

{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}/images/courses/plot-data-in-python-textbook/02-plot-spatial-data/raster-plots/2018-02-05-maps02-overlay-rasters/2018-02-05-maps02-overlay-rasters_5_0.png" alt = "Plot of the Digital Elevation Model overlayed on top of a hillshade.">
<figcaption>Plot of the Digital Elevation Model overlayed on top of a hillshade.</figcaption>

</figure>



