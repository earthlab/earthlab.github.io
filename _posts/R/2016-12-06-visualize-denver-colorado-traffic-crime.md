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

The city of Denver publicly hosts crime data from the past five years in their open data catalog. In this tutorial, we will use R to access and visualize these data, which are essentially spatiotemporally referenced points with features for type of crime, neighborhood, etc.

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

    ## 'data.frame':    450438 obs. of  19 variables:
    ##  $ incident_id           : num  2.01e+08 2.01e+08 2.01e+07 2.01e+08 2.01e+10 ...
    ##  $ offense_id            : num  2.01e+14 2.01e+14 2.01e+13 2.01e+14 2.01e+16 ...
    ##  $ offense_code          : int  2303 2305 5441 2399 2308 2305 2999 2305 2999 5401 ...
    ##  $ offense_code_extension: int  0 0 0 0 0 0 2 0 0 0 ...
    ##  $ offense_type_id       : chr  "theft-shoplift" "theft-items-from-vehicle" "traffic-accident" "theft-other" ...
    ##  $ offense_category_id   : chr  "larceny" "theft-from-motor-vehicle" "traffic-accident" "larceny" ...
    ##  $ first_occurrence_date : chr  "2013-02-08 17:49:59" "2013-02-08 10:15:00" "2013-01-04 22:24:00" "2013-02-08 17:10:00" ...
    ##  $ last_occurrence_date  : chr  "2013-02-08 18:02:59" "2013-02-08 16:15:00" "" "2013-02-08 17:15:00" ...
    ##  $ reported_date         : chr  "2013-02-08 18:02:59" "2013-02-08 18:04:59" "2013-01-04 23:19:00" "2013-02-08 20:04:59" ...
    ##  $ incident_address      : chr  "1155 E 9TH AVE" "36 N STEELE ST" "N BROADWAY ST / W 1ST AVE" "741 E COLFAX AVE" ...
    ##  $ geo_x                 : num  3147996 3154875 3144170 3146878 3160074 ...
    ##  $ geo_y                 : num  1691775 1686477 1686948 1694896 1672420 ...
    ##  $ geo_lon               : num  -105 -105 -105 -105 -105 ...
    ##  $ geo_lat               : num  39.7 39.7 39.7 39.7 39.7 ...
    ##  $ district_id           : int  6 3 3 6 3 1 2 5 2 3 ...
    ##  $ precinct_id           : int  623 312 311 621 322 113 221 513 211 311 ...
    ##  $ neighborhood_id       : chr  "capitol-hill" "cherry-creek" "baker" "north-capitol-hill" ...
    ##  $ is_crime              : int  1 1 0 1 1 1 1 1 1 0 ...
    ##  $ is_traffic            : int  0 0 1 0 0 0 0 0 0 1 ...

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
