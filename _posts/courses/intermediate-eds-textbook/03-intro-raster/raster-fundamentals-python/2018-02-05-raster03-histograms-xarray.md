---
layout: single
title: "Plot Histograms of Raster Values in Python"
excerpt: "Histograms of raster data provide the distribution of pixel values in the dataset. Learn how to explore and plot the distribution of values within a raster using histograms."
authors: ['Leah Wasser', 'Chris Holdgraf', 'Martha Morrissey']
dateCreated: 2018-02-06
modified: 2020-11-05
category: [courses]
class-lesson: ['intro-raster-python-tb']
permalink: /courses/use-data-open-source-python/intro-raster-data-python/fundamentals-raster-data/plot-raster-histograms/
nav-title: 'Plot Raster Histograms'
week: 3
course: 'intermediate-earth-data-science-textbook'
sidebar:
  nav:
author_profile: false
comments: false
order: 3
topics:
  reproducible-science-and-programming: ['python']
  spatial-data-and-gis: ['raster-data']
redirect_from:
  - "/courses/earth-analytics-python/lidar-raster-data/plot-raster-histograms/"
---

{% include toc title="On This Page" icon="file-text" %}

<div class='notice--success' markdown="1">

## <i class="fa fa-graduation-cap" aria-hidden="true"></i> Learning Objectives

* Explore the distribution of values within a raster using histograms.
* Plot a histogram of a raster dataset in **Python** using **matplotlib**.

</div>

In the last lesson, you learned about three key attributes of a raster dataset:

1. Spatial resolution
2. Spatial extent and
3. Coordinate reference systems

In this lesson, you will learn how to use histograms to better understand the
distribution of your data.


## Open Raster Data in Python

To work with raster data in **Python**, you can use the **rasterio** and **numpy** packages.
Remember you can use the **rasterio context manager** to import the raster object into **Python**.

{:.input}
```python
# Import necessary packages
import os
import matplotlib.pyplot as plt
import seaborn as sns
import numpy as np
import rioxarray as rxr
import earthpy as et

# Get data and set wd
et.data.get_data("colorado-flood")

os.chdir(os.path.join(et.io.HOME,
                      'earth-analytics',
                      'data'))

# Prettier plotting with seaborn
sns.set(font_scale=1.5, style="whitegrid")
```

As you did in the previous lessons, you can open your raster data using `rxr.open_rasterio()`.

{:.input}
```python
# Define relative path to file
lidar_dem_path = os.path.join("colorado-flood", 
                              "spatial",
                              "boulder-leehill-rd", 
                              "pre-flood", 
                              "lidar",
                              "pre_DTM.tif")

# Open data and mask nodata values
lidar_dem_im = rxr.open_rasterio(lidar_dem_path, masked=True)

# View object dimensions
lidar_dem_im.shape
```

{:.output}
{:.execute_result}



    (1, 2000, 4000)






## Raster Histograms - Distribution of Elevation Values


The histogram below represents the distribution of pixel elevation values in your
data. This plot is useful to:

1. Identify outlier data values
2. Assess the min and max values in your data
3. Explore the general distribution of elevation values in the data - i.e. is the area generally flat, hilly, is it high elevation or low elevation.

To begin, you will look at the shape of your lidar array object

{:.input}
```python
# Plot a histogram
f, ax = plt.subplots(figsize=(10, 6))
lidar_dem_im.plot.hist(ax=ax,
       color="purple")
ax.set(title="Distribution of Lidar DEM Elevation Values",
       xlabel='Elevation (meters)',
       ylabel='Frequency')
plt.show()

```

{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}/images/courses/intermediate-eds-textbook/03-intro-raster/raster-fundamentals-python/2018-02-05-raster03-histograms-xarray/2018-02-05-raster03-histograms-xarray_6_0.png" alt = "This plot displays a histogram of lidar dem elevation values.">
<figcaption>This plot displays a histogram of lidar dem elevation values.</figcaption>

</figure>





## What Does a Histogram Tell You?

A histogram shows us how the data are distributed. Each bin or bar in the plot
represents the number or frequency of pixels that fall within the range specified
by the bin.

You can use the `bins=` argument to specify fewer or more breaks in your histogram.
Note that this argument does not result in the exact number of breaks that you may
want in your histogram.


{:.input}
```python
# Plot a histogram
f, ax = plt.subplots(figsize=(10, 6))
lidar_dem_im.plot.hist(ax=ax,
                       color="purple",
                       bins=30)
ax.set(title="Distribution of Lidar DEM Elevation Values",
       xlabel='Elevation (meters)',
       ylabel='Frequency')
plt.show()
```

{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}/images/courses/intermediate-eds-textbook/03-intro-raster/raster-fundamentals-python/2018-02-05-raster03-histograms-xarray/2018-02-05-raster03-histograms-xarray_8_0.png" alt = "This plot displays a histogram of lidar dem elevation values with 3 bins.">
<figcaption>This plot displays a histogram of lidar dem elevation values with 3 bins.</figcaption>

</figure>




Alternatively, you can specify specific break points that you want **Python** to use when it
bins the data.

`bins=[1600, 1800, 2000, 2100]`

In this case, **Python** will count the number of pixels that occur within each value range
as follows:

* bin 1: number of pixels with values between 1600-1800
* bin 2: number of pixels with values between 1800-2000
* bin 3: number of pixels with values between 2000-2100


{:.input}
```python
f, ax = plt.subplots(figsize=(10, 6))
lidar_dem_im.plot.hist(ax=ax,
                       color="purple",
                       bins=[1600, 1800, 2000, 2100])
ax.set(title="Distribution of Lidar DEM Elevation Values",
       xlabel='Elevation (meters)',
       ylabel='Frequency')
plt.show()
```

{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}/images/courses/intermediate-eds-textbook/03-intro-raster/raster-fundamentals-python/2018-02-05-raster03-histograms-xarray/2018-02-05-raster03-histograms-xarray_10_0.png" alt = "This plot displays a histogram of lidar dem elevation values with 3 bins.">
<figcaption>This plot displays a histogram of lidar dem elevation values with 3 bins.</figcaption>

</figure>



