---
layout: single
category: courses
title: "Multispectral Imagery Python - NAIP, Landsat, Fire & Remote Sensing"
permalink: /courses/earth-analytics-python/multispectral-remote-sensing-in-python/
modified: 2018-10-23
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
| 20 minutes | Review / questions |   |
| 20-30 minutes  | Introduction to multispectral remote sensing  |  |
| Coding part I  | Coding Session: Multispectral data in Python using Rasterio |    |
|===
| Coding part II   | Vegetation indices and NDVI in Python |    |

### 1a. Remote Sensing Readings

* <a href="https://landsat.gsfc.nasa.gov/landsat-data-continuity-mission/" target="_blank">NASA Overview of Landsat 8</a>
* <a href="https://www.e-education.psu.edu/natureofgeoinfo/c8_p12.html" target="_blank">Penn State e-Education post on multi-spectral data. Note they discuss AVHRR at the top which you won't use in this lesson but be sure to read about Landsat.</a>




{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}//images/courses/earth-analytics-python/07-multispectral-remote-sensing-in-python/2017-01-01-wk-07-multispectral-remote-sensing-landsat_2_0.png" alt = "Homework plots 1 & 2 RGB and CIR images using NAIP data from 2017.">
<figcaption>Homework plots 1 & 2 RGB and CIR images using NAIP data from 2017.</figcaption>

</figure>




The intermediate NDVI plots below are not required for your homework. They are here so you can compare intermediate outputs if you want to! You will need to create these datasets to process the final NDVI difference plot that is a homework item!


{:.output}
    /Users/leah-su/anaconda3/envs/earth-analytics-python/lib/python3.6/site-packages/matplotlib/tight_layout.py:177: UserWarning: The left and right margins cannot be made large enough to accommodate all axes decorations. 
      warnings.warn('The left and right margins cannot be made large '
    /Users/leah-su/anaconda3/envs/earth-analytics-python/lib/python3.6/site-packages/matplotlib/tight_layout.py:182: UserWarning: The bottom and top margins cannot be made large enough to accommodate all axes decorations. 
      warnings.warn('The bottom and top margins cannot be made large '
    /Users/leah-su/anaconda3/envs/earth-analytics-python/lib/python3.6/site-packages/matplotlib/tight_layout.py:209: UserWarning: tight_layout cannot make axes height small enough to accommodate all axes decorations
      warnings.warn('tight_layout cannot make axes height small enough '



{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}//images/courses/earth-analytics-python/07-multispectral-remote-sensing-in-python/2017-01-01-wk-07-multispectral-remote-sensing-landsat_4_1.png" alt = "COMPARISON plots - intermediate NDVI NAIP outputs. These plots are just here if you want to compare your intermediate outputs with the instructors.">
<figcaption>COMPARISON plots - intermediate NDVI NAIP outputs. These plots are just here if you want to compare your intermediate outputs with the instructors.</figcaption>

</figure>





{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}//images/courses/earth-analytics-python/07-multispectral-remote-sensing-in-python/2017-01-01-wk-07-multispectral-remote-sensing-landsat_5_0.png" alt = "Homework plot 3 NDVI difference using NAIP 2017 - NAIP 2015.">
<figcaption>Homework plot 3 NDVI difference using NAIP 2017 - NAIP 2015.</figcaption>

</figure>





{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}//images/courses/earth-analytics-python/07-multispectral-remote-sensing-in-python/2017-01-01-wk-07-multispectral-remote-sensing-landsat_6_0.png" alt = "Homework plots 4 & 5 RGB and CIR images using Landsat 8 pre-fire.">
<figcaption>Homework plots 4 & 5 RGB and CIR images using Landsat 8 pre-fire.</figcaption>

</figure>





{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}//images/courses/earth-analytics-python/07-multispectral-remote-sensing-in-python/2017-01-01-wk-07-multispectral-remote-sensing-landsat_7_0.png" alt = "Homework plot  6 NDVI calculated from Landsat 8 pre-fire data.">
<figcaption>Homework plot  6 NDVI calculated from Landsat 8 pre-fire data.</figcaption>

</figure>



