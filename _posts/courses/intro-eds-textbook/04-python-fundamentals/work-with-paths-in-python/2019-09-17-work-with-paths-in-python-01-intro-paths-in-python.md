---
layout: single
title: 'Working Directories, Absolute and Relative Paths and Other Science Project Management Terms Defined'
excerpt: "A directory refers to a folder on a computer that has relationships to other folders. Learn about directories, files, and paths, as they relate to creating reproducible science projects."
authors: ['Leah Wasser','Jenny Palomino', 'Nathan Korinek']
category: [courses]
class-lesson: ['work-with-files-directories-in-python']
permalink: /courses/intro-to-earth-data-science/python-code-fundamentals/work-with-files-directories-paths-in-python/
nav-title: "Computer Directories"
dateCreated: 2019-09-18
modified: 2020-09-23
module-title: 'Introduction to Working with Files, Directories, and Paths in Python'
module-nav-title: 'Files, Directories & Paths'
module-description: 'Writing code that opens files using paths that will work on many different machines will make your project more reproducible. Learn how to construct paths in your Python code that will work on any machine using the os package.'
module-type: 'class'
class-order: 3
chapter: 12
course: "intro-to-earth-data-science-textbook"
week: 4
estimated-time: "1 hour"
difficulty: "beginner"
sidebar:
  nav:
author_profile: false
comments: true
order: 1
topics:
  reproducible-science-and-programming: ['python']
redirect_from:
  - "/courses/intro-to-earth-data-science/open-reproducible-science/bash/directories/"  
---
{% include toc title="In This Chapter" icon="file-text" %}

<div class='notice--success' markdown="1">

## <i class="fa fa-ship" aria-hidden="true"></i> Chapter Twelve - Work with Files and Directories in Python

In this chapter, you will learn how to work with paths in **Python**. You will also learn how to set a working directory and use absolute and relative paths to access files and directories.


## <i class="fa fa-graduation-cap" aria-hidden="true"></i> Learning Objectives

After completing this chapter, you will be able to:

* Define a computer directory and list the primary types of directories.
* Explain the difference between relative and absolute paths.
* Check and set your working directory in **Python** using the **os** package.

## <i class="fa fa-check-square-o fa-2" aria-hidden="true"></i> What You Need

Be sure that you have followed the instructions on <a href="{{ site.url }}/workshops/setup-earth-analytics-python/">Setting up Git, Bash, and Conda on your computer</a> to install the tools for your operating system (Windows, Mac, Linux).

Be sure that you have completed the chapter on <a href="{{ site.url }}/courses/intro-to-earth-data-science/open-reproducible-science/jupyter-python/">Jupyter Notebook</a>.

</div>


## About Computer Directories

You have probably used files and directories on your computer before. However, 
there are a set of terms that you will hear often, particularly as you work on open
science projects or use the command line to manipulate files and directories.
Below you will learn about some important terms associated with working with
files including working and parent directories.

A directory refers to a folder on a computer that has relationships to other
folders. The term "directory" considers the relationship between that folder and
the folders within and around it. Directories are hierarchical which means that
they can exist within other folders as well as have folders exist within them.

<i class="fa fa-star"></i> **Data Tip:** Directory vs Folder: You can think
of a directory as a folder. However, the term directory considers the relationship
between that folder and the folders within it and around it (it's full path).
{: .notice--success}


## What Is a Parent Directory

The term "parent" directory is used to describe the preceding directory in which
a subdirectory is created. A parent directory can have many subdirectories; thus,
many subdirectories can share the same parent directory. This also means that
parent directories can also be subdirectories of a parent directory above them in the hierarchy.

An example of a directory is your downloads directory. It is the parent directory
of any directories or files that get downloaded to your computer or placed
within this directory.

In the example below, `earth-analytics` is the parent directory of both the `data`
and `output-plots` subdirectories. `field-sites` is the parent directory for the
`california` directory, etc. 

The image files (study-site.jpg and tree-species-distribution-map.jpg) exist within their parent directory: `output-plots/spatial-vector directory`.

```
* earth-analytics\
    * data\
        * field-sites\
            * california\
_           * colorado\
              *  streams.csv
    * output-plots\
        * spatial-vector\
            * study-site.jpg
            * tree-species-distribution-map.jpg
```

## What Is the Home Directory?

The home directory on a computer is a directory defined by your operating system. The home directory is the primary directory for your user account on your computer. Your files are by default stored in your home directory.

On Windows, the home directory is typically `C:\Users\your-username`.

On Mac and Linux, the home directory is typically `/home/your-username`.

Throughout this textbook, `/home/your-username` is used as the example home directory and can be considered equivalent to `C:\Users\your-username` on Windows.

 
<div class="notice--success" markdown="1">

### Home Directories In Bash

When you first open the terminal, if no settings are customized, it opens
within the default directory of your computer which is called the **home**
directory. 

</div>


## What Is A Working Directory?

While the terminal will open in your home directory by default, you can change the working directory of the terminal to a different location within your computer's file structure.

The working directory refers to the directory (or location) on your computer that a the tool assumes is the starting place for all paths that you construct or try to access.  

For example, when you cd into the `earth-analytics` directory, it becomes your working directory. 

If you run the `ls` command within the `earth-analytics` directory (with the contents in the example above):

```bash
$ ls
```

You would see something like this:

```bash
data/
output-plots/
```

The `data` and `output-plots` directories are the immediately visible subdirectories within `earth-analytics`. 

By setting your working directory to `earth-analytics`, you can easily access anything in both of those subdirectories.

## Working Directories and Relative vs Absolute Paths in Python

You may be wondering why working directories are important to understand when working with **Python** (or **R** or most scientific programming languages). 

When set correctly, working directories help the programming language to find files when you create paths. 

Within **Python**, you can define (or set) the working directory of your choice. Then, you can create paths that are relative to that working directory, or create absolute paths, which means they begin at the home directory of your computer and provide the full path to the file that you wish to open.


### Relative Paths

A relative path is the path that (as the name sounds) is relative to the working
directory location on your computer. 

If the working directory is `earth-analytics`, then **Python** knows to start looking for your files in the
`earth-analytics` directory. 

Following the example above, if you set the working directory to the **earth-analytics** directory,
then the *relative path* to access `streams.csv` would be:

`data/field-sites/california/colorado/streams.csv`

<i class="fa fa-star"></i>**Data Tip** The default working directory
in any **Jupyter Notebook** file is the directory in which it is saved. However, you can change the working directory in your code!
{: .notice--success}

However, imagine that you set your working directory to `earth-analytics/data` which is a subdirectory of `earth-analytics`.

The correct *relative* path to the `streams.csv` file would now look like this:

`field-sites/california/colorado/streams.csv`

Relative paths are useful if you can count on whoever is running your code to
have a working directory setup similar to yours. When the details of your directory setup are shared with others who can replicate it, then you can use relative paths to support reproducibility and collaboration. 

### Absolute Paths

An absolute path is a path that contains the entire path to the file or
directory that you need to access. This path will begin at the home directory
of your computer and will end with the file or directory that you wish to access.

`/home/your-username/earth-analytics/data/field-sites/california/colorado/streams.csv`

Absolute paths ensure that **Python** can find the exact file on your computer. 

However, as you have seen, computers can have a different path constructions, depending on the operating system, and contain usernames that unique to that specific machine.  

There are ways to overcome this issue and others associated with finding files
on different machines using tools such as the **os** package in **Python**. You will
learn more about these approaches later in this chapter.
