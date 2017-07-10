---
layout: single
title: "Build a function in R - Efficient scientific programming"
excerpt: "This lesson introduces how to create a function in R."
authors: ['Max Joseph', 'Software Carpentry', 'Leah Wasser']
modified: '2017-07-10'
category: [course-materials]
class-lesson: ['automating-your-science-r']
permalink: /course-materials/earth-analytics/week-8/intro-to-functions-r/
nav-title: 'Write functions in R'
week: 8
course: "earth-analytics"
sidebar:
  nav:
author_profile: false
comments: true
topics:
  reproducible-science-and-programming: ['literate-expressive-programming', 'functions']
order: 4
---


{% include toc title="In This Lesson" icon="file-text" %}

<div class='notice--success' markdown="1">

## <i class="fa fa-graduation-cap" aria-hidden="true"></i> Learning Objectives

After completing this tutorial, you will be able to:

* Create a new function in R
* Understand the concept of a function argument.

## <i class="fa fa-check-square-o fa-2" aria-hidden="true"></i> What you need

You will need a computer with internet access to complete this lesson.

</div>



In this lesson, we'll learn how to write a function so that we can repeat several
operations with a single command.

### Defining a Function

Let's start by defining a function `fahr_to_kelvin` that converts temperatures
from Fahrenheit to Kelvin:


```r
fahr_to_kelvin <- function(fahr) {
  kelvin <- ((fahr - 32) * (5 / 9)) + 273.15
  kelvin
}
```

We define `fahr_to_kelvin` by assigning it to the output of `function`.
The list of argument names are contained within parentheses - in this case `temp`
is the only argument that this function requires.

Next, the body of the function--the
statements that are executed when it runs--is contained within curly braces (`{}`).
The statements in the body are indented by two spaces, which makes the code easier
to read but does not affect how the code operates.

When we call the function, the values we pass to it are assigned to those
variables so that we can use them inside the function.

Inside the function, we use a return statement
to send a result back to whoever asked for it.

> ## Automatic Returns
>
> In R, it is not necessary to include the return statement.
> R automatically returns whichever variable is on the last line of the body
> of the function.
{: .notice--success}

Let's try running our function.
Calling our own function is no different from calling any other function:


```r
# freezing point of water
fahr_to_kelvin(32)
## [1] 273.15
# boiling point of water
fahr_to_kelvin(212)
## [1] 373.15
```

We've successfully called the function that we defined, and we have access to the value that we returned.

### Composing Functions

Now that we've seen how to turn Fahrenheit into Kelvin, it's easy to turn Kelvin into Celsius:


```r
kelvin_to_celsius <- function(kelvin) {
  celsius <- kelvin - 273.15
  celsius
}

# absolute zero in Celsius
kelvin_to_celsius(0)
## [1] -273.15
```

What about converting Fahrenheit to Celsius?
We could write out the formula, but we don't need to.
Instead, we can compose the
two functions we have already created:


```r
fahr_to_celsius <- function(fahr) {
  kelvin <- fahr_to_kelvin(fahr)
  celsius <- kelvin_to_celsius(kelvin)
  celsius
}

# freezing point of water in Celsius
fahr_to_celsius(32.0)
## [1] 0
```

This is our first taste of how larger programs are built: we define basic
operations, then combine them in ever-larger chunks to get the effect we want.
Real-life functions will usually be larger than the ones shown here--typically half a dozen to a few dozen lines--but they shouldn't ever be much longer than that, or the next person who reads it won't be able to understand what's going on.
Even more important than avoiding long functions is ensuring that the logic of your function is expressed by the code that comprises your function.
For instance, it is nearly always better to use meaningful variable names such as `fahr` instead of simply `temp`, which could be taken to mean temporary, or temperature (in what units?).
You might be surprised at the human mental expense required to comprehend all of the objects and operations in long functions.

## Chaining Functions

This example showed the output of `fahr_to_kelvin` assigned to `temp_k`, which
is then passed to `kelvin_to_celsius` to get the final result. It is also possible
to perform this calculation in one line of code, by "chaining" functions
together, like so:


```r
# freezing point of water in Celsius
kelvin_to_celsius(fahr_to_kelvin(32.0))
## [1] 0
```


## Create a Function

We can use the `c` function to **c**oncatenate elements. We have done this when
we classified rasters. For example

`x <- c("A", "B", "C")` creates a vector `x`
with three elements. Furthermore, we can extend that vector again using `c`.

For example,

`y <- c(x, "D")` creates a vector `y` with four elements.

<div class="notice--warning" markdown="1">

## <i class="fa fa-pencil-square-o" aria-hidden="true"></i> Optional challenge

Write a function called `fence` that takes two vectors as arguments, called
original` and `wrapper`, and returns a new vector that has the wrapper vector
at the beginning and end of the original. An example of how the function
should run is below.

</div>




```r
best_practice <- c("Write", "programs", "for", "people", "not", "computers")
asterisk <- "***"  # R interprets a variable with a single value as a vector
                    # with one element.
fence(best_practice, asterisk)
## [1] "***"       "Write"     "programs"  "for"       "people"    "not"      
## [7] "computers" "***"
```

<div class="notice--warning" markdown="1">

## <i class="fa fa-pencil-square-o" aria-hidden="true"></i> Optional challenge 2
If the variable `v` refers to a vector, then `v[1]` is the vector's first element and `v[length(v)]` is its last (the function `length` returns the number of elements in a vector).
Write a function called `outside` that returns a vector made up of just the first and last elements of its input:

</div>




```r
 dry_principle <- c("Don't", "repeat", "yourself", "or", "others")
 outside(dry_principle)
## [1] "Don't"  "others"
```
