---
layout: single
category: courses
title: 'Text Editors for the Command Line and Scientific Programming'
excerpt: 'Text editors can be used to edit code and for commit messages in git. Learn about features to look for in a text editor and how to change your default text editor at the command line.'
authors: ['Martha Morrissey', 'Leah Wasser',  'Data Carpentry']
modified: 2018-07-30
module: "setup-earth-analytics-environment"
permalink: /workshops/setup-earth-analytics-python/text-editors-for-science-workflows/
nav-title: 'Text Editors For Coding'
week: 0
sidebar:
    nav:
author_profile: false
comments: true
order: 5
topics:
    reproducible-science-and-programming: ['python']
---
{% include toc title="In This Lesson" icon="file-text" %}

In this lesson you will learn about features to look for in a text editor and how to change your default text editor at the command line

<div class='notice--success' markdown="1">


## <i class="fa fa-graduation-cap" aria-hidden="true"></i> Learning Objectives

At the end of this activity, you will be able to:

* Explain how text editors are used in a scientific workflow

* Change your default text editor in the command line


## <i class="fa fa-check-square-o fa-2" aria-hidden="true"></i> What You Need


Make sure you have followed the installation instructions already from [Setup Git/Bash lesson.](/workshops/setup-earth-analytics-python/setup-git-bash-anaconda/ ) 

Information below is adapted from materials by <a href="http://software-carpentry.org/" target = "_blank">Software Carpentry</a> and <a href = "https://cs61a.org/articles/vim.html#introduction" target = "_blank">UC Berkeley CS61a</a>.


</div>


## Why You Need a Good Text Editor

The right text editor and / or coding gui (graphical user interface) environments makes a scientific workflow more efficient. You will use text editors for many different purposes including:
Interacting with tools at that command line: For example, you use a text editor when you use git for version control to write merge and commit message.
Writing bash scripts to process files: If you want to very quickly process a large set of text files, you will often use bash / the command line. You will use a text editor to write that script.
Scientific programming: Many scientists and coders work in a text editor to write their code. 
Often the default text editor setup for your command line environment, is not a graphical text editor. You may want to change the default text editor depending on your workflow. 
In this lesson, you will learn about the different features to look for in a text editor and how to set your default text editor.

## Features to Look For in a Text Editor

Certain features to look for in a text editor include:

* Automatic Color-coding: In a normal text editor, all of the text is the same color. However, when the text editor is optimized for coding, different parts of your code will be colored in different ways. For instance, all comments might be displayed using the color grey. Common functions may be blue and so on. This allows you to quickly scan and easily review and scan your code. 

<figure>
 <a href="{{ site.url }}/images/courses/earth-analytics-python/python-interface/non-color-code.png">
 <img src="{{ site.url }}/images/courses/earth-analytics-python/python-interface/non-color-code.png"></a>
 <figcaption> Code that is rendered in a text editor with no color coding.
 </figcaption>
</figure>



<figure>
 <a href="{{ site.url }}/images/courses/earth-analytics-python/python-interface/color-code.png">
 <img src="{{ site.url }}/images/courses/earth-analytics-python/python-interface/color-code.png"></a>
 <figcaption> Notice that various types of commands are colored differently making is easier to quickly scan and review the code.
 </figcaption>
</figure>


* Running Code: A text editor lets you write and save a script that is ready to be run in the terminal. Some text editors and gui environments also allow you to run code inline.

* Find and Replace: If you want to change a word that you’ve used multiple times in a file instead of manually changing that word many times, you can use the find and replace feature to let the text editor automatically change that word. 

Some scientists will only code in a text editor. Others will use a text editor for some tasks and Jupyter Notebooks (or some other coding GUI) for others. You will figure out your preferred workflow as you code more!


## What is your Default Text Editor?

Most operating systems come with a default text editor as described below. While choosing a text editor is a very personal preference, for this course,  if you don’t already have a favorite, we  recommend the [Atom](https://atom.io/) text editor which will run on mac, linux, and windows. You can use whatever text editor you are most comfortable, but mainly for this course we will be working in Jupyter Notebook. However, it is important to be familiar with text editors because they are powerful tools that many scientists use to write code. If you use git, you will need a text editor to create some commit and merge messages. 


## The Vim Text Editor 

Vim is the default text editor for  Mac OS X, Linux, and Windows (if windows has git bash installed). Vim is a text editor designed to support the command line / terminal interface. This means that rather than buttons to save, open and close files, you need to use the correct key commands as follows:


To open vim, type `vim` at the command line. Like this:

```bash
Vim
```

When you open vim, you’ll get a screen like the one below:
<figure>
 <a href="{{ site.url }}/images/courses/earth-analytics-python/python-interface/vim.png">
 <img src="{{ site.url }}/images/courses/earth-analytics-python/python-interface/vim.png"></a>
 <figcaption> Welcome screen of vim.
 </figcaption>
</figure>

Once you are in vim there is one core commands that you need to know about - how to exit vim. 

**How to exit vim** : If you need to exit vim, type the following: hit escape to bring up a prompt where you can type. Then type `:q!` (colon, lower-case 'q', exclamation mark). Hit return and you will return to the terminal. 


### How To Edit A New file in Vim

If you want to edit a new file in vim, then you need to be in insert mode. Insert mode, which allows you to use Vim like a regular text editor -- you press keys, and the corresponding characters will show up on the screen. 

* To enter the insert mode press `i`, 
* When you are done editing your file, you may want to save it. There are 5 steps to saving and the exiting a file 
    1. Enter normal mode (press ESC)
    2. Enter command mode (press :)
    3. (Press w) filename.txt 
    4. (Press Enter)
    5. Exit Vim :q! Return 
    

<i class="fa fa-star"></i> **Data Tip:**
Before saving a file in vim it’s a good idea to check what your working directory is because that’s where it will be saved. To do that after you are in the command mode type pwd. If you would want to save that file in a different directory Press w filepath/filename.txt
{: .notice--success }


### How to Open an Existing File in Vim

* Next, let’s open the earth-analytics.txt file that we just saved from vim. To open an existing file, type  
  `Vim name-of-file-here`
  
  
 
```bash
vim earth-analytics-test.txt
```


### How to Edit an Existing File in Vim

* To edit files make sure you are in the insert mode by pressing `i`. To save your edits follow the file save    commands:
    + Enter normal mode (press ESC)
    + Enter command mode (press :)
    + Press w filename.txt 
    + Press Enter
    + Exit Vim :q! Return 
    
    
If you are working on Linux or on may cloud and High Performance Communing (HPC) environments you may prefer a non-graphical text editor like Vim. However for this course, if you are running a Mac or Windows operating system and haven’t used Vim before, we recommend you work in Atom. 


## Commonly Used Text Editors

You can define any text editor that is installed on your computer, as the default text editor. A few that are often uses include: 
* [Atom](https://atom.io/)
* [Sublime Text](http://www.sublimetext.com/) 
* [Notepad ++  (just Windows)](https://notepad-plus-plus.org/)
* [Nano](https://www.nano-editor.org/)


<div class =  'notice--success' markdown = 1 >
### Why we recommend using Atom

If you don’t already have a favorite text editor, we suggest you use Atom in this course. We like atom because:
* It’s free and open source! 
* It supports [git / github integration](https://earthdatascience.org/courses/intro-version-control-git/) which makes it easier to collaborate with others to write code, address merge conflicts and other common git operations. 
* It has code highlighting support
* Atom has an active development community which means lots of extra packages are available to gain extra features. For example: [Markdown Preview](https://github.com/atom/markdown-preview) lets you write code in markdown in a .md file and preview the rendered output in a different window. [Hydrogen package](https://atom.io/packages/hydrogen), allows you to run code inline in Atom, similar to a Jupyter notebook. 
 </div>


### Check and Change Your Default Text Editor

Check Default Editor 

```bash 
$ git var -l 
```
Look at the GIT_EDITOR part of the output. Vi means vim. 

`GIT_EDITOR=vi`

To change your default text editor, you can use `git config` - IF git is installed on your computer already. Open your terminal and use the table below to change your default text editor. IMPORTANT: in order to change your default text editor, the text editor of your choice needs to be already installed on your computer! If it is not installed, the command below will not work.





Editor | Configuration command 
------ |------
Atom |  git config --global core.editor "atom --wait"
nano |  git config --global core.editor "nano -w"
Sublime Text (Mac) |  git config --global core.editor "subl -n -w"
Sublime Text (Win, 32-bit install) | git config --global core.editor "'c:/program files (x86)/sublime text  3/sublime_text.exe' -w"
Sublime Text (Win, 64-bit install)| git config --global core.editor "'c:/program files/sublime text 3/sublime_text.exe' -w"
Notepad++ (Win, 32-bit install)| git config --global core.editor "'c:/program files (x86)/Notepad++/notepad++.exe' -multiInst -notabbar -nosession -noPlugin"
Notepad++ (Win, 64-bit install) | git config --global core.editor "'c:/program files/Notepad++/notepad++.exe' -multiInst -notabbar -nosession -noPluginin”











<div class="notice--info" markdown="1">

## Additional Resources

If you are interested in learning more about the features of [atom](https://cs61a.org/articles/atom.html), [sublime](https://cs61a.org/articles/sublime.html), or [vim](https://cs61a.org/articles/vim.html) check out these guides. 

Vim also has a built-in interactive guide, which you can start from the terminal by typing. This tutorial will help you get accustomed to basic Vim commands. 


```bash
vimulator 
```


</div>


