---
layout: single
title: "Working with Dates & Times in R"
excerpt: "This lesson walks through using the date/time format in R."
authors: ['Leah Wasser', 'Data Carpentry']
lastModified: 2016-12-28
category: [course-materials]
class-lesson: ['hw-ggplot2-r']
permalink: /course-materials/earth-analytics/week-2/date-time-r
nav-title: 'Date / Time Format - R'
week: 2
sidebar:
  nav:
author_profile: false
comments: false
order: 3
---

In the previous tutorial, we converted dates that were stored in character format
to a date class in R. In this tutorial we will convert data that contains both dates
AND times in  R.

may just refer them to http://neondataskills.org/R/time-series-convert-date-time-class-POSIX/

<div class='notice--success' markdown="1">

# Learning Objectives
At the end of this activity, you will be able to:

* Convert column in a dataframe containing dates / times to a date/time object that can be used in R.

## What You Need

You need `R` and `RStudio` to complete this tutorial. Also you should have
an `earth-analytics` directory setup on your computer with a `/data`
directory with it.

* [How to Setup R / RStudio](/course-materials/earth-analytics/week-1/setup-r-rstudio/)
* [Setup your working directory](/course-materials/earth-analytics/week-1/setup-working-directory/)
* [Intro to the R & RStudio Interface](/course-materials/earth-analytics/week-1/intro-to-r-and-rstudio)

</div>


In this tutorial, we will learn how to convert data that contain dates and times
into a date / time format in R.





```r

# import the data
download.file("https://ndownloader.figshare.com/files/7270970",
              "data/week2/precip_2003_2013.csv")


## Show them the code below to assign to NA OR refer to lesson on importing with NA specified.

# import the data
precip_2003_2013 <- read.csv("data/week2/precip_2003_2013.csv")

# have to tell them the data are in the HPCP column
# view the structure of the data. What does the date field look like?

str(precip_2003_2013)
## 'data.frame':	1840 obs. of  9 variables:
##  $ STATION         : chr  "COOP:050843" "COOP:050843" "COOP:050843" "COOP:050843" ...
##  $ STATION_NAME    : chr  "BOULDER 2 CO US" "BOULDER 2 CO US" "BOULDER 2 CO US" "BOULDER 2 CO US" ...
##  $ ELEVATION       : num  1650 1650 1650 1650 1650 ...
##  $ LATITUDE        : num  40 40 40 40 40 ...
##  $ LONGITUDE       : num  -105 -105 -105 -105 -105 ...
##  $ DATE            : chr  "20030101 01:00" "20030201 01:00" "20030202 19:00" "20030202 22:00" ...
##  $ HPCP            : num  0 0 0.2 0.1 0.1 ...
##  $ Measurement.Flag: chr  "g" "g" " " " " ...
##  $ Quality.Flag    : chr  " " " " " " " " ...
# ?strptime

# specify the format
#year date month?

# convert the date field to a data class
# they will need to look at the date to see there are no dashes in it.
precip_2003_2013$DATE <- as.Date(precip_2003_2013$DATE, format = "%Y%d%m")

precip_2003_2013$DATE <- as.Date(precip_2003_2013$DATE, # convert to Date class
                                  format="%Y%m%d %H:%M")
                                  #DATE in the format: YearMonthDay Hour:Minute

# check out min and max data values
min(precip_2003_2013$HPCP, na.rm=T)
## [1] 0
max(precip_2003_2013$HPCP, na.rm=T)
## [1] 999.99

# looks like we need to remove NA values
precip_2003_2013$HPCP[precip_2003_2013$HPCP == 999.99] <- NA

# aggregate the Precipitation (PRECIP) data by DATE
precip_2003_2013_daily <- aggregate(precip_2003_2013$HPCP,   # data to aggregate
	          by=list(precip.boulder$DATE),  # variable to aggregate by
	          FUN=sum,   # take the sum (total) of the precip
          	na.rm=TRUE)  # if there are NA values, ignore them

# add month
precip_2003_2013_daily$month <- format(precip_2003_2013_daily$DATE, "%m")
precip_2003_2013_daily$year <- format(precip_2003_2013_daily$DATE, "%Y")

library(lubridate)
precip_2003_2013_daily$julian <- yday(precip_2003_2013_daily$DATE)
## Error in as.POSIXlt.default(x, tz = tz(x)): do not know how to convert 'x' to class "POSIXlt"


names(precip_2003_2013_daily) <- c("DATE", "PRECIP")

write.csv(precip_2003_2013_daily,
          file="data/week2/precip_2003_2013daily.csv", sep=",")
## Warning in write.csv(precip_2003_2013_daily, file = "data/week2/
## precip_2003_2013daily.csv", : attempt to set 'sep' ignored


# plot the data
ggplot(precip_2003_2013_daily, aes(x=julian, y=PRECIP)) +
  geom_point() + facet_wrap(~ year)
## Error in combine_vars(data, params$plot_env, vars, drop = params$drop): At least one layer must contain all variables used for facetting
```

![ ]({{ site.baseurl }}/images/rfigs/course-materials/earth-analytics/week-2/hw-plot-precip-data/2016-12-06-flood03-date-time-format-R/import-data-1.png)
