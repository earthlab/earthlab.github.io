---
layout: single
title: 'Install Packages in Python'
excerpt: "Packages in Python provide pre-built functionality that adds to the functionality available in base Python. Learn how to install packages in Python using conda environments."
authors: [ 'Leah Wasser', 'Jenny Palomino', 'Will Norris']
category: [courses]
class-lesson: ['python-packages-for-eds']
permalink: /courses/intro-to-earth-data-science/python-code-fundamentals/use-python-packages/use-conda-environments-and-install-packages/
nav-title: "Install Packages"
dateCreated: 2019-09-17
modified: 2020-09-23
module-type: 'class'
course: "intro-to-earth-data-science-textbook"
week: 4
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

* Create a **conda** environment.
* Install a **Python** package in the terminal using **conda**.

</div>

## Create Conda Environments

Previously in this chapter, you learned about **conda** environments and the difference between **conda** and **pip**. On this page, you will learn how to create and work with **conda** environments. You will also learn how to install **Python** packages using the **conda-forge** channel.

In order to create a **conda** environment, you first need to install an **conda** distribution. To do this, you have two main options: **Anaconda** and **Miniconda**.

**Anaconda** ships with a suite of libraries and software pre-installed, which makes it quite large (~3Gb). All of the installed packages can also lead to dependency conflicts as you install new packages. 

**Miniconda**, on the other hand, is a streamlined **conda** distribution. It only contains critical packages and
software such as the **conda** package manager and a basic **Python** environment.

**Miniconda** is predominately designed for users who know what packages they need and do not want or need the extra installations. For this textbook, we suggest that you use the **Miniconda** installation.

<i class="fa fa-star"></i> **Data Tip:** In this <a href="https://www.earthdatascience.org/workshops/setup-earth-analytics-python/setup-git-bash-conda/">lesson on installing conda</a>, you will learn about the advantages of **Miniconda** vs **Anaconda**. You will also learn how to install **Miniconda**.
{: .notice--success}

Once you have **conda** installed on your machine, you can create your first **conda** environment:

```bash
$ conda create -n myenv
```

With that command, you create a basic **conda** environment that relies on the base **Miniconda** installation
of packages. If you want to ensure that you are running **Python** 3.7, you could instead do this:

```bash
$ conda create -n myenv Python=3.7
```

### Build Conda Environment From YAML File

You can also build a **conda** environment from a .yml file. A .yml file is a text file that contains a list of dependencies and which channels you prioritize downloading them on. 

You can use the <a href="https://github.com/earthlab/earth-analytics-python-env/" target="_blank">earth-analytics-python yaml file</a> called environment.yml to perform the setup step below. 

This will install all of the packages that you will need to complete the exercises in both this textbook and the follow-up intermediate textbook that dives more deeply into spatial and remote sensing data.

```bash
$ conda env create -f environment.yml
```

## Use Conda Environments

### List Available Conda Environments

Up to this point, you have constructed one or multiple **conda** environments. In order to make use of a **conda** environment, it must be activated by name. 

**Conda** doesn't expect you to remember every environment name you create over time, so there is a
built-in command to list all that are available:

```bash
$ conda env list
```

This will list out the names and the locations of each of your available environments like such:

```bash
$ base                   *  /Users/test/miniconda3
$ myenv                     /Users/test/anaconda3/envs/myenv
$ otherenv                  /Users/test/anaconda3/envs/otherenv
```

Note that the environment with the asterisk (`*`) next to it is the current active environment. Until you activate a specific environment, the default active environment is the base environment installed with **Miniconda**.

### Activate an Environment for Use

Now that you have the name of the env that you would like to use, you can activate it using:

```bash
$ conda activate myenv
```

After activating your environment, run `conda env list` again, and notice that the asterisk has moved to `myenv` signifying that this environment is currently active.

```bash
$ base                       /Users/test/miniconda3
$ myenv                  *   /Users/test/anaconda3/envs/myenv
$ otherenv                   /Users/test/anaconda3/envs/otherenv
```

Once you have activated a **conda** environment, all installations that you run will be installed specifically to this environment. This allow you to have ultimate control when installing and managing dependencies for each project.

## Update Conda Environments Using a YAML File

Once you have created a conda environment, you can update it anytime by first activating the environment and then running the `conda env update` command. 

The example below updates the `earth-analytics-python` environment using the environment.yml file. In this example, the command `conda env update` is run in the same directory that contains the environment.yml file.

```bash
$ conda activate earth-analytics-python
$ conda env update -f environment.yml
```

Running this command will update your current `earth-analytics-python` environment to include the most current versions of the packages listed in that environment file. 

Note that if you add a new package to that environment.yml file, it will also add that package to the `earth-analytics-python` environment when you run an update using that file.

### Adding a Package to your YAML File

If you wish to add a new package to your environment file, you can do so by updating the environment.yml file. 

Below you see the contents of an example .yml file. The first example does not have **earthpy** in the list of dependencies. 

```
name: earth-analytics-python
channels:
  - conda-forge
  - defaults

dependencies:
  - python=3.7
  - matplotlib
  # Core scientific python
  - numpy
```

Your updated version of the environment.yml may look as follows with the list of dependencies ending with a new package **earthpy**:

```
name: earth-analytics-python
channels:
  - conda-forge
  - defaults

dependencies:
  - python=3.7
  - matplotlib
  # Core scientific python
  - numpy
  - earthpy
```

If you ran `conda env update -f environment.yml` using the second file, it would both update the packages in the environment that already existed and add a new one (**earthpy**) to the environment.

It is ideal to use a .yml file to create environments as it provides you and anyone else who may want to reproduce your workflow with a record of the exact setup of your environment. 

You can think of this .yml file as a recipe for your **Python** environment. It is much easier to send someone a single page of a recipe book than to try to type out all of the instructions by hand. This supports open reproducible science.

However, in a pinch, you may need to install a single package into your environment. You will learn how to do this next.

## Install A Python Package Into an Environment (Without a YAML File)

Imagine that you created and activated a brand new environment using the command below:

```bash
$ conda create -n myenv
$ conda activate myenv
```
You can install a package manually into this environment using `conda install`. Try the following:

Install **earthpy** into that environment using the **conda-forge** channel:

```bash
(myenv) $ conda install -c conda-forge earthpy
```

Here, the ``-c`` means ``--channel`` and tells **conda** to use the **conda-forge**
channel when installing **earthpy**. 

In general it is bad practice to mix channels, and **conda-forge** currently has the most well maintained and broad range of available libraries. **Conda-forge** is also currently the most consistent way to install **GDAL** which you will need for all of the spatial **Python** packages.

## List Installed Dependencies Within an Environment

At this point you have a new environment with **earthpy** installed. To see this installation and what other dependencies were installed, you can use `conda list`.

```bash
(myenv) $ conda list
```

The results of `conda list` will show you:
1. What packages are installed
2. What version of each package is installed
3. Which channel you installed each package from (**pip**, **conda**, **conda-forge**)

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

As `conda list` will tell you which channel was used to download each package, it is useful to review the list, when trying to debug issues that could be potentially related to dependency issues. Often times, an update to a single dependency or a channel mixing issue can break an entire project.  

`Conda list` is also a great way to create a list to share your environment specs with other users online.

<i class="fa fa-star"></i> **IMPORTANT:** note that when you run `conda list`, it is listing packages installed in the current active environment.
{: .notice--success}

### Summary of Installing Packages In Python Environments

You can add as many packages as you want to a **Python** environment. However, it is important to keep track of which environment you are adding the package to.

If you add the **earthpy** package to your root or base **conda** environment for **Python** and then try to use **earthpy** in a different environment, it won’t work!

You will have to install it separately into the each environment to access it within.

To summarize what you have learned above, you need to complete the following steps to install a package:
1. Open a terminal, so you have access to the command line.
2. Activate the **Python** environment that you wish to add the package to.
3. Install the package that you want to add to that environment using either a .yml file or `conda install`.  

<i class="fa fa-star"></i> **Data Tip:** You can also install a package into an environment without activating it by using `conda install conda-forge --name myenv package-name`
{: .notice--success}
