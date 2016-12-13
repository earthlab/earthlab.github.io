---
layout: single
title: 'Characterize Vegetation Structure Using Lidar Data'
authors: [Leah Wasser]
excerpt: "The overview page I used at CU 5 April 2016."
category: [course-materials]
class-lesson: ['lidar-vegetation-01-intro']
nav-title: 'Lidar intro'
sidebar:
  nav:
author_profile: false
comments: false
order: 1
published: true
---

## Overview

<div class='notice--success' markdown="1">

# Learning Outcomes

* Understand what lidar remote sensing data are.
* Understand how lidar data can be used to estimate tree height.
* Understand the concept of an active remote sensing sensor
* Understand the differences between (uncertainty surrounding) lidar estimates of vegetation height compared to ground measurements.

****

**Estimated Time:** 1-2 hours

[Download Lesson Data](#){: .btn .btn--large}
</div>

## How LiDAR Works

Learn more about the fundamental principles associated with lidar remote sensing
systems by watching the 7 minute video below.

<iframe width="560" height="315" src="//www.youtube.com/embed/EYbhNSUnIdU?rel=0" frameborder="0" allowfullscreen></iframe>


## Why LiDAR

Scientists often need to characterize vegetation over large regions. We use tools that can estimate key characteristics over large areas because we don't have the resources to measure each and every tree. These tools often use remote methods. Remote sensing means that we aren't actually physically measuring things with our hands, we are using sensors which capture information about a landscape and record things that we can use to estimate conditions and characteristics.

<figure>
<a href="{{ site.url }}{{ site.baseurl }}/images/course-materials/lidar/ScalingTrees_NatGeo.jpg"><img src="{{ site.url }}{{ site.baseurl }}/images/course-materials/lidar/ScalingTrees_NatGeo.jpg"></a>
<figcaption>Conventional on the ground methods to measure trees are resource intensive and limit the amount of vegetation that can be characterized! Photo: National Geographic. </figcaption>
</figure>

To measure vegetation across large areas we need remote sensing methods that can take many measurements, quickly using automated sensors. These measurements can  be used to estimate forest structure across larger areas. LiDAR, or light detection ranging (sometimes also referred to as active laser scanning) is one remote sensing method that can be used to map structure including vegetation height, density and other characteristics across a region. LiDAR directly measures the height and density of vegetation on the ground making it an ideal tool for scientists studying vegetation over large areas.

## How LiDAR Works ##

LIDAR is an **active remote sensing** system. An active system means that the system itself generates energy - in this case light - to measure things on the ground. In a LiDAR system, light is emitted from a rapidly firing laser. You can imagine, light quickly strobing from a laser light source. This light travels to the ground and reflects off of things like buildings and tree branches. The reflected light energy then returns to the LiDAR sensor where it is recorded.


A LiDAR system measures the time it takes for emitted light to travel  to the ground and back. That time is used to calculate distance traveled. Distance traveled is then converted to elevation. These measurements are made using the key components of a lidar system including a GPS that identifies the X,Y,Z location of the light energy and an IMU that provides the orientation of the plane in the sky.
