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


## Mid Term: 22 March 2017 During class

## Part 1 - the Quiz

A short quiz that you will take during the last hour of class on 22 March 2017
(10%). This quiz will cover key topics that we have been discussing in class
over the past 2 months. A suggested study guide will be posted on the website
to help direct your studying for this. The mid term will be mostly multi-choice
with a few open text questions. It will be designed to take about 30 minutes of
your time to complete (give or take) and you will have about 50 minutes to
complete it.

## Part 2 - A 5 minute group presentation

A **5 minute group presentation** that you will give on the same day. In this
presentation you will present a proposal for your final group project. This
proposal should include
  * A science question that you wish to address or a phenomenon or event that you wish to better understand. It can be related to something we've covered in class or to something completely different!
  * An overview of the data types and sources that you intend to use to answer your science question.
  * An overview of the study area you will be working in.
  * An overview of what you think you'll find working on your project.

You will have some time the week before the presentation is due (march 15) to
ask questions and work on your group project in class.

**Notes:**

* You can use any presentation tool that you wish for your presentation. Powerpoint, rpres, pdf, etc however you need to be able to SUBMIT a copy of your presentation to D2L!
* Groups should be 2-3 people. It is ok if you decide to work on your own but we prefer (and you will have a better project) if you work with others.
* You can reach out to the folks who have presented in this course for guidance / with questions if you want!
* Be sure to read more about the final project before proposing your mid term topic!




## Submit your final mid-term presentation to D2L by 24 March 2017

## Presentation rubric

Each section below is equally weighted

#### Science

|  Full Credit | Partial Credit ~B | Partial Credit ~C | Partial Credit ~D | No Credit|
|---|---|---|---|---|
| Presentation is clear, concise and thoughtfully pulled together. |  | | |  |
| Students present with confidence / make eye contact / are prepared. | |  | | |
|===
| Verbal pauses and fillers are minimized (um, like, etc) | |  | | |


#### Presentation structure

|  Full Credit | Partial Credit ~B | Partial Credit ~C | Partial Credit ~D | No Credit|
|---|---|---|---|---|
| All students introduce themselves / their background  |  | | |  |
| The project topic is clearly and concisely introduced  | | | | |
| The importance of the project topic to those in the room (the specific audience) is clearly articulated  | | |  |
| The study area where the project will be performed is clearly identified  | |  | | |
| 2 specific data sources are identified in the presentation  | |  | | |
| Everyone in the group presents. | |  | | |
|===
| The presentation spans no more than 5 minutes! | |  | | |


#### Slide presentation

|  Full Credit | Partial Credit ~B | Partial Credit ~C | Partial Credit ~D | No Credit|
|---|---|---|---|---|
| Presentation "slides" are simple and easy to read.  |  | | |  |
| Presentation graphics are relevant to the topic being presented  | | | | |
| Presentation graphics clearly present a message. | | |  |
| Data slides (containing maps or plots) area easy to read with clear labels as necessary.  | |  | | |
|===
| Slides can be read from the back of the room. | |  | | |


#### Science

|  Full Credit | Partial Credit ~B | Partial Credit ~C | Partial Credit ~D | No Credit|
|---|---|---|---|---|
| The science question / topic presented is well thought out with potential sources / background clearly articulated  |  | | |  |
| The data to be used to address the question of interest are clearly defined. | |  | | |
| The intended approach to how the data will be processed to address the question / topic of interest is clearly defined. | |  | | |
| The source of the data is clearly defined | |  | | |
|===
| Example of potential / expected results are discussed in the presentation.| |  | | |

***



## Mid Term Quiz - Study Guide

Anything that has been presented both online and in class is fair game for this
quiz. Below, however, is a list of key elements that you should review prior to
to taking the quiz.

### General

* You received a dataset that you haven't worked with before collected by someone else. List 2-3 questions that you might ask prior to working with the data.
* Describe 2 sources of uncertainty associated with spectral remote sensing data.
* Describe 2 sources of uncertainty associated with lidar remote sensing data.

### Week 1 - topics

* Why are self-explanatory file names useful when working on a large project with many files.
* Why is organizing your data into directories in a project useful when working on a large project with many files?
* (Review the reproducibility slide show)[{{ site.url }}/slide-shows/share-publish-archive/]
* List two R markdown code chunk arguments. Next, describe what does each argument does to your document when you knit to HTML or pdf.


### Week 2 - topics

* The 2013 Colorado floods - review readings & video
* What are 3 key components of a lidar system?
* Describe one way to deal with missing data in `R`.
* Following "clean" coding principles and Hadley Wickam's style guide, list 3 things that you can do to make your code easier to read for you, your collaborators and your future self.
* Working with dates in R. What are the steps to dealing with dates in R?
* What is the difference between a `data.frame` and a vector c(1, 2, 3, 4) in `R`?
* Why does the statement `four > five` return a value of `TRUE` in `R`?
* When you import a `.csv` into `R` and make a change to the data that you've imported in `R`, is the original `.csv` modified?


### Week 3

* Readings and videos on lidar data.
* What is the purpose of classifying raster data in R? Provide one example of a raster file that you may classify and list the classes that you would use.
* What is the native format of **discrete return lidar data** when it's collected by the lidar sensor? (raster or vector)
* What is a CHM, DSM, DTM?
* If you import a geotiff (.tif) file into R, what is the structure or type of object that R will create?
* In class we used the `crop()` function to crop rasters. What does cropping a raster do to the spatial extent of the raster object in `R`?


### Week 4

* Why is a histogram of a raster dataset useful when classifying raster data in `R`?


### Week 5

* When you import a shapefile into `R`, what is the structure or type of object that `R` creates?
* What is a coordinate reference system? Why are they important? Why are there different CRS' for different data?
* When you compare lidar derived tree height to human measured tree height - are they the same thing? Provide 2-3 examples of why lidar over or under-estimate human measured tree height for a vegetation plot.
* When you extract data from a raster using the `extract()` function, what are you doing?
* What are the three types (structures) of vector data?


### Week 6

* To date, how many landsat missions have there been since the inception of landsat?
* What type of data are Landsat & MODIS data (vector or raster)?
* What are the key differences between Landsat, MODIS & NAIP data?
* What are the key differences between Landsat data and lidar data?
* Describe the key differences between active and passive remote sensing.
* What is a vegetation index?
* List one vegetation index that you can use to quantify the extent of a burned area.


### Week 7

* You recieved a spectral dataset (Landsat) from your colleague. Unfortunately it has cloud cover in the image. How will this impact your study area analysis?
* What is one way you can account for / deal with clouds in spectral remote sensing data?
* You recieve a lidar terrain model that is 1 m spatial resolution. What does the 1 meter represent? What is spatial resolution?
* Define spectral resolution associated with spectral remote sensing data (Landsat, MODIS)?


#### Week 8

* Define expressive programming. Provide one example
* What does DRY stand for?
* Provide 2 examples of R functions. Then provide 2 examples of function arguments associated with each function.
