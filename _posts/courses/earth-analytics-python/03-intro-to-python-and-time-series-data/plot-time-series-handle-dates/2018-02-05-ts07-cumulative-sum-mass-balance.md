---
layout: single
title: "The Relationship Between Precipitation and Stream Discharge | Explore Mass Balance"
excerpt: "Learn how to create a cumulative sum plot in Pandas to better understand stream discharge in a watershed"
authors: ['Matthew Rossi', 'Leah Wasser']
modified: 2018-10-08
category: [courses]
class-lesson: ['time-series-python']
course: 'earth-analytics-python'
week: 3
permalink: /courses/earth-analytics-python/use-time-series-data-in-python/precipitation-discharge-mass-balance/
nav-title: 'Cumulative Sums in Pandas (Optional)'
sidebar:
  nav:
author_profile: false
comments: true
order: 7
topics:
---

## Introduction to Flood Frequency Analysis

To begin, load all of your libraries.

{:.input}
```python
import hydrofunctions as hf
import urllib
import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
import os
import math
plt.ion()
# set standard plot parameters for uniform plotting
plt.rcParams['figure.figsize'] = (11, 6)
# prettier plotting with seaborn
import seaborn as sns; 
sns.set(font_scale=1.5)
sns.set_style("whitegrid")
# set working dir and import earthpy
import earthpy as et
os.chdir(os.path.join(et.io.HOME, 'earth-analytics'))
```

## Download Stream Gage Data
picking up from the previous lesson... 

{:.input}
```python
# define the site number and start and end dates that you are interested in
site = "06730500"
start = '1946-05-10'
end = '2018-08-29'

# then request data for that site and time period 
longmont_resp = hf.get_nwis(site, 'dv', start, end)
# get the data in a pandas dataframe format
longmont_discharge = hf.extract_nwis_df(longmont_resp)
# rename columns
longmont_discharge.columns = ["discharge", "flag"]
# view first 5 rows
# add a year column to your longmont discharge data
longmont_discharge["year"]=longmont_discharge.index.year

# Calculate annual max by resampling
longmont_discharge_annual_max = longmont_discharge.resample('AS').max()
longmont_discharge_annual_max.head()
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
      <th>discharge</th>
      <th>flag</th>
      <th>year</th>
    </tr>
    <tr>
      <th>datetime</th>
      <th></th>
      <th></th>
      <th></th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>1946-01-01</th>
      <td>99.0</td>
      <td>A</td>
      <td>1946.0</td>
    </tr>
    <tr>
      <th>1947-01-01</th>
      <td>1930.0</td>
      <td>A</td>
      <td>1947.0</td>
    </tr>
    <tr>
      <th>1948-01-01</th>
      <td>339.0</td>
      <td>A</td>
      <td>1948.0</td>
    </tr>
    <tr>
      <th>1949-01-01</th>
      <td>2010.0</td>
      <td>A</td>
      <td>1949.0</td>
    </tr>
    <tr>
      <th>1950-01-01</th>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
    </tr>
  </tbody>
</table>
</div>





{:.input}
```python
# download usgs annual max data from figshare
url = "https://nwis.waterdata.usgs.gov/nwis/peak?site_no=06730500&agency_cd=USGS&format=rdb"
download_path = "data/colorado-flood/downloads/annual-peak-flow.txt"
urllib.request.urlretrieve(url, download_path)
# open the data using pandas
usgs_annual_max = pd.read_csv(download_path,
                              skiprows = 63,
                              header=[1,2], 
                              sep='\t', 
                              parse_dates = [2])
# drop one level of index
usgs_annual_max.columns = usgs_annual_max.columns.droplevel(1)
# finally set the date column as the index
usgs_annual_max = usgs_annual_max.set_index(['peak_dt'])

# optional - remove columns we don't need - this is just to make the lesson easier to read
# you can skip this step if you want
usgs_annual_max = usgs_annual_max.drop(["gage_ht_cd", "year_last_pk","ag_dt", "ag_gage_ht", "ag_tm", "ag_gage_ht_cd"], axis=1)

# add a year column to the data for easier plotting
usgs_annual_max["year"] = usgs_annual_max.index.year
# remove duplicate years - keep the max discharge value
usgs_annual_max = usgs_annual_max.sort_values('peak_va', ascending=False).drop_duplicates('year').sort_index()
# view cleaned dataframe
usgs_annual_max.head()
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
      <th>peak_tm</th>
      <th>peak_va</th>
      <th>peak_cd</th>
      <th>gage_ht</th>
      <th>year</th>
    </tr>
    <tr>
      <th>peak_dt</th>
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
      <th>1927-07-29</th>
      <td>USGS</td>
      <td>6730500</td>
      <td>06:00</td>
      <td>407.0</td>
      <td>5</td>
      <td>3.00</td>
      <td>1927</td>
    </tr>
    <tr>
      <th>1928-06-04</th>
      <td>USGS</td>
      <td>6730500</td>
      <td>09:00</td>
      <td>694.0</td>
      <td>5</td>
      <td>3.84</td>
      <td>1928</td>
    </tr>
    <tr>
      <th>1929-07-23</th>
      <td>USGS</td>
      <td>6730500</td>
      <td>15:00</td>
      <td>530.0</td>
      <td>5</td>
      <td>3.40</td>
      <td>1929</td>
    </tr>
    <tr>
      <th>1930-08-18</th>
      <td>USGS</td>
      <td>6730500</td>
      <td>05:00</td>
      <td>353.0</td>
      <td>5</td>
      <td>2.94</td>
      <td>1930</td>
    </tr>
    <tr>
      <th>1931-05-29</th>
      <td>USGS</td>
      <td>6730500</td>
      <td>09:00</td>
      <td>369.0</td>
      <td>5</td>
      <td>2.88</td>
      <td>1931</td>
    </tr>
  </tbody>
</table>
</div>





{:.input}
```python
# plot calculated vs USGS annual max flow values
fig, ax = plt.subplots(figsize = (11,9))
ax.plot(usgs_annual_max["year"], 
        usgs_annual_max["peak_va"],
        color = "purple",
        linestyle=':', 
        marker='o', 
        label = "USGS Annual Max")
ax.plot(longmont_discharge_annual_max["year"], 
        longmont_discharge_annual_max["discharge"],
        color = "lightgrey",
        linestyle=':', 
        marker='o', label = "Calculated Annual Max")
ax.legend()
ax.set_title("Annual Maxima - USGS Peak Flow vs Daily Calculated");
```

{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}//images/courses/earth-analytics-python/03-intro-to-python-and-time-series-data/plot-time-series-handle-dates/2018-02-05-ts07-cumulative-sum-mass-balance_6_0.png" alt = "Comparison of USGS peak annual max vs calculated annual max from the USGS daily mean data.">
<figcaption>Comparison of USGS peak annual max vs calculated annual max from the USGS daily mean data.</figcaption>

</figure>




## Calculate Cumulative Sum

Next you will create a plot that shows both stream discharge the the total cumulative runnof that it represents over the time period of interest. This plot is useful as you will be able to compare this to a plot of precipitation that you create for your homework. 

Together - stream runoff and precipitation can be explored to better understand the mass balance of water in your watershed of interest. The total precipitation in the watershed minus the total runoff can be used to calculate how much water is being "lost" in the system to evapotranspiration. The steps are as follows:

1. Calculate the cumulative sum using the `.cumsum()` method in pandas.
2. Convert CFS (Cubic Feet per Second) to a more meaningful unit of runoff by
    * converting CFS to Cubic feet per day
    * divide this value by the total area in the watershed to get a volume of water per area

<a href="https://waterdata.usgs.gov/nwis/inventory/?site_no=06730500" target = "_blank">USGS Site page</a> has the area of the site drainage area: 447 square miles

{:.input}
```python
# convert site drainage area to square km
miles_km = 2.58999
site_drainage = 447
longmont_area = site_drainage * miles_km
print("The site drainage area in square km =", longmont_area)
```

{:.output}
    The site drainage area in square km = 1157.72553



Next you calculate the cumulative sum, convert that to cubic feet per day and then divide by the drainage area.


{:.input}
```python
convert_to_cub_feet_day = (60*60*24)

convert_to_runoff = convert_to_cub_feet_day*longmont_area
convert_to_runoff
```

{:.output}
{:.execute_result}



    100027485.792





{:.input}
```python
# MAR - Mean Annual Runoff
longmont_discharge["cum-sum-vol"] = longmont_discharge['discharge'].cumsum()*convert_to_runoff
longmont_discharge.head()
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
      <th>discharge</th>
      <th>flag</th>
      <th>year</th>
      <th>cum-sum-vol</th>
    </tr>
    <tr>
      <th>datetime</th>
      <th></th>
      <th></th>
      <th></th>
      <th></th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>1946-05-10</th>
      <td>16.0</td>
      <td>A</td>
      <td>1946</td>
      <td>1.600440e+09</td>
    </tr>
    <tr>
      <th>1946-05-11</th>
      <td>19.0</td>
      <td>A</td>
      <td>1946</td>
      <td>3.500962e+09</td>
    </tr>
    <tr>
      <th>1946-05-12</th>
      <td>9.0</td>
      <td>A</td>
      <td>1946</td>
      <td>4.401209e+09</td>
    </tr>
    <tr>
      <th>1946-05-13</th>
      <td>3.0</td>
      <td>A</td>
      <td>1946</td>
      <td>4.701292e+09</td>
    </tr>
    <tr>
      <th>1946-05-14</th>
      <td>7.8</td>
      <td>A</td>
      <td>1946</td>
      <td>5.481506e+09</td>
    </tr>
  </tbody>
</table>
</div>





## Plot Cumulative Sum of Runnof and Daily Mean Discharge Together

Finally you can plot cumulative sum on top of your discharge values. This plot is an interesting way to to view increases and decreases in discharge as they occur over time.

### Creating this Plot
Notice below you have two sets of data with different Y axes on the same plot. The key to making this work is 
this:

`ax2 = ax.twinx()`

Where you define a second axis but tell matplotlib to create that axis on the `ax` object in your figure.

{:.input}
```python
# plot your data
fig, ax = plt.subplots(figsize=(11,7))
longmont_discharge["cum-sum-vol"].plot(ax=ax, label = "Cumulative Volume")

# Make the y-axis label, ticks and tick labels match the line color.
ax.set_ylabel('Total Area Runoff', color='b')
ax.tick_params('y', colors='b')

ax2 = ax.twinx()
ax2.scatter(x=longmont_discharge.index, 
        y=longmont_discharge["discharge"], 
        marker="o",
        s=4, 
        color ="purple", label="Daily Mean")
ax2.set_ylabel('Stream Discharge (CFS)', color='purple')
ax2.tick_params('y', colors='purple')
ax2.set_ylim(0,10000)
ax.set_title("Cumulative Sum & Daily Mean Discharge")
ax.legend()

# reposition the second legend so it renders under the first legend item
ax2.legend(loc = "upper left", bbox_to_anchor=(0.0, 0.9))
fig.tight_layout()
plt.show()

```

{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}//images/courses/earth-analytics-python/03-intro-to-python-and-time-series-data/plot-time-series-handle-dates/2018-02-05-ts07-cumulative-sum-mass-balance_13_0.png" alt = "Cumulative sum plot for stream discharge.">
<figcaption>Cumulative sum plot for stream discharge.</figcaption>

</figure>



