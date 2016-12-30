---
layout: single
title: "Plot and Subset Precipitation Data in R - 2013 Colorado Floods"
excerpt: "This lesson walks through the steps need to download and visualize
precipitation data in R to better understand the drivers and impacts of the 2013
Colorado floods."
authors: ['Leah Wasser', 'NEON Data Skills', 'Mariela Perignon']
lastModified: 2016-12-30
category: [course-materials]
class-lesson: ['hw-ggplot2-r']
permalink: /course-materials/earth-analytics/week-2/precip-in-r/
nav-title: 'Plot & Subset Precip Data R'
week: 2
sidebar:
  nav:
author_profile: false
comments: false
order: 3
---

In this lesson, we will learn how to import a larger dataset, and test our
skills cleaning and plotting the data.


<div class='notice--success' markdown="1">

## <i class="fa fa-graduation-cap" aria-hidden="true"></i> Learning Objectives

After completing this tutorial, you will be able to:

* Import a text file into R.
* Plot quantitative time series data using ggplot
* Ensure that NoData values do not interfere with quantitative analysis by setting them to NA in `R`.
* use the na.rm function argument when performing math with large datasets.
* subset data using the dplyr filter() function
* use dplyr pipes to filter data in R.

### What You'll Need

You need `R` and `RStudio` to complete this tutorial. Also you should have
an `earth-analytics` directory setup on your computer with a `/data`
directory with it.

* [How to Setup R / RStudio](/course-materials/earth-analytics/week-1/setup-r-rstudio/)
* [Setup your working directory](/course-materials/earth-analytics/week-1/setup-working-directory/)
* [Intro to the R & RStudio Interface](/course-materials/earth-analytics/week-1/intro-to-r-and-rstudio)

### R Libraries to Install:

* **ggplot2:** `install.packages("ggplot2")`
* **dplyr:** `install.packages("dplyr")`

### Data Download

[Download Precipitation Data](https://ndownloader.figshare.com/files/7283078)

</div>


## Work with Precipitation Data

## R Libraries

Let's get started by loading the ggplot2 library and making sure our working
directory is set. Be sure to also set `stringsAsFactors` to `FALSE` as shown below.


```r
# set your working directory to the earth-analytics directory
# setwd("working-dir-path-here")

# load packages
library(ggplot2) # efficient, professional plots
library(dplyr) # efficient data manipulation
##
## Attaching package: 'dplyr'
## The following objects are masked from 'package:stats':
##
##     filter, lag
## The following objects are masked from 'package:base':
##
##     intersect, setdiff, setequal, union

# set strings as factors to false for everything
options(stringsAsFactors = FALSE)
```


## Import Precipitation Data

We will use a precipitation dataset derived from data accessed through the
National Centers for Environmental Information (formerly
National Climate Data Center) Cooperative Observer Network (COOP)
station 050843 in Boulder, CO. The data time span is: 1 January 2003 through 31
December 2013.

We can use `read.csv()` to import the `.csv` file.


```r

# download the data
# download.file(url = "https://ndownloader.figshare.com/files/7283285",
#              destfile = "data/week2/805325-precip-dailysum_2003-2013.csv")

# import the data
# do we need to do something about NA VALUES?
boulder_daily_precip <- read.csv("data/week2/805325-precip-dailysum_2003-2013.csv",
         header = TRUE)
## Warning in file(file, "rt"): cannot open file 'data/week2/805325-precip-
## dailysum_2003-2013.csv': No such file or directory
## Error in file(file, "rt"): cannot open the connection


# view first 6 lines of the data
head(boulder_daily_precip)
## Error in head(boulder_daily_precip): object 'boulder_daily_precip' not found

# view structure of data
str(boulder_daily_precip)
## Error in str(boulder_daily_precip): object 'boulder_daily_precip' not found

# are there any unusual / No data values?
summary(boulder_daily_precip$DAILY_PRECIP)
## Error in summary(boulder_daily_precip$DAILY_PRECIP): object 'boulder_daily_precip' not found
max(boulder_daily_precip$DAILY_PRECIP)
## Error in eval(expr, envir, enclos): object 'boulder_daily_precip' not found
```


## About the Data

Viewing the structure of these data, we can see that different types of data are included in
this file.

* **STATION** and **STATION_NAME**: Identification of the COOP station.
* **ELEVATION, LATITUDE** and **LONGITUDE**: The spatial location of the station.
* **DATE**: The date when the data were collected in the format: YYYYMMDD. Notice that DATE is
currently class `chr`, meaning the data is interpreted as a character class and
not as a date.
* **DAILY_PRECIP**: The total precipitation in inches. Important: the metadata
notes that the value 999.99 indicates missing data. Also important,
hours with no precipitation are not recorded.
* **YEAR**: the year the data were collected
* **JULIAN**: the JULIAN DAY the data were collected.


Additional information about the data, known as metadata, is available in the
<a href="https://ndownloader.figshare.com/files/7283453">PRECIP_HLY_documentation.pdf</a>.
The metadata tell us that the noData value for these data is 999.99. IMPORTANT:
we have modified these data a bit for ease of teaching and learning. Specifically,
we've aggregated the data to represent daily sum values and added some noData
values to ensure you learn how to clean them!

You can download the original complete data subset with additional documentation
<a href="https://figshare.com/articles/NEON_Remote_Sensing_Boulder_Flood_2013_Teaching_Data_Subset_Lee_Hill_Road/3146284">here. </a>

<div class="notice--warning" markdown="1">

## <i class="fa fa-pencil-square-o" aria-hidden="true"></i> Challenge

Using everything you've learned in the previous lessons, import the data,
clean it up by assigning noData values to NA and making sure the dates are stored
in the correct class. When you are done, plot it using `ggplot()`. Be sure to
include a TITLE, and label the X and Y axes.

Some notes to help you along:

* Date: be sure to take of of the date format when you import the data.
* NoData Values: We know that the no data value = 999.99. We can account for this
when we read in the data. Remember how?

Your final plot should look something like the plot below.
</div>





```
## Error in file(file, "rt"): cannot open the connection
## Error in as.Date(boulder_daily_precip$DATE, format = "%m/%d/%y"): object 'boulder_daily_precip' not found
## Error in ggplot(data = boulder_daily_precip, aes(DATE, DAILY_PRECIP)): object 'boulder_daily_precip' not found
## Error in eval(expr, envir, enclos): object 'prec_plot_daily' not found
```

<i fa fa-star></i>**Data Tip:**For a more thorough review of date/time classes, see the NEON tutorial
<a href="http://www.neondataskills.org/R/time-series-convert-date-time-class-POSIX/" target="_blank"> *Dealing With Dates & Times in R - as.Date, POSIXct, POSIXlt*</a>.
{: .notice }





<div class="notice--warning" markdown="1">

## <i class="fa fa-pencil-square-o" aria-hidden="true"></i> Challenge

Take a close look at the plot.

* What does each point represent?
* What are the minimum and maximum precipitation values for the 10 year span?

</div>

## Subset the Data

If we wanted to zoom in and look at some data over a smaller time period, we can
subset it. Let create a subset of data for the time period around the flood between 15
August to 15 October 2013. We will use the `filter()` function in the `dplyr` package
to do this.

## Introduction to the Pipe %<%

Pipes let you take the output of one function and send it directly to the next,
which is useful when you need to do many things to the same data set. Pipes in R
look like %>% and are made available via the magrittr package, installed
automatically with dplyr.

If we want to subset our data, we could use the following syntax

`new_data <- filter(boulder_daily_precip, (DATE >= as.Date('2013-08-15') & DATE <= as.Date('2013-10-15')))`

When we code like this we have to create intermediate data frame outputs. however,
pipes allow us to link multiple steps in one line.



```r

# subset 2 months around flood
precip_boulder_AugOct <- boulder_daily_precip %>%
                        filter(DATE >= as.Date('2013-08-15') & DATE <= as.Date('2013-10-15'))
## Error in eval(expr, envir, enclos): object 'boulder_daily_precip' not found
```

In the code above, we use the pipe to send the boulder_daily_precip data through
a filter setp. In that filter step, we filter our only the rows withing the
date range that we specified. Since %>% takes the object on its left and passes
it as the first argument to the function on its right, we don’t need to explicitly include it as an argument to the filter() function.



```r
# check the first & last dates
min(precip_boulder_AugOct$DATE)
## Error in eval(expr, envir, enclos): object 'precip_boulder_AugOct' not found
max(precip_boulder_AugOct$DATE)
## Error in eval(expr, envir, enclos): object 'precip_boulder_AugOct' not found

# create new plot
precPlot_flood2 <- ggplot(data=precip_boulder_AugOct, aes(DATE,DAILY_PRECIP)) +
  geom_bar(stat="identity") +
  xlab("Date") + ylab("Precipitation (inches)") +
  ggtitle("Daily Total Precipitation Aug - Oct 2013 for Boulder Creek")
## Error in ggplot(data = precip_boulder_AugOct, aes(DATE, DAILY_PRECIP)): object 'precip_boulder_AugOct' not found

precPlot_flood2
## Error in eval(expr, envir, enclos): object 'precPlot_flood2' not found
```


<div class="notice--warning" markdown="1">

## <i class="fa fa-pencil-square-o" aria-hidden="true"></i> Challenge

Create a subset from the same dates in 2012 to compare to the 2013 plot.
Use the ylim() argument to ensure the y axis range is the SAME as the previous
plot - from 0 to 10".

How different was the rainfall in 2012?

HINT: type ?lims in the console to see how the xlim and ylim arguments work.


</div>


```
## Error in eval(expr, envir, enclos): object 'boulder_daily_precip' not found
## Error in ggplot(data = precip_boulder_AugOct_2012, aes(DATE, DAILY_PRECIP)): object 'precip_boulder_AugOct_2012' not found
## Error in eval(expr, envir, enclos): object 'precPlot_flood_2012' not found
```
