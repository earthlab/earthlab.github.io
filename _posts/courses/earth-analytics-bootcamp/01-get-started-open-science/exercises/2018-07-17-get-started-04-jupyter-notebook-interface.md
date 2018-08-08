---
layout: single
title: 'The Jupyter Notebook Interface'
excerpt: "Jupyter Notebooks is an interactive environment where you can write and run code and also add text that describes your workflow using Markdown. Learn how to use Jupyter Notebook to run Python Code and Markdown Text."
authors: ['Jenny Palomino', 'Leah Wasser', 'Martha Morrissey',  'Software Carpentry']
category: [courses]
class-lesson: ['get-started-with-open-science']
permalink: /courses/earth-analytics-bootcamp/get-started-with-open-science/jupyter-notebook-interface/
nav-title: "The Jupyter Notebook Interface"
dateCreated: 2018-06-27
modified: 2018-08-08
module-type: 'class'
course: "earth-analytics-bootcamp"
week: 1
sidebar:
  nav:
author_profile: false
comments: true
order: 4
topics:
  reproducible-science-and-programming: ['python']
---
{% include toc title="In This Lesson" icon="file-text" %}

In this lesson, you will learn how to use `Jupyter Notebook` to run `Python` code and render `Markdown` text in existing `Jupyter Notebook` files  (`.ipynb`) . 

<div class='notice--success' markdown="1">

# <i class="fa fa-graduation-cap" aria-hidden="true"></i> Learning Objectives

After completing this hands-on activity, you will be able to:

* List the components and functionality of `Jupyter Notebook` and explain how they support open reproducible science
* Navigate the `Jupyter Notebook` dashboard and open existing `Jupyter Notebook` files (`.ipynb`)
* Run Code and `Markdown` cells within Jupyter Notebook to execute `Python` code and render `Markdown` text
* Create new Code and `Markdown` cells within Jupyter Notebook


# <i class="fa fa-check-square-o fa-2" aria-hidden="true"></i> What You Need

Be sure that you have followed the instructions on <a href="{{ site.url }}/workshops/setup-earth-analytics-python/setup-git-bash-anaconda/">Setting up Git, Bash, and Anaconda on your computer</a> to install the tools for your operating system (Windows, Mac, Linux). 

Be sure that you have completed the previous lessons on <a href="{{ site.url }}/courses/earth-analytics-bootcamp/get-started-with-open-science/intro-shell/">Intro to Shell</a> and <a href="{{ site.url }}/courses/earth-analytics-bootcamp/get-started-with-open-science/get-files-from-github/">Get Files from Github.com.</a> 

This notebook is available in the **ea-bootcamp-day-1** repository that you cloned to `earth-analytics-bootcamp` under your home directory. 
 
 </div>

## Jupyter Notebook

In the lesson on Open Reproducible Science, you learned that `Jupyter Notebook` is a web-based interactive development environment (IDE) that allows you to:

* Write and run code interactively
* Share your work with colleagues so they can see both your code and the code outputs. 
* Document all aspects of your workflow using a combination of well written programming code (e.g. `Python`) and `Markdown` text.

This functionality supports open reproducible science by facilitating and supporting collaboration and documentation. 

The components of `Jupyter Notebook` include:
1. **The Jupyter Notebook IDE** The `Jupyter Notebook` interactive development environment (IDE) is the web application that launches in a web browser like Firefox or Safari and is the environment where you write and run your code.

2. **Notebook documents (.ipynb files)** The notebook document is a file type that you can use to store your `Python` code and `Markdown` text. A `Jupyter Notebook` file has an `.ipynb` extension (e.g. `jpalomino-homework-1.ipynb`)

3. **Kernels** A kernel runs your code in a specific programming language. `Jupyter Notebook` supports over 40 different languages. In this class, you will use `Python`. 

`Jupyter Notebook` also provides functionality for making the coding process more efficient such as keyboard short-cuts as well as auto-complete options using the `Tab` button. You will review this functionality in the hands-on activity.

## Markdown 

`Markdown` is a human readable syntax for formatting text documents and can be used to produce nicely formatted documents including .pdf files and web pages (e.g. .html files). When you format text using `Markdown` in a document, it is similar to using the formatting tools (bold, heading 1, heading 2, etc) in a word processing tool like Microsoft Word or Google Docs. 

However, instead of using buttons to apply formatting, you use syntax such as `**this syntax bolds text in Markdown**` or `# Here is a heading in Markdown`. `Markdown` allows you to format text - such as making headings, italics, bold, and bulleted lists, - add hyperlinks to websites (e.g. URLs), make tables, and more. 

In fact, this webpage that you are looking at right now (and all of the hands-on exercises in this course) use Markdown for formatting!

Using `Markdown` within `Jupyter Notebook` provides an easy and visually-appealing way to document your code's workflow, provide details on your data, and describe your output and results within a single `Jupyter Notebook` file (.ipynb).  

<i class="fa fa-star"></i> **Data Tip:**
Learn more about <a href="http://jupyter-notebook.readthedocs.io/en/stable/examples/Notebook/Working%20With%20Markdown%20Cells.html" target="_blank">Markdown.</a>
{: .notice--success}

Hopefully, by now you understand:

1. How the `Jupyter Notebook` environment works
2. How Jupyter supports open reproducible science through combining programming code, displaying output, and documentation with `Markdown`.

## Launch Jupyter Notebook From the Terminal

In this lesson, you will review how to use `Jupyter Notebook` and the functionality that it provides for documenting open reproducible science. First, you need to know how to open `Jupyter Notebook`, which is done in the `Terminal`.

### Use Bash to Change to Your Desired Working Directory

It is ideal (but not required) to launch `Jupyter Notebook` from the working directory where all of the notebook files that you wish to use live. In this case, these files are in the `earth-analytics-bootcamp` directory.

To launch `Jupyter Notebook`, you should always do the following:

1. change the current directory to your desired working directory. In this case: `~/earth-analytics-bootcamp`
2. run the command `jupyter notebook` in the `Terminal` to launch `Jupyter Notebook`.

<i class="fa fa-info-circle" aria-hidden="true"></i> **IMPORTANT:** the `jupyter notebook` command requires that you have `Jupyter Notebook` installed on your laptop! This was installed as part of the Anaconda installation that you followed as a part of the setup for this course.
{: .notice--success}


First, change the current working directory to `earth-analytics-bootcamp` under your home directory, and then check that the current working directory has been updated.

```bash
$ cd ~/earth-analytics-bootcamp
$ pwd
    /users/jpalomino/earth-analytics-bootcamp
```

### Begin a Jupyter Notebook Session From the Terminal

Now, start a new Jupyter Notebook session by typing the command `jupyter notebook` in the `Terminal`.

```bash
$ jupyter notebook
```

<figure>
 <a href="{{ site.url }}/images/courses/earth-analytics/bootcamp/jupyter-interface/terminal-launch.png" width = "125%">
 <img src="{{ site.url }}/images/courses/earth-analytics/bootcamp/jupyter-interface/terminal-launch.png" width = "125%" alt="You can use Shell (Terminal) to open Jupyter Notebook with the command, Jupyter Notebook."></a>
 <figcaption> You can use Shell (Terminal) to open Jupyter Notebook with the command, Jupyter Notebook.
 </figcaption>
</figure>


When you type this command into the terminal, it will launch a local web server on your computer. This server runs the `Jupyter Notebook` interface. If everything works as planned, your default web browser will open with a new tab that displays your `Jupyter Notebook` environment. 

<figure>
 <a href="{{ site.url }}/images/courses/earth-analytics/bootcamp/jupyter-interface/dashboard.png">
 <img src="{{ site.url }}/images/courses/earth-analytics/bootcamp/jupyter-interface/dashboard.png" alt="This is what Jupyter Notebook dashboard will look like when you launch it"></a>
 <figcaption> This is what the Jupyter Notebook dashboard will look like when you launch it. 
 </figcaption>
</figure>

You will also notice that the `Terminal` is running commands to start your `Jupyter Notebook` session. Be sure to leave the `Terminal` open while you use `Jupyter Notebook`. It is running a local server for `Jupyter Notebook` so that you can interact with it in your web browser. 

<figure>
 <a href="{{ site.url }}/images/courses/earth-analytics/bootcamp/jupyter-interface/terminal-jupyter.png">
 <img src="{{ site.url }}/images/courses/earth-analytics/bootcamp/jupyter-interface/terminal-jupyter.png" alt="This is what the Terminal looks like with a Jupyter Notebook session running."></a>
 <figcaption> This is what the Terminal looks like with a Jupyter Notebook session running.
 </figcaption>
</figure>


<i class="fa fa-star"></i> **Data Tip:** While `Jupyter Notebook` looks like an online interface, when you launch if from the terminal, like you did in this lesson, it is actually running locally on our computer. You do not need an internet connection to run `Jupyter Notebook` locally.
{: .notice--success}


## Navigate the Jupyter Notebook Dashboard

To navigate in the dashboard, you can simply click on the name of a directory (e.g. `ea-bootcamp-day-1`), and the dashboard will update to show you the contents of the directory. 

<figure>
 <a href="{{ site.url }}/images/courses/earth-analytics/bootcamp/jupyter-interface/ea-bootcamp-day-1-contents.png">
 <img src="{{ site.url }}/images/courses/earth-analytics/bootcamp/jupyter-interface/ea-bootcamp-day-1-contents.png" alt="You can click on the name of directory in the Jupyter Notebook Dashboard to navigate into that directory and see the contents."></a>
 <figcaption> You can click on the name of directory in the Jupyter Notebook Dashboard to navigate into that directory and see the contents.
 </figcaption>
</figure>

You can return to the parent directory of your `Jupyter Notebook` session (i.e. the directory from which you launched `Jupyter Notebook`; in this example, `earth-analytics-bootcamp`) by clicking on the folder icon on the top menu bar.  

<figure>
 <a href="{{ site.url }}/images/courses/earth-analytics/bootcamp/jupyter-interface/dashboard-parent.png">
 <img src="{{ site.url }}/images/courses/earth-analytics/bootcamp/jupyter-interface/dashboard-parent.png" alt="You can use the Jupyter Notebook dashboard to return to the parent directory of any subdirectory."></a>
 <figcaption> You can use the Jupyter Notebook dashboard to return to the parent directory of any subdirectory.
 </figcaption>
</figure>


## Open Existing Jupyter Notebook Files

You can open existing `Jupyter Notebook` files (.ipynb) in the `Jupyter Notebook` dashboard. 

Note: if you don't see the `Jupyter Notebook` file (.ipynb) or directory that you are looking for, you may need to navigate to another directory in the dashboard (see above). You may also need to launch the `Jupyter Notebook` from a different directory.  

Opening an existing `Jupyter Notebook` file (.ipynb) is as easy as clicking on the name of the file in the dashboard (e.g. `filename.ipynb`).


## Understand the Structure of Jupyter Notebook Files

A `Jupyter Notebook` has three main parts, which are highlighted in the image below: 
* Menu 
* Toolbar 
* Cells 

<figure>
 <a href="{{ site.url }}/images/courses/earth-analytics/bootcamp/jupyter-interface/notebook-components.png">
 <img src="{{ site.url }}/images/courses/earth-analytics/bootcamp/jupyter-interface/notebook-components.png" alt="The components of a Jupyter Notebook file include the Menu, the Toolbar, and Cells just like the ones shown here."></a>
 <figcaption> The components of a Jupyter Notebook file include the Menu, the Toolbar, and Cells just like the ones shown here.
 </figcaption>
</figure>

You will review the menu and toolbar throughout this exercise. It is also important to understand how `Jupyter Notebook` files use cells to store and execute your code and text. 

A `Jupyter Notebook` consists of a set of cells, which can be specified to store text such as `Markdown` or Code such as `Python`. 

You can check the cell type of any cell by clicking in the cell and looking at the Cell Type in Toolbar. 

<figure>
 <a href="{{ site.url }}/images/courses/earth-analytics/bootcamp/jupyter-interface/cell-type.png">
 <img src="{{ site.url }}/images/courses/earth-analytics/bootcamp/jupyter-interface/cell-type.png" alt="You can check the cell type of any cell in Jupyter Notebook using the Toolbar. The default cell type is Code."></a>
 <figcaption> You can check the cell type of any cell in Jupyter Notebook using the Toolbar. The default cell type is Code.
 </figcaption>
</figure>


## Work With Code and Markdown Cells

### Run Existing Cells

You can run any cell in `Jupyter Notebook` (regardless of whether it contains Code or `Markdown`) using the Menu tools (Click on Cell -> Run Cell) or Keyboard Shortcuts (Ctrl, then Enter).  

Function  | Keyboard Shortcut | Menu Tools
--- | --- | ---
Run Cell  | Ctrl + enter| Cell → Run Cell 

For example, you can run the `Python` code in the cell below using the Menu tools (Click on Cell -> Run Cell) or Keyboard Shortcuts (Ctrl, then Enter).  Your result, or output, will be displayed below the Code cell that you run.

{:.input}
```python
3 + 4
```

{:.output}
{:.execute_result}



    7





You can run `Markdown` cells in the same way as the Code cells using the Menu tools or Keyboard Shortcuts.

The difference between running a Code cell and a `Markdown` cell is that running a `Markdown` cell will not display results under the `Markdown` cell.

Rather, when you run `Markdown` cell, you will see that the `Markdown` syntax has been converted to nice formatting. 

For example, the `Markdown` below is rendered from syntax for creating headings and titles using `Markdown` syntax: `## Text Follows the Hashmarks`. 

You can double-click in any `Markdown` cell to see the `Markdown` syntax. To return to the formatted `Markdown` (i.e. rendered text), simply run the cell again. 

### This is a subtitle in Markdown

#### This is a smaller subtitle

##### This is an even smaller subtitle


### Create New Cells

You can also use the Menu tools and Keyboard Shortcuts to create new cells. 

Function  | Keyboard Shortcut | Menu Tools
--- | --- | ---
Create new cell| Esc + a (above), Esc + b (below) | Insert→ Insert Cell Above OR Insert → Insert Cell Below 
Copy Cell | c  | Copy Key
Paste Cell | v | Paste Key

The default cell type is Code. You can change the cell type of any existing cell by clicking in the cell and selecting a new cell type (e.g. `Markdown`) in the cell type menu in the toolbar. 

<figure>
 <a href="{{ site.url }}/images/courses/earth-analytics/bootcamp/jupyter-interface/change-cell-type.png">
 <img src="{{ site.url }}/images/courses/earth-analytics/bootcamp/jupyter-interface/change-cell-type.png" alt=" You can change the cell type of any cell in Jupyter Notebook using the Toolbar. The default cell type is Code."></a>
 <figcaption> You can change the cell type of any cell in Jupyter Notebook using the Toolbar. The default cell type is Code.
 </figcaption>
</figure>

### Move Cells Within Jupyter Notebook

You can change the order of cells within `Jupyter Notebook` using the `up arrow` and `down arrow` buttons on the menu bar. Simply click inside the cell that you want to move and then press the desired arrow as many times as you need to move the Cell to the desired location.

<figure>
  <a href="{{ site.url }}/images/courses/earth-analytics/bootcamp/jupyter-interface/move-cells.png">
  <img src="{{ site.url }}/images/courses/earth-analytics/bootcamp/jupyter-interface/move-cells.png" alt="You can use the menu bar in Jupyter Notebook to move cells within the Jupyter Notebook file."></a>
  <figcaption> You can use the menu bar in Jupyter Notebook to move cells within the Jupyter Notebook file.
  </figcaption>
 </figure>
 
### Run All Cells in Jupyter Notebook

In addition to running individual cells within a `Jupyter Notebook`, you can also run all of the cells in consecutive order using the Menu. 

Function  |  Menu Tools
--- | --- 
Run all cells  | Cell → Run all


### Clear Results in Jupyter Notebook

Sometimes, you may want to clear any output results that have been produced. 

You can do this using the Menu by clicking Cell -> Current Outputs -> Clear. This will clear the current cell that you are working in, which you can activate by clicking in a cell. 

You can also clear all of the output in a file by clicking Cell -> All Output -> Clear.


## Save Jupyter Notebook Files 

You can save `Jupyter Notebook` files (.ipynb) using the Menu or Keyboard Shortcuts. 

Function  | Keyboard Shortcut | Menu Tools
--- | --- | ---
Save notebook  | Esc + s | File → Save and Checkpoint


## Download Jupyter Notebook Files 

When using the Jupyter Cloud environment, you can download `Jupyter Notebook` files (.ipynb) to our computers using the Menu by clicking File -> Download as -> Notebook (.ipynb). 


## Close Your Jupyter Notebook Session

### Close and Shutdown Jupyter Notebook Files
After saving your Jupyter Notebook files (.ipynb), you can close the browser tab displaying the notebook, but you still need `Shutdown` the notebook from the dashboard. 

To `Shutdown` a Jupyter Notebook file (.ipynb), click in the checkbox to left of the filename. You will see an orange button named `Shutdown` appear in the top left of the dashboard menu; click on it to `Shutdown` any file that is checked in the list.

<figure>
 <a href="{{ site.url }}/images/courses/earth-analytics/bootcamp/jupyter-interface/shutdown-notebook.png">
 <img src="{{ site.url }}/images/courses/earth-analytics/bootcamp/jupyter-interface/shutdown-notebook.png" alt="You can shutdown Jupyter Notebook files uinsg the Jupyter Notebook Dashboard."></a>
 <figcaption> You can shutdown Jupyter Notebook files uinsg the Jupyter Notebook Dashboard.
 </figcaption>
</figure>


### Shutdown the Jupyter Notebook Local Server
After all of your notebooks are closed and shut down, you can close the browser tab displaying the Jupyter Notebook dashboard.

You will notice that the `Terminal` is still running commands for your `Jupyter Notebook` session. 

You can shutdown the session by clicking in the `Terminal` window and clicking `Ctrl` + `C`. 

Last, you will be asked to confirm that you want to `Shutdown this notebook server (y/[n])?`. Type `y` and hit `Enter` to confirm.

Then, you can close the `Terminal` by typing the command `exit`.

<figure>
 <a href="{{ site.url }}/images/courses/earth-analytics/bootcamp/jupyter-interface/terminal-close-jupyter.png">
 <img src="{{ site.url }}/images/courses/earth-analytics/bootcamp/jupyter-interface/terminal-close-jupyter.png" alt="You can close the Jupyter Notebook Session from the Terminal."></a>
 <figcaption> You can close the Jupyter Notebook Session from the Terminal.
 </figcaption>
</figure>


<div class="notice--warning" markdown="1">

## <i class="fa fa-pencil-square-o" aria-hidden="true"></i> Optional Challenge 1

Test your `Jupyter Notebook` skills to:

1. Add a Code cell and run the following `Python` code to determine which day had the most precipitation (i.e. the day of the greatest flooding) during the Fall 2013 flood in Boulder, CO, U.S.A. 

```python
# import required python packages
import pandas as pd
import matplotlib.pyplot as plt
from matplotlib.dates import DateFormatter
import matplotlib.dates as mdates

# create variable with data
boulder_precip = pd.DataFrame(columns=["date", "precip"], 
                              data=[
                                  ["2013-09-09", 0.1], ["2013-09-10", 1.0], 
                                  ["2013-09-11", 2.3], ["2013-09-12", 9.8], ["2013-09-13", 1.9],
                                  ["2013-09-14", 0.01], ["2013-09-15", 1.4], ["2013-09-16", 0.4]])      

# convert text strings in date to datetime type
boulder_precip.date = pd.to_datetime(boulder_precip.date)
     
# format date to just contain month and date 
myFmt = DateFormatter("%m/%d") 

# create plot with title and custom date labels for axes
plt.rcParams['figure.figsize'] = (12, 12)
fig, ax = plt.subplots()
ax.bar(boulder_precip['date'].values, boulder_precip['precip'].values,
       edgecolor='blue')
plt.setp(ax.get_xticklabels(), rotation=45);
ax.set(xlabel="Date", ylabel="Precipitation (Inches)",)
ax.set(title="Daily Precipitation (inches)\nBoulder, Colorado 2013")
ax.xaxis.set_major_formatter(myFmt)   
ax.xaxis.set_minor_locator(mdates.DayLocator())
```

**You have now experienced the benefits of using `Jupyter Notebook` for open reproducible science!**  

Without writing your own code, you were able to easily replicate this analysis because this code block can be shared with and run by anyone using `Python`. By the end of this course, you will be able to write your own code to conduct analysis and produce plots like these. 

</div>


{:.output}
{:.display_data}

![png]({{ site.url }}//images/courses/earth-analytics-bootcamp/01-get-started-open-science/exercises/2018-07-17-get-started-04-jupyter-notebook-interface_10_0.png)




<div class="notice--warning" markdown="1">

## <i class="fa fa-pencil-square-o" aria-hidden="true"></i> Optional Challenge 2 

Test your `Jupyter Notebook` skills to:

1. Launch `Jupyter Notebook` from the `ea-bootcamp-day-1` directory.

2. Open the existing `Jupyter Notebook` file called `jupyter-notebook-interface.ipynb`.

3. Double-click in a `Markdown` to see the syntax.

4. Run the cell to see `Markdown` return to the nice formatting. 

5. Add a `Markdown` cell as the second cell of the notebook. Include:
    * a `Markdown` subtitle (`##`) with the name of the notebook (e.g. `Earth Analytics Bootcamp - Day 1 Lesson on Jupyter Notebook`)
    * a smaller `Markdown` subtitle (`###`) with your name (e.g. `Jenny Palomino`).
    
6. Add four Code cells to the bottom of the notebook and run the following `Python` code for calculations:
    * `16 - 4`
    * `24 / 4`
    * `2 * 4`
    * `2 ** 4`

What do you notice about the output of `24 / 4` compared to the others? What operation does `**` execute?

</div>


{:.output}
{:.execute_result}



    12






{:.output}
{:.execute_result}



    6.0






{:.output}
{:.execute_result}



    8






{:.output}
{:.execute_result}



    16





<div class="notice--info" markdown="1">

## <i class="fa fa-pencil-square-o" aria-hidden="true"></i> Additional Resources

<a href="http://jupyter-notebook.readthedocs.io/en/stable/examples/Notebook/Working%20With%20Markdown%20Cells.html" target="_blank">More information on Markdown.</a>

</div>
