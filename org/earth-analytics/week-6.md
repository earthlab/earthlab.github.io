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
| 3:00 - 4:00  |  |   |
| 4:15 - 4:45  | |   |
| 4:45 - 5:50  |  |   |

### 1. Readings


* About landsat 8: https://landsat.gsfc.nasa.gov/landsat-data-continuity-mission/

https://www.e-education.psu.edu/natureofgeoinfo/c8_p12.html

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
1. **Write 1 paragraph:** In your own words, describe what a Coordinate Reference System (CRS) is. If you are working with two datasets that are stored using difference CRSs, and want to process or plot them, what do you need to do to ensure they line up on a map and can be processed together?
2. **Write *atleast* 2 paragraphs:** In this class we learned about lidar and canopy height models. We then compared height values extracted from a canopy height model compared to height values measured by humans at each study site. Compare the results of the scatter plots below (plots 3 and 4).
Which lidar estimate (max vs average) does a better job of comparing measured
average or max tree height ? Any ideas why one is better than the other? Discuss
this referencing what you see in the plots and the readings assigned for homework.
3. **Write *atleast* 1 paragraph:** List atleast 3 sources of uncertainty associated with the lidar derived tree heights and the in situ measurements of tree height. Be sure to reference the plots in your report when discussing this. Note: the assigned readings will help you write this paragraph.

#### Include the plots below.
Be sure to describe what each plot shows in your final report.

#### Plot 1 - Basemap of the study area

Create a basemap that shows the location of the study area within the larger state
of California / western United States or united states. Pick a spatial extent that
helps someone from the USA understand where the SJER site is located. HINT: use the
`ggmap()` lesson from week 4 if you forget how to do this!

#### Plot 2 - Study area map 2

Create a map of our SJER study area as follows:

1. Import the `madera-county-roads/tl_2013_06039_roads.shp` layer located in your week4 data download. Adjust line width as necessary.
2. Create a map that shows the madera roads layer, sjer plot locations and the sjer_aoi boundary.
3. Plot the roads by road type and the plots by plot type.
4. Add a **title** to your plot.

IMPORTANT: be sure that all of the data are within the same `EXTENT` and `crs`
of the `sjer_aoi` layer. This means that you may have to CROP and reproject your data prior to plotting it!

#### **BONUS - 1 point**:

Add a **legend** to your roads/ study area plot that shows both the road types and the plot locations. [Use the homework lesson on custom legends]({{ site.url }}/course-materials/earth-analytics/week-5/r-custom-legend/) to help build the legend.

#### Plot 3 & 4 scatterplots
Create two scatter plots that compare:

* **MAXIMUM** canopy height model height in meters, extracted within a 20 meter radius, compared to **MAXIMUM** tree
height derived from the in situ field site data.
* **AVERAGE** canopy height model height in meters, extracted within a 20 meter radius, compared to **AVERAGE** tree
height derived from the in situ field site data.

#### Plot 5 & 6 difference bar plots
Create barplots that show the DIFFERENCE between:

* Extracted lidar max canopy height model height compared to measured max height per plot.
* Extracted lidar average canopy height model compared to measured average height per plot.

#### Graduate students only
Add a regression line to each scatterplot. For both plots write a thoughtful paragraph
describing what the regression relationship tells you about the relationship
between lidar and measured vegetation height. Does the comparison between lidar and
measured average height look stronger? Or Maximum height? Why might one be "better"
or a strong relationship than the other.

### IMPORTANT: for all plots
* Label x and y axes appropriately - include units
* Add a title to your plot that describes what the plot shows
* Add a 2-3 sentence caption below each plot that describes what it shows HINT: you can use the knitr argument fig.cap="Caption here" if you are knitting to pdf to automatically add captions.

## Homework due: Friday Feb 24 2017 @ noon.
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
