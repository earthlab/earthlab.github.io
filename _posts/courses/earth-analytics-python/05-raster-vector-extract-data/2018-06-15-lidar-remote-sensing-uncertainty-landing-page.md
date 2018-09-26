---
layout: single
category: courses
title: "Lidar Remote Sensing Uncertainty - Comparing Ground to Lidar Measurements of Tree Height in Python"
permalink: /courses/earth-analytics-python/lidar-remote-sensing-uncertainty/
week-landing: 5
modified: 2018-09-26
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


### 2. Complete the Assignment Below (5 points)

<div class="notice--warning" markdown="1">

## <i class="fa fa-pencil-square-o" aria-hidden="true"></i> Homework Submission

### Produce a Report

Create a new `Jupyter notebook`. Name it: **lastName-firstInitial-week5.ipynb**
Within your `notebook` document, write the code needed to create the plots listed below. 
Be sure to name your files as instructed! Submit a ipynb file and a .html file with your output to Canvas.


<!--

#### Answer Questions Below in Your Report -- turning this into multiple choice questions...

2. **Write *at least* 2 paragraphs:** In this class you learned the relationship between lidar derived canopy height models and measured tree height. Use that plots that you create below, the readings and the course lessons to answer the following questions
  * Which lidar tree height metric, (max vs. mean height) more closely relates to human measured tree height?
  * What sources of uncertainty (as discussed in class and the readings) may impact relationship between lidar vs human measured tree height?
  * Do you notice any differences in the relationship between the lidar vs human measured tree height between SJER vs SOAP field sites? Explain.
3. **Write *at least* 1 paragraph:** List a minimum of 3 sources of uncertainty associated with the lidar derived tree heights and 3 sources of uncertainty associated with *in situ* measurements of tree height. For each source of uncertainty, specify whether it is a random or systematic error. Be sure to reference the plots and readings as necessary.


#### Include the Plots Below
Be sure to describe what each plot shows in your final report.
Your plots do not need to be in the order below. I just listed them this way
to make it easier to keep track of and grade!

-->



#### Questions To Answer

Answer the following questions:

1. When comparing lidar vs measured tree height, which metric, mean or max height has a strong relationship? Why do you think one height measurement might be closer to measured then the other?
2. For SJER, provide the plot numbers, of the two plots that have the largest difference between lidar vs measured maximum tree height.
3. For SOAP, provide the plot numbers, of the two plots that have the largest difference between lidar vs measured maximum tree height.


### IMPORTANT: For All Plots
* Label x and y axes appropriately - include units
* Add a title to your plot that describes what the plot shows
* Add a brief, 1-3 sentence caption below each plot that describes what it shows.


</div>



## Example Homework Plots

The plots below are examples of what your plot could look like. Feel free to
customize or modify plot settings as you see fit! Note that I did not number
the plots this week to allow you to place plots where you'd like in your report.

#### Plots 1 - 4: Scatterplots With Regression & a 1:1 Line

For both the SJER and SOAP field sites, create scatter plots that compare:

* **MAXIMUM** canopy height model height in meters, extracted within a 20 meter radius, compared to **MAXIMUM** tree
height derived from the *insitu* field site data.
* **MEAN** canopy height model height in meters, extracted within a 20 meter radius, compared to **MEAN** tree height derived from the *insitu* field site data.

For each of these plots be sure to:

1. Place lidar data values on the X axis and human measured tree height on the Y axis
2. Include a calculated **regression line** (HINT use `sns.plot()` to achieve this line) that describes the relationship of lidar of the data
3. Include a separate **1:1 line** that can be used to compare the regression fit to a perfect 1:1 fit. 
4. Set the x and y limits to be the SAME for each individual plot. This means that for plot 3 the x and y limits are the same. For plot 4 the x and y limits are the same. NOTE: You may have different limits for each plot depending on the data being rendered. Thus plot 3 x and plot 3 y axis may be the same. But plot 3 x axis does NOT need to be the same as plot 4 x axis. 
5. Plot the SJER plots within one figure using two ax elements (ax1, ax2) 
6. Plot the SOAP plots within one figure using two ax elements (ax1, ax2) 

HINT: the SOAP data have some inconsistencies in the column headings. One way to fix this is to use the syntax:

`"text-to-append-to-column" + dataframe_name["column-name-here"]`



{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}//images/courses/earth-analytics-python/05-raster-vector-extract-data/2018-06-15-lidar-remote-sensing-uncertainty-landing-page_3_0.png" alt = "Plots of lidar min and max vs insitu min and max with a 1:1 line a regression fit for the NEON SJER field site.">
<figcaption>Plots of lidar min and max vs insitu min and max with a 1:1 line a regression fit for the NEON SJER field site.</figcaption>

</figure>





{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}//images/courses/earth-analytics-python/05-raster-vector-extract-data/2018-06-15-lidar-remote-sensing-uncertainty-landing-page_4_0.png" alt = "Plots of lidar min and max vs insitu min and max with a 1:1 line a regression fit for the NEON SOAP field site.">
<figcaption>Plots of lidar min and max vs insitu min and max with a 1:1 line a regression fit for the NEON SOAP field site.</figcaption>

</figure>




### Calculated Regression Fit 

The above plots show the regression fit as calculated by the `seaborn` python package. Use stats.linregression() to calculate the slope and intercept of the regresion fit for each of the plots above. 

Print the outputs below. 



{:.output}
    SJER - Mean Height Comparison
    slope: 0.05 intercept: 5.26
    
    SJER - Max Height Comparison
    slope: 0.76 intercept: 2.98




{:.output}
    
    SOAP - Mean Height Comparison
    slope: 0.42 intercept: -0.82
    
    SOAP - Max Height Comparison
    slope: 2.35 intercept: -38.04




#### 1. Of all four relationships that you plotted above, which was the strongest?


## Is Mean of Max Height A Closer Comparison?

#### 2. List 2 reasons why lidar max height values may be larger than (over estimate) human measurements.


#### 3. List 2 reasons why lidar mean height values may be smaller than (underestimate) human measurements.



#### 4. List 2 systematic sources of error could impact differences between lidar and measured tree height values. 

Your answer here

#### 5. List 2 random sources of error that could impact differences between lidar and measured tree height values. 

Your answer here
