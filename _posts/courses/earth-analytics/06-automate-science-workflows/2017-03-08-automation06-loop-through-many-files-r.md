---
layout: single
title: "For loops  "
excerpt: " ."
authors: ['Leah Wasser', 'Max Joseph']
modified: '2017-10-04'
category: [courses]
class-lesson: ['automating-your-science-r']
permalink: /courses/earth-analytics/automate-science-workflows/loop-through-a-set-of-files-r/
nav-title: 'Loop through files'
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

* Integrate for loops and functions to process data efficiently

## <i class="fa fa-check-square-o fa-2" aria-hidden="true"></i> What you need

You will need a computer with internet access to complete this lesson.

</div>



```r
library(lubridate)
library(dplyr)
```

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

You can use `list.files()` to generate a list of files that you'd like to work
with. The `list.files()` function requires 2 arguments:

1. The path where the files are located on your computer
1. The pattern that you'd like to look for in the files. Eg. all csv files - youd use `*.csv`. If you want to find all files with "_precip" in the name you could do that too.


```r
list.files(path = ".",
           pattern = "*.csv")
## character(0)
```

Just find files that contain `_precip.csv` in the filename.


```r
list.files(path = ".",
           pattern = "_precip.csv")
## character(0)
```

Just find files that contain `_precip` in the filename.


```r
list.files(path = ".",
           pattern = "_precip")
## character(0)
```

You get the idea...


<i class="fa fa-star" aria-hidden="true"></i> **Data Tip** you can also use `list.dirs()` to generate a list of directories rather than files.
{: .notice--success }


One you have a list of files, you can loop through each file in a for loop.


```r

all_precip_files <- list.files(path = "data/",
           pattern = "precip-",
           full.names = TRUE)
# print the name of each file
for (file in all_precip_files) {
  print(file)
}
## [1] "data//precip-2003.csv"
## [1] "data//precip-2004.csv"
## [1] "data//precip-2005.csv"
## [1] "data//precip-2006.csv"
## [1] "data//precip-2007.csv"
## [1] "data//precip-2008.csv"
## [1] "data//precip-2009.csv"
## [1] "data//precip-2010.csv"
## [1] "data//precip-2011.csv"
## [1] "data//precip-2012.csv"
## [1] "data//precip-2013.csv"
## [1] "data//precip-boulder-aug-oct-2013.csv"
```

We can do even more now with our data. Let's loop through each `.csv` file and

1. Open the `.csv` file
1. Add a new column to the `data.frame` that contains the precipitation in **mm**
1. Export the `data.frame` as a new `.csv` in a new data directory (`data/week-06/outputs/precip_mm/`) with a modified file name


```r
# print the name of each file
for (file in all_precip_files) {
  # read in the csv
  the_data <- read.csv(file, header = TRUE) %>%
    mutate(precip_mm = (HPCP * 25.4)) # add a column with precip in mm
  # write the csv to a new file
  write_csv(the_data, path = paste0("data/week-06/outputs/precip_mm/", basename(file)))
}
## Error in write_csv(the_data, path = paste0("data/week-06/outputs/precip_mm/", : could not find function "write_csv"
```

## Check For and Create Directories with R

You are closer to the final file output in the format that you want, however
you can't write out the files to a new directory unless that directory exists.

You can create new directories and test to see if a directory exists in R too.
First let's figure out how to do that. Next, create a function that checks for and
if it doesn't exist, creates a new directory on your computer.

1. First, create a directory page for the new directory. You want to create a directory
with the following path: `data/week_06/outputs/precip_mm/`
2. See if the directory exists already using `dir.exists()`
3. Use an if statement to test whether the dir exists or not.
4. If the dir doesn't exist, then create the new directory using dir.create(). You'll want to use `recursive = TRUE` function argument to ensure that R creates not only the prec_mm dir but also outputs if it doesn't exist.





```r
# create an object with the directory name
new_dir <- "data/week_06/outputs/precip_mm/"
# does the dir exist?
dir.exists(new_dir)
## [1] FALSE

# if the dir doesn't exist, create it
if (!dir.exists(new_dir)) {
  dir.create(new_dir, recursive = TRUE)
}
```


<div class="notice--warning" markdown="1">

## <i class="fa fa-pencil-square-o" aria-hidden="true"></i> Challenge

1. Create a function called `check_create_dir()` that takes a path to a directory that you want to make and checks to see if it exists and then creates it if it doesn't exist.
2. Create a function called `in_to_mm()` that converts values in inches to mm (we did this in an earlier lesson so you may already have this function in your code).
2. Add both functions to the for loop below
3. Finally, summarize your data by daily total (sum) precipitation per day

NOTES

1. be sure that you are address of na values when you read your data in the loop!
2. make sure you address na values when you run the `sum()` function
3. When you write the csv make sure that you address na values!
4. use the `lubridate::month()` function to create a new column in your data frame called the_month

```r

check_create_dir <- function(dir_path){
  # document your function here

  # include the code required to check for the directory and then create it here
  # because this function is just creating a directory, you don't need to return anything!

}

in_to_mm <- function(precip_in){
  # document your function here

  # include the code required to convert inches to mm here

  return(precip_mm)
}

# create an object with the directory name
new_dir <- "data/week_06/outputs/precip_mm/"
# check to see if the directory exists - make it if it doesn't
check_create_dir(new_dir)

# print the name of each file
for (file in all_precip_files) {
  # read in the csv - be sure to fill in the na strings argument - i didn't do that below
  the_data <- read.csv(file, header = TRUE, na.strings = 999.99) %>%
    mutate(precip_mm = in_to_mm(HPCP)) # add a column with precip in mm and a column with just the month using the month() function
    # group the data by month

    # summarise using the sum function - be sure you address na values when you sum! we discussed this during week 1

  # write output to a new .csv file
  write_csv(the_data, path = paste0("data/week-06/outputs/precip_mm/", basename(file)))
}
```

</div>


