---
layout: single
title: "Work With Date - Time formats in Python - Time Series Data "
excerpt: "This lesson covers how to deal with dates in Python. It reviews how to apply the as.Date() function to a column containing date or data-time data. This function converts a field containing dates in a standard format, to a date class that R can understand and plot efficiently."
authors: ['Chris Holdgraf', 'Leah Wasser', 'Martha Morrissey']
modified: 2018-09-04
category: [courses]
class-lesson: ['time-series-python']
course: 'earth-analytics-python'
permalink: /courses/earth-analytics-python/use-time-series-data-in-python/date-class-in-python/
module-description: 'This lesson series covers working with time series data in Python. You will learn how to handle  date fields in Python to create custom plots of time series data using matplotlib. '
module-nav-title: 'Time Series Data in Python'
module-title: 'Work with Time Series Data From Sensor Networks in Python'
module-type: 'class'
nav-title: 'Dates in Python'
week: 3
sidebar:
  nav:
author_profile: false
comments: true
class-order: 1
order: 1
topics:
  reproducible-science-and-programming: ['jupyter-notebooks', 'python']
  time-series:
  data-exploration-and-analysis: ['data-visualization']
---
{% include toc title="In This Lesson" icon="file-text" %}


## Work With Date Formats in Python

In this tutorial, you will use the date time format - which is important for plotting and working with time series data in `Python`.

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

{% include/data_subsets/course_earth_analytics/_data-colorado-flood.md %}

</div>

Dates can be tricky in any programming language. While you may see a date and recognize it as something that can be quantified and related to time, a computer reads in numbers and characters and often by default brings in a date as a string (a set of characters) rather than something that has an order in time. 

In this lesson you will learn how to begin to handle dates in Python using Pandas. 
To begin, open up the `boulder-precip.csv` file that you used in the homework for week one.  

{:.input}
```python
# import libraries
import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
import os
plt.ion()
# set working directory if you are working locally on your laptop.
# os.chdir("path-to-you-dir-here/earth-analytics/data")
```

Next, open the `data/colorado-flood/precipitation/805325-precip-dailysum-2003-2013.csv` data using pandas. 

{:.input}
```python
boulder_precip = pd.read_csv('data/colorado-flood/downloads/boulder-precip.csv')
# view data frame structure
boulder_precip.dtypes
```

{:.output}
{:.execute_result}



    Unnamed: 0      int64
    DATE           object
    PRECIP        float64
    dtype: object





## Python Data Types 

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


### But What is an Object?
Objects in Python can be a set of different types of things including:

1. lists
2. strings
3. dictionaries and more

Look closely at the date column to see the type or class of information that it contains.

{:.input}
```python
type(boulder_precip['DATE'][0])
```

{:.output}
{:.execute_result}



    str





Notice that this is a date field - yet it's classified as of type `str` or string by Python. 
A string represents a sequence of values (letters and numbers). You can not perform any math on a string object!
Next, plot the data. 

{:.input}
```python
fig, ax= plt.subplots()
ax.plot(boulder_precip['DATE'], 
        boulder_precip['PRECIP'], 
        color = 'purple')
plt.setp(ax.get_xticklabels(), rotation=45)
ax.set(xlabel="Date",
       ylabel="Total Precipitation (Inches)",
       title="Precipitation Data\nBoulder, Colorado 2013");
```

{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}//images/courses/earth-analytics-python/03-intro-to-python-and-time-series-data/plot-time-series-handle-dates/2018-02-05-ts01-date-format-python_8_0.png">

</figure>




You can plot the data however you didn't explictly tell pandas to ensure that the data in the DATE column is a datetime object. Look closely at the dates on the x-axis. The dates may look ok at first glance, but upon closer examination, they are not spaced properly as they are being read in as strings.

Example - look at the spacing between the data for september 1 and september 9. Notice the points are spaced equally on the x axis compared to the points for september 10 and 11!  

When you plot a string field, `Python` gets stuck trying to plot the DATE field. Each value is read as a string and it's difficult to try to fit all of those values on the x axis efficiently. You can avoid this problem by explicetly importing your data using a dates argument as follows:

`parse_dates=['columnNameWithDatesHere']`

Give it a try.


{:.input}
```python
boulder_precip = pd.read_csv('data/colorado-flood/downloads/boulder-precip.csv',
                             parse_dates=['DATE'])
boulder_precip.dtypes
```

{:.output}
{:.execute_result}



    Unnamed: 0             int64
    DATE          datetime64[ns]
    PRECIP               float64
    dtype: object





Now the DATE column is of type: `datetime64`.
Try to plot again. Notice the spacing on the x-axis looks better. Notice that now your x-axis date values are easier to read as Python 
knows how to only show incremental values rather than each and every date value. 

{:.input}
```python
fig, ax= plt.subplots(figsize = (8,8))
ax.plot(boulder_precip['DATE'], boulder_precip['PRECIP'], color = 'purple')
plt.setp(ax.get_xticklabels(), rotation=45)
ax.set(xlabel="Date",
       ylabel="Total Precipitation (Inches)",
       title="Precipitation Data\nBoulder, Colorado 2013");
```

{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}//images/courses/earth-analytics-python/03-intro-to-python-and-time-series-data/plot-time-series-handle-dates/2018-02-05-ts01-date-format-python_12_0.png">

</figure>




{:.input}
```python
# bar plot with pandas
fig, ax= plt.subplots(figsize = (8,8))
boulder_precip.plot.bar(x='DATE', y='PRECIP', 
                         rot=45, 
                         ax=ax, 
                         color = 'purple',
                         title = "Pandas Bar Plot of Precipitation Data");
```

{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}//images/courses/earth-analytics-python/03-intro-to-python-and-time-series-data/plot-time-series-handle-dates/2018-02-05-ts01-date-format-python_13_0.png">

</figure>




## Bar Plots of Time Series Data Using Matplotlib

You can plot your data as a barplot too. When using `bar()` or `scatter()` to produce plots with `matplotlib`, you will get an error if you pass a pandas dataframe column of `Timestamps` objects directly into the plot function. This is because when plotting with these methods, `Numpy` tries to concatenate (a fancy word for combine) the array that has been passed in for `x` and the array that has been passed in for `y`. `Numpy` can't concatenate the `Timestamps` format with values. 

To avoid this error, you convert the pandas series of Timestamps into a `datetime64` format by calling `.values` on the data. Below is an example of the error you will get if you don't use `.values`. 

NOTE: `.values` is not needed when passing in a column that contains `float` objects rather than `datetime64` objects.

{:.input}
```python
boulder_precip.dtypes
```

{:.output}
{:.execute_result}



    Unnamed: 0             int64
    DATE          datetime64[ns]
    PRECIP               float64
    dtype: object





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

The error returned:
```
---------------------------------------------------------------------------
TypeError                                 Traceback (most recent call last)
<ipython-input-13-9f350a681e2f> in <module>()
      3 ax.bar(boulder_precip['DATE'], 
      4        boulder_precip['PRECIP'],
----> 5        color = 'purple')
      6 plt.setp(ax.get_xticklabels(), rotation=45)
      7 ax.set(xlabel="Date",

~/anaconda3/lib/python3.6/site-packages/matplotlib/__init__.py in inner(ax, *args, **kwargs)
   1853                         "the Matplotlib list!)" % (label_namer, func.__name__),
   1854                         RuntimeWarning, stacklevel=2)
-> 1855             return func(ax, *args, **kwargs)
   1856 
   1857         inner.__doc__ = _add_data_doc(inner.__doc__,

~/anaconda3/lib/python3.6/site-packages/matplotlib/axes/_axes.py in bar(self, *args, **kwargs)
   2257         if align == 'center':
   2258             if orientation == 'vertical':
-> 2259                 left = x - width / 2
   2260                 bottom = y
   2261             elif orientation == 'horizontal':

TypeError: ufunc subtract cannot use operands with types dtype('<M8[ns]') and dtype('float64')
```


The code below produces a plot because `.values` is used on the x and y axis data.

{:.input}
```python
# this plotting code works as .values is called
fig, ax= plt.subplots(figsize = (8,8))
ax.bar(boulder_precip['DATE'].values, 
       boulder_precip['PRECIP'].values, 
       color = 'purple')
plt.setp(ax.get_xticklabels(), rotation=45)
ax.set(xlabel="Date",
       ylabel="Total Precipitation (Inches)",
       title="Precipitation Data\nBoulder, Colorado 2013");
```
