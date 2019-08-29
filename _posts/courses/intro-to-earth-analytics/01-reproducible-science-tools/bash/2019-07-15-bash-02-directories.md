---
layout: single
title: 'What is a Working Directory and Other Science Project Management Terms Defined'
excerpt: "A directory refers to a folder on a computer that has relationships to other folders. Learn about the key terms associated with files and directories in a science project."
authors: ['Jenny Palomino', 'Leah Wasser']
category: [courses]
class-lesson: ['bash']
permalink: /courses/intro-to-earth-data-science/open-reproducible-science/bash/directories/
nav-title: "Computer Directories"
dateCreated: 2019-07-15
modified: 2019-08-29
module-type: 'class'
class-order: 2
course: "intro-to-earth-data-science"
week: 1
sidebar:
  nav:
author_profile: false
comments: true
order: 2
topics:
  reproducible-science-and-programming: ['shell']
---

{% include toc title="On This Page" icon="file-text" %}

<div class='notice--success' markdown="1">

## <i class="fa fa-graduation-cap" aria-hidden="true"></i> Learning Objectives

* Define a computer directory and list the primary types of directories.

</div>
 
You've probably used files and directories on your computer before. However, there are a set of terms that you will hear particularly as you work on open science projects or use the command line to manipuate files and directories. Below you will learn about some important terms associated with working with files including working and parent directories. 

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

On Windows, the home directory is typically specified to be `C:/Users/your-username`

On Mac and Linux, the home directory is typically specified to be `/home/your-user-name`. 

### What Is the Working Directory?

While the terminal will open in your home directory by default, you are able to change to a different location within your computer's file structure, or set a new working directory. 

The working directory refers to the current directory that is being accessed by the tool or program with which you are working (i.e. your current location within your computer's file structure).

Tools such as `Bash` provide the ability to define (or set) a new working directory in the terminal, which can be very helpful to programmatically access different directories and files across your computer as needed. 

In the example for `cat-pics` and `dog-pics`, `downloads` is a good choice for the current working directory if you need to access the contents of both `cat-pics` and `dog-pics`. However, the current working directory can also be set to `cat-pics` if you do not need to access the contents of `dog-pics` in your workflow. 

You can also update the current working directory anytime that you need to access files and directories that are stored in different locations across your computer.

In the lessons that follow, you will learn more about running `Bash` commands in the terminal to check and change the current working directory.

