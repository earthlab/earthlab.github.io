---
layout: single
title: "Remote Sensing to Study Wildfire"
excerpt: "Scientists often use remote sensing methods to study the impacts of wildfire through calculations of vegetation indices before and after wildfire. Learn more about how remote sensing can be used to study wildfire impacts."
authors: ['Leah Wasser']
dateCreated: 2018-10-04
modified: 2020-03-18
category: [courses]
class-lesson: ['wildfire-overview-tb']
permalink: /courses/use-data-open-source-python/data-stories/cold-springs-wildfire/wildfire-remote-sensing/
nav-title: 'Remote Sensing of Wildfire Impacts'
week: 9
course: 'intermediate-earth-data-science-textbook'
module-type: 'class'
sidebar:
  nav:
author_profile: false
comments: true
order: 3
topics:
  remote-sensing: ['multispectral-remote-sensing']
  earth-science: ['fire']
redirect_from:
  - "/courses/earth-analytics-python/multispectral-remote-sensing-in-python/wildfire-remote-sensing/"
---

{% include toc title="On This Page" icon="file-text" %}

<div class='notice--success' markdown="1">

## <i class="fa fa-graduation-cap" aria-hidden="true"></i> Learning Objectives

* Explain how scientists use remote sensing to study wildfire impacts.
* List two primary vegetation indices that are used to study wildfire impacts.
* List four primary sources of remote sensing data that can be used to study wildfire.

</div>


## Use Remote Sensing Data to Understand Fire Impacts

Remote sensing data are often used to study fires. Remote sensing data, collected from satellites and airplanes, allow you to gather information about the landscape over time. Data collected from satellites like Landsat and MODIS are freely available and collected regularly across the globe. 

Since remote sensing data are collected over time, they can be used to, among other things:
* Track changes in vegetation.
* Understand the area and intensity of fires.
* Monitor the post-fire vegetation dynamics of burned areas. 

## Remote Sensing Derived Vegetation Indices to Understand Fire Impacts

**Vegetation indices** can be useful tools for quantifying and visualizing the before and after effects of wildfire. They are calculations performed on specific spectral bands of remotely sensed imagery to accentuate a particular vegetation characteristic. They can be used for anything from understanding disasters like floods or fires to deciding when to irrigate crops. 

To calculate a vegetation index, you will need access to specific imagery bands across the electromagnetic spectrum; in other words, you will need access to satellite imagery with a certain <a href="{{ site.url }}/courses/use-data-open-source-python/multispectral-remote-sensing/">spectral resolution.</a>

### Normalized Difference Vegetation Index (NDVI)

<a href="{{ site.url }}/courses/use-data-open-source-python/multispectral-remote-sensing/vegetation-indices-in-python/">The normalized difference vegetation index (NDVI)</a> is a vegetation index that is used to measure the greenness of the area. For the purpose of studying wildfires like the Cold Springs Fire, it allows you to visualize and quantify vegetation health before and after the fire. 

Further, you can use NDVI to track the rate of vegetation growing back in a burned area over time. This can tell you the speed of ecosystem recovery. In this course, you will learn how to calculate NDVI and create images like those below using Python.

<figure>
  <a href="{{ site.url }}/images/earth-analytics/science/cold-springs-fire/remote-sensing-ndvi-example-cold-springs-fire-2.png">
    <img src="{{ site.url }}/images/earth-analytics/science/cold-springs-fire/remote-sensing-ndvi-example-cold-springs-fire-2.png" alt="Remote sensing NDVI example image.">
  </a>
  <figcaption>In this NDVI image, the darker green areas have the most lush vegetation while the yellow and red areas lack vegetation. Source: <a href="https://commons.wikimedia.org/wiki/File:NDVI_062003.png#filelinks" target="_blank">Wikipedia.</a>
  </figcaption>
</figure>

<figure>
  <a href="{{ site.url }}/images/earth-analytics/science/cold-springs-fire/remote-sensing-ndvi-example-cold-springs-fire-1.jpg">
    <img src="{{ site.url }}/images/earth-analytics/science/cold-springs-fire/remote-sensing-ndvi-example-cold-springs-fire-1.jpg" alt="Remote sensing NDVI example image of an agricultural field.">
  </a>
  <figcaption>In this NDVI image of agricultural fields, red areas signify healthier vegetation.  Source: <a href="https://blog.mapbox.com/visualizing-ndvi-for-agriculture-ad35d7c5f27e" target="_blank">Mapbox.</a>
  </figcaption>
</figure>

### Normalized Burn Ratio (NBR)

<a href="{{ site.url }}/courses/use-data-open-source-python/multispectral-remote-sensing/vegetation-indices-in-python/">The normalized burn ratio (NBR)</a> is another vegetation index that allows you to visualize burned areas to understand fire severity. To use NBR to understand wildfire, you can perform the calculation on a remotely sensed image taken prior to the fire and on another taken after, and then calculate the difference between the two. 

This difference image is called a dNBR (difference NBR) image. The images below show an example of an dNBR image for the Cold Springs Fire. In this course, you will learn how to perform these calculations and create these images using Python.

<figure>
  <a href="{{ site.url }}/images/earth-analytics/science/cold-springs-fire/pre-fire-landsat-nbr-cold-springs-fire.png">
    <img src="{{ site.url }}/images/earth-analytics/science/cold-springs-fire/pre-fire-landsat-nbr-cold-springs-fire.png" alt="Image of the NBR of the Cold Springs fire site prior to the wildfire.">
  </a>
  <figcaption>This image shows the NBR of the site of the Cold Springs Fire prior to the fire with a boundary overlay of the fire extent. Source: Megan Cattau.
  </figcaption>
</figure>

<figure>
  <a href="{{ site.url }}/images/earth-analytics/science/cold-springs-fire/post-fire-landsat-nbr-cold-springs-fire.png">
    <img src="{{ site.url }}/images/earth-analytics/science/cold-springs-fire/post-fire-landsat-nbr-cold-springs-fire.png" alt="Image of the NBR of the Cold Springs fire site after the wildfire.">
  </a>
  <figcaption>This image shows the NBR of the site of the Cold Springs Fire after the fire with a boundary overlay of the fire extent. Source: Megan Cattau.
  </figcaption>
</figure>

<figure>
  <a href="{{ site.url }}/images/earth-analytics/science/cold-springs-fire/dnbr-landsat-cold-springs-fire.png">
    <img src="{{ site.url }}/images/earth-analytics/science/cold-springs-fire/dnbr-landsat-cold-springs-fire.png" alt="Image of the dNBR of the Cold Springs fire site.">
  </a>
  <figcaption>This dNBR image of the Cold Springs Fire site was calculated with the above before and after images from the fire site. Source: Megan Cattau.
  </figcaption>
</figure>

## Where to Find Remote Sensing Data

There are many different free and proprietary sources of remote sensing data. In this course, you will learn how to use the following types of satellite data to understand fire impacts:
* <a href="{{ site.url }}/courses/use-data-open-source-python/multispectral-remote-sensing/">NAIP</a> 
* <a href="{{ site.url }}/courses/use-data-open-source-python/multispectral-remote-sensing/">Landsat</a> 
* <a href="{{ site.url }}/courses/use-data-open-source-python/multispectral-remote-sensing/">MODIS</a> 

Each one of these data sets have different <a href="{{ site.url }}/courses/use-data-open-source-python/multispectral-remote-sensing/">spatial and temporal resolutions.</a> 


| Data Source | Spatial Resolution | Temporal Resolution | Spectral Resolution |
| ------------- |-------------| -------------|-------------|
|NAIP | Typically 1m (only in US) | Every few years | 3-4 bands |
| MODIS |250m, 500m, 1000m (depending on the band) | Daily, 8 day, 16 day, Monthly, Quarterly, Yearly (Depending on the product) | 36 bands |
| Landsat 8 | 30m | 16 days | 11 bands |
Sentinel-2 | 10m, 20m, 60m (depending on the band) | 5 days |12 bands |

