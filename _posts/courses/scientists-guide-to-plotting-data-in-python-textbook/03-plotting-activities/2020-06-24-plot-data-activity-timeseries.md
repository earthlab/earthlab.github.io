---
layout: single
category: courses
title: "Plot Time Series Data Using Open Source Python"
permalink: /courses/scientists-guide-to-plotting-data-in-python/python-timeseries-plotting-activity/
week-landing: 3
dateCreated: 2020-06-24
modified: 2020-06-25
week: 3
sidebar:
  nav:
comments: false
author_profile: false
course: 'scientists-guide-to-plotting-data-in-python-textbook'
module-type: 'session'
---
{% include toc title="Section Three" icon="file-text" %}

<div class="notice--info" markdown="1">

## <i class="fa fa-ship" aria-hidden="true"></i> Section Three - Open Source Python Plotting Activities 

In section two of this textbook, you will test your skills with plotting different 
types of data using open source **Python**. 


## <i class="fa fa-graduation-cap" aria-hidden="true"></i> Learning Objectives

After completing this section of the Scientist's Guide to Plotting Data in Python online textbook, you will be able to:

* Plot different types of data using open source python approaches. 

</div>

{% include textbook-section-toc.html %}


<div class='notice--success' markdown="1">

## <i class="fa fa-graduation-cap" aria-hidden="true"></i> Challenge: Plot Time Series Data Using Open Source Python

One of the most common data plot the chapters have covered is time series data. Below is a challenge to refresh your memory on how to plot time series and modify certain aspects of it. 
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

<i class="fa fa-star"></i> **Data Tip:** For help with this challenge, see your previous activities involving time series, or [the time series chapters](https://www.earthdatascience.org/courses/use-data-open-source-python/use-time-series-data-in-python/) from the EarthLab website. 

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

<img src = "{{ site.url }}/images/courses/scientists-guide-to-plotting-data-in-python-textbook/03-plotting-activities/2020-06-24-plot-data-activity-timeseries/2020-06-24-plot-data-activity-timeseries_7_0.png">

</figure>



