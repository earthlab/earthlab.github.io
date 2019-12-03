---
layout: single
category: courses
title: 'How to Access and Use Shell to Set Up a Working Directory'
excerpt: 'This tutorial walks you through how access the shell through terminal, use basic commands in the terminal for file organization, and set up a working directory for the course.'
authors: ['Leah Wasser', 'Martha Morrissey']
modified: 2019-09-03
module: "setup-earth-analytics-environment"
permalink: /workshops/setup-earth-analytics-python/introduction-to-bash-shell/ 
nav-title: 'Intro to Bash'
sidebar:
    nav:
author_profile: false
comments: true
order: 3
topics:
    reproducible-science-and-programming: ['python']
---
{% include toc title="In This Lesson" icon="file-text" %}

In this tutorial, you will access `Bash`/Shell through the Terminal, use basic commands in the terminal for file organization,  and set up a working directory for the course.


<div class='notice--success' markdown="1">


## <i class="fa fa-graduation-cap" aria-hidden="true"></i> Learning Objectives

At the end of this activity, you will be able to:

* Open the Terminal.
* Navigate and change directories in the Terminal.
* Create an easy-to-use and well-structured project structure.


## <i class="fa fa-check-square-o fa-2" aria-hidden="true"></i> What You Need

You will need to have Git and Bash setup on your computer to complete this lesson. Instructions for setting up Git and Bash are here: <a href="{{ site.url }}/workshops/setup-earth-analytics-python/setup-git-bash-conda/">Setup Git, Bash & Conda lesson</a>. 

</div>

## How to Access Bash

Information below is adapted from materials developed by: <a href="https://cs61a.org/lab/lab00/" target="_blank">U.C. Berkeley’s cs61a</a>, <a href="http://swcarpentry.github.io/shell-novice/" target = "_blank">Software Carpentry</a> and <a href="https://github.com/thehackerwithin/berkeley/blob/master/code_examples/bash/tutorial.md" target="_blank">The Hacker Within, Berkeley</a>. 

### Get Started with the Terminal 

In the early days of computing, the computer that processed data or performed operations was separate from the tool that gave it the instructions to do the processing. There was: 

* Terminal: which was used to send commands to the computer and
* The computer: the hardware that processed the commands

Today, we have computers that can both provide commands AND perform the computation, and these computers have graphic interfaces (known as GUIs) that make it easy to perform tasks. 

However, we still need to access the command line or terminal for certain tasks. In this lesson, you will learn how to use a command line interface (CLI) or terminal on your computer. 

<figure>
 <a href="{{ site.url }}/images/courses/earth-analytics/python-interface/early-terminal.png">
 <img src="{{ site.url }}/images/courses/earth-analytics/python-interface/early-terminal.png" alt = "An image showing a terminal and a computer in the early days of computing."></a>
 <figcaption> Image of an older computer and terminal.</figcaption>
</figure>

### About Bash

`Bash` is command line program that allows you to efficiently perform many tasks. The command line or terminal is where you provide `Bash` commands that the computer then executes. This allows you to control your computer by typing in commands entered with a keyboard, instead of using buttons or drop down menus in a graphical user interface (GUI) with a mouse/keyboard. 

For example, you can use `Bash` to access and process files at the command line. Working with files at the command line is faster and more efficient than working with files in a graphic environment like Windows Explorer or Mac Finder. 

In `Bash`, you can perform multiple operations on multiple files quickly. You can also write and execute scripts in `Bash` just like you can in `R` or `Python`. 

Finally, you can use `Bash` to launch tools like `Python`, `R` and `Jupyter Notebook`. Throughout this class, you will use `Python` and `Jupyter Notebook`. 

<i class="fa fa-star"></i> **Data Tip:**  
`Bash` stands for “bourne again shell” and is an updated version of Shell. Sometimes you will hear `Bash` and Shell used interchangeably; in this course, we will use the term `Bash`.
{: .notice--success}

You access `Bash` using a terminal program which we will discuss next. 


## What is a Terminal?

A terminal is the command line interface (CLI) that gives you access to `Bash`. There are many different terminal programs, and thus, the terminal program that you use on your computer will vary according to your operating system. 

For instance, Mac computers have a terminal program already installed that provides access to `Bash`. However, on a Windows machine, you will have to install a new program to access `Bash` - like `Git Bash`, which we will use in this course. 

For the rest of this course, we will refer to the command line environment that you use to access `Bash` as the terminal. For Windows users, this terminal can be accessed using a tool like `Git Bash`.


## Why Use the Terminal?

#### Interact With Your Computer and Organize Files 

Using `Bash` in the Terminal is a powerful way of interacting with your computer. GUIs and command line `Bash` are complementary - by knowing both, you will greatly expand the range of tasks you can accomplish with your computer. 

You will also be able to perform many tasks more efficiently. Common tasks that you can run at the command line include checking your current working directory, changing directories, making a new directory, extracting files, and finding files on your computer. 


## Access Bash

How you access `Bash` will depend on your operating system. 

* OS X: The `Bash` program is called Terminal. You can search for it in Spotlight.

* Windows: `Git Bash` came with your download of Git for Windows. Search `Git Bash`. For the rest of this course, even if you are on Windows, we will refer to the Terminal. You are using `Git Bash` as your terminal.

* Linux: Default is usually `Bash`, if not, type `Bash` in the terminal.


## Bash Commands

The dollar sign is a prompt, that shows you that `Bash` is waiting for input; your shell may use a different character as a prompt and may add information before the prompt.

When typing commands, either from these tutorials or from other sources, do not type the dollar sign only the commands that follow it. In these tutorials, subsequent lines that follow a prompt and do not start with $ are the output of the command.



### Basic Bash Commands

* `ls`: This command `lists all files in the current directory in alphabetical order, arranged neatly into columns.


```bash 
$ ls

Applications   Documents   Library   Music   Public
Desktop        Downloads   Movies    Picture
```

Your results may be slightly different depending on your operating system and how you have customized your filesystem.


*  `pwd`: This command prints the name of the directory in which you are currently working.

```bash 
$ pwd 

/Users/earthlab

``` 


* `cd path-to-directory`: The command followed by a path allows you to change into a specified directory (such as a directory named `documents`).
   
* `cd ..` (two dots). The `..` means "the parent directory" of your current directory, so you can use `cd ..` to go back (or up) one directory.

* `cd ~` (the tilde). The `~` means the home directory, so this command will always change back to your home directory (the default directory in which the Terminal opens).  


```bash
$ cd ~
```


* `mkdir directory-name`: This command makes a new directory with the given name.
  The example below will make a new directory called notes inside of the documents directory. 


```bash
$ cd documents 
$ ls documents 

    data/  elements/  animals.txt  planets.txt  sunspot.txt

$ mkdir notes

$ ls documents 

	data/  elements/  notes/  animals.txt  planets.txt  sunspot.txt
```

Notice that `mkdir` command has no ouput. Also, because `notes` is a relative path (i.e., doesn’t have a leading slash), the new directory is created in the current working directory (e.g. `documents`). 

<i class="fa fa-star"></i> **Data Tip:** 
Directory vs Folder: You can think of a directory as a folder. However the term directory considers the relationship between that folder and the folders within it and around it. 
{: .notice--success}


<i class="fa fa-star"></i> **Data Tip:**
Notice that you are creating an easy to read directory name. The name has no spaces and uses all lower case to support machine reading down the road. Sometimes this format of naming using dashes is referred to as a slug.
{: .notice--success}

<div class="notice--warning" markdown="1">

## <i class="fa fa-pencil-square-o" aria-hidden="true"></i> Challenge
    
Project organization is integral to efficient research. In this challenge, you will use `Bash` to create an `earth-analytics` directory that you will use throughout this course. 

You will then create a  `data` directory within the `earth-analytics` directory to save all of the data that you will need to complete the homework assignments and follow along with the course.


### Create a Directory for earth-analytics

Begin by creating an `earth-analytics` directory (or folder) in your home directory. This is the default directory in which the Terminal opens. 

* Create a **new directory** called `earth-analytics`.


``` bash 
$ mkdir earth-analytics 
```


*  Next, change your working directory to the `earth-analytics` directory, and create a new directory within it called `data`.

```bash 
$ cd earth-analytics 
$ mkdir data 
```

* Last, go back to the home directory and confirm that you can then access the directories you just made.

```bash 

$ cd ~ 

$ cd earth-analytics 

$ ls 

data
```

</div>
