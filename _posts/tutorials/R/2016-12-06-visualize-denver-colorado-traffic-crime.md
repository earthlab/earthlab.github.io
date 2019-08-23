---
layout: single 
title: "Visualizing hourly traffic crime data for Denver, Colorado using R, dplyr, and ggplot"
date: 2016-12-06 
modified: '2019-08-23'
authors: [Max Joseph] 
category: [tutorials] 
excerpt: 'This tutorial demonstrates how to access and visualize crime data for Denver, Colorado.' 
sidebar: 
nav: 
author_profile: false 
comments: true 
lang: [r]
lib: [dplyr, ggplot2, lubridate, readr]
---


The city of Denver publicly hosts crime data from the past five years in their open data catalog.
In this tutorial, we will use R to access and visualize these data, which are essentially spatiotemporally referenced points with features for type of crime, neighborhood, etc. 

First, we will load some packages that we'll use later. 


```r
library(dplyr)
library(ggplot2)
library(lubridate)
```

Then, we need to download a comma separated values file that contains the raw data.


```r
data_url <- "https://www.denvergov.org/media/gis/DataCatalog/crime/csv/crime.csv"
d <- read.csv(data_url)
```

Let's lowercase the column names, and look at the structure of the data with the `str()` function. 


```r
names(d) <- tolower(names(d))
str(d)
## 'data.frame':	507164 obs. of  19 variables:
##  $ incident_id           : num  2.02e+09 2.02e+10 2.02e+10 2.02e+08 2.02e+09 ...
##  $ offense_id            : num  2.02e+15 2.02e+16 2.02e+16 2.02e+14 2.02e+15 ...
##  $ offense_code          : int  5213 2399 2305 2399 2303 5499 2304 5707 5401 2305 ...
##  $ offense_code_extension: int  0 0 0 0 0 0 0 0 0 0 ...
##  $ offense_type_id       : chr  "weapon-unlawful-discharge-of" "theft-other" "theft-items-from-vehicle" "theft-other" ...
##  $ offense_category_id   : chr  "all-other-crimes" "larceny" "theft-from-motor-vehicle" "larceny" ...
##  $ first_occurrence_date : chr  "6/15/2016 11:31:00 PM" "10/11/2017 12:30:00 PM" "3/4/2016 8:00:00 PM" "1/30/2018 7:20:00 PM" ...
##  $ last_occurrence_date  : chr  "" "10/11/2017 4:55:00 PM" "4/25/2016 8:00:00 AM" "" ...
##  $ reported_date         : chr  "6/15/2016 11:31:00 PM" "1/29/2018 5:53:00 PM" "4/26/2016 9:02:00 PM" "1/30/2018 10:29:00 PM" ...
##  $ incident_address      : chr  "" "" "2932 S JOSEPHINE ST" "705 S COLORADO BLVD" ...
##  $ geo_x                 : int  3193983 3201943 3152762 3157162 3153211 3151310 3133441 3145202 3142965 3136231 ...
##  $ geo_y                 : int  1707251 1711852 1667011 1681320 1686545 1696020 1692147 1688799 1693682 1701209 ...
##  $ geo_lon               : num  -105 -105 -105 -105 -105 ...
##  $ geo_lat               : num  39.8 39.8 39.7 39.7 39.7 ...
##  $ district_id           : int  5 5 3 3 3 6 1 3 6 1 ...
##  $ precinct_id           : int  521 522 314 312 311 622 122 311 611 113 ...
##  $ neighborhood_id       : chr  "montbello" "gateway-green-valley-ranch" "wellshire" "belcaro" ...
##  $ is_crime              : int  1 1 1 1 1 1 1 1 0 1 ...
##  $ is_traffic            : int  0 0 0 0 0 0 0 0 1 0 ...
```

The code below uses the `dplyr` package to subset the data to only include traffic accident crimes (`filter(...)`), and parses the date/time column so that we can extract quantities like hour-minutes (to evaluate patterns over the course of one day), the day of week (e.g., 1 = Sunday, 2 = Monday, ...), and year day (what day of the year is it?), creating new columns for these variables with the `mutate()` function.


```r
accidents <- d %>%
  filter(offense_type_id == "traffic-accident") %>%
  mutate(datetime = mdy_hms(first_occurrence_date, tz = "MST"),
         hr = hour(datetime),
         dow = wday(datetime), 
         yday = yday(datetime))
```

Last, we will group our data by hour and day of the week, and for each combination of these two quantities, compute the number of traffic accident crimes. 
Then we'll create a new variable `day`, which is the character representation (Sunday, Monday, ...) of the numeric `dow` column (1, 2, ...).
We'll also create a new variable `offense_type`, which is a more human-readable version of the `offense-type-id` column.
Using ggplot, we'll create a density plot with a color for each day of week.
This workflow uses `dplyr` to munge our data, then pipes the result to `ggplot2`, so that we only create one object in our global environment `p`, which is our plot. 


```r
p <- accidents %>%
  count(hr, dow, yday, offense_type_id) %>%
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
  ggplot(aes(x = hr, 
             fill = day, 
             color = day)) + 
  geom_freqpoly(binwidth = 1) + # 60 sec/min * 60 min
  scale_color_discrete("Day of week") + 
  xlab("Time of day (hour)") + 
  ylab("Frequency") + 
  ggtitle("Traffic crimes in Denver, Colorado")
p 
```

<img src="{{ site.url }}/images/tutorials//R/2016-12-06-visualize-denver-colorado-traffic-crime/plot-hourly-1.png" title="Traffic accident data for each hour in Denver, CO" alt="Traffic accident data for each hour in Denver, CO" width="90%" />

