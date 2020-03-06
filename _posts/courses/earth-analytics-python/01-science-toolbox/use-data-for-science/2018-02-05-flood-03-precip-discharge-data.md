---
layout: single
title: 'Explore Precipitation and Stream Flow Data Using Interactive Plots: The 2013 Colorado Floods'
excerpt: "Practice interpreting data on plots that show rainfall (precipitation) and stream flow (discharge) as it changes over time."
authors: ['Leah Wasser', 'Martha Morrissey']
modified: 2020-03-06
category: [courses]
class-lesson: ['data-for-science-floods']
permalink: /courses/earth-analytics-python/python-open-science-toolbox/precipitation-discharge-data-for-flood-analysis/
nav-title: 'Interactive Data Plots'
week: 1
sidebar:
  nav:
author_profile: false
comments: true
order: 3
course: 'earth-analytics-python' 
topics: 
    earth-science: ['flood-erosion']
    time-series:    
---
{% include toc title="In This Lesson" icon="file-text" %}

In this classroom activity you will look at different types of data
that scientifically quantify / document the drivers (causes of) and impacts of
a disturbance event like a flood.

<div class='notice--success' markdown="1">

## <i class="fa fa-graduation-cap" aria-hidden="true"></i> Learning Objectives
At the end of this activity, you will be able to:

* Describe two related drivers of a flood event.
* Interpret plots containing time series data related to flood drivers.

## <i class="fa fa-check-square-o fa-2" aria-hidden="true"></i> What You Need

You need a computer with internet to complete this lesson.

</div>

## Exploring Flood Drivers Using Data

In the previous lesson, you:

1. Looked at visible damage caused by the 2013 floods using Google Earth imagery.
2. Explored an extremely well written report on the floods identifying things that may make the report better.

In this lesson you will explore two of the  drivers of the flood and
associated flood impacts. A **driver** is a cause of a disturbance events.

<figure>
 <a href="{{ site.url }}/images/courses/earth-analytics/science/colorado-floods/st-vrain-creek-before-and-after-colorado-floods.jpg">
 <img src="{{ site.url }}/images/courses/earth-analytics/science/colorado-floods/st-vrain-creek-before-and-after-colorado-floods.jpg" alt="North St Vrain before and after 2013 flood."></a>
 <figcaption> The St. Vrain River in Boulder County, CO after (left) and before
 (right) the 2013 flooding event.  Source: Boulder County via <a href="http://krcc.org/post/post-flood-planning-boulder-county" target="_blank"> KRCC</a>.
 </figcaption>
</figure>


## Precipitation

Examine the plots below. Think about what the data may or may not be telling you.
Then answer the questions below.

<i class="fa fa-star"></i> **Precipitation:** is the moisture that
falls from clouds including rain, hail and snow.
{: .notice--success}

<figure>
 <a href="https://plot.ly/~NEONDataSkills/6/total-monthly-precipitation-boulder-co-station/" target="_blank">
 <img src="{{ site.url }}/images/courses/earth-analytics/document-your-science/intro-co-floods/total-monthly-precip.png" alt="North St Vrain before and after 2013 flood."></a>
 <figcaption> Total Monthly Precipitation. Click on the image to EXPLORE the data interactively! Data Source: NOAA <a href="http://krcc.org/post/post-flood-planning-boulder-county" target="_blank"> KRCC</a>.
 </figcaption>
</figure>

<iframe width="100%" height="400" frameborder="0" scrolling="no" src="//plot.ly/~leahawasser/161.embed"></iframe>

<div class="notice--warning" markdown="1">

## <i class="fa fa-pencil-square-o" aria-hidden="true"></i> Activity: Precip Data

### What do the data tell you about precipitation patterns?

As a group, discuss the following questions. Record your answers in the
Google doc that your instructor shared with you for today's class. As
you explore the data, keep in mind that the the flood event occured September 2013.


* What patterns do you observe in the data? Note any data points that appear to be visibly different from the other data points in the plots?
  * Do you think the differences that you note are statistically significant? Do you have enough information to determine this?
  * For each difference: What you think caused that difference?
  * For each difference: How can you quantitatively record the differences?
* What other factors may have contributed to the patterns that you observe in precipitation? What other data would you like to see to better "tell the story" of what took place during the flood?
</div>


## Stream Flow (Discharge)

<i class="fa fa-star"></i> **Stream Discharge**, quantifies the volume of water
moving down a stream. Discharge is an ideal metric to quantify stream flow, which
increases significantly during a flood event.
{: .notice--success}


<figure>
 <a href="https://plot.ly/~leahawasser/166/stream-discharge-boulder-creek-2013/">
 <img src="{{ site.url }}/images/courses/earth-analytics/document-your-science/intro-co-floods/stream-discharge-166.png" alt="Stream discharge plot."></a>
 <figcaption> 30 Years of Stream Discharge - Click on the graphic to
 explore the data interactively.
 </figcaption>
</figure>

<figure>
 <a href="https://plot.ly/~leahawasser/150/stream-discharge-boulder-creek-2013/">
 <img src="{{ site.url }}/images/courses/earth-analytics/document-your-science/intro-co-floods/stream-discharge-150.png" alt="Stream discharge plot."></a>
 <figcaption> 2013 Stream Discharge - Boulder Creek 2013 - Click on the graphic to
 explore the data interactively.
 </figcaption>
</figure>

<div class="notice--warning" markdown="1">

## <i class="fa fa-pencil-square-o" aria-hidden="true"></i> Activity: Stream Discharge Data

### What do the data tell you about stream discharge?

As a group, discuss the following questions. Record your answers in the
same Google doc that you used above.

* What differences do you see in stream discharge between 2012 and 2013?
  * For each difference: What you think caused that difference?
  * For each difference: How can you quantitatively record the differences?
* For each CAUSE listed above, could you somehow quantitatively record the magnitude (size or impact) of the cause?
* Was the cause - caused by (driven by) something else?


</div>

