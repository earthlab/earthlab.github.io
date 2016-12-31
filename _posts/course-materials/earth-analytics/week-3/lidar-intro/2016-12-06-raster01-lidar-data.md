---
layout: single
title: "Introduction to LiDAR Data"
excerpt: "."
authors: ['Leah Wasser', 'NEON Data Skills']
lastModified: 2016-12-30
category: [course-materials]
class-lesson: ['class-lidar-r']
permalink: /course-materials/earth-analytics/week-3/lidar-intro/
nav-title: 'LiDAR Raster Data in R'
module-title: 'LiDAR Raster Data R'
module-description: 'This tutorial covers the basic principles of LiDAR remote sensing.'
module-nav-title: 'Lidar Rasters in R'
module-type: 'class'
week: 3
sidebar:
  nav:
author_profile: false
comments: false
order: 1
---


<div class='notice--success' markdown="1">

## <i class="fa fa-graduation-cap" aria-hidden="true"></i> Learning Objectives

After completing this tutorial, you will be able to:

* List and briefly describe the 3 core components of a lidar remote sensing system.
* Describe what a lidar system measures.
* Define an active remote sensing system.

### Things You'll Need To Complete This Lesson

You will need a computer with internet access to complete this lesson.

</div>

LiDAR or **Li**ght **D**etection **a**nd **R**anging is an active remote sensing
system that can be used to measure vegetation height across wide areas.


<figure>
   <a href="{{ site.url }}/images/course-materials/earth-analytics/week-3/lidar-trees.jpg">
   <img src="{{ site.url }}/images/course-materials/earth-analytics/week-3/lidar-trees.jpg" alt="Lidar data collected by NEON AOP"></a>
   <figcaption>LiDAR data collected at the Soaproot Saddle site by the National
Ecological Observatory Network Airborne Observation Platform (NEON AOP). Source:
Keith Krauss, NEON.
   </figcaption>
</figure>


## LiDAR Background
Watch the videos below to better understand what lidar is and how a lidar system
works.

### The Story of LiDAR Data video
<iframe width="560" height="315" src="//www.youtube.com/embed/m7SXoFv6Sdc?rel=0" frameborder="0" allowfullscreen></iframe>

### How LiDAR Works
<iframe width="560" height="315" src="//www.youtube.com/embed/EYbhNSUnIdU?rel=0" frameborder="0" allowfullscreen></iframe>


## Let's Get Started - Key Concepts to Review

### Why LiDAR

Scientists often need to characterize vegetation over large regions. We use
tools that can estimate key characteristics over large areas because we don’t
have the resources to measure each individual tree. These tools often use remote
methods. Remote sensing means that we aren’t actually physically measuring
things with our hands, we are using sensors which capture information about a
landscape and record things that we can use to estimate conditions and
characteristics.

<figure>
   <a href="{{ site.url }}/images/course-materials/earth-analytics/week-3/scaling-trees-nat-geo.jpg">
   <img src="{{ site.url }}/images/course-materials/earth-analytics/week-3/scaling-trees-nat-geo.jpg" alt="national geographic scaling trees graphic"></a>
   <figcaption>Conventional on the ground methods to measure trees are resource
   intensive and limit the amount of vegetation that can be characterized. Source:
   National Geographic
   </figcaption>
</figure>


To measure vegetation across large areas we need remote sensing methods that can
collect many measurements, quickly using automated sensors. These measurements can
be used to estimate forest structure across larger areas. LiDAR, or light
detection ranging (sometimes also referred to as active laser scanning) is one
remote sensing method that can be used to map structure including vegetation
height, density and other characteristics across a region. LiDAR directly
measures the height and density of vegetation (and buildings and other objects)
on the ground making it an ideal tool for scientists studying vegetation over
large areas.

<figure class="half">
   <img src="http://www.nrcan.gc.ca/sites/www.nrcan.gc.ca/files/earthsciences/images/resource/tutor/fundam/images/passiv.gif" alt="active remote sensing">
   <img src="http://www.nrcan.gc.ca/sites/www.nrcan.gc.ca/files/earthsciences/images/resource/tutor/fundam/images/sensors.gif" alt="passive remote sensing">
   <figcaption>LEFT: Remote sensing systems which measure energy that is naturally
   available are called passive sensors. RIGHT: Active sensors emit their own
   energy from a source on the instrument itself. Source:
   Natural Resources Canada.
   </figcaption>
</figure>

### Lidar is an Active Remote Sensing System

LIDAR is an **active remote sensing** system. An
<a href="http://www.nrcan.gc.ca/node/14639" target="_blank">active system means that the
system itself generates energy </a> - in this case light - to measure things on the
ground. In a LiDAR system, light is emitted from a rapidly firing laser. You can
imagine, light quickly strobing from a laser light source. This light travels
to the ground and reflects off of things like buildings and tree branches. The
reflected light energy then returns to the LiDAR sensor where it is recorded.

A LiDAR system measures the time it takes for emitted light to travel  to the
ground and back. That time is used to calculate distance traveled. Distance
traveled is then converted to elevation. These measurements are made using the
key components of a lidar system including a GPS that identifies the X,Y,Z
location of the light energy and an Internal Measurement Unit (IMU) that
provides the orientation of the plane in the sky.

<iframe width="560" height="315" src="//www.youtube.com/embed/uSESVm59uDQ?rel=0" frameborder="0" allowfullscreen></iframe>


### How Light Energy Is Used to Measure Trees

Light energy is a collection of photons. As the photons that make up light moves
towards the ground, they hit objects such as branches on a tree. Some of the
light reflects off of those objects and returns to the sensor. If the object is
small, and there are gaps surrounding it that allow light to pass through, some
light continues down towards the ground. Because some photons reflect off of
things like branches but others continue down towards the ground, multiple
reflections may be recorded from one pulse of light.

The distribution of energy that returns to the sensor creates what we call a
waveform. The amount of energy that returned to the LiDAR sensor is known as
"intensity". The areas where more photons or more light energy returns to the
sensor create peaks in the distribution of energy. Theses peaks in the waveform
often represent objects on the ground like - a branch, a group of leaves or a
building.

<figure>
   <a href="{{ site.url }}/images/course-materials/earth-analytics/week-3/waveform.png" target="_blank">
   <img src="{{ site.url }}/images/course-materials/earth-analytics/week-3/waveform.png" alt="Example of a lidar waveform"></a>
   <figcaption>An example LiDAR waveform. Source: National Ecological
   Observatory Network, Boulder, CO - image
available on <a href="https://flic.kr/s/aHsk4W4cdP" target="_blank"> Flickr</a>.
   </figcaption>
</figure>


## How Scientists Use LiDAR Data
There are many different uses for LiDAR data.

- LiDAR data classically have been used to derive high resolution elevation data

<figure>
   <a href="{{ site.url }}/images/course-materials/earth-analytics/week-3/high-res-topo.png">
   <img src="{{ site.url }}/images/course-materials/earth-analytics/week-3/high-res-topo.png" alt="high resolution vs low resolution topography."></a>
   <figcaption>LiDAR data have historically been used to generate high
   resolution elevation datasets. Source: National Ecological Observatory
   Network - image
   available on <a href="https://flic.kr/s/aHsk4W4cdP" target="_blank"> Flickr</a>.
   </figcaption>
</figure>

- LiDAR data have also been used to derive information about vegetation
structure including
	- Canopy Height
	- Canopy Cover
	- Leaf Area Index
	- Vertical Forest Structure
	- Species identification (in less dense forests with high point density LiDAR)


<figure>
   <a href="{{ site.url }}/images/course-materials/earth-analytics/week-3/Treeline_ScannedPoints.png">
   <img src="{{ site.url }}/images/course-materials/earth-analytics/week-3/Treeline_ScannedPoints.png" alt="example of a tree profile after a lidar scan."></a>
   <figcaption>Cross section showing LiDAR point cloud data (above) and the
   corresponding landscape profile (below). Graphic: Leah A. Wasser
   </figcaption>
</figure>


## Discrete vs. Full Waveform LiDAR
A waveform or distribution of light energy is what returns to the LiDAR sensor.
However, this return may be recorded in two different ways.

1. A **Discrete Return LiDAR System** records individual (discrete) points for
the peaks in the waveform curve. Discrete return LiDAR systems, identify peaks
and record a point at each peak location in the waveform curve. These discrete
or individual points are called returns. A discrete system may record 1-4 (and
sometimes more) returns from each laser pulse.
2. A **Full Waveform LiDAR System** records a distribution of returned light
energy. Full waveform LiDAR data are thus more complex to process however they
can often capture more information compared to discrete return LiDAR systems.

## LiDAR File Formats
Whether it is collected as discrete points or full waveform, most often LiDAR
data are available as discrete points. A collection of discrete return LiDAR
points is known as a LiDAR point cloud.

The commonly used file format to store LIDAR point cloud data is called .las
which is a format supported by the Americal Society of Photogrammetry and Remote
Sensing (ASPRS). Recently, the [.laz](http://www.laszip.org/) format has been
developed by Martin Isenberg of LasTools. The differences is that .laz is a
highly compressed version of .las.

### LiDAR Data Attributes: X,Y, Z, Intensity and Classification
LiDAR data attributes can vary, depending upon how the data were collected and
processed. You can determine what attributes are available for each lidar point
by looking at the metadata. All lidar data points will have an associated X,Y
location and Z (elevation values). Most lidar data points will have an intensity
value, representing the amount of light energy recorded by the sensor.

Some LiDAR data will also be "classified" -- not top secret. Classification refers
to tagging each point with the object that it reflected off of. So if a pulse reflects
off of a tree branch, we would assign it to the class "vegetation". If the pulse
reflects off of the ground, we would assign it to the class "ground".
Classification of LiDAR point clouds is an additional
processing step. Classification simply represents the type of object that the
laser return reflected off of. So if the light energy reflected off of a tree,
it might be classified as "vegetation". And if it reflected off of the ground,
it might be classified as "ground".

Some LiDAR products will be classified as "ground/non-ground". Some datasets
will be further processed to determine which points reflected off of buildings
and other infrastructure. Some LiDAR data will be classified according to the
vegetation type.


#### Gridded or Raster LiDAR Data Products ###
LiDAR data products are most often worked within a gridded or raster data format.
A raster file is a regular grid of cells, all of which are the same size. A
few notes about rasters:

-  Each cell is called a pixel.
-  And each pixel represents an area on the ground.
-  The resolution of the raster represents the area that each pixel represents
- on the ground. So, for instance if the raster is 1 m resolution, that simple
- means that each pixel represents a 1 m by 1m area on the ground.

Raster data can have attributes associated with it as well. For instance in a
LiDAR derived digital elevation model (DEM), each cell might represent a
particular elevation value.  In a LIDAR derived intensity image, each cell
represents a LIDAR intensity value.


## Creating A Raster From LiDAR Point Clouds
There are different ways to create a raster from LiDAR point clouds. Let's look
at one of the most basic ways to create a raster file points- basic gridding.
When you perform a gridding algorithm, you are simply calculating a value, using
point data, for each pixels in your raster dataset. To do this:

1. To begin, a grid is placed on top of the LiDAR data in space. Each cell in the grid has the same spatial dimensions. These dimensions represent that particular area on the ground. If we want to derive a 1 m resolution raster from the lidar data, we overlay a 1m by 1m grid over the LiDAR data points.
2. Within each 1 m x 1 m cell, we calculate a value to be applied to that cell, using the LiDAR points found within that cell. The simplest method of doing this is to take the max, min or mean height value of all lidar points found within the 1 m cell. If we use this approach, we might have cells in the raster that don't contains any lidar points. These cells will have a "no data" value if we process our raster in this way.

### Point to Raster Methods - Interpolation
A different approach is to interpolate the value for each cell. Interpolation
considers the values of points outside of the cell in addition to points within
the cell to calculate a value. Interpolation is useful because it can provide us
with some ability to predict or calculate cell values in areas where there are
no data (or no points). And to quantify the error associated with those predictions
which is useful to know, if you are doing research.

<figure>
<a href="{{ site.url }}/images/course-materials/earth-analytics/week-3/gridding.gif">
<img src="{{ site.url }}/images/course-materials/earth-analytics/week-3/gridding.gif" alt="Animation Showing the general process of taking lidar point clouds and converting them to a Raster Format"></a>
<figcaption>
Animation Showing the general process of taking lidar point clouds and converting them to a Raster Format. Source: Tristan Goulden, National Ecological Observatory Network
</figcaption>
</figure>
