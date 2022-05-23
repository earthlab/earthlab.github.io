---
layout: single
title: 'What Is Version Control'
excerpt: "A version control system allows you to track and manage changes to your files. Learn benefits of version control for scientific workflows and how git and GitHub.com support version control."
authors: ['Max Joseph', 'Leah Wasser', 'Jenny Palomino', 'Martha Morrissey']
category: [courses]
class-lesson: ['version-control-git-github']
permalink: /courses/intro-to-earth-data-science/git-github/version-control/
nav-title: "About Version Control"
dateCreated: 2019-09-06
modified: 2021-03-30
module-title: 'Git/GitHub For Version Control'
module-nav-title: 'Git/GitHub For Version Control'
module-description: 'A version control system allows you to track and manage changes to your files. Learn how to get started with version control using git and GitHub.com.'
module-type: 'class'
chapter: 7
class-order: 1
course: "intro-to-earth-data-science-textbook"
week: 3
estimated-time: "2-3 hours"
difficulty: "beginner"
sidebar:
  nav:
author_profile: false
comments: true
order: 1
topics:
  reproducible-science-and-programming: ['git']
redirect_from:
  - "/courses/earth-analytics-bootcamp/git-github-version-control/intro-version-control/"
---

{% include toc title="In This Chapter" icon="file-text" %}

<div class='notice--success' markdown="1">

## <i class="fa fa-ship" aria-hidden="true"></i> Chapter Seven - Git/GitHub.com

In this chapter, you will learn about the benefits of version control for tracking and managing changes to your files. You will also learn how to implement version control using **git** and then upload changes to the cloud version of your files on **Github.com**. 

After completing this chapter, you will be able to:

* Define **version control**.
* Explain why **version control** is useful in a scientific workflow.
* Implement version control using **git**.


## <i class="fa fa-check-square-o fa-2" aria-hidden="true"></i> What You Need

Be sure that you have completed the instructions on <a href="{{ site.url }}/workshops/setup-earth-analytics-python/setup-git-bash-conda/">Setting up Git, Bash, and Conda on your computer</a> to install the tools for your operating system (Windows, Mac, Linux). 

You will also need a web browser and your **GitHub.com** login (username and password).

</div>

The text and graphics in the first three sections were borrowed, with some modifications, from Software Carpentry’s Version Control with **git** lessons.

 
## What is Version Control?

A version control system maintains a record of changes to code and other content. It also allows us to revert changes to a previous point in time.

<figure>
   <a href="{{ site.url }}/images/earth-analytics/git-version-control/final-doc-phd-comics.gif">
   <img src="{{ site.url }}/images/earth-analytics/git-version-control/final-doc-phd-comics.gif" alt="Many of us have appended a date to a file name as a method of version control at some point in our lives. Source: Piled Higher and Deeper by Jorge Cham www.phdcomics.com."></a>
   <figcaption> Many of us have used the "append a date" to a file name version of version control at some point in our lives. Source: "Piled Higher and Deeper" by <a href="http://phdcomics.com/comics/archive/phd101212s.gif">Jorge Cham on www.phdcomics.com</a>.
   </figcaption>
</figure>

## Types of Version control

There are many forms of version control. Some not as good:

* Save a document with a new date or name (we’ve all done it, but it isn’t efficient and easy to lose track of the latest file).
* Google Docs “history” function (not bad for some documents, but limited in scope).

Some better:

* Version control tools like Git, Mercurial, or Subversion.

## Why Version Control is Important

Version control facilitates two important aspects of many scientific workflows:

1. The ability to save and review or revert to previous versions.
2. The ability to collaborate on a single project.

This means that you don’t have to worry about a collaborator (or your future self) overwriting something important. It also allows two people working on the same document to efficiently combine ideas and changes.


<div class="notice--success" markdown="1">

<i class="fa fa-star"></i>**Thought Questions**: Think of a specific time when you weren’t using version control that it would have been useful.

1. Why would version control have been helpful to your project and workflow?
2. What were the consequences of not having a version control system in place?

</div>


## How Version Control Systems Works

### Simple Version Control Model

A version control system tracks what has changed in one or more files over 
time. Version control systems begin with a base version of a document. Then, 
they save the committed changes that you make. 

You can think of version control as a tape: if you rewind the tape and 
start at the base document, then you can play back each change and end 
up with your latest version.

<figure>
   <a href="{{ site.url }}/images/earth-analytics/git-version-control/git-play-changes.png">
   <img src="{{ site.url }}/images/earth-analytics/git-version-control/git-play-changes.png" alt="A version control system saves changes to a document, sequentially as you add and commit them to the system. Source: Software Carpentry."></a>
   <figcaption> A version control system saves changes to a document, sequentially as you add and commit them to the system. <a href="http://swcarpentry.github.io/git-novice/fig/play-changes.svg">Source: Software Carpentry</a>.
   </figcaption>
</figure>

Once you think of changes as separate from the document itself, you can then think about “playing back” different sets of changes onto the base document. You can then retrieve, or revert to, different versions of the document.

Collaboration with version control allows users to make independent changes to the same document.

<figure>
   <a href="{{ site.url }}/images/earth-analytics/git-version-control/git-versions.png">
   <img src="{{ site.url }}/images/earth-analytics/git-version-control/git-versions.png" alt="Different versions of the same document can be saved within a version control system. Source: Software Carpentry."></a>
   <figcaption> Different versions of the same document can be saved within a version control system. <a href="http://swcarpentry.github.io/git-novice/fig/versions.svg">Source: Software Carpentry</a>.
   </figcaption>
</figure>

If there aren’t conflicts between the users’ changes (a conflict is an area where both users modified the same part of the same document in different ways), you can review two sets of changes on the same base document. If there are conflicts, they can be resolved by choosing which change you want to keep.

<figure>
   <a href="{{ site.url }}/images/earth-analytics/git-version-control/git-merge.png">
   <img src="{{ site.url }}/images/earth-analytics/git-version-control/git-merge.png" alt="Two sets of changes to the same base document can be merged together within a version control system if there are no conflicts (areas where both users modified the same part of the same document in different ways). If there are conflicts, they can resolved by choosing which change you want to keep. After conflicts are resolved, all other changes submitted by both users can then be merged together. Source: Software Carpentry."></a>
   <figcaption> Two sets of changes to the same base document can be merged together within a version control system if there are no conflicts (areas where both users modified the same part of the same document in different ways). If there are conflicts, they can resolved by choosing which change you want to keep. After conflicts are resolved, all other changes submitted by both users can then be merged together. <a href="http://swcarpentry.github.io/git-novice/fig/merge.svg">Source: Software Carpentry</a>.
   </figcaption>
</figure>

A version control system is a tool that keeps track of all of these changes for us. 
Each version of a file can be viewed and reverted to at any time. That way if you 
add something that you end up not liking or delete something that you need, you can 
simply go back to a previous version. 


### Git and GitHub - A Distributed Version Control Model

**Git** uses a distributed version control model. This means that there can be 
many copies (or forks/branches in **GitHub** world) of the repository. When 
working locally, **git** is the program that you will use to keep track of 
changes to your repository. 

**GitHub.com** is a location on the internet (a cloud web server) that acts as a remote location for your repository. **GitHub** provides a backup of your work that can be retrieved if your local copy is lost (e.g. if your computer falls off a pier). **GitHub** also allows you to share your work and collaborate with others on projects.

<figure>
   <a href="{{ site.url }}/images/earth-analytics/git-version-control/git-distributed-version-control-model.png">
   <img src="{{ site.url }}/images/earth-analytics/git-version-control/git-distributed-version-control-model.png" alt="One advantage of a distributed version control system is that there are many copies of the repository. Thus, if any one server or computer dies, any of the client repositories can be copied and used to restore the data! Source: Pro Git by Scott Chacon & Ben Straub. "></a>
   <figcaption> One advantage of a distributed version control system is that there are many copies of the repository. Thus, if any one server or computer dies, any of the client repositories can be copied and used to restore the data! <a href="https://git-scm.com/book/en/v2/book/01-introduction/images/distributed.png">Source: Pro Git by Scott Chacon and Ben Straub</a>.
    </figcaption>
</figure>    

## How Git and GitHub Support Version Control

Due to the functionality that each tool provides, you can use **git** and **GitHub** together in the same workflow to:
* keep track of changes to your code locally using **git**.
* synchronizing code between different versions (i.e. either your own versions or others' versions).
* test changes to code without losing the original.
* revert back to older version of code, if needed.
* back-up your files on the cloud (**GitHub.com**).
* share your files on **GitHub.com** and collaborate with others.

Throughout this textbook, you will learn more about the functionality of **git** and **GitHub** for version control and collaboration to support open reproducible science.  

