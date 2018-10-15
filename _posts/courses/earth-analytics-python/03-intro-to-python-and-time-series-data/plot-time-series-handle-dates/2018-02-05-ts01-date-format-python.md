---
layout: single
title: "Work With Datetime Format in Python - Time Series Data "
excerpt: "This lesson covers how to deal with dates in Python. It reviews how to convert a field containing dates as strings to a datetime object that Python can understand and plot efficiently. This tutorial also covers how to handle missing data values in Python."
authors: ['Jenny Palomino', 'Leah Wasser', 'Chris Holdgraf', 'Martha Morrissey']
modified: 2018-10-08
category: [courses]
class-lesson: ['time-series-python']
course: 'earth-analytics-python'
permalink: /courses/earth-analytics-python/use-time-series-data-in-python/date-time-types-in-pandas-python/
module-description: 'This lesson series covers working with time series data in Python. You will learn how to handle date fields in Python to create custom plots of time series data using matplotlib.'
module-nav-title: 'Time Series Data in Pandas'
module-title: 'Use Time Series Data in Python Pandas'
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
  reproducible-science-and-programming: ['jupyter-notebook', 'python']
  time-series:
  data-exploration-and-analysis: ['data-visualization']
---
{% include toc title="In This Lesson" icon="file-text" %}

In this tutorial, you will learn how to work with the `datetime` object in `Python`, which is important for plotting and working with time series data. You will also learn how to work with "no data" values in `Python`.

<div class='notice--success' markdown="1">

## <i class="fa fa-graduation-cap" aria-hidden="true"></i> Learning Objectives

At the end of this activity, you will be able to:

* Import a time series dataset into Python using `pandas` with dates converted to a `datetime` object in `Python`.
* Describe how you can use the `datetime` object to create easier-to-read time series plots in `Python`.
* Explain the role of "no data" values and how the `NA` value is used in `Python` to account for "no data" values.
* Set a "no data" value for a file when you import it into a `pandas dataframe`. 


## <i class="fa fa-check-square-o fa-2" aria-hidden="true"></i> What You Need

You should have completed the lessons on <a href="{{ site.url }}/workshops/setup-earth-analytics-python/">Setting Up the Conda Environment.</a>. Be sure that you have a subdirectory called `data` under your `earth-analytics` directory. 

</div>


## Begin Working With Datetime Object in Python

Dates can be tricky in any programming language. While you may see a date and recognize it as something that can be quantified and related to time, a computer reads in numbers and characters, and often by default, loads date information as a string (i.e. a set of characters), rather than something that has an order in time. 

In this lesson, you will learn how to handle dates in `Python` with `pandas` using a dataset of <a href="https://www.esrl.noaa.gov/psd/boulder/data/boulderdaily.complete" target="_blank">daily temperature (maximum) and precipitation in July 2018 for Boulder, CO</a>.

Begin by importing the necessary `Python` packages to set the working directory and download the file. 

{:.input}
```python
# import necessary packages
#import numpy as np
import os
import urllib.request
import pandas as pd
import matplotlib.pyplot as plt
import earthpy as et

# make figures plot inline
plt.ion()

# set working directory
os.chdir(os.path.join(et.io.HOME, 'earth-analytics'))

# set standard plot parameters for uniform plotting
plt.rcParams['figure.figsize'] = (10, 6)
# prettier plotting with seaborn
import seaborn as sns; 
sns.set(font_scale=1.5)
sns.set_style("whitegrid")
```

{:.input}
```python
file_path = "data/colorado-flood/downloads/july-2018-temperature-precip.csv"
# download file from Earth Lab Figshare repository
urllib.request.urlretrieve(url='https://ndownloader.figshare.com/files/12948515', 
                           filename= file_path)
```

{:.output}
{:.execute_result}



    ('data/colorado-flood/downloads/july-2018-temperature-precip.csv',
     <http.client.HTTPMessage at 0x11b89e7b8>)





Next, import the data from `data/july-2018-temperature-precip.csv` into a `pandas dataframe` and query the data types using the attribute `.dtypes`. 

{:.input}
```python
# import file into pandas dataframe
boulder_july = pd.read_csv(file_path)

# view first few rows of the data`
boulder_july.head()
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
      <th>date</th>
      <th>max_temp</th>
      <th>precip</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>2018-07-01</td>
      <td>87</td>
      <td>0.00</td>
    </tr>
    <tr>
      <th>1</th>
      <td>2018-07-02</td>
      <td>92</td>
      <td>0.00</td>
    </tr>
    <tr>
      <th>2</th>
      <td>2018-07-03</td>
      <td>90</td>
      <td>-999.00</td>
    </tr>
    <tr>
      <th>3</th>
      <td>2018-07-04</td>
      <td>87</td>
      <td>0.00</td>
    </tr>
    <tr>
      <th>4</th>
      <td>2018-07-05</td>
      <td>84</td>
      <td>0.24</td>
    </tr>
  </tbody>
</table>
</div>





{:.input}
```python
# view data types
boulder_july.dtypes
```

{:.output}
{:.execute_result}



    date         object
    max_temp      int64
    precip      float64
    dtype: object





### Data Types in Pandas Dataframes

The `.dtypes` attribute indicates that the data columns in your `DataFrame` are stored as several different data types as follows:

* **date as object:** A string, characters that are in quotes. 
* **max_temp as int64** 64 bit integer. This is a numeric value that will never contain decimal points.
* **precip as float64 - 64 bit float:**  This data type accepts data that are a wide variety of numeric formats including decimals (floating point values) and integers. Numeric also accept larger numbers than **int** will.

### One Data Type Per Dataframe Column

A `pandas dataframe` column can only store one data type. This means that a column can not store both numbers and strings. If a column contains a list comprised of all numbers and one character string, then every value in that column will be stored as a string. 

Storing variables using different data types is a strategic decision by `Python` (and other programming languages) that optimizes processing and storage. It allows:

* data to be processed more quickly & efficiently.
* the program (`Python`) to minimize the storage size.


### Datetime Object

Objects are used in `Python` to provide a set of functionality and rules that apply to that specific object type such as: 

1. lists
2. dictionaries
3. `numpy arrays`
4. `pandas dataframes` and more

`Python` provides a `datetime` object for storing and working with dates, and you can convert columns in `pandas dataframe` containing dates and times as strings into `datetime` objects.

Investigate the data type in the `date` column further to see the data type or class of information it contains.

{:.input}
```python
# query the data type for date column
type(boulder_july['date'][0])
```

{:.output}
{:.execute_result}



    str





Notice that while you may see this column as a date, `Python` classifies it as a type `str` or string. 

You can easily convert the dates from strings to a `datetime` object during the import process, which you will see later in the lesson. Once the dates are converted to a `datetime` object, you can more easily customize the dates on your plot, resulting in a more visually appealing plot. 

### Plot Dates as Strings

To understand why using `datetime` objects can help you to create better plots, begin by creating a plot using `matplotlib`, based on the `date` column (as a string) and the `max_temp` column.

{:.input}
```python
# create the plot space upon which to plot the data
fig, ax = plt.subplots(figsize = (10,10))

# add the x-axis and the y-axis to the plot
ax.plot(boulder_july['date'], 
        boulder_july['precip'], 
        color = 'red')

# rotate tick labels
plt.setp(ax.get_xticklabels(), rotation=45)

# set title and labels for axes
ax.set(xlabel="Date",
       ylabel="Temperature (Fahrenheit)",
       title="Precipitation\nBoulder, Colorado in July 2018");
```

{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}//images/courses/earth-analytics-python/03-intro-to-python-and-time-series-data/plot-time-series-handle-dates/2018-02-05-ts01-date-format-python_10_0.png" alt = "Plot of precipitation in Boulder, CO without no data values removed.">
<figcaption>Plot of precipitation in Boulder, CO without no data values removed.</figcaption>

</figure>




Look closely at the dates on the x-axis. When you plot a string field for the x-axis, `Python` gets stuck trying to plot the all of the date labels. Each value is read as a string, and it is difficult to try to fit all of those values on the x axis efficiently. 

You can avoid this problem by importing the data using a parameter of the `read_csv()` that allows you to indicate that a particular column should be converted to a `datetime` object:

`parse_dates = ['date_column_name']`

If you have a single column that contain dates in your data, you also want to set dates as the index column.
You will use this in later lessons. The index column will allow you to quickly summarize and aggregate your data by date. To set the index use the argument:

`index_col = ['date_column_name']` 

## Import Date Column As Datetime 

{:.input}
```python
# import file into pandas dataframe, identifying the date column to be converted to datetime
boulder_july_datetime = pd.read_csv(file_path,
                             parse_dates = ['date'],
                             index_col = ['date'])

# view data index
boulder_july_datetime.index
```

{:.output}
{:.execute_result}



    DatetimeIndex(['2018-07-01', '2018-07-02', '2018-07-03', '2018-07-04',
                   '2018-07-05', '2018-07-06', '2018-07-07', '2018-07-08',
                   '2018-07-09', '2018-07-10', '2018-07-11', '2018-07-12',
                   '2018-07-13', '2018-07-14', '2018-07-15', '2018-07-16',
                   '2018-07-17', '2018-07-18', '2018-07-19', '2018-07-20',
                   '2018-07-21', '2018-07-22', '2018-07-23', '2018-07-24',
                   '2018-07-25', '2018-07-26', '2018-07-27', '2018-07-28',
                   '2018-07-29', '2018-07-30', '2018-07-31'],
                  dtype='datetime64[ns]', name='date', freq=None)





Once your date column is set to be both 

1. datetime64 and
2. an index
You will notice that the dataframe prints with that column on the left. Notice that the word "date" which represents the column header, is LOWER than the other two column headings. 

{:.input}
```python
boulder_july_datetime.head()
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
      <th>max_temp</th>
      <th>precip</th>
    </tr>
    <tr>
      <th>date</th>
      <th></th>
      <th></th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>2018-07-01</th>
      <td>87</td>
      <td>0.00</td>
    </tr>
    <tr>
      <th>2018-07-02</th>
      <td>92</td>
      <td>0.00</td>
    </tr>
    <tr>
      <th>2018-07-03</th>
      <td>90</td>
      <td>-999.00</td>
    </tr>
    <tr>
      <th>2018-07-04</th>
      <td>87</td>
      <td>0.00</td>
    </tr>
    <tr>
      <th>2018-07-05</th>
      <td>84</td>
      <td>0.24</td>
    </tr>
  </tbody>
</table>
</div>





Also notice that the date no longer appears when you call dtypes. Don't worry - the column is still there!

{:.input}
```python
boulder_july_datetime.dtypes
```

{:.output}
{:.execute_result}



    max_temp      int64
    precip      float64
    dtype: object






## Plot Dates Using Datetime 

To plot your data as a bar or scatter plot in `matplotlib`, you will get an error if you pass a `pandas dataframe` column of `datetime` directly into the plot function. 

This is because when plotting with these methods, `numpy` is used to concatenate (a fancy word for combine) the array that has been passed in for the `x-axis` and the array that has been passed in for `y-axis`. However, `numpy` cannot concatenate the `datetime` object with other values. 

### Use Values Attribute to Plot Datetime

To avoid this error, you can call the attribute `.values` on the `datetime` column using:

`dataframe.index.values`

Notice that here you use dataframe.index to access the datetime column. This is because you have assigned your date column to be an index for the dataframe. Also notice that the spacing on the x-axis looks better and that your x-axis date labels are easier to read, as `Python` 
knows how to only show incremental values rather than each and every date value. 

{:.input}
```python
# create the plot space upon which to plot the data
fig, ax= plt.subplots()

# add the x-axis and the y-axis to the plot
ax.plot(boulder_july_datetime.index.values, 
        boulder_july_datetime['precip'], 
        color = 'red')

# rotate tick labels
plt.setp(ax.get_xticklabels(), rotation=45)

# set title and labels for axes
ax.set(xlabel="Date",
       ylabel="Temperature (Fahrenheit)",
       title="Precipitation\nBoulder, Colorado in July 2018");
```

{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}//images/courses/earth-analytics-python/03-intro-to-python-and-time-series-data/plot-time-series-handle-dates/2018-02-05-ts01-date-format-python_18_0.png" alt = "Plot of precipitation with the x-axis dates formated as datetime.">
<figcaption>Plot of precipitation with the x-axis dates formated as datetime.</figcaption>

</figure>




{:.input}
```python
# create the plot space upon which to plot the data
fig, ax= plt.subplots()

# add the x-axis and the y-axis to the plot
ax.bar(boulder_july_datetime.index.values, 
        boulder_july_datetime['precip'], 
        color = 'blue')

# rotate tick labels
plt.setp(ax.get_xticklabels(), rotation=45)

# set title and labels for axes
ax.set(xlabel="Date",
       ylabel="Precipitation (in)",
       title="Precipitation \nBoulder, Colorado in July 2018");
```

{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}//images/courses/earth-analytics-python/03-intro-to-python-and-time-series-data/plot-time-series-handle-dates/2018-02-05-ts01-date-format-python_19_0.png" alt = "Bar plot showing daily precipitation with the x-axis dates cleaned up.">
<figcaption>Bar plot showing daily precipitation with the x-axis dates cleaned up.</figcaption>

</figure>




NOTE: you do not need to use `.values` when using a column that contains `float` objects rather than `datetime` objects, nor when creating a line graph. However, for consistency, the plot examples above use the same code to employ `.values` and create the plots.

You may have observed that the above plots did not look right. Explore the data further using the `describe()` dataframe method. Do you see any values that are questionable?

{:.input}
```python
# notice any values that may seem off in the summary statistics below?
boulder_july_datetime.describe()
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
      <th>max_temp</th>
      <th>precip</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>count</th>
      <td>31.000000</td>
      <td>31.000000</td>
    </tr>
    <tr>
      <th>mean</th>
      <td>88.129032</td>
      <td>-96.618065</td>
    </tr>
    <tr>
      <th>std</th>
      <td>6.626925</td>
      <td>300.256388</td>
    </tr>
    <tr>
      <th>min</th>
      <td>75.000000</td>
      <td>-999.000000</td>
    </tr>
    <tr>
      <th>25%</th>
      <td>84.000000</td>
      <td>0.000000</td>
    </tr>
    <tr>
      <th>50%</th>
      <td>88.000000</td>
      <td>0.000000</td>
    </tr>
    <tr>
      <th>75%</th>
      <td>94.000000</td>
      <td>0.050000</td>
    </tr>
    <tr>
      <th>max</th>
      <td>97.000000</td>
      <td>0.450000</td>
    </tr>
  </tbody>
</table>
</div>






## No Data Values

Sometimes data are missing from a file due to errors in collection, inability to record a data point, or other reasons. 

Imagine a spreadsheet in Microsoft Excel with cells that are blank. If the cells are blank, you don't know for sure whether those data weren't collected, or something someone forgot to fill in. To account for data that are missing (not by mistake), you can put a value into those cells that represents "no data".

### Customize NoData Values

Often, you'll find a dataset that uses a specific value for "no data". In many scientific disciplines, the value `-999` is often used to indicate "no data" values. The data in `july-2018-temperature-precip.csv` contains "no data" values in the `precip` column using the value `-999`. 

If you do not specify that the value `-999` is the "no data" value, the values will be imported as real data, which will impact any statistics or calculations run on that column.

When you used the `describe` method above, the `-999` values were imported as numeric values into the `pandas dataframe` when it was created, and thus, these values are included in the summary statistic. To ensure nodata values are properly ignored in your summary statistics, you can specify a "no data" value during the import, so that they are not read as numeric values, using the function argument: 

`na_values = no-data-value-here`


{:.input}
```python
# import file into pandas dataframe, with a no data value specified
boulder_july_datetime_nodata = pd.read_csv(file_path,
                                           parse_dates=['date'], 
                                           na_values=['-999'])
```

Now have a look at the summary statistics.

{:.input}
```python
# calculate mean of columns in dataframe
boulder_july_datetime_nodata.describe()
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
      <th>max_temp</th>
      <th>precip</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>count</th>
      <td>31.000000</td>
      <td>28.000000</td>
    </tr>
    <tr>
      <th>mean</th>
      <td>88.129032</td>
      <td>0.065714</td>
    </tr>
    <tr>
      <th>std</th>
      <td>6.626925</td>
      <td>0.120936</td>
    </tr>
    <tr>
      <th>min</th>
      <td>75.000000</td>
      <td>0.000000</td>
    </tr>
    <tr>
      <th>25%</th>
      <td>84.000000</td>
      <td>0.000000</td>
    </tr>
    <tr>
      <th>50%</th>
      <td>88.000000</td>
      <td>0.000000</td>
    </tr>
    <tr>
      <th>75%</th>
      <td>94.000000</td>
      <td>0.055000</td>
    </tr>
    <tr>
      <th>max</th>
      <td>97.000000</td>
      <td>0.450000</td>
    </tr>
  </tbody>
</table>
</div>





And finally, plot the data one last time.

{:.input}
```python
# create the plot space upon which to plot the data
fig, ax= plt.subplots()

# add the x-axis and the y-axis to the plot
ax.bar(boulder_july_datetime_nodata.index.values, 
        boulder_july_datetime_nodata['precip'], 
        color = 'purple')

# rotate tick labels
plt.setp(ax.get_xticklabels(), rotation=45)

# set title and labels for axes
ax.set(xlabel="Date",
       ylabel="Precipitation (Inches)",
       title="Precipitation\nBoulder, Colorado in July 2018");
```

{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}//images/courses/earth-analytics-python/03-intro-to-python-and-time-series-data/plot-time-series-handle-dates/2018-02-05-ts01-date-format-python_27_0.png" alt = "Bar plot showing daily precipitation with the x-axis dates cleaned up and no data values removed.">
<figcaption>Bar plot showing daily precipitation with the x-axis dates cleaned up and no data values removed.</figcaption>

</figure>




By using the `na_values` parameter, you told `Python` to ignore those "no data" values when it performs calculations on the data.

Note: if there are multiple types of missing values in your dataset, you can extend what `Python` considers a missing value using multiple values in the `na_values` parameter as follows:

`na_values=['NA', ' ', '-999'])`

In this example, the "no data" values are specified to be "NA", an empty space, or the value `999`. 

<div class="notice--warning" markdown="1">

## <i class="fa fa-pencil-square-o" aria-hidden="true"></i> Optional Challenge

Test your `Python` skills to plot data using `datetime` object: 

1. Use data that you previously downloaded to your `data` directory in the `earth-analytics` directory: 

`data/colorado-flood/downloads/boulder-precip.csv`

2. Import the data as `pandas dataframe` indicating the appropriate column for the `datetime` object. 

3. Print the `dtypes` attribute and create a bar plot of the precipitation data. 

</div>


{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}//images/courses/earth-analytics-python/03-intro-to-python-and-time-series-data/plot-time-series-handle-dates/2018-02-05-ts01-date-format-python_30_0.png" alt = "Bar plot showing daily precipitation with the x-axis dates cleaned up and no data values removed.">
<figcaption>Bar plot showing daily precipitation with the x-axis dates cleaned up and no data values removed.</figcaption>

</figure>



