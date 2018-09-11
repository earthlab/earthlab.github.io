---
layout: single
title: 'Guided Activity on Version Control with Git/GitHub'
excerpt: "This lesson teaches you how to implement version control using Git and GitHub."
authors: ['Jenny Palomino', 'Max Joseph', 'Leah Wasser']
category: [courses]
class-lesson: ['git-github-version-control']
permalink: /courses/earth-analytics-bootcamp/git-github-version-control/guided-activity-version-control/
nav-title: "Guided Activity on Version Control with Git/GitHub"
dateCreated: 2018-07-25
modified: 2018-09-10
odule-type: 'class'
class-order: 2
course: "earth-analytics-bootcamp"
week: 3
sidebar:
  nav:
author_profile: false
comments: true
order: 4
topics:
  reproducible-science-and-programming: ['git']
---
{% include toc title="In This Lesson" icon="file-text" %}

In this lesson, you will learn how to implement version control using `Git` and `GitHub`.

<div class='notice--success' markdown="1">

## <i class="fa fa-graduation-cap" aria-hidden="true"></i> Learning Objectives

After completing this lesson, you will be able to:

* Explain how `Git` and `GitHub` are used to implement version control
* Use `Git` to `add` and `commit` changed files 
* Use `Git` to `push` changed files from your local computer to the repository on `Github.com`

## <i class="fa fa-check-square-o fa-2" aria-hidden="true"></i> What You Need

Before completing this lesson and the challenges, be sure that you have forked and cloned the repository for Homework 1. If you have not, first complete the challenge posted at the bottom of the lesson on <a href="{{ site.url }}/courses/earth-analytics-bootcamp/get-started-with-open-science/get-files-from-github/">Get Files From GitHub.</a>

Be sure that you have also completed the lesson on <a href="{{ site.url }}/courses/earth-analytics-bootcamp/git-github-version-control/manage-jupyter-notebooks/">Manage Jupyter Notebook Files</a> and <a href="{{ site.url }}/courses/earth-analytics-bootcamp/git-github-version-control/markdown-jupyter-notebook/">Markdown in Jupyter Notebook</a>.

You will also need a web browser and your `Github.com` login (username and password). 

</div>


## Git and GitHub Workflow For Version Control

In the lesson on getting files from GitHub, you learned how to `fork` and `clone` existing `GitHub` repositories to make copies of other users' repositories and download them to your computer. 

In this lesson, you expand on those skills to:

* check the `status` of changed files in a repository
* `add` changed files to version control tracking
* `commit` the changed files to your local repository
* `push` those changed files from the local copy of a repository to the cloud (`Github.com`)

In later lessons, you will expand on this version control workflow to notify others (your collaborators) about changes you have made and that you would like to add to the original (`master`) copy of a repository.  

## Configure `Git` Settings On Your Computer:

1. In the terminal, set your `Github.com` username by typing: `git config --global user.name "Your UserName"`.

2. In the terminal, set the email for your `Github.com` account by typing: `git config --global user.email "youremail@email.com"`.

Note that you only have to configure these settings once on your computer. You can check your config settings for user.name and user.email using the following commands:

`git config user.name` or `git config user.email`


## Make Changes to Files and Directories

Begin by using Shell to navigate to your forked repository (the `ea-bootcamp-hw-1-yourusername` directory) and launching Jupyter Notebook. 

Open the `Jupyter Notebook` file for Homework 1 (`ea-bootcamp-hw-1.ipynb`) and make some changes.

* If you previously started working on Homework 1 or complete the optional challenge from the previous lesson on `Markdown`, then you already have some changes that can be added to version control and pushed to `GitHub`.   
    
* If you have not modified Homework 1, you can make a simple change in `Jupyter Notebook` to add a new `Markdown` cell below the existing cells and include:
    * A title for the notebook (e.g. `Earth Analytics Bootcamp - Homework 1`)
    * A **bullet list** with:
        * A bold word for `Author:` and then add text for your name. 
        * A bold word for `Date:` and then add text for today's date.
     

## Check the Status of Changes

In the `terminal`, navigate to your `ea-bootcamp-hw-1-yourusername` repository that you forked and cloned to your computer. 

Run the command `git status` to check that changes have been made to your files that have not been pushed back to `GitHub`. 

```bash
git status
On branch master
Your branch is up-to-date with 'origin/master'.
Changes not staged for commit:
  (use "git add <file>..." to update what will be committed)
  (use "git checkout -- <file>..." to discard changes in working directory)

	modified:   ea-bootcamp-hw-1.ipynb
    
no changes added to commit (use "git add" and/or "git commit -a")
```

The output from `git status` indicates that you have modified the file `ea-bootcamp-hw-1.ipynb`.

To keep track of changes to this file, you need to:

1. `add` the changes, and then
2. `commit` the changes.


## Add and Commit Changed Files

You will use the add and commit functions to `add` and `commit` your changed files.

* `git add`: takes a modified file in your working directory and places the modified version in a staging area.

* `git commit`: takes everything from the staging area and makes a permanent snapshot of the current state of your repository that is associated with a unique identifier.

These two commands make up the bulk of many workflows that use git for version control.

<figure>
   <a href="https://www.earthdatascience.org/images/workshops/version-control/git-add-commit.png">
   <img src="https://www.earthdatascience.org/images/workshops/version-control/git-add-commit.png" alt="Modified files are staged using git add, and following a commit, all files in the staging area are snapshotted and become part of the repository's history, receiving a unique SHA-1 hash identifier. Source: Max Joseph, adapted from Pro Git by Chacon and Straub (2014)."></a>
   <figcaption> Modified files are staged using git add, and following a commit, all files in the staging area are snapshotted and become part of the repository's history, receiving a unique SHA-1 hash identifier. Source: Max Joseph, adapted from Pro Git by Chacon and Straub (2014).
   </figcaption>
</figure>

### Add Files

You can add an individual file or groups of files to git tracking. To add a single file, use: 

`git add file-name.extension`.

For example, to add the `ea-bootcamp-hw-1.ipynb` file that you just modified, you’d use: 

`git add ea-bootcamp-hw-1.ipynb`.

You can also add all of the files that you have edited at the same time using: 

`git add .`

However, **use `git add .` with caution**. Be sure to review the results from `git status` carefully before using `git add .`. You do not want to accidentally add files that you do not want to change in the `GitHub` repository. 


### Commit Files

Once you are ready to make a snapshot of the current state of your repository, you can use `git commit`. 

The `git commit` command requires a commit message that describes the snapshot (i.e. changes) that you made in that commit. A commit message should outline what changed and why. These messages:

1. help collaborators and your future self understand what was changed and why
2. allow you and your collaborators to find (and undo if necessary) changes that were previously made.

Since you are not committing a lot of changes, you can create a short one line commit message using the -m flag:

`git commit -m "Update title and author name in homework 1"`

You will learn about including longer commit messages later in this course.


## Push Changed Files to GitHub

So far we have only modified our local copy of the repository. To update the files in your `GitHub` repository, you need to `push` the changed files to `GitHub`.

You can push your changes to `GitHub` with:

`git push origin master`

You will then be prompted for your `Github.com` username and password. 

After you have pushed your commits, visit your repository on `https://github.com/yourusername/ea-bootcamp-hw-1-yourusername` and notice that your changes are reflected there. Also notice that you have access to the full commit history for your repository!

<div class="notice--warning" markdown="1">

## <i class="fa fa-pencil-square-o" aria-hidden="true"></i> Optional Challenge 1

Rename your Homework 1 file and update it on `GitHub`!

1. Practice your `Jupyter Notebook` skills  to rename your `Jupyter Notebook` file for Homework 1 (`ea-bootcamp-hw-1.ipynb`) by adding your first initial and last name to the filename (e.g. `jpalomino-ea-bootcamp-hw-1.ipynb`).

2. Use your new `Git` skills to `add` and `commit` the changes and then `push` the changes to your `ea-bootcamp-hw-1-yourusername` repository on `GitHub`. 

3. Visit your repository on `Github.com` and see your change! What happened to the original file `ea-bootcamp-hw-1.ipynb`?

</div>
