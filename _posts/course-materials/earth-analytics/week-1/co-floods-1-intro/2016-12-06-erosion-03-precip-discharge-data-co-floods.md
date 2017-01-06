---
layout: single
title: "Intro to the CO Floods"
excerpt: "Understanding the floods with data."
authors: ['Leah Wasser', 'NEON Data Skills']
category: [course-materials]
class-lesson: ['co-floods-1-intro']
permalink: /course-materials/earth-analytics/week-1/precip-discharge/
nav-title: 'Interactive Precip & Discharge Data'
dateCreated: 2016-12-29
dateModified: 2016-12-29
module-title: 'Understanding Disturbance With Data - Flooding & Erosion'
module-description: 'This module introduces the concept of using data to Understand
a natural phenomenon. Here, we use a combination of NOAA precipitation data and
USGS stream flow data to begin to understand the factors associated with a flood.
No technical experience is needed to complete this activity.'
week: 1
sidebar:
  nav:
author_profile: false
comments: false
order: 3
---

{% include toc title="This Lesson" icon="file-text" %}

In this classroom activity we will look at different types of data
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

## Exploring Flood Damage

In the previous lesson, we looked at visible damage caused by the 2013 floods.
However, what actually caused that damage? We refer to causes of disturbance events
like floods as DRIVERS in science. In this lesson we will explore some data that
begins to quantify some of the drivers of the 2013 Colorado floods.

<figure>
 <a href="{{ site.url }}{{ site.baseurl }}/images/course-materials/earth-analytics/week-1/intro-co-floods/N_St_Vrain_before_after_CreditBoulderCo.jpg">
 <img src="{{ site.url }}{{ site.baseurl }}/images/course-materials/earth-analytics/week-1/intro-co-floods/N_St_Vrain_before_after_CreditBoulderCo.jpg" alt="North St Vrain before and after 2013 flood."></a>
 <figcaption> The St. Vrain River in Boulder County, CO after (left) and before
 (right) the 2013 flooding event.  Source: Boulder County via <a href="http://krcc.org/post/post-flood-planning-boulder-county" target="_blank"> KRCC</a>.
 </figcaption>
</figure>


## Precipitation

Examine the plots below. Think about what the data may or may not be telling you.
Then answer the questions below.

<i class="fa fa-star"></i> **Precipitation:** is the moisture that
falls from clouds including rain, hail and snow.
{: .notice}

<figure>
 <a href="https://plot.ly/~NEONDataSkills/6/total-monthly-precipitation-boulder-co-station/" target="_blank">
 <img src="{{ site.url }}{{ site.baseurl }}/images/course-materials/earth-analytics/week-1/intro-co-floods/total-monthly-precip.png" alt="North St Vrain before and after 2013 flood."></a>
 <figcaption> Total Monthly Precipitation. Click on the image to EXPLORE the data interactively! Data Source: NOAA <a href="http://krcc.org/post/post-flood-planning-boulder-county" target="_blank"> KRCC</a>.
 </figcaption>
</figure>

<iframe width="100%" height="400" frameborder="0" scrolling="no" src="//plot.ly/~leahawasser/161.embed"></iframe>

<div class="notice--warning" markdown="1">

## <i class="fa fa-pencil-square-o" aria-hidden="true"></i> Activity: Precip Data

### What do the data tell you about precipitation?

As a group, discuss the following questions. Record your answers following the
directions of your instructor (Google Doc, Word document, Etherpad, etc.).

* What interesting things do you observe in the data? Are there any data points that seem different from the rest?
  * For each difference: What you think caused that difference?
  * For each difference: How can you quantitatively record the differences?
* What do you think caused or drove the point(s) that your observed in the above question?
* Was the cause - caused by something else? I.E. did something else DRIVE the cause?
* Create a diagram that illustrates the causes and effects (or drivers and impacts) of the flood. Is it a linear diagram? Is it quantifiable?
</div>


## Stream Flow (Discharge)

<i class="fa fa-star"></i> **Stream Discharge**, quantifies the volume of water
moving down a stream. Discharge is an ideal metric to quantify stream flow, which
increases significantly during a flood event.
{: .notice}


<figure>
 <a href="https://plot.ly/~leahawasser/166/stream-discharge-boulder-creek-2013/">
 <img src="{{ site.url }}{{ site.baseurl }}/images/course-materials/earth-analytics/week-1/intro-co-floods/stream-discharge-166.png" alt="Stream discharge plot."></a>
 <figcaption> 30 Years of Stream Discharge - Click on the graphic to
 explore the data interactively.
 </figcaption>
</figure>

<figure>
 <a href="https://plot.ly/~leahawasser/150/stream-discharge-boulder-creek-2013/">
 <img src="{{ site.url }}{{ site.baseurl }}/images/course-materials/earth-analytics/week-1/intro-co-floods/stream-discharge-150.png" alt="Stream discharge plot."></a>
 <figcaption> 2013 Stream Discharge - Boulder Creek 2013 - Click on the graphic to
 explore the data interactively.
 </figcaption>
</figure>

<div class="notice--warning" markdown="1">

## <i class="fa fa-pencil-square-o" aria-hidden="true"></i> Activity: Stream discharge data

### What do the data tell you about stream discharge?

As a group, discuss the following questions. Record your answers following the
directions of your instructor (Google Doc, word document, etherpad, etc.).

* What differences do you see between 2012 and 2013?
  * For each difference: What you think caused that difference?
  * For each difference: How can you quantitatively record the differences?
* For each CAUSE listed above, could you somehow quantitatively record the "size" or impact of the cause?
* Was the cause - caused by something else? IE did something else DRIVE the cause?
* Create a diagram that illustrates the causes and effects (or drivers and impacts) of the flood. Is it a linear diagram? Is it quantifiable?
</div>
