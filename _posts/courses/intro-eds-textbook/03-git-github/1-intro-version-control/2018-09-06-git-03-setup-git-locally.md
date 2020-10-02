---
layout: single
title: 'How To Setup Git Locally On Your Computer'
excerpt: "Learn how to setup git locally on your computer."
authors: ['Jenny Palomino', 'Max Joseph', 'Leah Wasser']
category: [courses]
class-lesson: ['version-control-git-github']
permalink: /courses/intro-to-earth-data-science/git-github/version-control/how-to-setup-git/
nav-title: "Setup Git"
dateCreated: 2019-09-06
modified: 2020-10-02
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

* **configure** git locally with your username and email and preferred text editor

</div>


## Git and GitHub Workflow For Version Control

Previously, you learned how to `fork` **GitHub** repositories to make copies of other users' repositories, and you also learned how to download copies of (i.e. `clone`) **GitHub** repositories to your computer. On this page, you will learn to setup **git** on your computer:


## Configure git Username and Email On Your Computer

The first time that you use **git** on a computer, you will need to configure your **GitHub.com** username and email address. This information will be used to document who made changes to files in **git**. It is important to use the same email address and username that you setup on **GitHub.com**.

You can set your **Github.com** username in the **terminal** by typing: 
 
`$ git config --global user.name "username"`.

Next, you can set the email for your **Github.com** account by typing: 

`$ git config --global user.email "email@email.com"`.

Using the `--global` configuration option, you are telling **git** to use these settings for all **git** repositories that you work with on your computer. Note that you only have to configure these settings one time on your computer.  

*****

You can check your config settings for `user.name` and `user.email` using the following commands:

`git config user.name` which returns the username that you set previously

`git config user.email` which returns the email that you set previously

These configuration settings ensure that changes you make to repositories are attributed to your username and email. 

## Setup Your Preferred Text Editor

There are many text editors available for use with Git. Some such as Nano, Sublime and Vim are fully command line based. These are useful when you are working on remote servers and Linux and are often the default text editors for most computers. You may want to switch your git default text editor to a gui based editor to make things easier when you are getting started. 

<i class="fa fa-star" aria-hidden="true"></i> **Data Tip** <a href="https://docs.github.com/en/github/using-git/associating-text-editors-with-git" target="_blank">More on setting a default text editor from GitHub.</a> If the text editors below don't work for you, you can <a href="https://help.github.jp/enterprise/2.11/user/articles/associating-text-editors-with-git/" target="_blank">visit this page to learn more about other options such as Notepad++ for windows. </a>
{: .notice--success }

### Installing Atom as a Default Text Editor 

If you aren't sure what text editor you want to use, and you are on a MAC or PC <a href="https://atom.io/" target="_blank">we suggest Atom which is a powerful and free text editor that also has git and github support!</a> If you are on a MAC, before using Atom at the command line, you will need to install the shell command line tools. To get these tools installed

1. open up Atom 
2. Go to the Atom drop down at the very top of your screen. 
3. Select "Install Shell Commands"

The steps above will allow you to run `atom file-name-here` in bash to open the Atom text editor. Once you have Atom installed, you can run the command below in bash to set **Atom** to be the default text editor:

```bash
git config --global core.editor "atom --wait"
```

This command will set atom to be your default text editor for all operations. 

### Setting Nano as a Default Text Editor  For JupyterHub Environments 

If you are using a linux based JupyterHub (similar to what we use for our earth analytics course), we suggest setting the default text editor to **Nano**:

```bash
git config --global core.editor nano
```

This command will set nano to be your default text editor for all operations. 

