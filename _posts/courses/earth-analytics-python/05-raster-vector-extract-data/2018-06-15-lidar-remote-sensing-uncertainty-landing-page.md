---
layout: single
category: courses
title: "Lidar Remote Sensing Uncertainty - Compare Ground to Lidar Measurements of Tree Height in Python"
permalink: /courses/earth-analytics-python/lidar-remote-sensing-uncertainty/
week-landing: 5
modified: 2018-10-08
week: 5
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
You will also use pipes again this week to work with tabular data.

For your homework you'll also need to download the data below.

{% include/data_subsets/course_earth_analytics/_data-spatial-lidar.md %}

</div>

|  Time | Topic   | Speaker   |
|---|---|---|---|---|
| 1:00 - 1:30  | Questions / Review |   |
| 1:30 - 2:30  | Coding: Use lidar to characterize vegetation / uncertainty  |   |
| 2:30 - 2:40  | BREAK |   |
| 2:40 - 3:50  | Coding: Use lidar to characterize vegetation / uncertainty |   |

### 1. Readings
* <a href="http://journals.plos.org/plosone/article?id=10.1371/journal.pone.0054776" target="_blank">Influence of Vegetation Structure on Lidar-derived Canopy Height and Fractional Cover in Forested Riparian Buffers During Leaf-Off and Leaf-On Conditions</a>
* <a href="http://www.sciencedirect.com/science/article/pii/S0303243403000047" target="_blank">The characterization and measurement of land cover change through remote sensing: problems in operational applications?</a>
*  <a href="https://www.nde-ed.org/GeneralResources/ErrorAnalysis/UncertaintyTerms.htm" target="_blank">Learn more about the various uncertainty terms.</a>





## Example Homework Plots

The plots below are examples of what your plot could look like. Feel free to
customize or modify plot settings as you see fit! 


{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}//images/courses/earth-analytics-python/05-raster-vector-extract-data/2018-06-15-lidar-remote-sensing-uncertainty-landing-page_2_0.png" alt = "Plots of lidar min and max vs insitu min and max with a 1:1 line a regression fit for the NEON SJER field site.">
<figcaption>Plots of lidar min and max vs insitu min and max with a 1:1 line a regression fit for the NEON SJER field site.</figcaption>

</figure>





{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}//images/courses/earth-analytics-python/05-raster-vector-extract-data/2018-06-15-lidar-remote-sensing-uncertainty-landing-page_3_0.png" alt = "Plots of lidar min and max vs insitu min and max with a 1:1 line a regression fit for the NEON SOAP field site.">
<figcaption>Plots of lidar min and max vs insitu min and max with a 1:1 line a regression fit for the NEON SOAP field site.</figcaption>

</figure>




### Calculated Regression Fit 

The above plots show the regression fit as calculated by the `seaborn` python package. Use `stats.linregression()` to calculate the slope and intercept of the regresion fit for each of the plots above. 

Print the outputs below. 



{:.output}
    SJER - Mean Height Comparison
    slope: print-slope-value-here intercept: print-intercept-value-here
    
    SJER - Max Height Comparison
    slope: print-slope-value-here intercept: print-intercept-value-here


