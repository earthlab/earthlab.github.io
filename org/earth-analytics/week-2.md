---
layout: single
category: course-materials
title: "Week Two - Introduction to R & RStudio"
permalink: /course-materials/earth-analytics/week-2/
sidebar:
  nav: earth-analytics-2017
comments: false
author_profile: false
---


<div class="notice--info" markdown="1">

## <i class="fa fa-ship" aria-hidden="true"></i> Welcome to Week 2!

Welcome to week two of Earth Analytics! In week 2 we will learn how to work with
data in `R` and `Rstudio`. We will also dig deeper into the 2013 Colorado floods.

### In Class Lessons
* [In Class](/course-materials/earth-analytics/week-2/get-to-know-r/)

### Homework Lessons

* [Homework Lesson Set 1: Plot with Ggplot & Date / Time Formats directory](/course-materials/earth-analytics/week-2/hw-ggplot2-r)

Read the assignment below carefully. Use the class and homework lessons to help
you complete the assignment. 
</div>

## <i class="fa fa-pencil"></i> Week 2: Homework

### Part 1 - Readings

Read the following articles:

1. <a href="http://journals.ametsoc.org/doi/full/10.1175/BAMS-D-13-00241.1" target="_blank">Gochis, D., Schumacher, R., Friedrich, K., Doesken, N., Kelsch, M., Sun, J., Ikeda, K., Lindsey, D., Wood, A., Dolan, B., Matrosov, S., Newman, A., Mahoney, K., Rutledge, S., Johnson, R., Kucera, P., Kennedy, P., Sempere-Torres, D., Steiner, M., Roberts, R., Wilson, J., Yu, W., Chandrasekar, V., Rasmussen, R., Anderson, A., & Brown, B. (2014):  The great Colorado flood of September 2013.  Bull. Amer. Meteor. Soc. 96, 1461-1487, doi:10.1175/BAMS-D-13-00241.1.</a>

2. Coe, J.A., Kean, J.W., Godt, J.W., Baum, R.L., Jones, E.S., Gochis, D.J., & Anderson, G.S. (2014):  New insights into debris-flow hazards from an extraordinary event in the Colorado Front Range.  GSA Today 24 (10),  4-10, doi: 10.1130/GSATG214A.1.

3. Anderson, S.W., Anderson, S.P., & Anderson, R.S. (2015).  Exhumation by debris flows in the 2013 Colorado Front Range storm. Geology 43 (5), 391-394, doi:10.1130/G36507.1. 




### Part 2 - Plot Precip & Discharge Data

Download the data below. This data contains about 10 years of Precipitation
data, recorded at a location in Boulder, Colorado. Using what we covered in class
today, AND the lessons BELOW. do the following.

1. Create a new rmarkdown document. Title it: `lastname-firstname-week2.rmd`
2. Be sure to add a descriptive title and your name as the author in the `YAML` at the top of the file.
3. In the rmarkdown document, open up the dataset that you downloaded above and:
  * Clean the data up as you need to. This will include converting the date field to a `R` date class.
  * Look at the min and max values in the PRECIP `field`. Assign `NA` to any noData values. HINT: you may need to adjust your read.csv import code to assign certain values to NA as we covered in class.
  * Plot precipitation data using the `GGPLOT` function. Be sure to LABEL: X and Y axes and give the plot a DESCRIPTIVE title.
  * Adjust the colors of the plot as you see fit. Make the plot look nice.
4. Finally, interpret the plot. Describe what the data tell you. Describe how the data were collected.

### Part 3 - Plot Stream Discharge Data

Next, plot stream discharge data.

difference: discharge$datetime <- as.Date(discharge$datetime, format="%m/%d/%y")
%y for year rather than %Y. What is the difference???

Download the Precipitation Dataset.

* [Homework Lesson Set 1: Plot with Ggplot & Date / Time Formats directory](/course-materials/earth-analytics/week-2/hw-ggplot2-r){: .btn .btn--info .btn--large}
