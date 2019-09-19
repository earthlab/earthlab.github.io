---
layout: single
title: "Introduction to Plotting in Python Using Matplotlib"
excerpt: 'Matplotlib is the most commonly used plotting library in Python. Learn how to create different types of plots and customize the colors and look of your plot using matplotlib.'
authors: ['Leah Wasser', 'Jenny Palomino']
dateCreated: 2019-09-11
modified: 2019-09-19
module-title: 'Introduction to Plotting with Matplotlib'
module-nav-title: 'Intro to Plotting with Matplotlib'
module-description: 'Matplotlib is the most commonly used plotting library in Python. Learn how to get started with creating and customizing plots using matplotlib.'
category: [courses]
class-lesson: ['intro-to-plotting-matplotlib']
course: 'plot-data-in-python'
nav-title: 'Intro to Matplotlib Plotting'
permalink: /courses/plot-data-in-python/plot-with-matplotlib/intro-plotting-matplotlib/
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

In this chapter, you will learn how to create and customize plots in **Python** using **matplotlib**, including how to create different types of plots and how to customize plot colors and labels. 

## <i class="fa fa-graduation-cap" aria-hidden="true"></i> Learning Objectives

After completing this chapter, you will be able to:

* Explain **matplotlib's** object-oriented approach to plotting. 
* Use **matplotlib** to create scatter, line and bar plots.
* Customize the labels, colors and look of your **matplotlib** plot.
* Create figures with multiple plots.
* Save figure as an image file (e.g. .png format).


## <i class="fa fa-check-square-o fa-2" aria-hidden="true"></i> What You Need

Be sure that you have followed the instructions on <a href="{{ site.url }}/workshops/setup-earth-analytics-python/">Setting up Git, Bash, and Conda on your computer</a> to install the tools for your operating system (Windows, Mac, Linux). 

Be sure that you have completed the chapter on <a href="{{ site.url }}/courses/intro-to-earth-data-science/open-reproducible-science/jupyter-python/">Jupyter Notebook</a>.

</div>


## Overview of Plotting with Matplotlib

<a href="https://matplotlib.org/">**Matplotlib**</a> is a **Python** plotting package that makes it simple to create two-dimensional plots from data stored in a variety of data structures including lists, **numpy** arrays, and **pandas** dataframes. 

**Matplotlib** uses an object-oriented approach to plotting, which allows plots to be built step-by-step by adding new elements to the plot. 

The primary objects of a **matplotlib** plot include:
* `fig` object: the overall figure space that can contain one or more plots
* `ax` objects: the individual plots that are rendered within the figure

While **Matplotlib** contains many modules that provide different plotting functionality, the most commonly used module is <a href="https://matplotlib.org/api/index.html#the-pyplot-api">**pyplot**</a>, which provides functions that work together to add different components to a figure (`fig`) including:
* creating the individual plots as `ax` objects
* adding data to the plots
* adding titles and labels to the plots
* etc


## Create Plots Using Matplotlib

To create a plot using matplotlib's object oriented approach, you first create the figure (`fig`) and at least one axis (`ax`) using the function `subplots()` from the `pyplot` module as follows:

`fig, ax = plt.subplots()`

Notice that the `fig` and `ax` are created at the same time by setting them equal to the output of the `pyplot.subplots()` function. As no other arguments have been provided, the result is a figure with one plot that is empty but ready for data. 

{:.input}
```python
# Import necessary packages
import matplotlib.pyplot as plt
```

{:.input}
```python
# Define figure space and one plot (ax object) 
fig, ax = plt.subplots()
```

{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}/images/courses/plot-data-in-python/01-plot-with-matplotlib/intro-to-plotting-matplotlib/2019-09-11-plot-with-matplotlib-01-intro-plotting-matplotlib/2019-09-11-plot-with-matplotlib-01-intro-plotting-matplotlib_3_0.png" alt = "When you create a figure object, you are creating a blank canvas upon which to place a plot.">
<figcaption>When you create a figure object, you are creating a blank canvas upon which to place a plot.</figcaption>

</figure>




You can change the size of your plot using the argument `figsize` to specify a width and height for your plot as follows: 

`figsize = (width, height)`

{:.input}
```python
# Resize figure
fig, ax = plt.subplots(figsize = (10, 6))
```

{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}/images/courses/plot-data-in-python/01-plot-with-matplotlib/intro-to-plotting-matplotlib/2019-09-11-plot-with-matplotlib-01-intro-plotting-matplotlib/2019-09-11-plot-with-matplotlib-01-intro-plotting-matplotlib_5_0.png" alt = "When you create a figure object, you can define the figure size by providing a width and height value (width, height).">
<figcaption>When you create a figure object, you can define the figure size by providing a width and height value (width, height).</figcaption>

</figure>




Now that you have defined your `fig` and `ax` objects, you can add some data to your plot.

Begin by creating a few lists to plot the monthly average precipitation (inches) for <a href="https://www.esrl.noaa.gov/psd/boulder/Boulder.mm.precip.html">Boulder, Colorado provided by the U.S. National Oceanic and Atmospheric Administration (NOAA)</a>.

{:.input}
```python
# Monthly average precipitation
boulder_monthly_precip = [0.70, 0.75, 1.85, 2.93, 3.05, 2.02, 
                          1.93, 1.62, 1.84, 1.31, 1.39, 0.84]

# Month names for plotting
months = ["Jan", "Feb", "Mar", "Apr", "May", "June", "July", 
          "Aug", "Sept", "Oct", "Nov", "Dec"]
```

## Add Data to Plots

You can add data to your plot by calling the `ax` object, which is the axis element that you previously defined with: 

`fig, ax = plt.subplots()`

You can call the `.plot` method of the `ax` object and specify the arguments for the x axis (horizontal axis) and the y axis (vertical axis) of the plot as follows:

`ax.plot(x_axis, y_axis)`

In this example, you are adding data from lists that you previously defined, with months along the x axis and boulder_monthly_precip along the y axis.  

Note that the data plotted along the x and y axes can also come from **numpy** arrays as well as rows or columns in a **pandas** dataframes. 

{:.input}
```python
# Define plot space
fig, ax = plt.subplots(figsize=(10, 6))

# Define x and y axes
ax.plot(months, 
        boulder_monthly_precip)
```

{:.output}
{:.execute_result}



    [<matplotlib.lines.Line2D at 0x7f5bc15ee470>]





{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}/images/courses/plot-data-in-python/01-plot-with-matplotlib/intro-to-plotting-matplotlib/2019-09-11-plot-with-matplotlib-01-intro-plotting-matplotlib/2019-09-11-plot-with-matplotlib-01-intro-plotting-matplotlib_9_1.png" alt = "You can use ax.plot to add a line plot to your figure.">
<figcaption>You can use ax.plot to add a line plot to your figure.</figcaption>

</figure>




Note that the output displays the object type as well as the unique identifier for the figure, for example: 

`<matplotlib.lines.Line2D at 0x7f12063c7898>`

You can hide this information from the output by simply adding `plt.show()` as the last line you call in your plot code. 

{:.input}
```python
# Define plot space
fig, ax = plt.subplots(figsize=(10, 6))

# Define x and y axes
ax.plot(months, 
        boulder_monthly_precip)

plt.show()
```

{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}/images/courses/plot-data-in-python/01-plot-with-matplotlib/intro-to-plotting-matplotlib/2019-09-11-plot-with-matplotlib-01-intro-plotting-matplotlib/2019-09-11-plot-with-matplotlib-01-intro-plotting-matplotlib_11_0.png" alt = "You can add plt.show() as the last code line to hide the extra output that is generated about the unique identifier for the figure.">
<figcaption>You can add plt.show() as the last code line to hide the extra output that is generated about the unique identifier for the figure.</figcaption>

</figure>




Note also that the `ax` object that you created above can actually be called anything that you want; for example, you could decide you wanted to call it `bob`! 

However, it is not good practice to use random names for objects such as `bob`. 

The convention in the **Python** community is to use `ax` to name this `ax` object, but it is good to know that objects in **Python** do not have to be named something specific.  

You simply need to use the same name to call the object that you want, each time that you call it. 

For example, if you did name the `ax` object `bob` when you created it, then you would use the same name `bob` to call the object when you want to add data to it. 

{:.input}
```python
# Define plot space with ax named bob
fig, bob = plt.subplots(figsize=(10, 6))

# Define x and y axes
bob.plot(months, 
         boulder_monthly_precip)

plt.show()
```

{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}/images/courses/plot-data-in-python/01-plot-with-matplotlib/intro-to-plotting-matplotlib/2019-09-11-plot-with-matplotlib-01-intro-plotting-matplotlib/2019-09-11-plot-with-matplotlib-01-intro-plotting-matplotlib_13_0.png" alt = "While it is convention to use ax as the name of the axis object, you can actually call it whatever you want, even something like bob.">
<figcaption>While it is convention to use ax as the name of the axis object, you can actually call it whatever you want, even something like bob.</figcaption>

</figure>




## Change Plot Type

You may have noticed that by default `ax.plot` creates the plot as a line plot (meaning that all of the values are connected by a continuous line across the plot).

You can also use the `ax` object to create:
* scatter plots (using `ax.scatter`): values are displayed as individual points that are not connected with a continuous line. 
* bar plots ( using `ax.bar`): values are displayed as bars with height indicating the value at a specific point.

{:.input}
```python
# Define plot space
fig, ax = plt.subplots(figsize=(10, 6))

# Create scatter plot
ax.scatter(months, 
           boulder_monthly_precip)

plt.show()
```

{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}/images/courses/plot-data-in-python/01-plot-with-matplotlib/intro-to-plotting-matplotlib/2019-09-11-plot-with-matplotlib-01-intro-plotting-matplotlib/2019-09-11-plot-with-matplotlib-01-intro-plotting-matplotlib_15_0.png" alt = "You can use ax.scatter to create a scatter plot.">
<figcaption>You can use ax.scatter to create a scatter plot.</figcaption>

</figure>




{:.input}
```python
# Define plot space
fig, ax = plt.subplots(figsize=(10, 6))

# Create bar plot
ax.bar(months, 
       boulder_monthly_precip)

plt.show()
```

{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}/images/courses/plot-data-in-python/01-plot-with-matplotlib/intro-to-plotting-matplotlib/2019-09-11-plot-with-matplotlib-01-intro-plotting-matplotlib/2019-09-11-plot-with-matplotlib-01-intro-plotting-matplotlib_16_0.png" alt = "You can use ax.bar to create a scatter bar.">
<figcaption>You can use ax.bar to create a scatter bar.</figcaption>

</figure>




## Customize Plot Title and Axes Labels

You can customize and add more information to your plot by adding a plot title and labels for the axes using the `title`, `xlabel`, `ylabel` arguments within the `ax.set()` method: 

```
ax.set(title = "Plot title here",
       xlabel = "X axis label here", 
       ylabel = "Y axis label here")
```

{:.input}
```python
# Define plot space
fig, ax = plt.subplots(figsize=(10, 6))

# Define x and y axes
ax.plot(months, 
        boulder_monthly_precip)

# Set plot title and axes labels
ax.set(title = "Average Monthly Precipitation in Boulder, CO",
       xlabel = "Month",
       ylabel = "Precipitation (inches)")

plt.show()
```

{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}/images/courses/plot-data-in-python/01-plot-with-matplotlib/intro-to-plotting-matplotlib/2019-09-11-plot-with-matplotlib-01-intro-plotting-matplotlib/2019-09-11-plot-with-matplotlib-01-intro-plotting-matplotlib_18_0.png" alt = "You can customize your plot by adding titles and axes labels.">
<figcaption>You can customize your plot by adding titles and axes labels.</figcaption>

</figure>




### Multi-line Titles and Labels

You can also create titles and axes labels with have multiple lines of text using the new line character `\n` between two words to identity the start of the new line.

{:.input}
```python
# Define plot space
fig, ax = plt.subplots(figsize=(10, 6))

# Define x and y axes
ax.plot(months, 
        boulder_monthly_precip)

# Set plot title and axes labels
ax.set(title = "Average Monthly Precipitation\nBoulder, CO",
       xlabel = "Month",
       ylabel = "Precipitation\n(inches)")

plt.show()
```

{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}/images/courses/plot-data-in-python/01-plot-with-matplotlib/intro-to-plotting-matplotlib/2019-09-11-plot-with-matplotlib-01-intro-plotting-matplotlib/2019-09-11-plot-with-matplotlib-01-intro-plotting-matplotlib_20_0.png" alt = "You can use the new line symbol 
 between words to generate multi line titles and axes labels (e.g. Precipitation
(inches)).">
<figcaption>You can use the new line symbol 
 between words to generate multi line titles and axes labels (e.g. Precipitation
(inches)).</figcaption>

</figure>




### Rotate Labels

You can use `plt.setp` to set properties in your plot, such as customizing labels including the tick labels. 

In the example below, `ax.get_xticklabels()` grabs the tick labels from the x axis, and then the `rotation` argument specifies an angle of rotation (e.g. 45), so that the tick labels along the x axis are rotated 45 degrees. 

{:.input}
```python
# Define plot space
fig, ax = plt.subplots(figsize=(10, 6))

# Define x and y axes
ax.plot(months, 
        boulder_monthly_precip)

# Set plot title and axes labels
ax.set(title = "Average Monthly Precipitation\nBoulder, CO",
       xlabel = "Month",
       ylabel = "Precipitation\n(inches)")

plt.setp(ax.get_xticklabels(), rotation = 45)

plt.show()
```

{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}/images/courses/plot-data-in-python/01-plot-with-matplotlib/intro-to-plotting-matplotlib/2019-09-11-plot-with-matplotlib-01-intro-plotting-matplotlib/2019-09-11-plot-with-matplotlib-01-intro-plotting-matplotlib_22_0.png" alt = "You can use plt.setp(ax.get_xticklabels(), rotation 45) to rotate the tick marks along the x axis by 45 degrees.">
<figcaption>You can use plt.setp(ax.get_xticklabels(), rotation 45) to rotate the tick marks along the x axis by 45 degrees.</figcaption>

</figure>




## Custom Markers in Line and Scatter Plots

You can change the point marker type in your line or scatter plot using the argument  `marker =` and setting it equal to the symbol that you want to use to identify the points in the plot. 

For example, `","` will display the point markers as a pixel or box, and "o" will displau point markers as a circle.   

|Marker symbol| Marker description
|---|---|
| . | 	point |
| , |	pixel |
| o |	circle|
| v | 	triangle_down|
| ^ | 	triangle_up |
| < |	triangle_left|
| > | 	triangle_right |

Visit the <a href="http://matplotlib.org/1.4.1/api/markers_api.html" target="_blank">Matplotlib documentation </a> for a list of marker types. 


{:.input}
```python
# Define plot space
fig, ax = plt.subplots(figsize=(10, 6))

# Define x and y axes
ax.scatter(months, 
        boulder_monthly_precip,
        marker = ',')

# Set plot title and axes labels
ax.set(title = "Average Monthly Precipitation\nBoulder, CO",
       xlabel = "Month",
       ylabel = "Precipitation\n(inches)")

plt.show()
```

{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}/images/courses/plot-data-in-python/01-plot-with-matplotlib/intro-to-plotting-matplotlib/2019-09-11-plot-with-matplotlib-01-intro-plotting-matplotlib/2019-09-11-plot-with-matplotlib-01-intro-plotting-matplotlib_24_0.png" alt = "You can customize the symbol on a scatter or line plot using a variety of characters such as a , which indicates that you want a square symbol at each data point in the plot.">
<figcaption>You can customize the symbol on a scatter or line plot using a variety of characters such as a , which indicates that you want a square symbol at each data point in the plot.</figcaption>

</figure>




{:.input}
```python
# Define plot space
fig, ax = plt.subplots(figsize=(10, 6))

# Define x and y axes
ax.plot(months, 
        boulder_monthly_precip,
        marker = 'o')

# Set plot title and axes labels
ax.set(title = "Average Monthly Precipitation\nBoulder, CO",
       xlabel = "Month",
       ylabel = "Precipitation\n(inches)")

plt.show()
```

{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}/images/courses/plot-data-in-python/01-plot-with-matplotlib/intro-to-plotting-matplotlib/2019-09-11-plot-with-matplotlib-01-intro-plotting-matplotlib/2019-09-11-plot-with-matplotlib-01-intro-plotting-matplotlib_25_0.png" alt = "You can customize the symbol on a scatter or line plot using a variety of characters such as an o which indicates that you want a circular symbol at each data point in the plot.">
<figcaption>You can customize the symbol on a scatter or line plot using a variety of characters such as an o which indicates that you want a circular symbol at each data point in the plot.</figcaption>

</figure>




## Customize Plot Colors 

You can customize the color of your plot using the `color` argument and setting it equal to the color that you want to use for the plot. 

A list of some of the base color options available in **matplotlib** is below:

        b: blue
        g: green
        r: red
        c: cyan
        m: magenta
        y: yellow
        k: black
        w: white

For these base colors, you can set the `color` argument equal to the full name (e.g. `cyan`) or simply just the key letter as shown in the table above (e.g. `c`).  

<i class="fa fa-star"></i> **Data Tip:**
For more colors, visit the <a href="https://matplotlib.org/gallery/color/named_colors.html#sphx-glr-gallery-color-named-colors-py" target="_blank">matplotlib documentation</a> on color. 
{: .notice--success }

{:.input}
```python
# Define plot space
fig, ax = plt.subplots(figsize=(10, 6))

# Define x and y axes
ax.plot(months, 
        boulder_monthly_precip,
        marker = 'o',
        color = 'cyan')

# Set plot title and axes labels
ax.set(title = "Average Monthly Precipitation\nBoulder, CO",
       xlabel = "Month",
       ylabel = "Precipitation\n(inches)")

plt.show()
```

{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}/images/courses/plot-data-in-python/01-plot-with-matplotlib/intro-to-plotting-matplotlib/2019-09-11-plot-with-matplotlib-01-intro-plotting-matplotlib/2019-09-11-plot-with-matplotlib-01-intro-plotting-matplotlib_27_0.png" alt = "You can customize the colors on a plot using the argument called color and provided a key word for a base color such as cyan.">
<figcaption>You can customize the colors on a plot using the argument called color and provided a key word for a base color such as cyan.</figcaption>

</figure>




{:.input}
```python
# Define plot space
fig, ax = plt.subplots(figsize=(10, 6))

# Define x and y axes
ax.scatter(months, 
        boulder_monthly_precip,
        marker = ',',
        color = 'k')

# Set plot title and axes labels
ax.set(title = "Average Monthly Precipitation\nBoulder, CO",
       xlabel = "Month",
       ylabel = "Precipitation\n(inches)")

plt.show()
```

{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}/images/courses/plot-data-in-python/01-plot-with-matplotlib/intro-to-plotting-matplotlib/2019-09-11-plot-with-matplotlib-01-intro-plotting-matplotlib/2019-09-11-plot-with-matplotlib-01-intro-plotting-matplotlib_28_0.png" alt = "You can customize the colors on a plot using the argument called color and provided a key word abbreviation for a base color such as k for black.">
<figcaption>You can customize the colors on a plot using the argument called color and provided a key word abbreviation for a base color such as k for black.</figcaption>

</figure>




{:.input}
```python
# Define plot space
fig, ax = plt.subplots(figsize=(10, 6))

# Define x and y axes
ax.bar(months, 
        boulder_monthly_precip,
        color = 'darkblue')

# Set plot title and axes labels
ax.set(title = "Average Monthly Precipitation\nBoulder, CO",
       xlabel = "Month",
       ylabel = "Precipitation\n(inches)")

plt.show()
```

{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}/images/courses/plot-data-in-python/01-plot-with-matplotlib/intro-to-plotting-matplotlib/2019-09-11-plot-with-matplotlib-01-intro-plotting-matplotlib/2019-09-11-plot-with-matplotlib-01-intro-plotting-matplotlib_29_0.png" alt = "You can customize the colors on a plot using the argument called color and provided a key word for a base color such as darkblue.">
<figcaption>You can customize the colors on a plot using the argument called color and provided a key word for a base color such as darkblue.</figcaption>

</figure>




### Set Color Transpareny

You can also adjust the transparency of color using the `alpha = ` argument, with values closer to 0.0 indicating a higher transparency. 

{:.input}
```python
# Define plot space
fig, ax = plt.subplots(figsize=(10, 6))

# Define x and y axes
ax.bar(months, 
       boulder_monthly_precip,
       color = 'darkblue', 
       alpha = 0.3)

# Set plot title and axes labels
ax.set(title = "Average Monthly Precipitation\nBoulder, CO",
       xlabel = "Month",
       ylabel = "Precipitation\n(inches)")

plt.show()
```

{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}/images/courses/plot-data-in-python/01-plot-with-matplotlib/intro-to-plotting-matplotlib/2019-09-11-plot-with-matplotlib-01-intro-plotting-matplotlib/2019-09-11-plot-with-matplotlib-01-intro-plotting-matplotlib_31_0.png" alt = "You can add and adjust an alpha value to add transparency to your plot data.">
<figcaption>You can add and adjust an alpha value to add transparency to your plot data.</figcaption>

</figure>




### Customize Colors For Bar Plots

You can customize your bar plot further by changing the outline color for each bar to be blue using the argument `edgecolor` and specifying a color from the **matplotlib** color options previously discussed. 

{:.input}
```python
# Define plot space
fig, ax = plt.subplots(figsize=(10, 6))

# Define x and y axes
ax.bar(months, 
       boulder_monthly_precip,
       color = 'cyan',
       edgecolor = 'darkblue')

# Set plot title and axes labels
ax.set(title = "Average Monthly Precipitation\nBoulder, CO",
       xlabel = "Month",
       ylabel = "Precipitation\n(inches)")

plt.show()
```

{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}/images/courses/plot-data-in-python/01-plot-with-matplotlib/intro-to-plotting-matplotlib/2019-09-11-plot-with-matplotlib-01-intro-plotting-matplotlib/2019-09-11-plot-with-matplotlib-01-intro-plotting-matplotlib_33_0.png" alt = "You can adjust the bar fill and edge colors of a bar plot using the arguments color and edgecolor.">
<figcaption>You can adjust the bar fill and edge colors of a bar plot using the arguments color and edgecolor.</figcaption>

</figure>




### Customize Colors For Scatter Plots

When using scatter plots, you can also assign each point a color based upon its data value using the `c` and `cmap` arguments.

The `c` argument allows you to specify the sequence of values that will be color-mapped (e.g. `boulder_monthly_precip`), while `cmap` allows you to specify the color map to use for the sequence. 

The example below uses the `YlGnBu` colormap, in which lower values are filled in with yellow to green shades, while higher values are filled in with increasingly darker shades of blue. 

<i class="fa fa-star"></i> **Data Tip:**
To see a list of color map options, visit the <a href="https://matplotlib.org/3.1.1/gallery/color/colormap_reference.html" target="_blank">matplotlib documentation</a> on colormaps. 
{: .notice--success }

{:.input}
```python
# Define plot space
fig, ax = plt.subplots(figsize=(10, 6))

# Define x and y axes
ax.scatter(months, 
        boulder_monthly_precip,
        c = boulder_monthly_precip,
        cmap = 'YlGnBu')

# Set plot title and axes labels
ax.set(title = "Average Monthly Precipitation\nBoulder, CO",
       xlabel = "Month",
       ylabel = "Precipitation\n(inches)")

plt.show()
```

{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}/images/courses/plot-data-in-python/01-plot-with-matplotlib/intro-to-plotting-matplotlib/2019-09-11-plot-with-matplotlib-01-intro-plotting-matplotlib/2019-09-11-plot-with-matplotlib-01-intro-plotting-matplotlib_35_0.png" alt = "You can adjust the colors of the points in a scatter plot using color maps (cmap argument), which allows you to specify a range of colors that will be applied to the data points depending on their value.">
<figcaption>You can adjust the colors of the points in a scatter plot using color maps (cmap argument), which allows you to specify a range of colors that will be applied to the data points depending on their value.</figcaption>

</figure>




## Multi-plot Figures

Using matplotlib's object-oriented approach makes it easier to include more than one plot in a figure by creating additional `ax` objects. 

When adding more than one `ax` object, it is good practice to give them distinct names (such as `ax1` and `ax2`), so you can easily work with each `ax` individually.

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

<img src = "{{ site.url }}/images/courses/plot-data-in-python/01-plot-with-matplotlib/intro-to-plotting-matplotlib/2019-09-11-plot-with-matplotlib-01-intro-plotting-matplotlib/2019-09-11-plot-with-matplotlib-01-intro-plotting-matplotlib_37_0.png" alt = "You can create figures with multiple plots by adding additional ax objects (e.g. ax1, ax2).">
<figcaption>You can create figures with multiple plots by adding additional ax objects (e.g. ax1, ax2).</figcaption>

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

<img src = "{{ site.url }}/images/courses/plot-data-in-python/01-plot-with-matplotlib/intro-to-plotting-matplotlib/2019-09-11-plot-with-matplotlib-01-intro-plotting-matplotlib/2019-09-11-plot-with-matplotlib-01-intro-plotting-matplotlib_39_0.png" alt = "You can change the layout of the figure to specify how many rows and columns you want to use to display the plots.">
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

<img src = "{{ site.url }}/images/courses/plot-data-in-python/01-plot-with-matplotlib/intro-to-plotting-matplotlib/2019-09-11-plot-with-matplotlib-01-intro-plotting-matplotlib/2019-09-11-plot-with-matplotlib-01-intro-plotting-matplotlib_41_0.png" alt = "You can adjust the figshare as well as the number of rows and columns for a figure layout, in order to achieve the desired layout of the plots.">
<figcaption>You can adjust the figshare as well as the number of rows and columns for a figure layout, in order to achieve the desired layout of the plots.</figcaption>

</figure>




Now that you have your `fig` and two `ax` objects defined, you can add data to each `ax` and define the plot with unique characteristics. 

In the example below, `ax1.bar` creates a bar plot for the first plot, and `ax2.scatter` creates a scatter for the second plot. 

{:.input}
```python
# Define plot space
fig, (ax1, ax2) = plt.subplots(2, 1, figsize=(12, 12))

# Define x and y axes
ax1.bar(months, 
       boulder_monthly_precip,
       color = 'cyan', 
       edgecolor = 'darkblue')

# Define x and y axes
ax2.scatter(months, 
        boulder_monthly_precip,
        c = boulder_monthly_precip,
        cmap = 'YlGnBu')

plt.show()
```

{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}/images/courses/plot-data-in-python/01-plot-with-matplotlib/intro-to-plotting-matplotlib/2019-09-11-plot-with-matplotlib-01-intro-plotting-matplotlib/2019-09-11-plot-with-matplotlib-01-intro-plotting-matplotlib_43_0.png" alt = "Each ax object (e.g. ax1, ax2) is independent and can contain different data, plot colors, etc.">
<figcaption>Each ax object (e.g. ax1, ax2) is independent and can contain different data, plot colors, etc.</figcaption>

</figure>




You can continue to add to `ax1` and `ax2` such as adding the title and axes labels for each individual plot, just like you did before when the figure only had one plot.

You can use `ax1.set()` to define these elements for the first plot (the bar plot), and `ax2.set()` to define them for the second plot (the scatter plot). 

{:.input}
```python
# Define plot space
fig, (ax1, ax2) = plt.subplots(2, 1, figsize=(12, 12))

# Define x and y axes
ax1.bar(months, 
       boulder_monthly_precip,
       color = 'cyan', 
       edgecolor = 'darkblue')

# Set plot title and axes labels
ax1.set(title = "Bar Plot of Average Monthly Precipitation",
       xlabel = "Month",
       ylabel = "Precipitation\n(inches)");

# Define x and y axes
ax2.scatter(months, 
        boulder_monthly_precip,
        c = boulder_monthly_precip,
        cmap = 'YlGnBu')

# Set plot title and axes labels
ax2.set(title = "Scatter Plot of Average Monthly Precipitation",
       xlabel = "Month",
       ylabel = "Precipitation\n(inches)")

plt.show()
```

{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}/images/courses/plot-data-in-python/01-plot-with-matplotlib/intro-to-plotting-matplotlib/2019-09-11-plot-with-matplotlib-01-intro-plotting-matplotlib/2019-09-11-plot-with-matplotlib-01-intro-plotting-matplotlib_45_0.png" alt = "Each ax object (e.g. ax1, ax2) is independent and can contain different titles, axes labels, etc.">
<figcaption>Each ax object (e.g. ax1, ax2) is independent and can contain different titles, axes labels, etc.</figcaption>

</figure>




Now that you have more than one plot (each with their own labels), you can add an overall title (with a specified font size) for the entire figure using: 

`fig.suptitle("Title text", fontsize = 16)`

{:.input}
```python
# Define plot space
fig, (ax1, ax2) = plt.subplots(2, 1, figsize=(12, 12))

fig.suptitle("Average Monthly Precipitation for Boulder, CO", fontsize = 16)

# Define x and y axes
ax1.bar(months, 
       boulder_monthly_precip,
       color = 'cyan', 
       edgecolor = 'darkblue')

# Set plot title and axes labels
ax1.set(title = "Bar Plot",
       xlabel = "Month",
       ylabel = "Precipitation\n(inches)");

# Define x and y axes
ax2.scatter(months, 
        boulder_monthly_precip,
        c = boulder_monthly_precip,
        cmap = 'YlGnBu')

# Set plot title and axes labels
ax2.set(title = "Scatter Plot",
       xlabel = "Month",
       ylabel = "Precipitation\n(inches)")

plt.show()
```

{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}/images/courses/plot-data-in-python/01-plot-with-matplotlib/intro-to-plotting-matplotlib/2019-09-11-plot-with-matplotlib-01-intro-plotting-matplotlib/2019-09-11-plot-with-matplotlib-01-intro-plotting-matplotlib_47_0.png" alt = "You can define an overall title for your figure using the fig.suptitle() method.">
<figcaption>You can define an overall title for your figure using the fig.suptitle() method.</figcaption>

</figure>




## Save Figure to Image File 

You can easily save a figure to an image file such as .png using: 

`plt.savefig("path/name-of-file.png")`

which will save the latest figure rendered. 

If you do not specify a path for the file, the file will be created in your current working directory. 

<a href="https://matplotlib.org/3.1.1/api/_as_gen/matplotlib.pyplot.savefig.html">**Matplotlib** documentation</a> to see a list of the additional file formats that be used to save figures.

{:.input}
```python
# Define plot space
fig, (ax1, ax2) = plt.subplots(2, 1, figsize=(12, 12))

fig.suptitle("Average Monthly Precipitation for Boulder, CO", fontsize = 16)

# Define x and y axes
ax1.bar(months, 
       boulder_monthly_precip,
       color = 'cyan', 
       edgecolor = 'darkblue')

# Set plot title and axes labels
ax1.set(title = "Bar Plot",
       xlabel = "Month",
       ylabel = "Precipitation\n(inches)");

# Define x and y axes
ax2.scatter(months, 
        boulder_monthly_precip,
        c = boulder_monthly_precip,
        cmap = 'YlGnBu')

# Set plot title and axes labels
ax2.set(title = "Scatter Plot",
       xlabel = "Month",
       ylabel = "Precipitation\n(inches)")

plt.savefig("average-monthly-precip-boulder-co.png")

plt.show()
```

{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}/images/courses/plot-data-in-python/01-plot-with-matplotlib/intro-to-plotting-matplotlib/2019-09-11-plot-with-matplotlib-01-intro-plotting-matplotlib/2019-09-11-plot-with-matplotlib-01-intro-plotting-matplotlib_49_0.png" alt = "You can save a figure to an image file such as .png usingthe plt.savefig() method.">
<figcaption>You can save a figure to an image file such as .png usingthe plt.savefig() method.</figcaption>

</figure>




<div class="notice--info" markdown="1">

## Additional Resources

* Additional information about [color bars](http://joseph-long.com/writing/colorbars/) 
* An [in-depth guide to matplotlib](https://realpython.com/blog/python/python-matplotlib-guide/?utm_campaign=Data%2BElixir&utm_medium=email&utm_source=Data_Elixir_172)

</div>
