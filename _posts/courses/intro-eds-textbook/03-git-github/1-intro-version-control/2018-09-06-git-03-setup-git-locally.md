---
layout: single
title: 'How To Setup Git Locally On Your Computer'
excerpt: "Learn how to setup git locally on your computer."
authors: ['Leah Wasser', 'Nathan Korinek','Jenny Palomino', 'Max Joseph']
category: [courses]
class-lesson: ['version-control-git-github']
permalink: /courses/intro-to-earth-data-science/git-github/version-control/how-to-setup-git/
nav-title: "Setup Git"
dateCreated: 2019-09-06
modified: 2021-04-01
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
* Setup git / GitHub authentication using either a token or SSH

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

This command will set **nano** to be your default text editor for all operations. 

## Setup Authentication For Git Through GitHub

GitHub requires authentication to perform any changes to a repo. There are two ways to 
set up authentication for GitHub: 

1. Using a personal access token which you can setup on GitHub.com and use locally to authenticate: This involves  creating a token on GitHub.com and then using it as a "password" locally in bash.
2. Using SSH: This involves a bit more setup locally but once it is setup, you can skip the authentication steps for each change that you make to a repo.

In this lesson, you will learn about both options. If you are able to, we do  recommend that you use SSH authentication. However a token approach works well too!

### Set Up a GitHub Token For Authentication

Setting up a token is quicker in the short run as it requires fewer steps. However, in the long
run, token-based authentication can be more difficult to manage given:

1. You have to enter your token everytime you need to authenticate your GitHub account (unless you cache /store it)
2. If you lose your token value you have to refresh / ceate a new token. 

<a href="https://docs.github.com/en/github/authenticating-to-github/creating-a-personal-access-token" target="_blank">To setup a token to use for authentication, follow the GitHub guide.</a> 

<i class="fa fa-star"></i> **Data Tip:** If you chose to setup token based authentication, once you generate your token, be sure to copy it to a safe location before you close the GitHub page. If you lose the token, you will have to recreate it. 
{: .notice--success }

### Set Up an SSH Connection to GitHub (recommended)

SSH, which stands for **S**ecure **SH**ell, is an alternative way of authenticating with GitHub from your computer. While SSH setup involves more steps, once it is set up you never have to authenticate your connection to GitHub again. This is because you will have a Key stored locally on your computer that can be authenticated against a key stored on your GitHub account. 

Setting up SSH involves two steps:

1. creating the key itself locally on your computer, and 
2. adding the key to your GitHub account. 

Below you will find two GitHub tutorials that walk you through all of the steps needed to setup SSH on your computer.

#### Step 1: Generate Your  SSH Key Locally 

<a href="https://docs.github.com/en/github/authenticating-to-github/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent" target="_blank">Use this link to find step by step instructions for generating your SSH key.</a> 

Make sure to follow the instructions all the way to the end of the page where you add your SSH key to your SSH agent. **NOTE:** Around step 4 the instructions tell you to set up a passphrase for your SSH connection. While you can do this if you like, it is an optional step. SSH is already very secure, so if you decide you don't want an SSH passphrase, you can just hit return on the empty passphrase line. 

#### Step 2:  Add Your SSH Key  To Your GitHub Account

After you've generated your key and added it to your agent, you need to add the key to your GitHub account.<a href="https://docs.github.com/en/github/authenticating-to-github/adding-a-new-ssh-key-to-your-github-account" target="_blank">This link provides step by step instructions on adding the SSH key to your account.</a> The instructions vary slightly from operating system to operating system, so be sure you are using the instructions for the operating system running on your computer (MAC, Windows or Linux). 

<i class="fa fa-star"></i> **NOTE FOR LINUX USERS:** On the help page for adding your SSH key to your GitHub account, GitHub recommends that you install `xclip` and then use that to copy your SSH public key. While this works, it can cause problems on some computer. If you run into an issue on this step, you can always use `cat  path/to/file` and manually copy the output you get in the terminal. The `cat` command in BASH will copy the contents of a file to your clipboard. You can then paste that output (which is your secure key) into  GitHub to finalize connecting your computer to GitHub.
{: .notice--success }


### Update Your Remotes To Support SSH

If you have been using a username / password login to authenticate with GitHub, and you are  switching 
to SSH-based authentication, you will likely need to update the remotes attached to your GitHub repo(s).
A quick way to see if this is the case, is 

1. at the command line, CD to the repo directory (cd path/to/practice-git-skillz)
2. when in the directory of interest, run `git remote -v` 

If the URL returned looks like the one below, starting with **https://** then you are still authenticating
using either a password or a token. If you setup token-based authentication, then you can use the https:// remote  setup. 

```bash
$ (base) CIRES-EL-LM-020:practice-git-skillz $ git remote -v
origin	https://github.com/your-username/practice-git-skillz.git (fetch)
origin	https://github.com/your-username/practice-git-skillz.git (push)
```

However, if you wish to use SSH, then you will need to UPDATE the remote for your repo. 

```bash
$ (base) CIRES-EL-LM-020:practice-git-skillz $ git remote -v
origin	git@github.com:your-username/practice-git-skillz.git (fetch)
origin	git@github.com:your-username/practice-git-skillz.git (push)
```

To change your remote repository url from https to SSH, do the following

1. Go to the repository on GitHub.com
2. Use the green Code button to copy the SSH URL for that repo (see animated gif below for how to do that)
3. Use `git remote set-url` to update the url locally


<figure>
 <a href="{{ site.url }}/images/earth-analytics/git-version-control/github-get-remote-url.gif">
 <img src="{{ site.url }}/images/earth-analytics/git-version-control/github-get-remote-url.gif" alt="You can find  the url for your GitHub repo using the green code button. Copy the url and then use git --set-url to update the  remote locally."></a>
 <figcaption> You can find the url for your GitHub repo using the green code button. Copy the url and then use  git --set-url to update the remote locally.
 </figcaption>
</figure>

```bash
$ git remote set-url origin git@github.com:your-username/practice-git-skillz.git
```

Once you have updated your remotes, SSH authentication should work!

