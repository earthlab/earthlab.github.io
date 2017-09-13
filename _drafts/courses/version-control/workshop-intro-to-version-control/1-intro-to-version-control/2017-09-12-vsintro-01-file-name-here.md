---
layout: single # the template to use to build the page
authors: ['Software Carpentry', 'NEON Data Skills'] # add one or more authors as a list
category: [courses] # the category of choice - for now courses
title: 'Descriptive title here' # title should be concise and descriptive
attribution: 'Any attribute text that is required' # if we want to provide attribution for someone's work...
excerpt: 'Learn how to .' # one to two sentence description of the lesson using a "call to action - if what someone will learn for SEO"
dateCreated: 2017-09-12  # when the lesson was built
modified: '2017-09-13' # will populate during knitting
module-title: 'Template lessons - Set up Git 1' # this is the name for the set of lessons or module- only needed for first lesson in section
module-description: 'Description here.' # another call to action description of the MODULE (set of lessons )- only needed for first lesson in section
module-nav-title: 'Lesson 1' # this is the text that appears on the left hand side bar describing THE MODULE 1-3 words max - only needed for first lesson in section
module-type: 'class' # leave this for now
nav-title: 'What is version control?' # this is the text that appears on the left hand side bar describing THIS lesson 1-3 words max
class-order: 1 # define the order that each group of lessons are rendered
week: 1 # ignore this for now. A week is a unit
sidebar: # leave this alone!!
  nav:
course: "intro-version-control-git" # this is the "Course" or module name. it needs to be the same for all lessons in the workshop
class-lesson: ['what-is-version-control'] # this is the lesson set name - it is the same for all lessons in this folder and handles the subgroups
permalink: /courses/example-course-name/what-is-version-control/ # permalink needs to follow the structure coursename - lesson name using slugs
author_profile: false
comments: true
order: 1
topics:
  reproducible-science-and-programming: ['RStudio'] # adjust based on what tags are appropriate
---

<!-- Max - below i copied some neon intro materials that were based upon software carpentry... edit as you see fit?? i don't fully know if those materials NOTE - resources always go at the BOTTOM OF THE PAGE in a resources block. -->
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

In this page, you will be introduced to the importance of version control in
scientific workflows.

<div id="objectives" markdown="1">
# Learning Objectives
At the end of this activity, you will be able to:

* Explain what version control is and how it can be used.
* Explain why version control is important.
* Discuss the basics of how the Git version control system works.
* Discuss how GitHub can be used as a collaboration tool.

</div>

The text and graphics in the first three sections were borrowed, with some
modifications, from
<a href="http://swcarpentry.github.io/git-novice/01-basics.html" target="_blank"> Software Carpentry's Version Control with Git lessons</a>.

## What is Version Control?

A version control system maintains a record of changes to code and other content.
It also allows us to revert changes to a previous point in time.


<figure>
	<a href="http://www.phdcomics.com/comics/archive/phd101212s.gif">
	<img src="http://www.phdcomics.com/comics/archive/phd101212s.gif"></a>
	<figcaption> Many of us have used the "append a date" to a file name version
 of version control at some point in our lives.  Source: "Piled Higher and
Deeper" by Jorge Cham <a href="http://www.phdcomics.com" target="_blank"> www.phdcomics.com</a>
	</figcaption>
</figure>

## Types of Version control

There are many forms of version control. Some not as good:

* Save a document with a new date (we’ve all done it, but it isn’t efficient)
* Google Docs "history" function (not bad for some documents, but limited in scope).

Some better:

* Mercurial
* Subversion
* Git - which we’ll be learning much more about in this series.


<i class="fa fa-star"></i> **Thought Question:** Do you currently implement
any form of version control in your work?
{: .notice .thought}

<div class="notice" markdown="1">
## More Resources:

* <a href="https://en.wikipedia.org/wiki/List_of_version_control_software" target="_blank">
Visit the version control Wikipedia list of version control platforms.</a>
* <a href="https://git-scm.com/book/en/v2/Getting-Started-About-Version-Control" target="_blank"> Read the Git documentation explaining the progression of version control systems.</a>
</div>

## Why Version Control is Important

Version control facilitates two important aspects of many scientific workflows:

1. The ability to save and review or revert to previous versions.
2. The ability to collaborate on a single project.

This means that you don’t have to worry about a collaborator (or your future self)
overwriting something important. It also allows two people working on the same
document to efficiently combine ideas and changes.


<!-- Some of these thought questions are a bit weird... happy to remove them but the info may be useful?? -->
<div class="notice thought" markdown="1">
<i class="fa fa-star"></i> **Thought Questions:** Think of a specific time when
you weren’t using version control that it would have been useful.

* Why would version control have been helpful to your project & work flow?
* What were the consequences of not having a version control system in place?
</div>

## How Version Control Systems Works

### Simple Version Control Model

A version control system keeps track of what has changed in one or more files
over time. The way this tracking occurs, is slightly different between various
version control tools including `git`, `mercurial` and `svn`. However the
principle is the same.

Version control systems begin with a base version of a document. They then
save the committed changes that you make. You can think of version control
as a tape: if you rewind the tape and start at the base document, then you can
play back each change and end up with your latest version.
<!-- Images that we use ideally are housed locally to enforce https ... but we can't always do that. in this instance we can because this is a SWC image -->
 <figure>
	<a href="{{  site.url }}/images/pre-institute-content/pre-institute2-git/SWC_Git_play-changes.svg">
	<img src="{{  site.url }}/images/pre-institute-content/pre-institute2-git/SWC_Git_play-changes.svg"></a>
	<figcaption> A version control system saves changes to a document, sequentially
  as you add and commit them to the system.
	Source: <a href="http://swcarpentry.github.io/git-novice/01-basics.html" target="_blank"> Software Carpentry </a>
	</figcaption>
</figure>

Once you think of changes as separate from the document itself, you can then
think about “playing back” different sets of changes onto the base document.
You can then retrieve, or revert to, different versions of the document.

The benefit of version control when you are in a collaborative environment is that
two users can make independent changes to the same document.

 <figure>
	<a href="{{  site.url }}/images/pre-institute-content/pre-institute2-git/SWC_Git_versions.svg">
	<img src="{{  site.url }}/images/pre-institute-content/pre-institute2-git/SWC_Git_versions.svg"></a>
	<figcaption> Different versions of the same document can be saved within a
  version control system.
	Source: <a href="http://swcarpentry.github.io/git-novice/01-basics.html" target="_blank"> Software Carpentry </a>
	</figcaption>
</figure>

If there aren’t conflicts between the users changes (a conflict is an area
where both users modified the same part of the same document in different
ways) you can review two sets of changes on the same base document.

 <figure>
	<a href="{{  site.url }}/images/pre-institute-content/pre-institute2-git/SWC_Git_merge.svg">
	<img src="{{  site.url }}/images/pre-institute-content/pre-institute2-git/SWC_Git_merge.svg"></a>
	<figcaption>Two sets of changes to the same base document can be reviewed
	together, within a version control system <strong> if </strong> there are no conflicts (areas
	where both users <strong> modified the same part of the same document in different ways</strong>).
	Changes submitted by both users can then be merged together.
	Source: <a href="http://swcarpentry.github.io/git-novice/01-basics.html" target="_blank"> Software Carpentry </a>
	</figcaption>
</figure>

A version control system is a tool that keeps track of these changes for us.
Each version of a file can be viewed and reverted to at any time. That way if you
add something that you end up not liking or delete something that you need, you
can simply go back to a previous version.

### Git & GitHub - A Distributed Version Control Model

GitHub uses a distributed version control model. This means that there can be
many copies (or forks in GitHub world) of the repository.

<figure>
 <a href="https://git-scm.com/book/en/v2/book/01-introduction/images/distributed.png">
 <img src="https://git-scm.com/book/en/v2/book/01-introduction/images/distributed.png" width="70%"></a>
 <figcaption>One advantage of a distributed version control system is that there
 are many copies of the repository. Thus, if any server or computer dies, any of
  the client repositories can be copied and used to restore the data! Every clone
  (or fork) is a full backup of all the data.
 Source: <a href="https://git-scm.com/book/en/v2/book/01-introduction/images/distributed.png" target="_blank"> Pro Git by Scott Chacon & Ben Straub </a>
 </figcaption>
</figure>

Have a look at the graphic below. Notice that in the example, there is a "central"
version of our repository. Joe, Sue and Eve are all working together to update
the central repository. Because they are using a distributed system, each user (Joe,
Sue and Eve) has their own copy of the repository and can contribute to the central
copy of the repository at any time.

<figure>
 <a href="http://betterexplained.com/wp-content/uploads/version_control/distributed/distributed_example.png">
 <img src="http://betterexplained.com/wp-content/uploads/version_control/distributed/distributed_example.png"></a>
 <figcaption>Distributed version control models allow many users to
contribute to the same central document.
 Source: <a href="http://betterexplained.com/wp-content/uploads/version_control/distributed/distributed_example.png" target="_blank"> Better Explained </a>
 </figcaption>
</figure>


<!-- Optional - include resources at the bottom of the page. -->
<div class="notice--info" markdown="1">

## Example resources list at the bottom of the page

* <a href="http://www.rstudio.com/wp-content/uploads/2016/03/rmarkdown-cheatsheet-2.0.pdf" target="_blank"> R Markdown Cheatsheet</a>


</div>
