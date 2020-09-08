---
layout: single
title: 'Introduction to Jupyter For Python'
excerpt: "The Jupyter ecosystem contains many useful tools for working with Python including Jupyter Notebook, an interactive coding environment. Learn how the components and functionality of Jupyter Notebook can help you implement open reproducible science workflows."
authors: ['Jenny Palomino', 'Leah Wasser']
category: [courses]
class-lesson: ['jupyter-notebook']
permalink: /courses/intro-to-earth-data-science/open-reproducible-science/jupyter-python/
nav-title: "Intro to Jupyter"
dateCreated: 2019-07-15
modified: 2020-09-03
module-title: 'Jupyter For Python'
module-nav-title: 'Jupyter For Python'
module-description: 'This chapter teaches you how to use Jupyter Notebook, an interactive environment where you can write and run code such as Python and add text that describes your workflow using Markdown.'
module-type: 'class'
chapter: 3
class-order: 3
course: "intro-to-earth-data-science-textbook"
week: 1
estimated-time: "2-3 hours"
difficulty: "beginner"
sidebar:
  nav:
author_profile: false
comments: true
order: 1
topics:
  reproducible-science-and-programming: ['jupyter-notebook']
redirect_from:
  - "/courses/earth-analytics-bootcamp/get-started-with-open-science/jupyter-notebook-interface/"
  - "/courses/earth-analytics-bootcamp/git-github-version-control/manage-jupyter-notebooks/"
  - "/courses/earth-analytics-python/python-open-science-toolbox/use-jupyter-notebooks/"
---

{% include toc title="In This Chapter" icon="file-text" %}

<div class='notice--success' markdown="1">

## <i class="fa fa-ship" aria-hidden="true"></i> Chapter Three - Introduction to Jupyter For Python 

In this chapter, you will learn how using `Jupyter Notebook` can help you implement open reproducible science workflows and get familiar with the `Jupyter Notebook` interface to run and create new code and `Markdown` cells. You will also learn how to create new directories and files using `Jupyter Notebook`. 

After completing this chapter, you will be able to:

* List the components and functionality of `Jupyter Notebook` and explain how it supports open reproducible science.
* Launch and navigate the `Jupyter Notebook` dashboard.
* Open and create `Jupyter Notebook` files (`.ipynb`).
* Run code and `Markdown` cells within `Jupyter Notebook` to execute `Python` code and render `Markdown` text.
* Manage directories and files using `Jupyter Notebook`.


## <i class="fa fa-check-square-o fa-2" aria-hidden="true"></i> What You Need

Be sure that you have completed the instructions on <a href="{{ site.url }}/workshops/setup-earth-analytics-python/">Setting up Git, Bash, and Conda on your computer</a> to install the tools for your operating system (Windows, Mac, Linux). 

</div>


## Jupyter Notebook for Open Reproducible Science

If you recall from <a href="{{ site.url }}/courses/intro-to-earth-data-science/open-reproducible-science/get-started-open-reproducible-science/open-science-tools-git-bash-jupyter/">Chapter One on Open Reproducible Science</a>, Jupyter is an open source platform that contains a suite of tools including:

* Jupyter Notebook: A browser-based application that allows you to create and share documents (i.e. Jupyter Notebook files) that contain live code, equations, visualizations and narrative text.
* Jupyter Lab: A browser-based application that allows you to access multiple Jupyter Notebook files as well as other code and data files
* Jupyter Hub: A multi-person version of Jupyter Notebook and Lab that can be run on a server.

The Jupyter Notebook file format (`.ipynb` ) allows you to combine descriptive text, code blocks and code output in a single file. When you run the code, it generates the outputs, including plots and tables, within the notebook file. You can then export the notebook to a `.pdf` or `.html` that can then be shared with anyone.

This format is powerful as you can:

1. Share the notebook itself with anyone who might want to run it and
2. Convert the notebook to a PDF or HTML format that can be viewed like a report

You can use Jupyter Notebooks (`.ipynb` files) to document workflows and to share code for data processing, analysis and visualization.


### Combine Markdown and Code in Jupyter Notebooks To Document Workflows

Using Markdown alongside code in Jupyter Notebooks has many advantages:

* **Human readable:** it's much easier to read a web page or a report containing text and figures. By adding Markdown text around your code, your project becomes more user friendly and easier to understand.
* **Simple syntax:** Markdown uses simple formatting syntax that can be learned quickly. This reduces the learning curve for designing well-documented Jupyter Notebooks. 
* **Helpful Reminder for Your Future Self:** When you code, consider your future self. If you leave your future self a well documented set of Jupyter Notebook files that both run your code and describe the steps, then all components of your work are clearly documented. You (and your future self)do not have to remember what steps, assumptions, or tests were used to complete the workflow.
* **Easy to Modify:** You can easily extend or refine analyses contained within a Jupyter Notebook file by modifying existing or adding new code blocks.
* **Flexible export formats:** Analysis results stored in Jupyter Notebook files can be disseminated in various formats including HTML, PDF and slideshows.
* **Easy to share:** If all of your analysis is contained and described in a one or more notebooks, it makes it easy to share with a colleague. Your colleague can also easily replicate your workflow.

<i class="fa fa-star"></i> **Data Tip:**
You can easily create fully reproducible Jupyter Notebook files that can be run online using <a href="https://mybinder.org/" target = "_blank">my binder</a>. 
{: .notice--success }


### Jupyter Notebooks Are Beneficial to Your Colleagues

The link between data, code and results makes Jupyter Notebook powerful. You can share your entire workflow with your colleagues and they can quickly see your process. 

You can also write reports using .ipynb files which contain code and data analysis results. To enrich the document, you can add text, just like you would in a Word document that describes your workflow, discusses your results and presents your conclusions - alongside your analysis results.


### Jupyter Notebooks Are Beneficial to You & Your Future Self

Jupyter notebooks (`.ipynb`) are efficient. If you need to make changes to your workflow, you can simply modify the code and run the report again. Your future self will appreciate it too. 

Jupyter Notebooks allows you to add documentation to remind yourself of your process. Further, all of the code that you used is in the notebook ready to be rerun or modified at any time.

<i class="fa fa-star"></i> **Data Tip:**
Many of the Earth Lab lessons, including this one, were created using Jupyter Notebooks!
{: .notice--success }


### Convert Notebooks to Shareable HTML Files

You can save Jupyter Notebooks containing code and markdown as `.html` files. When you save a notebook as `.html`, it creates a nicely rendered web page with the code and outputs visible along with the markdown rendered as nicely formatted text. This means that you can share the file with a colleague and they can see your entire workflow - without having to rerun your analysis. You will learn how how to export to `.html` and other formats later in this textbook.


## What is Jupyter Notebook?

<a href="http://jupyter.org/index.html" target = "_blank">Jupyter Notebook</a> is an Integrated Development Environment (IDE) that allows you to write code, navigate files on our computer, inspect variables and more. 

An IDE is different from a text editor, as IDEs allow you to interactively write, test, and debug code. 

While there are other commonly used `Python` IDEs such as Spyder (which comes with the `Python` Anaconda distribution) and PyCharm, in this textbook, you will use `Jupyter Notebook` as your IDE. 


### Advantages of Jupyter Notebook

`Jupyter Notebook` provides users with useful functionality including the ability to:

* Write and run code interactively.
* Document all aspects of a workflow using a combination of well-written programming code and text.
* Share work with colleagues who can see all of the code, the code outputs, and text explanation.

This functionality supports open reproducible science by facilitating documentation and collaboration on workflows.


### Jupyter Notebook Makes Coding and Documentation More Efficient

`Jupyter Notebook` can help save your time:

* **Shortcuts**: `Jupyter Notebook` has <a href="{{ site.url }}/courses/intro-to-earth-data-science/open-reproducible-science/jupyter-python/jupyter-notebook-shortcuts/">different shortcuts</a> for running cells, adding new cells and formatting the notebook to help save you time.
* **Autocomplete** : Autocomplete is available to quickly find function names, arguments for those functions, and variables that are stored in your environment. This makes typing your code easier and less error-prone. Hitting the `tab` button while typing will prompt `Jupyter Notebook` to help you complete the name of a variable or function that you want to call. 
* **Markdown Integration**: You can combine text and code in the same document. This allows you to document and explain the code you have written and make your workflow more reproducible. 

`Jupyter Notebook` is also an open source product and free under the <a href="https://github.com/jupyter/jupyter/blob/master/LICENSE" target = "_blank">BSD 3-clause "New" or "Revised" License</a>. 


## Components of Jupyter Notebook

The components of `Jupyter Notebook` include:

1. **The Jupyter Notebook IDE** The `Jupyter Notebook` interactive development environment (IDE) is the application that launches in a web browser like Firefox or Safari and is the environment where you write and run your code.

2. **Notebook Files (.ipynb)** The notebook file (.ipynb) is a file type that you can use to store your `Python` code and `Markdown` text for individual projects and workflows. 

3. **Kernels** A kernel runs your code in a specific programming language. `Jupyter Notebook` supports over 40 different languages. In this class, you will use the `Python` kernel within the `Jupyter Notebook` IDE. 


### Structure of Jupyter Notebook Files

The `Jupyter Notebook` IDE allows you to organize and execute your work using individual `Jupyter Notebook` files with the file extension `.ipynb`. 

A `Jupyter Notebook` file (`.ipynb`) has three main parts, which are highlighted in the image below: 
* Menu bar
* Toolbar 
* Cells 

<figure>
 <a href="{{ site.url }}/images/courses/earth-analytics/python-interface/sample-jupyter-nb.png">
 <img src="{{ site.url }}/images/courses/earth-analytics/python-interface/sample-jupyter-nb.png" alt= "The components of a Jupyter Notebook file include a menu bar, toolbar, and cells just like the ones shown in this image."></a>
 <figcaption>The components of a Jupyter Notebook file include a menu bar, toolbar, and cells just like the ones shown in this image. 
 </figcaption>
</figure>

Throughout this chapter, you will review the menu and toolbar to complete different tasks within your `Jupyter Notebook` files such as saving changes, running code, etc. 


### Markdown and Code Cells in Jupyter Notebook

In addition to the menu and toolbar, a `Jupyter Notebook` consists of a set of cells, which can be specified to store documentation text such as `Markdown` or programming code such as `Python`. 

Text written using the `Markdown` syntax can be rendered in a cell that is of the cell type `Markdown`. 

<figure>
 <a href="{{ site.url }}/images/courses/earth-analytics/python-interface/md-cell.png">
 <img src="{{ site.url }}/images/courses/earth-analytics/python-interface/md-cell.png" alt= "Jupyter Notebook with a non-rendered Markdown cell."></a>
<figcaption> Jupyter Notebook with a non-rendered Markdown cell. 
 </figcaption>
</figure>

<figure>
 <a href="{{ site.url }}/images/courses/earth-analytics/python-interface/rendered-md-cell.png">
 <img src="{{ site.url }}/images/courses/earth-analytics/python-interface/rendered-md-cell.png" alt= "Jupyter Notebook with a rendered Markdown cell."></a>
 <figcaption> Jupyter Notebook with a rendered Markdown cell. 
 </figcaption>
</figure>

You can run code (e.g. `Python`) using the Code cells in `Jupyter Notebook`. 

Code is written in code chunks. When you run the code in a Code cell, the code output displayed below.

<figure>
 <a href="{{ site.url }}/images/courses/earth-analytics/python-interface/basic-code-cell.png">
 <img src="{{ site.url }}/images/courses/earth-analytics/python-interface/basic-code-cell.png" alt= "Jupyter Notebook with a code cell that contains 4 + 5. When you run the code, the output is 9 and is displayed below the code cell."></a>
 <figcaption> Jupyter Notebook with a code cell that contains 4 + 5. When you run the code, the output is 9 and is displayed below the code cell. 
 </figcaption>
</figure>

You can check the cell type of any cell within a `Jupyter Notebook` by clicking in the cell and looking at the Cell Type in Toolbar.

<figure>
 <a href="{{ site.url }}/images/courses/earth-analytics/python-interface/select-code-cell.png">
 <img src="{{ site.url }}/images/courses/earth-analytics/python-interface/select-code-cell.png" alt="You can check the cell type of any cell in Jupyter Notebook using the Toolbar. The default cell type is Code."></a>
 <figcaption> You can check the cell type of any cell in Jupyter Notebook using the Toolbar. The default cell type is Code.
 </figcaption>
</figure>

In the next sections of this chapter, you will learn how to run cells and add new cells to your `Jupyter Notebook` file to build out your workflow. 
