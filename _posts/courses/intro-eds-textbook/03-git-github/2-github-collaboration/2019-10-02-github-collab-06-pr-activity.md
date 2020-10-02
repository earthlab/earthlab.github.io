---
layout: single
title: 'Guided Activity to Submit Pull Requests'
excerpt: "A pull request allows anyone to suggest changes to a repository on GitHub that can be easily reviewed by others. Learn how to submit pull requests on GitHub.com to suggest changes to a GitHub repository."
authors: ['Jenny Palomino', 'Leah Wasser', 'Max Joseph']
category: [courses]
class-lesson: ['git-github-collaboration-tb']
permalink: /courses/intro-to-earth-data-science/git-github/github-collaboration/practice-pull-requests/
nav-title: "Guided Activity to Submit Pull Requests"
dateCreated: 2018-07-25
modified: 2020-10-02
odule-type: 'class'
class-order: 2
course: "intro-to-earth-data-science-textbook"
week: 3
sidebar:
  nav:
author_profile: false
comments: true
order: 6
topics:
  reproducible-science-and-programming: ['git']
redirect_from:
  - "/courses/earth-analytics-bootcamp/git-github-version-control/guided-activity-pull-request/"
---
{% include toc title="In This Lesson" icon="file-text" %}

In this lesson, you will learn how to submit a pull request to suggest that your edits be included in another repository (e.g. the original repository from which you forked and cloned a repository). Specifcally, you will practice submitting a pull request for your updated `Jupyter Notebook` for Homework 1. 

<div class='notice--success' markdown="1">

## <i class="fa fa-graduation-cap" aria-hidden="true"></i> Learning Objectives

After completing this lesson, you will be able to:

* Explain the relationship between a forked repository (head) and the original repository (base).
* Submit a pull request of changes to a repository on `GitHub.com`. 


## <i class="fa fa-check-square-o fa-2" aria-hidden="true"></i> What You Need

Be sure that you have also completed the <a href="{{ site.url }}/courses/earth-analytics-bootcamp/git-github-version-control/guided-activity-version-control/">Guided Activity on Version Control with Git/GitHub</a>.

You will also need a web browser and your `GitHub.com` login (username and password). 

</div>
## Step 1: Fork and Clone The GitHub Repo To Make a Copy That You Own

To begin, fork the https://github.com/earthlab-education/ea-bootcamp-hometowns repository.
Remember that this step only needs to be done once. When you create this fork, you then have full ownership of the fork in your user account. Full ownership means that you can make direct changes to the fork without submitting a Pull Request.

After you have forked the repo, clone it so that you have a copy locally to work with on your computer. 

<i class="fa fa-star"></i> **Data Tip:** Remember that you can use `git remove -v` to view the url path of your clone. This will allow you to ensure that your cloned your FORK rather than the repo owned by **earthlab-education**. 
{: .notice--success}

## Step 2:  Make some changes to the repo

For this assignment, you will add a new **markdown file** that contains information about your hometown. 

1. Create a fork of this repository and add to your fork a Jupyter Notebook called `city-state-or-country.md` (e.g. houston-tx.md). Add three interesting facts about the town that you live in using [Markdown](https://www.earthdatascience.org/courses/intro-to-earth-data-science/file-formats/use-text-files/format-text-with-markdown-jupyter-notebook/):

- add a Location subtitle (header) with the latitude and longitude of the town center below it
- add a Population subtitle (header) and the information for the most recent population figure you can find, plus a hyperlink to the source for this information
- add a Landmark subtitle (header) for a local landmark, plus an image and short text description of this landmark.

If a file for your town already exists in this repo as a markdown file, you can add any other facts about your town to that file that you wish following the structure listed above! 

Finally add your town as a row in the hometowns.csv file specifying the town, the type (whether it's your hometown or somewhere you live or somewhere you love and country, city and state and the lat/long location.  

| who (OPTIONS: cu-student; certificate-student; earthdatascience.org student, other) | type | country | state | city | latitude | longitude | 
|:---|:---|:---|---|---|---|---|
| other | hometown | United States | Colorado | Boulder | 40.0150 N | 105.2705 W| 
| cu-student | where I live | United States | Colorado | Boulder | 40.0150 N | 105.2705 W| 
| certificate-student | place i've lived | United States | State | City | latitude-here | longitude-here | 
| earthdatascience.org student | place i've lived | Australia | State | City | latitude-here | longitude-here | 


2. Submit a pull request from your fork to this repository, with the following included in the message of your pull request: 

- notify the owner of the repository (your instructor) that you have addressed the issue using `@lwasser`
- reference the issue number using `Fixes #issue-number` (e.g. the issue number is above in the title of this issue)


## About Pull Requests

In the <a href="{{ site.url }}/courses/earth-analytics-bootcamp/git-github-version-control/guided-activity-version-control/">Guided Activity on Version Control with Git/GitHub</a>, you added, committed, and pushed changed files to your forked repository on `https://github.com/yourusername/ea-bootcamp-hw-1-yourusername`. 

To submit changed files to the original repository owned by earthlab-education (`https://github.com/earthlab-education/ea-bootcamp-hw-1-yourusername`), you need to submit a pull request on `GitHub.com`. 

<figure>
   <a href="{{ site.url }}/images/earth-analytics/git-version-control/git-push-pr.png">
   <img src="{{ site.url }}/images/earth-analytics/git-version-control/git-push-pr.png" alt="LEFT: To sync changes made and committed locally on your computer to your Github account, you push the changes from your computer to your fork on GitHub. RIGHT: To suggest changes to another repository, you submit a Pull Request to update the central repository. Source: Colin Williams, NEON."></a>
   <figcaption> LEFT: To sync changes made and committed locally on your computer to your Github account, you push the changes from your computer to your fork on GitHub. RIGHT: To suggest changes to another repository, you submit a Pull Request to update the central repository. Source: Colin Williams, NEON.
   </figcaption>
</figure>

Pull requests inform the owner of the original repository (e.g. `https://github.com/earthlab-education/ea-bootcamp-hw-1-yourusername`) that you have changed files you would like to add from a forked repository (e.g. `https://github.com/yourusername/ea-bootcamp-hw-1-yourusername`). 

A pull request to another repository is similar to a “push”. However, it allows for a few things:

1. It allows you to contribute to another repo without needing administrative privileges to make changes to the repository.
2. It allows others to review your changes and suggest corrections, additions, edits, etc.
3. It allows repository administrators control over what gets added to their project repo.

The ability to suggest changes to ANY repository, without needing administrative privileges is a powerful feature of `GitHub`. You can make as many changes as you want in your fork, and then suggest that the owner of the original repository incorporate those changes using a pull request.

## Submit Pull Requests 

This section was adapted from the `GitHub` <a href="https://guides.github.com/activities/hello-world/" target = "_blank">Hello World guide</a>. They provide an animated version of these directions.

Pull requests are the heart of collaboration on `Github.com`. When you open a pull request, you’re proposing your changes and requesting that someone review and pull in your contribution and merge them into their project.

Pull requests show diffs, (differences), of the content between your repo and the repo that you are submitting changes to. The changes, additions, and subtractions are shown in green and red.


### Step 1 - Start Pull Request

To begin a pull request (PR), click the `New pull request` button on the main page of your forked repository (e.g. `https://github.com/yourusername/ea-bootcamp-hw-1-yourusername`).

<figure>
 <a href="{{ site.url }}/images/earth-analytics/git-version-control/new-pull-request.png">
 <img src="{{ site.url }}/images/earth-analytics/git-version-control/new-pull-request.png" alt="Location of the New pull request button on the main page of an example repository for jenp0277. This repository has been forked from the repository owned by earthlab-education. Changes have been made by jenp0277 in her fork, and jenp0277 is ready to create a new pull request to send changes from her fork to the repository owned by earthlab-education."></a>
 <figcaption> Location of the New pull request button on the main page of an example repository for jenp0277. This repository has been forked from the repository owned by earthlab-education. Changes have been made by jenp0277 in her fork, and jenp0277 is ready to create a new pull request to send changes from her fork to the repository owned by earthlab-education.
 </figcaption>
</figure>

<i class="fa fa-star"></i> **Data Tip:** You can also click the “Pull Requests” tab at the top of the main page of a repository to submit a pull request (PR). When the pull request page opens, click the “New pull request” button to initiate a PR.
{: .notice--success}


### Step 2 - Select Repository to Update

Next, you need to select which repository you wish to update (the base repo) and which repository contains the content that you wish to use to update the base (the head repo). 

In this example, you want to update `earthlab-education/ea-bootcamp-hw-1-yourusername` with commits in your fork `/yourusername/ea-bootcamp-hw-1-yourusername`.

#### Head vs Base

* Base: the repository that will be updated; changes will be added to this repository.
* Head: the repository containing the changes that will be added to the base.

One way to remember this is that the “head” is ahead of the "base". So you must add from the head to the base.

When you begin a pull request, the head and base will auto-populate as follows:

* base fork: `earthlab-education/ea-bootcamp-hw-1-yourusername`
* head fork: `/yourusername/ea-bootcamp-hw-1-yourusername`

The above pull request configuration tells `Github.com` to update the base repository with contents from your forked repository, or the head repository.

### Step 3 - Verify Changes

When you compare two repos in a pull request page, `GitHub` provides an overview of the differences (diffs) between the files. Look over the changes and make sure nothing looks surprising. 

You can also click on the commit titles to see the specific changes in each commit. 

<figure>
 <a href="{{ site.url }}/images/earth-analytics/git-version-control/github-pull-request-diff.png">
 <img src="{{ site.url }}/images/earth-analytics/git-version-control/github-pull-request-diff.png" alt="This screenshot shows the differences between the files in Earth Lab's version of the 14ers-git repo and a fork of that repository created by lwasser. When showing line by line changes, the deletions will be highlighted in red and additions will be highlighted in green. Pull request diffs view can be changed between unified and split (arrow)."></a>
 <figcaption> This screenshot shows the differences between the files in Earth Lab's version of the 14ers-git repo and a fork of that repository created by lwasser. When showing line by line changes, the deletions will be highlighted in red and additions will be highlighted in green. Pull request diffs view can be changed between unified and split (arrow).
 </figcaption>
</figure>

### Step 4 - Create New Pull Request

If you are adding new commits to base repository (e.g. `earthlab-education/ea-bootcamp-hw-1-yourusername`), then the "Create Pull Request" button will be available. Click the green “Create Pull Request” button to start your pull request.

### Step 5 - Describe Your Pull Request

Add a title and write a brief description of your changes. When you’re done with your message, click “Create Pull Request”.


<figure>
 <a href="{{ site.url }}/images/earth-analytics/git-version-control/github-create-pull-request.png">
 <img src="{{ site.url }}/images/earth-analytics/git-version-control/github-create-pull-request.png" alt="Pull request titles should be concise and descriptive of the content in the pull request. More detailed notes can be left in the comments box."></a>
 <figcaption> Pull request titles should be concise and descriptive of the content in the pull request. More detailed notes can be left in the comments box.
 </figcaption>
</figure>

Notice that when creating a new pull request, you will be automatically transferred to the `Github.com` site for the base repository. 

At this point, you are done with the pull request! In this case, you have submitted a pull request for Homework 1!

Though you may see an active button for Merge Pull Request, this button is intended for the owner of the repository. They can review your pull request and then decide if/when to merge it into their original repository.

Note that until the owner merges your pull request, all future commits that you make to your fork will continue to be added to the open pull request. 


### Close Pull Requests

You can also close a pull request on `Github.com` if you decide you are not ready to submit your files from your forked repository to the original repository. 

For example, the pull request you just created in this lesson can be closed if you have not yet completed Homework 1. When you are ready to submit Homework 1, you can simply create a new pull request on `Github.com` following these same steps.

To close a pull request, simply click on `Close pull request` button toward the bottom of the pull request page.

<figure>
 <a href="{{ site.url }}/images/earth-analytics/git-version-control/github-close-pull-request.png">
 <img src="{{ site.url }}/images/earth-analytics/git-version-control/github-close-pull-request.png" alt="Location of the Close pull request button on an example pull request from jenp0277 to earthlab-education."></a>
 <figcaption> Location of the Close pull request button on an example pull request from jenp0277 to earthlab-education.
 </figcaption>
</figure>

**Congratulations!** You know now how to submit Homework 1. Simply repeat the steps in this lesson when you are ready to submit your final `Jupyter Notebook` file for Homework 1. 
