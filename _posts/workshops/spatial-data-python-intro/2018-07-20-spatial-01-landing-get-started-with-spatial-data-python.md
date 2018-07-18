---
layout: single
category: courses
title: "Get Started With GIS in Open Source Python - Geopandas, Rasterio & Matplotlib"
excerpt: 'There are a suite of powerful open source python libraries that can be used to work with spatial data. Learn how to use geopandas, rasterio and matplotlib to plot and manipulate spatial data in Python.'
modified: 2018-07-18
nav-title: "Spatial Data Workshop Overview"
permalink: /workshops/gis-open-source-python/
module: "spatial-data-open-source-python"
module-type: 'workshop'
module-title: "Get Started With GIS in Open Source Python Tools"
module-description: 'There are a suite of powerful open source python libraries that can be used to work with spatial data. Learn how to use geopandas, rasterio and matplotlib to plot and manipulate spatial data in Python.'
sidebar:
  nav:
comments: false
author_profile: false
order: 1
---
{% include toc title="This Week" icon="file-text" %}


{% assign course_posts = site.posts | course: page.course %}
{% assign sorted_posts = course_posts | sort:'overview-order' %}

{% assign modules = sorted_posts | where:"module-type", 'overview' %}
{% assign modules_course = modules | where:"module", page.module %}

<div class="notice--info" markdown="1">

## <i class="fa fa-ship" aria-hidden="true"></i> Introduction to Git / Github workshop

## What You Need

To participate in this workshop, you need a laptop with internet access. You will be 
working with Python Jupyter Notebook in a cloud environment.

## Pre-requisites

This workshop is geared towards participants with background who has some experience using `Python` 
and also some experience working with spatial data or using GIS.  

### Workshop Data

All of the data required to complete this workshop will be available to you through
the cloud Jupyter environment. However you can also download the data here:

[<i class="fa fa-download" aria-hidden="true"></i> Download spatial-vector-lidar data subset (~172 MB)](https://ndownloader.figshare.com/files/12447845){:data-proofer-ignore='' .btn }

You will need a computer with internet access to complete this lesson. If you are following along online and not using our cloud environment:

[<i class="fa fa-download" aria-hidden="true"></i> Get data and software setup instructionshere]({{site.url}}/workshops/gis-open-source-python/){:data-proofer-ignore='' .btn }

You will need Anaconda Python 3.x Distribution, git and bash to work through all of the lessons.

</div>

This workshop will be taught by Earth Lab Staff:

* Joe McGlinchy - Remote Sensing Specialist, Earth Lab
* Leah Wasser - Director of Education, Earth Lab
* Jenny Palomino - Earth Analytics Course Developer / Instructor, Earth Lab


## <i class="fa fa-calendar-check-o" aria-hidden="true"></i> Workshop schedule

| time        | topic                                               | instructor |
|:------------|:----------------------------------------------------|:-----------|
| 9:00 - 9:05 |   Welcome | Leah     | 
| 9:00 - 9:25 |   Introduction to Rasterio - Raster data in Python |   Leah   | 
| 9:25 - 9:50 | Subtract Raster Data in Python         |  Joe  | 
| 10:00 - 10:30 |  Introduction to Vector Data & Plotting with Geopandas   |     Leah       |
| 10:30 - 10:40 | Break            |   Leah      |
| 3:20 - 4:00 | Vector Data Processing            |  Jenny   |

