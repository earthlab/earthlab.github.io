---
layout: single
title: "How to Convert Day of Year to Year, Month, Day in R"
excerpt: "Learn how to convert a day of year value to a normal date format in R. "
authors: ['Leah Wasser']
modified: '2018-01-10'
category: [courses]
class-lesson: ['how-to-hints-week8']
permalink: /courses/earth-analytics/multispectral-remote-sensing-modis/convert-day-of-year-to-date-in-R/
nav-title: 'Day of Year to Date'
week: 8
course: "earth-analytics"
sidebar:
  nav:
author_profile: false
comments: true
order: 5
topics:
lang-lib:
  r: []

---

{% include toc title="In This Lesson" icon="file-text" %}

<div class='notice--success' markdown="1">

## <i class="fa fa-graduation-cap" aria-hidden="true"></i> Learning Objectives

After completing this tutorial, you will be able to:

* Covert day of year values to normal date format in R.

## <i class="fa fa-check-square-o fa-2" aria-hidden="true"></i> What You Need

You will need a computer with internet access to complete this lesson and the
data for week 6 of the course.

[<i class="fa fa-download" aria-hidden="true"></i> Download Week 6 Data (~500 MB)](https://ndownloader.figshare.com/files/7677208){:data-proofer-ignore='' .btn }

</div>

Landsat data are often saved using a date that includes the year and the day of
year. You can quickly convert day of year to date as follows:

Here is your file name:

`LC80340322016189-SC20170128091153`

Looking at the name, you can see that the data were collected 2016-189. This
references the 189th day of the year in 2016.

You can quickly convert this in `R`:



```r
# note that R uses a 0 based index for dates only
# this means it starts counting at 0 rather than 1 when working with dates
as.Date(0, origin = "2016-01-01")
## [1] "2016-01-01"
# note that R uses a 0 based index
as.Date(1, origin = "2016-01-01")
## [1] "2016-01-02"

# figure out the date for day 189
as.Date(189, origin = "2016-01-01")
## [1] "2016-07-08"
```
