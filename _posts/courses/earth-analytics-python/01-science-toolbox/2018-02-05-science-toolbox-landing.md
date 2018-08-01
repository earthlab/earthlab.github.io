---
layout: single
category: courses
title: "Get Started with Data in Python / Jupyter Notebooks"
permalink: /courses/earth-analytics-python/python-open-science-toolbox/
week-landing: 1
week: 1
sidebar:
  nav:
comments: false
author_profile: false
course: "earth-analytics-python"
module-type: 'session'
---
{% include toc title="This Week" icon="file-text" %}

<div class="notice--info" markdown="1">

## <i class="fa fa-ship" aria-hidden="true"></i> Welcome to Week One!

Welcome to the first week the Earth Analytics Python course! This week you will explore data
in class related to the 2013 Colorado Floods. In your homework, you will set up
`Python` and `Jupyter Notebook` on your laptop and learn how to create a `Jupyter Notebook`
document and convert it to an `.html` file. 

<a class="btn btn--success btn--x-large" href="{{ site.url }}/slide-shows/4-earth-analytics-spring-2017-intro/" target= "_blank"> <i class="fa fa-youtube-play" aria-hidden="true"></i> View course overview slideshow
</a>

<!--
<a class="btn btn--success btn--large" href="https://docs.google.com/document/d/1EY9vxr3bAi81xfuIcNvjMRQqbSkXc9qoau0Pn3cahLQ/edit" target= "_blank"> View climate change google doc
</a>
<a class="btn btn--success btn--large" href="https://docs.google.com/document/d/1XuPS0oHh6lRo47sQ4XB-WSWvRQBoS2HWksNc6v_JSic/edit#
" target= "_blank"> View FLOODING change google doc
</a>
-->

</div>

## <i class="fa fa-pencil"></i> Homework Week 1

For this week's homework, do the following.

### 1. Read the Following Articles On Reproducible Science

* <a href="https://genomebiology.biomedcentral.com/articles/10.1186/s13059-015-0850-7" target="_blank">Five selfish reasons to work reproducibly - Florian Markowetz</a>
* <a href="http://journals.plos.org/plosbiology/article?id=10.1371/journal.pbio.1002303" target="_blank"> Computing Workflows for Biologists: A Roadmap</a>


### 2. Watch A Short Video On the 2013 Floods

This 4 minute video will help you understand what happened during the 2013
floods in Colorado. It will also help you understand the flood data that you will use 
during the next few weeks of this class.

<iframe width="560" height="315" src="https://www.youtube.com/embed/IHIckvWhwoo" frameborder="0" allowfullscreen></iframe>

#### Before / After Google Earth Fly Through

This 40 second video shows imagery collected before and after the 2013 floods in the Lee Hill Road, Boulder area.

<iframe width="560" height="315" src="https://www.youtube.com/embed/bUcWERTM-OA?rel=0&loop=1" frameborder="0" allowfullscreen></iframe>

### 3. Review Open Science Slides

These slides provide and overview of open science. Some of this will be a review from what was covered in the Earth Analytics Bootcamp course that you took in the summer.

<a class="btn btn--success" href="{{ site.url }}/slide-shows/share-publish-archive/" target= "_blank"> <i class="fa fa-youtube-play" aria-hidden="true"></i>
View Slideshow: Share, Publish & Archive Code & Data</a>

### 4. Review Course Website Lessons

The last part of your homework assignment is to review the homework lessons (see links
on the left hand side of this page).
Following the lessons, setup `Python`, `Jupyter Notebook` and a
`working directory` that will contain the data we will use for week one and the
rest of the semester on your laptop.

Once everything is setup, complete the second set of lessons which walk you
through creating and working with `Jupyter Notebooks` and exporting them to `.html` format. Some of these lessons 
will be review from the Earth Analytics Bootcamp course. 

<i class="fa fa-star" aria-hidden="true"></i> **Important:** Review
ALL of the lessons and have your computer setup BEFORE class begins next week.
You will be behind if these things are not setup / complete before next week.
{: .notice--success}

### 5. Complete Assignment Below By Wed 5 September 2018 at NOON Mountain Time

After you have complete the tasks above, complete the assignment below.
Submit your `.html` document and `.ipynb` document to Canvas.

<!-- start homework activity -->


<div class="notice--warning" markdown="1">

## <i class="fa fa-pencil-square-o" aria-hidden="true"></i> Homework Submission: Create A Report Using Jupyter Notebooks

You will complete 3 activities this week:

#### Part One

First - Submit a Jupyter notebook and html file.

* Create a new notebook `.ipynb` file in `Jupyter Notebook`. Name the file:
`yourLastName-firstInitial-week1.ipynb` example: `wasser-l-week1.ipynb`

* In your notebook do the following:

1. Import the boulder-precip csv file using pandas: `data/colorado-flood/downloads/boulder-precip.csv`.
2. Create a plot of the data.

* Below the code chunk in your document, add TEXT using **markdown** that describes what the plot that you created
shows - summarize what you think the plot shows / tells you about
the flood
* Using the skills that you learned in the earth analytics bootcamp course, clean up the plot by adding x and y axis labels and a title.
* NOTE: It is ok if your x axis dates are not formatted properly! You will learn how to deal with that next week in this course. 

Export your notebook to `.HTML` format. Submit the `.HTML` file and the `.ipynb` file to CANVAS. 

#### Part Two
Complete the week 1 quiz on canvas

#### Part Three
Complete the diagram activity [Flood Drived / Impact Diagram]({{ site.url }}/courses/earth-analytics-python/python-open-science-toolbox/precipitation-discharge-data-for-flood-analysis/)

</div>

<!-- end homework activity -->

## Your Homework Plot Should Look Something Like This
It is ok if the dates are not formatted properly on your plot. You will learn how to handle dates next week! 


{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}//images/courses/earth-analytics-python/01-science-toolbox/2018-02-05-science-toolbox-landing_2_0.png" alt = "Homework plot of precipitation over time in Boulder, Colorado.">
<figcaption>Homework plot of precipitation over time in Boulder, Colorado.</figcaption>

</figure>



