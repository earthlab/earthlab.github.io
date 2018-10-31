---
layout: single
category: courses
title: "Learn to Create Efficient Data Workflows in Python"
permalink: /courses/earth-analytics-python/create-efficient-data-workflows/
modified: 2018-10-31
week-landing: 10
week: 10
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

Welcome to week {{ page.week }} of Earth Analytics! This week you will learn how to automate a workflow using `Python`. You will design and implement your own workflow in `Python` that builds on the skills that you have learned in this course, such as functions and loops. You will also learn how to programmatically build paths to directories and files as well as parse strings to extract information from file and directory names.  

{% include/data_subsets/course_earth_analytics/_data-landsat-automation.md %}


</div>


## Automate a Workflow in Python

For this week’s assignment, you will generate a plot of the normalized difference vegetation index (NDVI) for two different locations in the United States to begin to understand how the growing seasons vary in each site:

1. <a href="https://www.neonscience.org/field-sites/field-sites-map/SJER" target="_blank">San Joaquin Experimental Range (SJER) in Southern California, United States</a>
2. <a href="https://www.neonscience.org/field-sites/field-sites-map/HARV" target="_blank">Harvard Forest (HARV) in the Eastern United States</a> 

From this plot, you will be able to compare the seasonal vegetation patterns of the two locations. This comparison would be useful if you were planning NEON’s upcoming flight season in both locations and wanted to ensure that you flew the area when the vegetation was the most green! If could also be useful if you wanted to track green-up as it happened over time in both sites to see if there were changes happening. 

As a bonus, you will also create a stacked NDVI output data product to share with your colleagues. You are doing all of the work to clean and process the data. It would be nice if you could share a data product output to save others the hassle. 

## Design A Workflow 

Your goal this week is to calculate the mean NDVI value for each Landsat 8 scene captured for a NEON site over a year. You have the following data to do accomplish this goal:

1. One year worth of Landsat 8 data for each site: Remember that for each landsat scene, you have a series of geotiff files representing bands and qa (quality assurance) layers in your data.
2. A site boundary “clip file” for each site: This is a shapefile representing the boundary of each NEON site. You will want to clip your landsat data to this boundary.

Before writing `Python` code, write pseudocode for your implementation. Pseudo-coding means that you will write out all of the steps that you need to perform. Then, you will identify areas where tasks are repeated that could benefit from a function, areas where loops might be appropriate, etc.  


## Homework for this Week

Your homework for this week is on outlined Canvas.


## Homework Plots

The plots below are provided to guide your thinking about the workflow. 

### Plot of All NDVI Values


{:.output}
{:.execute_result}



    <bound method EarthlabData.get_data of Available Datasets: ['co-flood-extras', 'colorado-flood', 'spatial-vector-lidar', 'cold-springs-modis-h5', 'cold-springs-fire', 'cs-test-naip', 'cs-test-landsat', 'ndvi-automation']>






{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}//images/courses/earth-analytics-python/10-data-workflows/2018-10-22-week-10-automate-workflows-landing_3_0.png" alt = "While there can exist month-to-month variability in NDVI values due to natural vegetation changes, the NDVI values for some months in this plot are the result of heavy cloud cover over the site.">
<figcaption>While there can exist month-to-month variability in NDVI values due to natural vegetation changes, the NDVI values for some months in this plot are the result of heavy cloud cover over the site.</figcaption>

</figure>




### Plot of NDVI Values Above 0.1


{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}//images/courses/earth-analytics-python/10-data-workflows/2018-10-22-week-10-automate-workflows-landing_5_0.png" alt = "Limiting the plot to NDVI values over a certain threshold, such as 0.1, can help to highlight the patterns of NDVI at each site.">
<figcaption>Limiting the plot to NDVI values over a certain threshold, such as 0.1, can help to highlight the patterns of NDVI at each site.</figcaption>

</figure>



