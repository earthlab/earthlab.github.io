---
layout: single
title: "How Do You Create a Data Workflow - Design and Develop a Workflow For NDVI Over Time"
excerpt: "Designing and developing data workflows can complete your work more efficiently by allowing you to repeat and automate data tasks. Learn how to design and develop efficient workflows to automate data analyses in Python."
authors: ['Leah Wasser', 'Max Joseph', 'Lauren Herwehe', 'Jenny Palomino', 'Joe McGlinchy']
modified: 2018-10-31
category: [courses]
class-lesson: ['create-data-workflows']
module-title: 'How To Design and Develop a Workflow For NDVI Over Time'
module-description: 'Learn how to design and develop automated workflows to calculate NDVI time series in Python.'
module-nav-title: 'Design and Develop Workflows'
module-type: 'class'
class-order: 1
permalink: /courses/earth-analytics-python/create-efficient-data-workflows/intro-to-ndvi-data-workflow/
nav-title: 'Intro to NDVI Data Workflow'
week: 10
course: "earth-analytics-python"
sidebar:
  nav:
author_profile: false
comments: true
order: 1
topics:
  reproducible-science-and-programming: ['python']
---
{% include toc title="In This Lesson" icon="file-text" %}

<div class='notice--success' markdown="1">

## <i class="fa fa-graduation-cap" aria-hidden="true"></i> Learning Objectives

After completing this tutorial, you will be able to:

* Explain how you can use a time series of normalized difference vegetation index (ndvi) to investigate ecological processes and changes.
* List the key steps in designing data workflows. 

## <i class="fa fa-check-square-o fa-2" aria-hidden="true"></i> What You Need

You will need a computer with internet access to complete this lesson and the data for week 10 of the course.

{% include/data_subsets/course_earth_analytics/_data-landsat-automation.md %}

</div>


## Normalized Difference Vegetation Index (NDVI) Over Time 

This semester you have have used vegetation indices to study changes due to a disturbance such as a flood or a fire. You used NDVI to identify where vegetation increased or decreased after the disturbance event. 

NDVI can also be used to understand seasonality - when an area begins to “green-up” or grow after the winter cold period and “brown down” when vegetation in an area begins to die back or senesce in an area (usually in the fall and winter). 

Different areas in different parts of the world have different seasonal patterns. For example, the NEON SJER (San Joaquin Experimental Range) in California has an early green-up date on average, a short growing season due to hot temperatures and lack of precipitation and an early brown down. Whereas Harvard Forest in Massachusetts has a longer growing season and a later green-up period.   

## Changes in Seasonality And Changes in Climate 

Changes in seasonality can be important indicators of ecological change. For example, if green-up begins earlier, such that fruit or seed resources become available sooner than average, animals that forage on the fruits in the spring must either migrate earlier to use these resources, or miss out on them if they do not adjust migration behavior. This phenomenon is referred to as a phenological mismatch.

<figure>
  <a href="{{ site.url }}/images/courses/earth-analytics/science/phenology/lilac-greenup-map-automation-landsat-ndvi.jpg">
    <img src="{{ site.url }}/images/courses/earth-analytics/science/phenology/lilac-greenup-map-automation-landsat-ndvi.jpg" alt="Changes in the date of first bloom across the U.S. for lilacs.">
  </a>
  <figcaption>This image shows the changes in the date of first bloom for the common lilac (syringa vulgaris) across the U.S. The data was collected by Project Budburst, a citizen science initiative that tracks plant species responses to climate change. Source: <a href="https://www.americanscientist.org/article/citizen-science-takes-root" target="_blank">American Scientist.</a>
  </figcaption>
</figure>

<figure>
  <a href="{{ site.url }}/images/courses/earth-analytics/science/phenology/bird-migration-map-automation-landsat-ndvi.jpg">
    <img src="{{ site.url }}/images/courses/earth-analytics/science/phenology/bird-migration-map-automation-landsat-ndvi.jpg" alt=" Map of migration changes for bird species due to shifting green-up dates.">
  </a>
  <figcaption>The maps in this image show the geographic variation in the mean shift in arrival date per ⁰C change in minimum spring temperature (MAD, days/⁰C) for four bird species. The graphs in the image depict changes in minimum spring temperature and arrival date over time for one example region (denoted with arrow). Source: <a href= "https://blog.nature.org/science/explainer/climate-change-already-changing-seasons-phenology-citizen-science/" target="_blank">The Nature Conservancy.</a>
  </figcaption>
</figure>

<figure>
  <a href="{{ site.url }}/images/courses/earth-analytics/science/phenology/north-america-greenup-map-automation-landsat-ndvi.jpg">
    <img src="{{ site.url }}/images/courses/earth-analytics/science/phenology/north-america-greenup-map-automation-landsat-ndvi.jpg" alt=" Map of shift in spring green-up throughout North America.">
  </a>
  <figcaption>This map conveys how the date of spring greenup is shifting throughout North America. Source: <a href= "https://www.wired.com/2007/11/greenup-of-the-planet-is-not-black-and-white-2/" target="_blank">Wired.</a>
  </figcaption>
</figure>

## Design Your Workflow

Designing workflows to process and create outputs for many large files and datasets is a key skill in Earth science. Yet it’s something that most scientists and earth analysts learn on the fly at some point in their careers. Here, we outline several steps associated with designing a workflow that can help you structure your thinking and develop an effective design. 

### Identify your problem, challenge or question

To begin you need to clarify the question(s) or challenge(s) that you need to address. Knowing the specific problem that you need to solve will help to set bounds on what your workflow does and does not need to do.

###  Identify the data needed to address that question

Once you have a question in mind, it’s time to figure out what your data requirements are. Requirements are the qualities that your data need to have in order to address a particular question well. In this week's class your goal is to create a plot and output csv files of NDVI for your study area for a year. You want to explore seasonal patterns of “green-up” and “brown down” and thus you need data that is at least collected each month. 

What data do you select for your analysis? Consider temporal frequency of data collection and spatial resolution. For example, NAIP is collected every other year, so it is unlikely to provide good information on seasonality. 

In contrast, MODIS and Landsat may be more useful, because they are collected on a daily and bi monthly frequency respectively. In terms of resolution, MODIS pixels could be too large depending upon your study site. Perhaps Landsat has an ideal combination of temporal frequency, resolution and spatial coverage.

### Design your Workflow

Next it’s time to design the workflow that you want to create. Use words - not code - to write out the steps of your workflow. Your task this week is to design a workflow that has two outputs:

1. A plot of average NDVI (for each Landsat image) for 2 sites over a year.
2. A csv file containing the average NDVI values for both sites. 

Once you know your outputs, you can work backwards to determine the data and steps needed to create your final output. The design process is difficult, but we will revisit it in more detail in the next lesson. 

## Implement Your Workflow

Once you have designed your workflow it’s time to implement. This is where you can put all of your programming skills to the test! Try to write code that is clear, efficient, well documented and expressive. Remember that you never know when you may have to re-run or re-use an analysis. And you never know when someone else might need to use your code too.

