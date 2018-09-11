---
layout: single
authors: ['Leah Wasser', 'Max Joseph', 'Software Carpentry','NEON Data Skills']
category: courses
title: 'How to fork a repo in GitHub'
attribution: ''
excerpt: 'Learn how to fork a repository using the GitHub website.'
dateCreated: 2017-09-12
modified: '2018-09-10'
nav-title: 'Fork a GitHub repo'
sidebar:
  nav:
module: "intro-version-control-git"
permalink: /workshops/intro-version-control-git/about-forks/
author_profile: false
comments: true
order: 6
topics:
  reproducible-science-and-programming: ['git', 'version-control']
---


{% include toc title="In this lesson" icon="file-text" %}

<!--  This is the top block with the learning objectives (LO) -->
<div class='notice--success' markdown="1">

## <i class="fa fa-graduation-cap" aria-hidden="true"></i> Learning objectives
At the end of this activity, you will:

* Be able to create a fork, or copy, of a GitHub repository within your Github account.
* Know how to navigate between your GitHub repository and a forked GitHub repository.
* Be able to explain how your forked repository relates to the original repository that it was created from.


## <i class="fa fa-check-square-o fa-2" aria-hidden="true"></i> What you need

* A GitHub user account
* A terminal running bash, and
* git installed and configured on your computer.

Follow the setup instructions here:
* [Setup instructions]({{ site.url }}/workshops/intro-version-control-git/)

</div>

## What is a fork?

A <a href="https://help.github.com/articles/fork-a-repo/" target="_blank">GitHub fork</a>
is a copy of a repository (repo) that sits in your account rather than the account from
which you forked the data from. Once you have forked a repo, you own your forked copy.
This  means that you can edit the contents of your forked repository without impacting
the parent repo.

<figure>
 <a href="{{ site.url }}/images/workshops/version-control/git-fork-emphasis.png">
 <img src="{{ site.url }}/images/workshops/version-control/git-fork-emphasis.png" alt="When you fork a repo, you make an exact copy of the repo in your own account. Once you create a copy in your account you own it! Thus, you you can freely modify it as you wish." width="70%"></a>
 <figcaption>When you fork a repo, you make an exact copy of the repo in your own account. Once you create a copy in your account you own it! Thus, you you can
 freely modify it as you wish. Image source: Colin Williams, NEON
 </figcaption>
</figure>


### An example forking workflow

In this workshop you will work from a central repo owned by Earth Lab. You will:

1. `Fork` this repo owned by <a href="https://github.com/earthlab" target="_blank">Earth Lab</a> into your GitHub account.
2. `Clone` the fork of your repo, so you can edit the contents locally
3. Make edits to your local cloned copy of the repo on your computer
4. `add`, `commit` and `push` those edits back to your fork on GitHub
5. Suggest the changes that you made, to be added to the Earth Lab central repo using a `pull request`

This workflow has a **central repository** - which is the one that Earth Lab owns.
Everyone in the workshop will then contribute to the central repository. There
are other Git and GitHub workflows too. However in this workshop,
we are demonstrating a central repo workflow.

 <figure>
	<a href="{{ site.url }}/images/workshops/version-control/git-fork-clone-flow.png">
	<img src="{{ site.url }}/images/workshops/version-control/git-fork-clone-flow.png" alt = "In this workshop, we are using a GitHub workflow that assumes a central repository. Earth Lab owns the central repo that you will initially fork." width="70%"></a>
	<figcaption>
	In this workshop, we are using a GitHub workflow that assumes a central repository.
  Earth Lab owns the central repo that you will initially fork. Image source: Colin Williams, NEON
	</figcaption>
</figure>


## How to Fork a Repo

You can fork any repo by clicking the fork button in the upper right hand corner of a repo page.

 <figure>
	<a href="{{ site.url }}/images/workshops/version-control/githubguides-bootcamp-fork.png">
	<img src="{{ site.url }}/images/workshops/version-control/githubguides-bootcamp-fork.png" alt="Click on the "Fork" button to fork any repo on github.com ." width="70%"></a>
	<figcaption> Click on the "Fork" button to fork any repo on github.com. Source:
<a href="https://guides.github.com/activities/forking/" target="_blank">GitHub Guides</a>.
	</figcaption>
</figure>

<figure>
 <a href="{{ site.url }}/images/workshops/version-control/git-fork-emphasis.png">
 <img src="{{ site.url }}/images/workshops/version-control/git-fork-emphasis.png" alt="When you fork a repo on GitHub, the forked repo is copied to your GitHub account, and you can edit it as the repo owner." width="70%"></a>
 <figcaption>When you fork a repo on GitHub, the forked repo is copied to your GitHub account,
 and you can edit it as the repo owner.
 Source: National Ecological Observatory Network (NEON)
 </figcaption>
</figure>


<div class="notice--warning" markdown="1">

## <i class="fa fa-pencil-square-o" aria-hidden="true"></i> Challenge: fork the Earth Lab 14ers repo

* Login to your GitHub account.
* Navigate to the `earthLab/14ers-git/`` repo.
* Use the fork button to create your a fork of the `14ers-git` repo in your account.

</div>


<i class="fa fa-star"></i> **Data tip:** You can change the name of a forked
repo and it will still be connected to the central repo from which it was forked.
For now, leave it the same.
{: .notice--success }

## Explore your 14ers-git fork

Now, navigate to your new fork. Its name should be:

 **YOUR-USER-NAME/14ers-git**.

Sometimes, navigating between repositories and keeping track of where you are on the
GitHub website can be confusing. In this case note the URL. The Earth Lab central
repo contains the `earthlab` account name:

* `https://github.com/earthlab/14ers-git`

and your forked repo contains your account name:

* `https://github.com/YOUR-USER-NAME/14ers-git`

A good way to figure out which repo you are viewing is to look at the

1. The name of the repo: does it contain your username? Or your colleagues? Or Earth Lab's?
2. Look at the path or URL to the repo and ask the same questions.

## Your fork vs. the central repo

When you create a fork, it is *an exact copy*, or completely in sync with, the parent repo.
You could confirm this by comparing your fork to the Earth Lab central repository using
the **pull request** option. We will learn about pull requests in the next lesson

The fork will remain in sync with the central repo until:

1. You modify your forked copy of the repo.
2. The central repository is modified.

If you modify your forked repo, the changes will not be reflected in the
central repo until you merge your fork with the central repo.

## Summary workflow -- fork a GitHub repository

On the github.com website:

* Navigate to desired repo that you want to fork.
* Click **Fork** button.

<div class="notice--info" markdown="1">

## Additional resources

### Important terms

* **Central repo (on Earth Lab's GitHub account )** - the main repo that everyone contributes to in the
workshop. This is the "final working version" of the project.
* **Your fork (on your GitHub account)** - your working copy of the central repo stored in your GitHub
account.
* **Your repo clone (on your computer)** - the local version of the fork in your GitHub account that
lives on your computer. You will most often work locally on your computer and then
push updates to GitHub.

### Git resources

* <a href="https://git-scm.com/doc" target="_blank"> Git Pro version 2 book by Scott Chacon and Ben Straub</a>
* <a href="https://ru.atlassian.com/git/tutorials/comparing-workflows/gitflow-workflow" target="_blank">Learn about other version control workflows here. This includes using Bitbucket vs Github for git repo cloud hosting.</a>
* <a href="http://rogerdudler.github.io/git-guide/files/git_cheat_sheet.pdf" target="_blank"> Diagram of Git Commands </a>
-- this diagram includes more commands than we will
learn in this series but includes all that we use for our standard workflow.
* <a href="https://help.github.com/articles/good-resources-for-learning-git-and-github/" target="_blank"> GitHub Help Learning Git resources </a>

</div>
