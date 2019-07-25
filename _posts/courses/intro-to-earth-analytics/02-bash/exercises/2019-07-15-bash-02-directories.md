---
layout: single
title: 'Computer Directories'
excerpt: "This section introduces directory structures on computers and the importance of using machine readable names for directories and files."
authors: ['Jenny Palomino', 'Leah Wasser']
category: [courses]
class-lesson: ['bash']
permalink: /courses/intro-to-earth-analytics/bash/directories/
nav-title: "Computer Directories"
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
order: 2
topics:
  reproducible-science-and-programming: ['shell']
---
{% include toc title="In This Section" icon="file-text" %}

In this section, you will learn about computer directory structures and the importance of using machine readable names for directories and files. 

<div class='notice--success' markdown="1">

## <i class="fa fa-graduation-cap" aria-hidden="true"></i> Learning Objectives

After completing this lesson, you will be able to:

* Explain what a computer directory is.
* Describe machine readable names and the importance of using them to name directories and files.

## <i class="fa fa-check-square-o fa-2" aria-hidden="true"></i> What You Need

Be sure that you have completed the instructions on <a href="{{ site.url }}/workshops/setup-earth-analytics-python/setup-git-bash-anaconda/">Setting up Git, Bash, and Anaconda on your computer</a> to install the tools for your operating system (Windows, Mac, Linux). 

 </div>


## Directory Structures

### What Is a Directory?

A directory refers to a folder on a computer that has relationships to other folders. The term directory considers the relationship between that folder and the folders within it as well as around it. 

Directories are hierarchical which means that they can exist within other folders as well as have folders exist within them. 

### What Is a Parent Directory?

The term "parent" directory is used to describe the preceding directory in which a subdirectory is created. 

A parent directory can have many subdirectories (or child directories); thus, many subdirectories can share the same parent directory. This also means that parent directories can also be subdirectories of a parent directory above them in the hierarchy. 

A familiar example would be your downloads directory. It is the parent directory for any directories or files that get downloaded to your computer and placed within this directory. 

In the example below, `downloads` is the parent directory of both the `cat-pics` and `dog-pics` directories, `cat-pics` is the parent directory for the `siamese` directory, etc. The image files (.jpg) exist within their parent directories as well (e.g the `poodle` directory is the parent directory of `01_max.jpg`). 

* downloads
    * cat-pics
        * siamese
            * 01_fluffy.jpg
            * 02_snowball.jpg
    * dog-pics
        * poodle
            * 01_max.jpg
            * 02_terry.jpg
    

### What is a Working Directory?

A working directory refers to the current directory that is being accessed by the tool or program with which you are working (i.e. your current location within your computer's file structure).

For many tools, the working directory is defaulted to the directory in which the opened file resides (e.g. Documents or Downloads directory). 

However, many tools also provide the ability to define (or set) a new working directory, which can be very helpful to programmatically access different directories and files across your computer as needed. 

In the example above, `downloads` is a good choice for the current working directory if you need to access the contents of both `cat-pics` and `dog-pics`. However, the current working directory can also be set to `cat-pics` if you do not need to access the contents of `dog-pics` in your workflow. 


## Importance of Machine Readable Names

As you create new directories and files on your computer throughout this textbook, consider the names carefully. It is good practice to: 

* Use names that clearly describe what the directory or file contains.
* Not use spaces in your names. Instead of spaces, you can use `-` or `_` to separate words within the name.
* Create a naming convention for a list of related directories or files (e.g. `01_max.jpg`, `02_terry.jpg`, etc). 

These guidelines not only help you to organize your directories and files but they can also help you to implement machine readable names that can be easily queried or parsed with computer code.  

Machine readable names are descriptive, standardized and named with conventions that can easily be manipulated and handled by computer code because there are keywords and/or identifiable patterns or rules that are followed. 

As an example, compare the list of file names on the left to those on the right in the image below. 

<figure>
   <a href="https://www.earthdatascience.org/images/slide-shows/intro-rr/human-readable-jenny.png">
   <img src="https://www.earthdatascience.org/images/slide-shows/intro-rr/human-readable-jenny.png" alt="This image displays examples of good and not-so-good names for directories and files. Source: Jenny Bryan, Reproducible Science Curriculum."></a>
   <figcaption>This image displays examples of good and not-so-good names for directories and files. Source: Jenny Bryan, Reproducible Science Curriculum.   
   </figcaption>
</figure>

Which ones are descriptive and easier to quickly understand what they contain?  Is there a discernible pattern that could be used by a computer to identify particular files?   

<i class="fa fa-exclamation-circle" aria-hidden="true"></i> **Windows Users:** note that the default names of your existing directories often begin with upper case letters (e.g. Documents, Downloads). When creating new directories, use lower case to follow the textbook more easily and for best results from future programming tasks.
{: .notice--success}
