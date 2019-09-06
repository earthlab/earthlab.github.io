---
layout: single
title: 'Copy (Fork) and Download (Clone) GitHub Repositories'
excerpt: "GitHub.com can be used to store and access files in the cloud to share with others or simply as a backup of your local files. Learn how to create a copy of files on GitHub (forking) and to download files from GitHub to your computer (cloning)."
authors: ['Jenny Palomino', 'Leah Wasser', 'Martha Morrissey']
category: [courses]
class-lesson: ['git-github-version-control']
permalink: /courses/intro-to-earth-data-science/git-github/version-control/fork-clone-github-repositories/
nav-title: "Get Files From GitHub"
dateCreated: 2019-09-06
modified: 2019-09-06
module-type: 'class'
class-order: 1
course: "intro-to-earth-data-science"
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

* Explain how **GitHub.com** and **git** use repositories to store and manage files
* Create a copy of (i.e. `fork`) other users' files on **GitHub.com** 
* Use the `Git clone` command to download your copy of files to your computer 
* Update your forked repository with changes made in the original **GitHub** repository (i.e. `git pull`)

 </div>


## About Git & GitHub

In the lesson on Open Reproducible Science, you learned that **git** is tool that is used to track changes in files (a process called version control) through a suite of commands that you can execute in the `Terminal`. You also learned that **GitHub** is the cloud-based version of **git**, which can be used to store files in the cloud to access them from any computer and to share them with others.  

**git** and **GitHub** use repositories (i.e. directories of files stored on **GitHub.com**) to manage and store files. 

<i class="fa fa-star"></i> **Data Tip:** A **GitHub** repository is a directory of files and folders that is hosted on **GitHub.com**.  
{: .notice--success}

**GitHub** allows you to store a set of files as Github repositories in the cloud (on the **GitHub** servers) and to work with these repositories locally on your computer using **git** commands in the `Terminal`. 

Having a copy of a set of files as repositories in the cloud is ideal because:

1. There is a backup: If something happens to your computer, the files are still available online
2. You can share the files with other people easily
3. You can even create a Digital Object Identifier (DOI) using third party tools like Zenodo to cite your files or ask others to cite your files. You can also add these DOIs to your resume or C.V. to promote your work. 


## Forking and Cloning Repositories

In this lesson, you will learn how to make a copy of an existing repository created by another user or organization (a task referred to as `forking` repositories) and to download your copy of the repository to your computer (a task referred to as `cloning` repositories). 

The ability to `fork` a repository is a great benefit of using **GitHub** repositories because the forked repository is linked to the original. This means that you can download new updates from original to your forked repository as well as suggest changes to the original repository, which can be reviewed by the owner of that repository. 

Cloning a repository to your computer is a great way to work on your files locally, while still having a copy of your files on the cloud on **GitHub.com**.

Throughout the course, you will learn more about the functionality provided by **GitHub** and **git**. In this lesson, you will first `fork` an existing repository on **GitHub.com** to make a copy for yourself, and then run the `git clone` command from the `Terminal` to download your copy of the repository to your computer.  
   

## Create a Copy of Other Users' Files on Github.com (Forking)

The URL link to a **GitHub** repository always follows the same format: `https://github.com/username/repositoryname`. 

You can `fork` an existing **GitHub** repository from the main **GitHub.com** page of the repository that you want to copy (example: `https://github.com/earthlab-education/example-repository`).

On the main **GitHub.com** page of the repository, you will see a button on the top right that says `Fork`. The number next to `Fork` tells the number of times that the repository has been copied or forked.

Click on the `Fork` button and select your **GitHub.com** account as the home of the forked repository. 

<figure>
 <a href="{{ site.url }}/images/courses/earth-analytics/git/git-fork-repo.gif">
 <img src="{{ site.url }}/images/courses/earth-analytics/git/git-fork-repo.gif" alt="You can create a copy of repositories created by other users on Github by forking their repository to your Github account."></a>
 <figcaption> You can create a copy of repositories created by other users on Github by forking their repository to your Github account. 
 </figcaption>
</figure>



## Copy Files From Github.com to Your Local Computer (`git clone`)

Now that you have made a copy (or forked) the desired repository, you will use the `git clone` command to download the forked repository (i.e. your copy of a **GitHub** repository) from **GitHub.com** onto your computer. 


### Use `Bash` to Change to Your Desired Working Directory

The first step to using any **git** command is to change the current working directory to your desired directory.

In the case of `git clone`, the current working directory needs to be where you want to download your local copy of a **GitHub** repository. You will use the `earth-analytics-bootcamp` directory that you created under your home directory in the previous lesson.

```bash
$ cd ~
$ cd earth-analytics-bootcamp
$ pwd
    /users/jpalomino/earth-analytics-bootcamp
```

### Copy a Github.com Repository URL From Github.com

Because you forked `example-repository`, your **GitHub.com** account now contains a copy of it, which you can access on `https://github.com/your-username/example-repository`. 

On the main **GitHub.com** page of your forked repository, click on the green button for `Clone or download`, and copy the URL provided in the box, which will look like: `https://github.com/your-username/example-repository`. 

<figure>
 <a href="{{ site.url }}/images/courses/earth-analytics/git/git-clone-repo.gif">
 <img src="{{ site.url }}/images/courses/earth-analytics/git/git-clone-repo.gif" alt="You can make a local copy of your forked repository on your computer with the git clone command."></a>
 <figcaption> You can make a local copy of your forked repository on your computer with the git clone command. 
 </figcaption>
</figure>

Note: you do not have to use the `Clone or download` button to copy the URL. You can also copy it directly from your web browser or you might simply already know the URL. However, in many cases, you will have come across a **GitHub.com** repository on your own and will need to follow these instructions to copy the URL for future use.


### Run the Git Clone Command in the Terminal

To download your forked copy of `example-repository` to your computer, be sure that you have changed to the correct working directory (see **Use `Bash` to Change to Your Desired Working Directory**). 

Then, run the command `git clone` followed by the URL that you copied in above as follows: 

```bash
git clone https://github.com/your-username/example-repository
```

You have now made a local copy of your forked repository under your `earth-analytics-bootcamp` directory. Double check that the directory exists using the `ls` command in terminal. 

```bash
$ ls     
    example-repository
```


## Need to add to page: 

* Reiterate that they do not need to fork repos that they own; add example
* Replace all mentions of "course" with "textbook"
* Change all examples from being about `earth-analytics-bootcamp` directory to `earth-analytics` directory.
