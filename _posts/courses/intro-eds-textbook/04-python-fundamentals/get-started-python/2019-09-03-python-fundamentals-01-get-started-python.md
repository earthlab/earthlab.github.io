---
layout: single
title: 'Introduction to the Python Scientific Programming Language for Earth Data Science'
excerpt: "Python is a free, open source programming language that can be used to work with scientific data. Learn about using Python to develop scientific workflows."
authors: ['Jenny Palomino', 'Leah Wasser']
category: [courses]
class-lesson: ['get-started-python']
permalink: /courses/intro-to-earth-data-science/python-code-fundamentals/get-started-using-python/
nav-title: "About Python"
dateCreated: 2019-07-01
modified: 2020-09-23
module-title: 'Get Started with Variables and Lists in Python'
module-nav-title: 'Get Started with Python Variables and Lists'
module-description: 'Python is programming language that emphasizes the readibility of code and provides many packages and libraries for working with scientific data. Learn how to get started with writing Python code.'
module-type: 'class'
chapter: 10
class-order: 1
course: "intro-to-earth-data-science-textbook"
week: 4
estimated-time: "2-3 hours"
difficulty: "beginner"
sidebar:
  nav:
author_profile: false
comments: true
order: 1
topics:
  reproducible-science-and-programming: ['python']
redirect_from:
  - "/courses/earth-analytics-python/use-time-series-data-in-python/about-and-get-help-with-python/"
---
{% include toc title="In This Chapter" icon="file-text" %}


<div class='notice--success' markdown="1">

## <i class="fa fa-ship" aria-hidden="true"></i> Chapter Ten - Get Started Using Python

In this chapter, you will learn what makes **Python** a useful programming language for scientific workflows. You will get started with writing **Python** code to create variables and lists to store information (i.e. data) and run basic operations on them (e.g. updates, comparisons). You will also learn about the PEP 8 Style Guide for **Python**, which provides useful standards for naming conventions and organization of code to support readibility.


## <i class="fa fa-graduation-cap" aria-hidden="true"></i> Learning Objectives

After completing this chapter, you will be able to:

* List key characteristics and benefits of using the **Python** language for scientific workflows.
* Explain how variables and lists are used in **Python** to store data.
* Write **Python** code to create variables and lists and run basic operations on them (e.g. updates, comparisons).
* Implement key ideas of the PEP 8 Style Guide to your **Python** code.


## <i class="fa fa-check-square-o fa-2" aria-hidden="true"></i> What You Need

Be sure that you have followed the instructions on <a href="{{ site.url }}/workshops/setup-earth-analytics-python/">Setting up Git, Bash, and Conda on your computer</a> to install the tools for your operating system (Windows, Mac, Linux). 

Be sure that you have completed the chapter on <a href="{{ site.url }}/courses/intro-to-earth-data-science/open-reproducible-science/jupyter-python/">Jupyter Notebook</a>.

</div>

## What is Python

<a href="https://www.python.org/doc/essays/blurb/" target="_blank">**Python**</a> is a free, open source scientific programming language.

Key Characteristics:

* **Interpreted Language:** **Python** is an interpreted programming language. At the most basic level, an interpreted language means that you can run **Python** code and associated commands without needed additional steps such as compiling the code first before running it. This makes getting started and working with **Python** quick and easy. 
* **Object-Oriented:** Python is most often used in an object-oriented way, which allows data to be stored as objects that have unique characteristics and functionality. You will learn more about object oriented programming later in this textbook. But in short, this means that rather than create generalized functions to perform tasks, most programmers will create methods, which are functions that are applied to specific object types, such as a method that is only applicable to a list or dataframe.
* **High Level Programming Language:** **Python** is also a high level programming language, which provides the ability to work with code that is human readable, as opposed to machine language (such as 0s and 1s). As the **Python** language abstracts away many of those technical details, you are free to write code and to process data using **Python** without worrying about what type of computer you are using. So you can get more quickly to your science and be able to share your code with others who may be using a different operating system. 
* **Free and Open Source:** **Python** is a free and open source programming language. This means that the source code for the entire language is freely available, and that anyone can contribute new functionality or documentation for the benefit of the **Python** community.


## Why Use Python For Earth Data Science

Each programming language has its benefits and its drawbacks. **Python** is being used in our earth analytics courses and in this textbook for many reasons including:

1. **Python is one of the most commonly used languages in the earth and environmental sciences:** Many different sources have identified **Python** as being one of the most popularly used languages, particularly in the sciences. <a href="https://insights.stackoverflow.com/survey/2019" target="_blank">An analysis conducted by Stack Overflow</a>
found that **Python** is one of the most active programming language threads on their widely used website and the overall fastest-growing major programming language. Earth Lab's own <a href="https://www.earthdatascience.org/blog/four-skills-earth-data-science/" target="_blank">market research of hiring managers in industry and public agencies </a> also  identified **Python** as a highly desired programming background for new employees. 
2. **Python is free and open source:** This means that anyone can use it without worrying about licenses. This also makes it easy to migrate code over to cloud and high performance computing (HPC) environments, given that there are no license restrictions. 
3. **Python has an active open source community for science:** There is an active open source community who are building **Python** tools to support scientific applications, such as the widely used scientific packages <a href="https://github.com/numpy/numpy" target="_blank">numpy</a> and <a href="https://github.com/pandas-dev/pandas" target="_blank">pandas</a>.
5. **Python is the core language for many spatial data tools:** Example tools that use **Python** as their core include ESRI ArcGIS, QGIS and others. This makes the language versatile if you wish to create macros (i.e. widgets) in a Desktop tool like QGIS. 


## Where to Run Python Code

There are many different ways to write and run **Python** code. In this textbook, you will learn how to write code using the Jupyter environment (discussed below). However, you can also write code at the command line (using the terminal), in a text editor, or in another tool such as Spyder or PyCharm. 

### Write Python Code Using Interactive Development Environments (IDE) Such as Jupyter Notebook

An interactive development environment (IDE) is a graphical interface that supports writing code efficiently by allowing you interactively write, test, and debug code.

#### Benefits of Using IDEs

There are many benefits of using IDEs for programming. 

**IDEs Make Coding Faster - Tab Completion**: Most IDEs have built in shortcuts that make it easier to write code quickly. Tab completion is a great example of this. 

For example, you can try the following in **Jupyter Notebook**:
1. add a new code cell
2. type `import os`, and hit return
3. then type `os.get` and hit <kbd>tab</kbd> 

```python
import os

# What happens when you hit tab after typing the t in os.get?
os.get
```

What happens? You get a list of all commands that begin with `os.get`!

Once you get the hang of tab completion, you will see how much more quickly you can code. It also makes it easier to avoid mistakes when typing commands such as `os.getcwd()`, which identifies the current working directory.

Tab completion also helps with paths to directories, files, etc - allowing you to generate paths to objects using tab <kbd>tab completion</kbd> after you have started to type a path. 

**Work With Objects and Files**: Tools like Spyder and PyCharm will show you objects that exist in your environment that have been created by your code.

<figure>
 <a href="{{ site.url }}/images/earth-analytics/run-python-options/pycharm.png">
 <img src="{{ site.url }}/images/earth-analytics/run-python-options/pycharm.png" alt="PyCharm is an interactive development environment (IDE) that can be used to run Python code interactively, access other files on your computer, and access objects created by your code."></a>
 <figcaption> PyCharm is an interactive development environment (IDE) (with a free, basic tier) that can be used to run Python code interactively, access other files on your computer, and access objects created by your code. Source: <a href="https://semanti.ca/blog/?recommended-ide-for-data-scientists-and-machine-learning-engineers" target="_blank">semanti.ca</a>.
 </figcaption>
</figure>

<figure>
 <a href="{{ site.url }}/images/earth-analytics/run-python-options/spyder.png">
 <img src="{{ site.url }}/images/earth-analytics/run-python-options/spyder.png" alt="Spyder is free interactive development environment (IDE) for Python that allows you to access other files on your computer, and access objects created by your code."></a>
 <figcaption> Spyder is free interactive development environment (IDE) for Python that allows you to access other files on your computer and access objects created by your code. Source: <a href="https://semanti.ca/blog/?recommended-ide-for-data-scientists-and-machine-learning-engineers" target="_blank">semanti.ca</a>.
 </figcaption>
</figure>


Some IDEs such as Jupyter Lab, PyCharm and Spyder will also make it easy for you to work within a working directory that may contain many different files. 

<figure>
 <a href="{{ site.url }}/images/earth-analytics/run-python-options/jupyterlab.png">
 <img src="{{ site.url }}/images/earth-analytics/run-python-options/jupyterlab.png" alt="Jupyter Lab is a free interactive development environment (IDE) for Python that allows you to run code interactively and work with multiple files, including Jupyter Notebook files, on your computer at one time."></a>
 <figcaption> Jupyter Lab is a free interactive development environment (IDE) for Python that allows you to run code interactively and work with multiple files, including Jupyter Notebook files, on your computer at one time. Source: <a href="https://medium.com/@swaroopkml96/jupyterlab-and-google-drive-integration-with-google-colab-42a8d64a9b63" target="_blank">Swaroop Kumar</a>.
 </figcaption>
</figure>

**Most IDEs for Python are free**: For example, Spyder is a free IDE that comes with the Anaconda **Python** distribution. The base version of PyCharm is also free but you need to pay for the full version if you want complete debugging functionality. 

The <a href="{{ site.url }}/courses/intro-to-earth-data-science/open-reproducible-science/jupyter-python/">Jupyter Platform, including Jupyter Notebook,</a> is completely free for you to use. As **Jupyter Notebook**  supports reproducible science by allowing you to connect code, data, documentation, and associated inputs and outputs, all of our Earth Analytics courses and this textbook use **Jupyter Notebook** to support open reproducible science. In fact, the lessons that you are reading now were generated from **Jupyter Notebooks** files!


### Use Text Editors To Write Python Code 

Many people use text editors for writing **Python** code. 

One way to use text editors is to create **Python** scripts (.py files) and then run them at the command line (see below). 

Alternatively, some text editors, such as Atom, have plugins that allow you to run code directly in the text editor like you would in PyCharm or Spyder. 

Some people prefer using text editors to write **Python** code because they are light weight, making them easier to use to edit code quickly, and have nice features such as automatic color coding of code, text editing options such as find/replace, and the ability to directly connect to repositories on GitHub.com to track changes to files and share code with others. 

Learn more about the benefits of <a href="{{ site.url }}/workshops/setup-earth-analytics-python/text-editors-for-science-workflows/">different text editors</a> including Atom, Nano, and Sublime Text. 

### Write Python Code Using the Terminal

You can also execute Python code at the command line using the terminal. 

#### Execute Python Commands In the Terminal 

One way to do this is to open up a terminal, and type `python`. This will send you into an interactive **Python** session where you can import packages and run code.

The following example launches an interactive **Python** session to import the `os` package and then run the `os.getcwd()` function to get the current working directory. The output of the commands are displayed under the executed code. 

```bash
$ python
  Python 3.7.3 | packaged by conda-forge | (default, Jul  1 2019, 21:52:21) 
  [GCC 7.3.0] :: Anaconda, Inc. on linux
  Type "help", "copyright", "credits" or "license" for more information.
$ import os
$ os.getcwd()
  '/home/jpalomino'
```

Writing code interactively in the terminal is a nice way to quickly test out a few code lines. However, it is much more efficient to create scripts (.py files) where you can save the code and rerun it.

#### Write Scripts That Can Run in the terminal

Alternatively, a more efficient approach to using the terminal with **Python** is to write **Python** scripts. These script files have a `.py` extension. You can then call the script at the terminal using:

```bash
$ # Execute a python script named myscript.py at the command line
$ python myscript.py
```

To write scripts, you will want to use either an IDE or a text editor as discussed above.


### Other Ways to Write Python Code

**Python** is also used in many GIS applications. Tools like QGIS and ArcGIS that support working with geospatial data often have command line interfaces that allow you to execute **Python** code. 

Both QGIS and ArcGIS also have **Python** packages that are specifically created to run analyses and access other functionality in their software.

<a href="https://pro.arcgis.com/en/pro-app/arcpy/get-started/what-is-arcpy-.htm" target="_blank">ArcPy</a> is used by ArcGIS users to access proprietary functionality that ESRI has built to work with geospatial data. With a license, users can use ArcPy programmatically access the same analyses and workflows that can be executed using the user interface. The ArcPy package is maintained by ESRI.

<a href="https://docs.qgis.org/testing/en/docs/pyqgis_developer_cookbook/" target="_blank">PyQGIS</a> is used by QGIS users to programmatically access the functionality provided by the free, open source QGIS software. The PyQGIS package is maintained by the open source community of geospatial **Python** users. 

<figure>
 <a href="{{ site.url }}/images/earth-analytics/run-python-options/qgis-python-console.png">
 <img src="{{ site.url }}/images/earth-analytics/run-python-options/qgis-python-console.png" alt="QGIS provides a built-in console to run Python code, including use of the PyQGIS package, directly in the desktop user interface."></a>
 <figcaption> QGIS provides a built-in console to run Python code, including use of the PyQGIS package, directly in the desktop user interface. Source: <a href="https://gis.stackexchange.com/questions/227613/export-shp-geometry-into-wkb-format-using-pyqgis" target="_blank">Stack Exchange</a>.
 </figcaption>
</figure>

