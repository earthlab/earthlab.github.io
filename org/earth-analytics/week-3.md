---
layout: single
category: course-materials
title: "Week 3 - LiDAR Data "
permalink: /course-materials/earth-analytics/week-3/
week-landing: 3
week: 3
sidebar:
  nav:
comments: false
author_profile: false
---

{% include toc title="This Week" icon="file-text" %}

<div class="notice--info" markdown="1">

## <i class="fa fa-ship" aria-hidden="true"></i> Welcome to Week {{ page.week }}!

Welcome to week {{ page.week }} of Earth Analytics! In week 3 we will learn about
Light Detection and Ranging (LiDAR) data. We will cover using point cloud data and
lidar rasters in `R` and will explore using QGIS - a free, open-source GIS tool.

Your final 2013 Colorado flood report assignment is below. Read the assignment
carefully and make sure you've completed all of the steps and followed all of the
guidelines. Use all of the class and homework lessons that we've reviewed in the
first few weeks to help you complete the assignment.

[<i class="fa fa-download" aria-hidden="true"></i> Download Week 3 Data (~250 MB)](https://ndownloader.figshare.com/files/7446715){:data-proofer-ignore='' .btn }
</div>

## <i class="fa fa-calendar-check-o" aria-hidden="true"></i> Class schedule

|  time | topic   | speaker   |
|---|---|---|---|---|
| 3:00 pm  | Review r studio / r markdown / questions  | Leah  |
| 3:20 - 4:00  | Using data and models to understand the boulder floods   | Dr. Mariela Perignon  |
| 4:15 - 5:50  | R coding session - Intro to Lidar data & raster data in R  | Leah  |

### 1. Readings

First - review ALL of the lessons for this week. We did not cover them all in class. This
includes the in class and homework lessons.

Read the following articles. They will help you write your report.

* Wehr, A., and U. Lohr (1999). Airborne Laser Scanning - An Introduction and Overview. ISPRS Journal of Photogrammetry and Remote Sensing 54:68–92. doi: 10.1016/S0924-2716(99)00011-8 : <a href="http://citeseerx.ist.psu.edu/viewdoc/download?doi=10.1.1.9.516&rep=rep1&type=pdf" target="_blank" data-proofer-ignore=''><i class="fa fa-download" aria-hidden="true"></i>
PDF</a>
* <a href="https://www.e-education.psu.edu/geog481/l1_p3.html" target="_blank">Introduction to Lasers</a>
* <a href="https://www.e-education.psu.edu/geog481/l1_p4.html" target="_blank">History of Lidar Development</a>
* <a href="https://www.e-education.psu.edu/natureofgeoinfo/node/1890" target="_blank">Active remote sensing</a>


<div class="notice--warning" markdown="1">

## <i class="fa fa-pencil-square-o" aria-hidden="true"></i> Homework submission

#### Produce a final report on the 2013 Floods

Create a new `R markdown `document. Name it: **lastName-firstInitial-floodreport.Rmd**
Within your `.Rmd` document, carefully compose a report that summarizes what you have
learned about the 2013 Colorado flood event. Use all of the plots that you have created
in the first 3 weeks of the class in your report as listed below.

When you are done with your report, use `knitr` to convert it to `PDF` format (note:
if you did not get `knitr` working it is ok if you create an html document and
export it to pdf as we demonstrated in class). You will submit both
the `.Rmd` file and the `.pdf` file. Be sure to name your files as instructed above!

Include the following parts in your report:

####  Background / overview of the flood

Include the following background in your report:

1. Describe where and when the disturbance event occurred.
2. Discussion of the drivers that yielded the flooding in Boulder and discussion of the impacts of the flood.

#### Your report should include 7 (or 8) Plots
Your report should include the following plots (in whatever order you think best
describes the events of the flood):

### Basemap plot from week 3:

* **PLOT 0:** A basemap showing the location of the stream gage / study area created using
`ggmap()`.

### Precip & discharge plots from week 2:

Use the `data/week2/precipitation/805325-precip-dailysum-2003-2013.csv`file to create:

* **PLOT 1:** a plot of precipitation from 2003 to 2013 using `ggplot()`.
* **PLOT 2:** a plot that shows precipitation SUBSETTED from Aug 15 - Oct 15 2013 using `ggplot()`.

Use the `data/week2/discharge/06730200-discharge-daily-1986-2013.csv` file to create:

* **PLOT 3:** a plot of stream discharge from 1986 to 2016 using `ggplot()`.
* **PLOT 4:** a plot that shows stream discharge SUBSETTED from Aug 15 - Oct 15 2013 using `ggplot()`.

### Raster plots from week 3:

* **PLOT 5:** A **classified** and **cropped** raster map that shows positive and negative change in the canopy height model before and after the flood. To do this you will need to calculate the difference between two canopy height models. Subtract the pre-flood CHM from the post-flood CHM (**post_flood_CHM - pre-flood-CHM**). The plot should be CROPPED using the crop_extent shapefile that is included in your data download. You should classify the plot using values that make
sense after reviewing the histogram of the data (created below).
* **PLOT 6:** A **classified** and **cropped** raster map that shows positive and negative change in terrain
derived from the pre and post flood Digital Terrain Models. Subtract the pre-flood DTM from the post-flood DTM (**post_flood_DTM - pre-flood-DTM**). The plot should be CROPPED using the crop_extent shapefile that is included in your data download. You should classify the plot using values that make
sense after reviewing the histogram of the data (created below).
* **PLOT 7** Create a HISTOGRAM of the **classified** and **cropped** raster map that shows positive and negative change in the canopy height model before and after the flood.
* **PLOT 8** Create a HISTOGRAM of the **classified** and **cropped** raster map that shows positive and negative change in terrain
derived from the pre and post flood Digital Terrain Models.

### Graduate students & anyone who did the bonus week 2 plot

* **PLOT 9:** A plot of precipitation that spans from 1948 - 2013 using the `805333-precip-daily-1948-2013.csv` file. Use the bonus lesson to guide you through creating this plot. This lesson will give you a more real world experience with working with less than perfect data!

For all plots use the readings from the last 3 weeks to discuss:

* Where the data came from and what the data shows.
* Discuss patterns that are evident in the data and potential relationships between
what you see in the lidar data compared to precipitation and discharge.


#### Summary / Discussion
End your report with a summary discussion of the flood events. Be sure to discuss
how the data help us better understand these types of disturbance events.


#### Important:

* Clearly state the source of each dataset that you use to create the plot in your report text.
* Make sure each plot has a clear **TITLE** and, where appropriate, **label the x and y axes**. Be sure to include **UNITS** in your labels!
* Analyze / interpret each plot that you produce in your report. State what the source of the data are and what the plot shows as a driver or impact of the 2013 flood events.
* Clearly document that steps that you took to process the data by commenting your code or in the text of your report itself as it makes sense.
* Cite **atleast 3** articles that you read or other sources of information that you used to write your report.
* Use clean coding practices - this includes comments, variable names that are informative, clean code spacing, following Hadley Wickham's code style guide.
* Make sure all of the libraries that you use in the report are listed in a code chunk at the TOP of your document.
* Spell check your report and check grammar.
* All plots should be clearly labeled with titles, and x and y axis labels are it makes sense. (Your map of lidar data doesn't need x and y labels).
* Be sure to discuss how you selected the classification values used in the raster plots referencing
the histograms of the data that you create.
* OPTIONAL BONUS: Include images as they make sense. Be sure to cite any graphics that you use that are not yours.


## Homework due: Feb 8 @ noon.
Submit your report in both `.Rmd` and `.PDF` format to the D2l dropbox by NOON Wednesday 8
February 2017.
</div>

## Report grading

While most homework assignments are worth 5 points, this homework is worth 20 points as it
represents a culmination of the things we have learned during the first 3 weeks
of class. The grading rubric that we will use to grade the assignment is below.

### Report content - text writeup: 40%

|  Full Credit | Partial Credit | Partial Credit | No Credit|
|---|---|---|---|---|
| PDF and RMD submitted | Both files are submitted  | Only one of the 2 files are submitted  | NA |
| Summary text is provided for each plot | Summary text is provided for all of the plots in the report. | Summary text is missing for 1-2 plots in the report. | Summary text is not included for 3 or more plots.  |
| Grammar & spelling are accurate throughout the report| No visible grammar or spelling issues in the report| 2-4 grammar and spelling issues in the report| More than 4 spelling / grammar issues in the report |
| File is named with last name-first initial week 3| File naming is as required| NA | File is not named properly|
| Report contains all 9 (or 10 if you're a grad student) plots described in the assignment| All plots are included in the report|1 plot is missing| More than 1 plot is missing|
| References are made to the assigned class readings in your report in the form of citations. | References are made to atleast 3 readings assigned over the last 3 weeks of class. | References are made to 1-2 readings assigned over the last 3 weeks of class. | No references are made to the assigned readings. |
| BONUS: images are added to your report. | 1-2 additional images are added to your report - bonus points!. | NA | NA |
| There is a thoughtful discussion of the relationship between precip, discharge and patterns seen in the lidar pre-post flood data.||| Discussion is missing. |


### Report Content - Code Format: 30%

|  Full Credit | Partial Credit | Partial Credit | No Credit|
|---|---|---|---|---|
| Code is written using "clean" code practices following the Hadley Wickham style guide| Spaces are placed after all # comment tags, variable names do not use periods, or function names. | Clean coding is used in some of the code but spaces or variable names are incorrect 2-4 times| clean coding is not implemented consistently throughout the report. |
| YAML contains a title, author and date | Author, title and date are in YAML | One element is missing from the YAML | 2 or more elements are missing from the YAML |
| Code chunk contains code and runs  | All code runs in the document  | There are 1-2 errors in the code in the document that make it not run | The are more than 3 code errors in the document |
| All required R packages are listed at the top of the document in a code chunk.  | All libraries are listed at the top of the .Rmd in a code chunk. | Some libraries are at the top and some are lower down. | NA |



### Plots - Previously produced plots - 10%

|  Full Credit | Partial Credit | Partial Credit | No Credit|
|---|---|---|---|---|
| PLOT 0 - `ggmap()` basemap | `ggmap()` basemap included  | NA  | Missing `ggmap()` basemap | Plot is missing|
| PLOT 1 - precipitation from 2003 to 2013 using `ggplot()`| Plot is customized with appropriate titles, axis labels and colors. Plot data source is clearly described in the text & the plot data are interpreted relative to the boulder flood. | Plot is correct but is not coded using `ggplot()` / or the data source is not mentioned in the text./ or the data source is not mentioned in the text.| Plot is missing appropriate labels and is not described adequately in the text of the report.  |Plot is missing|
| PLOT 2: a plot that shows precipitation SUBSETTED from Aug 15 - Oct 15 2013 using `ggplot()`. | Plot is customized with appropriate titles, axis labels and colors. Plot data source is clearly described in the text & the plot data are interpreted relative to the boulder flood. | Plot is correct but is not coded using `ggplot()` / or the data source is not mentioned in the text.| Plot is missing appropriate labels and is not described adequately in the text of the report.  |Plot is missing|
| PLOT 3: a plot of stream discharge from 1986 to 2016 using `ggplot()`.| Plot is customized with appropriate titles, axis labels and colors. Plot data source is clearly described in the text & the plot data are interpreted relative to the boulder flood. | Plot is correct but is not coded using `ggplot()` / or the data source is not mentioned in the text.| Plot is missing appropriate labels and is not described adequately in the text of the report.  |Plot is missing|
| PLOT 4: a plot that shows stream discharge SUBSETTED from Aug 15 - Oct 15 2013 using `ggplot()`.| Plot is customized with appropriate titles, axis labels and colors. Plot data source is clearly described in the text & the plot data are interpreted relative to the boulder flood. | Plot is correct but is not coded using `ggplot()` / or the data source is not mentioned in the text.| Plot is missing appropriate labels and is not described adequately in the text of the report.  |Plot is missing|
| PLOT 9: A plot of precipitation that spans from 1948 - 2013 using the 805333-precip-daily-1948-2013.csv file. Use the bonus lesson to guide you through creating this plot. (BONUS)| Plot is customized with appropriate titles, axis labels and colors. Plot data source is clearly described in the text & the plot data are interpreted relative to the boulder flood. | Plot is correct but is not coded using `ggplot()` / or the data source is not mentioned in the text.| Plot is missing appropriate labels and is not described adequately in the text of the report.  |Plot is missing|

## Raster Plots - 20%

### Plot 5: A classified raster map that shows positive and negative change in the canopy height model before and after the flood.

|  Full Credit | Partial Credit | Partial Credit | No Credit|
|---|---|---|---|---|
| Plot is customized with appropriate titles, axis labels and colors. Plot data source is clearly described in the text & the plot data are interpreted relative to the boulder flood. | Plot is correct but is missing a title / or the data source is not mentioned in the text.| Plot is missing appropriate labels and is not described adequately in the text of the report. |Plot is missing|
| Data are CROPPED using the crop_extent shapefile||| Data are not cropped to the crop_extent shapefile|
| Raster data are classified into discrete values || | Data are not classified into discrete values |
| The colors and classes selected to process the data and display the plot, clearly show changes in terrain. | Some adjustment was made to the classes and colors but the approach could be improved.|| The colors and classes are show change poorly or don't show change at all. |
| There is text describing where the data come from and what the data show. ||| Text describing where the data come from and what the data show is missing.  |
| There is discussion of how the classification values used in the raster plots were selected referencing the histograms.||| Discussion is missing. |

### Plot 6:
A classified raster map that shows positive and negative change in CHM.| Plot is customized with appropriate titles, axis labels and colors. Plot data source is clearly described in the text & the plot data are interpreted relative to the boulder flood.

|  Full Credit | Partial Credit | Partial Credit | No Credit|
|---|---|---|---|---|
| Plot is correct but is missing a title  / or the data source is not mentioned in the text.| Plot is missing appropriate labels and is not described adequately in the text of the report. || Plot is missing|
| Pre and post flood canopy height models have been created. ||| Pre-post flood CHMs were not created.  |
| Data are CROPPED using the crop_extent shapefile||| Data are not cropped to the crop_extent shapefile|
| Raster data are classified into discrete values || | Data are not classified into discrete values |
| The colors and classes selected to process the data and display the plot, clearly show changes in terrain. | Some adjustment was made to the classes and colors but the approach could be improved.|| The colors and classes are show change poorly or don't show change at all. |
| There is text describing where the data come from and what the data show. ||| Text describing where the data come from and what the data show is missing.  |
| There is discussion of how the classification values used in the raster plots were selected referencing the histograms. ||| Discussion is missing. |


### Plot 7:

A histogram of the classified raster layer that shows positive and negative change in canopy height derived from the pre and post flood Digital Terrain Models before and after the flood

|  Full Credit | Partial Credit | Partial Credit | No Credit|
|---|---|---|---|---|
| Plot is customized with appropriate titles, axis labels and colors. There is discussion of how the histogram was used to select classification ranges. | Plot is correct but is missing a title  / or there is no discussion of what the histogram shows and how it was used to create the classification ranges.| Plot is missing appropriate labels and is discussion is missing in the body of the report. | Plot is missing|
| Histogram breaks were selected to clearly show positive and negative changes ||| Histogram breaks were not adjusted|
| Histogram axes are clearly labeled and includes units ||| Histogram axes are not clearly labeled|
| Plot has a clear title.  ||| Plot title is missing.|


### Plot 8:

A histogram raster map that shows positive and negative change in terrain derived from the pre and post flood Digital Terrain Models before and after the flood.

|  Full Credit | Partial Credit | Partial Credit | No Credit|
|---|---|---|---|---|
| Plot is customized with appropriate titles, axis labels and colors. There is discussion of how the histogram was used to select classification ranges. | Plot is correct but is missing a title  / or there is no discussion of what the histogram shows and how it was used to create the classification ranges.| Plot is missing appropriate labels and is discussion is missing in the body of the report. | Plot is missing|
| Histogram breaks were selected to clearly show positive and negative changes ||| Histogram breaks were not adjusted|
| Histogram axes are clearly labeled and includes units ||| Histogram axes are not clearly labeled|
| Plot has a clear title. ||| Plot title is missing.|
