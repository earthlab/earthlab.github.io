---
layout: single
title: "Customize Matplotlibe Dates Ticks on the x-axis in Python"
excerpt: 'When you plot time series data in matplotlib, you often want to customize the date format that is presented on the plot. Learn how to customize the date format in a Python matplotlib plot.'
authors: ['Chris Holdgraf', 'Leah Wasser', 'Martha Morrissey']
dateCreated: 2019-09-11
modified: 2020-09-24
category: [courses]
class-lesson: ['intro-to-plotting-matplotlib']
course: 'scientists-guide-to-plotting-data-in-python-textbook'
nav-title: 'Custom Plot Date Tick Formats'
permalink: /courses/scientists-guide-to-plotting-data-in-python/plot-with-matplotlib/introduction-to-matplotlib-plots/plot-time-series-data-in-python/
module-type: 'class'
week: 1
sidebar:
  nav:
author_profile: false
comments: true
order: 3
topics:
  reproducible-science-and-programming: ['python']
  data-exploration-and-analysis: ['data-visualization']
---

{% include toc title="On This Page" icon="file-text" %}

<div class='notice--success' markdown="1">

## <i class="fa fa-graduation-cap" aria-hidden="true"></i> Learning Objectives

* Customize date formats on a **matplotlib** plot in **Python**
</div>

{:.input}
```python
# Import required python packages
import os
import pandas as pd
import matplotlib.pyplot as plt
from matplotlib.dates import DateFormatter
import matplotlib.dates as mdates
import seaborn as sns
import earthpy as et

# Date time conversion registration
from pandas.plotting import register_matplotlib_converters
register_matplotlib_converters()


# Get the data
data = et.data.get_data('colorado-flood')

# Set working directory
os.chdir(os.path.join(et.io.HOME, 'earth-analytics', 'data'))

# Prettier plotting with seaborn
sns.set(font_scale=1.5)
# Ticks instead of whitegrid in order to demonstrate changes to plot ticks better
sns.set_style("ticks")
```

{:.output}
    Downloading from https://ndownloader.figshare.com/files/16371473
    Extracted output to /root/earth-analytics/data/colorado-flood/.



In this lesson you will learn how to plot time series using matplotlib in Python.
You will use the same data that you used in the previous lesson. To begin download the data. 

{:.input}
```python
# Read in the data
data_path = os.path.join("colorado-flood",
                         "precipitation",
                         "805325-precip-dailysum-2003-2013.csv")
boulder_daily_precip = pd.read_csv(data_path,
                                   parse_dates=['DATE'],
                                   na_values=['999.99'],
                                   index_col=['DATE'])


```

{:.input}
```python
# Subset the data as we did previously
precip_boulder_AugOct = boulder_daily_precip["2013-08-15":"2013-10-15"]


# View first few rows of data
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
      <th>2013-08-21</th>
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
      <th>2013-08-26</th>
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
      <th>2013-08-27</th>
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
      <th>2013-09-01</th>
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
      <th>2013-09-09</th>
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





Plot the data.

{:.input}
```python
fig, ax = plt.subplots(figsize=(12, 8))
ax.plot(precip_boulder_AugOct.index.values,
        precip_boulder_AugOct['DAILY_PRECIP'].values,
        '-o',
        color='purple')
ax.set(xlabel="Date", ylabel="Precipitation (Inches)",
       title="Daily Precipitation \nBoulder, Colorado 2013")

# Format the x axis
ax.xaxis.set_major_locator(mdates.WeekdayLocator(interval=2))
ax.xaxis.set_major_formatter(DateFormatter("%m-%d"))

plt.show()
```

{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}/images/courses/plot-data-in-python-textbook/01-plot-with-matplotlib/intro-to-plotting-matplotlib/2019-09-11-plot-with-matplotlib-03-plot-time-series-data/2019-09-11-plot-with-matplotlib-03-plot-time-series-data_7_0.png" alt = "Scatterplot showing daily precipitation in Boulder, Colorado.">
<figcaption>Scatterplot showing daily precipitation in Boulder, Colorado.</figcaption>

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
# Plot the data
fig, ax = plt.subplots(figsize=(10,6))
ax.scatter(precip_boulder_AugOct.index.values,
           precip_boulder_AugOct['DAILY_PRECIP'].values,
           color='purple')
ax.set(xlabel="Date", ylabel="Precipitation (Inches)",
       title="Daily Precipitation (inches)\nBoulder, Colorado 2013")

# Define the date format
date_form = DateFormatter("%m/%d")
ax.xaxis.set_major_formatter(date_form)

```

{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}/images/courses/plot-data-in-python-textbook/01-plot-with-matplotlib/intro-to-plotting-matplotlib/2019-09-11-plot-with-matplotlib-03-plot-time-series-data/2019-09-11-plot-with-matplotlib-03-plot-time-series-data_9_0.png" alt = "Scatterplot showing daily precipitation with the x-axis dates cleaned up so they are easier to read.">
<figcaption>Scatterplot showing daily precipitation with the x-axis dates cleaned up so they are easier to read.</figcaption>

</figure>




### X-Label Ticks and Dates

Time specific ticks can be added along the x-axis. For example, large ticks can indicate each new week day and small ticks can indicate each day. 

The function `xaxis.set_major_locator()` controls the location of the large ticks, and the function `xaxis.set_minor_locator` controls the smaller ticks.

{:.input}
```python
# Plot the data
fig, ax = plt.subplots(figsize=(10,6))
ax.scatter(precip_boulder_AugOct.index.values,
           precip_boulder_AugOct['DAILY_PRECIP'].values,
           color='purple')
ax.set(xlabel="Date", ylabel="Precipitation (Inches)",
       title="Daily Precipitation (inches)\nBoulder, Colorado 2013")


# Define the date format
date_form = DateFormatter("%m/%d")
ax.xaxis.set_major_formatter(date_form)
# Ensure ticks fall once every other week (interval=2) 
ax.xaxis.set_major_locator(mdates.WeekdayLocator(interval=2))
```

{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}/images/courses/plot-data-in-python-textbook/01-plot-with-matplotlib/intro-to-plotting-matplotlib/2019-09-11-plot-with-matplotlib-03-plot-time-series-data/2019-09-11-plot-with-matplotlib-03-plot-time-series-data_11_0.png" alt = "Scatterplot showing daily precipitation with the x-axis dates cleaned up and the format customized so they are easier to read.">
<figcaption>Scatterplot showing daily precipitation with the x-axis dates cleaned up and the format customized so they are easier to read.</figcaption>

</figure>





You can add minor ticks to your plot too. Given we are using seaborn to customize the look of our plot, minor ticks are not rendered. But if you wanted to add day ticks to a plot that did have minor ticks turned "on" you would use:

`ax.xaxis.set_minor_locator(mdates.DayLocator())`

`mdates.DayLocator()` adds a tick for each day. 

<div class="notice--info" markdown="1">

## Additional Resources

Here are some additional `matplotlib` 
* <a href = "https://matplotlib.org/examples/pylab_examples/subplots_demo.html" target = "_blank">plots demo</a>
* <a href = "http://joseph-long.com/writing/colorbars/" target = "_blank">color bars</a> 
* <a href = "https://realpython.com/blog/python/python-matplotlib-guide/" target = "_blank">in-depth guide to plotting</a> 
</div>
