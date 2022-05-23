---
layout: single
title: "Introduction to Plotting in Python Using Matplotlib"
excerpt: 'Matplotlib is the most commonly used plotting library in Python. Learn how to create plots using the matplotlib object oriented approach.'
authors: ['Jenny Palomino', 'Leah Wasser']
dateCreated: 2019-09-11
modified: 2020-09-02
module-title: 'Introduction to Plotting with Matplotlib'
module-nav-title: 'Intro to Plotting with Matplotlib'
module-description: 'Matplotlib is the most commonly used plotting library in Python. Learn how to get started with creating and customizing plots using matplotlib.'
category: [courses]
class-lesson: ['intro-to-plotting-matplotlib']
course: 'scientists-guide-to-plotting-data-in-python-textbook'
nav-title: 'Intro to Matplotlib Plotting'
permalink: /courses/scientists-guide-to-plotting-data-in-python/plot-with-matplotlib/introduction-to-matplotlib-plots/
module-type: 'class'
class-order: 1
chapter: 1
week: 1
sidebar:
  nav:
author_profile: false
comments: true
order: 1
topics:
  reproducible-science-and-programming: ['python']
  data-exploration-and-analysis: ['data-visualization']
---
{% include toc title="In This Chapter" icon="file-text" %}

<div class='notice--success' markdown="1">

## <i class="fa fa-ship" aria-hidden="true"></i> Chapter One - Introduction to Plotting with Matplotlib

In this chapter, you will learn how to create and customize plots in **Python** using **matplotlib**, including how to create different types of plots and customize plot colors and labels. 

## <i class="fa fa-graduation-cap" aria-hidden="true"></i> Learning Objectives

After completing this chapter, you will be able to:

* Explain the **matplotlib** object-oriented approach to plotting. 
* Use **matplotlib** to create scatter, line and bar plots.
* Customize the labels, colors and look of your **matplotlib** plot.
* Create figures with multiple plots.
* Save figure as an image file (e.g. .png format).


## <i class="fa fa-check-square-o fa-2" aria-hidden="true"></i> What You Need

Be sure that you have followed the instructions on <a href="{{ site.url }}/workshops/setup-earth-analytics-python/">Setting up Git, Bash, and Conda on your computer</a> to install the tools for your operating system (Windows, Mac, Linux). 

Be sure that you have completed the chapter on <a href="{{ site.url }}/courses/intro-to-earth-data-science/open-reproducible-science/jupyter-python/">Jupyter Notebook</a>.

</div>


## Overview of Plotting with Matplotlib

<a href="https://matplotlib.org/" target="_blank">**Matplotlib**</a> is a **Python** plotting package that makes it simple to create two-dimensional plots from data stored in a variety of data structures including lists, **numpy** arrays, and **pandas** dataframes. 

**Matplotlib** uses an object oriented approach to plotting. This means that plots can be built step-by-step by adding new elements to the plot. 

There are two primary objects associated with a **matplotlib** plot:
* `figure` object: the overall figure space that can contain one or more plots.
* `axis` objects: the individual plots that are rendered within the figure.

You can think of the figure object as your plot canvas. You can think about the axis object as an individual plot. 

A figure can hold one or more axis objects. This structure allows you to create figures with one or more plots on them.

<figure>
 <a href="{{ site.url }}/images/earth-analytics/plot-data/fig-1-plot.png">
 <img src="{{ site.url }}/images/earth-analytics/plot-data/fig-1-plot.png" alt="A figure created using matplotlib can contain one or many plots, or axis objects. Source: Earth Lab, Alana Faller"></a>
 <figcaption> A figure created using matplotlib can contain one or many plots, or axis objects. Source: Earth Lab, Alana Faller
 </figcaption>
</figure>


While **Matplotlib** contains many modules that provide different plotting functionality, the most commonly used module is <a href="https://matplotlib.org/api/index.html#the-pyplot-api" target="_blank">**pyplot**</a>. 

**Pyplot** provides methods that can be used to add different components to `figure` objects, including creating the individual plots as `axis` objects, also known as subplots.

The **pyplot** module is typically imported using the alias `plt` as demonstrated below.

{:.input}
```python
# Import pyplot
import matplotlib.pyplot as plt
```

## Create Plots Using Matplotlib

To create a plot using matplotlib's object oriented approach, you first create the figure (which you can call `fig`) and at least one axis (which you can call `ax`) using the `subplots()` function from the `pyplot` module:

`fig, ax = plt.subplots()`

Notice that the `fig` and `ax` are created at the same time by setting them equal to the output of the `pyplot.subplots()` function. As no other arguments have been provided, the result is a figure with one plot that is empty but ready for data. 

<i class="fa fa-star"></i> **Data Tip:** In the example above, `fig` and `ax` are variable names for the figure and axis objects. You can call these items whatever you want. For example, you might see `f`, `ax` or `fig`, `axis1` used. 
{: .notice--success }


{:.input}
```python
# Create figure and one plot (axis object) 
fig, ax = plt.subplots()
```

{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}/images/courses/plot-data-in-python-textbook/01-plot-with-matplotlib/intro-to-plotting-matplotlib/2019-09-11-plot-with-matplotlib-01-intro-plotting-matplotlib/2019-09-11-plot-with-matplotlib-01-intro-plotting-matplotlib_4_0.png" alt = "When you create a figure object, you are creating a blank canvas upon which to place a plot.">
<figcaption>When you create a figure object, you are creating a blank canvas upon which to place a plot.</figcaption>

</figure>




## Change Figure Size 

You can change the size of your figure using the argument `figsize` to specify a width and height for your figure: 

`figsize = (width, height)`

{:.input}
```python
# Resize figure
fig, ax = plt.subplots(figsize = (10, 6))
```

{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}/images/courses/plot-data-in-python-textbook/01-plot-with-matplotlib/intro-to-plotting-matplotlib/2019-09-11-plot-with-matplotlib-01-intro-plotting-matplotlib/2019-09-11-plot-with-matplotlib-01-intro-plotting-matplotlib_6_0.png" alt = "When you create a figure object, you can define the figure size by providing a width and height value (width, height).">
<figcaption>When you create a figure object, you can define the figure size by providing a width and height value (width, height).</figcaption>

</figure>




## Multi-plot Figures

Using matplotlib's object-oriented approach makes it easier to include more than one plot in a figure by creating additional `axis` objects. 

<figure>
 <a href="{{ site.url }}/images/earth-analytics/plot-data/fig-2-plots.png">
 <img src="{{ site.url }}/images/earth-analytics/plot-data/fig-2-plots.png" alt="A figure created using matplotlib can contain many plots, or axis objects. Source: Earth Lab, Alana Faller"></a>
 <figcaption> A figure created using matplotlib can contain many plots, or axis objects. Source: Earth Lab, Alana Faller
 </figcaption>
</figure>

<figure>
 <a href="{{ site.url }}/images/earth-analytics/plot-data/fig-4-plots.png">
 <img src="{{ site.url }}/images/earth-analytics/plot-data/fig-4-plots.png" alt="When creating a figure with multiple axis objects, you can arrange the plots across multiple rows and columns. Source: Earth Lab, Alana Faller"></a>
 <figcaption> When creating a figure with multiple axis objects, you can arrange the plots across multiple rows and columns. Source: Earth Lab, Alana Faller
 </figcaption>
</figure>


When adding more than one `axis` object, it is good practice to give them distinct names (such as `ax1` and `ax2`), so you can easily work with each `axis` individually.

You will need to provide new arguments to `plt.subplots` for the layout of the figure: number of rows and columns:

`plt.subplots(1, 2)`

In this example, `1, 2` indicates that you want the plot layout to be 1 row across 2 columns.

{:.input}
```python
# Figure with two plots
fig, (ax1, ax2) = plt.subplots(1, 2, figsize = (10, 6))
```

{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}/images/courses/plot-data-in-python-textbook/01-plot-with-matplotlib/intro-to-plotting-matplotlib/2019-09-11-plot-with-matplotlib-01-intro-plotting-matplotlib/2019-09-11-plot-with-matplotlib-01-intro-plotting-matplotlib_8_0.png" alt = "You can create figures with multiple plots by adding additional axis objects (e.g. ax1, ax2).">
<figcaption>You can create figures with multiple plots by adding additional axis objects (e.g. ax1, ax2).</figcaption>

</figure>




Conversely, `2, 1` indicates that you want the plot layout to be 2 rows across one column.

{:.input}
```python
# Figure with two plots
fig, (ax1, ax2) = plt.subplots(2, 1, figsize = (10, 6))
```

{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}/images/courses/plot-data-in-python-textbook/01-plot-with-matplotlib/intro-to-plotting-matplotlib/2019-09-11-plot-with-matplotlib-01-intro-plotting-matplotlib/2019-09-11-plot-with-matplotlib-01-intro-plotting-matplotlib_10_0.png" alt = "You can change the layout of the figure to specify how many rows and columns you want to use to display the plots.">
<figcaption>You can change the layout of the figure to specify how many rows and columns you want to use to display the plots.</figcaption>

</figure>




Because you have defined `figsize=(10, 6)`, the figure space remains the same size regardless of how many rows or columns you request. 

You can play around with both the number of rows and columns as well as `figsize` to arrive at the look that you want. 

{:.input}
```python
# Figure with two plots
fig, (ax1, ax2) = plt.subplots(2, 1, figsize = (12, 12))
```

{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}/images/courses/plot-data-in-python-textbook/01-plot-with-matplotlib/intro-to-plotting-matplotlib/2019-09-11-plot-with-matplotlib-01-intro-plotting-matplotlib/2019-09-11-plot-with-matplotlib-01-intro-plotting-matplotlib_12_0.png" alt = "You can adjust the figshare as well as the number of rows and columns for a figure layout, in order to achieve the desired layout of the plots.">
<figcaption>You can adjust the figshare as well as the number of rows and columns for a figure layout, in order to achieve the desired layout of the plots.</figcaption>

</figure>




You can continue to add as many as `axis` objects as you need to create the overall layout of the desired figure and continue adjusting the `figsize` as needed.  

{:.input}
```python
# Figure with three plots
fig, (ax1, ax2, ax3) = plt.subplots(3, 1, figsize = (15, 15))
```

{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}/images/courses/plot-data-in-python-textbook/01-plot-with-matplotlib/intro-to-plotting-matplotlib/2019-09-11-plot-with-matplotlib-01-intro-plotting-matplotlib/2019-09-11-plot-with-matplotlib-01-intro-plotting-matplotlib_14_0.png" alt = "You can continue to add multiple plots to your figure by adding additional axis objects (e.g. ax1, ax2, ax3).">
<figcaption>You can continue to add multiple plots to your figure by adding additional axis objects (e.g. ax1, ax2, ax3).</figcaption>

</figure>




A key benefit of the **matplotlib** object oriented approach is that each `axis` is its own object and can be customized independently of the other plots in the figure. 

You will learn how to take advantage of this capability to customize individual plots on the next page of this chapter. 
