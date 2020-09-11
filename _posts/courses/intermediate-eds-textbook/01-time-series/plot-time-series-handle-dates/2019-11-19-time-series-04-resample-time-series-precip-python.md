---
layout: single
title: "Resample or Summarize Time Series Data in Python With Pandas - Hourly to Daily Summary"
excerpt: "Sometimes you need to take time series data collected at a higher resolution (for instance many times a day) and summarize it to a daily, weekly or even monthly value. This process is called resampling in Python and can be done using pandas dataframes. Learn how to resample time series data in Python with Pandas."
authors: ['Leah Wasser', 'Jenny Palomino', 'Chris Holdgraf', 'Martha Morrissey']
modified: 2020-09-11
category: [courses]
class-lesson: ['time-series-python-tb']
course: 'intermediate-earth-data-science-textbook'
week: 1
permalink: /courses/use-data-open-source-python/use-time-series-data-in-python/date-time-types-in-pandas-python/resample-time-series-data-pandas-python/
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
redirect_from:
  - "/courses/earth-analytics-python/use-time-series-data-in-python/resample-time-series-data-pandas-python/"
  - "/courses/use-data-open-source-python/use-time-series-data-in-python/resample-time-series-data-pandas-python/"
---

{% include toc title="On This Page" icon="file-text" %}

<div class='notice--success' markdown="1">

## <i class="fa fa-graduation-cap" aria-hidden="true"></i> Learning Objectives

* Resample time series data from hourly to daily, monthly, or yearly using **pandas**.

</div>


## Resample Time Series Data Using Pandas Dataframes

Often you need to summarize or aggregate time series data by a new time period. For instance, you may want to summarize hourly data to provide a daily maximum value. 

This process of changing the time period that data are summarized for is often called resampling. 

Lucky for you, there is a nice `resample()` method for **pandas** dataframes that have a `datetime` index.

On this page, you will learn how to use this `resample()` method to aggregate time series data by a new time period (e.g. daily to monthly).  


### Import Packages and Get Data

You will use the precipitation data from the <a href="https://www.ncdc.noaa.gov/cdo-web/search" target ="_blank">National Centers for Environmental Information (formerly National Climate Data Center) Cooperative Observer Network (COOP)</a> that you used previously in this chapter. 

This time, however, you will use the hourly data that was not aggregated to a daily sum: 

`805333-precip-daily-1948-2013.csv` 

This dataset contains the precipitation values collected hourly from the COOP station 050843 in Boulder, CO for January 1, 1948 through December 31, 2013. This means that there are sometimes multiple values collected for each day if it happened to rain throughout the day. 

Before using the data, consider a few things about how it was collected: 
1. The data were collected over several decades, and the data were not always collected consistently.
2. The data are not cleaned. You may find heading names that are not meaningful, and other issues with the data that need to be explored.

To begin, import the necessary packages to work with **pandas** dataframe and download data. 

You will continue to work with modules from **pandas** and **matplotlib** to plot dates more efficiently and with <a href="https://seaborn.pydata.org/introduction.html" target="_blank">**seaborn**</a> to make more attractive plots. 

{:.input}
```python
# Import necessary packages
import os
import matplotlib.pyplot as plt
import seaborn as sns
import pandas as pd
import earthpy as et

# Handle date time conversions between pandas and matplotlib
from pandas.plotting import register_matplotlib_converters
register_matplotlib_converters()

# Use white grid plot background from seaborn
sns.set(font_scale=1.5, style="whitegrid")
```

{:.input}
```python
# Download the data
data = et.data.get_data('colorado-flood')
```

{:.input}
```python
# Set working directory
os.chdir(os.path.join(et.io.HOME, 'earth-analytics'))

# Define relative path to file with hourly precip
file_path = os.path.join("data", "colorado-flood",
                         "precipitation",
                         "805325-precip-daily-2003-2013.csv")
```

Just as before, when you import the file to a **pandas** dataframe, be sure to specify the:
* no data values using the parameter `na_values`
* date column using the parameter `parse_dates`
* datetime index using the parameter `index_col`

{:.input}
```python
# Import data using datetime and no data value
precip_2003_2013_hourly = pd.read_csv(file_path,
                                      parse_dates=['DATE'],
                                      index_col=['DATE'],
                                      na_values=['999.99'])

# View first few rows
precip_2003_2013_hourly.head()
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





### About the Precipitation Data

The structure of the data is similar to what you saw in previous lessons. The `HPCP` column contains the total precipitation given in inches, recorded for the hour ending at the time specified by `DATE`. 

There is a designated missing data value of `999.99`. Note that if there is no precipitation recorded in a particular hour, then no value is recorded.

Additional information about the data, known as metadata, is available in the
<a href="https://ndownloader.figshare.com/files/7283453">PRECIP_HLY_documentation.pdf</a>.

Note, as of Sept. 2016, there is a mismatch in the data downloaded and the documentation. The differences are in the units and corresponding no data value: 999.99 for inches or 25399.75 for millimeters.

Once again, explore the data before you begin to work with it.

{:.input}
```python
# View dataframe info
precip_2003_2013_hourly.info()
```

{:.output}
    <class 'pandas.core.frame.DataFrame'>
    DatetimeIndex: 1840 entries, 2003-01-01 01:00:00 to 2013-12-31 00:00:00
    Data columns (total 8 columns):
     #   Column            Non-Null Count  Dtype  
    ---  ------            --------------  -----  
     0   STATION           1840 non-null   object 
     1   STATION_NAME      1840 non-null   object 
     2   ELEVATION         1840 non-null   float64
     3   LATITUDE          1840 non-null   float64
     4   LONGITUDE         1840 non-null   float64
     5   HPCP              1746 non-null   float64
     6   Measurement Flag  1840 non-null   object 
     7   Quality Flag      1840 non-null   object 
    dtypes: float64(4), object(4)
    memory usage: 129.4+ KB



{:.input}
```python
# View summary statistics
precip_2003_2013_hourly.describe()
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
      <th>ELEVATION</th>
      <th>LATITUDE</th>
      <th>LONGITUDE</th>
      <th>HPCP</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>count</th>
      <td>1840.0</td>
      <td>1840.000000</td>
      <td>1840.000000</td>
      <td>1746.000000</td>
    </tr>
    <tr>
      <th>mean</th>
      <td>1650.5</td>
      <td>40.033851</td>
      <td>-105.281106</td>
      <td>0.111856</td>
    </tr>
    <tr>
      <th>std</th>
      <td>0.0</td>
      <td>0.000045</td>
      <td>0.000005</td>
      <td>0.093222</td>
    </tr>
    <tr>
      <th>min</th>
      <td>1650.5</td>
      <td>40.033800</td>
      <td>-105.281110</td>
      <td>0.000000</td>
    </tr>
    <tr>
      <th>25%</th>
      <td>1650.5</td>
      <td>40.033800</td>
      <td>-105.281110</td>
      <td>0.100000</td>
    </tr>
    <tr>
      <th>50%</th>
      <td>1650.5</td>
      <td>40.033890</td>
      <td>-105.281110</td>
      <td>0.100000</td>
    </tr>
    <tr>
      <th>75%</th>
      <td>1650.5</td>
      <td>40.033890</td>
      <td>-105.281100</td>
      <td>0.100000</td>
    </tr>
    <tr>
      <th>max</th>
      <td>1650.5</td>
      <td>40.033890</td>
      <td>-105.281100</td>
      <td>2.200000</td>
    </tr>
  </tbody>
</table>
</div>





{:.input}
```python
# View index values of dataframe
precip_2003_2013_hourly.index
```

{:.output}
{:.execute_result}



    DatetimeIndex(['2003-01-01 01:00:00', '2003-02-01 01:00:00',
                   '2003-02-02 19:00:00', '2003-02-02 22:00:00',
                   '2003-02-03 02:00:00', '2003-02-05 02:00:00',
                   '2003-02-05 08:00:00', '2003-02-06 00:00:00',
                   '2003-02-07 12:00:00', '2003-02-10 13:00:00',
                   ...
                   '2013-12-01 01:00:00', '2013-12-03 20:00:00',
                   '2013-12-04 03:00:00', '2013-12-04 06:00:00',
                   '2013-12-04 09:00:00', '2013-12-22 01:00:00',
                   '2013-12-23 00:00:00', '2013-12-23 02:00:00',
                   '2013-12-29 01:00:00', '2013-12-31 00:00:00'],
                  dtype='datetime64[ns]', name='DATE', length=1840, freq=None)





## Plot Hourly Precipitation Data

Plot the hourly data and notice that there are often multiple records for a single day. 

{:.input}
```python
# Create figure and plot space
fig, ax = plt.subplots(figsize=(10, 10))

# Add x-axis and y-axis
ax.scatter(precip_2003_2013_hourly.index.values,
           precip_2003_2013_hourly['HPCP'],
           color='purple')

# Set title and labels for axes
ax.set(xlabel="Date",
       ylabel="Precipitation (inches)",
       title="Hourly Precipitation - Boulder Station\n 2003-2013")

plt.show()
```

{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}/images/courses/intermediate-eds-textbook/01-time-series/plot-time-series-handle-dates/2019-11-19-time-series-04-resample-time-series-precip-python/2019-11-19-time-series-04-resample-time-series-precip-python_12_0.png" alt = "Scatter plot showing hourly precipitation for Boulder, CO from 2003 to 2013.">
<figcaption>Scatter plot showing hourly precipitation for Boulder, CO from 2003 to 2013.</figcaption>

</figure>




Also, notice that the plot is not displaying each individual hourly timestamp, but rather, has aggregated the x-axis labels to the year. (On the next page, you will learn how to customize these labels!)


## Resample Hourly Data to Daily Data

To simplify your plot which has a lot of data points due to the hourly records, you can aggregate the data for each day using the `.resample()` method.

To aggregate or temporal resample the data for a time period, you can take all of the values for each day and summarize them.

In this case, you want total daily rainfall, so you will use the `resample()` method together with `.sum()`.

As previously mentioned, `resample()` is a method of **pandas** dataframes that can be used to summarize data by date or time.  The `.sum()` method will add up all values for each resampling period (e.g. for each day) to provide a summary output value for that period.

As you have already set the `DATE` column as the index, **pandas** already knows what to use for the date index.

`df.resample('D').sum()`

The `'D'` specifies that you want to aggregate, or resample, by day. 

{:.input}
```python
# Resample to daily precip sum and save as new dataframe
precip_2003_2013_daily = precip_2003_2013_hourly.resample('D').sum()

precip_2003_2013_daily
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
      <th>ELEVATION</th>
      <th>LATITUDE</th>
      <th>LONGITUDE</th>
      <th>HPCP</th>
    </tr>
    <tr>
      <th>DATE</th>
      <th></th>
      <th></th>
      <th></th>
      <th></th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>2003-01-01</th>
      <td>1650.5</td>
      <td>40.03389</td>
      <td>-105.28111</td>
      <td>0.0</td>
    </tr>
    <tr>
      <th>2003-01-02</th>
      <td>0.0</td>
      <td>0.00000</td>
      <td>0.00000</td>
      <td>0.0</td>
    </tr>
    <tr>
      <th>2003-01-03</th>
      <td>0.0</td>
      <td>0.00000</td>
      <td>0.00000</td>
      <td>0.0</td>
    </tr>
    <tr>
      <th>2003-01-04</th>
      <td>0.0</td>
      <td>0.00000</td>
      <td>0.00000</td>
      <td>0.0</td>
    </tr>
    <tr>
      <th>2003-01-05</th>
      <td>0.0</td>
      <td>0.00000</td>
      <td>0.00000</td>
      <td>0.0</td>
    </tr>
    <tr>
      <th>...</th>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
    </tr>
    <tr>
      <th>2013-12-27</th>
      <td>0.0</td>
      <td>0.00000</td>
      <td>0.00000</td>
      <td>0.0</td>
    </tr>
    <tr>
      <th>2013-12-28</th>
      <td>0.0</td>
      <td>0.00000</td>
      <td>0.00000</td>
      <td>0.0</td>
    </tr>
    <tr>
      <th>2013-12-29</th>
      <td>1650.5</td>
      <td>40.03380</td>
      <td>-105.28110</td>
      <td>0.0</td>
    </tr>
    <tr>
      <th>2013-12-30</th>
      <td>0.0</td>
      <td>0.00000</td>
      <td>0.00000</td>
      <td>0.0</td>
    </tr>
    <tr>
      <th>2013-12-31</th>
      <td>1650.5</td>
      <td>40.03380</td>
      <td>-105.28110</td>
      <td>0.0</td>
    </tr>
  </tbody>
</table>
<p>4018 rows × 4 columns</p>
</div>





Now that you have resampled the data, each HPCP value now represents a daily total or sum of all precipitation measured that day. Also notice that your `DATE` index no longer contains hourly time stamps, as you now have only one summary value or row per day. 

<div class='notice--success' markdown="1">

<i class="fa fa-star"></i> **Data Tip:** You can also resample using the syntax below if you have not already set the DATE column as an index during the import process. 

```python
# Set date column as index 
precip_hourly_index = precip_hourly.set_index('DATE')

# Resample to daily sum of precip
precip_daily = precip_hourly_index.resample('D').sum()
```
{: .notice--success}

</div>


### Plot Daily Precipitation Data

Plot the aggregated dataframe for daily total precipitation and notice that the y axis has increased in range and that there is only one data point for each day (though there are still quite a lot of points!). 

{:.input}
```python
# Create figure and plot space
fig, ax = plt.subplots(figsize=(10, 10))

# Add x-axis and y-axis
ax.scatter(precip_2003_2013_daily.index.values,
           precip_2003_2013_daily['HPCP'],
           color='purple')

# Set title and labels for axes
ax.set(xlabel="Date",
       ylabel="Precipitation (inches)",
       title="Daily Precipitation - Boulder Station\n 2003-2013")

plt.show()
```

{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}/images/courses/intermediate-eds-textbook/01-time-series/plot-time-series-handle-dates/2019-11-19-time-series-04-resample-time-series-precip-python/2019-11-19-time-series-04-resample-time-series-precip-python_18_0.png" alt = "Scatter plot of daily total precipitation subsetted 2003-2013.">
<figcaption>Scatter plot of daily total precipitation subsetted 2003-2013.</figcaption>

</figure>




## Resample Daily Data to Monthly Data

You can use the same syntax to resample the data again, this time from daily to monthly using:

`df.resample('M').sum()`

with `'M'` specifying that you want to aggregate, or resample, by month.

{:.input}
```python
# Resample to monthly precip sum and save as new dataframe
precip_2003_2013_monthly = precip_2003_2013_daily.resample('M').sum()

precip_2003_2013_monthly
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
      <th>ELEVATION</th>
      <th>LATITUDE</th>
      <th>LONGITUDE</th>
      <th>HPCP</th>
    </tr>
    <tr>
      <th>DATE</th>
      <th></th>
      <th></th>
      <th></th>
      <th></th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>2003-01-31</th>
      <td>1650.5</td>
      <td>40.03389</td>
      <td>-105.28111</td>
      <td>0.0</td>
    </tr>
    <tr>
      <th>2003-02-28</th>
      <td>26408.0</td>
      <td>640.54224</td>
      <td>-1684.49776</td>
      <td>1.4</td>
    </tr>
    <tr>
      <th>2003-03-31</th>
      <td>74272.5</td>
      <td>1801.52505</td>
      <td>-4737.64995</td>
      <td>5.2</td>
    </tr>
    <tr>
      <th>2003-04-30</th>
      <td>28058.5</td>
      <td>680.57613</td>
      <td>-1789.77887</td>
      <td>1.6</td>
    </tr>
    <tr>
      <th>2003-05-31</th>
      <td>34660.5</td>
      <td>840.71169</td>
      <td>-2210.90331</td>
      <td>3.3</td>
    </tr>
    <tr>
      <th>...</th>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
    </tr>
    <tr>
      <th>2013-08-31</th>
      <td>14854.5</td>
      <td>360.30420</td>
      <td>-947.52990</td>
      <td>1.0</td>
    </tr>
    <tr>
      <th>2013-09-30</th>
      <td>118836.0</td>
      <td>2882.43360</td>
      <td>-7580.23920</td>
      <td>17.7</td>
    </tr>
    <tr>
      <th>2013-10-31</th>
      <td>31359.5</td>
      <td>760.64220</td>
      <td>-2000.34090</td>
      <td>2.0</td>
    </tr>
    <tr>
      <th>2013-11-30</th>
      <td>8252.5</td>
      <td>200.16900</td>
      <td>-526.40550</td>
      <td>0.4</td>
    </tr>
    <tr>
      <th>2013-12-31</th>
      <td>16505.0</td>
      <td>400.33800</td>
      <td>-1052.81100</td>
      <td>0.5</td>
    </tr>
  </tbody>
</table>
<p>132 rows × 4 columns</p>
</div>





Once again, notice that now that you have resampled the data, each HPCP value now represents a monthly total and that you have only one summary value for each month.

### Plot Monthly Precipitation Data

Plot the aggregated dataframe for monthly total precipitation and notice that the y axis has again increased in range and that there is only one data point for each month. 

{:.input}
```python
# Create figure and plot space
fig, ax = plt.subplots(figsize=(10, 10))

# Add x-axis and y-axis
ax.scatter(precip_2003_2013_monthly.index.values,
           precip_2003_2013_monthly['HPCP'],
           color='purple')

# Set title and labels for axes
ax.set(xlabel="Date",
       ylabel="Precipitation (inches)",
       title="Monthly Precipitation - Boulder Station\n 2003-2013")

plt.show()
```

{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}/images/courses/intermediate-eds-textbook/01-time-series/plot-time-series-handle-dates/2019-11-19-time-series-04-resample-time-series-precip-python/2019-11-19-time-series-04-resample-time-series-precip-python_22_0.png" alt = "Scatter plot of monthly total precipitation subsetted 2003-2013.">
<figcaption>Scatter plot of monthly total precipitation subsetted 2003-2013.</figcaption>

</figure>




## Resample Monthly Data to Yearly Data

You can use the same syntax to resample the data one last time, this time from monthly to yearly using:

`df.resample('Y').sum()`

with `'Y'` specifying that you want to aggregate, or resample, by year.

{:.input}
```python
# Resample to monthly precip sum and save as new dataframe
precip_2003_2013_yearly = precip_2003_2013_monthly.resample('Y').sum()

precip_2003_2013_yearly
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
      <th>ELEVATION</th>
      <th>LATITUDE</th>
      <th>LONGITUDE</th>
      <th>HPCP</th>
    </tr>
    <tr>
      <th>DATE</th>
      <th></th>
      <th></th>
      <th></th>
      <th></th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>2003-12-31</th>
      <td>255827.5</td>
      <td>6205.25295</td>
      <td>-16318.57205</td>
      <td>17.6</td>
    </tr>
    <tr>
      <th>2004-12-31</th>
      <td>349906.0</td>
      <td>8487.18468</td>
      <td>-22319.59532</td>
      <td>22.6</td>
    </tr>
    <tr>
      <th>2005-12-31</th>
      <td>292138.5</td>
      <td>7085.99853</td>
      <td>-18634.75647</td>
      <td>16.7</td>
    </tr>
    <tr>
      <th>2006-12-31</th>
      <td>278934.5</td>
      <td>6765.72741</td>
      <td>-17792.50759</td>
      <td>16.8</td>
    </tr>
    <tr>
      <th>2007-12-31</th>
      <td>259128.5</td>
      <td>6285.32073</td>
      <td>-16529.13427</td>
      <td>15.0</td>
    </tr>
    <tr>
      <th>2008-12-31</th>
      <td>239322.5</td>
      <td>5804.91405</td>
      <td>-15265.76095</td>
      <td>14.0</td>
    </tr>
    <tr>
      <th>2009-12-31</th>
      <td>250876.0</td>
      <td>6085.13949</td>
      <td>-16002.72741</td>
      <td>14.7</td>
    </tr>
    <tr>
      <th>2010-12-31</th>
      <td>272332.5</td>
      <td>6605.57700</td>
      <td>-17371.38150</td>
      <td>17.6</td>
    </tr>
    <tr>
      <th>2011-12-31</th>
      <td>300391.0</td>
      <td>7286.15160</td>
      <td>-19161.16020</td>
      <td>17.5</td>
    </tr>
    <tr>
      <th>2012-12-31</th>
      <td>153496.5</td>
      <td>3723.14340</td>
      <td>-9791.14230</td>
      <td>9.5</td>
    </tr>
    <tr>
      <th>2013-12-31</th>
      <td>384566.5</td>
      <td>9327.87540</td>
      <td>-24530.49630</td>
      <td>33.3</td>
    </tr>
  </tbody>
</table>
</div>





After the resample, each HPCP value now represents a yearly total, and there is now only one summary value for each year.

Notice that the dates have also been updated in the dataframe as the last day of each year (e.g. 2013-12-31). This is important to note for the plot, in which the values will appear along the x axis with one value at the end of each year. 

Note that you can also resample the hourly data to a yearly timestep, without first resampling the data to a daily or monthly timestep:

```python
precip_2003_2013_yearly = precip_2003_2013_hourly.resample('Y').sum()
```

This helps to improve the efficiency of your code if you do not need the intermediate resampled timesteps (e.g. daily, monthly) for a different purpose.


### Plot Yearly Precipitation Data

To minimize your code further, you can use `precip_2003_2013_hourly.resample('Y').sum()` directly in the plot code, rather than `precip_2003_2013_yearly`, as shown below:

{:.input}
```python
# Create figure and plot space
fig, ax = plt.subplots(figsize=(10, 10))

# Add x-axis and y-axis
ax.scatter(precip_2003_2013_hourly.resample('Y').sum().index.values,
           precip_2003_2013_hourly.resample('Y').sum()['HPCP'],
           color='purple')

# Set title and labels for axes
ax.set(xlabel="Date",
       ylabel="Precipitation (inches)",
       title="Yearly Precipitation - Boulder Station\n 2003-2013")

plt.show()
```

{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}/images/courses/intermediate-eds-textbook/01-time-series/plot-time-series-handle-dates/2019-11-19-time-series-04-resample-time-series-precip-python/2019-11-19-time-series-04-resample-time-series-precip-python_26_0.png" alt = "Scatter plot of yearly total precipitation subsetted 2003-2013.">
<figcaption>Scatter plot of yearly total precipitation subsetted 2003-2013.</figcaption>

</figure>




### Think of New Applications and Uses of Resampling

Given what you have learned about resampling, how would change the code `df.resample('D').sum()` to resample the data to a weekly interval?

How about changing the code `df.resample('D').sum()` calculate a mean, minimum or maximum value, rather than a sum?
