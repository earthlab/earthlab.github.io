---
layout: single
title: 'Update GitHub Repositories Using Pull Requests'
excerpt: "GitHub.com can be used to store and access files in the cloud using GitHub repositories. Learn how to submit pull requests on GitHub.com to suggest changes or update a GitHub repository."
authors: ['Jenny Palomino', 'Leah Wasser', 'Max Joseph']
category: [courses]
class-lesson: ['git-github-collaboration']
permalink: /courses/intro-to-earth-data-science/git-github/collaboration/pull-requests-to-update-github-repositories/
nav-title: "Update GitHub Repositories"
dateCreated: 2019-09-06
modified: 2019-09-23
module-type: 'class'
course: "intro-to-earth-data-science-textbook"
week: 3
sidebar:
  nav:
author_profile: false
comments: true
order: 2
topics:
  reproducible-science-and-programming: ['git']
redirect_from:
  - "/courses/earth-analytics-bootcamp/git-github-version-control/guided-activity-pull-request/"
---
{% include toc title="On This Page" icon="file-text" %}

<div class='notice--success' markdown="1">

## <i class="fa fa-graduation-cap" aria-hidden="true"></i> Learning Objectives

After completing this page, you will be able to:

* Explain the relationship between a forked repository (head) and the original repository (base).
* Submit a pull request of changes to a repository on **GitHub.com**. 
* Update your fork of a repository using **GitHub.com**.
* Update your local clone of a repository with changes made in the  **GitHub** repository using `git pull`.

</div>


## About Pull Requests

To submit changed files to a repository owned by another user (e.g. `https://github.com/earthlab-education/ea-bootcamp-git-github-workflow`), you need to submit a pull request on `Github.com`. 

<figure>
   <a href="https://www.earthdatascience.org/images/workshops/version-control/git-push-pr.png">
   <img src="https://www.earthdatascience.org/images/workshops/version-control/git-push-pr.png" alt="LEFT: To sync changes made and committed locally on your computer to your Github account, you push the changes from your computer to your fork on GitHub. RIGHT: To suggest changes to another repository, you submit a Pull Request to update the central repository. Source: Colin Williams, NEON."></a>
   <figcaption> LEFT: To sync changes made and committed locally on your computer to your Github account, you push the changes from your computer to your fork on GitHub. RIGHT: To suggest changes to another repository, you submit a Pull Request to update the central repository. Source: Colin Williams, NEON.
   </figcaption>
</figure>

Pull requests inform the owner of the original repository (e.g. `https://github.com/earthlab-education/ea-bootcamp-hw-1-yourusername`) that you have changed files you would like to add from a forked repository (e.g. `https://github.com/yourusername/ea-bootcamp-hw-1-yourusername`). 

A pull request to another repository is similar to a “push”. However, it allows for a few things:

1. It allows you to contribute to another repo without needing administrative privileges to make changes to the repository.
2. It allows others to review your changes and suggest corrections, additions, edits, etc.
3. It allows repository administrators control over what gets added to their project repo.

The ability to suggest changes to ANY repository, without needing administrative privileges is a powerful feature of `GitHub`. You can make as many changes as you want in your fork, and then suggest that the owner of the original repository incorporate those changes using a pull request.

## Submit Pull Requests To Suggest Changes To Others' Repositories

This section was adapted from the `GitHub` <a href="https://guides.github.com/activities/hello-world/" target = "_blank">Hello World guide</a>. They provide an animated version of these directions.

Pull requests are the heart of collaboration on `Github.com`. When you open a pull request, you’re proposing your changes and requesting that someone review and pull in your contribution and merge them into their project.

Pull requests show diffs, (differences), of the content between your repo and the repo that you are submitting changes to. The changes, additions, and subtractions are shown in green and red.


### Step 1 - Start Pull Request

To begin a pull request (PR), click the `New pull request` button on the main page of your forked repository (e.g. `https://github.com/yourusername/ea-bootcamp-hw-1-yourusername`).

<figure>
 <a href="{{ site.url }}/images/courses/earth-analytics/git/new-pull-request.png">
 <img src="{{ site.url }}/images/courses/earth-analytics/git/new-pull-request.png" alt="Location of the New pull request button on the main page of an example repository for jenp0277."></a>
 <figcaption> Location of the New pull request button on the main page of an example repository for jenp0277. 
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
 <a href="{{ site.url }}/images/courses/earth-analytics/git/diffs.png">
 <img src="{{ site.url }}/images/courses/earth-analytics/git/diffs.png" alt="This screenshot shows the differences between the files on earthlab-education and jenp0277's fork of the repository. When showing line by line changes, the deletions will be highlighted in red and additions will be highlighted in green. Pull request diffs view can be changed between unified and split (arrow)."></a>
 <figcaption> This screenshot shows the differences between the files on earthlab-education and jenp0277's fork of the repository. When showing line by line changes, the deletions will be highlighted in red and additions will be highlighted in green. Pull request diffs view can be changed between unified and split (arrow).
 </figcaption>
</figure>

### Step 4 - Create New Pull Request

If you are adding new commits to base repository (e.g. `earthlab-education/ea-bootcamp-hw-1-yourusername`), then the "Create Pull Request" button will be available. Click the green “Create Pull Request” button to start your pull request.

### Step 5 - Describe Your Pull Request

Add a title and write a brief description of your changes. When you’re done with your message, click “Create Pull Request”.


<figure>
 <a href="{{ site.url }}/images/courses/earth-analytics/git/create-pull-request.png">
 <img src="{{ site.url }}/images/courses/earth-analytics/git/create-pull-request.png" alt="Pull request titles should be concise and descriptive of the content in the pull request. More detailed notes can be left in the comments box."></a>
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
 <a href="{{ site.url }}/images/courses/earth-analytics/git/close-pull-request.png">
 <img src="{{ site.url }}/images/courses/earth-analytics/git/close-pull-request.png" alt="Location of the Close pull request button on an example pull request from jenp0277 to earthlab-education."></a>
 <figcaption> Location of the Close pull request button on an example pull request from jenp0277 to earthlab-education.
 </figcaption>
</figure>


## Update Your Repository with Changes From Others

When others make in the original repository, you can copy (i.e. pull) those changes to your fork of that repository and then you can copy those changes to the clone on your local computer. 

First, you need to create a pull request on **GitHub.com** to update your fork of the repository from the original repository, and then you need to run the `git pull` command in the Terminal to update your local clone. The following sections review how to complete these steps. 


### Update Your Forked Repo on Github.com

To update your fork on **GitHub.com**, navigate in your web browser to the main **GitHub.com** page of your forked repository: `https://github.com/your-username/example-repository`.

On this web page, create a pull request from the original repository by following these steps:
1. Click on the `New pull request` button to begin the pull request
2. On the new page, choose your fork as the **base fork** and the original repository (e.g. from earthlab-education) as the **head fork**.  This will indicate that the changed files are being requested by your fork (i.e. the base fork) from the original repository (i.e. the head fork). **You will need to click on the text `compare across forks` to be able to update both the base and head forks appropriately.** 
4. Then, click on `Create pull request`.
5. On the new page, click on `Create pull request` once more to finish creating the pull request. 

<figure>
 <a href="{{ site.url }}/images/courses/earth-analytics/git/github-create-reverse-pull-request.gif">
 <img src="{{ site.url }}/images/courses/earth-analytics/git/github-create-reverse-pull-request.gif" alt="You can update your fork with changes made to the original Github repository by creating a pull request from the original repository to your fork."></a>
 <figcaption> You can update your fork with changes made to the original Github repository by creating a pull request from the original repository to your fork. 
 </figcaption>
</figure>

After creating the pull request, you need to merge the pull request, so that the changes in the original repository are copied to your computer. 

You can simply click on the green button for `Merge pull request` and `Confirm merge`. Once you return to the main page of your fork, you will see the changes reflected. 

<figure>
 <a href="{{ site.url }}/images/courses/earth-analytics/git/github-merge-reverse-pull-request.gif">
 <img src="{{ site.url }}/images/courses/earth-analytics/git/github-merge-reverse-pull-request.gif" alt="After creating a pull request, you merge the pull request to apply the changes from the original repository to your fork."></a>
 <figcaption> After creating a pull request, you merge the pull request to apply the changes from the original repository to your fork. 
 </figcaption>
</figure>


### Update Your Local Clone 

To copy the updated files locally to your computer, you can use the Terminal. 

Run the following commands to navigate to the directory that contains your local clone and then to pull down the changes from your updated **GitHub** fork.

```bash
$ cd ~
$ cd earth-analytics
$ cd example-repository
$ git pull
```

Congratulations! You have now updated your local clone with the updates made to the original **GitHub** repository.




___________________

## NEED TO ADD:

* Question: make a new page for the section called Update Your Repository with Changes From Others?
    * It currently covers reverse pull request to update your fork and then run git pull to update clone
* Question: create new page for following or add to this page:
    * Propose changes to others’ repositories on GitHub
        * Using Issues
        * Create a new issue
        * Communicate with @mention
        * Close an issue through a pull request


For Jenny:
* Need to save copies of all external images using file-names-like-this.png to images/earth-analytics/git-version-control
* Move all images that need it to images/earth-analytics/git-version-control 

