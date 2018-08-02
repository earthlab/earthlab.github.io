---
layout: single
title: "Plot Stream Discharge Data in Python"
excerpt: "This lesson is a challenge exercise that asks you to use all of the skills used during the week 2 set of lessons in the earth analytics course. Here you will import data and subset it to create a final plot of stream discharge over time."
authors: ['Leah Wasser', 'NEON Data Skills']
modified: 2018-08-01
category: [courses]
class-lesson: ['time-series-python']
course: 'earth-analytics-python'
week: 2
permalink: /courses/earth-analytics-python/use-time-series-data-in-python/plot-stream-discharge-timeseries-challenge-python/
nav-title: 'Subset & plot timeseries data'
sidebar:
  nav:
author_profile: false
comments: true
order: 4
topics:
  reproducible-science-and-programming: ['Jupyter notebook']
  time-series:
  data-exploration-and-analysis: ['data-visualization']
---


{% include toc title="In This Lesson" icon="file-text" %}

In this data lesson, you will explore and visualize stream discharge time series data collected by the United States Geological Survey (USGS). You will use everything hat you learned in the previous lessons to create your plots. You will use these plots in the report that you submit for your homework.

Note: this page just shows you what the plots should look like. You will need to use your programming skills to create the plots!

<div class='notice--success' markdown="1">

## <i class="fa fa-graduation-cap" aria-hidden="true"></i> Learning Objectives

After completing this tutorial, you will be able to:

* Plot USGS Stream Discharge time series data in `Python`.

## <i class="fa fa-check-square-o fa-2" aria-hidden="true"></i> What You Need

You need `Python` and `Jupyter notebooks` to complete this tutorial. Also you should have
an `earth-analytics` directory setup on your computer with a `/data`
directory with it.


* [Setup Conda](/courses/earth-analytics-python/get-started-with-python-jupyter/setup-conda-earth-analytics-environment/)
* [Setup your working directory](/courses/earth-analytics-python/get-started-with-python-jupyter/introduction-to-bash-shell/)
* [Intro to Jupyter Notebooks](/courses/earth-analytics-python/python-open-science-tool-box/intro-to-jupyter-notebooks/)

Please download the data (used throughout this series of lessons) if you don't already have it on your computer.

{% include/data_subsets/course_earth_analytics/_data-colorado-flood.md %}

</div>

## About the Data - USGS Stream Discharge Data

The USGS has a distributed network of aquatic sensors located in streams across the United States. This network monitors a suit of variables that are important to stream morphology and health. One of the metrics that this sensor network monitors is **Stream Discharge**, a metric which quantifies the volume of water moving down a stream. Discharge is an ideal metric to quantify flow, which increases significantly during a flood event.

> As defined by USGS: Discharge is the volume of water moving down a stream or
> river per unit of time, commonly expressed in cubic feet per second or gallons
> per day. In general, river discharge is computed by multiplying the area of
> water in a channel cross section by the average velocity of the water in that
> cross section.
>
> <a href="http://water.usgs.gov/edu/streamflow2.html" target="_blank">
Read more about stream discharge data collected by USGS.</a>

<figure>
<a href="{{ site.url }}/images/courses/earth-analytics/week-02/USGS-peak-discharge.gif">
<img src="{{ site.url }}/images/courses/earth-analytics/week-02/USGS-peak-discharge.gif" alt="Plot of stream discharge from the USGS boulder creek stream gage"></a>
<figcaption>
The USGS tracks stream discharge through time at locations across the United
States. Note the pattern observed in the plot above. The peak recorded discharge
value in 2013 was significantly larger than what was observed in other years.
Source: <a href="http://nwis.waterdata.usgs.gov/usa/nwis/peak/?site_no=06730200" target="_blank"> USGS, National Water Information System. </a>
</figcaption>
</figure>



## Work with USGS Stream Gage Data

Let's begin by loading the required libraries and setting your working directory.


{:.input}
```python
import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
import os
plt.ion()
```

##  Import USGS Stream Discharge Data Into Python

Let's first import your data using the pandas `read.csv()` function.


{:.input}
```python
discharge = pd.read_csv('data/colorado-flood/discharge/06730200-discharge-daily-1986-2013.csv', 
                        parse_dates=['datetime'])
discharge.head()
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
      <th>agency_cd</th>
      <th>site_no</th>
      <th>datetime</th>
      <th>disValue</th>
      <th>qualCode</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>USGS</td>
      <td>6730200</td>
      <td>1986-10-01</td>
      <td>30.0</td>
      <td>A</td>
    </tr>
    <tr>
      <th>1</th>
      <td>USGS</td>
      <td>6730200</td>
      <td>1986-10-02</td>
      <td>30.0</td>
      <td>A</td>
    </tr>
    <tr>
      <th>2</th>
      <td>USGS</td>
      <td>6730200</td>
      <td>1986-10-03</td>
      <td>30.0</td>
      <td>A</td>
    </tr>
    <tr>
      <th>3</th>
      <td>USGS</td>
      <td>6730200</td>
      <td>1986-10-04</td>
      <td>30.0</td>
      <td>A</td>
    </tr>
    <tr>
      <th>4</th>
      <td>USGS</td>
      <td>6730200</td>
      <td>1986-10-05</td>
      <td>30.0</td>
      <td>A</td>
    </tr>
  </tbody>
</table>
</div>





{:.input}
```python
discharge.dtypes
```

{:.output}
{:.execute_result}



    agency_cd            object
    site_no               int64
    datetime     datetime64[ns]
    disValue            float64
    qualCode             object
    dtype: object








Plot discharge (disValue) over time.
Your plot should look something like the one below:





{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}//images/courses/earth-analytics-python/02-intro-to-python-and-time-series-data/plot-time-series-handle-dates/2018-02-05-flood04-USGS-stream-discharge-in-python_8_0.png">

</figure>




<div class="notice--warning" markdown="1">

## <i class="fa fa-pencil-square-o" aria-hidden="true"></i> Optional challenge

Similar to the previous lesson, take the cleaned discharge data that you just
plotted and subset it to the time span
of **2013-08-15 to 2013-10-15**.  

Finally plot the data using `matplotlib`. Your plot should look like the one below.
</div>



{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}//images/courses/earth-analytics-python/02-intro-to-python-and-time-series-data/plot-time-series-handle-dates/2018-02-05-flood04-USGS-stream-discharge-in-python_10_0.png">

</figure>




<i class="fa fa-star"></i> **Data Tip:**
To make your plots more attractive check out [this tutorial from seaborn!](https://seaborn.pydata.org/tutorial/aesthetics.html) 
{: .notice--success}
