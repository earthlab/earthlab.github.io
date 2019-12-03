---
layout: single
title: 'Setup Your Earth Analytics Working Directory'
excerpt: 'This tutorial walks you through how to create your earth-analytics working directory in bash. It also covers how to change the working directory in Jupyter Notebook.'
authors: ['Leah Wasser']
modified: 2018-09-14
category: [courses]
class-lesson: ['open-science-python']
permalink: /courses/earth-analytics-python/python-open-science-toolbox/setup-earth-analytics-working-directory/ 
nav-title: 'Setup Working Directory'
week: 1
sidebar:
    nav:
author_profile: false
comments: true
order: 6
course: "earth-analytics-python"
topics:
   reproducible-science-and-programming: ['python']
---
{% include toc title="In This Lesson" icon="file-text" %}

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
* Set a working directory using the `Jupyter Notebook` interface using `os.chdir`.

## <i class="fa fa-check-square-o fa-2" aria-hidden="true"></i> What You Need

You will need the most current version of `Jupyter Notebook` and `earth-analytics-python` environment loaded on
your computer to complete this lesson.

</div>


## Create earth-analytics Project Directory

Now that you have the basics of good project structure out of the way, let's get
your project set up. You are going to create an `earth-analytics` project directory
(or folder) where you will store data and files used in the class. You will then
set that **project directory** as your **working directory** in `python` using the syntax.

`os.chdir(os.path.join(et.io.HOME, 'earth-analytics'))`

<i class="fa fa-star"></i> **Data Tip:** Directory vs Folder: You can think
of a directory as a folder. However the term directory considers the relationship
between that folder and the folders within it and around it (it's full path).
{: .notice--success}

Follow the steps below to create an `earth-analytics` project directory on your
computer and then a data directory located within that project directory. The 
steps below use `bash` to create your directory. YOu could also create this manually using 
`File Explorer` on a `Mac` or `windows explorer` on `Windows`.

* Navigate to the `home` directory on your computer. This is likely a directory that ends with our username like:

On a MAC: `/Users/yourUserName`
On a PC: `/c/Users/yourUserName

```bash
# navigate to your home directory
cd
```

* In the directory, create a NEW DIRECTORY called `earth-analytics`.

```bash
mkdir -p earth-analytics/data
```

Above the -p argument makes a directory recursively - this means it will make both the `earth-analytics` and the `data` directory within it. 

<i class="fa fa-star"></i> **Data Tip:** Notice that you are creating an easy to
read directory name. The name has no spaces and uses all lower case to support
machine reading down the road. Sometimes this format of naming using dashes is
referred to as a `slug`.
{: .notice--success}


<figure>
	<a href="{{ site.url }}/images/courses/earth-analytics/document-your-science/setup-r-rstudio/working-dir-os.png">
	<img src="{{ site.url }}/images/courses/earth-analytics/document-your-science/setup-r-rstudio/working-dir-os.png" alt="working directory screenshot"></a>
	<figcaption> Your project directory should look like this. Right now it just
	contains one directory called data.
	</figcaption>
</figure>

Once you have setup your working directory, you are ready to test things out in Jupyter.
To begin, activate the `earth-analytics-python` environment on your computer and launch `jupyter notebook`.

Then import the `os` and `earthpy` python packages.

{:.input}
```python
import os
import earthpy as et
```

Finally, you can use the function below to set your working directory to your home/earth-analytics directory.


{:.input}
```python
os.chdir(os.path.join(et.io.HOME, 'earth-analytics'))
```

The function below uses several functions

1. `os.chdir()` is a function in the `os` package that is used to change your working directory. If you want you could manually add a path in quotes to the function to change your directory like this:

`os.chdir("path/to/dir/here")`

2. the os.path.join() function allows you to build a path from a set of strings. This is a useful function because the path structure can vary on different operating systems. For instance the `/` slash is used on a mac whereas often windows uses `\`. By using `os.path.join` your code will work on any machine that has the directory structure that you list in the function. Thus your work is more reproducible.


{:.input}
```python
os.path.join("look","im","making","a","path")
```

{:.output}
{:.execute_result}



    'look/im/making/a/path'





`et.io.HOME` is a function build to automagically find the home directory on your computer. Below you see the home for the computer where this notebook lives is: 

`/Users/lewa8222`

{:.input}
```python
et.io.HOME
```

{:.output}
{:.execute_result}



    '/Users/lewa8222'





So this code: `os.path.join(et.io.HOME, 'earth-analytics')` creates the full path and `os.chdir()` tells jupyter to change the working directory for the notebook to that path.

Make sure that you have an earth-analytics directory setup on your computer in the home directory. If you don't have this setup, then it is possible that your instructor may not be able to run your code without editing it. Your instructor will not edit your code to ensure it runs during this course!
