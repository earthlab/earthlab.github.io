---
layout: single
title: "Plot Histograms of Raster Values in Python"
excerpt: "This lesson introduces the raster geotiff file format - which is often used
to store lidar raster data. You cover the 3 key spatial attributes of a raster dataset
including Coordinate reference system, spatial extent and resolution."
authors: ['Leah Wasser', 'Chris Holdgraf', 'Martha Morrissey']
modified: 2018-08-07
category: [courses]
class-lesson: ['intro-lidar-raster-python']
permalink: /courses/earth-analytics-python/raster-lidar-intro/plot-raster-histograms/
nav-title: 'Plot Raster Histograms'
week: 3
course: "earth-analytics-python"
sidebar:
  nav:
author_profile: false
comments: false
order: 3
topics:
  reproducible-science-and-programming:
  remote-sensing: ['lidar']
  earth-science: ['vegetation']
  spatial-data-and-gis: ['raster-data']
---
{% include toc title="In This Lesson" icon="file-text" %}

<div class='notice--success' markdown="1">

## <i class="fa fa-graduation-cap" aria-hidden="true"></i> Learning Objectives

After completing this tutorial, you will be able to:

* Explore the distribution of values within a raster using histograms.
* Plot a histogram of a raster dataset in `Python` using `matplotlib`.

## <i class="fa fa-check-square-o fa-2" aria-hidden="true"></i> What You Need

You will need a computer with internet access to complete this lesson.

If you have not already downloaded the week 3 data, please do so now.
[<i class="fa fa-download" aria-hidden="true"></i> Download the 2013 Colorado Flood Teaching Data (~250 MB)](https://ndownloader.figshare.com/files/12395030){:data-proofer-ignore='' .btn }

</div>

In the last lesson, you discussed 3 key attributes of a raster dataset:

1. Spatial resolution
2. Spatial extent and
3. Coordinate reference systems

In this lesson, you will learn how to use histograms to better understand the
distribution of your data.


## Open Raster Data in Python

To work with raster data in `Python`, you can use the `rasterio` and `numpy` packages.
Remember you can use the `raserio context manager` to import the raster object into `Python`.

{:.input}
```python
import rasterio as rio
import matplotlib.pyplot as plt
import numpy as np
import os
# you will use this library to adjust your color bar height below
from mpl_toolkits.axes_grid1 import make_axes_locatable


plt.ion()
```

{:.input}
```python
import earthpy as et
os.chdir(os.path.join(et.io.HOME, 'earth-analytics'))
```

As you did in the previous lessons, you can open your raster data using `rio.open()`.

{:.input}
```python
# open data and reassign nan values

with rio.open('data/colorado-flood/spatial/boulder-leehill-rd/pre-flood/lidar/pre_DTM.tif') as src:
    lidar_dem_im = src.read()[0]
    lidar_dem_im[lidar_dem_im < 0] = np.nan
```


## Raster Histograms - Distribution of Elevation Values


The histogram below represents the distribution of pixel elevation values in your
data. This plot is useful to:

1. Identify outlier data values
2. Assess the min and max values in your data
3. Explore the general distribution of elevation values in the data - i.e. is the area generally flat, hilly, is it high elevation or low elevation.

To begin, you will look at the shape of your lidar array object

{:.input}
```python
# .ravel turns an 2-D array into a 1-D vector
print(lidar_dem_im.shape)
print(lidar_dem_im.ravel().shape)
```

{:.output}
    (2000, 4000)
    (8000000,)



{:.input}
```python
# Remove the `nan` values
lidar_dem_hist = lidar_dem_im.ravel()
lidar_dem_hist = lidar_dem_hist[~np.isnan(lidar_dem_hist)]
```

{:.input}
```python
#format histograms
plt.rcParams['figure.figsize'] = (8, 8)
plt.rcParams['axes.titlesize'] = 20
plt.rcParams['axes.facecolor']='white'
plt.rcParams['grid.color'] = 'grey'
plt.rcParams['grid.linestyle'] = '-'
plt.rcParams['grid.linewidth'] = '.5'
plt.rcParams['lines.color'] = 'purple'
plt.rcParams['axes.labelsize'] = 16
```

{:.input}
```python
fig = plt.figure(figsize = (14,14))
ax = fig.add_subplot(111)
ax.hist(lidar_dem_hist, color='purple')
ax.set(xlabel = 'Elevation (meters)', ylabel = 'Frequency')
ax.set_title("Distribution of surface elevation values", fontsize = 17);
```

{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}//images/courses/earth-analytics-python/03-into-to-lidar-and-raster/lidar-raster-intro/2018-02-05-raster03-plot-raster-histograms_10_0.png">

</figure>





## What Does a Histogram Tell You?

A histogram shows us how the data are distributed. Each bin or bar in the plot
represents the number or frequency of pixels that fall within the range specified
by the bin.

You can use the `breaks=` argument to specify fewer or more breaks in your histogram.
Note that this argument does not result in the exact number of breaks that you may
want in your histogram.


{:.input}
```python
fig = plt.figure(figsize = (14,14))
ax = fig.add_subplot(111)
ax.hist(lidar_dem_hist, color='purple', bins=3)
ax.set_title("Distribution of surface elevation values",
            fontsize=16)
ax.set_xlabel('Elevation (meters)', fontsize=16)
ax.set_ylabel('Frequency', fontsize=16);
```

{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}//images/courses/earth-analytics-python/03-into-to-lidar-and-raster/lidar-raster-intro/2018-02-05-raster03-plot-raster-histograms_12_0.png">

</figure>




Alternatively, you can specify specific break points that you want `Python` to use when it
bins the data.

`bins=[1600, 1800, 2000, 2100]`

In this case, `Python` will count the number of pixels that occur within each value range
as follows:

* bin 1: number of pixels with values between 1600-1800
* bin 2: number of pixels with values between 1800-2000
* bin 3: number of pixels with values between 2000-2100


{:.input}
```python
fig, ax = plt.subplots()
ax.hist(lidar_dem_hist, bins=[1600, 1800, 2000, 2100], color='purple')
ax.set_title("Distribution of surface elevation values \n 3 histogram bins",
            fontsize=16)
ax.set_xlabel('Elevation (meters)')
ax.set_ylabel('Frequency');
```

{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}//images/courses/earth-analytics-python/03-into-to-lidar-and-raster/lidar-raster-intro/2018-02-05-raster03-plot-raster-histograms_14_0.png">

</figure>



