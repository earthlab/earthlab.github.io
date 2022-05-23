---
layout: single
title: 'Introduction to Bash (Shell) and Manipulating Files and Directores at the Command Line'
excerpt: "Bash or Shell is a command line tool that is used in open science to efficiently manipulate files and directories. Learn how to use Bash to manipulate files in support of reproducible science."
authors: ['Jenny Palomino', 'Leah Wasser']
category: [courses]
class-lesson: ['bash']
permalink: /courses/intro-to-earth-data-science/open-reproducible-science/bash/
nav-title: "Introduction to Bash"
dateCreated: 2019-07-15
modified: 2020-09-14
module-title: 'Bash'
module-nav-title: 'Use Bash to Manipulate Files'
module-description: "Bash or Shell is a command line tool that is used in open science to efficiently manipulate files and directories. Learn how to use Bash to access and move files and directories."
module-type: 'class'
chapter: 2
class-order: 2
course: "intro-to-earth-data-science-textbook"
week: 1
estimated-time: "1 hour"
difficulty: "beginner"
sidebar:
  nav:
author_profile: false
comments: true
order: 1
topics:
  reproducible-science-and-programming: ['shell']
redirect_from:
  - "/courses/earth-analytics-bootcamp/get-started-with-open-science/intro-shell/"  
---

{% include toc title="In This Chapter" icon="file-text" %}

<div class='notice--success' markdown="1">

## <i class="fa fa-ship" aria-hidden="true"></i> Chapter Two - Introduction to Bash

In this chapter, you will learn how using `Bash` can help you implement open reproducible science workflows and get familiar with useful commands for accessing items on your computer. 

After completing this chapter, you will be able to:

* Explain the roles of `Terminal`, `Shell`, and `Bash` for accessing programs and other items on your computer. 
* Launch a `Terminal` session to access `Bash`.
* Run `Bash` commands in the terminal to work with files and directories on your computer.
* Test that `Bash` is ready for use on your computer.


## <i class="fa fa-check-square-o fa-2" aria-hidden="true"></i> What You Need

Be sure that you have completed the instructions on <a href="{{ site.url }}/workshops/setup-earth-analytics-python/">Setting up Git, Bash, and Conda on your computer</a> to install the tools for your operating system (Windows, Mac, Linux). 

</div>


## Terminal, Shell, and Bash - An Overview

### Terminal

In the early days of computing, the computer that processed data or performed operations was separate from the tool that gave it the instructions to do the processing. There was: 

* The terminal: which was used to send commands to the computer and
* The computer: the hardware that processed the commands

Today, there are computers that can both provide commands AND perform the computation, and these computers have graphical user interfaces (known as GUIs) that make it easy to perform tasks. 

However, accessing the command line or terminal can often be more efficient than using GUIs for certain tasks, and you can send commands via the terminal to programmatically accomplish these tasks. For example, working with files in the terminal is faster and more efficient than working with files in a graphic environment like Windows Explorer or the Finder on a MAC. 

You can also use the terminal to launch and execute open reproducible science tools such as `Jupyter Notebook`, `Python`, and `git`, which you will use throughout this textbook. 

<figure>
 <a href="{{ site.url }}/images/courses/earth-analytics/python-interface/early-terminal.png">
 <img src="{{ site.url }}/images/courses/earth-analytics/python-interface/early-terminal.png" alt="An image showing a terminal and a computer in the early days of computing."></a>
 <figcaption> Image of an older computer and terminal.</figcaption>
</figure>    

### Shell and Bash

In the chapter on Open Reproducible Science, you learned that `Shell` is the primary program that computers use to receive code (i.e. commands) and return information produced by executing these commands (i.e. output). 

These commands can be entered and executed via the terminal. This allows you to control your computer by typing in commands with a keyboard, instead of using buttons or drop down menus in a GUI with a mouse/keyboard.

`Bash` (also known as the "Bourne Again SHell") is an implementation of `Shell` and allows you to efficiently perform many tasks. For example, you can use `Bash` to perform operations on multiple files quickly via the command line. 

You can also write and execute scripts in `Bash`, just like you can in `R` or `Python`, that can be executed across different operating systems. 

<i class="fa fa-star"></i> **Data Tip:**  
`Bash` stands for “Bourne Again SHell” and is an updated version of `Shell`. Sometimes you will hear `Bash` and `Shell` used interchangeably; this textbook uses the term `Bash`.
{: .notice--success}


## Why Is Bash Important for Open Reproducible Science

Using `Bash` in the Terminal is a powerful way of interacting with your computer. GUIs and command line `Bash` are complementary—by knowing both, you will greatly expand the range of tasks you can accomplish with your computer. 

With `Bash` commands, you will be able to perform many tasks more efficiently and automate and replicate workflows across different operating systems. Common tasks that you can run at the command line include checking your current working directory, changing directories, making a new directory, extracting files, and finding files on your computer. 

Working in the terminal with `Bash` provides you with the ability to:
* easily navigate your computer to access and manage files and folders (i.e. directories). 
* quickly and efficiently work with many files and directories at once.
* run programs that provide more functionality at the command line (e.g. `git`).
* launch programs from specific directories on your computer (e.g. `Jupyter Notebook`).
* use repeatable commands for these tasks across many different operating systems (Windows, Mac, Linux).


## Terminal Options For Bash

Previously, you learned that a terminal is the command line interface (CLI) that gives you access to `Bash`. There are many different terminal programs, and thus, the terminal that you use on your computer will vary according to your operating system. 

For instance, Mac as well as many Linux computers have a default terminal program installed that provides access to `Bash`. However, the default terminal on Windows computers does not provide access to `Bash`. 

For this textbook, Windows users will need to install a customized terminal called `Git Bash` to access and run `Bash` commands (see section above on What You Need).

Throughout the textbook, the command line environment that you use to access `Bash` will be referred to as the terminal. 


## Open a Terminal Session On Your Computer

The terminal program that you use to run `Bash` commands will vary depending upon your computer's operating system.

### Mac (OS X)

You can use the program called Terminal, which uses the `Bash` implementation of `Shell` and is installed natively on the Mac OS. 

You can open Terminal by finding and launching it from Spotlight (or from `/Applications/Utilities`).

<figure>
   <a href="{{ site.url }}/images/earth-analytics/bash/mac-terminal.png">
   <img src="{{ site.url }}/images/earth-analytics/bash/mac-terminal.png" alt="This is what the Terminal on Mac looks like. Source: Apple.com."></a>
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

* <a href="{{ site.url }}/workshops/setup-earth-analytics-python/">Setting up Git, Bash, and Conda on your computer</a> 

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

