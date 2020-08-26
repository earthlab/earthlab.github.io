---
layout: single
category: courses
title: "Learn to Create Efficient Data Workflows in Python"
permalink: /courses/earth-analytics-python/create-efficient-data-workflows/
modified: 2020-07-09
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

Welcome to week {{ page.week }} of Earth Analytics! This week you will learn how to automate a workflow using `Python`. You will design and implement your own workflow in `Python` that builds on the skills that you have learned in this course, such as functions and loops. You will also learn how to programmatically build paths to directories and files as well as parse strings to extract information from file and directory names.  

{% include/data_subsets/course_earth_analytics/_data-landsat-automation.md %}


</div>


## Materials to Review For This Week's Assignment

Please be sure to review Chapter of Section 6 of the Intermediate Earth Analytics Textbook on <a href="{{ site.url }}/courses/use-data-open-source-python/earth-data-science-workflows/design-efficient-automated-data-workflows/">Designing and Automating Data Workflows in Python</a>. 



### Automate a Workflow in Python

For this week’s assignment, you will generate a plot of the normalized difference vegetation index (NDVI) for two different locations in the United States to begin to understand how the growing seasons vary in each site:

1. <a href="https://www.neonscience.org/field-sites/field-sites-map/SJER" target="_blank">San Joaquin Experimental Range (SJER) in Southern California, United States</a>
2. <a href="https://www.neonscience.org/field-sites/field-sites-map/HARV" target="_blank">Harvard Forest (HARV) in the Eastern United States</a> 

From this plot, you will be able to compare the seasonal vegetation patterns of the two locations. This comparison would be useful if you were planning NEON’s upcoming flight season in both locations and wanted to ensure that you flew the area when the vegetation was the most green! If could also be useful if you wanted to track green-up as it happened over time in both sites to see if there were changes happening. 

As a bonus, you will also create a stacked NDVI output data product to share with your colleagues. You are doing all of the work to clean and process the data. It would be nice if you could share a data product output to save others the hassle. 


### Design A Workflow 

Your goal this week is to calculate the mean NDVI value for each Landsat 8 scene captured for a NEON site over a year. You have the following data to do accomplish this goal:

1. One year worth of Landsat 8 data for each site: Remember that for each landsat scene, you have a series of geotiff files representing bands and qa (quality assurance) layers in your data.
2. A site boundary “clip file” for each site: This is a shapefile representing the boundary of each NEON site. You will want to clip your landsat data to this boundary.

Before writing `Python` code, write pseudocode for your implementation. Pseudo-coding means that you will write out all of the steps that you need to perform. Then, you will identify areas where tasks are repeated that could benefit from a function, areas where loops might be appropriate, etc.  


## Homework Plots

The plots below are examples of what your output plots will look like with and without cleaning the data to deal with cloud cover.





{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}/images/courses/earth-analytics-python/07-data-workflows/2018-10-22-week-07-automate-workflows-landing/2018-10-22-week-07-automate-workflows-landing_4_0.png" alt = "While there can exist month-to-month variability in NDVI values due to natural vegetation changes, the NDVI values for some months in this plot are the result of heavy cloud cover over the site.">
<figcaption>While there can exist month-to-month variability in NDVI values due to natural vegetation changes, the NDVI values for some months in this plot are the result of heavy cloud cover over the site.</figcaption>

</figure>







{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}/images/courses/earth-analytics-python/07-data-workflows/2018-10-22-week-07-automate-workflows-landing/2018-10-22-week-07-automate-workflows-landing_7_0.png" alt = "Plot showing NDVI for each time period at both NEON Sites. In this example the cloudy pixels were removed using the pixel_qa cloud mask. Notice that this makes a significant different in the output values. Why do you think this difference is so significant?">
<figcaption>Plot showing NDVI for each time period at both NEON Sites. In this example the cloudy pixels were removed using the pixel_qa cloud mask. Notice that this makes a significant different in the output values. Why do you think this difference is so significant?</figcaption>

</figure>



