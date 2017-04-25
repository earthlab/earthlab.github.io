---
layout: single
title: "Introduction to lidar raster data products"
excerpt: "This lesson reviews how to open a lidar raster dataset in R."
authors: ['Leah Wasser']
lastModified: '2017-04-25'
category: [course-materials]
class-lesson: ['class-lidar-r']
permalink: /course-materials/earth-analytics/week-3/open-lidar-raster-r/
nav-title: 'Open Raster Data R'
week: 3
sidebar:
  nav:
author_profile: false
comments: false
order: 4
tags2:
  scientific-programming: ['r']
  remote-sensing: ['lidar']
  earth-science: ['vegetation-change']
  spatial-data-and-gis: ['raster-data']
---

{% include toc title="In This Lesson" icon="file-text" %}

<div class='notice--success' markdown="1">

## <i class="fa fa-graduation-cap" aria-hidden="true"></i> Learning Objectives

After completing this tutorial, you will be able to:

* Open a lidar raster dataset in R.
* Be able to identify the resolution of a raster in R.
* Be able to plot a lidar raster dataset in R.

## <i class="fa fa-check-square-o fa-2" aria-hidden="true"></i> What You Need

You will need a computer with internet access to complete this lesson.

If you have not already downloaded the week 3 data, please do so now.
[<i class="fa fa-download" aria-hidden="true"></i> Download Week 3 Data (~250 MB)](https://ndownloader.figshare.com/files/7446715){:data-proofer-ignore='' .btn }

</div>

In the last lesson, we reviewed the basic principles behind what a lidar raster
dataset is in R and how point clouds are used to derive the raster. In this lesson, we
will learn how to open a plot a lidar raster dataset in `R`.

<figure>
  <a href="{{ site.url }}/images/course-materials/earth-analytics/week-3/gridding.gif">
  <img src="{{ site.url }}/images/course-materials/earth-analytics/week-3/gridding.gif" alt="Animation Showing the general process of taking lidar point clouds and converting them to a Raster Format"></a>
  <figcaption>
  Animation that shows the general process of taking lidar point clouds and
  converting them to a Raster Format. Source: Tristan Goulden, NEON.
  </figcaption>
</figure>



## Open Raster Data in R

To work with raster data in `R`, we can use the `raster` and `rgdal` packages.


```r
# load libraries
library(raster)
library(rgdal)

# Make sure your working directory is set to  wherever your 'earth-analytics' dir is
# setwd("earth-analytics-dir-path-here")
```

We use the `raster("path-to-raster-here")` function to open a raster dataset in `R`.
Note that we use the `plot()` function to plot the data. The function argument `main=""`
adds a title to the plot.


```r
# open raster data
lidar_dem <- raster(x="data/week3/BLDR_LeeHill/pre-flood/lidar/pre_DTM.tif")

# plot raster data
plot(lidar_dem,
     main="Digital Elevation Model - Pre 2013 Flood")
```

<img src="{{ site.url }}/images/rfigs/course-materials/earth-analytics/week-3/lidar-intro/2017-02-01-raster04-open-lidar-raster-data-r/open-plot-raster-1.png" title="digital surface model raster plot" alt="digital surface model raster plot" width="100%" />

If we zoom in on a small section of the raster, we can see the individual pixels
that make up the raster. Each pixel has one value associated with it. In this
case that value represents the elevation of ground.

Note that we are using the `xlim=` argument to zoom in to on region of the raster.
You can use `xlim` and `ylim` to define the x and y axis extents for any plot.


```r
# zoom in to one region of the raster
plot(lidar_dem,
  xlim=c(473000, 473030), # define the x limits
  ylim=c(4434000, 4434030), # define y limits for the plot
     main="Lidar Raster - Zoomed into to one small region")
```

<img src="{{ site.url }}/images/rfigs/course-materials/earth-analytics/week-3/lidar-intro/2017-02-01-raster04-open-lidar-raster-data-r/plot-zoomed-in-raster-1.png" title="zoom in on a small part of a raster - see the pixels?" alt="zoom in on a small part of a raster - see the pixels?" width="100%" />

## Raster Resolution

A raster has horizontal (x and y) resolution. This resolution represents the
area on the ground that each pixel covers. The units for our data are in meters.
In this case, our data resolution is 1 x 1. This means that each pixel represents
a 1 x 1 meter area on the ground. We can figure out the units of this resolution
using the `crs()` function which we will use next.


```r
# what is the x and y resolution for our raster data?
xres(lidar_dem)
## [1] 1
yres(lidar_dem)
## [1] 1
```

### Resolution units

Resolution as a number doesn't mean anything unless we know the units. We can
figure out the horizontal (x and y) units from the coordinate reference system
string.


```r
# view coordinate refence system
crs(lidar_dem)
## CRS arguments:
##  +proj=utm +zone=13 +datum=WGS84 +units=m +no_defs +ellps=WGS84
## +towgs84=0,0,0
```

Notice this string contains an element called **units=m**. This means the units
are in meters. We won't get into too much detail about coordinate refence strings
in this weeks class but they are important to be familiar with when working with spatial
data. We will cover them in more detail during the semester!

## Distribution of elevation values

We can view the distribution of elevation values in our data too. This is useful
for identifying outlier data values. Notice that we are using the `xlab` and `ylab`
arguments to label our plot axes.


```r
# plot histogram
hist(lidar_dem,
     main="Distribution of surface elevation values",
     xlab="Elevation (meters)", ylab="Frequency",
     col="springgreen")
```

<img src="{{ site.url }}/images/rfigs/course-materials/earth-analytics/week-3/lidar-intro/2017-02-01-raster04-open-lidar-raster-data-r/view-hist-1.png" title="histogram of DEM elevation values" alt="histogram of DEM elevation values" width="100%" />


<div class="notice--warning" markdown="1">

## <i class="fa fa-pencil-square-o" aria-hidden="true"></i> In-class challenge - import DSM

* Import the file: `data/week3/BLDR_LeeHill/pre-flood/lidar/pre_DSM_hill.tif`

Plot the data and a histogram of the data. What do the elevations in the DSM
represent? Are they different from the DTM? Discuss this with your neighbor.

* What is the CRS and spatial resolution for this dataset? What units is the spatial
resolution in?
<!-- Yes - they are the same for both files you can figure this out using
crs() and xres()  / yres() -->

</div>

<img src="{{ site.url }}/images/rfigs/course-materials/earth-analytics/week-3/lidar-intro/2017-02-01-raster04-open-lidar-raster-data-r/class-challenge-1.png" title="DSM histogram and plot" alt="DSM histogram and plot" width="100%" /><img src="{{ site.url }}/images/rfigs/course-materials/earth-analytics/week-3/lidar-intro/2017-02-01-raster04-open-lidar-raster-data-r/class-challenge-2.png" title="DSM histogram and plot" alt="DSM histogram and plot" width="100%" />
