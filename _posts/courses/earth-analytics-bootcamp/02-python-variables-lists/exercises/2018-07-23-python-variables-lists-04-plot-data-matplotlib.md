---
layout: single
title: 'Plot Data in Python with Matplotlib'
excerpt: "Matplotlib is one of the most commonly used packages for plotting in Python. This lesson covers how to create a plot and customize plot colors and label axes using matplotlib."
authors: ['Jenny Palomino', 'Chris Holdgraf', 'Leah Wasser', 'Martha Morrissey']
category: [courses]
class-lesson: ['python-variables-lists']
permalink: /courses/earth-analytics-bootcamp/python-variables-lists/plot-data-matplotlib/
nav-title: "Plot Data in Python with Matplotlib"
dateCreated: 2018-06-27
modified: 2018-09-10
module-type: 'class'
course: "earth-analytics-bootcamp"
week: 2
sidebar:
  nav:
author_profile: false
comments: true
order: 4
topics:
  reproducible-science-and-programming: ['python']
---
{% include toc title="In This Lesson" icon="file-text" %}

In this lesson, you will write `Python` code to plot data from lists using the `matplotlib` package.

<div class='notice--success' markdown="1">

# <i class="fa fa-graduation-cap" aria-hidden="true"></i> Learning Objectives

After completing this lesson, you will be able to:

* Write `Python` code to plot data from lists using the `matplotlib` package
* Write `Python` code to customize your plots (e.g. titles, axes labels, colors)   
 
# <i class="fa fa-check-square-o fa-2" aria-hidden="true"></i> What You Need

Be sure that you have completed the previous lesson on <a href="{{ site.url }}/courses/earth-analytics-bootcamp/python-variables-lists/lists/">Lists</a> and <a href="{{ site.url }}/courses/earth-analytics-bootcamp/python-variables-lists/import-python-packages/">Import Python Packages</a>.

The code below is available in the **ea-bootcamp-day-2** repository that you cloned to `earth-analytics-bootcamp` under your home directory. 

 </div>

## Types of Plots

Plots are very useful for displaying information that has a temporal occurrence such as the monthly precipitation data from the previous lessons. There are many different kinds of plots including line and bar graphs as well as scatter plots (i.e. plots of points representing observations in the data). 

To create a plot, you need to provide data for the x-axis (i.e. horizontal axis) and the y-axis (i.e. vertical axis) of the plot. The data can be contained in various formats including lists and other data structures that you will work with in this course such as `numpy arrays` and `pandas dataframes`. 

In this lesson, you will use your previously created lists for average monthly precipitation in Boulder, CO to create and customize a plot. You will use `months` along the x-axis and `precip` along the y-axis. 

<a href="https://www.esrl.noaa.gov/psd/boulder/Boulder.mm.precip.html" target="_blank">Average Monthly Precipitation for Boulder, Colorado provided by the U.S. National Oceanic and Atmospheric Administration (NOAA)</a>

Month  | Precipitation (inches) 
--- | --- 
Jan | 0.70
Feb | 0.75
Mar | 1.85
Apr | 2.93
May | 3.05
June | 2.02
July | 1.93
Aug | 1.62
Sept | 1.84
Oct | 1.31
Nov | 1.39
Dec | 0.84


## Begin Writing Your Code

Now that you know how to import `Python` packages, you can begin your code by importing the `matplotlib` package, and specifically, the `pyplot` module. 

Recall that in the `Python` community (that you are now a part of!), the `matplotlib.pyplot` is often assigned an alias of `plt`.

{:.input}
```python
# import necessary Python packages
import matplotlib.pyplot as plt

# print a message after the package has been imported successfully
print("import of packages successful")
```

{:.output}
    import of packages successful



## Create Lists

Review your `Python` skills to create lists of the converted values for average monthly precipitation (mm) and of the month names.  

{:.input}
```python
# create variables for each month of average precipitation for Boulder, CO
jan = 0.70 * 25.4
feb = 0.75 * 25.4
mar = 1.85 * 25.4
apr = 2.93 * 25.4
may = 3.05 * 25.4
june = 2.02 * 25.4
july = 1.93 * 25.4
aug = 1.62 * 25.4
sept = 1.84 * 25.4
oct = 1.31 * 25.4
nov = 1.39 * 25.4
dec = 0.84 * 25.4

# create a list of the converted monthly variables for the y-axis of your plot
precip = [jan, feb, mar, apr, may, june, july, aug, sept, oct, nov, dec] 

# create a list of the month names for the x-axis of your plot
months = ["Jan", "Feb", "Mar", "Apr", "May", "June", "July", "Aug", "Sept", "Oct", "Nov", "Dec"]
```

## Plot Data From Lists

Since you now have lists containing the converted values for average monthly precipitation and the month names, you can use these lists to create a plot using `matplotlib`. 

`Matplotlib` is a plotting package that makes it simple to create plots from various data structures in `Python`, including lists. 

`Matplotlib` uses default settings, which help to create publication quality plots with a minimal amount of settings and tweaking. Matplotlib graphics are built step by step by adding new elements.

To build a `matplotlib` plot, you need to:

1. Create the empty plot on which data will be plotted
2. Define the plot elements including the x- and y- axes (variables)
3. Customize your plot to change default styles and to add titles and labels to the axes.

Begin by creating a plot using the default styles provided by `matplotlib.pyplot`. 

{:.input}
```python
# set plot size for the plot
plt.rcParams["figure.figsize"] = (8, 8)

# create the plot space upon which to plot the data
fig, ax = plt.subplots()

# add the x-axis and the y-axis to the plot
ax.plot(months, precip);
```

{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}//images/courses/earth-analytics-bootcamp/02-python-variables-lists/exercises/2018-07-23-python-variables-lists-04-plot-data-matplotlib_6_0.png" alt = "This plot displays the default settings of the matplotlib package for Python, which renders a blue line plot of the input data.">
<figcaption>This plot displays the default settings of the matplotlib package for Python, which renders a blue line plot of the input data.</figcaption>

</figure>




## Customize Your Plot

### Add Title and Axis Labels

Expand your code to add a title to the plot and to label the axes. 

{:.input}
```python
# set plot size for all plots that follow
plt.rcParams["figure.figsize"] = (8, 8)

# set plot title size for all plots that follow
plt.rcParams['axes.titlesize'] = 20

# create the plot space upon which to plot the data
fig, ax = plt.subplots()

# add the x-axis and the y-axis to the plot
ax.plot(months, precip)

# set plot title
ax.set(title="Average Monthly Precipitation in Boulder, CO")

# add labels to the axes
ax.set(xlabel="Month", ylabel="Precipitation (mm)");
```

{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}//images/courses/earth-analytics-bootcamp/02-python-variables-lists/exercises/2018-07-23-python-variables-lists-04-plot-data-matplotlib_8_0.png" alt = "This plot expands on the default settings of the matplotlib package for Python to add a title and labels for the plot axes.">
<figcaption>This plot expands on the default settings of the matplotlib package for Python to add a title and labels for the plot axes.</figcaption>

</figure>




## Change Plot Type

You can turn your plot into a bar plot using `ax.bar()`, providing the x- and y-axes as you did with `ax.plot()`.

You can also assign a fill color using `color="green"`. 

{:.input}
```python
# set plot size for all plots that follow
plt.rcParams["figure.figsize"] = (8, 8)

# create the plot space upon which to plot the data
fig, ax = plt.subplots()

# add the x-axis and the y-axis to the plot
ax.bar(months, precip, color="green")

# set plot title
ax.set(title="Average Monthly Precipitation in Boulder, CO")

# add labels to the axes
ax.set(xlabel="Month", ylabel="Precipitation (mm)");
```

{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}//images/courses/earth-analytics-bootcamp/02-python-variables-lists/exercises/2018-07-23-python-variables-lists-04-plot-data-matplotlib_10_0.png" alt = "This plot modifies the default settings of the matplotlib package for Python to create a green bar plot, instead of the default blue line plot.">
<figcaption>This plot modifies the default settings of the matplotlib package for Python to create a green bar plot, instead of the default blue line plot.</figcaption>

</figure>




**Congratulations - you have created your first customized plots of data!** 

<div class="notice--warning" markdown="1">

## <i class="fa fa-pencil-square-o" aria-hidden="true"></i> Optional Challenge 

Test your `Python` skills to further customize your plot:

1. Recreate the x-axis to use full month name (e.g. `January`, not `Jan`) (hint: create a new `months` list). 

2. Rotate the x-axis markers using `plt.setp(ax.get_xticklabels(), rotation=45)`, so that the spacing along the x-axis is more appealing now that the months are longer. 

3. Change your plot to a scatter plot using `ax.scatter()` (hint: see `ax.bar(months, precip)`).

</div>



{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}//images/courses/earth-analytics-bootcamp/02-python-variables-lists/exercises/2018-07-23-python-variables-lists-04-plot-data-matplotlib_12_0.png" alt = "This plot modifies the default settings of the matplotlib package for Python to create a blue scatter plot, instead of the default blue line plot.">
<figcaption>This plot modifies the default settings of the matplotlib package for Python to create a blue scatter plot, instead of the default blue line plot.</figcaption>

</figure>




<div class="notice--info" markdown="1">

## <i class="fa fa-pencil-square-o" aria-hidden="true"></i> Additional Resources

* <a href="https://matplotlib.org/examples/pylab_examples/subplots_demo.html" target="_blank">More Matplotlib Examples</a>

* <a href="https://realpython.com/blog/python/python-matplotlib-guide/?utm_campaign=Data%2BElixir&utm_medium=email&utm_source=Data_Elixir_172" target="_blank">In-depth Guide to Matplotlib</a>

* <a href="http://joseph-long.com/writing/colorbars/" target="_blank">More Information on Color Bars</a>

</div>
