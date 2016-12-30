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

### In Class Lessons
* [In Class](/course-materials/earth-analytics/week-2/get-to-know-r/)


### Homework Lessons

* [Homework Lesson Set 1: Plot with Ggplot & Date / Time Formats directory](/course-materials/earth-analytics/week-2/hw-ggplot2-r)

Read the assignment below carefully. Use the class and homework lessons to help
you complete the assignment.
</div>

## <i class="fa fa-pencil"></i> Week 2: Homework

### Part 1 - Readings

Read the following articles. They will help you write your report.

1. <a href="http://journals.ametsoc.org/doi/full/10.1175/BAMS-D-13-00241.1" target="_blank">Gochis, D., Schumacher, R., Friedrich, K., Doesken, N., Kelsch, M., Sun, J., Ikeda, K., Lindsey, D., Wood, A., Dolan, B., Matrosov, S., Newman, A., Mahoney, K., Rutledge, S., Johnson, R., Kucera, P., Kennedy, P., Sempere-Torres, D., Steiner, M., Roberts, R., Wilson, J., Yu, W., Chandrasekar, V., Rasmussen, R., Anderson, A., & Brown, B. (2014):  The great Colorado flood of September 2013.  Bull. Amer. Meteor. Soc. 96, 1461-1487, doi:10.1175/BAMS-D-13-00241.1.</a>

2. Coe, J.A., Kean, J.W., Godt, J.W., Baum, R.L., Jones, E.S., Gochis, D.J., & Anderson, G.S. (2014):  New insights into debris-flow hazards from an extraordinary event in the Colorado Front Range.  GSA Today 24 (10),  4-10, doi: 10.1130/GSATG214A.1.

3. Anderson, S.W., Anderson, S.P., & Anderson, R.S. (2015).  Exhumation by debris flows in the 2013 Colorado Front Range storm. Geology 43 (5), 391-394, doi:10.1130/G36507.1. 

4. Read the short article and **listen to the 7 minute interview with Suzanne Anderson**: To listen - click on the "<i class="fa fa-volume-up" aria-hidden="true"></i>
Listen" icon on the page
<a href="http://www.cpr.org/news/story/study-2013-front-range-floods-caused-thousand-years-worth-erosion" target="_blank">Study: 2013 Front Range floods caused a thousand year's worth of erosion</a>

***

### Part 2 - Plot Precip & Discharge Data

1. Create a new `R markdown` document. Name it: `youLastName-yourFirstName-week2.rmd`
2. In this `R markdown` document, add the following plots [using the homework lessons
as a guide to walk you through](/course-materials/earth-analytics/week-2/hw-ggplot2-r).
    * Create a plot of precipitation from 2003 to 2013 using `ggplot()`.
    * Create a plot that shows precipitation SUBSETTED from Aug 15 - Oct 15 2013
    * Create a plot of stream discharge from 1986 to 2016 using `ggplot()`.
    * Create a plot that shows stream discharge SUBSETTED from Aug 15 - Oct 15 2013

Be sure to:

* LABEL all plots clearly. This includes a title, x and y axis labels
* Be sure to write [clean code](/course-materials/earth-analytics/week-2/write-clean-code-with-r/). This includes comments that document / describe the steps you take in your code and clean syntax following <a href="http://adv-r.had.co.nz/Style.html" target="_blank">Hadley Wickham's style guide.</a>


#### Report Write Up

Turn your R Markdown document into a report about the 2013 Boulder floods by adding
the following:

1. Carefull compose 2-3 paragraphs at the top of the repor which summarize the conditions
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

**Submit your final report in both PDF and R Markdown formats by....**

* [Homework Lesson Set 1: Plot with Ggplot & Date / Time Formats directory](/course-materials/earth-analytics/week-2/hw-ggplot2-r){: .btn .btn--info .btn--large}
