---
layout: single
title: 'Programmatically Accessing Geospatial Data Using APIs'
excerpt: 'This lesson walks through the process of retrieving and manipulating surface water data housed in the Colorado Information Warehouse. These data are stored in JSON format with spatial x, y information that support mapping.'
authors: ['Carson Farmer', 'Leah Wasser', 'Max Joseph', 'Martha Morrissey', 'Jenny Palomino']
modified: 2019-09-03
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



    [{'station_name': 'SMEAD DITCH',
      'div': '1',
      'location': {'latitude': '40.211389',
       'needs_recoding': False,
       'longitude': '-105.250952'},
      'dwr_abbrev': 'SMEDITCO',
      'data_source': 'Cooperative Program of CDWR, NCWCD & SVLHWCD',
      'amount': '3.78',
      'station_type': 'Diversion',
      'wd': '5',
      'http_linkage': {'url': 'https://dwr.state.co.us/SurfaceWater/data/detail_graph.aspx?ID=SMEDITCO&MTYPE=DISCHRG'},
      'date_time': '2019-09-03T09:00:00.000',
      'county': 'BOULDER',
      'variable': 'DISCHRG',
      'stage': '0.74',
      'station_status': 'Active'},
     {'station_name': 'PECK PELLA CLOVER DITCH',
      'div': '1',
      'location': {'latitude': '40.17708',
       'needs_recoding': False,
       'longitude': '-105.178567'},
      'dwr_abbrev': 'PCKPELCO',
      'data_source': 'Cooperative SDR Program of CDWR & NCWCD',
      'amount': '1.56',
      'station_type': 'Diversion',
      'wd': '5',
      'http_linkage': {'url': 'https://dwr.state.co.us/SurfaceWater/data/detail_graph.aspx?ID=PCKPELCO&MTYPE=DISCHRG'},
      'date_time': '2019-09-03T10:00:00.000',
      'county': 'BOULDER',
      'variable': 'DISCHRG',
      'stage': '0.18',
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
      <td>SMEAD DITCH</td>
      <td>1</td>
      <td>SMEDITCO</td>
      <td>Cooperative Program of CDWR, NCWCD &amp; SVLHWCD</td>
      <td>3.78</td>
      <td>Diversion</td>
      <td>5</td>
      <td>2019-09-03T09:00:00.000</td>
      <td>BOULDER</td>
      <td>DISCHRG</td>
      <td>0.74</td>
      <td>Active</td>
      <td>40.211389</td>
      <td>False</td>
      <td>-105.250952</td>
      <td>https://dwr.state.co.us/SurfaceWater/data/deta...</td>
      <td>NaN</td>
    </tr>
    <tr>
      <td>1</td>
      <td>PECK PELLA CLOVER DITCH</td>
      <td>1</td>
      <td>PCKPELCO</td>
      <td>Cooperative SDR Program of CDWR &amp; NCWCD</td>
      <td>1.56</td>
      <td>Diversion</td>
      <td>5</td>
      <td>2019-09-03T10:00:00.000</td>
      <td>BOULDER</td>
      <td>DISCHRG</td>
      <td>0.18</td>
      <td>Active</td>
      <td>40.17708</td>
      <td>False</td>
      <td>-105.178567</td>
      <td>https://dwr.state.co.us/SurfaceWater/data/deta...</td>
      <td>NaN</td>
    </tr>
    <tr>
      <td>2</td>
      <td>TRUE AND WEBSTER DITCH</td>
      <td>1</td>
      <td>TRUDITCO</td>
      <td>Cooperative Program of CDWR, NCWCD &amp; SVLHWCD</td>
      <td>0.10</td>
      <td>Diversion</td>
      <td>5</td>
      <td>2019-09-03T10:00:00.000</td>
      <td>BOULDER</td>
      <td>DISCHRG</td>
      <td>0.09</td>
      <td>Active</td>
      <td>40.193019</td>
      <td>False</td>
      <td>-105.210388</td>
      <td>https://dwr.state.co.us/SurfaceWater/data/deta...</td>
      <td>NaN</td>
    </tr>
    <tr>
      <td>3</td>
      <td>DENIO TAYLOR DITCH</td>
      <td>1</td>
      <td>DENTAYCO</td>
      <td>Cooperative Program of CDWR, NCWCD &amp; SVLHWCD</td>
      <td>0.01</td>
      <td>Diversion</td>
      <td>5</td>
      <td>2019-09-03T10:00:00.000</td>
      <td>BOULDER</td>
      <td>DISCHRG</td>
      <td>0.02</td>
      <td>Active</td>
      <td>40.187578</td>
      <td>False</td>
      <td>-105.189191</td>
      <td>https://dwr.state.co.us/SurfaceWater/data/deta...</td>
      <td>NaN</td>
    </tr>
    <tr>
      <td>4</td>
      <td>BONUS DITCH</td>
      <td>1</td>
      <td>BONDITCO</td>
      <td>Cooperative Program of CDWR, NCWCD &amp; SVLHWCD</td>
      <td>23.91</td>
      <td>Diversion</td>
      <td>5</td>
      <td>2019-09-03T10:00:00.000</td>
      <td>BOULDER</td>
      <td>DISCHRG</td>
      <td>1.29</td>
      <td>Active</td>
      <td>40.153363</td>
      <td>False</td>
      <td>-105.088695</td>
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



    '40.211389'





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



    40.211389





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



    -105.250952





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
      <td>SMEAD DITCH</td>
      <td>1</td>
      <td>SMEDITCO</td>
      <td>Cooperative Program of CDWR, NCWCD &amp; SVLHWCD</td>
      <td>3.78</td>
      <td>Diversion</td>
      <td>5</td>
      <td>2019-09-03T09:00:00.000</td>
      <td>BOULDER</td>
      <td>DISCHRG</td>
      <td>0.74</td>
      <td>Active</td>
      <td>40.211389</td>
      <td>False</td>
      <td>-105.250952</td>
      <td>https://dwr.state.co.us/SurfaceWater/data/deta...</td>
      <td>NaN</td>
      <td>POINT (-105.250952 40.211389)</td>
    </tr>
    <tr>
      <td>1</td>
      <td>PECK PELLA CLOVER DITCH</td>
      <td>1</td>
      <td>PCKPELCO</td>
      <td>Cooperative SDR Program of CDWR &amp; NCWCD</td>
      <td>1.56</td>
      <td>Diversion</td>
      <td>5</td>
      <td>2019-09-03T10:00:00.000</td>
      <td>BOULDER</td>
      <td>DISCHRG</td>
      <td>0.18</td>
      <td>Active</td>
      <td>40.177080</td>
      <td>False</td>
      <td>-105.178567</td>
      <td>https://dwr.state.co.us/SurfaceWater/data/deta...</td>
      <td>NaN</td>
      <td>POINT (-105.178567 40.17708)</td>
    </tr>
    <tr>
      <td>2</td>
      <td>TRUE AND WEBSTER DITCH</td>
      <td>1</td>
      <td>TRUDITCO</td>
      <td>Cooperative Program of CDWR, NCWCD &amp; SVLHWCD</td>
      <td>0.10</td>
      <td>Diversion</td>
      <td>5</td>
      <td>2019-09-03T10:00:00.000</td>
      <td>BOULDER</td>
      <td>DISCHRG</td>
      <td>0.09</td>
      <td>Active</td>
      <td>40.193019</td>
      <td>False</td>
      <td>-105.210388</td>
      <td>https://dwr.state.co.us/SurfaceWater/data/deta...</td>
      <td>NaN</td>
      <td>POINT (-105.210388 40.193019)</td>
    </tr>
    <tr>
      <td>3</td>
      <td>DENIO TAYLOR DITCH</td>
      <td>1</td>
      <td>DENTAYCO</td>
      <td>Cooperative Program of CDWR, NCWCD &amp; SVLHWCD</td>
      <td>0.01</td>
      <td>Diversion</td>
      <td>5</td>
      <td>2019-09-03T10:00:00.000</td>
      <td>BOULDER</td>
      <td>DISCHRG</td>
      <td>0.02</td>
      <td>Active</td>
      <td>40.187578</td>
      <td>False</td>
      <td>-105.189191</td>
      <td>https://dwr.state.co.us/SurfaceWater/data/deta...</td>
      <td>NaN</td>
      <td>POINT (-105.189191 40.187578)</td>
    </tr>
    <tr>
      <td>4</td>
      <td>BONUS DITCH</td>
      <td>1</td>
      <td>BONDITCO</td>
      <td>Cooperative Program of CDWR, NCWCD &amp; SVLHWCD</td>
      <td>23.91</td>
      <td>Diversion</td>
      <td>5</td>
      <td>2019-09-03T10:00:00.000</td>
      <td>BOULDER</td>
      <td>DISCHRG</td>
      <td>1.29</td>
      <td>Active</td>
      <td>40.153363</td>
      <td>False</td>
      <td>-105.088695</td>
      <td>https://dwr.state.co.us/SurfaceWater/data/deta...</td>
      <td>NaN</td>
      <td>POINT (-105.088695 40.153363)</td>
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



<div style="width:100%;"><div style="position:relative;width:100%;height:0;padding-bottom:60%;"><iframe src="data:text/html;charset=utf-8;base64,PCFET0NUWVBFIGh0bWw+CjxoZWFkPiAgICAKICAgIDxtZXRhIGh0dHAtZXF1aXY9ImNvbnRlbnQtdHlwZSIgY29udGVudD0idGV4dC9odG1sOyBjaGFyc2V0PVVURi04IiAvPgogICAgCiAgICAgICAgPHNjcmlwdD4KICAgICAgICAgICAgTF9OT19UT1VDSCA9IGZhbHNlOwogICAgICAgICAgICBMX0RJU0FCTEVfM0QgPSBmYWxzZTsKICAgICAgICA8L3NjcmlwdD4KICAgIAogICAgPHNjcmlwdCBzcmM9Imh0dHBzOi8vY2RuLmpzZGVsaXZyLm5ldC9ucG0vbGVhZmxldEAxLjUuMS9kaXN0L2xlYWZsZXQuanMiPjwvc2NyaXB0PgogICAgPHNjcmlwdCBzcmM9Imh0dHBzOi8vY29kZS5qcXVlcnkuY29tL2pxdWVyeS0xLjEyLjQubWluLmpzIj48L3NjcmlwdD4KICAgIDxzY3JpcHQgc3JjPSJodHRwczovL21heGNkbi5ib290c3RyYXBjZG4uY29tL2Jvb3RzdHJhcC8zLjIuMC9qcy9ib290c3RyYXAubWluLmpzIj48L3NjcmlwdD4KICAgIDxzY3JpcHQgc3JjPSJodHRwczovL2NkbmpzLmNsb3VkZmxhcmUuY29tL2FqYXgvbGlicy9MZWFmbGV0LmF3ZXNvbWUtbWFya2Vycy8yLjAuMi9sZWFmbGV0LmF3ZXNvbWUtbWFya2Vycy5qcyI+PC9zY3JpcHQ+CiAgICA8bGluayByZWw9InN0eWxlc2hlZXQiIGhyZWY9Imh0dHBzOi8vY2RuLmpzZGVsaXZyLm5ldC9ucG0vbGVhZmxldEAxLjUuMS9kaXN0L2xlYWZsZXQuY3NzIi8+CiAgICA8bGluayByZWw9InN0eWxlc2hlZXQiIGhyZWY9Imh0dHBzOi8vbWF4Y2RuLmJvb3RzdHJhcGNkbi5jb20vYm9vdHN0cmFwLzMuMi4wL2Nzcy9ib290c3RyYXAubWluLmNzcyIvPgogICAgPGxpbmsgcmVsPSJzdHlsZXNoZWV0IiBocmVmPSJodHRwczovL21heGNkbi5ib290c3RyYXBjZG4uY29tL2Jvb3RzdHJhcC8zLjIuMC9jc3MvYm9vdHN0cmFwLXRoZW1lLm1pbi5jc3MiLz4KICAgIDxsaW5rIHJlbD0ic3R5bGVzaGVldCIgaHJlZj0iaHR0cHM6Ly9tYXhjZG4uYm9vdHN0cmFwY2RuLmNvbS9mb250LWF3ZXNvbWUvNC42LjMvY3NzL2ZvbnQtYXdlc29tZS5taW4uY3NzIi8+CiAgICA8bGluayByZWw9InN0eWxlc2hlZXQiIGhyZWY9Imh0dHBzOi8vY2RuanMuY2xvdWRmbGFyZS5jb20vYWpheC9saWJzL0xlYWZsZXQuYXdlc29tZS1tYXJrZXJzLzIuMC4yL2xlYWZsZXQuYXdlc29tZS1tYXJrZXJzLmNzcyIvPgogICAgPGxpbmsgcmVsPSJzdHlsZXNoZWV0IiBocmVmPSJodHRwczovL3Jhd2Nkbi5naXRoYWNrLmNvbS9weXRob24tdmlzdWFsaXphdGlvbi9mb2xpdW0vbWFzdGVyL2ZvbGl1bS90ZW1wbGF0ZXMvbGVhZmxldC5hd2Vzb21lLnJvdGF0ZS5jc3MiLz4KICAgIDxzdHlsZT5odG1sLCBib2R5IHt3aWR0aDogMTAwJTtoZWlnaHQ6IDEwMCU7bWFyZ2luOiAwO3BhZGRpbmc6IDA7fTwvc3R5bGU+CiAgICA8c3R5bGU+I21hcCB7cG9zaXRpb246YWJzb2x1dGU7dG9wOjA7Ym90dG9tOjA7cmlnaHQ6MDtsZWZ0OjA7fTwvc3R5bGU+CiAgICAKICAgICAgICAgICAgPG1ldGEgbmFtZT0idmlld3BvcnQiIGNvbnRlbnQ9IndpZHRoPWRldmljZS13aWR0aCwKICAgICAgICAgICAgICAgIGluaXRpYWwtc2NhbGU9MS4wLCBtYXhpbXVtLXNjYWxlPTEuMCwgdXNlci1zY2FsYWJsZT1ubyIgLz4KICAgICAgICAgICAgPHN0eWxlPgogICAgICAgICAgICAgICAgI21hcF8wNTE5YTZlOWIyZDE0YTYwOTViNTRkZmNkMWY5YzUzMSB7CiAgICAgICAgICAgICAgICAgICAgcG9zaXRpb246IHJlbGF0aXZlOwogICAgICAgICAgICAgICAgICAgIHdpZHRoOiAxMDAuMCU7CiAgICAgICAgICAgICAgICAgICAgaGVpZ2h0OiAxMDAuMCU7CiAgICAgICAgICAgICAgICAgICAgbGVmdDogMC4wJTsKICAgICAgICAgICAgICAgICAgICB0b3A6IDAuMCU7CiAgICAgICAgICAgICAgICB9CiAgICAgICAgICAgIDwvc3R5bGU+CiAgICAgICAgCjwvaGVhZD4KPGJvZHk+ICAgIAogICAgCiAgICAgICAgICAgIDxkaXYgY2xhc3M9ImZvbGl1bS1tYXAiIGlkPSJtYXBfMDUxOWE2ZTliMmQxNGE2MDk1YjU0ZGZjZDFmOWM1MzEiID48L2Rpdj4KICAgICAgICAKPC9ib2R5Pgo8c2NyaXB0PiAgICAKICAgIAogICAgICAgICAgICB2YXIgbWFwXzA1MTlhNmU5YjJkMTRhNjA5NWI1NGRmY2QxZjljNTMxID0gTC5tYXAoCiAgICAgICAgICAgICAgICAibWFwXzA1MTlhNmU5YjJkMTRhNjA5NWI1NGRmY2QxZjljNTMxIiwKICAgICAgICAgICAgICAgIHsKICAgICAgICAgICAgICAgICAgICBjZW50ZXI6IFs0MC4wMSwgLTEwNS4yN10sCiAgICAgICAgICAgICAgICAgICAgY3JzOiBMLkNSUy5FUFNHMzg1NywKICAgICAgICAgICAgICAgICAgICB6b29tOiAxMCwKICAgICAgICAgICAgICAgICAgICB6b29tQ29udHJvbDogdHJ1ZSwKICAgICAgICAgICAgICAgICAgICBwcmVmZXJDYW52YXM6IGZhbHNlLAogICAgICAgICAgICAgICAgfQogICAgICAgICAgICApOwoKICAgICAgICAgICAgCgogICAgICAgIAogICAgCiAgICAgICAgICAgIHZhciB0aWxlX2xheWVyXzJkZDZhZGMzYjUxMjQ0ZDU5ZjNiMWIxNTA5ZGU0ZDk3ID0gTC50aWxlTGF5ZXIoCiAgICAgICAgICAgICAgICAiaHR0cHM6Ly9jYXJ0b2RiLWJhc2VtYXBzLXtzfS5nbG9iYWwuc3NsLmZhc3RseS5uZXQvbGlnaHRfYWxsL3t6fS97eH0ve3l9LnBuZyIsCiAgICAgICAgICAgICAgICB7ImF0dHJpYnV0aW9uIjogIlx1MDAyNmNvcHk7IFx1MDAzY2EgaHJlZj1cImh0dHA6Ly93d3cub3BlbnN0cmVldG1hcC5vcmcvY29weXJpZ2h0XCJcdTAwM2VPcGVuU3RyZWV0TWFwXHUwMDNjL2FcdTAwM2UgY29udHJpYnV0b3JzIFx1MDAyNmNvcHk7IFx1MDAzY2EgaHJlZj1cImh0dHA6Ly9jYXJ0b2RiLmNvbS9hdHRyaWJ1dGlvbnNcIlx1MDAzZUNhcnRvREJcdTAwM2MvYVx1MDAzZSwgQ2FydG9EQiBcdTAwM2NhIGhyZWYgPVwiaHR0cDovL2NhcnRvZGIuY29tL2F0dHJpYnV0aW9uc1wiXHUwMDNlYXR0cmlidXRpb25zXHUwMDNjL2FcdTAwM2UiLCAiZGV0ZWN0UmV0aW5hIjogZmFsc2UsICJtYXhOYXRpdmVab29tIjogMTgsICJtYXhab29tIjogMTgsICJtaW5ab29tIjogMCwgIm5vV3JhcCI6IGZhbHNlLCAib3BhY2l0eSI6IDEsICJzdWJkb21haW5zIjogImFiYyIsICJ0bXMiOiBmYWxzZX0KICAgICAgICAgICAgKS5hZGRUbyhtYXBfMDUxOWE2ZTliMmQxNGE2MDk1YjU0ZGZjZDFmOWM1MzEpOwogICAgICAgIAogICAgCiAgICAgICAgZnVuY3Rpb24gZ2VvX2pzb25fOWViMTJiODE2YmExNDYzMGFlMzQwNjA5MDhiNzRjMDRfb25FYWNoRmVhdHVyZShmZWF0dXJlLCBsYXllcikgewogICAgICAgICAgICBsYXllci5vbih7CiAgICAgICAgICAgICAgICBjbGljazogZnVuY3Rpb24oZSkgewogICAgICAgICAgICAgICAgICAgIG1hcF8wNTE5YTZlOWIyZDE0YTYwOTViNTRkZmNkMWY5YzUzMS5maXRCb3VuZHMoZS50YXJnZXQuZ2V0Qm91bmRzKCkpOwogICAgICAgICAgICAgICAgfQogICAgICAgICAgICB9KTsKICAgICAgICB9OwogICAgICAgIHZhciBnZW9fanNvbl85ZWIxMmI4MTZiYTE0NjMwYWUzNDA2MDkwOGI3NGMwNCA9IEwuZ2VvSnNvbihudWxsLCB7CiAgICAgICAgICAgICAgICBvbkVhY2hGZWF0dXJlOiBnZW9fanNvbl85ZWIxMmI4MTZiYTE0NjMwYWUzNDA2MDkwOGI3NGMwNF9vbkVhY2hGZWF0dXJlLAogICAgICAgICAgICAKICAgICAgICB9KS5hZGRUbyhtYXBfMDUxOWE2ZTliMmQxNGE2MDk1YjU0ZGZjZDFmOWM1MzEpOwogICAgICAgICAgICBnZW9fanNvbl85ZWIxMmI4MTZiYTE0NjMwYWUzNDA2MDkwOGI3NGMwNC5hZGREYXRhKHsiYmJveCI6IFstMTA1LjUxNzExMSwgMzkuOTMxNTk3LCAtMTA1LjA3NTY5NTAwMDAwMDAxLCA0MC4yNjA4MjddLCAiZmVhdHVyZXMiOiBbeyJiYm94IjogWy0xMDUuMjUwOTUyLCA0MC4yMTEzODksIC0xMDUuMjUwOTUyLCA0MC4yMTEzODldLCAiZ2VvbWV0cnkiOiB7ImNvb3JkaW5hdGVzIjogWy0xMDUuMjUwOTUyLCA0MC4yMTEzODldLCAidHlwZSI6ICJQb2ludCJ9LCAiaWQiOiAiMCIsICJwcm9wZXJ0aWVzIjogeyJhbW91bnQiOiAiMy43OCIsICJjb3VudHkiOiAiQk9VTERFUiIsICJkYXRhX3NvdXJjZSI6ICJDb29wZXJhdGl2ZSBQcm9ncmFtIG9mIENEV1IsIE5DV0NEIFx1MDAyNiBTVkxIV0NEIiwgImRhdGVfdGltZSI6ICIyMDE5LTA5LTAzVDA5OjAwOjAwLjAwMCIsICJkaXYiOiAiMSIsICJkd3JfYWJicmV2IjogIlNNRURJVENPIiwgImh0dHBfbGlua2FnZS51cmwiOiAiaHR0cHM6Ly9kd3Iuc3RhdGUuY28udXMvU3VyZmFjZVdhdGVyL2RhdGEvZGV0YWlsX2dyYXBoLmFzcHg/SUQ9U01FRElUQ09cdTAwMjZNVFlQRT1ESVNDSFJHIiwgImxvY2F0aW9uLmxhdGl0dWRlIjogNDAuMjExMzg5LCAibG9jYXRpb24ubG9uZ2l0dWRlIjogLTEwNS4yNTA5NTIsICJsb2NhdGlvbi5uZWVkc19yZWNvZGluZyI6IGZhbHNlLCAic3RhZ2UiOiAiMC43NCIsICJzdGF0aW9uX25hbWUiOiAiU01FQUQgRElUQ0giLCAic3RhdGlvbl9zdGF0dXMiOiAiQWN0aXZlIiwgInN0YXRpb25fdHlwZSI6ICJEaXZlcnNpb24iLCAidXNnc19zdGF0aW9uX2lkIjogbnVsbCwgInZhcmlhYmxlIjogIkRJU0NIUkciLCAid2QiOiAiNSJ9LCAidHlwZSI6ICJGZWF0dXJlIn0sIHsiYmJveCI6IFstMTA1LjE3ODU2NywgNDAuMTc3MDgwMDAwMDAwMDA0LCAtMTA1LjE3ODU2NywgNDAuMTc3MDgwMDAwMDAwMDA0XSwgImdlb21ldHJ5IjogeyJjb29yZGluYXRlcyI6IFstMTA1LjE3ODU2NywgNDAuMTc3MDgwMDAwMDAwMDA0XSwgInR5cGUiOiAiUG9pbnQifSwgImlkIjogIjEiLCAicHJvcGVydGllcyI6IHsiYW1vdW50IjogIjEuNTYiLCAiY291bnR5IjogIkJPVUxERVIiLCAiZGF0YV9zb3VyY2UiOiAiQ29vcGVyYXRpdmUgU0RSIFByb2dyYW0gb2YgQ0RXUiBcdTAwMjYgTkNXQ0QiLCAiZGF0ZV90aW1lIjogIjIwMTktMDktMDNUMTA6MDA6MDAuMDAwIiwgImRpdiI6ICIxIiwgImR3cl9hYmJyZXYiOiAiUENLUEVMQ08iLCAiaHR0cF9saW5rYWdlLnVybCI6ICJodHRwczovL2R3ci5zdGF0ZS5jby51cy9TdXJmYWNlV2F0ZXIvZGF0YS9kZXRhaWxfZ3JhcGguYXNweD9JRD1QQ0tQRUxDT1x1MDAyNk1UWVBFPURJU0NIUkciLCAibG9jYXRpb24ubGF0aXR1ZGUiOiA0MC4xNzcwOCwgImxvY2F0aW9uLmxvbmdpdHVkZSI6IC0xMDUuMTc4NTY3LCAibG9jYXRpb24ubmVlZHNfcmVjb2RpbmciOiBmYWxzZSwgInN0YWdlIjogIjAuMTgiLCAic3RhdGlvbl9uYW1lIjogIlBFQ0sgUEVMTEEgQ0xPVkVSIERJVENIIiwgInN0YXRpb25fc3RhdHVzIjogIkFjdGl2ZSIsICJzdGF0aW9uX3R5cGUiOiAiRGl2ZXJzaW9uIiwgInVzZ3Nfc3RhdGlvbl9pZCI6IG51bGwsICJ2YXJpYWJsZSI6ICJESVNDSFJHIiwgIndkIjogIjUifSwgInR5cGUiOiAiRmVhdHVyZSJ9LCB7ImJib3giOiBbLTEwNS4yMTAzODgwMDAwMDAwMSwgNDAuMTkzMDE5LCAtMTA1LjIxMDM4ODAwMDAwMDAxLCA0MC4xOTMwMTldLCAiZ2VvbWV0cnkiOiB7ImNvb3JkaW5hdGVzIjogWy0xMDUuMjEwMzg4MDAwMDAwMDEsIDQwLjE5MzAxOV0sICJ0eXBlIjogIlBvaW50In0sICJpZCI6ICIyIiwgInByb3BlcnRpZXMiOiB7ImFtb3VudCI6ICIwLjEwIiwgImNvdW50eSI6ICJCT1VMREVSIiwgImRhdGFfc291cmNlIjogIkNvb3BlcmF0aXZlIFByb2dyYW0gb2YgQ0RXUiwgTkNXQ0QgXHUwMDI2IFNWTEhXQ0QiLCAiZGF0ZV90aW1lIjogIjIwMTktMDktMDNUMTA6MDA6MDAuMDAwIiwgImRpdiI6ICIxIiwgImR3cl9hYmJyZXYiOiAiVFJVRElUQ08iLCAiaHR0cF9saW5rYWdlLnVybCI6ICJodHRwczovL2R3ci5zdGF0ZS5jby51cy9TdXJmYWNlV2F0ZXIvZGF0YS9kZXRhaWxfZ3JhcGguYXNweD9JRD1UUlVESVRDT1x1MDAyNk1UWVBFPURJU0NIUkciLCAibG9jYXRpb24ubGF0aXR1ZGUiOiA0MC4xOTMwMTksICJsb2NhdGlvbi5sb25naXR1ZGUiOiAtMTA1LjIxMDM4OCwgImxvY2F0aW9uLm5lZWRzX3JlY29kaW5nIjogZmFsc2UsICJzdGFnZSI6ICIwLjA5IiwgInN0YXRpb25fbmFtZSI6ICJUUlVFIEFORCBXRUJTVEVSIERJVENIIiwgInN0YXRpb25fc3RhdHVzIjogIkFjdGl2ZSIsICJzdGF0aW9uX3R5cGUiOiAiRGl2ZXJzaW9uIiwgInVzZ3Nfc3RhdGlvbl9pZCI6IG51bGwsICJ2YXJpYWJsZSI6ICJESVNDSFJHIiwgIndkIjogIjUifSwgInR5cGUiOiAiRmVhdHVyZSJ9LCB7ImJib3giOiBbLTEwNS4xODkxOTEsIDQwLjE4NzU3OCwgLTEwNS4xODkxOTEsIDQwLjE4NzU3OF0sICJnZW9tZXRyeSI6IHsiY29vcmRpbmF0ZXMiOiBbLTEwNS4xODkxOTEsIDQwLjE4NzU3OF0sICJ0eXBlIjogIlBvaW50In0sICJpZCI6ICIzIiwgInByb3BlcnRpZXMiOiB7ImFtb3VudCI6ICIwLjAxIiwgImNvdW50eSI6ICJCT1VMREVSIiwgImRhdGFfc291cmNlIjogIkNvb3BlcmF0aXZlIFByb2dyYW0gb2YgQ0RXUiwgTkNXQ0QgXHUwMDI2IFNWTEhXQ0QiLCAiZGF0ZV90aW1lIjogIjIwMTktMDktMDNUMTA6MDA6MDAuMDAwIiwgImRpdiI6ICIxIiwgImR3cl9hYmJyZXYiOiAiREVOVEFZQ08iLCAiaHR0cF9saW5rYWdlLnVybCI6ICJodHRwczovL2R3ci5zdGF0ZS5jby51cy9TdXJmYWNlV2F0ZXIvZGF0YS9kZXRhaWxfZ3JhcGguYXNweD9JRD1ERU5UQVlDT1x1MDAyNk1UWVBFPURJU0NIUkciLCAibG9jYXRpb24ubGF0aXR1ZGUiOiA0MC4xODc1NzgsICJsb2NhdGlvbi5sb25naXR1ZGUiOiAtMTA1LjE4OTE5MSwgImxvY2F0aW9uLm5lZWRzX3JlY29kaW5nIjogZmFsc2UsICJzdGFnZSI6ICIwLjAyIiwgInN0YXRpb25fbmFtZSI6ICJERU5JTyBUQVlMT1IgRElUQ0giLCAic3RhdGlvbl9zdGF0dXMiOiAiQWN0aXZlIiwgInN0YXRpb25fdHlwZSI6ICJEaXZlcnNpb24iLCAidXNnc19zdGF0aW9uX2lkIjogbnVsbCwgInZhcmlhYmxlIjogIkRJU0NIUkciLCAid2QiOiAiNSJ9LCAidHlwZSI6ICJGZWF0dXJlIn0sIHsiYmJveCI6IFstMTA1LjA4ODY5NSwgNDAuMTUzMzYzLCAtMTA1LjA4ODY5NSwgNDAuMTUzMzYzXSwgImdlb21ldHJ5IjogeyJjb29yZGluYXRlcyI6IFstMTA1LjA4ODY5NSwgNDAuMTUzMzYzXSwgInR5cGUiOiAiUG9pbnQifSwgImlkIjogIjQiLCAicHJvcGVydGllcyI6IHsiYW1vdW50IjogIjIzLjkxIiwgImNvdW50eSI6ICJCT1VMREVSIiwgImRhdGFfc291cmNlIjogIkNvb3BlcmF0aXZlIFByb2dyYW0gb2YgQ0RXUiwgTkNXQ0QgXHUwMDI2IFNWTEhXQ0QiLCAiZGF0ZV90aW1lIjogIjIwMTktMDktMDNUMTA6MDA6MDAuMDAwIiwgImRpdiI6ICIxIiwgImR3cl9hYmJyZXYiOiAiQk9ORElUQ08iLCAiaHR0cF9saW5rYWdlLnVybCI6ICJodHRwczovL2R3ci5zdGF0ZS5jby51cy9TdXJmYWNlV2F0ZXIvZGF0YS9kZXRhaWxfZ3JhcGguYXNweD9JRD1CT05ESVRDT1x1MDAyNk1UWVBFPURJU0NIUkciLCAibG9jYXRpb24ubGF0aXR1ZGUiOiA0MC4xNTMzNjMsICJsb2NhdGlvbi5sb25naXR1ZGUiOiAtMTA1LjA4ODY5NSwgImxvY2F0aW9uLm5lZWRzX3JlY29kaW5nIjogZmFsc2UsICJzdGFnZSI6ICIxLjI5IiwgInN0YXRpb25fbmFtZSI6ICJCT05VUyBESVRDSCIsICJzdGF0aW9uX3N0YXR1cyI6ICJBY3RpdmUiLCAic3RhdGlvbl90eXBlIjogIkRpdmVyc2lvbiIsICJ1c2dzX3N0YXRpb25faWQiOiBudWxsLCAidmFyaWFibGUiOiAiRElTQ0hSRyIsICJ3ZCI6ICI1In0sICJ0eXBlIjogIkZlYXR1cmUifSwgeyJiYm94IjogWy0xMDUuMjE3NTE5LCA0MC4wODYyNzgsIC0xMDUuMjE3NTE5LCA0MC4wODYyNzhdLCAiZ2VvbWV0cnkiOiB7ImNvb3JkaW5hdGVzIjogWy0xMDUuMjE3NTE5LCA0MC4wODYyNzhdLCAidHlwZSI6ICJQb2ludCJ9LCAiaWQiOiAiNSIsICJwcm9wZXJ0aWVzIjogeyJhbW91bnQiOiAiNjMuNjAiLCAiY291bnR5IjogIkJPVUxERVIiLCAiZGF0YV9zb3VyY2UiOiAiTm9ydGhlcm4gQ29sb3JhZG8gV2F0ZXIgQ29uc2VydmFuY3kgRGlzdHJpY3QgKERhdGEgUHJvdmlkZXIpIiwgImRhdGVfdGltZSI6ICIyMDE5LTA5LTAzVDEwOjAwOjAwLjAwMCIsICJkaXYiOiAiMSIsICJkd3JfYWJicmV2IjogIkJGQ0lORkNPIiwgImh0dHBfbGlua2FnZS51cmwiOiAiaHR0cDovL3d3dy5ub3J0aGVybndhdGVyLm9yZy9XYXRlclByb2plY3RzL0Vhc3RTbG9wZVdhdGVyRGF0YS5hc3B4IiwgImxvY2F0aW9uLmxhdGl0dWRlIjogNDAuMDg2Mjc4LCAibG9jYXRpb24ubG9uZ2l0dWRlIjogLTEwNS4yMTc1MTksICJsb2NhdGlvbi5uZWVkc19yZWNvZGluZyI6IGZhbHNlLCAic3RhZ2UiOiAiMi42MSIsICJzdGF0aW9uX25hbWUiOiAiQk9VTERFUiBSRVNFUlZPSVIgSU5MRVQiLCAic3RhdGlvbl9zdGF0dXMiOiAiQWN0aXZlIiwgInN0YXRpb25fdHlwZSI6ICJTdHJlYW0iLCAidXNnc19zdGF0aW9uX2lkIjogIkVTMTkxNiIsICJ2YXJpYWJsZSI6ICJESVNDSFJHIiwgIndkIjogIjYifSwgInR5cGUiOiAiRmVhdHVyZSJ9LCB7ImJib3giOiBbLTEwNS4zMzA4NDEsIDQwLjAwNjM4MDAwMDAwMDAxLCAtMTA1LjMzMDg0MSwgNDAuMDA2MzgwMDAwMDAwMDFdLCAiZ2VvbWV0cnkiOiB7ImNvb3JkaW5hdGVzIjogWy0xMDUuMzMwODQxLCA0MC4wMDYzODAwMDAwMDAwMV0sICJ0eXBlIjogIlBvaW50In0sICJpZCI6ICI2IiwgInByb3BlcnRpZXMiOiB7ImFtb3VudCI6ICIzNy4zMCIsICJjb3VudHkiOiAiQk9VTERFUiIsICJkYXRhX3NvdXJjZSI6ICJDby4gRGl2aXNpb24gb2YgV2F0ZXIgUmVzb3VyY2VzIiwgImRhdGVfdGltZSI6ICIyMDE5LTA5LTAzVDEwOjE1OjAwLjAwMCIsICJkaXYiOiAiMSIsICJkd3JfYWJicmV2IjogIkJPQ09ST0NPIiwgImh0dHBfbGlua2FnZS51cmwiOiAiaHR0cHM6Ly9kd3Iuc3RhdGUuY28udXMvU3VyZmFjZVdhdGVyL2RhdGEvZGV0YWlsX2dyYXBoLmFzcHg/SUQ9Qk9DT1JPQ09cdTAwMjZNVFlQRT1ESVNDSFJHIiwgImxvY2F0aW9uLmxhdGl0dWRlIjogNDAuMDA2MzgsICJsb2NhdGlvbi5sb25naXR1ZGUiOiAtMTA1LjMzMDg0MSwgImxvY2F0aW9uLm5lZWRzX3JlY29kaW5nIjogZmFsc2UsICJzdGFnZSI6ICIyLjA1IiwgInN0YXRpb25fbmFtZSI6ICJCT1VMREVSIENSRUVLIE5FQVIgT1JPREVMTCwgQ08uIiwgInN0YXRpb25fc3RhdHVzIjogIkFjdGl2ZSIsICJzdGF0aW9uX3R5cGUiOiAiU3RyZWFtIiwgInVzZ3Nfc3RhdGlvbl9pZCI6ICIwNjcyNzAwMCIsICJ2YXJpYWJsZSI6ICJESVNDSFJHIiwgIndkIjogIjYifSwgInR5cGUiOiAiRmVhdHVyZSJ9LCB7ImJib3giOiBbLTEwNS4xNjkzNzQsIDQwLjE3Mzk1LCAtMTA1LjE2OTM3NCwgNDAuMTczOTVdLCAiZ2VvbWV0cnkiOiB7ImNvb3JkaW5hdGVzIjogWy0xMDUuMTY5Mzc0LCA0MC4xNzM5NV0sICJ0eXBlIjogIlBvaW50In0sICJpZCI6ICI3IiwgInByb3BlcnRpZXMiOiB7ImFtb3VudCI6ICIzLjgxIiwgImNvdW50eSI6ICJCT1VMREVSIiwgImRhdGFfc291cmNlIjogIkNvb3BlcmF0aXZlIFByb2dyYW0gb2YgQ0RXUiwgTkNXQ0QgXHUwMDI2IFNWTEhXQ0QiLCAiZGF0ZV90aW1lIjogIjIwMTktMDktMDNUMDk6MzA6MDAuMDAwIiwgImRpdiI6ICIxIiwgImR3cl9hYmJyZXYiOiAiTklXRElUQ08iLCAiaHR0cF9saW5rYWdlLnVybCI6ICJodHRwczovL2R3ci5zdGF0ZS5jby51cy9TdXJmYWNlV2F0ZXIvZGF0YS9kZXRhaWxfZ3JhcGguYXNweD9JRD1OSVdESVRDT1x1MDAyNk1UWVBFPURJU0NIUkciLCAibG9jYXRpb24ubGF0aXR1ZGUiOiA0MC4xNzM5NSwgImxvY2F0aW9uLmxvbmdpdHVkZSI6IC0xMDUuMTY5Mzc0LCAibG9jYXRpb24ubmVlZHNfcmVjb2RpbmciOiBmYWxzZSwgInN0YWdlIjogIjAuNjIiLCAic3RhdGlvbl9uYW1lIjogIk5JV09UIERJVENIIiwgInN0YXRpb25fc3RhdHVzIjogIkFjdGl2ZSIsICJzdGF0aW9uX3R5cGUiOiAiRGl2ZXJzaW9uIiwgInVzZ3Nfc3RhdGlvbl9pZCI6IG51bGwsICJ2YXJpYWJsZSI6ICJESVNDSFJHIiwgIndkIjogIjUifSwgInR5cGUiOiAiRmVhdHVyZSJ9LCB7ImJib3giOiBbLTEwNS4xOTg1NjcsIDQwLjI2MDgyNywgLTEwNS4xOTg1NjcsIDQwLjI2MDgyN10sICJnZW9tZXRyeSI6IHsiY29vcmRpbmF0ZXMiOiBbLTEwNS4xOTg1NjcsIDQwLjI2MDgyN10sICJ0eXBlIjogIlBvaW50In0sICJpZCI6ICI4IiwgInByb3BlcnRpZXMiOiB7ImFtb3VudCI6ICIyLjIyIiwgImNvdW50eSI6ICJCT1VMREVSIiwgImRhdGFfc291cmNlIjogIkNvb3BlcmF0aXZlIFNEUiBQcm9ncmFtIG9mIENEV1IgXHUwMDI2IE5DV0NEIiwgImRhdGVfdGltZSI6ICIyMDE5LTA5LTAzVDEwOjAwOjAwLjAwMCIsICJkaXYiOiAiMSIsICJkd3JfYWJicmV2IjogIkNVTERJVENPIiwgImh0dHBfbGlua2FnZS51cmwiOiAiaHR0cHM6Ly9kd3Iuc3RhdGUuY28udXMvU3VyZmFjZVdhdGVyL2RhdGEvZGV0YWlsX2dyYXBoLmFzcHg/SUQ9Q1VMRElUQ09cdTAwMjZNVFlQRT1ESVNDSFJHIiwgImxvY2F0aW9uLmxhdGl0dWRlIjogNDAuMjYwODI3LCAibG9jYXRpb24ubG9uZ2l0dWRlIjogLTEwNS4xOTg1NjcsICJsb2NhdGlvbi5uZWVkc19yZWNvZGluZyI6IGZhbHNlLCAic3RhZ2UiOiAiMC4yNSIsICJzdGF0aW9uX25hbWUiOiAiQ1VMVkVSIERJVENIIiwgInN0YXRpb25fc3RhdHVzIjogIkFjdGl2ZSIsICJzdGF0aW9uX3R5cGUiOiAiRGl2ZXJzaW9uIiwgInVzZ3Nfc3RhdGlvbl9pZCI6IG51bGwsICJ2YXJpYWJsZSI6ICJESVNDSFJHIiwgIndkIjogIjQifSwgInR5cGUiOiAiRmVhdHVyZSJ9LCB7ImJib3giOiBbLTEwNS4yNTE4MjYsIDQwLjIxMjUwNSwgLTEwNS4yNTE4MjYsIDQwLjIxMjUwNV0sICJnZW9tZXRyeSI6IHsiY29vcmRpbmF0ZXMiOiBbLTEwNS4yNTE4MjYsIDQwLjIxMjUwNV0sICJ0eXBlIjogIlBvaW50In0sICJpZCI6ICI5IiwgInByb3BlcnRpZXMiOiB7ImFtb3VudCI6ICIwLjI3IiwgImNvdW50eSI6ICJCT1VMREVSIiwgImRhdGFfc291cmNlIjogIkNvb3BlcmF0aXZlIFByb2dyYW0gb2YgQ0RXUiwgTkNXQ0QgXHUwMDI2IFNWTEhXQ0QiLCAiZGF0ZV90aW1lIjogIjIwMTktMDktMDNUMTA6MDA6MDAuMDAwIiwgImRpdiI6ICIxIiwgImR3cl9hYmJyZXYiOiAiUEFMRElUQ08iLCAiaHR0cF9saW5rYWdlLnVybCI6ICJodHRwczovL2R3ci5zdGF0ZS5jby51cy9TdXJmYWNlV2F0ZXIvZGF0YS9kZXRhaWxfZ3JhcGguYXNweD9JRD1QQUxESVRDT1x1MDAyNk1UWVBFPURJU0NIUkciLCAibG9jYXRpb24ubGF0aXR1ZGUiOiA0MC4yMTI1MDUsICJsb2NhdGlvbi5sb25naXR1ZGUiOiAtMTA1LjI1MTgyNiwgImxvY2F0aW9uLm5lZWRzX3JlY29kaW5nIjogZmFsc2UsICJzdGFnZSI6ICIwLjA1IiwgInN0YXRpb25fbmFtZSI6ICJQQUxNRVJUT04gRElUQ0giLCAic3RhdGlvbl9zdGF0dXMiOiAiQWN0aXZlIiwgInN0YXRpb25fdHlwZSI6ICJEaXZlcnNpb24iLCAidXNnc19zdGF0aW9uX2lkIjogbnVsbCwgInZhcmlhYmxlIjogIkRJU0NIUkciLCAid2QiOiAiNSJ9LCAidHlwZSI6ICJGZWF0dXJlIn0sIHsiYmJveCI6IFstMTA1LjUwODQ4LCA0MC4wOTEzOTEsIC0xMDUuNTA4NDgsIDQwLjA5MTM5MV0sICJnZW9tZXRyeSI6IHsiY29vcmRpbmF0ZXMiOiBbLTEwNS41MDg0OCwgNDAuMDkxMzkxXSwgInR5cGUiOiAiUG9pbnQifSwgImlkIjogIjEwIiwgInByb3BlcnRpZXMiOiB7ImFtb3VudCI6ICIzNS40MCIsICJjb3VudHkiOiAiQk9VTERFUiIsICJkYXRhX3NvdXJjZSI6ICJDby4gRGl2aXNpb24gb2YgV2F0ZXIgUmVzb3VyY2VzIiwgImRhdGVfdGltZSI6ICIyMDE5LTA5LTAzVDA5OjMwOjAwLjAwMCIsICJkaXYiOiAiMSIsICJkd3JfYWJicmV2IjogIkxFRlRIRENPIiwgImh0dHBfbGlua2FnZS51cmwiOiAiaHR0cHM6Ly9kd3Iuc3RhdGUuY28udXMvU3VyZmFjZVdhdGVyL2RhdGEvZGV0YWlsX2dyYXBoLmFzcHg/SUQ9TEVGVEhEQ09cdTAwMjZNVFlQRT1ESVNDSFJHIiwgImxvY2F0aW9uLmxhdGl0dWRlIjogNDAuMDkxMzkxLCAibG9jYXRpb24ubG9uZ2l0dWRlIjogLTEwNS41MDg0OCwgImxvY2F0aW9uLm5lZWRzX3JlY29kaW5nIjogZmFsc2UsICJzdGFnZSI6ICIxLjYwIiwgInN0YXRpb25fbmFtZSI6ICJMRUZUIEhBTkQgRElWRVJTSU9OIE5FQVIgV0FSRCIsICJzdGF0aW9uX3N0YXR1cyI6ICJBY3RpdmUiLCAic3RhdGlvbl90eXBlIjogIkRpdmVyc2lvbiIsICJ1c2dzX3N0YXRpb25faWQiOiBudWxsLCAidmFyaWFibGUiOiAiRElTQ0hSRyIsICJ3ZCI6ICI1In0sICJ0eXBlIjogIkZlYXR1cmUifSwgeyJiYm94IjogWy0xMDUuMzU3MzA4LCAzOS45NDc3MDQsIC0xMDUuMzU3MzA4LCAzOS45NDc3MDRdLCAiZ2VvbWV0cnkiOiB7ImNvb3JkaW5hdGVzIjogWy0xMDUuMzU3MzA4LCAzOS45NDc3MDRdLCAidHlwZSI6ICJQb2ludCJ9LCAiaWQiOiAiMTEiLCAicHJvcGVydGllcyI6IHsiYW1vdW50IjogIjQxMDE0LjAwIiwgImNvdW50eSI6ICJCT1VMREVSIiwgImRhdGFfc291cmNlIjogIkNvLiBEaXZpc2lvbiBvZiBXYXRlciBSZXNvdXJjZXMiLCAiZGF0ZV90aW1lIjogIjIwMTktMDktMDNUMDk6MzA6MDAuMDAwIiwgImRpdiI6ICIxIiwgImR3cl9hYmJyZXYiOiAiR1JPU1JFQ08iLCAiaHR0cF9saW5rYWdlLnVybCI6ICJodHRwczovL2R3ci5zdGF0ZS5jby51cy9TdXJmYWNlV2F0ZXIvZGF0YS9kZXRhaWxfZ3JhcGguYXNweD9JRD1HUk9TUkVDT1x1MDAyNk1UWVBFPVNUT1JBR0UiLCAibG9jYXRpb24ubGF0aXR1ZGUiOiAzOS45NDc3MDQsICJsb2NhdGlvbi5sb25naXR1ZGUiOiAtMTA1LjM1NzMwOCwgImxvY2F0aW9uLm5lZWRzX3JlY29kaW5nIjogZmFsc2UsICJzdGFnZSI6ICI3Mjc5Ljk4IiwgInN0YXRpb25fbmFtZSI6ICJHUk9TUyBSRVNFUlZPSVIgIiwgInN0YXRpb25fc3RhdHVzIjogIkFjdGl2ZSIsICJzdGF0aW9uX3R5cGUiOiAiUmVzZXJ2b2lyIiwgInVzZ3Nfc3RhdGlvbl9pZCI6IG51bGwsICJ2YXJpYWJsZSI6ICJTVE9SQUdFIiwgIndkIjogIjYifSwgInR5cGUiOiAiRmVhdHVyZSJ9LCB7ImJib3giOiBbLTEwNS4xNzgxNDUsIDQwLjE3NzQyMywgLTEwNS4xNzgxNDUsIDQwLjE3NzQyM10sICJnZW9tZXRyeSI6IHsiY29vcmRpbmF0ZXMiOiBbLTEwNS4xNzgxNDUsIDQwLjE3NzQyM10sICJ0eXBlIjogIlBvaW50In0sICJpZCI6ICIxMiIsICJwcm9wZXJ0aWVzIjogeyJhbW91bnQiOiAiMTQuMDAiLCAiY291bnR5IjogIkJPVUxERVIiLCAiZGF0YV9zb3VyY2UiOiAiQ28uIERpdmlzaW9uIG9mIFdhdGVyIFJlc291cmNlcyIsICJkYXRlX3RpbWUiOiAiMjAxOS0wOS0wM1QwOTo0NTowMC4wMDAiLCAiZGl2IjogIjEiLCAiZHdyX2FiYnJldiI6ICJTVkNIR0lDTyIsICJodHRwX2xpbmthZ2UudXJsIjogImh0dHBzOi8vZHdyLnN0YXRlLmNvLnVzL1N1cmZhY2VXYXRlci9kYXRhL2RldGFpbF9ncmFwaC5hc3B4P0lEPVNWQ0hHSUNPXHUwMDI2TVRZUEU9RElTQ0hSRyIsICJsb2NhdGlvbi5sYXRpdHVkZSI6IDQwLjE3NzQyMywgImxvY2F0aW9uLmxvbmdpdHVkZSI6IC0xMDUuMTc4MTQ1LCAibG9jYXRpb24ubmVlZHNfcmVjb2RpbmciOiBmYWxzZSwgInN0YWdlIjogIjEuOTEiLCAic3RhdGlvbl9uYW1lIjogIlNBSU5UIFZSQUlOIENSRUVLIEFUIEhZR0lFTkUsIENPIiwgInN0YXRpb25fc3RhdHVzIjogIkFjdGl2ZSIsICJzdGF0aW9uX3R5cGUiOiAiU3RyZWFtIiwgInVzZ3Nfc3RhdGlvbl9pZCI6IG51bGwsICJ2YXJpYWJsZSI6ICJESVNDSFJHIiwgIndkIjogIjUifSwgInR5cGUiOiAiRmVhdHVyZSJ9LCB7ImJib3giOiBbLTEwNS4yNTYwMTcsIDQwLjIxNTA0MywgLTEwNS4yNTYwMTcsIDQwLjIxNTA0M10sICJnZW9tZXRyeSI6IHsiY29vcmRpbmF0ZXMiOiBbLTEwNS4yNTYwMTcsIDQwLjIxNTA0M10sICJ0eXBlIjogIlBvaW50In0sICJpZCI6ICIxMyIsICJwcm9wZXJ0aWVzIjogeyJhbW91bnQiOiAiMTQ4LjAwIiwgImNvdW50eSI6ICJCT1VMREVSIiwgImRhdGFfc291cmNlIjogIkNvLiBEaXZpc2lvbiBvZiBXYXRlciBSZXNvdXJjZXMiLCAiZGF0ZV90aW1lIjogIjIwMTktMDktMDNUMDk6MzA6MDAuMDAwIiwgImRpdiI6ICIxIiwgImR3cl9hYmJyZXYiOiAiSElHSExEQ08iLCAiaHR0cF9saW5rYWdlLnVybCI6ICJodHRwczovL2R3ci5zdGF0ZS5jby51cy9TdXJmYWNlV2F0ZXIvZGF0YS9kZXRhaWxfZ3JhcGguYXNweD9JRD1ISUdITERDT1x1MDAyNk1UWVBFPURJU0NIUkciLCAibG9jYXRpb24ubGF0aXR1ZGUiOiA0MC4yMTUwNDMsICJsb2NhdGlvbi5sb25naXR1ZGUiOiAtMTA1LjI1NjAxNywgImxvY2F0aW9uLm5lZWRzX3JlY29kaW5nIjogZmFsc2UsICJzdGFnZSI6ICIxLjc5IiwgInN0YXRpb25fbmFtZSI6ICJISUdITEFORCBESVRDSCBBVCBMWU9OUywgQ08iLCAic3RhdGlvbl9zdGF0dXMiOiAiQWN0aXZlIiwgInN0YXRpb25fdHlwZSI6ICJEaXZlcnNpb24iLCAidXNnc19zdGF0aW9uX2lkIjogbnVsbCwgInZhcmlhYmxlIjogIkRJU0NIUkciLCAid2QiOiAiNSJ9LCAidHlwZSI6ICJGZWF0dXJlIn0sIHsiYmJveCI6IFstMTA1LjM0NzkwNiwgMzkuOTM4MzUxLCAtMTA1LjM0NzkwNiwgMzkuOTM4MzUxXSwgImdlb21ldHJ5IjogeyJjb29yZGluYXRlcyI6IFstMTA1LjM0NzkwNiwgMzkuOTM4MzUxXSwgInR5cGUiOiAiUG9pbnQifSwgImlkIjogIjE0IiwgInByb3BlcnRpZXMiOiB7ImFtb3VudCI6ICIxMDkuMDAiLCAiY291bnR5IjogIkJPVUxERVIiLCAiZGF0YV9zb3VyY2UiOiAiQ28uIERpdmlzaW9uIG9mIFdhdGVyIFJlc291cmNlcyIsICJkYXRlX3RpbWUiOiAiMjAxOS0wOS0wM1QxMDoxNTowMC4wMDAiLCAiZGl2IjogIjEiLCAiZHdyX2FiYnJldiI6ICJCT0NCR1JDTyIsICJodHRwX2xpbmthZ2UudXJsIjogImh0dHBzOi8vZHdyLnN0YXRlLmNvLnVzL1N1cmZhY2VXYXRlci9kYXRhL2RldGFpbF9ncmFwaC5hc3B4P0lEPUJPQ0JHUkNPXHUwMDI2TVRZUEU9RElTQ0hSRyIsICJsb2NhdGlvbi5sYXRpdHVkZSI6IDM5LjkzODM1MSwgImxvY2F0aW9uLmxvbmdpdHVkZSI6IC0xMDUuMzQ3OTA2LCAibG9jYXRpb24ubmVlZHNfcmVjb2RpbmciOiBmYWxzZSwgInN0YWdlIjogIjEuMDYiLCAic3RhdGlvbl9uYW1lIjogIlNPVVRIIEJPVUxERVIgQ1JFRUsgQkVMT1cgR1JPU1MgUkVTRVJWT0lSIiwgInN0YXRpb25fc3RhdHVzIjogIkFjdGl2ZSIsICJzdGF0aW9uX3R5cGUiOiAiU3RyZWFtIiwgInVzZ3Nfc3RhdGlvbl9pZCI6ICIwNjcyOTQ1MCIsICJ2YXJpYWJsZSI6ICJESVNDSFJHIiwgIndkIjogIjYifSwgInR5cGUiOiAiRmVhdHVyZSJ9LCB7ImJib3giOiBbLTEwNS4xNjQzOTcsIDQwLjI1Nzg0NCwgLTEwNS4xNjQzOTcsIDQwLjI1Nzg0NF0sICJnZW9tZXRyeSI6IHsiY29vcmRpbmF0ZXMiOiBbLTEwNS4xNjQzOTcsIDQwLjI1Nzg0NF0sICJ0eXBlIjogIlBvaW50In0sICJpZCI6ICIxNSIsICJwcm9wZXJ0aWVzIjogeyJhbW91bnQiOiAiMC4xOSIsICJjb3VudHkiOiAiQk9VTERFUiIsICJkYXRhX3NvdXJjZSI6ICJDb29wZXJhdGl2ZSBTRFIgUHJvZ3JhbSBvZiBDRFdSIFx1MDAyNiBOQ1dDRCIsICJkYXRlX3RpbWUiOiAiMjAxOS0wOS0wM1QxMDowMDowMC4wMDAiLCAiZGl2IjogIjEiLCAiZHdyX2FiYnJldiI6ICJCTFdESVRDTyIsICJodHRwX2xpbmthZ2UudXJsIjogImh0dHBzOi8vZHdyLnN0YXRlLmNvLnVzL1N1cmZhY2VXYXRlci9kYXRhL2RldGFpbF9ncmFwaC5hc3B4P0lEPUJMV0RJVENPXHUwMDI2TVRZUEU9RElTQ0hSRyIsICJsb2NhdGlvbi5sYXRpdHVkZSI6IDQwLjI1Nzg0NCwgImxvY2F0aW9uLmxvbmdpdHVkZSI6IC0xMDUuMTY0Mzk3LCAibG9jYXRpb24ubmVlZHNfcmVjb2RpbmciOiBmYWxzZSwgInN0YWdlIjogIjAuMDkiLCAic3RhdGlvbl9uYW1lIjogIkJMT1dFUiBESVRDSCIsICJzdGF0aW9uX3N0YXR1cyI6ICJBY3RpdmUiLCAic3RhdGlvbl90eXBlIjogIkRpdmVyc2lvbiIsICJ1c2dzX3N0YXRpb25faWQiOiBudWxsLCAidmFyaWFibGUiOiAiRElTQ0hSRyIsICJ3ZCI6ICI0In0sICJ0eXBlIjogIkZlYXR1cmUifSwgeyJiYm94IjogWy0xMDUuMTk2Nzc1LCA0MC4xODE4OCwgLTEwNS4xOTY3NzUsIDQwLjE4MTg4XSwgImdlb21ldHJ5IjogeyJjb29yZGluYXRlcyI6IFstMTA1LjE5Njc3NSwgNDAuMTgxODhdLCAidHlwZSI6ICJQb2ludCJ9LCAiaWQiOiAiMTYiLCAicHJvcGVydGllcyI6IHsiYW1vdW50IjogIjAuMDAiLCAiY291bnR5IjogIkJPVUxERVIiLCAiZGF0YV9zb3VyY2UiOiAiQ29vcGVyYXRpdmUgUHJvZ3JhbSBvZiBDRFdSLCBOQ1dDRCBcdTAwMjYgU1ZMSFdDRCIsICJkYXRlX3RpbWUiOiAiMjAxOS0wOS0wM1QwOTo0NTowMC4wMDAiLCAiZGl2IjogIjEiLCAiZHdyX2FiYnJldiI6ICJEQVZET1dDTyIsICJodHRwX2xpbmthZ2UudXJsIjogImh0dHBzOi8vZHdyLnN0YXRlLmNvLnVzL1N1cmZhY2VXYXRlci9kYXRhL2RldGFpbF9ncmFwaC5hc3B4P0lEPURBVkRPV0NPXHUwMDI2TVRZUEU9RElTQ0hSRyIsICJsb2NhdGlvbi5sYXRpdHVkZSI6IDQwLjE4MTg4LCAibG9jYXRpb24ubG9uZ2l0dWRlIjogLTEwNS4xOTY3NzUsICJsb2NhdGlvbi5uZWVkc19yZWNvZGluZyI6IGZhbHNlLCAic3RhZ2UiOiBudWxsLCAic3RhdGlvbl9uYW1lIjogIkRBVklTIEFORCBET1dOSU5HIERJVENIIiwgInN0YXRpb25fc3RhdHVzIjogIkFjdGl2ZSIsICJzdGF0aW9uX3R5cGUiOiAiRGl2ZXJzaW9uIiwgInVzZ3Nfc3RhdGlvbl9pZCI6IG51bGwsICJ2YXJpYWJsZSI6ICJESVNDSFJHIiwgIndkIjogIjUifSwgInR5cGUiOiAiRmVhdHVyZSJ9LCB7ImJib3giOiBbLTEwNS4xNzQ5NTcsIDQwLjI1ODM2NywgLTEwNS4xNzQ5NTcsIDQwLjI1ODM2N10sICJnZW9tZXRyeSI6IHsiY29vcmRpbmF0ZXMiOiBbLTEwNS4xNzQ5NTcsIDQwLjI1ODM2N10sICJ0eXBlIjogIlBvaW50In0sICJpZCI6ICIxNyIsICJwcm9wZXJ0aWVzIjogeyJhbW91bnQiOiAiMC4wMCIsICJjb3VudHkiOiAiQk9VTERFUiIsICJkYXRhX3NvdXJjZSI6ICJDby4gRGl2aXNpb24gb2YgV2F0ZXIgUmVzb3VyY2VzIiwgImRhdGVfdGltZSI6ICIyMDE5LTA5LTAzVDA5OjMwOjAwLjAwMCIsICJkaXYiOiAiMSIsICJkd3JfYWJicmV2IjogIkJPVUxBUkNPIiwgImh0dHBfbGlua2FnZS51cmwiOiAiaHR0cHM6Ly9kd3Iuc3RhdGUuY28udXMvU3VyZmFjZVdhdGVyL2RhdGEvZGV0YWlsX2dyYXBoLmFzcHg/SUQ9Qk9VTEFSQ09cdTAwMjZNVFlQRT1ESVNDSFJHIiwgImxvY2F0aW9uLmxhdGl0dWRlIjogNDAuMjU4MzY3LCAibG9jYXRpb24ubG9uZ2l0dWRlIjogLTEwNS4xNzQ5NTcsICJsb2NhdGlvbi5uZWVkc19yZWNvZGluZyI6IGZhbHNlLCAic3RhZ2UiOiAiLTAuMTAiLCAic3RhdGlvbl9uYW1lIjogIkJPVUxERVItTEFSSU1FUiBESVRDSCBORUFSIEJFUlRIT1VEIiwgInN0YXRpb25fc3RhdHVzIjogIkFjdGl2ZSIsICJzdGF0aW9uX3R5cGUiOiAiRGl2ZXJzaW9uIiwgInVzZ3Nfc3RhdGlvbl9pZCI6IG51bGwsICJ2YXJpYWJsZSI6ICJESVNDSFJHIiwgIndkIjogIjQifSwgInR5cGUiOiAiRmVhdHVyZSJ9LCB7ImJib3giOiBbLTEwNS41MTcxMTEsIDQwLjEyOTgwNiwgLTEwNS41MTcxMTEsIDQwLjEyOTgwNl0sICJnZW9tZXRyeSI6IHsiY29vcmRpbmF0ZXMiOiBbLTEwNS41MTcxMTEsIDQwLjEyOTgwNl0sICJ0eXBlIjogIlBvaW50In0sICJpZCI6ICIxOCIsICJwcm9wZXJ0aWVzIjogeyJhbW91bnQiOiAiMTcuODAiLCAiY291bnR5IjogIkJPVUxERVIiLCAiZGF0YV9zb3VyY2UiOiAiQ28uIERpdmlzaW9uIG9mIFdhdGVyIFJlc291cmNlcyIsICJkYXRlX3RpbWUiOiAiMjAxOS0wOS0wM1QxMDowMDowMC4wMDAiLCAiZGl2IjogIjEiLCAiZHdyX2FiYnJldiI6ICJNSURTVEVDTyIsICJodHRwX2xpbmthZ2UudXJsIjogImh0dHBzOi8vZHdyLnN0YXRlLmNvLnVzL1N1cmZhY2VXYXRlci9kYXRhL2RldGFpbF9ncmFwaC5hc3B4P0lEPU1JRFNURUNPXHUwMDI2TVRZUEU9RElTQ0hSRyIsICJsb2NhdGlvbi5sYXRpdHVkZSI6IDQwLjEyOTgwNiwgImxvY2F0aW9uLmxvbmdpdHVkZSI6IC0xMDUuNTE3MTExLCAibG9jYXRpb24ubmVlZHNfcmVjb2RpbmciOiBmYWxzZSwgInN0YWdlIjogIjIuNjYiLCAic3RhdGlvbl9uYW1lIjogIk1JRERMRSBTQUlOVCBWUkFJTiBBVCBQRUFDRUZVTCBWQUxMRVkiLCAic3RhdGlvbl9zdGF0dXMiOiAiQWN0aXZlIiwgInN0YXRpb25fdHlwZSI6ICJTdHJlYW0iLCAidXNnc19zdGF0aW9uX2lkIjogbnVsbCwgInZhcmlhYmxlIjogIkRJU0NIUkciLCAid2QiOiAiNSJ9LCAidHlwZSI6ICJGZWF0dXJlIn0sIHsiYmJveCI6IFstMTA1LjIyMDQ5NywgNDAuMDc4NTYsIC0xMDUuMjIwNDk3LCA0MC4wNzg1Nl0sICJnZW9tZXRyeSI6IHsiY29vcmRpbmF0ZXMiOiBbLTEwNS4yMjA0OTcsIDQwLjA3ODU2XSwgInR5cGUiOiAiUG9pbnQifSwgImlkIjogIjE5IiwgInByb3BlcnRpZXMiOiB7ImFtb3VudCI6ICI3NTU5LjUwIiwgImNvdW50eSI6ICJCT1VMREVSIiwgImRhdGFfc291cmNlIjogIk5vcnRoZXJuIENvbG9yYWRvIFdhdGVyIENvbnNlcnZhbmN5IERpc3RyaWN0IChEYXRhIFByb3ZpZGVyKSIsICJkYXRlX3RpbWUiOiAiMjAxOS0wOS0wM1QxMDowMDowMC4wMDAiLCAiZGl2IjogIjEiLCAiZHdyX2FiYnJldiI6ICJCT1VSRVNDTyIsICJodHRwX2xpbmthZ2UudXJsIjogImh0dHA6Ly93d3cubm9ydGhlcm53YXRlci5vcmcvV2F0ZXJQcm9qZWN0cy9FYXN0U2xvcGVXYXRlckRhdGEuYXNweCIsICJsb2NhdGlvbi5sYXRpdHVkZSI6IDQwLjA3ODU2LCAibG9jYXRpb24ubG9uZ2l0dWRlIjogLTEwNS4yMjA0OTcsICJsb2NhdGlvbi5uZWVkc19yZWNvZGluZyI6IGZhbHNlLCAic3RhZ2UiOiBudWxsLCAic3RhdGlvbl9uYW1lIjogIkJPVUxERVIgUkVTRVJWT0lSIiwgInN0YXRpb25fc3RhdHVzIjogIkFjdGl2ZSIsICJzdGF0aW9uX3R5cGUiOiAiUmVzZXJ2b2lyIiwgInVzZ3Nfc3RhdGlvbl9pZCI6ICJFUjE5MTQiLCAidmFyaWFibGUiOiAiU1RPUkFHRSIsICJ3ZCI6ICI2In0sICJ0eXBlIjogIkZlYXR1cmUifSwgeyJiYm94IjogWy0xMDUuMjUwOTI3LCA0MC4yMTEwODMsIC0xMDUuMjUwOTI3LCA0MC4yMTEwODNdLCAiZ2VvbWV0cnkiOiB7ImNvb3JkaW5hdGVzIjogWy0xMDUuMjUwOTI3LCA0MC4yMTEwODNdLCAidHlwZSI6ICJQb2ludCJ9LCAiaWQiOiAiMjAiLCAicHJvcGVydGllcyI6IHsiYW1vdW50IjogIjguNzEiLCAiY291bnR5IjogIkJPVUxERVIiLCAiZGF0YV9zb3VyY2UiOiAiQ29vcGVyYXRpdmUgUHJvZ3JhbSBvZiBDRFdSLCBOQ1dDRCBcdTAwMjYgU1ZMSFdDRCIsICJkYXRlX3RpbWUiOiAiMjAxOS0wOS0wM1QwOTowMDowMC4wMDAiLCAiZGl2IjogIjEiLCAiZHdyX2FiYnJldiI6ICJTV0VESVRDTyIsICJodHRwX2xpbmthZ2UudXJsIjogImh0dHBzOi8vZHdyLnN0YXRlLmNvLnVzL1N1cmZhY2VXYXRlci9kYXRhL2RldGFpbF9ncmFwaC5hc3B4P0lEPVNXRURJVENPXHUwMDI2TVRZUEU9RElTQ0hSRyIsICJsb2NhdGlvbi5sYXRpdHVkZSI6IDQwLjIxMTA4MywgImxvY2F0aW9uLmxvbmdpdHVkZSI6IC0xMDUuMjUwOTI3LCAibG9jYXRpb24ubmVlZHNfcmVjb2RpbmciOiBmYWxzZSwgInN0YWdlIjogIjAuNjgiLCAic3RhdGlvbl9uYW1lIjogIlNXRURFIERJVENIIiwgInN0YXRpb25fc3RhdHVzIjogIkFjdGl2ZSIsICJzdGF0aW9uX3R5cGUiOiAiRGl2ZXJzaW9uIiwgInVzZ3Nfc3RhdGlvbl9pZCI6IG51bGwsICJ2YXJpYWJsZSI6ICJESVNDSFJHIiwgIndkIjogIjUifSwgInR5cGUiOiAiRmVhdHVyZSJ9LCB7ImJib3giOiBbLTEwNS4xNjA4NzYsIDQwLjE3MDk5OCwgLTEwNS4xNjA4NzYsIDQwLjE3MDk5OF0sICJnZW9tZXRyeSI6IHsiY29vcmRpbmF0ZXMiOiBbLTEwNS4xNjA4NzYsIDQwLjE3MDk5OF0sICJ0eXBlIjogIlBvaW50In0sICJpZCI6ICIyMSIsICJwcm9wZXJ0aWVzIjogeyJhbW91bnQiOiAiMS4wNCIsICJjb3VudHkiOiAiQk9VTERFUiIsICJkYXRhX3NvdXJjZSI6ICJDb29wZXJhdGl2ZSBQcm9ncmFtIG9mIENEV1IsIE5DV0NEIFx1MDAyNiBTVkxIV0NEIiwgImRhdGVfdGltZSI6ICIyMDE5LTA5LTAzVDEwOjAwOjAwLjAwMCIsICJkaXYiOiAiMSIsICJkd3JfYWJicmV2IjogIlNGTERJVENPIiwgImh0dHBfbGlua2FnZS51cmwiOiAiaHR0cHM6Ly9kd3Iuc3RhdGUuY28udXMvU3VyZmFjZVdhdGVyL2RhdGEvZGV0YWlsX2dyYXBoLmFzcHg/SUQ9U0ZMRElUQ09cdTAwMjZNVFlQRT1ESVNDSFJHIiwgImxvY2F0aW9uLmxhdGl0dWRlIjogNDAuMTcwOTk4LCAibG9jYXRpb24ubG9uZ2l0dWRlIjogLTEwNS4xNjA4NzYsICJsb2NhdGlvbi5uZWVkc19yZWNvZGluZyI6IGZhbHNlLCAic3RhZ2UiOiAiMC4yMSIsICJzdGF0aW9uX25hbWUiOiAiU09VVEggRkxBVCBESVRDSCIsICJzdGF0aW9uX3N0YXR1cyI6ICJBY3RpdmUiLCAic3RhdGlvbl90eXBlIjogIkRpdmVyc2lvbiIsICJ1c2dzX3N0YXRpb25faWQiOiBudWxsLCAidmFyaWFibGUiOiAiRElTQ0hSRyIsICJ3ZCI6ICI1In0sICJ0eXBlIjogIkZlYXR1cmUifSwgeyJiYm94IjogWy0xMDUuMjEwMzksIDQwLjE5Mzc1OCwgLTEwNS4yMTAzOSwgNDAuMTkzNzU4XSwgImdlb21ldHJ5IjogeyJjb29yZGluYXRlcyI6IFstMTA1LjIxMDM5LCA0MC4xOTM3NThdLCAidHlwZSI6ICJQb2ludCJ9LCAiaWQiOiAiMjIiLCAicHJvcGVydGllcyI6IHsiYW1vdW50IjogIjEuNjQiLCAiY291bnR5IjogIkJPVUxERVIiLCAiZGF0YV9zb3VyY2UiOiAiQ29vcGVyYXRpdmUgUHJvZ3JhbSBvZiBDRFdSLCBOQ1dDRCBcdTAwMjYgU1ZMSFdDRCIsICJkYXRlX3RpbWUiOiAiMjAxOS0wOS0wM1QxMDowMDowMC4wMDAiLCAiZGl2IjogIjEiLCAiZHdyX2FiYnJldiI6ICJDTE9ESVRDTyIsICJodHRwX2xpbmthZ2UudXJsIjogImh0dHBzOi8vZHdyLnN0YXRlLmNvLnVzL1N1cmZhY2VXYXRlci9kYXRhL2RldGFpbF9ncmFwaC5hc3B4P0lEPUNMT0RJVENPXHUwMDI2TVRZUEU9RElTQ0hSRyIsICJsb2NhdGlvbi5sYXRpdHVkZSI6IDQwLjE5Mzc1OCwgImxvY2F0aW9uLmxvbmdpdHVkZSI6IC0xMDUuMjEwMzksICJsb2NhdGlvbi5uZWVkc19yZWNvZGluZyI6IGZhbHNlLCAic3RhZ2UiOiAiMC40MyIsICJzdGF0aW9uX25hbWUiOiAiQ0xPVUdIIEFORCBUUlVFIERJVENIIiwgInN0YXRpb25fc3RhdHVzIjogIkFjdGl2ZSIsICJzdGF0aW9uX3R5cGUiOiAiRGl2ZXJzaW9uIiwgInVzZ3Nfc3RhdGlvbl9pZCI6IG51bGwsICJ2YXJpYWJsZSI6ICJESVNDSFJHIiwgIndkIjogIjUifSwgInR5cGUiOiAiRmVhdHVyZSJ9LCB7ImJib3giOiBbLTEwNS4zMDg0MzIsIDM5LjkzMTgxMywgLTEwNS4zMDg0MzIsIDM5LjkzMTgxM10sICJnZW9tZXRyeSI6IHsiY29vcmRpbmF0ZXMiOiBbLTEwNS4zMDg0MzIsIDM5LjkzMTgxM10sICJ0eXBlIjogIlBvaW50In0sICJpZCI6ICIyMyIsICJwcm9wZXJ0aWVzIjogeyJhbW91bnQiOiAiOTMuNzAiLCAiY291bnR5IjogIkJPVUxERVIiLCAiZGF0YV9zb3VyY2UiOiAiQ28uIERpdmlzaW9uIG9mIFdhdGVyIFJlc291cmNlcyIsICJkYXRlX3RpbWUiOiAiMjAxOS0wOS0wM1QwOTozMDowMC4wMDAiLCAiZGl2IjogIjEiLCAiZHdyX2FiYnJldiI6ICJCT1NERUxDTyIsICJodHRwX2xpbmthZ2UudXJsIjogImh0dHBzOi8vZHdyLnN0YXRlLmNvLnVzL1N1cmZhY2VXYXRlci9kYXRhL2RldGFpbF9ncmFwaC5hc3B4P0lEPUJPU0RFTENPXHUwMDI2TVRZUEU9RElTQ0hSRyIsICJsb2NhdGlvbi5sYXRpdHVkZSI6IDM5LjkzMTgxMywgImxvY2F0aW9uLmxvbmdpdHVkZSI6IC0xMDUuMzA4NDMyLCAibG9jYXRpb24ubmVlZHNfcmVjb2RpbmciOiBmYWxzZSwgInN0YWdlIjogIjEuNTIiLCAic3RhdGlvbl9uYW1lIjogIlNPVVRIIEJPVUxERVIgQ1JFRUsgRElWRVJTSU9OIE5FQVIgRUxET1JBRE8gU1BSSU5HUyIsICJzdGF0aW9uX3N0YXR1cyI6ICJBY3RpdmUiLCAic3RhdGlvbl90eXBlIjogIkRpdmVyc2lvbiIsICJ1c2dzX3N0YXRpb25faWQiOiBudWxsLCAidmFyaWFibGUiOiAiRElTQ0hSRyIsICJ3ZCI6ICI2In0sICJ0eXBlIjogIkZlYXR1cmUifSwgeyJiYm94IjogWy0xMDUuMTkzMDQ4LCA0MC4wNTMwMzUsIC0xMDUuMTkzMDQ4LCA0MC4wNTMwMzVdLCAiZ2VvbWV0cnkiOiB7ImNvb3JkaW5hdGVzIjogWy0xMDUuMTkzMDQ4LCA0MC4wNTMwMzVdLCAidHlwZSI6ICJQb2ludCJ9LCAiaWQiOiAiMjQiLCAicHJvcGVydGllcyI6IHsiYW1vdW50IjogIjExNy42OSIsICJjb3VudHkiOiAiQk9VTERFUiIsICJkYXRhX3NvdXJjZSI6ICJOb3J0aGVybiBDb2xvcmFkbyBXYXRlciBDb25zZXJ2YW5jeSBEaXN0cmljdCAoRGF0YSBQcm92aWRlcikiLCAiZGF0ZV90aW1lIjogIjIwMTktMDktMDNUMTA6MDA6MDAuMDAwIiwgImRpdiI6ICIxIiwgImR3cl9hYmJyZXYiOiAiQkNTQ0JDQ08iLCAiaHR0cF9saW5rYWdlLnVybCI6ICJodHRwOi8vd3d3Lm5vcnRoZXJud2F0ZXIub3JnL1dhdGVyUHJvamVjdHMvRWFzdFNsb3BlV2F0ZXJEYXRhLmFzcHgiLCAibG9jYXRpb24ubGF0aXR1ZGUiOiA0MC4wNTMwMzUsICJsb2NhdGlvbi5sb25naXR1ZGUiOiAtMTA1LjE5MzA0OCwgImxvY2F0aW9uLm5lZWRzX3JlY29kaW5nIjogZmFsc2UsICJzdGFnZSI6ICIxLjk1IiwgInN0YXRpb25fbmFtZSI6ICJCT1VMREVSIENSRUVLIFNVUFBMWSBDQU5BTCBUTyBCT1VMREVSIENSRUVLIE5FQVIgQk9VTERFUiIsICJzdGF0aW9uX3N0YXR1cyI6ICJBY3RpdmUiLCAic3RhdGlvbl90eXBlIjogIkRpdmVyc2lvbiIsICJ1c2dzX3N0YXRpb25faWQiOiAiRVMxOTE3IiwgInZhcmlhYmxlIjogIkRJU0NIUkciLCAid2QiOiAiNiJ9LCAidHlwZSI6ICJGZWF0dXJlIn0sIHsiYmJveCI6IFstMTA1LjIwNjU5MiwgNDAuMTk2NDIyLCAtMTA1LjIwNjU5MiwgNDAuMTk2NDIyXSwgImdlb21ldHJ5IjogeyJjb29yZGluYXRlcyI6IFstMTA1LjIwNjU5MiwgNDAuMTk2NDIyXSwgInR5cGUiOiAiUG9pbnQifSwgImlkIjogIjI1IiwgInByb3BlcnRpZXMiOiB7ImFtb3VudCI6ICIwLjE0IiwgImNvdW50eSI6ICJCT1VMREVSIiwgImRhdGFfc291cmNlIjogIkNvb3BlcmF0aXZlIFByb2dyYW0gb2YgQ0RXUiwgTkNXQ0QgXHUwMDI2IFNWTEhXQ0QiLCAiZGF0ZV90aW1lIjogIjIwMTktMDktMDNUMDk6MDA6MDAuMDAwIiwgImRpdiI6ICIxIiwgImR3cl9hYmJyZXYiOiAiT0xJRElUQ08iLCAiaHR0cF9saW5rYWdlLnVybCI6ICJodHRwczovL2R3ci5zdGF0ZS5jby51cy9TdXJmYWNlV2F0ZXIvZGF0YS9kZXRhaWxfZ3JhcGguYXNweD9JRD1PTElESVRDT1x1MDAyNk1UWVBFPURJU0NIUkciLCAibG9jYXRpb24ubGF0aXR1ZGUiOiA0MC4xOTY0MjIsICJsb2NhdGlvbi5sb25naXR1ZGUiOiAtMTA1LjIwNjU5MiwgImxvY2F0aW9uLm5lZWRzX3JlY29kaW5nIjogZmFsc2UsICJzdGFnZSI6ICIwLjAzIiwgInN0YXRpb25fbmFtZSI6ICJPTElHQVJDSFkgRElUQ0ggRElWRVJTSU9OIiwgInN0YXRpb25fc3RhdHVzIjogIkFjdGl2ZSIsICJzdGF0aW9uX3R5cGUiOiAiRGl2ZXJzaW9uIiwgInVzZ3Nfc3RhdGlvbl9pZCI6IG51bGwsICJ2YXJpYWJsZSI6ICJESVNDSFJHIiwgIndkIjogIjUifSwgInR5cGUiOiAiRmVhdHVyZSJ9LCB7ImJib3giOiBbLTEwNS4yMTg3NzcsIDQwLjIwNDE5MywgLTEwNS4yMTg3NzcsIDQwLjIwNDE5M10sICJnZW9tZXRyeSI6IHsiY29vcmRpbmF0ZXMiOiBbLTEwNS4yMTg3NzcsIDQwLjIwNDE5M10sICJ0eXBlIjogIlBvaW50In0sICJpZCI6ICIyNiIsICJwcm9wZXJ0aWVzIjogeyJhbW91bnQiOiAiMTMuNTQiLCAiY291bnR5IjogIkJPVUxERVIiLCAiZGF0YV9zb3VyY2UiOiAiQ29vcGVyYXRpdmUgUHJvZ3JhbSBvZiBDRFdSLCBOQ1dDRCBcdTAwMjYgU1ZMSFdDRCIsICJkYXRlX3RpbWUiOiAiMjAxOS0wOS0wM1QxMDowMDowMC4wMDAiLCAiZGl2IjogIjEiLCAiZHdyX2FiYnJldiI6ICJMT05TVVBDTyIsICJodHRwX2xpbmthZ2UudXJsIjogImh0dHBzOi8vZHdyLnN0YXRlLmNvLnVzL1N1cmZhY2VXYXRlci9kYXRhL2RldGFpbF9ncmFwaC5hc3B4P0lEPUxPTlNVUENPXHUwMDI2TVRZUEU9RElTQ0hSRyIsICJsb2NhdGlvbi5sYXRpdHVkZSI6IDQwLjIwNDE5MywgImxvY2F0aW9uLmxvbmdpdHVkZSI6IC0xMDUuMjE4Nzc3LCAibG9jYXRpb24ubmVlZHNfcmVjb2RpbmciOiBmYWxzZSwgInN0YWdlIjogIjEuMDgiLCAic3RhdGlvbl9uYW1lIjogIkxPTkdNT05UIFNVUFBMWSBESVRDSCIsICJzdGF0aW9uX3N0YXR1cyI6ICJBY3RpdmUiLCAic3RhdGlvbl90eXBlIjogIkRpdmVyc2lvbiIsICJ1c2dzX3N0YXRpb25faWQiOiBudWxsLCAidmFyaWFibGUiOiAiRElTQ0hSRyIsICJ3ZCI6ICI1In0sICJ0eXBlIjogIkZlYXR1cmUifSwgeyJiYm94IjogWy0xMDUuMzI2MjUsIDQwLjAxODY2NywgLTEwNS4zMjYyNSwgNDAuMDE4NjY3XSwgImdlb21ldHJ5IjogeyJjb29yZGluYXRlcyI6IFstMTA1LjMyNjI1LCA0MC4wMTg2NjddLCAidHlwZSI6ICJQb2ludCJ9LCAiaWQiOiAiMjciLCAicHJvcGVydGllcyI6IHsiYW1vdW50IjogIjAuMjQiLCAiY291bnR5IjogIkJPVUxERVIiLCAiZGF0YV9zb3VyY2UiOiAiVS5TLiBHZW9sb2dpY2FsIFN1cnZleSAoRGF0YSBQcm92aWRlcikiLCAiZGF0ZV90aW1lIjogIjIwMTktMDktMDNUMTA6MjA6MDAuMDAwIiwgImRpdiI6ICIxIiwgImR3cl9hYmJyZXYiOiAiRk9VT1JPQ08iLCAiaHR0cF9saW5rYWdlLnVybCI6ICJodHRwczovL3dhdGVyZGF0YS51c2dzLmdvdi9ud2lzL3V2PzA2NzI3NTAwIiwgImxvY2F0aW9uLmxhdGl0dWRlIjogNDAuMDE4NjY3LCAibG9jYXRpb24ubG9uZ2l0dWRlIjogLTEwNS4zMjYyNSwgImxvY2F0aW9uLm5lZWRzX3JlY29kaW5nIjogZmFsc2UsICJzdGFnZSI6IG51bGwsICJzdGF0aW9uX25hbWUiOiAiRk9VUk1JTEUgQ1JFRUsgQVQgT1JPREVMTCwgQ08iLCAic3RhdGlvbl9zdGF0dXMiOiAiQWN0aXZlIiwgInN0YXRpb25fdHlwZSI6ICJTdHJlYW0iLCAidXNnc19zdGF0aW9uX2lkIjogIjA2NzI3NTAwIiwgInZhcmlhYmxlIjogIkRJU0NIUkciLCAid2QiOiAiNiJ9LCAidHlwZSI6ICJGZWF0dXJlIn0sIHsiYmJveCI6IFstMTA1LjI2MzQ5LCA0MC4yMjA3MDIsIC0xMDUuMjYzNDksIDQwLjIyMDcwMl0sICJnZW9tZXRyeSI6IHsiY29vcmRpbmF0ZXMiOiBbLTEwNS4yNjM0OSwgNDAuMjIwNzAyXSwgInR5cGUiOiAiUG9pbnQifSwgImlkIjogIjI4IiwgInByb3BlcnRpZXMiOiB7ImFtb3VudCI6ICI1MC4xMCIsICJjb3VudHkiOiAiQk9VTERFUiIsICJkYXRhX3NvdXJjZSI6ICJDby4gRGl2aXNpb24gb2YgV2F0ZXIgUmVzb3VyY2VzIiwgImRhdGVfdGltZSI6ICIyMDE5LTA5LTAzVDEwOjE1OjAwLjAwMCIsICJkaXYiOiAiMSIsICJkd3JfYWJicmV2IjogIlNWQ0xZT0NPIiwgImh0dHBfbGlua2FnZS51cmwiOiAiaHR0cHM6Ly9kd3Iuc3RhdGUuY28udXMvU3VyZmFjZVdhdGVyL2RhdGEvZGV0YWlsX2dyYXBoLmFzcHg/SUQ9U1ZDTFlPQ09cdTAwMjZNVFlQRT1ESVNDSFJHIiwgImxvY2F0aW9uLmxhdGl0dWRlIjogNDAuMjIwNzAyLCAibG9jYXRpb24ubG9uZ2l0dWRlIjogLTEwNS4yNjM0OSwgImxvY2F0aW9uLm5lZWRzX3JlY29kaW5nIjogZmFsc2UsICJzdGFnZSI6ICIyLjk0IiwgInN0YXRpb25fbmFtZSI6ICJTQUlOVCBWUkFJTiBDUkVFSyBBVCBMWU9OUywgQ08iLCAic3RhdGlvbl9zdGF0dXMiOiAiQWN0aXZlIiwgInN0YXRpb25fdHlwZSI6ICJTdHJlYW0iLCAidXNnc19zdGF0aW9uX2lkIjogIjA2NzI0MDAwIiwgInZhcmlhYmxlIjogIkRJU0NIUkciLCAid2QiOiAiNSJ9LCAidHlwZSI6ICJGZWF0dXJlIn0sIHsiYmJveCI6IFstMTA1LjIwOTI4MiwgNDAuMTg4NTc5LCAtMTA1LjIwOTI4MiwgNDAuMTg4NTc5XSwgImdlb21ldHJ5IjogeyJjb29yZGluYXRlcyI6IFstMTA1LjIwOTI4MiwgNDAuMTg4NTc5XSwgInR5cGUiOiAiUG9pbnQifSwgImlkIjogIjI5IiwgInByb3BlcnRpZXMiOiB7ImFtb3VudCI6ICIyLjY1IiwgImNvdW50eSI6ICJCT1VMREVSIiwgImRhdGFfc291cmNlIjogIkNvb3BlcmF0aXZlIFByb2dyYW0gb2YgQ0RXUiwgTkNXQ0QgXHUwMDI2IFNWTEhXQ0QiLCAiZGF0ZV90aW1lIjogIjIwMTktMDktMDNUMDk6NDU6MDAuMDAwIiwgImRpdiI6ICIxIiwgImR3cl9hYmJyZXYiOiAiSkFNRElUQ08iLCAiaHR0cF9saW5rYWdlLnVybCI6ICJodHRwczovL2R3ci5zdGF0ZS5jby51cy9TdXJmYWNlV2F0ZXIvZGF0YS9kZXRhaWxfZ3JhcGguYXNweD9JRD1KQU1ESVRDT1x1MDAyNk1UWVBFPURJU0NIUkciLCAibG9jYXRpb24ubGF0aXR1ZGUiOiA0MC4xODg1NzksICJsb2NhdGlvbi5sb25naXR1ZGUiOiAtMTA1LjIwOTI4MiwgImxvY2F0aW9uLm5lZWRzX3JlY29kaW5nIjogZmFsc2UsICJzdGFnZSI6ICIwLjI4IiwgInN0YXRpb25fbmFtZSI6ICJKQU1FUyBESVRDSCIsICJzdGF0aW9uX3N0YXR1cyI6ICJBY3RpdmUiLCAic3RhdGlvbl90eXBlIjogIkRpdmVyc2lvbiIsICJ1c2dzX3N0YXRpb25faWQiOiBudWxsLCAidmFyaWFibGUiOiAiRElTQ0hSRyIsICJ3ZCI6ICI1In0sICJ0eXBlIjogIkZlYXR1cmUifSwgeyJiYm94IjogWy0xMDUuMjA2Mzg2LCA0MC4yNTgwMzgsIC0xMDUuMjA2Mzg2LCA0MC4yNTgwMzhdLCAiZ2VvbWV0cnkiOiB7ImNvb3JkaW5hdGVzIjogWy0xMDUuMjA2Mzg2LCA0MC4yNTgwMzhdLCAidHlwZSI6ICJQb2ludCJ9LCAiaWQiOiAiMzAiLCAicHJvcGVydGllcyI6IHsiYW1vdW50IjogIjEuMjgiLCAiY291bnR5IjogIkJPVUxERVIiLCAiZGF0YV9zb3VyY2UiOiAiQ28uIERpdmlzaW9uIG9mIFdhdGVyIFJlc291cmNlcyIsICJkYXRlX3RpbWUiOiAiMjAxOS0wOS0wM1QwOTozMDowMC4wMDAiLCAiZGl2IjogIjEiLCAiZHdyX2FiYnJldiI6ICJMVENBTllDTyIsICJodHRwX2xpbmthZ2UudXJsIjogImh0dHBzOi8vZHdyLnN0YXRlLmNvLnVzL1N1cmZhY2VXYXRlci9kYXRhL2RldGFpbF9ncmFwaC5hc3B4P0lEPUxUQ0FOWUNPXHUwMDI2TVRZUEU9RElTQ0hSRyIsICJsb2NhdGlvbi5sYXRpdHVkZSI6IDQwLjI1ODAzOCwgImxvY2F0aW9uLmxvbmdpdHVkZSI6IC0xMDUuMjA2Mzg2LCAibG9jYXRpb24ubmVlZHNfcmVjb2RpbmciOiBmYWxzZSwgInN0YWdlIjogIjEuMDciLCAic3RhdGlvbl9uYW1lIjogIkxJVFRMRSBUSE9NUFNPTiBSSVZFUiBBVCBDQU5ZT04gTU9VVEggTkVBUiBCRVJUSE9VRCIsICJzdGF0aW9uX3N0YXR1cyI6ICJBY3RpdmUiLCAic3RhdGlvbl90eXBlIjogIlN0cmVhbSIsICJ1c2dzX3N0YXRpb25faWQiOiBudWxsLCAidmFyaWFibGUiOiAiRElTQ0hSRyIsICJ3ZCI6ICI0In0sICJ0eXBlIjogIkZlYXR1cmUifSwgeyJiYm94IjogWy0xMDUuMjA5NSwgNDAuMjU1Nzc2LCAtMTA1LjIwOTUsIDQwLjI1NTc3Nl0sICJnZW9tZXRyeSI6IHsiY29vcmRpbmF0ZXMiOiBbLTEwNS4yMDk1LCA0MC4yNTU3NzZdLCAidHlwZSI6ICJQb2ludCJ9LCAiaWQiOiAiMzEiLCAicHJvcGVydGllcyI6IHsiYW1vdW50IjogIjcuNTMiLCAiY291bnR5IjogIkJPVUxERVIiLCAiZGF0YV9zb3VyY2UiOiAiTm9ydGhlcm4gQ29sb3JhZG8gV2F0ZXIgQ29uc2VydmFuY3kgRGlzdHJpY3QgKERhdGEgUHJvdmlkZXIpIiwgImRhdGVfdGltZSI6ICIyMDE5LTA5LTAzVDEwOjAwOjAwLjAwMCIsICJkaXYiOiAiMSIsICJkd3JfYWJicmV2IjogIkxJVFRIMkNPIiwgImh0dHBfbGlua2FnZS51cmwiOiAiaHR0cDovL3d3dy5ub3J0aGVybndhdGVyLm9yZy9XYXRlclByb2plY3RzL0Vhc3RTbG9wZVdhdGVyRGF0YS5hc3B4IiwgImxvY2F0aW9uLmxhdGl0dWRlIjogNDAuMjU1Nzc2LCAibG9jYXRpb24ubG9uZ2l0dWRlIjogLTEwNS4yMDk1LCAibG9jYXRpb24ubmVlZHNfcmVjb2RpbmciOiBmYWxzZSwgInN0YWdlIjogbnVsbCwgInN0YXRpb25fbmFtZSI6ICJMSVRUTEUgVEhPTVBTT04gIzIgRElUQ0giLCAic3RhdGlvbl9zdGF0dXMiOiAiQWN0aXZlIiwgInN0YXRpb25fdHlwZSI6ICJEaXZlcnNpb24iLCAidXNnc19zdGF0aW9uX2lkIjogIkVTMTkwMCIsICJ2YXJpYWJsZSI6ICJESVNDSFJHIiwgIndkIjogIjQifSwgInR5cGUiOiAiRmVhdHVyZSJ9LCB7ImJib3giOiBbLTEwNS4xMzA4MTksIDQwLjEzNDI3OCwgLTEwNS4xMzA4MTksIDQwLjEzNDI3OF0sICJnZW9tZXRyeSI6IHsiY29vcmRpbmF0ZXMiOiBbLTEwNS4xMzA4MTksIDQwLjEzNDI3OF0sICJ0eXBlIjogIlBvaW50In0sICJpZCI6ICIzMiIsICJwcm9wZXJ0aWVzIjogeyJhbW91bnQiOiAiMy4yOSIsICJjb3VudHkiOiAiQk9VTERFUiIsICJkYXRhX3NvdXJjZSI6ICJVLlMuIEdlb2xvZ2ljYWwgU3VydmV5IChEYXRhIFByb3ZpZGVyKSIsICJkYXRlX3RpbWUiOiAiMjAxOS0wOS0wM1QxMDoxMDowMC4wMDAiLCAiZGl2IjogIjEiLCAiZHdyX2FiYnJldiI6ICJMRUZUSE9DTyIsICJodHRwX2xpbmthZ2UudXJsIjogImh0dHBzOi8vd2F0ZXJkYXRhLnVzZ3MuZ292L253aXMvdXY/MDY3MjQ5NzAiLCAibG9jYXRpb24ubGF0aXR1ZGUiOiA0MC4xMzQyNzgsICJsb2NhdGlvbi5sb25naXR1ZGUiOiAtMTA1LjEzMDgxOSwgImxvY2F0aW9uLm5lZWRzX3JlY29kaW5nIjogZmFsc2UsICJzdGFnZSI6IG51bGwsICJzdGF0aW9uX25hbWUiOiAiTEVGVCBIQU5EIENSRUVLIEFUIEhPVkVSIFJPQUQgTkVBUiBMT05HTU9OVCwgQ08iLCAic3RhdGlvbl9zdGF0dXMiOiAiQWN0aXZlIiwgInN0YXRpb25fdHlwZSI6ICJTdHJlYW0iLCAidXNnc19zdGF0aW9uX2lkIjogIjA2NzI0OTcwIiwgInZhcmlhYmxlIjogIkRJU0NIUkciLCAid2QiOiAiNSJ9LCAidHlwZSI6ICJGZWF0dXJlIn0sIHsiYmJveCI6IFstMTA1LjM2NDkxNzAwMDAwMDAyLCA0MC4wNDIwMjgsIC0xMDUuMzY0OTE3MDAwMDAwMDIsIDQwLjA0MjAyOF0sICJnZW9tZXRyeSI6IHsiY29vcmRpbmF0ZXMiOiBbLTEwNS4zNjQ5MTcwMDAwMDAwMiwgNDAuMDQyMDI4XSwgInR5cGUiOiAiUG9pbnQifSwgImlkIjogIjMzIiwgInByb3BlcnRpZXMiOiB7ImFtb3VudCI6IG51bGwsICJjb3VudHkiOiAiQk9VTERFUiIsICJkYXRhX3NvdXJjZSI6ICJVLlMuIEdlb2xvZ2ljYWwgU3VydmV5IChEYXRhIFByb3ZpZGVyKSIsICJkYXRlX3RpbWUiOiAiMTk5OS0wOS0zMFQwMDowMDowMC4wMDAiLCAiZGl2IjogIjEiLCAiZHdyX2FiYnJldiI6ICJGUk1MTVJDTyIsICJodHRwX2xpbmthZ2UudXJsIjogImh0dHBzOi8vd2F0ZXJkYXRhLnVzZ3MuZ292L253aXMvdXY/MDY3Mjc0MTAiLCAibG9jYXRpb24ubGF0aXR1ZGUiOiA0MC4wNDIwMjgsICJsb2NhdGlvbi5sb25naXR1ZGUiOiAtMTA1LjM2NDkxNywgImxvY2F0aW9uLm5lZWRzX3JlY29kaW5nIjogZmFsc2UsICJzdGFnZSI6IG51bGwsICJzdGF0aW9uX25hbWUiOiAiRk9VUk1JTEUgQ1JFRUsgQVQgTE9HQU4gTUlMTCBST0FEIE5FQVIgQ1JJU01BTiwgQ08iLCAic3RhdGlvbl9zdGF0dXMiOiAiQWN0aXZlIiwgInN0YXRpb25fdHlwZSI6ICJTdHJlYW0iLCAidXNnc19zdGF0aW9uX2lkIjogIjA2NzI3NDEwIiwgInZhcmlhYmxlIjogIkRJU0NIUkciLCAid2QiOiAiNiJ9LCAidHlwZSI6ICJGZWF0dXJlIn0sIHsiYmJveCI6IFstMTA1LjA5Nzg3MiwgNDAuMDU5ODA5LCAtMTA1LjA5Nzg3MiwgNDAuMDU5ODA5XSwgImdlb21ldHJ5IjogeyJjb29yZGluYXRlcyI6IFstMTA1LjA5Nzg3MiwgNDAuMDU5ODA5XSwgInR5cGUiOiAiUG9pbnQifSwgImlkIjogIjM0IiwgInByb3BlcnRpZXMiOiB7ImFtb3VudCI6ICI3LjczIiwgImNvdW50eSI6ICJCT1VMREVSIiwgImRhdGFfc291cmNlIjogIkNvLiBEaXZpc2lvbiBvZiBXYXRlciBSZXNvdXJjZXMiLCAiZGF0ZV90aW1lIjogIjIwMTktMDktMDNUMDk6NDU6MDAuMDAwIiwgImRpdiI6ICIxIiwgImR3cl9hYmJyZXYiOiAiQk9DMTA5Q08iLCAiaHR0cF9saW5rYWdlLnVybCI6ICJodHRwczovL2R3ci5zdGF0ZS5jby51cy9TdXJmYWNlV2F0ZXIvZGF0YS9kZXRhaWxfZ3JhcGguYXNweD9JRD1CT0MxMDlDT1x1MDAyNk1UWVBFPURJU0NIUkciLCAibG9jYXRpb24ubGF0aXR1ZGUiOiA0MC4wNTk4MDksICJsb2NhdGlvbi5sb25naXR1ZGUiOiAtMTA1LjA5Nzg3MiwgImxvY2F0aW9uLm5lZWRzX3JlY29kaW5nIjogZmFsc2UsICJzdGFnZSI6ICIxLjg0IiwgInN0YXRpb25fbmFtZSI6ICJCT1VMREVSIENSRUVLIEFUIDEwOSBTVCBORUFSIEVSSUUsIENPIiwgInN0YXRpb25fc3RhdHVzIjogIkFjdGl2ZSIsICJzdGF0aW9uX3R5cGUiOiAiU3RyZWFtIiwgInVzZ3Nfc3RhdGlvbl9pZCI6IG51bGwsICJ2YXJpYWJsZSI6ICJESVNDSFJHIiwgIndkIjogIjYifSwgInR5cGUiOiAiRmVhdHVyZSJ9LCB7ImJib3giOiBbLTEwNS4xNjc2MjIsIDQwLjE3MjkyNSwgLTEwNS4xNjc2MjIsIDQwLjE3MjkyNV0sICJnZW9tZXRyeSI6IHsiY29vcmRpbmF0ZXMiOiBbLTEwNS4xNjc2MjIsIDQwLjE3MjkyNV0sICJ0eXBlIjogIlBvaW50In0sICJpZCI6ICIzNSIsICJwcm9wZXJ0aWVzIjogeyJhbW91bnQiOiAiMS42NiIsICJjb3VudHkiOiAiQk9VTERFUiIsICJkYXRhX3NvdXJjZSI6ICJDb29wZXJhdGl2ZSBTRFIgUHJvZ3JhbSBvZiBDRFdSIFx1MDAyNiBOQ1dDRCIsICJkYXRlX3RpbWUiOiAiMjAxOS0wOS0wM1QxMDowMDowMC4wMDAiLCAiZGl2IjogIjEiLCAiZHdyX2FiYnJldiI6ICJOT1JNVVRDTyIsICJodHRwX2xpbmthZ2UudXJsIjogImh0dHBzOi8vZHdyLnN0YXRlLmNvLnVzL1N1cmZhY2VXYXRlci9kYXRhL2RldGFpbF9ncmFwaC5hc3B4P0lEPU5PUk1VVENPXHUwMDI2TVRZUEU9RElTQ0hSRyIsICJsb2NhdGlvbi5sYXRpdHVkZSI6IDQwLjE3MjkyNSwgImxvY2F0aW9uLmxvbmdpdHVkZSI6IC0xMDUuMTY3NjIyLCAibG9jYXRpb24ubmVlZHNfcmVjb2RpbmciOiBmYWxzZSwgInN0YWdlIjogIjAuNTYiLCAic3RhdGlvbl9uYW1lIjogIk5PUlRIV0VTVCBNVVRVQUwgRElUQ0giLCAic3RhdGlvbl9zdGF0dXMiOiAiQWN0aXZlIiwgInN0YXRpb25fdHlwZSI6ICJEaXZlcnNpb24iLCAidXNnc19zdGF0aW9uX2lkIjogbnVsbCwgInZhcmlhYmxlIjogIkRJU0NIUkciLCAid2QiOiAiNSJ9LCAidHlwZSI6ICJGZWF0dXJlIn0sIHsiYmJveCI6IFstMTA1LjI1OTc5NSwgNDAuMjE5MDQ2LCAtMTA1LjI1OTc5NSwgNDAuMjE5MDQ2XSwgImdlb21ldHJ5IjogeyJjb29yZGluYXRlcyI6IFstMTA1LjI1OTc5NSwgNDAuMjE5MDQ2XSwgInR5cGUiOiAiUG9pbnQifSwgImlkIjogIjM2IiwgInByb3BlcnRpZXMiOiB7ImFtb3VudCI6ICIzLjQ0IiwgImNvdW50eSI6ICJCT1VMREVSIiwgImRhdGFfc291cmNlIjogIkNvb3BlcmF0aXZlIFByb2dyYW0gb2YgQ0RXUiwgTkNXQ0QgXHUwMDI2IFNWTEhXQ0QiLCAiZGF0ZV90aW1lIjogIjIwMTktMDktMDNUMDk6NDU6MDAuMDAwIiwgImRpdiI6ICIxIiwgImR3cl9hYmJyZXYiOiAiU1VQRElUQ08iLCAiaHR0cF9saW5rYWdlLnVybCI6ICJodHRwczovL2R3ci5zdGF0ZS5jby51cy9TdXJmYWNlV2F0ZXIvZGF0YS9kZXRhaWxfZ3JhcGguYXNweD9JRD1TVVBESVRDT1x1MDAyNk1UWVBFPURJU0NIUkciLCAibG9jYXRpb24ubGF0aXR1ZGUiOiA0MC4yMTkwNDYsICJsb2NhdGlvbi5sb25naXR1ZGUiOiAtMTA1LjI1OTc5NSwgImxvY2F0aW9uLm5lZWRzX3JlY29kaW5nIjogZmFsc2UsICJzdGFnZSI6ICIwLjI3IiwgInN0YXRpb25fbmFtZSI6ICJTVVBQTFkgRElUQ0giLCAic3RhdGlvbl9zdGF0dXMiOiAiQWN0aXZlIiwgInN0YXRpb25fdHlwZSI6ICJEaXZlcnNpb24iLCAidXNnc19zdGF0aW9uX2lkIjogbnVsbCwgInZhcmlhYmxlIjogIkRJU0NIUkciLCAid2QiOiAiNSJ9LCAidHlwZSI6ICJGZWF0dXJlIn0sIHsiYmJveCI6IFstMTA1LjUxNDQ0MiwgNDAuMDkwODIwMDAwMDAwMDEsIC0xMDUuNTE0NDQyLCA0MC4wOTA4MjAwMDAwMDAwMV0sICJnZW9tZXRyeSI6IHsiY29vcmRpbmF0ZXMiOiBbLTEwNS41MTQ0NDIsIDQwLjA5MDgyMDAwMDAwMDAxXSwgInR5cGUiOiAiUG9pbnQifSwgImlkIjogIjM3IiwgInByb3BlcnRpZXMiOiB7ImFtb3VudCI6ICIzMy4zMCIsICJjb3VudHkiOiAiQk9VTERFUiIsICJkYXRhX3NvdXJjZSI6ICJDby4gRGl2aXNpb24gb2YgV2F0ZXIgUmVzb3VyY2VzIiwgImRhdGVfdGltZSI6ICIyMDE5LTA5LTAzVDA5OjMwOjAwLjAwMCIsICJkaXYiOiAiMSIsICJkd3JfYWJicmV2IjogIlNTVldBUkNPIiwgImh0dHBfbGlua2FnZS51cmwiOiAiaHR0cHM6Ly9kd3Iuc3RhdGUuY28udXMvU3VyZmFjZVdhdGVyL2RhdGEvZGV0YWlsX2dyYXBoLmFzcHg/SUQ9U1NWV0FSQ09cdTAwMjZNVFlQRT1ESVNDSFJHIiwgImxvY2F0aW9uLmxhdGl0dWRlIjogNDAuMDkwODIsICJsb2NhdGlvbi5sb25naXR1ZGUiOiAtMTA1LjUxNDQ0MiwgImxvY2F0aW9uLm5lZWRzX3JlY29kaW5nIjogZmFsc2UsICJzdGFnZSI6ICIyLjEwIiwgInN0YXRpb25fbmFtZSI6ICJTT1VUSCBTQUlOVCBWUkFJTiBORUFSIFdBUkQiLCAic3RhdGlvbl9zdGF0dXMiOiAiQWN0aXZlIiwgInN0YXRpb25fdHlwZSI6ICJTdHJlYW0iLCAidXNnc19zdGF0aW9uX2lkIjogIjA2NzIyNTAwIiwgInZhcmlhYmxlIjogIkRJU0NIUkciLCAid2QiOiAiNSJ9LCAidHlwZSI6ICJGZWF0dXJlIn0sIHsiYmJveCI6IFstMTA1LjM2NTM2NSwgNDAuMjE2MjYzLCAtMTA1LjM2NTM2NSwgNDAuMjE2MjYzXSwgImdlb21ldHJ5IjogeyJjb29yZGluYXRlcyI6IFstMTA1LjM2NTM2NSwgNDAuMjE2MjYzXSwgInR5cGUiOiAiUG9pbnQifSwgImlkIjogIjM4IiwgInByb3BlcnRpZXMiOiB7ImFtb3VudCI6ICIxNjIxNy4wMCIsICJjb3VudHkiOiAiQk9VTERFUiIsICJkYXRhX3NvdXJjZSI6ICJDby4gRGl2aXNpb24gb2YgV2F0ZXIgUmVzb3VyY2VzIiwgImRhdGVfdGltZSI6ICIyMDE5LTA5LTAzVDA5OjQ1OjAwLjAwMCIsICJkaXYiOiAiMSIsICJkd3JfYWJicmV2IjogIkJSS0RBTUNPIiwgImh0dHBfbGlua2FnZS51cmwiOiAiaHR0cHM6Ly9kd3Iuc3RhdGUuY28udXMvU3VyZmFjZVdhdGVyL2RhdGEvZGV0YWlsX2dyYXBoLmFzcHg/SUQ9QlJLREFNQ09cdTAwMjZNVFlQRT1TVE9SQUdFIiwgImxvY2F0aW9uLmxhdGl0dWRlIjogNDAuMjE2MjYzLCAibG9jYXRpb24ubG9uZ2l0dWRlIjogLTEwNS4zNjUzNjUsICJsb2NhdGlvbi5uZWVkc19yZWNvZGluZyI6IGZhbHNlLCAic3RhZ2UiOiAiNjQwMC4wOSIsICJzdGF0aW9uX25hbWUiOiAiQlVUVE9OUk9DSyAoUkFMUEggUFJJQ0UpIFJFU0VSVk9JUiIsICJzdGF0aW9uX3N0YXR1cyI6ICJBY3RpdmUiLCAic3RhdGlvbl90eXBlIjogIlJlc2Vydm9pciIsICJ1c2dzX3N0YXRpb25faWQiOiBudWxsLCAidmFyaWFibGUiOiAiU1RPUkFHRSIsICJ3ZCI6ICI1In0sICJ0eXBlIjogIkZlYXR1cmUifSwgeyJiYm94IjogWy0xMDUuMzA0OTksIDM5LjkzMTU5NywgLTEwNS4zMDQ5OSwgMzkuOTMxNTk3XSwgImdlb21ldHJ5IjogeyJjb29yZGluYXRlcyI6IFstMTA1LjMwNDk5LCAzOS45MzE1OTddLCAidHlwZSI6ICJQb2ludCJ9LCAiaWQiOiAiMzkiLCAicHJvcGVydGllcyI6IHsiYW1vdW50IjogIjI0LjAwIiwgImNvdW50eSI6ICJCT1VMREVSIiwgImRhdGFfc291cmNlIjogIkNvLiBEaXZpc2lvbiBvZiBXYXRlciBSZXNvdXJjZXMiLCAiZGF0ZV90aW1lIjogIjIwMTktMDktMDNUMTA6MTU6MDAuMDAwIiwgImRpdiI6ICIxIiwgImR3cl9hYmJyZXYiOiAiQk9DRUxTQ08iLCAiaHR0cF9saW5rYWdlLnVybCI6ICJodHRwczovL2R3ci5zdGF0ZS5jby51cy9TdXJmYWNlV2F0ZXIvZGF0YS9kZXRhaWxfZ3JhcGguYXNweD9JRD1CT0NFTFNDT1x1MDAyNk1UWVBFPURJU0NIUkciLCAibG9jYXRpb24ubGF0aXR1ZGUiOiAzOS45MzE1OTcsICJsb2NhdGlvbi5sb25naXR1ZGUiOiAtMTA1LjMwNDk5LCAibG9jYXRpb24ubmVlZHNfcmVjb2RpbmciOiBmYWxzZSwgInN0YWdlIjogIjIuMjUiLCAic3RhdGlvbl9uYW1lIjogIlNPVVRIIEJPVUxERVIgQ1JFRUsgTkVBUiBFTERPUkFETyBTUFJJTkdTLCBDTy4iLCAic3RhdGlvbl9zdGF0dXMiOiAiQWN0aXZlIiwgInN0YXRpb25fdHlwZSI6ICJTdHJlYW0iLCAidXNnc19zdGF0aW9uX2lkIjogbnVsbCwgInZhcmlhYmxlIjogIkRJU0NIUkciLCAid2QiOiAiNiJ9LCAidHlwZSI6ICJGZWF0dXJlIn0sIHsiYmJveCI6IFstMTA1LjE4NTc4OSwgNDAuMTg1MDMzLCAtMTA1LjE4NTc4OSwgNDAuMTg1MDMzXSwgImdlb21ldHJ5IjogeyJjb29yZGluYXRlcyI6IFstMTA1LjE4NTc4OSwgNDAuMTg1MDMzXSwgInR5cGUiOiAiUG9pbnQifSwgImlkIjogIjQwIiwgInByb3BlcnRpZXMiOiB7ImFtb3VudCI6ICIxMi44NCIsICJjb3VudHkiOiAiQk9VTERFUiIsICJkYXRhX3NvdXJjZSI6ICJDb29wZXJhdGl2ZSBQcm9ncmFtIG9mIENEV1IsIE5DV0NEIFx1MDAyNiBTVkxIV0NEIiwgImRhdGVfdGltZSI6ICIyMDE5LTA5LTAzVDEwOjAwOjAwLjAwMCIsICJkaXYiOiAiMSIsICJkd3JfYWJicmV2IjogIlpXRVRVUkNPIiwgImh0dHBfbGlua2FnZS51cmwiOiAiaHR0cHM6Ly9kd3Iuc3RhdGUuY28udXMvU3VyZmFjZVdhdGVyL2RhdGEvZGV0YWlsX2dyYXBoLmFzcHg/SUQ9WldFVFVSQ09cdTAwMjZNVFlQRT1ESVNDSFJHIiwgImxvY2F0aW9uLmxhdGl0dWRlIjogNDAuMTg1MDMzLCAibG9jYXRpb24ubG9uZ2l0dWRlIjogLTEwNS4xODU3ODksICJsb2NhdGlvbi5uZWVkc19yZWNvZGluZyI6IGZhbHNlLCAic3RhZ2UiOiAiMC44NyIsICJzdGF0aW9uX25hbWUiOiAiWldFQ0sgQU5EIFRVUk5FUiBESVRDSCIsICJzdGF0aW9uX3N0YXR1cyI6ICJBY3RpdmUiLCAic3RhdGlvbl90eXBlIjogIkRpdmVyc2lvbiIsICJ1c2dzX3N0YXRpb25faWQiOiBudWxsLCAidmFyaWFibGUiOiAiRElTQ0hSRyIsICJ3ZCI6ICI1In0sICJ0eXBlIjogIkZlYXR1cmUifSwgeyJiYm94IjogWy0xMDUuMDc1Njk1MDAwMDAwMDEsIDQwLjE1MzM0MSwgLTEwNS4wNzU2OTUwMDAwMDAwMSwgNDAuMTUzMzQxXSwgImdlb21ldHJ5IjogeyJjb29yZGluYXRlcyI6IFstMTA1LjA3NTY5NTAwMDAwMDAxLCA0MC4xNTMzNDFdLCAidHlwZSI6ICJQb2ludCJ9LCAiaWQiOiAiNDEiLCAicHJvcGVydGllcyI6IHsiYW1vdW50IjogIjQ2LjYwIiwgImNvdW50eSI6ICJCT1VMREVSIiwgImRhdGFfc291cmNlIjogIkNvLiBEaXZpc2lvbiBvZiBXYXRlciBSZXNvdXJjZXMiLCAiZGF0ZV90aW1lIjogIjIwMTktMDktMDNUMTA6MzA6MDAuMDAwIiwgImRpdiI6ICIxIiwgImR3cl9hYmJyZXYiOiAiU1ZDTE9QQ08iLCAiaHR0cF9saW5rYWdlLnVybCI6ICJodHRwczovL2R3ci5zdGF0ZS5jby51cy9TdXJmYWNlV2F0ZXIvZGF0YS9kZXRhaWxfZ3JhcGguYXNweD9JRD1TVkNMT1BDT1x1MDAyNk1UWVBFPURJU0NIUkciLCAibG9jYXRpb24ubGF0aXR1ZGUiOiA0MC4xNTMzNDEsICJsb2NhdGlvbi5sb25naXR1ZGUiOiAtMTA1LjA3NTY5NSwgImxvY2F0aW9uLm5lZWRzX3JlY29kaW5nIjogZmFsc2UsICJzdGFnZSI6ICIzLjY0IiwgInN0YXRpb25fbmFtZSI6ICJTQUlOVCBWUkFJTiBDUkVFSyBCRUxPVyBLRU4gUFJBVFQgQkxWRCBBVCBMT05HTU9OVCwgQ08iLCAic3RhdGlvbl9zdGF0dXMiOiAiQWN0aXZlIiwgInN0YXRpb25fdHlwZSI6ICJTdHJlYW0iLCAidXNnc19zdGF0aW9uX2lkIjogbnVsbCwgInZhcmlhYmxlIjogIkRJU0NIUkciLCAid2QiOiAiNSJ9LCAidHlwZSI6ICJGZWF0dXJlIn0sIHsiYmJveCI6IFstMTA1LjIyMjYzOSwgNDAuMTk5MzIxLCAtMTA1LjIyMjYzOSwgNDAuMTk5MzIxXSwgImdlb21ldHJ5IjogeyJjb29yZGluYXRlcyI6IFstMTA1LjIyMjYzOSwgNDAuMTk5MzIxXSwgInR5cGUiOiAiUG9pbnQifSwgImlkIjogIjQyIiwgInByb3BlcnRpZXMiOiB7ImFtb3VudCI6ICIwLjE5IiwgImNvdW50eSI6ICJCT1VMREVSIiwgImRhdGFfc291cmNlIjogIkNvb3BlcmF0aXZlIFByb2dyYW0gb2YgQ0RXUiwgTkNXQ0QgXHUwMDI2IFNWTEhXQ0QiLCAiZGF0ZV90aW1lIjogIjIwMTktMDktMDNUMDk6NDU6MDAuMDAwIiwgImRpdiI6ICIxIiwgImR3cl9hYmJyZXYiOiAiR09ESVQxQ08iLCAiaHR0cF9saW5rYWdlLnVybCI6ICJodHRwczovL2R3ci5zdGF0ZS5jby51cy9TdXJmYWNlV2F0ZXIvZGF0YS9kZXRhaWxfZ3JhcGguYXNweD9JRD1HT0RJVDFDT1x1MDAyNk1UWVBFPURJU0NIUkciLCAibG9jYXRpb24ubGF0aXR1ZGUiOiA0MC4xOTkzMjEsICJsb2NhdGlvbi5sb25naXR1ZGUiOiAtMTA1LjIyMjYzOSwgImxvY2F0aW9uLm5lZWRzX3JlY29kaW5nIjogZmFsc2UsICJzdGFnZSI6ICIwLjA5IiwgInN0YXRpb25fbmFtZSI6ICJHT1NTIERJVENIIDEiLCAic3RhdGlvbl9zdGF0dXMiOiAiQWN0aXZlIiwgInN0YXRpb25fdHlwZSI6ICJEaXZlcnNpb24iLCAidXNnc19zdGF0aW9uX2lkIjogbnVsbCwgInZhcmlhYmxlIjogIkRJU0NIUkciLCAid2QiOiAiNSJ9LCAidHlwZSI6ICJGZWF0dXJlIn0sIHsiYmJveCI6IFstMTA1LjUwNDQ0LCAzOS45NjE2NTUsIC0xMDUuNTA0NDQsIDM5Ljk2MTY1NV0sICJnZW9tZXRyeSI6IHsiY29vcmRpbmF0ZXMiOiBbLTEwNS41MDQ0NCwgMzkuOTYxNjU1XSwgInR5cGUiOiAiUG9pbnQifSwgImlkIjogIjQzIiwgInByb3BlcnRpZXMiOiB7ImFtb3VudCI6ICIyNy42MCIsICJjb3VudHkiOiAiQk9VTERFUiIsICJkYXRhX3NvdXJjZSI6ICJDby4gRGl2aXNpb24gb2YgV2F0ZXIgUmVzb3VyY2VzIiwgImRhdGVfdGltZSI6ICIyMDE5LTA5LTAzVDEwOjE1OjAwLjAwMCIsICJkaXYiOiAiMSIsICJkd3JfYWJicmV2IjogIkJPQ01JRENPIiwgImh0dHBfbGlua2FnZS51cmwiOiAiaHR0cHM6Ly9kd3Iuc3RhdGUuY28udXMvU3VyZmFjZVdhdGVyL2RhdGEvZGV0YWlsX2dyYXBoLmFzcHg/SUQ9Qk9DTUlEQ09cdTAwMjZNVFlQRT1ESVNDSFJHIiwgImxvY2F0aW9uLmxhdGl0dWRlIjogMzkuOTYxNjU1LCAibG9jYXRpb24ubG9uZ2l0dWRlIjogLTEwNS41MDQ0NCwgImxvY2F0aW9uLm5lZWRzX3JlY29kaW5nIjogZmFsc2UsICJzdGFnZSI6ICIxLjE5IiwgInN0YXRpb25fbmFtZSI6ICJNSURETEUgQk9VTERFUiBDUkVFSyBBVCBORURFUkxBTkQsIENPLiIsICJzdGF0aW9uX3N0YXR1cyI6ICJBY3RpdmUiLCAic3RhdGlvbl90eXBlIjogIlN0cmVhbSIsICJ1c2dzX3N0YXRpb25faWQiOiAiMDY3MjU1MDAiLCAidmFyaWFibGUiOiAiRElTQ0hSRyIsICJ3ZCI6ICI2In0sICJ0eXBlIjogIkZlYXR1cmUifSwgeyJiYm94IjogWy0xMDUuMzA0NDA0LCA0MC4xMjYzODksIC0xMDUuMzA0NDA0LCA0MC4xMjYzODldLCAiZ2VvbWV0cnkiOiB7ImNvb3JkaW5hdGVzIjogWy0xMDUuMzA0NDA0LCA0MC4xMjYzODldLCAidHlwZSI6ICJQb2ludCJ9LCAiaWQiOiAiNDQiLCAicHJvcGVydGllcyI6IHsiYW1vdW50IjogIjMzLjQwIiwgImNvdW50eSI6ICJCT1VMREVSIiwgImRhdGFfc291cmNlIjogIkNvLiBEaXZpc2lvbiBvZiBXYXRlciBSZXNvdXJjZXMiLCAiZGF0ZV90aW1lIjogIjIwMTktMDktMDNUMTA6MTU6MDAuMDAwIiwgImRpdiI6ICIxIiwgImR3cl9hYmJyZXYiOiAiTEVGQ1JFQ08iLCAiaHR0cF9saW5rYWdlLnVybCI6ICJodHRwczovL2R3ci5zdGF0ZS5jby51cy9TdXJmYWNlV2F0ZXIvZGF0YS9kZXRhaWxfZ3JhcGguYXNweD9JRD1MRUZDUkVDT1x1MDAyNk1UWVBFPURJU0NIUkciLCAibG9jYXRpb24ubGF0aXR1ZGUiOiA0MC4xMjYzODksICJsb2NhdGlvbi5sb25naXR1ZGUiOiAtMTA1LjMwNDQwNCwgImxvY2F0aW9uLm5lZWRzX3JlY29kaW5nIjogZmFsc2UsICJzdGFnZSI6ICIwLjg4IiwgInN0YXRpb25fbmFtZSI6ICJMRUZUIEhBTkQgQ1JFRUsgTkVBUiBCT1VMREVSLCBDTy4iLCAic3RhdGlvbl9zdGF0dXMiOiAiQWN0aXZlIiwgInN0YXRpb25fdHlwZSI6ICJTdHJlYW0iLCAidXNnc19zdGF0aW9uX2lkIjogIjA2NzI0NTAwIiwgInZhcmlhYmxlIjogIkRJU0NIUkciLCAid2QiOiAiNSJ9LCAidHlwZSI6ICJGZWF0dXJlIn0sIHsiYmJveCI6IFstMTA1LjIxODY3NywgMzkuOTg2MTY5LCAtMTA1LjIxODY3NywgMzkuOTg2MTY5XSwgImdlb21ldHJ5IjogeyJjb29yZGluYXRlcyI6IFstMTA1LjIxODY3NywgMzkuOTg2MTY5XSwgInR5cGUiOiAiUG9pbnQifSwgImlkIjogIjQ1IiwgInByb3BlcnRpZXMiOiB7ImFtb3VudCI6ICIyLjMxIiwgImNvdW50eSI6ICJCT1VMREVSIiwgImRhdGFfc291cmNlIjogIkNvb3BlcmF0aXZlIFByb2dyYW0gb2YgQ0RXUiwgTkNXQ0QgXHUwMDI2IExTUFdDRCIsICJkYXRlX3RpbWUiOiAiMjAxOS0wOS0wM1QwOTowMDowMC4wMDAiLCAiZGl2IjogIjEiLCAiZHdyX2FiYnJldiI6ICJEUllDQVJDTyIsICJodHRwX2xpbmthZ2UudXJsIjogImh0dHBzOi8vZHdyLnN0YXRlLmNvLnVzL1N1cmZhY2VXYXRlci9kYXRhL2RldGFpbF9ncmFwaC5hc3B4P0lEPURSWUNBUkNPXHUwMDI2TVRZUEU9RElTQ0hSRyIsICJsb2NhdGlvbi5sYXRpdHVkZSI6IDM5Ljk4NjE2OSwgImxvY2F0aW9uLmxvbmdpdHVkZSI6IC0xMDUuMjE4Njc3LCAibG9jYXRpb24ubmVlZHNfcmVjb2RpbmciOiBmYWxzZSwgInN0YWdlIjogIjAuMTciLCAic3RhdGlvbl9uYW1lIjogIkRSWSBDUkVFSyBDQVJSSUVSIiwgInN0YXRpb25fc3RhdHVzIjogIkFjdGl2ZSIsICJzdGF0aW9uX3R5cGUiOiAiRGl2ZXJzaW9uIiwgInVzZ3Nfc3RhdGlvbl9pZCI6IG51bGwsICJ2YXJpYWJsZSI6ICJESVNDSFJHIiwgIndkIjogIjYifSwgInR5cGUiOiAiRmVhdHVyZSJ9LCB7ImJib3giOiBbLTEwNS4yNTgxMSwgNDAuMjE4MzM1LCAtMTA1LjI1ODExLCA0MC4yMTgzMzVdLCAiZ2VvbWV0cnkiOiB7ImNvb3JkaW5hdGVzIjogWy0xMDUuMjU4MTEsIDQwLjIxODMzNV0sICJ0eXBlIjogIlBvaW50In0sICJpZCI6ICI0NiIsICJwcm9wZXJ0aWVzIjogeyJhbW91bnQiOiAiMjczLjAwIiwgImNvdW50eSI6ICJCT1VMREVSIiwgImRhdGFfc291cmNlIjogIk5vcnRoZXJuIENvbG9yYWRvIFdhdGVyIENvbnNlcnZhbmN5IERpc3RyaWN0IChTdGF0aW9uIENvb3BlcmF0b3IpIiwgImRhdGVfdGltZSI6ICIyMDE5LTA5LTAzVDA5OjMwOjAwLjAwMCIsICJkaXYiOiAiMSIsICJkd3JfYWJicmV2IjogIlNWU0xZT0NPIiwgImh0dHBfbGlua2FnZS51cmwiOiAiaHR0cHM6Ly9kd3Iuc3RhdGUuY28udXMvU3VyZmFjZVdhdGVyL2RhdGEvZGV0YWlsX2dyYXBoLmFzcHg/SUQ9U1ZTTFlPQ09cdTAwMjZNVFlQRT1ESVNDSFJHIiwgImxvY2F0aW9uLmxhdGl0dWRlIjogNDAuMjE4MzM1LCAibG9jYXRpb24ubG9uZ2l0dWRlIjogLTEwNS4yNTgxMSwgImxvY2F0aW9uLm5lZWRzX3JlY29kaW5nIjogZmFsc2UsICJzdGFnZSI6ICIyLjY1IiwgInN0YXRpb25fbmFtZSI6ICJTQUlOVCBWUkFJTiBTVVBQTFkgQ0FOQUwgTkVBUiBMWU9OUywgQ08iLCAic3RhdGlvbl9zdGF0dXMiOiAiQWN0aXZlIiwgInN0YXRpb25fdHlwZSI6ICJEaXZlcnNpb24iLCAidXNnc19zdGF0aW9uX2lkIjogbnVsbCwgInZhcmlhYmxlIjogIkRJU0NIUkciLCAid2QiOiAiNSJ9LCAidHlwZSI6ICJGZWF0dXJlIn0sIHsiYmJveCI6IFstMTA1LjIwOTQxNiwgNDAuMjU2Mjc2MDAwMDAwMDEsIC0xMDUuMjA5NDE2LCA0MC4yNTYyNzYwMDAwMDAwMV0sICJnZW9tZXRyeSI6IHsiY29vcmRpbmF0ZXMiOiBbLTEwNS4yMDk0MTYsIDQwLjI1NjI3NjAwMDAwMDAxXSwgInR5cGUiOiAiUG9pbnQifSwgImlkIjogIjQ3IiwgInByb3BlcnRpZXMiOiB7ImFtb3VudCI6ICIwLjAzIiwgImNvdW50eSI6ICJCT1VMREVSIiwgImRhdGFfc291cmNlIjogIk5vcnRoZXJuIENvbG9yYWRvIFdhdGVyIENvbnNlcnZhbmN5IERpc3RyaWN0IChEYXRhIFByb3ZpZGVyKSIsICJkYXRlX3RpbWUiOiAiMjAxOS0wOS0wM1QxMDowMDowMC4wMDAiLCAiZGl2IjogIjEiLCAiZHdyX2FiYnJldiI6ICJMSVRUSDFDTyIsICJodHRwX2xpbmthZ2UudXJsIjogImh0dHA6Ly93d3cubm9ydGhlcm53YXRlci5vcmcvV2F0ZXJQcm9qZWN0cy9FYXN0U2xvcGVXYXRlckRhdGEuYXNweCIsICJsb2NhdGlvbi5sYXRpdHVkZSI6IDQwLjI1NjI3NiwgImxvY2F0aW9uLmxvbmdpdHVkZSI6IC0xMDUuMjA5NDE2LCAibG9jYXRpb24ubmVlZHNfcmVjb2RpbmciOiBmYWxzZSwgInN0YWdlIjogIjAuMDIiLCAic3RhdGlvbl9uYW1lIjogIkxJVFRMRSBUSE9NUFNPTiAjMSBESVRDSCIsICJzdGF0aW9uX3N0YXR1cyI6ICJBY3RpdmUiLCAic3RhdGlvbl90eXBlIjogIkRpdmVyc2lvbiIsICJ1c2dzX3N0YXRpb25faWQiOiAiRVMxOTAxIiwgInZhcmlhYmxlIjogIkRJU0NIUkciLCAid2QiOiAiNCJ9LCAidHlwZSI6ICJGZWF0dXJlIn0sIHsiYmJveCI6IFstMTA1LjE3ODg3NSwgNDAuMDUxNjUyLCAtMTA1LjE3ODg3NSwgNDAuMDUxNjUyXSwgImdlb21ldHJ5IjogeyJjb29yZGluYXRlcyI6IFstMTA1LjE3ODg3NSwgNDAuMDUxNjUyXSwgInR5cGUiOiAiUG9pbnQifSwgImlkIjogIjQ4IiwgInByb3BlcnRpZXMiOiB7ImFtb3VudCI6ICIxMzguMDAiLCAiY291bnR5IjogIkJPVUxERVIiLCAiZGF0YV9zb3VyY2UiOiAiVS5TLiBHZW9sb2dpY2FsIFN1cnZleSAoRGF0YSBQcm92aWRlcikiLCAiZGF0ZV90aW1lIjogIjIwMTktMDktMDNUMTA6MTU6MDAuMDAwIiwgImRpdiI6ICIxIiwgImR3cl9hYmJyZXYiOiAiQk9DTk9SQ08iLCAiaHR0cF9saW5rYWdlLnVybCI6ICJodHRwczovL3dhdGVyZGF0YS51c2dzLmdvdi9ud2lzL3V2PzA2NzMwMjAwIiwgImxvY2F0aW9uLmxhdGl0dWRlIjogNDAuMDUxNjUyLCAibG9jYXRpb24ubG9uZ2l0dWRlIjogLTEwNS4xNzg4NzUsICJsb2NhdGlvbi5uZWVkc19yZWNvZGluZyI6IGZhbHNlLCAic3RhZ2UiOiBudWxsLCAic3RhdGlvbl9uYW1lIjogIkJPVUxERVIgQ1JFRUsgQVQgTk9SVEggNzVUSCBTVC4gTkVBUiBCT1VMREVSLCBDTyIsICJzdGF0aW9uX3N0YXR1cyI6ICJBY3RpdmUiLCAic3RhdGlvbl90eXBlIjogIlN0cmVhbSIsICJ1c2dzX3N0YXRpb25faWQiOiAiMDY3MzAyMDAiLCAidmFyaWFibGUiOiAiRElTQ0hSRyIsICJ3ZCI6ICI2In0sICJ0eXBlIjogIkZlYXR1cmUifSwgeyJiYm94IjogWy0xMDUuMzYzNDIyLCA0MC4yMTU2NTgsIC0xMDUuMzYzNDIyLCA0MC4yMTU2NThdLCAiZ2VvbWV0cnkiOiB7ImNvb3JkaW5hdGVzIjogWy0xMDUuMzYzNDIyLCA0MC4yMTU2NThdLCAidHlwZSI6ICJQb2ludCJ9LCAiaWQiOiAiNDkiLCAicHJvcGVydGllcyI6IHsiYW1vdW50IjogIjMwLjcwIiwgImNvdW50eSI6ICJCT1VMREVSIiwgImRhdGFfc291cmNlIjogIkNvLiBEaXZpc2lvbiBvZiBXYXRlciBSZXNvdXJjZXMiLCAiZGF0ZV90aW1lIjogIjIwMTktMDktMDNUMDk6NDU6MDAuMDAwIiwgImRpdiI6ICIxIiwgImR3cl9hYmJyZXYiOiAiTlNWQkJSQ08iLCAiaHR0cF9saW5rYWdlLnVybCI6ICJodHRwczovL2R3ci5zdGF0ZS5jby51cy9TdXJmYWNlV2F0ZXIvZGF0YS9kZXRhaWxfZ3JhcGguYXNweD9JRD1OU1ZCQlJDT1x1MDAyNk1UWVBFPURJU0NIUkciLCAibG9jYXRpb24ubGF0aXR1ZGUiOiA0MC4yMTU2NTgsICJsb2NhdGlvbi5sb25naXR1ZGUiOiAtMTA1LjM2MzQyMiwgImxvY2F0aW9uLm5lZWRzX3JlY29kaW5nIjogZmFsc2UsICJzdGFnZSI6ICIwLjQ0IiwgInN0YXRpb25fbmFtZSI6ICJOT1JUSCBTQUlOVCBWUkFJTiBDUkVFSyBCRUxPVyBCVVRUT05ST0NLICAoUkFMUEggUFJJQ0UpIFJFU0VSVk9JUiIsICJzdGF0aW9uX3N0YXR1cyI6ICJBY3RpdmUiLCAic3RhdGlvbl90eXBlIjogIlN0cmVhbSIsICJ1c2dzX3N0YXRpb25faWQiOiBudWxsLCAidmFyaWFibGUiOiAiRElTQ0hSRyIsICJ3ZCI6ICI1In0sICJ0eXBlIjogIkZlYXR1cmUifSwgeyJiYm94IjogWy0xMDUuMjUxODI2LCA0MC4yMTI2NTgsIC0xMDUuMjUxODI2LCA0MC4yMTI2NThdLCAiZ2VvbWV0cnkiOiB7ImNvb3JkaW5hdGVzIjogWy0xMDUuMjUxODI2LCA0MC4yMTI2NThdLCAidHlwZSI6ICJQb2ludCJ9LCAiaWQiOiAiNTAiLCAicHJvcGVydGllcyI6IHsiYW1vdW50IjogIjEwLjg0IiwgImNvdW50eSI6ICJCT1VMREVSIiwgImRhdGFfc291cmNlIjogIkNvb3BlcmF0aXZlIFByb2dyYW0gb2YgQ0RXUiwgTkNXQ0QgXHUwMDI2IFNWTEhXQ0QiLCAiZGF0ZV90aW1lIjogIjIwMTktMDktMDNUMTA6MDA6MDAuMDAwIiwgImRpdiI6ICIxIiwgImR3cl9hYmJyZXYiOiAiUk9VUkVBQ08iLCAiaHR0cF9saW5rYWdlLnVybCI6ICJodHRwczovL2R3ci5zdGF0ZS5jby51cy9TdXJmYWNlV2F0ZXIvZGF0YS9kZXRhaWxfZ3JhcGguYXNweD9JRD1ST1VSRUFDT1x1MDAyNk1UWVBFPURJU0NIUkciLCAibG9jYXRpb24ubGF0aXR1ZGUiOiA0MC4yMTI2NTgsICJsb2NhdGlvbi5sb25naXR1ZGUiOiAtMTA1LjI1MTgyNiwgImxvY2F0aW9uLm5lZWRzX3JlY29kaW5nIjogZmFsc2UsICJzdGFnZSI6ICIwLjY4IiwgInN0YXRpb25fbmFtZSI6ICJST1VHSCBBTkQgUkVBRFkgRElUQ0giLCAic3RhdGlvbl9zdGF0dXMiOiAiQWN0aXZlIiwgInN0YXRpb25fdHlwZSI6ICJEaXZlcnNpb24iLCAidXNnc19zdGF0aW9uX2lkIjogbnVsbCwgInZhcmlhYmxlIjogIkRJU0NIUkciLCAid2QiOiAiNSJ9LCAidHlwZSI6ICJGZWF0dXJlIn0sIHsiYmJveCI6IFstMTA1LjIxMDQyNCwgNDAuMTkzMjgwMDAwMDAwMDEsIC0xMDUuMjEwNDI0LCA0MC4xOTMyODAwMDAwMDAwMV0sICJnZW9tZXRyeSI6IHsiY29vcmRpbmF0ZXMiOiBbLTEwNS4yMTA0MjQsIDQwLjE5MzI4MDAwMDAwMDAxXSwgInR5cGUiOiAiUG9pbnQifSwgImlkIjogIjUxIiwgInByb3BlcnRpZXMiOiB7ImFtb3VudCI6ICIwLjI2IiwgImNvdW50eSI6ICJCT1VMREVSIiwgImRhdGFfc291cmNlIjogIkNvb3BlcmF0aXZlIFByb2dyYW0gb2YgQ0RXUiwgTkNXQ0QgXHUwMDI2IFNWTEhXQ0QiLCAiZGF0ZV90aW1lIjogIjIwMTktMDktMDNUMTA6MDA6MDAuMDAwIiwgImRpdiI6ICIxIiwgImR3cl9hYmJyZXYiOiAiV0VCRElUQ08iLCAiaHR0cF9saW5rYWdlLnVybCI6ICJodHRwczovL2R3ci5zdGF0ZS5jby51cy9TdXJmYWNlV2F0ZXIvZGF0YS9kZXRhaWxfZ3JhcGguYXNweD9JRD1XRUJESVRDT1x1MDAyNk1UWVBFPURJU0NIUkciLCAibG9jYXRpb24ubGF0aXR1ZGUiOiA0MC4xOTMyOCwgImxvY2F0aW9uLmxvbmdpdHVkZSI6IC0xMDUuMjEwNDI0LCAibG9jYXRpb24ubmVlZHNfcmVjb2RpbmciOiBmYWxzZSwgInN0YWdlIjogIjAuMTMiLCAic3RhdGlvbl9uYW1lIjogIldFQlNURVIgTUNDQVNMSU4gRElUQ0giLCAic3RhdGlvbl9zdGF0dXMiOiAiQWN0aXZlIiwgInN0YXRpb25fdHlwZSI6ICJEaXZlcnNpb24iLCAidXNnc19zdGF0aW9uX2lkIjogbnVsbCwgInZhcmlhYmxlIjogIkRJU0NIUkciLCAid2QiOiAiNSJ9LCAidHlwZSI6ICJGZWF0dXJlIn0sIHsiYmJveCI6IFstMTA1LjI1NzczNiwgNDAuMjE1OTA0LCAtMTA1LjI1NzczNiwgNDAuMjE1OTA0XSwgImdlb21ldHJ5IjogeyJjb29yZGluYXRlcyI6IFstMTA1LjI1NzczNiwgNDAuMjE1OTA0XSwgInR5cGUiOiAiUG9pbnQifSwgImlkIjogIjUyIiwgInByb3BlcnRpZXMiOiB7ImFtb3VudCI6ICIxMDMuMDAiLCAiY291bnR5IjogIkJPVUxERVIiLCAiZGF0YV9zb3VyY2UiOiAiTm9ydGhlcm4gQ29sb3JhZG8gV2F0ZXIgQ29uc2VydmFuY3kgRGlzdHJpY3QgKFN0YXRpb24gQ29vcGVyYXRvcikiLCAiZGF0ZV90aW1lIjogIjIwMTktMDktMDNUMDk6MzA6MDAuMDAwIiwgImRpdiI6ICIxIiwgImR3cl9hYmJyZXYiOiAiQkZDTFlPQ08iLCAiaHR0cF9saW5rYWdlLnVybCI6ICJodHRwczovL2R3ci5zdGF0ZS5jby51cy9TdXJmYWNlV2F0ZXIvZGF0YS9kZXRhaWxfZ3JhcGguYXNweD9JRD1CRkNMWU9DT1x1MDAyNk1UWVBFPURJU0NIUkciLCAibG9jYXRpb24ubGF0aXR1ZGUiOiA0MC4yMTU5MDQsICJsb2NhdGlvbi5sb25naXR1ZGUiOiAtMTA1LjI1NzczNiwgImxvY2F0aW9uLm5lZWRzX3JlY29kaW5nIjogZmFsc2UsICJzdGFnZSI6ICIxLjg3IiwgInN0YXRpb25fbmFtZSI6ICJCT1VMREVSIENSRUVLIEZFRURFUiBDQU5BTCBORUFSIExZT05TIiwgInN0YXRpb25fc3RhdHVzIjogIkFjdGl2ZSIsICJzdGF0aW9uX3R5cGUiOiAiRGl2ZXJzaW9uIiwgInVzZ3Nfc3RhdGlvbl9pZCI6IG51bGwsICJ2YXJpYWJsZSI6ICJESVNDSFJHIiwgIndkIjogIjUifSwgInR5cGUiOiAiRmVhdHVyZSJ9LCB7ImJib3giOiBbLTEwNS4xNjc4NzMsIDQwLjE3NDg0NCwgLTEwNS4xNjc4NzMsIDQwLjE3NDg0NF0sICJnZW9tZXRyeSI6IHsiY29vcmRpbmF0ZXMiOiBbLTEwNS4xNjc4NzMsIDQwLjE3NDg0NF0sICJ0eXBlIjogIlBvaW50In0sICJpZCI6ICI1MyIsICJwcm9wZXJ0aWVzIjogeyJhbW91bnQiOiAiMi4wMyIsICJjb3VudHkiOiAiQk9VTERFUiIsICJkYXRhX3NvdXJjZSI6ICJDb29wZXJhdGl2ZSBQcm9ncmFtIG9mIENEV1IsIE5DV0NEIFx1MDAyNiBTVkxIV0NEIiwgImRhdGVfdGltZSI6ICIyMDE5LTA5LTAzVDA5OjQ1OjAwLjAwMCIsICJkaXYiOiAiMSIsICJkd3JfYWJicmV2IjogIkhHUk1EV0NPIiwgImh0dHBfbGlua2FnZS51cmwiOiAiaHR0cHM6Ly9kd3Iuc3RhdGUuY28udXMvU3VyZmFjZVdhdGVyL2RhdGEvZGV0YWlsX2dyYXBoLmFzcHg/SUQ9SEdSTURXQ09cdTAwMjZNVFlQRT1ESVNDSFJHIiwgImxvY2F0aW9uLmxhdGl0dWRlIjogNDAuMTc0ODQ0LCAibG9jYXRpb24ubG9uZ2l0dWRlIjogLTEwNS4xNjc4NzMsICJsb2NhdGlvbi5uZWVkc19yZWNvZGluZyI6IGZhbHNlLCAic3RhZ2UiOiAiMC40NSIsICJzdGF0aW9uX25hbWUiOiAiSEFHRVIgTUVBRE9XUyBESVRDSCIsICJzdGF0aW9uX3N0YXR1cyI6ICJBY3RpdmUiLCAic3RhdGlvbl90eXBlIjogIkRpdmVyc2lvbiIsICJ1c2dzX3N0YXRpb25faWQiOiBudWxsLCAidmFyaWFibGUiOiAiRElTQ0hSRyIsICJ3ZCI6ICI1In0sICJ0eXBlIjogIkZlYXR1cmUifSwgeyJiYm94IjogWy0xMDUuMTUxMTQzLCA0MC4wNTM2NjEsIC0xMDUuMTUxMTQzLCA0MC4wNTM2NjFdLCAiZ2VvbWV0cnkiOiB7ImNvb3JkaW5hdGVzIjogWy0xMDUuMTUxMTQzLCA0MC4wNTM2NjFdLCAidHlwZSI6ICJQb2ludCJ9LCAiaWQiOiAiNTQiLCAicHJvcGVydGllcyI6IHsiYW1vdW50IjogIjIzLjI5IiwgImNvdW50eSI6ICJCT1VMREVSIiwgImRhdGFfc291cmNlIjogIkNvb3BlcmF0aXZlIFByb2dyYW0gb2YgQ0RXUiwgTkNXQ0QgXHUwMDI2IExTUFdDRCIsICJkYXRlX3RpbWUiOiAiMjAxOS0wOS0wM1QxMDowMDowMC4wMDAiLCAiZGl2IjogIjEiLCAiZHdyX2FiYnJldiI6ICJMRUdESVRDTyIsICJodHRwX2xpbmthZ2UudXJsIjogImh0dHBzOi8vZHdyLnN0YXRlLmNvLnVzL1N1cmZhY2VXYXRlci9kYXRhL2RldGFpbF9ncmFwaC5hc3B4P0lEPUxFR0RJVENPXHUwMDI2TVRZUEU9RElTQ0hSRyIsICJsb2NhdGlvbi5sYXRpdHVkZSI6IDQwLjA1MzY2MSwgImxvY2F0aW9uLmxvbmdpdHVkZSI6IC0xMDUuMTUxMTQzLCAibG9jYXRpb24ubmVlZHNfcmVjb2RpbmciOiBmYWxzZSwgInN0YWdlIjogIjAuODIiLCAic3RhdGlvbl9uYW1lIjogIkxFR0dFVFQgRElUQ0giLCAic3RhdGlvbl9zdGF0dXMiOiAiQWN0aXZlIiwgInN0YXRpb25fdHlwZSI6ICJEaXZlcnNpb24iLCAidXNnc19zdGF0aW9uX2lkIjogbnVsbCwgInZhcmlhYmxlIjogIkRJU0NIUkciLCAid2QiOiAiNiJ9LCAidHlwZSI6ICJGZWF0dXJlIn0sIHsiYmJveCI6IFstMTA1LjE4OTEzMiwgNDAuMTg3NTI0LCAtMTA1LjE4OTEzMiwgNDAuMTg3NTI0XSwgImdlb21ldHJ5IjogeyJjb29yZGluYXRlcyI6IFstMTA1LjE4OTEzMiwgNDAuMTg3NTI0XSwgInR5cGUiOiAiUG9pbnQifSwgImlkIjogIjU1IiwgInByb3BlcnRpZXMiOiB7ImFtb3VudCI6ICIwLjAwIiwgImNvdW50eSI6ICJCT1VMREVSIiwgImRhdGFfc291cmNlIjogIkNvb3BlcmF0aXZlIFByb2dyYW0gb2YgQ0RXUiwgTkNXQ0QgXHUwMDI2IFNWTEhXQ0QiLCAiZGF0ZV90aW1lIjogIjIwMTktMDktMDNUMTA6MDA6MDAuMDAwIiwgImRpdiI6ICIxIiwgImR3cl9hYmJyZXYiOiAiUlVOWU9OQ08iLCAiaHR0cF9saW5rYWdlLnVybCI6ICJodHRwczovL2R3ci5zdGF0ZS5jby51cy9TdXJmYWNlV2F0ZXIvZGF0YS9kZXRhaWxfZ3JhcGguYXNweD9JRD1SVU5ZT05DT1x1MDAyNk1UWVBFPURJU0NIUkciLCAibG9jYXRpb24ubGF0aXR1ZGUiOiA0MC4xODc1MjQsICJsb2NhdGlvbi5sb25naXR1ZGUiOiAtMTA1LjE4OTEzMiwgImxvY2F0aW9uLm5lZWRzX3JlY29kaW5nIjogZmFsc2UsICJzdGFnZSI6ICIwLjAwIiwgInN0YXRpb25fbmFtZSI6ICJSVU5ZT04gRElUQ0giLCAic3RhdGlvbl9zdGF0dXMiOiAiQWN0aXZlIiwgInN0YXRpb25fdHlwZSI6ICJEaXZlcnNpb24iLCAidXNnc19zdGF0aW9uX2lkIjogbnVsbCwgInZhcmlhYmxlIjogIkRJU0NIUkciLCAid2QiOiAiNSJ9LCAidHlwZSI6ICJGZWF0dXJlIn0sIHsiYmJveCI6IFstMTA1LjQyMjk4NSwgMzkuOTMxNjU5LCAtMTA1LjQyMjk4NSwgMzkuOTMxNjU5XSwgImdlb21ldHJ5IjogeyJjb29yZGluYXRlcyI6IFstMTA1LjQyMjk4NSwgMzkuOTMxNjU5XSwgInR5cGUiOiAiUG9pbnQifSwgImlkIjogIjU2IiwgInByb3BlcnRpZXMiOiB7ImFtb3VudCI6ICI3Ny4yMCIsICJjb3VudHkiOiAiQk9VTERFUiIsICJkYXRhX3NvdXJjZSI6ICJDby4gRGl2aXNpb24gb2YgV2F0ZXIgUmVzb3VyY2VzIiwgImRhdGVfdGltZSI6ICIyMDE5LTA5LTAzVDA5OjQ1OjAwLjAwMCIsICJkaXYiOiAiMSIsICJkd3JfYWJicmV2IjogIkJPQ1BJTkNPIiwgImh0dHBfbGlua2FnZS51cmwiOiAiaHR0cHM6Ly9kd3Iuc3RhdGUuY28udXMvU3VyZmFjZVdhdGVyL2RhdGEvZGV0YWlsX2dyYXBoLmFzcHg/SUQ9Qk9DUElOQ09cdTAwMjZNVFlQRT1ESVNDSFJHIiwgImxvY2F0aW9uLmxhdGl0dWRlIjogMzkuOTMxNjU5LCAibG9jYXRpb24ubG9uZ2l0dWRlIjogLTEwNS40MjI5ODUsICJsb2NhdGlvbi5uZWVkc19yZWNvZGluZyI6IGZhbHNlLCAic3RhZ2UiOiAiMC44MyIsICJzdGF0aW9uX25hbWUiOiAiU09VVEggQk9VTERFUiBDUkVFSyBBQk9WRSBHUk9TUyBSRVNFUlZPSVIgQVQgUElORUNMSUZGRSIsICJzdGF0aW9uX3N0YXR1cyI6ICJBY3RpdmUiLCAic3RhdGlvbl90eXBlIjogIlN0cmVhbSIsICJ1c2dzX3N0YXRpb25faWQiOiBudWxsLCAidmFyaWFibGUiOiAiRElTQ0hSRyIsICJ3ZCI6ICI2In0sICJ0eXBlIjogIkZlYXR1cmUifV0sICJ0eXBlIjogIkZlYXR1cmVDb2xsZWN0aW9uIn0pOwogICAgICAgIAo8L3NjcmlwdD4=" style="position:absolute;width:100%;height:100%;left:0;top:0;border:none !important;" allowfullscreen webkitallowfullscreen mozallowfullscreen></iframe></div></div>





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



<div style="width:100%;"><div style="position:relative;width:100%;height:0;padding-bottom:60%;"><iframe src="data:text/html;charset=utf-8;base64,PCFET0NUWVBFIGh0bWw+CjxoZWFkPiAgICAKICAgIDxtZXRhIGh0dHAtZXF1aXY9ImNvbnRlbnQtdHlwZSIgY29udGVudD0idGV4dC9odG1sOyBjaGFyc2V0PVVURi04IiAvPgogICAgCiAgICAgICAgPHNjcmlwdD4KICAgICAgICAgICAgTF9OT19UT1VDSCA9IGZhbHNlOwogICAgICAgICAgICBMX0RJU0FCTEVfM0QgPSBmYWxzZTsKICAgICAgICA8L3NjcmlwdD4KICAgIAogICAgPHNjcmlwdCBzcmM9Imh0dHBzOi8vY2RuLmpzZGVsaXZyLm5ldC9ucG0vbGVhZmxldEAxLjUuMS9kaXN0L2xlYWZsZXQuanMiPjwvc2NyaXB0PgogICAgPHNjcmlwdCBzcmM9Imh0dHBzOi8vY29kZS5qcXVlcnkuY29tL2pxdWVyeS0xLjEyLjQubWluLmpzIj48L3NjcmlwdD4KICAgIDxzY3JpcHQgc3JjPSJodHRwczovL21heGNkbi5ib290c3RyYXBjZG4uY29tL2Jvb3RzdHJhcC8zLjIuMC9qcy9ib290c3RyYXAubWluLmpzIj48L3NjcmlwdD4KICAgIDxzY3JpcHQgc3JjPSJodHRwczovL2NkbmpzLmNsb3VkZmxhcmUuY29tL2FqYXgvbGlicy9MZWFmbGV0LmF3ZXNvbWUtbWFya2Vycy8yLjAuMi9sZWFmbGV0LmF3ZXNvbWUtbWFya2Vycy5qcyI+PC9zY3JpcHQ+CiAgICA8bGluayByZWw9InN0eWxlc2hlZXQiIGhyZWY9Imh0dHBzOi8vY2RuLmpzZGVsaXZyLm5ldC9ucG0vbGVhZmxldEAxLjUuMS9kaXN0L2xlYWZsZXQuY3NzIi8+CiAgICA8bGluayByZWw9InN0eWxlc2hlZXQiIGhyZWY9Imh0dHBzOi8vbWF4Y2RuLmJvb3RzdHJhcGNkbi5jb20vYm9vdHN0cmFwLzMuMi4wL2Nzcy9ib290c3RyYXAubWluLmNzcyIvPgogICAgPGxpbmsgcmVsPSJzdHlsZXNoZWV0IiBocmVmPSJodHRwczovL21heGNkbi5ib290c3RyYXBjZG4uY29tL2Jvb3RzdHJhcC8zLjIuMC9jc3MvYm9vdHN0cmFwLXRoZW1lLm1pbi5jc3MiLz4KICAgIDxsaW5rIHJlbD0ic3R5bGVzaGVldCIgaHJlZj0iaHR0cHM6Ly9tYXhjZG4uYm9vdHN0cmFwY2RuLmNvbS9mb250LWF3ZXNvbWUvNC42LjMvY3NzL2ZvbnQtYXdlc29tZS5taW4uY3NzIi8+CiAgICA8bGluayByZWw9InN0eWxlc2hlZXQiIGhyZWY9Imh0dHBzOi8vY2RuanMuY2xvdWRmbGFyZS5jb20vYWpheC9saWJzL0xlYWZsZXQuYXdlc29tZS1tYXJrZXJzLzIuMC4yL2xlYWZsZXQuYXdlc29tZS1tYXJrZXJzLmNzcyIvPgogICAgPGxpbmsgcmVsPSJzdHlsZXNoZWV0IiBocmVmPSJodHRwczovL3Jhd2Nkbi5naXRoYWNrLmNvbS9weXRob24tdmlzdWFsaXphdGlvbi9mb2xpdW0vbWFzdGVyL2ZvbGl1bS90ZW1wbGF0ZXMvbGVhZmxldC5hd2Vzb21lLnJvdGF0ZS5jc3MiLz4KICAgIDxzdHlsZT5odG1sLCBib2R5IHt3aWR0aDogMTAwJTtoZWlnaHQ6IDEwMCU7bWFyZ2luOiAwO3BhZGRpbmc6IDA7fTwvc3R5bGU+CiAgICA8c3R5bGU+I21hcCB7cG9zaXRpb246YWJzb2x1dGU7dG9wOjA7Ym90dG9tOjA7cmlnaHQ6MDtsZWZ0OjA7fTwvc3R5bGU+CiAgICAKICAgICAgICAgICAgPG1ldGEgbmFtZT0idmlld3BvcnQiIGNvbnRlbnQ9IndpZHRoPWRldmljZS13aWR0aCwKICAgICAgICAgICAgICAgIGluaXRpYWwtc2NhbGU9MS4wLCBtYXhpbXVtLXNjYWxlPTEuMCwgdXNlci1zY2FsYWJsZT1ubyIgLz4KICAgICAgICAgICAgPHN0eWxlPgogICAgICAgICAgICAgICAgI21hcF9jYTExYmE3Yzc5MGM0YzI5Yjc3YTIxMmNjZDliOGMwYiB7CiAgICAgICAgICAgICAgICAgICAgcG9zaXRpb246IHJlbGF0aXZlOwogICAgICAgICAgICAgICAgICAgIHdpZHRoOiAxMDAuMCU7CiAgICAgICAgICAgICAgICAgICAgaGVpZ2h0OiAxMDAuMCU7CiAgICAgICAgICAgICAgICAgICAgbGVmdDogMC4wJTsKICAgICAgICAgICAgICAgICAgICB0b3A6IDAuMCU7CiAgICAgICAgICAgICAgICB9CiAgICAgICAgICAgIDwvc3R5bGU+CiAgICAgICAgCiAgICA8c2NyaXB0IHNyYz0iaHR0cHM6Ly9jZG5qcy5jbG91ZGZsYXJlLmNvbS9hamF4L2xpYnMvbGVhZmxldC5tYXJrZXJjbHVzdGVyLzEuMS4wL2xlYWZsZXQubWFya2VyY2x1c3Rlci5qcyI+PC9zY3JpcHQ+CiAgICA8bGluayByZWw9InN0eWxlc2hlZXQiIGhyZWY9Imh0dHBzOi8vY2RuanMuY2xvdWRmbGFyZS5jb20vYWpheC9saWJzL2xlYWZsZXQubWFya2VyY2x1c3Rlci8xLjEuMC9NYXJrZXJDbHVzdGVyLmNzcyIvPgogICAgPGxpbmsgcmVsPSJzdHlsZXNoZWV0IiBocmVmPSJodHRwczovL2NkbmpzLmNsb3VkZmxhcmUuY29tL2FqYXgvbGlicy9sZWFmbGV0Lm1hcmtlcmNsdXN0ZXIvMS4xLjAvTWFya2VyQ2x1c3Rlci5EZWZhdWx0LmNzcyIvPgo8L2hlYWQ+Cjxib2R5PiAgICAKICAgIAogICAgICAgICAgICA8ZGl2IGNsYXNzPSJmb2xpdW0tbWFwIiBpZD0ibWFwX2NhMTFiYTdjNzkwYzRjMjliNzdhMjEyY2NkOWI4YzBiIiA+PC9kaXY+CiAgICAgICAgCjwvYm9keT4KPHNjcmlwdD4gICAgCiAgICAKICAgICAgICAgICAgdmFyIG1hcF9jYTExYmE3Yzc5MGM0YzI5Yjc3YTIxMmNjZDliOGMwYiA9IEwubWFwKAogICAgICAgICAgICAgICAgIm1hcF9jYTExYmE3Yzc5MGM0YzI5Yjc3YTIxMmNjZDliOGMwYiIsCiAgICAgICAgICAgICAgICB7CiAgICAgICAgICAgICAgICAgICAgY2VudGVyOiBbNDAuMDEsIC0xMDUuMjddLAogICAgICAgICAgICAgICAgICAgIGNyczogTC5DUlMuRVBTRzM4NTcsCiAgICAgICAgICAgICAgICAgICAgem9vbTogMTAsCiAgICAgICAgICAgICAgICAgICAgem9vbUNvbnRyb2w6IHRydWUsCiAgICAgICAgICAgICAgICAgICAgcHJlZmVyQ2FudmFzOiBmYWxzZSwKICAgICAgICAgICAgICAgIH0KICAgICAgICAgICAgKTsKCiAgICAgICAgICAgIAoKICAgICAgICAKICAgIAogICAgICAgICAgICB2YXIgdGlsZV9sYXllcl84ZmNiZjFiZmVhNGQ0ZDc5OGY4MmNiMzk3MDk4ZmYzZiA9IEwudGlsZUxheWVyKAogICAgICAgICAgICAgICAgImh0dHBzOi8vY2FydG9kYi1iYXNlbWFwcy17c30uZ2xvYmFsLnNzbC5mYXN0bHkubmV0L2xpZ2h0X2FsbC97en0ve3h9L3t5fS5wbmciLAogICAgICAgICAgICAgICAgeyJhdHRyaWJ1dGlvbiI6ICJcdTAwMjZjb3B5OyBcdTAwM2NhIGhyZWY9XCJodHRwOi8vd3d3Lm9wZW5zdHJlZXRtYXAub3JnL2NvcHlyaWdodFwiXHUwMDNlT3BlblN0cmVldE1hcFx1MDAzYy9hXHUwMDNlIGNvbnRyaWJ1dG9ycyBcdTAwMjZjb3B5OyBcdTAwM2NhIGhyZWY9XCJodHRwOi8vY2FydG9kYi5jb20vYXR0cmlidXRpb25zXCJcdTAwM2VDYXJ0b0RCXHUwMDNjL2FcdTAwM2UsIENhcnRvREIgXHUwMDNjYSBocmVmID1cImh0dHA6Ly9jYXJ0b2RiLmNvbS9hdHRyaWJ1dGlvbnNcIlx1MDAzZWF0dHJpYnV0aW9uc1x1MDAzYy9hXHUwMDNlIiwgImRldGVjdFJldGluYSI6IGZhbHNlLCAibWF4TmF0aXZlWm9vbSI6IDE4LCAibWF4Wm9vbSI6IDE4LCAibWluWm9vbSI6IDAsICJub1dyYXAiOiBmYWxzZSwgIm9wYWNpdHkiOiAxLCAic3ViZG9tYWlucyI6ICJhYmMiLCAidG1zIjogZmFsc2V9CiAgICAgICAgICAgICkuYWRkVG8obWFwX2NhMTFiYTdjNzkwYzRjMjliNzdhMjEyY2NkOWI4YzBiKTsKICAgICAgICAKICAgIAogICAgICAgICAgICB2YXIgbWFya2VyX2NsdXN0ZXJfN2UyN2E2NGFhYzg2NGU4MGJiZWRmYmQ2ZDQxZjg4MDIgPSBMLm1hcmtlckNsdXN0ZXJHcm91cCgKICAgICAgICAgICAgICAgIHt9CiAgICAgICAgICAgICk7CiAgICAgICAgICAgIG1hcF9jYTExYmE3Yzc5MGM0YzI5Yjc3YTIxMmNjZDliOGMwYi5hZGRMYXllcihtYXJrZXJfY2x1c3Rlcl83ZTI3YTY0YWFjODY0ZTgwYmJlZGZiZDZkNDFmODgwMik7CiAgICAgICAgCiAgICAKICAgICAgICAgICAgdmFyIG1hcmtlcl80OWNhOGM3ZGViY2E0ODdkODc5OWY3OWUyYjlkMGYzYiA9IEwubWFya2VyKAogICAgICAgICAgICAgICAgWzQwLjIxMTM4OSwgLTEwNS4yNTA5NTJdLAogICAgICAgICAgICAgICAge30KICAgICAgICAgICAgKS5hZGRUbyhtYXJrZXJfY2x1c3Rlcl83ZTI3YTY0YWFjODY0ZTgwYmJlZGZiZDZkNDFmODgwMik7CiAgICAgICAgCiAgICAKICAgICAgICB2YXIgcG9wdXBfMDliYzY5MzNhY2Y2NGYxMDhkNTUxMTYyMTA2MGNlYWMgPSBMLnBvcHVwKHsibWF4V2lkdGgiOiAiMTAwJSJ9KTsKCiAgICAgICAgCiAgICAgICAgICAgIHZhciBodG1sX2Q4OTNmOWU4MDU4NzRiY2U5MmI2NzlhMzgxNzQ1M2U2ID0gJChgPGRpdiBpZD0iaHRtbF9kODkzZjllODA1ODc0YmNlOTJiNjc5YTM4MTc0NTNlNiIgc3R5bGU9IndpZHRoOiAxMDAuMCU7IGhlaWdodDogMTAwLjAlOyI+TmFtZTogU01FQUQgRElUQ0ggUHJlY2lwOiAzLjc4PC9kaXY+YClbMF07CiAgICAgICAgICAgIHBvcHVwXzA5YmM2OTMzYWNmNjRmMTA4ZDU1MTE2MjEwNjBjZWFjLnNldENvbnRlbnQoaHRtbF9kODkzZjllODA1ODc0YmNlOTJiNjc5YTM4MTc0NTNlNik7CiAgICAgICAgCgogICAgICAgIG1hcmtlcl80OWNhOGM3ZGViY2E0ODdkODc5OWY3OWUyYjlkMGYzYi5iaW5kUG9wdXAocG9wdXBfMDliYzY5MzNhY2Y2NGYxMDhkNTUxMTYyMTA2MGNlYWMpCiAgICAgICAgOwoKICAgICAgICAKICAgIAogICAgCiAgICAgICAgICAgIHZhciBtYXJrZXJfMmRhMmVkMWViN2VkNGM5OGExMTUxZWI5OTA4ODNlMDMgPSBMLm1hcmtlcigKICAgICAgICAgICAgICAgIFs0MC4xNzcwOCwgLTEwNS4xNzg1NjddLAogICAgICAgICAgICAgICAge30KICAgICAgICAgICAgKS5hZGRUbyhtYXJrZXJfY2x1c3Rlcl83ZTI3YTY0YWFjODY0ZTgwYmJlZGZiZDZkNDFmODgwMik7CiAgICAgICAgCiAgICAKICAgICAgICB2YXIgcG9wdXBfMTljNWVhNjIxYTg4NDVhOGIwNDNhMDEyNTQ0ZWI0MDkgPSBMLnBvcHVwKHsibWF4V2lkdGgiOiAiMTAwJSJ9KTsKCiAgICAgICAgCiAgICAgICAgICAgIHZhciBodG1sX2QxMzJhMTZmZWI3MTQ5ZTZiZmY3YmIyMjI1ZjcyZDQ5ID0gJChgPGRpdiBpZD0iaHRtbF9kMTMyYTE2ZmViNzE0OWU2YmZmN2JiMjIyNWY3MmQ0OSIgc3R5bGU9IndpZHRoOiAxMDAuMCU7IGhlaWdodDogMTAwLjAlOyI+TmFtZTogUEVDSyBQRUxMQSBDTE9WRVIgRElUQ0ggUHJlY2lwOiAxLjU2PC9kaXY+YClbMF07CiAgICAgICAgICAgIHBvcHVwXzE5YzVlYTYyMWE4ODQ1YThiMDQzYTAxMjU0NGViNDA5LnNldENvbnRlbnQoaHRtbF9kMTMyYTE2ZmViNzE0OWU2YmZmN2JiMjIyNWY3MmQ0OSk7CiAgICAgICAgCgogICAgICAgIG1hcmtlcl8yZGEyZWQxZWI3ZWQ0Yzk4YTExNTFlYjk5MDg4M2UwMy5iaW5kUG9wdXAocG9wdXBfMTljNWVhNjIxYTg4NDVhOGIwNDNhMDEyNTQ0ZWI0MDkpCiAgICAgICAgOwoKICAgICAgICAKICAgIAogICAgCiAgICAgICAgICAgIHZhciBtYXJrZXJfYTEzZGZmODdjMDBjNDM3ZmJmYjBiYjcxY2FmMDRiNjYgPSBMLm1hcmtlcigKICAgICAgICAgICAgICAgIFs0MC4xOTMwMTksIC0xMDUuMjEwMzg4XSwKICAgICAgICAgICAgICAgIHt9CiAgICAgICAgICAgICkuYWRkVG8obWFya2VyX2NsdXN0ZXJfN2UyN2E2NGFhYzg2NGU4MGJiZWRmYmQ2ZDQxZjg4MDIpOwogICAgICAgIAogICAgCiAgICAgICAgdmFyIHBvcHVwXzllY2E5NTc4YzYzZTQ3ZTQ5NGEwNWZmMmE0OTUzYWNlID0gTC5wb3B1cCh7Im1heFdpZHRoIjogIjEwMCUifSk7CgogICAgICAgIAogICAgICAgICAgICB2YXIgaHRtbF9lZDE2ZjAyMTQzZTE0ZmQ4YTQxM2IwMjAxNWE2ZDBkMSA9ICQoYDxkaXYgaWQ9Imh0bWxfZWQxNmYwMjE0M2UxNGZkOGE0MTNiMDIwMTVhNmQwZDEiIHN0eWxlPSJ3aWR0aDogMTAwLjAlOyBoZWlnaHQ6IDEwMC4wJTsiPk5hbWU6IFRSVUUgQU5EIFdFQlNURVIgRElUQ0ggUHJlY2lwOiAwLjEwPC9kaXY+YClbMF07CiAgICAgICAgICAgIHBvcHVwXzllY2E5NTc4YzYzZTQ3ZTQ5NGEwNWZmMmE0OTUzYWNlLnNldENvbnRlbnQoaHRtbF9lZDE2ZjAyMTQzZTE0ZmQ4YTQxM2IwMjAxNWE2ZDBkMSk7CiAgICAgICAgCgogICAgICAgIG1hcmtlcl9hMTNkZmY4N2MwMGM0MzdmYmZiMGJiNzFjYWYwNGI2Ni5iaW5kUG9wdXAocG9wdXBfOWVjYTk1NzhjNjNlNDdlNDk0YTA1ZmYyYTQ5NTNhY2UpCiAgICAgICAgOwoKICAgICAgICAKICAgIAogICAgCiAgICAgICAgICAgIHZhciBtYXJrZXJfZjE4YjM4MGZhNDNiNDgzZTllYmZiNDA3ZjQ5Y2Y0MjggPSBMLm1hcmtlcigKICAgICAgICAgICAgICAgIFs0MC4xODc1NzgsIC0xMDUuMTg5MTkxXSwKICAgICAgICAgICAgICAgIHt9CiAgICAgICAgICAgICkuYWRkVG8obWFya2VyX2NsdXN0ZXJfN2UyN2E2NGFhYzg2NGU4MGJiZWRmYmQ2ZDQxZjg4MDIpOwogICAgICAgIAogICAgCiAgICAgICAgdmFyIHBvcHVwXzU5ZmJmMzhmYmEwNzQ4YjU5MTNhMzMzOWFjY2U4YTlkID0gTC5wb3B1cCh7Im1heFdpZHRoIjogIjEwMCUifSk7CgogICAgICAgIAogICAgICAgICAgICB2YXIgaHRtbF9mYzZjYWNhY2VkNDc0MjNiODVmMDIyYTZhOWQ5YzUxOCA9ICQoYDxkaXYgaWQ9Imh0bWxfZmM2Y2FjYWNlZDQ3NDIzYjg1ZjAyMmE2YTlkOWM1MTgiIHN0eWxlPSJ3aWR0aDogMTAwLjAlOyBoZWlnaHQ6IDEwMC4wJTsiPk5hbWU6IERFTklPIFRBWUxPUiBESVRDSCBQcmVjaXA6IDAuMDE8L2Rpdj5gKVswXTsKICAgICAgICAgICAgcG9wdXBfNTlmYmYzOGZiYTA3NDhiNTkxM2EzMzM5YWNjZThhOWQuc2V0Q29udGVudChodG1sX2ZjNmNhY2FjZWQ0NzQyM2I4NWYwMjJhNmE5ZDljNTE4KTsKICAgICAgICAKCiAgICAgICAgbWFya2VyX2YxOGIzODBmYTQzYjQ4M2U5ZWJmYjQwN2Y0OWNmNDI4LmJpbmRQb3B1cChwb3B1cF81OWZiZjM4ZmJhMDc0OGI1OTEzYTMzMzlhY2NlOGE5ZCkKICAgICAgICA7CgogICAgICAgIAogICAgCiAgICAKICAgICAgICAgICAgdmFyIG1hcmtlcl80NjA4ZjZiODQyNTg0ZGQ3YWE4MmFhN2U0MjA2NTc1YiA9IEwubWFya2VyKAogICAgICAgICAgICAgICAgWzQwLjE1MzM2MywgLTEwNS4wODg2OTVdLAogICAgICAgICAgICAgICAge30KICAgICAgICAgICAgKS5hZGRUbyhtYXJrZXJfY2x1c3Rlcl83ZTI3YTY0YWFjODY0ZTgwYmJlZGZiZDZkNDFmODgwMik7CiAgICAgICAgCiAgICAKICAgICAgICB2YXIgcG9wdXBfYjA3MWE4YTIwYjNhNDI1NGExNmMwMWRmOTI0MmZjMmEgPSBMLnBvcHVwKHsibWF4V2lkdGgiOiAiMTAwJSJ9KTsKCiAgICAgICAgCiAgICAgICAgICAgIHZhciBodG1sX2VlNzI1NzBjNjIzODQ1NzFhMjNjNzQ3ZDg4MzY2MjE2ID0gJChgPGRpdiBpZD0iaHRtbF9lZTcyNTcwYzYyMzg0NTcxYTIzYzc0N2Q4ODM2NjIxNiIgc3R5bGU9IndpZHRoOiAxMDAuMCU7IGhlaWdodDogMTAwLjAlOyI+TmFtZTogQk9OVVMgRElUQ0ggUHJlY2lwOiAyMy45MTwvZGl2PmApWzBdOwogICAgICAgICAgICBwb3B1cF9iMDcxYThhMjBiM2E0MjU0YTE2YzAxZGY5MjQyZmMyYS5zZXRDb250ZW50KGh0bWxfZWU3MjU3MGM2MjM4NDU3MWEyM2M3NDdkODgzNjYyMTYpOwogICAgICAgIAoKICAgICAgICBtYXJrZXJfNDYwOGY2Yjg0MjU4NGRkN2FhODJhYTdlNDIwNjU3NWIuYmluZFBvcHVwKHBvcHVwX2IwNzFhOGEyMGIzYTQyNTRhMTZjMDFkZjkyNDJmYzJhKQogICAgICAgIDsKCiAgICAgICAgCiAgICAKICAgIAogICAgICAgICAgICB2YXIgbWFya2VyX2UwZTUyZDk5NmE4ZTQ3NDRhMTNlZGNhMDU0ZDA1NGNhID0gTC5tYXJrZXIoCiAgICAgICAgICAgICAgICBbNDAuMDg2Mjc4LCAtMTA1LjIxNzUxOV0sCiAgICAgICAgICAgICAgICB7fQogICAgICAgICAgICApLmFkZFRvKG1hcmtlcl9jbHVzdGVyXzdlMjdhNjRhYWM4NjRlODBiYmVkZmJkNmQ0MWY4ODAyKTsKICAgICAgICAKICAgIAogICAgICAgIHZhciBwb3B1cF8xYTk4YzdiYTYyMDE0NTBlOTJhODE1NjkyNGU2ZWJmYSA9IEwucG9wdXAoeyJtYXhXaWR0aCI6ICIxMDAlIn0pOwoKICAgICAgICAKICAgICAgICAgICAgdmFyIGh0bWxfYjkzNDBjNjhmZDUxNGI4NjkxYmNlZmQzODg4MjQyOGEgPSAkKGA8ZGl2IGlkPSJodG1sX2I5MzQwYzY4ZmQ1MTRiODY5MWJjZWZkMzg4ODI0MjhhIiBzdHlsZT0id2lkdGg6IDEwMC4wJTsgaGVpZ2h0OiAxMDAuMCU7Ij5OYW1lOiBCT1VMREVSIFJFU0VSVk9JUiBJTkxFVCBQcmVjaXA6IDYzLjYwPC9kaXY+YClbMF07CiAgICAgICAgICAgIHBvcHVwXzFhOThjN2JhNjIwMTQ1MGU5MmE4MTU2OTI0ZTZlYmZhLnNldENvbnRlbnQoaHRtbF9iOTM0MGM2OGZkNTE0Yjg2OTFiY2VmZDM4ODgyNDI4YSk7CiAgICAgICAgCgogICAgICAgIG1hcmtlcl9lMGU1MmQ5OTZhOGU0NzQ0YTEzZWRjYTA1NGQwNTRjYS5iaW5kUG9wdXAocG9wdXBfMWE5OGM3YmE2MjAxNDUwZTkyYTgxNTY5MjRlNmViZmEpCiAgICAgICAgOwoKICAgICAgICAKICAgIAogICAgCiAgICAgICAgICAgIHZhciBtYXJrZXJfYzQ4Y2RiZDljOGVjNDc1ZjhkNzA2ZjFlYjg0MzZiNjIgPSBMLm1hcmtlcigKICAgICAgICAgICAgICAgIFs0MC4wMDYzOCwgLTEwNS4zMzA4NDFdLAogICAgICAgICAgICAgICAge30KICAgICAgICAgICAgKS5hZGRUbyhtYXJrZXJfY2x1c3Rlcl83ZTI3YTY0YWFjODY0ZTgwYmJlZGZiZDZkNDFmODgwMik7CiAgICAgICAgCiAgICAKICAgICAgICB2YXIgcG9wdXBfNzc4ZDIwZmY1MDE5NDhmZWJlNGYxOTQwZGNmMzA5NTQgPSBMLnBvcHVwKHsibWF4V2lkdGgiOiAiMTAwJSJ9KTsKCiAgICAgICAgCiAgICAgICAgICAgIHZhciBodG1sX2ViNDZmYWFjMzE1ODRjZjU4NmRhMGYwYzJiNjk4OTY3ID0gJChgPGRpdiBpZD0iaHRtbF9lYjQ2ZmFhYzMxNTg0Y2Y1ODZkYTBmMGMyYjY5ODk2NyIgc3R5bGU9IndpZHRoOiAxMDAuMCU7IGhlaWdodDogMTAwLjAlOyI+TmFtZTogQk9VTERFUiBDUkVFSyBORUFSIE9ST0RFTEwsIENPLiBQcmVjaXA6IDM3LjMwPC9kaXY+YClbMF07CiAgICAgICAgICAgIHBvcHVwXzc3OGQyMGZmNTAxOTQ4ZmViZTRmMTk0MGRjZjMwOTU0LnNldENvbnRlbnQoaHRtbF9lYjQ2ZmFhYzMxNTg0Y2Y1ODZkYTBmMGMyYjY5ODk2Nyk7CiAgICAgICAgCgogICAgICAgIG1hcmtlcl9jNDhjZGJkOWM4ZWM0NzVmOGQ3MDZmMWViODQzNmI2Mi5iaW5kUG9wdXAocG9wdXBfNzc4ZDIwZmY1MDE5NDhmZWJlNGYxOTQwZGNmMzA5NTQpCiAgICAgICAgOwoKICAgICAgICAKICAgIAogICAgCiAgICAgICAgICAgIHZhciBtYXJrZXJfMTBkYWE3NGEyYTg5NDE3MDliZWEzODI1MjliNjQ3OTEgPSBMLm1hcmtlcigKICAgICAgICAgICAgICAgIFs0MC4xNzM5NSwgLTEwNS4xNjkzNzRdLAogICAgICAgICAgICAgICAge30KICAgICAgICAgICAgKS5hZGRUbyhtYXJrZXJfY2x1c3Rlcl83ZTI3YTY0YWFjODY0ZTgwYmJlZGZiZDZkNDFmODgwMik7CiAgICAgICAgCiAgICAKICAgICAgICB2YXIgcG9wdXBfZjM1NzNmMWI1NTMzNGNkNGE0MWJjZmQ2MTM4ZDgyMjMgPSBMLnBvcHVwKHsibWF4V2lkdGgiOiAiMTAwJSJ9KTsKCiAgICAgICAgCiAgICAgICAgICAgIHZhciBodG1sXzYyMjg2YTIwOWY2OTRmNzE4MTk0YmFmZTgzNWI3MTk5ID0gJChgPGRpdiBpZD0iaHRtbF82MjI4NmEyMDlmNjk0ZjcxODE5NGJhZmU4MzViNzE5OSIgc3R5bGU9IndpZHRoOiAxMDAuMCU7IGhlaWdodDogMTAwLjAlOyI+TmFtZTogTklXT1QgRElUQ0ggUHJlY2lwOiAzLjgxPC9kaXY+YClbMF07CiAgICAgICAgICAgIHBvcHVwX2YzNTczZjFiNTUzMzRjZDRhNDFiY2ZkNjEzOGQ4MjIzLnNldENvbnRlbnQoaHRtbF82MjI4NmEyMDlmNjk0ZjcxODE5NGJhZmU4MzViNzE5OSk7CiAgICAgICAgCgogICAgICAgIG1hcmtlcl8xMGRhYTc0YTJhODk0MTcwOWJlYTM4MjUyOWI2NDc5MS5iaW5kUG9wdXAocG9wdXBfZjM1NzNmMWI1NTMzNGNkNGE0MWJjZmQ2MTM4ZDgyMjMpCiAgICAgICAgOwoKICAgICAgICAKICAgIAogICAgCiAgICAgICAgICAgIHZhciBtYXJrZXJfNzZmYzlkNGU5YTJkNDU4MWFjZDgyNTE2OGUwNWQwYzYgPSBMLm1hcmtlcigKICAgICAgICAgICAgICAgIFs0MC4yNjA4MjcsIC0xMDUuMTk4NTY3XSwKICAgICAgICAgICAgICAgIHt9CiAgICAgICAgICAgICkuYWRkVG8obWFya2VyX2NsdXN0ZXJfN2UyN2E2NGFhYzg2NGU4MGJiZWRmYmQ2ZDQxZjg4MDIpOwogICAgICAgIAogICAgCiAgICAgICAgdmFyIHBvcHVwX2Y3YjZmNjJkNjMwODQ2MGJhNGJkOWNlM2U3MWQ3MDUxID0gTC5wb3B1cCh7Im1heFdpZHRoIjogIjEwMCUifSk7CgogICAgICAgIAogICAgICAgICAgICB2YXIgaHRtbF9lMmNjYmFhMDViNDQ0YzJmYTc4NGI0MTk5MjJkNDZkNiA9ICQoYDxkaXYgaWQ9Imh0bWxfZTJjY2JhYTA1YjQ0NGMyZmE3ODRiNDE5OTIyZDQ2ZDYiIHN0eWxlPSJ3aWR0aDogMTAwLjAlOyBoZWlnaHQ6IDEwMC4wJTsiPk5hbWU6IENVTFZFUiBESVRDSCBQcmVjaXA6IDIuMjI8L2Rpdj5gKVswXTsKICAgICAgICAgICAgcG9wdXBfZjdiNmY2MmQ2MzA4NDYwYmE0YmQ5Y2UzZTcxZDcwNTEuc2V0Q29udGVudChodG1sX2UyY2NiYWEwNWI0NDRjMmZhNzg0YjQxOTkyMmQ0NmQ2KTsKICAgICAgICAKCiAgICAgICAgbWFya2VyXzc2ZmM5ZDRlOWEyZDQ1ODFhY2Q4MjUxNjhlMDVkMGM2LmJpbmRQb3B1cChwb3B1cF9mN2I2ZjYyZDYzMDg0NjBiYTRiZDljZTNlNzFkNzA1MSkKICAgICAgICA7CgogICAgICAgIAogICAgCiAgICAKICAgICAgICAgICAgdmFyIG1hcmtlcl85OWYxMDJlMGVkZGQ0NTFkODFhZTc3OTc2Y2VhMWU5YyA9IEwubWFya2VyKAogICAgICAgICAgICAgICAgWzQwLjIxMjUwNSwgLTEwNS4yNTE4MjZdLAogICAgICAgICAgICAgICAge30KICAgICAgICAgICAgKS5hZGRUbyhtYXJrZXJfY2x1c3Rlcl83ZTI3YTY0YWFjODY0ZTgwYmJlZGZiZDZkNDFmODgwMik7CiAgICAgICAgCiAgICAKICAgICAgICB2YXIgcG9wdXBfMTZhMzRkMTNlZGYwNGNhOTg3ZDhhYTY0NGI0NDMzMzggPSBMLnBvcHVwKHsibWF4V2lkdGgiOiAiMTAwJSJ9KTsKCiAgICAgICAgCiAgICAgICAgICAgIHZhciBodG1sX2NmYWE4NzE0MjgxZjQwY2ZhOWRkZWExNjY0M2I5NTIxID0gJChgPGRpdiBpZD0iaHRtbF9jZmFhODcxNDI4MWY0MGNmYTlkZGVhMTY2NDNiOTUyMSIgc3R5bGU9IndpZHRoOiAxMDAuMCU7IGhlaWdodDogMTAwLjAlOyI+TmFtZTogUEFMTUVSVE9OIERJVENIIFByZWNpcDogMC4yNzwvZGl2PmApWzBdOwogICAgICAgICAgICBwb3B1cF8xNmEzNGQxM2VkZjA0Y2E5ODdkOGFhNjQ0YjQ0MzMzOC5zZXRDb250ZW50KGh0bWxfY2ZhYTg3MTQyODFmNDBjZmE5ZGRlYTE2NjQzYjk1MjEpOwogICAgICAgIAoKICAgICAgICBtYXJrZXJfOTlmMTAyZTBlZGRkNDUxZDgxYWU3Nzk3NmNlYTFlOWMuYmluZFBvcHVwKHBvcHVwXzE2YTM0ZDEzZWRmMDRjYTk4N2Q4YWE2NDRiNDQzMzM4KQogICAgICAgIDsKCiAgICAgICAgCiAgICAKICAgIAogICAgICAgICAgICB2YXIgbWFya2VyXzMwMDk4ODQyZDVkNTRjYTA5MDhiNGFkZDJiMzg4NzlhID0gTC5tYXJrZXIoCiAgICAgICAgICAgICAgICBbNDAuMDkxMzkxLCAtMTA1LjUwODQ4XSwKICAgICAgICAgICAgICAgIHt9CiAgICAgICAgICAgICkuYWRkVG8obWFya2VyX2NsdXN0ZXJfN2UyN2E2NGFhYzg2NGU4MGJiZWRmYmQ2ZDQxZjg4MDIpOwogICAgICAgIAogICAgCiAgICAgICAgdmFyIHBvcHVwX2M5NGI1ZDAxZTNiZTQzN2RhMmM4MmZlMGU5NjkzNGZiID0gTC5wb3B1cCh7Im1heFdpZHRoIjogIjEwMCUifSk7CgogICAgICAgIAogICAgICAgICAgICB2YXIgaHRtbF9iMzgwNzliOTU3NjY0YWRlOTQ4NDgzY2M3OGFiYWE3ZiA9ICQoYDxkaXYgaWQ9Imh0bWxfYjM4MDc5Yjk1NzY2NGFkZTk0ODQ4M2NjNzhhYmFhN2YiIHN0eWxlPSJ3aWR0aDogMTAwLjAlOyBoZWlnaHQ6IDEwMC4wJTsiPk5hbWU6IExFRlQgSEFORCBESVZFUlNJT04gTkVBUiBXQVJEIFByZWNpcDogMzUuNDA8L2Rpdj5gKVswXTsKICAgICAgICAgICAgcG9wdXBfYzk0YjVkMDFlM2JlNDM3ZGEyYzgyZmUwZTk2OTM0ZmIuc2V0Q29udGVudChodG1sX2IzODA3OWI5NTc2NjRhZGU5NDg0ODNjYzc4YWJhYTdmKTsKICAgICAgICAKCiAgICAgICAgbWFya2VyXzMwMDk4ODQyZDVkNTRjYTA5MDhiNGFkZDJiMzg4NzlhLmJpbmRQb3B1cChwb3B1cF9jOTRiNWQwMWUzYmU0MzdkYTJjODJmZTBlOTY5MzRmYikKICAgICAgICA7CgogICAgICAgIAogICAgCiAgICAKICAgICAgICAgICAgdmFyIG1hcmtlcl8yZTFiM2I5ZTlkYjA0ZmY2YjBlMDcwMjM3MDA2MzM0NSA9IEwubWFya2VyKAogICAgICAgICAgICAgICAgWzM5Ljk0NzcwNCwgLTEwNS4zNTczMDhdLAogICAgICAgICAgICAgICAge30KICAgICAgICAgICAgKS5hZGRUbyhtYXJrZXJfY2x1c3Rlcl83ZTI3YTY0YWFjODY0ZTgwYmJlZGZiZDZkNDFmODgwMik7CiAgICAgICAgCiAgICAKICAgICAgICB2YXIgcG9wdXBfMmM5NGEyZTZhNDhlNDNjNGIyZjBkYjU1YTU5NTBjYjQgPSBMLnBvcHVwKHsibWF4V2lkdGgiOiAiMTAwJSJ9KTsKCiAgICAgICAgCiAgICAgICAgICAgIHZhciBodG1sX2E1ZDcwZGQ0OWI1ZTRmNGNhNDE3MGI5MGZjZmY5YjgzID0gJChgPGRpdiBpZD0iaHRtbF9hNWQ3MGRkNDliNWU0ZjRjYTQxNzBiOTBmY2ZmOWI4MyIgc3R5bGU9IndpZHRoOiAxMDAuMCU7IGhlaWdodDogMTAwLjAlOyI+TmFtZTogR1JPU1MgUkVTRVJWT0lSICBQcmVjaXA6IDQxMDE0LjAwPC9kaXY+YClbMF07CiAgICAgICAgICAgIHBvcHVwXzJjOTRhMmU2YTQ4ZTQzYzRiMmYwZGI1NWE1OTUwY2I0LnNldENvbnRlbnQoaHRtbF9hNWQ3MGRkNDliNWU0ZjRjYTQxNzBiOTBmY2ZmOWI4Myk7CiAgICAgICAgCgogICAgICAgIG1hcmtlcl8yZTFiM2I5ZTlkYjA0ZmY2YjBlMDcwMjM3MDA2MzM0NS5iaW5kUG9wdXAocG9wdXBfMmM5NGEyZTZhNDhlNDNjNGIyZjBkYjU1YTU5NTBjYjQpCiAgICAgICAgOwoKICAgICAgICAKICAgIAogICAgCiAgICAgICAgICAgIHZhciBtYXJrZXJfODEyNjBiOTU2NDc2NDFlNTk4NjI0OGZiYzY3NzU4YTcgPSBMLm1hcmtlcigKICAgICAgICAgICAgICAgIFs0MC4xNzc0MjMsIC0xMDUuMTc4MTQ1XSwKICAgICAgICAgICAgICAgIHt9CiAgICAgICAgICAgICkuYWRkVG8obWFya2VyX2NsdXN0ZXJfN2UyN2E2NGFhYzg2NGU4MGJiZWRmYmQ2ZDQxZjg4MDIpOwogICAgICAgIAogICAgCiAgICAgICAgdmFyIHBvcHVwX2NlZGI3OGU0Yzk2MzRkOWZiOGQwMTk3YjM5NDYwMGY4ID0gTC5wb3B1cCh7Im1heFdpZHRoIjogIjEwMCUifSk7CgogICAgICAgIAogICAgICAgICAgICB2YXIgaHRtbF9mMDgzZTZmOTExMGY0ZGQwOTAwYmEyYTMyNGZiNGZjMCA9ICQoYDxkaXYgaWQ9Imh0bWxfZjA4M2U2ZjkxMTBmNGRkMDkwMGJhMmEzMjRmYjRmYzAiIHN0eWxlPSJ3aWR0aDogMTAwLjAlOyBoZWlnaHQ6IDEwMC4wJTsiPk5hbWU6IFNBSU5UIFZSQUlOIENSRUVLIEFUIEhZR0lFTkUsIENPIFByZWNpcDogMTQuMDA8L2Rpdj5gKVswXTsKICAgICAgICAgICAgcG9wdXBfY2VkYjc4ZTRjOTYzNGQ5ZmI4ZDAxOTdiMzk0NjAwZjguc2V0Q29udGVudChodG1sX2YwODNlNmY5MTEwZjRkZDA5MDBiYTJhMzI0ZmI0ZmMwKTsKICAgICAgICAKCiAgICAgICAgbWFya2VyXzgxMjYwYjk1NjQ3NjQxZTU5ODYyNDhmYmM2Nzc1OGE3LmJpbmRQb3B1cChwb3B1cF9jZWRiNzhlNGM5NjM0ZDlmYjhkMDE5N2IzOTQ2MDBmOCkKICAgICAgICA7CgogICAgICAgIAogICAgCiAgICAKICAgICAgICAgICAgdmFyIG1hcmtlcl9lOTZiNzg3NzE2YjE0NjE0YjJjNjMyNjhiMjEwZDI3MCA9IEwubWFya2VyKAogICAgICAgICAgICAgICAgWzQwLjIxNTA0MywgLTEwNS4yNTYwMTddLAogICAgICAgICAgICAgICAge30KICAgICAgICAgICAgKS5hZGRUbyhtYXJrZXJfY2x1c3Rlcl83ZTI3YTY0YWFjODY0ZTgwYmJlZGZiZDZkNDFmODgwMik7CiAgICAgICAgCiAgICAKICAgICAgICB2YXIgcG9wdXBfZjE1ZTU4NzcwZWIxNDI0YWJkOTQwZmQ3NjAwODUxNzMgPSBMLnBvcHVwKHsibWF4V2lkdGgiOiAiMTAwJSJ9KTsKCiAgICAgICAgCiAgICAgICAgICAgIHZhciBodG1sXzQ4MjY0ZTU2OTI0NjQzOWE4NzQ5NDI5Y2E4NjIxZjgxID0gJChgPGRpdiBpZD0iaHRtbF80ODI2NGU1NjkyNDY0MzlhODc0OTQyOWNhODYyMWY4MSIgc3R5bGU9IndpZHRoOiAxMDAuMCU7IGhlaWdodDogMTAwLjAlOyI+TmFtZTogSElHSExBTkQgRElUQ0ggQVQgTFlPTlMsIENPIFByZWNpcDogMTQ4LjAwPC9kaXY+YClbMF07CiAgICAgICAgICAgIHBvcHVwX2YxNWU1ODc3MGViMTQyNGFiZDk0MGZkNzYwMDg1MTczLnNldENvbnRlbnQoaHRtbF80ODI2NGU1NjkyNDY0MzlhODc0OTQyOWNhODYyMWY4MSk7CiAgICAgICAgCgogICAgICAgIG1hcmtlcl9lOTZiNzg3NzE2YjE0NjE0YjJjNjMyNjhiMjEwZDI3MC5iaW5kUG9wdXAocG9wdXBfZjE1ZTU4NzcwZWIxNDI0YWJkOTQwZmQ3NjAwODUxNzMpCiAgICAgICAgOwoKICAgICAgICAKICAgIAogICAgCiAgICAgICAgICAgIHZhciBtYXJrZXJfMjA5ZGNmNGFhNjI5NDMxNWFkNGVjODkwY2I0NDg4MGUgPSBMLm1hcmtlcigKICAgICAgICAgICAgICAgIFszOS45MzgzNTEsIC0xMDUuMzQ3OTA2XSwKICAgICAgICAgICAgICAgIHt9CiAgICAgICAgICAgICkuYWRkVG8obWFya2VyX2NsdXN0ZXJfN2UyN2E2NGFhYzg2NGU4MGJiZWRmYmQ2ZDQxZjg4MDIpOwogICAgICAgIAogICAgCiAgICAgICAgdmFyIHBvcHVwXzc5NTc3YTEwODNjOTQ4MWY4NWZmNjE3ZTQ2ZmRlNzUxID0gTC5wb3B1cCh7Im1heFdpZHRoIjogIjEwMCUifSk7CgogICAgICAgIAogICAgICAgICAgICB2YXIgaHRtbF8zMWQ0NTYwYzNmMmE0YzA2YWY3ODRjMjIyMWQ2YzkwZSA9ICQoYDxkaXYgaWQ9Imh0bWxfMzFkNDU2MGMzZjJhNGMwNmFmNzg0YzIyMjFkNmM5MGUiIHN0eWxlPSJ3aWR0aDogMTAwLjAlOyBoZWlnaHQ6IDEwMC4wJTsiPk5hbWU6IFNPVVRIIEJPVUxERVIgQ1JFRUsgQkVMT1cgR1JPU1MgUkVTRVJWT0lSIFByZWNpcDogMTA5LjAwPC9kaXY+YClbMF07CiAgICAgICAgICAgIHBvcHVwXzc5NTc3YTEwODNjOTQ4MWY4NWZmNjE3ZTQ2ZmRlNzUxLnNldENvbnRlbnQoaHRtbF8zMWQ0NTYwYzNmMmE0YzA2YWY3ODRjMjIyMWQ2YzkwZSk7CiAgICAgICAgCgogICAgICAgIG1hcmtlcl8yMDlkY2Y0YWE2Mjk0MzE1YWQ0ZWM4OTBjYjQ0ODgwZS5iaW5kUG9wdXAocG9wdXBfNzk1NzdhMTA4M2M5NDgxZjg1ZmY2MTdlNDZmZGU3NTEpCiAgICAgICAgOwoKICAgICAgICAKICAgIAogICAgCiAgICAgICAgICAgIHZhciBtYXJrZXJfNDIwNGFmNDk4NzVmNDIyM2FiNDUwZDc2M2I0ZGNlMzEgPSBMLm1hcmtlcigKICAgICAgICAgICAgICAgIFs0MC4yNTc4NDQsIC0xMDUuMTY0Mzk3XSwKICAgICAgICAgICAgICAgIHt9CiAgICAgICAgICAgICkuYWRkVG8obWFya2VyX2NsdXN0ZXJfN2UyN2E2NGFhYzg2NGU4MGJiZWRmYmQ2ZDQxZjg4MDIpOwogICAgICAgIAogICAgCiAgICAgICAgdmFyIHBvcHVwXzY2NjgwZDkzZGY2NzQxZTFiOTMxMGVjMGU0YzdmNTczID0gTC5wb3B1cCh7Im1heFdpZHRoIjogIjEwMCUifSk7CgogICAgICAgIAogICAgICAgICAgICB2YXIgaHRtbF82ODFlZmJjMzY2YzE0OGVjYTFhNWU0Njc0ZjJiNDk0NSA9ICQoYDxkaXYgaWQ9Imh0bWxfNjgxZWZiYzM2NmMxNDhlY2ExYTVlNDY3NGYyYjQ5NDUiIHN0eWxlPSJ3aWR0aDogMTAwLjAlOyBoZWlnaHQ6IDEwMC4wJTsiPk5hbWU6IEJMT1dFUiBESVRDSCBQcmVjaXA6IDAuMTk8L2Rpdj5gKVswXTsKICAgICAgICAgICAgcG9wdXBfNjY2ODBkOTNkZjY3NDFlMWI5MzEwZWMwZTRjN2Y1NzMuc2V0Q29udGVudChodG1sXzY4MWVmYmMzNjZjMTQ4ZWNhMWE1ZTQ2NzRmMmI0OTQ1KTsKICAgICAgICAKCiAgICAgICAgbWFya2VyXzQyMDRhZjQ5ODc1ZjQyMjNhYjQ1MGQ3NjNiNGRjZTMxLmJpbmRQb3B1cChwb3B1cF82NjY4MGQ5M2RmNjc0MWUxYjkzMTBlYzBlNGM3ZjU3MykKICAgICAgICA7CgogICAgICAgIAogICAgCiAgICAKICAgICAgICAgICAgdmFyIG1hcmtlcl82YzQ2OTMzODk0NmU0NzZiOTFjYTdiNTMxNTRiZDdiMiA9IEwubWFya2VyKAogICAgICAgICAgICAgICAgWzQwLjE4MTg4LCAtMTA1LjE5Njc3NV0sCiAgICAgICAgICAgICAgICB7fQogICAgICAgICAgICApLmFkZFRvKG1hcmtlcl9jbHVzdGVyXzdlMjdhNjRhYWM4NjRlODBiYmVkZmJkNmQ0MWY4ODAyKTsKICAgICAgICAKICAgIAogICAgICAgIHZhciBwb3B1cF80OGE4OTkxNmI1MzY0NWEzYWEwYzQzNDBjYTcyNzU2ZiA9IEwucG9wdXAoeyJtYXhXaWR0aCI6ICIxMDAlIn0pOwoKICAgICAgICAKICAgICAgICAgICAgdmFyIGh0bWxfODg1MGVkNjVlNGVmNDAxZDhkOWZiZDg3ODY5NWM0MmYgPSAkKGA8ZGl2IGlkPSJodG1sXzg4NTBlZDY1ZTRlZjQwMWQ4ZDlmYmQ4Nzg2OTVjNDJmIiBzdHlsZT0id2lkdGg6IDEwMC4wJTsgaGVpZ2h0OiAxMDAuMCU7Ij5OYW1lOiBEQVZJUyBBTkQgRE9XTklORyBESVRDSCBQcmVjaXA6IDAuMDA8L2Rpdj5gKVswXTsKICAgICAgICAgICAgcG9wdXBfNDhhODk5MTZiNTM2NDVhM2FhMGM0MzQwY2E3Mjc1NmYuc2V0Q29udGVudChodG1sXzg4NTBlZDY1ZTRlZjQwMWQ4ZDlmYmQ4Nzg2OTVjNDJmKTsKICAgICAgICAKCiAgICAgICAgbWFya2VyXzZjNDY5MzM4OTQ2ZTQ3NmI5MWNhN2I1MzE1NGJkN2IyLmJpbmRQb3B1cChwb3B1cF80OGE4OTkxNmI1MzY0NWEzYWEwYzQzNDBjYTcyNzU2ZikKICAgICAgICA7CgogICAgICAgIAogICAgCiAgICAKICAgICAgICAgICAgdmFyIG1hcmtlcl81MjAwZTM2YWYyY2Y0NjFkOGNlNmM3ODExZjI4YjUwZCA9IEwubWFya2VyKAogICAgICAgICAgICAgICAgWzQwLjI1ODM2NywgLTEwNS4xNzQ5NTddLAogICAgICAgICAgICAgICAge30KICAgICAgICAgICAgKS5hZGRUbyhtYXJrZXJfY2x1c3Rlcl83ZTI3YTY0YWFjODY0ZTgwYmJlZGZiZDZkNDFmODgwMik7CiAgICAgICAgCiAgICAKICAgICAgICB2YXIgcG9wdXBfMzBhNTBmZGJiOTdjNDgwNGE0MWQ3NmQ1ZGYxYzIwOGYgPSBMLnBvcHVwKHsibWF4V2lkdGgiOiAiMTAwJSJ9KTsKCiAgICAgICAgCiAgICAgICAgICAgIHZhciBodG1sXzcxZmFjZWM5Nzg3ODQ0MTZhM2MxMmU1NGEwYmE3MDkwID0gJChgPGRpdiBpZD0iaHRtbF83MWZhY2VjOTc4Nzg0NDE2YTNjMTJlNTRhMGJhNzA5MCIgc3R5bGU9IndpZHRoOiAxMDAuMCU7IGhlaWdodDogMTAwLjAlOyI+TmFtZTogQk9VTERFUi1MQVJJTUVSIERJVENIIE5FQVIgQkVSVEhPVUQgUHJlY2lwOiAwLjAwPC9kaXY+YClbMF07CiAgICAgICAgICAgIHBvcHVwXzMwYTUwZmRiYjk3YzQ4MDRhNDFkNzZkNWRmMWMyMDhmLnNldENvbnRlbnQoaHRtbF83MWZhY2VjOTc4Nzg0NDE2YTNjMTJlNTRhMGJhNzA5MCk7CiAgICAgICAgCgogICAgICAgIG1hcmtlcl81MjAwZTM2YWYyY2Y0NjFkOGNlNmM3ODExZjI4YjUwZC5iaW5kUG9wdXAocG9wdXBfMzBhNTBmZGJiOTdjNDgwNGE0MWQ3NmQ1ZGYxYzIwOGYpCiAgICAgICAgOwoKICAgICAgICAKICAgIAogICAgCiAgICAgICAgICAgIHZhciBtYXJrZXJfYWY4M2U3ZjU2NmIwNDcyOTkwNWYxMDBkNzQxMGU1MWYgPSBMLm1hcmtlcigKICAgICAgICAgICAgICAgIFs0MC4xMjk4MDYsIC0xMDUuNTE3MTExXSwKICAgICAgICAgICAgICAgIHt9CiAgICAgICAgICAgICkuYWRkVG8obWFya2VyX2NsdXN0ZXJfN2UyN2E2NGFhYzg2NGU4MGJiZWRmYmQ2ZDQxZjg4MDIpOwogICAgICAgIAogICAgCiAgICAgICAgdmFyIHBvcHVwXzFjOGY1Yjg4ZmNjOTRhYWVhNWYwY2RhNmJmNzc5YmE4ID0gTC5wb3B1cCh7Im1heFdpZHRoIjogIjEwMCUifSk7CgogICAgICAgIAogICAgICAgICAgICB2YXIgaHRtbF82ZTk3ZDc2MGViODI0NGVjYThjMmUzNjkxMWY0YTUyNiA9ICQoYDxkaXYgaWQ9Imh0bWxfNmU5N2Q3NjBlYjgyNDRlY2E4YzJlMzY5MTFmNGE1MjYiIHN0eWxlPSJ3aWR0aDogMTAwLjAlOyBoZWlnaHQ6IDEwMC4wJTsiPk5hbWU6IE1JRERMRSBTQUlOVCBWUkFJTiBBVCBQRUFDRUZVTCBWQUxMRVkgUHJlY2lwOiAxNy44MDwvZGl2PmApWzBdOwogICAgICAgICAgICBwb3B1cF8xYzhmNWI4OGZjYzk0YWFlYTVmMGNkYTZiZjc3OWJhOC5zZXRDb250ZW50KGh0bWxfNmU5N2Q3NjBlYjgyNDRlY2E4YzJlMzY5MTFmNGE1MjYpOwogICAgICAgIAoKICAgICAgICBtYXJrZXJfYWY4M2U3ZjU2NmIwNDcyOTkwNWYxMDBkNzQxMGU1MWYuYmluZFBvcHVwKHBvcHVwXzFjOGY1Yjg4ZmNjOTRhYWVhNWYwY2RhNmJmNzc5YmE4KQogICAgICAgIDsKCiAgICAgICAgCiAgICAKICAgIAogICAgICAgICAgICB2YXIgbWFya2VyX2Y0OTZmMDk3NGMxMDQ1MTE5YTQzZTRkODk4ZDUyYjMxID0gTC5tYXJrZXIoCiAgICAgICAgICAgICAgICBbNDAuMDc4NTYsIC0xMDUuMjIwNDk3XSwKICAgICAgICAgICAgICAgIHt9CiAgICAgICAgICAgICkuYWRkVG8obWFya2VyX2NsdXN0ZXJfN2UyN2E2NGFhYzg2NGU4MGJiZWRmYmQ2ZDQxZjg4MDIpOwogICAgICAgIAogICAgCiAgICAgICAgdmFyIHBvcHVwXzdiZTJiMjE4N2Q1ZTQyNjY4ZDhhNzFkNjIyMDU4OWEyID0gTC5wb3B1cCh7Im1heFdpZHRoIjogIjEwMCUifSk7CgogICAgICAgIAogICAgICAgICAgICB2YXIgaHRtbF9kY2IwZDc2YzFkOWE0YTI1OTY0MjIzODJkMjMyNzhmNyA9ICQoYDxkaXYgaWQ9Imh0bWxfZGNiMGQ3NmMxZDlhNGEyNTk2NDIyMzgyZDIzMjc4ZjciIHN0eWxlPSJ3aWR0aDogMTAwLjAlOyBoZWlnaHQ6IDEwMC4wJTsiPk5hbWU6IEJPVUxERVIgUkVTRVJWT0lSIFByZWNpcDogNzU1OS41MDwvZGl2PmApWzBdOwogICAgICAgICAgICBwb3B1cF83YmUyYjIxODdkNWU0MjY2OGQ4YTcxZDYyMjA1ODlhMi5zZXRDb250ZW50KGh0bWxfZGNiMGQ3NmMxZDlhNGEyNTk2NDIyMzgyZDIzMjc4ZjcpOwogICAgICAgIAoKICAgICAgICBtYXJrZXJfZjQ5NmYwOTc0YzEwNDUxMTlhNDNlNGQ4OThkNTJiMzEuYmluZFBvcHVwKHBvcHVwXzdiZTJiMjE4N2Q1ZTQyNjY4ZDhhNzFkNjIyMDU4OWEyKQogICAgICAgIDsKCiAgICAgICAgCiAgICAKICAgIAogICAgICAgICAgICB2YXIgbWFya2VyXzViNjZmZWYzODM4ZjQ5OTc5NzNiOTkzNzM5MTdmODQ5ID0gTC5tYXJrZXIoCiAgICAgICAgICAgICAgICBbNDAuMjExMDgzLCAtMTA1LjI1MDkyN10sCiAgICAgICAgICAgICAgICB7fQogICAgICAgICAgICApLmFkZFRvKG1hcmtlcl9jbHVzdGVyXzdlMjdhNjRhYWM4NjRlODBiYmVkZmJkNmQ0MWY4ODAyKTsKICAgICAgICAKICAgIAogICAgICAgIHZhciBwb3B1cF80NDA3NjM1YmNmNTU0MWViOTU3Y2Q3ZTAyZjc1ZGJhNCA9IEwucG9wdXAoeyJtYXhXaWR0aCI6ICIxMDAlIn0pOwoKICAgICAgICAKICAgICAgICAgICAgdmFyIGh0bWxfYWY2Y2U3Nzc0ZjQ5NDMzNGI3ZDczMjc0N2JhNTE5NDEgPSAkKGA8ZGl2IGlkPSJodG1sX2FmNmNlNzc3NGY0OTQzMzRiN2Q3MzI3NDdiYTUxOTQxIiBzdHlsZT0id2lkdGg6IDEwMC4wJTsgaGVpZ2h0OiAxMDAuMCU7Ij5OYW1lOiBTV0VERSBESVRDSCBQcmVjaXA6IDguNzE8L2Rpdj5gKVswXTsKICAgICAgICAgICAgcG9wdXBfNDQwNzYzNWJjZjU1NDFlYjk1N2NkN2UwMmY3NWRiYTQuc2V0Q29udGVudChodG1sX2FmNmNlNzc3NGY0OTQzMzRiN2Q3MzI3NDdiYTUxOTQxKTsKICAgICAgICAKCiAgICAgICAgbWFya2VyXzViNjZmZWYzODM4ZjQ5OTc5NzNiOTkzNzM5MTdmODQ5LmJpbmRQb3B1cChwb3B1cF80NDA3NjM1YmNmNTU0MWViOTU3Y2Q3ZTAyZjc1ZGJhNCkKICAgICAgICA7CgogICAgICAgIAogICAgCiAgICAKICAgICAgICAgICAgdmFyIG1hcmtlcl9mZGFmODIwYWY0OWU0MjhhODE1OGRhNmE5MzZkNmY2OSA9IEwubWFya2VyKAogICAgICAgICAgICAgICAgWzQwLjE3MDk5OCwgLTEwNS4xNjA4NzZdLAogICAgICAgICAgICAgICAge30KICAgICAgICAgICAgKS5hZGRUbyhtYXJrZXJfY2x1c3Rlcl83ZTI3YTY0YWFjODY0ZTgwYmJlZGZiZDZkNDFmODgwMik7CiAgICAgICAgCiAgICAKICAgICAgICB2YXIgcG9wdXBfNGQwODAzMzlkMTdkNDMzNGIzNmJmYmQyNTIyYTcyYWEgPSBMLnBvcHVwKHsibWF4V2lkdGgiOiAiMTAwJSJ9KTsKCiAgICAgICAgCiAgICAgICAgICAgIHZhciBodG1sX2I5OTM3YjQ5YWNjNDQ2OGZhNjg0NGJjNDNjY2JjNTU3ID0gJChgPGRpdiBpZD0iaHRtbF9iOTkzN2I0OWFjYzQ0NjhmYTY4NDRiYzQzY2NiYzU1NyIgc3R5bGU9IndpZHRoOiAxMDAuMCU7IGhlaWdodDogMTAwLjAlOyI+TmFtZTogU09VVEggRkxBVCBESVRDSCBQcmVjaXA6IDEuMDQ8L2Rpdj5gKVswXTsKICAgICAgICAgICAgcG9wdXBfNGQwODAzMzlkMTdkNDMzNGIzNmJmYmQyNTIyYTcyYWEuc2V0Q29udGVudChodG1sX2I5OTM3YjQ5YWNjNDQ2OGZhNjg0NGJjNDNjY2JjNTU3KTsKICAgICAgICAKCiAgICAgICAgbWFya2VyX2ZkYWY4MjBhZjQ5ZTQyOGE4MTU4ZGE2YTkzNmQ2ZjY5LmJpbmRQb3B1cChwb3B1cF80ZDA4MDMzOWQxN2Q0MzM0YjM2YmZiZDI1MjJhNzJhYSkKICAgICAgICA7CgogICAgICAgIAogICAgCiAgICAKICAgICAgICAgICAgdmFyIG1hcmtlcl9mNDNiNmQzMWVkYjY0YTIwYjkxY2FhZGNhM2Q3ZTBiYiA9IEwubWFya2VyKAogICAgICAgICAgICAgICAgWzQwLjE5Mzc1OCwgLTEwNS4yMTAzOV0sCiAgICAgICAgICAgICAgICB7fQogICAgICAgICAgICApLmFkZFRvKG1hcmtlcl9jbHVzdGVyXzdlMjdhNjRhYWM4NjRlODBiYmVkZmJkNmQ0MWY4ODAyKTsKICAgICAgICAKICAgIAogICAgICAgIHZhciBwb3B1cF9mNjJhYzYzMzc1Y2U0OGIyODEwZWIwMmEwZGQwYmI5NSA9IEwucG9wdXAoeyJtYXhXaWR0aCI6ICIxMDAlIn0pOwoKICAgICAgICAKICAgICAgICAgICAgdmFyIGh0bWxfNDY4NTAyNTEyZDM1NGQwMGFiNWFmMDg2NDdlNGFmYzYgPSAkKGA8ZGl2IGlkPSJodG1sXzQ2ODUwMjUxMmQzNTRkMDBhYjVhZjA4NjQ3ZTRhZmM2IiBzdHlsZT0id2lkdGg6IDEwMC4wJTsgaGVpZ2h0OiAxMDAuMCU7Ij5OYW1lOiBDTE9VR0ggQU5EIFRSVUUgRElUQ0ggUHJlY2lwOiAxLjY0PC9kaXY+YClbMF07CiAgICAgICAgICAgIHBvcHVwX2Y2MmFjNjMzNzVjZTQ4YjI4MTBlYjAyYTBkZDBiYjk1LnNldENvbnRlbnQoaHRtbF80Njg1MDI1MTJkMzU0ZDAwYWI1YWYwODY0N2U0YWZjNik7CiAgICAgICAgCgogICAgICAgIG1hcmtlcl9mNDNiNmQzMWVkYjY0YTIwYjkxY2FhZGNhM2Q3ZTBiYi5iaW5kUG9wdXAocG9wdXBfZjYyYWM2MzM3NWNlNDhiMjgxMGViMDJhMGRkMGJiOTUpCiAgICAgICAgOwoKICAgICAgICAKICAgIAogICAgCiAgICAgICAgICAgIHZhciBtYXJrZXJfNzQ3NDU5MmViNTQwNDMyNTg1MTE5OWVkMDk0NWI3ZjkgPSBMLm1hcmtlcigKICAgICAgICAgICAgICAgIFszOS45MzE4MTMsIC0xMDUuMzA4NDMyXSwKICAgICAgICAgICAgICAgIHt9CiAgICAgICAgICAgICkuYWRkVG8obWFya2VyX2NsdXN0ZXJfN2UyN2E2NGFhYzg2NGU4MGJiZWRmYmQ2ZDQxZjg4MDIpOwogICAgICAgIAogICAgCiAgICAgICAgdmFyIHBvcHVwXzYzNDkyNTc0OGFhZTRlNDI4YWRhN2M2ZGU0NmI2MTViID0gTC5wb3B1cCh7Im1heFdpZHRoIjogIjEwMCUifSk7CgogICAgICAgIAogICAgICAgICAgICB2YXIgaHRtbF9jNGNmZWJjNjQwODg0MTU3YmYzN2JkMDNkN2FhNjBjMiA9ICQoYDxkaXYgaWQ9Imh0bWxfYzRjZmViYzY0MDg4NDE1N2JmMzdiZDAzZDdhYTYwYzIiIHN0eWxlPSJ3aWR0aDogMTAwLjAlOyBoZWlnaHQ6IDEwMC4wJTsiPk5hbWU6IFNPVVRIIEJPVUxERVIgQ1JFRUsgRElWRVJTSU9OIE5FQVIgRUxET1JBRE8gU1BSSU5HUyBQcmVjaXA6IDkzLjcwPC9kaXY+YClbMF07CiAgICAgICAgICAgIHBvcHVwXzYzNDkyNTc0OGFhZTRlNDI4YWRhN2M2ZGU0NmI2MTViLnNldENvbnRlbnQoaHRtbF9jNGNmZWJjNjQwODg0MTU3YmYzN2JkMDNkN2FhNjBjMik7CiAgICAgICAgCgogICAgICAgIG1hcmtlcl83NDc0NTkyZWI1NDA0MzI1ODUxMTk5ZWQwOTQ1YjdmOS5iaW5kUG9wdXAocG9wdXBfNjM0OTI1NzQ4YWFlNGU0MjhhZGE3YzZkZTQ2YjYxNWIpCiAgICAgICAgOwoKICAgICAgICAKICAgIAogICAgCiAgICAgICAgICAgIHZhciBtYXJrZXJfODQ4OTVmYmQ2YTg2NDMzMmFkZWU5ZGIzMzlkMTU4OTEgPSBMLm1hcmtlcigKICAgICAgICAgICAgICAgIFs0MC4wNTMwMzUsIC0xMDUuMTkzMDQ4XSwKICAgICAgICAgICAgICAgIHt9CiAgICAgICAgICAgICkuYWRkVG8obWFya2VyX2NsdXN0ZXJfN2UyN2E2NGFhYzg2NGU4MGJiZWRmYmQ2ZDQxZjg4MDIpOwogICAgICAgIAogICAgCiAgICAgICAgdmFyIHBvcHVwXzk3ZGRkZjAxYTk0NTQ5MThiMTQwODNjNTQxZmFjMzE2ID0gTC5wb3B1cCh7Im1heFdpZHRoIjogIjEwMCUifSk7CgogICAgICAgIAogICAgICAgICAgICB2YXIgaHRtbF9jNTIzNWJlZTZkYTM0NDlkOGY0ZTczNDU4M2RiNWViYSA9ICQoYDxkaXYgaWQ9Imh0bWxfYzUyMzViZWU2ZGEzNDQ5ZDhmNGU3MzQ1ODNkYjVlYmEiIHN0eWxlPSJ3aWR0aDogMTAwLjAlOyBoZWlnaHQ6IDEwMC4wJTsiPk5hbWU6IEJPVUxERVIgQ1JFRUsgU1VQUExZIENBTkFMIFRPIEJPVUxERVIgQ1JFRUsgTkVBUiBCT1VMREVSIFByZWNpcDogMTE3LjY5PC9kaXY+YClbMF07CiAgICAgICAgICAgIHBvcHVwXzk3ZGRkZjAxYTk0NTQ5MThiMTQwODNjNTQxZmFjMzE2LnNldENvbnRlbnQoaHRtbF9jNTIzNWJlZTZkYTM0NDlkOGY0ZTczNDU4M2RiNWViYSk7CiAgICAgICAgCgogICAgICAgIG1hcmtlcl84NDg5NWZiZDZhODY0MzMyYWRlZTlkYjMzOWQxNTg5MS5iaW5kUG9wdXAocG9wdXBfOTdkZGRmMDFhOTQ1NDkxOGIxNDA4M2M1NDFmYWMzMTYpCiAgICAgICAgOwoKICAgICAgICAKICAgIAogICAgCiAgICAgICAgICAgIHZhciBtYXJrZXJfMDM1ZGExOThhOTUwNDZjY2IwZmU2ZDYxY2UwNzI0NTMgPSBMLm1hcmtlcigKICAgICAgICAgICAgICAgIFs0MC4xOTY0MjIsIC0xMDUuMjA2NTkyXSwKICAgICAgICAgICAgICAgIHt9CiAgICAgICAgICAgICkuYWRkVG8obWFya2VyX2NsdXN0ZXJfN2UyN2E2NGFhYzg2NGU4MGJiZWRmYmQ2ZDQxZjg4MDIpOwogICAgICAgIAogICAgCiAgICAgICAgdmFyIHBvcHVwXzhhYzM4MTAwNmZhZjQ0Yjg4YWU4ZWYzM2UyOTAzZGM2ID0gTC5wb3B1cCh7Im1heFdpZHRoIjogIjEwMCUifSk7CgogICAgICAgIAogICAgICAgICAgICB2YXIgaHRtbF83ZmJmYWJmYjgwODQ0ZDlhYjc4MjI0NTc1YjQxZjdjMCA9ICQoYDxkaXYgaWQ9Imh0bWxfN2ZiZmFiZmI4MDg0NGQ5YWI3ODIyNDU3NWI0MWY3YzAiIHN0eWxlPSJ3aWR0aDogMTAwLjAlOyBoZWlnaHQ6IDEwMC4wJTsiPk5hbWU6IE9MSUdBUkNIWSBESVRDSCBESVZFUlNJT04gUHJlY2lwOiAwLjE0PC9kaXY+YClbMF07CiAgICAgICAgICAgIHBvcHVwXzhhYzM4MTAwNmZhZjQ0Yjg4YWU4ZWYzM2UyOTAzZGM2LnNldENvbnRlbnQoaHRtbF83ZmJmYWJmYjgwODQ0ZDlhYjc4MjI0NTc1YjQxZjdjMCk7CiAgICAgICAgCgogICAgICAgIG1hcmtlcl8wMzVkYTE5OGE5NTA0NmNjYjBmZTZkNjFjZTA3MjQ1My5iaW5kUG9wdXAocG9wdXBfOGFjMzgxMDA2ZmFmNDRiODhhZThlZjMzZTI5MDNkYzYpCiAgICAgICAgOwoKICAgICAgICAKICAgIAogICAgCiAgICAgICAgICAgIHZhciBtYXJrZXJfNzllMDA0NmE2MGU5NGUyM2IzOTE0ZDM5NzE1YzIxMzUgPSBMLm1hcmtlcigKICAgICAgICAgICAgICAgIFs0MC4yMDQxOTMsIC0xMDUuMjE4Nzc3XSwKICAgICAgICAgICAgICAgIHt9CiAgICAgICAgICAgICkuYWRkVG8obWFya2VyX2NsdXN0ZXJfN2UyN2E2NGFhYzg2NGU4MGJiZWRmYmQ2ZDQxZjg4MDIpOwogICAgICAgIAogICAgCiAgICAgICAgdmFyIHBvcHVwX2EyM2FmMTA0NTc5NTRmYjQ4Y2FkYTcyY2ZiYTJiNjk4ID0gTC5wb3B1cCh7Im1heFdpZHRoIjogIjEwMCUifSk7CgogICAgICAgIAogICAgICAgICAgICB2YXIgaHRtbF84YjE3MjQ5ZmQ2Njk0ZWRjOTY1NTE3ZGZiMzY0NDhjZCA9ICQoYDxkaXYgaWQ9Imh0bWxfOGIxNzI0OWZkNjY5NGVkYzk2NTUxN2RmYjM2NDQ4Y2QiIHN0eWxlPSJ3aWR0aDogMTAwLjAlOyBoZWlnaHQ6IDEwMC4wJTsiPk5hbWU6IExPTkdNT05UIFNVUFBMWSBESVRDSCBQcmVjaXA6IDEzLjU0PC9kaXY+YClbMF07CiAgICAgICAgICAgIHBvcHVwX2EyM2FmMTA0NTc5NTRmYjQ4Y2FkYTcyY2ZiYTJiNjk4LnNldENvbnRlbnQoaHRtbF84YjE3MjQ5ZmQ2Njk0ZWRjOTY1NTE3ZGZiMzY0NDhjZCk7CiAgICAgICAgCgogICAgICAgIG1hcmtlcl83OWUwMDQ2YTYwZTk0ZTIzYjM5MTRkMzk3MTVjMjEzNS5iaW5kUG9wdXAocG9wdXBfYTIzYWYxMDQ1Nzk1NGZiNDhjYWRhNzJjZmJhMmI2OTgpCiAgICAgICAgOwoKICAgICAgICAKICAgIAogICAgCiAgICAgICAgICAgIHZhciBtYXJrZXJfMDFjODYyZGMwOGM5NGY2OTg5MGIwNTc2OGIxYjZkMDQgPSBMLm1hcmtlcigKICAgICAgICAgICAgICAgIFs0MC4wMTg2NjcsIC0xMDUuMzI2MjVdLAogICAgICAgICAgICAgICAge30KICAgICAgICAgICAgKS5hZGRUbyhtYXJrZXJfY2x1c3Rlcl83ZTI3YTY0YWFjODY0ZTgwYmJlZGZiZDZkNDFmODgwMik7CiAgICAgICAgCiAgICAKICAgICAgICB2YXIgcG9wdXBfNGFkNWM2M2ViZjAyNDA0ZmE1YWI4MDczYjY2MjQzOWIgPSBMLnBvcHVwKHsibWF4V2lkdGgiOiAiMTAwJSJ9KTsKCiAgICAgICAgCiAgICAgICAgICAgIHZhciBodG1sX2E5MTU3MGIwNDQyMTRiNDY4YmE0YjkwNzNmODYyZGVmID0gJChgPGRpdiBpZD0iaHRtbF9hOTE1NzBiMDQ0MjE0YjQ2OGJhNGI5MDczZjg2MmRlZiIgc3R5bGU9IndpZHRoOiAxMDAuMCU7IGhlaWdodDogMTAwLjAlOyI+TmFtZTogRk9VUk1JTEUgQ1JFRUsgQVQgT1JPREVMTCwgQ08gUHJlY2lwOiAwLjI0PC9kaXY+YClbMF07CiAgICAgICAgICAgIHBvcHVwXzRhZDVjNjNlYmYwMjQwNGZhNWFiODA3M2I2NjI0MzliLnNldENvbnRlbnQoaHRtbF9hOTE1NzBiMDQ0MjE0YjQ2OGJhNGI5MDczZjg2MmRlZik7CiAgICAgICAgCgogICAgICAgIG1hcmtlcl8wMWM4NjJkYzA4Yzk0ZjY5ODkwYjA1NzY4YjFiNmQwNC5iaW5kUG9wdXAocG9wdXBfNGFkNWM2M2ViZjAyNDA0ZmE1YWI4MDczYjY2MjQzOWIpCiAgICAgICAgOwoKICAgICAgICAKICAgIAogICAgCiAgICAgICAgICAgIHZhciBtYXJrZXJfYjEzODQ3MzI0YzkyNDk3ZWIzZDBiM2Y1NmIxYTBkZTUgPSBMLm1hcmtlcigKICAgICAgICAgICAgICAgIFs0MC4yMjA3MDIsIC0xMDUuMjYzNDldLAogICAgICAgICAgICAgICAge30KICAgICAgICAgICAgKS5hZGRUbyhtYXJrZXJfY2x1c3Rlcl83ZTI3YTY0YWFjODY0ZTgwYmJlZGZiZDZkNDFmODgwMik7CiAgICAgICAgCiAgICAKICAgICAgICB2YXIgcG9wdXBfOTZjMmU5OGM5YjRkNDIzYmI2YzJkMmQyZWQ1NTRiMTMgPSBMLnBvcHVwKHsibWF4V2lkdGgiOiAiMTAwJSJ9KTsKCiAgICAgICAgCiAgICAgICAgICAgIHZhciBodG1sXzBjMDYwMGYwMjE0ZjQ1YTc5ZDI0MzgyNTIwNGUyYWI5ID0gJChgPGRpdiBpZD0iaHRtbF8wYzA2MDBmMDIxNGY0NWE3OWQyNDM4MjUyMDRlMmFiOSIgc3R5bGU9IndpZHRoOiAxMDAuMCU7IGhlaWdodDogMTAwLjAlOyI+TmFtZTogU0FJTlQgVlJBSU4gQ1JFRUsgQVQgTFlPTlMsIENPIFByZWNpcDogNTAuMTA8L2Rpdj5gKVswXTsKICAgICAgICAgICAgcG9wdXBfOTZjMmU5OGM5YjRkNDIzYmI2YzJkMmQyZWQ1NTRiMTMuc2V0Q29udGVudChodG1sXzBjMDYwMGYwMjE0ZjQ1YTc5ZDI0MzgyNTIwNGUyYWI5KTsKICAgICAgICAKCiAgICAgICAgbWFya2VyX2IxMzg0NzMyNGM5MjQ5N2ViM2QwYjNmNTZiMWEwZGU1LmJpbmRQb3B1cChwb3B1cF85NmMyZTk4YzliNGQ0MjNiYjZjMmQyZDJlZDU1NGIxMykKICAgICAgICA7CgogICAgICAgIAogICAgCiAgICAKICAgICAgICAgICAgdmFyIG1hcmtlcl9lY2QyMmUwZWY1YzU0MTEzYjZlMmUwOWJkYmZmN2Y4MSA9IEwubWFya2VyKAogICAgICAgICAgICAgICAgWzQwLjE4ODU3OSwgLTEwNS4yMDkyODJdLAogICAgICAgICAgICAgICAge30KICAgICAgICAgICAgKS5hZGRUbyhtYXJrZXJfY2x1c3Rlcl83ZTI3YTY0YWFjODY0ZTgwYmJlZGZiZDZkNDFmODgwMik7CiAgICAgICAgCiAgICAKICAgICAgICB2YXIgcG9wdXBfNDBlMzgzYzQ5ZTFhNDc5ZTgwOWY1MWRmNzEyZjc5Y2IgPSBMLnBvcHVwKHsibWF4V2lkdGgiOiAiMTAwJSJ9KTsKCiAgICAgICAgCiAgICAgICAgICAgIHZhciBodG1sX2M5MmI0MTk4NzAyMzRlN2Y4ZDhjMTY0YWUwOThmYzMwID0gJChgPGRpdiBpZD0iaHRtbF9jOTJiNDE5ODcwMjM0ZTdmOGQ4YzE2NGFlMDk4ZmMzMCIgc3R5bGU9IndpZHRoOiAxMDAuMCU7IGhlaWdodDogMTAwLjAlOyI+TmFtZTogSkFNRVMgRElUQ0ggUHJlY2lwOiAyLjY1PC9kaXY+YClbMF07CiAgICAgICAgICAgIHBvcHVwXzQwZTM4M2M0OWUxYTQ3OWU4MDlmNTFkZjcxMmY3OWNiLnNldENvbnRlbnQoaHRtbF9jOTJiNDE5ODcwMjM0ZTdmOGQ4YzE2NGFlMDk4ZmMzMCk7CiAgICAgICAgCgogICAgICAgIG1hcmtlcl9lY2QyMmUwZWY1YzU0MTEzYjZlMmUwOWJkYmZmN2Y4MS5iaW5kUG9wdXAocG9wdXBfNDBlMzgzYzQ5ZTFhNDc5ZTgwOWY1MWRmNzEyZjc5Y2IpCiAgICAgICAgOwoKICAgICAgICAKICAgIAogICAgCiAgICAgICAgICAgIHZhciBtYXJrZXJfZmYxMDkyYWE3YTUwNDg0OWI2YjQ3NThkNzAwZWVkMTggPSBMLm1hcmtlcigKICAgICAgICAgICAgICAgIFs0MC4yNTgwMzgsIC0xMDUuMjA2Mzg2XSwKICAgICAgICAgICAgICAgIHt9CiAgICAgICAgICAgICkuYWRkVG8obWFya2VyX2NsdXN0ZXJfN2UyN2E2NGFhYzg2NGU4MGJiZWRmYmQ2ZDQxZjg4MDIpOwogICAgICAgIAogICAgCiAgICAgICAgdmFyIHBvcHVwX2QyYWFmNThkNTc5MDQxNjRiNGFkZGFiYzQxYWI2YzU0ID0gTC5wb3B1cCh7Im1heFdpZHRoIjogIjEwMCUifSk7CgogICAgICAgIAogICAgICAgICAgICB2YXIgaHRtbF9jODkwNjQ3OWY5ZmM0YzExOWE1NDUwMmYxYWJkNjJjNiA9ICQoYDxkaXYgaWQ9Imh0bWxfYzg5MDY0NzlmOWZjNGMxMTlhNTQ1MDJmMWFiZDYyYzYiIHN0eWxlPSJ3aWR0aDogMTAwLjAlOyBoZWlnaHQ6IDEwMC4wJTsiPk5hbWU6IExJVFRMRSBUSE9NUFNPTiBSSVZFUiBBVCBDQU5ZT04gTU9VVEggTkVBUiBCRVJUSE9VRCBQcmVjaXA6IDEuMjg8L2Rpdj5gKVswXTsKICAgICAgICAgICAgcG9wdXBfZDJhYWY1OGQ1NzkwNDE2NGI0YWRkYWJjNDFhYjZjNTQuc2V0Q29udGVudChodG1sX2M4OTA2NDc5ZjlmYzRjMTE5YTU0NTAyZjFhYmQ2MmM2KTsKICAgICAgICAKCiAgICAgICAgbWFya2VyX2ZmMTA5MmFhN2E1MDQ4NDliNmI0NzU4ZDcwMGVlZDE4LmJpbmRQb3B1cChwb3B1cF9kMmFhZjU4ZDU3OTA0MTY0YjRhZGRhYmM0MWFiNmM1NCkKICAgICAgICA7CgogICAgICAgIAogICAgCiAgICAKICAgICAgICAgICAgdmFyIG1hcmtlcl9iNzM3MGY1ZThiOTM0MDU2YWI3OWViOGY5ZmRmMDZmZCA9IEwubWFya2VyKAogICAgICAgICAgICAgICAgWzQwLjI1NTc3NiwgLTEwNS4yMDk1XSwKICAgICAgICAgICAgICAgIHt9CiAgICAgICAgICAgICkuYWRkVG8obWFya2VyX2NsdXN0ZXJfN2UyN2E2NGFhYzg2NGU4MGJiZWRmYmQ2ZDQxZjg4MDIpOwogICAgICAgIAogICAgCiAgICAgICAgdmFyIHBvcHVwXzRjZWJmM2IwZDk3MTQwOTlhY2Q5MTU4ZjBhYWUxYzU4ID0gTC5wb3B1cCh7Im1heFdpZHRoIjogIjEwMCUifSk7CgogICAgICAgIAogICAgICAgICAgICB2YXIgaHRtbF9kN2JiY2RiYTQ1ZWQ0ODRmOTRiY2ZkZGVkNjEyY2FkNSA9ICQoYDxkaXYgaWQ9Imh0bWxfZDdiYmNkYmE0NWVkNDg0Zjk0YmNmZGRlZDYxMmNhZDUiIHN0eWxlPSJ3aWR0aDogMTAwLjAlOyBoZWlnaHQ6IDEwMC4wJTsiPk5hbWU6IExJVFRMRSBUSE9NUFNPTiAjMiBESVRDSCBQcmVjaXA6IDcuNTM8L2Rpdj5gKVswXTsKICAgICAgICAgICAgcG9wdXBfNGNlYmYzYjBkOTcxNDA5OWFjZDkxNThmMGFhZTFjNTguc2V0Q29udGVudChodG1sX2Q3YmJjZGJhNDVlZDQ4NGY5NGJjZmRkZWQ2MTJjYWQ1KTsKICAgICAgICAKCiAgICAgICAgbWFya2VyX2I3MzcwZjVlOGI5MzQwNTZhYjc5ZWI4ZjlmZGYwNmZkLmJpbmRQb3B1cChwb3B1cF80Y2ViZjNiMGQ5NzE0MDk5YWNkOTE1OGYwYWFlMWM1OCkKICAgICAgICA7CgogICAgICAgIAogICAgCiAgICAKICAgICAgICAgICAgdmFyIG1hcmtlcl84YmQ4ZTk3YzUzNDM0ZjZlODE5NDhlNjIzMGIzNmFhNCA9IEwubWFya2VyKAogICAgICAgICAgICAgICAgWzQwLjEzNDI3OCwgLTEwNS4xMzA4MTldLAogICAgICAgICAgICAgICAge30KICAgICAgICAgICAgKS5hZGRUbyhtYXJrZXJfY2x1c3Rlcl83ZTI3YTY0YWFjODY0ZTgwYmJlZGZiZDZkNDFmODgwMik7CiAgICAgICAgCiAgICAKICAgICAgICB2YXIgcG9wdXBfZTE5NGM4ZmQzYzM4NDcwZmE4OGEwZjQzOWI3YTFiOTQgPSBMLnBvcHVwKHsibWF4V2lkdGgiOiAiMTAwJSJ9KTsKCiAgICAgICAgCiAgICAgICAgICAgIHZhciBodG1sX2M1M2Q5ZWMyZjZhMDRmNzc4MzllOWQzNzQxYzYwYzQzID0gJChgPGRpdiBpZD0iaHRtbF9jNTNkOWVjMmY2YTA0Zjc3ODM5ZTlkMzc0MWM2MGM0MyIgc3R5bGU9IndpZHRoOiAxMDAuMCU7IGhlaWdodDogMTAwLjAlOyI+TmFtZTogTEVGVCBIQU5EIENSRUVLIEFUIEhPVkVSIFJPQUQgTkVBUiBMT05HTU9OVCwgQ08gUHJlY2lwOiAzLjI5PC9kaXY+YClbMF07CiAgICAgICAgICAgIHBvcHVwX2UxOTRjOGZkM2MzODQ3MGZhODhhMGY0MzliN2ExYjk0LnNldENvbnRlbnQoaHRtbF9jNTNkOWVjMmY2YTA0Zjc3ODM5ZTlkMzc0MWM2MGM0Myk7CiAgICAgICAgCgogICAgICAgIG1hcmtlcl84YmQ4ZTk3YzUzNDM0ZjZlODE5NDhlNjIzMGIzNmFhNC5iaW5kUG9wdXAocG9wdXBfZTE5NGM4ZmQzYzM4NDcwZmE4OGEwZjQzOWI3YTFiOTQpCiAgICAgICAgOwoKICAgICAgICAKICAgIAogICAgCiAgICAgICAgICAgIHZhciBtYXJrZXJfMTc1ODg1OWRmNTc5NDBlYmIxZmI3NTNmYWM1MGNkMDMgPSBMLm1hcmtlcigKICAgICAgICAgICAgICAgIFs0MC4wNDIwMjgsIC0xMDUuMzY0OTE3XSwKICAgICAgICAgICAgICAgIHt9CiAgICAgICAgICAgICkuYWRkVG8obWFya2VyX2NsdXN0ZXJfN2UyN2E2NGFhYzg2NGU4MGJiZWRmYmQ2ZDQxZjg4MDIpOwogICAgICAgIAogICAgCiAgICAgICAgdmFyIHBvcHVwXzBjNzdkNDY4MmUyYTQwNTJhMGE0ZjQxNjJhNjA4Yzg1ID0gTC5wb3B1cCh7Im1heFdpZHRoIjogIjEwMCUifSk7CgogICAgICAgIAogICAgICAgICAgICB2YXIgaHRtbF9iNTgwZWI2MTdjY2I0NDZhOGI2ZTQyZWVkOWU2OTdjZSA9ICQoYDxkaXYgaWQ9Imh0bWxfYjU4MGViNjE3Y2NiNDQ2YThiNmU0MmVlZDllNjk3Y2UiIHN0eWxlPSJ3aWR0aDogMTAwLjAlOyBoZWlnaHQ6IDEwMC4wJTsiPk5hbWU6IEZPVVJNSUxFIENSRUVLIEFUIExPR0FOIE1JTEwgUk9BRCBORUFSIENSSVNNQU4sIENPIFByZWNpcDogbmFuPC9kaXY+YClbMF07CiAgICAgICAgICAgIHBvcHVwXzBjNzdkNDY4MmUyYTQwNTJhMGE0ZjQxNjJhNjA4Yzg1LnNldENvbnRlbnQoaHRtbF9iNTgwZWI2MTdjY2I0NDZhOGI2ZTQyZWVkOWU2OTdjZSk7CiAgICAgICAgCgogICAgICAgIG1hcmtlcl8xNzU4ODU5ZGY1Nzk0MGViYjFmYjc1M2ZhYzUwY2QwMy5iaW5kUG9wdXAocG9wdXBfMGM3N2Q0NjgyZTJhNDA1MmEwYTRmNDE2MmE2MDhjODUpCiAgICAgICAgOwoKICAgICAgICAKICAgIAogICAgCiAgICAgICAgICAgIHZhciBtYXJrZXJfYTJhNTk2ODZhYTVhNDczZTllYjRiNjM3YzNmNWI0NWYgPSBMLm1hcmtlcigKICAgICAgICAgICAgICAgIFs0MC4wNTk4MDksIC0xMDUuMDk3ODcyXSwKICAgICAgICAgICAgICAgIHt9CiAgICAgICAgICAgICkuYWRkVG8obWFya2VyX2NsdXN0ZXJfN2UyN2E2NGFhYzg2NGU4MGJiZWRmYmQ2ZDQxZjg4MDIpOwogICAgICAgIAogICAgCiAgICAgICAgdmFyIHBvcHVwXzE3ODViMTM0NjRkNjRhNzBiMTI4MmU4YjlhYzc4NDIwID0gTC5wb3B1cCh7Im1heFdpZHRoIjogIjEwMCUifSk7CgogICAgICAgIAogICAgICAgICAgICB2YXIgaHRtbF80NmU2Y2FiZDJiYTE0MzVmOWRhYmFlNWY2MzhmMGQ0MyA9ICQoYDxkaXYgaWQ9Imh0bWxfNDZlNmNhYmQyYmExNDM1ZjlkYWJhZTVmNjM4ZjBkNDMiIHN0eWxlPSJ3aWR0aDogMTAwLjAlOyBoZWlnaHQ6IDEwMC4wJTsiPk5hbWU6IEJPVUxERVIgQ1JFRUsgQVQgMTA5IFNUIE5FQVIgRVJJRSwgQ08gUHJlY2lwOiA3LjczPC9kaXY+YClbMF07CiAgICAgICAgICAgIHBvcHVwXzE3ODViMTM0NjRkNjRhNzBiMTI4MmU4YjlhYzc4NDIwLnNldENvbnRlbnQoaHRtbF80NmU2Y2FiZDJiYTE0MzVmOWRhYmFlNWY2MzhmMGQ0Myk7CiAgICAgICAgCgogICAgICAgIG1hcmtlcl9hMmE1OTY4NmFhNWE0NzNlOWViNGI2MzdjM2Y1YjQ1Zi5iaW5kUG9wdXAocG9wdXBfMTc4NWIxMzQ2NGQ2NGE3MGIxMjgyZThiOWFjNzg0MjApCiAgICAgICAgOwoKICAgICAgICAKICAgIAogICAgCiAgICAgICAgICAgIHZhciBtYXJrZXJfMGU1ZTlkYWFmMGQwNDE1MDg5ZjVlNDY0ZjY2ZDNhMGQgPSBMLm1hcmtlcigKICAgICAgICAgICAgICAgIFs0MC4xNzI5MjUsIC0xMDUuMTY3NjIyXSwKICAgICAgICAgICAgICAgIHt9CiAgICAgICAgICAgICkuYWRkVG8obWFya2VyX2NsdXN0ZXJfN2UyN2E2NGFhYzg2NGU4MGJiZWRmYmQ2ZDQxZjg4MDIpOwogICAgICAgIAogICAgCiAgICAgICAgdmFyIHBvcHVwXzkyYTcyMDVkN2NmNjQ3ZGRhNGE3MmZmOTVmNTRmOWFjID0gTC5wb3B1cCh7Im1heFdpZHRoIjogIjEwMCUifSk7CgogICAgICAgIAogICAgICAgICAgICB2YXIgaHRtbF9jYzQ4MWU2ZmIyZDg0ZTY2YWUwYzU0ZmI1MGFmMDU2YyA9ICQoYDxkaXYgaWQ9Imh0bWxfY2M0ODFlNmZiMmQ4NGU2NmFlMGM1NGZiNTBhZjA1NmMiIHN0eWxlPSJ3aWR0aDogMTAwLjAlOyBoZWlnaHQ6IDEwMC4wJTsiPk5hbWU6IE5PUlRIV0VTVCBNVVRVQUwgRElUQ0ggUHJlY2lwOiAxLjY2PC9kaXY+YClbMF07CiAgICAgICAgICAgIHBvcHVwXzkyYTcyMDVkN2NmNjQ3ZGRhNGE3MmZmOTVmNTRmOWFjLnNldENvbnRlbnQoaHRtbF9jYzQ4MWU2ZmIyZDg0ZTY2YWUwYzU0ZmI1MGFmMDU2Yyk7CiAgICAgICAgCgogICAgICAgIG1hcmtlcl8wZTVlOWRhYWYwZDA0MTUwODlmNWU0NjRmNjZkM2EwZC5iaW5kUG9wdXAocG9wdXBfOTJhNzIwNWQ3Y2Y2NDdkZGE0YTcyZmY5NWY1NGY5YWMpCiAgICAgICAgOwoKICAgICAgICAKICAgIAogICAgCiAgICAgICAgICAgIHZhciBtYXJrZXJfOThhNTQ3MmMwMDAyNGRmZThjNjI3MGMxY2Y0NmJjOGYgPSBMLm1hcmtlcigKICAgICAgICAgICAgICAgIFs0MC4yMTkwNDYsIC0xMDUuMjU5Nzk1XSwKICAgICAgICAgICAgICAgIHt9CiAgICAgICAgICAgICkuYWRkVG8obWFya2VyX2NsdXN0ZXJfN2UyN2E2NGFhYzg2NGU4MGJiZWRmYmQ2ZDQxZjg4MDIpOwogICAgICAgIAogICAgCiAgICAgICAgdmFyIHBvcHVwX2FjNjFhYjc0N2I5MzQ4MjY5YjhlZjFhNjBlMDA3MzA0ID0gTC5wb3B1cCh7Im1heFdpZHRoIjogIjEwMCUifSk7CgogICAgICAgIAogICAgICAgICAgICB2YXIgaHRtbF9hYmY2ZjFhM2Y0NTU0Y2ExYjczZDRmY2E1YzAzZTljOCA9ICQoYDxkaXYgaWQ9Imh0bWxfYWJmNmYxYTNmNDU1NGNhMWI3M2Q0ZmNhNWMwM2U5YzgiIHN0eWxlPSJ3aWR0aDogMTAwLjAlOyBoZWlnaHQ6IDEwMC4wJTsiPk5hbWU6IFNVUFBMWSBESVRDSCBQcmVjaXA6IDMuNDQ8L2Rpdj5gKVswXTsKICAgICAgICAgICAgcG9wdXBfYWM2MWFiNzQ3YjkzNDgyNjliOGVmMWE2MGUwMDczMDQuc2V0Q29udGVudChodG1sX2FiZjZmMWEzZjQ1NTRjYTFiNzNkNGZjYTVjMDNlOWM4KTsKICAgICAgICAKCiAgICAgICAgbWFya2VyXzk4YTU0NzJjMDAwMjRkZmU4YzYyNzBjMWNmNDZiYzhmLmJpbmRQb3B1cChwb3B1cF9hYzYxYWI3NDdiOTM0ODI2OWI4ZWYxYTYwZTAwNzMwNCkKICAgICAgICA7CgogICAgICAgIAogICAgCiAgICAKICAgICAgICAgICAgdmFyIG1hcmtlcl8xZjgxOWYyNWU5MmI0N2E4OWMyNmQ1ZWI2YjI2OGFmOSA9IEwubWFya2VyKAogICAgICAgICAgICAgICAgWzQwLjA5MDgyLCAtMTA1LjUxNDQ0Ml0sCiAgICAgICAgICAgICAgICB7fQogICAgICAgICAgICApLmFkZFRvKG1hcmtlcl9jbHVzdGVyXzdlMjdhNjRhYWM4NjRlODBiYmVkZmJkNmQ0MWY4ODAyKTsKICAgICAgICAKICAgIAogICAgICAgIHZhciBwb3B1cF80OWQ0ODJkZTdkNGM0ODFhYjhmNmYzNmIyMGVhZjdmZSA9IEwucG9wdXAoeyJtYXhXaWR0aCI6ICIxMDAlIn0pOwoKICAgICAgICAKICAgICAgICAgICAgdmFyIGh0bWxfM2ZiNDZmYzg5NDcxNDIxZTk4YTVjZDQ5NDJkNDViNWUgPSAkKGA8ZGl2IGlkPSJodG1sXzNmYjQ2ZmM4OTQ3MTQyMWU5OGE1Y2Q0OTQyZDQ1YjVlIiBzdHlsZT0id2lkdGg6IDEwMC4wJTsgaGVpZ2h0OiAxMDAuMCU7Ij5OYW1lOiBTT1VUSCBTQUlOVCBWUkFJTiBORUFSIFdBUkQgUHJlY2lwOiAzMy4zMDwvZGl2PmApWzBdOwogICAgICAgICAgICBwb3B1cF80OWQ0ODJkZTdkNGM0ODFhYjhmNmYzNmIyMGVhZjdmZS5zZXRDb250ZW50KGh0bWxfM2ZiNDZmYzg5NDcxNDIxZTk4YTVjZDQ5NDJkNDViNWUpOwogICAgICAgIAoKICAgICAgICBtYXJrZXJfMWY4MTlmMjVlOTJiNDdhODljMjZkNWViNmIyNjhhZjkuYmluZFBvcHVwKHBvcHVwXzQ5ZDQ4MmRlN2Q0YzQ4MWFiOGY2ZjM2YjIwZWFmN2ZlKQogICAgICAgIDsKCiAgICAgICAgCiAgICAKICAgIAogICAgICAgICAgICB2YXIgbWFya2VyX2FiNGJhM2U0MDAzOTQ5YTI5Yzk4NmM4NjM4OTliMjAxID0gTC5tYXJrZXIoCiAgICAgICAgICAgICAgICBbNDAuMjE2MjYzLCAtMTA1LjM2NTM2NV0sCiAgICAgICAgICAgICAgICB7fQogICAgICAgICAgICApLmFkZFRvKG1hcmtlcl9jbHVzdGVyXzdlMjdhNjRhYWM4NjRlODBiYmVkZmJkNmQ0MWY4ODAyKTsKICAgICAgICAKICAgIAogICAgICAgIHZhciBwb3B1cF9kNTE1Y2E3MDRkNjY0YzAwYjRmYTA0ZjAyMjAwNGMyMyA9IEwucG9wdXAoeyJtYXhXaWR0aCI6ICIxMDAlIn0pOwoKICAgICAgICAKICAgICAgICAgICAgdmFyIGh0bWxfY2QyOTVjY2Q2MDg2NDExNjlkYWNkNjQyYmFkZjgxZDEgPSAkKGA8ZGl2IGlkPSJodG1sX2NkMjk1Y2NkNjA4NjQxMTY5ZGFjZDY0MmJhZGY4MWQxIiBzdHlsZT0id2lkdGg6IDEwMC4wJTsgaGVpZ2h0OiAxMDAuMCU7Ij5OYW1lOiBCVVRUT05ST0NLIChSQUxQSCBQUklDRSkgUkVTRVJWT0lSIFByZWNpcDogMTYyMTcuMDA8L2Rpdj5gKVswXTsKICAgICAgICAgICAgcG9wdXBfZDUxNWNhNzA0ZDY2NGMwMGI0ZmEwNGYwMjIwMDRjMjMuc2V0Q29udGVudChodG1sX2NkMjk1Y2NkNjA4NjQxMTY5ZGFjZDY0MmJhZGY4MWQxKTsKICAgICAgICAKCiAgICAgICAgbWFya2VyX2FiNGJhM2U0MDAzOTQ5YTI5Yzk4NmM4NjM4OTliMjAxLmJpbmRQb3B1cChwb3B1cF9kNTE1Y2E3MDRkNjY0YzAwYjRmYTA0ZjAyMjAwNGMyMykKICAgICAgICA7CgogICAgICAgIAogICAgCiAgICAKICAgICAgICAgICAgdmFyIG1hcmtlcl8yMWU4MjUwMzhiMDg0NWIyYmFlODRlZTNiYTQzYWVhYyA9IEwubWFya2VyKAogICAgICAgICAgICAgICAgWzM5LjkzMTU5NywgLTEwNS4zMDQ5OV0sCiAgICAgICAgICAgICAgICB7fQogICAgICAgICAgICApLmFkZFRvKG1hcmtlcl9jbHVzdGVyXzdlMjdhNjRhYWM4NjRlODBiYmVkZmJkNmQ0MWY4ODAyKTsKICAgICAgICAKICAgIAogICAgICAgIHZhciBwb3B1cF9jNjZmNDQ0ZWQxNGE0MWNjODc4ODg3MDUzZGE0YmQ3ZSA9IEwucG9wdXAoeyJtYXhXaWR0aCI6ICIxMDAlIn0pOwoKICAgICAgICAKICAgICAgICAgICAgdmFyIGh0bWxfZDdhYjQ3ZjRjOTZkNDUyNmEzY2U3YjQwOGEwMzk5NGUgPSAkKGA8ZGl2IGlkPSJodG1sX2Q3YWI0N2Y0Yzk2ZDQ1MjZhM2NlN2I0MDhhMDM5OTRlIiBzdHlsZT0id2lkdGg6IDEwMC4wJTsgaGVpZ2h0OiAxMDAuMCU7Ij5OYW1lOiBTT1VUSCBCT1VMREVSIENSRUVLIE5FQVIgRUxET1JBRE8gU1BSSU5HUywgQ08uIFByZWNpcDogMjQuMDA8L2Rpdj5gKVswXTsKICAgICAgICAgICAgcG9wdXBfYzY2ZjQ0NGVkMTRhNDFjYzg3ODg4NzA1M2RhNGJkN2Uuc2V0Q29udGVudChodG1sX2Q3YWI0N2Y0Yzk2ZDQ1MjZhM2NlN2I0MDhhMDM5OTRlKTsKICAgICAgICAKCiAgICAgICAgbWFya2VyXzIxZTgyNTAzOGIwODQ1YjJiYWU4NGVlM2JhNDNhZWFjLmJpbmRQb3B1cChwb3B1cF9jNjZmNDQ0ZWQxNGE0MWNjODc4ODg3MDUzZGE0YmQ3ZSkKICAgICAgICA7CgogICAgICAgIAogICAgCiAgICAKICAgICAgICAgICAgdmFyIG1hcmtlcl8xNTdjZjRjMWQ5ZjM0Nzk5YTU3ODRlMjhhYWIwOTVjNiA9IEwubWFya2VyKAogICAgICAgICAgICAgICAgWzQwLjE4NTAzMywgLTEwNS4xODU3ODldLAogICAgICAgICAgICAgICAge30KICAgICAgICAgICAgKS5hZGRUbyhtYXJrZXJfY2x1c3Rlcl83ZTI3YTY0YWFjODY0ZTgwYmJlZGZiZDZkNDFmODgwMik7CiAgICAgICAgCiAgICAKICAgICAgICB2YXIgcG9wdXBfMmIwNmMyMzZhNWI2NDFkMzhjNDBkNjA0Mjc2OWFmNzUgPSBMLnBvcHVwKHsibWF4V2lkdGgiOiAiMTAwJSJ9KTsKCiAgICAgICAgCiAgICAgICAgICAgIHZhciBodG1sXzZmMzNkYWEwN2Y4NzQ0Njk4ZjI4ZGUxMWYwZjMxYTU2ID0gJChgPGRpdiBpZD0iaHRtbF82ZjMzZGFhMDdmODc0NDY5OGYyOGRlMTFmMGYzMWE1NiIgc3R5bGU9IndpZHRoOiAxMDAuMCU7IGhlaWdodDogMTAwLjAlOyI+TmFtZTogWldFQ0sgQU5EIFRVUk5FUiBESVRDSCBQcmVjaXA6IDEyLjg0PC9kaXY+YClbMF07CiAgICAgICAgICAgIHBvcHVwXzJiMDZjMjM2YTViNjQxZDM4YzQwZDYwNDI3NjlhZjc1LnNldENvbnRlbnQoaHRtbF82ZjMzZGFhMDdmODc0NDY5OGYyOGRlMTFmMGYzMWE1Nik7CiAgICAgICAgCgogICAgICAgIG1hcmtlcl8xNTdjZjRjMWQ5ZjM0Nzk5YTU3ODRlMjhhYWIwOTVjNi5iaW5kUG9wdXAocG9wdXBfMmIwNmMyMzZhNWI2NDFkMzhjNDBkNjA0Mjc2OWFmNzUpCiAgICAgICAgOwoKICAgICAgICAKICAgIAogICAgCiAgICAgICAgICAgIHZhciBtYXJrZXJfZWMyMmQwYTVlZTMzNDYwZWExODBkMmVmZGMwZTg2MzQgPSBMLm1hcmtlcigKICAgICAgICAgICAgICAgIFs0MC4xNTMzNDEsIC0xMDUuMDc1Njk1XSwKICAgICAgICAgICAgICAgIHt9CiAgICAgICAgICAgICkuYWRkVG8obWFya2VyX2NsdXN0ZXJfN2UyN2E2NGFhYzg2NGU4MGJiZWRmYmQ2ZDQxZjg4MDIpOwogICAgICAgIAogICAgCiAgICAgICAgdmFyIHBvcHVwXzJiNmYxMzE2OTI0YjQ0MmU4YTU0ZmRiODRkYzc1Mzc2ID0gTC5wb3B1cCh7Im1heFdpZHRoIjogIjEwMCUifSk7CgogICAgICAgIAogICAgICAgICAgICB2YXIgaHRtbF8yODcwMzgxZTRlOTA0M2EzYjljMzk0YTQzNmU2OTQ0YSA9ICQoYDxkaXYgaWQ9Imh0bWxfMjg3MDM4MWU0ZTkwNDNhM2I5YzM5NGE0MzZlNjk0NGEiIHN0eWxlPSJ3aWR0aDogMTAwLjAlOyBoZWlnaHQ6IDEwMC4wJTsiPk5hbWU6IFNBSU5UIFZSQUlOIENSRUVLIEJFTE9XIEtFTiBQUkFUVCBCTFZEIEFUIExPTkdNT05ULCBDTyBQcmVjaXA6IDQ2LjYwPC9kaXY+YClbMF07CiAgICAgICAgICAgIHBvcHVwXzJiNmYxMzE2OTI0YjQ0MmU4YTU0ZmRiODRkYzc1Mzc2LnNldENvbnRlbnQoaHRtbF8yODcwMzgxZTRlOTA0M2EzYjljMzk0YTQzNmU2OTQ0YSk7CiAgICAgICAgCgogICAgICAgIG1hcmtlcl9lYzIyZDBhNWVlMzM0NjBlYTE4MGQyZWZkYzBlODYzNC5iaW5kUG9wdXAocG9wdXBfMmI2ZjEzMTY5MjRiNDQyZThhNTRmZGI4NGRjNzUzNzYpCiAgICAgICAgOwoKICAgICAgICAKICAgIAogICAgCiAgICAgICAgICAgIHZhciBtYXJrZXJfMzg3NDJjZDYyNzJmNDVlYTgwZTMzMzE1YmJkODM2YWMgPSBMLm1hcmtlcigKICAgICAgICAgICAgICAgIFs0MC4xOTkzMjEsIC0xMDUuMjIyNjM5XSwKICAgICAgICAgICAgICAgIHt9CiAgICAgICAgICAgICkuYWRkVG8obWFya2VyX2NsdXN0ZXJfN2UyN2E2NGFhYzg2NGU4MGJiZWRmYmQ2ZDQxZjg4MDIpOwogICAgICAgIAogICAgCiAgICAgICAgdmFyIHBvcHVwXzM2NzJkMDhhYjQ1ODQxMjE5ODI0ODgyN2RjNGVlYzY0ID0gTC5wb3B1cCh7Im1heFdpZHRoIjogIjEwMCUifSk7CgogICAgICAgIAogICAgICAgICAgICB2YXIgaHRtbF8zZTRlZTU2NzJmNDk0NmQ2OTEzNmE5YTkwNjcxNjQwOSA9ICQoYDxkaXYgaWQ9Imh0bWxfM2U0ZWU1NjcyZjQ5NDZkNjkxMzZhOWE5MDY3MTY0MDkiIHN0eWxlPSJ3aWR0aDogMTAwLjAlOyBoZWlnaHQ6IDEwMC4wJTsiPk5hbWU6IEdPU1MgRElUQ0ggMSBQcmVjaXA6IDAuMTk8L2Rpdj5gKVswXTsKICAgICAgICAgICAgcG9wdXBfMzY3MmQwOGFiNDU4NDEyMTk4MjQ4ODI3ZGM0ZWVjNjQuc2V0Q29udGVudChodG1sXzNlNGVlNTY3MmY0OTQ2ZDY5MTM2YTlhOTA2NzE2NDA5KTsKICAgICAgICAKCiAgICAgICAgbWFya2VyXzM4NzQyY2Q2MjcyZjQ1ZWE4MGUzMzMxNWJiZDgzNmFjLmJpbmRQb3B1cChwb3B1cF8zNjcyZDA4YWI0NTg0MTIxOTgyNDg4MjdkYzRlZWM2NCkKICAgICAgICA7CgogICAgICAgIAogICAgCiAgICAKICAgICAgICAgICAgdmFyIG1hcmtlcl9mNDU2ZjY2OTM2NGY0YmI5YWM4YTA3YTJhMTE4YWE2ZSA9IEwubWFya2VyKAogICAgICAgICAgICAgICAgWzM5Ljk2MTY1NSwgLTEwNS41MDQ0NF0sCiAgICAgICAgICAgICAgICB7fQogICAgICAgICAgICApLmFkZFRvKG1hcmtlcl9jbHVzdGVyXzdlMjdhNjRhYWM4NjRlODBiYmVkZmJkNmQ0MWY4ODAyKTsKICAgICAgICAKICAgIAogICAgICAgIHZhciBwb3B1cF9kZGY2NDZiOTIxMmQ0YTdlYjE4YjNkM2NhZmRkODgxNCA9IEwucG9wdXAoeyJtYXhXaWR0aCI6ICIxMDAlIn0pOwoKICAgICAgICAKICAgICAgICAgICAgdmFyIGh0bWxfNGVjMTRiNWUyMDJmNGM5NThlNmRhMzA5NzhmY2Q2MmEgPSAkKGA8ZGl2IGlkPSJodG1sXzRlYzE0YjVlMjAyZjRjOTU4ZTZkYTMwOTc4ZmNkNjJhIiBzdHlsZT0id2lkdGg6IDEwMC4wJTsgaGVpZ2h0OiAxMDAuMCU7Ij5OYW1lOiBNSURETEUgQk9VTERFUiBDUkVFSyBBVCBORURFUkxBTkQsIENPLiBQcmVjaXA6IDI3LjYwPC9kaXY+YClbMF07CiAgICAgICAgICAgIHBvcHVwX2RkZjY0NmI5MjEyZDRhN2ViMThiM2QzY2FmZGQ4ODE0LnNldENvbnRlbnQoaHRtbF80ZWMxNGI1ZTIwMmY0Yzk1OGU2ZGEzMDk3OGZjZDYyYSk7CiAgICAgICAgCgogICAgICAgIG1hcmtlcl9mNDU2ZjY2OTM2NGY0YmI5YWM4YTA3YTJhMTE4YWE2ZS5iaW5kUG9wdXAocG9wdXBfZGRmNjQ2YjkyMTJkNGE3ZWIxOGIzZDNjYWZkZDg4MTQpCiAgICAgICAgOwoKICAgICAgICAKICAgIAogICAgCiAgICAgICAgICAgIHZhciBtYXJrZXJfMGVlZmNlYWExMGNmNGQ4OTk0ZmRiZGI1ODZmYzc2ZjMgPSBMLm1hcmtlcigKICAgICAgICAgICAgICAgIFs0MC4xMjYzODksIC0xMDUuMzA0NDA0XSwKICAgICAgICAgICAgICAgIHt9CiAgICAgICAgICAgICkuYWRkVG8obWFya2VyX2NsdXN0ZXJfN2UyN2E2NGFhYzg2NGU4MGJiZWRmYmQ2ZDQxZjg4MDIpOwogICAgICAgIAogICAgCiAgICAgICAgdmFyIHBvcHVwX2U4MTIzMGUyNjAwZDQwNjRiNjBiNzlkZWZlMDI3OTk1ID0gTC5wb3B1cCh7Im1heFdpZHRoIjogIjEwMCUifSk7CgogICAgICAgIAogICAgICAgICAgICB2YXIgaHRtbF8yZDc0NDNjYmQ4MDg0MTIwOTM3ZWQxODFjZTllZTk0NiA9ICQoYDxkaXYgaWQ9Imh0bWxfMmQ3NDQzY2JkODA4NDEyMDkzN2VkMTgxY2U5ZWU5NDYiIHN0eWxlPSJ3aWR0aDogMTAwLjAlOyBoZWlnaHQ6IDEwMC4wJTsiPk5hbWU6IExFRlQgSEFORCBDUkVFSyBORUFSIEJPVUxERVIsIENPLiBQcmVjaXA6IDMzLjQwPC9kaXY+YClbMF07CiAgICAgICAgICAgIHBvcHVwX2U4MTIzMGUyNjAwZDQwNjRiNjBiNzlkZWZlMDI3OTk1LnNldENvbnRlbnQoaHRtbF8yZDc0NDNjYmQ4MDg0MTIwOTM3ZWQxODFjZTllZTk0Nik7CiAgICAgICAgCgogICAgICAgIG1hcmtlcl8wZWVmY2VhYTEwY2Y0ZDg5OTRmZGJkYjU4NmZjNzZmMy5iaW5kUG9wdXAocG9wdXBfZTgxMjMwZTI2MDBkNDA2NGI2MGI3OWRlZmUwMjc5OTUpCiAgICAgICAgOwoKICAgICAgICAKICAgIAogICAgCiAgICAgICAgICAgIHZhciBtYXJrZXJfZGYzNDE0OTZhMzJkNGQ4ZjliZDM1YTBkOTY5YTNjZjEgPSBMLm1hcmtlcigKICAgICAgICAgICAgICAgIFszOS45ODYxNjksIC0xMDUuMjE4Njc3XSwKICAgICAgICAgICAgICAgIHt9CiAgICAgICAgICAgICkuYWRkVG8obWFya2VyX2NsdXN0ZXJfN2UyN2E2NGFhYzg2NGU4MGJiZWRmYmQ2ZDQxZjg4MDIpOwogICAgICAgIAogICAgCiAgICAgICAgdmFyIHBvcHVwX2IxOTg5OTc0YmExNTQ3ZTZiM2RhOTVmNWI3MDYxOWFlID0gTC5wb3B1cCh7Im1heFdpZHRoIjogIjEwMCUifSk7CgogICAgICAgIAogICAgICAgICAgICB2YXIgaHRtbF9mYWZhMzkwM2YwMGQ0NTA1OWY1YjBkOWYyYjljYjRmMiA9ICQoYDxkaXYgaWQ9Imh0bWxfZmFmYTM5MDNmMDBkNDUwNTlmNWIwZDlmMmI5Y2I0ZjIiIHN0eWxlPSJ3aWR0aDogMTAwLjAlOyBoZWlnaHQ6IDEwMC4wJTsiPk5hbWU6IERSWSBDUkVFSyBDQVJSSUVSIFByZWNpcDogMi4zMTwvZGl2PmApWzBdOwogICAgICAgICAgICBwb3B1cF9iMTk4OTk3NGJhMTU0N2U2YjNkYTk1ZjViNzA2MTlhZS5zZXRDb250ZW50KGh0bWxfZmFmYTM5MDNmMDBkNDUwNTlmNWIwZDlmMmI5Y2I0ZjIpOwogICAgICAgIAoKICAgICAgICBtYXJrZXJfZGYzNDE0OTZhMzJkNGQ4ZjliZDM1YTBkOTY5YTNjZjEuYmluZFBvcHVwKHBvcHVwX2IxOTg5OTc0YmExNTQ3ZTZiM2RhOTVmNWI3MDYxOWFlKQogICAgICAgIDsKCiAgICAgICAgCiAgICAKICAgIAogICAgICAgICAgICB2YXIgbWFya2VyXzVmNDQzMjk2YTE2NTRlN2E5NjVmOGRlMTdkMDBhMDhkID0gTC5tYXJrZXIoCiAgICAgICAgICAgICAgICBbNDAuMjE4MzM1LCAtMTA1LjI1ODExXSwKICAgICAgICAgICAgICAgIHt9CiAgICAgICAgICAgICkuYWRkVG8obWFya2VyX2NsdXN0ZXJfN2UyN2E2NGFhYzg2NGU4MGJiZWRmYmQ2ZDQxZjg4MDIpOwogICAgICAgIAogICAgCiAgICAgICAgdmFyIHBvcHVwX2QyYWE4ZDI1ZGEzMTRjYTJhYWU1ZWViYmNhZGE1NDI2ID0gTC5wb3B1cCh7Im1heFdpZHRoIjogIjEwMCUifSk7CgogICAgICAgIAogICAgICAgICAgICB2YXIgaHRtbF9hMzAxOWFiZGI5OGM0NmQyOWJlNjRlOThhNDdjZDY1OSA9ICQoYDxkaXYgaWQ9Imh0bWxfYTMwMTlhYmRiOThjNDZkMjliZTY0ZTk4YTQ3Y2Q2NTkiIHN0eWxlPSJ3aWR0aDogMTAwLjAlOyBoZWlnaHQ6IDEwMC4wJTsiPk5hbWU6IFNBSU5UIFZSQUlOIFNVUFBMWSBDQU5BTCBORUFSIExZT05TLCBDTyBQcmVjaXA6IDI3My4wMDwvZGl2PmApWzBdOwogICAgICAgICAgICBwb3B1cF9kMmFhOGQyNWRhMzE0Y2EyYWFlNWVlYmJjYWRhNTQyNi5zZXRDb250ZW50KGh0bWxfYTMwMTlhYmRiOThjNDZkMjliZTY0ZTk4YTQ3Y2Q2NTkpOwogICAgICAgIAoKICAgICAgICBtYXJrZXJfNWY0NDMyOTZhMTY1NGU3YTk2NWY4ZGUxN2QwMGEwOGQuYmluZFBvcHVwKHBvcHVwX2QyYWE4ZDI1ZGEzMTRjYTJhYWU1ZWViYmNhZGE1NDI2KQogICAgICAgIDsKCiAgICAgICAgCiAgICAKICAgIAogICAgICAgICAgICB2YXIgbWFya2VyXzNlNWQ0OGRhNjY5ZjRiODZhYTk3MWNmNGNmZmJlMTYwID0gTC5tYXJrZXIoCiAgICAgICAgICAgICAgICBbNDAuMjU2Mjc2LCAtMTA1LjIwOTQxNl0sCiAgICAgICAgICAgICAgICB7fQogICAgICAgICAgICApLmFkZFRvKG1hcmtlcl9jbHVzdGVyXzdlMjdhNjRhYWM4NjRlODBiYmVkZmJkNmQ0MWY4ODAyKTsKICAgICAgICAKICAgIAogICAgICAgIHZhciBwb3B1cF8zMDI5MzMyYzZjMjk0MjJlODQ3MDRkMzkwMGMwYjNhMSA9IEwucG9wdXAoeyJtYXhXaWR0aCI6ICIxMDAlIn0pOwoKICAgICAgICAKICAgICAgICAgICAgdmFyIGh0bWxfZTc0Yzk3YTRkYTI2NGU3ZGJlMGE1MTBjZTEwYmI2MTAgPSAkKGA8ZGl2IGlkPSJodG1sX2U3NGM5N2E0ZGEyNjRlN2RiZTBhNTEwY2UxMGJiNjEwIiBzdHlsZT0id2lkdGg6IDEwMC4wJTsgaGVpZ2h0OiAxMDAuMCU7Ij5OYW1lOiBMSVRUTEUgVEhPTVBTT04gIzEgRElUQ0ggUHJlY2lwOiAwLjAzPC9kaXY+YClbMF07CiAgICAgICAgICAgIHBvcHVwXzMwMjkzMzJjNmMyOTQyMmU4NDcwNGQzOTAwYzBiM2ExLnNldENvbnRlbnQoaHRtbF9lNzRjOTdhNGRhMjY0ZTdkYmUwYTUxMGNlMTBiYjYxMCk7CiAgICAgICAgCgogICAgICAgIG1hcmtlcl8zZTVkNDhkYTY2OWY0Yjg2YWE5NzFjZjRjZmZiZTE2MC5iaW5kUG9wdXAocG9wdXBfMzAyOTMzMmM2YzI5NDIyZTg0NzA0ZDM5MDBjMGIzYTEpCiAgICAgICAgOwoKICAgICAgICAKICAgIAogICAgCiAgICAgICAgICAgIHZhciBtYXJrZXJfYjQxNDhkYjNiNzNmNGVmYjhlMjUwMzM2M2RmMzRhMzcgPSBMLm1hcmtlcigKICAgICAgICAgICAgICAgIFs0MC4wNTE2NTIsIC0xMDUuMTc4ODc1XSwKICAgICAgICAgICAgICAgIHt9CiAgICAgICAgICAgICkuYWRkVG8obWFya2VyX2NsdXN0ZXJfN2UyN2E2NGFhYzg2NGU4MGJiZWRmYmQ2ZDQxZjg4MDIpOwogICAgICAgIAogICAgCiAgICAgICAgdmFyIHBvcHVwXzNiZmUxZDgwNzcwYjQ3YzU5N2Y3ODA2YWEzZDNiYzdmID0gTC5wb3B1cCh7Im1heFdpZHRoIjogIjEwMCUifSk7CgogICAgICAgIAogICAgICAgICAgICB2YXIgaHRtbF85ZjQxMTY1MTZlYTQ0MjFiYjQ3MGQ3NGU2MDQzZWYzNiA9ICQoYDxkaXYgaWQ9Imh0bWxfOWY0MTE2NTE2ZWE0NDIxYmI0NzBkNzRlNjA0M2VmMzYiIHN0eWxlPSJ3aWR0aDogMTAwLjAlOyBoZWlnaHQ6IDEwMC4wJTsiPk5hbWU6IEJPVUxERVIgQ1JFRUsgQVQgTk9SVEggNzVUSCBTVC4gTkVBUiBCT1VMREVSLCBDTyBQcmVjaXA6IDEzOC4wMDwvZGl2PmApWzBdOwogICAgICAgICAgICBwb3B1cF8zYmZlMWQ4MDc3MGI0N2M1OTdmNzgwNmFhM2QzYmM3Zi5zZXRDb250ZW50KGh0bWxfOWY0MTE2NTE2ZWE0NDIxYmI0NzBkNzRlNjA0M2VmMzYpOwogICAgICAgIAoKICAgICAgICBtYXJrZXJfYjQxNDhkYjNiNzNmNGVmYjhlMjUwMzM2M2RmMzRhMzcuYmluZFBvcHVwKHBvcHVwXzNiZmUxZDgwNzcwYjQ3YzU5N2Y3ODA2YWEzZDNiYzdmKQogICAgICAgIDsKCiAgICAgICAgCiAgICAKICAgIAogICAgICAgICAgICB2YXIgbWFya2VyXzExY2QzMjI4OGVjMzRiZDg4ZThiNGI3MmU0OTNlOTJlID0gTC5tYXJrZXIoCiAgICAgICAgICAgICAgICBbNDAuMjE1NjU4LCAtMTA1LjM2MzQyMl0sCiAgICAgICAgICAgICAgICB7fQogICAgICAgICAgICApLmFkZFRvKG1hcmtlcl9jbHVzdGVyXzdlMjdhNjRhYWM4NjRlODBiYmVkZmJkNmQ0MWY4ODAyKTsKICAgICAgICAKICAgIAogICAgICAgIHZhciBwb3B1cF9iYmE0NDgwZDNiNTQ0OWMzYTNjMTI1NjA5MjRmOTE0YiA9IEwucG9wdXAoeyJtYXhXaWR0aCI6ICIxMDAlIn0pOwoKICAgICAgICAKICAgICAgICAgICAgdmFyIGh0bWxfOTM0N2RhMGU0MzdiNDM5NGI0ZWJkMGYwYjY2ZGI2NzMgPSAkKGA8ZGl2IGlkPSJodG1sXzkzNDdkYTBlNDM3YjQzOTRiNGViZDBmMGI2NmRiNjczIiBzdHlsZT0id2lkdGg6IDEwMC4wJTsgaGVpZ2h0OiAxMDAuMCU7Ij5OYW1lOiBOT1JUSCBTQUlOVCBWUkFJTiBDUkVFSyBCRUxPVyBCVVRUT05ST0NLICAoUkFMUEggUFJJQ0UpIFJFU0VSVk9JUiBQcmVjaXA6IDMwLjcwPC9kaXY+YClbMF07CiAgICAgICAgICAgIHBvcHVwX2JiYTQ0ODBkM2I1NDQ5YzNhM2MxMjU2MDkyNGY5MTRiLnNldENvbnRlbnQoaHRtbF85MzQ3ZGEwZTQzN2I0Mzk0YjRlYmQwZjBiNjZkYjY3Myk7CiAgICAgICAgCgogICAgICAgIG1hcmtlcl8xMWNkMzIyODhlYzM0YmQ4OGU4YjRiNzJlNDkzZTkyZS5iaW5kUG9wdXAocG9wdXBfYmJhNDQ4MGQzYjU0NDljM2EzYzEyNTYwOTI0ZjkxNGIpCiAgICAgICAgOwoKICAgICAgICAKICAgIAogICAgCiAgICAgICAgICAgIHZhciBtYXJrZXJfZTFiYzFmNzJmZDMyNGU4ODhmZWVkOGE4ZTBlNmRlYjIgPSBMLm1hcmtlcigKICAgICAgICAgICAgICAgIFs0MC4yMTI2NTgsIC0xMDUuMjUxODI2XSwKICAgICAgICAgICAgICAgIHt9CiAgICAgICAgICAgICkuYWRkVG8obWFya2VyX2NsdXN0ZXJfN2UyN2E2NGFhYzg2NGU4MGJiZWRmYmQ2ZDQxZjg4MDIpOwogICAgICAgIAogICAgCiAgICAgICAgdmFyIHBvcHVwXzM3M2I1OGQ0NmM4ODRmMzhhYWNlNGI2MjEwZmVhMDViID0gTC5wb3B1cCh7Im1heFdpZHRoIjogIjEwMCUifSk7CgogICAgICAgIAogICAgICAgICAgICB2YXIgaHRtbF81OWYwODE4NjQyNTI0MzVmYTZjMmJjMTU0ZTRhMTQ5ZSA9ICQoYDxkaXYgaWQ9Imh0bWxfNTlmMDgxODY0MjUyNDM1ZmE2YzJiYzE1NGU0YTE0OWUiIHN0eWxlPSJ3aWR0aDogMTAwLjAlOyBoZWlnaHQ6IDEwMC4wJTsiPk5hbWU6IFJPVUdIIEFORCBSRUFEWSBESVRDSCBQcmVjaXA6IDEwLjg0PC9kaXY+YClbMF07CiAgICAgICAgICAgIHBvcHVwXzM3M2I1OGQ0NmM4ODRmMzhhYWNlNGI2MjEwZmVhMDViLnNldENvbnRlbnQoaHRtbF81OWYwODE4NjQyNTI0MzVmYTZjMmJjMTU0ZTRhMTQ5ZSk7CiAgICAgICAgCgogICAgICAgIG1hcmtlcl9lMWJjMWY3MmZkMzI0ZTg4OGZlZWQ4YThlMGU2ZGViMi5iaW5kUG9wdXAocG9wdXBfMzczYjU4ZDQ2Yzg4NGYzOGFhY2U0YjYyMTBmZWEwNWIpCiAgICAgICAgOwoKICAgICAgICAKICAgIAogICAgCiAgICAgICAgICAgIHZhciBtYXJrZXJfNjFmNzdiNGUwYjBkNDkwMTljZjRlMTU4ZTRiZmFjNjIgPSBMLm1hcmtlcigKICAgICAgICAgICAgICAgIFs0MC4xOTMyOCwgLTEwNS4yMTA0MjRdLAogICAgICAgICAgICAgICAge30KICAgICAgICAgICAgKS5hZGRUbyhtYXJrZXJfY2x1c3Rlcl83ZTI3YTY0YWFjODY0ZTgwYmJlZGZiZDZkNDFmODgwMik7CiAgICAgICAgCiAgICAKICAgICAgICB2YXIgcG9wdXBfOTFkNzhlZTlmNTllNGRiNWE0ZDA2ZDMzMDA5YmQxNTMgPSBMLnBvcHVwKHsibWF4V2lkdGgiOiAiMTAwJSJ9KTsKCiAgICAgICAgCiAgICAgICAgICAgIHZhciBodG1sX2JlYmRhZTQ3ODMyNTQyNzdhOGY0NGQ4NzQ2ZDk5ZTAxID0gJChgPGRpdiBpZD0iaHRtbF9iZWJkYWU0NzgzMjU0Mjc3YThmNDRkODc0NmQ5OWUwMSIgc3R5bGU9IndpZHRoOiAxMDAuMCU7IGhlaWdodDogMTAwLjAlOyI+TmFtZTogV0VCU1RFUiBNQ0NBU0xJTiBESVRDSCBQcmVjaXA6IDAuMjY8L2Rpdj5gKVswXTsKICAgICAgICAgICAgcG9wdXBfOTFkNzhlZTlmNTllNGRiNWE0ZDA2ZDMzMDA5YmQxNTMuc2V0Q29udGVudChodG1sX2JlYmRhZTQ3ODMyNTQyNzdhOGY0NGQ4NzQ2ZDk5ZTAxKTsKICAgICAgICAKCiAgICAgICAgbWFya2VyXzYxZjc3YjRlMGIwZDQ5MDE5Y2Y0ZTE1OGU0YmZhYzYyLmJpbmRQb3B1cChwb3B1cF85MWQ3OGVlOWY1OWU0ZGI1YTRkMDZkMzMwMDliZDE1MykKICAgICAgICA7CgogICAgICAgIAogICAgCiAgICAKICAgICAgICAgICAgdmFyIG1hcmtlcl8xMDNiNDU5OTQzMGU0Nzc0OWJkYjc3Yjg5M2JkZTM1YiA9IEwubWFya2VyKAogICAgICAgICAgICAgICAgWzQwLjIxNTkwNCwgLTEwNS4yNTc3MzZdLAogICAgICAgICAgICAgICAge30KICAgICAgICAgICAgKS5hZGRUbyhtYXJrZXJfY2x1c3Rlcl83ZTI3YTY0YWFjODY0ZTgwYmJlZGZiZDZkNDFmODgwMik7CiAgICAgICAgCiAgICAKICAgICAgICB2YXIgcG9wdXBfMTgzYWJhZjQ4YmFlNDc0MjgzMTFlMTY4NWEwYTRhYTcgPSBMLnBvcHVwKHsibWF4V2lkdGgiOiAiMTAwJSJ9KTsKCiAgICAgICAgCiAgICAgICAgICAgIHZhciBodG1sXzNkZmE3OGZiMGI5NDQxNTI5YjkxZmNhNWI1MGI3NmZiID0gJChgPGRpdiBpZD0iaHRtbF8zZGZhNzhmYjBiOTQ0MTUyOWI5MWZjYTViNTBiNzZmYiIgc3R5bGU9IndpZHRoOiAxMDAuMCU7IGhlaWdodDogMTAwLjAlOyI+TmFtZTogQk9VTERFUiBDUkVFSyBGRUVERVIgQ0FOQUwgTkVBUiBMWU9OUyBQcmVjaXA6IDEwMy4wMDwvZGl2PmApWzBdOwogICAgICAgICAgICBwb3B1cF8xODNhYmFmNDhiYWU0NzQyODMxMWUxNjg1YTBhNGFhNy5zZXRDb250ZW50KGh0bWxfM2RmYTc4ZmIwYjk0NDE1MjliOTFmY2E1YjUwYjc2ZmIpOwogICAgICAgIAoKICAgICAgICBtYXJrZXJfMTAzYjQ1OTk0MzBlNDc3NDliZGI3N2I4OTNiZGUzNWIuYmluZFBvcHVwKHBvcHVwXzE4M2FiYWY0OGJhZTQ3NDI4MzExZTE2ODVhMGE0YWE3KQogICAgICAgIDsKCiAgICAgICAgCiAgICAKICAgIAogICAgICAgICAgICB2YXIgbWFya2VyXzNiNmExNTI1NjE3YjRmMzRhNzJmNDM3NDczZTlmYTljID0gTC5tYXJrZXIoCiAgICAgICAgICAgICAgICBbNDAuMTc0ODQ0LCAtMTA1LjE2Nzg3M10sCiAgICAgICAgICAgICAgICB7fQogICAgICAgICAgICApLmFkZFRvKG1hcmtlcl9jbHVzdGVyXzdlMjdhNjRhYWM4NjRlODBiYmVkZmJkNmQ0MWY4ODAyKTsKICAgICAgICAKICAgIAogICAgICAgIHZhciBwb3B1cF84NWM2MWIzNTI5MzM0ODEyYjc4MzE5ZDFjOGExZmMyZiA9IEwucG9wdXAoeyJtYXhXaWR0aCI6ICIxMDAlIn0pOwoKICAgICAgICAKICAgICAgICAgICAgdmFyIGh0bWxfNjE3Zjg2ZjRlOWE4NDRkMDg5ODA1OThjNTcxZTA5ODQgPSAkKGA8ZGl2IGlkPSJodG1sXzYxN2Y4NmY0ZTlhODQ0ZDA4OTgwNTk4YzU3MWUwOTg0IiBzdHlsZT0id2lkdGg6IDEwMC4wJTsgaGVpZ2h0OiAxMDAuMCU7Ij5OYW1lOiBIQUdFUiBNRUFET1dTIERJVENIIFByZWNpcDogMi4wMzwvZGl2PmApWzBdOwogICAgICAgICAgICBwb3B1cF84NWM2MWIzNTI5MzM0ODEyYjc4MzE5ZDFjOGExZmMyZi5zZXRDb250ZW50KGh0bWxfNjE3Zjg2ZjRlOWE4NDRkMDg5ODA1OThjNTcxZTA5ODQpOwogICAgICAgIAoKICAgICAgICBtYXJrZXJfM2I2YTE1MjU2MTdiNGYzNGE3MmY0Mzc0NzNlOWZhOWMuYmluZFBvcHVwKHBvcHVwXzg1YzYxYjM1MjkzMzQ4MTJiNzgzMTlkMWM4YTFmYzJmKQogICAgICAgIDsKCiAgICAgICAgCiAgICAKICAgIAogICAgICAgICAgICB2YXIgbWFya2VyXzQyYWQ0MjcxZjU1MDQ4YzI4YWNkNTZhODZjNDJmZjI4ID0gTC5tYXJrZXIoCiAgICAgICAgICAgICAgICBbNDAuMDUzNjYxLCAtMTA1LjE1MTE0M10sCiAgICAgICAgICAgICAgICB7fQogICAgICAgICAgICApLmFkZFRvKG1hcmtlcl9jbHVzdGVyXzdlMjdhNjRhYWM4NjRlODBiYmVkZmJkNmQ0MWY4ODAyKTsKICAgICAgICAKICAgIAogICAgICAgIHZhciBwb3B1cF82YmJjOGNjZGNjMDE0ZmYwYTRjMGI3OTg5NmVmMmRkMyA9IEwucG9wdXAoeyJtYXhXaWR0aCI6ICIxMDAlIn0pOwoKICAgICAgICAKICAgICAgICAgICAgdmFyIGh0bWxfNGI0OTZkNDA3NzBkNDQ2YWExYjU1ZDYyZTI3MjAxMDUgPSAkKGA8ZGl2IGlkPSJodG1sXzRiNDk2ZDQwNzcwZDQ0NmFhMWI1NWQ2MmUyNzIwMTA1IiBzdHlsZT0id2lkdGg6IDEwMC4wJTsgaGVpZ2h0OiAxMDAuMCU7Ij5OYW1lOiBMRUdHRVRUIERJVENIIFByZWNpcDogMjMuMjk8L2Rpdj5gKVswXTsKICAgICAgICAgICAgcG9wdXBfNmJiYzhjY2RjYzAxNGZmMGE0YzBiNzk4OTZlZjJkZDMuc2V0Q29udGVudChodG1sXzRiNDk2ZDQwNzcwZDQ0NmFhMWI1NWQ2MmUyNzIwMTA1KTsKICAgICAgICAKCiAgICAgICAgbWFya2VyXzQyYWQ0MjcxZjU1MDQ4YzI4YWNkNTZhODZjNDJmZjI4LmJpbmRQb3B1cChwb3B1cF82YmJjOGNjZGNjMDE0ZmYwYTRjMGI3OTg5NmVmMmRkMykKICAgICAgICA7CgogICAgICAgIAogICAgCiAgICAKICAgICAgICAgICAgdmFyIG1hcmtlcl85N2ZmMzU0OWJkNDc0YjZmOWExN2FkY2U4ZWEzZmM2YyA9IEwubWFya2VyKAogICAgICAgICAgICAgICAgWzQwLjE4NzUyNCwgLTEwNS4xODkxMzJdLAogICAgICAgICAgICAgICAge30KICAgICAgICAgICAgKS5hZGRUbyhtYXJrZXJfY2x1c3Rlcl83ZTI3YTY0YWFjODY0ZTgwYmJlZGZiZDZkNDFmODgwMik7CiAgICAgICAgCiAgICAKICAgICAgICB2YXIgcG9wdXBfOTY4YjY3NDVjZGY4NGZlZDljZTg5N2E3MGQzZDI0MWMgPSBMLnBvcHVwKHsibWF4V2lkdGgiOiAiMTAwJSJ9KTsKCiAgICAgICAgCiAgICAgICAgICAgIHZhciBodG1sXzA0YTc2Y2Y4Y2YwNzQ1MGViNjY3NDQ4ZjczNzFlM2U5ID0gJChgPGRpdiBpZD0iaHRtbF8wNGE3NmNmOGNmMDc0NTBlYjY2NzQ0OGY3MzcxZTNlOSIgc3R5bGU9IndpZHRoOiAxMDAuMCU7IGhlaWdodDogMTAwLjAlOyI+TmFtZTogUlVOWU9OIERJVENIIFByZWNpcDogMC4wMDwvZGl2PmApWzBdOwogICAgICAgICAgICBwb3B1cF85NjhiNjc0NWNkZjg0ZmVkOWNlODk3YTcwZDNkMjQxYy5zZXRDb250ZW50KGh0bWxfMDRhNzZjZjhjZjA3NDUwZWI2Njc0NDhmNzM3MWUzZTkpOwogICAgICAgIAoKICAgICAgICBtYXJrZXJfOTdmZjM1NDliZDQ3NGI2ZjlhMTdhZGNlOGVhM2ZjNmMuYmluZFBvcHVwKHBvcHVwXzk2OGI2NzQ1Y2RmODRmZWQ5Y2U4OTdhNzBkM2QyNDFjKQogICAgICAgIDsKCiAgICAgICAgCiAgICAKICAgIAogICAgICAgICAgICB2YXIgbWFya2VyX2FkOTM1OTYwNWNjZTQ4OTdhMTM2ZmUyMDlhMzc1ZGQzID0gTC5tYXJrZXIoCiAgICAgICAgICAgICAgICBbMzkuOTMxNjU5LCAtMTA1LjQyMjk4NV0sCiAgICAgICAgICAgICAgICB7fQogICAgICAgICAgICApLmFkZFRvKG1hcmtlcl9jbHVzdGVyXzdlMjdhNjRhYWM4NjRlODBiYmVkZmJkNmQ0MWY4ODAyKTsKICAgICAgICAKICAgIAogICAgICAgIHZhciBwb3B1cF81ZWRhOTY2MGZjYmY0MGZiYjMwNWExZGVhMDE1YWQxYSA9IEwucG9wdXAoeyJtYXhXaWR0aCI6ICIxMDAlIn0pOwoKICAgICAgICAKICAgICAgICAgICAgdmFyIGh0bWxfNjg1YjgxMzFlZDg2NGNhNDk0ZjYxYmYyYjk1ZDIyMmMgPSAkKGA8ZGl2IGlkPSJodG1sXzY4NWI4MTMxZWQ4NjRjYTQ5NGY2MWJmMmI5NWQyMjJjIiBzdHlsZT0id2lkdGg6IDEwMC4wJTsgaGVpZ2h0OiAxMDAuMCU7Ij5OYW1lOiBTT1VUSCBCT1VMREVSIENSRUVLIEFCT1ZFIEdST1NTIFJFU0VSVk9JUiBBVCBQSU5FQ0xJRkZFIFByZWNpcDogNzcuMjA8L2Rpdj5gKVswXTsKICAgICAgICAgICAgcG9wdXBfNWVkYTk2NjBmY2JmNDBmYmIzMDVhMWRlYTAxNWFkMWEuc2V0Q29udGVudChodG1sXzY4NWI4MTMxZWQ4NjRjYTQ5NGY2MWJmMmI5NWQyMjJjKTsKICAgICAgICAKCiAgICAgICAgbWFya2VyX2FkOTM1OTYwNWNjZTQ4OTdhMTM2ZmUyMDlhMzc1ZGQzLmJpbmRQb3B1cChwb3B1cF81ZWRhOTY2MGZjYmY0MGZiYjMwNWExZGVhMDE1YWQxYSkKICAgICAgICA7CgogICAgICAgIAogICAgCjwvc2NyaXB0Pg==" style="position:absolute;width:100%;height:100%;left:0;top:0;border:none !important;" allowfullscreen webkitallowfullscreen mozallowfullscreen></iframe></div></div>





<div class="notice--info" markdown="1">

## Additional Resources

* <a href="https://blog.datafiniti.co/4-reasons-you-should-use-json-instead-of-csv-2cac362f1943" target="_blank">Why you should use JSON instead of csv.</a>


* <a href="https://www.w3schools.com/js/js_json_intro.asp" target="_blank">W3schools JSON intro </a>

</div>

