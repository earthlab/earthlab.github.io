---
layout: single
title: 'Use Git and Github to Get Course Files'
excerpt: '.'
authors: ['Leah Wasser', 'Jenny Palomino']
modified: 2018-09-25
category: [courses]
class-lesson: ['open-science-python']
permalink: /courses/earth-analytics-python/python-open-science-toolbox/get-files-from-github-fork-clone-pull-request/ 
nav-title: 'Get Files from Github'
week: 1
sidebar:
    nav:
author_profile: false
comments: true
order: 7
course: "earth-analytics-python"
topics:
   reproducible-science-and-programming: 
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






## About Pull Requests

In the <a href="{{ site.url }}/courses/earth-analytics-bootcamp/git-github-version-control/guided-activity-version-control/">Guided Activity on Version Control with Git/GitHub</a>, you added, committed, and pushed changed files to your forked repository on `https://github.com/yourusername/ea-bootcamp-hw-1-yourusername`. 

To submit changed files to the original repository owned by earthlab-education (`https://github.com/earthlab-education/ea-bootcamp-hw-1-yourusername`), you need to submit a pull request on `Github.com`. 

<figure>
   <a href="https://www.earthdatascience.org/images/workshops/version-control/git-push-pr.png">
   <img src="https://www.earthdatascience.org/images/workshops/version-control/git-push-pr.png" alt="LEFT: To sync changes made and committed locally on your computer to your Github account, you push the changes from your computer to your fork on GitHub. RIGHT: To suggest changes to another repository, you submit a Pull Request to update the central repository. Source: Colin Williams, NEON."></a>
   <figcaption> LEFT: To sync changes made and committed locally on your computer to your Github account, you push the changes from your computer to your fork on GitHub. RIGHT: To suggest changes to another repository, you submit a Pull Request to update the central repository. Source: Colin Williams, NEON.
   </figcaption>
</figure>

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
