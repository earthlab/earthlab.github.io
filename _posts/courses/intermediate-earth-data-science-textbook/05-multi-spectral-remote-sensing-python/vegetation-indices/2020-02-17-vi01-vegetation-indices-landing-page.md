---
layout: single
title: "Calculate Vegetation Indices in Python"
excerpt: "A vegetation index is a single value that quantifies vegetation health or structure. Learn how to calculate the NDVI and NBR vegetation indices to study vegetation health and wildfire impacts in Python."
authors: ['Leah Wasser', 'Chris Holdgraf']
dateCreated: 2018-04-14
modified: 2020-03-18
category: [courses]
class-lesson: ['multispectral-remote-sensing-data-python-veg-indices']
permalink: /courses/use-data-open-source-python/multispectral-remote-sensing/vegetation-indices-in-python/
nav-title: 'Intro to Vegetation Indices'
module-title: 'NAIP, Landsat, MODIS and Vegetation Indices in Python'
module-description: 'Learn how to calculate vegetation indices from multispectral remote sensing data in Python. '
module-nav-title: 'Calculate Vegetation Indices in Python'
module-type: 'class'
chapter: 11
class-order: 5
week: 5
course: "intermediate-earth-data-science-textbook"
sidebar:
  nav:
author_profile: false
comments: true
order: 1
topics:
  remote-sensing: ['landsat', 'modis']
  earth-science: ['fire']
  reproducible-science-and-programming:
  spatial-data-and-gis: ['raster-data'] 
redirect_from:
  - "/courses/earth-analytics-python/multispectral-remote-sensing-modis/normalized-burn-index-dNBR/"
---

{% include toc title="In This Chapter" icon="file-text" %}

<div class='notice--success' markdown="1">

## <i class="fa fa-ship" aria-hidden="true"></i> Chapter Eleven - Calculate Vegetation Indices From Remote Sensing Data Using Python

In this chapter, you will learn how to calculate vegetation indices such as normalized difference vegetation index (NDVI) and normalized burn ratio (NBR) from multispectral remote sensing data in **Python**. 

## <i class="fa fa-graduation-cap" aria-hidden="true"></i> Learning Objectives

After completing this tutorial, you will be able to:

* Describe what a vegetation index is and how it is used with spectral remote sensing data.
* Describe how the `NDVI` index is used to quantify vegetation health (greeness).
* Calculate NDVI using multispectral imagery in **Python**.
* Describe how the `dNBR` index is used to quantify fire severity.
* Calculate `dNBR` using multispectral imagery in **Python**.


## <i class="fa fa-check-square-o fa-2" aria-hidden="true"></i> What You Need

You will need a computer with internet access to complete this lesson and the Cold Springs Fire data.

{% include /data_subsets/course_earth_analytics/_data-cold-springs-fire.md %}

</div>

## About Vegetation Indices

A vegetation index is a single value that quantifies vegetation health or structure.
The math associated with calculating a vegetation index is derived from the physics
of light reflection and absorption across bands. For instance, it is known that
healthy vegetation reflects light strongly in the near infrared band and less strongly
in the visible portion of the spectrum. 

Thus, if you create a ratio between light
reflected in the near infrared and light reflected in the visible spectrum, it
will represent areas that potentially have healthy vegetation.


## Normalized Difference Vegetation Index (NDVI)

The Normalized Difference Vegetation Index (NDVI) is a quantitative index of
greenness ranging from 0-1 where 0 represents minimal or no greenness and 1
represents maximum greenness.

NDVI is often used for a quantitate proxy measure of vegetation health, cover
and phenology (life cycle stage) over large areas.

<figure>
 <a href="{{ site.url }}/images/earth-analytics/remote-sensing/nasa-earth-observatory-ndvi-diagram.jpg">
 <img src="{{ site.url }}/images/earth-analytics/remote-sensing/nasa-earth-observatory-ndvi-diagram.jpg" alt="NDVI image from NASA that shows reflectance."></a>
    <figcaption>NDVI is calculated from the visible and near-infrared light
    reflected by vegetation. Healthy vegetation (left) absorbs most of the
    visible light that hits it, and reflects a large portion of
    near-infrared light. Unhealthy or sparse vegetation (right) reflects more
    visible light and less near-infrared light.  Source: NASA
    </figcaption>
</figure>

* <a href="http://earthobservatory.nasa.gov/Features/MeasuringVegetation/measuring_vegetation_2.php" target="_blank">
More on NDVI from NASA</a>

### How to Derive the NDVI Vegetation Index From Multispectral Imagery

The normalized difference vegetation index (NDVI) uses a ratio between near infrared
and red light within the electromagnetic spectrum. To calculate NDVI you use the
following formula where NIR is near infrared light and
red represents red light. For your raster data, you will take the reflectance value
in the red and near infrared bands to calculate the index.

`(NIR - Red) / (NIR + Red)`



{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}/images/courses/intermediate-earth-data-science-textbook/05-multi-spectral-remote-sensing-python/vegetation-indices/2020-02-17-vi01-vegetation-indices-landing-page/2020-02-17-vi01-vegetation-indices-landing-page_3_0.png" alt = "Plotting the NDVI calculation of the 2015 NAIP data with a colorbar that reflects the data.">
<figcaption>Plotting the NDVI calculation of the 2015 NAIP data with a colorbar that reflects the data.</figcaption>

</figure>




## Normalized Burn Ratio (NBR)

The Normalized burn ratio (NBR) is used to identify burned areas. The formula
is similar to a normalized difference vegetation index (NDVI), except that it
uses near-infrared (NIR) and shortwave-infrared (SWIR) portions of the
electromagnetic spectrum (Lopez, 1991; Key and Benson, 1995).

<figure class="half">
 <a href="{{ site.url}}/images/earth-analytics/remote-sensing/nbr-index.png">
 <img src="{{ site.url}}/images/earth-analytics/remote-sensing/nbr-index.png" alt="NBR - US Forest Service."></a>
    <figcaption>The normalized burn ratio (NBR) index uses the shortwave-infrared (SWIR) and near-infrared (NIR) portions of the electromagnetic
    spectrum.
    </figcaption>
</figure>

The NIR and SWIR parts of the electromagnetic spectrum are a powerful combination
of bands to use for this index given vegetation reflects strongly in the NIR region
of the electromagnetic spectrum and weakly in the SWIR. Alternatively, it has been
shown that a fire scar which contains scarred woody vegetation and earth will
reflect more strongly in the SWIR part of the electromagnetic spectrum and beyond
(see figure below).

<figure>
 <a href="{{ site.url}}/images/earth-analytics/remote-sensing/barc-spectral-response-US-forest-service.png">
 <img src="{{ site.url}}/images/earth-analytics/remote-sensing/barc-spectral-response-US-forest-service.png" alt="NBR - US Forest Service."></a>
    <figcaption>Plants reflect strongly in the NIR portion of the spectrum but
    spectrun. reflect much less strongly in the SWIR portion which makes this combination powerful for identifying areas with standing dead stems (fire scarred wood / bark) and soil / earth. Source: US Forest Service
    </figcaption>
</figure>


## NBR Bands

The NBR index was originally developed for use with Landsat TM and ETM+ bands 4 and 7,
but it will work with any multispectral sensor with a NIR
band between **760 - 900 nm** and a SWIR band between **2080 - 2350 nm**. Thus this
index can be used with both Landsat 8, MODIS and other multi (and hyper) spectral
sensors.

### NBR & Landsat 8

The table below which shows the band distribution of Landsat 8. These bands
are different from Landsat 7. What
bands should you use to calculate NBR using Landsat 8?

#### Landsat 8 Bands

| Band | Wavelength range (nanometers) | Spatial Resolution (m) | Spectral Width (nm)|
|-------------------------------------|------------------|--------------------|----------------|
| Band 1 - Coastal aerosol | 430 - 450 | 30 | 2.0 |
| Band 2 - Blue | 450 - 510 | 30 | 6.0 |
| Band 3 - Green | 530 - 590 | 30 | 6.0 |
| Band 4 - Red | 640 - 670 | 30 | 0.03 |
| Band 5 - Near Infrared (NIR) | 850 - 880 | 30 | 3.0 |
| Band 6 - SWIR 1 | 1570 - 1650 | 30 | 8.0  |
| Band 7 - SWIR 2 | 2110 - 2290 | 30 | 18 |
| Band 8 - Panchromatic | 500 - 680 | 15 | 18 |
| Band 9 - Cirrus | 1360 - 1380 | 30 | 2.0 |


### NBR & MODIS

Similarly the table below shows the band ranges for the MODIS sensor. What bands
should you use to calculate NBR using MODIS?

| Band | Wavelength range (nm) | Spatial Resolution (m) | Spectral Width (nm)|
|-------------------------------------|------------------|--------------------|----------------|
| Band 1 - red | 620 - 670 | 250 | 2.0 |
| Band 2 - near infrared | 841 - 876 | 250 | 6.0 |
| Band 3 -  blue/green | 459 - 479 | 500 | 6.0 |
| Band 4 - green | 545 - 565 | 500 | 3.0 |
| Band 5 - near infrared  | 1230 – 1250 | 500 | 8.0  |
| Band 6 - mid-infrared | 1628 – 1652 | 500 | 18 |
| Band 7 - mid-infrared | 2105 - 2155 | 500 | 18 |


### Example NBR Plots Calculated for Post and Pre Fire Landsat Images




{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}/images/courses/intermediate-earth-data-science-textbook/05-multi-spectral-remote-sensing-python/vegetation-indices/2020-02-17-vi01-vegetation-indices-landing-page/2020-02-17-vi01-vegetation-indices-landing-page_6_0.png" alt = "NBR - Post Cold Springs Fire using Landsat 8 data.">
<figcaption>NBR - Post Cold Springs Fire using Landsat 8 data.</figcaption>

</figure>






## Difference NBR

The Normalized Burn Ratio is most powerful as a tool to better understand fire
extent and severity when used after calculating the difference between pre and post
fire conditions. This
difference is best measured using data collected immediately before the fire and
then immediately after the fire.
NBR is less effective if time has passed and vegetation regrowth / regeneration
has begun after the fire. Once vegetation regeneration has begun, the fire scar will begin
to reflect a stronger signal in the NIR portion of the spectrum because
healthy plants reflect strongly in the NIR portion due to the properties of
chlorophyll).

For this reason, the NBR ratio works better in areas like the United States where
plant regeneration is expected to occur more slowly. In areas like the tropics
which are wet and characterized by rapid regrowth, NBR may be less effective.

To calculate the difference NBR, you subtract the post-fire NBR raster from the pre-fire
NBR raster as follows:

<figure>
 <a href="{{ site.url}}/images/earth-analytics/remote-sensing/dnbr-equation.jpg">
 <img src="{{ site.url}}/images/earth-analytics/remote-sensing/dnbr-equation.jpg" alt="NBR - US Forest Service."></a>
    <figcaption>difference NBR (dNBR) equation.  <a href="http://gsp.humboldt.edu/OLM/Courses/GSP_216_Online/lesson5-1/NBR.html" target = "_blank">Source Humboldt.edu</a>
    </figcaption>
</figure>

The classification table below can be used to classify the difference raster according to
the severity of the burn.

| SEVERITY LEVEL  | | dNBR RANGE |
|------------------------------|
| Enhanced Regrowth | | < -.1 |
| Unburned       |  | -.1 to +.1 |
| Low Severity     | | +.1 to +.27 |
| Moderate Severity  | | +.27 to +.66 |
|===
| High Severity     |  | > .66 |

### How Severe is Severe?

It is important to keep in mind that that the classification table above is one
quantitative interpretation of what the results of dNBR actually mean. The term
"severity" is a qualitative term that could be quantified in different ways.
For instance, who is to say that .5 couldn't be representative of "high severity"
vs .66?

As scientists, the best way to make sure your classification approaches represent
what is actually happening on the ground in terms of fire severity is to check
out the actual conditions on the ground. This process of confirming a value that
you get from remote sensing data by checking it on the ground is called validation.

You can review more about ground validation as it applies to lidar data in the  
<a href="{{ site.url }}/courses/use-data-open-source-python/spatial-data-applications/lidar-remote-sensing-uncertainty/">chapter on uncertainty in remote sensing data</a>.

### NBR & Water - False Positives

The NBR index can be a powerful tool to identify pixels that have a high likelyhood
or being "burned". However it is important to know that this index is also
sensitive to water and thus sometimes, pixels that are classified as "high severity"
may actually be water. Because of this, it is important to mask out areas of water
PRIOR to performing any quantitative analysis on the difference NBR results.






