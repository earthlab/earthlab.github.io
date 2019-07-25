---
layout: single
title: 'Terminal Sessions'
excerpt: "This section covers how to open and close terminal sessions across different operating systems and test that Bash is ready for use on your computer."
authors: ['Jenny Palomino', 'Leah Wasser']
category: [courses]
class-lesson: ['bash']
permalink: /courses/intro-to-earth-analytics/bash/terminal-session/
nav-title: "Terminal Sessions"
dateCreated: 2019-07-15
modified: 2019-07-16
module-type: 'class'
class-order: 1
course: "intro-to-earth-analytics"
week: 2
sidebar:
  nav:
author_profile: false
comments: true
order: 3
topics:
  reproducible-science-and-programming: ['shell']
---
{% include toc title="In This Section" icon="file-text" %}

In this section, you will learn how to open and close terminal sessions across different operating systems including Windows, Mac, and Linux. You will also test that `Bash` is ready for use on your computer. 

<div class='notice--success' markdown="1">

## <i class="fa fa-graduation-cap" aria-hidden="true"></i> Learning Objectives

After completing this lesson, you will be able to:

* Open and close terminal sessions on your computer.
* Test that `Bash` is ready for use on your computer.


## <i class="fa fa-check-square-o fa-2" aria-hidden="true"></i> What You Need

Be sure that you have completed the instructions on <a href="{{ site.url }}/workshops/setup-earth-analytics-python/setup-git-bash-anaconda/">Setting up Git, Bash, and Anaconda on your computer</a> to install the tools for your operating system (Windows, Mac, Linux). 

 </div>
 

## Terminal Options

In the previous section, you learned that a terminal is the command line interface (CLI) that gives you access to `Bash`. There are many different terminal programs, and thus, the terminal that you use on your computer will vary according to your operating system. 

For instance, Mac as well as many Linux computers have a default terminal program installed that provides access to `Bash`. However, the default terminal on Windows computers does not provide access to `Bash`. 

For this textbook, Windows users will need to install a customized terminal called `Git Bash` to access and run `Bash` commands (see section above on What You Need).

Throughout the textbook, the command line environment that you use to access `Bash` will be referred to as the terminal. 


## Open a Terminal Session

The terminal program that you use to run `Bash` commands will vary depending upon your computer's operating system.

### Mac (OS X)

You can use the program called Terminal, which uses the `Bash` implementation of `Shell` and is installed natively on the Mac OS. 

You can open Terminal by finding and launching it from Spotlight (or from `/Applications/Utilities`).

<figure>
   <a href="https://help.apple.com/assets/58C4E5B4680CE2040551BA60/58C4E5B6680CE2040551BA69/en_US/84239026ca019f46567b86e900f5edd7.png">
   <img src="https://help.apple.com/assets/58C4E5B4680CE2040551BA60/58C4E5B6680CE2040551BA69/en_US/84239026ca019f46567b86e900f5edd7.png" alt="This is what the Terminal on Mac looks like. Source: Apple.com."></a>
   <figcaption>This is what the Terminal on Mac looks like. Source: Apple.com.
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
