---
layout: single
title: "For loops  "
excerpt: " ."
authors: ['Max Joseph', 'Software Carpentry',  'Leah Wasser']
modified: '2017-10-03'
category: [courses]
class-lesson: ['automating-your-science-r']
permalink: /courses/earth-analytics/automate-science-workflows/loops-r/
nav-title: 'For loops arguments'
week: 6
course: "earth-analytics"
sidebar:
  nav:
author_profile: false
comments: true
topics:
  reproducible-science-and-programming: ['literate-expressive-programming', 'functions']
order: 5
redirect_from:
---



## Automating tasks with loops 

 
In the previous lessons, you learned how to create functions in R. Functions:

1. reduce the number of lines / clutter in your code
1. to make code more expressive and better documented
1. reduce memory consumed by intermediate operations 

In this lesson we will learn how to create loops to perform repeated tasks. Loops 
can be combined with functions to create powerful algorithms. 
 
As the name suggests a loop is a sequence of operations that are performed over 
and over in some order.  


```r
for (variable in collection) {
  do things with variable
}
```

We can name the loop variable anything we like (with a few restrictions, e.g. 
the name of the variable cannot start with a digit). in is part of the for syntax. 
Note that the condition (variable in collection) is enclosed in parentheses, 
and the body of the loop is enclosed in curly braces { }. For a single-line 
loop body, as here, the braces aren’t needed, but it is good practice to include 
them as we did.


```r

vowels <- c("a", "e", "i", "o", "u")
for (v in vowels) {
  print(v)
}
## [1] "a"
## [1] "e"
## [1] "i"
## [1] "o"
## [1] "u"
```


Here’s another loop that repeatedly updates a variable called `len`:


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

It’s worth tracing the execution of this little program step by step. Since there 
are five elements in the vector vowels, the statement inside the loop will be 
executed five times. The first time around, len is zero (the value assigned to it 
on line 1) and v is "a". The statement adds 1 to the old value of len, producing 
1, and updates len to refer to that new value. The next time around, v is "e" 
and len is 1, so len is updated to be 2. After three more updates, len is 5; 
since there is nothing left in the vector vowels for R to process, the loop 
finishes.

Note that a loop variable is just a variable that’s being used to record progress 
in a loop. It still exists after the loop is over, and we can re-use variables 
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

## Using loops to manipulate data

Above we covered the basics of how a loop works. Next, let's use a loop to 
manipulate some data that we worked with in the first weeks of this course. 
To being, let's load libraries that we used for the time series data during week 2. 


```r
library(lubridate)
library(ggplot2)
library(dplyr)
# playing with some automation ideas
# setwd("~/earth-analytics")
```


Next, read in the precip data and fix the date so it's a date format.


```r
boulder_precip <- read.csv("data/week_02/precipitation/805325-precip-daily-2003-2013.csv")

# fix the date
boulder_precip <- boulder_precip %>%
  mutate(DATE = as.POSIXct(DATE, format = "%Y%m%d %H:%M"))
```

## Loop through dates

We can loop through dates in our data in the same way we loop through letters
or other numbers. First, we grab the `min()` and `max()` date values for our 
`boulder_precip` object.


```r
min_yr <- min(year(boulder_precip$DATE))
max_yr <- max(year(boulder_precip$DATE))
max_yr
## [1] 2013
min_yr
## [1] 2003

# a for loop sequences through a series of things. 
# below we sequence through the min and max years found in our data
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


## Write loops that perform multiple tasks

Next, let's create a for loop that does the following:

1. filters the data by year: select rows where the year = the current year in the loop
1. creates a unique csv file for that year: with a unique name that contains the year

To build your `for loop`, first write out the pseudo code, then fill in the functions
needed to execute the code. Let's start with the pipe required to subset our data
our for a particular year


```r
# the year function grabs just the year from a date class object
# ==
# define the year that you want to filter out
the_year =  2003
a_year <- boulder_precip %>%
    filter(year(DATE) == the_year)

head(a_year)
##       STATION    STATION_NAME ELEVATION LATITUDE LONGITUDE
## 1 COOP:050843 BOULDER 2 CO US      1650    40.03    -105.3
## 2 COOP:050843 BOULDER 2 CO US      1650    40.03    -105.3
## 3 COOP:050843 BOULDER 2 CO US      1650    40.03    -105.3
## 4 COOP:050843 BOULDER 2 CO US      1650    40.03    -105.3
## 5 COOP:050843 BOULDER 2 CO US      1650    40.03    -105.3
## 6 COOP:050843 BOULDER 2 CO US      1650    40.03    -105.3
##                  DATE HPCP Measurement.Flag Quality.Flag
## 1 2003-01-01 01:00:00  0.0                g             
## 2 2003-02-01 01:00:00  0.0                g             
## 3 2003-02-02 19:00:00  0.2                              
## 4 2003-02-02 22:00:00  0.1                              
## 5 2003-02-03 02:00:00  0.1                              
## 6 2003-02-05 02:00:00  0.1
```

Next, practice writing a `.csv` file to your hard drive.

We can use `paste0()` to paste together a file name that suits our purposes.


```r
# create a file name using paste0
paste0(the_year , "_precip.csv")
## [1] "2003_precip.csv"
```

Then `write.csv()` to write out a csv for that year.


```r
write.csv(a_year, file = paste0(the_year, "_precip.csv"))
```

<div class="notice--warning" markdown="1">

## <i class="fa fa-pencil-square-o" aria-hidden="true"></i> Challenge

### Write a for loop that created individual files for each year

Put everythign that you learned above together to create a for loop that:

1. loops through each year
2. `filter()` the data to include only the rows that are for that year.
3. write a csv to your hard drive with a file name that contains: `year_precip.csv`. You will use `paste0()` to create your filename.

Now let's put everything together into a loop


```r
# start for loop - loop through min to max years (min:max)
for (year in min_yr:max_yr) {
  # filter data by year using pipes and filter
  
  # export the data to a csv file 
}
```

</div>


```
## Error in is.data.frame(x): object 'this_year' not found
```


## This could be homework??

<div class="notice--warning" markdown="1">

## <i class="fa fa-pencil-square-o" aria-hidden="true"></i> Challenge

Write a function that converts temperature in inches (the units of our data) to 
mm. The calculate is very simple, but it's still useful to write a function.

Be sure to document your function with what it does, inputs and outputs.
Don't forget to specify the class of each input argument and the output value. 
</div>



Next lesson -- functions -- write a function that checks to see if a directory exists
and if it doesn't exist, create it.


# write a function to convert inches to mm <previous lesson??>
1 inch is equal to 25.4mm




# Steps
# 1. Define the directory
# 2. check to see if the directory already exists
# 3. If the directory doesn't exist, then create the directory. Recursive means it will create the directory and all directories needed above it!

new_dir <- "data/week_06/outputs/precip_in/"
if (!dir.exists(new_dir)) {
  dir.create(new_dir, recursive = TRUE)
}


# read things in
all_precip_files <- list.files(".", pattern = "*.csv")

# could create a for loop and loop through everything

for (file in all_precip_files) {
  print(file)
}


# what if we wanted to do the following

1. open each file,
2. summarize the data by total daily precip
3. add a precip column in inches
4. create a new fils




```r
# get a list of all csv files 
all_files <- list.files(".", pattern = "*.csv")

# open a file 

# add a new column to the file that converts precip in inches to mm
# summarize by day?

# write the csv's out to a new directory 
```

