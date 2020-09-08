---
layout: single
title: 'Bash Commands to Manage Directories and Files'
excerpt: "Bash or Shell is a command line tool that is used in open science to efficiently manipulate files and directories. Learn how to run useful Bash commands to access and manage directories and files on your computer."
authors: ['Jenny Palomino', 'Leah Wasser']
category: [courses]
class-lesson: ['bash']
permalink: /courses/intro-to-earth-data-science/open-reproducible-science/bash/bash-commands-to-manage-directories-files/
nav-title: "Bash Commands"
dateCreated: 2019-07-15
modified: 2020-09-03
module-type: 'class'
course: "intro-to-earth-data-science-textbook"
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

* Run `Bash` commands to complete the following tasks: 
    * print the current working directory (`pwd`)
    * navigate between directories on your computer (`cd`)
    * create new directories (`mkdir`) 
    * print a list of files and subdirectories within directories (`ls`)
    * delete files (`rm `) and directories (`rm -r`)
    * copy files (`cp`) and directories (`cp -r`) to another directory
    * easily create new files using a single command (`touch`)

</div>
 

## How to Run Bash Commands in the Terminal

In the previous section on Terminal Sessions, you learned that the terminal displays a prompt that shows you that `Bash` is waiting for input. 

```bash
$ bash
    $
```

Recall that depending on your computer's set-up, you may see a different character as a prompt and/or additional information before the prompt, such as your current location within your computer's file structure (i.e. your current working directory).

When typing commands (either from this textbook or from other sources), do not type the dollar sign (or other character prompt). Only type the commands that follow it. 

Note: In the examples on this page, the indented lines that follow a prompt and do not start with a dollar sign ($) are the output of the command. The results of the commands below on your computer will be slightly different, depending on your operating system and how you have customized your file system.

## Useful Bash Commands to Manage Directories and Files

### Print Current Working Directory (`pwd`)

Your current working directory is the directory where your commands are being executed. It is typically printed as the full path to the directory (meaning that you can see the parent directory). 

To print the name of the current working directory, use the command `pwd`.

```bash  
$ pwd 
    /users/jpalomino
```

As this is the first command that you have executed in `Bash` in this session, the result of the `pwd` is the full path to your home directory. The home directory is the default directory that you will be in each time you start a new `Bash` session. 

**Windows users:** note that the `Terminal` uses forward slashes (`/`) to indicate directories within a path. This differs from the Windows File Explorer which uses backslashes (`\`) to indicate directories within a path.   


### Change Current Working Directory (`cd`)

Often, you may want to change the current working directory, so that you can access different subdirectories and files. 

To change directories, use the command `cd` followed by the name of the directory (e.g. `cd downloads`). Then, you can print your current working directory again to check the new path. 

For example, you can change the working directory to an existing `documents` directory under your home directory, and then check that the current working directory has been updated.

```bash
$ cd documents
$ pwd
    /users/jpalomino/documents
```

You can go back to the parent directory of any current directory by using the command `cd ..`, as the full path of the current working directory is understood by `Bash`.

```bash
$ cd ..
$ pwd
    /users/jpalomino
```

You can also go back to your home directory (e.g. `/users/jpalomino`) at any time using the command `cd ~` (the character known as the tilde). 

```bash
$ cd ~
$ pwd
    /users/jpalomino
```

### Create a New Directory (`mkdir`)

The first step in creating a new directory is to navigate to the directory that you would like to be the parent directory to this new directory using `cd`. 

Then, use the command `mkdir` followed by the name you would like to give the new directory (e.g. `mkdir directory-name`). 

For example, you can create a new directory under `documents` called `assignments`. Then, you can navigate into the new directory called `assignments`, and print the current working directory to check the new path.

```bash
$ cd documents
$ mkdir assignments
$ cd assignments
$ pwd
    /users/jpalomino/documents/assignments
```

Notice that `mkdir` command has no output. Also, because `assignments` is provided to `Bash` as a relative path (i.e., doesn’t have a leading slash or additional path information), the new directory is created in the current working directory (e.g. `documents`) by default. 

<i class="fa fa-star"></i> **Data Tip:** 
Directory vs Folder: You can think of a directory as a folder. However, recall that the term directory considers the relationship between that folder and the folders within it and around it. 
{: .notice--success}

<i class="fa fa-star"></i> **Data Tip:**
Notice that you are creating an easy to read directory name. The name has no spaces and uses all lower case to support machine reading down the road. 
{: .notice--success}


### Print a List of Files and Subdirectories  (`ls`)

To see a list of all subdirectories and files within your current working directory, use the command `ls`.

```bash
$ cd ~
$ pwd
    /users/jpalomino
$ ls 
    addresses.txt    documents    downloads    grades.txt    
```
In the example above, `ls` printed the contents of the home directory which contains the subdirectories called `documents` and `downloads` and the files called `addresses.txt` and `grades.txt`. 

You can continue to change your current working directory to a subdirectory such as `documents` and print a new list of all files and subdirectories to see your newly created `assignments` directory.

```bash
$ cd documents
$ ls    
    assignments  
```

You can also create a new subdirectory under `assignments` called `homeworks`, and then list the contents of the `assignments` directory to see the newly created `homeworks`.

```bash
$ cd assignments
$ mkdir homeworks
$ ls    
    homeworks  
```

### Delete a File (`rm`)

To delete a specific file, you can use the command `rm` followed by the name of the file you want to delete (e.g. `rm filename`).

For example, you can delete the `addresses.txt` file under the home directory. 

```bash
$ pwd
    /users/jpalomino
$ ls 
    addresses.txt    documents    downloads    grades.txt 
$ rm addresses.txt
$ ls 
    documents    downloads    grades.txt
```

### Delete a Directory (`rm -r`)

To delete (i.e. remove) a directory and all the sub-directories and files that it contains, navigate to its parent directory, and then use the command `rm -r` followed by the name of the directory you want to delete (e.g. `rm -r directory-name`). 

For example, you can delete the `assignments` directory under the `documents` directory because it does not meet the requirement of a good name for a directory (i.e. not descriptive enough - what kind of assignments?).

```bash
$ cd ~
$ cd documents
$ pwd
    /users/jpalomino/documents
$ ls    
    assignments  
$ rm -r assignments
```

The `rm` stands for remove, while the `-r` is necessary to tell `Bash` that it needs to recurse (or repeat) the command through a list of all files and sub-directory within the parent directory. 

Thus, the newly created `homeworks` directory under `assignments` will also be removed, when `assignments` is deleted.

```bash
$ pwd
    /users/jpalomino/documents
$ ls
$
```

### Copy a File (`cp`)

You can also copy a specific file to a new directory using the command `cp` followed by the name of the file you want to copy and the name of the directory to where you want to copy the file (e.g. `cp filename directory-name`). 

For example, you can copy `grades.txt` from the home directory to `documents`. 

```bash
$ cd ~
$ pwd
    /users/jpalomino
$ ls 
    documents    downloads    grades.txt
$ cp grades.txt documents
$ cd documents
$ ls
    grades.txt
```

Note that the original copy of the file remains in the original directory, so you would now have two copies of `grades.txt`, the original one in the home directory and the copy under `documents`.

```bash
$ cd ~
$ pwd
    /users/jpalomino
$ ls 
    documents    downloads    grades.txt
```

### Copy a Directory and Its Contents (`cp -r`)

Similarly, you can copy an entire directory to another directory using `cp -r` followed by the directory name that you want to copy and the name of the directory to where you want to copy the directory (e.g. `cp -r directory-name-1 directory-name-2`). 

Similar to `rm -r`, `-r` in `cp -r` is necessary to tell `Bash` that it needs to recurse (or repeat) the command through a list of all files and sub-directory within the parent directory.

```bash
$ cd ~
$ pwd
    /users/jpalomino
$ ls 
    documents    downloads    grades.txt
$ mkdir pics
$ ls 
    documents    downloads    grades.txt    pics
$ cp -r pics documents
$ cd documents
$ ls
    grades.txt    pics
```

Once again, the original copy of the directory remains in the original directory. 

```bash
$ cd ~
$ pwd
    /users/jpalomino
$ ls 
    documents    downloads    grades.txt    pics
```

### Create a New File Using a Single Command (`touch`)

You can create a new empty file using the single command `touch` (e.g. `touch file-name.txt`). This command was originally created to manage the timestamps of files. However, if a file does not already exist, then the command will make the file. 

This is an incredibly useful way to quickly and programmatically create a new empty file that can be populated at a later time.   

```bash
$ cd ~
$ cd downloads
$ pwd
    /users/jpalomino/downloads
$ touch veg-data.txt
$ ls
    veg-data.txt
```

<div class="notice--warning" markdown="1">

## <i class="fa fa-pencil-square-o" aria-hidden="true"></i> Practice Your Bash Skills
    
Project organization is integral to efficient research. In this challenge, you will use `Bash` to create an `earth-analytics` directory that you will use throughout this textbook. 

You will then create a  `data` directory within the `earth-analytics` directory to save all of the data that you will need to complete the homework assignments and follow along with the course.


### Create a Directory for earth-analytics

Begin by creating an `earth-analytics` directory (or folder) in your home directory. Recall that this is the default directory in which the Terminal opens. 

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
