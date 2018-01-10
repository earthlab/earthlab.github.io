---
layout: single
title: "Summarize Time Series Data by Month or Year Using Tidyverse Pipes in R"
excerpt: "Learn how to summarize time series data by day, month or year with Tidyverse pipes in R."
authors: ['Leah Wasser']
modified: '2018-01-10'
category: [courses]
class-lesson: ['time-series-r']
permalink: /courses/earth-analytics/time-series-data/summarize-time-series-by-month-in-r/
nav-title: 'Summarize Time Series Data'
week: 2
sidebar:
  nav:
author_profile: false
comments: true
order: 3
course: "earth-analytics"
topics:
  reproducible-science-and-programming: ['RStudio']
  time-series:
  data-exploration-and-analysis: ['data-visualization']
---

{% include toc title="In This Lesson" icon="file-text" %}



In this lesson, you will learn about time series data by various time units
including month, day and year.

<div class='notice--success' markdown="1">

## <i class="fa fa-graduation-cap" aria-hidden="true"></i> Learning Objectives

After completing this tutorial, you will be able to:

* Summarize time series data by a particular time unit (e.g. month to year, day to month, using pipes etc.).
* Use `dplyr` pipes to manipulate data in `R`.

## <i class="fa fa-check-square-o fa-2" aria-hidden="true"></i> What You Need

You need `R` and `RStudio` to complete this tutorial. Also you should have
an `earth-analytics` directory set up on your computer with a `/data`
directory within it.

* [How to set up R / RStudio](/courses/earth-analytics/document-your-science/setup-r-rstudio/)
* [Set up your working directory](/courses/earth-analytics/document-your-science/setup-working-directory/)
* [Intro to the R & RStudio Interface](/courses/earth-analytics/document-your-science/intro-to-r-and-rstudio)

### R Libraries to Install:

* **ggplot2:** `install.packages("ggplot2")`
* **dplyr:** `install.packages("dplyr")`
* **lubridate:** `install.packages("lubridate")`


[<i class="fa fa-download" aria-hidden="true"></i> Download Week 2 Data](https://ndownloader.figshare.com/files/7426738){:data-proofer-ignore='' .btn }

</div>


## Get Started with Time Series Data
To begin, load the `ggplot2` and `dplyr` libraries. Also, set your
working directory. Finally, set `stringsAsFactors` to `FALSE` globally using
`options(stringsAsFactors = FALSE)`.




```r
# set your working directory to the earth-analytics directory
# setwd("working-dir-path-here")

# load packages
library(ggplot2)
library(dplyr)
library(lubridate)

# set strings as factors to false
options(stringsAsFactors = FALSE)
```

## Import Precipitation Time Series Data

You will use the same precipitation data that you used in the last lesson. The
data cover the time span between 1 January 2003 through 31 December 2013.
You have a single data point for each day in this dataset. However you are interested
in summary values per MONTH instead of per day.

To begin, use `read.csv()` to import the `.csv` file as you did in the last lesson.


```r
# download the data
# download.file(url = "https://ndownloader.figshare.com/files/7283285",
#              destfile = "data/week-02/805325-precip-dailysum_2003-2013.csv",
#              method = "libcurl")

# import data
boulder_daily_precip <- read.csv("data/week-02/precipitation/805325-precip-dailysum-2003-2013.csv",
         header = TRUE,
         na.strings = 999.99)

# view structure of data
str(boulder_daily_precip)
## 'data.frame':	792 obs. of  9 variables:
##  $ DATE        : chr  "1/1/03" "1/5/03" "2/1/03" "2/2/03" ...
##  $ DAILY_PRECIP: num  0 NA 0 NA 0.4 0.2 0.1 0.1 0 0 ...
##  $ STATION     : chr  "COOP:050843" "COOP:050843" "COOP:050843" "COOP:050843" ...
##  $ STATION_NAME: chr  "BOULDER 2 CO US" "BOULDER 2 CO US" "BOULDER 2 CO US" "BOULDER 2 CO US" ...
##  $ ELEVATION   : num  1650 1650 1650 1650 1650 ...
##  $ LATITUDE    : num  40 40 40 40 40 ...
##  $ LONGITUDE   : num  -105 -105 -105 -105 -105 ...
##  $ YEAR        : int  2003 2003 2003 2003 2003 2003 2003 2003 2003 2003 ...
##  $ JULIAN      : int  1 5 32 33 34 36 37 38 41 49 ...

# are there any unusual / No data values?
summary(boulder_daily_precip$DAILY_PRECIP)
##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max.    NA's 
##  0.0000  0.1000  0.1000  0.2478  0.3000  9.8000       4
```

As you did in the previous lesson, let's convert the `DATE` column to a date class.
In the previous lesson, you performed this step by directly assigning the column

`boulder_daily_precip$DATE`

You can use pipes ( `%>%` ) to achieve the same thing. The `mutate()` function
in `dplyr` is used to

1. reassign a column value / format OR
2. create a new column

The syntax for the mutate function is as follows:

`mutate(column_name = what_you_want_to_store_in_this_column)`

So if you want to create a new date column contain the information from the
existing DATE column you'd write

`mutate(new_date = DATE)`

In this case you will reassign the date column to the values populated by
the as.Date() function with converts the class of the column to a date class.
Like this:

`mutate(DATE = as.Date(DATE, format = "%m/%d/%y"))`

Because you are using a pipe you need to reassign your `data.frame` output to the
`boulder_daily_precip` object.



```r
# Create a new data.frame with the newly formatted date field
boulder_daily_precip <- boulder_daily_precip %>%
  mutate(DATE = as.Date(DATE, format = "%m/%d/%y"))
```

Finally, you plot the data using `ggplot()`.
In the example below, you send the `data.frame` directly to `ggplot` using a
pipe too.


```r

# plot the data using ggplot2 and pipes
boulder_daily_precip %>%
ggplot(aes(x = DATE, y = DAILY_PRECIP)) +
      geom_point(color = "darkorchid4") +
      labs(title = "Precipitation - Boulder, Colorado",
           subtitle = "The data frame is sent to the plot using pipes",
           y = "Daily precipitation (inches)",
           x = "Date") + theme_bw(base_size = 15)
```

<img src="{{ site.url }}/images/rfigs/courses/earth-analytics/02-time-series-data/time-series-dates-r/2017-01-25-R03-summarize-time-series-data-by-month-or-day-R/plot-precip-hourly-pipes-1.png" title="precip plot w fixed dates" alt="precip plot w fixed dates" width="90%" />

The code below created the same plot as above.


```r

# plot the data using ggplot2
ggplot(data=boulder_daily_precip, aes(x = DATE, y = DAILY_PRECIP)) +
      geom_point(color = "darkorchid4") +
      labs(title = "Precipitation - Boulder, Colorado",
           subtitle = "Note using pipes",
           y = "Daily precipitation (inches)",
           x = "Date") + theme_bw(base_size = 15)
```

<img src="{{ site.url }}/images/rfigs/courses/earth-analytics/02-time-series-data/time-series-dates-r/2017-01-25-R03-summarize-time-series-data-by-month-or-day-R/plot-precip-hourly-1.png" title="precip plot w fixed dates" alt="precip plot w fixed dates" width="90%" />

### Create Facets

Notice in your data you have a "year" column. You can quickly
plot data by year using `facet_wrap()`. When you use facet wrap, you select
a column in your data that you wish to "group by". In this case, you have a
"YEAR" column that you can use to plot. To plot by year you add the following
line to your ggplot code:

`facet_wrap( ~ YEAR )`


```r

# plot the data using ggplot2 and pipes
boulder_daily_precip %>%
  na.omit() %>%
ggplot(aes(x = DATE, y = DAILY_PRECIP)) +
      geom_point(color = "darkorchid4") +
      facet_wrap( ~ YEAR ) +
      labs(title = "Precipitation - Boulder, Colorado",
           subtitle = "Use facets to plot by a variable - year in this case",
           y = "Daily precipitation (inches)",
           x = "Date") + theme_bw(base_size = 15) +
     # adjust the x axis breaks
     scale_x_date(date_breaks = "5 years", date_labels = "%m-%Y")
```

<img src="{{ site.url }}/images/rfigs/courses/earth-analytics/02-time-series-data/time-series-dates-r/2017-01-25-R03-summarize-time-series-data-by-month-or-day-R/facet-plot-1.png" title="create facets using facet_wrap" alt="create facets using facet_wrap" width="90%" />

Your plot looks ok but there is a problem with the x axis. Each date is unique
to that particular `YEAR`. You need to plot a variable on the x axis that is the same
across all years for the plots to be comparable. One option is the day # of the year
sometimes referred to as Julian Day or day of year. Lucky for us, you have a
column called `JULIAN` in your data. This column contains the day of the year.
Create the same plot however this time, use the `JULIAN` column for the x axis
instead of `DATE`.


```r
# plot the data using ggplot2 and pipes
boulder_daily_precip %>%
ggplot(aes(x = JULIAN, y = DAILY_PRECIP)) +
      geom_point(color = "darkorchid4") +
      facet_wrap( ~ YEAR, ncol = 3) +
      labs(title = "Daily Precipitation - Boulder, Colorado",
           subtitle = "Data plotted by year",
           y = "Daily Precipitation (inches)",
           x = "Day of Year") + theme_bw(base_size = 15)
```

<img src="{{ site.url }}/images/rfigs/courses/earth-analytics/02-time-series-data/time-series-dates-r/2017-01-25-R03-summarize-time-series-data-by-month-or-day-R/facet-plot2-1.png" title="create facets using facet_wrap" alt="create facets using facet_wrap" width="90%" />


<div class="notice--warning" markdown="1">

## <i class="fa fa-pencil-square-o" aria-hidden="true"></i> Challenge

Create a subset plot that only shows data for Julian day range: 230-290. This
date range is approximately the end of August - Oct (2013).


</div>


```r
# subset 2 months around flood
boulder_daily_precip %>%
  filter(JULIAN > 230 & JULIAN < 290) %>%
  ggplot(aes(x = JULIAN, y = DAILY_PRECIP)) +
      geom_bar(stat = "identity", fill = "darkorchid4") +
      facet_wrap( ~ YEAR, ncol = 3) +
      labs(title = "Daily Precipitation - Boulder, Colorado",
           subtitle = "Data plotted by year",
           y = "Daily precipitation (inches)",
           x = "Date") + theme_bw(base_size = 15)
```

<img src="{{ site.url }}/images/rfigs/courses/earth-analytics/02-time-series-data/time-series-dates-r/2017-01-25-R03-summarize-time-series-data-by-month-or-day-R/subset-data-1.png" title="plot of chunk subset-data" alt="plot of chunk subset-data" width="90%" />

## Summarize Data by Month

In the example above, you plotted your data plot by day of the year. This column,
however already existed in your data. However,
what if you don't have these columns in your data?

Next, you will create a month column in the data which will allow us to summarize
the data by month. Note that you could do this for any particular time subset that
you want. You are just using month as an example.

You use the `lubridate` package to quickly extract the month from an existing
date formatted field.

<i fa fa-star></i>**IMPORTANT:** this will only work on data where you've already converted the date
into a date class that `R` can read as a date.
{: .notice--success }

Below, you extract just the date from the date field using the month() function.


```r
# if you send the month function a particular date and specify the format, it returns the month
month(as.POSIXlt("01-01-2003", format = "%m-%d-%y"))
## [1] 1
month(as.POSIXlt("06-01-2003", format = "%m-%d-%y"))
## [1] 6

# extract just the date from the date field in your data.frame
head(month(boulder_daily_precip$DATE))
## [1] 1 1 2 2 2 2
```

### Add Month Column to the Data

Now you have everything that you need to add a "month" column to your data. As you did
earlier, you can use the `mutate()` function to add the date. However in this case,
instead of modifying an existing column, you will create a new month column.


```r
# add a month column to your boulder_daily_precip data.frame
boulder_daily_precip <- boulder_daily_precip %>%
  mutate(month = month(DATE))

#boulder_daily_precip$test <- as.Date(paste0(boulder_daily_precip$month_year,"-01"),"%Y-%m-%d")
```




Now that you have a new column you can create a summary precipitation value for
each month. To do this, you need to do the following:

1. `group_by()`: group the data by month AND year (so you have unique values for each month)
1. `summarise()`: add up all precipitation values for each month to get your summary statistic
1. `ggplot()`: plot the newly summarized data!



```r
# calculate the sum precipitation for each month
boulder_daily_precip_month <- boulder_daily_precip %>%
  group_by(month) %>%
  summarise(sum_precip = sum(DAILY_PRECIP))
```

Next, plot the data.


```r
# subset 2 months around flood
boulder_daily_precip_month %>%
  ggplot(aes(x = month, y = sum_precip)) +
      geom_point(color = "darkorchid4") +
      labs(title = "Daily Precipitation - Boulder, Colorado",
           subtitle = "Data plotted by year",
           y = "Daily precipitation (inches)",
           x = "Date") + theme_bw(base_size = 15)
```

<img src="{{ site.url }}/images/rfigs/courses/earth-analytics/02-time-series-data/time-series-dates-r/2017-01-25-R03-summarize-time-series-data-by-month-or-day-R/plot-monthly-values-1.png" title="monthly summary of precipitation plot" alt="monthly summary of precipitation plot" width="90%" />

The plot above is not quite what you want. You want to be able to group by both
month and year. To do this you send the `group_by()` function both columns.
Like this:

`group_by(month, YEAR)`

Then you summarize using the same syntax you used above.


```r
# calculate the sum precipitation for each month
boulder_daily_precip_month <- boulder_daily_precip %>%
  group_by(month, YEAR) %>%
  summarise(max_precip = sum(DAILY_PRECIP))
```

Once again, plot. Now that you have the YEAR column in your data you can use
`facet_wrap()` to create a unique plot in a grid for each year.


```r
# subset 2 months around flood
boulder_daily_precip_month %>%
  ggplot(aes(x = month, y = max_precip)) +
      geom_bar(stat = "identity", fill = "darkorchid4") +
  facet_wrap(~ YEAR, ncol = 3) +
      labs(title = "Total Monthly Precipitation - Boulder, Colorado",
           subtitle = "Data plotted by year",
           y = "Daily precipitation (inches)",
           x = "Month") + theme_bw(base_size = 15)
```

<img src="{{ site.url }}/images/rfigs/courses/earth-analytics/02-time-series-data/time-series-dates-r/2017-01-25-R03-summarize-time-series-data-by-month-or-day-R/plot-monthly-values-year-1.png" title="monthly summary of precipitation plot grouped by month and year" alt="monthly summary of precipitation plot grouped by month and year" width="90%" />

### Clean Up x and y Axes

You can clean up the x axes by formatting the month column as a date. Note that below 
you are being a bit tricky with your dates. You are assigning each month to the 
same year and day. Note that this is one of many different ways that you can go about 
cleaning up your axis.



```r
# assign each month to the same year and day for plotting
as.Date(paste0("2015-", boulder_daily_precip_month$month,"-01"),"%Y-%m-%d")
##   [1] "2015-01-01" "2015-01-01" "2015-01-01" "2015-01-01" "2015-01-01"
##   [6] "2015-01-01" "2015-01-01" "2015-01-01" "2015-01-01" "2015-01-01"
##  [11] "2015-01-01" "2015-02-01" "2015-02-01" "2015-02-01" "2015-02-01"
##  [16] "2015-02-01" "2015-02-01" "2015-02-01" "2015-02-01" "2015-02-01"
##  [21] "2015-02-01" "2015-02-01" "2015-03-01" "2015-03-01" "2015-03-01"
##  [26] "2015-03-01" "2015-03-01" "2015-03-01" "2015-03-01" "2015-03-01"
##  [31] "2015-03-01" "2015-03-01" "2015-03-01" "2015-04-01" "2015-04-01"
##  [36] "2015-04-01" "2015-04-01" "2015-04-01" "2015-04-01" "2015-04-01"
##  [41] "2015-04-01" "2015-04-01" "2015-04-01" "2015-04-01" "2015-05-01"
##  [46] "2015-05-01" "2015-05-01" "2015-05-01" "2015-05-01" "2015-05-01"
##  [51] "2015-05-01" "2015-05-01" "2015-05-01" "2015-05-01" "2015-05-01"
##  [56] "2015-06-01" "2015-06-01" "2015-06-01" "2015-06-01" "2015-06-01"
##  [61] "2015-06-01" "2015-06-01" "2015-06-01" "2015-06-01" "2015-06-01"
##  [66] "2015-06-01" "2015-07-01" "2015-07-01" "2015-07-01" "2015-07-01"
##  [71] "2015-07-01" "2015-07-01" "2015-07-01" "2015-07-01" "2015-07-01"
##  [76] "2015-07-01" "2015-07-01" "2015-08-01" "2015-08-01" "2015-08-01"
##  [81] "2015-08-01" "2015-08-01" "2015-08-01" "2015-08-01" "2015-08-01"
##  [86] "2015-08-01" "2015-08-01" "2015-08-01" "2015-09-01" "2015-09-01"
##  [91] "2015-09-01" "2015-09-01" "2015-09-01" "2015-09-01" "2015-09-01"
##  [96] "2015-09-01" "2015-09-01" "2015-09-01" "2015-09-01" "2015-10-01"
## [101] "2015-10-01" "2015-10-01" "2015-10-01" "2015-10-01" "2015-10-01"
## [106] "2015-10-01" "2015-10-01" "2015-10-01" "2015-10-01" "2015-10-01"
## [111] "2015-11-01" "2015-11-01" "2015-11-01" "2015-11-01" "2015-11-01"
## [116] "2015-11-01" "2015-11-01" "2015-11-01" "2015-11-01" "2015-11-01"
## [121] "2015-11-01" "2015-12-01" "2015-12-01" "2015-12-01" "2015-12-01"
## [126] "2015-12-01" "2015-12-01" "2015-12-01" "2015-12-01" "2015-12-01"
## [131] "2015-12-01" "2015-12-01"
```

You can use the code above with the `mutate()` function to create a new month
column that contains the month of the year as a class of type date.
If `R` reads the column as a date, you can then use the:

`scale_x_date(date_labels = "%b")`

function with `ggplot()`, to format the x axis as a date.

Note that `%b` represents the abbreviated month which will be plotted as labels
on the x-axis.


```r

boulder_daily_precip_month %>%
  mutate(month2 = as.Date(paste0("2015-", month,"-01"),"%Y-%m-%d")) %>%
  ggplot(aes(x = month2, y = max_precip)) +
      geom_bar(stat = "identity", fill = "darkorchid4") +
  facet_wrap(~ YEAR, ncol = 3) +
      labs(title = "Montly Total Daily Precipitation - Boulder, Colorado",
           subtitle = "Data plotted by year",
           y = "Daily precipitation (inches)",
           x = "Month") + theme_bw(base_size = 15) +
  scale_x_date(date_labels = "%b")
```

<img src="{{ site.url }}/images/rfigs/courses/earth-analytics/02-time-series-data/time-series-dates-r/2017-01-25-R03-summarize-time-series-data-by-month-or-day-R/plot-monthly-values-year2-1.png" title="monthly summary of precipitation plot grouped by month and year" alt="monthly summary of precipitation plot grouped by month and year" width="90%" />
