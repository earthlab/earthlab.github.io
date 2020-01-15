---
layout: single
category: courses
title: "Earth Analytics Python Course - Week One"
permalink: /courses/earth-analytics-python/python-open-science-toolbox/
week-landing: 1
modified: 2020-01-15
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
in class related to the 2013 Colorado Floods. 


<a class="btn btn--success btn--x-large" href="https://docs.google.com/presentation/d/1WJV_taQN6u0Lt5PO5wN5601ZHRtyQFdcKB54HmSw1t0/edit?usp=sharing" target= "_blank"> <i class="fa fa-youtube-play" aria-hidden="true"></i> View course overview Google slideshow
</a>

<!--
<a class="btn btn--success btn--large" href="https://docs.google.com/document/d/1EY9vxr3bAi81xfuIcNvjMRQqbSkXc9qoau0Pn3cahLQ/edit" target= "_blank"> View climate change google doc
</a>
<a class="btn btn--success btn--large" href="https://docs.google.com/document/d/1XuPS0oHh6lRo47sQ4XB-WSWvRQBoS2HWksNc6v_JSic/edit#
" target= "_blank"> View FLOODING change google doc
</a>
-->

</div>

## <i class="fa fa-pencil"></i> Homework 1: Due Next Week

You will begin working on your first assignment that relates to data associated with the 2013 Colorado flood. 
This assignment will test skills learned in the Bootcamp course which is a pre-requisite requirement for this course! 

The details of this assignment are in your first GitHub Classroom assignment repo (link in Canvas). 


### 1. Readings

* <a href="https://www.earthdatascience.org/courses/use-data-open-source-python/data-stories/colorado-2013-floods/an-overview-of-the-colorado-2013-floods/">Colorado Flood Overview:</a> This chapter will provide some background on the flood event and some data assocaited with understanding the events drivers and impacts. 

* <a href="https://www.earthdatascience.org/courses/use-data-open-source-python/data-stories/lidar-raster-data/lidar-intro/">Raster data:</a> We will be covering raster data in Python in more details next week. However you can get a jump start if you want to review these lessons.  

#### Review Readings
* <a href="https://www.earthdatascience.org/courses/use-data-open-source-python/use-time-series-data-in-python/date-time-types-in-pandas-python/">Time Series Review:</a> You covered working with pandas and timeseries data in the bootcamp. These lessons review what you learned.


<!--
# For now commenting this out. 
To complete this week's homework, review the following materials.

### 1. Read the Following Articles On Reproducible Science and Review Slides on Open Science

These articles and slides provide an overview of reproducibility and open science. Some of this will be a review from what was covered in the Earth Analytics Bootcamp course.

* <a href="https://genomebiology.biomedcentral.com/articles/10.1186/s13059-015-0850-7" target="_blank">Five selfish reasons to work reproducibly - Florian Markowetz</a>
* <a href="http://journals.plos.org/plosbiology/article?id=10.1371/journal.pbio.1002303" target="_blank"> Computing Workflows for Biologists: A Roadmap</a>

<a class="btn btn--success" href="{{ site.url }}/slide-shows/share-publish-archive/" target= "_blank"> <i class="fa fa-youtube-play" aria-hidden="true"></i>
View Slideshow: Share, Publish & Archive Code & Data</a>
-->



### 2. Watch Short Videos On the 2013 Colorado Floods
> [name=Leah Wasser] let's move these videos into the textbook and off of this page! 

This 4 minute video will help you understand what happened during the 2013
floods in Colorado. It will also help you understand the flood data that you will use 
during the next few weeks of this class.

<iframe width="560" height="315" src="https://www.youtube.com/embed/IHIckvWhwoo" frameborder="0" allowfullscreen></iframe>

#### Before / After Google Earth Fly Through

This 40 second video shows imagery collected before and after the 2013 floods in the Lee Hill Road, Boulder area.

<iframe width="560" height="315" src="https://www.youtube.com/embed/bUcWERTM-OA?rel=0&loop=1" frameborder="0" allowfullscreen></iframe>


<i class="fa fa-star" aria-hidden="true"></i> **Important:** It is important to start on this report assignment early as it will take you some time to complete. Start today so you can focus on the raster data additions to the report next week! 
{: .notice--success}


### Requirements

You will need the Earth Analytics Python environment to complete all of the assignments for this semester's course. This environment is the same environment that you used in the Earth Analytics bootcamp. If you don't already have this setup on your computer, review the setup instructions below. 
<a href= "{{ site.url }}/workshops/setup-earth-analytics-python/">Setup Earth Analytics Python Environment on Your Laptop</a>


Alternatively, if you are enrolled in this course, you can use our Jupyter Hub which contains all of the tools needed to complete the assignments. The course Jupyter Hub will give you access to more computing resources. We can also easily troubleshoot issues if your environment is not working. 

If you wish to use our course Jupyter Hub, and do not already have access, please add your github username to the GitHub discussion in Canvas. Your instructor will then provide you with access to the hub.



<!-- start homework activity 

### 5. Complete Assignment Below By Wed, January 29, 2020 at NOON Mountain Time

After you have complete the tasks above, complete the assignment below.

Submit your `.html` document and `.ipynb` document to Canvas.



<div class="notice--warning" markdown="1">

## <i class="fa fa-pencil-square-o" aria-hidden="true"></i> Homework Submission For Next Week: Class Activities

****

*The following two activities will be completed during our class period. However if you are taking the class remotely - please be sure to complete this as well. It will count towards your participation in this class. Ideally you should work with 1 or 2 other people on this diagram. However if you are in another location and are not able to team up with someone, you can complete this on your own!*


#### <i class="fa fa-pencil-square-o" aria-hidden="true"></i> Part 1 - Activity: Drivers and Impacts Quantified - (5 Participation Points)

This activity is can be completed during the class period. If you are taking the course remotely be sure to also complete this for your homework. 

Complete the <a href = "{{ site.url }}/courses/earth-analytics-python/python-open-science-toolbox/use-data-for-science/">google earth activity</a>. Then as a group (or individually), discuss the following questions.

* What differences do you see in the landscape between 2012 and 2013?
  * For each difference: What caused that difference in the landscape?
  * For each difference: How can you quantify the difference?
  
* For each CAUSE listed above, could you somehow quantitatively record the "size" or impact of the cause?
* Was the cause - caused by something else (i.e. did something else DRIVE the cause)?

Now, go to Canvas. In the `Google Earth -- Flood Drivers and Impacts Activity` discussion create a <kbd>reply</kbd> that includes:

1. Atleast 3 differences or changes that your group noticed in the imagery.
2. What data you could use to quantify each different that you noticed.
3. What might have caused that change in the landscape?
4. How would you measure that driver that caused the change in the landscape.

Organize your response in a table like the one below. Do not use the example below in your piazza post UNLESS you can come up with another way to quantify how many (or the degree to which) trees were lost! Also note the example provided below is using manually measured data. You may know of other ways to measure tree loss.

An example table that shows what you might post:


|  Difference | Data you can use to quantify the change | What drove the change  | How could you quantify that driver |
|:---|:---|:---|:---|
| Trees are missing after the flood  | human field survey of trees  | Large boulders swept downstream by flood waters  | changes in terrain pre-post flood |
| Difference 2 | Data used  | Driver of the change  | Data to quantify driver  |
|==
| Difference 2 | Data used  | Driver of the change  | Data to quantify driver  |


**IMPORTANT:** Only one person in the group needs to post the table. Each other member should reply with the words "I am in this group" to get credit. Or the group leader can simply add the first and last names of other members who contributed to the post. 


When everyone has posted - scroll through all of the posts and select 3 tables that you <kbd>like</kbd>. Click the <kbd>like</kbd> button for those posts.

**** 


## <i class="fa fa-pencil-square-o" aria-hidden="true"></i> Colorado Flood Report: Homework Due in Two Weeks: Create A Report Using Jupyter Notebooks 

Create a report on the Colorado Flood event that occured in 2013. follow the directions in the 1-colorado-flood GitHub repo for the ea-python course to complete this assignment. You will submit your assignment using GitHub / GitHub classroom.  





**** 

</div>
--> 
<!-- end homework activity -->

## Your Homework Plot Should Look Something Like The Plots Below
It is OK if the dates are not formatted properly on your plot. You will learn how to handle dates next week! 



{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}/images/courses/earth-analytics-python/01-science-toolbox/2018-02-05-science-toolbox-landing/2018-02-05-science-toolbox-landing_4_0.png" alt = "Homework plot of precipitation over time in Boulder, Colorado.">
<figcaption>Homework plot of precipitation over time in Boulder, Colorado.</figcaption>

</figure>





{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}/images/courses/earth-analytics-python/01-science-toolbox/2018-02-05-science-toolbox-landing/2018-02-05-science-toolbox-landing_5_0.png">

</figure>




