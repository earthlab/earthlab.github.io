---
layout: single
category: courses
title: "Multispectral Imagery Python - NAIP, Landsat, Fire & Remote Sensing"
permalink: /courses/earth-analytics-python/multispectral-remote-sensing-in-python/
modified: 2018-10-08
week-landing: 7
week: 7
sidebar:
  nav:
comments: false
author_profile: false
course: "earth-analytics-python"
module-type: 'session'
---
{% include toc title="This Week" icon="file-text" %}

<div class="notice--info" markdown="1">

## <i class="fa fa-ship" aria-hidden="true"></i> Welcome to Week {{ page.week }}!

Welcome to week {{ page.week }} of Earth Analytics!

At the end of this week you will be able to:

* Describe what a spectral band is in remote sensing data.
* Create maps of spectral remote sensing data using different band combinations including CIR and RGB.
* Calculate NDVI in `Python` using.
* Get NAIP remote sensing data from Earth Explorer.
* Use the Landsat file naming convention to determine correct band combinations for plotting and calculating NDVI.
* Define additive color model.

{% include /data_subsets/course_earth_analytics/_data-cold-springs-fire.md %}


</div>


|  Time | Topic   | Speaker   |
|---|---|---|---|---|
| 9:30 - 9:45  | Review last week's assignment / questions |   |
| 9:45 - 10:00  | Introduction to multispectral remote sensing  |  |
| 10:00 - 11:00  | Coding Session: Multispectral data in Python using Rasterio |  Leah  |
|===
| 11:10 - 12:20  | Vegetation indices and NDVI in Python |  Leah  |

### 1a. Remote Sensing Readings

* <a href="https://landsat.gsfc.nasa.gov/landsat-data-continuity-mission/" target="_blank">NASA Overview of Landsat 8</a>
* <a href="https://www.e-education.psu.edu/natureofgeoinfo/c8_p12.html" target="_blank">Penn State e-Education post on multi-spectral data. Note they discuss AVHRR at the top which you won't use in this lesson but be sure to read about Landsat.</a>



## Plots 1 & 2: RGB & CIR Images Using NAIP Data
Using Earth Explorer, download NAIP data from 2017 (post fire).
Clip the data to the spatial extent of the 2015 NAIP data. The code below will help you do this. 
In the example below `naip_2015_bds` is the `.bounds` attribute of the NAIP 2015 rasterio reader object. 

`naip_clip_extent = mapping(box(*naip_2015_bds))`

Create a 1) RGB and 2) Color Infrared (CIR) image of the study site using the post fire NAIP data.

Add the Cold Springs fire boundary to each map. 

HINT: In a CIR image the:

* Infrared band will appear red.
* Red band will appear green.
* Green band will appear blue.

IMPORTANT: Make sure that you use the correct bands to create both images.

### Data Sources

Use the following data sources for these plots: 
* NAIP 2015: `cold-springs-fire/naip/m_3910505_nw_13_1_20150919/crop/m_3910505_nw_13_1_20150919_crop.tif`
* NAIP 2017: Use the data you download from EarthExplorer
* Fire Boundary: `data/cold-springs-fire/vector_layers/fire-boundary-geomac/co_cold_springs_20160711_2200_dd83.shp`


{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}//images/courses/earth-analytics-python/07-multispectral-remote-sensing-in-python/2017-01-01-wk-07-multispectral-remote-sensing-landsat_3_0.png" alt = "Homework plots 1 & 2 RGB and CIR images using NAIP data from 2017.">
<figcaption>Homework plots 1 & 2 RGB and CIR images using NAIP data from 2017.</figcaption>

</figure>




## Plot 3: Create a Plot of the Difference NDVI Using NAIP Data from 2017 & 2015

Calculate and plot the DIFFERENCE between NDVI in 2017 and 2015. To calculate difference **subtract the pre-fire data from the post fire data (post - pre)** to ensure that negative values represent a decrease in NDVI between the two years. 

For this to work properly you will need to ensure that the 2017 data are CLIPPED to the 2015 data boundary as described for plots 1&2. 

Add the Cold Springs fire boundary to your plot. 

### Data 
Use the following data to complete this plot.

* NAIP Pre-fire:  `cold-springs-fire/naip/m_3910505_nw_13_1_20150919/crop/m_3910505_nw_13_1_20150919_crop.tif`
* NAIP Post Fire: Use the data that you got from Earth Explorer
* Fire Boundary: `data/cold-springs-fire/vector_layers/fire-boundary-geomac/co_cold_springs_20160711_2200_dd83.shp`

The intermediate NDVI plots below are not required for your homework. They are here so you can compare intermediate outputs if you want to! You will need to create these datasets to process the final NDVI difference plot that is a homework item!


{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}//images/courses/earth-analytics-python/07-multispectral-remote-sensing-in-python/2017-01-01-wk-07-multispectral-remote-sensing-landsat_6_0.png" alt = "COMPARISON plots - intermediate NDVI NAIP outputs. These plots are just here if you want to compare your intermediate outputs with the instructors.">
<figcaption>COMPARISON plots - intermediate NDVI NAIP outputs. These plots are just here if you want to compare your intermediate outputs with the instructors.</figcaption>

</figure>





{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}//images/courses/earth-analytics-python/07-multispectral-remote-sensing-in-python/2017-01-01-wk-07-multispectral-remote-sensing-landsat_7_0.png" alt = "Homework plot 3 NDVI difference using NAIP 2017 - NAIP 2015.">
<figcaption>Homework plot 3 NDVI difference using NAIP 2017 - NAIP 2015.</figcaption>

</figure>




## Plot 4 & 5: RGB & CIR Images Using Pre-Fire Landsat Data

Plot a RGB and CIR image using Landsat data collected pre-fire.

Add the Cold Springs fire boundary to each map. 
    
### Data

Landsate Prefire Data: `cold-springs-fire/landsat_collect/LC080340322016070701T1-SC20180214145604/crop/`


{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}//images/courses/earth-analytics-python/07-multispectral-remote-sensing-in-python/2017-01-01-wk-07-multispectral-remote-sensing-landsat_9_0.png" alt = "Homework plots 4 & 5 RGB and CIR images using Landsat 8 pre-fire.">
<figcaption>Homework plots 4 & 5 RGB and CIR images using Landsat 8 pre-fire.</figcaption>

</figure>




## Plots 6: Calculate NDVI Using Pre-Fire Landsat Data

Create map of NDVI pre and post Cold Springs fire using the Landsat pre-fire data.

Add the Cold Springs fire boundary to your plot. 

IMPORTANT: don't forget to label each map appropriately with the date that the
data were collected and pre or post fire!


{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}//images/courses/earth-analytics-python/07-multispectral-remote-sensing-in-python/2017-01-01-wk-07-multispectral-remote-sensing-landsat_11_0.png" alt = "Homework plot  6 NDVI calculated from Landsat 8 pre-fire data.">
<figcaption>Homework plot  6 NDVI calculated from Landsat 8 pre-fire data.</figcaption>

</figure>



