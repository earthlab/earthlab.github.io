---
layout: single
title: 'Useful Jupyter Notebook Shortcuts'
excerpt: "The Jupyter ecosystem contains many useful tools for working with Python including Jupyter Notebook, an interactive coding environment. Learn useful shortcuts in Jupyter Notebook that can help you complete your tasks quickly and efficiently."
authors: ['Jenny Palomino', 'Leah Wasser']
category: [courses]
class-lesson: ['jupyter-notebook']
permalink: /courses/intro-to-earth-data-science/open-reproducible-science/jupyter-python/jupyter-notebook-shortcuts/
nav-title: "Jupyter Notebook Shortcuts"
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
order: 6
topics:
  reproducible-science-and-programming: ['jupyter-notebook']
---

{% include toc title="On This Page" icon="file-text" %}

<div class='notice--success' markdown="1">

## <i class="fa fa-graduation-cap" aria-hidden="true"></i> Learning Objectives

* List useful keyboard shortcuts in `Jupyter Notebook`.
* Be able to access the list list of keyborad shortcuts in `Jupyter Notebook`. 

</div>


## List of Useful Jupyter Notebook Shortcuts

### Menu Tools vs. Keyboard Shortcuts

As you have seen in this chapter, you can manipulate your `Jupyter Notebook` using the drop-down tools from the menu, with keyboard shortcuts, or using both. 

The table below lists common tasks in `Jupyter Notebook` and how to do them using keyboard shortcuts or the menu tool. 


Function  | Keyboard Shortcut | Menu Tools
--- | --- | ---
Save notebook  | Esc + s | File → Save and Checkpoint
Create new cell| Esc + a (above), Esc + b (below) | Insert→ cell above Insert → cell below 
Run Cell  | Ctrl + enter| Cell → Run Cell 
Copy Cell | c  | Copy Key
Paste Cell | v | Paste Key
Interrupt Kernel| Esc + i i | Kernel → Interrupt 
Restart Kernel | Esc + 0 0 | Kernel → Restart
Find and replace on your code but not the outputs | Esc + f | N/A
merge multiple cells| Shift + M| N/A
When placed before a function Information about a function from its documentation| ? | N/A

For a full list of keyboard shortcuts, click the help button, then the keyboard shortcuts button.  

<figure>
 <a href="{{ site.url }}/images/courses/earth-analytics/python-interface/help-jupyter.png">
 <img src="{{ site.url }}/images/courses/earth-analytics/python-interface/help-jupyter.png" alt= "Help menu of Jupyter Notebook."></a>
 <figcaption> Help menu of Jupyter Notebook. 
 </figcaption>
</figure>


<div class="notice--info" markdown="1">

## Additional Resources

* <a href="https://unidata.github.io/online-python-training/introduction.html" target="_blank">Why Jupyter Notebook and Python</a>

* <a href="https://jupyter-notebook.readthedocs.io/en/stable/examples/Notebook/Notebook%20Basics.html" target="_blank">Jupyter Notebook Basics</a>

* <a href="https://www.dataquest.io/blog/jupyter-notebook-tips-tricks-shortcuts/" target = "_blank">Dataquest tips and tricks for Jupyter Notebook</a>. 

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

