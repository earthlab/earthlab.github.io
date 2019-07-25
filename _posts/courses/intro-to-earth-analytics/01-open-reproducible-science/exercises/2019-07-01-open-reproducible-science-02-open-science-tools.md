---
layout: single
title: 'Tools For Open Reproducible Science'
excerpt: "This section introduces key tools for implementing open reproducible science workflows."
authors: ['Jenny Palomino', 'Leah Wasser']
category: [courses]
class-lesson: ['open-reproducible-science']
permalink: /courses/intro-to-earth-analytics/open-reproducible-science/open-science-tools/
nav-title: "Tools for Open Reproducible Science"
dateCreated: 2019-07-01
modified: 2019-07-10
module-type: 'class'
class-order: 1
course: "intro-to-earth-analytics"
week: 1
sidebar:
  nav:
author_profile: false
comments: true
order: 2
topics:
  reproducible-science-and-programming: ['python']
---
{% include toc title="In This Section" icon="file-text" %}

In this section, you will learn about key tools that can help you implement open reproducible science workflows. 

<div class='notice--success' markdown="1">

## <i class="fa fa-graduation-cap" aria-hidden="true"></i> Learning Objectives

After completing this lesson, you will be able to:

* Describe how key open science tools can help you implement open reproducible science workflows

## <i class="fa fa-check-square-o fa-2" aria-hidden="true"></i> What You Need

You will need a web browser to review the material. 

 </div>
 

## Useful Tools in the Open Reproducible Science Toolbox

To implement open science workflows, you need tools that help you document and share various aspects of your workflow, such as the details of the data collection or your code for data analysis. 

Throughout this textbook, you will learn how to use various open science tools that will help you: 
* document your work, so that others and your future self can understand your workflow.
* generate reports that connect your data, code (i.e. methods used to process the data), and outputs and publish them in different formats (`HTML`, `PDF`, etc).
* automate your workflows, so that they can be re-run by others and your future self.
* share your workflows and collaborate with others.

While there are many tools that support open reproducible science, you will learn how to implement open science workflows throughout this textbook using: `Shell`, `Git`/`Github.com`, and `Python` in `Jupyter Notebook`. 


### Shell

`Shell` is the primary program that computers use to receive code (i.e. commands) and return information produced by executing these commands (i.e. output). These commands can be entered via a `Terminal` (i.e. Command Line Interface - CLI), which you will work with in this course. 

Using a `Shell` helps you to:
* easily navigate your computer to access and manage files and folders (i.e. directories). 
* quickly and efficiently work with many files and directories at once.
* run programs that provide more functionality at the command line (e.g. the `git` tool suite).
* launch programs from specific directories on your computer (e.g. `Jupyter Notebook` for interactive programming).
* use repeatable commands for these tasks across many different operating systems (Windows, Mac, Linux).

In later chapters, you will learn how to use a `Shell` to access and manage files on your computer and to run other programs that can be started or run from the `Terminal`, such as `Jupyter Notebook` and `git`.

<figure>
   <a href="https://help.apple.com/assets/58C4E5B4680CE2040551BA60/58C4E5B6680CE2040551BA69/en_US/84239026ca019f46567b86e900f5edd7.png">
   <img src="https://help.apple.com/assets/58C4E5B4680CE2040551BA60/58C4E5B6680CE2040551BA69/en_US/84239026ca019f46567b86e900f5edd7.png" alt="This is what the Terminal on Mac looks like. Source: Apple.com."></a>
   <figcaption>This is what the Terminal on a Mac looks like. Source: Apple.com.
   </figcaption>
</figure>


### Git and GitHub

`Git` is a useful tool that helps you to monitor and track changes in files, a process referred to as version control. `GitHub` is a cloud-based implementation of `git`, which allows you to store and manage your files and the associated changes in the cloud on `Github.com`.

These tools work together to support the sharing of files and collaboration within workflows. With `git`, you can work on your files locally and then upload changes to the cloud version of your files on `Github.com`. You can choose to share your files on `Github.com` with others, who can review the files and suggest changes. 

In later chapters, you will learn how to use the `git`/`GitHub` workflow to implement version control for your files as well as share work and collaborate with others. 

<figure>
 <a href="{{ site.url }}/images/courses/earth-analytics/git/git-clone-repo.gif">
 <img src="{{ site.url }}/images/courses/earth-analytics/git/git-clone-repo.gif" alt="You can make local copies on your computer of repositories on Github.com, using git commands that you run in the Terminal."></a>
 <figcaption> You can make local copies on your computer of repositories on Github.com, using git commands that you run in the Terminal.  
 </figcaption>
</figure>



### Python in Jupyter Notebook

`Python` is a widely used programming language in the sciences and provides strong functionality for working with a variety of data types and formats. `Jupyter Notebook` is a web-based tool that allows you to write and run `Python` code interactively as well as organize your code with documentation and results within `Jupyter Notebook` files. 

Writing and organizing your `Python` code within `Jupyter Notebook` files supports open reproducible science through documentation of data inputs, code for analysis and visualization, and results - all within one file that can be easily shared with others. 

In later chapters, you will learn how to use `Jupyter Notebook` to write and run `Python` code for analysis and visualization of earth and environmental science data. 

<figure>
 <a href="{{ site.url }}/images/courses/earth-analytics/bootcamp/jupyter-interface/notebook-components.png">
 <img src="{{ site.url }}/images/courses/earth-analytics/bootcamp/jupyter-interface/notebook-components.png" alt="A Jupyter Notebook file can contain both text documentation as well as programming code, which can be executed interactively within Jupyter Notebook."></a>
 <figcaption> A Jupyter Notebook file can contain both text documentation as well as programming code, which can be executed interactively within Jupyter Notebook.
 </figcaption>
</figure>

