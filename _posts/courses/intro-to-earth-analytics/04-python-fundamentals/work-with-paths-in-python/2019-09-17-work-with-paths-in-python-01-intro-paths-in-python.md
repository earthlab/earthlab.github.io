---
layout: single
title: 'What is a Working Directory and Other Science Project Management Terms Defined'
excerpt: "A directory refers to a folder on a computer that has relationships to other folders. Learn about the key terms associated with files and directories in a science project."
authors: ['Jenny Palomino', 'Leah Wasser']
category: [courses]
class-lesson: ['work-with-files-directories-in-python']
permalink: /courses/intro-to-earth-data-science/python-code-fundamentals/work-with-files-directories-in-python/
nav-title: "Computer Directories"
dateCreated: 2019-09-18
modified: 2019-09-23
module-title: 'Intro to Working with Files and Directories in Python'
module-nav-title: 'Work with Files and Directories'
module-description: 'Paths . Learn how . '
module-type: 'class'
class-order: 3
chapter: 12
course: "intro-to-earth-data-science"
week: 4
sidebar:
  nav:
author_profile: false
comments: true
order: 1
topics:
  reproducible-science-and-programming: ['python']
---
{% include toc title="In This Chapter" icon="file-text" %}

<div class='notice--success' markdown="1">

## <i class="fa fa-ship" aria-hidden="true"></i> Chapter Twelve - Work with Files and Directories in Python

In this chapter, you will learn how to work with paths in **Python**. You will learn how absolute and relative paths 

You will learn how to set a working directory and using absolute and relative paths to access files and directories.


## <i class="fa fa-graduation-cap" aria-hidden="true"></i> Learning Objectives

After completing this chapter, you will be able to:

* Define a computer directory and list the primary types of directories.
* Explain the difference between relative and absolute paths. 
* Check and set your working directory in **Python** using the **os** package. 


## <i class="fa fa-check-square-o fa-2" aria-hidden="true"></i> What You Need

Be sure that you have followed the instructions on <a href="{{ site.url }}/workshops/setup-earth-analytics-python/">Setting up Git, Bash, and Conda on your computer</a> to install the tools for your operating system (Windows, Mac, Linux). 

Be sure that you have completed the chapter on <a href="{{ site.url }}/courses/intro-to-earth-data-science/open-reproducible-science/jupyter-python/">Jupyter Notebook</a>.

</div>

<a href="https://www.python.org/doc/essays/blurb/" target="_blank">**Python**</a> is a free, open source scientific programming language.


## About Computer Directories

You've probably used files and directories on your computer before. However, there are a set of terms that you will hear particularly as you work on open science projects or use the command line to manipuate files and directories. Below you will learn about some important terms associated with working with files including working and parent directories. 

A directory refers to a folder on a computer that has relationships to other folders. The term "directory" considers the relationship between that folder and the folders within and around it. Directories are hierarchical which means that they can exist within other folders as well as have folders exist within them. 


## What Is a Parent Directory

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


## What Is the Home Directory

When you first open the terminal, it opens within the default directory of your computer, or the home directory. The home directory is the primary directory for your user on your computer, and it is created automatically as the default location for your user's files. 

On Windows, the home directory is typically specified to be `C:/Users/your-username`

On Mac and Linux, the home directory is typically specified to be `/home/your-user-name`. 


## What Is the Working Directory

While the terminal will open in your home directory by default, you are able to change to a different location within your computer's file structure, or set a new working directory. 

The working directory refers to the current directory that is being accessed by the tool or program with which you are working (i.e. your current location within your computer's file structure).

Tools such as `Bash` provide the ability to define (or set) a new working directory in the terminal, which can be very helpful to programmatically access different directories and files across your computer as needed. 

In the example for `cat-pics` and `dog-pics`, `downloads` is a good choice for the current working directory if you need to access the contents of both `cat-pics` and `dog-pics`. However, the current working directory can also be set to `cat-pics` if you do not need to access the contents of `dog-pics` in your workflow. 

You can also update the current working directory anytime that you need to access files and directories that are stored in different locations across your computer.

In the lessons that follow, you will learn more about running `Bash` commands in the terminal to check and change the current working directory.


## Absolute and Relative Paths




