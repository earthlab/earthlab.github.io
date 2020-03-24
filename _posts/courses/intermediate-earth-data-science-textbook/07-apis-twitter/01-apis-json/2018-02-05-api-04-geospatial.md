---
layout: single
title: 'Programmatically Accessing Geospatial Data Using APIs'
excerpt: 'This lesson walks through the process of retrieving and manipulating surface water data housed in the Colorado Information Warehouse. These data are stored in JSON format with spatial x, y information that support mapping.'
authors: ['Leah Wasser', 'Max Joseph', 'Martha Morrissey', 'Jenny Palomino', 'Carson Farmer']
modified: 2020-03-24
category: [courses]
class-lesson: ['intro-APIs-python']
permalink: /courses/use-data-open-source-python/using-apis-natural-language-processing-twitter/co-water-data-spatial-python/
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
      'date_time': '2020-03-24T15:00:00.000',
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
      'date_time': '2020-03-24T15:15:00.000',
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
      <td>2020-03-24T15:00:00.000</td>
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
      <td>2020-03-24T15:15:00.000</td>
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
      <td>3.75</td>
      <td>Diversion</td>
      <td>5</td>
      <td>2020-03-24T13:45:00.000</td>
      <td>BOULDER</td>
      <td>DISCHRG</td>
      <td>0.23</td>
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
      <td>2020-03-24T15:30:00.000</td>
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
      <td>2020-03-24T15:00:00.000</td>
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
      <td>2020-03-24T15:00:00.000</td>
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
      <td>2020-03-24T15:15:00.000</td>
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
      <td>3.75</td>
      <td>Diversion</td>
      <td>5</td>
      <td>2020-03-24T13:45:00.000</td>
      <td>BOULDER</td>
      <td>DISCHRG</td>
      <td>0.23</td>
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
      <td>2020-03-24T15:30:00.000</td>
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
      <td>2020-03-24T15:00:00.000</td>
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



<div style="width:100%;"><div style="position:relative;width:100%;height:0;padding-bottom:60%;"><iframe src="data:text/html;charset=utf-8;base64,PCFET0NUWVBFIGh0bWw+CjxoZWFkPiAgICAKICAgIDxtZXRhIGh0dHAtZXF1aXY9ImNvbnRlbnQtdHlwZSIgY29udGVudD0idGV4dC9odG1sOyBjaGFyc2V0PVVURi04IiAvPgogICAgCiAgICAgICAgPHNjcmlwdD4KICAgICAgICAgICAgTF9OT19UT1VDSCA9IGZhbHNlOwogICAgICAgICAgICBMX0RJU0FCTEVfM0QgPSBmYWxzZTsKICAgICAgICA8L3NjcmlwdD4KICAgIAogICAgPHNjcmlwdCBzcmM9Imh0dHBzOi8vY2RuLmpzZGVsaXZyLm5ldC9ucG0vbGVhZmxldEAxLjUuMS9kaXN0L2xlYWZsZXQuanMiPjwvc2NyaXB0PgogICAgPHNjcmlwdCBzcmM9Imh0dHBzOi8vY29kZS5qcXVlcnkuY29tL2pxdWVyeS0xLjEyLjQubWluLmpzIj48L3NjcmlwdD4KICAgIDxzY3JpcHQgc3JjPSJodHRwczovL21heGNkbi5ib290c3RyYXBjZG4uY29tL2Jvb3RzdHJhcC8zLjIuMC9qcy9ib290c3RyYXAubWluLmpzIj48L3NjcmlwdD4KICAgIDxzY3JpcHQgc3JjPSJodHRwczovL2NkbmpzLmNsb3VkZmxhcmUuY29tL2FqYXgvbGlicy9MZWFmbGV0LmF3ZXNvbWUtbWFya2Vycy8yLjAuMi9sZWFmbGV0LmF3ZXNvbWUtbWFya2Vycy5qcyI+PC9zY3JpcHQ+CiAgICA8bGluayByZWw9InN0eWxlc2hlZXQiIGhyZWY9Imh0dHBzOi8vY2RuLmpzZGVsaXZyLm5ldC9ucG0vbGVhZmxldEAxLjUuMS9kaXN0L2xlYWZsZXQuY3NzIi8+CiAgICA8bGluayByZWw9InN0eWxlc2hlZXQiIGhyZWY9Imh0dHBzOi8vbWF4Y2RuLmJvb3RzdHJhcGNkbi5jb20vYm9vdHN0cmFwLzMuMi4wL2Nzcy9ib290c3RyYXAubWluLmNzcyIvPgogICAgPGxpbmsgcmVsPSJzdHlsZXNoZWV0IiBocmVmPSJodHRwczovL21heGNkbi5ib290c3RyYXBjZG4uY29tL2Jvb3RzdHJhcC8zLjIuMC9jc3MvYm9vdHN0cmFwLXRoZW1lLm1pbi5jc3MiLz4KICAgIDxsaW5rIHJlbD0ic3R5bGVzaGVldCIgaHJlZj0iaHR0cHM6Ly9tYXhjZG4uYm9vdHN0cmFwY2RuLmNvbS9mb250LWF3ZXNvbWUvNC42LjMvY3NzL2ZvbnQtYXdlc29tZS5taW4uY3NzIi8+CiAgICA8bGluayByZWw9InN0eWxlc2hlZXQiIGhyZWY9Imh0dHBzOi8vY2RuanMuY2xvdWRmbGFyZS5jb20vYWpheC9saWJzL0xlYWZsZXQuYXdlc29tZS1tYXJrZXJzLzIuMC4yL2xlYWZsZXQuYXdlc29tZS1tYXJrZXJzLmNzcyIvPgogICAgPGxpbmsgcmVsPSJzdHlsZXNoZWV0IiBocmVmPSJodHRwczovL3Jhd2Nkbi5naXRoYWNrLmNvbS9weXRob24tdmlzdWFsaXphdGlvbi9mb2xpdW0vbWFzdGVyL2ZvbGl1bS90ZW1wbGF0ZXMvbGVhZmxldC5hd2Vzb21lLnJvdGF0ZS5jc3MiLz4KICAgIDxzdHlsZT5odG1sLCBib2R5IHt3aWR0aDogMTAwJTtoZWlnaHQ6IDEwMCU7bWFyZ2luOiAwO3BhZGRpbmc6IDA7fTwvc3R5bGU+CiAgICA8c3R5bGU+I21hcCB7cG9zaXRpb246YWJzb2x1dGU7dG9wOjA7Ym90dG9tOjA7cmlnaHQ6MDtsZWZ0OjA7fTwvc3R5bGU+CiAgICAKICAgICAgICAgICAgPG1ldGEgbmFtZT0idmlld3BvcnQiIGNvbnRlbnQ9IndpZHRoPWRldmljZS13aWR0aCwKICAgICAgICAgICAgICAgIGluaXRpYWwtc2NhbGU9MS4wLCBtYXhpbXVtLXNjYWxlPTEuMCwgdXNlci1zY2FsYWJsZT1ubyIgLz4KICAgICAgICAgICAgPHN0eWxlPgogICAgICAgICAgICAgICAgI21hcF84MzM3ZjgzYjgzYTg0MzhiODlkYTdiYjJhYjdhYTIwZCB7CiAgICAgICAgICAgICAgICAgICAgcG9zaXRpb246IHJlbGF0aXZlOwogICAgICAgICAgICAgICAgICAgIHdpZHRoOiAxMDAuMCU7CiAgICAgICAgICAgICAgICAgICAgaGVpZ2h0OiAxMDAuMCU7CiAgICAgICAgICAgICAgICAgICAgbGVmdDogMC4wJTsKICAgICAgICAgICAgICAgICAgICB0b3A6IDAuMCU7CiAgICAgICAgICAgICAgICB9CiAgICAgICAgICAgIDwvc3R5bGU+CiAgICAgICAgCjwvaGVhZD4KPGJvZHk+ICAgIAogICAgCiAgICAgICAgICAgIDxkaXYgY2xhc3M9ImZvbGl1bS1tYXAiIGlkPSJtYXBfODMzN2Y4M2I4M2E4NDM4Yjg5ZGE3YmIyYWI3YWEyMGQiID48L2Rpdj4KICAgICAgICAKPC9ib2R5Pgo8c2NyaXB0PiAgICAKICAgIAogICAgICAgICAgICB2YXIgbWFwXzgzMzdmODNiODNhODQzOGI4OWRhN2JiMmFiN2FhMjBkID0gTC5tYXAoCiAgICAgICAgICAgICAgICAibWFwXzgzMzdmODNiODNhODQzOGI4OWRhN2JiMmFiN2FhMjBkIiwKICAgICAgICAgICAgICAgIHsKICAgICAgICAgICAgICAgICAgICBjZW50ZXI6IFs0MC4wMSwgLTEwNS4yN10sCiAgICAgICAgICAgICAgICAgICAgY3JzOiBMLkNSUy5FUFNHMzg1NywKICAgICAgICAgICAgICAgICAgICB6b29tOiAxMCwKICAgICAgICAgICAgICAgICAgICB6b29tQ29udHJvbDogdHJ1ZSwKICAgICAgICAgICAgICAgICAgICBwcmVmZXJDYW52YXM6IGZhbHNlLAogICAgICAgICAgICAgICAgfQogICAgICAgICAgICApOwoKICAgICAgICAgICAgCgogICAgICAgIAogICAgCiAgICAgICAgICAgIHZhciB0aWxlX2xheWVyXzMzOWM2ZTAxZjZiYTRjOTY4ZGUwZTc4YmUyODUzMWE1ID0gTC50aWxlTGF5ZXIoCiAgICAgICAgICAgICAgICAiaHR0cHM6Ly9jYXJ0b2RiLWJhc2VtYXBzLXtzfS5nbG9iYWwuc3NsLmZhc3RseS5uZXQvbGlnaHRfYWxsL3t6fS97eH0ve3l9LnBuZyIsCiAgICAgICAgICAgICAgICB7ImF0dHJpYnV0aW9uIjogIlx1MDAyNmNvcHk7IFx1MDAzY2EgaHJlZj1cImh0dHA6Ly93d3cub3BlbnN0cmVldG1hcC5vcmcvY29weXJpZ2h0XCJcdTAwM2VPcGVuU3RyZWV0TWFwXHUwMDNjL2FcdTAwM2UgY29udHJpYnV0b3JzIFx1MDAyNmNvcHk7IFx1MDAzY2EgaHJlZj1cImh0dHA6Ly9jYXJ0b2RiLmNvbS9hdHRyaWJ1dGlvbnNcIlx1MDAzZUNhcnRvREJcdTAwM2MvYVx1MDAzZSwgQ2FydG9EQiBcdTAwM2NhIGhyZWYgPVwiaHR0cDovL2NhcnRvZGIuY29tL2F0dHJpYnV0aW9uc1wiXHUwMDNlYXR0cmlidXRpb25zXHUwMDNjL2FcdTAwM2UiLCAiZGV0ZWN0UmV0aW5hIjogZmFsc2UsICJtYXhOYXRpdmVab29tIjogMTgsICJtYXhab29tIjogMTgsICJtaW5ab29tIjogMCwgIm5vV3JhcCI6IGZhbHNlLCAib3BhY2l0eSI6IDEsICJzdWJkb21haW5zIjogImFiYyIsICJ0bXMiOiBmYWxzZX0KICAgICAgICAgICAgKS5hZGRUbyhtYXBfODMzN2Y4M2I4M2E4NDM4Yjg5ZGE3YmIyYWI3YWEyMGQpOwogICAgICAgIAogICAgCiAgICAgICAgZnVuY3Rpb24gZ2VvX2pzb25fMDg0Y2VkZjUxOWVhNGQxMWE4YTE5YzY1Zjk3YTgzMGVfb25FYWNoRmVhdHVyZShmZWF0dXJlLCBsYXllcikgewogICAgICAgICAgICBsYXllci5vbih7CiAgICAgICAgICAgICAgICBjbGljazogZnVuY3Rpb24oZSkgewogICAgICAgICAgICAgICAgICAgIG1hcF84MzM3ZjgzYjgzYTg0MzhiODlkYTdiYjJhYjdhYTIwZC5maXRCb3VuZHMoZS50YXJnZXQuZ2V0Qm91bmRzKCkpOwogICAgICAgICAgICAgICAgfQogICAgICAgICAgICB9KTsKICAgICAgICB9OwogICAgICAgIHZhciBnZW9fanNvbl8wODRjZWRmNTE5ZWE0ZDExYThhMTljNjVmOTdhODMwZSA9IEwuZ2VvSnNvbihudWxsLCB7CiAgICAgICAgICAgICAgICBvbkVhY2hGZWF0dXJlOiBnZW9fanNvbl8wODRjZWRmNTE5ZWE0ZDExYThhMTljNjVmOTdhODMwZV9vbkVhY2hGZWF0dXJlLAogICAgICAgICAgICAKICAgICAgICB9KTsKICAgICAgICBmdW5jdGlvbiBnZW9fanNvbl8wODRjZWRmNTE5ZWE0ZDExYThhMTljNjVmOTdhODMwZV9hZGQgKGRhdGEpIHsKICAgICAgICAgICAgZ2VvX2pzb25fMDg0Y2VkZjUxOWVhNGQxMWE4YTE5YzY1Zjk3YTgzMGUuYWRkRGF0YShkYXRhKQogICAgICAgICAgICAgICAgLmFkZFRvKG1hcF84MzM3ZjgzYjgzYTg0MzhiODlkYTdiYjJhYjdhYTIwZCk7CiAgICAgICAgfQogICAgICAgICAgICBnZW9fanNvbl8wODRjZWRmNTE5ZWE0ZDExYThhMTljNjVmOTdhODMwZV9hZGQoeyJiYm94IjogWy0xMDUuNTA0NDQsIDM5LjkzMTU5NywgLTEwNS4wNzU2OTUwMDAwMDAwMSwgNDAuMjYwODI3XSwgImZlYXR1cmVzIjogW3siYmJveCI6IFstMTA1LjE4NTc4OSwgNDAuMTg1MDMzLCAtMTA1LjE4NTc4OSwgNDAuMTg1MDMzXSwgImdlb21ldHJ5IjogeyJjb29yZGluYXRlcyI6IFstMTA1LjE4NTc4OSwgNDAuMTg1MDMzXSwgInR5cGUiOiAiUG9pbnQifSwgImlkIjogIjAiLCAicHJvcGVydGllcyI6IHsiYW1vdW50IjogIjAuMTQiLCAiY291bnR5IjogIkJPVUxERVIiLCAiZGF0YV9zb3VyY2UiOiAiQ29vcGVyYXRpdmUgUHJvZ3JhbSBvZiBDRFdSLCBOQ1dDRCBcdTAwMjYgU1ZMSFdDRCIsICJkYXRlX3RpbWUiOiAiMjAyMC0wMy0yNFQxNTowMDowMC4wMDAiLCAiZGl2IjogIjEiLCAiZHdyX2FiYnJldiI6ICJaV0VUVVJDTyIsICJmbGFnIjogbnVsbCwgImh0dHBfbGlua2FnZS51cmwiOiAiaHR0cHM6Ly9kd3Iuc3RhdGUuY28udXMvU3VyZmFjZVdhdGVyL2RhdGEvZGV0YWlsX2dyYXBoLmFzcHg/SUQ9WldFVFVSQ09cdTAwMjZNVFlQRT1ESVNDSFJHIiwgImxvY2F0aW9uLmxhdGl0dWRlIjogNDAuMTg1MDMzLCAibG9jYXRpb24ubG9uZ2l0dWRlIjogLTEwNS4xODU3ODksICJsb2NhdGlvbi5uZWVkc19yZWNvZGluZyI6IGZhbHNlLCAic3RhZ2UiOiAiMC4wNSIsICJzdGF0aW9uX25hbWUiOiAiWldFQ0sgQU5EIFRVUk5FUiBESVRDSCIsICJzdGF0aW9uX3N0YXR1cyI6ICJBY3RpdmUiLCAic3RhdGlvbl90eXBlIjogIkRpdmVyc2lvbiIsICJ1c2dzX3N0YXRpb25faWQiOiBudWxsLCAidmFyaWFibGUiOiAiRElTQ0hSRyIsICJ3ZCI6ICI1In0sICJ0eXBlIjogIkZlYXR1cmUifSwgeyJiYm94IjogWy0xMDUuMjYzNDksIDQwLjIyMDcwMiwgLTEwNS4yNjM0OSwgNDAuMjIwNzAyXSwgImdlb21ldHJ5IjogeyJjb29yZGluYXRlcyI6IFstMTA1LjI2MzQ5LCA0MC4yMjA3MDJdLCAidHlwZSI6ICJQb2ludCJ9LCAiaWQiOiAiMSIsICJwcm9wZXJ0aWVzIjogeyJhbW91bnQiOiAiMzkuMjAiLCAiY291bnR5IjogIkJPVUxERVIiLCAiZGF0YV9zb3VyY2UiOiAiQ28uIERpdmlzaW9uIG9mIFdhdGVyIFJlc291cmNlcyIsICJkYXRlX3RpbWUiOiAiMjAyMC0wMy0yNFQxNToxNTowMC4wMDAiLCAiZGl2IjogIjEiLCAiZHdyX2FiYnJldiI6ICJTVkNMWU9DTyIsICJmbGFnIjogbnVsbCwgImh0dHBfbGlua2FnZS51cmwiOiAiaHR0cHM6Ly9kd3Iuc3RhdGUuY28udXMvU3VyZmFjZVdhdGVyL2RhdGEvZGV0YWlsX2dyYXBoLmFzcHg/SUQ9U1ZDTFlPQ09cdTAwMjZNVFlQRT1ESVNDSFJHIiwgImxvY2F0aW9uLmxhdGl0dWRlIjogNDAuMjIwNzAyLCAibG9jYXRpb24ubG9uZ2l0dWRlIjogLTEwNS4yNjM0OSwgImxvY2F0aW9uLm5lZWRzX3JlY29kaW5nIjogZmFsc2UsICJzdGFnZSI6ICIyLjk3IiwgInN0YXRpb25fbmFtZSI6ICJTQUlOVCBWUkFJTiBDUkVFSyBBVCBMWU9OUywgQ08iLCAic3RhdGlvbl9zdGF0dXMiOiAiQWN0aXZlIiwgInN0YXRpb25fdHlwZSI6ICJTdHJlYW0iLCAidXNnc19zdGF0aW9uX2lkIjogIjA2NzI0MDAwIiwgInZhcmlhYmxlIjogIkRJU0NIUkciLCAid2QiOiAiNSJ9LCAidHlwZSI6ICJGZWF0dXJlIn0sIHsiYmJveCI6IFstMTA1LjIwNjU5MiwgNDAuMTk2NDIyLCAtMTA1LjIwNjU5MiwgNDAuMTk2NDIyXSwgImdlb21ldHJ5IjogeyJjb29yZGluYXRlcyI6IFstMTA1LjIwNjU5MiwgNDAuMTk2NDIyXSwgInR5cGUiOiAiUG9pbnQifSwgImlkIjogIjIiLCAicHJvcGVydGllcyI6IHsiYW1vdW50IjogIjMuNzUiLCAiY291bnR5IjogIkJPVUxERVIiLCAiZGF0YV9zb3VyY2UiOiAiQ29vcGVyYXRpdmUgUHJvZ3JhbSBvZiBDRFdSLCBOQ1dDRCBcdTAwMjYgU1ZMSFdDRCIsICJkYXRlX3RpbWUiOiAiMjAyMC0wMy0yNFQxMzo0NTowMC4wMDAiLCAiZGl2IjogIjEiLCAiZHdyX2FiYnJldiI6ICJPTElESVRDTyIsICJmbGFnIjogbnVsbCwgImh0dHBfbGlua2FnZS51cmwiOiAiaHR0cHM6Ly9kd3Iuc3RhdGUuY28udXMvU3VyZmFjZVdhdGVyL2RhdGEvZGV0YWlsX2dyYXBoLmFzcHg/SUQ9T0xJRElUQ09cdTAwMjZNVFlQRT1ESVNDSFJHIiwgImxvY2F0aW9uLmxhdGl0dWRlIjogNDAuMTk2NDIyLCAibG9jYXRpb24ubG9uZ2l0dWRlIjogLTEwNS4yMDY1OTIsICJsb2NhdGlvbi5uZWVkc19yZWNvZGluZyI6IGZhbHNlLCAic3RhZ2UiOiAiMC4yMyIsICJzdGF0aW9uX25hbWUiOiAiT0xJR0FSQ0hZIERJVENIIERJVkVSU0lPTiIsICJzdGF0aW9uX3N0YXR1cyI6ICJBY3RpdmUiLCAic3RhdGlvbl90eXBlIjogIkRpdmVyc2lvbiIsICJ1c2dzX3N0YXRpb25faWQiOiBudWxsLCAidmFyaWFibGUiOiAiRElTQ0hSRyIsICJ3ZCI6ICI1In0sICJ0eXBlIjogIkZlYXR1cmUifSwgeyJiYm94IjogWy0xMDUuMzA4NDMyLCAzOS45MzE4MTMsIC0xMDUuMzA4NDMyLCAzOS45MzE4MTNdLCAiZ2VvbWV0cnkiOiB7ImNvb3JkaW5hdGVzIjogWy0xMDUuMzA4NDMyLCAzOS45MzE4MTNdLCAidHlwZSI6ICJQb2ludCJ9LCAiaWQiOiAiMyIsICJwcm9wZXJ0aWVzIjogeyJhbW91bnQiOiAiMC4wMCIsICJjb3VudHkiOiAiQk9VTERFUiIsICJkYXRhX3NvdXJjZSI6ICJDby4gRGl2aXNpb24gb2YgV2F0ZXIgUmVzb3VyY2VzIiwgImRhdGVfdGltZSI6ICIyMDIwLTAzLTI0VDE1OjMwOjAwLjAwMCIsICJkaXYiOiAiMSIsICJkd3JfYWJicmV2IjogIkJPU0RFTENPIiwgImZsYWciOiBudWxsLCAiaHR0cF9saW5rYWdlLnVybCI6ICJodHRwczovL2R3ci5zdGF0ZS5jby51cy9TdXJmYWNlV2F0ZXIvZGF0YS9kZXRhaWxfZ3JhcGguYXNweD9JRD1CT1NERUxDT1x1MDAyNk1UWVBFPURJU0NIUkciLCAibG9jYXRpb24ubGF0aXR1ZGUiOiAzOS45MzE4MTMsICJsb2NhdGlvbi5sb25naXR1ZGUiOiAtMTA1LjMwODQzMiwgImxvY2F0aW9uLm5lZWRzX3JlY29kaW5nIjogZmFsc2UsICJzdGFnZSI6ICItMS43MCIsICJzdGF0aW9uX25hbWUiOiAiU09VVEggQk9VTERFUiBDUkVFSyBESVZFUlNJT04gTkVBUiBFTERPUkFETyBTUFJJTkdTIiwgInN0YXRpb25fc3RhdHVzIjogIkFjdGl2ZSIsICJzdGF0aW9uX3R5cGUiOiAiRGl2ZXJzaW9uIiwgInVzZ3Nfc3RhdGlvbl9pZCI6IG51bGwsICJ2YXJpYWJsZSI6ICJESVNDSFJHIiwgIndkIjogIjYifSwgInR5cGUiOiAiRmVhdHVyZSJ9LCB7ImJib3giOiBbLTEwNS4yMTAzOSwgNDAuMTkzNzU4LCAtMTA1LjIxMDM5LCA0MC4xOTM3NThdLCAiZ2VvbWV0cnkiOiB7ImNvb3JkaW5hdGVzIjogWy0xMDUuMjEwMzksIDQwLjE5Mzc1OF0sICJ0eXBlIjogIlBvaW50In0sICJpZCI6ICI0IiwgInByb3BlcnRpZXMiOiB7ImFtb3VudCI6ICIwLjAwIiwgImNvdW50eSI6ICJCT1VMREVSIiwgImRhdGFfc291cmNlIjogIkNvb3BlcmF0aXZlIFByb2dyYW0gb2YgQ0RXUiwgTkNXQ0QgXHUwMDI2IFNWTEhXQ0QiLCAiZGF0ZV90aW1lIjogIjIwMjAtMDMtMjRUMTU6MDA6MDAuMDAwIiwgImRpdiI6ICIxIiwgImR3cl9hYmJyZXYiOiAiQ0xPRElUQ08iLCAiZmxhZyI6IG51bGwsICJodHRwX2xpbmthZ2UudXJsIjogImh0dHBzOi8vZHdyLnN0YXRlLmNvLnVzL1N1cmZhY2VXYXRlci9kYXRhL2RldGFpbF9ncmFwaC5hc3B4P0lEPUNMT0RJVENPXHUwMDI2TVRZUEU9RElTQ0hSRyIsICJsb2NhdGlvbi5sYXRpdHVkZSI6IDQwLjE5Mzc1OCwgImxvY2F0aW9uLmxvbmdpdHVkZSI6IC0xMDUuMjEwMzksICJsb2NhdGlvbi5uZWVkc19yZWNvZGluZyI6IGZhbHNlLCAic3RhZ2UiOiBudWxsLCAic3RhdGlvbl9uYW1lIjogIkNMT1VHSCBBTkQgVFJVRSBESVRDSCIsICJzdGF0aW9uX3N0YXR1cyI6ICJBY3RpdmUiLCAic3RhdGlvbl90eXBlIjogIkRpdmVyc2lvbiIsICJ1c2dzX3N0YXRpb25faWQiOiBudWxsLCAidmFyaWFibGUiOiAiRElTQ0hSRyIsICJ3ZCI6ICI1In0sICJ0eXBlIjogIkZlYXR1cmUifSwgeyJiYm94IjogWy0xMDUuMzMwODQxLCA0MC4wMDYzODAwMDAwMDAwMSwgLTEwNS4zMzA4NDEsIDQwLjAwNjM4MDAwMDAwMDAxXSwgImdlb21ldHJ5IjogeyJjb29yZGluYXRlcyI6IFstMTA1LjMzMDg0MSwgNDAuMDA2MzgwMDAwMDAwMDFdLCAidHlwZSI6ICJQb2ludCJ9LCAiaWQiOiAiNSIsICJwcm9wZXJ0aWVzIjogeyJhbW91bnQiOiAiMjAuNDAiLCAiY291bnR5IjogIkJPVUxERVIiLCAiZGF0YV9zb3VyY2UiOiAiQ28uIERpdmlzaW9uIG9mIFdhdGVyIFJlc291cmNlcyIsICJkYXRlX3RpbWUiOiAiMjAyMC0wMy0yNFQxNToxNTowMC4wMDAiLCAiZGl2IjogIjEiLCAiZHdyX2FiYnJldiI6ICJCT0NPUk9DTyIsICJmbGFnIjogIkljZSIsICJodHRwX2xpbmthZ2UudXJsIjogImh0dHBzOi8vZHdyLnN0YXRlLmNvLnVzL1N1cmZhY2VXYXRlci9kYXRhL2RldGFpbF9ncmFwaC5hc3B4P0lEPUJPQ09ST0NPXHUwMDI2TVRZUEU9RElTQ0hSRyIsICJsb2NhdGlvbi5sYXRpdHVkZSI6IDQwLjAwNjM4LCAibG9jYXRpb24ubG9uZ2l0dWRlIjogLTEwNS4zMzA4NDEsICJsb2NhdGlvbi5uZWVkc19yZWNvZGluZyI6IGZhbHNlLCAic3RhZ2UiOiAiMS44NCIsICJzdGF0aW9uX25hbWUiOiAiQk9VTERFUiBDUkVFSyBORUFSIE9ST0RFTEwsIENPLiIsICJzdGF0aW9uX3N0YXR1cyI6ICJBY3RpdmUiLCAic3RhdGlvbl90eXBlIjogIlN0cmVhbSIsICJ1c2dzX3N0YXRpb25faWQiOiAiMDY3MjcwMDAiLCAidmFyaWFibGUiOiAiRElTQ0hSRyIsICJ3ZCI6ICI2In0sICJ0eXBlIjogIkZlYXR1cmUifSwgeyJiYm94IjogWy0xMDUuMjE4Nzc3LCA0MC4yMDQxOTMsIC0xMDUuMjE4Nzc3LCA0MC4yMDQxOTNdLCAiZ2VvbWV0cnkiOiB7ImNvb3JkaW5hdGVzIjogWy0xMDUuMjE4Nzc3LCA0MC4yMDQxOTNdLCAidHlwZSI6ICJQb2ludCJ9LCAiaWQiOiAiNiIsICJwcm9wZXJ0aWVzIjogeyJhbW91bnQiOiAiMC4wMCIsICJjb3VudHkiOiAiQk9VTERFUiIsICJkYXRhX3NvdXJjZSI6ICJDb29wZXJhdGl2ZSBQcm9ncmFtIG9mIENEV1IsIE5DV0NEIFx1MDAyNiBTVkxIV0NEIiwgImRhdGVfdGltZSI6ICIyMDIwLTAzLTI0VDE1OjAwOjAwLjAwMCIsICJkaXYiOiAiMSIsICJkd3JfYWJicmV2IjogIkxPTlNVUENPIiwgImZsYWciOiBudWxsLCAiaHR0cF9saW5rYWdlLnVybCI6ICJodHRwczovL2R3ci5zdGF0ZS5jby51cy9TdXJmYWNlV2F0ZXIvZGF0YS9kZXRhaWxfZ3JhcGguYXNweD9JRD1MT05TVVBDT1x1MDAyNk1UWVBFPURJU0NIUkciLCAibG9jYXRpb24ubGF0aXR1ZGUiOiA0MC4yMDQxOTMsICJsb2NhdGlvbi5sb25naXR1ZGUiOiAtMTA1LjIxODc3NywgImxvY2F0aW9uLm5lZWRzX3JlY29kaW5nIjogZmFsc2UsICJzdGFnZSI6IG51bGwsICJzdGF0aW9uX25hbWUiOiAiTE9OR01PTlQgU1VQUExZIERJVENIIiwgInN0YXRpb25fc3RhdHVzIjogIkFjdGl2ZSIsICJzdGF0aW9uX3R5cGUiOiAiRGl2ZXJzaW9uIiwgInVzZ3Nfc3RhdGlvbl9pZCI6IG51bGwsICJ2YXJpYWJsZSI6ICJESVNDSFJHIiwgIndkIjogIjUifSwgInR5cGUiOiAiRmVhdHVyZSJ9LCB7ImJib3giOiBbLTEwNS4xNjc2MjIsIDQwLjE3MjkyNSwgLTEwNS4xNjc2MjIsIDQwLjE3MjkyNV0sICJnZW9tZXRyeSI6IHsiY29vcmRpbmF0ZXMiOiBbLTEwNS4xNjc2MjIsIDQwLjE3MjkyNV0sICJ0eXBlIjogIlBvaW50In0sICJpZCI6ICI3IiwgInByb3BlcnRpZXMiOiB7ImFtb3VudCI6ICIwLjAwIiwgImNvdW50eSI6ICJCT1VMREVSIiwgImRhdGFfc291cmNlIjogIkNvb3BlcmF0aXZlIFNEUiBQcm9ncmFtIG9mIENEV1IgXHUwMDI2IE5DV0NEIiwgImRhdGVfdGltZSI6ICIyMDIwLTAzLTI0VDE1OjAwOjAwLjAwMCIsICJkaXYiOiAiMSIsICJkd3JfYWJicmV2IjogIk5PUk1VVENPIiwgImZsYWciOiBudWxsLCAiaHR0cF9saW5rYWdlLnVybCI6ICJodHRwczovL2R3ci5zdGF0ZS5jby51cy9TdXJmYWNlV2F0ZXIvZGF0YS9kZXRhaWxfZ3JhcGguYXNweD9JRD1OT1JNVVRDT1x1MDAyNk1UWVBFPURJU0NIUkciLCAibG9jYXRpb24ubGF0aXR1ZGUiOiA0MC4xNzI5MjUsICJsb2NhdGlvbi5sb25naXR1ZGUiOiAtMTA1LjE2NzYyMiwgImxvY2F0aW9uLm5lZWRzX3JlY29kaW5nIjogZmFsc2UsICJzdGFnZSI6IG51bGwsICJzdGF0aW9uX25hbWUiOiAiTk9SVEhXRVNUIE1VVFVBTCBESVRDSCIsICJzdGF0aW9uX3N0YXR1cyI6ICJBY3RpdmUiLCAic3RhdGlvbl90eXBlIjogIkRpdmVyc2lvbiIsICJ1c2dzX3N0YXRpb25faWQiOiBudWxsLCAidmFyaWFibGUiOiAiRElTQ0hSRyIsICJ3ZCI6ICI1In0sICJ0eXBlIjogIkZlYXR1cmUifSwgeyJiYm94IjogWy0xMDUuMTMwODE5LCA0MC4xMzQyNzgsIC0xMDUuMTMwODE5LCA0MC4xMzQyNzhdLCAiZ2VvbWV0cnkiOiB7ImNvb3JkaW5hdGVzIjogWy0xMDUuMTMwODE5LCA0MC4xMzQyNzhdLCAidHlwZSI6ICJQb2ludCJ9LCAiaWQiOiAiOCIsICJwcm9wZXJ0aWVzIjogeyJhbW91bnQiOiAiMy4zNCIsICJjb3VudHkiOiAiQk9VTERFUiIsICJkYXRhX3NvdXJjZSI6ICJVLlMuIEdlb2xvZ2ljYWwgU3VydmV5IiwgImRhdGVfdGltZSI6ICIyMDIwLTAzLTI0VDE1OjEwOjAwLjAwMCIsICJkaXYiOiAiMSIsICJkd3JfYWJicmV2IjogIkxFRlRIT0NPIiwgImZsYWciOiBudWxsLCAiaHR0cF9saW5rYWdlLnVybCI6ICJodHRwczovL3dhdGVyZGF0YS51c2dzLmdvdi9ud2lzL3V2PzA2NzI0OTcwIiwgImxvY2F0aW9uLmxhdGl0dWRlIjogNDAuMTM0Mjc4LCAibG9jYXRpb24ubG9uZ2l0dWRlIjogLTEwNS4xMzA4MTksICJsb2NhdGlvbi5uZWVkc19yZWNvZGluZyI6IGZhbHNlLCAic3RhZ2UiOiBudWxsLCAic3RhdGlvbl9uYW1lIjogIkxFRlQgSEFORCBDUkVFSyBBVCBIT1ZFUiBST0FEIE5FQVIgTE9OR01PTlQsIENPIiwgInN0YXRpb25fc3RhdHVzIjogIkFjdGl2ZSIsICJzdGF0aW9uX3R5cGUiOiAiU3RyZWFtIiwgInVzZ3Nfc3RhdGlvbl9pZCI6ICIwNjcyNDk3MCIsICJ2YXJpYWJsZSI6ICJESVNDSFJHIiwgIndkIjogIjUifSwgInR5cGUiOiAiRmVhdHVyZSJ9LCB7ImJib3giOiBbLTEwNS4yMTg2NzcsIDM5Ljk4NjE2OSwgLTEwNS4yMTg2NzcsIDM5Ljk4NjE2OV0sICJnZW9tZXRyeSI6IHsiY29vcmRpbmF0ZXMiOiBbLTEwNS4yMTg2NzcsIDM5Ljk4NjE2OV0sICJ0eXBlIjogIlBvaW50In0sICJpZCI6ICI5IiwgInByb3BlcnRpZXMiOiB7ImFtb3VudCI6ICIwLjAwIiwgImNvdW50eSI6ICJCT1VMREVSIiwgImRhdGFfc291cmNlIjogIkNvb3BlcmF0aXZlIFByb2dyYW0gb2YgQ0RXUiwgTkNXQ0QgXHUwMDI2IExTUFdDRCIsICJkYXRlX3RpbWUiOiAiMjAyMC0wMy0yNFQxNDowMDowMC4wMDAiLCAiZGl2IjogIjEiLCAiZHdyX2FiYnJldiI6ICJEUllDQVJDTyIsICJmbGFnIjogbnVsbCwgImh0dHBfbGlua2FnZS51cmwiOiAiaHR0cHM6Ly9kd3Iuc3RhdGUuY28udXMvU3VyZmFjZVdhdGVyL2RhdGEvZGV0YWlsX2dyYXBoLmFzcHg/SUQ9RFJZQ0FSQ09cdTAwMjZNVFlQRT1ESVNDSFJHIiwgImxvY2F0aW9uLmxhdGl0dWRlIjogMzkuOTg2MTY5LCAibG9jYXRpb24ubG9uZ2l0dWRlIjogLTEwNS4yMTg2NzcsICJsb2NhdGlvbi5uZWVkc19yZWNvZGluZyI6IGZhbHNlLCAic3RhZ2UiOiBudWxsLCAic3RhdGlvbl9uYW1lIjogIkRSWSBDUkVFSyBDQVJSSUVSIiwgInN0YXRpb25fc3RhdHVzIjogIkFjdGl2ZSIsICJzdGF0aW9uX3R5cGUiOiAiRGl2ZXJzaW9uIiwgInVzZ3Nfc3RhdGlvbl9pZCI6IG51bGwsICJ2YXJpYWJsZSI6ICJESVNDSFJHIiwgIndkIjogIjYifSwgInR5cGUiOiAiRmVhdHVyZSJ9LCB7ImJib3giOiBbLTEwNS4xNjg0NzEsIDQwLjE2MDcwNSwgLTEwNS4xNjg0NzEsIDQwLjE2MDcwNV0sICJnZW9tZXRyeSI6IHsiY29vcmRpbmF0ZXMiOiBbLTEwNS4xNjg0NzEsIDQwLjE2MDcwNV0sICJ0eXBlIjogIlBvaW50In0sICJpZCI6ICIxMCIsICJwcm9wZXJ0aWVzIjogeyJhbW91bnQiOiAiMC4wMCIsICJjb3VudHkiOiAiQk9VTERFUiIsICJkYXRhX3NvdXJjZSI6ICJDby4gRGl2aXNpb24gb2YgV2F0ZXIgUmVzb3VyY2VzIiwgImRhdGVfdGltZSI6ICIyMDIwLTAzLTI0VDEzOjQ1OjAwLjAwMCIsICJkaXYiOiAiMSIsICJkd3JfYWJicmV2IjogIlBFQ1JUTkNPIiwgImZsYWciOiBudWxsLCAiaHR0cF9saW5rYWdlLnVybCI6ICJodHRwczovL2R3ci5zdGF0ZS5jby51cy9TdXJmYWNlV2F0ZXIvZGF0YS9kZXRhaWxfZ3JhcGguYXNweD9JRD1QRUNSVE5DT1x1MDAyNk1UWVBFPURJU0NIUkciLCAibG9jYXRpb24ubGF0aXR1ZGUiOiA0MC4xNjA3MDUsICJsb2NhdGlvbi5sb25naXR1ZGUiOiAtMTA1LjE2ODQ3MSwgImxvY2F0aW9uLm5lZWRzX3JlY29kaW5nIjogZmFsc2UsICJzdGFnZSI6IG51bGwsICJzdGF0aW9uX25hbWUiOiAiUEVDSy1QRUxMQSBBVUdNRU5UQVRJT04gUkVUVVJOIiwgInN0YXRpb25fc3RhdHVzIjogIkFjdGl2ZSIsICJzdGF0aW9uX3R5cGUiOiAiRGl2ZXJzaW9uIiwgInVzZ3Nfc3RhdGlvbl9pZCI6IG51bGwsICJ2YXJpYWJsZSI6ICJESVNDSFJHIiwgIndkIjogIjUifSwgInR5cGUiOiAiRmVhdHVyZSJ9LCB7ImJib3giOiBbLTEwNS4yMjI2MzksIDQwLjE5OTMyMSwgLTEwNS4yMjI2MzksIDQwLjE5OTMyMV0sICJnZW9tZXRyeSI6IHsiY29vcmRpbmF0ZXMiOiBbLTEwNS4yMjI2MzksIDQwLjE5OTMyMV0sICJ0eXBlIjogIlBvaW50In0sICJpZCI6ICIxMSIsICJwcm9wZXJ0aWVzIjogeyJhbW91bnQiOiAiMC4wMCIsICJjb3VudHkiOiAiQk9VTERFUiIsICJkYXRhX3NvdXJjZSI6ICJDb29wZXJhdGl2ZSBQcm9ncmFtIG9mIENEV1IsIE5DV0NEIFx1MDAyNiBTVkxIV0NEIiwgImRhdGVfdGltZSI6ICIyMDIwLTAzLTI0VDE0OjQ1OjAwLjAwMCIsICJkaXYiOiAiMSIsICJkd3JfYWJicmV2IjogIkdPRElUMUNPIiwgImZsYWciOiBudWxsLCAiaHR0cF9saW5rYWdlLnVybCI6ICJodHRwczovL2R3ci5zdGF0ZS5jby51cy9TdXJmYWNlV2F0ZXIvZGF0YS9kZXRhaWxfZ3JhcGguYXNweD9JRD1HT0RJVDFDT1x1MDAyNk1UWVBFPURJU0NIUkciLCAibG9jYXRpb24ubGF0aXR1ZGUiOiA0MC4xOTkzMjEsICJsb2NhdGlvbi5sb25naXR1ZGUiOiAtMTA1LjIyMjYzOSwgImxvY2F0aW9uLm5lZWRzX3JlY29kaW5nIjogZmFsc2UsICJzdGFnZSI6IG51bGwsICJzdGF0aW9uX25hbWUiOiAiR09TUyBESVRDSCAxIiwgInN0YXRpb25fc3RhdHVzIjogIkFjdGl2ZSIsICJzdGF0aW9uX3R5cGUiOiAiRGl2ZXJzaW9uIiwgInVzZ3Nfc3RhdGlvbl9pZCI6IG51bGwsICJ2YXJpYWJsZSI6ICJESVNDSFJHIiwgIndkIjogIjUifSwgInR5cGUiOiAiRmVhdHVyZSJ9LCB7ImJib3giOiBbLTEwNS4yMTA0MjQsIDQwLjE5MzI4MDAwMDAwMDAxLCAtMTA1LjIxMDQyNCwgNDAuMTkzMjgwMDAwMDAwMDFdLCAiZ2VvbWV0cnkiOiB7ImNvb3JkaW5hdGVzIjogWy0xMDUuMjEwNDI0LCA0MC4xOTMyODAwMDAwMDAwMV0sICJ0eXBlIjogIlBvaW50In0sICJpZCI6ICIxMiIsICJwcm9wZXJ0aWVzIjogeyJhbW91bnQiOiAiMC4wMCIsICJjb3VudHkiOiAiQk9VTERFUiIsICJkYXRhX3NvdXJjZSI6ICJDb29wZXJhdGl2ZSBQcm9ncmFtIG9mIENEV1IsIE5DV0NEIFx1MDAyNiBTVkxIV0NEIiwgImRhdGVfdGltZSI6ICIyMDIwLTAzLTI0VDE1OjAwOjAwLjAwMCIsICJkaXYiOiAiMSIsICJkd3JfYWJicmV2IjogIldFQkRJVENPIiwgImZsYWciOiBudWxsLCAiaHR0cF9saW5rYWdlLnVybCI6ICJodHRwczovL2R3ci5zdGF0ZS5jby51cy9TdXJmYWNlV2F0ZXIvZGF0YS9kZXRhaWxfZ3JhcGguYXNweD9JRD1XRUJESVRDT1x1MDAyNk1UWVBFPURJU0NIUkciLCAibG9jYXRpb24ubGF0aXR1ZGUiOiA0MC4xOTMyOCwgImxvY2F0aW9uLmxvbmdpdHVkZSI6IC0xMDUuMjEwNDI0LCAibG9jYXRpb24ubmVlZHNfcmVjb2RpbmciOiBmYWxzZSwgInN0YWdlIjogbnVsbCwgInN0YXRpb25fbmFtZSI6ICJXRUJTVEVSIE1DQ0FTTElOIERJVENIIiwgInN0YXRpb25fc3RhdHVzIjogIkFjdGl2ZSIsICJzdGF0aW9uX3R5cGUiOiAiRGl2ZXJzaW9uIiwgInVzZ3Nfc3RhdGlvbl9pZCI6IG51bGwsICJ2YXJpYWJsZSI6ICJESVNDSFJHIiwgIndkIjogIjUifSwgInR5cGUiOiAiRmVhdHVyZSJ9LCB7ImJib3giOiBbLTEwNS4xNTExNDMsIDQwLjA1MzY2MSwgLTEwNS4xNTExNDMsIDQwLjA1MzY2MV0sICJnZW9tZXRyeSI6IHsiY29vcmRpbmF0ZXMiOiBbLTEwNS4xNTExNDMsIDQwLjA1MzY2MV0sICJ0eXBlIjogIlBvaW50In0sICJpZCI6ICIxMyIsICJwcm9wZXJ0aWVzIjogeyJhbW91bnQiOiAiMi42MyIsICJjb3VudHkiOiAiQk9VTERFUiIsICJkYXRhX3NvdXJjZSI6ICJDb29wZXJhdGl2ZSBQcm9ncmFtIG9mIENEV1IsIE5DV0NEIFx1MDAyNiBMU1BXQ0QiLCAiZGF0ZV90aW1lIjogIjIwMjAtMDMtMjRUMTU6MDA6MDAuMDAwIiwgImRpdiI6ICIxIiwgImR3cl9hYmJyZXYiOiAiTEVHRElUQ08iLCAiZmxhZyI6IG51bGwsICJodHRwX2xpbmthZ2UudXJsIjogImh0dHBzOi8vZHdyLnN0YXRlLmNvLnVzL1N1cmZhY2VXYXRlci9kYXRhL2RldGFpbF9ncmFwaC5hc3B4P0lEPUxFR0RJVENPXHUwMDI2TVRZUEU9RElTQ0hSRyIsICJsb2NhdGlvbi5sYXRpdHVkZSI6IDQwLjA1MzY2MSwgImxvY2F0aW9uLmxvbmdpdHVkZSI6IC0xMDUuMTUxMTQzLCAibG9jYXRpb24ubmVlZHNfcmVjb2RpbmciOiBmYWxzZSwgInN0YWdlIjogIjAuMjEiLCAic3RhdGlvbl9uYW1lIjogIkxFR0dFVFQgRElUQ0giLCAic3RhdGlvbl9zdGF0dXMiOiAiQWN0aXZlIiwgInN0YXRpb25fdHlwZSI6ICJEaXZlcnNpb24iLCAidXNnc19zdGF0aW9uX2lkIjogbnVsbCwgInZhcmlhYmxlIjogIkRJU0NIUkciLCAid2QiOiAiNiJ9LCAidHlwZSI6ICJGZWF0dXJlIn0sIHsiYmJveCI6IFstMTA1LjM2NTM2NSwgNDAuMjE2MjYzLCAtMTA1LjM2NTM2NSwgNDAuMjE2MjYzXSwgImdlb21ldHJ5IjogeyJjb29yZGluYXRlcyI6IFstMTA1LjM2NTM2NSwgNDAuMjE2MjYzXSwgInR5cGUiOiAiUG9pbnQifSwgImlkIjogIjE0IiwgInByb3BlcnRpZXMiOiB7ImFtb3VudCI6ICIxMjg4Ni4wMCIsICJjb3VudHkiOiAiQk9VTERFUiIsICJkYXRhX3NvdXJjZSI6ICJDby4gRGl2aXNpb24gb2YgV2F0ZXIgUmVzb3VyY2VzIiwgImRhdGVfdGltZSI6ICIyMDIwLTAzLTI0VDE1OjQ1OjAwLjAwMCIsICJkaXYiOiAiMSIsICJkd3JfYWJicmV2IjogIkJSS0RBTUNPIiwgImZsYWciOiBudWxsLCAiaHR0cF9saW5rYWdlLnVybCI6ICJodHRwczovL2R3ci5zdGF0ZS5jby51cy9TdXJmYWNlV2F0ZXIvZGF0YS9kZXRhaWxfZ3JhcGguYXNweD9JRD1CUktEQU1DT1x1MDAyNk1UWVBFPVNUT1JBR0UiLCAibG9jYXRpb24ubGF0aXR1ZGUiOiA0MC4yMTYyNjMsICJsb2NhdGlvbi5sb25naXR1ZGUiOiAtMTA1LjM2NTM2NSwgImxvY2F0aW9uLm5lZWRzX3JlY29kaW5nIjogZmFsc2UsICJzdGFnZSI6ICI2Mzg0LjA0IiwgInN0YXRpb25fbmFtZSI6ICJCVVRUT05ST0NLIChSQUxQSCBQUklDRSkgUkVTRVJWT0lSIiwgInN0YXRpb25fc3RhdHVzIjogIkFjdGl2ZSIsICJzdGF0aW9uX3R5cGUiOiAiUmVzZXJ2b2lyIiwgInVzZ3Nfc3RhdGlvbl9pZCI6IG51bGwsICJ2YXJpYWJsZSI6ICJTVE9SQUdFIiwgIndkIjogIjUifSwgInR5cGUiOiAiRmVhdHVyZSJ9LCB7ImJib3giOiBbLTEwNS4yMDk1LCA0MC4yNTU3NzYsIC0xMDUuMjA5NSwgNDAuMjU1Nzc2XSwgImdlb21ldHJ5IjogeyJjb29yZGluYXRlcyI6IFstMTA1LjIwOTUsIDQwLjI1NTc3Nl0sICJ0eXBlIjogIlBvaW50In0sICJpZCI6ICIxNSIsICJwcm9wZXJ0aWVzIjogeyJhbW91bnQiOiAiMC4xMCIsICJjb3VudHkiOiAiQk9VTERFUiIsICJkYXRhX3NvdXJjZSI6ICJOb3J0aGVybiBDb2xvcmFkbyBXYXRlciBDb25zZXJ2YW5jeSBEaXN0cmljdCIsICJkYXRlX3RpbWUiOiAiMjAyMC0wMy0yNFQxNTowMDowMC4wMDAiLCAiZGl2IjogIjEiLCAiZHdyX2FiYnJldiI6ICJMSVRUSDJDTyIsICJmbGFnIjogbnVsbCwgImh0dHBfbGlua2FnZS51cmwiOiAiaHR0cDovL3d3dy5ub3J0aGVybndhdGVyLm9yZy9XYXRlclByb2plY3RzL1dhdGVyRGF0YS5hc3B4RWFzdFNsb3BlV2F0ZXJEYXRhLmFzcHgiLCAibG9jYXRpb24ubGF0aXR1ZGUiOiA0MC4yNTU3NzYsICJsb2NhdGlvbi5sb25naXR1ZGUiOiAtMTA1LjIwOTUsICJsb2NhdGlvbi5uZWVkc19yZWNvZGluZyI6IGZhbHNlLCAic3RhZ2UiOiAiMC4xMCIsICJzdGF0aW9uX25hbWUiOiAiTElUVExFIFRIT01QU09OICMyIERJVENIIiwgInN0YXRpb25fc3RhdHVzIjogIkFjdGl2ZSIsICJzdGF0aW9uX3R5cGUiOiAiRGl2ZXJzaW9uIiwgInVzZ3Nfc3RhdGlvbl9pZCI6ICJFUzE5MDAiLCAidmFyaWFibGUiOiAiRElTQ0hSRyIsICJ3ZCI6ICI0In0sICJ0eXBlIjogIkZlYXR1cmUifSwgeyJiYm94IjogWy0xMDUuMTY0Mzk3LCA0MC4yNTc4NDQsIC0xMDUuMTY0Mzk3LCA0MC4yNTc4NDRdLCAiZ2VvbWV0cnkiOiB7ImNvb3JkaW5hdGVzIjogWy0xMDUuMTY0Mzk3LCA0MC4yNTc4NDRdLCAidHlwZSI6ICJQb2ludCJ9LCAiaWQiOiAiMTYiLCAicHJvcGVydGllcyI6IHsiYW1vdW50IjogIjAuMDEiLCAiY291bnR5IjogIkJPVUxERVIiLCAiZGF0YV9zb3VyY2UiOiAiQ29vcGVyYXRpdmUgU0RSIFByb2dyYW0gb2YgQ0RXUiBcdTAwMjYgTkNXQ0QiLCAiZGF0ZV90aW1lIjogIjIwMjAtMDMtMjRUMTU6MDA6MDAuMDAwIiwgImRpdiI6ICIxIiwgImR3cl9hYmJyZXYiOiAiQkxXRElUQ08iLCAiZmxhZyI6IG51bGwsICJodHRwX2xpbmthZ2UudXJsIjogImh0dHBzOi8vZHdyLnN0YXRlLmNvLnVzL1N1cmZhY2VXYXRlci9kYXRhL2RldGFpbF9ncmFwaC5hc3B4P0lEPUJMV0RJVENPXHUwMDI2TVRZUEU9RElTQ0hSRyIsICJsb2NhdGlvbi5sYXRpdHVkZSI6IDQwLjI1Nzg0NCwgImxvY2F0aW9uLmxvbmdpdHVkZSI6IC0xMDUuMTY0Mzk3LCAibG9jYXRpb24ubmVlZHNfcmVjb2RpbmciOiBmYWxzZSwgInN0YWdlIjogIjAuMDMiLCAic3RhdGlvbl9uYW1lIjogIkJMT1dFUiBESVRDSCIsICJzdGF0aW9uX3N0YXR1cyI6ICJBY3RpdmUiLCAic3RhdGlvbl90eXBlIjogIkRpdmVyc2lvbiIsICJ1c2dzX3N0YXRpb25faWQiOiBudWxsLCAidmFyaWFibGUiOiAiRElTQ0hSRyIsICJ3ZCI6ICI0In0sICJ0eXBlIjogIkZlYXR1cmUifSwgeyJiYm94IjogWy0xMDUuMzA0OTksIDM5LjkzMTU5NywgLTEwNS4zMDQ5OSwgMzkuOTMxNTk3XSwgImdlb21ldHJ5IjogeyJjb29yZGluYXRlcyI6IFstMTA1LjMwNDk5LCAzOS45MzE1OTddLCAidHlwZSI6ICJQb2ludCJ9LCAiaWQiOiAiMTciLCAicHJvcGVydGllcyI6IHsiYW1vdW50IjogIjE3LjIwIiwgImNvdW50eSI6ICJCT1VMREVSIiwgImRhdGFfc291cmNlIjogIkNvLiBEaXZpc2lvbiBvZiBXYXRlciBSZXNvdXJjZXMiLCAiZGF0ZV90aW1lIjogIjIwMjAtMDMtMjRUMTU6MTU6MDAuMDAwIiwgImRpdiI6ICIxIiwgImR3cl9hYmJyZXYiOiAiQk9DRUxTQ08iLCAiZmxhZyI6ICJJY2UiLCAiaHR0cF9saW5rYWdlLnVybCI6ICJodHRwczovL2R3ci5zdGF0ZS5jby51cy9TdXJmYWNlV2F0ZXIvZGF0YS9kZXRhaWxfZ3JhcGguYXNweD9JRD1CT0NFTFNDT1x1MDAyNk1UWVBFPURJU0NIUkciLCAibG9jYXRpb24ubGF0aXR1ZGUiOiAzOS45MzE1OTcsICJsb2NhdGlvbi5sb25naXR1ZGUiOiAtMTA1LjMwNDk5LCAibG9jYXRpb24ubmVlZHNfcmVjb2RpbmciOiBmYWxzZSwgInN0YWdlIjogIjIuMjMiLCAic3RhdGlvbl9uYW1lIjogIlNPVVRIIEJPVUxERVIgQ1JFRUsgTkVBUiBFTERPUkFETyBTUFJJTkdTLCBDTy4iLCAic3RhdGlvbl9zdGF0dXMiOiAiQWN0aXZlIiwgInN0YXRpb25fdHlwZSI6ICJTdHJlYW0iLCAidXNnc19zdGF0aW9uX2lkIjogbnVsbCwgInZhcmlhYmxlIjogIkRJU0NIUkciLCAid2QiOiAiNiJ9LCAidHlwZSI6ICJGZWF0dXJlIn0sIHsiYmJveCI6IFstMTA1LjE3ODg3NSwgNDAuMDUxNjUyLCAtMTA1LjE3ODg3NSwgNDAuMDUxNjUyXSwgImdlb21ldHJ5IjogeyJjb29yZGluYXRlcyI6IFstMTA1LjE3ODg3NSwgNDAuMDUxNjUyXSwgInR5cGUiOiAiUG9pbnQifSwgImlkIjogIjE4IiwgInByb3BlcnRpZXMiOiB7ImFtb3VudCI6ICIzMC4yMCIsICJjb3VudHkiOiAiQk9VTERFUiIsICJkYXRhX3NvdXJjZSI6ICJVLlMuIEdlb2xvZ2ljYWwgU3VydmV5IiwgImRhdGVfdGltZSI6ICIyMDIwLTAzLTI0VDE1OjE1OjAwLjAwMCIsICJkaXYiOiAiMSIsICJkd3JfYWJicmV2IjogIkJPQ05PUkNPIiwgImZsYWciOiBudWxsLCAiaHR0cF9saW5rYWdlLnVybCI6ICJodHRwczovL3dhdGVyZGF0YS51c2dzLmdvdi9ud2lzL3V2PzA2NzMwMjAwIiwgImxvY2F0aW9uLmxhdGl0dWRlIjogNDAuMDUxNjUyLCAibG9jYXRpb24ubG9uZ2l0dWRlIjogLTEwNS4xNzg4NzUsICJsb2NhdGlvbi5uZWVkc19yZWNvZGluZyI6IGZhbHNlLCAic3RhZ2UiOiBudWxsLCAic3RhdGlvbl9uYW1lIjogIkJPVUxERVIgQ1JFRUsgQVQgTk9SVEggNzVUSCBTVC4gTkVBUiBCT1VMREVSLCBDTyIsICJzdGF0aW9uX3N0YXR1cyI6ICJBY3RpdmUiLCAic3RhdGlvbl90eXBlIjogIlN0cmVhbSIsICJ1c2dzX3N0YXRpb25faWQiOiAiMDY3MzAyMDAiLCAidmFyaWFibGUiOiAiRElTQ0hSRyIsICJ3ZCI6ICI2In0sICJ0eXBlIjogIkZlYXR1cmUifSwgeyJiYm94IjogWy0xMDUuMTYwODc2LCA0MC4xNzA5OTgsIC0xMDUuMTYwODc2LCA0MC4xNzA5OThdLCAiZ2VvbWV0cnkiOiB7ImNvb3JkaW5hdGVzIjogWy0xMDUuMTYwODc2LCA0MC4xNzA5OThdLCAidHlwZSI6ICJQb2ludCJ9LCAiaWQiOiAiMTkiLCAicHJvcGVydGllcyI6IHsiYW1vdW50IjogIjAuMzgiLCAiY291bnR5IjogIkJPVUxERVIiLCAiZGF0YV9zb3VyY2UiOiAiQ29vcGVyYXRpdmUgUHJvZ3JhbSBvZiBDRFdSLCBOQ1dDRCBcdTAwMjYgU1ZMSFdDRCIsICJkYXRlX3RpbWUiOiAiMjAyMC0wMy0yNFQxNTowMDowMC4wMDAiLCAiZGl2IjogIjEiLCAiZHdyX2FiYnJldiI6ICJTRkxESVRDTyIsICJmbGFnIjogbnVsbCwgImh0dHBfbGlua2FnZS51cmwiOiAiaHR0cHM6Ly9kd3Iuc3RhdGUuY28udXMvU3VyZmFjZVdhdGVyL2RhdGEvZGV0YWlsX2dyYXBoLmFzcHg/SUQ9U0ZMRElUQ09cdTAwMjZNVFlQRT1ESVNDSFJHIiwgImxvY2F0aW9uLmxhdGl0dWRlIjogNDAuMTcwOTk4LCAibG9jYXRpb24ubG9uZ2l0dWRlIjogLTEwNS4xNjA4NzYsICJsb2NhdGlvbi5uZWVkc19yZWNvZGluZyI6IGZhbHNlLCAic3RhZ2UiOiAiMC4xMSIsICJzdGF0aW9uX25hbWUiOiAiU09VVEggRkxBVCBESVRDSCIsICJzdGF0aW9uX3N0YXR1cyI6ICJBY3RpdmUiLCAic3RhdGlvbl90eXBlIjogIkRpdmVyc2lvbiIsICJ1c2dzX3N0YXRpb25faWQiOiBudWxsLCAidmFyaWFibGUiOiAiRElTQ0hSRyIsICJ3ZCI6ICI1In0sICJ0eXBlIjogIkZlYXR1cmUifSwgeyJiYm94IjogWy0xMDUuMDc1Njk1MDAwMDAwMDEsIDQwLjE1MzM0MSwgLTEwNS4wNzU2OTUwMDAwMDAwMSwgNDAuMTUzMzQxXSwgImdlb21ldHJ5IjogeyJjb29yZGluYXRlcyI6IFstMTA1LjA3NTY5NTAwMDAwMDAxLCA0MC4xNTMzNDFdLCAidHlwZSI6ICJQb2ludCJ9LCAiaWQiOiAiMjAiLCAicHJvcGVydGllcyI6IHsiYW1vdW50IjogIjMzLjgwIiwgImNvdW50eSI6ICJCT1VMREVSIiwgImRhdGFfc291cmNlIjogIkNvLiBEaXZpc2lvbiBvZiBXYXRlciBSZXNvdXJjZXMiLCAiZGF0ZV90aW1lIjogIjIwMjAtMDMtMjRUMTU6MzA6MDAuMDAwIiwgImRpdiI6ICIxIiwgImR3cl9hYmJyZXYiOiAiU1ZDTE9QQ08iLCAiZmxhZyI6IG51bGwsICJodHRwX2xpbmthZ2UudXJsIjogImh0dHBzOi8vZHdyLnN0YXRlLmNvLnVzL1N1cmZhY2VXYXRlci9kYXRhL2RldGFpbF9ncmFwaC5hc3B4P0lEPVNWQ0xPUENPXHUwMDI2TVRZUEU9RElTQ0hSRyIsICJsb2NhdGlvbi5sYXRpdHVkZSI6IDQwLjE1MzM0MSwgImxvY2F0aW9uLmxvbmdpdHVkZSI6IC0xMDUuMDc1Njk1LCAibG9jYXRpb24ubmVlZHNfcmVjb2RpbmciOiBmYWxzZSwgInN0YWdlIjogIjMuNTMiLCAic3RhdGlvbl9uYW1lIjogIlNBSU5UIFZSQUlOIENSRUVLIEJFTE9XIEtFTiBQUkFUVCBCTFZEIEFUIExPTkdNT05ULCBDTyIsICJzdGF0aW9uX3N0YXR1cyI6ICJBY3RpdmUiLCAic3RhdGlvbl90eXBlIjogIlN0cmVhbSIsICJ1c2dzX3N0YXRpb25faWQiOiBudWxsLCAidmFyaWFibGUiOiAiRElTQ0hSRyIsICJ3ZCI6ICI1In0sICJ0eXBlIjogIkZlYXR1cmUifSwgeyJiYm94IjogWy0xMDUuNTA0NDQsIDM5Ljk2MTY1NSwgLTEwNS41MDQ0NCwgMzkuOTYxNjU1XSwgImdlb21ldHJ5IjogeyJjb29yZGluYXRlcyI6IFstMTA1LjUwNDQ0LCAzOS45NjE2NTVdLCAidHlwZSI6ICJQb2ludCJ9LCAiaWQiOiAiMjEiLCAicHJvcGVydGllcyI6IHsiYW1vdW50IjogIjI0LjYwIiwgImNvdW50eSI6ICJCT1VMREVSIiwgImRhdGFfc291cmNlIjogIkNvLiBEaXZpc2lvbiBvZiBXYXRlciBSZXNvdXJjZXMiLCAiZGF0ZV90aW1lIjogIjIwMjAtMDMtMjRUMTU6MTU6MDAuMDAwIiwgImRpdiI6ICIxIiwgImR3cl9hYmJyZXYiOiAiQk9DTUlEQ08iLCAiZmxhZyI6IG51bGwsICJodHRwX2xpbmthZ2UudXJsIjogImh0dHBzOi8vZHdyLnN0YXRlLmNvLnVzL1N1cmZhY2VXYXRlci9kYXRhL2RldGFpbF9ncmFwaC5hc3B4P0lEPUJPQ01JRENPXHUwMDI2TVRZUEU9RElTQ0hSRyIsICJsb2NhdGlvbi5sYXRpdHVkZSI6IDM5Ljk2MTY1NSwgImxvY2F0aW9uLmxvbmdpdHVkZSI6IC0xMDUuNTA0NDQsICJsb2NhdGlvbi5uZWVkc19yZWNvZGluZyI6IGZhbHNlLCAic3RhZ2UiOiAiMS4xNCIsICJzdGF0aW9uX25hbWUiOiAiTUlERExFIEJPVUxERVIgQ1JFRUsgQVQgTkVERVJMQU5ELCBDTy4iLCAic3RhdGlvbl9zdGF0dXMiOiAiQWN0aXZlIiwgInN0YXRpb25fdHlwZSI6ICJTdHJlYW0iLCAidXNnc19zdGF0aW9uX2lkIjogIjA2NzI1NTAwIiwgInZhcmlhYmxlIjogIkRJU0NIUkciLCAid2QiOiAiNiJ9LCAidHlwZSI6ICJGZWF0dXJlIn0sIHsiYmJveCI6IFstMTA1LjA5Nzg3MiwgNDAuMDU5ODA5LCAtMTA1LjA5Nzg3MiwgNDAuMDU5ODA5XSwgImdlb21ldHJ5IjogeyJjb29yZGluYXRlcyI6IFstMTA1LjA5Nzg3MiwgNDAuMDU5ODA5XSwgInR5cGUiOiAiUG9pbnQifSwgImlkIjogIjIyIiwgInByb3BlcnRpZXMiOiB7ImFtb3VudCI6ICI1MC4yMCIsICJjb3VudHkiOiAiQk9VTERFUiIsICJkYXRhX3NvdXJjZSI6ICJDby4gRGl2aXNpb24gb2YgV2F0ZXIgUmVzb3VyY2VzIiwgImRhdGVfdGltZSI6ICIyMDIwLTAzLTI0VDE1OjQ1OjAwLjAwMCIsICJkaXYiOiAiMSIsICJkd3JfYWJicmV2IjogIkJPQzEwOUNPIiwgImZsYWciOiBudWxsLCAiaHR0cF9saW5rYWdlLnVybCI6ICJodHRwczovL2R3ci5zdGF0ZS5jby51cy9TdXJmYWNlV2F0ZXIvZGF0YS9kZXRhaWxfZ3JhcGguYXNweD9JRD1CT0MxMDlDT1x1MDAyNk1UWVBFPURJU0NIUkciLCAibG9jYXRpb24ubGF0aXR1ZGUiOiA0MC4wNTk4MDksICJsb2NhdGlvbi5sb25naXR1ZGUiOiAtMTA1LjA5Nzg3MiwgImxvY2F0aW9uLm5lZWRzX3JlY29kaW5nIjogZmFsc2UsICJzdGFnZSI6ICIyLjU3IiwgInN0YXRpb25fbmFtZSI6ICJCT1VMREVSIENSRUVLIEFUIDEwOSBTVCBORUFSIEVSSUUsIENPIiwgInN0YXRpb25fc3RhdHVzIjogIkFjdGl2ZSIsICJzdGF0aW9uX3R5cGUiOiAiU3RyZWFtIiwgInVzZ3Nfc3RhdGlvbl9pZCI6IG51bGwsICJ2YXJpYWJsZSI6ICJESVNDSFJHIiwgIndkIjogIjYifSwgInR5cGUiOiAiRmVhdHVyZSJ9LCB7ImJib3giOiBbLTEwNS4zNjM0MjIsIDQwLjIxNTY1OCwgLTEwNS4zNjM0MjIsIDQwLjIxNTY1OF0sICJnZW9tZXRyeSI6IHsiY29vcmRpbmF0ZXMiOiBbLTEwNS4zNjM0MjIsIDQwLjIxNTY1OF0sICJ0eXBlIjogIlBvaW50In0sICJpZCI6ICIyMyIsICJwcm9wZXJ0aWVzIjogeyJhbW91bnQiOiAiMTkuMzAiLCAiY291bnR5IjogIkJPVUxERVIiLCAiZGF0YV9zb3VyY2UiOiAiQ28uIERpdmlzaW9uIG9mIFdhdGVyIFJlc291cmNlcyIsICJkYXRlX3RpbWUiOiAiMjAyMC0wMy0yNFQxNTo0NTowMC4wMDAiLCAiZGl2IjogIjEiLCAiZHdyX2FiYnJldiI6ICJOU1ZCQlJDTyIsICJmbGFnIjogbnVsbCwgImh0dHBfbGlua2FnZS51cmwiOiAiaHR0cHM6Ly9kd3Iuc3RhdGUuY28udXMvU3VyZmFjZVdhdGVyL2RhdGEvZGV0YWlsX2dyYXBoLmFzcHg/SUQ9TlNWQkJSQ09cdTAwMjZNVFlQRT1ESVNDSFJHIiwgImxvY2F0aW9uLmxhdGl0dWRlIjogNDAuMjE1NjU4LCAibG9jYXRpb24ubG9uZ2l0dWRlIjogLTEwNS4zNjM0MjIsICJsb2NhdGlvbi5uZWVkc19yZWNvZGluZyI6IGZhbHNlLCAic3RhZ2UiOiAiMC4zNCIsICJzdGF0aW9uX25hbWUiOiAiTk9SVEggU0FJTlQgVlJBSU4gQ1JFRUsgQkVMT1cgQlVUVE9OUk9DSyAgKFJBTFBIIFBSSUNFKSBSRVNFUlZPSVIiLCAic3RhdGlvbl9zdGF0dXMiOiAiQWN0aXZlIiwgInN0YXRpb25fdHlwZSI6ICJTdHJlYW0iLCAidXNnc19zdGF0aW9uX2lkIjogbnVsbCwgInZhcmlhYmxlIjogIkRJU0NIUkciLCAid2QiOiAiNSJ9LCAidHlwZSI6ICJGZWF0dXJlIn0sIHsiYmJveCI6IFstMTA1LjMwNDQwNCwgNDAuMTI2Mzg5LCAtMTA1LjMwNDQwNCwgNDAuMTI2Mzg5XSwgImdlb21ldHJ5IjogeyJjb29yZGluYXRlcyI6IFstMTA1LjMwNDQwNCwgNDAuMTI2Mzg5XSwgInR5cGUiOiAiUG9pbnQifSwgImlkIjogIjI0IiwgInByb3BlcnRpZXMiOiB7ImFtb3VudCI6ICIxMi42MCIsICJjb3VudHkiOiAiQk9VTERFUiIsICJkYXRhX3NvdXJjZSI6ICJDby4gRGl2aXNpb24gb2YgV2F0ZXIgUmVzb3VyY2VzIiwgImRhdGVfdGltZSI6ICIyMDIwLTAzLTI0VDE1OjE1OjAwLjAwMCIsICJkaXYiOiAiMSIsICJkd3JfYWJicmV2IjogIkxFRkNSRUNPIiwgImZsYWciOiBudWxsLCAiaHR0cF9saW5rYWdlLnVybCI6ICJodHRwczovL2R3ci5zdGF0ZS5jby51cy9TdXJmYWNlV2F0ZXIvZGF0YS9kZXRhaWxfZ3JhcGguYXNweD9JRD1MRUZDUkVDT1x1MDAyNk1UWVBFPURJU0NIUkciLCAibG9jYXRpb24ubGF0aXR1ZGUiOiA0MC4xMjYzODksICJsb2NhdGlvbi5sb25naXR1ZGUiOiAtMTA1LjMwNDQwNCwgImxvY2F0aW9uLm5lZWRzX3JlY29kaW5nIjogZmFsc2UsICJzdGFnZSI6ICIwLjQ2IiwgInN0YXRpb25fbmFtZSI6ICJMRUZUIEhBTkQgQ1JFRUsgTkVBUiBCT1VMREVSLCBDTy4iLCAic3RhdGlvbl9zdGF0dXMiOiAiQWN0aXZlIiwgInN0YXRpb25fdHlwZSI6ICJTdHJlYW0iLCAidXNnc19zdGF0aW9uX2lkIjogIjA2NzI0NTAwIiwgInZhcmlhYmxlIjogIkRJU0NIUkciLCAid2QiOiAiNSJ9LCAidHlwZSI6ICJGZWF0dXJlIn0sIHsiYmJveCI6IFstMTA1LjIxNzUxOSwgNDAuMDg2Mjc4LCAtMTA1LjIxNzUxOSwgNDAuMDg2Mjc4XSwgImdlb21ldHJ5IjogeyJjb29yZGluYXRlcyI6IFstMTA1LjIxNzUxOSwgNDAuMDg2Mjc4XSwgInR5cGUiOiAiUG9pbnQifSwgImlkIjogIjI1IiwgInByb3BlcnRpZXMiOiB7ImFtb3VudCI6ICIwLjAwIiwgImNvdW50eSI6ICJCT1VMREVSIiwgImRhdGFfc291cmNlIjogIk5vcnRoZXJuIENvbG9yYWRvIFdhdGVyIENvbnNlcnZhbmN5IERpc3RyaWN0IiwgImRhdGVfdGltZSI6ICIyMDIwLTAzLTI0VDE1OjAwOjAwLjAwMCIsICJkaXYiOiAiMSIsICJkd3JfYWJicmV2IjogIkJGQ0lORkNPIiwgImZsYWciOiBudWxsLCAiaHR0cF9saW5rYWdlLnVybCI6ICJodHRwOi8vd3d3Lm5vcnRoZXJud2F0ZXIub3JnL1dhdGVyUHJvamVjdHMvV2F0ZXJEYXRhLmFzcHhFYXN0U2xvcGVXYXRlckRhdGEuYXNweCIsICJsb2NhdGlvbi5sYXRpdHVkZSI6IDQwLjA4NjI3OCwgImxvY2F0aW9uLmxvbmdpdHVkZSI6IC0xMDUuMjE3NTE5LCAibG9jYXRpb24ubmVlZHNfcmVjb2RpbmciOiBmYWxzZSwgInN0YWdlIjogIjAuMDEiLCAic3RhdGlvbl9uYW1lIjogIkJPVUxERVIgUkVTRVJWT0lSIElOTEVUIiwgInN0YXRpb25fc3RhdHVzIjogIkFjdGl2ZSIsICJzdGF0aW9uX3R5cGUiOiAiU3RyZWFtIiwgInVzZ3Nfc3RhdGlvbl9pZCI6ICJFUzE5MTYiLCAidmFyaWFibGUiOiAiRElTQ0hSRyIsICJ3ZCI6ICI2In0sICJ0eXBlIjogIkZlYXR1cmUifSwgeyJiYm94IjogWy0xMDUuMjEwMzg4MDAwMDAwMDEsIDQwLjE5MzAxOSwgLTEwNS4yMTAzODgwMDAwMDAwMSwgNDAuMTkzMDE5XSwgImdlb21ldHJ5IjogeyJjb29yZGluYXRlcyI6IFstMTA1LjIxMDM4ODAwMDAwMDAxLCA0MC4xOTMwMTldLCAidHlwZSI6ICJQb2ludCJ9LCAiaWQiOiAiMjYiLCAicHJvcGVydGllcyI6IHsiYW1vdW50IjogIjAuMDAiLCAiY291bnR5IjogIkJPVUxERVIiLCAiZGF0YV9zb3VyY2UiOiAiQ29vcGVyYXRpdmUgUHJvZ3JhbSBvZiBDRFdSLCBOQ1dDRCBcdTAwMjYgU1ZMSFdDRCIsICJkYXRlX3RpbWUiOiAiMjAyMC0wMy0yNFQxNTowMDowMC4wMDAiLCAiZGl2IjogIjEiLCAiZHdyX2FiYnJldiI6ICJUUlVESVRDTyIsICJmbGFnIjogbnVsbCwgImh0dHBfbGlua2FnZS51cmwiOiAiaHR0cHM6Ly9kd3Iuc3RhdGUuY28udXMvU3VyZmFjZVdhdGVyL2RhdGEvZGV0YWlsX2dyYXBoLmFzcHg/SUQ9VFJVRElUQ09cdTAwMjZNVFlQRT1ESVNDSFJHIiwgImxvY2F0aW9uLmxhdGl0dWRlIjogNDAuMTkzMDE5LCAibG9jYXRpb24ubG9uZ2l0dWRlIjogLTEwNS4yMTAzODgsICJsb2NhdGlvbi5uZWVkc19yZWNvZGluZyI6IGZhbHNlLCAic3RhZ2UiOiBudWxsLCAic3RhdGlvbl9uYW1lIjogIlRSVUUgQU5EIFdFQlNURVIgRElUQ0giLCAic3RhdGlvbl9zdGF0dXMiOiAiQWN0aXZlIiwgInN0YXRpb25fdHlwZSI6ICJEaXZlcnNpb24iLCAidXNnc19zdGF0aW9uX2lkIjogbnVsbCwgInZhcmlhYmxlIjogIkRJU0NIUkciLCAid2QiOiAiNSJ9LCAidHlwZSI6ICJGZWF0dXJlIn0sIHsiYmJveCI6IFstMTA1LjI1MTgyNiwgNDAuMjEyNjU4LCAtMTA1LjI1MTgyNiwgNDAuMjEyNjU4XSwgImdlb21ldHJ5IjogeyJjb29yZGluYXRlcyI6IFstMTA1LjI1MTgyNiwgNDAuMjEyNjU4XSwgInR5cGUiOiAiUG9pbnQifSwgImlkIjogIjI3IiwgInByb3BlcnRpZXMiOiB7ImFtb3VudCI6ICIwLjAwIiwgImNvdW50eSI6ICJCT1VMREVSIiwgImRhdGFfc291cmNlIjogIkNvb3BlcmF0aXZlIFByb2dyYW0gb2YgQ0RXUiwgTkNXQ0QgXHUwMDI2IFNWTEhXQ0QiLCAiZGF0ZV90aW1lIjogIjIwMjAtMDMtMjRUMTU6MDA6MDAuMDAwIiwgImRpdiI6ICIxIiwgImR3cl9hYmJyZXYiOiAiUk9VUkVBQ08iLCAiZmxhZyI6IG51bGwsICJodHRwX2xpbmthZ2UudXJsIjogImh0dHBzOi8vZHdyLnN0YXRlLmNvLnVzL1N1cmZhY2VXYXRlci9kYXRhL2RldGFpbF9ncmFwaC5hc3B4P0lEPVJPVVJFQUNPXHUwMDI2TVRZUEU9RElTQ0hSRyIsICJsb2NhdGlvbi5sYXRpdHVkZSI6IDQwLjIxMjY1OCwgImxvY2F0aW9uLmxvbmdpdHVkZSI6IC0xMDUuMjUxODI2LCAibG9jYXRpb24ubmVlZHNfcmVjb2RpbmciOiBmYWxzZSwgInN0YWdlIjogbnVsbCwgInN0YXRpb25fbmFtZSI6ICJST1VHSCBBTkQgUkVBRFkgRElUQ0giLCAic3RhdGlvbl9zdGF0dXMiOiAiQWN0aXZlIiwgInN0YXRpb25fdHlwZSI6ICJEaXZlcnNpb24iLCAidXNnc19zdGF0aW9uX2lkIjogbnVsbCwgInZhcmlhYmxlIjogIkRJU0NIUkciLCAid2QiOiAiNSJ9LCAidHlwZSI6ICJGZWF0dXJlIn0sIHsiYmJveCI6IFstMTA1LjE2Nzg3MywgNDAuMTc0ODQ0LCAtMTA1LjE2Nzg3MywgNDAuMTc0ODQ0XSwgImdlb21ldHJ5IjogeyJjb29yZGluYXRlcyI6IFstMTA1LjE2Nzg3MywgNDAuMTc0ODQ0XSwgInR5cGUiOiAiUG9pbnQifSwgImlkIjogIjI4IiwgInByb3BlcnRpZXMiOiB7ImFtb3VudCI6ICIwLjEyIiwgImNvdW50eSI6ICJCT1VMREVSIiwgImRhdGFfc291cmNlIjogIkNvb3BlcmF0aXZlIFByb2dyYW0gb2YgQ0RXUiwgTkNXQ0QgXHUwMDI2IFNWTEhXQ0QiLCAiZGF0ZV90aW1lIjogIjIwMjAtMDMtMjRUMTQ6NDU6MDAuMDAwIiwgImRpdiI6ICIxIiwgImR3cl9hYmJyZXYiOiAiSEdSTURXQ08iLCAiZmxhZyI6IG51bGwsICJodHRwX2xpbmthZ2UudXJsIjogImh0dHBzOi8vZHdyLnN0YXRlLmNvLnVzL1N1cmZhY2VXYXRlci9kYXRhL2RldGFpbF9ncmFwaC5hc3B4P0lEPUhHUk1EV0NPXHUwMDI2TVRZUEU9RElTQ0hSRyIsICJsb2NhdGlvbi5sYXRpdHVkZSI6IDQwLjE3NDg0NCwgImxvY2F0aW9uLmxvbmdpdHVkZSI6IC0xMDUuMTY3ODczLCAibG9jYXRpb24ubmVlZHNfcmVjb2RpbmciOiBmYWxzZSwgInN0YWdlIjogIjAuMDciLCAic3RhdGlvbl9uYW1lIjogIkhBR0VSIE1FQURPV1MgRElUQ0giLCAic3RhdGlvbl9zdGF0dXMiOiAiQWN0aXZlIiwgInN0YXRpb25fdHlwZSI6ICJEaXZlcnNpb24iLCAidXNnc19zdGF0aW9uX2lkIjogbnVsbCwgInZhcmlhYmxlIjogIkRJU0NIUkciLCAid2QiOiAiNSJ9LCAidHlwZSI6ICJGZWF0dXJlIn0sIHsiYmJveCI6IFstMTA1LjIwOTQxNiwgNDAuMjU2Mjc2MDAwMDAwMDEsIC0xMDUuMjA5NDE2LCA0MC4yNTYyNzYwMDAwMDAwMV0sICJnZW9tZXRyeSI6IHsiY29vcmRpbmF0ZXMiOiBbLTEwNS4yMDk0MTYsIDQwLjI1NjI3NjAwMDAwMDAxXSwgInR5cGUiOiAiUG9pbnQifSwgImlkIjogIjI5IiwgInByb3BlcnRpZXMiOiB7ImFtb3VudCI6ICIwLjAwIiwgImNvdW50eSI6ICJCT1VMREVSIiwgImRhdGFfc291cmNlIjogIk5vcnRoZXJuIENvbG9yYWRvIFdhdGVyIENvbnNlcnZhbmN5IERpc3RyaWN0IiwgImRhdGVfdGltZSI6ICIyMDIwLTAzLTI0VDE1OjAwOjAwLjAwMCIsICJkaXYiOiAiMSIsICJkd3JfYWJicmV2IjogIkxJVFRIMUNPIiwgImZsYWciOiBudWxsLCAiaHR0cF9saW5rYWdlLnVybCI6ICJodHRwOi8vd3d3Lm5vcnRoZXJud2F0ZXIub3JnL1dhdGVyUHJvamVjdHMvV2F0ZXJEYXRhLmFzcHhFYXN0U2xvcGVXYXRlckRhdGEuYXNweCIsICJsb2NhdGlvbi5sYXRpdHVkZSI6IDQwLjI1NjI3NiwgImxvY2F0aW9uLmxvbmdpdHVkZSI6IC0xMDUuMjA5NDE2LCAibG9jYXRpb24ubmVlZHNfcmVjb2RpbmciOiBmYWxzZSwgInN0YWdlIjogbnVsbCwgInN0YXRpb25fbmFtZSI6ICJMSVRUTEUgVEhPTVBTT04gIzEgRElUQ0giLCAic3RhdGlvbl9zdGF0dXMiOiAiQWN0aXZlIiwgInN0YXRpb25fdHlwZSI6ICJEaXZlcnNpb24iLCAidXNnc19zdGF0aW9uX2lkIjogIkVTMTkwMSIsICJ2YXJpYWJsZSI6ICJESVNDSFJHIiwgIndkIjogIjQifSwgInR5cGUiOiAiRmVhdHVyZSJ9LCB7ImJib3giOiBbLTEwNS4xOTg1NjcsIDQwLjI2MDgyNywgLTEwNS4xOTg1NjcsIDQwLjI2MDgyN10sICJnZW9tZXRyeSI6IHsiY29vcmRpbmF0ZXMiOiBbLTEwNS4xOTg1NjcsIDQwLjI2MDgyN10sICJ0eXBlIjogIlBvaW50In0sICJpZCI6ICIzMCIsICJwcm9wZXJ0aWVzIjogeyJhbW91bnQiOiAiMC4wMCIsICJjb3VudHkiOiAiQk9VTERFUiIsICJkYXRhX3NvdXJjZSI6ICJDb29wZXJhdGl2ZSBTRFIgUHJvZ3JhbSBvZiBDRFdSIFx1MDAyNiBOQ1dDRCIsICJkYXRlX3RpbWUiOiAiMjAyMC0wMy0yNFQxNTowMDowMC4wMDAiLCAiZGl2IjogIjEiLCAiZHdyX2FiYnJldiI6ICJDVUxESVRDTyIsICJmbGFnIjogbnVsbCwgImh0dHBfbGlua2FnZS51cmwiOiAiaHR0cHM6Ly9kd3Iuc3RhdGUuY28udXMvU3VyZmFjZVdhdGVyL2RhdGEvZGV0YWlsX2dyYXBoLmFzcHg/SUQ9Q1VMRElUQ09cdTAwMjZNVFlQRT1ESVNDSFJHIiwgImxvY2F0aW9uLmxhdGl0dWRlIjogNDAuMjYwODI3LCAibG9jYXRpb24ubG9uZ2l0dWRlIjogLTEwNS4xOTg1NjcsICJsb2NhdGlvbi5uZWVkc19yZWNvZGluZyI6IGZhbHNlLCAic3RhZ2UiOiBudWxsLCAic3RhdGlvbl9uYW1lIjogIkNVTFZFUiBESVRDSCIsICJzdGF0aW9uX3N0YXR1cyI6ICJBY3RpdmUiLCAic3RhdGlvbl90eXBlIjogIkRpdmVyc2lvbiIsICJ1c2dzX3N0YXRpb25faWQiOiBudWxsLCAidmFyaWFibGUiOiAiRElTQ0hSRyIsICJ3ZCI6ICI0In0sICJ0eXBlIjogIkZlYXR1cmUifSwgeyJiYm94IjogWy0xMDUuMjU2MDE3LCA0MC4yMTUwNDMsIC0xMDUuMjU2MDE3LCA0MC4yMTUwNDNdLCAiZ2VvbWV0cnkiOiB7ImNvb3JkaW5hdGVzIjogWy0xMDUuMjU2MDE3LCA0MC4yMTUwNDNdLCAidHlwZSI6ICJQb2ludCJ9LCAiaWQiOiAiMzEiLCAicHJvcGVydGllcyI6IHsiYW1vdW50IjogIjM4LjkwIiwgImNvdW50eSI6ICJCT1VMREVSIiwgImRhdGFfc291cmNlIjogIkNvLiBEaXZpc2lvbiBvZiBXYXRlciBSZXNvdXJjZXMiLCAiZGF0ZV90aW1lIjogIjIwMjAtMDMtMjRUMTU6MzA6MDAuMDAwIiwgImRpdiI6ICIxIiwgImR3cl9hYmJyZXYiOiAiSElHSExEQ08iLCAiZmxhZyI6IG51bGwsICJodHRwX2xpbmthZ2UudXJsIjogImh0dHBzOi8vZHdyLnN0YXRlLmNvLnVzL1N1cmZhY2VXYXRlci9kYXRhL2RldGFpbF9ncmFwaC5hc3B4P0lEPUhJR0hMRENPXHUwMDI2TVRZUEU9RElTQ0hSRyIsICJsb2NhdGlvbi5sYXRpdHVkZSI6IDQwLjIxNTA0MywgImxvY2F0aW9uLmxvbmdpdHVkZSI6IC0xMDUuMjU2MDE3LCAibG9jYXRpb24ubmVlZHNfcmVjb2RpbmciOiBmYWxzZSwgInN0YWdlIjogIjAuNzIiLCAic3RhdGlvbl9uYW1lIjogIkhJR0hMQU5EIERJVENIIEFUIExZT05TLCBDTyIsICJzdGF0aW9uX3N0YXR1cyI6ICJBY3RpdmUiLCAic3RhdGlvbl90eXBlIjogIkRpdmVyc2lvbiIsICJ1c2dzX3N0YXRpb25faWQiOiBudWxsLCAidmFyaWFibGUiOiAiRElTQ0hSRyIsICJ3ZCI6ICI1In0sICJ0eXBlIjogIkZlYXR1cmUifSwgeyJiYm94IjogWy0xMDUuMjIwNDk3LCA0MC4wNzg1NiwgLTEwNS4yMjA0OTcsIDQwLjA3ODU2XSwgImdlb21ldHJ5IjogeyJjb29yZGluYXRlcyI6IFstMTA1LjIyMDQ5NywgNDAuMDc4NTZdLCAidHlwZSI6ICJQb2ludCJ9LCAiaWQiOiAiMzIiLCAicHJvcGVydGllcyI6IHsiYW1vdW50IjogIjUyMTEuNTAiLCAiY291bnR5IjogIkJPVUxERVIiLCAiZGF0YV9zb3VyY2UiOiAiTm9ydGhlcm4gQ29sb3JhZG8gV2F0ZXIgQ29uc2VydmFuY3kgRGlzdHJpY3QiLCAiZGF0ZV90aW1lIjogIjIwMjAtMDMtMjRUMTU6MDA6MDAuMDAwIiwgImRpdiI6ICIxIiwgImR3cl9hYmJyZXYiOiAiQk9VUkVTQ08iLCAiZmxhZyI6IG51bGwsICJodHRwX2xpbmthZ2UudXJsIjogImh0dHA6Ly93d3cubm9ydGhlcm53YXRlci5vcmcvV2F0ZXJQcm9qZWN0cy9XYXRlckRhdGEuYXNweEVhc3RTbG9wZVdhdGVyRGF0YS5hc3B4IiwgImxvY2F0aW9uLmxhdGl0dWRlIjogNDAuMDc4NTYsICJsb2NhdGlvbi5sb25naXR1ZGUiOiAtMTA1LjIyMDQ5NywgImxvY2F0aW9uLm5lZWRzX3JlY29kaW5nIjogZmFsc2UsICJzdGFnZSI6IG51bGwsICJzdGF0aW9uX25hbWUiOiAiQk9VTERFUiBSRVNFUlZPSVIiLCAic3RhdGlvbl9zdGF0dXMiOiAiQWN0aXZlIiwgInN0YXRpb25fdHlwZSI6ICJSZXNlcnZvaXIiLCAidXNnc19zdGF0aW9uX2lkIjogIkVSMTkxNCIsICJ2YXJpYWJsZSI6ICJTVE9SQUdFIiwgIndkIjogIjYifSwgInR5cGUiOiAiRmVhdHVyZSJ9LCB7ImJib3giOiBbLTEwNS4xNjkzNzQsIDQwLjE3Mzk1LCAtMTA1LjE2OTM3NCwgNDAuMTczOTVdLCAiZ2VvbWV0cnkiOiB7ImNvb3JkaW5hdGVzIjogWy0xMDUuMTY5Mzc0LCA0MC4xNzM5NV0sICJ0eXBlIjogIlBvaW50In0sICJpZCI6ICIzMyIsICJwcm9wZXJ0aWVzIjogeyJhbW91bnQiOiAiMC4xOSIsICJjb3VudHkiOiAiQk9VTERFUiIsICJkYXRhX3NvdXJjZSI6ICJDb29wZXJhdGl2ZSBQcm9ncmFtIG9mIENEV1IsIE5DV0NEIFx1MDAyNiBTVkxIV0NEIiwgImRhdGVfdGltZSI6ICIyMDIwLTAzLTI0VDE0OjMwOjAwLjAwMCIsICJkaXYiOiAiMSIsICJkd3JfYWJicmV2IjogIk5JV0RJVENPIiwgImZsYWciOiBudWxsLCAiaHR0cF9saW5rYWdlLnVybCI6ICJodHRwczovL2R3ci5zdGF0ZS5jby51cy9TdXJmYWNlV2F0ZXIvZGF0YS9kZXRhaWxfZ3JhcGguYXNweD9JRD1OSVdESVRDT1x1MDAyNk1UWVBFPURJU0NIUkciLCAibG9jYXRpb24ubGF0aXR1ZGUiOiA0MC4xNzM5NSwgImxvY2F0aW9uLmxvbmdpdHVkZSI6IC0xMDUuMTY5Mzc0LCAibG9jYXRpb24ubmVlZHNfcmVjb2RpbmciOiBmYWxzZSwgInN0YWdlIjogIjAuMDkiLCAic3RhdGlvbl9uYW1lIjogIk5JV09UIERJVENIIiwgInN0YXRpb25fc3RhdHVzIjogIkFjdGl2ZSIsICJzdGF0aW9uX3R5cGUiOiAiRGl2ZXJzaW9uIiwgInVzZ3Nfc3RhdGlvbl9pZCI6IG51bGwsICJ2YXJpYWJsZSI6ICJESVNDSFJHIiwgIndkIjogIjUifSwgInR5cGUiOiAiRmVhdHVyZSJ9LCB7ImJib3giOiBbLTEwNS4yNTA5NTIsIDQwLjIxMTM4OSwgLTEwNS4yNTA5NTIsIDQwLjIxMTM4OV0sICJnZW9tZXRyeSI6IHsiY29vcmRpbmF0ZXMiOiBbLTEwNS4yNTA5NTIsIDQwLjIxMTM4OV0sICJ0eXBlIjogIlBvaW50In0sICJpZCI6ICIzNCIsICJwcm9wZXJ0aWVzIjogeyJhbW91bnQiOiAiMC4wMCIsICJjb3VudHkiOiAiQk9VTERFUiIsICJkYXRhX3NvdXJjZSI6ICJDb29wZXJhdGl2ZSBQcm9ncmFtIG9mIENEV1IsIE5DV0NEIFx1MDAyNiBTVkxIV0NEIiwgImRhdGVfdGltZSI6ICIyMDIwLTAzLTI0VDE0OjAwOjAwLjAwMCIsICJkaXYiOiAiMSIsICJkd3JfYWJicmV2IjogIlNNRURJVENPIiwgImZsYWciOiBudWxsLCAiaHR0cF9saW5rYWdlLnVybCI6ICJodHRwczovL2R3ci5zdGF0ZS5jby51cy9TdXJmYWNlV2F0ZXIvZGF0YS9kZXRhaWxfZ3JhcGguYXNweD9JRD1TTUVESVRDT1x1MDAyNk1UWVBFPURJU0NIUkciLCAibG9jYXRpb24ubGF0aXR1ZGUiOiA0MC4yMTEzODksICJsb2NhdGlvbi5sb25naXR1ZGUiOiAtMTA1LjI1MDk1MiwgImxvY2F0aW9uLm5lZWRzX3JlY29kaW5nIjogZmFsc2UsICJzdGFnZSI6IG51bGwsICJzdGF0aW9uX25hbWUiOiAiU01FQUQgRElUQ0giLCAic3RhdGlvbl9zdGF0dXMiOiAiQWN0aXZlIiwgInN0YXRpb25fdHlwZSI6ICJEaXZlcnNpb24iLCAidXNnc19zdGF0aW9uX2lkIjogbnVsbCwgInZhcmlhYmxlIjogIkRJU0NIUkciLCAid2QiOiAiNSJ9LCAidHlwZSI6ICJGZWF0dXJlIn0sIHsiYmJveCI6IFstMTA1LjA4ODY5NSwgNDAuMTUzMzYzLCAtMTA1LjA4ODY5NSwgNDAuMTUzMzYzXSwgImdlb21ldHJ5IjogeyJjb29yZGluYXRlcyI6IFstMTA1LjA4ODY5NSwgNDAuMTUzMzYzXSwgInR5cGUiOiAiUG9pbnQifSwgImlkIjogIjM1IiwgInByb3BlcnRpZXMiOiB7ImFtb3VudCI6ICIwLjEwIiwgImNvdW50eSI6ICJCT1VMREVSIiwgImRhdGFfc291cmNlIjogIkNvb3BlcmF0aXZlIFByb2dyYW0gb2YgQ0RXUiwgTkNXQ0QgXHUwMDI2IFNWTEhXQ0QiLCAiZGF0ZV90aW1lIjogIjIwMjAtMDMtMjRUMTU6MDA6MDAuMDAwIiwgImRpdiI6ICIxIiwgImR3cl9hYmJyZXYiOiAiQk9ORElUQ08iLCAiZmxhZyI6IG51bGwsICJodHRwX2xpbmthZ2UudXJsIjogImh0dHBzOi8vZHdyLnN0YXRlLmNvLnVzL1N1cmZhY2VXYXRlci9kYXRhL2RldGFpbF9ncmFwaC5hc3B4P0lEPUJPTkRJVENPXHUwMDI2TVRZUEU9RElTQ0hSRyIsICJsb2NhdGlvbi5sYXRpdHVkZSI6IDQwLjE1MzM2MywgImxvY2F0aW9uLmxvbmdpdHVkZSI6IC0xMDUuMDg4Njk1LCAibG9jYXRpb24ubmVlZHNfcmVjb2RpbmciOiBmYWxzZSwgInN0YWdlIjogIjAuMDQiLCAic3RhdGlvbl9uYW1lIjogIkJPTlVTIERJVENIIiwgInN0YXRpb25fc3RhdHVzIjogIkFjdGl2ZSIsICJzdGF0aW9uX3R5cGUiOiAiRGl2ZXJzaW9uIiwgInVzZ3Nfc3RhdGlvbl9pZCI6IG51bGwsICJ2YXJpYWJsZSI6ICJESVNDSFJHIiwgIndkIjogIjUifSwgInR5cGUiOiAiRmVhdHVyZSJ9LCB7ImJib3giOiBbLTEwNS4yNTA5MjcsIDQwLjIxMTA4MywgLTEwNS4yNTA5MjcsIDQwLjIxMTA4M10sICJnZW9tZXRyeSI6IHsiY29vcmRpbmF0ZXMiOiBbLTEwNS4yNTA5MjcsIDQwLjIxMTA4M10sICJ0eXBlIjogIlBvaW50In0sICJpZCI6ICIzNiIsICJwcm9wZXJ0aWVzIjogeyJhbW91bnQiOiAiMC4wMCIsICJjb3VudHkiOiAiQk9VTERFUiIsICJkYXRhX3NvdXJjZSI6ICJDb29wZXJhdGl2ZSBQcm9ncmFtIG9mIENEV1IsIE5DV0NEIFx1MDAyNiBTVkxIV0NEIiwgImRhdGVfdGltZSI6ICIyMDIwLTAzLTI0VDE0OjAwOjAwLjAwMCIsICJkaXYiOiAiMSIsICJkd3JfYWJicmV2IjogIlNXRURJVENPIiwgImZsYWciOiBudWxsLCAiaHR0cF9saW5rYWdlLnVybCI6ICJodHRwczovL2R3ci5zdGF0ZS5jby51cy9TdXJmYWNlV2F0ZXIvZGF0YS9kZXRhaWxfZ3JhcGguYXNweD9JRD1TV0VESVRDT1x1MDAyNk1UWVBFPURJU0NIUkciLCAibG9jYXRpb24ubGF0aXR1ZGUiOiA0MC4yMTEwODMsICJsb2NhdGlvbi5sb25naXR1ZGUiOiAtMTA1LjI1MDkyNywgImxvY2F0aW9uLm5lZWRzX3JlY29kaW5nIjogZmFsc2UsICJzdGFnZSI6ICItMC4wNSIsICJzdGF0aW9uX25hbWUiOiAiU1dFREUgRElUQ0giLCAic3RhdGlvbl9zdGF0dXMiOiAiQWN0aXZlIiwgInN0YXRpb25fdHlwZSI6ICJEaXZlcnNpb24iLCAidXNnc19zdGF0aW9uX2lkIjogbnVsbCwgInZhcmlhYmxlIjogIkRJU0NIUkciLCAid2QiOiAiNSJ9LCAidHlwZSI6ICJGZWF0dXJlIn0sIHsiYmJveCI6IFstMTA1LjE4OTEzMiwgNDAuMTg3NTI0LCAtMTA1LjE4OTEzMiwgNDAuMTg3NTI0XSwgImdlb21ldHJ5IjogeyJjb29yZGluYXRlcyI6IFstMTA1LjE4OTEzMiwgNDAuMTg3NTI0XSwgInR5cGUiOiAiUG9pbnQifSwgImlkIjogIjM3IiwgInByb3BlcnRpZXMiOiB7ImFtb3VudCI6ICIwLjAwIiwgImNvdW50eSI6ICJCT1VMREVSIiwgImRhdGFfc291cmNlIjogIkNvb3BlcmF0aXZlIFByb2dyYW0gb2YgQ0RXUiwgTkNXQ0QgXHUwMDI2IFNWTEhXQ0QiLCAiZGF0ZV90aW1lIjogIjIwMjAtMDMtMjRUMTU6MDA6MDAuMDAwIiwgImRpdiI6ICIxIiwgImR3cl9hYmJyZXYiOiAiUlVOWU9OQ08iLCAiZmxhZyI6IG51bGwsICJodHRwX2xpbmthZ2UudXJsIjogImh0dHBzOi8vZHdyLnN0YXRlLmNvLnVzL1N1cmZhY2VXYXRlci9kYXRhL2RldGFpbF9ncmFwaC5hc3B4P0lEPVJVTllPTkNPXHUwMDI2TVRZUEU9RElTQ0hSRyIsICJsb2NhdGlvbi5sYXRpdHVkZSI6IDQwLjE4NzUyNCwgImxvY2F0aW9uLmxvbmdpdHVkZSI6IC0xMDUuMTg5MTMyLCAibG9jYXRpb24ubmVlZHNfcmVjb2RpbmciOiBmYWxzZSwgInN0YWdlIjogIjUwLjc5IiwgInN0YXRpb25fbmFtZSI6ICJSVU5ZT04gRElUQ0giLCAic3RhdGlvbl9zdGF0dXMiOiAiQWN0aXZlIiwgInN0YXRpb25fdHlwZSI6ICJEaXZlcnNpb24iLCAidXNnc19zdGF0aW9uX2lkIjogbnVsbCwgInZhcmlhYmxlIjogIkRJU0NIUkciLCAid2QiOiAiNSJ9LCAidHlwZSI6ICJGZWF0dXJlIn0sIHsiYmJveCI6IFstMTA1LjE5Njc3NSwgNDAuMTgxODgsIC0xMDUuMTk2Nzc1LCA0MC4xODE4OF0sICJnZW9tZXRyeSI6IHsiY29vcmRpbmF0ZXMiOiBbLTEwNS4xOTY3NzUsIDQwLjE4MTg4XSwgInR5cGUiOiAiUG9pbnQifSwgImlkIjogIjM4IiwgInByb3BlcnRpZXMiOiB7ImFtb3VudCI6ICIwLjAwIiwgImNvdW50eSI6ICJCT1VMREVSIiwgImRhdGFfc291cmNlIjogIkNvb3BlcmF0aXZlIFByb2dyYW0gb2YgQ0RXUiwgTkNXQ0QgXHUwMDI2IFNWTEhXQ0QiLCAiZGF0ZV90aW1lIjogIjIwMjAtMDMtMjRUMTQ6NDU6MDAuMDAwIiwgImRpdiI6ICIxIiwgImR3cl9hYmJyZXYiOiAiREFWRE9XQ08iLCAiZmxhZyI6IG51bGwsICJodHRwX2xpbmthZ2UudXJsIjogImh0dHBzOi8vZHdyLnN0YXRlLmNvLnVzL1N1cmZhY2VXYXRlci9kYXRhL2RldGFpbF9ncmFwaC5hc3B4P0lEPURBVkRPV0NPXHUwMDI2TVRZUEU9RElTQ0hSRyIsICJsb2NhdGlvbi5sYXRpdHVkZSI6IDQwLjE4MTg4LCAibG9jYXRpb24ubG9uZ2l0dWRlIjogLTEwNS4xOTY3NzUsICJsb2NhdGlvbi5uZWVkc19yZWNvZGluZyI6IGZhbHNlLCAic3RhZ2UiOiBudWxsLCAic3RhdGlvbl9uYW1lIjogIkRBVklTIEFORCBET1dOSU5HIERJVENIIiwgInN0YXRpb25fc3RhdHVzIjogIkFjdGl2ZSIsICJzdGF0aW9uX3R5cGUiOiAiRGl2ZXJzaW9uIiwgInVzZ3Nfc3RhdGlvbl9pZCI6IG51bGwsICJ2YXJpYWJsZSI6ICJESVNDSFJHIiwgIndkIjogIjUifSwgInR5cGUiOiAiRmVhdHVyZSJ9LCB7ImJib3giOiBbLTEwNS4zMjYyNSwgNDAuMDE4NjY3LCAtMTA1LjMyNjI1LCA0MC4wMTg2NjddLCAiZ2VvbWV0cnkiOiB7ImNvb3JkaW5hdGVzIjogWy0xMDUuMzI2MjUsIDQwLjAxODY2N10sICJ0eXBlIjogIlBvaW50In0sICJpZCI6ICIzOSIsICJwcm9wZXJ0aWVzIjogeyJhbW91bnQiOiAiMC43NCIsICJjb3VudHkiOiAiQk9VTERFUiIsICJkYXRhX3NvdXJjZSI6ICJVLlMuIEdlb2xvZ2ljYWwgU3VydmV5IiwgImRhdGVfdGltZSI6ICIyMDE5LTEwLTAyVDE0OjUwOjAwLjAwMCIsICJkaXYiOiAiMSIsICJkd3JfYWJicmV2IjogIkZPVU9ST0NPIiwgImZsYWciOiBudWxsLCAiaHR0cF9saW5rYWdlLnVybCI6ICJodHRwczovL3dhdGVyZGF0YS51c2dzLmdvdi9ud2lzL3V2PzA2NzI3NTAwIiwgImxvY2F0aW9uLmxhdGl0dWRlIjogNDAuMDE4NjY3LCAibG9jYXRpb24ubG9uZ2l0dWRlIjogLTEwNS4zMjYyNSwgImxvY2F0aW9uLm5lZWRzX3JlY29kaW5nIjogZmFsc2UsICJzdGFnZSI6IG51bGwsICJzdGF0aW9uX25hbWUiOiAiRk9VUk1JTEUgQ1JFRUsgQVQgT1JPREVMTCwgQ08iLCAic3RhdGlvbl9zdGF0dXMiOiAiQWN0aXZlIiwgInN0YXRpb25fdHlwZSI6ICJTdHJlYW0iLCAidXNnc19zdGF0aW9uX2lkIjogIjA2NzI3NTAwIiwgInZhcmlhYmxlIjogIkRJU0NIUkciLCAid2QiOiAiNiJ9LCAidHlwZSI6ICJGZWF0dXJlIn0sIHsiYmJveCI6IFstMTA1LjIwOTI4MiwgNDAuMTg4NTc5LCAtMTA1LjIwOTI4MiwgNDAuMTg4NTc5XSwgImdlb21ldHJ5IjogeyJjb29yZGluYXRlcyI6IFstMTA1LjIwOTI4MiwgNDAuMTg4NTc5XSwgInR5cGUiOiAiUG9pbnQifSwgImlkIjogIjQwIiwgInByb3BlcnRpZXMiOiB7ImFtb3VudCI6ICIwLjEyIiwgImNvdW50eSI6ICJCT1VMREVSIiwgImRhdGFfc291cmNlIjogIkNvb3BlcmF0aXZlIFByb2dyYW0gb2YgQ0RXUiwgTkNXQ0QgXHUwMDI2IFNWTEhXQ0QiLCAiZGF0ZV90aW1lIjogIjIwMjAtMDMtMjRUMTQ6NDU6MDAuMDAwIiwgImRpdiI6ICIxIiwgImR3cl9hYmJyZXYiOiAiSkFNRElUQ08iLCAiZmxhZyI6IG51bGwsICJodHRwX2xpbmthZ2UudXJsIjogImh0dHBzOi8vZHdyLnN0YXRlLmNvLnVzL1N1cmZhY2VXYXRlci9kYXRhL2RldGFpbF9ncmFwaC5hc3B4P0lEPUpBTURJVENPXHUwMDI2TVRZUEU9RElTQ0hSRyIsICJsb2NhdGlvbi5sYXRpdHVkZSI6IDQwLjE4ODU3OSwgImxvY2F0aW9uLmxvbmdpdHVkZSI6IC0xMDUuMjA5MjgyLCAibG9jYXRpb24ubmVlZHNfcmVjb2RpbmciOiBmYWxzZSwgInN0YWdlIjogIjAuMDQiLCAic3RhdGlvbl9uYW1lIjogIkpBTUVTIERJVENIIiwgInN0YXRpb25fc3RhdHVzIjogIkFjdGl2ZSIsICJzdGF0aW9uX3R5cGUiOiAiRGl2ZXJzaW9uIiwgInVzZ3Nfc3RhdGlvbl9pZCI6IG51bGwsICJ2YXJpYWJsZSI6ICJESVNDSFJHIiwgIndkIjogIjUifSwgInR5cGUiOiAiRmVhdHVyZSJ9LCB7ImJib3giOiBbLTEwNS4xOTMwNDgsIDQwLjA1MzAzNSwgLTEwNS4xOTMwNDgsIDQwLjA1MzAzNV0sICJnZW9tZXRyeSI6IHsiY29vcmRpbmF0ZXMiOiBbLTEwNS4xOTMwNDgsIDQwLjA1MzAzNV0sICJ0eXBlIjogIlBvaW50In0sICJpZCI6ICI0MSIsICJwcm9wZXJ0aWVzIjogeyJhbW91bnQiOiAiMC4wMCIsICJjb3VudHkiOiAiQk9VTERFUiIsICJkYXRhX3NvdXJjZSI6ICJOb3J0aGVybiBDb2xvcmFkbyBXYXRlciBDb25zZXJ2YW5jeSBEaXN0cmljdCIsICJkYXRlX3RpbWUiOiAiMjAyMC0wMy0yNFQxNTowMDowMC4wMDAiLCAiZGl2IjogIjEiLCAiZHdyX2FiYnJldiI6ICJCQ1NDQkNDTyIsICJmbGFnIjogbnVsbCwgImh0dHBfbGlua2FnZS51cmwiOiAiaHR0cDovL3d3dy5ub3J0aGVybndhdGVyLm9yZy9XYXRlclByb2plY3RzL1dhdGVyRGF0YS5hc3B4RWFzdFNsb3BlV2F0ZXJEYXRhLmFzcHgiLCAibG9jYXRpb24ubGF0aXR1ZGUiOiA0MC4wNTMwMzUsICJsb2NhdGlvbi5sb25naXR1ZGUiOiAtMTA1LjE5MzA0OCwgImxvY2F0aW9uLm5lZWRzX3JlY29kaW5nIjogZmFsc2UsICJzdGFnZSI6ICIwLjAwIiwgInN0YXRpb25fbmFtZSI6ICJCT1VMREVSIENSRUVLIFNVUFBMWSBDQU5BTCBUTyBCT1VMREVSIENSRUVLIE5FQVIgQk9VTERFUiIsICJzdGF0aW9uX3N0YXR1cyI6ICJBY3RpdmUiLCAic3RhdGlvbl90eXBlIjogIkRpdmVyc2lvbiIsICJ1c2dzX3N0YXRpb25faWQiOiAiRVMxOTE3IiwgInZhcmlhYmxlIjogIkRJU0NIUkciLCAid2QiOiAiNiJ9LCAidHlwZSI6ICJGZWF0dXJlIn0sIHsiYmJveCI6IFstMTA1LjE3NDk1NywgNDAuMjU4MzY3LCAtMTA1LjE3NDk1NywgNDAuMjU4MzY3XSwgImdlb21ldHJ5IjogeyJjb29yZGluYXRlcyI6IFstMTA1LjE3NDk1NywgNDAuMjU4MzY3XSwgInR5cGUiOiAiUG9pbnQifSwgImlkIjogIjQyIiwgInByb3BlcnRpZXMiOiB7ImFtb3VudCI6ICIwLjAwIiwgImNvdW50eSI6ICJCT1VMREVSIiwgImRhdGFfc291cmNlIjogIkNvLiBEaXZpc2lvbiBvZiBXYXRlciBSZXNvdXJjZXMiLCAiZGF0ZV90aW1lIjogIjIwMjAtMDMtMjRUMTU6MzA6MDAuMDAwIiwgImRpdiI6ICIxIiwgImR3cl9hYmJyZXYiOiAiQk9VTEFSQ08iLCAiZmxhZyI6IG51bGwsICJodHRwX2xpbmthZ2UudXJsIjogImh0dHBzOi8vZHdyLnN0YXRlLmNvLnVzL1N1cmZhY2VXYXRlci9kYXRhL2RldGFpbF9ncmFwaC5hc3B4P0lEPUJPVUxBUkNPXHUwMDI2TVRZUEU9RElTQ0hSRyIsICJsb2NhdGlvbi5sYXRpdHVkZSI6IDQwLjI1ODM2NywgImxvY2F0aW9uLmxvbmdpdHVkZSI6IC0xMDUuMTc0OTU3LCAibG9jYXRpb24ubmVlZHNfcmVjb2RpbmciOiBmYWxzZSwgInN0YWdlIjogIi0wLjEyIiwgInN0YXRpb25fbmFtZSI6ICJCT1VMREVSLUxBUklNRVIgRElUQ0ggTkVBUiBCRVJUSE9VRCIsICJzdGF0aW9uX3N0YXR1cyI6ICJBY3RpdmUiLCAic3RhdGlvbl90eXBlIjogIkRpdmVyc2lvbiIsICJ1c2dzX3N0YXRpb25faWQiOiBudWxsLCAidmFyaWFibGUiOiAiRElTQ0hSRyIsICJ3ZCI6ICI0In0sICJ0eXBlIjogIkZlYXR1cmUifSwgeyJiYm94IjogWy0xMDUuMzQ3OTA2LCAzOS45MzgzNTEsIC0xMDUuMzQ3OTA2LCAzOS45MzgzNTFdLCAiZ2VvbWV0cnkiOiB7ImNvb3JkaW5hdGVzIjogWy0xMDUuMzQ3OTA2LCAzOS45MzgzNTFdLCAidHlwZSI6ICJQb2ludCJ9LCAiaWQiOiAiNDMiLCAicHJvcGVydGllcyI6IHsiYW1vdW50IjogIjE2LjQwIiwgImNvdW50eSI6ICJCT1VMREVSIiwgImRhdGFfc291cmNlIjogIkNvLiBEaXZpc2lvbiBvZiBXYXRlciBSZXNvdXJjZXMiLCAiZGF0ZV90aW1lIjogIjIwMjAtMDMtMjRUMTU6MTU6MDAuMDAwIiwgImRpdiI6ICIxIiwgImR3cl9hYmJyZXYiOiAiQk9DQkdSQ08iLCAiZmxhZyI6IG51bGwsICJodHRwX2xpbmthZ2UudXJsIjogImh0dHBzOi8vZHdyLnN0YXRlLmNvLnVzL1N1cmZhY2VXYXRlci9kYXRhL2RldGFpbF9ncmFwaC5hc3B4P0lEPUJPQ0JHUkNPXHUwMDI2TVRZUEU9RElTQ0hSRyIsICJsb2NhdGlvbi5sYXRpdHVkZSI6IDM5LjkzODM1MSwgImxvY2F0aW9uLmxvbmdpdHVkZSI6IC0xMDUuMzQ3OTA2LCAibG9jYXRpb24ubmVlZHNfcmVjb2RpbmciOiBmYWxzZSwgInN0YWdlIjogIjAuMzYiLCAic3RhdGlvbl9uYW1lIjogIlNPVVRIIEJPVUxERVIgQ1JFRUsgQkVMT1cgR1JPU1MgUkVTRVJWT0lSIiwgInN0YXRpb25fc3RhdHVzIjogIkFjdGl2ZSIsICJzdGF0aW9uX3R5cGUiOiAiU3RyZWFtIiwgInVzZ3Nfc3RhdGlvbl9pZCI6ICIwNjcyOTQ1MCIsICJ2YXJpYWJsZSI6ICJESVNDSFJHIiwgIndkIjogIjYifSwgInR5cGUiOiAiRmVhdHVyZSJ9LCB7ImJib3giOiBbLTEwNS4yNTE4MjYsIDQwLjIxMjUwNSwgLTEwNS4yNTE4MjYsIDQwLjIxMjUwNV0sICJnZW9tZXRyeSI6IHsiY29vcmRpbmF0ZXMiOiBbLTEwNS4yNTE4MjYsIDQwLjIxMjUwNV0sICJ0eXBlIjogIlBvaW50In0sICJpZCI6ICI0NCIsICJwcm9wZXJ0aWVzIjogeyJhbW91bnQiOiAiMS4wOCIsICJjb3VudHkiOiAiQk9VTERFUiIsICJkYXRhX3NvdXJjZSI6ICJDb29wZXJhdGl2ZSBQcm9ncmFtIG9mIENEV1IsIE5DV0NEIFx1MDAyNiBTVkxIV0NEIiwgImRhdGVfdGltZSI6ICIyMDIwLTAzLTI0VDE1OjAwOjAwLjAwMCIsICJkaXYiOiAiMSIsICJkd3JfYWJicmV2IjogIlBBTERJVENPIiwgImZsYWciOiBudWxsLCAiaHR0cF9saW5rYWdlLnVybCI6ICJodHRwczovL2R3ci5zdGF0ZS5jby51cy9TdXJmYWNlV2F0ZXIvZGF0YS9kZXRhaWxfZ3JhcGguYXNweD9JRD1QQUxESVRDT1x1MDAyNk1UWVBFPURJU0NIUkciLCAibG9jYXRpb24ubGF0aXR1ZGUiOiA0MC4yMTI1MDUsICJsb2NhdGlvbi5sb25naXR1ZGUiOiAtMTA1LjI1MTgyNiwgImxvY2F0aW9uLm5lZWRzX3JlY29kaW5nIjogZmFsc2UsICJzdGFnZSI6ICIwLjEyIiwgInN0YXRpb25fbmFtZSI6ICJQQUxNRVJUT04gRElUQ0giLCAic3RhdGlvbl9zdGF0dXMiOiAiQWN0aXZlIiwgInN0YXRpb25fdHlwZSI6ICJEaXZlcnNpb24iLCAidXNnc19zdGF0aW9uX2lkIjogbnVsbCwgInZhcmlhYmxlIjogIkRJU0NIUkciLCAid2QiOiAiNSJ9LCAidHlwZSI6ICJGZWF0dXJlIn0sIHsiYmJveCI6IFstMTA1LjI1OTc5NSwgNDAuMjE5MDQ2LCAtMTA1LjI1OTc5NSwgNDAuMjE5MDQ2XSwgImdlb21ldHJ5IjogeyJjb29yZGluYXRlcyI6IFstMTA1LjI1OTc5NSwgNDAuMjE5MDQ2XSwgInR5cGUiOiAiUG9pbnQifSwgImlkIjogIjQ1IiwgInByb3BlcnRpZXMiOiB7ImFtb3VudCI6ICIwLjAwIiwgImNvdW50eSI6ICJCT1VMREVSIiwgImRhdGFfc291cmNlIjogIkNvb3BlcmF0aXZlIFByb2dyYW0gb2YgQ0RXUiwgTkNXQ0QgXHUwMDI2IFNWTEhXQ0QiLCAiZGF0ZV90aW1lIjogIjIwMjAtMDMtMjRUMTQ6NDU6MDAuMDAwIiwgImRpdiI6ICIxIiwgImR3cl9hYmJyZXYiOiAiU1VQRElUQ08iLCAiZmxhZyI6IG51bGwsICJodHRwX2xpbmthZ2UudXJsIjogImh0dHBzOi8vZHdyLnN0YXRlLmNvLnVzL1N1cmZhY2VXYXRlci9kYXRhL2RldGFpbF9ncmFwaC5hc3B4P0lEPVNVUERJVENPXHUwMDI2TVRZUEU9RElTQ0hSRyIsICJsb2NhdGlvbi5sYXRpdHVkZSI6IDQwLjIxOTA0NiwgImxvY2F0aW9uLmxvbmdpdHVkZSI6IC0xMDUuMjU5Nzk1LCAibG9jYXRpb24ubmVlZHNfcmVjb2RpbmciOiBmYWxzZSwgInN0YWdlIjogIjAuMDAiLCAic3RhdGlvbl9uYW1lIjogIlNVUFBMWSBESVRDSCIsICJzdGF0aW9uX3N0YXR1cyI6ICJBY3RpdmUiLCAic3RhdGlvbl90eXBlIjogIkRpdmVyc2lvbiIsICJ1c2dzX3N0YXRpb25faWQiOiBudWxsLCAidmFyaWFibGUiOiAiRElTQ0hSRyIsICJ3ZCI6ICI1In0sICJ0eXBlIjogIkZlYXR1cmUifSwgeyJiYm94IjogWy0xMDUuMTg5MTkxLCA0MC4xODc1NzgsIC0xMDUuMTg5MTkxLCA0MC4xODc1NzhdLCAiZ2VvbWV0cnkiOiB7ImNvb3JkaW5hdGVzIjogWy0xMDUuMTg5MTkxLCA0MC4xODc1NzhdLCAidHlwZSI6ICJQb2ludCJ9LCAiaWQiOiAiNDYiLCAicHJvcGVydGllcyI6IHsiYW1vdW50IjogIjI4MTkuNjgiLCAiY291bnR5IjogIkJPVUxERVIiLCAiZGF0YV9zb3VyY2UiOiAiQ29vcGVyYXRpdmUgUHJvZ3JhbSBvZiBDRFdSLCBOQ1dDRCBcdTAwMjYgU1ZMSFdDRCIsICJkYXRlX3RpbWUiOiAiMjAyMC0wMy0yNFQxNTowMDowMC4wMDAiLCAiZGl2IjogIjEiLCAiZHdyX2FiYnJldiI6ICJERU5UQVlDTyIsICJmbGFnIjogbnVsbCwgImh0dHBfbGlua2FnZS51cmwiOiAiaHR0cHM6Ly9kd3Iuc3RhdGUuY28udXMvU3VyZmFjZVdhdGVyL2RhdGEvZGV0YWlsX2dyYXBoLmFzcHg/SUQ9REVOVEFZQ09cdTAwMjZNVFlQRT1ESVNDSFJHIiwgImxvY2F0aW9uLmxhdGl0dWRlIjogNDAuMTg3NTc4LCAibG9jYXRpb24ubG9uZ2l0dWRlIjogLTEwNS4xODkxOTEsICJsb2NhdGlvbi5uZWVkc19yZWNvZGluZyI6IGZhbHNlLCAic3RhZ2UiOiAiNjIuMzEiLCAic3RhdGlvbl9uYW1lIjogIkRFTklPIFRBWUxPUiBESVRDSCIsICJzdGF0aW9uX3N0YXR1cyI6ICJBY3RpdmUiLCAic3RhdGlvbl90eXBlIjogIkRpdmVyc2lvbiIsICJ1c2dzX3N0YXRpb25faWQiOiBudWxsLCAidmFyaWFibGUiOiAiRElTQ0hSRyIsICJ3ZCI6ICI1In0sICJ0eXBlIjogIkZlYXR1cmUifSwgeyJiYm94IjogWy0xMDUuMzY0OTE3MDAwMDAwMDIsIDQwLjA0MjAyOCwgLTEwNS4zNjQ5MTcwMDAwMDAwMiwgNDAuMDQyMDI4XSwgImdlb21ldHJ5IjogeyJjb29yZGluYXRlcyI6IFstMTA1LjM2NDkxNzAwMDAwMDAyLCA0MC4wNDIwMjhdLCAidHlwZSI6ICJQb2ludCJ9LCAiaWQiOiAiNDciLCAicHJvcGVydGllcyI6IHsiYW1vdW50IjogbnVsbCwgImNvdW50eSI6ICJCT1VMREVSIiwgImRhdGFfc291cmNlIjogIlUuUy4gR2VvbG9naWNhbCBTdXJ2ZXkiLCAiZGF0ZV90aW1lIjogIjE5OTktMDktMzBUMDA6MDA6MDAuMDAwIiwgImRpdiI6ICIxIiwgImR3cl9hYmJyZXYiOiAiRlJNTE1SQ08iLCAiZmxhZyI6IG51bGwsICJodHRwX2xpbmthZ2UudXJsIjogImh0dHBzOi8vd2F0ZXJkYXRhLnVzZ3MuZ292L253aXMvdXY/MDY3Mjc0MTAiLCAibG9jYXRpb24ubGF0aXR1ZGUiOiA0MC4wNDIwMjgsICJsb2NhdGlvbi5sb25naXR1ZGUiOiAtMTA1LjM2NDkxNywgImxvY2F0aW9uLm5lZWRzX3JlY29kaW5nIjogZmFsc2UsICJzdGFnZSI6IG51bGwsICJzdGF0aW9uX25hbWUiOiAiRk9VUk1JTEUgQ1JFRUsgQVQgTE9HQU4gTUlMTCBST0FEIE5FQVIgQ1JJU01BTiwgQ08iLCAic3RhdGlvbl9zdGF0dXMiOiAiQWN0aXZlIiwgInN0YXRpb25fdHlwZSI6ICJTdHJlYW0iLCAidXNnc19zdGF0aW9uX2lkIjogIjA2NzI3NDEwIiwgInZhcmlhYmxlIjogIkRJU0NIUkciLCAid2QiOiAiNiJ9LCAidHlwZSI6ICJGZWF0dXJlIn0sIHsiYmJveCI6IFstMTA1LjE3ODU2NywgNDAuMTc3MDgwMDAwMDAwMDA0LCAtMTA1LjE3ODU2NywgNDAuMTc3MDgwMDAwMDAwMDA0XSwgImdlb21ldHJ5IjogeyJjb29yZGluYXRlcyI6IFstMTA1LjE3ODU2NywgNDAuMTc3MDgwMDAwMDAwMDA0XSwgInR5cGUiOiAiUG9pbnQifSwgImlkIjogIjQ4IiwgInByb3BlcnRpZXMiOiB7ImFtb3VudCI6ICIxLjI5IiwgImNvdW50eSI6ICJCT1VMREVSIiwgImRhdGFfc291cmNlIjogIkNvb3BlcmF0aXZlIFNEUiBQcm9ncmFtIG9mIENEV1IgXHUwMDI2IE5DV0NEIiwgImRhdGVfdGltZSI6ICIyMDIwLTAzLTI0VDE1OjAwOjAwLjAwMCIsICJkaXYiOiAiMSIsICJkd3JfYWJicmV2IjogIlBDS1BFTENPIiwgImZsYWciOiBudWxsLCAiaHR0cF9saW5rYWdlLnVybCI6ICJodHRwczovL2R3ci5zdGF0ZS5jby51cy9TdXJmYWNlV2F0ZXIvZGF0YS9kZXRhaWxfZ3JhcGguYXNweD9JRD1QQ0tQRUxDT1x1MDAyNk1UWVBFPURJU0NIUkciLCAibG9jYXRpb24ubGF0aXR1ZGUiOiA0MC4xNzcwOCwgImxvY2F0aW9uLmxvbmdpdHVkZSI6IC0xMDUuMTc4NTY3LCAibG9jYXRpb24ubmVlZHNfcmVjb2RpbmciOiBmYWxzZSwgInN0YWdlIjogIjAuMTYiLCAic3RhdGlvbl9uYW1lIjogIlBFQ0sgUEVMTEEgQ0xPVkVSIERJVENIIiwgInN0YXRpb25fc3RhdHVzIjogIkFjdGl2ZSIsICJzdGF0aW9uX3R5cGUiOiAiRGl2ZXJzaW9uIiwgInVzZ3Nfc3RhdGlvbl9pZCI6IG51bGwsICJ2YXJpYWJsZSI6ICJESVNDSFJHIiwgIndkIjogIjUifSwgInR5cGUiOiAiRmVhdHVyZSJ9LCB7ImJib3giOiBbLTEwNS4zNTczMDgsIDM5Ljk0NzcwNCwgLTEwNS4zNTczMDgsIDM5Ljk0NzcwNF0sICJnZW9tZXRyeSI6IHsiY29vcmRpbmF0ZXMiOiBbLTEwNS4zNTczMDgsIDM5Ljk0NzcwNF0sICJ0eXBlIjogIlBvaW50In0sICJpZCI6ICI0OSIsICJwcm9wZXJ0aWVzIjogeyJhbW91bnQiOiAiMTEzNjguMDAiLCAiY291bnR5IjogIkJPVUxERVIiLCAiZGF0YV9zb3VyY2UiOiAiQ28uIERpdmlzaW9uIG9mIFdhdGVyIFJlc291cmNlcyIsICJkYXRlX3RpbWUiOiAiMjAyMC0wMy0yNFQxNTozMDowMC4wMDAiLCAiZGl2IjogIjEiLCAiZHdyX2FiYnJldiI6ICJHUk9TUkVDTyIsICJmbGFnIjogbnVsbCwgImh0dHBfbGlua2FnZS51cmwiOiAiaHR0cHM6Ly9kd3Iuc3RhdGUuY28udXMvU3VyZmFjZVdhdGVyL2RhdGEvZGV0YWlsX2dyYXBoLmFzcHg/SUQ9R1JPU1JFQ09cdTAwMjZNVFlQRT1TVE9SQUdFIiwgImxvY2F0aW9uLmxhdGl0dWRlIjogMzkuOTQ3NzA0LCAibG9jYXRpb24ubG9uZ2l0dWRlIjogLTEwNS4zNTczMDgsICJsb2NhdGlvbi5uZWVkc19yZWNvZGluZyI6IGZhbHNlLCAic3RhZ2UiOiAiNzE3NS42MiIsICJzdGF0aW9uX25hbWUiOiAiR1JPU1MgUkVTRVJWT0lSICIsICJzdGF0aW9uX3N0YXR1cyI6ICJBY3RpdmUiLCAic3RhdGlvbl90eXBlIjogIlJlc2Vydm9pciIsICJ1c2dzX3N0YXRpb25faWQiOiBudWxsLCAidmFyaWFibGUiOiAiU1RPUkFHRSIsICJ3ZCI6ICI2In0sICJ0eXBlIjogIkZlYXR1cmUifV0sICJ0eXBlIjogIkZlYXR1cmVDb2xsZWN0aW9uIn0pOwogICAgICAgIAo8L3NjcmlwdD4=" style="position:absolute;width:100%;height:100%;left:0;top:0;border:none !important;" allowfullscreen webkitallowfullscreen mozallowfullscreen></iframe></div></div>





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



<div style="width:100%;"><div style="position:relative;width:100%;height:0;padding-bottom:60%;"><iframe src="data:text/html;charset=utf-8;base64,PCFET0NUWVBFIGh0bWw+CjxoZWFkPiAgICAKICAgIDxtZXRhIGh0dHAtZXF1aXY9ImNvbnRlbnQtdHlwZSIgY29udGVudD0idGV4dC9odG1sOyBjaGFyc2V0PVVURi04IiAvPgogICAgCiAgICAgICAgPHNjcmlwdD4KICAgICAgICAgICAgTF9OT19UT1VDSCA9IGZhbHNlOwogICAgICAgICAgICBMX0RJU0FCTEVfM0QgPSBmYWxzZTsKICAgICAgICA8L3NjcmlwdD4KICAgIAogICAgPHNjcmlwdCBzcmM9Imh0dHBzOi8vY2RuLmpzZGVsaXZyLm5ldC9ucG0vbGVhZmxldEAxLjUuMS9kaXN0L2xlYWZsZXQuanMiPjwvc2NyaXB0PgogICAgPHNjcmlwdCBzcmM9Imh0dHBzOi8vY29kZS5qcXVlcnkuY29tL2pxdWVyeS0xLjEyLjQubWluLmpzIj48L3NjcmlwdD4KICAgIDxzY3JpcHQgc3JjPSJodHRwczovL21heGNkbi5ib290c3RyYXBjZG4uY29tL2Jvb3RzdHJhcC8zLjIuMC9qcy9ib290c3RyYXAubWluLmpzIj48L3NjcmlwdD4KICAgIDxzY3JpcHQgc3JjPSJodHRwczovL2NkbmpzLmNsb3VkZmxhcmUuY29tL2FqYXgvbGlicy9MZWFmbGV0LmF3ZXNvbWUtbWFya2Vycy8yLjAuMi9sZWFmbGV0LmF3ZXNvbWUtbWFya2Vycy5qcyI+PC9zY3JpcHQ+CiAgICA8bGluayByZWw9InN0eWxlc2hlZXQiIGhyZWY9Imh0dHBzOi8vY2RuLmpzZGVsaXZyLm5ldC9ucG0vbGVhZmxldEAxLjUuMS9kaXN0L2xlYWZsZXQuY3NzIi8+CiAgICA8bGluayByZWw9InN0eWxlc2hlZXQiIGhyZWY9Imh0dHBzOi8vbWF4Y2RuLmJvb3RzdHJhcGNkbi5jb20vYm9vdHN0cmFwLzMuMi4wL2Nzcy9ib290c3RyYXAubWluLmNzcyIvPgogICAgPGxpbmsgcmVsPSJzdHlsZXNoZWV0IiBocmVmPSJodHRwczovL21heGNkbi5ib290c3RyYXBjZG4uY29tL2Jvb3RzdHJhcC8zLjIuMC9jc3MvYm9vdHN0cmFwLXRoZW1lLm1pbi5jc3MiLz4KICAgIDxsaW5rIHJlbD0ic3R5bGVzaGVldCIgaHJlZj0iaHR0cHM6Ly9tYXhjZG4uYm9vdHN0cmFwY2RuLmNvbS9mb250LWF3ZXNvbWUvNC42LjMvY3NzL2ZvbnQtYXdlc29tZS5taW4uY3NzIi8+CiAgICA8bGluayByZWw9InN0eWxlc2hlZXQiIGhyZWY9Imh0dHBzOi8vY2RuanMuY2xvdWRmbGFyZS5jb20vYWpheC9saWJzL0xlYWZsZXQuYXdlc29tZS1tYXJrZXJzLzIuMC4yL2xlYWZsZXQuYXdlc29tZS1tYXJrZXJzLmNzcyIvPgogICAgPGxpbmsgcmVsPSJzdHlsZXNoZWV0IiBocmVmPSJodHRwczovL3Jhd2Nkbi5naXRoYWNrLmNvbS9weXRob24tdmlzdWFsaXphdGlvbi9mb2xpdW0vbWFzdGVyL2ZvbGl1bS90ZW1wbGF0ZXMvbGVhZmxldC5hd2Vzb21lLnJvdGF0ZS5jc3MiLz4KICAgIDxzdHlsZT5odG1sLCBib2R5IHt3aWR0aDogMTAwJTtoZWlnaHQ6IDEwMCU7bWFyZ2luOiAwO3BhZGRpbmc6IDA7fTwvc3R5bGU+CiAgICA8c3R5bGU+I21hcCB7cG9zaXRpb246YWJzb2x1dGU7dG9wOjA7Ym90dG9tOjA7cmlnaHQ6MDtsZWZ0OjA7fTwvc3R5bGU+CiAgICAKICAgICAgICAgICAgPG1ldGEgbmFtZT0idmlld3BvcnQiIGNvbnRlbnQ9IndpZHRoPWRldmljZS13aWR0aCwKICAgICAgICAgICAgICAgIGluaXRpYWwtc2NhbGU9MS4wLCBtYXhpbXVtLXNjYWxlPTEuMCwgdXNlci1zY2FsYWJsZT1ubyIgLz4KICAgICAgICAgICAgPHN0eWxlPgogICAgICAgICAgICAgICAgI21hcF85OTQ4ZDljMDU2MzA0ODI2YWQ3ODI0NmU4MmMwMzU0MCB7CiAgICAgICAgICAgICAgICAgICAgcG9zaXRpb246IHJlbGF0aXZlOwogICAgICAgICAgICAgICAgICAgIHdpZHRoOiAxMDAuMCU7CiAgICAgICAgICAgICAgICAgICAgaGVpZ2h0OiAxMDAuMCU7CiAgICAgICAgICAgICAgICAgICAgbGVmdDogMC4wJTsKICAgICAgICAgICAgICAgICAgICB0b3A6IDAuMCU7CiAgICAgICAgICAgICAgICB9CiAgICAgICAgICAgIDwvc3R5bGU+CiAgICAgICAgCiAgICA8c2NyaXB0IHNyYz0iaHR0cHM6Ly9jZG5qcy5jbG91ZGZsYXJlLmNvbS9hamF4L2xpYnMvbGVhZmxldC5tYXJrZXJjbHVzdGVyLzEuMS4wL2xlYWZsZXQubWFya2VyY2x1c3Rlci5qcyI+PC9zY3JpcHQ+CiAgICA8bGluayByZWw9InN0eWxlc2hlZXQiIGhyZWY9Imh0dHBzOi8vY2RuanMuY2xvdWRmbGFyZS5jb20vYWpheC9saWJzL2xlYWZsZXQubWFya2VyY2x1c3Rlci8xLjEuMC9NYXJrZXJDbHVzdGVyLmNzcyIvPgogICAgPGxpbmsgcmVsPSJzdHlsZXNoZWV0IiBocmVmPSJodHRwczovL2NkbmpzLmNsb3VkZmxhcmUuY29tL2FqYXgvbGlicy9sZWFmbGV0Lm1hcmtlcmNsdXN0ZXIvMS4xLjAvTWFya2VyQ2x1c3Rlci5EZWZhdWx0LmNzcyIvPgo8L2hlYWQ+Cjxib2R5PiAgICAKICAgIAogICAgICAgICAgICA8ZGl2IGNsYXNzPSJmb2xpdW0tbWFwIiBpZD0ibWFwXzk5NDhkOWMwNTYzMDQ4MjZhZDc4MjQ2ZTgyYzAzNTQwIiA+PC9kaXY+CiAgICAgICAgCjwvYm9keT4KPHNjcmlwdD4gICAgCiAgICAKICAgICAgICAgICAgdmFyIG1hcF85OTQ4ZDljMDU2MzA0ODI2YWQ3ODI0NmU4MmMwMzU0MCA9IEwubWFwKAogICAgICAgICAgICAgICAgIm1hcF85OTQ4ZDljMDU2MzA0ODI2YWQ3ODI0NmU4MmMwMzU0MCIsCiAgICAgICAgICAgICAgICB7CiAgICAgICAgICAgICAgICAgICAgY2VudGVyOiBbNDAuMDEsIC0xMDUuMjddLAogICAgICAgICAgICAgICAgICAgIGNyczogTC5DUlMuRVBTRzM4NTcsCiAgICAgICAgICAgICAgICAgICAgem9vbTogMTAsCiAgICAgICAgICAgICAgICAgICAgem9vbUNvbnRyb2w6IHRydWUsCiAgICAgICAgICAgICAgICAgICAgcHJlZmVyQ2FudmFzOiBmYWxzZSwKICAgICAgICAgICAgICAgIH0KICAgICAgICAgICAgKTsKCiAgICAgICAgICAgIAoKICAgICAgICAKICAgIAogICAgICAgICAgICB2YXIgdGlsZV9sYXllcl85NmQ4OTQ3ZGVkMjc0MTlhOTY4ZTZiM2FhNTRkNmU5OSA9IEwudGlsZUxheWVyKAogICAgICAgICAgICAgICAgImh0dHBzOi8vY2FydG9kYi1iYXNlbWFwcy17c30uZ2xvYmFsLnNzbC5mYXN0bHkubmV0L2xpZ2h0X2FsbC97en0ve3h9L3t5fS5wbmciLAogICAgICAgICAgICAgICAgeyJhdHRyaWJ1dGlvbiI6ICJcdTAwMjZjb3B5OyBcdTAwM2NhIGhyZWY9XCJodHRwOi8vd3d3Lm9wZW5zdHJlZXRtYXAub3JnL2NvcHlyaWdodFwiXHUwMDNlT3BlblN0cmVldE1hcFx1MDAzYy9hXHUwMDNlIGNvbnRyaWJ1dG9ycyBcdTAwMjZjb3B5OyBcdTAwM2NhIGhyZWY9XCJodHRwOi8vY2FydG9kYi5jb20vYXR0cmlidXRpb25zXCJcdTAwM2VDYXJ0b0RCXHUwMDNjL2FcdTAwM2UsIENhcnRvREIgXHUwMDNjYSBocmVmID1cImh0dHA6Ly9jYXJ0b2RiLmNvbS9hdHRyaWJ1dGlvbnNcIlx1MDAzZWF0dHJpYnV0aW9uc1x1MDAzYy9hXHUwMDNlIiwgImRldGVjdFJldGluYSI6IGZhbHNlLCAibWF4TmF0aXZlWm9vbSI6IDE4LCAibWF4Wm9vbSI6IDE4LCAibWluWm9vbSI6IDAsICJub1dyYXAiOiBmYWxzZSwgIm9wYWNpdHkiOiAxLCAic3ViZG9tYWlucyI6ICJhYmMiLCAidG1zIjogZmFsc2V9CiAgICAgICAgICAgICkuYWRkVG8obWFwXzk5NDhkOWMwNTYzMDQ4MjZhZDc4MjQ2ZTgyYzAzNTQwKTsKICAgICAgICAKICAgIAogICAgICAgICAgICB2YXIgbWFya2VyX2NsdXN0ZXJfY2E5YTQ2ODQxM2FiNGI0YWIwNTJiOWIxN2ViNDg5ZDAgPSBMLm1hcmtlckNsdXN0ZXJHcm91cCgKICAgICAgICAgICAgICAgIHt9CiAgICAgICAgICAgICk7CiAgICAgICAgICAgIG1hcF85OTQ4ZDljMDU2MzA0ODI2YWQ3ODI0NmU4MmMwMzU0MC5hZGRMYXllcihtYXJrZXJfY2x1c3Rlcl9jYTlhNDY4NDEzYWI0YjRhYjA1MmI5YjE3ZWI0ODlkMCk7CiAgICAgICAgCiAgICAKICAgICAgICAgICAgdmFyIG1hcmtlcl9kNzJiY2U5YmI2YzA0MmFlYjE1YWRjNDQzZTJmNjQ4MSA9IEwubWFya2VyKAogICAgICAgICAgICAgICAgWzQwLjE4NTAzMywgLTEwNS4xODU3ODldLAogICAgICAgICAgICAgICAge30KICAgICAgICAgICAgKS5hZGRUbyhtYXJrZXJfY2x1c3Rlcl9jYTlhNDY4NDEzYWI0YjRhYjA1MmI5YjE3ZWI0ODlkMCk7CiAgICAgICAgCiAgICAKICAgICAgICB2YXIgcG9wdXBfNGM1MjVkMDY2MTljNGIwOWExZjQ0NzQ3YTU5MDQ1MWMgPSBMLnBvcHVwKHsibWF4V2lkdGgiOiAiMTAwJSJ9KTsKCiAgICAgICAgCiAgICAgICAgICAgIHZhciBodG1sXzA4ZDE3ZDE1NzRjOTRjYmM4YmY0ZmI5M2Y1Y2M0YTFiID0gJChgPGRpdiBpZD0iaHRtbF8wOGQxN2QxNTc0Yzk0Y2JjOGJmNGZiOTNmNWNjNGExYiIgc3R5bGU9IndpZHRoOiAxMDAuMCU7IGhlaWdodDogMTAwLjAlOyI+TmFtZTogWldFQ0sgQU5EIFRVUk5FUiBESVRDSCBQcmVjaXA6IDAuMTQ8L2Rpdj5gKVswXTsKICAgICAgICAgICAgcG9wdXBfNGM1MjVkMDY2MTljNGIwOWExZjQ0NzQ3YTU5MDQ1MWMuc2V0Q29udGVudChodG1sXzA4ZDE3ZDE1NzRjOTRjYmM4YmY0ZmI5M2Y1Y2M0YTFiKTsKICAgICAgICAKCiAgICAgICAgbWFya2VyX2Q3MmJjZTliYjZjMDQyYWViMTVhZGM0NDNlMmY2NDgxLmJpbmRQb3B1cChwb3B1cF80YzUyNWQwNjYxOWM0YjA5YTFmNDQ3NDdhNTkwNDUxYykKICAgICAgICA7CgogICAgICAgIAogICAgCiAgICAKICAgICAgICAgICAgdmFyIG1hcmtlcl8wMzg5N2YyMmIzYzE0NWJiYTY3NmQ0YTBiOTEyNjcyOCA9IEwubWFya2VyKAogICAgICAgICAgICAgICAgWzQwLjIyMDcwMiwgLTEwNS4yNjM0OV0sCiAgICAgICAgICAgICAgICB7fQogICAgICAgICAgICApLmFkZFRvKG1hcmtlcl9jbHVzdGVyX2NhOWE0Njg0MTNhYjRiNGFiMDUyYjliMTdlYjQ4OWQwKTsKICAgICAgICAKICAgIAogICAgICAgIHZhciBwb3B1cF83YmQxODk4ZTQ4MTg0ZWIyYjY3NmZkZmRjMDBmYjc2YSA9IEwucG9wdXAoeyJtYXhXaWR0aCI6ICIxMDAlIn0pOwoKICAgICAgICAKICAgICAgICAgICAgdmFyIGh0bWxfMmM3MGY3NmNhNzFjNDExNjllYzFjMjJiNDE4OTQ5YzQgPSAkKGA8ZGl2IGlkPSJodG1sXzJjNzBmNzZjYTcxYzQxMTY5ZWMxYzIyYjQxODk0OWM0IiBzdHlsZT0id2lkdGg6IDEwMC4wJTsgaGVpZ2h0OiAxMDAuMCU7Ij5OYW1lOiBTQUlOVCBWUkFJTiBDUkVFSyBBVCBMWU9OUywgQ08gUHJlY2lwOiAzOS4yMDwvZGl2PmApWzBdOwogICAgICAgICAgICBwb3B1cF83YmQxODk4ZTQ4MTg0ZWIyYjY3NmZkZmRjMDBmYjc2YS5zZXRDb250ZW50KGh0bWxfMmM3MGY3NmNhNzFjNDExNjllYzFjMjJiNDE4OTQ5YzQpOwogICAgICAgIAoKICAgICAgICBtYXJrZXJfMDM4OTdmMjJiM2MxNDViYmE2NzZkNGEwYjkxMjY3MjguYmluZFBvcHVwKHBvcHVwXzdiZDE4OThlNDgxODRlYjJiNjc2ZmRmZGMwMGZiNzZhKQogICAgICAgIDsKCiAgICAgICAgCiAgICAKICAgIAogICAgICAgICAgICB2YXIgbWFya2VyXzE4M2UwMTNmZmFiMzRhMmQ4YjA1NjI1OTNhODlkODU1ID0gTC5tYXJrZXIoCiAgICAgICAgICAgICAgICBbNDAuMTk2NDIyLCAtMTA1LjIwNjU5Ml0sCiAgICAgICAgICAgICAgICB7fQogICAgICAgICAgICApLmFkZFRvKG1hcmtlcl9jbHVzdGVyX2NhOWE0Njg0MTNhYjRiNGFiMDUyYjliMTdlYjQ4OWQwKTsKICAgICAgICAKICAgIAogICAgICAgIHZhciBwb3B1cF85MzM1Yzg2ZWIwZDc0NjQ1YTczNzU4MmJhNzY3MmIzOCA9IEwucG9wdXAoeyJtYXhXaWR0aCI6ICIxMDAlIn0pOwoKICAgICAgICAKICAgICAgICAgICAgdmFyIGh0bWxfN2ExMDVkMTQ1ODliNDBlZDliMTA3YjM1YzQ1OTUyODIgPSAkKGA8ZGl2IGlkPSJodG1sXzdhMTA1ZDE0NTg5YjQwZWQ5YjEwN2IzNWM0NTk1MjgyIiBzdHlsZT0id2lkdGg6IDEwMC4wJTsgaGVpZ2h0OiAxMDAuMCU7Ij5OYW1lOiBPTElHQVJDSFkgRElUQ0ggRElWRVJTSU9OIFByZWNpcDogMy43NTwvZGl2PmApWzBdOwogICAgICAgICAgICBwb3B1cF85MzM1Yzg2ZWIwZDc0NjQ1YTczNzU4MmJhNzY3MmIzOC5zZXRDb250ZW50KGh0bWxfN2ExMDVkMTQ1ODliNDBlZDliMTA3YjM1YzQ1OTUyODIpOwogICAgICAgIAoKICAgICAgICBtYXJrZXJfMTgzZTAxM2ZmYWIzNGEyZDhiMDU2MjU5M2E4OWQ4NTUuYmluZFBvcHVwKHBvcHVwXzkzMzVjODZlYjBkNzQ2NDVhNzM3NTgyYmE3NjcyYjM4KQogICAgICAgIDsKCiAgICAgICAgCiAgICAKICAgIAogICAgICAgICAgICB2YXIgbWFya2VyXzcxZWVjMmE3MjBkODQ1MzNhNTk1NGM3OWVlZjg5YzY0ID0gTC5tYXJrZXIoCiAgICAgICAgICAgICAgICBbMzkuOTMxODEzLCAtMTA1LjMwODQzMl0sCiAgICAgICAgICAgICAgICB7fQogICAgICAgICAgICApLmFkZFRvKG1hcmtlcl9jbHVzdGVyX2NhOWE0Njg0MTNhYjRiNGFiMDUyYjliMTdlYjQ4OWQwKTsKICAgICAgICAKICAgIAogICAgICAgIHZhciBwb3B1cF9iZjRkNTRmMDZlNDY0OGE1ODg1M2IxMTFmMDgyYTE5ZCA9IEwucG9wdXAoeyJtYXhXaWR0aCI6ICIxMDAlIn0pOwoKICAgICAgICAKICAgICAgICAgICAgdmFyIGh0bWxfZWY1MTdkZmNlZjgyNGVhZTg2ZmQ2MWYzM2ZkYWZkYTEgPSAkKGA8ZGl2IGlkPSJodG1sX2VmNTE3ZGZjZWY4MjRlYWU4NmZkNjFmMzNmZGFmZGExIiBzdHlsZT0id2lkdGg6IDEwMC4wJTsgaGVpZ2h0OiAxMDAuMCU7Ij5OYW1lOiBTT1VUSCBCT1VMREVSIENSRUVLIERJVkVSU0lPTiBORUFSIEVMRE9SQURPIFNQUklOR1MgUHJlY2lwOiAwLjAwPC9kaXY+YClbMF07CiAgICAgICAgICAgIHBvcHVwX2JmNGQ1NGYwNmU0NjQ4YTU4ODUzYjExMWYwODJhMTlkLnNldENvbnRlbnQoaHRtbF9lZjUxN2RmY2VmODI0ZWFlODZmZDYxZjMzZmRhZmRhMSk7CiAgICAgICAgCgogICAgICAgIG1hcmtlcl83MWVlYzJhNzIwZDg0NTMzYTU5NTRjNzllZWY4OWM2NC5iaW5kUG9wdXAocG9wdXBfYmY0ZDU0ZjA2ZTQ2NDhhNTg4NTNiMTExZjA4MmExOWQpCiAgICAgICAgOwoKICAgICAgICAKICAgIAogICAgCiAgICAgICAgICAgIHZhciBtYXJrZXJfMzdhNTEzZWVhOGI0NDcyMmFlODYzMzZmZWIyNDdhYjIgPSBMLm1hcmtlcigKICAgICAgICAgICAgICAgIFs0MC4xOTM3NTgsIC0xMDUuMjEwMzldLAogICAgICAgICAgICAgICAge30KICAgICAgICAgICAgKS5hZGRUbyhtYXJrZXJfY2x1c3Rlcl9jYTlhNDY4NDEzYWI0YjRhYjA1MmI5YjE3ZWI0ODlkMCk7CiAgICAgICAgCiAgICAKICAgICAgICB2YXIgcG9wdXBfMjYxYmE0YTQ2NjM2NDgxZWI2Yzc0ZTA5ZTM1OTc3MWUgPSBMLnBvcHVwKHsibWF4V2lkdGgiOiAiMTAwJSJ9KTsKCiAgICAgICAgCiAgICAgICAgICAgIHZhciBodG1sXzVkN2ZlZDhkOTY1NTQzNDVhODMzMzYxNzE5N2EzNjRmID0gJChgPGRpdiBpZD0iaHRtbF81ZDdmZWQ4ZDk2NTU0MzQ1YTgzMzM2MTcxOTdhMzY0ZiIgc3R5bGU9IndpZHRoOiAxMDAuMCU7IGhlaWdodDogMTAwLjAlOyI+TmFtZTogQ0xPVUdIIEFORCBUUlVFIERJVENIIFByZWNpcDogMC4wMDwvZGl2PmApWzBdOwogICAgICAgICAgICBwb3B1cF8yNjFiYTRhNDY2MzY0ODFlYjZjNzRlMDllMzU5NzcxZS5zZXRDb250ZW50KGh0bWxfNWQ3ZmVkOGQ5NjU1NDM0NWE4MzMzNjE3MTk3YTM2NGYpOwogICAgICAgIAoKICAgICAgICBtYXJrZXJfMzdhNTEzZWVhOGI0NDcyMmFlODYzMzZmZWIyNDdhYjIuYmluZFBvcHVwKHBvcHVwXzI2MWJhNGE0NjYzNjQ4MWViNmM3NGUwOWUzNTk3NzFlKQogICAgICAgIDsKCiAgICAgICAgCiAgICAKICAgIAogICAgICAgICAgICB2YXIgbWFya2VyX2RkODk1MTEwMTVjMTRhOWViZWQzYjkzMDRmMmU4ODA5ID0gTC5tYXJrZXIoCiAgICAgICAgICAgICAgICBbNDAuMDA2MzgsIC0xMDUuMzMwODQxXSwKICAgICAgICAgICAgICAgIHt9CiAgICAgICAgICAgICkuYWRkVG8obWFya2VyX2NsdXN0ZXJfY2E5YTQ2ODQxM2FiNGI0YWIwNTJiOWIxN2ViNDg5ZDApOwogICAgICAgIAogICAgCiAgICAgICAgdmFyIHBvcHVwXzcyOTc4NTMyNDY1ZTRkMzJhMDE5Mzc3NWZlN2NhNWNkID0gTC5wb3B1cCh7Im1heFdpZHRoIjogIjEwMCUifSk7CgogICAgICAgIAogICAgICAgICAgICB2YXIgaHRtbF83MDAwZWQ3NDcyZTM0ODY0OGZjMGEwNzQ1MDc1OGU5MSA9ICQoYDxkaXYgaWQ9Imh0bWxfNzAwMGVkNzQ3MmUzNDg2NDhmYzBhMDc0NTA3NThlOTEiIHN0eWxlPSJ3aWR0aDogMTAwLjAlOyBoZWlnaHQ6IDEwMC4wJTsiPk5hbWU6IEJPVUxERVIgQ1JFRUsgTkVBUiBPUk9ERUxMLCBDTy4gUHJlY2lwOiAyMC40MDwvZGl2PmApWzBdOwogICAgICAgICAgICBwb3B1cF83Mjk3ODUzMjQ2NWU0ZDMyYTAxOTM3NzVmZTdjYTVjZC5zZXRDb250ZW50KGh0bWxfNzAwMGVkNzQ3MmUzNDg2NDhmYzBhMDc0NTA3NThlOTEpOwogICAgICAgIAoKICAgICAgICBtYXJrZXJfZGQ4OTUxMTAxNWMxNGE5ZWJlZDNiOTMwNGYyZTg4MDkuYmluZFBvcHVwKHBvcHVwXzcyOTc4NTMyNDY1ZTRkMzJhMDE5Mzc3NWZlN2NhNWNkKQogICAgICAgIDsKCiAgICAgICAgCiAgICAKICAgIAogICAgICAgICAgICB2YXIgbWFya2VyXzdhMmQxNWJmNDA1MzRlMTI5OTY4YjdiNDgzM2M1NTBhID0gTC5tYXJrZXIoCiAgICAgICAgICAgICAgICBbNDAuMjA0MTkzLCAtMTA1LjIxODc3N10sCiAgICAgICAgICAgICAgICB7fQogICAgICAgICAgICApLmFkZFRvKG1hcmtlcl9jbHVzdGVyX2NhOWE0Njg0MTNhYjRiNGFiMDUyYjliMTdlYjQ4OWQwKTsKICAgICAgICAKICAgIAogICAgICAgIHZhciBwb3B1cF8zODUyNjRiMTk4N2I0ZDY5OGI2ZjZiODM3N2ViNzdiNiA9IEwucG9wdXAoeyJtYXhXaWR0aCI6ICIxMDAlIn0pOwoKICAgICAgICAKICAgICAgICAgICAgdmFyIGh0bWxfYjVkNzVjYjU1YzQ0NGZiMjkyYjIyZGY2ZWY5YzY2MTEgPSAkKGA8ZGl2IGlkPSJodG1sX2I1ZDc1Y2I1NWM0NDRmYjI5MmIyMmRmNmVmOWM2NjExIiBzdHlsZT0id2lkdGg6IDEwMC4wJTsgaGVpZ2h0OiAxMDAuMCU7Ij5OYW1lOiBMT05HTU9OVCBTVVBQTFkgRElUQ0ggUHJlY2lwOiAwLjAwPC9kaXY+YClbMF07CiAgICAgICAgICAgIHBvcHVwXzM4NTI2NGIxOTg3YjRkNjk4YjZmNmI4Mzc3ZWI3N2I2LnNldENvbnRlbnQoaHRtbF9iNWQ3NWNiNTVjNDQ0ZmIyOTJiMjJkZjZlZjljNjYxMSk7CiAgICAgICAgCgogICAgICAgIG1hcmtlcl83YTJkMTViZjQwNTM0ZTEyOTk2OGI3YjQ4MzNjNTUwYS5iaW5kUG9wdXAocG9wdXBfMzg1MjY0YjE5ODdiNGQ2OThiNmY2YjgzNzdlYjc3YjYpCiAgICAgICAgOwoKICAgICAgICAKICAgIAogICAgCiAgICAgICAgICAgIHZhciBtYXJrZXJfNzkxZGViMGYwZThlNGI1ZmFiNGY3OWU0MTA2Y2FjMWQgPSBMLm1hcmtlcigKICAgICAgICAgICAgICAgIFs0MC4xNzI5MjUsIC0xMDUuMTY3NjIyXSwKICAgICAgICAgICAgICAgIHt9CiAgICAgICAgICAgICkuYWRkVG8obWFya2VyX2NsdXN0ZXJfY2E5YTQ2ODQxM2FiNGI0YWIwNTJiOWIxN2ViNDg5ZDApOwogICAgICAgIAogICAgCiAgICAgICAgdmFyIHBvcHVwXzEyZWRjZWMwOGNhMTRiZTVhMGZhYjMyYjUxMTkwZjFkID0gTC5wb3B1cCh7Im1heFdpZHRoIjogIjEwMCUifSk7CgogICAgICAgIAogICAgICAgICAgICB2YXIgaHRtbF82ZmZiM2MyYWExZjQ0YjViOTQzZDkwNzFjN2QyNzg2MyA9ICQoYDxkaXYgaWQ9Imh0bWxfNmZmYjNjMmFhMWY0NGI1Yjk0M2Q5MDcxYzdkMjc4NjMiIHN0eWxlPSJ3aWR0aDogMTAwLjAlOyBoZWlnaHQ6IDEwMC4wJTsiPk5hbWU6IE5PUlRIV0VTVCBNVVRVQUwgRElUQ0ggUHJlY2lwOiAwLjAwPC9kaXY+YClbMF07CiAgICAgICAgICAgIHBvcHVwXzEyZWRjZWMwOGNhMTRiZTVhMGZhYjMyYjUxMTkwZjFkLnNldENvbnRlbnQoaHRtbF82ZmZiM2MyYWExZjQ0YjViOTQzZDkwNzFjN2QyNzg2Myk7CiAgICAgICAgCgogICAgICAgIG1hcmtlcl83OTFkZWIwZjBlOGU0YjVmYWI0Zjc5ZTQxMDZjYWMxZC5iaW5kUG9wdXAocG9wdXBfMTJlZGNlYzA4Y2ExNGJlNWEwZmFiMzJiNTExOTBmMWQpCiAgICAgICAgOwoKICAgICAgICAKICAgIAogICAgCiAgICAgICAgICAgIHZhciBtYXJrZXJfYzlmN2M3NDQ0OTFkNDAxOWEwOTMxZDAxMTU4YmJhMmQgPSBMLm1hcmtlcigKICAgICAgICAgICAgICAgIFs0MC4xMzQyNzgsIC0xMDUuMTMwODE5XSwKICAgICAgICAgICAgICAgIHt9CiAgICAgICAgICAgICkuYWRkVG8obWFya2VyX2NsdXN0ZXJfY2E5YTQ2ODQxM2FiNGI0YWIwNTJiOWIxN2ViNDg5ZDApOwogICAgICAgIAogICAgCiAgICAgICAgdmFyIHBvcHVwX2Y2YmU5NDU1ZmQ0MDQ1NDk5Y2ZmNGRhMTc0MDNlYTI5ID0gTC5wb3B1cCh7Im1heFdpZHRoIjogIjEwMCUifSk7CgogICAgICAgIAogICAgICAgICAgICB2YXIgaHRtbF83ODZjODg5ZWI5Yzk0OGVkOTRiNjRhYWFmNjc5ZWI5YiA9ICQoYDxkaXYgaWQ9Imh0bWxfNzg2Yzg4OWViOWM5NDhlZDk0YjY0YWFhZjY3OWViOWIiIHN0eWxlPSJ3aWR0aDogMTAwLjAlOyBoZWlnaHQ6IDEwMC4wJTsiPk5hbWU6IExFRlQgSEFORCBDUkVFSyBBVCBIT1ZFUiBST0FEIE5FQVIgTE9OR01PTlQsIENPIFByZWNpcDogMy4zNDwvZGl2PmApWzBdOwogICAgICAgICAgICBwb3B1cF9mNmJlOTQ1NWZkNDA0NTQ5OWNmZjRkYTE3NDAzZWEyOS5zZXRDb250ZW50KGh0bWxfNzg2Yzg4OWViOWM5NDhlZDk0YjY0YWFhZjY3OWViOWIpOwogICAgICAgIAoKICAgICAgICBtYXJrZXJfYzlmN2M3NDQ0OTFkNDAxOWEwOTMxZDAxMTU4YmJhMmQuYmluZFBvcHVwKHBvcHVwX2Y2YmU5NDU1ZmQ0MDQ1NDk5Y2ZmNGRhMTc0MDNlYTI5KQogICAgICAgIDsKCiAgICAgICAgCiAgICAKICAgIAogICAgICAgICAgICB2YXIgbWFya2VyXzg1YzkzYmM2OTc2NjQ3N2Q4MzQ5NWU4ZWY4OGNhYWFiID0gTC5tYXJrZXIoCiAgICAgICAgICAgICAgICBbMzkuOTg2MTY5LCAtMTA1LjIxODY3N10sCiAgICAgICAgICAgICAgICB7fQogICAgICAgICAgICApLmFkZFRvKG1hcmtlcl9jbHVzdGVyX2NhOWE0Njg0MTNhYjRiNGFiMDUyYjliMTdlYjQ4OWQwKTsKICAgICAgICAKICAgIAogICAgICAgIHZhciBwb3B1cF84NmVjZTM3MWFhNWE0ODg2YWViNmFmYjI5ZDVmNWY2MSA9IEwucG9wdXAoeyJtYXhXaWR0aCI6ICIxMDAlIn0pOwoKICAgICAgICAKICAgICAgICAgICAgdmFyIGh0bWxfOGVhZDA3YjNjMDQzNGM0OWFiMWYwN2Y4NWViNmNlOTcgPSAkKGA8ZGl2IGlkPSJodG1sXzhlYWQwN2IzYzA0MzRjNDlhYjFmMDdmODVlYjZjZTk3IiBzdHlsZT0id2lkdGg6IDEwMC4wJTsgaGVpZ2h0OiAxMDAuMCU7Ij5OYW1lOiBEUlkgQ1JFRUsgQ0FSUklFUiBQcmVjaXA6IDAuMDA8L2Rpdj5gKVswXTsKICAgICAgICAgICAgcG9wdXBfODZlY2UzNzFhYTVhNDg4NmFlYjZhZmIyOWQ1ZjVmNjEuc2V0Q29udGVudChodG1sXzhlYWQwN2IzYzA0MzRjNDlhYjFmMDdmODVlYjZjZTk3KTsKICAgICAgICAKCiAgICAgICAgbWFya2VyXzg1YzkzYmM2OTc2NjQ3N2Q4MzQ5NWU4ZWY4OGNhYWFiLmJpbmRQb3B1cChwb3B1cF84NmVjZTM3MWFhNWE0ODg2YWViNmFmYjI5ZDVmNWY2MSkKICAgICAgICA7CgogICAgICAgIAogICAgCiAgICAKICAgICAgICAgICAgdmFyIG1hcmtlcl8yN2U4NTZjZmYxNWM0ZTFhOWMxNDk3YmQ5YWFlMWY0NyA9IEwubWFya2VyKAogICAgICAgICAgICAgICAgWzQwLjE2MDcwNSwgLTEwNS4xNjg0NzFdLAogICAgICAgICAgICAgICAge30KICAgICAgICAgICAgKS5hZGRUbyhtYXJrZXJfY2x1c3Rlcl9jYTlhNDY4NDEzYWI0YjRhYjA1MmI5YjE3ZWI0ODlkMCk7CiAgICAgICAgCiAgICAKICAgICAgICB2YXIgcG9wdXBfZTVhM2UyYzZiYzBmNDEyOWE3NmFmOTQ3YzAzZDZjMmUgPSBMLnBvcHVwKHsibWF4V2lkdGgiOiAiMTAwJSJ9KTsKCiAgICAgICAgCiAgICAgICAgICAgIHZhciBodG1sXzZhNTIyNGRhYTY2MTQzZDk4ZDE5NGM2YWEzYzJlZjYzID0gJChgPGRpdiBpZD0iaHRtbF82YTUyMjRkYWE2NjE0M2Q5OGQxOTRjNmFhM2MyZWY2MyIgc3R5bGU9IndpZHRoOiAxMDAuMCU7IGhlaWdodDogMTAwLjAlOyI+TmFtZTogUEVDSy1QRUxMQSBBVUdNRU5UQVRJT04gUkVUVVJOIFByZWNpcDogMC4wMDwvZGl2PmApWzBdOwogICAgICAgICAgICBwb3B1cF9lNWEzZTJjNmJjMGY0MTI5YTc2YWY5NDdjMDNkNmMyZS5zZXRDb250ZW50KGh0bWxfNmE1MjI0ZGFhNjYxNDNkOThkMTk0YzZhYTNjMmVmNjMpOwogICAgICAgIAoKICAgICAgICBtYXJrZXJfMjdlODU2Y2ZmMTVjNGUxYTljMTQ5N2JkOWFhZTFmNDcuYmluZFBvcHVwKHBvcHVwX2U1YTNlMmM2YmMwZjQxMjlhNzZhZjk0N2MwM2Q2YzJlKQogICAgICAgIDsKCiAgICAgICAgCiAgICAKICAgIAogICAgICAgICAgICB2YXIgbWFya2VyXzNiYzg2NDQ2MjI0NjQ3YTI5NDZiYTVkMWFjZmM3ODQ5ID0gTC5tYXJrZXIoCiAgICAgICAgICAgICAgICBbNDAuMTk5MzIxLCAtMTA1LjIyMjYzOV0sCiAgICAgICAgICAgICAgICB7fQogICAgICAgICAgICApLmFkZFRvKG1hcmtlcl9jbHVzdGVyX2NhOWE0Njg0MTNhYjRiNGFiMDUyYjliMTdlYjQ4OWQwKTsKICAgICAgICAKICAgIAogICAgICAgIHZhciBwb3B1cF80NTdhZTgyZjM2M2Y0OGIyODliZDEzNmJhNDFlMjY3NCA9IEwucG9wdXAoeyJtYXhXaWR0aCI6ICIxMDAlIn0pOwoKICAgICAgICAKICAgICAgICAgICAgdmFyIGh0bWxfOTM4ZWI5ZjlkNGY0NDA4ZTk1ZTU5OTFkNDU1YmRhYWQgPSAkKGA8ZGl2IGlkPSJodG1sXzkzOGViOWY5ZDRmNDQwOGU5NWU1OTkxZDQ1NWJkYWFkIiBzdHlsZT0id2lkdGg6IDEwMC4wJTsgaGVpZ2h0OiAxMDAuMCU7Ij5OYW1lOiBHT1NTIERJVENIIDEgUHJlY2lwOiAwLjAwPC9kaXY+YClbMF07CiAgICAgICAgICAgIHBvcHVwXzQ1N2FlODJmMzYzZjQ4YjI4OWJkMTM2YmE0MWUyNjc0LnNldENvbnRlbnQoaHRtbF85MzhlYjlmOWQ0ZjQ0MDhlOTVlNTk5MWQ0NTViZGFhZCk7CiAgICAgICAgCgogICAgICAgIG1hcmtlcl8zYmM4NjQ0NjIyNDY0N2EyOTQ2YmE1ZDFhY2ZjNzg0OS5iaW5kUG9wdXAocG9wdXBfNDU3YWU4MmYzNjNmNDhiMjg5YmQxMzZiYTQxZTI2NzQpCiAgICAgICAgOwoKICAgICAgICAKICAgIAogICAgCiAgICAgICAgICAgIHZhciBtYXJrZXJfNTBhMDE4MmIyZGZiNDE1NGIxMzZiMGJiY2UyNGE4ODAgPSBMLm1hcmtlcigKICAgICAgICAgICAgICAgIFs0MC4xOTMyOCwgLTEwNS4yMTA0MjRdLAogICAgICAgICAgICAgICAge30KICAgICAgICAgICAgKS5hZGRUbyhtYXJrZXJfY2x1c3Rlcl9jYTlhNDY4NDEzYWI0YjRhYjA1MmI5YjE3ZWI0ODlkMCk7CiAgICAgICAgCiAgICAKICAgICAgICB2YXIgcG9wdXBfMjc4ZTQxZTBmMjY0NGU0NWIyYTc2MDdhYjRmYzM5NTIgPSBMLnBvcHVwKHsibWF4V2lkdGgiOiAiMTAwJSJ9KTsKCiAgICAgICAgCiAgICAgICAgICAgIHZhciBodG1sX2RlYWQ3MjMwMzMwYTQwZGE5MzBlNWQzNzBmNzc4NTlhID0gJChgPGRpdiBpZD0iaHRtbF9kZWFkNzIzMDMzMGE0MGRhOTMwZTVkMzcwZjc3ODU5YSIgc3R5bGU9IndpZHRoOiAxMDAuMCU7IGhlaWdodDogMTAwLjAlOyI+TmFtZTogV0VCU1RFUiBNQ0NBU0xJTiBESVRDSCBQcmVjaXA6IDAuMDA8L2Rpdj5gKVswXTsKICAgICAgICAgICAgcG9wdXBfMjc4ZTQxZTBmMjY0NGU0NWIyYTc2MDdhYjRmYzM5NTIuc2V0Q29udGVudChodG1sX2RlYWQ3MjMwMzMwYTQwZGE5MzBlNWQzNzBmNzc4NTlhKTsKICAgICAgICAKCiAgICAgICAgbWFya2VyXzUwYTAxODJiMmRmYjQxNTRiMTM2YjBiYmNlMjRhODgwLmJpbmRQb3B1cChwb3B1cF8yNzhlNDFlMGYyNjQ0ZTQ1YjJhNzYwN2FiNGZjMzk1MikKICAgICAgICA7CgogICAgICAgIAogICAgCiAgICAKICAgICAgICAgICAgdmFyIG1hcmtlcl9jMDNkNGY2MTA0OTc0MTMxOThjZWNhYjA3YzBjZmJkNSA9IEwubWFya2VyKAogICAgICAgICAgICAgICAgWzQwLjA1MzY2MSwgLTEwNS4xNTExNDNdLAogICAgICAgICAgICAgICAge30KICAgICAgICAgICAgKS5hZGRUbyhtYXJrZXJfY2x1c3Rlcl9jYTlhNDY4NDEzYWI0YjRhYjA1MmI5YjE3ZWI0ODlkMCk7CiAgICAgICAgCiAgICAKICAgICAgICB2YXIgcG9wdXBfYjA3Y2JlMWM0YzJhNGE1ODlmZjA2NTc1NGVhMjQxYTYgPSBMLnBvcHVwKHsibWF4V2lkdGgiOiAiMTAwJSJ9KTsKCiAgICAgICAgCiAgICAgICAgICAgIHZhciBodG1sXzFiNDEzZDhhMmQyZDRhZWY5ZTBiMWQ5MjgzNmUyMjg4ID0gJChgPGRpdiBpZD0iaHRtbF8xYjQxM2Q4YTJkMmQ0YWVmOWUwYjFkOTI4MzZlMjI4OCIgc3R5bGU9IndpZHRoOiAxMDAuMCU7IGhlaWdodDogMTAwLjAlOyI+TmFtZTogTEVHR0VUVCBESVRDSCBQcmVjaXA6IDIuNjM8L2Rpdj5gKVswXTsKICAgICAgICAgICAgcG9wdXBfYjA3Y2JlMWM0YzJhNGE1ODlmZjA2NTc1NGVhMjQxYTYuc2V0Q29udGVudChodG1sXzFiNDEzZDhhMmQyZDRhZWY5ZTBiMWQ5MjgzNmUyMjg4KTsKICAgICAgICAKCiAgICAgICAgbWFya2VyX2MwM2Q0ZjYxMDQ5NzQxMzE5OGNlY2FiMDdjMGNmYmQ1LmJpbmRQb3B1cChwb3B1cF9iMDdjYmUxYzRjMmE0YTU4OWZmMDY1NzU0ZWEyNDFhNikKICAgICAgICA7CgogICAgICAgIAogICAgCiAgICAKICAgICAgICAgICAgdmFyIG1hcmtlcl80NmUxYWIzMjE1YzA0MjNiOTJmN2EyNzM2Y2ZhYjEyZCA9IEwubWFya2VyKAogICAgICAgICAgICAgICAgWzQwLjIxNjI2MywgLTEwNS4zNjUzNjVdLAogICAgICAgICAgICAgICAge30KICAgICAgICAgICAgKS5hZGRUbyhtYXJrZXJfY2x1c3Rlcl9jYTlhNDY4NDEzYWI0YjRhYjA1MmI5YjE3ZWI0ODlkMCk7CiAgICAgICAgCiAgICAKICAgICAgICB2YXIgcG9wdXBfOWM5Y2VhNmIxNzQwNGIxMzlhNmQxMWVhMzBlODU5ZGMgPSBMLnBvcHVwKHsibWF4V2lkdGgiOiAiMTAwJSJ9KTsKCiAgICAgICAgCiAgICAgICAgICAgIHZhciBodG1sXzY1Y2FlM2YzY2IwMDQ3Mzg4ZDg5NDIyOTJjYmIyMTNlID0gJChgPGRpdiBpZD0iaHRtbF82NWNhZTNmM2NiMDA0NzM4OGQ4OTQyMjkyY2JiMjEzZSIgc3R5bGU9IndpZHRoOiAxMDAuMCU7IGhlaWdodDogMTAwLjAlOyI+TmFtZTogQlVUVE9OUk9DSyAoUkFMUEggUFJJQ0UpIFJFU0VSVk9JUiBQcmVjaXA6IDEyODg2LjAwPC9kaXY+YClbMF07CiAgICAgICAgICAgIHBvcHVwXzljOWNlYTZiMTc0MDRiMTM5YTZkMTFlYTMwZTg1OWRjLnNldENvbnRlbnQoaHRtbF82NWNhZTNmM2NiMDA0NzM4OGQ4OTQyMjkyY2JiMjEzZSk7CiAgICAgICAgCgogICAgICAgIG1hcmtlcl80NmUxYWIzMjE1YzA0MjNiOTJmN2EyNzM2Y2ZhYjEyZC5iaW5kUG9wdXAocG9wdXBfOWM5Y2VhNmIxNzQwNGIxMzlhNmQxMWVhMzBlODU5ZGMpCiAgICAgICAgOwoKICAgICAgICAKICAgIAogICAgCiAgICAgICAgICAgIHZhciBtYXJrZXJfMGYxNmI3NTIxNGMxNDYzZWE5ZDMyYzFiY2QwZWJlYjMgPSBMLm1hcmtlcigKICAgICAgICAgICAgICAgIFs0MC4yNTU3NzYsIC0xMDUuMjA5NV0sCiAgICAgICAgICAgICAgICB7fQogICAgICAgICAgICApLmFkZFRvKG1hcmtlcl9jbHVzdGVyX2NhOWE0Njg0MTNhYjRiNGFiMDUyYjliMTdlYjQ4OWQwKTsKICAgICAgICAKICAgIAogICAgICAgIHZhciBwb3B1cF9jNmYxYWY0YmNlMDk0M2Q0YWU4YzAxZmE1ZmYxNWU1OSA9IEwucG9wdXAoeyJtYXhXaWR0aCI6ICIxMDAlIn0pOwoKICAgICAgICAKICAgICAgICAgICAgdmFyIGh0bWxfYjgyNWVjZTU0YThiNDgyZGEzZjE3MzFkOTgxYWUxMjEgPSAkKGA8ZGl2IGlkPSJodG1sX2I4MjVlY2U1NGE4YjQ4MmRhM2YxNzMxZDk4MWFlMTIxIiBzdHlsZT0id2lkdGg6IDEwMC4wJTsgaGVpZ2h0OiAxMDAuMCU7Ij5OYW1lOiBMSVRUTEUgVEhPTVBTT04gIzIgRElUQ0ggUHJlY2lwOiAwLjEwPC9kaXY+YClbMF07CiAgICAgICAgICAgIHBvcHVwX2M2ZjFhZjRiY2UwOTQzZDRhZThjMDFmYTVmZjE1ZTU5LnNldENvbnRlbnQoaHRtbF9iODI1ZWNlNTRhOGI0ODJkYTNmMTczMWQ5ODFhZTEyMSk7CiAgICAgICAgCgogICAgICAgIG1hcmtlcl8wZjE2Yjc1MjE0YzE0NjNlYTlkMzJjMWJjZDBlYmViMy5iaW5kUG9wdXAocG9wdXBfYzZmMWFmNGJjZTA5NDNkNGFlOGMwMWZhNWZmMTVlNTkpCiAgICAgICAgOwoKICAgICAgICAKICAgIAogICAgCiAgICAgICAgICAgIHZhciBtYXJrZXJfZjQxMzBhYTYzMDRkNDk2NzgzZWJiNjQ4Y2IwNWIxOWEgPSBMLm1hcmtlcigKICAgICAgICAgICAgICAgIFs0MC4yNTc4NDQsIC0xMDUuMTY0Mzk3XSwKICAgICAgICAgICAgICAgIHt9CiAgICAgICAgICAgICkuYWRkVG8obWFya2VyX2NsdXN0ZXJfY2E5YTQ2ODQxM2FiNGI0YWIwNTJiOWIxN2ViNDg5ZDApOwogICAgICAgIAogICAgCiAgICAgICAgdmFyIHBvcHVwXzZlNjM4NDRmNDMxZjRhNGViNmE3NzE5ODk2MGVkNjg2ID0gTC5wb3B1cCh7Im1heFdpZHRoIjogIjEwMCUifSk7CgogICAgICAgIAogICAgICAgICAgICB2YXIgaHRtbF8wODRhMDIzMzI4NzA0MTc1OGE5NmMyZjU3NmFjODEzOCA9ICQoYDxkaXYgaWQ9Imh0bWxfMDg0YTAyMzMyODcwNDE3NThhOTZjMmY1NzZhYzgxMzgiIHN0eWxlPSJ3aWR0aDogMTAwLjAlOyBoZWlnaHQ6IDEwMC4wJTsiPk5hbWU6IEJMT1dFUiBESVRDSCBQcmVjaXA6IDAuMDE8L2Rpdj5gKVswXTsKICAgICAgICAgICAgcG9wdXBfNmU2Mzg0NGY0MzFmNGE0ZWI2YTc3MTk4OTYwZWQ2ODYuc2V0Q29udGVudChodG1sXzA4NGEwMjMzMjg3MDQxNzU4YTk2YzJmNTc2YWM4MTM4KTsKICAgICAgICAKCiAgICAgICAgbWFya2VyX2Y0MTMwYWE2MzA0ZDQ5Njc4M2ViYjY0OGNiMDViMTlhLmJpbmRQb3B1cChwb3B1cF82ZTYzODQ0ZjQzMWY0YTRlYjZhNzcxOTg5NjBlZDY4NikKICAgICAgICA7CgogICAgICAgIAogICAgCiAgICAKICAgICAgICAgICAgdmFyIG1hcmtlcl82MzY3MGFhM2I4MTA0MWJkOTE3Zjk2OTE3ZWI0NWE5YSA9IEwubWFya2VyKAogICAgICAgICAgICAgICAgWzM5LjkzMTU5NywgLTEwNS4zMDQ5OV0sCiAgICAgICAgICAgICAgICB7fQogICAgICAgICAgICApLmFkZFRvKG1hcmtlcl9jbHVzdGVyX2NhOWE0Njg0MTNhYjRiNGFiMDUyYjliMTdlYjQ4OWQwKTsKICAgICAgICAKICAgIAogICAgICAgIHZhciBwb3B1cF83MzlhYjhkNzM3N2Q0MzNlOTc0ZTg2MjIxNjJjY2I2MCA9IEwucG9wdXAoeyJtYXhXaWR0aCI6ICIxMDAlIn0pOwoKICAgICAgICAKICAgICAgICAgICAgdmFyIGh0bWxfNGY0NmU0OWE1MTgxNGUwYzg2Y2RjNmUzNDczNjE3NTcgPSAkKGA8ZGl2IGlkPSJodG1sXzRmNDZlNDlhNTE4MTRlMGM4NmNkYzZlMzQ3MzYxNzU3IiBzdHlsZT0id2lkdGg6IDEwMC4wJTsgaGVpZ2h0OiAxMDAuMCU7Ij5OYW1lOiBTT1VUSCBCT1VMREVSIENSRUVLIE5FQVIgRUxET1JBRE8gU1BSSU5HUywgQ08uIFByZWNpcDogMTcuMjA8L2Rpdj5gKVswXTsKICAgICAgICAgICAgcG9wdXBfNzM5YWI4ZDczNzdkNDMzZTk3NGU4NjIyMTYyY2NiNjAuc2V0Q29udGVudChodG1sXzRmNDZlNDlhNTE4MTRlMGM4NmNkYzZlMzQ3MzYxNzU3KTsKICAgICAgICAKCiAgICAgICAgbWFya2VyXzYzNjcwYWEzYjgxMDQxYmQ5MTdmOTY5MTdlYjQ1YTlhLmJpbmRQb3B1cChwb3B1cF83MzlhYjhkNzM3N2Q0MzNlOTc0ZTg2MjIxNjJjY2I2MCkKICAgICAgICA7CgogICAgICAgIAogICAgCiAgICAKICAgICAgICAgICAgdmFyIG1hcmtlcl83MWU5ODkyYjE2NzI0YzFiYTdkMzY0MjFhNGRjMmMwZCA9IEwubWFya2VyKAogICAgICAgICAgICAgICAgWzQwLjA1MTY1MiwgLTEwNS4xNzg4NzVdLAogICAgICAgICAgICAgICAge30KICAgICAgICAgICAgKS5hZGRUbyhtYXJrZXJfY2x1c3Rlcl9jYTlhNDY4NDEzYWI0YjRhYjA1MmI5YjE3ZWI0ODlkMCk7CiAgICAgICAgCiAgICAKICAgICAgICB2YXIgcG9wdXBfYWEwODQwOWE4OWJhNGQ0NmFkMzE2YTZiNDIxN2RmOTMgPSBMLnBvcHVwKHsibWF4V2lkdGgiOiAiMTAwJSJ9KTsKCiAgICAgICAgCiAgICAgICAgICAgIHZhciBodG1sXzZjNGU4OTZjNmRkYzQ3ZjQ4Y2YzZmE0NzNlOWZkY2I2ID0gJChgPGRpdiBpZD0iaHRtbF82YzRlODk2YzZkZGM0N2Y0OGNmM2ZhNDczZTlmZGNiNiIgc3R5bGU9IndpZHRoOiAxMDAuMCU7IGhlaWdodDogMTAwLjAlOyI+TmFtZTogQk9VTERFUiBDUkVFSyBBVCBOT1JUSCA3NVRIIFNULiBORUFSIEJPVUxERVIsIENPIFByZWNpcDogMzAuMjA8L2Rpdj5gKVswXTsKICAgICAgICAgICAgcG9wdXBfYWEwODQwOWE4OWJhNGQ0NmFkMzE2YTZiNDIxN2RmOTMuc2V0Q29udGVudChodG1sXzZjNGU4OTZjNmRkYzQ3ZjQ4Y2YzZmE0NzNlOWZkY2I2KTsKICAgICAgICAKCiAgICAgICAgbWFya2VyXzcxZTk4OTJiMTY3MjRjMWJhN2QzNjQyMWE0ZGMyYzBkLmJpbmRQb3B1cChwb3B1cF9hYTA4NDA5YTg5YmE0ZDQ2YWQzMTZhNmI0MjE3ZGY5MykKICAgICAgICA7CgogICAgICAgIAogICAgCiAgICAKICAgICAgICAgICAgdmFyIG1hcmtlcl9hOTNiZWU3NmI1NTc0ZWRjYmFlY2I2N2QwOWJkNjRlOSA9IEwubWFya2VyKAogICAgICAgICAgICAgICAgWzQwLjE3MDk5OCwgLTEwNS4xNjA4NzZdLAogICAgICAgICAgICAgICAge30KICAgICAgICAgICAgKS5hZGRUbyhtYXJrZXJfY2x1c3Rlcl9jYTlhNDY4NDEzYWI0YjRhYjA1MmI5YjE3ZWI0ODlkMCk7CiAgICAgICAgCiAgICAKICAgICAgICB2YXIgcG9wdXBfYjA3OWI1OGUyNWZhNGI2MjkwMjk3YjE0MTAzM2MwZTcgPSBMLnBvcHVwKHsibWF4V2lkdGgiOiAiMTAwJSJ9KTsKCiAgICAgICAgCiAgICAgICAgICAgIHZhciBodG1sXzcyN2QwMDNhOGIzMzQyMWY5MGIwNTQ2ZWMxY2ZlYjU3ID0gJChgPGRpdiBpZD0iaHRtbF83MjdkMDAzYThiMzM0MjFmOTBiMDU0NmVjMWNmZWI1NyIgc3R5bGU9IndpZHRoOiAxMDAuMCU7IGhlaWdodDogMTAwLjAlOyI+TmFtZTogU09VVEggRkxBVCBESVRDSCBQcmVjaXA6IDAuMzg8L2Rpdj5gKVswXTsKICAgICAgICAgICAgcG9wdXBfYjA3OWI1OGUyNWZhNGI2MjkwMjk3YjE0MTAzM2MwZTcuc2V0Q29udGVudChodG1sXzcyN2QwMDNhOGIzMzQyMWY5MGIwNTQ2ZWMxY2ZlYjU3KTsKICAgICAgICAKCiAgICAgICAgbWFya2VyX2E5M2JlZTc2YjU1NzRlZGNiYWVjYjY3ZDA5YmQ2NGU5LmJpbmRQb3B1cChwb3B1cF9iMDc5YjU4ZTI1ZmE0YjYyOTAyOTdiMTQxMDMzYzBlNykKICAgICAgICA7CgogICAgICAgIAogICAgCiAgICAKICAgICAgICAgICAgdmFyIG1hcmtlcl9iMDQ2YzIxZTM3ZGQ0YzljYjI1OWY3NzUwYmU4ZDMwYiA9IEwubWFya2VyKAogICAgICAgICAgICAgICAgWzQwLjE1MzM0MSwgLTEwNS4wNzU2OTVdLAogICAgICAgICAgICAgICAge30KICAgICAgICAgICAgKS5hZGRUbyhtYXJrZXJfY2x1c3Rlcl9jYTlhNDY4NDEzYWI0YjRhYjA1MmI5YjE3ZWI0ODlkMCk7CiAgICAgICAgCiAgICAKICAgICAgICB2YXIgcG9wdXBfNWM0OTYxMmIyNzYxNDEzYjhlMTJhMWIxNjIzMGFlODEgPSBMLnBvcHVwKHsibWF4V2lkdGgiOiAiMTAwJSJ9KTsKCiAgICAgICAgCiAgICAgICAgICAgIHZhciBodG1sXzk1ZTg3YmNlMjYxMjQ2NmQ4Njc4NTE0MjZiYzg5NzJkID0gJChgPGRpdiBpZD0iaHRtbF85NWU4N2JjZTI2MTI0NjZkODY3ODUxNDI2YmM4OTcyZCIgc3R5bGU9IndpZHRoOiAxMDAuMCU7IGhlaWdodDogMTAwLjAlOyI+TmFtZTogU0FJTlQgVlJBSU4gQ1JFRUsgQkVMT1cgS0VOIFBSQVRUIEJMVkQgQVQgTE9OR01PTlQsIENPIFByZWNpcDogMzMuODA8L2Rpdj5gKVswXTsKICAgICAgICAgICAgcG9wdXBfNWM0OTYxMmIyNzYxNDEzYjhlMTJhMWIxNjIzMGFlODEuc2V0Q29udGVudChodG1sXzk1ZTg3YmNlMjYxMjQ2NmQ4Njc4NTE0MjZiYzg5NzJkKTsKICAgICAgICAKCiAgICAgICAgbWFya2VyX2IwNDZjMjFlMzdkZDRjOWNiMjU5Zjc3NTBiZThkMzBiLmJpbmRQb3B1cChwb3B1cF81YzQ5NjEyYjI3NjE0MTNiOGUxMmExYjE2MjMwYWU4MSkKICAgICAgICA7CgogICAgICAgIAogICAgCiAgICAKICAgICAgICAgICAgdmFyIG1hcmtlcl9iZmZlOWQwZDY2NjY0YjAxYjY5MzQ0OGQwYWY5ZWEwNCA9IEwubWFya2VyKAogICAgICAgICAgICAgICAgWzM5Ljk2MTY1NSwgLTEwNS41MDQ0NF0sCiAgICAgICAgICAgICAgICB7fQogICAgICAgICAgICApLmFkZFRvKG1hcmtlcl9jbHVzdGVyX2NhOWE0Njg0MTNhYjRiNGFiMDUyYjliMTdlYjQ4OWQwKTsKICAgICAgICAKICAgIAogICAgICAgIHZhciBwb3B1cF83ZGUwOGFkZGM1ZjM0ZmIxYjgzNjRhMmQyOTM2ODRjYiA9IEwucG9wdXAoeyJtYXhXaWR0aCI6ICIxMDAlIn0pOwoKICAgICAgICAKICAgICAgICAgICAgdmFyIGh0bWxfOTAxM2ViZTczZDExNGZkNDljMTc3M2QzODZlZWMxYTMgPSAkKGA8ZGl2IGlkPSJodG1sXzkwMTNlYmU3M2QxMTRmZDQ5YzE3NzNkMzg2ZWVjMWEzIiBzdHlsZT0id2lkdGg6IDEwMC4wJTsgaGVpZ2h0OiAxMDAuMCU7Ij5OYW1lOiBNSURETEUgQk9VTERFUiBDUkVFSyBBVCBORURFUkxBTkQsIENPLiBQcmVjaXA6IDI0LjYwPC9kaXY+YClbMF07CiAgICAgICAgICAgIHBvcHVwXzdkZTA4YWRkYzVmMzRmYjFiODM2NGEyZDI5MzY4NGNiLnNldENvbnRlbnQoaHRtbF85MDEzZWJlNzNkMTE0ZmQ0OWMxNzczZDM4NmVlYzFhMyk7CiAgICAgICAgCgogICAgICAgIG1hcmtlcl9iZmZlOWQwZDY2NjY0YjAxYjY5MzQ0OGQwYWY5ZWEwNC5iaW5kUG9wdXAocG9wdXBfN2RlMDhhZGRjNWYzNGZiMWI4MzY0YTJkMjkzNjg0Y2IpCiAgICAgICAgOwoKICAgICAgICAKICAgIAogICAgCiAgICAgICAgICAgIHZhciBtYXJrZXJfY2MzMmU3Yzc0NTMxNDNlOThlN2FlN2Q0YTMwNTM4ZjggPSBMLm1hcmtlcigKICAgICAgICAgICAgICAgIFs0MC4wNTk4MDksIC0xMDUuMDk3ODcyXSwKICAgICAgICAgICAgICAgIHt9CiAgICAgICAgICAgICkuYWRkVG8obWFya2VyX2NsdXN0ZXJfY2E5YTQ2ODQxM2FiNGI0YWIwNTJiOWIxN2ViNDg5ZDApOwogICAgICAgIAogICAgCiAgICAgICAgdmFyIHBvcHVwX2JmZGRjOGM5NTE0ODQ4MGI5MzU2OGJlNjEyZTU4MzUzID0gTC5wb3B1cCh7Im1heFdpZHRoIjogIjEwMCUifSk7CgogICAgICAgIAogICAgICAgICAgICB2YXIgaHRtbF80Y2QxYzM0NTdhMDU0OWZiODhkOTNjMmE3MTdlZDEwZCA9ICQoYDxkaXYgaWQ9Imh0bWxfNGNkMWMzNDU3YTA1NDlmYjg4ZDkzYzJhNzE3ZWQxMGQiIHN0eWxlPSJ3aWR0aDogMTAwLjAlOyBoZWlnaHQ6IDEwMC4wJTsiPk5hbWU6IEJPVUxERVIgQ1JFRUsgQVQgMTA5IFNUIE5FQVIgRVJJRSwgQ08gUHJlY2lwOiA1MC4yMDwvZGl2PmApWzBdOwogICAgICAgICAgICBwb3B1cF9iZmRkYzhjOTUxNDg0ODBiOTM1NjhiZTYxMmU1ODM1My5zZXRDb250ZW50KGh0bWxfNGNkMWMzNDU3YTA1NDlmYjg4ZDkzYzJhNzE3ZWQxMGQpOwogICAgICAgIAoKICAgICAgICBtYXJrZXJfY2MzMmU3Yzc0NTMxNDNlOThlN2FlN2Q0YTMwNTM4ZjguYmluZFBvcHVwKHBvcHVwX2JmZGRjOGM5NTE0ODQ4MGI5MzU2OGJlNjEyZTU4MzUzKQogICAgICAgIDsKCiAgICAgICAgCiAgICAKICAgIAogICAgICAgICAgICB2YXIgbWFya2VyXzNjOGNmMDAyMTUwMjQxZjJhM2M3OWNhMjc0ODFhMmU2ID0gTC5tYXJrZXIoCiAgICAgICAgICAgICAgICBbNDAuMjE1NjU4LCAtMTA1LjM2MzQyMl0sCiAgICAgICAgICAgICAgICB7fQogICAgICAgICAgICApLmFkZFRvKG1hcmtlcl9jbHVzdGVyX2NhOWE0Njg0MTNhYjRiNGFiMDUyYjliMTdlYjQ4OWQwKTsKICAgICAgICAKICAgIAogICAgICAgIHZhciBwb3B1cF84ODk1ZGYzMjFmODA0ODg2OTlkZjVmMTI5NWNjOTM0ZiA9IEwucG9wdXAoeyJtYXhXaWR0aCI6ICIxMDAlIn0pOwoKICAgICAgICAKICAgICAgICAgICAgdmFyIGh0bWxfNjZmYWI5ZDNhNTk1NDNiOGEzMTIzOTNlYjVlMGI3ZGUgPSAkKGA8ZGl2IGlkPSJodG1sXzY2ZmFiOWQzYTU5NTQzYjhhMzEyMzkzZWI1ZTBiN2RlIiBzdHlsZT0id2lkdGg6IDEwMC4wJTsgaGVpZ2h0OiAxMDAuMCU7Ij5OYW1lOiBOT1JUSCBTQUlOVCBWUkFJTiBDUkVFSyBCRUxPVyBCVVRUT05ST0NLICAoUkFMUEggUFJJQ0UpIFJFU0VSVk9JUiBQcmVjaXA6IDE5LjMwPC9kaXY+YClbMF07CiAgICAgICAgICAgIHBvcHVwXzg4OTVkZjMyMWY4MDQ4ODY5OWRmNWYxMjk1Y2M5MzRmLnNldENvbnRlbnQoaHRtbF82NmZhYjlkM2E1OTU0M2I4YTMxMjM5M2ViNWUwYjdkZSk7CiAgICAgICAgCgogICAgICAgIG1hcmtlcl8zYzhjZjAwMjE1MDI0MWYyYTNjNzljYTI3NDgxYTJlNi5iaW5kUG9wdXAocG9wdXBfODg5NWRmMzIxZjgwNDg4Njk5ZGY1ZjEyOTVjYzkzNGYpCiAgICAgICAgOwoKICAgICAgICAKICAgIAogICAgCiAgICAgICAgICAgIHZhciBtYXJrZXJfYTY3NDQ3ZTM0NWFlNDgyM2IxNDc3ZmRhNWU2ZDI4OGMgPSBMLm1hcmtlcigKICAgICAgICAgICAgICAgIFs0MC4xMjYzODksIC0xMDUuMzA0NDA0XSwKICAgICAgICAgICAgICAgIHt9CiAgICAgICAgICAgICkuYWRkVG8obWFya2VyX2NsdXN0ZXJfY2E5YTQ2ODQxM2FiNGI0YWIwNTJiOWIxN2ViNDg5ZDApOwogICAgICAgIAogICAgCiAgICAgICAgdmFyIHBvcHVwXzYxZGU1ZWYxNzBiMzRjYzliZDFlNmNiNTM4NzdkNDJhID0gTC5wb3B1cCh7Im1heFdpZHRoIjogIjEwMCUifSk7CgogICAgICAgIAogICAgICAgICAgICB2YXIgaHRtbF8yMTczOWE2ZmNlNjM0ZWE1ODRlZDdiODUwMzA1ZGU0OSA9ICQoYDxkaXYgaWQ9Imh0bWxfMjE3MzlhNmZjZTYzNGVhNTg0ZWQ3Yjg1MDMwNWRlNDkiIHN0eWxlPSJ3aWR0aDogMTAwLjAlOyBoZWlnaHQ6IDEwMC4wJTsiPk5hbWU6IExFRlQgSEFORCBDUkVFSyBORUFSIEJPVUxERVIsIENPLiBQcmVjaXA6IDEyLjYwPC9kaXY+YClbMF07CiAgICAgICAgICAgIHBvcHVwXzYxZGU1ZWYxNzBiMzRjYzliZDFlNmNiNTM4NzdkNDJhLnNldENvbnRlbnQoaHRtbF8yMTczOWE2ZmNlNjM0ZWE1ODRlZDdiODUwMzA1ZGU0OSk7CiAgICAgICAgCgogICAgICAgIG1hcmtlcl9hNjc0NDdlMzQ1YWU0ODIzYjE0NzdmZGE1ZTZkMjg4Yy5iaW5kUG9wdXAocG9wdXBfNjFkZTVlZjE3MGIzNGNjOWJkMWU2Y2I1Mzg3N2Q0MmEpCiAgICAgICAgOwoKICAgICAgICAKICAgIAogICAgCiAgICAgICAgICAgIHZhciBtYXJrZXJfZTA5NzQwZTZiMWQ0NDViNzkyODFkM2RkNjE0YzlhOGEgPSBMLm1hcmtlcigKICAgICAgICAgICAgICAgIFs0MC4wODYyNzgsIC0xMDUuMjE3NTE5XSwKICAgICAgICAgICAgICAgIHt9CiAgICAgICAgICAgICkuYWRkVG8obWFya2VyX2NsdXN0ZXJfY2E5YTQ2ODQxM2FiNGI0YWIwNTJiOWIxN2ViNDg5ZDApOwogICAgICAgIAogICAgCiAgICAgICAgdmFyIHBvcHVwXzM4MjNmYWU4OTgzODRlOTk4NzUxYzIzMDAzN2YwZjA5ID0gTC5wb3B1cCh7Im1heFdpZHRoIjogIjEwMCUifSk7CgogICAgICAgIAogICAgICAgICAgICB2YXIgaHRtbF84NjhmYWI4MThjN2I0ZDQ2ODE4MTNmZGQ5NjEzMTk3YiA9ICQoYDxkaXYgaWQ9Imh0bWxfODY4ZmFiODE4YzdiNGQ0NjgxODEzZmRkOTYxMzE5N2IiIHN0eWxlPSJ3aWR0aDogMTAwLjAlOyBoZWlnaHQ6IDEwMC4wJTsiPk5hbWU6IEJPVUxERVIgUkVTRVJWT0lSIElOTEVUIFByZWNpcDogMC4wMDwvZGl2PmApWzBdOwogICAgICAgICAgICBwb3B1cF8zODIzZmFlODk4Mzg0ZTk5ODc1MWMyMzAwMzdmMGYwOS5zZXRDb250ZW50KGh0bWxfODY4ZmFiODE4YzdiNGQ0NjgxODEzZmRkOTYxMzE5N2IpOwogICAgICAgIAoKICAgICAgICBtYXJrZXJfZTA5NzQwZTZiMWQ0NDViNzkyODFkM2RkNjE0YzlhOGEuYmluZFBvcHVwKHBvcHVwXzM4MjNmYWU4OTgzODRlOTk4NzUxYzIzMDAzN2YwZjA5KQogICAgICAgIDsKCiAgICAgICAgCiAgICAKICAgIAogICAgICAgICAgICB2YXIgbWFya2VyX2JmMTM1NzdhYTFlNTRmYjRiNTM4OGZlOTNlOWNmMGJlID0gTC5tYXJrZXIoCiAgICAgICAgICAgICAgICBbNDAuMTkzMDE5LCAtMTA1LjIxMDM4OF0sCiAgICAgICAgICAgICAgICB7fQogICAgICAgICAgICApLmFkZFRvKG1hcmtlcl9jbHVzdGVyX2NhOWE0Njg0MTNhYjRiNGFiMDUyYjliMTdlYjQ4OWQwKTsKICAgICAgICAKICAgIAogICAgICAgIHZhciBwb3B1cF9jZWI5ZTY1OTgxYjI0Zjc3YTZiNTliODZhN2RlZWMxNCA9IEwucG9wdXAoeyJtYXhXaWR0aCI6ICIxMDAlIn0pOwoKICAgICAgICAKICAgICAgICAgICAgdmFyIGh0bWxfYWZiZTU3YTE3ZjlmNDBkNjhiZjgxOTdiYTYzMTdhMTcgPSAkKGA8ZGl2IGlkPSJodG1sX2FmYmU1N2ExN2Y5ZjQwZDY4YmY4MTk3YmE2MzE3YTE3IiBzdHlsZT0id2lkdGg6IDEwMC4wJTsgaGVpZ2h0OiAxMDAuMCU7Ij5OYW1lOiBUUlVFIEFORCBXRUJTVEVSIERJVENIIFByZWNpcDogMC4wMDwvZGl2PmApWzBdOwogICAgICAgICAgICBwb3B1cF9jZWI5ZTY1OTgxYjI0Zjc3YTZiNTliODZhN2RlZWMxNC5zZXRDb250ZW50KGh0bWxfYWZiZTU3YTE3ZjlmNDBkNjhiZjgxOTdiYTYzMTdhMTcpOwogICAgICAgIAoKICAgICAgICBtYXJrZXJfYmYxMzU3N2FhMWU1NGZiNGI1Mzg4ZmU5M2U5Y2YwYmUuYmluZFBvcHVwKHBvcHVwX2NlYjllNjU5ODFiMjRmNzdhNmI1OWI4NmE3ZGVlYzE0KQogICAgICAgIDsKCiAgICAgICAgCiAgICAKICAgIAogICAgICAgICAgICB2YXIgbWFya2VyXzE4ZDQyYzNkNmQ3MTQwZWI5MzY3ZTYyNjE1NGIyNmVhID0gTC5tYXJrZXIoCiAgICAgICAgICAgICAgICBbNDAuMjEyNjU4LCAtMTA1LjI1MTgyNl0sCiAgICAgICAgICAgICAgICB7fQogICAgICAgICAgICApLmFkZFRvKG1hcmtlcl9jbHVzdGVyX2NhOWE0Njg0MTNhYjRiNGFiMDUyYjliMTdlYjQ4OWQwKTsKICAgICAgICAKICAgIAogICAgICAgIHZhciBwb3B1cF9iYWFkOWI1MDQxNTc0YzQ0YmVjYzM5MzZjZTlkZGIwZCA9IEwucG9wdXAoeyJtYXhXaWR0aCI6ICIxMDAlIn0pOwoKICAgICAgICAKICAgICAgICAgICAgdmFyIGh0bWxfZDRmYTBhYjg0OWUwNGFhZjk5OGNjZDIwMjhlYmE5NWEgPSAkKGA8ZGl2IGlkPSJodG1sX2Q0ZmEwYWI4NDllMDRhYWY5OThjY2QyMDI4ZWJhOTVhIiBzdHlsZT0id2lkdGg6IDEwMC4wJTsgaGVpZ2h0OiAxMDAuMCU7Ij5OYW1lOiBST1VHSCBBTkQgUkVBRFkgRElUQ0ggUHJlY2lwOiAwLjAwPC9kaXY+YClbMF07CiAgICAgICAgICAgIHBvcHVwX2JhYWQ5YjUwNDE1NzRjNDRiZWNjMzkzNmNlOWRkYjBkLnNldENvbnRlbnQoaHRtbF9kNGZhMGFiODQ5ZTA0YWFmOTk4Y2NkMjAyOGViYTk1YSk7CiAgICAgICAgCgogICAgICAgIG1hcmtlcl8xOGQ0MmMzZDZkNzE0MGViOTM2N2U2MjYxNTRiMjZlYS5iaW5kUG9wdXAocG9wdXBfYmFhZDliNTA0MTU3NGM0NGJlY2MzOTM2Y2U5ZGRiMGQpCiAgICAgICAgOwoKICAgICAgICAKICAgIAogICAgCiAgICAgICAgICAgIHZhciBtYXJrZXJfYTk5ZmViMTc2MjFiNGE3MDliYTVlN2U1ZjRlODZlNGEgPSBMLm1hcmtlcigKICAgICAgICAgICAgICAgIFs0MC4xNzQ4NDQsIC0xMDUuMTY3ODczXSwKICAgICAgICAgICAgICAgIHt9CiAgICAgICAgICAgICkuYWRkVG8obWFya2VyX2NsdXN0ZXJfY2E5YTQ2ODQxM2FiNGI0YWIwNTJiOWIxN2ViNDg5ZDApOwogICAgICAgIAogICAgCiAgICAgICAgdmFyIHBvcHVwXzc0ZmFjN2Q3YmNiMjQ0YmVhMmFmOTVmYjAzZTczNmE1ID0gTC5wb3B1cCh7Im1heFdpZHRoIjogIjEwMCUifSk7CgogICAgICAgIAogICAgICAgICAgICB2YXIgaHRtbF81M2YwMWEwYTQ4NGI0NDg0YmRhNDViODA4MjIwMjMzOCA9ICQoYDxkaXYgaWQ9Imh0bWxfNTNmMDFhMGE0ODRiNDQ4NGJkYTQ1YjgwODIyMDIzMzgiIHN0eWxlPSJ3aWR0aDogMTAwLjAlOyBoZWlnaHQ6IDEwMC4wJTsiPk5hbWU6IEhBR0VSIE1FQURPV1MgRElUQ0ggUHJlY2lwOiAwLjEyPC9kaXY+YClbMF07CiAgICAgICAgICAgIHBvcHVwXzc0ZmFjN2Q3YmNiMjQ0YmVhMmFmOTVmYjAzZTczNmE1LnNldENvbnRlbnQoaHRtbF81M2YwMWEwYTQ4NGI0NDg0YmRhNDViODA4MjIwMjMzOCk7CiAgICAgICAgCgogICAgICAgIG1hcmtlcl9hOTlmZWIxNzYyMWI0YTcwOWJhNWU3ZTVmNGU4NmU0YS5iaW5kUG9wdXAocG9wdXBfNzRmYWM3ZDdiY2IyNDRiZWEyYWY5NWZiMDNlNzM2YTUpCiAgICAgICAgOwoKICAgICAgICAKICAgIAogICAgCiAgICAgICAgICAgIHZhciBtYXJrZXJfZDI5NTJlNDFjMWNmNDhlNWJiM2YxODk2ZmM1ZDA2MTYgPSBMLm1hcmtlcigKICAgICAgICAgICAgICAgIFs0MC4yNTYyNzYsIC0xMDUuMjA5NDE2XSwKICAgICAgICAgICAgICAgIHt9CiAgICAgICAgICAgICkuYWRkVG8obWFya2VyX2NsdXN0ZXJfY2E5YTQ2ODQxM2FiNGI0YWIwNTJiOWIxN2ViNDg5ZDApOwogICAgICAgIAogICAgCiAgICAgICAgdmFyIHBvcHVwX2JhNzRhYmVkNzAxYjRkNmJhYWRmM2VmMWI2NTdjY2RhID0gTC5wb3B1cCh7Im1heFdpZHRoIjogIjEwMCUifSk7CgogICAgICAgIAogICAgICAgICAgICB2YXIgaHRtbF84ZTY0NjgwNjNhMjI0ZjFiYWQ4YzZlZThhNDlhMTViMiA9ICQoYDxkaXYgaWQ9Imh0bWxfOGU2NDY4MDYzYTIyNGYxYmFkOGM2ZWU4YTQ5YTE1YjIiIHN0eWxlPSJ3aWR0aDogMTAwLjAlOyBoZWlnaHQ6IDEwMC4wJTsiPk5hbWU6IExJVFRMRSBUSE9NUFNPTiAjMSBESVRDSCBQcmVjaXA6IDAuMDA8L2Rpdj5gKVswXTsKICAgICAgICAgICAgcG9wdXBfYmE3NGFiZWQ3MDFiNGQ2YmFhZGYzZWYxYjY1N2NjZGEuc2V0Q29udGVudChodG1sXzhlNjQ2ODA2M2EyMjRmMWJhZDhjNmVlOGE0OWExNWIyKTsKICAgICAgICAKCiAgICAgICAgbWFya2VyX2QyOTUyZTQxYzFjZjQ4ZTViYjNmMTg5NmZjNWQwNjE2LmJpbmRQb3B1cChwb3B1cF9iYTc0YWJlZDcwMWI0ZDZiYWFkZjNlZjFiNjU3Y2NkYSkKICAgICAgICA7CgogICAgICAgIAogICAgCiAgICAKICAgICAgICAgICAgdmFyIG1hcmtlcl80Zjg5Mzk4NDQzNjg0MTcyOTMyNWQxMTcxYzNjMWVhOSA9IEwubWFya2VyKAogICAgICAgICAgICAgICAgWzQwLjI2MDgyNywgLTEwNS4xOTg1NjddLAogICAgICAgICAgICAgICAge30KICAgICAgICAgICAgKS5hZGRUbyhtYXJrZXJfY2x1c3Rlcl9jYTlhNDY4NDEzYWI0YjRhYjA1MmI5YjE3ZWI0ODlkMCk7CiAgICAgICAgCiAgICAKICAgICAgICB2YXIgcG9wdXBfNjBlN2JmNGJmZjcxNDJhYWEzMmI2ZGZiMGEwZjIyMmYgPSBMLnBvcHVwKHsibWF4V2lkdGgiOiAiMTAwJSJ9KTsKCiAgICAgICAgCiAgICAgICAgICAgIHZhciBodG1sX2I3OGZkYmVlN2JlODRhM2M5NDZjYmM5M2U4MDMyNTkzID0gJChgPGRpdiBpZD0iaHRtbF9iNzhmZGJlZTdiZTg0YTNjOTQ2Y2JjOTNlODAzMjU5MyIgc3R5bGU9IndpZHRoOiAxMDAuMCU7IGhlaWdodDogMTAwLjAlOyI+TmFtZTogQ1VMVkVSIERJVENIIFByZWNpcDogMC4wMDwvZGl2PmApWzBdOwogICAgICAgICAgICBwb3B1cF82MGU3YmY0YmZmNzE0MmFhYTMyYjZkZmIwYTBmMjIyZi5zZXRDb250ZW50KGh0bWxfYjc4ZmRiZWU3YmU4NGEzYzk0NmNiYzkzZTgwMzI1OTMpOwogICAgICAgIAoKICAgICAgICBtYXJrZXJfNGY4OTM5ODQ0MzY4NDE3MjkzMjVkMTE3MWMzYzFlYTkuYmluZFBvcHVwKHBvcHVwXzYwZTdiZjRiZmY3MTQyYWFhMzJiNmRmYjBhMGYyMjJmKQogICAgICAgIDsKCiAgICAgICAgCiAgICAKICAgIAogICAgICAgICAgICB2YXIgbWFya2VyXzRhN2M1ZmY3OTg4YzQ5ZThiNzJjZjQ1N2NjNTMyZTk4ID0gTC5tYXJrZXIoCiAgICAgICAgICAgICAgICBbNDAuMjE1MDQzLCAtMTA1LjI1NjAxN10sCiAgICAgICAgICAgICAgICB7fQogICAgICAgICAgICApLmFkZFRvKG1hcmtlcl9jbHVzdGVyX2NhOWE0Njg0MTNhYjRiNGFiMDUyYjliMTdlYjQ4OWQwKTsKICAgICAgICAKICAgIAogICAgICAgIHZhciBwb3B1cF8yNDYzNWUwYWRlNTM0Yjg5ODA2NzQwMTE4YTlmZGY5YyA9IEwucG9wdXAoeyJtYXhXaWR0aCI6ICIxMDAlIn0pOwoKICAgICAgICAKICAgICAgICAgICAgdmFyIGh0bWxfZjczNzVlZTU5NmM4NGM1Zjg5YzQ4YjZhZmM3YjBjYmIgPSAkKGA8ZGl2IGlkPSJodG1sX2Y3Mzc1ZWU1OTZjODRjNWY4OWM0OGI2YWZjN2IwY2JiIiBzdHlsZT0id2lkdGg6IDEwMC4wJTsgaGVpZ2h0OiAxMDAuMCU7Ij5OYW1lOiBISUdITEFORCBESVRDSCBBVCBMWU9OUywgQ08gUHJlY2lwOiAzOC45MDwvZGl2PmApWzBdOwogICAgICAgICAgICBwb3B1cF8yNDYzNWUwYWRlNTM0Yjg5ODA2NzQwMTE4YTlmZGY5Yy5zZXRDb250ZW50KGh0bWxfZjczNzVlZTU5NmM4NGM1Zjg5YzQ4YjZhZmM3YjBjYmIpOwogICAgICAgIAoKICAgICAgICBtYXJrZXJfNGE3YzVmZjc5ODhjNDllOGI3MmNmNDU3Y2M1MzJlOTguYmluZFBvcHVwKHBvcHVwXzI0NjM1ZTBhZGU1MzRiODk4MDY3NDAxMThhOWZkZjljKQogICAgICAgIDsKCiAgICAgICAgCiAgICAKICAgIAogICAgICAgICAgICB2YXIgbWFya2VyXzEyNDE0Yzg4MzJjYjQyZjc5MTM5YmY0NDdhODAyMzQ4ID0gTC5tYXJrZXIoCiAgICAgICAgICAgICAgICBbNDAuMDc4NTYsIC0xMDUuMjIwNDk3XSwKICAgICAgICAgICAgICAgIHt9CiAgICAgICAgICAgICkuYWRkVG8obWFya2VyX2NsdXN0ZXJfY2E5YTQ2ODQxM2FiNGI0YWIwNTJiOWIxN2ViNDg5ZDApOwogICAgICAgIAogICAgCiAgICAgICAgdmFyIHBvcHVwXzE2NDBiZWI2NGYwZjRhYTBiMmNhZGRlNzhlMGIwNmVlID0gTC5wb3B1cCh7Im1heFdpZHRoIjogIjEwMCUifSk7CgogICAgICAgIAogICAgICAgICAgICB2YXIgaHRtbF9lYzE5NDQzMjUyOGM0MWNmYjIzMzQyODM0ZmZhY2M2ZiA9ICQoYDxkaXYgaWQ9Imh0bWxfZWMxOTQ0MzI1MjhjNDFjZmIyMzM0MjgzNGZmYWNjNmYiIHN0eWxlPSJ3aWR0aDogMTAwLjAlOyBoZWlnaHQ6IDEwMC4wJTsiPk5hbWU6IEJPVUxERVIgUkVTRVJWT0lSIFByZWNpcDogNTIxMS41MDwvZGl2PmApWzBdOwogICAgICAgICAgICBwb3B1cF8xNjQwYmViNjRmMGY0YWEwYjJjYWRkZTc4ZTBiMDZlZS5zZXRDb250ZW50KGh0bWxfZWMxOTQ0MzI1MjhjNDFjZmIyMzM0MjgzNGZmYWNjNmYpOwogICAgICAgIAoKICAgICAgICBtYXJrZXJfMTI0MTRjODgzMmNiNDJmNzkxMzliZjQ0N2E4MDIzNDguYmluZFBvcHVwKHBvcHVwXzE2NDBiZWI2NGYwZjRhYTBiMmNhZGRlNzhlMGIwNmVlKQogICAgICAgIDsKCiAgICAgICAgCiAgICAKICAgIAogICAgICAgICAgICB2YXIgbWFya2VyX2ViNzc3MjI0N2M4NjRkNGY5YzQyZGU3OWNiMzYyNTFkID0gTC5tYXJrZXIoCiAgICAgICAgICAgICAgICBbNDAuMTczOTUsIC0xMDUuMTY5Mzc0XSwKICAgICAgICAgICAgICAgIHt9CiAgICAgICAgICAgICkuYWRkVG8obWFya2VyX2NsdXN0ZXJfY2E5YTQ2ODQxM2FiNGI0YWIwNTJiOWIxN2ViNDg5ZDApOwogICAgICAgIAogICAgCiAgICAgICAgdmFyIHBvcHVwXzM4NDEwOTkzZmZmMDQ5YzY4MWM1ZGE0ZDBiZDRjODQzID0gTC5wb3B1cCh7Im1heFdpZHRoIjogIjEwMCUifSk7CgogICAgICAgIAogICAgICAgICAgICB2YXIgaHRtbF81OTZiYjM3NjkyNTM0ZjYxOTU2OTU4MGUxMjIxMmIxYiA9ICQoYDxkaXYgaWQ9Imh0bWxfNTk2YmIzNzY5MjUzNGY2MTk1Njk1ODBlMTIyMTJiMWIiIHN0eWxlPSJ3aWR0aDogMTAwLjAlOyBoZWlnaHQ6IDEwMC4wJTsiPk5hbWU6IE5JV09UIERJVENIIFByZWNpcDogMC4xOTwvZGl2PmApWzBdOwogICAgICAgICAgICBwb3B1cF8zODQxMDk5M2ZmZjA0OWM2ODFjNWRhNGQwYmQ0Yzg0My5zZXRDb250ZW50KGh0bWxfNTk2YmIzNzY5MjUzNGY2MTk1Njk1ODBlMTIyMTJiMWIpOwogICAgICAgIAoKICAgICAgICBtYXJrZXJfZWI3NzcyMjQ3Yzg2NGQ0ZjljNDJkZTc5Y2IzNjI1MWQuYmluZFBvcHVwKHBvcHVwXzM4NDEwOTkzZmZmMDQ5YzY4MWM1ZGE0ZDBiZDRjODQzKQogICAgICAgIDsKCiAgICAgICAgCiAgICAKICAgIAogICAgICAgICAgICB2YXIgbWFya2VyX2I2MDJiODU0YWMyMzRiMWFhYTU2ZjA1MGVhNDE5ZWI2ID0gTC5tYXJrZXIoCiAgICAgICAgICAgICAgICBbNDAuMjExMzg5LCAtMTA1LjI1MDk1Ml0sCiAgICAgICAgICAgICAgICB7fQogICAgICAgICAgICApLmFkZFRvKG1hcmtlcl9jbHVzdGVyX2NhOWE0Njg0MTNhYjRiNGFiMDUyYjliMTdlYjQ4OWQwKTsKICAgICAgICAKICAgIAogICAgICAgIHZhciBwb3B1cF9hZDIyMDgxODA1YjE0NGFhODYyNWJiYzQ0NGY5ODNhOSA9IEwucG9wdXAoeyJtYXhXaWR0aCI6ICIxMDAlIn0pOwoKICAgICAgICAKICAgICAgICAgICAgdmFyIGh0bWxfYzQ3OTVlMzEyNGY5NDViNDhkY2NjNTQ3ODJhZmI5YmMgPSAkKGA8ZGl2IGlkPSJodG1sX2M0Nzk1ZTMxMjRmOTQ1YjQ4ZGNjYzU0NzgyYWZiOWJjIiBzdHlsZT0id2lkdGg6IDEwMC4wJTsgaGVpZ2h0OiAxMDAuMCU7Ij5OYW1lOiBTTUVBRCBESVRDSCBQcmVjaXA6IDAuMDA8L2Rpdj5gKVswXTsKICAgICAgICAgICAgcG9wdXBfYWQyMjA4MTgwNWIxNDRhYTg2MjViYmM0NDRmOTgzYTkuc2V0Q29udGVudChodG1sX2M0Nzk1ZTMxMjRmOTQ1YjQ4ZGNjYzU0NzgyYWZiOWJjKTsKICAgICAgICAKCiAgICAgICAgbWFya2VyX2I2MDJiODU0YWMyMzRiMWFhYTU2ZjA1MGVhNDE5ZWI2LmJpbmRQb3B1cChwb3B1cF9hZDIyMDgxODA1YjE0NGFhODYyNWJiYzQ0NGY5ODNhOSkKICAgICAgICA7CgogICAgICAgIAogICAgCiAgICAKICAgICAgICAgICAgdmFyIG1hcmtlcl84NTdhNGNjYWJlZDk0YTZiODFlNDVkYjA1ZGMxYjE0NCA9IEwubWFya2VyKAogICAgICAgICAgICAgICAgWzQwLjE1MzM2MywgLTEwNS4wODg2OTVdLAogICAgICAgICAgICAgICAge30KICAgICAgICAgICAgKS5hZGRUbyhtYXJrZXJfY2x1c3Rlcl9jYTlhNDY4NDEzYWI0YjRhYjA1MmI5YjE3ZWI0ODlkMCk7CiAgICAgICAgCiAgICAKICAgICAgICB2YXIgcG9wdXBfZDA1NTdmMDU3MjI1NDIzMmIyNGM2Yjk1ZmU1ODc0YzkgPSBMLnBvcHVwKHsibWF4V2lkdGgiOiAiMTAwJSJ9KTsKCiAgICAgICAgCiAgICAgICAgICAgIHZhciBodG1sXzc5NzI3NDcxODY4MTRhZDE5M2JjYjU5NGFjZDM3ZjczID0gJChgPGRpdiBpZD0iaHRtbF83OTcyNzQ3MTg2ODE0YWQxOTNiY2I1OTRhY2QzN2Y3MyIgc3R5bGU9IndpZHRoOiAxMDAuMCU7IGhlaWdodDogMTAwLjAlOyI+TmFtZTogQk9OVVMgRElUQ0ggUHJlY2lwOiAwLjEwPC9kaXY+YClbMF07CiAgICAgICAgICAgIHBvcHVwX2QwNTU3ZjA1NzIyNTQyMzJiMjRjNmI5NWZlNTg3NGM5LnNldENvbnRlbnQoaHRtbF83OTcyNzQ3MTg2ODE0YWQxOTNiY2I1OTRhY2QzN2Y3Myk7CiAgICAgICAgCgogICAgICAgIG1hcmtlcl84NTdhNGNjYWJlZDk0YTZiODFlNDVkYjA1ZGMxYjE0NC5iaW5kUG9wdXAocG9wdXBfZDA1NTdmMDU3MjI1NDIzMmIyNGM2Yjk1ZmU1ODc0YzkpCiAgICAgICAgOwoKICAgICAgICAKICAgIAogICAgCiAgICAgICAgICAgIHZhciBtYXJrZXJfNmY1YjU0OWJlMWI0NGVjOTk1NTA5NGM0MzJhZjc2YmMgPSBMLm1hcmtlcigKICAgICAgICAgICAgICAgIFs0MC4yMTEwODMsIC0xMDUuMjUwOTI3XSwKICAgICAgICAgICAgICAgIHt9CiAgICAgICAgICAgICkuYWRkVG8obWFya2VyX2NsdXN0ZXJfY2E5YTQ2ODQxM2FiNGI0YWIwNTJiOWIxN2ViNDg5ZDApOwogICAgICAgIAogICAgCiAgICAgICAgdmFyIHBvcHVwXzcwZDhkZmI4ZGFkOTQzMThiMTI2Y2M5ODQyYTFiODM1ID0gTC5wb3B1cCh7Im1heFdpZHRoIjogIjEwMCUifSk7CgogICAgICAgIAogICAgICAgICAgICB2YXIgaHRtbF83OTEyOWU2ZmI0NDI0OTRiOGI4YTA2OGQxYWE2NDE2YiA9ICQoYDxkaXYgaWQ9Imh0bWxfNzkxMjllNmZiNDQyNDk0YjhiOGEwNjhkMWFhNjQxNmIiIHN0eWxlPSJ3aWR0aDogMTAwLjAlOyBoZWlnaHQ6IDEwMC4wJTsiPk5hbWU6IFNXRURFIERJVENIIFByZWNpcDogMC4wMDwvZGl2PmApWzBdOwogICAgICAgICAgICBwb3B1cF83MGQ4ZGZiOGRhZDk0MzE4YjEyNmNjOTg0MmExYjgzNS5zZXRDb250ZW50KGh0bWxfNzkxMjllNmZiNDQyNDk0YjhiOGEwNjhkMWFhNjQxNmIpOwogICAgICAgIAoKICAgICAgICBtYXJrZXJfNmY1YjU0OWJlMWI0NGVjOTk1NTA5NGM0MzJhZjc2YmMuYmluZFBvcHVwKHBvcHVwXzcwZDhkZmI4ZGFkOTQzMThiMTI2Y2M5ODQyYTFiODM1KQogICAgICAgIDsKCiAgICAgICAgCiAgICAKICAgIAogICAgICAgICAgICB2YXIgbWFya2VyXzZjNzUxMTUyZTUwYTRjMzM4NTAxOWU5Mzk1NGViMWU2ID0gTC5tYXJrZXIoCiAgICAgICAgICAgICAgICBbNDAuMTg3NTI0LCAtMTA1LjE4OTEzMl0sCiAgICAgICAgICAgICAgICB7fQogICAgICAgICAgICApLmFkZFRvKG1hcmtlcl9jbHVzdGVyX2NhOWE0Njg0MTNhYjRiNGFiMDUyYjliMTdlYjQ4OWQwKTsKICAgICAgICAKICAgIAogICAgICAgIHZhciBwb3B1cF8wZmI2ZmY0NDZhNWE0Y2UyOGJhOGYyYzA1MWI2NWIxZSA9IEwucG9wdXAoeyJtYXhXaWR0aCI6ICIxMDAlIn0pOwoKICAgICAgICAKICAgICAgICAgICAgdmFyIGh0bWxfODA2NmY1NDkxMzc0NGM1N2JiZmVlMmY5MGM1YzFjZGQgPSAkKGA8ZGl2IGlkPSJodG1sXzgwNjZmNTQ5MTM3NDRjNTdiYmZlZTJmOTBjNWMxY2RkIiBzdHlsZT0id2lkdGg6IDEwMC4wJTsgaGVpZ2h0OiAxMDAuMCU7Ij5OYW1lOiBSVU5ZT04gRElUQ0ggUHJlY2lwOiAwLjAwPC9kaXY+YClbMF07CiAgICAgICAgICAgIHBvcHVwXzBmYjZmZjQ0NmE1YTRjZTI4YmE4ZjJjMDUxYjY1YjFlLnNldENvbnRlbnQoaHRtbF84MDY2ZjU0OTEzNzQ0YzU3YmJmZWUyZjkwYzVjMWNkZCk7CiAgICAgICAgCgogICAgICAgIG1hcmtlcl82Yzc1MTE1MmU1MGE0YzMzODUwMTllOTM5NTRlYjFlNi5iaW5kUG9wdXAocG9wdXBfMGZiNmZmNDQ2YTVhNGNlMjhiYThmMmMwNTFiNjViMWUpCiAgICAgICAgOwoKICAgICAgICAKICAgIAogICAgCiAgICAgICAgICAgIHZhciBtYXJrZXJfNTNhZjA2ZTVjM2FlNDRjYWEzZjFiYzJhNjJjZGIzOWIgPSBMLm1hcmtlcigKICAgICAgICAgICAgICAgIFs0MC4xODE4OCwgLTEwNS4xOTY3NzVdLAogICAgICAgICAgICAgICAge30KICAgICAgICAgICAgKS5hZGRUbyhtYXJrZXJfY2x1c3Rlcl9jYTlhNDY4NDEzYWI0YjRhYjA1MmI5YjE3ZWI0ODlkMCk7CiAgICAgICAgCiAgICAKICAgICAgICB2YXIgcG9wdXBfMTE5OGZlMzc5MmQ0NDU1YWFhY2VlMDYzZWRmNWU4ZjAgPSBMLnBvcHVwKHsibWF4V2lkdGgiOiAiMTAwJSJ9KTsKCiAgICAgICAgCiAgICAgICAgICAgIHZhciBodG1sXzc3ZjFiNTU1NjY3OTQ4Mzc4YjJlMjkwMWEwZDhmZTQ3ID0gJChgPGRpdiBpZD0iaHRtbF83N2YxYjU1NTY2Nzk0ODM3OGIyZTI5MDFhMGQ4ZmU0NyIgc3R5bGU9IndpZHRoOiAxMDAuMCU7IGhlaWdodDogMTAwLjAlOyI+TmFtZTogREFWSVMgQU5EIERPV05JTkcgRElUQ0ggUHJlY2lwOiAwLjAwPC9kaXY+YClbMF07CiAgICAgICAgICAgIHBvcHVwXzExOThmZTM3OTJkNDQ1NWFhYWNlZTA2M2VkZjVlOGYwLnNldENvbnRlbnQoaHRtbF83N2YxYjU1NTY2Nzk0ODM3OGIyZTI5MDFhMGQ4ZmU0Nyk7CiAgICAgICAgCgogICAgICAgIG1hcmtlcl81M2FmMDZlNWMzYWU0NGNhYTNmMWJjMmE2MmNkYjM5Yi5iaW5kUG9wdXAocG9wdXBfMTE5OGZlMzc5MmQ0NDU1YWFhY2VlMDYzZWRmNWU4ZjApCiAgICAgICAgOwoKICAgICAgICAKICAgIAogICAgCiAgICAgICAgICAgIHZhciBtYXJrZXJfNTUwZjQwMzQwZjNkNGI2NmFkMjBjNWVmZjVjNzA1ODYgPSBMLm1hcmtlcigKICAgICAgICAgICAgICAgIFs0MC4wMTg2NjcsIC0xMDUuMzI2MjVdLAogICAgICAgICAgICAgICAge30KICAgICAgICAgICAgKS5hZGRUbyhtYXJrZXJfY2x1c3Rlcl9jYTlhNDY4NDEzYWI0YjRhYjA1MmI5YjE3ZWI0ODlkMCk7CiAgICAgICAgCiAgICAKICAgICAgICB2YXIgcG9wdXBfOWViZDIwMDU0YjlhNDRkOGFjMzhhZDE4YTk0Yjg5YzAgPSBMLnBvcHVwKHsibWF4V2lkdGgiOiAiMTAwJSJ9KTsKCiAgICAgICAgCiAgICAgICAgICAgIHZhciBodG1sXzI2ZTlkZGQ0ZWZjNTQzYTI5NGYxOGU1OWE3YWVhMDhmID0gJChgPGRpdiBpZD0iaHRtbF8yNmU5ZGRkNGVmYzU0M2EyOTRmMThlNTlhN2FlYTA4ZiIgc3R5bGU9IndpZHRoOiAxMDAuMCU7IGhlaWdodDogMTAwLjAlOyI+TmFtZTogRk9VUk1JTEUgQ1JFRUsgQVQgT1JPREVMTCwgQ08gUHJlY2lwOiAwLjc0PC9kaXY+YClbMF07CiAgICAgICAgICAgIHBvcHVwXzllYmQyMDA1NGI5YTQ0ZDhhYzM4YWQxOGE5NGI4OWMwLnNldENvbnRlbnQoaHRtbF8yNmU5ZGRkNGVmYzU0M2EyOTRmMThlNTlhN2FlYTA4Zik7CiAgICAgICAgCgogICAgICAgIG1hcmtlcl81NTBmNDAzNDBmM2Q0YjY2YWQyMGM1ZWZmNWM3MDU4Ni5iaW5kUG9wdXAocG9wdXBfOWViZDIwMDU0YjlhNDRkOGFjMzhhZDE4YTk0Yjg5YzApCiAgICAgICAgOwoKICAgICAgICAKICAgIAogICAgCiAgICAgICAgICAgIHZhciBtYXJrZXJfOGMzYWUzOGQyOWVkNDYwZDliYjNhNzQzZGJiYTQ0NGQgPSBMLm1hcmtlcigKICAgICAgICAgICAgICAgIFs0MC4xODg1NzksIC0xMDUuMjA5MjgyXSwKICAgICAgICAgICAgICAgIHt9CiAgICAgICAgICAgICkuYWRkVG8obWFya2VyX2NsdXN0ZXJfY2E5YTQ2ODQxM2FiNGI0YWIwNTJiOWIxN2ViNDg5ZDApOwogICAgICAgIAogICAgCiAgICAgICAgdmFyIHBvcHVwXzU0ZTM1MzMzMTAwMDQ4MDRhMDQxZjFhMjQ2YTc5NjZhID0gTC5wb3B1cCh7Im1heFdpZHRoIjogIjEwMCUifSk7CgogICAgICAgIAogICAgICAgICAgICB2YXIgaHRtbF9iZGYxYmU4NmYxZGM0ZTY3YTk2YmY0OWMxNGJiMzhhMiA9ICQoYDxkaXYgaWQ9Imh0bWxfYmRmMWJlODZmMWRjNGU2N2E5NmJmNDljMTRiYjM4YTIiIHN0eWxlPSJ3aWR0aDogMTAwLjAlOyBoZWlnaHQ6IDEwMC4wJTsiPk5hbWU6IEpBTUVTIERJVENIIFByZWNpcDogMC4xMjwvZGl2PmApWzBdOwogICAgICAgICAgICBwb3B1cF81NGUzNTMzMzEwMDA0ODA0YTA0MWYxYTI0NmE3OTY2YS5zZXRDb250ZW50KGh0bWxfYmRmMWJlODZmMWRjNGU2N2E5NmJmNDljMTRiYjM4YTIpOwogICAgICAgIAoKICAgICAgICBtYXJrZXJfOGMzYWUzOGQyOWVkNDYwZDliYjNhNzQzZGJiYTQ0NGQuYmluZFBvcHVwKHBvcHVwXzU0ZTM1MzMzMTAwMDQ4MDRhMDQxZjFhMjQ2YTc5NjZhKQogICAgICAgIDsKCiAgICAgICAgCiAgICAKICAgIAogICAgICAgICAgICB2YXIgbWFya2VyXzlhMjRlZTZlYWUyZTQ2ZWI4MjMwNTEyZGEwNzNhYTRhID0gTC5tYXJrZXIoCiAgICAgICAgICAgICAgICBbNDAuMDUzMDM1LCAtMTA1LjE5MzA0OF0sCiAgICAgICAgICAgICAgICB7fQogICAgICAgICAgICApLmFkZFRvKG1hcmtlcl9jbHVzdGVyX2NhOWE0Njg0MTNhYjRiNGFiMDUyYjliMTdlYjQ4OWQwKTsKICAgICAgICAKICAgIAogICAgICAgIHZhciBwb3B1cF84ZTcwOWNkMjI1ZWM0ODcwOWI0NWIwOGVlYmNkZjA5NiA9IEwucG9wdXAoeyJtYXhXaWR0aCI6ICIxMDAlIn0pOwoKICAgICAgICAKICAgICAgICAgICAgdmFyIGh0bWxfNWU4ZjY3ZTEzODNkNDM2NjhlMDJiNjU0ZjI0YThiODggPSAkKGA8ZGl2IGlkPSJodG1sXzVlOGY2N2UxMzgzZDQzNjY4ZTAyYjY1NGYyNGE4Yjg4IiBzdHlsZT0id2lkdGg6IDEwMC4wJTsgaGVpZ2h0OiAxMDAuMCU7Ij5OYW1lOiBCT1VMREVSIENSRUVLIFNVUFBMWSBDQU5BTCBUTyBCT1VMREVSIENSRUVLIE5FQVIgQk9VTERFUiBQcmVjaXA6IDAuMDA8L2Rpdj5gKVswXTsKICAgICAgICAgICAgcG9wdXBfOGU3MDljZDIyNWVjNDg3MDliNDViMDhlZWJjZGYwOTYuc2V0Q29udGVudChodG1sXzVlOGY2N2UxMzgzZDQzNjY4ZTAyYjY1NGYyNGE4Yjg4KTsKICAgICAgICAKCiAgICAgICAgbWFya2VyXzlhMjRlZTZlYWUyZTQ2ZWI4MjMwNTEyZGEwNzNhYTRhLmJpbmRQb3B1cChwb3B1cF84ZTcwOWNkMjI1ZWM0ODcwOWI0NWIwOGVlYmNkZjA5NikKICAgICAgICA7CgogICAgICAgIAogICAgCiAgICAKICAgICAgICAgICAgdmFyIG1hcmtlcl8yYWQxZDQ1ZDdmZjg0YzM0YjA5OWY0ZjZhZDk4YTU1OSA9IEwubWFya2VyKAogICAgICAgICAgICAgICAgWzQwLjI1ODM2NywgLTEwNS4xNzQ5NTddLAogICAgICAgICAgICAgICAge30KICAgICAgICAgICAgKS5hZGRUbyhtYXJrZXJfY2x1c3Rlcl9jYTlhNDY4NDEzYWI0YjRhYjA1MmI5YjE3ZWI0ODlkMCk7CiAgICAgICAgCiAgICAKICAgICAgICB2YXIgcG9wdXBfMTU5OTFhOTgxOGEzNDA1YjgyYTZhYWZlNjk5YzhhNTEgPSBMLnBvcHVwKHsibWF4V2lkdGgiOiAiMTAwJSJ9KTsKCiAgICAgICAgCiAgICAgICAgICAgIHZhciBodG1sXzliMTUzY2YxZDViYjQ1MGNhZDE4NDk4OWQ3NTZiMmIxID0gJChgPGRpdiBpZD0iaHRtbF85YjE1M2NmMWQ1YmI0NTBjYWQxODQ5ODlkNzU2YjJiMSIgc3R5bGU9IndpZHRoOiAxMDAuMCU7IGhlaWdodDogMTAwLjAlOyI+TmFtZTogQk9VTERFUi1MQVJJTUVSIERJVENIIE5FQVIgQkVSVEhPVUQgUHJlY2lwOiAwLjAwPC9kaXY+YClbMF07CiAgICAgICAgICAgIHBvcHVwXzE1OTkxYTk4MThhMzQwNWI4MmE2YWFmZTY5OWM4YTUxLnNldENvbnRlbnQoaHRtbF85YjE1M2NmMWQ1YmI0NTBjYWQxODQ5ODlkNzU2YjJiMSk7CiAgICAgICAgCgogICAgICAgIG1hcmtlcl8yYWQxZDQ1ZDdmZjg0YzM0YjA5OWY0ZjZhZDk4YTU1OS5iaW5kUG9wdXAocG9wdXBfMTU5OTFhOTgxOGEzNDA1YjgyYTZhYWZlNjk5YzhhNTEpCiAgICAgICAgOwoKICAgICAgICAKICAgIAogICAgCiAgICAgICAgICAgIHZhciBtYXJrZXJfZDlkMjRjYWUwOTgyNDBlOGIzMTY4YzcxNmQ0YWNkOTEgPSBMLm1hcmtlcigKICAgICAgICAgICAgICAgIFszOS45MzgzNTEsIC0xMDUuMzQ3OTA2XSwKICAgICAgICAgICAgICAgIHt9CiAgICAgICAgICAgICkuYWRkVG8obWFya2VyX2NsdXN0ZXJfY2E5YTQ2ODQxM2FiNGI0YWIwNTJiOWIxN2ViNDg5ZDApOwogICAgICAgIAogICAgCiAgICAgICAgdmFyIHBvcHVwXzRmYmIzNTQ1ZjcyNjRhNWE5OWZlYTZmOGE2ZTAxY2RjID0gTC5wb3B1cCh7Im1heFdpZHRoIjogIjEwMCUifSk7CgogICAgICAgIAogICAgICAgICAgICB2YXIgaHRtbF9lYzI0YTY1Yzk3Y2E0ZTU2YjdiY2U0ODUwNzA3MTNmMiA9ICQoYDxkaXYgaWQ9Imh0bWxfZWMyNGE2NWM5N2NhNGU1NmI3YmNlNDg1MDcwNzEzZjIiIHN0eWxlPSJ3aWR0aDogMTAwLjAlOyBoZWlnaHQ6IDEwMC4wJTsiPk5hbWU6IFNPVVRIIEJPVUxERVIgQ1JFRUsgQkVMT1cgR1JPU1MgUkVTRVJWT0lSIFByZWNpcDogMTYuNDA8L2Rpdj5gKVswXTsKICAgICAgICAgICAgcG9wdXBfNGZiYjM1NDVmNzI2NGE1YTk5ZmVhNmY4YTZlMDFjZGMuc2V0Q29udGVudChodG1sX2VjMjRhNjVjOTdjYTRlNTZiN2JjZTQ4NTA3MDcxM2YyKTsKICAgICAgICAKCiAgICAgICAgbWFya2VyX2Q5ZDI0Y2FlMDk4MjQwZThiMzE2OGM3MTZkNGFjZDkxLmJpbmRQb3B1cChwb3B1cF80ZmJiMzU0NWY3MjY0YTVhOTlmZWE2ZjhhNmUwMWNkYykKICAgICAgICA7CgogICAgICAgIAogICAgCiAgICAKICAgICAgICAgICAgdmFyIG1hcmtlcl9mY2YwYWUyYWFlY2I0ZTQxYTU0NWQ4YjAxYmI2NGVjMiA9IEwubWFya2VyKAogICAgICAgICAgICAgICAgWzQwLjIxMjUwNSwgLTEwNS4yNTE4MjZdLAogICAgICAgICAgICAgICAge30KICAgICAgICAgICAgKS5hZGRUbyhtYXJrZXJfY2x1c3Rlcl9jYTlhNDY4NDEzYWI0YjRhYjA1MmI5YjE3ZWI0ODlkMCk7CiAgICAgICAgCiAgICAKICAgICAgICB2YXIgcG9wdXBfNjljMjU4ZmJiMmQ3NGE4NmFmMjM1ZjI4NDlkYjBiYzQgPSBMLnBvcHVwKHsibWF4V2lkdGgiOiAiMTAwJSJ9KTsKCiAgICAgICAgCiAgICAgICAgICAgIHZhciBodG1sXzIwZWYxYzdiOTg5OTQ2ZjI4NWMwNDMxZjcwNDY1ZDc4ID0gJChgPGRpdiBpZD0iaHRtbF8yMGVmMWM3Yjk4OTk0NmYyODVjMDQzMWY3MDQ2NWQ3OCIgc3R5bGU9IndpZHRoOiAxMDAuMCU7IGhlaWdodDogMTAwLjAlOyI+TmFtZTogUEFMTUVSVE9OIERJVENIIFByZWNpcDogMS4wODwvZGl2PmApWzBdOwogICAgICAgICAgICBwb3B1cF82OWMyNThmYmIyZDc0YTg2YWYyMzVmMjg0OWRiMGJjNC5zZXRDb250ZW50KGh0bWxfMjBlZjFjN2I5ODk5NDZmMjg1YzA0MzFmNzA0NjVkNzgpOwogICAgICAgIAoKICAgICAgICBtYXJrZXJfZmNmMGFlMmFhZWNiNGU0MWE1NDVkOGIwMWJiNjRlYzIuYmluZFBvcHVwKHBvcHVwXzY5YzI1OGZiYjJkNzRhODZhZjIzNWYyODQ5ZGIwYmM0KQogICAgICAgIDsKCiAgICAgICAgCiAgICAKICAgIAogICAgICAgICAgICB2YXIgbWFya2VyXzRhZGI5NjQ5ZDNkMTQ4YTA5YTgzODFhNTIzOTZiNjlmID0gTC5tYXJrZXIoCiAgICAgICAgICAgICAgICBbNDAuMjE5MDQ2LCAtMTA1LjI1OTc5NV0sCiAgICAgICAgICAgICAgICB7fQogICAgICAgICAgICApLmFkZFRvKG1hcmtlcl9jbHVzdGVyX2NhOWE0Njg0MTNhYjRiNGFiMDUyYjliMTdlYjQ4OWQwKTsKICAgICAgICAKICAgIAogICAgICAgIHZhciBwb3B1cF85YzRhYWVjOGEyYWM0NTFjOTA0YzQ2MDkzODFjN2NkZiA9IEwucG9wdXAoeyJtYXhXaWR0aCI6ICIxMDAlIn0pOwoKICAgICAgICAKICAgICAgICAgICAgdmFyIGh0bWxfYWEwMDUwMDE4NTYxNDU1NWI5YmJhZmE4MWE5NjFlZTUgPSAkKGA8ZGl2IGlkPSJodG1sX2FhMDA1MDAxODU2MTQ1NTViOWJiYWZhODFhOTYxZWU1IiBzdHlsZT0id2lkdGg6IDEwMC4wJTsgaGVpZ2h0OiAxMDAuMCU7Ij5OYW1lOiBTVVBQTFkgRElUQ0ggUHJlY2lwOiAwLjAwPC9kaXY+YClbMF07CiAgICAgICAgICAgIHBvcHVwXzljNGFhZWM4YTJhYzQ1MWM5MDRjNDYwOTM4MWM3Y2RmLnNldENvbnRlbnQoaHRtbF9hYTAwNTAwMTg1NjE0NTU1YjliYmFmYTgxYTk2MWVlNSk7CiAgICAgICAgCgogICAgICAgIG1hcmtlcl80YWRiOTY0OWQzZDE0OGEwOWE4MzgxYTUyMzk2YjY5Zi5iaW5kUG9wdXAocG9wdXBfOWM0YWFlYzhhMmFjNDUxYzkwNGM0NjA5MzgxYzdjZGYpCiAgICAgICAgOwoKICAgICAgICAKICAgIAogICAgCiAgICAgICAgICAgIHZhciBtYXJrZXJfZWZmMzZhMDI4YzM4NDc3ZmIxOTY2MmI3ZTYzYzc2MjkgPSBMLm1hcmtlcigKICAgICAgICAgICAgICAgIFs0MC4xODc1NzgsIC0xMDUuMTg5MTkxXSwKICAgICAgICAgICAgICAgIHt9CiAgICAgICAgICAgICkuYWRkVG8obWFya2VyX2NsdXN0ZXJfY2E5YTQ2ODQxM2FiNGI0YWIwNTJiOWIxN2ViNDg5ZDApOwogICAgICAgIAogICAgCiAgICAgICAgdmFyIHBvcHVwXzUwNWFhNTQwNWQ2ZjRmZTFiYWYwYWJhZGU5M2EwYThiID0gTC5wb3B1cCh7Im1heFdpZHRoIjogIjEwMCUifSk7CgogICAgICAgIAogICAgICAgICAgICB2YXIgaHRtbF8wOGE1NTVmYWE0Zjc0ODBlYjYzODYwMDE1NzQxMTRkMyA9ICQoYDxkaXYgaWQ9Imh0bWxfMDhhNTU1ZmFhNGY3NDgwZWI2Mzg2MDAxNTc0MTE0ZDMiIHN0eWxlPSJ3aWR0aDogMTAwLjAlOyBoZWlnaHQ6IDEwMC4wJTsiPk5hbWU6IERFTklPIFRBWUxPUiBESVRDSCBQcmVjaXA6IDI4MTkuNjg8L2Rpdj5gKVswXTsKICAgICAgICAgICAgcG9wdXBfNTA1YWE1NDA1ZDZmNGZlMWJhZjBhYmFkZTkzYTBhOGIuc2V0Q29udGVudChodG1sXzA4YTU1NWZhYTRmNzQ4MGViNjM4NjAwMTU3NDExNGQzKTsKICAgICAgICAKCiAgICAgICAgbWFya2VyX2VmZjM2YTAyOGMzODQ3N2ZiMTk2NjJiN2U2M2M3NjI5LmJpbmRQb3B1cChwb3B1cF81MDVhYTU0MDVkNmY0ZmUxYmFmMGFiYWRlOTNhMGE4YikKICAgICAgICA7CgogICAgICAgIAogICAgCiAgICAKICAgICAgICAgICAgdmFyIG1hcmtlcl82YTU2OTViMGY3ZWQ0MzVjOTc4YTVhMjYyZmY2NTdhZiA9IEwubWFya2VyKAogICAgICAgICAgICAgICAgWzQwLjA0MjAyOCwgLTEwNS4zNjQ5MTddLAogICAgICAgICAgICAgICAge30KICAgICAgICAgICAgKS5hZGRUbyhtYXJrZXJfY2x1c3Rlcl9jYTlhNDY4NDEzYWI0YjRhYjA1MmI5YjE3ZWI0ODlkMCk7CiAgICAgICAgCiAgICAKICAgICAgICB2YXIgcG9wdXBfY2YyYzc0MzViN2Q5NDE2NGI3MjNkMGFkNTg1NzdhNzkgPSBMLnBvcHVwKHsibWF4V2lkdGgiOiAiMTAwJSJ9KTsKCiAgICAgICAgCiAgICAgICAgICAgIHZhciBodG1sXzAxMGM5ZTk5MWJjYzRjY2JiMWQzYmYyZmQxYzI0ZjlmID0gJChgPGRpdiBpZD0iaHRtbF8wMTBjOWU5OTFiY2M0Y2NiYjFkM2JmMmZkMWMyNGY5ZiIgc3R5bGU9IndpZHRoOiAxMDAuMCU7IGhlaWdodDogMTAwLjAlOyI+TmFtZTogRk9VUk1JTEUgQ1JFRUsgQVQgTE9HQU4gTUlMTCBST0FEIE5FQVIgQ1JJU01BTiwgQ08gUHJlY2lwOiBuYW48L2Rpdj5gKVswXTsKICAgICAgICAgICAgcG9wdXBfY2YyYzc0MzViN2Q5NDE2NGI3MjNkMGFkNTg1NzdhNzkuc2V0Q29udGVudChodG1sXzAxMGM5ZTk5MWJjYzRjY2JiMWQzYmYyZmQxYzI0ZjlmKTsKICAgICAgICAKCiAgICAgICAgbWFya2VyXzZhNTY5NWIwZjdlZDQzNWM5NzhhNWEyNjJmZjY1N2FmLmJpbmRQb3B1cChwb3B1cF9jZjJjNzQzNWI3ZDk0MTY0YjcyM2QwYWQ1ODU3N2E3OSkKICAgICAgICA7CgogICAgICAgIAogICAgCiAgICAKICAgICAgICAgICAgdmFyIG1hcmtlcl83ZWJjOGNlOWIyZDg0NjdjYjZjNTMyN2I1ZmMyMTMyMiA9IEwubWFya2VyKAogICAgICAgICAgICAgICAgWzQwLjE3NzA4LCAtMTA1LjE3ODU2N10sCiAgICAgICAgICAgICAgICB7fQogICAgICAgICAgICApLmFkZFRvKG1hcmtlcl9jbHVzdGVyX2NhOWE0Njg0MTNhYjRiNGFiMDUyYjliMTdlYjQ4OWQwKTsKICAgICAgICAKICAgIAogICAgICAgIHZhciBwb3B1cF9hMjMwYjE4M2RjZmY0ZDFjYTZiZjYyZGIwMTczY2IxYyA9IEwucG9wdXAoeyJtYXhXaWR0aCI6ICIxMDAlIn0pOwoKICAgICAgICAKICAgICAgICAgICAgdmFyIGh0bWxfOTQwYWE4ZWU2ODFmNDNiNmFmMTUwNTUwZGY3MWFmNzYgPSAkKGA8ZGl2IGlkPSJodG1sXzk0MGFhOGVlNjgxZjQzYjZhZjE1MDU1MGRmNzFhZjc2IiBzdHlsZT0id2lkdGg6IDEwMC4wJTsgaGVpZ2h0OiAxMDAuMCU7Ij5OYW1lOiBQRUNLIFBFTExBIENMT1ZFUiBESVRDSCBQcmVjaXA6IDEuMjk8L2Rpdj5gKVswXTsKICAgICAgICAgICAgcG9wdXBfYTIzMGIxODNkY2ZmNGQxY2E2YmY2MmRiMDE3M2NiMWMuc2V0Q29udGVudChodG1sXzk0MGFhOGVlNjgxZjQzYjZhZjE1MDU1MGRmNzFhZjc2KTsKICAgICAgICAKCiAgICAgICAgbWFya2VyXzdlYmM4Y2U5YjJkODQ2N2NiNmM1MzI3YjVmYzIxMzIyLmJpbmRQb3B1cChwb3B1cF9hMjMwYjE4M2RjZmY0ZDFjYTZiZjYyZGIwMTczY2IxYykKICAgICAgICA7CgogICAgICAgIAogICAgCiAgICAKICAgICAgICAgICAgdmFyIG1hcmtlcl81MDE3YzFhNzg2NGU0OTA5ODczNWRlOThkZGZjZDU4YSA9IEwubWFya2VyKAogICAgICAgICAgICAgICAgWzM5Ljk0NzcwNCwgLTEwNS4zNTczMDhdLAogICAgICAgICAgICAgICAge30KICAgICAgICAgICAgKS5hZGRUbyhtYXJrZXJfY2x1c3Rlcl9jYTlhNDY4NDEzYWI0YjRhYjA1MmI5YjE3ZWI0ODlkMCk7CiAgICAgICAgCiAgICAKICAgICAgICB2YXIgcG9wdXBfZTI4ZGRmMDJhNzE4NDY2MzkyZjUzYzVlM2M0N2YwMmUgPSBMLnBvcHVwKHsibWF4V2lkdGgiOiAiMTAwJSJ9KTsKCiAgICAgICAgCiAgICAgICAgICAgIHZhciBodG1sX2E2NGEzMmI0NTExNjRhNzg4MTY5OGMyMmUwYWFlM2Y0ID0gJChgPGRpdiBpZD0iaHRtbF9hNjRhMzJiNDUxMTY0YTc4ODE2OThjMjJlMGFhZTNmNCIgc3R5bGU9IndpZHRoOiAxMDAuMCU7IGhlaWdodDogMTAwLjAlOyI+TmFtZTogR1JPU1MgUkVTRVJWT0lSICBQcmVjaXA6IDExMzY4LjAwPC9kaXY+YClbMF07CiAgICAgICAgICAgIHBvcHVwX2UyOGRkZjAyYTcxODQ2NjM5MmY1M2M1ZTNjNDdmMDJlLnNldENvbnRlbnQoaHRtbF9hNjRhMzJiNDUxMTY0YTc4ODE2OThjMjJlMGFhZTNmNCk7CiAgICAgICAgCgogICAgICAgIG1hcmtlcl81MDE3YzFhNzg2NGU0OTA5ODczNWRlOThkZGZjZDU4YS5iaW5kUG9wdXAocG9wdXBfZTI4ZGRmMDJhNzE4NDY2MzkyZjUzYzVlM2M0N2YwMmUpCiAgICAgICAgOwoKICAgICAgICAKICAgIAo8L3NjcmlwdD4=" style="position:absolute;width:100%;height:100%;left:0;top:0;border:none !important;" allowfullscreen webkitallowfullscreen mozallowfullscreen></iframe></div></div>





<div class="notice--info" markdown="1">

## Additional Resources

* <a href="https://blog.datafiniti.co/4-reasons-you-should-use-json-instead-of-csv-2cac362f1943" target="_blank">Why you should use JSON instead of csv.</a>


* <a href="https://www.w3schools.com/js/js_json_intro.asp" target="_blank">W3schools JSON intro </a>

</div>

