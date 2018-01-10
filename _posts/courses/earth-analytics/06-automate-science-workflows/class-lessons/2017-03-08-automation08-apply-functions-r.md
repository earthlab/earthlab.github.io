---
layout: single
title: "Use lapply in R Instead of For Loops to Process .csv files - Efficient Coding in R"
excerpt: "Learn how to take code in a for loop and convert it to be used in an apply function. Make your R code more efficient and expressive programming."
authors: ['Leah Wasser', 'Bryce Mecum', 'Max Joseph']
modified: '2018-01-10'
category: [courses]
class-lesson: ['automating-your-science-r']
permalink: /courses/earth-analytics/automate-science-workflows/use-apply-functions-for-efficient-code-r/
nav-title: 'lapply vs For Loops'
week: 6
course: "earth-analytics"
sidebar:
  nav:
author_profile: false
comments: true
topics:
  reproducible-science-and-programming: ['literate-expressive-programming', 'functions']
order: 8
redirect_from:
---

{% include toc title="In This Lesson" icon="file-text" %}



<div class='notice--success' markdown="1">

## <i class="fa fa-graduation-cap" aria-hidden="true"></i> Learning Objectives

After completing this tutorial, you will be able to:

* Use the `lapply()` function in `R` to automate your code.

## <i class="fa fa-check-square-o fa-2" aria-hidden="true"></i> What You Need

You will need a computer with internet access to complete this lesson.

</div>

In the previous lessons, you learned how to use for loops to perform tasks that
you want to implement over and over - for example on a set of files. For loops are
a good start to automating your code. However if you want to scale this automation
to process more and / or larger files, the `R` `apply` family of functions are useful
to know about.

`apply` functions perform a task over and over - on a list, vector, etc. So, for example
you can use the `lapply` function (list apply) on the list of file names that
you generate when using `list.files()`.

## Why Use Apply vs For Loops

There are several good reasons to use the `apply` family of functions.

**1. They make your code more expressive and in turn easier to read:**

Here's what the master, Hadley Wikham has to say about expressive code and the `apply` family:

> The point of the apply (and plyr) family of functions is not speed, but expressiveness. They also tend to prevent bugs because they eliminate the book keeping code needed with loops.
>
> Lately, answers on stackoverflow have over-emphasised speed. Your code will get faster on its own as computers get faster and R-core optimises the internals of R. Your code will never get more elegant or easier to understand on its own.
>
> In this case you can have the best of both worlds: an elegant answer using vectorisation that is also very fast, (million > 0) * 2 - 1.
> <a href="https://stackoverflow.com/questions/5533246/why-is-apply-method-slower-than-a-for-loop-in-r/5538309#5538309" target="_blank">Source: Hadley Wikham, stackoverflow comment</a>

And another quote:

> A common reflex is to use a function in the apply family. This is not vectorization,
> it is loop-hiding. The apply function has a for loop in its definition -- Source: Patrick Burns - the Inferno.

**2. They make it easier to parallelize your code:** Most computers these days have
more than one core that can be used to process your data. However, by default,
most functions in R only take advantage of one core on your machine. This means your
computer course process things faster. Parallelized code refers to code that is
optimized to use the cores available to it on a machine. While this topic is out
of the scope of this class - it's important to know about if you ever need to process
large amounts of data - particularly in a cloud or high performance computing environment.

**3. They make your code just a bit faster** At the bottom of this lesson you'll see
a quick benchmark test where you see whether the `apply` version of a `for loop` is faster
or not. The `apply` functions do run a `for loop` in the background. However they
often do it in the C programming language (which is used to build R). This does
make the `apply` functions a few milliseconds faster than regular for loops.
However, this is not the main reason to use `apply` functions!



```r
# view code for the lapply function
lapply
## function (X, FUN, ...) 
## {
##     FUN <- match.fun(FUN)
##     if (!is.vector(X) || is.object(X)) 
##         X <- as.list(X)
##     .Internal(lapply(X, FUN))
## }
## <bytecode: 0x102835c08>
## <environment: namespace:base>
```



```r
library(parallel)
# how many cores are on this machine
detectCores()
## [1] 8
```

## Use lapply to Process Lists of Files

Next, let's look at an example of using `lapply` to perform the same task that
you performed in the previous lesson. To do this you will need to:

1. Write a function that performs all of the tasks that you executed in your `for loop`.
2. Call the `apply` function and tell it to use the function that you created in step 1.

To get started, call the lubridate and dplyr libraries like you did in the previous lessons.


```r
library(lubridate)
library(dplyr)
```

### How lapply Works

> lapply takes a vector (or list) as its first argument (in this case a vector of the continent names), then a function as its second argument. This function is then executed on every element in the first argument. This is very similar to a for loop: first, cc stores the first continent name, “Asia”, then runs the code in the function body, then cc stores the second continent name, and runs the function body, and so on. The code in the function body can be thought of in exactly the same way as the body of the for loop. The result of the last line is then returned to lapply, which combines the results into a list. --Software Carpentry


```r
check_create_dir <- function(the_dir) {
  if (!dir.exists(the_dir)) {
  dir.create(the_dir, recursive = TRUE) }
}

in_to_mm <- function(data_in_inches) {
  value_inches <- data_in_inches * 25.4
  return(value_inches)
}
```

In the previous lessons, you created a list of files in a directory.


```r
all_precip_files <- list.files("data/week_06", pattern = "*.csv",
                             full.names = TRUE)

# create an object with the directory name
the_dir <- "data/week-06/outputs/precip_mm"
# check to see if the directory exists - make it if it doesn't
check_create_dir(the_dir)

# print the name of each file
for (file in all_precip_files) {
  # read in the csv
  the_data <- read.csv(file, header = TRUE, na.strings = 999.99) %>%
    mutate(DATE = as.POSIXct(DATE, tz = "America/Denver", format = "%Y-%m-%d %H:%M:%S"),
            # add a column with precip in mm
           precip_mm = in_to_mm(HPCP))

  # write the csv to a new file
  write.csv(the_data, file = paste0(the_dir, "/", basename(file)),
            na = "999.99")

}
```


Create a function that performs all of the tasks performed in the `for loop` above.


```r
# create a function that performs all of the tasks performed in the for loop above
summarize_data <- function(a_csv, the_dir) {
  # open the data, fix the date and add a new column
  the_data <- read.csv(a_csv, header = TRUE, na.strings = 999.99) %>%
      mutate(DATE = as.POSIXct(DATE, tz = "America/Denver", format = "%Y-%m-%d %H:%M:%S"),
              # add a column with precip in mm - you did this using a function previously
             precip_mm = (HPCP * 25.4))

  # write the csv to a new file
  write.csv(the_data, file = paste0(the_dir, "/", basename(a_csv)),
            na = "999.99")
}
```

As you did above, make sure your output directory is created.
Then use `list.files()` to get a list of all of the files that you'd like to process.


```r

the_dir_ex <- "data/week-06/outputs/example"
check_create_dir(the_dir_ex)
# get a list of all files that you want to process
# you can use a list with the lapply function
all_precip_files <- list.files("data/week_06", pattern = "*.csv",
                             full.names = TRUE)

```

Now you can perform the same task that you performed above in a loop with one
line of code (ok two if you break them up for readability).


```r

lapply(all_precip_files,
       FUN = summarize_data,
       the_dir = the_dir_ex)
## list()
```



```r

# turn off the output empty list
invisible(lapply(all_precip_files, (FUN = summarize_data),
       the_dir = the_dir_ex))
```



## Are Apply Function Faster Than For Loops?

As promised let's test your code to see whether the `lapply()` function is in fact
faster than the `for loop`.



```r
# let's see what approach is faster
library(microbenchmark)
microbenchmark(invisible(lapply(all_precip_files, (FUN = summarize_data),
       the_dir = the_dir_ex)))
## Unit: nanoseconds
##                                                                               expr
##  invisible(lapply(all_precip_files, (FUN = summarize_data), the_dir = the_dir_ex))
##  min   lq   mean median   uq   max neval
##  996 1076 1295.7   1110 1148 17106   100
```



```r

# print the name of each file
microbenchmark(for (file in all_precip_files) {
  # read in the csv
  the_data <- read.csv(file, header = TRUE, na.strings = 999.99) %>%
    mutate(DATE = as.POSIXct(DATE, tz = "America/Denver", format = "%Y-%m-%d %H:%M:%S"),
            # add a column with precip in mm
           precip_mm = in_to_mm(HPCP))

  # write the csv to a new file
  write.csv(the_data, file = paste0(the_dir, "/", basename(file)),
            na = "999.99")

})
## Unit: milliseconds
##                                                                                                                                                                                                                                                                                                                                           expr
##  for (file in all_precip_files) {     the_data <- read.csv(file, header = TRUE, na.strings = 999.99) %>%          mutate(DATE = as.POSIXct(DATE, tz = "America/Denver",              format = "%Y-%m-%d %H:%M:%S"), precip_mm = in_to_mm(HPCP))     write.csv(the_data, file = paste0(the_dir, "/", basename(file)),          na = "999.99") }
##       min       lq     mean   median       uq      max neval
##  3.765952 4.018107 4.427995 4.089864 4.295926 17.50724   100
```

<!--RETURN a single data.frame do.call(rbind, lapply(file_paths, function(path) { read.csv(path, stringsAsFactors = FALSZE }))-->

Is it faster on average? Perhaps just by a few milliseconds?


<div class="notice--info" markdown="1">

## Additional Resources

* <a href = "http://resbaz.github.io/r-intermediate-gapminder/17-apply.html
" target = "_blank">Software Carpentry apply lesson </a>
* <a href = "http://www.burns-stat.com/pages/Tutor/R_inferno.pdf
" target = "_blank">The R Inferno - Patrick Burns </a>


</div>
