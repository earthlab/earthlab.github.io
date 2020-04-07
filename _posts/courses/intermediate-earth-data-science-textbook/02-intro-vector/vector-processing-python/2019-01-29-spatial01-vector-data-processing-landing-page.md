---
layout: single
title: "GIS in Python: Reproject Vector Data."
excerpt: "Often when spatial data do not line up properly on a plot, it is because they are in different 
coordinate reference systems (CRS). Learn how to reproject a vector dataset to a different CRS in Python using the to_crs() function from GeoPandas."
authors: ['Leah Wasser','Martha Morrissey','Chris Holdgraf']
dateCreated: 2018-02-05
modified: 2020-04-07
category: [courses]
class-lesson: ['vector-processing-python']
permalink: /courses/use-data-open-source-python/intro-vector-data-python/vector-data-processing/
nav-title: 'Processing Spatial Vector Data in Python'
module-title: 'Spatial Vector Data Processing in Python'
module-description: 'Common spatial vector data processing tasks include reprojecting data to a different coordinate reference system (CRS), clipping data to a specified boundary, and joining data based on spatial location and attributes. Learn how to process spatial vector data using open source Python.'
module-nav-title: 'Processing Spatial Vector Data in Python'
module-type: 'class'
course: 'intermediate-earth-data-science-textbook'
chapter: 3
week: 2
class-order: 2
estimated-time: "2-3 hours"
difficulty: "intermediate"
sidebar:
  nav:
author_profile: false
comments: true
order: 1
topics:
  spatial-data-and-gis: ['vector-data']
---

{% include toc title="In This Chapter" icon="file-text" %}

<div class='notice--success' markdown="1">

## <i class="fa fa-ship" aria-hidden="true"></i> Chapter Three - Spatial Vector Data Processing in Python 

In this chapter, you will learn how process vector data including how to reproject data to a different coordinate reference system (CRS), clip data to a specified boundary, and join data based on spatial location and attributes.


## <i class="fa fa-graduation-cap" aria-hidden="true"></i> Learning Objectives

After completing this chapter, you will be able to:

* Identify the CRS of a spatial dataset and reproject it to another CRS in **Python**.
* Clip a spatial vector point and line layer to the spatial extent of a polygon layer in **Python** using **geopandas**.
* Dissolve polygons based upon an attribute in **Python** using **geopandas**.
* Join spatial attributes from one shapefile to another in **Python** using **geopandas**.

## <i class="fa fa-check-square-o fa-2" aria-hidden="true"></i> What You Need

You will need a computer with internet access to complete this lesson and the
spatial-vector-lidar data subset created for the course.

{% include/data_subsets/course_earth_analytics/_data-spatial-lidar.md %}

</div>

