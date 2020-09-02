---
layout: single
title: "Customize matplotlib plots in Python - earth analytics - data science for scientists"
excerpt: 'Matplotlib is the most commonly used plotting library in Python. This lesson covers how to get started with customizing plot colors and axes labels using matplotlib in Python.'
authors: ['Leah Wasser', 'Jenny Palomino']
dateCreated: 2019-09-11
modified: 2020-09-02
module-title: 'x'
module-nav-title: 'x'
module-description: 'x'
category: [courses]
class-lesson: ['intro-to-plotting-matplotlib']
course: 'plot-data-in-python'
nav-title: 'Intro to Matplotlib Plotting'
permalink: /courses/plot-data-in-python/plot-with-matplotlib/intro-plotting-matplotlib-not-published/
module-type: 'class'
week: 1
sidebar:
  nav:
author_profile: false
comments: true
order: 3
topics:
  reproducible-science-and-programming: ['python']
  data-exploration-and-analysis: ['data-visualization']
---

{% include toc title="In This Chapter" icon="file-text" %}

<div class='notice--success' markdown="1">

## <i class="fa fa-ship" aria-hidden="true"></i> Chapter One - Open Reproducible Science

In this chapter, you will learn about open reproducible science and become familiar with a suite of open source tools that are often used in open reproducible science (and earth data science) workflows including `Shell`, `git` and `GitHub`, `Python`, and `Jupyter`. 


## <i class="fa fa-graduation-cap" aria-hidden="true"></i> Learning Objectives

After completing this chapter, you will be able to:

* Use `matplotlib` to create custom scatter, line and bar plots.
* Add x and y axes labels and a title to your matplotlib plot.
* Customize the colors and look of your matplotlib plot.

## <i class="fa fa-check-square-o fa-2" aria-hidden="true"></i> What You Need

You need `Python 3.x` and `Jupyter notebooks` to complete this tutorial. Also you should have an `earth-analytics` directory setup on your computer with a `/data` directory with it.

{% include/data_subsets/course_earth_analytics/_data-colorado-flood.md %}

</div>


## Important - Data Organization

Before you begin this lesson series, be sure that you’ve downloaded the colorado flood data subset and unpacked it into your `earth-analytics/data/colorado-flood/` directory on your computer. The easiest way to get the data is to use earthpy's `get_data` method: `et.data.get_data("colorado-flood")`. However you can also download the data manually by clicking on the link below. 

# The image below is likely wrong 

also maybe they can just download a single file to make this simpler?
Your directory should look like the image below:

<figure>
<a href="{{ site.url }}/images/courses/earth-analytics/co-flood-lessons/week-02-data.jpg">
<img src="{{ site.url }}/images/courses/earth-analytics/co-flood-lessons/week-02-data.jpg" alt="week 2 file organization">
</a>
<figcaption>Your `week_02` file directory should look like the one above. Note that
the data directly under the week_02 folder.</figcaption>
</figure>

To begin, import the needed Python packages.

{:.input}
```python
# Import required python packages
import numpy as np
import matplotlib.pyplot as plt
from matplotlib.dates import DateFormatter
import os
import pandas as pd
import seaborn as sns
import urllib
import earthpy as et


# Plot styles
sns.set(font_scale=1.5)
sns.set_style("whitegrid")

# Get data
et.data.get_data("colorado-flood")

# Set working directory
os.chdir(os.path.join(et.io.HOME, 'earth-analytics', 'data'))

```

To begin, download the .csv file below and read the data into your notebook.

{:.input}
```python
# Download file from Earth Lab figshare repository
data_path = os.path.join("colorado-flood", "boulder-precip.csv")
urllib.request.urlretrieve(url='https://ndownloader.figshare.com/files/7010681',
                           filename=data_path)

```

{:.output}
{:.execute_result}



    ('colorado-flood/boulder-precip.csv',
     <http.client.HTTPMessage at 0x7f5933ecd700>)





{:.input}
```python
# is parse dates a function argument that recoganizes dates
boulder_precip = pd.read_csv(data_path,
                             index_col=['DATE'])

# View first few rows of data
boulder_precip.head()

# Rename column
boulder_precip = boulder_precip.rename(columns={"Unnamed: 0": "observation"})
```

The data above were imported using pandas. Pandas dataframes have a default method (`.plot()`) that you can use to plot your data. Below the `PRECIP` column is plotted. Note that the color of the lines in the plot is set to purple. 

{:.input}
```python
# Plot using pandas .plot()
boulder_precip.plot(x="observation",
                    y='PRECIP',
                    color="purple")
plt.show()
```

{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}/images/courses/plot-data-in-python-textbook/01-plot-with-matplotlib/intro-to-plotting-matplotlib/unpublished-plot-with-matplotlib-00-intro-plotting-matplotlib-org-with-dataframes/unpublished-plot-with-matplotlib-00-intro-plotting-matplotlib-org-with-dataframes_7_0.png" alt = "Basic matplotlib plot with dates on the x axis using .plot().">
<figcaption>Basic matplotlib plot with dates on the x axis using .plot().</figcaption>

</figure>




The pandas function .plot() is a wrapper for Matplotlib. It is calling the matplotlib methods but simplifying the code for you. This is a great way to create a quick plot. However, sometimes you want to customize your plots. To customize it is often easier to utilize the core matplotlib functionality. 

## Plot with matplotlib

`Matplotlib` is a plotting package that makes it simple to create complex plots
from data in a `data.frame`. `Matplotlib` plots are object-oriented and can be built 
step by step by adding new elements to the plot. Below you are using an explicetly object-oriented
plotting approach which includes defining your axes object and the adding to it. 

To begin, creating a plot using this method you first define the axes using `plt.subplots()`.
Below you are assigning the `fig`ure and the `ax`is objects.  This assignment will make it easier to 
customize your plot later.

{:.input}
```python
# Create the plot space upon which to plot the data
fig, ax = plt.subplots()
```

{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}/images/courses/plot-data-in-python-textbook/01-plot-with-matplotlib/intro-to-plotting-matplotlib/unpublished-plot-with-matplotlib-00-intro-plotting-matplotlib-org-with-dataframes/unpublished-plot-with-matplotlib-00-intro-plotting-matplotlib-org-with-dataframes_9_0.png" alt = "When you create a figure object you are creating a blank canvas to place a plot on.">
<figcaption>When you create a figure object you are creating a blank canvas to place a plot on.</figcaption>

</figure>




Once you have defined your axis and figure objects, you can add some data to your plot.
Below, you call `ax.plot()`. Note that the `ax` element is the axis element that you 
defined above.

`ax.plot(boulder_precip['DATE'], boulder_precip)['PRECIP'])`

Note that below you also specify the `figsize` of the plot. figsize allows you to resize your plot.

{:.input}
```python
fig, ax = plt.subplots(figsize=(10, 6))
ax.plot(boulder_precip['observation'],
        boulder_precip['PRECIP'],
        color='purple')
plt.show()
```

{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}/images/courses/plot-data-in-python-textbook/01-plot-with-matplotlib/intro-to-plotting-matplotlib/unpublished-plot-with-matplotlib-00-intro-plotting-matplotlib-org-with-dataframes/unpublished-plot-with-matplotlib-00-intro-plotting-matplotlib-org-with-dataframes_11_0.png" alt = "Once you add a call to plot using ax.plot - your  blank canvas has a plot on it.">
<figcaption>Once you add a call to plot using ax.plot - your  blank canvas has a plot on it.</figcaption>

</figure>




Note that the ax object that you created above can be called anything that you want. While the 
convention is to use `ax` you could decide you wanted to call it bob. 

We don't suggest that you use obscure ax names however for your plots such as Bob.  

{:.input}
```python
fig, bob = plt.subplots(figsize=(10, 6))
bob.plot(boulder_precip['observation'],
         boulder_precip['PRECIP'],
         color='purple')
plt.show()
```

{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}/images/courses/plot-data-in-python-textbook/01-plot-with-matplotlib/intro-to-plotting-matplotlib/unpublished-plot-with-matplotlib-00-intro-plotting-matplotlib-org-with-dataframes/unpublished-plot-with-matplotlib-00-intro-plotting-matplotlib-org-with-dataframes_13_0.png">

</figure>




You can refine your plot by adding labels and a title. 

{:.input}
```python
# Define figure
fig, ax = plt.subplots(figsize=(10, 6))
# Define data and x and y axes
ax.plot(boulder_precip['observation'],
        boulder_precip['PRECIP'],
        color="purple")
# Set plot title
ax.set(title="Matplotlib Example Plot - Precipation")
plt.show()
```

{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}/images/courses/plot-data-in-python-textbook/01-plot-with-matplotlib/intro-to-plotting-matplotlib/unpublished-plot-with-matplotlib-00-intro-plotting-matplotlib-org-with-dataframes/unpublished-plot-with-matplotlib-00-intro-plotting-matplotlib-org-with-dataframes_15_0.png" alt = "You can customize your plot adding and adjust ticks and titles.">
<figcaption>You can customize your plot adding and adjust ticks and titles.</figcaption>

</figure>




You can use plt.setp to customize elements of the labels such as the tick labels. 
Below the labels are rotated 45 degrees.

Note that in the example below, `ax.get_xticklabels()` grabs the labels that will be used for your plot. Then those labels are rotated.

{:.input}
```python
# Define figure
fig, ax = plt.subplots(figsize=(10, 6))
# Define data and x and y axes
ax.plot(boulder_precip['observation'],
        boulder_precip['PRECIP'],
        color="purple")
# Set plot title
ax.set(title="Matplotlib Example Plot - Precipation")
plt.show()
```

{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}/images/courses/plot-data-in-python-textbook/01-plot-with-matplotlib/intro-to-plotting-matplotlib/unpublished-plot-with-matplotlib-00-intro-plotting-matplotlib-org-with-dataframes/unpublished-plot-with-matplotlib-00-intro-plotting-matplotlib-org-with-dataframes_17_0.png">

</figure>




## Custom Markers and Symbols

You can customize the look of the plot in different ways. For instance, you can change the point marker type to a circle using the function argument:  `-o`.

Visit the <a href="http://matplotlib.org/1.4.1/api/markers_api.html" target="_blank">Matplotlib documentation </a> for a list of marker types. 

|Marker symbol| Marker description
|---|---|
| . | 	point |
| , |	pixel |
| o |	circle|
| v | 	triangle_down|
| ^ | 	triangle_up |
| < |	triangle_left|
| > | 	triangle_right |


{:.input}
```python
fig, ax = plt.subplots(figsize=(9, 7))
ax.plot(boulder_precip['observation'], 
        boulder_precip['PRECIP'], 
        '-o', color="purple")
ax.set(title="matplotlib example plot precip")
plt.setp(ax.get_xticklabels(), rotation=45)
plt.show()
```

{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}/images/courses/plot-data-in-python-textbook/01-plot-with-matplotlib/intro-to-plotting-matplotlib/unpublished-plot-with-matplotlib-00-intro-plotting-matplotlib-org-with-dataframes/unpublished-plot-with-matplotlib-00-intro-plotting-matplotlib-org-with-dataframes_19_0.png" alt = "Here you adjust the point markers used in your plot.">
<figcaption>Here you adjust the point markers used in your plot.</figcaption>

</figure>




<i class="fa fa-star"></i> **Data Tip:**
If your dataframe has an index column and you want to use it for the x or y axis, you can access it with `DataFramename.index`. Above you use `boulder_precip.index.values` to access the date values 
{: .notice--success }

## Customize point colors

You can also apply a color to your points using the `c=` argument. Below the points are to blue using `c='blue'`

A list of some of the color options available in `python` is below:

        b: blue
        g: green
        r: red
        c: cyan
        m: magenta
        y: yellow
        k: black
        w: white


<i class="fa fa-star"></i> **Data Tip:**
For more information about conda environments check out the `matplotlib` [colors documentation](https://matplotlib.org/api/colors_api.html)
{: .notice--success }

{:.input}
```python
fig, ax = plt.subplots(figsize=(9, 7))
ax.scatter(boulder_precip['observation'],
           boulder_precip['PRECIP'].values,
           c='blue')
plt.setp(ax.get_xticklabels(), rotation=45)
plt.show()
```

{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}/images/courses/plot-data-in-python-textbook/01-plot-with-matplotlib/intro-to-plotting-matplotlib/unpublished-plot-with-matplotlib-00-intro-plotting-matplotlib-org-with-dataframes/unpublished-plot-with-matplotlib-00-intro-plotting-matplotlib-org-with-dataframes_22_0.png" alt = "Adjust the ticklabels on the x-axis and create a scatterplot.">
<figcaption>Adjust the ticklabels on the x-axis and create a scatterplot.</figcaption>

</figure>




You can adjust the transparency of each point using the `alpha=` argument.

{:.input}
```python
fig, ax = plt.subplots(figsize=(9, 7))
ax.scatter(boulder_precip['observation'],
           boulder_precip['PRECIP'],
           c='blue', alpha=.5)
plt.setp(ax.get_xticklabels(), rotation=45)
plt.show()
```

{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}/images/courses/plot-data-in-python-textbook/01-plot-with-matplotlib/intro-to-plotting-matplotlib/unpublished-plot-with-matplotlib-00-intro-plotting-matplotlib-org-with-dataframes/unpublished-plot-with-matplotlib-00-intro-plotting-matplotlib-org-with-dataframes_24_0.png" alt = "Adjust the alpha value to add transparency to your points.">
<figcaption>Adjust the alpha value to add transparency to your points.</figcaption>

</figure>




You can also assign each point a color based upon it's data value by

assigning `c=` to the values in the data.
`c=boulder_precip['PRECIP'].values`

and then specifying colors using the `cmap=` argument.
`cmap='rainbow'`

{:.input}
```python
# Setup figure
fig, ax = plt.subplots(figsize=(9,7))
ax.scatter(boulder_precip['observation'],
           boulder_precip['PRECIP'],
           c=boulder_precip['PRECIP'],
           alpha=.5, cmap='rainbow')
plt.setp(ax.get_xticklabels(), rotation=45)
plt.show()
```

{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}/images/courses/plot-data-in-python-textbook/01-plot-with-matplotlib/intro-to-plotting-matplotlib/unpublished-plot-with-matplotlib-00-intro-plotting-matplotlib-org-with-dataframes/unpublished-plot-with-matplotlib-00-intro-plotting-matplotlib-org-with-dataframes_26_0.png" alt = "Color points according to an attribute value.">
<figcaption>Color points according to an attribute value.</figcaption>

</figure>




### Create Bar Plots with Matplotlib 

Above, you used the `.plot()` method to create a plot. This by default creates a 
line or scatter plot. You create a bar plot using `ax.bar()`.


{:.input}
```python
fig, ax = plt.subplots(figsize=(9, 7))
ax.bar(boulder_precip['observation'],
       boulder_precip['PRECIP'].values,
       color="purple")
plt.setp(ax.get_xticklabels(), rotation=45)
plt.show()
```

{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}/images/courses/plot-data-in-python-textbook/01-plot-with-matplotlib/intro-to-plotting-matplotlib/unpublished-plot-with-matplotlib-00-intro-plotting-matplotlib-org-with-dataframes/unpublished-plot-with-matplotlib-00-intro-plotting-matplotlib-org-with-dataframes_28_0.png" alt = "When you create a bar plot you need to call .values on your data.">
<figcaption>When you create a bar plot you need to call .values on your data.</figcaption>

</figure>





You can customize your bar plot too. To begin, change the outline color for 
each bar to be blue using `edgecolor`.

{:.input}
```python
fig, ax = plt.subplots(figsize=(9, 7))
ax.bar(boulder_precip['observation'],
       boulder_precip['PRECIP'],
       color="purple",
       edgecolor='blue')
plt.setp(ax.get_xticklabels(), rotation=45)
plt.show()
```

{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}/images/courses/plot-data-in-python-textbook/01-plot-with-matplotlib/intro-to-plotting-matplotlib/unpublished-plot-with-matplotlib-00-intro-plotting-matplotlib-org-with-dataframes/unpublished-plot-with-matplotlib-00-intro-plotting-matplotlib-org-with-dataframes_30_0.png" alt = "Just like you could adjust point colors you can adjust the bar fill and edge colors.">
<figcaption>Just like you could adjust point colors you can adjust the bar fill and edge colors.</figcaption>

</figure>






Change the fill to bright green.




{:.input}
```python
fig, ax = plt.subplots(figsize=(9, 7))
ax.bar(boulder_precip['observation'], 
       boulder_precip['PRECIP'].values,
       edgecolor='blue', color='green')
plt.setp(ax.get_xticklabels(), rotation=45)
plt.show()
```

{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}/images/courses/plot-data-in-python-textbook/01-plot-with-matplotlib/intro-to-plotting-matplotlib/unpublished-plot-with-matplotlib-00-intro-plotting-matplotlib-org-with-dataframes/unpublished-plot-with-matplotlib-00-intro-plotting-matplotlib-org-with-dataframes_32_0.png" alt = "Here the bar color is set to green and the edge color is blue.">
<figcaption>Here the bar color is set to green and the edge color is blue.</figcaption>

</figure>




### Use Matplotlib Styles or Themes


Try out a new style usind this function 

Matplotlib also has a set of predefined color palettes that you can apply to a plot. To view a list of available styles, use:

`plt.style.use()` 

{:.input}
```python
# view all styles
print(plt.style.available)
```

{:.output}
    ['Solarize_Light2', '_classic_test_patch', 'bmh', 'classic', 'dark_background', 'fast', 'fivethirtyeight', 'ggplot', 'grayscale', 'seaborn', 'seaborn-bright', 'seaborn-colorblind', 'seaborn-dark', 'seaborn-dark-palette', 'seaborn-darkgrid', 'seaborn-deep', 'seaborn-muted', 'seaborn-notebook', 'seaborn-paper', 'seaborn-pastel', 'seaborn-poster', 'seaborn-talk', 'seaborn-ticks', 'seaborn-white', 'seaborn-whitegrid', 'tableau-colorblind10']



{:.input}
```python
fig, ax = plt.subplots(figsize=(9, 7))
ax.bar(boulder_precip['observation'], 
       boulder_precip['PRECIP'].values)
plt.setp(ax.get_xticklabels(), rotation=45)
plt.style.use('seaborn-poster')
plt.show()
```

{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}/images/courses/plot-data-in-python-textbook/01-plot-with-matplotlib/intro-to-plotting-matplotlib/unpublished-plot-with-matplotlib-00-intro-plotting-matplotlib-org-with-dataframes/unpublished-plot-with-matplotlib-00-intro-plotting-matplotlib-org-with-dataframes_35_0.png" alt = "There are many styles that you can apply to make your plots look nicer and uniform. Here a style is called within the plot code. This style will only be applied to this plot.">
<figcaption>There are many styles that you can apply to make your plots look nicer and uniform. Here a style is called within the plot code. This style will only be applied to this plot.</figcaption>

</figure>




## Add Plot Labels

You can add labels to your plots as well. Below you add a title, and an x and y label using the `xlabel` and `ylabel` arguments within the `ax.set()` method. Notice that the styles that you selected above are still applied below.

{:.input}
```python
fig, ax = plt.subplots(figsize=(9, 7))
ax.bar(boulder_precip['observation'],
       boulder_precip['PRECIP'].values,
       edgecolor='blue')
plt.setp(ax.get_xticklabels(), rotation=45)
ax.set(xlabel="Date", ylabel="Precipitation (Inches)")
ax.set(title="Daily Precipitation (inches)\nBoulder, Colorado 2013")
plt.show()
```

{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}/images/courses/plot-data-in-python-textbook/01-plot-with-matplotlib/intro-to-plotting-matplotlib/unpublished-plot-with-matplotlib-00-intro-plotting-matplotlib-org-with-dataframes/unpublished-plot-with-matplotlib-00-intro-plotting-matplotlib-org-with-dataframes_37_0.png" alt = "You can label your x and y axes as well.">
<figcaption>You can label your x and y axes as well.</figcaption>

</figure>







<div class="notice--info" markdown="1">

## Additional Resources

Here are some additional `matplotlib` [examples](https://matplotlib.org/examples/pylab_examples/subplots_demo.html) and information about [color bars](http://joseph-long.com/writing/colorbars/). Here is an [in-depth guide](https://realpython.com/blog/python/python-matplotlib-guide/?utm_campaign=Data%2BElixir&utm_medium=email&utm_source=Data_Elixir_172) to `matplotlib` that will be useful for you to refer back to. 


</div>
