---
layout: single
title: "Get to Know the Function Environment & Function Arguments in R"
excerpt: "This lesson introduces the function environment and documenting functions in R. When you run a function intermediate variables are not stored in the global environment. This not only saves memory on your computer but also keeps our environment clean, reducing the risk of conflicting variables."
authors: ['Max Joseph', 'Software Carpentry', 'Leah Wasser']
modified: '2018-01-10'
category: [courses]
class-lesson: ['automating-your-science-r']
permalink: /courses/earth-analytics/automate-science-workflows/document-functions-in-r/
nav-title: 'Document Functions'
week: 6
course: "earth-analytics"
sidebar:
  nav:
author_profile: false
comments: true
topics:
  reproducible-science-and-programming: ['literate-expressive-programming', 'functions']
order: 4
redirect_from:
  - "/courses/earth-analytics/week-8/function-documentation-environment-r/"
---

{% include toc title="In This Lesson" icon="file-text" %}



<div class='notice--success' markdown="1">

## <i class="fa fa-graduation-cap" aria-hidden="true"></i> Learning Objectives

After completing this tutorial, you will be able to:

* Document a function in R describing the function purpose, inputs, outputs and associated structures.
* Describe what happens to intermediate variables processed during a function call.

## <i class="fa fa-check-square-o fa-2" aria-hidden="true"></i> What You Need

You will need a computer with internet access to complete this lesson.

</div>

In the last lesson, you learned how to create a function in `R`. You learned that
functions are efficient ways to reduce variables in your global environment.
In this lesson your will explore that further. You will also explore function arguments.

## The Function Environment is Self-contained

As discussed in the previous lessons, there are many benefits to using functions in your code including:

1. Functions make your code lesson complex by grouping sets of well-defined tasks into discrete lines of code.
2. Expressiveness - well named functions will make your code more expressive or self descriptive. As you scan the code, what it does is more clear.

However, functions also save memory by keeping intermediately created objects out
of your global environment.

The function environment is self-contained. This  means that when you
run a function, it does not create intermediate variables in your global environment.

For example, in the previous lessons, you created a function called
`fahr_to_celsius`. Within that function, you created two variables:

1. `kelvin`
2. `celsius`

Run the function below. Then call it `fahr_to_celsius(15)`. Look closely at
your global environment in `R`. Do you see the variables `temp_k` or `result`
in your list of variables in R Studio?


```r
fahr_to_celsius <- function(fahr) {
  kelvin <- fahr_to_kelvin(fahr)
  celsius <- kelvin_to_celsius(kelvin)
  celsius
}

fahr_to_celsius(15)
## [1] -9.444444
```

When you run the function above, it creates a new temporary environment where it runs
the steps required to complete the tasks specified in the function. However,
the variables defined by each intermediate steps are not retained in your global
environment. These variables only exist within the function environment. This
is convenient for you because each variable that you create consumes
memory on your computer. It also reduces the "clutter" associated with too many
variables in your global environment which could conflict further down in your
code. For example you may have another variable called "celsius" in your code
code further down.


## Documentation

It is important to document your functions to:

1. Remind your future self what the function does
1. Show your future self and your colleagues how to use the function
1. Help anyone else looking at your code understand what **you think** the function does

Note that your written documentation can at best describe what **you think** the function does, because ultimately the code itself is the only true documentation for the what the function **actually** does.
{: .notice--success }

A common way to add documentation in software is to add comments to your function
that specify

1. What does this function do?
2. What are the arguments (inputs) to the function, and what are these supposed to be (e.g., what class are they? Character, numeric, logical?)
3. What does the function return, and what kind of object is it?

Like this:


```r
fahr_to_celsius <- function(fahr) {
  # convert temperature in fahrenheit to celsius
  # args: temperature in degrees F (numeric)
  # returns: temperature in degrees celsius (numeric)
  kelvin <- fahr_to_kelvin(fahr)
  celsius <- kelvin_to_celsius(kelvin)
  celsius
}
```

<div class="notice--success" markdown="1">

## Writing Documentation
Formal documentation for `R` functions that you see when you access the help in
`R` is written in separate `.Rd` using a
markup language similar to LaTeX. You see the result of this documentation
when you look at the help file for a given function, e.g. `?read.csv`.
The `roxygen2` package allows `R` coders to write documentation alongside
the function code and then process it into the appropriate `.Rd` files.
You should consider switching this more formal method of writing documentation
when you start working on more complicated `R` projects. Or if you aspire to
write packages in R!

* <a href="http://www.latex-project.org/" target="_blank">More on LaTeX</a>
* <a href="http://cran.r-project.org/web/packages/roxygen2/vignettes/rd.html" target="_blank"> More on roxygen2</a>

</div>
