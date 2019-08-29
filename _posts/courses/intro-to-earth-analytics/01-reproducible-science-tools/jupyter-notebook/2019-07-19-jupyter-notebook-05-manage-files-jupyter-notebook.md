---
layout: single
title: 'Manage Jupyter Notebook Files'
excerpt: "The Jupyter ecosystem contains many useful tools for working with Python including Jupyter Notebook, an interactive coding environment, and the Jupyter Notebook dashboard, which allows you to manage files and directories in your Jupyter environment. Learn how to manage Jupyter Notebook files including saving, renaming, deleting, moving, and downloading notebooks."
authors: ['Jenny Palomino', 'Leah Wasser']
category: [courses]
class-lesson: ['jupyter-notebook']
permalink: /courses/intro-to-earth-data-science/open-reproducible-science/jupyter-python/manage-jupyter-notebook-files/
nav-title: "Manage Jupyter Notebooks"
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
order: 5
topics:
  reproducible-science-and-programming: ['jupyter-notebook']
---

{% include toc title="On This Page" icon="file-text" %}

<div class='notice--success' markdown="1">

## <i class="fa fa-graduation-cap" aria-hidden="true"></i> Learning Objectives

* Save, rename, and delete `Jupyter Notebook` files.
* Move `Jupyter Notebook` files using the `Jupyter Notebook` dashboard.
* Convert `Jupyter Notebook` files into user-friendly formats such as `.html`. 

</div>


## Save Jupyter Notebook Files 

After you make changes in your `Jupyter Notebook` files (.ipynb), you can save them using either the Menu or Keyboard Shortcuts. 

Function  | Keyboard Shortcut | Menu Tools
--- | --- | ---
Save notebook  | Esc + s | File → Save and Checkpoint


## Rename Jupyter Notebook Files

There are two ways to rename `Jupyter Notebook` files: 

1. from the `Jupyter Notebook` dashboard and 
2. from title textbox at the top of an open notebook. 

To change the name of the file from the `Jupyter Notebook` dashboard, begin by checking the box next to the filename and selecting `Rename`. A new window will open in which you can type the new name for the file (e.g. `jupyter-notebook-interface.ipynb`). Then, you can select `Rename` to apply the name change. 

<figure>
 <a href="{{ site.url }}/images/courses/earth-analytics/bootcamp/jupyter-interface/rename-existing-notebook.png">
 <img src="{{ site.url }}/images/courses/earth-analytics/bootcamp/jupyter-interface/rename-existing-notebook.png" alt="When you use the Jupyter Notebook dashboard menu to rename Jupyter Notebook files (.ipynb), a new window will open in which you can type the new name of the file."></a>
 <figcaption> When you use the Jupyter Notebook dashboard menu to rename Jupyter Notebook files (.ipynb), a new window will open in which you can type the new name of the file.
 </figcaption>
</figure>

You can also change the name of an open `Jupyter Notebook` file by clicking on the title textbox at the top of your notebook (e.g. `jupyter-notebook-interface`) next to the `Jupyter` logo. Then, you can simply type in a new name into the title textbox and select `Rename`. 


## Delete Jupyter Notebook Files

You can delete `Jupyter Notebook` files (.ipynb) from the dashboard by selecting the checkbox to left of the filename and then selecting the red trash can button that appears in the top left of the dashboard menu. 

If you have selected multiple `Jupyter Notebook` files (.ipynb), clicking on that red trashcan button will delete any file that is checked in the list. 

<figure>
 <a href="{{ site.url }}/images/courses/earth-analytics/bootcamp/jupyter-interface/delete-existing-notebook.png">
 <img src="{{ site.url }}/images/courses/earth-analytics/bootcamp/jupyter-interface/delete-existing-notebook.png" alt="To use the Jupyter Notebook dashboard menu to delete Jupyter Notebook files (.ipynb), you can check the box to left of the filename and select the red Trashcan button that appears."></a>
 <figcaption> To use the Jupyter Notebook dashboard menu to delete Jupyter Notebook files (.ipynb), you can check the box to left of the filename and select the red Trashcan button that appears.
 </figcaption>
</figure>


## Move Jupyter Notebook Files

You can move `Jupyter Notebook` files using the Dashboard. To move a file, first make sure that the notebook is not actively running. If the notebook is running, shut it down. To `Shutdown` a Jupyter Notebook file (.ipynb), click in the checkbox to left of the filename. You will see an orange button named `Shutdown` appear in the top left of the dashboard menu. You can click on it to `Shutdown` any file that is checked in the list.

<figure>
 <a href="{{ site.url }}/images/courses/earth-analytics/bootcamp/jupyter-interface/shutdown-notebook.png">
 <img src="{{ site.url }}/images/courses/earth-analytics/bootcamp/jupyter-interface/shutdown-notebook.png" alt="To use the Jupyter Notebook dashboard menu to shutdown Jupyter Notebook files (.ipynb), you can check the box to left of the filename and select the orange Shutdown button that appears."></a>
 <figcaption> To use the Jupyter Notebook dashboard menu to shutdown Jupyter Notebook files (.ipynb), you can check the box to left of the filename and select the orange Shutdown button that appears.
 </figcaption>
</figure>

After the notebook is shutdown, you can click in the checkbox to left of the filename and select `Move`. You will be asked to provide the path to directory to which to move the file. 

<figure>
 <a href="{{ site.url }}/images/courses/earth-analytics/bootcamp/jupyter-interface/move-notebook.png">
 <img src="{{ site.url }}/images/courses/earth-analytics/bootcamp/jupyter-interface/move-notebook.png" alt="To use the Jupyter Notebook dashboard menu to move Jupyter Notebook files (.ipynb), you can check the box to left of the filename and select the Move button that appears."></a>
 <figcaption> To use the Jupyter Notebook dashboard menu to move Jupyter Notebook files (.ipynb), you can check the box to left of the filename and select the Move button that appears.
 </figcaption>
</figure>


## Download Jupyter Notebook Files From Local Jupyter Dashboard

Sometimes you may want to share your notebook with others in a format that does not require `Jupyter Notebook` such as an HTML (`.html`) version of your notebook. This format can be very useful as it displays your Markdown, code and rendered results, just like in your notebook file. However, this format can be opened by anyone that has an internet browser.   

Note that the `.html` file does not actually require the internet to render. It require an internet browser such as Chrome or Firefox to render the file. 

To download your `Jupyter Notebook` file (.ipynb) to an `.html` file, you can use the Menu:

Menu Tools | 
--- |  
File → Download as -> HTML (.html) |


## Download Jupyter Notebook Files From Jupyter Hub

In addition, there may be future occasions in which you will use the cloud-based `Jupyter Hub` environment to complete your work, and thus, you may want to download those notebooks locally to your computer. If so, you can download any `Jupyter Notebook` file (.ipynb) to your local computer using the Menu: 

Menu Tools | 
--- |  
File → Download as -> Notebook (.ipynb) |
