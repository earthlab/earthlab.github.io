---
layout: single
category: courses
title: "Earth Data Science Corps - Week One"
permalink: /courses/earth-data-science-corps/week-1-intro-to-python/
week-landing: 1
modified: 2020-06-30
week: 1
sidebar:
  nav:
comments: false
author_profile: false
course: "earth-data-science-corps"
module-type: 'session'
---
{% include toc title="This Week" icon="file-text" %}

<div class="notice--info" markdown="1">

## <i class="fa fa-ship" aria-hidden="true"></i> Welcome to Week One!

Welcome to the first week the Earth Data Science Corps! This week you will be introduced to the Python programming language. 

</div>

## <i class="fa fa-pencil"></i> Homework 1: Due Next Week

For this assignment, you will work through self-paced exercises that introduce core concepts in Python programming including:
* defining variables to store information (data values)
* creating lists (or collections) of data values
* manipulating variables and lists to update and reorganize data 

### Readings

* <a href="https://www.earthdatascience.org/courses/intro-to-earth-data-science/python-code-fundamentals/get-started-using-python/">Introduction to Python:</a> Chapter 10 in the Introduction to Earth Data Science online textbook.  

* <a href="https://www.earthdatascience.org/courses/intro-to-earth-data-science/open-reproducible-science/jupyter-python/">Introduction to Jupyter:</a> Chapter 3 in the Introduction to Earth Data Science online textbook. 

###  Assignment Part 1 to Complete by Thurs, June 5 (9am MT):

To complete these exercises, we can encourage you to use the JupyterHub environment which is accessible via a web browser with an active internet connection. You can then work on setting up your local computer once you have completed the lessons.

To access these exercises on the JupyterHub:
1. Create a free GitHub account and add your name and GitHub username to this <a href="https://docs.google.com/spreadsheets/d/1xSJoSO7AYKkE6h5yum_Km_XlBgcsmCmIxxsDjy8Ux9A/edit#gid=0">Google Spreadsheet</a> to be granted access (if you have not already).  
2. Watch the <a href="https://earthlab.earthdatascience.org/t/how-to-log-into-jupyterhub-cloud-computing-environment/51">Intro to JupyterHub video</a> to learn how to login and access the Jupyter Notebooks.  
    * URL for the JupyterHub: https://hub.earthdatascience.org/edsc-hub/hub/login
    * Notebooks for this assignment (and all future assignments) are accessible in the directory (folder) called course-lessons. 
    * Additional resources: 
       * <a href="https://www.earthdatascience.org/courses/intro-to-earth-data-science/open-reproducible-science/jupyter-python/">Introduction to Jupyter Notebooks</a> 

###  Assignment Part 2 to Complete by Thurs, June 11 (9am MT):

* If you haven’t already, post your bio to the <a href="https://earthlab.earthdatascience.org/t/meet-the-earth-data-science-corps-post-your-bio-and-meet-your-peers/20 ">Meet the Earth Data Science Corps</a> topic on Discourse.
    * After you have posted your bio, respond to three posts by <a href="https://meta.discourse.org/t/what-are-likes/30803">liking the post and replying with a comment</a> (e.g. you share similar project interests or hobbies). 
* <a href="https://www.earthdatascience.org/workshops/setup-earth-analytics-python/">Set-up the Earth Analytics Python environment on your local computer</a> 
     * Note that you can use JupyterHub (which is already set up with the tools you need) for all of your summer activities (e.g. assignments, project).
     * However, we encourage you to set up your local environment if you are able (instructions below), as this ensures that you will always have access to these tools!

### Submission
Please post a response to this <a href="https://earthlab.earthdatascience.org/t/about-the-edsc-week-01-category/75">Discourse discussion for Week 1.</a> 

### Optional: If You Want to Set Things Up Locally on your Computer
Once you have completed these exercises, you have the option to complete the <a href="https://earthlab.earthdatascience.org/t/about-the-edsc-week-01-category/75">Set-up the Earth Analytics Python environment exercise</a> (lessons 1-4) to set up the necessary tools on your local computer (Bash, git, Miniconda with Python).

After you have set-up your local environment, you can access the same Jupyter Notebooks by downloading them to your computer with the following steps:

* Fork and clone the GitHub Repository for the Earth Data Science Corps Summer program to your computer - https://github.com/earthlab/edsc-summer-2020/
    * Additional Resources:
        * <a href="https://www.earthdatascience.org/courses/intro-to-earth-data-science/open-reproducible-science/bash/">Introduction to Bash in the Terminal</a> 
        * <a href="https://www.earthdatascience.org/courses/intro-to-earth-data-science/open-reproducible-science/bash/">Copy (Fork) and Download (Clone) GitHub Repositories</a>
* Open a terminal (Git Bash on Windows or Terminal on Mac/Linux):
    * Change directories to the clone of the GitHub repository using the command *cd earth-analytics/edsc-summer-2020*
    * Activate the Earth Analytics Python environment using the command *conda activate earth-analytics-python*
    * Launch Jupyter Notebook using the command *jupyter notebook*
* Once Jupyter Notebook has launched, you can navigate to the directory (folder) called course-lessons to access the Jupyter Notebooks for this assignment. 
    * Additional resources: 
        * <a href="https://www.earthdatascience.org/courses/intro-to-earth-data-science/open-reproducible-science/jupyter-python/">Introduction to Jupyter Notebooks</a> 


## <i class="fa fa-book"></i> Workshop Agenda

### Welcome to the Earth Data Science Corps
* 12:30-1:20pm MT / 1:30-2:20pm CT: Welcome to the NSF Earth Data Science Corps (EDSC)
    * Intro to Earth Lab Education Team & School PI's
    * Intro: Slack - useful for group chat
    * Review syllabus, expectations, and timeline document      
    * Overview of tools: 
        * <a href="https://earthlab.earthdatascience.org/">Discourse </a> - useful for posting questions for everyone to see and answer
        * <a href="https://hub.earthdatascience.org/edsc-hub/hub/login">JupyterHub </a> - cloud computing environment for Python (you can use this for summer activities, in addition to installing the tools on your local computer)
    * Mentimeter survey

### Breakout Sessions (2 sessions) - Students Only
* 1:20-1:35pm MT / 2:20-2:35pm CT: Breakout Groups - Meet Your Peers
    * Split into Zoom breakout rooms with groups of three
    * Introduce yourselves (~5 mins for each student): answer the following questions:
        * Which year are you in your college/university? (e.g. junior)
        * What is your major? 
        * What led you to the EDSC program? (e.g. skills you hope to develop)
        * What kinds of projects are you interested in working on through EDSC? (e.g. water, air quality)
        * What do you like to do for fun?
* 1:35-1:50pm MT / 2:30-2:45pm CT: Breakout Groups - Meet More Peers
    * Same as above

### Breakout Session (1 session) - Instructors Only 
* 1:20-1:50pm MT / 2:15-2:45pm CT: Faculty break-out session led by Nate Q
    * Challenges and Opportunities for Teaching Data Skills

### Wrap Up
* 1:50-2pm MT / 2:50-3pm CT: Reconvene in main Zoom session
     * Questions



