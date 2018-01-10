---
layout: single
title: "Add Images to an R Markdown Report"
excerpt: "This lesson covers how to use markdown to add images to a report. It also discusses good file management practices associated with saving images within your project directory to avoid losing them if you have to go back and work on the report in the future."
authors: ['Leah Wasser']
modified: '2018-01-10'
category: [courses]
class-lesson: ['intro-rmarkdown-knitr']
permalink: /courses/earth-analytics/document-your-science/add-images-to-rmarkdown-report/
nav-title: 'Add images to R Markdown'
course: "earth-analytics"
week: 1
sidebar:
  nav:
author_profile: false
comments: true
order: 6
topics:
  reproducible-science-and-programming: ['rmarkdown']
---

{% include toc title="In this lesson" icon="file-text" %}


<div class='notice--success' markdown="1">

## <i class="fa fa-graduation-cap" aria-hidden="true"></i> Learning Objectives

After completing this tutorial, you will be able to:

* Add an image to an `R markdown` report.
* Describe the ideal location to store an image associated with an `R markdown` report
so that `knitr` can find it when it renders a file.

## <i class="fa fa-check-square-o fa-2" aria-hidden="true"></i> What You Need

You need `R` and `RStudio` to complete this tutorial. Also you should have
an `earth-analytics` directory set up on your computer with a `/data`
directory with it.

* [How to set up R / RStudio](/courses/earth-analytics/document-your-science/setup-r-rstudio/)
* [Set up your working directory](/courses/earth-analytics/document-your-science/setup-working-directory/)

</div>


## Add an Image to Your Report

You can add images to an `R Markdown` report using markdown syntax as follows:

```md
![alt text here](path-to-image-here)
```

However, when you knit the report, `R` will only be able to find your image if you
have placed it in the right place - RELATIVE to your `.Rmd` file. This is where
good file management becomes extremely important.

To make this simple, let's set up a directory named **images** in your earth-analytics
project / working directory. If your `.Rmd` file is located in the root of this directory
and all images that you want to include in your report are located in the
images directory within the earth-analytics directory, then the path that you
would use for each image would look like:

`images/week3/image-name-here.png`

Let's try it with an actual image.

```md
![an image caption Source: Ultimate Funny Dog Videos Compilation 2013.](images/week3/silly-dog.png)
```
And here's what that code does IF the image is in the right place:

![an image caption Source: Ultimate Funny Dog Videos Compilation 2013.]({{ site.url }}/images/courses/earth-analytics/lidar-raster-data-r/silly-dog.png)

If all of your images are in your images directory, then `knitr` will be able to
easily find them. This also follows good file management practices because
all of the images that you use in your report are contained within your
project directory.

<div class="notice--info" markdown="1">

## Additional Resources

* <a href="https://www.rstudio.com/wp-content/uploads/2015/02/rmarkdown-cheatsheet.pdf" target="_blank">R studio R / markdown cheat sheet</a>

</div>
