---
layout: single
title: 'Install and Import Python Packages'
excerpt: 'This tutorial walks you through how to install and import python packages.'
authors: ['Martha Morrissey','Leah Wasser', 'Software Carpentry']
modified: 2018-07-31
category: [courses]
class-lesson: ['open-science-python']
permalink: /courses/earth-analytics-python/python-open-science-toolbox/install-and-import-python-packages/ 
nav-title: 'Install and Import Packages'
week: 1
sidebar:
    nav:
author_profile: false
comments: true
order: 5
course: "earth-analytics-python"
topics:
   reproducible-science-and-programming: ['python']
---
{% include toc title="In This Lesson" icon="file-text" %}

This tutorial walks you through how to install and import python packages

<div class='notice--success' markdown="1">

## <i class="fa fa-graduation-cap" aria-hidden="true"></i> Learning Objectives

At the end of this activity, you will be able to:

* Be able to install a Python package using terminal. 
* Be able to explain what a package is in Python.


## <i class="fa fa-check-square-o fa-2" aria-hidden="true"></i> What You Need

* You will also need to have the earth-analytics-python environment set up. Instructions for setting here: [Set up earth analytics python environment]({{ site.url }}/workshops/setup-earth-analytics-python/setup-python-anaconda-earth-analytics-environment/)
 
</div>

Information below is adapted from materials developed by [Conda Documentation](https://conda.io/docs/user-guide/tasks/manage-pkgs.html) on managing packages. 

## What is a Package?

A package, in Python is a bundle of pre-built functionality. You can think of a package like a toolbox filled with tools. The tools in the toolbox can be compared to functions in Python. Except when working with Python, the tools, do things like calculate a mathematical function like a sum or create a plot. There are many different packages available for python. Some of these are optimized for scientific applications including:

* Statistics
* Machine learning
* Using geospatial data 
* Visualizing data


## Where To Get Python Packages 

There are many different repositories where Python libraries are maintained and can be installed from. When installing libraries on your computer or in an online environment, it is important to consider where the library is maintained. 

There are three main python package repositories to download python libraries from:
* **Conda:** this is the default repository that is used and maintained for the Anaconda distribution of Python. To install libraries from conda, you use the syntax `conda install` at the command line..
* **Conda-forge:(( Conda-forge is community maintained. We have found that  installing many of the spatial libraries using conda-forge will minimize library conflicts.
* **Pip:** Python Package Index (pip) is another way to install python packages. 


<i class="fa fa-star"></i> **Data Tip:**
Sometimes python libraries are on github. You can install python libraries from github using `pip install git+git://github.com/path-to-github-user/repo-name.git`
{: .notice--success}

It’s good practice to download as many packages as possible from the same repository. For example is you use pip to install geopandas and then try to install shapely from conda-forge, the odds of conflicts increase. When you encounter these conflicts, often you will not be able to load the libraries and start coding. Conflicts between package dependencies can thus be frustrating when all you want to do is start coding and instead you need to figure out how to properly install a library.  

For consistency, in this course you will download most libraries from the **conda-forge** repository.

### Install a Package In a Python Environment

You can add as many packages as you want to a Python environment. However, it is important to keep track of what environment you are adding the package to. If you add a the geopandas python package to your root python environment and then try to use geopandas in another environment, it won’t work! 

To add a package you need to complete the following steps:
1. Open a terminal so you have access to the command line.
2. Activate the python environment that you wish to add the package to. 
3. Install the package that you want to add to that environment 

Note, the example code below assumes that you have already setup the earth-analytics-python environment. The code below will activate that environment and then add the `statsmodels` library to it. 
Note that you are using conda to install statsmodels in this example.


``` bash

source activate earth-analytics-python
conda install conda-forge statsmodels

```
On Windows: 

``` bash

activate earth-analytics-python
conda install conda-forge statsmodels

```

Note that you can also install a library to an environment directly using the --name argument.  To install a specific library such as SciPy into an existing environment “myenv” you’d use the following code:

```bash

conda install conda-forge --name myenv SciPy

```

To install the scipy library to the earth-analytics-python environment, you’d use the code below:

```bash

conda install conda-forge  --earth-analytics-python scipy

```

Following the examples above, if you do not either specify the environment name, OR activate the environment that you wish to install the package to, then the package installs into the current, active environment. The code below will install a package into the currently active environment

```bash

conda install conda-forge bokeh

```

In the example below, you use `conda` rather than `conda-forge` to install a package:

```bash

source activate earth-analytics-python
conda install packagename

```


### View List of All Installed Packages in an Environment

Sometimes you want to view all of the packages installed in a particular environment. To see the installed packages in the activate environment in the terminal type: 
 
``` bash

conda list

```

Conda list will show you: 
1. What packages are installed
2. What version of each package is installed
3. Where you installed each package from (pip, conda, conda-forge)

IMPORTANT: note that when you run `conda list` it’s listing libraries installed in the current active environment.
 
```
(earth-analytics-python)~ username $ conda list
# packages in environment at //anaconda/envs/earth-analytics-python:
#
affine                    2.1.0                      py_1    conda-forge
alembic                   0.9.7                     <pip>
altair                    1.2.1                      py_0    conda-forge
appnope                   0.1.0                    py36_0    conda-forge
asn1crypto                0.22.0                   py36_0    conda-forge
attrs                     17.4.0                     py_0    conda-forge
backports                 1.0                      py36_1    conda-forge
backports.functools_lru_cache 1.4                      py36_1    conda-forge
blas                      1.1                    openblas    conda-forge
bleach                    2.0.0                    py36_0    conda-forge
boost                     1.65.1                   py36_0    conda-forge

```


## Import a Package in Python 
Once you have installed the packages that you require, you can call them in `python` at the command line, in a script or in a Jupyter notebook. You have to explicitly call and load each library that you need in your notebook or script in order for the functions (or tools) in the library to be available in your code. 
Reproducibility Tip: IMPORTANT: Load all of the packages that you will need in the first code cell of a Jupyter notebook. By doing this, you or anyone using your Notebook will know what libraries they need to install in order to run your Notebook.
 
Once the package is loaded you can use it in your code. Like this:

```
import numpy
numpy.sin(0)
0
```
Import _____ (name of package) 


### Package Shortcuts or Aliases

In the example above, sin function was called using the full python library name numpy.sin. Doing this over and over will make your code more verbose. Thus you will often see abbreviations or aliases used to call functions within a specific package. The syntax to create an library abbreviation is:

``` import _____ (name of package) as ____```

Using the example above, create an abbreviation for the numpy package. It’s common to use `np` for numpy:

```
import numpy as np
numpy.sin(0)
0
```

<figure>
 <a href="{{ site.url }}/images/courses/earth-analytics/python-interface/import-package.png">
 <img src="{{ site.url }}/images/courses/earth-analytics/python-interface/import-package.png"></a>
 <figcaption> Jupyter Notebook with a rendered markdown cell. 
 </figcaption>
</figure>

### Import Libraries at the Top of Your Script

It is good practice to import all of the packages that you will need to run code in your notebook in the first code cell in a Jupyter notebook. This allows anyone looking at your code - to immediately know what packages they need to run the code. To import a package you use the `import` function. Your notebook will then look like this:

<figure>
 <a href="{{ site.url }}/images/courses/earth-analytics/python-interface/import_packages-first-cell.png">
 <img src="{{ site.url }}/images/courses/earth-analytics/python-interface/import_packages-first-cell.png"></a>
 <figcaption> Jupyter Notebook with the first cell importing the package numpy to be used with the abbreviations.
 </figcaption>
</figure>

Once you have imported all of the packages that you need in your code, you have access to all of the functions contained within each library. An example of the functions available in numpy package is below
np.() And hit the tab key and then a list of callable functions will appear. 

<figure>
 <a href="{{ site.url }}/images/courses/earth-analytics/python-interface/tab-complete.png">
 <img src="{{ site.url }}/images/courses/earth-analytics/python-interface/tab-complete.png"></a>
 <figcaption> Jupyter Notebook with the first cell importing the package numpy to be used with the abbreviations.
 </figcaption>
</figure>


