---
layout: single
category: course-materials
title: "Week 4: Data workflows"
permalink: /course-materials/earth-analytics/week-4/
week-landing: 4
week: 4
sidebar:
  nav:
comments: false
author_profile: false
---

{% include toc title="This Week" icon="file-text" %}


<div class="notice--info" markdown="1">

## <i class="fa fa-ship" aria-hidden="true"></i> Welcome to Week {{ page.week }}!

Welcome to week {{ page.week }} of Earth Analytics! This week, we will review
some key concepts associated with working with time series & spatial data and rasters.
Also, we will cover some key frameworks for organizing an rmarkdown document and
starting a workflow to explore a dataset.

## <i class="fa fa-check-square-o fa-2" aria-hidden="true"></i> What you need

You will need a computer with internet access to complete this lesson and the data for week 4 of the course. We will use the data that we've been using for the first few weeks of
course in our lessons today.

</div>

|  Time | Topic   | Speaker   |
|---|---|---|---|---|
| 3:00 pm  | Review r studio / r markdown / questions  | Leah  |
| 3:20 - 4:00  | Open Topography / lidar data | Chris Crosby, UNAVCO / Open Topography  |
| 4:15 - 5:50  | R coding session - Use lidar to characterize vegetation / uncertainty | Leah  |

### 1. Complete the assignment below

<div class="notice--warning" markdown="1">

## <i class="fa fa-pencil-square-o" aria-hidden="true"></i> Homework Submission

### Produce a .pdf report

Create a new `R markdown `document. Name it: **lastName-firstInitial-week4.Rmd**
Within your `.Rmd` document, include the plots listed below.

When you are done with your report, use `knitr` to convert it to `PDF` format (note:
if you did not get `knitr` working it is ok if you create an html document and
export it to pdf as we demonstrated in class). You will submit both
the `.Rmd` file and the `.pdf` file. Be sure to name your files as instructed above!

In your report, include the plots below. The important part of this week is that
you document each step of your workflow using comments. And that you break up the
sections of your analysis into SEPARATE code chunks.

### About the plots

For your homework last week, you created 2 **classified** and **cropped** raster
maps that showed positive and negative change between the pre and post flood conditions,
as seen in the lidar derived terrain and the canopy height models. To do thus you subtracted the pre-flood DTM from the post-flood DTM (**post_flood_DTM - pre-flood-DTM**). You
performed the same math on the CHM data. You then cropped
the plot using the `crop_extent.shp` shapefile that was included in your data
download and classified the data using values that made sense.

This week, you will recreate the SAME plots however, you will outline the steps that
are needed to create a meaningful plot and histogram in `R`, in your `.Rmd` file.
Also, you will separate out key components of your analysis, into individual code
chunks in your `.Rmd `file.

### Part 1: Classified DTM difference map

In your .Rmd demonstrate all of the steps needed to create a map that shows the
difference (post-flood minus pre-flood) between the pre
and post flood digital terrain models (DTMs). To create this map you should subtract the
pre-flood DTM from the post-flood DTM. The steps include:

#### Data Processing
1. Open the pre and post flood raster data.
1. Calculate the difference between the two rasters.
1. Crop the data.

#### Data Exploration
1. Explore the data. What is the min and max values of the data?
1. Plot a histogram of the difference raster using the base histogram function (don't worry about custom breaks)
1. Plot a second histogram of the difference raster and customize the breaks to mimic the
classes that you may want to use for your final classified raster. Note - you should spend some time on this step to produce a histogram that looks good and clearly shows areas of positive and negative change.
1. Plot a map of the difference raster - use breaks and custom colors to "color" positive and negative  difference "bins".


#### Final Data Processing
1. Once your are happy with the plot above, classify your raster using the breaks that you have defined.

#### Final data presentation
1. Plot your classified raster
2. Add a title and legend to your plot - you are done with the first part!

### Part 2: Classified CHM difference map

This map should show the difference (post-flood minus pre-flood) between the two canopy
height models (CHM). To create this map you should subtract the pre-flood CHM
from the post-flood CHM.

Follow the steps that you followed above for part one. Note that you will have a few
additional steps in the data processing section because you will need to first calculate
the pre and post flood CHM and then perform the difference calculate (**Post-flood-CHM minus Pre-flood-CHM**).

### BONUS (1 point): Use colorBrewer to create a color ramp
In the lessons, I show you how to color your map by manually selecting colors.
Use the `RColorBrewer` package to create a set of colors to use on your plot.

* <a href="https://www.r-bloggers.com/r-using-rcolorbrewer-to-colour-your-figures-in-r/" target="_blank"> R-Bloggers - using color brewer</a>
* <a href="https://cran.r-project.org/web/packages/RColorBrewer/RColorBrewer.pdf" target="_blank"> Color brewer documentation</a>

## Homework due: Feb 15 2017 @ noon.
Submit your report in both `.Rmd` and `.PDF` format to the D2l week 4 dropbox by NOON.NOTE: it is OK if you'd like to submit an html document to D2l.
If you do, please ZIP the html file up with your .Rmd file.

</div>

### .Pdf Report structure & code: 30%

|  Full Credit | Partial Credit ~B | Partial Credit ~C | Partial Credit ~D | No Credit|
|---|---|---|---|---|
| PDF and RMD submitted |  | Only one of the 2 files are submitted  | | No files submitted |
| Code is written using "clean" code practices following the Hadley Wickham style guide| Spaces are placed after all # comment tags, variable names do not use periods, or function names. | Clean coding is used in some of the code but spaces or variable names are incorrect 2-4 times| | Clean coding is not implemented consistently throughout the report. |
| YAML contains a title, author and date | Author, title and date are in YAML | One element is missing from the YAML | | 2 or more elements are missing from the YAML |
| Code chunk contains code and runs  | All code runs in the document  | There are 1-2 errors in the code in the document that make it not run | | The are more than 3 code errors in the document |
| All required R packages are listed at the top of the document in a code chunk.  | | Some packages are listed at the top of the document and some are lower down. | | |

### Part 1 - Classified DTM Difference Raster Plot: 35%

|  Full Credit | Partial Credit ~B | Partial Credit ~C | Partial Credit ~D | No Credit|
|---|---|---|---|---|
| DTM Difference plot is customized with appropriate titles, axis labels and colors.  | Plot is correct but is missing a title. | Plot is missing appropriate labels. | | Plot is missing|
| DTM difference data are CROPPED using the crop_extent shapefile ||| | Data are not cropped to the crop_extent shapefile|
| Difference DTM is classified into discrete values || | | Data are not classified into discrete values |
| Data Exploration Plot 1: Plot a histogram of the DTM difference raster using the base histogram function (don’t worry about custom breaks)||| | Histogram is missing |
| Data Exploration Plot 2: Plot a second histogram of the DTM difference raster and customize the breaks to mimic the classes that you may want to use for your final classified raster. ||| | Histogram is missing |
| The colors and classes selected to plot the final difference raster, selected using the previous histogram s clearly show changes. | || | The colors and classes selected do not show change well / don't show change at all. |


### Part 2 - Classified CHM Difference Raster Plot: 35%

|  Full Credit | Partial Credit ~B | Partial Credit ~C | Partial Credit ~D | No Credit|
|---|---|---|---|---|
| Difference CHM plot is customized with appropriate titles, axis labels and colors. | Plot is correct but is missing a title. | Plot is missing appropriate labels and is not described adequately in the text of the report. | |Plot is missing|
| Difference CHM data are CROPPED using the crop_extent shapefile||| | Data are not cropped to the crop_extent shapefile|
| Difference CHM is classified into discrete values || | | Data are not classified into discrete values |
| Data Exploration Plot 1: Plot a histogram of the difference raster using the base histogram function (don’t worry about custom breaks)||| | Histogram is missing |
| Data Exploration Plot 2: Plot a second histogram of the difference raster and customize the breaks to mimic the classes that you may want to use for your final classified raster. ||| | Histogram is missing |
| The colors and classes selected to plot the final difference raster, selected using the previous histogram s clearly show changes. | || | The colors and classes selected do not show change well / don't show change at all. |
