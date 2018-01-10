---
layout: single
title: "How to Reuse Functions That You Create In Scripts - Source a Function in R"
excerpt: "Learn how to source a function in R. Learn how to import functions that are stored in a separate file into a script or R Markdown file."
authors: ['Leah Wasser']
modified: '2018-01-10'
category: [courses]
class-lesson: ['automate-spatial-data-analysis-r']
permalink: /courses/earth-analytics/multispectral-remote-sensing-data/source-function-in-R/
nav-title: 'Source Functions R'
module-title: 'R Source Functions - Efficient Programming'
module-description: 'Learn how to source a function in R by saving the function in another R script.'
module-nav-title: 'Source Functions in R'
week: 7
module-type: 'class'
course: "earth-analytics"
sidebar:
  nav:
author_profile: false
comments: true
order: 1
class-order: 2
topics:
  reproducible-science-and-programming:
    ['literate-expressive-programming', 'functions']
lang-lib:
  r: []
redirect_from:
---

<!-- primary source a function in R sv -0-10 -->

{% include toc title="In This Lesson" icon="file-text" %}



<div class='notice--success' markdown="1">

## <i class="fa fa-graduation-cap" aria-hidden="true"></i> Learning Objectives

After completing this tutorial, you will be able to:

* Calculate NDVI using NAIP multispectral imagery in `R`.
* Describe what a vegetation index is and how it is used with spectral remote sensing data.

## <i class="fa fa-check-square-o fa-2" aria-hidden="true"></i> What You Need

You will need a computer with internet access and `R` / `R Studio` loaded to
complete this lesson.

</div>

## Where to Store Your Functions

When you create a function to use in your analysis, you often create it and
store it at the top of your script or `.Rmd` file as a first step. However,
lots of functions at the top of your code can make your code dense and harder
to read.

It is good practice to create separate `R` scripts that you can use to
store sets of related functions. You can then call those functions using the
`source()` function, at the top of your script in the same way that you call an
`R` package. `R` will then load those functions into memory and you can use them!

Sourcing functions is good practice because it is:

1. **Reusable:** It allows you to reuse functions over and over using the same code (i.e. you don't have to copy and paste the function into each new analysis script).
2. **Easy to Maintain:** It allows you to quick fix a function that doesn't work properly - only once.
3. **Sharable:** In the same way that a library can be used by anyone, you can share your `R` script containing your functions with anyone too. This is the first step towards creating an `R` package!


## How to Source Functions in R

To source a set of functions in `R`:

1. Create a new `R Script` (.R file) in the same working directory as your `.Rmd` file or `R` script. Give the file a descriptive name that captures the types of functions in the file.
2. Open that `R Script` file and add one or more functions to the file.
3. Save your file.

Next,

* Open your `.Rmd` file or `R` script.
* At the top of your file, add the `source(path/tofile/here.R)` function.

`source("remote-sensing-functions.R")`

If the `.R` script is in your main working directory then it won't have a path
element before it like `week_06/functionfile.R` vs `functionfile.R`.

If it's in a different directory, adjust the path accordingly.
Once you run the code containing the `source()` function, all of the functions in
your `.R` file will load into your global environment. You can now use them in your
script!

<div class="notice--info" markdown="1">

## Additional Resources

* <a href="https://nicercode.github.io/guides/functions/" target = "_blank">NicerCode.com Guide to Functions</a>

</div>
