---
layout: single
category: courses
title: 'Set Up Your Anaconda Python Environment'
excerpt: 'This tutorial walks you through installing a conda environment designed for this class.'
authors: ['Jenny Palomino', 'Martha Morrissey', 'Leah Wasser', 'Data Carpentry']
modified: 2019-03-05
module: "setup-earth-analytics-environment"
permalink: /workshops/setup-earth-analytics-python/setup-python-anaconda-earth-analytics-environment/
nav-title: 'Set up Conda Environment'
week: 0
sidebar:
    nav:
author_profile: false
comments: true
order: 4
topics:
    reproducible-science-and-programming: ['python']
---
{% include toc title="In This Lesson" icon="file-text" %}

In this lesson, you will learn how to install a conda environment designed specifically for this class called `earth-analytics-python` from a .yaml file.

<div class='notice--success' markdown="1">

## <i class="fa fa-graduation-cap" aria-hidden="true"></i> Learning Objectives

At the end of this activity, you will be able to:

* Install a new environment in Anaconda
* View a list of the available environments in Anaconda 


## <i class="fa fa-check-square-o fa-2" aria-hidden="true"></i> What You Need

You should have `Bash` and the Anaconda distribution of `Python` 3.x setup on your computer and an `earth-analytics` working directory. Be sure you have:

* Completed <a href="{{ site.url }}/workshops/setup-earth-analytics-python/setup-git-bash-anaconda/">the setup for `Bash` and Anaconda</a>
* Created a `earth-analytics` directory on your computer 

</div>

Information below is adapted from materials developed by the Conda documentation for <a href="https://conda.io/docs/user-guide/install/index.html" target="_blank">installing conda</a> and <a href="https://conda.io/docs/user-guide/tasks/manage-pkgs.html" target="_blank">managing packages</a>. 


## Set up A Conda Python Environment 

### Install the Earth Lab Conda Environment

Anaconda allows you to have different environments installed on your computer to access different versions of `Python` and different libraries. Sometimes libraries conflict which causes errors and packages not to work. 

To avoid conflicts, we created an environment specifically for this earth analytics course that contains all of the spatial libraries that you will need.

<i class="fa fa-star"></i> **Data Tip:**
For more information about conda environments check out the <a href="https://conda.io/docs/user-guide/tasks/index.html" target="_blank">conda documentation</a>.  
{: .notice--success }

To install the earth lab environment, you will need to follow these steps: 

1. Fork and clone a Github repository from `https://github.com/earthlab/earth-analytics-python-env` to your `earth-analytics` directory. This repository contains a file called `environment.yaml` that is needed for the installation.  (For instructions on forking/cloning repositories, see the section below on **Fork and Clone Github Repository**). 
2. Copy the `environment.yaml` file into your `earth-analytics` directory using your file manager. You can also copy the file using `Bash` if you prefer (e.g. `cd earth-analytics-python-env`, then `cp environment.yaml ..` to move the file up to the parent directory `earth-analytics`). 
3. Open the Terminal on your computer (e.g. Git Bash for Windows or Terminal on a Mac/Linux).
4. In the Terminal, navigate to the `earth-analytics` directory (e.g. `cd ~`, then `cd earth-analytics`).
5. Then, type in the Terminal: `conda env create -f environment.yml`

Note that it takes a bit of time to run this setup, as it needs to download and install each library, and that you need to have internet access for this to run! 

<i class="fa fa-star"></i> **Data Tip:**
The instructions above will only work if you run them in the directory where you placed the environment.yml file
{: .notice--success }

Once the environment is installed, **always make sure that the earth-analytics-python environment is activated** before doing work for this class. 

See the instructions further down on this page to **Activate a Conda Environment**. Once the environment is activated, the name of the activated environment will appear in parentheses on the left side of your terminal. 


### Fork and Clone Github Repository

This section provides the basic steps for forking a `Github` repository (i.e. copying an existing repository to your `Github` account) and for cloning a forked repository (i.e. downloading your forked repository locally to your computer). For a more detailed explanation of these steps, see the lesson on <a href="{{ site.url }}/courses/earth-analytics-bootcamp/get-started-with-open-science/get-files-from-github/">Get Files from Github.com.</a>

#### Fork a Repository on Github.com

You can `fork` an existing `Github` repository from the main `Github.com` page of the repository that you want to copy (example: `https://github.com/earthlab/earth-analytics-python-env`).

On the main `Github.com` page of the repository, you will see a button on the top right that says `Fork`. 

Click on the `Fork` button and select your `Github.com` account as the home of the forked repository. 

<figure>
   <a href="https://help.github.com/assets/images/help/repository/fork_button.jpg">
   <img src="https://help.github.com/assets/images/help/repository/fork_button.jpg" alt="Fork an existing Github.com repository to make a copy of other users' files. Source: Github.com."></a>
   <figcaption>Fork an existing Github.com repository to make a copy of other users' files. Source: Github.com.
   </figcaption>
</figure>


#### Clone a Repository to Local Computer 

To download your forked copy of the `earth-analytics-python-env` repository to your computer, open the Terminal and change directories to your `earth-analytics` directory (e.g. `cd ~`, then `cd  earth-analytics`).

Then, run the command `git clone` followed by the URL to your fork on `Github` (e.g. `https://github.com/your-username/earth-analytics-python-env`). Be sure to change `your-username` to your `Github` account username.  

```bash
cd ~
cd earth-analytics
git clone https://github.com/your-username/earth-analytics-python-env
```


### About the Conda Environment

### What is a .yaml File?

When you work with Anaconda, you can create custom lists that tell Anaconda where to install libraries from, and in what order. You can even specify a particular version. You write this list using  <a href="http://yaml.org/" target="_blank">yaml</a>(Yet Another Markup Language). This is an alternative to using `pip` to install `Python` packages.  

In previous steps, you used a custom .yaml list to install all of the `Python` libraries that you will need to complete the lessons in this course. This .yaml list is customized to install libraries from the repositories and in an order that minimizes conflicts. 

If you run into any issues installing the environment from the yaml, let us know! 

Let’s take a minute to explore the conda environment for this course! Here’s what part of the .yaml file looks like:

```
name: earth-analytics-python
channels:
  - conda-forge
dependencies:
  # Core scientific python libraries
  - numpy
  - matplotlib
  - python=3.6
  - pyqt
  - seaborn

  # spatial libraries
  - rasterstats
  - geopy
  - cartopy
  - geopandas
  
```

Notice at the top of the file there is the environment name. This file has a few key parts: 

1. NAME: the name of the environment that you will call when you wish to activate the environment. The name earth-analytics-python is defined in the environment.yml file.

2. Channels: this lists where packages will be installed from. There are many options including conda, conda-forge and pip. You will be predominately using conda-forge for all of the earth-analytics courses. 

3. Dependencies: Dependencies are all of the things that you need installed in order for the environment to be complete. In the example, python version 3.6 is specified because this is because it works best with gdal. The order in which the libraries should be installed is also specified. 


## Manage Your Conda Environment

You can have different `Python` environments on your computer. Anaconda allows you to easily jump between environments using a set of commands that you run in your terminal. 

### View a List of All Installed Conda Environments

You can see a list of all installed conda environments by typing:

```bash

conda info --envs

```

If you want to `Jupyter Notebook` to use a particular environment that you have setup on your computer, you need to activate it. 

For example, if a `Python` package such as `geopandas` is only installed in the earth-analytics-python environment, and not the default anaconda environment, you will not be able to import it to `Jupyter Notebook`, unless you have the earth-analytics-python environment activated.


### Activate a Conda Environment

**To activate an environment**, use the Terminal to navigate to your earth-analytics directory (e.g. `cd` to the directory). Then, type the following command to activate the environment (e.g. earth-analytics-python):

```bash
conda activate earth-analytics-python
``` 

<a href="https://conda.io/projects/conda/en/latest/user-guide/tasks/manage-environments.html" target="_blank">For older installations of Anaconda (versions prior to 4.6)</a> on Mac, Linux, and Git Bash for Windows, type:

```bash
source activate earth-analytics-python
```

<i class="fa fa-exclamation-circle" aria-hidden="true"></i> **Windows Users:** The lessons on this website assume that Windows users are using Git Bash as their primary terminal. If you need to activate a conda environment using the Command Prompt, you will need to use the following command: `activate earth-analytics-python`
{: .notice--success}

Once the environment is activated, the name of the activated environment will appear in parentheses on the left side of your terminal. 

<i class="fa fa-star"></i> **Data Tip:**
Note that after you restart the Terminal, the earth-analytics-python environment is no longer active. You will need to activate the earth-analytics-python environment each time you start the Terminal by running the appropriate command provided above for your operating system. 
{: .notice--success }


### Deactivate a Conda Environment 

If needed, you can deactivate a conda environment. Deactivating the environment switches you back to the default environment in your computer. 


#### Mac and Linux Instructions: 

```bash
Source deactivate earth-analytics-python

```

#### Windows Instructions 

```bash
deactivate earth-analytics-python

```

###  Delete a Conda Environment

If you ever want to delete an envrionment, you must first deactivate that environment and then type: 

```bash
conda env remove --name myenv
``` 

and replace `myenv` with the name of the environment that you want to remove. 

**Remember to never delete your root environment.** 
