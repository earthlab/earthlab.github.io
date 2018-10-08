---
layout: single
title: 'Install and Import Python Packages'
excerpt: 'This tutorial walks you through how to install and import python packages.'
authors: ['Martha Morrissey','Leah Wasser', 'Software Carpentry']
modified: 2018-09-25
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

This tutorial walks you through how to install and import `Python` packages.

<div class='notice--success' markdown="1">

## <i class="fa fa-graduation-cap" aria-hidden="true"></i> Learning Objectives

At the end of this activity, you will be able to:

* Explain what a package is in `Python`.
* Install a `Python` package using terminal. 


## <i class="fa fa-check-square-o fa-2" aria-hidden="true"></i> What You Need

* You will also need to have the earth-analytics-python environment set up. Instructions for setting up this environment are here: <a href="{{ site.url }}/workshops/setup-earth-analytics-python/setup-python-anaconda-earth-analytics-environment/">Set up earth analytics python environment</a>
 
</div>

Information below is adapted from materials developed by Anaconda on managing packages: <a href="https://conda.io/docs/user-guide/tasks/manage-pkgs.html" target = "_blank">Conda Documentation</a>.

## What is a Package?

In `Python`, a package is a bundle of pre-built functionality. You can think of a package like a toolbox filled with tools. The tools in the toolbox can be compared to functions in `Python`. 

When working with Python, the "tools" (i.e. functions) do things like calculate a mathematical operation like a sum or create a plot. There are many different packages available for `Python`. Some of these are optimized for scientific tasks including:

* Statistics
* Machine learning
* Using geospatial data 
* Visualizing data


## Where To Get Python Packages 

There are many different repositories where `Python` packages are maintained and from where they can be installed. When installing libraries on your computer or in an online environment, it is important to consider where the package is maintained. 

There are three main python package repositories to download `Python` libraries from:
* **Conda:** this is the default repository that is used and maintained for the Anaconda distribution of `Python`. To install libraries from conda, you use the syntax `conda install` at the command line..
* **Conda-forge:** Conda-forge is community maintained. We have found that installing many of the spatial packages using conda-forge will minimize conflicts between packages.
* **Pip:** `Python` Package Index (pip) is another way to install `Python` packages. 

<i class="fa fa-star"></i> **Data Tip:**
Sometimes `Python` libraries are on `Github.com`. You can install `Python` libraries from `Github.com` using `pip install git+git://github.com/path-to-github-user/repo-name.git`
{: .notice--success}

It is good practice to download as many packages as possible from the same repository. For example, if you use pip to install geopandas and then try to install shapely from conda-forge, the odds of conflicts increase. 

When you encounter these conflicts, often you will not be able to load the libraries and start coding. Conflicts between package dependencies can be frustrating, when all you want to do is start coding, and instead, you need to figure out how to properly install a package.  

For consistency, in this course, you will download most packages from the **conda-forge** repository.

### Install a Package In a Python Environment

You can add as many packages as you want to a `Python` environment. However, it is important to keep track of which environment you are adding the package to. If you add the `geopandas` package to your root `Python` environment and then try to use `geopandas` in another environment, it won’t work! 

To add a package, you need to complete the following steps:
1. Open a terminal so you have access to the command line.
2. Activate the `Python` environment that you wish to add the package to. 
3. Install the package that you want to add to that environment 

Note, the example code below assumes that you have already setup the `earth-analytics-python` environment. The code below will activate that environment and then add the `statsmodels` package to it. 

Note that you are using conda to install the `statsmodels` package in this example.


``` bash

source activate earth-analytics-python
conda install conda-forge statsmodels

```
On Windows: 

``` bash

activate earth-analytics-python
conda install conda-forge statsmodels

```

Note that you can also install a package to an environment directly using the --name argument.  To install a specific library, such as `sciPy`, into an existing environment called “myenv”, you would use the following code:

```bash

conda install conda-forge --name myenv sciPy

```

To install the `scipy` library to the `earth-analytics-python` environment, you’d use the code below:

```bash

conda install conda-forge  --earth-analytics-python scipy

```

Following the examples above, if you do not either specify the environment name, OR activate the environment that you wish to install the package to, then the package installs into the current, active environment. The code below will install a package called `bokeh` into the currently active environment.

```bash

conda install conda-forge bokeh

```

If a desired package is not available for installation with conda-forge but is available for installation with conda, you can simply use `conda` rather than `conda-forge` to install a package:

```bash

source activate earth-analytics-python
conda install packagename

```


### View List of All Installed Packages in an Environment

Sometimes you want to view all of the packages installed in a particular environment. To see the installed packages in the activate environment in the terminal, type: 
 
``` bash

conda list

```

The results of `conda list` will show you: 
1. What packages are installed
2. What version of each package is installed
3. Where you installed each package from (pip, conda, conda-forge)

IMPORTANT: note that when you run `conda list`, it is listing packages installed in the current active environment.
 
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

Once you have installed the packages that you require, you can call them in `Python` at the command line, in a script or in a `Jupyter Notebook` file. You have to explicitly call and load each package that you need in your notebook or script in order for the functions (or tools) in the package to be available in your code. 
 
You can import `Python` packages using `import package-name`. Once a package has been imported, you can call functions from that package as follows:

```
import numpy
numpy.sin(0)
0
```



### Package Shortcuts or Aliases

In the example above, the sin function was called using the full `Python` name: `numpy.sin`. Doing this over and over will make your code more verbose. Thus, you will often see abbreviations or aliases used to call functions within a specific package. The syntax to create an library abbreviation is:

``` import _____ (name of package) as ____```

Using the example above, you can create an abbreviation for the `numpy` package. It is common to use `np` for numpy:

```
import numpy as np
numpy.sin(0)
0
```

<figure>
 <a href="{{ site.url }}/images/courses/earth-analytics/python-interface/import-package.png">
 <img src="{{ site.url }}/images/courses/earth-analytics/python-interface/import-package.png" alt= "Jupyter Notebook with code cell to import the Python packages called numpy and pandas using the alias np and pd."></a>
 <figcaption> Jupyter Notebook with code cell to import the Python packages called numpy and pandas using the alias np and pd. 
 </figcaption>
</figure>


### Import Libraries at the Top of Your Script

It is good practice to import all of the packages that you will need in the first code cell of a `Jupyter Notebook` file. This allows anyone looking at your code to immediately know what packages they need to run the code.

<figure>
 <a href="{{ site.url }}/images/courses/earth-analytics/python-interface/import_packages-first-cell.png">
 <img src="{{ site.url }}/images/courses/earth-analytics/python-interface/import_packages-first-cell.png" alt= "Jupyter Notebook with the first code cell importing the numpy package (and many others) to be used with abbreviations or aliases (e.g. np)."></a>
 <figcaption> Jupyter Notebook with the first code cell importing the numpy package (and many others) to be used with abbreviations or aliases (e.g. np).
 </figcaption>
</figure>

Once you have imported all of the packages that you need in your code, you have access to all of the functions contained within each package and you can query for a list of available functions. 

For example, using the alias `np` for `numpy`, you can get a list of the functions available using `np.()` and hitting the tab key. A list of callable functions will appear. 

<figure>
 <a href="{{ site.url }}/images/courses/earth-analytics/python-interface/tab-complete.png">
 <img src="{{ site.url }}/images/courses/earth-analytics/python-interface/tab-complete.png" alt= "Jupyter Notebook with a code cell to get a list of the functions available in numpy, which was imported as np."></a>
 <figcaption> Jupyter Notebook with a code cell to get a list of the functions available in numpy, which was imported as np.
 </figcaption>
</figure>
