---
layout: single
category: courses
title: "Introduction to Spatial Vector Data in Open Source Python"
permalink: /courses/earth-analytics-bootcamp/spatial-vector-data-python/
week-landing: 1
week: 13
sidebar:
  nav:
comments: false
author_profile: false
course: "earth-analytics-bootcamp"
module-type: 'session'
redirect_from:
  - "/courses/earth-analytics-bootcamp/loops/"
---


{% include toc title="This Week" icon="file-text" %}

<div class="notice--info" markdown="1">

## <i class="fa fa-ship" aria-hidden="true"></i> Welcome to Week {{ page.week }}!

Welcome to Week {{ page.week }} of the Earth Analytics Bootcamp course! This week, you will write `Python` code in `Jupyter Notebook` to work with vector data in using open source **Python** software. 

## <i class="fa fa-graduation-cap" aria-hidden="true"></i> Learning Objectives

After completing the lessons for Week {{ page.week }}, you will be able to:

* Open and plot vector data using geopandas in Python 
* Crop and manipulate vector data using geopandas

## <i class="fa fa-pencil-square-o" aria-hidden="true"></i> Homework & Readings

<a href="https://github.com/earthlab-education/bootcamp-2020-12-vector-template" target="_blank"> <i class="fa fa-link" aria-hidden="true"></i> Click here to view the GitHub Repo with the assignment template.</i> {: .btn .btn--info .btn--x-large}


## <i class="fa fa-book"></i> Earth Data Science Textbook Readings

Please read the following chapters of the <a href="https://www.earthdatascience.org/courses/use-data-open-source-python"> Intermediate to Earth Data Science online textbook</a> to support completing this week's assignment:


* <a href="https://www.earthdatascience.org/courses/use-data-open-source-python/intro-vector-data-python/">Chapters 2 and 3 on using vector data in open source python</a>.

</div>

## Example Homework Plots

Below are example versions of the plots you will create for your homework.


{:.output}
    Downloading from https://ndownloader.figshare.com/files/12459464
    Extracted output to /root/earth-analytics/data/spatial-vector-lidar/.




## Challenge 1a: Open And Clip Your Vector Data



{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}/images/courses/ea-bootcamp/13-vector-data/2019-08-11-vector-data-landing-page/2019-08-11-vector-data-landing-page_6_0.png">

</figure>




## Challenge 2: Figure 2 - Roads in Del Norte, Modoc & Siskiyou Counties




{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}/images/courses/ea-bootcamp/13-vector-data/2019-08-11-vector-data-landing-page/2019-08-11-vector-data-landing-page_9_0.png" alt = "Plots of lidar min and max vs insitu min and max with a 1:1 line a regression fit for the NEON SJER field site.">
<figcaption>Plots of lidar min and max vs insitu min and max with a 1:1 line a regression fit for the NEON SJER field site.</figcaption>

</figure>





{:.output}
    Downloading from https://ndownloader.figshare.com/files/25515986
    Extracted output to /root/earth-analytics/data/earthpy-downloads/ne_10m_admin_0_countries



{:.output}
    /opt/conda/envs/EDS/lib/python3.8/site-packages/pandas/core/reshape/merge.py:643: UserWarning: merging between different levels can give an unintended result (1 levels on the left,2 on the right)
      warnings.warn(msg, UserWarning)




{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}/images/courses/ea-bootcamp/13-vector-data/2019-08-11-vector-data-landing-page/2019-08-11-vector-data-landing-page_11_0.png">

</figure>




