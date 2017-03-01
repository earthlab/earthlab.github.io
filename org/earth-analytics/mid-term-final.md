---
layout: single
category: course-materials
title: "Mid term & Final"
permalink: /course-materials/earth-analytics/mid-term/
sidebar:
  nav: earth-analytics-2017
comments: false
author_profile: false
---

{% include toc title="Earth Analytics Mid-term" icon="file-text" %}


<div class="notice--info" markdown="1">

## <i class="fa fa-ship" aria-hidden="true"></i> About the class mid term and final

This course includes a Mid term project which is 20% of your grade

The mid term will be broken down into 2 parts:

1. An individual "open book", quiz (10%): the point of this quiz is not that you memorize everything that we've learned in class. It's to ensure that you understand key concepts that have been covered throughout the semester. We have covered a lot! The quiz will be timed to ensure you don't spend too much time on it and thus you'll have to prepare for it some.
2. A 5 minute group presentation that proposed a topic for your final project.
</div>


### Mid Term: 22 March 2017 During class

## Part 1 - the Quiz

A short quiz that you will take during the last hour of class on 22 March 2017 (10%). This quiz will cover key topics that we have been discussing in class over the past 2 months. A suggested study guide will be posted on the website to help direct your studying for this. The mid term will be mostly multi-choice with a few open text questions. It will be designed to take about 30 minutes of your time to complete (give or take) and you will have about 50 minutes to complete it.

## Part 2 - A 5 minute group presentation

A 3-5 minute group presentation that you will give on the same day. In this presentation you will present a proposal for your final group project. This proposal should include
  * A science question that you wish to address or a phenomenon or event that you wish to better understand. It can be related to something we've covered in class or to something completely different!
  * An overview of the data types and sources that you intend to use to answer your science question.
  * An overview of the study area you will be working in.
  * An overview of what you think you'll find working on your project.

You will have some time the week before the presentation is due (march 15) to ask questions and work on your group project in class.

**Notes:**

* You can use any presentation tool that you wish for your presentation. Powerpoint, rpres, pdf, etc!
* Groups should be 2-3 people. It is ok if you decide to work on your own but we prefer (and you will have a better project) if you work with others.
* You can reach out to the folks who have presented in this course for guidance / with questions if you want!
* Be sure to read more about the final project before proposing your mid term topic!



## Mid Term Quiz - Study Guide

Anything that has been presented both online and in class is fair game for this
quiz. Below, however, is a list of key elements that you should review prior to
to taking the quiz.

#### General

* What are questions that we may want to ask before fulling "trusting" data that we haven't worked with before?
* When we say uncertainty - what do we mean?

#### Week 1 - topics

* Importance of self-explanatory file names & data organization best practices.
* (Review the reproducibility slide show)[{{ site.url }}/slide-shows/share-publish-archive/]
* Code chunk arguments


#### Week 2 - topics

* The 2013 Colorado floods - review readings & video
* The components of a lidar system. How Lidar systems work.
* Handling missing data with no data values in R
* Key guidelines of clean coding
* Working with dates in R. What are the steps to dealing with dates in R?
* What is the difference between a data.frame and a vector in R?
* Why does the statement `four > five` return a value of `TRUE` in `R`?

#### Week 3

* Readings and videos on lidar data.
* How and why do we classify raster data?
* What is the native format of discrete return lidar data when it's collected by the lidar sensor? (raster or vector)
* What is a CHM, DSM, DTM?
* If you import a geotiff (.tif) file into R, what is the structure or type of object that R will create?
* What does cropping a raster do?


#### Week 4

* Why is a histogram useful when classifying raster data in R?


#### Week 5

* When you import a shapefile into R, what is the structure or type of object that R creates?
* What is a coordinate reference system? Why are they important? Why are there different CRS' for different data?
* When you compare lidar derived tree height to human measured tree height - are they the same thing? Provide 2-3 examples of why lidar over or under-estimate human measured tree height for a vegetation plot.
* When you extract data from a raster using the `extract()` function, what are you doing?
* What are the three types (structures) of vector data?


#### Week 6

* To date, how many landsat missions have there been since the inception of landsat?
* What type of data are landsat & modis data?
* What are the key differences between Landsat, MODIS & NAIP data?
* What are the key differences between Landsat data and lidar data?
* What is active vs passive remote sensing?
* What is NBR? What is a vegetation index?


#### Week 7

* Are clouds problematic when using remote sensing data? If so, why?
* What is a way we can handle clouds when working with remote sensing data?
* What is spatial resolution?
* What is spectral resolution?
