---
layout: single
title: "Customize plots in Python using matplotlib"
excerpt: 'Matplotlib is the most commonly used plotting library in Python. Learn how to create different types of plots and customize the colors and look of your plot using matplotlib.'
authors: ['Leah Wasser', 'Jenny Palomino']
modified: 2019-09-17
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

* Use **matplotlib** to create custom scatter, line and bar plots.
* Add a title and x and y axes labels to your **matplotlib** plot.
* Customize the colors and look of your **matplotlib** plot.
* Apply pre-configured **matplotlib** styles or themes to your plot.


## <i class="fa fa-check-square-o fa-2" aria-hidden="true"></i> What You Need

Be sure that you have followed the instructions on <a href="{{ site.url }}/workshops/setup-earth-analytics-python/">Setting up Git, Bash, and Conda on your computer</a> to install the tools for your operating system (Windows, Mac, Linux). 

Be sure that you have completed the chapter on <a href="{{ site.url }}/courses/intro-to-earth-data-science/open-reproducible-science/jupyter-python/">Jupyter Notebook</a>.

</div>


## Overview of Plotting with Matplotlib

**Matplotlib** is a **Python** plotting package that makes it simple to create complex plots from data in a variety of data structures including lists, **numpy** arrays, and **pandas** dataframes. 

* Need to add more here

**Matplotlib** plots are object-oriented and can be built step-by-step by adding new elements to the plot.  


* Need to add more here
* what is the fig object
* what is the ax object


## Create Plots Using Matplotlib

To begin creating a plot using matplotlib's object oriented approach, you first define the initial axes using `plt.subplots()`, and then create the `fig` (figure) and the `ax` objects that you will use to add data and customize the look of your plot. 

{:.input}
```python
# Import necessary packages
import matplotlib.pyplot as plt
```

{:.input}
```python
# Define the plot space upon which to plot the data
fig, ax = plt.subplots()
```

{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}/images/courses/plot-data-in-python/01-plot-with-matplotlib/intro-to-plotting-matplotlib/2019-09-11-plot-with-matplotlib-01-intro-plotting-matplotlib/2019-09-11-plot-with-matplotlib-01-intro-plotting-matplotlib_3_0.png" alt = "When you create a figure object you are creating a blank canvas to place a plot on.">
<figcaption>When you create a figure object you are creating a blank canvas to place a plot on.</figcaption>

</figure>




To change the size of your plot, you can use the argument `figsize` to specify a width and height for your plot: 

`figsize = (width, height)`

{:.input}
```python
# Resize plot
fig, ax = plt.subplots(figsize = (10, 6))
```

{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}/images/courses/plot-data-in-python/01-plot-with-matplotlib/intro-to-plotting-matplotlib/2019-09-11-plot-with-matplotlib-01-intro-plotting-matplotlib/2019-09-11-plot-with-matplotlib-01-intro-plotting-matplotlib_5_0.png">

</figure>




Now that you have defined your axis and figure objects, you can add some data to your plot.

Begin by creating a few lists to plot the monthly average precipitation (inches) for Boulder, CO. 

{:.input}
```python
# Lists for plotting monthly average precipitation
boulder_monthly_precip = [0.70, 0.75, 1.85, 2.93, 3.05, 2.02, 
                          1.93, 1.62, 1.84, 1.31, 1.39, 0.84]

months = ["Jan", "Feb", "Mar", "Apr", "May", "June", "July", 
          "Aug", "Sept", "Oct", "Nov", "Dec"]
```

## Add Data to Plots

You can add data to your plot by calling the `ax` object, which is the axis element that you previously defined with: 

`fig, ax = plt.subplots()`

You can call the `.plot` method of the `ax` object and specify the arguments for the x axis (horizontal axis) and the y axis (vertical axis) as follows:

```
ax.plot(x_axis, y_axis)
```

In this example, you are adding data from lists that you previously defined, with months along the x axis and boulder_monthly_precip along the y axis.  Note that the data plotted along the x and y axes can also come from **numpy** arrays as well as rows or columns in a **pandas** dataframes. 

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



    [<matplotlib.lines.Line2D at 0x7f413438cc18>]





{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}/images/courses/plot-data-in-python/01-plot-with-matplotlib/intro-to-plotting-matplotlib/2019-09-11-plot-with-matplotlib-01-intro-plotting-matplotlib/2019-09-11-plot-with-matplotlib-01-intro-plotting-matplotlib_9_1.png" alt = "Once you add a call to plot using ax.plot - your  blank canvas has a plot on it.">
<figcaption>Once you add a call to plot using ax.plot - your  blank canvas has a plot on it.</figcaption>

</figure>




Note that the output displays the object type as well as the unique location of the plot on your computer, e.g.: 

`<matplotlib.lines.Line2D at 0x7f12063c7898>`

You can hide this information easily by simply adding a semicolon `;` to the end of the last line you call in your plot. 

{:.input}
```python
# Define plot space
fig, ax = plt.subplots(figsize=(10, 6))

# Define x and y axes
ax.plot(months, 
        boulder_monthly_precip);
```

{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}/images/courses/plot-data-in-python/01-plot-with-matplotlib/intro-to-plotting-matplotlib/2019-09-11-plot-with-matplotlib-01-intro-plotting-matplotlib/2019-09-11-plot-with-matplotlib-01-intro-plotting-matplotlib_11_0.png">

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
         boulder_monthly_precip);
```

{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}/images/courses/plot-data-in-python/01-plot-with-matplotlib/intro-to-plotting-matplotlib/2019-09-11-plot-with-matplotlib-01-intro-plotting-matplotlib/2019-09-11-plot-with-matplotlib-01-intro-plotting-matplotlib_13_0.png">

</figure>




## Change Plot Type

You may have noticed that by default `ax.plot` creates the plot as a line plot (meaning that all of the values are connected by a continuous line across the plot).

You can also use the `ax` object to create:
* scatter plots (`ax.scatter`): values are displayed as individual points that are not connected with a continuous line. 
* bar plots (`ax.bar`): values are displayed as bars with height indicating the value at a specific point.

{:.input}
```python
# Define plot space
fig, ax = plt.subplots(figsize=(10, 6))

# Create scatter plot
ax.scatter(months, 
           boulder_monthly_precip);
```

{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}/images/courses/plot-data-in-python/01-plot-with-matplotlib/intro-to-plotting-matplotlib/2019-09-11-plot-with-matplotlib-01-intro-plotting-matplotlib/2019-09-11-plot-with-matplotlib-01-intro-plotting-matplotlib_15_0.png">

</figure>




{:.input}
```python
# Define plot space
fig, ax = plt.subplots(figsize=(10, 6))

# Create bar plot
ax.bar(months, 
       boulder_monthly_precip);
```

{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}/images/courses/plot-data-in-python/01-plot-with-matplotlib/intro-to-plotting-matplotlib/2019-09-11-plot-with-matplotlib-01-intro-plotting-matplotlib/2019-09-11-plot-with-matplotlib-01-intro-plotting-matplotlib_16_0.png">

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
       ylabel = "Precipitation (inches)");
```

{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}/images/courses/plot-data-in-python/01-plot-with-matplotlib/intro-to-plotting-matplotlib/2019-09-11-plot-with-matplotlib-01-intro-plotting-matplotlib/2019-09-11-plot-with-matplotlib-01-intro-plotting-matplotlib_18_0.png" alt = "You can customize your plot adding and adjust ticks and titles.">
<figcaption>You can customize your plot adding and adjust ticks and titles.</figcaption>

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
       ylabel = "Precipitation\n(inches)");
```

{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}/images/courses/plot-data-in-python/01-plot-with-matplotlib/intro-to-plotting-matplotlib/2019-09-11-plot-with-matplotlib-01-intro-plotting-matplotlib/2019-09-11-plot-with-matplotlib-01-intro-plotting-matplotlib_20_0.png">

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

plt.setp(ax.get_xticklabels(), rotation = 45);
```

{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}/images/courses/plot-data-in-python/01-plot-with-matplotlib/intro-to-plotting-matplotlib/2019-09-11-plot-with-matplotlib-01-intro-plotting-matplotlib/2019-09-11-plot-with-matplotlib-01-intro-plotting-matplotlib_22_0.png">

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
        marker = ",")

# Set plot title and axes labels
ax.set(title = "Average Monthly Precipitation\nBoulder, CO",
       xlabel = "Month",
       ylabel = "Precipitation\n(inches)");
```

{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}/images/courses/plot-data-in-python/01-plot-with-matplotlib/intro-to-plotting-matplotlib/2019-09-11-plot-with-matplotlib-01-intro-plotting-matplotlib/2019-09-11-plot-with-matplotlib-01-intro-plotting-matplotlib_24_0.png">

</figure>




{:.input}
```python
# Define plot space
fig, ax = plt.subplots(figsize=(10, 6))

# Define x and y axes
ax.plot(months, 
        boulder_monthly_precip,
        marker = "o")

# Set plot title and axes labels
ax.set(title = "Average Monthly Precipitation\nBoulder, CO",
       xlabel = "Month",
       ylabel = "Precipitation\n(inches)");
```

{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}/images/courses/plot-data-in-python/01-plot-with-matplotlib/intro-to-plotting-matplotlib/2019-09-11-plot-with-matplotlib-01-intro-plotting-matplotlib/2019-09-11-plot-with-matplotlib-01-intro-plotting-matplotlib_25_0.png">

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
        marker = "o",
        color = "cyan")

# Set plot title and axes labels
ax.set(title = "Average Monthly Precipitation\nBoulder, CO",
       xlabel = "Month",
       ylabel = "Precipitation\n(inches)");
```

{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}/images/courses/plot-data-in-python/01-plot-with-matplotlib/intro-to-plotting-matplotlib/2019-09-11-plot-with-matplotlib-01-intro-plotting-matplotlib/2019-09-11-plot-with-matplotlib-01-intro-plotting-matplotlib_27_0.png" alt = "Adjust the ticklabels on the x-axis and create a scatterplot.">
<figcaption>Adjust the ticklabels on the x-axis and create a scatterplot.</figcaption>

</figure>




{:.input}
```python
# Define plot space
fig, ax = plt.subplots(figsize=(10, 6))

# Define x and y axes
ax.scatter(months, 
        boulder_monthly_precip,
        marker = ",",
        color = "k")

# Set plot title and axes labels
ax.set(title = "Average Monthly Precipitation\nBoulder, CO",
       xlabel = "Month",
       ylabel = "Precipitation\n(inches)");
```

{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}/images/courses/plot-data-in-python/01-plot-with-matplotlib/intro-to-plotting-matplotlib/2019-09-11-plot-with-matplotlib-01-intro-plotting-matplotlib/2019-09-11-plot-with-matplotlib-01-intro-plotting-matplotlib_28_0.png">

</figure>




{:.input}
```python
# Define plot space
fig, ax = plt.subplots(figsize=(10, 6))

# Define x and y axes
ax.bar(months, 
        boulder_monthly_precip,
        color = "darkblue")

# Set plot title and axes labels
ax.set(title = "Average Monthly Precipitation\nBoulder, CO",
       xlabel = "Month",
       ylabel = "Precipitation\n(inches)");
```

{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}/images/courses/plot-data-in-python/01-plot-with-matplotlib/intro-to-plotting-matplotlib/2019-09-11-plot-with-matplotlib-01-intro-plotting-matplotlib/2019-09-11-plot-with-matplotlib-01-intro-plotting-matplotlib_29_0.png">

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
       color = "darkblue", 
       alpha = 0.3)

# Set plot title and axes labels
ax.set(title = "Average Monthly Precipitation\nBoulder, CO",
       xlabel = "Month",
       ylabel = "Precipitation\n(inches)");
```

{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}/images/courses/plot-data-in-python/01-plot-with-matplotlib/intro-to-plotting-matplotlib/2019-09-11-plot-with-matplotlib-01-intro-plotting-matplotlib/2019-09-11-plot-with-matplotlib-01-intro-plotting-matplotlib_31_0.png" alt = "Adjust the alpha value to add transparency to your points.">
<figcaption>Adjust the alpha value to add transparency to your points.</figcaption>

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
       color = "cyan", 
       edgecolor = "darkblue")

# Set plot title and axes labels
ax.set(title = "Average Monthly Precipitation\nBoulder, CO",
       xlabel = "Month",
       ylabel = "Precipitation\n(inches)");
```

{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}/images/courses/plot-data-in-python/01-plot-with-matplotlib/intro-to-plotting-matplotlib/2019-09-11-plot-with-matplotlib-01-intro-plotting-matplotlib/2019-09-11-plot-with-matplotlib-01-intro-plotting-matplotlib_33_0.png" alt = "Just like you could adjust point colors you can adjust the bar fill and edge colors.">
<figcaption>Just like you could adjust point colors you can adjust the bar fill and edge colors.</figcaption>

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
        cmap = "YlGnBu")

# Set plot title and axes labels
ax.set(title = "Average Monthly Precipitation\nBoulder, CO",
       xlabel = "Month",
       ylabel = "Precipitation\n(inches)");
```

{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}/images/courses/plot-data-in-python/01-plot-with-matplotlib/intro-to-plotting-matplotlib/2019-09-11-plot-with-matplotlib-01-intro-plotting-matplotlib/2019-09-11-plot-with-matplotlib-01-intro-plotting-matplotlib_35_0.png">

</figure>




## Use Matplotlib Styles or Themes

**Matplotlib** also has a set of predefined color palettes that you can apply to a plot. To view a list of available styles, use:

`plt.style.use()` 

{:.input}
```python
# view all styles
print(plt.style.available)
```

{:.output}
    ['seaborn-poster', 'fivethirtyeight', 'bmh', 'seaborn-colorblind', 'seaborn-bright', 'seaborn-dark', 'seaborn-whitegrid', 'seaborn-ticks', 'seaborn-darkgrid', 'seaborn', 'fast', 'seaborn-dark-palette', 'seaborn-deep', 'seaborn-white', 'seaborn-talk', 'seaborn-muted', 'seaborn-notebook', 'Solarize_Light2', '_classic_test', 'seaborn-pastel', 'dark_background', 'grayscale', 'ggplot', 'classic', 'tableau-colorblind10', 'seaborn-paper']



{:.input}
```python
# Define matplotlib style
plt.style.use('seaborn-darkgrid')

# Define plot space
fig, ax = plt.subplots(figsize=(10, 6))

# Define x and y axes
ax.bar(months, 
       boulder_monthly_precip,
       color = "cyan", 
       edgecolor = "darkblue")

# Set plot title and axes labels
ax.set(title = "Average Monthly Precipitation\nBoulder, CO",
       xlabel = "Month",
       ylabel = "Precipitation\n(inches)");
```

{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}/images/courses/plot-data-in-python/01-plot-with-matplotlib/intro-to-plotting-matplotlib/2019-09-11-plot-with-matplotlib-01-intro-plotting-matplotlib/2019-09-11-plot-with-matplotlib-01-intro-plotting-matplotlib_38_0.png" alt = "There are many styles that you can apply to make your plots look nicer and uniform. Here a style is called within the plot code. This style will only be applied to this plot.">
<figcaption>There are many styles that you can apply to make your plots look nicer and uniform. Here a style is called within the plot code. This style will only be applied to this plot.</figcaption>

</figure>




<div class="notice--info" markdown="1">

## Additional Resources

* Additional information about [color bars](http://joseph-long.com/writing/colorbars/) 
* An [in-depth guide to matplotlib](https://realpython.com/blog/python/python-matplotlib-guide/?utm_campaign=Data%2BElixir&utm_medium=email&utm_source=Data_Elixir_172)

</div>

