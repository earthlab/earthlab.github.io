---
layout: single
title: "The Relationship Between Precipitation and Stream Discharge | Explore Mass Balance"
excerpt: "Learn how to create a cumulative sum plot in Pandas to better understand stream discharge in a watershed"
authors: ['Matthew Rossi', 'Leah Wasser']
dateCreated: 2018-02-05
modified: 2020-03-30
category: [courses]
class-lesson: ['time-series-python-tb']
course: 'intermediate-earth-data-science-textbook'
week: 1
permalink: /courses/use-data-open-source-python/use-time-series-data-in-python/date-time-types-in-pandas-python/precipitation-discharge-mass-balance/
nav-title: 'Cumulative Sums in Pandas (Optional)'
sidebar:
  nav:
author_profile: false
comments: true
order: 6
topics:
  reproducible-science-and-programming: ['python']
  data-exploration-and-analysis: ['data-visualization']
redirect_from:
  - "/courses/earth-analytics-python/use-time-series-data-in-python/precipitation-discharge-mass-balance/"
  - "/courses/use-data-open-source-python/use-time-series-data-in-python/precipitation-discharge-mass-balance/"
---

{% include toc title="On This Page" icon="file-text" %}

<div class='notice--success' markdown="1">

## <i class="fa fa-graduation-cap" aria-hidden="true"></i> Learning Objectives

* Create a cumulative sum plot in **Pandas** to better understand stream discharge in a watershed.

</div>

## Introduction to Flood Frequency Analysis

To begin, load all of your libraries.



{:.input}
```python
import os
import urllib
import math
import matplotlib.pyplot as plt
import seaborn as sns
import pandas as pd
import earthpy as et
import hydrofunctions as hf

# Date time conversion registration
from pandas.plotting import register_matplotlib_converters
register_matplotlib_converters()

# Prettier plotting with seaborn
sns.set(font_scale=1.5, style="whitegrid")

# Get the data & set working director
data = et.data.get_data('colorado-flood')
os.chdir(os.path.join(et.io.HOME, 'earth-analytics'))
```


## Download Stream Gage Data

Picking up from the previous lesson... 

{:.input}
```python
# Define the site number and start and end dates that you are interested in
site = "06730500"
start = '1946-05-10'
end = '2018-08-29'

# Request data for that site and time period
longmont_resp = hf.get_nwis(site, 'dv', start, end)

# Convert the response to a json in order to use the extract_nwis_df function
longmont_resp = longmont_resp.json()

# Get metadata about the data
hf.get_nwis(site, 'dv').json()
```

{:.output}
{:.execute_result}



    {'name': 'ns1:timeSeriesResponseType',
     'declaredType': 'org.cuahsi.waterml.TimeSeriesResponseType',
     'scope': 'javax.xml.bind.JAXBElement$GlobalScope',
     'value': {'queryInfo': {'queryURL': 'http://waterservices.usgs.gov/nwis/dv/format=json%2C1.1&sites=06730500&parameterCd=00060',
       'criteria': {'locationParam': '[ALL:06730500]',
        'variableParam': '[00060]',
        'parameter': []},
       'note': [{'value': '[ALL:06730500]', 'title': 'filter:sites'},
        {'value': '[mode=LATEST, modifiedSince=null]',
         'title': 'filter:timeRange'},
        {'value': 'methodIds=[ALL]', 'title': 'filter:methodId'},
        {'value': '2020-03-30T22:46:40.064Z', 'title': 'requestDT'},
        {'value': '51e44c00-72d8-11ea-b343-6cae8b6642ea', 'title': 'requestId'},
        {'value': 'Provisional data are subject to revision. Go to http://waterdata.usgs.gov/nwis/help/?provisional for more information.',
         'title': 'disclaimer'},
        {'value': 'sdas01', 'title': 'server'}]},
      'timeSeries': [{'sourceInfo': {'siteName': 'BOULDER CREEK AT MOUTH NEAR LONGMONT, CO',
         'siteCode': [{'value': '06730500',
           'network': 'NWIS',
           'agencyCode': 'USGS'}],
         'timeZoneInfo': {'defaultTimeZone': {'zoneOffset': '-07:00',
           'zoneAbbreviation': 'MST'},
          'daylightSavingsTimeZone': {'zoneOffset': '-06:00',
           'zoneAbbreviation': 'MDT'},
          'siteUsesDaylightSavingsTime': True},
         'geoLocation': {'geogLocation': {'srs': 'EPSG:4326',
           'latitude': 40.13877778,
           'longitude': -105.0202222},
          'localSiteXY': []},
         'note': [],
         'siteType': [],
         'siteProperty': [{'value': 'ST', 'name': 'siteTypeCd'},
          {'value': '10190005', 'name': 'hucCd'},
          {'value': '08', 'name': 'stateCd'},
          {'value': '08123', 'name': 'countyCd'}]},
        'variable': {'variableCode': [{'value': '00060',
           'network': 'NWIS',
           'vocabulary': 'NWIS:UnitValues',
           'variableID': 45807197,
           'default': True}],
         'variableName': 'Streamflow, ft&#179;/s',
         'variableDescription': 'Discharge, cubic feet per second',
         'valueType': 'Derived Value',
         'unit': {'unitCode': 'ft3/s'},
         'options': {'option': [{'value': 'Mean',
            'name': 'Statistic',
            'optionCode': '00003'}]},
         'note': [],
         'noDataValue': -999999.0,
         'variableProperty': [],
         'oid': '45807197'},
        'values': [{'value': [{'value': '85.0',
            'qualifiers': ['P'],
            'dateTime': '2020-03-29T00:00:00.000'}],
          'qualifier': [{'qualifierCode': 'P',
            'qualifierDescription': 'Provisional data subject to revision.',
            'qualifierID': 0,
            'network': 'NWIS',
            'vocabulary': 'uv_rmk_cd'}],
          'qualityControlLevel': [],
          'method': [{'methodDescription': '', 'methodID': 17666}],
          'source': [],
          'offset': [],
          'sample': [],
          'censorCode': []}],
        'name': 'USGS:06730500:00060:00003'}]},
     'nil': False,
     'globalScope': True,
     'typeSubstituted': False}





{:.input}
```python
# Get the data in a pandas dataframe format
longmont_discharge = hf.extract_nwis_df(longmont_resp)

# Rename columns
longmont_discharge.columns = ["discharge", "flag"]

# Add a year column to your longmont discharge data
longmont_discharge["year"] = longmont_discharge.index.year

# Calculate annual max by resampling
longmont_discharge_annual_max = longmont_discharge.resample('AS').max()

# View first 5 rows
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
# Download usgs annual max data from figshare
url = "https://nwis.waterdata.usgs.gov/nwis/peak?site_no=06730500&agency_cd=USGS&format=rdb"

download_path = os.path.join("data", "colorado-flood", 
                             "downloads", "annual-peak-flow.txt")

urllib.request.urlretrieve(url, download_path)

# Open the data using pandas
usgs_annual_max = pd.read_csv(download_path,
                              comment="#",
                              sep='\t',
                              parse_dates=["peak_dt"],
                              skiprows=[73],
                              usecols=["peak_dt","peak_va"],
                              index_col="peak_dt")
usgs_annual_max.head()

# Add a year column to the data for easier plotting
usgs_annual_max["year"] = usgs_annual_max.index.year

# Remove duplicate years - keep the max discharge value
usgs_annual_max = usgs_annual_max.sort_values(
    'peak_va', ascending=False).drop_duplicates('year').sort_index()

# View cleaned dataframe
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
      <th>peak_va</th>
      <th>year</th>
    </tr>
    <tr>
      <th>peak_dt</th>
      <th></th>
      <th></th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>1927-07-29</th>
      <td>407.0</td>
      <td>1927</td>
    </tr>
    <tr>
      <th>1928-06-04</th>
      <td>694.0</td>
      <td>1928</td>
    </tr>
    <tr>
      <th>1929-07-23</th>
      <td>530.0</td>
      <td>1929</td>
    </tr>
    <tr>
      <th>1930-08-18</th>
      <td>353.0</td>
      <td>1930</td>
    </tr>
    <tr>
      <th>1931-05-29</th>
      <td>369.0</td>
      <td>1931</td>
    </tr>
  </tbody>
</table>
</div>





{:.input}
```python
# Plot calculated vs USGS annual max flow values
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
ax.set_title("Annual Maxima - USGS Peak Flow vs Daily Calculated")

plt.show()
```

{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}/images/courses/intermediate-earth-data-science-textbook/01-time-series/plot-time-series-handle-dates/2019-11-19-time-series-06-cumulative-sum-mass-balance/2019-11-19-time-series-06-cumulative-sum-mass-balance_9_0.png" alt = "Comparison of USGS peak annual max vs calculated annual max from the USGS daily mean data.">
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
# Convert site drainage area to square km
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
longmont_discharge["cum-sum-vol"] = longmont_discharge[
    'discharge'].cumsum()*convert_to_runoff

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
# Plot your data
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

# Reposition the second legend so it renders under the first legend item
ax2.legend(loc = "upper left", bbox_to_anchor=(0.0, 0.9))

fig.tight_layout()

plt.show()
```

{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}/images/courses/intermediate-earth-data-science-textbook/01-time-series/plot-time-series-handle-dates/2019-11-19-time-series-06-cumulative-sum-mass-balance/2019-11-19-time-series-06-cumulative-sum-mass-balance_16_0.png" alt = "Cumulative sum plot for stream discharge.">
<figcaption>Cumulative sum plot for stream discharge.</figcaption>

</figure>



