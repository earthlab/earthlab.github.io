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


## IMPORTANT NEED TO ADD A LESSON ON ADDING IMAGES TO A REPORT

<div class="notice--info" markdown="1">

## <i class="fa fa-ship" aria-hidden="true"></i> Welcome to Week {{ page.week }}!

Welcome to week {{ page.week }} of Earth Analytics! In week 3 we will learn about
Light Detection and Ranging (LiDAR) data. We will cover using point cloud data and
lidar rasters in `R` and will explore using QGIS - a free, open-source GIS tool.

Your final 2013 Colorado flood report assignment is below. Read the assignment
carefully and make sure you've completed all of the steps and followed all of the
guidelines. Use all of the class and homework lessons that we've reviewed in the
first few weeks to help you complete the assignment.
</div>

## <i class="fa fa-calendar-check-o" aria-hidden="true"></i> Class schedule

|  time | topic   | speaker   |
|---|---|---|---|---|
| 3:00 pm  | Review r studio / r markdown / questions  | Leah  |
| 3:20 - 4:00  | Using data and models to understand the boulder floods   | Dr. Mariela Perignon  |
| 4:15 - 5:50  | R coding session - Intro to Scientific programming with R  | Leah  |

### 1. Readings

Read the following articles. They will help you write your report.

* Wehr, A., and U. Lohr (1999). Airborne Laser Scanning - An Introduction and Overview. ISPRS Journal of Photogrammetry and Remote Sensing 54:68–92. doi: 10.1016/S0924-2716(99)00011-8 : <a href="http://citeseerx.ist.psu.edu/viewdoc/download?doi=10.1.1.9.516&rep=rep1&type=pdf" target="_blank" data-proofer-ignore=''><i class="fa fa-download" aria-hidden="true"></i>
PDF</a>
* <a href="https://www.e-education.psu.edu/geog481/l1_p3.html" target="_blank">Introduction to Lasers</a>
* <a href="https://www.e-education.psu.edu/geog481/l1_p4.html" target="_blank">History of Lidar Development</a>
* <a href="https://www.e-education.psu.edu/natureofgeoinfo/node/1890" target="_blank">Active remote sensing</a>


<div class="notice--warning" markdown="1">

## <i class="fa fa-pencil-square-o" aria-hidden="true"></i> Homework Submission

#### Produce a final report

Create a new R markdown document. Name it: lastName-firstInitial-floodreport.rmd
Carefully compose a report that summarized the 2013 Colorado flood event. When you
are done with your report, use knitr to convert it to PDF. You will submit both
the .Rmd file and the .pdf file.

Include the following parts in your report:

####  Background / overview of the flood

Include the following background in your report:

1. Where and when the disturbance event occured.
2. Discussion of the drivers that yielded the flooding in Boulder and discussion of the impacts of the flood.
3. Plots that show precipitation and discharge data during the flood period and around the flood period. Be sure to:
    * Discuss where the data came from and what it shows.
    * Discuss patterns that are evident in the data and how precipitation is or isn't linked to discharge.
    * Interpret your plots
4. Plots of lidar data that show before / after differences in elevation and tree cover.

#### Summary / Discussion
A summary of the flood events, how drivers and impacts were quantified and
and what the data show you about those drivers and impacts.

#### Important:

* Clearly state the source of each dataset that you use.
* Analyze / interpret each plot that you produce in your report. State what the source of the data are and what the plot shows as a driver or impact of the 2013 flood events.
* Clearly document that steps that you took to process the data by commenting your code or in the text of your report itself as it makes sense.
* Cite articles that you read or other sources of information that you used to write your report.
* Use clean coding practices - this includes comments, variable names that are informative, clean code spacing, following Hadley Wickham's code style guide.
* Spell check your report and check grammar.
* All plots should be clearly labeled with titles, and x and y axis labels are it makes sense. (Your map of lidar data doesn't need x and y labels).
* Include images as they make sense. Be sure to cite any graphics that you use that are not yours


### Deadline
Submit your report in both .Rmd and .PDF format by xXX @ 5pm.
</div>
