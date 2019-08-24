---
layout: single
title: 'Programmatically Accessing Geospatial Data Using APIs'
excerpt: 'This lesson walks through the process of retrieving and manipulating surface water data housed in the Colorado Information Warehouse. These data are stored in JSON format with spatial x, y information that support mapping.'
authors: ['Carson Farmer', 'Leah Wasser', 'Max Joseph', 'Martha Morrissey', 'Jenny Palomino']
modified: 2019-08-24
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



    [{'station_name': 'SOUTH FLAT DITCH',
      'div': '1',
      'location': {'latitude': '40.170998',
       'needs_recoding': False,
       'longitude': '-105.160876'},
      'dwr_abbrev': 'SFLDITCO',
      'data_source': 'Cooperative Program of CDWR, NCWCD & SVLHWCD',
      'amount': '6.26',
      'station_type': 'Diversion',
      'wd': '5',
      'http_linkage': {'url': 'https://dwr.state.co.us/SurfaceWater/data/detail_graph.aspx?ID=SFLDITCO&MTYPE=DISCHRG'},
      'date_time': '2019-08-23T20:00:00.000',
      'county': 'BOULDER',
      'variable': 'DISCHRG',
      'stage': '0.66',
      'station_status': 'Active'},
     {'station_name': 'ROUGH AND READY DITCH',
      'div': '1',
      'location': {'latitude': '40.212658',
       'needs_recoding': False,
       'longitude': '-105.251826'},
      'dwr_abbrev': 'ROUREACO',
      'data_source': 'Cooperative Program of CDWR, NCWCD & SVLHWCD',
      'amount': '0.08',
      'station_type': 'Diversion',
      'wd': '5',
      'http_linkage': {'url': 'https://dwr.state.co.us/SurfaceWater/data/detail_graph.aspx?ID=ROUREACO&MTYPE=DISCHRG'},
      'date_time': '2019-08-23T20:00:00.000',
      'county': 'BOULDER',
      'variable': 'DISCHRG',
      'stage': '0.03',
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
    </tr>
  </thead>
  <tbody>
    <tr>
      <td>0</td>
      <td>SOUTH FLAT DITCH</td>
      <td>1</td>
      <td>SFLDITCO</td>
      <td>Cooperative Program of CDWR, NCWCD &amp; SVLHWCD</td>
      <td>6.26</td>
      <td>Diversion</td>
      <td>5</td>
      <td>2019-08-23T20:00:00.000</td>
      <td>BOULDER</td>
      <td>DISCHRG</td>
      <td>0.66</td>
      <td>Active</td>
      <td>40.170998</td>
      <td>False</td>
      <td>-105.160876</td>
      <td>https://dwr.state.co.us/SurfaceWater/data/deta...</td>
      <td>NaN</td>
    </tr>
    <tr>
      <td>1</td>
      <td>ROUGH AND READY DITCH</td>
      <td>1</td>
      <td>ROUREACO</td>
      <td>Cooperative Program of CDWR, NCWCD &amp; SVLHWCD</td>
      <td>0.08</td>
      <td>Diversion</td>
      <td>5</td>
      <td>2019-08-23T20:00:00.000</td>
      <td>BOULDER</td>
      <td>DISCHRG</td>
      <td>0.03</td>
      <td>Active</td>
      <td>40.212658</td>
      <td>False</td>
      <td>-105.251826</td>
      <td>https://dwr.state.co.us/SurfaceWater/data/deta...</td>
      <td>NaN</td>
    </tr>
    <tr>
      <td>2</td>
      <td>WEBSTER MCCASLIN DITCH</td>
      <td>1</td>
      <td>WEBDITCO</td>
      <td>Cooperative Program of CDWR, NCWCD &amp; SVLHWCD</td>
      <td>0.29</td>
      <td>Diversion</td>
      <td>5</td>
      <td>2019-08-23T20:00:00.000</td>
      <td>BOULDER</td>
      <td>DISCHRG</td>
      <td>0.14</td>
      <td>Active</td>
      <td>40.19328</td>
      <td>False</td>
      <td>-105.210424</td>
      <td>https://dwr.state.co.us/SurfaceWater/data/deta...</td>
      <td>NaN</td>
    </tr>
    <tr>
      <td>3</td>
      <td>GOSS DITCH 1</td>
      <td>1</td>
      <td>GODIT1CO</td>
      <td>Cooperative Program of CDWR, NCWCD &amp; SVLHWCD</td>
      <td>9.14</td>
      <td>Diversion</td>
      <td>5</td>
      <td>2019-08-23T19:45:00.000</td>
      <td>BOULDER</td>
      <td>DISCHRG</td>
      <td>1.09</td>
      <td>Active</td>
      <td>40.199321</td>
      <td>False</td>
      <td>-105.222639</td>
      <td>https://dwr.state.co.us/SurfaceWater/data/deta...</td>
      <td>NaN</td>
    </tr>
    <tr>
      <td>4</td>
      <td>BOULDER CREEK FEEDER CANAL NEAR LYONS</td>
      <td>1</td>
      <td>BFCLYOCO</td>
      <td>Northern Colorado Water Conservancy District (...</td>
      <td>58.50</td>
      <td>Diversion</td>
      <td>5</td>
      <td>2019-08-23T20:30:00.000</td>
      <td>BOULDER</td>
      <td>DISCHRG</td>
      <td>1.31</td>
      <td>Active</td>
      <td>40.215904</td>
      <td>False</td>
      <td>-105.257736</td>
      <td>https://dwr.state.co.us/SurfaceWater/data/deta...</td>
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
           'location.longitude', 'http_linkage.url', 'usgs_station_id'],
          dtype='object')





## Data Cleaning for Visualization

Now you can clean up the data. Notice that your longitude and latitude values are stored as strings. Do you think can create a map if these values are stored as strings?

{:.input}
```python
result['location.latitude'][0]
```

{:.output}
{:.execute_result}



    '40.170998'





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



    40.170998





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



    -105.160876





Now that you have numeric values for mapping, make sure that are are no missing values. 

{:.input}
```python
result.shape
```

{:.output}
{:.execute_result}



    (57, 17)





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
      <th>geometry</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td>0</td>
      <td>SOUTH FLAT DITCH</td>
      <td>1</td>
      <td>SFLDITCO</td>
      <td>Cooperative Program of CDWR, NCWCD &amp; SVLHWCD</td>
      <td>6.26</td>
      <td>Diversion</td>
      <td>5</td>
      <td>2019-08-23T20:00:00.000</td>
      <td>BOULDER</td>
      <td>DISCHRG</td>
      <td>0.66</td>
      <td>Active</td>
      <td>40.170998</td>
      <td>False</td>
      <td>-105.160876</td>
      <td>https://dwr.state.co.us/SurfaceWater/data/deta...</td>
      <td>NaN</td>
      <td>POINT (-105.160876 40.170998)</td>
    </tr>
    <tr>
      <td>1</td>
      <td>ROUGH AND READY DITCH</td>
      <td>1</td>
      <td>ROUREACO</td>
      <td>Cooperative Program of CDWR, NCWCD &amp; SVLHWCD</td>
      <td>0.08</td>
      <td>Diversion</td>
      <td>5</td>
      <td>2019-08-23T20:00:00.000</td>
      <td>BOULDER</td>
      <td>DISCHRG</td>
      <td>0.03</td>
      <td>Active</td>
      <td>40.212658</td>
      <td>False</td>
      <td>-105.251826</td>
      <td>https://dwr.state.co.us/SurfaceWater/data/deta...</td>
      <td>NaN</td>
      <td>POINT (-105.251826 40.212658)</td>
    </tr>
    <tr>
      <td>2</td>
      <td>WEBSTER MCCASLIN DITCH</td>
      <td>1</td>
      <td>WEBDITCO</td>
      <td>Cooperative Program of CDWR, NCWCD &amp; SVLHWCD</td>
      <td>0.29</td>
      <td>Diversion</td>
      <td>5</td>
      <td>2019-08-23T20:00:00.000</td>
      <td>BOULDER</td>
      <td>DISCHRG</td>
      <td>0.14</td>
      <td>Active</td>
      <td>40.193280</td>
      <td>False</td>
      <td>-105.210424</td>
      <td>https://dwr.state.co.us/SurfaceWater/data/deta...</td>
      <td>NaN</td>
      <td>POINT (-105.210424 40.19328)</td>
    </tr>
    <tr>
      <td>3</td>
      <td>GOSS DITCH 1</td>
      <td>1</td>
      <td>GODIT1CO</td>
      <td>Cooperative Program of CDWR, NCWCD &amp; SVLHWCD</td>
      <td>9.14</td>
      <td>Diversion</td>
      <td>5</td>
      <td>2019-08-23T19:45:00.000</td>
      <td>BOULDER</td>
      <td>DISCHRG</td>
      <td>1.09</td>
      <td>Active</td>
      <td>40.199321</td>
      <td>False</td>
      <td>-105.222639</td>
      <td>https://dwr.state.co.us/SurfaceWater/data/deta...</td>
      <td>NaN</td>
      <td>POINT (-105.222639 40.199321)</td>
    </tr>
    <tr>
      <td>4</td>
      <td>BOULDER CREEK FEEDER CANAL NEAR LYONS</td>
      <td>1</td>
      <td>BFCLYOCO</td>
      <td>Northern Colorado Water Conservancy District (...</td>
      <td>58.50</td>
      <td>Diversion</td>
      <td>5</td>
      <td>2019-08-23T20:30:00.000</td>
      <td>BOULDER</td>
      <td>DISCHRG</td>
      <td>1.31</td>
      <td>Active</td>
      <td>40.215904</td>
      <td>False</td>
      <td>-105.257736</td>
      <td>https://dwr.state.co.us/SurfaceWater/data/deta...</td>
      <td>NaN</td>
      <td>POINT (-105.257736 40.215904)</td>
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



<div style="width:100%;"><div style="position:relative;width:100%;height:0;padding-bottom:60%;"><iframe src="data:text/html;charset=utf-8;base64,PCFET0NUWVBFIGh0bWw+CjxoZWFkPiAgICAKICAgIDxtZXRhIGh0dHAtZXF1aXY9ImNvbnRlbnQtdHlwZSIgY29udGVudD0idGV4dC9odG1sOyBjaGFyc2V0PVVURi04IiAvPgogICAgCiAgICAgICAgPHNjcmlwdD4KICAgICAgICAgICAgTF9OT19UT1VDSCA9IGZhbHNlOwogICAgICAgICAgICBMX0RJU0FCTEVfM0QgPSBmYWxzZTsKICAgICAgICA8L3NjcmlwdD4KICAgIAogICAgPHNjcmlwdCBzcmM9Imh0dHBzOi8vY2RuLmpzZGVsaXZyLm5ldC9ucG0vbGVhZmxldEAxLjUuMS9kaXN0L2xlYWZsZXQuanMiPjwvc2NyaXB0PgogICAgPHNjcmlwdCBzcmM9Imh0dHBzOi8vY29kZS5qcXVlcnkuY29tL2pxdWVyeS0xLjEyLjQubWluLmpzIj48L3NjcmlwdD4KICAgIDxzY3JpcHQgc3JjPSJodHRwczovL21heGNkbi5ib290c3RyYXBjZG4uY29tL2Jvb3RzdHJhcC8zLjIuMC9qcy9ib290c3RyYXAubWluLmpzIj48L3NjcmlwdD4KICAgIDxzY3JpcHQgc3JjPSJodHRwczovL2NkbmpzLmNsb3VkZmxhcmUuY29tL2FqYXgvbGlicy9MZWFmbGV0LmF3ZXNvbWUtbWFya2Vycy8yLjAuMi9sZWFmbGV0LmF3ZXNvbWUtbWFya2Vycy5qcyI+PC9zY3JpcHQ+CiAgICA8bGluayByZWw9InN0eWxlc2hlZXQiIGhyZWY9Imh0dHBzOi8vY2RuLmpzZGVsaXZyLm5ldC9ucG0vbGVhZmxldEAxLjUuMS9kaXN0L2xlYWZsZXQuY3NzIi8+CiAgICA8bGluayByZWw9InN0eWxlc2hlZXQiIGhyZWY9Imh0dHBzOi8vbWF4Y2RuLmJvb3RzdHJhcGNkbi5jb20vYm9vdHN0cmFwLzMuMi4wL2Nzcy9ib290c3RyYXAubWluLmNzcyIvPgogICAgPGxpbmsgcmVsPSJzdHlsZXNoZWV0IiBocmVmPSJodHRwczovL21heGNkbi5ib290c3RyYXBjZG4uY29tL2Jvb3RzdHJhcC8zLjIuMC9jc3MvYm9vdHN0cmFwLXRoZW1lLm1pbi5jc3MiLz4KICAgIDxsaW5rIHJlbD0ic3R5bGVzaGVldCIgaHJlZj0iaHR0cHM6Ly9tYXhjZG4uYm9vdHN0cmFwY2RuLmNvbS9mb250LWF3ZXNvbWUvNC42LjMvY3NzL2ZvbnQtYXdlc29tZS5taW4uY3NzIi8+CiAgICA8bGluayByZWw9InN0eWxlc2hlZXQiIGhyZWY9Imh0dHBzOi8vY2RuanMuY2xvdWRmbGFyZS5jb20vYWpheC9saWJzL0xlYWZsZXQuYXdlc29tZS1tYXJrZXJzLzIuMC4yL2xlYWZsZXQuYXdlc29tZS1tYXJrZXJzLmNzcyIvPgogICAgPGxpbmsgcmVsPSJzdHlsZXNoZWV0IiBocmVmPSJodHRwczovL3Jhd2Nkbi5naXRoYWNrLmNvbS9weXRob24tdmlzdWFsaXphdGlvbi9mb2xpdW0vbWFzdGVyL2ZvbGl1bS90ZW1wbGF0ZXMvbGVhZmxldC5hd2Vzb21lLnJvdGF0ZS5jc3MiLz4KICAgIDxzdHlsZT5odG1sLCBib2R5IHt3aWR0aDogMTAwJTtoZWlnaHQ6IDEwMCU7bWFyZ2luOiAwO3BhZGRpbmc6IDA7fTwvc3R5bGU+CiAgICA8c3R5bGU+I21hcCB7cG9zaXRpb246YWJzb2x1dGU7dG9wOjA7Ym90dG9tOjA7cmlnaHQ6MDtsZWZ0OjA7fTwvc3R5bGU+CiAgICAKICAgICAgICAgICAgPG1ldGEgbmFtZT0idmlld3BvcnQiIGNvbnRlbnQ9IndpZHRoPWRldmljZS13aWR0aCwKICAgICAgICAgICAgICAgIGluaXRpYWwtc2NhbGU9MS4wLCBtYXhpbXVtLXNjYWxlPTEuMCwgdXNlci1zY2FsYWJsZT1ubyIgLz4KICAgICAgICAgICAgPHN0eWxlPgogICAgICAgICAgICAgICAgI21hcF9jNTBkYzNlYzNlOGY0YWE1ODQ5NGIwMjU5MmMzMWI3NCB7CiAgICAgICAgICAgICAgICAgICAgcG9zaXRpb246IHJlbGF0aXZlOwogICAgICAgICAgICAgICAgICAgIHdpZHRoOiAxMDAuMCU7CiAgICAgICAgICAgICAgICAgICAgaGVpZ2h0OiAxMDAuMCU7CiAgICAgICAgICAgICAgICAgICAgbGVmdDogMC4wJTsKICAgICAgICAgICAgICAgICAgICB0b3A6IDAuMCU7CiAgICAgICAgICAgICAgICB9CiAgICAgICAgICAgIDwvc3R5bGU+CiAgICAgICAgCjwvaGVhZD4KPGJvZHk+ICAgIAogICAgCiAgICAgICAgICAgIDxkaXYgY2xhc3M9ImZvbGl1bS1tYXAiIGlkPSJtYXBfYzUwZGMzZWMzZThmNGFhNTg0OTRiMDI1OTJjMzFiNzQiID48L2Rpdj4KICAgICAgICAKPC9ib2R5Pgo8c2NyaXB0PiAgICAKICAgIAogICAgICAgICAgICB2YXIgbWFwX2M1MGRjM2VjM2U4ZjRhYTU4NDk0YjAyNTkyYzMxYjc0ID0gTC5tYXAoCiAgICAgICAgICAgICAgICAibWFwX2M1MGRjM2VjM2U4ZjRhYTU4NDk0YjAyNTkyYzMxYjc0IiwKICAgICAgICAgICAgICAgIHsKICAgICAgICAgICAgICAgICAgICBjZW50ZXI6IFs0MC4wMSwgLTEwNS4yN10sCiAgICAgICAgICAgICAgICAgICAgY3JzOiBMLkNSUy5FUFNHMzg1NywKICAgICAgICAgICAgICAgICAgICB6b29tOiAxMCwKICAgICAgICAgICAgICAgICAgICB6b29tQ29udHJvbDogdHJ1ZSwKICAgICAgICAgICAgICAgICAgICBwcmVmZXJDYW52YXM6IGZhbHNlLAogICAgICAgICAgICAgICAgfQogICAgICAgICAgICApOwoKICAgICAgICAgICAgCgogICAgICAgIAogICAgCiAgICAgICAgICAgIHZhciB0aWxlX2xheWVyX2M5NDYxYTM3ZDViNDQxYjdhOGJlNTI1OGYzYjQ0OTRkID0gTC50aWxlTGF5ZXIoCiAgICAgICAgICAgICAgICAiaHR0cHM6Ly9jYXJ0b2RiLWJhc2VtYXBzLXtzfS5nbG9iYWwuc3NsLmZhc3RseS5uZXQvbGlnaHRfYWxsL3t6fS97eH0ve3l9LnBuZyIsCiAgICAgICAgICAgICAgICB7ImF0dHJpYnV0aW9uIjogIlx1MDAyNmNvcHk7IFx1MDAzY2EgaHJlZj1cImh0dHA6Ly93d3cub3BlbnN0cmVldG1hcC5vcmcvY29weXJpZ2h0XCJcdTAwM2VPcGVuU3RyZWV0TWFwXHUwMDNjL2FcdTAwM2UgY29udHJpYnV0b3JzIFx1MDAyNmNvcHk7IFx1MDAzY2EgaHJlZj1cImh0dHA6Ly9jYXJ0b2RiLmNvbS9hdHRyaWJ1dGlvbnNcIlx1MDAzZUNhcnRvREJcdTAwM2MvYVx1MDAzZSwgQ2FydG9EQiBcdTAwM2NhIGhyZWYgPVwiaHR0cDovL2NhcnRvZGIuY29tL2F0dHJpYnV0aW9uc1wiXHUwMDNlYXR0cmlidXRpb25zXHUwMDNjL2FcdTAwM2UiLCAiZGV0ZWN0UmV0aW5hIjogZmFsc2UsICJtYXhOYXRpdmVab29tIjogMTgsICJtYXhab29tIjogMTgsICJtaW5ab29tIjogMCwgIm5vV3JhcCI6IGZhbHNlLCAib3BhY2l0eSI6IDEsICJzdWJkb21haW5zIjogImFiYyIsICJ0bXMiOiBmYWxzZX0KICAgICAgICAgICAgKS5hZGRUbyhtYXBfYzUwZGMzZWMzZThmNGFhNTg0OTRiMDI1OTJjMzFiNzQpOwogICAgICAgIAogICAgCiAgICAgICAgZnVuY3Rpb24gZ2VvX2pzb25fMWExYjE1OGIyYjI3NDNhNTk2MTAzMjE3MDdhMWRhMTBfb25FYWNoRmVhdHVyZShmZWF0dXJlLCBsYXllcikgewogICAgICAgICAgICBsYXllci5vbih7CiAgICAgICAgICAgICAgICBjbGljazogZnVuY3Rpb24oZSkgewogICAgICAgICAgICAgICAgICAgIG1hcF9jNTBkYzNlYzNlOGY0YWE1ODQ5NGIwMjU5MmMzMWI3NC5maXRCb3VuZHMoZS50YXJnZXQuZ2V0Qm91bmRzKCkpOwogICAgICAgICAgICAgICAgfQogICAgICAgICAgICB9KTsKICAgICAgICB9OwogICAgICAgIHZhciBnZW9fanNvbl8xYTFiMTU4YjJiMjc0M2E1OTYxMDMyMTcwN2ExZGExMCA9IEwuZ2VvSnNvbihudWxsLCB7CiAgICAgICAgICAgICAgICBvbkVhY2hGZWF0dXJlOiBnZW9fanNvbl8xYTFiMTU4YjJiMjc0M2E1OTYxMDMyMTcwN2ExZGExMF9vbkVhY2hGZWF0dXJlLAogICAgICAgICAgICAKICAgICAgICB9KS5hZGRUbyhtYXBfYzUwZGMzZWMzZThmNGFhNTg0OTRiMDI1OTJjMzFiNzQpOwogICAgICAgICAgICBnZW9fanNvbl8xYTFiMTU4YjJiMjc0M2E1OTYxMDMyMTcwN2ExZGExMC5hZGREYXRhKHsiYmJveCI6IFstMTA1LjUxNzExMSwgMzkuOTMxNTk3LCAtMTA1LjA3NTY5NTAwMDAwMDAxLCA0MC4yNjA4MjddLCAiZmVhdHVyZXMiOiBbeyJiYm94IjogWy0xMDUuMTYwODc2LCA0MC4xNzA5OTgsIC0xMDUuMTYwODc2LCA0MC4xNzA5OThdLCAiZ2VvbWV0cnkiOiB7ImNvb3JkaW5hdGVzIjogWy0xMDUuMTYwODc2LCA0MC4xNzA5OThdLCAidHlwZSI6ICJQb2ludCJ9LCAiaWQiOiAiMCIsICJwcm9wZXJ0aWVzIjogeyJhbW91bnQiOiAiNi4yNiIsICJjb3VudHkiOiAiQk9VTERFUiIsICJkYXRhX3NvdXJjZSI6ICJDb29wZXJhdGl2ZSBQcm9ncmFtIG9mIENEV1IsIE5DV0NEIFx1MDAyNiBTVkxIV0NEIiwgImRhdGVfdGltZSI6ICIyMDE5LTA4LTIzVDIwOjAwOjAwLjAwMCIsICJkaXYiOiAiMSIsICJkd3JfYWJicmV2IjogIlNGTERJVENPIiwgImh0dHBfbGlua2FnZS51cmwiOiAiaHR0cHM6Ly9kd3Iuc3RhdGUuY28udXMvU3VyZmFjZVdhdGVyL2RhdGEvZGV0YWlsX2dyYXBoLmFzcHg/SUQ9U0ZMRElUQ09cdTAwMjZNVFlQRT1ESVNDSFJHIiwgImxvY2F0aW9uLmxhdGl0dWRlIjogNDAuMTcwOTk4LCAibG9jYXRpb24ubG9uZ2l0dWRlIjogLTEwNS4xNjA4NzYsICJsb2NhdGlvbi5uZWVkc19yZWNvZGluZyI6IGZhbHNlLCAic3RhZ2UiOiAiMC42NiIsICJzdGF0aW9uX25hbWUiOiAiU09VVEggRkxBVCBESVRDSCIsICJzdGF0aW9uX3N0YXR1cyI6ICJBY3RpdmUiLCAic3RhdGlvbl90eXBlIjogIkRpdmVyc2lvbiIsICJ1c2dzX3N0YXRpb25faWQiOiBudWxsLCAidmFyaWFibGUiOiAiRElTQ0hSRyIsICJ3ZCI6ICI1In0sICJ0eXBlIjogIkZlYXR1cmUifSwgeyJiYm94IjogWy0xMDUuMjUxODI2LCA0MC4yMTI2NTgsIC0xMDUuMjUxODI2LCA0MC4yMTI2NThdLCAiZ2VvbWV0cnkiOiB7ImNvb3JkaW5hdGVzIjogWy0xMDUuMjUxODI2LCA0MC4yMTI2NThdLCAidHlwZSI6ICJQb2ludCJ9LCAiaWQiOiAiMSIsICJwcm9wZXJ0aWVzIjogeyJhbW91bnQiOiAiMC4wOCIsICJjb3VudHkiOiAiQk9VTERFUiIsICJkYXRhX3NvdXJjZSI6ICJDb29wZXJhdGl2ZSBQcm9ncmFtIG9mIENEV1IsIE5DV0NEIFx1MDAyNiBTVkxIV0NEIiwgImRhdGVfdGltZSI6ICIyMDE5LTA4LTIzVDIwOjAwOjAwLjAwMCIsICJkaXYiOiAiMSIsICJkd3JfYWJicmV2IjogIlJPVVJFQUNPIiwgImh0dHBfbGlua2FnZS51cmwiOiAiaHR0cHM6Ly9kd3Iuc3RhdGUuY28udXMvU3VyZmFjZVdhdGVyL2RhdGEvZGV0YWlsX2dyYXBoLmFzcHg/SUQ9Uk9VUkVBQ09cdTAwMjZNVFlQRT1ESVNDSFJHIiwgImxvY2F0aW9uLmxhdGl0dWRlIjogNDAuMjEyNjU4LCAibG9jYXRpb24ubG9uZ2l0dWRlIjogLTEwNS4yNTE4MjYsICJsb2NhdGlvbi5uZWVkc19yZWNvZGluZyI6IGZhbHNlLCAic3RhZ2UiOiAiMC4wMyIsICJzdGF0aW9uX25hbWUiOiAiUk9VR0ggQU5EIFJFQURZIERJVENIIiwgInN0YXRpb25fc3RhdHVzIjogIkFjdGl2ZSIsICJzdGF0aW9uX3R5cGUiOiAiRGl2ZXJzaW9uIiwgInVzZ3Nfc3RhdGlvbl9pZCI6IG51bGwsICJ2YXJpYWJsZSI6ICJESVNDSFJHIiwgIndkIjogIjUifSwgInR5cGUiOiAiRmVhdHVyZSJ9LCB7ImJib3giOiBbLTEwNS4yMTA0MjQsIDQwLjE5MzI4MDAwMDAwMDAxLCAtMTA1LjIxMDQyNCwgNDAuMTkzMjgwMDAwMDAwMDFdLCAiZ2VvbWV0cnkiOiB7ImNvb3JkaW5hdGVzIjogWy0xMDUuMjEwNDI0LCA0MC4xOTMyODAwMDAwMDAwMV0sICJ0eXBlIjogIlBvaW50In0sICJpZCI6ICIyIiwgInByb3BlcnRpZXMiOiB7ImFtb3VudCI6ICIwLjI5IiwgImNvdW50eSI6ICJCT1VMREVSIiwgImRhdGFfc291cmNlIjogIkNvb3BlcmF0aXZlIFByb2dyYW0gb2YgQ0RXUiwgTkNXQ0QgXHUwMDI2IFNWTEhXQ0QiLCAiZGF0ZV90aW1lIjogIjIwMTktMDgtMjNUMjA6MDA6MDAuMDAwIiwgImRpdiI6ICIxIiwgImR3cl9hYmJyZXYiOiAiV0VCRElUQ08iLCAiaHR0cF9saW5rYWdlLnVybCI6ICJodHRwczovL2R3ci5zdGF0ZS5jby51cy9TdXJmYWNlV2F0ZXIvZGF0YS9kZXRhaWxfZ3JhcGguYXNweD9JRD1XRUJESVRDT1x1MDAyNk1UWVBFPURJU0NIUkciLCAibG9jYXRpb24ubGF0aXR1ZGUiOiA0MC4xOTMyOCwgImxvY2F0aW9uLmxvbmdpdHVkZSI6IC0xMDUuMjEwNDI0LCAibG9jYXRpb24ubmVlZHNfcmVjb2RpbmciOiBmYWxzZSwgInN0YWdlIjogIjAuMTQiLCAic3RhdGlvbl9uYW1lIjogIldFQlNURVIgTUNDQVNMSU4gRElUQ0giLCAic3RhdGlvbl9zdGF0dXMiOiAiQWN0aXZlIiwgInN0YXRpb25fdHlwZSI6ICJEaXZlcnNpb24iLCAidXNnc19zdGF0aW9uX2lkIjogbnVsbCwgInZhcmlhYmxlIjogIkRJU0NIUkciLCAid2QiOiAiNSJ9LCAidHlwZSI6ICJGZWF0dXJlIn0sIHsiYmJveCI6IFstMTA1LjIyMjYzOSwgNDAuMTk5MzIxLCAtMTA1LjIyMjYzOSwgNDAuMTk5MzIxXSwgImdlb21ldHJ5IjogeyJjb29yZGluYXRlcyI6IFstMTA1LjIyMjYzOSwgNDAuMTk5MzIxXSwgInR5cGUiOiAiUG9pbnQifSwgImlkIjogIjMiLCAicHJvcGVydGllcyI6IHsiYW1vdW50IjogIjkuMTQiLCAiY291bnR5IjogIkJPVUxERVIiLCAiZGF0YV9zb3VyY2UiOiAiQ29vcGVyYXRpdmUgUHJvZ3JhbSBvZiBDRFdSLCBOQ1dDRCBcdTAwMjYgU1ZMSFdDRCIsICJkYXRlX3RpbWUiOiAiMjAxOS0wOC0yM1QxOTo0NTowMC4wMDAiLCAiZGl2IjogIjEiLCAiZHdyX2FiYnJldiI6ICJHT0RJVDFDTyIsICJodHRwX2xpbmthZ2UudXJsIjogImh0dHBzOi8vZHdyLnN0YXRlLmNvLnVzL1N1cmZhY2VXYXRlci9kYXRhL2RldGFpbF9ncmFwaC5hc3B4P0lEPUdPRElUMUNPXHUwMDI2TVRZUEU9RElTQ0hSRyIsICJsb2NhdGlvbi5sYXRpdHVkZSI6IDQwLjE5OTMyMSwgImxvY2F0aW9uLmxvbmdpdHVkZSI6IC0xMDUuMjIyNjM5LCAibG9jYXRpb24ubmVlZHNfcmVjb2RpbmciOiBmYWxzZSwgInN0YWdlIjogIjEuMDkiLCAic3RhdGlvbl9uYW1lIjogIkdPU1MgRElUQ0ggMSIsICJzdGF0aW9uX3N0YXR1cyI6ICJBY3RpdmUiLCAic3RhdGlvbl90eXBlIjogIkRpdmVyc2lvbiIsICJ1c2dzX3N0YXRpb25faWQiOiBudWxsLCAidmFyaWFibGUiOiAiRElTQ0hSRyIsICJ3ZCI6ICI1In0sICJ0eXBlIjogIkZlYXR1cmUifSwgeyJiYm94IjogWy0xMDUuMjU3NzM2LCA0MC4yMTU5MDQsIC0xMDUuMjU3NzM2LCA0MC4yMTU5MDRdLCAiZ2VvbWV0cnkiOiB7ImNvb3JkaW5hdGVzIjogWy0xMDUuMjU3NzM2LCA0MC4yMTU5MDRdLCAidHlwZSI6ICJQb2ludCJ9LCAiaWQiOiAiNCIsICJwcm9wZXJ0aWVzIjogeyJhbW91bnQiOiAiNTguNTAiLCAiY291bnR5IjogIkJPVUxERVIiLCAiZGF0YV9zb3VyY2UiOiAiTm9ydGhlcm4gQ29sb3JhZG8gV2F0ZXIgQ29uc2VydmFuY3kgRGlzdHJpY3QgKFN0YXRpb24gQ29vcGVyYXRvcikiLCAiZGF0ZV90aW1lIjogIjIwMTktMDgtMjNUMjA6MzA6MDAuMDAwIiwgImRpdiI6ICIxIiwgImR3cl9hYmJyZXYiOiAiQkZDTFlPQ08iLCAiaHR0cF9saW5rYWdlLnVybCI6ICJodHRwczovL2R3ci5zdGF0ZS5jby51cy9TdXJmYWNlV2F0ZXIvZGF0YS9kZXRhaWxfZ3JhcGguYXNweD9JRD1CRkNMWU9DT1x1MDAyNk1UWVBFPURJU0NIUkciLCAibG9jYXRpb24ubGF0aXR1ZGUiOiA0MC4yMTU5MDQsICJsb2NhdGlvbi5sb25naXR1ZGUiOiAtMTA1LjI1NzczNiwgImxvY2F0aW9uLm5lZWRzX3JlY29kaW5nIjogZmFsc2UsICJzdGFnZSI6ICIxLjMxIiwgInN0YXRpb25fbmFtZSI6ICJCT1VMREVSIENSRUVLIEZFRURFUiBDQU5BTCBORUFSIExZT05TIiwgInN0YXRpb25fc3RhdHVzIjogIkFjdGl2ZSIsICJzdGF0aW9uX3R5cGUiOiAiRGl2ZXJzaW9uIiwgInVzZ3Nfc3RhdGlvbl9pZCI6IG51bGwsICJ2YXJpYWJsZSI6ICJESVNDSFJHIiwgIndkIjogIjUifSwgInR5cGUiOiAiRmVhdHVyZSJ9LCB7ImJib3giOiBbLTEwNS4yMTg2NzcsIDM5Ljk4NjE2OSwgLTEwNS4yMTg2NzcsIDM5Ljk4NjE2OV0sICJnZW9tZXRyeSI6IHsiY29vcmRpbmF0ZXMiOiBbLTEwNS4yMTg2NzcsIDM5Ljk4NjE2OV0sICJ0eXBlIjogIlBvaW50In0sICJpZCI6ICI1IiwgInByb3BlcnRpZXMiOiB7ImFtb3VudCI6ICIyLjMxIiwgImNvdW50eSI6ICJCT1VMREVSIiwgImRhdGFfc291cmNlIjogIkNvb3BlcmF0aXZlIFByb2dyYW0gb2YgQ0RXUiwgTkNXQ0QgXHUwMDI2IExTUFdDRCIsICJkYXRlX3RpbWUiOiAiMjAxOS0wOC0yM1QxOTowMDowMC4wMDAiLCAiZGl2IjogIjEiLCAiZHdyX2FiYnJldiI6ICJEUllDQVJDTyIsICJodHRwX2xpbmthZ2UudXJsIjogImh0dHBzOi8vZHdyLnN0YXRlLmNvLnVzL1N1cmZhY2VXYXRlci9kYXRhL2RldGFpbF9ncmFwaC5hc3B4P0lEPURSWUNBUkNPXHUwMDI2TVRZUEU9RElTQ0hSRyIsICJsb2NhdGlvbi5sYXRpdHVkZSI6IDM5Ljk4NjE2OSwgImxvY2F0aW9uLmxvbmdpdHVkZSI6IC0xMDUuMjE4Njc3LCAibG9jYXRpb24ubmVlZHNfcmVjb2RpbmciOiBmYWxzZSwgInN0YWdlIjogIjAuMTciLCAic3RhdGlvbl9uYW1lIjogIkRSWSBDUkVFSyBDQVJSSUVSIiwgInN0YXRpb25fc3RhdHVzIjogIkFjdGl2ZSIsICJzdGF0aW9uX3R5cGUiOiAiRGl2ZXJzaW9uIiwgInVzZ3Nfc3RhdGlvbl9pZCI6IG51bGwsICJ2YXJpYWJsZSI6ICJESVNDSFJHIiwgIndkIjogIjYifSwgInR5cGUiOiAiRmVhdHVyZSJ9LCB7ImJib3giOiBbLTEwNS4xOTMwNDgsIDQwLjA1MzAzNSwgLTEwNS4xOTMwNDgsIDQwLjA1MzAzNV0sICJnZW9tZXRyeSI6IHsiY29vcmRpbmF0ZXMiOiBbLTEwNS4xOTMwNDgsIDQwLjA1MzAzNV0sICJ0eXBlIjogIlBvaW50In0sICJpZCI6ICI2IiwgInByb3BlcnRpZXMiOiB7ImFtb3VudCI6ICI3MS43OCIsICJjb3VudHkiOiAiQk9VTERFUiIsICJkYXRhX3NvdXJjZSI6ICJOb3J0aGVybiBDb2xvcmFkbyBXYXRlciBDb25zZXJ2YW5jeSBEaXN0cmljdCAoRGF0YSBQcm92aWRlcikiLCAiZGF0ZV90aW1lIjogIjIwMTktMDgtMjNUMjA6MDA6MDAuMDAwIiwgImRpdiI6ICIxIiwgImR3cl9hYmJyZXYiOiAiQkNTQ0JDQ08iLCAiaHR0cF9saW5rYWdlLnVybCI6ICJodHRwOi8vd3d3Lm5vcnRoZXJud2F0ZXIub3JnL1dhdGVyUHJvamVjdHMvRWFzdFNsb3BlV2F0ZXJEYXRhLmFzcHgiLCAibG9jYXRpb24ubGF0aXR1ZGUiOiA0MC4wNTMwMzUsICJsb2NhdGlvbi5sb25naXR1ZGUiOiAtMTA1LjE5MzA0OCwgImxvY2F0aW9uLm5lZWRzX3JlY29kaW5nIjogZmFsc2UsICJzdGFnZSI6ICIxLjQ1IiwgInN0YXRpb25fbmFtZSI6ICJCT1VMREVSIENSRUVLIFNVUFBMWSBDQU5BTCBUTyBCT1VMREVSIENSRUVLIE5FQVIgQk9VTERFUiIsICJzdGF0aW9uX3N0YXR1cyI6ICJBY3RpdmUiLCAic3RhdGlvbl90eXBlIjogIkRpdmVyc2lvbiIsICJ1c2dzX3N0YXRpb25faWQiOiAiRVMxOTE3IiwgInZhcmlhYmxlIjogIkRJU0NIUkciLCAid2QiOiAiNiJ9LCAidHlwZSI6ICJGZWF0dXJlIn0sIHsiYmJveCI6IFstMTA1LjM2MzQyMiwgNDAuMjE1NjU4LCAtMTA1LjM2MzQyMiwgNDAuMjE1NjU4XSwgImdlb21ldHJ5IjogeyJjb29yZGluYXRlcyI6IFstMTA1LjM2MzQyMiwgNDAuMjE1NjU4XSwgInR5cGUiOiAiUG9pbnQifSwgImlkIjogIjciLCAicHJvcGVydGllcyI6IHsiYW1vdW50IjogIjMwLjcwIiwgImNvdW50eSI6ICJCT1VMREVSIiwgImRhdGFfc291cmNlIjogIkNvLiBEaXZpc2lvbiBvZiBXYXRlciBSZXNvdXJjZXMiLCAiZGF0ZV90aW1lIjogIjIwMTktMDgtMjNUMjA6NDU6MDAuMDAwIiwgImRpdiI6ICIxIiwgImR3cl9hYmJyZXYiOiAiTlNWQkJSQ08iLCAiaHR0cF9saW5rYWdlLnVybCI6ICJodHRwczovL2R3ci5zdGF0ZS5jby51cy9TdXJmYWNlV2F0ZXIvZGF0YS9kZXRhaWxfZ3JhcGguYXNweD9JRD1OU1ZCQlJDT1x1MDAyNk1UWVBFPURJU0NIUkciLCAibG9jYXRpb24ubGF0aXR1ZGUiOiA0MC4yMTU2NTgsICJsb2NhdGlvbi5sb25naXR1ZGUiOiAtMTA1LjM2MzQyMiwgImxvY2F0aW9uLm5lZWRzX3JlY29kaW5nIjogZmFsc2UsICJzdGFnZSI6ICIwLjQ0IiwgInN0YXRpb25fbmFtZSI6ICJOT1JUSCBTQUlOVCBWUkFJTiBDUkVFSyBCRUxPVyBCVVRUT05ST0NLICAoUkFMUEggUFJJQ0UpIFJFU0VSVk9JUiIsICJzdGF0aW9uX3N0YXR1cyI6ICJBY3RpdmUiLCAic3RhdGlvbl90eXBlIjogIlN0cmVhbSIsICJ1c2dzX3N0YXRpb25faWQiOiBudWxsLCAidmFyaWFibGUiOiAiRElTQ0hSRyIsICJ3ZCI6ICI1In0sICJ0eXBlIjogIkZlYXR1cmUifSwgeyJiYm94IjogWy0xMDUuMjA5NDE2LCA0MC4yNTYyNzYwMDAwMDAwMSwgLTEwNS4yMDk0MTYsIDQwLjI1NjI3NjAwMDAwMDAxXSwgImdlb21ldHJ5IjogeyJjb29yZGluYXRlcyI6IFstMTA1LjIwOTQxNiwgNDAuMjU2Mjc2MDAwMDAwMDFdLCAidHlwZSI6ICJQb2ludCJ9LCAiaWQiOiAiOCIsICJwcm9wZXJ0aWVzIjogeyJhbW91bnQiOiAiMC4wMyIsICJjb3VudHkiOiAiQk9VTERFUiIsICJkYXRhX3NvdXJjZSI6ICJOb3J0aGVybiBDb2xvcmFkbyBXYXRlciBDb25zZXJ2YW5jeSBEaXN0cmljdCAoRGF0YSBQcm92aWRlcikiLCAiZGF0ZV90aW1lIjogIjIwMTktMDgtMjNUMjA6MDA6MDAuMDAwIiwgImRpdiI6ICIxIiwgImR3cl9hYmJyZXYiOiAiTElUVEgxQ08iLCAiaHR0cF9saW5rYWdlLnVybCI6ICJodHRwOi8vd3d3Lm5vcnRoZXJud2F0ZXIub3JnL1dhdGVyUHJvamVjdHMvRWFzdFNsb3BlV2F0ZXJEYXRhLmFzcHgiLCAibG9jYXRpb24ubGF0aXR1ZGUiOiA0MC4yNTYyNzYsICJsb2NhdGlvbi5sb25naXR1ZGUiOiAtMTA1LjIwOTQxNiwgImxvY2F0aW9uLm5lZWRzX3JlY29kaW5nIjogZmFsc2UsICJzdGFnZSI6ICIwLjAyIiwgInN0YXRpb25fbmFtZSI6ICJMSVRUTEUgVEhPTVBTT04gIzEgRElUQ0giLCAic3RhdGlvbl9zdGF0dXMiOiAiQWN0aXZlIiwgInN0YXRpb25fdHlwZSI6ICJEaXZlcnNpb24iLCAidXNnc19zdGF0aW9uX2lkIjogIkVTMTkwMSIsICJ2YXJpYWJsZSI6ICJESVNDSFJHIiwgIndkIjogIjQifSwgInR5cGUiOiAiRmVhdHVyZSJ9LCB7ImJib3giOiBbLTEwNS4xNzg1NjcsIDQwLjE3NzA4MDAwMDAwMDAwNCwgLTEwNS4xNzg1NjcsIDQwLjE3NzA4MDAwMDAwMDAwNF0sICJnZW9tZXRyeSI6IHsiY29vcmRpbmF0ZXMiOiBbLTEwNS4xNzg1NjcsIDQwLjE3NzA4MDAwMDAwMDAwNF0sICJ0eXBlIjogIlBvaW50In0sICJpZCI6ICI5IiwgInByb3BlcnRpZXMiOiB7ImFtb3VudCI6ICIxLjcwIiwgImNvdW50eSI6ICJCT1VMREVSIiwgImRhdGFfc291cmNlIjogIkNvb3BlcmF0aXZlIFNEUiBQcm9ncmFtIG9mIENEV1IgXHUwMDI2IE5DV0NEIiwgImRhdGVfdGltZSI6ICIyMDE5LTA4LTIzVDE4OjAwOjAwLjAwMCIsICJkaXYiOiAiMSIsICJkd3JfYWJicmV2IjogIlBDS1BFTENPIiwgImh0dHBfbGlua2FnZS51cmwiOiAiaHR0cHM6Ly9kd3Iuc3RhdGUuY28udXMvU3VyZmFjZVdhdGVyL2RhdGEvZGV0YWlsX2dyYXBoLmFzcHg/SUQ9UENLUEVMQ09cdTAwMjZNVFlQRT1ESVNDSFJHIiwgImxvY2F0aW9uLmxhdGl0dWRlIjogNDAuMTc3MDgsICJsb2NhdGlvbi5sb25naXR1ZGUiOiAtMTA1LjE3ODU2NywgImxvY2F0aW9uLm5lZWRzX3JlY29kaW5nIjogZmFsc2UsICJzdGFnZSI6ICIwLjE5IiwgInN0YXRpb25fbmFtZSI6ICJQRUNLIFBFTExBIENMT1ZFUiBESVRDSCIsICJzdGF0aW9uX3N0YXR1cyI6ICJBY3RpdmUiLCAic3RhdGlvbl90eXBlIjogIkRpdmVyc2lvbiIsICJ1c2dzX3N0YXRpb25faWQiOiBudWxsLCAidmFyaWFibGUiOiAiRElTQ0hSRyIsICJ3ZCI6ICI1In0sICJ0eXBlIjogIkZlYXR1cmUifSwgeyJiYm94IjogWy0xMDUuMjE4Nzc3LCA0MC4yMDQxOTMsIC0xMDUuMjE4Nzc3LCA0MC4yMDQxOTNdLCAiZ2VvbWV0cnkiOiB7ImNvb3JkaW5hdGVzIjogWy0xMDUuMjE4Nzc3LCA0MC4yMDQxOTNdLCAidHlwZSI6ICJQb2ludCJ9LCAiaWQiOiAiMTAiLCAicHJvcGVydGllcyI6IHsiYW1vdW50IjogIjEzLjczIiwgImNvdW50eSI6ICJCT1VMREVSIiwgImRhdGFfc291cmNlIjogIkNvb3BlcmF0aXZlIFByb2dyYW0gb2YgQ0RXUiwgTkNXQ0QgXHUwMDI2IFNWTEhXQ0QiLCAiZGF0ZV90aW1lIjogIjIwMTktMDgtMjNUMjA6MDA6MDAuMDAwIiwgImRpdiI6ICIxIiwgImR3cl9hYmJyZXYiOiAiTE9OU1VQQ08iLCAiaHR0cF9saW5rYWdlLnVybCI6ICJodHRwczovL2R3ci5zdGF0ZS5jby51cy9TdXJmYWNlV2F0ZXIvZGF0YS9kZXRhaWxfZ3JhcGguYXNweD9JRD1MT05TVVBDT1x1MDAyNk1UWVBFPURJU0NIUkciLCAibG9jYXRpb24ubGF0aXR1ZGUiOiA0MC4yMDQxOTMsICJsb2NhdGlvbi5sb25naXR1ZGUiOiAtMTA1LjIxODc3NywgImxvY2F0aW9uLm5lZWRzX3JlY29kaW5nIjogZmFsc2UsICJzdGFnZSI6ICIxLjA5IiwgInN0YXRpb25fbmFtZSI6ICJMT05HTU9OVCBTVVBQTFkgRElUQ0giLCAic3RhdGlvbl9zdGF0dXMiOiAiQWN0aXZlIiwgInN0YXRpb25fdHlwZSI6ICJEaXZlcnNpb24iLCAidXNnc19zdGF0aW9uX2lkIjogbnVsbCwgInZhcmlhYmxlIjogIkRJU0NIUkciLCAid2QiOiAiNSJ9LCAidHlwZSI6ICJGZWF0dXJlIn0sIHsiYmJveCI6IFstMTA1LjE1MTE0MywgNDAuMDUzNjYxLCAtMTA1LjE1MTE0MywgNDAuMDUzNjYxXSwgImdlb21ldHJ5IjogeyJjb29yZGluYXRlcyI6IFstMTA1LjE1MTE0MywgNDAuMDUzNjYxXSwgInR5cGUiOiAiUG9pbnQifSwgImlkIjogIjExIiwgInByb3BlcnRpZXMiOiB7ImFtb3VudCI6ICIyMS45NSIsICJjb3VudHkiOiAiQk9VTERFUiIsICJkYXRhX3NvdXJjZSI6ICJDb29wZXJhdGl2ZSBQcm9ncmFtIG9mIENEV1IsIE5DV0NEIFx1MDAyNiBMU1BXQ0QiLCAiZGF0ZV90aW1lIjogIjIwMTktMDgtMjNUMjA6MDA6MDAuMDAwIiwgImRpdiI6ICIxIiwgImR3cl9hYmJyZXYiOiAiTEVHRElUQ08iLCAiaHR0cF9saW5rYWdlLnVybCI6ICJodHRwczovL2R3ci5zdGF0ZS5jby51cy9TdXJmYWNlV2F0ZXIvZGF0YS9kZXRhaWxfZ3JhcGguYXNweD9JRD1MRUdESVRDT1x1MDAyNk1UWVBFPURJU0NIUkciLCAibG9jYXRpb24ubGF0aXR1ZGUiOiA0MC4wNTM2NjEsICJsb2NhdGlvbi5sb25naXR1ZGUiOiAtMTA1LjE1MTE0MywgImxvY2F0aW9uLm5lZWRzX3JlY29kaW5nIjogZmFsc2UsICJzdGFnZSI6ICIwLjc5IiwgInN0YXRpb25fbmFtZSI6ICJMRUdHRVRUIERJVENIIiwgInN0YXRpb25fc3RhdHVzIjogIkFjdGl2ZSIsICJzdGF0aW9uX3R5cGUiOiAiRGl2ZXJzaW9uIiwgInVzZ3Nfc3RhdGlvbl9pZCI6IG51bGwsICJ2YXJpYWJsZSI6ICJESVNDSFJHIiwgIndkIjogIjYifSwgInR5cGUiOiAiRmVhdHVyZSJ9LCB7ImJib3giOiBbLTEwNS4yNjM0OSwgNDAuMjIwNzAyLCAtMTA1LjI2MzQ5LCA0MC4yMjA3MDJdLCAiZ2VvbWV0cnkiOiB7ImNvb3JkaW5hdGVzIjogWy0xMDUuMjYzNDksIDQwLjIyMDcwMl0sICJ0eXBlIjogIlBvaW50In0sICJpZCI6ICIxMiIsICJwcm9wZXJ0aWVzIjogeyJhbW91bnQiOiAiMTEyLjAwIiwgImNvdW50eSI6ICJCT1VMREVSIiwgImRhdGFfc291cmNlIjogIkNvLiBEaXZpc2lvbiBvZiBXYXRlciBSZXNvdXJjZXMiLCAiZGF0ZV90aW1lIjogIjIwMTktMDgtMjNUMjA6MTU6MDAuMDAwIiwgImRpdiI6ICIxIiwgImR3cl9hYmJyZXYiOiAiU1ZDTFlPQ08iLCAiaHR0cF9saW5rYWdlLnVybCI6ICJodHRwczovL2R3ci5zdGF0ZS5jby51cy9TdXJmYWNlV2F0ZXIvZGF0YS9kZXRhaWxfZ3JhcGguYXNweD9JRD1TVkNMWU9DT1x1MDAyNk1UWVBFPURJU0NIUkciLCAibG9jYXRpb24ubGF0aXR1ZGUiOiA0MC4yMjA3MDIsICJsb2NhdGlvbi5sb25naXR1ZGUiOiAtMTA1LjI2MzQ5LCAibG9jYXRpb24ubmVlZHNfcmVjb2RpbmciOiBmYWxzZSwgInN0YWdlIjogIjMuMjkiLCAic3RhdGlvbl9uYW1lIjogIlNBSU5UIFZSQUlOIENSRUVLIEFUIExZT05TLCBDTyIsICJzdGF0aW9uX3N0YXR1cyI6ICJBY3RpdmUiLCAic3RhdGlvbl90eXBlIjogIlN0cmVhbSIsICJ1c2dzX3N0YXRpb25faWQiOiAiMDY3MjQwMDAiLCAidmFyaWFibGUiOiAiRElTQ0hSRyIsICJ3ZCI6ICI1In0sICJ0eXBlIjogIkZlYXR1cmUifSwgeyJiYm94IjogWy0xMDUuMjA5MjgyLCA0MC4xODg1NzksIC0xMDUuMjA5MjgyLCA0MC4xODg1NzldLCAiZ2VvbWV0cnkiOiB7ImNvb3JkaW5hdGVzIjogWy0xMDUuMjA5MjgyLCA0MC4xODg1NzldLCAidHlwZSI6ICJQb2ludCJ9LCAiaWQiOiAiMTMiLCAicHJvcGVydGllcyI6IHsiYW1vdW50IjogIjUuMjQiLCAiY291bnR5IjogIkJPVUxERVIiLCAiZGF0YV9zb3VyY2UiOiAiQ29vcGVyYXRpdmUgUHJvZ3JhbSBvZiBDRFdSLCBOQ1dDRCBcdTAwMjYgU1ZMSFdDRCIsICJkYXRlX3RpbWUiOiAiMjAxOS0wOC0yM1QxOTo0NTowMC4wMDAiLCAiZGl2IjogIjEiLCAiZHdyX2FiYnJldiI6ICJKQU1ESVRDTyIsICJodHRwX2xpbmthZ2UudXJsIjogImh0dHBzOi8vZHdyLnN0YXRlLmNvLnVzL1N1cmZhY2VXYXRlci9kYXRhL2RldGFpbF9ncmFwaC5hc3B4P0lEPUpBTURJVENPXHUwMDI2TVRZUEU9RElTQ0hSRyIsICJsb2NhdGlvbi5sYXRpdHVkZSI6IDQwLjE4ODU3OSwgImxvY2F0aW9uLmxvbmdpdHVkZSI6IC0xMDUuMjA5MjgyLCAibG9jYXRpb24ubmVlZHNfcmVjb2RpbmciOiBmYWxzZSwgInN0YWdlIjogIjAuNDMiLCAic3RhdGlvbl9uYW1lIjogIkpBTUVTIERJVENIIiwgInN0YXRpb25fc3RhdHVzIjogIkFjdGl2ZSIsICJzdGF0aW9uX3R5cGUiOiAiRGl2ZXJzaW9uIiwgInVzZ3Nfc3RhdGlvbl9pZCI6IG51bGwsICJ2YXJpYWJsZSI6ICJESVNDSFJHIiwgIndkIjogIjUifSwgInR5cGUiOiAiRmVhdHVyZSJ9LCB7ImJib3giOiBbLTEwNS4zMDg0MzIsIDM5LjkzMTgxMywgLTEwNS4zMDg0MzIsIDM5LjkzMTgxM10sICJnZW9tZXRyeSI6IHsiY29vcmRpbmF0ZXMiOiBbLTEwNS4zMDg0MzIsIDM5LjkzMTgxM10sICJ0eXBlIjogIlBvaW50In0sICJpZCI6ICIxNCIsICJwcm9wZXJ0aWVzIjogeyJhbW91bnQiOiAiOTMuNzAiLCAiY291bnR5IjogIkJPVUxERVIiLCAiZGF0YV9zb3VyY2UiOiAiQ28uIERpdmlzaW9uIG9mIFdhdGVyIFJlc291cmNlcyIsICJkYXRlX3RpbWUiOiAiMjAxOS0wOC0yM1QyMDozMDowMC4wMDAiLCAiZGl2IjogIjEiLCAiZHdyX2FiYnJldiI6ICJCT1NERUxDTyIsICJodHRwX2xpbmthZ2UudXJsIjogImh0dHBzOi8vZHdyLnN0YXRlLmNvLnVzL1N1cmZhY2VXYXRlci9kYXRhL2RldGFpbF9ncmFwaC5hc3B4P0lEPUJPU0RFTENPXHUwMDI2TVRZUEU9RElTQ0hSRyIsICJsb2NhdGlvbi5sYXRpdHVkZSI6IDM5LjkzMTgxMywgImxvY2F0aW9uLmxvbmdpdHVkZSI6IC0xMDUuMzA4NDMyLCAibG9jYXRpb24ubmVlZHNfcmVjb2RpbmciOiBmYWxzZSwgInN0YWdlIjogIjEuNTIiLCAic3RhdGlvbl9uYW1lIjogIlNPVVRIIEJPVUxERVIgQ1JFRUsgRElWRVJTSU9OIE5FQVIgRUxET1JBRE8gU1BSSU5HUyIsICJzdGF0aW9uX3N0YXR1cyI6ICJBY3RpdmUiLCAic3RhdGlvbl90eXBlIjogIkRpdmVyc2lvbiIsICJ1c2dzX3N0YXRpb25faWQiOiBudWxsLCAidmFyaWFibGUiOiAiRElTQ0hSRyIsICJ3ZCI6ICI2In0sICJ0eXBlIjogIkZlYXR1cmUifSwgeyJiYm94IjogWy0xMDUuMTg5MTkxLCA0MC4xODc1NzgsIC0xMDUuMTg5MTkxLCA0MC4xODc1NzhdLCAiZ2VvbWV0cnkiOiB7ImNvb3JkaW5hdGVzIjogWy0xMDUuMTg5MTkxLCA0MC4xODc1NzhdLCAidHlwZSI6ICJQb2ludCJ9LCAiaWQiOiAiMTUiLCAicHJvcGVydGllcyI6IHsiYW1vdW50IjogIjIuODMiLCAiY291bnR5IjogIkJPVUxERVIiLCAiZGF0YV9zb3VyY2UiOiAiQ29vcGVyYXRpdmUgUHJvZ3JhbSBvZiBDRFdSLCBOQ1dDRCBcdTAwMjYgU1ZMSFdDRCIsICJkYXRlX3RpbWUiOiAiMjAxOS0wOC0yM1QyMDowMDowMC4wMDAiLCAiZGl2IjogIjEiLCAiZHdyX2FiYnJldiI6ICJERU5UQVlDTyIsICJodHRwX2xpbmthZ2UudXJsIjogImh0dHBzOi8vZHdyLnN0YXRlLmNvLnVzL1N1cmZhY2VXYXRlci9kYXRhL2RldGFpbF9ncmFwaC5hc3B4P0lEPURFTlRBWUNPXHUwMDI2TVRZUEU9RElTQ0hSRyIsICJsb2NhdGlvbi5sYXRpdHVkZSI6IDQwLjE4NzU3OCwgImxvY2F0aW9uLmxvbmdpdHVkZSI6IC0xMDUuMTg5MTkxLCAibG9jYXRpb24ubmVlZHNfcmVjb2RpbmciOiBmYWxzZSwgInN0YWdlIjogIjAuNjYiLCAic3RhdGlvbl9uYW1lIjogIkRFTklPIFRBWUxPUiBESVRDSCIsICJzdGF0aW9uX3N0YXR1cyI6ICJBY3RpdmUiLCAic3RhdGlvbl90eXBlIjogIkRpdmVyc2lvbiIsICJ1c2dzX3N0YXRpb25faWQiOiBudWxsLCAidmFyaWFibGUiOiAiRElTQ0hSRyIsICJ3ZCI6ICI1In0sICJ0eXBlIjogIkZlYXR1cmUifSwgeyJiYm94IjogWy0xMDUuMTk4NTY3LCA0MC4yNjA4MjcsIC0xMDUuMTk4NTY3LCA0MC4yNjA4MjddLCAiZ2VvbWV0cnkiOiB7ImNvb3JkaW5hdGVzIjogWy0xMDUuMTk4NTY3LCA0MC4yNjA4MjddLCAidHlwZSI6ICJQb2ludCJ9LCAiaWQiOiAiMTYiLCAicHJvcGVydGllcyI6IHsiYW1vdW50IjogIjAuMDAiLCAiY291bnR5IjogIkJPVUxERVIiLCAiZGF0YV9zb3VyY2UiOiAiQ29vcGVyYXRpdmUgU0RSIFByb2dyYW0gb2YgQ0RXUiBcdTAwMjYgTkNXQ0QiLCAiZGF0ZV90aW1lIjogIjIwMTktMDgtMjNUMjA6MDA6MDAuMDAwIiwgImRpdiI6ICIxIiwgImR3cl9hYmJyZXYiOiAiQ1VMRElUQ08iLCAiaHR0cF9saW5rYWdlLnVybCI6ICJodHRwczovL2R3ci5zdGF0ZS5jby51cy9TdXJmYWNlV2F0ZXIvZGF0YS9kZXRhaWxfZ3JhcGguYXNweD9JRD1DVUxESVRDT1x1MDAyNk1UWVBFPURJU0NIUkciLCAibG9jYXRpb24ubGF0aXR1ZGUiOiA0MC4yNjA4MjcsICJsb2NhdGlvbi5sb25naXR1ZGUiOiAtMTA1LjE5ODU2NywgImxvY2F0aW9uLm5lZWRzX3JlY29kaW5nIjogZmFsc2UsICJzdGFnZSI6IG51bGwsICJzdGF0aW9uX25hbWUiOiAiQ1VMVkVSIERJVENIIiwgInN0YXRpb25fc3RhdHVzIjogIkFjdGl2ZSIsICJzdGF0aW9uX3R5cGUiOiAiRGl2ZXJzaW9uIiwgInVzZ3Nfc3RhdGlvbl9pZCI6IG51bGwsICJ2YXJpYWJsZSI6ICJESVNDSFJHIiwgIndkIjogIjQifSwgInR5cGUiOiAiRmVhdHVyZSJ9LCB7ImJib3giOiBbLTEwNS4wODg2OTUsIDQwLjE1MzM2MywgLTEwNS4wODg2OTUsIDQwLjE1MzM2M10sICJnZW9tZXRyeSI6IHsiY29vcmRpbmF0ZXMiOiBbLTEwNS4wODg2OTUsIDQwLjE1MzM2M10sICJ0eXBlIjogIlBvaW50In0sICJpZCI6ICIxNyIsICJwcm9wZXJ0aWVzIjogeyJhbW91bnQiOiAiOC4xMSIsICJjb3VudHkiOiAiQk9VTERFUiIsICJkYXRhX3NvdXJjZSI6ICJDb29wZXJhdGl2ZSBQcm9ncmFtIG9mIENEV1IsIE5DV0NEIFx1MDAyNiBTVkxIV0NEIiwgImRhdGVfdGltZSI6ICIyMDE5LTA4LTIzVDIwOjAwOjAwLjAwMCIsICJkaXYiOiAiMSIsICJkd3JfYWJicmV2IjogIkJPTkRJVENPIiwgImh0dHBfbGlua2FnZS51cmwiOiAiaHR0cHM6Ly9kd3Iuc3RhdGUuY28udXMvU3VyZmFjZVdhdGVyL2RhdGEvZGV0YWlsX2dyYXBoLmFzcHg/SUQ9Qk9ORElUQ09cdTAwMjZNVFlQRT1ESVNDSFJHIiwgImxvY2F0aW9uLmxhdGl0dWRlIjogNDAuMTUzMzYzLCAibG9jYXRpb24ubG9uZ2l0dWRlIjogLTEwNS4wODg2OTUsICJsb2NhdGlvbi5uZWVkc19yZWNvZGluZyI6IGZhbHNlLCAic3RhZ2UiOiAiMC42NSIsICJzdGF0aW9uX25hbWUiOiAiQk9OVVMgRElUQ0giLCAic3RhdGlvbl9zdGF0dXMiOiAiQWN0aXZlIiwgInN0YXRpb25fdHlwZSI6ICJEaXZlcnNpb24iLCAidXNnc19zdGF0aW9uX2lkIjogbnVsbCwgInZhcmlhYmxlIjogIkRJU0NIUkciLCAid2QiOiAiNSJ9LCAidHlwZSI6ICJGZWF0dXJlIn0sIHsiYmJveCI6IFstMTA1LjE2OTM3NCwgNDAuMTczOTUsIC0xMDUuMTY5Mzc0LCA0MC4xNzM5NV0sICJnZW9tZXRyeSI6IHsiY29vcmRpbmF0ZXMiOiBbLTEwNS4xNjkzNzQsIDQwLjE3Mzk1XSwgInR5cGUiOiAiUG9pbnQifSwgImlkIjogIjE4IiwgInByb3BlcnRpZXMiOiB7ImFtb3VudCI6ICI1LjIzIiwgImNvdW50eSI6ICJCT1VMREVSIiwgImRhdGFfc291cmNlIjogIkNvb3BlcmF0aXZlIFByb2dyYW0gb2YgQ0RXUiwgTkNXQ0QgXHUwMDI2IFNWTEhXQ0QiLCAiZGF0ZV90aW1lIjogIjIwMTktMDgtMjNUMTk6MzA6MDAuMDAwIiwgImRpdiI6ICIxIiwgImR3cl9hYmJyZXYiOiAiTklXRElUQ08iLCAiaHR0cF9saW5rYWdlLnVybCI6ICJodHRwczovL2R3ci5zdGF0ZS5jby51cy9TdXJmYWNlV2F0ZXIvZGF0YS9kZXRhaWxfZ3JhcGguYXNweD9JRD1OSVdESVRDT1x1MDAyNk1UWVBFPURJU0NIUkciLCAibG9jYXRpb24ubGF0aXR1ZGUiOiA0MC4xNzM5NSwgImxvY2F0aW9uLmxvbmdpdHVkZSI6IC0xMDUuMTY5Mzc0LCAibG9jYXRpb24ubmVlZHNfcmVjb2RpbmciOiBmYWxzZSwgInN0YWdlIjogIjAuNzYiLCAic3RhdGlvbl9uYW1lIjogIk5JV09UIERJVENIIiwgInN0YXRpb25fc3RhdHVzIjogIkFjdGl2ZSIsICJzdGF0aW9uX3R5cGUiOiAiRGl2ZXJzaW9uIiwgInVzZ3Nfc3RhdGlvbl9pZCI6IG51bGwsICJ2YXJpYWJsZSI6ICJESVNDSFJHIiwgIndkIjogIjUifSwgInR5cGUiOiAiRmVhdHVyZSJ9LCB7ImJib3giOiBbLTEwNS4yMTc1MTksIDQwLjA4NjI3OCwgLTEwNS4yMTc1MTksIDQwLjA4NjI3OF0sICJnZW9tZXRyeSI6IHsiY29vcmRpbmF0ZXMiOiBbLTEwNS4yMTc1MTksIDQwLjA4NjI3OF0sICJ0eXBlIjogIlBvaW50In0sICJpZCI6ICIxOSIsICJwcm9wZXJ0aWVzIjogeyJhbW91bnQiOiAiMjAuMDAiLCAiY291bnR5IjogIkJPVUxERVIiLCAiZGF0YV9zb3VyY2UiOiAiTm9ydGhlcm4gQ29sb3JhZG8gV2F0ZXIgQ29uc2VydmFuY3kgRGlzdHJpY3QgKERhdGEgUHJvdmlkZXIpIiwgImRhdGVfdGltZSI6ICIyMDE5LTA4LTIzVDIwOjAwOjAwLjAwMCIsICJkaXYiOiAiMSIsICJkd3JfYWJicmV2IjogIkJGQ0lORkNPIiwgImh0dHBfbGlua2FnZS51cmwiOiAiaHR0cDovL3d3dy5ub3J0aGVybndhdGVyLm9yZy9XYXRlclByb2plY3RzL0Vhc3RTbG9wZVdhdGVyRGF0YS5hc3B4IiwgImxvY2F0aW9uLmxhdGl0dWRlIjogNDAuMDg2Mjc4LCAibG9jYXRpb24ubG9uZ2l0dWRlIjogLTEwNS4yMTc1MTksICJsb2NhdGlvbi5uZWVkc19yZWNvZGluZyI6IGZhbHNlLCAic3RhZ2UiOiAiMS40MCIsICJzdGF0aW9uX25hbWUiOiAiQk9VTERFUiBSRVNFUlZPSVIgSU5MRVQiLCAic3RhdGlvbl9zdGF0dXMiOiAiQWN0aXZlIiwgInN0YXRpb25fdHlwZSI6ICJTdHJlYW0iLCAidXNnc19zdGF0aW9uX2lkIjogIkVTMTkxNiIsICJ2YXJpYWJsZSI6ICJESVNDSFJHIiwgIndkIjogIjYifSwgInR5cGUiOiAiRmVhdHVyZSJ9LCB7ImJib3giOiBbLTEwNS4yMTAzODgwMDAwMDAwMSwgNDAuMTkzMDE5LCAtMTA1LjIxMDM4ODAwMDAwMDAxLCA0MC4xOTMwMTldLCAiZ2VvbWV0cnkiOiB7ImNvb3JkaW5hdGVzIjogWy0xMDUuMjEwMzg4MDAwMDAwMDEsIDQwLjE5MzAxOV0sICJ0eXBlIjogIlBvaW50In0sICJpZCI6ICIyMCIsICJwcm9wZXJ0aWVzIjogeyJhbW91bnQiOiAiNC44OCIsICJjb3VudHkiOiAiQk9VTERFUiIsICJkYXRhX3NvdXJjZSI6ICJDb29wZXJhdGl2ZSBQcm9ncmFtIG9mIENEV1IsIE5DV0NEIFx1MDAyNiBTVkxIV0NEIiwgImRhdGVfdGltZSI6ICIyMDE5LTA4LTIzVDIwOjAwOjAwLjAwMCIsICJkaXYiOiAiMSIsICJkd3JfYWJicmV2IjogIlRSVURJVENPIiwgImh0dHBfbGlua2FnZS51cmwiOiAiaHR0cHM6Ly9kd3Iuc3RhdGUuY28udXMvU3VyZmFjZVdhdGVyL2RhdGEvZGV0YWlsX2dyYXBoLmFzcHg/SUQ9VFJVRElUQ09cdTAwMjZNVFlQRT1ESVNDSFJHIiwgImxvY2F0aW9uLmxhdGl0dWRlIjogNDAuMTkzMDE5LCAibG9jYXRpb24ubG9uZ2l0dWRlIjogLTEwNS4yMTAzODgsICJsb2NhdGlvbi5uZWVkc19yZWNvZGluZyI6IGZhbHNlLCAic3RhZ2UiOiAiMS4xNCIsICJzdGF0aW9uX25hbWUiOiAiVFJVRSBBTkQgV0VCU1RFUiBESVRDSCIsICJzdGF0aW9uX3N0YXR1cyI6ICJBY3RpdmUiLCAic3RhdGlvbl90eXBlIjogIkRpdmVyc2lvbiIsICJ1c2dzX3N0YXRpb25faWQiOiBudWxsLCAidmFyaWFibGUiOiAiRElTQ0hSRyIsICJ3ZCI6ICI1In0sICJ0eXBlIjogIkZlYXR1cmUifSwgeyJiYm94IjogWy0xMDUuNTE0NDQyLCA0MC4wOTA4MjAwMDAwMDAwMSwgLTEwNS41MTQ0NDIsIDQwLjA5MDgyMDAwMDAwMDAxXSwgImdlb21ldHJ5IjogeyJjb29yZGluYXRlcyI6IFstMTA1LjUxNDQ0MiwgNDAuMDkwODIwMDAwMDAwMDFdLCAidHlwZSI6ICJQb2ludCJ9LCAiaWQiOiAiMjEiLCAicHJvcGVydGllcyI6IHsiYW1vdW50IjogIjI2LjcwIiwgImNvdW50eSI6ICJCT1VMREVSIiwgImRhdGFfc291cmNlIjogIkNvLiBEaXZpc2lvbiBvZiBXYXRlciBSZXNvdXJjZXMiLCAiZGF0ZV90aW1lIjogIjIwMTktMDgtMjNUMjA6MzA6MDAuMDAwIiwgImRpdiI6ICIxIiwgImR3cl9hYmJyZXYiOiAiU1NWV0FSQ08iLCAiaHR0cF9saW5rYWdlLnVybCI6ICJodHRwczovL2R3ci5zdGF0ZS5jby51cy9TdXJmYWNlV2F0ZXIvZGF0YS9kZXRhaWxfZ3JhcGguYXNweD9JRD1TU1ZXQVJDT1x1MDAyNk1UWVBFPURJU0NIUkciLCAibG9jYXRpb24ubGF0aXR1ZGUiOiA0MC4wOTA4MiwgImxvY2F0aW9uLmxvbmdpdHVkZSI6IC0xMDUuNTE0NDQyLCAibG9jYXRpb24ubmVlZHNfcmVjb2RpbmciOiBmYWxzZSwgInN0YWdlIjogIjIuMDMiLCAic3RhdGlvbl9uYW1lIjogIlNPVVRIIFNBSU5UIFZSQUlOIE5FQVIgV0FSRCIsICJzdGF0aW9uX3N0YXR1cyI6ICJBY3RpdmUiLCAic3RhdGlvbl90eXBlIjogIlN0cmVhbSIsICJ1c2dzX3N0YXRpb25faWQiOiAiMDY3MjI1MDAiLCAidmFyaWFibGUiOiAiRElTQ0hSRyIsICJ3ZCI6ICI1In0sICJ0eXBlIjogIkZlYXR1cmUifSwgeyJiYm94IjogWy0xMDUuMTk2Nzc1LCA0MC4xODE4OCwgLTEwNS4xOTY3NzUsIDQwLjE4MTg4XSwgImdlb21ldHJ5IjogeyJjb29yZGluYXRlcyI6IFstMTA1LjE5Njc3NSwgNDAuMTgxODhdLCAidHlwZSI6ICJQb2ludCJ9LCAiaWQiOiAiMjIiLCAicHJvcGVydGllcyI6IHsiYW1vdW50IjogIjUuMTkiLCAiY291bnR5IjogIkJPVUxERVIiLCAiZGF0YV9zb3VyY2UiOiAiQ29vcGVyYXRpdmUgUHJvZ3JhbSBvZiBDRFdSLCBOQ1dDRCBcdTAwMjYgU1ZMSFdDRCIsICJkYXRlX3RpbWUiOiAiMjAxOS0wOC0yM1QxOTo0NTowMC4wMDAiLCAiZGl2IjogIjEiLCAiZHdyX2FiYnJldiI6ICJEQVZET1dDTyIsICJodHRwX2xpbmthZ2UudXJsIjogImh0dHBzOi8vZHdyLnN0YXRlLmNvLnVzL1N1cmZhY2VXYXRlci9kYXRhL2RldGFpbF9ncmFwaC5hc3B4P0lEPURBVkRPV0NPXHUwMDI2TVRZUEU9RElTQ0hSRyIsICJsb2NhdGlvbi5sYXRpdHVkZSI6IDQwLjE4MTg4LCAibG9jYXRpb24ubG9uZ2l0dWRlIjogLTEwNS4xOTY3NzUsICJsb2NhdGlvbi5uZWVkc19yZWNvZGluZyI6IGZhbHNlLCAic3RhZ2UiOiAiMC40OSIsICJzdGF0aW9uX25hbWUiOiAiREFWSVMgQU5EIERPV05JTkcgRElUQ0giLCAic3RhdGlvbl9zdGF0dXMiOiAiQWN0aXZlIiwgInN0YXRpb25fdHlwZSI6ICJEaXZlcnNpb24iLCAidXNnc19zdGF0aW9uX2lkIjogbnVsbCwgInZhcmlhYmxlIjogIkRJU0NIUkciLCAid2QiOiAiNSJ9LCAidHlwZSI6ICJGZWF0dXJlIn0sIHsiYmJveCI6IFstMTA1LjMwNDk5LCAzOS45MzE1OTcsIC0xMDUuMzA0OTksIDM5LjkzMTU5N10sICJnZW9tZXRyeSI6IHsiY29vcmRpbmF0ZXMiOiBbLTEwNS4zMDQ5OSwgMzkuOTMxNTk3XSwgInR5cGUiOiAiUG9pbnQifSwgImlkIjogIjIzIiwgInByb3BlcnRpZXMiOiB7ImFtb3VudCI6ICIyNS41MCIsICJjb3VudHkiOiAiQk9VTERFUiIsICJkYXRhX3NvdXJjZSI6ICJDby4gRGl2aXNpb24gb2YgV2F0ZXIgUmVzb3VyY2VzIiwgImRhdGVfdGltZSI6ICIyMDE5LTA4LTIzVDIwOjE1OjAwLjAwMCIsICJkaXYiOiAiMSIsICJkd3JfYWJicmV2IjogIkJPQ0VMU0NPIiwgImh0dHBfbGlua2FnZS51cmwiOiAiaHR0cHM6Ly9kd3Iuc3RhdGUuY28udXMvU3VyZmFjZVdhdGVyL2RhdGEvZGV0YWlsX2dyYXBoLmFzcHg/SUQ9Qk9DRUxTQ09cdTAwMjZNVFlQRT1ESVNDSFJHIiwgImxvY2F0aW9uLmxhdGl0dWRlIjogMzkuOTMxNTk3LCAibG9jYXRpb24ubG9uZ2l0dWRlIjogLTEwNS4zMDQ5OSwgImxvY2F0aW9uLm5lZWRzX3JlY29kaW5nIjogZmFsc2UsICJzdGFnZSI6ICIyLjI2IiwgInN0YXRpb25fbmFtZSI6ICJTT1VUSCBCT1VMREVSIENSRUVLIE5FQVIgRUxET1JBRE8gU1BSSU5HUywgQ08uIiwgInN0YXRpb25fc3RhdHVzIjogIkFjdGl2ZSIsICJzdGF0aW9uX3R5cGUiOiAiU3RyZWFtIiwgInVzZ3Nfc3RhdGlvbl9pZCI6IG51bGwsICJ2YXJpYWJsZSI6ICJESVNDSFJHIiwgIndkIjogIjYifSwgInR5cGUiOiAiRmVhdHVyZSJ9LCB7ImJib3giOiBbLTEwNS4yMjA0OTcsIDQwLjA3ODU2LCAtMTA1LjIyMDQ5NywgNDAuMDc4NTZdLCAiZ2VvbWV0cnkiOiB7ImNvb3JkaW5hdGVzIjogWy0xMDUuMjIwNDk3LCA0MC4wNzg1Nl0sICJ0eXBlIjogIlBvaW50In0sICJpZCI6ICIyNCIsICJwcm9wZXJ0aWVzIjogeyJhbW91bnQiOiAiODk0Mi4wMCIsICJjb3VudHkiOiAiQk9VTERFUiIsICJkYXRhX3NvdXJjZSI6ICJOb3J0aGVybiBDb2xvcmFkbyBXYXRlciBDb25zZXJ2YW5jeSBEaXN0cmljdCAoRGF0YSBQcm92aWRlcikiLCAiZGF0ZV90aW1lIjogIjIwMTktMDgtMjNUMjA6NDU6MDAuMDAwIiwgImRpdiI6ICIxIiwgImR3cl9hYmJyZXYiOiAiQk9VUkVTQ08iLCAiaHR0cF9saW5rYWdlLnVybCI6ICJodHRwOi8vd3d3Lm5vcnRoZXJud2F0ZXIub3JnL1dhdGVyUHJvamVjdHMvRWFzdFNsb3BlV2F0ZXJEYXRhLmFzcHgiLCAibG9jYXRpb24ubGF0aXR1ZGUiOiA0MC4wNzg1NiwgImxvY2F0aW9uLmxvbmdpdHVkZSI6IC0xMDUuMjIwNDk3LCAibG9jYXRpb24ubmVlZHNfcmVjb2RpbmciOiBmYWxzZSwgInN0YWdlIjogbnVsbCwgInN0YXRpb25fbmFtZSI6ICJCT1VMREVSIFJFU0VSVk9JUiIsICJzdGF0aW9uX3N0YXR1cyI6ICJBY3RpdmUiLCAic3RhdGlvbl90eXBlIjogIlJlc2Vydm9pciIsICJ1c2dzX3N0YXRpb25faWQiOiAiRVIxOTE0IiwgInZhcmlhYmxlIjogIlNUT1JBR0UiLCAid2QiOiAiNiJ9LCAidHlwZSI6ICJGZWF0dXJlIn0sIHsiYmJveCI6IFstMTA1LjI1MTgyNiwgNDAuMjEyNTA1LCAtMTA1LjI1MTgyNiwgNDAuMjEyNTA1XSwgImdlb21ldHJ5IjogeyJjb29yZGluYXRlcyI6IFstMTA1LjI1MTgyNiwgNDAuMjEyNTA1XSwgInR5cGUiOiAiUG9pbnQifSwgImlkIjogIjI1IiwgInByb3BlcnRpZXMiOiB7ImFtb3VudCI6ICIyMC4yMCIsICJjb3VudHkiOiAiQk9VTERFUiIsICJkYXRhX3NvdXJjZSI6ICJDb29wZXJhdGl2ZSBQcm9ncmFtIG9mIENEV1IsIE5DV0NEIFx1MDAyNiBTVkxIV0NEIiwgImRhdGVfdGltZSI6ICIyMDE5LTA4LTIzVDIwOjAwOjAwLjAwMCIsICJkaXYiOiAiMSIsICJkd3JfYWJicmV2IjogIlBBTERJVENPIiwgImh0dHBfbGlua2FnZS51cmwiOiAiaHR0cHM6Ly9kd3Iuc3RhdGUuY28udXMvU3VyZmFjZVdhdGVyL2RhdGEvZGV0YWlsX2dyYXBoLmFzcHg/SUQ9UEFMRElUQ09cdTAwMjZNVFlQRT1ESVNDSFJHIiwgImxvY2F0aW9uLmxhdGl0dWRlIjogNDAuMjEyNTA1LCAibG9jYXRpb24ubG9uZ2l0dWRlIjogLTEwNS4yNTE4MjYsICJsb2NhdGlvbi5uZWVkc19yZWNvZGluZyI6IGZhbHNlLCAic3RhZ2UiOiAiMC43NSIsICJzdGF0aW9uX25hbWUiOiAiUEFMTUVSVE9OIERJVENIIiwgInN0YXRpb25fc3RhdHVzIjogIkFjdGl2ZSIsICJzdGF0aW9uX3R5cGUiOiAiRGl2ZXJzaW9uIiwgInVzZ3Nfc3RhdGlvbl9pZCI6IG51bGwsICJ2YXJpYWJsZSI6ICJESVNDSFJHIiwgIndkIjogIjUifSwgInR5cGUiOiAiRmVhdHVyZSJ9LCB7ImJib3giOiBbLTEwNS41MTcxMTEsIDQwLjEyOTgwNiwgLTEwNS41MTcxMTEsIDQwLjEyOTgwNl0sICJnZW9tZXRyeSI6IHsiY29vcmRpbmF0ZXMiOiBbLTEwNS41MTcxMTEsIDQwLjEyOTgwNl0sICJ0eXBlIjogIlBvaW50In0sICJpZCI6ICIyNiIsICJwcm9wZXJ0aWVzIjogeyJhbW91bnQiOiAiMjUuMDAiLCAiY291bnR5IjogIkJPVUxERVIiLCAiZGF0YV9zb3VyY2UiOiAiQ28uIERpdmlzaW9uIG9mIFdhdGVyIFJlc291cmNlcyIsICJkYXRlX3RpbWUiOiAiMjAxOS0wOC0yM1QyMDowMDowMC4wMDAiLCAiZGl2IjogIjEiLCAiZHdyX2FiYnJldiI6ICJNSURTVEVDTyIsICJodHRwX2xpbmthZ2UudXJsIjogImh0dHBzOi8vZHdyLnN0YXRlLmNvLnVzL1N1cmZhY2VXYXRlci9kYXRhL2RldGFpbF9ncmFwaC5hc3B4P0lEPU1JRFNURUNPXHUwMDI2TVRZUEU9RElTQ0hSRyIsICJsb2NhdGlvbi5sYXRpdHVkZSI6IDQwLjEyOTgwNiwgImxvY2F0aW9uLmxvbmdpdHVkZSI6IC0xMDUuNTE3MTExLCAibG9jYXRpb24ubmVlZHNfcmVjb2RpbmciOiBmYWxzZSwgInN0YWdlIjogIjIuNzciLCAic3RhdGlvbl9uYW1lIjogIk1JRERMRSBTQUlOVCBWUkFJTiBBVCBQRUFDRUZVTCBWQUxMRVkiLCAic3RhdGlvbl9zdGF0dXMiOiAiQWN0aXZlIiwgInN0YXRpb25fdHlwZSI6ICJTdHJlYW0iLCAidXNnc19zdGF0aW9uX2lkIjogbnVsbCwgInZhcmlhYmxlIjogIkRJU0NIUkciLCAid2QiOiAiNSJ9LCAidHlwZSI6ICJGZWF0dXJlIn0sIHsiYmJveCI6IFstMTA1LjM1NzMwOCwgMzkuOTQ3NzA0LCAtMTA1LjM1NzMwOCwgMzkuOTQ3NzA0XSwgImdlb21ldHJ5IjogeyJjb29yZGluYXRlcyI6IFstMTA1LjM1NzMwOCwgMzkuOTQ3NzA0XSwgInR5cGUiOiAiUG9pbnQifSwgImlkIjogIjI3IiwgInByb3BlcnRpZXMiOiB7ImFtb3VudCI6ICI0MTQ2MS4wMCIsICJjb3VudHkiOiAiQk9VTERFUiIsICJkYXRhX3NvdXJjZSI6ICJDby4gRGl2aXNpb24gb2YgV2F0ZXIgUmVzb3VyY2VzIiwgImRhdGVfdGltZSI6ICIyMDE5LTA4LTIzVDIwOjMwOjAwLjAwMCIsICJkaXYiOiAiMSIsICJkd3JfYWJicmV2IjogIkdST1NSRUNPIiwgImh0dHBfbGlua2FnZS51cmwiOiAiaHR0cHM6Ly9kd3Iuc3RhdGUuY28udXMvU3VyZmFjZVdhdGVyL2RhdGEvZGV0YWlsX2dyYXBoLmFzcHg/SUQ9R1JPU1JFQ09cdTAwMjZNVFlQRT1TVE9SQUdFIiwgImxvY2F0aW9uLmxhdGl0dWRlIjogMzkuOTQ3NzA0LCAibG9jYXRpb24ubG9uZ2l0dWRlIjogLTEwNS4zNTczMDgsICJsb2NhdGlvbi5uZWVkc19yZWNvZGluZyI6IGZhbHNlLCAic3RhZ2UiOiAiNzI4MS4wNiIsICJzdGF0aW9uX25hbWUiOiAiR1JPU1MgUkVTRVJWT0lSICIsICJzdGF0aW9uX3N0YXR1cyI6ICJBY3RpdmUiLCAic3RhdGlvbl90eXBlIjogIlJlc2Vydm9pciIsICJ1c2dzX3N0YXRpb25faWQiOiBudWxsLCAidmFyaWFibGUiOiAiU1RPUkFHRSIsICJ3ZCI6ICI2In0sICJ0eXBlIjogIkZlYXR1cmUifSwgeyJiYm94IjogWy0xMDUuMDc1Njk1MDAwMDAwMDEsIDQwLjE1MzM0MSwgLTEwNS4wNzU2OTUwMDAwMDAwMSwgNDAuMTUzMzQxXSwgImdlb21ldHJ5IjogeyJjb29yZGluYXRlcyI6IFstMTA1LjA3NTY5NTAwMDAwMDAxLCA0MC4xNTMzNDFdLCAidHlwZSI6ICJQb2ludCJ9LCAiaWQiOiAiMjgiLCAicHJvcGVydGllcyI6IHsiYW1vdW50IjogIjU3LjUwIiwgImNvdW50eSI6ICJCT1VMREVSIiwgImRhdGFfc291cmNlIjogIkNvLiBEaXZpc2lvbiBvZiBXYXRlciBSZXNvdXJjZXMiLCAiZGF0ZV90aW1lIjogIjIwMTktMDgtMjNUMjA6MzA6MDAuMDAwIiwgImRpdiI6ICIxIiwgImR3cl9hYmJyZXYiOiAiU1ZDTE9QQ08iLCAiaHR0cF9saW5rYWdlLnVybCI6ICJodHRwczovL2R3ci5zdGF0ZS5jby51cy9TdXJmYWNlV2F0ZXIvZGF0YS9kZXRhaWxfZ3JhcGguYXNweD9JRD1TVkNMT1BDT1x1MDAyNk1UWVBFPURJU0NIUkciLCAibG9jYXRpb24ubGF0aXR1ZGUiOiA0MC4xNTMzNDEsICJsb2NhdGlvbi5sb25naXR1ZGUiOiAtMTA1LjA3NTY5NSwgImxvY2F0aW9uLm5lZWRzX3JlY29kaW5nIjogZmFsc2UsICJzdGFnZSI6ICIzLjc4IiwgInN0YXRpb25fbmFtZSI6ICJTQUlOVCBWUkFJTiBDUkVFSyBCRUxPVyBLRU4gUFJBVFQgQkxWRCBBVCBMT05HTU9OVCwgQ08iLCAic3RhdGlvbl9zdGF0dXMiOiAiQWN0aXZlIiwgInN0YXRpb25fdHlwZSI6ICJTdHJlYW0iLCAidXNnc19zdGF0aW9uX2lkIjogbnVsbCwgInZhcmlhYmxlIjogIkRJU0NIUkciLCAid2QiOiAiNSJ9LCAidHlwZSI6ICJGZWF0dXJlIn0sIHsiYmJveCI6IFstMTA1LjA5Nzg3MiwgNDAuMDU5ODA5LCAtMTA1LjA5Nzg3MiwgNDAuMDU5ODA5XSwgImdlb21ldHJ5IjogeyJjb29yZGluYXRlcyI6IFstMTA1LjA5Nzg3MiwgNDAuMDU5ODA5XSwgInR5cGUiOiAiUG9pbnQifSwgImlkIjogIjI5IiwgInByb3BlcnRpZXMiOiB7ImFtb3VudCI6ICI4LjkxIiwgImNvdW50eSI6ICJCT1VMREVSIiwgImRhdGFfc291cmNlIjogIkNvLiBEaXZpc2lvbiBvZiBXYXRlciBSZXNvdXJjZXMiLCAiZGF0ZV90aW1lIjogIjIwMTktMDgtMjNUMjA6NDU6MDAuMDAwIiwgImRpdiI6ICIxIiwgImR3cl9hYmJyZXYiOiAiQk9DMTA5Q08iLCAiaHR0cF9saW5rYWdlLnVybCI6ICJodHRwczovL2R3ci5zdGF0ZS5jby51cy9TdXJmYWNlV2F0ZXIvZGF0YS9kZXRhaWxfZ3JhcGguYXNweD9JRD1CT0MxMDlDT1x1MDAyNk1UWVBFPURJU0NIUkciLCAibG9jYXRpb24ubGF0aXR1ZGUiOiA0MC4wNTk4MDksICJsb2NhdGlvbi5sb25naXR1ZGUiOiAtMTA1LjA5Nzg3MiwgImxvY2F0aW9uLm5lZWRzX3JlY29kaW5nIjogZmFsc2UsICJzdGFnZSI6ICIxLjg4IiwgInN0YXRpb25fbmFtZSI6ICJCT1VMREVSIENSRUVLIEFUIDEwOSBTVCBORUFSIEVSSUUsIENPIiwgInN0YXRpb25fc3RhdHVzIjogIkFjdGl2ZSIsICJzdGF0aW9uX3R5cGUiOiAiU3RyZWFtIiwgInVzZ3Nfc3RhdGlvbl9pZCI6IG51bGwsICJ2YXJpYWJsZSI6ICJESVNDSFJHIiwgIndkIjogIjYifSwgInR5cGUiOiAiRmVhdHVyZSJ9LCB7ImJib3giOiBbLTEwNS4xNzQ5NTcsIDQwLjI1ODM2NywgLTEwNS4xNzQ5NTcsIDQwLjI1ODM2N10sICJnZW9tZXRyeSI6IHsiY29vcmRpbmF0ZXMiOiBbLTEwNS4xNzQ5NTcsIDQwLjI1ODM2N10sICJ0eXBlIjogIlBvaW50In0sICJpZCI6ICIzMCIsICJwcm9wZXJ0aWVzIjogeyJhbW91bnQiOiAiMC4wMCIsICJjb3VudHkiOiAiQk9VTERFUiIsICJkYXRhX3NvdXJjZSI6ICJDby4gRGl2aXNpb24gb2YgV2F0ZXIgUmVzb3VyY2VzIiwgImRhdGVfdGltZSI6ICIyMDE5LTA4LTIzVDIwOjMwOjAwLjAwMCIsICJkaXYiOiAiMSIsICJkd3JfYWJicmV2IjogIkJPVUxBUkNPIiwgImh0dHBfbGlua2FnZS51cmwiOiAiaHR0cHM6Ly9kd3Iuc3RhdGUuY28udXMvU3VyZmFjZVdhdGVyL2RhdGEvZGV0YWlsX2dyYXBoLmFzcHg/SUQ9Qk9VTEFSQ09cdTAwMjZNVFlQRT1ESVNDSFJHIiwgImxvY2F0aW9uLmxhdGl0dWRlIjogNDAuMjU4MzY3LCAibG9jYXRpb24ubG9uZ2l0dWRlIjogLTEwNS4xNzQ5NTcsICJsb2NhdGlvbi5uZWVkc19yZWNvZGluZyI6IGZhbHNlLCAic3RhZ2UiOiAiLTAuMTEiLCAic3RhdGlvbl9uYW1lIjogIkJPVUxERVItTEFSSU1FUiBESVRDSCBORUFSIEJFUlRIT1VEIiwgInN0YXRpb25fc3RhdHVzIjogIkFjdGl2ZSIsICJzdGF0aW9uX3R5cGUiOiAiRGl2ZXJzaW9uIiwgInVzZ3Nfc3RhdGlvbl9pZCI6IG51bGwsICJ2YXJpYWJsZSI6ICJESVNDSFJHIiwgIndkIjogIjQifSwgInR5cGUiOiAiRmVhdHVyZSJ9LCB7ImJib3giOiBbLTEwNS4xMzA4MTksIDQwLjEzNDI3OCwgLTEwNS4xMzA4MTksIDQwLjEzNDI3OF0sICJnZW9tZXRyeSI6IHsiY29vcmRpbmF0ZXMiOiBbLTEwNS4xMzA4MTksIDQwLjEzNDI3OF0sICJ0eXBlIjogIlBvaW50In0sICJpZCI6ICIzMSIsICJwcm9wZXJ0aWVzIjogeyJhbW91bnQiOiAiMy43MSIsICJjb3VudHkiOiAiQk9VTERFUiIsICJkYXRhX3NvdXJjZSI6ICJVLlMuIEdlb2xvZ2ljYWwgU3VydmV5IChEYXRhIFByb3ZpZGVyKSIsICJkYXRlX3RpbWUiOiAiMjAxOS0wOC0yM1QyMDoxMDowMC4wMDAiLCAiZGl2IjogIjEiLCAiZHdyX2FiYnJldiI6ICJMRUZUSE9DTyIsICJodHRwX2xpbmthZ2UudXJsIjogImh0dHBzOi8vd2F0ZXJkYXRhLnVzZ3MuZ292L253aXMvdXY/MDY3MjQ5NzAiLCAibG9jYXRpb24ubGF0aXR1ZGUiOiA0MC4xMzQyNzgsICJsb2NhdGlvbi5sb25naXR1ZGUiOiAtMTA1LjEzMDgxOSwgImxvY2F0aW9uLm5lZWRzX3JlY29kaW5nIjogZmFsc2UsICJzdGFnZSI6IG51bGwsICJzdGF0aW9uX25hbWUiOiAiTEVGVCBIQU5EIENSRUVLIEFUIEhPVkVSIFJPQUQgTkVBUiBMT05HTU9OVCwgQ08iLCAic3RhdGlvbl9zdGF0dXMiOiAiQWN0aXZlIiwgInN0YXRpb25fdHlwZSI6ICJTdHJlYW0iLCAidXNnc19zdGF0aW9uX2lkIjogIjA2NzI0OTcwIiwgInZhcmlhYmxlIjogIkRJU0NIUkciLCAid2QiOiAiNSJ9LCAidHlwZSI6ICJGZWF0dXJlIn0sIHsiYmJveCI6IFstMTA1LjIwNjM4NiwgNDAuMjU4MDM4LCAtMTA1LjIwNjM4NiwgNDAuMjU4MDM4XSwgImdlb21ldHJ5IjogeyJjb29yZGluYXRlcyI6IFstMTA1LjIwNjM4NiwgNDAuMjU4MDM4XSwgInR5cGUiOiAiUG9pbnQifSwgImlkIjogIjMyIiwgInByb3BlcnRpZXMiOiB7ImFtb3VudCI6ICIxLjU2IiwgImNvdW50eSI6ICJCT1VMREVSIiwgImRhdGFfc291cmNlIjogIkNvLiBEaXZpc2lvbiBvZiBXYXRlciBSZXNvdXJjZXMiLCAiZGF0ZV90aW1lIjogIjIwMTktMDgtMjNUMjA6MzA6MDAuMDAwIiwgImRpdiI6ICIxIiwgImR3cl9hYmJyZXYiOiAiTFRDQU5ZQ08iLCAiaHR0cF9saW5rYWdlLnVybCI6ICJodHRwczovL2R3ci5zdGF0ZS5jby51cy9TdXJmYWNlV2F0ZXIvZGF0YS9kZXRhaWxfZ3JhcGguYXNweD9JRD1MVENBTllDT1x1MDAyNk1UWVBFPURJU0NIUkciLCAibG9jYXRpb24ubGF0aXR1ZGUiOiA0MC4yNTgwMzgsICJsb2NhdGlvbi5sb25naXR1ZGUiOiAtMTA1LjIwNjM4NiwgImxvY2F0aW9uLm5lZWRzX3JlY29kaW5nIjogZmFsc2UsICJzdGFnZSI6ICIxLjEyIiwgInN0YXRpb25fbmFtZSI6ICJMSVRUTEUgVEhPTVBTT04gUklWRVIgQVQgQ0FOWU9OIE1PVVRIIE5FQVIgQkVSVEhPVUQiLCAic3RhdGlvbl9zdGF0dXMiOiAiQWN0aXZlIiwgInN0YXRpb25fdHlwZSI6ICJTdHJlYW0iLCAidXNnc19zdGF0aW9uX2lkIjogbnVsbCwgInZhcmlhYmxlIjogIkRJU0NIUkciLCAid2QiOiAiNCJ9LCAidHlwZSI6ICJGZWF0dXJlIn0sIHsiYmJveCI6IFstMTA1LjMwNDQwNCwgNDAuMTI2Mzg5LCAtMTA1LjMwNDQwNCwgNDAuMTI2Mzg5XSwgImdlb21ldHJ5IjogeyJjb29yZGluYXRlcyI6IFstMTA1LjMwNDQwNCwgNDAuMTI2Mzg5XSwgInR5cGUiOiAiUG9pbnQifSwgImlkIjogIjMzIiwgInByb3BlcnRpZXMiOiB7ImFtb3VudCI6ICIyOC45MCIsICJjb3VudHkiOiAiQk9VTERFUiIsICJkYXRhX3NvdXJjZSI6ICJDby4gRGl2aXNpb24gb2YgV2F0ZXIgUmVzb3VyY2VzIiwgImRhdGVfdGltZSI6ICIyMDE5LTA4LTIzVDIwOjE1OjAwLjAwMCIsICJkaXYiOiAiMSIsICJkd3JfYWJicmV2IjogIkxFRkNSRUNPIiwgImh0dHBfbGlua2FnZS51cmwiOiAiaHR0cHM6Ly9kd3Iuc3RhdGUuY28udXMvU3VyZmFjZVdhdGVyL2RhdGEvZGV0YWlsX2dyYXBoLmFzcHg/SUQ9TEVGQ1JFQ09cdTAwMjZNVFlQRT1ESVNDSFJHIiwgImxvY2F0aW9uLmxhdGl0dWRlIjogNDAuMTI2Mzg5LCAibG9jYXRpb24ubG9uZ2l0dWRlIjogLTEwNS4zMDQ0MDQsICJsb2NhdGlvbi5uZWVkc19yZWNvZGluZyI6IGZhbHNlLCAic3RhZ2UiOiAiMC44MSIsICJzdGF0aW9uX25hbWUiOiAiTEVGVCBIQU5EIENSRUVLIE5FQVIgQk9VTERFUiwgQ08uIiwgInN0YXRpb25fc3RhdHVzIjogIkFjdGl2ZSIsICJzdGF0aW9uX3R5cGUiOiAiU3RyZWFtIiwgInVzZ3Nfc3RhdGlvbl9pZCI6ICIwNjcyNDUwMCIsICJ2YXJpYWJsZSI6ICJESVNDSFJHIiwgIndkIjogIjUifSwgInR5cGUiOiAiRmVhdHVyZSJ9LCB7ImJib3giOiBbLTEwNS4zMjYyNSwgNDAuMDE4NjY3LCAtMTA1LjMyNjI1LCA0MC4wMTg2NjddLCAiZ2VvbWV0cnkiOiB7ImNvb3JkaW5hdGVzIjogWy0xMDUuMzI2MjUsIDQwLjAxODY2N10sICJ0eXBlIjogIlBvaW50In0sICJpZCI6ICIzNCIsICJwcm9wZXJ0aWVzIjogeyJhbW91bnQiOiAiMC42MyIsICJjb3VudHkiOiAiQk9VTERFUiIsICJkYXRhX3NvdXJjZSI6ICJVLlMuIEdlb2xvZ2ljYWwgU3VydmV5IChEYXRhIFByb3ZpZGVyKSIsICJkYXRlX3RpbWUiOiAiMjAxOS0wOC0yM1QyMDo1MDowMC4wMDAiLCAiZGl2IjogIjEiLCAiZHdyX2FiYnJldiI6ICJGT1VPUk9DTyIsICJodHRwX2xpbmthZ2UudXJsIjogImh0dHBzOi8vd2F0ZXJkYXRhLnVzZ3MuZ292L253aXMvdXY/MDY3Mjc1MDAiLCAibG9jYXRpb24ubGF0aXR1ZGUiOiA0MC4wMTg2NjcsICJsb2NhdGlvbi5sb25naXR1ZGUiOiAtMTA1LjMyNjI1LCAibG9jYXRpb24ubmVlZHNfcmVjb2RpbmciOiBmYWxzZSwgInN0YWdlIjogbnVsbCwgInN0YXRpb25fbmFtZSI6ICJGT1VSTUlMRSBDUkVFSyBBVCBPUk9ERUxMLCBDTyIsICJzdGF0aW9uX3N0YXR1cyI6ICJBY3RpdmUiLCAic3RhdGlvbl90eXBlIjogIlN0cmVhbSIsICJ1c2dzX3N0YXRpb25faWQiOiAiMDY3Mjc1MDAiLCAidmFyaWFibGUiOiAiRElTQ0hSRyIsICJ3ZCI6ICI2In0sICJ0eXBlIjogIkZlYXR1cmUifSwgeyJiYm94IjogWy0xMDUuMTc4ODc1LCA0MC4wNTE2NTIsIC0xMDUuMTc4ODc1LCA0MC4wNTE2NTJdLCAiZ2VvbWV0cnkiOiB7ImNvb3JkaW5hdGVzIjogWy0xMDUuMTc4ODc1LCA0MC4wNTE2NTJdLCAidHlwZSI6ICJQb2ludCJ9LCAiaWQiOiAiMzUiLCAicHJvcGVydGllcyI6IHsiYW1vdW50IjogIjkwLjEwIiwgImNvdW50eSI6ICJCT1VMREVSIiwgImRhdGFfc291cmNlIjogIlUuUy4gR2VvbG9naWNhbCBTdXJ2ZXkgKERhdGEgUHJvdmlkZXIpIiwgImRhdGVfdGltZSI6ICIyMDE5LTA4LTIzVDIwOjE1OjAwLjAwMCIsICJkaXYiOiAiMSIsICJkd3JfYWJicmV2IjogIkJPQ05PUkNPIiwgImh0dHBfbGlua2FnZS51cmwiOiAiaHR0cHM6Ly93YXRlcmRhdGEudXNncy5nb3Yvbndpcy91dj8wNjczMDIwMCIsICJsb2NhdGlvbi5sYXRpdHVkZSI6IDQwLjA1MTY1MiwgImxvY2F0aW9uLmxvbmdpdHVkZSI6IC0xMDUuMTc4ODc1LCAibG9jYXRpb24ubmVlZHNfcmVjb2RpbmciOiBmYWxzZSwgInN0YWdlIjogbnVsbCwgInN0YXRpb25fbmFtZSI6ICJCT1VMREVSIENSRUVLIEFUIE5PUlRIIDc1VEggU1QuIE5FQVIgQk9VTERFUiwgQ08iLCAic3RhdGlvbl9zdGF0dXMiOiAiQWN0aXZlIiwgInN0YXRpb25fdHlwZSI6ICJTdHJlYW0iLCAidXNnc19zdGF0aW9uX2lkIjogIjA2NzMwMjAwIiwgInZhcmlhYmxlIjogIkRJU0NIUkciLCAid2QiOiAiNiJ9LCAidHlwZSI6ICJGZWF0dXJlIn0sIHsiYmJveCI6IFstMTA1LjIwNjU5MiwgNDAuMTk2NDIyLCAtMTA1LjIwNjU5MiwgNDAuMTk2NDIyXSwgImdlb21ldHJ5IjogeyJjb29yZGluYXRlcyI6IFstMTA1LjIwNjU5MiwgNDAuMTk2NDIyXSwgInR5cGUiOiAiUG9pbnQifSwgImlkIjogIjM2IiwgInByb3BlcnRpZXMiOiB7ImFtb3VudCI6ICIxMy40MSIsICJjb3VudHkiOiAiQk9VTERFUiIsICJkYXRhX3NvdXJjZSI6ICJDb29wZXJhdGl2ZSBQcm9ncmFtIG9mIENEV1IsIE5DV0NEIFx1MDAyNiBTVkxIV0NEIiwgImRhdGVfdGltZSI6ICIyMDE5LTA4LTIzVDIwOjAwOjAwLjAwMCIsICJkaXYiOiAiMSIsICJkd3JfYWJicmV2IjogIk9MSURJVENPIiwgImh0dHBfbGlua2FnZS51cmwiOiAiaHR0cHM6Ly9kd3Iuc3RhdGUuY28udXMvU3VyZmFjZVdhdGVyL2RhdGEvZGV0YWlsX2dyYXBoLmFzcHg/SUQ9T0xJRElUQ09cdTAwMjZNVFlQRT1ESVNDSFJHIiwgImxvY2F0aW9uLmxhdGl0dWRlIjogNDAuMTk2NDIyLCAibG9jYXRpb24ubG9uZ2l0dWRlIjogLTEwNS4yMDY1OTIsICJsb2NhdGlvbi5uZWVkc19yZWNvZGluZyI6IGZhbHNlLCAic3RhZ2UiOiAiMC41MSIsICJzdGF0aW9uX25hbWUiOiAiT0xJR0FSQ0hZIERJVENIIERJVkVSU0lPTiIsICJzdGF0aW9uX3N0YXR1cyI6ICJBY3RpdmUiLCAic3RhdGlvbl90eXBlIjogIkRpdmVyc2lvbiIsICJ1c2dzX3N0YXRpb25faWQiOiBudWxsLCAidmFyaWFibGUiOiAiRElTQ0hSRyIsICJ3ZCI6ICI1In0sICJ0eXBlIjogIkZlYXR1cmUifSwgeyJiYm94IjogWy0xMDUuMjUwOTI3LCA0MC4yMTEwODMsIC0xMDUuMjUwOTI3LCA0MC4yMTEwODNdLCAiZ2VvbWV0cnkiOiB7ImNvb3JkaW5hdGVzIjogWy0xMDUuMjUwOTI3LCA0MC4yMTEwODNdLCAidHlwZSI6ICJQb2ludCJ9LCAiaWQiOiAiMzciLCAicHJvcGVydGllcyI6IHsiYW1vdW50IjogIjAuMTAiLCAiY291bnR5IjogIkJPVUxERVIiLCAiZGF0YV9zb3VyY2UiOiAiQ29vcGVyYXRpdmUgUHJvZ3JhbSBvZiBDRFdSLCBOQ1dDRCBcdTAwMjYgU1ZMSFdDRCIsICJkYXRlX3RpbWUiOiAiMjAxOS0wOC0yM1QxOTowMDowMC4wMDAiLCAiZGl2IjogIjEiLCAiZHdyX2FiYnJldiI6ICJTV0VESVRDTyIsICJodHRwX2xpbmthZ2UudXJsIjogImh0dHBzOi8vZHdyLnN0YXRlLmNvLnVzL1N1cmZhY2VXYXRlci9kYXRhL2RldGFpbF9ncmFwaC5hc3B4P0lEPVNXRURJVENPXHUwMDI2TVRZUEU9RElTQ0hSRyIsICJsb2NhdGlvbi5sYXRpdHVkZSI6IDQwLjIxMTA4MywgImxvY2F0aW9uLmxvbmdpdHVkZSI6IC0xMDUuMjUwOTI3LCAibG9jYXRpb24ubmVlZHNfcmVjb2RpbmciOiBmYWxzZSwgInN0YWdlIjogIjAuMDQiLCAic3RhdGlvbl9uYW1lIjogIlNXRURFIERJVENIIiwgInN0YXRpb25fc3RhdHVzIjogIkFjdGl2ZSIsICJzdGF0aW9uX3R5cGUiOiAiRGl2ZXJzaW9uIiwgInVzZ3Nfc3RhdGlvbl9pZCI6IG51bGwsICJ2YXJpYWJsZSI6ICJESVNDSFJHIiwgIndkIjogIjUifSwgInR5cGUiOiAiRmVhdHVyZSJ9LCB7ImJib3giOiBbLTEwNS4yNTk3OTUsIDQwLjIxOTA0NiwgLTEwNS4yNTk3OTUsIDQwLjIxOTA0Nl0sICJnZW9tZXRyeSI6IHsiY29vcmRpbmF0ZXMiOiBbLTEwNS4yNTk3OTUsIDQwLjIxOTA0Nl0sICJ0eXBlIjogIlBvaW50In0sICJpZCI6ICIzOCIsICJwcm9wZXJ0aWVzIjogeyJhbW91bnQiOiAiMy40NCIsICJjb3VudHkiOiAiQk9VTERFUiIsICJkYXRhX3NvdXJjZSI6ICJDb29wZXJhdGl2ZSBQcm9ncmFtIG9mIENEV1IsIE5DV0NEIFx1MDAyNiBTVkxIV0NEIiwgImRhdGVfdGltZSI6ICIyMDE5LTA4LTIzVDEwOjQ1OjAwLjAwMCIsICJkaXYiOiAiMSIsICJkd3JfYWJicmV2IjogIlNVUERJVENPIiwgImh0dHBfbGlua2FnZS51cmwiOiAiaHR0cHM6Ly9kd3Iuc3RhdGUuY28udXMvU3VyZmFjZVdhdGVyL2RhdGEvZGV0YWlsX2dyYXBoLmFzcHg/SUQ9U1VQRElUQ09cdTAwMjZNVFlQRT1ESVNDSFJHIiwgImxvY2F0aW9uLmxhdGl0dWRlIjogNDAuMjE5MDQ2LCAibG9jYXRpb24ubG9uZ2l0dWRlIjogLTEwNS4yNTk3OTUsICJsb2NhdGlvbi5uZWVkc19yZWNvZGluZyI6IGZhbHNlLCAic3RhZ2UiOiAiMC4yNyIsICJzdGF0aW9uX25hbWUiOiAiU1VQUExZIERJVENIIiwgInN0YXRpb25fc3RhdHVzIjogIkFjdGl2ZSIsICJzdGF0aW9uX3R5cGUiOiAiRGl2ZXJzaW9uIiwgInVzZ3Nfc3RhdGlvbl9pZCI6IG51bGwsICJ2YXJpYWJsZSI6ICJESVNDSFJHIiwgIndkIjogIjUifSwgInR5cGUiOiAiRmVhdHVyZSJ9LCB7ImJib3giOiBbLTEwNS4yMTAzOSwgNDAuMTkzNzU4LCAtMTA1LjIxMDM5LCA0MC4xOTM3NThdLCAiZ2VvbWV0cnkiOiB7ImNvb3JkaW5hdGVzIjogWy0xMDUuMjEwMzksIDQwLjE5Mzc1OF0sICJ0eXBlIjogIlBvaW50In0sICJpZCI6ICIzOSIsICJwcm9wZXJ0aWVzIjogeyJhbW91bnQiOiAiMC4wMCIsICJjb3VudHkiOiAiQk9VTERFUiIsICJkYXRhX3NvdXJjZSI6ICJDb29wZXJhdGl2ZSBQcm9ncmFtIG9mIENEV1IsIE5DV0NEIFx1MDAyNiBTVkxIV0NEIiwgImRhdGVfdGltZSI6ICIyMDE5LTA4LTIzVDIwOjAwOjAwLjAwMCIsICJkaXYiOiAiMSIsICJkd3JfYWJicmV2IjogIkNMT0RJVENPIiwgImh0dHBfbGlua2FnZS51cmwiOiAiaHR0cHM6Ly9kd3Iuc3RhdGUuY28udXMvU3VyZmFjZVdhdGVyL2RhdGEvZGV0YWlsX2dyYXBoLmFzcHg/SUQ9Q0xPRElUQ09cdTAwMjZNVFlQRT1ESVNDSFJHIiwgImxvY2F0aW9uLmxhdGl0dWRlIjogNDAuMTkzNzU4LCAibG9jYXRpb24ubG9uZ2l0dWRlIjogLTEwNS4yMTAzOSwgImxvY2F0aW9uLm5lZWRzX3JlY29kaW5nIjogZmFsc2UsICJzdGFnZSI6IG51bGwsICJzdGF0aW9uX25hbWUiOiAiQ0xPVUdIIEFORCBUUlVFIERJVENIIiwgInN0YXRpb25fc3RhdHVzIjogIkFjdGl2ZSIsICJzdGF0aW9uX3R5cGUiOiAiRGl2ZXJzaW9uIiwgInVzZ3Nfc3RhdGlvbl9pZCI6IG51bGwsICJ2YXJpYWJsZSI6ICJESVNDSFJHIiwgIndkIjogIjUifSwgInR5cGUiOiAiRmVhdHVyZSJ9LCB7ImJib3giOiBbLTEwNS4yNTgxMSwgNDAuMjE4MzM1LCAtMTA1LjI1ODExLCA0MC4yMTgzMzVdLCAiZ2VvbWV0cnkiOiB7ImNvb3JkaW5hdGVzIjogWy0xMDUuMjU4MTEsIDQwLjIxODMzNV0sICJ0eXBlIjogIlBvaW50In0sICJpZCI6ICI0MCIsICJwcm9wZXJ0aWVzIjogeyJhbW91bnQiOiAiMTMwLjAwIiwgImNvdW50eSI6ICJCT1VMREVSIiwgImRhdGFfc291cmNlIjogIk5vcnRoZXJuIENvbG9yYWRvIFdhdGVyIENvbnNlcnZhbmN5IERpc3RyaWN0IChTdGF0aW9uIENvb3BlcmF0b3IpIiwgImRhdGVfdGltZSI6ICIyMDE5LTA4LTIzVDIwOjMwOjAwLjAwMCIsICJkaXYiOiAiMSIsICJkd3JfYWJicmV2IjogIlNWU0xZT0NPIiwgImh0dHBfbGlua2FnZS51cmwiOiAiaHR0cHM6Ly9kd3Iuc3RhdGUuY28udXMvU3VyZmFjZVdhdGVyL2RhdGEvZGV0YWlsX2dyYXBoLmFzcHg/SUQ9U1ZTTFlPQ09cdTAwMjZNVFlQRT1ESVNDSFJHIiwgImxvY2F0aW9uLmxhdGl0dWRlIjogNDAuMjE4MzM1LCAibG9jYXRpb24ubG9uZ2l0dWRlIjogLTEwNS4yNTgxMSwgImxvY2F0aW9uLm5lZWRzX3JlY29kaW5nIjogZmFsc2UsICJzdGFnZSI6ICIxLjY2IiwgInN0YXRpb25fbmFtZSI6ICJTQUlOVCBWUkFJTiBTVVBQTFkgQ0FOQUwgTkVBUiBMWU9OUywgQ08iLCAic3RhdGlvbl9zdGF0dXMiOiAiQWN0aXZlIiwgInN0YXRpb25fdHlwZSI6ICJEaXZlcnNpb24iLCAidXNnc19zdGF0aW9uX2lkIjogbnVsbCwgInZhcmlhYmxlIjogIkRJU0NIUkciLCAid2QiOiAiNSJ9LCAidHlwZSI6ICJGZWF0dXJlIn0sIHsiYmJveCI6IFstMTA1LjE2Nzg3MywgNDAuMTc0ODQ0LCAtMTA1LjE2Nzg3MywgNDAuMTc0ODQ0XSwgImdlb21ldHJ5IjogeyJjb29yZGluYXRlcyI6IFstMTA1LjE2Nzg3MywgNDAuMTc0ODQ0XSwgInR5cGUiOiAiUG9pbnQifSwgImlkIjogIjQxIiwgInByb3BlcnRpZXMiOiB7ImFtb3VudCI6ICIyLjI0IiwgImNvdW50eSI6ICJCT1VMREVSIiwgImRhdGFfc291cmNlIjogIkNvb3BlcmF0aXZlIFByb2dyYW0gb2YgQ0RXUiwgTkNXQ0QgXHUwMDI2IFNWTEhXQ0QiLCAiZGF0ZV90aW1lIjogIjIwMTktMDgtMjNUMTk6NDU6MDAuMDAwIiwgImRpdiI6ICIxIiwgImR3cl9hYmJyZXYiOiAiSEdSTURXQ08iLCAiaHR0cF9saW5rYWdlLnVybCI6ICJodHRwczovL2R3ci5zdGF0ZS5jby51cy9TdXJmYWNlV2F0ZXIvZGF0YS9kZXRhaWxfZ3JhcGguYXNweD9JRD1IR1JNRFdDT1x1MDAyNk1UWVBFPURJU0NIUkciLCAibG9jYXRpb24ubGF0aXR1ZGUiOiA0MC4xNzQ4NDQsICJsb2NhdGlvbi5sb25naXR1ZGUiOiAtMTA1LjE2Nzg3MywgImxvY2F0aW9uLm5lZWRzX3JlY29kaW5nIjogZmFsc2UsICJzdGFnZSI6ICIwLjQ4IiwgInN0YXRpb25fbmFtZSI6ICJIQUdFUiBNRUFET1dTIERJVENIIiwgInN0YXRpb25fc3RhdHVzIjogIkFjdGl2ZSIsICJzdGF0aW9uX3R5cGUiOiAiRGl2ZXJzaW9uIiwgInVzZ3Nfc3RhdGlvbl9pZCI6IG51bGwsICJ2YXJpYWJsZSI6ICJESVNDSFJHIiwgIndkIjogIjUifSwgInR5cGUiOiAiRmVhdHVyZSJ9LCB7ImJib3giOiBbLTEwNS40MjI5ODUsIDM5LjkzMTY1OSwgLTEwNS40MjI5ODUsIDM5LjkzMTY1OV0sICJnZW9tZXRyeSI6IHsiY29vcmRpbmF0ZXMiOiBbLTEwNS40MjI5ODUsIDM5LjkzMTY1OV0sICJ0eXBlIjogIlBvaW50In0sICJpZCI6ICI0MiIsICJwcm9wZXJ0aWVzIjogeyJhbW91bnQiOiAiOTYuMjAiLCAiY291bnR5IjogIkJPVUxERVIiLCAiZGF0YV9zb3VyY2UiOiAiQ28uIERpdmlzaW9uIG9mIFdhdGVyIFJlc291cmNlcyIsICJkYXRlX3RpbWUiOiAiMjAxOS0wOC0yM1QyMDo0NTowMC4wMDAiLCAiZGl2IjogIjEiLCAiZHdyX2FiYnJldiI6ICJCT0NQSU5DTyIsICJodHRwX2xpbmthZ2UudXJsIjogImh0dHBzOi8vZHdyLnN0YXRlLmNvLnVzL1N1cmZhY2VXYXRlci9kYXRhL2RldGFpbF9ncmFwaC5hc3B4P0lEPUJPQ1BJTkNPXHUwMDI2TVRZUEU9RElTQ0hSRyIsICJsb2NhdGlvbi5sYXRpdHVkZSI6IDM5LjkzMTY1OSwgImxvY2F0aW9uLmxvbmdpdHVkZSI6IC0xMDUuNDIyOTg1LCAibG9jYXRpb24ubmVlZHNfcmVjb2RpbmciOiBmYWxzZSwgInN0YWdlIjogIjAuOTYiLCAic3RhdGlvbl9uYW1lIjogIlNPVVRIIEJPVUxERVIgQ1JFRUsgQUJPVkUgR1JPU1MgUkVTRVJWT0lSIEFUIFBJTkVDTElGRkUiLCAic3RhdGlvbl9zdGF0dXMiOiAiQWN0aXZlIiwgInN0YXRpb25fdHlwZSI6ICJTdHJlYW0iLCAidXNnc19zdGF0aW9uX2lkIjogbnVsbCwgInZhcmlhYmxlIjogIkRJU0NIUkciLCAid2QiOiAiNiJ9LCAidHlwZSI6ICJGZWF0dXJlIn0sIHsiYmJveCI6IFstMTA1LjUwODQ4LCA0MC4wOTEzOTEsIC0xMDUuNTA4NDgsIDQwLjA5MTM5MV0sICJnZW9tZXRyeSI6IHsiY29vcmRpbmF0ZXMiOiBbLTEwNS41MDg0OCwgNDAuMDkxMzkxXSwgInR5cGUiOiAiUG9pbnQifSwgImlkIjogIjQzIiwgInByb3BlcnRpZXMiOiB7ImFtb3VudCI6ICIyOS4yMCIsICJjb3VudHkiOiAiQk9VTERFUiIsICJkYXRhX3NvdXJjZSI6ICJDby4gRGl2aXNpb24gb2YgV2F0ZXIgUmVzb3VyY2VzIiwgImRhdGVfdGltZSI6ICIyMDE5LTA4LTIzVDIwOjMwOjAwLjAwMCIsICJkaXYiOiAiMSIsICJkd3JfYWJicmV2IjogIkxFRlRIRENPIiwgImh0dHBfbGlua2FnZS51cmwiOiAiaHR0cHM6Ly9kd3Iuc3RhdGUuY28udXMvU3VyZmFjZVdhdGVyL2RhdGEvZGV0YWlsX2dyYXBoLmFzcHg/SUQ9TEVGVEhEQ09cdTAwMjZNVFlQRT1ESVNDSFJHIiwgImxvY2F0aW9uLmxhdGl0dWRlIjogNDAuMDkxMzkxLCAibG9jYXRpb24ubG9uZ2l0dWRlIjogLTEwNS41MDg0OCwgImxvY2F0aW9uLm5lZWRzX3JlY29kaW5nIjogZmFsc2UsICJzdGFnZSI6ICIxLjU0IiwgInN0YXRpb25fbmFtZSI6ICJMRUZUIEhBTkQgRElWRVJTSU9OIE5FQVIgV0FSRCIsICJzdGF0aW9uX3N0YXR1cyI6ICJBY3RpdmUiLCAic3RhdGlvbl90eXBlIjogIkRpdmVyc2lvbiIsICJ1c2dzX3N0YXRpb25faWQiOiBudWxsLCAidmFyaWFibGUiOiAiRElTQ0hSRyIsICJ3ZCI6ICI1In0sICJ0eXBlIjogIkZlYXR1cmUifSwgeyJiYm94IjogWy0xMDUuMzY0OTE3MDAwMDAwMDIsIDQwLjA0MjAyOCwgLTEwNS4zNjQ5MTcwMDAwMDAwMiwgNDAuMDQyMDI4XSwgImdlb21ldHJ5IjogeyJjb29yZGluYXRlcyI6IFstMTA1LjM2NDkxNzAwMDAwMDAyLCA0MC4wNDIwMjhdLCAidHlwZSI6ICJQb2ludCJ9LCAiaWQiOiAiNDQiLCAicHJvcGVydGllcyI6IHsiYW1vdW50IjogbnVsbCwgImNvdW50eSI6ICJCT1VMREVSIiwgImRhdGFfc291cmNlIjogIlUuUy4gR2VvbG9naWNhbCBTdXJ2ZXkgKERhdGEgUHJvdmlkZXIpIiwgImRhdGVfdGltZSI6ICIxOTk5LTA5LTMwVDAwOjAwOjAwLjAwMCIsICJkaXYiOiAiMSIsICJkd3JfYWJicmV2IjogIkZSTUxNUkNPIiwgImh0dHBfbGlua2FnZS51cmwiOiAiaHR0cHM6Ly93YXRlcmRhdGEudXNncy5nb3Yvbndpcy91dj8wNjcyNzQxMCIsICJsb2NhdGlvbi5sYXRpdHVkZSI6IDQwLjA0MjAyOCwgImxvY2F0aW9uLmxvbmdpdHVkZSI6IC0xMDUuMzY0OTE3LCAibG9jYXRpb24ubmVlZHNfcmVjb2RpbmciOiBmYWxzZSwgInN0YWdlIjogbnVsbCwgInN0YXRpb25fbmFtZSI6ICJGT1VSTUlMRSBDUkVFSyBBVCBMT0dBTiBNSUxMIFJPQUQgTkVBUiBDUklTTUFOLCBDTyIsICJzdGF0aW9uX3N0YXR1cyI6ICJBY3RpdmUiLCAic3RhdGlvbl90eXBlIjogIlN0cmVhbSIsICJ1c2dzX3N0YXRpb25faWQiOiAiMDY3Mjc0MTAiLCAidmFyaWFibGUiOiAiRElTQ0hSRyIsICJ3ZCI6ICI2In0sICJ0eXBlIjogIkZlYXR1cmUifSwgeyJiYm94IjogWy0xMDUuMjUwOTUyLCA0MC4yMTEzODksIC0xMDUuMjUwOTUyLCA0MC4yMTEzODldLCAiZ2VvbWV0cnkiOiB7ImNvb3JkaW5hdGVzIjogWy0xMDUuMjUwOTUyLCA0MC4yMTEzODldLCAidHlwZSI6ICJQb2ludCJ9LCAiaWQiOiAiNDUiLCAicHJvcGVydGllcyI6IHsiYW1vdW50IjogIjQuNTAiLCAiY291bnR5IjogIkJPVUxERVIiLCAiZGF0YV9zb3VyY2UiOiAiQ29vcGVyYXRpdmUgUHJvZ3JhbSBvZiBDRFdSLCBOQ1dDRCBcdTAwMjYgU1ZMSFdDRCIsICJkYXRlX3RpbWUiOiAiMjAxOS0wOC0yM1QxOTowMDowMC4wMDAiLCAiZGl2IjogIjEiLCAiZHdyX2FiYnJldiI6ICJTTUVESVRDTyIsICJodHRwX2xpbmthZ2UudXJsIjogImh0dHBzOi8vZHdyLnN0YXRlLmNvLnVzL1N1cmZhY2VXYXRlci9kYXRhL2RldGFpbF9ncmFwaC5hc3B4P0lEPVNNRURJVENPXHUwMDI2TVRZUEU9RElTQ0hSRyIsICJsb2NhdGlvbi5sYXRpdHVkZSI6IDQwLjIxMTM4OSwgImxvY2F0aW9uLmxvbmdpdHVkZSI6IC0xMDUuMjUwOTUyLCAibG9jYXRpb24ubmVlZHNfcmVjb2RpbmciOiBmYWxzZSwgInN0YWdlIjogIjAuODMiLCAic3RhdGlvbl9uYW1lIjogIlNNRUFEIERJVENIIiwgInN0YXRpb25fc3RhdHVzIjogIkFjdGl2ZSIsICJzdGF0aW9uX3R5cGUiOiAiRGl2ZXJzaW9uIiwgInVzZ3Nfc3RhdGlvbl9pZCI6IG51bGwsICJ2YXJpYWJsZSI6ICJESVNDSFJHIiwgIndkIjogIjUifSwgInR5cGUiOiAiRmVhdHVyZSJ9LCB7ImJib3giOiBbLTEwNS4yMDk1LCA0MC4yNTU3NzYsIC0xMDUuMjA5NSwgNDAuMjU1Nzc2XSwgImdlb21ldHJ5IjogeyJjb29yZGluYXRlcyI6IFstMTA1LjIwOTUsIDQwLjI1NTc3Nl0sICJ0eXBlIjogIlBvaW50In0sICJpZCI6ICI0NiIsICJwcm9wZXJ0aWVzIjogeyJhbW91bnQiOiAiOS4yOCIsICJjb3VudHkiOiAiQk9VTERFUiIsICJkYXRhX3NvdXJjZSI6ICJOb3J0aGVybiBDb2xvcmFkbyBXYXRlciBDb25zZXJ2YW5jeSBEaXN0cmljdCAoRGF0YSBQcm92aWRlcikiLCAiZGF0ZV90aW1lIjogIjIwMTktMDgtMjNUMjA6MDA6MDAuMDAwIiwgImRpdiI6ICIxIiwgImR3cl9hYmJyZXYiOiAiTElUVEgyQ08iLCAiaHR0cF9saW5rYWdlLnVybCI6ICJodHRwOi8vd3d3Lm5vcnRoZXJud2F0ZXIub3JnL1dhdGVyUHJvamVjdHMvRWFzdFNsb3BlV2F0ZXJEYXRhLmFzcHgiLCAibG9jYXRpb24ubGF0aXR1ZGUiOiA0MC4yNTU3NzYsICJsb2NhdGlvbi5sb25naXR1ZGUiOiAtMTA1LjIwOTUsICJsb2NhdGlvbi5uZWVkc19yZWNvZGluZyI6IGZhbHNlLCAic3RhZ2UiOiBudWxsLCAic3RhdGlvbl9uYW1lIjogIkxJVFRMRSBUSE9NUFNPTiAjMiBESVRDSCIsICJzdGF0aW9uX3N0YXR1cyI6ICJBY3RpdmUiLCAic3RhdGlvbl90eXBlIjogIkRpdmVyc2lvbiIsICJ1c2dzX3N0YXRpb25faWQiOiAiRVMxOTAwIiwgInZhcmlhYmxlIjogIkRJU0NIUkciLCAid2QiOiAiNCJ9LCAidHlwZSI6ICJGZWF0dXJlIn0sIHsiYmJveCI6IFstMTA1LjMzMDg0MSwgNDAuMDA2MzgwMDAwMDAwMDEsIC0xMDUuMzMwODQxLCA0MC4wMDYzODAwMDAwMDAwMV0sICJnZW9tZXRyeSI6IHsiY29vcmRpbmF0ZXMiOiBbLTEwNS4zMzA4NDEsIDQwLjAwNjM4MDAwMDAwMDAxXSwgInR5cGUiOiAiUG9pbnQifSwgImlkIjogIjQ3IiwgInByb3BlcnRpZXMiOiB7ImFtb3VudCI6ICI0Ni40MCIsICJjb3VudHkiOiAiQk9VTERFUiIsICJkYXRhX3NvdXJjZSI6ICJDby4gRGl2aXNpb24gb2YgV2F0ZXIgUmVzb3VyY2VzIiwgImRhdGVfdGltZSI6ICIyMDE5LTA4LTIzVDIwOjE1OjAwLjAwMCIsICJkaXYiOiAiMSIsICJkd3JfYWJicmV2IjogIkJPQ09ST0NPIiwgImh0dHBfbGlua2FnZS51cmwiOiAiaHR0cHM6Ly9kd3Iuc3RhdGUuY28udXMvU3VyZmFjZVdhdGVyL2RhdGEvZGV0YWlsX2dyYXBoLmFzcHg/SUQ9Qk9DT1JPQ09cdTAwMjZNVFlQRT1ESVNDSFJHIiwgImxvY2F0aW9uLmxhdGl0dWRlIjogNDAuMDA2MzgsICJsb2NhdGlvbi5sb25naXR1ZGUiOiAtMTA1LjMzMDg0MSwgImxvY2F0aW9uLm5lZWRzX3JlY29kaW5nIjogZmFsc2UsICJzdGFnZSI6ICIyLjEyIiwgInN0YXRpb25fbmFtZSI6ICJCT1VMREVSIENSRUVLIE5FQVIgT1JPREVMTCwgQ08uIiwgInN0YXRpb25fc3RhdHVzIjogIkFjdGl2ZSIsICJzdGF0aW9uX3R5cGUiOiAiU3RyZWFtIiwgInVzZ3Nfc3RhdGlvbl9pZCI6ICIwNjcyNzAwMCIsICJ2YXJpYWJsZSI6ICJESVNDSFJHIiwgIndkIjogIjYifSwgInR5cGUiOiAiRmVhdHVyZSJ9LCB7ImJib3giOiBbLTEwNS4xNjc2MjIsIDQwLjE3MjkyNSwgLTEwNS4xNjc2MjIsIDQwLjE3MjkyNV0sICJnZW9tZXRyeSI6IHsiY29vcmRpbmF0ZXMiOiBbLTEwNS4xNjc2MjIsIDQwLjE3MjkyNV0sICJ0eXBlIjogIlBvaW50In0sICJpZCI6ICI0OCIsICJwcm9wZXJ0aWVzIjogeyJhbW91bnQiOiAiMS43NSIsICJjb3VudHkiOiAiQk9VTERFUiIsICJkYXRhX3NvdXJjZSI6ICJDb29wZXJhdGl2ZSBTRFIgUHJvZ3JhbSBvZiBDRFdSIFx1MDAyNiBOQ1dDRCIsICJkYXRlX3RpbWUiOiAiMjAxOS0wOC0yM1QyMDowMDowMC4wMDAiLCAiZGl2IjogIjEiLCAiZHdyX2FiYnJldiI6ICJOT1JNVVRDTyIsICJodHRwX2xpbmthZ2UudXJsIjogImh0dHBzOi8vZHdyLnN0YXRlLmNvLnVzL1N1cmZhY2VXYXRlci9kYXRhL2RldGFpbF9ncmFwaC5hc3B4P0lEPU5PUk1VVENPXHUwMDI2TVRZUEU9RElTQ0hSRyIsICJsb2NhdGlvbi5sYXRpdHVkZSI6IDQwLjE3MjkyNSwgImxvY2F0aW9uLmxvbmdpdHVkZSI6IC0xMDUuMTY3NjIyLCAibG9jYXRpb24ubmVlZHNfcmVjb2RpbmciOiBmYWxzZSwgInN0YWdlIjogIjAuNTgiLCAic3RhdGlvbl9uYW1lIjogIk5PUlRIV0VTVCBNVVRVQUwgRElUQ0giLCAic3RhdGlvbl9zdGF0dXMiOiAiQWN0aXZlIiwgInN0YXRpb25fdHlwZSI6ICJEaXZlcnNpb24iLCAidXNnc19zdGF0aW9uX2lkIjogbnVsbCwgInZhcmlhYmxlIjogIkRJU0NIUkciLCAid2QiOiAiNSJ9LCAidHlwZSI6ICJGZWF0dXJlIn0sIHsiYmJveCI6IFstMTA1LjE4OTEzMiwgNDAuMTg3NTI0LCAtMTA1LjE4OTEzMiwgNDAuMTg3NTI0XSwgImdlb21ldHJ5IjogeyJjb29yZGluYXRlcyI6IFstMTA1LjE4OTEzMiwgNDAuMTg3NTI0XSwgInR5cGUiOiAiUG9pbnQifSwgImlkIjogIjQ5IiwgInByb3BlcnRpZXMiOiB7ImFtb3VudCI6ICIwLjAzIiwgImNvdW50eSI6ICJCT1VMREVSIiwgImRhdGFfc291cmNlIjogIkNvb3BlcmF0aXZlIFByb2dyYW0gb2YgQ0RXUiwgTkNXQ0QgXHUwMDI2IFNWTEhXQ0QiLCAiZGF0ZV90aW1lIjogIjIwMTktMDgtMjNUMjA6MDA6MDAuMDAwIiwgImRpdiI6ICIxIiwgImR3cl9hYmJyZXYiOiAiUlVOWU9OQ08iLCAiaHR0cF9saW5rYWdlLnVybCI6ICJodHRwczovL2R3ci5zdGF0ZS5jby51cy9TdXJmYWNlV2F0ZXIvZGF0YS9kZXRhaWxfZ3JhcGguYXNweD9JRD1SVU5ZT05DT1x1MDAyNk1UWVBFPURJU0NIUkciLCAibG9jYXRpb24ubGF0aXR1ZGUiOiA0MC4xODc1MjQsICJsb2NhdGlvbi5sb25naXR1ZGUiOiAtMTA1LjE4OTEzMiwgImxvY2F0aW9uLm5lZWRzX3JlY29kaW5nIjogZmFsc2UsICJzdGFnZSI6ICIwLjAxIiwgInN0YXRpb25fbmFtZSI6ICJSVU5ZT04gRElUQ0giLCAic3RhdGlvbl9zdGF0dXMiOiAiQWN0aXZlIiwgInN0YXRpb25fdHlwZSI6ICJEaXZlcnNpb24iLCAidXNnc19zdGF0aW9uX2lkIjogbnVsbCwgInZhcmlhYmxlIjogIkRJU0NIUkciLCAid2QiOiAiNSJ9LCAidHlwZSI6ICJGZWF0dXJlIn0sIHsiYmJveCI6IFstMTA1LjE4NTc4OSwgNDAuMTg1MDMzLCAtMTA1LjE4NTc4OSwgNDAuMTg1MDMzXSwgImdlb21ldHJ5IjogeyJjb29yZGluYXRlcyI6IFstMTA1LjE4NTc4OSwgNDAuMTg1MDMzXSwgInR5cGUiOiAiUG9pbnQifSwgImlkIjogIjUwIiwgInByb3BlcnRpZXMiOiB7ImFtb3VudCI6ICIxMi4zOCIsICJjb3VudHkiOiAiQk9VTERFUiIsICJkYXRhX3NvdXJjZSI6ICJDb29wZXJhdGl2ZSBQcm9ncmFtIG9mIENEV1IsIE5DV0NEIFx1MDAyNiBTVkxIV0NEIiwgImRhdGVfdGltZSI6ICIyMDE5LTA4LTIzVDIwOjAwOjAwLjAwMCIsICJkaXYiOiAiMSIsICJkd3JfYWJicmV2IjogIlpXRVRVUkNPIiwgImh0dHBfbGlua2FnZS51cmwiOiAiaHR0cHM6Ly9kd3Iuc3RhdGUuY28udXMvU3VyZmFjZVdhdGVyL2RhdGEvZGV0YWlsX2dyYXBoLmFzcHg/SUQ9WldFVFVSQ09cdTAwMjZNVFlQRT1ESVNDSFJHIiwgImxvY2F0aW9uLmxhdGl0dWRlIjogNDAuMTg1MDMzLCAibG9jYXRpb24ubG9uZ2l0dWRlIjogLTEwNS4xODU3ODksICJsb2NhdGlvbi5uZWVkc19yZWNvZGluZyI6IGZhbHNlLCAic3RhZ2UiOiAiMC44NSIsICJzdGF0aW9uX25hbWUiOiAiWldFQ0sgQU5EIFRVUk5FUiBESVRDSCIsICJzdGF0aW9uX3N0YXR1cyI6ICJBY3RpdmUiLCAic3RhdGlvbl90eXBlIjogIkRpdmVyc2lvbiIsICJ1c2dzX3N0YXRpb25faWQiOiBudWxsLCAidmFyaWFibGUiOiAiRElTQ0hSRyIsICJ3ZCI6ICI1In0sICJ0eXBlIjogIkZlYXR1cmUifSwgeyJiYm94IjogWy0xMDUuMzY1MzY1LCA0MC4yMTYyNjMsIC0xMDUuMzY1MzY1LCA0MC4yMTYyNjNdLCAiZ2VvbWV0cnkiOiB7ImNvb3JkaW5hdGVzIjogWy0xMDUuMzY1MzY1LCA0MC4yMTYyNjNdLCAidHlwZSI6ICJQb2ludCJ9LCAiaWQiOiAiNTEiLCAicHJvcGVydGllcyI6IHsiYW1vdW50IjogIjE2MjQ2LjAwIiwgImNvdW50eSI6ICJCT1VMREVSIiwgImRhdGFfc291cmNlIjogIkNvLiBEaXZpc2lvbiBvZiBXYXRlciBSZXNvdXJjZXMiLCAiZGF0ZV90aW1lIjogIjIwMTktMDgtMjNUMjA6NDU6MDAuMDAwIiwgImRpdiI6ICIxIiwgImR3cl9hYmJyZXYiOiAiQlJLREFNQ08iLCAiaHR0cF9saW5rYWdlLnVybCI6ICJodHRwczovL2R3ci5zdGF0ZS5jby51cy9TdXJmYWNlV2F0ZXIvZGF0YS9kZXRhaWxfZ3JhcGguYXNweD9JRD1CUktEQU1DT1x1MDAyNk1UWVBFPVNUT1JBR0UiLCAibG9jYXRpb24ubGF0aXR1ZGUiOiA0MC4yMTYyNjMsICJsb2NhdGlvbi5sb25naXR1ZGUiOiAtMTA1LjM2NTM2NSwgImxvY2F0aW9uLm5lZWRzX3JlY29kaW5nIjogZmFsc2UsICJzdGFnZSI6ICI2NDAwLjIyIiwgInN0YXRpb25fbmFtZSI6ICJCVVRUT05ST0NLIChSQUxQSCBQUklDRSkgUkVTRVJWT0lSIiwgInN0YXRpb25fc3RhdHVzIjogIkFjdGl2ZSIsICJzdGF0aW9uX3R5cGUiOiAiUmVzZXJ2b2lyIiwgInVzZ3Nfc3RhdGlvbl9pZCI6IG51bGwsICJ2YXJpYWJsZSI6ICJTVE9SQUdFIiwgIndkIjogIjUifSwgInR5cGUiOiAiRmVhdHVyZSJ9LCB7ImJib3giOiBbLTEwNS4xNjQzOTcsIDQwLjI1Nzg0NCwgLTEwNS4xNjQzOTcsIDQwLjI1Nzg0NF0sICJnZW9tZXRyeSI6IHsiY29vcmRpbmF0ZXMiOiBbLTEwNS4xNjQzOTcsIDQwLjI1Nzg0NF0sICJ0eXBlIjogIlBvaW50In0sICJpZCI6ICI1MiIsICJwcm9wZXJ0aWVzIjogeyJhbW91bnQiOiAiMC4yMyIsICJjb3VudHkiOiAiQk9VTERFUiIsICJkYXRhX3NvdXJjZSI6ICJDb29wZXJhdGl2ZSBTRFIgUHJvZ3JhbSBvZiBDRFdSIFx1MDAyNiBOQ1dDRCIsICJkYXRlX3RpbWUiOiAiMjAxOS0wOC0yM1QyMDowMDowMC4wMDAiLCAiZGl2IjogIjEiLCAiZHdyX2FiYnJldiI6ICJCTFdESVRDTyIsICJodHRwX2xpbmthZ2UudXJsIjogImh0dHBzOi8vZHdyLnN0YXRlLmNvLnVzL1N1cmZhY2VXYXRlci9kYXRhL2RldGFpbF9ncmFwaC5hc3B4P0lEPUJMV0RJVENPXHUwMDI2TVRZUEU9RElTQ0hSRyIsICJsb2NhdGlvbi5sYXRpdHVkZSI6IDQwLjI1Nzg0NCwgImxvY2F0aW9uLmxvbmdpdHVkZSI6IC0xMDUuMTY0Mzk3LCAibG9jYXRpb24ubmVlZHNfcmVjb2RpbmciOiBmYWxzZSwgInN0YWdlIjogIjAuMTAiLCAic3RhdGlvbl9uYW1lIjogIkJMT1dFUiBESVRDSCIsICJzdGF0aW9uX3N0YXR1cyI6ICJBY3RpdmUiLCAic3RhdGlvbl90eXBlIjogIkRpdmVyc2lvbiIsICJ1c2dzX3N0YXRpb25faWQiOiBudWxsLCAidmFyaWFibGUiOiAiRElTQ0hSRyIsICJ3ZCI6ICI0In0sICJ0eXBlIjogIkZlYXR1cmUifSwgeyJiYm94IjogWy0xMDUuMjU2MDE3LCA0MC4yMTUwNDMsIC0xMDUuMjU2MDE3LCA0MC4yMTUwNDNdLCAiZ2VvbWV0cnkiOiB7ImNvb3JkaW5hdGVzIjogWy0xMDUuMjU2MDE3LCA0MC4yMTUwNDNdLCAidHlwZSI6ICJQb2ludCJ9LCAiaWQiOiAiNTMiLCAicHJvcGVydGllcyI6IHsiYW1vdW50IjogIjEwMy4wMCIsICJjb3VudHkiOiAiQk9VTERFUiIsICJkYXRhX3NvdXJjZSI6ICJDby4gRGl2aXNpb24gb2YgV2F0ZXIgUmVzb3VyY2VzIiwgImRhdGVfdGltZSI6ICIyMDE5LTA4LTIzVDIwOjMwOjAwLjAwMCIsICJkaXYiOiAiMSIsICJkd3JfYWJicmV2IjogIkhJR0hMRENPIiwgImh0dHBfbGlua2FnZS51cmwiOiAiaHR0cHM6Ly9kd3Iuc3RhdGUuY28udXMvU3VyZmFjZVdhdGVyL2RhdGEvZGV0YWlsX2dyYXBoLmFzcHg/SUQ9SElHSExEQ09cdTAwMjZNVFlQRT1ESVNDSFJHIiwgImxvY2F0aW9uLmxhdGl0dWRlIjogNDAuMjE1MDQzLCAibG9jYXRpb24ubG9uZ2l0dWRlIjogLTEwNS4yNTYwMTcsICJsb2NhdGlvbi5uZWVkc19yZWNvZGluZyI6IGZhbHNlLCAic3RhZ2UiOiAiMS40MSIsICJzdGF0aW9uX25hbWUiOiAiSElHSExBTkQgRElUQ0ggQVQgTFlPTlMsIENPIiwgInN0YXRpb25fc3RhdHVzIjogIkFjdGl2ZSIsICJzdGF0aW9uX3R5cGUiOiAiRGl2ZXJzaW9uIiwgInVzZ3Nfc3RhdGlvbl9pZCI6IG51bGwsICJ2YXJpYWJsZSI6ICJESVNDSFJHIiwgIndkIjogIjUifSwgInR5cGUiOiAiRmVhdHVyZSJ9LCB7ImJib3giOiBbLTEwNS41MDQ0NCwgMzkuOTYxNjU1LCAtMTA1LjUwNDQ0LCAzOS45NjE2NTVdLCAiZ2VvbWV0cnkiOiB7ImNvb3JkaW5hdGVzIjogWy0xMDUuNTA0NDQsIDM5Ljk2MTY1NV0sICJ0eXBlIjogIlBvaW50In0sICJpZCI6ICI1NCIsICJwcm9wZXJ0aWVzIjogeyJhbW91bnQiOiAiMzkuNzAiLCAiY291bnR5IjogIkJPVUxERVIiLCAiZGF0YV9zb3VyY2UiOiAiQ28uIERpdmlzaW9uIG9mIFdhdGVyIFJlc291cmNlcyIsICJkYXRlX3RpbWUiOiAiMjAxOS0wOC0yM1QyMDoxNTowMC4wMDAiLCAiZGl2IjogIjEiLCAiZHdyX2FiYnJldiI6ICJCT0NNSURDTyIsICJodHRwX2xpbmthZ2UudXJsIjogImh0dHBzOi8vZHdyLnN0YXRlLmNvLnVzL1N1cmZhY2VXYXRlci9kYXRhL2RldGFpbF9ncmFwaC5hc3B4P0lEPUJPQ01JRENPXHUwMDI2TVRZUEU9RElTQ0hSRyIsICJsb2NhdGlvbi5sYXRpdHVkZSI6IDM5Ljk2MTY1NSwgImxvY2F0aW9uLmxvbmdpdHVkZSI6IC0xMDUuNTA0NDQsICJsb2NhdGlvbi5uZWVkc19yZWNvZGluZyI6IGZhbHNlLCAic3RhZ2UiOiAiMS4zNiIsICJzdGF0aW9uX25hbWUiOiAiTUlERExFIEJPVUxERVIgQ1JFRUsgQVQgTkVERVJMQU5ELCBDTy4iLCAic3RhdGlvbl9zdGF0dXMiOiAiQWN0aXZlIiwgInN0YXRpb25fdHlwZSI6ICJTdHJlYW0iLCAidXNnc19zdGF0aW9uX2lkIjogIjA2NzI1NTAwIiwgInZhcmlhYmxlIjogIkRJU0NIUkciLCAid2QiOiAiNiJ9LCAidHlwZSI6ICJGZWF0dXJlIn0sIHsiYmJveCI6IFstMTA1LjE3ODE0NSwgNDAuMTc3NDIzLCAtMTA1LjE3ODE0NSwgNDAuMTc3NDIzXSwgImdlb21ldHJ5IjogeyJjb29yZGluYXRlcyI6IFstMTA1LjE3ODE0NSwgNDAuMTc3NDIzXSwgInR5cGUiOiAiUG9pbnQifSwgImlkIjogIjU1IiwgInByb3BlcnRpZXMiOiB7ImFtb3VudCI6ICIxNC40MCIsICJjb3VudHkiOiAiQk9VTERFUiIsICJkYXRhX3NvdXJjZSI6ICJDby4gRGl2aXNpb24gb2YgV2F0ZXIgUmVzb3VyY2VzIiwgImRhdGVfdGltZSI6ICIyMDE5LTA4LTIzVDIwOjQ1OjAwLjAwMCIsICJkaXYiOiAiMSIsICJkd3JfYWJicmV2IjogIlNWQ0hHSUNPIiwgImh0dHBfbGlua2FnZS51cmwiOiAiaHR0cHM6Ly9kd3Iuc3RhdGUuY28udXMvU3VyZmFjZVdhdGVyL2RhdGEvZGV0YWlsX2dyYXBoLmFzcHg/SUQ9U1ZDSEdJQ09cdTAwMjZNVFlQRT1ESVNDSFJHIiwgImxvY2F0aW9uLmxhdGl0dWRlIjogNDAuMTc3NDIzLCAibG9jYXRpb24ubG9uZ2l0dWRlIjogLTEwNS4xNzgxNDUsICJsb2NhdGlvbi5uZWVkc19yZWNvZGluZyI6IGZhbHNlLCAic3RhZ2UiOiAiMS45MiIsICJzdGF0aW9uX25hbWUiOiAiU0FJTlQgVlJBSU4gQ1JFRUsgQVQgSFlHSUVORSwgQ08iLCAic3RhdGlvbl9zdGF0dXMiOiAiQWN0aXZlIiwgInN0YXRpb25fdHlwZSI6ICJTdHJlYW0iLCAidXNnc19zdGF0aW9uX2lkIjogbnVsbCwgInZhcmlhYmxlIjogIkRJU0NIUkciLCAid2QiOiAiNSJ9LCAidHlwZSI6ICJGZWF0dXJlIn0sIHsiYmJveCI6IFstMTA1LjM0NzkwNiwgMzkuOTM4MzUxLCAtMTA1LjM0NzkwNiwgMzkuOTM4MzUxXSwgImdlb21ldHJ5IjogeyJjb29yZGluYXRlcyI6IFstMTA1LjM0NzkwNiwgMzkuOTM4MzUxXSwgInR5cGUiOiAiUG9pbnQifSwgImlkIjogIjU2IiwgInByb3BlcnRpZXMiOiB7ImFtb3VudCI6ICIxMTUuMDAiLCAiY291bnR5IjogIkJPVUxERVIiLCAiZGF0YV9zb3VyY2UiOiAiQ28uIERpdmlzaW9uIG9mIFdhdGVyIFJlc291cmNlcyIsICJkYXRlX3RpbWUiOiAiMjAxOS0wOC0yM1QyMDoxNTowMC4wMDAiLCAiZGl2IjogIjEiLCAiZHdyX2FiYnJldiI6ICJCT0NCR1JDTyIsICJodHRwX2xpbmthZ2UudXJsIjogImh0dHBzOi8vZHdyLnN0YXRlLmNvLnVzL1N1cmZhY2VXYXRlci9kYXRhL2RldGFpbF9ncmFwaC5hc3B4P0lEPUJPQ0JHUkNPXHUwMDI2TVRZUEU9RElTQ0hSRyIsICJsb2NhdGlvbi5sYXRpdHVkZSI6IDM5LjkzODM1MSwgImxvY2F0aW9uLmxvbmdpdHVkZSI6IC0xMDUuMzQ3OTA2LCAibG9jYXRpb24ubmVlZHNfcmVjb2RpbmciOiBmYWxzZSwgInN0YWdlIjogIjEuMTAiLCAic3RhdGlvbl9uYW1lIjogIlNPVVRIIEJPVUxERVIgQ1JFRUsgQkVMT1cgR1JPU1MgUkVTRVJWT0lSIiwgInN0YXRpb25fc3RhdHVzIjogIkFjdGl2ZSIsICJzdGF0aW9uX3R5cGUiOiAiU3RyZWFtIiwgInVzZ3Nfc3RhdGlvbl9pZCI6ICIwNjcyOTQ1MCIsICJ2YXJpYWJsZSI6ICJESVNDSFJHIiwgIndkIjogIjYifSwgInR5cGUiOiAiRmVhdHVyZSJ9XSwgInR5cGUiOiAiRmVhdHVyZUNvbGxlY3Rpb24ifSk7CiAgICAgICAgCjwvc2NyaXB0Pg==" style="position:absolute;width:100%;height:100%;left:0;top:0;border:none !important;" allowfullscreen webkitallowfullscreen mozallowfullscreen></iframe></div></div>





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



<div style="width:100%;"><div style="position:relative;width:100%;height:0;padding-bottom:60%;"><iframe src="data:text/html;charset=utf-8;base64,PCFET0NUWVBFIGh0bWw+CjxoZWFkPiAgICAKICAgIDxtZXRhIGh0dHAtZXF1aXY9ImNvbnRlbnQtdHlwZSIgY29udGVudD0idGV4dC9odG1sOyBjaGFyc2V0PVVURi04IiAvPgogICAgCiAgICAgICAgPHNjcmlwdD4KICAgICAgICAgICAgTF9OT19UT1VDSCA9IGZhbHNlOwogICAgICAgICAgICBMX0RJU0FCTEVfM0QgPSBmYWxzZTsKICAgICAgICA8L3NjcmlwdD4KICAgIAogICAgPHNjcmlwdCBzcmM9Imh0dHBzOi8vY2RuLmpzZGVsaXZyLm5ldC9ucG0vbGVhZmxldEAxLjUuMS9kaXN0L2xlYWZsZXQuanMiPjwvc2NyaXB0PgogICAgPHNjcmlwdCBzcmM9Imh0dHBzOi8vY29kZS5qcXVlcnkuY29tL2pxdWVyeS0xLjEyLjQubWluLmpzIj48L3NjcmlwdD4KICAgIDxzY3JpcHQgc3JjPSJodHRwczovL21heGNkbi5ib290c3RyYXBjZG4uY29tL2Jvb3RzdHJhcC8zLjIuMC9qcy9ib290c3RyYXAubWluLmpzIj48L3NjcmlwdD4KICAgIDxzY3JpcHQgc3JjPSJodHRwczovL2NkbmpzLmNsb3VkZmxhcmUuY29tL2FqYXgvbGlicy9MZWFmbGV0LmF3ZXNvbWUtbWFya2Vycy8yLjAuMi9sZWFmbGV0LmF3ZXNvbWUtbWFya2Vycy5qcyI+PC9zY3JpcHQ+CiAgICA8bGluayByZWw9InN0eWxlc2hlZXQiIGhyZWY9Imh0dHBzOi8vY2RuLmpzZGVsaXZyLm5ldC9ucG0vbGVhZmxldEAxLjUuMS9kaXN0L2xlYWZsZXQuY3NzIi8+CiAgICA8bGluayByZWw9InN0eWxlc2hlZXQiIGhyZWY9Imh0dHBzOi8vbWF4Y2RuLmJvb3RzdHJhcGNkbi5jb20vYm9vdHN0cmFwLzMuMi4wL2Nzcy9ib290c3RyYXAubWluLmNzcyIvPgogICAgPGxpbmsgcmVsPSJzdHlsZXNoZWV0IiBocmVmPSJodHRwczovL21heGNkbi5ib290c3RyYXBjZG4uY29tL2Jvb3RzdHJhcC8zLjIuMC9jc3MvYm9vdHN0cmFwLXRoZW1lLm1pbi5jc3MiLz4KICAgIDxsaW5rIHJlbD0ic3R5bGVzaGVldCIgaHJlZj0iaHR0cHM6Ly9tYXhjZG4uYm9vdHN0cmFwY2RuLmNvbS9mb250LWF3ZXNvbWUvNC42LjMvY3NzL2ZvbnQtYXdlc29tZS5taW4uY3NzIi8+CiAgICA8bGluayByZWw9InN0eWxlc2hlZXQiIGhyZWY9Imh0dHBzOi8vY2RuanMuY2xvdWRmbGFyZS5jb20vYWpheC9saWJzL0xlYWZsZXQuYXdlc29tZS1tYXJrZXJzLzIuMC4yL2xlYWZsZXQuYXdlc29tZS1tYXJrZXJzLmNzcyIvPgogICAgPGxpbmsgcmVsPSJzdHlsZXNoZWV0IiBocmVmPSJodHRwczovL3Jhd2Nkbi5naXRoYWNrLmNvbS9weXRob24tdmlzdWFsaXphdGlvbi9mb2xpdW0vbWFzdGVyL2ZvbGl1bS90ZW1wbGF0ZXMvbGVhZmxldC5hd2Vzb21lLnJvdGF0ZS5jc3MiLz4KICAgIDxzdHlsZT5odG1sLCBib2R5IHt3aWR0aDogMTAwJTtoZWlnaHQ6IDEwMCU7bWFyZ2luOiAwO3BhZGRpbmc6IDA7fTwvc3R5bGU+CiAgICA8c3R5bGU+I21hcCB7cG9zaXRpb246YWJzb2x1dGU7dG9wOjA7Ym90dG9tOjA7cmlnaHQ6MDtsZWZ0OjA7fTwvc3R5bGU+CiAgICAKICAgICAgICAgICAgPG1ldGEgbmFtZT0idmlld3BvcnQiIGNvbnRlbnQ9IndpZHRoPWRldmljZS13aWR0aCwKICAgICAgICAgICAgICAgIGluaXRpYWwtc2NhbGU9MS4wLCBtYXhpbXVtLXNjYWxlPTEuMCwgdXNlci1zY2FsYWJsZT1ubyIgLz4KICAgICAgICAgICAgPHN0eWxlPgogICAgICAgICAgICAgICAgI21hcF80ZGZhOWZiY2U1YTg0NDNlOWI3ZGM2ZjZmZjE1OGZlZiB7CiAgICAgICAgICAgICAgICAgICAgcG9zaXRpb246IHJlbGF0aXZlOwogICAgICAgICAgICAgICAgICAgIHdpZHRoOiAxMDAuMCU7CiAgICAgICAgICAgICAgICAgICAgaGVpZ2h0OiAxMDAuMCU7CiAgICAgICAgICAgICAgICAgICAgbGVmdDogMC4wJTsKICAgICAgICAgICAgICAgICAgICB0b3A6IDAuMCU7CiAgICAgICAgICAgICAgICB9CiAgICAgICAgICAgIDwvc3R5bGU+CiAgICAgICAgCiAgICA8c2NyaXB0IHNyYz0iaHR0cHM6Ly9jZG5qcy5jbG91ZGZsYXJlLmNvbS9hamF4L2xpYnMvbGVhZmxldC5tYXJrZXJjbHVzdGVyLzEuMS4wL2xlYWZsZXQubWFya2VyY2x1c3Rlci5qcyI+PC9zY3JpcHQ+CiAgICA8bGluayByZWw9InN0eWxlc2hlZXQiIGhyZWY9Imh0dHBzOi8vY2RuanMuY2xvdWRmbGFyZS5jb20vYWpheC9saWJzL2xlYWZsZXQubWFya2VyY2x1c3Rlci8xLjEuMC9NYXJrZXJDbHVzdGVyLmNzcyIvPgogICAgPGxpbmsgcmVsPSJzdHlsZXNoZWV0IiBocmVmPSJodHRwczovL2NkbmpzLmNsb3VkZmxhcmUuY29tL2FqYXgvbGlicy9sZWFmbGV0Lm1hcmtlcmNsdXN0ZXIvMS4xLjAvTWFya2VyQ2x1c3Rlci5EZWZhdWx0LmNzcyIvPgo8L2hlYWQ+Cjxib2R5PiAgICAKICAgIAogICAgICAgICAgICA8ZGl2IGNsYXNzPSJmb2xpdW0tbWFwIiBpZD0ibWFwXzRkZmE5ZmJjZTVhODQ0M2U5YjdkYzZmNmZmMTU4ZmVmIiA+PC9kaXY+CiAgICAgICAgCjwvYm9keT4KPHNjcmlwdD4gICAgCiAgICAKICAgICAgICAgICAgdmFyIG1hcF80ZGZhOWZiY2U1YTg0NDNlOWI3ZGM2ZjZmZjE1OGZlZiA9IEwubWFwKAogICAgICAgICAgICAgICAgIm1hcF80ZGZhOWZiY2U1YTg0NDNlOWI3ZGM2ZjZmZjE1OGZlZiIsCiAgICAgICAgICAgICAgICB7CiAgICAgICAgICAgICAgICAgICAgY2VudGVyOiBbNDAuMDEsIC0xMDUuMjddLAogICAgICAgICAgICAgICAgICAgIGNyczogTC5DUlMuRVBTRzM4NTcsCiAgICAgICAgICAgICAgICAgICAgem9vbTogMTAsCiAgICAgICAgICAgICAgICAgICAgem9vbUNvbnRyb2w6IHRydWUsCiAgICAgICAgICAgICAgICAgICAgcHJlZmVyQ2FudmFzOiBmYWxzZSwKICAgICAgICAgICAgICAgIH0KICAgICAgICAgICAgKTsKCiAgICAgICAgICAgIAoKICAgICAgICAKICAgIAogICAgICAgICAgICB2YXIgdGlsZV9sYXllcl85YWQwMDg0MGRiMzE0NWRmOGY2YjI5NzFiYjEwYjI0ZSA9IEwudGlsZUxheWVyKAogICAgICAgICAgICAgICAgImh0dHBzOi8vY2FydG9kYi1iYXNlbWFwcy17c30uZ2xvYmFsLnNzbC5mYXN0bHkubmV0L2xpZ2h0X2FsbC97en0ve3h9L3t5fS5wbmciLAogICAgICAgICAgICAgICAgeyJhdHRyaWJ1dGlvbiI6ICJcdTAwMjZjb3B5OyBcdTAwM2NhIGhyZWY9XCJodHRwOi8vd3d3Lm9wZW5zdHJlZXRtYXAub3JnL2NvcHlyaWdodFwiXHUwMDNlT3BlblN0cmVldE1hcFx1MDAzYy9hXHUwMDNlIGNvbnRyaWJ1dG9ycyBcdTAwMjZjb3B5OyBcdTAwM2NhIGhyZWY9XCJodHRwOi8vY2FydG9kYi5jb20vYXR0cmlidXRpb25zXCJcdTAwM2VDYXJ0b0RCXHUwMDNjL2FcdTAwM2UsIENhcnRvREIgXHUwMDNjYSBocmVmID1cImh0dHA6Ly9jYXJ0b2RiLmNvbS9hdHRyaWJ1dGlvbnNcIlx1MDAzZWF0dHJpYnV0aW9uc1x1MDAzYy9hXHUwMDNlIiwgImRldGVjdFJldGluYSI6IGZhbHNlLCAibWF4TmF0aXZlWm9vbSI6IDE4LCAibWF4Wm9vbSI6IDE4LCAibWluWm9vbSI6IDAsICJub1dyYXAiOiBmYWxzZSwgIm9wYWNpdHkiOiAxLCAic3ViZG9tYWlucyI6ICJhYmMiLCAidG1zIjogZmFsc2V9CiAgICAgICAgICAgICkuYWRkVG8obWFwXzRkZmE5ZmJjZTVhODQ0M2U5YjdkYzZmNmZmMTU4ZmVmKTsKICAgICAgICAKICAgIAogICAgICAgICAgICB2YXIgbWFya2VyX2NsdXN0ZXJfYTVlMTExNzdjMzhiNDQwYTk0MTVjYWZhMWY4Mjg5ZTIgPSBMLm1hcmtlckNsdXN0ZXJHcm91cCgKICAgICAgICAgICAgICAgIHt9CiAgICAgICAgICAgICk7CiAgICAgICAgICAgIG1hcF80ZGZhOWZiY2U1YTg0NDNlOWI3ZGM2ZjZmZjE1OGZlZi5hZGRMYXllcihtYXJrZXJfY2x1c3Rlcl9hNWUxMTE3N2MzOGI0NDBhOTQxNWNhZmExZjgyODllMik7CiAgICAgICAgCiAgICAKICAgICAgICAgICAgdmFyIG1hcmtlcl9lM2NiODJmZjU1ZTg0MTg3YTE2MzU5Y2MwZGRhYjE3NSA9IEwubWFya2VyKAogICAgICAgICAgICAgICAgWzQwLjE3MDk5OCwgLTEwNS4xNjA4NzZdLAogICAgICAgICAgICAgICAge30KICAgICAgICAgICAgKS5hZGRUbyhtYXJrZXJfY2x1c3Rlcl9hNWUxMTE3N2MzOGI0NDBhOTQxNWNhZmExZjgyODllMik7CiAgICAgICAgCiAgICAKICAgICAgICB2YXIgcG9wdXBfNWQ4NGIwNzM4ODBkNDNkZTg1NTAwZjFiMzg1OWY2NDIgPSBMLnBvcHVwKHsibWF4V2lkdGgiOiAiMTAwJSJ9KTsKCiAgICAgICAgCiAgICAgICAgICAgIHZhciBodG1sXzY0NTFhODI3ZTE5ZDQ2MjY4ODI2NjQwMWMyOGZkZDU2ID0gJChgPGRpdiBpZD0iaHRtbF82NDUxYTgyN2UxOWQ0NjI2ODgyNjY0MDFjMjhmZGQ1NiIgc3R5bGU9IndpZHRoOiAxMDAuMCU7IGhlaWdodDogMTAwLjAlOyI+TmFtZTogU09VVEggRkxBVCBESVRDSCBQcmVjaXA6IDYuMjY8L2Rpdj5gKVswXTsKICAgICAgICAgICAgcG9wdXBfNWQ4NGIwNzM4ODBkNDNkZTg1NTAwZjFiMzg1OWY2NDIuc2V0Q29udGVudChodG1sXzY0NTFhODI3ZTE5ZDQ2MjY4ODI2NjQwMWMyOGZkZDU2KTsKICAgICAgICAKCiAgICAgICAgbWFya2VyX2UzY2I4MmZmNTVlODQxODdhMTYzNTljYzBkZGFiMTc1LmJpbmRQb3B1cChwb3B1cF81ZDg0YjA3Mzg4MGQ0M2RlODU1MDBmMWIzODU5ZjY0MikKICAgICAgICA7CgogICAgICAgIAogICAgCiAgICAKICAgICAgICAgICAgdmFyIG1hcmtlcl9iYzIzZjkwMTNkNTk0MGE1YTE2NWQ5NDY5NWMyMDk5NiA9IEwubWFya2VyKAogICAgICAgICAgICAgICAgWzQwLjIxMjY1OCwgLTEwNS4yNTE4MjZdLAogICAgICAgICAgICAgICAge30KICAgICAgICAgICAgKS5hZGRUbyhtYXJrZXJfY2x1c3Rlcl9hNWUxMTE3N2MzOGI0NDBhOTQxNWNhZmExZjgyODllMik7CiAgICAgICAgCiAgICAKICAgICAgICB2YXIgcG9wdXBfNTcxNGVmNmE2Mzk3NDBiZjg2MWM4ZGY4YzM3ODlkZmYgPSBMLnBvcHVwKHsibWF4V2lkdGgiOiAiMTAwJSJ9KTsKCiAgICAgICAgCiAgICAgICAgICAgIHZhciBodG1sX2FkOTgyZDUyZGMzNzRlNGM4NzQxMjgyM2IxOGY2MmMzID0gJChgPGRpdiBpZD0iaHRtbF9hZDk4MmQ1MmRjMzc0ZTRjODc0MTI4MjNiMThmNjJjMyIgc3R5bGU9IndpZHRoOiAxMDAuMCU7IGhlaWdodDogMTAwLjAlOyI+TmFtZTogUk9VR0ggQU5EIFJFQURZIERJVENIIFByZWNpcDogMC4wODwvZGl2PmApWzBdOwogICAgICAgICAgICBwb3B1cF81NzE0ZWY2YTYzOTc0MGJmODYxYzhkZjhjMzc4OWRmZi5zZXRDb250ZW50KGh0bWxfYWQ5ODJkNTJkYzM3NGU0Yzg3NDEyODIzYjE4ZjYyYzMpOwogICAgICAgIAoKICAgICAgICBtYXJrZXJfYmMyM2Y5MDEzZDU5NDBhNWExNjVkOTQ2OTVjMjA5OTYuYmluZFBvcHVwKHBvcHVwXzU3MTRlZjZhNjM5NzQwYmY4NjFjOGRmOGMzNzg5ZGZmKQogICAgICAgIDsKCiAgICAgICAgCiAgICAKICAgIAogICAgICAgICAgICB2YXIgbWFya2VyX2E3YmU4ZjUyMzQxZjQ4NTJiNGYxMDlkNjJiODRhMzUyID0gTC5tYXJrZXIoCiAgICAgICAgICAgICAgICBbNDAuMTkzMjgsIC0xMDUuMjEwNDI0XSwKICAgICAgICAgICAgICAgIHt9CiAgICAgICAgICAgICkuYWRkVG8obWFya2VyX2NsdXN0ZXJfYTVlMTExNzdjMzhiNDQwYTk0MTVjYWZhMWY4Mjg5ZTIpOwogICAgICAgIAogICAgCiAgICAgICAgdmFyIHBvcHVwX2FmMjJiNmVmZWJlMjQ4ZjNiYTAxNDdmNjMwMDgxZTIwID0gTC5wb3B1cCh7Im1heFdpZHRoIjogIjEwMCUifSk7CgogICAgICAgIAogICAgICAgICAgICB2YXIgaHRtbF82MzExMWQyY2Q0MDY0NTY3YWNmOTYxZmQ5ZGExMDAxNyA9ICQoYDxkaXYgaWQ9Imh0bWxfNjMxMTFkMmNkNDA2NDU2N2FjZjk2MWZkOWRhMTAwMTciIHN0eWxlPSJ3aWR0aDogMTAwLjAlOyBoZWlnaHQ6IDEwMC4wJTsiPk5hbWU6IFdFQlNURVIgTUNDQVNMSU4gRElUQ0ggUHJlY2lwOiAwLjI5PC9kaXY+YClbMF07CiAgICAgICAgICAgIHBvcHVwX2FmMjJiNmVmZWJlMjQ4ZjNiYTAxNDdmNjMwMDgxZTIwLnNldENvbnRlbnQoaHRtbF82MzExMWQyY2Q0MDY0NTY3YWNmOTYxZmQ5ZGExMDAxNyk7CiAgICAgICAgCgogICAgICAgIG1hcmtlcl9hN2JlOGY1MjM0MWY0ODUyYjRmMTA5ZDYyYjg0YTM1Mi5iaW5kUG9wdXAocG9wdXBfYWYyMmI2ZWZlYmUyNDhmM2JhMDE0N2Y2MzAwODFlMjApCiAgICAgICAgOwoKICAgICAgICAKICAgIAogICAgCiAgICAgICAgICAgIHZhciBtYXJrZXJfMjJjMmMyMDdlZWU0NDlhM2EyMWJmOGRhMTY5NjM3MzAgPSBMLm1hcmtlcigKICAgICAgICAgICAgICAgIFs0MC4xOTkzMjEsIC0xMDUuMjIyNjM5XSwKICAgICAgICAgICAgICAgIHt9CiAgICAgICAgICAgICkuYWRkVG8obWFya2VyX2NsdXN0ZXJfYTVlMTExNzdjMzhiNDQwYTk0MTVjYWZhMWY4Mjg5ZTIpOwogICAgICAgIAogICAgCiAgICAgICAgdmFyIHBvcHVwXzJkYjliYTlhNDM2MDQyYTliOWY4YjA4MzQ1Y2M0NDVjID0gTC5wb3B1cCh7Im1heFdpZHRoIjogIjEwMCUifSk7CgogICAgICAgIAogICAgICAgICAgICB2YXIgaHRtbF80MTAzNjk0ZmE5NDY0ODU1OTc0NWM4ODIzYTgyMDA0MCA9ICQoYDxkaXYgaWQ9Imh0bWxfNDEwMzY5NGZhOTQ2NDg1NTk3NDVjODgyM2E4MjAwNDAiIHN0eWxlPSJ3aWR0aDogMTAwLjAlOyBoZWlnaHQ6IDEwMC4wJTsiPk5hbWU6IEdPU1MgRElUQ0ggMSBQcmVjaXA6IDkuMTQ8L2Rpdj5gKVswXTsKICAgICAgICAgICAgcG9wdXBfMmRiOWJhOWE0MzYwNDJhOWI5ZjhiMDgzNDVjYzQ0NWMuc2V0Q29udGVudChodG1sXzQxMDM2OTRmYTk0NjQ4NTU5NzQ1Yzg4MjNhODIwMDQwKTsKICAgICAgICAKCiAgICAgICAgbWFya2VyXzIyYzJjMjA3ZWVlNDQ5YTNhMjFiZjhkYTE2OTYzNzMwLmJpbmRQb3B1cChwb3B1cF8yZGI5YmE5YTQzNjA0MmE5YjlmOGIwODM0NWNjNDQ1YykKICAgICAgICA7CgogICAgICAgIAogICAgCiAgICAKICAgICAgICAgICAgdmFyIG1hcmtlcl84N2I3OTEyMjhkOWM0YWExYmRmZjU2OWUwYmM1MzA5MiA9IEwubWFya2VyKAogICAgICAgICAgICAgICAgWzQwLjIxNTkwNCwgLTEwNS4yNTc3MzZdLAogICAgICAgICAgICAgICAge30KICAgICAgICAgICAgKS5hZGRUbyhtYXJrZXJfY2x1c3Rlcl9hNWUxMTE3N2MzOGI0NDBhOTQxNWNhZmExZjgyODllMik7CiAgICAgICAgCiAgICAKICAgICAgICB2YXIgcG9wdXBfY2UwZDgyNTYyYzM1NDI1ZmFiNjQ0YjYxZWMyNzkyMDQgPSBMLnBvcHVwKHsibWF4V2lkdGgiOiAiMTAwJSJ9KTsKCiAgICAgICAgCiAgICAgICAgICAgIHZhciBodG1sXzMyMDNhYWRmNjJlMjQ4MGJiZWUzZThjODM1NWE3ZTU1ID0gJChgPGRpdiBpZD0iaHRtbF8zMjAzYWFkZjYyZTI0ODBiYmVlM2U4YzgzNTVhN2U1NSIgc3R5bGU9IndpZHRoOiAxMDAuMCU7IGhlaWdodDogMTAwLjAlOyI+TmFtZTogQk9VTERFUiBDUkVFSyBGRUVERVIgQ0FOQUwgTkVBUiBMWU9OUyBQcmVjaXA6IDU4LjUwPC9kaXY+YClbMF07CiAgICAgICAgICAgIHBvcHVwX2NlMGQ4MjU2MmMzNTQyNWZhYjY0NGI2MWVjMjc5MjA0LnNldENvbnRlbnQoaHRtbF8zMjAzYWFkZjYyZTI0ODBiYmVlM2U4YzgzNTVhN2U1NSk7CiAgICAgICAgCgogICAgICAgIG1hcmtlcl84N2I3OTEyMjhkOWM0YWExYmRmZjU2OWUwYmM1MzA5Mi5iaW5kUG9wdXAocG9wdXBfY2UwZDgyNTYyYzM1NDI1ZmFiNjQ0YjYxZWMyNzkyMDQpCiAgICAgICAgOwoKICAgICAgICAKICAgIAogICAgCiAgICAgICAgICAgIHZhciBtYXJrZXJfMmMxZWE2MTU1ODdlNDc1ZTlhZjI1MmZkYzYyNjEwZGQgPSBMLm1hcmtlcigKICAgICAgICAgICAgICAgIFszOS45ODYxNjksIC0xMDUuMjE4Njc3XSwKICAgICAgICAgICAgICAgIHt9CiAgICAgICAgICAgICkuYWRkVG8obWFya2VyX2NsdXN0ZXJfYTVlMTExNzdjMzhiNDQwYTk0MTVjYWZhMWY4Mjg5ZTIpOwogICAgICAgIAogICAgCiAgICAgICAgdmFyIHBvcHVwXzczOWNmMTZlM2I5MDRhNDY5NTgxMmYwNDI0MDg0NjZhID0gTC5wb3B1cCh7Im1heFdpZHRoIjogIjEwMCUifSk7CgogICAgICAgIAogICAgICAgICAgICB2YXIgaHRtbF82MWFiZWQ4NTAyMzg0YThiOGI4MmU0YzExMjcyNjE0MCA9ICQoYDxkaXYgaWQ9Imh0bWxfNjFhYmVkODUwMjM4NGE4YjhiODJlNGMxMTI3MjYxNDAiIHN0eWxlPSJ3aWR0aDogMTAwLjAlOyBoZWlnaHQ6IDEwMC4wJTsiPk5hbWU6IERSWSBDUkVFSyBDQVJSSUVSIFByZWNpcDogMi4zMTwvZGl2PmApWzBdOwogICAgICAgICAgICBwb3B1cF83MzljZjE2ZTNiOTA0YTQ2OTU4MTJmMDQyNDA4NDY2YS5zZXRDb250ZW50KGh0bWxfNjFhYmVkODUwMjM4NGE4YjhiODJlNGMxMTI3MjYxNDApOwogICAgICAgIAoKICAgICAgICBtYXJrZXJfMmMxZWE2MTU1ODdlNDc1ZTlhZjI1MmZkYzYyNjEwZGQuYmluZFBvcHVwKHBvcHVwXzczOWNmMTZlM2I5MDRhNDY5NTgxMmYwNDI0MDg0NjZhKQogICAgICAgIDsKCiAgICAgICAgCiAgICAKICAgIAogICAgICAgICAgICB2YXIgbWFya2VyX2U0Nzg0YWRlMjE4YTQxMjY4OWRhMTAxZWMxN2I5NTZjID0gTC5tYXJrZXIoCiAgICAgICAgICAgICAgICBbNDAuMDUzMDM1LCAtMTA1LjE5MzA0OF0sCiAgICAgICAgICAgICAgICB7fQogICAgICAgICAgICApLmFkZFRvKG1hcmtlcl9jbHVzdGVyX2E1ZTExMTc3YzM4YjQ0MGE5NDE1Y2FmYTFmODI4OWUyKTsKICAgICAgICAKICAgIAogICAgICAgIHZhciBwb3B1cF85NDRkOTQwZTg3MjQ0NzlhYmRlZTgwOGQ4NzE4NDI3NyA9IEwucG9wdXAoeyJtYXhXaWR0aCI6ICIxMDAlIn0pOwoKICAgICAgICAKICAgICAgICAgICAgdmFyIGh0bWxfOGVlNjMzYWRiNTliNDAxOGFmYmZkYmI5NTM5ZDY1M2EgPSAkKGA8ZGl2IGlkPSJodG1sXzhlZTYzM2FkYjU5YjQwMThhZmJmZGJiOTUzOWQ2NTNhIiBzdHlsZT0id2lkdGg6IDEwMC4wJTsgaGVpZ2h0OiAxMDAuMCU7Ij5OYW1lOiBCT1VMREVSIENSRUVLIFNVUFBMWSBDQU5BTCBUTyBCT1VMREVSIENSRUVLIE5FQVIgQk9VTERFUiBQcmVjaXA6IDcxLjc4PC9kaXY+YClbMF07CiAgICAgICAgICAgIHBvcHVwXzk0NGQ5NDBlODcyNDQ3OWFiZGVlODA4ZDg3MTg0Mjc3LnNldENvbnRlbnQoaHRtbF84ZWU2MzNhZGI1OWI0MDE4YWZiZmRiYjk1MzlkNjUzYSk7CiAgICAgICAgCgogICAgICAgIG1hcmtlcl9lNDc4NGFkZTIxOGE0MTI2ODlkYTEwMWVjMTdiOTU2Yy5iaW5kUG9wdXAocG9wdXBfOTQ0ZDk0MGU4NzI0NDc5YWJkZWU4MDhkODcxODQyNzcpCiAgICAgICAgOwoKICAgICAgICAKICAgIAogICAgCiAgICAgICAgICAgIHZhciBtYXJrZXJfN2YyZTg1MWFjMDlkNDU0YTg4NmEyOWEwYjM1MmQ4ZGIgPSBMLm1hcmtlcigKICAgICAgICAgICAgICAgIFs0MC4yMTU2NTgsIC0xMDUuMzYzNDIyXSwKICAgICAgICAgICAgICAgIHt9CiAgICAgICAgICAgICkuYWRkVG8obWFya2VyX2NsdXN0ZXJfYTVlMTExNzdjMzhiNDQwYTk0MTVjYWZhMWY4Mjg5ZTIpOwogICAgICAgIAogICAgCiAgICAgICAgdmFyIHBvcHVwX2IzNDQzMDFhOTM1MTQ1Y2I5MzZjMzNhYmVlZjc4MzRiID0gTC5wb3B1cCh7Im1heFdpZHRoIjogIjEwMCUifSk7CgogICAgICAgIAogICAgICAgICAgICB2YXIgaHRtbF9hZDkwMjU0ZmFkMmY0YmFjYWU0NjQyMWNjYjNjODMxMiA9ICQoYDxkaXYgaWQ9Imh0bWxfYWQ5MDI1NGZhZDJmNGJhY2FlNDY0MjFjY2IzYzgzMTIiIHN0eWxlPSJ3aWR0aDogMTAwLjAlOyBoZWlnaHQ6IDEwMC4wJTsiPk5hbWU6IE5PUlRIIFNBSU5UIFZSQUlOIENSRUVLIEJFTE9XIEJVVFRPTlJPQ0sgIChSQUxQSCBQUklDRSkgUkVTRVJWT0lSIFByZWNpcDogMzAuNzA8L2Rpdj5gKVswXTsKICAgICAgICAgICAgcG9wdXBfYjM0NDMwMWE5MzUxNDVjYjkzNmMzM2FiZWVmNzgzNGIuc2V0Q29udGVudChodG1sX2FkOTAyNTRmYWQyZjRiYWNhZTQ2NDIxY2NiM2M4MzEyKTsKICAgICAgICAKCiAgICAgICAgbWFya2VyXzdmMmU4NTFhYzA5ZDQ1NGE4ODZhMjlhMGIzNTJkOGRiLmJpbmRQb3B1cChwb3B1cF9iMzQ0MzAxYTkzNTE0NWNiOTM2YzMzYWJlZWY3ODM0YikKICAgICAgICA7CgogICAgICAgIAogICAgCiAgICAKICAgICAgICAgICAgdmFyIG1hcmtlcl9kNTI1ZmE1MmM1NmQ0NWU3ODcyNTBmNmU0MGJhNTAyMCA9IEwubWFya2VyKAogICAgICAgICAgICAgICAgWzQwLjI1NjI3NiwgLTEwNS4yMDk0MTZdLAogICAgICAgICAgICAgICAge30KICAgICAgICAgICAgKS5hZGRUbyhtYXJrZXJfY2x1c3Rlcl9hNWUxMTE3N2MzOGI0NDBhOTQxNWNhZmExZjgyODllMik7CiAgICAgICAgCiAgICAKICAgICAgICB2YXIgcG9wdXBfNmRhNjU5ZmZmMTg1NDhmMDkyZTkxNzBjY2FhNzhjMWEgPSBMLnBvcHVwKHsibWF4V2lkdGgiOiAiMTAwJSJ9KTsKCiAgICAgICAgCiAgICAgICAgICAgIHZhciBodG1sXzQzODBkNzQzM2NjNjQ3OTg5ZWNjZWVjMDQ4MzIzMThkID0gJChgPGRpdiBpZD0iaHRtbF80MzgwZDc0MzNjYzY0Nzk4OWVjY2VlYzA0ODMyMzE4ZCIgc3R5bGU9IndpZHRoOiAxMDAuMCU7IGhlaWdodDogMTAwLjAlOyI+TmFtZTogTElUVExFIFRIT01QU09OICMxIERJVENIIFByZWNpcDogMC4wMzwvZGl2PmApWzBdOwogICAgICAgICAgICBwb3B1cF82ZGE2NTlmZmYxODU0OGYwOTJlOTE3MGNjYWE3OGMxYS5zZXRDb250ZW50KGh0bWxfNDM4MGQ3NDMzY2M2NDc5ODllY2NlZWMwNDgzMjMxOGQpOwogICAgICAgIAoKICAgICAgICBtYXJrZXJfZDUyNWZhNTJjNTZkNDVlNzg3MjUwZjZlNDBiYTUwMjAuYmluZFBvcHVwKHBvcHVwXzZkYTY1OWZmZjE4NTQ4ZjA5MmU5MTcwY2NhYTc4YzFhKQogICAgICAgIDsKCiAgICAgICAgCiAgICAKICAgIAogICAgICAgICAgICB2YXIgbWFya2VyX2U3ZjI4YWRlNWM4ZjQ5ZjVhMzI0M2IzZjEzMWZjODU0ID0gTC5tYXJrZXIoCiAgICAgICAgICAgICAgICBbNDAuMTc3MDgsIC0xMDUuMTc4NTY3XSwKICAgICAgICAgICAgICAgIHt9CiAgICAgICAgICAgICkuYWRkVG8obWFya2VyX2NsdXN0ZXJfYTVlMTExNzdjMzhiNDQwYTk0MTVjYWZhMWY4Mjg5ZTIpOwogICAgICAgIAogICAgCiAgICAgICAgdmFyIHBvcHVwX2Y1YTBiZjE2Y2MzNzQ3NzU4ZTNkNmZkMDk2NDM0ZDNlID0gTC5wb3B1cCh7Im1heFdpZHRoIjogIjEwMCUifSk7CgogICAgICAgIAogICAgICAgICAgICB2YXIgaHRtbF8zZTE1MmQzNWVjNWI0ZjAxYTUxNGY3OTM0YzUzZWQ3MCA9ICQoYDxkaXYgaWQ9Imh0bWxfM2UxNTJkMzVlYzViNGYwMWE1MTRmNzkzNGM1M2VkNzAiIHN0eWxlPSJ3aWR0aDogMTAwLjAlOyBoZWlnaHQ6IDEwMC4wJTsiPk5hbWU6IFBFQ0sgUEVMTEEgQ0xPVkVSIERJVENIIFByZWNpcDogMS43MDwvZGl2PmApWzBdOwogICAgICAgICAgICBwb3B1cF9mNWEwYmYxNmNjMzc0Nzc1OGUzZDZmZDA5NjQzNGQzZS5zZXRDb250ZW50KGh0bWxfM2UxNTJkMzVlYzViNGYwMWE1MTRmNzkzNGM1M2VkNzApOwogICAgICAgIAoKICAgICAgICBtYXJrZXJfZTdmMjhhZGU1YzhmNDlmNWEzMjQzYjNmMTMxZmM4NTQuYmluZFBvcHVwKHBvcHVwX2Y1YTBiZjE2Y2MzNzQ3NzU4ZTNkNmZkMDk2NDM0ZDNlKQogICAgICAgIDsKCiAgICAgICAgCiAgICAKICAgIAogICAgICAgICAgICB2YXIgbWFya2VyX2Q2OWQ5NWNkNWI3YjQ0YTdiNjI5OTU3YTNiZTllYTIxID0gTC5tYXJrZXIoCiAgICAgICAgICAgICAgICBbNDAuMjA0MTkzLCAtMTA1LjIxODc3N10sCiAgICAgICAgICAgICAgICB7fQogICAgICAgICAgICApLmFkZFRvKG1hcmtlcl9jbHVzdGVyX2E1ZTExMTc3YzM4YjQ0MGE5NDE1Y2FmYTFmODI4OWUyKTsKICAgICAgICAKICAgIAogICAgICAgIHZhciBwb3B1cF8yMzkyYmMyYTk5ODk0NDFmOTBmN2U0NGU5OTI2YmVkNCA9IEwucG9wdXAoeyJtYXhXaWR0aCI6ICIxMDAlIn0pOwoKICAgICAgICAKICAgICAgICAgICAgdmFyIGh0bWxfMWMyMDg1Mjc3N2YwNDgyYjgwYWU0YTdhNzJlNjM0NmMgPSAkKGA8ZGl2IGlkPSJodG1sXzFjMjA4NTI3NzdmMDQ4MmI4MGFlNGE3YTcyZTYzNDZjIiBzdHlsZT0id2lkdGg6IDEwMC4wJTsgaGVpZ2h0OiAxMDAuMCU7Ij5OYW1lOiBMT05HTU9OVCBTVVBQTFkgRElUQ0ggUHJlY2lwOiAxMy43MzwvZGl2PmApWzBdOwogICAgICAgICAgICBwb3B1cF8yMzkyYmMyYTk5ODk0NDFmOTBmN2U0NGU5OTI2YmVkNC5zZXRDb250ZW50KGh0bWxfMWMyMDg1Mjc3N2YwNDgyYjgwYWU0YTdhNzJlNjM0NmMpOwogICAgICAgIAoKICAgICAgICBtYXJrZXJfZDY5ZDk1Y2Q1YjdiNDRhN2I2Mjk5NTdhM2JlOWVhMjEuYmluZFBvcHVwKHBvcHVwXzIzOTJiYzJhOTk4OTQ0MWY5MGY3ZTQ0ZTk5MjZiZWQ0KQogICAgICAgIDsKCiAgICAgICAgCiAgICAKICAgIAogICAgICAgICAgICB2YXIgbWFya2VyXzdkNzVjMGNjYjJiNDQ0NzY5OWY3ZmM0NjdjN2IyZmMxID0gTC5tYXJrZXIoCiAgICAgICAgICAgICAgICBbNDAuMDUzNjYxLCAtMTA1LjE1MTE0M10sCiAgICAgICAgICAgICAgICB7fQogICAgICAgICAgICApLmFkZFRvKG1hcmtlcl9jbHVzdGVyX2E1ZTExMTc3YzM4YjQ0MGE5NDE1Y2FmYTFmODI4OWUyKTsKICAgICAgICAKICAgIAogICAgICAgIHZhciBwb3B1cF81YzZhMGYzMTA5ODg0NjgwYjIyOTFlMTQ5MGYxYzFjOCA9IEwucG9wdXAoeyJtYXhXaWR0aCI6ICIxMDAlIn0pOwoKICAgICAgICAKICAgICAgICAgICAgdmFyIGh0bWxfOWM1MmE0ZmE0OWJkNDY3MzgyZjA1MDU2OTBmZTY5YjMgPSAkKGA8ZGl2IGlkPSJodG1sXzljNTJhNGZhNDliZDQ2NzM4MmYwNTA1NjkwZmU2OWIzIiBzdHlsZT0id2lkdGg6IDEwMC4wJTsgaGVpZ2h0OiAxMDAuMCU7Ij5OYW1lOiBMRUdHRVRUIERJVENIIFByZWNpcDogMjEuOTU8L2Rpdj5gKVswXTsKICAgICAgICAgICAgcG9wdXBfNWM2YTBmMzEwOTg4NDY4MGIyMjkxZTE0OTBmMWMxYzguc2V0Q29udGVudChodG1sXzljNTJhNGZhNDliZDQ2NzM4MmYwNTA1NjkwZmU2OWIzKTsKICAgICAgICAKCiAgICAgICAgbWFya2VyXzdkNzVjMGNjYjJiNDQ0NzY5OWY3ZmM0NjdjN2IyZmMxLmJpbmRQb3B1cChwb3B1cF81YzZhMGYzMTA5ODg0NjgwYjIyOTFlMTQ5MGYxYzFjOCkKICAgICAgICA7CgogICAgICAgIAogICAgCiAgICAKICAgICAgICAgICAgdmFyIG1hcmtlcl8wZjQ2OTM4YWMzOTY0MmFmYTE5MWQ5ZGUzZDc1MGI5ZSA9IEwubWFya2VyKAogICAgICAgICAgICAgICAgWzQwLjIyMDcwMiwgLTEwNS4yNjM0OV0sCiAgICAgICAgICAgICAgICB7fQogICAgICAgICAgICApLmFkZFRvKG1hcmtlcl9jbHVzdGVyX2E1ZTExMTc3YzM4YjQ0MGE5NDE1Y2FmYTFmODI4OWUyKTsKICAgICAgICAKICAgIAogICAgICAgIHZhciBwb3B1cF9lYjQ2MDBhZGZmZTg0ZTE3OGU5MGIwMzkxNzQ5M2RlYiA9IEwucG9wdXAoeyJtYXhXaWR0aCI6ICIxMDAlIn0pOwoKICAgICAgICAKICAgICAgICAgICAgdmFyIGh0bWxfZGU1NWJkYzdjYWFmNGM5OWI0NGIxNmM1YTFjODgxZTkgPSAkKGA8ZGl2IGlkPSJodG1sX2RlNTViZGM3Y2FhZjRjOTliNDRiMTZjNWExYzg4MWU5IiBzdHlsZT0id2lkdGg6IDEwMC4wJTsgaGVpZ2h0OiAxMDAuMCU7Ij5OYW1lOiBTQUlOVCBWUkFJTiBDUkVFSyBBVCBMWU9OUywgQ08gUHJlY2lwOiAxMTIuMDA8L2Rpdj5gKVswXTsKICAgICAgICAgICAgcG9wdXBfZWI0NjAwYWRmZmU4NGUxNzhlOTBiMDM5MTc0OTNkZWIuc2V0Q29udGVudChodG1sX2RlNTViZGM3Y2FhZjRjOTliNDRiMTZjNWExYzg4MWU5KTsKICAgICAgICAKCiAgICAgICAgbWFya2VyXzBmNDY5MzhhYzM5NjQyYWZhMTkxZDlkZTNkNzUwYjllLmJpbmRQb3B1cChwb3B1cF9lYjQ2MDBhZGZmZTg0ZTE3OGU5MGIwMzkxNzQ5M2RlYikKICAgICAgICA7CgogICAgICAgIAogICAgCiAgICAKICAgICAgICAgICAgdmFyIG1hcmtlcl85YjQ1MWU2MGJjNTI0YmE1OWUwYjNjZjNmNjZjYmJkOSA9IEwubWFya2VyKAogICAgICAgICAgICAgICAgWzQwLjE4ODU3OSwgLTEwNS4yMDkyODJdLAogICAgICAgICAgICAgICAge30KICAgICAgICAgICAgKS5hZGRUbyhtYXJrZXJfY2x1c3Rlcl9hNWUxMTE3N2MzOGI0NDBhOTQxNWNhZmExZjgyODllMik7CiAgICAgICAgCiAgICAKICAgICAgICB2YXIgcG9wdXBfZWRkZWJlNmI4MGQzNGNhZjllYzMzNGFkNGM2Y2M5MzYgPSBMLnBvcHVwKHsibWF4V2lkdGgiOiAiMTAwJSJ9KTsKCiAgICAgICAgCiAgICAgICAgICAgIHZhciBodG1sXzRjODYyMTNlMjg4ZDQ1Y2E5MDEyNTg1MDI1MTVhYWI1ID0gJChgPGRpdiBpZD0iaHRtbF80Yzg2MjEzZTI4OGQ0NWNhOTAxMjU4NTAyNTE1YWFiNSIgc3R5bGU9IndpZHRoOiAxMDAuMCU7IGhlaWdodDogMTAwLjAlOyI+TmFtZTogSkFNRVMgRElUQ0ggUHJlY2lwOiA1LjI0PC9kaXY+YClbMF07CiAgICAgICAgICAgIHBvcHVwX2VkZGViZTZiODBkMzRjYWY5ZWMzMzRhZDRjNmNjOTM2LnNldENvbnRlbnQoaHRtbF80Yzg2MjEzZTI4OGQ0NWNhOTAxMjU4NTAyNTE1YWFiNSk7CiAgICAgICAgCgogICAgICAgIG1hcmtlcl85YjQ1MWU2MGJjNTI0YmE1OWUwYjNjZjNmNjZjYmJkOS5iaW5kUG9wdXAocG9wdXBfZWRkZWJlNmI4MGQzNGNhZjllYzMzNGFkNGM2Y2M5MzYpCiAgICAgICAgOwoKICAgICAgICAKICAgIAogICAgCiAgICAgICAgICAgIHZhciBtYXJrZXJfNGRlYzdiOWU4MGM0NDMyMDhlNzg4ZTg2NWM5MDA1NzAgPSBMLm1hcmtlcigKICAgICAgICAgICAgICAgIFszOS45MzE4MTMsIC0xMDUuMzA4NDMyXSwKICAgICAgICAgICAgICAgIHt9CiAgICAgICAgICAgICkuYWRkVG8obWFya2VyX2NsdXN0ZXJfYTVlMTExNzdjMzhiNDQwYTk0MTVjYWZhMWY4Mjg5ZTIpOwogICAgICAgIAogICAgCiAgICAgICAgdmFyIHBvcHVwXzU2MzQ3ZmFhNzEyNjQ1YzE5ZGExZmI3NmU3MmNmMGQ0ID0gTC5wb3B1cCh7Im1heFdpZHRoIjogIjEwMCUifSk7CgogICAgICAgIAogICAgICAgICAgICB2YXIgaHRtbF8yZWY2OTg0ZjJmZGM0MDExYjQyY2VjMDY1ZTYxMmFiNiA9ICQoYDxkaXYgaWQ9Imh0bWxfMmVmNjk4NGYyZmRjNDAxMWI0MmNlYzA2NWU2MTJhYjYiIHN0eWxlPSJ3aWR0aDogMTAwLjAlOyBoZWlnaHQ6IDEwMC4wJTsiPk5hbWU6IFNPVVRIIEJPVUxERVIgQ1JFRUsgRElWRVJTSU9OIE5FQVIgRUxET1JBRE8gU1BSSU5HUyBQcmVjaXA6IDkzLjcwPC9kaXY+YClbMF07CiAgICAgICAgICAgIHBvcHVwXzU2MzQ3ZmFhNzEyNjQ1YzE5ZGExZmI3NmU3MmNmMGQ0LnNldENvbnRlbnQoaHRtbF8yZWY2OTg0ZjJmZGM0MDExYjQyY2VjMDY1ZTYxMmFiNik7CiAgICAgICAgCgogICAgICAgIG1hcmtlcl80ZGVjN2I5ZTgwYzQ0MzIwOGU3ODhlODY1YzkwMDU3MC5iaW5kUG9wdXAocG9wdXBfNTYzNDdmYWE3MTI2NDVjMTlkYTFmYjc2ZTcyY2YwZDQpCiAgICAgICAgOwoKICAgICAgICAKICAgIAogICAgCiAgICAgICAgICAgIHZhciBtYXJrZXJfOTE2NjYyNzI0MGU1NDhlNDg5ZjgyODc4OTFmZTAwZWUgPSBMLm1hcmtlcigKICAgICAgICAgICAgICAgIFs0MC4xODc1NzgsIC0xMDUuMTg5MTkxXSwKICAgICAgICAgICAgICAgIHt9CiAgICAgICAgICAgICkuYWRkVG8obWFya2VyX2NsdXN0ZXJfYTVlMTExNzdjMzhiNDQwYTk0MTVjYWZhMWY4Mjg5ZTIpOwogICAgICAgIAogICAgCiAgICAgICAgdmFyIHBvcHVwXzQ4MDZiNmYyZjZkMDRkZDdiYTQzM2ZkZjc5NjliMGEyID0gTC5wb3B1cCh7Im1heFdpZHRoIjogIjEwMCUifSk7CgogICAgICAgIAogICAgICAgICAgICB2YXIgaHRtbF9iMGU2NzlmZTM4NTk0ZGM1YTA5ODg2ZDQxNTdhYzczNCA9ICQoYDxkaXYgaWQ9Imh0bWxfYjBlNjc5ZmUzODU5NGRjNWEwOTg4NmQ0MTU3YWM3MzQiIHN0eWxlPSJ3aWR0aDogMTAwLjAlOyBoZWlnaHQ6IDEwMC4wJTsiPk5hbWU6IERFTklPIFRBWUxPUiBESVRDSCBQcmVjaXA6IDIuODM8L2Rpdj5gKVswXTsKICAgICAgICAgICAgcG9wdXBfNDgwNmI2ZjJmNmQwNGRkN2JhNDMzZmRmNzk2OWIwYTIuc2V0Q29udGVudChodG1sX2IwZTY3OWZlMzg1OTRkYzVhMDk4ODZkNDE1N2FjNzM0KTsKICAgICAgICAKCiAgICAgICAgbWFya2VyXzkxNjY2MjcyNDBlNTQ4ZTQ4OWY4Mjg3ODkxZmUwMGVlLmJpbmRQb3B1cChwb3B1cF80ODA2YjZmMmY2ZDA0ZGQ3YmE0MzNmZGY3OTY5YjBhMikKICAgICAgICA7CgogICAgICAgIAogICAgCiAgICAKICAgICAgICAgICAgdmFyIG1hcmtlcl8xOGY3ODRjNTM4N2I0YzA0ODU5MTFhZmY1MjhlYTI2ZCA9IEwubWFya2VyKAogICAgICAgICAgICAgICAgWzQwLjI2MDgyNywgLTEwNS4xOTg1NjddLAogICAgICAgICAgICAgICAge30KICAgICAgICAgICAgKS5hZGRUbyhtYXJrZXJfY2x1c3Rlcl9hNWUxMTE3N2MzOGI0NDBhOTQxNWNhZmExZjgyODllMik7CiAgICAgICAgCiAgICAKICAgICAgICB2YXIgcG9wdXBfMjU1NTdjNzQ1ZjVkNGZkM2E5OWY3MmIwZjY3NzQxZjYgPSBMLnBvcHVwKHsibWF4V2lkdGgiOiAiMTAwJSJ9KTsKCiAgICAgICAgCiAgICAgICAgICAgIHZhciBodG1sX2Q1NDY1MGZmZmI5MzQxOThiNGQ0MDE3YzZjZWU5NWQzID0gJChgPGRpdiBpZD0iaHRtbF9kNTQ2NTBmZmZiOTM0MTk4YjRkNDAxN2M2Y2VlOTVkMyIgc3R5bGU9IndpZHRoOiAxMDAuMCU7IGhlaWdodDogMTAwLjAlOyI+TmFtZTogQ1VMVkVSIERJVENIIFByZWNpcDogMC4wMDwvZGl2PmApWzBdOwogICAgICAgICAgICBwb3B1cF8yNTU1N2M3NDVmNWQ0ZmQzYTk5ZjcyYjBmNjc3NDFmNi5zZXRDb250ZW50KGh0bWxfZDU0NjUwZmZmYjkzNDE5OGI0ZDQwMTdjNmNlZTk1ZDMpOwogICAgICAgIAoKICAgICAgICBtYXJrZXJfMThmNzg0YzUzODdiNGMwNDg1OTExYWZmNTI4ZWEyNmQuYmluZFBvcHVwKHBvcHVwXzI1NTU3Yzc0NWY1ZDRmZDNhOTlmNzJiMGY2Nzc0MWY2KQogICAgICAgIDsKCiAgICAgICAgCiAgICAKICAgIAogICAgICAgICAgICB2YXIgbWFya2VyXzVkYWE5OWQ3ZjQxYTQxM2ZhZDZiOGFlYjc1YTgzMTU5ID0gTC5tYXJrZXIoCiAgICAgICAgICAgICAgICBbNDAuMTUzMzYzLCAtMTA1LjA4ODY5NV0sCiAgICAgICAgICAgICAgICB7fQogICAgICAgICAgICApLmFkZFRvKG1hcmtlcl9jbHVzdGVyX2E1ZTExMTc3YzM4YjQ0MGE5NDE1Y2FmYTFmODI4OWUyKTsKICAgICAgICAKICAgIAogICAgICAgIHZhciBwb3B1cF82ZDIyMjVhYzM3N2U0MWMzYjJjNmZmNjgzZTUwMDhlYSA9IEwucG9wdXAoeyJtYXhXaWR0aCI6ICIxMDAlIn0pOwoKICAgICAgICAKICAgICAgICAgICAgdmFyIGh0bWxfZTE5ZGY2NzBmMGFlNGNhNzkyYWQ1YjdiM2ZmNGM1MTYgPSAkKGA8ZGl2IGlkPSJodG1sX2UxOWRmNjcwZjBhZTRjYTc5MmFkNWI3YjNmZjRjNTE2IiBzdHlsZT0id2lkdGg6IDEwMC4wJTsgaGVpZ2h0OiAxMDAuMCU7Ij5OYW1lOiBCT05VUyBESVRDSCBQcmVjaXA6IDguMTE8L2Rpdj5gKVswXTsKICAgICAgICAgICAgcG9wdXBfNmQyMjI1YWMzNzdlNDFjM2IyYzZmZjY4M2U1MDA4ZWEuc2V0Q29udGVudChodG1sX2UxOWRmNjcwZjBhZTRjYTc5MmFkNWI3YjNmZjRjNTE2KTsKICAgICAgICAKCiAgICAgICAgbWFya2VyXzVkYWE5OWQ3ZjQxYTQxM2ZhZDZiOGFlYjc1YTgzMTU5LmJpbmRQb3B1cChwb3B1cF82ZDIyMjVhYzM3N2U0MWMzYjJjNmZmNjgzZTUwMDhlYSkKICAgICAgICA7CgogICAgICAgIAogICAgCiAgICAKICAgICAgICAgICAgdmFyIG1hcmtlcl9iNGIxNWNkNmJhZGU0NGFhYWRmOTI1YWMyZjAwN2QzYiA9IEwubWFya2VyKAogICAgICAgICAgICAgICAgWzQwLjE3Mzk1LCAtMTA1LjE2OTM3NF0sCiAgICAgICAgICAgICAgICB7fQogICAgICAgICAgICApLmFkZFRvKG1hcmtlcl9jbHVzdGVyX2E1ZTExMTc3YzM4YjQ0MGE5NDE1Y2FmYTFmODI4OWUyKTsKICAgICAgICAKICAgIAogICAgICAgIHZhciBwb3B1cF83OWNmNzdlMmViNjU0ZDM1YjJjOTZiMTIzODcxN2RlOSA9IEwucG9wdXAoeyJtYXhXaWR0aCI6ICIxMDAlIn0pOwoKICAgICAgICAKICAgICAgICAgICAgdmFyIGh0bWxfZWQ0OTY4MjM2YzVkNDhhMWIzZTMxZWNhM2FjYWQzMGQgPSAkKGA8ZGl2IGlkPSJodG1sX2VkNDk2ODIzNmM1ZDQ4YTFiM2UzMWVjYTNhY2FkMzBkIiBzdHlsZT0id2lkdGg6IDEwMC4wJTsgaGVpZ2h0OiAxMDAuMCU7Ij5OYW1lOiBOSVdPVCBESVRDSCBQcmVjaXA6IDUuMjM8L2Rpdj5gKVswXTsKICAgICAgICAgICAgcG9wdXBfNzljZjc3ZTJlYjY1NGQzNWIyYzk2YjEyMzg3MTdkZTkuc2V0Q29udGVudChodG1sX2VkNDk2ODIzNmM1ZDQ4YTFiM2UzMWVjYTNhY2FkMzBkKTsKICAgICAgICAKCiAgICAgICAgbWFya2VyX2I0YjE1Y2Q2YmFkZTQ0YWFhZGY5MjVhYzJmMDA3ZDNiLmJpbmRQb3B1cChwb3B1cF83OWNmNzdlMmViNjU0ZDM1YjJjOTZiMTIzODcxN2RlOSkKICAgICAgICA7CgogICAgICAgIAogICAgCiAgICAKICAgICAgICAgICAgdmFyIG1hcmtlcl9lYzk4MTE5ZDJlOGE0YzdiYmJkOTM0YWQ3Nzc2YmE1YiA9IEwubWFya2VyKAogICAgICAgICAgICAgICAgWzQwLjA4NjI3OCwgLTEwNS4yMTc1MTldLAogICAgICAgICAgICAgICAge30KICAgICAgICAgICAgKS5hZGRUbyhtYXJrZXJfY2x1c3Rlcl9hNWUxMTE3N2MzOGI0NDBhOTQxNWNhZmExZjgyODllMik7CiAgICAgICAgCiAgICAKICAgICAgICB2YXIgcG9wdXBfMWI4N2RhODQ2OWQ0NDFjNjg0ZDdhMzQ2NjU2NGRhZWEgPSBMLnBvcHVwKHsibWF4V2lkdGgiOiAiMTAwJSJ9KTsKCiAgICAgICAgCiAgICAgICAgICAgIHZhciBodG1sXzQ1NWI0NDAwZTY4ZjRlY2M5NjM5NzlhNzdhOTY3NTcyID0gJChgPGRpdiBpZD0iaHRtbF80NTViNDQwMGU2OGY0ZWNjOTYzOTc5YTc3YTk2NzU3MiIgc3R5bGU9IndpZHRoOiAxMDAuMCU7IGhlaWdodDogMTAwLjAlOyI+TmFtZTogQk9VTERFUiBSRVNFUlZPSVIgSU5MRVQgUHJlY2lwOiAyMC4wMDwvZGl2PmApWzBdOwogICAgICAgICAgICBwb3B1cF8xYjg3ZGE4NDY5ZDQ0MWM2ODRkN2EzNDY2NTY0ZGFlYS5zZXRDb250ZW50KGh0bWxfNDU1YjQ0MDBlNjhmNGVjYzk2Mzk3OWE3N2E5Njc1NzIpOwogICAgICAgIAoKICAgICAgICBtYXJrZXJfZWM5ODExOWQyZThhNGM3YmJiZDkzNGFkNzc3NmJhNWIuYmluZFBvcHVwKHBvcHVwXzFiODdkYTg0NjlkNDQxYzY4NGQ3YTM0NjY1NjRkYWVhKQogICAgICAgIDsKCiAgICAgICAgCiAgICAKICAgIAogICAgICAgICAgICB2YXIgbWFya2VyX2NhNDBjM2Y2M2I1ZjQxMjhiNWJlYTAwZTY3NjYxNzJlID0gTC5tYXJrZXIoCiAgICAgICAgICAgICAgICBbNDAuMTkzMDE5LCAtMTA1LjIxMDM4OF0sCiAgICAgICAgICAgICAgICB7fQogICAgICAgICAgICApLmFkZFRvKG1hcmtlcl9jbHVzdGVyX2E1ZTExMTc3YzM4YjQ0MGE5NDE1Y2FmYTFmODI4OWUyKTsKICAgICAgICAKICAgIAogICAgICAgIHZhciBwb3B1cF8xZTcwN2UzMGQ4Yzc0YjE0ODFiMjgwM2UyNDc1NDliZSA9IEwucG9wdXAoeyJtYXhXaWR0aCI6ICIxMDAlIn0pOwoKICAgICAgICAKICAgICAgICAgICAgdmFyIGh0bWxfMTE3YmY5MmMwMTQ4NGIzNDllZTNmMWY4MDY0NmU2NTIgPSAkKGA8ZGl2IGlkPSJodG1sXzExN2JmOTJjMDE0ODRiMzQ5ZWUzZjFmODA2NDZlNjUyIiBzdHlsZT0id2lkdGg6IDEwMC4wJTsgaGVpZ2h0OiAxMDAuMCU7Ij5OYW1lOiBUUlVFIEFORCBXRUJTVEVSIERJVENIIFByZWNpcDogNC44ODwvZGl2PmApWzBdOwogICAgICAgICAgICBwb3B1cF8xZTcwN2UzMGQ4Yzc0YjE0ODFiMjgwM2UyNDc1NDliZS5zZXRDb250ZW50KGh0bWxfMTE3YmY5MmMwMTQ4NGIzNDllZTNmMWY4MDY0NmU2NTIpOwogICAgICAgIAoKICAgICAgICBtYXJrZXJfY2E0MGMzZjYzYjVmNDEyOGI1YmVhMDBlNjc2NjE3MmUuYmluZFBvcHVwKHBvcHVwXzFlNzA3ZTMwZDhjNzRiMTQ4MWIyODAzZTI0NzU0OWJlKQogICAgICAgIDsKCiAgICAgICAgCiAgICAKICAgIAogICAgICAgICAgICB2YXIgbWFya2VyXzEyYzE2YTg2ZjA4NjQ5ZjE4MGM2YzE3MjFmMTBhMTFiID0gTC5tYXJrZXIoCiAgICAgICAgICAgICAgICBbNDAuMDkwODIsIC0xMDUuNTE0NDQyXSwKICAgICAgICAgICAgICAgIHt9CiAgICAgICAgICAgICkuYWRkVG8obWFya2VyX2NsdXN0ZXJfYTVlMTExNzdjMzhiNDQwYTk0MTVjYWZhMWY4Mjg5ZTIpOwogICAgICAgIAogICAgCiAgICAgICAgdmFyIHBvcHVwXzRjZjk0YTMzZThkNDQ4NzFiOWNlNWE2NzcxZTA0YjZhID0gTC5wb3B1cCh7Im1heFdpZHRoIjogIjEwMCUifSk7CgogICAgICAgIAogICAgICAgICAgICB2YXIgaHRtbF8xODM2NGY4ZWQwZGQ0ZDNjOTY3OGI2NWY1MmYwZmQzNiA9ICQoYDxkaXYgaWQ9Imh0bWxfMTgzNjRmOGVkMGRkNGQzYzk2NzhiNjVmNTJmMGZkMzYiIHN0eWxlPSJ3aWR0aDogMTAwLjAlOyBoZWlnaHQ6IDEwMC4wJTsiPk5hbWU6IFNPVVRIIFNBSU5UIFZSQUlOIE5FQVIgV0FSRCBQcmVjaXA6IDI2LjcwPC9kaXY+YClbMF07CiAgICAgICAgICAgIHBvcHVwXzRjZjk0YTMzZThkNDQ4NzFiOWNlNWE2NzcxZTA0YjZhLnNldENvbnRlbnQoaHRtbF8xODM2NGY4ZWQwZGQ0ZDNjOTY3OGI2NWY1MmYwZmQzNik7CiAgICAgICAgCgogICAgICAgIG1hcmtlcl8xMmMxNmE4NmYwODY0OWYxODBjNmMxNzIxZjEwYTExYi5iaW5kUG9wdXAocG9wdXBfNGNmOTRhMzNlOGQ0NDg3MWI5Y2U1YTY3NzFlMDRiNmEpCiAgICAgICAgOwoKICAgICAgICAKICAgIAogICAgCiAgICAgICAgICAgIHZhciBtYXJrZXJfN2FkMTcwYjJiMGVmNGRiY2FkODM5Mzg3NWVhYjk2MWEgPSBMLm1hcmtlcigKICAgICAgICAgICAgICAgIFs0MC4xODE4OCwgLTEwNS4xOTY3NzVdLAogICAgICAgICAgICAgICAge30KICAgICAgICAgICAgKS5hZGRUbyhtYXJrZXJfY2x1c3Rlcl9hNWUxMTE3N2MzOGI0NDBhOTQxNWNhZmExZjgyODllMik7CiAgICAgICAgCiAgICAKICAgICAgICB2YXIgcG9wdXBfNWRkMWEyNWI3MTc0NDg1NDg2ZjIzNTMyMTcxN2EyN2QgPSBMLnBvcHVwKHsibWF4V2lkdGgiOiAiMTAwJSJ9KTsKCiAgICAgICAgCiAgICAgICAgICAgIHZhciBodG1sXzkyNTk3OGNlMjhhYTQ5ZDY4OTE4N2Q1YjEzNmQ5MTQ5ID0gJChgPGRpdiBpZD0iaHRtbF85MjU5NzhjZTI4YWE0OWQ2ODkxODdkNWIxMzZkOTE0OSIgc3R5bGU9IndpZHRoOiAxMDAuMCU7IGhlaWdodDogMTAwLjAlOyI+TmFtZTogREFWSVMgQU5EIERPV05JTkcgRElUQ0ggUHJlY2lwOiA1LjE5PC9kaXY+YClbMF07CiAgICAgICAgICAgIHBvcHVwXzVkZDFhMjViNzE3NDQ4NTQ4NmYyMzUzMjE3MTdhMjdkLnNldENvbnRlbnQoaHRtbF85MjU5NzhjZTI4YWE0OWQ2ODkxODdkNWIxMzZkOTE0OSk7CiAgICAgICAgCgogICAgICAgIG1hcmtlcl83YWQxNzBiMmIwZWY0ZGJjYWQ4MzkzODc1ZWFiOTYxYS5iaW5kUG9wdXAocG9wdXBfNWRkMWEyNWI3MTc0NDg1NDg2ZjIzNTMyMTcxN2EyN2QpCiAgICAgICAgOwoKICAgICAgICAKICAgIAogICAgCiAgICAgICAgICAgIHZhciBtYXJrZXJfNzAwNGJkYjEyODcwNGVlMWFjNmQyYjUxZDZiOTRhNmIgPSBMLm1hcmtlcigKICAgICAgICAgICAgICAgIFszOS45MzE1OTcsIC0xMDUuMzA0OTldLAogICAgICAgICAgICAgICAge30KICAgICAgICAgICAgKS5hZGRUbyhtYXJrZXJfY2x1c3Rlcl9hNWUxMTE3N2MzOGI0NDBhOTQxNWNhZmExZjgyODllMik7CiAgICAgICAgCiAgICAKICAgICAgICB2YXIgcG9wdXBfZGQ3YzRhMmY5ODhjNDkxMGI1MWMyYzA0YWZjZDgyMzUgPSBMLnBvcHVwKHsibWF4V2lkdGgiOiAiMTAwJSJ9KTsKCiAgICAgICAgCiAgICAgICAgICAgIHZhciBodG1sX2IxZjRiOGFmODE1OTQ2YTFhZTMyZTYyMDRhN2FlNTEzID0gJChgPGRpdiBpZD0iaHRtbF9iMWY0YjhhZjgxNTk0NmExYWUzMmU2MjA0YTdhZTUxMyIgc3R5bGU9IndpZHRoOiAxMDAuMCU7IGhlaWdodDogMTAwLjAlOyI+TmFtZTogU09VVEggQk9VTERFUiBDUkVFSyBORUFSIEVMRE9SQURPIFNQUklOR1MsIENPLiBQcmVjaXA6IDI1LjUwPC9kaXY+YClbMF07CiAgICAgICAgICAgIHBvcHVwX2RkN2M0YTJmOTg4YzQ5MTBiNTFjMmMwNGFmY2Q4MjM1LnNldENvbnRlbnQoaHRtbF9iMWY0YjhhZjgxNTk0NmExYWUzMmU2MjA0YTdhZTUxMyk7CiAgICAgICAgCgogICAgICAgIG1hcmtlcl83MDA0YmRiMTI4NzA0ZWUxYWM2ZDJiNTFkNmI5NGE2Yi5iaW5kUG9wdXAocG9wdXBfZGQ3YzRhMmY5ODhjNDkxMGI1MWMyYzA0YWZjZDgyMzUpCiAgICAgICAgOwoKICAgICAgICAKICAgIAogICAgCiAgICAgICAgICAgIHZhciBtYXJrZXJfMzNiYjllNGEwOGRjNGIyZGJiZTYzNzRlMmQwNTA0Y2IgPSBMLm1hcmtlcigKICAgICAgICAgICAgICAgIFs0MC4wNzg1NiwgLTEwNS4yMjA0OTddLAogICAgICAgICAgICAgICAge30KICAgICAgICAgICAgKS5hZGRUbyhtYXJrZXJfY2x1c3Rlcl9hNWUxMTE3N2MzOGI0NDBhOTQxNWNhZmExZjgyODllMik7CiAgICAgICAgCiAgICAKICAgICAgICB2YXIgcG9wdXBfZGQyMjVkYzJlZGFmNDg5ZDgyNzMzMzAwNGViOTU0MTUgPSBMLnBvcHVwKHsibWF4V2lkdGgiOiAiMTAwJSJ9KTsKCiAgICAgICAgCiAgICAgICAgICAgIHZhciBodG1sXzcxNjhlMDdkZjA5NTRlMjc5OTNjZDMyMTI5ZGExZjU2ID0gJChgPGRpdiBpZD0iaHRtbF83MTY4ZTA3ZGYwOTU0ZTI3OTkzY2QzMjEyOWRhMWY1NiIgc3R5bGU9IndpZHRoOiAxMDAuMCU7IGhlaWdodDogMTAwLjAlOyI+TmFtZTogQk9VTERFUiBSRVNFUlZPSVIgUHJlY2lwOiA4OTQyLjAwPC9kaXY+YClbMF07CiAgICAgICAgICAgIHBvcHVwX2RkMjI1ZGMyZWRhZjQ4OWQ4MjczMzMwMDRlYjk1NDE1LnNldENvbnRlbnQoaHRtbF83MTY4ZTA3ZGYwOTU0ZTI3OTkzY2QzMjEyOWRhMWY1Nik7CiAgICAgICAgCgogICAgICAgIG1hcmtlcl8zM2JiOWU0YTA4ZGM0YjJkYmJlNjM3NGUyZDA1MDRjYi5iaW5kUG9wdXAocG9wdXBfZGQyMjVkYzJlZGFmNDg5ZDgyNzMzMzAwNGViOTU0MTUpCiAgICAgICAgOwoKICAgICAgICAKICAgIAogICAgCiAgICAgICAgICAgIHZhciBtYXJrZXJfOTAzYmM5ZjJjMjY3NDFhMmI4NmEwMDE4MzcxOTVjY2YgPSBMLm1hcmtlcigKICAgICAgICAgICAgICAgIFs0MC4yMTI1MDUsIC0xMDUuMjUxODI2XSwKICAgICAgICAgICAgICAgIHt9CiAgICAgICAgICAgICkuYWRkVG8obWFya2VyX2NsdXN0ZXJfYTVlMTExNzdjMzhiNDQwYTk0MTVjYWZhMWY4Mjg5ZTIpOwogICAgICAgIAogICAgCiAgICAgICAgdmFyIHBvcHVwX2Y1MTVmNzI5NGRkYTQ4OGM5MDdkMmI5MGQwYWEwOWU5ID0gTC5wb3B1cCh7Im1heFdpZHRoIjogIjEwMCUifSk7CgogICAgICAgIAogICAgICAgICAgICB2YXIgaHRtbF82ZGYwODNhYWNlYjM0ZDBhYTY1ZWEwNjE3MWRlYjQ0MyA9ICQoYDxkaXYgaWQ9Imh0bWxfNmRmMDgzYWFjZWIzNGQwYWE2NWVhMDYxNzFkZWI0NDMiIHN0eWxlPSJ3aWR0aDogMTAwLjAlOyBoZWlnaHQ6IDEwMC4wJTsiPk5hbWU6IFBBTE1FUlRPTiBESVRDSCBQcmVjaXA6IDIwLjIwPC9kaXY+YClbMF07CiAgICAgICAgICAgIHBvcHVwX2Y1MTVmNzI5NGRkYTQ4OGM5MDdkMmI5MGQwYWEwOWU5LnNldENvbnRlbnQoaHRtbF82ZGYwODNhYWNlYjM0ZDBhYTY1ZWEwNjE3MWRlYjQ0Myk7CiAgICAgICAgCgogICAgICAgIG1hcmtlcl85MDNiYzlmMmMyNjc0MWEyYjg2YTAwMTgzNzE5NWNjZi5iaW5kUG9wdXAocG9wdXBfZjUxNWY3Mjk0ZGRhNDg4YzkwN2QyYjkwZDBhYTA5ZTkpCiAgICAgICAgOwoKICAgICAgICAKICAgIAogICAgCiAgICAgICAgICAgIHZhciBtYXJrZXJfMjI2MmM0Mjg4NjM4NGI2ZmFhNDI3ZWEzMzBiOTcxMjUgPSBMLm1hcmtlcigKICAgICAgICAgICAgICAgIFs0MC4xMjk4MDYsIC0xMDUuNTE3MTExXSwKICAgICAgICAgICAgICAgIHt9CiAgICAgICAgICAgICkuYWRkVG8obWFya2VyX2NsdXN0ZXJfYTVlMTExNzdjMzhiNDQwYTk0MTVjYWZhMWY4Mjg5ZTIpOwogICAgICAgIAogICAgCiAgICAgICAgdmFyIHBvcHVwXzg5MDBiNzBmMDA1YjRhMTU5NzM3YzgyYjAzYzk5YzdjID0gTC5wb3B1cCh7Im1heFdpZHRoIjogIjEwMCUifSk7CgogICAgICAgIAogICAgICAgICAgICB2YXIgaHRtbF9lNzJhMDFmNDliNTA0YzNlYmU1ZTE0MDkyNTNiMGNiZSA9ICQoYDxkaXYgaWQ9Imh0bWxfZTcyYTAxZjQ5YjUwNGMzZWJlNWUxNDA5MjUzYjBjYmUiIHN0eWxlPSJ3aWR0aDogMTAwLjAlOyBoZWlnaHQ6IDEwMC4wJTsiPk5hbWU6IE1JRERMRSBTQUlOVCBWUkFJTiBBVCBQRUFDRUZVTCBWQUxMRVkgUHJlY2lwOiAyNS4wMDwvZGl2PmApWzBdOwogICAgICAgICAgICBwb3B1cF84OTAwYjcwZjAwNWI0YTE1OTczN2M4MmIwM2M5OWM3Yy5zZXRDb250ZW50KGh0bWxfZTcyYTAxZjQ5YjUwNGMzZWJlNWUxNDA5MjUzYjBjYmUpOwogICAgICAgIAoKICAgICAgICBtYXJrZXJfMjI2MmM0Mjg4NjM4NGI2ZmFhNDI3ZWEzMzBiOTcxMjUuYmluZFBvcHVwKHBvcHVwXzg5MDBiNzBmMDA1YjRhMTU5NzM3YzgyYjAzYzk5YzdjKQogICAgICAgIDsKCiAgICAgICAgCiAgICAKICAgIAogICAgICAgICAgICB2YXIgbWFya2VyXzJhNTJmZDNlMDAyZjQwNjJiYzM2ZGMzMTg2Y2FiYTgxID0gTC5tYXJrZXIoCiAgICAgICAgICAgICAgICBbMzkuOTQ3NzA0LCAtMTA1LjM1NzMwOF0sCiAgICAgICAgICAgICAgICB7fQogICAgICAgICAgICApLmFkZFRvKG1hcmtlcl9jbHVzdGVyX2E1ZTExMTc3YzM4YjQ0MGE5NDE1Y2FmYTFmODI4OWUyKTsKICAgICAgICAKICAgIAogICAgICAgIHZhciBwb3B1cF8zNTMyYTJkODE1MDY0MTc1ODdjMjk2OTAzZThmMzFjOSA9IEwucG9wdXAoeyJtYXhXaWR0aCI6ICIxMDAlIn0pOwoKICAgICAgICAKICAgICAgICAgICAgdmFyIGh0bWxfM2QxYTViNjJiMGEyNDFkZTk5MDBiMDBjNjc2M2ZkYjIgPSAkKGA8ZGl2IGlkPSJodG1sXzNkMWE1YjYyYjBhMjQxZGU5OTAwYjAwYzY3NjNmZGIyIiBzdHlsZT0id2lkdGg6IDEwMC4wJTsgaGVpZ2h0OiAxMDAuMCU7Ij5OYW1lOiBHUk9TUyBSRVNFUlZPSVIgIFByZWNpcDogNDE0NjEuMDA8L2Rpdj5gKVswXTsKICAgICAgICAgICAgcG9wdXBfMzUzMmEyZDgxNTA2NDE3NTg3YzI5NjkwM2U4ZjMxYzkuc2V0Q29udGVudChodG1sXzNkMWE1YjYyYjBhMjQxZGU5OTAwYjAwYzY3NjNmZGIyKTsKICAgICAgICAKCiAgICAgICAgbWFya2VyXzJhNTJmZDNlMDAyZjQwNjJiYzM2ZGMzMTg2Y2FiYTgxLmJpbmRQb3B1cChwb3B1cF8zNTMyYTJkODE1MDY0MTc1ODdjMjk2OTAzZThmMzFjOSkKICAgICAgICA7CgogICAgICAgIAogICAgCiAgICAKICAgICAgICAgICAgdmFyIG1hcmtlcl81YTBjNDg4MjEzMjQ0YTJhOGM4NWMyNjhhNDI1Nzk4ZCA9IEwubWFya2VyKAogICAgICAgICAgICAgICAgWzQwLjE1MzM0MSwgLTEwNS4wNzU2OTVdLAogICAgICAgICAgICAgICAge30KICAgICAgICAgICAgKS5hZGRUbyhtYXJrZXJfY2x1c3Rlcl9hNWUxMTE3N2MzOGI0NDBhOTQxNWNhZmExZjgyODllMik7CiAgICAgICAgCiAgICAKICAgICAgICB2YXIgcG9wdXBfODQ4OWIxZThmZjVhNDAzMTliOWZhMzQ4NDAzM2NlZDcgPSBMLnBvcHVwKHsibWF4V2lkdGgiOiAiMTAwJSJ9KTsKCiAgICAgICAgCiAgICAgICAgICAgIHZhciBodG1sX2Y1Y2FlMjQ5MGExMzQzZWJiYzA3ZmM1YTcxNTIzNjZhID0gJChgPGRpdiBpZD0iaHRtbF9mNWNhZTI0OTBhMTM0M2ViYmMwN2ZjNWE3MTUyMzY2YSIgc3R5bGU9IndpZHRoOiAxMDAuMCU7IGhlaWdodDogMTAwLjAlOyI+TmFtZTogU0FJTlQgVlJBSU4gQ1JFRUsgQkVMT1cgS0VOIFBSQVRUIEJMVkQgQVQgTE9OR01PTlQsIENPIFByZWNpcDogNTcuNTA8L2Rpdj5gKVswXTsKICAgICAgICAgICAgcG9wdXBfODQ4OWIxZThmZjVhNDAzMTliOWZhMzQ4NDAzM2NlZDcuc2V0Q29udGVudChodG1sX2Y1Y2FlMjQ5MGExMzQzZWJiYzA3ZmM1YTcxNTIzNjZhKTsKICAgICAgICAKCiAgICAgICAgbWFya2VyXzVhMGM0ODgyMTMyNDRhMmE4Yzg1YzI2OGE0MjU3OThkLmJpbmRQb3B1cChwb3B1cF84NDg5YjFlOGZmNWE0MDMxOWI5ZmEzNDg0MDMzY2VkNykKICAgICAgICA7CgogICAgICAgIAogICAgCiAgICAKICAgICAgICAgICAgdmFyIG1hcmtlcl8wMTkyYjA5MTJiMGE0Mzg4OTAwZGEyMGE0NjdjMGVhOSA9IEwubWFya2VyKAogICAgICAgICAgICAgICAgWzQwLjA1OTgwOSwgLTEwNS4wOTc4NzJdLAogICAgICAgICAgICAgICAge30KICAgICAgICAgICAgKS5hZGRUbyhtYXJrZXJfY2x1c3Rlcl9hNWUxMTE3N2MzOGI0NDBhOTQxNWNhZmExZjgyODllMik7CiAgICAgICAgCiAgICAKICAgICAgICB2YXIgcG9wdXBfYjg1OTRiMWQzMzJhNGMxZjg2OWEwN2I4ZDBhZTEyNGEgPSBMLnBvcHVwKHsibWF4V2lkdGgiOiAiMTAwJSJ9KTsKCiAgICAgICAgCiAgICAgICAgICAgIHZhciBodG1sXzkyMDE1NDc3YzY3NTQwNmI4MTQzYmZiZDViM2MzOWY3ID0gJChgPGRpdiBpZD0iaHRtbF85MjAxNTQ3N2M2NzU0MDZiODE0M2JmYmQ1YjNjMzlmNyIgc3R5bGU9IndpZHRoOiAxMDAuMCU7IGhlaWdodDogMTAwLjAlOyI+TmFtZTogQk9VTERFUiBDUkVFSyBBVCAxMDkgU1QgTkVBUiBFUklFLCBDTyBQcmVjaXA6IDguOTE8L2Rpdj5gKVswXTsKICAgICAgICAgICAgcG9wdXBfYjg1OTRiMWQzMzJhNGMxZjg2OWEwN2I4ZDBhZTEyNGEuc2V0Q29udGVudChodG1sXzkyMDE1NDc3YzY3NTQwNmI4MTQzYmZiZDViM2MzOWY3KTsKICAgICAgICAKCiAgICAgICAgbWFya2VyXzAxOTJiMDkxMmIwYTQzODg5MDBkYTIwYTQ2N2MwZWE5LmJpbmRQb3B1cChwb3B1cF9iODU5NGIxZDMzMmE0YzFmODY5YTA3YjhkMGFlMTI0YSkKICAgICAgICA7CgogICAgICAgIAogICAgCiAgICAKICAgICAgICAgICAgdmFyIG1hcmtlcl9hZmEyMGZjMzdhODE0ZTNhYWMxYmMyNDFlYzNkN2E3MSA9IEwubWFya2VyKAogICAgICAgICAgICAgICAgWzQwLjI1ODM2NywgLTEwNS4xNzQ5NTddLAogICAgICAgICAgICAgICAge30KICAgICAgICAgICAgKS5hZGRUbyhtYXJrZXJfY2x1c3Rlcl9hNWUxMTE3N2MzOGI0NDBhOTQxNWNhZmExZjgyODllMik7CiAgICAgICAgCiAgICAKICAgICAgICB2YXIgcG9wdXBfNjA3YzhjOTYxOTA2NGRlYWI0ZGYwYTJkZjNhNzg0YTggPSBMLnBvcHVwKHsibWF4V2lkdGgiOiAiMTAwJSJ9KTsKCiAgICAgICAgCiAgICAgICAgICAgIHZhciBodG1sXzQ5OTdhMjE3ODQxZTRmYzBhYjRlMjNmMTQxN2Q4NmFlID0gJChgPGRpdiBpZD0iaHRtbF80OTk3YTIxNzg0MWU0ZmMwYWI0ZTIzZjE0MTdkODZhZSIgc3R5bGU9IndpZHRoOiAxMDAuMCU7IGhlaWdodDogMTAwLjAlOyI+TmFtZTogQk9VTERFUi1MQVJJTUVSIERJVENIIE5FQVIgQkVSVEhPVUQgUHJlY2lwOiAwLjAwPC9kaXY+YClbMF07CiAgICAgICAgICAgIHBvcHVwXzYwN2M4Yzk2MTkwNjRkZWFiNGRmMGEyZGYzYTc4NGE4LnNldENvbnRlbnQoaHRtbF80OTk3YTIxNzg0MWU0ZmMwYWI0ZTIzZjE0MTdkODZhZSk7CiAgICAgICAgCgogICAgICAgIG1hcmtlcl9hZmEyMGZjMzdhODE0ZTNhYWMxYmMyNDFlYzNkN2E3MS5iaW5kUG9wdXAocG9wdXBfNjA3YzhjOTYxOTA2NGRlYWI0ZGYwYTJkZjNhNzg0YTgpCiAgICAgICAgOwoKICAgICAgICAKICAgIAogICAgCiAgICAgICAgICAgIHZhciBtYXJrZXJfYjFiOTFjNmU4MDcwNDUxNDk4ZGVkODdjNmJhMzBiNTMgPSBMLm1hcmtlcigKICAgICAgICAgICAgICAgIFs0MC4xMzQyNzgsIC0xMDUuMTMwODE5XSwKICAgICAgICAgICAgICAgIHt9CiAgICAgICAgICAgICkuYWRkVG8obWFya2VyX2NsdXN0ZXJfYTVlMTExNzdjMzhiNDQwYTk0MTVjYWZhMWY4Mjg5ZTIpOwogICAgICAgIAogICAgCiAgICAgICAgdmFyIHBvcHVwXzY5M2RkZDJhMmE1ZDQ3YmI4NzkxMmRiNDJmZWYwYTBmID0gTC5wb3B1cCh7Im1heFdpZHRoIjogIjEwMCUifSk7CgogICAgICAgIAogICAgICAgICAgICB2YXIgaHRtbF8zNjI0ZDdjMzNhY2Y0OGFhOWUyZTE1NjYwODkwNjlkYiA9ICQoYDxkaXYgaWQ9Imh0bWxfMzYyNGQ3YzMzYWNmNDhhYTllMmUxNTY2MDg5MDY5ZGIiIHN0eWxlPSJ3aWR0aDogMTAwLjAlOyBoZWlnaHQ6IDEwMC4wJTsiPk5hbWU6IExFRlQgSEFORCBDUkVFSyBBVCBIT1ZFUiBST0FEIE5FQVIgTE9OR01PTlQsIENPIFByZWNpcDogMy43MTwvZGl2PmApWzBdOwogICAgICAgICAgICBwb3B1cF82OTNkZGQyYTJhNWQ0N2JiODc5MTJkYjQyZmVmMGEwZi5zZXRDb250ZW50KGh0bWxfMzYyNGQ3YzMzYWNmNDhhYTllMmUxNTY2MDg5MDY5ZGIpOwogICAgICAgIAoKICAgICAgICBtYXJrZXJfYjFiOTFjNmU4MDcwNDUxNDk4ZGVkODdjNmJhMzBiNTMuYmluZFBvcHVwKHBvcHVwXzY5M2RkZDJhMmE1ZDQ3YmI4NzkxMmRiNDJmZWYwYTBmKQogICAgICAgIDsKCiAgICAgICAgCiAgICAKICAgIAogICAgICAgICAgICB2YXIgbWFya2VyXzBhZTQxMjA3ODk5MzQzNTVhZjFhN2I3ZjI0Yzk4ZmJmID0gTC5tYXJrZXIoCiAgICAgICAgICAgICAgICBbNDAuMjU4MDM4LCAtMTA1LjIwNjM4Nl0sCiAgICAgICAgICAgICAgICB7fQogICAgICAgICAgICApLmFkZFRvKG1hcmtlcl9jbHVzdGVyX2E1ZTExMTc3YzM4YjQ0MGE5NDE1Y2FmYTFmODI4OWUyKTsKICAgICAgICAKICAgIAogICAgICAgIHZhciBwb3B1cF84NTFhZTEyMzg2OTU0N2ZmYTY2YzI1NzUyYTA1MjlmNSA9IEwucG9wdXAoeyJtYXhXaWR0aCI6ICIxMDAlIn0pOwoKICAgICAgICAKICAgICAgICAgICAgdmFyIGh0bWxfOTc1N2U0YzY4NmRhNDI4Zjk4NjNmMWEzN2EyNTE4NGUgPSAkKGA8ZGl2IGlkPSJodG1sXzk3NTdlNGM2ODZkYTQyOGY5ODYzZjFhMzdhMjUxODRlIiBzdHlsZT0id2lkdGg6IDEwMC4wJTsgaGVpZ2h0OiAxMDAuMCU7Ij5OYW1lOiBMSVRUTEUgVEhPTVBTT04gUklWRVIgQVQgQ0FOWU9OIE1PVVRIIE5FQVIgQkVSVEhPVUQgUHJlY2lwOiAxLjU2PC9kaXY+YClbMF07CiAgICAgICAgICAgIHBvcHVwXzg1MWFlMTIzODY5NTQ3ZmZhNjZjMjU3NTJhMDUyOWY1LnNldENvbnRlbnQoaHRtbF85NzU3ZTRjNjg2ZGE0MjhmOTg2M2YxYTM3YTI1MTg0ZSk7CiAgICAgICAgCgogICAgICAgIG1hcmtlcl8wYWU0MTIwNzg5OTM0MzU1YWYxYTdiN2YyNGM5OGZiZi5iaW5kUG9wdXAocG9wdXBfODUxYWUxMjM4Njk1NDdmZmE2NmMyNTc1MmEwNTI5ZjUpCiAgICAgICAgOwoKICAgICAgICAKICAgIAogICAgCiAgICAgICAgICAgIHZhciBtYXJrZXJfMjY3NWRjYjI2ZTUxNDYwYmJhNjc4MGY1ZWQ2MjY2MzEgPSBMLm1hcmtlcigKICAgICAgICAgICAgICAgIFs0MC4xMjYzODksIC0xMDUuMzA0NDA0XSwKICAgICAgICAgICAgICAgIHt9CiAgICAgICAgICAgICkuYWRkVG8obWFya2VyX2NsdXN0ZXJfYTVlMTExNzdjMzhiNDQwYTk0MTVjYWZhMWY4Mjg5ZTIpOwogICAgICAgIAogICAgCiAgICAgICAgdmFyIHBvcHVwX2Y1ZWU4NDMzNzIzNDRiMjliYWM1ZTkxMDZmZjNmY2U0ID0gTC5wb3B1cCh7Im1heFdpZHRoIjogIjEwMCUifSk7CgogICAgICAgIAogICAgICAgICAgICB2YXIgaHRtbF9jZjhjMzQ5MTk4ZjY0MDQ2YWExZDdmZDBkYTY4Y2E1OCA9ICQoYDxkaXYgaWQ9Imh0bWxfY2Y4YzM0OTE5OGY2NDA0NmFhMWQ3ZmQwZGE2OGNhNTgiIHN0eWxlPSJ3aWR0aDogMTAwLjAlOyBoZWlnaHQ6IDEwMC4wJTsiPk5hbWU6IExFRlQgSEFORCBDUkVFSyBORUFSIEJPVUxERVIsIENPLiBQcmVjaXA6IDI4LjkwPC9kaXY+YClbMF07CiAgICAgICAgICAgIHBvcHVwX2Y1ZWU4NDMzNzIzNDRiMjliYWM1ZTkxMDZmZjNmY2U0LnNldENvbnRlbnQoaHRtbF9jZjhjMzQ5MTk4ZjY0MDQ2YWExZDdmZDBkYTY4Y2E1OCk7CiAgICAgICAgCgogICAgICAgIG1hcmtlcl8yNjc1ZGNiMjZlNTE0NjBiYmE2NzgwZjVlZDYyNjYzMS5iaW5kUG9wdXAocG9wdXBfZjVlZTg0MzM3MjM0NGIyOWJhYzVlOTEwNmZmM2ZjZTQpCiAgICAgICAgOwoKICAgICAgICAKICAgIAogICAgCiAgICAgICAgICAgIHZhciBtYXJrZXJfZDliNjgxOTNkNWFjNDIxMmE1ZjdjM2NlNzNhZTE5ODYgPSBMLm1hcmtlcigKICAgICAgICAgICAgICAgIFs0MC4wMTg2NjcsIC0xMDUuMzI2MjVdLAogICAgICAgICAgICAgICAge30KICAgICAgICAgICAgKS5hZGRUbyhtYXJrZXJfY2x1c3Rlcl9hNWUxMTE3N2MzOGI0NDBhOTQxNWNhZmExZjgyODllMik7CiAgICAgICAgCiAgICAKICAgICAgICB2YXIgcG9wdXBfNzMxZTU5ODVmZGYwNDMyMjlhOWMwMzk2NjdlNWYzY2QgPSBMLnBvcHVwKHsibWF4V2lkdGgiOiAiMTAwJSJ9KTsKCiAgICAgICAgCiAgICAgICAgICAgIHZhciBodG1sX2QyZDE2MzNhOTEwODQwN2VhZDBiYzdjZDI1ZTMwMDNkID0gJChgPGRpdiBpZD0iaHRtbF9kMmQxNjMzYTkxMDg0MDdlYWQwYmM3Y2QyNWUzMDAzZCIgc3R5bGU9IndpZHRoOiAxMDAuMCU7IGhlaWdodDogMTAwLjAlOyI+TmFtZTogRk9VUk1JTEUgQ1JFRUsgQVQgT1JPREVMTCwgQ08gUHJlY2lwOiAwLjYzPC9kaXY+YClbMF07CiAgICAgICAgICAgIHBvcHVwXzczMWU1OTg1ZmRmMDQzMjI5YTljMDM5NjY3ZTVmM2NkLnNldENvbnRlbnQoaHRtbF9kMmQxNjMzYTkxMDg0MDdlYWQwYmM3Y2QyNWUzMDAzZCk7CiAgICAgICAgCgogICAgICAgIG1hcmtlcl9kOWI2ODE5M2Q1YWM0MjEyYTVmN2MzY2U3M2FlMTk4Ni5iaW5kUG9wdXAocG9wdXBfNzMxZTU5ODVmZGYwNDMyMjlhOWMwMzk2NjdlNWYzY2QpCiAgICAgICAgOwoKICAgICAgICAKICAgIAogICAgCiAgICAgICAgICAgIHZhciBtYXJrZXJfZmMyZTZlMDgzN2U0NDY5MTgyNGJhMzQ5Y2RjZTZhZGUgPSBMLm1hcmtlcigKICAgICAgICAgICAgICAgIFs0MC4wNTE2NTIsIC0xMDUuMTc4ODc1XSwKICAgICAgICAgICAgICAgIHt9CiAgICAgICAgICAgICkuYWRkVG8obWFya2VyX2NsdXN0ZXJfYTVlMTExNzdjMzhiNDQwYTk0MTVjYWZhMWY4Mjg5ZTIpOwogICAgICAgIAogICAgCiAgICAgICAgdmFyIHBvcHVwXzkxMzFhM2JiYWI0YTRiMjQ4Y2Q5OGQzN2NlYzJlMjgzID0gTC5wb3B1cCh7Im1heFdpZHRoIjogIjEwMCUifSk7CgogICAgICAgIAogICAgICAgICAgICB2YXIgaHRtbF84MTA5NmNkYTEyMjQ0YzM0ODA3NDczOWZjMjgzNDM1MCA9ICQoYDxkaXYgaWQ9Imh0bWxfODEwOTZjZGExMjI0NGMzNDgwNzQ3MzlmYzI4MzQzNTAiIHN0eWxlPSJ3aWR0aDogMTAwLjAlOyBoZWlnaHQ6IDEwMC4wJTsiPk5hbWU6IEJPVUxERVIgQ1JFRUsgQVQgTk9SVEggNzVUSCBTVC4gTkVBUiBCT1VMREVSLCBDTyBQcmVjaXA6IDkwLjEwPC9kaXY+YClbMF07CiAgICAgICAgICAgIHBvcHVwXzkxMzFhM2JiYWI0YTRiMjQ4Y2Q5OGQzN2NlYzJlMjgzLnNldENvbnRlbnQoaHRtbF84MTA5NmNkYTEyMjQ0YzM0ODA3NDczOWZjMjgzNDM1MCk7CiAgICAgICAgCgogICAgICAgIG1hcmtlcl9mYzJlNmUwODM3ZTQ0NjkxODI0YmEzNDljZGNlNmFkZS5iaW5kUG9wdXAocG9wdXBfOTEzMWEzYmJhYjRhNGIyNDhjZDk4ZDM3Y2VjMmUyODMpCiAgICAgICAgOwoKICAgICAgICAKICAgIAogICAgCiAgICAgICAgICAgIHZhciBtYXJrZXJfOGU4YzczMTNmNDFmNDA4M2JiYzczZDE5YjNhZmFlYjEgPSBMLm1hcmtlcigKICAgICAgICAgICAgICAgIFs0MC4xOTY0MjIsIC0xMDUuMjA2NTkyXSwKICAgICAgICAgICAgICAgIHt9CiAgICAgICAgICAgICkuYWRkVG8obWFya2VyX2NsdXN0ZXJfYTVlMTExNzdjMzhiNDQwYTk0MTVjYWZhMWY4Mjg5ZTIpOwogICAgICAgIAogICAgCiAgICAgICAgdmFyIHBvcHVwXzNjNWIwMDJkM2E3YjQ3NGFiOGY5ZTZjY2VmM2ZjNzBlID0gTC5wb3B1cCh7Im1heFdpZHRoIjogIjEwMCUifSk7CgogICAgICAgIAogICAgICAgICAgICB2YXIgaHRtbF9mYjhhMzVmNDRmM2Q0Y2MzYmM3NGYxZWVkNGUwZTUzMSA9ICQoYDxkaXYgaWQ9Imh0bWxfZmI4YTM1ZjQ0ZjNkNGNjM2JjNzRmMWVlZDRlMGU1MzEiIHN0eWxlPSJ3aWR0aDogMTAwLjAlOyBoZWlnaHQ6IDEwMC4wJTsiPk5hbWU6IE9MSUdBUkNIWSBESVRDSCBESVZFUlNJT04gUHJlY2lwOiAxMy40MTwvZGl2PmApWzBdOwogICAgICAgICAgICBwb3B1cF8zYzViMDAyZDNhN2I0NzRhYjhmOWU2Y2NlZjNmYzcwZS5zZXRDb250ZW50KGh0bWxfZmI4YTM1ZjQ0ZjNkNGNjM2JjNzRmMWVlZDRlMGU1MzEpOwogICAgICAgIAoKICAgICAgICBtYXJrZXJfOGU4YzczMTNmNDFmNDA4M2JiYzczZDE5YjNhZmFlYjEuYmluZFBvcHVwKHBvcHVwXzNjNWIwMDJkM2E3YjQ3NGFiOGY5ZTZjY2VmM2ZjNzBlKQogICAgICAgIDsKCiAgICAgICAgCiAgICAKICAgIAogICAgICAgICAgICB2YXIgbWFya2VyXzBjMjcwODQwMTAzYzQ3ZTVhN2QwMzg1Yzk1YzYzYmQ2ID0gTC5tYXJrZXIoCiAgICAgICAgICAgICAgICBbNDAuMjExMDgzLCAtMTA1LjI1MDkyN10sCiAgICAgICAgICAgICAgICB7fQogICAgICAgICAgICApLmFkZFRvKG1hcmtlcl9jbHVzdGVyX2E1ZTExMTc3YzM4YjQ0MGE5NDE1Y2FmYTFmODI4OWUyKTsKICAgICAgICAKICAgIAogICAgICAgIHZhciBwb3B1cF84NTZmODIyYWZmMjE0M2JiYTQ0M2Q4ZTJiZjI0NDhiZCA9IEwucG9wdXAoeyJtYXhXaWR0aCI6ICIxMDAlIn0pOwoKICAgICAgICAKICAgICAgICAgICAgdmFyIGh0bWxfN2QzOTVlNTI3MDRhNDUzOGI3MTk3N2ZiNmQxZjBjNmQgPSAkKGA8ZGl2IGlkPSJodG1sXzdkMzk1ZTUyNzA0YTQ1MzhiNzE5NzdmYjZkMWYwYzZkIiBzdHlsZT0id2lkdGg6IDEwMC4wJTsgaGVpZ2h0OiAxMDAuMCU7Ij5OYW1lOiBTV0VERSBESVRDSCBQcmVjaXA6IDAuMTA8L2Rpdj5gKVswXTsKICAgICAgICAgICAgcG9wdXBfODU2ZjgyMmFmZjIxNDNiYmE0NDNkOGUyYmYyNDQ4YmQuc2V0Q29udGVudChodG1sXzdkMzk1ZTUyNzA0YTQ1MzhiNzE5NzdmYjZkMWYwYzZkKTsKICAgICAgICAKCiAgICAgICAgbWFya2VyXzBjMjcwODQwMTAzYzQ3ZTVhN2QwMzg1Yzk1YzYzYmQ2LmJpbmRQb3B1cChwb3B1cF84NTZmODIyYWZmMjE0M2JiYTQ0M2Q4ZTJiZjI0NDhiZCkKICAgICAgICA7CgogICAgICAgIAogICAgCiAgICAKICAgICAgICAgICAgdmFyIG1hcmtlcl9iMGI3MTBhMDM2ZGQ0YTJiYWU1YTAzZWZkZmY5MmUxYyA9IEwubWFya2VyKAogICAgICAgICAgICAgICAgWzQwLjIxOTA0NiwgLTEwNS4yNTk3OTVdLAogICAgICAgICAgICAgICAge30KICAgICAgICAgICAgKS5hZGRUbyhtYXJrZXJfY2x1c3Rlcl9hNWUxMTE3N2MzOGI0NDBhOTQxNWNhZmExZjgyODllMik7CiAgICAgICAgCiAgICAKICAgICAgICB2YXIgcG9wdXBfN2NhYjkyMTdhNjFkNDgyMmIxNmJlNmY1NmY0YWM2YTIgPSBMLnBvcHVwKHsibWF4V2lkdGgiOiAiMTAwJSJ9KTsKCiAgICAgICAgCiAgICAgICAgICAgIHZhciBodG1sXzY1M2VhNGQ4YjUzMjQ4NTFhY2QwM2E5MDU3MjdjYTgxID0gJChgPGRpdiBpZD0iaHRtbF82NTNlYTRkOGI1MzI0ODUxYWNkMDNhOTA1NzI3Y2E4MSIgc3R5bGU9IndpZHRoOiAxMDAuMCU7IGhlaWdodDogMTAwLjAlOyI+TmFtZTogU1VQUExZIERJVENIIFByZWNpcDogMy40NDwvZGl2PmApWzBdOwogICAgICAgICAgICBwb3B1cF83Y2FiOTIxN2E2MWQ0ODIyYjE2YmU2ZjU2ZjRhYzZhMi5zZXRDb250ZW50KGh0bWxfNjUzZWE0ZDhiNTMyNDg1MWFjZDAzYTkwNTcyN2NhODEpOwogICAgICAgIAoKICAgICAgICBtYXJrZXJfYjBiNzEwYTAzNmRkNGEyYmFlNWEwM2VmZGZmOTJlMWMuYmluZFBvcHVwKHBvcHVwXzdjYWI5MjE3YTYxZDQ4MjJiMTZiZTZmNTZmNGFjNmEyKQogICAgICAgIDsKCiAgICAgICAgCiAgICAKICAgIAogICAgICAgICAgICB2YXIgbWFya2VyX2RkNDI2ZmQ0YWRiNzQwMTlhZDk2MDNkNTcwYTY1YWRiID0gTC5tYXJrZXIoCiAgICAgICAgICAgICAgICBbNDAuMTkzNzU4LCAtMTA1LjIxMDM5XSwKICAgICAgICAgICAgICAgIHt9CiAgICAgICAgICAgICkuYWRkVG8obWFya2VyX2NsdXN0ZXJfYTVlMTExNzdjMzhiNDQwYTk0MTVjYWZhMWY4Mjg5ZTIpOwogICAgICAgIAogICAgCiAgICAgICAgdmFyIHBvcHVwX2MxNTU5MTVhOWE5MDQ1YjBiNWU5ZGU5OWQ4ZDY4ZTlhID0gTC5wb3B1cCh7Im1heFdpZHRoIjogIjEwMCUifSk7CgogICAgICAgIAogICAgICAgICAgICB2YXIgaHRtbF9hOWZhODNjNjMwN2E0NTQ2YTJlZjhiMjIxNDFjNmFjZSA9ICQoYDxkaXYgaWQ9Imh0bWxfYTlmYTgzYzYzMDdhNDU0NmEyZWY4YjIyMTQxYzZhY2UiIHN0eWxlPSJ3aWR0aDogMTAwLjAlOyBoZWlnaHQ6IDEwMC4wJTsiPk5hbWU6IENMT1VHSCBBTkQgVFJVRSBESVRDSCBQcmVjaXA6IDAuMDA8L2Rpdj5gKVswXTsKICAgICAgICAgICAgcG9wdXBfYzE1NTkxNWE5YTkwNDViMGI1ZTlkZTk5ZDhkNjhlOWEuc2V0Q29udGVudChodG1sX2E5ZmE4M2M2MzA3YTQ1NDZhMmVmOGIyMjE0MWM2YWNlKTsKICAgICAgICAKCiAgICAgICAgbWFya2VyX2RkNDI2ZmQ0YWRiNzQwMTlhZDk2MDNkNTcwYTY1YWRiLmJpbmRQb3B1cChwb3B1cF9jMTU1OTE1YTlhOTA0NWIwYjVlOWRlOTlkOGQ2OGU5YSkKICAgICAgICA7CgogICAgICAgIAogICAgCiAgICAKICAgICAgICAgICAgdmFyIG1hcmtlcl83MWQ1YTcyZTA0ZmQ0M2E3OWM0NjIxNWExMjcwY2FhNSA9IEwubWFya2VyKAogICAgICAgICAgICAgICAgWzQwLjIxODMzNSwgLTEwNS4yNTgxMV0sCiAgICAgICAgICAgICAgICB7fQogICAgICAgICAgICApLmFkZFRvKG1hcmtlcl9jbHVzdGVyX2E1ZTExMTc3YzM4YjQ0MGE5NDE1Y2FmYTFmODI4OWUyKTsKICAgICAgICAKICAgIAogICAgICAgIHZhciBwb3B1cF82NTQyYjJlOGRmYzM0MzAwOTViZTMxMzIwNDlkOGY4NyA9IEwucG9wdXAoeyJtYXhXaWR0aCI6ICIxMDAlIn0pOwoKICAgICAgICAKICAgICAgICAgICAgdmFyIGh0bWxfNzk3OTU5NTk4NTNkNDg1NWE4YzZiY2M5NzkzYzBkMjYgPSAkKGA8ZGl2IGlkPSJodG1sXzc5Nzk1OTU5ODUzZDQ4NTVhOGM2YmNjOTc5M2MwZDI2IiBzdHlsZT0id2lkdGg6IDEwMC4wJTsgaGVpZ2h0OiAxMDAuMCU7Ij5OYW1lOiBTQUlOVCBWUkFJTiBTVVBQTFkgQ0FOQUwgTkVBUiBMWU9OUywgQ08gUHJlY2lwOiAxMzAuMDA8L2Rpdj5gKVswXTsKICAgICAgICAgICAgcG9wdXBfNjU0MmIyZThkZmMzNDMwMDk1YmUzMTMyMDQ5ZDhmODcuc2V0Q29udGVudChodG1sXzc5Nzk1OTU5ODUzZDQ4NTVhOGM2YmNjOTc5M2MwZDI2KTsKICAgICAgICAKCiAgICAgICAgbWFya2VyXzcxZDVhNzJlMDRmZDQzYTc5YzQ2MjE1YTEyNzBjYWE1LmJpbmRQb3B1cChwb3B1cF82NTQyYjJlOGRmYzM0MzAwOTViZTMxMzIwNDlkOGY4NykKICAgICAgICA7CgogICAgICAgIAogICAgCiAgICAKICAgICAgICAgICAgdmFyIG1hcmtlcl84ZTdiNDQ1MDA2OTY0NzdmOWFlYmZiYzhmODdmMmFkNCA9IEwubWFya2VyKAogICAgICAgICAgICAgICAgWzQwLjE3NDg0NCwgLTEwNS4xNjc4NzNdLAogICAgICAgICAgICAgICAge30KICAgICAgICAgICAgKS5hZGRUbyhtYXJrZXJfY2x1c3Rlcl9hNWUxMTE3N2MzOGI0NDBhOTQxNWNhZmExZjgyODllMik7CiAgICAgICAgCiAgICAKICAgICAgICB2YXIgcG9wdXBfYjY2YzFmOGFmY2I5NGM4YTgzM2YxMGIzZmVhOGI2YmYgPSBMLnBvcHVwKHsibWF4V2lkdGgiOiAiMTAwJSJ9KTsKCiAgICAgICAgCiAgICAgICAgICAgIHZhciBodG1sXzBkZDRmMmJhNTljNjQ1ZDU5OWVhODhlYzEyYTM2OGE4ID0gJChgPGRpdiBpZD0iaHRtbF8wZGQ0ZjJiYTU5YzY0NWQ1OTllYTg4ZWMxMmEzNjhhOCIgc3R5bGU9IndpZHRoOiAxMDAuMCU7IGhlaWdodDogMTAwLjAlOyI+TmFtZTogSEFHRVIgTUVBRE9XUyBESVRDSCBQcmVjaXA6IDIuMjQ8L2Rpdj5gKVswXTsKICAgICAgICAgICAgcG9wdXBfYjY2YzFmOGFmY2I5NGM4YTgzM2YxMGIzZmVhOGI2YmYuc2V0Q29udGVudChodG1sXzBkZDRmMmJhNTljNjQ1ZDU5OWVhODhlYzEyYTM2OGE4KTsKICAgICAgICAKCiAgICAgICAgbWFya2VyXzhlN2I0NDUwMDY5NjQ3N2Y5YWViZmJjOGY4N2YyYWQ0LmJpbmRQb3B1cChwb3B1cF9iNjZjMWY4YWZjYjk0YzhhODMzZjEwYjNmZWE4YjZiZikKICAgICAgICA7CgogICAgICAgIAogICAgCiAgICAKICAgICAgICAgICAgdmFyIG1hcmtlcl82MWRiYjhlNDQ5MjU0ZDAxODg2YmQ4M2IyZWI3ZTNmMiA9IEwubWFya2VyKAogICAgICAgICAgICAgICAgWzM5LjkzMTY1OSwgLTEwNS40MjI5ODVdLAogICAgICAgICAgICAgICAge30KICAgICAgICAgICAgKS5hZGRUbyhtYXJrZXJfY2x1c3Rlcl9hNWUxMTE3N2MzOGI0NDBhOTQxNWNhZmExZjgyODllMik7CiAgICAgICAgCiAgICAKICAgICAgICB2YXIgcG9wdXBfYjQxNjg2NWFiOTllNDlkZjhiYmJhMmZlMWNmMWU4OTMgPSBMLnBvcHVwKHsibWF4V2lkdGgiOiAiMTAwJSJ9KTsKCiAgICAgICAgCiAgICAgICAgICAgIHZhciBodG1sXzUzNDg2ZWJiNzFhZTQxMTNhZDJhNzRlMzk1MDRiZThiID0gJChgPGRpdiBpZD0iaHRtbF81MzQ4NmViYjcxYWU0MTEzYWQyYTc0ZTM5NTA0YmU4YiIgc3R5bGU9IndpZHRoOiAxMDAuMCU7IGhlaWdodDogMTAwLjAlOyI+TmFtZTogU09VVEggQk9VTERFUiBDUkVFSyBBQk9WRSBHUk9TUyBSRVNFUlZPSVIgQVQgUElORUNMSUZGRSBQcmVjaXA6IDk2LjIwPC9kaXY+YClbMF07CiAgICAgICAgICAgIHBvcHVwX2I0MTY4NjVhYjk5ZTQ5ZGY4YmJiYTJmZTFjZjFlODkzLnNldENvbnRlbnQoaHRtbF81MzQ4NmViYjcxYWU0MTEzYWQyYTc0ZTM5NTA0YmU4Yik7CiAgICAgICAgCgogICAgICAgIG1hcmtlcl82MWRiYjhlNDQ5MjU0ZDAxODg2YmQ4M2IyZWI3ZTNmMi5iaW5kUG9wdXAocG9wdXBfYjQxNjg2NWFiOTllNDlkZjhiYmJhMmZlMWNmMWU4OTMpCiAgICAgICAgOwoKICAgICAgICAKICAgIAogICAgCiAgICAgICAgICAgIHZhciBtYXJrZXJfMmI1YmVkNTI4MzU3NGRhMTliZTZiYmYwMWY2YWRmM2YgPSBMLm1hcmtlcigKICAgICAgICAgICAgICAgIFs0MC4wOTEzOTEsIC0xMDUuNTA4NDhdLAogICAgICAgICAgICAgICAge30KICAgICAgICAgICAgKS5hZGRUbyhtYXJrZXJfY2x1c3Rlcl9hNWUxMTE3N2MzOGI0NDBhOTQxNWNhZmExZjgyODllMik7CiAgICAgICAgCiAgICAKICAgICAgICB2YXIgcG9wdXBfZWRkYjk0MmQ5NWZlNGE4NDk4NjFmZDllZGI4NGI5YWQgPSBMLnBvcHVwKHsibWF4V2lkdGgiOiAiMTAwJSJ9KTsKCiAgICAgICAgCiAgICAgICAgICAgIHZhciBodG1sXzMwOGNmYmVhODExZDQ5YzA5NzIzNThkYmE2NmY2NzA3ID0gJChgPGRpdiBpZD0iaHRtbF8zMDhjZmJlYTgxMWQ0OWMwOTcyMzU4ZGJhNjZmNjcwNyIgc3R5bGU9IndpZHRoOiAxMDAuMCU7IGhlaWdodDogMTAwLjAlOyI+TmFtZTogTEVGVCBIQU5EIERJVkVSU0lPTiBORUFSIFdBUkQgUHJlY2lwOiAyOS4yMDwvZGl2PmApWzBdOwogICAgICAgICAgICBwb3B1cF9lZGRiOTQyZDk1ZmU0YTg0OTg2MWZkOWVkYjg0YjlhZC5zZXRDb250ZW50KGh0bWxfMzA4Y2ZiZWE4MTFkNDljMDk3MjM1OGRiYTY2ZjY3MDcpOwogICAgICAgIAoKICAgICAgICBtYXJrZXJfMmI1YmVkNTI4MzU3NGRhMTliZTZiYmYwMWY2YWRmM2YuYmluZFBvcHVwKHBvcHVwX2VkZGI5NDJkOTVmZTRhODQ5ODYxZmQ5ZWRiODRiOWFkKQogICAgICAgIDsKCiAgICAgICAgCiAgICAKICAgIAogICAgICAgICAgICB2YXIgbWFya2VyX2I3NGEyY2E1MDQ4MTRlZmY5NmExZWQ1MWZiOTQyMjc0ID0gTC5tYXJrZXIoCiAgICAgICAgICAgICAgICBbNDAuMDQyMDI4LCAtMTA1LjM2NDkxN10sCiAgICAgICAgICAgICAgICB7fQogICAgICAgICAgICApLmFkZFRvKG1hcmtlcl9jbHVzdGVyX2E1ZTExMTc3YzM4YjQ0MGE5NDE1Y2FmYTFmODI4OWUyKTsKICAgICAgICAKICAgIAogICAgICAgIHZhciBwb3B1cF83YTAwODJjNmU2ZjU0NmQ0YTJkNTcwMjNjYzRjNmYxOCA9IEwucG9wdXAoeyJtYXhXaWR0aCI6ICIxMDAlIn0pOwoKICAgICAgICAKICAgICAgICAgICAgdmFyIGh0bWxfMDRjMzQwNmFkZmM4NGU3MGI0ZDJhNmZkMDQ4OTY0MjIgPSAkKGA8ZGl2IGlkPSJodG1sXzA0YzM0MDZhZGZjODRlNzBiNGQyYTZmZDA0ODk2NDIyIiBzdHlsZT0id2lkdGg6IDEwMC4wJTsgaGVpZ2h0OiAxMDAuMCU7Ij5OYW1lOiBGT1VSTUlMRSBDUkVFSyBBVCBMT0dBTiBNSUxMIFJPQUQgTkVBUiBDUklTTUFOLCBDTyBQcmVjaXA6IG5hbjwvZGl2PmApWzBdOwogICAgICAgICAgICBwb3B1cF83YTAwODJjNmU2ZjU0NmQ0YTJkNTcwMjNjYzRjNmYxOC5zZXRDb250ZW50KGh0bWxfMDRjMzQwNmFkZmM4NGU3MGI0ZDJhNmZkMDQ4OTY0MjIpOwogICAgICAgIAoKICAgICAgICBtYXJrZXJfYjc0YTJjYTUwNDgxNGVmZjk2YTFlZDUxZmI5NDIyNzQuYmluZFBvcHVwKHBvcHVwXzdhMDA4MmM2ZTZmNTQ2ZDRhMmQ1NzAyM2NjNGM2ZjE4KQogICAgICAgIDsKCiAgICAgICAgCiAgICAKICAgIAogICAgICAgICAgICB2YXIgbWFya2VyXzBjNzlhNjNiNjYwNzRkOTk4YTcxZWY5YmIzZjlhMWU0ID0gTC5tYXJrZXIoCiAgICAgICAgICAgICAgICBbNDAuMjExMzg5LCAtMTA1LjI1MDk1Ml0sCiAgICAgICAgICAgICAgICB7fQogICAgICAgICAgICApLmFkZFRvKG1hcmtlcl9jbHVzdGVyX2E1ZTExMTc3YzM4YjQ0MGE5NDE1Y2FmYTFmODI4OWUyKTsKICAgICAgICAKICAgIAogICAgICAgIHZhciBwb3B1cF81ZWU0MWFmYzIwMGI0YzIwYTIwZGMxZTExYmRjZmZhMiA9IEwucG9wdXAoeyJtYXhXaWR0aCI6ICIxMDAlIn0pOwoKICAgICAgICAKICAgICAgICAgICAgdmFyIGh0bWxfMDZhYjA3MDMyY2YxNGQ0ZDg5Yzc4OTM5ZDE1NmZjODEgPSAkKGA8ZGl2IGlkPSJodG1sXzA2YWIwNzAzMmNmMTRkNGQ4OWM3ODkzOWQxNTZmYzgxIiBzdHlsZT0id2lkdGg6IDEwMC4wJTsgaGVpZ2h0OiAxMDAuMCU7Ij5OYW1lOiBTTUVBRCBESVRDSCBQcmVjaXA6IDQuNTA8L2Rpdj5gKVswXTsKICAgICAgICAgICAgcG9wdXBfNWVlNDFhZmMyMDBiNGMyMGEyMGRjMWUxMWJkY2ZmYTIuc2V0Q29udGVudChodG1sXzA2YWIwNzAzMmNmMTRkNGQ4OWM3ODkzOWQxNTZmYzgxKTsKICAgICAgICAKCiAgICAgICAgbWFya2VyXzBjNzlhNjNiNjYwNzRkOTk4YTcxZWY5YmIzZjlhMWU0LmJpbmRQb3B1cChwb3B1cF81ZWU0MWFmYzIwMGI0YzIwYTIwZGMxZTExYmRjZmZhMikKICAgICAgICA7CgogICAgICAgIAogICAgCiAgICAKICAgICAgICAgICAgdmFyIG1hcmtlcl9mMTUzOGNkOWY5N2I0OTczOTg3NTIyZDNlNjllNWI3NyA9IEwubWFya2VyKAogICAgICAgICAgICAgICAgWzQwLjI1NTc3NiwgLTEwNS4yMDk1XSwKICAgICAgICAgICAgICAgIHt9CiAgICAgICAgICAgICkuYWRkVG8obWFya2VyX2NsdXN0ZXJfYTVlMTExNzdjMzhiNDQwYTk0MTVjYWZhMWY4Mjg5ZTIpOwogICAgICAgIAogICAgCiAgICAgICAgdmFyIHBvcHVwX2NjYjI2ZjMzNDc3MTRiZWE4MjcwYTk5N2E5YzcxMzNlID0gTC5wb3B1cCh7Im1heFdpZHRoIjogIjEwMCUifSk7CgogICAgICAgIAogICAgICAgICAgICB2YXIgaHRtbF8wMDUzOTZjYjc2MTY0MWRlOWFkZDFlOWE0NmU2NWRhOSA9ICQoYDxkaXYgaWQ9Imh0bWxfMDA1Mzk2Y2I3NjE2NDFkZTlhZGQxZTlhNDZlNjVkYTkiIHN0eWxlPSJ3aWR0aDogMTAwLjAlOyBoZWlnaHQ6IDEwMC4wJTsiPk5hbWU6IExJVFRMRSBUSE9NUFNPTiAjMiBESVRDSCBQcmVjaXA6IDkuMjg8L2Rpdj5gKVswXTsKICAgICAgICAgICAgcG9wdXBfY2NiMjZmMzM0NzcxNGJlYTgyNzBhOTk3YTljNzEzM2Uuc2V0Q29udGVudChodG1sXzAwNTM5NmNiNzYxNjQxZGU5YWRkMWU5YTQ2ZTY1ZGE5KTsKICAgICAgICAKCiAgICAgICAgbWFya2VyX2YxNTM4Y2Q5Zjk3YjQ5NzM5ODc1MjJkM2U2OWU1Yjc3LmJpbmRQb3B1cChwb3B1cF9jY2IyNmYzMzQ3NzE0YmVhODI3MGE5OTdhOWM3MTMzZSkKICAgICAgICA7CgogICAgICAgIAogICAgCiAgICAKICAgICAgICAgICAgdmFyIG1hcmtlcl9iNzk1ZjMyZDk1Yjg0OTI3YjEyMTVkMmIwODgxZTJiNSA9IEwubWFya2VyKAogICAgICAgICAgICAgICAgWzQwLjAwNjM4LCAtMTA1LjMzMDg0MV0sCiAgICAgICAgICAgICAgICB7fQogICAgICAgICAgICApLmFkZFRvKG1hcmtlcl9jbHVzdGVyX2E1ZTExMTc3YzM4YjQ0MGE5NDE1Y2FmYTFmODI4OWUyKTsKICAgICAgICAKICAgIAogICAgICAgIHZhciBwb3B1cF85YTA2MThmNGE5YzI0NWRkYTkxZWE1MGFjMDEyY2QwMyA9IEwucG9wdXAoeyJtYXhXaWR0aCI6ICIxMDAlIn0pOwoKICAgICAgICAKICAgICAgICAgICAgdmFyIGh0bWxfZWMwNTM2MTBmZDZiNDFjM2IzNjIxYzcyMjZmYTRjNmMgPSAkKGA8ZGl2IGlkPSJodG1sX2VjMDUzNjEwZmQ2YjQxYzNiMzYyMWM3MjI2ZmE0YzZjIiBzdHlsZT0id2lkdGg6IDEwMC4wJTsgaGVpZ2h0OiAxMDAuMCU7Ij5OYW1lOiBCT1VMREVSIENSRUVLIE5FQVIgT1JPREVMTCwgQ08uIFByZWNpcDogNDYuNDA8L2Rpdj5gKVswXTsKICAgICAgICAgICAgcG9wdXBfOWEwNjE4ZjRhOWMyNDVkZGE5MWVhNTBhYzAxMmNkMDMuc2V0Q29udGVudChodG1sX2VjMDUzNjEwZmQ2YjQxYzNiMzYyMWM3MjI2ZmE0YzZjKTsKICAgICAgICAKCiAgICAgICAgbWFya2VyX2I3OTVmMzJkOTViODQ5MjdiMTIxNWQyYjA4ODFlMmI1LmJpbmRQb3B1cChwb3B1cF85YTA2MThmNGE5YzI0NWRkYTkxZWE1MGFjMDEyY2QwMykKICAgICAgICA7CgogICAgICAgIAogICAgCiAgICAKICAgICAgICAgICAgdmFyIG1hcmtlcl8zMWQ3OGNkZDFlYjk0OGRhOGM5NzE4ODk5ZWI0ZGNlZiA9IEwubWFya2VyKAogICAgICAgICAgICAgICAgWzQwLjE3MjkyNSwgLTEwNS4xNjc2MjJdLAogICAgICAgICAgICAgICAge30KICAgICAgICAgICAgKS5hZGRUbyhtYXJrZXJfY2x1c3Rlcl9hNWUxMTE3N2MzOGI0NDBhOTQxNWNhZmExZjgyODllMik7CiAgICAgICAgCiAgICAKICAgICAgICB2YXIgcG9wdXBfYTAwNTJmMzg0ZWUyNGI1YzkwZDAwOWNkNTM1ODM2NzYgPSBMLnBvcHVwKHsibWF4V2lkdGgiOiAiMTAwJSJ9KTsKCiAgICAgICAgCiAgICAgICAgICAgIHZhciBodG1sXzIyM2NlMTAxZjE1YzQ5ZDhhZGE1ODg5ZjNlNGVmY2FmID0gJChgPGRpdiBpZD0iaHRtbF8yMjNjZTEwMWYxNWM0OWQ4YWRhNTg4OWYzZTRlZmNhZiIgc3R5bGU9IndpZHRoOiAxMDAuMCU7IGhlaWdodDogMTAwLjAlOyI+TmFtZTogTk9SVEhXRVNUIE1VVFVBTCBESVRDSCBQcmVjaXA6IDEuNzU8L2Rpdj5gKVswXTsKICAgICAgICAgICAgcG9wdXBfYTAwNTJmMzg0ZWUyNGI1YzkwZDAwOWNkNTM1ODM2NzYuc2V0Q29udGVudChodG1sXzIyM2NlMTAxZjE1YzQ5ZDhhZGE1ODg5ZjNlNGVmY2FmKTsKICAgICAgICAKCiAgICAgICAgbWFya2VyXzMxZDc4Y2RkMWViOTQ4ZGE4Yzk3MTg4OTllYjRkY2VmLmJpbmRQb3B1cChwb3B1cF9hMDA1MmYzODRlZTI0YjVjOTBkMDA5Y2Q1MzU4MzY3NikKICAgICAgICA7CgogICAgICAgIAogICAgCiAgICAKICAgICAgICAgICAgdmFyIG1hcmtlcl9jZWNiZTdkMzRkYzc0NGNjODM0Y2UxYjE1NzY1NzE2YSA9IEwubWFya2VyKAogICAgICAgICAgICAgICAgWzQwLjE4NzUyNCwgLTEwNS4xODkxMzJdLAogICAgICAgICAgICAgICAge30KICAgICAgICAgICAgKS5hZGRUbyhtYXJrZXJfY2x1c3Rlcl9hNWUxMTE3N2MzOGI0NDBhOTQxNWNhZmExZjgyODllMik7CiAgICAgICAgCiAgICAKICAgICAgICB2YXIgcG9wdXBfZjE0ODhkZGNkMTBiNDY2OTg5NzRiM2M2MTFmZDhlY2UgPSBMLnBvcHVwKHsibWF4V2lkdGgiOiAiMTAwJSJ9KTsKCiAgICAgICAgCiAgICAgICAgICAgIHZhciBodG1sX2FhMWI4MWRiOWYxMjQ3ZjY5NGVhZjU1MzIyNzQ5ZGIzID0gJChgPGRpdiBpZD0iaHRtbF9hYTFiODFkYjlmMTI0N2Y2OTRlYWY1NTMyMjc0OWRiMyIgc3R5bGU9IndpZHRoOiAxMDAuMCU7IGhlaWdodDogMTAwLjAlOyI+TmFtZTogUlVOWU9OIERJVENIIFByZWNpcDogMC4wMzwvZGl2PmApWzBdOwogICAgICAgICAgICBwb3B1cF9mMTQ4OGRkY2QxMGI0NjY5ODk3NGIzYzYxMWZkOGVjZS5zZXRDb250ZW50KGh0bWxfYWExYjgxZGI5ZjEyNDdmNjk0ZWFmNTUzMjI3NDlkYjMpOwogICAgICAgIAoKICAgICAgICBtYXJrZXJfY2VjYmU3ZDM0ZGM3NDRjYzgzNGNlMWIxNTc2NTcxNmEuYmluZFBvcHVwKHBvcHVwX2YxNDg4ZGRjZDEwYjQ2Njk4OTc0YjNjNjExZmQ4ZWNlKQogICAgICAgIDsKCiAgICAgICAgCiAgICAKICAgIAogICAgICAgICAgICB2YXIgbWFya2VyXzFiNzE3YTU1YTgxYjRjNDc4ZDZiZmZiNTRjNTllODUwID0gTC5tYXJrZXIoCiAgICAgICAgICAgICAgICBbNDAuMTg1MDMzLCAtMTA1LjE4NTc4OV0sCiAgICAgICAgICAgICAgICB7fQogICAgICAgICAgICApLmFkZFRvKG1hcmtlcl9jbHVzdGVyX2E1ZTExMTc3YzM4YjQ0MGE5NDE1Y2FmYTFmODI4OWUyKTsKICAgICAgICAKICAgIAogICAgICAgIHZhciBwb3B1cF8wMTEwOWZmZWYzYzA0NGRlYWFkMWE1ZmQ1ZDRjZDM2ZCA9IEwucG9wdXAoeyJtYXhXaWR0aCI6ICIxMDAlIn0pOwoKICAgICAgICAKICAgICAgICAgICAgdmFyIGh0bWxfMmM0YzllYTMxOGMyNGI0MThlYTM2ZjcxODA5NzNhMGIgPSAkKGA8ZGl2IGlkPSJodG1sXzJjNGM5ZWEzMThjMjRiNDE4ZWEzNmY3MTgwOTczYTBiIiBzdHlsZT0id2lkdGg6IDEwMC4wJTsgaGVpZ2h0OiAxMDAuMCU7Ij5OYW1lOiBaV0VDSyBBTkQgVFVSTkVSIERJVENIIFByZWNpcDogMTIuMzg8L2Rpdj5gKVswXTsKICAgICAgICAgICAgcG9wdXBfMDExMDlmZmVmM2MwNDRkZWFhZDFhNWZkNWQ0Y2QzNmQuc2V0Q29udGVudChodG1sXzJjNGM5ZWEzMThjMjRiNDE4ZWEzNmY3MTgwOTczYTBiKTsKICAgICAgICAKCiAgICAgICAgbWFya2VyXzFiNzE3YTU1YTgxYjRjNDc4ZDZiZmZiNTRjNTllODUwLmJpbmRQb3B1cChwb3B1cF8wMTEwOWZmZWYzYzA0NGRlYWFkMWE1ZmQ1ZDRjZDM2ZCkKICAgICAgICA7CgogICAgICAgIAogICAgCiAgICAKICAgICAgICAgICAgdmFyIG1hcmtlcl82OThlNTZmZjc3NjI0ZjE2YmIxMjEyNDI2NjgxYTE0YiA9IEwubWFya2VyKAogICAgICAgICAgICAgICAgWzQwLjIxNjI2MywgLTEwNS4zNjUzNjVdLAogICAgICAgICAgICAgICAge30KICAgICAgICAgICAgKS5hZGRUbyhtYXJrZXJfY2x1c3Rlcl9hNWUxMTE3N2MzOGI0NDBhOTQxNWNhZmExZjgyODllMik7CiAgICAgICAgCiAgICAKICAgICAgICB2YXIgcG9wdXBfYjk0YzBiMWMzY2I5NDk1Njk1NzA1MjVmOTExNmE2ZDIgPSBMLnBvcHVwKHsibWF4V2lkdGgiOiAiMTAwJSJ9KTsKCiAgICAgICAgCiAgICAgICAgICAgIHZhciBodG1sXzY4NjJlYmEzZWFlOTQ2NDg5NmM3MWRmZGZhMTJjZTFiID0gJChgPGRpdiBpZD0iaHRtbF82ODYyZWJhM2VhZTk0NjQ4OTZjNzFkZmRmYTEyY2UxYiIgc3R5bGU9IndpZHRoOiAxMDAuMCU7IGhlaWdodDogMTAwLjAlOyI+TmFtZTogQlVUVE9OUk9DSyAoUkFMUEggUFJJQ0UpIFJFU0VSVk9JUiBQcmVjaXA6IDE2MjQ2LjAwPC9kaXY+YClbMF07CiAgICAgICAgICAgIHBvcHVwX2I5NGMwYjFjM2NiOTQ5NTY5NTcwNTI1ZjkxMTZhNmQyLnNldENvbnRlbnQoaHRtbF82ODYyZWJhM2VhZTk0NjQ4OTZjNzFkZmRmYTEyY2UxYik7CiAgICAgICAgCgogICAgICAgIG1hcmtlcl82OThlNTZmZjc3NjI0ZjE2YmIxMjEyNDI2NjgxYTE0Yi5iaW5kUG9wdXAocG9wdXBfYjk0YzBiMWMzY2I5NDk1Njk1NzA1MjVmOTExNmE2ZDIpCiAgICAgICAgOwoKICAgICAgICAKICAgIAogICAgCiAgICAgICAgICAgIHZhciBtYXJrZXJfYmY4ZjdlZTYxMTg3NGI2MzlhOTE2MzkzNjY3NzVlZGQgPSBMLm1hcmtlcigKICAgICAgICAgICAgICAgIFs0MC4yNTc4NDQsIC0xMDUuMTY0Mzk3XSwKICAgICAgICAgICAgICAgIHt9CiAgICAgICAgICAgICkuYWRkVG8obWFya2VyX2NsdXN0ZXJfYTVlMTExNzdjMzhiNDQwYTk0MTVjYWZhMWY4Mjg5ZTIpOwogICAgICAgIAogICAgCiAgICAgICAgdmFyIHBvcHVwXzVmZTVjZjFlYzBiNTRlNzJiZGEyZDc0MTUxMzlmMGJjID0gTC5wb3B1cCh7Im1heFdpZHRoIjogIjEwMCUifSk7CgogICAgICAgIAogICAgICAgICAgICB2YXIgaHRtbF9kODBhY2YwNzUyYjc0NTE0YTg2NDI5MjkzNGYyZjJiMSA9ICQoYDxkaXYgaWQ9Imh0bWxfZDgwYWNmMDc1MmI3NDUxNGE4NjQyOTI5MzRmMmYyYjEiIHN0eWxlPSJ3aWR0aDogMTAwLjAlOyBoZWlnaHQ6IDEwMC4wJTsiPk5hbWU6IEJMT1dFUiBESVRDSCBQcmVjaXA6IDAuMjM8L2Rpdj5gKVswXTsKICAgICAgICAgICAgcG9wdXBfNWZlNWNmMWVjMGI1NGU3MmJkYTJkNzQxNTEzOWYwYmMuc2V0Q29udGVudChodG1sX2Q4MGFjZjA3NTJiNzQ1MTRhODY0MjkyOTM0ZjJmMmIxKTsKICAgICAgICAKCiAgICAgICAgbWFya2VyX2JmOGY3ZWU2MTE4NzRiNjM5YTkxNjM5MzY2Nzc1ZWRkLmJpbmRQb3B1cChwb3B1cF81ZmU1Y2YxZWMwYjU0ZTcyYmRhMmQ3NDE1MTM5ZjBiYykKICAgICAgICA7CgogICAgICAgIAogICAgCiAgICAKICAgICAgICAgICAgdmFyIG1hcmtlcl82ODdkY2FiNDgwODM0ODAxYTYwNGUzZmRlODU2M2NmZiA9IEwubWFya2VyKAogICAgICAgICAgICAgICAgWzQwLjIxNTA0MywgLTEwNS4yNTYwMTddLAogICAgICAgICAgICAgICAge30KICAgICAgICAgICAgKS5hZGRUbyhtYXJrZXJfY2x1c3Rlcl9hNWUxMTE3N2MzOGI0NDBhOTQxNWNhZmExZjgyODllMik7CiAgICAgICAgCiAgICAKICAgICAgICB2YXIgcG9wdXBfODAzYzk3ZTU4MTI3NDZjMmJlYzM1YWNmOGU3MWY1YTggPSBMLnBvcHVwKHsibWF4V2lkdGgiOiAiMTAwJSJ9KTsKCiAgICAgICAgCiAgICAgICAgICAgIHZhciBodG1sX2E2NDdkMjdkZDYyOTRmZmFhZWU0NzczYzRjM2NiMTkwID0gJChgPGRpdiBpZD0iaHRtbF9hNjQ3ZDI3ZGQ2Mjk0ZmZhYWVlNDc3M2M0YzNjYjE5MCIgc3R5bGU9IndpZHRoOiAxMDAuMCU7IGhlaWdodDogMTAwLjAlOyI+TmFtZTogSElHSExBTkQgRElUQ0ggQVQgTFlPTlMsIENPIFByZWNpcDogMTAzLjAwPC9kaXY+YClbMF07CiAgICAgICAgICAgIHBvcHVwXzgwM2M5N2U1ODEyNzQ2YzJiZWMzNWFjZjhlNzFmNWE4LnNldENvbnRlbnQoaHRtbF9hNjQ3ZDI3ZGQ2Mjk0ZmZhYWVlNDc3M2M0YzNjYjE5MCk7CiAgICAgICAgCgogICAgICAgIG1hcmtlcl82ODdkY2FiNDgwODM0ODAxYTYwNGUzZmRlODU2M2NmZi5iaW5kUG9wdXAocG9wdXBfODAzYzk3ZTU4MTI3NDZjMmJlYzM1YWNmOGU3MWY1YTgpCiAgICAgICAgOwoKICAgICAgICAKICAgIAogICAgCiAgICAgICAgICAgIHZhciBtYXJrZXJfODZiMzAzYTU4YjgzNDcyOTlkNWMyNjE2MTI4NDI5NTkgPSBMLm1hcmtlcigKICAgICAgICAgICAgICAgIFszOS45NjE2NTUsIC0xMDUuNTA0NDRdLAogICAgICAgICAgICAgICAge30KICAgICAgICAgICAgKS5hZGRUbyhtYXJrZXJfY2x1c3Rlcl9hNWUxMTE3N2MzOGI0NDBhOTQxNWNhZmExZjgyODllMik7CiAgICAgICAgCiAgICAKICAgICAgICB2YXIgcG9wdXBfMTc3ODBlMGNlMzY4NDcxM2E2MDllMTE4NzlhNmM4MzAgPSBMLnBvcHVwKHsibWF4V2lkdGgiOiAiMTAwJSJ9KTsKCiAgICAgICAgCiAgICAgICAgICAgIHZhciBodG1sXzAzM2EzMjRlN2ZmODQ5ODNhYmFiOThhMzZmYTAwNWNjID0gJChgPGRpdiBpZD0iaHRtbF8wMzNhMzI0ZTdmZjg0OTgzYWJhYjk4YTM2ZmEwMDVjYyIgc3R5bGU9IndpZHRoOiAxMDAuMCU7IGhlaWdodDogMTAwLjAlOyI+TmFtZTogTUlERExFIEJPVUxERVIgQ1JFRUsgQVQgTkVERVJMQU5ELCBDTy4gUHJlY2lwOiAzOS43MDwvZGl2PmApWzBdOwogICAgICAgICAgICBwb3B1cF8xNzc4MGUwY2UzNjg0NzEzYTYwOWUxMTg3OWE2YzgzMC5zZXRDb250ZW50KGh0bWxfMDMzYTMyNGU3ZmY4NDk4M2FiYWI5OGEzNmZhMDA1Y2MpOwogICAgICAgIAoKICAgICAgICBtYXJrZXJfODZiMzAzYTU4YjgzNDcyOTlkNWMyNjE2MTI4NDI5NTkuYmluZFBvcHVwKHBvcHVwXzE3NzgwZTBjZTM2ODQ3MTNhNjA5ZTExODc5YTZjODMwKQogICAgICAgIDsKCiAgICAgICAgCiAgICAKICAgIAogICAgICAgICAgICB2YXIgbWFya2VyXzJmMTlmODQxZmM1NzQyYzg4Njc5ZGFiNTk1YjQ1M2Y3ID0gTC5tYXJrZXIoCiAgICAgICAgICAgICAgICBbNDAuMTc3NDIzLCAtMTA1LjE3ODE0NV0sCiAgICAgICAgICAgICAgICB7fQogICAgICAgICAgICApLmFkZFRvKG1hcmtlcl9jbHVzdGVyX2E1ZTExMTc3YzM4YjQ0MGE5NDE1Y2FmYTFmODI4OWUyKTsKICAgICAgICAKICAgIAogICAgICAgIHZhciBwb3B1cF9lMDdkZmMyZWUzMzI0NmRhYTVmNmI3MjAyYjU4ZjdjNCA9IEwucG9wdXAoeyJtYXhXaWR0aCI6ICIxMDAlIn0pOwoKICAgICAgICAKICAgICAgICAgICAgdmFyIGh0bWxfNDE0MDhmZDM5ZWU4NDVmMDg4ZmJkY2MzMTI1YzMwYjYgPSAkKGA8ZGl2IGlkPSJodG1sXzQxNDA4ZmQzOWVlODQ1ZjA4OGZiZGNjMzEyNWMzMGI2IiBzdHlsZT0id2lkdGg6IDEwMC4wJTsgaGVpZ2h0OiAxMDAuMCU7Ij5OYW1lOiBTQUlOVCBWUkFJTiBDUkVFSyBBVCBIWUdJRU5FLCBDTyBQcmVjaXA6IDE0LjQwPC9kaXY+YClbMF07CiAgICAgICAgICAgIHBvcHVwX2UwN2RmYzJlZTMzMjQ2ZGFhNWY2YjcyMDJiNThmN2M0LnNldENvbnRlbnQoaHRtbF80MTQwOGZkMzllZTg0NWYwODhmYmRjYzMxMjVjMzBiNik7CiAgICAgICAgCgogICAgICAgIG1hcmtlcl8yZjE5Zjg0MWZjNTc0MmM4ODY3OWRhYjU5NWI0NTNmNy5iaW5kUG9wdXAocG9wdXBfZTA3ZGZjMmVlMzMyNDZkYWE1ZjZiNzIwMmI1OGY3YzQpCiAgICAgICAgOwoKICAgICAgICAKICAgIAogICAgCiAgICAgICAgICAgIHZhciBtYXJrZXJfNWE1YjExN2JiOTc0NDYzMzlhMzVjNmU5NzM3ZDhiNTIgPSBMLm1hcmtlcigKICAgICAgICAgICAgICAgIFszOS45MzgzNTEsIC0xMDUuMzQ3OTA2XSwKICAgICAgICAgICAgICAgIHt9CiAgICAgICAgICAgICkuYWRkVG8obWFya2VyX2NsdXN0ZXJfYTVlMTExNzdjMzhiNDQwYTk0MTVjYWZhMWY4Mjg5ZTIpOwogICAgICAgIAogICAgCiAgICAgICAgdmFyIHBvcHVwX2U3OGQ1NmE4MDNhNzRhMzVhYmIzZTNlOGQyYTg5ODgwID0gTC5wb3B1cCh7Im1heFdpZHRoIjogIjEwMCUifSk7CgogICAgICAgIAogICAgICAgICAgICB2YXIgaHRtbF9iMWZlNWQwNWE4NDQ0NGI4OTc1Yjg5MDhiZDBiMmRiOSA9ICQoYDxkaXYgaWQ9Imh0bWxfYjFmZTVkMDVhODQ0NDRiODk3NWI4OTA4YmQwYjJkYjkiIHN0eWxlPSJ3aWR0aDogMTAwLjAlOyBoZWlnaHQ6IDEwMC4wJTsiPk5hbWU6IFNPVVRIIEJPVUxERVIgQ1JFRUsgQkVMT1cgR1JPU1MgUkVTRVJWT0lSIFByZWNpcDogMTE1LjAwPC9kaXY+YClbMF07CiAgICAgICAgICAgIHBvcHVwX2U3OGQ1NmE4MDNhNzRhMzVhYmIzZTNlOGQyYTg5ODgwLnNldENvbnRlbnQoaHRtbF9iMWZlNWQwNWE4NDQ0NGI4OTc1Yjg5MDhiZDBiMmRiOSk7CiAgICAgICAgCgogICAgICAgIG1hcmtlcl81YTViMTE3YmI5NzQ0NjMzOWEzNWM2ZTk3MzdkOGI1Mi5iaW5kUG9wdXAocG9wdXBfZTc4ZDU2YTgwM2E3NGEzNWFiYjNlM2U4ZDJhODk4ODApCiAgICAgICAgOwoKICAgICAgICAKICAgIAo8L3NjcmlwdD4=" style="position:absolute;width:100%;height:100%;left:0;top:0;border:none !important;" allowfullscreen webkitallowfullscreen mozallowfullscreen></iframe></div></div>





<div class="notice--info" markdown="1">

## Additional Resources

* <a href="https://blog.datafiniti.co/4-reasons-you-should-use-json-instead-of-csv-2cac362f1943" target="_blank">Why you should use JSON instead of csv.</a>


* <a href="https://www.w3schools.com/js/js_json_intro.asp" target="_blank">W3schools JSON intro </a>

</div>

