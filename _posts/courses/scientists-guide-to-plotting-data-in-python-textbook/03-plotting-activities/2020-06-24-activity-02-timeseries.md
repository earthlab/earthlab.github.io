---
layout: single
title: "Activity: Plot Time Series Data Using Pandas in Open Source Python"
excerpt: "Practice your skills plotting time series data stored in Pandas Data Frames in Python."
authors: ['Leah Wasser', 'Nathan Korinek']
dateCreated: 2020-02-26
modified: 2020-06-26
category: [courses]
class-lesson: ['plot-activities']
permalink: /courses/scientists-guide-to-plotting-data-in-python/plot-activities/plot-time-series-data-python/
nav-title: 'Plot Time Series Data'
module-title: 'Practice Your Python Plotting Skills'
module-description: 'This chapter provides a series of activities that allow you to practice your Python plotting skills using differen types of data.'
module-nav-title: 'Practice Plotting'
module-type: 'class'
chapter: 5
week: 3
sidebar:
  nav:
author_profile: false
comments: true
order: 1
class-order: 1
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

## Plot Time Series Data in Python

One of the most common tasks the chapters have covered is plotting time series data. Time series data is a very common and important data type when it comes to earth analytics. It can be used to store precipitation data, temperature data, land change data, and much more. The chapters have covered information about common file types for time series data storage, such as `.txt` and `.csv` files, as well as how to read in and handle time series data in **Python** with the **pandas** package. The chapters also showed how to modify time series plots with **matplotlib** to make them communicate the time series data more effectively. 

## <i class="fa fa-graduation-cap" aria-hidden="true"></i> Challenge: Plot Time Series Data Using Open Source Python

Below is a challenge to refresh your memory on how to plot time series using **matplotlib** and modify certain aspects of it with **pandas**. 
</div>

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

****
<div class='notice--success alert alert-info' markdown="1">

<i class="fa fa-star"></i> **Data Tip:** [To learn more about time series data and how to plot it, see this chapter of the earth data science Use Data for Earth and Environmental Science in Open Source Python textbook.](https://www.earthdatascience.org/courses/use-data-open-source-python/use-time-series-data-in-python/)  

</div>

{:.input}
```python
# Download the data & Set your working directory
et.data.get_data(
    url="https://datahub.io/core/glacier-mass-balance/r/glacier-mass-balance_zip.zip")
os.chdir(os.path.join(et.io.HOME, "earth-analytics", "data"))
```

{:.output}
    Downloading from https://datahub.io/core/glacier-mass-balance/r/glacier-mass-balance_zip.zip
    Extracted output to /root/earth-analytics/data/earthpy-downloads/glacier-mass-balance_zip





{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}/images/courses/scientists-guide-to-plotting-data-in-python-textbook/03-plotting-activities/2020-06-24-activity-02-timeseries/2020-06-24-activity-02-timeseries_7_0.png">

</figure>



