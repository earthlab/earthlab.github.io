---
layout: single
title: "Write Clean Code in R"
excerpt: "#"
authors: ['Leah Wasser', 'Data Carpentry']
category: [course-materials]
class-lesson: ['get-to-know-r']
permalink: /course-materials/earth-analytics/week-2/write-clean-code-with-r/
nav-title: 'Write Clean Code'
dateCreated: 2016-12-13
lastModified: 2016-12-28
week: 2
sidebar:
  nav:
author_profile: false
comments: false
order: 6
---

.

<div class='notice--success' markdown="1">

# Learning Objectives
At the end of this activity, you will be able to:

* write code using Hadley Wickham's style guide

## What You Need

You need `R` and `RStudio` to complete this tutorial. Also we recommend have you
have an `earth-analytics` directory setup on your computer with a `/data`
directory with it.

* [How to Setup R / R Studio](/course-materials/earth-analytics/week-1/setup-r-rstudio/)
* [Setup your working directory](/course-materials/earth-analytics/week-1/setup-working-directory/)

</div>


Clean code means that your code is organized in a way that is easy for you and
for someone else to follow / read. Certain conventions are suggested to make code
easier to read. For example, many guides suggest the use of a space after a comment.
Like so:

```r
#poorly formatted  comments are missing the space after the pound sign.
# good comments have a space after the pound sign
```

While these types of guidelines may seem unimportant when you first begin to code,
after a while you're realize that consistently formatted code is much easier
for your eye to scan and quickly understand.

## Consistent, Clean Code

Take some time to review <a href="http://adv-r.had.co.nz/Style.html" target="_blank">Hadley Wickham's style guide</a>. From here on in, we will
follow this guide for all of the assignments in this class.
