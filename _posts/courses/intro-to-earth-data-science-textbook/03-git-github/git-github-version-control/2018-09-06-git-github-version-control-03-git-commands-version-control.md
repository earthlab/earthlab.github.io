---
layout: single
title: 'Git Commands for Version Control'
excerpt: "A version control system allows you to track and manage changes to your files. Learn how to get started with version control using Git."
authors: ['Jenny Palomino', 'Max Joseph', 'Leah Wasser']
category: [courses]
class-lesson: ['version-control-git-github']
permalink: /courses/intro-to-earth-data-science/git-github/version-control/git-commands/
nav-title: "Git Commands for Version Control"
dateCreated: 2019-09-06
modified: 2019-09-23
module-type: 'class'
course: "intro-to-earth-data-science-textbook"
week: 3
sidebar:
  nav:
author_profile: false
comments: true
order: 3
topics:
  reproducible-science-and-programming: ['git']
redirect_from:
  - "/courses/earth-analytics-bootcamp/git-github-version-control/guided-activity-version-control/"
---

{% include toc title="On This Page" icon="file-text" %}

<div class='notice--success' markdown="1">

## <i class="fa fa-graduation-cap" aria-hidden="true"></i> Learning Objectives

After completing this page, you will be able to:

* Use **git** to `add` and `commit` changed files to version control. 
* Use **git** to `push` changed files from your local computer to the repository on **Github.com**.

</div>


## Git and GitHub Workflow For Version Control

Previously, you learned how to `fork` **GitHub** repositories to make copies of other users' repositories, and you also learned how to download copies of (i.e. `clone`) **GitHub** repositories to your computer. 

On this page, you expand on those skills to use **git** to implement the three key steps of version control:
* `git add` changed files to version control tracking.
* `git commit` the changed files to create a unique snapshot of the local repository.
* `git push` those changed files from the local copy of a repository to the cloud (**GitHub.com**).



## Configure git Settings On Your Computer

The first time that you use **git**, you will need to configure a few settings including the username and email address that you want to be associated with the changes that you make using **git**. 

You can set your **Github.com** username in the **terminal** by typing: 
 
`git config --global user.name "username"`.

Next, you can set the email for your **Github.com** account by typing: 

`git config --global user.email "email@email.com"`.

Using the `--global` configuration option, you are telling **git** to use these settings for all **git** repositories that you work with on your computer. 

Note that you only have to configure these settings once on your computer.  

You can check your config settings for user.name and user.email using the following commands:

`git config user.name` which returns the username that you set previously

`git config user.email` which returns the email that you set previously

These configuration settings ensure that changes you make to repositories are attributed to your username and email, so that you can easily track changes over time. 

## Check the Status of Changes Using Git Status

Once you start making changes to files in the repository, you can use the `git status` command to check what changes are being identified by **git**. 

To practice working with this command, use the **terminal** to navigate to a repository that you have cloned to your computer (e.g. `cd ea-bootcamp-03-git-github-version-control`). 

Make some change to a file in this repository (e.g. open a **Jupyter Notebook** file and add a new Code cell).

Then, run the command `git status` to check that changes have been made to your file(s). 

```bash
git status
On branch master
Your branch is up-to-date with 'origin/master'.
Changes not staged for commit:
  (use "git add <file>..." to update what will be committed)
  (use "git checkout -- <file>..." to discard changes in working directory)

	modified:   ea-bootcamp-03-git-github-version-control.ipynb
    
no changes added to commit (use "git add" and/or "git commit -a")
```

The output from the `git status` command indicates that you have modified a file (e.g. `ea-bootcamp-03-git-github-version-control.ipynb`) that can be added to version control if desired.


### Overview of Adding and Committing Changes To Version Control

To keep track of changes to this file using **git**, you need to:

1. first `git add` the changes to tracking (or staging area), and then
2. `git commit` the changes to version control. 

These two commands make up the bulk of many workflows that use **git** for version control:

* `git add`: takes a modified file in your working directory and places the modified version in a staging area for review.

* `git commit`: takes everything from the staging area and makes a permanent snapshot of the current state of your repository that has a unique identifier.



<figure>
   <a href="{{ site.url }}/images/earth-analytics/git-version-control/git-add-commit.png">
   <img src="{{ site.url }}/images/earth-analytics/git-version-control/git-add-commit.png" alt="Modified files are staged using git add. Then, following git commit, all files in the staging area are included in snapshot and become part of the repository's history, receiving a unique SHA-1 hash identifier. Source: Max Joseph, adapted from Pro Git by Chacon and Straub (2014)."></a>
   <figcaption> Modified files are staged using git add. Then, following git commit, all files in the staging area are included in snapshot and become part of the repository's history, receiving a unique SHA-1 hash identifier. Source: Max Joseph, adapted from Pro Git by Chacon and Straub (2014).
   </figcaption>
</figure>

## Add Changed Files Using git add

After making changes, you can add either an individual file or groups of files to version control tracking. 

To add a single file, run the command: 

`git add file-name.extension`

For example, to add the `ea-bootcamp-03-git-github-version-control.ipynb` file, you would use: 

`git add ea-bootcamp-03-git-github-version-control.ipynb`

You can also add all of the files that you have edited at the same time using: 

`git add .`

However, **use `git add .` with caution**. Be sure to review the results from `git status` carefully before using `git add .`. You do not want to accidentally add files that you do not want to change in the **GitHub** repository. 


## Commit Changed Files Using git commit

Once you are ready to make a snapshot of the current state of your repository (i.e. move changes from staging area), you can run `git commit`. 

The `git commit` command requires a commit message that describes the snapshot (i.e. changes) that you made in that commit. 

A commit message should outline what changed and why. These messages:

1. help collaborators and your future self understand what was changed and why.
2. allow you and your collaborators to find (and undo if necessary) changes that were previously made.

When you are not committing a lot of changes, you can create a short one line commit message using the -m flag as follows:

`git commit -m "Update title and author name in homework for week 3"`

You will learn about including longer commit messages later in this textbook.

Each commit is provided a unique identifier (SHA-1 hash) and includes all changes to files in the staging area when the commit was created (i.e. all files that had been added to staging using `git add`). 

## Push Changed Files to GitHub.com

So far you have only modified your local copy of the repository and completed a local commit to the repository. 

To update the files on **GitHub.com**, you need to `push` the changed files to the repository on **GitHub.com**.

You can push your changes to **GitHub** using the command:

`git push origin master`

Depending on your settings, you may then be prompted for your **Github.com** username and password. 

After you have pushed your commits to **GitHub.com**, visit your repository (e.g. `https://github.com/username/repository-name`) and notice that your changes are reflected there. 

Also notice that you have access to the full commit history for your repository!

<figure>
   <a href="{{ site.url }}/images/earth-analytics/git-version-control/access-commits-on-github.png">
   <img src="{{ site.url }}/images/earth-analytics/git-version-control/access-commits-on-github.png" alt="On the GitHub page of a repository, you can click on the Commits option (as shown in the image) to see a full list of commits that have been pushed to a repository."></a>
   <figcaption> On the GitHub page of a repository, you can click on the Commits option (as shown in the image) to see a full list of commits that have been pushed to a repository.
   </figcaption>
</figure>

<figure>
   <a href="{{ site.url }}/images/earth-analytics/git-version-control/list-commits-github.png">
   <img src="{{ site.url }}/images/earth-analytics/git-version-control/list-commits-github.png" alt="The full list of commits that have been pushed to a repository are available for you to see and review as needed on GitHub.com."></a>
   <figcaption> The full list of commits that have been pushed to a repository are available for you to see and review as needed on GitHub.com.
   </figcaption>
</figure>


## View All Commits to Repository Using git log

You can also see a list of all commits to a repository (even those that have yet not been pushed to **GitHub.com**!) when working locally with the repository on your computer. 

To see a list of all commits, you can run the command:

`git log`

Which returns something like the following:

```bash
commit 6575476476hdjig946jksg95jywkg034mk6gkro6
Author: eastudent <eastudent@email.edu>
Date:   Mon Aug 5 15:30:54 2019 -0600

    Update title and author name in homework for week 3
```

Notice that `git log` provides a lot of useful information about the commit, including the unique identifier assigned to that snapshot, the message description provided during the commit (i.e. the message after `-m`) as well as the date, time, and author of the commit. 


## Tell Git to Ignore Sensitive Files

If you have sensitive files in a repository that you never want to track with **git**, you can add those file names to a file called `.gitignore`, and **git** will not track them. 

For instance, if you have a text file called `social-security.txt` that contains sensitive information, you can add that file to a .gitignore file. 

Once listed in .gitignore, **git** will never add that file to version control or send it to **GitHub.com**.

If the .gitignore file is not already present in the repository, you can create it manually using a text , or using the following `bash` command:

```bash
# Comment in bash
# Create a .gitignore file if one doesn't already exist 
touch .gitignore

```

Open this .gitignore file in a text editor and add the file names (with no other information needed) that you want **git** to ignore, for example:

```
social-security.txt
```

Any files listed in the `.gitignore` file will be ignored by **git**. 

You can also tell **git** to ignore directories by adding the directory name to the `gitignore` file (e.g. ignore a directory called `private-directory`):

```
private-directory/
```

<i class="fa fa-star"></i> **Data tip:** Learn more about using .gitignore files to ignore files and directories in your **git** repository on the <a href="http://swcarpentry.github.io/git-novice/06-ignore/
" target="_blank">Software Carpentry Git Lessons</a>.
{: .notice--success }

