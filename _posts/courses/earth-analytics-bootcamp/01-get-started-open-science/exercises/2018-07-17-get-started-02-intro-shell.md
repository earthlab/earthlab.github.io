---
layout: single
title: 'Intro to Shell'
excerpt: "This lesson walks you through using Bash/Shell to navigate and manage files and directories on your computer."
authors: ['Jenny Palomino', 'Leah Wasser', 'Martha Morrissey',  'Software Carpentry']
category: [courses]
class-lesson: ['get-started-with-open-science']
permalink: /courses/earth-analytics-bootcamp/get-started-with-open-science/intro-shell/
nav-title: "Intro to Shell"
dateCreated: 2018-06-27
modified: 2018-08-08
module-type: 'class'
class-order: 1
course: "earth-analytics-bootcamp"
week: 1
sidebar:
  nav:
author_profile: false
comments: true
order: 2
topics:
  reproducible-science-and-programming: ['shell']
---
{% include toc title="In This Lesson" icon="file-text" %}

In this lesson, you will learn how to use `Bash`/`Shell` to navigate and manage directories on your computer. 

<div class='notice--success' markdown="1">

## <i class="fa fa-graduation-cap" aria-hidden="true"></i> Learning Objectives

After completing this lesson, you will be able to:
* Explain the roles of `Shell`, `Bash`, and `Terminal` for accessing files and programs on your computer 
* Explain what a directory is
* Use `Bash` to complete the following tasks: 
    * print the current working directory (pwd)
    * navigate between directories on your computer (cd)
    * create new directories (mkdir)
    * print a list of files (and sub-directories) within directories (ls)
    * delete directories (rm -r)
 
## <i class="fa fa-check-square-o fa-2" aria-hidden="true"></i> What You Need

Be sure that you have completed the instructions on <a href="{{ site.url }}/workshops/setup-earth-analytics-python/setup-git-bash-anaconda/">Setting up Git, Bash, and Anaconda on your computer</a> to install the tools for your operating system (Windows, Mac, Linux). 
 
</div>


## Shell, Bash, and Terminal - An Overview

In the lesson on Open Reproducible Science, you learned that `Shell` is the primary program that computers use to receive code (i.e. commands) and return information produced by executing these commands (i.e. output). 

These commands can be entered via a `Terminal` (i.e. Command Line Interface - CLI) or can be executed via software, which provide graphical user interfaces (GUIs) that send commands to the `Shell` and receive output back from the `Shell` when the command has been executed. 

`Bash` (also known as the "Bourne-Again Shell") is an implementation of `Shell` and provides many commands that can be executed via a `Terminal`. You will only use a handful of commands in this course, but more information on the available commands is provided on the bottom of this page under Additional Resources.

There are also many options for terminals, including customized ones like `Git Bash`, which Windows users will use in this course. 


### Why Is Shell Important for Open Reproducible Science

`Shell` helps you to:
* easily navigate your computer to access and manage files and folders (i.e. directories) 
* quickly and efficiently work with many files and directories at once
* run programs that provide more functionality at the command line (e.g. `Git`)
* launch programs from specific directories on your computer (e.g. `Jupyter Notebook`)
* use repeatable commands for these tasks across many different operating systems (Windows, Mac, Linux)


## What Is a Directory?

A directory refers to a folder on a computer that relates to other folders. The term directory considers the relationship between that folder and the folders within it and around it. Directories are hierarchical. 


### What Is a Parent Directory?

The term "parent" directory is used to describe the preceding directory in which a sub-directory is created.


## Open a Terminal to Run Bash Commands

The tool that you use to run bash commands will vary depending upon your computer's operating system.

### Mac (OS X)
You can use the program called `Terminal`, which can be searched for in Spotlight (or found in /Applications/Utilities) and uses the Bash implementation of Shell. Terminal is installed natively on the MAC OS.

<figure>
   <a href="https://help.apple.com/assets/58C4E5B4680CE2040551BA60/58C4E5B6680CE2040551BA69/en_US/84239026ca019f46567b86e900f5edd7.png">
   <img src="https://help.apple.com/assets/58C4E5B4680CE2040551BA60/58C4E5B6680CE2040551BA69/en_US/84239026ca019f46567b86e900f5edd7.png" alt="This is what the Terminal on Mac looks like. Source: Apple.com."></a>
   <figcaption>This is what the Terminal on Mac looks like. Source: Apple.com.
   </figcaption>
</figure>



### Linux

You can use the program called `Terminal` (or `Terminal Emulator`), which typically uses the Bash implementation of Shell. 

<figure>
 <a href="{{ site.url }}/images/courses/earth-analytics/bootcamp/terminal/linux-terminal.png" width = "125%">
 <img src="{{ site.url }}/images/courses/earth-analytics/bootcamp/terminal/linux-terminal.png" alt="This is what the Terminal on Linux looks like." width = "125%"></a>
 <figcaption> This is what the Terminal on Linux looks like.
 </figcaption>
</figure>

### Windows

There are many options for running bash on windows. For this course, you will use `Git Bash` which comes with your installation of `Git`. Instructions for setting this up are here: 

* <a href="{{ site.url }}/workshops/setup-earth-analytics-python/setup-git-bash-anaconda/" target = "_blank">Setting up Git, Bash, and Anaconda on your computer</a>

Once you have installed `Git` on a Windows machine, you can open this Terminal by searching for `Git Bash` in the start menu. Use `Git Bash` for all hands-on activities and assignments in this course that ask you to use the `Terminal`. 

<figure>
 <a href="{{ site.url }}/images/courses/earth-analytics/bootcamp/terminal/git-bash-terminal.png">
 <img src="{{ site.url }}/images/courses/earth-analytics/bootcamp/terminal/git-bash-terminal.png" alt="This is what the Git Bash Terminal on Windows looks like."></a>
 <figcaption> This is what the Git Bash Terminal on Windows looks like.
 </figcaption>
</figure>


## Run Bash Commands in the Terminal
The dollar sign ($) is a prompt that shows you that `Bash` is waiting for input. 

```bash
$ bash
    $
```

Note: depending on your computer's set-up, you may see a different character as a prompt and/or may add information before the prompt, such as the directory that you are currently in.

When typing commands (either from this course or from other sources), do not type the dollar sign (or other character prompt). Only type the commands that follow it. 

### Test That Bash Is Available on Your Computer

Type "bash" into the `Terminal`. You will only get a message back if the command is not successful. If the command is successful, you will simply see a new line prompt waiting for more input.

```bash
$ bash
    $
```

Note: In the examples below, the indented lines that follow a prompt and do not start with a dollar sign ($) are the output of the command. The results of the commands below on your computer will be slightly different, depending on your operating system and how you have customized your file system.


### Print Your Current Working Directory (`pwd`)
Your current working directory is the directory where your commands are being executed. It is typically printed as the full path to the directory (meaning that you can see the parent directory). To print the name of the current working directory, use the command `pwd`.

```bash  
$ pwd 
    /users/jpalomino
```

As this is the first command that you have executed in `Bash` today, the result of the `pwd` is the full path to your home directory. The home directory is the first directory that you will be in each time you start a new `Bash` session. 

**Windows users:** note that the `Terminal` uses forward slashes (`/`) to indicate directories within a path. This differs from the Windows File Explorer which uses backslashes (`\`) to indicate directories within a path.   


### Change Working Directory (`cd`)

To change directories, use the command `cd` followed by the name of_directory (e.g. `cd downloads`). You can print your current working directory again to check the new path. 

For example, you can change the working directory to `documents` under your home directory, and then check that the current working directory has been updated.

```bash
$ cd documents
$ pwd
    /users/jpalomino/documents
```

You can go back to the parent directory by using the command `cd ..`. The full path to the current working directory is understood by Bash.

```bash
$ cd ..
$ pwd
    /users/jpalomino
```

You can also go back to your home directory (e.g. /users/jpalomino) at any time using the command `cd ~` (the character known as the tilde). 

```bash
$ cd ~
$ pwd
    /users/jpalomino
```

### Create a New Directory (`mkdir`)

The first step in creating a new directory is to navigate to the directory that you would like to be the parent directory to this new directory. Then, use the command `mkdir`, followed by the name you would like to give the new directory (e.g. `mkdir directoryname`). 

For example, you can create new directory under `documents` called `assignments`. Then, you can navigate into the new directory called `assignments`, and print the current working directory to check the new path.

```bash
$ cd documents
$ mkdir assignments
$ cd assignments
$ pwd
    /users/jpalomino/documents/assignments
```

Use 'cd ~' to return to your home directory.

```bash
$ cd ~
$ pwd
    /users/jpalomino
```

### Machine Readable Directory Names Are Important

As you create new directories, consider the names carefully. 

* Use names that clearly describe what the directory contains.
* Don't use spaces in your names. Instead of spaces, you can use `-` or `_` to separate words within the name.

In the image below, compare the list of file names on the LEFT to those on the right. Which ones are easier to quickly understand? 

<figure>
   <a href="https://www.earthdatascience.org/images/slide-shows/intro-rr/human-readable-jenny.png">
   <img src="https://www.earthdatascience.org/images/slide-shows/intro-rr/human-readable-jenny.png" alt="This image displays examples of good and not-so-good names for directories and files. Source: Jenny Bryan, Reproducible Science Curriculum."></a>
   <figcaption>This image displays examples of good and not-so-good names for directories and files. Source: Jenny Bryan, Reproducible Science Curriculum.   
   </figcaption>
</figure>



<i class="fa fa-exclamation-circle" aria-hidden="true"></i> **Windows Users:** note that the names of your existing directories often begin with upper case letters. When creating new directories, use lower case to follow the lessons more easily and for best results from future programming tasks.
{: .notice--success}



### Print a List of All Files and Sub-directories  (`ls`)

To see a list of all files and sub-directories within your current working directory, use the command `ls`.

```bash
$ pwd
    /users/jpalomino
$ ls 
    documents    downloads    
```
For example, you can change your current working directory to `documents` and print a new list of all files and sub-directories to see our newly created `assignments` directory by using the `cd` and `ls` functions. 

```bash
$ cd documents
$ ls    
    assignments  
```

You can also create a new directory under `assignments` called `homeworks`, and then list the contents of the `assignments` directory to see the newly created `homeworks`.

```bash
$ cd assignments
$ mkdir homeworks
$ ls    
    homeworks  
```

### Delete a Directory (`rm`)

To delete (i.e. remove) a directory and all the sub-directories and files that it contains, navigate to its parent directory and use the command `rm -r`, followed by the name of the directory you want to delete (e.g. `rm -r directoryname`). 

For example, you can delete the `assignments` directory under the `documents` directory because it does not meet the requirement of a good name for a directory.

```bash
$ cd ~
$ cd documents
$ pwd
    /users/jpalomino/documents
$ ls    
    assignments  
$ rm -r assignments
```

The `rm` stands for remove, while the `-r` is necessary to tell Bash that it needs to recurse or repeat the command) through a list of all files and sub-directory within the parent directory. This means that the newly created `homeworks` directory under `assignments` will also be removed.

## Close the Terminal

You can close the terminal at any time by typing the command `exit` and hitting `Enter`.

For now, leave the `Terminal` open, so you can complete the rest of this lesson.

<div class="notice--warning" markdown="1">

## <i class="fa fa-pencil-square-o" aria-hidden="true"></i> Optional Challenge 

Test your `Bash` skills to:

1. Create a new directory called `earth-analytics-bootcamp` in your home directory (hint: `cd`, `mkdir`).

2. Check that `earth-analytics-bootcamp` has been successfully created in your home directory (hint: `ls`).

3. Change the directory to `earth-analytics-bootcamp` and create a new directory called `data` (hint: `cd`, `mkdir`). 

4. Check that `data` has been successfully created in `earth-analytics-bootcamp`  (hint: `ls`).

</div>
