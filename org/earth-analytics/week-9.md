---
layout: single
category: course-materials
title: "Week 8"
permalink: /course-materials/earth-analytics/week-8/
week-landing: 8
week: 8
sidebar:
  nav:
comments: false
author_profile: false
---

{% include toc title="This Week" icon="file-text" %}

<div class="notice--info" markdown="1">

## <i class="fa fa-ship" aria-hidden="true"></i> Welcome to Week {{ page.week }}!

Welcome to week {{ page.week }} of Earth Analytics! This week we learn about
efficient coding practices. Specifically, we will learn how to use functions to
make our code:

* Easier to read / simpler
* More modular
* More efficient

We will also discuss the DRY principle of programming - Don't Repeat Yourself.

We will continue to use the data from weeks 6-7 in this week. Download it now
if you don't already have it (which you should)!

{% include/data_subsets/course_earth_analytics/_data-week6-7.md %}


[<i class="fa fa-download" aria-hidden="true"></i> Download class demo file]({{ site.url}}/processing-code/landsat-modis-data/r-functions/landsat-helper-functions.R){:data-proofer-ignore='' .btn }
</div>


|  Time | Topic   | Speaker   |
|---|---|---|---|---|
| 3:00 - 3:10  | Questions |   |
| 3:10 - 3:45  | Identifying replication in your code - Don't Repeat yourself **DRY** |  Dr. Max Joseph |
| 3:45 - 4:30  | Efficient coding approaches / Intro to functions   |  Dr. Max Joseph  |
|===
| 4:40 - 5:50  | Interactive coding -  build custom functions |  Dr. Max Joseph  |


### 1a. Remote sensing readings

There are no new readings for this week.


### 2. Complete the assignment below (10 points)

<div class="notice--warning" markdown="1">

## <i class="fa fa-pencil-square-o" aria-hidden="true"></i> Homework Submission

### Produce a .pdf report

Over the past 2 weeks you have created the following plots:

1. NBR from Landsat and MODIS data pre & post cold springs fire
2. NDVI from Landsat and MODIS pre & post cold springs fire

This week you will create the same plots that you created in previous weeks,
BUT you will do it using the functions that we have created in class including:

* `load_bands()`
* `reclassify_ndvi())`

Create a new `R markdown `document. Name it: **lastName-firstInitial-week8.Rmd**
Within your `.Rmd` document, include the plots listed below. When you are done
with your report, use `knitr` to convert it to `PDF` format. Submit both the
`.Rmd` file and the `.pdf` (or `html` file to D2L. Be sure to name your files
as instructed above!

#### Use knitr code chunk arguments

For this week's assignment, you can turn off warnings but **please do not hide your code**.
We will grade the
assignment based upon your use of functions to complete your assignment.

#### Answer the following questions below in your report

1. Explain what the acronym **DRY** stands for and means in practice.
2. List 2 ways that the DRY principle can improve your code.
3. Explain the key difference between a variable that you create when programming line by line compared to a variable that is created within a function. Use the example below to help you answer the question OR use code to answer the question.
4. When you document a function, what elements should you include?
5. Define expressive programming. List 2 things that you can do to make your code more expressive.

```r
# for example:
my_variable <- 1+2

# and a variable created within a function
the_answer <- function(num1, num2){
  # calculate sum
  my_variable2 <- num1 + num2
  return(my_variable)
  }

# given the code above, will the code below run or return an error?
`my_variable2`
```

#### Include the plots below.

For all plots use functions as follows:

1. In class we build a function called `load_bands()`. Modify this function to support opening both landsat data and the MODIS data that we used in class. HINT: you will need to add an argument that accounts for the differences in file names and modifies the `glob2rx()` function / list.files argument.
2. Create & use a second function that reclassifies your calculated NDVI raster for each plot below. Be sure to document your function as covered in class. HINT: you may be able to use the function that we created in class to do this! Or you can make an even BETTER, more generic function that is more flexible.


#### BONUS (2 points)
* Write a third function that **calculates** NDVI. The function should work with **both LANDSAT AND MODIS **data. Thus you will not be able to use the function that we created in class.

#### BONUS (1 points)
* Write a fourth function that plots your data! Use that when creating the plots below.

#### Plot 1 - Pre-fire NDVI using landsat data
Create a MAP of the classified pre-burn **NDVI **using the landsat scene that you
downloaded from Earth Explorer last week. Add a legend. This file should not have
a cloud in the middle of the burn area!

#### Plot 2 - Post-fire NDVI using landsat data
Create a MAP of post fire classified **NDVI** using Landsat data. Add a legend.

#### Plot 3 - Post-fire NDVI using MODIS data
Create a MAP of post fire classified **NDVI** using Landsat data. Add a legend.


****

## Homework due: Thursday March 16 2017 @ 5PM.
Submit your report in both `.Rmd` and `.PDF` format to the D2L dropbox.

</div>

## Grade rubric


#### .Pdf Report structure & code: 10%

|  Full Credit | Partial Credit ~B | Partial Credit ~C | Partial Credit ~D | No Credit|
|---|---|---|---|---|
| PDF and RMD submitted |  | Only one of the 2 files are submitted  | | No files submitted |
| Code is written using "clean" code practices following the Hadley Wickham style guide| Spaces are placed after all # comment tags, variable names do not use periods, or function names. | Clean coding is used in some of the code but spaces or variable names are incorrect 2-4 times| | Clean coding is not implemented consistently throughout the report. |
| Code chunk contains code and runs  | All code runs in the document  | There are 1-2 errors in the code in the document that make it not run | | The are more than 3 code errors in the document |
| All required R packages are listed at the top of the document in a code chunk.  | | Some packages are listed at the top of the document and some are lower down. | | |
|===
| Lines of code are broken up at commas to make the code more readable  | |  | | |


####  Knitr pdf output: 10%

|  Full Credit | Partial Credit ~B | Partial Credit ~C | Partial Credit ~D | No Credit|
|---|---|---|---|---|
| Code chunk arguments are used to hide warnings & messages |  |  | | |
|===
| Code is visible in the document to demonstrate use of functions |  | | |  |


####  Report questions: 30%

|  Full Credit | Partial Credit ~B | Partial Credit ~C | Partial Credit ~D | No Credit|
|---|---|---|---|---|
| Explain what the acronym DRY stands for and means.|  |  | | |
| List 2 ways that the DRY principle can improve your code. |  |  | | |
| Explain the key difference between a variable that you create when programming line by line compared to a variable that is created within a function.  |  |  | | |
| When you document a function, what elements should you include? |  |  | | |
|===
| Define expressive programming. List 2 things that you can do to make your code more expressive. |  |  | | |





### Code is worth 50% of the assignment grade this week

#### Plots render properly & use functions

|  Full Credit | Partial Credit ~B | Partial Credit ~C | Partial Credit ~D | No Credit|
|---|---|---|---|---|
| Plot 1 - Pre-fire NDVI using landsat data plots, includes a legend and a title & is plotted using the required functions to load bands and classify the data. |  |  | | |
| Plot 2 - Post-fire NDVI using landsat data plots, includes a legend and a title & is derived using the load bands and classification functions. |  |  | | |
|===
| Plot 3 - Post-fire NDVI using MODIS data plots, includes a legend and a title & is plotted using functions.|  |  | | |

#### Functions are used to load & process data

|  Full Credit | Partial Credit ~B | Partial Credit ~C | Partial Credit ~D | No Credit|
|---|---|---|---|---|
| Functions are used to load data into a raster stack for each plot. |  |  | | |
| Functions are used to reclassify NDVI for pre and post fire plots. |  |  | | |
|===
| All functions are documented with what the function does, inputs, outputs and structure of inputs and outputs. |  |  | | |
