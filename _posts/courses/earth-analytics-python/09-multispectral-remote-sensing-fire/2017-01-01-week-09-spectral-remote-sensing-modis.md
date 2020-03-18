---
layout: single
category: courses
title: "Quantify the Impacts of a Fire Using MODIS and Landsat Remote Sensing Data in Python"
permalink: /courses/earth-analytics-python/multispectral-remote-sensing-modis/
modified: 2020-03-18
week-landing: 9
week: 9
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

Welcome to week {{ page.week }} of Earth Analytics! This week you will work with MODIS and 
Landsat data to calculate burn indices.  

{% include/data_subsets/course_earth_analytics/_data-cold-springs-fire.md %}

</div>


## Materials to Review For This Week’s Assignment

Please be sure to review:
1. <a href="{{ site.url }}/courses/use-data-open-source-python/multispectral-remote-sensing/vegetation-indices-in-python/" target="_blank">Chapter 11 on Calculating Normalized Burn Ratio (NBR) </a> in Section 5 of the Intermediate Earth Data Science Textbook.
2. <a href="{{ site.url }}/courses/use-data-open-source-python/hierarchical-data-formats-hdf/intro-to-hdf4/" target="_blank">Chapter 12 on Working with MODIS HDF4 Files in Python</a> in Section 6 of Intermediate Earth Data Science Textbook.
    * For more background on MODIS, you can review  <a href="{{ site.url }}/courses/earth-analytics-python/multispectral-remote-sensing-modis/modis-remote-sensing-data-in-python/" target="_blank">Chapter 10 on Intro to MODIS Data</a> in Section 5 of the Intermediate Earth Data Science Textbook.
3. <a href="{{ site.url }}/courses/use-data-open-source-python/data-stories/cold-springs-wildfire/" target="_blank">Data Story on Cold Springs Fire</a> in Section 7 of the Intermediate Earth Data Science Textbook.

### 1. Complete the Assignment Using the Template for this week. 

Note that this assignment is worth more points than a usual weekly assignment. 

<a href="https://github.com/earthlab-education/ea-python-2020-09-cold-springs-workflows-h4-template" target="_blank">Click here to view the the example GitHub Repo with the assignment template. </a>

### 2. Suggested Fire Readings

Please read the articles below to prepare for next week's class.

* <a href="http://www.denverpost.com/2016/07/13/cold-springs-fire-wednesday/" target="_blank">Denver Post article on the Cold Springs fire.</a>
* <a href="http://www.nature.com/nature/journal/v421/n6926/full/nature01437.html" target="_blank" data-proofer-ignore=''>Fire science for rainforests -  Cochrane 2003.</a>
* <a href="https://www.webpages.uidaho.edu/for570/Readings/2006_Lentile_et_al.pdf
" target="_blank">A review of ways to use remote sensing to assess fire and post-fire effects - Lentile et al 2006.</a>
* <a href="http://www.sciencedirect.com/science/article/pii/S0034425710001100" target="_blank"> Comparison of dNBR vs RdNBR accuracy / introduction to fire indices -  Soverel et al 2010.</a>
















## Homework Figure 1 - Grid of 3 Color InfraRed (CIR) Post-Fire Plots: NAIP, Landsat and MODIS


{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}/images/courses/earth-analytics-python/09-multispectral-remote-sensing-fire/2017-01-01-week-09-spectral-remote-sensing-modis/2017-01-01-week-09-spectral-remote-sensing-modis_18_0.png" alt = "CIR Composite images from NAIP, Landsat, and MODIS for the post-Cold Springs fire.">
<figcaption>CIR Composite images from NAIP, Landsat, and MODIS for the post-Cold Springs fire.</figcaption>

</figure>





## Homework Figure 2 - Difference NDVI (dNDVI) Using Landsat & MODIS


{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}/images/courses/earth-analytics-python/09-multispectral-remote-sensing-fire/2017-01-01-week-09-spectral-remote-sensing-modis/2017-01-01-week-09-spectral-remote-sensing-modis_21_0.png">

</figure>




## Homework Figure 3 - Difference NBR (dNBR) Using Landsat & MODIS




{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}/images/courses/earth-analytics-python/09-multispectral-remote-sensing-fire/2017-01-01-week-09-spectral-remote-sensing-modis/2017-01-01-week-09-spectral-remote-sensing-modis_25_0.png" alt = "NBR images calculated from Landsat for pre- and post-Cold Springs fire.">
<figcaption>NBR images calculated from Landsat for pre- and post-Cold Springs fire.</figcaption>

</figure>










{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}/images/courses/earth-analytics-python/09-multispectral-remote-sensing-fire/2017-01-01-week-09-spectral-remote-sensing-modis/2017-01-01-week-09-spectral-remote-sensing-modis_31_0.png" alt = "NBR images calculated from MODIS for pre- and post-Cold Springs fire.">
<figcaption>NBR images calculated from MODIS for pre- and post-Cold Springs fire.</figcaption>

</figure>








{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}/images/courses/earth-analytics-python/09-multispectral-remote-sensing-fire/2017-01-01-week-09-spectral-remote-sensing-modis/2017-01-01-week-09-spectral-remote-sensing-modis_35_0.png" alt = "Classified difference NBR (dNBR) images calculated from Landsat and MODIS for the Cold Springs fire.">
<figcaption>Classified difference NBR (dNBR) images calculated from Landsat and MODIS for the Cold Springs fire.</figcaption>

</figure>






# Landsat vs MODIS  Burned Area



{:.output}
    Burned Landsat class 4:
    Burned Landsat class 5:
    Burned MODIS class 4:
    Burned MODIS class 5:








