---
layout: single
title: 'Introduction to Jupyter Notebook'
excerpt: 'This tutorial walks you through the Jupyter notebook interface.'
authors: ['Martha Morrissey', 'Leah Wasser', 'Data Carpentry']
modified: 2018-07-27
category: [courses]
class-lesson: ['open-science-python']
permalink: /courses/earth-analytics-python/python-open-science-toolbox/intro-to-jupyter-notebooks/
nav-title: 'Intro to Jupyter'
week: 1
sidebar:
    nav:
author_profile: false
comments: true
order: 4
course: "earth-analytics-python"
topics:
   open-science: ['jupyter-notebooks']
---
{% include toc title="In This Lesson" icon="file-text" %}

This tutorial walks you through the Jupyter notebook interface. 

<div class='notice--success' markdown="1">

## <i class="fa fa-graduation-cap" aria-hidden="true"></i> Learning Objectives

At the end of this activity, you will be able to:

* Be able to open Jupyter notebook from the terminal, 
* Be able to write and run Python code and markdown in the Jupyter notebook, 
* Be able to add and run markdown text to a Jupyter notebook

## <i class="fa fa-check-square-o fa-2" aria-hidden="true"></i> What You Need

* You will need to have Git, Bash, and Anaconda setup on your computer to complete this lesson. Instructions for setting up are here: [Setup Git/Bash and Anaconda lesson lesson](/courses/earth-analytics-python/setup-your-python-earth-analytics-environment/setup-git-bash-anaconda/). 
* You will also need to have the earth-analytics-python environment set up. Instructions for setting here: [Set up earth analytics python environment](/courses/earth-analytics-python/setup-your-python-earth-analytics-environment/setup-conda-earth-analytics-env)
* You will need to have completed the [Introduction to Bash Shell lesson](/courses/earth-analytics-python/setup-your-python-earth-analytics-environment/introduction-to-bash-shell/). 

 
</div>
 
Information below is adapted from materials developed by: [Jupyter](http://nbviewer.jupyter.org/github/jupyter/notebook/blob/master/docs/source/examples/Notebook/Notebook%20Basics.ipynb), [Datacamp](https://www.datacamp.com/community/tutorials/tutorial-jupyter-notebook#WhatIs), and [Dataquest](https://www.dataquest.io/blog/jupyter-notebook-tips-tricks-shortcuts/).  



## About Jupyter Notebook

Jupyter Notebooks supports a more reproducible workflow. They allow you to:

* Write and run inline code interactively
* Share your work with colleagues so they can see both your code and the code outputs. 
* Document all aspects of your workflow using a combination of well written code and markdown text.


## Advantages of Jupyter Notebook

Jupyter notebooks also make coding more efficient. 

* **Shortcuts**: Jupyter notebook have different shortcuts for running cells, adding new cells and formatting the notebook to help save you time
* **Autocomplete** : Autocomplete is available to quickly find function names, arguments for those functions and variables that are stored in your environment. This makes typing easier and less error-prone. Hitting tab while typing will prompt  Jupyter to help you complete the name of a function or variable that you want to call. 
* **Markdown Integration**: You can combine text and code in the same document. This allows you to explain the code you’ve written, and  make your workflow more reproducible. 



## Get to Know Jupyter Notebook 

Next, you will explore [Jupyter Notebook](http://jupyter.org/index.html), the Integrated Development Environment (IDE) that you will use to write code, navigate files on our computer, inspect variables and more. An IDE is different from a text editor. IDEs allow you to write, test, and debug code. Other commonly used Python IDEs are Spyder (which comes with the Python Anaconda distribution), and PyCharm. There are many tools to help you code, but in this class you will focus on using Jupyter Notebooks. 
Jupyter Notebooks is open source product and free under the [BSD 3-clause "New" or "Revised" License](https://github.com/jupyter/jupyter/blob/master/LICENSE). 


### How to Start Jupyter Notebook
* Launch via the terminal (by typing jupyter notebook), make sure you are in the earth-analytics directory and that the earth-analytics-python environment is activated. 

``` bash 
$ source activate earth-analytics-python 
$ cd earth-analytics 
$ jupyter notebook 
```

### Jupyter Notebooks combine three components: 

1. **The Jupyter Notebook** The Jupyter Notebook is a web application that launches in a web browser like firefox or safari. The notebook is where you write and run your code.

2. **Kernels** A kernel is the program that runs your code. So for instance if you have `R` on your computer and want to run R code, you’d use an R kernel. If you want to run Python, then you’ll run a Python kernel in Jupyter notebooks. The kernel runs your code in a given language and returns output back to the notebook web application. Jupyter notebook supports over 40 different kernel languages. In this class, you will use Python. Specifically you will use the earth-analytics-python kernel which contains all of the libraries that you need for this course.

3. **Notebook documents** The notebook document is the file that you use to store your code and markdown. Each Jupyter Notebook file has an `.ipynb` extension.


<figure>
 <a href="{{ site.url }}/images/courses/earth-analytics/python-interface/sample-jupyter-nb.png">
 <img src="{{ site.url }}/images/courses/earth-analytics/python-interface/sample-jupyter-nb.png"></a>
 <figcaption> Sample Jupyter Notebook from Jupyter documentation indicating the location of the toolbar, menu bar, cell in command mode, and kernel indicator. 
 </figcaption>
</figure>



When you first start the Jupyter Notebook server, your browser will open to the notebook dashboard. 

<figure>
 <a href="{{ site.url }}/images/courses/earth-analytics/python-interface/nb-dashboard.png">
 <img src="{{ site.url }}/images/courses/earth-analytics/python-interface/nb-dashboard.png"></a>
 <figcaption> Jupyter notebook dashboard with one notebook called week1 and a data folder
 </figcaption>
</figure>

The dashboard serves as a homepage for the notebook. Its main purpose is to display the notebooks and files in the current directory. For this class, you will always work in the [earth-analytics directory](/courses/earth-analytics-python/setup-your-python-earth-analytics-environment/introduction-to-bash-shell/). 


#### Explore the Jupyter Notebook Interface

When  you open or create a new Notebook you will see three main parts: 
* Menu 
* Toolbar 
* Notebook Area and Cells 

### Work With Markdown and Code Cells in Jupyter Notebooks

A jupyter notebook consists of a set of cells that can store text or code. You will focus on code and markdown cells for this lesson. 

* Text Cells: Text cells allow you to write markdown.This is where you will describe your workflow. 
* Code Cells: Allow you to write code. 

<figure>
 <a href="{{ site.url }}/images/courses/earth-analytics/python-interface/select-code-cell.png">
 <img src="{{ site.url }}/images/courses/earth-analytics/python-interface/select-code-cell.png"></a>
 <figcaption> You can change the type of any cell using the drop down. Cell type options including:  code, markdown, Raw NBConvert, and heading. There are also shortcut to enter the command mode to use shortcuts hit the esc key. After to change a cell to markdown hit the “m” key or to change a cell to code hit the “y” key. 
 </figcaption>
</figure>


For a full list of keyboard shortcuts click the help button then the keyboard shortcuts button.  


<figure>
 <a href="{{ site.url }}/images/courses/earth-analytics/python-interface/help-jupyter.png">
 <img src="{{ site.url }}/images/courses/earth-analytics/python-interface/help-jupyter.png"></a>
 <figcaption> Jupyter Notebook help menu. 
 </figcaption>
</figure>

### Markdown Cells in Jupyter

A Jupyter notebook contain text written using the markdown syntax, in a cell that is specified for markdown. 

<figure>
 <a href="{{ site.url }}/images/courses/earth-analytics/python-interface/md-cell.png">
 <img src="{{ site.url }}/images/courses/earth-analytics/python-interface/md-cell.png"></a>
 <figcaption> Jupyter Notebook with a non-rendered markdown cell. 
 </figcaption>
</figure>

<figure>
 <a href="{{ site.url }}/images/courses/earth-analytics/python-interface/rendered-md-cell.png">
 <img src="{{ site.url }}/images/courses/earth-analytics/python-interface/rendered-md-cell.png"></a>
 <figcaption> Jupyter Notebook with a rendered markdown cell. 
 </figcaption>
</figure>



### Code Cells in Jupyter Notebooks


You can add code to the code cells in Jupyter Notebooks. Code is written in code chunks. When you run the code in a cell, the code output displayed below. A cell can be run by hitting the run button or using a keyboard shortcut, as discussed in the next section.

<figure>
 <a href="{{ site.url }}/images/courses/earth-analytics/python-interface/basic-code-cell.png">
 <img src="{{ site.url }}/images/courses/earth-analytics/python-interface/basic-code-cell.png"></a>
 <figcaption> Jupyter Notebook with a code cell that contains 4 + 5. When you run the code, the output is 9 and is displayed below the code cell. 
 </figcaption>
</figure>

For more information on code in Jupyter Notebooks is in the next lesson [Install and Import Python Packages](/courses/earth-analytics-python/python-open-science-toolbox/install-and-import-python-packages). 



### Useful Jupyter Shortcuts For Running Code and Adding Cells

#### Menu Tools vs. Keyboard Shortcuts
* You can manipulate your Jupyter Notebook using the drop down tools from the menu, with keyboard shortcuts, or using both. 
* Keyboard shortcuts allow your workflow to be faster and more efficient. 
* The most important keyboard shortcuts are Enter, which enters edit mode, and Esc, which enters command mode. 
    * **Enter Mode** is indicated  by green around cells and is for editing the contents of a cell 
    * **Command Mode** is indicated by a grey cell border with blue on the left edge. This mode allows you to edit the notebook as a whole. 

The table below shows common tasks in Jupyter and how to do them using keyboard shortcuts or the menu tool. 


Function  | Keyboard Shortcut | Menu Tools
--- | --- | ---
Save notebook  | Esc + s | File → Save and Checkpoint
Create new cell| Esc + a (above), Esc + b (below) | Insert→ cell above Insert → cell below 
Run Cell  | Ctrl + enter| Cell → Run Cell 
Copy Cell | c  | Copy Key
Paste Cell | v | Paste Key
Interrupt Kernel| Esc + i i | Kernel → Interrupt 
Restart Kernel | Esc + 0 0 | Kernel → Restart
Find and replace on your code but not the outputs | Esc + f | N/A
merge multiple cells| Shift + M| N/A
When placed before a function Information about a function from its documentation| ? | N/A




<i class="fa fa-star"></i>**Data Tip:**
Inline magic are commands built into the python kernel and always start with a %. Magic commands are useful shortcuts. Magic commands always start with a % because this symbol isn’t valid in Python. Magic commands also only work on the ipython kernel. Magic commands provide shortcuts to common tasks that would normally take several lines of code to accomplish in Python.  
{: .notice--success }



Magic  | What it does 
--- | --- 
%writefile | Saves the contents of a cell to an external file
%timeit | Shows how long it takes a cell of code to run
%who | List all variables of a global scope
%store | Pass variables between notebooks
%load | Insert code from an external script





<div class="notice--info" markdown="1">

## Additional Resources

* <a href="https://unidata.github.io/online-python-training/introduction.html" target="_blank">More Jupyter Notebook Overview Material</a>

</div>




