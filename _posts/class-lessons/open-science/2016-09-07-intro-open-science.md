---
layout: single
authors: [Naupaka Zimmerman, Leah Wasser, Reproducible Science Curriculum Community]
category: [course-materials]
title: 'Introduction to Open Science Teaching Activity'
excerpt: 'A hands-on activity where students review a project for readability,
organization, etc and identify key elements that would make it more usable and
readily reproducible.'
nav-title: 'Lesson Overview'
sidebar:
  nav:
class-lesson: ['intro-open-science']
author_profile: false
comments: false
order: 1
---

## Overview

<div class='notice--success' markdown="1">

# Learning Outcomes

* Understand the four facets of reproducibility.
  1. Organization
  2. Documentation
  3. Automation
  4. Dissemination
* Be able to apply the four facets of reproducibility to improve and create more
efficient and productive scientific workflows

****

**Estimated Time:** 1-2 hours

[Download Lesson Data](https://ndownloader.figshare.com/files/6463767
){: .btn .btn--large}
</div>

## Intro to Reproducibility: Review First

Please review the material below to prepare for class.

<a href="{{ site.baseurl }}/slide-shows/1_intro-reprod-science/" class="btn btn--info" target="_blank">Introduction to Reproducible Science Slide Show </a>

<a href="{{ site.baseurl }}/slide-shows/2-file-naming-jenny-bryan/" class="btn btn--info" target="_blank">File Naming 101</a>

> Special Thanks: This presentation was adapted from the reproducible science curriculum.
Special thanks go out to: Francois Michonneau, Hilmar Lapp, Karen Cranston, Jenny Bryan,
and others who contributed to creating this presentation.

## The Scenario

You are in a lab and a colleague has moved on to a new job and left you their
research which you are tasked by your supervisor with picking up and moving forward.
Have a look at the files that were left for you to work with and answer the following
questions:

1. Are the contents of the directory easy to understand?
2. Do you feel confident that you can easily recreate the workflow associated with the data / code?
3. Do you have access to the data? What data are available and where / how were
they collected?

Next, work with your group to document ways in which you could improve upon the
reproducibility of this project.

1. Create a list of things that would make the working directory easier to work with.
1. Break that list into general “areas” / categories of reproducibility.

<div class="notice--info" markdown="1">
# Resources

### Clean Coding
* <a href="http://r-pkgs.had.co.nz/style.html" target="_blank">Hadley Wickham's Style Guide</a>
* <a href="https://blog.goyello.com/2013/05/17/express-names-in-code-bad-vs-clean/" target="_blank">BLOG: Bad vs Good Code Naming Conventions</a>
* <a href="https://www.amazon.com/Clean-Code-Handbook-Software-Craftsmanship/dp/0132350882" target="_blank">BOOK: Clean Code: A Handbook of Agile Software Craftsmanship 1st Edition</a>


### Reproducibility
* <a href="http://science.sciencemag.org/content/334/6060/1226" target="_blank">Peng (2011) - Reproducible Research in Computational Science</a>
* <a href="http://genomebiology.biomedcentral.com/articles/10.1186/s13059-015-0850-7" target="_blank">Markowetz (2015) - Five selfish reasons to work reproducibly
</a>
* <a href="http://journals.plos.org/plosone/article?id=10.1371/journal.pone.0026828" target="_blank">Wicherts (2011) - Willingness to Share Research Data Is Related to the Strength of the Evidence and the Quality of Reporting of Statistical Results
</a>
* <a href="http://link.springer.com/article/10.1007/s10816-015-9272-9
" target="_blank">Marwick (2016) - Computational Reproducibility in Archaeological Research: Basic Principles and a Case Study of Their Implementation
</a>

### Organization

* <a href="http://journals.plos.org/ploscompbiol/article?id=10.1371/journal.pcbi.1000424" target="_blank">Noble (2009) - A Quick Guide to Organizing Computational Biology Projects
</a>
</div>





<!--
{% for lesson in site.open-science %}
<h3><a href="{{ lesson.url}}">{{ lesson.title }}</a></h3>
{{ lesson.description }}

{% endfor %}
-->

<!-- Testing out listing each collection set
{% for issue in site.collections %}
  <li>
    <h6 class="post-meta">
       {{ issue[1].label }}
      {{ issue[3] }}
      {{ issue[1].date | date: "%b %-d, %Y" }}
    </h6>
    <h2>
      {{ issue[1].title }}
    </h2>
  </li>
{% endfor %}

-->
