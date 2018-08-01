---
layout: single
authors: ['Max Joseph', 'Leah Wasser']
category: courses
title: 'Automate Workflows Using Loops in R'
attribution: ''
excerpt: 'When you are programming, it can be easy to copy and paste code that works. However this approach is not efficient. Learn how to create for-loops to process multiple files in R.'
dateCreated: 2018-01-29
modified: '2018-02-02'
nav-title: 'Write Loops'
sidebar:
  nav:
module: "clean-coding-tidyverse-intro"
permalink: /workshops/clean-coding-tidyverse-intro/automate-data-processing-with-loops-in-r/
author_profile: false
comments: true
order: 5
topics:
  reproducible-science-and-programming: ['literate-expressive-programming']
---

{% include toc title="In this lesson" icon="file-text" %}

<!--  This is the top block with the learning objectives (LO) -->
<div class='notice--success' markdown="1">

## <i class="fa fa-graduation-cap" aria-hidden="true"></i> Learning objectives
At the end of this activity, you will be able to:

* Use for-loops to handle repetitive tasks
* Bind multiple data frames together by row

## <i class="fa fa-check-square-o fa-2" aria-hidden="true"></i> What you need

Follow the setup instructions here:

* [Setup instructions]({{ site.url }}/workshops/clean-coding-tidyverse-intro/)

</div>


[<i class="fa fa-download" aria-hidden="true"></i> Overview of clean code ]({{ site.url }}/courses/earth-analytics/automate-science-workflows/write-efficient-code-for-science-r/){:data-proofer-ignore='' .btn }

## Don't Repeat Yourself (DRY)

The DRY (Don't Repeat Yourself) principles refers to repeating code over and over
in a script. When you notice yourself doing this, it's a good time to consider
whether there is another approach that may be more efficient.

A snippet of the code that we examined at the beginning of this workshop is below.
Notice here, our colleague is building a `data.frame` of elements, manually, line
by line.

```r
finalSUMMARYmean <- data.frame(jan_mean_2003 = mean(myFinalData$HPCP[myFinalData$month == "01"], na.rm = TRUE),
                           feb_mean_2003 = mean(myFinalData$HPCP[myFinalData$month == "02"], na.rm = TRUE),
                           march_mean_2003 = mean(myFinalData$HPCP[myFinalData$month == "03"], na.rm = TRUE),
                           apr_mean_2003 = mean(myFinalData$HPCP[myFinalData$month == "04"], na.rm = TRUE),
                           may_mean_2003 = mean(myFinalData$HPCP[myFinalData$month == "05"], na.rm = TRUE),
                           june_mean_2003 = mean(myFinalData$HPCP[myFinalData$month == "05"], na.rm = TRUE),
                           may_mean_2003 = mean(myFinalData$HPCP[myFinalData$month == "06"], na.rm = TRUE),
                           july_mean_2003 = mean(myFinalData$HPCP[myFinalData$month == "07"], na.rm = TRUE),
                           aug_mean_2003 = mean(myFinalData$HPCP[myFinalData$month == "08"], na.rm = TRUE),
                           sept_mean_2003 = mean(myFinalData$HPCP[myFinalData$month == "09"], na.rm = TRUE),
                           oct_mean_2003 = mean(myFinalData$HPCP[myFinalData$month == "09"], na.rm = TRUE),
                           nov_mean_2003 = mean(myFinalData$HPCP[myFinalData$month == "11"], na.rm = TRUE),
                           dec_mean_2003 = mean(myFinalData$HPCP[myFinalData$month == "12"], na.rm = TRUE))

finalSUMMARYmean
```

Similarly, our colleague may opt to open  a set of csv files line by line.

```r
myDATA1 <- read.csv("https://s3-us-west-2.amazonaws.com/earthlab-teaching/vchm/My_Data2004.csv",
                   na.strings = c("999.99"))

myDATA2 <- read.csv("https://s3-us-west-2.amazonaws.com/earthlab-teaching/vchm/My_Data2005.csv",
                                      na.strings = c("999.99"))

myDATA3 <- read.csv("https://s3-us-west-2.amazonaws.com/earthlab-teaching/vchm/My_Data2006.csv",
                                                         na.strings = c("999.99"))
```

We refer to this as copy pasta. When you repeat code over and over. The DRY
principle supports automating these types of tasks using for-loops, functions
and other approaches. In this lesson we will review using for loops to automate
opening and aggregating a set of `.csv` files.

<figure>
 <a href="{{ site.url }}/images/workshops/open-science/dont-repeat-yourself-code-copy-pasta.png">
 <img src="{{ site.url }}/images/workshops/open-science/dont-repeat-yourself-code-copy-pasta.png" alt="Copy pasta refers to repeating the same code over and over with a slight adjustment to perform a set of tasks."></a>
 <figcaption>Copy pasta refers to repeating the same code over and over with a slight adjustment to perform a set of tasks. When you plan ahead and automate your code by using loops, functions and pseudocode to plan out your approach, you will write more efficient code.
 </figcaption>
</figure>

## For-loops in R

For-loops provide a way to iterate over objects in `R`.
For example, pretend you want to print each number in a sequence of numbers:
`1:10`. You can do that with a for loop as follows:


```r
numbers <- 1:10
for (i in numbers) {
  print(i)
}
## [1] 1
## [1] 2
## [1] 3
## [1] 4
## [1] 5
## [1] 6
## [1] 7
## [1] 8
## [1] 9
## [1] 10
```

In the above for-loop, the object `i` will take on the values in `numbers`
sequentially: first `i` will be set to the first element in `numbers` (1), then
it will be set to the second element (2), and so on, until finally `i = 10`.
Everything contained within the curly braces `{...}` is considered the **body**
of the for-loop, and this will be executed for every iteration of the loop.

IMPORTANT: The variable, `i`, and any other variable in the for-loop will
persist as an object in your `R` environment after the for-loop is done
executing. This is the opposite of what you may have
learned working with functions.


```r
i
## [1] 10
```

You can use a for-loop in the same way with a character vector:


```r
charvec <- c('first element', 'second element', 'third element')
for (i in charvec) {
  print(i)
}
## [1] "first element"
## [1] "second element"
## [1] "third element"
```

Notice here that `i` takes on the values of the elements of `charvec`.

When iterating over objects with loops, it is often useful to use the `seq_along`
function to create a numeric sequence of element indices.
For example, here's what `seq_along` returns when given our `charvec` as an input:


```r
seq_along(charvec)
## [1] 1 2 3
```

<i fa fa-star></i>**Protip**: Using `seq_along` in a for-loop allows you to get numeric indices for the object that you want to iterate over:
{: .notice--success}


```r
for (i in seq_along(charvec)) {
  print(paste('i =', i))
}
## [1] "i = 1"
## [1] "i = 2"
## [1] "i = 3"
```

Of course, if you wanted to iterate over `charvec` and still get the character
elements, you can use these `i` values as indices:


```r
for (i in seq_along(charvec)) {
  print(paste('charvec[i] =', charvec[i]))
}
## [1] "charvec[i] = first element"
## [1] "charvec[i] = second element"
## [1] "charvec[i] = third element"
```

### Populate Objects with For-loops

Suppose you wanted to create a list, and have each element in that list be some
number. You could create an empty list, then populate each element in that list
using a for loop.


```r
my_list <- list()
for (i in seq_along(charvec)) {
  my_list[i] <- charvec[i]
}
```

Let's dissect this a bit.

1. First, you create an empty list using `my_list <- list()`. This is the object that you will populate in the loop.
2. Then, you use `seq_along(charvec)` as the thing to iterate over with our for-loop, so that first `i=1`, then `i=2`, then `i=3`, because there are 3 elements in `charvec`.
3. Finally, within the body of the for loop (between the curly braces), you assign `charvec[i]` to be the #i element in `my_list`.

<div class="notice--warning" markdown="1">

## <i class="fa fa-pencil-square-o" aria-hidden="true"></i> Answer the following:
* What will `my_list` be after this for-loop?
+What is its class?
+What is its length?
+What is the first element?
</div>

Let's have a look:


```r
class(my_list)
## [1] "list"
```


```r
length(my_list)
## [1] 3
```


```r
my_list
## [[1]]
## [1] "first element"
##
## [[2]]
## [1] "second element"
##
## [[3]]
## [1] "third element"
```


<div class="notice--warning" markdown="1">

## <i class="fa fa-pencil-square-o" aria-hidden="true"></i> Challenge

There are multiple url's in the `data/data_urls.csv` file that you provided in this
workshop. Your challenge is to combine all of the `.csv` files into 1 data.frame in `R`.

Your list of url's looks something like the code below


```r
urls <- c(
  'https://s3-us-west-2.amazonaws.com/earthlab-teaching/vchm/My_Data2003-boulder.csv',
  'https://s3-us-west-2.amazonaws.com/earthlab-teaching/vchm/My_Data2003-denver.csv',
  'https://s3-us-west-2.amazonaws.com/earthlab-teaching/vchm/My_Data2003-lyons.csv'
)
```

Lost? Here are a few functions that may help you out.

* You might find it useful to populate a list, so that each element in your list is a `data.frame`.
* You can create one data.frame from a list of data.frames using the function, `bind_rows(list_object_here)`. bind_rows is a `dplyr` function that combines data.frames contained in a list row-wise (it stacks them on top of each other).
</div>


<div class="notice--info" markdown="1">

## Additional resources

You may find the materials below useful as an overview of what we cover
during this workshop:

* <a href="{{ site.url }}/courses/earth-analytics/automate-science-workflows/">Functions, loops and automation - Earth Analytics Course Module</a>

</div>
