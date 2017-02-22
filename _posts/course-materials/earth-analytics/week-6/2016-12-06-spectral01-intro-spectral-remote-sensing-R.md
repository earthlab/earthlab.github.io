---
layout: single
title: "Intro to spectral remote sensing"
excerpt: "This lesson overviews the key components of spectral remote sensing. We briefly overview: active vs passive sensors, the electromagnetic spectrum and spaceborne vs airborne sensors. "
authors: ['Leah Wasser']
modified: '2017-02-22'
category: [course-materials]
class-lesson: ['spectral-data-fire-r']
permalink: /course-materials/earth-analytics/week-6/intro-spectral-data-r/
nav-title: 'Intro spectral data'
module-title: 'Understanding fire using spectral remote sensing data'
module-description: 'This teaching module overviews the use of spectral remote sensing data to better understand fire activity. In it we will review spectral remote sensing as a passive type of remote sensing and how to work with spaceborne vs airborne remote sensing data in R. We cover raster stacks in R, plotting multi band compositie images, calculating vegetation indices and creating functions to make the processing more efficient in R.'
module-nav-title: 'Fire / spectral remote sensing data - in R'
module-type: 'class'
week: 6
sidebar:
  nav:
author_profile: false
comments: true
order: 1
---

{% include toc title="In This Lesson" icon="file-text" %}

<div class='notice--success' markdown="1">

## <i class="fa fa-graduation-cap" aria-hidden="true"></i> Learning Objectives

After completing this tutorial, you will be able to:

* Define spectral and spatial resolution. Explain how the two types of resolution are different.
* Describe atleast 3 differences between NAIP imagery, Landsat 8 and MODIS in terms of how the data are collected, how frequently they are collected and the spatial & spectral resolution.
* Describe the spatial and temporal tradeoffs between data collected from a satellite vs. an airplane.

## <i class="fa fa-check-square-o fa-2" aria-hidden="true"></i> What you need

You will need a computer with internet access to complete this lesson and the
data for week 6 of the course.

[<i class="fa fa-download" aria-hidden="true"></i> Download Week 6 Data (~500 MB)](https://ndownloader.figshare.com/files/7636975){:data-proofer-ignore='' .btn }



</div>



## About Spectral Remote Sensing

In the previous weeks of this course, we talked about lidar remote sensing. If
you recall, a lidar instrument is an active remote sensing instrument. This means
that the instrument emits energy actively rather than collecting information about
light energy from another source (the sun). This week we will work with spectral
remote sensing. Spectral remote sensing is a passive remote sensing type. This
means the the sensor is measuring light energy from an existing source - in this
case the sun.


<figure class="half">
   <img src="{{ site.url }}/images/course-materials/earth-analytics/week-6/active-vs-passive.png" alt="passive remote sensing">
   <img src="{{ site.url }}/images/course-materials/earth-analytics/week-6/active-rs.png" alt="active remote sensing">
   <figcaption>LEFT: Remote sensing systems which measure energy that is naturally
   available are called passive sensors. RIGHT: Active sensors emit their own
   energy from a source on the instrument itself. Source:
    <a href="http://www.nrcan.gc.ca/sites/www.nrcan.gc.ca/files/earthsciences/images/resource/tutor/fundam/images/passiv.gif" target="_blank">Natural Resources Canada</a>.
   </figcaption>
</figure>

## Electromagnetic spectrum

To
better understand spectral remote sensing we need to review
some basic principles of the electromagnetic spectrum.

The electromagnetic spectrum is composed of a range of different wavelengths or
"colors / types" of light energy. A spectral remote sensing instrument collects
light energy within specific regions of the electromagnetic spectrum. We call each
region in the spectrum a band.

<iframe width="560" height="315" src="https://www.youtube.com/embed/3iaFzafWJQE?rel=0" frameborder="0" allowfullscreen></iframe>

Above: a video overview of spectral remote sensing.

<iframe width="560" height="315" src="https://www.youtube.com/embed/jaARDWeyNDE" frameborder="0" allowfullscreen></iframe>

Above: Watch the first 8 minutes for a nice overview of spectral remote sensing.

# Key Attributes of spectral remote sensing data

## Space vs. airborne data
First, it is important to understand how the data are collected. Data can be collected
from the ground, the air (using airplanes or helicopters) or from space. You can
imagine that data that are collected from space are often of a lower spatial
resolution compared to data collected from an airplane. The tradeoff however
is that data collected from an satellite often offer better (even global) coverage.

For example the landsat 8 satellite has a 16 day repeat cycle for the entire globe.
This means that you can find a new image for an area, every 16 days. It takes a
lot of time and financial resources collect airborne data. Thus data are often
only available for smaller geographic areas. Also, you may not find the data are
available for multiple time periods OR, in the case of NAIP, you may have a new
dataset ever 2-4 years.


<figure>
   <img src="{{ site.url }}/images/course-materials/earth-analytics/week-6/space-airborne.png" alt="space vs airborne remote sensing">
   <figcaption>Spaceborn vs airborne remote sensing. Notice that spaceborn data
   are often of lower resolution however beacuse a satellite rotates continuously
   around the earth, the spatial coverage may be better than airborne data. Source:http://www.cartospace.com/?page_id=22
   </figcaption>
</figure>

## Bands and Wavelengths

When talking about spectral data, we need to understand both the electromagnetic
spectrum and image bands. Spectral remote sensing data are collected by powerful
camera like instruments known as imaging spectrometers. Imaging spectrometers
collect reflected light energy in "bands".

A *band* represents a segment of the electromagnetic
spectrum. You can think of it as a bin of one "type" of light. For example, the
wavelength values between 800nm and 850nm might be one
band captured by an imaging spectrometer. The imaging spectrometer collects
reflected light energy within a pixel area on the ground. Because an imaging spectrometer
collects many different types of light - for each pixel, the amount of light energy
for each type of light or band, will be recorded. So for eample a camera records
the amount of red, green and blue light for each pixel.

Often when you work with a multispectral dataset, the band information is reported as the center
wavelength value. This value represents the center point value of the wavelengths
represented in that  band. Thus in a band spanning 800-850 nm, the center would
be 825).

<figure>
    <a href="{{ site.url }}/images/course-materials/earth-analytics/week-6/spectrumZoomed.png">
    <img src="{{ site.url }}/images/course-materials/earth-analytics/week-6/spectrumZoomed.png" alt="Spectrum zoomed in."></a>
    <figcaption>Imaging spectrometers collect reflected light information within defined bands or regions of the electromagnetic spectrum.</figcaption>
</figure>

## Spectral Resolution
The spectral resolution of a dataset that has more than one band, refers to the
spectral width of each band in the dataset. In the image above, a band was
defined as spanning 800-810nm. The spectral width or spectral resolution of the
band is thus 10 nanometers. To see an example of this, check out the band widths
for the <a href="http://landsat.usgs.gov/band_designations_landsat_satellites.php" target="_blank">Landsat sensors</a>.

While a general spectral resolution of the sensor is often provided, not all
sensors collect information within bands of uniform widths.

## Spatial Resolution

The spatial resolution of a raster represents the area on the ground that each
pixel covers. If you have smaller pixels in a raster the data will appear more
"detailed". If you have large pixels in a raster, the data will appear more
coarse or "fuzzy".

If high resolution the data show us more about what is happening on the earth's surface
why wouldn't we always just collect high resolution data (smaller
pixels?)

<figure>
    <a href="{{ site.url }}/images/course-materials/earth-analytics/week-6/pixel-detail.png">
    <img src="{{ site.url }}/images/course-materials/earth-analytics/week-6/pixel-detail.png" alt="Detail of a 1 meter pixel."></a>
    <figcaption>The spatial resolution of a raster represents the area on the
    ground that each pixel covers. Source: Colin Williams, NEON.</figcaption>
</figure>
<figure>
    <a href="{{ site.url }}/images/course-materials/earth-analytics/week-3/raster-resolution.png">
    <img src="{{ site.url }}/images/course-materials/earth-analytics/week-3/raster-resolution.png" alt="Raster resolution."></a>
    <figcaption>Remote sensing data is collected at varying spatial resolutions.
    Remember that the spatial resolution represents that area on the ground
    that each pixel covers. Source: Colin Williams, NEON.</figcaption>
</figure>

## NAIP, Landsat & MODIS

In this week's class, we will look at 3 types of spectral remote sensing data.

1. NAIP
2. Landsat
3. MODIS


### NAIP imagery

We will work with NAIP imagery in the next lesson. NAIP imagery typically has
red, green and blue bands. However, sometimes, there is a 4th
near-infrared band available. NAIP imagery typically is 1m spatial resolution.
This means that each pixel represents 1 meter on the earth's surface. NAIP is
often collected using a camera mounted on an airplane.

### Landsat 8 imagery

Compared to NAIP, Landsat data are collected using an instrument mounted on a
satellite which orbits the globe, continuously collecting images. The landsat
instrument collects data at 30 meter spatial resolution but also has 11 bands
distributed across the electromagnetic spectrum compared to the 3 or 4 that
NAIP imagery has. Landsat also has one panchromatic band that collects information
across the visible portion of the spectrum at 15 m spatial resolution.


Landsat 8 bands 1-9 are listed below:

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

Above: Source - <a href="http://landsat.usgs.gov" target="_blank">http://landsat.usgs.gov</a>




<figure>
    <a href="{{ site.url }}/images/course-materials/earth-analytics/week-6/Landsat8_BandsUses.png">
    <img src="{{ site.url }}/images/course-materials/earth-analytics/week-6/Landsat8_BandsUses.png" alt="landsat 8 bands image">
    </a>
    <figcaption>The bands for Landsat 7 (bottom) vs Landsat 8 (top).
    there are several other landsat instruments that provide data - the most
    commonly used being Landsat 5 and 7. The specifications for each instrument are
    different. Source: USGS Landsat.</figcaption>
</figure>


### MODIS imagery
The Moderate Resolution Imaging Spectrometer (MODIS) instrument is another
satellite based instrument that continuously collects
data over the Earth's surface. MODIS collects spectral information at several
spatial resolutions including 250m, 500m and 1000m. We will be working with the
500 m spatial resolution MODIS data in this class. MODIS has 36 bands to work with
however in class we will focus on the first 7 bands.

#### First 7 MODIS Bands

Below, you can see the first 7 bands of the MODIS instrument

| Band | Wavelength range (nm) | Spatial Resolution (m) | Spectral Width (nm)|
|-------------------------------------|------------------|--------------------|----------------|
| Band 1 - red | 620 - 670 | 250 | 2.0 |
| Band 2 - near infrared | 841 - 876 | 250 | 6.0 |
| Band 3 -  blue/green | 459 - 479 | 500 | 6.0 |
| Band 4 - green | 545 - 565 | 500 | 3.0 |
| Band 5 - near infrared  | 1230 – 1250 | 500 | 8.0  |
| Band 6 - mid-infrared | 1628 – 1652 | 500 | 18 |
| Band 7 - mid-infrared | 2105 - 2155 | 500 | 18 |


In the next lesson, we will dive further into multi-band imagery. We will begin
to work with NAIP imagery in `R`.

<div class="notice--info" markdown="1">

## Additional resources:

* <a href="
http://biodiversityinformatics.amnh.org/interactives/bandcombination.php" target="_blank" data-proofer-ignore=''>Learn more about band combinations</a>
* <a href="
https://www.e-education.psu.edu/natureofgeoinfo/c8_p12.html" target="_blank" data-proofer-ignore=''>About multi spectral data - Penn State E-education</a>

</div>
