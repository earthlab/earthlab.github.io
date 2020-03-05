---
layout: single
title: "Introduction to Raster Data Processing in Open Source Python"
excerpt: "You can perform the same raster processing steps in Python that you would in a tool like ArcGIS. Learn how to process spatial raster data using Open Source Python."
authors: ['Leah Wasser', 'Chris Holdgraf', 'Martha Morrissey']
dateCreated: 2018-02-05
modified: 2020-02-14
category: [courses]
class-lesson: ['raster-processing-python']
permalink: /courses/use-data-open-source-python/intro-raster-data-python/raster-data-processing/
nav-title: 'Process Raster Data'
module-title: 'Raster Data Processing in Python'
module-description: 'Common raster data processing tasks include cropping and reprojecting raster data, using raster math to derive new rasters, and reclassifying rasters using a set of values. Learn how to process raster data using open source Python.'
module-nav-title: 'Processing Raster Data in Python'
module-type: 'class'
week: 3
class-order: 2
course: 'intermediate-earth-data-science-textbook'
chapter: 5
sidebar:
  nav:
author_profile: false
comments: true
order: 1
topics:
  reproducible-science-and-programming: ['python']
  remote-sensing: ['lidar']
  earth-science: ['vegetation']
  spatial-data-and-gis: ['raster-data']
redirect_from:
  - "/courses/earth-analytics-python/lidar-raster-data/subtract-rasters-in-python/"
---
{% include toc title="On This Page" icon="file-text" %}

<div class='notice--success' markdown="1">

## <i class="fa fa-ship" aria-hidden="true"></i> Chapter Five - Raster Data Processing in Python 

In this chapter, you will learn how to process raster data. You will learn how to 
crop, reproject and reclassify raster data.

## <i class="fa fa-graduation-cap" aria-hidden="true"></i> Learning Objectives

After completing this chapter, you will be able to:

* Use raster math in **Python** to derive new rasters, such as a Canopy Height Model (CHM).
* Reclassify a raster dataset in **Python** using a set of defined values. 
* Crop a raster dataset in **Python** using a vector extent object derived from a shapefile.
* Reproject a raster using **rasterio**.

## <i class="fa fa-check-square-o fa-2" aria-hidden="true"></i> What You Need

You will need a computer with internet access to complete this lesson.

{% include/data_subsets/course_earth_analytics/_data-colorado-flood.md %}

</div>
