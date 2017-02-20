---
layout: single
title: "intro"
excerpt: ". "
authors: ['Leah Wasser']
modified: '2017-02-18'
category: [course-materials]
class-lesson: ['spectral-data-fire-r']
permalink: /course-materials/earth-analytics/week-6/intro-spectral-data-r/
nav-title: 'Intro spectral data'
module-title: 'Fire '
module-description: 'About here. here it is. '
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

*

## <i class="fa fa-check-square-o fa-2" aria-hidden="true"></i> What you need

You will need a computer with internet access to complete this lesson and the data for week 5 of the course.


</div>



## About Spectral Remote Sensing

In the previous weeks of this course, we talked about lidar remote sensing. If
you recall, a lidar instrument is an active remote sensing instrument. This means
that the instrument emits energy actively rather than collecting information about
light energy from another source (the sun). This week we will work with spectral
remote sensing. To better understand spectral remote sensing we need to review
some basic principles of the electromagnetic spectrum.

The electromagnetic spectrum is composed of a range of different wavelengths or
"colors / types" of light energy. A spectral remote sensing instrument collects
light energy within specific regions of the electromagnetic spectrum. We call each
region in the spectrum a band.

<iframe width="560" height="315" src="https://www.youtube.com/embed/3iaFzafWJQE?rel=0" frameborder="0" allowfullscreen></iframe>

Above: a video overview of spectral remote sensing.

# Key Metadata for Spectral Remote Sensing Data

## Bands and Wavelengths

A *band* represents a segment of the electromagnetic spectrum. You can think of it
as a bin. For example, the wavelength values between 800nm and 850nm might be one
band as captured by an imaging spectrometer. The imaging spectrometer collects
reflected light energy in a pixel for light in that band. Often when you work
with a multispectral dataset, the band information is reported as the center
wavelength value. This value represents the center point value of the wavelengths
represented in that  band. Thus in a band spanning 800-805 nm, the center would
be 825).

<figure>
    <a href="{{ site.baseurl }}/images/course-materials/earth-analytics/week-6/spectrumZoomed.png">
    <img src="{{ site.baseurl }}/images/course-materials/earth-analytics/week-6/spectrumZoomed.png" alt="Spectrum zoomed in."></a>
    <figcaption>Imaging spectrometers collect reflected light information within defined bands or regions of the electromagnetic spectrum.</figcaption>
</figure>

## Spectral Resolution
The spectral resolution of a dataset that has more than one band, refers to the width of each band in the dataset. In the example above, a band was defined as spanning 800-805nm. The width or Spatial Resolution of the band is thus 5 nanometers. To see an example of this, check out the band widths for the <a href="http://landsat.usgs.gov/band_designations_landsat_satellites.php" target="_blank">Landsat sensors</a>.


While a general spectral resolution of the sensor is often provided, not all
sensors create bands of uniform widths. For instance bands 1-9 of Landsat 8 are
listed below:


| Band | Wavelength range (microns) | Spatial Resolution (m) | Spectral Width (microns)|
|-------------------------------------|------------------|--------------------|----------------|
| Band 1 - Coastal aerosol | 0.43 - 0.45 | 30 | 0.02 |
| Band 2 - Blue | 0.45 - 0.51 | 30 | 0.06 |
| Band 3 - Green | 0.53 - 0.59 | 30 | 0.06 |
| Band 4 - Red | 0.64 - 0.67 | 30 | 0.03 |
| Band 5 - Near Infrared (NIR) | 0.85 - 0.88 | 30 | 0.03 |
| Band 6 - SWIR 1 | 1.57 - 1.65 | 30 | 0.08  |
| Band 7 - SWIR 2 | 2.11 - 2.29 | 30 | 0.18 |
| Band 8 - Panchromatic | 0.50 - 0.68 | 15 | 0.18 |
| Band 9 - Cirrus | 1.36 - 1.38 | 30 | 0.02 |


Above: Source - <a href="http://landsat.usgs.gov" target="_blank">http://landsat.usgs.gov</a>

## MODIS Bands

| Band | Wavelength range (microns) | Spatial Resolution (m) | Spectral Width (microns)|
|-------------------------------------|------------------|--------------------|----------------|
| Band 1 - red | .62 - .67 | 250 | 0.02 |
| Band 2 - near infrared | .841 - .876 | 250 | 0.06 |
| Band 3 -  blue/green | 459 - 479 | 500 | 0.06 |
| Band 4 - green | .545 - .565 | 500 | 0.03 |
| Band 5 - near infrared  | 1.23 – 1.25 | 500 | 0.08  |
| Band 6 - mid-infrared | 1628–1652 | 500 | 0.18 |
| Band 7 - mid-infrared | 2105 - 2155 | 500 | 0.18 |

### About Modis bands

## copy the band descriptions on this page:

http://biodiversityinformatics.amnh.org/interactives/bandcombination.php here:

Then cite the page
Band 1: This is similar to Landsat TM band 3.


## Something about rasters can have a few bands...

In the previous weeks, we've worked with rasters derived from lidar remote sensing
instruments. These rasters consisted of one layer or band. However raster data can
have multiple bands. an image that you take with your camera ...


<div class="notice--info" markdown="1">

## Additional resources:

*

</div>
