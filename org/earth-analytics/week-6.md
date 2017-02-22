---
layout: single
category: course-materials
title: "Week 6"
permalink: /course-materials/earth-analytics/week-6/
week-landing: 6
week: 6
sidebar:
  nav:
comments: false
author_profile: false
---

{% include toc title="This Week" icon="file-text" %}


<div class="notice--info" markdown="1">

## <i class="fa fa-ship" aria-hidden="true"></i> Welcome to Week {{ page.week }}!

Welcome to week {{ page.week }} of Earth Analytics!

</div>


|  Time | Topic   | Speaker   |
|---|---|---|---|---|
| 3:00 - 3:30  | Review last week's assignment / questions |   |
| 3:30 - 4:15  | Understanding fire with Remote sensing data  | Megan Cattau  |
| 4:30 - 5:50  | Coding Session: Spectral RS data in R |  Leah  |

### 1a. Remote sensing readings

* <a href="https://landsat.gsfc.nasa.gov/landsat-data-continuity-mission/" target="_blank">NASA overview of landsat 8</a>
* <a href="https://www.e-education.psu.edu/natureofgeoinfo/c8_p12.html" target="_blank">Penn state e-education post on multi-spectral data. Note they discuss AVHRR at the top which we aren't using but be sure to read about Landsat.</a>

### 1b. Fire readings

* <a href="http://www.denverpost.com/2016/07/13/cold-springs-fire-wednesday/" target="_blank">Denver post article on the cold springs fire.</a>
* <a href="http://www.nature.com/nature/journal/v421/n6926/full/nature01437.html" target="_blank">Fire science for rainforests -  Cochrane 2003.</a>
* <a href="https://www.webpages.uidaho.edu/for570/Readings/2006_Lentile_et_al.pdf
" target="_blank">A review of ways to use remote sensing to assess fire and post-fire effects - Lentile et al 2006.</a>
* <a href="http://www.sciencedirect.com/science/article/pii/S0034425710001100" target="_blank"> Comparison of dNBR vs RdNBR accuracy / introduction to fire indices
 -  Soverel et al 2010.</a>


### 2. Complete the assignment below (10 points)

<div class="notice--warning" markdown="1">

## <i class="fa fa-pencil-square-o" aria-hidden="true"></i> Homework Submission

### Produce a .pdf report

Create a new `R markdown `document. Name it: **lastName-firstInitial-week5.Rmd**
Within your `.Rmd` document, include the plots listed below. When you are done
with your report, use `knitr` to convert it to `PDF` format. Submit both the
`.Rmd` file and the `.pdf` file. Be sure to name your files as instructed above!

#### Use knitr code chunk arguments
In your final report, use the following knitr code chunk arguments to hide messages
and warnings and code as you see fit.

* `message=T`, `warning=T` Hide warnings and messages in a code chunk
* `echo=F` Hide code and just show code output

#### Answer the following questions below in your report
1. What is the key difference between active and passive remote sensing system.
2. Describe *atleast* 3 differences between how lidar vs landsat remote sensing data.
2. Explain what a vegetation index is.

#### Include the plots below.
For all plots
1. Be sure to describe what each plot shows in your final report using a figure
caption argument in your code chunks: `fig.cap="caption here".
2. Add appropriate titles that tells someone reading your report what the map shows

#### Plot 1
Create a basemap that shows the location of your study area. Use `ggmap()` or the
maps package or any other R packages that you'd like to create this map in `R`.

#### Plot 2
Create a MAP of the difference between NDVI pre vs post fire (Post fire - pre-fire NDVI).

#### Plot 3
Create a MAP of the difference between NBR pre vs post fire (Post fire - pre-fire NDVI). Be sure to include a legend on your map that helps someone looking at it
understand differences

#### Plot 4
Create a classified map of post fire NBR using the classification thresholds below.

#### Plot 5
Create a classified map of post fire NDVI using classification values that you
think make sense based upon exploring the data.



## Homework due: Thursday March 2 2017 @ 5PM.
Submit your report in both `.Rmd` and `.PDF` format to the D2l dropbox.

</div>


## .Pdf Report structure & code: 10%

|  Full Credit | Partial Credit ~B | Partial Credit ~C | Partial Credit ~D | No Credit|
|---|---|---|---|---|
| PDF and RMD submitted |  | Only one of the 2 files are submitted  | | No files submitted |
| Code is written using "clean" code practices following the Hadley Wickham style guide| Spaces are placed after all # comment tags, variable names do not use periods, or function names. | Clean coding is used in some of the code but spaces or variable names are incorrect 2-4 times| | Clean coding is not implemented consistently throughout the report. |
| Code chunk contains code and runs  | All code runs in the document  | There are 1-2 errors in the code in the document that make it not run | | The are more than 3 code errors in the document |
| All required R packages are listed at the top of the document in a code chunk.  | | Some packages are listed at the top of the document and some are lower down. | | |
| Lines of code are broken up at commas to make the code more readable  | |  | | |


## Knitr pdf output: 10%

|  Full Credit | Partial Credit ~B | Partial Credit ~C | Partial Credit ~D | No Credit|
|---|---|---|---|---|
| Code chunk arguments are used to hide warnings |  |  | | |
| Code chunk arguments are used to hide code and just show output |  | | |  |
| PDf report emphasizes the write up and the code outputs rather than showing each step of the code |  | | |  |

## Report questions: 40%

|  Full Credit | Partial Credit ~B | Partial Credit ~C | Partial Credit ~D | No Credit|
|---|---|---|---|---|
| Student clearly defines Coordinate Reference System (CRS) (1 paragraph is well written and correctly describes what a CRS is.) |  |  | | |
| Describe what you need to do when you want to plot 2 spatial datasets in 2 different Coordinate Reference System (CRS) (paragraph is well written and correctly describes the key step.) |  |  | | |
| Student compared the scatter plots of average and max height and determined which relationship is "better" (more comparable)|  |  | | |
| Student references what they see in the scatter plots and the difference bar plots to make their argument for which one is better. The argument is based upon data results and what they learned in the readings / class. |  |  | | |
| 1-2 readings from the homework are referenced in this paragraph.|  |  | | |
| 3 sources of uncertainty are discussed in the homework. |||||
| The sources of uncertainty either reference the readings or are real uncertainty sources. |||||

## Plots are worth 40% of the assignment grade

### Plot 1 ggmap() or maps basemap plot 1

|  Full Credit | Partial Credit ~B | Partial Credit ~C | Partial Credit ~D | No Credit|
|---|---|---|---|---|
| Code chunk arguments are used to hide warnings |  |  | | |
| Plot renders on the pdf. |  |  | | |
| Study area location is correct. |  |  | | |
| Plots have a 2-3 caption that clearly describes plot contents. |  |  | | |

### Plot 2 Field site detail map

|  Full Credit | Partial Credit ~B | Partial Credit ~C | Partial Credit ~D | No Credit|
|---|---|---|---|---|
| Roads and plots are included on the map |  |  | | |
| AOI boundary is included on the map. |  |  | | |
| Roads are symbolized by type. |  |  | | |
| Plots are symbolized by type. |  |  | | |
| Plots has a title that defined plot contents. |  |  | | |
| Plots have a 2-3 sentence caption that clearly describes plot contents. |  |  | | |

## Plots 3 & 4 - scatterplots insitu vs lidar

|  Full Credit | Partial Credit ~B | Partial Credit ~C | Partial Credit ~D | No Credit|
|---|---|---|---|---|
| Scatter plot of maximum measured vs lidar tree height is included |  |  | | |
| Scatter plot of average measured vs lidar tree height is included |  |  | | |
| Plots have a title that describes plot contents. |  |  | | |
| X & Y axes are labeled appropriately. |  |  | | |
| Plots have a 2-3 sentence caption that clearly describes plot contents. |  |  | | |

## Plots 5 & 6 - difference bar plot: insitu vs lidar

|  Full Credit | Partial Credit ~B | Partial Credit ~C | Partial Credit ~D | No Credit|
|---|---|---|---|---|
| Bar plot of maximum measured minus lidar tree height is included. |  |  | | |
| Bar plot of average measured minus lidar tree height is included. |  |  | | |
| Plots have a title that clearly describes plot contents. |  |  | | |
| X & Y axes are labeled appropriately. |  |  | | |
| Plots have a 2-3 sentence caption that clearly describes plot contents. |  |  | | |

## Graduate regression scatter plot 1

|  Full Credit | Partial Credit ~B | Partial Credit ~C | Partial Credit ~D | No Credit|
|---|---|---|---|---|
| Bar plot of maximum measured minus lidar tree height is included. |  |  | | Plot is not included |
| Bar plot of average measured minus lidar tree height is included. |  |  | |  plot is not included |
| Plots have a title that clearly describes plot contents. |  |  | | |
| X & Y axes are labeled appropriately. |  |  | | |
| Plots have a 2-3 sentence caption that clearly describes plot contents. |  |  | | |
| 1-2 Paragraphs are included that describe what these plots show in terms of the relationship between lidar and measured tree height and which metrics may or may not be better (average vs maximum height). |  |  | | |
