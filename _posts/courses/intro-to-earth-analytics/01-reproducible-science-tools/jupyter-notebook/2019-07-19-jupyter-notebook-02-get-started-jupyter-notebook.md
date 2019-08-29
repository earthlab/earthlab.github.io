---
layout: single
title: 'Get Started With Jupyter Notebook For Python'
excerpt: "The Jupyter ecosystem contains many useful tools for working with Python including Jupyter Notebook, an interactive coding environment. Learn how to launch and close Jupyter Notebook sessions and how to navigate the Jupyter Dashboard to create and open Jupyter Notebook files (.ipynb)."
authors: ['Jenny Palomino', 'Leah Wasser']
category: [courses]
class-lesson: ['jupyter-notebook']
permalink: /courses/intro-to-earth-data-science/open-reproducible-science/jupyter-python/get-started-with-jupyter-notebook-for-python/
nav-title: "Jupyter Notebook For Python"
dateCreated: 2019-07-15
modified: 2019-08-29
module-type: 'class'
class-order: 3
course: "intro-to-earth-data-science"
week: 1
sidebar:
  nav:
author_profile: false
comments: true
order: 2
topics:
  reproducible-science-and-programming: ['jupyter-notebook']
---

{% include toc title="On This Page" icon="file-text" %}

<div class='notice--success' markdown="1">

## <i class="fa fa-graduation-cap" aria-hidden="true"></i> Learning Objectives

* Launch and close a `Jupyter Notebook` session.
* Navigate the `Jupyter` dashboard.
* Create and open `Jupyter Notebook` files (`.ipynb`).

</div>


## Launch Jupyter Notebook From the Terminal

Throughout this chapter, you will learn how to use `Jupyter Notebook` to write and document your `Python` code. First, you need to know how to open `Jupyter Notebook`, which is done in the `Terminal`.

It is ideal (but not required) to launch `Jupyter Notebook` from the working directory where all of the notebook files that you wish to use live, so you can easily access the files you need.

<i class="fa fa-info-circle" aria-hidden="true"></i> **IMPORTANT:** the `jupyter notebook` command requires that you have `Jupyter Notebook` installed on your computer! `Jupyter Notebook` was installed when you created the `earth-analytics-python` environment as a part of the setup for this textbook. Be sure to activate the environment in the terminal using the command `conda activate earth-analytics-python` before launching `Jupyter Notebook`.
{: .notice--success}


### Use Bash to Change to Your Working Directory

Begin by opening your terminal (i.e. `Git Bash` for Windows or the `terminal` on Mac or Linux). 

Change the current working directory to your desired directory (e.g. `earth-analytics` under your home directory) using `cd directory-name`.You can then check that the current working directory has been updated (`pwd`).

```bash
$ cd ~/earth-analytics
$ pwd
    /users/jpalomino/earth-analytics
```

### Begin a Jupyter Notebook Session From the Terminal

Now you can start a new `Jupyter Notebook` session by typing the command `jupyter notebook` in the `Terminal`.

```bash
$ jupyter notebook
```

<figure>
 <a href="{{ site.url }}/images/courses/earth-analytics/bootcamp/jupyter-interface/terminal-launch.png" width = "125%">
 <img src="{{ site.url }}/images/courses/earth-analytics/bootcamp/jupyter-interface/terminal-launch.png" width = "125%" alt="You can use Shell (Terminal) to open Jupyter Notebook with the command, Jupyter Notebook."></a>
 <figcaption> You can use Shell (Terminal) to open Jupyter Notebook with the command, Jupyter Notebook.
 </figcaption>
</figure>

<i class="fa fa-info-circle" aria-hidden="true"></i> **NOTE:** If you get an error `jupyter: command not found`, this means that you have not activated the conda environment that you installed for this textbook. Be sure to activate the environment in the terminal using the command `conda activate earth-analytics-python` before running the `jupyter notebook` command.
{: .notice--success}

When you type this command into the terminal, it will launch a local web server on your computer. This server runs the `Jupyter Notebook` interface. 

You will notice that the `Terminal` is running commands to start your `Jupyter Notebook` session. Be sure to leave the `Terminal` open while you use `Jupyter Notebook`. It is running a local server for `Jupyter Notebook` so that you can interact with it in your web browser. 

<figure>
 <a href="{{ site.url }}/images/courses/earth-analytics/bootcamp/jupyter-interface/terminal-jupyter.png">
 <img src="{{ site.url }}/images/courses/earth-analytics/bootcamp/jupyter-interface/terminal-jupyter.png" alt="This is what the Terminal looks like with a Jupyter Notebook session running."></a>
 <figcaption> This is what the Terminal looks like with a Jupyter Notebook session running.
 </figcaption>
</figure>

If your commands were successful, your default web browser will open with a new tab that displays your `Jupyter Notebook` dashboard.

The dashboard serves as a homepage for `Jupyter Notebook`. Its main purpose is to display the notebooks and files in the current directory. 

<figure>
 <a href="{{ site.url }}/images/courses/earth-analytics/python-interface/nb-dashboard.png">
 <img src="{{ site.url }}/images/courses/earth-analytics/python-interface/nb-dashboard.png" alt= "This is what Jupyter Notebook dashboard will look like when you launch it. If there are any directories and files, you will see them listed in the dashboard, just like the data directory and notebook called week1.ipynb are listed in this image."></a>
 <figcaption> This is what Jupyter Notebook dashboard will look like when you launch it. If there are any directories and files, you will see them listed in the dashboard, just like the data directory and notebook called week1.ipynb are listed in this image.
 </figcaption>
</figure>

<i class="fa fa-star"></i> **Data Tip:** While `Jupyter Notebook` looks like an online interface, when you launch it from the terminal, like you did in this lesson, it is actually running locally on our computer. You do not need an internet connection to run `Jupyter Notebook` locally.
{: .notice--success}

## Navigate Files Using the Jupyter Notebook Dashboard

To find files in the Jupyter Notebook dashboard, you can click on the name of a directory (e.g. `ea-bootcamp-day-1`), and the dashboard will update to show you the contents of the directory. 

<figure>
 <a href="{{ site.url }}/images/courses/earth-analytics/bootcamp/jupyter-interface/ea-bootcamp-day-1-contents.png">
 <img src="{{ site.url }}/images/courses/earth-analytics/bootcamp/jupyter-interface/ea-bootcamp-day-1-contents.png" alt="You can click on the name of directory in the Jupyter Notebook Dashboard to navigate into that directory and see the contents."></a>
 <figcaption> You can click on the name of directory in the Jupyter Notebook Dashboard to navigate into that directory and see the contents.
 </figcaption>
</figure>

You can return to the parent directory of your current directory in the `Jupyter Notebook` session by clicking on the folder icon on the top menu bar.  

<figure>
 <a href="{{ site.url }}/images/courses/earth-analytics/bootcamp/jupyter-interface/dashboard-parent.png">
 <img src="{{ site.url }}/images/courses/earth-analytics/bootcamp/jupyter-interface/dashboard-parent.png" alt="You can use the Jupyter Notebook dashboard to return to the parent directory of any subdirectory."></a>
 <figcaption> You can use the Jupyter Notebook dashboard to return to the parent directory of any subdirectory.
 </figcaption>
</figure>


## Create New Jupyter Notebook Files

You can create new `Jupyter Notebook` files (.ipynb) from the dashboard.

On the top right of the dashboard, there are two buttons for `Upload` and `New`. `Upload` allows you to import an existing `Jupyter Notebook` file (.ipynb) that is not already in that directory.

You can create a new `Python 3` `Jupyter Notebook` file (.ipynb) by clicking on `New` and selecting `Python 3`. A new notebook will open a new tab in your web browser. 

<figure>
 <a href="{{ site.url }}/images/courses/earth-analytics/bootcamp/jupyter-interface/create-notebook.png">
 <img src="{{ site.url }}/images/courses/earth-analytics/bootcamp/jupyter-interface/create-notebook.png" alt="When you use the Jupyter Notebook dashboard menu to create new Jupyter Notebook files (.ipynb), you will click on the New button and select Python 3."></a>
 <figcaption> You can use the Jupyter Notebook dashboard menu to create new Jupyter Notebook files (.ipynb) by clicking on the New button and selecting Python 3. 
 </figcaption>
</figure>

## Open Jupyter Notebook Files

You can open existing `Jupyter Notebook` files (.ipynb) in the `Jupyter Notebook` dashboard by clicking on the name of the file in the dashboard (e.g. `filename.ipynb`). 

Note: if you don't see the `Jupyter Notebook` file (.ipynb) or directory that you are looking for, you may need to navigate to another directory in the dashboard (see above). You may also need to launch the `Jupyter Notebook` from a different directory.  

## Close Your Jupyter Notebook Session

### Close and Shutdown Jupyter Notebook Files

To close your `Jupyter Notebook` files (.ipynb), you can close the browser tab displaying the notebook, but you still need `Shutdown` the notebook from the dashboard. 

To `Shutdown` a Jupyter Notebook file (.ipynb), click in the checkbox to left of the filename. You will see an orange button named `Shutdown` appear in the top left of the dashboard menu; click on it to `Shutdown` any file that is checked in the list.

<figure>
 <a href="{{ site.url }}/images/courses/earth-analytics/bootcamp/jupyter-interface/shutdown-notebook.png">
 <img src="{{ site.url }}/images/courses/earth-analytics/bootcamp/jupyter-interface/shutdown-notebook.png" alt="You can shutdown Jupyter Notebook files using the Shutdown button on the Jupyter Notebook Dashboard."></a>
 <figcaption> You can shutdown Jupyter Notebook files using the Shutdown button on the Jupyter Notebook Dashboard.
 </figcaption>
</figure>

### Shutdown the Jupyter Notebook Local Server

After all of your notebooks are closed and shut down, you can end your `Jupyter Notebook` session by clicking on the <kbd>QUIT</kbd> button at the top right of the dashboard. You can now close the browswer tab for `Jupyter Notebook`.

If desired, you can also close your terminal by typing the command `exit` and hitting <kbd>Enter</kbd>.

<div class="notice--success" markdown="1">

**NOTE:** You can also shutdown a `Jupyter Notebook` session by clicking in the `Terminal` window and clicking <kbd>Ctrl+c</kbd>. You will be asked to confirm that you want to `Shutdown this notebook server (y/[n])?`.  Type `y` and hit `Enter` to confirm. Then, you can close the `Terminal` by typing the command `exit` and hitting <kbd>Enter</kbd>.

</div>

