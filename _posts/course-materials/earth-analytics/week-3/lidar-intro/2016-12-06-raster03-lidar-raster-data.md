---
layout: single
title: "Introduction to lidar raster data products"
excerpt: "This lesson reviews how a lidar data point cloud is converted to a raster."
authors: ['Leah Wasser', 'NEON Data Skills']
lastModified: 2017-01-03
category: [course-materials]
class-lesson: ['class-lidar-r']
permalink: /course-materials/earth-analytics/week-3/lidar-raster-data/
nav-title: 'LiDAR Raster Data'
week: 3
sidebar:
  nav:
author_profile: false
comments: false
order: 3
---


<div class='notice--success' markdown="1">

## <i class="fa fa-graduation-cap" aria-hidden="true"></i> Learning Objectives

After completing this tutorial, you will be able to:

* Describe the basic process of how a lidar point cloud is converted into a raster.
*

## <i class="fa fa-check-square-o fa-2" aria-hidden="true"></i> What You Need

You will need a computer with internet access to complete this lesson.

</div>

In the last lesson, we learned about lidar points clouds. In this lesson, we
will learn how a point cloud is converted into a gridded or raster data format.

## create a graphic of lidar points and then a raster version??

<figure>
   <a href="{{ site.url }}/images/course-materials/earth-analytics/week-3/#">
   <img src="#" alt="Lidar data collected by NEON AOP"></a>
   <figcaption>Caption here.
   </figcaption>
</figure>


### How A Lidar system records points

Remember that lidar is an active remote sensing system that records reflected
or returned light energy. A discrete return lidar system, records the strongest
reflections of light as discrete or individual points. Each point has an associated
X, Y and Z value associated with it.  It also has an intensity which represents
the amount of energy that returned to the sensor.

<figure>
   <a href="{{ site.url }}/images/course-materials/earth-analytics/week-3/waveform.png" target="_blank">
   <img src="{{ site.url }}/images/course-materials/earth-analytics/week-3/waveform.png" alt="Example of a lidar waveform"></a>
   <figcaption>An example LiDAR waveform. Source: National Ecological
   Observatory Network, Boulder, CO - image
available on <a href="https://flic.kr/s/aHsk4W4cdP" target="_blank"> Flickr</a>.
   </figcaption>
</figure>


## Gridded or Raster LiDAR Data Products
Point clouds provide a lot of information, scientifically, however they can be
difficult to work with given the size of the data. LiDAR data products are often
created and stored in a gridded or raster data format. A raster file is a
regular grid of cells, all of which are the same size.


<figure>
   <a href="{{ site.url }}/images/course-materials/earth-analytics/week-3/raster-concept.png" target="_blank">
   <img src="{{ site.url }}/images/course-materials/earth-analytics/week-3/raster-concept.png" alt="Raster data concept diagram."></a>
   <figcaption>A raster is composed of a regular grid of cells. Each cell is the same
   size in the x and y direction. Source: Colin Williams, NEON.
   </figcaption>
</figure>

A few notes about rasters:

-  Each cell is called a pixel.
-  And each pixel represents an area on the ground.
-  The resolution of the raster represents the area that each pixel represents
- on the ground. So, for instance if the raster is 1 m resolution, that simple
- means that each pixel represents a 1 m by 1m area on the ground.

Raster data can have attributes associated with it as well. For instance in a
LiDAR derived digital elevation model (DEM), each cell might represent a
particular elevation value.  In a LIDAR derived intensity image, each cell
represents a LIDAR intensity value.

<figure>
   <a href="{{ site.url }}/images/course-materials/earth-analytics/week-3/raster-resolution.png" target="_blank">
   <img src="{{ site.url }}/images/course-materials/earth-analytics/week-3/raster-resolution.png" alt="Raster data resolution concept diagram."></a>
   <figcaption>Raster can be stored at different resolutions. The resolution simply
   represents the size of each pixel cell. Source: Colin Williams, NEON.
   </figcaption>
</figure>

## Creating A Raster From LiDAR Point Clouds

There are different ways to create a raster from LiDAR point clouds. Let's look
at one of the most basic ways to create a raster file points - gridding.
When you grid raster data, you calculate a value for each pixel or cell in your
raster dataset using the points that are spatially located within that cell. To
do this:

1. A grid is placed on top of the LiDAR data in geographic space. Each cell in
the grid has the same spatial dimensions. These dimensions represent that
particular area on the ground. If we want to derive a 1 m resolution raster
from the lidar data, we overlay a 1m by 1m grid over the LiDAR data points.
2. Within each 1 m x 1 m cell, we calculate a value to be applied to that cell,
using the LiDAR points found within that cell. The simplest method of doing this
is to take the max, min or mean height value of all lidar points found within
the 1 m cell. If we use this approach, we might have cells in the raster that
don't contains any lidar points. These cells will have a "no data" value if we
process our raster in this way.

### Point to Raster Methods - Interpolation

A different approach is to interpolate the value for each cell. Interpolation
considers the values of points outside of the cell in addition to points within
the cell to calculate a value. Interpolation also often uses statistical operations
(math) to calculate the cell value. Interpolation is useful because it can provide us
with some ability to predict or calculate cell values in areas where there are
no data (or no points). And to quantify the error associated with those predictions
which is useful to know, if you are doing research.

We will not be talking about interpolation in today's class.

<figure>
  <a href="{{ site.url }}/images/course-materials/earth-analytics/week-3/gridding.gif">
  <img src="{{ site.url }}/images/course-materials/earth-analytics/week-3/gridding.gif" alt="Animation Showing the general process of taking lidar point clouds and converting them to a Raster Format"></a>
  <figcaption>
  Animation Showing the general process of taking lidar point clouds and
  converting them to a Raster Format. Source: Tristan Goulden, NEON.
  </figcaption>
</figure>

## Open Raster Data in R

To work with raster data in R, we can use the `raster` and `rgdal` packages.


```r

# load libraries
library(raster)
library(rgdal)

# set working directory to ensure R can find the file we wish to import
# setwd("working-dir-path-here")
```

We can use the `raster("path-to-raster-here")` function to open a raster in R.



```r

# open raster data
lidar_dsm <- raster(x="data/week3/lidar/post-flood/postDSM3.tif")

# plot raster data
plot(lidar_dsm)
```

![ ]({{ site.baseurl }}/images/rfigs/course-materials/earth-analytics/week-3/lidar-intro/2016-12-06-raster03-lidar-raster-data/open-plot-raster-1.png)

```r

lidar_dsm
## class       : RasterLayer
## dimensions  : 2000, 2000, 4e+06  (nrow, ncol, ncell)
## resolution  : 1, 1  (x, y)
## extent      : 473000, 475000, 4434000, 4436000  (xmin, xmax, ymin, ymax)
## coord. ref. : +proj=utm +zone=13 +datum=WGS84 +units=m +no_defs +ellps=WGS84 +towgs84=0,0,0
## data source : /Users/lewa8222/Documents/earth-analytics/data/week3/lidar/post-flood/postDSM3.tif
## names       : postDSM3
```

If we zoom in on a small section of the raster, we can see the individual pixels
that make up the raster. Each pixel has one value.


```r
plot(lidar_dsm, xlim=c(473000, 473050), ylim=c(4434000, 4434050),
     main="Lidar Raster - Zoomed into to one small region")
```

![ ]({{ site.baseurl }}/images/rfigs/course-materials/earth-analytics/week-3/lidar-intro/2016-12-06-raster03-lidar-raster-data/plot-zoomed-in-raster-1.png)


## histogram - look at the values of all of the pixels
## figure out the units of the data (x and y)
