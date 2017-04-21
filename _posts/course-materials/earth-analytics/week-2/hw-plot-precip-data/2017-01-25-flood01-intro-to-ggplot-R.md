---
layout: single
title: "Customize ggplot plots in R - earth analytics - data science for scientists"
excerpt: 'This lesson covers how to customize ggplot plot colors and label axes in R. It uses the ggplot2 package.'
authors: ['Leah Wasser', 'Data Carpentry']
modified: '2017-04-21'
category: [course-materials]
class-lesson: ['hw-ggplot2-r']
nav-title: 'GGPLOT R'
permalink: /course-materials/earth-analytics/week-2/hw-ggplot2-r/
module-description: 'This module covers handling with data fields in R so you can efficiently plot time series data using ggplot(). We will use the as.DATE() function to convert dates stored in a data.frame to a date class. We will then plot the time series data using ggplot() and learn how to customize colors and axis labels. '
module-nav-title: 'Time Series Data in R'
module-title: 'Work with Sensor Network Derived Time Series Data in R'
module-type: 'homework'
course: "Earth Analytics"
week: 2
sidebar:
  nav:
author_profile: false
comments: true
order: 1
tags2:
  scientific-programming: ['r-studio', 'r']
  data-exploration-and-analysis: ['data-visualization']
---

{% include toc title="In This Lesson" icon="file-text" %}

In this tutorial, we will explore more advanced plotting techniques using `ggplot2`.

<div class='notice--success' markdown="1">

## <i class="fa fa-graduation-cap" aria-hidden="true"></i> Learning Objectives
At the end of this activity, you will be able to:

* Use the `ggplot()` plot function to create custom plots.
* Add labels to x and y axes and a title to your ggplot plot.
* Customize the colors and look of a ggplot plot.

## <i class="fa fa-check-square-o fa-2" aria-hidden="true"></i> What you need

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
# note that we already downloaded the data to our laptops previously
# but in case you don't have it - re-download it by uncommenting the code below.
# download.file(url = "https://ndownloader.figshare.com/files/7010681",
#              destfile = "data/boulder-precip.csv")

# import data
boulder_precip <- read.csv(file="data/boulder-precip.csv")

# view first few rows of the data
head(boulder_precip)
##     X       DATE PRECIP
## 1 756 2013-08-21    0.1
## 2 757 2013-08-26    0.1
## 3 758 2013-08-27    0.1
## 4 759 2013-09-01    0.0
## 5 760 2013-09-09    0.1
## 6 761 2013-09-10    1.0

# when we download the data we create a dataframe
# view each column of the data frame using its name (or header)
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

<img src="{{ site.url }}/images/rfigs/course-materials/earth-analytics/week-2/hw-plot-precip-data/2017-01-25-flood01-intro-to-ggplot-R/plot-data-1.png" title="quick plot of precip data" alt="quick plot of precip data" width="100%" />

## Plot with ggplot2

`ggplot2` is a plotting package that makes it simple to create complex plots
from data in a data.frame. It uses default settings, which help to create
publication quality plots with a minimal amount of settings and tweaking.

ggplot graphics are built step by step by adding new elements.

To build a ggplot() we need to:

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

<img src="{{ site.url }}/images/rfigs/course-materials/earth-analytics/week-2/hw-plot-precip-data/2017-01-25-flood01-intro-to-ggplot-R/first-ggplot-1.png" title="ggplot boulder precip" alt="ggplot boulder precip" width="100%" />

The `+` in the `ggplot2` package is particularly useful because it allows you
to modify existing `ggplot` objects. This means you can easily set up plot
"templates" and conveniently explore different types of plots, so the above
plot can also be generated with code like this:


```r
# Create the plot object (nothing will render on your screen)
precip_plot <-  ggplot(data = boulder_precip,  aes(x = DATE, y = PRECIP))

# Draw the plot
precip_plot + geom_point()

```




We can also apply a color to our points


```r
ggplot(data = boulder_precip,  aes(x = DATE, y = PRECIP)) +
    geom_point(color = "blue")
```

<img src="{{ site.url }}/images/rfigs/course-materials/earth-analytics/week-2/hw-plot-precip-data/2017-01-25-flood01-intro-to-ggplot-R/adding-colors-1.png" title="ggplot with blue points" alt="ggplot with blue points" width="100%" />

And adjust the transparency.


```r
ggplot(data = boulder_precip,  aes(x = DATE, y = PRECIP)) +
    geom_point(alpha=.5, color = "blue")
```

<img src="{{ site.url }}/images/rfigs/course-materials/earth-analytics/week-2/hw-plot-precip-data/2017-01-25-flood01-intro-to-ggplot-R/add-alpha-1.png" title="ggplot with blue points and alpha" alt="ggplot with blue points and alpha" width="100%" />


Or to color each value in the plot differently:


```r
ggplot(data = boulder_precip,  aes(x = DATE, y = PRECIP)) +
    geom_point(alpha = 0.9, aes(color=PRECIP))
```

<img src="{{ site.url }}/images/rfigs/course-materials/earth-analytics/week-2/hw-plot-precip-data/2017-01-25-flood01-intro-to-ggplot-R/color-by-species-1.png" title="ggplot with colored points" alt="ggplot with colored points" width="100%" />


We can turn our plot into a bar plot.


```r
ggplot(data = boulder_precip,  aes(x = DATE, y = PRECIP)) +
    geom_bar(stat="identity")
```

<img src="{{ site.url }}/images/rfigs/course-materials/earth-analytics/week-2/hw-plot-precip-data/2017-01-25-flood01-intro-to-ggplot-R/barplot-1.png" title="ggplot with bars" alt="ggplot with bars" width="100%" />

Turn the bar outlines blue


```r
ggplot(data = boulder_precip,  aes(x = DATE, y = PRECIP)) +
    geom_bar(stat="identity", color="blue")
```

<img src="{{ site.url }}/images/rfigs/course-materials/earth-analytics/week-2/hw-plot-precip-data/2017-01-25-flood01-intro-to-ggplot-R/bar-color-1.png" title="ggplot with blue bars" alt="ggplot with blue bars" width="100%" />

Change the fill to bright green.


```r
ggplot(data = boulder_precip,  aes(x = DATE, y = PRECIP)) +
    geom_bar(stat="identity", color="blue", fill="green")
```

<img src="{{ site.url }}/images/rfigs/course-materials/earth-analytics/week-2/hw-plot-precip-data/2017-01-25-flood01-intro-to-ggplot-R/barcolor2-1.png" title="ggplot with green bars" alt="ggplot with green bars" width="100%" />


## Add plot labels

You can add labels to your plots as well. Let's add a title, and x and y labels using the glab() argument.


```r
ggplot(data = boulder_precip,  aes(x = DATE, y = PRECIP)) +
    geom_point(alpha = 0.9, aes(color=PRECIP)) +
    glabs(x="Date",
      y="Precipitation (Inches)",
      title="Daily Precipitation (inches)"
      subtitle="Boulder, Colorado 2013")
## Error: <text>:6:7: unexpected symbol
## 5:       title="Daily Precipitation (inches)"
## 6:       subtitle
##          ^
```



## More on customizing your plots

There are many different tutorials out there on customizing ggplot plots. A
few are listed below.

* <a href="http://www.datacarpentry.org/R-ecology-lesson/05-visualization-ggplot2.html" target="_blank" data-proofer-ignore=''> Data carpentry ggplot2 </a>
* <a href="http://www.cookbook-r.com/Graphs/" target="_blank">R Cookbook</a>

<div class="notice--warning" markdown="1">

## <i class="fa fa-pencil-square-o" aria-hidden="true"></i> Optional challenge

Customize the plot that we created in last weeks homework as follows:

* Change the colors of the plot
* Plot the data using points `geom_point()` AND bars `geom_bar()`
* Add a title to your plot and x and y axis labels.

</div>
