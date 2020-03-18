---
layout: single
title: 'Rain: a Driver of the 2013 Colorado Floods'
excerpt: "The amount and/or duration of rainfall can impact how severe a flood is. Learn how rainfall is measured and used to understand flood impacts."
authors: ['Leah Wasser', 'Lauren Herwehe']
modified: 2020-03-18
category: [courses]
class-lesson: ['about-2013-floods-tb']
course: 'intermediate-earth-data-science-textbook'
chapter: 20
permalink: /courses/use-data-open-source-python/data-stories/colorado-floods-2013/how-rain-impacts-floods/
nav-title: 'Precipitation'
dateCreated: 2018-05-24
module-type: 'class'
week: 9
sidebar:
  nav:
author_profile: false
comments: true
order: 4
topics: 
    remote-sensing: ['multispectral-remote-sensing']
    earth-science: ['flood-erosion']
    time-series:  
redirect_from:
  - "/courses/earth-analytics-python/python-open-science-toolbox/how-rain-impacts-floods/"
  - "/courses/use-data-open-source-python/data-stories/colorado-2013-floods/how-rain-impacts-floods/"
---

{% include toc title="On This Page" icon="file-text" %}

<div class='notice--success' markdown="1">

## <i class="fa fa-graduation-cap" aria-hidden="true"></i> Learning Objectives

* Describe how rainfall or precipitation contributes to a flood event.
* Describe how rainfall is measured.

</div>


## What Is Precipitation? 

Precipitation refers to moisture from the condensation of atmospheric water vapor that falls to the ground. The term precipitation can refer to rain, snow and even hail. While rainfall is the most common driver of flood events, ice and snow melt can also cause or exacerbate them.
 
<figure>
 <a href="{{ site.url }}/images/earth-analytics/science/colorado-2013-floods/big-thompson-creek-road-destruction-colorado-floods.jpg">
 <img src="{{ site.url }}/images/earth-analytics/science/colorado-2013-floods/big-thompson-creek-road-destruction-colorado-floods.jpg" alt = "Big Thompson River during the Colorado floods"></a>
 <figcaption> The Big Thompson River rages in Larimer County, Colorado during the 2013 Colorado floods. Source:<a href="https://www.denverpost.com/2015/09/12/two-years-later-2013-colorado-floods-remain-a-nightmare-for-some/" target="_blank">The Denver Post.</a>
 </figcaption>
</figure>



## How Is Precipitation Measured?

Rainfall is reported as the total amount of rain (millimeters, centimeters, or inches) over a given area per period of time. Various types of gauges can be used to measure precipitation. They are often as simple as a small plastic cylinder with vertical ticks that collects water. These precipitation gauges can be manually checked. In some cases there are automated systems in place that will record precipitation over time. 

<figure>
 <a href="{{ site.url }}/images/earth-analytics/science/colorado-2013-floods/standard-rain-gauge-colorado-floods.jpg">
 <img src="{{ site.url }}/images/earth-analytics/science/colorado-2013-floods/standard-rain-gauge-colorado-floods.jpg" alt = "Rain gage"></a>
 <figcaption>Image of a standard rain gage. Source:<a href="https://en.wikipedia.org/wiki/File:Rain_gauge_2525388751_4c05081862_b.jpg" target="_blank">Wikipedia.</a>
 </figcaption>
</figure>


## Where Can You Find Precipitation Data?

Several US governmental organizations collect precipitation data. In this lesson, you will use data from the National Weather Service (NWS) Cooperative Observer Platform (COOP). 

This platform, which is operated by thousands of volunteer weather observers, consists of over 11,000 stations, about 5,000 of them measuring climate. These climate stations report 24 hour minimum and maximum temperature, liquid equivalent precipitation, snowfall, snow depth, and other weather metrics.

<figure>
 <a href="{{ site.url }}/images/earth-analytics/science/colorado-2013-floods/map-of-coop-sites-colorado-floods.jpg">
 <img src="{{ site.url }}/images/earth-analytics/science/colorado-2013-floods/map-of-coop-sites-colorado-floods.jpg" alt = "Map of US COOP sites"></a>
 <figcaption>Map of US COOP sites. Source:<a href="https://www.weather.gov/coop/" target="_blank">National Weather Service.</a>
 </figcaption>
</figure>


Another ‘citizen science’ source of precipitation data is CoCoRaHS. In contrast with COOP, this volunteer network measures only precipitation.

## Precipitation and the Colorado Floods

The average annual precipitation (which includes rain and snow) in Boulder, Colorado is 20 inches. This precipitation comes from winter snow, intense summer thunderstorms, and intermittent storms throughout the year. 

The precipitation that led to the 2013 floods was a late summer storm. Due to the atmospheric conditions, the storm produced significant precipitation in a short period of time. 

### How Much Rain Did Boulder Get During the Floods? 

The figure below shows the total precipitation each month from 1948 to 2013 for a National Weather Service COOP site located in Boulder, CO.



{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}/images/courses/intermediate-earth-data-science-textbook/09-data-stories/colorado-2013-floods/2018-02-05-coflood-04-flood-drivers-precipitation/2018-02-05-coflood-04-flood-drivers-precipitation_3_0.png" alt = "Scatter plot showing daily precipitation values for Boulder from 1948 to 2016.">
<figcaption>Scatter plot showing daily precipitation values for Boulder from 1948 to 2016.</figcaption>

</figure>




<i>ABOVE: Graph of total monthly precipitation from 1948 to 2013 for the National Weather Service’s COOP site Boulder 2 (Station ID:050843).</i>

Within this 65 years of data, you can see that there is a jump in the amount of precipitation that was measured in September 2013. If you “zoom in” on the time period of fall 2013 (see the plot below) you will see the precipitation that led to the floods came in the span of just a few days.



{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}/images/courses/intermediate-earth-data-science-textbook/09-data-stories/colorado-2013-floods/2018-02-05-coflood-04-flood-drivers-precipitation/2018-02-05-coflood-04-flood-drivers-precipitation_5_0.png" alt = "Plot of total daily precipitation from August 15th to September 15th, 2013 for a National Weather Service COOP site located in Boulder, CO.">
<figcaption>Plot of total daily precipitation from August 15th to September 15th, 2013 for a National Weather Service COOP site located in Boulder, CO.</figcaption>

</figure>




## Stream Discharge 

### What Is Stream Discharge?

Stream discharge, or flow, is the volume of water that moves through a designated point over a fixed period of time. Measuring stream discharge helps scientists understand the amount and velocity of water that is moving through an area, which is of particular interest during floods. 

### How Is Stream Discharge Measured?

Stream discharge is calculated by multiplying the area of a cross section of the stream by the velocity.

<figure>
 <a href="{{ site.url }}/images/earth-analytics/science/colorado-2013-floods/measure-stream-discharge-colorado-floods.png">
 <img src="{{ site.url }}/images/earth-analytics/science/colorado-2013-floods/measure-stream-discharge-colorado-floods.png" alt = "How to measure stream discharge"></a>
 <figcaption>Schematic of how to measure stream discharge. It is measured by multiplying the area of a cross-section of the stream by the velocity. Source:<a href="https://water.usgs.gov/edu/streamflow2.html" target="_blank">USGS.</a>
 </figcaption>
</figure>



### Where Can You Find Stream Discharge Data?

One of the most common sources of stream data is the USGS which maintains a network of sensors in rivers and streams across the country. In addition to stream discharge, these sensors monitor other variables that are important to stream morphology and health such as water level, velocity, and direction of flow. 

### Stream Discharge and the Colorado Floods

During the flooding in Boulder, the combination of atmospheric conditions, precipitation and drought yielded rapid increases in stream flow, which served as a secondary driver of the floods. Stream discharge in Boulder Creek during the 2013 floods was 100 times greater than average, causing the creek to overflow its banks. The velocity of the water in the streams allowed it to pick up and move significant debris
 
The daily average data for the stream gauge along Boulder Creek, five miles downstream of downtown Boulder, is graphed below. This graph, paired with the graph of precipitation in the above section, shows that heavy precipitation led to a stream surge. As a result of this extreme discharge rate, water poured into the flood zone.


{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}/images/courses/intermediate-earth-data-science-textbook/09-data-stories/colorado-2013-floods/2018-02-05-coflood-04-flood-drivers-precipitation/2018-02-05-coflood-04-flood-drivers-precipitation_7_0.png" alt = "Plot of Daily Average Stream Discharge (CFS) for Boulder Creek from August 15th to September 15th, 2013 for a National Weather Service COOP site located in Boulder, CO.">
<figcaption>Plot of Daily Average Stream Discharge (CFS) for Boulder Creek from August 15th to September 15th, 2013 for a National Weather Service COOP site located in Boulder, CO.</figcaption>

</figure>



