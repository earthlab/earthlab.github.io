---
layout: single
title: "Homework Challenge: Plot USGS Stream Discharge Data in R"
excerpt: "This lesson illustrated what your final stream discharge homework
plots should look like for the week. Use all of the skills that you've learned in the previous lessons to complete it."
authors: ['Leah Wasser']
modified: '2018-01-10'
category: [courses]
class-lesson: ['time-series-r']
week: 2
permalink: /courses/earth-analytics/time-series-data/plot-stream-discharge-timeseries-challenge-r/
nav-title: 'Homework example: Stream Discharge'
sidebar:
  nav:
author_profile: false
comments: true
order: 4
course: "earth-analytics"
topics:
  reproducible-science-and-programming: ['RStudio']
  time-series:
  data-exploration-and-analysis: ['data-visualization']
---


{% include toc title="In This Lesson" icon="file-text" %}



In this data lesson, you explore and visualize stream discharge time series
data collected by the United States Geological Survey (USGS). You will use everything
that you learned in the previous lessons to create your plots. You will use these
plots in the report that you submit for your homework.

Note: this page just shows you what the plots should look like. You will need
to use your programming skills to create the plots!

<div class='notice--success' markdown="1">

## <i class="fa fa-graduation-cap" aria-hidden="true"></i> Learning Objectives

After completing this tutorial, you will be able to:

* Plot USGS Stream Discharge time series data in `R`

## <i class="fa fa-check-square-o fa-2" aria-hidden="true"></i> What You Need

You need `R` and `RStudio` to complete this tutorial. Also you should have
an `earth-analytics` directory set up on your computer with a `/data`
directory with it.

* [How to set up R / RStudio](/courses/earth-analytics/document-your-science/setup-r-rstudio/)
* [Set up your working directory](/courses/earth-analytics/document-your-science/setup-working-directory/)
* [Intro to the R & RStudio Interface](/courses/earth-analytics/document-your-science/intro-to-r-and-rstudio)

### R Libraries to Install:

* **ggplot2:** `install.packages("ggplot2")`
* **dplyr:** `install.packages("dplyr")`

If you haven't already downloaded this data (from the previous lesson), do so now.

[<i class="fa fa-download" aria-hidden="true"></i> Download Week 2 Data](https://ndownloader.figshare.com/files/7426738){:data-proofer-ignore='' .btn }

</div>

## About the Data - USGS Stream Discharge Data

The USGS has a distributed network of aquatic sensors located in streams across
the United States. This network monitors a suit of variables that are important
to stream morphology and health. One of the metrics that this sensor network
monitors is **Stream Discharge**, a metric which quantifies the volume of water
moving down a stream. Discharge is an ideal metric to quantify flow, which
increases significantly during a flood event.

> As defined by USGS: Discharge is the volume of water moving down a stream or
> river per unit of time, commonly expressed in cubic feet per second or gallons
> per day. In general, river discharge is computed by multiplying the area of
> water in a channel cross section by the average velocity of the water in that
> cross section.
>
> <a href="http://water.usgs.gov/edu/streamflow2.html" target="_blank">
Read more about stream discharge data collected by USGS.</a>

<figure>
<a href="{{ site.url }}/images/courses/earth-analytics/week-02/USGS-peak-discharge.gif">
<img src="{{ site.url }}/images/courses/earth-analytics/week-02/USGS-peak-discharge.gif" alt="Plot of stream discharge from the USGS boulder creek stream gage"></a>
<figcaption>
The USGS tracks stream discharge through time at locations across the United
States. Note the pattern observed in the plot above. The peak recorded discharge
value in 2013 was significantly larger than what was observed in other years.
Source: <a href="http://nwis.waterdata.usgs.gov/usa/nwis/peak/?site_no=06730200" target="_blank"> USGS, National Water Information System. </a>
</figcaption>
</figure>

As you can imagine, stream gages can be sensitive to high flows and in the case of
an extreme event like a flood are sometimes damaged. However, during the 2013 floods,
one stream gage in Boulder, Colorado remained in tact. USGS stream gauge 06730200
located on Boulder Creek at North 75th St. collected data that you will use in
the lesson below!




## Work with USGS Stream Gage Data

Let's begin by loading your libraries and setting your working directory.


```r
# set your working directory
# setwd("working-dir-path-here")

# load packages
library(ggplot2) # create efficient, professional plots
library(dplyr) # data manipulation

# set strings as factors to false
options(stringsAsFactors = FALSE)
```

##  Import USGS Stream Discharge Data into R

Let's first import your data using the `read.csv()` function.



```r
discharge <- read.csv("data/week-02/discharge/06730200-discharge-daily-1986-2013.csv",
                      header = TRUE)

# view first 6 lines of data
head(discharge)
##   agency_cd site_no datetime disValue qualCode
## 1      USGS 6730200  10/1/86       30        A
## 2      USGS 6730200  10/2/86       30        A
## 3      USGS 6730200  10/3/86       30        A
## 4      USGS 6730200  10/4/86       30        A
## 5      USGS 6730200  10/5/86       30        A
## 6      USGS 6730200  10/6/86       30        A
```


<div class="notice--warning" markdown="1">

## <i class="fa fa-pencil-square-o" aria-hidden="true"></i> Challenge

Now that the data are imported, plot `disValue` (discharge value) over time.
To do this, you will need to use everything that you learned in the previous lessons.

Hint: when converting the date, take a close look at the format of the date -
is the year 4 digits (including the century) or just 2? Use `?strptime` to figure
out what format elements you'll need to include to get the date right.

</div>





Your plot should look something like the one below:

<img src="{{ site.url }}/images/rfigs/courses/earth-analytics/02-time-series-data/time-series-dates-r/2017-01-25-R04-homework-example-USGS-stream-discharge-data-r/plot-flood-data-1.png" title="plot of discharge vs time" alt="plot of discharge vs time" width="90%" />

<div class="notice--warning" markdown="1">

## <i class="fa fa-pencil-square-o" aria-hidden="true"></i> Challenge

Similar to the previous lesson, take the cleaned discharge data that you just
plotted and subset it to the time span
of 2013-08-15 to 2013-10-15. Use `dplyr` pipes and the `filter()` function
to perform the subset.

Plot the data with `ggplot()`. Your plot should look like the one below.
</div>




<img src="{{ site.url }}/images/rfigs/courses/earth-analytics/02-time-series-data/time-series-dates-r/2017-01-25-R04-homework-example-USGS-stream-discharge-data-r/plot-challenge-1.png" title="ggplot subsetted discharge data" alt="ggplot subsetted discharge data" width="90%" />
<div class="notice--info" markdown="1">

## Additional Resources

Additional information on USGS streamflow measurements and data:

* <a href="http://nwis.waterdata.usgs.gov/usa/nwis/peak/" target="_blank">Find peak streamflow for other locations</a>
* <a href="http://water.usgs.gov/edu/measureflow.html" target="_blank">USGS: How streamflow is measured</a>
* <a href="http://water.usgs.gov/edu/streamflow2.html" target="_blank">USGS: How streamflow is measured, Part II</a>
* <a href="http://pubs.usgs.gov/fs/2005/3131/FS2005-3131.pdf" target="_blank"> USGS National Streamflow Information Program Fact Sheet </a>

## API Data Access

USGS data can be downloaded via an API using a command line interface. This is
particularly useful if you want to request data from multiple sites or build the
data request into a script.
<a href="http://help.waterdata.usgs.gov/faq/automated-retrievals#RT" target="_blank" data-proofer-ignore=''>
Read more here about API downloads of USGS data</a>.

</div>
