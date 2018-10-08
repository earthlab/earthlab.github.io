---
layout: single
title: "Work with tabular spreadsheet data in Python"
excerpt: "About."
authors: ['Data Carpentry', 'Leah Wasser']
category: [courses]
class-lesson: ['get-to-know-python']
course: "earth-analytics-python"
permalink: /courses/earth-analytics-python/use-time-series-data-in-python/spreadsheet-data-in-python/
nav-title: 'Spreadsheet Data in Python'
dateCreated: 2016-12-13
modified: 2018-10-08
week: 3
sidebar:
  nav:
author_profile: false
comments: true
order: 4
topics:
  reproducible-science-and-programming: ['python']
---

{% include toc title="In This Lesson" icon="file-text" %}

This lesson introduces the `data.frame` which is very similar to working with
a spreadsheet in `Python`.

<div class='notice--success' markdown="1">

## <i class="fa fa-graduation-cap" aria-hidden="true"></i> Learning Objectives
At the end of this activity, you will be able to:

* Open `.csv` or text file containing tabular (spreadsheet) formatted data in `Python`.
* Quickly plot the data using the Pandas function `.plot()`
* Quickly plot the data using Matplotlib plotting

## <i class="fa fa-check-square-o fa-2" aria-hidden="true"></i> What You Need

You need `Python 3.x` and `Jupyter notebooks` to complete this tutorial. Also you should have
an `earth-analytics` directory setup on your computer with a `/data`
directory with it.

{% include/data_subsets/course_earth_analytics/_data-colorado-flood.md %}

</div>

In the homework from week 1, you used the code below to create a report with in `Jupyter Notebooks`. 

{:.input}
```python
import numpy as np
import pandas as pd
import urllib
import os
from matplotlib import pyplot as plt

# Force notebooks to plot figures inline (in the notebook)
plt.ion()

# be sure to set your working directory using os.chdir() put your file path in the parenthesis 
```

### Be sure to set your working directory

`os.chdir("path-to-you-dir-here/earth-analytics/data")`

{:.input}
```python
# download data from figshare (note - we did this in a previous lesson)
urllib.request.urlretrieve(url='https://ndownloader.figshare.com/files/7010681', 
                           filename= 'data/boulder-precip.csv')
```

{:.output}
{:.execute_result}



    ('data/boulder-precip.csv', <http.client.HTTPMessage at 0x110028390>)





Remember that earlier in the lessons you learned that the code above  `urllib.request.urlretrieve()` is used to 
download a datafile. In this case, the data are stored on
<a href="http://www.figshare.com" target="_blank">Figshare</a> - a
popular data repository that is free to use if your data are cumulatively
smaller than 20gb.

Remember that `urllib.request.urlretrieve()` function has two function **ARGUMENTS**:

1. **url**: this is the path to the data file that you wish to download
2. **filename**: this is the location on your computer (in this case: `/data`) and name of the
file when saved (in this case: boulder-precip.csv). So you downloaded a file from
a url on figshare do your data directory. You named that file `boulder-precip.csv`.

Next, you read in the data using the function: `pd.read_csv()`.

{:.input}
```python
boulder_precip = pd.read_csv('data/colorado-flood/boulder-precip.csv')
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
      <th>DATE</th>
      <th>PRECIP</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>756</td>
      <td>2013-08-21</td>
      <td>0.1</td>
    </tr>
    <tr>
      <th>1</th>
      <td>757</td>
      <td>2013-08-26</td>
      <td>0.1</td>
    </tr>
    <tr>
      <th>2</th>
      <td>758</td>
      <td>2013-08-27</td>
      <td>0.1</td>
    </tr>
    <tr>
      <th>3</th>
      <td>759</td>
      <td>2013-09-01</td>
      <td>0.0</td>
    </tr>
    <tr>
      <th>4</th>
      <td>760</td>
      <td>2013-09-09</td>
      <td>0.1</td>
    </tr>
  </tbody>
</table>
</div>





{:.input}
```python
# view the structure of the data.frame 
boulder_precip.dtypes

```

{:.output}
{:.execute_result}



    Unnamed: 0      int64
    DATE           object
    PRECIP        float64
    dtype: object





<div class="notice--warning" markdown="1">

## <i class="fa fa-pencil-square-o" aria-hidden="true"></i> Optional challenge
What is the format associated with each column for the `boulder_precip`
data.frame? Describe the attributes of each format. Can you perform math
on each column? Why or why not?


<!--
integer - numbers without decimal points,
character: text strings
number: numeric values (can contain decimals places)
-->

</div>


## Introduction to the DataFrame

When you read data into Python using `pd.read_csv()` it imports it into a DataFrame format.
A DataFrame is a 2-dimensional data structure that can store data of different types (including characters, integers, floating point values and more) in columns. It is similar to a spreadsheet or an SQL database table. 

A dataframe is composed of columns and rows. Each column in a dataFrame object has the same number of rows.
Each cell in a dataframe is located or defined by a x,y (column, row) index value. 

Remember that in python, this index value begins at 0!  

A data frame can be created manually, however most commonly they are generated when
you important a text file or spreadsheet into Python using the Pandas function `pd.read_csv`.


## Extracting / Specifying "columns" By Name

You can extract one single column from a dataFrame using the syntax:

`data_frame_name['columnNameHere']`

as follows:


{:.input}
```python
# view the date column of the data frame using its name (or header)
boulder_precip['DATE']
```

{:.output}
{:.execute_result}



    0     2013-08-21
    1     2013-08-26
    2     2013-08-27
    3     2013-09-01
    4     2013-09-09
    5     2013-09-10
    6     2013-09-11
    7     2013-09-12
    8     2013-09-13
    9     2013-09-15
    10    2013-09-16
    11    2013-09-22
    12    2013-09-23
    13    2013-09-27
    14    2013-09-28
    15    2013-10-01
    16    2013-10-04
    17    2013-10-11
    Name: DATE, dtype: object





{:.input}
```python
# view the precip column
boulder_precip['PRECIP']
```

{:.output}
{:.execute_result}



    0     0.1
    1     0.1
    2     0.1
    3     0.0
    4     0.1
    5     1.0
    6     2.3
    7     9.8
    8     1.9
    9     1.4
    10    0.4
    11    0.1
    12    0.3
    13    0.3
    14    0.1
    15    0.0
    16    0.9
    17    0.1
    Name: PRECIP, dtype: float64





## View Structure of a Data Frame

You can explore the format of your data frame too. For instance, you can see how many rows and columns your dataframe has using the shape attribute. Here the shape of the object is returned as an array containing two numbers (# of rows, # of columns)

{:.input}
```python
# view the number of rows and columns in your dataframe
boulder_precip.shape
```

{:.output}
{:.execute_result}



    (18, 3)





{:.input}
```python
<div class="notice--warning" markdown="1">

## <i class="fa fa-pencil-square-o" aria-hidden="true"></i> ## Optional challenge

Using your DataFrame `boulder_precip`, try out the attributes & methods below to see what they return.

* boulder_precip.columns
* boulder_precip.shape 

Take note of the output of shape - what format does it return the shape of the DataFrame in? HINT: [More on tuples, here.](https://docs.python.org/3/tutorial/datastructures.html)

* `boulder_precip.head()` 
* What does `boulder_precip.head(15)` do?
* `boulder_precip.tail()`

</div>
```

{:.input}
```python
# view the data structure of the data frame
boulder_precip.dtypes
```

{:.output}
{:.execute_result}



    Unnamed: 0      int64
    DATE           object
    PRECIP        float64
    dtype: object





## Calculate dataframe statistics
You can quickly calculate summary statistics too. First let's explore the column names using `.columns.values`. You can use the `.describe()` function to get summary statistics about numeric columns in your data.


{:.input}
```python
# view column names
boulder_precip.columns.values
```

{:.output}
{:.execute_result}



    array(['Unnamed: 0', 'DATE', 'PRECIP'], dtype=object)





{:.input}
```python
# view summary statistics  - for all columns
boulder_precip.describe()
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
  </thead>
  <tbody>
    <tr>
      <th>count</th>
      <td>18.000000</td>
      <td>18.000000</td>
    </tr>
    <tr>
      <th>mean</th>
      <td>764.500000</td>
      <td>1.055556</td>
    </tr>
    <tr>
      <th>std</th>
      <td>5.338539</td>
      <td>2.288905</td>
    </tr>
    <tr>
      <th>min</th>
      <td>756.000000</td>
      <td>0.000000</td>
    </tr>
    <tr>
      <th>25%</th>
      <td>760.250000</td>
      <td>0.100000</td>
    </tr>
    <tr>
      <th>50%</th>
      <td>764.500000</td>
      <td>0.200000</td>
    </tr>
    <tr>
      <th>75%</th>
      <td>768.750000</td>
      <td>0.975000</td>
    </tr>
    <tr>
      <th>max</th>
      <td>773.000000</td>
      <td>9.800000</td>
    </tr>
  </tbody>
</table>
</div>





{:.input}
```python
# view summary statistics  - for just the precip column
boulder_precip['PRECIP'].describe()
```

{:.output}
{:.execute_result}



    count    18.000000
    mean      1.055556
    std       2.288905
    min       0.000000
    25%       0.100000
    50%       0.200000
    75%       0.975000
    max       9.800000
    Name: PRECIP, dtype: float64





{:.input}
```python
# view a list of just the unique precipitation values
pd.unique(boulder_precip['PRECIP'])
```

{:.output}
{:.execute_result}



    array([0.1, 0. , 1. , 2.3, 9.8, 1.9, 1.4, 0.4, 0.3, 0.9])





## Plot data
You can quickly plot your data too. Note that you are using the `.plot()` function, which comes from Pandas.

{:.input}
```python
# setup the plot
boulder_precip.plot('DATE', 'PRECIP', color = 'purple');
```

{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}//images/courses/earth-analytics-python/03-intro-to-python-and-time-series-data/python-basics-review/2018-02-05-py04-spreadsheet-data-python_21_0.png" alt = "If you call dataframe.plot() you are plotting using the pandas plot function. This function wraps around matplotlib.">
<figcaption>If you call dataframe.plot() you are plotting using the pandas plot function. This function wraps around matplotlib.</figcaption>

</figure>




{:.input}
```python
boulder_precip.plot.bar('DATE', 'PRECIP', color = 'purple');
```

{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}//images/courses/earth-analytics-python/03-intro-to-python-and-time-series-data/python-basics-review/2018-02-05-py04-spreadsheet-data-python_22_0.png" alt = "Here dataframe.plot.bar() is also using the pandas plot function to create a bar plot.">
<figcaption>Here dataframe.plot.bar() is also using the pandas plot function to create a bar plot.</figcaption>

</figure>




{:.input}
```python
# convert DATE field to a datetime structure
boulder_precip['DATE'] = pd.to_datetime(boulder_precip['DATE'])
boulder_precip.dtypes
```

{:.output}
{:.execute_result}



    Unnamed: 0             int64
    DATE          datetime64[ns]
    PRECIP               float64
    dtype: object





Let's now work with the matplotlib and take a little time to customize your plots. Below you add the following arguments to your plot:

* **title:** add a title to your plot
* **legend = False:** turn off the legend for the plot
* **kind = bar**: create a bar plot

{:.input}
```python
fig, ax = plt.subplots()

ax.bar(boulder_precip['DATE'].values, boulder_precip['PRECIP'].values, data=boulder_precip, color = 'purple')
ax.set_title("Total Daily Precipitation")

ax.set_xlabel("Hour", fontsize=12)
ax.set_ylabel("Total Precip (inches)", fontsize=12)
plt.setp(ax.get_xticklabels(), rotation=45);

```

{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}//images/courses/earth-analytics-python/03-intro-to-python-and-time-series-data/python-basics-review/2018-02-05-py04-spreadsheet-data-python_25_0.png" alt = "Notice here you use ax.plot. This is matplotlib plotting not pandas.">
<figcaption>Notice here you use ax.plot. This is matplotlib plotting not pandas.</figcaption>

</figure>



