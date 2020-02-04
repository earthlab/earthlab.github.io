---
layout: single
title: 'Programmatically Accessing Geospatial Data Using APIs'
excerpt: 'This lesson walks through the process of retrieving and manipulating surface water data housed in the Colorado Information Warehouse. These data are stored in JSON format with spatial x, y information that support mapping.'
authors: ['Carson Farmer', 'Leah Wasser', 'Max Joseph', 'Martha Morrissey', 'Jenny Palomino']
modified: 2020-02-01
category: [courses]
class-lesson: ['intro-APIs-python']
permalink: /courses/earth-analytics-python/using-apis-natural-language-processing-twitter/co-water-data-spatial-python/
nav-title: 'Geospatial Data From APIs'
week: 13
sidebar:
    nav:
author_profile: false
comments: true
order: 4
course: "earth-analytics-python"
topics:
    find-and-manage-data: ['apis']
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
      'amount': '0.30',
      'station_type': 'Diversion',
      'wd': '5',
      'http_linkage': {'url': 'https://dwr.state.co.us/SurfaceWater/data/detail_graph.aspx?ID=ZWETURCO&MTYPE=DISCHRG'},
      'date_time': '2020-01-31T19:00:00.000',
      'county': 'BOULDER',
      'variable': 'DISCHRG',
      'stage': '0.08',
      'station_status': 'Active'},
     {'station_name': 'SAINT VRAIN CREEK AT LYONS, CO',
      'div': '1',
      'location': {'latitude': '40.220702',
       'needs_recoding': False,
       'longitude': '-105.26349'},
      'dwr_abbrev': 'SVCLYOCO',
      'data_source': 'Co. Division of Water Resources',
      'usgs_station_id': '06724000',
      'amount': '24.20',
      'station_type': 'Stream',
      'wd': '5',
      'http_linkage': {'url': 'https://dwr.state.co.us/SurfaceWater/data/detail_graph.aspx?ID=SVCLYOCO&MTYPE=DISCHRG'},
      'date_time': '2020-01-31T19:15:00.000',
      'county': 'BOULDER',
      'variable': 'DISCHRG',
      'stage': '2.84',
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
      <td>0.30</td>
      <td>Diversion</td>
      <td>5</td>
      <td>2020-01-31T19:00:00.000</td>
      <td>BOULDER</td>
      <td>DISCHRG</td>
      <td>0.08</td>
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
      <td>24.20</td>
      <td>Stream</td>
      <td>5</td>
      <td>2020-01-31T19:15:00.000</td>
      <td>BOULDER</td>
      <td>DISCHRG</td>
      <td>2.84</td>
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
      <td>33.27</td>
      <td>Diversion</td>
      <td>5</td>
      <td>2020-01-31T18:45:00.000</td>
      <td>BOULDER</td>
      <td>DISCHRG</td>
      <td>0.90</td>
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
      <td>75.20</td>
      <td>Diversion</td>
      <td>6</td>
      <td>2020-01-31T19:30:00.000</td>
      <td>BOULDER</td>
      <td>DISCHRG</td>
      <td>1.33</td>
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
      <td>2020-01-31T19:00:00.000</td>
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



    (49, 18)





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
      <td>0.30</td>
      <td>Diversion</td>
      <td>5</td>
      <td>2020-01-31T19:00:00.000</td>
      <td>BOULDER</td>
      <td>DISCHRG</td>
      <td>0.08</td>
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
      <td>24.20</td>
      <td>Stream</td>
      <td>5</td>
      <td>2020-01-31T19:15:00.000</td>
      <td>BOULDER</td>
      <td>DISCHRG</td>
      <td>2.84</td>
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
      <td>33.27</td>
      <td>Diversion</td>
      <td>5</td>
      <td>2020-01-31T18:45:00.000</td>
      <td>BOULDER</td>
      <td>DISCHRG</td>
      <td>0.90</td>
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
      <td>75.20</td>
      <td>Diversion</td>
      <td>6</td>
      <td>2020-01-31T19:30:00.000</td>
      <td>BOULDER</td>
      <td>DISCHRG</td>
      <td>1.33</td>
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
      <td>2020-01-31T19:00:00.000</td>
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



<div style="width:100%;"><div style="position:relative;width:100%;height:0;padding-bottom:60%;"><iframe src="data:text/html;charset=utf-8;base64,PCFET0NUWVBFIGh0bWw+CjxoZWFkPiAgICAKICAgIDxtZXRhIGh0dHAtZXF1aXY9ImNvbnRlbnQtdHlwZSIgY29udGVudD0idGV4dC9odG1sOyBjaGFyc2V0PVVURi04IiAvPgogICAgCiAgICAgICAgPHNjcmlwdD4KICAgICAgICAgICAgTF9OT19UT1VDSCA9IGZhbHNlOwogICAgICAgICAgICBMX0RJU0FCTEVfM0QgPSBmYWxzZTsKICAgICAgICA8L3NjcmlwdD4KICAgIAogICAgPHNjcmlwdCBzcmM9Imh0dHBzOi8vY2RuLmpzZGVsaXZyLm5ldC9ucG0vbGVhZmxldEAxLjUuMS9kaXN0L2xlYWZsZXQuanMiPjwvc2NyaXB0PgogICAgPHNjcmlwdCBzcmM9Imh0dHBzOi8vY29kZS5qcXVlcnkuY29tL2pxdWVyeS0xLjEyLjQubWluLmpzIj48L3NjcmlwdD4KICAgIDxzY3JpcHQgc3JjPSJodHRwczovL21heGNkbi5ib290c3RyYXBjZG4uY29tL2Jvb3RzdHJhcC8zLjIuMC9qcy9ib290c3RyYXAubWluLmpzIj48L3NjcmlwdD4KICAgIDxzY3JpcHQgc3JjPSJodHRwczovL2NkbmpzLmNsb3VkZmxhcmUuY29tL2FqYXgvbGlicy9MZWFmbGV0LmF3ZXNvbWUtbWFya2Vycy8yLjAuMi9sZWFmbGV0LmF3ZXNvbWUtbWFya2Vycy5qcyI+PC9zY3JpcHQ+CiAgICA8bGluayByZWw9InN0eWxlc2hlZXQiIGhyZWY9Imh0dHBzOi8vY2RuLmpzZGVsaXZyLm5ldC9ucG0vbGVhZmxldEAxLjUuMS9kaXN0L2xlYWZsZXQuY3NzIi8+CiAgICA8bGluayByZWw9InN0eWxlc2hlZXQiIGhyZWY9Imh0dHBzOi8vbWF4Y2RuLmJvb3RzdHJhcGNkbi5jb20vYm9vdHN0cmFwLzMuMi4wL2Nzcy9ib290c3RyYXAubWluLmNzcyIvPgogICAgPGxpbmsgcmVsPSJzdHlsZXNoZWV0IiBocmVmPSJodHRwczovL21heGNkbi5ib290c3RyYXBjZG4uY29tL2Jvb3RzdHJhcC8zLjIuMC9jc3MvYm9vdHN0cmFwLXRoZW1lLm1pbi5jc3MiLz4KICAgIDxsaW5rIHJlbD0ic3R5bGVzaGVldCIgaHJlZj0iaHR0cHM6Ly9tYXhjZG4uYm9vdHN0cmFwY2RuLmNvbS9mb250LWF3ZXNvbWUvNC42LjMvY3NzL2ZvbnQtYXdlc29tZS5taW4uY3NzIi8+CiAgICA8bGluayByZWw9InN0eWxlc2hlZXQiIGhyZWY9Imh0dHBzOi8vY2RuanMuY2xvdWRmbGFyZS5jb20vYWpheC9saWJzL0xlYWZsZXQuYXdlc29tZS1tYXJrZXJzLzIuMC4yL2xlYWZsZXQuYXdlc29tZS1tYXJrZXJzLmNzcyIvPgogICAgPGxpbmsgcmVsPSJzdHlsZXNoZWV0IiBocmVmPSJodHRwczovL3Jhd2Nkbi5naXRoYWNrLmNvbS9weXRob24tdmlzdWFsaXphdGlvbi9mb2xpdW0vbWFzdGVyL2ZvbGl1bS90ZW1wbGF0ZXMvbGVhZmxldC5hd2Vzb21lLnJvdGF0ZS5jc3MiLz4KICAgIDxzdHlsZT5odG1sLCBib2R5IHt3aWR0aDogMTAwJTtoZWlnaHQ6IDEwMCU7bWFyZ2luOiAwO3BhZGRpbmc6IDA7fTwvc3R5bGU+CiAgICA8c3R5bGU+I21hcCB7cG9zaXRpb246YWJzb2x1dGU7dG9wOjA7Ym90dG9tOjA7cmlnaHQ6MDtsZWZ0OjA7fTwvc3R5bGU+CiAgICAKICAgICAgICAgICAgPG1ldGEgbmFtZT0idmlld3BvcnQiIGNvbnRlbnQ9IndpZHRoPWRldmljZS13aWR0aCwKICAgICAgICAgICAgICAgIGluaXRpYWwtc2NhbGU9MS4wLCBtYXhpbXVtLXNjYWxlPTEuMCwgdXNlci1zY2FsYWJsZT1ubyIgLz4KICAgICAgICAgICAgPHN0eWxlPgogICAgICAgICAgICAgICAgI21hcF9lYWI2ZjA4ZDM3NTY0NGUzOWYyMDk5OGJiMTViNTE0YSB7CiAgICAgICAgICAgICAgICAgICAgcG9zaXRpb246IHJlbGF0aXZlOwogICAgICAgICAgICAgICAgICAgIHdpZHRoOiAxMDAuMCU7CiAgICAgICAgICAgICAgICAgICAgaGVpZ2h0OiAxMDAuMCU7CiAgICAgICAgICAgICAgICAgICAgbGVmdDogMC4wJTsKICAgICAgICAgICAgICAgICAgICB0b3A6IDAuMCU7CiAgICAgICAgICAgICAgICB9CiAgICAgICAgICAgIDwvc3R5bGU+CiAgICAgICAgCjwvaGVhZD4KPGJvZHk+ICAgIAogICAgCiAgICAgICAgICAgIDxkaXYgY2xhc3M9ImZvbGl1bS1tYXAiIGlkPSJtYXBfZWFiNmYwOGQzNzU2NDRlMzlmMjA5OThiYjE1YjUxNGEiID48L2Rpdj4KICAgICAgICAKPC9ib2R5Pgo8c2NyaXB0PiAgICAKICAgIAogICAgICAgICAgICB2YXIgbWFwX2VhYjZmMDhkMzc1NjQ0ZTM5ZjIwOTk4YmIxNWI1MTRhID0gTC5tYXAoCiAgICAgICAgICAgICAgICAibWFwX2VhYjZmMDhkMzc1NjQ0ZTM5ZjIwOTk4YmIxNWI1MTRhIiwKICAgICAgICAgICAgICAgIHsKICAgICAgICAgICAgICAgICAgICBjZW50ZXI6IFs0MC4wMSwgLTEwNS4yN10sCiAgICAgICAgICAgICAgICAgICAgY3JzOiBMLkNSUy5FUFNHMzg1NywKICAgICAgICAgICAgICAgICAgICB6b29tOiAxMCwKICAgICAgICAgICAgICAgICAgICB6b29tQ29udHJvbDogdHJ1ZSwKICAgICAgICAgICAgICAgICAgICBwcmVmZXJDYW52YXM6IGZhbHNlLAogICAgICAgICAgICAgICAgfQogICAgICAgICAgICApOwoKICAgICAgICAgICAgCgogICAgICAgIAogICAgCiAgICAgICAgICAgIHZhciB0aWxlX2xheWVyX2IxZGIzOTMxMGQ1ZTQxMzI5ZjdkODMxOWJlZGM4NDQzID0gTC50aWxlTGF5ZXIoCiAgICAgICAgICAgICAgICAiaHR0cHM6Ly9jYXJ0b2RiLWJhc2VtYXBzLXtzfS5nbG9iYWwuc3NsLmZhc3RseS5uZXQvbGlnaHRfYWxsL3t6fS97eH0ve3l9LnBuZyIsCiAgICAgICAgICAgICAgICB7ImF0dHJpYnV0aW9uIjogIlx1MDAyNmNvcHk7IFx1MDAzY2EgaHJlZj1cImh0dHA6Ly93d3cub3BlbnN0cmVldG1hcC5vcmcvY29weXJpZ2h0XCJcdTAwM2VPcGVuU3RyZWV0TWFwXHUwMDNjL2FcdTAwM2UgY29udHJpYnV0b3JzIFx1MDAyNmNvcHk7IFx1MDAzY2EgaHJlZj1cImh0dHA6Ly9jYXJ0b2RiLmNvbS9hdHRyaWJ1dGlvbnNcIlx1MDAzZUNhcnRvREJcdTAwM2MvYVx1MDAzZSwgQ2FydG9EQiBcdTAwM2NhIGhyZWYgPVwiaHR0cDovL2NhcnRvZGIuY29tL2F0dHJpYnV0aW9uc1wiXHUwMDNlYXR0cmlidXRpb25zXHUwMDNjL2FcdTAwM2UiLCAiZGV0ZWN0UmV0aW5hIjogZmFsc2UsICJtYXhOYXRpdmVab29tIjogMTgsICJtYXhab29tIjogMTgsICJtaW5ab29tIjogMCwgIm5vV3JhcCI6IGZhbHNlLCAib3BhY2l0eSI6IDEsICJzdWJkb21haW5zIjogImFiYyIsICJ0bXMiOiBmYWxzZX0KICAgICAgICAgICAgKS5hZGRUbyhtYXBfZWFiNmYwOGQzNzU2NDRlMzlmMjA5OThiYjE1YjUxNGEpOwogICAgICAgIAogICAgCiAgICAgICAgZnVuY3Rpb24gZ2VvX2pzb25fYjhiN2Q1NjUwNGNmNDA4ODhjZWNjNDBhNTQ3MTgxYzNfb25FYWNoRmVhdHVyZShmZWF0dXJlLCBsYXllcikgewogICAgICAgICAgICBsYXllci5vbih7CiAgICAgICAgICAgICAgICBjbGljazogZnVuY3Rpb24oZSkgewogICAgICAgICAgICAgICAgICAgIG1hcF9lYWI2ZjA4ZDM3NTY0NGUzOWYyMDk5OGJiMTViNTE0YS5maXRCb3VuZHMoZS50YXJnZXQuZ2V0Qm91bmRzKCkpOwogICAgICAgICAgICAgICAgfQogICAgICAgICAgICB9KTsKICAgICAgICB9OwogICAgICAgIHZhciBnZW9fanNvbl9iOGI3ZDU2NTA0Y2Y0MDg4OGNlY2M0MGE1NDcxODFjMyA9IEwuZ2VvSnNvbihudWxsLCB7CiAgICAgICAgICAgICAgICBvbkVhY2hGZWF0dXJlOiBnZW9fanNvbl9iOGI3ZDU2NTA0Y2Y0MDg4OGNlY2M0MGE1NDcxODFjM19vbkVhY2hGZWF0dXJlLAogICAgICAgICAgICAKICAgICAgICB9KTsKICAgICAgICBmdW5jdGlvbiBnZW9fanNvbl9iOGI3ZDU2NTA0Y2Y0MDg4OGNlY2M0MGE1NDcxODFjM19hZGQgKGRhdGEpIHsKICAgICAgICAgICAgZ2VvX2pzb25fYjhiN2Q1NjUwNGNmNDA4ODhjZWNjNDBhNTQ3MTgxYzMuYWRkRGF0YShkYXRhKQogICAgICAgICAgICAgICAgLmFkZFRvKG1hcF9lYWI2ZjA4ZDM3NTY0NGUzOWYyMDk5OGJiMTViNTE0YSk7CiAgICAgICAgfQogICAgICAgICAgICBnZW9fanNvbl9iOGI3ZDU2NTA0Y2Y0MDg4OGNlY2M0MGE1NDcxODFjM19hZGQoeyJiYm94IjogWy0xMDUuNTA0NDQsIDM5LjkzMTU5NywgLTEwNS4wNzU2OTUwMDAwMDAwMSwgNDAuMjYwODI3XSwgImZlYXR1cmVzIjogW3siYmJveCI6IFstMTA1LjE4NTc4OSwgNDAuMTg1MDMzLCAtMTA1LjE4NTc4OSwgNDAuMTg1MDMzXSwgImdlb21ldHJ5IjogeyJjb29yZGluYXRlcyI6IFstMTA1LjE4NTc4OSwgNDAuMTg1MDMzXSwgInR5cGUiOiAiUG9pbnQifSwgImlkIjogIjAiLCAicHJvcGVydGllcyI6IHsiYW1vdW50IjogIjAuMzAiLCAiY291bnR5IjogIkJPVUxERVIiLCAiZGF0YV9zb3VyY2UiOiAiQ29vcGVyYXRpdmUgUHJvZ3JhbSBvZiBDRFdSLCBOQ1dDRCBcdTAwMjYgU1ZMSFdDRCIsICJkYXRlX3RpbWUiOiAiMjAyMC0wMS0zMVQxOTowMDowMC4wMDAiLCAiZGl2IjogIjEiLCAiZHdyX2FiYnJldiI6ICJaV0VUVVJDTyIsICJmbGFnIjogbnVsbCwgImh0dHBfbGlua2FnZS51cmwiOiAiaHR0cHM6Ly9kd3Iuc3RhdGUuY28udXMvU3VyZmFjZVdhdGVyL2RhdGEvZGV0YWlsX2dyYXBoLmFzcHg/SUQ9WldFVFVSQ09cdTAwMjZNVFlQRT1ESVNDSFJHIiwgImxvY2F0aW9uLmxhdGl0dWRlIjogNDAuMTg1MDMzLCAibG9jYXRpb24ubG9uZ2l0dWRlIjogLTEwNS4xODU3ODksICJsb2NhdGlvbi5uZWVkc19yZWNvZGluZyI6IGZhbHNlLCAic3RhZ2UiOiAiMC4wOCIsICJzdGF0aW9uX25hbWUiOiAiWldFQ0sgQU5EIFRVUk5FUiBESVRDSCIsICJzdGF0aW9uX3N0YXR1cyI6ICJBY3RpdmUiLCAic3RhdGlvbl90eXBlIjogIkRpdmVyc2lvbiIsICJ1c2dzX3N0YXRpb25faWQiOiBudWxsLCAidmFyaWFibGUiOiAiRElTQ0hSRyIsICJ3ZCI6ICI1In0sICJ0eXBlIjogIkZlYXR1cmUifSwgeyJiYm94IjogWy0xMDUuMjYzNDksIDQwLjIyMDcwMiwgLTEwNS4yNjM0OSwgNDAuMjIwNzAyXSwgImdlb21ldHJ5IjogeyJjb29yZGluYXRlcyI6IFstMTA1LjI2MzQ5LCA0MC4yMjA3MDJdLCAidHlwZSI6ICJQb2ludCJ9LCAiaWQiOiAiMSIsICJwcm9wZXJ0aWVzIjogeyJhbW91bnQiOiAiMjQuMjAiLCAiY291bnR5IjogIkJPVUxERVIiLCAiZGF0YV9zb3VyY2UiOiAiQ28uIERpdmlzaW9uIG9mIFdhdGVyIFJlc291cmNlcyIsICJkYXRlX3RpbWUiOiAiMjAyMC0wMS0zMVQxOToxNTowMC4wMDAiLCAiZGl2IjogIjEiLCAiZHdyX2FiYnJldiI6ICJTVkNMWU9DTyIsICJmbGFnIjogbnVsbCwgImh0dHBfbGlua2FnZS51cmwiOiAiaHR0cHM6Ly9kd3Iuc3RhdGUuY28udXMvU3VyZmFjZVdhdGVyL2RhdGEvZGV0YWlsX2dyYXBoLmFzcHg/SUQ9U1ZDTFlPQ09cdTAwMjZNVFlQRT1ESVNDSFJHIiwgImxvY2F0aW9uLmxhdGl0dWRlIjogNDAuMjIwNzAyLCAibG9jYXRpb24ubG9uZ2l0dWRlIjogLTEwNS4yNjM0OSwgImxvY2F0aW9uLm5lZWRzX3JlY29kaW5nIjogZmFsc2UsICJzdGFnZSI6ICIyLjg0IiwgInN0YXRpb25fbmFtZSI6ICJTQUlOVCBWUkFJTiBDUkVFSyBBVCBMWU9OUywgQ08iLCAic3RhdGlvbl9zdGF0dXMiOiAiQWN0aXZlIiwgInN0YXRpb25fdHlwZSI6ICJTdHJlYW0iLCAidXNnc19zdGF0aW9uX2lkIjogIjA2NzI0MDAwIiwgInZhcmlhYmxlIjogIkRJU0NIUkciLCAid2QiOiAiNSJ9LCAidHlwZSI6ICJGZWF0dXJlIn0sIHsiYmJveCI6IFstMTA1LjIwNjU5MiwgNDAuMTk2NDIyLCAtMTA1LjIwNjU5MiwgNDAuMTk2NDIyXSwgImdlb21ldHJ5IjogeyJjb29yZGluYXRlcyI6IFstMTA1LjIwNjU5MiwgNDAuMTk2NDIyXSwgInR5cGUiOiAiUG9pbnQifSwgImlkIjogIjIiLCAicHJvcGVydGllcyI6IHsiYW1vdW50IjogIjMzLjI3IiwgImNvdW50eSI6ICJCT1VMREVSIiwgImRhdGFfc291cmNlIjogIkNvb3BlcmF0aXZlIFByb2dyYW0gb2YgQ0RXUiwgTkNXQ0QgXHUwMDI2IFNWTEhXQ0QiLCAiZGF0ZV90aW1lIjogIjIwMjAtMDEtMzFUMTg6NDU6MDAuMDAwIiwgImRpdiI6ICIxIiwgImR3cl9hYmJyZXYiOiAiT0xJRElUQ08iLCAiZmxhZyI6IG51bGwsICJodHRwX2xpbmthZ2UudXJsIjogImh0dHBzOi8vZHdyLnN0YXRlLmNvLnVzL1N1cmZhY2VXYXRlci9kYXRhL2RldGFpbF9ncmFwaC5hc3B4P0lEPU9MSURJVENPXHUwMDI2TVRZUEU9RElTQ0hSRyIsICJsb2NhdGlvbi5sYXRpdHVkZSI6IDQwLjE5NjQyMiwgImxvY2F0aW9uLmxvbmdpdHVkZSI6IC0xMDUuMjA2NTkyLCAibG9jYXRpb24ubmVlZHNfcmVjb2RpbmciOiBmYWxzZSwgInN0YWdlIjogIjAuOTAiLCAic3RhdGlvbl9uYW1lIjogIk9MSUdBUkNIWSBESVRDSCBESVZFUlNJT04iLCAic3RhdGlvbl9zdGF0dXMiOiAiQWN0aXZlIiwgInN0YXRpb25fdHlwZSI6ICJEaXZlcnNpb24iLCAidXNnc19zdGF0aW9uX2lkIjogbnVsbCwgInZhcmlhYmxlIjogIkRJU0NIUkciLCAid2QiOiAiNSJ9LCAidHlwZSI6ICJGZWF0dXJlIn0sIHsiYmJveCI6IFstMTA1LjMwODQzMiwgMzkuOTMxODEzLCAtMTA1LjMwODQzMiwgMzkuOTMxODEzXSwgImdlb21ldHJ5IjogeyJjb29yZGluYXRlcyI6IFstMTA1LjMwODQzMiwgMzkuOTMxODEzXSwgInR5cGUiOiAiUG9pbnQifSwgImlkIjogIjMiLCAicHJvcGVydGllcyI6IHsiYW1vdW50IjogIjc1LjIwIiwgImNvdW50eSI6ICJCT1VMREVSIiwgImRhdGFfc291cmNlIjogIkNvLiBEaXZpc2lvbiBvZiBXYXRlciBSZXNvdXJjZXMiLCAiZGF0ZV90aW1lIjogIjIwMjAtMDEtMzFUMTk6MzA6MDAuMDAwIiwgImRpdiI6ICIxIiwgImR3cl9hYmJyZXYiOiAiQk9TREVMQ08iLCAiZmxhZyI6IG51bGwsICJodHRwX2xpbmthZ2UudXJsIjogImh0dHBzOi8vZHdyLnN0YXRlLmNvLnVzL1N1cmZhY2VXYXRlci9kYXRhL2RldGFpbF9ncmFwaC5hc3B4P0lEPUJPU0RFTENPXHUwMDI2TVRZUEU9RElTQ0hSRyIsICJsb2NhdGlvbi5sYXRpdHVkZSI6IDM5LjkzMTgxMywgImxvY2F0aW9uLmxvbmdpdHVkZSI6IC0xMDUuMzA4NDMyLCAibG9jYXRpb24ubmVlZHNfcmVjb2RpbmciOiBmYWxzZSwgInN0YWdlIjogIjEuMzMiLCAic3RhdGlvbl9uYW1lIjogIlNPVVRIIEJPVUxERVIgQ1JFRUsgRElWRVJTSU9OIE5FQVIgRUxET1JBRE8gU1BSSU5HUyIsICJzdGF0aW9uX3N0YXR1cyI6ICJBY3RpdmUiLCAic3RhdGlvbl90eXBlIjogIkRpdmVyc2lvbiIsICJ1c2dzX3N0YXRpb25faWQiOiBudWxsLCAidmFyaWFibGUiOiAiRElTQ0hSRyIsICJ3ZCI6ICI2In0sICJ0eXBlIjogIkZlYXR1cmUifSwgeyJiYm94IjogWy0xMDUuMjEwMzksIDQwLjE5Mzc1OCwgLTEwNS4yMTAzOSwgNDAuMTkzNzU4XSwgImdlb21ldHJ5IjogeyJjb29yZGluYXRlcyI6IFstMTA1LjIxMDM5LCA0MC4xOTM3NThdLCAidHlwZSI6ICJQb2ludCJ9LCAiaWQiOiAiNCIsICJwcm9wZXJ0aWVzIjogeyJhbW91bnQiOiAiMC4wMCIsICJjb3VudHkiOiAiQk9VTERFUiIsICJkYXRhX3NvdXJjZSI6ICJDb29wZXJhdGl2ZSBQcm9ncmFtIG9mIENEV1IsIE5DV0NEIFx1MDAyNiBTVkxIV0NEIiwgImRhdGVfdGltZSI6ICIyMDIwLTAxLTMxVDE5OjAwOjAwLjAwMCIsICJkaXYiOiAiMSIsICJkd3JfYWJicmV2IjogIkNMT0RJVENPIiwgImZsYWciOiBudWxsLCAiaHR0cF9saW5rYWdlLnVybCI6ICJodHRwczovL2R3ci5zdGF0ZS5jby51cy9TdXJmYWNlV2F0ZXIvZGF0YS9kZXRhaWxfZ3JhcGguYXNweD9JRD1DTE9ESVRDT1x1MDAyNk1UWVBFPURJU0NIUkciLCAibG9jYXRpb24ubGF0aXR1ZGUiOiA0MC4xOTM3NTgsICJsb2NhdGlvbi5sb25naXR1ZGUiOiAtMTA1LjIxMDM5LCAibG9jYXRpb24ubmVlZHNfcmVjb2RpbmciOiBmYWxzZSwgInN0YWdlIjogbnVsbCwgInN0YXRpb25fbmFtZSI6ICJDTE9VR0ggQU5EIFRSVUUgRElUQ0giLCAic3RhdGlvbl9zdGF0dXMiOiAiQWN0aXZlIiwgInN0YXRpb25fdHlwZSI6ICJEaXZlcnNpb24iLCAidXNnc19zdGF0aW9uX2lkIjogbnVsbCwgInZhcmlhYmxlIjogIkRJU0NIUkciLCAid2QiOiAiNSJ9LCAidHlwZSI6ICJGZWF0dXJlIn0sIHsiYmJveCI6IFstMTA1LjMzMDg0MSwgNDAuMDA2MzgwMDAwMDAwMDEsIC0xMDUuMzMwODQxLCA0MC4wMDYzODAwMDAwMDAwMV0sICJnZW9tZXRyeSI6IHsiY29vcmRpbmF0ZXMiOiBbLTEwNS4zMzA4NDEsIDQwLjAwNjM4MDAwMDAwMDAxXSwgInR5cGUiOiAiUG9pbnQifSwgImlkIjogIjUiLCAicHJvcGVydGllcyI6IHsiYW1vdW50IjogIjEyLjQwIiwgImNvdW50eSI6ICJCT1VMREVSIiwgImRhdGFfc291cmNlIjogIkNvLiBEaXZpc2lvbiBvZiBXYXRlciBSZXNvdXJjZXMiLCAiZGF0ZV90aW1lIjogIjIwMjAtMDEtMzFUMTk6MTU6MDAuMDAwIiwgImRpdiI6ICIxIiwgImR3cl9hYmJyZXYiOiAiQk9DT1JPQ08iLCAiZmxhZyI6ICJJY2UiLCAiaHR0cF9saW5rYWdlLnVybCI6ICJodHRwczovL2R3ci5zdGF0ZS5jby51cy9TdXJmYWNlV2F0ZXIvZGF0YS9kZXRhaWxfZ3JhcGguYXNweD9JRD1CT0NPUk9DT1x1MDAyNk1UWVBFPURJU0NIUkciLCAibG9jYXRpb24ubGF0aXR1ZGUiOiA0MC4wMDYzOCwgImxvY2F0aW9uLmxvbmdpdHVkZSI6IC0xMDUuMzMwODQxLCAibG9jYXRpb24ubmVlZHNfcmVjb2RpbmciOiBmYWxzZSwgInN0YWdlIjogIjEuOTEiLCAic3RhdGlvbl9uYW1lIjogIkJPVUxERVIgQ1JFRUsgTkVBUiBPUk9ERUxMLCBDTy4iLCAic3RhdGlvbl9zdGF0dXMiOiAiQWN0aXZlIiwgInN0YXRpb25fdHlwZSI6ICJTdHJlYW0iLCAidXNnc19zdGF0aW9uX2lkIjogIjA2NzI3MDAwIiwgInZhcmlhYmxlIjogIkRJU0NIUkciLCAid2QiOiAiNiJ9LCAidHlwZSI6ICJGZWF0dXJlIn0sIHsiYmJveCI6IFstMTA1LjIxODc3NywgNDAuMjA0MTkzLCAtMTA1LjIxODc3NywgNDAuMjA0MTkzXSwgImdlb21ldHJ5IjogeyJjb29yZGluYXRlcyI6IFstMTA1LjIxODc3NywgNDAuMjA0MTkzXSwgInR5cGUiOiAiUG9pbnQifSwgImlkIjogIjYiLCAicHJvcGVydGllcyI6IHsiYW1vdW50IjogIjAuMDAiLCAiY291bnR5IjogIkJPVUxERVIiLCAiZGF0YV9zb3VyY2UiOiAiQ29vcGVyYXRpdmUgUHJvZ3JhbSBvZiBDRFdSLCBOQ1dDRCBcdTAwMjYgU1ZMSFdDRCIsICJkYXRlX3RpbWUiOiAiMjAyMC0wMS0zMVQxOTowMDowMC4wMDAiLCAiZGl2IjogIjEiLCAiZHdyX2FiYnJldiI6ICJMT05TVVBDTyIsICJmbGFnIjogbnVsbCwgImh0dHBfbGlua2FnZS51cmwiOiAiaHR0cHM6Ly9kd3Iuc3RhdGUuY28udXMvU3VyZmFjZVdhdGVyL2RhdGEvZGV0YWlsX2dyYXBoLmFzcHg/SUQ9TE9OU1VQQ09cdTAwMjZNVFlQRT1ESVNDSFJHIiwgImxvY2F0aW9uLmxhdGl0dWRlIjogNDAuMjA0MTkzLCAibG9jYXRpb24ubG9uZ2l0dWRlIjogLTEwNS4yMTg3NzcsICJsb2NhdGlvbi5uZWVkc19yZWNvZGluZyI6IGZhbHNlLCAic3RhZ2UiOiBudWxsLCAic3RhdGlvbl9uYW1lIjogIkxPTkdNT05UIFNVUFBMWSBESVRDSCIsICJzdGF0aW9uX3N0YXR1cyI6ICJBY3RpdmUiLCAic3RhdGlvbl90eXBlIjogIkRpdmVyc2lvbiIsICJ1c2dzX3N0YXRpb25faWQiOiBudWxsLCAidmFyaWFibGUiOiAiRElTQ0hSRyIsICJ3ZCI6ICI1In0sICJ0eXBlIjogIkZlYXR1cmUifSwgeyJiYm94IjogWy0xMDUuMTY3NjIyLCA0MC4xNzI5MjUsIC0xMDUuMTY3NjIyLCA0MC4xNzI5MjVdLCAiZ2VvbWV0cnkiOiB7ImNvb3JkaW5hdGVzIjogWy0xMDUuMTY3NjIyLCA0MC4xNzI5MjVdLCAidHlwZSI6ICJQb2ludCJ9LCAiaWQiOiAiNyIsICJwcm9wZXJ0aWVzIjogeyJhbW91bnQiOiAiMC4wMCIsICJjb3VudHkiOiAiQk9VTERFUiIsICJkYXRhX3NvdXJjZSI6ICJDb29wZXJhdGl2ZSBTRFIgUHJvZ3JhbSBvZiBDRFdSIFx1MDAyNiBOQ1dDRCIsICJkYXRlX3RpbWUiOiAiMjAyMC0wMS0zMVQxOTowMDowMC4wMDAiLCAiZGl2IjogIjEiLCAiZHdyX2FiYnJldiI6ICJOT1JNVVRDTyIsICJmbGFnIjogbnVsbCwgImh0dHBfbGlua2FnZS51cmwiOiAiaHR0cHM6Ly9kd3Iuc3RhdGUuY28udXMvU3VyZmFjZVdhdGVyL2RhdGEvZGV0YWlsX2dyYXBoLmFzcHg/SUQ9Tk9STVVUQ09cdTAwMjZNVFlQRT1ESVNDSFJHIiwgImxvY2F0aW9uLmxhdGl0dWRlIjogNDAuMTcyOTI1LCAibG9jYXRpb24ubG9uZ2l0dWRlIjogLTEwNS4xNjc2MjIsICJsb2NhdGlvbi5uZWVkc19yZWNvZGluZyI6IGZhbHNlLCAic3RhZ2UiOiBudWxsLCAic3RhdGlvbl9uYW1lIjogIk5PUlRIV0VTVCBNVVRVQUwgRElUQ0giLCAic3RhdGlvbl9zdGF0dXMiOiAiQWN0aXZlIiwgInN0YXRpb25fdHlwZSI6ICJEaXZlcnNpb24iLCAidXNnc19zdGF0aW9uX2lkIjogbnVsbCwgInZhcmlhYmxlIjogIkRJU0NIUkciLCAid2QiOiAiNSJ9LCAidHlwZSI6ICJGZWF0dXJlIn0sIHsiYmJveCI6IFstMTA1LjEzMDgxOSwgNDAuMTM0Mjc4LCAtMTA1LjEzMDgxOSwgNDAuMTM0Mjc4XSwgImdlb21ldHJ5IjogeyJjb29yZGluYXRlcyI6IFstMTA1LjEzMDgxOSwgNDAuMTM0Mjc4XSwgInR5cGUiOiAiUG9pbnQifSwgImlkIjogIjgiLCAicHJvcGVydGllcyI6IHsiYW1vdW50IjogIjUuNTAiLCAiY291bnR5IjogIkJPVUxERVIiLCAiZGF0YV9zb3VyY2UiOiAiVS5TLiBHZW9sb2dpY2FsIFN1cnZleSIsICJkYXRlX3RpbWUiOiAiMjAyMC0wMS0zMVQxOToxMDowMC4wMDAiLCAiZGl2IjogIjEiLCAiZHdyX2FiYnJldiI6ICJMRUZUSE9DTyIsICJmbGFnIjogbnVsbCwgImh0dHBfbGlua2FnZS51cmwiOiAiaHR0cHM6Ly93YXRlcmRhdGEudXNncy5nb3Yvbndpcy91dj8wNjcyNDk3MCIsICJsb2NhdGlvbi5sYXRpdHVkZSI6IDQwLjEzNDI3OCwgImxvY2F0aW9uLmxvbmdpdHVkZSI6IC0xMDUuMTMwODE5LCAibG9jYXRpb24ubmVlZHNfcmVjb2RpbmciOiBmYWxzZSwgInN0YWdlIjogbnVsbCwgInN0YXRpb25fbmFtZSI6ICJMRUZUIEhBTkQgQ1JFRUsgQVQgSE9WRVIgUk9BRCBORUFSIExPTkdNT05ULCBDTyIsICJzdGF0aW9uX3N0YXR1cyI6ICJBY3RpdmUiLCAic3RhdGlvbl90eXBlIjogIlN0cmVhbSIsICJ1c2dzX3N0YXRpb25faWQiOiAiMDY3MjQ5NzAiLCAidmFyaWFibGUiOiAiRElTQ0hSRyIsICJ3ZCI6ICI1In0sICJ0eXBlIjogIkZlYXR1cmUifSwgeyJiYm94IjogWy0xMDUuMjE4Njc3LCAzOS45ODYxNjksIC0xMDUuMjE4Njc3LCAzOS45ODYxNjldLCAiZ2VvbWV0cnkiOiB7ImNvb3JkaW5hdGVzIjogWy0xMDUuMjE4Njc3LCAzOS45ODYxNjldLCAidHlwZSI6ICJQb2ludCJ9LCAiaWQiOiAiOSIsICJwcm9wZXJ0aWVzIjogeyJhbW91bnQiOiAiMS42OSIsICJjb3VudHkiOiAiQk9VTERFUiIsICJkYXRhX3NvdXJjZSI6ICJDb29wZXJhdGl2ZSBQcm9ncmFtIG9mIENEV1IsIE5DV0NEIFx1MDAyNiBMU1BXQ0QiLCAiZGF0ZV90aW1lIjogIjIwMjAtMDEtMzFUMTk6MDA6MDAuMDAwIiwgImRpdiI6ICIxIiwgImR3cl9hYmJyZXYiOiAiRFJZQ0FSQ08iLCAiZmxhZyI6IG51bGwsICJodHRwX2xpbmthZ2UudXJsIjogImh0dHBzOi8vZHdyLnN0YXRlLmNvLnVzL1N1cmZhY2VXYXRlci9kYXRhL2RldGFpbF9ncmFwaC5hc3B4P0lEPURSWUNBUkNPXHUwMDI2TVRZUEU9RElTQ0hSRyIsICJsb2NhdGlvbi5sYXRpdHVkZSI6IDM5Ljk4NjE2OSwgImxvY2F0aW9uLmxvbmdpdHVkZSI6IC0xMDUuMjE4Njc3LCAibG9jYXRpb24ubmVlZHNfcmVjb2RpbmciOiBmYWxzZSwgInN0YWdlIjogIjAuMTQiLCAic3RhdGlvbl9uYW1lIjogIkRSWSBDUkVFSyBDQVJSSUVSIiwgInN0YXRpb25fc3RhdHVzIjogIkFjdGl2ZSIsICJzdGF0aW9uX3R5cGUiOiAiRGl2ZXJzaW9uIiwgInVzZ3Nfc3RhdGlvbl9pZCI6IG51bGwsICJ2YXJpYWJsZSI6ICJESVNDSFJHIiwgIndkIjogIjYifSwgInR5cGUiOiAiRmVhdHVyZSJ9LCB7ImJib3giOiBbLTEwNS4xNjg0NzEsIDQwLjE2MDcwNSwgLTEwNS4xNjg0NzEsIDQwLjE2MDcwNV0sICJnZW9tZXRyeSI6IHsiY29vcmRpbmF0ZXMiOiBbLTEwNS4xNjg0NzEsIDQwLjE2MDcwNV0sICJ0eXBlIjogIlBvaW50In0sICJpZCI6ICIxMCIsICJwcm9wZXJ0aWVzIjogeyJhbW91bnQiOiAiMC4wMCIsICJjb3VudHkiOiAiQk9VTERFUiIsICJkYXRhX3NvdXJjZSI6ICJDby4gRGl2aXNpb24gb2YgV2F0ZXIgUmVzb3VyY2VzIiwgImRhdGVfdGltZSI6ICIyMDIwLTAxLTMxVDE3OjQ1OjAwLjAwMCIsICJkaXYiOiAiMSIsICJkd3JfYWJicmV2IjogIlBFQ1JUTkNPIiwgImZsYWciOiBudWxsLCAiaHR0cF9saW5rYWdlLnVybCI6ICJodHRwczovL2R3ci5zdGF0ZS5jby51cy9TdXJmYWNlV2F0ZXIvZGF0YS9kZXRhaWxfZ3JhcGguYXNweD9JRD1QRUNSVE5DT1x1MDAyNk1UWVBFPURJU0NIUkciLCAibG9jYXRpb24ubGF0aXR1ZGUiOiA0MC4xNjA3MDUsICJsb2NhdGlvbi5sb25naXR1ZGUiOiAtMTA1LjE2ODQ3MSwgImxvY2F0aW9uLm5lZWRzX3JlY29kaW5nIjogZmFsc2UsICJzdGFnZSI6IG51bGwsICJzdGF0aW9uX25hbWUiOiAiUEVDSy1QRUxMQSBBVUdNRU5UQVRJT04gUkVUVVJOIiwgInN0YXRpb25fc3RhdHVzIjogIkFjdGl2ZSIsICJzdGF0aW9uX3R5cGUiOiAiRGl2ZXJzaW9uIiwgInVzZ3Nfc3RhdGlvbl9pZCI6IG51bGwsICJ2YXJpYWJsZSI6ICJESVNDSFJHIiwgIndkIjogIjUifSwgInR5cGUiOiAiRmVhdHVyZSJ9LCB7ImJib3giOiBbLTEwNS4yMjI2MzksIDQwLjE5OTMyMSwgLTEwNS4yMjI2MzksIDQwLjE5OTMyMV0sICJnZW9tZXRyeSI6IHsiY29vcmRpbmF0ZXMiOiBbLTEwNS4yMjI2MzksIDQwLjE5OTMyMV0sICJ0eXBlIjogIlBvaW50In0sICJpZCI6ICIxMSIsICJwcm9wZXJ0aWVzIjogeyJhbW91bnQiOiAiMC4wMCIsICJjb3VudHkiOiAiQk9VTERFUiIsICJkYXRhX3NvdXJjZSI6ICJDb29wZXJhdGl2ZSBQcm9ncmFtIG9mIENEV1IsIE5DV0NEIFx1MDAyNiBTVkxIV0NEIiwgImRhdGVfdGltZSI6ICIyMDIwLTAxLTMxVDE5OjAwOjAwLjAwMCIsICJkaXYiOiAiMSIsICJkd3JfYWJicmV2IjogIkdPRElUMUNPIiwgImZsYWciOiBudWxsLCAiaHR0cF9saW5rYWdlLnVybCI6ICJodHRwczovL2R3ci5zdGF0ZS5jby51cy9TdXJmYWNlV2F0ZXIvZGF0YS9kZXRhaWxfZ3JhcGguYXNweD9JRD1HT0RJVDFDT1x1MDAyNk1UWVBFPURJU0NIUkciLCAibG9jYXRpb24ubGF0aXR1ZGUiOiA0MC4xOTkzMjEsICJsb2NhdGlvbi5sb25naXR1ZGUiOiAtMTA1LjIyMjYzOSwgImxvY2F0aW9uLm5lZWRzX3JlY29kaW5nIjogZmFsc2UsICJzdGFnZSI6IG51bGwsICJzdGF0aW9uX25hbWUiOiAiR09TUyBESVRDSCAxIiwgInN0YXRpb25fc3RhdHVzIjogIkFjdGl2ZSIsICJzdGF0aW9uX3R5cGUiOiAiRGl2ZXJzaW9uIiwgInVzZ3Nfc3RhdGlvbl9pZCI6IG51bGwsICJ2YXJpYWJsZSI6ICJESVNDSFJHIiwgIndkIjogIjUifSwgInR5cGUiOiAiRmVhdHVyZSJ9LCB7ImJib3giOiBbLTEwNS4yMTA0MjQsIDQwLjE5MzI4MDAwMDAwMDAxLCAtMTA1LjIxMDQyNCwgNDAuMTkzMjgwMDAwMDAwMDFdLCAiZ2VvbWV0cnkiOiB7ImNvb3JkaW5hdGVzIjogWy0xMDUuMjEwNDI0LCA0MC4xOTMyODAwMDAwMDAwMV0sICJ0eXBlIjogIlBvaW50In0sICJpZCI6ICIxMiIsICJwcm9wZXJ0aWVzIjogeyJhbW91bnQiOiAiMC4wMCIsICJjb3VudHkiOiAiQk9VTERFUiIsICJkYXRhX3NvdXJjZSI6ICJDb29wZXJhdGl2ZSBQcm9ncmFtIG9mIENEV1IsIE5DV0NEIFx1MDAyNiBTVkxIV0NEIiwgImRhdGVfdGltZSI6ICIyMDIwLTAxLTMxVDE5OjAwOjAwLjAwMCIsICJkaXYiOiAiMSIsICJkd3JfYWJicmV2IjogIldFQkRJVENPIiwgImZsYWciOiBudWxsLCAiaHR0cF9saW5rYWdlLnVybCI6ICJodHRwczovL2R3ci5zdGF0ZS5jby51cy9TdXJmYWNlV2F0ZXIvZGF0YS9kZXRhaWxfZ3JhcGguYXNweD9JRD1XRUJESVRDT1x1MDAyNk1UWVBFPURJU0NIUkciLCAibG9jYXRpb24ubGF0aXR1ZGUiOiA0MC4xOTMyOCwgImxvY2F0aW9uLmxvbmdpdHVkZSI6IC0xMDUuMjEwNDI0LCAibG9jYXRpb24ubmVlZHNfcmVjb2RpbmciOiBmYWxzZSwgInN0YWdlIjogbnVsbCwgInN0YXRpb25fbmFtZSI6ICJXRUJTVEVSIE1DQ0FTTElOIERJVENIIiwgInN0YXRpb25fc3RhdHVzIjogIkFjdGl2ZSIsICJzdGF0aW9uX3R5cGUiOiAiRGl2ZXJzaW9uIiwgInVzZ3Nfc3RhdGlvbl9pZCI6IG51bGwsICJ2YXJpYWJsZSI6ICJESVNDSFJHIiwgIndkIjogIjUifSwgInR5cGUiOiAiRmVhdHVyZSJ9LCB7ImJib3giOiBbLTEwNS4xNTExNDMsIDQwLjA1MzY2MSwgLTEwNS4xNTExNDMsIDQwLjA1MzY2MV0sICJnZW9tZXRyeSI6IHsiY29vcmRpbmF0ZXMiOiBbLTEwNS4xNTExNDMsIDQwLjA1MzY2MV0sICJ0eXBlIjogIlBvaW50In0sICJpZCI6ICIxMyIsICJwcm9wZXJ0aWVzIjogeyJhbW91bnQiOiAiMjYuNTYiLCAiY291bnR5IjogIkJPVUxERVIiLCAiZGF0YV9zb3VyY2UiOiAiQ29vcGVyYXRpdmUgUHJvZ3JhbSBvZiBDRFdSLCBOQ1dDRCBcdTAwMjYgTFNQV0NEIiwgImRhdGVfdGltZSI6ICIyMDIwLTAxLTMxVDE5OjAwOjAwLjAwMCIsICJkaXYiOiAiMSIsICJkd3JfYWJicmV2IjogIkxFR0RJVENPIiwgImZsYWciOiBudWxsLCAiaHR0cF9saW5rYWdlLnVybCI6ICJodHRwczovL2R3ci5zdGF0ZS5jby51cy9TdXJmYWNlV2F0ZXIvZGF0YS9kZXRhaWxfZ3JhcGguYXNweD9JRD1MRUdESVRDT1x1MDAyNk1UWVBFPURJU0NIUkciLCAibG9jYXRpb24ubGF0aXR1ZGUiOiA0MC4wNTM2NjEsICJsb2NhdGlvbi5sb25naXR1ZGUiOiAtMTA1LjE1MTE0MywgImxvY2F0aW9uLm5lZWRzX3JlY29kaW5nIjogZmFsc2UsICJzdGFnZSI6ICIwLjg5IiwgInN0YXRpb25fbmFtZSI6ICJMRUdHRVRUIERJVENIIiwgInN0YXRpb25fc3RhdHVzIjogIkFjdGl2ZSIsICJzdGF0aW9uX3R5cGUiOiAiRGl2ZXJzaW9uIiwgInVzZ3Nfc3RhdGlvbl9pZCI6IG51bGwsICJ2YXJpYWJsZSI6ICJESVNDSFJHIiwgIndkIjogIjYifSwgInR5cGUiOiAiRmVhdHVyZSJ9LCB7ImJib3giOiBbLTEwNS4zNjUzNjUsIDQwLjIxNjI2MywgLTEwNS4zNjUzNjUsIDQwLjIxNjI2M10sICJnZW9tZXRyeSI6IHsiY29vcmRpbmF0ZXMiOiBbLTEwNS4zNjUzNjUsIDQwLjIxNjI2M10sICJ0eXBlIjogIlBvaW50In0sICJpZCI6ICIxNCIsICJwcm9wZXJ0aWVzIjogeyJhbW91bnQiOiAiMTQwMzQuMDAiLCAiY291bnR5IjogIkJPVUxERVIiLCAiZGF0YV9zb3VyY2UiOiAiQ28uIERpdmlzaW9uIG9mIFdhdGVyIFJlc291cmNlcyIsICJkYXRlX3RpbWUiOiAiMjAyMC0wMS0zMVQxOTo0NTowMC4wMDAiLCAiZGl2IjogIjEiLCAiZHdyX2FiYnJldiI6ICJCUktEQU1DTyIsICJmbGFnIjogbnVsbCwgImh0dHBfbGlua2FnZS51cmwiOiAiaHR0cHM6Ly9kd3Iuc3RhdGUuY28udXMvU3VyZmFjZVdhdGVyL2RhdGEvZGV0YWlsX2dyYXBoLmFzcHg/SUQ9QlJLREFNQ09cdTAwMjZNVFlQRT1TVE9SQUdFIiwgImxvY2F0aW9uLmxhdGl0dWRlIjogNDAuMjE2MjYzLCAibG9jYXRpb24ubG9uZ2l0dWRlIjogLTEwNS4zNjUzNjUsICJsb2NhdGlvbi5uZWVkc19yZWNvZGluZyI6IGZhbHNlLCAic3RhZ2UiOiAiNjM4OS44MiIsICJzdGF0aW9uX25hbWUiOiAiQlVUVE9OUk9DSyAoUkFMUEggUFJJQ0UpIFJFU0VSVk9JUiIsICJzdGF0aW9uX3N0YXR1cyI6ICJBY3RpdmUiLCAic3RhdGlvbl90eXBlIjogIlJlc2Vydm9pciIsICJ1c2dzX3N0YXRpb25faWQiOiBudWxsLCAidmFyaWFibGUiOiAiU1RPUkFHRSIsICJ3ZCI6ICI1In0sICJ0eXBlIjogIkZlYXR1cmUifSwgeyJiYm94IjogWy0xMDUuMjA5NSwgNDAuMjU1Nzc2LCAtMTA1LjIwOTUsIDQwLjI1NTc3Nl0sICJnZW9tZXRyeSI6IHsiY29vcmRpbmF0ZXMiOiBbLTEwNS4yMDk1LCA0MC4yNTU3NzZdLCAidHlwZSI6ICJQb2ludCJ9LCAiaWQiOiAiMTUiLCAicHJvcGVydGllcyI6IHsiYW1vdW50IjogIjAuMDEiLCAiY291bnR5IjogIkJPVUxERVIiLCAiZGF0YV9zb3VyY2UiOiAiTm9ydGhlcm4gQ29sb3JhZG8gV2F0ZXIgQ29uc2VydmFuY3kgRGlzdHJpY3QiLCAiZGF0ZV90aW1lIjogIjIwMjAtMDEtMzFUMTk6MDA6MDAuMDAwIiwgImRpdiI6ICIxIiwgImR3cl9hYmJyZXYiOiAiTElUVEgyQ08iLCAiZmxhZyI6IG51bGwsICJodHRwX2xpbmthZ2UudXJsIjogImh0dHA6Ly93d3cubm9ydGhlcm53YXRlci5vcmcvV2F0ZXJQcm9qZWN0cy9XYXRlckRhdGEuYXNweEVhc3RTbG9wZVdhdGVyRGF0YS5hc3B4IiwgImxvY2F0aW9uLmxhdGl0dWRlIjogNDAuMjU1Nzc2LCAibG9jYXRpb24ubG9uZ2l0dWRlIjogLTEwNS4yMDk1LCAibG9jYXRpb24ubmVlZHNfcmVjb2RpbmciOiBmYWxzZSwgInN0YWdlIjogIjAuMDEiLCAic3RhdGlvbl9uYW1lIjogIkxJVFRMRSBUSE9NUFNPTiAjMiBESVRDSCIsICJzdGF0aW9uX3N0YXR1cyI6ICJBY3RpdmUiLCAic3RhdGlvbl90eXBlIjogIkRpdmVyc2lvbiIsICJ1c2dzX3N0YXRpb25faWQiOiAiRVMxOTAwIiwgInZhcmlhYmxlIjogIkRJU0NIUkciLCAid2QiOiAiNCJ9LCAidHlwZSI6ICJGZWF0dXJlIn0sIHsiYmJveCI6IFstMTA1LjE2NDM5NywgNDAuMjU3ODQ0LCAtMTA1LjE2NDM5NywgNDAuMjU3ODQ0XSwgImdlb21ldHJ5IjogeyJjb29yZGluYXRlcyI6IFstMTA1LjE2NDM5NywgNDAuMjU3ODQ0XSwgInR5cGUiOiAiUG9pbnQifSwgImlkIjogIjE2IiwgInByb3BlcnRpZXMiOiB7ImFtb3VudCI6ICIwLjAwIiwgImNvdW50eSI6ICJCT1VMREVSIiwgImRhdGFfc291cmNlIjogIkNvb3BlcmF0aXZlIFNEUiBQcm9ncmFtIG9mIENEV1IgXHUwMDI2IE5DV0NEIiwgImRhdGVfdGltZSI6ICIyMDIwLTAxLTMxVDE5OjAwOjAwLjAwMCIsICJkaXYiOiAiMSIsICJkd3JfYWJicmV2IjogIkJMV0RJVENPIiwgImZsYWciOiBudWxsLCAiaHR0cF9saW5rYWdlLnVybCI6ICJodHRwczovL2R3ci5zdGF0ZS5jby51cy9TdXJmYWNlV2F0ZXIvZGF0YS9kZXRhaWxfZ3JhcGguYXNweD9JRD1CTFdESVRDT1x1MDAyNk1UWVBFPURJU0NIUkciLCAibG9jYXRpb24ubGF0aXR1ZGUiOiA0MC4yNTc4NDQsICJsb2NhdGlvbi5sb25naXR1ZGUiOiAtMTA1LjE2NDM5NywgImxvY2F0aW9uLm5lZWRzX3JlY29kaW5nIjogZmFsc2UsICJzdGFnZSI6IG51bGwsICJzdGF0aW9uX25hbWUiOiAiQkxPV0VSIERJVENIIiwgInN0YXRpb25fc3RhdHVzIjogIkFjdGl2ZSIsICJzdGF0aW9uX3R5cGUiOiAiRGl2ZXJzaW9uIiwgInVzZ3Nfc3RhdGlvbl9pZCI6IG51bGwsICJ2YXJpYWJsZSI6ICJESVNDSFJHIiwgIndkIjogIjQifSwgInR5cGUiOiAiRmVhdHVyZSJ9LCB7ImJib3giOiBbLTEwNS4zMDQ5OSwgMzkuOTMxNTk3LCAtMTA1LjMwNDk5LCAzOS45MzE1OTddLCAiZ2VvbWV0cnkiOiB7ImNvb3JkaW5hdGVzIjogWy0xMDUuMzA0OTksIDM5LjkzMTU5N10sICJ0eXBlIjogIlBvaW50In0sICJpZCI6ICIxNyIsICJwcm9wZXJ0aWVzIjogeyJhbW91bnQiOiAiNy44OCIsICJjb3VudHkiOiAiQk9VTERFUiIsICJkYXRhX3NvdXJjZSI6ICJDby4gRGl2aXNpb24gb2YgV2F0ZXIgUmVzb3VyY2VzIiwgImRhdGVfdGltZSI6ICIyMDIwLTAxLTMxVDE5OjE1OjAwLjAwMCIsICJkaXYiOiAiMSIsICJkd3JfYWJicmV2IjogIkJPQ0VMU0NPIiwgImZsYWciOiAiSWNlIiwgImh0dHBfbGlua2FnZS51cmwiOiAiaHR0cHM6Ly9kd3Iuc3RhdGUuY28udXMvU3VyZmFjZVdhdGVyL2RhdGEvZGV0YWlsX2dyYXBoLmFzcHg/SUQ9Qk9DRUxTQ09cdTAwMjZNVFlQRT1ESVNDSFJHIiwgImxvY2F0aW9uLmxhdGl0dWRlIjogMzkuOTMxNTk3LCAibG9jYXRpb24ubG9uZ2l0dWRlIjogLTEwNS4zMDQ5OSwgImxvY2F0aW9uLm5lZWRzX3JlY29kaW5nIjogZmFsc2UsICJzdGFnZSI6ICIyLjA2IiwgInN0YXRpb25fbmFtZSI6ICJTT1VUSCBCT1VMREVSIENSRUVLIE5FQVIgRUxET1JBRE8gU1BSSU5HUywgQ08uIiwgInN0YXRpb25fc3RhdHVzIjogIkFjdGl2ZSIsICJzdGF0aW9uX3R5cGUiOiAiU3RyZWFtIiwgInVzZ3Nfc3RhdGlvbl9pZCI6IG51bGwsICJ2YXJpYWJsZSI6ICJESVNDSFJHIiwgIndkIjogIjYifSwgInR5cGUiOiAiRmVhdHVyZSJ9LCB7ImJib3giOiBbLTEwNS4xNzg4NzUsIDQwLjA1MTY1MiwgLTEwNS4xNzg4NzUsIDQwLjA1MTY1Ml0sICJnZW9tZXRyeSI6IHsiY29vcmRpbmF0ZXMiOiBbLTEwNS4xNzg4NzUsIDQwLjA1MTY1Ml0sICJ0eXBlIjogIlBvaW50In0sICJpZCI6ICIxOCIsICJwcm9wZXJ0aWVzIjogeyJhbW91bnQiOiAiMTcuNjAiLCAiY291bnR5IjogIkJPVUxERVIiLCAiZGF0YV9zb3VyY2UiOiAiVS5TLiBHZW9sb2dpY2FsIFN1cnZleSIsICJkYXRlX3RpbWUiOiAiMjAyMC0wMS0zMVQxOToxNTowMC4wMDAiLCAiZGl2IjogIjEiLCAiZHdyX2FiYnJldiI6ICJCT0NOT1JDTyIsICJmbGFnIjogbnVsbCwgImh0dHBfbGlua2FnZS51cmwiOiAiaHR0cHM6Ly93YXRlcmRhdGEudXNncy5nb3Yvbndpcy91dj8wNjczMDIwMCIsICJsb2NhdGlvbi5sYXRpdHVkZSI6IDQwLjA1MTY1MiwgImxvY2F0aW9uLmxvbmdpdHVkZSI6IC0xMDUuMTc4ODc1LCAibG9jYXRpb24ubmVlZHNfcmVjb2RpbmciOiBmYWxzZSwgInN0YWdlIjogbnVsbCwgInN0YXRpb25fbmFtZSI6ICJCT1VMREVSIENSRUVLIEFUIE5PUlRIIDc1VEggU1QuIE5FQVIgQk9VTERFUiwgQ08iLCAic3RhdGlvbl9zdGF0dXMiOiAiQWN0aXZlIiwgInN0YXRpb25fdHlwZSI6ICJTdHJlYW0iLCAidXNnc19zdGF0aW9uX2lkIjogIjA2NzMwMjAwIiwgInZhcmlhYmxlIjogIkRJU0NIUkciLCAid2QiOiAiNiJ9LCAidHlwZSI6ICJGZWF0dXJlIn0sIHsiYmJveCI6IFstMTA1LjE2MDg3NiwgNDAuMTcwOTk4LCAtMTA1LjE2MDg3NiwgNDAuMTcwOTk4XSwgImdlb21ldHJ5IjogeyJjb29yZGluYXRlcyI6IFstMTA1LjE2MDg3NiwgNDAuMTcwOTk4XSwgInR5cGUiOiAiUG9pbnQifSwgImlkIjogIjE5IiwgInByb3BlcnRpZXMiOiB7ImFtb3VudCI6ICIwLjM4IiwgImNvdW50eSI6ICJCT1VMREVSIiwgImRhdGFfc291cmNlIjogIkNvb3BlcmF0aXZlIFByb2dyYW0gb2YgQ0RXUiwgTkNXQ0QgXHUwMDI2IFNWTEhXQ0QiLCAiZGF0ZV90aW1lIjogIjIwMjAtMDEtMzFUMTk6MDA6MDAuMDAwIiwgImRpdiI6ICIxIiwgImR3cl9hYmJyZXYiOiAiU0ZMRElUQ08iLCAiZmxhZyI6IG51bGwsICJodHRwX2xpbmthZ2UudXJsIjogImh0dHBzOi8vZHdyLnN0YXRlLmNvLnVzL1N1cmZhY2VXYXRlci9kYXRhL2RldGFpbF9ncmFwaC5hc3B4P0lEPVNGTERJVENPXHUwMDI2TVRZUEU9RElTQ0hSRyIsICJsb2NhdGlvbi5sYXRpdHVkZSI6IDQwLjE3MDk5OCwgImxvY2F0aW9uLmxvbmdpdHVkZSI6IC0xMDUuMTYwODc2LCAibG9jYXRpb24ubmVlZHNfcmVjb2RpbmciOiBmYWxzZSwgInN0YWdlIjogIjAuMTEiLCAic3RhdGlvbl9uYW1lIjogIlNPVVRIIEZMQVQgRElUQ0giLCAic3RhdGlvbl9zdGF0dXMiOiAiQWN0aXZlIiwgInN0YXRpb25fdHlwZSI6ICJEaXZlcnNpb24iLCAidXNnc19zdGF0aW9uX2lkIjogbnVsbCwgInZhcmlhYmxlIjogIkRJU0NIUkciLCAid2QiOiAiNSJ9LCAidHlwZSI6ICJGZWF0dXJlIn0sIHsiYmJveCI6IFstMTA1LjA3NTY5NTAwMDAwMDAxLCA0MC4xNTMzNDEsIC0xMDUuMDc1Njk1MDAwMDAwMDEsIDQwLjE1MzM0MV0sICJnZW9tZXRyeSI6IHsiY29vcmRpbmF0ZXMiOiBbLTEwNS4wNzU2OTUwMDAwMDAwMSwgNDAuMTUzMzQxXSwgInR5cGUiOiAiUG9pbnQifSwgImlkIjogIjIwIiwgInByb3BlcnRpZXMiOiB7ImFtb3VudCI6ICIzNS43MCIsICJjb3VudHkiOiAiQk9VTERFUiIsICJkYXRhX3NvdXJjZSI6ICJDby4gRGl2aXNpb24gb2YgV2F0ZXIgUmVzb3VyY2VzIiwgImRhdGVfdGltZSI6ICIyMDIwLTAxLTMxVDE5OjMwOjAwLjAwMCIsICJkaXYiOiAiMSIsICJkd3JfYWJicmV2IjogIlNWQ0xPUENPIiwgImZsYWciOiBudWxsLCAiaHR0cF9saW5rYWdlLnVybCI6ICJodHRwczovL2R3ci5zdGF0ZS5jby51cy9TdXJmYWNlV2F0ZXIvZGF0YS9kZXRhaWxfZ3JhcGguYXNweD9JRD1TVkNMT1BDT1x1MDAyNk1UWVBFPURJU0NIUkciLCAibG9jYXRpb24ubGF0aXR1ZGUiOiA0MC4xNTMzNDEsICJsb2NhdGlvbi5sb25naXR1ZGUiOiAtMTA1LjA3NTY5NSwgImxvY2F0aW9uLm5lZWRzX3JlY29kaW5nIjogZmFsc2UsICJzdGFnZSI6ICIzLjU2IiwgInN0YXRpb25fbmFtZSI6ICJTQUlOVCBWUkFJTiBDUkVFSyBCRUxPVyBLRU4gUFJBVFQgQkxWRCBBVCBMT05HTU9OVCwgQ08iLCAic3RhdGlvbl9zdGF0dXMiOiAiQWN0aXZlIiwgInN0YXRpb25fdHlwZSI6ICJTdHJlYW0iLCAidXNnc19zdGF0aW9uX2lkIjogbnVsbCwgInZhcmlhYmxlIjogIkRJU0NIUkciLCAid2QiOiAiNSJ9LCAidHlwZSI6ICJGZWF0dXJlIn0sIHsiYmJveCI6IFstMTA1LjUwNDQ0LCAzOS45NjE2NTUsIC0xMDUuNTA0NDQsIDM5Ljk2MTY1NV0sICJnZW9tZXRyeSI6IHsiY29vcmRpbmF0ZXMiOiBbLTEwNS41MDQ0NCwgMzkuOTYxNjU1XSwgInR5cGUiOiAiUG9pbnQifSwgImlkIjogIjIxIiwgInByb3BlcnRpZXMiOiB7ImFtb3VudCI6ICIzOS43MCIsICJjb3VudHkiOiAiQk9VTERFUiIsICJkYXRhX3NvdXJjZSI6ICJDby4gRGl2aXNpb24gb2YgV2F0ZXIgUmVzb3VyY2VzIiwgImRhdGVfdGltZSI6ICIyMDIwLTAxLTMxVDE5OjE1OjAwLjAwMCIsICJkaXYiOiAiMSIsICJkd3JfYWJicmV2IjogIkJPQ01JRENPIiwgImZsYWciOiBudWxsLCAiaHR0cF9saW5rYWdlLnVybCI6ICJodHRwczovL2R3ci5zdGF0ZS5jby51cy9TdXJmYWNlV2F0ZXIvZGF0YS9kZXRhaWxfZ3JhcGguYXNweD9JRD1CT0NNSURDT1x1MDAyNk1UWVBFPURJU0NIUkciLCAibG9jYXRpb24ubGF0aXR1ZGUiOiAzOS45NjE2NTUsICJsb2NhdGlvbi5sb25naXR1ZGUiOiAtMTA1LjUwNDQ0LCAibG9jYXRpb24ubmVlZHNfcmVjb2RpbmciOiBmYWxzZSwgInN0YWdlIjogIjEuMzYiLCAic3RhdGlvbl9uYW1lIjogIk1JRERMRSBCT1VMREVSIENSRUVLIEFUIE5FREVSTEFORCwgQ08uIiwgInN0YXRpb25fc3RhdHVzIjogIkFjdGl2ZSIsICJzdGF0aW9uX3R5cGUiOiAiU3RyZWFtIiwgInVzZ3Nfc3RhdGlvbl9pZCI6ICIwNjcyNTUwMCIsICJ2YXJpYWJsZSI6ICJESVNDSFJHIiwgIndkIjogIjYifSwgInR5cGUiOiAiRmVhdHVyZSJ9LCB7ImJib3giOiBbLTEwNS4wOTc4NzIsIDQwLjA1OTgwOSwgLTEwNS4wOTc4NzIsIDQwLjA1OTgwOV0sICJnZW9tZXRyeSI6IHsiY29vcmRpbmF0ZXMiOiBbLTEwNS4wOTc4NzIsIDQwLjA1OTgwOV0sICJ0eXBlIjogIlBvaW50In0sICJpZCI6ICIyMiIsICJwcm9wZXJ0aWVzIjogeyJhbW91bnQiOiAiMzIuMDAiLCAiY291bnR5IjogIkJPVUxERVIiLCAiZGF0YV9zb3VyY2UiOiAiQ28uIERpdmlzaW9uIG9mIFdhdGVyIFJlc291cmNlcyIsICJkYXRlX3RpbWUiOiAiMjAyMC0wMS0zMVQxOTo0NTowMC4wMDAiLCAiZGl2IjogIjEiLCAiZHdyX2FiYnJldiI6ICJCT0MxMDlDTyIsICJmbGFnIjogbnVsbCwgImh0dHBfbGlua2FnZS51cmwiOiAiaHR0cHM6Ly9kd3Iuc3RhdGUuY28udXMvU3VyZmFjZVdhdGVyL2RhdGEvZGV0YWlsX2dyYXBoLmFzcHg/SUQ9Qk9DMTA5Q09cdTAwMjZNVFlQRT1ESVNDSFJHIiwgImxvY2F0aW9uLmxhdGl0dWRlIjogNDAuMDU5ODA5LCAibG9jYXRpb24ubG9uZ2l0dWRlIjogLTEwNS4wOTc4NzIsICJsb2NhdGlvbi5uZWVkc19yZWNvZGluZyI6IGZhbHNlLCAic3RhZ2UiOiAiMi4zOSIsICJzdGF0aW9uX25hbWUiOiAiQk9VTERFUiBDUkVFSyBBVCAxMDkgU1QgTkVBUiBFUklFLCBDTyIsICJzdGF0aW9uX3N0YXR1cyI6ICJBY3RpdmUiLCAic3RhdGlvbl90eXBlIjogIlN0cmVhbSIsICJ1c2dzX3N0YXRpb25faWQiOiBudWxsLCAidmFyaWFibGUiOiAiRElTQ0hSRyIsICJ3ZCI6ICI2In0sICJ0eXBlIjogIkZlYXR1cmUifSwgeyJiYm94IjogWy0xMDUuMzYzNDIyLCA0MC4yMTU2NTgsIC0xMDUuMzYzNDIyLCA0MC4yMTU2NThdLCAiZ2VvbWV0cnkiOiB7ImNvb3JkaW5hdGVzIjogWy0xMDUuMzYzNDIyLCA0MC4yMTU2NThdLCAidHlwZSI6ICJQb2ludCJ9LCAiaWQiOiAiMjMiLCAicHJvcGVydGllcyI6IHsiYW1vdW50IjogIjIwLjQwIiwgImNvdW50eSI6ICJCT1VMREVSIiwgImRhdGFfc291cmNlIjogIkNvLiBEaXZpc2lvbiBvZiBXYXRlciBSZXNvdXJjZXMiLCAiZGF0ZV90aW1lIjogIjIwMjAtMDEtMzFUMTk6NDU6MDAuMDAwIiwgImRpdiI6ICIxIiwgImR3cl9hYmJyZXYiOiAiTlNWQkJSQ08iLCAiZmxhZyI6IG51bGwsICJodHRwX2xpbmthZ2UudXJsIjogImh0dHBzOi8vZHdyLnN0YXRlLmNvLnVzL1N1cmZhY2VXYXRlci9kYXRhL2RldGFpbF9ncmFwaC5hc3B4P0lEPU5TVkJCUkNPXHUwMDI2TVRZUEU9RElTQ0hSRyIsICJsb2NhdGlvbi5sYXRpdHVkZSI6IDQwLjIxNTY1OCwgImxvY2F0aW9uLmxvbmdpdHVkZSI6IC0xMDUuMzYzNDIyLCAibG9jYXRpb24ubmVlZHNfcmVjb2RpbmciOiBmYWxzZSwgInN0YWdlIjogIjAuMzUiLCAic3RhdGlvbl9uYW1lIjogIk5PUlRIIFNBSU5UIFZSQUlOIENSRUVLIEJFTE9XIEJVVFRPTlJPQ0sgIChSQUxQSCBQUklDRSkgUkVTRVJWT0lSIiwgInN0YXRpb25fc3RhdHVzIjogIkFjdGl2ZSIsICJzdGF0aW9uX3R5cGUiOiAiU3RyZWFtIiwgInVzZ3Nfc3RhdGlvbl9pZCI6IG51bGwsICJ2YXJpYWJsZSI6ICJESVNDSFJHIiwgIndkIjogIjUifSwgInR5cGUiOiAiRmVhdHVyZSJ9LCB7ImJib3giOiBbLTEwNS4yMTc1MTksIDQwLjA4NjI3OCwgLTEwNS4yMTc1MTksIDQwLjA4NjI3OF0sICJnZW9tZXRyeSI6IHsiY29vcmRpbmF0ZXMiOiBbLTEwNS4yMTc1MTksIDQwLjA4NjI3OF0sICJ0eXBlIjogIlBvaW50In0sICJpZCI6ICIyNCIsICJwcm9wZXJ0aWVzIjogeyJhbW91bnQiOiAiMC44MCIsICJjb3VudHkiOiAiQk9VTERFUiIsICJkYXRhX3NvdXJjZSI6ICJOb3J0aGVybiBDb2xvcmFkbyBXYXRlciBDb25zZXJ2YW5jeSBEaXN0cmljdCIsICJkYXRlX3RpbWUiOiAiMjAyMC0wMS0zMVQxOTowMDowMC4wMDAiLCAiZGl2IjogIjEiLCAiZHdyX2FiYnJldiI6ICJCRkNJTkZDTyIsICJmbGFnIjogbnVsbCwgImh0dHBfbGlua2FnZS51cmwiOiAiaHR0cDovL3d3dy5ub3J0aGVybndhdGVyLm9yZy9XYXRlclByb2plY3RzL1dhdGVyRGF0YS5hc3B4RWFzdFNsb3BlV2F0ZXJEYXRhLmFzcHgiLCAibG9jYXRpb24ubGF0aXR1ZGUiOiA0MC4wODYyNzgsICJsb2NhdGlvbi5sb25naXR1ZGUiOiAtMTA1LjIxNzUxOSwgImxvY2F0aW9uLm5lZWRzX3JlY29kaW5nIjogZmFsc2UsICJzdGFnZSI6ICIwLjE0IiwgInN0YXRpb25fbmFtZSI6ICJCT1VMREVSIFJFU0VSVk9JUiBJTkxFVCIsICJzdGF0aW9uX3N0YXR1cyI6ICJBY3RpdmUiLCAic3RhdGlvbl90eXBlIjogIlN0cmVhbSIsICJ1c2dzX3N0YXRpb25faWQiOiAiRVMxOTE2IiwgInZhcmlhYmxlIjogIkRJU0NIUkciLCAid2QiOiAiNiJ9LCAidHlwZSI6ICJGZWF0dXJlIn0sIHsiYmJveCI6IFstMTA1LjIxMDM4ODAwMDAwMDAxLCA0MC4xOTMwMTksIC0xMDUuMjEwMzg4MDAwMDAwMDEsIDQwLjE5MzAxOV0sICJnZW9tZXRyeSI6IHsiY29vcmRpbmF0ZXMiOiBbLTEwNS4yMTAzODgwMDAwMDAwMSwgNDAuMTkzMDE5XSwgInR5cGUiOiAiUG9pbnQifSwgImlkIjogIjI1IiwgInByb3BlcnRpZXMiOiB7ImFtb3VudCI6ICIwLjAwIiwgImNvdW50eSI6ICJCT1VMREVSIiwgImRhdGFfc291cmNlIjogIkNvb3BlcmF0aXZlIFByb2dyYW0gb2YgQ0RXUiwgTkNXQ0QgXHUwMDI2IFNWTEhXQ0QiLCAiZGF0ZV90aW1lIjogIjIwMjAtMDEtMzFUMTk6MDA6MDAuMDAwIiwgImRpdiI6ICIxIiwgImR3cl9hYmJyZXYiOiAiVFJVRElUQ08iLCAiZmxhZyI6IG51bGwsICJodHRwX2xpbmthZ2UudXJsIjogImh0dHBzOi8vZHdyLnN0YXRlLmNvLnVzL1N1cmZhY2VXYXRlci9kYXRhL2RldGFpbF9ncmFwaC5hc3B4P0lEPVRSVURJVENPXHUwMDI2TVRZUEU9RElTQ0hSRyIsICJsb2NhdGlvbi5sYXRpdHVkZSI6IDQwLjE5MzAxOSwgImxvY2F0aW9uLmxvbmdpdHVkZSI6IC0xMDUuMjEwMzg4LCAibG9jYXRpb24ubmVlZHNfcmVjb2RpbmciOiBmYWxzZSwgInN0YWdlIjogbnVsbCwgInN0YXRpb25fbmFtZSI6ICJUUlVFIEFORCBXRUJTVEVSIERJVENIIiwgInN0YXRpb25fc3RhdHVzIjogIkFjdGl2ZSIsICJzdGF0aW9uX3R5cGUiOiAiRGl2ZXJzaW9uIiwgInVzZ3Nfc3RhdGlvbl9pZCI6IG51bGwsICJ2YXJpYWJsZSI6ICJESVNDSFJHIiwgIndkIjogIjUifSwgInR5cGUiOiAiRmVhdHVyZSJ9LCB7ImJib3giOiBbLTEwNS4yNTE4MjYsIDQwLjIxMjY1OCwgLTEwNS4yNTE4MjYsIDQwLjIxMjY1OF0sICJnZW9tZXRyeSI6IHsiY29vcmRpbmF0ZXMiOiBbLTEwNS4yNTE4MjYsIDQwLjIxMjY1OF0sICJ0eXBlIjogIlBvaW50In0sICJpZCI6ICIyNiIsICJwcm9wZXJ0aWVzIjogeyJhbW91bnQiOiAiMC4wNCIsICJjb3VudHkiOiAiQk9VTERFUiIsICJkYXRhX3NvdXJjZSI6ICJDb29wZXJhdGl2ZSBQcm9ncmFtIG9mIENEV1IsIE5DV0NEIFx1MDAyNiBTVkxIV0NEIiwgImRhdGVfdGltZSI6ICIyMDIwLTAxLTMxVDE5OjAwOjAwLjAwMCIsICJkaXYiOiAiMSIsICJkd3JfYWJicmV2IjogIlJPVVJFQUNPIiwgImZsYWciOiBudWxsLCAiaHR0cF9saW5rYWdlLnVybCI6ICJodHRwczovL2R3ci5zdGF0ZS5jby51cy9TdXJmYWNlV2F0ZXIvZGF0YS9kZXRhaWxfZ3JhcGguYXNweD9JRD1ST1VSRUFDT1x1MDAyNk1UWVBFPURJU0NIUkciLCAibG9jYXRpb24ubGF0aXR1ZGUiOiA0MC4yMTI2NTgsICJsb2NhdGlvbi5sb25naXR1ZGUiOiAtMTA1LjI1MTgyNiwgImxvY2F0aW9uLm5lZWRzX3JlY29kaW5nIjogZmFsc2UsICJzdGFnZSI6ICIwLjAyIiwgInN0YXRpb25fbmFtZSI6ICJST1VHSCBBTkQgUkVBRFkgRElUQ0giLCAic3RhdGlvbl9zdGF0dXMiOiAiQWN0aXZlIiwgInN0YXRpb25fdHlwZSI6ICJEaXZlcnNpb24iLCAidXNnc19zdGF0aW9uX2lkIjogbnVsbCwgInZhcmlhYmxlIjogIkRJU0NIUkciLCAid2QiOiAiNSJ9LCAidHlwZSI6ICJGZWF0dXJlIn0sIHsiYmJveCI6IFstMTA1LjE2Nzg3MywgNDAuMTc0ODQ0LCAtMTA1LjE2Nzg3MywgNDAuMTc0ODQ0XSwgImdlb21ldHJ5IjogeyJjb29yZGluYXRlcyI6IFstMTA1LjE2Nzg3MywgNDAuMTc0ODQ0XSwgInR5cGUiOiAiUG9pbnQifSwgImlkIjogIjI3IiwgInByb3BlcnRpZXMiOiB7ImFtb3VudCI6ICIwLjIxIiwgImNvdW50eSI6ICJCT1VMREVSIiwgImRhdGFfc291cmNlIjogIkNvb3BlcmF0aXZlIFByb2dyYW0gb2YgQ0RXUiwgTkNXQ0QgXHUwMDI2IFNWTEhXQ0QiLCAiZGF0ZV90aW1lIjogIjIwMjAtMDEtMzFUMTk6MDA6MDAuMDAwIiwgImRpdiI6ICIxIiwgImR3cl9hYmJyZXYiOiAiSEdSTURXQ08iLCAiZmxhZyI6IG51bGwsICJodHRwX2xpbmthZ2UudXJsIjogImh0dHBzOi8vZHdyLnN0YXRlLmNvLnVzL1N1cmZhY2VXYXRlci9kYXRhL2RldGFpbF9ncmFwaC5hc3B4P0lEPUhHUk1EV0NPXHUwMDI2TVRZUEU9RElTQ0hSRyIsICJsb2NhdGlvbi5sYXRpdHVkZSI6IDQwLjE3NDg0NCwgImxvY2F0aW9uLmxvbmdpdHVkZSI6IC0xMDUuMTY3ODczLCAibG9jYXRpb24ubmVlZHNfcmVjb2RpbmciOiBmYWxzZSwgInN0YWdlIjogIjAuMTAiLCAic3RhdGlvbl9uYW1lIjogIkhBR0VSIE1FQURPV1MgRElUQ0giLCAic3RhdGlvbl9zdGF0dXMiOiAiQWN0aXZlIiwgInN0YXRpb25fdHlwZSI6ICJEaXZlcnNpb24iLCAidXNnc19zdGF0aW9uX2lkIjogbnVsbCwgInZhcmlhYmxlIjogIkRJU0NIUkciLCAid2QiOiAiNSJ9LCAidHlwZSI6ICJGZWF0dXJlIn0sIHsiYmJveCI6IFstMTA1LjIwOTQxNiwgNDAuMjU2Mjc2MDAwMDAwMDEsIC0xMDUuMjA5NDE2LCA0MC4yNTYyNzYwMDAwMDAwMV0sICJnZW9tZXRyeSI6IHsiY29vcmRpbmF0ZXMiOiBbLTEwNS4yMDk0MTYsIDQwLjI1NjI3NjAwMDAwMDAxXSwgInR5cGUiOiAiUG9pbnQifSwgImlkIjogIjI4IiwgInByb3BlcnRpZXMiOiB7ImFtb3VudCI6ICIwLjAwIiwgImNvdW50eSI6ICJCT1VMREVSIiwgImRhdGFfc291cmNlIjogIk5vcnRoZXJuIENvbG9yYWRvIFdhdGVyIENvbnNlcnZhbmN5IERpc3RyaWN0IiwgImRhdGVfdGltZSI6ICIyMDIwLTAxLTMxVDE5OjAwOjAwLjAwMCIsICJkaXYiOiAiMSIsICJkd3JfYWJicmV2IjogIkxJVFRIMUNPIiwgImZsYWciOiBudWxsLCAiaHR0cF9saW5rYWdlLnVybCI6ICJodHRwOi8vd3d3Lm5vcnRoZXJud2F0ZXIub3JnL1dhdGVyUHJvamVjdHMvV2F0ZXJEYXRhLmFzcHhFYXN0U2xvcGVXYXRlckRhdGEuYXNweCIsICJsb2NhdGlvbi5sYXRpdHVkZSI6IDQwLjI1NjI3NiwgImxvY2F0aW9uLmxvbmdpdHVkZSI6IC0xMDUuMjA5NDE2LCAibG9jYXRpb24ubmVlZHNfcmVjb2RpbmciOiBmYWxzZSwgInN0YWdlIjogbnVsbCwgInN0YXRpb25fbmFtZSI6ICJMSVRUTEUgVEhPTVBTT04gIzEgRElUQ0giLCAic3RhdGlvbl9zdGF0dXMiOiAiQWN0aXZlIiwgInN0YXRpb25fdHlwZSI6ICJEaXZlcnNpb24iLCAidXNnc19zdGF0aW9uX2lkIjogIkVTMTkwMSIsICJ2YXJpYWJsZSI6ICJESVNDSFJHIiwgIndkIjogIjQifSwgInR5cGUiOiAiRmVhdHVyZSJ9LCB7ImJib3giOiBbLTEwNS4xOTg1NjcsIDQwLjI2MDgyNywgLTEwNS4xOTg1NjcsIDQwLjI2MDgyN10sICJnZW9tZXRyeSI6IHsiY29vcmRpbmF0ZXMiOiBbLTEwNS4xOTg1NjcsIDQwLjI2MDgyN10sICJ0eXBlIjogIlBvaW50In0sICJpZCI6ICIyOSIsICJwcm9wZXJ0aWVzIjogeyJhbW91bnQiOiAiMC4wMCIsICJjb3VudHkiOiAiQk9VTERFUiIsICJkYXRhX3NvdXJjZSI6ICJDb29wZXJhdGl2ZSBTRFIgUHJvZ3JhbSBvZiBDRFdSIFx1MDAyNiBOQ1dDRCIsICJkYXRlX3RpbWUiOiAiMjAyMC0wMS0zMVQxODowMDowMC4wMDAiLCAiZGl2IjogIjEiLCAiZHdyX2FiYnJldiI6ICJDVUxESVRDTyIsICJmbGFnIjogbnVsbCwgImh0dHBfbGlua2FnZS51cmwiOiAiaHR0cHM6Ly9kd3Iuc3RhdGUuY28udXMvU3VyZmFjZVdhdGVyL2RhdGEvZGV0YWlsX2dyYXBoLmFzcHg/SUQ9Q1VMRElUQ09cdTAwMjZNVFlQRT1ESVNDSFJHIiwgImxvY2F0aW9uLmxhdGl0dWRlIjogNDAuMjYwODI3LCAibG9jYXRpb24ubG9uZ2l0dWRlIjogLTEwNS4xOTg1NjcsICJsb2NhdGlvbi5uZWVkc19yZWNvZGluZyI6IGZhbHNlLCAic3RhZ2UiOiBudWxsLCAic3RhdGlvbl9uYW1lIjogIkNVTFZFUiBESVRDSCIsICJzdGF0aW9uX3N0YXR1cyI6ICJBY3RpdmUiLCAic3RhdGlvbl90eXBlIjogIkRpdmVyc2lvbiIsICJ1c2dzX3N0YXRpb25faWQiOiBudWxsLCAidmFyaWFibGUiOiAiRElTQ0hSRyIsICJ3ZCI6ICI0In0sICJ0eXBlIjogIkZlYXR1cmUifSwgeyJiYm94IjogWy0xMDUuMjU2MDE3LCA0MC4yMTUwNDMsIC0xMDUuMjU2MDE3LCA0MC4yMTUwNDNdLCAiZ2VvbWV0cnkiOiB7ImNvb3JkaW5hdGVzIjogWy0xMDUuMjU2MDE3LCA0MC4yMTUwNDNdLCAidHlwZSI6ICJQb2ludCJ9LCAiaWQiOiAiMzAiLCAicHJvcGVydGllcyI6IHsiYW1vdW50IjogIjAuMDAiLCAiY291bnR5IjogIkJPVUxERVIiLCAiZGF0YV9zb3VyY2UiOiAiQ28uIERpdmlzaW9uIG9mIFdhdGVyIFJlc291cmNlcyIsICJkYXRlX3RpbWUiOiAiMjAyMC0wMS0zMVQxOTozMDowMC4wMDAiLCAiZGl2IjogIjEiLCAiZHdyX2FiYnJldiI6ICJISUdITERDTyIsICJmbGFnIjogbnVsbCwgImh0dHBfbGlua2FnZS51cmwiOiAiaHR0cHM6Ly9kd3Iuc3RhdGUuY28udXMvU3VyZmFjZVdhdGVyL2RhdGEvZGV0YWlsX2dyYXBoLmFzcHg/SUQ9SElHSExEQ09cdTAwMjZNVFlQRT1ESVNDSFJHIiwgImxvY2F0aW9uLmxhdGl0dWRlIjogNDAuMjE1MDQzLCAibG9jYXRpb24ubG9uZ2l0dWRlIjogLTEwNS4yNTYwMTcsICJsb2NhdGlvbi5uZWVkc19yZWNvZGluZyI6IGZhbHNlLCAic3RhZ2UiOiAiLTAuMTgiLCAic3RhdGlvbl9uYW1lIjogIkhJR0hMQU5EIERJVENIIEFUIExZT05TLCBDTyIsICJzdGF0aW9uX3N0YXR1cyI6ICJBY3RpdmUiLCAic3RhdGlvbl90eXBlIjogIkRpdmVyc2lvbiIsICJ1c2dzX3N0YXRpb25faWQiOiBudWxsLCAidmFyaWFibGUiOiAiRElTQ0hSRyIsICJ3ZCI6ICI1In0sICJ0eXBlIjogIkZlYXR1cmUifSwgeyJiYm94IjogWy0xMDUuMjIwNDk3LCA0MC4wNzg1NiwgLTEwNS4yMjA0OTcsIDQwLjA3ODU2XSwgImdlb21ldHJ5IjogeyJjb29yZGluYXRlcyI6IFstMTA1LjIyMDQ5NywgNDAuMDc4NTZdLCAidHlwZSI6ICJQb2ludCJ9LCAiaWQiOiAiMzEiLCAicHJvcGVydGllcyI6IHsiYW1vdW50IjogIjU4NDIuNTAiLCAiY291bnR5IjogIkJPVUxERVIiLCAiZGF0YV9zb3VyY2UiOiAiTm9ydGhlcm4gQ29sb3JhZG8gV2F0ZXIgQ29uc2VydmFuY3kgRGlzdHJpY3QiLCAiZGF0ZV90aW1lIjogIjIwMjAtMDEtMzFUMTk6MzA6MDAuMDAwIiwgImRpdiI6ICIxIiwgImR3cl9hYmJyZXYiOiAiQk9VUkVTQ08iLCAiZmxhZyI6IG51bGwsICJodHRwX2xpbmthZ2UudXJsIjogImh0dHA6Ly93d3cubm9ydGhlcm53YXRlci5vcmcvV2F0ZXJQcm9qZWN0cy9XYXRlckRhdGEuYXNweEVhc3RTbG9wZVdhdGVyRGF0YS5hc3B4IiwgImxvY2F0aW9uLmxhdGl0dWRlIjogNDAuMDc4NTYsICJsb2NhdGlvbi5sb25naXR1ZGUiOiAtMTA1LjIyMDQ5NywgImxvY2F0aW9uLm5lZWRzX3JlY29kaW5nIjogZmFsc2UsICJzdGFnZSI6IG51bGwsICJzdGF0aW9uX25hbWUiOiAiQk9VTERFUiBSRVNFUlZPSVIiLCAic3RhdGlvbl9zdGF0dXMiOiAiQWN0aXZlIiwgInN0YXRpb25fdHlwZSI6ICJSZXNlcnZvaXIiLCAidXNnc19zdGF0aW9uX2lkIjogIkVSMTkxNCIsICJ2YXJpYWJsZSI6ICJTVE9SQUdFIiwgIndkIjogIjYifSwgInR5cGUiOiAiRmVhdHVyZSJ9LCB7ImJib3giOiBbLTEwNS4xNjkzNzQsIDQwLjE3Mzk1LCAtMTA1LjE2OTM3NCwgNDAuMTczOTVdLCAiZ2VvbWV0cnkiOiB7ImNvb3JkaW5hdGVzIjogWy0xMDUuMTY5Mzc0LCA0MC4xNzM5NV0sICJ0eXBlIjogIlBvaW50In0sICJpZCI6ICIzMiIsICJwcm9wZXJ0aWVzIjogeyJhbW91bnQiOiAiMC4yMyIsICJjb3VudHkiOiAiQk9VTERFUiIsICJkYXRhX3NvdXJjZSI6ICJDb29wZXJhdGl2ZSBQcm9ncmFtIG9mIENEV1IsIE5DV0NEIFx1MDAyNiBTVkxIV0NEIiwgImRhdGVfdGltZSI6ICIyMDIwLTAxLTMxVDE5OjAwOjAwLjAwMCIsICJkaXYiOiAiMSIsICJkd3JfYWJicmV2IjogIk5JV0RJVENPIiwgImZsYWciOiBudWxsLCAiaHR0cF9saW5rYWdlLnVybCI6ICJodHRwczovL2R3ci5zdGF0ZS5jby51cy9TdXJmYWNlV2F0ZXIvZGF0YS9kZXRhaWxfZ3JhcGguYXNweD9JRD1OSVdESVRDT1x1MDAyNk1UWVBFPURJU0NIUkciLCAibG9jYXRpb24ubGF0aXR1ZGUiOiA0MC4xNzM5NSwgImxvY2F0aW9uLmxvbmdpdHVkZSI6IC0xMDUuMTY5Mzc0LCAibG9jYXRpb24ubmVlZHNfcmVjb2RpbmciOiBmYWxzZSwgInN0YWdlIjogIjAuMTAiLCAic3RhdGlvbl9uYW1lIjogIk5JV09UIERJVENIIiwgInN0YXRpb25fc3RhdHVzIjogIkFjdGl2ZSIsICJzdGF0aW9uX3R5cGUiOiAiRGl2ZXJzaW9uIiwgInVzZ3Nfc3RhdGlvbl9pZCI6IG51bGwsICJ2YXJpYWJsZSI6ICJESVNDSFJHIiwgIndkIjogIjUifSwgInR5cGUiOiAiRmVhdHVyZSJ9LCB7ImJib3giOiBbLTEwNS4yNTA5NTIsIDQwLjIxMTM4OSwgLTEwNS4yNTA5NTIsIDQwLjIxMTM4OV0sICJnZW9tZXRyeSI6IHsiY29vcmRpbmF0ZXMiOiBbLTEwNS4yNTA5NTIsIDQwLjIxMTM4OV0sICJ0eXBlIjogIlBvaW50In0sICJpZCI6ICIzMyIsICJwcm9wZXJ0aWVzIjogeyJhbW91bnQiOiAiMC4wMCIsICJjb3VudHkiOiAiQk9VTERFUiIsICJkYXRhX3NvdXJjZSI6ICJDb29wZXJhdGl2ZSBQcm9ncmFtIG9mIENEV1IsIE5DV0NEIFx1MDAyNiBTVkxIV0NEIiwgImRhdGVfdGltZSI6ICIyMDIwLTAxLTMxVDE5OjAwOjAwLjAwMCIsICJkaXYiOiAiMSIsICJkd3JfYWJicmV2IjogIlNNRURJVENPIiwgImZsYWciOiBudWxsLCAiaHR0cF9saW5rYWdlLnVybCI6ICJodHRwczovL2R3ci5zdGF0ZS5jby51cy9TdXJmYWNlV2F0ZXIvZGF0YS9kZXRhaWxfZ3JhcGguYXNweD9JRD1TTUVESVRDT1x1MDAyNk1UWVBFPURJU0NIUkciLCAibG9jYXRpb24ubGF0aXR1ZGUiOiA0MC4yMTEzODksICJsb2NhdGlvbi5sb25naXR1ZGUiOiAtMTA1LjI1MDk1MiwgImxvY2F0aW9uLm5lZWRzX3JlY29kaW5nIjogZmFsc2UsICJzdGFnZSI6ICIwLjAwIiwgInN0YXRpb25fbmFtZSI6ICJTTUVBRCBESVRDSCIsICJzdGF0aW9uX3N0YXR1cyI6ICJBY3RpdmUiLCAic3RhdGlvbl90eXBlIjogIkRpdmVyc2lvbiIsICJ1c2dzX3N0YXRpb25faWQiOiBudWxsLCAidmFyaWFibGUiOiAiRElTQ0hSRyIsICJ3ZCI6ICI1In0sICJ0eXBlIjogIkZlYXR1cmUifSwgeyJiYm94IjogWy0xMDUuMDg4Njk1LCA0MC4xNTMzNjMsIC0xMDUuMDg4Njk1LCA0MC4xNTMzNjNdLCAiZ2VvbWV0cnkiOiB7ImNvb3JkaW5hdGVzIjogWy0xMDUuMDg4Njk1LCA0MC4xNTMzNjNdLCAidHlwZSI6ICJQb2ludCJ9LCAiaWQiOiAiMzQiLCAicHJvcGVydGllcyI6IHsiYW1vdW50IjogIjAuMTQiLCAiY291bnR5IjogIkJPVUxERVIiLCAiZGF0YV9zb3VyY2UiOiAiQ29vcGVyYXRpdmUgUHJvZ3JhbSBvZiBDRFdSLCBOQ1dDRCBcdTAwMjYgU1ZMSFdDRCIsICJkYXRlX3RpbWUiOiAiMjAyMC0wMS0zMVQxOTowMDowMC4wMDAiLCAiZGl2IjogIjEiLCAiZHdyX2FiYnJldiI6ICJCT05ESVRDTyIsICJmbGFnIjogbnVsbCwgImh0dHBfbGlua2FnZS51cmwiOiAiaHR0cHM6Ly9kd3Iuc3RhdGUuY28udXMvU3VyZmFjZVdhdGVyL2RhdGEvZGV0YWlsX2dyYXBoLmFzcHg/SUQ9Qk9ORElUQ09cdTAwMjZNVFlQRT1ESVNDSFJHIiwgImxvY2F0aW9uLmxhdGl0dWRlIjogNDAuMTUzMzYzLCAibG9jYXRpb24ubG9uZ2l0dWRlIjogLTEwNS4wODg2OTUsICJsb2NhdGlvbi5uZWVkc19yZWNvZGluZyI6IGZhbHNlLCAic3RhZ2UiOiAiMC4wNSIsICJzdGF0aW9uX25hbWUiOiAiQk9OVVMgRElUQ0giLCAic3RhdGlvbl9zdGF0dXMiOiAiQWN0aXZlIiwgInN0YXRpb25fdHlwZSI6ICJEaXZlcnNpb24iLCAidXNnc19zdGF0aW9uX2lkIjogbnVsbCwgInZhcmlhYmxlIjogIkRJU0NIUkciLCAid2QiOiAiNSJ9LCAidHlwZSI6ICJGZWF0dXJlIn0sIHsiYmJveCI6IFstMTA1LjI1MDkyNywgNDAuMjExMDgzLCAtMTA1LjI1MDkyNywgNDAuMjExMDgzXSwgImdlb21ldHJ5IjogeyJjb29yZGluYXRlcyI6IFstMTA1LjI1MDkyNywgNDAuMjExMDgzXSwgInR5cGUiOiAiUG9pbnQifSwgImlkIjogIjM1IiwgInByb3BlcnRpZXMiOiB7ImFtb3VudCI6ICIwLjAwIiwgImNvdW50eSI6ICJCT1VMREVSIiwgImRhdGFfc291cmNlIjogIkNvb3BlcmF0aXZlIFByb2dyYW0gb2YgQ0RXUiwgTkNXQ0QgXHUwMDI2IFNWTEhXQ0QiLCAiZGF0ZV90aW1lIjogIjIwMjAtMDEtMzFUMTk6MDA6MDAuMDAwIiwgImRpdiI6ICIxIiwgImR3cl9hYmJyZXYiOiAiU1dFRElUQ08iLCAiZmxhZyI6IG51bGwsICJodHRwX2xpbmthZ2UudXJsIjogImh0dHBzOi8vZHdyLnN0YXRlLmNvLnVzL1N1cmZhY2VXYXRlci9kYXRhL2RldGFpbF9ncmFwaC5hc3B4P0lEPVNXRURJVENPXHUwMDI2TVRZUEU9RElTQ0hSRyIsICJsb2NhdGlvbi5sYXRpdHVkZSI6IDQwLjIxMTA4MywgImxvY2F0aW9uLmxvbmdpdHVkZSI6IC0xMDUuMjUwOTI3LCAibG9jYXRpb24ubmVlZHNfcmVjb2RpbmciOiBmYWxzZSwgInN0YWdlIjogIi0wLjA3IiwgInN0YXRpb25fbmFtZSI6ICJTV0VERSBESVRDSCIsICJzdGF0aW9uX3N0YXR1cyI6ICJBY3RpdmUiLCAic3RhdGlvbl90eXBlIjogIkRpdmVyc2lvbiIsICJ1c2dzX3N0YXRpb25faWQiOiBudWxsLCAidmFyaWFibGUiOiAiRElTQ0hSRyIsICJ3ZCI6ICI1In0sICJ0eXBlIjogIkZlYXR1cmUifSwgeyJiYm94IjogWy0xMDUuMTg5MTMyLCA0MC4xODc1MjQsIC0xMDUuMTg5MTMyLCA0MC4xODc1MjRdLCAiZ2VvbWV0cnkiOiB7ImNvb3JkaW5hdGVzIjogWy0xMDUuMTg5MTMyLCA0MC4xODc1MjRdLCAidHlwZSI6ICJQb2ludCJ9LCAiaWQiOiAiMzYiLCAicHJvcGVydGllcyI6IHsiYW1vdW50IjogIjAuMDAiLCAiY291bnR5IjogIkJPVUxERVIiLCAiZGF0YV9zb3VyY2UiOiAiQ29vcGVyYXRpdmUgUHJvZ3JhbSBvZiBDRFdSLCBOQ1dDRCBcdTAwMjYgU1ZMSFdDRCIsICJkYXRlX3RpbWUiOiAiMjAyMC0wMS0zMVQxOTowMDowMC4wMDAiLCAiZGl2IjogIjEiLCAiZHdyX2FiYnJldiI6ICJSVU5ZT05DTyIsICJmbGFnIjogbnVsbCwgImh0dHBfbGlua2FnZS51cmwiOiAiaHR0cHM6Ly9kd3Iuc3RhdGUuY28udXMvU3VyZmFjZVdhdGVyL2RhdGEvZGV0YWlsX2dyYXBoLmFzcHg/SUQ9UlVOWU9OQ09cdTAwMjZNVFlQRT1ESVNDSFJHIiwgImxvY2F0aW9uLmxhdGl0dWRlIjogNDAuMTg3NTI0LCAibG9jYXRpb24ubG9uZ2l0dWRlIjogLTEwNS4xODkxMzIsICJsb2NhdGlvbi5uZWVkc19yZWNvZGluZyI6IGZhbHNlLCAic3RhZ2UiOiAiNTAuNzAiLCAic3RhdGlvbl9uYW1lIjogIlJVTllPTiBESVRDSCIsICJzdGF0aW9uX3N0YXR1cyI6ICJBY3RpdmUiLCAic3RhdGlvbl90eXBlIjogIkRpdmVyc2lvbiIsICJ1c2dzX3N0YXRpb25faWQiOiBudWxsLCAidmFyaWFibGUiOiAiRElTQ0hSRyIsICJ3ZCI6ICI1In0sICJ0eXBlIjogIkZlYXR1cmUifSwgeyJiYm94IjogWy0xMDUuMTk2Nzc1LCA0MC4xODE4OCwgLTEwNS4xOTY3NzUsIDQwLjE4MTg4XSwgImdlb21ldHJ5IjogeyJjb29yZGluYXRlcyI6IFstMTA1LjE5Njc3NSwgNDAuMTgxODhdLCAidHlwZSI6ICJQb2ludCJ9LCAiaWQiOiAiMzciLCAicHJvcGVydGllcyI6IHsiYW1vdW50IjogIjAuMDAiLCAiY291bnR5IjogIkJPVUxERVIiLCAiZGF0YV9zb3VyY2UiOiAiQ29vcGVyYXRpdmUgUHJvZ3JhbSBvZiBDRFdSLCBOQ1dDRCBcdTAwMjYgU1ZMSFdDRCIsICJkYXRlX3RpbWUiOiAiMjAyMC0wMS0zMVQxOTowMDowMC4wMDAiLCAiZGl2IjogIjEiLCAiZHdyX2FiYnJldiI6ICJEQVZET1dDTyIsICJmbGFnIjogbnVsbCwgImh0dHBfbGlua2FnZS51cmwiOiAiaHR0cHM6Ly9kd3Iuc3RhdGUuY28udXMvU3VyZmFjZVdhdGVyL2RhdGEvZGV0YWlsX2dyYXBoLmFzcHg/SUQ9REFWRE9XQ09cdTAwMjZNVFlQRT1ESVNDSFJHIiwgImxvY2F0aW9uLmxhdGl0dWRlIjogNDAuMTgxODgsICJsb2NhdGlvbi5sb25naXR1ZGUiOiAtMTA1LjE5Njc3NSwgImxvY2F0aW9uLm5lZWRzX3JlY29kaW5nIjogZmFsc2UsICJzdGFnZSI6IG51bGwsICJzdGF0aW9uX25hbWUiOiAiREFWSVMgQU5EIERPV05JTkcgRElUQ0giLCAic3RhdGlvbl9zdGF0dXMiOiAiQWN0aXZlIiwgInN0YXRpb25fdHlwZSI6ICJEaXZlcnNpb24iLCAidXNnc19zdGF0aW9uX2lkIjogbnVsbCwgInZhcmlhYmxlIjogIkRJU0NIUkciLCAid2QiOiAiNSJ9LCAidHlwZSI6ICJGZWF0dXJlIn0sIHsiYmJveCI6IFstMTA1LjMyNjI1LCA0MC4wMTg2NjcsIC0xMDUuMzI2MjUsIDQwLjAxODY2N10sICJnZW9tZXRyeSI6IHsiY29vcmRpbmF0ZXMiOiBbLTEwNS4zMjYyNSwgNDAuMDE4NjY3XSwgInR5cGUiOiAiUG9pbnQifSwgImlkIjogIjM4IiwgInByb3BlcnRpZXMiOiB7ImFtb3VudCI6ICIwLjc0IiwgImNvdW50eSI6ICJCT1VMREVSIiwgImRhdGFfc291cmNlIjogIlUuUy4gR2VvbG9naWNhbCBTdXJ2ZXkiLCAiZGF0ZV90aW1lIjogIjIwMTktMTAtMDJUMTQ6NTA6MDAuMDAwIiwgImRpdiI6ICIxIiwgImR3cl9hYmJyZXYiOiAiRk9VT1JPQ08iLCAiZmxhZyI6IG51bGwsICJodHRwX2xpbmthZ2UudXJsIjogImh0dHBzOi8vd2F0ZXJkYXRhLnVzZ3MuZ292L253aXMvdXY/MDY3Mjc1MDAiLCAibG9jYXRpb24ubGF0aXR1ZGUiOiA0MC4wMTg2NjcsICJsb2NhdGlvbi5sb25naXR1ZGUiOiAtMTA1LjMyNjI1LCAibG9jYXRpb24ubmVlZHNfcmVjb2RpbmciOiBmYWxzZSwgInN0YWdlIjogbnVsbCwgInN0YXRpb25fbmFtZSI6ICJGT1VSTUlMRSBDUkVFSyBBVCBPUk9ERUxMLCBDTyIsICJzdGF0aW9uX3N0YXR1cyI6ICJBY3RpdmUiLCAic3RhdGlvbl90eXBlIjogIlN0cmVhbSIsICJ1c2dzX3N0YXRpb25faWQiOiAiMDY3Mjc1MDAiLCAidmFyaWFibGUiOiAiRElTQ0hSRyIsICJ3ZCI6ICI2In0sICJ0eXBlIjogIkZlYXR1cmUifSwgeyJiYm94IjogWy0xMDUuMjA5MjgyLCA0MC4xODg1NzksIC0xMDUuMjA5MjgyLCA0MC4xODg1NzldLCAiZ2VvbWV0cnkiOiB7ImNvb3JkaW5hdGVzIjogWy0xMDUuMjA5MjgyLCA0MC4xODg1NzldLCAidHlwZSI6ICJQb2ludCJ9LCAiaWQiOiAiMzkiLCAicHJvcGVydGllcyI6IHsiYW1vdW50IjogIjAuMDgiLCAiY291bnR5IjogIkJPVUxERVIiLCAiZGF0YV9zb3VyY2UiOiAiQ29vcGVyYXRpdmUgUHJvZ3JhbSBvZiBDRFdSLCBOQ1dDRCBcdTAwMjYgU1ZMSFdDRCIsICJkYXRlX3RpbWUiOiAiMjAyMC0wMS0zMVQxOTowMDowMC4wMDAiLCAiZGl2IjogIjEiLCAiZHdyX2FiYnJldiI6ICJKQU1ESVRDTyIsICJmbGFnIjogbnVsbCwgImh0dHBfbGlua2FnZS51cmwiOiAiaHR0cHM6Ly9kd3Iuc3RhdGUuY28udXMvU3VyZmFjZVdhdGVyL2RhdGEvZGV0YWlsX2dyYXBoLmFzcHg/SUQ9SkFNRElUQ09cdTAwMjZNVFlQRT1ESVNDSFJHIiwgImxvY2F0aW9uLmxhdGl0dWRlIjogNDAuMTg4NTc5LCAibG9jYXRpb24ubG9uZ2l0dWRlIjogLTEwNS4yMDkyODIsICJsb2NhdGlvbi5uZWVkc19yZWNvZGluZyI6IGZhbHNlLCAic3RhZ2UiOiAiMC4wMyIsICJzdGF0aW9uX25hbWUiOiAiSkFNRVMgRElUQ0giLCAic3RhdGlvbl9zdGF0dXMiOiAiQWN0aXZlIiwgInN0YXRpb25fdHlwZSI6ICJEaXZlcnNpb24iLCAidXNnc19zdGF0aW9uX2lkIjogbnVsbCwgInZhcmlhYmxlIjogIkRJU0NIUkciLCAid2QiOiAiNSJ9LCAidHlwZSI6ICJGZWF0dXJlIn0sIHsiYmJveCI6IFstMTA1LjE5MzA0OCwgNDAuMDUzMDM1LCAtMTA1LjE5MzA0OCwgNDAuMDUzMDM1XSwgImdlb21ldHJ5IjogeyJjb29yZGluYXRlcyI6IFstMTA1LjE5MzA0OCwgNDAuMDUzMDM1XSwgInR5cGUiOiAiUG9pbnQifSwgImlkIjogIjQwIiwgInByb3BlcnRpZXMiOiB7ImFtb3VudCI6ICIwLjAwIiwgImNvdW50eSI6ICJCT1VMREVSIiwgImRhdGFfc291cmNlIjogIk5vcnRoZXJuIENvbG9yYWRvIFdhdGVyIENvbnNlcnZhbmN5IERpc3RyaWN0IiwgImRhdGVfdGltZSI6ICIyMDE5LTExLTI5VDAxOjAwOjAwLjAwMCIsICJkaXYiOiAiMSIsICJkd3JfYWJicmV2IjogIkJDU0NCQ0NPIiwgImZsYWciOiBudWxsLCAiaHR0cF9saW5rYWdlLnVybCI6ICJodHRwOi8vd3d3Lm5vcnRoZXJud2F0ZXIub3JnL1dhdGVyUHJvamVjdHMvV2F0ZXJEYXRhLmFzcHhFYXN0U2xvcGVXYXRlckRhdGEuYXNweCIsICJsb2NhdGlvbi5sYXRpdHVkZSI6IDQwLjA1MzAzNSwgImxvY2F0aW9uLmxvbmdpdHVkZSI6IC0xMDUuMTkzMDQ4LCAibG9jYXRpb24ubmVlZHNfcmVjb2RpbmciOiBmYWxzZSwgInN0YWdlIjogIjAuMDAiLCAic3RhdGlvbl9uYW1lIjogIkJPVUxERVIgQ1JFRUsgU1VQUExZIENBTkFMIFRPIEJPVUxERVIgQ1JFRUsgTkVBUiBCT1VMREVSIiwgInN0YXRpb25fc3RhdHVzIjogIkFjdGl2ZSIsICJzdGF0aW9uX3R5cGUiOiAiRGl2ZXJzaW9uIiwgInVzZ3Nfc3RhdGlvbl9pZCI6ICJFUzE5MTciLCAidmFyaWFibGUiOiAiRElTQ0hSRyIsICJ3ZCI6ICI2In0sICJ0eXBlIjogIkZlYXR1cmUifSwgeyJiYm94IjogWy0xMDUuMTc0OTU3LCA0MC4yNTgzNjcsIC0xMDUuMTc0OTU3LCA0MC4yNTgzNjddLCAiZ2VvbWV0cnkiOiB7ImNvb3JkaW5hdGVzIjogWy0xMDUuMTc0OTU3LCA0MC4yNTgzNjddLCAidHlwZSI6ICJQb2ludCJ9LCAiaWQiOiAiNDEiLCAicHJvcGVydGllcyI6IHsiYW1vdW50IjogIjAuMDAiLCAiY291bnR5IjogIkJPVUxERVIiLCAiZGF0YV9zb3VyY2UiOiAiQ28uIERpdmlzaW9uIG9mIFdhdGVyIFJlc291cmNlcyIsICJkYXRlX3RpbWUiOiAiMjAyMC0wMS0zMVQxOTozMDowMC4wMDAiLCAiZGl2IjogIjEiLCAiZHdyX2FiYnJldiI6ICJCT1VMQVJDTyIsICJmbGFnIjogbnVsbCwgImh0dHBfbGlua2FnZS51cmwiOiAiaHR0cHM6Ly9kd3Iuc3RhdGUuY28udXMvU3VyZmFjZVdhdGVyL2RhdGEvZGV0YWlsX2dyYXBoLmFzcHg/SUQ9Qk9VTEFSQ09cdTAwMjZNVFlQRT1ESVNDSFJHIiwgImxvY2F0aW9uLmxhdGl0dWRlIjogNDAuMjU4MzY3LCAibG9jYXRpb24ubG9uZ2l0dWRlIjogLTEwNS4xNzQ5NTcsICJsb2NhdGlvbi5uZWVkc19yZWNvZGluZyI6IGZhbHNlLCAic3RhZ2UiOiAiLTAuMTIiLCAic3RhdGlvbl9uYW1lIjogIkJPVUxERVItTEFSSU1FUiBESVRDSCBORUFSIEJFUlRIT1VEIiwgInN0YXRpb25fc3RhdHVzIjogIkFjdGl2ZSIsICJzdGF0aW9uX3R5cGUiOiAiRGl2ZXJzaW9uIiwgInVzZ3Nfc3RhdGlvbl9pZCI6IG51bGwsICJ2YXJpYWJsZSI6ICJESVNDSFJHIiwgIndkIjogIjQifSwgInR5cGUiOiAiRmVhdHVyZSJ9LCB7ImJib3giOiBbLTEwNS4zNDc5MDYsIDM5LjkzODM1MSwgLTEwNS4zNDc5MDYsIDM5LjkzODM1MV0sICJnZW9tZXRyeSI6IHsiY29vcmRpbmF0ZXMiOiBbLTEwNS4zNDc5MDYsIDM5LjkzODM1MV0sICJ0eXBlIjogIlBvaW50In0sICJpZCI6ICI0MiIsICJwcm9wZXJ0aWVzIjogeyJhbW91bnQiOiAiODMuNDAiLCAiY291bnR5IjogIkJPVUxERVIiLCAiZGF0YV9zb3VyY2UiOiAiQ28uIERpdmlzaW9uIG9mIFdhdGVyIFJlc291cmNlcyIsICJkYXRlX3RpbWUiOiAiMjAyMC0wMS0zMVQxOToxNTowMC4wMDAiLCAiZGl2IjogIjEiLCAiZHdyX2FiYnJldiI6ICJCT0NCR1JDTyIsICJmbGFnIjogbnVsbCwgImh0dHBfbGlua2FnZS51cmwiOiAiaHR0cHM6Ly9kd3Iuc3RhdGUuY28udXMvU3VyZmFjZVdhdGVyL2RhdGEvZGV0YWlsX2dyYXBoLmFzcHg/SUQ9Qk9DQkdSQ09cdTAwMjZNVFlQRT1ESVNDSFJHIiwgImxvY2F0aW9uLmxhdGl0dWRlIjogMzkuOTM4MzUxLCAibG9jYXRpb24ubG9uZ2l0dWRlIjogLTEwNS4zNDc5MDYsICJsb2NhdGlvbi5uZWVkc19yZWNvZGluZyI6IGZhbHNlLCAic3RhZ2UiOiAiMC45MiIsICJzdGF0aW9uX25hbWUiOiAiU09VVEggQk9VTERFUiBDUkVFSyBCRUxPVyBHUk9TUyBSRVNFUlZPSVIiLCAic3RhdGlvbl9zdGF0dXMiOiAiQWN0aXZlIiwgInN0YXRpb25fdHlwZSI6ICJTdHJlYW0iLCAidXNnc19zdGF0aW9uX2lkIjogIjA2NzI5NDUwIiwgInZhcmlhYmxlIjogIkRJU0NIUkciLCAid2QiOiAiNiJ9LCAidHlwZSI6ICJGZWF0dXJlIn0sIHsiYmJveCI6IFstMTA1LjI1MTgyNiwgNDAuMjEyNTA1LCAtMTA1LjI1MTgyNiwgNDAuMjEyNTA1XSwgImdlb21ldHJ5IjogeyJjb29yZGluYXRlcyI6IFstMTA1LjI1MTgyNiwgNDAuMjEyNTA1XSwgInR5cGUiOiAiUG9pbnQifSwgImlkIjogIjQzIiwgInByb3BlcnRpZXMiOiB7ImFtb3VudCI6ICIwLjM1IiwgImNvdW50eSI6ICJCT1VMREVSIiwgImRhdGFfc291cmNlIjogIkNvb3BlcmF0aXZlIFByb2dyYW0gb2YgQ0RXUiwgTkNXQ0QgXHUwMDI2IFNWTEhXQ0QiLCAiZGF0ZV90aW1lIjogIjIwMjAtMDEtMzFUMTk6MDA6MDAuMDAwIiwgImRpdiI6ICIxIiwgImR3cl9hYmJyZXYiOiAiUEFMRElUQ08iLCAiZmxhZyI6IG51bGwsICJodHRwX2xpbmthZ2UudXJsIjogImh0dHBzOi8vZHdyLnN0YXRlLmNvLnVzL1N1cmZhY2VXYXRlci9kYXRhL2RldGFpbF9ncmFwaC5hc3B4P0lEPVBBTERJVENPXHUwMDI2TVRZUEU9RElTQ0hSRyIsICJsb2NhdGlvbi5sYXRpdHVkZSI6IDQwLjIxMjUwNSwgImxvY2F0aW9uLmxvbmdpdHVkZSI6IC0xMDUuMjUxODI2LCAibG9jYXRpb24ubmVlZHNfcmVjb2RpbmciOiBmYWxzZSwgInN0YWdlIjogIjAuMDYiLCAic3RhdGlvbl9uYW1lIjogIlBBTE1FUlRPTiBESVRDSCIsICJzdGF0aW9uX3N0YXR1cyI6ICJBY3RpdmUiLCAic3RhdGlvbl90eXBlIjogIkRpdmVyc2lvbiIsICJ1c2dzX3N0YXRpb25faWQiOiBudWxsLCAidmFyaWFibGUiOiAiRElTQ0hSRyIsICJ3ZCI6ICI1In0sICJ0eXBlIjogIkZlYXR1cmUifSwgeyJiYm94IjogWy0xMDUuMjU5Nzk1LCA0MC4yMTkwNDYsIC0xMDUuMjU5Nzk1LCA0MC4yMTkwNDZdLCAiZ2VvbWV0cnkiOiB7ImNvb3JkaW5hdGVzIjogWy0xMDUuMjU5Nzk1LCA0MC4yMTkwNDZdLCAidHlwZSI6ICJQb2ludCJ9LCAiaWQiOiAiNDQiLCAicHJvcGVydGllcyI6IHsiYW1vdW50IjogIjAuMDAiLCAiY291bnR5IjogIkJPVUxERVIiLCAiZGF0YV9zb3VyY2UiOiAiQ29vcGVyYXRpdmUgUHJvZ3JhbSBvZiBDRFdSLCBOQ1dDRCBcdTAwMjYgU1ZMSFdDRCIsICJkYXRlX3RpbWUiOiAiMjAyMC0wMS0zMVQxOTowMDowMC4wMDAiLCAiZGl2IjogIjEiLCAiZHdyX2FiYnJldiI6ICJTVVBESVRDTyIsICJmbGFnIjogbnVsbCwgImh0dHBfbGlua2FnZS51cmwiOiAiaHR0cHM6Ly9kd3Iuc3RhdGUuY28udXMvU3VyZmFjZVdhdGVyL2RhdGEvZGV0YWlsX2dyYXBoLmFzcHg/SUQ9U1VQRElUQ09cdTAwMjZNVFlQRT1ESVNDSFJHIiwgImxvY2F0aW9uLmxhdGl0dWRlIjogNDAuMjE5MDQ2LCAibG9jYXRpb24ubG9uZ2l0dWRlIjogLTEwNS4yNTk3OTUsICJsb2NhdGlvbi5uZWVkc19yZWNvZGluZyI6IGZhbHNlLCAic3RhZ2UiOiAiMC4wMCIsICJzdGF0aW9uX25hbWUiOiAiU1VQUExZIERJVENIIiwgInN0YXRpb25fc3RhdHVzIjogIkFjdGl2ZSIsICJzdGF0aW9uX3R5cGUiOiAiRGl2ZXJzaW9uIiwgInVzZ3Nfc3RhdGlvbl9pZCI6IG51bGwsICJ2YXJpYWJsZSI6ICJESVNDSFJHIiwgIndkIjogIjUifSwgInR5cGUiOiAiRmVhdHVyZSJ9LCB7ImJib3giOiBbLTEwNS4xODkxOTEsIDQwLjE4NzU3OCwgLTEwNS4xODkxOTEsIDQwLjE4NzU3OF0sICJnZW9tZXRyeSI6IHsiY29vcmRpbmF0ZXMiOiBbLTEwNS4xODkxOTEsIDQwLjE4NzU3OF0sICJ0eXBlIjogIlBvaW50In0sICJpZCI6ICI0NSIsICJwcm9wZXJ0aWVzIjogeyJhbW91bnQiOiAiMjgxNi4yNSIsICJjb3VudHkiOiAiQk9VTERFUiIsICJkYXRhX3NvdXJjZSI6ICJDb29wZXJhdGl2ZSBQcm9ncmFtIG9mIENEV1IsIE5DV0NEIFx1MDAyNiBTVkxIV0NEIiwgImRhdGVfdGltZSI6ICIyMDIwLTAxLTMxVDE5OjAwOjAwLjAwMCIsICJkaXYiOiAiMSIsICJkd3JfYWJicmV2IjogIkRFTlRBWUNPIiwgImZsYWciOiBudWxsLCAiaHR0cF9saW5rYWdlLnVybCI6ICJodHRwczovL2R3ci5zdGF0ZS5jby51cy9TdXJmYWNlV2F0ZXIvZGF0YS9kZXRhaWxfZ3JhcGguYXNweD9JRD1ERU5UQVlDT1x1MDAyNk1UWVBFPURJU0NIUkciLCAibG9jYXRpb24ubGF0aXR1ZGUiOiA0MC4xODc1NzgsICJsb2NhdGlvbi5sb25naXR1ZGUiOiAtMTA1LjE4OTE5MSwgImxvY2F0aW9uLm5lZWRzX3JlY29kaW5nIjogZmFsc2UsICJzdGFnZSI6ICI2Mi4yNiIsICJzdGF0aW9uX25hbWUiOiAiREVOSU8gVEFZTE9SIERJVENIIiwgInN0YXRpb25fc3RhdHVzIjogIkFjdGl2ZSIsICJzdGF0aW9uX3R5cGUiOiAiRGl2ZXJzaW9uIiwgInVzZ3Nfc3RhdGlvbl9pZCI6IG51bGwsICJ2YXJpYWJsZSI6ICJESVNDSFJHIiwgIndkIjogIjUifSwgInR5cGUiOiAiRmVhdHVyZSJ9LCB7ImJib3giOiBbLTEwNS4zNjQ5MTcwMDAwMDAwMiwgNDAuMDQyMDI4LCAtMTA1LjM2NDkxNzAwMDAwMDAyLCA0MC4wNDIwMjhdLCAiZ2VvbWV0cnkiOiB7ImNvb3JkaW5hdGVzIjogWy0xMDUuMzY0OTE3MDAwMDAwMDIsIDQwLjA0MjAyOF0sICJ0eXBlIjogIlBvaW50In0sICJpZCI6ICI0NiIsICJwcm9wZXJ0aWVzIjogeyJhbW91bnQiOiBudWxsLCAiY291bnR5IjogIkJPVUxERVIiLCAiZGF0YV9zb3VyY2UiOiAiVS5TLiBHZW9sb2dpY2FsIFN1cnZleSIsICJkYXRlX3RpbWUiOiAiMTk5OS0wOS0zMFQwMDowMDowMC4wMDAiLCAiZGl2IjogIjEiLCAiZHdyX2FiYnJldiI6ICJGUk1MTVJDTyIsICJmbGFnIjogbnVsbCwgImh0dHBfbGlua2FnZS51cmwiOiAiaHR0cHM6Ly93YXRlcmRhdGEudXNncy5nb3Yvbndpcy91dj8wNjcyNzQxMCIsICJsb2NhdGlvbi5sYXRpdHVkZSI6IDQwLjA0MjAyOCwgImxvY2F0aW9uLmxvbmdpdHVkZSI6IC0xMDUuMzY0OTE3LCAibG9jYXRpb24ubmVlZHNfcmVjb2RpbmciOiBmYWxzZSwgInN0YWdlIjogbnVsbCwgInN0YXRpb25fbmFtZSI6ICJGT1VSTUlMRSBDUkVFSyBBVCBMT0dBTiBNSUxMIFJPQUQgTkVBUiBDUklTTUFOLCBDTyIsICJzdGF0aW9uX3N0YXR1cyI6ICJBY3RpdmUiLCAic3RhdGlvbl90eXBlIjogIlN0cmVhbSIsICJ1c2dzX3N0YXRpb25faWQiOiAiMDY3Mjc0MTAiLCAidmFyaWFibGUiOiAiRElTQ0hSRyIsICJ3ZCI6ICI2In0sICJ0eXBlIjogIkZlYXR1cmUifSwgeyJiYm94IjogWy0xMDUuMTc4NTY3LCA0MC4xNzcwODAwMDAwMDAwMDQsIC0xMDUuMTc4NTY3LCA0MC4xNzcwODAwMDAwMDAwMDRdLCAiZ2VvbWV0cnkiOiB7ImNvb3JkaW5hdGVzIjogWy0xMDUuMTc4NTY3LCA0MC4xNzcwODAwMDAwMDAwMDRdLCAidHlwZSI6ICJQb2ludCJ9LCAiaWQiOiAiNDciLCAicHJvcGVydGllcyI6IHsiYW1vdW50IjogIjEuNDIiLCAiY291bnR5IjogIkJPVUxERVIiLCAiZGF0YV9zb3VyY2UiOiAiQ29vcGVyYXRpdmUgU0RSIFByb2dyYW0gb2YgQ0RXUiBcdTAwMjYgTkNXQ0QiLCAiZGF0ZV90aW1lIjogIjIwMjAtMDEtMzFUMTk6MDA6MDAuMDAwIiwgImRpdiI6ICIxIiwgImR3cl9hYmJyZXYiOiAiUENLUEVMQ08iLCAiZmxhZyI6IG51bGwsICJodHRwX2xpbmthZ2UudXJsIjogImh0dHBzOi8vZHdyLnN0YXRlLmNvLnVzL1N1cmZhY2VXYXRlci9kYXRhL2RldGFpbF9ncmFwaC5hc3B4P0lEPVBDS1BFTENPXHUwMDI2TVRZUEU9RElTQ0hSRyIsICJsb2NhdGlvbi5sYXRpdHVkZSI6IDQwLjE3NzA4LCAibG9jYXRpb24ubG9uZ2l0dWRlIjogLTEwNS4xNzg1NjcsICJsb2NhdGlvbi5uZWVkc19yZWNvZGluZyI6IGZhbHNlLCAic3RhZ2UiOiAiMC4xNyIsICJzdGF0aW9uX25hbWUiOiAiUEVDSyBQRUxMQSBDTE9WRVIgRElUQ0giLCAic3RhdGlvbl9zdGF0dXMiOiAiQWN0aXZlIiwgInN0YXRpb25fdHlwZSI6ICJEaXZlcnNpb24iLCAidXNnc19zdGF0aW9uX2lkIjogbnVsbCwgInZhcmlhYmxlIjogIkRJU0NIUkciLCAid2QiOiAiNSJ9LCAidHlwZSI6ICJGZWF0dXJlIn0sIHsiYmJveCI6IFstMTA1LjM1NzMwOCwgMzkuOTQ3NzA0LCAtMTA1LjM1NzMwOCwgMzkuOTQ3NzA0XSwgImdlb21ldHJ5IjogeyJjb29yZGluYXRlcyI6IFstMTA1LjM1NzMwOCwgMzkuOTQ3NzA0XSwgInR5cGUiOiAiUG9pbnQifSwgImlkIjogIjQ4IiwgInByb3BlcnRpZXMiOiB7ImFtb3VudCI6ICIxMjkxMi4wMCIsICJjb3VudHkiOiAiQk9VTERFUiIsICJkYXRhX3NvdXJjZSI6ICJDby4gRGl2aXNpb24gb2YgV2F0ZXIgUmVzb3VyY2VzIiwgImRhdGVfdGltZSI6ICIyMDIwLTAxLTMxVDE5OjMwOjAwLjAwMCIsICJkaXYiOiAiMSIsICJkd3JfYWJicmV2IjogIkdST1NSRUNPIiwgImZsYWciOiBudWxsLCAiaHR0cF9saW5rYWdlLnVybCI6ICJodHRwczovL2R3ci5zdGF0ZS5jby51cy9TdXJmYWNlV2F0ZXIvZGF0YS9kZXRhaWxfZ3JhcGguYXNweD9JRD1HUk9TUkVDT1x1MDAyNk1UWVBFPVNUT1JBR0UiLCAibG9jYXRpb24ubGF0aXR1ZGUiOiAzOS45NDc3MDQsICJsb2NhdGlvbi5sb25naXR1ZGUiOiAtMTA1LjM1NzMwOCwgImxvY2F0aW9uLm5lZWRzX3JlY29kaW5nIjogZmFsc2UsICJzdGFnZSI6ICI3MTg0LjU1IiwgInN0YXRpb25fbmFtZSI6ICJHUk9TUyBSRVNFUlZPSVIgIiwgInN0YXRpb25fc3RhdHVzIjogIkFjdGl2ZSIsICJzdGF0aW9uX3R5cGUiOiAiUmVzZXJ2b2lyIiwgInVzZ3Nfc3RhdGlvbl9pZCI6IG51bGwsICJ2YXJpYWJsZSI6ICJTVE9SQUdFIiwgIndkIjogIjYifSwgInR5cGUiOiAiRmVhdHVyZSJ9XSwgInR5cGUiOiAiRmVhdHVyZUNvbGxlY3Rpb24ifSk7CiAgICAgICAgCjwvc2NyaXB0Pg==" style="position:absolute;width:100%;height:100%;left:0;top:0;border:none !important;" allowfullscreen webkitallowfullscreen mozallowfullscreen></iframe></div></div>





Great - now you have a map! 

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



<div style="width:100%;"><div style="position:relative;width:100%;height:0;padding-bottom:60%;"><iframe src="data:text/html;charset=utf-8;base64,PCFET0NUWVBFIGh0bWw+CjxoZWFkPiAgICAKICAgIDxtZXRhIGh0dHAtZXF1aXY9ImNvbnRlbnQtdHlwZSIgY29udGVudD0idGV4dC9odG1sOyBjaGFyc2V0PVVURi04IiAvPgogICAgCiAgICAgICAgPHNjcmlwdD4KICAgICAgICAgICAgTF9OT19UT1VDSCA9IGZhbHNlOwogICAgICAgICAgICBMX0RJU0FCTEVfM0QgPSBmYWxzZTsKICAgICAgICA8L3NjcmlwdD4KICAgIAogICAgPHNjcmlwdCBzcmM9Imh0dHBzOi8vY2RuLmpzZGVsaXZyLm5ldC9ucG0vbGVhZmxldEAxLjUuMS9kaXN0L2xlYWZsZXQuanMiPjwvc2NyaXB0PgogICAgPHNjcmlwdCBzcmM9Imh0dHBzOi8vY29kZS5qcXVlcnkuY29tL2pxdWVyeS0xLjEyLjQubWluLmpzIj48L3NjcmlwdD4KICAgIDxzY3JpcHQgc3JjPSJodHRwczovL21heGNkbi5ib290c3RyYXBjZG4uY29tL2Jvb3RzdHJhcC8zLjIuMC9qcy9ib290c3RyYXAubWluLmpzIj48L3NjcmlwdD4KICAgIDxzY3JpcHQgc3JjPSJodHRwczovL2NkbmpzLmNsb3VkZmxhcmUuY29tL2FqYXgvbGlicy9MZWFmbGV0LmF3ZXNvbWUtbWFya2Vycy8yLjAuMi9sZWFmbGV0LmF3ZXNvbWUtbWFya2Vycy5qcyI+PC9zY3JpcHQ+CiAgICA8bGluayByZWw9InN0eWxlc2hlZXQiIGhyZWY9Imh0dHBzOi8vY2RuLmpzZGVsaXZyLm5ldC9ucG0vbGVhZmxldEAxLjUuMS9kaXN0L2xlYWZsZXQuY3NzIi8+CiAgICA8bGluayByZWw9InN0eWxlc2hlZXQiIGhyZWY9Imh0dHBzOi8vbWF4Y2RuLmJvb3RzdHJhcGNkbi5jb20vYm9vdHN0cmFwLzMuMi4wL2Nzcy9ib290c3RyYXAubWluLmNzcyIvPgogICAgPGxpbmsgcmVsPSJzdHlsZXNoZWV0IiBocmVmPSJodHRwczovL21heGNkbi5ib290c3RyYXBjZG4uY29tL2Jvb3RzdHJhcC8zLjIuMC9jc3MvYm9vdHN0cmFwLXRoZW1lLm1pbi5jc3MiLz4KICAgIDxsaW5rIHJlbD0ic3R5bGVzaGVldCIgaHJlZj0iaHR0cHM6Ly9tYXhjZG4uYm9vdHN0cmFwY2RuLmNvbS9mb250LWF3ZXNvbWUvNC42LjMvY3NzL2ZvbnQtYXdlc29tZS5taW4uY3NzIi8+CiAgICA8bGluayByZWw9InN0eWxlc2hlZXQiIGhyZWY9Imh0dHBzOi8vY2RuanMuY2xvdWRmbGFyZS5jb20vYWpheC9saWJzL0xlYWZsZXQuYXdlc29tZS1tYXJrZXJzLzIuMC4yL2xlYWZsZXQuYXdlc29tZS1tYXJrZXJzLmNzcyIvPgogICAgPGxpbmsgcmVsPSJzdHlsZXNoZWV0IiBocmVmPSJodHRwczovL3Jhd2Nkbi5naXRoYWNrLmNvbS9weXRob24tdmlzdWFsaXphdGlvbi9mb2xpdW0vbWFzdGVyL2ZvbGl1bS90ZW1wbGF0ZXMvbGVhZmxldC5hd2Vzb21lLnJvdGF0ZS5jc3MiLz4KICAgIDxzdHlsZT5odG1sLCBib2R5IHt3aWR0aDogMTAwJTtoZWlnaHQ6IDEwMCU7bWFyZ2luOiAwO3BhZGRpbmc6IDA7fTwvc3R5bGU+CiAgICA8c3R5bGU+I21hcCB7cG9zaXRpb246YWJzb2x1dGU7dG9wOjA7Ym90dG9tOjA7cmlnaHQ6MDtsZWZ0OjA7fTwvc3R5bGU+CiAgICAKICAgICAgICAgICAgPG1ldGEgbmFtZT0idmlld3BvcnQiIGNvbnRlbnQ9IndpZHRoPWRldmljZS13aWR0aCwKICAgICAgICAgICAgICAgIGluaXRpYWwtc2NhbGU9MS4wLCBtYXhpbXVtLXNjYWxlPTEuMCwgdXNlci1zY2FsYWJsZT1ubyIgLz4KICAgICAgICAgICAgPHN0eWxlPgogICAgICAgICAgICAgICAgI21hcF9hOTQ4MTMzNjIyYjg0NGE4YTQ2MzExZDVjYWYwNTExNCB7CiAgICAgICAgICAgICAgICAgICAgcG9zaXRpb246IHJlbGF0aXZlOwogICAgICAgICAgICAgICAgICAgIHdpZHRoOiAxMDAuMCU7CiAgICAgICAgICAgICAgICAgICAgaGVpZ2h0OiAxMDAuMCU7CiAgICAgICAgICAgICAgICAgICAgbGVmdDogMC4wJTsKICAgICAgICAgICAgICAgICAgICB0b3A6IDAuMCU7CiAgICAgICAgICAgICAgICB9CiAgICAgICAgICAgIDwvc3R5bGU+CiAgICAgICAgCiAgICA8c2NyaXB0IHNyYz0iaHR0cHM6Ly9jZG5qcy5jbG91ZGZsYXJlLmNvbS9hamF4L2xpYnMvbGVhZmxldC5tYXJrZXJjbHVzdGVyLzEuMS4wL2xlYWZsZXQubWFya2VyY2x1c3Rlci5qcyI+PC9zY3JpcHQ+CiAgICA8bGluayByZWw9InN0eWxlc2hlZXQiIGhyZWY9Imh0dHBzOi8vY2RuanMuY2xvdWRmbGFyZS5jb20vYWpheC9saWJzL2xlYWZsZXQubWFya2VyY2x1c3Rlci8xLjEuMC9NYXJrZXJDbHVzdGVyLmNzcyIvPgogICAgPGxpbmsgcmVsPSJzdHlsZXNoZWV0IiBocmVmPSJodHRwczovL2NkbmpzLmNsb3VkZmxhcmUuY29tL2FqYXgvbGlicy9sZWFmbGV0Lm1hcmtlcmNsdXN0ZXIvMS4xLjAvTWFya2VyQ2x1c3Rlci5EZWZhdWx0LmNzcyIvPgo8L2hlYWQ+Cjxib2R5PiAgICAKICAgIAogICAgICAgICAgICA8ZGl2IGNsYXNzPSJmb2xpdW0tbWFwIiBpZD0ibWFwX2E5NDgxMzM2MjJiODQ0YThhNDYzMTFkNWNhZjA1MTE0IiA+PC9kaXY+CiAgICAgICAgCjwvYm9keT4KPHNjcmlwdD4gICAgCiAgICAKICAgICAgICAgICAgdmFyIG1hcF9hOTQ4MTMzNjIyYjg0NGE4YTQ2MzExZDVjYWYwNTExNCA9IEwubWFwKAogICAgICAgICAgICAgICAgIm1hcF9hOTQ4MTMzNjIyYjg0NGE4YTQ2MzExZDVjYWYwNTExNCIsCiAgICAgICAgICAgICAgICB7CiAgICAgICAgICAgICAgICAgICAgY2VudGVyOiBbNDAuMDEsIC0xMDUuMjddLAogICAgICAgICAgICAgICAgICAgIGNyczogTC5DUlMuRVBTRzM4NTcsCiAgICAgICAgICAgICAgICAgICAgem9vbTogMTAsCiAgICAgICAgICAgICAgICAgICAgem9vbUNvbnRyb2w6IHRydWUsCiAgICAgICAgICAgICAgICAgICAgcHJlZmVyQ2FudmFzOiBmYWxzZSwKICAgICAgICAgICAgICAgIH0KICAgICAgICAgICAgKTsKCiAgICAgICAgICAgIAoKICAgICAgICAKICAgIAogICAgICAgICAgICB2YXIgdGlsZV9sYXllcl8zOWIxYzhjZTU3ZDE0ZmQ3YTE3ODk5YjU1OTkxZmQ1OCA9IEwudGlsZUxheWVyKAogICAgICAgICAgICAgICAgImh0dHBzOi8vY2FydG9kYi1iYXNlbWFwcy17c30uZ2xvYmFsLnNzbC5mYXN0bHkubmV0L2xpZ2h0X2FsbC97en0ve3h9L3t5fS5wbmciLAogICAgICAgICAgICAgICAgeyJhdHRyaWJ1dGlvbiI6ICJcdTAwMjZjb3B5OyBcdTAwM2NhIGhyZWY9XCJodHRwOi8vd3d3Lm9wZW5zdHJlZXRtYXAub3JnL2NvcHlyaWdodFwiXHUwMDNlT3BlblN0cmVldE1hcFx1MDAzYy9hXHUwMDNlIGNvbnRyaWJ1dG9ycyBcdTAwMjZjb3B5OyBcdTAwM2NhIGhyZWY9XCJodHRwOi8vY2FydG9kYi5jb20vYXR0cmlidXRpb25zXCJcdTAwM2VDYXJ0b0RCXHUwMDNjL2FcdTAwM2UsIENhcnRvREIgXHUwMDNjYSBocmVmID1cImh0dHA6Ly9jYXJ0b2RiLmNvbS9hdHRyaWJ1dGlvbnNcIlx1MDAzZWF0dHJpYnV0aW9uc1x1MDAzYy9hXHUwMDNlIiwgImRldGVjdFJldGluYSI6IGZhbHNlLCAibWF4TmF0aXZlWm9vbSI6IDE4LCAibWF4Wm9vbSI6IDE4LCAibWluWm9vbSI6IDAsICJub1dyYXAiOiBmYWxzZSwgIm9wYWNpdHkiOiAxLCAic3ViZG9tYWlucyI6ICJhYmMiLCAidG1zIjogZmFsc2V9CiAgICAgICAgICAgICkuYWRkVG8obWFwX2E5NDgxMzM2MjJiODQ0YThhNDYzMTFkNWNhZjA1MTE0KTsKICAgICAgICAKICAgIAogICAgICAgICAgICB2YXIgbWFya2VyX2NsdXN0ZXJfYjgxNmYyNDY1MzQwNGVlYWE2MjhjYjgzMDA3MmZhNjggPSBMLm1hcmtlckNsdXN0ZXJHcm91cCgKICAgICAgICAgICAgICAgIHt9CiAgICAgICAgICAgICk7CiAgICAgICAgICAgIG1hcF9hOTQ4MTMzNjIyYjg0NGE4YTQ2MzExZDVjYWYwNTExNC5hZGRMYXllcihtYXJrZXJfY2x1c3Rlcl9iODE2ZjI0NjUzNDA0ZWVhYTYyOGNiODMwMDcyZmE2OCk7CiAgICAgICAgCiAgICAKICAgICAgICAgICAgdmFyIG1hcmtlcl8wNzYzNDE5MmRlNmY0NDQ4YThjMWU4NTA3ZGQ1NGEyNyA9IEwubWFya2VyKAogICAgICAgICAgICAgICAgWzQwLjE4NTAzMywgLTEwNS4xODU3ODldLAogICAgICAgICAgICAgICAge30KICAgICAgICAgICAgKS5hZGRUbyhtYXJrZXJfY2x1c3Rlcl9iODE2ZjI0NjUzNDA0ZWVhYTYyOGNiODMwMDcyZmE2OCk7CiAgICAgICAgCiAgICAKICAgICAgICB2YXIgcG9wdXBfNWE3ODhhNTQ1ODNjNGViMzlhZjVkYzAyZDJhNzcyMzYgPSBMLnBvcHVwKHsibWF4V2lkdGgiOiAiMTAwJSJ9KTsKCiAgICAgICAgCiAgICAgICAgICAgIHZhciBodG1sX2NlMDJhNjVlMzc5ZjQ1ZDM4ZWEyMmRlMzIzZmMyM2NhID0gJChgPGRpdiBpZD0iaHRtbF9jZTAyYTY1ZTM3OWY0NWQzOGVhMjJkZTMyM2ZjMjNjYSIgc3R5bGU9IndpZHRoOiAxMDAuMCU7IGhlaWdodDogMTAwLjAlOyI+TmFtZTogWldFQ0sgQU5EIFRVUk5FUiBESVRDSCBQcmVjaXA6IDAuMzA8L2Rpdj5gKVswXTsKICAgICAgICAgICAgcG9wdXBfNWE3ODhhNTQ1ODNjNGViMzlhZjVkYzAyZDJhNzcyMzYuc2V0Q29udGVudChodG1sX2NlMDJhNjVlMzc5ZjQ1ZDM4ZWEyMmRlMzIzZmMyM2NhKTsKICAgICAgICAKCiAgICAgICAgbWFya2VyXzA3NjM0MTkyZGU2ZjQ0NDhhOGMxZTg1MDdkZDU0YTI3LmJpbmRQb3B1cChwb3B1cF81YTc4OGE1NDU4M2M0ZWIzOWFmNWRjMDJkMmE3NzIzNikKICAgICAgICA7CgogICAgICAgIAogICAgCiAgICAKICAgICAgICAgICAgdmFyIG1hcmtlcl84MzhiZWFjMzA1OGQ0NzliYjkzNDgwMzY4ZTg5NzkyOSA9IEwubWFya2VyKAogICAgICAgICAgICAgICAgWzQwLjIyMDcwMiwgLTEwNS4yNjM0OV0sCiAgICAgICAgICAgICAgICB7fQogICAgICAgICAgICApLmFkZFRvKG1hcmtlcl9jbHVzdGVyX2I4MTZmMjQ2NTM0MDRlZWFhNjI4Y2I4MzAwNzJmYTY4KTsKICAgICAgICAKICAgIAogICAgICAgIHZhciBwb3B1cF8xNGIxMDZjYTlkN2M0NGFmYjE5ZDAyNWQ5ZDQ3MWM5MiA9IEwucG9wdXAoeyJtYXhXaWR0aCI6ICIxMDAlIn0pOwoKICAgICAgICAKICAgICAgICAgICAgdmFyIGh0bWxfNThjYTk1YzUyODZlNGE2MDljMjZiMmFmNGEyZjA2ZmUgPSAkKGA8ZGl2IGlkPSJodG1sXzU4Y2E5NWM1Mjg2ZTRhNjA5YzI2YjJhZjRhMmYwNmZlIiBzdHlsZT0id2lkdGg6IDEwMC4wJTsgaGVpZ2h0OiAxMDAuMCU7Ij5OYW1lOiBTQUlOVCBWUkFJTiBDUkVFSyBBVCBMWU9OUywgQ08gUHJlY2lwOiAyNC4yMDwvZGl2PmApWzBdOwogICAgICAgICAgICBwb3B1cF8xNGIxMDZjYTlkN2M0NGFmYjE5ZDAyNWQ5ZDQ3MWM5Mi5zZXRDb250ZW50KGh0bWxfNThjYTk1YzUyODZlNGE2MDljMjZiMmFmNGEyZjA2ZmUpOwogICAgICAgIAoKICAgICAgICBtYXJrZXJfODM4YmVhYzMwNThkNDc5YmI5MzQ4MDM2OGU4OTc5MjkuYmluZFBvcHVwKHBvcHVwXzE0YjEwNmNhOWQ3YzQ0YWZiMTlkMDI1ZDlkNDcxYzkyKQogICAgICAgIDsKCiAgICAgICAgCiAgICAKICAgIAogICAgICAgICAgICB2YXIgbWFya2VyXzc0MjM3YTUxYjVlZDQ5MjliOTllZjQyMTRlOGNmNTk4ID0gTC5tYXJrZXIoCiAgICAgICAgICAgICAgICBbNDAuMTk2NDIyLCAtMTA1LjIwNjU5Ml0sCiAgICAgICAgICAgICAgICB7fQogICAgICAgICAgICApLmFkZFRvKG1hcmtlcl9jbHVzdGVyX2I4MTZmMjQ2NTM0MDRlZWFhNjI4Y2I4MzAwNzJmYTY4KTsKICAgICAgICAKICAgIAogICAgICAgIHZhciBwb3B1cF8yZjgwMWFhNmIyNWY0OGNlOTEyNTc0YzUyZDIyYmNlZCA9IEwucG9wdXAoeyJtYXhXaWR0aCI6ICIxMDAlIn0pOwoKICAgICAgICAKICAgICAgICAgICAgdmFyIGh0bWxfM2E2OTRiY2RiODFlNGYzMDhjNTZlOWJhZDljMGY2YjUgPSAkKGA8ZGl2IGlkPSJodG1sXzNhNjk0YmNkYjgxZTRmMzA4YzU2ZTliYWQ5YzBmNmI1IiBzdHlsZT0id2lkdGg6IDEwMC4wJTsgaGVpZ2h0OiAxMDAuMCU7Ij5OYW1lOiBPTElHQVJDSFkgRElUQ0ggRElWRVJTSU9OIFByZWNpcDogMzMuMjc8L2Rpdj5gKVswXTsKICAgICAgICAgICAgcG9wdXBfMmY4MDFhYTZiMjVmNDhjZTkxMjU3NGM1MmQyMmJjZWQuc2V0Q29udGVudChodG1sXzNhNjk0YmNkYjgxZTRmMzA4YzU2ZTliYWQ5YzBmNmI1KTsKICAgICAgICAKCiAgICAgICAgbWFya2VyXzc0MjM3YTUxYjVlZDQ5MjliOTllZjQyMTRlOGNmNTk4LmJpbmRQb3B1cChwb3B1cF8yZjgwMWFhNmIyNWY0OGNlOTEyNTc0YzUyZDIyYmNlZCkKICAgICAgICA7CgogICAgICAgIAogICAgCiAgICAKICAgICAgICAgICAgdmFyIG1hcmtlcl9kNDY4ZDdmM2Q3ZTU0ZDczYTY2M2Y0M2RiOTNhYzZhZSA9IEwubWFya2VyKAogICAgICAgICAgICAgICAgWzM5LjkzMTgxMywgLTEwNS4zMDg0MzJdLAogICAgICAgICAgICAgICAge30KICAgICAgICAgICAgKS5hZGRUbyhtYXJrZXJfY2x1c3Rlcl9iODE2ZjI0NjUzNDA0ZWVhYTYyOGNiODMwMDcyZmE2OCk7CiAgICAgICAgCiAgICAKICAgICAgICB2YXIgcG9wdXBfMGU0ZWMyMzRkZGM4NGFlMjlkN2QwYjU0N2ZiMDhjYTQgPSBMLnBvcHVwKHsibWF4V2lkdGgiOiAiMTAwJSJ9KTsKCiAgICAgICAgCiAgICAgICAgICAgIHZhciBodG1sXzdiMjU1ZDNmNTY2MjQ4OTZiZDMyYTkyMGNjOWYzMGZiID0gJChgPGRpdiBpZD0iaHRtbF83YjI1NWQzZjU2NjI0ODk2YmQzMmE5MjBjYzlmMzBmYiIgc3R5bGU9IndpZHRoOiAxMDAuMCU7IGhlaWdodDogMTAwLjAlOyI+TmFtZTogU09VVEggQk9VTERFUiBDUkVFSyBESVZFUlNJT04gTkVBUiBFTERPUkFETyBTUFJJTkdTIFByZWNpcDogNzUuMjA8L2Rpdj5gKVswXTsKICAgICAgICAgICAgcG9wdXBfMGU0ZWMyMzRkZGM4NGFlMjlkN2QwYjU0N2ZiMDhjYTQuc2V0Q29udGVudChodG1sXzdiMjU1ZDNmNTY2MjQ4OTZiZDMyYTkyMGNjOWYzMGZiKTsKICAgICAgICAKCiAgICAgICAgbWFya2VyX2Q0NjhkN2YzZDdlNTRkNzNhNjYzZjQzZGI5M2FjNmFlLmJpbmRQb3B1cChwb3B1cF8wZTRlYzIzNGRkYzg0YWUyOWQ3ZDBiNTQ3ZmIwOGNhNCkKICAgICAgICA7CgogICAgICAgIAogICAgCiAgICAKICAgICAgICAgICAgdmFyIG1hcmtlcl85ODYyZDY3Y2JjMmQ0ZDE3YTdhYWI1MzFiY2RjMGM1ZCA9IEwubWFya2VyKAogICAgICAgICAgICAgICAgWzQwLjE5Mzc1OCwgLTEwNS4yMTAzOV0sCiAgICAgICAgICAgICAgICB7fQogICAgICAgICAgICApLmFkZFRvKG1hcmtlcl9jbHVzdGVyX2I4MTZmMjQ2NTM0MDRlZWFhNjI4Y2I4MzAwNzJmYTY4KTsKICAgICAgICAKICAgIAogICAgICAgIHZhciBwb3B1cF82NDBjNTFmZDgxZWQ0MjIxOTYyYzI2ZDBkMjk3Y2I4ZCA9IEwucG9wdXAoeyJtYXhXaWR0aCI6ICIxMDAlIn0pOwoKICAgICAgICAKICAgICAgICAgICAgdmFyIGh0bWxfMTg1ZDUwNTMyOTJiNDA4NTk5ZmQxMWU2Zjc4YWQwNDYgPSAkKGA8ZGl2IGlkPSJodG1sXzE4NWQ1MDUzMjkyYjQwODU5OWZkMTFlNmY3OGFkMDQ2IiBzdHlsZT0id2lkdGg6IDEwMC4wJTsgaGVpZ2h0OiAxMDAuMCU7Ij5OYW1lOiBDTE9VR0ggQU5EIFRSVUUgRElUQ0ggUHJlY2lwOiAwLjAwPC9kaXY+YClbMF07CiAgICAgICAgICAgIHBvcHVwXzY0MGM1MWZkODFlZDQyMjE5NjJjMjZkMGQyOTdjYjhkLnNldENvbnRlbnQoaHRtbF8xODVkNTA1MzI5MmI0MDg1OTlmZDExZTZmNzhhZDA0Nik7CiAgICAgICAgCgogICAgICAgIG1hcmtlcl85ODYyZDY3Y2JjMmQ0ZDE3YTdhYWI1MzFiY2RjMGM1ZC5iaW5kUG9wdXAocG9wdXBfNjQwYzUxZmQ4MWVkNDIyMTk2MmMyNmQwZDI5N2NiOGQpCiAgICAgICAgOwoKICAgICAgICAKICAgIAogICAgCiAgICAgICAgICAgIHZhciBtYXJrZXJfMzkyOTUxMmNiNzMyNDQ1Yjk2MTE0ZWNkMDdhMDMzYTYgPSBMLm1hcmtlcigKICAgICAgICAgICAgICAgIFs0MC4wMDYzOCwgLTEwNS4zMzA4NDFdLAogICAgICAgICAgICAgICAge30KICAgICAgICAgICAgKS5hZGRUbyhtYXJrZXJfY2x1c3Rlcl9iODE2ZjI0NjUzNDA0ZWVhYTYyOGNiODMwMDcyZmE2OCk7CiAgICAgICAgCiAgICAKICAgICAgICB2YXIgcG9wdXBfM2RiNTJiMzg1YmYyNDBmMzk5MTUwNTkxNGM5YjViYzEgPSBMLnBvcHVwKHsibWF4V2lkdGgiOiAiMTAwJSJ9KTsKCiAgICAgICAgCiAgICAgICAgICAgIHZhciBodG1sXzQ0ZjZhZmM4MzU4NzRlN2U4NzQzOTM1NjE4NTg3MjJlID0gJChgPGRpdiBpZD0iaHRtbF80NGY2YWZjODM1ODc0ZTdlODc0MzkzNTYxODU4NzIyZSIgc3R5bGU9IndpZHRoOiAxMDAuMCU7IGhlaWdodDogMTAwLjAlOyI+TmFtZTogQk9VTERFUiBDUkVFSyBORUFSIE9ST0RFTEwsIENPLiBQcmVjaXA6IDEyLjQwPC9kaXY+YClbMF07CiAgICAgICAgICAgIHBvcHVwXzNkYjUyYjM4NWJmMjQwZjM5OTE1MDU5MTRjOWI1YmMxLnNldENvbnRlbnQoaHRtbF80NGY2YWZjODM1ODc0ZTdlODc0MzkzNTYxODU4NzIyZSk7CiAgICAgICAgCgogICAgICAgIG1hcmtlcl8zOTI5NTEyY2I3MzI0NDViOTYxMTRlY2QwN2EwMzNhNi5iaW5kUG9wdXAocG9wdXBfM2RiNTJiMzg1YmYyNDBmMzk5MTUwNTkxNGM5YjViYzEpCiAgICAgICAgOwoKICAgICAgICAKICAgIAogICAgCiAgICAgICAgICAgIHZhciBtYXJrZXJfYWRiMTA0ZDhjMTI0NDUwNWJmZTY4YmM0ODAyNjI0MTkgPSBMLm1hcmtlcigKICAgICAgICAgICAgICAgIFs0MC4yMDQxOTMsIC0xMDUuMjE4Nzc3XSwKICAgICAgICAgICAgICAgIHt9CiAgICAgICAgICAgICkuYWRkVG8obWFya2VyX2NsdXN0ZXJfYjgxNmYyNDY1MzQwNGVlYWE2MjhjYjgzMDA3MmZhNjgpOwogICAgICAgIAogICAgCiAgICAgICAgdmFyIHBvcHVwX2Q3YzQ4OTA3MjQ1MDQxODk5ODI0MjdhNDM1MzA2MDE1ID0gTC5wb3B1cCh7Im1heFdpZHRoIjogIjEwMCUifSk7CgogICAgICAgIAogICAgICAgICAgICB2YXIgaHRtbF80OWU0ZWM4N2ZhZjc0ZmE0ODk2NzNmMDFkMzhhNWIwNSA9ICQoYDxkaXYgaWQ9Imh0bWxfNDllNGVjODdmYWY3NGZhNDg5NjczZjAxZDM4YTViMDUiIHN0eWxlPSJ3aWR0aDogMTAwLjAlOyBoZWlnaHQ6IDEwMC4wJTsiPk5hbWU6IExPTkdNT05UIFNVUFBMWSBESVRDSCBQcmVjaXA6IDAuMDA8L2Rpdj5gKVswXTsKICAgICAgICAgICAgcG9wdXBfZDdjNDg5MDcyNDUwNDE4OTk4MjQyN2E0MzUzMDYwMTUuc2V0Q29udGVudChodG1sXzQ5ZTRlYzg3ZmFmNzRmYTQ4OTY3M2YwMWQzOGE1YjA1KTsKICAgICAgICAKCiAgICAgICAgbWFya2VyX2FkYjEwNGQ4YzEyNDQ1MDViZmU2OGJjNDgwMjYyNDE5LmJpbmRQb3B1cChwb3B1cF9kN2M0ODkwNzI0NTA0MTg5OTgyNDI3YTQzNTMwNjAxNSkKICAgICAgICA7CgogICAgICAgIAogICAgCiAgICAKICAgICAgICAgICAgdmFyIG1hcmtlcl84OGIxOTRiOWFiOWI0ZDM2YWUzNTNiNDQzZDM0Yzg3ZSA9IEwubWFya2VyKAogICAgICAgICAgICAgICAgWzQwLjE3MjkyNSwgLTEwNS4xNjc2MjJdLAogICAgICAgICAgICAgICAge30KICAgICAgICAgICAgKS5hZGRUbyhtYXJrZXJfY2x1c3Rlcl9iODE2ZjI0NjUzNDA0ZWVhYTYyOGNiODMwMDcyZmE2OCk7CiAgICAgICAgCiAgICAKICAgICAgICB2YXIgcG9wdXBfYjlhZTUxMWRhYzc4NGVlMDhkNTQ0Y2E1YTI0NTc3NWYgPSBMLnBvcHVwKHsibWF4V2lkdGgiOiAiMTAwJSJ9KTsKCiAgICAgICAgCiAgICAgICAgICAgIHZhciBodG1sXzQ0NjQ4OTQwYmY4ZDRjODlhYmY1MDVjM2ViZDhhZDM2ID0gJChgPGRpdiBpZD0iaHRtbF80NDY0ODk0MGJmOGQ0Yzg5YWJmNTA1YzNlYmQ4YWQzNiIgc3R5bGU9IndpZHRoOiAxMDAuMCU7IGhlaWdodDogMTAwLjAlOyI+TmFtZTogTk9SVEhXRVNUIE1VVFVBTCBESVRDSCBQcmVjaXA6IDAuMDA8L2Rpdj5gKVswXTsKICAgICAgICAgICAgcG9wdXBfYjlhZTUxMWRhYzc4NGVlMDhkNTQ0Y2E1YTI0NTc3NWYuc2V0Q29udGVudChodG1sXzQ0NjQ4OTQwYmY4ZDRjODlhYmY1MDVjM2ViZDhhZDM2KTsKICAgICAgICAKCiAgICAgICAgbWFya2VyXzg4YjE5NGI5YWI5YjRkMzZhZTM1M2I0NDNkMzRjODdlLmJpbmRQb3B1cChwb3B1cF9iOWFlNTExZGFjNzg0ZWUwOGQ1NDRjYTVhMjQ1Nzc1ZikKICAgICAgICA7CgogICAgICAgIAogICAgCiAgICAKICAgICAgICAgICAgdmFyIG1hcmtlcl82ZTkwZjEwM2ZjNjE0OTNiYjk5OGNlMWM0ZTM3YWY2ZiA9IEwubWFya2VyKAogICAgICAgICAgICAgICAgWzQwLjEzNDI3OCwgLTEwNS4xMzA4MTldLAogICAgICAgICAgICAgICAge30KICAgICAgICAgICAgKS5hZGRUbyhtYXJrZXJfY2x1c3Rlcl9iODE2ZjI0NjUzNDA0ZWVhYTYyOGNiODMwMDcyZmE2OCk7CiAgICAgICAgCiAgICAKICAgICAgICB2YXIgcG9wdXBfYzkyNDIxZjZhMjlkNDc4ZDg3NjA3NjJkM2VlOTFlZjkgPSBMLnBvcHVwKHsibWF4V2lkdGgiOiAiMTAwJSJ9KTsKCiAgICAgICAgCiAgICAgICAgICAgIHZhciBodG1sXzAwYjM5NTgwYTE1YTQ0ZjBiM2EwZjgyYjcwZDQyYjhiID0gJChgPGRpdiBpZD0iaHRtbF8wMGIzOTU4MGExNWE0NGYwYjNhMGY4MmI3MGQ0MmI4YiIgc3R5bGU9IndpZHRoOiAxMDAuMCU7IGhlaWdodDogMTAwLjAlOyI+TmFtZTogTEVGVCBIQU5EIENSRUVLIEFUIEhPVkVSIFJPQUQgTkVBUiBMT05HTU9OVCwgQ08gUHJlY2lwOiA1LjUwPC9kaXY+YClbMF07CiAgICAgICAgICAgIHBvcHVwX2M5MjQyMWY2YTI5ZDQ3OGQ4NzYwNzYyZDNlZTkxZWY5LnNldENvbnRlbnQoaHRtbF8wMGIzOTU4MGExNWE0NGYwYjNhMGY4MmI3MGQ0MmI4Yik7CiAgICAgICAgCgogICAgICAgIG1hcmtlcl82ZTkwZjEwM2ZjNjE0OTNiYjk5OGNlMWM0ZTM3YWY2Zi5iaW5kUG9wdXAocG9wdXBfYzkyNDIxZjZhMjlkNDc4ZDg3NjA3NjJkM2VlOTFlZjkpCiAgICAgICAgOwoKICAgICAgICAKICAgIAogICAgCiAgICAgICAgICAgIHZhciBtYXJrZXJfMDczZDg3NWExNGVlNGZjNmIxYTQxMDI2YjQwNTQ3NzcgPSBMLm1hcmtlcigKICAgICAgICAgICAgICAgIFszOS45ODYxNjksIC0xMDUuMjE4Njc3XSwKICAgICAgICAgICAgICAgIHt9CiAgICAgICAgICAgICkuYWRkVG8obWFya2VyX2NsdXN0ZXJfYjgxNmYyNDY1MzQwNGVlYWE2MjhjYjgzMDA3MmZhNjgpOwogICAgICAgIAogICAgCiAgICAgICAgdmFyIHBvcHVwXzYyYTA5YmE2MDlmOTQwMGViYzE3MGUxMmY2ZmQ3MGNiID0gTC5wb3B1cCh7Im1heFdpZHRoIjogIjEwMCUifSk7CgogICAgICAgIAogICAgICAgICAgICB2YXIgaHRtbF9iYTM5MjdiYzE2YmI0M2Q0OTQ1Y2ViOTJmN2Q4M2RkNyA9ICQoYDxkaXYgaWQ9Imh0bWxfYmEzOTI3YmMxNmJiNDNkNDk0NWNlYjkyZjdkODNkZDciIHN0eWxlPSJ3aWR0aDogMTAwLjAlOyBoZWlnaHQ6IDEwMC4wJTsiPk5hbWU6IERSWSBDUkVFSyBDQVJSSUVSIFByZWNpcDogMS42OTwvZGl2PmApWzBdOwogICAgICAgICAgICBwb3B1cF82MmEwOWJhNjA5Zjk0MDBlYmMxNzBlMTJmNmZkNzBjYi5zZXRDb250ZW50KGh0bWxfYmEzOTI3YmMxNmJiNDNkNDk0NWNlYjkyZjdkODNkZDcpOwogICAgICAgIAoKICAgICAgICBtYXJrZXJfMDczZDg3NWExNGVlNGZjNmIxYTQxMDI2YjQwNTQ3NzcuYmluZFBvcHVwKHBvcHVwXzYyYTA5YmE2MDlmOTQwMGViYzE3MGUxMmY2ZmQ3MGNiKQogICAgICAgIDsKCiAgICAgICAgCiAgICAKICAgIAogICAgICAgICAgICB2YXIgbWFya2VyX2I4MmUwMDc3NWVjZjQ0NjBhNWUxYzdlMzI3YjU4ZTQyID0gTC5tYXJrZXIoCiAgICAgICAgICAgICAgICBbNDAuMTYwNzA1LCAtMTA1LjE2ODQ3MV0sCiAgICAgICAgICAgICAgICB7fQogICAgICAgICAgICApLmFkZFRvKG1hcmtlcl9jbHVzdGVyX2I4MTZmMjQ2NTM0MDRlZWFhNjI4Y2I4MzAwNzJmYTY4KTsKICAgICAgICAKICAgIAogICAgICAgIHZhciBwb3B1cF84OTg2NWQ5NmE1ODc0NWIxYTZhZDMxZTEyYjA1OTg5ZCA9IEwucG9wdXAoeyJtYXhXaWR0aCI6ICIxMDAlIn0pOwoKICAgICAgICAKICAgICAgICAgICAgdmFyIGh0bWxfM2VjMzYyYTRmNmUyNDJmYmJkOTE2Nzk5ZWE1YzAzOTIgPSAkKGA8ZGl2IGlkPSJodG1sXzNlYzM2MmE0ZjZlMjQyZmJiZDkxNjc5OWVhNWMwMzkyIiBzdHlsZT0id2lkdGg6IDEwMC4wJTsgaGVpZ2h0OiAxMDAuMCU7Ij5OYW1lOiBQRUNLLVBFTExBIEFVR01FTlRBVElPTiBSRVRVUk4gUHJlY2lwOiAwLjAwPC9kaXY+YClbMF07CiAgICAgICAgICAgIHBvcHVwXzg5ODY1ZDk2YTU4NzQ1YjFhNmFkMzFlMTJiMDU5ODlkLnNldENvbnRlbnQoaHRtbF8zZWMzNjJhNGY2ZTI0MmZiYmQ5MTY3OTllYTVjMDM5Mik7CiAgICAgICAgCgogICAgICAgIG1hcmtlcl9iODJlMDA3NzVlY2Y0NDYwYTVlMWM3ZTMyN2I1OGU0Mi5iaW5kUG9wdXAocG9wdXBfODk4NjVkOTZhNTg3NDViMWE2YWQzMWUxMmIwNTk4OWQpCiAgICAgICAgOwoKICAgICAgICAKICAgIAogICAgCiAgICAgICAgICAgIHZhciBtYXJrZXJfZWZhNDMxOTU2OGIyNDc5Mzk3NmE4ZjA5M2I5NDBjMmYgPSBMLm1hcmtlcigKICAgICAgICAgICAgICAgIFs0MC4xOTkzMjEsIC0xMDUuMjIyNjM5XSwKICAgICAgICAgICAgICAgIHt9CiAgICAgICAgICAgICkuYWRkVG8obWFya2VyX2NsdXN0ZXJfYjgxNmYyNDY1MzQwNGVlYWE2MjhjYjgzMDA3MmZhNjgpOwogICAgICAgIAogICAgCiAgICAgICAgdmFyIHBvcHVwXzI5ZTcxNzY0NWIwNDRmMjA5N2I3ZjMyYzZiYWQ5YWFhID0gTC5wb3B1cCh7Im1heFdpZHRoIjogIjEwMCUifSk7CgogICAgICAgIAogICAgICAgICAgICB2YXIgaHRtbF80ZGZiMTAzODExZTg0MmVmYmUwNzIxODUwMDY4OWY1OCA9ICQoYDxkaXYgaWQ9Imh0bWxfNGRmYjEwMzgxMWU4NDJlZmJlMDcyMTg1MDA2ODlmNTgiIHN0eWxlPSJ3aWR0aDogMTAwLjAlOyBoZWlnaHQ6IDEwMC4wJTsiPk5hbWU6IEdPU1MgRElUQ0ggMSBQcmVjaXA6IDAuMDA8L2Rpdj5gKVswXTsKICAgICAgICAgICAgcG9wdXBfMjllNzE3NjQ1YjA0NGYyMDk3YjdmMzJjNmJhZDlhYWEuc2V0Q29udGVudChodG1sXzRkZmIxMDM4MTFlODQyZWZiZTA3MjE4NTAwNjg5ZjU4KTsKICAgICAgICAKCiAgICAgICAgbWFya2VyX2VmYTQzMTk1NjhiMjQ3OTM5NzZhOGYwOTNiOTQwYzJmLmJpbmRQb3B1cChwb3B1cF8yOWU3MTc2NDViMDQ0ZjIwOTdiN2YzMmM2YmFkOWFhYSkKICAgICAgICA7CgogICAgICAgIAogICAgCiAgICAKICAgICAgICAgICAgdmFyIG1hcmtlcl8zYWY2YzhlMWJkNDA0YWYyYmM4ZjNkMzkyMzhlNTg2YiA9IEwubWFya2VyKAogICAgICAgICAgICAgICAgWzQwLjE5MzI4LCAtMTA1LjIxMDQyNF0sCiAgICAgICAgICAgICAgICB7fQogICAgICAgICAgICApLmFkZFRvKG1hcmtlcl9jbHVzdGVyX2I4MTZmMjQ2NTM0MDRlZWFhNjI4Y2I4MzAwNzJmYTY4KTsKICAgICAgICAKICAgIAogICAgICAgIHZhciBwb3B1cF9lYjQyOTA1Zjg1OWE0Y2MxYjc1YjA2NmNmZDQ5ZDVjNyA9IEwucG9wdXAoeyJtYXhXaWR0aCI6ICIxMDAlIn0pOwoKICAgICAgICAKICAgICAgICAgICAgdmFyIGh0bWxfY2YzNTg1ZDg4NjQ1NGEzOWE3ZGVlZjZmNDgzZDE4YjIgPSAkKGA8ZGl2IGlkPSJodG1sX2NmMzU4NWQ4ODY0NTRhMzlhN2RlZWY2ZjQ4M2QxOGIyIiBzdHlsZT0id2lkdGg6IDEwMC4wJTsgaGVpZ2h0OiAxMDAuMCU7Ij5OYW1lOiBXRUJTVEVSIE1DQ0FTTElOIERJVENIIFByZWNpcDogMC4wMDwvZGl2PmApWzBdOwogICAgICAgICAgICBwb3B1cF9lYjQyOTA1Zjg1OWE0Y2MxYjc1YjA2NmNmZDQ5ZDVjNy5zZXRDb250ZW50KGh0bWxfY2YzNTg1ZDg4NjQ1NGEzOWE3ZGVlZjZmNDgzZDE4YjIpOwogICAgICAgIAoKICAgICAgICBtYXJrZXJfM2FmNmM4ZTFiZDQwNGFmMmJjOGYzZDM5MjM4ZTU4NmIuYmluZFBvcHVwKHBvcHVwX2ViNDI5MDVmODU5YTRjYzFiNzViMDY2Y2ZkNDlkNWM3KQogICAgICAgIDsKCiAgICAgICAgCiAgICAKICAgIAogICAgICAgICAgICB2YXIgbWFya2VyX2U2M2JkYmEyZTc4YzQyNjliZWZhNmM2ODljNmM3NTU3ID0gTC5tYXJrZXIoCiAgICAgICAgICAgICAgICBbNDAuMDUzNjYxLCAtMTA1LjE1MTE0M10sCiAgICAgICAgICAgICAgICB7fQogICAgICAgICAgICApLmFkZFRvKG1hcmtlcl9jbHVzdGVyX2I4MTZmMjQ2NTM0MDRlZWFhNjI4Y2I4MzAwNzJmYTY4KTsKICAgICAgICAKICAgIAogICAgICAgIHZhciBwb3B1cF9iN2U2NjNiNWMzODA0MTlhYWFiYTlkMDk3MDEwZTEwYiA9IEwucG9wdXAoeyJtYXhXaWR0aCI6ICIxMDAlIn0pOwoKICAgICAgICAKICAgICAgICAgICAgdmFyIGh0bWxfMzAxZGVlMGI1ZjJmNGNlZGI0YjA5MDgyNGUzNThmOGQgPSAkKGA8ZGl2IGlkPSJodG1sXzMwMWRlZTBiNWYyZjRjZWRiNGIwOTA4MjRlMzU4ZjhkIiBzdHlsZT0id2lkdGg6IDEwMC4wJTsgaGVpZ2h0OiAxMDAuMCU7Ij5OYW1lOiBMRUdHRVRUIERJVENIIFByZWNpcDogMjYuNTY8L2Rpdj5gKVswXTsKICAgICAgICAgICAgcG9wdXBfYjdlNjYzYjVjMzgwNDE5YWFhYmE5ZDA5NzAxMGUxMGIuc2V0Q29udGVudChodG1sXzMwMWRlZTBiNWYyZjRjZWRiNGIwOTA4MjRlMzU4ZjhkKTsKICAgICAgICAKCiAgICAgICAgbWFya2VyX2U2M2JkYmEyZTc4YzQyNjliZWZhNmM2ODljNmM3NTU3LmJpbmRQb3B1cChwb3B1cF9iN2U2NjNiNWMzODA0MTlhYWFiYTlkMDk3MDEwZTEwYikKICAgICAgICA7CgogICAgICAgIAogICAgCiAgICAKICAgICAgICAgICAgdmFyIG1hcmtlcl80MDhkNzViODQwNjA0ZDc2YTMxZDZkOTNiNGZhNmI2ZCA9IEwubWFya2VyKAogICAgICAgICAgICAgICAgWzQwLjIxNjI2MywgLTEwNS4zNjUzNjVdLAogICAgICAgICAgICAgICAge30KICAgICAgICAgICAgKS5hZGRUbyhtYXJrZXJfY2x1c3Rlcl9iODE2ZjI0NjUzNDA0ZWVhYTYyOGNiODMwMDcyZmE2OCk7CiAgICAgICAgCiAgICAKICAgICAgICB2YXIgcG9wdXBfM2JlN2EzYTk2ZTlmNDQxMWE5ODQ1MGQ0ZGE5NDE5YzkgPSBMLnBvcHVwKHsibWF4V2lkdGgiOiAiMTAwJSJ9KTsKCiAgICAgICAgCiAgICAgICAgICAgIHZhciBodG1sX2IzMjhhM2NhODU4ZTQ0Yjk5YTNlNjQ1MWMzYzE2N2M5ID0gJChgPGRpdiBpZD0iaHRtbF9iMzI4YTNjYTg1OGU0NGI5OWEzZTY0NTFjM2MxNjdjOSIgc3R5bGU9IndpZHRoOiAxMDAuMCU7IGhlaWdodDogMTAwLjAlOyI+TmFtZTogQlVUVE9OUk9DSyAoUkFMUEggUFJJQ0UpIFJFU0VSVk9JUiBQcmVjaXA6IDE0MDM0LjAwPC9kaXY+YClbMF07CiAgICAgICAgICAgIHBvcHVwXzNiZTdhM2E5NmU5ZjQ0MTFhOTg0NTBkNGRhOTQxOWM5LnNldENvbnRlbnQoaHRtbF9iMzI4YTNjYTg1OGU0NGI5OWEzZTY0NTFjM2MxNjdjOSk7CiAgICAgICAgCgogICAgICAgIG1hcmtlcl80MDhkNzViODQwNjA0ZDc2YTMxZDZkOTNiNGZhNmI2ZC5iaW5kUG9wdXAocG9wdXBfM2JlN2EzYTk2ZTlmNDQxMWE5ODQ1MGQ0ZGE5NDE5YzkpCiAgICAgICAgOwoKICAgICAgICAKICAgIAogICAgCiAgICAgICAgICAgIHZhciBtYXJrZXJfYTliYTM1NjI2NzBhNDkwOTkyM2I1ODFkZjdkYmVhMzggPSBMLm1hcmtlcigKICAgICAgICAgICAgICAgIFs0MC4yNTU3NzYsIC0xMDUuMjA5NV0sCiAgICAgICAgICAgICAgICB7fQogICAgICAgICAgICApLmFkZFRvKG1hcmtlcl9jbHVzdGVyX2I4MTZmMjQ2NTM0MDRlZWFhNjI4Y2I4MzAwNzJmYTY4KTsKICAgICAgICAKICAgIAogICAgICAgIHZhciBwb3B1cF9hZmJhOTc2YmE3Nzg0NDVjYTE0MDY5MTRjZWFlOGQwNCA9IEwucG9wdXAoeyJtYXhXaWR0aCI6ICIxMDAlIn0pOwoKICAgICAgICAKICAgICAgICAgICAgdmFyIGh0bWxfNWQwZDhhZTI2M2M2NDkyOGE0M2QxMTk4MWNhYmRmYWMgPSAkKGA8ZGl2IGlkPSJodG1sXzVkMGQ4YWUyNjNjNjQ5MjhhNDNkMTE5ODFjYWJkZmFjIiBzdHlsZT0id2lkdGg6IDEwMC4wJTsgaGVpZ2h0OiAxMDAuMCU7Ij5OYW1lOiBMSVRUTEUgVEhPTVBTT04gIzIgRElUQ0ggUHJlY2lwOiAwLjAxPC9kaXY+YClbMF07CiAgICAgICAgICAgIHBvcHVwX2FmYmE5NzZiYTc3ODQ0NWNhMTQwNjkxNGNlYWU4ZDA0LnNldENvbnRlbnQoaHRtbF81ZDBkOGFlMjYzYzY0OTI4YTQzZDExOTgxY2FiZGZhYyk7CiAgICAgICAgCgogICAgICAgIG1hcmtlcl9hOWJhMzU2MjY3MGE0OTA5OTIzYjU4MWRmN2RiZWEzOC5iaW5kUG9wdXAocG9wdXBfYWZiYTk3NmJhNzc4NDQ1Y2ExNDA2OTE0Y2VhZThkMDQpCiAgICAgICAgOwoKICAgICAgICAKICAgIAogICAgCiAgICAgICAgICAgIHZhciBtYXJrZXJfNmE4ZWVhZGJiMjdmNDQzOTgxYzIxYzRlMWNlNWM0ZmIgPSBMLm1hcmtlcigKICAgICAgICAgICAgICAgIFs0MC4yNTc4NDQsIC0xMDUuMTY0Mzk3XSwKICAgICAgICAgICAgICAgIHt9CiAgICAgICAgICAgICkuYWRkVG8obWFya2VyX2NsdXN0ZXJfYjgxNmYyNDY1MzQwNGVlYWE2MjhjYjgzMDA3MmZhNjgpOwogICAgICAgIAogICAgCiAgICAgICAgdmFyIHBvcHVwXzVjMDA3NDMwZGQ1YzRmMGM4NTkzZDUwMDIxNWMzZDIwID0gTC5wb3B1cCh7Im1heFdpZHRoIjogIjEwMCUifSk7CgogICAgICAgIAogICAgICAgICAgICB2YXIgaHRtbF8wODk0NDhhZDk0OWE0ZDI3OGQxOWE1NjcyYzliZGQ5ZSA9ICQoYDxkaXYgaWQ9Imh0bWxfMDg5NDQ4YWQ5NDlhNGQyNzhkMTlhNTY3MmM5YmRkOWUiIHN0eWxlPSJ3aWR0aDogMTAwLjAlOyBoZWlnaHQ6IDEwMC4wJTsiPk5hbWU6IEJMT1dFUiBESVRDSCBQcmVjaXA6IDAuMDA8L2Rpdj5gKVswXTsKICAgICAgICAgICAgcG9wdXBfNWMwMDc0MzBkZDVjNGYwYzg1OTNkNTAwMjE1YzNkMjAuc2V0Q29udGVudChodG1sXzA4OTQ0OGFkOTQ5YTRkMjc4ZDE5YTU2NzJjOWJkZDllKTsKICAgICAgICAKCiAgICAgICAgbWFya2VyXzZhOGVlYWRiYjI3ZjQ0Mzk4MWMyMWM0ZTFjZTVjNGZiLmJpbmRQb3B1cChwb3B1cF81YzAwNzQzMGRkNWM0ZjBjODU5M2Q1MDAyMTVjM2QyMCkKICAgICAgICA7CgogICAgICAgIAogICAgCiAgICAKICAgICAgICAgICAgdmFyIG1hcmtlcl81MzVjZmQ1MDIzNTY0ZmNiOTg0ZGM1MDg3MjllMjk3MCA9IEwubWFya2VyKAogICAgICAgICAgICAgICAgWzM5LjkzMTU5NywgLTEwNS4zMDQ5OV0sCiAgICAgICAgICAgICAgICB7fQogICAgICAgICAgICApLmFkZFRvKG1hcmtlcl9jbHVzdGVyX2I4MTZmMjQ2NTM0MDRlZWFhNjI4Y2I4MzAwNzJmYTY4KTsKICAgICAgICAKICAgIAogICAgICAgIHZhciBwb3B1cF8zZmNhNjEyNTk2OWI0Njg4OTZkYjFkMDNiMmMyZTI0OSA9IEwucG9wdXAoeyJtYXhXaWR0aCI6ICIxMDAlIn0pOwoKICAgICAgICAKICAgICAgICAgICAgdmFyIGh0bWxfNzI5OGU3MWI2MWJlNGQ5YWFmNmZlNzdmZjkzOWVlOGIgPSAkKGA8ZGl2IGlkPSJodG1sXzcyOThlNzFiNjFiZTRkOWFhZjZmZTc3ZmY5MzllZThiIiBzdHlsZT0id2lkdGg6IDEwMC4wJTsgaGVpZ2h0OiAxMDAuMCU7Ij5OYW1lOiBTT1VUSCBCT1VMREVSIENSRUVLIE5FQVIgRUxET1JBRE8gU1BSSU5HUywgQ08uIFByZWNpcDogNy44ODwvZGl2PmApWzBdOwogICAgICAgICAgICBwb3B1cF8zZmNhNjEyNTk2OWI0Njg4OTZkYjFkMDNiMmMyZTI0OS5zZXRDb250ZW50KGh0bWxfNzI5OGU3MWI2MWJlNGQ5YWFmNmZlNzdmZjkzOWVlOGIpOwogICAgICAgIAoKICAgICAgICBtYXJrZXJfNTM1Y2ZkNTAyMzU2NGZjYjk4NGRjNTA4NzI5ZTI5NzAuYmluZFBvcHVwKHBvcHVwXzNmY2E2MTI1OTY5YjQ2ODg5NmRiMWQwM2IyYzJlMjQ5KQogICAgICAgIDsKCiAgICAgICAgCiAgICAKICAgIAogICAgICAgICAgICB2YXIgbWFya2VyXzNlZDE3NzRjOGU2ODQ5NjE4MzE4ZmFhZjEzNmU4ODQ3ID0gTC5tYXJrZXIoCiAgICAgICAgICAgICAgICBbNDAuMDUxNjUyLCAtMTA1LjE3ODg3NV0sCiAgICAgICAgICAgICAgICB7fQogICAgICAgICAgICApLmFkZFRvKG1hcmtlcl9jbHVzdGVyX2I4MTZmMjQ2NTM0MDRlZWFhNjI4Y2I4MzAwNzJmYTY4KTsKICAgICAgICAKICAgIAogICAgICAgIHZhciBwb3B1cF82NGM4YzAzMzQ2NGQ0YTQ5OGE5OTgzNDJmMmQ0ZGI2NSA9IEwucG9wdXAoeyJtYXhXaWR0aCI6ICIxMDAlIn0pOwoKICAgICAgICAKICAgICAgICAgICAgdmFyIGh0bWxfMTBmZTZhYmMxMzU3NGQ1ZWJjNDdmY2YxYWJkM2JiNGYgPSAkKGA8ZGl2IGlkPSJodG1sXzEwZmU2YWJjMTM1NzRkNWViYzQ3ZmNmMWFiZDNiYjRmIiBzdHlsZT0id2lkdGg6IDEwMC4wJTsgaGVpZ2h0OiAxMDAuMCU7Ij5OYW1lOiBCT1VMREVSIENSRUVLIEFUIE5PUlRIIDc1VEggU1QuIE5FQVIgQk9VTERFUiwgQ08gUHJlY2lwOiAxNy42MDwvZGl2PmApWzBdOwogICAgICAgICAgICBwb3B1cF82NGM4YzAzMzQ2NGQ0YTQ5OGE5OTgzNDJmMmQ0ZGI2NS5zZXRDb250ZW50KGh0bWxfMTBmZTZhYmMxMzU3NGQ1ZWJjNDdmY2YxYWJkM2JiNGYpOwogICAgICAgIAoKICAgICAgICBtYXJrZXJfM2VkMTc3NGM4ZTY4NDk2MTgzMThmYWFmMTM2ZTg4NDcuYmluZFBvcHVwKHBvcHVwXzY0YzhjMDMzNDY0ZDRhNDk4YTk5ODM0MmYyZDRkYjY1KQogICAgICAgIDsKCiAgICAgICAgCiAgICAKICAgIAogICAgICAgICAgICB2YXIgbWFya2VyX2I1NWMyZjExMjMyMDRhZThiOTAzM2Q1N2UxOTcxNDBkID0gTC5tYXJrZXIoCiAgICAgICAgICAgICAgICBbNDAuMTcwOTk4LCAtMTA1LjE2MDg3Nl0sCiAgICAgICAgICAgICAgICB7fQogICAgICAgICAgICApLmFkZFRvKG1hcmtlcl9jbHVzdGVyX2I4MTZmMjQ2NTM0MDRlZWFhNjI4Y2I4MzAwNzJmYTY4KTsKICAgICAgICAKICAgIAogICAgICAgIHZhciBwb3B1cF9jODkwZjBkNDBlMjk0MmFmOWM5MzQ2ZTJjOWU4YzY1MiA9IEwucG9wdXAoeyJtYXhXaWR0aCI6ICIxMDAlIn0pOwoKICAgICAgICAKICAgICAgICAgICAgdmFyIGh0bWxfYzE3M2QyZWM5NjUzNDg1ZjhjZDUyY2JjNmUyNTZhZDMgPSAkKGA8ZGl2IGlkPSJodG1sX2MxNzNkMmVjOTY1MzQ4NWY4Y2Q1MmNiYzZlMjU2YWQzIiBzdHlsZT0id2lkdGg6IDEwMC4wJTsgaGVpZ2h0OiAxMDAuMCU7Ij5OYW1lOiBTT1VUSCBGTEFUIERJVENIIFByZWNpcDogMC4zODwvZGl2PmApWzBdOwogICAgICAgICAgICBwb3B1cF9jODkwZjBkNDBlMjk0MmFmOWM5MzQ2ZTJjOWU4YzY1Mi5zZXRDb250ZW50KGh0bWxfYzE3M2QyZWM5NjUzNDg1ZjhjZDUyY2JjNmUyNTZhZDMpOwogICAgICAgIAoKICAgICAgICBtYXJrZXJfYjU1YzJmMTEyMzIwNGFlOGI5MDMzZDU3ZTE5NzE0MGQuYmluZFBvcHVwKHBvcHVwX2M4OTBmMGQ0MGUyOTQyYWY5YzkzNDZlMmM5ZThjNjUyKQogICAgICAgIDsKCiAgICAgICAgCiAgICAKICAgIAogICAgICAgICAgICB2YXIgbWFya2VyXzJiMzFkOTdjMTdjZDRkMzFiYjExNzc5Njk0NWUwZmVmID0gTC5tYXJrZXIoCiAgICAgICAgICAgICAgICBbNDAuMTUzMzQxLCAtMTA1LjA3NTY5NV0sCiAgICAgICAgICAgICAgICB7fQogICAgICAgICAgICApLmFkZFRvKG1hcmtlcl9jbHVzdGVyX2I4MTZmMjQ2NTM0MDRlZWFhNjI4Y2I4MzAwNzJmYTY4KTsKICAgICAgICAKICAgIAogICAgICAgIHZhciBwb3B1cF80MzM1OTU3MzZiYTQ0ZWRkODhjMThkNjMzYjRkZWE5NCA9IEwucG9wdXAoeyJtYXhXaWR0aCI6ICIxMDAlIn0pOwoKICAgICAgICAKICAgICAgICAgICAgdmFyIGh0bWxfZDFiNmZhYzIyODNkNDExMGI4YWU4MTVkMTM5MTBhMmMgPSAkKGA8ZGl2IGlkPSJodG1sX2QxYjZmYWMyMjgzZDQxMTBiOGFlODE1ZDEzOTEwYTJjIiBzdHlsZT0id2lkdGg6IDEwMC4wJTsgaGVpZ2h0OiAxMDAuMCU7Ij5OYW1lOiBTQUlOVCBWUkFJTiBDUkVFSyBCRUxPVyBLRU4gUFJBVFQgQkxWRCBBVCBMT05HTU9OVCwgQ08gUHJlY2lwOiAzNS43MDwvZGl2PmApWzBdOwogICAgICAgICAgICBwb3B1cF80MzM1OTU3MzZiYTQ0ZWRkODhjMThkNjMzYjRkZWE5NC5zZXRDb250ZW50KGh0bWxfZDFiNmZhYzIyODNkNDExMGI4YWU4MTVkMTM5MTBhMmMpOwogICAgICAgIAoKICAgICAgICBtYXJrZXJfMmIzMWQ5N2MxN2NkNGQzMWJiMTE3Nzk2OTQ1ZTBmZWYuYmluZFBvcHVwKHBvcHVwXzQzMzU5NTczNmJhNDRlZGQ4OGMxOGQ2MzNiNGRlYTk0KQogICAgICAgIDsKCiAgICAgICAgCiAgICAKICAgIAogICAgICAgICAgICB2YXIgbWFya2VyXzhkOTVmM2Q3YjdjMjRiMDA5NDhlNjIxYWE1MDIwN2E4ID0gTC5tYXJrZXIoCiAgICAgICAgICAgICAgICBbMzkuOTYxNjU1LCAtMTA1LjUwNDQ0XSwKICAgICAgICAgICAgICAgIHt9CiAgICAgICAgICAgICkuYWRkVG8obWFya2VyX2NsdXN0ZXJfYjgxNmYyNDY1MzQwNGVlYWE2MjhjYjgzMDA3MmZhNjgpOwogICAgICAgIAogICAgCiAgICAgICAgdmFyIHBvcHVwXzRlZWJlZDQ4ZTVmYzRhZTBhNmNlMGFiMzNjMTgzYWU0ID0gTC5wb3B1cCh7Im1heFdpZHRoIjogIjEwMCUifSk7CgogICAgICAgIAogICAgICAgICAgICB2YXIgaHRtbF8yNzRmYTU3MmU0N2I0MWU0YjNmM2U1ZTg4N2I4N2MzYyA9ICQoYDxkaXYgaWQ9Imh0bWxfMjc0ZmE1NzJlNDdiNDFlNGIzZjNlNWU4ODdiODdjM2MiIHN0eWxlPSJ3aWR0aDogMTAwLjAlOyBoZWlnaHQ6IDEwMC4wJTsiPk5hbWU6IE1JRERMRSBCT1VMREVSIENSRUVLIEFUIE5FREVSTEFORCwgQ08uIFByZWNpcDogMzkuNzA8L2Rpdj5gKVswXTsKICAgICAgICAgICAgcG9wdXBfNGVlYmVkNDhlNWZjNGFlMGE2Y2UwYWIzM2MxODNhZTQuc2V0Q29udGVudChodG1sXzI3NGZhNTcyZTQ3YjQxZTRiM2YzZTVlODg3Yjg3YzNjKTsKICAgICAgICAKCiAgICAgICAgbWFya2VyXzhkOTVmM2Q3YjdjMjRiMDA5NDhlNjIxYWE1MDIwN2E4LmJpbmRQb3B1cChwb3B1cF80ZWViZWQ0OGU1ZmM0YWUwYTZjZTBhYjMzYzE4M2FlNCkKICAgICAgICA7CgogICAgICAgIAogICAgCiAgICAKICAgICAgICAgICAgdmFyIG1hcmtlcl82NzAwMTdhYTFhNjk0NTY4YTY4Y2Q4NGRhMDhiMDM2NSA9IEwubWFya2VyKAogICAgICAgICAgICAgICAgWzQwLjA1OTgwOSwgLTEwNS4wOTc4NzJdLAogICAgICAgICAgICAgICAge30KICAgICAgICAgICAgKS5hZGRUbyhtYXJrZXJfY2x1c3Rlcl9iODE2ZjI0NjUzNDA0ZWVhYTYyOGNiODMwMDcyZmE2OCk7CiAgICAgICAgCiAgICAKICAgICAgICB2YXIgcG9wdXBfZjdlOTBkMzVhMjJlNGQ5OThmNjVjNmI3MTYzMTVjZDUgPSBMLnBvcHVwKHsibWF4V2lkdGgiOiAiMTAwJSJ9KTsKCiAgICAgICAgCiAgICAgICAgICAgIHZhciBodG1sXzY0MmY2ZWM0MjRjYzQwYzA5MWZiYmNkNjc2MGY4MmFiID0gJChgPGRpdiBpZD0iaHRtbF82NDJmNmVjNDI0Y2M0MGMwOTFmYmJjZDY3NjBmODJhYiIgc3R5bGU9IndpZHRoOiAxMDAuMCU7IGhlaWdodDogMTAwLjAlOyI+TmFtZTogQk9VTERFUiBDUkVFSyBBVCAxMDkgU1QgTkVBUiBFUklFLCBDTyBQcmVjaXA6IDMyLjAwPC9kaXY+YClbMF07CiAgICAgICAgICAgIHBvcHVwX2Y3ZTkwZDM1YTIyZTRkOTk4ZjY1YzZiNzE2MzE1Y2Q1LnNldENvbnRlbnQoaHRtbF82NDJmNmVjNDI0Y2M0MGMwOTFmYmJjZDY3NjBmODJhYik7CiAgICAgICAgCgogICAgICAgIG1hcmtlcl82NzAwMTdhYTFhNjk0NTY4YTY4Y2Q4NGRhMDhiMDM2NS5iaW5kUG9wdXAocG9wdXBfZjdlOTBkMzVhMjJlNGQ5OThmNjVjNmI3MTYzMTVjZDUpCiAgICAgICAgOwoKICAgICAgICAKICAgIAogICAgCiAgICAgICAgICAgIHZhciBtYXJrZXJfZmYyOWY1MzRjYzQ0NGJhOGIzMDNiZTg0ODg3NWY3MDkgPSBMLm1hcmtlcigKICAgICAgICAgICAgICAgIFs0MC4yMTU2NTgsIC0xMDUuMzYzNDIyXSwKICAgICAgICAgICAgICAgIHt9CiAgICAgICAgICAgICkuYWRkVG8obWFya2VyX2NsdXN0ZXJfYjgxNmYyNDY1MzQwNGVlYWE2MjhjYjgzMDA3MmZhNjgpOwogICAgICAgIAogICAgCiAgICAgICAgdmFyIHBvcHVwXzdjNmM5YjIxN2JjNDQyYjY4OGI5NDI2MWRiZmU2OWM3ID0gTC5wb3B1cCh7Im1heFdpZHRoIjogIjEwMCUifSk7CgogICAgICAgIAogICAgICAgICAgICB2YXIgaHRtbF84NThlNmYyZWFmNjY0MTQ3OGMwOTQ1MWMxZmFiNDViYiA9ICQoYDxkaXYgaWQ9Imh0bWxfODU4ZTZmMmVhZjY2NDE0NzhjMDk0NTFjMWZhYjQ1YmIiIHN0eWxlPSJ3aWR0aDogMTAwLjAlOyBoZWlnaHQ6IDEwMC4wJTsiPk5hbWU6IE5PUlRIIFNBSU5UIFZSQUlOIENSRUVLIEJFTE9XIEJVVFRPTlJPQ0sgIChSQUxQSCBQUklDRSkgUkVTRVJWT0lSIFByZWNpcDogMjAuNDA8L2Rpdj5gKVswXTsKICAgICAgICAgICAgcG9wdXBfN2M2YzliMjE3YmM0NDJiNjg4Yjk0MjYxZGJmZTY5Yzcuc2V0Q29udGVudChodG1sXzg1OGU2ZjJlYWY2NjQxNDc4YzA5NDUxYzFmYWI0NWJiKTsKICAgICAgICAKCiAgICAgICAgbWFya2VyX2ZmMjlmNTM0Y2M0NDRiYThiMzAzYmU4NDg4NzVmNzA5LmJpbmRQb3B1cChwb3B1cF83YzZjOWIyMTdiYzQ0MmI2ODhiOTQyNjFkYmZlNjljNykKICAgICAgICA7CgogICAgICAgIAogICAgCiAgICAKICAgICAgICAgICAgdmFyIG1hcmtlcl85YjJjMzM3ZDkzNzU0YmQ5YTZiNzdmYWQ4OTY2YTNlNiA9IEwubWFya2VyKAogICAgICAgICAgICAgICAgWzQwLjA4NjI3OCwgLTEwNS4yMTc1MTldLAogICAgICAgICAgICAgICAge30KICAgICAgICAgICAgKS5hZGRUbyhtYXJrZXJfY2x1c3Rlcl9iODE2ZjI0NjUzNDA0ZWVhYTYyOGNiODMwMDcyZmE2OCk7CiAgICAgICAgCiAgICAKICAgICAgICB2YXIgcG9wdXBfNGU2MDIwY2Q2M2QyNDA0OWJmZjA4MGUzZGRhZmY1MDcgPSBMLnBvcHVwKHsibWF4V2lkdGgiOiAiMTAwJSJ9KTsKCiAgICAgICAgCiAgICAgICAgICAgIHZhciBodG1sXzQ3ZWVlMzc1NGUwMjRmNDg5MWEwNjljYzgwNDI3MWJkID0gJChgPGRpdiBpZD0iaHRtbF80N2VlZTM3NTRlMDI0ZjQ4OTFhMDY5Y2M4MDQyNzFiZCIgc3R5bGU9IndpZHRoOiAxMDAuMCU7IGhlaWdodDogMTAwLjAlOyI+TmFtZTogQk9VTERFUiBSRVNFUlZPSVIgSU5MRVQgUHJlY2lwOiAwLjgwPC9kaXY+YClbMF07CiAgICAgICAgICAgIHBvcHVwXzRlNjAyMGNkNjNkMjQwNDliZmYwODBlM2RkYWZmNTA3LnNldENvbnRlbnQoaHRtbF80N2VlZTM3NTRlMDI0ZjQ4OTFhMDY5Y2M4MDQyNzFiZCk7CiAgICAgICAgCgogICAgICAgIG1hcmtlcl85YjJjMzM3ZDkzNzU0YmQ5YTZiNzdmYWQ4OTY2YTNlNi5iaW5kUG9wdXAocG9wdXBfNGU2MDIwY2Q2M2QyNDA0OWJmZjA4MGUzZGRhZmY1MDcpCiAgICAgICAgOwoKICAgICAgICAKICAgIAogICAgCiAgICAgICAgICAgIHZhciBtYXJrZXJfZmNiZDRjZTllZWExNGYzNjg3YzM0MTAzNmI5ZDRiNmIgPSBMLm1hcmtlcigKICAgICAgICAgICAgICAgIFs0MC4xOTMwMTksIC0xMDUuMjEwMzg4XSwKICAgICAgICAgICAgICAgIHt9CiAgICAgICAgICAgICkuYWRkVG8obWFya2VyX2NsdXN0ZXJfYjgxNmYyNDY1MzQwNGVlYWE2MjhjYjgzMDA3MmZhNjgpOwogICAgICAgIAogICAgCiAgICAgICAgdmFyIHBvcHVwXzUwMjdjYzU3MTgwOTQ3ZWQ5YTVkNGZlY2UzNWJkMjMzID0gTC5wb3B1cCh7Im1heFdpZHRoIjogIjEwMCUifSk7CgogICAgICAgIAogICAgICAgICAgICB2YXIgaHRtbF9kMjJkNTMyMDhmNTk0MTZiYTNlZDk0NGY3OTMxMjdkNSA9ICQoYDxkaXYgaWQ9Imh0bWxfZDIyZDUzMjA4ZjU5NDE2YmEzZWQ5NDRmNzkzMTI3ZDUiIHN0eWxlPSJ3aWR0aDogMTAwLjAlOyBoZWlnaHQ6IDEwMC4wJTsiPk5hbWU6IFRSVUUgQU5EIFdFQlNURVIgRElUQ0ggUHJlY2lwOiAwLjAwPC9kaXY+YClbMF07CiAgICAgICAgICAgIHBvcHVwXzUwMjdjYzU3MTgwOTQ3ZWQ5YTVkNGZlY2UzNWJkMjMzLnNldENvbnRlbnQoaHRtbF9kMjJkNTMyMDhmNTk0MTZiYTNlZDk0NGY3OTMxMjdkNSk7CiAgICAgICAgCgogICAgICAgIG1hcmtlcl9mY2JkNGNlOWVlYTE0ZjM2ODdjMzQxMDM2YjlkNGI2Yi5iaW5kUG9wdXAocG9wdXBfNTAyN2NjNTcxODA5NDdlZDlhNWQ0ZmVjZTM1YmQyMzMpCiAgICAgICAgOwoKICAgICAgICAKICAgIAogICAgCiAgICAgICAgICAgIHZhciBtYXJrZXJfZjM1ZWNiOGUwMjgwNDMzMWEyZTBjNzAwYTMxYjEwMTEgPSBMLm1hcmtlcigKICAgICAgICAgICAgICAgIFs0MC4yMTI2NTgsIC0xMDUuMjUxODI2XSwKICAgICAgICAgICAgICAgIHt9CiAgICAgICAgICAgICkuYWRkVG8obWFya2VyX2NsdXN0ZXJfYjgxNmYyNDY1MzQwNGVlYWE2MjhjYjgzMDA3MmZhNjgpOwogICAgICAgIAogICAgCiAgICAgICAgdmFyIHBvcHVwX2I0Y2IxZjQyODY4NzRjY2E5NDRiOWRhMjE2YmVlYzJjID0gTC5wb3B1cCh7Im1heFdpZHRoIjogIjEwMCUifSk7CgogICAgICAgIAogICAgICAgICAgICB2YXIgaHRtbF9mZDhmOTQ4Y2RmMzg0MmUzODZmNTI1OWU1ZDAxMjgxZCA9ICQoYDxkaXYgaWQ9Imh0bWxfZmQ4Zjk0OGNkZjM4NDJlMzg2ZjUyNTllNWQwMTI4MWQiIHN0eWxlPSJ3aWR0aDogMTAwLjAlOyBoZWlnaHQ6IDEwMC4wJTsiPk5hbWU6IFJPVUdIIEFORCBSRUFEWSBESVRDSCBQcmVjaXA6IDAuMDQ8L2Rpdj5gKVswXTsKICAgICAgICAgICAgcG9wdXBfYjRjYjFmNDI4Njg3NGNjYTk0NGI5ZGEyMTZiZWVjMmMuc2V0Q29udGVudChodG1sX2ZkOGY5NDhjZGYzODQyZTM4NmY1MjU5ZTVkMDEyODFkKTsKICAgICAgICAKCiAgICAgICAgbWFya2VyX2YzNWVjYjhlMDI4MDQzMzFhMmUwYzcwMGEzMWIxMDExLmJpbmRQb3B1cChwb3B1cF9iNGNiMWY0Mjg2ODc0Y2NhOTQ0YjlkYTIxNmJlZWMyYykKICAgICAgICA7CgogICAgICAgIAogICAgCiAgICAKICAgICAgICAgICAgdmFyIG1hcmtlcl9hMTQ0NmU5Y2UwYzU0MGQxYmRhOWNmN2RhNjM5N2I2ZiA9IEwubWFya2VyKAogICAgICAgICAgICAgICAgWzQwLjE3NDg0NCwgLTEwNS4xNjc4NzNdLAogICAgICAgICAgICAgICAge30KICAgICAgICAgICAgKS5hZGRUbyhtYXJrZXJfY2x1c3Rlcl9iODE2ZjI0NjUzNDA0ZWVhYTYyOGNiODMwMDcyZmE2OCk7CiAgICAgICAgCiAgICAKICAgICAgICB2YXIgcG9wdXBfMzY1ZjNlNTgxNDRiNDg1M2JlZWQ2MWYyOWVkNWM0NGQgPSBMLnBvcHVwKHsibWF4V2lkdGgiOiAiMTAwJSJ9KTsKCiAgICAgICAgCiAgICAgICAgICAgIHZhciBodG1sXzk2NGYwZmNkNjVmMzQzZmFiZDcyOTAxOTBhZjczN2EzID0gJChgPGRpdiBpZD0iaHRtbF85NjRmMGZjZDY1ZjM0M2ZhYmQ3MjkwMTkwYWY3MzdhMyIgc3R5bGU9IndpZHRoOiAxMDAuMCU7IGhlaWdodDogMTAwLjAlOyI+TmFtZTogSEFHRVIgTUVBRE9XUyBESVRDSCBQcmVjaXA6IDAuMjE8L2Rpdj5gKVswXTsKICAgICAgICAgICAgcG9wdXBfMzY1ZjNlNTgxNDRiNDg1M2JlZWQ2MWYyOWVkNWM0NGQuc2V0Q29udGVudChodG1sXzk2NGYwZmNkNjVmMzQzZmFiZDcyOTAxOTBhZjczN2EzKTsKICAgICAgICAKCiAgICAgICAgbWFya2VyX2ExNDQ2ZTljZTBjNTQwZDFiZGE5Y2Y3ZGE2Mzk3YjZmLmJpbmRQb3B1cChwb3B1cF8zNjVmM2U1ODE0NGI0ODUzYmVlZDYxZjI5ZWQ1YzQ0ZCkKICAgICAgICA7CgogICAgICAgIAogICAgCiAgICAKICAgICAgICAgICAgdmFyIG1hcmtlcl82NTRjMDYxZTJjYjI0YzI1YWM0Zjg1MWZkNWFhY2Q4ZiA9IEwubWFya2VyKAogICAgICAgICAgICAgICAgWzQwLjI1NjI3NiwgLTEwNS4yMDk0MTZdLAogICAgICAgICAgICAgICAge30KICAgICAgICAgICAgKS5hZGRUbyhtYXJrZXJfY2x1c3Rlcl9iODE2ZjI0NjUzNDA0ZWVhYTYyOGNiODMwMDcyZmE2OCk7CiAgICAgICAgCiAgICAKICAgICAgICB2YXIgcG9wdXBfODk1MjgzZjg4ZTdjNDE4NDgzYWIyMThjZGE0ZGZiYzEgPSBMLnBvcHVwKHsibWF4V2lkdGgiOiAiMTAwJSJ9KTsKCiAgICAgICAgCiAgICAgICAgICAgIHZhciBodG1sXzg2N2U5NjVmN2UzMTRlZmRhNjlmMzU0MGUyOTY3OWZlID0gJChgPGRpdiBpZD0iaHRtbF84NjdlOTY1ZjdlMzE0ZWZkYTY5ZjM1NDBlMjk2NzlmZSIgc3R5bGU9IndpZHRoOiAxMDAuMCU7IGhlaWdodDogMTAwLjAlOyI+TmFtZTogTElUVExFIFRIT01QU09OICMxIERJVENIIFByZWNpcDogMC4wMDwvZGl2PmApWzBdOwogICAgICAgICAgICBwb3B1cF84OTUyODNmODhlN2M0MTg0ODNhYjIxOGNkYTRkZmJjMS5zZXRDb250ZW50KGh0bWxfODY3ZTk2NWY3ZTMxNGVmZGE2OWYzNTQwZTI5Njc5ZmUpOwogICAgICAgIAoKICAgICAgICBtYXJrZXJfNjU0YzA2MWUyY2IyNGMyNWFjNGY4NTFmZDVhYWNkOGYuYmluZFBvcHVwKHBvcHVwXzg5NTI4M2Y4OGU3YzQxODQ4M2FiMjE4Y2RhNGRmYmMxKQogICAgICAgIDsKCiAgICAgICAgCiAgICAKICAgIAogICAgICAgICAgICB2YXIgbWFya2VyXzA1YTMwMDAyZmU3ODRjZWI5ZWQ5NDRhYTk0NTgyZGE5ID0gTC5tYXJrZXIoCiAgICAgICAgICAgICAgICBbNDAuMjYwODI3LCAtMTA1LjE5ODU2N10sCiAgICAgICAgICAgICAgICB7fQogICAgICAgICAgICApLmFkZFRvKG1hcmtlcl9jbHVzdGVyX2I4MTZmMjQ2NTM0MDRlZWFhNjI4Y2I4MzAwNzJmYTY4KTsKICAgICAgICAKICAgIAogICAgICAgIHZhciBwb3B1cF84NWViNTExZDk5NDU0Y2QyODRmYzkyOTAwM2Q5MWM1YSA9IEwucG9wdXAoeyJtYXhXaWR0aCI6ICIxMDAlIn0pOwoKICAgICAgICAKICAgICAgICAgICAgdmFyIGh0bWxfY2NlYTdmMjRjMmVlNDE0ZDkyNWM4MmE1OWIyMTJhZTEgPSAkKGA8ZGl2IGlkPSJodG1sX2NjZWE3ZjI0YzJlZTQxNGQ5MjVjODJhNTliMjEyYWUxIiBzdHlsZT0id2lkdGg6IDEwMC4wJTsgaGVpZ2h0OiAxMDAuMCU7Ij5OYW1lOiBDVUxWRVIgRElUQ0ggUHJlY2lwOiAwLjAwPC9kaXY+YClbMF07CiAgICAgICAgICAgIHBvcHVwXzg1ZWI1MTFkOTk0NTRjZDI4NGZjOTI5MDAzZDkxYzVhLnNldENvbnRlbnQoaHRtbF9jY2VhN2YyNGMyZWU0MTRkOTI1YzgyYTU5YjIxMmFlMSk7CiAgICAgICAgCgogICAgICAgIG1hcmtlcl8wNWEzMDAwMmZlNzg0Y2ViOWVkOTQ0YWE5NDU4MmRhOS5iaW5kUG9wdXAocG9wdXBfODVlYjUxMWQ5OTQ1NGNkMjg0ZmM5MjkwMDNkOTFjNWEpCiAgICAgICAgOwoKICAgICAgICAKICAgIAogICAgCiAgICAgICAgICAgIHZhciBtYXJrZXJfZTUyZDUzMzg1MWNlNDVlMWFhOWY0MjUwNzFlMDU2M2QgPSBMLm1hcmtlcigKICAgICAgICAgICAgICAgIFs0MC4yMTUwNDMsIC0xMDUuMjU2MDE3XSwKICAgICAgICAgICAgICAgIHt9CiAgICAgICAgICAgICkuYWRkVG8obWFya2VyX2NsdXN0ZXJfYjgxNmYyNDY1MzQwNGVlYWE2MjhjYjgzMDA3MmZhNjgpOwogICAgICAgIAogICAgCiAgICAgICAgdmFyIHBvcHVwXzY4NzAxOWI5NDFlNzQxNzk4MmNhYTk0ODkyMmI1YjdiID0gTC5wb3B1cCh7Im1heFdpZHRoIjogIjEwMCUifSk7CgogICAgICAgIAogICAgICAgICAgICB2YXIgaHRtbF85YTZmZDM4MGFjYTQ0Yjk1YjM1YjYyYmI1NzRjMzM2YyA9ICQoYDxkaXYgaWQ9Imh0bWxfOWE2ZmQzODBhY2E0NGI5NWIzNWI2MmJiNTc0YzMzNmMiIHN0eWxlPSJ3aWR0aDogMTAwLjAlOyBoZWlnaHQ6IDEwMC4wJTsiPk5hbWU6IEhJR0hMQU5EIERJVENIIEFUIExZT05TLCBDTyBQcmVjaXA6IDAuMDA8L2Rpdj5gKVswXTsKICAgICAgICAgICAgcG9wdXBfNjg3MDE5Yjk0MWU3NDE3OTgyY2FhOTQ4OTIyYjViN2Iuc2V0Q29udGVudChodG1sXzlhNmZkMzgwYWNhNDRiOTViMzViNjJiYjU3NGMzMzZjKTsKICAgICAgICAKCiAgICAgICAgbWFya2VyX2U1MmQ1MzM4NTFjZTQ1ZTFhYTlmNDI1MDcxZTA1NjNkLmJpbmRQb3B1cChwb3B1cF82ODcwMTliOTQxZTc0MTc5ODJjYWE5NDg5MjJiNWI3YikKICAgICAgICA7CgogICAgICAgIAogICAgCiAgICAKICAgICAgICAgICAgdmFyIG1hcmtlcl80MTdiNmFjYmM5NTI0YjhmYTZjNTQ0YjMwMWUwOWI1ZiA9IEwubWFya2VyKAogICAgICAgICAgICAgICAgWzQwLjA3ODU2LCAtMTA1LjIyMDQ5N10sCiAgICAgICAgICAgICAgICB7fQogICAgICAgICAgICApLmFkZFRvKG1hcmtlcl9jbHVzdGVyX2I4MTZmMjQ2NTM0MDRlZWFhNjI4Y2I4MzAwNzJmYTY4KTsKICAgICAgICAKICAgIAogICAgICAgIHZhciBwb3B1cF8yMjJkNTI0MDQ1ZDY0ZmMwYmI2Y2UxNDhlNjYzMmI3YSA9IEwucG9wdXAoeyJtYXhXaWR0aCI6ICIxMDAlIn0pOwoKICAgICAgICAKICAgICAgICAgICAgdmFyIGh0bWxfZDEyOWViNjM1NjMxNGQzZjk4MTJmZTMxZDk4M2ViZTkgPSAkKGA8ZGl2IGlkPSJodG1sX2QxMjllYjYzNTYzMTRkM2Y5ODEyZmUzMWQ5ODNlYmU5IiBzdHlsZT0id2lkdGg6IDEwMC4wJTsgaGVpZ2h0OiAxMDAuMCU7Ij5OYW1lOiBCT1VMREVSIFJFU0VSVk9JUiBQcmVjaXA6IDU4NDIuNTA8L2Rpdj5gKVswXTsKICAgICAgICAgICAgcG9wdXBfMjIyZDUyNDA0NWQ2NGZjMGJiNmNlMTQ4ZTY2MzJiN2Euc2V0Q29udGVudChodG1sX2QxMjllYjYzNTYzMTRkM2Y5ODEyZmUzMWQ5ODNlYmU5KTsKICAgICAgICAKCiAgICAgICAgbWFya2VyXzQxN2I2YWNiYzk1MjRiOGZhNmM1NDRiMzAxZTA5YjVmLmJpbmRQb3B1cChwb3B1cF8yMjJkNTI0MDQ1ZDY0ZmMwYmI2Y2UxNDhlNjYzMmI3YSkKICAgICAgICA7CgogICAgICAgIAogICAgCiAgICAKICAgICAgICAgICAgdmFyIG1hcmtlcl82Zjg5OTJjYzdlNDY0MTdiOWY0YzFmOGMyMjUwMzBjYiA9IEwubWFya2VyKAogICAgICAgICAgICAgICAgWzQwLjE3Mzk1LCAtMTA1LjE2OTM3NF0sCiAgICAgICAgICAgICAgICB7fQogICAgICAgICAgICApLmFkZFRvKG1hcmtlcl9jbHVzdGVyX2I4MTZmMjQ2NTM0MDRlZWFhNjI4Y2I4MzAwNzJmYTY4KTsKICAgICAgICAKICAgIAogICAgICAgIHZhciBwb3B1cF9lNzlkYjAyNmYzOTI0MGFiYTY5Y2YwYzIwMTVmYjIyZSA9IEwucG9wdXAoeyJtYXhXaWR0aCI6ICIxMDAlIn0pOwoKICAgICAgICAKICAgICAgICAgICAgdmFyIGh0bWxfMmM4M2QzZWM5MWYyNDczMzkzNDBjZTQ1MjFkMDVhYjQgPSAkKGA8ZGl2IGlkPSJodG1sXzJjODNkM2VjOTFmMjQ3MzM5MzQwY2U0NTIxZDA1YWI0IiBzdHlsZT0id2lkdGg6IDEwMC4wJTsgaGVpZ2h0OiAxMDAuMCU7Ij5OYW1lOiBOSVdPVCBESVRDSCBQcmVjaXA6IDAuMjM8L2Rpdj5gKVswXTsKICAgICAgICAgICAgcG9wdXBfZTc5ZGIwMjZmMzkyNDBhYmE2OWNmMGMyMDE1ZmIyMmUuc2V0Q29udGVudChodG1sXzJjODNkM2VjOTFmMjQ3MzM5MzQwY2U0NTIxZDA1YWI0KTsKICAgICAgICAKCiAgICAgICAgbWFya2VyXzZmODk5MmNjN2U0NjQxN2I5ZjRjMWY4YzIyNTAzMGNiLmJpbmRQb3B1cChwb3B1cF9lNzlkYjAyNmYzOTI0MGFiYTY5Y2YwYzIwMTVmYjIyZSkKICAgICAgICA7CgogICAgICAgIAogICAgCiAgICAKICAgICAgICAgICAgdmFyIG1hcmtlcl9mNWY2OGY4ODM4NTk0ZWYyOWQ0ZDM5OGIzOWMwNjgzMyA9IEwubWFya2VyKAogICAgICAgICAgICAgICAgWzQwLjIxMTM4OSwgLTEwNS4yNTA5NTJdLAogICAgICAgICAgICAgICAge30KICAgICAgICAgICAgKS5hZGRUbyhtYXJrZXJfY2x1c3Rlcl9iODE2ZjI0NjUzNDA0ZWVhYTYyOGNiODMwMDcyZmE2OCk7CiAgICAgICAgCiAgICAKICAgICAgICB2YXIgcG9wdXBfYWI4YWM2OTI5NTUwNGFiN2IzMTE4MzYzMGY4MWI1M2MgPSBMLnBvcHVwKHsibWF4V2lkdGgiOiAiMTAwJSJ9KTsKCiAgICAgICAgCiAgICAgICAgICAgIHZhciBodG1sX2NhNWFhZjJhZDBiYzQzNzc5MDQ1NzQ1YjI3ZDUzNzc0ID0gJChgPGRpdiBpZD0iaHRtbF9jYTVhYWYyYWQwYmM0Mzc3OTA0NTc0NWIyN2Q1Mzc3NCIgc3R5bGU9IndpZHRoOiAxMDAuMCU7IGhlaWdodDogMTAwLjAlOyI+TmFtZTogU01FQUQgRElUQ0ggUHJlY2lwOiAwLjAwPC9kaXY+YClbMF07CiAgICAgICAgICAgIHBvcHVwX2FiOGFjNjkyOTU1MDRhYjdiMzExODM2MzBmODFiNTNjLnNldENvbnRlbnQoaHRtbF9jYTVhYWYyYWQwYmM0Mzc3OTA0NTc0NWIyN2Q1Mzc3NCk7CiAgICAgICAgCgogICAgICAgIG1hcmtlcl9mNWY2OGY4ODM4NTk0ZWYyOWQ0ZDM5OGIzOWMwNjgzMy5iaW5kUG9wdXAocG9wdXBfYWI4YWM2OTI5NTUwNGFiN2IzMTE4MzYzMGY4MWI1M2MpCiAgICAgICAgOwoKICAgICAgICAKICAgIAogICAgCiAgICAgICAgICAgIHZhciBtYXJrZXJfYjI0MDg2NTQxNjFiNGNhM2I4Y2Q4NTNlOTNjZDhiYzUgPSBMLm1hcmtlcigKICAgICAgICAgICAgICAgIFs0MC4xNTMzNjMsIC0xMDUuMDg4Njk1XSwKICAgICAgICAgICAgICAgIHt9CiAgICAgICAgICAgICkuYWRkVG8obWFya2VyX2NsdXN0ZXJfYjgxNmYyNDY1MzQwNGVlYWE2MjhjYjgzMDA3MmZhNjgpOwogICAgICAgIAogICAgCiAgICAgICAgdmFyIHBvcHVwXzBlYmQyN2RjOTc1ZjQ2NmViZWVhOTFkNWMyNzc1YWNjID0gTC5wb3B1cCh7Im1heFdpZHRoIjogIjEwMCUifSk7CgogICAgICAgIAogICAgICAgICAgICB2YXIgaHRtbF81ODQ1N2IwMzQyNjU0NzRmYmExNGI0M2RjYmJkZjBiOCA9ICQoYDxkaXYgaWQ9Imh0bWxfNTg0NTdiMDM0MjY1NDc0ZmJhMTRiNDNkY2JiZGYwYjgiIHN0eWxlPSJ3aWR0aDogMTAwLjAlOyBoZWlnaHQ6IDEwMC4wJTsiPk5hbWU6IEJPTlVTIERJVENIIFByZWNpcDogMC4xNDwvZGl2PmApWzBdOwogICAgICAgICAgICBwb3B1cF8wZWJkMjdkYzk3NWY0NjZlYmVlYTkxZDVjMjc3NWFjYy5zZXRDb250ZW50KGh0bWxfNTg0NTdiMDM0MjY1NDc0ZmJhMTRiNDNkY2JiZGYwYjgpOwogICAgICAgIAoKICAgICAgICBtYXJrZXJfYjI0MDg2NTQxNjFiNGNhM2I4Y2Q4NTNlOTNjZDhiYzUuYmluZFBvcHVwKHBvcHVwXzBlYmQyN2RjOTc1ZjQ2NmViZWVhOTFkNWMyNzc1YWNjKQogICAgICAgIDsKCiAgICAgICAgCiAgICAKICAgIAogICAgICAgICAgICB2YXIgbWFya2VyXzkwNmNiM2Y1ODJkODRhYmNhY2RhM2JkZjI1YmNjODhkID0gTC5tYXJrZXIoCiAgICAgICAgICAgICAgICBbNDAuMjExMDgzLCAtMTA1LjI1MDkyN10sCiAgICAgICAgICAgICAgICB7fQogICAgICAgICAgICApLmFkZFRvKG1hcmtlcl9jbHVzdGVyX2I4MTZmMjQ2NTM0MDRlZWFhNjI4Y2I4MzAwNzJmYTY4KTsKICAgICAgICAKICAgIAogICAgICAgIHZhciBwb3B1cF9jZDYwNWEzNGU2Mzc0YWU2ODkyMzAwNzM0MDI3MTYzNyA9IEwucG9wdXAoeyJtYXhXaWR0aCI6ICIxMDAlIn0pOwoKICAgICAgICAKICAgICAgICAgICAgdmFyIGh0bWxfNmJmM2RmODA2YmQwNDdjOGI3Y2RkMTZjZmMzNDEzM2EgPSAkKGA8ZGl2IGlkPSJodG1sXzZiZjNkZjgwNmJkMDQ3YzhiN2NkZDE2Y2ZjMzQxMzNhIiBzdHlsZT0id2lkdGg6IDEwMC4wJTsgaGVpZ2h0OiAxMDAuMCU7Ij5OYW1lOiBTV0VERSBESVRDSCBQcmVjaXA6IDAuMDA8L2Rpdj5gKVswXTsKICAgICAgICAgICAgcG9wdXBfY2Q2MDVhMzRlNjM3NGFlNjg5MjMwMDczNDAyNzE2Mzcuc2V0Q29udGVudChodG1sXzZiZjNkZjgwNmJkMDQ3YzhiN2NkZDE2Y2ZjMzQxMzNhKTsKICAgICAgICAKCiAgICAgICAgbWFya2VyXzkwNmNiM2Y1ODJkODRhYmNhY2RhM2JkZjI1YmNjODhkLmJpbmRQb3B1cChwb3B1cF9jZDYwNWEzNGU2Mzc0YWU2ODkyMzAwNzM0MDI3MTYzNykKICAgICAgICA7CgogICAgICAgIAogICAgCiAgICAKICAgICAgICAgICAgdmFyIG1hcmtlcl9iZjk2NDg2NzYwOTM0ZDk2ODI1NTA5ZDljYzUyZDhiNyA9IEwubWFya2VyKAogICAgICAgICAgICAgICAgWzQwLjE4NzUyNCwgLTEwNS4xODkxMzJdLAogICAgICAgICAgICAgICAge30KICAgICAgICAgICAgKS5hZGRUbyhtYXJrZXJfY2x1c3Rlcl9iODE2ZjI0NjUzNDA0ZWVhYTYyOGNiODMwMDcyZmE2OCk7CiAgICAgICAgCiAgICAKICAgICAgICB2YXIgcG9wdXBfMDhmNTNkZjBmMDQxNGJmNGI4MjdjYWRkZDlmNjc0YjEgPSBMLnBvcHVwKHsibWF4V2lkdGgiOiAiMTAwJSJ9KTsKCiAgICAgICAgCiAgICAgICAgICAgIHZhciBodG1sXzQ4YzI4NGZhMzdmZTRkYWFiZjE2NWI2MWIyNjE4MmI4ID0gJChgPGRpdiBpZD0iaHRtbF80OGMyODRmYTM3ZmU0ZGFhYmYxNjViNjFiMjYxODJiOCIgc3R5bGU9IndpZHRoOiAxMDAuMCU7IGhlaWdodDogMTAwLjAlOyI+TmFtZTogUlVOWU9OIERJVENIIFByZWNpcDogMC4wMDwvZGl2PmApWzBdOwogICAgICAgICAgICBwb3B1cF8wOGY1M2RmMGYwNDE0YmY0YjgyN2NhZGRkOWY2NzRiMS5zZXRDb250ZW50KGh0bWxfNDhjMjg0ZmEzN2ZlNGRhYWJmMTY1YjYxYjI2MTgyYjgpOwogICAgICAgIAoKICAgICAgICBtYXJrZXJfYmY5NjQ4Njc2MDkzNGQ5NjgyNTUwOWQ5Y2M1MmQ4YjcuYmluZFBvcHVwKHBvcHVwXzA4ZjUzZGYwZjA0MTRiZjRiODI3Y2FkZGQ5ZjY3NGIxKQogICAgICAgIDsKCiAgICAgICAgCiAgICAKICAgIAogICAgICAgICAgICB2YXIgbWFya2VyX2UzMWJjNTA2YWRkNDQxMTY5Y2FiYTJlZDMxYzYyNzdlID0gTC5tYXJrZXIoCiAgICAgICAgICAgICAgICBbNDAuMTgxODgsIC0xMDUuMTk2Nzc1XSwKICAgICAgICAgICAgICAgIHt9CiAgICAgICAgICAgICkuYWRkVG8obWFya2VyX2NsdXN0ZXJfYjgxNmYyNDY1MzQwNGVlYWE2MjhjYjgzMDA3MmZhNjgpOwogICAgICAgIAogICAgCiAgICAgICAgdmFyIHBvcHVwXzY4NWI3ZmRmMmJhMTQ2NWRhMDZmZTdjMjQ4ZmQwNTIwID0gTC5wb3B1cCh7Im1heFdpZHRoIjogIjEwMCUifSk7CgogICAgICAgIAogICAgICAgICAgICB2YXIgaHRtbF9jY2NkYmJiYTQ5ZGI0ODNmODc2MDQxMjNiYTVlMDExZSA9ICQoYDxkaXYgaWQ9Imh0bWxfY2NjZGJiYmE0OWRiNDgzZjg3NjA0MTIzYmE1ZTAxMWUiIHN0eWxlPSJ3aWR0aDogMTAwLjAlOyBoZWlnaHQ6IDEwMC4wJTsiPk5hbWU6IERBVklTIEFORCBET1dOSU5HIERJVENIIFByZWNpcDogMC4wMDwvZGl2PmApWzBdOwogICAgICAgICAgICBwb3B1cF82ODViN2ZkZjJiYTE0NjVkYTA2ZmU3YzI0OGZkMDUyMC5zZXRDb250ZW50KGh0bWxfY2NjZGJiYmE0OWRiNDgzZjg3NjA0MTIzYmE1ZTAxMWUpOwogICAgICAgIAoKICAgICAgICBtYXJrZXJfZTMxYmM1MDZhZGQ0NDExNjljYWJhMmVkMzFjNjI3N2UuYmluZFBvcHVwKHBvcHVwXzY4NWI3ZmRmMmJhMTQ2NWRhMDZmZTdjMjQ4ZmQwNTIwKQogICAgICAgIDsKCiAgICAgICAgCiAgICAKICAgIAogICAgICAgICAgICB2YXIgbWFya2VyX2U5OWEwZDEyYTVjNTQ1NTg4NWY0OTE3ODU3MGY1N2Q1ID0gTC5tYXJrZXIoCiAgICAgICAgICAgICAgICBbNDAuMDE4NjY3LCAtMTA1LjMyNjI1XSwKICAgICAgICAgICAgICAgIHt9CiAgICAgICAgICAgICkuYWRkVG8obWFya2VyX2NsdXN0ZXJfYjgxNmYyNDY1MzQwNGVlYWE2MjhjYjgzMDA3MmZhNjgpOwogICAgICAgIAogICAgCiAgICAgICAgdmFyIHBvcHVwX2QwZGE3ZGRlMzU2MzRkZDFiOWE2OWJhYmU3YTQ4NDZmID0gTC5wb3B1cCh7Im1heFdpZHRoIjogIjEwMCUifSk7CgogICAgICAgIAogICAgICAgICAgICB2YXIgaHRtbF84NmMwZWQyYjJiMjU0MGNmYjRlNTYyMDRhNWE3ZGM1NSA9ICQoYDxkaXYgaWQ9Imh0bWxfODZjMGVkMmIyYjI1NDBjZmI0ZTU2MjA0YTVhN2RjNTUiIHN0eWxlPSJ3aWR0aDogMTAwLjAlOyBoZWlnaHQ6IDEwMC4wJTsiPk5hbWU6IEZPVVJNSUxFIENSRUVLIEFUIE9ST0RFTEwsIENPIFByZWNpcDogMC43NDwvZGl2PmApWzBdOwogICAgICAgICAgICBwb3B1cF9kMGRhN2RkZTM1NjM0ZGQxYjlhNjliYWJlN2E0ODQ2Zi5zZXRDb250ZW50KGh0bWxfODZjMGVkMmIyYjI1NDBjZmI0ZTU2MjA0YTVhN2RjNTUpOwogICAgICAgIAoKICAgICAgICBtYXJrZXJfZTk5YTBkMTJhNWM1NDU1ODg1ZjQ5MTc4NTcwZjU3ZDUuYmluZFBvcHVwKHBvcHVwX2QwZGE3ZGRlMzU2MzRkZDFiOWE2OWJhYmU3YTQ4NDZmKQogICAgICAgIDsKCiAgICAgICAgCiAgICAKICAgIAogICAgICAgICAgICB2YXIgbWFya2VyXzNhOGYxZGRhOTA2YTRmMzg4NDA2MjQyMWRmZDNiZGViID0gTC5tYXJrZXIoCiAgICAgICAgICAgICAgICBbNDAuMTg4NTc5LCAtMTA1LjIwOTI4Ml0sCiAgICAgICAgICAgICAgICB7fQogICAgICAgICAgICApLmFkZFRvKG1hcmtlcl9jbHVzdGVyX2I4MTZmMjQ2NTM0MDRlZWFhNjI4Y2I4MzAwNzJmYTY4KTsKICAgICAgICAKICAgIAogICAgICAgIHZhciBwb3B1cF9lYjU3NzA3NmJkZTc0MmJmOTU1NDkyNjAzNzY3NjYwOCA9IEwucG9wdXAoeyJtYXhXaWR0aCI6ICIxMDAlIn0pOwoKICAgICAgICAKICAgICAgICAgICAgdmFyIGh0bWxfODk3MDIxMGFlYzViNGM0MWExZTUzZjgzZGE3ZGUxNDkgPSAkKGA8ZGl2IGlkPSJodG1sXzg5NzAyMTBhZWM1YjRjNDFhMWU1M2Y4M2RhN2RlMTQ5IiBzdHlsZT0id2lkdGg6IDEwMC4wJTsgaGVpZ2h0OiAxMDAuMCU7Ij5OYW1lOiBKQU1FUyBESVRDSCBQcmVjaXA6IDAuMDg8L2Rpdj5gKVswXTsKICAgICAgICAgICAgcG9wdXBfZWI1NzcwNzZiZGU3NDJiZjk1NTQ5MjYwMzc2NzY2MDguc2V0Q29udGVudChodG1sXzg5NzAyMTBhZWM1YjRjNDFhMWU1M2Y4M2RhN2RlMTQ5KTsKICAgICAgICAKCiAgICAgICAgbWFya2VyXzNhOGYxZGRhOTA2YTRmMzg4NDA2MjQyMWRmZDNiZGViLmJpbmRQb3B1cChwb3B1cF9lYjU3NzA3NmJkZTc0MmJmOTU1NDkyNjAzNzY3NjYwOCkKICAgICAgICA7CgogICAgICAgIAogICAgCiAgICAKICAgICAgICAgICAgdmFyIG1hcmtlcl85MzNjOTUyOGFjNWU0ZWI2OWQ2ZDM5NDEzZjM5MGU5YyA9IEwubWFya2VyKAogICAgICAgICAgICAgICAgWzQwLjA1MzAzNSwgLTEwNS4xOTMwNDhdLAogICAgICAgICAgICAgICAge30KICAgICAgICAgICAgKS5hZGRUbyhtYXJrZXJfY2x1c3Rlcl9iODE2ZjI0NjUzNDA0ZWVhYTYyOGNiODMwMDcyZmE2OCk7CiAgICAgICAgCiAgICAKICAgICAgICB2YXIgcG9wdXBfZGVjMDU3Y2YyYTNjNDQ0ZWI2NDFmMTcwOTU4NmQ5MWYgPSBMLnBvcHVwKHsibWF4V2lkdGgiOiAiMTAwJSJ9KTsKCiAgICAgICAgCiAgICAgICAgICAgIHZhciBodG1sXzJiOWIwZmU3MzRiNDQ2NzE5MzAyYTE1ZWE0YjlkOWVkID0gJChgPGRpdiBpZD0iaHRtbF8yYjliMGZlNzM0YjQ0NjcxOTMwMmExNWVhNGI5ZDllZCIgc3R5bGU9IndpZHRoOiAxMDAuMCU7IGhlaWdodDogMTAwLjAlOyI+TmFtZTogQk9VTERFUiBDUkVFSyBTVVBQTFkgQ0FOQUwgVE8gQk9VTERFUiBDUkVFSyBORUFSIEJPVUxERVIgUHJlY2lwOiAwLjAwPC9kaXY+YClbMF07CiAgICAgICAgICAgIHBvcHVwX2RlYzA1N2NmMmEzYzQ0NGViNjQxZjE3MDk1ODZkOTFmLnNldENvbnRlbnQoaHRtbF8yYjliMGZlNzM0YjQ0NjcxOTMwMmExNWVhNGI5ZDllZCk7CiAgICAgICAgCgogICAgICAgIG1hcmtlcl85MzNjOTUyOGFjNWU0ZWI2OWQ2ZDM5NDEzZjM5MGU5Yy5iaW5kUG9wdXAocG9wdXBfZGVjMDU3Y2YyYTNjNDQ0ZWI2NDFmMTcwOTU4NmQ5MWYpCiAgICAgICAgOwoKICAgICAgICAKICAgIAogICAgCiAgICAgICAgICAgIHZhciBtYXJrZXJfZGE0YjkyZTY0NDk4NDc0MDg1MDEwZGNkZTE4YjA1ZTIgPSBMLm1hcmtlcigKICAgICAgICAgICAgICAgIFs0MC4yNTgzNjcsIC0xMDUuMTc0OTU3XSwKICAgICAgICAgICAgICAgIHt9CiAgICAgICAgICAgICkuYWRkVG8obWFya2VyX2NsdXN0ZXJfYjgxNmYyNDY1MzQwNGVlYWE2MjhjYjgzMDA3MmZhNjgpOwogICAgICAgIAogICAgCiAgICAgICAgdmFyIHBvcHVwXzg4ZGE0NDU2YTUwMTQ4NmFiNzA0ZWM0NDM3ZDIxOWY3ID0gTC5wb3B1cCh7Im1heFdpZHRoIjogIjEwMCUifSk7CgogICAgICAgIAogICAgICAgICAgICB2YXIgaHRtbF9iMjQ3YTI0MjFkMTc0OWM1YTA2MjM0Y2Y4ZDcwYWYwNSA9ICQoYDxkaXYgaWQ9Imh0bWxfYjI0N2EyNDIxZDE3NDljNWEwNjIzNGNmOGQ3MGFmMDUiIHN0eWxlPSJ3aWR0aDogMTAwLjAlOyBoZWlnaHQ6IDEwMC4wJTsiPk5hbWU6IEJPVUxERVItTEFSSU1FUiBESVRDSCBORUFSIEJFUlRIT1VEIFByZWNpcDogMC4wMDwvZGl2PmApWzBdOwogICAgICAgICAgICBwb3B1cF84OGRhNDQ1NmE1MDE0ODZhYjcwNGVjNDQzN2QyMTlmNy5zZXRDb250ZW50KGh0bWxfYjI0N2EyNDIxZDE3NDljNWEwNjIzNGNmOGQ3MGFmMDUpOwogICAgICAgIAoKICAgICAgICBtYXJrZXJfZGE0YjkyZTY0NDk4NDc0MDg1MDEwZGNkZTE4YjA1ZTIuYmluZFBvcHVwKHBvcHVwXzg4ZGE0NDU2YTUwMTQ4NmFiNzA0ZWM0NDM3ZDIxOWY3KQogICAgICAgIDsKCiAgICAgICAgCiAgICAKICAgIAogICAgICAgICAgICB2YXIgbWFya2VyXzU4ODk4ZGJhZDA4NTQyNTE4ZDU4MGQwZTljYmI4NDZiID0gTC5tYXJrZXIoCiAgICAgICAgICAgICAgICBbMzkuOTM4MzUxLCAtMTA1LjM0NzkwNl0sCiAgICAgICAgICAgICAgICB7fQogICAgICAgICAgICApLmFkZFRvKG1hcmtlcl9jbHVzdGVyX2I4MTZmMjQ2NTM0MDRlZWFhNjI4Y2I4MzAwNzJmYTY4KTsKICAgICAgICAKICAgIAogICAgICAgIHZhciBwb3B1cF9jMDgyOTEyZDQ4OTk0ODZjYWQ1Y2FmMjg1MmU4NmEyZiA9IEwucG9wdXAoeyJtYXhXaWR0aCI6ICIxMDAlIn0pOwoKICAgICAgICAKICAgICAgICAgICAgdmFyIGh0bWxfYzE2YmQ4NjRlZTc5NDUwMmI3NmNhYzc4NTNiNzIxMDYgPSAkKGA8ZGl2IGlkPSJodG1sX2MxNmJkODY0ZWU3OTQ1MDJiNzZjYWM3ODUzYjcyMTA2IiBzdHlsZT0id2lkdGg6IDEwMC4wJTsgaGVpZ2h0OiAxMDAuMCU7Ij5OYW1lOiBTT1VUSCBCT1VMREVSIENSRUVLIEJFTE9XIEdST1NTIFJFU0VSVk9JUiBQcmVjaXA6IDgzLjQwPC9kaXY+YClbMF07CiAgICAgICAgICAgIHBvcHVwX2MwODI5MTJkNDg5OTQ4NmNhZDVjYWYyODUyZTg2YTJmLnNldENvbnRlbnQoaHRtbF9jMTZiZDg2NGVlNzk0NTAyYjc2Y2FjNzg1M2I3MjEwNik7CiAgICAgICAgCgogICAgICAgIG1hcmtlcl81ODg5OGRiYWQwODU0MjUxOGQ1ODBkMGU5Y2JiODQ2Yi5iaW5kUG9wdXAocG9wdXBfYzA4MjkxMmQ0ODk5NDg2Y2FkNWNhZjI4NTJlODZhMmYpCiAgICAgICAgOwoKICAgICAgICAKICAgIAogICAgCiAgICAgICAgICAgIHZhciBtYXJrZXJfMDg2Nzc3YjU1M2U2NDRjZjg4ZmQ2OWM0ZGQyNjRkZDggPSBMLm1hcmtlcigKICAgICAgICAgICAgICAgIFs0MC4yMTI1MDUsIC0xMDUuMjUxODI2XSwKICAgICAgICAgICAgICAgIHt9CiAgICAgICAgICAgICkuYWRkVG8obWFya2VyX2NsdXN0ZXJfYjgxNmYyNDY1MzQwNGVlYWE2MjhjYjgzMDA3MmZhNjgpOwogICAgICAgIAogICAgCiAgICAgICAgdmFyIHBvcHVwXzk4YWU0ZjMzMjhlYjRjN2Q5NDk2OTQwMjEyNjg2YmJkID0gTC5wb3B1cCh7Im1heFdpZHRoIjogIjEwMCUifSk7CgogICAgICAgIAogICAgICAgICAgICB2YXIgaHRtbF8zZTkxOGFiNjEyN2I0YjQ1OGYyZWE3NmMzNDI0Y2NjOCA9ICQoYDxkaXYgaWQ9Imh0bWxfM2U5MThhYjYxMjdiNGI0NThmMmVhNzZjMzQyNGNjYzgiIHN0eWxlPSJ3aWR0aDogMTAwLjAlOyBoZWlnaHQ6IDEwMC4wJTsiPk5hbWU6IFBBTE1FUlRPTiBESVRDSCBQcmVjaXA6IDAuMzU8L2Rpdj5gKVswXTsKICAgICAgICAgICAgcG9wdXBfOThhZTRmMzMyOGViNGM3ZDk0OTY5NDAyMTI2ODZiYmQuc2V0Q29udGVudChodG1sXzNlOTE4YWI2MTI3YjRiNDU4ZjJlYTc2YzM0MjRjY2M4KTsKICAgICAgICAKCiAgICAgICAgbWFya2VyXzA4Njc3N2I1NTNlNjQ0Y2Y4OGZkNjljNGRkMjY0ZGQ4LmJpbmRQb3B1cChwb3B1cF85OGFlNGYzMzI4ZWI0YzdkOTQ5Njk0MDIxMjY4NmJiZCkKICAgICAgICA7CgogICAgICAgIAogICAgCiAgICAKICAgICAgICAgICAgdmFyIG1hcmtlcl85NzA2MzRiMTRiZTM0NDJhYjQyNTY3ODM5ZTVjYzE2MiA9IEwubWFya2VyKAogICAgICAgICAgICAgICAgWzQwLjIxOTA0NiwgLTEwNS4yNTk3OTVdLAogICAgICAgICAgICAgICAge30KICAgICAgICAgICAgKS5hZGRUbyhtYXJrZXJfY2x1c3Rlcl9iODE2ZjI0NjUzNDA0ZWVhYTYyOGNiODMwMDcyZmE2OCk7CiAgICAgICAgCiAgICAKICAgICAgICB2YXIgcG9wdXBfNGE5NDIwM2E5MTVkNGU1ODhkMTVkZDk3MmIxMWNiZmUgPSBMLnBvcHVwKHsibWF4V2lkdGgiOiAiMTAwJSJ9KTsKCiAgICAgICAgCiAgICAgICAgICAgIHZhciBodG1sXzQ3OWIzMWRhYzA5ODRjZWNhY2YyMjgwNjkwNTAyODVlID0gJChgPGRpdiBpZD0iaHRtbF80NzliMzFkYWMwOTg0Y2VjYWNmMjI4MDY5MDUwMjg1ZSIgc3R5bGU9IndpZHRoOiAxMDAuMCU7IGhlaWdodDogMTAwLjAlOyI+TmFtZTogU1VQUExZIERJVENIIFByZWNpcDogMC4wMDwvZGl2PmApWzBdOwogICAgICAgICAgICBwb3B1cF80YTk0MjAzYTkxNWQ0ZTU4OGQxNWRkOTcyYjExY2JmZS5zZXRDb250ZW50KGh0bWxfNDc5YjMxZGFjMDk4NGNlY2FjZjIyODA2OTA1MDI4NWUpOwogICAgICAgIAoKICAgICAgICBtYXJrZXJfOTcwNjM0YjE0YmUzNDQyYWI0MjU2NzgzOWU1Y2MxNjIuYmluZFBvcHVwKHBvcHVwXzRhOTQyMDNhOTE1ZDRlNTg4ZDE1ZGQ5NzJiMTFjYmZlKQogICAgICAgIDsKCiAgICAgICAgCiAgICAKICAgIAogICAgICAgICAgICB2YXIgbWFya2VyX2JhYzJiYjZhMDNhYzQ4ZWRiNzViNTk4MzQ4NDUwMWJkID0gTC5tYXJrZXIoCiAgICAgICAgICAgICAgICBbNDAuMTg3NTc4LCAtMTA1LjE4OTE5MV0sCiAgICAgICAgICAgICAgICB7fQogICAgICAgICAgICApLmFkZFRvKG1hcmtlcl9jbHVzdGVyX2I4MTZmMjQ2NTM0MDRlZWFhNjI4Y2I4MzAwNzJmYTY4KTsKICAgICAgICAKICAgIAogICAgICAgIHZhciBwb3B1cF8zYjhkNGUzNjRkZWU0MmJhOTAxZDUyMmZiYjZmMjllZSA9IEwucG9wdXAoeyJtYXhXaWR0aCI6ICIxMDAlIn0pOwoKICAgICAgICAKICAgICAgICAgICAgdmFyIGh0bWxfOTBhY2Q4OWMyNGJmNGVlNTkzYmI1NjRmNmJmNTk0MWMgPSAkKGA8ZGl2IGlkPSJodG1sXzkwYWNkODljMjRiZjRlZTU5M2JiNTY0ZjZiZjU5NDFjIiBzdHlsZT0id2lkdGg6IDEwMC4wJTsgaGVpZ2h0OiAxMDAuMCU7Ij5OYW1lOiBERU5JTyBUQVlMT1IgRElUQ0ggUHJlY2lwOiAyODE2LjI1PC9kaXY+YClbMF07CiAgICAgICAgICAgIHBvcHVwXzNiOGQ0ZTM2NGRlZTQyYmE5MDFkNTIyZmJiNmYyOWVlLnNldENvbnRlbnQoaHRtbF85MGFjZDg5YzI0YmY0ZWU1OTNiYjU2NGY2YmY1OTQxYyk7CiAgICAgICAgCgogICAgICAgIG1hcmtlcl9iYWMyYmI2YTAzYWM0OGVkYjc1YjU5ODM0ODQ1MDFiZC5iaW5kUG9wdXAocG9wdXBfM2I4ZDRlMzY0ZGVlNDJiYTkwMWQ1MjJmYmI2ZjI5ZWUpCiAgICAgICAgOwoKICAgICAgICAKICAgIAogICAgCiAgICAgICAgICAgIHZhciBtYXJrZXJfOWJkMGM1MjNkNDU4NGIwMjg1YWQ5MGM0YjM3OWRjOWEgPSBMLm1hcmtlcigKICAgICAgICAgICAgICAgIFs0MC4wNDIwMjgsIC0xMDUuMzY0OTE3XSwKICAgICAgICAgICAgICAgIHt9CiAgICAgICAgICAgICkuYWRkVG8obWFya2VyX2NsdXN0ZXJfYjgxNmYyNDY1MzQwNGVlYWE2MjhjYjgzMDA3MmZhNjgpOwogICAgICAgIAogICAgCiAgICAgICAgdmFyIHBvcHVwX2Y0MzA5MDhkMGI5NDQ0NzQ4YzAxYWI3N2MzMGEwNzYxID0gTC5wb3B1cCh7Im1heFdpZHRoIjogIjEwMCUifSk7CgogICAgICAgIAogICAgICAgICAgICB2YXIgaHRtbF9iYWQ2ZjA1ZGY3ZGQ0NWZkOTY4NjUzNTM0NTQ2OTVjMCA9ICQoYDxkaXYgaWQ9Imh0bWxfYmFkNmYwNWRmN2RkNDVmZDk2ODY1MzUzNDU0Njk1YzAiIHN0eWxlPSJ3aWR0aDogMTAwLjAlOyBoZWlnaHQ6IDEwMC4wJTsiPk5hbWU6IEZPVVJNSUxFIENSRUVLIEFUIExPR0FOIE1JTEwgUk9BRCBORUFSIENSSVNNQU4sIENPIFByZWNpcDogbmFuPC9kaXY+YClbMF07CiAgICAgICAgICAgIHBvcHVwX2Y0MzA5MDhkMGI5NDQ0NzQ4YzAxYWI3N2MzMGEwNzYxLnNldENvbnRlbnQoaHRtbF9iYWQ2ZjA1ZGY3ZGQ0NWZkOTY4NjUzNTM0NTQ2OTVjMCk7CiAgICAgICAgCgogICAgICAgIG1hcmtlcl85YmQwYzUyM2Q0NTg0YjAyODVhZDkwYzRiMzc5ZGM5YS5iaW5kUG9wdXAocG9wdXBfZjQzMDkwOGQwYjk0NDQ3NDhjMDFhYjc3YzMwYTA3NjEpCiAgICAgICAgOwoKICAgICAgICAKICAgIAogICAgCiAgICAgICAgICAgIHZhciBtYXJrZXJfYzUxNTI0OTk5NWEwNDRmOGFlNGE2MDFmNWI3MzI1NDAgPSBMLm1hcmtlcigKICAgICAgICAgICAgICAgIFs0MC4xNzcwOCwgLTEwNS4xNzg1NjddLAogICAgICAgICAgICAgICAge30KICAgICAgICAgICAgKS5hZGRUbyhtYXJrZXJfY2x1c3Rlcl9iODE2ZjI0NjUzNDA0ZWVhYTYyOGNiODMwMDcyZmE2OCk7CiAgICAgICAgCiAgICAKICAgICAgICB2YXIgcG9wdXBfNGU3NjRkMTlmOTJhNDg5YmFmZDdkNDY0NWUyMDhmYTkgPSBMLnBvcHVwKHsibWF4V2lkdGgiOiAiMTAwJSJ9KTsKCiAgICAgICAgCiAgICAgICAgICAgIHZhciBodG1sXzQxNjQwYTRiZjdiMDQwYTdiOWUxYjVmZmFlZDVkNWNkID0gJChgPGRpdiBpZD0iaHRtbF80MTY0MGE0YmY3YjA0MGE3YjllMWI1ZmZhZWQ1ZDVjZCIgc3R5bGU9IndpZHRoOiAxMDAuMCU7IGhlaWdodDogMTAwLjAlOyI+TmFtZTogUEVDSyBQRUxMQSBDTE9WRVIgRElUQ0ggUHJlY2lwOiAxLjQyPC9kaXY+YClbMF07CiAgICAgICAgICAgIHBvcHVwXzRlNzY0ZDE5ZjkyYTQ4OWJhZmQ3ZDQ2NDVlMjA4ZmE5LnNldENvbnRlbnQoaHRtbF80MTY0MGE0YmY3YjA0MGE3YjllMWI1ZmZhZWQ1ZDVjZCk7CiAgICAgICAgCgogICAgICAgIG1hcmtlcl9jNTE1MjQ5OTk1YTA0NGY4YWU0YTYwMWY1YjczMjU0MC5iaW5kUG9wdXAocG9wdXBfNGU3NjRkMTlmOTJhNDg5YmFmZDdkNDY0NWUyMDhmYTkpCiAgICAgICAgOwoKICAgICAgICAKICAgIAogICAgCiAgICAgICAgICAgIHZhciBtYXJrZXJfZDlmNDU3ODVjYTNlNDZjZTkyOTJhMzY3NTlhY2YyMTEgPSBMLm1hcmtlcigKICAgICAgICAgICAgICAgIFszOS45NDc3MDQsIC0xMDUuMzU3MzA4XSwKICAgICAgICAgICAgICAgIHt9CiAgICAgICAgICAgICkuYWRkVG8obWFya2VyX2NsdXN0ZXJfYjgxNmYyNDY1MzQwNGVlYWE2MjhjYjgzMDA3MmZhNjgpOwogICAgICAgIAogICAgCiAgICAgICAgdmFyIHBvcHVwXzU2YjNmNGVkZGY2ODRjYzdiMjY5YzY3YmI5ZTcyM2QyID0gTC5wb3B1cCh7Im1heFdpZHRoIjogIjEwMCUifSk7CgogICAgICAgIAogICAgICAgICAgICB2YXIgaHRtbF9kMGFhMDAzMzY3N2U0ZDlkOTM4M2E5N2I2MWY0MGZhMSA9ICQoYDxkaXYgaWQ9Imh0bWxfZDBhYTAwMzM2NzdlNGQ5ZDkzODNhOTdiNjFmNDBmYTEiIHN0eWxlPSJ3aWR0aDogMTAwLjAlOyBoZWlnaHQ6IDEwMC4wJTsiPk5hbWU6IEdST1NTIFJFU0VSVk9JUiAgUHJlY2lwOiAxMjkxMi4wMDwvZGl2PmApWzBdOwogICAgICAgICAgICBwb3B1cF81NmIzZjRlZGRmNjg0Y2M3YjI2OWM2N2JiOWU3MjNkMi5zZXRDb250ZW50KGh0bWxfZDBhYTAwMzM2NzdlNGQ5ZDkzODNhOTdiNjFmNDBmYTEpOwogICAgICAgIAoKICAgICAgICBtYXJrZXJfZDlmNDU3ODVjYTNlNDZjZTkyOTJhMzY3NTlhY2YyMTEuYmluZFBvcHVwKHBvcHVwXzU2YjNmNGVkZGY2ODRjYzdiMjY5YzY3YmI5ZTcyM2QyKQogICAgICAgIDsKCiAgICAgICAgCiAgICAKPC9zY3JpcHQ+" style="position:absolute;width:100%;height:100%;left:0;top:0;border:none !important;" allowfullscreen webkitallowfullscreen mozallowfullscreen></iframe></div></div>





<div class="notice--info" markdown="1">

## Additional Resources

* <a href="https://blog.datafiniti.co/4-reasons-you-should-use-json-instead-of-csv-2cac362f1943" target="_blank">Why you should use JSON instead of csv.</a>


* <a href="https://www.w3schools.com/js/js_json_intro.asp" target="_blank">W3schools JSON intro </a>

</div>

