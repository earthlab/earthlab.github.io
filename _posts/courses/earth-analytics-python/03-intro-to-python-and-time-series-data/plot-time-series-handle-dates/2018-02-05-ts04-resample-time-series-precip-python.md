---
layout: single
title: "Resample or Summarize Time Series Data in Python With Pandas - Hourly to Daily Summary"
excerpt: "Sometimes you need to take time series data collected at a higher resolution (for instance many times a day) and summarize it to a daily, weekly or even monthly value. This process is called resampling in Python and can be done using pandas dataframes. Learn how to resample time series data in Python with pandas."
authors: ['Leah Wasser', 'Chris Holdgraf', 'Martha Morrissey']
modified: 2018-09-04
category: [courses]
class-lesson: ['time-series-python']
course: 'earth-analytics-python'
week: 3
permalink: /courses/earth-analytics-python/use-time-series-data-in-python/resample-time-series-data-pandas-python/
nav-title: 'Resample Time Series Data'
sidebar:
  nav:
author_profile: false
comments: true
order: 4
topics:
  reproducible-science-and-programming: ['python']
  time-series:
  data-exploration-and-analysis: ['data-visualization']
---
{% include toc title="In This Lesson" icon="file-text" %}

<div class='notice--success' markdown="1">

This lesson supports the additional homework assignment question for graduate students to create a subsetted and aggregated plot. 

## <i class="fa fa-graduation-cap" aria-hidden="true"></i> Learning Objectives
After completing this tutorial, you will be able to:

* Resample times series data by day in `Python`

### Things You'll Need To Complete This Lesson
You need `Python` and `Jupyter notebooks` to complete this tutorial. Also you should have an `earth-analytics` directory setup on your computer with a `/data` directory with it.

#### Data Download
Please download the data (used throughout this series of lessons) if you don't already have it on your computer.

{% include/data_subsets/course_earth_analytics/_data-colorado-flood.md %}

</div>

You will plot USGS precipitation time series data. First, before plotting, there is some important information to consider about the data, since it needs to be pre-processed before plotting: 

1. The Data were collected over several decades and the data were not always collected consistently
1. Sometimes there are multiple data points per day which need to be aggragated to find a total precipitation value
1. The data are also not cleaned. You will find heading names that may not be meaningful, and other issues with the data that need to be explored

Working with these data is more akin to working with real data that you will download yourself rather than class data that is already pre-processed and cleaned. 

You will use the skills
that you learned in the previous lessons, coupled with the skills in this lesson
to process the data.


## Work with Precipitation Data
To get started you will load the needed Python libraries.

{:.input}
```python
import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
import os
plt.ion()

# set default figure parameters 
plt.rcParams['figure.figsize'] = (8, 8)
# prettier plotting with seaborn
import seaborn as sns; 
sns.set(font_scale=1.5)

# set working dir and import earthpy
import earthpy as et
os.chdir(os.path.join(et.io.HOME, 'earth-analytics'))
```

{:.output}
    /Users/lewa8222/anaconda3/envs/earth-analytics-python/lib/python3.6/importlib/_bootstrap.py:219: RuntimeWarning: numpy.dtype size changed, may indicate binary incompatibility. Expected 96, got 88
      return f(*args, **kwds)
    /Users/lewa8222/anaconda3/envs/earth-analytics-python/lib/python3.6/importlib/_bootstrap.py:219: RuntimeWarning: numpy.dtype size changed, may indicate binary incompatibility. Expected 96, got 88
      return f(*args, **kwds)
    /Users/lewa8222/anaconda3/envs/earth-analytics-python/lib/python3.6/importlib/_bootstrap.py:219: RuntimeWarning: numpy.dtype size changed, may indicate binary incompatibility. Expected 96, got 88
      return f(*args, **kwds)



## Import Precipitation Data

In this lesson you will learn how to aggregate or resample time series data to a different temporal resolution. You will use the `805333-precip-daily-1948-2013.csv` dataset in this lesson. This dataset contains the precipitation values collected daily from the COOP station 050843 in Boulder, CO for 1 January 2003 through 31 December 2013. When you look at the data, notice that there are sometimes multiple values collected for each day. 

However, you want to summarize the data on a daily time scale.

To begin, import the data into Python and then view the first few rows, and what data type each column contains.
When you import, be sure to specify the 

* no data values
* date column
* set the data column to be the dataframe index


{:.input}
```python
# open the data 
precip_file = "data/colorado-flood/precipitation/805325-precip-daily-2003-2013.csv"
precip_boulder = pd.read_csv(precip_file,
                             na_values=[999.99],
                             parse_dates=['DATE'], 
                            index_col = 'DATE')
precip_boulder.head()
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
      <th>STATION</th>
      <th>STATION_NAME</th>
      <th>ELEVATION</th>
      <th>LATITUDE</th>
      <th>LONGITUDE</th>
      <th>HPCP</th>
      <th>Measurement Flag</th>
      <th>Quality Flag</th>
    </tr>
    <tr>
      <th>DATE</th>
      <th></th>
      <th></th>
      <th></th>
      <th></th>
      <th></th>
      <th></th>
      <th></th>
      <th></th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>2003-01-01 01:00:00</th>
      <td>COOP:050843</td>
      <td>BOULDER 2 CO US</td>
      <td>1650.5</td>
      <td>40.03389</td>
      <td>-105.28111</td>
      <td>0.0</td>
      <td>g</td>
      <td></td>
    </tr>
    <tr>
      <th>2003-02-01 01:00:00</th>
      <td>COOP:050843</td>
      <td>BOULDER 2 CO US</td>
      <td>1650.5</td>
      <td>40.03389</td>
      <td>-105.28111</td>
      <td>0.0</td>
      <td>g</td>
      <td></td>
    </tr>
    <tr>
      <th>2003-02-02 19:00:00</th>
      <td>COOP:050843</td>
      <td>BOULDER 2 CO US</td>
      <td>1650.5</td>
      <td>40.03389</td>
      <td>-105.28111</td>
      <td>0.2</td>
      <td></td>
      <td></td>
    </tr>
    <tr>
      <th>2003-02-02 22:00:00</th>
      <td>COOP:050843</td>
      <td>BOULDER 2 CO US</td>
      <td>1650.5</td>
      <td>40.03389</td>
      <td>-105.28111</td>
      <td>0.1</td>
      <td></td>
      <td></td>
    </tr>
    <tr>
      <th>2003-02-03 02:00:00</th>
      <td>COOP:050843</td>
      <td>BOULDER 2 CO US</td>
      <td>1650.5</td>
      <td>40.03389</td>
      <td>-105.28111</td>
      <td>0.1</td>
      <td></td>
      <td></td>
    </tr>
  </tbody>
</table>
</div>





View the data structure.

{:.input}
```python
precip_boulder.dtypes
```

{:.output}
{:.execute_result}



    STATION              object
    STATION_NAME         object
    ELEVATION           float64
    LATITUDE            float64
    LONGITUDE           float64
    HPCP                float64
    Measurement Flag     object
    Quality Flag         object
    dtype: object





## Plot Precipitation Data

Next plot the data. Notice that the data often have multiple records for a single day. However you 
are interested in summarizing the data for each day.

{:.input}
```python
fig, ax = plt.subplots()
precip_boulder.plot(y = "HPCP", 
        color = 'purple', ax=ax)
ax.set(xlabel='Date', ylabel='Precipitation (Inches)',
       title="Hourly Precipitation - Boulder Station\n 1948-2013");
```

{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}//images/courses/earth-analytics-python/03-intro-to-python-and-time-series-data/plot-time-series-handle-dates/2018-02-05-ts04-resample-time-series-precip-python_8_0.png">

</figure>




## Resample Hourly Data to Daily Data

For your research project, you only need daily summary values. To aggregate or temporal resample
the data for a time period, you can create a new object 
called in the dataset called day. You will take all of the values for each day and summarize them.
In this case you want total daily rainfall - so you will use the `resample()` and `.sum()` function. 
`resample()` is a method in pandas that can be used to summarize data by date or time. 

The `.sum()` method will add up all values to provide a summary output value.

If you do not set the DATE column as the index, your code will look like this:

`pandas_data_fram_name.resample('D', on = 'DATE').sum()`

If you do however, you do not need the `on=` argument.

`pandas_data_fram_name.resample('D').sum()`

The `on` argument of the `resample` function is used to specify the column that will be used to summarized. This column need to be in the format `datetime`. Notice that either method will return a new `DataFrame` with the dates as the index.

The `'D'` specifies that you will aggregate by day. 

<div class = "notice--success">

<i class="fa fa-star"></i> **Data Tip:** You can also resample using the syntax below. Here you first set the date to the index of the dataframe. By doing this, you do not need to specify the on argument.

```python

precip_boulder2 = precip_boulder.set_index('DATE')
daily_sum_precip2 = precip_boulder2.resample('D').sum()

```
</div>

{:.input}
```python
# resample the data 
precip_boulder_daily = precip_boulder.resample('D').sum()
```

Once you have resampled the data, look at it. each HPCP value now represents a daily total or sum of all precipitation measured that day. Notice in the output below that your DATE field no longer contains time stamps. Also notice that you have only one summary value or row per day. 

{:.input}
```python
precip_boulder_daily.head()
```

{:.input}
```python
# plot the data
fig, ax = plt.subplots()
ax.scatter(precip_boulder_daily.index, 
       precip_boulder_daily['HPCP'], 
       color = 'purple')
ax.set(xlabel='Date', 
       ylabel='Precipitation (Inches)',
       title="Daily Precipitation - Boulder Station\n 1983-2013");
```

## Plot Resampled Data

{:.input}
```python
# plot the data
fig, ax = plt.subplots()
ax.scatter(precip_boulder_daily.index, 
       precip_boulder_daily['HPCP'].rolling, 
       color = 'purple')
ax.set(xlabel='Date', 
       ylabel='Precipitation (Inches)',
       title="Daily Precipitation - Boulder Station\n 1983-2013");
```
