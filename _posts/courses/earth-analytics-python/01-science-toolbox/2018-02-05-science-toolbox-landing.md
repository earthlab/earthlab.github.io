---
layout: single
category: courses
title: "Get Started with Data in Python / Jupyter Notebooks"
permalink: /courses/earth-analytics-python/python-open-science-toolbox/
week-landing: 1
modified: 2018-09-25
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

<a class="btn btn--success btn--x-large" href="{{ site.url }}/slide-shows/4-earth-analytics-course-intro/" target= "_blank"> <i class="fa fa-youtube-play" aria-hidden="true"></i> View course overview slideshow
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

### 5. Setup Python Anaconda on Your Laptop or Access the Jupyter Hub

You have two options to complete activities assigned in this course. 

1. You can choose to either work on the assignments locally on your computer. 

<a href= "https://www.earthdatascience.org/workshops/setup-earth-analytics-python/">Setup Earth Analytics Python Environment on Your Laptop</a>

or

2. You can use our Jupyter Hub which contains all of the tools needed to complete the assignments.
The course Jupyter Hub will give you access to more computing resources. We can also easily troubleshoot issues if your environment is not working. If you wish to use our course Jupyter Hub please add your github username to the github discussion in Canvas. Your instructor will then provide you with access to the hub.


### 6. Complete Assignment Below By Wed 5 September 2018 at NOON Mountain Time

After you have complete the tasks above, complete the assignment below.
Submit your `.html` document and `.ipynb` document to Canvas.

<!-- start homework activity -->


<div class="notice--warning" markdown="1">

## <i class="fa fa-pencil-square-o" aria-hidden="true"></i> Homework Submission: Create A Report Using Jupyter Notebooks + Class Activities

You will complete 3 activities this week. Note that several of these activities will be completed during the class period if you attend class in person or online! You will only be working on the jupyter notebook outside of regular class period. 

#### Part 1 - Jupyter Notebook & HTML

To begin, download the data that you will use for next week's class. In this download you will find the file: `downloads/boulder-precip.csv`. 

{% include/data_subsets/course_earth_analytics/_data-colorado-flood.md %}

Submit a Jupyter notebook and `html` file following the instructions below to Canvas:

Create a new notebook `.ipynb` file in `Jupyter Notebook`. Name the file:
`yourLastName-firstInitial-week1.ipynb` example: `wasser-l-week1.ipynb`. 
In your notebook do the following:

1. Import the `boulder-precip.csv` csv file using pandas: `data/colorado-flood/downloads/boulder-precip.csv`.
2. Plot the data.
3. Below the code chunk in your document, add TEXT using **markdown** that describes what the plot that you created
shows - summarize what you think the plot shows / tells you about
the flood
4. Using the skills that you learned in the earth analytics bootcamp course, clean up the plot by adding x and y axis labels and a title.

* NOTE: It is ok if your x axis dates are not formatted properly! You will learn how to deal with that next week in this course. 

Export your notebook to `.HTML` format. Submit the `.HTML` file and the `.ipynb` file to CANVAS in the `week_1` dropbox. 

****

*The following two activities will be completed during our class period. However if you are taking the class remotely - please be sure to complete this as well. It will count towards your participation in this class. Ideally you should work with 1 or 2 other people on this diagram. However if you are in another location and are not able to team up with someone, you can complete this on your own!*

#### <i class="fa fa-pencil-square-o" aria-hidden="true"></i> Part 2 - Driver / Impact Diagrams & Driver / Impact Data  - (5 Participation Points)

Work with 1-2 other people in this class to create a diagram of the 2013 floods that shows the things that contributed to the flood event as they are related to each other (the drivers and impacts). Use the readings for this week, what we discussed in class and what you know about floods to complete this diagram. When you are happy with your diagram,
create a digital version of it (take a picture using a phone, scan it, make your diagram in a digital format). When you are finished, go to Piazza. Create a post in the <kbd>Flood Diagram Discussion</kbd> on Canvas. In that post embed your flood diagram image. 

Note - to embed an image in canvas, you have to:

1. Add it to your files in canvas. To do this click on the <kbd>Files</kbd> link on the left hand side of canvas. Then upload the diagram.
2. Once the diagram is uploaded to your files, you can embed it in your discussion post.

**IMPORTANT:** Only one person needs to post the diagram. If you worked in a group, please RESPOND to this post saying "I am also in this group" so I can give you credit for your participation. 

When everyone has posted - scroll through ALL of the diagrams and select 3 diagrams that you <kbd>like</kbd> and be sure to <kbd>like</kbd> the post.

**** 

#### <i class="fa fa-pencil-square-o" aria-hidden="true"></i> Part 3 - Activity: Drivers and Impacts Quantified - (5 Participation Points)

This activity is also completed during the class period. If you are taking the course remotely be sure to also complete this for your homework. Please work in the same group that you worked in for the flood diagram above.

Complete the <a href = "{{ site.url }}/courses/earth-analytics-python/python-open-science-toolbox/use-data-for-science/">google earth activity</a>. Then as a group (or individually), discuss the following questions.

* What differences do you see in the landscape between 2012 and 2013?
  * For each difference: What do you think caused that difference?
  * For each difference: How can you quantitatively record the difference?
* For each CAUSE listed above, could you somehow quantitatively record the "size" or impact of the cause?
* Was the cause - caused by something else (i.e. did something else DRIVE the cause)?

Now, go to Canvas. In the `Google Earth -- Flood Drivers and Impacts Activity` discussion create a <kbd>reply</kbd> that includes:

1. Atleast 3 differences or changes that your group noticed in the imagery.
2. What data you could use to quantify each different that you noticed.
3. What might have caused that change in the landscape?
4. How would you measure that driver that caused the change in the landscape.

Consider organizing your response in a table like the one below. Do not use the example below in your piazza post UNLESS you can come up with another way to quantify how many (or the degree to which) trees were lost! Also note the example provided below is using manually measured data. You may know of other ways to measure tree loss.

An example table that shows what you might post:

|  Difference | Data you can use to quantify the change | What drove the change  | How could you quantify that driver |
|---|---|---|
| Trees are missing after the flood  | human field survey of trees  | Large boulders swept downstream by flood waters  | changes in terrain pre-post flood |
|==
|   |   |   | |

**IMPORTANT:** Only one person in the group needs to post the table. Each other member should reply with the words "I am in this group" to get credit.  

</div>

<!-- end homework activity -->

## Your Homework Plot Should Look Something Like This
It is OK if the dates are not formatted properly on your plot. You will learn how to handle dates next week! 


{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}//images/courses/earth-analytics-python/01-science-toolbox/2018-02-05-science-toolbox-landing_2_0.png" alt = "Homework plot of precipitation over time in Boulder, Colorado.">
<figcaption>Homework plot of precipitation over time in Boulder, Colorado.</figcaption>

</figure>



