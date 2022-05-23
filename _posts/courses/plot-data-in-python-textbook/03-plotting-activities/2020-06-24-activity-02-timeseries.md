---
layout: single
title: "Activity: Plot Time Series Data Using Pandas in Open Source Python"
excerpt: "Practice your skills plotting time series data stored in Pandas Data Frames in Python."
authors: ['Leah Wasser', 'Nathan Korinek']
dateCreated: 2020-02-26
modified: 2020-09-15
category: [courses]
class-lesson: ['plot-activities']
permalink: /courses/scientists-guide-to-plotting-data-in-python/plot-activities/plot-time-series-data-python/
nav-title: 'Plot Time Series Data'
chapter: 5
week: 3
sidebar:
  nav:
author_profile: false
comments: true
order: 2
course: 'scientists-guide-to-plotting-data-in-python-textbook'
topics:
  reproducible-science-and-programming:
  data-exploration-and-analysis: ['data-visualization']
  spatial-data-and-gis: ['raster-data', 'vector-data']
---

{% include toc title="Section Three" icon="file-text" %}

<div class='notice--success' markdown="1">

## <i class="fa fa-ship" aria-hidden="true"></i> Chapter Five - Practice Your Plotting Skills

In this chapter, you will practice your skills creating different types of plots in **Python** using **earthpy**, **matplotlib**, and **folium**. 

</div>


<div class='notice--success' markdown="1">

## <i class="fa fa-graduation-cap" aria-hidden="true"></i> Learning Objectives

* Apply your skills in plotting time series data using matplotlib and pandas in open source Python. 

</div>


## Plot Time Series Data in Python

Time series data formats apply to many different types of data including precipitation, temperature, land use change data, and much more. Plotting time series data can be particularly tricky given varying time stamp formats, time zone differences and your analysis needs. In this lesson you will practice you skills associated with plotting time series data in Python. To review how to work with time series data using Pandas,  <a href="{{ site.baseurl }}/courses/use-data-open-source-python/use-time-series-data-in-python/introduction-to-time-series-in-pandas-python/">check out the chapter of time series data in the intermediate earth data science textbook.</a>


Below is you will find a challenge activity that you can use to practice your 
plotting skills for plot time series data using **matplotlib** and **pandas**. 
The packages that you will need to complete this activity are listed below. 


{:.input}
```python
# Import Packages
import os
from datetime import datetime

import matplotlib.pyplot as plt
import matplotlib.dates as mdates
import seaborn as sns
import pandas as pd
import earthpy as et

# Add seaborn general plot specifications
sns.set(font_scale=1.5, style="whitegrid")
```

<div class="notice--warning" markdown="1">

## <i class="fa fa-pencil-square-o" aria-hidden="true"></i> Challenge 1: Plot Time-Series Data

The plot that you will create will show the global loss of glaciers from 1945
to the present using NOAA data. To make this plot, you will have to do the following: 

1. Read in the `.csv` using the API link: `https://datahub.io/core/glacier-mass-balance/r/glacier-mass-balance_zip.zip` using **pandas** to create a `DataFrame`.
2. Parse the dates from the `.csv` file. Assign the date column to be a `DataFrame` index.
3. Plot your data making sure datetime is on the x-axis and `Mean cumulative mass balance` column is on the y-axis. 
4. Set an appropriate xlabel, ylabel, and plot title. 
5. Change the x limits to range from 1940 to 2020. Use the `ax.set_xlim()` argument, and ensure that you create your limits as datetime objects. For example, if the lower xlimit was to be set for 1920, I would create it using `datetime(1920, 1, 1)` to say the datetime is for January 1st, 2020. 
6. Open and look at the metadata found in the `README.md` file of your download, to find out what the units for the `Mean cumulative mass balance` are.

</div>

The plot below is an example of what your final plot should look like after 
completing this challenge. 

****
<div class='notice--success alert alert-info' markdown="1">

<i class="fa fa-star"></i> **Data Tip:** <a href="{{ site.baseurl }}/courses/use-data-open-source-python/use-time-series-data-in-python/">To learn more about time series data and how to plot it, see this chapter of the earth data science Use Data for Earth and Environmental Science in Open Source Python textbook.</a>

</div>

{:.input}
```python
# Download the data & Set your working directory
et.data.get_data(
    url="https://ndownloader.figshare.com/files/24649952")
os.chdir(os.path.join(et.io.HOME, 
                      "earth-analytics", 
                      "data"))
```

{:.output}
    Downloading from https://ndownloader.figshare.com/files/24649952
    Extracted output to /root/earth-analytics/data/earthpy-downloads/glacier-mass-balance





{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}/images/courses/plot-data-in-python-textbook/03-plotting-activities/2020-06-24-activity-02-timeseries/2020-06-24-activity-02-timeseries_7_0.png" alt = "Line graph showing the global glacier mass balance since 1945.">
<figcaption>Line graph showing the global glacier mass balance since 1945.</figcaption>

</figure>



