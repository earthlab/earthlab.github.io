---
layout: single
title: 'Lidar Point Clouds'
authors: [Leah Wasser]
excerpt: "The overview page I used at CU 5 April 2016."
category: [course-materials]
class-lesson: ['veg-structure-lidar']
permalink: /course-materials/veg-structure-lidar-point-clouds
nav-title: 'Point clouds'
sidebar:
  nav:
author_profile: false
comments: false
order: 2
published: false
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

## Discrete Return LiDAR Data
There are different types of lidar data. One common type is called **Discrete
return lidar**. In a discrete return lidar system, a pulse of energy is shot out
towards the earth's surface. Light energy then reflects off of objects that it
encounters on it's way down to the ground such as tree branches, power lines,
buildings and ofcourse the ground. Each reflection is called a return. Discrete
return systems record returns that are strongest (where the most light was reflected)
with some systems recording 1-4 returns per pulse of light emitted from the lidar
sensor.

Discrete return lidar data are recorded as *discrete* points, in X, Y, Z format creating what's known as a lidar point cloud.

### How discrete points are recorded:

<iframe width="560" height="315" src="//www.youtube.com/embed/uSESVm59uDQ?rel=0" frameborder="0" allowfullscreen></iframe>

In addition to
X, Y and Z (elevation) information, each point cloud can also have other information
associated with it including:

* COLOR - the Red, Green and Blue (RGB) value associated with the lidar data point (often extracted from an associated RGB image).
* Intensity - quantifying the amount of light reflected off of the object on the ground.

The point cloud format is stored as <a href="#" target="_blank">vector data (link to vector
 overview)</a>. The points may be located anywhere in space are not aligned
 within any particular grid.


<figure class='half'>
<a href="{{ site.url }}{{ site.baseurl }}#"><img src="{{ site.url }}{{ site.baseurl }}#"></a>
<figcaption>image of point clouds </figcaption>
</figure>


### Classifying LiDAR point clouds

LiDAR point clouds are useful because they tell us something about the heights of objects on the ground. However, how do we know whether a point reflected off of a tree, a bird, a building or the ground? In order to develop useful data products like elevation models and canopy height models (which we will talk about next), we need to classify individual LiDAR points. We might classify LiDAR points into classes including:

- Ground
- Vegetation
- Buildings

There are special tools and algorithms that can be used to classify lidar point clouds.
Programs such as:

* lastools,
* fusion and
* terrascan

are often used to perform this classification. Once the points are classified, they can be used to derive various
LiDAR data products.

<figure>
<a href="{{ site.url }}{{ site.baseurl }}/images/course-materials/lidar/Treeline_ScannedPoints.png"><img src="{{ site.url }}{{ site.baseurl }}/images/course-materials/lidar/Treeline_ScannedPoints.png"></a>
<figcaption>A cross section of point clouds associated with a riparian landscape.
The green points have been classified as vegetation. The orange points are classified
as ground. Image Source: Leah Wasser, NEON </figcaption>
</figure>

<Image - cross section, 1. unclassified points 2. classified points 3. >

## Work With Point Clouds
Point clouds can be challenging to work with as they are extremely large and often
require special tools or programming to work with efficiently. For this reason,
many people will take lidar point clouds turn them into a <a href="#">raster data </a>
product. It is common to create surface models that represent:

* Terrain: the elevation of the ground
* Surface elevation: the elevation at the top of the surface which may include trees and buildings
* Vegetation height

<figure class='half'>
<a href="{{ site.url }}{{ site.baseurl }}/images/course-materials/lidar/lidar-chm-dsm-dtm.png"><img src="{{ site.url }}{{ site.baseurl }}/images/course-materials/lidar/
lidar-chm-dsm-dtm.png"></a>
<figcaption>image of point clouds </figcaption>
</figure>

We will talk about the process of turning lidar point clouds into surface models, next.

## Point Cloud File Formats

LiDAR point clouds are most often available in a `.las` file format. The .las
file format is a compressed format that can better handle extremely large volumes
of points.
