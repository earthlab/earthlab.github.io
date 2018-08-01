---
layout: single
category: courses
title: 'Setup Git, Bash, and Anaconda on Your Computer'
excerpt: "Learn how to install Git, GitBash (a version of command line Bash) and Python Anaconda distribution on your computer."
authors: ['Leah Wasser', 'Martha Morrissey']
attribution: 'These materials were adapted from Software Carpentry materials'
modified: 2018-07-30
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

In this lesson, you will learn how to install Git, Git Bash (a version of command line Bash) and the Python Anaconda distribution on your computer.

<div class='notice--success' markdown="1">


## <i class="fa fa-graduation-cap" aria-hidden="true"></i> Learning Objectives

At the end of this activity, you will be able to:

* Install Bash

* Open a terminal 

* Install anaconda using the terminal 


## <i class="fa fa-check-square-o fa-2" aria-hidden="true"></i> What You Need

Before you start this tutorial, be sure that you have a computer with internet access. 

Information below is adapted from materials developed by [Data Carpentry](https://github.com/swcarpentry/workshop-template) and the [Conda documentation](https://conda.io/docs/user-guide/install/index.html). 

</div>


## Bash Setup 

### Install Bash for Windows

Download the [Git for Windows installer](https://git-scm.com/download/win). Run the installer by double-clicking on the downloaded file and follow the steps bellow:
1. Click on “Run”.
2. Click on "Next".
3. Click on "Next".
4. Click on "Next".
5. Click on "Next".
6. Click on "Next".
7. Leave the selection on  "Use Git from the Windows Command Prompt" and click on "Next". NOTE: If you forgot to do this, the programs that you need for the workshop will not work properly. If this happens, rerun the installer and select the appropriate option.
8. Click on "Next". 
9. Leave the selection on  "Checkout Windows-style, commit Unix-style line endings" and click on “Next”.
10. Select the second option for "Use Windows' default console window" and click on "Next".
11. Click on "Install".
12. When the install is complete, click on “Finish”.

This installation will provide you with both Git and Bash in the Git Bash program.

### Install Bash for Mac OS X
The default shell in all versions of Mac OS X is bash, so no need to install anything. You access bash from the Terminal (found in /Applications/Utilities). You may want to keep Terminal in your dock for this workshop.

### Install Bash for Linux
The default shell is usually Bash, but if your machine is set up differently you can run it by opening a terminal and typing bash. There is no need to install anything.


## Git Setup

Git is a version control system that lets you track who made changes to what when and has options for easily updating a shared or public version of your code on [GitHub](https://github.com/). You will need a [supported](https://help.github.com/articles/supported-browsers/) web browser (current versions of Chrome, Firefox or Safari, or Internet Explorer version 9 or above).

Git installation instructions borrowed and modified from [Software Carpentry](http://software-carpentry.org/).

### Git for Windows
Git was installed on your computer as part of your Bash install.

### Git on Mac OS X
[Video Tutorial](https://www.youtube.com/watch?v=9LQhwETCdwY)
Install Git on Macs by downloading and running the most recent installer for "mavericks" if you are using OS X 10.9 and higher -or- if using an earlier OS X, choose the most recent "snow leopard" installer, from [this list](http://sourceforge.net/projects/git-osx-installer/files/). After installing Git, there will not be anything in your /Applications folder, as Git is a command line program.


<i class="fa fa-star"></i> **Data Tip:**
If you are running Mac OSX El Capitan, you might encounter errors when trying to use git. Make sure you update XCODE. [Read more - a Stack Overflow Issue](http://stackoverflow.com/questions/32893412/command-line-tools-not-working-os-x-el-capitan).
{: .notice--success }


### Git on Linux
If Git is not already available on your machine you can try to install it via your distro’s package manager. For Debian/Ubuntu run `sudo apt-get install git` and for Fedora run `sudo yum install git`.


## Setup Anaconda 
We will use the Anaconda Python 3.x distribution for this course. Anaconda is a distribution of python that comes with many of the libraries that we need to work with scientific data. Anaconda also comes with Jupyter Notebooks and several other tools that are useful for working in Python.

If you already have Anaconda for Python 2 setup you do not need to install Anaconda again. We will be working with Python version 3.6 in this class, but a python 3.6 environment can be installed into an Anaconda 2.7 distribution. We will discuss setting up conda envrionments in [lesson 3 of this module](/courses/earth-analytics-python/get-started-with-python-jupyter/setup-conda-earth-analytics-environment/).

 
### Windows
**IMPORTANT:** if you already have a Python installation on your Windows computer, the settings below will replace it with Anaconda as the default Python. If you have questions or concerns about this, please contact your course instructor. 

Download the [Anaconda installer for Windows](https://www.anaconda.com/download/#windows). Be sure to download the python 3.6 version! Run the installer by double-clicking on the downloaded file and follow the steps bellow:
1. Click “Run”. 
2. Click on "Next".
3. Click on “I agree”.
4. Leave the selection on “Just me” and click on “Next”.
5. Click on "Next".
6. Select the first option for “Add Anaconda to my PATH environment variable” and also leave the selection on “Register Anaconda as my default Python 3.6”. Click on “Install”. 
7. When the install is complete, Click on “Next”.
8. Click on “Skip”. 
9. Click on “Finish”. 

This installation will provide you with a Python 3.6 distribution created by the Anaconda project. 


### Mac
1. Download the installer: [Anaconda installer for macOS](https://www.anaconda.com/download/). Be sure to download the python 3.x version!

2. Install: Anaconda—Double-click the .pkg file.

3. Follow the prompts on the installer screens.

4. If you are unsure about any setting, accept the defaults. You can change them later.

5. To make the changes take effect, close and then re-open your Terminal window.


### Linux
1. Download the installer: [Anaconda installer for Linux](https://www.anaconda.com/download/). Be sure to download the python 3.x version!

2. In your Terminal window, run: `bash Anaconda-latest-Linux-x86_64.sh`

3. Follow the prompts on the installer screens.

4. If you are unsure about any setting, accept the defaults. You can change them later.

5. To make the changes take effect, close and then re-open your Terminal window.


## Test your set-up of Bash, Git and Anaconda
### Windows
1. Search for and open the Git Bash program. In this `Terminal` window, type `bash` and hit enter. 
If you do not get a message back, then Bash is available for use. 

2. Next, type `git` and hit enter. 
If you see a list of commands that you can execute, then Git has been installed correctly. 

3. Next, type `conda` and hit enter.
Again, if you see a list of commands that you can execute, then Anaconda Python has been installed correctly.

4. Close the `Terminal` by typing `exit`.

### Mac
1. Search for and open the Terminal program (found in /Applications/Utilities). In this `Terminal` window, type `bash` and hit enter. 
If you do not get a message back, then Bash is available for use. 

2. Next, type `git` and hit enter. 
If you see a list of commands that you can execute, then Git has been installed correctly. 

3. Next, type `conda` and hit enter.
Again, if you see a list of commands that you can execute, then Anaconda Python has been installed correctly.

4. Close the `Terminal` by typing `exit`.

### Linux
1. Search for and open the Terminal program. In this `Terminal` window, type `bash` and hit enter. 
If you do not get a message back, then Bash is available for use. 

2. Next, type `git` and hit enter. 
If you see a list of commands that you can execute, then Git has been installed correctly. 

3. Next, type `conda` and hit enter.
Again, if you see a list of commands that you can execute, then Anaconda Python has been installed correctly.

4. Close the `Terminal` by typing `exit`.

