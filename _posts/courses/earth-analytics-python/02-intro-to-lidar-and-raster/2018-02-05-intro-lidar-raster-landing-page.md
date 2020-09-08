---
layout: single
category: courses
title: "Lidar Raster Data in Python"
permalink: /courses/earth-analytics-python/lidar-raster-data/
modified: 2020-08-26
week-landing: 3
week: 2
sidebar:
  nav:
comments: false
author_profile: false
course: "earth-analytics-python"
module-type: 'session'
---
{% include toc title="This Week" icon="file-text" %}

<div class="notice--info" markdown="1">

## <i class="fa fa-ship" aria-hidden="true"></i> Welcome to Week {{ page.week }}!

Welcome to week {{ page.week }} of Earth Analytics! In week {{ page.week }} you will learn about
Light Detection and Ranging (LiDAR) data. You will learn to use point cloud data and
lidar rasters in `Python` and explore using QGIS - a free, open-source GIS tool.

<!-- 
Your final 2013 Colorado flood report assignment is below. Read the assignment
carefully and make sure you've completed all of the steps and followed all of the
guidelines. Use all of the class and homework lessons that you've learned in the
first few weeks to help you complete the assignment.
-->

{% include/data_subsets/course_earth_analytics/_data-colorado-flood.md %}

</div>

## <i class="fa fa-calendar-check-o" aria-hidden="true"></i> Class Schedule

| time          | topic                                                     | speaker           |  |  |
|:--------------|:----------------------------------------------------------|:------------------|:-|:-|
| First 15 minutes       | Review Jupyter Notebook / questions                  | Leah              |  |  |
| Rest of Class | Python coding session - Working with Raster Data in Python | Leah              |  |  |

### 1. Readings

First - review ALL of the lessons for this week. We did not cover them all in class. This
includes the in class and homework lessons.

Read the following articles. They will help you write your report.

* Wehr, A., and U. Lohr (1999). Airborne Laser Scanning - An Introduction and Overview. ISPRS Journal of Photogrammetry and Remote Sensing 54:68–92. doi: 10.1016/S0924-2716(99)00011-8 : <a href="http://citeseerx.ist.psu.edu/viewdoc/download?doi=10.1.1.9.516&rep=rep1&type=pdf" target="_blank" data-proofer-ignore=''><i class="fa fa-download" aria-hidden="true"></i>
PDF</a>
* <a href="https://www.e-education.psu.edu/natureofgeoinfo/node/1888" target="_blank">Intro to Lidar</a>
* <a href="https://www.e-education.psu.edu/natureofgeoinfo/node/1890" target="_blank">Active remote sensing</a>


<div class="notice--warning" markdown="1">

## <i class="fa fa-pencil-square-o" aria-hidden="true"></i> Homework

Please see the assignment dropbox on CANVAS for an overview of your homework for this week. If you'd like to see what your plots should look like - please scroll down to the bottom of this page. 

Note that your plots may look at bit different from the ones on this page as you might select different classification value ranges and colors. That is OK. Please be sure to justify your choices in your homework test. 


</div>

## Homework Plots

The plots below are examples of what your plots might look like. Your plots do not need to look exactly like these! You may use different classes for your different maps for example which will change your rasters! Feel free to customize colors, labels, layers, etc as you like to create nice plots.


## Grade Rubric

Please view the dropbox in Canvas to see the rubric that will be used to grade your assignment

## Homework Plots
The plots that you generate for this week's homework should look like the ones below. 
Note that your plot may have some variation if you select different classification bins and plot colors. 






{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}/images/courses/earth-analytics-python/02-intro-to-lidar-and-raster/2018-02-05-intro-lidar-raster-landing-page/2018-02-05-intro-lidar-raster-landing-page_7_0.png" alt = "Difference Plot: Canopy Height Model post flood minus pre flood.">
<figcaption>Difference Plot: Canopy Height Model post flood minus pre flood.</figcaption>

</figure>






{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}/images/courses/earth-analytics-python/02-intro-to-lidar-and-raster/2018-02-05-intro-lidar-raster-landing-page/2018-02-05-intro-lidar-raster-landing-page_9_0.png" alt = "Canopy Height Model Different - Raster plot.">
<figcaption>Canopy Height Model Different - Raster plot.</figcaption>

</figure>





{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}/images/courses/earth-analytics-python/02-intro-to-lidar-and-raster/2018-02-05-intro-lidar-raster-landing-page/2018-02-05-intro-lidar-raster-landing-page_10_0.png" alt = "Histogram of the DTM different raster.">
<figcaption>Histogram of the DTM different raster.</figcaption>

</figure>





{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}/images/courses/earth-analytics-python/02-intro-to-lidar-and-raster/2018-02-05-intro-lidar-raster-landing-page/2018-02-05-intro-lidar-raster-landing-page_11_0.png" alt = "Plot of classified pre/post DTM difference raster.">
<figcaption>Plot of classified pre/post DTM difference raster.</figcaption>

</figure>








