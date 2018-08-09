---
layout: single
title: "Customize Dates on in Matplotlib plots in Python"
excerpt: 'When you plot time series data in matplotlib, you often want to customize the date format that is presented on the plot. Learn how to customize the date format in a Python matplotlib plot.'
authors: ['Chris Holdgraf', 'Leah Wasser', 'Martha Morrissey']
modified: 2018-08-09
category: [courses]
class-lesson: ['time-series-python']
course: 'earth-analytics-python'
nav-title: 'Customize Date Format - Matplotlib'
permalink: /courses/earth-analytics-python/use-time-series-data-in-python/customize-dates--matplotlib-plots-python/
module-type: 'class'
week: 2
sidebar:
  nav:
author_profile: false
comments: true
order: 5
topics:
  reproducible-science-and-programming: ['python']
  data-exploration-and-analysis: ['data-visualization']
---

{% include toc title="In This Lesson" icon="file-text" %}

In this tutorial, you will explore more advanced plotting techniques using `matplotlib`.

<div class='notice--success' markdown="1">

## <i class="fa fa-graduation-cap" aria-hidden="true"></i> Learning Objectives

At the end of this activity, you will be able to:

* Customize date formats on a `matplotlib plot in `python`

## <i class="fa fa-check-square-o fa-2" aria-hidden="true"></i> What You Need

You need `Python 3.x` and `Jupyter notebooks` to complete this tutorial. Also you should have an `earth-analytics` directory setup on your computer with a `/data` directory with it.

{% include/data_subsets/course_earth_analytics/_data-colorado-flood.md %}

</div>

In this lesson you will learn how to format the time and date stamps drawn on a matplotlib plot axis.

{:.input}
```python
# import required python packages
import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
from matplotlib.dates import DateFormatter
import os
plt.ion()
import earthpy as et
os.chdir(os.path.join(et.io.HOME, 'earth-analytics'))

# set parameters so all plots are consistent
plt.rcParams['figure.figsize'] = (8, 8)
import seaborn as sns; 
sns.set(font_scale=1.5)
```

{:.output}
    /Users/lewa8222/anaconda3/envs/earth-analytics-python/lib/python3.6/importlib/_bootstrap.py:219: RuntimeWarning: numpy.dtype size changed, may indicate binary incompatibility. Expected 96, got 88
      return f(*args, **kwds)
    /Users/lewa8222/anaconda3/envs/earth-analytics-python/lib/python3.6/importlib/_bootstrap.py:219: RuntimeWarning: numpy.dtype size changed, may indicate binary incompatibility. Expected 96, got 88
      return f(*args, **kwds)
    /Users/lewa8222/anaconda3/envs/earth-analytics-python/lib/python3.6/importlib/_bootstrap.py:219: RuntimeWarning: numpy.dtype size changed, may indicate binary incompatibility. Expected 96, got 88
      return f(*args, **kwds)



In the previous lessons you downloaded and imported data from [figshare](https://figshare.com/authors/_/3386570) into Python using the following code.

{:.input}
```python
# to begin, read in the data
boulder_daily_precip = pd.read_csv('data/colorado-flood/precipitation/805325-precip-dailysum-2003-2013.csv', 
                                   parse_dates=['DATE'], na_values=['999.99'])

# subset the data as we did previously
precip_boulder_AugOct = boulder_daily_precip.query('DATE >= "2013-08-15" and DATE <= "2013-10-15"')


# view first few rows of data
precip_boulder_AugOct.head()
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
      <th>759</th>
      <td>2013-08-21</td>
      <td>0.1</td>
      <td>COOP:050843</td>
      <td>BOULDER 2 CO US</td>
      <td>1650.5</td>
      <td>40.0338</td>
      <td>-105.2811</td>
      <td>2013</td>
      <td>233</td>
    </tr>
    <tr>
      <th>760</th>
      <td>2013-08-26</td>
      <td>0.1</td>
      <td>COOP:050843</td>
      <td>BOULDER 2 CO US</td>
      <td>1650.5</td>
      <td>40.0338</td>
      <td>-105.2811</td>
      <td>2013</td>
      <td>238</td>
    </tr>
    <tr>
      <th>761</th>
      <td>2013-08-27</td>
      <td>0.1</td>
      <td>COOP:050843</td>
      <td>BOULDER 2 CO US</td>
      <td>1650.5</td>
      <td>40.0338</td>
      <td>-105.2811</td>
      <td>2013</td>
      <td>239</td>
    </tr>
    <tr>
      <th>762</th>
      <td>2013-09-01</td>
      <td>0.0</td>
      <td>COOP:050843</td>
      <td>BOULDER 2 CO US</td>
      <td>1650.5</td>
      <td>40.0338</td>
      <td>-105.2811</td>
      <td>2013</td>
      <td>244</td>
    </tr>
    <tr>
      <th>763</th>
      <td>2013-09-09</td>
      <td>0.1</td>
      <td>COOP:050843</td>
      <td>BOULDER 2 CO US</td>
      <td>1650.5</td>
      <td>40.0338</td>
      <td>-105.2811</td>
      <td>2013</td>
      <td>252</td>
    </tr>
  </tbody>
</table>
</div>





Plot the data using the pandas function, `.plot()`.

{:.input}
```python
# plot the data
fig, ax = plt.subplots()
ax.scatter(precip_boulder_AugOct['DATE'].values, 
       precip_boulder_AugOct['DAILY_PRECIP'].values,
       color='purple')
ax.set(xlabel="Date", ylabel="Precipitation (Inches)")
ax.set(title="Daily Precipitation (inches)\nBoulder, Colorado 2013");
```

{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}//images/courses/earth-analytics-python/02-intro-to-python-and-time-series-data/plot-time-series-handle-dates/2018-02-05-ts05-customize-date-axes-matplotlib_6_0.png">

</figure>




## Reformat Dates in Matplotlib

You can change the format of a date on a plot axis too in `matplotlib` using the `DateFormatter` module.

To begin you need to import `DateFormatter` from `matplotlib`. Then you specify the format that you want to use for the date DateFormatter using the syntax: `("%m/%d")` where each %m element represents a part of the date as follows:

`%Y` - 4 digit year
`%y` - 2 digit year
`%m` - month
`%d` - day

To implement the custom date, you then:
define the date format: `myFmt = DateFormatter("%m/%d")`

This a date format that is `month/day` so it will look like this: `10/05` which represents October 5th.
Here you can customize the date to look like whatever format you want. 

Then you call the format that you defined using the `set_major_formatter()` method. 
`ax.xaxis.set_major_formatter(myFmt)`

This applies the date format that you defined above to the plot. 


{:.input}
```python
# import the date format modules
from matplotlib.dates import DateFormatter
import matplotlib.dates as mdates

# Define the date format
myFmt = DateFormatter("%m/%d") 

# plot the data
fig, ax = plt.subplots()
ax.scatter(precip_boulder_AugOct['DATE'].values, 
       precip_boulder_AugOct['DAILY_PRECIP'].values,
       color='purple')
ax.set(xlabel="Date", ylabel="Precipitation (Inches)")
ax.set(title="Daily Precipitation (inches)\nBoulder, Colorado 2013")

# tell matplotlib to use the format specified above
ax.xaxis.set_major_formatter(myFmt); 
```

{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}//images/courses/earth-analytics-python/02-intro-to-python-and-time-series-data/plot-time-series-handle-dates/2018-02-05-ts05-customize-date-axes-matplotlib_8_0.png">

</figure>




### X-Lable Ticks and Dates

Time specific ticks can be added along the x-axis. For example, large ticks can indicate each new week day and small ticks can indicate each day. 

The function `xaxis.set_major_location()` controls large ticks, and the function `xaxis.set_minor_locator` controls the smaller ticks.

{:.input}
```python
from matplotlib.dates import DateFormatter
import matplotlib.dates as mdates

# define the date format
myFmt = DateFormatter("%m-%d") 

# plot
fig, ax = plt.subplots()
ax.scatter(precip_boulder_AugOct['DATE'].values, 
       precip_boulder_AugOct['DAILY_PRECIP'].values,
       color='purple')
ax.set(xlabel="Date", ylabel="Precipitation (Inches)",)
ax.set_title("Daily Precipitation (inches)\nBoulder, Colorado 2013")
     
#ax.xaxis.set_major_locator(mdates.WeekdayLocator())
ax.xaxis.set_major_formatter(myFmt)   
ax.xaxis.set_minor_locator(mdates.DayLocator())
```

{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}//images/courses/earth-analytics-python/02-intro-to-python-and-time-series-data/plot-time-series-handle-dates/2018-02-05-ts05-customize-date-axes-matplotlib_10_0.png">

</figure>





<div class="notice--info" markdown="1">

## Additional Resources

Here are some additional `matplotlib` [examples](https://matplotlib.org/examples/pylab_examples/subplots_demo.html) and information about [color bars](http://joseph-long.com/writing/colorbars/). Here is an [in-depth guide](https://realpython.com/blog/python/python-matplotlib-guide/?utm_campaign=Data%2BElixir&utm_medium=email&utm_source=Data_Elixir_172) to `matplotlib` that will be useful for you to refer back to. 


</div>
