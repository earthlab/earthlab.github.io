---
layout: single
authors: ['Max Joseph', 'Leah Wasser']
category: courses
title: 'Use tidyverse group_by and summarise to Manipulate Data in R'
attribution: ''
excerpt: 'Learn how to write pseudocode to plan our your approach to working with data. Then use tidyverse functions including group_by and summarise to implement your plan.'
dateCreated: 2018-01-29
modified: '2019-08-24'
nav-title: 'Summarize Data'
sidebar:
  nav:
module: "clean-coding-tidyverse-intro"
permalink: /workshops/clean-coding-tidyverse-intro/summarise-data-in-R-tidyverse/
author_profile: false
comments: true
order: 3
topics:
  reproducible-science-and-programming: ['literate-expressive-programming']
---


{% include toc title="In this lesson" icon="file-text" %}

<!--  This is the top block with the learning objectives (LO) -->
<div class='notice--success' markdown="1">

## <i class="fa fa-graduation-cap" aria-hidden="true"></i> Learning objectives
At the end of this activity, you will be able to:

* Use the `group_by`, `summarise` and `mutate` functions to manipulate data 
in `R`.
* Use `readr` to open tabular data in `R`.
* Read CSV data files by specifying a URL in `R`.
* Work with no data values in `R`.

## <i class="fa fa-check-square-o fa-2" aria-hidden="true"></i> What you need

We recommend that you have `R` and `RStudio` setup to complete this lesson.
You will also need the following `R` packages:

* ggplot2
* dplyr
* readr
* lubridate

</div>


[<i class="fa fa-download" aria-hidden="true"></i> Overview of clean code ]({{ site.url }}/courses/earth-analytics/automate-science-workflows/write-efficient-code-for-science-r/){:data-proofer-ignore='' .btn }


## About the Data

The data that you will use for this workshop is stored in the cloud. It
contains precipitation information over time for several locations in Colorado.

All you have to get started with is a list of URLs - one for each data file.
Each data file is in `.csv` format. You can find this list of URLs in the
`data/` directory of the
<a href="https://github.com/earthlab/version-control-hot-mess/" target="_blank">version-control-hot-mess</a>
GitHub repository that you cloned or downloaded for this workshop.

## Data Exploration

To begin this lesson you will explore your data.

###  What Is the Length of Record For Each Site?

Your end goal in this workshop is to create plots of precipitation data over 
time by station and month / year. However, you have yet to explore your data. 
To begin, open the first url in csv file containing urls of the data locations. 
Remember that file is located in `data/data_urls.csv`.

Explore your data and calculate the length of record for each site in the data.

For this activity you will use the `readr` library to import your data - a 
powerful library for parsing and reading tabular data. The `readr` package will 
attempt to convert known character formats including date/times, numbers and 
other formats into the correct `R` class.


```r
# load libraries
library(readr)
library(ggplot2)
library(dplyr)
```

Next, open the file that contains URLs to the data.
Note that we are using data that are stored on Amazon Web Services (AWS)
servers.

















