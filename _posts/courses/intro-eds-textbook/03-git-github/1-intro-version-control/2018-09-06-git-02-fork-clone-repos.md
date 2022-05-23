---
layout: single
title: 'Copy (Fork) and Download (Clone) GitHub Repositories'
excerpt: "GitHub.com can be used to store and access files in the cloud to share with others or simply as a backup of your local files. Learn how to create a copy of files on GitHub (fork) and to download files from GitHub to your computer (clone)."
authors: ['Jenny Palomino', 'Leah Wasser', 'Martha Morrissey']
category: [courses]
class-lesson: ['version-control-git-github']
permalink: /courses/intro-to-earth-data-science/git-github/version-control/fork-clone-github-repositories/
nav-title: "Get Files From GitHub"
dateCreated: 2019-09-06
modified: 2021-03-30
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
  - "/courses/earth-analytics-bootcamp/get-started-with-open-science/get-files-from-github/"
---

{% include toc title="On This Page" icon="file-text" %}

<div class='notice--success' markdown="1">

## <i class="fa fa-graduation-cap" aria-hidden="true"></i> Learning Objectives

After completing this page, you will be able to:

* Explain how a **GitHub** repository stores and tracks changes to files.
* Create a copy of (i.e. `fork`) other users' files on **GitHub.com** .
* Use the `git clone` command to download a copy of a **GitHub** repository to your computer. 


 </div>


## About Git and GitHub

Previously in this textbook, you learned that **git** is tool that is used to track changes in files (a process called version control) through a suite of commands that you can execute in the **Terminal**. You also learned that **GitHub** allows you to store files in the cloud to access them from any computer and to share them with others. 

You can use **git** and **GitHub** together in a workflow to make changes to files locally with **git** and to store and share your files on **GitHub.com**. To work together, **git** and **GitHub** use repositories (i.e. directories of files) to manage and store files. 

<i class="fa fa-star"></i> **Data Tip:** A **GitHub** repository is a directory of files and folders that is hosted on **GitHub.com**.  
{: .notice--success}

Having a copy of a set of files stored in **GitHub** repositories in the cloud is ideal because:
1. There is a backup: If something happens to your computer, the files are still available online.
2. You can share the files with other people easily.
3. You can even create a Digital Object Identifier (DOI) using third party tools like Zenodo to cite your files or ask others to cite your files. You can also add these DOIs to your resume or C.V. to promote your work. 

## Directory Structure of Repositories

In essence, a repository is a directory for a specific project that is identified as a repository by **git** and **GitHub** because it contains a subdirectory called `.git`. 

The `.git` subdirectory is created automatically, either by **GitHub** if it is created on **GitHub.com** or by **git** if the repository is created locally on a computer first (i.e. initialized as a repository). This `.git` subdirectory is used by these tools to manage and track the various tasks that are run on this directory (e.g. tracking changes to files in the repository). Thus, **you never need to access or modify the files in the `.git` subdirectory.**

A typical repository (e.g. `project-name`) is structured as follows:

```bash
project-name
    .git/
    data/
    scripts/
    .gitignore
    README.md
```

In addition to the `.git` subdirectory, it is common to have subdirectories for specific files of a workflow such  as data or scripts. A few common files in most if not all git repos are:

1. **`README.md` file:** This is a Markdown file that is used to provide a description of the repository (i.e. its contents, purpose, etc), so that others can learn how to use the files in the repository. 
2. **`.gitignore` file:** This file can be used to list the files that you do not want **git** to track (i.e. monitor via version control). You will learn more about both of these useful files later in this chapter. 


## URL of Repositories on GitHub.com

When a repository is stored on **GitHub.com**, it is assigned a unique URL (i.e. link on the **GitHub.com** website) that can be used to find the repository and access its files. While repositories on **GitHub.com** can be made either public or private, the default is public for free **GitHub** accounts.

In either case (public or private), the URL links to a **GitHub** repository always follows the same format: 

`https://github.com/username/repository-name`

The username is the username of the creator (i.e. owner) of the repository. The username can either be an individual such as `eastudent` (or your **GitHub** username!), or it can represent an organization such as `earthlab-education`.

For example, the repositories that you will work with throughout this textbook will be owned by `earthlab-education`, and thus, will have URLs that look like this:

`https://github.com/earthlab-education/repository-name`


## Create a Copy of Other Users' Files on GitHub.com (Fork a Repo)

Using **GitHub.com**, you can make a copy of a **GitHub** repository (also known as a **repo**) owned by another user or organization (a task referred to as `forking` a repository). This means that **you do not have to fork a repository that you already own**. Instead, other users can fork your repository if they would like a copy to work with, and your original files will not be modified! 

The ability to `fork` a repository is a benefit of using **GitHub** repositories because the forked repository is linked to the original. This means that you (or other users) can update the files in your fork from the original to your (or their) forked repository. It also means that you can suggest changes to the original repository, which can be reviewed by the owner of that repository. Thus, forking allows you to collaborate with others while protecting the original versions of files. When collaborating, everyone will work with copies of the original files. And all changes are tracked in each file's history and can be undone at any time. 

You can `fork` an existing **GitHub** repository from the main **GitHub.com** page of the repository that you want to copy.

To fork a repo:

1. Navigate to the repo page that you wish to fork - example:

`https://github.com/earthlab-education/practice-git-skillz`

2. On that page, you will see a button in the UPPER RIGHT hand corner that says `Fork`. The number next to that button tells you how many times the repo has already been forked. 
3. Click on the `Fork` button and select your user account when it asks you where you want to fork the repo. 
4. Once you have forked the repo, you will have a copy of it in your account. Navigate to your repo page. The url should look something like this:

`https://github.com/your-user-name/practice-git-skillz`


<figure>
 <a href="{{ site.url }}/images/earth-analytics/git-version-control/github-fork-repo.gif">
 <img src="{{ site.url }}/images/earth-analytics/git-version-control/github-fork-repo.gif" alt="You can create a copy of repositories created by other users on Github by forking their repository to your Github account."></a>
 <figcaption> To fork a repo, first navigate to the repo you want to fork. Then click the **fork** button in the upper right hand corner of your screen. You can then create a copy of of this repo in your account.
 </figcaption>
</figure>


Later in this textbook, you will learn how to suggest changes to the original repository, receive updates from the original repository to your fork, and collaborate with others. 


## Copy Files From GitHub.com to Your Computer (`git clone`)

To work locally with a **GitHub** repository (including forked repos), you need to create a local copy of that repository on your computer (a task referred to as `cloning` a repo). You can clone **GitHub** repositories that you own or that are owned by others (e.g. repositories that you have forked to your **GitHub** account).

In either case, cloning allows you to create a local copy of a **GitHub** repository, so that you can work with the files locally on your computer. Cloning a repository to your computer is a great way to work on your files locally, while still having a copy of your files on the cloud on **GitHub.com**. Following the steps below, you will use the `git clone` command in the **terminal** to clone **GitHub** repositories. 


### Use `Bash` to Change to Your Desired Working Directory

The first step to using any **git** command is to change the current working directory to your desired directory.
In the case of `git clone`, the current working directory needs to be where you want to download a local copy of a **GitHub** repository. 

For this textbook, you will clone a repo into a directory called `earth-analytics` on your computer (or wherever you are working. This `earth-analytics` directory should be located in the home directory of your computer.  

```bash
# This command with change your directory to home (`~`) /earth-analytics
# If the directory doesn't already exist you can make it using mkdir ~/earth-analytics
$ cd ~/earth-analytics
$ pwd
    /users/your-user-name/earth-analytics
```

### Copy a Github.com Repository URL From GitHub.com

To run the `git clone` command, you need the URL for the repository that you want to clone (i.e. either a repository owned by you or a fork that you created of another user's repository). 

On the main **GitHub.com** page of the repository, you can click on the green button for `Clone or download`, and copy the URL provided in the box, which will look like: 

`https://github.com/your-username/practice-git-skillz`


<figure>
 <a href="{{ site.url }}/images/earth-analytics/git-version-control/github-clone-repo.gif">
 <img src="{{ site.url }}/images/earth-analytics/git-version-control/github-clone-repo.gif" alt="You can make a local copy of your forked repository on your computer with the git clone command."></a>
 <figcaption> You can make a local copy of your forked repository on your computer with the git clone command. 
 </figcaption>
</figure>


<i class="fa fa-star"></i> **Data Tip:** You can also copy the URL directly from your web browser, or in some cases, you might already know the URL. However, in many cases, you will come across a new **GitHub.com** repository on your own and will need to follow these instructions to copy the URL for future use. 
{: .notice--success}


### Run the Git Clone Command in the Terminal

Now that you have the URL for a repository that you want to copy locally, you can use the **terminal** to run the `git clone` command followed by the URL that you copied: 

```bash
git clone https://github.com/your-username/practice-git-skillz
```

You have now made a local copy of a repository under your `earth-analytics` directory. You can double check that the directory exists using the `ls` command in the **terminal**. 

```bash
$ ls     
    practice-git-skillz
```

<div class="notice--warning" markdown="1">

## <i class="fa fa-pencil-square-o" aria-hidden="true"></i> Challenge  - Fork and Clone a Repository

Go to GitHub.com and login. Then use the link below to open the **practice-git-skillz** repo.

`https://github.com/earthlab-education/practice-git-skillz`

* On the main **GitHub.com** page of this repository, you will see a button on the top right that says `Fork`. The number next to `Fork` tells the number of times that the repository has been copied or forked.
* Click on the `Fork` button and select your **GitHub.com** account as the home of the forked repository. 
* Once you have forked a repository, you will have a copy (or a fork) of that repository in your **GitHub** account. The URL to your fork will contain your username:

`https://github.com/your-username/practice-git-skillz`

* Finally, clone the fork that you created above so you have a copy of all the files on github.com on your local computer. You may want to clone this repo into your **earth-anlaytics** directory if you are working through the complete Bootcamp course as a part of our Professional Certificate program. 

To make sure you did things right, in bash, cd to the practice-git-skillz directory on your computer. 
Type:

`$ git remote -v` 

The paths returned should look something like this:

`https://github.com/your-username/practice-git-skillz`


</div>







