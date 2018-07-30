---
layout: single
title: "Introduction to Lidar Raster Data Products"
excerpt: "This lesson introduces the raster geotiff file format - which is often used
to store lidar raster data. You learn the 3 key spatial attributes of a raster dataset
including Coordinate reference system, spatial extent and resolution."
authors: ['Leah Wasser']
modified: '2018-07-30'
category: [courses]
class-lesson: ['intro-lidar-raster-r']
permalink: /courses/earth-analytics/lidar-raster-data-r/open-lidar-raster-r/
nav-title: 'Open Raster Data R'
module-title: 'Lidar Raster Data R'
module-description: 'This module introduces the raster spatial data format as it
relates to working with lidar data in R. You will learn how to open, crop and classify raster data in
R. Also you will learn three commonly used lidar data products: the digital elevation model, digital surface model and the canopy height model.'
module-nav-title: 'Lidar Raster Data in R'
module-type: 'class'
week: 3
course: "earth-analytics"
sidebar:
  nav:
author_profile: false
comments: false
order: 1
class-order: 2
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

* Open a lidar raster dataset in `R`.
* List and define 3 spatial attributes of a raster dataset: extent, `crs` and resolution.
* Identify the resolution of a raster in `R`.
* Plot a lidar raster dataset in `R`.

## <i class="fa fa-check-square-o fa-2" aria-hidden="true"></i> What You Need

You will need a computer with internet access to complete this lesson.

If you have not already downloaded the week 3 data, please do so now.
[<i class="fa fa-download" aria-hidden="true"></i> Download week 3 data (~250 MB)](https://ndownloader.figshare.com/files/7446715){:data-proofer-ignore='' .btn }

</div>

In the last lesson, you reviewed the basic principles behind what a lidar raster
dataset is in `R` and how point clouds are used to derive the raster. In this lesson, you
will learn how to open and plot a lidar raster dataset in `R`. You will also learn
3 key attributes of a raster dataset:

1. Spatial resolution
2. Spatial extent
3. Coordinate reference system

<figure>
  <a href="{{ site.url }}/images/courses/earth-analytics/lidar-raster-data-r/gridding.gif">
  <img src="{{ site.url }}/images/courses/earth-analytics/lidar-raster-data-r/gridding.gif" alt="Animation Showing the general process of taking lidar point clouds and converting them to a Raster Format"></a>
  <figcaption>
  Animation that shows the general process of taking lidar point clouds and
  converting them to a Raster Format. Source: Tristan Goulden, NEON.
  </figcaption>
</figure>



## Open Raster Data in R

To work with raster data in `R`, you can use the `raster` and `rgdal` packages.


```r
# load libraries
library(raster)
library(rgdal)

# Make sure your working directory is set to  wherever your 'earth-analytics' dir is
# setwd("earth-analytics-dir-path-here")
```

You use the `raster("path-to-raster-here")` function to open a raster dataset in `R`.
Note that you use the `plot()` function to plot the data. The function argument
`main = ""` adds a title to the plot.


```r
# open raster data
lidar_dem <- raster(x = "data/week-03/BLDR_LeeHill/pre-flood/lidar/pre_DTM.tif")

# plot raster data
plot(lidar_dem,
     main = "Digital Elevation Model - Pre 2013 Flood")
```

<img src="{{ site.url }}/images/rfigs/courses/earth-analytics/03-lidar-raster-data/lidar-raster-intro/2017-02-01-raster01-open-lidar-raster-data-r/open-plot-raster-1.png" title="digital surface model raster plot" alt="digital surface model raster plot" width="90%" />

If you zoom in on a small section of the raster, you can see the individual pixels
that make up the raster. Each pixel has one value associated with it. In this
case that value represents the elevation of ground.

Note that you are using the `xlim=` argument to zoom in to on region of the raster.
You can use `xlim` and `ylim` to define the x and y axis extents for any plot.


```r
# zoom in to one region of the raster
plot(lidar_dem,
  xlim = c(473000, 473030), # define the x limits
  ylim = c(4434000, 4434030), # define y limits for the plot
     main = "Lidar Raster - Zoomed into one small region")
```

<img src="{{ site.url }}/images/rfigs/courses/earth-analytics/03-lidar-raster-data/lidar-raster-intro/2017-02-01-raster01-open-lidar-raster-data-r/plot-zoomed-in-raster-1.png" title="zoom in on a small part of a raster - see the pixels?" alt="zoom in on a small part of a raster - see the pixels?" width="90%" />

Next, let's discuss some of the important spatial attributes associated with raster
data.

## 1. Coordinate Reference System

The coordinate reference system (`CRS`) of a spatial object tells `R` where
the raster is located in geographic space. It also tells `R` what method should
be used to “flatten” or project the raster in geographic space.


<figure>
    <a href="{{ site.url }}/images/courses/earth-analytics/spatial-data/compare-mercator-utm-wgs-projections.jpg">
    <img src="{{ site.url }}/images/courses/earth-analytics/spatial-data/compare-mercator-utm-wgs-projections.jpg" alt="Maps of the United States in different projections. Notice the
    differences in shape associated with each different projection. These
    differences are a direct result of the calculations used to 'flatten' the
    data onto a 2-dimensional map. Source: M. Corey, opennews.org">
    </a>
    <figcaption> Maps of the United States in different projections. Notice the
    differences in shape associated with each different projection. These
    differences are a direct result of the calculations used to "flatten" the
    data onto a 2-dimensional map. Source: M. Corey, opennews.org</figcaption>
</figure>

### What Makes Spatial Data Line Up on a Map?

You will learn `CRS` in more detail in next weeks class.
For this week, just remember that data from the same location
but saved in **different coordinate references systems will not line up in any GIS or other
program**. Thus, it's important when working with spatial data in a program like
`R` to identify the coordinate reference system applied to the data and retain
it throughout data processing and analysis.

### View Raster CRS in R

You can view the `CRS` string associated with your `R` object using the`crs()`
method. You can assign this string to an `R` object too.


```r
# view resolution units
crs(lidar_dem)
## CRS arguments:
##  +proj=utm +zone=13 +datum=WGS84 +units=m +no_defs +ellps=WGS84
## +towgs84=0,0,0

# assign crs to an object (class) to use for reprojection and other tasks
myCRS <- crs(lidar_dem)
myCRS
## CRS arguments:
##  +proj=utm +zone=13 +datum=WGS84 +units=m +no_defs +ellps=WGS84
## +towgs84=0,0,0
```

The `CRS` string for our `lidar_dem` object tells us that your data are in the UTM
projection.

<figure>
    <a href="{{ site.url }}/images/courses/earth-analytics/spatial-data/UTM-zones.png">
    <img src="{{ site.url }}/images/courses/earth-analytics/spatial-data/UTM-zones.png" alt="The UTM zones across the continental United States. Source:
   	Chrismurf, wikimedia.org."></a>
   	<figcaption> The UTM zones across the continental United States. Source:
   	Chrismurf, wikimedia.org.
		</figcaption>
</figure>

The `CRS` format, returned by `R`, is in a `PROJ 4` format. This means that the projection
information is strung together as a series of text elements, each of which
begins with a `+` sign.

 `+proj=utm +zone=18 +datum=WGS84 +units=m +no_defs +ellps=WGS84 +towgs84=0,0,0`

You'll focus on the first few components of the `CRS` in this tutorial.

* `+proj=utm` The projection of the dataset. Your data are in Universal
Transverse Mercator (`UTM`).
* `+zone=18` The `UTM` projection divides up the world into zones, this element
tells you which zone the data is in. Harvard Forest is in Zone 18.
* `+datum=WGS84` The datum was used to define the center point of the
projection. Your raster uses the `WGS84` datum.
* `+units=m` This is the **horizontal** units that the data are in. Your units
are meters.


<div class="notice--success" markdown="1">
<i fa fa-star></i>**Important:**
You are working with lidar data which has a Z or vertical value as well.
While the horizontal units often match the vertical units of a raster they don't
always! Be sure to check the metadata of your data to figure out the vertical
units!
</div>

## Spatial Extent

Next, let's discuss spatial extent. The spatial extent of a raster or spatial
object is the geographic area that the raster data covers.

<figure>
    <a href="{{ site.baseurl}}/images/courses/earth-analytics/raster-data/raster-spatial-extent-coordinates.png">
    <img src="{{ site.baseurl}}/images/courses/earth-analytics/raster-data/raster-spatial-extent-coordinates.png" alt="The spatial extent of vector data which you will learn next week.
    Notice that the spatial extent represents the rectangular area that the data cover.
    Thus, if the data are not rectangular (i.e. points OR an image that is rotated
    in some way) the spatial extent covers portions of the dataset where there are no data.
    Image Source: National Ecological Observatory Network (NEON).">
    </a>
    <figcaption> The spatial extent of raster data.
    Notice that the spatial extent represents the rectangular area that the data cover.
    Thus, if the data are not rectangular (i.e. points OR an image that is rotated in some way)
    the spatial extent covers portions of the dataset where there are no data.
    Image Source: National Ecological Observatory Network (NEON).
    </figcaption>
</figure>


<figure>
    <a href="{{ site.baseurl}}/images/courses/earth-analytics/spatial-data/spatial-extent.png">
    <img src="{{ site.baseurl}}/images/courses/earth-analytics/spatial-data/spatial-extent.png" alt="The spatial extent of vector data which you will learn next week.
    Notice that the spatial extent represents the rectangular area that the data cover.
    Thus, if the data are not rectangular (i.e. points OR an image that is rotated in some way)
    the spatial extent covers portions of the dataset where there are no data.
    Image Source: National Ecological Observatory Network (NEON)">
    </a>
    <figcaption> The spatial extent of vector data which you will learn next week.
    Notice that the spatial extent represents the rectangular area that the data cover.
    Thus, if the data are not rectangular (i.e. points OR an image that is rotated in some way)
    the spatial extent covers portions of the dataset where there are no data.
    Image Source: National Ecological Observatory Network (NEON)
    </figcaption>
</figure>

The spatial extent of an `R` spatial object represents the geographic "edge" or
location that is the furthest north, south, east and west. In other words, `extent`
represents the overall geographic coverage of the spatial object.

## Raster Resolution

A raster has horizontal (x and y) resolution. This resolution represents the
area on the ground that each pixel covers. The units for your data are in meters.
In this case, your data resolution is 1 x 1. This means that each pixel represents
a 1 x 1 meter area on the ground. You can figure out the units of this resolution
using the `crs()` function which you will use next.


```r
# what is the x and y resolution for your raster data?
xres(lidar_dem)
## [1] 1
yres(lidar_dem)
## [1] 1
```

<figure>
    <a href="{{ site.baseurl}}/images/courses/earth-analytics/raster-data/raster-pixel-resolution.png">
    <img src="{{ site.baseurl}}/images/courses/earth-analytics/raster-data/raster-pixel-resolution.png" alt="The spatial resolution of a raster refers the size of each cell. This size in turn relates to the area on the ground that the pixel represents. Source: Colin Williams, National Ecological Observatory Network (NEON) ">
    </a>
    <figcaption> The spatial resolution of a raster refers the size of each cell.
    This size in turn relates to the area on the ground that the pixel represents.
    Source: Colin Williams, National Ecological Observatory Network (NEON)
    </figcaption>
</figure>

### Resolution Units

Resolution as a number doesn't mean anything unless you know the units. You can
figure out the horizontal (x and y) units from the coordinate reference system
string.


```r
# view coordinate reference system
crs(lidar_dem)
## CRS arguments:
##  +proj=utm +zone=13 +datum=WGS84 +units=m +no_defs +ellps=WGS84
## +towgs84=0,0,0
```

Notice this string contains an element called **units=m**. This means the units
are in meters. You won't get into too much detail about coordinate reference strings
in this weeks class but they are important to be familiar with when working with spatial
data. You will learn them in more detail during the semester!


<div class="notice--info" markdown="1">

## Additional Resources

### About Coordinate Reference Systems

* <a href="http://spatialreference.org/ref/epsg/" target="_blank"> A comprehensive online library of CRS information.</a>
* <a href="https://docs.qgis.org/2.8/en/docs/gentle_gis_introduction/coordinate_reference_systems.html?highlight=coordinate%20reference%20system" target="_blank">QGIS Documentation - CRS Overview.</a>
* <a href="https://source.opennews.org/en-US/learning/choosing-right-map-projection/" target="_blank">Choosing the Right Map Projection.</a>
* <a href="https://www.nceas.ucsb.edu/~frazier/RSpatialGuides/OverviewCoordinateReferenceSystems.pdf" target="_blank"> NCEAS Overview of CRS in R.</a>

</div>
