---
layout: single
title: "Creating Variables in R and the String vs Numeric Data Type or Class - Data Science for Scientists 101"
excerpt: "This lesson covers creating variables or objects in R. It also introduces some of the basic data types or classes including strings and numbers. This lesson is designed for someone who has not used R before."
authors: ['Leah Wasser', 'Data Carpentry']
category: [courses]
class-lesson: ['get-to-know-r']
permalink: /courses/earth-analytics/time-series-data/objects-in-r/
nav-title: 'Objects in R'
dateCreated: 2016-12-13
modified: '2018-01-10'
week: 2
sidebar:
  nav:
author_profile: false
comments: true
course: "earth-analytics"
order: 2
topics:
  reproducible-science-and-programming: ['RStudio']
---

{% include toc title="In This Lesson" icon="file-text" %}



<div class='notice--success' markdown="1">

## <i class="fa fa-graduation-cap" aria-hidden="true"></i> Learning Objectives
At the end of this activity, you will be able to:

* Create, modify and use objects or variables in `R`.
* Define the key differences between the str (string) and num (number) classes in `R` in terms of how `R` can or cannot perform calculations with each.

## <i class="fa fa-check-square-o fa-2" aria-hidden="true"></i> What You Need

You need `R` and `RStudio` to complete this tutorial. Also we recommend that you
have an `earth-analytics` directory set up on your computer with a `/data`
directory within it.

* [How to set up R / RStudio](/courses/earth-analytics/document-your-science/setup-r-rstudio/)
* [Set up your working directory](/courses/earth-analytics/document-your-science/setup-working-directory/)

</div>


## Creating Objects

You can get output from `R` by typing a mathematical equation into the console -
for example, if you type in `3 + 5`, `R` will calculate the output value:


```r
# add 3 + 5
3 + 5
## [1] 8
# divide 12 by 7
12/7
## [1] 1.714286
```

However, is it more useful to assign _values_ to
_objects_. To create an object, you need to give it a name followed by the
assignment operator `<-`, and the value you want to give it:


```r
# assign weight_kg to the value of 55
weight_kg <- 55

# view object value
weight_kg
## [1] 55
```

## Use Useful Object Names
Objects can be given any name such as `x`, `current_temperature`, or
`subject_id`. However, it is best to use clear and descriptive words when naming
objects to ensure your code is easy to follow.

You will learn best practicing for coding in this module - in the [clean coding
lesson](/courses/earth-analytics/time-series-data/write-clean-code-with-r/).

1. **Keep object names short:** This makes them easier to read when scanning through code.
2. **Use meaningful names:** For example, `precip` is a more useful name that tells us something about the object compared to `x`.
3. **Don't start names with numbers!** Objects that start with a number are NOT VALID in `R`.
4. **Avoid names that are existing functions in R:** e.g.`if`, `else`, `for`, see [here](https://stat.ethz.ch/R-manual/R-devel/library/base/html/Reserved.html).

A few other notes about object names in `R`:

* `R` is case sensitive (e.g. `weight_kg` is different from `Weight_kg`).
* Avoid other function names (e.g. `c`, `T`, `mean`, `data`, `df`, `weights`).
* Use nouns for variable names, and verbs for function names.
* Avoid using dots in object names - e.g. `my.dataset` - dots have a special meaning in R (for methods) and other programming languages. Instead use underscores `my_dataset`.

## View Object Value
When assigning a value to an object, `R` does not print anything. You can force
it to print the value by using parentheses or by typing the name:


```r
weight_kg <- 55    # doesn't print anything
(weight_kg <- 55)  # but putting parenthesis around the call prints the value of `weight_kg`
## [1] 55
weight_kg          # and so does typing the name of the object
## [1] 55
```

Now that `R` has `weight_kg` in memory, you can do arithmetic with it. For
instance, you may want to convert this weight in pounds (weight in pounds is 2.2
times the weight in kg):


```r
2.2 * weight_kg
## [1] 121
```

You can also change a variable's value by assigning it a new one:


```r
weight_kg <- 57.5
2.2 * weight_kg
## [1] 126.5
```

This means that assigning a value to one variable does not change the values of
other variables.  For example, let's store the animal's weight in pounds in a new
variable, `weight_lb`:


```r
weight_lb <- 2.2 * weight_kg
```

and then change `weight_kg` to 100.


```r
weight_kg <- 100
```

What do you think is the current content of the object `weight_lb`? 126.5 or 200?

<div class="notice--warning" markdown="1">

## <i class="fa fa-pencil-square-o" aria-hidden="true"></i> Optional Challenge

What are the values of each object defined in EACH LINE of code below?


```r
mass <- 47.5            # mass?
age  <- 122             # age?
mass <- mass * 2.0      # mass?
age  <- age - 20        # age?
mass_index <- mass/age  # mass_index?
```
</div>
