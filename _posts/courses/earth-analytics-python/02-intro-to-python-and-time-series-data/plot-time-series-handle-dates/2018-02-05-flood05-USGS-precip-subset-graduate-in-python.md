---
layout: single
title: "Subset & aggregate time series precipitation data in Python using the resample function."
excerpt: "This lesson introduces subsetting and resampling functions - which will allow you to aggregate or summarize time series data by a particular field - in this case you will aggregate data by day to get daily precipitation totals for Boulder during the 2013 floods."
authors: ['Leah Wasser', Chris Holdgraf', 'Martha Morrissey']
modified: 2018-08-01
category: [courses]
class-lesson: ['time-series-python']
course: 'earth-analytics-python'
week: 2
permalink: /courses/earth-analytics-python/use-time-series-data-in-python/aggregate-time-series-data-python/
nav-title: 'Aggregate data'
sidebar:
  nav:
author_profile: false
comments: true
order: 5
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

* Aggregate data by a day in `Python`
* View data.frame column names and clean-up / rename dataframe column names.

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
```

{:.input}
```python
# set default figure parameters 

plt.rcParams['figure.figsize'] = (8, 8)
plt.rcParams['axes.titlesize'] = 20
plt.rcParams['axes.facecolor']='white'
plt.rcParams['grid.color'] = 'grey'
plt.rcParams['axes.grid'] = True
plt.rcParams['grid.linestyle'] = '-'
plt.rcParams['grid.linewidth'] = '.5'
plt.rcParams['lines.color'] = 'purple'
plt.rcParams['axes.labelsize']= 16
```

## Import Precipitation Data

You will use the `805333-precip-daily-1948-2013.csv` dataset in this analysis. This dataset contains the precipitation values collected daily from the COOP station 050843 in Boulder, CO for 1 January 2003 through 31 December 2013.

To begin, import the data into Python and then view the first few rows, and what data type each column contains.

### Be sure to set your working directory

`os.chdir("path-to-you-dir-here/earth-analytics/data")`

{:.input}
```python
precip_file = 'data/colorado-flood/precipitation/805333-precip-daily-1948-2013.csv'
precip_boulder = pd.read_csv(precip_file)
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
      <th>DATE</th>
      <th>HPCP</th>
      <th>Measurement Flag</th>
      <th>Quality Flag</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>COOP:050843</td>
      <td>BOULDER 2 CO US</td>
      <td>unknown</td>
      <td>unknown</td>
      <td>unknown</td>
      <td>19480801 01:00</td>
      <td>0.00</td>
      <td>g</td>
      <td></td>
    </tr>
    <tr>
      <th>1</th>
      <td>COOP:050843</td>
      <td>BOULDER 2 CO US</td>
      <td>unknown</td>
      <td>unknown</td>
      <td>unknown</td>
      <td>19480802 15:00</td>
      <td>0.05</td>
      <td></td>
      <td></td>
    </tr>
    <tr>
      <th>2</th>
      <td>COOP:050843</td>
      <td>BOULDER 2 CO US</td>
      <td>unknown</td>
      <td>unknown</td>
      <td>unknown</td>
      <td>19480803 09:00</td>
      <td>0.01</td>
      <td></td>
      <td></td>
    </tr>
    <tr>
      <th>3</th>
      <td>COOP:050843</td>
      <td>BOULDER 2 CO US</td>
      <td>unknown</td>
      <td>unknown</td>
      <td>unknown</td>
      <td>19480803 14:00</td>
      <td>0.03</td>
      <td></td>
      <td></td>
    </tr>
    <tr>
      <th>4</th>
      <td>COOP:050843</td>
      <td>BOULDER 2 CO US</td>
      <td>unknown</td>
      <td>unknown</td>
      <td>unknown</td>
      <td>19480803 15:00</td>
      <td>0.03</td>
      <td></td>
      <td></td>
    </tr>
  </tbody>
</table>
</div>






{:.output}
{:.execute_result}



    STATION              object
    STATION_NAME         object
    ELEVATION            object
    LATITUDE             object
    LONGITUDE            object
    DATE                 object
    HPCP                float64
    Measurement Flag     object
    Quality Flag         object
    dtype: object





## About the Data

The structure of the data is similar to what you saw in previous lessons. The `HPCP`
column contains the total precipitation given in inches, recorded
for the hour ending at the time specified by DATE. There is a designated missing
data value of `999.99`. Note that if there is no data in a particular hour, then 
no value is recorded.

The metadata for this file is located in your week2 directory:
`PRECIP_HLY_documentation.pdf` file that can be downloaded along with the data.
(Note, as of Sept. 2016, there is a mismatch in the data downloaded and the
documentation. The differences are in the units and missing data value:
inches/999.99 (standard) or millimeters/25399.75 (metric)).
 
### No Data Values

Be sure to explore the data closely. If there are no data values in the data, make sure to adjust your
data import code above to account for no data values. Then determine how many no
data values you have in your dataset.


{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}//images/courses/earth-analytics-python/02-intro-to-python-and-time-series-data/plot-time-series-handle-dates/2018-02-05-flood05-USGS-precip-subset-graduate-in-python_8_0.png">

</figure>





{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}//images/courses/earth-analytics-python/02-intro-to-python-and-time-series-data/plot-time-series-handle-dates/2018-02-05-flood05-USGS-precip-subset-graduate-in-python_9_0.png">

</figure>




{:.input}
```python
print("How many NA values are there?")
print(precip_boulder.isnull().sum())
```

{:.output}
    How many NA values are there?
    STATION               0
    STATION_NAME          0
    ELEVATION             0
    LATITUDE              0
    LONGITUDE             0
    DATE                  0
    HPCP                401
    Measurement Flag      0
    Quality Flag          0
    dtype: int64



### Convert Date and Time

Compared to the data that you worked with in previous lessons where you were only working with dates, these data contains dates and times. Luckily pandas is very good at recognizing date and datetime formats. 

{:.input}
```python
precip_boulder['DATE'] = pd.to_datetime(precip_boulder['DATE'])
precip_boulder['DATE'].head()
```

{:.output}
{:.execute_result}



    0   1948-08-01 01:00:00
    1   1948-08-02 15:00:00
    2   1948-08-03 09:00:00
    3   1948-08-03 14:00:00
    4   1948-08-03 15:00:00
    Name: DATE, dtype: datetime64[ns]





## Plot Precipitation Data

Next, let's have explore the data further by plotting it. Format the plot using
the colors, labels, etc that are most clear and look the best. Your plot does not
need to look like the one below!


{:.input}
```python
fig, ax = plt.subplots()
ax.plot(precip_boulder['DATE'], precip_boulder['HPCP'], 'o', color = 'purple')
ax.set(xlabel='Date', ylabel='Precipitation (Inches)',
       title="Hourly Precipitation - Boulder Station\n 1948-2013");
```

{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}//images/courses/earth-analytics-python/02-intro-to-python-and-time-series-data/plot-time-series-handle-dates/2018-02-05-flood05-USGS-precip-subset-graduate-in-python_14_0.png">

</figure>




## Differences in the data

The plot above brings to light a visual difference in the data that seems to begin around 1970. What do you notice? Any ideas what might be causing the notable difference in the plotted data through time?


{:.input}
```python
# round the data 
precip_boulder['HPCP_round'] = precip_boulder['HPCP'].apply(np.round, decimals=1)
```

{:.input}
```python
precip_boulder['HPCP_round'].head()

precip_boulder.dropna(inplace= True)

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
      <th>DATE</th>
      <th>HPCP</th>
      <th>Measurement Flag</th>
      <th>Quality Flag</th>
      <th>HPCP_round</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>COOP:050843</td>
      <td>BOULDER 2 CO US</td>
      <td>unknown</td>
      <td>unknown</td>
      <td>unknown</td>
      <td>1948-08-01 01:00:00</td>
      <td>0.00</td>
      <td>g</td>
      <td></td>
      <td>0.0</td>
    </tr>
    <tr>
      <th>1</th>
      <td>COOP:050843</td>
      <td>BOULDER 2 CO US</td>
      <td>unknown</td>
      <td>unknown</td>
      <td>unknown</td>
      <td>1948-08-02 15:00:00</td>
      <td>0.05</td>
      <td></td>
      <td></td>
      <td>0.0</td>
    </tr>
    <tr>
      <th>2</th>
      <td>COOP:050843</td>
      <td>BOULDER 2 CO US</td>
      <td>unknown</td>
      <td>unknown</td>
      <td>unknown</td>
      <td>1948-08-03 09:00:00</td>
      <td>0.01</td>
      <td></td>
      <td></td>
      <td>0.0</td>
    </tr>
    <tr>
      <th>3</th>
      <td>COOP:050843</td>
      <td>BOULDER 2 CO US</td>
      <td>unknown</td>
      <td>unknown</td>
      <td>unknown</td>
      <td>1948-08-03 14:00:00</td>
      <td>0.03</td>
      <td></td>
      <td></td>
      <td>0.0</td>
    </tr>
    <tr>
      <th>4</th>
      <td>COOP:050843</td>
      <td>BOULDER 2 CO US</td>
      <td>unknown</td>
      <td>unknown</td>
      <td>unknown</td>
      <td>1948-08-03 15:00:00</td>
      <td>0.03</td>
      <td></td>
      <td></td>
      <td>0.0</td>
    </tr>
  </tbody>
</table>
</div>





{:.input}
```python

fig, ax = plt.subplots(figsize=(14, 14))
ax.plot(precip_boulder['DATE'], precip_boulder['HPCP_round'], 'o', color = 'purple')
ax.set(xlabel='Date', ylabel='Precipitation (Inches)',
       title="Hourly Precipitation - Boulder Station\n 1948-2013");
```

{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}//images/courses/earth-analytics-python/02-intro-to-python-and-time-series-data/plot-time-series-handle-dates/2018-02-05-flood05-USGS-precip-subset-graduate-in-python_18_0.png">

</figure>




## Subset the data

For our research project, you only need to explore 30 years of data.
There's no need to work with the entire dataset so let's do the following:

1. Subset the data for 30 years (you learned how to do this in a previous lesson).
2. Aggregate the precipitation totals (sum) by day.

#### Aggregate and summarize data

To aggregate data by a particular variable or time period, you can create a new object 
called in our dataset called day. You will take all of the values for each day and add them
using the `resample()` and `.sum()` function.  




{:.input}
```python
precip_boulder_subset = precip_boulder.query('DATE >= "1983-12-31" and DATE <= "2013-12-31"')
```

<div class="notice--success" markdown="1">

The `on` argument of the `resample` function will take column that has date as the datatype `datetime` or if the `DataFrame` index is a datetime-like index then the `on` argument is not necessary. Notice that either method will return a new `DataFrame` with the dates as the index.

</div>

{:.input}
```python
precip_boulder_daily = precip_boulder_subset.resample('D', on = 'DATE').sum()
```

{:.input}
```python
precip_boulder_daily.head()
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
      <th>HPCP</th>
      <th>HPCP_round</th>
    </tr>
    <tr>
      <th>DATE</th>
      <th></th>
      <th></th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>1984-01-01</th>
      <td>0.0</td>
      <td>0.0</td>
    </tr>
    <tr>
      <th>1984-01-02</th>
      <td>0.0</td>
      <td>0.0</td>
    </tr>
    <tr>
      <th>1984-01-03</th>
      <td>0.0</td>
      <td>0.0</td>
    </tr>
    <tr>
      <th>1984-01-04</th>
      <td>0.0</td>
      <td>0.0</td>
    </tr>
    <tr>
      <th>1984-01-05</th>
      <td>0.0</td>
      <td>0.0</td>
    </tr>
  </tbody>
</table>
</div>





{:.input}
```python
fig, ax = plt.subplots()
ax.bar(precip_boulder_daily.index, precip_boulder_daily['HPCP_round'], color = 'purple')
ax.set(xlabel='Date', ylabel='Precipitation (Inches)',
       title="Daily Precipitation - Boulder Station\n 1983-2013");
```

{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}//images/courses/earth-analytics-python/02-intro-to-python-and-time-series-data/plot-time-series-handle-dates/2018-02-05-flood05-USGS-precip-subset-graduate-in-python_24_0.png">

</figure>




## Resample with Date as the Index

{:.input}
```python
precip_boulder2 = precip_boulder.set_index('DATE')
daily_sum_precip2 = precip_boulder2.resample('D').sum()
daily_sum_precip2.head()
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
      <th>HPCP</th>
      <th>HPCP_round</th>
    </tr>
    <tr>
      <th>DATE</th>
      <th></th>
      <th></th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>1948-08-01</th>
      <td>0.00</td>
      <td>0.0</td>
    </tr>
    <tr>
      <th>1948-08-02</th>
      <td>0.05</td>
      <td>0.0</td>
    </tr>
    <tr>
      <th>1948-08-03</th>
      <td>0.07</td>
      <td>0.0</td>
    </tr>
    <tr>
      <th>1948-08-04</th>
      <td>0.14</td>
      <td>0.0</td>
    </tr>
    <tr>
      <th>1948-08-05</th>
      <td>0.02</td>
      <td>0.0</td>
    </tr>
  </tbody>
</table>
</div>





Finally, plot a temporal subsets of the data from 2000-2013. You learned how to do this in the previous lessons. Now you can easily see the dramatic rainfall event in mid-September!


#### Subset The Data
If you wanted to, you could subset this data set using the same code that you used previously to subset! An example of the subsetted plot is below.

{:.input}
```python
this_daily_sum = precip_boulder_daily.query('DATE >= "2012-12-31" and DATE <= "2013-12-31"')

this_daily_sum2 = precip_boulder_daily[precip_boulder_daily.HPCP_round != 0]
```

{:.input}
```python
fig, ax = plt.subplots()
#fig, ax = plt.subplots(figsize = (14,14))
ax.plot(this_daily_sum2.index, this_daily_sum2['HPCP_round'], 'o', color = 'purple')
ax.set(xlabel='Date', ylabel='Precipitation (Inches)',
       title="Daily Precipitation - Boulder Station\n 2012-2013");
```

{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}//images/courses/earth-analytics-python/02-intro-to-python-and-time-series-data/plot-time-series-handle-dates/2018-02-05-flood05-USGS-precip-subset-graduate-in-python_29_0.png">

</figure>



