---
layout: single
title: 'How To Create A Pull Request on Github: Propose Changes to GitHub Repositories'
excerpt: "A pull request allows anyone to suggest changes to a repository on GitHub that can be easily reviewed by others. Learn how to submit pull requests on GitHub.com to suggest changes to a GitHub repository."
authors: ['Leah Wasser', 'Max Joseph', 'Jenny Palomino']
category: [courses]
class-lesson: ['git-github-collaboration-tb']
permalink: /courses/intro-to-earth-data-science/git-github/github-collaboration/how-to-submit-pull-requests-on-github/
nav-title: "GitHub Pull Requests"
dateCreated: 2019-10-02
modified: 2021-03-31
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

* Explain what a pull request is and how it can be used.
* Explain the relationship between the head repository (e.g. a forked repository) and base (e.g. original repository or main branch) repository.
* Mention or call out someone to review your pull request on **GitHub** using @GitHubUsername.
* Explain what a diff is in **GitHub**.
* Submit a pull request of changes to a repository on **GitHub.com**.

</div>


## About Pull Requests And Two Ways to Create A Pull Request

A **pull request** (referred to as a **PR**) is a way for you to suggest changes
to a repository that are visible and can be easily reviewed. 

Pull requests are specific to **GitHub** and can be implemented in two ways:

1. You submit changes to another repository based upon changes that you made to a fork (i.e. copy owned by you) of that repository.
2. You submit changes to an existing repository using a branch (i.e. a copy of the main branch of repository). Branches are not discussed in this chapter but you will learn more about branches as you get into more advanced **GItHub** topics.

## Introduction to the Pull Request Workflow

For the purposes of this page, pretend that you are working with your colleague
on a project. You have been asked to make some changes to a README.md file
in your collaborator's repository. 

To begin this task, you:

1. <a href="{{ site.url }}/courses/intro-to-earth-data-science/git-github/version-control/fork-clone-github-repositories/#create-a-copy-of-other-users-files-on-githubcom-forking">Create a fork</a> of your colleague's repository. 
2. Clone that fork to your local computer and begin to work on the README.md file in a text editor.
3. When you are done editing the text file locally on your computer, you save the file and `git add` and `git commit` your changes using git.
4. Finally, you `git push` those changes back up to your fork of your colleague's repository.

Now, the changes are in your fork but you want to suggest those changes as updates to your colleague's repository. To do this, you submit a pull request with the changes to your colleague's repository.

<figure>
   <a href="{{ site.url }}/images/earth-analytics/git-version-control/git-push-pr.png">
   <img src="{{ site.url }}/images/earth-analytics/git-version-control/git-push-pr.png" alt="LEFT: To sync changes made and committed locally on your computer to your GitHub account, you push the changes from your computer to your fork on GitHub. RIGHT: To suggest changes to another repository, you submit a Pull Request to update the central repository. Source: Colin Williams, NEON."></a>
   <figcaption> LEFT: To sync changes made and committed locally on your computer to your GitHub account, you push the changes from your computer to your fork on GitHub. RIGHT: To suggest changes to another repository, you submit a Pull Request to update the central repository. Source: Colin Williams, NEON.
   </figcaption>
</figure>

When you open up a pull request, you will see the line by line changes or
differences between the file you submitted, compared to the file that exists
in a repository. These changes are called **diffs** (short for differences).

Pull requests show diffs of the content between (a branch on) your repository and (a
branch on) the repository that you are submitting changes to. 

The changes, additions,
and subtractions are shown in green and red. The color green represents additions
to the file whereas red represents deletions.

<figure>
 <a href="{{ site.url }}/images/earth-analytics/git-version-control/github-diff-file.png">
 <img src="{{ site.url }}/images/earth-analytics/git-version-control/github-diff-file.png" alt="This screenshot shows a diff associated with a pull request. On the LEFT, you can see the text (highlighted with red) that was modified by the proposed pull request. The words that are dark red were the ones that were deleted. On the RIGHT, you can see the text (in green) that represents the proposed changes. The words that are darker green were added. In this example, the word **earthpy** was replaced with **matplotcheck** in the contributing.rst file of the repo"></a>
 <figcaption>This screenshot shows a diff associated with a pull request. On the LEFT, you can see the text (highlighted with red) that was modified by the proposed pull request. The words that are dark red were the ones that were deleted. On the RIGHT, you can see the text (in green) that represents the proposed changes. The words that are darker green were added. In this example, the word **earthpy** was replaced with **matplotcheck** in the contributing.rst file of the repo.
 </figcaption>
</figure>

### GItHub and Mentions: Communicating With Your Collaborators

After you have submitted your PR, your colleague can review the changes. It is
good practice to "mention" your colleague specifically when you submit your PR to
ensure that they see it. 

You can do that by using `@their-github-username-here` in a
comment in the PR (e.g. `@eastudent` which will notify the GitHub user called eastudent). 

Your colleague will review the changes.  If they would like a few additional changes, they will
request changes. 

Once your colleague is happy with the changes, then they
will merge your PR. This is the general PR workflow.


## The Anatomy of a Diff (Difference Between Two Files)

As mentioned above, a diff represents differences between two files in **git**.

**Git** keeps track of changes through additions and deletions on a character by
character and line by line basis.

So, pretend that the word "great" is spelled incorrectly in a file, and you wish
to fix the spelling. The edit that you will make is: **graet** is changed to **great**

The change above represents 2 character deletions and 2 additions.

The word great has 5 characters, so the number of characters is not changing in this example.

However, you are deleting: `ae` and replacing those two characters with `ea`.

As you edit files in a version control system like **git**, it is tracking each character
addition and deletion. These tracked changes are what you see in a diff when you submit a pull
request.

## GitHub Pull Requests Support Open Science and Open Collaboration

A pull request (herein referred to as **PR**) is ideal to use as a collaboration
tool. A **PR** is similar to a “push” that you would make to a repository that
you own. However, a **PR** also allows for a few things:

1. It allows you to contribute to another repo without needing administrative privileges to make changes to the repository.
2. It documents changes as they are made to a repository and as they address issues. It also makes those changes easily visible to anyone who may want to see them.
3. It allows others to review your changes and suggest corrections, additions, and edits on a line by line basis to those changes as necessary.
4. It supports and documents conversation between collaborators on the project.
5. It allows repository administrators or code maintainers to control what gets added to the project repository.

Note if you do not own the repository that you wish to modify, a **PR** is the
only way that you can contribute changes to that repository.

This ability to suggest changes to ANY repository, without needing administrative
privileges is a powerful feature of **GitHub**. 

This workflow supports open science
because the entire process of updating content is open and supported by peer
review. You can make as many changes as you want in your fork, and then suggest
that the owner of the original repository incorporate those changes using a pull request.

## Pull Request Terminology - Head vs. Base

Consider the example above where you were submitting changes to the contributing.rst
file in your colleague's repo. After pushing the changes to your fork, you are ready to make a pull request to your colleague's repo.  

When submitting a pull request, you need to specify both where you'd like to
suggest the changes (e.g. your colleague's repo) and where the changes are
coming from (e.g. your fork). 

There are two key terms that you should know to set this
up in Github: 
* **Base**: Base is the repository that will be updated. Changes will be added to this repository via the pull request. Following the example above, the base repo is your colleague's repo.
* **Head**: Head is the repository containing the changes that will be added to the base. Following the example above, this is your repository (your fork of your colleague's repo).

One way to remember the difference between head and base is that the “head” is
a**head** of the "base". Ahead means that there are changes in the head repo that
the base repo does NOT have. 

So, you need to add the changes from the **head**
 (your forked repo) to the **base** (your colleague's repo).

When you begin a pull request, the head and base will auto-populate. It may
look something like this:

* base fork: `your-colleagues-username/project-name`
* head fork: `your-username/project-name`

Next, you will learn how to create a pull request in **GitHub**.

## How To Submit Pull Requests To Suggest Changes To Repositories

<figure>
 <a href="{{ site.url }}/images/earth-analytics/git-version-control/github-submit-pull-request-demo.gif">
 <img src="{{ site.url }}/images/earth-analytics/git-version-control/github-submit-pull-request-demo.gif" alt="Short animated gif showing the steps involved with creating a pull request. When you setup your pull request, remember to ensure that the base is the repository that you wish to ADD change to. Your fork (or a branch) is where the changes currently exist (i.e. the head). When creating a new pull request, you should always check that the changes in your PR are the ones that you wish to submit. It's also good practice to ping or @mention a collaborator who you want to review and merge the PR if you know who that will be."></a>
 <figcaption>When you setup your pull request, remember to ensure that the base is the repository that you wish to ADD change to. Your fork (or a branch) is where the changes currently exist (i.e. the head). When creating a new pull request, you should always check that the changes in your PR are the ones that you wish to submit. It's also good practice to ping or @mention a collaborator who you want to review and merge the PR if you know who that will be.
 </figcaption>
</figure>

### Step 1 - Start to Open Your Pull Request on GitHub

To start a PR, click the `New pull request` button on the main page of your forked repository.

<figure>
 <a href="{{ site.url }}/images/earth-analytics/git-version-control/github-create-new-pull-request.png">
 <img src="{{ site.url }}/images/earth-analytics/git-version-control/github-create-new-pull-request.png" alt="Location of the New pull request button on the main page of an example repository for jenp0277."></a>
 <figcaption> Location of the new pull request button on the main page of an example forked repository.
 </figcaption>
</figure>

<i class="fa fa-star"></i> **Data Tip:** There are many different ways to submit a pull request. You can also click the “Pull Requests” tab at the top of the main page of a repository to submit a pull request (PR). When the pull request page opens, click the “New pull request” button to initiate a PR. You can also click on the PR button in the repository that you are submitting changes to!
{: .notice--success}


### Step 2 - Select Repository That You Want to Update on GitHub

In this example, you are updating another repository with changes from your fork. 

Next, select both the repo that you wish to update (the base repo) and the
repo that contains the content that you wish to use to update the base
(the head repo).

In this example, you want to update:

* **base**: `your-colleagues-username/project-name` with
* **head**: commits in your fork `your-username/project-name`.

The above pull request configuration tells **GitHub** to update the base repository with contents from your forked repository, or the head repository.

### Step 3 - Verify The Changes In Your Pull Request

When you compare two repos in a pull request page, **GitHub** provides an overview of the differences (diffs) between the files. 

Carefully review these changes to
ensure that the changes that you are submitting are in fact the ones that you
want to submit.

1. First, look at the number of files. How many files did you modify? Do you see that many files listed in the **PR**?
2. Look over the changes made to each file. Do the changes all look correct (like
     changes that you committed to the repository)?

 <figure>
  <a href="{{ site.url }}/images/earth-analytics/git-version-control/github-pr-changes.png">
  <img src="{{ site.url }}/images/earth-analytics/git-version-control/github-pr-changes.png" alt="When you first create a PR, be sure to check the PR contents. Notice in this image that the number of files and number of commits are displayed. Make sure these numbers make sense based upon the changes that you made."></a>
  <figcaption>When you first create a PR, be sure to check the PR contents. Notice in this image that the number of files and number of commits are displayed. Make sure these numbers make sense based upon the changes that you made.
  </figcaption>
 </figure>

<i class="fa fa-star"></i> **Data Tip:** You can also click on the commit titles to see the specific changes in each commit. This is another way to check that the contents of a PR are what you expect them to be.
{: .notice--success}

This review of your own **PR** before submitting it is important. Remember that someone
else is going to take time to review your PR. 

Make sure that you take care of
cleaning up what you can FIRST, before submitting the PR.


### Step 4 - Click on the Create New Pull Request Button

The next step of the create PR process is to click the "Create Pull Request" button. Note that this button will NOT be available if you have not made changes in your repo (e.g. fork). 

Click the green “Create Pull Request” button to start your pull request. Once you do that, a title box and description box will be visible.

Add a title and write a brief description of your changes. When you have added your
title and description, click on “Create Pull Request”.

<i class="fa fa-star"></i> **Data Tip:** You can modify the title and description of your pull request at any time - even after you've submitted the pull request!
{: .notice--success}

<figure>
 <a href="{{ site.url }}/images/earth-analytics/git-version-control/github-create-pull-request.png">
 <img src="{{ site.url }}/images/earth-analytics/git-version-control/github-create-pull-request.png" alt="Pull request titles should be concise and descriptive of the content in the pull request. More detailed notes can be left in the comments box."></a>
 <figcaption> Pull request titles should be concise and descriptive of the content in the pull request. More detailed notes can be left in the comments box.
 </figcaption>
</figure>


## Pull Requests and Your Location On GitHub

When you create a new pull request, you will be automatically transferred to the
**GitHub.com** URL or landing page for the base repository (your colleague's
repository). 

At this point, you have submitted your pull request!

At the bottom of your pull request, you may see an large green button that says
**Merge Pull Request**. This button will be used by owner of the
repository (your colleague or perhaps others working on this collaborative project)
to merge in your changes, when a review has been completed. 

The repo owner will
review your PR and may ask for changes. When they are happy with all of the changes, your PR could get merged!

<i class="fa fa-star"></i> **Data Tip:** All future commits that you make to your fork (on the branch where you are working) will continue to be added to the open pull request UNTIL it is merged.
{: .notice--success}

## How To Merge GitHub Pull Requests on GitHub

After you have submitted your PR, someone who owns or manages the repo where you
are submitting the PR will review it. At this point, they will either:

1. suggest that you make some changes to the PR or
2. merge the PR if they are happy with all of the changes that you made.

A screencast showing how this process works is below.

<figure>
 <a href="{{ site.url }}/images/earth-analytics/git-version-control/github-merge-pull-request.gif">
 <img src="{{ site.url }}/images/earth-analytics/git-version-control/github-merge-pull-request.gif" alt="Short animated gif showing the steps involved with merging a pull request. It's common for a reviewer to comment on your pull request and request changes. Once the reviewer is happy with the PR, they will merge it using the merge button on the bottom of the PR. It is important to note that you can only merge a PR in a repo in which you have permissions to merge."></a>
 <figcaption>It's common for a reviewer to comment on your pull request and request changes. Once the reviewer is happy with the PR, they will merge it using the merge button on the bottom of the PR. It is important to note that you can only merge a PR in a repo in which you have permissions to merge.
 </figcaption>
</figure>


### How To Close Pull Requests on GitHub

You can also close a pull request on **GitHub** if you decide you are not
ready to submit your files from your forked repository to the original repository.

For example, the pull request you just created in this lesson can be closed anytime before it is merged. 

When you are ready to submit changes,
you can simply create a new pull request on **GitHub** following these same steps.

To close a pull request, click on `Close pull request` button towards the
bottom of the pull request page.

<figure>
 <a href="{{ site.url }}/images/earth-analytics/git-version-control/github-close-pull-request.png">
 <img src="{{ site.url }}/images/earth-analytics/git-version-control/github-close-pull-request.png" alt="Location of the Close pull request button on an example pull request from jenp0277 to earthlab-education."></a>
 <figcaption> Location of the Close pull request button on an example pull request page from jenp0277 to earthlab-education.
 </figcaption>
</figure>

