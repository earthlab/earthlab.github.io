---
layout: single
authors: ['Max Joseph', 'Leah Wasser']
category: courses
title: 'Use Tidyverse group_by and summarise to Manipulate Data in R'
attribution: ''
excerpt: 'Learn how to write pseudocode to plan our your approach to working with data. Then use Tidyverse functions including group_by and summarise to implement your plan.'
dateCreated: 2018-01-29
modified: '2018-01-31'
nav-title: 'Summarise Data'
sidebar:
  nav:
module: "clean-coding-tidyverse-intro"
permalink: /courses/clean-coding-tidyverse-intro/summarise-data-in-R-tidyverse/
author_profile: false
comments: true
order: 3
topics:
  reproducible-science-and-programming: ['literate expressive programming']
---

{% include toc title="In this lesson" icon="file-text" %}

<!--  This is the top block with the learning objectives (LO) -->
<div class='notice--success' markdown="1">

## <i class="fa fa-graduation-cap" aria-hidden="true"></i> Learning objectives
At the end of this activity, you will be able to:

* Use the `group_by`, `summarise` and `mutate` functions to manipulate data in `R`.
* Use `readr` to open tabular data in `R`.
* Access data stored in the cloud via a URL in `R`.
* Work with no data values in `R`.

## <i class="fa fa-check-square-o fa-2" aria-hidden="true"></i> What you need

We recommend that you have `R` and `R Studio` setup to complete this lesson.
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

All you have to get started with is a list of URL's - one for each data file.
Each data file is in `.csv` format. You can find this list of url's in the
`data/` directory of the
<a href="https://github.com/earthlab/version-control-hot-mess/" target="_blank">version-control-hot-mess</a>
Github repository that you cloned or downloaded for this workshop.

## Data Exploration

To begin this lesson you will explore your data.

###  What Is the Length of Record For Each Site?

Your end goal in this workshop is to create plots of precipitation data over time
by station and month / year. However, you have yet to explore your data. To begin,
open the first url in your list of urls. Remember that list is located:
`data/data_urls.csv`.

Explore your data and calculate the length of record for each site in the data.

For this activity you will use the `readr` library to import your data.
`Readr` is a powerful library that is able to parse and import in the correct
format, tabular data. `Readr` will attempt to convert known character formats
including date/times, numbers and other formats into the correct `R` class.


```r
# load libraries
library(readr)
library(ggplot2)
```

Next, open the file that contains url's to the data.
Note that we are using data that are stored on Amazon Web Services (AWS)
servers.


```r
# max note that all_paths doesn't print nicely with the class of each column as i'd like it to.. is there a good way to do this as str is messy too?

# import data using readr
all_paths <- read_csv("data/data_urls.csv")
## Parsed with column specification:
## cols(
##   url = col_character()
## )
all_paths
## # A tibble: 33 x 1
##                                                                            url
##                                                                          <chr>
##  1 https://s3-us-west-2.amazonaws.com/earthlab-teaching/vchm/My_Data2003-bould
##  2 https://s3-us-west-2.amazonaws.com/earthlab-teaching/vchm/My_Data2003-denve
##  3 https://s3-us-west-2.amazonaws.com/earthlab-teaching/vchm/My_Data2003-lyons
##  4 https://s3-us-west-2.amazonaws.com/earthlab-teaching/vchm/My_Data2004-bould
##  5 https://s3-us-west-2.amazonaws.com/earthlab-teaching/vchm/My_Data2004-denve
##  6 https://s3-us-west-2.amazonaws.com/earthlab-teaching/vchm/My_Data2004-lyons
##  7 https://s3-us-west-2.amazonaws.com/earthlab-teaching/vchm/My_Data2005-bould
##  8 https://s3-us-west-2.amazonaws.com/earthlab-teaching/vchm/My_Data2005-denve
##  9 https://s3-us-west-2.amazonaws.com/earthlab-teaching/vchm/My_Data2005-lyons
## 10 https://s3-us-west-2.amazonaws.com/earthlab-teaching/vchm/My_Data2006-bould
## # ... with 23 more rows
# grab the first url from the list of urls
all_paths[1,1]
## # A tibble: 1 x 1
##                                                                           url
##                                                                         <chr>
## 1 https://s3-us-west-2.amazonaws.com/earthlab-teaching/vchm/My_Data2003-bould
```

### Open a File with readr::read_csv

Next, open the data contained in the first url in the `.csv` file that you
just imported above.


```r
# grab first url from the file
first_csv <- all_paths$url[1]
# open the first data file using readr:read_csv
year_one <- read_csv(first_csv)
## Parsed with column specification:
## cols(
##   STATION = col_character(),
##   STATION_NAME = col_character(),
##   ELEVATION = col_double(),
##   LATITUDE = col_double(),
##   LONGITUDE = col_double(),
##   DATE = col_datetime(format = ""),
##   HPCP = col_character(),
##   `Measurement Flag` = col_character(),
##   `Quality Flag` = col_character()
## )
```

Note that when you use `readr::read_csv`, it returns the data class that
each column was converted to. Above, notice that the lat, lon, elevation
are all of type double - which is a number with decimal places.

The `DATE` field was converted to a proper `datetime` class.

The `HPCP` column stores precipitation. This is the data that you ultimately
want to plot. Notice that those data were not converted to a numeric format.
You will explore that issue later in this lesson.

### What is Pseudocode?

Before you start to code, think about your goals. Rather than simply jumping
into `R` and coding (which is what we all want to do initially!), plan things out.

Write down that steps associated with what you wish to accomplish - in
english. Writing out the steps required to complete an operation is
called **pseudocode**. **Pseudocode** is very useful for organization coding
operations. It allows you to think through what you wish to accomplish and
the most efficient way to go about it BEFORE you write your code.

GOAL: I want to calculate the total time in days that is represented
in my precipitation data for colorado for each station or site.

## Write Pseudo Code

Once your goal is clear, write out the steps that you will need to implement
in order to achieve your goal. It's ok if you don't know all of the functions
yet to implement this. Organize first, look up functions second.


```r
## Below is the pseudocode for calculating length of record

# 1. open up the file containing the data

# 2. group by data by the station name field

# 3. calculate the total time by subtracting the min date from the max date.

```

Once your pseudocode is written out, it's time to associated `R` functions
with each step. To do that you will use the `tidyverse`.

### Get Started with Tidyverse

To get going with tidyverse, there are a few things that you should know.

1. The pipe `%>%` is fundamental to tidyverse. The pipe is a way to connect a sequence of operations together. Pipes are efficient because they:

* Don't create intermediate outputs saving memory
* Combine operations into a clean chunk of code
* Allow you to send one output as an input to the next operation.

When combined with tidyverse functions, you also gain extremely
expressive code. Pipes generally are often used with a `data.frame` object and
are written as follows:


```r
my_data_frame %>%
  perform_some_operation
```

> Pipes are a powerful tool for clearly expressing a sequence of multiple
> operations. - Hadley Wickham, R for Data Science

## R Tidyverse summarise and group_by Functions

The next operations that you need to know are the `summarise` and `group_by`
functions.

* `group_by`: As the name suggest, `group_by` allows you to group by a particular
variable or variables. You can group by as many variables as you want
(within reason)

* `summarise`: `summarise` creates a new `data.frame` containing calculated summary information about a grouped variable.

`group_by` and `summarise` are two of the most commonly used tidyverse functions.
An example of using them is below:


```r
# group_by / summarise workflow example
my_data_frame %>%
  group_by(total_precip_col) %>%
  summarise(avg_precip = mean(total_precip_col))
```

### Calculate Total Days of Observations

You can calculate the total number of days represented in your data by
subtracting the max date from the min date for each station. Lucky for us,
our dates were stored in a friendly format that `readr` could understand and
convert to a `datetime` class.

Your code to calculate length of record will thus look something like this:


```r

# 1. open up the file containing the data
read_csv(first_csv) %>%
# 2. group by data by the station name field
  group_by(STATION_NAME) %>%
# 3. calculate the total time by subtracting the min date from the max date.
  summarize(total_days = max(DATE) - min(DATE))
## Parsed with column specification:
## cols(
##   STATION = col_character(),
##   STATION_NAME = col_character(),
##   ELEVATION = col_double(),
##   LATITUDE = col_double(),
##   LONGITUDE = col_double(),
##   DATE = col_datetime(format = ""),
##   HPCP = col_character(),
##   `Measurement Flag` = col_character(),
##   `Quality Flag` = col_character()
## )
## # A tibble: 4 x 2
##      STATION_NAME    total_days
##             <chr>        <time>
## 1 BOULdER 2 CO US   0.0000 secs
## 2 BOULDEr 2 CO US   0.0000 secs
## 3 BOULDER 2 cO US 113.5417 secs
## 4 BOULDER 2 CO US 334.6250 secs
```

<div class="notice--warning" markdown="1">

## <i class="fa fa-pencil-square-o" aria-hidden="true"></i> On Your Own (OYO)

Create a plot of precipitation over time using the `.csv` file that is access
through the first URL in the list.  This is the same file we've been using throughout
this lesson. To help you create your plot, an example of creating a scatter plot
with ggplot and sending a `data.frame` to `ggplot` is below.


```r

# Syntax to create scatter plot using ggplot
data.frame  %>%
  ggplot(aes(x = date_field_here, y = precipitation_field_here)) +
  geom_point() + theme_bw()
```

Note that the code above does NOT create the plot below! It provides you with
the syntax that you need to create the plot.


```
## Parsed with column specification:
## cols(
##   STATION = col_character(),
##   STATION_NAME = col_character(),
##   ELEVATION = col_double(),
##   LATITUDE = col_double(),
##   LONGITUDE = col_double(),
##   DATE = col_datetime(format = ""),
##   HPCP = col_character(),
##   `Measurement Flag` = col_character(),
##   `Quality Flag` = col_character()
## )
```

<img src="{{ site.url }}/images/rfigs/workshops/clean-code-tidyverse-r/2018-01-29-clcode-03-summarize-data-using-tidyverse-r/precip-plot-1.png" title="plot of chunk precip-plot" alt="plot of chunk precip-plot" width="90%" />


</div>



<div class="notice--info" markdown="1">

## Additional resources

You may find the materials below useful as an overview of what we cover
during this workshop:

* <a href="http://r4ds.had.co.nz/pipes.html#introduction-11" target="_blank">Introduction to Pipes - R for Data Science Book</a>

</div>
