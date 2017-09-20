---
layout: single # the template to use to build the page
authors: ['Leah Wasser', 'Max Joseph', 'NEON Data Skills'] # add one or more authors as a list
category: courses # the category of choice - for now courses
title: 'Find your way around a repo hosted on the github.com website' # title should be concise and descriptive
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

In this tutorial, we will learn how to use the github.com website.

<div class='notice--success' markdown="1">

## <i class="fa fa-graduation-cap" aria-hidden="true"></i> Learning objectives
At the end of this activity, you will be able to:

* Know how to navigate to and between GitHub repositories.


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

The first thing that you'll need to do is find the `earthlab/14ers-gi`t repo.
You can find repos in two ways:

1. Type “**14ers-git**”  in the github.com search bar to find the repository.
2. Use the repository URL if you have it - like so:
<a href="https://github.com/EarthLab/14ers-git" target="_blank"> https://github.com/EarthLab/14ers-git</a>.

### The Github.com interface

Once you have found the https://github.com/EarthLab/14ers-git repo,
explore it.

* Notice the structure of the repository name: Repository names will always begin with the account or organization name followed by the repo name. Like this: `organization-or-account-name/repo-name`

The full name of our repo is:

 `EarthLab/14ers-git`

* Next, below the repo full name, explore the header tabs

Notice the following 3 that you will use in this workshop:

* **Code:** Click here to view structure & contents of the repo.
* **Issues:** Submit discussion topics, or problems that you are having with
the content in the repo, here.
* **Pull Requests:** Submit changes to the repo for review /
acceptance.

 <figure>
	<a href="{{ site.url }}/images/workshops/version-control/github-repo-interface.png">
	<img src="{{ site.url }}/images/workshops/version-control/github-repo-interface.png"></a>
	<figcaption> Screenshot of the `earthlab/14ers-git` central repository.
	The github.com search bar is located at the very top of the page. Notice there are 6
	"tabs" below the repo name including: Code, Issues, Pull Request, ...etc.
  NOTE: Because you are not an administrator for this
	repo, you will not see the "Settings" tab in your browser.
	Source: Earth Lab
	</figcaption>
</figure>



#### Other Text Links

A bit further down the page, you'll notice a few other links including
commits and branch. We learned how to commit changes in the [basic git commands lesson.]({{ site.url }}/courses/intro-version-control-git/basic-git-commands/)


<i class="fa fa-star"></i> A `commit` is a documented change to the content
or structure of the repo. The `commit` history contains all changes that
have been made to that repo.
{: .notice--success }
