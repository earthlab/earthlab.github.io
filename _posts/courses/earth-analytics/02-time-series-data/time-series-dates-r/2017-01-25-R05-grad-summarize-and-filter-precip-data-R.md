---
layout: single
title: "Subset & Aggregate Time Series Precipitation Data in R Using mutate(), group_by() and summarise()"
excerpt: "This lesson introduces the mutate() and group_by() dplyr functions - which allow you to aggregate or summarize time series data by a particular field - in this case you will aggregate data by day to get daily precipitation totals for Boulder during the 2013 floods."
authors: ['Leah Wasser']
modified: '2018-07-30'
category: [courses]
class-lesson: ['time-series-r']
week: 2
permalink: /courses/earth-analytics/time-series-data/aggregate-time-series-data-r/
nav-title: 'Bonus: Summarize & Filter Data'
sidebar:
  nav:
author_profile: false
comments: true
order: 5
course: "earth-analytics"
topics:
  reproducible-science-and-programming: ['RStudio']
  time-series:
  data-exploration-and-analysis: ['data-visualization']
---

{% include toc title="In This Lesson" icon="file-text" %}



Bonus / Graduate activity. In this lesson, you will plot precipitation data in `R`.
However, these data were collected over several decades and sometimes there are
multiple data points per day. The data are also not cleaned. You will find
heading names that may not be meaningful, and other issues with the data.

This lesson shows you what the plots should look like but does not
provide each and every step that you need to process the data.
You have the skills that you need from the other lessons
covered this week!

<div class='notice--success' markdown="1">

## <i class="fa fa-graduation-cap" aria-hidden="true"></i> Learning Objectives

After completing this tutorial, you will be able to:

* Aggregate data by a day in `R`.
* View names and rename columns in a `data.frame`.

### Things You'll Need To Complete This Lesson

Please be sure you have the most current version of `R` and, preferably,
`RStudio` to write your code.

 **R skill level:** Intermediate - To succeed in this tutorial, you will need to
have basic knowledge for use of the `R` software program.

### R Libraries to Install:

* **ggplot2:** `install.packages("ggplot2")`
* **plotly:** `install.packages("dplyr")`

#### Data download

If you haven't already downloaded this data (from the previous lesson), do so now.

[<i class="fa fa-download" aria-hidden="true"></i> Download Week 02 data](https://ndownloader.figshare.com/files/7426738){:data-proofer-ignore='' .btn }

</div>


## Work with Precipitation Data

## R Libraries

To get started, load the `ggplot2` and `dplyr` libraries, set up your working
directory and set `stringsAsFactors` to FALSE using `options()`.







## Import Precipitation Data

You will use the `805333-precip-daily-1948-2013.csv` dataset for this assignment.
in this analysis. This dataset contains the precipitation values collected daily
from the COOP station 050843 in Boulder, CO for 1 January 2003 through 31 December 2013.

Import the data into `R` and then view the data structure.


```r

# import precip data into R data.frame
# be sure to handle NA values!
precip_boulder <- read.csv("data/week-02/precipitation/805333-precip-daily-1948-2013.csv",
                           header = TRUE)

# view first 6 lines of the data
head(precip_boulder)
##       STATION    STATION_NAME ELEVATION LATITUDE LONGITUDE           DATE
## 1 COOP:050843 BOULDER 2 CO US   unknown  unknown   unknown 19480801 01:00
## 2 COOP:050843 BOULDER 2 CO US   unknown  unknown   unknown 19480802 15:00
## 3 COOP:050843 BOULDER 2 CO US   unknown  unknown   unknown 19480803 09:00
## 4 COOP:050843 BOULDER 2 CO US   unknown  unknown   unknown 19480803 14:00
## 5 COOP:050843 BOULDER 2 CO US   unknown  unknown   unknown 19480803 15:00
## 6 COOP:050843 BOULDER 2 CO US   unknown  unknown   unknown 19480804 01:00
##   HPCP Measurement.Flag Quality.Flag
## 1 0.00                g             
## 2 0.05                              
## 3 0.01                              
## 4 0.03                              
## 5 0.03                              
## 6 0.05

# view structure of data
str(precip_boulder)
## 'data.frame':	14476 obs. of  9 variables:
##  $ STATION         : chr  "COOP:050843" "COOP:050843" "COOP:050843" "COOP:050843" ...
##  $ STATION_NAME    : chr  "BOULDER 2 CO US" "BOULDER 2 CO US" "BOULDER 2 CO US" "BOULDER 2 CO US" ...
##  $ ELEVATION       : chr  "unknown" "unknown" "unknown" "unknown" ...
##  $ LATITUDE        : chr  "unknown" "unknown" "unknown" "unknown" ...
##  $ LONGITUDE       : chr  "unknown" "unknown" "unknown" "unknown" ...
##  $ DATE            : chr  "19480801 01:00" "19480802 15:00" "19480803 09:00" "19480803 14:00" ...
##  $ HPCP            : num  0 0.05 0.01 0.03 0.03 0.05 0.02 0.01 0.01 0.01 ...
##  $ Measurement.Flag: chr  "g" " " " " " " ...
##  $ Quality.Flag    : chr  " " " " " " " " ...
```

## About the Data

The structure of the data are similar to what you saw in previous lessons. HPCP
is the total precipitation given in inches, recorded
for the hour ending at the time specified by DATE. There is a designated **missing
data value of 999.99**. Note that hours with no precipitation are not recorded.

The metadata for this file is located in your `week_02` directory:
`PRECIP_HLY_documentation.pdf` file that can be downloaded along with the data.
(Note: as of Sept. 2016, there is a mismatch in the data downloaded and the
documentation. The differences are in the units and missing data value:
inches/999.99 (standard) or millimeters/25399.75 (metric)).

### NoData Values

Next, check out the data. Are there no data values? If so, make sure to adjust your
data import code above to account for no data values. Then determine how many no
data values you have in your dataset.


```r
# plot histogram
# you wanted to explore the data
hist(precip_boulder$HPCP, main ="Are there NA values?")
```

<img src="{{ site.url }}/images/rfigs/courses/earth-analytics/02-time-series-data/time-series-dates-r/2017-01-25-R05-grad-summarize-and-filter-precip-data-R/no-data-values-hist-1.png" title="histogram of data" alt="histogram of data" width="90%" />

```r

precip_boulder <- read.csv("data/week-02/precipitation/805333-precip-daily-1948-2013.csv",
                           header = TRUE, na.strings = 999.99)

```

View histogram without the 999 NA values!


```r
hist(precip_boulder$HPCP,
     main = "This looks better after the reimporting with\n no data values specified",
     xlab = "Precip (inches)", ylab = "Frequency",
     col = "darkorchid4")
```

<img src="{{ site.url }}/images/rfigs/courses/earth-analytics/02-time-series-data/time-series-dates-r/2017-01-25-R05-grad-summarize-and-filter-precip-data-R/plot-hist-1.png" title="histogram without NA values" alt="histogram without NA values" width="90%" />


Next, let's see how many NA values are in your data.


```r
print("how many NA values are there?")
## [1] "how many NA values are there?"
sum(is.na(precip_boulder))
## [1] 401
```

### Convert date and time

Compared to the previous lessons, notice that you now have date & time in your date field.
To deal with both date and time, you use the `as.POSIXct()` method rather than
as.date which you used previously. The syntax to convert to POSIXct is similar to
what you used previously, but now, you will add the hour (H) and minute (M) to the
format argument as follows:

`as.POSIXct(column-you-want-to-convert-here, format="%Y%m%d %H:%M")`


```r

# convert to date/time and retain as a new field
precip_boulder$DATE <- as.POSIXct(precip_boulder$DATE,
                                  format = "%Y%m%d %H:%M")
                                  # date in the format: YearMonthDay Hour:Minute

# double check structure
str(precip_boulder$DATE)
##  POSIXct[1:14476], format: "1948-08-01 01:00:00" "1948-08-02 15:00:00" ...
```


## Plot Precipitation Data

Next, let's have a look at the data. Plot it using `ggplot()`. Format the plot using
the colors, labels, etc. that are most clear and look the best. Your plot colors
and labels doesn't need to be exactly like the one below!

Note the code is hidden as you should know how to create a ggplot plot now!

<img src="{{ site.url }}/images/rfigs/courses/earth-analytics/02-time-series-data/time-series-dates-r/2017-01-25-R05-grad-summarize-and-filter-precip-data-R/plot-precip-hourly-1.png" title="hourly precipitation" alt="hourly precipitation" width="90%" />

## Differences in the Data

Any ideas what might be causing the notable difference in the plotted data through
time? If you can answer this you can get a bonus point for the week!

<img src="{{ site.url }}/images/rfigs/courses/earth-analytics/02-time-series-data/time-series-dates-r/2017-01-25-R05-grad-summarize-and-filter-precip-data-R/plot-precip-hourly-round-1.png" title="hourly precipitation" alt="hourly precipitation" width="90%" />

It is difficult to interpret this plot which spans so many years at such a fine
temporal scale. For your research project, you only need to explore 30 years of data.
Let's do the following:

1. Aggregate the precipitation totals (sum) by day.
2. Subset the data for 30 years (you learned how to do this in a previous lesson).

#### Calculate Daily Total Precipitation with Summarize()

To summarize data by a particular variable or time period, you first create a new column
in your dataset called day. Next, take all of the values (in this case precipitation measured each hour) for each day and add them
using the `sum()` function. You can do all of this efficiently using dplyr mutate() function.

You use the `mutate()` function to add a new column called **day** to a new data.frame c
alled **daily_sum_precip**. Note that you used `as.Date()` to just grab the dates
rather than dates and times which are stored in the POSIX format.



```r
# use dplyr and mutate to add a day column to your data
daily_sum_precip <- precip_boulder %>%
  mutate(day = as.Date(DATE, format = "%Y-%m-%d"))

# let's look at the new column
head(daily_sum_precip$day)
## [1] "1948-08-01" "1948-08-02" "1948-08-03" "1948-08-03" "1948-08-03"
## [6] "1948-08-04"
```

<img src="{{ site.url }}/images/rfigs/courses/earth-analytics/02-time-series-data/time-series-dates-r/2017-01-25-R05-grad-summarize-and-filter-precip-data-R/plot-daily-1.png" title="Daily precip plot" alt="Daily precip plot" width="90%" />

Next you `summarize()` the precipitation column (total_precip) - grouped by day.
What this means is that you ADD UP all of the values for each day to get a grand
total amount of precipitation each day.



```r
# use dplyr
daily_sum_precip <- precip_boulder %>%
  mutate(day = as.Date(DATE, format="%Y-%m-%d")) %>%
  group_by(day) %>% # group by the day column
  summarise(total_precip=sum(HPCP)) %>%  # calculate the SUM of all precipitation that occurred on each day
  na.omit()

# how large is the resulting data frame?
nrow(daily_sum_precip)
## [1] 4576

# view the results
head(daily_sum_precip)
## # A tibble: 6 x 2
##   day        total_precip
##   <date>            <dbl>
## 1 1948-08-01       0     
## 2 1948-08-02       0.05  
## 3 1948-08-03       0.0700
## 4 1948-08-04       0.14  
## 5 1948-08-06       0.02  
## 6 1948-08-14       0.03

# view column names
names(daily_sum_precip)
## [1] "day"          "total_precip"
```


Now plot the daily data.

<img src="{{ site.url }}/images/rfigs/courses/earth-analytics/02-time-series-data/time-series-dates-r/2017-01-25-R05-grad-summarize-and-filter-precip-data-R/daily-prec-plot-1.png" title="Daily precipitation for boulder" alt="Daily precipitation for boulder" width="90%" />


Finally, plot a temporal subset of the data from Jan-October 2013. You learned how to
do this in the previous lessons.


Now you can easily see the dramatic rainfall event in mid-September!

<i class="fa fa-star"></i> **R tip:** If you are using a date-time class, instead
of just a date class, you need to use `scale_x_datetime()`.
{: .notice--success}

#### Subset the Data

If you wanted to, you could subset this data set using the same code that you used
previously to subset! An example of the subsetted plot is below.

<img src="{{ site.url }}/images/rfigs/courses/earth-analytics/02-time-series-data/time-series-dates-r/2017-01-25-R05-grad-summarize-and-filter-precip-data-R/subset-data-1.png" title="final precip plot daily sum" alt="final precip plot daily sum" width="90%" />

<div class="notice--info" markdown="1">

## Additional Resources

* <a href="http://stackoverflow.com/questions/11395927/how-to-subset-data-frame-by-weeks-and-then-sum" target="_blank">How to subset data by weeks</a>
</div>
