---
layout: single 
title: "Visualizing hourly traffic crime data for Denver, Colorado using R, dplyr, and ggplot"
date: 2016-12-06 
authors: [Max Joseph] 
category: [tutorials] 
excerpt: 'This tutorial demonstrates how to access and visualize crime data for Denver, Colorado.' 
sidebar: 
nav: 
author_profile: false 
comments: true 
lang: [r]
lib: [dplyr, ggplot2, lubridate, viridis, RCurl]
---

The city of Denver publicly hosts crime data from the past five years in their [open data catalog](https://www.denvergov.org/opendata/dataset/city-and-county-of-denver-crime). In this tutorial, we will use R to access and visualize these data, which are essentially spatiotemporally referenced points with features for type of crime, neighborhood, etc.

First, we will load some packages that we'll use later.

``` r
library(dplyr)
library(ggplot2)
library(lubridate)
library(viridis)
library(RCurl)
```

Then, we need to download a comma separated values file that contains the raw data.

``` r
data_url <- "http://data.denvergov.org/download/gis/crime/csv/crime.csv"
data <- getURL(data_url, ssl.verifypeer = 0L, followlocation = 1L)
d <- read.csv(text = data)
```

Let's lowercase the column names, and look at the structure of the data with the `str()` function.

``` r
names(d) <- tolower(names(d))
str(d)
```

    ## 'data.frame':    449724 obs. of  19 variables:
    ##  $ incident_id           : num  2.01e+08 2.01e+09 2.01e+09 2.01e+09 2.01e+09 ...
    ##  $ offense_id            : num  2.01e+14 2.01e+15 2.01e+15 2.01e+15 2.01e+15 ...
    ##  $ offense_code          : int  1313 5441 5312 5311 5309 1315 2999 5401 2305 2999 ...
    ##  $ offense_code_extension: int  2 0 0 0 1 1 0 0 0 0 ...
    ##  $ offense_type_id       : Factor w/ 196 levels "accessory-conspiracy-to-crime",..: 14 172 38 127 88 4 34 174 158 34 ...
    ##  $ offense_category_id   : Factor w/ 15 levels "aggravated-assault",..: 9 14 10 2 10 1 10 14 13 10 ...
    ##  $ first_occurrence_date : Factor w/ 293596 levels "2011-01-02 00:00:00",..: 126932 145524 145391 145391 108681 145525 145442 145527 145349 145520 ...
    ##  $ last_occurrence_date  : Factor w/ 126800 levels "","2011-01-02 00:40:00",..: 65663 1 1 1 72643 1 72644 1 72630 72642 ...
    ##  $ reported_date         : Factor w/ 384342 levels "2011-01-02 01:15:00",..: 169763 193621 193900 193900 193614 193633 193630 193622 193623 193659 ...
    ##  $ incident_address      : Factor w/ 94536 levels "","0000 BLOCK E COLFAX AVE /NORTHSIDE",..: 77367 1 1 1 65601 26272 67136 49196 70149 51123 ...
    ##  $ geo_x                 : num  3167314 3152232 3188858 3188858 3167289 ...
    ##  $ geo_y                 : num  1680984 1671713 1712058 1712058 1689360 ...
    ##  $ geo_lon               : num  -105 -105 -105 -105 -105 ...
    ##  $ geo_lat               : num  39.7 39.7 39.8 39.8 39.7 ...
    ##  $ district_id           : int  3 3 5 5 3 6 4 2 4 2 ...
    ##  $ precinct_id           : int  321 313 512 512 321 621 421 221 412 212 ...
    ##  $ neighborhood_id       : Factor w/ 79 levels "","athmar-park",..: 73 67 46 46 38 27 35 49 77 18 ...
    ##  $ is_crime              : int  1 0 1 1 1 1 1 0 1 1 ...
    ##  $ is_traffic            : int  0 1 0 0 0 0 0 1 0 0 ...

The code below uses the `dplyr` package to subset the data to only include traffic accident crimes (`filter(...)`), and parses the date/time column so that we can extract quantities like hour-minutes (to evaluate patterns over the course of one day), the day of week (e.g., 1 = Sunday, 2 = Monday, ...), and year day (what day of the year is it?), creating new columns for these variables with the `mutate()` function.

``` r
accidents <- d %>%
  filter(offense_category_id == "traffic-accident") %>%
  mutate(datetime = ymd_hms(first_occurrence_date, tz = "MST"),
         hm = as.POSIXct(paste(hour(datetime), minute(datetime), sep = ":"), 
                         format = "%H:%M"),
         dow = wday(datetime), 
         yday = yday(datetime))
```

Last, we will group our data by hour-minute and day of the week, and for each combination of these two quantities, compute the number of traffic accident crimes. Then we'll create a new variable `day`, which is the character representation (Sunday, Monday, ...) of the numeric `dow` column (1, 2, ...). We'll also create a new variable `offense_type`, which is a more human-readable version of the `offense-type-id` column. Using ggplot, we'll create a density plot with a color for each day of week. This workflow uses `dplyr` to munge our data, then pipes the result to `ggplot2`, so that we only create one object in our global environment `p`, which is our plot.

``` r
p <- accidents %>%
  group_by(hm, dow, yday, offense_type_id) %>%
  summarize(n = n()) %>%
  # the call to mutate() makes new variables with better names
  mutate(day = factor(c("Sunday", "Monday", "Tuesday", 
                 "Wednesday", "Thursday", "Friday", 
                 "Saturday")[dow], 
                 levels = c("Monday", "Tuesday", 
                            "Wednesday", "Thursday", "Friday", 
                            "Saturday", "Sunday")), 
         offense_type = ifelse(
           offense_type_id == "traffic-accident-hit-and-run", 
           "Hit and run", 
           ifelse(
             offense_type_id == "traffic-accident-dui-duid",
             "Driving under the influence", "Traffic accident"))) %>%
  ggplot(aes(x = hm, 
             fill = day, 
             color = day)) + 
  geom_freqpoly(binwidth = 60 * 30) + # 60 sec/min * 30 min
  scale_color_viridis(discrete = TRUE, "", direction = -1) + 
  scale_fill_viridis(discrete = TRUE, "", direction = -1) + 
  xlab("Time of day") + 
  ylab("Frequency") + 
  ggtitle("Traffic crimes in Denver, Colorado") + 
  scale_x_datetime(date_breaks = "4 hours", date_labels = "%H:%M")
p 
```

![Traffic accident data for each hour in Denver, CO](/images/visualize-denver-colorado-traffic-crime_files/unnamed-chunk-5-1.png)

This dplyr to ggplot approach is extremely modular. If we wanted to see this plot for each type of traffic accident crime, we could do so simply by adding one statement.

``` r
p + facet_wrap(~ offense_type, ncol = 1, scales = "free_y")
```

![Traffic crime data by type](/images/visualize-denver-colorado-traffic-crime_files/unnamed-chunk-6-1.png)
