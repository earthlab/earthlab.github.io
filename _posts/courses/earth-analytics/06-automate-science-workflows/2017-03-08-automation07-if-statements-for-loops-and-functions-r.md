---
layout: single
title: "For loops  "
excerpt: " ."
authors: ['Leah Wasser', 'Max Joseph']
modified: '2017-10-05'
category: [courses]
class-lesson: ['automating-your-science-r']
permalink: /courses/earth-analytics/automate-science-workflows/write-if-statements-and-modify-files-r/
nav-title: 'If statements, functions and loops'
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




## Work with directories of files

In the previous lesson, we broke up a single `.csv` file into a set of csv files -
one for each year. However, what if we wanted to modify each of those .csv files
in some way? How would we go about it?

One option could be to open each file individually and then manipulate it.

This is:

1. Tedious & inefficient,
1. Generates lots of redundant lines of code
1. Leaves room for lots of error




Another option is to generate a list of all `.csv` files in our directory. Using that
list, we can then create a for loop. OR, we can also use an `R`, `apply` function if
we have build the correct functions that we need to process our data.

## Generate a list of files

You can use `list.files()` to generate a list of files that you'd like to work
with. The `list.files()` function requires 2 arguments:

1. The path where the files are located on your computer
1. The pattern that you'd like to look for in the files. Eg. all csv files - youd use `*.csv`. If you want to find all files with "_precip" in the name you could do that too.


```
##  [1] "precip-2003.csv" "precip-2004.csv" "precip-2005.csv"
##  [4] "precip-2006.csv" "precip-2007.csv" "precip-2008.csv"
##  [7] "precip-2009.csv" "precip-2010.csv" "precip-2011.csv"
## [10] "precip-2012.csv" "precip-2013.csv"
```

Just find files that contain `precip-` in the filename.


```
##  [1] "precip-2003.csv" "precip-2004.csv" "precip-2005.csv"
##  [4] "precip-2006.csv" "precip-2007.csv" "precip-2008.csv"
##  [7] "precip-2009.csv" "precip-2010.csv" "precip-2011.csv"
## [10] "precip-2012.csv" "precip-2013.csv"
```

Just find files that contain `_precip` in the filename.


```
##  [1] "precip-2003.csv" "precip-2004.csv" "precip-2005.csv"
##  [4] "precip-2006.csv" "precip-2007.csv" "precip-2008.csv"
##  [7] "precip-2009.csv" "precip-2010.csv" "precip-2011.csv"
## [10] "precip-2012.csv" "precip-2013.csv"
```

You get the idea...


<i class="fa fa-star" aria-hidden="true"></i> **Data Tip** you can also use `list.dirs()` to generate a list of directories rather than files.
{: .notice--success }


One you have a list of files, you can loop through each file in a for loop.
Note below the argument `full.names = TRUE` is used to ensure that `R` gets the
full path rather than just the filename.


```
## [1] "data/week_06//precip-2003.csv"
## [1] "data/week_06//precip-2004.csv"
## [1] "data/week_06//precip-2005.csv"
## [1] "data/week_06//precip-2006.csv"
## [1] "data/week_06//precip-2007.csv"
## [1] "data/week_06//precip-2008.csv"
## [1] "data/week_06//precip-2009.csv"
## [1] "data/week_06//precip-2010.csv"
## [1] "data/week_06//precip-2011.csv"
## [1] "data/week_06//precip-2012.csv"
## [1] "data/week_06//precip-2013.csv"
```

We can do even more now with our data. Let's loop through each `.csv` file and

1. Open the `.csv` file
1. Add a new column to the `data.frame` that contains the precipitation in **mm**
1. Export the `data.frame` as a new `.csv` in a new data directory (`data/week-06/outputs/precip_mm/`) with a modified file name


The example below uses the `basename()` function to grab just the file name (without the path)
from the file variable.


```
## [1] "precip-2013.csv"
## [1] "data/week-06/outputs/precip_mm/precip-2013.csv"
```



```
## Error in write_csv(the_data, path = paste0("data/week-06/outputs/precip_mm/", : could not find function "write_csv"
```


## Check For and Create Directories with R with If Statements

You are closer to the final file output in the format that you want. However,
you can't write out the files to a new directory unless that directory exists.

You can create new directories and test to see if a directory exists in `R` too
using if statements.

An `if` statement:

1. Starts with the word, `if`
1. Is followed by the condition that you are testing for in `()`
1. Then the task that you want R to perform follows, in curly braces `{}`

If the if statement condition is `TRUE` then `R` will perform the tasks in the
curly braces.

```r
# an example if statement
if (some-condition-exists) {
  perform-some-task
}
```
In your case, you'd like to test to see if a directory exists.

You can use the `dir.exists()` function to check to see if a directory exists in
your working directory or on your computer.





```
## [1] FALSE
```

However we want to check if the directory doesn't exist. To do this, use the `!`
at the beginning of your function.


```
## [1] TRUE
```

Now, build your if statement.

1. First, create a directory path that you wish to check for. Use: `data/week_06/outputs/precip_mm/`
2. Condition: Check to see if that directory path (defined in step 1) exists using `dir.exists()`
3. Use an if statement to test whether the dir exists or not.
4. If the dir doesn't exist, then create the new directory using `dir.create()`. Use the `recursive = TRUE` function argument to ensure that R creates not only the prec_mm dir but also the outputs directory.

Like this:



You are now ready to complete the homework for week 6!
