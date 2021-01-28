---
layout: single
title: 'GEOG 4463 & 5463 - Earth Analytics Bootcamp: Homework 1'
authors: ['Jenny Palomino']
category: courses
excerpt:
nav-title: Homework 1
modified: 2021-01-28
comments: no
permalink: /courses/earth-analytics-bootcamp/earth-analytics-bootcamp-homework-1/
author_profile: no
overview-order: 5
module-type: 'overview'
course: "earth-analytics-bootcamp"
sidebar:
  nav:
---
{% include toc title="In This Lesson" icon="file-text" %}

<div class="notice--info" markdown="1">

## <i class="fa fa-ship" aria-hidden="true"></i> Homework 1

This assignment has two components:

1. Completing the <a href="https://canvas.colorado.edu/courses/17063/quizzes/38134" target = "_blank">Homework 1 Quiz on CANVAS</a>. You need to log into CANVAS to complete this quiz. 

2. Completing and submitting the `Jupyter Notebook` for Homework 1 (`ea-bootcamp-hw-1.ipynb`). You will need follow the instructions below **Part 3: Submit Your Jupyter Notebook to GitHub** to submit this component.

You need to **complete both components of this assignment (Homework 1) by Friday, August 10th at 8:00 AM (U.S. Mountain Daylight Time)**. See <a href="https://www.timeanddate.com/worldclock/fixedtime.html?iso=20180810T08&p1=1243" target="_blank">this link</a>  to convert the due date/time to your local time. Each component contributes 50% to your final grade for Homework 1. 


## <i class="fa fa-check-square-o fa-2" aria-hidden="true"></i> What You Need

Be sure that you have completed all of the lessons from Days 1, 2, and 3 for the Earth Analytics Bootcamp. Completing the challenges at the end of the lessons will also help you with this assignment. 

You will need the `Jupyter Notebook` for Homework 1 (`ea-bootcamp-hw-1.ipynb`), which is in your forked repository for Homework 1 (`https://github.com/yourusername/ea-bootcamp-hw-1-yourusername`).

If you have not already forked and cloned the repository for Homework 1, complete the following instructions:

1. On Day 1 of the course, you will receive an email invitation to Homework 1 via CANVAS.

2. Accept the invitation, which will create a new private repository that includes your `Github.com` username in the name of the repository: `https://github.com/earthlab-education/ea-bootcamp-hw-1-yourusername`.

3. `Fork` this repository to your `GitHub account`. Your forked repository will be available on `https://github.com/yourusername/ea-bootcamp-hw-1-yourusername`.

4. Clone your forked repository `ea-bootcamp-hw-1-yourusername` to the `earth-analytics-bootcamp` directory on your computer (hint: `cd`, `git clone`). This repository will contain the the `Jupyter Notebook` for Homework 1 (`ea-bootcamp-hw-1.ipynb`).

</div>


## Part 1: Complete Homework 1 Quiz on Canvas

Complete the <a href="https://canvas.colorado.edu/courses/17063/quizzes/38134" target = "_blank">Homework 1 Quiz on CANVAS.</a> You need to log into CANVAS to see this quiz. This component contributes 50 points to your homework grade (out of a total possible points of 100).

This component will test your `Shell`, `Jupyter Notebook` and `Git` skills from Days 1 to 3. 



## Part 2: Complete a Jupyter Notebook

The second part of this homework assignment will involve you working on a set of questions in a `Jupyter Notebook`. Open `ea-bootcamp-hw-1.ipynb` in your `ea-bootcamp-hw-1-yourusername` repository, and follow the instructions in the notebook (which are also listed below). 

All new cells should be added after this `Markdown` cell with the instructions and in the order specified.  

For code cells, **be sure to add `Python` comments to document each code block** and use appropriate variable names that are short and concise but also clearly indicate the kind of data contained in the variable. Review the variable names that you have seen throughout the lessons. 

The possible points earned for each question are listed; this component contributes 50 points to your homework grade (out of a total possible points of 100). 

This component will test your `Jupyter Notebook` and `Python` skills from Days 1 to 3. 


### Question 1 - Rename Jupyter Notebook Files (2 pts)

Rename your `Jupyter Notebook` file for Homework 1 (`ea-bootcamp-hw-1.ipynb`) by adding your first initial and last name to the filename (e.g. `jpalomino-ea-bootcamp-hw-1.ipynb`).


### Question 2 - Markdown Styling (2 pts)

Add a new `Markdown` cell below and add `Markdown` for:
* A title for the notebook.
* A **bullet list** with:
    * A bold word for `Author:` and then add text for your name. 
    * A bold word for `Date:` and then add text for today's date.
    
    
### Question 3 - Open Reproducible Science (4 pts)

Add a new `Markdown` cell below, and answer the following questions using a **numbered list**.

* In 1-2 sentences, define open reproducible science. 

* In 1-2 sentences, choose one of the tools that you have learned (i.e. `Shell`, `Git`/`GitHub`, `Jupyter Notebook`, `Python`) and explain how it supports open reproducible science. 


### Question 4 - Import Necessary Python Packages (4 pts)

Add a new code cell below, and add `Python` code to:

* Import the `os` package.
* Import the `matplotlib.pyplot` module using the alias `plt`.


### Question 5 - Print Current Working Directory (2 pts)

Add a new code cell below, and add the appropriate `Python` function to print your current working directory, which should be the full path to the `ea-bootcamp-hw-1-yourusername` directory.


### Question 6 - Create Variables (4 pts)

For this question, you will use data on average monthly temperature for <a href="https://www.esrl.noaa.gov/psd/boulder/Boulder.mm.html" target="_blank">Boulder, Colorado, provided by the U.S. National Oceanic and Atmospheric Administration (NOAA).</a> 

Month  | Temperature (Fahrenheit) |
--- | --- |
Jan | 32.0 |
Feb | 35.6 |
Mar | 41.0 |
Apr | 49.2 |
May | 57.9 |
June | 67.2 |
July | 73.0 |
Aug | 71.1 |
Sept | 62.1 |
Oct | 52.9 |
Nov | 40.8 |
Dec | 33.8 |


Add a new code cell below, and add `Python` code to:

* Create new variables for monthly average temperature (Fahrenheit) for January through December. 
* Print the variable for December.    


{:.output}
    33.8



### Question 7 - Run Calculations on Variables (10 pts)

Add a new code cell below, and add `Python` code to:

* Convert the variable values from Fahrenheit to Celsius using the following equation:
    * Celsius = (Fahrenheit - 32) / 1.8
    * Note that including `Fahrenheit - 32` within parenthesis `()` tells `Python` to execute that calculation first. 
* Print the new variable for December. 


{:.output}
    0.9999999999999984



### Question 8 - Create Lists (6 pts)

Add a new code cell below, and add `Python` code to:

* Create a new list for average monthly temperature for Boulder, CO from the variables containing the Celsius values. 
* Print the temperature list.
* Create another list for the month names using **full-length** month names (e.g. January).
* Print the month name list.


{:.output}
    [0.0, 2.000000000000001, 5.0, 9.555555555555557, 14.388888888888888, 19.555555555555557, 22.77777777777778, 21.722222222222218, 16.72222222222222, 11.61111111111111, 4.8888888888888875, 0.9999999999999984]
    ['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December']



### Question 9 - Plot Data From Lists (12 pts)

Add a new code cell below, and add `Python` code to:

* Create a **red bar** plot of the average monthly temperature for Boulder, CO using the lists created in Question 8 (units in Celsius). 
* Be sure to include a title for your plot.
* Be sure to include labels for the x- and y-axes, **including the units for the temperature (Celsius)**.
* Rotate the x-axis markers, so that the spacing along the x-axis is more appealing with long month names.


{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}/images/courses/ea-bootcamp/00-course-overview/05-homework-1/05-homework-1_8_0.png" alt = "This plot displays the correct response to question 9 on plotting average monthly temperature for Boulder, CO.">
<figcaption>This plot displays the correct response to question 9 on plotting average monthly temperature for Boulder, CO.</figcaption>

</figure>




### Question 10 - Discuss Plot (4 pts)

Add a new `Markdown` cell below, and answer the following questions (4-6 sentences).

1. Which months have the lowest and the highest temperatures? How much of a difference is there between the lowest and highest temperatures?

2. Given that Boulder, CO is in the Northern Hemisphere, are these results surprising? How might the results look different if you were plotting data from a location in the Southern Hemisphere? 

3. Given the Boulder, CO is at a moderately high latitude (~40 degrees North), are these results surprising? How might the results look different if you were plotting data from a location closer to the equator? (Hint: think about the difference between the lowest and highest temperatures)

To answer these questions, it can help to review the <a href="https://www.google.com/maps/place/Boulder,+CO/@18.3736306,-81.2965677,3.85z/data=!4m5!3m4!1s0x876b8d4e278dafd3:0xc8393b7ca01b8058!8m2!3d40.0149856!4d-105.2705456" target = "_blank">location of Boulder Colorado on Google Maps</a>. 


## Part 3: Submit Your Jupyter Notebook to GitHub

To submit your `Jupyter Notebook` for Homework 1, follow the `Git`/`Github` workflow from:

1. <a href="{{ site.url }}/courses/earth-analytics-bootcamp/git-github-version-control/guided-activity-version-control/">Guided Activity on Version Control with Git/GitHub</a> to add, commit, and push your `Jupyter Notebook` for Homework 1 to your forked repository for Homework 1 (`https://github.com/yourusername/ea-bootcamp-hw-1-yourusername`).

2. <a href="{{ site.url }}/courses/earth-analytics-bootcamp/git-github-version-control/guided-activity-pull-request">Guided Activity to Submit Pull Request</a> to submit a pull request of your `Jupyter Notebook` for Homework 1 to the Earth Lab repository for Homework 1 (`https://github.com/earthlab-education/ea-bootcamp-hw-1-yourusername`). 

