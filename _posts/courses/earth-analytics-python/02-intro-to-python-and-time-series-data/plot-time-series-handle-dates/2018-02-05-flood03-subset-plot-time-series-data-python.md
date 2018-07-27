---
layout: single
title: "Subset and plot time series data in Python - Flooding & erosion data"
excerpt: "This lesson walks through extracting temporal subsets of time series data using the pandas subset function. In the previous lesson you learned how to convert data containing a data field into a data class. In this lesson you subset the data and create refined time series plots using matplotlib. You'll learn how to set the x and y limits on a matplotlib plot to only plot a subset of the data and how to format an axis containing dates."
authors: ['Chris Holdgraf', 'Martha Morrissey', 'Leah Wasser', 'NEON']
modified: 2018-07-27
category: [courses]
class-lesson: ['time-series-python']
course: 'earth-analytics-python'
permalink: /courses/earth-analytics-python/use-time-series-data-in-python/subset-time-series-data-python/
nav-title: 'Subset time series data in Python'
week: 2
sidebar:
  nav:
author_profile: false
comments: true
order: 3
topics:
  reproducible-science-and-programming: ['Jupyter notebook']
  time-series:
  data-exploration-and-analysis: ['data-visualization']
---
{% include toc title="In This Lesson" icon="file-text" %}


In this lesson, you learn how to subset time series data into Python. You will also test the skills that you learned in the previous lessons to handle `NaN` values and dates in `Python`. 


<div class='notice--success' markdown="1">

## <i class="fa fa-graduation-cap" aria-hidden="true"></i> Learning Objectives

After completing this tutorial, you will be able to:

* Import a text file in .csv format into Python.
* Plot quantitative time series data using matplotlib 
* Assign missing data values `NaN` in `Python` when the data are imported into Python to ensure that the data plot and can be analyzed correctly.
* Subset data temporally using the `pandas` `.query()` function 

## <i class="fa fa-check-square-o fa-2" aria-hidden="true"></i> What You Need

You need `Python 3.x` and `Jupyter notebooks` to complete this tutorial. Also you should have
an `earth-analytics` directory setup on your computer with a `/data`
directory with it.

* [Setup Conda](/courses/earth-analytics-python/get-started-with-python-jupyter/setup-conda-earth-analytics-environment/)
* [Setup your working directory](/courses/earth-analytics-python/get-started-with-python-jupyter/introduction-to-bash-shell/)
* [Intro to Jupyter Notebooks](/courses/earth-analytics-python/python-open-science-tool-box/intro-to-jupyter-notebooks/)


[<i class="fa fa-download" aria-hidden="true"></i> Download the 2013 Colorado Flood Teaching Data (~250 MB)](https://ndownloader.figshare.com/files/12395030){:data-proofer-ignore='' .btn }

</div>



## Get started with time series data
Let's get started by loading the required python libraries into your Jupyter notebook. You will be using:

* numpy # work with arrays and perform quantitative analysis
* pandas # work with data frames
* matplotlib pyplot # plot the data
* os # manage working directory paths
* urllib # import data from a url

## About The NOAA Precipitation Data Used In This Lesson

To complete this lesson, you will use a slightly modified version of precipitation data downloaded through the <a href="https://www.ncdc.noaa.gov/cdo-web/search" target ="_blank">National Centers for Environmental Information (formerly National Climate Data Center) Cooperative Observer Network (COOP) </a> station 050843 in Boulder, CO. The data were collected : 1 January 2003 through 31 December 2013.

### Data Modifications For Teaching 
Your instructor has modified these data a bit for ease of teaching and learning. She has:

* aggregated the data to represent daily sum values
* added some `noData` values to allow you to practice handing missing data
* added several columns to this data that would not usually be there if you downloaded it directly. 

The added columns include:

* Year
* Julian day

### How Is Precipitation Measured? 

Precipitation can be measured by different types of gauges; some must be manually read and emptied, others automatically record the amount of precipitation. If the precipitation is in a frozen form (snow, hail, freezing rain) the contents of the gauge must be melted to get the water equivalency for measurement. Rainfall is generally reported as the total amount of rain (millimeters, centimeters, or inches) over a given per period of time.

 * Data Tip: Precipitation is the moisture that falls from clouds including rain, hail and snow.

Boulder, Colorado lays on the eastern edge of the Rocky Mountains where they meet the high plains. The average annual precipitation is near 20”. However, the precipitation comes in many forms including winter snow, intense summer thunderstorms, and intermittent storms throughout the year.

### Use Precipitation Time Series Data in Python

You can use precipitation data to understand events like the 2013 floods that occurred in [Colorado](/courses/earth-analytics-python/01-science-toolbox/co-floods-data-example-python/co-floods-data-example-python/) However to work with these data in Python, you need to know how to do a few things:

1. Open a .csv file in Python
1. Ensure dates are read as a date/time format in python
1. Handle missing data values appropriately

It's also useful to know how to subset the data by time periods when analyzing and plotting. 

You've already learned how to open a csv and handle missing data values and date times. In this lesson you will use these skills and learn how to subset the data by time. 

### Be sure to set your working directory

`os.chdir("path-to-you-dir-here/earth-analytics/data")`

{:.input}
```python
# load python libraries
import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
import os
import urllib
plt.ion()
```

{:.input}
```python
# In the previous lesson we downloaded the data using the code below. 
#urllib.request.urlretrieve(url='https://ndownloader.figshare.com/files/7283285', 
#                           filename= 'data/week2/805325-precip-dailysum_2003-2013.csv')


# read the data into python
boulder_daily_precip = pd.read_csv('data/colorado-flood/precipitation/805325-precip-dailysum-2003-2013.csv', 
                                   parse_dates=['DATE'])
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
      <td>0.00</td>
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
      <td>999.99</td>
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
      <td>0.00</td>
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
      <td>999.99</td>
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
      <td>0.40</td>
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
# view summary stats for the precip data - note the max value
boulder_daily_precip['DAILY_PRECIP'].describe()
```

{:.output}
{:.execute_result}



    count    792.000000
    mean       5.297045
    std       70.915223
    min        0.000000
    25%        0.100000
    50%        0.100000
    75%        0.300000
    max      999.990000
    Name: DAILY_PRECIP, dtype: float64





{:.input}
```python
# view max value
boulder_daily_precip['DAILY_PRECIP'].max()
```

{:.output}
{:.execute_result}



    999.99





{:.input}
```python
# view data summary statistics for all columns
precip_boulder.describe()
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
      <td>1840.000000</td>
    </tr>
    <tr>
      <th>mean</th>
      <td>1650.5</td>
      <td>40.033851</td>
      <td>-105.281106</td>
      <td>51.192587</td>
    </tr>
    <tr>
      <th>std</th>
      <td>0.0</td>
      <td>0.000045</td>
      <td>0.000005</td>
      <td>220.208147</td>
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
      <td>999.990000</td>
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
you have modified these data a bit for ease of teaching and learning. Specifically,
you've aggregated the data to represent daily sum values and added some noData
values to ensure you learn how to clean them!

You can download the original complete data subset with additional documentation
<a href="https://figshare.com/articles/NEON_Remote_Sensing_Boulder_Flood_2013_Teaching_Data_Subset_Lee_Hill_Road/3146284">here. </a>

<div class="notice--warning" markdown="1">

## <i class="fa fa-pencil-square-o" aria-hidden="true"></i> Optional challenge

Using everything you've learned in the previous lessons:

* Import the dataset: `data/week2/precipitation/805325-precip-dailysum-2003-2013.csv`
* Clean the data by assigning noData values to `NA`
* Make sure the date column is a `date` class
* When you are done, plot it using `ggplot()`.
  * Be sure to include a TITLE, and label the X and Y axes.
  * Change the color of the plotted points

Some notes to help you along:

* Date: be sure to take of the date format when you import the data.
* `NoData Values`: You know that the `no data value = 999.99`. You can account for this when you read in the data. Remember how?

Your final plot should look something like the plot below.
</div>


{:.output}
{:.execute_result}



    Text(0,0.5,'Precipitation (Inches)')





{:.output}
{:.display_data}

![png]({{ site.url }}//images/courses/earth-analytics-python/02-intro-to-python-and-time-series-data/plot-time-series-handle-dates/2018-02-05-flood03-subset-plot-time-series-data-python_11_1.png)




<div class="notice--warning" markdown="1">
## <i class="fa fa-pencil-square-o" aria-hidden="true"></i> Optional challenge

Take a close look at the plot.

* What does each point represent?
* Use the `.min()` and `.max()` functions to determine the minimum and maximum precipitation values for the 10 year span.

</div>

## Subset the Data

You can subset the data temporally, to focus in on a shorter time period. Let's 
create a subset of data for the time period around the flood between **15
August to 15 October 2013**. You will use the pandas `.query()` function
to do this.

To subset by a range of dates, you specify the range as follows

`DATE > "2013-08-15" and DATE <= "2013-10-15"`

In the code above you are asking python to only select rows where the `DATE` value is greater than 2013-08-15 and less than 2013-10-15. 

Another way to subset is 
`discharge[(discharge['datetime'] >="2013-08-15") & (discharge['datetime'] <= "2013-10-15")]` both of these methods will yield the same result. 
In this class, all examples will be shown using `.query` method of subsetting. The rest of the examples will use the `.query` function looks which cleaner, involves less typing, and is easier to work with for more complicated queries.

{:.input}
```python
# subset the data 
precip_boulder_AugOct = boulder_daily_precip.query('DATE >= "2013-08-15" and DATE <= "2013-10-15"')
# did it work? 
print(precip_boulder_AugOct['DATE'].min())
print(precip_boulder_AugOct['DATE'].max())
```

{:.output}
    2013-08-21 00:00:00
    2013-10-11 00:00:00





## Plot subsetted data

Once you've subsetted the data, you can plot the data to focus in on the new time period.



{:.input}
```python
fig, ax = plt.subplots()
ax.bar(precip_boulder_AugOct['DATE'].values, precip_boulder_AugOct['DAILY_PRECIP'].values, color = 'purple')
ax.set(xlim=["2013-08-01", "2013-11-01"]);

# add titles and format as you see fit
fig.suptitle('Daily Total Precipitation \nAug - Oct 2013 for Boulder Creek')
plt.xlabel('Date')
plt.ylabel('Precipitation (Inches)')
plt.grid(color='grey', linestyle='-', linewidth=.5)


from matplotlib.dates import YearLocator, MonthLocator, DateFormatter
months = MonthLocator()  # every month
yearsFmt = DateFormatter('%b %d')
ax.xaxis.set_major_locator(months)
ax.xaxis.set_major_formatter(yearsFmt)
ax.xaxis.set_minor_locator(months)
ax.autoscale_view()
```

{:.output}
{:.display_data}

![png]({{ site.url }}//images/courses/earth-analytics-python/02-intro-to-python-and-time-series-data/plot-time-series-handle-dates/2018-02-05-flood03-subset-plot-time-series-data-python_15_0.png)




<div class="notice--warning" markdown="1">

## <i class="fa fa-pencil-square-o" aria-hidden="true"></i> Challenge

Create a subset from the `boulder_daily_precip` data using the same date range in 2012 to compare to the 2013 plot.
Use the ylim() argument to ensure the y axis range is the SAME as the previous
plot - from 0 to 10".

How different was the rainfall in 2012?

HINT: type `?lims` in the console to see how the `xlim` and `ylim` arguments work.


</div>


{:.output}
{:.display_data}

![png]({{ site.url }}//images/courses/earth-analytics-python/02-intro-to-python-and-time-series-data/plot-time-series-handle-dates/2018-02-05-flood03-subset-plot-time-series-data-python_17_0.png)





{:.output}
{:.display_data}

![png]({{ site.url }}//images/courses/earth-analytics-python/02-intro-to-python-and-time-series-data/plot-time-series-handle-dates/2018-02-05-flood03-subset-plot-time-series-data-python_18_0.png)




<div class="notice--info" markdown="1">

## Additional Resources

Here are some additional resources about downloading the [raw precipitation data](http://neondataskills.org/R/COOP-precip-data-R)

</div>
