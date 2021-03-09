---
layout: single
title: "Practice Opening and Plotting Landsat Data in Python Using Rasterio"
excerpt: "A set of activities for you to practice your skills using Landsat Data in Open Source Python."
authors: ['Leah Wasser', 'Nathan Korinek']
dateCreated: 2020-06-24
modified: 2021-03-09
category: [courses]
class-lesson: ['multispectral-remote-sensing-data-python-landsat']
permalink: /courses/use-data-open-source-python/multispectral-remote-sensing/landsat-in-Python/landsat-exercises/
nav-title: 'Landsat Exercises'
course: "intermediate-earth-data-science-textbook"
week: 5
sidebar:
  nav:
author_profile: false
comments: true
order: 6
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

* Practice your skills using Landsat data in Python.

</div>


{:.input}
```python
import os
from glob import glob

import matplotlib.pyplot as plt
import geopandas as gpd
import rioxarray as rxr
import xarray as xr
from shapely.geometry import mapping
import numpy as np
import numpy.ma as ma
import earthpy as et
import earthpy.spatial as es
import earthpy.plot as ep


# Download data and set working directory
data = et.data.get_data('cold-springs-fire')
os.chdir(os.path.join(et.io.HOME, 'earth-analytics', 'data'))
```

<div class="notice--warning alert alert-info" markdown="1">

## <i class="fa fa-pencil-square-o" aria-hidden="true"></i> Challenge 1: Open And Crop Your Data

Above, you opened up the landsat scene in the directory: `LC080340322016072301T1-SC20180214145802`. This data covers 
an area which a file occured near Nederland, Colorado. For this challenge, you will
work with data that was collected before the fire for the same area. 
Do the following:

1. Crop all of the bands (tif files with the word "band" in them,  in the `LC080340322016070701T1-SC20180214145604` directory using **xarray** `concat()` and **rioxarray** `rio.clip()`.
2. Make sure your fire boundary data is in the correct crs before clipping the array!
3. Plot the data using `ep.plot_bands()`

</div>


{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}/images/courses/intermediate-eds-textbook/05-multi-spectral-remote-sensing-python/landsat/2020-03-02-landsat-multispectral-06-landsat-data-exercises/2020-03-02-landsat-multispectral-06-landsat-data-exercises_4_0.png" alt = "Plot of each individual Landsat 8 band collected by glob and cropped by crop all. This image is of the Cold Springs Fire shorly before the fire.">
<figcaption>Plot of each individual Landsat 8 band collected by glob and cropped by crop all. This image is of the Cold Springs Fire shorly before the fire.</figcaption>

</figure>




<div class="notice--warning alert alert-info" markdown="1">

## <i class="fa fa-pencil-square-o" aria-hidden="true"></i> Challenge 2 (Optional): Plot CIR and RGB Images Using Landsat 

In <a href="https://www.earthdatascience.org/courses/use-data-open-source-python/multispectral-remote-sensing/landsat-in-Python/" target="_blank">this lesson which introduces working with Landsat data in open source 
    Python, </a> you learn how to plot both a color RGB and Color Infrared (CIR) images
    using landsat data. Create a figure below that has:

1. A color RGB image of the landsat data collected post fire
2. A CIR image of the landsat data collected post fire. 
 
HINT: You will need to set the correct band combinations for your plots to 
turn our properly. You will also have to mask out the nan values for your plot to work.

* For Regular color images use: `rgb=[3, 2, 1]`
* For color infrared use: `rgb=[4, 3, 2]`
</div>




{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}/images/courses/intermediate-eds-textbook/05-multi-spectral-remote-sensing-python/landsat/2020-03-02-landsat-multispectral-06-landsat-data-exercises/2020-03-02-landsat-multispectral-06-landsat-data-exercises_6_0.png" alt = "Plot of color RBG and CIR of the Cold Springs fire before the fire.">
<figcaption>Plot of color RBG and CIR of the Cold Springs fire before the fire.</figcaption>

</figure>



