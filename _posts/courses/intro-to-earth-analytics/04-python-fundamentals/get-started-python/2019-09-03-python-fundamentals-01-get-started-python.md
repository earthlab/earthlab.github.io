---
layout: single
title: 'Introduction to the Python Scientific Programming Language for Earth Data Science'
excerpt: "Python is programming language that emphasizes the readibility of code and provides many packages and libraries for working with scientific data. Learn about the key characteristics of Python and the benefits of using Python for scientific workflows."
authors: ['Jenny Palomino', 'Leah Wasser', 'Max Joseph']
category: [courses]
class-lesson: ['python-fundamentals']
permalink: /courses/intro-to-earth-data-science/python-fundamentals/get-started-python/
nav-title: "About Python"
dateCreated: 2019-07-01
modified: 2019-09-04
module-title: 'Get Started with Python'
module-nav-title: 'Get Started with Python'
module-description: 'Python is programming language that emphasizes the readibility of code and provides many packages and libraries for working with scientific data. Learn how to get started with writing Python code.'
module-type: 'class'
class-order: 1
course: "intro-to-earth-data-science"
week: 4
sidebar:
  nav:
author_profile: false
comments: true
order: 1
topics:
  reproducible-science-and-programming: ['python']
---
{% include toc title="In This Chapter" icon="file-text" %}


<div class='notice--success' markdown="1">

## <i class="fa fa-ship" aria-hidden="true"></i> Chapter Ten - Get Started with Python

In this chapter, you will learn what makes `Python` a useful programming language for scientific workflows. You will get started with writing `Python` code to create variables and lists to store information (i.e. data) and run basic operations on them (e.g. updates, comparisons). You will also learn about the PEP 8 Style Guide for `Python`, which provides useful standards for naming conventions and organization of code to support readibility.


## <i class="fa fa-graduation-cap" aria-hidden="true"></i> Learning Objectives

After completing this chapter, you will be able to:

* List key characteristics and benefits of using the `Python` language for scientific workflows.
* Explain how variables and lists are used in Python to store data.
* Write Python code to create variables and lists and run basic operations on them (e.g. updates, comparisons).
* Implement key ideas of the PEP 8 Style Guide to your `Python` code.


## <i class="fa fa-check-square-o fa-2" aria-hidden="true"></i> What You Need

Be sure that you have followed the instructions on <a href="{{ site.url }}/workshops/setup-earth-analytics-python/">Setting up Git, Bash, and Conda on your computer</a> to install the tools for your operating system (Windows, Mac, Linux). 

Be sure that you have completed the chapter on <a href="{{ site.url }}/courses/intro-to-earth-data-science/open-reproducible-science/jupyter-python/">Jupyter Notebook</a>.

</div>

## What is Python

Python is a free, open source scientific programming language.

Key Characteristiscs:

* **Interpreted Language:** **Python** is an interpreted programming language. At the most basic level, an interpreted language means that you can run **python** code and associated commands without needed additional steps such as compiling the code first before running it. 
* **Object-Oriented:** Python is most often used in an object-oriented way. You will leanr more about object oriented programming later in this textbook. But in short, this means that rather than create functions to perform tasks, most programmers will create methods which are functions that can be applied to a particular object such as a dataframe.
> [name=Leah Wasser]not sure how to describe this simply? We could make these subheadings so there can be more examples too...
* **High Level Programming Language:** **Python** is also a high level programming language. This means that you are free to create programs using python and to process data without worrying about what type of computer you are on. The **Python** language abstracts away some of those technical details so you can get more quickly to your science. 
> [name=Leah Wasser]this also feels a bit to hard to understand
* **Free and Open Source:** **Python** is a free and open source programming language. This means that anyone can contribute to `Python`. But also the source code for the entire language is freely available. 

> [name=Leah Wasser]let's make a decision - do we want this to be python in bold and just code in code syntax like the R texts do (sometimes??) 

https://www.python.org/doc/essays/blurb/


## Why Use Python Over Other Programming Languages?

Each programming language has its benefits and its drawbacks. **Python** is being used in our earth analytics courses and in this textbook for many reasons including:

1. **Python is one of the most commonly used languages in the earth and environmental sciences:** Many different sources have identified Python as being one of the most popularly used language. Earth Lab's market research of industry and agency partners has identified this. Stack overflow also did an analysis which found that Python was one of the most active programming language threads on their popularly used website
> [name=Leah Wasser] Add links to earthlab research and SO analysis which was a blog post that was pretty cool. there might be others too??
2. **Python is free and open source:** This means that anyone can use it without worrying about licenses. This also makes it easy to migtate over to cloud and high performance computing (HPC) environments given there are no license restrictions. 

3 **Python has an active open source community for science:** Python also has an active open source community who are building tools to support scientific applications.

> [name=Leah Wasser] do we want to talk about how python is a bit more efficient when it comes to memory allocation as designed (vs R) -- can of worms i know

> [name=Leah Wasser] Do we want to talk about  

4. **Python is the core language formany spatial data tools:** Example tools that use Python as their core include ESRI ArcGIS, QGIS and others. This makes the language versatile if you wish to create macros in a tool like QGIS. 


## Where to Run Python Code

There are many different ways to write and run Python code. In this textbook you will learn how to write code using the Jupyter environment (discussed below). However you can also write code at the command line (using the terminal), in a text editor or in another tool such as Spyter or PyCharm. 


### Write Python Code Using Interactive Development Environments (IDE) Such as Jupyter Notebook

An interactive development environment (IDE) is a graphical interface that supports writing code efficently. There are many benefits of using IDE's to program. 

**IDE's Make Coding Faster - Tab Completion** Most IDE's have built in shortcuts that make it easier to write code quickly. Tab completion is a great example of this. Try the following. If you are in a Jupyter notebook:

1. add a new code cell
2. type `import os`, and hit return
3. type `os.get` and hit <kbd>tab</kbd> what happens?

```python
import os
# Start to type os.get, what happens when you hit tab after typing the t in os.get?
os.get

```

Once you get the hang of tab completion, you will see how much more quickly you can code. It also makes it easier to avoid mistakes when typing commands like `os.getcwd()`.

#### Benefits of Using IDE's
There are many other benefits of IDE's for programming. Tools like Spyder and pycharm will show you objects that exist in your environment that have been created by your code.

Some IDE's such as Jupyter Lab, PyCharm and Spyder will also make it easy for you to work within a working directory that may contain many different files. 

Further they can help with paths - allowing you to generate paths to objects using tab <kbd>tab completion</kbd>.

> [name=Leah Wasser] add image from pycharm of the objects available in an environment. Probably good to create one for spyter too. i'm not sure jupyter lab supports this yet but it's worth seeing if it does??  

IDE's can be free of sometimes they are purchased. Spyder is a free IDE that comes with the Anaconda python distribution. The base version of PyCharm is also free but you need to pay for the full version if you want complete debugging functionality. 

The Jupyter platform is completely free for you to use. Because jupyter also supports reproducible science by allowing you to connect code, data, documentation, and associated inputs and outputs. Thus we use Jupyter in all of our Earth Analytics courses and throughout this textbook. In fact the lessons that you are reading now we were generated from Jupyter Notebooks.

> [name=Leah Wasser] Do we need to add links or references to other chapters? specifically the jupyter chapter would be good here. 
> 
### Use Text Editors To Write Python Code 

Many people use text editors for writing Python code. One way to use text editors is to create python scripts and then run them at the command line (see below). Alterniatvely some text editors, such as Atom have plugins that allow you to run code directly in the text editor like you would in pycharm or Spyder. 

Some people prefer using text editors to write Python code   becuase they are smaller in size, and light weight making them easier to use.  

> [name=Leah Wasser]link to the text editor lesson

* For writing/editing code files (e.g. .py scripts) 
    * Options
        * Atom
        * Nano
        * Sublime Text

### Write Python Code Using the Terminal

You can also execut Python code at the command line using the terminal. 


#### Execute Python Commands In the Terminal 
One way to do this is to open up a terminal, and type `Python`. This will send you into an interactive python session where you can import packages and run code.

> [name=Leah Wasser] add a few code examples showing launching python in bash... and tying in a few commands. give them steps to do this??
> 

Writing code interactively ni the terminal is a nice way to quickly test out apraches. However, it's much more efficient to create scripts where you can save the code and rerun it.

#### Write Scripts that can be run in the terminal

Alternatively a more efficient approach to using the terminal with Python is to write python scripts. These scripts will have a `.py` extension. You can then call the script at the terminal using:

```bash
$ # execute a python script named myscript.py at the command line
$ python myscript.py
```
> [name=Leah Wasser] i'm pretty curious if jupyttext will turn this into a cell or not? Jenny can you test that? what if we want code in markdown vs code in a new cell??
\* .py scripts

To write scripts, you will likely want want to use either an IDE  OR a text editor as discussed above.


### Other Ways to Write Python Code

Python is also used in many GIS applications. Tools like QGIS and ArcGIS that support working with spatial data often have command line interfaces that allow you to execute python code. 

> [name=Leah Wasser] maybe a tad more here on this but it can be very short. perhaps just a screenshort of QGIS with the CLI open and some code being writte??


> [name=Leah Wasser]jenny is the end region thing part of jupytext or just a random addition??
> [name=Jenny Palomino] not sure, I did not add that, so I assume that it is jupytext tracking the sections on the page (e.g. yaml vs the rest).
> I removed the title for this page (# Chapter 10 ... ) and moved your comment about the authors down here to keep the top of the file clean.

> [name=Leah Wasser] author note: we want authors who contribute to the chapter. the first author should be the person who contributed the most to that chapters content for the entire module. but for each page we can keep it unique. so if i ended up writing the entire page, i'll be first author for the lesson (no one will see this in our website build for drupal) but YOU will be first author on the entire module (which is actually what counts) oh but i just realized this is a landing page... so for this if you write most of the chapter which i suspect you will, you should be first!! we can add this high level to the google doc for clarity for the future too
