---
layout: single
title: 'Using Python Conda Environments to Create Reproducible Workflows and to Manage Dependencies: Everything That You Need to Know'
excerpt: "A conda environment is a self contained Python environment that allows you to run differen versions of Python on your computer. Learn how to create conda environments to support open reproducible science."
authors: ['Will Norris', 'Jenny Palomino', 'Leah Wasser']
category: [courses]
class-lesson: ['open-reproducible-science']
permalink: /courses/intro-to-earth-data-science/open-reproducible-science/get-started-open-reproducible-science/introduction-to-python-conda-environments/
nav-title: "Conda Environments"
dateCreated: 2019-08-23
modified: 2019-08-29
module-type: 'class'
class-order: 1
course: "intro-to-earth-data-science"
week: 1
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

* Understand how dependency management can play a large role in `Python` programming.
* Be able to use conda environments to manage your third party libraries.

</div>


## Conda Environments in Python 

### The Third Party Library Issue

Most projects written in `Python` require a certain set of third party libraries that aren't in the `Python` standard library. There is a good chance you have used at least one of these libraries such as numpy, matplotlib, or pandas. Third party libraries are critical to making `Python` the great tool it is; developers all over the world are constantly improving the functionality `Python` provides by writing it themselves. When we require one of these third party libraries in our workflow they are called dependencies, because our workflow depends on them to function.

While having a plethora of open source functionality available to the community is one of `Python`'s greatest strengths, dependency management is a major friction point for many `Python` programmers. This is especially true for `Python` programmers who are not dedicated software engineers! 

In `Python`, regardless of what project you are working on, your computer will store third party libraries in the same location. This means that if you depend on GDAL 2.4.2 in an older project and GDAL 3.0.1 in your brand new project, you will need a way to store these dependencies separately. If they aren't stored separately, `Python` will not be able to tell the difference between the two that are both installed in the same location. 

<figure>
   <a href="{{ site.url }}/images/earth-analytics/python/python-environment-dependency-issues.jpg">
   <img src="{{ site.url }}/images/earth-analytics/python/python-environment-dependency-issues.jpg" alt="Dependency conflicts can cause significant issues when working with `Python`. Conda allows you to install multiple environments on your computer and to address dependency issues."></a>
   <figcaption>Dependency conflicts can cause significant issues when working with `Python`. Conda allows you to install multiple environments on your computer and to address dependency issues.
   </figcaption>
</figure>


### Python Environments 

A `Python` environment is simply a dedicated directory where specific dependencies can be stored and maintained. Environments have unique names and can be activated when we need them allowing us to have ultimate control over the libraries that are installed at any given time. 

There is no harm in creating many environments, so it is common to see programmers using a fresh environment for each project they work on. Often times information about your environment will assist you in debugging certain errors, so starting with a clean one for each project can help you control the number of variables to consider when looking for bugs. 

When it comes to creating environments, we have two choices; we can create a virtual environment (venv) using pip to install packages or create a conda environment with conda installing packages for us. 

On this page, we will focus on conda environments due to several strengths it has over pip and virtual environments, which we will discuss next. 


## What is Conda

<a href="https://docs.conda.io/en/latest/" target="_blank">Conda</a> is a package and environment management tool that allows you to install `Python` packages on your computer as well as create and manage multiple `Python` environments, each containing different packages. 

While we will predominately use conda for the installation and management of `Python` libraries, it is important to note that conda can install and manage software of many different languages; this can be incredibly important when working with external dependencies that aren't built in `Python`. 


## Why Conda

As we mentioned previously, when it comes to installing packages we have two options: pip and conda. Pip stands for Pip Installs Packages and is the default package manager available in `Python`. Conda, on the other hand, is an environment manager that aims to do what pip does with added functionality. 

There are several reasons that make conda such a strong contender for managing your `Python` environments over pip. 

### 1. Conda is Cross Platform 

Libraries available on conda are stored on the Anaconda Cloud and can easily be installed on any system. Conda libraries are stored as binary files, which makes them easy for conda to unpack anywhere you have the Anaconda distribution downloaded. Pip packages on the other hand are stored as wheel's or source distributions, which require a compiler to unpack. This means we need `Python` installed to install packages with pip, which brings us to our next point. 
    
### 2. Conda Can Install `Python` 

One of the great strengths of conda is being able to create a new environment that runs a specific version of `Python`. Anything installed with pip requires a wheel or source distribution for the `Python` compiler to break down. Unfortunately, this means that pip cannot directly install versions of `Python`. It also means we have to install our preferred `Python` distribution before even starting the process of working with a new virtual environment. 
    
### 3. Environments are Native to Conda 

As discussed previously, when using pip we must use a virtual environment as our environment to separate out dependencies. However, ```virtualenv``` is a `Python` library itself. With some configuration and other wrappers, virtual environments can provide a satisfactory development environment, but conda environments are ready to go from the get go. 

### 4. Conda is Better at Dependency Management

Pip makes no attempt to check if all of your dependencies are satisfied at once. Instead, pip may allow incompatible dependencies to be installed depending on the order you install packages. Conda instead uses what they call a "satisfiability solver", which checks that all dependencies are met at all times. This comes with a performance hit due to having to comb through every dependency on each install, but will save you headaches down the road. 
    
### 5. Conda Manages External Dependencies

Pip is really lacking when it comes to managing and tracking external dependencies and accessing all of the available libraries out there. GDAL is a prime example of a package that can be installed easily through conda, but is horribly difficult to install any other way. Part of this is due to the fact that GDAL is not a native `Python` application, and conda has a much easier time dealing with that. 

While we prefer using conda, there is no clear consensus whether pip or conda are better and many people don't consider them to even be in direct competition with each other. While they both install packages, conda is an entirely different beast, capable of doing much more than pip at the cost of increased complexity. For a simple workflow, the benefits of conda may not be worth the extra effort to get up and running, however for working with geospatial libraries conda will be a major help. 


## Channels in Conda

### Default and Personal Channels

Conda doesn't just have a single repository where all uploaded packages live. When a package is uploaded to conda, it must be uploaded to a specific channel, which is just a separate URL where packages published to that channel reside. 

There is a ```default``` conda channel where the stock conda packages live. These packages are maintained by conda and are generally very stable. With no configuration done, whenever you run ```conda install x```, conda will search its ```default``` channel for that package; if the package isn't on that channel it will throw an error. 

When a user publishes their own conda package, it is automatically uploaded to their personal channel. This means when you upload a shiny new package to Anaconda Cloud, in order to download it you will need to use a command like: 

```$ conda install -c mychannel myshinynewpackage```

The problem with this is that mixing channels can lead to all kinds of weird issues and errors in `Python`. Much like having two different versions of GDAL installed in the same place, mixing channels can confuse conda's satisfiability solver for managing dependencies; the resulting errors can make it look like you have a package installed, however `Python` will fail to find dependencies at runtime. 

### Conda-Forge

The `Python` community has responded to this mixing channel issue and created a community managed channel that solves the channel mixing issues associated with default and personal conda channels. This community managed channel is called ```conda-forge```, which has thousands of contributers and functions very similar to PyPi (pip's central package repository). ```conda-forge``` mandates that your dependencies all be installed via ```conda-forge``` or the ```default``` channels; by requiring this, any package installed via conda-forge should not have issues with mixing channels of dependencies. 

```conda-forge``` aims to do better than PyPi by providing an automated testing suite along with more peer review of code before it is published. Overall these extra rules make ```conda-forge``` an excellent choice for your workflow, and will likely save you massive headaches down the road as your list of dependencies grows with your project.


## How to Create Conda Environments

In order to create a conda environment, we first need to install an Anaconda distribution. To do this we have two main options, Anaconda and Miniconda. 

Anaconda ships with a plethora of libraries and software pre-installed; however, it is large (~3Gb) and can potentially lead to dependency conflicts as you install new packages. Miniconda, on the other hand, is a streamlined version only containing critical packages and software such as the conda package manager and a basic `Python` environment; it is predominately designed for those who know what packages they need and don't want or need the extra installations. 

In this <a href="https://www.earthdatascience.org/workshops/setup-earth-analytics-python/setup-git-bash-conda/">lesson on installing conda</a>, we discuss the advantages of Miniconda vs Anaconda and show you how to install Miniconda.  

Once you have conda installed on your machine, we can create our first conda env!

```bash
$ conda create -n myenv
```

Here, we create a simple conda environment using the set conda defaults. If we would like to ensure we are running `Python` 3.6, we could instead do this: 

```bash
$ conda create -n myenv Python=3.6
```

You are also always able to build a conda environment from a yml file, which is a simple file that contains a list of dependencies and which channels you prioritize downloading them on. 

```bash
$ conda env create -f environment.yml
```

## Making Use of Conda Environments

### How to List Available Conda Environments

Up to this point we have constructed one or multiple conda environments. In order to make use of a conda environment, it must be activated by name. Conda doesn't expect us to remember every environment name we create over time, so we have a built in command to list all that are available: 

```bash
$ conda env list
```

This will list out the names and the locations of each of our available environments like such: 

```bash
$ myenv                     /Users/test/anaconda3/envs/myenv
$ otherenv                  /Users/test/anaconda3/envs/otherenv
```

### How to Activate an Environment for Use

Now that we have the name of the env we would like to use, to activate it for use all we have to do is: 

```bash
$ conda activate myenv
```

After this is run, your terminal window will begin with ```(myenv)``` signifying you are now running inside of your conda env. 

Once inside a conda environment, anything installed will install specifically to this environment allowing there to be ultimate control when installing and managing dependencies for each project.

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


<div class="notice--info" markdown="1">

## Additional Resources

1. <a href="https://phys.org/news/2016-08-science-movement.html" target="_blank">The value of open science</a>
2. <a href="https://genomebiology.biomedcentral.com/articles/10.1186/s13059-015-0850-7" target="_blank">Five selfish reasons to work reproducibly - Florian Markowetz</a>
3. <a href="http://journals.plos.org/plosbiology/article?id=10.1371/journal.pbio.1002303" target="_blank"> Computing Workflows for Biologists: A Roadmap</a>

</div>

