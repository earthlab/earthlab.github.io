---
layout: single
title: "Work With Precipitation Data in R: 2013 Colorado Floods"
excerpt: "Learn why documentation is important when analyzing data by evaluating someone elses report on the Colorado floods."
authors: ['Leah Wasser']
modified: '2018-01-10'
category: [courses]
class-lesson: ['co-floods-1-intro']
permalink: /courses/earth-analytics/document-your-science/data-driven-reports/
nav-title: 'Data Driven Report'
week: 1
sidebar:
  nav:
author_profile: false
comments: true
course: "earth-analytics"
order: 2
topics:
  earth-science: ['flood-erosion']
  time-series:
---


{% include toc title="In this lesson" icon="file-text" %}

In this lesson you will review a data driven report created by a "fictitious" colleague on the 2013 floods.

<div class='notice--success' markdown='1'>

## <i class="fa fa-graduation-cap" aria-hidden="true"></i> Learning Objectives

After completing this tutorial, you will be able to:

* List some of the components of a project that make it more easily reusable
(reproducible) to you when working with other people.


## <i class="fa fa-check-square-o fa-2" aria-hidden="true"></i> What You Need

You will need a computer with internet access to complete this activity.

</div>

## A Data Report

Your colleague put together the very informative data report below. The topic of
the report is the 2013 Colorado floods. Examine the report. Then answer the questions
below.

### What do you know about the data used to generate the report?

1. What sources of data were used to create the plots?
1. How were the data processed?
1. What units are the precipitation data in?
1. Where were the data collected and how?

### You would like to know about who contributed to the report and when.

1. How did your colleague generate this report? When was it last updated?
1. Who contributed to this report?

### You are tasked with updating the report. Will that be difficult?

1. You'd like to make some changes to the report - can you do that easily? If you
wanted to make changes, what process and tools would you use to make those changes? Do you have everything that you need?

Last but not least...

1. Create a list of the things that would make editing this report easier.

***

## My Report - 2013 Colorado Flood Data

Precipitation Data

When a weather front passed through Colorado in 2013, a lot of rain
impacted Colorado. See below.



Some terrain data.


```r
lidar_dsm <- raster(x = "data/week-03/BLDR_LeeHill/pre-flood/lidar/pre_DSM.tif")

# plot raster data
plot(lidar_dsm,
     main = "Lidar Digital Surface Model (DSM)\n Study area map")
```

<img src="{{ site.url }}/images/rfigs/courses/earth-analytics/01-document-your-science/use-data-for-science/2016-12-06-floods-02-data-driven-report-r/plot-raster-1.png" title="Study area map" alt="Study area map" width="90%" />


```r
# download.file(url = "https://ndownloader.figshare.com/files/7270970",
#              "data/week-01/805325-precip_daily_2003-2013.csv")

# import precip data into R data.frame
precip_boulder <- read.csv("data/week-01/805325-precip_daily_2003-2013.csv",
                           header = TRUE)


# convert to date/time and retain as a new field
precip_boulder$DateTime <- as.POSIXct(precip_boulder$DATE,
                                  format = "%Y%m%d %H:%M")

# assign NoData values to NA
precip_boulder$HPCP[precip_boulder$HPCP == 999.99] <- NA

```

<img src="{{ site.url }}/images/rfigs/courses/earth-analytics/01-document-your-science/use-data-for-science/2016-12-06-floods-02-data-driven-report-r/daily-summaries-1.png" title="plot 1" alt="plot 1" width="90%" />

## Fall 2013 Precipitation

Let's check out the data for a few months.


<img src="{{ site.url }}/images/rfigs/courses/earth-analytics/01-document-your-science/use-data-for-science/2016-12-06-floods-02-data-driven-report-r/subset-data-1.png" title="plot 2 precip" alt="plot 2 precip" width="90%" />


<img src="{{ site.url }}/images/rfigs/courses/earth-analytics/01-document-your-science/use-data-for-science/2016-12-06-floods-02-data-driven-report-r/all-boulder-station-data-1.png" title="plot 3 discharge" alt="plot 3 discharge" width="90%" />
