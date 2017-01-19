---
layout: single
category: course-materials
title: "Week Two - Introduction to R & R Studio & Sensor Network Derived Time Series Data"
permalink: /course-materials/earth-analytics/week-2/
week-landing: 2
week: 2
sidebar:
  nav:
comments: false
author_profile: false
---

{% include toc title="This Week" icon="file-text" %}

<div class="notice--info" markdown="1">

## <i class="fa fa-ship" aria-hidden="true"></i> Welcome to Week 2!

Welcome to week two of Earth Analytics! In week 2 we will learn how to work with
data in `R` and `Rstudio`. We will also learn how to work with data collected
by in situ sensor networks including the USGS stream gage network data and
NOAA / National Weather Service precipitation data. These data are collected through
time and thus require knowledge of both working with date fields, dealing with
missing data and also efficient plotting and subsetting of large datasets. All
of the data we work with are for the Boulder region and can be used to quantify
drivers of the 2013 flood event.

Read the assignment below carefully. Use the class and homework lessons to help
you complete the assignment.
</div>

## <i class="fa fa-calendar-check-o" aria-hidden="true"></i> Class schedule

|  time | topic   | speaker   |
|---|---|---|---|---|
| 3:00 pm  | Review r studio / r markdown / questions  | Leah  |
| 3:20 - 4:00  | Using data and models to understand the boulder floods   | Dr. Mariela Perignon  |
| 4:15 - 5:50  | R coding session - Intro to Scientific programming with R  | Leah  |


## <i class="fa fa-pencil"></i> Homework Week 2

### 1. Readings

Read the papers and pages listed below.

* Wehr, A., and U. Lohr (1999). Airborne Laser Scanning - An Introduction and Overview. ISPRS Journal of Photogrammetry and Remote Sensing 54:68–92. doi: 10.1016/S0924-2716(99)00011-8 : <a href="http://citeseerx.ist.psu.edu/viewdoc/download?doi=10.1.1.9.516&rep=rep1&type=pdf" target="_blank" data-proofer-ignore=''><i class="fa fa-download" aria-hidden="true"></i>
PDF</a>
* <a href="https://www.e-education.psu.edu/geog481/l1_p3.html" target="_blank">Introduction to Lasers</a>
* <a href="https://www.e-education.psu.edu/geog481/l1_p4.html" target="_blank">History of Lidar Development</a>
* <a href="https://www.e-education.psu.edu/natureofgeoinfo/node/1890" target="_blank">Active remote sensing</a>


### 2. Videos

Watch the following videos:

#### The Story of LiDAR Data video
<iframe width="560" height="315" src="//www.youtube.com/embed/m7SXoFv6Sdc?rel=0" frameborder="0" allowfullscreen></iframe>

#### How LiDAR Works
<iframe width="560" height="315" src="//www.youtube.com/embed/EYbhNSUnIdU?rel=0" frameborder="0" allowfullscreen></iframe>


### 3. Install QGIS & review homework lessons

Install QGIS. Use the install QGIS homework lesson as a guide if needed.
Then review all of the homework lessons - they will help you complete the
submission below.

***


<div class="notice--warning" markdown="1">

## <i class="fa fa-pencil-square-o" aria-hidden="true"></i> Homework submission

1. Create a new `R markdown` document. Name it: `youLastName-yourFirstName-week2.rmd`
2. In this `R markdown` document, add the following plots [using the homework lessons
as a guide to walk you through](/course-materials/earth-analytics/week-2/hw-ggplot2-r).
    * Create a plot of precipitation from 2003 to 2013 using `ggplot()`.
    * Create a plot that shows precipitation SUBSETTED from Aug 15 - Oct 15 2013
    * Create a plot of stream discharge from 1986 to 2016 using `ggplot()`.
    * Create a plot that shows stream discharge SUBSETTED from Aug 15 - Oct 15 2013

Note: If you did the challenge activities, you have already created these plots.

Be sure to:

* LABEL all plots clearly. This includes a title, x and y axis labels
* Write [clean code](/course-materials/earth-analytics/week-2/write-clean-code-with-r/). This includes comments that document / describe the steps you take in your code and clean syntax following <a href="http://adv-r.had.co.nz/Style.html" target="_blank">Hadley Wickham's style guide.</a>
* Convert date fields as appropriate


#### Report Write Up

Turn your R Markdown document into a report about the 2013 Boulder floods by adding
the following:

1. Carefully compose 2-3 paragraphs at the top of the repor which summarize the conditions
and the events that took place in 2013 to cause a flood that had significant impacts.
Describe the impacts of the flood on the terrain and the people in Boulder. Then
describe and interpret each
plot, telling us what it shows, and how it impacted the overall disturbance caused
by the floods. Use the readings above to write the text in your report.

When you are happy with your report, convert your R Markdown file into a .pdf
format report using `knitr`.

Be sure to PROOFREAD your report before submitting it. Check for spelling, and grammar.
The text will be graded like a typical paper. The code will be graded for

* syntax, clean code style, function (does it run without errors)

**Submit your final report to the d2l drop box in both `.html` and `.Rmd`
formats by Wed 1 February 2017**

</div>
