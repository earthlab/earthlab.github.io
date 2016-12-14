---
layout: single
title: "Get to Know R & RStudio"
excerpt: "This tutorial introduces the R scientific programming language. It is
designed for someone who has not used R before. We will work with precipitation and
stream discharge data for Boulder County."
authors: ['Leah Wasser', 'Data Carpentry']
category: [course-materials]
class-lesson: ['get-to-know-r']
permalink: /course-materials/earth-analytics/start-using-r
nav-title: 'Use R'
dateCreated: 2016-12-13
lastModified: 2016-12-14
sidebar:
  nav:
author_profile: false
comments: false
order: 2
---

.

<div class='notice--success' markdown="1">

# Learning Objectives
At the end of this activity, you will be able to:

* Be able to work with the 4 panes in the RStudio interface
* Understand the basic concept of a function and be able to use a function in your code.
* Know how to use key operator commands in R (<-)

## What You Need

You need R and RStudio to complete this tutorial. Also we recommend have you
have an `earth-analytics` directory setup on your computer with a `/data`
directory with it.

* [How to Setup R / R Studio](/course-materials/setup-r-rstudio)
* [Setup your working directory](/course-materials/setup-working-directory)


</div>


## Creating objects

You can get output from R simply by typing in math in the console


```r
3 + 5
## [1] 8
12/7
## [1] 1.714286
```

However, to do useful and interesting things, we need to assign _values_ to
_objects_. To create an object, we need to give it a name followed by the
assignment operator `<-`, and the value we want to give it:


```r
weight_kg <- 55
```

Objects can be given any name such as `x`, `current_temperature`, or
`subject_id`. You want your object names to be explicit and not too long. They
cannot start with a number (`2x` is not valid, but `x2` is). R is case sensitive
(e.g., `weight_kg` is different from `Weight_kg`). There are some names that
cannot be used because they are the names of fundamental functions in R (e.g.,
`if`, `else`, `for`, see
[here](https://stat.ethz.ch/R-manual/R-devel/library/base/html/Reserved.html)
for a complete list). In general, even if it's allowed, it's best to not use
other function names (e.g., `c`, `T`, `mean`, `data`, `df`, `weights`). In doubt
check the help to see if the name is already in use. It's also best to avoid
dots (`.`) within a variable name as in `my.dataset`. There are many functions
in R with dots in their names for historical reasons, but because dots have a
special meaning in R (for methods) and other programming languages, it's best to
avoid them. It is also recommended to use nouns for variable names, and verbs
for function names. It's important to be consistent in the styling of your code
(where you put spaces, how you name variable, etc.). In R, two popular style
guides are [Hadley Wickham's](http://adv-r.had.co.nz/Style.html) and
[Google's](https://google-styleguide.googlecode.com/svn/trunk/Rguide.xml).

When assigning a value to an object, R does not print anything. You can force to
print the value by using parentheses or by typing the name:


```r
weight_kg <- 55    # doesn't print anything
(weight_kg <- 55)  # but putting parenthesis around the call prints the value of `weight_kg`
## [1] 55
weight_kg          # and so does typing the name of the object
## [1] 55
```

Now that R has `weight_kg` in memory, we can do arithmetic with it. For
instance, we may want to convert this weight in pounds (weight in pounds is 2.2
times the weight in kg):


```r
2.2 * weight_kg
## [1] 121
```

We can also change a variable's value by assigning it a new one:


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

### Challenge

What are the values after each statement in the following?


```r
mass <- 47.5            # mass?
age  <- 122             # age?
mass <- mass * 2.0      # mass?
age  <- age - 20        # age?
mass_index <- mass/age  # mass_index?
```
