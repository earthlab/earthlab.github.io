---
layout: single
authors: ['Software Carpentry', 'NEON Data Skills', 'Max Joseph', 'Leah Wasser']
category: courses
title: 'An introduction version control'
attribution: ''
excerpt: 'Learn what version control is, and how git and GitHub factor in to a typical version control workflow.'
dateCreated: 2017-09-12
modified: '2017-09-19'
module-title: 'Introduction to version control'
module-description: 'This module includes instructions for setting up your git environment, introduces key version control concepts, and describes first steps to start using version control with git and GitHub.'
module-nav-title: 'Version control'
module-type: 'class'
nav-title: 'What is version control?'
sidebar:
  nav:
module: "intro-version-control-git"
permalink: /courses/intro-version-control-git/intro-to-version-control/
author_profile: false
comments: true
order: 2
topics:
  reproducible-science-and-programming: ['git', 'version-control']
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

* Install git on your workstation
* Configure git with your user name and e-mail address
* Log in to your account on GitHub
* Describe the difference between git and GitHub



## <i class="fa fa-check-square-o fa-2" aria-hidden="true"></i> What you need

Before getting started with this lesson, you'll want to make sure you have access to a terminal emulator that is running bash, install git, and create an account on GitHub.

* [The Bash shell](https://swcarpentry.github.io/workshop-template)
* [Installing git](https://swcarpentry.github.io/workshop-template/#git)
* [Configuring git for the first time](https://git-scm.com/book/en/v2/Getting-Started-First-Time-Git-Setup)
* [Creating a free user account on GitHub](https://github.com/join)

</div>


In this page, you will be introduced to the importance of version control in
scientific workflows.

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

* Git
* Mercurial
* Subversion


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

A version control system keeps track of what has changed in one or more files over time.
Version control systems begin with a base version of a document.
They then save the committed changes that you make.
You can think of version control as a tape: if you rewind the tape and start at the base document, then you can play back each change and end up with your latest version.

<!-- Images that we use ideally are housed locally to enforce https ... but we can't always do that. in this instance we can because this is a SWC image -->
 <figure>
	<a href="{{  site.url }}/images/workshops/version-control/swc_git_play-changes.svg">
	<img src="{{  site.url }}/images/workshops/version-control/swc_git_play-changes.svg"></a>
	<figcaption> A version control system saves changes to a document, sequentially
  as you add and commit them to the system.
	Source: <a href="http://swcarpentry.github.io/git-novice/01-basics.html" target="_blank"> Software Carpentry </a>
	</figcaption>
</figure>

Once you think of changes as separate from the document itself, you can then
think about “playing back” different sets of changes onto the base document.
You can then retrieve, or revert to, different versions of the document.

Collaboration with version control allows to users to make independent changes to the same document.

 <figure>
	<a href="{{  site.url }}/images/workshops/version-control/swc_git_versions.svg">
	<img src="{{  site.url }}/images/workshops/version-control/swc_git_versions.svg"></a>
	<figcaption> Different versions of the same document can be saved within a
  version control system.
	Source: <a href="http://swcarpentry.github.io/git-novice/01-basics.html" target="_blank"> Software Carpentry </a>
	</figcaption>
</figure>

If there aren’t conflicts between the users changes (a conflict is an area
where both users modified the same part of the same document in different
ways) you can review two sets of changes on the same base document.

 <figure>
	<a href="{{  site.url }}/images/workshops/version-control/swc_git_merge.svg">
	<img src="{{  site.url }}/images/workshops/version-control/swc_git_merge.svg"></a>
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


Git uses a distributed version control model.
This means that there can be many copies (or forks in GitHub world) of the repository.
When working locally, git is the program that you will use to keep track of changes to your repository.
GitHub can be thought of as a location on the internet that acts as a remote location for your repository, providing a backup in case your local copy is lost (e.g., if your computer falls off a pier).

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

## Additional resources

- [About version control](https://git-scm.com/book/en/v2/Getting-Started-About-Version-Control)
