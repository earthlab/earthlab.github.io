---
layout: single
title: 'Install Packages in Python'
excerpt: "Packages in Python . Learn how to install packages in Python."
authors: ['Martha Morrissey', 'Leah Wasser', 'Jenny Palomino', 'Will Norris']
category: [courses]
class-lesson: ['python-packages-for-eds']
permalink: /courses/intro-to-earth-data-science/python-code-fundamentals/python-packages-for-eds/install-packages/
nav-title: "Install Packages"
dateCreated: 2019-07-01
modified: 2019-09-23
module-type: 'class'
course: "intro-to-earth-data-science-textbook"
week: 4
sidebar:
  nav:
author_profile: false
comments: true
order: 4
topics:
  reproducible-science-and-programming: ['python']
---
{% include toc title="On This Page" icon="file-text" %}

<div class='notice--success' markdown="1">

## <i class="fa fa-graduation-cap" aria-hidden="true"></i> Learning Objectives

* Install a **Python** package in the terminal. 

</div>
 



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


#### From Will's conda environment page
### Installing Your First Third Party Library 

Our brand new conda env isn't very useful without any new libraries installed. So lets install numpy and see what changes in our env. 

```bash
(myenv) $ conda install -c conda-forge numpy 
```

Here, the ```-c``` means ```--channel``` and tells conda to use the conda-forge channel when installing numpy. In general it is bad practice to mix channels, and right now conda-forge has the most well maintained and broad range of available libraries. 

For example, conda-forge is the only way to install GDAL with a single command.

### How to List Installed Dependencies Within an Environment

At this point we have a new environment with numpy installed. To see this installation and what other dependencies were installed we can simply: 

```bash
(myenv) $ conda list 
```

This will read out a list of all the libraries installed along with their version and what channel they were installed on.

This command will be incredibly useful when trying to debug issues that could be potentially related to dependency issues. Often times an update to a single dependency or a channel mixing issue can break an entire project, and ```conda list``` is the best way to share your environment specs with other users online. 




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

