---
layout: single
title: 'Get Files From GitHub'
excerpt: "GitHub can be used to store and access files. Learn how to create a copy of files on Github (forking) and to use the Terminal to download the copy to your computer (cloning). You will also learn how to to update your forked repository with changes made in the original Github repository."
authors: ['Jenny Palomino', 'Leah Wasser', 'Martha Morrissey',  'Software Carpentry']
category: [courses]
class-lesson: ['get-started-with-open-science']
permalink: /courses/earth-analytics-bootcamp/get-started-with-open-science/get-files-from-github/
nav-title: "Get Files From GitHub"
dateCreated: 2018-06-27
modified: 2020-02-05
module-type: 'class'
class-order: 1
course: "earth-analytics-bootcamp"
week: 1
sidebar:
  nav:
author_profile: false
comments: true
order: 3
topics:
  reproducible-science-and-programming: ['shell', 'git']
---
{% include toc title="In This Lesson" icon="file-text" %}

In this lesson, you will learn how to create a copy of other users' files on `Github.com` (i.e. forking) and to use the `Terminal` to download the copy to your computer (i.e. cloning). You will learn how to to update your forked repository with changes made in the original `Github` repository (i.e. pulling)

<div class='notice--success' markdown="1">

## <i class="fa fa-graduation-cap" aria-hidden="true"></i> Learning Objectives

After completing this lesson, you will be able to:

* Explain how `Github.com` and `Git` use repositories to store and manage files.
* Create a copy of (i.e. `fork`) other users' files on `Github.com`. 
* Use the `Git clone` command to download your copy of files to your computer. 
* Update your forked repository with changes made in the original `Github`repository (i.e. `git pull`).

 
## <i class="fa fa-check-square-o fa-2" aria-hidden="true"></i> What You Need

Be sure that you have completed the instructions on <a href="{{ site.url }}/workshops/setup-earth-analytics-python/setup-git-bash-anaconda/">Setting up Git, Bash, and Anaconda on your computer</a> to install the tools for your operating system (Windows, Mac, Linux). 

Be sure that you have completed the previous lesson on <a href="{{ site.url }}/courses/earth-analytics-bootcamp/get-started-with-open-science/intro-shell/">Intro to Shell.</a>

You will also need a web browser and your `Github.com` login (username and password). 
 
 </div>


## About Git & GitHub

In the lesson on Open Reproducible Science, you learned that `Git` is tool that is used to track changes in files (a process called version control) through a suite of commands that you can execute in the `Terminal`. You also learned that `GitHub` is the cloud-based version of `Git`, which can be used to store files in the cloud to access them from any computer and to share them with others.  

`Git` and `GitHub` use repositories (i.e. directories of files stored on `Github.com`) to manage and store files. 

<i class="fa fa-star"></i> **Data Tip:** A `GitHub` repository is a directory of files and folders that is hosted on `Github.com`.  
{: .notice--success}

`GitHub` allows you to store a set of files as Github repositories in the cloud (on the `GitHub` servers) and to work with these repositories locally on your computer using `Git` commands in the `Terminal`. 

Having a copy of a set of files as repositories in the cloud is ideal because:

1. There is a backup: If something happens to your computer, the files are still available online
2. You can share the files with other people easily
3. You can even create a Digital Object Identifier (DOI) using third party tools like Zenodo to cite your files or ask others to cite your files. You can also add these DOIs to your resume or C.V. to promote your work. 


## Forking and Cloning Repositories

In this lesson, you will learn how to make a copy of an existing repository created by another user or organization (a task referred to as `forking` repositories) and to download your copy of the repository to your computer (a task referred to as `cloning` repositories). 

The ability to `fork` a repository is a great benefit of using `GitHub` repositories because the forked repository is linked to the original. This means that you can download new updates from original to your forked repository as well as suggest changes to the original repository, which can be reviewed by the owner of that repository. 

Cloning a repository to your computer is a great way to work on your files locally, while still having a copy of your files on the cloud on `Github.com`.

Throughout the course, you will learn more about the functionality provided by `GitHub` and `Git`. In this lesson, you will first `fork` an existing repository on `Github.com` to make a copy for yourself, and then run the `git clone` command from the `Terminal` to download your copy of the repository to your computer.  
   

## Create a Copy of Other Users' Files on Github.com (Forking)

The URL link to a `GitHub` repository always follows the same format: `https://github.com/username/repositoryname`. 

You can `fork` an existing `Github` repository from the main `Github.com` page of the repository that you want to copy (example: `https://github.com/earthlab-education/example-repository`).

On the main `Github.com` page of the repository, you will see a button on the top right that says `Fork`. The number next to `Fork` tells the number of times that the repository has been copied or forked.

Click on the `Fork` button and select your `Github.com` account as the home of the forked repository. 

<figure>
 <a href="{{ site.url }}/images/earth-analytics/git-version-control/git-fork-repo.gif">
 <img src="{{ site.url }}/images/earth-analytics/git-version-control/git-fork-repo.gif" alt="You can create a copy of repositories created by other users on Github by forking their repository to your Github account."></a>
 <figcaption> You can create a copy of repositories created by other users on Github by forking their repository to your Github account. 
 </figcaption>
</figure>



## Copy Files From Github.com to Your Local Computer (`git clone`)

Now that you have made a copy (or forked) the desired repository, you will use the `git clone` command to download the forked repository (i.e. your copy of a `GitHub` repository) from `Github.com` onto your computer. 


### Use `Bash` to Change to Your Desired Working Directory

The first step to using any `Git` command is to change the current working directory to your desired directory.

In the case of `git clone`, the current working directory needs to be where you want to download your local copy of a `GitHub` repository. You will use the `earth-analytics-bootcamp` directory that you created under your home directory in the previous lesson.

```bash
$ cd ~
$ cd earth-analytics-bootcamp
$ pwd
    /users/jpalomino/earth-analytics-bootcamp
```

### Copy a Github.com Repository URL From Github.com

Because you forked `example-repository`, your `Github.com` account now contains a copy of it, which you can access on `https://github.com/your-username/example-repository`. 

On the main `Github.com` page of your forked repository, click on the green button for `Clone or download`, and copy the URL provided in the box, which will look like: `https://github.com/your-username/example-repository`. 

<figure>
 <a href="{{ site.url }}/images/earth-analytics/git-version-control/git-clone-repo.gif">
 <img src="{{ site.url }}/images/earth-analytics/git-version-control/git-clone-repo.gif" alt="You can make a local copy of your forked repository on your computer with the git clone command."></a>
 <figcaption> You can make a local copy of your forked repository on your computer with the git clone command. 
 </figcaption>
</figure>


Note: you do not have to use the `Clone or download` button to copy the URL. You can also copy it directly from your web browser or you might simply already know the URL. However, in many cases, you will have come across a `Github.com` repository on your own and will need to follow these instructions to copy the URL for future use.


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

## Update Your Repository on Github.com and Locally

When others make in the original repository, you can copy (i.e. pull) those changes to your fork of that repository and then you can copy those changes to the clone on your local computer. 

First, you need to create a pull request on `Github.com` to update your fork of the repository from the original repository, and then you need to run the `git pull` command in the Terminal to update your local clone. The following sections review how to complete these steps. 


### Update Your Forked Repo on Github.com

To update your fork on `Github.com`, navigate in your web browser to the main `Github.com` page of your forked repository: `https://github.com/your-username/example-repository`.

On this web page, create a pull request from the original repository by following these steps:
1. Click on the `New pull request` button to begin the pull request
2. On the new page, choose your fork as the **base fork** and the original repository (e.g. from earthlab-education) as the **head fork**.  This will indicate that the changed files are being requested by your fork (i.e. the base fork) from the original repository (i.e. the head fork). **You will need to click on the text `compare across forks` to be able to update both the base and head forks appropriately.** 
4. Then, click on `Create pull request`.
5. On the new page, click on `Create pull request` once more to finish creating the pull request. 

<figure>
 <a href="{{ site.url }}/images/earth-analytics/git-version-control/github-create-reverse-pull-request.gif">
 <img src="{{ site.url }}/images/earth-analytics/git-version-control/github-create-reverse-pull-request.gif" alt="You can update your fork with changes made to the original Github repository by creating a pull request from the original repository to your fork."></a>
 <figcaption> You can update your fork with changes made to the original Github repository by creating a pull request from the original repository to your fork. 
 </figcaption>
</figure>

After creating the pull request, you need to merge the pull request, so that the changes in the original repository are copied to your computer. 

You can simply click on the green button for `Merge pull request` and `Confirm merge`. Once you return to the main page of your fork, you will see the changes reflected. 

<figure>
 <a href="{{ site.url }}/images/earth-analytics/git-version-control/github-merge-reverse-pull-request.gif">
 <img src="{{ site.url }}/images/earth-analytics/git-version-control/github-merge-reverse-pull-request.gif" alt="After creating a pull request, you merge the pull request to apply the changes from the original repository to your fork."></a>
 <figcaption> After creating a pull request, you merge the pull request to apply the changes from the original repository to your fork. 
 </figcaption>
</figure>


### Update Your Local Clone 

To copy the updated files locally to your computer, you can use the Terminal. 

Run the following commands to navigate to the directory that contains your local clone and then to pull down the changes from your updated `Github` fork.

```bash
$ cd ~
$ cd earth-analytics-bootcamp
$ cd example-repository
$ git pull
```

Congratulations! You have now updated your local clone with the updates made to the original `Github` repository.


## Making Changes in Your Clone

In this lesson, you will not be modifying the files in the `Github` repository that you clone from `earthlab-education`. If you would like, you can copy/paste files that you want to modify and place them in the named folder that your instructor has designated for you (e.g. `place-your-modified-files-here`). 

Files in this designated folder will be ignored by `git`, so that they will not get overwritten when you download new changes to your local clone.

In future lessons, you will learn how to make changes to files in your local clone and then submit a request to update the original repository. 

<div class="notice--warning" markdown="1">

## <i class="fa fa-pencil-square-o" aria-hidden="true"></i> Optional Challenge 

Test your `Bash` and `Git`/`GitHub` skills to `fork`/`clone` the repository for Homework 1:

1. On Day 1 of the course, you will receive an email invitation to Homework 1 via `Github.com`.

2. Accept the invitation, which will create a new private repository that includes your `Github.com` username in the name of the repository: `https://github.com/earthlab-education/ea-bootcamp-hw-1-yourusername`.

3. `Fork` this repository to your `GitHub account`. Your forked repository will be available on `https://github.com/yourusername/ea-bootcamp-hw-1-yourusername`.

4. Clone your forked repository `ea-bootcamp-hw-1-yourusername` to the `earth-analytics-bootcamp` directory on your computer (hint: `cd`, `git clone`).

5. Check that `ea-bootcamp-hw-1-yourusername` has been successfully cloned to your computer (hint: `ls`).

What other directories are present in the `earth-analytics-bootcamp` directory?

</div>

