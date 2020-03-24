---
layout: single
title: 'Programmatically Accessing Geospatial Data Using APIs'
excerpt: 'This lesson walks through the process of retrieving and manipulating surface water data housed in the Colorado Information Warehouse. These data are stored in JSON format with spatial x, y information that support mapping.'
authors: ['Carson Farmer', 'Leah Wasser', 'Max Joseph', 'Martha Morrissey', 'Jenny Palomino']
modified: 2020-03-24
category: [courses]
class-lesson: ['intro-APIs-python']
permalink: /courses/earth-analytics-python/using-apis-natural-language-processing-twitter/co-water-data-spatial-python/
nav-title: 'Geospatial Data From APIs'
week: 7
sidebar:
    nav:
author_profile: false
comments: true
order: 4
course: "intermediate-earth-data-science-textbook"
topics:
    find-and-manage-data: ['apis']
redirect_from:
  - "/courses/earth-analytics-python/using-apis-natural-language-processing-twitter/co-water-data-spatial-python/"
---
{% include toc title = "In This Lesson" icon="file-text" %}

<div class='notice--success' markdown="1">

## <i class="fa fa-graduation-cap" aria-hidden="true"></i> Learning Objectives

After completing this tutorial, you will be able to:

* Extract geospatial (x,y) coordinate information embedded within a `JSON` hierarchical data structure.
* Convert data imported in `JSON` format into a `Geopandas` `DataFrame`.
* Create a map of geospatial data.


## <i class="fa fa-check-square-o fa-2" aria-hidden="true"></i> What You Need

You will need a computer with internet access to complete this lesson.

</div>

In this lesson, you work with `JSON` data accessed via the Colorado information warehouse. The data will contain geospatial information nested within it that will allow us to create a map of the data.

## Working with Geospatial Data

Check out the map <a href="https://data.colorado.gov/Water/DWR-Current-Surface-Water-Conditions-Map-Statewide/j5pc-4t32" target="_blank"> Colorado DWR Current Surface Water Conditions map</a>. 

Remember from the previous lesson, APIs can be used for many different things. Web developers (people who program and create web sites and cool applications) can use APIs to create user friendly interfaces - like the map in the previous example that allows us to look at and interact with data. These APIs are similar to, if not the same as, the ones that you often use to access data in `Python`.

In this lesson, you will access the data used to create the map at the link above using `Python`.

* The data that you will use are located here: <a href="https://data.colorado.gov/resource/j5pc-4t32.json" target="_blank">View JSON format data used to create surface water map.</a>
* And you can learn more about the data here: <a href="https://data.colorado.gov/Water/DWR-Current-Surface-Water-Conditions/4yw9-a5y6" target="_blank">View CO Current water surface </a>.

{:.input}
```python
import requests
import folium
import urllib
from pandas.io.json import json_normalize
import pandas as pd
import folium
from geopandas import GeoDataFrame
from shapely.geometry import Point
```

{:.input}
```python
# Get URL
water_base_url = "https://data.colorado.gov/resource/j5pc-4t32.json?"
water_full_url = water_base_url + "station_status=Active" + "&county=BOULDER"
```

<i class="fa fa-lightbulb-o" aria-hidden="true"></i> **ATTENTION WINDOWS USERS:**
We have noticed a bug where on windows machines, sometimes the https URL doesn't work.
Instead try the same url as above but without the `s` - like this: `water_base_url = "http://data.colorado.gov/resource/j5pc-4t32.json?"` This change has resolved many issues on windows machines so give it a try if you are having problems with the API.
{: .notice--success }

{:.input}
```python
water_full_url
```

{:.output}
{:.execute_result}



    'https://data.colorado.gov/resource/j5pc-4t32.json?station_status=Active&county=BOULDER'





{:.input}
```python
data = requests.get(water_full_url)
```

{:.input}
```python
type(data.json())
```

{:.output}
{:.execute_result}



    list





Remember that the JSON structure supports hierarchical data and can be NESTED. If you look at the structure of the `.json` file below, you can see that the location object, is nested with three sub objects:

* latitude
* longitude
* needs_recoding

Since `data.json()` is a `list` you can print out just the first few items of the list to look at your data as a sanity check.

{:.input}
```python
data.json()[:2]
```

{:.output}
{:.execute_result}



    [{'station_name': 'ZWECK AND TURNER DITCH',
      'div': '1',
      'location': {'latitude': '40.185033',
       'needs_recoding': False,
       'longitude': '-105.185789'},
      'dwr_abbrev': 'ZWETURCO',
      'data_source': 'Cooperative Program of CDWR, NCWCD & SVLHWCD',
      'amount': '0.14',
      'station_type': 'Diversion',
      'wd': '5',
      'http_linkage': {'url': 'https://dwr.state.co.us/SurfaceWater/data/detail_graph.aspx?ID=ZWETURCO&MTYPE=DISCHRG'},
      'date_time': '2020-03-24T08:00:00.000',
      'county': 'BOULDER',
      'variable': 'DISCHRG',
      'stage': '0.05',
      'station_status': 'Active'},
     {'station_name': 'SAINT VRAIN CREEK AT LYONS, CO',
      'div': '1',
      'location': {'latitude': '40.220702',
       'needs_recoding': False,
       'longitude': '-105.26349'},
      'dwr_abbrev': 'SVCLYOCO',
      'data_source': 'Co. Division of Water Resources',
      'usgs_station_id': '06724000',
      'amount': '39.20',
      'station_type': 'Stream',
      'wd': '5',
      'http_linkage': {'url': 'https://dwr.state.co.us/SurfaceWater/data/detail_graph.aspx?ID=SVCLYOCO&MTYPE=DISCHRG'},
      'date_time': '2020-03-24T08:15:00.000',
      'county': 'BOULDER',
      'variable': 'DISCHRG',
      'stage': '2.97',
      'station_status': 'Active'}]





## Convert JSON to Pandas DataFrame

Now that you have pulled down the data from the website, you have it in the `JSON` format. For the next step, you will use the `json_normalize()` function from the `Pandas` library to convert this data into a `Pandas DataFrame.` 

This function helps organize and flatten data into a semi-structed table. To learn more, check out the <a href="https://pandas.pydata.org/pandas-docs/stable/generated/pandas.io.json.json_normalize.html" target="_blank">documentation</a>! 

{:.input}
```python
from pandas.io.json import json_normalize
```

{:.input}
```python
result = json_normalize(data.json())
```

{:.output}
    /opt/conda/lib/python3.7/site-packages/ipykernel_launcher.py:1: FutureWarning: pandas.io.json.json_normalize is deprecated, use pandas.json_normalize instead
      """Entry point for launching an IPython kernel.



{:.input}
```python
result.head()
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
      <th>station_name</th>
      <th>div</th>
      <th>dwr_abbrev</th>
      <th>data_source</th>
      <th>amount</th>
      <th>station_type</th>
      <th>wd</th>
      <th>date_time</th>
      <th>county</th>
      <th>variable</th>
      <th>stage</th>
      <th>station_status</th>
      <th>location.latitude</th>
      <th>location.needs_recoding</th>
      <th>location.longitude</th>
      <th>http_linkage.url</th>
      <th>usgs_station_id</th>
      <th>flag</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>ZWECK AND TURNER DITCH</td>
      <td>1</td>
      <td>ZWETURCO</td>
      <td>Cooperative Program of CDWR, NCWCD &amp; SVLHWCD</td>
      <td>0.14</td>
      <td>Diversion</td>
      <td>5</td>
      <td>2020-03-24T08:00:00.000</td>
      <td>BOULDER</td>
      <td>DISCHRG</td>
      <td>0.05</td>
      <td>Active</td>
      <td>40.185033</td>
      <td>False</td>
      <td>-105.185789</td>
      <td>https://dwr.state.co.us/SurfaceWater/data/deta...</td>
      <td>NaN</td>
      <td>NaN</td>
    </tr>
    <tr>
      <th>1</th>
      <td>SAINT VRAIN CREEK AT LYONS, CO</td>
      <td>1</td>
      <td>SVCLYOCO</td>
      <td>Co. Division of Water Resources</td>
      <td>39.20</td>
      <td>Stream</td>
      <td>5</td>
      <td>2020-03-24T08:15:00.000</td>
      <td>BOULDER</td>
      <td>DISCHRG</td>
      <td>2.97</td>
      <td>Active</td>
      <td>40.220702</td>
      <td>False</td>
      <td>-105.26349</td>
      <td>https://dwr.state.co.us/SurfaceWater/data/deta...</td>
      <td>06724000</td>
      <td>NaN</td>
    </tr>
    <tr>
      <th>2</th>
      <td>OLIGARCHY DITCH DIVERSION</td>
      <td>1</td>
      <td>OLIDITCO</td>
      <td>Cooperative Program of CDWR, NCWCD &amp; SVLHWCD</td>
      <td>4.01</td>
      <td>Diversion</td>
      <td>5</td>
      <td>2020-03-24T06:45:00.000</td>
      <td>BOULDER</td>
      <td>DISCHRG</td>
      <td>0.24</td>
      <td>Active</td>
      <td>40.196422</td>
      <td>False</td>
      <td>-105.206592</td>
      <td>https://dwr.state.co.us/SurfaceWater/data/deta...</td>
      <td>NaN</td>
      <td>NaN</td>
    </tr>
    <tr>
      <th>3</th>
      <td>SOUTH BOULDER CREEK DIVERSION NEAR ELDORADO SP...</td>
      <td>1</td>
      <td>BOSDELCO</td>
      <td>Co. Division of Water Resources</td>
      <td>0.00</td>
      <td>Diversion</td>
      <td>6</td>
      <td>2020-03-24T08:30:00.000</td>
      <td>BOULDER</td>
      <td>DISCHRG</td>
      <td>-1.70</td>
      <td>Active</td>
      <td>39.931813</td>
      <td>False</td>
      <td>-105.308432</td>
      <td>https://dwr.state.co.us/SurfaceWater/data/deta...</td>
      <td>NaN</td>
      <td>NaN</td>
    </tr>
    <tr>
      <th>4</th>
      <td>CLOUGH AND TRUE DITCH</td>
      <td>1</td>
      <td>CLODITCO</td>
      <td>Cooperative Program of CDWR, NCWCD &amp; SVLHWCD</td>
      <td>0.00</td>
      <td>Diversion</td>
      <td>5</td>
      <td>2020-03-24T08:00:00.000</td>
      <td>BOULDER</td>
      <td>DISCHRG</td>
      <td>NaN</td>
      <td>Active</td>
      <td>40.193758</td>
      <td>False</td>
      <td>-105.21039</td>
      <td>https://dwr.state.co.us/SurfaceWater/data/deta...</td>
      <td>NaN</td>
      <td>NaN</td>
    </tr>
  </tbody>
</table>
</div>





{:.input}
```python
type(result)
```

{:.output}
{:.execute_result}



    pandas.core.frame.DataFrame





{:.input}
```python
result.columns
```

{:.output}
{:.execute_result}



    Index(['station_name', 'div', 'dwr_abbrev', 'data_source', 'amount',
           'station_type', 'wd', 'date_time', 'county', 'variable', 'stage',
           'station_status', 'location.latitude', 'location.needs_recoding',
           'location.longitude', 'http_linkage.url', 'usgs_station_id', 'flag'],
          dtype='object')





## Data Cleaning for Visualization

Now you can clean up the data. Notice that your longitude and latitude values are stored as strings. Do you think can create a map if these values are stored as strings?

{:.input}
```python
result['location.latitude'][0]
```

{:.output}
{:.execute_result}



    '40.185033'





You can convert the strings to type `float` as follows. 

{:.input}
```python
result['location.latitude'] = result['location.latitude'].astype(float)
```

{:.input}
```python
result['location.latitude'][0]
```

{:.output}
{:.execute_result}



    40.185033





{:.input}
```python
result['location.longitude'] = result['location.longitude'].astype(float)
```

{:.input}
```python
result['location.longitude'][0]
```

{:.output}
{:.execute_result}



    -105.185789





Now that you have numeric values for mapping, make sure that are are no missing values. 

{:.input}
```python
result.shape
```

{:.output}
{:.execute_result}



    (50, 18)





{:.input}
```python
result['location.longitude'].isna().any()
```

{:.output}
{:.execute_result}



    False





{:.input}
```python
result['location.latitude'].isna().any()
```

{:.output}
{:.execute_result}



    False





There are no `nan` values in this data. However, if there were, you could remove rows where a column has a `nan` value in a specific column with the following: 
`result_nonan = result.dropna(subset=['location.longitude', 'location.latitude'])`

## Data Visualization 

You will use the `folium` package to visualize the data. One approach you could take would be to convert your `Pandas DataFrame` to a `Geopandas DataFrame` for easy mapping.

{:.input}
```python
geometry = [Point(xy) for xy in zip(result['location.longitude'], result['location.latitude'])]
crs = {'init': 'epsg:4326'}
gdf = GeoDataFrame(result, crs=crs, geometry=geometry)
```

{:.input}
```python
gdf.head()
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
      <th>station_name</th>
      <th>div</th>
      <th>dwr_abbrev</th>
      <th>data_source</th>
      <th>amount</th>
      <th>station_type</th>
      <th>wd</th>
      <th>date_time</th>
      <th>county</th>
      <th>variable</th>
      <th>stage</th>
      <th>station_status</th>
      <th>location.latitude</th>
      <th>location.needs_recoding</th>
      <th>location.longitude</th>
      <th>http_linkage.url</th>
      <th>usgs_station_id</th>
      <th>flag</th>
      <th>geometry</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>ZWECK AND TURNER DITCH</td>
      <td>1</td>
      <td>ZWETURCO</td>
      <td>Cooperative Program of CDWR, NCWCD &amp; SVLHWCD</td>
      <td>0.14</td>
      <td>Diversion</td>
      <td>5</td>
      <td>2020-03-24T08:00:00.000</td>
      <td>BOULDER</td>
      <td>DISCHRG</td>
      <td>0.05</td>
      <td>Active</td>
      <td>40.185033</td>
      <td>False</td>
      <td>-105.185789</td>
      <td>https://dwr.state.co.us/SurfaceWater/data/deta...</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>POINT (-105.18579 40.18503)</td>
    </tr>
    <tr>
      <th>1</th>
      <td>SAINT VRAIN CREEK AT LYONS, CO</td>
      <td>1</td>
      <td>SVCLYOCO</td>
      <td>Co. Division of Water Resources</td>
      <td>39.20</td>
      <td>Stream</td>
      <td>5</td>
      <td>2020-03-24T08:15:00.000</td>
      <td>BOULDER</td>
      <td>DISCHRG</td>
      <td>2.97</td>
      <td>Active</td>
      <td>40.220702</td>
      <td>False</td>
      <td>-105.263490</td>
      <td>https://dwr.state.co.us/SurfaceWater/data/deta...</td>
      <td>06724000</td>
      <td>NaN</td>
      <td>POINT (-105.26349 40.22070)</td>
    </tr>
    <tr>
      <th>2</th>
      <td>OLIGARCHY DITCH DIVERSION</td>
      <td>1</td>
      <td>OLIDITCO</td>
      <td>Cooperative Program of CDWR, NCWCD &amp; SVLHWCD</td>
      <td>4.01</td>
      <td>Diversion</td>
      <td>5</td>
      <td>2020-03-24T06:45:00.000</td>
      <td>BOULDER</td>
      <td>DISCHRG</td>
      <td>0.24</td>
      <td>Active</td>
      <td>40.196422</td>
      <td>False</td>
      <td>-105.206592</td>
      <td>https://dwr.state.co.us/SurfaceWater/data/deta...</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>POINT (-105.20659 40.19642)</td>
    </tr>
    <tr>
      <th>3</th>
      <td>SOUTH BOULDER CREEK DIVERSION NEAR ELDORADO SP...</td>
      <td>1</td>
      <td>BOSDELCO</td>
      <td>Co. Division of Water Resources</td>
      <td>0.00</td>
      <td>Diversion</td>
      <td>6</td>
      <td>2020-03-24T08:30:00.000</td>
      <td>BOULDER</td>
      <td>DISCHRG</td>
      <td>-1.70</td>
      <td>Active</td>
      <td>39.931813</td>
      <td>False</td>
      <td>-105.308432</td>
      <td>https://dwr.state.co.us/SurfaceWater/data/deta...</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>POINT (-105.30843 39.93181)</td>
    </tr>
    <tr>
      <th>4</th>
      <td>CLOUGH AND TRUE DITCH</td>
      <td>1</td>
      <td>CLODITCO</td>
      <td>Cooperative Program of CDWR, NCWCD &amp; SVLHWCD</td>
      <td>0.00</td>
      <td>Diversion</td>
      <td>5</td>
      <td>2020-03-24T08:00:00.000</td>
      <td>BOULDER</td>
      <td>DISCHRG</td>
      <td>NaN</td>
      <td>Active</td>
      <td>40.193758</td>
      <td>False</td>
      <td>-105.210390</td>
      <td>https://dwr.state.co.us/SurfaceWater/data/deta...</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>POINT (-105.21039 40.19376)</td>
    </tr>
  </tbody>
</table>
</div>





Then, you can plot the data using the folium functions `GeoJson()` and `add_to()` to add the data from the `Geopandas DataFrame` to the map object. 

{:.input}
```python
m = folium.Map([40.01, -105.27], zoom_start= 10, tiles='cartodbpositron')
folium.GeoJson(gdf).add_to(m)

m
```

{:.output}
{:.execute_result}



<div style="width:100%;"><div style="position:relative;width:100%;height:0;padding-bottom:60%;"><iframe src="data:text/html;charset=utf-8;base64,PCFET0NUWVBFIGh0bWw+CjxoZWFkPiAgICAKICAgIDxtZXRhIGh0dHAtZXF1aXY9ImNvbnRlbnQtdHlwZSIgY29udGVudD0idGV4dC9odG1sOyBjaGFyc2V0PVVURi04IiAvPgogICAgCiAgICAgICAgPHNjcmlwdD4KICAgICAgICAgICAgTF9OT19UT1VDSCA9IGZhbHNlOwogICAgICAgICAgICBMX0RJU0FCTEVfM0QgPSBmYWxzZTsKICAgICAgICA8L3NjcmlwdD4KICAgIAogICAgPHNjcmlwdCBzcmM9Imh0dHBzOi8vY2RuLmpzZGVsaXZyLm5ldC9ucG0vbGVhZmxldEAxLjUuMS9kaXN0L2xlYWZsZXQuanMiPjwvc2NyaXB0PgogICAgPHNjcmlwdCBzcmM9Imh0dHBzOi8vY29kZS5qcXVlcnkuY29tL2pxdWVyeS0xLjEyLjQubWluLmpzIj48L3NjcmlwdD4KICAgIDxzY3JpcHQgc3JjPSJodHRwczovL21heGNkbi5ib290c3RyYXBjZG4uY29tL2Jvb3RzdHJhcC8zLjIuMC9qcy9ib290c3RyYXAubWluLmpzIj48L3NjcmlwdD4KICAgIDxzY3JpcHQgc3JjPSJodHRwczovL2NkbmpzLmNsb3VkZmxhcmUuY29tL2FqYXgvbGlicy9MZWFmbGV0LmF3ZXNvbWUtbWFya2Vycy8yLjAuMi9sZWFmbGV0LmF3ZXNvbWUtbWFya2Vycy5qcyI+PC9zY3JpcHQ+CiAgICA8bGluayByZWw9InN0eWxlc2hlZXQiIGhyZWY9Imh0dHBzOi8vY2RuLmpzZGVsaXZyLm5ldC9ucG0vbGVhZmxldEAxLjUuMS9kaXN0L2xlYWZsZXQuY3NzIi8+CiAgICA8bGluayByZWw9InN0eWxlc2hlZXQiIGhyZWY9Imh0dHBzOi8vbWF4Y2RuLmJvb3RzdHJhcGNkbi5jb20vYm9vdHN0cmFwLzMuMi4wL2Nzcy9ib290c3RyYXAubWluLmNzcyIvPgogICAgPGxpbmsgcmVsPSJzdHlsZXNoZWV0IiBocmVmPSJodHRwczovL21heGNkbi5ib290c3RyYXBjZG4uY29tL2Jvb3RzdHJhcC8zLjIuMC9jc3MvYm9vdHN0cmFwLXRoZW1lLm1pbi5jc3MiLz4KICAgIDxsaW5rIHJlbD0ic3R5bGVzaGVldCIgaHJlZj0iaHR0cHM6Ly9tYXhjZG4uYm9vdHN0cmFwY2RuLmNvbS9mb250LWF3ZXNvbWUvNC42LjMvY3NzL2ZvbnQtYXdlc29tZS5taW4uY3NzIi8+CiAgICA8bGluayByZWw9InN0eWxlc2hlZXQiIGhyZWY9Imh0dHBzOi8vY2RuanMuY2xvdWRmbGFyZS5jb20vYWpheC9saWJzL0xlYWZsZXQuYXdlc29tZS1tYXJrZXJzLzIuMC4yL2xlYWZsZXQuYXdlc29tZS1tYXJrZXJzLmNzcyIvPgogICAgPGxpbmsgcmVsPSJzdHlsZXNoZWV0IiBocmVmPSJodHRwczovL3Jhd2Nkbi5naXRoYWNrLmNvbS9weXRob24tdmlzdWFsaXphdGlvbi9mb2xpdW0vbWFzdGVyL2ZvbGl1bS90ZW1wbGF0ZXMvbGVhZmxldC5hd2Vzb21lLnJvdGF0ZS5jc3MiLz4KICAgIDxzdHlsZT5odG1sLCBib2R5IHt3aWR0aDogMTAwJTtoZWlnaHQ6IDEwMCU7bWFyZ2luOiAwO3BhZGRpbmc6IDA7fTwvc3R5bGU+CiAgICA8c3R5bGU+I21hcCB7cG9zaXRpb246YWJzb2x1dGU7dG9wOjA7Ym90dG9tOjA7cmlnaHQ6MDtsZWZ0OjA7fTwvc3R5bGU+CiAgICAKICAgICAgICAgICAgPG1ldGEgbmFtZT0idmlld3BvcnQiIGNvbnRlbnQ9IndpZHRoPWRldmljZS13aWR0aCwKICAgICAgICAgICAgICAgIGluaXRpYWwtc2NhbGU9MS4wLCBtYXhpbXVtLXNjYWxlPTEuMCwgdXNlci1zY2FsYWJsZT1ubyIgLz4KICAgICAgICAgICAgPHN0eWxlPgogICAgICAgICAgICAgICAgI21hcF9mYTlmNjVjM2EzYjE0YjU1YjE2NDg1NjY4M2YwMzhiOSB7CiAgICAgICAgICAgICAgICAgICAgcG9zaXRpb246IHJlbGF0aXZlOwogICAgICAgICAgICAgICAgICAgIHdpZHRoOiAxMDAuMCU7CiAgICAgICAgICAgICAgICAgICAgaGVpZ2h0OiAxMDAuMCU7CiAgICAgICAgICAgICAgICAgICAgbGVmdDogMC4wJTsKICAgICAgICAgICAgICAgICAgICB0b3A6IDAuMCU7CiAgICAgICAgICAgICAgICB9CiAgICAgICAgICAgIDwvc3R5bGU+CiAgICAgICAgCjwvaGVhZD4KPGJvZHk+ICAgIAogICAgCiAgICAgICAgICAgIDxkaXYgY2xhc3M9ImZvbGl1bS1tYXAiIGlkPSJtYXBfZmE5ZjY1YzNhM2IxNGI1NWIxNjQ4NTY2ODNmMDM4YjkiID48L2Rpdj4KICAgICAgICAKPC9ib2R5Pgo8c2NyaXB0PiAgICAKICAgIAogICAgICAgICAgICB2YXIgbWFwX2ZhOWY2NWMzYTNiMTRiNTViMTY0ODU2NjgzZjAzOGI5ID0gTC5tYXAoCiAgICAgICAgICAgICAgICAibWFwX2ZhOWY2NWMzYTNiMTRiNTViMTY0ODU2NjgzZjAzOGI5IiwKICAgICAgICAgICAgICAgIHsKICAgICAgICAgICAgICAgICAgICBjZW50ZXI6IFs0MC4wMSwgLTEwNS4yN10sCiAgICAgICAgICAgICAgICAgICAgY3JzOiBMLkNSUy5FUFNHMzg1NywKICAgICAgICAgICAgICAgICAgICB6b29tOiAxMCwKICAgICAgICAgICAgICAgICAgICB6b29tQ29udHJvbDogdHJ1ZSwKICAgICAgICAgICAgICAgICAgICBwcmVmZXJDYW52YXM6IGZhbHNlLAogICAgICAgICAgICAgICAgfQogICAgICAgICAgICApOwoKICAgICAgICAgICAgCgogICAgICAgIAogICAgCiAgICAgICAgICAgIHZhciB0aWxlX2xheWVyXzYzOWY0ZjhjNDdkYjQwZDU4Mzc3NTIzOTU2OTdlMGVjID0gTC50aWxlTGF5ZXIoCiAgICAgICAgICAgICAgICAiaHR0cHM6Ly9jYXJ0b2RiLWJhc2VtYXBzLXtzfS5nbG9iYWwuc3NsLmZhc3RseS5uZXQvbGlnaHRfYWxsL3t6fS97eH0ve3l9LnBuZyIsCiAgICAgICAgICAgICAgICB7ImF0dHJpYnV0aW9uIjogIlx1MDAyNmNvcHk7IFx1MDAzY2EgaHJlZj1cImh0dHA6Ly93d3cub3BlbnN0cmVldG1hcC5vcmcvY29weXJpZ2h0XCJcdTAwM2VPcGVuU3RyZWV0TWFwXHUwMDNjL2FcdTAwM2UgY29udHJpYnV0b3JzIFx1MDAyNmNvcHk7IFx1MDAzY2EgaHJlZj1cImh0dHA6Ly9jYXJ0b2RiLmNvbS9hdHRyaWJ1dGlvbnNcIlx1MDAzZUNhcnRvREJcdTAwM2MvYVx1MDAzZSwgQ2FydG9EQiBcdTAwM2NhIGhyZWYgPVwiaHR0cDovL2NhcnRvZGIuY29tL2F0dHJpYnV0aW9uc1wiXHUwMDNlYXR0cmlidXRpb25zXHUwMDNjL2FcdTAwM2UiLCAiZGV0ZWN0UmV0aW5hIjogZmFsc2UsICJtYXhOYXRpdmVab29tIjogMTgsICJtYXhab29tIjogMTgsICJtaW5ab29tIjogMCwgIm5vV3JhcCI6IGZhbHNlLCAib3BhY2l0eSI6IDEsICJzdWJkb21haW5zIjogImFiYyIsICJ0bXMiOiBmYWxzZX0KICAgICAgICAgICAgKS5hZGRUbyhtYXBfZmE5ZjY1YzNhM2IxNGI1NWIxNjQ4NTY2ODNmMDM4YjkpOwogICAgICAgIAogICAgCiAgICAgICAgZnVuY3Rpb24gZ2VvX2pzb25fYzFjYTk4ZGUxNDBiNDRmNTg3ODNmNWRlZDhiOWI0NWFfb25FYWNoRmVhdHVyZShmZWF0dXJlLCBsYXllcikgewogICAgICAgICAgICBsYXllci5vbih7CiAgICAgICAgICAgICAgICBjbGljazogZnVuY3Rpb24oZSkgewogICAgICAgICAgICAgICAgICAgIG1hcF9mYTlmNjVjM2EzYjE0YjU1YjE2NDg1NjY4M2YwMzhiOS5maXRCb3VuZHMoZS50YXJnZXQuZ2V0Qm91bmRzKCkpOwogICAgICAgICAgICAgICAgfQogICAgICAgICAgICB9KTsKICAgICAgICB9OwogICAgICAgIHZhciBnZW9fanNvbl9jMWNhOThkZTE0MGI0NGY1ODc4M2Y1ZGVkOGI5YjQ1YSA9IEwuZ2VvSnNvbihudWxsLCB7CiAgICAgICAgICAgICAgICBvbkVhY2hGZWF0dXJlOiBnZW9fanNvbl9jMWNhOThkZTE0MGI0NGY1ODc4M2Y1ZGVkOGI5YjQ1YV9vbkVhY2hGZWF0dXJlLAogICAgICAgICAgICAKICAgICAgICB9KTsKICAgICAgICBmdW5jdGlvbiBnZW9fanNvbl9jMWNhOThkZTE0MGI0NGY1ODc4M2Y1ZGVkOGI5YjQ1YV9hZGQgKGRhdGEpIHsKICAgICAgICAgICAgZ2VvX2pzb25fYzFjYTk4ZGUxNDBiNDRmNTg3ODNmNWRlZDhiOWI0NWEuYWRkRGF0YShkYXRhKQogICAgICAgICAgICAgICAgLmFkZFRvKG1hcF9mYTlmNjVjM2EzYjE0YjU1YjE2NDg1NjY4M2YwMzhiOSk7CiAgICAgICAgfQogICAgICAgICAgICBnZW9fanNvbl9jMWNhOThkZTE0MGI0NGY1ODc4M2Y1ZGVkOGI5YjQ1YV9hZGQoeyJiYm94IjogWy0xMDUuNTA0NDQsIDM5LjkzMTU5NywgLTEwNS4wNzU2OTUwMDAwMDAwMSwgNDAuMjYwODI3XSwgImZlYXR1cmVzIjogW3siYmJveCI6IFstMTA1LjE4NTc4OSwgNDAuMTg1MDMzLCAtMTA1LjE4NTc4OSwgNDAuMTg1MDMzXSwgImdlb21ldHJ5IjogeyJjb29yZGluYXRlcyI6IFstMTA1LjE4NTc4OSwgNDAuMTg1MDMzXSwgInR5cGUiOiAiUG9pbnQifSwgImlkIjogIjAiLCAicHJvcGVydGllcyI6IHsiYW1vdW50IjogIjAuMTQiLCAiY291bnR5IjogIkJPVUxERVIiLCAiZGF0YV9zb3VyY2UiOiAiQ29vcGVyYXRpdmUgUHJvZ3JhbSBvZiBDRFdSLCBOQ1dDRCBcdTAwMjYgU1ZMSFdDRCIsICJkYXRlX3RpbWUiOiAiMjAyMC0wMy0yNFQwODowMDowMC4wMDAiLCAiZGl2IjogIjEiLCAiZHdyX2FiYnJldiI6ICJaV0VUVVJDTyIsICJmbGFnIjogbnVsbCwgImh0dHBfbGlua2FnZS51cmwiOiAiaHR0cHM6Ly9kd3Iuc3RhdGUuY28udXMvU3VyZmFjZVdhdGVyL2RhdGEvZGV0YWlsX2dyYXBoLmFzcHg/SUQ9WldFVFVSQ09cdTAwMjZNVFlQRT1ESVNDSFJHIiwgImxvY2F0aW9uLmxhdGl0dWRlIjogNDAuMTg1MDMzLCAibG9jYXRpb24ubG9uZ2l0dWRlIjogLTEwNS4xODU3ODksICJsb2NhdGlvbi5uZWVkc19yZWNvZGluZyI6IGZhbHNlLCAic3RhZ2UiOiAiMC4wNSIsICJzdGF0aW9uX25hbWUiOiAiWldFQ0sgQU5EIFRVUk5FUiBESVRDSCIsICJzdGF0aW9uX3N0YXR1cyI6ICJBY3RpdmUiLCAic3RhdGlvbl90eXBlIjogIkRpdmVyc2lvbiIsICJ1c2dzX3N0YXRpb25faWQiOiBudWxsLCAidmFyaWFibGUiOiAiRElTQ0hSRyIsICJ3ZCI6ICI1In0sICJ0eXBlIjogIkZlYXR1cmUifSwgeyJiYm94IjogWy0xMDUuMjYzNDksIDQwLjIyMDcwMiwgLTEwNS4yNjM0OSwgNDAuMjIwNzAyXSwgImdlb21ldHJ5IjogeyJjb29yZGluYXRlcyI6IFstMTA1LjI2MzQ5LCA0MC4yMjA3MDJdLCAidHlwZSI6ICJQb2ludCJ9LCAiaWQiOiAiMSIsICJwcm9wZXJ0aWVzIjogeyJhbW91bnQiOiAiMzkuMjAiLCAiY291bnR5IjogIkJPVUxERVIiLCAiZGF0YV9zb3VyY2UiOiAiQ28uIERpdmlzaW9uIG9mIFdhdGVyIFJlc291cmNlcyIsICJkYXRlX3RpbWUiOiAiMjAyMC0wMy0yNFQwODoxNTowMC4wMDAiLCAiZGl2IjogIjEiLCAiZHdyX2FiYnJldiI6ICJTVkNMWU9DTyIsICJmbGFnIjogbnVsbCwgImh0dHBfbGlua2FnZS51cmwiOiAiaHR0cHM6Ly9kd3Iuc3RhdGUuY28udXMvU3VyZmFjZVdhdGVyL2RhdGEvZGV0YWlsX2dyYXBoLmFzcHg/SUQ9U1ZDTFlPQ09cdTAwMjZNVFlQRT1ESVNDSFJHIiwgImxvY2F0aW9uLmxhdGl0dWRlIjogNDAuMjIwNzAyLCAibG9jYXRpb24ubG9uZ2l0dWRlIjogLTEwNS4yNjM0OSwgImxvY2F0aW9uLm5lZWRzX3JlY29kaW5nIjogZmFsc2UsICJzdGFnZSI6ICIyLjk3IiwgInN0YXRpb25fbmFtZSI6ICJTQUlOVCBWUkFJTiBDUkVFSyBBVCBMWU9OUywgQ08iLCAic3RhdGlvbl9zdGF0dXMiOiAiQWN0aXZlIiwgInN0YXRpb25fdHlwZSI6ICJTdHJlYW0iLCAidXNnc19zdGF0aW9uX2lkIjogIjA2NzI0MDAwIiwgInZhcmlhYmxlIjogIkRJU0NIUkciLCAid2QiOiAiNSJ9LCAidHlwZSI6ICJGZWF0dXJlIn0sIHsiYmJveCI6IFstMTA1LjIwNjU5MiwgNDAuMTk2NDIyLCAtMTA1LjIwNjU5MiwgNDAuMTk2NDIyXSwgImdlb21ldHJ5IjogeyJjb29yZGluYXRlcyI6IFstMTA1LjIwNjU5MiwgNDAuMTk2NDIyXSwgInR5cGUiOiAiUG9pbnQifSwgImlkIjogIjIiLCAicHJvcGVydGllcyI6IHsiYW1vdW50IjogIjQuMDEiLCAiY291bnR5IjogIkJPVUxERVIiLCAiZGF0YV9zb3VyY2UiOiAiQ29vcGVyYXRpdmUgUHJvZ3JhbSBvZiBDRFdSLCBOQ1dDRCBcdTAwMjYgU1ZMSFdDRCIsICJkYXRlX3RpbWUiOiAiMjAyMC0wMy0yNFQwNjo0NTowMC4wMDAiLCAiZGl2IjogIjEiLCAiZHdyX2FiYnJldiI6ICJPTElESVRDTyIsICJmbGFnIjogbnVsbCwgImh0dHBfbGlua2FnZS51cmwiOiAiaHR0cHM6Ly9kd3Iuc3RhdGUuY28udXMvU3VyZmFjZVdhdGVyL2RhdGEvZGV0YWlsX2dyYXBoLmFzcHg/SUQ9T0xJRElUQ09cdTAwMjZNVFlQRT1ESVNDSFJHIiwgImxvY2F0aW9uLmxhdGl0dWRlIjogNDAuMTk2NDIyLCAibG9jYXRpb24ubG9uZ2l0dWRlIjogLTEwNS4yMDY1OTIsICJsb2NhdGlvbi5uZWVkc19yZWNvZGluZyI6IGZhbHNlLCAic3RhZ2UiOiAiMC4yNCIsICJzdGF0aW9uX25hbWUiOiAiT0xJR0FSQ0hZIERJVENIIERJVkVSU0lPTiIsICJzdGF0aW9uX3N0YXR1cyI6ICJBY3RpdmUiLCAic3RhdGlvbl90eXBlIjogIkRpdmVyc2lvbiIsICJ1c2dzX3N0YXRpb25faWQiOiBudWxsLCAidmFyaWFibGUiOiAiRElTQ0hSRyIsICJ3ZCI6ICI1In0sICJ0eXBlIjogIkZlYXR1cmUifSwgeyJiYm94IjogWy0xMDUuMzA4NDMyLCAzOS45MzE4MTMsIC0xMDUuMzA4NDMyLCAzOS45MzE4MTNdLCAiZ2VvbWV0cnkiOiB7ImNvb3JkaW5hdGVzIjogWy0xMDUuMzA4NDMyLCAzOS45MzE4MTNdLCAidHlwZSI6ICJQb2ludCJ9LCAiaWQiOiAiMyIsICJwcm9wZXJ0aWVzIjogeyJhbW91bnQiOiAiMC4wMCIsICJjb3VudHkiOiAiQk9VTERFUiIsICJkYXRhX3NvdXJjZSI6ICJDby4gRGl2aXNpb24gb2YgV2F0ZXIgUmVzb3VyY2VzIiwgImRhdGVfdGltZSI6ICIyMDIwLTAzLTI0VDA4OjMwOjAwLjAwMCIsICJkaXYiOiAiMSIsICJkd3JfYWJicmV2IjogIkJPU0RFTENPIiwgImZsYWciOiBudWxsLCAiaHR0cF9saW5rYWdlLnVybCI6ICJodHRwczovL2R3ci5zdGF0ZS5jby51cy9TdXJmYWNlV2F0ZXIvZGF0YS9kZXRhaWxfZ3JhcGguYXNweD9JRD1CT1NERUxDT1x1MDAyNk1UWVBFPURJU0NIUkciLCAibG9jYXRpb24ubGF0aXR1ZGUiOiAzOS45MzE4MTMsICJsb2NhdGlvbi5sb25naXR1ZGUiOiAtMTA1LjMwODQzMiwgImxvY2F0aW9uLm5lZWRzX3JlY29kaW5nIjogZmFsc2UsICJzdGFnZSI6ICItMS43MCIsICJzdGF0aW9uX25hbWUiOiAiU09VVEggQk9VTERFUiBDUkVFSyBESVZFUlNJT04gTkVBUiBFTERPUkFETyBTUFJJTkdTIiwgInN0YXRpb25fc3RhdHVzIjogIkFjdGl2ZSIsICJzdGF0aW9uX3R5cGUiOiAiRGl2ZXJzaW9uIiwgInVzZ3Nfc3RhdGlvbl9pZCI6IG51bGwsICJ2YXJpYWJsZSI6ICJESVNDSFJHIiwgIndkIjogIjYifSwgInR5cGUiOiAiRmVhdHVyZSJ9LCB7ImJib3giOiBbLTEwNS4yMTAzOSwgNDAuMTkzNzU4LCAtMTA1LjIxMDM5LCA0MC4xOTM3NThdLCAiZ2VvbWV0cnkiOiB7ImNvb3JkaW5hdGVzIjogWy0xMDUuMjEwMzksIDQwLjE5Mzc1OF0sICJ0eXBlIjogIlBvaW50In0sICJpZCI6ICI0IiwgInByb3BlcnRpZXMiOiB7ImFtb3VudCI6ICIwLjAwIiwgImNvdW50eSI6ICJCT1VMREVSIiwgImRhdGFfc291cmNlIjogIkNvb3BlcmF0aXZlIFByb2dyYW0gb2YgQ0RXUiwgTkNXQ0QgXHUwMDI2IFNWTEhXQ0QiLCAiZGF0ZV90aW1lIjogIjIwMjAtMDMtMjRUMDg6MDA6MDAuMDAwIiwgImRpdiI6ICIxIiwgImR3cl9hYmJyZXYiOiAiQ0xPRElUQ08iLCAiZmxhZyI6IG51bGwsICJodHRwX2xpbmthZ2UudXJsIjogImh0dHBzOi8vZHdyLnN0YXRlLmNvLnVzL1N1cmZhY2VXYXRlci9kYXRhL2RldGFpbF9ncmFwaC5hc3B4P0lEPUNMT0RJVENPXHUwMDI2TVRZUEU9RElTQ0hSRyIsICJsb2NhdGlvbi5sYXRpdHVkZSI6IDQwLjE5Mzc1OCwgImxvY2F0aW9uLmxvbmdpdHVkZSI6IC0xMDUuMjEwMzksICJsb2NhdGlvbi5uZWVkc19yZWNvZGluZyI6IGZhbHNlLCAic3RhZ2UiOiBudWxsLCAic3RhdGlvbl9uYW1lIjogIkNMT1VHSCBBTkQgVFJVRSBESVRDSCIsICJzdGF0aW9uX3N0YXR1cyI6ICJBY3RpdmUiLCAic3RhdGlvbl90eXBlIjogIkRpdmVyc2lvbiIsICJ1c2dzX3N0YXRpb25faWQiOiBudWxsLCAidmFyaWFibGUiOiAiRElTQ0hSRyIsICJ3ZCI6ICI1In0sICJ0eXBlIjogIkZlYXR1cmUifSwgeyJiYm94IjogWy0xMDUuMzMwODQxLCA0MC4wMDYzODAwMDAwMDAwMSwgLTEwNS4zMzA4NDEsIDQwLjAwNjM4MDAwMDAwMDAxXSwgImdlb21ldHJ5IjogeyJjb29yZGluYXRlcyI6IFstMTA1LjMzMDg0MSwgNDAuMDA2MzgwMDAwMDAwMDFdLCAidHlwZSI6ICJQb2ludCJ9LCAiaWQiOiAiNSIsICJwcm9wZXJ0aWVzIjogeyJhbW91bnQiOiAiMTkuNjAiLCAiY291bnR5IjogIkJPVUxERVIiLCAiZGF0YV9zb3VyY2UiOiAiQ28uIERpdmlzaW9uIG9mIFdhdGVyIFJlc291cmNlcyIsICJkYXRlX3RpbWUiOiAiMjAyMC0wMy0yNFQwODoxNTowMC4wMDAiLCAiZGl2IjogIjEiLCAiZHdyX2FiYnJldiI6ICJCT0NPUk9DTyIsICJmbGFnIjogIkljZSIsICJodHRwX2xpbmthZ2UudXJsIjogImh0dHBzOi8vZHdyLnN0YXRlLmNvLnVzL1N1cmZhY2VXYXRlci9kYXRhL2RldGFpbF9ncmFwaC5hc3B4P0lEPUJPQ09ST0NPXHUwMDI2TVRZUEU9RElTQ0hSRyIsICJsb2NhdGlvbi5sYXRpdHVkZSI6IDQwLjAwNjM4LCAibG9jYXRpb24ubG9uZ2l0dWRlIjogLTEwNS4zMzA4NDEsICJsb2NhdGlvbi5uZWVkc19yZWNvZGluZyI6IGZhbHNlLCAic3RhZ2UiOiAiMS44MyIsICJzdGF0aW9uX25hbWUiOiAiQk9VTERFUiBDUkVFSyBORUFSIE9ST0RFTEwsIENPLiIsICJzdGF0aW9uX3N0YXR1cyI6ICJBY3RpdmUiLCAic3RhdGlvbl90eXBlIjogIlN0cmVhbSIsICJ1c2dzX3N0YXRpb25faWQiOiAiMDY3MjcwMDAiLCAidmFyaWFibGUiOiAiRElTQ0hSRyIsICJ3ZCI6ICI2In0sICJ0eXBlIjogIkZlYXR1cmUifSwgeyJiYm94IjogWy0xMDUuMjE4Nzc3LCA0MC4yMDQxOTMsIC0xMDUuMjE4Nzc3LCA0MC4yMDQxOTNdLCAiZ2VvbWV0cnkiOiB7ImNvb3JkaW5hdGVzIjogWy0xMDUuMjE4Nzc3LCA0MC4yMDQxOTNdLCAidHlwZSI6ICJQb2ludCJ9LCAiaWQiOiAiNiIsICJwcm9wZXJ0aWVzIjogeyJhbW91bnQiOiAiMC4wMCIsICJjb3VudHkiOiAiQk9VTERFUiIsICJkYXRhX3NvdXJjZSI6ICJDb29wZXJhdGl2ZSBQcm9ncmFtIG9mIENEV1IsIE5DV0NEIFx1MDAyNiBTVkxIV0NEIiwgImRhdGVfdGltZSI6ICIyMDIwLTAzLTI0VDA4OjAwOjAwLjAwMCIsICJkaXYiOiAiMSIsICJkd3JfYWJicmV2IjogIkxPTlNVUENPIiwgImZsYWciOiBudWxsLCAiaHR0cF9saW5rYWdlLnVybCI6ICJodHRwczovL2R3ci5zdGF0ZS5jby51cy9TdXJmYWNlV2F0ZXIvZGF0YS9kZXRhaWxfZ3JhcGguYXNweD9JRD1MT05TVVBDT1x1MDAyNk1UWVBFPURJU0NIUkciLCAibG9jYXRpb24ubGF0aXR1ZGUiOiA0MC4yMDQxOTMsICJsb2NhdGlvbi5sb25naXR1ZGUiOiAtMTA1LjIxODc3NywgImxvY2F0aW9uLm5lZWRzX3JlY29kaW5nIjogZmFsc2UsICJzdGFnZSI6IG51bGwsICJzdGF0aW9uX25hbWUiOiAiTE9OR01PTlQgU1VQUExZIERJVENIIiwgInN0YXRpb25fc3RhdHVzIjogIkFjdGl2ZSIsICJzdGF0aW9uX3R5cGUiOiAiRGl2ZXJzaW9uIiwgInVzZ3Nfc3RhdGlvbl9pZCI6IG51bGwsICJ2YXJpYWJsZSI6ICJESVNDSFJHIiwgIndkIjogIjUifSwgInR5cGUiOiAiRmVhdHVyZSJ9LCB7ImJib3giOiBbLTEwNS4xNjc2MjIsIDQwLjE3MjkyNSwgLTEwNS4xNjc2MjIsIDQwLjE3MjkyNV0sICJnZW9tZXRyeSI6IHsiY29vcmRpbmF0ZXMiOiBbLTEwNS4xNjc2MjIsIDQwLjE3MjkyNV0sICJ0eXBlIjogIlBvaW50In0sICJpZCI6ICI3IiwgInByb3BlcnRpZXMiOiB7ImFtb3VudCI6ICIwLjAwIiwgImNvdW50eSI6ICJCT1VMREVSIiwgImRhdGFfc291cmNlIjogIkNvb3BlcmF0aXZlIFNEUiBQcm9ncmFtIG9mIENEV1IgXHUwMDI2IE5DV0NEIiwgImRhdGVfdGltZSI6ICIyMDIwLTAzLTI0VDA4OjAwOjAwLjAwMCIsICJkaXYiOiAiMSIsICJkd3JfYWJicmV2IjogIk5PUk1VVENPIiwgImZsYWciOiBudWxsLCAiaHR0cF9saW5rYWdlLnVybCI6ICJodHRwczovL2R3ci5zdGF0ZS5jby51cy9TdXJmYWNlV2F0ZXIvZGF0YS9kZXRhaWxfZ3JhcGguYXNweD9JRD1OT1JNVVRDT1x1MDAyNk1UWVBFPURJU0NIUkciLCAibG9jYXRpb24ubGF0aXR1ZGUiOiA0MC4xNzI5MjUsICJsb2NhdGlvbi5sb25naXR1ZGUiOiAtMTA1LjE2NzYyMiwgImxvY2F0aW9uLm5lZWRzX3JlY29kaW5nIjogZmFsc2UsICJzdGFnZSI6IG51bGwsICJzdGF0aW9uX25hbWUiOiAiTk9SVEhXRVNUIE1VVFVBTCBESVRDSCIsICJzdGF0aW9uX3N0YXR1cyI6ICJBY3RpdmUiLCAic3RhdGlvbl90eXBlIjogIkRpdmVyc2lvbiIsICJ1c2dzX3N0YXRpb25faWQiOiBudWxsLCAidmFyaWFibGUiOiAiRElTQ0hSRyIsICJ3ZCI6ICI1In0sICJ0eXBlIjogIkZlYXR1cmUifSwgeyJiYm94IjogWy0xMDUuMTMwODE5LCA0MC4xMzQyNzgsIC0xMDUuMTMwODE5LCA0MC4xMzQyNzhdLCAiZ2VvbWV0cnkiOiB7ImNvb3JkaW5hdGVzIjogWy0xMDUuMTMwODE5LCA0MC4xMzQyNzhdLCAidHlwZSI6ICJQb2ludCJ9LCAiaWQiOiAiOCIsICJwcm9wZXJ0aWVzIjogeyJhbW91bnQiOiAiMy42MSIsICJjb3VudHkiOiAiQk9VTERFUiIsICJkYXRhX3NvdXJjZSI6ICJVLlMuIEdlb2xvZ2ljYWwgU3VydmV5IiwgImRhdGVfdGltZSI6ICIyMDIwLTAzLTI0VDA4OjEwOjAwLjAwMCIsICJkaXYiOiAiMSIsICJkd3JfYWJicmV2IjogIkxFRlRIT0NPIiwgImZsYWciOiBudWxsLCAiaHR0cF9saW5rYWdlLnVybCI6ICJodHRwczovL3dhdGVyZGF0YS51c2dzLmdvdi9ud2lzL3V2PzA2NzI0OTcwIiwgImxvY2F0aW9uLmxhdGl0dWRlIjogNDAuMTM0Mjc4LCAibG9jYXRpb24ubG9uZ2l0dWRlIjogLTEwNS4xMzA4MTksICJsb2NhdGlvbi5uZWVkc19yZWNvZGluZyI6IGZhbHNlLCAic3RhZ2UiOiBudWxsLCAic3RhdGlvbl9uYW1lIjogIkxFRlQgSEFORCBDUkVFSyBBVCBIT1ZFUiBST0FEIE5FQVIgTE9OR01PTlQsIENPIiwgInN0YXRpb25fc3RhdHVzIjogIkFjdGl2ZSIsICJzdGF0aW9uX3R5cGUiOiAiU3RyZWFtIiwgInVzZ3Nfc3RhdGlvbl9pZCI6ICIwNjcyNDk3MCIsICJ2YXJpYWJsZSI6ICJESVNDSFJHIiwgIndkIjogIjUifSwgInR5cGUiOiAiRmVhdHVyZSJ9LCB7ImJib3giOiBbLTEwNS4yMTg2NzcsIDM5Ljk4NjE2OSwgLTEwNS4yMTg2NzcsIDM5Ljk4NjE2OV0sICJnZW9tZXRyeSI6IHsiY29vcmRpbmF0ZXMiOiBbLTEwNS4yMTg2NzcsIDM5Ljk4NjE2OV0sICJ0eXBlIjogIlBvaW50In0sICJpZCI6ICI5IiwgInByb3BlcnRpZXMiOiB7ImFtb3VudCI6ICIwLjAwIiwgImNvdW50eSI6ICJCT1VMREVSIiwgImRhdGFfc291cmNlIjogIkNvb3BlcmF0aXZlIFByb2dyYW0gb2YgQ0RXUiwgTkNXQ0QgXHUwMDI2IExTUFdDRCIsICJkYXRlX3RpbWUiOiAiMjAyMC0wMy0yNFQwNzowMDowMC4wMDAiLCAiZGl2IjogIjEiLCAiZHdyX2FiYnJldiI6ICJEUllDQVJDTyIsICJmbGFnIjogbnVsbCwgImh0dHBfbGlua2FnZS51cmwiOiAiaHR0cHM6Ly9kd3Iuc3RhdGUuY28udXMvU3VyZmFjZVdhdGVyL2RhdGEvZGV0YWlsX2dyYXBoLmFzcHg/SUQ9RFJZQ0FSQ09cdTAwMjZNVFlQRT1ESVNDSFJHIiwgImxvY2F0aW9uLmxhdGl0dWRlIjogMzkuOTg2MTY5LCAibG9jYXRpb24ubG9uZ2l0dWRlIjogLTEwNS4yMTg2NzcsICJsb2NhdGlvbi5uZWVkc19yZWNvZGluZyI6IGZhbHNlLCAic3RhZ2UiOiBudWxsLCAic3RhdGlvbl9uYW1lIjogIkRSWSBDUkVFSyBDQVJSSUVSIiwgInN0YXRpb25fc3RhdHVzIjogIkFjdGl2ZSIsICJzdGF0aW9uX3R5cGUiOiAiRGl2ZXJzaW9uIiwgInVzZ3Nfc3RhdGlvbl9pZCI6IG51bGwsICJ2YXJpYWJsZSI6ICJESVNDSFJHIiwgIndkIjogIjYifSwgInR5cGUiOiAiRmVhdHVyZSJ9LCB7ImJib3giOiBbLTEwNS4xNjg0NzEsIDQwLjE2MDcwNSwgLTEwNS4xNjg0NzEsIDQwLjE2MDcwNV0sICJnZW9tZXRyeSI6IHsiY29vcmRpbmF0ZXMiOiBbLTEwNS4xNjg0NzEsIDQwLjE2MDcwNV0sICJ0eXBlIjogIlBvaW50In0sICJpZCI6ICIxMCIsICJwcm9wZXJ0aWVzIjogeyJhbW91bnQiOiAiMC4wMCIsICJjb3VudHkiOiAiQk9VTERFUiIsICJkYXRhX3NvdXJjZSI6ICJDby4gRGl2aXNpb24gb2YgV2F0ZXIgUmVzb3VyY2VzIiwgImRhdGVfdGltZSI6ICIyMDIwLTAzLTI0VDA3OjQ1OjAwLjAwMCIsICJkaXYiOiAiMSIsICJkd3JfYWJicmV2IjogIlBFQ1JUTkNPIiwgImZsYWciOiBudWxsLCAiaHR0cF9saW5rYWdlLnVybCI6ICJodHRwczovL2R3ci5zdGF0ZS5jby51cy9TdXJmYWNlV2F0ZXIvZGF0YS9kZXRhaWxfZ3JhcGguYXNweD9JRD1QRUNSVE5DT1x1MDAyNk1UWVBFPURJU0NIUkciLCAibG9jYXRpb24ubGF0aXR1ZGUiOiA0MC4xNjA3MDUsICJsb2NhdGlvbi5sb25naXR1ZGUiOiAtMTA1LjE2ODQ3MSwgImxvY2F0aW9uLm5lZWRzX3JlY29kaW5nIjogZmFsc2UsICJzdGFnZSI6IG51bGwsICJzdGF0aW9uX25hbWUiOiAiUEVDSy1QRUxMQSBBVUdNRU5UQVRJT04gUkVUVVJOIiwgInN0YXRpb25fc3RhdHVzIjogIkFjdGl2ZSIsICJzdGF0aW9uX3R5cGUiOiAiRGl2ZXJzaW9uIiwgInVzZ3Nfc3RhdGlvbl9pZCI6IG51bGwsICJ2YXJpYWJsZSI6ICJESVNDSFJHIiwgIndkIjogIjUifSwgInR5cGUiOiAiRmVhdHVyZSJ9LCB7ImJib3giOiBbLTEwNS4yMjI2MzksIDQwLjE5OTMyMSwgLTEwNS4yMjI2MzksIDQwLjE5OTMyMV0sICJnZW9tZXRyeSI6IHsiY29vcmRpbmF0ZXMiOiBbLTEwNS4yMjI2MzksIDQwLjE5OTMyMV0sICJ0eXBlIjogIlBvaW50In0sICJpZCI6ICIxMSIsICJwcm9wZXJ0aWVzIjogeyJhbW91bnQiOiAiMC4wMCIsICJjb3VudHkiOiAiQk9VTERFUiIsICJkYXRhX3NvdXJjZSI6ICJDb29wZXJhdGl2ZSBQcm9ncmFtIG9mIENEV1IsIE5DV0NEIFx1MDAyNiBTVkxIV0NEIiwgImRhdGVfdGltZSI6ICIyMDIwLTAzLTI0VDA3OjQ1OjAwLjAwMCIsICJkaXYiOiAiMSIsICJkd3JfYWJicmV2IjogIkdPRElUMUNPIiwgImZsYWciOiBudWxsLCAiaHR0cF9saW5rYWdlLnVybCI6ICJodHRwczovL2R3ci5zdGF0ZS5jby51cy9TdXJmYWNlV2F0ZXIvZGF0YS9kZXRhaWxfZ3JhcGguYXNweD9JRD1HT0RJVDFDT1x1MDAyNk1UWVBFPURJU0NIUkciLCAibG9jYXRpb24ubGF0aXR1ZGUiOiA0MC4xOTkzMjEsICJsb2NhdGlvbi5sb25naXR1ZGUiOiAtMTA1LjIyMjYzOSwgImxvY2F0aW9uLm5lZWRzX3JlY29kaW5nIjogZmFsc2UsICJzdGFnZSI6IG51bGwsICJzdGF0aW9uX25hbWUiOiAiR09TUyBESVRDSCAxIiwgInN0YXRpb25fc3RhdHVzIjogIkFjdGl2ZSIsICJzdGF0aW9uX3R5cGUiOiAiRGl2ZXJzaW9uIiwgInVzZ3Nfc3RhdGlvbl9pZCI6IG51bGwsICJ2YXJpYWJsZSI6ICJESVNDSFJHIiwgIndkIjogIjUifSwgInR5cGUiOiAiRmVhdHVyZSJ9LCB7ImJib3giOiBbLTEwNS4yMTA0MjQsIDQwLjE5MzI4MDAwMDAwMDAxLCAtMTA1LjIxMDQyNCwgNDAuMTkzMjgwMDAwMDAwMDFdLCAiZ2VvbWV0cnkiOiB7ImNvb3JkaW5hdGVzIjogWy0xMDUuMjEwNDI0LCA0MC4xOTMyODAwMDAwMDAwMV0sICJ0eXBlIjogIlBvaW50In0sICJpZCI6ICIxMiIsICJwcm9wZXJ0aWVzIjogeyJhbW91bnQiOiAiMC4wMCIsICJjb3VudHkiOiAiQk9VTERFUiIsICJkYXRhX3NvdXJjZSI6ICJDb29wZXJhdGl2ZSBQcm9ncmFtIG9mIENEV1IsIE5DV0NEIFx1MDAyNiBTVkxIV0NEIiwgImRhdGVfdGltZSI6ICIyMDIwLTAzLTI0VDA4OjAwOjAwLjAwMCIsICJkaXYiOiAiMSIsICJkd3JfYWJicmV2IjogIldFQkRJVENPIiwgImZsYWciOiBudWxsLCAiaHR0cF9saW5rYWdlLnVybCI6ICJodHRwczovL2R3ci5zdGF0ZS5jby51cy9TdXJmYWNlV2F0ZXIvZGF0YS9kZXRhaWxfZ3JhcGguYXNweD9JRD1XRUJESVRDT1x1MDAyNk1UWVBFPURJU0NIUkciLCAibG9jYXRpb24ubGF0aXR1ZGUiOiA0MC4xOTMyOCwgImxvY2F0aW9uLmxvbmdpdHVkZSI6IC0xMDUuMjEwNDI0LCAibG9jYXRpb24ubmVlZHNfcmVjb2RpbmciOiBmYWxzZSwgInN0YWdlIjogbnVsbCwgInN0YXRpb25fbmFtZSI6ICJXRUJTVEVSIE1DQ0FTTElOIERJVENIIiwgInN0YXRpb25fc3RhdHVzIjogIkFjdGl2ZSIsICJzdGF0aW9uX3R5cGUiOiAiRGl2ZXJzaW9uIiwgInVzZ3Nfc3RhdGlvbl9pZCI6IG51bGwsICJ2YXJpYWJsZSI6ICJESVNDSFJHIiwgIndkIjogIjUifSwgInR5cGUiOiAiRmVhdHVyZSJ9LCB7ImJib3giOiBbLTEwNS4xNTExNDMsIDQwLjA1MzY2MSwgLTEwNS4xNTExNDMsIDQwLjA1MzY2MV0sICJnZW9tZXRyeSI6IHsiY29vcmRpbmF0ZXMiOiBbLTEwNS4xNTExNDMsIDQwLjA1MzY2MV0sICJ0eXBlIjogIlBvaW50In0sICJpZCI6ICIxMyIsICJwcm9wZXJ0aWVzIjogeyJhbW91bnQiOiAiMy4wNSIsICJjb3VudHkiOiAiQk9VTERFUiIsICJkYXRhX3NvdXJjZSI6ICJDb29wZXJhdGl2ZSBQcm9ncmFtIG9mIENEV1IsIE5DV0NEIFx1MDAyNiBMU1BXQ0QiLCAiZGF0ZV90aW1lIjogIjIwMjAtMDMtMjRUMDg6MDA6MDAuMDAwIiwgImRpdiI6ICIxIiwgImR3cl9hYmJyZXYiOiAiTEVHRElUQ08iLCAiZmxhZyI6IG51bGwsICJodHRwX2xpbmthZ2UudXJsIjogImh0dHBzOi8vZHdyLnN0YXRlLmNvLnVzL1N1cmZhY2VXYXRlci9kYXRhL2RldGFpbF9ncmFwaC5hc3B4P0lEPUxFR0RJVENPXHUwMDI2TVRZUEU9RElTQ0hSRyIsICJsb2NhdGlvbi5sYXRpdHVkZSI6IDQwLjA1MzY2MSwgImxvY2F0aW9uLmxvbmdpdHVkZSI6IC0xMDUuMTUxMTQzLCAibG9jYXRpb24ubmVlZHNfcmVjb2RpbmciOiBmYWxzZSwgInN0YWdlIjogIjAuMjMiLCAic3RhdGlvbl9uYW1lIjogIkxFR0dFVFQgRElUQ0giLCAic3RhdGlvbl9zdGF0dXMiOiAiQWN0aXZlIiwgInN0YXRpb25fdHlwZSI6ICJEaXZlcnNpb24iLCAidXNnc19zdGF0aW9uX2lkIjogbnVsbCwgInZhcmlhYmxlIjogIkRJU0NIUkciLCAid2QiOiAiNiJ9LCAidHlwZSI6ICJGZWF0dXJlIn0sIHsiYmJveCI6IFstMTA1LjM2NTM2NSwgNDAuMjE2MjYzLCAtMTA1LjM2NTM2NSwgNDAuMjE2MjYzXSwgImdlb21ldHJ5IjogeyJjb29yZGluYXRlcyI6IFstMTA1LjM2NTM2NSwgNDAuMjE2MjYzXSwgInR5cGUiOiAiUG9pbnQifSwgImlkIjogIjE0IiwgInByb3BlcnRpZXMiOiB7ImFtb3VudCI6ICIxMjg5MC4wMCIsICJjb3VudHkiOiAiQk9VTERFUiIsICJkYXRhX3NvdXJjZSI6ICJDby4gRGl2aXNpb24gb2YgV2F0ZXIgUmVzb3VyY2VzIiwgImRhdGVfdGltZSI6ICIyMDIwLTAzLTI0VDA4OjQ1OjAwLjAwMCIsICJkaXYiOiAiMSIsICJkd3JfYWJicmV2IjogIkJSS0RBTUNPIiwgImZsYWciOiBudWxsLCAiaHR0cF9saW5rYWdlLnVybCI6ICJodHRwczovL2R3ci5zdGF0ZS5jby51cy9TdXJmYWNlV2F0ZXIvZGF0YS9kZXRhaWxfZ3JhcGguYXNweD9JRD1CUktEQU1DT1x1MDAyNk1UWVBFPVNUT1JBR0UiLCAibG9jYXRpb24ubGF0aXR1ZGUiOiA0MC4yMTYyNjMsICJsb2NhdGlvbi5sb25naXR1ZGUiOiAtMTA1LjM2NTM2NSwgImxvY2F0aW9uLm5lZWRzX3JlY29kaW5nIjogZmFsc2UsICJzdGFnZSI6ICI2Mzg0LjA2IiwgInN0YXRpb25fbmFtZSI6ICJCVVRUT05ST0NLIChSQUxQSCBQUklDRSkgUkVTRVJWT0lSIiwgInN0YXRpb25fc3RhdHVzIjogIkFjdGl2ZSIsICJzdGF0aW9uX3R5cGUiOiAiUmVzZXJ2b2lyIiwgInVzZ3Nfc3RhdGlvbl9pZCI6IG51bGwsICJ2YXJpYWJsZSI6ICJTVE9SQUdFIiwgIndkIjogIjUifSwgInR5cGUiOiAiRmVhdHVyZSJ9LCB7ImJib3giOiBbLTEwNS4yMDk1LCA0MC4yNTU3NzYsIC0xMDUuMjA5NSwgNDAuMjU1Nzc2XSwgImdlb21ldHJ5IjogeyJjb29yZGluYXRlcyI6IFstMTA1LjIwOTUsIDQwLjI1NTc3Nl0sICJ0eXBlIjogIlBvaW50In0sICJpZCI6ICIxNSIsICJwcm9wZXJ0aWVzIjogeyJhbW91bnQiOiAiMC4xMCIsICJjb3VudHkiOiAiQk9VTERFUiIsICJkYXRhX3NvdXJjZSI6ICJOb3J0aGVybiBDb2xvcmFkbyBXYXRlciBDb25zZXJ2YW5jeSBEaXN0cmljdCIsICJkYXRlX3RpbWUiOiAiMjAyMC0wMy0yNFQwODowMDowMC4wMDAiLCAiZGl2IjogIjEiLCAiZHdyX2FiYnJldiI6ICJMSVRUSDJDTyIsICJmbGFnIjogbnVsbCwgImh0dHBfbGlua2FnZS51cmwiOiAiaHR0cDovL3d3dy5ub3J0aGVybndhdGVyLm9yZy9XYXRlclByb2plY3RzL1dhdGVyRGF0YS5hc3B4RWFzdFNsb3BlV2F0ZXJEYXRhLmFzcHgiLCAibG9jYXRpb24ubGF0aXR1ZGUiOiA0MC4yNTU3NzYsICJsb2NhdGlvbi5sb25naXR1ZGUiOiAtMTA1LjIwOTUsICJsb2NhdGlvbi5uZWVkc19yZWNvZGluZyI6IGZhbHNlLCAic3RhZ2UiOiAiMC4xMCIsICJzdGF0aW9uX25hbWUiOiAiTElUVExFIFRIT01QU09OICMyIERJVENIIiwgInN0YXRpb25fc3RhdHVzIjogIkFjdGl2ZSIsICJzdGF0aW9uX3R5cGUiOiAiRGl2ZXJzaW9uIiwgInVzZ3Nfc3RhdGlvbl9pZCI6ICJFUzE5MDAiLCAidmFyaWFibGUiOiAiRElTQ0hSRyIsICJ3ZCI6ICI0In0sICJ0eXBlIjogIkZlYXR1cmUifSwgeyJiYm94IjogWy0xMDUuMTY0Mzk3LCA0MC4yNTc4NDQsIC0xMDUuMTY0Mzk3LCA0MC4yNTc4NDRdLCAiZ2VvbWV0cnkiOiB7ImNvb3JkaW5hdGVzIjogWy0xMDUuMTY0Mzk3LCA0MC4yNTc4NDRdLCAidHlwZSI6ICJQb2ludCJ9LCAiaWQiOiAiMTYiLCAicHJvcGVydGllcyI6IHsiYW1vdW50IjogIjAuMDEiLCAiY291bnR5IjogIkJPVUxERVIiLCAiZGF0YV9zb3VyY2UiOiAiQ29vcGVyYXRpdmUgU0RSIFByb2dyYW0gb2YgQ0RXUiBcdTAwMjYgTkNXQ0QiLCAiZGF0ZV90aW1lIjogIjIwMjAtMDMtMjRUMDg6MDA6MDAuMDAwIiwgImRpdiI6ICIxIiwgImR3cl9hYmJyZXYiOiAiQkxXRElUQ08iLCAiZmxhZyI6IG51bGwsICJodHRwX2xpbmthZ2UudXJsIjogImh0dHBzOi8vZHdyLnN0YXRlLmNvLnVzL1N1cmZhY2VXYXRlci9kYXRhL2RldGFpbF9ncmFwaC5hc3B4P0lEPUJMV0RJVENPXHUwMDI2TVRZUEU9RElTQ0hSRyIsICJsb2NhdGlvbi5sYXRpdHVkZSI6IDQwLjI1Nzg0NCwgImxvY2F0aW9uLmxvbmdpdHVkZSI6IC0xMDUuMTY0Mzk3LCAibG9jYXRpb24ubmVlZHNfcmVjb2RpbmciOiBmYWxzZSwgInN0YWdlIjogIjAuMDMiLCAic3RhdGlvbl9uYW1lIjogIkJMT1dFUiBESVRDSCIsICJzdGF0aW9uX3N0YXR1cyI6ICJBY3RpdmUiLCAic3RhdGlvbl90eXBlIjogIkRpdmVyc2lvbiIsICJ1c2dzX3N0YXRpb25faWQiOiBudWxsLCAidmFyaWFibGUiOiAiRElTQ0hSRyIsICJ3ZCI6ICI0In0sICJ0eXBlIjogIkZlYXR1cmUifSwgeyJiYm94IjogWy0xMDUuMzA0OTksIDM5LjkzMTU5NywgLTEwNS4zMDQ5OSwgMzkuOTMxNTk3XSwgImdlb21ldHJ5IjogeyJjb29yZGluYXRlcyI6IFstMTA1LjMwNDk5LCAzOS45MzE1OTddLCAidHlwZSI6ICJQb2ludCJ9LCAiaWQiOiAiMTciLCAicHJvcGVydGllcyI6IHsiYW1vdW50IjogIjE2LjAwIiwgImNvdW50eSI6ICJCT1VMREVSIiwgImRhdGFfc291cmNlIjogIkNvLiBEaXZpc2lvbiBvZiBXYXRlciBSZXNvdXJjZXMiLCAiZGF0ZV90aW1lIjogIjIwMjAtMDMtMjRUMDg6MTU6MDAuMDAwIiwgImRpdiI6ICIxIiwgImR3cl9hYmJyZXYiOiAiQk9DRUxTQ08iLCAiZmxhZyI6ICJJY2UiLCAiaHR0cF9saW5rYWdlLnVybCI6ICJodHRwczovL2R3ci5zdGF0ZS5jby51cy9TdXJmYWNlV2F0ZXIvZGF0YS9kZXRhaWxfZ3JhcGguYXNweD9JRD1CT0NFTFNDT1x1MDAyNk1UWVBFPURJU0NIUkciLCAibG9jYXRpb24ubGF0aXR1ZGUiOiAzOS45MzE1OTcsICJsb2NhdGlvbi5sb25naXR1ZGUiOiAtMTA1LjMwNDk5LCAibG9jYXRpb24ubmVlZHNfcmVjb2RpbmciOiBmYWxzZSwgInN0YWdlIjogIjIuMjEiLCAic3RhdGlvbl9uYW1lIjogIlNPVVRIIEJPVUxERVIgQ1JFRUsgTkVBUiBFTERPUkFETyBTUFJJTkdTLCBDTy4iLCAic3RhdGlvbl9zdGF0dXMiOiAiQWN0aXZlIiwgInN0YXRpb25fdHlwZSI6ICJTdHJlYW0iLCAidXNnc19zdGF0aW9uX2lkIjogbnVsbCwgInZhcmlhYmxlIjogIkRJU0NIUkciLCAid2QiOiAiNiJ9LCAidHlwZSI6ICJGZWF0dXJlIn0sIHsiYmJveCI6IFstMTA1LjE3ODg3NSwgNDAuMDUxNjUyLCAtMTA1LjE3ODg3NSwgNDAuMDUxNjUyXSwgImdlb21ldHJ5IjogeyJjb29yZGluYXRlcyI6IFstMTA1LjE3ODg3NSwgNDAuMDUxNjUyXSwgInR5cGUiOiAiUG9pbnQifSwgImlkIjogIjE4IiwgInByb3BlcnRpZXMiOiB7ImFtb3VudCI6ICIzMi4xMCIsICJjb3VudHkiOiAiQk9VTERFUiIsICJkYXRhX3NvdXJjZSI6ICJVLlMuIEdlb2xvZ2ljYWwgU3VydmV5IiwgImRhdGVfdGltZSI6ICIyMDIwLTAzLTI0VDA4OjE1OjAwLjAwMCIsICJkaXYiOiAiMSIsICJkd3JfYWJicmV2IjogIkJPQ05PUkNPIiwgImZsYWciOiBudWxsLCAiaHR0cF9saW5rYWdlLnVybCI6ICJodHRwczovL3dhdGVyZGF0YS51c2dzLmdvdi9ud2lzL3V2PzA2NzMwMjAwIiwgImxvY2F0aW9uLmxhdGl0dWRlIjogNDAuMDUxNjUyLCAibG9jYXRpb24ubG9uZ2l0dWRlIjogLTEwNS4xNzg4NzUsICJsb2NhdGlvbi5uZWVkc19yZWNvZGluZyI6IGZhbHNlLCAic3RhZ2UiOiBudWxsLCAic3RhdGlvbl9uYW1lIjogIkJPVUxERVIgQ1JFRUsgQVQgTk9SVEggNzVUSCBTVC4gTkVBUiBCT1VMREVSLCBDTyIsICJzdGF0aW9uX3N0YXR1cyI6ICJBY3RpdmUiLCAic3RhdGlvbl90eXBlIjogIlN0cmVhbSIsICJ1c2dzX3N0YXRpb25faWQiOiAiMDY3MzAyMDAiLCAidmFyaWFibGUiOiAiRElTQ0hSRyIsICJ3ZCI6ICI2In0sICJ0eXBlIjogIkZlYXR1cmUifSwgeyJiYm94IjogWy0xMDUuMTYwODc2LCA0MC4xNzA5OTgsIC0xMDUuMTYwODc2LCA0MC4xNzA5OThdLCAiZ2VvbWV0cnkiOiB7ImNvb3JkaW5hdGVzIjogWy0xMDUuMTYwODc2LCA0MC4xNzA5OThdLCAidHlwZSI6ICJQb2ludCJ9LCAiaWQiOiAiMTkiLCAicHJvcGVydGllcyI6IHsiYW1vdW50IjogIjAuMzgiLCAiY291bnR5IjogIkJPVUxERVIiLCAiZGF0YV9zb3VyY2UiOiAiQ29vcGVyYXRpdmUgUHJvZ3JhbSBvZiBDRFdSLCBOQ1dDRCBcdTAwMjYgU1ZMSFdDRCIsICJkYXRlX3RpbWUiOiAiMjAyMC0wMy0yNFQwODowMDowMC4wMDAiLCAiZGl2IjogIjEiLCAiZHdyX2FiYnJldiI6ICJTRkxESVRDTyIsICJmbGFnIjogbnVsbCwgImh0dHBfbGlua2FnZS51cmwiOiAiaHR0cHM6Ly9kd3Iuc3RhdGUuY28udXMvU3VyZmFjZVdhdGVyL2RhdGEvZGV0YWlsX2dyYXBoLmFzcHg/SUQ9U0ZMRElUQ09cdTAwMjZNVFlQRT1ESVNDSFJHIiwgImxvY2F0aW9uLmxhdGl0dWRlIjogNDAuMTcwOTk4LCAibG9jYXRpb24ubG9uZ2l0dWRlIjogLTEwNS4xNjA4NzYsICJsb2NhdGlvbi5uZWVkc19yZWNvZGluZyI6IGZhbHNlLCAic3RhZ2UiOiAiMC4xMSIsICJzdGF0aW9uX25hbWUiOiAiU09VVEggRkxBVCBESVRDSCIsICJzdGF0aW9uX3N0YXR1cyI6ICJBY3RpdmUiLCAic3RhdGlvbl90eXBlIjogIkRpdmVyc2lvbiIsICJ1c2dzX3N0YXRpb25faWQiOiBudWxsLCAidmFyaWFibGUiOiAiRElTQ0hSRyIsICJ3ZCI6ICI1In0sICJ0eXBlIjogIkZlYXR1cmUifSwgeyJiYm94IjogWy0xMDUuMDc1Njk1MDAwMDAwMDEsIDQwLjE1MzM0MSwgLTEwNS4wNzU2OTUwMDAwMDAwMSwgNDAuMTUzMzQxXSwgImdlb21ldHJ5IjogeyJjb29yZGluYXRlcyI6IFstMTA1LjA3NTY5NTAwMDAwMDAxLCA0MC4xNTMzNDFdLCAidHlwZSI6ICJQb2ludCJ9LCAiaWQiOiAiMjAiLCAicHJvcGVydGllcyI6IHsiYW1vdW50IjogIjM2LjMwIiwgImNvdW50eSI6ICJCT1VMREVSIiwgImRhdGFfc291cmNlIjogIkNvLiBEaXZpc2lvbiBvZiBXYXRlciBSZXNvdXJjZXMiLCAiZGF0ZV90aW1lIjogIjIwMjAtMDMtMjRUMDg6MzA6MDAuMDAwIiwgImRpdiI6ICIxIiwgImR3cl9hYmJyZXYiOiAiU1ZDTE9QQ08iLCAiZmxhZyI6IG51bGwsICJodHRwX2xpbmthZ2UudXJsIjogImh0dHBzOi8vZHdyLnN0YXRlLmNvLnVzL1N1cmZhY2VXYXRlci9kYXRhL2RldGFpbF9ncmFwaC5hc3B4P0lEPVNWQ0xPUENPXHUwMDI2TVRZUEU9RElTQ0hSRyIsICJsb2NhdGlvbi5sYXRpdHVkZSI6IDQwLjE1MzM0MSwgImxvY2F0aW9uLmxvbmdpdHVkZSI6IC0xMDUuMDc1Njk1LCAibG9jYXRpb24ubmVlZHNfcmVjb2RpbmciOiBmYWxzZSwgInN0YWdlIjogIjMuNTciLCAic3RhdGlvbl9uYW1lIjogIlNBSU5UIFZSQUlOIENSRUVLIEJFTE9XIEtFTiBQUkFUVCBCTFZEIEFUIExPTkdNT05ULCBDTyIsICJzdGF0aW9uX3N0YXR1cyI6ICJBY3RpdmUiLCAic3RhdGlvbl90eXBlIjogIlN0cmVhbSIsICJ1c2dzX3N0YXRpb25faWQiOiBudWxsLCAidmFyaWFibGUiOiAiRElTQ0hSRyIsICJ3ZCI6ICI1In0sICJ0eXBlIjogIkZlYXR1cmUifSwgeyJiYm94IjogWy0xMDUuNTA0NDQsIDM5Ljk2MTY1NSwgLTEwNS41MDQ0NCwgMzkuOTYxNjU1XSwgImdlb21ldHJ5IjogeyJjb29yZGluYXRlcyI6IFstMTA1LjUwNDQ0LCAzOS45NjE2NTVdLCAidHlwZSI6ICJQb2ludCJ9LCAiaWQiOiAiMjEiLCAicHJvcGVydGllcyI6IHsiYW1vdW50IjogIjI0LjYwIiwgImNvdW50eSI6ICJCT1VMREVSIiwgImRhdGFfc291cmNlIjogIkNvLiBEaXZpc2lvbiBvZiBXYXRlciBSZXNvdXJjZXMiLCAiZGF0ZV90aW1lIjogIjIwMjAtMDMtMjRUMDg6MTU6MDAuMDAwIiwgImRpdiI6ICIxIiwgImR3cl9hYmJyZXYiOiAiQk9DTUlEQ08iLCAiZmxhZyI6IG51bGwsICJodHRwX2xpbmthZ2UudXJsIjogImh0dHBzOi8vZHdyLnN0YXRlLmNvLnVzL1N1cmZhY2VXYXRlci9kYXRhL2RldGFpbF9ncmFwaC5hc3B4P0lEPUJPQ01JRENPXHUwMDI2TVRZUEU9RElTQ0hSRyIsICJsb2NhdGlvbi5sYXRpdHVkZSI6IDM5Ljk2MTY1NSwgImxvY2F0aW9uLmxvbmdpdHVkZSI6IC0xMDUuNTA0NDQsICJsb2NhdGlvbi5uZWVkc19yZWNvZGluZyI6IGZhbHNlLCAic3RhZ2UiOiAiMS4xNCIsICJzdGF0aW9uX25hbWUiOiAiTUlERExFIEJPVUxERVIgQ1JFRUsgQVQgTkVERVJMQU5ELCBDTy4iLCAic3RhdGlvbl9zdGF0dXMiOiAiQWN0aXZlIiwgInN0YXRpb25fdHlwZSI6ICJTdHJlYW0iLCAidXNnc19zdGF0aW9uX2lkIjogIjA2NzI1NTAwIiwgInZhcmlhYmxlIjogIkRJU0NIUkciLCAid2QiOiAiNiJ9LCAidHlwZSI6ICJGZWF0dXJlIn0sIHsiYmJveCI6IFstMTA1LjA5Nzg3MiwgNDAuMDU5ODA5LCAtMTA1LjA5Nzg3MiwgNDAuMDU5ODA5XSwgImdlb21ldHJ5IjogeyJjb29yZGluYXRlcyI6IFstMTA1LjA5Nzg3MiwgNDAuMDU5ODA5XSwgInR5cGUiOiAiUG9pbnQifSwgImlkIjogIjIyIiwgInByb3BlcnRpZXMiOiB7ImFtb3VudCI6ICI0NC42MCIsICJjb3VudHkiOiAiQk9VTERFUiIsICJkYXRhX3NvdXJjZSI6ICJDby4gRGl2aXNpb24gb2YgV2F0ZXIgUmVzb3VyY2VzIiwgImRhdGVfdGltZSI6ICIyMDIwLTAzLTI0VDA4OjQ1OjAwLjAwMCIsICJkaXYiOiAiMSIsICJkd3JfYWJicmV2IjogIkJPQzEwOUNPIiwgImZsYWciOiBudWxsLCAiaHR0cF9saW5rYWdlLnVybCI6ICJodHRwczovL2R3ci5zdGF0ZS5jby51cy9TdXJmYWNlV2F0ZXIvZGF0YS9kZXRhaWxfZ3JhcGguYXNweD9JRD1CT0MxMDlDT1x1MDAyNk1UWVBFPURJU0NIUkciLCAibG9jYXRpb24ubGF0aXR1ZGUiOiA0MC4wNTk4MDksICJsb2NhdGlvbi5sb25naXR1ZGUiOiAtMTA1LjA5Nzg3MiwgImxvY2F0aW9uLm5lZWRzX3JlY29kaW5nIjogZmFsc2UsICJzdGFnZSI6ICIyLjUyIiwgInN0YXRpb25fbmFtZSI6ICJCT1VMREVSIENSRUVLIEFUIDEwOSBTVCBORUFSIEVSSUUsIENPIiwgInN0YXRpb25fc3RhdHVzIjogIkFjdGl2ZSIsICJzdGF0aW9uX3R5cGUiOiAiU3RyZWFtIiwgInVzZ3Nfc3RhdGlvbl9pZCI6IG51bGwsICJ2YXJpYWJsZSI6ICJESVNDSFJHIiwgIndkIjogIjYifSwgInR5cGUiOiAiRmVhdHVyZSJ9LCB7ImJib3giOiBbLTEwNS4zNjM0MjIsIDQwLjIxNTY1OCwgLTEwNS4zNjM0MjIsIDQwLjIxNTY1OF0sICJnZW9tZXRyeSI6IHsiY29vcmRpbmF0ZXMiOiBbLTEwNS4zNjM0MjIsIDQwLjIxNTY1OF0sICJ0eXBlIjogIlBvaW50In0sICJpZCI6ICIyMyIsICJwcm9wZXJ0aWVzIjogeyJhbW91bnQiOiAiMTkuMzAiLCAiY291bnR5IjogIkJPVUxERVIiLCAiZGF0YV9zb3VyY2UiOiAiQ28uIERpdmlzaW9uIG9mIFdhdGVyIFJlc291cmNlcyIsICJkYXRlX3RpbWUiOiAiMjAyMC0wMy0yNFQwODo0NTowMC4wMDAiLCAiZGl2IjogIjEiLCAiZHdyX2FiYnJldiI6ICJOU1ZCQlJDTyIsICJmbGFnIjogbnVsbCwgImh0dHBfbGlua2FnZS51cmwiOiAiaHR0cHM6Ly9kd3Iuc3RhdGUuY28udXMvU3VyZmFjZVdhdGVyL2RhdGEvZGV0YWlsX2dyYXBoLmFzcHg/SUQ9TlNWQkJSQ09cdTAwMjZNVFlQRT1ESVNDSFJHIiwgImxvY2F0aW9uLmxhdGl0dWRlIjogNDAuMjE1NjU4LCAibG9jYXRpb24ubG9uZ2l0dWRlIjogLTEwNS4zNjM0MjIsICJsb2NhdGlvbi5uZWVkc19yZWNvZGluZyI6IGZhbHNlLCAic3RhZ2UiOiAiMC4zNCIsICJzdGF0aW9uX25hbWUiOiAiTk9SVEggU0FJTlQgVlJBSU4gQ1JFRUsgQkVMT1cgQlVUVE9OUk9DSyAgKFJBTFBIIFBSSUNFKSBSRVNFUlZPSVIiLCAic3RhdGlvbl9zdGF0dXMiOiAiQWN0aXZlIiwgInN0YXRpb25fdHlwZSI6ICJTdHJlYW0iLCAidXNnc19zdGF0aW9uX2lkIjogbnVsbCwgInZhcmlhYmxlIjogIkRJU0NIUkciLCAid2QiOiAiNSJ9LCAidHlwZSI6ICJGZWF0dXJlIn0sIHsiYmJveCI6IFstMTA1LjMwNDQwNCwgNDAuMTI2Mzg5LCAtMTA1LjMwNDQwNCwgNDAuMTI2Mzg5XSwgImdlb21ldHJ5IjogeyJjb29yZGluYXRlcyI6IFstMTA1LjMwNDQwNCwgNDAuMTI2Mzg5XSwgInR5cGUiOiAiUG9pbnQifSwgImlkIjogIjI0IiwgInByb3BlcnRpZXMiOiB7ImFtb3VudCI6ICIxMi42MCIsICJjb3VudHkiOiAiQk9VTERFUiIsICJkYXRhX3NvdXJjZSI6ICJDby4gRGl2aXNpb24gb2YgV2F0ZXIgUmVzb3VyY2VzIiwgImRhdGVfdGltZSI6ICIyMDIwLTAzLTI0VDA4OjE1OjAwLjAwMCIsICJkaXYiOiAiMSIsICJkd3JfYWJicmV2IjogIkxFRkNSRUNPIiwgImZsYWciOiBudWxsLCAiaHR0cF9saW5rYWdlLnVybCI6ICJodHRwczovL2R3ci5zdGF0ZS5jby51cy9TdXJmYWNlV2F0ZXIvZGF0YS9kZXRhaWxfZ3JhcGguYXNweD9JRD1MRUZDUkVDT1x1MDAyNk1UWVBFPURJU0NIUkciLCAibG9jYXRpb24ubGF0aXR1ZGUiOiA0MC4xMjYzODksICJsb2NhdGlvbi5sb25naXR1ZGUiOiAtMTA1LjMwNDQwNCwgImxvY2F0aW9uLm5lZWRzX3JlY29kaW5nIjogZmFsc2UsICJzdGFnZSI6ICIwLjQ2IiwgInN0YXRpb25fbmFtZSI6ICJMRUZUIEhBTkQgQ1JFRUsgTkVBUiBCT1VMREVSLCBDTy4iLCAic3RhdGlvbl9zdGF0dXMiOiAiQWN0aXZlIiwgInN0YXRpb25fdHlwZSI6ICJTdHJlYW0iLCAidXNnc19zdGF0aW9uX2lkIjogIjA2NzI0NTAwIiwgInZhcmlhYmxlIjogIkRJU0NIUkciLCAid2QiOiAiNSJ9LCAidHlwZSI6ICJGZWF0dXJlIn0sIHsiYmJveCI6IFstMTA1LjIxNzUxOSwgNDAuMDg2Mjc4LCAtMTA1LjIxNzUxOSwgNDAuMDg2Mjc4XSwgImdlb21ldHJ5IjogeyJjb29yZGluYXRlcyI6IFstMTA1LjIxNzUxOSwgNDAuMDg2Mjc4XSwgInR5cGUiOiAiUG9pbnQifSwgImlkIjogIjI1IiwgInByb3BlcnRpZXMiOiB7ImFtb3VudCI6ICIwLjAwIiwgImNvdW50eSI6ICJCT1VMREVSIiwgImRhdGFfc291cmNlIjogIk5vcnRoZXJuIENvbG9yYWRvIFdhdGVyIENvbnNlcnZhbmN5IERpc3RyaWN0IiwgImRhdGVfdGltZSI6ICIyMDIwLTAzLTI0VDA4OjAwOjAwLjAwMCIsICJkaXYiOiAiMSIsICJkd3JfYWJicmV2IjogIkJGQ0lORkNPIiwgImZsYWciOiBudWxsLCAiaHR0cF9saW5rYWdlLnVybCI6ICJodHRwOi8vd3d3Lm5vcnRoZXJud2F0ZXIub3JnL1dhdGVyUHJvamVjdHMvV2F0ZXJEYXRhLmFzcHhFYXN0U2xvcGVXYXRlckRhdGEuYXNweCIsICJsb2NhdGlvbi5sYXRpdHVkZSI6IDQwLjA4NjI3OCwgImxvY2F0aW9uLmxvbmdpdHVkZSI6IC0xMDUuMjE3NTE5LCAibG9jYXRpb24ubmVlZHNfcmVjb2RpbmciOiBmYWxzZSwgInN0YWdlIjogIjAuMDEiLCAic3RhdGlvbl9uYW1lIjogIkJPVUxERVIgUkVTRVJWT0lSIElOTEVUIiwgInN0YXRpb25fc3RhdHVzIjogIkFjdGl2ZSIsICJzdGF0aW9uX3R5cGUiOiAiU3RyZWFtIiwgInVzZ3Nfc3RhdGlvbl9pZCI6ICJFUzE5MTYiLCAidmFyaWFibGUiOiAiRElTQ0hSRyIsICJ3ZCI6ICI2In0sICJ0eXBlIjogIkZlYXR1cmUifSwgeyJiYm94IjogWy0xMDUuMjEwMzg4MDAwMDAwMDEsIDQwLjE5MzAxOSwgLTEwNS4yMTAzODgwMDAwMDAwMSwgNDAuMTkzMDE5XSwgImdlb21ldHJ5IjogeyJjb29yZGluYXRlcyI6IFstMTA1LjIxMDM4ODAwMDAwMDAxLCA0MC4xOTMwMTldLCAidHlwZSI6ICJQb2ludCJ9LCAiaWQiOiAiMjYiLCAicHJvcGVydGllcyI6IHsiYW1vdW50IjogIjAuMDAiLCAiY291bnR5IjogIkJPVUxERVIiLCAiZGF0YV9zb3VyY2UiOiAiQ29vcGVyYXRpdmUgUHJvZ3JhbSBvZiBDRFdSLCBOQ1dDRCBcdTAwMjYgU1ZMSFdDRCIsICJkYXRlX3RpbWUiOiAiMjAyMC0wMy0yNFQwODowMDowMC4wMDAiLCAiZGl2IjogIjEiLCAiZHdyX2FiYnJldiI6ICJUUlVESVRDTyIsICJmbGFnIjogbnVsbCwgImh0dHBfbGlua2FnZS51cmwiOiAiaHR0cHM6Ly9kd3Iuc3RhdGUuY28udXMvU3VyZmFjZVdhdGVyL2RhdGEvZGV0YWlsX2dyYXBoLmFzcHg/SUQ9VFJVRElUQ09cdTAwMjZNVFlQRT1ESVNDSFJHIiwgImxvY2F0aW9uLmxhdGl0dWRlIjogNDAuMTkzMDE5LCAibG9jYXRpb24ubG9uZ2l0dWRlIjogLTEwNS4yMTAzODgsICJsb2NhdGlvbi5uZWVkc19yZWNvZGluZyI6IGZhbHNlLCAic3RhZ2UiOiBudWxsLCAic3RhdGlvbl9uYW1lIjogIlRSVUUgQU5EIFdFQlNURVIgRElUQ0giLCAic3RhdGlvbl9zdGF0dXMiOiAiQWN0aXZlIiwgInN0YXRpb25fdHlwZSI6ICJEaXZlcnNpb24iLCAidXNnc19zdGF0aW9uX2lkIjogbnVsbCwgInZhcmlhYmxlIjogIkRJU0NIUkciLCAid2QiOiAiNSJ9LCAidHlwZSI6ICJGZWF0dXJlIn0sIHsiYmJveCI6IFstMTA1LjI1MTgyNiwgNDAuMjEyNjU4LCAtMTA1LjI1MTgyNiwgNDAuMjEyNjU4XSwgImdlb21ldHJ5IjogeyJjb29yZGluYXRlcyI6IFstMTA1LjI1MTgyNiwgNDAuMjEyNjU4XSwgInR5cGUiOiAiUG9pbnQifSwgImlkIjogIjI3IiwgInByb3BlcnRpZXMiOiB7ImFtb3VudCI6ICIwLjAwIiwgImNvdW50eSI6ICJCT1VMREVSIiwgImRhdGFfc291cmNlIjogIkNvb3BlcmF0aXZlIFByb2dyYW0gb2YgQ0RXUiwgTkNXQ0QgXHUwMDI2IFNWTEhXQ0QiLCAiZGF0ZV90aW1lIjogIjIwMjAtMDMtMjRUMDg6MDA6MDAuMDAwIiwgImRpdiI6ICIxIiwgImR3cl9hYmJyZXYiOiAiUk9VUkVBQ08iLCAiZmxhZyI6IG51bGwsICJodHRwX2xpbmthZ2UudXJsIjogImh0dHBzOi8vZHdyLnN0YXRlLmNvLnVzL1N1cmZhY2VXYXRlci9kYXRhL2RldGFpbF9ncmFwaC5hc3B4P0lEPVJPVVJFQUNPXHUwMDI2TVRZUEU9RElTQ0hSRyIsICJsb2NhdGlvbi5sYXRpdHVkZSI6IDQwLjIxMjY1OCwgImxvY2F0aW9uLmxvbmdpdHVkZSI6IC0xMDUuMjUxODI2LCAibG9jYXRpb24ubmVlZHNfcmVjb2RpbmciOiBmYWxzZSwgInN0YWdlIjogbnVsbCwgInN0YXRpb25fbmFtZSI6ICJST1VHSCBBTkQgUkVBRFkgRElUQ0giLCAic3RhdGlvbl9zdGF0dXMiOiAiQWN0aXZlIiwgInN0YXRpb25fdHlwZSI6ICJEaXZlcnNpb24iLCAidXNnc19zdGF0aW9uX2lkIjogbnVsbCwgInZhcmlhYmxlIjogIkRJU0NIUkciLCAid2QiOiAiNSJ9LCAidHlwZSI6ICJGZWF0dXJlIn0sIHsiYmJveCI6IFstMTA1LjE2Nzg3MywgNDAuMTc0ODQ0LCAtMTA1LjE2Nzg3MywgNDAuMTc0ODQ0XSwgImdlb21ldHJ5IjogeyJjb29yZGluYXRlcyI6IFstMTA1LjE2Nzg3MywgNDAuMTc0ODQ0XSwgInR5cGUiOiAiUG9pbnQifSwgImlkIjogIjI4IiwgInByb3BlcnRpZXMiOiB7ImFtb3VudCI6ICIwLjEwIiwgImNvdW50eSI6ICJCT1VMREVSIiwgImRhdGFfc291cmNlIjogIkNvb3BlcmF0aXZlIFByb2dyYW0gb2YgQ0RXUiwgTkNXQ0QgXHUwMDI2IFNWTEhXQ0QiLCAiZGF0ZV90aW1lIjogIjIwMjAtMDMtMjRUMDc6NDU6MDAuMDAwIiwgImRpdiI6ICIxIiwgImR3cl9hYmJyZXYiOiAiSEdSTURXQ08iLCAiZmxhZyI6IG51bGwsICJodHRwX2xpbmthZ2UudXJsIjogImh0dHBzOi8vZHdyLnN0YXRlLmNvLnVzL1N1cmZhY2VXYXRlci9kYXRhL2RldGFpbF9ncmFwaC5hc3B4P0lEPUhHUk1EV0NPXHUwMDI2TVRZUEU9RElTQ0hSRyIsICJsb2NhdGlvbi5sYXRpdHVkZSI6IDQwLjE3NDg0NCwgImxvY2F0aW9uLmxvbmdpdHVkZSI6IC0xMDUuMTY3ODczLCAibG9jYXRpb24ubmVlZHNfcmVjb2RpbmciOiBmYWxzZSwgInN0YWdlIjogIjAuMDYiLCAic3RhdGlvbl9uYW1lIjogIkhBR0VSIE1FQURPV1MgRElUQ0giLCAic3RhdGlvbl9zdGF0dXMiOiAiQWN0aXZlIiwgInN0YXRpb25fdHlwZSI6ICJEaXZlcnNpb24iLCAidXNnc19zdGF0aW9uX2lkIjogbnVsbCwgInZhcmlhYmxlIjogIkRJU0NIUkciLCAid2QiOiAiNSJ9LCAidHlwZSI6ICJGZWF0dXJlIn0sIHsiYmJveCI6IFstMTA1LjIwOTQxNiwgNDAuMjU2Mjc2MDAwMDAwMDEsIC0xMDUuMjA5NDE2LCA0MC4yNTYyNzYwMDAwMDAwMV0sICJnZW9tZXRyeSI6IHsiY29vcmRpbmF0ZXMiOiBbLTEwNS4yMDk0MTYsIDQwLjI1NjI3NjAwMDAwMDAxXSwgInR5cGUiOiAiUG9pbnQifSwgImlkIjogIjI5IiwgInByb3BlcnRpZXMiOiB7ImFtb3VudCI6ICIwLjAwIiwgImNvdW50eSI6ICJCT1VMREVSIiwgImRhdGFfc291cmNlIjogIk5vcnRoZXJuIENvbG9yYWRvIFdhdGVyIENvbnNlcnZhbmN5IERpc3RyaWN0IiwgImRhdGVfdGltZSI6ICIyMDIwLTAzLTI0VDA4OjAwOjAwLjAwMCIsICJkaXYiOiAiMSIsICJkd3JfYWJicmV2IjogIkxJVFRIMUNPIiwgImZsYWciOiBudWxsLCAiaHR0cF9saW5rYWdlLnVybCI6ICJodHRwOi8vd3d3Lm5vcnRoZXJud2F0ZXIub3JnL1dhdGVyUHJvamVjdHMvV2F0ZXJEYXRhLmFzcHhFYXN0U2xvcGVXYXRlckRhdGEuYXNweCIsICJsb2NhdGlvbi5sYXRpdHVkZSI6IDQwLjI1NjI3NiwgImxvY2F0aW9uLmxvbmdpdHVkZSI6IC0xMDUuMjA5NDE2LCAibG9jYXRpb24ubmVlZHNfcmVjb2RpbmciOiBmYWxzZSwgInN0YWdlIjogbnVsbCwgInN0YXRpb25fbmFtZSI6ICJMSVRUTEUgVEhPTVBTT04gIzEgRElUQ0giLCAic3RhdGlvbl9zdGF0dXMiOiAiQWN0aXZlIiwgInN0YXRpb25fdHlwZSI6ICJEaXZlcnNpb24iLCAidXNnc19zdGF0aW9uX2lkIjogIkVTMTkwMSIsICJ2YXJpYWJsZSI6ICJESVNDSFJHIiwgIndkIjogIjQifSwgInR5cGUiOiAiRmVhdHVyZSJ9LCB7ImJib3giOiBbLTEwNS4xOTg1NjcsIDQwLjI2MDgyNywgLTEwNS4xOTg1NjcsIDQwLjI2MDgyN10sICJnZW9tZXRyeSI6IHsiY29vcmRpbmF0ZXMiOiBbLTEwNS4xOTg1NjcsIDQwLjI2MDgyN10sICJ0eXBlIjogIlBvaW50In0sICJpZCI6ICIzMCIsICJwcm9wZXJ0aWVzIjogeyJhbW91bnQiOiAiMC4wMCIsICJjb3VudHkiOiAiQk9VTERFUiIsICJkYXRhX3NvdXJjZSI6ICJDb29wZXJhdGl2ZSBTRFIgUHJvZ3JhbSBvZiBDRFdSIFx1MDAyNiBOQ1dDRCIsICJkYXRlX3RpbWUiOiAiMjAyMC0wMy0yNFQwODowMDowMC4wMDAiLCAiZGl2IjogIjEiLCAiZHdyX2FiYnJldiI6ICJDVUxESVRDTyIsICJmbGFnIjogbnVsbCwgImh0dHBfbGlua2FnZS51cmwiOiAiaHR0cHM6Ly9kd3Iuc3RhdGUuY28udXMvU3VyZmFjZVdhdGVyL2RhdGEvZGV0YWlsX2dyYXBoLmFzcHg/SUQ9Q1VMRElUQ09cdTAwMjZNVFlQRT1ESVNDSFJHIiwgImxvY2F0aW9uLmxhdGl0dWRlIjogNDAuMjYwODI3LCAibG9jYXRpb24ubG9uZ2l0dWRlIjogLTEwNS4xOTg1NjcsICJsb2NhdGlvbi5uZWVkc19yZWNvZGluZyI6IGZhbHNlLCAic3RhZ2UiOiBudWxsLCAic3RhdGlvbl9uYW1lIjogIkNVTFZFUiBESVRDSCIsICJzdGF0aW9uX3N0YXR1cyI6ICJBY3RpdmUiLCAic3RhdGlvbl90eXBlIjogIkRpdmVyc2lvbiIsICJ1c2dzX3N0YXRpb25faWQiOiBudWxsLCAidmFyaWFibGUiOiAiRElTQ0hSRyIsICJ3ZCI6ICI0In0sICJ0eXBlIjogIkZlYXR1cmUifSwgeyJiYm94IjogWy0xMDUuMjU2MDE3LCA0MC4yMTUwNDMsIC0xMDUuMjU2MDE3LCA0MC4yMTUwNDNdLCAiZ2VvbWV0cnkiOiB7ImNvb3JkaW5hdGVzIjogWy0xMDUuMjU2MDE3LCA0MC4yMTUwNDNdLCAidHlwZSI6ICJQb2ludCJ9LCAiaWQiOiAiMzEiLCAicHJvcGVydGllcyI6IHsiYW1vdW50IjogIjM5LjcwIiwgImNvdW50eSI6ICJCT1VMREVSIiwgImRhdGFfc291cmNlIjogIkNvLiBEaXZpc2lvbiBvZiBXYXRlciBSZXNvdXJjZXMiLCAiZGF0ZV90aW1lIjogIjIwMjAtMDMtMjRUMDg6MzA6MDAuMDAwIiwgImRpdiI6ICIxIiwgImR3cl9hYmJyZXYiOiAiSElHSExEQ08iLCAiZmxhZyI6IG51bGwsICJodHRwX2xpbmthZ2UudXJsIjogImh0dHBzOi8vZHdyLnN0YXRlLmNvLnVzL1N1cmZhY2VXYXRlci9kYXRhL2RldGFpbF9ncmFwaC5hc3B4P0lEPUhJR0hMRENPXHUwMDI2TVRZUEU9RElTQ0hSRyIsICJsb2NhdGlvbi5sYXRpdHVkZSI6IDQwLjIxNTA0MywgImxvY2F0aW9uLmxvbmdpdHVkZSI6IC0xMDUuMjU2MDE3LCAibG9jYXRpb24ubmVlZHNfcmVjb2RpbmciOiBmYWxzZSwgInN0YWdlIjogIjAuNzMiLCAic3RhdGlvbl9uYW1lIjogIkhJR0hMQU5EIERJVENIIEFUIExZT05TLCBDTyIsICJzdGF0aW9uX3N0YXR1cyI6ICJBY3RpdmUiLCAic3RhdGlvbl90eXBlIjogIkRpdmVyc2lvbiIsICJ1c2dzX3N0YXRpb25faWQiOiBudWxsLCAidmFyaWFibGUiOiAiRElTQ0hSRyIsICJ3ZCI6ICI1In0sICJ0eXBlIjogIkZlYXR1cmUifSwgeyJiYm94IjogWy0xMDUuMjIwNDk3LCA0MC4wNzg1NiwgLTEwNS4yMjA0OTcsIDQwLjA3ODU2XSwgImdlb21ldHJ5IjogeyJjb29yZGluYXRlcyI6IFstMTA1LjIyMDQ5NywgNDAuMDc4NTZdLCAidHlwZSI6ICJQb2ludCJ9LCAiaWQiOiAiMzIiLCAicHJvcGVydGllcyI6IHsiYW1vdW50IjogIjUxOTcuNTAiLCAiY291bnR5IjogIkJPVUxERVIiLCAiZGF0YV9zb3VyY2UiOiAiTm9ydGhlcm4gQ29sb3JhZG8gV2F0ZXIgQ29uc2VydmFuY3kgRGlzdHJpY3QiLCAiZGF0ZV90aW1lIjogIjIwMjAtMDMtMjRUMDg6MDA6MDAuMDAwIiwgImRpdiI6ICIxIiwgImR3cl9hYmJyZXYiOiAiQk9VUkVTQ08iLCAiZmxhZyI6IG51bGwsICJodHRwX2xpbmthZ2UudXJsIjogImh0dHA6Ly93d3cubm9ydGhlcm53YXRlci5vcmcvV2F0ZXJQcm9qZWN0cy9XYXRlckRhdGEuYXNweEVhc3RTbG9wZVdhdGVyRGF0YS5hc3B4IiwgImxvY2F0aW9uLmxhdGl0dWRlIjogNDAuMDc4NTYsICJsb2NhdGlvbi5sb25naXR1ZGUiOiAtMTA1LjIyMDQ5NywgImxvY2F0aW9uLm5lZWRzX3JlY29kaW5nIjogZmFsc2UsICJzdGFnZSI6IG51bGwsICJzdGF0aW9uX25hbWUiOiAiQk9VTERFUiBSRVNFUlZPSVIiLCAic3RhdGlvbl9zdGF0dXMiOiAiQWN0aXZlIiwgInN0YXRpb25fdHlwZSI6ICJSZXNlcnZvaXIiLCAidXNnc19zdGF0aW9uX2lkIjogIkVSMTkxNCIsICJ2YXJpYWJsZSI6ICJTVE9SQUdFIiwgIndkIjogIjYifSwgInR5cGUiOiAiRmVhdHVyZSJ9LCB7ImJib3giOiBbLTEwNS4xNjkzNzQsIDQwLjE3Mzk1LCAtMTA1LjE2OTM3NCwgNDAuMTczOTVdLCAiZ2VvbWV0cnkiOiB7ImNvb3JkaW5hdGVzIjogWy0xMDUuMTY5Mzc0LCA0MC4xNzM5NV0sICJ0eXBlIjogIlBvaW50In0sICJpZCI6ICIzMyIsICJwcm9wZXJ0aWVzIjogeyJhbW91bnQiOiAiMC4xOSIsICJjb3VudHkiOiAiQk9VTERFUiIsICJkYXRhX3NvdXJjZSI6ICJDb29wZXJhdGl2ZSBQcm9ncmFtIG9mIENEV1IsIE5DV0NEIFx1MDAyNiBTVkxIV0NEIiwgImRhdGVfdGltZSI6ICIyMDIwLTAzLTI0VDA3OjMwOjAwLjAwMCIsICJkaXYiOiAiMSIsICJkd3JfYWJicmV2IjogIk5JV0RJVENPIiwgImZsYWciOiBudWxsLCAiaHR0cF9saW5rYWdlLnVybCI6ICJodHRwczovL2R3ci5zdGF0ZS5jby51cy9TdXJmYWNlV2F0ZXIvZGF0YS9kZXRhaWxfZ3JhcGguYXNweD9JRD1OSVdESVRDT1x1MDAyNk1UWVBFPURJU0NIUkciLCAibG9jYXRpb24ubGF0aXR1ZGUiOiA0MC4xNzM5NSwgImxvY2F0aW9uLmxvbmdpdHVkZSI6IC0xMDUuMTY5Mzc0LCAibG9jYXRpb24ubmVlZHNfcmVjb2RpbmciOiBmYWxzZSwgInN0YWdlIjogIjAuMDkiLCAic3RhdGlvbl9uYW1lIjogIk5JV09UIERJVENIIiwgInN0YXRpb25fc3RhdHVzIjogIkFjdGl2ZSIsICJzdGF0aW9uX3R5cGUiOiAiRGl2ZXJzaW9uIiwgInVzZ3Nfc3RhdGlvbl9pZCI6IG51bGwsICJ2YXJpYWJsZSI6ICJESVNDSFJHIiwgIndkIjogIjUifSwgInR5cGUiOiAiRmVhdHVyZSJ9LCB7ImJib3giOiBbLTEwNS4yNTA5NTIsIDQwLjIxMTM4OSwgLTEwNS4yNTA5NTIsIDQwLjIxMTM4OV0sICJnZW9tZXRyeSI6IHsiY29vcmRpbmF0ZXMiOiBbLTEwNS4yNTA5NTIsIDQwLjIxMTM4OV0sICJ0eXBlIjogIlBvaW50In0sICJpZCI6ICIzNCIsICJwcm9wZXJ0aWVzIjogeyJhbW91bnQiOiAiMC4wMCIsICJjb3VudHkiOiAiQk9VTERFUiIsICJkYXRhX3NvdXJjZSI6ICJDb29wZXJhdGl2ZSBQcm9ncmFtIG9mIENEV1IsIE5DV0NEIFx1MDAyNiBTVkxIV0NEIiwgImRhdGVfdGltZSI6ICIyMDIwLTAzLTI0VDA3OjAwOjAwLjAwMCIsICJkaXYiOiAiMSIsICJkd3JfYWJicmV2IjogIlNNRURJVENPIiwgImZsYWciOiBudWxsLCAiaHR0cF9saW5rYWdlLnVybCI6ICJodHRwczovL2R3ci5zdGF0ZS5jby51cy9TdXJmYWNlV2F0ZXIvZGF0YS9kZXRhaWxfZ3JhcGguYXNweD9JRD1TTUVESVRDT1x1MDAyNk1UWVBFPURJU0NIUkciLCAibG9jYXRpb24ubGF0aXR1ZGUiOiA0MC4yMTEzODksICJsb2NhdGlvbi5sb25naXR1ZGUiOiAtMTA1LjI1MDk1MiwgImxvY2F0aW9uLm5lZWRzX3JlY29kaW5nIjogZmFsc2UsICJzdGFnZSI6IG51bGwsICJzdGF0aW9uX25hbWUiOiAiU01FQUQgRElUQ0giLCAic3RhdGlvbl9zdGF0dXMiOiAiQWN0aXZlIiwgInN0YXRpb25fdHlwZSI6ICJEaXZlcnNpb24iLCAidXNnc19zdGF0aW9uX2lkIjogbnVsbCwgInZhcmlhYmxlIjogIkRJU0NIUkciLCAid2QiOiAiNSJ9LCAidHlwZSI6ICJGZWF0dXJlIn0sIHsiYmJveCI6IFstMTA1LjA4ODY5NSwgNDAuMTUzMzYzLCAtMTA1LjA4ODY5NSwgNDAuMTUzMzYzXSwgImdlb21ldHJ5IjogeyJjb29yZGluYXRlcyI6IFstMTA1LjA4ODY5NSwgNDAuMTUzMzYzXSwgInR5cGUiOiAiUG9pbnQifSwgImlkIjogIjM1IiwgInByb3BlcnRpZXMiOiB7ImFtb3VudCI6ICIwLjEwIiwgImNvdW50eSI6ICJCT1VMREVSIiwgImRhdGFfc291cmNlIjogIkNvb3BlcmF0aXZlIFByb2dyYW0gb2YgQ0RXUiwgTkNXQ0QgXHUwMDI2IFNWTEhXQ0QiLCAiZGF0ZV90aW1lIjogIjIwMjAtMDMtMjRUMDg6MDA6MDAuMDAwIiwgImRpdiI6ICIxIiwgImR3cl9hYmJyZXYiOiAiQk9ORElUQ08iLCAiZmxhZyI6IG51bGwsICJodHRwX2xpbmthZ2UudXJsIjogImh0dHBzOi8vZHdyLnN0YXRlLmNvLnVzL1N1cmZhY2VXYXRlci9kYXRhL2RldGFpbF9ncmFwaC5hc3B4P0lEPUJPTkRJVENPXHUwMDI2TVRZUEU9RElTQ0hSRyIsICJsb2NhdGlvbi5sYXRpdHVkZSI6IDQwLjE1MzM2MywgImxvY2F0aW9uLmxvbmdpdHVkZSI6IC0xMDUuMDg4Njk1LCAibG9jYXRpb24ubmVlZHNfcmVjb2RpbmciOiBmYWxzZSwgInN0YWdlIjogIjAuMDQiLCAic3RhdGlvbl9uYW1lIjogIkJPTlVTIERJVENIIiwgInN0YXRpb25fc3RhdHVzIjogIkFjdGl2ZSIsICJzdGF0aW9uX3R5cGUiOiAiRGl2ZXJzaW9uIiwgInVzZ3Nfc3RhdGlvbl9pZCI6IG51bGwsICJ2YXJpYWJsZSI6ICJESVNDSFJHIiwgIndkIjogIjUifSwgInR5cGUiOiAiRmVhdHVyZSJ9LCB7ImJib3giOiBbLTEwNS4yNTA5MjcsIDQwLjIxMTA4MywgLTEwNS4yNTA5MjcsIDQwLjIxMTA4M10sICJnZW9tZXRyeSI6IHsiY29vcmRpbmF0ZXMiOiBbLTEwNS4yNTA5MjcsIDQwLjIxMTA4M10sICJ0eXBlIjogIlBvaW50In0sICJpZCI6ICIzNiIsICJwcm9wZXJ0aWVzIjogeyJhbW91bnQiOiAiMC4wMCIsICJjb3VudHkiOiAiQk9VTERFUiIsICJkYXRhX3NvdXJjZSI6ICJDb29wZXJhdGl2ZSBQcm9ncmFtIG9mIENEV1IsIE5DV0NEIFx1MDAyNiBTVkxIV0NEIiwgImRhdGVfdGltZSI6ICIyMDIwLTAzLTI0VDA3OjAwOjAwLjAwMCIsICJkaXYiOiAiMSIsICJkd3JfYWJicmV2IjogIlNXRURJVENPIiwgImZsYWciOiBudWxsLCAiaHR0cF9saW5rYWdlLnVybCI6ICJodHRwczovL2R3ci5zdGF0ZS5jby51cy9TdXJmYWNlV2F0ZXIvZGF0YS9kZXRhaWxfZ3JhcGguYXNweD9JRD1TV0VESVRDT1x1MDAyNk1UWVBFPURJU0NIUkciLCAibG9jYXRpb24ubGF0aXR1ZGUiOiA0MC4yMTEwODMsICJsb2NhdGlvbi5sb25naXR1ZGUiOiAtMTA1LjI1MDkyNywgImxvY2F0aW9uLm5lZWRzX3JlY29kaW5nIjogZmFsc2UsICJzdGFnZSI6ICItMC4wNSIsICJzdGF0aW9uX25hbWUiOiAiU1dFREUgRElUQ0giLCAic3RhdGlvbl9zdGF0dXMiOiAiQWN0aXZlIiwgInN0YXRpb25fdHlwZSI6ICJEaXZlcnNpb24iLCAidXNnc19zdGF0aW9uX2lkIjogbnVsbCwgInZhcmlhYmxlIjogIkRJU0NIUkciLCAid2QiOiAiNSJ9LCAidHlwZSI6ICJGZWF0dXJlIn0sIHsiYmJveCI6IFstMTA1LjE4OTEzMiwgNDAuMTg3NTI0LCAtMTA1LjE4OTEzMiwgNDAuMTg3NTI0XSwgImdlb21ldHJ5IjogeyJjb29yZGluYXRlcyI6IFstMTA1LjE4OTEzMiwgNDAuMTg3NTI0XSwgInR5cGUiOiAiUG9pbnQifSwgImlkIjogIjM3IiwgInByb3BlcnRpZXMiOiB7ImFtb3VudCI6ICIwLjAwIiwgImNvdW50eSI6ICJCT1VMREVSIiwgImRhdGFfc291cmNlIjogIkNvb3BlcmF0aXZlIFByb2dyYW0gb2YgQ0RXUiwgTkNXQ0QgXHUwMDI2IFNWTEhXQ0QiLCAiZGF0ZV90aW1lIjogIjIwMjAtMDMtMjRUMDg6MDA6MDAuMDAwIiwgImRpdiI6ICIxIiwgImR3cl9hYmJyZXYiOiAiUlVOWU9OQ08iLCAiZmxhZyI6IG51bGwsICJodHRwX2xpbmthZ2UudXJsIjogImh0dHBzOi8vZHdyLnN0YXRlLmNvLnVzL1N1cmZhY2VXYXRlci9kYXRhL2RldGFpbF9ncmFwaC5hc3B4P0lEPVJVTllPTkNPXHUwMDI2TVRZUEU9RElTQ0hSRyIsICJsb2NhdGlvbi5sYXRpdHVkZSI6IDQwLjE4NzUyNCwgImxvY2F0aW9uLmxvbmdpdHVkZSI6IC0xMDUuMTg5MTMyLCAibG9jYXRpb24ubmVlZHNfcmVjb2RpbmciOiBmYWxzZSwgInN0YWdlIjogIjUwLjc5IiwgInN0YXRpb25fbmFtZSI6ICJSVU5ZT04gRElUQ0giLCAic3RhdGlvbl9zdGF0dXMiOiAiQWN0aXZlIiwgInN0YXRpb25fdHlwZSI6ICJEaXZlcnNpb24iLCAidXNnc19zdGF0aW9uX2lkIjogbnVsbCwgInZhcmlhYmxlIjogIkRJU0NIUkciLCAid2QiOiAiNSJ9LCAidHlwZSI6ICJGZWF0dXJlIn0sIHsiYmJveCI6IFstMTA1LjE5Njc3NSwgNDAuMTgxODgsIC0xMDUuMTk2Nzc1LCA0MC4xODE4OF0sICJnZW9tZXRyeSI6IHsiY29vcmRpbmF0ZXMiOiBbLTEwNS4xOTY3NzUsIDQwLjE4MTg4XSwgInR5cGUiOiAiUG9pbnQifSwgImlkIjogIjM4IiwgInByb3BlcnRpZXMiOiB7ImFtb3VudCI6ICIwLjAwIiwgImNvdW50eSI6ICJCT1VMREVSIiwgImRhdGFfc291cmNlIjogIkNvb3BlcmF0aXZlIFByb2dyYW0gb2YgQ0RXUiwgTkNXQ0QgXHUwMDI2IFNWTEhXQ0QiLCAiZGF0ZV90aW1lIjogIjIwMjAtMDMtMjRUMDc6NDU6MDAuMDAwIiwgImRpdiI6ICIxIiwgImR3cl9hYmJyZXYiOiAiREFWRE9XQ08iLCAiZmxhZyI6IG51bGwsICJodHRwX2xpbmthZ2UudXJsIjogImh0dHBzOi8vZHdyLnN0YXRlLmNvLnVzL1N1cmZhY2VXYXRlci9kYXRhL2RldGFpbF9ncmFwaC5hc3B4P0lEPURBVkRPV0NPXHUwMDI2TVRZUEU9RElTQ0hSRyIsICJsb2NhdGlvbi5sYXRpdHVkZSI6IDQwLjE4MTg4LCAibG9jYXRpb24ubG9uZ2l0dWRlIjogLTEwNS4xOTY3NzUsICJsb2NhdGlvbi5uZWVkc19yZWNvZGluZyI6IGZhbHNlLCAic3RhZ2UiOiBudWxsLCAic3RhdGlvbl9uYW1lIjogIkRBVklTIEFORCBET1dOSU5HIERJVENIIiwgInN0YXRpb25fc3RhdHVzIjogIkFjdGl2ZSIsICJzdGF0aW9uX3R5cGUiOiAiRGl2ZXJzaW9uIiwgInVzZ3Nfc3RhdGlvbl9pZCI6IG51bGwsICJ2YXJpYWJsZSI6ICJESVNDSFJHIiwgIndkIjogIjUifSwgInR5cGUiOiAiRmVhdHVyZSJ9LCB7ImJib3giOiBbLTEwNS4zMjYyNSwgNDAuMDE4NjY3LCAtMTA1LjMyNjI1LCA0MC4wMTg2NjddLCAiZ2VvbWV0cnkiOiB7ImNvb3JkaW5hdGVzIjogWy0xMDUuMzI2MjUsIDQwLjAxODY2N10sICJ0eXBlIjogIlBvaW50In0sICJpZCI6ICIzOSIsICJwcm9wZXJ0aWVzIjogeyJhbW91bnQiOiAiMC43NCIsICJjb3VudHkiOiAiQk9VTERFUiIsICJkYXRhX3NvdXJjZSI6ICJVLlMuIEdlb2xvZ2ljYWwgU3VydmV5IiwgImRhdGVfdGltZSI6ICIyMDE5LTEwLTAyVDE0OjUwOjAwLjAwMCIsICJkaXYiOiAiMSIsICJkd3JfYWJicmV2IjogIkZPVU9ST0NPIiwgImZsYWciOiBudWxsLCAiaHR0cF9saW5rYWdlLnVybCI6ICJodHRwczovL3dhdGVyZGF0YS51c2dzLmdvdi9ud2lzL3V2PzA2NzI3NTAwIiwgImxvY2F0aW9uLmxhdGl0dWRlIjogNDAuMDE4NjY3LCAibG9jYXRpb24ubG9uZ2l0dWRlIjogLTEwNS4zMjYyNSwgImxvY2F0aW9uLm5lZWRzX3JlY29kaW5nIjogZmFsc2UsICJzdGFnZSI6IG51bGwsICJzdGF0aW9uX25hbWUiOiAiRk9VUk1JTEUgQ1JFRUsgQVQgT1JPREVMTCwgQ08iLCAic3RhdGlvbl9zdGF0dXMiOiAiQWN0aXZlIiwgInN0YXRpb25fdHlwZSI6ICJTdHJlYW0iLCAidXNnc19zdGF0aW9uX2lkIjogIjA2NzI3NTAwIiwgInZhcmlhYmxlIjogIkRJU0NIUkciLCAid2QiOiAiNiJ9LCAidHlwZSI6ICJGZWF0dXJlIn0sIHsiYmJveCI6IFstMTA1LjIwOTI4MiwgNDAuMTg4NTc5LCAtMTA1LjIwOTI4MiwgNDAuMTg4NTc5XSwgImdlb21ldHJ5IjogeyJjb29yZGluYXRlcyI6IFstMTA1LjIwOTI4MiwgNDAuMTg4NTc5XSwgInR5cGUiOiAiUG9pbnQifSwgImlkIjogIjQwIiwgInByb3BlcnRpZXMiOiB7ImFtb3VudCI6ICIwLjEyIiwgImNvdW50eSI6ICJCT1VMREVSIiwgImRhdGFfc291cmNlIjogIkNvb3BlcmF0aXZlIFByb2dyYW0gb2YgQ0RXUiwgTkNXQ0QgXHUwMDI2IFNWTEhXQ0QiLCAiZGF0ZV90aW1lIjogIjIwMjAtMDMtMjRUMDc6NDU6MDAuMDAwIiwgImRpdiI6ICIxIiwgImR3cl9hYmJyZXYiOiAiSkFNRElUQ08iLCAiZmxhZyI6IG51bGwsICJodHRwX2xpbmthZ2UudXJsIjogImh0dHBzOi8vZHdyLnN0YXRlLmNvLnVzL1N1cmZhY2VXYXRlci9kYXRhL2RldGFpbF9ncmFwaC5hc3B4P0lEPUpBTURJVENPXHUwMDI2TVRZUEU9RElTQ0hSRyIsICJsb2NhdGlvbi5sYXRpdHVkZSI6IDQwLjE4ODU3OSwgImxvY2F0aW9uLmxvbmdpdHVkZSI6IC0xMDUuMjA5MjgyLCAibG9jYXRpb24ubmVlZHNfcmVjb2RpbmciOiBmYWxzZSwgInN0YWdlIjogIjAuMDQiLCAic3RhdGlvbl9uYW1lIjogIkpBTUVTIERJVENIIiwgInN0YXRpb25fc3RhdHVzIjogIkFjdGl2ZSIsICJzdGF0aW9uX3R5cGUiOiAiRGl2ZXJzaW9uIiwgInVzZ3Nfc3RhdGlvbl9pZCI6IG51bGwsICJ2YXJpYWJsZSI6ICJESVNDSFJHIiwgIndkIjogIjUifSwgInR5cGUiOiAiRmVhdHVyZSJ9LCB7ImJib3giOiBbLTEwNS4xOTMwNDgsIDQwLjA1MzAzNSwgLTEwNS4xOTMwNDgsIDQwLjA1MzAzNV0sICJnZW9tZXRyeSI6IHsiY29vcmRpbmF0ZXMiOiBbLTEwNS4xOTMwNDgsIDQwLjA1MzAzNV0sICJ0eXBlIjogIlBvaW50In0sICJpZCI6ICI0MSIsICJwcm9wZXJ0aWVzIjogeyJhbW91bnQiOiAiMC4wMCIsICJjb3VudHkiOiAiQk9VTERFUiIsICJkYXRhX3NvdXJjZSI6ICJOb3J0aGVybiBDb2xvcmFkbyBXYXRlciBDb25zZXJ2YW5jeSBEaXN0cmljdCIsICJkYXRlX3RpbWUiOiAiMjAyMC0wMy0yNFQwODowMDowMC4wMDAiLCAiZGl2IjogIjEiLCAiZHdyX2FiYnJldiI6ICJCQ1NDQkNDTyIsICJmbGFnIjogbnVsbCwgImh0dHBfbGlua2FnZS51cmwiOiAiaHR0cDovL3d3dy5ub3J0aGVybndhdGVyLm9yZy9XYXRlclByb2plY3RzL1dhdGVyRGF0YS5hc3B4RWFzdFNsb3BlV2F0ZXJEYXRhLmFzcHgiLCAibG9jYXRpb24ubGF0aXR1ZGUiOiA0MC4wNTMwMzUsICJsb2NhdGlvbi5sb25naXR1ZGUiOiAtMTA1LjE5MzA0OCwgImxvY2F0aW9uLm5lZWRzX3JlY29kaW5nIjogZmFsc2UsICJzdGFnZSI6ICIwLjAwIiwgInN0YXRpb25fbmFtZSI6ICJCT1VMREVSIENSRUVLIFNVUFBMWSBDQU5BTCBUTyBCT1VMREVSIENSRUVLIE5FQVIgQk9VTERFUiIsICJzdGF0aW9uX3N0YXR1cyI6ICJBY3RpdmUiLCAic3RhdGlvbl90eXBlIjogIkRpdmVyc2lvbiIsICJ1c2dzX3N0YXRpb25faWQiOiAiRVMxOTE3IiwgInZhcmlhYmxlIjogIkRJU0NIUkciLCAid2QiOiAiNiJ9LCAidHlwZSI6ICJGZWF0dXJlIn0sIHsiYmJveCI6IFstMTA1LjE3NDk1NywgNDAuMjU4MzY3LCAtMTA1LjE3NDk1NywgNDAuMjU4MzY3XSwgImdlb21ldHJ5IjogeyJjb29yZGluYXRlcyI6IFstMTA1LjE3NDk1NywgNDAuMjU4MzY3XSwgInR5cGUiOiAiUG9pbnQifSwgImlkIjogIjQyIiwgInByb3BlcnRpZXMiOiB7ImFtb3VudCI6ICIwLjAwIiwgImNvdW50eSI6ICJCT1VMREVSIiwgImRhdGFfc291cmNlIjogIkNvLiBEaXZpc2lvbiBvZiBXYXRlciBSZXNvdXJjZXMiLCAiZGF0ZV90aW1lIjogIjIwMjAtMDMtMjRUMDg6MzA6MDAuMDAwIiwgImRpdiI6ICIxIiwgImR3cl9hYmJyZXYiOiAiQk9VTEFSQ08iLCAiZmxhZyI6IG51bGwsICJodHRwX2xpbmthZ2UudXJsIjogImh0dHBzOi8vZHdyLnN0YXRlLmNvLnVzL1N1cmZhY2VXYXRlci9kYXRhL2RldGFpbF9ncmFwaC5hc3B4P0lEPUJPVUxBUkNPXHUwMDI2TVRZUEU9RElTQ0hSRyIsICJsb2NhdGlvbi5sYXRpdHVkZSI6IDQwLjI1ODM2NywgImxvY2F0aW9uLmxvbmdpdHVkZSI6IC0xMDUuMTc0OTU3LCAibG9jYXRpb24ubmVlZHNfcmVjb2RpbmciOiBmYWxzZSwgInN0YWdlIjogIi0wLjEyIiwgInN0YXRpb25fbmFtZSI6ICJCT1VMREVSLUxBUklNRVIgRElUQ0ggTkVBUiBCRVJUSE9VRCIsICJzdGF0aW9uX3N0YXR1cyI6ICJBY3RpdmUiLCAic3RhdGlvbl90eXBlIjogIkRpdmVyc2lvbiIsICJ1c2dzX3N0YXRpb25faWQiOiBudWxsLCAidmFyaWFibGUiOiAiRElTQ0hSRyIsICJ3ZCI6ICI0In0sICJ0eXBlIjogIkZlYXR1cmUifSwgeyJiYm94IjogWy0xMDUuMzQ3OTA2LCAzOS45MzgzNTEsIC0xMDUuMzQ3OTA2LCAzOS45MzgzNTFdLCAiZ2VvbWV0cnkiOiB7ImNvb3JkaW5hdGVzIjogWy0xMDUuMzQ3OTA2LCAzOS45MzgzNTFdLCAidHlwZSI6ICJQb2ludCJ9LCAiaWQiOiAiNDMiLCAicHJvcGVydGllcyI6IHsiYW1vdW50IjogIjE2LjQwIiwgImNvdW50eSI6ICJCT1VMREVSIiwgImRhdGFfc291cmNlIjogIkNvLiBEaXZpc2lvbiBvZiBXYXRlciBSZXNvdXJjZXMiLCAiZGF0ZV90aW1lIjogIjIwMjAtMDMtMjRUMDg6MTU6MDAuMDAwIiwgImRpdiI6ICIxIiwgImR3cl9hYmJyZXYiOiAiQk9DQkdSQ08iLCAiZmxhZyI6IG51bGwsICJodHRwX2xpbmthZ2UudXJsIjogImh0dHBzOi8vZHdyLnN0YXRlLmNvLnVzL1N1cmZhY2VXYXRlci9kYXRhL2RldGFpbF9ncmFwaC5hc3B4P0lEPUJPQ0JHUkNPXHUwMDI2TVRZUEU9RElTQ0hSRyIsICJsb2NhdGlvbi5sYXRpdHVkZSI6IDM5LjkzODM1MSwgImxvY2F0aW9uLmxvbmdpdHVkZSI6IC0xMDUuMzQ3OTA2LCAibG9jYXRpb24ubmVlZHNfcmVjb2RpbmciOiBmYWxzZSwgInN0YWdlIjogIjAuMzYiLCAic3RhdGlvbl9uYW1lIjogIlNPVVRIIEJPVUxERVIgQ1JFRUsgQkVMT1cgR1JPU1MgUkVTRVJWT0lSIiwgInN0YXRpb25fc3RhdHVzIjogIkFjdGl2ZSIsICJzdGF0aW9uX3R5cGUiOiAiU3RyZWFtIiwgInVzZ3Nfc3RhdGlvbl9pZCI6ICIwNjcyOTQ1MCIsICJ2YXJpYWJsZSI6ICJESVNDSFJHIiwgIndkIjogIjYifSwgInR5cGUiOiAiRmVhdHVyZSJ9LCB7ImJib3giOiBbLTEwNS4yNTE4MjYsIDQwLjIxMjUwNSwgLTEwNS4yNTE4MjYsIDQwLjIxMjUwNV0sICJnZW9tZXRyeSI6IHsiY29vcmRpbmF0ZXMiOiBbLTEwNS4yNTE4MjYsIDQwLjIxMjUwNV0sICJ0eXBlIjogIlBvaW50In0sICJpZCI6ICI0NCIsICJwcm9wZXJ0aWVzIjogeyJhbW91bnQiOiAiMC4yNyIsICJjb3VudHkiOiAiQk9VTERFUiIsICJkYXRhX3NvdXJjZSI6ICJDb29wZXJhdGl2ZSBQcm9ncmFtIG9mIENEV1IsIE5DV0NEIFx1MDAyNiBTVkxIV0NEIiwgImRhdGVfdGltZSI6ICIyMDIwLTAzLTI0VDA4OjAwOjAwLjAwMCIsICJkaXYiOiAiMSIsICJkd3JfYWJicmV2IjogIlBBTERJVENPIiwgImZsYWciOiBudWxsLCAiaHR0cF9saW5rYWdlLnVybCI6ICJodHRwczovL2R3ci5zdGF0ZS5jby51cy9TdXJmYWNlV2F0ZXIvZGF0YS9kZXRhaWxfZ3JhcGguYXNweD9JRD1QQUxESVRDT1x1MDAyNk1UWVBFPURJU0NIUkciLCAibG9jYXRpb24ubGF0aXR1ZGUiOiA0MC4yMTI1MDUsICJsb2NhdGlvbi5sb25naXR1ZGUiOiAtMTA1LjI1MTgyNiwgImxvY2F0aW9uLm5lZWRzX3JlY29kaW5nIjogZmFsc2UsICJzdGFnZSI6ICIwLjA1IiwgInN0YXRpb25fbmFtZSI6ICJQQUxNRVJUT04gRElUQ0giLCAic3RhdGlvbl9zdGF0dXMiOiAiQWN0aXZlIiwgInN0YXRpb25fdHlwZSI6ICJEaXZlcnNpb24iLCAidXNnc19zdGF0aW9uX2lkIjogbnVsbCwgInZhcmlhYmxlIjogIkRJU0NIUkciLCAid2QiOiAiNSJ9LCAidHlwZSI6ICJGZWF0dXJlIn0sIHsiYmJveCI6IFstMTA1LjI1OTc5NSwgNDAuMjE5MDQ2LCAtMTA1LjI1OTc5NSwgNDAuMjE5MDQ2XSwgImdlb21ldHJ5IjogeyJjb29yZGluYXRlcyI6IFstMTA1LjI1OTc5NSwgNDAuMjE5MDQ2XSwgInR5cGUiOiAiUG9pbnQifSwgImlkIjogIjQ1IiwgInByb3BlcnRpZXMiOiB7ImFtb3VudCI6ICIwLjAwIiwgImNvdW50eSI6ICJCT1VMREVSIiwgImRhdGFfc291cmNlIjogIkNvb3BlcmF0aXZlIFByb2dyYW0gb2YgQ0RXUiwgTkNXQ0QgXHUwMDI2IFNWTEhXQ0QiLCAiZGF0ZV90aW1lIjogIjIwMjAtMDMtMjRUMDc6NDU6MDAuMDAwIiwgImRpdiI6ICIxIiwgImR3cl9hYmJyZXYiOiAiU1VQRElUQ08iLCAiZmxhZyI6IG51bGwsICJodHRwX2xpbmthZ2UudXJsIjogImh0dHBzOi8vZHdyLnN0YXRlLmNvLnVzL1N1cmZhY2VXYXRlci9kYXRhL2RldGFpbF9ncmFwaC5hc3B4P0lEPVNVUERJVENPXHUwMDI2TVRZUEU9RElTQ0hSRyIsICJsb2NhdGlvbi5sYXRpdHVkZSI6IDQwLjIxOTA0NiwgImxvY2F0aW9uLmxvbmdpdHVkZSI6IC0xMDUuMjU5Nzk1LCAibG9jYXRpb24ubmVlZHNfcmVjb2RpbmciOiBmYWxzZSwgInN0YWdlIjogIjAuMDAiLCAic3RhdGlvbl9uYW1lIjogIlNVUFBMWSBESVRDSCIsICJzdGF0aW9uX3N0YXR1cyI6ICJBY3RpdmUiLCAic3RhdGlvbl90eXBlIjogIkRpdmVyc2lvbiIsICJ1c2dzX3N0YXRpb25faWQiOiBudWxsLCAidmFyaWFibGUiOiAiRElTQ0hSRyIsICJ3ZCI6ICI1In0sICJ0eXBlIjogIkZlYXR1cmUifSwgeyJiYm94IjogWy0xMDUuMTg5MTkxLCA0MC4xODc1NzgsIC0xMDUuMTg5MTkxLCA0MC4xODc1NzhdLCAiZ2VvbWV0cnkiOiB7ImNvb3JkaW5hdGVzIjogWy0xMDUuMTg5MTkxLCA0MC4xODc1NzhdLCAidHlwZSI6ICJQb2ludCJ9LCAiaWQiOiAiNDYiLCAicHJvcGVydGllcyI6IHsiYW1vdW50IjogIjI4MTkuNjgiLCAiY291bnR5IjogIkJPVUxERVIiLCAiZGF0YV9zb3VyY2UiOiAiQ29vcGVyYXRpdmUgUHJvZ3JhbSBvZiBDRFdSLCBOQ1dDRCBcdTAwMjYgU1ZMSFdDRCIsICJkYXRlX3RpbWUiOiAiMjAyMC0wMy0yNFQwODowMDowMC4wMDAiLCAiZGl2IjogIjEiLCAiZHdyX2FiYnJldiI6ICJERU5UQVlDTyIsICJmbGFnIjogbnVsbCwgImh0dHBfbGlua2FnZS51cmwiOiAiaHR0cHM6Ly9kd3Iuc3RhdGUuY28udXMvU3VyZmFjZVdhdGVyL2RhdGEvZGV0YWlsX2dyYXBoLmFzcHg/SUQ9REVOVEFZQ09cdTAwMjZNVFlQRT1ESVNDSFJHIiwgImxvY2F0aW9uLmxhdGl0dWRlIjogNDAuMTg3NTc4LCAibG9jYXRpb24ubG9uZ2l0dWRlIjogLTEwNS4xODkxOTEsICJsb2NhdGlvbi5uZWVkc19yZWNvZGluZyI6IGZhbHNlLCAic3RhZ2UiOiAiNjIuMzEiLCAic3RhdGlvbl9uYW1lIjogIkRFTklPIFRBWUxPUiBESVRDSCIsICJzdGF0aW9uX3N0YXR1cyI6ICJBY3RpdmUiLCAic3RhdGlvbl90eXBlIjogIkRpdmVyc2lvbiIsICJ1c2dzX3N0YXRpb25faWQiOiBudWxsLCAidmFyaWFibGUiOiAiRElTQ0hSRyIsICJ3ZCI6ICI1In0sICJ0eXBlIjogIkZlYXR1cmUifSwgeyJiYm94IjogWy0xMDUuMzY0OTE3MDAwMDAwMDIsIDQwLjA0MjAyOCwgLTEwNS4zNjQ5MTcwMDAwMDAwMiwgNDAuMDQyMDI4XSwgImdlb21ldHJ5IjogeyJjb29yZGluYXRlcyI6IFstMTA1LjM2NDkxNzAwMDAwMDAyLCA0MC4wNDIwMjhdLCAidHlwZSI6ICJQb2ludCJ9LCAiaWQiOiAiNDciLCAicHJvcGVydGllcyI6IHsiYW1vdW50IjogbnVsbCwgImNvdW50eSI6ICJCT1VMREVSIiwgImRhdGFfc291cmNlIjogIlUuUy4gR2VvbG9naWNhbCBTdXJ2ZXkiLCAiZGF0ZV90aW1lIjogIjE5OTktMDktMzBUMDA6MDA6MDAuMDAwIiwgImRpdiI6ICIxIiwgImR3cl9hYmJyZXYiOiAiRlJNTE1SQ08iLCAiZmxhZyI6IG51bGwsICJodHRwX2xpbmthZ2UudXJsIjogImh0dHBzOi8vd2F0ZXJkYXRhLnVzZ3MuZ292L253aXMvdXY/MDY3Mjc0MTAiLCAibG9jYXRpb24ubGF0aXR1ZGUiOiA0MC4wNDIwMjgsICJsb2NhdGlvbi5sb25naXR1ZGUiOiAtMTA1LjM2NDkxNywgImxvY2F0aW9uLm5lZWRzX3JlY29kaW5nIjogZmFsc2UsICJzdGFnZSI6IG51bGwsICJzdGF0aW9uX25hbWUiOiAiRk9VUk1JTEUgQ1JFRUsgQVQgTE9HQU4gTUlMTCBST0FEIE5FQVIgQ1JJU01BTiwgQ08iLCAic3RhdGlvbl9zdGF0dXMiOiAiQWN0aXZlIiwgInN0YXRpb25fdHlwZSI6ICJTdHJlYW0iLCAidXNnc19zdGF0aW9uX2lkIjogIjA2NzI3NDEwIiwgInZhcmlhYmxlIjogIkRJU0NIUkciLCAid2QiOiAiNiJ9LCAidHlwZSI6ICJGZWF0dXJlIn0sIHsiYmJveCI6IFstMTA1LjE3ODU2NywgNDAuMTc3MDgwMDAwMDAwMDA0LCAtMTA1LjE3ODU2NywgNDAuMTc3MDgwMDAwMDAwMDA0XSwgImdlb21ldHJ5IjogeyJjb29yZGluYXRlcyI6IFstMTA1LjE3ODU2NywgNDAuMTc3MDgwMDAwMDAwMDA0XSwgInR5cGUiOiAiUG9pbnQifSwgImlkIjogIjQ4IiwgInByb3BlcnRpZXMiOiB7ImFtb3VudCI6ICIxLjQyIiwgImNvdW50eSI6ICJCT1VMREVSIiwgImRhdGFfc291cmNlIjogIkNvb3BlcmF0aXZlIFNEUiBQcm9ncmFtIG9mIENEV1IgXHUwMDI2IE5DV0NEIiwgImRhdGVfdGltZSI6ICIyMDIwLTAzLTI0VDA4OjAwOjAwLjAwMCIsICJkaXYiOiAiMSIsICJkd3JfYWJicmV2IjogIlBDS1BFTENPIiwgImZsYWciOiBudWxsLCAiaHR0cF9saW5rYWdlLnVybCI6ICJodHRwczovL2R3ci5zdGF0ZS5jby51cy9TdXJmYWNlV2F0ZXIvZGF0YS9kZXRhaWxfZ3JhcGguYXNweD9JRD1QQ0tQRUxDT1x1MDAyNk1UWVBFPURJU0NIUkciLCAibG9jYXRpb24ubGF0aXR1ZGUiOiA0MC4xNzcwOCwgImxvY2F0aW9uLmxvbmdpdHVkZSI6IC0xMDUuMTc4NTY3LCAibG9jYXRpb24ubmVlZHNfcmVjb2RpbmciOiBmYWxzZSwgInN0YWdlIjogIjAuMTciLCAic3RhdGlvbl9uYW1lIjogIlBFQ0sgUEVMTEEgQ0xPVkVSIERJVENIIiwgInN0YXRpb25fc3RhdHVzIjogIkFjdGl2ZSIsICJzdGF0aW9uX3R5cGUiOiAiRGl2ZXJzaW9uIiwgInVzZ3Nfc3RhdGlvbl9pZCI6IG51bGwsICJ2YXJpYWJsZSI6ICJESVNDSFJHIiwgIndkIjogIjUifSwgInR5cGUiOiAiRmVhdHVyZSJ9LCB7ImJib3giOiBbLTEwNS4zNTczMDgsIDM5Ljk0NzcwNCwgLTEwNS4zNTczMDgsIDM5Ljk0NzcwNF0sICJnZW9tZXRyeSI6IHsiY29vcmRpbmF0ZXMiOiBbLTEwNS4zNTczMDgsIDM5Ljk0NzcwNF0sICJ0eXBlIjogIlBvaW50In0sICJpZCI6ICI0OSIsICJwcm9wZXJ0aWVzIjogeyJhbW91bnQiOiAiMTEzNjguMDAiLCAiY291bnR5IjogIkJPVUxERVIiLCAiZGF0YV9zb3VyY2UiOiAiQ28uIERpdmlzaW9uIG9mIFdhdGVyIFJlc291cmNlcyIsICJkYXRlX3RpbWUiOiAiMjAyMC0wMy0yNFQwODozMDowMC4wMDAiLCAiZGl2IjogIjEiLCAiZHdyX2FiYnJldiI6ICJHUk9TUkVDTyIsICJmbGFnIjogbnVsbCwgImh0dHBfbGlua2FnZS51cmwiOiAiaHR0cHM6Ly9kd3Iuc3RhdGUuY28udXMvU3VyZmFjZVdhdGVyL2RhdGEvZGV0YWlsX2dyYXBoLmFzcHg/SUQ9R1JPU1JFQ09cdTAwMjZNVFlQRT1TVE9SQUdFIiwgImxvY2F0aW9uLmxhdGl0dWRlIjogMzkuOTQ3NzA0LCAibG9jYXRpb24ubG9uZ2l0dWRlIjogLTEwNS4zNTczMDgsICJsb2NhdGlvbi5uZWVkc19yZWNvZGluZyI6IGZhbHNlLCAic3RhZ2UiOiAiNzE3NS42MiIsICJzdGF0aW9uX25hbWUiOiAiR1JPU1MgUkVTRVJWT0lSICIsICJzdGF0aW9uX3N0YXR1cyI6ICJBY3RpdmUiLCAic3RhdGlvbl90eXBlIjogIlJlc2Vydm9pciIsICJ1c2dzX3N0YXRpb25faWQiOiBudWxsLCAidmFyaWFibGUiOiAiU1RPUkFHRSIsICJ3ZCI6ICI2In0sICJ0eXBlIjogIkZlYXR1cmUifV0sICJ0eXBlIjogIkZlYXR1cmVDb2xsZWN0aW9uIn0pOwogICAgICAgIAo8L3NjcmlwdD4=" style="position:absolute;width:100%;height:100%;left:0;top:0;border:none !important;" allowfullscreen webkitallowfullscreen mozallowfullscreen></iframe></div></div>





Great! You now have an interactive map in your notebook! 

You can also cluster the markers, and add a popup to each marker, so you can give your viewers more information about station: such as its name and the amount of precipitation measured.

For this example below, you will work with the `Pandas DataFrame` you originally created from the `JSON`, instead of the `Geopandas GeoDataFrame`.

{:.input}
```python
# Get the latitude and longitude from result as a list
locations = result[['location.latitude', 'location.longitude']]
coords = locations.values.tolist()
```

{:.input}
```python
from folium.plugins import MarkerCluster

m = folium.Map([40.01, -105.27], zoom_start= 10, tiles='cartodbpositron')

marker_cluster = MarkerCluster().add_to(m)

for point in range(0, len(coords)):
    folium.Marker(location = coords[point], popup= 'Name: ' + result['station_name'][point] + ' ' + 'Precip: ' + str(result['amount'][point])).add_to(marker_cluster)

m
```

{:.output}
{:.execute_result}



<div style="width:100%;"><div style="position:relative;width:100%;height:0;padding-bottom:60%;"><iframe src="data:text/html;charset=utf-8;base64,PCFET0NUWVBFIGh0bWw+CjxoZWFkPiAgICAKICAgIDxtZXRhIGh0dHAtZXF1aXY9ImNvbnRlbnQtdHlwZSIgY29udGVudD0idGV4dC9odG1sOyBjaGFyc2V0PVVURi04IiAvPgogICAgCiAgICAgICAgPHNjcmlwdD4KICAgICAgICAgICAgTF9OT19UT1VDSCA9IGZhbHNlOwogICAgICAgICAgICBMX0RJU0FCTEVfM0QgPSBmYWxzZTsKICAgICAgICA8L3NjcmlwdD4KICAgIAogICAgPHNjcmlwdCBzcmM9Imh0dHBzOi8vY2RuLmpzZGVsaXZyLm5ldC9ucG0vbGVhZmxldEAxLjUuMS9kaXN0L2xlYWZsZXQuanMiPjwvc2NyaXB0PgogICAgPHNjcmlwdCBzcmM9Imh0dHBzOi8vY29kZS5qcXVlcnkuY29tL2pxdWVyeS0xLjEyLjQubWluLmpzIj48L3NjcmlwdD4KICAgIDxzY3JpcHQgc3JjPSJodHRwczovL21heGNkbi5ib290c3RyYXBjZG4uY29tL2Jvb3RzdHJhcC8zLjIuMC9qcy9ib290c3RyYXAubWluLmpzIj48L3NjcmlwdD4KICAgIDxzY3JpcHQgc3JjPSJodHRwczovL2NkbmpzLmNsb3VkZmxhcmUuY29tL2FqYXgvbGlicy9MZWFmbGV0LmF3ZXNvbWUtbWFya2Vycy8yLjAuMi9sZWFmbGV0LmF3ZXNvbWUtbWFya2Vycy5qcyI+PC9zY3JpcHQ+CiAgICA8bGluayByZWw9InN0eWxlc2hlZXQiIGhyZWY9Imh0dHBzOi8vY2RuLmpzZGVsaXZyLm5ldC9ucG0vbGVhZmxldEAxLjUuMS9kaXN0L2xlYWZsZXQuY3NzIi8+CiAgICA8bGluayByZWw9InN0eWxlc2hlZXQiIGhyZWY9Imh0dHBzOi8vbWF4Y2RuLmJvb3RzdHJhcGNkbi5jb20vYm9vdHN0cmFwLzMuMi4wL2Nzcy9ib290c3RyYXAubWluLmNzcyIvPgogICAgPGxpbmsgcmVsPSJzdHlsZXNoZWV0IiBocmVmPSJodHRwczovL21heGNkbi5ib290c3RyYXBjZG4uY29tL2Jvb3RzdHJhcC8zLjIuMC9jc3MvYm9vdHN0cmFwLXRoZW1lLm1pbi5jc3MiLz4KICAgIDxsaW5rIHJlbD0ic3R5bGVzaGVldCIgaHJlZj0iaHR0cHM6Ly9tYXhjZG4uYm9vdHN0cmFwY2RuLmNvbS9mb250LWF3ZXNvbWUvNC42LjMvY3NzL2ZvbnQtYXdlc29tZS5taW4uY3NzIi8+CiAgICA8bGluayByZWw9InN0eWxlc2hlZXQiIGhyZWY9Imh0dHBzOi8vY2RuanMuY2xvdWRmbGFyZS5jb20vYWpheC9saWJzL0xlYWZsZXQuYXdlc29tZS1tYXJrZXJzLzIuMC4yL2xlYWZsZXQuYXdlc29tZS1tYXJrZXJzLmNzcyIvPgogICAgPGxpbmsgcmVsPSJzdHlsZXNoZWV0IiBocmVmPSJodHRwczovL3Jhd2Nkbi5naXRoYWNrLmNvbS9weXRob24tdmlzdWFsaXphdGlvbi9mb2xpdW0vbWFzdGVyL2ZvbGl1bS90ZW1wbGF0ZXMvbGVhZmxldC5hd2Vzb21lLnJvdGF0ZS5jc3MiLz4KICAgIDxzdHlsZT5odG1sLCBib2R5IHt3aWR0aDogMTAwJTtoZWlnaHQ6IDEwMCU7bWFyZ2luOiAwO3BhZGRpbmc6IDA7fTwvc3R5bGU+CiAgICA8c3R5bGU+I21hcCB7cG9zaXRpb246YWJzb2x1dGU7dG9wOjA7Ym90dG9tOjA7cmlnaHQ6MDtsZWZ0OjA7fTwvc3R5bGU+CiAgICAKICAgICAgICAgICAgPG1ldGEgbmFtZT0idmlld3BvcnQiIGNvbnRlbnQ9IndpZHRoPWRldmljZS13aWR0aCwKICAgICAgICAgICAgICAgIGluaXRpYWwtc2NhbGU9MS4wLCBtYXhpbXVtLXNjYWxlPTEuMCwgdXNlci1zY2FsYWJsZT1ubyIgLz4KICAgICAgICAgICAgPHN0eWxlPgogICAgICAgICAgICAgICAgI21hcF9hZjg3YjNiOWVmYzI0NGNhOGJlOTBjNWE2MjI1ZjVmOSB7CiAgICAgICAgICAgICAgICAgICAgcG9zaXRpb246IHJlbGF0aXZlOwogICAgICAgICAgICAgICAgICAgIHdpZHRoOiAxMDAuMCU7CiAgICAgICAgICAgICAgICAgICAgaGVpZ2h0OiAxMDAuMCU7CiAgICAgICAgICAgICAgICAgICAgbGVmdDogMC4wJTsKICAgICAgICAgICAgICAgICAgICB0b3A6IDAuMCU7CiAgICAgICAgICAgICAgICB9CiAgICAgICAgICAgIDwvc3R5bGU+CiAgICAgICAgCiAgICA8c2NyaXB0IHNyYz0iaHR0cHM6Ly9jZG5qcy5jbG91ZGZsYXJlLmNvbS9hamF4L2xpYnMvbGVhZmxldC5tYXJrZXJjbHVzdGVyLzEuMS4wL2xlYWZsZXQubWFya2VyY2x1c3Rlci5qcyI+PC9zY3JpcHQ+CiAgICA8bGluayByZWw9InN0eWxlc2hlZXQiIGhyZWY9Imh0dHBzOi8vY2RuanMuY2xvdWRmbGFyZS5jb20vYWpheC9saWJzL2xlYWZsZXQubWFya2VyY2x1c3Rlci8xLjEuMC9NYXJrZXJDbHVzdGVyLmNzcyIvPgogICAgPGxpbmsgcmVsPSJzdHlsZXNoZWV0IiBocmVmPSJodHRwczovL2NkbmpzLmNsb3VkZmxhcmUuY29tL2FqYXgvbGlicy9sZWFmbGV0Lm1hcmtlcmNsdXN0ZXIvMS4xLjAvTWFya2VyQ2x1c3Rlci5EZWZhdWx0LmNzcyIvPgo8L2hlYWQ+Cjxib2R5PiAgICAKICAgIAogICAgICAgICAgICA8ZGl2IGNsYXNzPSJmb2xpdW0tbWFwIiBpZD0ibWFwX2FmODdiM2I5ZWZjMjQ0Y2E4YmU5MGM1YTYyMjVmNWY5IiA+PC9kaXY+CiAgICAgICAgCjwvYm9keT4KPHNjcmlwdD4gICAgCiAgICAKICAgICAgICAgICAgdmFyIG1hcF9hZjg3YjNiOWVmYzI0NGNhOGJlOTBjNWE2MjI1ZjVmOSA9IEwubWFwKAogICAgICAgICAgICAgICAgIm1hcF9hZjg3YjNiOWVmYzI0NGNhOGJlOTBjNWE2MjI1ZjVmOSIsCiAgICAgICAgICAgICAgICB7CiAgICAgICAgICAgICAgICAgICAgY2VudGVyOiBbNDAuMDEsIC0xMDUuMjddLAogICAgICAgICAgICAgICAgICAgIGNyczogTC5DUlMuRVBTRzM4NTcsCiAgICAgICAgICAgICAgICAgICAgem9vbTogMTAsCiAgICAgICAgICAgICAgICAgICAgem9vbUNvbnRyb2w6IHRydWUsCiAgICAgICAgICAgICAgICAgICAgcHJlZmVyQ2FudmFzOiBmYWxzZSwKICAgICAgICAgICAgICAgIH0KICAgICAgICAgICAgKTsKCiAgICAgICAgICAgIAoKICAgICAgICAKICAgIAogICAgICAgICAgICB2YXIgdGlsZV9sYXllcl80MmQzMzY0ZGM5MjQ0ZjY3OTEyZmE0ZjU4ODkwYjM4YyA9IEwudGlsZUxheWVyKAogICAgICAgICAgICAgICAgImh0dHBzOi8vY2FydG9kYi1iYXNlbWFwcy17c30uZ2xvYmFsLnNzbC5mYXN0bHkubmV0L2xpZ2h0X2FsbC97en0ve3h9L3t5fS5wbmciLAogICAgICAgICAgICAgICAgeyJhdHRyaWJ1dGlvbiI6ICJcdTAwMjZjb3B5OyBcdTAwM2NhIGhyZWY9XCJodHRwOi8vd3d3Lm9wZW5zdHJlZXRtYXAub3JnL2NvcHlyaWdodFwiXHUwMDNlT3BlblN0cmVldE1hcFx1MDAzYy9hXHUwMDNlIGNvbnRyaWJ1dG9ycyBcdTAwMjZjb3B5OyBcdTAwM2NhIGhyZWY9XCJodHRwOi8vY2FydG9kYi5jb20vYXR0cmlidXRpb25zXCJcdTAwM2VDYXJ0b0RCXHUwMDNjL2FcdTAwM2UsIENhcnRvREIgXHUwMDNjYSBocmVmID1cImh0dHA6Ly9jYXJ0b2RiLmNvbS9hdHRyaWJ1dGlvbnNcIlx1MDAzZWF0dHJpYnV0aW9uc1x1MDAzYy9hXHUwMDNlIiwgImRldGVjdFJldGluYSI6IGZhbHNlLCAibWF4TmF0aXZlWm9vbSI6IDE4LCAibWF4Wm9vbSI6IDE4LCAibWluWm9vbSI6IDAsICJub1dyYXAiOiBmYWxzZSwgIm9wYWNpdHkiOiAxLCAic3ViZG9tYWlucyI6ICJhYmMiLCAidG1zIjogZmFsc2V9CiAgICAgICAgICAgICkuYWRkVG8obWFwX2FmODdiM2I5ZWZjMjQ0Y2E4YmU5MGM1YTYyMjVmNWY5KTsKICAgICAgICAKICAgIAogICAgICAgICAgICB2YXIgbWFya2VyX2NsdXN0ZXJfMmY4ZTQzYjA3NDMyNDM1ZTllZmRhYjIxOWFkMTBkNGYgPSBMLm1hcmtlckNsdXN0ZXJHcm91cCgKICAgICAgICAgICAgICAgIHt9CiAgICAgICAgICAgICk7CiAgICAgICAgICAgIG1hcF9hZjg3YjNiOWVmYzI0NGNhOGJlOTBjNWE2MjI1ZjVmOS5hZGRMYXllcihtYXJrZXJfY2x1c3Rlcl8yZjhlNDNiMDc0MzI0MzVlOWVmZGFiMjE5YWQxMGQ0Zik7CiAgICAgICAgCiAgICAKICAgICAgICAgICAgdmFyIG1hcmtlcl8xNmJlZWU3NThjMDA0ZDlkYTYzOWY2Njk3NWJmOGUwYSA9IEwubWFya2VyKAogICAgICAgICAgICAgICAgWzQwLjE4NTAzMywgLTEwNS4xODU3ODldLAogICAgICAgICAgICAgICAge30KICAgICAgICAgICAgKS5hZGRUbyhtYXJrZXJfY2x1c3Rlcl8yZjhlNDNiMDc0MzI0MzVlOWVmZGFiMjE5YWQxMGQ0Zik7CiAgICAgICAgCiAgICAKICAgICAgICB2YXIgcG9wdXBfMDJiYjQ2MmM1NzBiNDBhYTkwYjBhMzE3NDFjYzA0OTggPSBMLnBvcHVwKHsibWF4V2lkdGgiOiAiMTAwJSJ9KTsKCiAgICAgICAgCiAgICAgICAgICAgIHZhciBodG1sX2U4YTliOTQyNDYxZDQ1Y2Y5NDhhODg1ZWFmMGFlMzI5ID0gJChgPGRpdiBpZD0iaHRtbF9lOGE5Yjk0MjQ2MWQ0NWNmOTQ4YTg4NWVhZjBhZTMyOSIgc3R5bGU9IndpZHRoOiAxMDAuMCU7IGhlaWdodDogMTAwLjAlOyI+TmFtZTogWldFQ0sgQU5EIFRVUk5FUiBESVRDSCBQcmVjaXA6IDAuMTQ8L2Rpdj5gKVswXTsKICAgICAgICAgICAgcG9wdXBfMDJiYjQ2MmM1NzBiNDBhYTkwYjBhMzE3NDFjYzA0OTguc2V0Q29udGVudChodG1sX2U4YTliOTQyNDYxZDQ1Y2Y5NDhhODg1ZWFmMGFlMzI5KTsKICAgICAgICAKCiAgICAgICAgbWFya2VyXzE2YmVlZTc1OGMwMDRkOWRhNjM5ZjY2OTc1YmY4ZTBhLmJpbmRQb3B1cChwb3B1cF8wMmJiNDYyYzU3MGI0MGFhOTBiMGEzMTc0MWNjMDQ5OCkKICAgICAgICA7CgogICAgICAgIAogICAgCiAgICAKICAgICAgICAgICAgdmFyIG1hcmtlcl9jNmM3YjJlODhiODI0MDYwYjY4OGY3Njc5ZDNlYjgwOCA9IEwubWFya2VyKAogICAgICAgICAgICAgICAgWzQwLjIyMDcwMiwgLTEwNS4yNjM0OV0sCiAgICAgICAgICAgICAgICB7fQogICAgICAgICAgICApLmFkZFRvKG1hcmtlcl9jbHVzdGVyXzJmOGU0M2IwNzQzMjQzNWU5ZWZkYWIyMTlhZDEwZDRmKTsKICAgICAgICAKICAgIAogICAgICAgIHZhciBwb3B1cF9kOTJiMGMyNjlmZTQ0MDJjYjQzNmQ4MDUzYjM5OTc1NCA9IEwucG9wdXAoeyJtYXhXaWR0aCI6ICIxMDAlIn0pOwoKICAgICAgICAKICAgICAgICAgICAgdmFyIGh0bWxfMWYyNDAxNjc5MjJkNGFhNTg0Yjg1YzlmODE2MTM5YzkgPSAkKGA8ZGl2IGlkPSJodG1sXzFmMjQwMTY3OTIyZDRhYTU4NGI4NWM5ZjgxNjEzOWM5IiBzdHlsZT0id2lkdGg6IDEwMC4wJTsgaGVpZ2h0OiAxMDAuMCU7Ij5OYW1lOiBTQUlOVCBWUkFJTiBDUkVFSyBBVCBMWU9OUywgQ08gUHJlY2lwOiAzOS4yMDwvZGl2PmApWzBdOwogICAgICAgICAgICBwb3B1cF9kOTJiMGMyNjlmZTQ0MDJjYjQzNmQ4MDUzYjM5OTc1NC5zZXRDb250ZW50KGh0bWxfMWYyNDAxNjc5MjJkNGFhNTg0Yjg1YzlmODE2MTM5YzkpOwogICAgICAgIAoKICAgICAgICBtYXJrZXJfYzZjN2IyZTg4YjgyNDA2MGI2ODhmNzY3OWQzZWI4MDguYmluZFBvcHVwKHBvcHVwX2Q5MmIwYzI2OWZlNDQwMmNiNDM2ZDgwNTNiMzk5NzU0KQogICAgICAgIDsKCiAgICAgICAgCiAgICAKICAgIAogICAgICAgICAgICB2YXIgbWFya2VyXzQ1YWFlNDE3NWI2ZTQ4ZjFiMDVmNGVjZDI5YmZlMTliID0gTC5tYXJrZXIoCiAgICAgICAgICAgICAgICBbNDAuMTk2NDIyLCAtMTA1LjIwNjU5Ml0sCiAgICAgICAgICAgICAgICB7fQogICAgICAgICAgICApLmFkZFRvKG1hcmtlcl9jbHVzdGVyXzJmOGU0M2IwNzQzMjQzNWU5ZWZkYWIyMTlhZDEwZDRmKTsKICAgICAgICAKICAgIAogICAgICAgIHZhciBwb3B1cF84NTBlYmM2OTRkNjg0YzA3YWYzMDZjN2YzYWI0NjNiZCA9IEwucG9wdXAoeyJtYXhXaWR0aCI6ICIxMDAlIn0pOwoKICAgICAgICAKICAgICAgICAgICAgdmFyIGh0bWxfNTZlYWQ1Y2UwYmFlNGQyZjhiYjdjMmZhMDY2NjZhMTIgPSAkKGA8ZGl2IGlkPSJodG1sXzU2ZWFkNWNlMGJhZTRkMmY4YmI3YzJmYTA2NjY2YTEyIiBzdHlsZT0id2lkdGg6IDEwMC4wJTsgaGVpZ2h0OiAxMDAuMCU7Ij5OYW1lOiBPTElHQVJDSFkgRElUQ0ggRElWRVJTSU9OIFByZWNpcDogNC4wMTwvZGl2PmApWzBdOwogICAgICAgICAgICBwb3B1cF84NTBlYmM2OTRkNjg0YzA3YWYzMDZjN2YzYWI0NjNiZC5zZXRDb250ZW50KGh0bWxfNTZlYWQ1Y2UwYmFlNGQyZjhiYjdjMmZhMDY2NjZhMTIpOwogICAgICAgIAoKICAgICAgICBtYXJrZXJfNDVhYWU0MTc1YjZlNDhmMWIwNWY0ZWNkMjliZmUxOWIuYmluZFBvcHVwKHBvcHVwXzg1MGViYzY5NGQ2ODRjMDdhZjMwNmM3ZjNhYjQ2M2JkKQogICAgICAgIDsKCiAgICAgICAgCiAgICAKICAgIAogICAgICAgICAgICB2YXIgbWFya2VyXzcwNzNhMjFiNTdhNzQ3ODc4NjA5M2VmYzlkNzkwOTU1ID0gTC5tYXJrZXIoCiAgICAgICAgICAgICAgICBbMzkuOTMxODEzLCAtMTA1LjMwODQzMl0sCiAgICAgICAgICAgICAgICB7fQogICAgICAgICAgICApLmFkZFRvKG1hcmtlcl9jbHVzdGVyXzJmOGU0M2IwNzQzMjQzNWU5ZWZkYWIyMTlhZDEwZDRmKTsKICAgICAgICAKICAgIAogICAgICAgIHZhciBwb3B1cF8xMDYzMzViYWZmYWY0NzRjYjRhNjQ3OTYwZmIxYWRmZSA9IEwucG9wdXAoeyJtYXhXaWR0aCI6ICIxMDAlIn0pOwoKICAgICAgICAKICAgICAgICAgICAgdmFyIGh0bWxfOTE2NzY4Y2Y0YjAxNGViOThkNWRmZmMxYjBhNGQ4YTUgPSAkKGA8ZGl2IGlkPSJodG1sXzkxNjc2OGNmNGIwMTRlYjk4ZDVkZmZjMWIwYTRkOGE1IiBzdHlsZT0id2lkdGg6IDEwMC4wJTsgaGVpZ2h0OiAxMDAuMCU7Ij5OYW1lOiBTT1VUSCBCT1VMREVSIENSRUVLIERJVkVSU0lPTiBORUFSIEVMRE9SQURPIFNQUklOR1MgUHJlY2lwOiAwLjAwPC9kaXY+YClbMF07CiAgICAgICAgICAgIHBvcHVwXzEwNjMzNWJhZmZhZjQ3NGNiNGE2NDc5NjBmYjFhZGZlLnNldENvbnRlbnQoaHRtbF85MTY3NjhjZjRiMDE0ZWI5OGQ1ZGZmYzFiMGE0ZDhhNSk7CiAgICAgICAgCgogICAgICAgIG1hcmtlcl83MDczYTIxYjU3YTc0Nzg3ODYwOTNlZmM5ZDc5MDk1NS5iaW5kUG9wdXAocG9wdXBfMTA2MzM1YmFmZmFmNDc0Y2I0YTY0Nzk2MGZiMWFkZmUpCiAgICAgICAgOwoKICAgICAgICAKICAgIAogICAgCiAgICAgICAgICAgIHZhciBtYXJrZXJfOTFhYjAyZDg1Y2I3NDgyYTkxNmZhN2I4NWUzNzBkMDYgPSBMLm1hcmtlcigKICAgICAgICAgICAgICAgIFs0MC4xOTM3NTgsIC0xMDUuMjEwMzldLAogICAgICAgICAgICAgICAge30KICAgICAgICAgICAgKS5hZGRUbyhtYXJrZXJfY2x1c3Rlcl8yZjhlNDNiMDc0MzI0MzVlOWVmZGFiMjE5YWQxMGQ0Zik7CiAgICAgICAgCiAgICAKICAgICAgICB2YXIgcG9wdXBfMThhODk0ZTI3ZGIwNGQ2ZTgzNGIxZGM1NDNkYTE1MWUgPSBMLnBvcHVwKHsibWF4V2lkdGgiOiAiMTAwJSJ9KTsKCiAgICAgICAgCiAgICAgICAgICAgIHZhciBodG1sX2I1NmY1ZTg3NmVkMjQ4ZWRiY2E5MjYwN2NjNzMxZDQzID0gJChgPGRpdiBpZD0iaHRtbF9iNTZmNWU4NzZlZDI0OGVkYmNhOTI2MDdjYzczMWQ0MyIgc3R5bGU9IndpZHRoOiAxMDAuMCU7IGhlaWdodDogMTAwLjAlOyI+TmFtZTogQ0xPVUdIIEFORCBUUlVFIERJVENIIFByZWNpcDogMC4wMDwvZGl2PmApWzBdOwogICAgICAgICAgICBwb3B1cF8xOGE4OTRlMjdkYjA0ZDZlODM0YjFkYzU0M2RhMTUxZS5zZXRDb250ZW50KGh0bWxfYjU2ZjVlODc2ZWQyNDhlZGJjYTkyNjA3Y2M3MzFkNDMpOwogICAgICAgIAoKICAgICAgICBtYXJrZXJfOTFhYjAyZDg1Y2I3NDgyYTkxNmZhN2I4NWUzNzBkMDYuYmluZFBvcHVwKHBvcHVwXzE4YTg5NGUyN2RiMDRkNmU4MzRiMWRjNTQzZGExNTFlKQogICAgICAgIDsKCiAgICAgICAgCiAgICAKICAgIAogICAgICAgICAgICB2YXIgbWFya2VyX2EwNmU4NzMzMTEzNTQ1ODI5ZGYwZjZkNGYyYWQ5ZTYzID0gTC5tYXJrZXIoCiAgICAgICAgICAgICAgICBbNDAuMDA2MzgsIC0xMDUuMzMwODQxXSwKICAgICAgICAgICAgICAgIHt9CiAgICAgICAgICAgICkuYWRkVG8obWFya2VyX2NsdXN0ZXJfMmY4ZTQzYjA3NDMyNDM1ZTllZmRhYjIxOWFkMTBkNGYpOwogICAgICAgIAogICAgCiAgICAgICAgdmFyIHBvcHVwXzhmMzY2MGM2N2FjODQxYmE4ODFiM2EzOTBkZDk1ODYzID0gTC5wb3B1cCh7Im1heFdpZHRoIjogIjEwMCUifSk7CgogICAgICAgIAogICAgICAgICAgICB2YXIgaHRtbF9iZDI5MmE1ZGZkMWY0ZTdmOGJmMDJhODNiMTRlZDIzYyA9ICQoYDxkaXYgaWQ9Imh0bWxfYmQyOTJhNWRmZDFmNGU3ZjhiZjAyYTgzYjE0ZWQyM2MiIHN0eWxlPSJ3aWR0aDogMTAwLjAlOyBoZWlnaHQ6IDEwMC4wJTsiPk5hbWU6IEJPVUxERVIgQ1JFRUsgTkVBUiBPUk9ERUxMLCBDTy4gUHJlY2lwOiAxOS42MDwvZGl2PmApWzBdOwogICAgICAgICAgICBwb3B1cF84ZjM2NjBjNjdhYzg0MWJhODgxYjNhMzkwZGQ5NTg2My5zZXRDb250ZW50KGh0bWxfYmQyOTJhNWRmZDFmNGU3ZjhiZjAyYTgzYjE0ZWQyM2MpOwogICAgICAgIAoKICAgICAgICBtYXJrZXJfYTA2ZTg3MzMxMTM1NDU4MjlkZjBmNmQ0ZjJhZDllNjMuYmluZFBvcHVwKHBvcHVwXzhmMzY2MGM2N2FjODQxYmE4ODFiM2EzOTBkZDk1ODYzKQogICAgICAgIDsKCiAgICAgICAgCiAgICAKICAgIAogICAgICAgICAgICB2YXIgbWFya2VyX2NlOGFiMGZkOGUxZjRlMDQ5OTczY2FkOGYzNWJmMzg1ID0gTC5tYXJrZXIoCiAgICAgICAgICAgICAgICBbNDAuMjA0MTkzLCAtMTA1LjIxODc3N10sCiAgICAgICAgICAgICAgICB7fQogICAgICAgICAgICApLmFkZFRvKG1hcmtlcl9jbHVzdGVyXzJmOGU0M2IwNzQzMjQzNWU5ZWZkYWIyMTlhZDEwZDRmKTsKICAgICAgICAKICAgIAogICAgICAgIHZhciBwb3B1cF9mY2ZhYWFhNzgwNmI0ODZkOTIzYThhOTgzMWU3ZTMzMSA9IEwucG9wdXAoeyJtYXhXaWR0aCI6ICIxMDAlIn0pOwoKICAgICAgICAKICAgICAgICAgICAgdmFyIGh0bWxfYmFhZWU1NjUzYmUyNGQxNWJjMGRmOTEzMWEzM2M0MTMgPSAkKGA8ZGl2IGlkPSJodG1sX2JhYWVlNTY1M2JlMjRkMTViYzBkZjkxMzFhMzNjNDEzIiBzdHlsZT0id2lkdGg6IDEwMC4wJTsgaGVpZ2h0OiAxMDAuMCU7Ij5OYW1lOiBMT05HTU9OVCBTVVBQTFkgRElUQ0ggUHJlY2lwOiAwLjAwPC9kaXY+YClbMF07CiAgICAgICAgICAgIHBvcHVwX2ZjZmFhYWE3ODA2YjQ4NmQ5MjNhOGE5ODMxZTdlMzMxLnNldENvbnRlbnQoaHRtbF9iYWFlZTU2NTNiZTI0ZDE1YmMwZGY5MTMxYTMzYzQxMyk7CiAgICAgICAgCgogICAgICAgIG1hcmtlcl9jZThhYjBmZDhlMWY0ZTA0OTk3M2NhZDhmMzViZjM4NS5iaW5kUG9wdXAocG9wdXBfZmNmYWFhYTc4MDZiNDg2ZDkyM2E4YTk4MzFlN2UzMzEpCiAgICAgICAgOwoKICAgICAgICAKICAgIAogICAgCiAgICAgICAgICAgIHZhciBtYXJrZXJfZTY3NTA3NWRhZWExNDBhYTk1NmRlNGRkZmRmZTc3NmIgPSBMLm1hcmtlcigKICAgICAgICAgICAgICAgIFs0MC4xNzI5MjUsIC0xMDUuMTY3NjIyXSwKICAgICAgICAgICAgICAgIHt9CiAgICAgICAgICAgICkuYWRkVG8obWFya2VyX2NsdXN0ZXJfMmY4ZTQzYjA3NDMyNDM1ZTllZmRhYjIxOWFkMTBkNGYpOwogICAgICAgIAogICAgCiAgICAgICAgdmFyIHBvcHVwX2I1MzdkNjY1OWMwMDRhY2I5MjZkMTI3NjI0Njc0ZWZjID0gTC5wb3B1cCh7Im1heFdpZHRoIjogIjEwMCUifSk7CgogICAgICAgIAogICAgICAgICAgICB2YXIgaHRtbF9hZWVlOGZlMDA0NjY0YTllOTQ4OWJiZGUyNGQyZmYwYyA9ICQoYDxkaXYgaWQ9Imh0bWxfYWVlZThmZTAwNDY2NGE5ZTk0ODliYmRlMjRkMmZmMGMiIHN0eWxlPSJ3aWR0aDogMTAwLjAlOyBoZWlnaHQ6IDEwMC4wJTsiPk5hbWU6IE5PUlRIV0VTVCBNVVRVQUwgRElUQ0ggUHJlY2lwOiAwLjAwPC9kaXY+YClbMF07CiAgICAgICAgICAgIHBvcHVwX2I1MzdkNjY1OWMwMDRhY2I5MjZkMTI3NjI0Njc0ZWZjLnNldENvbnRlbnQoaHRtbF9hZWVlOGZlMDA0NjY0YTllOTQ4OWJiZGUyNGQyZmYwYyk7CiAgICAgICAgCgogICAgICAgIG1hcmtlcl9lNjc1MDc1ZGFlYTE0MGFhOTU2ZGU0ZGRmZGZlNzc2Yi5iaW5kUG9wdXAocG9wdXBfYjUzN2Q2NjU5YzAwNGFjYjkyNmQxMjc2MjQ2NzRlZmMpCiAgICAgICAgOwoKICAgICAgICAKICAgIAogICAgCiAgICAgICAgICAgIHZhciBtYXJrZXJfOWU1NWE0OTlkNTAxNDEyYmE2MDUxZTRhNDgxM2JlZDQgPSBMLm1hcmtlcigKICAgICAgICAgICAgICAgIFs0MC4xMzQyNzgsIC0xMDUuMTMwODE5XSwKICAgICAgICAgICAgICAgIHt9CiAgICAgICAgICAgICkuYWRkVG8obWFya2VyX2NsdXN0ZXJfMmY4ZTQzYjA3NDMyNDM1ZTllZmRhYjIxOWFkMTBkNGYpOwogICAgICAgIAogICAgCiAgICAgICAgdmFyIHBvcHVwXzQwOWQ5ZmY0MzNiNzQxZmNhY2IwYzMwNGViYWY5MDlhID0gTC5wb3B1cCh7Im1heFdpZHRoIjogIjEwMCUifSk7CgogICAgICAgIAogICAgICAgICAgICB2YXIgaHRtbF81OTBjNTUxMjIxMDM0NzIxYTlkOGVlZWMzZjUzZjFjNiA9ICQoYDxkaXYgaWQ9Imh0bWxfNTkwYzU1MTIyMTAzNDcyMWE5ZDhlZWVjM2Y1M2YxYzYiIHN0eWxlPSJ3aWR0aDogMTAwLjAlOyBoZWlnaHQ6IDEwMC4wJTsiPk5hbWU6IExFRlQgSEFORCBDUkVFSyBBVCBIT1ZFUiBST0FEIE5FQVIgTE9OR01PTlQsIENPIFByZWNpcDogMy42MTwvZGl2PmApWzBdOwogICAgICAgICAgICBwb3B1cF80MDlkOWZmNDMzYjc0MWZjYWNiMGMzMDRlYmFmOTA5YS5zZXRDb250ZW50KGh0bWxfNTkwYzU1MTIyMTAzNDcyMWE5ZDhlZWVjM2Y1M2YxYzYpOwogICAgICAgIAoKICAgICAgICBtYXJrZXJfOWU1NWE0OTlkNTAxNDEyYmE2MDUxZTRhNDgxM2JlZDQuYmluZFBvcHVwKHBvcHVwXzQwOWQ5ZmY0MzNiNzQxZmNhY2IwYzMwNGViYWY5MDlhKQogICAgICAgIDsKCiAgICAgICAgCiAgICAKICAgIAogICAgICAgICAgICB2YXIgbWFya2VyXzhlZTAzZDA4NjM3NzRmNWRhZDE2YzY4YmVmNDFmZmUwID0gTC5tYXJrZXIoCiAgICAgICAgICAgICAgICBbMzkuOTg2MTY5LCAtMTA1LjIxODY3N10sCiAgICAgICAgICAgICAgICB7fQogICAgICAgICAgICApLmFkZFRvKG1hcmtlcl9jbHVzdGVyXzJmOGU0M2IwNzQzMjQzNWU5ZWZkYWIyMTlhZDEwZDRmKTsKICAgICAgICAKICAgIAogICAgICAgIHZhciBwb3B1cF8zNmEwMGYxOGZmZjM0ZjAxOTJiZDBhOTY4OWE3ODc1ZCA9IEwucG9wdXAoeyJtYXhXaWR0aCI6ICIxMDAlIn0pOwoKICAgICAgICAKICAgICAgICAgICAgdmFyIGh0bWxfZDkxMTUwMjk5MDgwNDJjYjkwMzZmZjNiMmUzZTA1Y2UgPSAkKGA8ZGl2IGlkPSJodG1sX2Q5MTE1MDI5OTA4MDQyY2I5MDM2ZmYzYjJlM2UwNWNlIiBzdHlsZT0id2lkdGg6IDEwMC4wJTsgaGVpZ2h0OiAxMDAuMCU7Ij5OYW1lOiBEUlkgQ1JFRUsgQ0FSUklFUiBQcmVjaXA6IDAuMDA8L2Rpdj5gKVswXTsKICAgICAgICAgICAgcG9wdXBfMzZhMDBmMThmZmYzNGYwMTkyYmQwYTk2ODlhNzg3NWQuc2V0Q29udGVudChodG1sX2Q5MTE1MDI5OTA4MDQyY2I5MDM2ZmYzYjJlM2UwNWNlKTsKICAgICAgICAKCiAgICAgICAgbWFya2VyXzhlZTAzZDA4NjM3NzRmNWRhZDE2YzY4YmVmNDFmZmUwLmJpbmRQb3B1cChwb3B1cF8zNmEwMGYxOGZmZjM0ZjAxOTJiZDBhOTY4OWE3ODc1ZCkKICAgICAgICA7CgogICAgICAgIAogICAgCiAgICAKICAgICAgICAgICAgdmFyIG1hcmtlcl80NjZiNGEzNjJiNDA0YmNhYjdjZDY5MmI1OGZkM2E1OCA9IEwubWFya2VyKAogICAgICAgICAgICAgICAgWzQwLjE2MDcwNSwgLTEwNS4xNjg0NzFdLAogICAgICAgICAgICAgICAge30KICAgICAgICAgICAgKS5hZGRUbyhtYXJrZXJfY2x1c3Rlcl8yZjhlNDNiMDc0MzI0MzVlOWVmZGFiMjE5YWQxMGQ0Zik7CiAgICAgICAgCiAgICAKICAgICAgICB2YXIgcG9wdXBfM2NhZmJiN2RlMjE5NDMwYmEyY2I5ZGJjM2ZhYTc4MjcgPSBMLnBvcHVwKHsibWF4V2lkdGgiOiAiMTAwJSJ9KTsKCiAgICAgICAgCiAgICAgICAgICAgIHZhciBodG1sX2M3ZTZiMGMyYTIxODRmYmI4OWJmNGFmODliYjE3MzQ5ID0gJChgPGRpdiBpZD0iaHRtbF9jN2U2YjBjMmEyMTg0ZmJiODliZjRhZjg5YmIxNzM0OSIgc3R5bGU9IndpZHRoOiAxMDAuMCU7IGhlaWdodDogMTAwLjAlOyI+TmFtZTogUEVDSy1QRUxMQSBBVUdNRU5UQVRJT04gUkVUVVJOIFByZWNpcDogMC4wMDwvZGl2PmApWzBdOwogICAgICAgICAgICBwb3B1cF8zY2FmYmI3ZGUyMTk0MzBiYTJjYjlkYmMzZmFhNzgyNy5zZXRDb250ZW50KGh0bWxfYzdlNmIwYzJhMjE4NGZiYjg5YmY0YWY4OWJiMTczNDkpOwogICAgICAgIAoKICAgICAgICBtYXJrZXJfNDY2YjRhMzYyYjQwNGJjYWI3Y2Q2OTJiNThmZDNhNTguYmluZFBvcHVwKHBvcHVwXzNjYWZiYjdkZTIxOTQzMGJhMmNiOWRiYzNmYWE3ODI3KQogICAgICAgIDsKCiAgICAgICAgCiAgICAKICAgIAogICAgICAgICAgICB2YXIgbWFya2VyX2Y4MGUyNGFmNzk2NzQ3M2ViYzNjNjI2ZGZjNDQzMTM5ID0gTC5tYXJrZXIoCiAgICAgICAgICAgICAgICBbNDAuMTk5MzIxLCAtMTA1LjIyMjYzOV0sCiAgICAgICAgICAgICAgICB7fQogICAgICAgICAgICApLmFkZFRvKG1hcmtlcl9jbHVzdGVyXzJmOGU0M2IwNzQzMjQzNWU5ZWZkYWIyMTlhZDEwZDRmKTsKICAgICAgICAKICAgIAogICAgICAgIHZhciBwb3B1cF8xMTlhN2I5NzZlNTA0ZGViYjMwNGUwMDJmNWZlYzQ2MSA9IEwucG9wdXAoeyJtYXhXaWR0aCI6ICIxMDAlIn0pOwoKICAgICAgICAKICAgICAgICAgICAgdmFyIGh0bWxfYTFmMDBhMDI5NWIyNGIwOWEzNzk5YzY0MTFhZjZiNmMgPSAkKGA8ZGl2IGlkPSJodG1sX2ExZjAwYTAyOTViMjRiMDlhMzc5OWM2NDExYWY2YjZjIiBzdHlsZT0id2lkdGg6IDEwMC4wJTsgaGVpZ2h0OiAxMDAuMCU7Ij5OYW1lOiBHT1NTIERJVENIIDEgUHJlY2lwOiAwLjAwPC9kaXY+YClbMF07CiAgICAgICAgICAgIHBvcHVwXzExOWE3Yjk3NmU1MDRkZWJiMzA0ZTAwMmY1ZmVjNDYxLnNldENvbnRlbnQoaHRtbF9hMWYwMGEwMjk1YjI0YjA5YTM3OTljNjQxMWFmNmI2Yyk7CiAgICAgICAgCgogICAgICAgIG1hcmtlcl9mODBlMjRhZjc5Njc0NzNlYmMzYzYyNmRmYzQ0MzEzOS5iaW5kUG9wdXAocG9wdXBfMTE5YTdiOTc2ZTUwNGRlYmIzMDRlMDAyZjVmZWM0NjEpCiAgICAgICAgOwoKICAgICAgICAKICAgIAogICAgCiAgICAgICAgICAgIHZhciBtYXJrZXJfY2I3ZDJkN2VlNzU0NGYzODgwZjc2YzdhMDAyZjM0NjggPSBMLm1hcmtlcigKICAgICAgICAgICAgICAgIFs0MC4xOTMyOCwgLTEwNS4yMTA0MjRdLAogICAgICAgICAgICAgICAge30KICAgICAgICAgICAgKS5hZGRUbyhtYXJrZXJfY2x1c3Rlcl8yZjhlNDNiMDc0MzI0MzVlOWVmZGFiMjE5YWQxMGQ0Zik7CiAgICAgICAgCiAgICAKICAgICAgICB2YXIgcG9wdXBfMTM1MzJhMWIxNmVkNDUxY2JjN2Q4MzMxM2IwN2FjYTQgPSBMLnBvcHVwKHsibWF4V2lkdGgiOiAiMTAwJSJ9KTsKCiAgICAgICAgCiAgICAgICAgICAgIHZhciBodG1sXzU1NjY1NDg2MDc5ZTQ2NWE4YmVkZWUyNGZjN2QzZDdhID0gJChgPGRpdiBpZD0iaHRtbF81NTY2NTQ4NjA3OWU0NjVhOGJlZGVlMjRmYzdkM2Q3YSIgc3R5bGU9IndpZHRoOiAxMDAuMCU7IGhlaWdodDogMTAwLjAlOyI+TmFtZTogV0VCU1RFUiBNQ0NBU0xJTiBESVRDSCBQcmVjaXA6IDAuMDA8L2Rpdj5gKVswXTsKICAgICAgICAgICAgcG9wdXBfMTM1MzJhMWIxNmVkNDUxY2JjN2Q4MzMxM2IwN2FjYTQuc2V0Q29udGVudChodG1sXzU1NjY1NDg2MDc5ZTQ2NWE4YmVkZWUyNGZjN2QzZDdhKTsKICAgICAgICAKCiAgICAgICAgbWFya2VyX2NiN2QyZDdlZTc1NDRmMzg4MGY3NmM3YTAwMmYzNDY4LmJpbmRQb3B1cChwb3B1cF8xMzUzMmExYjE2ZWQ0NTFjYmM3ZDgzMzEzYjA3YWNhNCkKICAgICAgICA7CgogICAgICAgIAogICAgCiAgICAKICAgICAgICAgICAgdmFyIG1hcmtlcl9iNDFhZGRmMTRhMTE0NzMyYTQzMDNkOWYzZWVjMjNlNyA9IEwubWFya2VyKAogICAgICAgICAgICAgICAgWzQwLjA1MzY2MSwgLTEwNS4xNTExNDNdLAogICAgICAgICAgICAgICAge30KICAgICAgICAgICAgKS5hZGRUbyhtYXJrZXJfY2x1c3Rlcl8yZjhlNDNiMDc0MzI0MzVlOWVmZGFiMjE5YWQxMGQ0Zik7CiAgICAgICAgCiAgICAKICAgICAgICB2YXIgcG9wdXBfMzgyNDA1ZTkzODI3NGYxYWEyYjNjNjc4ZWM1YjU2OWYgPSBMLnBvcHVwKHsibWF4V2lkdGgiOiAiMTAwJSJ9KTsKCiAgICAgICAgCiAgICAgICAgICAgIHZhciBodG1sXzA2ZGYzMGFkMjJkMTQzZTI5ZDA2ZTIxMDQ5MTBhMzcwID0gJChgPGRpdiBpZD0iaHRtbF8wNmRmMzBhZDIyZDE0M2UyOWQwNmUyMTA0OTEwYTM3MCIgc3R5bGU9IndpZHRoOiAxMDAuMCU7IGhlaWdodDogMTAwLjAlOyI+TmFtZTogTEVHR0VUVCBESVRDSCBQcmVjaXA6IDMuMDU8L2Rpdj5gKVswXTsKICAgICAgICAgICAgcG9wdXBfMzgyNDA1ZTkzODI3NGYxYWEyYjNjNjc4ZWM1YjU2OWYuc2V0Q29udGVudChodG1sXzA2ZGYzMGFkMjJkMTQzZTI5ZDA2ZTIxMDQ5MTBhMzcwKTsKICAgICAgICAKCiAgICAgICAgbWFya2VyX2I0MWFkZGYxNGExMTQ3MzJhNDMwM2Q5ZjNlZWMyM2U3LmJpbmRQb3B1cChwb3B1cF8zODI0MDVlOTM4Mjc0ZjFhYTJiM2M2NzhlYzViNTY5ZikKICAgICAgICA7CgogICAgICAgIAogICAgCiAgICAKICAgICAgICAgICAgdmFyIG1hcmtlcl8wZDE4NDQ4N2Q5Yjg0MDQ2OGNlZWI0YjIyNzdiNTk2MCA9IEwubWFya2VyKAogICAgICAgICAgICAgICAgWzQwLjIxNjI2MywgLTEwNS4zNjUzNjVdLAogICAgICAgICAgICAgICAge30KICAgICAgICAgICAgKS5hZGRUbyhtYXJrZXJfY2x1c3Rlcl8yZjhlNDNiMDc0MzI0MzVlOWVmZGFiMjE5YWQxMGQ0Zik7CiAgICAgICAgCiAgICAKICAgICAgICB2YXIgcG9wdXBfZjg3ZmZkNTBmZjYzNDI0Yjk0OTBmYjJhM2VlMWYyOWIgPSBMLnBvcHVwKHsibWF4V2lkdGgiOiAiMTAwJSJ9KTsKCiAgICAgICAgCiAgICAgICAgICAgIHZhciBodG1sXzMwZjQzZjc0OGQzNzQwYmFhYjZiNGI0MDUyNWJhMDhjID0gJChgPGRpdiBpZD0iaHRtbF8zMGY0M2Y3NDhkMzc0MGJhYWI2YjRiNDA1MjViYTA4YyIgc3R5bGU9IndpZHRoOiAxMDAuMCU7IGhlaWdodDogMTAwLjAlOyI+TmFtZTogQlVUVE9OUk9DSyAoUkFMUEggUFJJQ0UpIFJFU0VSVk9JUiBQcmVjaXA6IDEyODkwLjAwPC9kaXY+YClbMF07CiAgICAgICAgICAgIHBvcHVwX2Y4N2ZmZDUwZmY2MzQyNGI5NDkwZmIyYTNlZTFmMjliLnNldENvbnRlbnQoaHRtbF8zMGY0M2Y3NDhkMzc0MGJhYWI2YjRiNDA1MjViYTA4Yyk7CiAgICAgICAgCgogICAgICAgIG1hcmtlcl8wZDE4NDQ4N2Q5Yjg0MDQ2OGNlZWI0YjIyNzdiNTk2MC5iaW5kUG9wdXAocG9wdXBfZjg3ZmZkNTBmZjYzNDI0Yjk0OTBmYjJhM2VlMWYyOWIpCiAgICAgICAgOwoKICAgICAgICAKICAgIAogICAgCiAgICAgICAgICAgIHZhciBtYXJrZXJfNTJjODczOGY1ZGRmNDMwMzhiY2M3MTkyZDQ3YzY1MDEgPSBMLm1hcmtlcigKICAgICAgICAgICAgICAgIFs0MC4yNTU3NzYsIC0xMDUuMjA5NV0sCiAgICAgICAgICAgICAgICB7fQogICAgICAgICAgICApLmFkZFRvKG1hcmtlcl9jbHVzdGVyXzJmOGU0M2IwNzQzMjQzNWU5ZWZkYWIyMTlhZDEwZDRmKTsKICAgICAgICAKICAgIAogICAgICAgIHZhciBwb3B1cF9hOGI2ODViYTk4NjE0YjZjYWMyYWVkY2E5MzA5MTg0YyA9IEwucG9wdXAoeyJtYXhXaWR0aCI6ICIxMDAlIn0pOwoKICAgICAgICAKICAgICAgICAgICAgdmFyIGh0bWxfYjdkY2I4OTVhOGY2NGVjYmIxNzMzNmYxOTExOTgxZjIgPSAkKGA8ZGl2IGlkPSJodG1sX2I3ZGNiODk1YThmNjRlY2JiMTczMzZmMTkxMTk4MWYyIiBzdHlsZT0id2lkdGg6IDEwMC4wJTsgaGVpZ2h0OiAxMDAuMCU7Ij5OYW1lOiBMSVRUTEUgVEhPTVBTT04gIzIgRElUQ0ggUHJlY2lwOiAwLjEwPC9kaXY+YClbMF07CiAgICAgICAgICAgIHBvcHVwX2E4YjY4NWJhOTg2MTRiNmNhYzJhZWRjYTkzMDkxODRjLnNldENvbnRlbnQoaHRtbF9iN2RjYjg5NWE4ZjY0ZWNiYjE3MzM2ZjE5MTE5ODFmMik7CiAgICAgICAgCgogICAgICAgIG1hcmtlcl81MmM4NzM4ZjVkZGY0MzAzOGJjYzcxOTJkNDdjNjUwMS5iaW5kUG9wdXAocG9wdXBfYThiNjg1YmE5ODYxNGI2Y2FjMmFlZGNhOTMwOTE4NGMpCiAgICAgICAgOwoKICAgICAgICAKICAgIAogICAgCiAgICAgICAgICAgIHZhciBtYXJrZXJfYmJlMmUwMDdlZmZjNDJhOGI3OTA3YjkzNmIxYzY0OGIgPSBMLm1hcmtlcigKICAgICAgICAgICAgICAgIFs0MC4yNTc4NDQsIC0xMDUuMTY0Mzk3XSwKICAgICAgICAgICAgICAgIHt9CiAgICAgICAgICAgICkuYWRkVG8obWFya2VyX2NsdXN0ZXJfMmY4ZTQzYjA3NDMyNDM1ZTllZmRhYjIxOWFkMTBkNGYpOwogICAgICAgIAogICAgCiAgICAgICAgdmFyIHBvcHVwXzQxM2QyN2JmZmIwZTRhMzQ5ZmU5MzcwNTM0MTI0ZmQzID0gTC5wb3B1cCh7Im1heFdpZHRoIjogIjEwMCUifSk7CgogICAgICAgIAogICAgICAgICAgICB2YXIgaHRtbF81ZDNkNTk3ZjdkMWU0ODkwOTI4NTc3MDIzNzdmM2E1OSA9ICQoYDxkaXYgaWQ9Imh0bWxfNWQzZDU5N2Y3ZDFlNDg5MDkyODU3NzAyMzc3ZjNhNTkiIHN0eWxlPSJ3aWR0aDogMTAwLjAlOyBoZWlnaHQ6IDEwMC4wJTsiPk5hbWU6IEJMT1dFUiBESVRDSCBQcmVjaXA6IDAuMDE8L2Rpdj5gKVswXTsKICAgICAgICAgICAgcG9wdXBfNDEzZDI3YmZmYjBlNGEzNDlmZTkzNzA1MzQxMjRmZDMuc2V0Q29udGVudChodG1sXzVkM2Q1OTdmN2QxZTQ4OTA5Mjg1NzcwMjM3N2YzYTU5KTsKICAgICAgICAKCiAgICAgICAgbWFya2VyX2JiZTJlMDA3ZWZmYzQyYThiNzkwN2I5MzZiMWM2NDhiLmJpbmRQb3B1cChwb3B1cF80MTNkMjdiZmZiMGU0YTM0OWZlOTM3MDUzNDEyNGZkMykKICAgICAgICA7CgogICAgICAgIAogICAgCiAgICAKICAgICAgICAgICAgdmFyIG1hcmtlcl8zNGIzMzI4MWE5YWI0YzAxODFkNDgxNTEzNTgwNmIxYSA9IEwubWFya2VyKAogICAgICAgICAgICAgICAgWzM5LjkzMTU5NywgLTEwNS4zMDQ5OV0sCiAgICAgICAgICAgICAgICB7fQogICAgICAgICAgICApLmFkZFRvKG1hcmtlcl9jbHVzdGVyXzJmOGU0M2IwNzQzMjQzNWU5ZWZkYWIyMTlhZDEwZDRmKTsKICAgICAgICAKICAgIAogICAgICAgIHZhciBwb3B1cF80ZWQxNTljOTMxMzg0NGE2YjcxZDA3Y2VlY2ExMTlmMiA9IEwucG9wdXAoeyJtYXhXaWR0aCI6ICIxMDAlIn0pOwoKICAgICAgICAKICAgICAgICAgICAgdmFyIGh0bWxfOWM0YTc0NDU0MmMyNDI0ZGE0ZjYxZmY0NWE4NTdiOGEgPSAkKGA8ZGl2IGlkPSJodG1sXzljNGE3NDQ1NDJjMjQyNGRhNGY2MWZmNDVhODU3YjhhIiBzdHlsZT0id2lkdGg6IDEwMC4wJTsgaGVpZ2h0OiAxMDAuMCU7Ij5OYW1lOiBTT1VUSCBCT1VMREVSIENSRUVLIE5FQVIgRUxET1JBRE8gU1BSSU5HUywgQ08uIFByZWNpcDogMTYuMDA8L2Rpdj5gKVswXTsKICAgICAgICAgICAgcG9wdXBfNGVkMTU5YzkzMTM4NDRhNmI3MWQwN2NlZWNhMTE5ZjIuc2V0Q29udGVudChodG1sXzljNGE3NDQ1NDJjMjQyNGRhNGY2MWZmNDVhODU3YjhhKTsKICAgICAgICAKCiAgICAgICAgbWFya2VyXzM0YjMzMjgxYTlhYjRjMDE4MWQ0ODE1MTM1ODA2YjFhLmJpbmRQb3B1cChwb3B1cF80ZWQxNTljOTMxMzg0NGE2YjcxZDA3Y2VlY2ExMTlmMikKICAgICAgICA7CgogICAgICAgIAogICAgCiAgICAKICAgICAgICAgICAgdmFyIG1hcmtlcl81Nzc2NGNjMmI2NGU0ODY3YWZjZDFjNDM0YTE0OWFlNyA9IEwubWFya2VyKAogICAgICAgICAgICAgICAgWzQwLjA1MTY1MiwgLTEwNS4xNzg4NzVdLAogICAgICAgICAgICAgICAge30KICAgICAgICAgICAgKS5hZGRUbyhtYXJrZXJfY2x1c3Rlcl8yZjhlNDNiMDc0MzI0MzVlOWVmZGFiMjE5YWQxMGQ0Zik7CiAgICAgICAgCiAgICAKICAgICAgICB2YXIgcG9wdXBfOTJhZWJmODhmM2UxNDk0YmE4NjcwNzY2M2VmMmZiNWYgPSBMLnBvcHVwKHsibWF4V2lkdGgiOiAiMTAwJSJ9KTsKCiAgICAgICAgCiAgICAgICAgICAgIHZhciBodG1sXzAxMWQ1ZWQzZmY0NTQ4NDRiZmU3ZTI2MjYyMmIwODI0ID0gJChgPGRpdiBpZD0iaHRtbF8wMTFkNWVkM2ZmNDU0ODQ0YmZlN2UyNjI2MjJiMDgyNCIgc3R5bGU9IndpZHRoOiAxMDAuMCU7IGhlaWdodDogMTAwLjAlOyI+TmFtZTogQk9VTERFUiBDUkVFSyBBVCBOT1JUSCA3NVRIIFNULiBORUFSIEJPVUxERVIsIENPIFByZWNpcDogMzIuMTA8L2Rpdj5gKVswXTsKICAgICAgICAgICAgcG9wdXBfOTJhZWJmODhmM2UxNDk0YmE4NjcwNzY2M2VmMmZiNWYuc2V0Q29udGVudChodG1sXzAxMWQ1ZWQzZmY0NTQ4NDRiZmU3ZTI2MjYyMmIwODI0KTsKICAgICAgICAKCiAgICAgICAgbWFya2VyXzU3NzY0Y2MyYjY0ZTQ4NjdhZmNkMWM0MzRhMTQ5YWU3LmJpbmRQb3B1cChwb3B1cF85MmFlYmY4OGYzZTE0OTRiYTg2NzA3NjYzZWYyZmI1ZikKICAgICAgICA7CgogICAgICAgIAogICAgCiAgICAKICAgICAgICAgICAgdmFyIG1hcmtlcl8wMzBiNTU0YzM4NmY0YjE3OWRhMGFkMzUzMTAwZjY5NSA9IEwubWFya2VyKAogICAgICAgICAgICAgICAgWzQwLjE3MDk5OCwgLTEwNS4xNjA4NzZdLAogICAgICAgICAgICAgICAge30KICAgICAgICAgICAgKS5hZGRUbyhtYXJrZXJfY2x1c3Rlcl8yZjhlNDNiMDc0MzI0MzVlOWVmZGFiMjE5YWQxMGQ0Zik7CiAgICAgICAgCiAgICAKICAgICAgICB2YXIgcG9wdXBfNzNlZDY2MmQzOTNiNDcwM2JjZjg4NmU4YWRiMTA5MTkgPSBMLnBvcHVwKHsibWF4V2lkdGgiOiAiMTAwJSJ9KTsKCiAgICAgICAgCiAgICAgICAgICAgIHZhciBodG1sX2QyMTAxNTNlMjc1NDRkOTI4MDM5NjhlNDIzY2Y0OGQ1ID0gJChgPGRpdiBpZD0iaHRtbF9kMjEwMTUzZTI3NTQ0ZDkyODAzOTY4ZTQyM2NmNDhkNSIgc3R5bGU9IndpZHRoOiAxMDAuMCU7IGhlaWdodDogMTAwLjAlOyI+TmFtZTogU09VVEggRkxBVCBESVRDSCBQcmVjaXA6IDAuMzg8L2Rpdj5gKVswXTsKICAgICAgICAgICAgcG9wdXBfNzNlZDY2MmQzOTNiNDcwM2JjZjg4NmU4YWRiMTA5MTkuc2V0Q29udGVudChodG1sX2QyMTAxNTNlMjc1NDRkOTI4MDM5NjhlNDIzY2Y0OGQ1KTsKICAgICAgICAKCiAgICAgICAgbWFya2VyXzAzMGI1NTRjMzg2ZjRiMTc5ZGEwYWQzNTMxMDBmNjk1LmJpbmRQb3B1cChwb3B1cF83M2VkNjYyZDM5M2I0NzAzYmNmODg2ZThhZGIxMDkxOSkKICAgICAgICA7CgogICAgICAgIAogICAgCiAgICAKICAgICAgICAgICAgdmFyIG1hcmtlcl9hMGJlY2U4ZjEzOGM0YWY3ODc2MGI5NmRkMzk5MjNmOCA9IEwubWFya2VyKAogICAgICAgICAgICAgICAgWzQwLjE1MzM0MSwgLTEwNS4wNzU2OTVdLAogICAgICAgICAgICAgICAge30KICAgICAgICAgICAgKS5hZGRUbyhtYXJrZXJfY2x1c3Rlcl8yZjhlNDNiMDc0MzI0MzVlOWVmZGFiMjE5YWQxMGQ0Zik7CiAgICAgICAgCiAgICAKICAgICAgICB2YXIgcG9wdXBfMjgxNWI2NTFhYjcwNDM0NDliYmZlNTY4OWE5NmNhYmUgPSBMLnBvcHVwKHsibWF4V2lkdGgiOiAiMTAwJSJ9KTsKCiAgICAgICAgCiAgICAgICAgICAgIHZhciBodG1sXzAxZWY2ODBjNGM0MzRlZTlhZDQ4YWZlY2ZhNDNhMDlhID0gJChgPGRpdiBpZD0iaHRtbF8wMWVmNjgwYzRjNDM0ZWU5YWQ0OGFmZWNmYTQzYTA5YSIgc3R5bGU9IndpZHRoOiAxMDAuMCU7IGhlaWdodDogMTAwLjAlOyI+TmFtZTogU0FJTlQgVlJBSU4gQ1JFRUsgQkVMT1cgS0VOIFBSQVRUIEJMVkQgQVQgTE9OR01PTlQsIENPIFByZWNpcDogMzYuMzA8L2Rpdj5gKVswXTsKICAgICAgICAgICAgcG9wdXBfMjgxNWI2NTFhYjcwNDM0NDliYmZlNTY4OWE5NmNhYmUuc2V0Q29udGVudChodG1sXzAxZWY2ODBjNGM0MzRlZTlhZDQ4YWZlY2ZhNDNhMDlhKTsKICAgICAgICAKCiAgICAgICAgbWFya2VyX2EwYmVjZThmMTM4YzRhZjc4NzYwYjk2ZGQzOTkyM2Y4LmJpbmRQb3B1cChwb3B1cF8yODE1YjY1MWFiNzA0MzQ0OWJiZmU1Njg5YTk2Y2FiZSkKICAgICAgICA7CgogICAgICAgIAogICAgCiAgICAKICAgICAgICAgICAgdmFyIG1hcmtlcl9iZmM4NzE4YTM0YTg0YzllODM3MTY0YzFmZWJiYmFmOSA9IEwubWFya2VyKAogICAgICAgICAgICAgICAgWzM5Ljk2MTY1NSwgLTEwNS41MDQ0NF0sCiAgICAgICAgICAgICAgICB7fQogICAgICAgICAgICApLmFkZFRvKG1hcmtlcl9jbHVzdGVyXzJmOGU0M2IwNzQzMjQzNWU5ZWZkYWIyMTlhZDEwZDRmKTsKICAgICAgICAKICAgIAogICAgICAgIHZhciBwb3B1cF81NTNlNTNjNDkwMzk0MzRjOTdhZDE5OGY5OWU5ODliOCA9IEwucG9wdXAoeyJtYXhXaWR0aCI6ICIxMDAlIn0pOwoKICAgICAgICAKICAgICAgICAgICAgdmFyIGh0bWxfYTU5ODg3ZTU2ZmM1NGU2ZjhjZThjZDE5NGY3MWNjY2IgPSAkKGA8ZGl2IGlkPSJodG1sX2E1OTg4N2U1NmZjNTRlNmY4Y2U4Y2QxOTRmNzFjY2NiIiBzdHlsZT0id2lkdGg6IDEwMC4wJTsgaGVpZ2h0OiAxMDAuMCU7Ij5OYW1lOiBNSURETEUgQk9VTERFUiBDUkVFSyBBVCBORURFUkxBTkQsIENPLiBQcmVjaXA6IDI0LjYwPC9kaXY+YClbMF07CiAgICAgICAgICAgIHBvcHVwXzU1M2U1M2M0OTAzOTQzNGM5N2FkMTk4Zjk5ZTk4OWI4LnNldENvbnRlbnQoaHRtbF9hNTk4ODdlNTZmYzU0ZTZmOGNlOGNkMTk0ZjcxY2NjYik7CiAgICAgICAgCgogICAgICAgIG1hcmtlcl9iZmM4NzE4YTM0YTg0YzllODM3MTY0YzFmZWJiYmFmOS5iaW5kUG9wdXAocG9wdXBfNTUzZTUzYzQ5MDM5NDM0Yzk3YWQxOThmOTllOTg5YjgpCiAgICAgICAgOwoKICAgICAgICAKICAgIAogICAgCiAgICAgICAgICAgIHZhciBtYXJrZXJfMDBjOWFmMTc0Y2U2NDQzZmEwNDU5ZmMwMWJjZDY0MmEgPSBMLm1hcmtlcigKICAgICAgICAgICAgICAgIFs0MC4wNTk4MDksIC0xMDUuMDk3ODcyXSwKICAgICAgICAgICAgICAgIHt9CiAgICAgICAgICAgICkuYWRkVG8obWFya2VyX2NsdXN0ZXJfMmY4ZTQzYjA3NDMyNDM1ZTllZmRhYjIxOWFkMTBkNGYpOwogICAgICAgIAogICAgCiAgICAgICAgdmFyIHBvcHVwXzJlNTY1NjhmNTljZjRjYWU5MDFlMzc5OTE2OTU3ZGZhID0gTC5wb3B1cCh7Im1heFdpZHRoIjogIjEwMCUifSk7CgogICAgICAgIAogICAgICAgICAgICB2YXIgaHRtbF83ZTkzNzcwNTIxZWU0MzliYjUxNjMwMzc0NTQwNjg3NiA9ICQoYDxkaXYgaWQ9Imh0bWxfN2U5Mzc3MDUyMWVlNDM5YmI1MTYzMDM3NDU0MDY4NzYiIHN0eWxlPSJ3aWR0aDogMTAwLjAlOyBoZWlnaHQ6IDEwMC4wJTsiPk5hbWU6IEJPVUxERVIgQ1JFRUsgQVQgMTA5IFNUIE5FQVIgRVJJRSwgQ08gUHJlY2lwOiA0NC42MDwvZGl2PmApWzBdOwogICAgICAgICAgICBwb3B1cF8yZTU2NTY4ZjU5Y2Y0Y2FlOTAxZTM3OTkxNjk1N2RmYS5zZXRDb250ZW50KGh0bWxfN2U5Mzc3MDUyMWVlNDM5YmI1MTYzMDM3NDU0MDY4NzYpOwogICAgICAgIAoKICAgICAgICBtYXJrZXJfMDBjOWFmMTc0Y2U2NDQzZmEwNDU5ZmMwMWJjZDY0MmEuYmluZFBvcHVwKHBvcHVwXzJlNTY1NjhmNTljZjRjYWU5MDFlMzc5OTE2OTU3ZGZhKQogICAgICAgIDsKCiAgICAgICAgCiAgICAKICAgIAogICAgICAgICAgICB2YXIgbWFya2VyXzQ0OTMyNWJiYzlmNjRhMTM5NzI4ODhiNDhmOTNmYzc5ID0gTC5tYXJrZXIoCiAgICAgICAgICAgICAgICBbNDAuMjE1NjU4LCAtMTA1LjM2MzQyMl0sCiAgICAgICAgICAgICAgICB7fQogICAgICAgICAgICApLmFkZFRvKG1hcmtlcl9jbHVzdGVyXzJmOGU0M2IwNzQzMjQzNWU5ZWZkYWIyMTlhZDEwZDRmKTsKICAgICAgICAKICAgIAogICAgICAgIHZhciBwb3B1cF8zYjNkNzhhMjUzOWE0ZDM1ODg4MzZlZjliZDk2MjZhZCA9IEwucG9wdXAoeyJtYXhXaWR0aCI6ICIxMDAlIn0pOwoKICAgICAgICAKICAgICAgICAgICAgdmFyIGh0bWxfOTc0MjczYTgwOGM3NDJkYWEzMmRkZWNlYTU4NTZiYmUgPSAkKGA8ZGl2IGlkPSJodG1sXzk3NDI3M2E4MDhjNzQyZGFhMzJkZGVjZWE1ODU2YmJlIiBzdHlsZT0id2lkdGg6IDEwMC4wJTsgaGVpZ2h0OiAxMDAuMCU7Ij5OYW1lOiBOT1JUSCBTQUlOVCBWUkFJTiBDUkVFSyBCRUxPVyBCVVRUT05ST0NLICAoUkFMUEggUFJJQ0UpIFJFU0VSVk9JUiBQcmVjaXA6IDE5LjMwPC9kaXY+YClbMF07CiAgICAgICAgICAgIHBvcHVwXzNiM2Q3OGEyNTM5YTRkMzU4ODgzNmVmOWJkOTYyNmFkLnNldENvbnRlbnQoaHRtbF85NzQyNzNhODA4Yzc0MmRhYTMyZGRlY2VhNTg1NmJiZSk7CiAgICAgICAgCgogICAgICAgIG1hcmtlcl80NDkzMjViYmM5ZjY0YTEzOTcyODg4YjQ4ZjkzZmM3OS5iaW5kUG9wdXAocG9wdXBfM2IzZDc4YTI1MzlhNGQzNTg4ODM2ZWY5YmQ5NjI2YWQpCiAgICAgICAgOwoKICAgICAgICAKICAgIAogICAgCiAgICAgICAgICAgIHZhciBtYXJrZXJfMzEyZGFiOTBmZDY3NGNmZmFlMWIzOThkZjI1NWVjOWIgPSBMLm1hcmtlcigKICAgICAgICAgICAgICAgIFs0MC4xMjYzODksIC0xMDUuMzA0NDA0XSwKICAgICAgICAgICAgICAgIHt9CiAgICAgICAgICAgICkuYWRkVG8obWFya2VyX2NsdXN0ZXJfMmY4ZTQzYjA3NDMyNDM1ZTllZmRhYjIxOWFkMTBkNGYpOwogICAgICAgIAogICAgCiAgICAgICAgdmFyIHBvcHVwXzk3NGUyMzkzNDkzNzRlODI4ZGMzMjUwNGEwZjY4MGRlID0gTC5wb3B1cCh7Im1heFdpZHRoIjogIjEwMCUifSk7CgogICAgICAgIAogICAgICAgICAgICB2YXIgaHRtbF8zOTRiNmYwZTUzZDk0OGY2ODU5N2YyMGZlMmNmZTkwOCA9ICQoYDxkaXYgaWQ9Imh0bWxfMzk0YjZmMGU1M2Q5NDhmNjg1OTdmMjBmZTJjZmU5MDgiIHN0eWxlPSJ3aWR0aDogMTAwLjAlOyBoZWlnaHQ6IDEwMC4wJTsiPk5hbWU6IExFRlQgSEFORCBDUkVFSyBORUFSIEJPVUxERVIsIENPLiBQcmVjaXA6IDEyLjYwPC9kaXY+YClbMF07CiAgICAgICAgICAgIHBvcHVwXzk3NGUyMzkzNDkzNzRlODI4ZGMzMjUwNGEwZjY4MGRlLnNldENvbnRlbnQoaHRtbF8zOTRiNmYwZTUzZDk0OGY2ODU5N2YyMGZlMmNmZTkwOCk7CiAgICAgICAgCgogICAgICAgIG1hcmtlcl8zMTJkYWI5MGZkNjc0Y2ZmYWUxYjM5OGRmMjU1ZWM5Yi5iaW5kUG9wdXAocG9wdXBfOTc0ZTIzOTM0OTM3NGU4MjhkYzMyNTA0YTBmNjgwZGUpCiAgICAgICAgOwoKICAgICAgICAKICAgIAogICAgCiAgICAgICAgICAgIHZhciBtYXJrZXJfMjcxMGY5MGViN2E5NDM3M2EyMTczY2VlMGE1ZTE5MmIgPSBMLm1hcmtlcigKICAgICAgICAgICAgICAgIFs0MC4wODYyNzgsIC0xMDUuMjE3NTE5XSwKICAgICAgICAgICAgICAgIHt9CiAgICAgICAgICAgICkuYWRkVG8obWFya2VyX2NsdXN0ZXJfMmY4ZTQzYjA3NDMyNDM1ZTllZmRhYjIxOWFkMTBkNGYpOwogICAgICAgIAogICAgCiAgICAgICAgdmFyIHBvcHVwX2M0ODM4Yjk4MTE3ZDQ5MGE4ZGFkMzEwZDBmY2I0MWU4ID0gTC5wb3B1cCh7Im1heFdpZHRoIjogIjEwMCUifSk7CgogICAgICAgIAogICAgICAgICAgICB2YXIgaHRtbF9lZDVmNjgwMGEyZDA0NzVjOTU4ZTI0MjM5NGRlZTQxYiA9ICQoYDxkaXYgaWQ9Imh0bWxfZWQ1ZjY4MDBhMmQwNDc1Yzk1OGUyNDIzOTRkZWU0MWIiIHN0eWxlPSJ3aWR0aDogMTAwLjAlOyBoZWlnaHQ6IDEwMC4wJTsiPk5hbWU6IEJPVUxERVIgUkVTRVJWT0lSIElOTEVUIFByZWNpcDogMC4wMDwvZGl2PmApWzBdOwogICAgICAgICAgICBwb3B1cF9jNDgzOGI5ODExN2Q0OTBhOGRhZDMxMGQwZmNiNDFlOC5zZXRDb250ZW50KGh0bWxfZWQ1ZjY4MDBhMmQwNDc1Yzk1OGUyNDIzOTRkZWU0MWIpOwogICAgICAgIAoKICAgICAgICBtYXJrZXJfMjcxMGY5MGViN2E5NDM3M2EyMTczY2VlMGE1ZTE5MmIuYmluZFBvcHVwKHBvcHVwX2M0ODM4Yjk4MTE3ZDQ5MGE4ZGFkMzEwZDBmY2I0MWU4KQogICAgICAgIDsKCiAgICAgICAgCiAgICAKICAgIAogICAgICAgICAgICB2YXIgbWFya2VyX2E0YTcyODFlZGU4YjRmYmE5NDFkNmVjYzlkNmMwNDQ4ID0gTC5tYXJrZXIoCiAgICAgICAgICAgICAgICBbNDAuMTkzMDE5LCAtMTA1LjIxMDM4OF0sCiAgICAgICAgICAgICAgICB7fQogICAgICAgICAgICApLmFkZFRvKG1hcmtlcl9jbHVzdGVyXzJmOGU0M2IwNzQzMjQzNWU5ZWZkYWIyMTlhZDEwZDRmKTsKICAgICAgICAKICAgIAogICAgICAgIHZhciBwb3B1cF84MThjODlhNmJiMzY0YTU2OGQwZDZhMzljODFhODVhMCA9IEwucG9wdXAoeyJtYXhXaWR0aCI6ICIxMDAlIn0pOwoKICAgICAgICAKICAgICAgICAgICAgdmFyIGh0bWxfYTVmNTk5YWViNWU4NDcyOThkMWZkM2E4YWJmNmZmNTUgPSAkKGA8ZGl2IGlkPSJodG1sX2E1ZjU5OWFlYjVlODQ3Mjk4ZDFmZDNhOGFiZjZmZjU1IiBzdHlsZT0id2lkdGg6IDEwMC4wJTsgaGVpZ2h0OiAxMDAuMCU7Ij5OYW1lOiBUUlVFIEFORCBXRUJTVEVSIERJVENIIFByZWNpcDogMC4wMDwvZGl2PmApWzBdOwogICAgICAgICAgICBwb3B1cF84MThjODlhNmJiMzY0YTU2OGQwZDZhMzljODFhODVhMC5zZXRDb250ZW50KGh0bWxfYTVmNTk5YWViNWU4NDcyOThkMWZkM2E4YWJmNmZmNTUpOwogICAgICAgIAoKICAgICAgICBtYXJrZXJfYTRhNzI4MWVkZThiNGZiYTk0MWQ2ZWNjOWQ2YzA0NDguYmluZFBvcHVwKHBvcHVwXzgxOGM4OWE2YmIzNjRhNTY4ZDBkNmEzOWM4MWE4NWEwKQogICAgICAgIDsKCiAgICAgICAgCiAgICAKICAgIAogICAgICAgICAgICB2YXIgbWFya2VyX2E4YmExNjYyZWUzNTQzYWM4OWJhYTkyMWI4YjhmYTkxID0gTC5tYXJrZXIoCiAgICAgICAgICAgICAgICBbNDAuMjEyNjU4LCAtMTA1LjI1MTgyNl0sCiAgICAgICAgICAgICAgICB7fQogICAgICAgICAgICApLmFkZFRvKG1hcmtlcl9jbHVzdGVyXzJmOGU0M2IwNzQzMjQzNWU5ZWZkYWIyMTlhZDEwZDRmKTsKICAgICAgICAKICAgIAogICAgICAgIHZhciBwb3B1cF9jZjBmNDEzNTRlMzk0ZWM5OGZlNzQ1ZWY1ZTJhMDlhOCA9IEwucG9wdXAoeyJtYXhXaWR0aCI6ICIxMDAlIn0pOwoKICAgICAgICAKICAgICAgICAgICAgdmFyIGh0bWxfZjk2ZDBmOTRkMGJjNGFlYzllN2Q4ZDIyNDM5MjRmMmYgPSAkKGA8ZGl2IGlkPSJodG1sX2Y5NmQwZjk0ZDBiYzRhZWM5ZTdkOGQyMjQzOTI0ZjJmIiBzdHlsZT0id2lkdGg6IDEwMC4wJTsgaGVpZ2h0OiAxMDAuMCU7Ij5OYW1lOiBST1VHSCBBTkQgUkVBRFkgRElUQ0ggUHJlY2lwOiAwLjAwPC9kaXY+YClbMF07CiAgICAgICAgICAgIHBvcHVwX2NmMGY0MTM1NGUzOTRlYzk4ZmU3NDVlZjVlMmEwOWE4LnNldENvbnRlbnQoaHRtbF9mOTZkMGY5NGQwYmM0YWVjOWU3ZDhkMjI0MzkyNGYyZik7CiAgICAgICAgCgogICAgICAgIG1hcmtlcl9hOGJhMTY2MmVlMzU0M2FjODliYWE5MjFiOGI4ZmE5MS5iaW5kUG9wdXAocG9wdXBfY2YwZjQxMzU0ZTM5NGVjOThmZTc0NWVmNWUyYTA5YTgpCiAgICAgICAgOwoKICAgICAgICAKICAgIAogICAgCiAgICAgICAgICAgIHZhciBtYXJrZXJfNjZiNWU5NGVlZTdkNDM1Mjg0ZWRkNTYyZjhhMjkwYjAgPSBMLm1hcmtlcigKICAgICAgICAgICAgICAgIFs0MC4xNzQ4NDQsIC0xMDUuMTY3ODczXSwKICAgICAgICAgICAgICAgIHt9CiAgICAgICAgICAgICkuYWRkVG8obWFya2VyX2NsdXN0ZXJfMmY4ZTQzYjA3NDMyNDM1ZTllZmRhYjIxOWFkMTBkNGYpOwogICAgICAgIAogICAgCiAgICAgICAgdmFyIHBvcHVwXzU4NzNmNzkxZGMwMDRiZWI4OTA5NzA0MDgzYTczNjlmID0gTC5wb3B1cCh7Im1heFdpZHRoIjogIjEwMCUifSk7CgogICAgICAgIAogICAgICAgICAgICB2YXIgaHRtbF83ODZmZDIxNTQwNmE0MDIxYTMwM2MxYmM5NTRiMjRjOSA9ICQoYDxkaXYgaWQ9Imh0bWxfNzg2ZmQyMTU0MDZhNDAyMWEzMDNjMWJjOTU0YjI0YzkiIHN0eWxlPSJ3aWR0aDogMTAwLjAlOyBoZWlnaHQ6IDEwMC4wJTsiPk5hbWU6IEhBR0VSIE1FQURPV1MgRElUQ0ggUHJlY2lwOiAwLjEwPC9kaXY+YClbMF07CiAgICAgICAgICAgIHBvcHVwXzU4NzNmNzkxZGMwMDRiZWI4OTA5NzA0MDgzYTczNjlmLnNldENvbnRlbnQoaHRtbF83ODZmZDIxNTQwNmE0MDIxYTMwM2MxYmM5NTRiMjRjOSk7CiAgICAgICAgCgogICAgICAgIG1hcmtlcl82NmI1ZTk0ZWVlN2Q0MzUyODRlZGQ1NjJmOGEyOTBiMC5iaW5kUG9wdXAocG9wdXBfNTg3M2Y3OTFkYzAwNGJlYjg5MDk3MDQwODNhNzM2OWYpCiAgICAgICAgOwoKICAgICAgICAKICAgIAogICAgCiAgICAgICAgICAgIHZhciBtYXJrZXJfMTZlOWM4NjNlNDRjNGIxMmFjMDVhYzUwM2VkOGZiMmYgPSBMLm1hcmtlcigKICAgICAgICAgICAgICAgIFs0MC4yNTYyNzYsIC0xMDUuMjA5NDE2XSwKICAgICAgICAgICAgICAgIHt9CiAgICAgICAgICAgICkuYWRkVG8obWFya2VyX2NsdXN0ZXJfMmY4ZTQzYjA3NDMyNDM1ZTllZmRhYjIxOWFkMTBkNGYpOwogICAgICAgIAogICAgCiAgICAgICAgdmFyIHBvcHVwXzVhZGRkZjlmZmJjMjQwN2I5MmYxM2JiNzMzZmI1MGQ3ID0gTC5wb3B1cCh7Im1heFdpZHRoIjogIjEwMCUifSk7CgogICAgICAgIAogICAgICAgICAgICB2YXIgaHRtbF9iYTc0OGMxN2I2YzE0ODU0YTA1ODgwOWU4YmQ4M2U3YSA9ICQoYDxkaXYgaWQ9Imh0bWxfYmE3NDhjMTdiNmMxNDg1NGEwNTg4MDllOGJkODNlN2EiIHN0eWxlPSJ3aWR0aDogMTAwLjAlOyBoZWlnaHQ6IDEwMC4wJTsiPk5hbWU6IExJVFRMRSBUSE9NUFNPTiAjMSBESVRDSCBQcmVjaXA6IDAuMDA8L2Rpdj5gKVswXTsKICAgICAgICAgICAgcG9wdXBfNWFkZGRmOWZmYmMyNDA3YjkyZjEzYmI3MzNmYjUwZDcuc2V0Q29udGVudChodG1sX2JhNzQ4YzE3YjZjMTQ4NTRhMDU4ODA5ZThiZDgzZTdhKTsKICAgICAgICAKCiAgICAgICAgbWFya2VyXzE2ZTljODYzZTQ0YzRiMTJhYzA1YWM1MDNlZDhmYjJmLmJpbmRQb3B1cChwb3B1cF81YWRkZGY5ZmZiYzI0MDdiOTJmMTNiYjczM2ZiNTBkNykKICAgICAgICA7CgogICAgICAgIAogICAgCiAgICAKICAgICAgICAgICAgdmFyIG1hcmtlcl9iMTI4NGYzNTBiZmY0MmI1YTVmZmU3ZWYyNzY5ZGZmMSA9IEwubWFya2VyKAogICAgICAgICAgICAgICAgWzQwLjI2MDgyNywgLTEwNS4xOTg1NjddLAogICAgICAgICAgICAgICAge30KICAgICAgICAgICAgKS5hZGRUbyhtYXJrZXJfY2x1c3Rlcl8yZjhlNDNiMDc0MzI0MzVlOWVmZGFiMjE5YWQxMGQ0Zik7CiAgICAgICAgCiAgICAKICAgICAgICB2YXIgcG9wdXBfOGZkMzgyN2U1YWUzNGVlYzk1ODg5ZDc0ODYwODk5ZjAgPSBMLnBvcHVwKHsibWF4V2lkdGgiOiAiMTAwJSJ9KTsKCiAgICAgICAgCiAgICAgICAgICAgIHZhciBodG1sXzA5YjdlODQ4MzFiMjQ3NDliMTUyZjJkNTczZDMyZjc2ID0gJChgPGRpdiBpZD0iaHRtbF8wOWI3ZTg0ODMxYjI0NzQ5YjE1MmYyZDU3M2QzMmY3NiIgc3R5bGU9IndpZHRoOiAxMDAuMCU7IGhlaWdodDogMTAwLjAlOyI+TmFtZTogQ1VMVkVSIERJVENIIFByZWNpcDogMC4wMDwvZGl2PmApWzBdOwogICAgICAgICAgICBwb3B1cF84ZmQzODI3ZTVhZTM0ZWVjOTU4ODlkNzQ4NjA4OTlmMC5zZXRDb250ZW50KGh0bWxfMDliN2U4NDgzMWIyNDc0OWIxNTJmMmQ1NzNkMzJmNzYpOwogICAgICAgIAoKICAgICAgICBtYXJrZXJfYjEyODRmMzUwYmZmNDJiNWE1ZmZlN2VmMjc2OWRmZjEuYmluZFBvcHVwKHBvcHVwXzhmZDM4MjdlNWFlMzRlZWM5NTg4OWQ3NDg2MDg5OWYwKQogICAgICAgIDsKCiAgICAgICAgCiAgICAKICAgIAogICAgICAgICAgICB2YXIgbWFya2VyXzk4YjQ1ODc4MGEwMTRmOTg5ZjkwMjg5OWRiNDdmNjE3ID0gTC5tYXJrZXIoCiAgICAgICAgICAgICAgICBbNDAuMjE1MDQzLCAtMTA1LjI1NjAxN10sCiAgICAgICAgICAgICAgICB7fQogICAgICAgICAgICApLmFkZFRvKG1hcmtlcl9jbHVzdGVyXzJmOGU0M2IwNzQzMjQzNWU5ZWZkYWIyMTlhZDEwZDRmKTsKICAgICAgICAKICAgIAogICAgICAgIHZhciBwb3B1cF83MDI0NWM5OGQ2OTY0YTYyYjM3YzFlNTRmYjI0OThlOCA9IEwucG9wdXAoeyJtYXhXaWR0aCI6ICIxMDAlIn0pOwoKICAgICAgICAKICAgICAgICAgICAgdmFyIGh0bWxfYjU0MmY4OTdhNjQxNDExYjhmZmVmZTI5ZWViZDgxYTggPSAkKGA8ZGl2IGlkPSJodG1sX2I1NDJmODk3YTY0MTQxMWI4ZmZlZmUyOWVlYmQ4MWE4IiBzdHlsZT0id2lkdGg6IDEwMC4wJTsgaGVpZ2h0OiAxMDAuMCU7Ij5OYW1lOiBISUdITEFORCBESVRDSCBBVCBMWU9OUywgQ08gUHJlY2lwOiAzOS43MDwvZGl2PmApWzBdOwogICAgICAgICAgICBwb3B1cF83MDI0NWM5OGQ2OTY0YTYyYjM3YzFlNTRmYjI0OThlOC5zZXRDb250ZW50KGh0bWxfYjU0MmY4OTdhNjQxNDExYjhmZmVmZTI5ZWViZDgxYTgpOwogICAgICAgIAoKICAgICAgICBtYXJrZXJfOThiNDU4NzgwYTAxNGY5ODlmOTAyODk5ZGI0N2Y2MTcuYmluZFBvcHVwKHBvcHVwXzcwMjQ1Yzk4ZDY5NjRhNjJiMzdjMWU1NGZiMjQ5OGU4KQogICAgICAgIDsKCiAgICAgICAgCiAgICAKICAgIAogICAgICAgICAgICB2YXIgbWFya2VyX2ZmNDA0MWI3YmExMTRhYmJiMzQ0NTYzNDFiMjFiYWU5ID0gTC5tYXJrZXIoCiAgICAgICAgICAgICAgICBbNDAuMDc4NTYsIC0xMDUuMjIwNDk3XSwKICAgICAgICAgICAgICAgIHt9CiAgICAgICAgICAgICkuYWRkVG8obWFya2VyX2NsdXN0ZXJfMmY4ZTQzYjA3NDMyNDM1ZTllZmRhYjIxOWFkMTBkNGYpOwogICAgICAgIAogICAgCiAgICAgICAgdmFyIHBvcHVwXzhkMTE3MmViZGIyMTQ3ZWZiMmM5ZmM0NGQ0MmU3YjQ2ID0gTC5wb3B1cCh7Im1heFdpZHRoIjogIjEwMCUifSk7CgogICAgICAgIAogICAgICAgICAgICB2YXIgaHRtbF80NTQ3MTcwMmJkZDk0ZTFiOGY0NzU5OGM0NWU2M2QyYiA9ICQoYDxkaXYgaWQ9Imh0bWxfNDU0NzE3MDJiZGQ5NGUxYjhmNDc1OThjNDVlNjNkMmIiIHN0eWxlPSJ3aWR0aDogMTAwLjAlOyBoZWlnaHQ6IDEwMC4wJTsiPk5hbWU6IEJPVUxERVIgUkVTRVJWT0lSIFByZWNpcDogNTE5Ny41MDwvZGl2PmApWzBdOwogICAgICAgICAgICBwb3B1cF84ZDExNzJlYmRiMjE0N2VmYjJjOWZjNDRkNDJlN2I0Ni5zZXRDb250ZW50KGh0bWxfNDU0NzE3MDJiZGQ5NGUxYjhmNDc1OThjNDVlNjNkMmIpOwogICAgICAgIAoKICAgICAgICBtYXJrZXJfZmY0MDQxYjdiYTExNGFiYmIzNDQ1NjM0MWIyMWJhZTkuYmluZFBvcHVwKHBvcHVwXzhkMTE3MmViZGIyMTQ3ZWZiMmM5ZmM0NGQ0MmU3YjQ2KQogICAgICAgIDsKCiAgICAgICAgCiAgICAKICAgIAogICAgICAgICAgICB2YXIgbWFya2VyXzUxNmUwMWZkYzE3MzQ0MzFhZTA1MjhjMzQ0NjMwZGJiID0gTC5tYXJrZXIoCiAgICAgICAgICAgICAgICBbNDAuMTczOTUsIC0xMDUuMTY5Mzc0XSwKICAgICAgICAgICAgICAgIHt9CiAgICAgICAgICAgICkuYWRkVG8obWFya2VyX2NsdXN0ZXJfMmY4ZTQzYjA3NDMyNDM1ZTllZmRhYjIxOWFkMTBkNGYpOwogICAgICAgIAogICAgCiAgICAgICAgdmFyIHBvcHVwX2RlZjg3MzNiNWIwMTQ2MzM4Nzk1M2I3NzljZWI4MWMyID0gTC5wb3B1cCh7Im1heFdpZHRoIjogIjEwMCUifSk7CgogICAgICAgIAogICAgICAgICAgICB2YXIgaHRtbF9jNTg5NmY4OGE5NTI0Y2VjOTgwZGU0NTM0ZjAxYWIyZCA9ICQoYDxkaXYgaWQ9Imh0bWxfYzU4OTZmODhhOTUyNGNlYzk4MGRlNDUzNGYwMWFiMmQiIHN0eWxlPSJ3aWR0aDogMTAwLjAlOyBoZWlnaHQ6IDEwMC4wJTsiPk5hbWU6IE5JV09UIERJVENIIFByZWNpcDogMC4xOTwvZGl2PmApWzBdOwogICAgICAgICAgICBwb3B1cF9kZWY4NzMzYjViMDE0NjMzODc5NTNiNzc5Y2ViODFjMi5zZXRDb250ZW50KGh0bWxfYzU4OTZmODhhOTUyNGNlYzk4MGRlNDUzNGYwMWFiMmQpOwogICAgICAgIAoKICAgICAgICBtYXJrZXJfNTE2ZTAxZmRjMTczNDQzMWFlMDUyOGMzNDQ2MzBkYmIuYmluZFBvcHVwKHBvcHVwX2RlZjg3MzNiNWIwMTQ2MzM4Nzk1M2I3NzljZWI4MWMyKQogICAgICAgIDsKCiAgICAgICAgCiAgICAKICAgIAogICAgICAgICAgICB2YXIgbWFya2VyX2YwOTU5NzhkMDJmYjQ2NTNhZDAxZDA4MzdkZWZkMjZhID0gTC5tYXJrZXIoCiAgICAgICAgICAgICAgICBbNDAuMjExMzg5LCAtMTA1LjI1MDk1Ml0sCiAgICAgICAgICAgICAgICB7fQogICAgICAgICAgICApLmFkZFRvKG1hcmtlcl9jbHVzdGVyXzJmOGU0M2IwNzQzMjQzNWU5ZWZkYWIyMTlhZDEwZDRmKTsKICAgICAgICAKICAgIAogICAgICAgIHZhciBwb3B1cF84MDE4YzMxOTZiMjA0MjNkOTA5YmE0M2EyOWY2OGFlZCA9IEwucG9wdXAoeyJtYXhXaWR0aCI6ICIxMDAlIn0pOwoKICAgICAgICAKICAgICAgICAgICAgdmFyIGh0bWxfYmIzNDI5ZDdkN2FhNDE1NGFhYzJmNWU3OWI0NmFmNjUgPSAkKGA8ZGl2IGlkPSJodG1sX2JiMzQyOWQ3ZDdhYTQxNTRhYWMyZjVlNzliNDZhZjY1IiBzdHlsZT0id2lkdGg6IDEwMC4wJTsgaGVpZ2h0OiAxMDAuMCU7Ij5OYW1lOiBTTUVBRCBESVRDSCBQcmVjaXA6IDAuMDA8L2Rpdj5gKVswXTsKICAgICAgICAgICAgcG9wdXBfODAxOGMzMTk2YjIwNDIzZDkwOWJhNDNhMjlmNjhhZWQuc2V0Q29udGVudChodG1sX2JiMzQyOWQ3ZDdhYTQxNTRhYWMyZjVlNzliNDZhZjY1KTsKICAgICAgICAKCiAgICAgICAgbWFya2VyX2YwOTU5NzhkMDJmYjQ2NTNhZDAxZDA4MzdkZWZkMjZhLmJpbmRQb3B1cChwb3B1cF84MDE4YzMxOTZiMjA0MjNkOTA5YmE0M2EyOWY2OGFlZCkKICAgICAgICA7CgogICAgICAgIAogICAgCiAgICAKICAgICAgICAgICAgdmFyIG1hcmtlcl9iNmY0MDAwYWM3ZTE0YmI2YThmMjUzNjhjNGU1YjBlMSA9IEwubWFya2VyKAogICAgICAgICAgICAgICAgWzQwLjE1MzM2MywgLTEwNS4wODg2OTVdLAogICAgICAgICAgICAgICAge30KICAgICAgICAgICAgKS5hZGRUbyhtYXJrZXJfY2x1c3Rlcl8yZjhlNDNiMDc0MzI0MzVlOWVmZGFiMjE5YWQxMGQ0Zik7CiAgICAgICAgCiAgICAKICAgICAgICB2YXIgcG9wdXBfZmNkZjNiMDVhMmViNDNiOWEzMzFiYTdjNTdjOTAzMGEgPSBMLnBvcHVwKHsibWF4V2lkdGgiOiAiMTAwJSJ9KTsKCiAgICAgICAgCiAgICAgICAgICAgIHZhciBodG1sXzA5NmQ3MTAxY2M2NDRiNDBiZDExZjZkNDI1NmMzNTAxID0gJChgPGRpdiBpZD0iaHRtbF8wOTZkNzEwMWNjNjQ0YjQwYmQxMWY2ZDQyNTZjMzUwMSIgc3R5bGU9IndpZHRoOiAxMDAuMCU7IGhlaWdodDogMTAwLjAlOyI+TmFtZTogQk9OVVMgRElUQ0ggUHJlY2lwOiAwLjEwPC9kaXY+YClbMF07CiAgICAgICAgICAgIHBvcHVwX2ZjZGYzYjA1YTJlYjQzYjlhMzMxYmE3YzU3YzkwMzBhLnNldENvbnRlbnQoaHRtbF8wOTZkNzEwMWNjNjQ0YjQwYmQxMWY2ZDQyNTZjMzUwMSk7CiAgICAgICAgCgogICAgICAgIG1hcmtlcl9iNmY0MDAwYWM3ZTE0YmI2YThmMjUzNjhjNGU1YjBlMS5iaW5kUG9wdXAocG9wdXBfZmNkZjNiMDVhMmViNDNiOWEzMzFiYTdjNTdjOTAzMGEpCiAgICAgICAgOwoKICAgICAgICAKICAgIAogICAgCiAgICAgICAgICAgIHZhciBtYXJrZXJfNTdkYjI1ODg3OGZlNDFmOTlmMTllNjljZDAxNTYyYjkgPSBMLm1hcmtlcigKICAgICAgICAgICAgICAgIFs0MC4yMTEwODMsIC0xMDUuMjUwOTI3XSwKICAgICAgICAgICAgICAgIHt9CiAgICAgICAgICAgICkuYWRkVG8obWFya2VyX2NsdXN0ZXJfMmY4ZTQzYjA3NDMyNDM1ZTllZmRhYjIxOWFkMTBkNGYpOwogICAgICAgIAogICAgCiAgICAgICAgdmFyIHBvcHVwXzczYTU1NTYxOGRmYjQwZGJiZGU2YTE3N2ZiMjQ0MWRiID0gTC5wb3B1cCh7Im1heFdpZHRoIjogIjEwMCUifSk7CgogICAgICAgIAogICAgICAgICAgICB2YXIgaHRtbF8zYWE1YjI3ZWQzZjg0NTk2YWIyYmFlMTk4MTcwNGIxOSA9ICQoYDxkaXYgaWQ9Imh0bWxfM2FhNWIyN2VkM2Y4NDU5NmFiMmJhZTE5ODE3MDRiMTkiIHN0eWxlPSJ3aWR0aDogMTAwLjAlOyBoZWlnaHQ6IDEwMC4wJTsiPk5hbWU6IFNXRURFIERJVENIIFByZWNpcDogMC4wMDwvZGl2PmApWzBdOwogICAgICAgICAgICBwb3B1cF83M2E1NTU2MThkZmI0MGRiYmRlNmExNzdmYjI0NDFkYi5zZXRDb250ZW50KGh0bWxfM2FhNWIyN2VkM2Y4NDU5NmFiMmJhZTE5ODE3MDRiMTkpOwogICAgICAgIAoKICAgICAgICBtYXJrZXJfNTdkYjI1ODg3OGZlNDFmOTlmMTllNjljZDAxNTYyYjkuYmluZFBvcHVwKHBvcHVwXzczYTU1NTYxOGRmYjQwZGJiZGU2YTE3N2ZiMjQ0MWRiKQogICAgICAgIDsKCiAgICAgICAgCiAgICAKICAgIAogICAgICAgICAgICB2YXIgbWFya2VyXzY0ZDQwYjIxOGRjNzQ1MTU4ZDBlOTNjMjc3NTUzMWUwID0gTC5tYXJrZXIoCiAgICAgICAgICAgICAgICBbNDAuMTg3NTI0LCAtMTA1LjE4OTEzMl0sCiAgICAgICAgICAgICAgICB7fQogICAgICAgICAgICApLmFkZFRvKG1hcmtlcl9jbHVzdGVyXzJmOGU0M2IwNzQzMjQzNWU5ZWZkYWIyMTlhZDEwZDRmKTsKICAgICAgICAKICAgIAogICAgICAgIHZhciBwb3B1cF8xZWU4MTY2MTlhMDU0NWMxYWE2ZDliOWQxYjk4NTliNiA9IEwucG9wdXAoeyJtYXhXaWR0aCI6ICIxMDAlIn0pOwoKICAgICAgICAKICAgICAgICAgICAgdmFyIGh0bWxfODlmYjRlMTcxNmRhNDIyMWJiYWM1ZTAzNWZjYTdlZjYgPSAkKGA8ZGl2IGlkPSJodG1sXzg5ZmI0ZTE3MTZkYTQyMjFiYmFjNWUwMzVmY2E3ZWY2IiBzdHlsZT0id2lkdGg6IDEwMC4wJTsgaGVpZ2h0OiAxMDAuMCU7Ij5OYW1lOiBSVU5ZT04gRElUQ0ggUHJlY2lwOiAwLjAwPC9kaXY+YClbMF07CiAgICAgICAgICAgIHBvcHVwXzFlZTgxNjYxOWEwNTQ1YzFhYTZkOWI5ZDFiOTg1OWI2LnNldENvbnRlbnQoaHRtbF84OWZiNGUxNzE2ZGE0MjIxYmJhYzVlMDM1ZmNhN2VmNik7CiAgICAgICAgCgogICAgICAgIG1hcmtlcl82NGQ0MGIyMThkYzc0NTE1OGQwZTkzYzI3NzU1MzFlMC5iaW5kUG9wdXAocG9wdXBfMWVlODE2NjE5YTA1NDVjMWFhNmQ5YjlkMWI5ODU5YjYpCiAgICAgICAgOwoKICAgICAgICAKICAgIAogICAgCiAgICAgICAgICAgIHZhciBtYXJrZXJfZTE4MDZiMTc4MGY2NGRhZjg1NmQ0NDdiNWI1YmNlMzAgPSBMLm1hcmtlcigKICAgICAgICAgICAgICAgIFs0MC4xODE4OCwgLTEwNS4xOTY3NzVdLAogICAgICAgICAgICAgICAge30KICAgICAgICAgICAgKS5hZGRUbyhtYXJrZXJfY2x1c3Rlcl8yZjhlNDNiMDc0MzI0MzVlOWVmZGFiMjE5YWQxMGQ0Zik7CiAgICAgICAgCiAgICAKICAgICAgICB2YXIgcG9wdXBfYTIyMjUyMmJjNTFiNDM1MTk0ZWI3YzgzZWUxNWUxYjMgPSBMLnBvcHVwKHsibWF4V2lkdGgiOiAiMTAwJSJ9KTsKCiAgICAgICAgCiAgICAgICAgICAgIHZhciBodG1sXzdlMmEwZmQ5M2YwMDQyNzlhZDUxMzhhYTViNjVkNmJkID0gJChgPGRpdiBpZD0iaHRtbF83ZTJhMGZkOTNmMDA0Mjc5YWQ1MTM4YWE1YjY1ZDZiZCIgc3R5bGU9IndpZHRoOiAxMDAuMCU7IGhlaWdodDogMTAwLjAlOyI+TmFtZTogREFWSVMgQU5EIERPV05JTkcgRElUQ0ggUHJlY2lwOiAwLjAwPC9kaXY+YClbMF07CiAgICAgICAgICAgIHBvcHVwX2EyMjI1MjJiYzUxYjQzNTE5NGViN2M4M2VlMTVlMWIzLnNldENvbnRlbnQoaHRtbF83ZTJhMGZkOTNmMDA0Mjc5YWQ1MTM4YWE1YjY1ZDZiZCk7CiAgICAgICAgCgogICAgICAgIG1hcmtlcl9lMTgwNmIxNzgwZjY0ZGFmODU2ZDQ0N2I1YjViY2UzMC5iaW5kUG9wdXAocG9wdXBfYTIyMjUyMmJjNTFiNDM1MTk0ZWI3YzgzZWUxNWUxYjMpCiAgICAgICAgOwoKICAgICAgICAKICAgIAogICAgCiAgICAgICAgICAgIHZhciBtYXJrZXJfZWU5Y2RkNTUzODlmNGUwMzgwODliZWFlMWY0ZTZiOGMgPSBMLm1hcmtlcigKICAgICAgICAgICAgICAgIFs0MC4wMTg2NjcsIC0xMDUuMzI2MjVdLAogICAgICAgICAgICAgICAge30KICAgICAgICAgICAgKS5hZGRUbyhtYXJrZXJfY2x1c3Rlcl8yZjhlNDNiMDc0MzI0MzVlOWVmZGFiMjE5YWQxMGQ0Zik7CiAgICAgICAgCiAgICAKICAgICAgICB2YXIgcG9wdXBfMTYwNzQxMjY0YWE4NDY3NTk4Y2Y5YzU3MmNjZTE5NzcgPSBMLnBvcHVwKHsibWF4V2lkdGgiOiAiMTAwJSJ9KTsKCiAgICAgICAgCiAgICAgICAgICAgIHZhciBodG1sXzM2OGM1YmYyMzk4ZjQ0ZGVhZTAxOTFjOWYxNmZjMWMxID0gJChgPGRpdiBpZD0iaHRtbF8zNjhjNWJmMjM5OGY0NGRlYWUwMTkxYzlmMTZmYzFjMSIgc3R5bGU9IndpZHRoOiAxMDAuMCU7IGhlaWdodDogMTAwLjAlOyI+TmFtZTogRk9VUk1JTEUgQ1JFRUsgQVQgT1JPREVMTCwgQ08gUHJlY2lwOiAwLjc0PC9kaXY+YClbMF07CiAgICAgICAgICAgIHBvcHVwXzE2MDc0MTI2NGFhODQ2NzU5OGNmOWM1NzJjY2UxOTc3LnNldENvbnRlbnQoaHRtbF8zNjhjNWJmMjM5OGY0NGRlYWUwMTkxYzlmMTZmYzFjMSk7CiAgICAgICAgCgogICAgICAgIG1hcmtlcl9lZTljZGQ1NTM4OWY0ZTAzODA4OWJlYWUxZjRlNmI4Yy5iaW5kUG9wdXAocG9wdXBfMTYwNzQxMjY0YWE4NDY3NTk4Y2Y5YzU3MmNjZTE5NzcpCiAgICAgICAgOwoKICAgICAgICAKICAgIAogICAgCiAgICAgICAgICAgIHZhciBtYXJrZXJfYzEzN2FkNTY1NmY1NDk2Y2E5OTI2NTg1ODRlYjZiYzcgPSBMLm1hcmtlcigKICAgICAgICAgICAgICAgIFs0MC4xODg1NzksIC0xMDUuMjA5MjgyXSwKICAgICAgICAgICAgICAgIHt9CiAgICAgICAgICAgICkuYWRkVG8obWFya2VyX2NsdXN0ZXJfMmY4ZTQzYjA3NDMyNDM1ZTllZmRhYjIxOWFkMTBkNGYpOwogICAgICAgIAogICAgCiAgICAgICAgdmFyIHBvcHVwXzFlZjhmYWNjMzU0MzRkNDM4OGNkOTc0ZDcwZDAyZmRlID0gTC5wb3B1cCh7Im1heFdpZHRoIjogIjEwMCUifSk7CgogICAgICAgIAogICAgICAgICAgICB2YXIgaHRtbF9hZDZmY2M3MWY5ZmM0M2ZkOWU2MDQ2YjBiODhiYTJhNSA9ICQoYDxkaXYgaWQ9Imh0bWxfYWQ2ZmNjNzFmOWZjNDNmZDllNjA0NmIwYjg4YmEyYTUiIHN0eWxlPSJ3aWR0aDogMTAwLjAlOyBoZWlnaHQ6IDEwMC4wJTsiPk5hbWU6IEpBTUVTIERJVENIIFByZWNpcDogMC4xMjwvZGl2PmApWzBdOwogICAgICAgICAgICBwb3B1cF8xZWY4ZmFjYzM1NDM0ZDQzODhjZDk3NGQ3MGQwMmZkZS5zZXRDb250ZW50KGh0bWxfYWQ2ZmNjNzFmOWZjNDNmZDllNjA0NmIwYjg4YmEyYTUpOwogICAgICAgIAoKICAgICAgICBtYXJrZXJfYzEzN2FkNTY1NmY1NDk2Y2E5OTI2NTg1ODRlYjZiYzcuYmluZFBvcHVwKHBvcHVwXzFlZjhmYWNjMzU0MzRkNDM4OGNkOTc0ZDcwZDAyZmRlKQogICAgICAgIDsKCiAgICAgICAgCiAgICAKICAgIAogICAgICAgICAgICB2YXIgbWFya2VyX2YzNGJkOTFhOGE3NjQyMjQ5NDdmODIzNGFhYTA1NGZiID0gTC5tYXJrZXIoCiAgICAgICAgICAgICAgICBbNDAuMDUzMDM1LCAtMTA1LjE5MzA0OF0sCiAgICAgICAgICAgICAgICB7fQogICAgICAgICAgICApLmFkZFRvKG1hcmtlcl9jbHVzdGVyXzJmOGU0M2IwNzQzMjQzNWU5ZWZkYWIyMTlhZDEwZDRmKTsKICAgICAgICAKICAgIAogICAgICAgIHZhciBwb3B1cF82NjMyMTdkMzE4OGI0ZTgxYmI1OTZhNGMzYzlmOTUwMiA9IEwucG9wdXAoeyJtYXhXaWR0aCI6ICIxMDAlIn0pOwoKICAgICAgICAKICAgICAgICAgICAgdmFyIGh0bWxfMzY1NTdlMDIwMTc2NDg5MTkzY2U4ZjY2OTM3ZGEwNDUgPSAkKGA8ZGl2IGlkPSJodG1sXzM2NTU3ZTAyMDE3NjQ4OTE5M2NlOGY2NjkzN2RhMDQ1IiBzdHlsZT0id2lkdGg6IDEwMC4wJTsgaGVpZ2h0OiAxMDAuMCU7Ij5OYW1lOiBCT1VMREVSIENSRUVLIFNVUFBMWSBDQU5BTCBUTyBCT1VMREVSIENSRUVLIE5FQVIgQk9VTERFUiBQcmVjaXA6IDAuMDA8L2Rpdj5gKVswXTsKICAgICAgICAgICAgcG9wdXBfNjYzMjE3ZDMxODhiNGU4MWJiNTk2YTRjM2M5Zjk1MDIuc2V0Q29udGVudChodG1sXzM2NTU3ZTAyMDE3NjQ4OTE5M2NlOGY2NjkzN2RhMDQ1KTsKICAgICAgICAKCiAgICAgICAgbWFya2VyX2YzNGJkOTFhOGE3NjQyMjQ5NDdmODIzNGFhYTA1NGZiLmJpbmRQb3B1cChwb3B1cF82NjMyMTdkMzE4OGI0ZTgxYmI1OTZhNGMzYzlmOTUwMikKICAgICAgICA7CgogICAgICAgIAogICAgCiAgICAKICAgICAgICAgICAgdmFyIG1hcmtlcl9mM2E5M2RiY2VjMzY0MTQ5OGNmMWQzYWE3MDgxZWRlNiA9IEwubWFya2VyKAogICAgICAgICAgICAgICAgWzQwLjI1ODM2NywgLTEwNS4xNzQ5NTddLAogICAgICAgICAgICAgICAge30KICAgICAgICAgICAgKS5hZGRUbyhtYXJrZXJfY2x1c3Rlcl8yZjhlNDNiMDc0MzI0MzVlOWVmZGFiMjE5YWQxMGQ0Zik7CiAgICAgICAgCiAgICAKICAgICAgICB2YXIgcG9wdXBfMTAxZTMwZGY5ZjhkNDk3ZmIwZjhlYWQxZDlhNWQxYWIgPSBMLnBvcHVwKHsibWF4V2lkdGgiOiAiMTAwJSJ9KTsKCiAgICAgICAgCiAgICAgICAgICAgIHZhciBodG1sXzdjOGE5YWNiZTQ0ZTQ3N2ViYTQ2NjBmOTVjODY1ZjJmID0gJChgPGRpdiBpZD0iaHRtbF83YzhhOWFjYmU0NGU0NzdlYmE0NjYwZjk1Yzg2NWYyZiIgc3R5bGU9IndpZHRoOiAxMDAuMCU7IGhlaWdodDogMTAwLjAlOyI+TmFtZTogQk9VTERFUi1MQVJJTUVSIERJVENIIE5FQVIgQkVSVEhPVUQgUHJlY2lwOiAwLjAwPC9kaXY+YClbMF07CiAgICAgICAgICAgIHBvcHVwXzEwMWUzMGRmOWY4ZDQ5N2ZiMGY4ZWFkMWQ5YTVkMWFiLnNldENvbnRlbnQoaHRtbF83YzhhOWFjYmU0NGU0NzdlYmE0NjYwZjk1Yzg2NWYyZik7CiAgICAgICAgCgogICAgICAgIG1hcmtlcl9mM2E5M2RiY2VjMzY0MTQ5OGNmMWQzYWE3MDgxZWRlNi5iaW5kUG9wdXAocG9wdXBfMTAxZTMwZGY5ZjhkNDk3ZmIwZjhlYWQxZDlhNWQxYWIpCiAgICAgICAgOwoKICAgICAgICAKICAgIAogICAgCiAgICAgICAgICAgIHZhciBtYXJrZXJfYTNlMWI0MTNkZjU2NDY5NWFmMWJlMDI2MzRjN2YzYzQgPSBMLm1hcmtlcigKICAgICAgICAgICAgICAgIFszOS45MzgzNTEsIC0xMDUuMzQ3OTA2XSwKICAgICAgICAgICAgICAgIHt9CiAgICAgICAgICAgICkuYWRkVG8obWFya2VyX2NsdXN0ZXJfMmY4ZTQzYjA3NDMyNDM1ZTllZmRhYjIxOWFkMTBkNGYpOwogICAgICAgIAogICAgCiAgICAgICAgdmFyIHBvcHVwXzMwMzE3ODJjZTE5NTQ1Njc5Y2JiN2ZkMTAyM2Q0MTVjID0gTC5wb3B1cCh7Im1heFdpZHRoIjogIjEwMCUifSk7CgogICAgICAgIAogICAgICAgICAgICB2YXIgaHRtbF8wNmVkZWMyYzY4ODk0NGRiODg0NjFlMDk1MjEyNGQ4ZiA9ICQoYDxkaXYgaWQ9Imh0bWxfMDZlZGVjMmM2ODg5NDRkYjg4NDYxZTA5NTIxMjRkOGYiIHN0eWxlPSJ3aWR0aDogMTAwLjAlOyBoZWlnaHQ6IDEwMC4wJTsiPk5hbWU6IFNPVVRIIEJPVUxERVIgQ1JFRUsgQkVMT1cgR1JPU1MgUkVTRVJWT0lSIFByZWNpcDogMTYuNDA8L2Rpdj5gKVswXTsKICAgICAgICAgICAgcG9wdXBfMzAzMTc4MmNlMTk1NDU2NzljYmI3ZmQxMDIzZDQxNWMuc2V0Q29udGVudChodG1sXzA2ZWRlYzJjNjg4OTQ0ZGI4ODQ2MWUwOTUyMTI0ZDhmKTsKICAgICAgICAKCiAgICAgICAgbWFya2VyX2EzZTFiNDEzZGY1NjQ2OTVhZjFiZTAyNjM0YzdmM2M0LmJpbmRQb3B1cChwb3B1cF8zMDMxNzgyY2UxOTU0NTY3OWNiYjdmZDEwMjNkNDE1YykKICAgICAgICA7CgogICAgICAgIAogICAgCiAgICAKICAgICAgICAgICAgdmFyIG1hcmtlcl9kMDFkZTkwY2VkMmY0ZjUxOWQ1YjE5YjhhMjY1MzZmMiA9IEwubWFya2VyKAogICAgICAgICAgICAgICAgWzQwLjIxMjUwNSwgLTEwNS4yNTE4MjZdLAogICAgICAgICAgICAgICAge30KICAgICAgICAgICAgKS5hZGRUbyhtYXJrZXJfY2x1c3Rlcl8yZjhlNDNiMDc0MzI0MzVlOWVmZGFiMjE5YWQxMGQ0Zik7CiAgICAgICAgCiAgICAKICAgICAgICB2YXIgcG9wdXBfYjBiNGJhNzdiNzg4NDBhMzljMjM3ZTI3MzY1YWU1MGMgPSBMLnBvcHVwKHsibWF4V2lkdGgiOiAiMTAwJSJ9KTsKCiAgICAgICAgCiAgICAgICAgICAgIHZhciBodG1sXzE3MDFhM2Y3Njg2MDQ0ODJhMDYxOWM5NTY4YTgzOTgzID0gJChgPGRpdiBpZD0iaHRtbF8xNzAxYTNmNzY4NjA0NDgyYTA2MTljOTU2OGE4Mzk4MyIgc3R5bGU9IndpZHRoOiAxMDAuMCU7IGhlaWdodDogMTAwLjAlOyI+TmFtZTogUEFMTUVSVE9OIERJVENIIFByZWNpcDogMC4yNzwvZGl2PmApWzBdOwogICAgICAgICAgICBwb3B1cF9iMGI0YmE3N2I3ODg0MGEzOWMyMzdlMjczNjVhZTUwYy5zZXRDb250ZW50KGh0bWxfMTcwMWEzZjc2ODYwNDQ4MmEwNjE5Yzk1NjhhODM5ODMpOwogICAgICAgIAoKICAgICAgICBtYXJrZXJfZDAxZGU5MGNlZDJmNGY1MTlkNWIxOWI4YTI2NTM2ZjIuYmluZFBvcHVwKHBvcHVwX2IwYjRiYTc3Yjc4ODQwYTM5YzIzN2UyNzM2NWFlNTBjKQogICAgICAgIDsKCiAgICAgICAgCiAgICAKICAgIAogICAgICAgICAgICB2YXIgbWFya2VyXzI2MmVkNzczNjhjZDQ4Y2VhZWNkMDVmZTI1ODFkNGE2ID0gTC5tYXJrZXIoCiAgICAgICAgICAgICAgICBbNDAuMjE5MDQ2LCAtMTA1LjI1OTc5NV0sCiAgICAgICAgICAgICAgICB7fQogICAgICAgICAgICApLmFkZFRvKG1hcmtlcl9jbHVzdGVyXzJmOGU0M2IwNzQzMjQzNWU5ZWZkYWIyMTlhZDEwZDRmKTsKICAgICAgICAKICAgIAogICAgICAgIHZhciBwb3B1cF9jMWY2ZTNiNzk2NDY0YjYzYmUyNzE3NjQ0YWNjNWRmZSA9IEwucG9wdXAoeyJtYXhXaWR0aCI6ICIxMDAlIn0pOwoKICAgICAgICAKICAgICAgICAgICAgdmFyIGh0bWxfZTMxYmJjNjdlZWFlNDNhZmI3MWZjMzY3Y2I0YjUwOWEgPSAkKGA8ZGl2IGlkPSJodG1sX2UzMWJiYzY3ZWVhZTQzYWZiNzFmYzM2N2NiNGI1MDlhIiBzdHlsZT0id2lkdGg6IDEwMC4wJTsgaGVpZ2h0OiAxMDAuMCU7Ij5OYW1lOiBTVVBQTFkgRElUQ0ggUHJlY2lwOiAwLjAwPC9kaXY+YClbMF07CiAgICAgICAgICAgIHBvcHVwX2MxZjZlM2I3OTY0NjRiNjNiZTI3MTc2NDRhY2M1ZGZlLnNldENvbnRlbnQoaHRtbF9lMzFiYmM2N2VlYWU0M2FmYjcxZmMzNjdjYjRiNTA5YSk7CiAgICAgICAgCgogICAgICAgIG1hcmtlcl8yNjJlZDc3MzY4Y2Q0OGNlYWVjZDA1ZmUyNTgxZDRhNi5iaW5kUG9wdXAocG9wdXBfYzFmNmUzYjc5NjQ2NGI2M2JlMjcxNzY0NGFjYzVkZmUpCiAgICAgICAgOwoKICAgICAgICAKICAgIAogICAgCiAgICAgICAgICAgIHZhciBtYXJrZXJfNjhjYjVmZmRhMzg2NDczYmI4OTgyMGViZjBiYjc1YTkgPSBMLm1hcmtlcigKICAgICAgICAgICAgICAgIFs0MC4xODc1NzgsIC0xMDUuMTg5MTkxXSwKICAgICAgICAgICAgICAgIHt9CiAgICAgICAgICAgICkuYWRkVG8obWFya2VyX2NsdXN0ZXJfMmY4ZTQzYjA3NDMyNDM1ZTllZmRhYjIxOWFkMTBkNGYpOwogICAgICAgIAogICAgCiAgICAgICAgdmFyIHBvcHVwX2E3ODE3MWVhYmM1NTQwN2FiYzlhZDBjMmY3NzA2NmI2ID0gTC5wb3B1cCh7Im1heFdpZHRoIjogIjEwMCUifSk7CgogICAgICAgIAogICAgICAgICAgICB2YXIgaHRtbF8wZTg2NDZjMGI4Njg0NjdlYjM3NjZjYjA3NDAyOGQ5MyA9ICQoYDxkaXYgaWQ9Imh0bWxfMGU4NjQ2YzBiODY4NDY3ZWIzNzY2Y2IwNzQwMjhkOTMiIHN0eWxlPSJ3aWR0aDogMTAwLjAlOyBoZWlnaHQ6IDEwMC4wJTsiPk5hbWU6IERFTklPIFRBWUxPUiBESVRDSCBQcmVjaXA6IDI4MTkuNjg8L2Rpdj5gKVswXTsKICAgICAgICAgICAgcG9wdXBfYTc4MTcxZWFiYzU1NDA3YWJjOWFkMGMyZjc3MDY2YjYuc2V0Q29udGVudChodG1sXzBlODY0NmMwYjg2ODQ2N2ViMzc2NmNiMDc0MDI4ZDkzKTsKICAgICAgICAKCiAgICAgICAgbWFya2VyXzY4Y2I1ZmZkYTM4NjQ3M2JiODk4MjBlYmYwYmI3NWE5LmJpbmRQb3B1cChwb3B1cF9hNzgxNzFlYWJjNTU0MDdhYmM5YWQwYzJmNzcwNjZiNikKICAgICAgICA7CgogICAgICAgIAogICAgCiAgICAKICAgICAgICAgICAgdmFyIG1hcmtlcl84ZDY1ZTU0ZWE2ZjE0MGNhOTFiNmYyMGQzMDQ3ZjAxNSA9IEwubWFya2VyKAogICAgICAgICAgICAgICAgWzQwLjA0MjAyOCwgLTEwNS4zNjQ5MTddLAogICAgICAgICAgICAgICAge30KICAgICAgICAgICAgKS5hZGRUbyhtYXJrZXJfY2x1c3Rlcl8yZjhlNDNiMDc0MzI0MzVlOWVmZGFiMjE5YWQxMGQ0Zik7CiAgICAgICAgCiAgICAKICAgICAgICB2YXIgcG9wdXBfODE5YmNkNmMyZDc5NDczMTk0MjM3ZGRhMTBjYjM2ZjAgPSBMLnBvcHVwKHsibWF4V2lkdGgiOiAiMTAwJSJ9KTsKCiAgICAgICAgCiAgICAgICAgICAgIHZhciBodG1sX2UzZDgyY2NlMTRlNTQ5ZmJiNzIxY2JjMDRiNWM4MDI5ID0gJChgPGRpdiBpZD0iaHRtbF9lM2Q4MmNjZTE0ZTU0OWZiYjcyMWNiYzA0YjVjODAyOSIgc3R5bGU9IndpZHRoOiAxMDAuMCU7IGhlaWdodDogMTAwLjAlOyI+TmFtZTogRk9VUk1JTEUgQ1JFRUsgQVQgTE9HQU4gTUlMTCBST0FEIE5FQVIgQ1JJU01BTiwgQ08gUHJlY2lwOiBuYW48L2Rpdj5gKVswXTsKICAgICAgICAgICAgcG9wdXBfODE5YmNkNmMyZDc5NDczMTk0MjM3ZGRhMTBjYjM2ZjAuc2V0Q29udGVudChodG1sX2UzZDgyY2NlMTRlNTQ5ZmJiNzIxY2JjMDRiNWM4MDI5KTsKICAgICAgICAKCiAgICAgICAgbWFya2VyXzhkNjVlNTRlYTZmMTQwY2E5MWI2ZjIwZDMwNDdmMDE1LmJpbmRQb3B1cChwb3B1cF84MTliY2Q2YzJkNzk0NzMxOTQyMzdkZGExMGNiMzZmMCkKICAgICAgICA7CgogICAgICAgIAogICAgCiAgICAKICAgICAgICAgICAgdmFyIG1hcmtlcl8wYjE5MDM2ZGNiYjk0ZGUxYjkyMTYzOTEwZGFmZmZjNiA9IEwubWFya2VyKAogICAgICAgICAgICAgICAgWzQwLjE3NzA4LCAtMTA1LjE3ODU2N10sCiAgICAgICAgICAgICAgICB7fQogICAgICAgICAgICApLmFkZFRvKG1hcmtlcl9jbHVzdGVyXzJmOGU0M2IwNzQzMjQzNWU5ZWZkYWIyMTlhZDEwZDRmKTsKICAgICAgICAKICAgIAogICAgICAgIHZhciBwb3B1cF84OGZiZmJjNmU5ODM0MTRlODljOGMzYjJhZGI0ZGIyYyA9IEwucG9wdXAoeyJtYXhXaWR0aCI6ICIxMDAlIn0pOwoKICAgICAgICAKICAgICAgICAgICAgdmFyIGh0bWxfNGI2ZmVhZjgzNjkzNDE1YThhYzBlZGZmNGMxOWE2MmEgPSAkKGA8ZGl2IGlkPSJodG1sXzRiNmZlYWY4MzY5MzQxNWE4YWMwZWRmZjRjMTlhNjJhIiBzdHlsZT0id2lkdGg6IDEwMC4wJTsgaGVpZ2h0OiAxMDAuMCU7Ij5OYW1lOiBQRUNLIFBFTExBIENMT1ZFUiBESVRDSCBQcmVjaXA6IDEuNDI8L2Rpdj5gKVswXTsKICAgICAgICAgICAgcG9wdXBfODhmYmZiYzZlOTgzNDE0ZTg5YzhjM2IyYWRiNGRiMmMuc2V0Q29udGVudChodG1sXzRiNmZlYWY4MzY5MzQxNWE4YWMwZWRmZjRjMTlhNjJhKTsKICAgICAgICAKCiAgICAgICAgbWFya2VyXzBiMTkwMzZkY2JiOTRkZTFiOTIxNjM5MTBkYWZmZmM2LmJpbmRQb3B1cChwb3B1cF84OGZiZmJjNmU5ODM0MTRlODljOGMzYjJhZGI0ZGIyYykKICAgICAgICA7CgogICAgICAgIAogICAgCiAgICAKICAgICAgICAgICAgdmFyIG1hcmtlcl80ZjI4MmQ2Yjg5OTM0MGNiYTJlYjI5MTI4OGY0OWYxYiA9IEwubWFya2VyKAogICAgICAgICAgICAgICAgWzM5Ljk0NzcwNCwgLTEwNS4zNTczMDhdLAogICAgICAgICAgICAgICAge30KICAgICAgICAgICAgKS5hZGRUbyhtYXJrZXJfY2x1c3Rlcl8yZjhlNDNiMDc0MzI0MzVlOWVmZGFiMjE5YWQxMGQ0Zik7CiAgICAgICAgCiAgICAKICAgICAgICB2YXIgcG9wdXBfMWQ5MGE5NGUxOGZkNDRiODhiZDFjZTdmMzZlOTE0NzQgPSBMLnBvcHVwKHsibWF4V2lkdGgiOiAiMTAwJSJ9KTsKCiAgICAgICAgCiAgICAgICAgICAgIHZhciBodG1sX2RkYjhiNDU5NzY4YjQ0MGY4NzdkZGFjNTU1YmY4YWUyID0gJChgPGRpdiBpZD0iaHRtbF9kZGI4YjQ1OTc2OGI0NDBmODc3ZGRhYzU1NWJmOGFlMiIgc3R5bGU9IndpZHRoOiAxMDAuMCU7IGhlaWdodDogMTAwLjAlOyI+TmFtZTogR1JPU1MgUkVTRVJWT0lSICBQcmVjaXA6IDExMzY4LjAwPC9kaXY+YClbMF07CiAgICAgICAgICAgIHBvcHVwXzFkOTBhOTRlMThmZDQ0Yjg4YmQxY2U3ZjM2ZTkxNDc0LnNldENvbnRlbnQoaHRtbF9kZGI4YjQ1OTc2OGI0NDBmODc3ZGRhYzU1NWJmOGFlMik7CiAgICAgICAgCgogICAgICAgIG1hcmtlcl80ZjI4MmQ2Yjg5OTM0MGNiYTJlYjI5MTI4OGY0OWYxYi5iaW5kUG9wdXAocG9wdXBfMWQ5MGE5NGUxOGZkNDRiODhiZDFjZTdmMzZlOTE0NzQpCiAgICAgICAgOwoKICAgICAgICAKICAgIAo8L3NjcmlwdD4=" style="position:absolute;width:100%;height:100%;left:0;top:0;border:none !important;" allowfullscreen webkitallowfullscreen mozallowfullscreen></iframe></div></div>





<div class="notice--info" markdown="1">

## Additional Resources

* <a href="https://blog.datafiniti.co/4-reasons-you-should-use-json-instead-of-csv-2cac362f1943" target="_blank">Why you should use JSON instead of csv.</a>


* <a href="https://www.w3schools.com/js/js_json_intro.asp" target="_blank">W3schools JSON intro </a>

</div>

