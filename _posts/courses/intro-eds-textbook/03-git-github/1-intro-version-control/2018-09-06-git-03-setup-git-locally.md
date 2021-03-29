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
modified: 2021-03-29
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

## Setup Authentication Through GitHub

GitHub requires additional authentication for users aside from a username and password. There are two main ways to set up authentication for GitHub: through a personal access token, or though SSH. We will give you resources for both, but would recommend SSH!

### Set Up a GitHub Token (Not recommended)

Setting up a token is easier in the short run, but can be more difficult to manage over the long run. Using the token can be slower, as you have to enter it in everytime you need to authenticate your GitHub account, and if you lose your token it can be difficult to remedy that situation. <a href="https://docs.github.com/en/github/authenticating-to-github/creating-a-personal-access-token" target="_blank">GitHub has a great help page to help you set up a personal access token.</a> **ONCE YOU GENERATE YOUR TOKEN COPY IT TO SOMEWHERE SAFE BEFORE YOU CLOSE THE PAGE**. If you lose your token you will have to create a new one, and may be locked out of certain functionality on your GitHub. Treat it like a password for your account.

### Set Up an SSH Connection to GitHub (recommended)

SSH, which stands for Secure Shell, is an alternative way of connecting to GitHub remotely. While harder to set up, once SSH is set up you never have to authenticate your connection to GitHub again. This is because you will have a Key stored locally on your pc that can be authenticated against a key stored on your GitHub account. 

SSH has two steps too setting it up: creating the key itself, and adding the key to your GitHub account. 

<a href="https://docs.github.com/en/github/authenticating-to-github/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent" target="_blank">Here are step by step instructions for generating your SSH key.</a> Make sure to follow the instructions all the way to the end of the page where you add your SSH key to your SSH agent. **NOTE:** Around step 4 the instructions tell you to set up a passphrase for your SSH connection. While you can do this if you like, it is an optional step. SSH is already very secure, so if you decide you don't want an SSH passphrase, you can just hit return on the empty passphrase line. 

After you've generated your key and added it to your agent, you can <a href="https://docs.github.com/en/github/authenticating-to-github/adding-a-new-ssh-key-to-your-github-account" target="_blank">add the key to your GitHub account.</a> The instructions vary slightly from operating system to operating system, so be sure you are using the correct instructions! **NOTE FOR LINUX USERS:** On the help page for adding your SSH key to your GitHub account, GitHub recommends that you install `xclip` and then use that to copy your SSH public key. While this works, it has caused some people trouble. If you run into an issue on this step, you can always use `cat  path/to/file` and manually copy the output you get in the terminal. 

### Ensure Remote Connection Matches Authentication Type

When setting up authentication, you may notice that you set up SSH and Git is still prompting you for a password when using `git push` or `git pull`. This is due to the fact that while you set up SSH locally, your remote connection to GitHub is through an HTTPS url instead of an SSH url. If you are using SSH authentication, you should make sure all of your remote url's are SSH, and if you are using an access token, you should make sure all of your remote url's are HTTPS. Too see how to check which type of remote url you currently have, and how to change your connection url if needed, <a href="{{site.url}}/courses/intro-to-earth-data-science/git-github/github-collaboration/update-github-repositories-with-changes-by-others/#working-with-remotes" target="_blank">see this lesson.</a>

