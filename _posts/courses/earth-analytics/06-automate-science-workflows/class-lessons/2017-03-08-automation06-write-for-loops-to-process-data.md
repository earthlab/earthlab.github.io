---
layout: single
title: "Create For Loops"
excerpt: "Learn how to write a for loop to process a set of .csv format text files in R. "
authors: ['Leah Wasser', 'Max Joseph']
modified: '2018-01-10'
category: [courses]
class-lesson: ['automating-your-science-r']
permalink: /courses/earth-analytics/automate-science-workflows/create-for-loops-r/
nav-title: 'Create For Loops'
week: 6
course: "earth-analytics"
sidebar:
  nav:
author_profile: false
comments: true
topics:
  reproducible-science-and-programming: ['literate-expressive-programming', 'functions']
order: 6
redirect_from:
---

{% include toc title="In This Lesson" icon="file-text" %}




<div class='notice--success' markdown="1">

## <i class="fa fa-graduation-cap" aria-hidden="true"></i> Learning Objectives

After completing this tutorial, you will be able to:

* Write a `for loop` in `R`.

## <i class="fa fa-check-square-o fa-2" aria-hidden="true"></i> What You Need

You will need a computer with internet access to complete this lesson.

</div>

## Automate Tasks With Loops

In this lesson you will learn how to create loops to perform repeated tasks. Loops
can be combined with functions to create powerful algorithms.

As the name suggests a loop is a sequence of operations that are performed over
and over in some order using a loop `variable`.


```r
for (variable in collection) {
  do things with variable
}
```

You can name the loop `variable` anything you like with a few restrictions:

* the name of the variable cannot start with a number

A few notes about the loop syntax:

1. The loop condition `(variable in collection)` is enclosed in parentheses `()`.
2. The body of the loop is enclosed in curly braces `{ }`.

<i class="fa fa-star" aria-hidden="true"></i>**Data Tip**The curly braces aren't
required for a single-line loop like the one that you created above. However, it is good
practice to always include them.
{: .notice--success }

Below you can see how a `for loop` works. In this case, you provide a vector of
letters. Then you tell `R` to loop through each letter.


```r
# Create a vector of letters called vowels
vowels <- c("a", "e", "i", "o", "u")
# loop through each element in the vector and print out the letter
for (v in vowels) {
  print(v)
}
## [1] "a"
## [1] "e"
## [1] "i"
## [1] "o"
## [1] "u"
```

Here's another loop that repeatedly updates a variable called `len`:


```r
len <- 0
vowels <- c("a", "e", "i", "o", "u")
for (v in vowels) {
  len <- len + 1
  print(len)
}
## [1] 1
## [1] 2
## [1] 3
## [1] 4
## [1] 5
# Number of vowels
len
## [1] 5
```

It's worth tracing the execution of this little program step by step. Since there
are five elements in the vector vowels, the statement inside the loop will be
executed five times. The first time around, `len` is zero (the value assigned to it
before the loop begins) and v is "a". The statement adds 1 to the old value of `len`, producing
1, and updates `len` to refer to that new value. The next time around, v is "e"
and `len` is 1, so `len` is updated to be 2. After three more updates, `len` is 5;
since there is nothing left in the vector vowels for R to process, the loop
finishes.

Note that a loop variable is just a variable that's being used to record progress
in a loop. It still exists after the loop is over, and you can re-use variables
previously defined as loop variables as well:


```r
letter <- "z"
for (letter in c("a", "b", "c")) {
  print(letter)
}
## [1] "a"
## [1] "b"
## [1] "c"
```

## Using Loops to Manipulate Data

Above you covered the basics of how a loop works. Next, let's use a loop to
manipulate some data that you worked with in the first weeks of this course.
To being, let's load libraries that you used for the time series data during week 2.


```r
library(lubridate)
library(ggplot2)
library(dplyr)
# playing with some automation ideas
# setwd("~/earth-analytics")
```

Next, read in the `/precipitation/805325-precip-daily-2003-2013.csv` file that
contains precipitation data. Fix the date so it's a date class.


```r
boulder_precip <- read.csv("data/week-02/precipitation/805325-precip-daily-2003-2013.csv")

# fix the date
boulder_precip <- boulder_precip %>%
  mutate(DATE = as.POSIXct(DATE, format = "%Y%m%d %H:%M"))
```

## Loop Through Dates

You can loop through dates in your data in the same way you loop through letters
or other numbers. First, you grab the `min()` and `max()` date values for your
`boulder_precip` object.

Use the `year()` function from the `lubridate` package to grab just the 4 digit year
from a date class object.

`year(boulder_precip$DATE)`

Use min to grab the lowest or oldest year.

`min(year(boulder_precip$DATE))`


```r
min_yr <- min(year(boulder_precip$DATE))
max_yr <- max(year(boulder_precip$DATE))
max_yr
## [1] 2013
min_yr
## [1] 2003

# a for loop sequences through a series of things.
# below you sequence through the min and max years found in your data
for (i in min_yr:max_yr) {
  print(i)
}
## [1] 2003
## [1] 2004
## [1] 2005
## [1] 2006
## [1] 2007
## [1] 2008
## [1] 2009
## [1] 2010
## [1] 2011
## [1] 2012
## [1] 2013
```


## Write Loops That Perform Multiple Tasks

Next, let's create a `for loop` that does the following:

1. Filters the data by year: select rows where the year = the current year in the loop
1. Creates a unique `.csv` file for that year: with a unique name that contains the year

To build your `for loop`, first write out the pseudo code, then fill in the functions
needed to execute the code. Let's start with the pipe required to subset your data for a particular year


```r
# the year function grabs just the year from a date class object
# ==
# define the year that you want to filter out
the_year =  2003
a_year <- boulder_precip %>%
    filter(year(DATE) == the_year)

head(a_year)
##       STATION    STATION_NAME ELEVATION LATITUDE LONGITUDE
## 1 COOP:050843 BOULDER 2 CO US    1650.5 40.03389 -105.2811
## 2 COOP:050843 BOULDER 2 CO US    1650.5 40.03389 -105.2811
## 3 COOP:050843 BOULDER 2 CO US    1650.5 40.03389 -105.2811
## 4 COOP:050843 BOULDER 2 CO US    1650.5 40.03389 -105.2811
## 5 COOP:050843 BOULDER 2 CO US    1650.5 40.03389 -105.2811
## 6 COOP:050843 BOULDER 2 CO US    1650.5 40.03389 -105.2811
##                  DATE HPCP Measurement.Flag Quality.Flag
## 1 2003-01-01 01:00:00  0.0                g             
## 2 2003-02-01 01:00:00  0.0                g             
## 3 2003-02-02 19:00:00  0.2                              
## 4 2003-02-02 22:00:00  0.1                              
## 5 2003-02-03 02:00:00  0.1                              
## 6 2003-02-05 02:00:00  0.1
```

Next, practice writing a `.csv` file to your hard drive.

You can use `paste0()` to paste together a file name that suits your purposes.


```r
# create a file name using paste0
paste0("data/week-06/precip-", the_year, ".csv")
## [1] "data/week-06/precip-2003.csv"
```

Then `write.csv()` to write out a `.csv` for that year.


```r
# write .csv file to your data directory.
write.csv(a_year, file = paste0("data/week-06/precip-", the_year, ".csv"))
```

Oops. Looks like you don't have a week-06 directory yet. You can make one using the
`dir.create()`.


```r
# create new directory - if you already have this directory then you will
# get a warning message like the one below.
dir.create("data/week_06")
## Warning in dir.create("data/week_06"): 'data/week_06' already exists
```

<div class="notice--warning" markdown="1">

## <i class="fa fa-pencil-square-o" aria-hidden="true"></i> Challenge

### Write a For Loop That Creates Individual Files for Each Year

Put everything that you learned above together to create a `for loop` that:

1. Loops through each year.
2. `filter()`s the data to include only the rows that are for that year.
3. Adds a month column using `lubridate::month()`.
3. Writes a `.csv` file to your hard drive with a file name that contains: `year_precip.csv`.
  * Use `paste0()` to create your filename.

Now let's put everything together into a loop


```r
# start for loop - loop through min to max years (min:max)
for (year in min_yr:max_yr) {
  # filter data by year using pipes and filter

  # export the data to a .csv file
}
```

</div>


