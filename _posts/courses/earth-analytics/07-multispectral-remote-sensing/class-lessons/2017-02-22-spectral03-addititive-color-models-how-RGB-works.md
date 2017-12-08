---
layout: single
title: "How Multispectral Imagery is Drawn on Computers - Additive Color Models"
excerpt: "In this lesson you will learn the basics of using Landsat 7 and 8 in R. You will learn how to import Landsat data stored in .tif format - where each .tif file represents a single band rather than a stack of bands. Finally you will plot the data using various 3 band combinations including RGB and color-infrared."
authors: ['Leah Wasser']
modified: '2017-12-08'
category: [courses]
class-lesson: ['spectral-data-fire-r']
permalink: /courses/earth-analytics/multispectral-remote-sensing-data/addititive-color-models-how-multispectral-imagery-is-drawn-on-computers/
nav-title: 'Additive Color Models'
week: 7
course: "earth-analytics"
sidebar:
  nav:
author_profile: false
comments: true
order: 3
topics:
  remote-sensing: ['landsat']
  earth-science: ['fire']
  reproducible-science-and-programming:
  spatial-data-and-gis: ['raster-data']
lang-lib:
  r: []
redirect_from:
   - "/courses/earth-analytics/week-6/landsat-bands-geotif-in-R/"
---

{% include toc title="In This Lesson" icon="file-text" %}



<div class='notice--success' markdown="1">

## <i class="fa fa-graduation-cap" aria-hidden="true"></i> Learning Objectives

After completing this tutorial, you will be able to:

* Describe the difference between additive and subtractive light models.
* Explain how RGB images are rendered in a computer monitor.

## <i class="fa fa-check-square-o fa-2" aria-hidden="true"></i> What You Need

You don't need anything for this lesson. Please watch the videos below. They
review what you learned in class with the additive light demo.

</div>

The ~3 minute video below inspired the demonstration that you saw in class.

<iframe width="560" height="315" src="https://www.youtube.com/embed/Udvapi2lmvQ" frameborder="0" allowfullscreen></iframe>

The 2:30 minute video below shows the difference between additive and subtractive
light models and demonstrates subtractive models with paints.

<iframe width="560" height="315" src="https://www.youtube.com/embed/Er7CM_RNFZ4" frameborder="0" allowfullscreen></iframe>


The ~3 minute video below has no sound, but look closely as they zoom in on the pixels of
an old school computer monitor. You will notice that each  pixel is composed of three
types of light red, green and blue.

<iframe width="560" height="315" src="https://www.youtube.com/embed/HzY4Q5fKxmU" frameborder="0" allowfullscreen></iframe>

<div class="notice--info" markdown="1">


</div>
