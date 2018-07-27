---
layout: single
title: "Work With Date - Time formats in Python - Time Series Data "
excerpt: "This lesson covers how to deal with dates in Python. It reviews how to apply the as.Date() function to a column containing date or data-time data. This function converts a field containing dates in a standard format, to a date class that R can understand and plot efficiently."
authors: ['Chris Holdgraf', 'Leah Wasser', 'Martha Morrissey']
modified: 2018-07-27
category: [courses]
class-lesson: ['time-series-python']
course: 'earth-analytics-python'
permalink: /courses/earth-analytics-python/use-time-series-data-in-python/date-class-in-python/
nav-title: 'Dates in Python'
week: 2
sidebar:
  nav:
author_profile: false
comments: true
order: 2
topics:
  reproducible-science-and-programming: ['JupyterNotebook']
  time-series:
  data-exploration-and-analysis: ['data-visualization']
---
{% include toc title="In This Lesson" icon="file-text" %}


## Get started with date formats in Python

In this tutorial, you will look at the date time format - which is important for plotting and working with time series data in Python.


<div class='notice--success' markdown="1">

## <i class="fa fa-graduation-cap" aria-hidden="true"></i> Learning Objectives

At the end of this activity, you will be able to:

* Convert column in a `DataFrame` containing dates / times to a date/time object that can be used in Python.
* Be able to describe how you can use the 'date' class to create easier to read time series plots in `Python`.


## <i class="fa fa-check-square-o fa-2" aria-hidden="true"></i> What You Need

You need `Python 3.x` and `Jupyter notebooks` to complete this tutorial. Also you should have
an `earth-analytics` directory setup on your computer with a `/data`
directory with it.

* [Setup Conda](/courses/earth-analytics-python/get-started-with-python-jupyter/setup-conda-earth-analytics-environment/)
* [Setup your working directory](/courses/earth-analytics-python/get-started-with-python-jupyter/introduction-to-bash-shell/)
* [Intro to Jupyter Notebooks](/courses/earth-analytics-python/python-open-science-tool-box/intro-to-jupyter-notebooks/)


</div>

In this tutorial, you will learn how to convert data that contain dates and times into a date / time format in `Python`. To begin, let's revisit the boulder precip data that you've been working with in this module.

### Be sure to set your working directory

`os.chdir("path-to-you-dir-here/earth-analytics/data")`

{:.input}
```python
import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
import os
plt.ion()
```

## Plot using matplotlib

You can use matplotlib plotting to further customize your plots, so let's use that instead of using the `pandas` function `plot()`. 

{:.input}
```python
plt.rcParams['figure.figsize'] = (8, 8)
plt.rcParams['axes.titlesize'] = 20
plt.rcParams['axes.facecolor']='white'
plt.rcParams['grid.color'] = 'grey'
plt.rcParams['grid.linestyle'] = '-'
plt.rcParams['grid.linewidth'] = '.5'
plt.rcParams['lines.color'] = 'purple'
plt.rcParams['axes.grid'] = True
```

{:.input}
```python
boulder_precip = pd.read_csv('data/colorado-flood/boulder-precip.csv')
```

{:.input}
```python
boulder_precip.dtypes
```

{:.output}
{:.execute_result}



    Unnamed: 0      int64
    DATE           object
    PRECIP        float64
    dtype: object





{:.input}
```python
type(boulder_precip['DATE'][0])
```

{:.output}
{:.execute_result}



    str





{:.input}
```python
fig, ax= plt.subplots()
ax.plot(boulder_precip['DATE'], boulder_precip['PRECIP'], color = 'purple')
plt.setp(ax.get_xticklabels(), rotation=45)
ax.set(xlabel="Date",
       ylabel="Total Precipitation (Inches)",
       title="Precipitation Data\nBoulder, Colorado 2013");
```

{:.output}
{:.display_data}

![png]({{ site.url }}//images/courses/earth-analytics-python/02-intro-to-python-and-time-series-data/plot-time-series-handle-dates/2018-02-05-flood02-date-format-python_9_0.png)




You can plot the data however you didn't explictly tell pandas to ensure that the data in the DATE column is a datetime object. Look closely at the dates on the x-axis. they may look ok but upon closer examination, they are not spaced properly as they are being read in as strings. 

You will learn how to ensure the `DATE` is a datetime object in python, next.

Looking at the structure of your data, you see that the DATE field is of type `object`. However ideally you want `Python` to read this column as a date so you can work with it as a chronological element rather than a string or some other format.

## Python Data types 

The structure results above tell us that the data columns in your `DataFrame` are stored as several different data types or `classes` as follows:

* **int64 - Character:** 64 bit integer. This is a numeric value that will never contain decimal points.
* **object:** A string, characters that are in quotes. 
* **float64 - 64 bit float:**  This data type accepts data that are a wide variety of numeric formats
including decimals (floating point values) and integers. Numeric also accept larger numbers than **int** will.

### Data frame columns can only contain one data class

A `DataFrame` column can only store on type. This means that a column can not store both numbers and strings. If a column contains a list of numbers and one letter, then every value in that column will be stored as a string. 

Storing
variables using different `types` is a strategic decision by `Python` (and
other programming languages) that optimizes processing and storage. It allows:

* data to be processed more quickly & efficiently.
* the program (`Python`) to minimize the storage size.

Remember, that you learned about `Python` data types during class in this lessons: [data types](/courses/earth-analytics-python/use-time-series-data-in-python/work-with-data-types-python/)

Thus, when you plot, `Python` gets stuck trying to plot the DATE field. Each value is read as a string and it's difficult to try to fit all of those values on the x axis efficiently. You can avoid this problem by explicetly importing your data using a dates argument as follows:

`parse_dates=['columnNameWithDatesHere']`

Let's give it a try

{:.input}
```python
boulder_precip = pd.read_csv('data/boulder-precip.csv',
                             parse_dates=['DATE'])
boulder_precip.dtypes
```

{:.output}
{:.execute_result}



    Unnamed: 0             int64
    DATE          datetime64[ns]
    PRECIP               float64
    dtype: object





This looks much better. now the DATE column is of type: `datetime64`.
Let's try to plot again.

{:.input}
```python
fig, ax= plt.subplots()
ax.plot(boulder_precip['DATE'], boulder_precip['PRECIP'], color = 'purple')
plt.setp(ax.get_xticklabels(), rotation=45)
ax.set(xlabel="Date",
       ylabel="Total Precipitation (Inches)",
       title="Precipitation Data\nBoulder, Colorado 2013");
```

{:.output}
{:.display_data}

![png]({{ site.url }}//images/courses/earth-analytics-python/02-intro-to-python-and-time-series-data/plot-time-series-handle-dates/2018-02-05-flood02-date-format-python_15_0.png)




Notice that now your x-axis date values are easier to read as Python 
knows how to only show incremental values rather than each and every date value. You can plot your data as a barplot too.

<div class="notice--success" markdown="1">

### <i class="fa fa-star"></i> Dates and Plotting

When using `bar()` or `scatter()` to produce plots with `matplotlib`, you will get an error if you pass a pandas dataframe column of 'Timestamps' objects directly into the function. This is because when plotting with these methods, 'Numpy' tries to concatenate the array that has been passed in for 'x' and the array that has been passed in for 'y'. However, 'Numpy' is unable to concatenate series containing 'Timestamps'. To avoid this error, you can convert the pandas series of Timestamps into a Numpy array of `datetime64` objects. You can achieve this by calling '.values' on a pandas series. Below is an example of the error you will get if you don't use '.values' in this situation. You will also notice that '.values' is not needed when passing in a column that contains 'float' objects rather than 'datetime64' objects.

</div>

```
# this will return an error
fig, ax= plt.subplots()
ax.bar(boulder_precip['DATE'], 
       boulder_precip['PRECIP'], 
       color = 'purple')
plt.setp(ax.get_xticklabels(), rotation=45)
ax.set(xlabel="Date",
       ylabel="Total Precipitation (Inches)",
       title="Precipitation Data\nBoulder, Colorado 2013");
```

{:.input}
```python
fig, ax= plt.subplots()
ax.bar(boulder_precip['DATE'].values, boulder_precip['PRECIP'].values, color = 'purple')
plt.setp(ax.get_xticklabels(), rotation=45)
ax.set(xlabel="Date",
       ylabel="Total Precipitation (Inches)",
       title="Precipitation Data\nBoulder, Colorado 2013");
```

{:.output}
{:.display_data}

![png]({{ site.url }}//images/courses/earth-analytics-python/02-intro-to-python-and-time-series-data/plot-time-series-handle-dates/2018-02-05-flood02-date-format-python_19_0.png)



