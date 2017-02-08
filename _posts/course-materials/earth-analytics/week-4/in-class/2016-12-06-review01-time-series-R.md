---
layout: single
title: "Week 4 Review"
excerpt: "."
authors: ['Leah Wasser']
modified: '2017-02-08'
category: [course-materials]
class-lesson: ['week4-review-r']
permalink: /course-materials/earth-analytics/week-4/week4-review-r/
nav-title: 'Week 4 review'
module-title: 'Review of key concepts in R'
module-description: 'In this module, we will review some key concepts associated with both
time series data and raster data in R. '
module-nav-title: 'Spatial Data in R'
module-type: 'class'
week: 4
sidebar:
  nav:
author_profile: false
comments: true
order: 1
---

{% include toc title="In This Lesson" icon="file-text" %}

<div class='notice--success' markdown="1">

## <i class="fa fa-graduation-cap" aria-hidden="true"></i> Learning Objectives

After completing this tutorial, you will be able to:

*

## <i class="fa fa-check-square-o fa-2" aria-hidden="true"></i> What you need

You will need a computer with internet access to complete this lesson and the data for week 4 of the course.

[<i class="fa fa-download" aria-hidden="true"></i> Download Week 4 Data (~500 MB)](https://ndownloader.figshare.com/files/7525363){:data-proofer-ignore='' .btn }

</div>


# Exploring Data

Is there a visual change in the data over time that may not be related to changes
in precipitation?



```r
library(ggplot2)
# bonus lesson
precip_file <- "data/week2/precipitation/805333-precip-daily-1948-2013.csv"

# import precip data into R data.frame
precip.boulder <- read.csv(precip_file,
                           header = TRUE,
                           na.strings = 999.99)

# convert to date/time and retain as a new field
precip.boulder$DATE <- as.POSIXct(precip.boulder$DATE,
                                  format="%Y%m%d %H:%M")
                                  # date in the format: YearMonthDay Hour:Minute

# double check structure
str(precip.boulder$DATE)
##  POSIXct[1:14476], format: "1948-08-01 01:00:00" "1948-08-02 15:00:00" ...

# plot the data using ggplot2
precPlot_hourly <- ggplot(precip.boulder, aes(DATE, HPCP)) +   # the variables of interest
      geom_point(stat="identity") +   # create a bar graph
      xlab("Date") + ylab("Precipitation (Inches)") +  # label the x & y axes
      ggtitle("Hourly Precipitation - Boulder Station\n 1948-2013")  # add a title

precPlot_hourly
## Warning: Removed 401 rows containing missing values (geom_point).
```

<img src="{{ site.url }}/images/rfigs/course-materials/earth-analytics/week-4/in-class/2016-12-06-review01-time-series-R/setup-1.png" title="plot precip data using ggplot" alt="plot precip data using ggplot" width="100%" />

# interactive plotting

Note - don't run this in ggplot


```r
library(plotly)

ggplotly(precPlot_hourly)

```

## talk about adding arguments to code chunks



```r
precip.boulder$HPCP_round <- round(precip.boulder$HPCP, digits = 1)

# plot the data using ggplot2
precPlot_hourly_round <- ggplot(precip.boulder, aes(DATE, HPCP_round)) +   # the variables of interest
      geom_point(stat="identity") +   # create a bar graph
      xlab("Date") + ylab("Precipitation (Inches)") +  # label the x & y axes
      ggtitle("Hourly Precipitation - Boulder Station\n 1948-2013")  # add a title

precPlot_hourly_round
## Warning: Removed 401 rows containing missing values (geom_point).
```

<img src="{{ site.url }}/images/rfigs/course-materials/earth-analytics/week-4/in-class/2016-12-06-review01-time-series-R/plot-ggplot-1.png" title="time series plot of precipitation 1948-2013" alt="time series plot of precipitation 1948-2013" width="100%" />

## Time series - Dygraph






```r
# create a basic interactive element
dygraph(discharge_timeSeries) %>% dyRangeSelector()

```

## Factors


```r

new_vector <- c("dog", "cat", "mouse","cat", "mouse", "cat", "mouse")
str(new_vector)
##  chr [1:7] "dog" "cat" "mouse" "cat" "mouse" "cat" ...

new_vector <- factor(new_vector)
str(new_vector)
##  Factor w/ 3 levels "cat","dog","mouse": 2 1 3 1 3 1 3

# set the order
fa_levels <- c("dog", "cat", "mouse")
# reorder factors
new_vector_reordered = factor(new_vector,
           levels = fa_levels)
new_vector_reordered
## [1] dog   cat   mouse cat   mouse cat   mouse
## Levels: dog cat mouse
```
