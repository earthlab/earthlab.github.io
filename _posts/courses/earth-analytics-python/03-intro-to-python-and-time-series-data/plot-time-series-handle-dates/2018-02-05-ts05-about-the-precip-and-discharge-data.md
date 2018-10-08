---
layout: single
title: "About the Data Used in this Module"
excerpt: "This lesson reviews the data uses in this time series module."
authors: ['Leah Wasser']
modified: 2018-10-08
category: [courses]
class-lesson: ['time-series-python']
course: 'earth-analytics-python'
week: 3
permalink: /courses/earth-analytics-python/use-time-series-data-in-python/about-the-time-series-data/
nav-title: 'About the Stream Discharge Data'
sidebar:
  nav:
author_profile: false
comments: true
order: 5
topics:
---


{% include toc title="In This Lesson" icon="file-text" %}

In your homework for this week you need to plot the USGS stream discharge data provided in week's data download. This lesson provides some background on that data that may help you complete your homework. 

<div class='notice--success' markdown="1">

## <i class="fa fa-graduation-cap" aria-hidden="true"></i> Learning Objectives

After completing this tutorial, you will be able to:

* Be able to describe where the stream discharge data that is provided in your homework is from and what it represents. 

## <i class="fa fa-check-square-o fa-2" aria-hidden="true"></i> What You Need

A computer with internet access.

</div>

## About the Data - USGS Stream Discharge Data

The USGS has a distributed network of aquatic sensors located in streams across the United States. This network monitors a suit of variables that are important to stream morphology and health. One of the metrics that this sensor network monitors is **Stream Discharge**, a metric which quantifies the volume of water moving down a stream. Discharge is an ideal metric to quantify flow, which increases significantly during a flood event.

> As defined by USGS: Discharge is the volume of water moving down a stream or
> river per unit of time, commonly expressed in cubic feet per second or gallons
> per day. In general, river discharge is computed by multiplying the area of
> water in a channel cross section by the average velocity of the water in that
> cross section.
>
> <a href="http://water.usgs.gov/edu/streamflow2.html" target="_blank">
Read more about stream discharge data collected by USGS.</a>

<figure>
<a href="{{ site.url }}/images/courses/earth-analytics/co-flood-lessons/USGS-peak-discharge.gif">
<img src="{{ site.url }}/images/courses/earth-analytics/co-flood-lessons/USGS-peak-discharge.gif" alt="Plot of stream discharge from the USGS boulder creek stream gage"></a>
<figcaption>
The USGS tracks stream discharge through time at locations across the United
States. Note the pattern observed in the plot above. The peak recorded discharge
value in 2013 was significantly larger than what was observed in other years.
Source: <a href="http://nwis.waterdata.usgs.gov/usa/nwis/peak/?site_no=06730200" target="_blank"> USGS, National Water Information System. </a>
</figcaption>
</figure>



<i class="fa fa-star"></i> **Data Tip:**
To make your plots more attractive check out [this tutorial from seaborn!](https://seaborn.pydata.org/tutorial/aesthetics.html) 
{: .notice--success}
