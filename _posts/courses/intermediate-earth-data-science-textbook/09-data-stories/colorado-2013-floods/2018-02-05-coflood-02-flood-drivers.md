---
layout: single
title: 'How the Atmosphere Drives Floods: The 2013 Colorado Floods'
excerpt: "Changes in the atmosphere, including how quickly a storm moves can impact the severity of a flood. Learn more about how atmospheric conditions impact flood events."
authors: ['Leah Wasser', 'Lauren Herwehe']
modified: 2020-03-18
category: [courses]
class-lesson: ['about-2013-floods-tb']
course: 'intermediate-earth-data-science-textbook'
chapter: 20
permalink: /courses/use-data-open-source-python/data-stories/colorado-floods-2013/how-atmospheric-conditions-and-drought-impact-floods/
nav-title: 'Atmosphere & Drought'
dateCreated: 2018-05-24
module-type: 'class'
week: 9
sidebar:
  nav:
author_profile: false
comments: true
order: 2
topics: 
    remote-sensing: ['multispectral-remote-sensing']
    earth-science: ['flood-erosion']
    time-series: 
redirect_from:
  - "/courses/earth-analytics-python/python-open-science-toolbox/how-atmospheric-conditions-and-drought-impact-floods/"
  - "/courses/use-data-open-source-python/data-stories/colorado-2013-floods/how-atmospheric-conditions-and-drought-impact-floods/"
---

{% include toc title="On This Page" icon="file-text" %}

<div class='notice--success' markdown="1">

## <i class="fa fa-graduation-cap" aria-hidden="true"></i> Learning Objectives

* Describe how atmospheric conditions contribute to flood events.
* Describe one method that is used to study and track atmospheric conditions.

</div>


## Primary Driver: Atmospheric Conditions - a Driver of Flood Impacts

### What Are Atmospheric Conditions?

Atmospheric conditions are what produces weather. The term refers to the physical conditions in the Earth’s atmosphere including temperature, wind, clouds, and precipitation.

### How Are Atmospheric Conditions Measured?

Atmospheric conditions can be measured with ground-based or satellite observations. Ground measurements can include air temperature and heat indices, barometric pressure, humidity, precipitation, wind speed and direction, and solar radiation. 

There are several satellites that track atmospheric conditions, the most popular being the NOAA operated Geostationary Operational Environmental Satellite System.

<figure>
 <a href="{{ site.url }}/images/earth-analytics/science/colorado-2013-floods/goes-satellite-data-colorado-floods.jpg">
 <img src="{{ site.url }}/images/earth-analytics/science/colorado-2013-floods/goes-satellite-data-colorado-floods.jpg" alt = "GOES satellite imagery of the rain that caused the 2013 Colorado floods."></a>
 <figcaption>This animated loop shows water vapor systems over the western area of North America during the Colorado floods, on September 12th, 2013, as recorded by the GOES-15 and GOES-13 satellites. Source: <a href="http://cimss.ssec.wisc.edu/goes/blog/archives/13876" target="_blank">Cooperative Institute for Meteorological Satellite Studies (CIMSS).</a>
 </figcaption>
</figure>


The GOES system consists of space and ground tools that work together to support weather forecasting, severe storm tracking, and meteorology research. GOES satellites are “geostationary” meaning that they always remain over one particular point on the Earth’s surface, allowing them to provide dependable information on weather conditions in that location.

### Where Can You Get Atmospheric Data?

One source of atmospheric data is GOES satellite data on this NOAA Geostationary Satellite Server.

### Atmospheric Conditions and the Colorado Floods

The storm that caused the 2013 flooding  in Boulder began when a slow moving cold front intersected with a warm, humid front leading to heavy rain. The storm was kept in a confined area over the Eastern Range of the Rocky Mountains in Colorado by water vapor systems. This confinement resulted in a large amount of rainfall being dumped over the region in a short period of time. Over the course of just five days Boulder County received more rainfall than it does in a typical year.

## Primary Driver: Drought as a Driver of Flood Impacts

### What is Drought?

Drought is a disturbance event that occurs when a given area experiences below average precipitation. It can also be caused and exacerbated by the way that humans choose to distribute water resources.

### How Are Droughts Measured?

There are many ways to measure or quantify drought. The Palmer Drought Severity Index is one commonly used drought index. The Palmer Drought Severity Index is a measure of soil moisture content. It is calculated from soil available water content, precipitation and temperature data. The values range from extreme drought (values <-4.0) through near normal (-.49 to .49) to extremely moist (>4.0). 



{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}/images/courses/intermediate-earth-data-science-textbook/09-data-stories/colorado-2013-floods/2018-02-05-coflood-02-flood-drivers/2018-02-05-coflood-02-flood-drivers_3_0.png" alt = "Plot of Palmer Drought Index for Colorado 2005-2016.">
<figcaption>Plot of Palmer Drought Index for Colorado 2005-2016.</figcaption>

</figure>




## Where Can You Get Drought Data?

You can obtain data on drought and read more about different ways to measure it on the National Drought Mitigation Center website.

## Drought and the Colorado Floods

The 2013 flood occurred right at the end of a severe drought in Colorado.


<figure>
 <a href="{{ site.url }}/images/earth-analytics/science/colorado-2013-floods/drought-dust-storm-colorado-floods.jpg">
 <img src="{{ site.url }}/images/earth-analytics/science/colorado-2013-floods/drought-dust-storm-colorado-floods.jpg" alt = "MODIS satellite image of a dust storm caused by drought in Colorado"></a>
 <figcaption>This MODIS satellite image of the Colorado-Kansas border shows a massive dust storm during the 2013 drought in Colorado. The image was taken in January, several months prior to the Colorado floods, and shows how drought led to soil transport that exacerbated the impacts of the flooding. Source: <a href="https://earthobservatory.nasa.gov/IOTD/view.php?id=80164" target="_blank">NASA Earth Observatory.</a>
 </figcaption>
</figure>


In a drought period, the top soil layers and the moisture-absorbing organic matter (generally plant and animal residues at various stages of decomposition) within them dry out. 

<figure>
 <a href="{{ site.url }}/images/earth-analytics/science/colorado-2013-floods/drought-soil-colorado-floods.jpg">
 <img src="{{ site.url }}/images/earth-analytics/science/colorado-2013-floods/drought-soil-colorado-floods.jpg" alt = "Dry, compacted soil during a drought "></a>
 <figcaption>Dry, compacted soil during a drought. Source: <a href="https://commons.wikimedia.org/wiki/File:CSIRO_ScienceImage_607_Effects_of_Drought_on_the_Soil.jpg" target="_blank">Wikipedia.</a>
 </figcaption>
</figure>


Dry organic matter is less able to absorb moisture. It also can be easily relocated by wind, leaving only the harder less permeable earth beneath it. Some soil types, like clay, can dry out so much that they become almost as impermeable as pavement and unable to absorb water. 

<figure>
 <a href="{{ site.url }}/images/earth-analytics/science/colorado-2013-floods/soil-layers-colorado-floods.jpg">
 <img src="{{ site.url }}/images/earth-analytics/science/colorado-2013-floods/soil-layers-colorado-floods.jpg" alt = "Soil layers diagram"></a>
 <figcaption>In this diagram of soils layers you can see the the organic and top soil layers that are often dried out during drought periods. Source:<a href="https://commons.wikimedia.org/wiki/File:Soil_Layers.jpg" target="_blank">Wikipedia.</a>
 </figcaption>
</figure>


All of this causes water to flow across the soil rather than being absorbed into the soil. Water flowing over the soil and earth is referred to as overland flow. Often times the floods that have significant impacts on an area have a lot of overland flow.
