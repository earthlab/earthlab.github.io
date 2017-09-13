---
layout: single # the template to use to build the page
authors: ['author one', 'author one'] # add one or more authors as a list
category: [courses] # the category of choice - for now courses
title: 'Forks in GitHub' # title should be concise and descriptive
attribution: 'Any attribute text that is required' # if we want to provide attribution for someone's work...
excerpt: 'Learn how to .' # one to two sentence description of the lesson using a "call to action - if what someone will learn for SEO"
dateCreated: 2017-09-12  # when the lesson was built
modified: '2017-09-13' # will populate during knitting
module-title: 'Template lessons part 2 - Git 2' # this is the name for the set of lessons or module- only needed for first lesson in section
module-description: 'Learn how or about stuff...Here is the module description.' # another call to action description of the MODULE (set of lessons )- only needed for first lesson in section
module-nav-title: 'Forks 1' # this is the text that appears on the left hand side bar describing THE MODULE 1-3 words max - only needed for first lesson in section
module-type: 'class' # leave this for now
nav-title: 'Fork a repo' # this is the text that appears on the left hand side bar describing THIS lesson 1-3 words max
class-order: 2 # define the order that each group of lessons are rendered -- this is the second in the series currently
week: 1 # ignore this for now. A week is a unit and is what groups all of these things for the workshop together
sidebar: # leave this alone!!
  nav:
course: "intro-version-control-git" # this is the "Course" or module name. it needs to be the same for all lessons in the workshop
class-lesson: ['fork-pull-push'] # this is the lesson set name - it is the same for all lessons in this folder and handles the subgroups
permalink: /courses/intro-version-control-git/about-forks/ # permalink needs to follow the structure coursename - lesson name using slugs
author_profile: false
comments: true
order: 1
topics:
  reproducible-science-and-programming: ['RStudio'] # adjust based on what tags are appropriate
---

{% include toc title="In this lesson" icon="file-text" %}

<!--  This is the top block with the learning objectives (LO) -->
<div class='notice--success' markdown="1">

## <i class="fa fa-graduation-cap" aria-hidden="true"></i> Learning objectives
At the end of this activity, you will:

* Be able to create a fork, or copy, of a GitHub repository within your Github account.
* Know how to navigate between your GitHub repository and a forked GitHub repository.
* Be able to explain how your forked repository relates to the master repository that it was created from.

## <i class="fa fa-check-square-o fa-2" aria-hidden="true"></i> What you need

Some description of what is required to complete this lesson if anything.
For lessons using git we'll link to the setup pages.

* [setup xxx]({{ site.url }}/courses/path-here/)
* [setup xxx]({{ site.url }}/courses/path-here/)

</div>

## What is a fork?

A <a href="https://help.github.com/articles/fork-a-repo/" target="_blank">GitHub fork</a>
is a copy of a repository (repo) that sits in your account rather than the account from
which you forked the data from. Once you have forked a repo, you can edit the
contents of it without impacting the repo from which is was copied or forked from.

<figure>
 <a href="{{ site.url }}/images/courses/version-control/git-fork-emphasis.png">
 <img src="{{ site.url }}/images/courses/version-control/git-fork-emphasis.png" width="70%"></a>
 <figcaption>When you fork a repo, you make a copy in your own account that you can
 freely work on and modify. Source: Colin Williams, NEON</a>
 </figcaption>
</figure>



### Create A Working Copy of a Git Repo - Fork

There are different Git and GitHub workflows. In this workshop you will work from
a central repo owned by Earth Lab. You will:

1. Fork this repo owned by <a href="https://github.com/earthlab" target="_blank">Earth Lab</a> into your GitHub account.
2. Clone the fork of your repo, so you can edit the contents locally
3. Make edits to your local cloned copy of the repo on your computer
4. `add`, `commit` and `push` those edits back to your fork on GitHub
5. Suggest the changes that you made, to be added to the earth lab repo using a `pull request`

This workflow has a **Central Repository** - which is the one that Earth Lab owns.
Everyone in the workshop will then contribute to the central repository.

 <figure>
	<a href="{{ site.url }}/images/courses/version-control/git-fork-clone-flow.png">
	<img src="{{ site.url }}/images/courses/version-control/git-fork-clone-flow.png" width="70%"></a>
	<figcaption>
	Image source: Colin Williams, NEON
	</figcaption>
</figure>


<i class="fa fa-star"></i> **Data Tip:**
<a href="https://ru.atlassian.com/git/tutorials/comparing-workflows/gitflow-workflow" target="_blank">Learn about other version control workflows here. This includes using Bitbucket vs Github for git repo cloud hosting.</a>.
{: .notice--success }

<div class="notice--info" markdown="1">

## Important terms

* **Central repo (earth lab's GitHub account )** - the main repo that everyone contributes to in the
workshop. This is the "final working version" of the project.
* **Your fork (your GitHub account)** - your working copy of the central repo stored in your GitHub
account.
* **Your repo clone (Your account on your computer)** - the local version of the fork in your GitHub account that
lives on your computer. You will most often work locally on your computer and then
push updates to GitHub.


## Git resources

* <a href="https://git-scm.com/doc" target="_blank"> Git Pro version 2 book by Scott Chacon and Ben Straub</a>


</div>
