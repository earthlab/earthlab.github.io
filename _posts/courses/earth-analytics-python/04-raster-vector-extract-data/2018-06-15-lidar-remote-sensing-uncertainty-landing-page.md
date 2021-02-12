---
layout: single
category: courses
title: "Lidar Remote Sensing Uncertainty - Compare Ground to Lidar Measurements of Tree Height in Python"
permalink: /courses/earth-analytics-python/lidar-remote-sensing-uncertainty/
week-landing: 4
modified: 2021-02-12
week: 4
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

Welcome to week {{ page.week }} of Earth Analytics! This week, you will explore
the concept of uncertainty surrounding lidar raster data (and remote sensing
data in general). You will use the same data that you downloaded last week for class.

For your homework you'll also need to download the data below. You can do this most easily `using earthpy.get_data()`.

{% include/data_subsets/course_earth_analytics/_data-spatial-lidar.md %}

*******

## <i class="fa fa-pencil-square-o" aria-hidden="true"></i> Homework 

### The Homework Assignment for This Week Can Be Found on Github 


<a href="https://github.com/earthlab-education/ea-python-2020-04-lidar-uncertainty-template" target="_blank">Click here to view the GitHub Repo with the assignment template. </a>

The lessons for this week have been moved to our <a href="https://www.earthdatascience.org/courses/use-data-open-source-python/">Intermediate Earth Analytics Textbook. </a>

### Earth Analytics Textbook Chapters

Please read the following chapters to support completing this week's assignment:
* <a href="https://www.earthdatascience.org/courses/use-data-open-source-python/spatial-data-applications/lidar-remote-sensing-uncertainty/">NEW: Raster / Vector Spatial Data Applications: Compare Lidar to Human Measured Tree Heights -- Uncertainty</a>
* <a href="https://www.earthdatascience.org/courses/use-data-open-source-python/intro-vector-data-python/">REVIEW: Intro to Vector Spatial Data in Open Source Python</a>


### 1. Readings
* <a href="http://journals.plos.org/plosone/article?id=10.1371/journal.pone.0054776" target="_blank">Influence of Vegetation Structure on Lidar-derived Canopy Height and Fractional Cover in Forested Riparian Buffers During Leaf-Off and Leaf-On Conditions</a>
* <a href="http://www.sciencedirect.com/science/article/pii/S0303243403000047" target="_blank">The characterization and measurement of land cover change through remote sensing: problems in operational applications?</a>
*  <a href="https://www.nde-ed.org/GeneralResources/ErrorAnalysis/UncertaintyTerms.htm" target="_blank">Learn more about the various uncertainty terms.</a>

</div>


## Example Homework Plots

The plots below are examples of what your plot could look like. Feel free to
customize or modify plot settings as you see fit! 









{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}/images/courses/earth-analytics-python/04-raster-vector-extract-data/2018-06-15-lidar-remote-sensing-uncertainty-landing-page/2018-06-15-lidar-remote-sensing-uncertainty-landing-page_8_0.png" alt = "Plots of lidar min and max vs insitu min and max with a 1:1 line a regression fit for the NEON SJER field site.">
<figcaption>Plots of lidar min and max vs insitu min and max with a 1:1 line a regression fit for the NEON SJER field site.</figcaption>

</figure>








{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}/images/courses/earth-analytics-python/04-raster-vector-extract-data/2018-06-15-lidar-remote-sensing-uncertainty-landing-page/2018-06-15-lidar-remote-sensing-uncertainty-landing-page_12_0.png" alt = "Plots of lidar min and max vs insitu min and max with a 1:1 line a regression fit for the NEON SOAP field site.">
<figcaption>Plots of lidar min and max vs insitu min and max with a 1:1 line a regression fit for the NEON SOAP field site.</figcaption>

</figure>


















