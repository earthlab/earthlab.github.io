---
layout: single # the template to use to build the page
authors: ['author one', 'author one'] # add one or more authors as a list
category: [courses] # the category of choice - for now courses
title: 'Descriptive title here' # title should be concise and descriptive
attribution: 'Any attribute text that is required' # if we want to provide attribution for someone's work...
excerpt: 'Learn how to .' # one to two sentence description of the lesson using a "call to action - if what someone will learn for SEO"
dateCreated: 2017-09-12  # when the lesson was built
modified: '2017-09-13' # will populate during knitting
nav-title: 'Lesson 2' # this is the text that appears on the left hand side bar describing THIS lesson 1-3 words max
class-order: 2 # define the order that each group of lessons are rendered -- this is the second in the series currently
week: 1 # ignore this for now. A week is a unit and is what groups all of these things for the workshop together
sidebar: # leave this alone!!
  nav:
course: "example-course-name" # this is the "Course" or module name. it needs to be the same for all lessons in the workshop
class-lesson: ['example-lesson-set-name2'] # this is the lesson set name - it is the same for all lessons in this folder and handles the subgroups
permalink: /courses/example-course-name/forks2/ # permalink needs to follow the structure coursename - lesson name using slugs
author_profile: false
comments: true
order: 2
topics:
  reproducible-science-and-programming: ['RStudio'] # adjust based on what tags are appropriate
---

{% include toc title="In this lesson" icon="file-text" %}

<!--  This is the top block with the learning objectives (LO) -->
<div class='notice--success' markdown="1">

## <i class="fa fa-graduation-cap" aria-hidden="true"></i> Learning objectives
At the end of this activity, you will be able to:

* Learning objective 1
* Learning objective 2
* Learning objective 3


## <i class="fa fa-check-square-o fa-2" aria-hidden="true"></i> What you need

Some description of what is required to complete this lesson if anything.
For lessons using git we'll link to the setup pages.

* [setup xxx]({{ site.url }}/courses/path-here/)
* [setup xxx]({{ site.url }}/courses/path-here/)

</div>


Start lesson....
