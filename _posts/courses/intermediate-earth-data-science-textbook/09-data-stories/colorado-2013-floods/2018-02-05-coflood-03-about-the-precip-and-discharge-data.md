---
layout: single
title: "About the Stream Discharge Data Used in this Data Story"
excerpt: "Learn more about the stream discharge data that is used in this data story."
authors: ['Leah Wasser']
dateCreated: 2018-02-05
modified: 2020-03-18
category: [courses]
class-lesson: ['about-2013-floods-tb']
course: 'intermediate-earth-data-science-textbook'
chapter: 20
week: 9
permalink: /courses/use-data-open-source-python/data-stories/colorado-floods-2013/about-the-stream-discharge-data/
nav-title: 'About the Stream Discharge Data'
sidebar:
  nav:
author_profile: false
comments: true
order: 3
topics: 
    remote-sensing: ['multispectral-remote-sensing']
    earth-science: ['flood-erosion']
    time-series:  
redirect_from:
  - "/courses/earth-analytics-python/use-time-series-data-in-python/about-the-time-series-data/"
  - "/courses/use-data-open-source-python/data-stories/colorado-2013-floods/about-the-stream-discharge-data/"
---

{% include toc title="On This Page" icon="file-text" %}

<div class='notice--success' markdown="1">

## <i class="fa fa-graduation-cap" aria-hidden="true"></i> Learning Objectives

* Be able to describe where the stream discharge data that is provided in this data story comes from and what it represents. 

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
<a href="{{ site.url }}/images/earth-analytics/co-flood-lessons/USGS-peak-discharge.gif">
<img src="{{ site.url }}/images/earth-analytics/co-flood-lessons/USGS-peak-discharge.gif" alt="Plot of stream discharge from the USGS boulder creek stream gage"></a>
<figcaption>
The USGS tracks stream discharge through time at locations across the United
States. Note the pattern observed in the plot above. The peak recorded discharge
value in 2013 was significantly larger than what was observed in other years.
Source: <a href="http://nwis.waterdata.usgs.gov/usa/nwis/peak/?site_no=06730200" target="_blank"> USGS, National Water Information System. </a>
</figcaption>
</figure>

<i class="fa fa-star"></i> **Data Tip:**
To make your plots more attractive check out <a href="https://seaborn.pydata.org/tutorial/aesthetics.html" target="_blank"> this tutorial from seaborn! </a> 
{: .notice--success}
