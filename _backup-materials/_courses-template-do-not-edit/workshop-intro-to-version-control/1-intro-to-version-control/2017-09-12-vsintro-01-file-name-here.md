---
layout: single # the template to use to build the page
authors: ['author one', 'author one'] # add one or more authors as a list
category: [courses] # the category of choice - for now courses
title: 'Descriptive title here' # title should be concise and descriptive
attribution: 'Any attribute text that is required' # if we want to provide attribution for someone's work...
excerpt: 'Learn how to .' # one to two sentence description of the lesson using a "call to action - if what someone will learn for SEO"
dateCreated: 2017-09-12  # when the lesson was built
modified: '2017-09-13' # will populate during knitting
module-title: 'Template lessons - Set up Git 1' # this is the name for the set of lessons or module- only needed for first lesson in section
module-description: '.' # another call to action description of the MODULE (set of lessons )- only needed for first lesson in section
module-nav-title: 'Sub Module 1' # this is the text that appears on the left hand side bar describing THE MODULE 1-3 words max - only needed for first lesson in section
module-type: 'class' # leave this for now
nav-title: 'Lesson 1 ' # this is the text that appears on the left hand side bar describing THIS lesson 1-3 words max
class-order: 1 # define the order that each group of lessons are rendered
week: 1 # ignore this for now. A week is a unit
sidebar: # leave this alone!!
  nav:
course: "example-course-name" # this is the "Course" or module name. it needs to be the same for all lessons in the workshop
class-lesson: ['example-lesson-set-name'] # this is the lesson set name - it is the same for all lessons in this folder and handles the subgroups
permalink: /courses/example-course-name/sample-lesson/ # permalink needs to follow the structure coursename - lesson name using slugs
author_profile: false
comments: true
order: 1
topics:
  reproducible-science-and-programming: ['RStudio'] # adjust based on what tags are appropriate
---

<!-- Rules for lessons
1. keep sentences short where you can
2. define jargon where you can
3. keep resources at the bottom of the pages
4. move images to our site especially when the site isn't https enforced
5. -->

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


<!-- Optional - include resources at the bottom of the page. -->
<div class="notice--info" markdown="1">

## Example resources list at the bottom of the page

* <a href="http://www.rstudio.com/wp-content/uploads/2016/03/rmarkdown-cheatsheet-2.0.pdf" target="_blank"> R Markdown Cheatsheet</a>


</div>
