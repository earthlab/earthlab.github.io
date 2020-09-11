---
layout: single
title: "Customize Dates on Time Series Plots in Python Using Matplotlib"
excerpt: 'When you plot time series data using the matplotlib package in Python, you often want to customize the date format that is presented on the plot. Learn how to customize the date format on time series plots created using matplotlib.'
authors: ['Leah Wasser', 'Jenny Palomino', 'Chris Holdgraf', 'Martha Morrissey']
modified: 2020-09-11
category: [courses]
class-lesson: ['time-series-python-tb']
course: 'intermediate-earth-data-science-textbook'
nav-title: 'Custom Date Formats for Plots'
permalink: /courses/use-data-open-source-python/use-time-series-data-in-python/date-time-types-in-pandas-python/customize-dates-matplotlib-plots-python/
module-type: 'class'
week: 1
sidebar:
  nav:
author_profile: false
comments: true
order: 5
topics:
  reproducible-science-and-programming: ['python']
  data-exploration-and-analysis: ['data-visualization']
redirect_from:
  - "/courses/earth-analytics-python/use-time-series-data-in-python/customize-dates--matplotlib-plots-python/"
  - "/courses/use-data-open-source-python/use-time-series-data-in-python/customize-dates-matplotlib-plots-python/"
---

{% include toc title="On This Page" icon="file-text" %}

<div class='notice--success' markdown="1">

## <i class="fa fa-graduation-cap" aria-hidden="true"></i> Learning Objectives

* Customize date formats on a plot created with **matplotlib** in **Python**.

</div>


## How to Reformat Date Labels in Matplotlib

So far in this chapter, using the `datetime` index has worked well for plotting, but there have been instances in which the date tick marks had to be rotated in order to fit them nicely along the x-axis.

Luckily, **matplotlib** provides functionality to change the format of a date on a plot axis using the `DateFormatter` module, so that you can customize the look of your labels without having to rotate them.

Using the `DateFormatter` module from **matplotlib**, you can specify the format that you want to use for the date using the syntax: `"%X %X"` where each `%X` element represents a part of the date as follows:
* `%Y` - 4 digit year with upper case `Y`
* `%y` - 2 digit year with lower case `y`
* `%m` - month as a number with lower case `m`
* `%b` - month as abbreviated name with lower case `b`
* `%d` - day with lower case `d`

You can also add a character between the `"%X %X"` to specify how the values are connected in the label such as `-` or `\`. 

For example, using the syntax `"%m-%d"` would create labels that appears as `month-day`, such as `05-01` for May 1st.  

On this page, you will learn how to use `DateFormatter` to modify the look and frequency of the axis labels on your plots. 


### Import Packages and Get Data

You will use the daily total precipitation (inches) data, sourced from the <a href="https://www.ncdc.noaa.gov/cdo-web/search" target ="_blank">National Centers for Environmental Information (formerly National Climate Data Center) Cooperative Observer Network (COOP)</a>, that you used previously in this chapter. 

To begin, import the necessary packages to work with **pandas** dataframe and download data. 

You will continue to work with modules from **pandas** and **matplotlib** including `DataFormatter` to plot dates more efficiently and with <a href="https://seaborn.pydata.org/introduction.html" target="_blank">**seaborn**</a> to make more attractive plots. 

{:.input}
```python
# Import necessary packages
import os
import matplotlib.pyplot as plt
import matplotlib.dates as mdates
from matplotlib.dates import DateFormatter
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

# Define relative path to file with daily precip
file_path = os.path.join("data", "colorado-flood",
                         "precipitation",
                         "805325-precip-dailysum-2003-2013.csv")
```

Just as before, when you import the file to a **pandas** dataframe, be sure to specify the:
* no data values using the parameter `na_values`
* date column using the parameter `parse_dates`
* datetime index using the parameter `index_col`

{:.input}
```python
# Import data using datetime and no data value
precip_2003_2013_daily = pd.read_csv(file_path,
                                     parse_dates=['DATE'],
                                     index_col= ['DATE'],
                                     na_values=['999.99'])
```

Now, subset the data to time period June 1, 2005 - August 31, 2005 and plot the data without rotating the labels along the x-axis.

{:.input}
```python
# Subset data to June-Aug 2005
precip_june_aug_2005 = precip_2003_2013_daily['2005-06-01':'2005-08-31']

precip_june_aug_2005.head()
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
      <th>2005-06-01</th>
      <td>0.0</td>
      <td>COOP:050843</td>
      <td>BOULDER 2 CO US</td>
      <td>1650.5</td>
      <td>40.03389</td>
      <td>-105.28111</td>
      <td>2005</td>
      <td>152</td>
    </tr>
    <tr>
      <th>2005-06-02</th>
      <td>0.1</td>
      <td>COOP:050843</td>
      <td>BOULDER 2 CO US</td>
      <td>1650.5</td>
      <td>40.03389</td>
      <td>-105.28111</td>
      <td>2005</td>
      <td>153</td>
    </tr>
    <tr>
      <th>2005-06-03</th>
      <td>0.3</td>
      <td>COOP:050843</td>
      <td>BOULDER 2 CO US</td>
      <td>1650.5</td>
      <td>40.03389</td>
      <td>-105.28111</td>
      <td>2005</td>
      <td>154</td>
    </tr>
    <tr>
      <th>2005-06-04</th>
      <td>0.7</td>
      <td>COOP:050843</td>
      <td>BOULDER 2 CO US</td>
      <td>1650.5</td>
      <td>40.03389</td>
      <td>-105.28111</td>
      <td>2005</td>
      <td>155</td>
    </tr>
    <tr>
      <th>2005-06-09</th>
      <td>0.1</td>
      <td>COOP:050843</td>
      <td>BOULDER 2 CO US</td>
      <td>1650.5</td>
      <td>40.03389</td>
      <td>-105.28111</td>
      <td>2005</td>
      <td>160</td>
    </tr>
  </tbody>
</table>
</div>





{:.input}
```python
# Create figure and plot space
fig, ax = plt.subplots(figsize=(12, 12))

# Add x-axis and y-axis
ax.bar(precip_june_aug_2005.index.values,
       precip_june_aug_2005['DAILY_PRECIP'],
       color='purple')

# Set title and labels for axes
ax.set(xlabel="Date",
       ylabel="Precipitation (inches)",
       title="Daily Total Precipitation\nJune - Aug 2005 for Boulder Creek")

plt.show()
```

{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}/images/courses/intermediate-eds-textbook/01-time-series/plot-time-series-handle-dates/2019-11-19-time-series-05-customize-date-axes-matplotlib/2019-11-19-time-series-05-customize-date-axes-matplotlib_9_0.png" alt = "Bar plot of daily total precipitation for June to Aug 2005.">
<figcaption>Bar plot of daily total precipitation for June to Aug 2005.</figcaption>

</figure>




Notice that labels are not visually appealing with the year included. Given that the data have been subsetted to June to Aug within 2005, the labels can be shorten to remove the year, which is no longer needed. 


## Use DateFormatter to Reformat Date Labels in Matplotlib

To implement the custom date formatting, you can expand your plot code to include new code lines that define the format and then implement the format on the plot.

To begin, define the date format that you want to use as follows:

`date_form = DateFormatter("%m-%d")`

with the `"%m-%d"` specifying that you want the labels to appear like `05-01` for May 1st. 

Then, all the format that you defined using the `set_major_formatter()` method on the x-axis of the plot:

`ax.xaxis.set_major_formatter(date_form)`

Add these lines to your plot code and notice how much nicer the labels appear along the x-axis. 

{:.input}
```python
# Create figure and plot space
fig, ax = plt.subplots(figsize=(12, 12))

# Add x-axis and y-axis
ax.bar(precip_june_aug_2005.index.values,
       precip_june_aug_2005['DAILY_PRECIP'],
       color='purple')

# Set title and labels for axes
ax.set(xlabel="Date",
       ylabel="Precipitation (inches)",
       title="Daily Total Precipitation\nJune - Aug 2005 for Boulder Creek")

# Define the date format
date_form = DateFormatter("%m-%d")
ax.xaxis.set_major_formatter(date_form)

plt.show()
```

{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}/images/courses/intermediate-eds-textbook/01-time-series/plot-time-series-handle-dates/2019-11-19-time-series-05-customize-date-axes-matplotlib/2019-11-19-time-series-05-customize-date-axes-matplotlib_11_0.png" alt = "Bar plot showing daily total precipitation with the x-axis dates shortened to just month and day, so they are easier to read.">
<figcaption>Bar plot showing daily total precipitation with the x-axis dates shortened to just month and day, so they are easier to read.</figcaption>

</figure>




## Modify Frequency of Date Label Ticks

You can actually customize your plot further to identify time specific ticks along the x-axis. 

For example, you could use ticks to indicate each new week using the code:
`xaxis.set_major_locator()` 

to control the location of the ticks.

Using a parameter to this function, you can specify that you want a large tick for each week with:
`mdates.WeekdayLocator(interval=1)`

The `interval` is an integer that represents the weekly frequency of the ticks (e.g. a value of 2 to add a tick mark for every other week). 

Add these lines to your plot code and notice that you now have an at least one tick mark for each week. 

{:.input}
```python
# Create figure and plot space
fig, ax = plt.subplots(figsize=(12, 12))

# Add x-axis and y-axis
ax.bar(precip_june_aug_2005.index.values,
       precip_june_aug_2005['DAILY_PRECIP'],
       color='purple')

# Set title and labels for axes
ax.set(xlabel="Date",
       ylabel="Precipitation (inches)",
       title="Daily Total Precipitation\nJune - Aug 2005 for Boulder Creek")

# Define the date format
date_form = DateFormatter("%m-%d")
ax.xaxis.set_major_formatter(date_form)

# Ensure a major tick for each week using (interval=1) 
ax.xaxis.set_major_locator(mdates.WeekdayLocator(interval=1))

plt.show()
```

{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}/images/courses/intermediate-eds-textbook/01-time-series/plot-time-series-handle-dates/2019-11-19-time-series-05-customize-date-axes-matplotlib/2019-11-19-time-series-05-customize-date-axes-matplotlib_13_0.png" alt = "Bar plot showing daily total precipitation with the x-axis dates cleaned up and the format customized, so they are easier to read.">
<figcaption>Bar plot showing daily total precipitation with the x-axis dates cleaned up and the format customized, so they are easier to read.</figcaption>

</figure>




Note that you can also specify the start and end of the labels by adding a parameter to `ax.set` for `xlim` such as:
    
`xlim=["2005-06-01", "2005-08-31"]`

to have the tick marks start on June 1st and finish on Aug 31st. 

{:.input}
```python
# Create figure and plot space
fig, ax = plt.subplots(figsize=(12, 12))

# Add x-axis and y-axis
ax.bar(precip_june_aug_2005.index.values,
       precip_june_aug_2005['DAILY_PRECIP'],
       color='purple')

# Set title and labels for axes
ax.set(xlabel="Date",
       ylabel="Precipitation (inches)",
       title="Daily Total Precipitation\nJune - Aug 2005 for Boulder Creek",
       xlim=["2005-06-01", "2005-08-31"])

# Define the date format
date_form = DateFormatter("%m-%d")
ax.xaxis.set_major_formatter(date_form)

# Ensure a major tick for each week using (interval=1) 
ax.xaxis.set_major_locator(mdates.WeekdayLocator(interval=1))

plt.show()
```

{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}/images/courses/intermediate-eds-textbook/01-time-series/plot-time-series-handle-dates/2019-11-19-time-series-05-customize-date-axes-matplotlib/2019-11-19-time-series-05-customize-date-axes-matplotlib_15_0.png" alt = "Bar plot showing daily total precipitation with the x-axis date range customized.">
<figcaption>Bar plot showing daily total precipitation with the x-axis date range customized.</figcaption>

</figure>




The code above added labeled major ticks to the plot. 

Note that you can also add minor ticks to your plot using: 

`ax.xaxis.set_minor_locator()`

Given we are using seaborn to customize the look of our plot, minor ticks are not rendered. However, if you wanted to add day ticks to a plot that did have minor ticks turned "on", you could use:

`ax.xaxis.set_minor_locator(mdates.DayLocator())`

with the parameter `mdates.DayLocator()` specifying that you want a tick for each day.

<div class="notice--info" markdown="1">

## Additional Resources

* <a href="https://jakevdp.github.io/PythonDataScienceHandbook/03.11-working-with-time-series.html" target = "_blank">Time Series Data - Data Science Handbook</a>
* <a href = "https://matplotlib.org/examples/pylab_examples/subplots_demo.html" target = "_blank">Matplotlib Plot Demos</a>
* <a href = "http://joseph-long.com/writing/colorbars/" target = "_blank">Color bars in Matplotlib</a> 
* <a href = "https://realpython.com/blog/python/python-matplotlib-guide/" target = "_blank">In-depth guide to plotting</a> 


</div>

<div class="notice--warning" markdown="1">

## <i class="fa fa-pencil-square-o" aria-hidden="true"></i> Practice Your Time Series Skills 

Create plots for the following time subsets for the year of the September 2013 flood and the year before the flood:
* Time period A: 2012-08-01 to 2012-11-01
* Time period B: 2013-08-01 to 2013-11-01

Be sure to set the y limits to be the same for both plots, so they are visually comparable, using the parameter `ylim` for `ax.set()`:

`ylim=[min, max]`

and use the abbreviated month names in the date labels without an additional character between the values such as `Aug 1` for August 1st. 

You can also use `plt.tight_layout()` to ensure that the two plots are spaced evenly within the figure space. 

How different was the rainfall in 2012 compared to 2013?

</div>


{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}/images/courses/intermediate-eds-textbook/01-time-series/plot-time-series-handle-dates/2019-11-19-time-series-05-customize-date-axes-matplotlib/2019-11-19-time-series-05-customize-date-axes-matplotlib_19_0.png" alt = "Bar plots showing daily total precipitation for Aug to Oct in both 2012 and 2013.">
<figcaption>Bar plots showing daily total precipitation for Aug to Oct in both 2012 and 2013.</figcaption>

</figure>



