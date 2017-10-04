---
layout: single
category: courses
title: "Functions & automation"
permalink: /courses/earth-analytics/automate-science-workflows/
modified: '2017-10-04'
week-landing: 6
week: 6
sidebar:
  nav:
comments: false
author_profile: false
course: "earth-analytics"
module-type: 'session'
redirect_from:
  - "/courses/earth-analytics/week-8/"
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

This week is still under development and the content won't be done until Friday!

</div>


|  Time | Topic   | Speaker   |
|---|---|---|---|---|
| 9:30 - 9:45   | Questions / Review  |   |
|  9:45 - 10:15 | Write efficient, expressive code - Don't Repeat yourself **DRY** |    |
| 10:15 - 11:00 | Write functions in R |    |
|===
| 11:- 12:20 | Loops & functions to automate workflows |    |


### 1a. Readings

There are no new readings for this week.


### 2. Complete the assignment below (10 points)

<div class="notice--warning" markdown="1">

## <i class="fa fa-pencil-square-o" aria-hidden="true"></i> Homework Submission

### Produce a R Markdown report

Create a new `R markdown `document. Name it: **lastName-firstInitial-week8.Rmd**
Within your `.Rmd` document, include the plots listed below. When you are done
with your report, use `knitr` to convert it to `html` format. Submit both the
`.Rmd` file and the `.html` (or `.pdf` file to D2L. Be sure to name your files
as instructed above!

#### Use knitr code chunk arguments

For this week's assignment **please do not hide your code**.
We will grade the
assignment based upon your use of functions and for loops to complete your assignment.

#### Answer the following questions below in your report

1. Explain what the acronym **DRY** stands for and means in practice.
2. List 2 ways that the DRY principle can improve your code.
3. Explain the key difference between a variable that you create when programming line by line compared to a variable that is created within a function. Use the example below to help you answer the question OR use code to answer the question.
4. When you document a function, what elements should you include?
5. Provide an example of a function name that is expressive vs one that is not expressive.

```r
# this code below should help you answer question 3.
my_variable <- 1+2

# and a variable created within a function
the_answer <- function(num1, num2){
  # calculate sum
  my_variable2 <- num1 + num2
  return(my_variable)
  }

# given the code above, will the code below run or return an error? Why?
`my_variable2`
```

#### Code assignment

For this week's assignment, write some code that does the following.

1. Write a `for loop` that takes the file `"data/week_02/precipitation/805325-precip-daily-2003-2013.csv"` and creates an individual `.csv` file for each year's worth of data. Each `.csv` file should be saved in `data/week_06/` If you followed along in class, then you have already written this code! [This lesson will help you complete this task. ]({{ site.url }}/courses/earth-analytics/automate-science-workflows/create-for-loops-r/)
2. Complete the challenge exercise at the bottom of [this lesson - lesson 06 ]({{ site.url }}/courses/earth-analytics/automate-science-workflows/loop-through-a-set-of-files-r#i-classfa-fa-pencil-square-o-aria-hiddentruei-challenge) The challenge asks you to create a for loop that summarises data by month and exports new `.csv` files for each year. It also asks you to create two new functions to include in your for loop.


#### Bonus opportunity

You can use `apply()` functions (instead of for loops) to run a function on a
list of elements. 

## Homework due: Monday October 16 2017 @ 8AM.
Submit your report in both `.Rmd` and `.html` format to the D2L dropbox.

</div>

## Grade rubric


#### R Markdown Report structure & code: 10%

| Full Credit | No Credit  |
|:----|----|
| html / pdf  and RMD submitted |   |
| Code is written using "clean" code practices following the Hadley Wickham style guide|  |
| Code chunk contains code and runs  |  |
| All required `R` packages are listed at the top of the document in a code chunk.  | |
| Code chunk arguments are used to hide warnings & messages |  |
| Code is visible in the document to demonstrate use of functions |  |
|===
| Lines of code are broken up at commas to make the code more readable  | |


####  Report questions: 30%

| Full Credit | No Credit  |
|:----|----|
| Define the acronym D.R.Y. - what does it stand for and what does DRY mean? |  |
| List 2 ways that the DRY principle can improve your code. |  |
| Explain the key difference between a variable that you create when programming line by line compared to a variable that is created within a function.  |  |
| When you document a function, what elements should you include? |  |
|===
| Provide an example of a function name that is expressive vs. one that is not expressive |  |



### Code is worth 60% of the assignment grade this week

#### For loop 1

>Write a loop that takes the file "data/week_02/precipitation/805325-precip-daily-2003-2013.csv" and creates an
> individual `.csv` file for each year’s worth of data.

| Full Credit | No Credit  |
|:----|----|
| Code produces an individual `.csv` file for each year's worth of data | |
| Following the code, `.csv` files are saved in the `data/week_06/` directory | |
| `.csv` files are named correctly - including the year of data that the file contains ||
|===
| `.csv` files created contain the correct data (for the year specified)| |

#### For loop 2

|  Full Credit | Partial Credit ~B | Partial Credit ~C | Partial Credit ~D | No Credit|
|---|---|---|---|---|
| `in_to_mm()` function is used to convert precipitation from inches to mm | |
| `check_create_dir()` function is used to check for and create a directory if one doesn't exist.| |
| Code produces an individual `.csv` file for each year's worth of data, summarized by month.  | |
| `NA` values are handled properly in the code - when the data are read in, and exported to .csv files and for the monthly summary calculation.  | |
|===
| All functions are documented with what the function does, inputs, outputs and structure of inputs and outputs. |  |
