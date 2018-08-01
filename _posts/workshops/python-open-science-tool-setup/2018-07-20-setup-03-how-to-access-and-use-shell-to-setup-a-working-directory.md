---
layout: single
category: courses
title: 'How to Access and Use Shell to Set Up a Working Directory'
excerpt: 'This tutorial walks you through how access the shell through terminal, use basic commands in the terminal for file organization, and set up a working directory for the course.'
authors: ['Martha Morrissey','Leah Wasser', 'Data Carpentry']
modified: 2018-07-30
module: "setup-earth-analytics-environment"
permalink: /workshops/setup-earth-analytics-python/introduction-to-bash-shell/
nav-title: 'Bash'
sidebar:
    nav:
author_profile: false
comments: true
order: 3
topics:
    reproducible-science-and-programming: ['python']
---
{% include toc title="In This Lesson" icon="file-text" %}


In this tutorial you will access the shell through terminal, use basic commands in the terminal for file organization,  and set up a working directory for the course.


<div class='notice--success' markdown="1">


## <i class="fa fa-graduation-cap" aria-hidden="true"></i> Learning Objectives

At the end of this activity, you will be able to:

* Open a terminal
* Navigate and change directories in the terminal
* Access python from the terminal.
* Create an easy to use and well structured project structure.


## <i class="fa fa-check-square-o fa-2" aria-hidden="true"></i> What You Need

You will need to have Git and Bash setup on your computer to complete this lesson. Instructions for setting up Git and Bash are here: [Setup Git/Bash & Anaconda Python lesson]({{ site.url }}/workshops/setup-earth-analytics-python/setup-git-bash-anaconda/)

</div>

## How to Access Bash

Information below is adapted from materials developed by: <a href="https://cs61a.org/lab/lab00/" target="_blank">U.C. Berkeley’s cs61a</a>, <a href="http://swcarpentry.github.io/shell-novice/" target = "_blank">Software Carpentry</a> and <a href="https://github.com/thehackerwithin/berkeley/blob/master/code_examples/bash/tutorial.md" target="_blank">The Hacker Within, Berkeley</a>.

### Get Started with the Terminal

In the earliest days of computing, the computer itself which processed data or performed operations was separate from the tool that gave it instructions to do the processing. There was:

* Terminal: which was used to send commands to the computer and
* The computer: the hardware that processed the commands

Today, we have computers that can both provide commands AND perform the computation. And those computers have graphic interfaces (known as GUIs) that make it easy to perform tasks. However, we still need to access the command line or terminal for certain tasks. In this lesson you will learn how to set up a command line interface on your computer.

<figure>
 <a href="{{ site.url }}/images/courses/earth-analytics/python-interface/early-terminal.png">
 <img src="{{ site.url }}/images/courses/earth-analytics/python-interface/early-terminal.png" alt = "An image showing a terminal and a computer in it's earliest days. "></a>
 <figcaption> Image of the earliest computers and a terminal.</figcaption>
</figure>

### About Bash
Bash is command line program that allows you to efficiently perform many tasks. You can think of it as the computer in the example above. The command line or terminal is where you provide bash commands that it then executes. This allows you to control your computer by typing in commands entered with a keyboard instead of using buttons or drop down menus in a graphical user interface (GUI) with a mouse/keyboard combination.

You can use bash to access and process files at the command line. Working with files at the command line is faster and more efficient than working with files in a graphic environment like Windows Explorer or Mac Finder. In bash, you can perform multiple operations on multiple files quickly. You can also write and execute scripts in Bash just like you can in `R` or `Python`. Finally, you can use Bash to launch tools like `Python`, `R` and Jupyter Notebooks. We will be using Python and Jupyter notebooks throughout this class.  (we will use Jupyter in this class).

<i class="fa fa-star"></i> **Data Tip:**
Bash stands for “bourne again shell”, and is an updated version of shell. Sometimes you will hear bash and shell used interchangeably, but in this course we will use the term bash throughout.
{: .notice--success}

You access Bash using a terminal program which we will discuss next.


## What is a Terminal?
A terminal is the command line interface  that gives you access to bash. There are many different terminal programs and thus the terminal program that you use on your computer will vary according to your operating system. For instance a MAC comes with a terminal program that provides access to Bash already installed. However, on a Windows machine, you will have to install a new program to access bash - like GitBash which we will use in this course.

For the rest of this course, we will refer to the command line environment that you use to access bash as the terminal. For windows users, this terminal may be opened using a tool like Git Bash.


## Why use Terminal?
#### Interact with your computer/organize files

Using Bash in the terminal is a powerful way of interacting with your computer. GUIs and command line Bash are complementary - by knowing both you will greatly expand the range of tasks you can accomplish with your computer. You will also be able to perform many tasks more efficiently. Common tasks you can run at the command liner include checking the directory you’re in, changing directories, making a new directory, extracting files, and finding files on your computer.


## Access Bash

You access bash differently depending on your operating system.

* OS X: The bash program is called Terminal. You can search for it in Spotlight.

* Windows: Git Bash came with your download of Git for Windows. Search Git Bash. For the rest of this course, even if you are on windows, we will refer to the terminal. You are using Git Bash as your terminal.

* Linux: Default is usually bash, if not, type bash in the terminal.


## Bash Commands

The dollar sign is a prompt, that shows you that bash is waiting for input; your shell may use a different character as a prompt and may add information before the prompt.

When typing commands, either from these tutorials or from other sources, do not type the dollar sign only the commands that follow it. In these tutorials, subsequent lines that follow a prompt and do not start with $ are the output of the command.



### Basic Bash Commands

* ls: lists all files in the current directory in alphabetical order, arranged neatly into columns.





```bash
$ ls

Applications   Documents   Library   Music   Public
Desktop        Downloads   Movies    Picture
```

Your results may be slightly different depending on your operating system and how you have customized your filesystem.



*  pwd: print working directory- prints the name of the directory you are working from

```bash
$ pwd

/Users/earthlab

```


* cd (path to directory): change into the specified directory

* cd .. (two dots). The .. means "the parent directory" so you can use cd .. to go up one directory.

* cd ~ (the tilde). Remember that ~ means home directory, so this command will always change to your home directory.


```bash
$ cd ~
```


* mkdir (directory name): make a new directory with the given name
  This example will make a new directory called notes inside of the documents directory.


```bash
$ cd documents
$ ls documents

    data/  elements/  animals.txt  planets.txt  sunspot.txt

$ mkdir notes

$ ls documents

	data/  elements/  notes/  animals.txt  planets.txt  sunspot.txt
```

Notice that mkdir command has no ouput, and that since notes is a relative path (i.e., doesn’t have a leading slash), the new directory is created in the current working directory.

<i class="fa fa-star"></i> **Data Tip:**
Directory vs Folder: You can think of a directory as a folder. However the term directory considers the relationship between that folder and the folders within it and around it.
{: .notice--success}


<i class="fa fa-star"></i> **Data Tip:**
Notice that you are creating an easy to read directory name. The name has no spaces and uses all lower case to support machine reading down the road. Sometimes this format of naming using dashes is referred to as a slug.
{: .notice--success}


<div class="notice--warning" markdown="1">

## <i class="fa fa-pencil-square-o" aria-hidden="true"></i> Exercise

Project organization is integral to efficient research. Use Bash to create an `earth-analytics` project directory. You will use this directory throughout this course.

You will then create a  `\data` directory within the `earth-analytics` directory to save all of the data that you will need to complete the homework assignments and follow along with the course.

### Create earth-analytics Project Directory


Create an `earth-analytics` project directory (or folder).

* Navigate to the Documents directory on your computer.

```bash
$ cd documents
```


* In the directory, create a NEW DIRECTORY called `earth-analytics`.


``` bash
$ mkdir earth-analytics
```


*  Next change directories to be inside of the earth-analytics directory and create a directory within it called `data`

```bash
$ cd earth-analytics
$ mkdir data
```



* Let’s go back to the home directory and confirm we can then access the directories we just made.

```bash

$ cd ~

$ cd documents

$ cd earth-analytics

$ ls

data/
```

</div>
