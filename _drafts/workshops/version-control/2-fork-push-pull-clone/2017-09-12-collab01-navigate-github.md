---
layout: single # the template to use to build the page
authors: ['Leah Wasser', 'Max Joseph', 'NEON Data Skills'] # add one or more authors as a list
category: courses # the category of choice - for now courses
title: 'Sync a fork title here' # title should be concise and descriptive
attribution: 'Any attribute text that is required'
excerpt: 'Learn how to .'
dateCreated: 2017-09-12
modified: '2017-09-20'
nav-title: 'Navigate github repos'
sidebar:
  nav:
module: "intro-version-control-git"
permalink: /courses/intro-version-control-git/navigate-github-repos/
author_profile: false
comments: true
order: 5
topics:
  reproducible-science-and-programming: ['git', 'version-control']
---

{% include toc title="In this lesson" icon="file-text" %}

In this tutorial, we will fork, or create a copy in your github.com account,
an existing GitHub repository. We will also explore the github.com interface.

At the end of this activity, you will be able to:


<!--  This is the top block with the learning objectives (LO) -->
<div class='notice--success' markdown="1">

## <i class="fa fa-graduation-cap" aria-hidden="true"></i> Learning objectives
At the end of this activity, you will be able to:

* Create a GitHub account.
* Know how to navigate to and between GitHub repositories.
* Create your own fork, or copy, a GitHub repository.
* Explain the relationship between your forked repository and the master
repository it was created from.


## <i class="fa fa-check-square-o fa-2" aria-hidden="true"></i> What you need

Some description of what is required to complete this lesson if anything.
For lessons using git we'll link to the setup pages.

* [setup xxx]({{ site.url }}/courses/path-here/)
* [setup xxx]({{ site.url }}/courses/path-here/)

</div>


## Navigate GitHub

### Repositories AKA Repos

A repository or "repo", according to
<a href="https://help.github.com/articles/github-glossary/" target="_blank"> the GitHub glossary</a> is:

> A repository is the most basic element of GitHub. They're easiest to imagine
as a project's folder. A repository contains all of the project files (including
documentation), and stores each file's revision history. Repositories can have
multiple collaborators and can be either public or private.

In this workshop you will collaborate with your colleagues using the
<a href="https://github.com/EarthLab/14ers-git" target="_blank">14ers-git repo.</a>

### Find an Existing Repo

The first thing that you'll need to do is find the earthlab/14ers-git repo.
You can find repos in two ways:

1. Type  “**14ers-git**”  in the github.com search bar to find the repository.
2. Use the repository URL if you have it - like so:
<a href="https://github.com/EarthLab/14ers-git" target="_blank"> https://github.com/EarthLab/14ers-git</a>.

### Navigating repos

Once you have found the https://github.com/EarthLab/14ers-git repo,
explore it.

1. Find the repo name: Repository names will always begin with the account or organization name followed by the repo name. Like this: `organization-or-account-name/repo-name`

The full name of our repository is:

 `EarthLab/14ers-git`

2. Next, below the repo full name, explore the header tabs

Notice the following 3 that you will use in this workshop:

* **Code:** Click here to view structure & contents of the repo.
* **Issues:** Submit discussion topics, or problems that you are having with
the content in the repo, here.
* **Pull Requests:** Submit changes to the repo for review /
acceptance.

 <figure>
	<a href="{{ site.url }}/images/workshops/version-control/Git-MasterScreenshot-tabs.png">
	<img src="{{ site.url }}/images/workshops/version-control/Git-MasterScreenshot-tabs.png"></a>
	<figcaption> UPDATE SCREENSHOT Screenshot of the NEON Data Institute central repository.
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
<a href="{{ site.url }}/tutorial-series/pre-institute2/git05"> Git 05: Git Add Changes -- Commits </a>.






### extra stuff - delete?



****
