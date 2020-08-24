---
layout: single
title: "Customize your Maps in Python using Matplotlib: GIS in Python"
excerpt: "When making maps, you often want to create legends, customize colors, adjust zoom levels, or even make interactive maps. Learn how to customize maps created using vector data in Python with matplotlib, geopandas, and folium."
authors: ['Chris Holdgraf', 'Leah Wasser']
dateCreated: 2019-01-29
modified: 2020-07-21
category: [courses]
class-lesson: ['hw-custom-maps-python-tb']
module-title: 'Customize Plots of Spatial Vector Data in Python'
module-description: 'When making maps, you often want to create legends, customize colors, adjust zoom levels, or even make interactive maps. Learn how to customize maps created using vector data in Python with matplotlib, geopandas, and folium.'
module-nav-title: 'Custom Vector Plots in Python'
module-type: 'class'
permalink: /courses/scientists-guide-to-plotting-data-in-python/plot-spatial-data/customize-vector-plots/
nav-title: 'Customize Python Maps'
course: 'scientists-guide-to-plotting-data-in-python-textbook'
chapter: 3
class-order: 1
week: 2
sidebar:
  nav:
author_profile: false
comments: true
order: 1
topics:
  reproducible-science-and-programming:
  data-exploration-and-analysis: ['data-visualization']
  spatial-data-and-gis: ['vector-data']
---

{% include toc title="In This Chapter" icon="file-text" %}

<div class='notice--success' markdown="1">

## <i class="fa fa-ship" aria-hidden="true"></i> Chapter Three - Customize Vector Plots

In this chapter, you will learn how to create and customize vector plots in **Python** using **geopandas**, **matplotlib**, and **folium**. 

## <i class="fa fa-graduation-cap" aria-hidden="true"></i> Learning Objectives

After completing this chapter, you will be able to:

* Create a map containing multiple vector datasets, colored by unique attributes in **Python**.
* Add a custom legend to a map in **Python** with unique colors.
* Visually "clip" or zoom in to a particular spatial extent in a plot.
* Create interactive plots of vector data using **folium** in **Python** and **Jupyter Notebook**.


## <i class="fa fa-check-square-o fa-2" aria-hidden="true"></i> What You Need

You need **Python** and **Jupyer Notebook** to complete this chapter. You should also have an `earth-analytics` directory setup on your computer with a `data` subdirectory within it. You should have completed the lesson on <a href="{{ site.url }}/workshops/setup-earth-analytics-python/">Setting Up the Earth Analytics Python Conda Environment.</a>.

You will need a computer with internet access to complete this lesson and the spatial-vector-lidar dataset.

{% include/data_subsets/course_earth_analytics/_data-spatial-lidar.md %}

</div>

