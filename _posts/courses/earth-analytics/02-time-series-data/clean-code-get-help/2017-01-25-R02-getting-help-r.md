---
layout: single
title: "Get Help with R - Data Science for Scientists 101"
excerpt: "This tutorial covers ways to get help when you are not sure how to perform a task in R. "
authors: ['Data Carpentry', 'Leah Wasser']
category: [courses]
class-lesson: ['write-clean-code']
permalink: /courses/earth-analytics/time-series-data/ways-to-get-help-with-R/
nav-title: 'About R / Get Help'
dateCreated: 2016-12-13
modified: '2018-01-10'
week: 2
sidebar:
  nav:
author_profile: false
comments: true
order: 2
course: "earth-analytics"
topics:
  reproducible-science-and-programming: ['RStudio']
---

{% include toc title="In this lesson" icon="file-text" %}

Getting help

<div class='notice--success' markdown="1">

## <i class="fa fa-graduation-cap" aria-hidden="true"></i> Learning Objectives
At the end of this activity, you will be able to:

* List 2 ways that you can get help when you are stuck using `R`.
* List several features of `R` that makes it a versatile tool for scientific programming.

## <i class="fa fa-check-square-o fa-2" aria-hidden="true"></i> What You Need

A computer with internet access.

</div>

## Basics of R

`R` is a versatile, open source programming/scripting language that's useful both
for statistics but also data science. Inspired by the programming language `S`.

* Free/Libre/Open Source Software under the [GPL version 2](https://www.gnu.org/licenses/old-licenses/gpl-2.0.html).
* Superior (if not just comparable) to commercial alternatives. `R` has over 7,000
  user contributed packages at this time. It's widely used both in academia and
  industry.
* Available on all platforms.
* Not just for statistics, but also general purpose programming.
* For people who have experience in programmming: `R` is both an object-oriented
  and a so-called [functional language](http://adv-r.had.co.nz/Functional-programming.html).
* Large and growing community of peers.

## Seeking Help

Below outlines a few ways that you can get help when you are stuck in `R`.


## I know the name of the function I want to use, but I'm not sure how to use it.

If you need help with a specific function, let's say `barplot()`, you can type:


```r
?barplot
```

When you use the `?barplot` in the `R` console, you asking `R` to look for the documentation
for the `barplot()` function.

If you just need to remind yourself of the names of the arguments that can be used
with the function, you can use:


```r
args(lm)
```

## I want to use a function that does X, there must be a function for it but I don't know which one...

If you are looking for a function to do a particular task, you can use
`help.search()` function, which is called by the double question mark `??`.
However, this only looks through the installed packages for help pages with a
match to your search request


```r
??kruskal
```

If you can't find what you are looking for, you can use the
[rdocumention.org](http://www.rdocumentation.org) website that searches through
the help files across all packages available.

## I am stuck...I get an error message that I don't understand.

Start by googling the error message. However, this doesn't always work very well
because often, package developers rely on the error catching provided by `R`. You
end up with general error messages that might not be very helpful to diagnose a
problem (e.g. "subscript out of bounds"). If the message is very generic, you might
also include the name of the function or package you're using in your query.

However, you should check StackOverflow. Search using the `[r]` tag. Most
questions have already been answered, but the challenge is to use the right
words in the search to find the answers:
[http://stackoverflow.com/questions/tagged/r](http://stackoverflow.com/questions/tagged/r)

The [Introduction to R](http://cran.r-project.org/doc/manuals/R-intro.pdf) can
also be dense for people with little programming experience but it is a good
place to understand the underpinnings of the R language.

The [R FAQ](http://cran.r-project.org/doc/FAQ/R-FAQ.html) is dense and technical
but it is full of useful information.


<div class='notice--info' markdown="1">

# Where to Get Help

* Ask your colleagues: if you know someone with more experience than you,
  they might be able to help you.
* [StackOverflow](http://stackoverflow.com/questions/tagged/r): if your question
  hasn't been answered before and is well crafted, chances are you will get an
  answer in less than 5 min. Remember to follow their guidelines on [how to ask
  a good question](http://stackoverflow.com/help/how-to-ask).
* There are also some topic-specific mailing lists (GIS, phylogenetics, etc...),
  the complete list is [here](http://www.r-project.org/mail.html).

## More Resources

* The [Posting Guide](http://www.r-project.org/posting-guide.html) for the `R`
  mailing lists.
* <a href="http://blog.revolutionanalytics.com/2014/01/how-to-ask-for-r-help.html" target="_blank" data-proofer-ignore=''>How to ask for R help useful guidelines</a>
* <a href="http://codeblog.jonskeet.uk/2010/08/29/writing-the-perfect-question/" target="_blank" data-proofer-ignore=''>
  This blog post by Jon Skeet has a comprehensive advice on how to ask programming questions.</a>
</div>
