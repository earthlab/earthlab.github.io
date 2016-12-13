---
layout: single
authors: ['Software Carpentry']
category: [course-materials]
title: 'File Organization 101'
excerpt: '#.'
nav-title: 'File Organization 101'
sidebar:
  nav:
class-lesson: ['setup']
author_profile: false
comments: false
order: 2
---


## Setup your project

Project organization is integral to efficient research. A well organized project
structure will allow you to more easily find components of your project AND
make it easier for others you are working with to understand and find data, code,
and results.

<div class='notice--success' markdown="1">

# Learning Objectives
At the end of this activity, you will:

* Be able to describe the key components of a well structured project.
* Be able to summarize in 1-3 sentences why good project structure can make your work more efficient and make it easier to collaborate with colleagues.


## What You Need

You will need the most current version of R and, preferably, RStudio loaded on
your computer to complete this tutorial.

* [How to Setup R / R Studio](/course-materials/setup-r-rstudio)

</div>

## Characteristics of a Well Structured Project


## 1. Organization - Files & Directories

When it comes to structuring the names of the files and folders that create your
project, the more self explanatory, the better.

<figure class="half">
	<a href="{{ site.url }}/images/slide-shows/intro-rr/basmati-rice.png">
	<img src="{{ site.url }}/images/slide-shows/intro-rr/basmati-rice.png"></a>
	<figcaption> A well structured project uses directory (folder) names that describe
  the contents of the directory. Source: Jenny Bryan, Reproducible Science Curriculum.
	</figcaption>
</figure>


A well structured project directory should:

* Reflect the structure of your project: For this set of lessons, we just need a main directory (`earth-analytics`), and a `data` directory. Other projects may be more complex with inputs (data) outputs (data outputs), code and more.
* Utilize a naming convention that is:
   * **Human readable** - use directory names that are easy to understand.
   * **Machine readable** - avoid funky characters OR SPACES.
   * **Support sorting**  - If you have a list of input files, it's nice to be able to sort them to quickly see what's there and find what you need.
* **Preserve raw data so it's not modified:** We'll worry about this later.

<figure>
	<a href="{{ site.baseurl }}/images/slide-shows/intro-rr/file-organization.png">
	<img src="{{ site.baseurl }}/images/slide-shows/intro-rr/file-organization.png"></a>
	<figcaption> # Source: Jenny Bryan, Reproducible Science Curriculum.
	</figcaption>
</figure>

### Which Filenames Are Most Self-explanatory?

Your goal when structuring a project directory is to try your best to use a naming
convention that someone who is not familiar with your project can quickly understand.
Case in point, have a look at the graphic below. Which list of file names is
the most self explanatory.

<figure>
	<a href="{{ site.url }}/images/slide-shows/intro-rr/human-readable-jenny.png">
	<img src="{{ site.url }}/images/slide-shows/intro-rr/human-readable-jenny.png"></a>
	<figcaption> Compare the list of file names on the LEFT to those on the right
  which ones are easier to quickly understand? Source: Jenny Bryan, Reproducible Science Curriculum.
	</figcaption>
</figure>


Consider this as we build the project directory for our earth analytics tutorials
in the next lesson.
