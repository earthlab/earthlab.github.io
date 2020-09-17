---
layout: single
title: 'Tools For Open Reproducible Science'
excerpt: "Key tools for open reproducible science include Shell (Bash), git and GitHub, Jupyter, and Python. Learn how these tools help you implement open reproducible science workflows."
authors: ['Jenny Palomino', 'Leah Wasser', 'Max Joseph']
category: [courses]
class-lesson: ['open-reproducible-science']
permalink: /courses/intro-to-earth-data-science/open-reproducible-science/get-started-open-reproducible-science/open-science-tools-git-bash-jupyter/
nav-title: "Open Science Tools"
dateCreated: 2019-07-01
modified: 2020-09-14
module-type: 'class'
course: "intro-to-earth-data-science-textbook"
week: 1
sidebar:
  nav:
author_profile: false
comments: true
order: 2
topics:
  reproducible-science-and-programming: ['python']
---

{% include toc title="On This Page" icon="file-text" %}

<div class='notice--success' markdown="1">

## <i class="fa fa-graduation-cap" aria-hidden="true"></i> Learning Objectives

* Describe how `bash`, `git`, `GitHub` and `Jupyter` can help you implement open reproducible science workflows.

</div>
 

## Useful Tools in the Open Reproducible Science Toolbox

To implement open science workflows, you need tools that help you document, automate, and share your work. For example you may need to document how you collected your data (protocols), how the data were processed and what analysis approaches you used to summarize the data.

Throughout this textbook, you will learn how to use open science tools that will help you: 
* Document your work, so others and your future self can understand your workflow.
* Generate reports that connect your data, code (i.e. methods used to process the data), and outputs and publish them in different formats (`HTML`, `PDF`, etc).
* Automate your workflows, so they can be reproduced by others and your future self.
* Share your workflows.
* Collaborate with others.

While there are many tools that support open reproducible science, this textbook uses: `bash`, `git`,`GitHub.com`, and `Python` in `Jupyter Notebooks`.

## Use Scientific Programming to Automate Workflows

Many people begin to use data in tools such as Microsoft Excel (for spreadsheets / tabular data) or ArcGIS (for spatial data) that have graphical user interfaces (GUIs). GUIs can be easier to learn early on as they have a visual interface that can be less overwhelming as a beginner. However, as the data that you are working with get larger, you will often run into challenges where the GUI based tools can not handle larger volumes of data. Further GUI based tools require individual steps that are often manually implemented (unless you build macros or small automation scripts). This makes your workflow difficult to reproduce. Some tools such as Excel require paid licenses which will limit who can access your data and further, will limit including your workflow in a cloud or other remote environment. 

Scientific programming using an open source, free programming language like `R` or `Python`, is an effective and efficient way to begin building a workflow that is both reproducible and that can be easily shared. 

In this textbook, you will learn the `Python` programming language. `Python` is a free and open source programming language that anyone can download and use. Further it is becomming one of the more popular and in-demand skills in today's job market. While you will learn Python in this textbook, many of the principles that you will learn can be applied across many programming languages. 

<figure>
 <a href="{{ site.url }}/images/earth-analytics/jupyter-interface/python-jupyter-notebook.png">
 <img src="{{ site.url }}/images/earth-analytics/jupyter-interface/python-jupyter-notebook.png" alt="You can write and run Python code in interactive development environments such as Jupyter Notebook. This image shows how Python code can be organized and run using cells in Jupyter Notebook and how the output is displayed under the executed cells. "></a>
 <figcaption>You can write and run Python code in interactive development environments such as Jupyter Notebook. This image shows how Python code can be organized and run using cells in Jupyter Notebook and how the output is displayed under the executed cells. 
 </figcaption>
</figure>


## Use Shell (Also Called Bash) For File Manipulation and Management

`Shell` is the primary program that computers use to receive code (i.e. commands) and return information produced by executing these commands (i.e. output). These commands can be entered via a `Terminal` (also known as a Command Line Interface - CLI), which you will work with in this course. 

Using a `Shell` helps you:
* Navigate your computer to access and manage files and folders (i.e. directories). 
* Efficiently work with many files and directories at once.
* Run programs that provide more functionality at the command line such as `git` for version control.
* Launch programs from specific directories on your computer such as `Jupyter Notebook` for interactive programming.
* Use repeatable commands for these tasks across many different operating systems (Windows, Mac, Linux).

`Shell` is also important if you need to work on remote machines such as a high performance computing cluster (HPC) or the cloud. Later in this textbook, you will learn how to use a `Bash` (a specific implementation of `Shell`) to access and manage files on your computer and to run other programs that can be started or run from the `Terminal`, such as `Jupyter Notebook` and `git`.

<figure>
 <a href="{{ site.url }}/images/earth-analytics/bash/terminal-ea-dir.png">
 <img src="{{ site.url }}/images/earth-analytics/bash/terminal-ea-dir.png" alt="The terminal and shell (bash) can be used to view file directory structures. The image above shows bash commands to change directories (cd) from the home directory to a subdirectory called earth-analytics, and to list out the contents (ls) of the earth-analytics directory, which includes a subdirectory called data. "></a>
 <figcaption>The terminal and shell (bash) can be used to view file directory structures. The image above shows bash commands to change directories (cd) from the home directory to a subdirectory called earth-analytics, and to list out the contents (ls) of the earth-analytics directory, which includes a subdirectory called data. 
 </figcaption>
</figure>


## Version Control and Collaboration Using Git and GitHub

`Git` helps you monitor and track changes in files, a process referred to as version control. Git provides a way to create and track a "repository" for a project, i.e., a folder where all relevant files are kept. GitHub is a cloud-based platform to host git repositories, which allows you to store and manage your files and track changes. GitHub also includes project management and communication features that are useful when working on collaborative projects such as issues, forks, and milestone tracking.

These tools work together to support sharing files and collaboration within workflows. With `git`, you can work on your files locally and then upload changes to `GitHub.com`. If you make your repository public, then others can find it on GitHub and contribute to your code (if you want them to) which makes it ideal for collaboration and sharing. GitHub is also useful for code review as others can comment on changes to a workflow and you can chose to accept or reject proposed changes. 

Later in this textbook, you will learn how to use the `git`/`GitHub` workflow to implement version control for your files, share work and collaborate with others. 

<figure>
 <a href="{{ site.url }}/images/earth-analytics/git-version-control/git-fork-repo.gif">
 <img src="{{ site.url }}/images/earth-analytics/git-version-control/git-fork-repo.gif" alt="You can make local copies on your computer of repositories on Github.com, using git commands that you run in the Terminal."></a>
 <figcaption> You can make local copies on your computer of repositories on Github.com, using git commands that you run in the Terminal. It's valuable to have copies of your code in multiple places (for example, on your computer and GitHub) just in case something happens to your computer. 
 </figcaption>
</figure>

## The Jupyter Project 

The Jupyter project is an open source effort that evolved from the IPython project to support interactive data science and computing. While the project evolved from Python, it supports many different programming languages including `R`, `Python` and `Julia` and was designed to be language-agnostic. The Jupyter platform has been widely adopted by the public and private sector science community. If you are familiar with the `R` programming language, Jupyter Notebook can be compared to R Markdown.

There are three core tools that you should be familiar with associated with Project Jupyter. The text below which describes these tools was copied directly from the <a href="https://jupyter.org/index.html" target="_blank"><i class="fas fa-external-link-alt"></i> Jupyter Website</a>:

**Jupyter Notebook:** The Jupyter Notebook is an open-source browser-based application that allows you to create and share documents that contain live code, equations, visualizations and narrative text. Uses include: data cleaning and transformation, numerical simulation, statistical modeling, data visualization, machine learning, and much more.

<figure>
 <a href="{{ site.url }}/images/courses/earth-analytics/bootcamp/jupyter-interface/notebook-components.png">
 <img src="{{ site.url }}/images/courses/earth-analytics/bootcamp/jupyter-interface/notebook-components.png" alt="A Jupyter Notebook file can contain both text documentation as well as programming code, which can be executed interactively within Jupyter Notebook."></a>
 <figcaption> A Jupyter Notebook file can contain both text documentation as well as programming code, which can be executed interactively within Jupyter Notebook.
 </figcaption>
</figure>

**JupyterLab:** JupyterLab is a browser-based interactive development environment for Jupyter notebooks, code, and data. JupyterLab is flexible: you can configure and arrange the user interface to support a wide range of workflows in data science, scientific computing, and machine learning. JupyterLab is extensible and modular: you can write plugins that add new components and integrate with existing ones.

<figure class="half">
    <a href="{{ site.url }}/images/earth-analytics/jupyter-interface/python-jupyter-notebook.png"><img src="{{ site.url }}/images/earth-analytics/jupyter-interface/python-jupyter-notebook.png" alt="Jupyter Notebook (left) is a browser-based interface that allows you to write code in many programming languages, including Python, and add formatted text that describes what the code does using Markdown."></a>
    <a href="{{ site.url }}/images/earth-analytics/jupyter-interface/multiple-notebooks-jupyter-lab.png"><img src="{{ site.url }}/images/earth-analytics/jupyter-interface//multiple-notebooks-jupyter-lab.png" alt="Jupyter Lab (right) provides access to Jupyter Notebook but also allows you to work with multiple documents, including notebook files and other files, at a time."></a>
    <figcaption>Jupyter Notebook (left) is a browser-based interface that allows you to write code in many programming languages, including Python, and add formatted text that describes what the code does using Markdown. Jupyter Lab (right) provides access to Jupyter Notebook but also allows you to work with multiple documents, including notebook files and other files, at a time.</figcaption>
</figure>


**JupyterHub:** A multi-person version of Jupyter Notebook and Lab that can be run on a server. This is the tool that supports the cloud based classroom used in all of the Earth Analytics courses and workshops.

You will learn more about Jupyter tools in later chapters of this book. 


### Organize and Document Workflows Using Jupyter Notebook Files

Connecting your entire workflow including accessing the data, processing methods and outputs is an important part of open reproducible science. 

`Jupyter Notebook` files can help you connect your workflow by allowing you to write and run code interactively as well as organize your code with documentation and results within individual `Jupyter Notebook` files. You can also export `Jupyter Notebook` files to HTML and PDF formats for easy sharing. 

In this textbook and in our Earth Analytics courses, we use `Jupyter Notebook` with Python. As described previously, `Python` is a widely used programming language in the sciences and provides strong functionality for working with a variety of data types and formats.

Writing and organizing your `Python` code within `Jupyter Notebook` files supports open reproducible science through documentation of data inputs, code for analysis and visualization, and results -- all within one file that can be easily shared with others. 

In later chapters, you will learn how to use `Jupyter Notebook` to write and run `Python` code for analysis and visualization of earth and environmental science data. 
