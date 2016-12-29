---
layout: single
title: "Plotting with GGPLOT"
excerpt: "This lesson walks through using GGPLOT2 to plot data."
authors: ['Leah Wasser', 'Data Carpentry']
lastModified: 2016-12-28
category: [course-materials]
class-lesson: ['hw-ggplot2-r']
permalink: /course-materials/earth-analytics/week-2/hw-ggplot2-r
nav-title: 'GGPLOT R'
module-title: 'Plotting Time Series Data in R'
module-description: 'This tutorial covers how to plot time series data in R using ggplot2. It also covers converting data stored in data/time format into an R date time class.'
week: 2
sidebar:
  nav:
author_profile: false
comments: false
order: 1
---

In this tutorial, we will explore more advanced plotting techniques using `ggplot2`.

<div class='notice--success' markdown="1">

# Learning Objectives
At the end of this activity, you will be able to:

* use the ggplot plot function to customize plots

## What You Need

You need `R` and `RStudio` to complete this tutorial. Also you should have
an `earth-analytics` directory setup on your computer with a `/data`
directory with it.

* [How to Setup R / RStudio](/course-materials/earth-analytics/week-1/setup-r-rstudio/)
* [Setup your working directory](/course-materials/earth-analytics/week-1/setup-working-directory/)
* [Intro to the R & RStudio Interface](/course-materials/earth-analytics/week-1/intro-to-r-and-rstudio)

</div>


In our week 1 homework, we used the quick plot function of ggplot2 to plot our data.
In this tutorial, we'll explore ggplot - which offers many more advanced plotting
features.

Let's explore the code below to create a quick plot.


```r

# load the ggplot2 library for plotting
library(ggplot2)

# download data from figshare
# note that we are downloaded the data into your
download.file(url = "https://ndownloader.figshare.com/files/7010681",
              destfile = "data/boulder-precip.csv")

# import data
boulder_precip <- read.csv(file="data/boulder-precip.csv")

# view first few rows of the data
head(boulder.precip)
##     X       DATE PRECIP
## 1 756 2013-08-21    0.1
## 2 757 2013-08-26    0.1
## 3 758 2013-08-27    0.1
## 4 759 2013-09-01    0.0
## 5 760 2013-09-09    0.1
## 6 761 2013-09-10    1.0

# when we download the data we create a dataframe
# view each column of the data frame using it's name (or header)
boulder_precip$DATE
##  [1] "2013-08-21" "2013-08-26" "2013-08-27" "2013-09-01" "2013-09-09"
##  [6] "2013-09-10" "2013-09-11" "2013-09-12" "2013-09-13" "2013-09-15"
## [11] "2013-09-16" "2013-09-22" "2013-09-23" "2013-09-27" "2013-09-28"
## [16] "2013-10-01" "2013-10-04" "2013-10-11"

# view the precip column
boulder_precip$PRECIP
##  [1] 0.1 0.1 0.1 0.0 0.1 1.0 2.3 9.8 1.9 1.4 0.4 0.1 0.3 0.3 0.1 0.0 0.9
## [18] 0.1

# q plot stands for quick plot. Let's use it to plot our data
qplot(x=boulder_precip$DATE,
      y=boulder_precip$PRECIP)
```

![ ]({{ site.baseurl }}/images/rfigs/course-materials/earth-analytics/week-2/hw-plot-precip-data/2016-12-06-flood01-intro-to-ggplot-R/plot-data-1.png)

## Plotting with ggplot2

`ggplot2` is a plotting package that makes it simple to create complex plots
from data in a dataframe. It uses default settings, which help to create
publication quality plots with a minimal amount of settings and tweaking.

ggplot graphics are built step by step by adding new elements.

To build a ggplot we need to:

- bind the plot to a specific data frame using the `data` argument


```r

ggplot(data = boulder_precip)

```

- define aesthetics (`aes`), by selecting the variables to be plotted and the variables to define the presentation
     such as plotting size, shape color, etc.,


```r
ggplot(data = boulder_precip, aes(x = DATE, y = PRECIP))
```

- add `geoms` -- graphical representation of the data in the plot (points,
     lines, bars). To add a geom to the plot use `+` operator:


```r

ggplot(data = boulder_precip,  aes(x = DATE, y = PRECIP)) +
  geom_point()
```

![ ]({{ site.baseurl }}/images/rfigs/course-materials/earth-analytics/week-2/hw-plot-precip-data/2016-12-06-flood01-intro-to-ggplot-R/first-ggplot-1.png)

The `+` in the `ggplot2` package is particularly useful because it allows you
to modify existing `ggplot` objects. This means you can easily set up plot
"templates" and conveniently explore different types of plots, so the above
plot can also be generated with code like this:


```r
# Create
precip_plot <-  ggplot(data = boulder_precip,  aes(x = DATE, y = PRECIP))

# Draw the plot
precip_plot + geom_point()

```




We can also apply a color to our the points


```r
 ggplot(data = boulder_precip,  aes(x = DATE, y = PRECIP)) +
    geom_point(color = "blue")
```

![ ]({{ site.baseurl }}/images/rfigs/course-materials/earth-analytics/week-2/hw-plot-precip-data/2016-12-06-flood01-intro-to-ggplot-R/adding-colors-1.png)

And adjust the transparency.


```r

ggplot(data = boulder_precip,  aes(x = DATE, y = PRECIP)) +
    geom_point(alpha=.5, color = "blue")
```

![ ]({{ site.baseurl }}/images/rfigs/course-materials/earth-analytics/week-2/hw-plot-precip-data/2016-12-06-flood01-intro-to-ggplot-R/add-alpha-1.png)


Or to color each value in the plot differently:


```r
ggplot(data = boulder_precip,  aes(x = DATE, y = PRECIP)) +
    geom_point(alpha = 0.9, aes(color=PRECIP))
```

![ ]({{ site.baseurl }}/images/rfigs/course-materials/earth-analytics/week-2/hw-plot-precip-data/2016-12-06-flood01-intro-to-ggplot-R/color-by-species-1.png)


We can turn our plot into a bar plot.


```r
ggplot(data = boulder_precip,  aes(x = DATE, y = PRECIP)) +
    geom_bar(stat="identity")
```

![ ]({{ site.baseurl }}/images/rfigs/course-materials/earth-analytics/week-2/hw-plot-precip-data/2016-12-06-flood01-intro-to-ggplot-R/barplot-1.png)

Turn the bars blue


```r
ggplot(data = boulder_precip,  aes(x = DATE, y = PRECIP)) +
    geom_bar(stat="identity", color="blue")
```

![ ]({{ site.baseurl }}/images/rfigs/course-materials/earth-analytics/week-2/hw-plot-precip-data/2016-12-06-flood01-intro-to-ggplot-R/bar-color-1.png)

Change the fill to bright green.


```r
ggplot(data = boulder_precip,  aes(x = DATE, y = PRECIP)) +
    geom_bar(stat="identity", color="blue", fill="green")
```

![ ]({{ site.baseurl }}/images/rfigs/course-materials/earth-analytics/week-2/hw-plot-precip-data/2016-12-06-flood01-intro-to-ggplot-R/barcolor2-1.png)


## Adding Labels

You can add labels to your plots as well. Let's add a title, and x and y labels.

```r
ggplot(data = boulder_precip,  aes(x = DATE, y = PRECIP)) +
    geom_point(alpha = 0.9, aes(color=PRECIP)) +
    ggtitle("Precipitation - Boulder, Colorado 2013")
```

![ ]({{ site.baseurl }}/images/rfigs/course-materials/earth-analytics/week-2/hw-plot-precip-data/2016-12-06-flood01-intro-to-ggplot-R/add-title-1.png)

x and y labels...



```r
ggplot(data = boulder_precip,  aes(x = DATE, y = PRECIP)) +
    geom_point(alpha = 0.9, aes(color=PRECIP)) +
    ggtitle("Precipitation - Boulder, Colorado 2013") +
    xlab("x label here") + ylab("y label here")
```

![ ]({{ site.baseurl }}/images/rfigs/course-materials/earth-analytics/week-2/hw-plot-precip-data/2016-12-06-flood01-intro-to-ggplot-R/add-title2-1.png)


## More on customizing your plots

There are many different tutorials out there on customizing ggplot plots. A
few are listed below.

* <a href="http://www.datacarpentry.org/R-ecology-lesson/05-visualization-ggplot2.html" target="_blank"> Data carpentry ggplot2 </a>
* <a href="http://www.cookbook-r.com/Graphs/" target="_blank">R Cookbook</a>

<div id="challenge" markdown="1">
* customize your plot as follows

- color of the plot,
dots vs bars
add labels
</div>
