---
layout: single
authors: ['Leah Wasser', 'Max Joseph', 'Software Carpentry','NEON Data Skills']
category: courses
title: 'Forks in GitHub'
attribution: 'Any attribute text that is required'
excerpt: 'Learn how to .'
dateCreated: 2017-09-12
modified: '2017-09-19'
module-title: 'Template lessons part 2 - Git 2'
nav-title: 'Fork a repo'
sidebar:
  nav:
module: "intro-version-control-git" # this is the "Course" or module name. it needs to be the same for all lessons in the workshop
permalink: /courses/intro-version-control-git/about-forks/
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
which you forked the data from. Once you have forked a repo, you own it. This  means
that you can edit the
contents of it without impacting the repo from which is was copied or forked from.

<figure>
 <a href="{{ site.url }}/images/workshops/version-control/git-fork-emphasis.png">
 <img src="{{ site.url }}/images/workshops/version-control/git-fork-emphasis.png" width="70%"></a>
 <figcaption>When you fork a repo, you make an exact copy of the repo in your own account. Once you create a copy in your account you own it! Thus, you you can
 freely work on and modify it as you wish. Image source: Colin Williams, NEON
 </figcaption>
</figure>


### Create A Working Copy of a Git Repo - Fork

In this workshop you will work from a central repo owned by Earth Lab. You will:

1. `Fork` this repo owned by <a href="https://github.com/earthlab" target="_blank">Earth Lab</a> into your GitHub account.
2. `Clone` the fork of your repo, so you can edit the contents locally
3. Make edits to your local cloned copy of the repo on your computer
4. `add`, `commit` and `push` those edits back to your fork on GitHub
5. Suggest the changes that you made, to be added to the Earth Lab central repo using a `pull request`

This workflow has a **Central Repository** - which is the one that Earth Lab owns.
Everyone in the workshop will then contribute to the central repository. There
are other, different Git and GitHub workflows too. However in this workshop,
we are demonstrating a central repo workflow.

 <figure>
	<a href="{{ site.url }}/images/workshops/version-control/git-fork-clone-flow.png">
	<img src="{{ site.url }}/images/workshops/version-control/git-fork-clone-flow.png" width="70%"></a>
	<figcaption>
	In this workshop, we are using a github workflow that assumes a central repository.
  Earth Lab owns the central repo that you will initially fork. Image source: Colin Williams, NEON
	</figcaption>
</figure>


## How to Fork a Repo

You can fork any repo at
any time by clicking the fork button in the upper right hand corner on github.com.

 <figure>
	<a href="{{ site.url }}/images/workshops/version-control/githubguides-bootcamp-fork.png">
	<img src="{{ site.url }}/images/workshops/version-control/githubguides-bootcamp-fork.png" width="70%"></a>
	<figcaption> Click on the "Fork" button to fork any repo. Source:
<a href="https://guides.github.com/activities/forking/" target="_blank">GitHub Guides</a>.
	</figcaption>
</figure>

<figure>
 <a href="{{ site.url }}/images/workshops/version-control/git-fork-emphasis.png">
 <img src="{{ site.url }}/images/workshops/version-control/git-fork-emphasis.png" width="70%"></a>
 <figcaption>When we fork a repo on the github website, we are creating an
 exact copy of that forked repo in our own github account.
 Once the repo is in our own account, we can edit it as we now own that fork.
 Source: National Ecological Observatory Network (NEON)
 </figcaption>
</figure>


<div class="notice--warning" markdown="1">

## <i class="fa fa-pencil-square-o" aria-hidden="true"></i> Challenge: Fork the Earth Lab 14ers Repo

* Login to your github account.
* Navigate to the `EarthLab/14ers-git/`` repo.
* Use the fork button to create your a fork of the `14ers-git` repo in your account.

</div>


<i class="fa fa-star"></i> **Data Tip:** You can change the name of a forked
repo and it will still be connected to the central repo from which it was forked.
For now, leave it the same.
{: .notice--success }

## Check Out Your Data Institute Fork

Now, check out your new fork. Its name should be:

 **YOUR-USER-NAME/14ers-git**.

It can get confusing sometimes moving between a central repo:

* `https://github.com/earthlab/14ers-git`

and your forked repo:

* `https://github.com/YOUR-USER-NAME/14ers-git`

A good way to figure out which repo you are viewing is to look at the

1. The name of the repo: does it contain your username? Or your colleagues? Or EarthLab's?
2. Look at the path or URL to the repo and ask the same questions.

## Your Fork vs. the Central Repo

When you initially create a fork, it is *an exact copy*, or completely in sync with,
the Earth Lab central repo.
You could confirm this by comparing your fork to the Earth Lab central repository using
the **pull request** option. We will learn about pull requests in the next lesson

The fork will remain in sync with the Earth Lab central repo until:

1. You begin to make changes to your forked copy of the repo.
2. The central repository is changed or updated by a collaborator.

If you make changes to your forked repo, the changes will not be added to the
Earth Lab central repo until you sync your fork with the Earth Lab central repo.

## Summary Workflow -- Fork a GitHub Repository

On the github.com website:

* Navigate to desired repo that you want to fork.
* Click Fork button.

<div class="notice--info" markdown="1">

## Additional resources

### Important terms

* **Central repo (Earth Lab's GitHub account )** - the main repo that everyone contributes to in the
workshop. This is the "final working version" of the project.
* **Your fork (your GitHub account)** - your working copy of the central repo stored in your GitHub
account.
* **Your repo clone (Your account on your computer)** - the local version of the fork in your GitHub account that
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
