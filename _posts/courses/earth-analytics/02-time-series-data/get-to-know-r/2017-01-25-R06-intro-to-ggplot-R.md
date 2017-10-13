---
layout: single
title: "Plot data and customize plots with ggplot plots in R - earth analytics - data science for scientists"
excerpt: 'Learn how to plot data and customize your plots using ggplot in R.'
authors: ['Leah Wasser', 'Data Carpentry']
modified: '2017-09-10'
category: [courses]
class-lesson: ['get-to-know-r']
nav-title: 'Plot data with ggplot'
permalink: /courses/earth-analytics/time-series-data/plot-data-with-ggplot2-r/
course: "earth-analytics"
week: 2
sidebar:
  nav:
author_profile: false
comments: true
order: 6
topics:
  reproducible-science-and-programming: ['RStudio']
  data-exploration-and-analysis: ['data-visualization']
---


{% include toc title="In this lesson" icon="file-text" %}

In this tutorial, we will explore more advanced plotting techniques using `ggplot2`.

<div class='notice--success' markdown="1">

## <i class="fa fa-graduation-cap" aria-hidden="true"></i> Learning objectives
At the end of this activity, you will be able to:

* Use the `ggplot()` plot function to create custom plots.
* Add labels to x and y axes and a title to your `ggplot()` plot.
* Customize the colors and look of a `ggplot()` plot.

## <i class="fa fa-check-square-o fa-2" aria-hidden="true"></i> What you need

You need `R` and `RStudio` to complete this tutorial. Also you should have
an `earth-analytics` directory setup on your computer with a `/data`
directory within it.

* [How to setup R / RStudio](/courses/earth-analytics/document-your-science/setup-r-rstudio/)
* [Setup your working directory](/courses/earth-analytics/document-your-science/setup-working-directory/)
* [Intro to the R & RStudio interface](/courses/earth-analytics/document-your-science/intro-to-r-and-rstudio)

</div>


In our week 1 homework, we used the quick plot function of `ggplot2` to plot our data.
In this tutorial, we'll explore `ggplot` - which offers many more advanced plotting
features.

Let's explore the code below to create a quick plot.


```r

# load the ggplot2 library for plotting
library(ggplot2)

# download data from figshare
# note that we already downloaded the data to our laptops previously
# but in case you don't have it - re-download it by uncommenting the code below.
# download.file("https://ndownloader.figshare.com/files/9282364",
#              "data/boulder-precip.csv",
#              method = "libcurl")

# import data
boulder_precip <- read.csv(file="data/boulder-precip.csv")

# view first few rows of the data
head(boulder_precip)
##    ID    DATE PRECIP TEMP
## 1 756 8/21/13    0.1   55
## 2 757 8/26/13    0.1   25
## 3 758 8/27/13    0.1   NA
## 4 759  9/1/13    0.0 -999
## 5 760  9/9/13    0.1   15
## 6 761 9/10/13    1.0   25

# when we download the data we create a dataframe
# view each column of the data frame using its name (or header)
boulder_precip$DATE
##  [1] "8/21/13"  "8/26/13"  "8/27/13"  "9/1/13"   "9/9/13"   "9/10/13" 
##  [7] "9/11/13"  "9/12/13"  "9/13/13"  "9/15/13"  "9/16/13"  "9/22/13" 
## [13] "9/23/13"  "9/27/13"  "9/28/13"  "10/1/13"  "10/4/13"  "10/11/13"

# view the precip column
boulder_precip$PRECIP
##  [1] 0.1 0.1 0.1 0.0 0.1 1.0 2.3 9.8 1.9 1.4 0.4 0.1 0.3 0.3 0.1 0.0 0.9
## [18] 0.1

# q plot stands for quick plot. Let's use it to plot our data
qplot(x=boulder_precip$DATE,
      y=boulder_precip$PRECIP)
```

<img src="{{ site.url }}/images/rfigs/courses/earth-analytics/02-time-series-data/get-to-know-r/2017-01-25-R06-intro-to-ggplot-R/plot-data-1.png" title="quick plot of precip data" alt="quick plot of precip data" width="90%" />

## Plot with ggplot2

`ggplot2` is a plotting package that makes it simple to create complex plots
from data in a data.frame. It uses default settings, which help to create
publication quality plots with a minimal amount of settings and tweaking.

`ggplot` graphics are built step by step by adding new elements.

To build a `ggplot()` we need to:

- Bind the plot to a specific data frame using the `data` argument


```r
ggplot(data = boulder_precip)

```


- Define aesthetics (`aes`), by selecting the variables to be plotted and the variables to define the presentation
     such as plotting size, shape color, etc.,


```r
ggplot(data = boulder_precip, aes(x = DATE, y = PRECIP))
```

- Add `geoms` -- graphical representation of the data in the plot (points,
     lines, bars). To add a geom to the plot use `+` operator:


```r
ggplot(data = boulder_precip,  aes(x = DATE, y = PRECIP)) +
  geom_point()
```

<img src="{{ site.url }}/images/rfigs/courses/earth-analytics/02-time-series-data/get-to-know-r/2017-01-25-R06-intro-to-ggplot-R/first-ggplot-1.png" title="ggplot boulder precip" alt="ggplot boulder precip" width="90%" />

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

<img src="{{ site.url }}/images/rfigs/courses/earth-analytics/02-time-series-data/get-to-know-r/2017-01-25-R06-intro-to-ggplot-R/adding-colors-1.png" title="ggplot with blue points" alt="ggplot with blue points" width="90%" />

And adjust the transparency


```r
ggplot(data = boulder_precip,  aes(x = DATE, y = PRECIP)) +
    geom_point(alpha=.5, color = "blue")
```

<img src="{{ site.url }}/images/rfigs/courses/earth-analytics/02-time-series-data/get-to-know-r/2017-01-25-R06-intro-to-ggplot-R/add-alpha-1.png" title="ggplot with blue points and alpha" alt="ggplot with blue points and alpha" width="90%" />


Or to color each value in the plot differently


```r
ggplot(data = boulder_precip,  aes(x = DATE, y = PRECIP)) +
    geom_point(alpha = 0.9, aes(color=PRECIP))
```

<img src="{{ site.url }}/images/rfigs/courses/earth-analytics/02-time-series-data/get-to-know-r/2017-01-25-R06-intro-to-ggplot-R/color-by-species-1.png" title="ggplot with colored points" alt="ggplot with colored points" width="90%" />


We can turn our plot into a bar plot


```r
ggplot(data = boulder_precip,  aes(x = DATE, y = PRECIP)) +
    geom_bar(stat="identity")
```

<img src="{{ site.url }}/images/rfigs/courses/earth-analytics/02-time-series-data/get-to-know-r/2017-01-25-R06-intro-to-ggplot-R/barplot-1.png" title="ggplot with bars" alt="ggplot with bars" width="90%" />

Turn the bar outlines blue


```r
ggplot(data = boulder_precip,  aes(x = DATE, y = PRECIP)) +
    geom_bar(stat="identity", color="blue")
```

<img src="{{ site.url }}/images/rfigs/courses/earth-analytics/02-time-series-data/get-to-know-r/2017-01-25-R06-intro-to-ggplot-R/bar-color-1.png" title="ggplot with blue bars" alt="ggplot with blue bars" width="90%" />

Or change the fill to bright green


```r
ggplot(data = boulder_precip,  aes(x = DATE, y = PRECIP)) +
    geom_bar(stat="identity", color="blue", fill="green")
```

<img src="{{ site.url }}/images/rfigs/courses/earth-analytics/02-time-series-data/get-to-know-r/2017-01-25-R06-intro-to-ggplot-R/barcolor2-1.png" title="ggplot with green bars" alt="ggplot with green bars" width="90%" />


## Add plot labels

You can add labels to your plots as well. Let's add a title, and x and y labels
using the glab() argument.


```r
ggplot(data = boulder_precip,  aes(x = DATE, y = PRECIP)) +
    geom_point(alpha = 0.9, aes(color=PRECIP)) +
    labs(x="Date",
      y="Precipitation (Inches)",
      title="Daily Precipitation (inches)",
      subtitle="Boulder, Colorado 2013")
```

<img src="{{ site.url }}/images/rfigs/courses/earth-analytics/02-time-series-data/get-to-know-r/2017-01-25-R06-intro-to-ggplot-R/add-title-1.png" title="ggplot with labels" alt="ggplot with labels" width="90%" />

## Finally, explore using themes


```r
ggplot(data = boulder_precip,  aes(x = DATE, y = PRECIP)) +
    geom_point(alpha = 0.9, aes(color = PRECIP)) +
    labs(x = "Date",
      y = "Precipitation (Inches)",
      title = "Daily Precipitation (inches)",
      subtitle = "Boulder, Colorado 2013") + theme_bw()
```

<img src="{{ site.url }}/images/rfigs/courses/earth-analytics/02-time-series-data/get-to-know-r/2017-01-25-R06-intro-to-ggplot-R/add-title-theme-1.png" title="ggplot with labels and themes" alt="ggplot with labels and themes" width="90%" />

Make font size for all labels larger by setting the base size!

```r
ggplot(data = boulder_precip,  aes(x = DATE, y = PRECIP)) +
    geom_point(alpha = 0.9, aes(color = PRECIP)) +
    labs(x = "Date",
      y = "Precipitation (Inches)",
      title = "Daily Precipitation (inches)",
      subtitle = "Boulder, Colorado 2013") + theme_bw(base_size = 9)
```

<img src="{{ site.url }}/images/rfigs/courses/earth-analytics/02-time-series-data/get-to-know-r/2017-01-25-R06-intro-to-ggplot-R/add-title-theme-font-1.png" title="ggplot with labels and themes" alt="ggplot with labels and themes" width="90%" />

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
