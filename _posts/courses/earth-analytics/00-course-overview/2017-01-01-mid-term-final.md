---
layout: single
category: course-materials
title: "Midterm Project - Earth Analytics Course - GEOG 4563 / 5563"
nav-title: "Midterm Project"
permalink: /courses/earth-analytics/mid-term/
modified: '2018-01-10'
module-type: 'overview'
comments: false
author_profile: false
overview-order: 3
course: "earth-analytics"
sidebar:
  nav:
---

{% include toc title="Earth Analytics Mid-term" icon="file-text" %}


<div class="notice--info" markdown="1">

## <i class="fa fa-ship" aria-hidden="true"></i> About the Class Midterm and Final

The midterm will be broken down into 2 parts each of which are worth half of your
midterm grade:

1. **An individual "open book", quiz:** the goal of this quiz is to ensure that you understand key concepts that have been covered throughout the semester. We have covered a lot! The quiz will be timed to ensure you don't spend too much time on it and thus you'll have to prepare for it.
2. **A 5 minute group presentation:** This presentation should propose a topic for your final project.
</div>

## Midterm: 13 November 2017


*This is the Monday before Thanksgiving / Fall Break*

Presentations will occur during class.
If you are taking the course online, here are your options

1. Please try to attend this one class session either in person or remotely.

If you can't attend the course:

1. Try to schedule a slot where you can attend the class to give your presentation (participate for part of the class).
2. Record your presentation and submit it to D2L prior to the class. We will watch it during the class. Questions will be asked virtually on Piazza and you will be required to address the questions on piazza.

**IMPORTANT:** Please email your instructor (Leah) to let her know how you intend to participate by **Monday 6 November 2013**.


## Part 1: 'Take-home' Quiz

A short quiz that you will take during the mid term week - November 2017. This 
quiz will cover key topics that you have been learning in class over the past 2 
months. A suggested study guide is posted on the website.

* **Date:** The week of November 13. You will have all week to complete the quiz.
* **Format:** The mid term will be mostly multiple choice with a few open text questions.
* **Time:** The quiz will be designed to take about 30 minutes. You will have 60 minutes to
complete it on D2L. Once you begin the quiz, you must complete it so set the time
aside to do so.

## Part 2: 5 Group Presentation (5 mins)

* **Date:** November 13th during class
* **Format:** A **5 minute group presentation**. In this
presentation you will present a proposal for your final group project.

Your presentation should include:

  * A science question that you wish to address or a phenomenon or event that you wish to better understand. It can be related to something you've learned in class or something completely different!
  * An overview of the data types and sources that you intend to use to answer your science question.
  * A map, created in `R`, that shows the project study area.
  * An image that shows the 2 types of data that you'll be working with - this may be a rough plot or just some of the raw data.
  * An brief discussion of what you think you'll find working on your project.

Be sure to closely review the rubric below to see how your presentation will
be graded! You will have some time the week before the presentation is due to
ask questions and work on your group project in class.

**Notes:**

* You can use any presentation tool that you wish for your presentation (powerpoint, pdf, etc.) however you need to be able to SUBMIT a copy of your presentation to D2L!
* Groups should be 2-3 people. It is ok if you decide to work on your own but I prefer (and you will have a better project) if you work with others.
* You can reach out to the folks who have presented in this course for guidance if you want!
* Be sure to read more about the final project before proposing your midterm topic!


## Submit Your Final Midterm Presentation to D2L by 13 November 2017 @ 9AM

## Mid-Term Presentation Rubric


#### Science (50%)

| Full Credit | No Credit  |
|:----|----|
| The science question / topic is thoughtfully presented |  |
| The **importance of the project topic to those in the room** (the specific audience) is clearly articulated. Why should we care?  |  |
|===
| Example of potential / expected results are discussed in the presentation| |


#### Data (25%)

| Full Credit | No Credit  |
|:----|----|
| Two specific data sources are identified in the presentation  | |
| Each data source identified is described: how it's collected & where its acquired from  | |
| How the data will be used to address the topic is clearly articulated | |
| Rough data plots or example images of the data to be used (even if it's the raw data) are shown in the presentation | |
|===
| An `R` generated study area map is included in the presentation to clearly articulate the study area  | |


#### Presentation (20%)

| Full Credit | No Credit  |
|:----|----|
| Presentation is clear, concise and thoughtfully pulled together |  |
| Presenters are well prepared | |
| All students introduce themselves and their background  |  |
| The project topic is clearly and concisely introduced  | |
| Everyone in the group presents | |
|===
| The presentation spans no more than 5 minutes | |


#### Slide Presentation (5%)

| Full Credit | No Credit  |
|:----|----|
| Presentation "slides" are not too text heavy, simple and easy to read  |  |
| Presentation graphics are relevant to the topic being presented and clear  | |
| Data slides (containing maps or plots) area easy to read, well annotated (x and y axes, title, etc)  | |
| Data slides cite the source of the data | |
|===
| Slides can be read from the back of the room | |


***



## Midterm Quiz - Study Guide

Anything that has been presented both online and in class is fair game for this
quiz. Below, however, is a list of key elements that you should review prior to
to taking the quiz.

### General

* You received a dataset that you haven't worked with before, collected by someone else. List 2-3 questions that you might ask prior to working with the data.
* Describe 2 sources of uncertainty associated with spectral remote sensing data.
* Describe 2 sources of uncertainty associated with lidar remote sensing data.

### Reproducibility & Open Science

* Why are self-explanatory file names useful when working on a large project with many files.
* Why is organizing your data into directories in a project useful when working on a large project with many files?
* [Review the reproducibility slide show]({{ site.url }}/slide-shows/share-publish-archive/)
* List two `R Markdown` code chunk arguments. Next, describe what each argument does to your document when you knit to .html format.


### Time Series Data & the 2013 Colorado Floods

* The 2013 Colorado floods - review readings & video.
* What are 3 key components of a lidar system?
* Describe one way to deal with missing data in `R`.
* Following "clean" coding principles and Hadley Wickam's style guide, list 3 things that you can do to make your code easier to read for you, your collaborators and your future self.
* Working with dates in `R`. What are the steps to dealing with dates in `R`?
* What is the difference between a `data.frame` and a vector `c(1, 2, 3, 4)` in `R`?
* Why does the statement `four > five` return a value of `TRUE` in `R`?
* When you import a `.csv` into `R` and make a change to the data that you've imported in `R`, is the original `.csv` modified?


### Light Detection and Ranging Data (Lidar Remote Sensing)

* Readings and videos on lidar data.
* What is the purpose of classifying raster data in R? Provide one example of a raster file that you may classify and list the classes that you would use.
* What is the native format of **discrete return lidar data** when it's collected by the lidar sensor? (raster or vector)
* What is a CHM, DSM, DTM?
* If you import a geotiff (.tif) file into R, what is the structure or type of object that R will create?
* In class we used the `crop()` function to crop rasters. What does cropping a raster do to the spatial extent of the raster object in `R`?
* Why is a histogram of a raster dataset useful when classifying raster data in `R`?


### Spatial Data / GIS in R

* When you import a shapefile into `R`, what is the structure or type of object that `R` creates?
* What is a coordinate reference system? Why are they important? Why are there different CRS' for different data?
* When you compare lidar derived tree height to human measured tree height - are they the same thing? Provide 2-3 examples of why lidar over or under-estimate human measured tree height for a vegetation plot.
* When you extract data from a raster using the `extract()` function, what are you doing?
* What are the three types (structures) of vector data?

### Landsat & MODIS Remote Sensing Data & Vegetation Indices

* To date, how many Landsat missions have there been since the inception of Landsat?
* What type of data are Landsat & MODIS data (vector or raster)?
* What are the key differences between Landsat, MODIS & NAIP data?
* What are the key differences between Landsat data and lidar data?
* Describe the key differences between active and passive remote sensing.
* What is a vegetation index?
* List one vegetation index that you can use to quantify the extent of a burned area.
* You received a spectral dataset (Landsat) from your colleague. Unfortunately it has cloud cover in the image. How will this impact your study area analysis?
* What is one way you can account for or deal with clouds in spectral remote sensing data?
* You receive a lidar terrain model that is 1 m spatial resolution. What does the 1 meter represent? What is spatial resolution?
* Define spectral resolution associated with spectral remote sensing data (Landsat, MODIS)?


### Functions & Automation

* Define expressive programming. Provide one example.
* What does DRY stand for?
* Provide 2 examples of `R` functions. Then provide 2 examples of function arguments associated with each function.
