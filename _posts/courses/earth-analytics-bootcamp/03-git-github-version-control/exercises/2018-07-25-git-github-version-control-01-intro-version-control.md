---
layout: single
title: 'What Is Version Control'
excerpt: "This lesson reviews the process and benefits of version control and how Git and GitHub support version control."
authors: ['Software Carpentry', 'NEON Data Skills', 'Max Joseph', 'Leah Wasser', 'Jenny Palomino']
category: [courses]
class-lesson: ['git-github-version-control']
permalink: /courses/earth-analytics-bootcamp/git-github-version-control/intro-version-control/
nav-title: "What Is Version Control"
dateCreated: 2018-07-25
modified: 2018-08-08
module-title: 'Git/GitHub Workflow For Version Control'
module-nav-title: 'Git/GitHub Workflow For Version Control'
module-description: 'This tutorial helps you get started with version control to track changes to your files and share your files with others using Git and GitHub.'
module-type: 'class'
class-order: 2
course: "earth-analytics-bootcamp"
week: 3
sidebar:
  nav:
author_profile: false
comments: true
order: 1
topics:
  reproducible-science-and-programming: ['git']
---
{% include toc title="In This Lesson" icon="file-text" %}

In this lesson, you will learn about the process and benefits of version control and how `Git` and `GitHub` support version control. 

<div class='notice--success' markdown="1">

## <i class="fa fa-graduation-cap" aria-hidden="true"></i> Learning Objectives

After completing this lesson, you will be able to:

* Define version control
* Explain how version control is useful in a scientific workflow
* Describe how `Git` and `GitHub` support version control


## <i class="fa fa-check-square-o fa-2" aria-hidden="true"></i> What You Need

Be sure that you have completed the lesson on <a href="{{ site.url }}/courses/earth-analytics-bootcamp/get-started-with-open-science/get-files-from-github/">Get Files From Github.com.</a>

</div>

The text and graphics in the first three sections were borrowed, with some modifications, from Software Carpentry’s Version Control with `Git` lessons.

 
## What is Version Control?

A version control system maintains a record of changes to code and other content. It also allows us to revert changes to a previous point in time.

<figure>
   <a href="http://www.phdcomics.com/comics/archive/phd101212s.gif">
   <img src="http://www.phdcomics.com/comics/archive/phd101212s.gif" alt="Many of us have appended a date to a file name as a method of version control at some point in our lives. Source: Piled Higher and Deeper by Jorge Cham www.phdcomics.com."></a>
   <figcaption> Many of us have used the "append a date" to a file name version of version control at some point in our lives. Source: "Piled Higher and Deeper" by Jorge Cham www.phdcomics.com.
   </figcaption>
</figure>

## Types of Version control

There are many forms of version control. Some not as good:

* Save a document with a new date (we’ve all done it, but it isn’t efficient)
* Google Docs “history” function (not bad for some documents, but limited in scope).

Some better:

* Version control tools like Git, Mercurial, or Subversion

## Why Version Control is Important

Version control facilitates two important aspects of many scientific workflows:

1. The ability to save and review or revert to previous versions.
2. The ability to collaborate on a single project.

This means that you don’t have to worry about a collaborator (or your future self) overwriting something important. It also allows two people working on the same document to efficiently combine ideas and changes.

<div class="notice" markdown="1">

<i class="fa fa-star"></i>**Thought Questions**: Think of a specific time when you weren’t using version control that it would have been useful.

1. Why would version control have been helpful to your project & work flow?
2. What were the consequences of not having a version control system in place?

</div>


## How Version Control Systems Works

### Simple Version Control Model

A version control system tracks what has changed in one or more files over time. Version control systems begin with a base version of a document. They then save the committed changes that you make. You can think of version control as a tape: if you rewind the tape and start at the base document, then you can play back each change and end up with your latest version.

<figure>
   <a href="http://swcarpentry.github.io/git-novice/fig/play-changes.svg">
   <img src="http://swcarpentry.github.io/git-novice/fig/play-changes.svg" alt="A version control system saves changes to a document, sequentially as you add and commit them to the system. Source: Software Carpentry."></a>
   <figcaption> A version control system saves changes to a document, sequentially as you add and commit them to the system. Source: Software Carpentry.
   </figcaption>
</figure>

Once you think of changes as separate from the document itself, you can then think about “playing back” different sets of changes onto the base document. You can then retrieve, or revert to, different versions of the document.

Collaboration with version control allows to users to make independent changes to the same document.

<figure>
   <a href="http://swcarpentry.github.io/git-novice/fig/versions.svg">
   <img src="http://swcarpentry.github.io/git-novice/fig/versions.svg" alt="Different versions of the same document can be saved within a version control system. Source: Software Carpentry."></a>
   <figcaption> Different versions of the same document can be saved within a version control system. Source: Software Carpentry.
   </figcaption>
</figure>

If there aren’t conflicts between the users’ changes (a conflict is an area where both users modified the same part of the same document in different ways) you can review two sets of changes on the same base document.

<figure>
   <a href="http://swcarpentry.github.io/git-novice/fig/merge.svg">
   <img src="http://swcarpentry.github.io/git-novice/fig/merge.svg" alt="Two sets of changes to the same base document can be reviewed together, within a version control system if there are no conflicts (areas where both users modified the same part of the same document in different ways). Changes submitted by both users can then be merged together. Source: Software Carpentry."></a>
   <figcaption> Two sets of changes to the same base document can be reviewed together, within a version control system if there are no conflicts (areas where both users modified the same part of the same document in different ways). Changes submitted by both users can then be merged together. Source: Software Carpentry.
   </figcaption>
</figure>

A version control system is a tool that keeps track of these changes for us. Each version of a file can be viewed and reverted to at any time. That way if you add something that you end up not liking or delete something that you need, you can simply go back to a previous version.


### Git and GitHub - A Distributed Version Control Model

`Git` uses a distributed version control model. This means that there can be many copies (or forks/branches in `GitHub` world) of the repository. When working locally, git is the program that you will use to keep track of changes to your repository. `GitHub` is a location on the internet (a cloud web server) that acts as a remote location for your repository. `GitHub` provides a backup of your work, that can be retrieved if your local copy is lost (e.g., if your computer falls off a pier).

GitHub also allows you to share your work and collaborate with others on projects.

<figure>
   <a href="https://git-scm.com/book/en/v2/book/01-introduction/images/distributed.png">
   <img src="https://git-scm.com/book/en/v2/book/01-introduction/images/distributed.png" alt="One advantage of a distributed version control system is that there are many copies of the repository. Thus, if any server or computer dies, any of the client repositories can be copied and used to restore the data! Every clone (or fork) is a full backup of all the data. Source: Pro Git by Scott Chacon & Ben Straub. "></a>
   <figcaption> One advantage of a distributed version control system is that there are many copies of the repository. Thus, if any server or computer dies, any of the client repositories can be copied and used to restore the data! Every clone (or fork) is a full backup of all the data. Source: Pro Git by Scott Chacon & Ben Straub. 
    </figcaption>
</figure>    

## How Git and GitHub Support Version Control

In the lesson on Open Reproducible Science, you learned that `Git` is version control tool that you use in the `Terminal` to work with and track changes in local files. You also learned that `GitHub` is the cloud-based version of `Git`, which can be used to store your files (as well as changes to those files) in the cloud to access them from any computer and to share them with others.  

Due to the functionality that each tool provides, you can use `Git` and `GitHub` together in the same workflow to:
* keep track of changes to your code
* synchronizing code between different versions (i.e. either your own versions or others' versions)
* test changes to code without losing the original
* revert back to older version of code, if needed
* back-up your files on the cloud
* share your files on `Github.com` and collaborate with others

Throughout this course, you will learn more about the functionality of `Git` and `GitHub` and how they support transparency and reproducibility in workflows, which in turn promotes open reproducible science.  
