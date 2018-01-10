---
layout: single
title: "How Lidar Point Clouds Are Converted to Raster Data Formats - Remote Sensing"
excerpt: "This lesson reviews how a lidar data point cloud is converted to a raster format such as a geotiff."
authors: ['Leah Wasser']
modified: '2018-01-10'
category: [courses]
class-lesson: ['class-lidar-r']
permalink: /courses/earth-analytics/lidar-raster-data-r/lidar-raster-data/
nav-title: 'Intro Lidar Raster Data'
week: 3
course: "earth-analytics"
sidebar:
  nav:
author_profile: false
comments: false
order: 3
topics:
  remote-sensing: ['lidar']
  earth-science: ['vegetation']
  spatial-data-and-gis: ['raster-data']
---

{% include toc title="In This Lesson" icon="file-text" %}



<div class='notice--success' markdown="1">

## <i class="fa fa-graduation-cap" aria-hidden="true"></i> Learning Objectives

After completing this tutorial, you will be able to:

* Describe the basic process of how a lidar point cloud is converted into a raster.
* Describe the structural differences between a raster dataset and a lidar point cloud.

## <i class="fa fa-check-square-o fa-2" aria-hidden="true"></i> What You Need

You will need a computer with internet access to complete this lesson.

If you have not already downloaded the week 3 data, please do so now.
[<i class="fa fa-download" aria-hidden="true"></i> Download week 3 data (~250 MB)](https://ndownloader.figshare.com/files/7446715){:data-proofer-ignore='' .btn }

</div>

In the last lesson, you learned about lidar points clouds. In this lesson, you
will learn how a point cloud is converted into a gridded or raster data format.


### How a Lidar System Records Points

Remember that lidar is an active remote sensing system that records reflected
or returned light energy. A discrete return lidar system, records the strongest
reflections of light as discrete or individual points. Each point has an associated
`X`, `Y` and `Z` value associated with it. It also has an intensity which represents
the amount of reflected light energy that returned to the sensor.

<figure>
   <a href="{{ site.url }}/images/courses/earth-analytics/lidar-raster-data-r/waveform.png" target="_blank">
   <img src="{{ site.url }}/images/courses/earth-analytics/lidar-raster-data-r/waveform.png" alt="Example of a lidar waveform"></a>
   <figcaption>An example lidar waveform. Source: NEON.
   </figcaption>
</figure>


## Gridded or Raster Lidar Data Products
Point clouds provide a lot of information, scientifically. However, they can be
difficult to work with given the size of the data and tools that are available
to handle large volumns of points. Lidar data products are often
created and stored in a gridded or raster data format. The raster format can be
easier for many people to work with and also is supported by many different
commonly used software packages.

<figure class="half">
   <a href="{{ site.url }}/images/courses/earth-analytics/lidar-raster-data-r/lidar-points-hill.png">
   <img src="{{ site.url }}/images/courses/earth-analytics/lidar-raster-data-r/lidar-points-hill.png" alt="lidar data on top of a raster."></a>
   <a href="{{ site.url }}/images/courses/earth-analytics/lidar-raster-data-r/lidar-points-hill-zoomout.png">
   <img src="{{ site.url }}/images/courses/earth-analytics/lidar-raster-data-r/lidar-points-hill-zoomout.png" alt="LEFT: Lidar data points overlayed on top of a hillshade which represents elevationin a graphical 3-dimensional view. RIGHT: If you zoom in on a portion of the data, you will see
   that the elevation data consists of cells or pixels, And there are lidar data
   points that fall within most of the pixels."></a>
   <figcaption>LEFT: Lidar data points overlayed on top of a hillshade which represents elevationin a graphical 3-dimensional view. RIGHT: If you zoom in on a portion of the data, you will see
   that the elevation data consists of cells or pixels and there are lidar data
   points that fall within most of the pixels.
   </figcaption>
</figure>


## What is a Raster?

Raster or “gridded” data are stored as a grid of values which are rendered on a
map as pixels. Each pixel value represents an area on the Earth’s surface.
A raster file is a composed of regular grid of cells, all of which are the same
size. You've looked at and used rasters before if you've looked at photographs
or imagery in a tool like Google Earth. However, the raster files that you will
work with are different from photographs in that they are spatially referenced.
Each pixel represents an area of land on the ground. That area is defined by
the spatial **resolution** of the raster.


<figure>
   <a href="{{ site.url }}/images/courses/earth-analytics/raster-data/raster-concept.png" target="_blank">
   <img src="{{ site.url }}/images/courses/earth-analytics/raster-data/raster-concept.png" alt="Raster data concept diagram."></a>
   <figcaption>A raster is composed of a regular grid of cells. Each cell is the same
   size in the x and y direction. Source: Colin Williams, NEON.
   </figcaption>
</figure>


### Raster Facts

A few notes about rasters:

-  Each cell is called a pixel.
-  Each pixel represents an area on the ground.
-  The resolution of the raster is the area that each pixel represents
on the ground. So a 1-meter resolution raster means that each pixel represents
a 1m by 1m area on the ground.

A raster dataset can have attributes associated with it as well. For instance in a
lidar derived digital elevation model (DEM), each cell represents an elevation
value for that location on the earth. In a lidar derived intensity image, each cell
represents a lidar intensity value or the amount of light energy returned to and
recorded by the sensor.

<figure>
   <a href="{{ site.url }}/images/courses/earth-analytics/raster-data/raster-resolution.png" target="_blank">
   <img src="{{ site.url }}/images/courses/earth-analytics/raster-data/raster-resolution.png" alt="Raster data resolution concept diagram."></a>
   <figcaption>Rasters can be stored at different resolutions. The resolution simply
   represents the size of each pixel cell. Source: Colin Williams, NEON.
   </figcaption>
</figure>

## Creating a Raster from Lidar Point Clouds

### Point to Raster Methods - Gridding

There are different ways to create a raster from lidar point clouds. Let's look
at one of the most basic ways to create a raster file points: gridding.
When you grid raster data, you calculate a value for each pixel or cell in your
raster dataset using the points that are spatially located within that cell. To
do this:

1. A grid is placed on top of the lidar data in geographic space. Each cell in
the grid has the same spatial dimensions. These dimensions represent that
particular area on the ground. If you want to derive a 1m resolution raster
from the lidar data, you overlay a 1m by 1m grid over the lidar data points.
2. Within each 1m x 1m cell, you calculate a value to be applied to that cell,
using the lidar points found within that cell. The simplest method of doing this
is to take the max, min or mean height value of all lidar points found within
the 1m cell. If you use this approach, you might have cells in the raster that
don't contain any lidar points. These cells will have a "no data" value if you
process your raster in this way.

### Point to Raster Methods - Interpolation

A different approach is to interpolate the value for each cell. Interpolation
considers the values of points outside of the cell in addition to points within
the cell to calculate a value. Interpolation also often uses statistical operations
(math) to calculate the cell value. Interpolation is useful because it can provide us
with some ability to predict or calculate cell values in areas where there are
no data (or no points). And to quantify the error associated with those predictions
which is useful to know, if you are doing research.

You will not be talking about interpolation in today's class.

<figure>
  <a href="{{ site.url }}/images/courses/earth-analytics/lidar-raster-data-r/gridding.gif">
  <img src="{{ site.url }}/images/courses/earth-analytics/lidar-raster-data-r/gridding.gif" alt="Animation Showing the general process of taking lidar point clouds and converting them to a Raster Format"></a>
  <figcaption>
  Animation Showing the general process of taking lidar point clouds and
  converting them to a Raster Format. Source: Tristan Goulden, NEON.
  </figcaption>
</figure>


In the next lesson, you will learn how to open a lidar raster dataset in `R`.
