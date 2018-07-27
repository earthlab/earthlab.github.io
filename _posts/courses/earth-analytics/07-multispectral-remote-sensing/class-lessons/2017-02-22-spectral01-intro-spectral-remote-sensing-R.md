---
layout: single
title: "Introduction to Spatial and Spectral Resolution: Multispectral Imagery"
excerpt: "Multispectral imagery can be provided at different resolutions and may contain different bands or types of light. Learn about spectral vs spatial resolution as it relates to spectral data."
authors: ['Leah Wasser']
modified: '2018-01-10'
category: [courses]
class-lesson: ['spectral-data-fire-r']
permalink: /courses/earth-analytics/multispectral-remote-sensing-data/introduction-multispectral-imagery-r/
nav-title: 'Intro Multispectral Data'
module-title: 'Multispectral imagery in R - Fire & Remote Sensing Data'
module-description: 'In this module, you will learn how to use multispectral imagery, a type of remote sensing data, to better understand changes in the landscape and how to calculate NDVI using various multispectral datasets You will also review spectral remote sensing as a passive type of remote sensing and how to work with space-borne vs airborne remote sensing data in R. Additionally, we will cover raster stacks in R, plotting multi-band composite images, calculating vegetation indices and creating functions to make the processing more efficient in R.'
module-nav-title: 'Fire / Spectral Remote Sensing Data in R'
module-type: 'class'
course: "earth-analytics"
week: 7
sidebar:
  nav:
author_profile: false
comments: true
order: 1
topics:
  remote-sensing: ['landsat', 'modis', 'naip', 'multispectral-remote-sensing']
lang-lib:
  r: ['raster']
redirect_from:
   - "/course-materials/earth-analytics/week-7/intro-spectral-data-r/"
   - "/courses/earth-analytics/spectral-remote-sensing-landsat/intro-spectral-data-r/"
---

{% include toc title="In This Lesson" icon="file-text" %}



<div class='notice--success' markdown="1">

## <i class="fa fa-graduation-cap" aria-hidden="true"></i> Learning Objectives

After completing this tutorial, you will be able to:

* Define spectral and spatial resolution and explain how they differ from one another.
* Describe *atleast* 3 differences between NAIP imagery, Landsat 8 and MODIS in terms of how the data are collected, how frequently they are collected and the spatial and spectral resolution.
* Describe the spatial and temporal tradeoffs between data collected from a satellite vs. an airplane.

## <i class="fa fa-check-square-o fa-2" aria-hidden="true"></i> What You Need

You will need a computer with internet access to complete this lesson and the
data for Weeks 7-9 of the course.

{% include /data_subsets/course_earth_analytics/_data-week6-7.md %}

</div>



## About Spectral Remote Sensing

In the previous weeks of this course, you learned about lidar remote sensing. If
you recall, a lidar instrument is an active remote sensing instrument. This means
that the instrument emits energy actively rather than collecting information about
light energy from another source (the sun). This week you will work with multispectral
imagery or multispectral remote sensing data. Multispectral remote sensing is a
passive remote sensing type. This means that the sensor is measuring light energy
from an existing source - in this case the sun.

<figure class="half">
   <img src="{{ site.url }}/images/courses/earth-analytics/remote-sensing/active-vs-passive.png" alt="passive remote sensing">
   <img src="{{ site.url }}/images/courses/earth-analytics/remote-sensing/active-rs.png" alt="active remote sensing">
   <figcaption>LEFT: Remote sensing systems which measure energy that is naturally
   available are called passive sensors. RIGHT: Active sensors emit their own
   energy from a source on the instrument itself. Source:
    <a href="http://www.nrcan.gc.ca/" target="_blank">Natural Resources Canada</a>.
   </figcaption>
</figure>

## Electromagnetic Spectrum

To better understand multispectral remote sensing you need to know
some basic principles of the electromagnetic spectrum.

The electromagnetic spectrum is composed of a range of different wavelengths or
"colors" of light energy. A spectral remote sensing instrument collects
light energy within specific regions of the electromagnetic spectrum. Each
region in the spectrum is referred to as a band.

<iframe width="560" height="315" src="https://www.youtube.com/embed/3iaFzafWJQE?rel=0" frameborder="0" allowfullscreen></iframe>

Above: A video overview of spectral remote sensing.

<iframe width="560" height="315" src="https://www.youtube.com/embed/jaARDWeyNDE" frameborder="0" allowfullscreen></iframe>

Above: Watch the first 8 minutes for a nice overview of spectral remote sensing.

# Key Attributes of Spectral Remote Sensing Data

## Space vs Airborne Data

Remote sensing data can be collected from the ground, the air (using airplanes or
helicopters) or from space. You can imagine that data that are collected from space 
are often of a lower spatial resolution than data collected from an airplane. The 
tradeoff however is that data collected from a satellite often offers better (up 
to global) coverage.

For example the Landsat 8 satellite has a 16 day repeat cycle for the entire globe.
This means that you can find a new image for an area, every 16 days. It takes a
lot of time and financial resources to collect airborne data. Thus data are often
only available for smaller geographic areas. Also, you may not find that the data are
available for the time periods that you need. For example, in the case of NAIP, you 
may only have a new dataset every 2-4 years.


<figure>
   <img src="{{ site.url }}/images/courses/earth-analytics/remote-sensing/space-airborne.png" alt="space vs airborne remote sensing">
   <figcaption>Spaceborne vs airborne remote sensing. Notice that spaceborne data
   are often of lower resolution, however, because a satellite rotates continuously
   around the earth, the spatial coverage may be better than airborne data. <a href="http://www.cartospace.com/?page_id=22" target="_blank">Source: Cartospace</a>
   </figcaption>
</figure>

## Bands and Wavelengths

When talking about spectral data, you need to understand both the electromagnetic
spectrum and image bands. Spectral remote sensing data are collected by powerful
camera-like instruments known as imaging spectrometers. Imaging spectrometers
collect reflected light energy in "bands."

A *band* represents a segment of the electromagnetic
spectrum. You can think of it as a bin of one "type" of light. For example, the
wavelength values between 800 nanometers (nm) and 850 nm might be one
band captured by an imaging spectrometer. The imaging spectrometer collects
reflected light energy within a pixel area on the ground. Since an imaging spectrometer
collects many different types of light - for each pixel the amount of light energy
for each type of light or band will be recorded. So, for example, a camera records
the amount of red, green and blue light for each pixel.

Often when you work with a multispectral dataset, the band information is reported as the center
wavelength value. This value represents the center point value of the wavelengths
represented in that  band. Thus in a band spanning 800-850 nm, the center would
be 825 nm.

<figure>
    <a href="{{ site.url }}/images/courses/earth-analytics/remote-sensing/spectrumZoomed.png">
    <img src="{{ site.url }}/images/courses/earth-analytics/remote-sensing/spectrumZoomed.png" alt="Spectrum zoomed in."></a>
    <figcaption>Imaging spectrometers collect reflected light information within defined bands or regions of the electromagnetic spectrum.</figcaption>
</figure>

## Spectral Resolution
The spectral resolution of a dataset that has more than one band, refers to the
spectral width of each band in the dataset. In the image above, a band was
defined as spanning 800-810 nm. The spectral width or spectral resolution of the
band is thus 10 nm. To see an example of this, check out the band widths
for the <a href="http://landsat.usgs.gov/band_designations_landsat_satellites.php" target="_blank">Landsat sensors</a>.

While a general spectral resolution of the sensor is often provided, not all
sensors collect information within bands of uniform widths.

## Spatial Resolution

The spatial resolution of a raster represents the area on the ground that each
pixel covers. If you have smaller pixels in a raster the data will appear more
"detailed." If you have large pixels in a raster, the data will appear more
coarse or "fuzzy."

If high resolution data shows you more about what is happening on the Earth's surface
why wouldn't you always just collect high resolution data (smaller
pixels)?

If you recall, you learned about raster spatial resolution when you worked with lidar
elevation data in previous lessons. The same resolution concepts apply to multispectral data.

<figure>
    <a href="{{ site.url }}/images/courses/earth-analytics/raster-data/raster-pixel-resolution.png">
    <img src="{{ site.url }}/images/courses/earth-analytics/raster-data/raster-pixel-resolution.png" alt="Detail of a 1 meter pixel."></a>
    <figcaption>The spatial resolution of a raster represents the area on the
    ground that each pixel covers. Source: Colin Williams, NEON.</figcaption>
</figure>
<figure>
    <a href="{{ site.url }}/images/courses/earth-analytics/raster-data/raster-resolution.png">
    <img src="{{ site.url }}/images/courses/earth-analytics/raster-data/raster-resolution.png" alt="Raster resolution."></a>
    <figcaption>Remote sensing data is collected at varying spatial resolutions.
    Remember that the spatial resolution represents that area on the ground
    that each pixel covers. Source: Colin Williams, NEON.</figcaption>
</figure>

## NAIP, Landsat & MODIS

In this week's class, you will look at 2 types of spectral remote sensing data:

1. NAIP
2. Landsat

Next week you will work with MODIS data.

### About NAIP Multispectral Imagery

NAIP imagery is available in the United States and typically has three bands -
red, green and blue. However, sometimes, there is a 4th near-infrared band available.
NAIP imagery typically is 1m spatial resolution, meaning that each pixel represents
1 meter on the Earth's surface. NAIP data is often collected using a camera mounted on
an airplane and is collected for a given geographic area every few years.

### Landsat 8 Imagery

Compared to NAIP, Landsat data are collected using an instrument mounted on a
satellite which orbits the globe, continuously collecting images. The Landsat
instrument collects data at 30 meter spatial resolution but also has 11 bands
distributed across the electromagnetic spectrum compared to the 3 or 4 that
NAIP imagery has. Landsat also has one panchromatic band that collects information
across the visible portion of the spectrum at 15 m spatial resolution.

Landsat 8 bands 1-9 are listed below:

#### Landsat 8 Bands

| Band | Wavelength range (nm) | Spatial Resolution (m) | Spectral Width (nm)|
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

Source: <a href="http://landsat.usgs.gov" target="_blank">USGS Landsat</a>

<figure>
    <a href="{{ site.url }}/images/courses/earth-analytics/remote-sensing/Landsat8_BandsUses.png">
    <img src="{{ site.url }}/images/courses/earth-analytics/remote-sensing/Landsat8_BandsUses.png" alt="landsat 8 bands image">
    </a>
    <figcaption>The bands for Landsat 7 (bottom) vs Landsat 8 (top).
    there are several other Landsat instruments that provide data - the most
    commonly used being Landsat 5 and 7. The specifications for each instrument are
    different. Source: USGS Landsat.</figcaption>
</figure>


### MODIS Imagery
The Moderate Resolution Imaging Spectrometer (MODIS) instrument is another
satellite based instrument that continuously collects
data over the Earth's surface. MODIS collects spectral information at several
spatial resolutions including 250m, 500m and 1000m. You will be working with the
500 m spatial resolution MODIS data in this class. MODIS has 36 bands
however in class you will learn about only the first 7 bands.

#### First 7 MODIS Bands

Below, you can see the first 7 bands of the MODIS instrument

| Band | Wavelength range (nm) | Spatial Resolution (m) | Spectral Width (nm)|
|-------------------------------------|------------------|--------------------|----------------|
| Band 1 - red | 620 - 670 | 250 | 2.0 |
| Band 2 - near infrared | 841 - 876 | 250 | 6.0 |
| Band 3 -  blue/green | 459 - 479 | 500 | 6.0 |
| Band 4 - green | 545 - 565 | 500 | 3.0 |
| Band 5 - near infrared  | 1230 | 1250 | 500 | 8.0  |
| Band 6 - mid-infrared | 1628 | 1652 | 500 | 18 |
| Band 7 - mid-infrared | 2105 - 2155 | 500 | 18 |


In the next lesson, you will learn how to work with NAIP imagery in `R`.

<div class="notice--info" markdown="1">

## Additional Resources:

* <a href="http://biodiversityinformatics.amnh.org/interactives/bandcombination.php" target="_blank" data-proofer-ignore=''>Learn more about band combinations</a>
* <a href="https://www.e-education.psu.edu/natureofgeoinfo/c8_p12.html" target="_blank" data-proofer-ignore=''>About multispectral data - Penn State e-Education</a>

</div>
