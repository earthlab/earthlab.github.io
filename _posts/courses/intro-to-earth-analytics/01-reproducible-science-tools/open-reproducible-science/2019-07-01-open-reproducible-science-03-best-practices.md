---
layout: single
title: 'How To Organize Your Project: Best Practices for Open Reproducible Science'
excerpt: "Open reproducible science refers to developing workflows that others can easily understand and use. Learn about best practices for organizing open reproducible science projects including the use of machine readable names."
authors: ['Jenny Palomino', 'Leah Wasser', 'Max Joseph']
category: [courses]
class-lesson: ['open-reproducible-science']
permalink: /courses/intro-to-earth-data-science/open-reproducible-science/get-started-open-reproducible-science/best-practices-for-organizing-open-reproducible-science/
nav-title: "Project Management Best Practices"
dateCreated: 2019-07-01
modified: 2019-08-29
module-type: 'class'
class-order: 1
course: "intro-to-earth-data-science"
week: 1
sidebar:
  nav:
author_profile: false
comments: true
order: 3
topics:
  reproducible-science-and-programming: ['python']
---

{% include toc title="On This Page" icon="file-text" %}

<div class='notice--success' markdown="1">

## <i class="fa fa-graduation-cap" aria-hidden="true"></i> Learning Objectives

* Describe machine readable names and the importance of using them to name directories and files.
* List best practices for organizing open reproducible science projects.

</div>


## Project Organization and Management for Open Reproducible Science Projects

### Organize Your Science Project Directory To Make It Easier to Understand

When you are working on a data project, there are often many files that you need to store on your computer. These files may include:

* Raw Data Files
* Processed data files: you may need to take the raw data and process it in some way
* Code and scripts 
* Outputs like figures and tables 
* Writing associated with your project 

It will save you time and make your project more useable and reproducible if you carefully consider how these files are stored on your computer. Below are some best practices to consider when pulling together a project.


### Importance of Directory and File Names

As you create new directories and files on your computer, consider using a carefully crafted naming convention that makes it easier for anyone to find things and also to understand what each files does or contains. 

It is good practice to use file and directory that are: 

* **Human readable**: use expressive names that clearly describe what the directory or file contains (e.g. code, data, outputs, figures).
* **Machine readable**: avoid strange characters or spaces. Instead of spaces, you can use `-` or `_` to separate words within the name to make them easy to read and parse.
* **Sortable**: it is nice to be able to sort files to quickly see what is there and find what you need. For example, you can create a naming convention for a list of related directories or files (e.g. `01-max.jpg`, `02-terry.jpg`, etc), which will result in sortable files. 

These guidelines not only help you to organize your directories and files, but they can also help you to implement machine readable names that can be easily queried or parsed using scientific programming or other forms of scripting. 

Using a good naming convention when structuring a project directory also supports reproducibility by helping others who are not familiar with your project quickly understand your directory and file structure.


## Best Practices for Open Reproducible Science Projects

### 1. Use Consistent Computer Readable Naming Conventions 

Machine readable file names allow your directory structure to be quickly manipulated and handled by code. 

For example, you may want to write a script that processes a set of images and you may want to sort those images by date. If the date of each image is included in the file name at the very beginning of the name, it will become easier to parse with your code. The files below could be difficult to parse because the naming convention is not standard.

```
* file.jpg
* file-two.jpg
* filethree.jpg
```
However this list of files is easier to parse as the date is included with the file name. 

```
* 2020-image.jpg
* 2019-image.jpg
* 2018-image.jpg
```

Sometimes simply numbering the files is enough to allow for sorting: 

```
* 01-image.jpg
* 02-image.jpg
* 03-image.jpg
```

If your files and directories follow identifiable patterns or rules, it will allow you to more easily manipulate them. This in turn will make it easier for you to automate file processing tasks.

A few other best practices to consider when naming files within a project:

* Avoid spaces in file and dir names: spaces in a file name can be difficult when automating workflows. 
* Use dashes-to-separate-words (slugs): dashes or underscores can make is easier for you to create expressive file names. Dashes or underscores are also easier to parse when coding. 
* Consider whether you may need to sort your files. If you do, you may want to number things.


### 2. Be Consistent When Naming Files - Use Lower Case

It might be tempting when naming files and directories to use `lower` and `Upper` case. However, case will cause coding issues for you down the road particularly if you are switching between operating systems (Mac vs Linux vs Windows). 

Case in point, have a look at the file names below. 

```
my-file.txt
My-File.txt

```

If you want to open / read `my-file.txt` it would be easy to call:

`pandas.read.csv("my-file.txt")`

in Python. This call will work on all operating systems. However, this call:

`pandas.read.csv("My-file.txt")`

may work on some machines  (possibly Windows) but it's likely to fail on Linux or MAC. To keep things simple and to avoid case sensitvity issues, usw lower case naming conventions for all file and directory names. 


### 3. Organize Your Project Directories to Make It Easy to Find Data, Code and Outputs

Rather than saving a bunch of files into a single directory, consider a directory organization approach that fits your project. 

Create numbered directories that cover the steps of your workflow - for example:

```
/vegetation-health-project
    /01-code-scripts
    /02-raw-data
    /03-processed-data
    /04-graphics-outputs
    /05-paper-blog
```

The numbers before each folder allow you to sort the directories in a way that makes it easier to parse. Notice also that each directory has an expressive (uses words that describe what is in the directory) name. Expressive naming will be discussed in the next section. 

Using individual directories to store data, scripts, output graphics and then the final paper and blog posts being written for the project makes it easier to find components of your project. 

This is especially useful for your future self who may need to come back to the project in six months to update things. It also makes is easier for a colleague that you are collaborating with to quickly find things. 

There is no one perfect example as each project may require different directories. The best advice is to pick something that works well for you and your team and stick to it. It's best to be consistent. 

<div class="notice--info" markdown="1">

| Organized Project  | Non Organized Project  | 
|---|---|
|/01-scripts <br>&nbsp;&nbsp;&nbsp; 01-clean-data.py <br> &nbsp;&nbsp;&nbsp; 02-run-model.py <br>&nbsp;&nbsp;&nbsp; 03-create-plots.py <br> /02-data <br> &nbsp;&nbsp;&nbsp;&nbsp;/raw-data <br> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;/landsat-imagery<br> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;/fire-boundary<br>/03-output-graphics<br>&nbsp;&nbsp;&nbsp; study-area-map.png <br> /04-final-paper <br>&nbsp;&nbsp;&nbsp; fire-paper.pdf| file1-new.py<br>file1.py<br> plotting-test.py <br> data-file.txt  <br> /old-stuff <br> testoutput1.txt <br>testoutput2.csv|

> Look at the example directory structures above. Which structure is easier to understand? In which could you more easily find what you need?

</div>


### 4. Use Meaningful (Expressive) File And Directory Names 

Expressive file names are those that are meaningful and thus describe what each directory or file is or contains. Using expressive file names makes it easier to scan a project directory and quickly understand where things are stored and what files do or contain. 

Expressive names also support machine readibility, as discernible patterns in expressive names can be used by a computer to identify and parse files. 

<div class="notice--info" markdown="1">

| Expressive Project  | Non Expressive Project  | 
|---|---|
|/01-scripts <br>&nbsp;&nbsp;&nbsp; 01-process-landsat-data.py <br> &nbsp;&nbsp;&nbsp; 02-calculate-ndvi.py <br>&nbsp;&nbsp;&nbsp; 03-create-ndvi-maps.py <br> /02-data <br> &nbsp;&nbsp;&nbsp;&nbsp;/raw-data <br> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;/landsat-imagery <br> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;/june-2016 <br> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;/july-2016<br> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;/cold-springs-fire-boundary<br>/03-output-graphics<br>&nbsp;&nbsp;&nbsp; ndvi-map-june-2016.png <br>  &nbsp;&nbsp;&nbsp; ndvi-map-july-2016.png <br>/04-final-paper <br>&nbsp;&nbsp;&nbsp; veg-impacts-cold-springs-fire.pdf| work.py<br>plotting.py<br> plotting-test.py <br>landsat/<br> data-file.txt  <br>old-stuff/ <br> testoutput1.txt <br>testoutput2.csv  |

> Look at the example directory structures above. Which directory structure (the one on the LEFT or the one on the RIGHT) would you prefer to work with? 

</div>

<i class="fa fa-exclamation-circle" aria-hidden="true"></i> **Windows Users:** Note that the default names of your existing directories often begin with upper case letters (e.g. Documents, Downloads). When creating new directories, use lower case to follow the textbook more easily and for best results from future programming tasks.
{: .notice--success}

### 5. Document Your Project With a README File 

There are many ways to document a project; however, a readme file at the top level of your project is a standard convention. When you begin to use GitHub, you will notice that almost all well designed github repositories contain readme files. The readme is a text file that describes data / software packages and tool used to process data in your project. The readme should also describe files and associated naming conventions. Finally, the readme can be used to document any abbreviations used, units, etc as needed.  

There are other files that you may consider as well such as software installation instructions if those are required, citation information and if the project is one that you want others to contribute to, then a `CONTRIBUTING` file may be in order. 


### 6. Don't Use Proprietary File Formats  

Proprietary formats are formats that require a specific tool (and a specific license often) to open. Examples include Excel (.xls) or Word (.doc). These formats may change over time as new versions come out (example: `.xls` upgraded to `.xlxs`. 

In some cases, certain formats are operating system specific (example: most Linux users do not run Microsoft tools). 

When choosing file formats for your projects, think about whether you will have a license to access that file format in the future and whether others have access to the license.

When you can, stick to formats that are operating system and tool agnostic such as `.csv` and `.txt`. Text files are not proprietary and thus can be opened on any operating system and on any computer with the right open tools. This allows more people to have access to your files including your future self who might not have a license to open these files. 


<i class="fa fa-lightbulb-o" aria-hidden="true"></i> **Pro Tip:** Using standard data formats increases opportunities for re-use and expansion of your research.
{: .notice--success }


<div class="notice--info" markdown="1">

## Best Practices For Open Reproducible Science Projects - A Case Study

Jennifer recently graduated with a degree in environmental science and got a job working with an environmental non-profit. While a student, she worked on some great projects to build flood models using MATLAB, a proprietary software used to design and run models. In collaboration with a professor and other class mates, Jennifer wrote a paper that was accepted for publication in well known hydrology journal, though some minor changes were requested. 

Excited to get the paper revised for publication, Jennifer tracks down her project files and tries to remember which files produced the final outputs that she included in the submitted paper. However, she realizes that even when she is able to identify which files she needs, she no longer has access to the MATLAB, which she needs to access the files. Unfortunately, her license expired when she graduated, and her non-profit does not have licenses for MATLAB. 

Jennifer's story can be a common experience for anyone who has moved to a new job where the resources and licenses differ, or who has spent a long time away from a particular project and need to recreate a workflow. 

How could using organized and expressively named directories have helped Jennifer with this project? How could avoiding proprietary file formats contribute to the longevity of this project? 

</div>
