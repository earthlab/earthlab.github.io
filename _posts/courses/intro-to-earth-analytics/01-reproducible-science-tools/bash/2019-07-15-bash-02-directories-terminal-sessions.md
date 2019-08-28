---
layout: single
title: 'Directories and Bash Terminal'
excerpt: "Bash or Shell is a command line tool that is used in open science to efficiently manipulate files and directories. Learn about the primary types of computer directories that you access with Bash. Also learn how to open and close terminal sessions across different operating systems to access Bash and test that Bash is ready for use on your computer."
authors: ['Jenny Palomino', 'Leah Wasser']
category: [courses]
class-lesson: ['bash']
permalink: /courses/intro-to-earth-analytics/open-science-bash-jupyter-markdown-git/bash/directories-bash-terminal/
nav-title: "Directories and Bash Terminal"
dateCreated: 2019-07-15
modified: 2019-08-28
module-type: 'class'
class-order: 2
course: "intro-to-earth-analytics"
week: 1
sidebar:
  nav:
author_profile: false
comments: true
order: 3
topics:
  reproducible-science-and-programming: ['shell']
---


{% include toc title="On This Page" icon="file-text" %}

<div class='notice--success' markdown="1">

## <i class="fa fa-graduation-cap" aria-hidden="true"></i> Learning Objectives

* Define a computer directory and list the primary types of directories.
* Open and close terminal sessions on your computer.
* Test that `Bash` is ready for use on your computer.

</div>
 

## Computer Directories

A directory refers to a folder on a computer that has relationships to other folders. The term "directory" considers the relationship between that folder and the folders within and around it. Directories are hierarchical which means that they can exist within other folders as well as have folders exist within them. 

### What Is a Parent Directory?

The term "parent" directory is used to describe the preceding directory in which a subdirectory is created. A parent directory can have many subdirectories; thus, many subdirectories can share the same parent directory. This also means that parent directories can also be subdirectories of a parent directory above them in the hierarchy. 

A familiar example would be your downloads directory. It is the parent directory for any directories or files that get downloaded to your computer or placed within this directory. 

In the example below, `downloads` is the parent directory of both the `cat-pics` and `dog-pics` directories, `cat-pics` is the parent directory for the `siamese` directory, etc. The image files (.jpg) exist within their parent directories as well (e.g the `poodle` directory is the parent directory of `01_max.jpg`). 

* downloads\
    * cat-pics\
        * siamese\
            * 01_fluffy.jpg
            * 02_snowball.jpg
    * dog-pics\
        * poodle\
            * 01_max.jpg
            * 02_terry.jpg


### What Is the Home Directory?

When you first open the terminal, it opens within the default directory of your computer, or the home directory. The home directory is the primary directory for your user on your computer, and it is created automatically as the default location for your user's files. 

On Windows, the home directory is typically specified to be `C:\Users\Your-Username`

On Mac and Linux, the home directory is typically specified to be `/home/your-user-name`. 

### What Is the Working Directory?

While the terminal will open in your home directory by default, you are able to change to a different location within your computer's file structure, or set a new working directory. 

The working directory refers to the current directory that is being accessed by the tool or program with which you are working (i.e. your current location within your computer's file structure).

Tools such as `Bash` provide the ability to define (or set) a new working directory in the terminal, which can be very helpful to programmatically access different directories and files across your computer as needed. 

In the example for `cat-pics` and `dog-pics`, `downloads` is a good choice for the current working directory if you need to access the contents of both `cat-pics` and `dog-pics`. However, the current working directory can also be set to `cat-pics` if you do not need to access the contents of `dog-pics` in your workflow. 

You can also update the current working directory anytime that you need to access files and directories that are stored in different locations across your computer.

In the lessons that follow, you will learn more about running `Bash` commands in the terminal to check and change the current working directory.


## Terminal Options For Bash

Previously, you learned that a terminal is the command line interface (CLI) that gives you access to `Bash`. There are many different terminal programs, and thus, the terminal that you use on your computer will vary according to your operating system. 

For instance, Mac as well as many Linux computers have a default terminal program installed that provides access to `Bash`. However, the default terminal on Windows computers does not provide access to `Bash`. 

For this textbook, Windows users will need to install a customized terminal called `Git Bash` to access and run `Bash` commands (see section above on What You Need).

Throughout the textbook, the command line environment that you use to access `Bash` will be referred to as the terminal. 


## Open a Terminal Session

The terminal program that you use to run `Bash` commands will vary depending upon your computer's operating system.

### Mac (OS X)

You can use the program called Terminal, which uses the `Bash` implementation of `Shell` and is installed natively on the Mac OS. 

You can open Terminal by finding and launching it from Spotlight (or from `/Applications/Utilities`).

<figure>
   <a href="{{ site.url }}/images/courses/earth-analytics/bash/mac-terminal.png">
   <img src="{{ site.url }}/images/courses/earth-analytics/bash/mac-terminal.png" alt="This is what the Terminal on Mac looks like. Source: Apple.com."></a>
   <figcaption>This is what the Terminal on Mac looks like. Source: <a href="https://help.apple.com/assets/58C4E5B4680CE2040551BA60/58C4E5B6680CE2040551BA69/en_US/84239026ca019f46567b86e900f5edd7.png" target = "_blank">Apple.com.</a>
   </figcaption>
</figure>

### Linux

Many Linux computers use the `Bash` implementation of `Shell`, which you will learn to test for in the section below.  

You can open the program called `Terminal` (or `Terminal Emulator`) by finding and launching it from your list of programs. 

<figure>
 <a href="{{ site.url }}/images/courses/earth-analytics/bootcamp/terminal/linux-terminal.png" width = "125%">
 <img src="{{ site.url }}/images/courses/earth-analytics/bootcamp/terminal/linux-terminal.png" alt="This is what the Terminal on Linux looks like." width = "125%"></a>
 <figcaption> This is what the Terminal on Linux looks like.
 </figcaption>
</figure>

### Windows

There are many options for running `Bash` on Windows. For this textbook, you will use `Git Bash` which comes with your installation of `git`. Instructions for setting this up are here: 

* <a href="{{ site.url }}/workshops/setup-earth-analytics-python/setup-git-bash-anaconda/" target = "_blank">Setting up Git, Bash, and Anaconda on your computer</a> 

Once you have installed `git` on a Windows machine, you can open this Terminal by searching for `Git Bash` in the start menu. Use `Git Bash` for all hands-on activities in this textbook that ask you to use the `Terminal`. 

<figure>
 <a href="{{ site.url }}/images/courses/earth-analytics/bootcamp/terminal/git-bash-terminal.png">
 <img src="{{ site.url }}/images/courses/earth-analytics/bootcamp/terminal/git-bash-terminal.png" alt="This is what the Git Bash Terminal on Windows looks like."></a>
 <figcaption> This is what the Git Bash Terminal on Windows looks like.
 </figcaption>
</figure>

## Check For Bash

To check for `Bash` on your computer, you can type "bash" into your open terminal, like shown below, and hit the enter key. 

Note that you will only get a message back if the command is not successful. If the command is successful, you will simply see a new line prompt waiting for more input.

```bash
$ bash
    $
```

In this example, the dollar sign ($) is a prompt that shows you that `Bash` is waiting for more input. 

Depending on your computer's set-up, you may see a different character as a prompt and/or additional information before the prompt, such as your current location within your computer's file structure (i.e. your current working directory).

## Close a Terminal Session

You can close the terminal at any time by typing the command "exit" and hitting the enter key. 

