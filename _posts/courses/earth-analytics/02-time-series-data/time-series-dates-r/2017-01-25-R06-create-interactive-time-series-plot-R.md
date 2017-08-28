---
layout: single
title: "Create interactive plots in R - time series & scatterplots using plotly and dygraphs"
excerpt: "Learn how to create interactive reports using plotly and dygraphs in R for plotting. "
authors: ['Leah Wasser']
modified: '2017-08-28'
category: [courses]
class-lesson: ['time-series-r']
permalink: /courses/earth-analytics/time-series-data/interactive-time-series-plots-in-r/
nav-title: 'Interactive time series plots'
week: 2
course: "earth-analytics"
sidebar:
  nav:
author_profile: false
comments: true
order: 5
---


{% include toc title="In This Lesson" icon="file-text" %}

<div class='notice--success' markdown="1">

## <i class="fa fa-graduation-cap" aria-hidden="true"></i> Learning Objectives

After completing this tutorial, you will be able to:

* Create an interactive time series plot using plot.ly in `R`
* Create an interactive time series plot using dygraphs in `R`

## <i class="fa fa-check-square-o fa-2" aria-hidden="true"></i> What you need

You will need a computer with internet access to complete this lesson and the data for week 4 of the course.

[<i class="fa fa-download" aria-hidden="true"></i> Download Week 4 Data (~500 MB)](https://ndownloader.figshare.com/files/7525363){:data-proofer-ignore='' .btn }

</div>



In this lesson we will explore using 2 interactive tools to create interactive
plots of our data:

1. plotly and
2. dygraphs

First, we will load all of the needed libraries.


```r
# install plotly from git - ropensci
#devtools::install_github('ropensci/plotly')

# load libraries
library(ggplot2)
library(xts)
library(dygraphs)
library(plotly)

options(stringsAsFactors = FALSE)
```



First, let's import some time series data


```r
discharge_time <- read.csv("data/week_02/discharge/06730200-discharge-daily-1986-2013.csv")

discharge_time$datetime <- as.Date(discharge_time$datetime, format="%m/%d/%y")
```

We can plot the data using ggplot().


```r
annual_precip <- ggplot(discharge_time, aes(x=datetime, y=disValue)) +
  geom_point() +
  labs(x = "Time",
       y = "discharge value",
       title = "my title")

annual_precip
```

<img src="{{ site.url }}/images/rfigs/courses/earth-analytics/02-time-series-data/time-series-dates-r/2017-01-25-R06-create-interactive-time-series-plot-R/annual-precip-1.png" title="annual precipation patterns" alt="annual precipation patterns" width="100%" />

## Time series - Plotly


We can use plotly to create an interactive plot that we can use in the
R console.



```r
# create interactive plotly plot
ggplotly(annual_precip)

```





<iframe title="Basic Map" width="100%" height="600" src="{{ site.url }}/leaflet-maps/plotly/plotly_precip.html" frameborder="0" allowfullscreen></iframe>


## Time series - Dygraph

Dygraph is a powerful and easy to use interactive time series plot generator.
Below, notice how we can quickly create a dygraph interactive plot. The output
format of the plot is html so it won't work with a pdf rmd output but it will
work with html!



```r
# interactive time series
library(dygraphs)
# create time series objects (class xs)
library(xts)

# create time series object
discharge_timeSeries <- xts(x = discharge_time$disValue,
                            order.by = discharge_time$datetime)

```

Then you can call the dygraph() function to create your interactive time-series plot.


```r
# create a basic interactive element
interact_time <- dygraph(discharge_timeSeries)
interact_time
```




<iframe title="Basic Map" width="100%" height="600" src="{{ site.url }}/leaflet-maps/dygraph/basic_time_interactive.html" frameborder="0" allowfullscreen></iframe>



```r
# create a basic interactive element
interact_time2 <- dygraph(discharge_timeSeries) %>% dyRangeSelector()
interact_time2
```



<iframe title="Basic Map" width="100%" height="600" src="{{ site.url }}/leaflet-maps/dygraph/time_interactive2.html" frameborder="0" allowfullscreen></iframe>
