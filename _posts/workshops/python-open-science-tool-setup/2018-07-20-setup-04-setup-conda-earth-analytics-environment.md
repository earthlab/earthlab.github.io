---
layout: single
category: courses
title: 'Set Up Your Conda Earth Analytics Python Environment'
excerpt: 'Conda environments allow you to easily manage the Python package installations on your computer. Learn how to install a conda environment using a yml file.'
authors: ['Leah Wasser', 'Jenny Palomino', 'Martha Morrissey', 'Will Norris']
modified: 2020-01-15
module: "setup-earth-analytics-environment"
permalink: /workshops/setup-earth-analytics-python/setup-python-conda-earth-analytics-environment/
nav-title: 'Set up Conda Environment'
week: 0
sidebar:
    nav:
author_profile: false
comments: true
order: 4
topics:
    reproducible-science-and-programming: ['python']
redirect_from:
  - "/workshops/setup-earth-analytics-python/setup-python-anaconda-earth-analytics-environment/"
---
{% include toc title="In This Lesson" icon="file-text" %}

In this lesson, you will learn how to install a conda environment from a .yml file that contains a list of desired **Python** packages. You will install a conda environment called `earth-analytics-python`, which has been designed specifically for the **Python** lessons on this website.


<div class='notice--success' markdown="1">

## <i class="fa fa-graduation-cap" aria-hidden="true"></i> Learning Objectives

At the end of this activity, you will be able to:

* Install a new environment using conda.
* View a list of the available environments in conda.
* Activate, update and delete conda environments.


## <i class="fa fa-check-square-o fa-2" aria-hidden="true"></i> What You Need

You should have **Bash** and the Miniconda distribution of **Python** 3.x setup on your computer and an `earth-analytics` working directory. Be sure you have:

* Completed <a href="{{ site.url }}/workshops/setup-earth-analytics-python/setup-git-bash-conda/">the setup for Git, Bash and Conda</a>.
* Created a `earth-analytics` directory on your computer.

</div>

Information below is adapted from materials developed by the Conda documentation for <a href="https://docs.conda.io/projects/conda/en/latest/user-guide/install/" target="_blank">installing conda</a> and <a href="https://docs.conda.io/projects/conda/en/latest/user-guide/tasks/manage-environments.html" target="_blank">managing conda environments</a>. 


## Why Use Conda Environments for Python

Conda allows you to have different environments installed on your computer to access different versions of **Python** and different libraries. Sometimes libraries conflict which causes errors and packages not to work. 

To avoid conflicts, we created an environment called `earth-analytics-python` that contains all of the libraries that you will need for the **Earth Analytics Python** course lessons on this website.

<div class='notice--success' markdown="1">

<i class="fa fa-star"></i> **Data Tip:** For general information about conda environments, see the section below on **About Conda Environments**.   

For a more detailed explanation of conda environments, see the Intro to Earth Data Science textbook page on <a href="{{ site.url }}/courses/intro-to-earth-data-science/python-code-fundamentals/use-python-packages/introduction-to-python-conda-environments/">Using Conda Environments to Manage Python Dependencies</a>.

You can also check out the <a href="https://docs.conda.io/projects/conda/en/latest/user-guide/concepts/environments.html" target="_blank">documentation on conda environments</a>.  

{: .notice--success }

</div>


## Install the Earth Analytics Python Conda Environment

To install the `earth-analytics-python` environment, you will need to follow these steps: 

1. Fork and clone a GitHub repository from `https://github.com/earthlab/earth-analytics-python-env` to your `earth-analytics` directory. 
    * This repository contains a file called `environment.yml` that contains the instructions to install the environment.
    * For a refresher on forking/cloning repositories, see the section below on **Fork and Clone GitHub Repository** at the bottom of this lesson. 
2. If it's not already open, open the Terminal on your computer (e.g. Git Bash for Windows or Terminal on a Mac/Linux).
3. In the Terminal, set your directory to the cloned `earth-analytics-python-env` dir using `cd` to change directories (e.g. `cd earth-analytics-python-env`).
4. Once you are in the `earth-analytics-python-env` directory, you can create your environment. To do this run: `conda env create -f environment.yml`.
    * Once the environment is installed you can activate it using: `conda activate earth-analytics-python`.
5. To view a list of all conda environments available on your machine run: `conda info --envs`.

IMPORTANT: **always make sure that the earth-analytics-python environment is activated** before doing work for lessons on this website.

Note that it takes time to install of the packages found in the earth-analytics-python environment as it needs to download and install each library. Also, you need to have internet access for this to run! 

<i class="fa fa-star"></i> **Data Tip:**
The instructions above will only work if you run them in the directory where you placed the environment.yml file.
{: .notice--success }

<i class="fa fa-exclamation-circle" aria-hidden="true"></i> **Windows Users:** A reminder that the lessons on this website assume that you are using Git Bash as your primary terminal. 
{: .notice--success}


## About Conda Environments

### What is a YAML (.yml) File?

When you work with conda, you can create custom lists that tell conda where to install libraries from, and in what order. You can even specify a particular version. 

You write this list using  <a href="http://yaml.org/" target="_blank">YAML</a> (Yet Another Markup Language). This is an alternative to using `pip` to install **Python** packages.  

In previous steps, you used a custom .yml list to install all of the **Python** libraries that you will need to complete the **Python** lessons on this website. This .yml list is customized to install libraries from the repositories and in an order that minimizes conflicts. 

If you run into any issues installing the environment from the .yml, let us know! 

Next, explore your new conda environment. Here’s what part of the .yml file looks like:

```
name: earth-analytics-python
channels:
  - conda-forge
  - defaults

dependencies:
  - python=3.7
  - pip
  # Core scientific python
  - numpy
  - matplotlib
```

Notice at the top of the file there is the environment name. This file has a few key parts: 

1. Name: the name of the environment that you will call when you want to activate the environment. The name `earth-analytics-python` is defined in the environment.yml file.

2. Channels: this list identifies where packages will be installed from. There are many options including conda, conda-forge and pip. You will be predominately using conda-forge for the `earth-analytics-python` environment. 

3. Dependencies: Dependencies are all of the things that you need installed in order for the environment to be complete. In the example, **Python** version 3.7 is specified. The order in which the libraries should be installed is also specified. 


## Use Conda Environments

You can have different **Python** environments on your computer. Conda allows you to easily jump between environments using a set of commands that you run in your terminal. 

This section provides an overview of various commands to manage your conda environments. 

For more detailed instructions for using these commands, see the Intro to Earth Data Science textbook page on <a href="{{ site.url }}/courses/intro-to-earth-data-science/python-code-fundamentals/use-python-packages/use-conda-environments-and-install-packages/">Installing Python Packages in Conda Environments</a>.

Or, have a look at the <a href="https://docs.conda.io/projects/conda/en/latest/user-guide/tasks/manage-environments.html#viewing-a-list-of-your-environments" target = "_blank">Conda documentation notes that review the steps below and more!</a>


### View a List of All Installed Conda Environments

You can see a list of all installed conda environments by typing:

```bash

conda info --envs

```

If you want to use a particular environment that you have installed on your computer, you need to activate it. 

For example, if a **Python** package such as `geopandas` is only installed in the `earth-analytics-python` environment, and not the default conda environment, you will not be able to access it (e.g. import it to `Jupyter Notebook`), unless you have the `earth-analytics-python` environment activated.


### Activate a Conda Environment

**To activate an environment**, use the Terminal to navigate to your earth-analytics directory (e.g. `cd` to the directory). Then, type the following command to activate the environment (e.g. `earth-analytics-python`):

```bash
conda activate earth-analytics-python
``` 

<a href="https://docs.conda.io/projects/conda/en/latest/user-guide/tasks/manage-environments.html" target="_blank">For older installations of conda (versions prior to 4.6)</a> on Mac, Linux, and Git Bash for Windows, type:

```bash
source activate earth-analytics-python
```

<i class="fa fa-exclamation-circle" aria-hidden="true"></i> **Windows Users:** The first time that you try to run the "conda activate" command, you may be asked to configure Git Bash to use "conda activate". You can do this by running the command "conda init bash", just one time. After that, Git Bash will be configured to use "conda activate" moving forward.  
{: .notice--success}

Once the environment is activated, the name of the activated environment will appear in parentheses on the left side of your terminal (e.g. `(earth-analytics-python`). 

<i class="fa fa-star"></i> **Data Tip:**
Note that after you restart the Terminal, the `earth-analytics-python` environment is no longer active. You will need to activate the `earth-analytics-python` environment each time you start the Terminal by running the appropriate command provided above for your operating system. 
{: .notice--success}


### Deactivate a Conda Environment 

If needed, you can deactivate a conda environment. Deactivating the environment switches you back to the default environment in your computer. 

```bash
conda deactivate

```

###  Delete a Conda Environment

If you ever want to delete an envrionment, you must first deactivate that environment and then type: 

```bash
conda env remove --name myenv
``` 

and replace `myenv` with the name of the environment that you want to remove. 

**Remember to never delete your root environment.** 


### Update a Conda Environment Using a YAML File

Once you have created a conda environment, you can update it anytime by first activating the environment and then running the `conda env update` command.

The example below updates the `earth-analytics-python environment` using the `environment.yml` file. In this example, the command `conda env update` is run in the same directory that contains the `environment.yml` file.

```bash
$ conda activate earth-analytics-python
$ conda env update -f environment.yml
```

Running this command will update your current `earth-analytics-python` environment to include the most current versions of the packages listed in that environment file.



<div class="notice--success" markdown="1">

**How to Fork and Clone a GitHub Repository**

This section provides the basic steps for forking a **GitHub** repository (i.e. copying an existing repository to your `Github` account) and cloning a forked repository (i.e. downloading your forked repository locally to your computer). 

For a more detailed explanation of these steps, see the Intro to Earth Data Science textbook chapter on <a href="{{ site.url }}/courses/intro-to-earth-data-science/git-github/version-control/fork-clone-github-repositories/">Copy (Fork) and Download (Clone) GitHub Repositories</a>.

**1. Fork a Repository on GitHub.com**

You can `fork` an existing **GitHub** repository from the main `Github.com` page of the repository that you want to copy (example: `https://github.com/earthlab/earth-analytics-python-env`).

On the main `Github.com` page of the repository, you will see a button on the top right that says `Fork`. 

Click on the `Fork` button and select your `Github.com` account as the home of the forked repository. 

<figure>
 <a href="{{ site.url }}/images/earth-analytics/git-version-control/git-fork-repo.gif">
 <img src="{{ site.url }}/images/earth-analytics/git-version-control/git-fork-repo.gif" alt="You can create a copy of repositories created by other users on Github by forking their repository to your Github account."></a>
 <figcaption> You can create a copy of repositories created by other users on Github by forking their repository to your Github account. 
 </figcaption>
</figure>


**2. Clone a Repository to Local Computer or JupyterHub**

To download your forked copy of the `earth-analytics-python-env` repository to your computer, open the Terminal and change directories to your `earth-analytics` directory (e.g. `cd ~`, then `cd  earth-analytics`).

Then, run the command `git clone` followed by the URL to your fork on **GitHub** (e.g. `https://github.com/your-username/earth-analytics-python-env`). Be sure to change `your-username` to your `Github.com` account username.  

```bash
cd ~
cd earth-analytics
git clone https://github.com/your-username/earth-analytics-python-env
```

</div>





