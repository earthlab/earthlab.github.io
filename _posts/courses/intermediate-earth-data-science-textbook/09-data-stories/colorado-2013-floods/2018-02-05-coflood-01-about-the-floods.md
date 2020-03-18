---
layout: single
title: 'An Overview of the 2013 Colorado Floods'
excerpt: "The 2013 flood event caused significant damage throughout the state of Colorado, USA. Learn about what caused the 2013 floods in Colorado and also some of the impacts."
authors: ['Leah Wasser', 'Lauren Herwehe']
dateCreated: 2018-05-24
modified: 2020-03-18
category: [courses]
class-lesson: ['about-2013-floods-tb']
course: 'intermediate-earth-data-science-textbook'
chapter: 20
permalink: /courses/use-data-open-source-python/data-stories/colorado-floods-2013/
nav-title: 'CO Flood Overview'
module-title: 'An Overview of the 2013 Floods in Colorado, USA'
module-nav-title: 'Flood overview '
module-description: 'In this module you will learn about the causes and effects of floods as seen during the 2013 Colorado floods. You will learn how streamflow, precipitation, drought, and remote sensing data are used to better understand flooding.'
module-type: 'class'
class-order: 1
week: 9
sidebar:
  nav:
author_profile: false
comments: true
order: 1
topics: 
    remote-sensing: ['multispectral-remote-sensing']
    earth-science: ['flood-erosion']
    time-series:  
redirect_from:
  - "/courses/earth-analytics-python/python-open-science-toolbox/an-overview-of-the-floods/"
  - "/courses/use-data-open-source-python/data-stories/colorado-2013-floods/an-overview-of-the-colorado-2013-floods/"
---

{% include toc title="In This Chapter" icon="file-text" %}

<div class='notice--success' markdown="1">

## <i class="fa fa-ship" aria-hidden="true"></i> Chapter 20 - The 2013 Colorado Floods 

In this chapter, you will learn about the 2013 floods in Colorado and describe the events and conditions leading up to the floods. 


## <i class="fa fa-graduation-cap" aria-hidden="true"></i> Learning Objectives

After completing this chapter, you will be able to:

* Describe the events that lead up to the 2013 Colorado Floods.
* Describe how atmospheric conditions contribute to flood events.
* Describe one method that is used to study and track atmospheric conditions.

</div>


## About The 2013 Colorado Flood

In early September 2013, a slow moving cold front moved through Colorado intersecting with a warm, humid front. The clash between the cold and warm fronts yielded heavy rain and devastating flooding across the Front Range of Colorado. Boulder County, Colorado, located where the Rocky Mountains meet the high plains, was impacted by this flood event. 

<figure>
 <a href="{{ site.url }}/images/earth-analytics/science/colorado-2013-floods/map-of-the-front-range-colorado-floods.jpg">
 <img src="{{ site.url }}/images/earth-analytics/science/colorado-2013-floods/map-of-the-front-range-colorado-floods.jpg" alt = "Map of Boulder, Colorado and the Front Range."></a>
 <figcaption> You can see Boulder just northwest of Denver in this map of Colorado. The Front Range runs from Wyoming to Pueblo, Colorado. Source: <a href="https://commons.wikimedia.org/wiki/File:Colorado_ref_2001.jpg" target="_blank">Wikipedia.</a>
 </figcaption>
</figure>


## What Is a Flood?

A flood is when water inundates normally dry land. Scientists (ecologists) often refer to floods as disturbance events. A disturbance event is a temporary change in environmental conditions that causes a large change to an ecosystem. Fires, earthquakes, tsunamis, air pollution, and human development are all examples of disturbance events. While floods and other disturbance events can happen in the span of a few minutes or days, their ecological impacts can last for decades or even longer. Other scientists may refer to floods as extreme events or even hazards.

<figure>
 <a href="{{ site.url }}/images/earth-analytics/science/colorado-2013-floods/broomfield-destruction-colorado-floods.jpg">
 <img src="{{ site.url }}/images/earth-analytics/science/colorado-2013-floods/broomfield-destruction-colorado-floods.jpg" alt = "Vehicles destroyed by Colorado floods"></a>
 <figcaption>Vehicles lay submerged in a creek in Broomfield, Colorado. Source: <a href="https://www.denverpost.com/2015/09/12/two-years-later-2013-colorado-floods-remain-a-nightmare-for-some/" target="_blank">The Denver Post.</a>
 </figcaption>
</figure>


## A History of Floods in Colorado

<figure>
 <a href="{{ site.url }}/images/earth-analytics/science/colorado-2013-floods/st-vrain-creek-before-and-after-colorado-floods.jpg">
 <img src="{{ site.url }}/images/earth-analytics/science/colorado-2013-floods/st-vrain-creek-before-and-after-colorado-floods.jpg" alt = "The St. Vrain River before and after the Colorado floods"></a>
 <figcaption>Aerial image of the St. Vrain River in Boulder County, Colorado before (right) and after (left) the 2013 Colorado floods. Notice how the flood caused the flow path of the river to entirely shift in less than five days. This change in river flow impacted plants, animals, and humans. Source: <a href="http://krcc.org/post/post-flood-planning-boulder-county" target="_blank">KRCC.</a>
 </figcaption>
</figure>


Boulder County, and Colorado in general, are susceptible to both flash floods and river floods. Flash floods, like the 2013 Colorado floods, are sudden and intense increases in streamflow, usually due to extreme weather. River floods occur more slowly and are more predictable. The 2013 floods are classified as a “100 year flood.” This means that a flood of their magnitude has a 1% chance of occurring each year. The first major flood reported in Boulder occurred in 1894 and was also a 100 year flood. Boulder’s first non-native settlers came in 1858, so many unreported floods likely occurred prior to that one.

<figure>
 <a href="{{ site.url }}/images/earth-analytics/science/colorado-2013-floods/boulder-100-year-floodplain-colorado-floods.jpg">
 <img src="{{ site.url }}/images/earth-analytics/science/colorado-2013-floods/boulder-100-year-floodplain-colorado-floods.jpg" alt = "The 100-year floodplain in Boulder"></a>
 <figcaption>The 100-year floodplain in Boulder. Source: <a href="http://floodsafety.com/media/maps/colorado/Boulder/index.htm" target="_blank">Floodsafety.com.</a>
 </figcaption>
</figure>


Boulder County’s landscape makes it prone to flooding. The nearby mountains create steep slopes and canyons which act as chutes ejecting water into the downstream plains. These mountains also create atmospheric conditions that lend to frequent isolated storms. In addition, the Front Range of Colorado is susceptible to wildfires and drought. These disturbance events make soil less able to absorb water, which both increases the likelihood of and exacerbates flooding.

## How Do You Measure Flood Events and Impacts?

You can measure causes and effects of floods with a variety of data types including precipitation data, drought indices, stream discharge data, lidar terrain data and other remotely sensed imagery that shows areas that have visually changed due to erosion, mudslides and other impacts. 



| Data Type                     | Potential Data Source                                                                                              |
|-------------------------------|--------------------------------------------------------------------|
| Atmospheric Conditions        | <a href="https://www.weather.gov/satellite#vis" target = "_blank">National Oceanic and Atmospheric Association (NOAA) GOES Satellite Data</a>  |
| Drought                       | <a href="https://drought.unl.edu/droughtmonitoring/Tools.aspx" target = "_blank">National Drought Mitigation Center Drought Monitor </a> |
| Precipitation                 | <a href="https://www.ncdc.noaa.gov/cdo-web/search" target = "_blank">National Weather Service COOP data </a> |
| Stream Discharge              | <a href="https://waterdata.usgs.gov/nwis/dv?referred_module=sw&search_criteria=state_cd&search_criteria=site_tp_cd&submitted_form=introduction" target = "_blank">United States Geological Survey (USGS) Surface Water Data</a>|
| Lidar Terrain Data            | USGS Lidar Data |
| Other remotely sensed imagery | USGS Landsat Data, European Space Agency Sentinel-2 Data, United States Department of Agriculture (USDA) NAIP Data |
|                               |                      


In the following sections you will learn more about each of the drivers and impacts of the floods and the data used to quantify these drivers and impacts. You will then learn how to work with different types of data in Python to better understand flood events including:

* Stream discharge data 
* Precipitation data
* Lidar data


