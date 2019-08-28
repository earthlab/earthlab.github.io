---
layout: single
title: 'Manage Jupyter Notebook Files'
excerpt: "The Jupyter ecosystem contains many useful tools for working with Python including Jupyter Notebook, an interactive coding environment, and the Jupyter dashboard, which allows you to manage files and directories in your Jupyter environment. Learn how to manage Jupyter Notebook files including saving, renaming, deleting, moving, and downloading notebooks."
authors: ['Jenny Palomino', 'Leah Wasser']
category: [courses]
class-lesson: ['jupyter-notebook']
permalink: /courses/intro-to-earth-analytics/open-science-bash-jupyter-markdown-git/jupyter-python/manage-jupyter-notebook-files/
nav-title: "Manage Jupyter Notebook Files"
dateCreated: 2019-07-15
modified: 2019-08-28
module-type: 'class'
class-order: 3
course: "intro-to-earth-analytics"
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
* Move `Jupyter Notebook` files using the `Jupyter` dashboard.
* Convert `Jupyter Notebook` files into user-friendly formats such as `.html`. 


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

Sometimes you may want to share your notebook with others in a format that does not require `Jupyter Notebook` such as an HTML version of your notebook. This format can be very useful as it displays your Markdown, code and rendered results, just like in your notebook file. However, this format can be opened by anyone that has an internet browser.   

Note that the HTML file does not actually require the internet to render. It require an internet browser such as Chrome or Firefox to render the file. 

To download your `Jupyter Notebook` file (.ipynb) to an HTML file, you can use the Menu:

Menu Tools | 
--- |  
File → Download as -> HTML (.html) |


## Download Jupyter Notebook Files From Jupyter Hub

In addition, there may be future occasions in which you will use the cloud-based `Jupyter Hub` environment to complete your work, and thus, you may want to download those notebooks locally to your computer. If so, you can download any `Jupyter Notebook` file (.ipynb) to your local computer using the Menu: 

Menu Tools | 
--- |  
File → Download as -> Notebook (.ipynb) |

<div class="notice--info" markdown="1">

## Additional Resources

* <a href="https://unidata.github.io/online-python-training/introduction.html" target="_blank">Why Jupyter Notebook and Python</a>

* <a href="https://jupyter-notebook.readthedocs.io/en/stable/examples/Notebook/Notebook%20Basics.html" target="_blank">Jupyter Notebook Basics</a>

</div>

<div class="notice--warning" markdown="1">

## <i class="fa fa-pencil-square-o" aria-hidden="true"></i> Practice Your Jupyter Notebook Skills

Test your `Jupyter Notebook` skills to:

1. Launch `Jupyter Notebook` from your `earth-analytics` directory.

2. Create a new `Jupyter Notebook` file called `jupyter-notebook-interface.ipynb`.

3. Add a Code cell and copy/paste the following `Python` code to determine which day had the most precipitation (i.e. the day of the greatest flooding) during the Fall 2013 flood in Boulder, CO, U.S.A. 

```python
# Import necessary packages
import matplotlib.pyplot as plt
import pandas as pd

# Create data
boulder_precip = pd.DataFrame(columns=["date", "precip"], 
                              data=[
                                  ["2013-09-09", 0.1], ["2013-09-10", 1.0], 
                                  ["2013-09-11", 2.3], ["2013-09-12", 9.8], ["2013-09-13", 1.9],
                                  ["2013-09-14", 0.01], ["2013-09-15", 1.4], ["2013-09-16", 0.4]])      
# Create plot
fig, ax = plt.subplots()
ax.bar(boulder_precip['date'].values, boulder_precip['precip'].values)
ax.set(title="Daily Precipitation (inches)\nBoulder, Colorado 2013", 
       xlabel="Date", ylabel="Precipitation (Inches)")
plt.setp(ax.get_xticklabels(), rotation=45);
```
4. Run the `Python` cell. 

**You have now experienced the benefits of using `Jupyter Notebook` for open reproducible science!**  

Without writing your own code, you were able to easily replicate this analysis because this code block can be shared with and run by anyone using `Python` in `Jupyter Notebook`. 

5. Add a Code cell and run each of the following `Python` calculations:
    * `16 - 4`
    * `24 / 4`
    * `2 * 4`
    * `2 ** 4`
        * What do you notice about the output of `24 / 4` compared to the others? 
        * What operation does `**` execute?

6. Create a new directory called `chap-3` in your `earth-analytics` directory. 

7. Create a new directory called `test` in your `earth-analytics` directory and move it into in the newly created directory called `chap-3`.

8. Delete the `test` directory - do you recall how to find the `test` directory in its new location? 

9. Rename the `Jupyter Notebook` file that you created in step 2 (e.g. `jupyter-notebook-interface.ipynb`) using your first initial and last name (e.g. `jpalomino-jupyter-notebook-interface.ipynb`). 

10. Create a new folder called `chap-3` in your `earth-analytics` directory. 

11. Move your renamed `Jupyter Notebook` file (e.g. `jpalomino-jupyter-notebook-interface.ipynb`) into the new `chap-3` directory. 

</div>


