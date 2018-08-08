---
layout: single
title: 'Get Files From GitHub'
excerpt: "GitHub can be used to store and access files. Learn how to create a copy of files on GitHub (forking) and to use the Terminal to download the copy to your computer (cloning)."
authors: ['Jenny Palomino', 'Leah Wasser', 'Martha Morrissey',  'Software Carpentry']
category: [courses]
class-lesson: ['get-started-with-open-science']
permalink: /courses/earth-analytics-bootcamp/get-started-with-open-science/get-files-from-github/
nav-title: "Get Files From GitHub"
dateCreated: 2018-06-27
modified: 2018-08-08
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

In this lesson, you will learn how to create a copy of other users' files on `GitHub` (i.e. forking) and to use the `Terminal` to download the copy to your computer (i.e. cloning). 

<div class='notice--success' markdown="1">

## <i class="fa fa-graduation-cap" aria-hidden="true"></i> Learning Objectives

After completing this lesson, you will be able to:

* Explain how `GitHub` and `Git` use repositories to store and manage files
* Create a copy of (i.e. `fork`) other users' files on `Github.com` 
* Use the `Git clone` command to download your copy of files to your computer 

 
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

You can `fork` an existing `Github` repository from the main `Github.com` page of the repository that you want to copy (example: `https://github.com/earthlab-education/ea-bootcamp-day-1`).

On the main `Github.com` page of the repository, you will see a button on the top right that says `Fork`. The number next to `Fork` tells the number of times that the repository has been copied or forked.

Click on the `Fork` button and select your `Github.com` account as the home of the forked repository. 

<figure>
   <a href="https://help.github.com/assets/images/help/repository/fork_button.jpg">
   <img src="https://help.github.com/assets/images/help/repository/fork_button.jpg" alt="Fork an existing Github.com repository to make a copy of other users' files. Source: Github.com."></a>
   <figcaption>Fork an existing Github.com repository to make a copy of other users' files. Source: Github.com.
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

Because you forked the `ea-bootcamp-day-1` repository, your `Github.com` account now contains a copy of it, which you can access on `https://github.com/your-username/ea-bootcamp-day-1`. 

On the main `Github.com` page of your forked repository, click on the green button for `Clone or download`, and copy the URL provided in the box, which will look like: `https://github.com/jlpalomino/ea-bootcamp-day-1`. 


<figure>
    <a href="https://services.github.com/on-demand/images/gifs/github-cli/git-clone.gif">
   <img src="https://services.github.com/on-demand/images/gifs/github-cli/git-clone.gif" alt="Copy the url of a Github repository on Github.com. Source: Github.com"></a>
   <figcaption>Copy the url of a Github repository on Github.com. Source: Github.com
   </figcaption>
</figure>


Note: you do not have to use the `Clone or download` button to copy the URL. You can also copy it directly from your web browser or you might simply already know the URL. However, in many cases, you will have come across a `Github.com` repository on your own and will need to follow these instructions to copy the URL for future use.


### Run the Git Clone Command in the Terminal

To download your forked copy of the `ea-bootcamp-day1` repository to your computer, be sure that you have changed to the correct working directory (see **Use `Bash` to Change to Your Desired Working Directory**). 

Then, run the command `git clone` followed by the URL that you copied in above as follows: 

```bash
git clone https://github.com/your-username/ea-bootcamp-day-1
```

You have now made a local copy of the forked `Github.com` repository under your `earth-analytics-bootcamp` directory. Double check that the directory exists using the `ls` command in terminal. 

```bash
$ ls     
    ea-bootcamp-day-1
```

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
