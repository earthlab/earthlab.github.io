---
layout: single
title: "How lidar point clouds are converted to raster data formats"
excerpt: "Rasters are gridded data composed of pixels that store values, such as an image or elevation data file. Learn how a lidar data point cloud is converted to a raster format such as a GeoTIFF."
authors: ['Leah Wasser']
dateCreated: 2018-02-05
modified: 2020-03-18
category: [courses]
class-lesson: ['lidar-data-story']
permalink: /courses/use-data-open-source-python/data-stories/what-is-lidar-data/lidar-points-to-pixels-raster/
nav-title: 'Points to Pixels'
week: 9
course: 'intermediate-earth-data-science-textbook'
chapter: 21
sidebar:
  nav:
author_profile: false
comments: true
order: 3
topics:
  remote-sensing: ['lidar']
  earth-science: ['vegetation']
  spatial-data-and-gis: ['raster-data']
redirect_from:
  - "/courses/earth-analytics-python/lidar-raster-data/lidar-raster-data/"
  - "/courses/use-data-open-source-python/data-stories/lidar-raster-data/intro-lidar-raster-data"
---

{% include toc title="On This Page" icon="file-text" %}

<div class='notice--success' markdown="1">

## <i class="fa fa-graduation-cap" aria-hidden="true"></i> Learning Objectives

* Describe the basic process of how a lidar point cloud is converted into a raster.
* Describe the structural differences between a raster dataset and a lidar point cloud.

</div>

In the last lesson, you learned about lidar point clouds. In this lesson, you will learn how a point cloud is converted into a gridded or raster data format.


### How a Lidar System Records Points

Remember that lidar is an active remote sensing system that records reflected or returned light energy. A discrete return lidar system, records the strongest reflections of light as discrete or individual points. 

Each point has an associated X, Y and Z value associated with it. It also has an intensity which represents the amount of reflected light energy that returned to the sensor.

<figure>
   <a href="{{ site.url }}/images/earth-analytics/lidar-raster-data/waveform.png" target="_blank">
   <img src="{{ site.url }}/images/earth-analytics/lidar-raster-data/waveform.png" alt="Example of a lidar waveform"></a>
   <figcaption>An example lidar waveform. Source: NEON.
   </figcaption>
</figure>



## Gridded or Raster LiDAR Data Products

Point clouds provide a lot of information, scientifically. However, they can be difficult to work with given the size of the data and tools that are available to handle large volumns of points. 

LiDAR data products are often created and stored in a gridded or raster data format. The raster format can be easier for many people to work with and also is supported by many different commonly used software packages.

<figure class="half">
   <a href="{{ site.url }}/images/earth-analytics/lidar-raster-data/lidar-points-hill.png">
   <img src="{{ site.url }}/images/earth-analytics/lidar-raster-data/lidar-points-hill.png" alt="lidar data on top of a raster."></a>
   <a href="{{ site.url }}/images/earth-analytics/lidar-raster-data/lidar-points-hill-zoomout.png">
   <img src="{{ site.url }}/images/earth-analytics/lidar-raster-data/lidar-points-hill-zoomout.png" alt="LEFT: Lidar data points overlayed on top of a hillshade which represents elevation in a graphical 3-dimensional view. RIGHT: If you zoom in on a portion of the data, you will see
   that the elevation data consists of cells or pixels, And there are lidar data
   points that fall within most of the pixels."></a>
   <figcaption>LEFT: Lidar data points overlayed on top of a hillshade which represents elevation in a graphical 3-dimensional view. RIGHT: If you zoom in on a portion of the data, you will see
   that the elevation data consists of cells or pixels and there are lidar data
   points that fall within most of the pixels.
   </figcaption>
</figure>


For a review of raster data, check out the chapter on <a href="{{ site.url }}/courses/use-data-open-source-python/intro-raster-data-python/fundamentals-raster-data/intro-raster-data/" target="_blank">Fundamentals of Raster Data</a>. 


## Creating a Raster from LiDAR Point Clouds

There are different ways to create a raster from LiDAR point clouds. Let's look at one of the most basic ways to create a raster file points - gridding. When you grid raster data, you calculate a value for each pixel or cell in your raster dataset using the points that are spatially located within that cell. To do this:

1. A grid is placed on top of the LiDAR data in geographic space. Each cell in
the grid has the same spatial dimensions. These dimensions represent that particular area on the ground. If you want to derive a 1 m resolution raster from the lidar data, you will overlay a 1m by 1m grid over the LiDAR data points.
2. Within each 1 m x 1 m cell, you calculate a value to be applied to that cell,
using the LiDAR points found within that cell. The simplest method of doing this is to take the max, min or mean height value of all lidar points found within the 1 m cell. If you use this approach, you might have cells in the raster that do not contain any lidar points. These cells will have a "no data" value if you process your raster in this way.

### Point to Raster Methods - Interpolation

A different approach is to interpolate the value for each cell. Interpolation considers the values of points outside of the cell in addition to points within the cell to calculate a value. Interpolation also often uses statistical operations (math) to calculate the cell value. 

Interpolation is useful because it can provide you with some ability to predict or calculate cell values in areas where there are no data (or no points), and to quantify the error associated with those predictions (which is useful to know if you are doing research).

You will not learn about interpolation in today's class, but will learn about it later in this course. 


<figure>
  <a href="{{ site.url }}/images/earth-analytics/lidar-raster-data/gridding.gif">
  <img src="{{ site.url }}/images/earth-analytics/lidar-raster-data/gridding.gif" alt="Animation Showing the general process of taking lidar point clouds and converting them to a Raster Format"></a>
  <figcaption>
  Animation Showing the general process of taking lidar point clouds and
  converting them to a Raster Format. Source: Tristan Goulden, NEON.
  </figcaption>
</figure>



