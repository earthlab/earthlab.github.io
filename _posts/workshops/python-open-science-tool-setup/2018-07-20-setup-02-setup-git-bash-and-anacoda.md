---
layout: single
category: courses
title: 'Setup Git, Bash, and Anaconda on Your Computer'
excerpt: "Learn how to install Git, GitBash (a version of command line Bash) and Python Anaconda distribution on your computer."
authors: ['Leah Wasser', 'Martha Morrissey']
attribution: 'These materials were adapted from Software Carpentry materials'
modified: 2018-08-30
nav-title: 'Setup Git Bash & Conda'
sidebar:
  nav:
module: "setup-earth-analytics-environment"
permalink: /workshops/setup-earth-analytics-python/setup-git-bash-anaconda/
author_profile: false
comments: true
order: 2
topics:
  reproducible-science-and-programming: ['python']
---

{% include toc title="In This Lesson" icon="file-text" %}

In this lesson, you will learn how to install `Git`, `Git Bash` (a version of command line `Bash`) and the Anaconda distribution for `Python` on your computer.

<div class='notice--success' markdown="1">


## <i class="fa fa-graduation-cap" aria-hidden="true"></i> Learning Objectives

At the end of this activity, you will be able to:

* Install `Bash` and `Git`
* Open a Terminal 
* Install Anaconda using the Terminal 


## <i class="fa fa-check-square-o fa-2" aria-hidden="true"></i> What You Need

Before you start this tutorial, be sure that you have a computer with internet access. 

Information below is adapted from materials developed by <a href="https://github.com/swcarpentry/workshop-template" target = "_blank">Data Carpentry</a> and the <a href="https://conda.io/docs/user-guide/install/index.html" target = "_blank">Conda documentation</a>.

</div>


## Bash Setup 

### Install Bash for Windows

Download the <a href="https://git-scm.com/download/win" target = "_blank">Git for Windows installer</a>. 

Run the installer by double-clicking on the downloaded file and by following the steps bellow:
1. Click on “Run”.
2. Click on "Next".
3. Click on "Next".
4. Click on "Next".
5. Click on "Next".
6. Click on "Next".
7. **Leave the selection on  "Use Git from the Windows Command Prompt"** and click on "Next". NOTE: If you forgot to do this, the programs that you need for the workshop will not work properly. If this happens, rerun the installer and select the appropriate option.
8. Click on "Next". 
9. Leave the selection on  "Checkout Windows-style, commit Unix-style line endings" and click on “Next”.
10. Select the second option for "Use Windows' default console window" and click on "Next".
11. Click on "Install".
12. When the install is complete, click on “Finish”.

This installation will provide you with both `Git` and `Bash` within the `Git Bash` program.

### Install Bash for Mac OS X

The default shell in all versions of Mac OS X is `Bash`, so no need to install anything. You access `Bash` from the Terminal (found in /Applications/Utilities). You may want to keep Terminal in your dock for this workshop.

### Install Bash for Linux

The default shell is usually `Bash` but if your machine is set up differently you can run it by opening the Terminal and typing: `bash`. There is no need to install anything.


## Git Setup

`Git` is a version control system that lets you track who made changes to what and when, and it has options for easily updating a shared or public version of your code on <a href="https://github.com/" target="_blank">GitHub</a>. 

You will need a <a href="https://help.github.com/articles/supported-browsers/" target="_blank">supported web browser</a> (current versions of Chrome, Firefox or Safari, or Internet Explorer version 9 or above).

`Git` installation instructions borrowed and modified from <a href="http://software-carpentry.org/" target="_blank">Software Carpentry</a>.

### Git for Windows

`Git` was installed on your computer as part of your `Bash` install.

### Git on Mac OS X

<a href="https://www.youtube.com/watch?v=9LQhwETCdwY" target="_blank">Video Tutorial</a>

Install `Git` on Macs by downloading and running the most recent installer for "mavericks" if you are using OS X 10.9 and higher -or- if using an earlier OS X, choose the most recent "snow leopard" installer, from <a href="http://sourceforge.net/projects/git-osx-installer/files/" target="_blank">this list</a>. 

After installing `Git`, there will not be anything in your /Applications folder, as `Git` is a command line program.


<i class="fa fa-star"></i> **Data Tip:**
If you are running Mac OSX El Capitan, you might encounter errors when trying to use `Git`. Make sure you update XCODE. <a href="http://stackoverflow.com/questions/32893412/command-line-tools-not-working-os-x-el-capitan" target="_blank">Read more - a Stack Overflow Issue</a>. 
{: .notice--success }


### Git on Linux

If `Git` is not already available on your machine, you can try to install it via your distro’s package manager. For Debian/Ubuntu, run `sudo apt-get install git` and for Fedora run `sudo yum install git`.


## Setup Anaconda 

We will use the Anaconda `Python` 3.x distribution for this course. Anaconda is a distribution of `Python` that comes with many of the libraries that we need to work with scientific data. Anaconda also comes with `Jupyter Notebook` and several other tools that are useful for working in `Python`.

If you already have Anaconda for `Python` 2 setup, you do not need to install Anaconda again. We will be working with Python version 3.6 in this class, but a `Python` 3.6 environment can be installed into an Anaconda 2.7 distribution. We will discuss setting up conda environments in <a href="{{ site.url }}/workshops/setup-earth-analytics-python/setup-python-anaconda-earth-analytics-environment/">lesson 4 of this module</a>.

### Windows

**IMPORTANT:** if you already have a `Python` installation on your Windows computer, the settings below will replace it with Anaconda as the default `Python`. If you have questions or concerns about this, please contact your course instructor. 

Download the <a href="https://www.anaconda.com/download/#windows" target="_blank">Anaconda installer for Windows</a>. Be sure to download the `Python` 3.6 version! 

Run the installer by double-clicking on the downloaded file and follow the steps bellow:
1. Click “Run”. 
2. Click on "Next".
3. Click on “I agree”.
4. Leave the selection on “Just me” and click on “Next”.
5. Click on "Next".
6. **Select the first option for “Add Anaconda to my PATH environment variable”** and also leave the selection on “Register Anaconda as my default Python 3.6”. Click on “Install”. 
7. When the install is complete, Click on “Next”.
8. Click on “Skip”. 
9. Click on “Finish”. 

This installation will provide you with a `Python` 3.6 distribution created by the Anaconda project. 


### Mac

1. Download the installer: <a href="https://www.anaconda.com/download/" target="_blank">Anaconda installer for Mac</a>. Be sure to download the `Python` 3.x version!

2. Install: Anaconda—Double-click the .pkg file.

3. Follow the prompts on the installer screens.

4. If you are unsure about any setting, accept the defaults. You can change them later.

5. To make the changes take effect, close and then re-open your Terminal window.


### Linux

1. Download the installer: <a href="https://www.anaconda.com/download/" target="_blank">Anaconda installer for Linux</a>. Be sure to download the `Python` 3.x version!

2. In your Terminal window, run: `bash Anaconda-latest-Linux-x86_64.sh`

3. Follow the prompts on the installer screens.

4. If you are unsure about any setting, accept the defaults. You can change them later.

5. To make the changes take effect, close and then re-open your Terminal window.


## Test your set-up of Bash, Git and Anaconda

### Windows

1. Search for and open the `Git Bash` program. In this `Terminal` window, type `bash` and hit enter. 
If you do not get a message back, then `Bash` is available for use. 

2. Next, type `git` and hit enter. 
If you see a list of commands that you can execute, then `Git` has been installed correctly. 

3. Next, type `conda` and hit enter.
Again, if you see a list of commands that you can execute, then Anaconda `Python` has been installed correctly.

4. Close the `Terminal` by typing `exit`.

### Mac

1. Search for and open the Terminal program (found in /Applications/Utilities). In this `Terminal` window, type `bash` and hit enter. 
If you do not get a message back, then `Bash` is available for use. 

2. Next, type `git` and hit enter. 
If you see a list of commands that you can execute, then `Git` has been installed correctly. 

3. Next, type `conda` and hit enter.
Again, if you see a list of commands that you can execute, then Anaconda `Python` has been installed correctly.

4. Close the `Terminal` by typing `exit`.

### Linux

1. Search for and open the Terminal program. In this `Terminal` window, type `bash` and hit enter. 
If you do not get a message back, then `Bash` is available for use. 

2. Next, type `git` and hit enter. 
If you see a list of commands that you can execute, then `Git` has been installed correctly. 

3. Next, type `conda` and hit enter.
Again, if you see a list of commands that you can execute, then Anaconda `Python` has been installed correctly.

4. Close the `Terminal` by typing `exit`.

