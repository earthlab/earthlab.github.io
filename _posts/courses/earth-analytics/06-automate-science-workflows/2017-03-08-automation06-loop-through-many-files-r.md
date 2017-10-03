---
layout: single
title: "For loops  "
excerpt: " ."
authors: ['Max Joseph', 'Software Carpentry',  'Leah Wasser']
modified: '2017-10-03'
category: [courses]
class-lesson: ['automating-your-science-r']
permalink: /courses/earth-analytics/automate-science-workflows/loop-through-a-set-of-files-r/
nav-title: 'For loops arguments'
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


## Work with directories of files

In the previous lesson, we broke up a single `.csv` file into a set of csv files -
one for each year. However, what if we wanted to modify each of those .csv files
in some way? How would we go about it?

One option could be to open each file individually and then manipulate it.

This is:

1. Tedious & inefficient,
1. Generates lots of redundant lines of code
1. Leaves room for lots of error



```r
year1 <- read.csv("2003_precip.csv")
year2 <- read.csv("2004_precip.csv")
year3 <- read.csv("2005_precip.csv")
year4 <- read.csv("2006_precip.csv")
year5 <- read.csv("2007_precip.csv")
year6 <- read.csv("2008_precip.csv")

```

Another option is to generate a list of all `.csv` files in our directory. Using that
list, we can then create a for loop. OR, we can also use an `R`, `apply` function if
we have build the correct functions that we need to process our data.

## Generate a list of files

You can use `list.files() to generate  a list of files that you'd like to work
with. List.files takes 2 critical arguments:

1. the path where the files are located on your computer
1. THe pattern that you'd like to look for in the files. Eg. all csv files - youd use `*.csv`. If you want to find all files with "_precip" in the name you could do that too


```r
list.files(path = ".",
           pattern = "*.csv")
##  [1] "2003_precip.csv" "2004_precip.csv" "2005_precip.csv"
##  [4] "2006_precip.csv" "2007_precip.csv" "2008_precip.csv"
##  [7] "2009_precip.csv" "2010_precip.csv" "2011_precip.csv"
## [10] "2012_precip.csv" "2013_precip.csv" "flights.csv"
```

Just find files that contain _precip.csv in the filename.


```r
list.files(path = ".",
           pattern = "_precip.csv")
##  [1] "2003_precip.csv" "2004_precip.csv" "2005_precip.csv"
##  [4] "2006_precip.csv" "2007_precip.csv" "2008_precip.csv"
##  [7] "2009_precip.csv" "2010_precip.csv" "2011_precip.csv"
## [10] "2012_precip.csv" "2013_precip.csv"
```

Just find files that contain _precip in the filename.


```r
list.files(path = ".",
           pattern = "_precip")
##  [1] "2003_precip.csv"     "2004_precip.csv"     "2005_precip.csv"    
##  [4] "2006_precip.csv"     "2007_precip.csv"     "2008_precip.csv"    
##  [7] "2009_precip.csv"     "2010_precip.csv"     "2011_precip.csv"    
## [10] "2012_precip.csv"     "2013_precip.csv"     "plotly_precip_files"
## [13] "plotly_precip.html"
```

You get the idea...


**Tip** you can also use list.dirs....
{: .notice--success }


One we have a list of files, we can loop through each file in a for loop as follows


```r

all_precip_files <- list.files(path = ".",
           pattern = "_precip.csv")
# print the name of each file
for (file in all_precip_files) {
  print(file)
}
## [1] "2003_precip.csv"
## [1] "2004_precip.csv"
## [1] "2005_precip.csv"
## [1] "2006_precip.csv"
## [1] "2007_precip.csv"
## [1] "2008_precip.csv"
## [1] "2009_precip.csv"
## [1] "2010_precip.csv"
## [1] "2011_precip.csv"
## [1] "2012_precip.csv"
## [1] "2013_precip.csv"
```

We can do even more now with our data. Let's loop through the data, open up the 
.csv file, add a new column and resave it with the new data in the file. 


```r
# print the name of each file
for (file in all_precip_files) {
  # read in the csv
  the_data <- read.csv(file) %>% 
    mutate(precip_mm = HPCP * 25.4) # add a column with precip in mm
  # write the csv to a new 
}
## Error in mutate_impl(.data, dots): Evaluation error: object 'HPCP' not found.
```
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
