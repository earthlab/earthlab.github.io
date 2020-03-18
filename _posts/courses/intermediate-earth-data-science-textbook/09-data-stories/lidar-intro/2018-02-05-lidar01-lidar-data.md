---
layout: single
title: "Introduction to Light Detection and Ranging (Lidar) Remote Sensing Data"
excerpt: "This lesson reviews what Lidar remote sensing is, what the lidar instrument measures and discusses the core
components of a lidar remote sensing system."
authors: ['Leah Wasser']
dateCreated: 2018-02-05
modified: 2020-03-18
category: [courses]
class-lesson: ['lidar-data-story']
permalink: /courses/use-data-open-source-python/data-stories/what-is-lidar-data/
nav-title: 'Intro to Lidar Data'
module-title: 'Intro to Lidar Data'
module-description: 'This tutorial covers the basic principles of LiDAR remote sensing and
the three commonly used data products: the digital elevation model, digital surface model and the canopy height model. Finally it walks through opening lidar derived raster data in Python'
module-nav-title: 'Intro to Lidar Data'
module-type: 'class'
course: 'intermediate-earth-data-science-textbook'
chapter: 21
week: 9
sidebar:
  nav:
author_profile: false
comments: true
order: 1
class-order: 2
topics:
  remote-sensing: ['lidar']
  earth-science: ['vegetation']
  spatial-data-and-gis: ['raster-data']
redirect_from:
  - "/courses/earth-analytics-python/lidar-raster-data/lidar-intro/"
  - "/courses/use-data-open-source-python/data-stories/lidar-raster-data/lidar-intro/"
---

{% include toc title="In This Chapter" icon="file-text" %}

<div class='notice--success' markdown="1">

## <i class="fa fa-ship" aria-hidden="true"></i> Chapter 21 - Understanding Lidar Data

In this chapter, you will learn about Lidar data and how it can be used to study flood events. 


## <i class="fa fa-graduation-cap" aria-hidden="true"></i> Learning Objectives

After completing this chapter, you will be able to:

* List and briefly describe the 3 core components of a lidar remote sensing system.
* Describe what a lidar system measures.
* Define an active remote sensing system.

## <i class="fa fa-check-square-o fa-2" aria-hidden="true"></i> What You Need

You will need a computer with internet access to complete this lesson.

{% include/data_subsets/course_earth_analytics/_data-colorado-flood.md %}


</div>

LiDAR or **Li**ght **D**etection **a**nd **R**anging is an active remote sensing
system that can be used to measure vegetation height across wide areas.


<figure>
   <a href="{{ site.url }}/images/earth-analytics/lidar-raster-data/lidar-trees.jpg">
   <img src="{{ site.url }}/images/earth-analytics/lidar-raster-data/lidar-trees.jpg" alt="Lidar data collected by NEON AOP"></a>
   <figcaption>LiDAR data collected at the Soaproot Saddle site by the National
Ecological Observatory Network Airborne Observation Platform (NEON AOP). Source:
Keith Krauss, NEON.
   </figcaption>
</figure>


## LiDAR Background

Watch the videos below to better understand what lidar is and how a lidar system works.

### The Story of LiDAR Data video
<iframe width="560" height="315" src="//www.youtube.com/embed/m7SXoFv6Sdc?rel=0" frameborder="0" allowfullscreen></iframe>

### How LiDAR Works
<iframe width="560" height="315" src="//www.youtube.com/embed/EYbhNSUnIdU?rel=0" frameborder="0" allowfullscreen></iframe>


## Let's Get Started - Key Concepts to Review

### Why LiDAR

Scientists often need to characterize vegetation over large regions. Scientists use tools that can estimate key characteristics over large areas because they don’t have the resources to measure each individual tree. These tools often use remote methods. Remote sensing means that scientists aren’t actually physically measuring things with their hands, they are using sensors which capture information about a landscape and record things that they can use to estimate conditions and characteristics.


<figure>
   <a href="{{ site.url }}/images/earth-analytics/lidar-raster-data/scaling-trees-nat-geo.jpg">
   <img src="{{ site.url }}/images/earth-analytics/lidar-raster-data/scaling-trees-nat-geo.jpg" alt="national geographic scaling trees graphic"></a>
   <figcaption>Conventional on the ground methods to measure trees are resource
   intensive and limit the amount of vegetation that can be characterized. Source:
   National Geographic.
   </figcaption>
</figure>


To measure vegetation across large areas you need remote sensing methods that can collect many measurements, quickly, using automated sensors. These measurements can be used to estimate forest structure across larger areas. 

LiDAR, or light detection ranging (sometimes also referred to as active laser scanning) is one remote sensing method that can be used to map structure including vegetation height, density and other characteristics across a region. LiDAR directly measures the height and density of vegetation (and buildings and other objects) on the ground making it an ideal tool for scientists studying vegetation over large areas.

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
<a href="http://www.nrcan.gc.ca/node/14639" target="_blank">active system means that the system itself generates energy </a> - in this case light - to measure things on the ground. In a LiDAR system, light is emitted from a rapidly firing laser. You can imagine a light quickly strobing from a laser light source. This light travels to the ground and reflects off of things like buildings and tree branches. The reflected light energy then returns to the LiDAR sensor where it is recorded.

A LiDAR system measures the time it takes for emitted light to travel to the ground and back. That time is used to calculate distance traveled. Distance traveled is then converted to elevation. These measurements are made using the key components of a lidar system including a GPS that identifies the X,Y,Z location of the light energy and an Internal Measurement Unit (IMU) that provides the orientation of the plane in the sky.

<iframe width="560" height="315" src="//www.youtube.com/embed/uSESVm59uDQ?rel=0" frameborder="0" allowfullscreen></iframe>


### How Light Energy Is Used to Measure Trees

Light energy is a collection of photons. As the photons that make up light move toward the ground, they hit objects such as branches on a tree. Some of the light reflects off of those objects and returns to the sensor. 

If the object is small, and there are gaps surrounding it that allow light to pass through, some light continues down towards the ground. Because some photons reflect off of things like branches but others continue down towards the ground, multiple reflections may be recorded from one pulse of light.

The distribution of energy that returns to the sensor creates what is called a waveform. The amount of energy that returned to the LiDAR sensor is known as "intensity". The areas where more photons or more light energy returns to the sensor create peaks in the distribution of energy. These peaks in the waveform often represent objects on the ground like - a branch, a group of leaves or a building.

<figure>
   <a href="{{ site.url }}/images/earth-analytics/lidar-raster-data/waveform.png" target="_blank">
   <img src="{{ site.url }}/images/earth-analytics/lidar-raster-data/waveform.png" alt="Example of a lidar waveform"></a>
   <figcaption>An example lidar waveform. Source: NEON, Boulder, CO.
   </figcaption>
</figure>


## How Scientists Use LiDAR Data

There are many different uses for LiDAR data.

- LiDAR data classically have been used to derive high resolution elevation data

<figure>
   <a href="{{ site.url }}/images/earth-analytics/lidar-raster-data/high-res-topo.png">
   <img src="{{ site.url }}/images/earth-analytics/lidar-raster-data/high-res-topo.png" alt="high resolution vs low resolution topography."></a>
   <figcaption>LiDAR data have historically been used to generate high
   resolution elevation datasets. Source: National Ecological Observatory
   Network.
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
   <a href="{{ site.url }}/images/earth-analytics/lidar-raster-data/treeline-scanned-lidar-points.png">
   <img src="{{ site.url }}/images/earth-analytics/lidar-raster-data/treeline-scanned-lidar-points.png" alt="example of a tree profile after a lidar scan."></a>
   <figcaption>Cross section showing lidar point cloud data (above) and the
   corresponding landscape profile (below). Graphic: Leah A. Wasser.
   </figcaption>
</figure>

## Discrete vs. Full Waveform LiDAR

A waveform or distribution of light energy is what returns to the LiDAR sensor. However, this return may be recorded in two different ways.

1. A **Discrete Return LiDAR System** records individual (discrete) points for
the peaks in the waveform curve. Discrete return LiDAR systems identify peaks
and record a point at each peak location in the waveform curve. These discrete
or individual points are called returns. A discrete system may record 1-4 (and
sometimes more) returns from each laser pulse.
2. A **Full Waveform LiDAR System** records a distribution of returned light
energy. Full waveform LiDAR data are thus more complex to process; however, they
can often capture more information compared to discrete return LiDAR systems.

<figure>
   <a href="{{ site.url }}/images/earth-analytics/lidar-raster-data/waveform.png" target="_blank">
   <img src="{{ site.url }}/images/earth-analytics/lidar-raster-data/waveform.png" alt="Example of a lidar waveform"></a>
   <figcaption>An example lidar waveform. Source: NEON.
   </figcaption>
</figure>

## LiDAR File Formats

Whether it is collected as discrete points or full waveform, most often LiDAR data are available as discrete points. A collection of discrete return LiDAR points is known as a LiDAR point cloud.

The commonly used file format to store LIDAR point cloud data is the .las format. The <a href="https://laszip.org/" target="_blank">.laz</a> format is a highly compressed version of .las and is becoming more widely used.

### LiDAR Data Attributes: X,Y, Z, Intensity and Classification

LiDAR data attributes can vary, depending upon how the data were collected and processed. You can determine what attributes are available for each lidar point by looking at the metadata.

All lidar data points will have:

* **X,Y Location information:** This determines the x,y coordinate location of the object that the lidar pulse (the light) reflected off of
* **Z (elevation values):** representing the elevation of the object that the lidar pulse reflected off of.

Most lidar data points will have:

* **Intensity:** representing the amount of light energy recorded by the sensor.

## Classified Lidar Point Clouds

Some LiDAR point cloud data will also be "classified". Classification refers to tagging each point with the object off which it reflected. So if a pulse reflects off a tree branch, you would assign it to the class "vegetation". If the pulse reflects off the ground, you would assign it to the class "ground". Classification of LiDAR point clouds is an additional processing step. 

Some LiDAR products will be classified as "ground/non-ground". Some datasets will be further processed to determine which points reflected off of buildings and other infrastructure. Some LiDAR data will be classified according to the vegetation type.



<figure>
   <a href="{{ site.url }}/images/earth-analytics/lidar-raster-data/treeline-scanned-lidar-points.png">
   <img src="{{ site.url }}/images/earth-analytics/lidar-raster-data/treeline-scanned-lidar-points.png" alt="example of a tree profile after a lidar scan."></a>
   <figcaption>Cross section showing lidar point cloud data (above) and the
   corresponding landscape profile (below). Graphic: Leah A. Wasser.
   </figcaption>
</figure>


## What is a Data Product?

A data product, is the data that are DERIVED from an instrument, or information collected on the ground. For instance, you may go out in the field and measure the heights of trees at 20 plots. Then calculate an average height per plot.
The average value is DERIVED from the individual measurements that you collected in the field.

When dealing with sensor data, the sensors often collect data in a format that needs to be processed in order to get usable values from it.


<figure>
   <a href="{{ site.url }}/images/earth-analytics/lidar-raster-data/lidar-cross-section.png">
   <img src="{{ site.url }}/images/earth-analytics/lidar-raster-data/lidar-cross-section.png" alt="A cross section of 3-dimensional lidar data. Brown points represent ground,
   green represent vegetation (trees)."></a>
   <figcaption>A cross section of 3-dimensional lidar data. This point cloud data
   product is classified into the classes: vegetation and ground points. Brown points represent ground,
   green represent vegetation (trees).
   </figcaption>
</figure>
