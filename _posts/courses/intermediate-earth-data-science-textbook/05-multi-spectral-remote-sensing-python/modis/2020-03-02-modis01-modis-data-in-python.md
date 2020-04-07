---
layout: single
title: "Work with MODIS Remote Sensing Data using Open Source Python"
excerpt: "MODIS is a satellite remote sensing instrument that collects data daily across the globe at 250-500 m resolution. Learn how to import, clean up and plot MODIS data in Python."
authors: ['Leah Wasser', 'Jenny Palomino']
modified: 2020-04-01
category: [courses]
class-lesson: ['modis-multispectral-rs-python']
permalink: /courses/use-data-open-source-python/multispectral-remote-sensing/modis-data-in-python/
nav-title: 'MODIS Data in Python'
module-title: 'MODIS, Landsat and the Normalized Burn Ratio Index (NBR) in Python' 
module-description: 'MODIS is a satellite remote sensing instrument that collects data daily across the globe at 250-500 m resolution. Learn how to import, clean up and plot MODIS data in Python' 
module-nav-title: 'MODIS Data' 
module-type: 'class'
class-order: 4
chapter: 10
week: 5
course: "intermediate-earth-data-science-textbook"
sidebar:
  nav:
author_profile: false
comments: true
order: 1
topics:
  remote-sensing: ['modis']
  earth-science: ['fire']
  spatial-data-and-gis: ['raster-data']
  reproducible-science-and-programming: ['python']
redirect_from: 
  - /courses/earth-analytics-python/multispectral-remote-sensing-modis/modis-remote-sensing-data-in-python/
---
{% include toc title="In This Lesson" icon="file-text" %}

<div class='notice--success' markdown="1">

## <i class="fa fa-graduation-cap" aria-hidden="true"></i> Learning Objectives

After completing this tutorial, you will be able to:

* List the MODIS spectral bands and identify which bands should be used to calculate a normalized burn ratio (NBR)
* Import and stack MODIS imagery in `Python`.
* Scale MODIS surface reflectance values to the appropriate range using `Python`. 

## <i class="fa fa-check-square-o fa-2" aria-hidden="true"></i> What You Need

You will need a computer with internet access to complete this lesson and the Cold Springs Fire
data.

{% include /data_subsets/course_earth_analytics/_data-cold-springs-fire.md %}

</div>


## Introduction to MODIS Imagery

Moderate Resolution Imaging Spectrometer (MODIS) is a satellite-based instrument that continuously collects
data over the Earth's surface. Currently, MODIS has the finest temporal resolution of the publicly available remote sensing data, spanning the entire globe every 24 hrs. 

MODIS collects data across 36 spectral bands; however, in this class, you will only work with the first 7 bands. 

| Band | Wavelength range (nm) | Spatial Resolution (m) | 
|-------------------------------------|------------------|--------------------|
| Band 1 - red | 620 - 670 | 250 | 
| Band 2 - near infrared | 841 - 876 | 250 | 
| Band 3 -  blue/green | 459 - 479 | 500 |
| Band 4 - green | 545 - 565 | 500 | 
| Band 5 - near infrared  | 1230 – 1250 | 500 | 
| Band 6 - mid-infrared | 1628 – 1652 | 500 | 
| Band 7 - mid-infrared | 2105 - 2155 | 500 | 


### MODIS Surface Reflectance (MOD09GA Product)

There are many different MODIS data products. These are datasets that are processed for use in science. In this class, we are using the MOD09GA product, which is a reflectance product that includes the first 7 bands of MODIS.

The normal range of surface reflectance values is 0 to 1, where 1 is the BRIGHTEST value and 0 is the DARKEST value. Surface reflectance is a measure of the spectral reflectance of the earth's surface, as it would be if measured on the ground. You can think of it as what your eye would see, except of course, your eye can not see light outside of the visible part of the electromagnetic spectrum. 

<a href="https://modis.gsfc.nasa.gov/data/dataprod/mod09.php" target="_blank">MODIS</a> provides many standardized products, including the MOD09GA product of surface reflectance which you will use in this course. The MOD09GA product provides surface reflectance at a spatial resolution of 500m across the 7 spectral bands listed in the table above. 

According to the <a href="http://modis-sr.ltdri.org/" target="_blank">Land Surface Reflectance Science Computing Facility</a>, who creates the MOD09 products, the products are *estimates of the surface spectral reflectance for each band as it would have been measured at ground level as if there were no atmospheric scattering or absorption. It corrects for the effects of atmospheric gases, aerosols, and thin cirrus clouds.*

### Band Metadata for the MOD09GA Product

To better understand the MODIS data, have a look at the <a href="http://modis-sr.ltdri.org/guide/MOD09_UserGuide_v1_3.pdf" target="_blank">detailed table for the MOD09GA product in the MODIS users guide on page 14</a>.

Part of the table is below:

| Science Data Sets (HDF Layers (21)) | Units  | Data Type | Fill Value (no data) | Valid Range | Scale Factor |
|---|---|---|---|---|---|
| surf_Refl_b01: 500m Surface Reflectance Band 1 (620-670 nm) | Reflectance | 16-bit signed integer | -28672 | -100 to 16000 | 0.0001 |
| surf_Refl_b02: 500m Surface Reflectance Band 2 (841-876 nm) | Reflectance | 16-bit signed integer  | -28672 | -100 to 16000 | 0.0001 |
| surf_Refl_b03: 500m Surface Reflectance Band 3 (459-479 nm)| Reflectance | 16-bit signed integer  | -28672 | -100 to 16000 | 0.0001 |
| surf_Refl_b04: 500m Surface Reflectance Band 4 (545-565 nm)| Reflectance | 16-bit signed integer  | -28672 | -100 to 16000 | 0.0001 |
| surf_Refl_b05: 500m Surface Reflectance Band 5 (1230-1250 nm)| Reflectance | 16-bit signed integer  | -28672 | -100 to 16000 | 0.0001 |
| surf_Refl_b06: 500m Surface Reflectance Band 6 (1628-1652 nm) | Reflectance | 16-bit signed integer  | -28672 | -100 to 16000 | 0.0001 |
| surf_Refl_b07: 500m Surface Reflectance Band 7 (2105-2155 nm) | Reflectance | 16-bit signed integer  | -28672 | -100 to 16000 | 0.0001 |

Using this table for the MOD09GA product, answer the following questions:
1. What is valid range of values for our data?
2. What the no data value?
3. What is the scale factor associated with our data?


### Identify MODIS Bands for NBR Calculations

This week in class, you will be calculating NBR using MODIS data. However, even though you can calculate the same vegetaion indices with many different remote sensing produts, remember that the bands for each remote sensing data  are different. 

Review the table above which displays the band ranges for the MODIS sensor. Recall that the NBR index will work with any multispectral sensor with a NIR band between 760 - 900 nm and a SWIR band between 2080 - 2350 nm.




{:.output}
    Downloading from https://ndownloader.figshare.com/files/10960109
    Extracted output to /root/earth-analytics/data/cold-springs-fire/.






{:.output}
{:.execute_result}



    ['data/cold-springs-fire/modis/reflectance/07_july_2016/crop/MOD09GA.A2016189.h09v05.006.2016191073856_sur_refl_b01_1.tif',
     'data/cold-springs-fire/modis/reflectance/07_july_2016/crop/MOD09GA.A2016189.h09v05.006.2016191073856_sur_refl_b02_1.tif',
     'data/cold-springs-fire/modis/reflectance/07_july_2016/crop/MOD09GA.A2016189.h09v05.006.2016191073856_sur_refl_b03_1.tif',
     'data/cold-springs-fire/modis/reflectance/07_july_2016/crop/MOD09GA.A2016189.h09v05.006.2016191073856_sur_refl_b04_1.tif',
     'data/cold-springs-fire/modis/reflectance/07_july_2016/crop/MOD09GA.A2016189.h09v05.006.2016191073856_sur_refl_b05_1.tif',
     'data/cold-springs-fire/modis/reflectance/07_july_2016/crop/MOD09GA.A2016189.h09v05.006.2016191073856_sur_refl_b06_1.tif',
     'data/cold-springs-fire/modis/reflectance/07_july_2016/crop/MOD09GA.A2016189.h09v05.006.2016191073856_sur_refl_b07_1.tif']












{:.output}
    -100 10039









{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}/images/courses/intermediate-earth-data-science-textbook/05-multi-spectral-remote-sensing-python/modis/2020-03-02-modis01-modis-data-in-python/2020-03-02-modis01-modis-data-in-python_15_0.png" alt = "Cropped images for surface reflectance from MODIS for all bands for pre-Cold Springs fire.">
<figcaption>Cropped images for surface reflectance from MODIS for all bands for pre-Cold Springs fire.</figcaption>

</figure>





{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}/images/courses/intermediate-earth-data-science-textbook/05-multi-spectral-remote-sensing-python/modis/2020-03-02-modis01-modis-data-in-python/2020-03-02-modis01-modis-data-in-python_16_0.png" alt = "Cropped surface reflectance from MODIS using the RGB bands for pre-Cold Springs fire.">
<figcaption>Cropped surface reflectance from MODIS using the RGB bands for pre-Cold Springs fire.</figcaption>

</figure>

















{:.output}
    0.24960000000000002 0.3013





