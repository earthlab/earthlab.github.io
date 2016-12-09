---
layout: single
title: 'Convert Lidar Point Clouds to Rasters'
authors: [Leah Wasser]
excerpt: "The overview page I used at CU 5 April 2016."
category: [course-materials]
class-lesson: ['veg-structure-lidar']
permalink: /course-materials/lidar-point-to-raster
nav-title: 'Point 2 raster'
sidebar:
  nav:
author_profile: false
comments: false
order: 3
---

## Overview

<div class='notice--success' markdown="1">

# Learning Outcomes

* Be able to describe what discrete lidar system measures.
* Be able to describe the format of data that a discrete return lidar system produces.

****

**Estimated Time:** 1-2 hours

[Download Lesson Data](#){: .btn .btn--large}
</div>


## Creating A Raster From LiDAR Point Clouds
There are different ways to create a raster from LiDAR point clouds. Let's look one of the most basic ways to create a raster file points- basic gridding. When you perform a gridding algorithm, you are simply calculating a value, using point data, for each pixels in your raster dataset. To do this:

1. To begin, a grid is placed on top of the LiDAR data in space. Each cell in the grid has the same spatial dimensions. These dimensions represent that particular area on the ground. If we want to derive a 1 m resolution raster from the lidar data, we overlay a 1m by 1m grid over the LiDAR data points.
2. Within each 1 m x 1 m cell, we calculate a value to be applied to that cell, using the LiDAR points found within that cell. The simplest method of doing this is to take the max, min or mean height value of all lidar points found within the 1 m cell. If we use this approach, we might have cells in the raster that don't contains any lidar points. These cells will have a "no data" value if we process our raster in this way.

### Point to Raster Methods - Interpolation
A different approach is to interpolate the value for each cell. Interpolation considers the values of points outside of the cell in addition to points within the cell to calculate a value. Interpolation is useful because it can provide us with some ability to predict or calculate cell values in areas where there are no data (or no points). And to quantify the error associated with those predictions which is useful to know, if you are doing research.

# FIND IMAGE BELOW
 url="http://neondataskills.org/images/gridding.gif" description="Animation Showing the general process of taking lidar point clouds and converting them to a Raster Format. Credits: Tristan Goulden, National Ecological Observatory Network"


## Three Common LiDAR Data Products
- [Digital Terrain Model](http://neonhighered.org/3dRasterLidar/DTM.html) - This product represents the ground.
- [Digital Surface Model](http://neonhighered.org/3dRasterLidar/DSM.html) - This represents the top of the surface (so imagine draping a sheet over the canopy of a forest).
- [Canopy Height Model](http://neonhighered.org/3dRasterLidar/CHM.html) - This represents the elevation of the Earth's surface - and it sometimes also called a DEM or digital elevation model.

<figure class="third">
    <a href="http://neonhighered.org/3d/SJER_DSM_3d.html"><img src="{{ site.baseurl }}/images/course-materials/lidar/dsm.png"></a>
    <a href="http://neonhighered.org/3d/SJER_DTM_3d.html"><img src="{{ site.baseurl }}/images/course-materials/lidar/dem.png"></a>
    <a href="http://neonhighered.org/3d/SJER_CHM_3d.html" target="_blank"><img src="{{ site.baseurl }}/images/course-materials/lidar/chm.png"></a>

    <figcaption> 3d models of a: LEFT: lidar derived digital surface model (DSM) , MIDDLE: Digital Elevation Model (DEM) and RIGHT: Canopy Height Model (CHM). Click on the images to view interactive 3d models. </figcaption>
</figure>
