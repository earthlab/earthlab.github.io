---
layout: single
title: "Use Google Earth Time Series Images to Explore Flood Impacts"
excerpt: "Learn how to use the time series feature in Google Earth to view before / after images of a location."
authors: ['Leah Wasser', 'NEON Data Skills']
category: [courses]
class-lesson: ['co-floods-1-intro']
permalink: /courses/earth-analytics/document-your-science/google-earth-time-series/
nav-title: 'Google Earth Time Series'
module-nav-title: 'Use data for science'
dateCreated: 2016-12-06
modified: '2018-01-10'
module-title: 'Understand Disturbance with Data - Flooding and Erosion'
module-description: 'This module uses time series data to explore the impacts of a flood. Learn how to use Google Earth imagery, NOAA precipitation data and
USGS stream flow data to explore the 2013 Colorado floods.'
module-type: 'class'
class-order: 1
course: "earth-analytics"
week: 1
sidebar:
  nav:
author_profile: false
comments: true
order: 1
topics:
  remote-sensing: ['multispectral-remote-sensing']
  earth-science: ['flood-erosion']
  time-series:
---

{% include toc title="In This Lesson" icon="file-text" %}

In this lesson, you will learn to use the time series function in Google Earth
to explore changes in the landscape associated with the 2013 Colorado floods.

<div class='notice--success' markdown="1">

## <i class="fa fa-graduation-cap" aria-hidden="true"></i> Learning Objectives
At the end of this activity, you will be able to:

* Use the timeline function in Google Earth to view time series imagery data.
* Identify and describe a driver and an impact of a flood event.

## <i class="fa fa-check-square-o fa-2" aria-hidden="true"></i> What You Need

You will need to download and install Google Earth on your computer and then
download the `.kml` file below.

<a href="https://www.google.com/earth/download/gep/agree.html" target="_blank" class="btn btn-success btn--x-large">
Get Google Earth</a>

<a href="https://ndownloader.figshare.com/files/7005404" class="btn btn-success btn--x-large">
<i class="fa fa-download" aria-hidden="true"></i> Download .kmz file - Locations of Change</a>

</div>

## About the 2013 CO Floods

In early September 2013, a slow moving cold air front moved through Colorado
intersecting with a warm, humid air front. The clash between the cold and warm
airs fronts yielded heavy rain. This rain, combined with a drought conditions,
Colorado soil conditions and other factors yielded devastating flooding across
the Front Range in Colorado, USA.

<figure>
 <a href="{{ site.url }}/images/courses/earth-analytics/document-your-science/intro-co-floods/N_St_Vrain_before_after_CreditBoulderCo.jpg">
 <img src="{{ site.url }}/images/courses/earth-analytics/document-your-science/intro-co-floods/N_St_Vrain_before_after_CreditBoulderCo.jpg" alt="North St Vrain before and after 2013 flood."></a>
 <figcaption> The St. Vrain River in Boulder County, CO after (left) and before
 (right) the 2013 flooding event.  Source: Boulder County via <a href="http://krcc.org/post/post-flood-planning-boulder-county" target="_blank"> KRCC</a>.
 </figcaption>
</figure>

<iframe width="560" height="315" src="https://www.youtube.com/embed/bUcWERTM-OA?rel=0&loop=1" frameborder="0" allowfullscreen></iframe>

## Use Imagery to Detect Change

Spatially located (georeferenced) imagery, collected using satellites and airplanes
provides a powerful visual record of landscape changes. Google Earth, has a time
series feature that allows you to look at imagery of the earth, across time in
certain areas of the Earth.

You will use this feature to look at the landscape in Boulder, Colorado both before
and after the floods.


### How to View Time Series Imagery in Google Earth

* Open Google Earth
* Double click on the `.kmz` file that you downloaded above. It should open in Google Earth.

<i fa fa-star></i>**Tip:** If the `.kmz` file doesn't automatically open when you
double click on it, try to Open Google Earth,
go to File --> Open in Google Earth. Finally, navigate to the
location of your downloaded file (`~Documents/data/co-flood/locations`) and open it.
{: .notice--success}

* Once you have the `.kmz` file open, notice it is listed in the **Temporary Places** section
of the  `places` window. It should automatically zoom you into to an area in North
Boulder, Colorado. If it doesn't double click on the text `Locations of Significant Damage`.
* Click on the show historical imagery button in Google Earth

<figure>
 <a href="{{ site.url }}/images/courses/earth-analytics/document-your-science/intro-co-floods/google-earth-time.png">
 <img src="{{ site.url }}/images/courses/earth-analytics/document-your-science/intro-co-floods/google-earth-time.png" alt="google earth time series feature."></a>
 <figcaption> The `show historical imagery` button allows you to turn on and slide
 through imagery from various points in time within Google Earth. It is the button
 outlined in pink in the above imaged.
 </figcaption>
</figure>

* When you click on the show historical imagery, a slider will appear in the upper
LEFT hand corner of your window. Scroll back and forth through time to get used
to the slider
* Finally, double click on one of the thumbtacks from `Locations of Significant Damage`.
Scroll to 10/2012 and then to 10/2013. Do you see any differences?
* Check out the other thumbtack. What differences do you see?


<div class="notice--warning" markdown="1">

## <i class="fa fa-pencil-square-o" aria-hidden="true"></i> Activity: What Changes Do You See?

As a group, discuss the following questions. Record your answers in the Google Document
provided.

* What differences do you see between 2012 and 2013?
  * For each difference: What do you think caused that difference?
  * For each difference: How can you quantitatively record the difference?
* For each CAUSE listed above, could you somehow quantitatively record the "size" or impact of the cause?
* Was the cause - caused by something else (i.e. did something else DRIVE the cause)?
</div>
