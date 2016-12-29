---
layout: single
title: "Visualize Stream Discharge Data in R - 2013 Colorado Floods"
excerpt: "This lesson walks through the steps need to download and visualize
USGS Stream Discharge data in R to better understand the drivers and impacts of
the 2013 Colorado floods."
authors: ['Leah Wasser', 'NEON Data Skills', 'Mariela Perignon']
lastModified: 2016-12-28
category: [course-materials]
class-lesson: ['hw-ggplot2-r']
week: 2
permalink: /course-materials/earth-analytics/week-2/co-floods-USGS-stream-discharge-r
nav-title: 'Stream Discharge Data R'
sidebar:
  nav:
author_profile: false
comments: false
order: 5
---

Several factors contributed to the extreme flooding that occurred in Boulder,
Colorado in 2013. In this data activity, we explore and visualize the data for
stream discharge data collected by the United States Geological Survey (USGS).

<div class='notice--success' markdown="1">

### Learning Objectives
After completing this tutorial, you will be able to:

* Plot USGS Stream Discharge time series data in `R`.

### Things You'll Need To Complete This Lesson

You need `R` and `RStudio` to complete this tutorial. Also you should have
an `earth-analytics` directory setup on your computer with a `/data`
directory with it.

* [How to Setup R / RStudio](/course-materials/earth-analytics/week-1/setup-r-rstudio/)
* [Setup your working directory](/course-materials/earth-analytics/week-1/setup-working-directory/)
* [Intro to the R & RStudio Interface](/course-materials/earth-analytics/week-1/intro-to-r-and-rstudio)

### R Libraries to Install:

* **ggplot2:** `install.packages("ggplot2")`

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
<img src="http://neondataskills.org/images/disturb-events-co13/USGS-Peak-discharge.gif"></a>
<figcaption>
The USGS tracks stream discharge through time at locations across the United
States. Note the pattern observed in the plot above. The peak recorded discharge
value in 2013 was significantly larger than what was observed in other years.
Source: <a href="http://nwis.waterdata.usgs.gov/usa/nwis/peak/?site_no=06730200" target="_blank"> USGS, National Water Information System. </a>
</figcaption>
</figure>


## Work with Stream Gauge Data

We will use `ggplot2` to  plot our data.


```r
# set your working directory
# setwd("working-dir-path-here")

# load packages
library(ggplot2) # create efficient, professional plots
library(plotly) # create cool interactive plots

# set strings as factors to false
options(stringsAsFactors = FALSE)
```

##  Import USGS Stream Discharge Data Into R

Let's first import our data using the `read.csv()` function.



```r

discharge <- read.csv("data/flood-co-2013/discharge/06730200-Discharge_Daily_1986-2013.csv",
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

## View Data Structure

Next, let's have a look at the structure of our data.


```r
# view structure of data
str(discharge)
## 'data.frame':	9954 obs. of  5 variables:
##  $ agency_cd: chr  "USGS" "USGS" "USGS" "USGS" ...
##  $ site_no  : int  6730200 6730200 6730200 6730200 6730200 6730200 6730200 6730200 6730200 6730200 ...
##  $ datetime : chr  "10/1/86" "10/2/86" "10/3/86" "10/4/86" ...
##  $ disValue : num  30 30 30 30 30 30 30 30 30 31 ...
##  $ qualCode : chr  "A" "A" "A" "A" ...

# view class of the disValue column
class(discharge$disValue)
## [1] "numeric"

# view class of the datetime column
class(discharge$datetime)
## [1] "character"
```


### Convert Date to R Date Class

However, the time stamp field, `datetime` is a `character` class.

To work with and efficiently plot time series data, it is best to convert date
and/or time data to a date/time class.

To learn more about different date/time classes, see the
<a href="http://www.neondataskills.org/R/time-series-convert-date-time-class-POSIX/" target="_blank" >
*Dealing With Dates & Times in R - as.Date, POSIXct, POSIXlt*</a> tutorial.

** note they will have to use %y lowercase instead of upper case.


```r

# convert to date class -
discharge$datetime <- as.Date(discharge$datetime, format="%m/%d/%y")

# recheck data structure
str(discharge)
## 'data.frame':	9954 obs. of  5 variables:
##  $ agency_cd: chr  "USGS" "USGS" "USGS" "USGS" ...
##  $ site_no  : int  6730200 6730200 6730200 6730200 6730200 6730200 6730200 6730200 6730200 6730200 ...
##  $ datetime : Date, format: "1986-10-01" "1986-10-02" ...
##  $ disValue : num  30 30 30 30 30 30 30 30 30 31 ...
##  $ qualCode : chr  "A" "A" "A" "A" ...
```

### No Data Values
Next, let's query our data to check whether there are no data values in
it.  The metadata associated with the data doesn't specify what the values would
be, `NA` or `-9999` are common values


```r
# check total number of NA values
sum(is.na(discharge$datetime))
## [1] 0

# view distribution of values
hist(discharge$disValue)
```

![ ]({{ site.baseurl }}/images/rfigs/course-materials/earth-analytics/week-2/hw-plot-precip-data/2016-12-06-flood05-USGS-Stream-Discharge-In-R/no-data-values-1.png)

```r
summary(discharge$disValue)
##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
##    0.87   32.00   54.00   93.71  108.00 4770.00
```

The min and max data values to not appear to have any NA values nor any values
that are typically used to represent NoData (e.g. -9999). It's safe to assume
our data don't have NA values.

## Plot The Data

Finally, we are ready to plot our data. We will use `ggplot` from the `ggplot2`
package to create our plot.


```r
# check out our date range
min(discharge$datetime)
## [1] "1986-10-01"
max(discharge$datetime)
## [1] "2013-12-31"

stream_discharge_30yrs  <- ggplot(discharge, aes(datetime, disValue)) +
              geom_point() +
              ggtitle("Stream Discharge (CFS) - Boulder Creek, 1986-2016") +
              xlab("Year") + ylab("Discharge (CFS)")

stream_discharge_30yrs
```

![ ]({{ site.baseurl }}/images/rfigs/course-materials/earth-analytics/week-2/hw-plot-precip-data/2016-12-06-flood05-USGS-Stream-Discharge-In-R/plot-flood-data-1.png)

#### Questions:

1. What patterns do you see in the data?
1. Why might there be an increase in discharge during that time of year?


## Plot Data Time Subsets With ggplot

We can plot a subset of our data within `ggplot()` by specifying the start and
end times (in a `limits` object) for the x-axis with `scale_x_datetime`. Let's
plot data for the months directly around the Boulder flood: August 15 2013 -
October 15 2013.


```r

# Define Start and end times for the subset as R objects that are the time class
startTime <- as.Date("2013-08-15")
endTime <- as.Date("2013-10-15")

# create a start and end time R object
start_end <- c(startTime,endTime)
start_end
## [1] "2013-08-15" "2013-10-15"

# plot the data - Aug 15-October 15
stream.discharge_3mo <- ggplot(discharge,
          aes(datetime,disValue)) +
          geom_point() +
          scale_x_date(limits=start_end) +
          xlab("Month / Day") + ylab("Discharge (Cubic Feet per Second)") +
          ggtitle("Daily Stream Discharge (CFS) for Boulder Creek 8/15 - 10/15 2013")

stream.discharge_3mo
## Warning: Removed 9892 rows containing missing values (geom_point).
```

![ ]({{ site.baseurl }}/images/rfigs/course-materials/earth-analytics/week-2/hw-plot-precip-data/2016-12-06-flood05-USGS-Stream-Discharge-In-R/define-time-subset-1.png)

We get a warning message because we are "ignoring" lots of the data in the
data set.


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
