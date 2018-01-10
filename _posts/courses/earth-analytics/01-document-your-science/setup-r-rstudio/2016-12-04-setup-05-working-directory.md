---
layout: single
authors: ['Leah Wasser', 'Software Carpentry']
category: [courses]
title: 'Create a Project & Working Directory Setup'
excerpt: 'Learn how to create a well-organized working directory to store your course data.'
nav-title: 'Set up working directory'
week: 1
sidebar:
  nav:
class-lesson: ['setup-r-rstudio']
permalink: courses/earth-analytics/document-your-science/setup-working-directory/
dateCreated: 2016-12-12
modified: '2018-01-10'
author_profile: false
comments: true
order: 5
course: "earth-analytics"
topics:
  reproducible-science-and-programming: ['data-management','RStudio']
---

{% include toc title="In this lesson" icon="file-text" %}



## Set Up Your Working Directory

As you learned in the previous tutorial, project organization is integral to
efficient research. In this tutorial, you will create the project directory that
you will use for all of your work. This project directory will be carefully
organized with a `\data` directory that you will use to save all of the data you
use in your lessons.

<div class='notice--success' markdown="1">

## <i class="fa fa-graduation-cap" aria-hidden="true"></i> Learning Objectives
At the end of this activity, you will be able to:

* Create an easy to use and well structured project structure.
* Set a working directory in `R` using code.
* Set a working directory using the `RStudio` interface.

## <i class="fa fa-check-square-o fa-2" aria-hidden="true"></i> What You Need

You will need the most current version of `R` and, preferably, `RStudio` loaded on
your computer to complete this tutorial.

* [How to set up R / RStudio](/courses/earth-analytics/document-your-science/setup-r-rstudio/)

</div>


## Create earth-analytics Project Directory

Now that you have the basics of good project structure out of the way, let's get
your project set up. You are going to create an `earth-analytics` project directory
(or folder) where you will store data and files used in the class. You will then
set that **project directory** as your **working directory** in `R`.

<i class="fa fa-star"></i> **Data Tip:** Directory vs Folder: You can think
of a directory as a folder. However the term directory considers the relationship
between that folder and the folders within it and around it (it's full path).
{: .notice--success}

Follow the steps below to create an `earth-analytics` project directory on your
computer and then a data directory located within that project directory.

* Navigate to the `Documents` directory on your computer.
* In the directory, create a NEW DIRECTORY called `earth-analytics`.

<i class="fa fa-star"></i> **Data Tip:** Notice that you are creating an easy to
read directory name. The name has no spaces and uses all lower case to support
machine reading down the road. Sometimes this format of naming using dashes is
referred to as a `slug`.
{: .notice--success}

* Next, open the earth-analytics directory and create a directory within it
called `data`

> You will use the data directory to store the data that you download to use in
> this course and in the tutorials hosted on this website.

<figure>
	<a href="{{ site.url }}/images/courses/earth-analytics/document-your-science/setup-r-rstudio/working-dir-os.png">
	<img src="{{ site.url }}/images/courses/earth-analytics/document-your-science/setup-r-rstudio/working-dir-os.png" alt="working directory screenshot"></a>
	<figcaption> Your project directory should look like this. Right now it just
	contains one directory called data.
	</figcaption>
</figure>

* The final step is optional but recommended - especially if you are new to `R`
and `RStudio`. Open up `RStudio` and set your default working directory
to the `earth-analytics` directory that you just created. In `RStudio` go to:
Tools --> Global Options --> Click on the General setting at the top of the global
options panel` (see screen shot below).
* Browse to the `earth-analytics` directory and set it as your default working directory.

<figure>
	<a href="{{ site.url }}/images/courses/earth-analytics/document-your-science/setup-r-rstudio/r-studio-wd-setup.png">
	<img src="{{ site.url }}/images/courses/earth-analytics/document-your-science/setup-r-rstudio/r-studio-wd-setup.png" alt="setup working directory in rstudio"></a>
	<figcaption> Set your default working directory in RStudio to the Earth Analytics
  directory. That way, every time you open `RStudio` it will default to that
  directory. Image: RStudio Version 0.99.903.
	</figcaption>
</figure>

When you set a default working directory, every time you open `RStudio` it will
default to that working directory being set. This can be nice if you are going
to always work in the same directory (like you will in all tutorials).

Finally, let's see what your main working directory looks like. Use the  `getwd()`
function to find out what your current working directory is in `R`.


```r

# view working directory
getwd()

```


```r
[1] "/Users/lewa8222/Documents/earth-analytics"
```

If your working directory path does not match the location where you created your
`earth-analytics` directory on your computer, then you need to fix it. You can
set the working directory with `R` code OR you can use the `RStudio` interface to
set the working directory.

### Set Working Directory in RStudio Interface

Let's set the working directory using the `RStudio` interface.

* In the `RStudio` interface, look at the pane in the LOWER LEFT hand corner of your
screen. It should have a tab called `Files` which opens the files window. In
the files window, navigate to your `earth-analytics` directory which should be
within the `Documents` directory.

Your window should look like the screen shot below:

<figure>
	<a href="{{ site.url }}/images/courses/earth-analytics/document-your-science/setup-r-rstudio/working-directory.png">
	<img src="{{ site.url }}/images/courses/earth-analytics/document-your-science/setup-r-rstudio/working-directory.png" alt="working directory screenshot"></a>
	<figcaption> Your working directory should look like this. It should contain
	just a `data` directory. Image: RStudio Version 0.99.903. Source: Earth Lab.
	</figcaption>
</figure>

* Next, click on the `More` drop down. Choose `Set as working directory`

<figure>
	<a href="{{ site.url }}/images/courses/earth-analytics/document-your-science/setup-r-rstudio/set-working-dir-rstudio.png">
	<img src="{{ site.url }}/images/courses/earth-analytics/document-your-science/setup-r-rstudio/set-working-dir-rstudio.png" alt="rstudio working directory set"></a>
	<figcaption> You can set your working directory in RStudio directly. Image: RStudio Version 0.99.903. Source: Earth Lab.
	</figcaption>
</figure>


## Set Working Directory Using Code

You can set the working directory  using code in R too. You don't have to do this
if you already set the working directory above. However, it's good to know how
to do it - particularly if you get into more advanced scripting in `R`. You use the
 `setwd()` function to set a new working directory as follows:



```r

# set working directory - MAC File Structure - backslashes
setwd("/Users/lewa8222/Documents/earth-analytics")

# a windows machine uses front slashes. There is normally a
# drive letter like C:\
setwd("C:\Users\lewa8222\Documents\earth-analytics")

```

## All Done!
Great work! You are now ready to start working with `RStudio`!
