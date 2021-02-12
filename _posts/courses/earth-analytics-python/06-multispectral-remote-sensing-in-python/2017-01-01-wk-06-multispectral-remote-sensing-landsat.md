---
layout: single
category: courses
title: "Multispectral Imagery Python - NAIP, Landsat, Fire & Remote Sensing"
permalink: /courses/earth-analytics-python/multispectral-remote-sensing-in-python/
modified: 2021-02-12
week-landing: 6
week: 6
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

### The Homework Assignment for This Week Can Be Found on Github 


<a href="https://github.com/earthlab-education/ea-python-2020-06-multispectral-remote-sensing-template" target="_blank">Click here to view the GitHub Repo with the assignment template. </a>

Please be sure to read Chapters 7-9 and 11 of Section 5 of the Intermediate Earth Analytics Textbook on <a href="https://www.earthdatascience.org/courses/use-data-open-source-python/multispectral-remote-sensing/">Multispectral Remote Sensing Data in Python</a>. 

Please be sure to read about the <a href="https://www.earthdatascience.org/courses/use-data-open-source-python/data-stories/cold-springs-wildfire/">Cold Springs fire</a> in Chapter 22 of Section 7 of the Intermediate Earth Analytics Textbook. 


### 1a. Remote Sensing Readings

* <a href="https://landsat.gsfc.nasa.gov/landsat-data-continuity-mission/" target="_blank">NASA Overview of Landsat 8</a>
* <a href="https://www.e-education.psu.edu/natureofgeoinfo/c8_p12.html" target="_blank">Penn State e-Education post on multi-spectral data. Note they discuss AVHRR at the top which you won't use in this lesson but be sure to read about Landsat.</a>












{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}/images/courses/earth-analytics-python/06-multispectral-remote-sensing-in-python/2017-01-01-wk-06-multispectral-remote-sensing-landsat/2017-01-01-wk-06-multispectral-remote-sensing-landsat_8_0.png" alt = "Homework plots 1 & 2 RGB and CIR images using NAIP data from 2017.">
<figcaption>Homework plots 1 & 2 RGB and CIR images using NAIP data from 2017.</figcaption>

</figure>








The intermediate NDVI plots below are not required for your homework. They are here so you can compare intermediate outputs if you want to! You will need to create these datasets to process the final NDVI difference plot that is a homework item!


{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}/images/courses/earth-analytics-python/06-multispectral-remote-sensing-in-python/2017-01-01-wk-06-multispectral-remote-sensing-landsat/2017-01-01-wk-06-multispectral-remote-sensing-landsat_13_0.png" alt = "COMPARISON plots - intermediate NDVI NAIP outputs. These plots are just here if you want to compare your intermediate outputs with the instructors.">
<figcaption>COMPARISON plots - intermediate NDVI NAIP outputs. These plots are just here if you want to compare your intermediate outputs with the instructors.</figcaption>

</figure>





{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}/images/courses/earth-analytics-python/06-multispectral-remote-sensing-in-python/2017-01-01-wk-06-multispectral-remote-sensing-landsat/2017-01-01-wk-06-multispectral-remote-sensing-landsat_14_0.png" alt = "Homework plot 3 NDVI difference using NAIP 2017 - NAIP 2015.">
<figcaption>Homework plot 3 NDVI difference using NAIP 2017 - NAIP 2015.</figcaption>

</figure>








{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}/images/courses/earth-analytics-python/06-multispectral-remote-sensing-in-python/2017-01-01-wk-06-multispectral-remote-sensing-landsat/2017-01-01-wk-06-multispectral-remote-sensing-landsat_17_0.png" alt = "Homework plots 4 & 5 RGB and CIR images using Landsat 8 pre-fire.">
<figcaption>Homework plots 4 & 5 RGB and CIR images using Landsat 8 pre-fire.</figcaption>

</figure>








{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}/images/courses/earth-analytics-python/06-multispectral-remote-sensing-in-python/2017-01-01-wk-06-multispectral-remote-sensing-landsat/2017-01-01-wk-06-multispectral-remote-sensing-landsat_20_0.png" alt = "Homework plot  6 NDVI calculated from Landsat 8 pre-fire data.">
<figcaption>Homework plot  6 NDVI calculated from Landsat 8 pre-fire data.</figcaption>

</figure>



