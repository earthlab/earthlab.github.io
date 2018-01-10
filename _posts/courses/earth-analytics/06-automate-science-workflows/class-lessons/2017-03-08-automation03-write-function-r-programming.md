---
layout: single
title: "How to Write a Function in R - Automate Your Science"
excerpt: "Learn how to write a function in the R programming language."
authors: ['Max Joseph', 'Software Carpentry', 'Leah Wasser']
modified: '2018-01-10'
category: [courses]
class-lesson: ['automating-your-science-r']
permalink: /courses/earth-analytics/automate-science-workflows/write-function-r-programming/
nav-title: 'Write Functions in R'
week: 6
course: "earth-analytics"
sidebar:
  nav:
author_profile: false
comments: true
topics:
  reproducible-science-and-programming: ['literate-expressive-programming', 'functions']
order: 3
redirect_from:
  - "/courses/earth-analytics/week-8/intro-to-functions-r/"
---


{% include toc title="In This Lesson" icon="file-text" %}



<div class='notice--success' markdown="1">

## <i class="fa fa-graduation-cap" aria-hidden="true"></i> Learning Objectives

After completing this tutorial, you will be able to:

* Write a function in `R`.
* Describe how a function argument is used in a function.

## <i class="fa fa-check-square-o fa-2" aria-hidden="true"></i> What You Need

You will need a computer with internet access to complete this lesson.

</div>


### How to Write a Function in R

There are several parts of a function:

1. **Function name**. This is what you use when you call a function. For example plot(my_data) is a function with the name `plot`. You pass that function my_data and it plots accordingly.
2. **The function() function**: Confusing, right? The `function()` is actually a function that allows you to create a function. Trust us on this one.
3. **Function Arguments:** An argument is what you pass the function. The function will take that object of value provided in the argument and use it to perform some task. In the example above, my_data is actually an argument value. In the case of plot, my_data provides that data that you wish to plot. `main =` in the plot function is the argument that allows you to pass a title to the plot.
4. **Documentation:** Documentation is not required for the function to work. However good documentation will save you time in the future when you need to use this code again.

Below is an example function. Notice that the part of the function that actually
runs or evaluates things, is enclosed in curly braces `{}`.


```r
# this is an example function
function_name <- function(argument1, argument2) {
  # document your function here
  # what the function does
  # function inputs and outputs
  some_calculated_output <- (argument1 + argument2 )
  return(some_calculated_output)
}
```

Now, create a function called `fahr_to_kelvin` that converts temperature values 
from degrees Fahrenheit to Kelvin.

The conversion between the two is as follows :

`temp_in_kelvin <- (temp_fahr - 32) * (5 / 9)) + 273.15`


```r
temp_fahr <- 5
# calculate Kelvin
((temp_fahr - 32) * (5 / 9)) + 273.15
## [1] 258.15
```

Take that same math and create a function that takes the temperature as a
numeric value as an input argument. This function returns temperature in Kelvin.


```r

fahr_to_kelvin <- function(fahr) {
  # function that converts temperature in degrees Fahrenheit to kelvin
  # input: fahr: numeric value representing temp in degrees farh
  # output: kelvin: numeric converted temp in kelvin
  kelvin <- ((fahr - 32) * (5 / 9)) + 273.15
  return(kelvin)
}
```

You define `fahr_to_kelvin` by assigning it to the output of `function`.
The list of argument names are contained within parentheses - in this case `fahr`
is the only argument that this function requires.

Next, the body of the function--the
statements that are executed when it runs--is contained within curly braces (`{}`).
The statements in the body are indented by two spaces, which makes the code easier
to read but does not affect how the code operates.

When you call the function, the values you pass to it are assigned to those
variables so that you can use them inside the function.

Inside the function, you use a return statement
to send a result back to whoever asked for it.

<i class="fa fa-star" aria-hidden="true"></i>**Automatic Returns:** In `R`, it is not necessary to include the return statement.
`R` automatically returns whichever variable is on the last line of the body
of the function. However, sometimes you may want to be explicit with what your
function returns
{: .notice--success}

Run your `fahr_to_kelvin()` function by providing a temperature value in degrees
Fahrenheit:


```r
# freezing point of water
fahr_to_kelvin(32)
## [1] 273.15
# boiling point of water
fahr_to_kelvin(212)
## [1] 373.15
```

<div class="notice--warning" markdown="1">

## <i class="fa fa-pencil-square-o" aria-hidden="true"></i> Challenge
To convert temperature to Celsius from kelvin, you subtract 273.15 from the
temperature value in kelvin. Write a function that performs this conversion called `kelvin_to_celsius()`.

</div>




Run your function to see if it works.


```r
# absolute zero in Celsius
kelvin_to_celsius(0)
## [1] -273.15
```


<div class="notice--warning" markdown="1">

## <i class="fa fa-pencil-square-o" aria-hidden="true"></i> Challenge

Write a function, called inches_to_mm that converts inches of rain to mm.

```r
inches_to_mm <- function(temp_fahr) {
# describe what the function does here
# inputs: Describe the input(s) that the function takes and the format of the input (ie numeric, character, data.frame, etc)
# outputs: Describe the output(s) and associated output format

# calculate mm

return()

}
```

</div>



## More About Functions

The content below is from the Software Carpentry functions lessons. While you won't 
learn the content below in this class, read through it to better understand
how you can begin to use functions to create more complex programs.

What about converting Fahrenheit to Celsius? You could write out the formula, but 
you don't need to. Instead, you can compose the two functions you have already created:


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

This is our first taste of how larger programs are built: you define basic
operations, then combine them in ever-larger chunks to get the effect you want.
Real-life functions will usually be larger than the ones shown here--typically
half a dozen to a few dozen lines--but they shouldn't ever be much longer than
that, or the next person who reads it won't be able to understand what's going on.

Even more important than avoiding long functions is ensuring that the logic of
your function is expressed by the code that comprises your function.
For instance, it is nearly always better to use meaningful variable names such
as `fahr` instead of simply `temp`, which could be taken to mean temporary, or
temperature (in what units?).

You might be surprised at the human mental expense required to comprehend all of
the objects and operations in long functions.

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


<div class="notice--info" markdown="1">

## Additional Resources

* <a href="https://swcarpentry.github.io/r-novice-inflammation/02-func-R/" target = "_blank">Software Carpentry lesson on functions</a>

</div>
