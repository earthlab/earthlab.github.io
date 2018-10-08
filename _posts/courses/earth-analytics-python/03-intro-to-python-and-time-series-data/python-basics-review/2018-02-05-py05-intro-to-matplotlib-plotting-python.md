---
layout: single
title: "Customize matplotlib plots in Python - earth analytics - data science for scientists"
excerpt: 'Matplotlib is one of the most commonly used plotting library in Python. This lesson covers how to create a plot using matplotlib and how to customize matplotlib plot colors and label axes in Python.'
authors: ['Chris Holdgraf', 'Leah Wasser', 'Martha Morrissey']
modified: 2018-10-08
category: [courses]
class-lesson: ['get-to-know-python']
course: 'earth-analytics-python'
nav-title: 'Matplotlib plotting'
permalink: /courses/earth-analytics-python/use-time-series-data-in-python/plot-with-matplotlib-python/
module-type: 'class'
class-order: 1
week: 3
sidebar:
  nav:
author_profile: false
comments: true
order: 5
topics:
  reproducible-science-and-programming: ['python']
  data-exploration-and-analysis: ['data-visualization']
---

{% include toc title="In This Lesson" icon="file-text" %}

In this tutorial, you will explore more advanced plotting techniques using `matplotlib`.

<div class='notice--success' markdown="1">

## <i class="fa fa-graduation-cap" aria-hidden="true"></i> Learning Objectives

At the end of this activity, you will be able to:

* Use the `matplotlib` plot function to create custom plots.
* Add labels to x and y axes and a title to your matplotlib plot.
* Customize the colors and look of a matplotlib plot.

## <i class="fa fa-check-square-o fa-2" aria-hidden="true"></i> What You Need

You need `Python 3.x` and `Jupyter notebooks` to complete this tutorial. Also you should have an `earth-analytics` directory setup on your computer with a `/data` directory with it.

{% include/data_subsets/course_earth_analytics/_data-colorado-flood.md %}

</div>

## Important - Data Organization
Before you begin this lesson series, be sure that you’ve downloaded the data for this week of the course. After you download the data, unzip it and make sure that is in your `earth-analytics/data/colorado-flood/` directory on your computer. Your directory should look like the image below: note that all of the data are within the week-02 directory. They are not nested within another directory.

<figure>
<a href="{{ site.url }}/images/courses/earth-analytics/co-flood-lessons/week-02-data.jpg">
<img src="{{ site.url }}/images/courses/earth-analytics/co-flood-lessons/week-02-data.jpg" alt="week 2 file organization">
</a>
<figcaption>Your `week_02` file directory should look like the one above. Note that
the data directly under the week_02 folder.</figcaption>
</figure>

In your week 1 homework, you used the pandas plot function to plot your data. In this tutorial, you'll explore more advanced plotting techniques using matplotlib.

First, explore the code below to that was used to download the data and then create a quick pandas plot.

### Be sure to set your working directory

`os.chdir("path-to-you-dir-here/earth-analytics/data")`

{:.input}
```python
# import required python packages
import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
from matplotlib.dates import DateFormatter
import os
import urllib
plt.ion()
import earthpy as et
os.chdir(os.path.join(et.io.HOME, 'earth-analytics'))

# set parameters so all plots are consistent
plt.rcParams['figure.figsize'] = (8, 8)
plt.rcParams['axes.titlesize'] = 20
#plt.rcParams['axes.facecolor']='white'
#plt.rcParams['grid.color'] = 'grey'
#plt.rcParams['grid.linestyle'] = '-'
#plt.rcParams['grid.linewidth'] = '.5'
plt.rcParams['lines.color'] = 'purple'
#plt.rcParams['axes.grid'] = True
```

In the previous lessons you downloaded and imported data from [figshare](https://figshare.com/authors/_/3386570) into Python using the following code.

{:.input}
```python
# download file from Earth Lab figshare repository
urllib.request.urlretrieve(url='https://ndownloader.figshare.com/files/7010681', 
                           filename= 'data/colorado-flood/boulder-precip.csv')

# is parse dates a function argument that recoganizes dates  
boulder_precip = pd.read_csv('data/colorado-flood/downloads/boulder-precip.csv', 
                             index_col=['DATE'], 
                             parse_dates=['DATE'])

# view first few rows of data
boulder_precip.head()
```

{:.output}
{:.execute_result}



<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>Unnamed: 0</th>
      <th>PRECIP</th>
    </tr>
    <tr>
      <th>DATE</th>
      <th></th>
      <th></th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>2013-08-21</th>
      <td>756</td>
      <td>0.1</td>
    </tr>
    <tr>
      <th>2013-08-26</th>
      <td>757</td>
      <td>0.1</td>
    </tr>
    <tr>
      <th>2013-08-27</th>
      <td>758</td>
      <td>0.1</td>
    </tr>
    <tr>
      <th>2013-09-01</th>
      <td>759</td>
      <td>0.0</td>
    </tr>
    <tr>
      <th>2013-09-09</th>
      <td>760</td>
      <td>0.1</td>
    </tr>
  </tbody>
</table>
</div>





Then the data was plotted using the pandas function, `.plot()`.

{:.input}
```python
# plot using pandas .plot()
boulder_precip.plot('DATE', 'PRECIP');
```

{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}//images/courses/earth-analytics-python/03-intro-to-python-and-time-series-data/python-basics-review/2018-02-05-py05-intro-to-matplotlib-plotting-python_7_0.png" alt = "Basic matplotlib plot with dates on the x axis using .plot().">
<figcaption>Basic matplotlib plot with dates on the x axis using .plot().</figcaption>

</figure>




## Plot with matplotlib

`Matplotlib` is a plotting package that makes it simple to create complex plots
from data in a data.frame. It uses default settings, which help to create
publication quality plots with a minimal amount of settings and tweaking.
`Matplotlib` graphics are built step by step by adding new elements.

To build a matplotlib plot you need to:

1. define the axes 

{:.input}
```python
# set plot formatting for all plots in the notebook
plt.rcParams['figure.figsize'] = (8, 8)
plt.rcParams['axes.titlesize'] = 20
#plt.rcParams['axes.facecolor']='white'
#plt.rcParams['grid.color'] = 'grey'
#plt.rcParams['grid.linestyle'] = '-'
#plt.rcParams['grid.linewidth'] = '.5'
#plt.rcParams['axes.grid'] = True
```

{:.input}
```python
# first create the plot space upon which to plot the data
fig, ax = plt.subplots()
```

{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}//images/courses/earth-analytics-python/03-intro-to-python-and-time-series-data/python-basics-review/2018-02-05-py05-intro-to-matplotlib-plotting-python_10_0.png" alt = "When you create a figure object you are creating a blank canvas to place a plot on.">
<figcaption>When you create a figure object you are creating a blank canvas to place a plot on.</figcaption>

</figure>




2. Define the plot elements including the x and y variables and the data to be used

`ax.plot(boulder_precip['DATE'], boulder_precip)['PRECIP'])`




{:.input}
```python
fig, ax = plt.subplots()
ax.plot(boulder_precip['DATE'], 
        boulder_precip['PRECIP'], 
        color = 'purple');
```

{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}//images/courses/earth-analytics-python/03-intro-to-python-and-time-series-data/python-basics-review/2018-02-05-py05-intro-to-matplotlib-plotting-python_12_0.png" alt = "Once you add a call to plot using ax.plot - your  blank canvas has a plot on it.">
<figcaption>Once you add a call to plot using ax.plot - your  blank canvas has a plot on it.</figcaption>

</figure>




Then finally you can refine your plot adding labels and other elements. 

{:.input}
```python
# define figure
fig, ax = plt.subplots()
# Define data and x and y axes
ax.plot(boulder_precip['DATE'], boulder_precip['PRECIP'])
# set plot title
ax.set(title="matplotlib example plot precip")
plt.setp(ax.get_xticklabels(), rotation=45);
```

{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}//images/courses/earth-analytics-python/03-intro-to-python-and-time-series-data/python-basics-review/2018-02-05-py05-intro-to-matplotlib-plotting-python_14_0.png" alt = "You can customize your plot adding and adjust ticks and titles.">
<figcaption>You can customize your plot adding and adjust ticks and titles.</figcaption>

</figure>





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
fig, ax = plt.subplots()
ax.plot(boulder_precip['DATE'], boulder_precip['PRECIP'], '-o')
ax.set(title="matplotlib example plot precip")
plt.setp(ax.get_xticklabels(), rotation=45);
```

{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}//images/courses/earth-analytics-python/03-intro-to-python-and-time-series-data/python-basics-review/2018-02-05-py05-intro-to-matplotlib-plotting-python_16_0.png" alt = "Here you adjust the point markers used in your plot.">
<figcaption>Here you adjust the point markers used in your plot.</figcaption>

</figure>




{:.input}
```python
# subset your data
# dates_subset = boulder_precip['2013-09-27':'2013-10-11']
# dates_subset.head()
```

<i class="fa fa-star"></i> **Data Tip:**
If the data you want to plot is the index of the `DataFrame` you can access it with `DataFramename.index`
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
fig, ax = plt.subplots()
ax.scatter(boulder_precip.index.values,
           boulder_precip['PRECIP'].values,
           c='blue')
plt.setp(ax.get_xticklabels(), rotation=45)
plt.show()
```

{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}//images/courses/earth-analytics-python/03-intro-to-python-and-time-series-data/python-basics-review/2018-02-05-py05-intro-to-matplotlib-plotting-python_20_0.png" alt = "Adjust the ticklabels on the x-axis and create a scatterplot.">
<figcaption>Adjust the ticklabels on the x-axis and create a scatterplot.</figcaption>

</figure>




You can adjust the transparency using the `alpha=` argument.

{:.input}
```python
fig, ax = plt.subplots()
ax.scatter(boulder_precip.index.values, 
           boulder_precip['PRECIP'].values,
           c='blue', alpha=.5)
plt.setp(ax.get_xticklabels(), rotation=45);
```

{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}//images/courses/earth-analytics-python/03-intro-to-python-and-time-series-data/python-basics-review/2018-02-05-py05-intro-to-matplotlib-plotting-python_22_0.png" alt = "Adjust the alpha value to add transparency to your points.">
<figcaption>Adjust the alpha value to add transparency to your points.</figcaption>

</figure>




You can also assign each point a color based upon it's data value by

assigning `c=` to the values in the data.
`c=boulder_precip['PRECIP'].values`

and then specifying colors using the `cmap=` argument.
`cmap='rainbow'`

{:.input}
```python
# setup figure
fig, ax = plt.subplots()
# create scatterplot
ax.scatter(boulder_precip.index.values, 
           boulder_precip['PRECIP'].values,
           c=boulder_precip['PRECIP'].values, 
           alpha=.5, cmap='rainbow')
# adjust x axis labels
plt.setp(ax.get_xticklabels(), rotation=45);
```

{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}//images/courses/earth-analytics-python/03-intro-to-python-and-time-series-data/python-basics-review/2018-02-05-py05-intro-to-matplotlib-plotting-python_24_0.png" alt = "Color points according to an attribute value.">
<figcaption>Color points according to an attribute value.</figcaption>

</figure>




### Create Bar Plots with Matplotlib 

You can turn your plot into a bar plot using `ax.bar()`.


{:.input}
```python
fig, ax = plt.subplots()
ax.bar(boulder_precip['DATE'].values, boulder_precip['PRECIP'].values)
plt.setp(ax.get_xticklabels(), rotation=45);
```

{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}//images/courses/earth-analytics-python/03-intro-to-python-and-time-series-data/python-basics-review/2018-02-05-py05-intro-to-matplotlib-plotting-python_26_0.png" alt = "When you create a bar plot you need to call .values on your data.">
<figcaption>When you create a bar plot you need to call .values on your data.</figcaption>

</figure>






Turn the bar outlines blue




{:.input}
```python
fig, ax = plt.subplots()
ax.bar(boulder_precip.index.values, 
       boulder_precip['PRECIP'].values,
       edgecolor='blue')
plt.setp(ax.get_xticklabels(), rotation=45);
```

{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}//images/courses/earth-analytics-python/03-intro-to-python-and-time-series-data/python-basics-review/2018-02-05-py05-intro-to-matplotlib-plotting-python_28_0.png" alt = "Just like you could adjust point colors you can adjust the bar fill and edge colors.">
<figcaption>Just like you could adjust point colors you can adjust the bar fill and edge colors.</figcaption>

</figure>






Change the fill to bright green.




{:.input}
```python
fig, ax = plt.subplots()
ax.bar(boulder_precip['DATE'].values, boulder_precip['PRECIP'].values,
       edgecolor='blue', color='green')
plt.setp(ax.get_xticklabels(), rotation=45);
```

{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}//images/courses/earth-analytics-python/03-intro-to-python-and-time-series-data/python-basics-review/2018-02-05-py05-intro-to-matplotlib-plotting-python_30_0.png" alt = "Here the bar color is set to green and the edge color is blue.">
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
    ['_classic_test', 'bmh', 'classic', 'dark_background', 'fast', 'fivethirtyeight', 'ggplot', 'grayscale', 'seaborn-bright', 'seaborn-colorblind', 'seaborn-dark-palette', 'seaborn-dark', 'seaborn-darkgrid', 'seaborn-deep', 'seaborn-muted', 'seaborn-notebook', 'seaborn-paper', 'seaborn-pastel', 'seaborn-poster', 'seaborn-talk', 'seaborn-ticks', 'seaborn-white', 'seaborn-whitegrid', 'seaborn', 'Solarize_Light2', 'tableau-colorblind10']



{:.input}
```python
fig, ax = plt.subplots()
ax.bar(boulder_precip['DATE'].values, boulder_precip['PRECIP'].values)
plt.setp(ax.get_xticklabels(), rotation=45);
plt.style.use('fivethirtyeight')
plt.show()
```

{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}//images/courses/earth-analytics-python/03-intro-to-python-and-time-series-data/python-basics-review/2018-02-05-py05-intro-to-matplotlib-plotting-python_33_0.png" alt = "There are many styles that you can apply to make your plots look nicer and uniform. Here a style is called within the plot code. This style will only be applied to this plot.">
<figcaption>There are many styles that you can apply to make your plots look nicer and uniform. Here a style is called within the plot code. This style will only be applied to this plot.</figcaption>

</figure>




## Add Plot Labels

You can add labels to your plots as well. Let's add a title, and x and y labels using the `xlabel` and `ylabel` arguments within the `ax.set()` function.

{:.input}
```python
fig, ax = plt.subplots()
ax.bar(boulder_precip['DATE'].values, 
       boulder_precip['PRECIP'].values,
       edgecolor='blue')
plt.setp(ax.get_xticklabels(), rotation=45);
ax.set(xlabel="Date", ylabel="Precipitation (Inches)")
ax.set(title="Daily Precipitation (inches)\nBoulder, Colorado 2013");
```

{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}//images/courses/earth-analytics-python/03-intro-to-python-and-time-series-data/python-basics-review/2018-02-05-py05-intro-to-matplotlib-plotting-python_35_0.png" alt = "You can label your x and y axes as well.">
<figcaption>You can label your x and y axes as well.</figcaption>

</figure>




### Set Graph formatting for an Entire Notebook: 

If you know that you want all of your graphs to have a white background, be a specific figure size and have titles, and labels the same font size the `plt.rcParams` function will save you some typing! This function allows you to set graph formatting for an entire notebook if it's placed at the beginning. 

`plt.rcParams['figure.figsize'] = (8, 8)
plt.rcParams['axes.titlesize'] = 20
plt.rcParams['axes.facecolor']='white'`


`figure.figuresize` sets the size of the figure  
`axis.titlesize` sets the title font size 
`axes.facecolor` sets the figure background color.


For a complete list of what you can pre-set using `plt.rcParams` check out the [documentation](https://matplotlib.org/api/matplotlib_configuration_api.html#matplotlib.RcParams)


<div class="notice--info" markdown="1">

## Additional Resources

Here are some additional `matplotlib` [examples](https://matplotlib.org/examples/pylab_examples/subplots_demo.html) and information about [color bars](http://joseph-long.com/writing/colorbars/). Here is an [in-depth guide](https://realpython.com/blog/python/python-matplotlib-guide/?utm_campaign=Data%2BElixir&utm_medium=email&utm_source=Data_Elixir_172) to `matplotlib` that will be useful for you to refer back to. 


</div>
