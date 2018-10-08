---
layout: single
title: 'File Organization Tips'
excerpt: 'This lesson provides a broad overview of file organization principles.'
authors: ['Leah Wasser', 'Martha Morrissey']
modified: 2018-09-25
category: [courses]
class-lesson: ['open-science-python']
permalink: /courses/earth-analytics-python/python-open-science-toolbox/best-practices-file-organization/
nav-title: 'File Organization Tips'
week: 1
sidebar:
    nav:
author_profile: false
comments: true
order: 2
course: "earth-analytics-python"
topics:
    reproducible-science-and-programming: ['python']
---
{% include toc title="In This Lesson" icon="file-text" %}

In this lesson you will learn about file organization to make your own future life easier (so you can find things) and also to make it easier to collaborate with other people.

<div class='notice--success' markdown="1">

## <i class="fa fa-graduation-cap" aria-hidden="true"></i> Learning Objectives

At the end of this activity, you will be able to:

* Be able to describe the key characteristics of a well structured project. 
* Be able to summarize in 1-3 sentences why good project structure can make your work more efficient and make it easier to collaborate with colleagues. 
* Be able to explain what a working directory is.

## <i class="fa fa-check-square-o fa-2" aria-hidden="true"></i> What You Need

You need to have Python and the `earth-analytics-python` anaconda environment installed on your computer. You should also have an `earth-analytics` directory setup on your computer with a `/data` directory in it.
 
</div>
 
## Characteristics of a Well Structured Project / Working Directory

Please note that in this lesson, you will use a project directory as a working directory.

### Organization - Files & Directories

When it comes to structuring the names of the files and folders that create your project, the more self explanatory, the better. A well structured project directory should:

* Utilize a naming convention that is:

    * **Human readable:** use directory names that are easy to understand.
    * **Machine readable:** avoid funky characters OR SPACES.
    * **Support sorting:** If you have a list of input files, it's nice to be able to sort them to quickly see what's there and find What You Need.
    * **Preserve raw data so it's not modified:** We'll worry about this later.

* Have easy to read directory names that contains components of the project (e.g. code, data, outputs, figures, etc)


### Which Filenames Are Most Self-explanatory?

Your goal when structuring a project directory is to use a naming convention that someone who is not familiar with your project can quickly understand. Case in point, have a look at the graphic below. Which list of file names are the most self explanatory? The ones on the LEFT? Or the ones of the RIGHT? Consider the structure of your project as we build the project or working directory for our earth analytics tutorials in the next lesson.


<figure>
 <a href="{{ site.url }}/images/courses/earth-analytics/python-interface/file-naming.png">
 <img src="{{ site.url }}/images/courses/earth-analytics/python-interface/file-naming.png" alt= "File and directory names that clearly indicate the type of information stored within that file or directory are the most useful or expressive to your colleagues or your future self as they allow you to quickly understand the structure and contents of a project directory. Source: Jenny Bryan, Reproducible Science Curriculum." ></a>
 <figcaption> Compare the list of file names on the LEFT to those on the right - which ones are easier to quickly understand? File and directory names that clearly indicate the type of information stored within that file or directory are the most useful or expressive to your colleagues or your future self as they allow you to quickly understand the structure and contents of a project directory. Source: Jenny Bryan, Reproducible Science Curriculum.
 </figcaption>
</figure>
