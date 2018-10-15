---
layout: single
title: "Subset Time Series By Dates Python Using Pandas"
excerpt: "Sometimes you have data over a longer time span than you need to run analysis. Learn how to subset your data  using a begina and end date in Python."
authors: ['Leah Wasser', 'Chris Holdgraf', 'Martha Morrissey']
modified: 2018-10-08
category: [courses]
class-lesson: ['time-series-python']
course: 'earth-analytics-python'
permalink: /courses/earth-analytics-python/use-time-series-data-in-python/subset-time-series-data-python/
nav-title: 'Subset time series data in Python'
week: 3
sidebar:
  nav:
author_profile: false
comments: true
order: 2
topics:
  reproducible-science-and-programming: ['python']
  time-series:
  data-exploration-and-analysis: ['data-visualization']
---
{% include toc title="In This Lesson" icon="file-text" %}

In this lesson, you learn how to subset time series data into Python. You will also test the skills that you learned in the previous lessons to handle dates and missing data in `Python`. 

<div class='notice--success' markdown="1">

## <i class="fa fa-graduation-cap" aria-hidden="true"></i> Learning Objectives

After completing this tutorial, you will be able to:

* Subset time series data by dates 

## <i class="fa fa-check-square-o fa-2" aria-hidden="true"></i> What You Need

You need `Python 3.x` and `Jupyter notebooks` to complete this tutorial. Also you should have
an `earth-analytics` directory setup on your computer with a `/data`
directory with it.

{% include/data_subsets/course_earth_analytics/_data-colorado-flood.md %}

</div>


## About The NOAA Precipitation Data Used In This Lesson

To complete this lesson, you will use a slightly modified version of precipitation data downloaded through the <a href="https://www.ncdc.noaa.gov/cdo-web/search" target ="_blank">National Centers for Environmental Information (formerly National Climate Data Center) Cooperative Observer Network (COOP) </a> station 050843 in Boulder, CO. The data were collected : 1 January 2003 through 31 December 2013.

Your instructor has modified these data as follows for this lesson:

* aggregated the data to represent daily sum values
* added some `noData` values to allow you to practice handing missing data
* added several columns to this data that would not usually be there if you downloaded it directly. 

The added columns include:

* Year
* Julian day

### How Is Precipitation Measured? 

Precipitation can be measured using different types of gages. Some gages are manually read and emptied. Others gages automatically record the amount of precipitation collected. If the precipitation is in a frozen form (snow, hail, freezing rain) then the contents of the gage are melted to get the water equivalency for measurement. Rainfall is generally reported as the total amount of rain (millimeters, centimeters, or inches) over a given period of time.

<i class="fa fa-star"></i> **Data Tip:** Precipitation is the moisture that falls from clouds including rain, hail and snow.
{: .notice--success }

Boulder, Colorado lays on the eastern edge of the Rocky Mountains where they meet the high plains. The average annual precipitation is near 20”. However, the precipitation comes in many forms including winter snow, intense summer thunderstorms, and intermittent storms throughout the year.

### Use Precipitation Time Series Data in Python

You can use precipitation data to understand events like the 2013 floods that occurred in Colorado. However to work with these data in Python, you need to know how to do a few things:

1. Open a `.csv` file in Python
1. Ensure dates are read as a date/time format in python
1. Handle missing data values appropriately

It's also useful to know how to subset the data by time periods when analyzing and plotting. 

You've already learned how to open a `.csv` and how to handle dates. In this lesson you will use these skills and learn how to subset the data by time. 


## Get Started With Time Series Data
Get started by loading the required python libraries into your Jupyter notebook. 

{:.input}
```python
# load python libraries
import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
import os
plt.ion()

import earthpy as et 
# set working directory
os.chdir(os.path.join(et.io.HOME, 'earth-analytics'))

# set standard plot parameters for uniform plotting
plt.rcParams['figure.figsize'] = (8, 8)

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
# read the data into python
boulder_daily_precip = pd.read_csv('data/colorado-flood/precipitation/805325-precip-dailysum-2003-2013.csv', 
                                   parse_dates=['DATE'],
                                  na_values = ['999.99'])
# view first 5 rows
boulder_daily_precip.head()
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
      <th>DATE</th>
      <th>DAILY_PRECIP</th>
      <th>STATION</th>
      <th>STATION_NAME</th>
      <th>ELEVATION</th>
      <th>LATITUDE</th>
      <th>LONGITUDE</th>
      <th>YEAR</th>
      <th>JULIAN</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>2003-01-01</td>
      <td>0.0</td>
      <td>COOP:050843</td>
      <td>BOULDER 2 CO US</td>
      <td>1650.5</td>
      <td>40.03389</td>
      <td>-105.28111</td>
      <td>2003</td>
      <td>1</td>
    </tr>
    <tr>
      <th>1</th>
      <td>2003-01-05</td>
      <td>NaN</td>
      <td>COOP:050843</td>
      <td>BOULDER 2 CO US</td>
      <td>1650.5</td>
      <td>40.03389</td>
      <td>-105.28111</td>
      <td>2003</td>
      <td>5</td>
    </tr>
    <tr>
      <th>2</th>
      <td>2003-02-01</td>
      <td>0.0</td>
      <td>COOP:050843</td>
      <td>BOULDER 2 CO US</td>
      <td>1650.5</td>
      <td>40.03389</td>
      <td>-105.28111</td>
      <td>2003</td>
      <td>32</td>
    </tr>
    <tr>
      <th>3</th>
      <td>2003-02-02</td>
      <td>NaN</td>
      <td>COOP:050843</td>
      <td>BOULDER 2 CO US</td>
      <td>1650.5</td>
      <td>40.03389</td>
      <td>-105.28111</td>
      <td>2003</td>
      <td>33</td>
    </tr>
    <tr>
      <th>4</th>
      <td>2003-02-03</td>
      <td>0.4</td>
      <td>COOP:050843</td>
      <td>BOULDER 2 CO US</td>
      <td>1650.5</td>
      <td>40.03389</td>
      <td>-105.28111</td>
      <td>2003</td>
      <td>34</td>
    </tr>
  </tbody>
</table>
</div>





It's always a good idea to explore the data before working with it. 

{:.input}
```python
# view structure of data
boulder_daily_precip.dtypes
```

{:.output}
{:.execute_result}



    DATE            datetime64[ns]
    DAILY_PRECIP           float64
    STATION                 object
    STATION_NAME            object
    ELEVATION              float64
    LATITUDE               float64
    LONGITUDE              float64
    YEAR                     int64
    JULIAN                   int64
    dtype: object





{:.input}
```python
# view data summary statistics for all columns
boulder_daily_precip.describe()
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
      <th>DAILY_PRECIP</th>
      <th>ELEVATION</th>
      <th>LATITUDE</th>
      <th>LONGITUDE</th>
      <th>YEAR</th>
      <th>JULIAN</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>count</th>
      <td>788.000000</td>
      <td>792.0</td>
      <td>792.000000</td>
      <td>792.000000</td>
      <td>792.000000</td>
      <td>792.000000</td>
    </tr>
    <tr>
      <th>mean</th>
      <td>0.247843</td>
      <td>1650.5</td>
      <td>40.033850</td>
      <td>-105.281106</td>
      <td>2007.967172</td>
      <td>175.541667</td>
    </tr>
    <tr>
      <th>std</th>
      <td>0.462558</td>
      <td>0.0</td>
      <td>0.000045</td>
      <td>0.000005</td>
      <td>3.149287</td>
      <td>98.536373</td>
    </tr>
    <tr>
      <th>min</th>
      <td>0.000000</td>
      <td>1650.5</td>
      <td>40.033800</td>
      <td>-105.281110</td>
      <td>2003.000000</td>
      <td>1.000000</td>
    </tr>
    <tr>
      <th>25%</th>
      <td>0.100000</td>
      <td>1650.5</td>
      <td>40.033800</td>
      <td>-105.281110</td>
      <td>2005.000000</td>
      <td>96.000000</td>
    </tr>
    <tr>
      <th>50%</th>
      <td>0.100000</td>
      <td>1650.5</td>
      <td>40.033890</td>
      <td>-105.281110</td>
      <td>2008.000000</td>
      <td>167.000000</td>
    </tr>
    <tr>
      <th>75%</th>
      <td>0.300000</td>
      <td>1650.5</td>
      <td>40.033890</td>
      <td>-105.281100</td>
      <td>2011.000000</td>
      <td>255.250000</td>
    </tr>
    <tr>
      <th>max</th>
      <td>9.800000</td>
      <td>1650.5</td>
      <td>40.033890</td>
      <td>-105.281100</td>
      <td>2013.000000</td>
      <td>365.000000</td>
    </tr>
  </tbody>
</table>
</div>





### About the Data

Viewing the structure of these data, you can see that different types of data are included in
this file.

* **STATION** and **STATION_NAME**: Identification of the COOP station.
* **ELEVATION, LATITUDE** and **LONGITUDE**: The spatial location of the station.
* **DATE**: The date when the data were collected in the format: YYYYMMDD. Notice that `DATE` is a `datetime64` because you used the `parse_date` function on the date column when the csv was first read in. 
* **DAILY_PRECIP**: The total precipitation in inches. Important: the meta data notes that the value 999.99 indicates missing data. Also important,hours with no precipitation are not recorded.
* **YEAR**: the year the data were collected
* **JULIAN**: the JULIAN DAY the data were collected.

Additional information about the data, known as metadata, is available in the
<a href="https://ndownloader.figshare.com/files/7283453">PRECIP_HLY_documentation.pdf</a>.
The metadata tell us that the noData value for these data is 999.99. IMPORTANT:
your instructor has modified these data a bit for ease of teaching and learning. Specifically,
she aggregated the data to represent daily sum values and added some noData
values to ensure you learn how to clean them.

<i class="fa fa-star"></i> **Data Tip** You can download the original complete data subset with additional documentation
<a href="https://figshare.com/articles/NEON_Remote_Sensing_Boulder_Flood_2013_Teaching_Data_Subset_Lee_Hill_Road/3146284">here. </a>
{: .notice--success }


## Subset Data Temporally in Pandas

There are many ways to subset the data temporally in Python. The easiest way to do this is to use pandas.
Pandas natively understands time operations if 

1. you tell it what column contains your time stamps and 
2. you set the date column of your data to be the index of the dataframe 

Both of these steps can be included in your read_csv import by adding the arguments:

`parse_dates` and
`index_col`

as done below. Note that for each argument, the column that contains the time stamps is specified. 


{:.input}
```python
# read the data into python setting date as an index
boulder_daily_precip = pd.read_csv('data/colorado-flood/precipitation/805325-precip-dailysum-2003-2013.csv', 
                                   parse_dates=['DATE'],
                                  na_values = ['999.99'],
                                  index_col = 'DATE')
```

Now the magic happens! Once you have specified an index column, your data frame looks like the one below when printed. Notice that the DATE column is lower visually then the other column names. It's also on the LEFT hand side of the dataframe. This is because it is now an index. 


{:.input}
```python
boulder_daily_precip.head()
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
      <th>DAILY_PRECIP</th>
      <th>STATION</th>
      <th>STATION_NAME</th>
      <th>ELEVATION</th>
      <th>LATITUDE</th>
      <th>LONGITUDE</th>
      <th>YEAR</th>
      <th>JULIAN</th>
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
      <th>2003-01-01</th>
      <td>0.0</td>
      <td>COOP:050843</td>
      <td>BOULDER 2 CO US</td>
      <td>1650.5</td>
      <td>40.03389</td>
      <td>-105.28111</td>
      <td>2003</td>
      <td>1</td>
    </tr>
    <tr>
      <th>2003-01-05</th>
      <td>NaN</td>
      <td>COOP:050843</td>
      <td>BOULDER 2 CO US</td>
      <td>1650.5</td>
      <td>40.03389</td>
      <td>-105.28111</td>
      <td>2003</td>
      <td>5</td>
    </tr>
    <tr>
      <th>2003-02-01</th>
      <td>0.0</td>
      <td>COOP:050843</td>
      <td>BOULDER 2 CO US</td>
      <td>1650.5</td>
      <td>40.03389</td>
      <td>-105.28111</td>
      <td>2003</td>
      <td>32</td>
    </tr>
    <tr>
      <th>2003-02-02</th>
      <td>NaN</td>
      <td>COOP:050843</td>
      <td>BOULDER 2 CO US</td>
      <td>1650.5</td>
      <td>40.03389</td>
      <td>-105.28111</td>
      <td>2003</td>
      <td>33</td>
    </tr>
    <tr>
      <th>2003-02-03</th>
      <td>0.4</td>
      <td>COOP:050843</td>
      <td>BOULDER 2 CO US</td>
      <td>1650.5</td>
      <td>40.03389</td>
      <td>-105.28111</td>
      <td>2003</td>
      <td>34</td>
    </tr>
  </tbody>
</table>
</div>





Also notice if you look at the structure of your dataframe, that the DATE column isn't rendered.
But if you call `boulder_daily_precip.index` you will find it.

{:.input}
```python
# your date column that is the index now is not listed below
boulder_daily_precip.dtypes
```

{:.output}
{:.execute_result}



    DAILY_PRECIP    float64
    STATION          object
    STATION_NAME     object
    ELEVATION       float64
    LATITUDE        float64
    LONGITUDE       float64
    YEAR              int64
    JULIAN            int64
    dtype: object





{:.input}
```python
# access the index of your dataframe
boulder_daily_precip.index
```

{:.output}
{:.execute_result}



    DatetimeIndex(['2003-01-01', '2003-01-05', '2003-02-01', '2003-02-02',
                   '2003-02-03', '2003-02-05', '2003-02-06', '2003-02-07',
                   '2003-02-10', '2003-02-18',
                   ...
                   '2013-11-01', '2013-11-09', '2013-11-21', '2013-11-27',
                   '2013-12-01', '2013-12-04', '2013-12-22', '2013-12-23',
                   '2013-12-29', '2013-12-31'],
                  dtype='datetime64[ns]', name='DATE', length=792, freq=None)





Once you have a dataframe setup with an index, you can begin to subset your data using the syntax:

data-frame-name['index -period-here']

{:.input}
```python
# below you subset all of the data for 2013 - the first 5 rows are shown
boulder_daily_precip['2013'].head()

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
      <th>DAILY_PRECIP</th>
      <th>STATION</th>
      <th>STATION_NAME</th>
      <th>ELEVATION</th>
      <th>LATITUDE</th>
      <th>LONGITUDE</th>
      <th>YEAR</th>
      <th>JULIAN</th>
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
      <th>2013-01-01</th>
      <td>0.0</td>
      <td>COOP:050843</td>
      <td>BOULDER 2 CO US</td>
      <td>1650.5</td>
      <td>40.0338</td>
      <td>-105.2811</td>
      <td>2013</td>
      <td>1</td>
    </tr>
    <tr>
      <th>2013-01-28</th>
      <td>0.1</td>
      <td>COOP:050843</td>
      <td>BOULDER 2 CO US</td>
      <td>1650.5</td>
      <td>40.0338</td>
      <td>-105.2811</td>
      <td>2013</td>
      <td>28</td>
    </tr>
    <tr>
      <th>2013-01-29</th>
      <td>0.1</td>
      <td>COOP:050843</td>
      <td>BOULDER 2 CO US</td>
      <td>1650.5</td>
      <td>40.0338</td>
      <td>-105.2811</td>
      <td>2013</td>
      <td>29</td>
    </tr>
    <tr>
      <th>2013-02-01</th>
      <td>0.0</td>
      <td>COOP:050843</td>
      <td>BOULDER 2 CO US</td>
      <td>1650.5</td>
      <td>40.0338</td>
      <td>-105.2811</td>
      <td>2013</td>
      <td>32</td>
    </tr>
    <tr>
      <th>2013-02-14</th>
      <td>0.1</td>
      <td>COOP:050843</td>
      <td>BOULDER 2 CO US</td>
      <td>1650.5</td>
      <td>40.0338</td>
      <td>-105.2811</td>
      <td>2013</td>
      <td>45</td>
    </tr>
  </tbody>
</table>
</div>





You can subset within a date range using the syntax below.

{:.input}
```python
# you can subset this way
boulder_daily_precip['2013-05-01':'2013-06-06']
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
      <th>DAILY_PRECIP</th>
      <th>STATION</th>
      <th>STATION_NAME</th>
      <th>ELEVATION</th>
      <th>LATITUDE</th>
      <th>LONGITUDE</th>
      <th>YEAR</th>
      <th>JULIAN</th>
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
      <th>2013-05-01</th>
      <td>1.4</td>
      <td>COOP:050843</td>
      <td>BOULDER 2 CO US</td>
      <td>1650.5</td>
      <td>40.0338</td>
      <td>-105.2811</td>
      <td>2013</td>
      <td>121</td>
    </tr>
    <tr>
      <th>2013-05-02</th>
      <td>0.1</td>
      <td>COOP:050843</td>
      <td>BOULDER 2 CO US</td>
      <td>1650.5</td>
      <td>40.0338</td>
      <td>-105.2811</td>
      <td>2013</td>
      <td>122</td>
    </tr>
    <tr>
      <th>2013-05-08</th>
      <td>0.4</td>
      <td>COOP:050843</td>
      <td>BOULDER 2 CO US</td>
      <td>1650.5</td>
      <td>40.0338</td>
      <td>-105.2811</td>
      <td>2013</td>
      <td>128</td>
    </tr>
    <tr>
      <th>2013-05-09</th>
      <td>0.5</td>
      <td>COOP:050843</td>
      <td>BOULDER 2 CO US</td>
      <td>1650.5</td>
      <td>40.0338</td>
      <td>-105.2811</td>
      <td>2013</td>
      <td>129</td>
    </tr>
    <tr>
      <th>2013-05-20</th>
      <td>0.1</td>
      <td>COOP:050843</td>
      <td>BOULDER 2 CO US</td>
      <td>1650.5</td>
      <td>40.0338</td>
      <td>-105.2811</td>
      <td>2013</td>
      <td>140</td>
    </tr>
    <tr>
      <th>2013-05-23</th>
      <td>0.1</td>
      <td>COOP:050843</td>
      <td>BOULDER 2 CO US</td>
      <td>1650.5</td>
      <td>40.0338</td>
      <td>-105.2811</td>
      <td>2013</td>
      <td>143</td>
    </tr>
    <tr>
      <th>2013-05-29</th>
      <td>0.1</td>
      <td>COOP:050843</td>
      <td>BOULDER 2 CO US</td>
      <td>1650.5</td>
      <td>40.0338</td>
      <td>-105.2811</td>
      <td>2013</td>
      <td>149</td>
    </tr>
    <tr>
      <th>2013-06-01</th>
      <td>0.0</td>
      <td>COOP:050843</td>
      <td>BOULDER 2 CO US</td>
      <td>1650.5</td>
      <td>40.0338</td>
      <td>-105.2811</td>
      <td>2013</td>
      <td>152</td>
    </tr>
    <tr>
      <th>2013-06-05</th>
      <td>0.1</td>
      <td>COOP:050843</td>
      <td>BOULDER 2 CO US</td>
      <td>1650.5</td>
      <td>40.0338</td>
      <td>-105.2811</td>
      <td>2013</td>
      <td>156</td>
    </tr>
  </tbody>
</table>
</div>





For this example, subset the data to the time period: **January 1 2003 - October 31 2003**.

{:.input}
```python
# subset the data to a date range
precip_boulder_AugOct = boulder_daily_precip['2003-01-01':'2003-10-31']
# did it work? 
print(precip_boulder_AugOct.index.min())
print(precip_boulder_AugOct.index.max())
```

{:.output}
    2003-01-01 00:00:00
    2003-10-31 00:00:00



## Plot Subsetted Data

Once you've subsetted the data, you can plot the data to focus in on the new time period. Note that
you need to call `.index` to access the date column which is now an index rather than a regular index.

You can see that in the plot call below:

```python
ax.scatter(precip_boulder_AugOct.index.values, 
       precip_boulder_AugOct['DAILY_PRECIP'].values, 
       color = 'purple')
```

You are now ready to plot your data. 


{:.input}
```python
# plot the data
fig, ax = plt.subplots(figsize = (8,8))
ax.scatter(precip_boulder_AugOct.index.values, 
       precip_boulder_AugOct['DAILY_PRECIP'].values, 
       color = 'purple')

# add titles and format 
ax.set_title('Daily Total Precipitation \nAug - Oct 2013 for Boulder Creek')
ax.set_xlabel('Date')
ax.set_ylabel('Precipitation (Inches)');
```

{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}//images/courses/earth-analytics-python/03-intro-to-python-and-time-series-data/plot-time-series-handle-dates/2018-02-05-ts02-subset-plot-time-series-data-python_24_0.png" alt = "Scatterplot showing daily total precipitation for Boulder Creek.">
<figcaption>Scatterplot showing daily total precipitation for Boulder Creek.</figcaption>

</figure>




The plot above appears to be subsetted correctly in time. However the plot itself looks off. 
Any ideas what is going on? Complete the challenge below to test your knowledge.

<div class="notice--warning" markdown="1">

## <i class="fa fa-pencil-square-o" aria-hidden="true"></i> Optional challenge

Using everything you've learned in the previous lessons:

* Import the dataset: `data/week2/precipitation/805325-precip-dailysum-2003-2013.csv`
* Clean the data by assigning `noData` values to `nan`
* Make sure the date column is a `date` class
* Plot your data

Some notes to help you along:

* Date: be sure to take of the date format when you import the data.
* `NoData Values`: You know that the `no data value = 999.99`. You can account for this when you read in the data. Remember how?

Your final plot should look something like the plot below.
</div>


{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}//images/courses/earth-analytics-python/03-intro-to-python-and-time-series-data/plot-time-series-handle-dates/2018-02-05-ts02-subset-plot-time-series-data-python_26_0.png" alt = "Scatterplot of hourly precipitation for Boulder subsetted to 2003-2013.">
<figcaption>Scatterplot of hourly precipitation for Boulder subsetted to 2003-2013.</figcaption>

</figure>




<div class="notice--warning" markdown="1">

## <i class="fa fa-pencil-square-o" aria-hidden="true"></i> Optional Challenge 

Create plots for the following time subsets in the data before and after the flood:

Time period A: 2012-08-01 to 2012-11-01
Time period B: 2013-08-01 to 2013-11-01

When you create your plot, be sure to set the y limits to be the same for both plots so they are 
visually comparable..

How different was the rainfall in 2012 compared to 2013?

</div>


{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}//images/courses/earth-analytics-python/03-intro-to-python-and-time-series-data/plot-time-series-handle-dates/2018-02-05-ts02-subset-plot-time-series-data-python_28_0.png" alt = "Comparison of precipitation data in Boulder, CO from 2012 and 2013.">
<figcaption>Comparison of precipitation data in Boulder, CO from 2012 and 2013.</figcaption>

</figure>





<div class="notice--info" markdown="1">

## Additional Resources


* <a href="https://jakevdp.github.io/PythonDataScienceHandbook/03.11-working-with-time-series.html" target = "_blank">Time Series Data - Data Science Handbook</a>
</div>
