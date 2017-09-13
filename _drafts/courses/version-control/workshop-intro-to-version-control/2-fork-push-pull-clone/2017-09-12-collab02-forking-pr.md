---
layout: single # the template to use to build the page
authors: ['author one', 'author one'] # add one or more authors as a list
category: [courses] # the category of choice - for now courses
title: 'Descriptive title here' # title should be concise and descriptive
attribution: 'Any attribute text that is required' # if we want to provide attribution for someone's work...
excerpt: 'Learn how to .' # one to two sentence description of the lesson using a "call to action - if what someone will learn for SEO"
dateCreated: 2017-09-12  # when the lesson was built
modified: '2017-09-13' # will populate during knitting
nav-title: 'Forks 2' # this is the text that appears on the left hand side bar describing THIS lesson 1-3 words max
class-order: 2 # define the order that each group of lessons are rendered -- this is the second in the series currently
week: 1 # ignore this for now. A week is a unit and is what groups all of these things fo the workshop together
sidebar: # leave this alone!!
  nav:
course: "intro-version-control-git" # this is the "Course" or module name. it needs to be the same for all lessons in the workshop
class-lesson: ['fork-pull-push'] # this is the lesson set name - it is the same for all lessons in this folder and handles the subgroups
permalink: /courses/intro-version-control-git/forks2/ # permalink needs to follow the structure coursename - lesson name using slugs
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


In this tutorial, we will fork, or create a copy in your github.com account,
an existing GitHub repository. We will also explore the github.com interface.

<div id="objectives" markdown="1">
# Learning Objectives
At the end of this activity, you will be able to:

* Create a GitHub account.
* Know how to navigate to and between GitHub repositories.
* Create your own fork, or copy, a GitHub repository.
* Explain the relationship between your forked repository and the master
repository it was created from.

****

#### Additional Resources:


* <a href="http://rogerdudler.github.io/git-guide/files/git_cheat_sheet.pdf" target="_blank"> Diagram of Git Commands </a>
-- this diagram includes more commands than we will
learn in this series but includes all that we use for our standard workflow.
* <a href="https://help.github.com/articles/good-resources-for-learning-git-and-github/" target="_blank"> GitHub Help Learning Git resources </a>

</div>

## Create An Account
If you do not already have a GitHub account, go to <a href="http://github.com" target="_blank" >GitHub </a> and sign up for
your free account. Pick a username that you like! This username is what your
colleagues will see as you work with them in GitHub and Git.

Take a minute to setup your account. If you want to make your account more
recognizable, be sure to add a profile picture to your account!

If you already have a GitHub account, simply sign in.

<i class="fa fa-star"></i> **Data Tip:** Are you a student? Sign up for the
<a href="https://education.github.com/pack" target="_blank" >Student Developer Pack</a>
and get the Git Personal account free (with unlimited private repos and other
discounts/options; normally $7/month).
{: .notice}

## Navigate GitHub

### Repositories AKA Repos

Let's first discuss the repository or "repo". (The cool kids say repo, so we will
jump on the git cool kid bandwagon) and use "repo" from here on in. According to
<a href="https://help.github.com/articles/github-glossary/" target="_blank"> the GitHub glossary</a>:

> A repository is the most basic element of GitHub. They're easiest to imagine
as a project's folder. A repository contains all of the project files (including
documentation), and stores each file's revision history. Repositories can have
multiple collaborators and can be either public or private.

In the Data Institute, we will share our work in the
<a href="https://github.com/NEON-WorkWithData/DI16-NEON-participants" target="_blank">DI16-NEON-participants repo.</a>

### Find an Existing Repo

The first thing that you'll need to do is find the DI16-NEON-participants repo.
You can find repos in two ways:

1. Type  “**DI16-NEON-participants**”  in the github.com search bar to find the repository.
2. Use the repository URL if you have it - like so:
<a href="https://github.com/NEON-WorkWithData/DI16-NEON-participants" target="_blank"> https://github.com/NEON-WorkWithData/DI16-NEON-participants</a>.

### Navigation of a Repo Page

Once you have found the Data Institute participants repo, take 5 minutes
to explore it.


#### Git Repo Names
First, get to know the repository naming convention. Repository names all take
the format:

**OrganizationName**/**RepositoryName**

So the full name of our repository is:

 **NEON-WorkWithData/DI16-NEON-participants**

#### Header Tabs

At the top of the page you'll notice a series of tabs. Please focus
on the following 3 for now:

* **Code:** Click here to view structure & contents of the repo.
* **Issues:** Submit discussion topics, or problems that you are having with
the content in the repo, here.
* **Pull Requests:** Submit changes to the repo for review /
acceptance. We will explore pull requests more in the <a href="{{ site.baseurl }}/tutorial-series/pre-institute2/git05" target="_blank">
Git 06 tutorial.</a>

 <figure>
	<a href="{{ site.baseurl }}/images/pre-institute-content/pre-institute2-git/Git-MasterScreenshot-tabs.png">
	<img src="{{ site.baseurl }}/images/pre-institute-content/pre-institute2-git/Git-MasterScreenshot-tabs.png"></a>
	<figcaption> Screenshot of the NEON Data Institute central repository.
	The github.com search bar is at the top of the page. Notice there are 6
	"tabs" below the repo name including: Code, Issues, Pull Request, Pulse,
	Graphics and Settings. NOTE: Because you are not an administrator for this
	repo, you will not see the "Settings" tab in your browser.
	Source: National Ecological Observatory Network (NEON)
	</figcaption>
</figure>



#### Other Text Links

A bit further down the page, you'll notice a few other links:

* **commits:** a commit is a saved and documented change to the content
or structure of the repo. The commit history contains all changes that
have been made to that repo. We will discuss commits more in
<a href="{{ site.baseurl }}/tutorial-series/pre-institute2/git05"> Git 05: Git Add Changes -- Commits </a>.

## Fork a Repository

Next, let's discuss the concept of a fork on the github.com site. A fork is a
copy of the repo that you create in **your account**. You can fork any repo at
any time by clicking the fork button in the upper right hand corner on github.com.

 <figure>
	<a href="{{ site.baseurl }}/images/pre-institute-content/pre-institute2-git/GitHubGuides_Bootcamp-Fork.png">
	<img src="{{ site.baseurl }}/images/pre-institute-content/pre-institute2-git/GitHubGuides_Bootcamp-Fork.png" width="70%"></a>
	<figcaption> Click on the "Fork" button to fork any repo. Source:
<a href="https://guides.github.com/activities/forking/" target="_blank">GitHub Guides</a>.
	</figcaption>
</figure>

<figure>
 <a href="{{ site.baseurl }}/images/pre-institute-content/pre-institute2-git/git_fork_emphasis.png">
 <img src="{{ site.baseurl }}/images/pre-institute-content/pre-institute2-git/git_fork_emphasis.png" width="70%"></a>
 <figcaption>When we fork a repo in github.com, we are telling Git to create an
 exact copy of the repo that we're forking in our own github.com account.
 Once the repo is in our own account, we can edit it as we now own that fork.
 Note that a fork is just a copy of the repo on github.com.
 Source: National Ecological Observatory Network (NEON) </a>
 </figcaption>
</figure>



 <div id="challenge" markdown="1">
## Activity: Fork the NEON DI16 Participants Repo

Create your own fork of the DI16-NEON-participants now.

</div>


<i class="fa fa-star"></i> **Data Tip:** You can change the name of a forked
repo and it will still be connected to the central repo from which it was forked.
For now, leave it the same.
{: .notice}

## Check Out Your Data Institute Fork

Now, check out your new fork. Its name should be:

 **YOUR-USER-NAME/DI16-NEON-participants**.

It can get confusing sometimes moving between a central repo:

* https://github.com/NEON-WorkWithData/DI16-NEON-participants

and your forked repo:

* https://github.com/YOUR-USER-NAME/DI16-NEON-participants

A good way to figure out which repo you are viewing is to look at the name of the
repo. Does it contain your username? Or your colleagues? Or NEONs?

## Your Fork vs the Central Repo

Your fork is *an exact copy*, or completely in sync with, the NEON central repo.
You could confirm this by comparing your fork to the NEON central repository using
the **pull request** option. We will learn about pull requests in
<a href="{{ site.baseurl }}/tutorial-series/pre-institute2/git06" target="_blank"> Git06: Sync GitHub Repos with Pull Requests.</a>
For now, take our word for it.

The fork will remain in sync with the NEON central repo until:

1. You begin to make changes to your forked copy of the repo.
2. The central repository is changed or updated by a collaborator.

If you make changes to your forked repo, the changes will not be added to the
NEON central repo until you sync your fork with the NEON central repo.

## Summary Workflow -- Fork a GitHub Repository

On the github.com website:

* Navigate to desired repo that you want to fork.
* Click Fork button.
