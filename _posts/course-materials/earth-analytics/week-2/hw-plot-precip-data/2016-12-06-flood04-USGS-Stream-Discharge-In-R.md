---
layout: single
title: "Plot Stream Discharge Data in R"
excerpt: "This lesson walks through the steps need to download and visualize
USGS Stream Discharge data in R to better understand the drivers and impacts of
the 2013 Colorado floods."
authors: ['Leah Wasser', 'NEON Data Skills', 'Mariela Perignon']
modified: '2017-01-31'
category: [course-materials]
class-lesson: ['hw-ggplot2-r']
week: 2
permalink: /course-materials/earth-analytics/week-2/plot-stream-discharge-timeseries-r/
nav-title: 'Plot Stream Discharge Data R'
sidebar:
  nav:
author_profile: false
comments: true
order: 4
---

{% include toc title="In This Lesson" icon="file-text" %}

In this data lesson, we explore and visualize stream discharge time series
data collected by the United States Geological Survey (USGS). You will use everything
that you learned in the previous lessons to create your plots. You will use these
plots in the report that you submit for your homework.

Note: this page just shows you what the plots should look like. You will need
to use your programming skills to create the plots!

<div class='notice--success' markdown="1">

## <i class="fa fa-graduation-cap" aria-hidden="true"></i> Learning Objectives

After completing this tutorial, you will be able to:

* Plot USGS Stream Discharge time series data in `R`.

## <i class="fa fa-check-square-o fa-2" aria-hidden="true"></i> What you need

You need `R` and `RStudio` to complete this tutorial. Also you should have
an `earth-analytics` directory setup on your computer with a `/data`
directory with it.

* [How to Setup R / RStudio](/course-materials/earth-analytics/week-1/setup-r-rstudio/)
* [Setup your working directory](/course-materials/earth-analytics/week-1/setup-working-directory/)
* [Intro to the R & RStudio Interface](/course-materials/earth-analytics/week-1/intro-to-r-and-rstudio)

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
<a href="http://neondataskills.org/images/disturb-events-co13/USGS-Peak-discharge.gif">
<img src="http://neondataskills.org/images/disturb-events-co13/USGS-Peak-discharge.gif" alt="USGS stream discharge boulder creek plot"></a>
<figcaption>
The USGS tracks stream discharge through time at locations across the United
States. Note the pattern observed in the plot above. The peak recorded discharge
value in 2013 was significantly larger than what was observed in other years.
Source: <a href="http://nwis.waterdata.usgs.gov/usa/nwis/peak/?site_no=06730200" target="_blank"> USGS, National Water Information System. </a>
</figcaption>
</figure>


## Work with USGS Stream Gage Data

Let's begin by loading our libraries and setting our working directory.


```r
# set your working directory
# setwd("working-dir-path-here")

# load packages
library(ggplot2) # create efficient, professional plots
library(dplyr) # data manipulation

# set strings as factors to false
options(stringsAsFactors = FALSE)
```

##  Import USGS Stream Discharge Data Into R

Let's first import our data using the `read.csv()` function.



```r
discharge <- read.csv("data/week2/discharge/06730200-discharge-daily-1986-2013.csv",
                      header=TRUE)

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

Now that the data are imported, plot disValue (discharge value) over time.
To do this, you will need to use
everything that you learned in the previous lessons.

Hint: when converting the date, take a close look at the format of the date -
is the year 4 digits (including the century) or just 2? Use `?strptime` to figure
out what format elements you'll need to include to get the date right.

</div>





Your plot should look something like the one below:

![plot of discharge vs time]({{ site.url }}/images/rfigs/course-materials/earth-analytics/week-2/hw-plot-precip-data/2016-12-06-flood04-USGS-Stream-Discharge-In-R/plot-flood-data-1.png)

<div class="notice--warning" markdown="1">

## <i class="fa fa-pencil-square-o" aria-hidden="true"></i> Challenge

Similar to the previous lesson, take the cleaned discharge data that you just
plotted and subset it to the time span
of 2013-08-15 to 2013-10-15. Use `dplyr` pipes and the `filter()` function
to perform the subset.

Plot the data with `ggplot()`. Your plot should look like the one below.
</div>




![ggplot subsetted discharge data]({{ site.url }}/images/rfigs/course-materials/earth-analytics/week-2/hw-plot-precip-data/2016-12-06-flood04-USGS-Stream-Discharge-In-R/plot-challenge-1.png)
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
<a href="http://help.waterdata.usgs.gov/faq/automated-retrievals#RT">
Read more here about API downloads of USGS data</a>.

</div>
