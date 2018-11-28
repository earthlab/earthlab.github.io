---
layout: single
title: 'Programmatically Accessing Geospatial Data Using APIs'
excerpt: 'This lesson walks through the process of retrieving and manipulating surface water data housed in the Colorado Information Warehouse. These data are stored in JSON format with spatial x, y information that support mapping.'
authors: ['Carson Farmer', 'Leah Wasser', 'Max Joseph', 'Martha Morrissey', 'Jenny Palomino']
modified: 2018-11-28
category: [courses]
class-lesson: ['intro-APIs-python']
permalink: /courses/earth-analytics-python/get-data-using-apis/co-water-data-spatial-python/
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



    [{'station_name': 'BLOWER DITCH',
      'amount': '0.00',
      'station_status': 'Active',
      'county': 'BOULDER',
      'wd': '4',
      'dwr_abbrev': 'BLWDITCO',
      'data_source': 'Cooperative SDR Program of CDWR & NCWCD',
      'http_linkage': {'url': 'http://www.dwr.state.co.us/SurfaceWater/data/detail_graph.aspx?ID=BLWDITCO&MTYPE=DISCHRG'},
      'div': '1',
      'date_time': '2018-11-28T07:00:00',
      'usgs_station_id': 'BLWDITCO',
      'variable': 'DISCHRG',
      'location': {'latitude': '40.257844',
       'needs_recoding': False,
       'longitude': '-105.164397'},
      'station_type': 'Diversion'},
     {'station_name': 'BOULDER-LARIMER BYPASS NEAR BERTHOUD',
      'amount': '0.80',
      'station_status': 'Active',
      'county': 'BOULDER',
      'wd': '4',
      'dwr_abbrev': 'BOUBYPCO',
      'data_source': 'Co. Division of Water Resources',
      'http_linkage': {'url': 'http://www.dwr.state.co.us/SurfaceWater/data/detail_graph.aspx?ID=BOUBYPCO&MTYPE=DISCHRG'},
      'div': '1',
      'date_time': '2018-11-28T07:15:00',
      'stage': '0.15',
      'variable': 'DISCHRG',
      'location': {'latitude': '40.258726',
       'needs_recoding': False,
       'longitude': '-105.175817'},
      'station_type': 'Diversion'}]





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
      <th>amount</th>
      <th>county</th>
      <th>data_source</th>
      <th>date_time</th>
      <th>div</th>
      <th>dwr_abbrev</th>
      <th>http_linkage.url</th>
      <th>location.latitude</th>
      <th>location.longitude</th>
      <th>location.needs_recoding</th>
      <th>stage</th>
      <th>station_name</th>
      <th>station_status</th>
      <th>station_type</th>
      <th>usgs_station_id</th>
      <th>variable</th>
      <th>wd</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>0.00</td>
      <td>BOULDER</td>
      <td>Cooperative SDR Program of CDWR &amp; NCWCD</td>
      <td>2018-11-28T07:00:00</td>
      <td>1</td>
      <td>BLWDITCO</td>
      <td>http://www.dwr.state.co.us/SurfaceWater/data/d...</td>
      <td>40.257844</td>
      <td>-105.164397</td>
      <td>False</td>
      <td>NaN</td>
      <td>BLOWER DITCH</td>
      <td>Active</td>
      <td>Diversion</td>
      <td>BLWDITCO</td>
      <td>DISCHRG</td>
      <td>4</td>
    </tr>
    <tr>
      <th>1</th>
      <td>0.80</td>
      <td>BOULDER</td>
      <td>Co. Division of Water Resources</td>
      <td>2018-11-28T07:15:00</td>
      <td>1</td>
      <td>BOUBYPCO</td>
      <td>http://www.dwr.state.co.us/SurfaceWater/data/d...</td>
      <td>40.258726</td>
      <td>-105.175817</td>
      <td>False</td>
      <td>0.15</td>
      <td>BOULDER-LARIMER BYPASS NEAR BERTHOUD</td>
      <td>Active</td>
      <td>Diversion</td>
      <td>NaN</td>
      <td>DISCHRG</td>
      <td>4</td>
    </tr>
    <tr>
      <th>2</th>
      <td>0.00</td>
      <td>BOULDER</td>
      <td>Co. Division of Water Resources</td>
      <td>2018-11-28T07:30:00</td>
      <td>1</td>
      <td>BOULARCO</td>
      <td>http://www.dwr.state.co.us/SurfaceWater/data/d...</td>
      <td>40.258367</td>
      <td>-105.174957</td>
      <td>False</td>
      <td>-0.09</td>
      <td>BOULDER-LARIMER DITCH NEAR BERTHOUD</td>
      <td>Active</td>
      <td>Diversion</td>
      <td>NaN</td>
      <td>DISCHRG</td>
      <td>4</td>
    </tr>
    <tr>
      <th>3</th>
      <td>0.00</td>
      <td>BOULDER</td>
      <td>Cooperative SDR Program of CDWR &amp; NCWCD</td>
      <td>2018-11-28T07:00:00</td>
      <td>1</td>
      <td>CULDITCO</td>
      <td>http://www.dwr.state.co.us/SurfaceWater/data/d...</td>
      <td>40.260827</td>
      <td>-105.198567</td>
      <td>False</td>
      <td>NaN</td>
      <td>CULVER DITCH</td>
      <td>Active</td>
      <td>Diversion</td>
      <td>CULDITCO</td>
      <td>DISCHRG</td>
      <td>4</td>
    </tr>
    <tr>
      <th>4</th>
      <td>15.50</td>
      <td>BOULDER</td>
      <td>Northern Colorado Water Conservancy District (...</td>
      <td>2018-11-28T07:00:00</td>
      <td>1</td>
      <td>LITTH1CO</td>
      <td>http://www.northernwater.org/WaterProjects/Eas...</td>
      <td>40.256276</td>
      <td>-105.209416</td>
      <td>False</td>
      <td>0.98</td>
      <td>LITTLE THOMPSON #1 DITCH</td>
      <td>Active</td>
      <td>Diversion</td>
      <td>ES1901</td>
      <td>DISCHRG</td>
      <td>4</td>
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



    Index(['amount', 'county', 'data_source', 'date_time', 'div', 'dwr_abbrev',
           'http_linkage.url', 'location.latitude', 'location.longitude',
           'location.needs_recoding', 'stage', 'station_name', 'station_status',
           'station_type', 'usgs_station_id', 'variable', 'wd'],
          dtype='object')





## Data Cleaning for Visualization

Now you can clean up the data. Notice that your longitude and latitude values are stored as strings. Do you think can create a map if these values are stored as strings?

{:.input}
```python
result['location.latitude'][0]
```

{:.output}
{:.execute_result}



    '40.257844'





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



    40.257844





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



    -105.164397





Now that you have numeric values for mapping, make sure that are are no missing values. 

{:.input}
```python
result.shape
```

{:.output}
{:.execute_result}



    (50, 17)





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
      <th>amount</th>
      <th>county</th>
      <th>data_source</th>
      <th>date_time</th>
      <th>div</th>
      <th>dwr_abbrev</th>
      <th>http_linkage.url</th>
      <th>location.latitude</th>
      <th>location.longitude</th>
      <th>location.needs_recoding</th>
      <th>stage</th>
      <th>station_name</th>
      <th>station_status</th>
      <th>station_type</th>
      <th>usgs_station_id</th>
      <th>variable</th>
      <th>wd</th>
      <th>geometry</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>0.00</td>
      <td>BOULDER</td>
      <td>Cooperative SDR Program of CDWR &amp; NCWCD</td>
      <td>2018-11-28T07:00:00</td>
      <td>1</td>
      <td>BLWDITCO</td>
      <td>http://www.dwr.state.co.us/SurfaceWater/data/d...</td>
      <td>40.257844</td>
      <td>-105.164397</td>
      <td>False</td>
      <td>NaN</td>
      <td>BLOWER DITCH</td>
      <td>Active</td>
      <td>Diversion</td>
      <td>BLWDITCO</td>
      <td>DISCHRG</td>
      <td>4</td>
      <td>POINT (-105.164397 40.257844)</td>
    </tr>
    <tr>
      <th>1</th>
      <td>0.80</td>
      <td>BOULDER</td>
      <td>Co. Division of Water Resources</td>
      <td>2018-11-28T07:15:00</td>
      <td>1</td>
      <td>BOUBYPCO</td>
      <td>http://www.dwr.state.co.us/SurfaceWater/data/d...</td>
      <td>40.258726</td>
      <td>-105.175817</td>
      <td>False</td>
      <td>0.15</td>
      <td>BOULDER-LARIMER BYPASS NEAR BERTHOUD</td>
      <td>Active</td>
      <td>Diversion</td>
      <td>NaN</td>
      <td>DISCHRG</td>
      <td>4</td>
      <td>POINT (-105.175817 40.258726)</td>
    </tr>
    <tr>
      <th>2</th>
      <td>0.00</td>
      <td>BOULDER</td>
      <td>Co. Division of Water Resources</td>
      <td>2018-11-28T07:30:00</td>
      <td>1</td>
      <td>BOULARCO</td>
      <td>http://www.dwr.state.co.us/SurfaceWater/data/d...</td>
      <td>40.258367</td>
      <td>-105.174957</td>
      <td>False</td>
      <td>-0.09</td>
      <td>BOULDER-LARIMER DITCH NEAR BERTHOUD</td>
      <td>Active</td>
      <td>Diversion</td>
      <td>NaN</td>
      <td>DISCHRG</td>
      <td>4</td>
      <td>POINT (-105.174957 40.258367)</td>
    </tr>
    <tr>
      <th>3</th>
      <td>0.00</td>
      <td>BOULDER</td>
      <td>Cooperative SDR Program of CDWR &amp; NCWCD</td>
      <td>2018-11-28T07:00:00</td>
      <td>1</td>
      <td>CULDITCO</td>
      <td>http://www.dwr.state.co.us/SurfaceWater/data/d...</td>
      <td>40.260827</td>
      <td>-105.198567</td>
      <td>False</td>
      <td>NaN</td>
      <td>CULVER DITCH</td>
      <td>Active</td>
      <td>Diversion</td>
      <td>CULDITCO</td>
      <td>DISCHRG</td>
      <td>4</td>
      <td>POINT (-105.198567 40.260827)</td>
    </tr>
    <tr>
      <th>4</th>
      <td>15.50</td>
      <td>BOULDER</td>
      <td>Northern Colorado Water Conservancy District (...</td>
      <td>2018-11-28T07:00:00</td>
      <td>1</td>
      <td>LITTH1CO</td>
      <td>http://www.northernwater.org/WaterProjects/Eas...</td>
      <td>40.256276</td>
      <td>-105.209416</td>
      <td>False</td>
      <td>0.98</td>
      <td>LITTLE THOMPSON #1 DITCH</td>
      <td>Active</td>
      <td>Diversion</td>
      <td>ES1901</td>
      <td>DISCHRG</td>
      <td>4</td>
      <td>POINT (-105.209416 40.256276)</td>
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



<div style="width:100%;"><div style="position:relative;width:100%;height:0;padding-bottom:60%;"><iframe src="data:text/html;charset=utf-8;base64,PCFET0NUWVBFIGh0bWw+CjxoZWFkPiAgICAKICAgIDxtZXRhIGh0dHAtZXF1aXY9ImNvbnRlbnQtdHlwZSIgY29udGVudD0idGV4dC9odG1sOyBjaGFyc2V0PVVURi04IiAvPgogICAgPHNjcmlwdD5MX1BSRUZFUl9DQU5WQVM9ZmFsc2U7IExfTk9fVE9VQ0g9ZmFsc2U7IExfRElTQUJMRV8zRD1mYWxzZTs8L3NjcmlwdD4KICAgIDxzY3JpcHQgc3JjPSJodHRwczovL2Nkbi5qc2RlbGl2ci5uZXQvbnBtL2xlYWZsZXRAMS4yLjAvZGlzdC9sZWFmbGV0LmpzIj48L3NjcmlwdD4KICAgIDxzY3JpcHQgc3JjPSJodHRwczovL2FqYXguZ29vZ2xlYXBpcy5jb20vYWpheC9saWJzL2pxdWVyeS8xLjExLjEvanF1ZXJ5Lm1pbi5qcyI+PC9zY3JpcHQ+CiAgICA8c2NyaXB0IHNyYz0iaHR0cHM6Ly9tYXhjZG4uYm9vdHN0cmFwY2RuLmNvbS9ib290c3RyYXAvMy4yLjAvanMvYm9vdHN0cmFwLm1pbi5qcyI+PC9zY3JpcHQ+CiAgICA8c2NyaXB0IHNyYz0iaHR0cHM6Ly9jZG5qcy5jbG91ZGZsYXJlLmNvbS9hamF4L2xpYnMvTGVhZmxldC5hd2Vzb21lLW1hcmtlcnMvMi4wLjIvbGVhZmxldC5hd2Vzb21lLW1hcmtlcnMuanMiPjwvc2NyaXB0PgogICAgPGxpbmsgcmVsPSJzdHlsZXNoZWV0IiBocmVmPSJodHRwczovL2Nkbi5qc2RlbGl2ci5uZXQvbnBtL2xlYWZsZXRAMS4yLjAvZGlzdC9sZWFmbGV0LmNzcyIvPgogICAgPGxpbmsgcmVsPSJzdHlsZXNoZWV0IiBocmVmPSJodHRwczovL21heGNkbi5ib290c3RyYXBjZG4uY29tL2Jvb3RzdHJhcC8zLjIuMC9jc3MvYm9vdHN0cmFwLm1pbi5jc3MiLz4KICAgIDxsaW5rIHJlbD0ic3R5bGVzaGVldCIgaHJlZj0iaHR0cHM6Ly9tYXhjZG4uYm9vdHN0cmFwY2RuLmNvbS9ib290c3RyYXAvMy4yLjAvY3NzL2Jvb3RzdHJhcC10aGVtZS5taW4uY3NzIi8+CiAgICA8bGluayByZWw9InN0eWxlc2hlZXQiIGhyZWY9Imh0dHBzOi8vbWF4Y2RuLmJvb3RzdHJhcGNkbi5jb20vZm9udC1hd2Vzb21lLzQuNi4zL2Nzcy9mb250LWF3ZXNvbWUubWluLmNzcyIvPgogICAgPGxpbmsgcmVsPSJzdHlsZXNoZWV0IiBocmVmPSJodHRwczovL2NkbmpzLmNsb3VkZmxhcmUuY29tL2FqYXgvbGlicy9MZWFmbGV0LmF3ZXNvbWUtbWFya2Vycy8yLjAuMi9sZWFmbGV0LmF3ZXNvbWUtbWFya2Vycy5jc3MiLz4KICAgIDxsaW5rIHJlbD0ic3R5bGVzaGVldCIgaHJlZj0iaHR0cHM6Ly9yYXdnaXQuY29tL3B5dGhvbi12aXN1YWxpemF0aW9uL2ZvbGl1bS9tYXN0ZXIvZm9saXVtL3RlbXBsYXRlcy9sZWFmbGV0LmF3ZXNvbWUucm90YXRlLmNzcyIvPgogICAgPHN0eWxlPmh0bWwsIGJvZHkge3dpZHRoOiAxMDAlO2hlaWdodDogMTAwJTttYXJnaW46IDA7cGFkZGluZzogMDt9PC9zdHlsZT4KICAgIDxzdHlsZT4jbWFwIHtwb3NpdGlvbjphYnNvbHV0ZTt0b3A6MDtib3R0b206MDtyaWdodDowO2xlZnQ6MDt9PC9zdHlsZT4KICAgIAogICAgPHN0eWxlPiNtYXBfNTg4MmEzNzc3ODRhNDRiNjg2MGJkYWUwMTMxYzhkYWYgewogICAgICAgIHBvc2l0aW9uOiByZWxhdGl2ZTsKICAgICAgICB3aWR0aDogMTAwLjAlOwogICAgICAgIGhlaWdodDogMTAwLjAlOwogICAgICAgIGxlZnQ6IDAuMCU7CiAgICAgICAgdG9wOiAwLjAlOwogICAgICAgIH0KICAgIDwvc3R5bGU+CjwvaGVhZD4KPGJvZHk+ICAgIAogICAgCiAgICA8ZGl2IGNsYXNzPSJmb2xpdW0tbWFwIiBpZD0ibWFwXzU4ODJhMzc3Nzg0YTQ0YjY4NjBiZGFlMDEzMWM4ZGFmIiA+PC9kaXY+CjwvYm9keT4KPHNjcmlwdD4gICAgCiAgICAKICAgIAogICAgICAgIHZhciBib3VuZHMgPSBudWxsOwogICAgCgogICAgdmFyIG1hcF81ODgyYTM3Nzc4NGE0NGI2ODYwYmRhZTAxMzFjOGRhZiA9IEwubWFwKAogICAgICAgICdtYXBfNTg4MmEzNzc3ODRhNDRiNjg2MGJkYWUwMTMxYzhkYWYnLCB7CiAgICAgICAgY2VudGVyOiBbNDAuMDEsIC0xMDUuMjddLAogICAgICAgIHpvb206IDEwLAogICAgICAgIG1heEJvdW5kczogYm91bmRzLAogICAgICAgIGxheWVyczogW10sCiAgICAgICAgd29ybGRDb3B5SnVtcDogZmFsc2UsCiAgICAgICAgY3JzOiBMLkNSUy5FUFNHMzg1NywKICAgICAgICB6b29tQ29udHJvbDogdHJ1ZSwKICAgICAgICB9KTsKCiAgICAKICAgIAogICAgdmFyIHRpbGVfbGF5ZXJfYTNlYTViNDYzY2E1NGRlYzkyNGRiODYxMjAwZGQ3Y2IgPSBMLnRpbGVMYXllcigKICAgICAgICAnaHR0cHM6Ly9jYXJ0b2RiLWJhc2VtYXBzLXtzfS5nbG9iYWwuc3NsLmZhc3RseS5uZXQvbGlnaHRfYWxsL3t6fS97eH0ve3l9LnBuZycsCiAgICAgICAgewogICAgICAgICJhdHRyaWJ1dGlvbiI6IG51bGwsCiAgICAgICAgImRldGVjdFJldGluYSI6IGZhbHNlLAogICAgICAgICJtYXhOYXRpdmVab29tIjogMTgsCiAgICAgICAgIm1heFpvb20iOiAxOCwKICAgICAgICAibWluWm9vbSI6IDAsCiAgICAgICAgIm5vV3JhcCI6IGZhbHNlLAogICAgICAgICJzdWJkb21haW5zIjogImFiYyIKfSkuYWRkVG8obWFwXzU4ODJhMzc3Nzg0YTQ0YjY4NjBiZGFlMDEzMWM4ZGFmKTsKICAgIAogICAgICAgIAogICAgICAgIHZhciBnZW9fanNvbl8yY2FmMzAxMzY0MDQ0NDhiOTU1NjFmZTRlZDQ5OTMwZSA9IEwuZ2VvSnNvbigKICAgICAgICAgICAgeyJiYm94IjogWy0xMDUuNTA0NDQsIDM5LjkzMTU5NywgLTEwNS4wNzU2OTUwMDAwMDAwMSwgNDAuMjYwODI3XSwgImZlYXR1cmVzIjogW3siYmJveCI6IFstMTA1LjE2NDM5NywgNDAuMjU3ODQ0LCAtMTA1LjE2NDM5NywgNDAuMjU3ODQ0XSwgImdlb21ldHJ5IjogeyJjb29yZGluYXRlcyI6IFstMTA1LjE2NDM5NywgNDAuMjU3ODQ0XSwgInR5cGUiOiAiUG9pbnQifSwgImlkIjogIjAiLCAicHJvcGVydGllcyI6IHsiYW1vdW50IjogIjAuMDAiLCAiY291bnR5IjogIkJPVUxERVIiLCAiZGF0YV9zb3VyY2UiOiAiQ29vcGVyYXRpdmUgU0RSIFByb2dyYW0gb2YgQ0RXUiAmIE5DV0NEIiwgImRhdGVfdGltZSI6ICIyMDE4LTExLTI4VDA3OjAwOjAwIiwgImRpdiI6ICIxIiwgImR3cl9hYmJyZXYiOiAiQkxXRElUQ08iLCAiaGlnaGxpZ2h0Ijoge30sICJodHRwX2xpbmthZ2UudXJsIjogImh0dHA6Ly93d3cuZHdyLnN0YXRlLmNvLnVzL1N1cmZhY2VXYXRlci9kYXRhL2RldGFpbF9ncmFwaC5hc3B4P0lEPUJMV0RJVENPJk1UWVBFPURJU0NIUkciLCAibG9jYXRpb24ubGF0aXR1ZGUiOiA0MC4yNTc4NDQsICJsb2NhdGlvbi5sb25naXR1ZGUiOiAtMTA1LjE2NDM5NywgImxvY2F0aW9uLm5lZWRzX3JlY29kaW5nIjogZmFsc2UsICJzdGFnZSI6IG51bGwsICJzdGF0aW9uX25hbWUiOiAiQkxPV0VSIERJVENIIiwgInN0YXRpb25fc3RhdHVzIjogIkFjdGl2ZSIsICJzdGF0aW9uX3R5cGUiOiAiRGl2ZXJzaW9uIiwgInN0eWxlIjoge30sICJ1c2dzX3N0YXRpb25faWQiOiAiQkxXRElUQ08iLCAidmFyaWFibGUiOiAiRElTQ0hSRyIsICJ3ZCI6ICI0In0sICJ0eXBlIjogIkZlYXR1cmUifSwgeyJiYm94IjogWy0xMDUuMTc1ODE3LCA0MC4yNTg3MjYsIC0xMDUuMTc1ODE3LCA0MC4yNTg3MjZdLCAiZ2VvbWV0cnkiOiB7ImNvb3JkaW5hdGVzIjogWy0xMDUuMTc1ODE3LCA0MC4yNTg3MjZdLCAidHlwZSI6ICJQb2ludCJ9LCAiaWQiOiAiMSIsICJwcm9wZXJ0aWVzIjogeyJhbW91bnQiOiAiMC44MCIsICJjb3VudHkiOiAiQk9VTERFUiIsICJkYXRhX3NvdXJjZSI6ICJDby4gRGl2aXNpb24gb2YgV2F0ZXIgUmVzb3VyY2VzIiwgImRhdGVfdGltZSI6ICIyMDE4LTExLTI4VDA3OjE1OjAwIiwgImRpdiI6ICIxIiwgImR3cl9hYmJyZXYiOiAiQk9VQllQQ08iLCAiaGlnaGxpZ2h0Ijoge30sICJodHRwX2xpbmthZ2UudXJsIjogImh0dHA6Ly93d3cuZHdyLnN0YXRlLmNvLnVzL1N1cmZhY2VXYXRlci9kYXRhL2RldGFpbF9ncmFwaC5hc3B4P0lEPUJPVUJZUENPJk1UWVBFPURJU0NIUkciLCAibG9jYXRpb24ubGF0aXR1ZGUiOiA0MC4yNTg3MjYsICJsb2NhdGlvbi5sb25naXR1ZGUiOiAtMTA1LjE3NTgxNywgImxvY2F0aW9uLm5lZWRzX3JlY29kaW5nIjogZmFsc2UsICJzdGFnZSI6ICIwLjE1IiwgInN0YXRpb25fbmFtZSI6ICJCT1VMREVSLUxBUklNRVIgQllQQVNTIE5FQVIgQkVSVEhPVUQiLCAic3RhdGlvbl9zdGF0dXMiOiAiQWN0aXZlIiwgInN0YXRpb25fdHlwZSI6ICJEaXZlcnNpb24iLCAic3R5bGUiOiB7fSwgInVzZ3Nfc3RhdGlvbl9pZCI6IG51bGwsICJ2YXJpYWJsZSI6ICJESVNDSFJHIiwgIndkIjogIjQifSwgInR5cGUiOiAiRmVhdHVyZSJ9LCB7ImJib3giOiBbLTEwNS4xNzQ5NTcsIDQwLjI1ODM2NywgLTEwNS4xNzQ5NTcsIDQwLjI1ODM2N10sICJnZW9tZXRyeSI6IHsiY29vcmRpbmF0ZXMiOiBbLTEwNS4xNzQ5NTcsIDQwLjI1ODM2N10sICJ0eXBlIjogIlBvaW50In0sICJpZCI6ICIyIiwgInByb3BlcnRpZXMiOiB7ImFtb3VudCI6ICIwLjAwIiwgImNvdW50eSI6ICJCT1VMREVSIiwgImRhdGFfc291cmNlIjogIkNvLiBEaXZpc2lvbiBvZiBXYXRlciBSZXNvdXJjZXMiLCAiZGF0ZV90aW1lIjogIjIwMTgtMTEtMjhUMDc6MzA6MDAiLCAiZGl2IjogIjEiLCAiZHdyX2FiYnJldiI6ICJCT1VMQVJDTyIsICJoaWdobGlnaHQiOiB7fSwgImh0dHBfbGlua2FnZS51cmwiOiAiaHR0cDovL3d3dy5kd3Iuc3RhdGUuY28udXMvU3VyZmFjZVdhdGVyL2RhdGEvZGV0YWlsX2dyYXBoLmFzcHg/SUQ9Qk9VTEFSQ08mTVRZUEU9RElTQ0hSRyIsICJsb2NhdGlvbi5sYXRpdHVkZSI6IDQwLjI1ODM2NywgImxvY2F0aW9uLmxvbmdpdHVkZSI6IC0xMDUuMTc0OTU3LCAibG9jYXRpb24ubmVlZHNfcmVjb2RpbmciOiBmYWxzZSwgInN0YWdlIjogIi0wLjA5IiwgInN0YXRpb25fbmFtZSI6ICJCT1VMREVSLUxBUklNRVIgRElUQ0ggTkVBUiBCRVJUSE9VRCIsICJzdGF0aW9uX3N0YXR1cyI6ICJBY3RpdmUiLCAic3RhdGlvbl90eXBlIjogIkRpdmVyc2lvbiIsICJzdHlsZSI6IHt9LCAidXNnc19zdGF0aW9uX2lkIjogbnVsbCwgInZhcmlhYmxlIjogIkRJU0NIUkciLCAid2QiOiAiNCJ9LCAidHlwZSI6ICJGZWF0dXJlIn0sIHsiYmJveCI6IFstMTA1LjE5ODU2NywgNDAuMjYwODI3LCAtMTA1LjE5ODU2NywgNDAuMjYwODI3XSwgImdlb21ldHJ5IjogeyJjb29yZGluYXRlcyI6IFstMTA1LjE5ODU2NywgNDAuMjYwODI3XSwgInR5cGUiOiAiUG9pbnQifSwgImlkIjogIjMiLCAicHJvcGVydGllcyI6IHsiYW1vdW50IjogIjAuMDAiLCAiY291bnR5IjogIkJPVUxERVIiLCAiZGF0YV9zb3VyY2UiOiAiQ29vcGVyYXRpdmUgU0RSIFByb2dyYW0gb2YgQ0RXUiAmIE5DV0NEIiwgImRhdGVfdGltZSI6ICIyMDE4LTExLTI4VDA3OjAwOjAwIiwgImRpdiI6ICIxIiwgImR3cl9hYmJyZXYiOiAiQ1VMRElUQ08iLCAiaGlnaGxpZ2h0Ijoge30sICJodHRwX2xpbmthZ2UudXJsIjogImh0dHA6Ly93d3cuZHdyLnN0YXRlLmNvLnVzL1N1cmZhY2VXYXRlci9kYXRhL2RldGFpbF9ncmFwaC5hc3B4P0lEPUNVTERJVENPJk1UWVBFPURJU0NIUkciLCAibG9jYXRpb24ubGF0aXR1ZGUiOiA0MC4yNjA4MjcsICJsb2NhdGlvbi5sb25naXR1ZGUiOiAtMTA1LjE5ODU2NywgImxvY2F0aW9uLm5lZWRzX3JlY29kaW5nIjogZmFsc2UsICJzdGFnZSI6IG51bGwsICJzdGF0aW9uX25hbWUiOiAiQ1VMVkVSIERJVENIIiwgInN0YXRpb25fc3RhdHVzIjogIkFjdGl2ZSIsICJzdGF0aW9uX3R5cGUiOiAiRGl2ZXJzaW9uIiwgInN0eWxlIjoge30sICJ1c2dzX3N0YXRpb25faWQiOiAiQ1VMRElUQ08iLCAidmFyaWFibGUiOiAiRElTQ0hSRyIsICJ3ZCI6ICI0In0sICJ0eXBlIjogIkZlYXR1cmUifSwgeyJiYm94IjogWy0xMDUuMjA5NDE2LCA0MC4yNTYyNzYwMDAwMDAwMSwgLTEwNS4yMDk0MTYsIDQwLjI1NjI3NjAwMDAwMDAxXSwgImdlb21ldHJ5IjogeyJjb29yZGluYXRlcyI6IFstMTA1LjIwOTQxNiwgNDAuMjU2Mjc2MDAwMDAwMDFdLCAidHlwZSI6ICJQb2ludCJ9LCAiaWQiOiAiNCIsICJwcm9wZXJ0aWVzIjogeyJhbW91bnQiOiAiMTUuNTAiLCAiY291bnR5IjogIkJPVUxERVIiLCAiZGF0YV9zb3VyY2UiOiAiTm9ydGhlcm4gQ29sb3JhZG8gV2F0ZXIgQ29uc2VydmFuY3kgRGlzdHJpY3QgKERhdGEgUHJvdmlkZXIpIiwgImRhdGVfdGltZSI6ICIyMDE4LTExLTI4VDA3OjAwOjAwIiwgImRpdiI6ICIxIiwgImR3cl9hYmJyZXYiOiAiTElUVEgxQ08iLCAiaGlnaGxpZ2h0Ijoge30sICJodHRwX2xpbmthZ2UudXJsIjogImh0dHA6Ly93d3cubm9ydGhlcm53YXRlci5vcmcvV2F0ZXJQcm9qZWN0cy9FYXN0U2xvcGVXYXRlckRhdGEuYXNweCIsICJsb2NhdGlvbi5sYXRpdHVkZSI6IDQwLjI1NjI3NiwgImxvY2F0aW9uLmxvbmdpdHVkZSI6IC0xMDUuMjA5NDE2LCAibG9jYXRpb24ubmVlZHNfcmVjb2RpbmciOiBmYWxzZSwgInN0YWdlIjogIjAuOTgiLCAic3RhdGlvbl9uYW1lIjogIkxJVFRMRSBUSE9NUFNPTiAjMSBESVRDSCIsICJzdGF0aW9uX3N0YXR1cyI6ICJBY3RpdmUiLCAic3RhdGlvbl90eXBlIjogIkRpdmVyc2lvbiIsICJzdHlsZSI6IHt9LCAidXNnc19zdGF0aW9uX2lkIjogIkVTMTkwMSIsICJ2YXJpYWJsZSI6ICJESVNDSFJHIiwgIndkIjogIjQifSwgInR5cGUiOiAiRmVhdHVyZSJ9LCB7ImJib3giOiBbLTEwNS4yMDk1LCA0MC4yNTU3NzYsIC0xMDUuMjA5NSwgNDAuMjU1Nzc2XSwgImdlb21ldHJ5IjogeyJjb29yZGluYXRlcyI6IFstMTA1LjIwOTUsIDQwLjI1NTc3Nl0sICJ0eXBlIjogIlBvaW50In0sICJpZCI6ICI1IiwgInByb3BlcnRpZXMiOiB7ImFtb3VudCI6ICIwLjAwIiwgImNvdW50eSI6ICJCT1VMREVSIiwgImRhdGFfc291cmNlIjogIk5vcnRoZXJuIENvbG9yYWRvIFdhdGVyIENvbnNlcnZhbmN5IERpc3RyaWN0IChEYXRhIFByb3ZpZGVyKSIsICJkYXRlX3RpbWUiOiAiMjAxOC0xMS0yOFQwNzowMDowMCIsICJkaXYiOiAiMSIsICJkd3JfYWJicmV2IjogIkxJVFRIMkNPIiwgImhpZ2hsaWdodCI6IHt9LCAiaHR0cF9saW5rYWdlLnVybCI6ICJodHRwOi8vd3d3Lm5vcnRoZXJud2F0ZXIub3JnL1dhdGVyUHJvamVjdHMvRWFzdFNsb3BlV2F0ZXJEYXRhLmFzcHgiLCAibG9jYXRpb24ubGF0aXR1ZGUiOiA0MC4yNTU3NzYsICJsb2NhdGlvbi5sb25naXR1ZGUiOiAtMTA1LjIwOTUsICJsb2NhdGlvbi5uZWVkc19yZWNvZGluZyI6IGZhbHNlLCAic3RhZ2UiOiAiMC4wMCIsICJzdGF0aW9uX25hbWUiOiAiTElUVExFIFRIT01QU09OICMyIERJVENIIiwgInN0YXRpb25fc3RhdHVzIjogIkFjdGl2ZSIsICJzdGF0aW9uX3R5cGUiOiAiRGl2ZXJzaW9uIiwgInN0eWxlIjoge30sICJ1c2dzX3N0YXRpb25faWQiOiAiRVMxOTAwIiwgInZhcmlhYmxlIjogIkRJU0NIUkciLCAid2QiOiAiNCJ9LCAidHlwZSI6ICJGZWF0dXJlIn0sIHsiYmJveCI6IFstMTA1LjIwNjM4NiwgNDAuMjU4MDM4LCAtMTA1LjIwNjM4NiwgNDAuMjU4MDM4XSwgImdlb21ldHJ5IjogeyJjb29yZGluYXRlcyI6IFstMTA1LjIwNjM4NiwgNDAuMjU4MDM4XSwgInR5cGUiOiAiUG9pbnQifSwgImlkIjogIjYiLCAicHJvcGVydGllcyI6IHsiYW1vdW50IjogIjAuNDEiLCAiY291bnR5IjogIkJPVUxERVIiLCAiZGF0YV9zb3VyY2UiOiAiQ28uIERpdmlzaW9uIG9mIFdhdGVyIFJlc291cmNlcyIsICJkYXRlX3RpbWUiOiAiMjAxOC0xMS0yOFQwNzozMDowMCIsICJkaXYiOiAiMSIsICJkd3JfYWJicmV2IjogIkxUQ0FOWUNPIiwgImhpZ2hsaWdodCI6IHt9LCAiaHR0cF9saW5rYWdlLnVybCI6ICJodHRwOi8vd3d3LmR3ci5zdGF0ZS5jby51cy9TdXJmYWNlV2F0ZXIvZGF0YS9kZXRhaWxfZ3JhcGguYXNweD9JRD1MVENBTllDTyZNVFlQRT1ESVNDSFJHIiwgImxvY2F0aW9uLmxhdGl0dWRlIjogNDAuMjU4MDM4LCAibG9jYXRpb24ubG9uZ2l0dWRlIjogLTEwNS4yMDYzODYsICJsb2NhdGlvbi5uZWVkc19yZWNvZGluZyI6IGZhbHNlLCAic3RhZ2UiOiAiMS4wNCIsICJzdGF0aW9uX25hbWUiOiAiTElUVExFIFRIT01QU09OIFJJVkVSIEFUIENBTllPTiBNT1VUSCBORUFSIEJFUlRIT1VEIiwgInN0YXRpb25fc3RhdHVzIjogIkFjdGl2ZSIsICJzdGF0aW9uX3R5cGUiOiAiU3RyZWFtIiwgInN0eWxlIjoge30sICJ1c2dzX3N0YXRpb25faWQiOiBudWxsLCAidmFyaWFibGUiOiAiRElTQ0hSRyIsICJ3ZCI6ICI0In0sICJ0eXBlIjogIkZlYXR1cmUifSwgeyJiYm94IjogWy0xMDUuMDg4Njk1LCA0MC4xNTMzNjMsIC0xMDUuMDg4Njk1LCA0MC4xNTMzNjNdLCAiZ2VvbWV0cnkiOiB7ImNvb3JkaW5hdGVzIjogWy0xMDUuMDg4Njk1LCA0MC4xNTMzNjNdLCAidHlwZSI6ICJQb2ludCJ9LCAiaWQiOiAiNyIsICJwcm9wZXJ0aWVzIjogeyJhbW91bnQiOiAiMC4wMCIsICJjb3VudHkiOiAiQk9VTERFUiIsICJkYXRhX3NvdXJjZSI6ICJDb29wZXJhdGl2ZSBQcm9ncmFtIG9mIENEV1IsIE5DV0NEICYgU1ZMSFdDRCIsICJkYXRlX3RpbWUiOiAiMjAxOC0xMS0yOFQwNzowMDowMCIsICJkaXYiOiAiMSIsICJkd3JfYWJicmV2IjogIkJPTkRJVENPIiwgImhpZ2hsaWdodCI6IHt9LCAiaHR0cF9saW5rYWdlLnVybCI6ICJodHRwOi8vd3d3LmR3ci5zdGF0ZS5jby51cy9TdXJmYWNlV2F0ZXIvZGF0YS9kZXRhaWxfZ3JhcGguYXNweD9JRD1CT05ESVRDTyZNVFlQRT1ESVNDSFJHIiwgImxvY2F0aW9uLmxhdGl0dWRlIjogNDAuMTUzMzYzLCAibG9jYXRpb24ubG9uZ2l0dWRlIjogLTEwNS4wODg2OTUsICJsb2NhdGlvbi5uZWVkc19yZWNvZGluZyI6IGZhbHNlLCAic3RhZ2UiOiBudWxsLCAic3RhdGlvbl9uYW1lIjogIkJPTlVTIERJVENIIiwgInN0YXRpb25fc3RhdHVzIjogIkFjdGl2ZSIsICJzdGF0aW9uX3R5cGUiOiAiRGl2ZXJzaW9uIiwgInN0eWxlIjoge30sICJ1c2dzX3N0YXRpb25faWQiOiAiQk9ORElUQ08iLCAidmFyaWFibGUiOiAiRElTQ0hSRyIsICJ3ZCI6ICI1In0sICJ0eXBlIjogIkZlYXR1cmUifSwgeyJiYm94IjogWy0xMDUuMzY1MzY1LCA0MC4yMTYyNjMsIC0xMDUuMzY1MzY1LCA0MC4yMTYyNjNdLCAiZ2VvbWV0cnkiOiB7ImNvb3JkaW5hdGVzIjogWy0xMDUuMzY1MzY1LCA0MC4yMTYyNjNdLCAidHlwZSI6ICJQb2ludCJ9LCAiaWQiOiAiOCIsICJwcm9wZXJ0aWVzIjogeyJhbW91bnQiOiAiMTQwOTMuMDAiLCAiY291bnR5IjogIkJPVUxERVIiLCAiZGF0YV9zb3VyY2UiOiAiQ28uIERpdmlzaW9uIG9mIFdhdGVyIFJlc291cmNlcyIsICJkYXRlX3RpbWUiOiAiMjAxOC0xMS0yOFQwNzo0NTowMCIsICJkaXYiOiAiMSIsICJkd3JfYWJicmV2IjogIkJSS0RBTUNPIiwgImhpZ2hsaWdodCI6IHt9LCAiaHR0cF9saW5rYWdlLnVybCI6ICJodHRwOi8vd3d3LmR3ci5zdGF0ZS5jby51cy9TdXJmYWNlV2F0ZXIvZGF0YS9kZXRhaWxfZ3JhcGguYXNweD9JRD1CUktEQU1DTyZNVFlQRT1TVE9SQUdFIiwgImxvY2F0aW9uLmxhdGl0dWRlIjogNDAuMjE2MjYzLCAibG9jYXRpb24ubG9uZ2l0dWRlIjogLTEwNS4zNjUzNjUsICJsb2NhdGlvbi5uZWVkc19yZWNvZGluZyI6IGZhbHNlLCAic3RhZ2UiOiAiNjM5MC4xMSIsICJzdGF0aW9uX25hbWUiOiAiQlVUVE9OUk9DSyAoUkFMUEggUFJJQ0UpIFJFU0VSVk9JUiIsICJzdGF0aW9uX3N0YXR1cyI6ICJBY3RpdmUiLCAic3RhdGlvbl90eXBlIjogIlJlc2Vydm9pciIsICJzdHlsZSI6IHt9LCAidXNnc19zdGF0aW9uX2lkIjogIkJSS0RBTUNPIiwgInZhcmlhYmxlIjogIlNUT1JBR0UiLCAid2QiOiAiNSJ9LCAidHlwZSI6ICJGZWF0dXJlIn0sIHsiYmJveCI6IFstMTA1LjIxMDM5LCA0MC4xOTM3NTgsIC0xMDUuMjEwMzksIDQwLjE5Mzc1OF0sICJnZW9tZXRyeSI6IHsiY29vcmRpbmF0ZXMiOiBbLTEwNS4yMTAzOSwgNDAuMTkzNzU4XSwgInR5cGUiOiAiUG9pbnQifSwgImlkIjogIjkiLCAicHJvcGVydGllcyI6IHsiYW1vdW50IjogIjAuMDAiLCAiY291bnR5IjogIkJPVUxERVIiLCAiZGF0YV9zb3VyY2UiOiAiQ29vcGVyYXRpdmUgUHJvZ3JhbSBvZiBDRFdSLCBOQ1dDRCAmIFNWTEhXQ0QiLCAiZGF0ZV90aW1lIjogIjIwMTgtMTEtMjhUMDc6MDA6MDAiLCAiZGl2IjogIjEiLCAiZHdyX2FiYnJldiI6ICJDTE9ESVRDTyIsICJoaWdobGlnaHQiOiB7fSwgImh0dHBfbGlua2FnZS51cmwiOiAiaHR0cDovL3d3dy5kd3Iuc3RhdGUuY28udXMvU3VyZmFjZVdhdGVyL2RhdGEvZGV0YWlsX2dyYXBoLmFzcHg/SUQ9Q0xPRElUQ08mTVRZUEU9RElTQ0hSRyIsICJsb2NhdGlvbi5sYXRpdHVkZSI6IDQwLjE5Mzc1OCwgImxvY2F0aW9uLmxvbmdpdHVkZSI6IC0xMDUuMjEwMzksICJsb2NhdGlvbi5uZWVkc19yZWNvZGluZyI6IGZhbHNlLCAic3RhZ2UiOiBudWxsLCAic3RhdGlvbl9uYW1lIjogIkNMT1VHSCBBTkQgVFJVRSBESVRDSCIsICJzdGF0aW9uX3N0YXR1cyI6ICJBY3RpdmUiLCAic3RhdGlvbl90eXBlIjogIkRpdmVyc2lvbiIsICJzdHlsZSI6IHt9LCAidXNnc19zdGF0aW9uX2lkIjogIkNMT0RJVENPIiwgInZhcmlhYmxlIjogIkRJU0NIUkciLCAid2QiOiAiNSJ9LCAidHlwZSI6ICJGZWF0dXJlIn0sIHsiYmJveCI6IFstMTA1LjE5Njc3NSwgNDAuMTgxODgsIC0xMDUuMTk2Nzc1LCA0MC4xODE4OF0sICJnZW9tZXRyeSI6IHsiY29vcmRpbmF0ZXMiOiBbLTEwNS4xOTY3NzUsIDQwLjE4MTg4XSwgInR5cGUiOiAiUG9pbnQifSwgImlkIjogIjEwIiwgInByb3BlcnRpZXMiOiB7ImFtb3VudCI6ICIwLjAwIiwgImNvdW50eSI6ICJCT1VMREVSIiwgImRhdGFfc291cmNlIjogIkNvb3BlcmF0aXZlIFByb2dyYW0gb2YgQ0RXUiwgTkNXQ0QgJiBTVkxIV0NEIiwgImRhdGVfdGltZSI6ICIyMDE4LTExLTI4VDA3OjAwOjAwIiwgImRpdiI6ICIxIiwgImR3cl9hYmJyZXYiOiAiREFWRE9XQ08iLCAiaGlnaGxpZ2h0Ijoge30sICJodHRwX2xpbmthZ2UudXJsIjogImh0dHA6Ly93d3cuZHdyLnN0YXRlLmNvLnVzL1N1cmZhY2VXYXRlci9kYXRhL2RldGFpbF9ncmFwaC5hc3B4P0lEPURBVkRPV0NPJk1UWVBFPURJU0NIUkciLCAibG9jYXRpb24ubGF0aXR1ZGUiOiA0MC4xODE4OCwgImxvY2F0aW9uLmxvbmdpdHVkZSI6IC0xMDUuMTk2Nzc1LCAibG9jYXRpb24ubmVlZHNfcmVjb2RpbmciOiBmYWxzZSwgInN0YWdlIjogbnVsbCwgInN0YXRpb25fbmFtZSI6ICJEQVZJUyBBTkQgRE9XTklORyBESVRDSCIsICJzdGF0aW9uX3N0YXR1cyI6ICJBY3RpdmUiLCAic3RhdGlvbl90eXBlIjogIkRpdmVyc2lvbiIsICJzdHlsZSI6IHt9LCAidXNnc19zdGF0aW9uX2lkIjogIkRBVkRPV0NPIiwgInZhcmlhYmxlIjogIkRJU0NIUkciLCAid2QiOiAiNSJ9LCAidHlwZSI6ICJGZWF0dXJlIn0sIHsiYmJveCI6IFstMTA1LjE4OTE5MSwgNDAuMTg3NTc4LCAtMTA1LjE4OTE5MSwgNDAuMTg3NTc4XSwgImdlb21ldHJ5IjogeyJjb29yZGluYXRlcyI6IFstMTA1LjE4OTE5MSwgNDAuMTg3NTc4XSwgInR5cGUiOiAiUG9pbnQifSwgImlkIjogIjExIiwgInByb3BlcnRpZXMiOiB7ImFtb3VudCI6ICIwLjAwIiwgImNvdW50eSI6ICJCT1VMREVSIiwgImRhdGFfc291cmNlIjogIkNvb3BlcmF0aXZlIFByb2dyYW0gb2YgQ0RXUiwgTkNXQ0QgJiBTVkxIV0NEIiwgImRhdGVfdGltZSI6ICIyMDE4LTExLTI4VDA3OjAwOjAwIiwgImRpdiI6ICIxIiwgImR3cl9hYmJyZXYiOiAiREVOVEFZQ08iLCAiaGlnaGxpZ2h0Ijoge30sICJodHRwX2xpbmthZ2UudXJsIjogImh0dHA6Ly93d3cuZHdyLnN0YXRlLmNvLnVzL1N1cmZhY2VXYXRlci9kYXRhL2RldGFpbF9ncmFwaC5hc3B4P0lEPURFTlRBWUNPJk1UWVBFPURJU0NIUkciLCAibG9jYXRpb24ubGF0aXR1ZGUiOiA0MC4xODc1NzgsICJsb2NhdGlvbi5sb25naXR1ZGUiOiAtMTA1LjE4OTE5MSwgImxvY2F0aW9uLm5lZWRzX3JlY29kaW5nIjogZmFsc2UsICJzdGFnZSI6IG51bGwsICJzdGF0aW9uX25hbWUiOiAiREVOSU8gVEFZTE9SIERJVENIIiwgInN0YXRpb25fc3RhdHVzIjogIkFjdGl2ZSIsICJzdGF0aW9uX3R5cGUiOiAiRGl2ZXJzaW9uIiwgInN0eWxlIjoge30sICJ1c2dzX3N0YXRpb25faWQiOiAiREVOVEFZQ08iLCAidmFyaWFibGUiOiAiRElTQ0hSRyIsICJ3ZCI6ICI1In0sICJ0eXBlIjogIkZlYXR1cmUifSwgeyJiYm94IjogWy0xMDUuMjIyNjM5LCA0MC4xOTkzMjEsIC0xMDUuMjIyNjM5LCA0MC4xOTkzMjFdLCAiZ2VvbWV0cnkiOiB7ImNvb3JkaW5hdGVzIjogWy0xMDUuMjIyNjM5LCA0MC4xOTkzMjFdLCAidHlwZSI6ICJQb2ludCJ9LCAiaWQiOiAiMTIiLCAicHJvcGVydGllcyI6IHsiYW1vdW50IjogIjAuMDAiLCAiY291bnR5IjogIkJPVUxERVIiLCAiZGF0YV9zb3VyY2UiOiAiQ29vcGVyYXRpdmUgUHJvZ3JhbSBvZiBDRFdSLCBOQ1dDRCAmIFNWTEhXQ0QiLCAiZGF0ZV90aW1lIjogIjIwMTgtMTEtMjhUMDc6MDA6MDAiLCAiZGl2IjogIjEiLCAiZHdyX2FiYnJldiI6ICJHT0RJVDFDTyIsICJoaWdobGlnaHQiOiB7fSwgImh0dHBfbGlua2FnZS51cmwiOiAiaHR0cDovL3d3dy5kd3Iuc3RhdGUuY28udXMvU3VyZmFjZVdhdGVyL2RhdGEvZGV0YWlsX2dyYXBoLmFzcHg/SUQ9R09ESVQxQ08mTVRZUEU9RElTQ0hSRyIsICJsb2NhdGlvbi5sYXRpdHVkZSI6IDQwLjE5OTMyMSwgImxvY2F0aW9uLmxvbmdpdHVkZSI6IC0xMDUuMjIyNjM5LCAibG9jYXRpb24ubmVlZHNfcmVjb2RpbmciOiBmYWxzZSwgInN0YWdlIjogbnVsbCwgInN0YXRpb25fbmFtZSI6ICJHT1NTIERJVENIIDEiLCAic3RhdGlvbl9zdGF0dXMiOiAiQWN0aXZlIiwgInN0YXRpb25fdHlwZSI6ICJEaXZlcnNpb24iLCAic3R5bGUiOiB7fSwgInVzZ3Nfc3RhdGlvbl9pZCI6ICJHT0RJVDFDTyIsICJ2YXJpYWJsZSI6ICJESVNDSFJHIiwgIndkIjogIjUifSwgInR5cGUiOiAiRmVhdHVyZSJ9LCB7ImJib3giOiBbLTEwNS4xNjc4NzMsIDQwLjE3NDg0NCwgLTEwNS4xNjc4NzMsIDQwLjE3NDg0NF0sICJnZW9tZXRyeSI6IHsiY29vcmRpbmF0ZXMiOiBbLTEwNS4xNjc4NzMsIDQwLjE3NDg0NF0sICJ0eXBlIjogIlBvaW50In0sICJpZCI6ICIxMyIsICJwcm9wZXJ0aWVzIjogeyJhbW91bnQiOiAiMC4wMyIsICJjb3VudHkiOiAiQk9VTERFUiIsICJkYXRhX3NvdXJjZSI6ICJDb29wZXJhdGl2ZSBQcm9ncmFtIG9mIENEV1IsIE5DV0NEICYgU1ZMSFdDRCIsICJkYXRlX3RpbWUiOiAiMjAxOC0xMS0yN1QxODowMDowMCIsICJkaXYiOiAiMSIsICJkd3JfYWJicmV2IjogIkhHUk1EV0NPIiwgImhpZ2hsaWdodCI6IHt9LCAiaHR0cF9saW5rYWdlLnVybCI6ICJodHRwOi8vd3d3LmR3ci5zdGF0ZS5jby51cy9TdXJmYWNlV2F0ZXIvZGF0YS9kZXRhaWxfZ3JhcGguYXNweD9JRD1IR1JNRFdDTyZNVFlQRT1ESVNDSFJHIiwgImxvY2F0aW9uLmxhdGl0dWRlIjogNDAuMTc0ODQ0LCAibG9jYXRpb24ubG9uZ2l0dWRlIjogLTEwNS4xNjc4NzMsICJsb2NhdGlvbi5uZWVkc19yZWNvZGluZyI6IGZhbHNlLCAic3RhZ2UiOiAiMC4wMyIsICJzdGF0aW9uX25hbWUiOiAiSEFHRVIgTUVBRE9XUyBESVRDSCIsICJzdGF0aW9uX3N0YXR1cyI6ICJBY3RpdmUiLCAic3RhdGlvbl90eXBlIjogIkRpdmVyc2lvbiIsICJzdHlsZSI6IHt9LCAidXNnc19zdGF0aW9uX2lkIjogIkhHUk1EV0NPIiwgInZhcmlhYmxlIjogIkRJU0NIUkciLCAid2QiOiAiNSJ9LCAidHlwZSI6ICJGZWF0dXJlIn0sIHsiYmJveCI6IFstMTA1LjI1NjAxNywgNDAuMjE1MDQzLCAtMTA1LjI1NjAxNywgNDAuMjE1MDQzXSwgImdlb21ldHJ5IjogeyJjb29yZGluYXRlcyI6IFstMTA1LjI1NjAxNywgNDAuMjE1MDQzXSwgInR5cGUiOiAiUG9pbnQifSwgImlkIjogIjE0IiwgInByb3BlcnRpZXMiOiB7ImFtb3VudCI6ICIxMy4xMCIsICJjb3VudHkiOiAiQk9VTERFUiIsICJkYXRhX3NvdXJjZSI6ICJDby4gRGl2aXNpb24gb2YgV2F0ZXIgUmVzb3VyY2VzIiwgImRhdGVfdGltZSI6ICIyMDE4LTExLTI4VDA3OjMwOjAwIiwgImRpdiI6ICIxIiwgImR3cl9hYmJyZXYiOiAiSElHSExEQ08iLCAiaGlnaGxpZ2h0Ijoge30sICJodHRwX2xpbmthZ2UudXJsIjogImh0dHA6Ly93d3cuZHdyLnN0YXRlLmNvLnVzL1N1cmZhY2VXYXRlci9kYXRhL2RldGFpbF9ncmFwaC5hc3B4P0lEPUhJR0hMRENPJk1UWVBFPURJU0NIUkciLCAibG9jYXRpb24ubGF0aXR1ZGUiOiA0MC4yMTUwNDMsICJsb2NhdGlvbi5sb25naXR1ZGUiOiAtMTA1LjI1NjAxNywgImxvY2F0aW9uLm5lZWRzX3JlY29kaW5nIjogZmFsc2UsICJzdGFnZSI6ICIwLjQwIiwgInN0YXRpb25fbmFtZSI6ICJISUdITEFORCBESVRDSCBBVCBMWU9OUywgQ08iLCAic3RhdGlvbl9zdGF0dXMiOiAiQWN0aXZlIiwgInN0YXRpb25fdHlwZSI6ICJEaXZlcnNpb24iLCAic3R5bGUiOiB7fSwgInVzZ3Nfc3RhdGlvbl9pZCI6IG51bGwsICJ2YXJpYWJsZSI6ICJESVNDSFJHIiwgIndkIjogIjUifSwgInR5cGUiOiAiRmVhdHVyZSJ9LCB7ImJib3giOiBbLTEwNS4yMDkyODIsIDQwLjE4ODU3OSwgLTEwNS4yMDkyODIsIDQwLjE4ODU3OV0sICJnZW9tZXRyeSI6IHsiY29vcmRpbmF0ZXMiOiBbLTEwNS4yMDkyODIsIDQwLjE4ODU3OV0sICJ0eXBlIjogIlBvaW50In0sICJpZCI6ICIxNSIsICJwcm9wZXJ0aWVzIjogeyJhbW91bnQiOiAiMi41MCIsICJjb3VudHkiOiAiQk9VTERFUiIsICJkYXRhX3NvdXJjZSI6ICJDb29wZXJhdGl2ZSBQcm9ncmFtIG9mIENEV1IsIE5DV0NEICYgU1ZMSFdDRCIsICJkYXRlX3RpbWUiOiAiMjAxOC0xMS0yOFQwNzowMDowMCIsICJkaXYiOiAiMSIsICJkd3JfYWJicmV2IjogIkpBTURJVENPIiwgImhpZ2hsaWdodCI6IHt9LCAiaHR0cF9saW5rYWdlLnVybCI6ICJodHRwOi8vd3d3LmR3ci5zdGF0ZS5jby51cy9TdXJmYWNlV2F0ZXIvZGF0YS9kZXRhaWxfZ3JhcGguYXNweD9JRD1KQU1ESVRDTyZNVFlQRT1ESVNDSFJHIiwgImxvY2F0aW9uLmxhdGl0dWRlIjogNDAuMTg4NTc5LCAibG9jYXRpb24ubG9uZ2l0dWRlIjogLTEwNS4yMDkyODIsICJsb2NhdGlvbi5uZWVkc19yZWNvZGluZyI6IGZhbHNlLCAic3RhZ2UiOiAiMC4yNyIsICJzdGF0aW9uX25hbWUiOiAiSkFNRVMgRElUQ0giLCAic3RhdGlvbl9zdGF0dXMiOiAiQWN0aXZlIiwgInN0YXRpb25fdHlwZSI6ICJEaXZlcnNpb24iLCAic3R5bGUiOiB7fSwgInVzZ3Nfc3RhdGlvbl9pZCI6ICJKQU1ESVRDTyIsICJ2YXJpYWJsZSI6ICJESVNDSFJHIiwgIndkIjogIjUifSwgInR5cGUiOiAiRmVhdHVyZSJ9LCB7ImJib3giOiBbLTEwNS4xMzA4MTksIDQwLjEzNDI3OCwgLTEwNS4xMzA4MTksIDQwLjEzNDI3OF0sICJnZW9tZXRyeSI6IHsiY29vcmRpbmF0ZXMiOiBbLTEwNS4xMzA4MTksIDQwLjEzNDI3OF0sICJ0eXBlIjogIlBvaW50In0sICJpZCI6ICIxNiIsICJwcm9wZXJ0aWVzIjogeyJhbW91bnQiOiAiNS4wNyIsICJjb3VudHkiOiAiQk9VTERFUiIsICJkYXRhX3NvdXJjZSI6ICJVLlMuIEdlb2xvZ2ljYWwgU3VydmV5IChEYXRhIFByb3ZpZGVyKSIsICJkYXRlX3RpbWUiOiAiMjAxOC0xMS0yOFQwNzozMDowMCIsICJkaXYiOiAiMSIsICJkd3JfYWJicmV2IjogIkxFRlRIT0NPIiwgImhpZ2hsaWdodCI6IHt9LCAiaHR0cF9saW5rYWdlLnVybCI6ICJodHRwOi8vd2F0ZXJkYXRhLnVzZ3MuZ292L253aXMvdXY/MDY3MjQ5NzAiLCAibG9jYXRpb24ubGF0aXR1ZGUiOiA0MC4xMzQyNzgsICJsb2NhdGlvbi5sb25naXR1ZGUiOiAtMTA1LjEzMDgxOSwgImxvY2F0aW9uLm5lZWRzX3JlY29kaW5nIjogZmFsc2UsICJzdGFnZSI6IG51bGwsICJzdGF0aW9uX25hbWUiOiAiTEVGVCBIQU5EIENSRUVLIEFUIEhPVkVSIFJPQUQgTkVBUiBMT05HTU9OVCwgQ08iLCAic3RhdGlvbl9zdGF0dXMiOiAiQWN0aXZlIiwgInN0YXRpb25fdHlwZSI6ICJTdHJlYW0iLCAic3R5bGUiOiB7fSwgInVzZ3Nfc3RhdGlvbl9pZCI6ICIwNjcyNDk3MCIsICJ2YXJpYWJsZSI6ICJESVNDSFJHIiwgIndkIjogIjUifSwgInR5cGUiOiAiRmVhdHVyZSJ9LCB7ImJib3giOiBbLTEwNS4yMTg3NzcsIDQwLjIwNDE5MywgLTEwNS4yMTg3NzcsIDQwLjIwNDE5M10sICJnZW9tZXRyeSI6IHsiY29vcmRpbmF0ZXMiOiBbLTEwNS4yMTg3NzcsIDQwLjIwNDE5M10sICJ0eXBlIjogIlBvaW50In0sICJpZCI6ICIxNyIsICJwcm9wZXJ0aWVzIjogeyJhbW91bnQiOiAiMC4zMyIsICJjb3VudHkiOiAiQk9VTERFUiIsICJkYXRhX3NvdXJjZSI6ICJDb29wZXJhdGl2ZSBQcm9ncmFtIG9mIENEV1IsIE5DV0NEICYgU1ZMSFdDRCIsICJkYXRlX3RpbWUiOiAiMjAxOC0xMS0yOFQwNzowMDowMCIsICJkaXYiOiAiMSIsICJkd3JfYWJicmV2IjogIkxPTlNVUENPIiwgImhpZ2hsaWdodCI6IHt9LCAiaHR0cF9saW5rYWdlLnVybCI6ICJodHRwOi8vd3d3LmR3ci5zdGF0ZS5jby51cy9TdXJmYWNlV2F0ZXIvZGF0YS9kZXRhaWxfZ3JhcGguYXNweD9JRD1MT05TVVBDTyZNVFlQRT1ESVNDSFJHIiwgImxvY2F0aW9uLmxhdGl0dWRlIjogNDAuMjA0MTkzLCAibG9jYXRpb24ubG9uZ2l0dWRlIjogLTEwNS4yMTg3NzcsICJsb2NhdGlvbi5uZWVkc19yZWNvZGluZyI6IGZhbHNlLCAic3RhZ2UiOiAiMC4xMCIsICJzdGF0aW9uX25hbWUiOiAiTE9OR01PTlQgU1VQUExZIERJVENIIiwgInN0YXRpb25fc3RhdHVzIjogIkFjdGl2ZSIsICJzdGF0aW9uX3R5cGUiOiAiRGl2ZXJzaW9uIiwgInN0eWxlIjoge30sICJ1c2dzX3N0YXRpb25faWQiOiAiTE9OU1VQQ08iLCAidmFyaWFibGUiOiAiRElTQ0hSRyIsICJ3ZCI6ICI1In0sICJ0eXBlIjogIkZlYXR1cmUifSwgeyJiYm94IjogWy0xMDUuMTY5Mzc0LCA0MC4xNzM5NSwgLTEwNS4xNjkzNzQsIDQwLjE3Mzk1XSwgImdlb21ldHJ5IjogeyJjb29yZGluYXRlcyI6IFstMTA1LjE2OTM3NCwgNDAuMTczOTVdLCAidHlwZSI6ICJQb2ludCJ9LCAiaWQiOiAiMTgiLCAicHJvcGVydGllcyI6IHsiYW1vdW50IjogIjAuNDciLCAiY291bnR5IjogIkJPVUxERVIiLCAiZGF0YV9zb3VyY2UiOiAiQ29vcGVyYXRpdmUgUHJvZ3JhbSBvZiBDRFdSLCBOQ1dDRCAmIFNWTEhXQ0QiLCAiZGF0ZV90aW1lIjogIjIwMTgtMTEtMjhUMDc6MDA6MDAiLCAiZGl2IjogIjEiLCAiZHdyX2FiYnJldiI6ICJOSVdESVRDTyIsICJoaWdobGlnaHQiOiB7fSwgImh0dHBfbGlua2FnZS51cmwiOiAiaHR0cDovL3d3dy5kd3Iuc3RhdGUuY28udXMvU3VyZmFjZVdhdGVyL2RhdGEvZGV0YWlsX2dyYXBoLmFzcHg/SUQ9TklXRElUQ08mTVRZUEU9RElTQ0hSRyIsICJsb2NhdGlvbi5sYXRpdHVkZSI6IDQwLjE3Mzk1LCAibG9jYXRpb24ubG9uZ2l0dWRlIjogLTEwNS4xNjkzNzQsICJsb2NhdGlvbi5uZWVkc19yZWNvZGluZyI6IGZhbHNlLCAic3RhZ2UiOiAiMC4xNiIsICJzdGF0aW9uX25hbWUiOiAiTklXT1QgRElUQ0giLCAic3RhdGlvbl9zdGF0dXMiOiAiQWN0aXZlIiwgInN0YXRpb25fdHlwZSI6ICJEaXZlcnNpb24iLCAic3R5bGUiOiB7fSwgInVzZ3Nfc3RhdGlvbl9pZCI6ICJOSVdESVRDTyIsICJ2YXJpYWJsZSI6ICJESVNDSFJHIiwgIndkIjogIjUifSwgInR5cGUiOiAiRmVhdHVyZSJ9LCB7ImJib3giOiBbLTEwNS4zNjM0MjIsIDQwLjIxNTY1OCwgLTEwNS4zNjM0MjIsIDQwLjIxNTY1OF0sICJnZW9tZXRyeSI6IHsiY29vcmRpbmF0ZXMiOiBbLTEwNS4zNjM0MjIsIDQwLjIxNTY1OF0sICJ0eXBlIjogIlBvaW50In0sICJpZCI6ICIxOSIsICJwcm9wZXJ0aWVzIjogeyJhbW91bnQiOiAiMjguNDAiLCAiY291bnR5IjogIkJPVUxERVIiLCAiZGF0YV9zb3VyY2UiOiAiQ28uIERpdmlzaW9uIG9mIFdhdGVyIFJlc291cmNlcyIsICJkYXRlX3RpbWUiOiAiMjAxOC0xMS0yOFQwNjo0NTowMCIsICJkaXYiOiAiMSIsICJkd3JfYWJicmV2IjogIk5TVkJCUkNPIiwgImhpZ2hsaWdodCI6IHt9LCAiaHR0cF9saW5rYWdlLnVybCI6ICJodHRwOi8vd3d3LmR3ci5zdGF0ZS5jby51cy9TdXJmYWNlV2F0ZXIvZGF0YS9kZXRhaWxfZ3JhcGguYXNweD9JRD1OU1ZCQlJDTyZNVFlQRT1ESVNDSFJHIiwgImxvY2F0aW9uLmxhdGl0dWRlIjogNDAuMjE1NjU4LCAibG9jYXRpb24ubG9uZ2l0dWRlIjogLTEwNS4zNjM0MjIsICJsb2NhdGlvbi5uZWVkc19yZWNvZGluZyI6IGZhbHNlLCAic3RhZ2UiOiAiMC40MSIsICJzdGF0aW9uX25hbWUiOiAiTk9SVEggU0FJTlQgVlJBSU4gQ1JFRUsgQkVMT1cgQlVUVE9OUk9DSyAgKFJBTFBIIFBSSUNFKSBSRVNFUlZPSVIiLCAic3RhdGlvbl9zdGF0dXMiOiAiQWN0aXZlIiwgInN0YXRpb25fdHlwZSI6ICJTdHJlYW0iLCAic3R5bGUiOiB7fSwgInVzZ3Nfc3RhdGlvbl9pZCI6ICJOU1ZCQlJDTyIsICJ2YXJpYWJsZSI6ICJESVNDSFJHIiwgIndkIjogIjUifSwgInR5cGUiOiAiRmVhdHVyZSJ9LCB7ImJib3giOiBbLTEwNS4xNjc2MjIsIDQwLjE3MjkyNSwgLTEwNS4xNjc2MjIsIDQwLjE3MjkyNV0sICJnZW9tZXRyeSI6IHsiY29vcmRpbmF0ZXMiOiBbLTEwNS4xNjc2MjIsIDQwLjE3MjkyNV0sICJ0eXBlIjogIlBvaW50In0sICJpZCI6ICIyMCIsICJwcm9wZXJ0aWVzIjogeyJhbW91bnQiOiAiMC4wNyIsICJjb3VudHkiOiAiQk9VTERFUiIsICJkYXRhX3NvdXJjZSI6ICJDb29wZXJhdGl2ZSBTRFIgUHJvZ3JhbSBvZiBDRFdSICYgTkNXQ0QiLCAiZGF0ZV90aW1lIjogIjIwMTgtMTEtMjhUMDc6MDA6MDAiLCAiZGl2IjogIjEiLCAiZHdyX2FiYnJldiI6ICJOT1JNVVRDTyIsICJoaWdobGlnaHQiOiB7fSwgImh0dHBfbGlua2FnZS51cmwiOiAiaHR0cDovL3d3dy5kd3Iuc3RhdGUuY28udXMvU3VyZmFjZVdhdGVyL2RhdGEvZGV0YWlsX2dyYXBoLmFzcHg/SUQ9Tk9STVVUQ08mTVRZUEU9RElTQ0hSRyIsICJsb2NhdGlvbi5sYXRpdHVkZSI6IDQwLjE3MjkyNSwgImxvY2F0aW9uLmxvbmdpdHVkZSI6IC0xMDUuMTY3NjIyLCAibG9jYXRpb24ubmVlZHNfcmVjb2RpbmciOiBmYWxzZSwgInN0YWdlIjogIjAuMDciLCAic3RhdGlvbl9uYW1lIjogIk5PUlRIV0VTVCBNVVRVQUwgRElUQ0giLCAic3RhdGlvbl9zdGF0dXMiOiAiQWN0aXZlIiwgInN0YXRpb25fdHlwZSI6ICJEaXZlcnNpb24iLCAic3R5bGUiOiB7fSwgInVzZ3Nfc3RhdGlvbl9pZCI6ICJOT1JNVVRDTyIsICJ2YXJpYWJsZSI6ICJESVNDSFJHIiwgIndkIjogIjUifSwgInR5cGUiOiAiRmVhdHVyZSJ9LCB7ImJib3giOiBbLTEwNS4yMDY1OTIsIDQwLjE5NjQyMiwgLTEwNS4yMDY1OTIsIDQwLjE5NjQyMl0sICJnZW9tZXRyeSI6IHsiY29vcmRpbmF0ZXMiOiBbLTEwNS4yMDY1OTIsIDQwLjE5NjQyMl0sICJ0eXBlIjogIlBvaW50In0sICJpZCI6ICIyMSIsICJwcm9wZXJ0aWVzIjogeyJhbW91bnQiOiAiMC4wMCIsICJjb3VudHkiOiAiQk9VTERFUiIsICJkYXRhX3NvdXJjZSI6ICJDb29wZXJhdGl2ZSBQcm9ncmFtIG9mIENEV1IsIE5DV0NEICYgU1ZMSFdDRCIsICJkYXRlX3RpbWUiOiAiMjAxOC0xMS0yOFQwNzowMDowMCIsICJkaXYiOiAiMSIsICJkd3JfYWJicmV2IjogIk9MSURJVENPIiwgImhpZ2hsaWdodCI6IHt9LCAiaHR0cF9saW5rYWdlLnVybCI6ICJodHRwOi8vd3d3LmR3ci5zdGF0ZS5jby51cy9TdXJmYWNlV2F0ZXIvZGF0YS9kZXRhaWxfZ3JhcGguYXNweD9JRD1PTElESVRDTyZNVFlQRT1ESVNDSFJHIiwgImxvY2F0aW9uLmxhdGl0dWRlIjogNDAuMTk2NDIyLCAibG9jYXRpb24ubG9uZ2l0dWRlIjogLTEwNS4yMDY1OTIsICJsb2NhdGlvbi5uZWVkc19yZWNvZGluZyI6IGZhbHNlLCAic3RhZ2UiOiBudWxsLCAic3RhdGlvbl9uYW1lIjogIk9MSUdBUkNIWSBESVRDSCBESVZFUlNJT04iLCAic3RhdGlvbl9zdGF0dXMiOiAiQWN0aXZlIiwgInN0YXRpb25fdHlwZSI6ICJEaXZlcnNpb24iLCAic3R5bGUiOiB7fSwgInVzZ3Nfc3RhdGlvbl9pZCI6IG51bGwsICJ2YXJpYWJsZSI6ICJESVNDSFJHIiwgIndkIjogIjUifSwgInR5cGUiOiAiRmVhdHVyZSJ9LCB7ImJib3giOiBbLTEwNS4yNTE4MjYsIDQwLjIxMjUwNSwgLTEwNS4yNTE4MjYsIDQwLjIxMjUwNV0sICJnZW9tZXRyeSI6IHsiY29vcmRpbmF0ZXMiOiBbLTEwNS4yNTE4MjYsIDQwLjIxMjUwNV0sICJ0eXBlIjogIlBvaW50In0sICJpZCI6ICIyMiIsICJwcm9wZXJ0aWVzIjogeyJhbW91bnQiOiAiMC4wMiIsICJjb3VudHkiOiAiQk9VTERFUiIsICJkYXRhX3NvdXJjZSI6ICJDb29wZXJhdGl2ZSBQcm9ncmFtIG9mIENEV1IsIE5DV0NEICYgU1ZMSFdDRCIsICJkYXRlX3RpbWUiOiAiMjAxOC0xMS0yOFQwNzowMDowMCIsICJkaXYiOiAiMSIsICJkd3JfYWJicmV2IjogIlBBTERJVENPIiwgImhpZ2hsaWdodCI6IHt9LCAiaHR0cF9saW5rYWdlLnVybCI6ICJodHRwOi8vd3d3LmR3ci5zdGF0ZS5jby51cy9TdXJmYWNlV2F0ZXIvZGF0YS9kZXRhaWxfZ3JhcGguYXNweD9JRD1QQUxESVRDTyZNVFlQRT1ESVNDSFJHIiwgImxvY2F0aW9uLmxhdGl0dWRlIjogNDAuMjEyNTA1LCAibG9jYXRpb24ubG9uZ2l0dWRlIjogLTEwNS4yNTE4MjYsICJsb2NhdGlvbi5uZWVkc19yZWNvZGluZyI6IGZhbHNlLCAic3RhZ2UiOiAiMC4wMSIsICJzdGF0aW9uX25hbWUiOiAiUEFMTUVSVE9OIERJVENIIiwgInN0YXRpb25fc3RhdHVzIjogIkFjdGl2ZSIsICJzdGF0aW9uX3R5cGUiOiAiRGl2ZXJzaW9uIiwgInN0eWxlIjoge30sICJ1c2dzX3N0YXRpb25faWQiOiAiUEFMRElUQ08iLCAidmFyaWFibGUiOiAiRElTQ0hSRyIsICJ3ZCI6ICI1In0sICJ0eXBlIjogIkZlYXR1cmUifSwgeyJiYm94IjogWy0xMDUuMTc4NTY3LCA0MC4xNzcwODAwMDAwMDAwMDQsIC0xMDUuMTc4NTY3LCA0MC4xNzcwODAwMDAwMDAwMDRdLCAiZ2VvbWV0cnkiOiB7ImNvb3JkaW5hdGVzIjogWy0xMDUuMTc4NTY3LCA0MC4xNzcwODAwMDAwMDAwMDRdLCAidHlwZSI6ICJQb2ludCJ9LCAiaWQiOiAiMjMiLCAicHJvcGVydGllcyI6IHsiYW1vdW50IjogIjAuNDMiLCAiY291bnR5IjogIkJPVUxERVIiLCAiZGF0YV9zb3VyY2UiOiAiQ29vcGVyYXRpdmUgU0RSIFByb2dyYW0gb2YgQ0RXUiAmIE5DV0NEIiwgImRhdGVfdGltZSI6ICIyMDE4LTExLTI4VDA2OjAwOjAwIiwgImRpdiI6ICIxIiwgImR3cl9hYmJyZXYiOiAiUENLUEVMQ08iLCAiaGlnaGxpZ2h0Ijoge30sICJodHRwX2xpbmthZ2UudXJsIjogImh0dHA6Ly93d3cuZHdyLnN0YXRlLmNvLnVzL1N1cmZhY2VXYXRlci9kYXRhL2RldGFpbF9ncmFwaC5hc3B4P0lEPVBDS1BFTENPJk1UWVBFPURJU0NIUkciLCAibG9jYXRpb24ubGF0aXR1ZGUiOiA0MC4xNzcwOCwgImxvY2F0aW9uLmxvbmdpdHVkZSI6IC0xMDUuMTc4NTY3LCAibG9jYXRpb24ubmVlZHNfcmVjb2RpbmciOiBmYWxzZSwgInN0YWdlIjogIjAuMDgiLCAic3RhdGlvbl9uYW1lIjogIlBFQ0sgUEVMTEEgQ0xPVkVSIERJVENIIiwgInN0YXRpb25fc3RhdHVzIjogIkFjdGl2ZSIsICJzdGF0aW9uX3R5cGUiOiAiRGl2ZXJzaW9uIiwgInN0eWxlIjoge30sICJ1c2dzX3N0YXRpb25faWQiOiAiUENLUEVMQ08iLCAidmFyaWFibGUiOiAiRElTQ0hSRyIsICJ3ZCI6ICI1In0sICJ0eXBlIjogIkZlYXR1cmUifSwgeyJiYm94IjogWy0xMDUuMjUxODI2LCA0MC4yMTI2NTgsIC0xMDUuMjUxODI2LCA0MC4yMTI2NThdLCAiZ2VvbWV0cnkiOiB7ImNvb3JkaW5hdGVzIjogWy0xMDUuMjUxODI2LCA0MC4yMTI2NThdLCAidHlwZSI6ICJQb2ludCJ9LCAiaWQiOiAiMjQiLCAicHJvcGVydGllcyI6IHsiYW1vdW50IjogIjYuNDUiLCAiY291bnR5IjogIkJPVUxERVIiLCAiZGF0YV9zb3VyY2UiOiAiQ29vcGVyYXRpdmUgUHJvZ3JhbSBvZiBDRFdSLCBOQ1dDRCAmIFNWTEhXQ0QiLCAiZGF0ZV90aW1lIjogIjIwMTgtMTEtMjhUMDc6MDA6MDAiLCAiZGl2IjogIjEiLCAiZHdyX2FiYnJldiI6ICJST1VSRUFDTyIsICJoaWdobGlnaHQiOiB7fSwgImh0dHBfbGlua2FnZS51cmwiOiAiaHR0cDovL3d3dy5kd3Iuc3RhdGUuY28udXMvU3VyZmFjZVdhdGVyL2RhdGEvZGV0YWlsX2dyYXBoLmFzcHg/SUQ9Uk9VUkVBQ08mTVRZUEU9RElTQ0hSRyIsICJsb2NhdGlvbi5sYXRpdHVkZSI6IDQwLjIxMjY1OCwgImxvY2F0aW9uLmxvbmdpdHVkZSI6IC0xMDUuMjUxODI2LCAibG9jYXRpb24ubmVlZHNfcmVjb2RpbmciOiBmYWxzZSwgInN0YWdlIjogIjAuNDkiLCAic3RhdGlvbl9uYW1lIjogIlJPVUdIIEFORCBSRUFEWSBESVRDSCIsICJzdGF0aW9uX3N0YXR1cyI6ICJBY3RpdmUiLCAic3RhdGlvbl90eXBlIjogIkRpdmVyc2lvbiIsICJzdHlsZSI6IHt9LCAidXNnc19zdGF0aW9uX2lkIjogIlJPVVJFQUNPIiwgInZhcmlhYmxlIjogIkRJU0NIUkciLCAid2QiOiAiNSJ9LCAidHlwZSI6ICJGZWF0dXJlIn0sIHsiYmJveCI6IFstMTA1LjE4OTEzMiwgNDAuMTg3NTI0LCAtMTA1LjE4OTEzMiwgNDAuMTg3NTI0XSwgImdlb21ldHJ5IjogeyJjb29yZGluYXRlcyI6IFstMTA1LjE4OTEzMiwgNDAuMTg3NTI0XSwgInR5cGUiOiAiUG9pbnQifSwgImlkIjogIjI1IiwgInByb3BlcnRpZXMiOiB7ImFtb3VudCI6ICIwLjA2IiwgImNvdW50eSI6ICJCT1VMREVSIiwgImRhdGFfc291cmNlIjogIkNvb3BlcmF0aXZlIFByb2dyYW0gb2YgQ0RXUiwgTkNXQ0QgJiBTVkxIV0NEIiwgImRhdGVfdGltZSI6ICIyMDE4LTExLTI4VDA3OjAwOjAwIiwgImRpdiI6ICIxIiwgImR3cl9hYmJyZXYiOiAiUlVOWU9OQ08iLCAiaGlnaGxpZ2h0Ijoge30sICJodHRwX2xpbmthZ2UudXJsIjogImh0dHA6Ly93d3cuZHdyLnN0YXRlLmNvLnVzL1N1cmZhY2VXYXRlci9kYXRhL2RldGFpbF9ncmFwaC5hc3B4P0lEPVJVTllPTkNPJk1UWVBFPURJU0NIUkciLCAibG9jYXRpb24ubGF0aXR1ZGUiOiA0MC4xODc1MjQsICJsb2NhdGlvbi5sb25naXR1ZGUiOiAtMTA1LjE4OTEzMiwgImxvY2F0aW9uLm5lZWRzX3JlY29kaW5nIjogZmFsc2UsICJzdGFnZSI6ICIwLjAyIiwgInN0YXRpb25fbmFtZSI6ICJSVU5ZT04gRElUQ0giLCAic3RhdGlvbl9zdGF0dXMiOiAiQWN0aXZlIiwgInN0YXRpb25fdHlwZSI6ICJEaXZlcnNpb24iLCAic3R5bGUiOiB7fSwgInVzZ3Nfc3RhdGlvbl9pZCI6ICJSVU5ZT05DTyIsICJ2YXJpYWJsZSI6ICJESVNDSFJHIiwgIndkIjogIjUifSwgInR5cGUiOiAiRmVhdHVyZSJ9LCB7ImJib3giOiBbLTEwNS4xNzgxNDUsIDQwLjE3NzQyMywgLTEwNS4xNzgxNDUsIDQwLjE3NzQyM10sICJnZW9tZXRyeSI6IHsiY29vcmRpbmF0ZXMiOiBbLTEwNS4xNzgxNDUsIDQwLjE3NzQyM10sICJ0eXBlIjogIlBvaW50In0sICJpZCI6ICIyNiIsICJwcm9wZXJ0aWVzIjogeyJhbW91bnQiOiAiNy42MCIsICJjb3VudHkiOiAiQk9VTERFUiIsICJkYXRhX3NvdXJjZSI6ICJDby4gRGl2aXNpb24gb2YgV2F0ZXIgUmVzb3VyY2VzIiwgImRhdGVfdGltZSI6ICIyMDE4LTExLTI4VDA2OjQ1OjAwIiwgImRpdiI6ICIxIiwgImR3cl9hYmJyZXYiOiAiU1ZDSEdJQ08iLCAiaGlnaGxpZ2h0Ijoge30sICJodHRwX2xpbmthZ2UudXJsIjogImh0dHA6Ly93d3cuZHdyLnN0YXRlLmNvLnVzL1N1cmZhY2VXYXRlci9kYXRhL2RldGFpbF9ncmFwaC5hc3B4P0lEPVNWQ0hHSUNPJk1UWVBFPURJU0NIUkciLCAibG9jYXRpb24ubGF0aXR1ZGUiOiA0MC4xNzc0MjMsICJsb2NhdGlvbi5sb25naXR1ZGUiOiAtMTA1LjE3ODE0NSwgImxvY2F0aW9uLm5lZWRzX3JlY29kaW5nIjogZmFsc2UsICJzdGFnZSI6ICIxLjcwIiwgInN0YXRpb25fbmFtZSI6ICJTQUlOVCBWUkFJTiBDUkVFSyBBVCBIWUdJRU5FLCBDTyIsICJzdGF0aW9uX3N0YXR1cyI6ICJBY3RpdmUiLCAic3RhdGlvbl90eXBlIjogIlN0cmVhbSIsICJzdHlsZSI6IHt9LCAidXNnc19zdGF0aW9uX2lkIjogIlNWQ0hHSUNPIiwgInZhcmlhYmxlIjogIkRJU0NIUkciLCAid2QiOiAiNSJ9LCAidHlwZSI6ICJGZWF0dXJlIn0sIHsiYmJveCI6IFstMTA1LjI2MzQ5LCA0MC4yMjA3MDIsIC0xMDUuMjYzNDksIDQwLjIyMDcwMl0sICJnZW9tZXRyeSI6IHsiY29vcmRpbmF0ZXMiOiBbLTEwNS4yNjM0OSwgNDAuMjIwNzAyXSwgInR5cGUiOiAiUG9pbnQifSwgImlkIjogIjI3IiwgInByb3BlcnRpZXMiOiB7ImFtb3VudCI6ICIyMS4yMCIsICJjb3VudHkiOiAiQk9VTERFUiIsICJkYXRhX3NvdXJjZSI6ICJDby4gRGl2aXNpb24gb2YgV2F0ZXIgUmVzb3VyY2VzIiwgImRhdGVfdGltZSI6ICIyMDE4LTExLTI4VDA3OjE1OjAwIiwgImRpdiI6ICIxIiwgImR3cl9hYmJyZXYiOiAiU1ZDTFlPQ08iLCAiaGlnaGxpZ2h0Ijoge30sICJodHRwX2xpbmthZ2UudXJsIjogImh0dHA6Ly93d3cuZHdyLnN0YXRlLmNvLnVzL1N1cmZhY2VXYXRlci9kYXRhL2RldGFpbF9ncmFwaC5hc3B4P0lEPVNWQ0xZT0NPJk1UWVBFPURJU0NIUkciLCAibG9jYXRpb24ubGF0aXR1ZGUiOiA0MC4yMjA3MDIsICJsb2NhdGlvbi5sb25naXR1ZGUiOiAtMTA1LjI2MzQ5LCAibG9jYXRpb24ubmVlZHNfcmVjb2RpbmciOiBmYWxzZSwgInN0YWdlIjogIjIuOTEiLCAic3RhdGlvbl9uYW1lIjogIlNBSU5UIFZSQUlOIENSRUVLIEFUIExZT05TLCBDTyIsICJzdGF0aW9uX3N0YXR1cyI6ICJBY3RpdmUiLCAic3RhdGlvbl90eXBlIjogIlN0cmVhbSIsICJzdHlsZSI6IHt9LCAidXNnc19zdGF0aW9uX2lkIjogIjA2NzI0MDAwIiwgInZhcmlhYmxlIjogIkRJU0NIUkciLCAid2QiOiAiNSJ9LCAidHlwZSI6ICJGZWF0dXJlIn0sIHsiYmJveCI6IFstMTA1LjA3NTY5NTAwMDAwMDAxLCA0MC4xNTMzNDEsIC0xMDUuMDc1Njk1MDAwMDAwMDEsIDQwLjE1MzM0MV0sICJnZW9tZXRyeSI6IHsiY29vcmRpbmF0ZXMiOiBbLTEwNS4wNzU2OTUwMDAwMDAwMSwgNDAuMTUzMzQxXSwgInR5cGUiOiAiUG9pbnQifSwgImlkIjogIjI4IiwgInByb3BlcnRpZXMiOiB7ImFtb3VudCI6ICIyNC40MCIsICJjb3VudHkiOiAiQk9VTERFUiIsICJkYXRhX3NvdXJjZSI6ICJDby4gRGl2aXNpb24gb2YgV2F0ZXIgUmVzb3VyY2VzIiwgImRhdGVfdGltZSI6ICIyMDE4LTExLTI4VDA3OjMwOjAwIiwgImRpdiI6ICIxIiwgImR3cl9hYmJyZXYiOiAiU1ZDTE9QQ08iLCAiaGlnaGxpZ2h0Ijoge30sICJodHRwX2xpbmthZ2UudXJsIjogImh0dHA6Ly93d3cuZHdyLnN0YXRlLmNvLnVzL1N1cmZhY2VXYXRlci9kYXRhL2RldGFpbF9ncmFwaC5hc3B4P0lEPVNWQ0xPUENPJk1UWVBFPURJU0NIUkciLCAibG9jYXRpb24ubGF0aXR1ZGUiOiA0MC4xNTMzNDEsICJsb2NhdGlvbi5sb25naXR1ZGUiOiAtMTA1LjA3NTY5NSwgImxvY2F0aW9uLm5lZWRzX3JlY29kaW5nIjogZmFsc2UsICJzdGFnZSI6ICIzLjQ5IiwgInN0YXRpb25fbmFtZSI6ICJTQUlOVCBWUkFJTiBDUkVFSyBCRUxPVyBLRU4gUFJBVFQgQkxWRCBBVCBMT05HTU9OVCwgQ08iLCAic3RhdGlvbl9zdGF0dXMiOiAiQWN0aXZlIiwgInN0YXRpb25fdHlwZSI6ICJTdHJlYW0iLCAic3R5bGUiOiB7fSwgInVzZ3Nfc3RhdGlvbl9pZCI6ICJTVkNMT1BDTyIsICJ2YXJpYWJsZSI6ICJESVNDSFJHIiwgIndkIjogIjUifSwgInR5cGUiOiAiRmVhdHVyZSJ9LCB7ImJib3giOiBbLTEwNS4yNTA5NTIsIDQwLjIxMTM4OSwgLTEwNS4yNTA5NTIsIDQwLjIxMTM4OV0sICJnZW9tZXRyeSI6IHsiY29vcmRpbmF0ZXMiOiBbLTEwNS4yNTA5NTIsIDQwLjIxMTM4OV0sICJ0eXBlIjogIlBvaW50In0sICJpZCI6ICIyOSIsICJwcm9wZXJ0aWVzIjogeyJhbW91bnQiOiAiMC43MSIsICJjb3VudHkiOiAiQk9VTERFUiIsICJkYXRhX3NvdXJjZSI6ICJDb29wZXJhdGl2ZSBQcm9ncmFtIG9mIENEV1IsIE5DV0NEICYgU1ZMSFdDRCIsICJkYXRlX3RpbWUiOiAiMjAxOC0xMS0yOFQwNzowMDowMCIsICJkaXYiOiAiMSIsICJkd3JfYWJicmV2IjogIlNNRURJVENPIiwgImhpZ2hsaWdodCI6IHt9LCAiaHR0cF9saW5rYWdlLnVybCI6ICJodHRwOi8vd3d3LmR3ci5zdGF0ZS5jby51cy9TdXJmYWNlV2F0ZXIvZGF0YS9kZXRhaWxfZ3JhcGguYXNweD9JRD1TTUVESVRDTyZNVFlQRT1ESVNDSFJHIiwgImxvY2F0aW9uLmxhdGl0dWRlIjogNDAuMjExMzg5LCAibG9jYXRpb24ubG9uZ2l0dWRlIjogLTEwNS4yNTA5NTIsICJsb2NhdGlvbi5uZWVkc19yZWNvZGluZyI6IGZhbHNlLCAic3RhZ2UiOiAiMC4yNSIsICJzdGF0aW9uX25hbWUiOiAiU01FQUQgRElUQ0giLCAic3RhdGlvbl9zdGF0dXMiOiAiQWN0aXZlIiwgInN0YXRpb25fdHlwZSI6ICJEaXZlcnNpb24iLCAic3R5bGUiOiB7fSwgInVzZ3Nfc3RhdGlvbl9pZCI6ICJTTUVESVRDTyIsICJ2YXJpYWJsZSI6ICJESVNDSFJHIiwgIndkIjogIjUifSwgInR5cGUiOiAiRmVhdHVyZSJ9LCB7ImJib3giOiBbLTEwNS4xNjA4NzYsIDQwLjE3MDk5OCwgLTEwNS4xNjA4NzYsIDQwLjE3MDk5OF0sICJnZW9tZXRyeSI6IHsiY29vcmRpbmF0ZXMiOiBbLTEwNS4xNjA4NzYsIDQwLjE3MDk5OF0sICJ0eXBlIjogIlBvaW50In0sICJpZCI6ICIzMCIsICJwcm9wZXJ0aWVzIjogeyJhbW91bnQiOiAiMC4zOCIsICJjb3VudHkiOiAiQk9VTERFUiIsICJkYXRhX3NvdXJjZSI6ICJDb29wZXJhdGl2ZSBQcm9ncmFtIG9mIENEV1IsIE5DV0NEICYgU1ZMSFdDRCIsICJkYXRlX3RpbWUiOiAiMjAxOC0xMC0yM1QxMDowMDowMCIsICJkaXYiOiAiMSIsICJkd3JfYWJicmV2IjogIlNGTERJVENPIiwgImhpZ2hsaWdodCI6IHt9LCAiaHR0cF9saW5rYWdlLnVybCI6ICJodHRwOi8vd3d3LmR3ci5zdGF0ZS5jby51cy9TdXJmYWNlV2F0ZXIvZGF0YS9kZXRhaWxfZ3JhcGguYXNweD9JRD1TRkxESVRDTyZNVFlQRT1ESVNDSFJHIiwgImxvY2F0aW9uLmxhdGl0dWRlIjogNDAuMTcwOTk4LCAibG9jYXRpb24ubG9uZ2l0dWRlIjogLTEwNS4xNjA4NzYsICJsb2NhdGlvbi5uZWVkc19yZWNvZGluZyI6IGZhbHNlLCAic3RhZ2UiOiAiMC4xMSIsICJzdGF0aW9uX25hbWUiOiAiU09VVEggRkxBVCBESVRDSCIsICJzdGF0aW9uX3N0YXR1cyI6ICJBY3RpdmUiLCAic3RhdGlvbl90eXBlIjogIkRpdmVyc2lvbiIsICJzdHlsZSI6IHt9LCAidXNnc19zdGF0aW9uX2lkIjogIlNGTERJVENPIiwgInZhcmlhYmxlIjogIkRJU0NIUkciLCAid2QiOiAiNSJ9LCAidHlwZSI6ICJGZWF0dXJlIn0sIHsiYmJveCI6IFstMTA1LjI1OTc5NSwgNDAuMjE5MDQ2LCAtMTA1LjI1OTc5NSwgNDAuMjE5MDQ2XSwgImdlb21ldHJ5IjogeyJjb29yZGluYXRlcyI6IFstMTA1LjI1OTc5NSwgNDAuMjE5MDQ2XSwgInR5cGUiOiAiUG9pbnQifSwgImlkIjogIjMxIiwgInByb3BlcnRpZXMiOiB7ImFtb3VudCI6ICIxNi45MyIsICJjb3VudHkiOiAiQk9VTERFUiIsICJkYXRhX3NvdXJjZSI6ICJDb29wZXJhdGl2ZSBQcm9ncmFtIG9mIENEV1IsIE5DV0NEICYgU1ZMSFdDRCIsICJkYXRlX3RpbWUiOiAiMjAxOC0xMS0yOFQwNzowMDowMCIsICJkaXYiOiAiMSIsICJkd3JfYWJicmV2IjogIlNVUERJVENPIiwgImhpZ2hsaWdodCI6IHt9LCAiaHR0cF9saW5rYWdlLnVybCI6ICJodHRwOi8vd3d3LmR3ci5zdGF0ZS5jby51cy9TdXJmYWNlV2F0ZXIvZGF0YS9kZXRhaWxfZ3JhcGguYXNweD9JRD1TVVBESVRDTyZNVFlQRT1ESVNDSFJHIiwgImxvY2F0aW9uLmxhdGl0dWRlIjogNDAuMjE5MDQ2LCAibG9jYXRpb24ubG9uZ2l0dWRlIjogLTEwNS4yNTk3OTUsICJsb2NhdGlvbi5uZWVkc19yZWNvZGluZyI6IGZhbHNlLCAic3RhZ2UiOiAiMC41OSIsICJzdGF0aW9uX25hbWUiOiAiU1VQUExZIERJVENIIiwgInN0YXRpb25fc3RhdHVzIjogIkFjdGl2ZSIsICJzdGF0aW9uX3R5cGUiOiAiRGl2ZXJzaW9uIiwgInN0eWxlIjoge30sICJ1c2dzX3N0YXRpb25faWQiOiAiU1VQRElUQ08iLCAidmFyaWFibGUiOiAiRElTQ0hSRyIsICJ3ZCI6ICI1In0sICJ0eXBlIjogIkZlYXR1cmUifSwgeyJiYm94IjogWy0xMDUuMjUwOTI3LCA0MC4yMTEwODMsIC0xMDUuMjUwOTI3LCA0MC4yMTEwODNdLCAiZ2VvbWV0cnkiOiB7ImNvb3JkaW5hdGVzIjogWy0xMDUuMjUwOTI3LCA0MC4yMTEwODNdLCAidHlwZSI6ICJQb2ludCJ9LCAiaWQiOiAiMzIiLCAicHJvcGVydGllcyI6IHsiYW1vdW50IjogIjAuMDAiLCAiY291bnR5IjogIkJPVUxERVIiLCAiZGF0YV9zb3VyY2UiOiAiQ29vcGVyYXRpdmUgUHJvZ3JhbSBvZiBDRFdSLCBOQ1dDRCAmIFNWTEhXQ0QiLCAiZGF0ZV90aW1lIjogIjIwMTgtMTEtMjhUMDc6MDA6MDAiLCAiZGl2IjogIjEiLCAiZHdyX2FiYnJldiI6ICJTV0VESVRDTyIsICJoaWdobGlnaHQiOiB7fSwgImh0dHBfbGlua2FnZS51cmwiOiAiaHR0cDovL3d3dy5kd3Iuc3RhdGUuY28udXMvU3VyZmFjZVdhdGVyL2RhdGEvZGV0YWlsX2dyYXBoLmFzcHg/SUQ9U1dFRElUQ08mTVRZUEU9RElTQ0hSRyIsICJsb2NhdGlvbi5sYXRpdHVkZSI6IDQwLjIxMTA4MywgImxvY2F0aW9uLmxvbmdpdHVkZSI6IC0xMDUuMjUwOTI3LCAibG9jYXRpb24ubmVlZHNfcmVjb2RpbmciOiBmYWxzZSwgInN0YWdlIjogIi0wLjAyIiwgInN0YXRpb25fbmFtZSI6ICJTV0VERSBESVRDSCIsICJzdGF0aW9uX3N0YXR1cyI6ICJBY3RpdmUiLCAic3RhdGlvbl90eXBlIjogIkRpdmVyc2lvbiIsICJzdHlsZSI6IHt9LCAidXNnc19zdGF0aW9uX2lkIjogbnVsbCwgInZhcmlhYmxlIjogIkRJU0NIUkciLCAid2QiOiAiNSJ9LCAidHlwZSI6ICJGZWF0dXJlIn0sIHsiYmJveCI6IFstMTA1LjIxMDM4ODAwMDAwMDAxLCA0MC4xOTMwMTksIC0xMDUuMjEwMzg4MDAwMDAwMDEsIDQwLjE5MzAxOV0sICJnZW9tZXRyeSI6IHsiY29vcmRpbmF0ZXMiOiBbLTEwNS4yMTAzODgwMDAwMDAwMSwgNDAuMTkzMDE5XSwgInR5cGUiOiAiUG9pbnQifSwgImlkIjogIjMzIiwgInByb3BlcnRpZXMiOiB7ImFtb3VudCI6ICIwLjAzIiwgImNvdW50eSI6ICJCT1VMREVSIiwgImRhdGFfc291cmNlIjogIkNvb3BlcmF0aXZlIFByb2dyYW0gb2YgQ0RXUiwgTkNXQ0QgJiBTVkxIV0NEIiwgImRhdGVfdGltZSI6ICIyMDE4LTExLTI4VDA3OjAwOjAwIiwgImRpdiI6ICIxIiwgImR3cl9hYmJyZXYiOiAiVFJVRElUQ08iLCAiaGlnaGxpZ2h0Ijoge30sICJodHRwX2xpbmthZ2UudXJsIjogImh0dHA6Ly93d3cuZHdyLnN0YXRlLmNvLnVzL1N1cmZhY2VXYXRlci9kYXRhL2RldGFpbF9ncmFwaC5hc3B4P0lEPVRSVURJVENPJk1UWVBFPURJU0NIUkciLCAibG9jYXRpb24ubGF0aXR1ZGUiOiA0MC4xOTMwMTksICJsb2NhdGlvbi5sb25naXR1ZGUiOiAtMTA1LjIxMDM4OCwgImxvY2F0aW9uLm5lZWRzX3JlY29kaW5nIjogZmFsc2UsICJzdGFnZSI6ICIwLjA0IiwgInN0YXRpb25fbmFtZSI6ICJUUlVFIEFORCBXRUJTVEVSIERJVENIIiwgInN0YXRpb25fc3RhdHVzIjogIkFjdGl2ZSIsICJzdGF0aW9uX3R5cGUiOiAiRGl2ZXJzaW9uIiwgInN0eWxlIjoge30sICJ1c2dzX3N0YXRpb25faWQiOiAiVFJVRElUQ08iLCAidmFyaWFibGUiOiAiRElTQ0hSRyIsICJ3ZCI6ICI1In0sICJ0eXBlIjogIkZlYXR1cmUifSwgeyJiYm94IjogWy0xMDUuMjEwNDI0LCA0MC4xOTMyODAwMDAwMDAwMSwgLTEwNS4yMTA0MjQsIDQwLjE5MzI4MDAwMDAwMDAxXSwgImdlb21ldHJ5IjogeyJjb29yZGluYXRlcyI6IFstMTA1LjIxMDQyNCwgNDAuMTkzMjgwMDAwMDAwMDFdLCAidHlwZSI6ICJQb2ludCJ9LCAiaWQiOiAiMzQiLCAicHJvcGVydGllcyI6IHsiYW1vdW50IjogIjAuMDEiLCAiY291bnR5IjogIkJPVUxERVIiLCAiZGF0YV9zb3VyY2UiOiAiQ29vcGVyYXRpdmUgUHJvZ3JhbSBvZiBDRFdSLCBOQ1dDRCAmIFNWTEhXQ0QiLCAiZGF0ZV90aW1lIjogIjIwMTgtMTEtMjhUMDc6MDA6MDAiLCAiZGl2IjogIjEiLCAiZHdyX2FiYnJldiI6ICJXRUJESVRDTyIsICJoaWdobGlnaHQiOiB7fSwgImh0dHBfbGlua2FnZS51cmwiOiAiaHR0cDovL3d3dy5kd3Iuc3RhdGUuY28udXMvU3VyZmFjZVdhdGVyL2RhdGEvZGV0YWlsX2dyYXBoLmFzcHg/SUQ9V0VCRElUQ08mTVRZUEU9RElTQ0hSRyIsICJsb2NhdGlvbi5sYXRpdHVkZSI6IDQwLjE5MzI4LCAibG9jYXRpb24ubG9uZ2l0dWRlIjogLTEwNS4yMTA0MjQsICJsb2NhdGlvbi5uZWVkc19yZWNvZGluZyI6IGZhbHNlLCAic3RhZ2UiOiAiMC4wMSIsICJzdGF0aW9uX25hbWUiOiAiV0VCU1RFUiBNQ0NBU0xJTiBESVRDSCIsICJzdGF0aW9uX3N0YXR1cyI6ICJBY3RpdmUiLCAic3RhdGlvbl90eXBlIjogIkRpdmVyc2lvbiIsICJzdHlsZSI6IHt9LCAidXNnc19zdGF0aW9uX2lkIjogIldFQkRJVENPIiwgInZhcmlhYmxlIjogIkRJU0NIUkciLCAid2QiOiAiNSJ9LCAidHlwZSI6ICJGZWF0dXJlIn0sIHsiYmJveCI6IFstMTA1LjE4NTc4OSwgNDAuMTg1MDMzLCAtMTA1LjE4NTc4OSwgNDAuMTg1MDMzXSwgImdlb21ldHJ5IjogeyJjb29yZGluYXRlcyI6IFstMTA1LjE4NTc4OSwgNDAuMTg1MDMzXSwgInR5cGUiOiAiUG9pbnQifSwgImlkIjogIjM1IiwgInByb3BlcnRpZXMiOiB7ImFtb3VudCI6ICIwLjEwIiwgImNvdW50eSI6ICJCT1VMREVSIiwgImRhdGFfc291cmNlIjogIkNvb3BlcmF0aXZlIFByb2dyYW0gb2YgQ0RXUiwgTkNXQ0QgJiBTVkxIV0NEIiwgImRhdGVfdGltZSI6ICIyMDE4LTExLTI4VDA3OjAwOjAwIiwgImRpdiI6ICIxIiwgImR3cl9hYmJyZXYiOiAiWldFVFVSQ08iLCAiaGlnaGxpZ2h0Ijoge30sICJodHRwX2xpbmthZ2UudXJsIjogImh0dHA6Ly93d3cuZHdyLnN0YXRlLmNvLnVzL1N1cmZhY2VXYXRlci9kYXRhL2RldGFpbF9ncmFwaC5hc3B4P0lEPVpXRVRVUkNPJk1UWVBFPURJU0NIUkciLCAibG9jYXRpb24ubGF0aXR1ZGUiOiA0MC4xODUwMzMsICJsb2NhdGlvbi5sb25naXR1ZGUiOiAtMTA1LjE4NTc4OSwgImxvY2F0aW9uLm5lZWRzX3JlY29kaW5nIjogZmFsc2UsICJzdGFnZSI6ICIwLjA0IiwgInN0YXRpb25fbmFtZSI6ICJaV0VDSyBBTkQgVFVSTkVSIERJVENIIiwgInN0YXRpb25fc3RhdHVzIjogIkFjdGl2ZSIsICJzdGF0aW9uX3R5cGUiOiAiRGl2ZXJzaW9uIiwgInN0eWxlIjoge30sICJ1c2dzX3N0YXRpb25faWQiOiAiWldFVFVSQ08iLCAidmFyaWFibGUiOiAiRElTQ0hSRyIsICJ3ZCI6ICI1In0sICJ0eXBlIjogIkZlYXR1cmUifSwgeyJiYm94IjogWy0xMDUuMDk3ODcyLCA0MC4wNTk4MDksIC0xMDUuMDk3ODcyLCA0MC4wNTk4MDldLCAiZ2VvbWV0cnkiOiB7ImNvb3JkaW5hdGVzIjogWy0xMDUuMDk3ODcyLCA0MC4wNTk4MDldLCAidHlwZSI6ICJQb2ludCJ9LCAiaWQiOiAiMzYiLCAicHJvcGVydGllcyI6IHsiYW1vdW50IjogIjQzLjUwIiwgImNvdW50eSI6ICJCT1VMREVSIiwgImRhdGFfc291cmNlIjogIkNvLiBEaXZpc2lvbiBvZiBXYXRlciBSZXNvdXJjZXMiLCAiZGF0ZV90aW1lIjogIjIwMTgtMTEtMjhUMDY6NDU6MDAiLCAiZGl2IjogIjEiLCAiZHdyX2FiYnJldiI6ICJCT0MxMDlDTyIsICJoaWdobGlnaHQiOiB7fSwgImh0dHBfbGlua2FnZS51cmwiOiAiaHR0cDovL3d3dy5kd3Iuc3RhdGUuY28udXMvU3VyZmFjZVdhdGVyL2RhdGEvZGV0YWlsX2dyYXBoLmFzcHg/SUQ9Qk9DMTA5Q08mTVRZUEU9RElTQ0hSRyIsICJsb2NhdGlvbi5sYXRpdHVkZSI6IDQwLjA1OTgwOSwgImxvY2F0aW9uLmxvbmdpdHVkZSI6IC0xMDUuMDk3ODcyLCAibG9jYXRpb24ubmVlZHNfcmVjb2RpbmciOiBmYWxzZSwgInN0YWdlIjogIjIuNDEiLCAic3RhdGlvbl9uYW1lIjogIkJPVUxERVIgQ1JFRUsgQVQgMTA5IFNUIE5FQVIgRVJJRSwgQ08iLCAic3RhdGlvbl9zdGF0dXMiOiAiQWN0aXZlIiwgInN0YXRpb25fdHlwZSI6ICJTdHJlYW0iLCAic3R5bGUiOiB7fSwgInVzZ3Nfc3RhdGlvbl9pZCI6ICJCT0MxMDlDTyIsICJ2YXJpYWJsZSI6ICJESVNDSFJHIiwgIndkIjogIjYifSwgInR5cGUiOiAiRmVhdHVyZSJ9LCB7ImJib3giOiBbLTEwNS4xNzg4NzUsIDQwLjA1MTY1MiwgLTEwNS4xNzg4NzUsIDQwLjA1MTY1Ml0sICJnZW9tZXRyeSI6IHsiY29vcmRpbmF0ZXMiOiBbLTEwNS4xNzg4NzUsIDQwLjA1MTY1Ml0sICJ0eXBlIjogIlBvaW50In0sICJpZCI6ICIzNyIsICJwcm9wZXJ0aWVzIjogeyJhbW91bnQiOiAiMjYuODAiLCAiY291bnR5IjogIkJPVUxERVIiLCAiZGF0YV9zb3VyY2UiOiAiVS5TLiBHZW9sb2dpY2FsIFN1cnZleSAoRGF0YSBQcm92aWRlcikiLCAiZGF0ZV90aW1lIjogIjIwMTgtMTEtMjhUMDc6MTU6MDAiLCAiZGl2IjogIjEiLCAiZHdyX2FiYnJldiI6ICJCT0NOT1JDTyIsICJoaWdobGlnaHQiOiB7fSwgImh0dHBfbGlua2FnZS51cmwiOiAiaHR0cDovL3dhdGVyZGF0YS51c2dzLmdvdi9ud2lzL3V2PzA2NzMwMjAwIiwgImxvY2F0aW9uLmxhdGl0dWRlIjogNDAuMDUxNjUyLCAibG9jYXRpb24ubG9uZ2l0dWRlIjogLTEwNS4xNzg4NzUsICJsb2NhdGlvbi5uZWVkc19yZWNvZGluZyI6IGZhbHNlLCAic3RhZ2UiOiBudWxsLCAic3RhdGlvbl9uYW1lIjogIkJPVUxERVIgQ1JFRUsgQVQgTk9SVEggNzVUSCBTVFJFRVQgTkVBUiBCT1VMREVSIiwgInN0YXRpb25fc3RhdHVzIjogIkFjdGl2ZSIsICJzdGF0aW9uX3R5cGUiOiAiU3RyZWFtIiwgInN0eWxlIjoge30sICJ1c2dzX3N0YXRpb25faWQiOiAiMDY3MzAyMDAiLCAidmFyaWFibGUiOiAiRElTQ0hSRyIsICJ3ZCI6ICI2In0sICJ0eXBlIjogIkZlYXR1cmUifSwgeyJiYm94IjogWy0xMDUuMTkzMDQ4LCA0MC4wNTMwMzUsIC0xMDUuMTkzMDQ4LCA0MC4wNTMwMzVdLCAiZ2VvbWV0cnkiOiB7ImNvb3JkaW5hdGVzIjogWy0xMDUuMTkzMDQ4LCA0MC4wNTMwMzVdLCAidHlwZSI6ICJQb2ludCJ9LCAiaWQiOiAiMzgiLCAicHJvcGVydGllcyI6IHsiYW1vdW50IjogIjAuOTkiLCAiY291bnR5IjogIkJPVUxERVIiLCAiZGF0YV9zb3VyY2UiOiAiTm9ydGhlcm4gQ29sb3JhZG8gV2F0ZXIgQ29uc2VydmFuY3kgRGlzdHJpY3QgKERhdGEgUHJvdmlkZXIpIiwgImRhdGVfdGltZSI6ICIyMDE4LTExLTAyVDA0OjAwOjAwIiwgImRpdiI6ICIxIiwgImR3cl9hYmJyZXYiOiAiQkNTQ0JDQ08iLCAiaGlnaGxpZ2h0Ijoge30sICJodHRwX2xpbmthZ2UudXJsIjogImh0dHA6Ly93d3cubm9ydGhlcm53YXRlci5vcmcvV2F0ZXJQcm9qZWN0cy9FYXN0U2xvcGVXYXRlckRhdGEuYXNweCIsICJsb2NhdGlvbi5sYXRpdHVkZSI6IDQwLjA1MzAzNSwgImxvY2F0aW9uLmxvbmdpdHVkZSI6IC0xMDUuMTkzMDQ4LCAibG9jYXRpb24ubmVlZHNfcmVjb2RpbmciOiBmYWxzZSwgInN0YWdlIjogIjAuMTAiLCAic3RhdGlvbl9uYW1lIjogIkJPVUxERVIgQ1JFRUsgU1VQUExZIENBTkFMIFRPIEJPVUxERVIgQ1JFRUsgTkVBUiBCT1VMREVSIiwgInN0YXRpb25fc3RhdHVzIjogIkFjdGl2ZSIsICJzdGF0aW9uX3R5cGUiOiAiRGl2ZXJzaW9uIiwgInN0eWxlIjoge30sICJ1c2dzX3N0YXRpb25faWQiOiAiRVMxOTE3IiwgInZhcmlhYmxlIjogIkRJU0NIUkciLCAid2QiOiAiNiJ9LCAidHlwZSI6ICJGZWF0dXJlIn0sIHsiYmJveCI6IFstMTA1LjIyMDQ5NywgNDAuMDc4NTYsIC0xMDUuMjIwNDk3LCA0MC4wNzg1Nl0sICJnZW9tZXRyeSI6IHsiY29vcmRpbmF0ZXMiOiBbLTEwNS4yMjA0OTcsIDQwLjA3ODU2XSwgInR5cGUiOiAiUG9pbnQifSwgImlkIjogIjM5IiwgInByb3BlcnRpZXMiOiB7ImFtb3VudCI6ICI3OTY3LjAwIiwgImNvdW50eSI6ICJCT1VMREVSIiwgImRhdGFfc291cmNlIjogIk5vcnRoZXJuIENvbG9yYWRvIFdhdGVyIENvbnNlcnZhbmN5IERpc3RyaWN0IChEYXRhIFByb3ZpZGVyKSIsICJkYXRlX3RpbWUiOiAiMjAxOC0xMS0yOFQwNzozMDowMCIsICJkaXYiOiAiMSIsICJkd3JfYWJicmV2IjogIkJPVVJFU0NPIiwgImhpZ2hsaWdodCI6IHt9LCAiaHR0cF9saW5rYWdlLnVybCI6ICJodHRwOi8vd3d3Lm5vcnRoZXJud2F0ZXIub3JnL1dhdGVyUHJvamVjdHMvRWFzdFNsb3BlV2F0ZXJEYXRhLmFzcHgiLCAibG9jYXRpb24ubGF0aXR1ZGUiOiA0MC4wNzg1NiwgImxvY2F0aW9uLmxvbmdpdHVkZSI6IC0xMDUuMjIwNDk3LCAibG9jYXRpb24ubmVlZHNfcmVjb2RpbmciOiBmYWxzZSwgInN0YWdlIjogbnVsbCwgInN0YXRpb25fbmFtZSI6ICJCT1VMREVSIFJFU0VSVk9JUiIsICJzdGF0aW9uX3N0YXR1cyI6ICJBY3RpdmUiLCAic3RhdGlvbl90eXBlIjogIlJlc2Vydm9pciIsICJzdHlsZSI6IHt9LCAidXNnc19zdGF0aW9uX2lkIjogIkVSMTkxNCIsICJ2YXJpYWJsZSI6ICJTVE9SQUdFIiwgIndkIjogIjYifSwgInR5cGUiOiAiRmVhdHVyZSJ9LCB7ImJib3giOiBbLTEwNS4yMTc1MTksIDQwLjA4NjI3OCwgLTEwNS4yMTc1MTksIDQwLjA4NjI3OF0sICJnZW9tZXRyeSI6IHsiY29vcmRpbmF0ZXMiOiBbLTEwNS4yMTc1MTksIDQwLjA4NjI3OF0sICJ0eXBlIjogIlBvaW50In0sICJpZCI6ICI0MCIsICJwcm9wZXJ0aWVzIjogeyJhbW91bnQiOiAiMS4zMCIsICJjb3VudHkiOiAiQk9VTERFUiIsICJkYXRhX3NvdXJjZSI6ICJOb3J0aGVybiBDb2xvcmFkbyBXYXRlciBDb25zZXJ2YW5jeSBEaXN0cmljdCAoRGF0YSBQcm92aWRlcikiLCAiZGF0ZV90aW1lIjogIjIwMTgtMTEtMTZUMTM6MDA6MDAiLCAiZGl2IjogIjEiLCAiZHdyX2FiYnJldiI6ICJCRkNJTkZDTyIsICJoaWdobGlnaHQiOiB7fSwgImh0dHBfbGlua2FnZS51cmwiOiAiaHR0cDovL3d3dy5ub3J0aGVybndhdGVyLm9yZy9XYXRlclByb2plY3RzL0Vhc3RTbG9wZVdhdGVyRGF0YS5hc3B4IiwgImxvY2F0aW9uLmxhdGl0dWRlIjogNDAuMDg2Mjc4LCAibG9jYXRpb24ubG9uZ2l0dWRlIjogLTEwNS4yMTc1MTksICJsb2NhdGlvbi5uZWVkc19yZWNvZGluZyI6IGZhbHNlLCAic3RhZ2UiOiAiMC4yMSIsICJzdGF0aW9uX25hbWUiOiAiQk9VTERFUiBSRVNFUlZPSVIgSU5MRVQiLCAic3RhdGlvbl9zdGF0dXMiOiAiQWN0aXZlIiwgInN0YXRpb25fdHlwZSI6ICJTdHJlYW0iLCAic3R5bGUiOiB7fSwgInVzZ3Nfc3RhdGlvbl9pZCI6ICJFUzE5MTYiLCAidmFyaWFibGUiOiAiRElTQ0hSRyIsICJ3ZCI6ICI2In0sICJ0eXBlIjogIkZlYXR1cmUifSwgeyJiYm94IjogWy0xMDUuMjE4Njc3LCAzOS45ODYxNjksIC0xMDUuMjE4Njc3LCAzOS45ODYxNjldLCAiZ2VvbWV0cnkiOiB7ImNvb3JkaW5hdGVzIjogWy0xMDUuMjE4Njc3LCAzOS45ODYxNjldLCAidHlwZSI6ICJQb2ludCJ9LCAiaWQiOiAiNDEiLCAicHJvcGVydGllcyI6IHsiYW1vdW50IjogIjIuNzYiLCAiY291bnR5IjogIkJPVUxERVIiLCAiZGF0YV9zb3VyY2UiOiAiQ29vcGVyYXRpdmUgUHJvZ3JhbSBvZiBDRFdSLCBOQ1dDRCAmIExTUFdDRCIsICJkYXRlX3RpbWUiOiAiMjAxOC0xMS0yN1QxMTowMDowMCIsICJkaXYiOiAiMSIsICJkd3JfYWJicmV2IjogIkRSWUNBUkNPIiwgImhpZ2hsaWdodCI6IHt9LCAiaHR0cF9saW5rYWdlLnVybCI6ICJodHRwOi8vd3d3LmR3ci5zdGF0ZS5jby51cy9TdXJmYWNlV2F0ZXIvZGF0YS9kZXRhaWxfZ3JhcGguYXNweD9JRD1EUllDQVJDTyZNVFlQRT1ESVNDSFJHIiwgImxvY2F0aW9uLmxhdGl0dWRlIjogMzkuOTg2MTY5LCAibG9jYXRpb24ubG9uZ2l0dWRlIjogLTEwNS4yMTg2NzcsICJsb2NhdGlvbi5uZWVkc19yZWNvZGluZyI6IGZhbHNlLCAic3RhZ2UiOiAiMC4xOSIsICJzdGF0aW9uX25hbWUiOiAiRFJZIENSRUVLIENBUlJJRVIiLCAic3RhdGlvbl9zdGF0dXMiOiAiQWN0aXZlIiwgInN0YXRpb25fdHlwZSI6ICJEaXZlcnNpb24iLCAic3R5bGUiOiB7fSwgInVzZ3Nfc3RhdGlvbl9pZCI6IG51bGwsICJ2YXJpYWJsZSI6ICJESVNDSFJHIiwgIndkIjogIjYifSwgInR5cGUiOiAiRmVhdHVyZSJ9LCB7ImJib3giOiBbLTEwNS4zNjQ5MTcwMDAwMDAwMiwgNDAuMDQyMDI4LCAtMTA1LjM2NDkxNzAwMDAwMDAyLCA0MC4wNDIwMjhdLCAiZ2VvbWV0cnkiOiB7ImNvb3JkaW5hdGVzIjogWy0xMDUuMzY0OTE3MDAwMDAwMDIsIDQwLjA0MjAyOF0sICJ0eXBlIjogIlBvaW50In0sICJpZCI6ICI0MiIsICJwcm9wZXJ0aWVzIjogeyJhbW91bnQiOiBudWxsLCAiY291bnR5IjogIkJPVUxERVIiLCAiZGF0YV9zb3VyY2UiOiAiVS5TLiBHZW9sb2dpY2FsIFN1cnZleSAoRGF0YSBQcm92aWRlcikiLCAiZGF0ZV90aW1lIjogIjE5OTktMDktMzBUMDA6MDA6MDAiLCAiZGl2IjogIjEiLCAiZHdyX2FiYnJldiI6ICJGUk1MTVJDTyIsICJoaWdobGlnaHQiOiB7fSwgImh0dHBfbGlua2FnZS51cmwiOiAiaHR0cDovL3dhdGVyZGF0YS51c2dzLmdvdi9ud2lzL3V2PzA2NzI3NDEwIiwgImxvY2F0aW9uLmxhdGl0dWRlIjogNDAuMDQyMDI4LCAibG9jYXRpb24ubG9uZ2l0dWRlIjogLTEwNS4zNjQ5MTcsICJsb2NhdGlvbi5uZWVkc19yZWNvZGluZyI6IGZhbHNlLCAic3RhZ2UiOiBudWxsLCAic3RhdGlvbl9uYW1lIjogIkZPVVIgTUlMRSBDUkVFSyBBVCBMT0dBTiBNSUxMIFJPQUQgTkVBUiBDUklTTUFOLCBDTyIsICJzdGF0aW9uX3N0YXR1cyI6ICJBY3RpdmUiLCAic3RhdGlvbl90eXBlIjogIlN0cmVhbSIsICJzdHlsZSI6IHt9LCAidXNnc19zdGF0aW9uX2lkIjogIjA2NzI3NDEwIiwgInZhcmlhYmxlIjogIkRJU0NIUkciLCAid2QiOiAiNiJ9LCAidHlwZSI6ICJGZWF0dXJlIn0sIHsiYmJveCI6IFstMTA1LjMyNjI1LCA0MC4wMTg2NjcsIC0xMDUuMzI2MjUsIDQwLjAxODY2N10sICJnZW9tZXRyeSI6IHsiY29vcmRpbmF0ZXMiOiBbLTEwNS4zMjYyNSwgNDAuMDE4NjY3XSwgInR5cGUiOiAiUG9pbnQifSwgImlkIjogIjQzIiwgInByb3BlcnRpZXMiOiB7ImFtb3VudCI6ICIwLjQ1IiwgImNvdW50eSI6ICJCT1VMREVSIiwgImRhdGFfc291cmNlIjogIlUuUy4gR2VvbG9naWNhbCBTdXJ2ZXkgKERhdGEgUHJvdmlkZXIpIiwgImRhdGVfdGltZSI6ICIyMDE4LTEwLTAxVDEzOjIwOjAwIiwgImRpdiI6ICIxIiwgImR3cl9hYmJyZXYiOiAiRk9VT1JPQ08iLCAiaGlnaGxpZ2h0Ijoge30sICJodHRwX2xpbmthZ2UudXJsIjogImh0dHA6Ly93YXRlcmRhdGEudXNncy5nb3Yvbndpcy91dj8wNjcyNzUwMCIsICJsb2NhdGlvbi5sYXRpdHVkZSI6IDQwLjAxODY2NywgImxvY2F0aW9uLmxvbmdpdHVkZSI6IC0xMDUuMzI2MjUsICJsb2NhdGlvbi5uZWVkc19yZWNvZGluZyI6IGZhbHNlLCAic3RhZ2UiOiBudWxsLCAic3RhdGlvbl9uYW1lIjogIkZPVVJNSUxFIENSRUVLIEFUIE9ST0RFTEwsIENPLiIsICJzdGF0aW9uX3N0YXR1cyI6ICJBY3RpdmUiLCAic3RhdGlvbl90eXBlIjogIlN0cmVhbSIsICJzdHlsZSI6IHt9LCAidXNnc19zdGF0aW9uX2lkIjogIjA2NzI3NTAwIiwgInZhcmlhYmxlIjogIkRJU0NIUkciLCAid2QiOiAiNiJ9LCAidHlwZSI6ICJGZWF0dXJlIn0sIHsiYmJveCI6IFstMTA1LjM1NzMwOCwgMzkuOTQ3NzA0LCAtMTA1LjM1NzMwOCwgMzkuOTQ3NzA0XSwgImdlb21ldHJ5IjogeyJjb29yZGluYXRlcyI6IFstMTA1LjM1NzMwOCwgMzkuOTQ3NzA0XSwgInR5cGUiOiAiUG9pbnQifSwgImlkIjogIjQ0IiwgInByb3BlcnRpZXMiOiB7ImFtb3VudCI6ICIzMDg1MS4wMCIsICJjb3VudHkiOiAiQk9VTERFUiIsICJkYXRhX3NvdXJjZSI6ICJDby4gRGl2aXNpb24gb2YgV2F0ZXIgUmVzb3VyY2VzIiwgImRhdGVfdGltZSI6ICIyMDE4LTExLTI4VDA3OjMwOjAwIiwgImRpdiI6ICIxIiwgImR3cl9hYmJyZXYiOiAiR1JPU1JFQ08iLCAiaGlnaGxpZ2h0Ijoge30sICJodHRwX2xpbmthZ2UudXJsIjogImh0dHA6Ly93d3cuZHdyLnN0YXRlLmNvLnVzL1N1cmZhY2VXYXRlci9kYXRhL2RldGFpbF9ncmFwaC5hc3B4P0lEPUdST1NSRUNPJk1UWVBFPVNUT1JBR0UiLCAibG9jYXRpb24ubGF0aXR1ZGUiOiAzOS45NDc3MDQsICJsb2NhdGlvbi5sb25naXR1ZGUiOiAtMTA1LjM1NzMwOCwgImxvY2F0aW9uLm5lZWRzX3JlY29kaW5nIjogZmFsc2UsICJzdGFnZSI6ICI3MjUzLjA0IiwgInN0YXRpb25fbmFtZSI6ICJHUk9TUyBSRVNFUlZPSVIgIiwgInN0YXRpb25fc3RhdHVzIjogIkFjdGl2ZSIsICJzdGF0aW9uX3R5cGUiOiAiUmVzZXJ2b2lyIiwgInN0eWxlIjoge30sICJ1c2dzX3N0YXRpb25faWQiOiAiR1JPU1JFQ08iLCAidmFyaWFibGUiOiAiU1RPUkFHRSIsICJ3ZCI6ICI2In0sICJ0eXBlIjogIkZlYXR1cmUifSwgeyJiYm94IjogWy0xMDUuMTUxMTQzLCA0MC4wNTM2NjEsIC0xMDUuMTUxMTQzLCA0MC4wNTM2NjFdLCAiZ2VvbWV0cnkiOiB7ImNvb3JkaW5hdGVzIjogWy0xMDUuMTUxMTQzLCA0MC4wNTM2NjFdLCAidHlwZSI6ICJQb2ludCJ9LCAiaWQiOiAiNDUiLCAicHJvcGVydGllcyI6IHsiYW1vdW50IjogIjAuMDAiLCAiY291bnR5IjogIkJPVUxERVIiLCAiZGF0YV9zb3VyY2UiOiAiQ29vcGVyYXRpdmUgUHJvZ3JhbSBvZiBDRFdSLCBOQ1dDRCAmIExTUFdDRCIsICJkYXRlX3RpbWUiOiAiMjAxOC0xMS0yOFQwNzowMDowMCIsICJkaXYiOiAiMSIsICJkd3JfYWJicmV2IjogIkxFR0RJVENPIiwgImhpZ2hsaWdodCI6IHt9LCAiaHR0cF9saW5rYWdlLnVybCI6ICJodHRwOi8vd3d3LmR3ci5zdGF0ZS5jby51cy9TdXJmYWNlV2F0ZXIvZGF0YS9kZXRhaWxfZ3JhcGguYXNweD9JRD1MRUdESVRDTyZNVFlQRT1ESVNDSFJHIiwgImxvY2F0aW9uLmxhdGl0dWRlIjogNDAuMDUzNjYxLCAibG9jYXRpb24ubG9uZ2l0dWRlIjogLTEwNS4xNTExNDMsICJsb2NhdGlvbi5uZWVkc19yZWNvZGluZyI6IGZhbHNlLCAic3RhZ2UiOiBudWxsLCAic3RhdGlvbl9uYW1lIjogIkxFR0dFVFQgRElUQ0giLCAic3RhdGlvbl9zdGF0dXMiOiAiQWN0aXZlIiwgInN0YXRpb25fdHlwZSI6ICJEaXZlcnNpb24iLCAic3R5bGUiOiB7fSwgInVzZ3Nfc3RhdGlvbl9pZCI6ICJMRUdESVRDTyIsICJ2YXJpYWJsZSI6ICJESVNDSFJHIiwgIndkIjogIjYifSwgInR5cGUiOiAiRmVhdHVyZSJ9LCB7ImJib3giOiBbLTEwNS41MDQ0NCwgMzkuOTYxNjU1LCAtMTA1LjUwNDQ0LCAzOS45NjE2NTVdLCAiZ2VvbWV0cnkiOiB7ImNvb3JkaW5hdGVzIjogWy0xMDUuNTA0NDQsIDM5Ljk2MTY1NV0sICJ0eXBlIjogIlBvaW50In0sICJpZCI6ICI0NiIsICJwcm9wZXJ0aWVzIjogeyJhbW91bnQiOiAiOC4xMCIsICJjb3VudHkiOiAiQk9VTERFUiIsICJkYXRhX3NvdXJjZSI6ICJDby4gRGl2aXNpb24gb2YgV2F0ZXIgUmVzb3VyY2VzIiwgImRhdGVfdGltZSI6ICIyMDE4LTExLTI4VDA3OjE1OjAwIiwgImRpdiI6ICIxIiwgImR3cl9hYmJyZXYiOiAiQk9DTUlEQ08iLCAiaGlnaGxpZ2h0Ijoge30sICJodHRwX2xpbmthZ2UudXJsIjogImh0dHA6Ly93d3cuZHdyLnN0YXRlLmNvLnVzL1N1cmZhY2VXYXRlci9kYXRhL2RldGFpbF9ncmFwaC5hc3B4P0lEPUJPQ01JRENPJk1UWVBFPURJU0NIUkciLCAibG9jYXRpb24ubGF0aXR1ZGUiOiAzOS45NjE2NTUsICJsb2NhdGlvbi5sb25naXR1ZGUiOiAtMTA1LjUwNDQ0LCAibG9jYXRpb24ubmVlZHNfcmVjb2RpbmciOiBmYWxzZSwgInN0YWdlIjogIjAuNTMiLCAic3RhdGlvbl9uYW1lIjogIk1JRERMRSBCT1VMREVSIENSRUVLIEFUIE5FREVSTEFORCIsICJzdGF0aW9uX3N0YXR1cyI6ICJBY3RpdmUiLCAic3RhdGlvbl90eXBlIjogIlN0cmVhbSIsICJzdHlsZSI6IHt9LCAidXNnc19zdGF0aW9uX2lkIjogIjA2NzI1NTAwIiwgInZhcmlhYmxlIjogIkRJU0NIUkciLCAid2QiOiAiNiJ9LCAidHlwZSI6ICJGZWF0dXJlIn0sIHsiYmJveCI6IFstMTA1LjM0NzkwNiwgMzkuOTM4MzUxLCAtMTA1LjM0NzkwNiwgMzkuOTM4MzUxXSwgImdlb21ldHJ5IjogeyJjb29yZGluYXRlcyI6IFstMTA1LjM0NzkwNiwgMzkuOTM4MzUxXSwgInR5cGUiOiAiUG9pbnQifSwgImlkIjogIjQ3IiwgInByb3BlcnRpZXMiOiB7ImFtb3VudCI6ICI4Mi45MCIsICJjb3VudHkiOiAiQk9VTERFUiIsICJkYXRhX3NvdXJjZSI6ICJDby4gRGl2aXNpb24gb2YgV2F0ZXIgUmVzb3VyY2VzIiwgImRhdGVfdGltZSI6ICIyMDE4LTExLTI4VDA3OjE1OjAwIiwgImRpdiI6ICIxIiwgImR3cl9hYmJyZXYiOiAiQk9DQkdSQ08iLCAiaGlnaGxpZ2h0Ijoge30sICJodHRwX2xpbmthZ2UudXJsIjogImh0dHA6Ly93d3cuZHdyLnN0YXRlLmNvLnVzL1N1cmZhY2VXYXRlci9kYXRhL2RldGFpbF9ncmFwaC5hc3B4P0lEPUJPQ0JHUkNPJk1UWVBFPURJU0NIUkciLCAibG9jYXRpb24ubGF0aXR1ZGUiOiAzOS45MzgzNTEsICJsb2NhdGlvbi5sb25naXR1ZGUiOiAtMTA1LjM0NzkwNiwgImxvY2F0aW9uLm5lZWRzX3JlY29kaW5nIjogZmFsc2UsICJzdGFnZSI6ICIwLjkyIiwgInN0YXRpb25fbmFtZSI6ICJTT1VUSCBCT1VMREVSIENSRUVLIEJFTE9XIEdST1NTIFJFU0VSVk9JUiIsICJzdGF0aW9uX3N0YXR1cyI6ICJBY3RpdmUiLCAic3RhdGlvbl90eXBlIjogIlN0cmVhbSIsICJzdHlsZSI6IHt9LCAidXNnc19zdGF0aW9uX2lkIjogIjA2NzI5NDUwIiwgInZhcmlhYmxlIjogIkRJU0NIUkciLCAid2QiOiAiNiJ9LCAidHlwZSI6ICJGZWF0dXJlIn0sIHsiYmJveCI6IFstMTA1LjMwODQzMiwgMzkuOTMxODEzLCAtMTA1LjMwODQzMiwgMzkuOTMxODEzXSwgImdlb21ldHJ5IjogeyJjb29yZGluYXRlcyI6IFstMTA1LjMwODQzMiwgMzkuOTMxODEzXSwgInR5cGUiOiAiUG9pbnQifSwgImlkIjogIjQ4IiwgInByb3BlcnRpZXMiOiB7ImFtb3VudCI6ICI3Ni4xMCIsICJjb3VudHkiOiAiQk9VTERFUiIsICJkYXRhX3NvdXJjZSI6ICJDby4gRGl2aXNpb24gb2YgV2F0ZXIgUmVzb3VyY2VzIiwgImRhdGVfdGltZSI6ICIyMDE4LTExLTI4VDA3OjMwOjAwIiwgImRpdiI6ICIxIiwgImR3cl9hYmJyZXYiOiAiQk9TREVMQ08iLCAiaGlnaGxpZ2h0Ijoge30sICJodHRwX2xpbmthZ2UudXJsIjogImh0dHA6Ly93d3cuZHdyLnN0YXRlLmNvLnVzL1N1cmZhY2VXYXRlci9kYXRhL2RldGFpbF9ncmFwaC5hc3B4P0lEPUJPU0RFTENPJk1UWVBFPURJU0NIUkciLCAibG9jYXRpb24ubGF0aXR1ZGUiOiAzOS45MzE4MTMsICJsb2NhdGlvbi5sb25naXR1ZGUiOiAtMTA1LjMwODQzMiwgImxvY2F0aW9uLm5lZWRzX3JlY29kaW5nIjogZmFsc2UsICJzdGFnZSI6ICIxLjM0IiwgInN0YXRpb25fbmFtZSI6ICJTT1VUSCBCT1VMREVSIENSRUVLIERJVkVSU0lPTiBORUFSIEVMRE9SQURPIFNQUklOR1MiLCAic3RhdGlvbl9zdGF0dXMiOiAiQWN0aXZlIiwgInN0YXRpb25fdHlwZSI6ICJEaXZlcnNpb24iLCAic3R5bGUiOiB7fSwgInVzZ3Nfc3RhdGlvbl9pZCI6IG51bGwsICJ2YXJpYWJsZSI6ICJESVNDSFJHIiwgIndkIjogIjYifSwgInR5cGUiOiAiRmVhdHVyZSJ9LCB7ImJib3giOiBbLTEwNS4zMDQ5OSwgMzkuOTMxNTk3LCAtMTA1LjMwNDk5LCAzOS45MzE1OTddLCAiZ2VvbWV0cnkiOiB7ImNvb3JkaW5hdGVzIjogWy0xMDUuMzA0OTksIDM5LjkzMTU5N10sICJ0eXBlIjogIlBvaW50In0sICJpZCI6ICI0OSIsICJwcm9wZXJ0aWVzIjogeyJhbW91bnQiOiAiMTAuNDAiLCAiY291bnR5IjogIkJPVUxERVIiLCAiZGF0YV9zb3VyY2UiOiAiQ28uIERpdmlzaW9uIG9mIFdhdGVyIFJlc291cmNlcyIsICJkYXRlX3RpbWUiOiAiMjAxOC0xMS0yOFQwNzoxNTowMCIsICJkaXYiOiAiMSIsICJkd3JfYWJicmV2IjogIkJPQ0VMU0NPIiwgImhpZ2hsaWdodCI6IHt9LCAiaHR0cF9saW5rYWdlLnVybCI6ICJodHRwOi8vd3d3LmR3ci5zdGF0ZS5jby51cy9TdXJmYWNlV2F0ZXIvZGF0YS9kZXRhaWxfZ3JhcGguYXNweD9JRD1CT0NFTFNDTyZNVFlQRT1ESVNDSFJHIiwgImxvY2F0aW9uLmxhdGl0dWRlIjogMzkuOTMxNTk3LCAibG9jYXRpb24ubG9uZ2l0dWRlIjogLTEwNS4zMDQ5OSwgImxvY2F0aW9uLm5lZWRzX3JlY29kaW5nIjogZmFsc2UsICJzdGFnZSI6ICIyLjEwIiwgInN0YXRpb25fbmFtZSI6ICJTT1VUSCBCT1VMREVSIENSRUVLIE5FQVIgRUxET1JBRE8gU1BSSU5HUyIsICJzdGF0aW9uX3N0YXR1cyI6ICJBY3RpdmUiLCAic3RhdGlvbl90eXBlIjogIlN0cmVhbSIsICJzdHlsZSI6IHt9LCAidXNnc19zdGF0aW9uX2lkIjogbnVsbCwgInZhcmlhYmxlIjogIkRJU0NIUkciLCAid2QiOiAiNiJ9LCAidHlwZSI6ICJGZWF0dXJlIn1dLCAidHlwZSI6ICJGZWF0dXJlQ29sbGVjdGlvbiJ9CiAgICAgICAgICAgIAogICAgICAgICAgICApLmFkZFRvKG1hcF81ODgyYTM3Nzc4NGE0NGI2ODYwYmRhZTAxMzFjOGRhZik7CiAgICAgICAgZ2VvX2pzb25fMmNhZjMwMTM2NDA0NDQ4Yjk1NTYxZmU0ZWQ0OTkzMGUuc2V0U3R5bGUoZnVuY3Rpb24oZmVhdHVyZSkge3JldHVybiBmZWF0dXJlLnByb3BlcnRpZXMuc3R5bGU7fSk7CiAgICAgICAgCjwvc2NyaXB0Pg==" style="position:absolute;width:100%;height:100%;left:0;top:0;border:none !important;" allowfullscreen webkitallowfullscreen mozallowfullscreen></iframe></div></div>





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



<div style="width:100%;"><div style="position:relative;width:100%;height:0;padding-bottom:60%;"><iframe src="data:text/html;charset=utf-8;base64,PCFET0NUWVBFIGh0bWw+CjxoZWFkPiAgICAKICAgIDxtZXRhIGh0dHAtZXF1aXY9ImNvbnRlbnQtdHlwZSIgY29udGVudD0idGV4dC9odG1sOyBjaGFyc2V0PVVURi04IiAvPgogICAgPHNjcmlwdD5MX1BSRUZFUl9DQU5WQVM9ZmFsc2U7IExfTk9fVE9VQ0g9ZmFsc2U7IExfRElTQUJMRV8zRD1mYWxzZTs8L3NjcmlwdD4KICAgIDxzY3JpcHQgc3JjPSJodHRwczovL2Nkbi5qc2RlbGl2ci5uZXQvbnBtL2xlYWZsZXRAMS4yLjAvZGlzdC9sZWFmbGV0LmpzIj48L3NjcmlwdD4KICAgIDxzY3JpcHQgc3JjPSJodHRwczovL2FqYXguZ29vZ2xlYXBpcy5jb20vYWpheC9saWJzL2pxdWVyeS8xLjExLjEvanF1ZXJ5Lm1pbi5qcyI+PC9zY3JpcHQ+CiAgICA8c2NyaXB0IHNyYz0iaHR0cHM6Ly9tYXhjZG4uYm9vdHN0cmFwY2RuLmNvbS9ib290c3RyYXAvMy4yLjAvanMvYm9vdHN0cmFwLm1pbi5qcyI+PC9zY3JpcHQ+CiAgICA8c2NyaXB0IHNyYz0iaHR0cHM6Ly9jZG5qcy5jbG91ZGZsYXJlLmNvbS9hamF4L2xpYnMvTGVhZmxldC5hd2Vzb21lLW1hcmtlcnMvMi4wLjIvbGVhZmxldC5hd2Vzb21lLW1hcmtlcnMuanMiPjwvc2NyaXB0PgogICAgPGxpbmsgcmVsPSJzdHlsZXNoZWV0IiBocmVmPSJodHRwczovL2Nkbi5qc2RlbGl2ci5uZXQvbnBtL2xlYWZsZXRAMS4yLjAvZGlzdC9sZWFmbGV0LmNzcyIvPgogICAgPGxpbmsgcmVsPSJzdHlsZXNoZWV0IiBocmVmPSJodHRwczovL21heGNkbi5ib290c3RyYXBjZG4uY29tL2Jvb3RzdHJhcC8zLjIuMC9jc3MvYm9vdHN0cmFwLm1pbi5jc3MiLz4KICAgIDxsaW5rIHJlbD0ic3R5bGVzaGVldCIgaHJlZj0iaHR0cHM6Ly9tYXhjZG4uYm9vdHN0cmFwY2RuLmNvbS9ib290c3RyYXAvMy4yLjAvY3NzL2Jvb3RzdHJhcC10aGVtZS5taW4uY3NzIi8+CiAgICA8bGluayByZWw9InN0eWxlc2hlZXQiIGhyZWY9Imh0dHBzOi8vbWF4Y2RuLmJvb3RzdHJhcGNkbi5jb20vZm9udC1hd2Vzb21lLzQuNi4zL2Nzcy9mb250LWF3ZXNvbWUubWluLmNzcyIvPgogICAgPGxpbmsgcmVsPSJzdHlsZXNoZWV0IiBocmVmPSJodHRwczovL2NkbmpzLmNsb3VkZmxhcmUuY29tL2FqYXgvbGlicy9MZWFmbGV0LmF3ZXNvbWUtbWFya2Vycy8yLjAuMi9sZWFmbGV0LmF3ZXNvbWUtbWFya2Vycy5jc3MiLz4KICAgIDxsaW5rIHJlbD0ic3R5bGVzaGVldCIgaHJlZj0iaHR0cHM6Ly9yYXdnaXQuY29tL3B5dGhvbi12aXN1YWxpemF0aW9uL2ZvbGl1bS9tYXN0ZXIvZm9saXVtL3RlbXBsYXRlcy9sZWFmbGV0LmF3ZXNvbWUucm90YXRlLmNzcyIvPgogICAgPHN0eWxlPmh0bWwsIGJvZHkge3dpZHRoOiAxMDAlO2hlaWdodDogMTAwJTttYXJnaW46IDA7cGFkZGluZzogMDt9PC9zdHlsZT4KICAgIDxzdHlsZT4jbWFwIHtwb3NpdGlvbjphYnNvbHV0ZTt0b3A6MDtib3R0b206MDtyaWdodDowO2xlZnQ6MDt9PC9zdHlsZT4KICAgIAogICAgPHN0eWxlPiNtYXBfMzQ2NmUzODE5MTBjNDc5MDliNWM3M2Y1ZDZmYzk2NzkgewogICAgICAgIHBvc2l0aW9uOiByZWxhdGl2ZTsKICAgICAgICB3aWR0aDogMTAwLjAlOwogICAgICAgIGhlaWdodDogMTAwLjAlOwogICAgICAgIGxlZnQ6IDAuMCU7CiAgICAgICAgdG9wOiAwLjAlOwogICAgICAgIH0KICAgIDwvc3R5bGU+CiAgICA8c2NyaXB0IHNyYz0iaHR0cHM6Ly9jZG5qcy5jbG91ZGZsYXJlLmNvbS9hamF4L2xpYnMvbGVhZmxldC5tYXJrZXJjbHVzdGVyLzEuMS4wL2xlYWZsZXQubWFya2VyY2x1c3Rlci5qcyI+PC9zY3JpcHQ+CiAgICA8bGluayByZWw9InN0eWxlc2hlZXQiIGhyZWY9Imh0dHBzOi8vY2RuanMuY2xvdWRmbGFyZS5jb20vYWpheC9saWJzL2xlYWZsZXQubWFya2VyY2x1c3Rlci8xLjEuMC9NYXJrZXJDbHVzdGVyLmNzcyIvPgogICAgPGxpbmsgcmVsPSJzdHlsZXNoZWV0IiBocmVmPSJodHRwczovL2NkbmpzLmNsb3VkZmxhcmUuY29tL2FqYXgvbGlicy9sZWFmbGV0Lm1hcmtlcmNsdXN0ZXIvMS4xLjAvTWFya2VyQ2x1c3Rlci5EZWZhdWx0LmNzcyIvPgo8L2hlYWQ+Cjxib2R5PiAgICAKICAgIAogICAgPGRpdiBjbGFzcz0iZm9saXVtLW1hcCIgaWQ9Im1hcF8zNDY2ZTM4MTkxMGM0NzkwOWI1YzczZjVkNmZjOTY3OSIgPjwvZGl2Pgo8L2JvZHk+CjxzY3JpcHQ+ICAgIAogICAgCiAgICAKICAgICAgICB2YXIgYm91bmRzID0gbnVsbDsKICAgIAoKICAgIHZhciBtYXBfMzQ2NmUzODE5MTBjNDc5MDliNWM3M2Y1ZDZmYzk2NzkgPSBMLm1hcCgKICAgICAgICAnbWFwXzM0NjZlMzgxOTEwYzQ3OTA5YjVjNzNmNWQ2ZmM5Njc5JywgewogICAgICAgIGNlbnRlcjogWzQwLjAxLCAtMTA1LjI3XSwKICAgICAgICB6b29tOiAxMCwKICAgICAgICBtYXhCb3VuZHM6IGJvdW5kcywKICAgICAgICBsYXllcnM6IFtdLAogICAgICAgIHdvcmxkQ29weUp1bXA6IGZhbHNlLAogICAgICAgIGNyczogTC5DUlMuRVBTRzM4NTcsCiAgICAgICAgem9vbUNvbnRyb2w6IHRydWUsCiAgICAgICAgfSk7CgogICAgCiAgICAKICAgIHZhciB0aWxlX2xheWVyXzlmNWM0N2NmYjhiNzQ2ZDU4NDNjZTFhOTI2NTQ2ODZlID0gTC50aWxlTGF5ZXIoCiAgICAgICAgJ2h0dHBzOi8vY2FydG9kYi1iYXNlbWFwcy17c30uZ2xvYmFsLnNzbC5mYXN0bHkubmV0L2xpZ2h0X2FsbC97en0ve3h9L3t5fS5wbmcnLAogICAgICAgIHsKICAgICAgICAiYXR0cmlidXRpb24iOiBudWxsLAogICAgICAgICJkZXRlY3RSZXRpbmEiOiBmYWxzZSwKICAgICAgICAibWF4TmF0aXZlWm9vbSI6IDE4LAogICAgICAgICJtYXhab29tIjogMTgsCiAgICAgICAgIm1pblpvb20iOiAwLAogICAgICAgICJub1dyYXAiOiBmYWxzZSwKICAgICAgICAic3ViZG9tYWlucyI6ICJhYmMiCn0pLmFkZFRvKG1hcF8zNDY2ZTM4MTkxMGM0NzkwOWI1YzczZjVkNmZjOTY3OSk7CiAgICAKICAgICAgICAgICAgdmFyIG1hcmtlcl9jbHVzdGVyX2RmMjlmMTY2OTA2ZDQ0YjE5NmUwOWRhOWFjM2U0MjIyID0gTC5tYXJrZXJDbHVzdGVyR3JvdXAoe30pOwogICAgICAgICAgICBtYXBfMzQ2NmUzODE5MTBjNDc5MDliNWM3M2Y1ZDZmYzk2NzkuYWRkTGF5ZXIobWFya2VyX2NsdXN0ZXJfZGYyOWYxNjY5MDZkNDRiMTk2ZTA5ZGE5YWMzZTQyMjIpOwogICAgICAgICAgICAKICAgIAogICAgICAgIHZhciBtYXJrZXJfNTQxYmE2YWRmMjk3NGExZjhjMmNlMTNiNmQ3NTk1YTcgPSBMLm1hcmtlcigKICAgICAgICAgICAgWzQwLjI1Nzg0NCwgLTEwNS4xNjQzOTddLAogICAgICAgICAgICB7CiAgICAgICAgICAgICAgICBpY29uOiBuZXcgTC5JY29uLkRlZmF1bHQoKQogICAgICAgICAgICAgICAgfQogICAgICAgICAgICApLmFkZFRvKG1hcmtlcl9jbHVzdGVyX2RmMjlmMTY2OTA2ZDQ0YjE5NmUwOWRhOWFjM2U0MjIyKTsKICAgICAgICAKICAgIAogICAgICAgICAgICB2YXIgcG9wdXBfYmYyYTlmNDQ1ZjVmNGY4OTljOTAxNTE4NmEzN2M3MmQgPSBMLnBvcHVwKHttYXhXaWR0aDogJzMwMCcKICAgICAgICAgICAgCiAgICAgICAgICAgIH0pOwoKICAgICAgICAgICAgCiAgICAgICAgICAgICAgICB2YXIgaHRtbF81ZWM4ODk0YzRhN2Y0MWIzOTYyZTE2OWZiNDMzOWJiNCA9ICQoJzxkaXYgaWQ9Imh0bWxfNWVjODg5NGM0YTdmNDFiMzk2MmUxNjlmYjQzMzliYjQiIHN0eWxlPSJ3aWR0aDogMTAwLjAlOyBoZWlnaHQ6IDEwMC4wJTsiPk5hbWU6IEJMT1dFUiBESVRDSCBQcmVjaXA6IDAuMDA8L2Rpdj4nKVswXTsKICAgICAgICAgICAgICAgIHBvcHVwX2JmMmE5ZjQ0NWY1ZjRmODk5YzkwMTUxODZhMzdjNzJkLnNldENvbnRlbnQoaHRtbF81ZWM4ODk0YzRhN2Y0MWIzOTYyZTE2OWZiNDMzOWJiNCk7CiAgICAgICAgICAgIAoKICAgICAgICAgICAgbWFya2VyXzU0MWJhNmFkZjI5NzRhMWY4YzJjZTEzYjZkNzU5NWE3LmJpbmRQb3B1cChwb3B1cF9iZjJhOWY0NDVmNWY0Zjg5OWM5MDE1MTg2YTM3YzcyZCkKICAgICAgICAgICAgOwoKICAgICAgICAgICAgCiAgICAgICAgCiAgICAKICAgICAgICB2YXIgbWFya2VyXzA4YmYwYTdmYmQzMTQyYzZiOTQ4MmY1ZjI5NTdiOGZjID0gTC5tYXJrZXIoCiAgICAgICAgICAgIFs0MC4yNTg3MjYsIC0xMDUuMTc1ODE3XSwKICAgICAgICAgICAgewogICAgICAgICAgICAgICAgaWNvbjogbmV3IEwuSWNvbi5EZWZhdWx0KCkKICAgICAgICAgICAgICAgIH0KICAgICAgICAgICAgKS5hZGRUbyhtYXJrZXJfY2x1c3Rlcl9kZjI5ZjE2NjkwNmQ0NGIxOTZlMDlkYTlhYzNlNDIyMik7CiAgICAgICAgCiAgICAKICAgICAgICAgICAgdmFyIHBvcHVwXzExZWM4Njg2MGZmMjRhOWFhM2MwYzgzZGJhOGM4NmFlID0gTC5wb3B1cCh7bWF4V2lkdGg6ICczMDAnCiAgICAgICAgICAgIAogICAgICAgICAgICB9KTsKCiAgICAgICAgICAgIAogICAgICAgICAgICAgICAgdmFyIGh0bWxfZDRlZjI2NGQ2NTgxNGIyOGJmYzgxYWVlMGNlNzU3ODQgPSAkKCc8ZGl2IGlkPSJodG1sX2Q0ZWYyNjRkNjU4MTRiMjhiZmM4MWFlZTBjZTc1Nzg0IiBzdHlsZT0id2lkdGg6IDEwMC4wJTsgaGVpZ2h0OiAxMDAuMCU7Ij5OYW1lOiBCT1VMREVSLUxBUklNRVIgQllQQVNTIE5FQVIgQkVSVEhPVUQgUHJlY2lwOiAwLjgwPC9kaXY+JylbMF07CiAgICAgICAgICAgICAgICBwb3B1cF8xMWVjODY4NjBmZjI0YTlhYTNjMGM4M2RiYThjODZhZS5zZXRDb250ZW50KGh0bWxfZDRlZjI2NGQ2NTgxNGIyOGJmYzgxYWVlMGNlNzU3ODQpOwogICAgICAgICAgICAKCiAgICAgICAgICAgIG1hcmtlcl8wOGJmMGE3ZmJkMzE0MmM2Yjk0ODJmNWYyOTU3YjhmYy5iaW5kUG9wdXAocG9wdXBfMTFlYzg2ODYwZmYyNGE5YWEzYzBjODNkYmE4Yzg2YWUpCiAgICAgICAgICAgIDsKCiAgICAgICAgICAgIAogICAgICAgIAogICAgCiAgICAgICAgdmFyIG1hcmtlcl85MTZmMThlOTZiMGI0MmZkYTkxN2NjNGZjYWY4ZDBlYiA9IEwubWFya2VyKAogICAgICAgICAgICBbNDAuMjU4MzY3LCAtMTA1LjE3NDk1N10sCiAgICAgICAgICAgIHsKICAgICAgICAgICAgICAgIGljb246IG5ldyBMLkljb24uRGVmYXVsdCgpCiAgICAgICAgICAgICAgICB9CiAgICAgICAgICAgICkuYWRkVG8obWFya2VyX2NsdXN0ZXJfZGYyOWYxNjY5MDZkNDRiMTk2ZTA5ZGE5YWMzZTQyMjIpOwogICAgICAgIAogICAgCiAgICAgICAgICAgIHZhciBwb3B1cF8wM2U5ZjdlNTVlZWM0OWJmODdlMTNkNWE1MjRiOWIyNiA9IEwucG9wdXAoe21heFdpZHRoOiAnMzAwJwogICAgICAgICAgICAKICAgICAgICAgICAgfSk7CgogICAgICAgICAgICAKICAgICAgICAgICAgICAgIHZhciBodG1sXzIxODNhZTBmOTY5NTRjYTk5M2Y3OTJhZmQyYWI4MWEzID0gJCgnPGRpdiBpZD0iaHRtbF8yMTgzYWUwZjk2OTU0Y2E5OTNmNzkyYWZkMmFiODFhMyIgc3R5bGU9IndpZHRoOiAxMDAuMCU7IGhlaWdodDogMTAwLjAlOyI+TmFtZTogQk9VTERFUi1MQVJJTUVSIERJVENIIE5FQVIgQkVSVEhPVUQgUHJlY2lwOiAwLjAwPC9kaXY+JylbMF07CiAgICAgICAgICAgICAgICBwb3B1cF8wM2U5ZjdlNTVlZWM0OWJmODdlMTNkNWE1MjRiOWIyNi5zZXRDb250ZW50KGh0bWxfMjE4M2FlMGY5Njk1NGNhOTkzZjc5MmFmZDJhYjgxYTMpOwogICAgICAgICAgICAKCiAgICAgICAgICAgIG1hcmtlcl85MTZmMThlOTZiMGI0MmZkYTkxN2NjNGZjYWY4ZDBlYi5iaW5kUG9wdXAocG9wdXBfMDNlOWY3ZTU1ZWVjNDliZjg3ZTEzZDVhNTI0YjliMjYpCiAgICAgICAgICAgIDsKCiAgICAgICAgICAgIAogICAgICAgIAogICAgCiAgICAgICAgdmFyIG1hcmtlcl8xZGI4NWFjNDM4MzA0MTM4ODJjNTQxMzBkMWNjMjA0OSA9IEwubWFya2VyKAogICAgICAgICAgICBbNDAuMjYwODI3LCAtMTA1LjE5ODU2N10sCiAgICAgICAgICAgIHsKICAgICAgICAgICAgICAgIGljb246IG5ldyBMLkljb24uRGVmYXVsdCgpCiAgICAgICAgICAgICAgICB9CiAgICAgICAgICAgICkuYWRkVG8obWFya2VyX2NsdXN0ZXJfZGYyOWYxNjY5MDZkNDRiMTk2ZTA5ZGE5YWMzZTQyMjIpOwogICAgICAgIAogICAgCiAgICAgICAgICAgIHZhciBwb3B1cF85NDhjNzU5MTZkZDI0Y2EwODQ5ZjU3MTYxY2FiZTFjMSA9IEwucG9wdXAoe21heFdpZHRoOiAnMzAwJwogICAgICAgICAgICAKICAgICAgICAgICAgfSk7CgogICAgICAgICAgICAKICAgICAgICAgICAgICAgIHZhciBodG1sXzZiM2U5ZTM4NDZkMjQ5ZmFhMzI5Mzg0NGE3ODU3N2IyID0gJCgnPGRpdiBpZD0iaHRtbF82YjNlOWUzODQ2ZDI0OWZhYTMyOTM4NDRhNzg1NzdiMiIgc3R5bGU9IndpZHRoOiAxMDAuMCU7IGhlaWdodDogMTAwLjAlOyI+TmFtZTogQ1VMVkVSIERJVENIIFByZWNpcDogMC4wMDwvZGl2PicpWzBdOwogICAgICAgICAgICAgICAgcG9wdXBfOTQ4Yzc1OTE2ZGQyNGNhMDg0OWY1NzE2MWNhYmUxYzEuc2V0Q29udGVudChodG1sXzZiM2U5ZTM4NDZkMjQ5ZmFhMzI5Mzg0NGE3ODU3N2IyKTsKICAgICAgICAgICAgCgogICAgICAgICAgICBtYXJrZXJfMWRiODVhYzQzODMwNDEzODgyYzU0MTMwZDFjYzIwNDkuYmluZFBvcHVwKHBvcHVwXzk0OGM3NTkxNmRkMjRjYTA4NDlmNTcxNjFjYWJlMWMxKQogICAgICAgICAgICA7CgogICAgICAgICAgICAKICAgICAgICAKICAgIAogICAgICAgIHZhciBtYXJrZXJfNGJhNDhmYmE0MzI2NGNhNzliYzUzN2NiNzQ2MDMxMWIgPSBMLm1hcmtlcigKICAgICAgICAgICAgWzQwLjI1NjI3NiwgLTEwNS4yMDk0MTZdLAogICAgICAgICAgICB7CiAgICAgICAgICAgICAgICBpY29uOiBuZXcgTC5JY29uLkRlZmF1bHQoKQogICAgICAgICAgICAgICAgfQogICAgICAgICAgICApLmFkZFRvKG1hcmtlcl9jbHVzdGVyX2RmMjlmMTY2OTA2ZDQ0YjE5NmUwOWRhOWFjM2U0MjIyKTsKICAgICAgICAKICAgIAogICAgICAgICAgICB2YXIgcG9wdXBfNzhjNGUzMjU3NTI1NDQ4NWIyOTQ3NjcyOWFlNzNjZDIgPSBMLnBvcHVwKHttYXhXaWR0aDogJzMwMCcKICAgICAgICAgICAgCiAgICAgICAgICAgIH0pOwoKICAgICAgICAgICAgCiAgICAgICAgICAgICAgICB2YXIgaHRtbF83Y2I5YzI0M2ZlY2U0MTM3YjA4MzhmZDJhOWIwOTYyYSA9ICQoJzxkaXYgaWQ9Imh0bWxfN2NiOWMyNDNmZWNlNDEzN2IwODM4ZmQyYTliMDk2MmEiIHN0eWxlPSJ3aWR0aDogMTAwLjAlOyBoZWlnaHQ6IDEwMC4wJTsiPk5hbWU6IExJVFRMRSBUSE9NUFNPTiAjMSBESVRDSCBQcmVjaXA6IDE1LjUwPC9kaXY+JylbMF07CiAgICAgICAgICAgICAgICBwb3B1cF83OGM0ZTMyNTc1MjU0NDg1YjI5NDc2NzI5YWU3M2NkMi5zZXRDb250ZW50KGh0bWxfN2NiOWMyNDNmZWNlNDEzN2IwODM4ZmQyYTliMDk2MmEpOwogICAgICAgICAgICAKCiAgICAgICAgICAgIG1hcmtlcl80YmE0OGZiYTQzMjY0Y2E3OWJjNTM3Y2I3NDYwMzExYi5iaW5kUG9wdXAocG9wdXBfNzhjNGUzMjU3NTI1NDQ4NWIyOTQ3NjcyOWFlNzNjZDIpCiAgICAgICAgICAgIDsKCiAgICAgICAgICAgIAogICAgICAgIAogICAgCiAgICAgICAgdmFyIG1hcmtlcl9jNmE4ZWZkODRlNWE0ZTQ4YTVkYThmMDI0M2U3OGIwMCA9IEwubWFya2VyKAogICAgICAgICAgICBbNDAuMjU1Nzc2LCAtMTA1LjIwOTVdLAogICAgICAgICAgICB7CiAgICAgICAgICAgICAgICBpY29uOiBuZXcgTC5JY29uLkRlZmF1bHQoKQogICAgICAgICAgICAgICAgfQogICAgICAgICAgICApLmFkZFRvKG1hcmtlcl9jbHVzdGVyX2RmMjlmMTY2OTA2ZDQ0YjE5NmUwOWRhOWFjM2U0MjIyKTsKICAgICAgICAKICAgIAogICAgICAgICAgICB2YXIgcG9wdXBfOTNhZTgwZjhhZmIzNDVhYTgxMTU3MGMyNTFiOWFkYTIgPSBMLnBvcHVwKHttYXhXaWR0aDogJzMwMCcKICAgICAgICAgICAgCiAgICAgICAgICAgIH0pOwoKICAgICAgICAgICAgCiAgICAgICAgICAgICAgICB2YXIgaHRtbF9mNGNjYzlmNmIzZjU0NTViYjIxODdiMjM3ZDI1NzJmMSA9ICQoJzxkaXYgaWQ9Imh0bWxfZjRjY2M5ZjZiM2Y1NDU1YmIyMTg3YjIzN2QyNTcyZjEiIHN0eWxlPSJ3aWR0aDogMTAwLjAlOyBoZWlnaHQ6IDEwMC4wJTsiPk5hbWU6IExJVFRMRSBUSE9NUFNPTiAjMiBESVRDSCBQcmVjaXA6IDAuMDA8L2Rpdj4nKVswXTsKICAgICAgICAgICAgICAgIHBvcHVwXzkzYWU4MGY4YWZiMzQ1YWE4MTE1NzBjMjUxYjlhZGEyLnNldENvbnRlbnQoaHRtbF9mNGNjYzlmNmIzZjU0NTViYjIxODdiMjM3ZDI1NzJmMSk7CiAgICAgICAgICAgIAoKICAgICAgICAgICAgbWFya2VyX2M2YThlZmQ4NGU1YTRlNDhhNWRhOGYwMjQzZTc4YjAwLmJpbmRQb3B1cChwb3B1cF85M2FlODBmOGFmYjM0NWFhODExNTcwYzI1MWI5YWRhMikKICAgICAgICAgICAgOwoKICAgICAgICAgICAgCiAgICAgICAgCiAgICAKICAgICAgICB2YXIgbWFya2VyX2VlYzUwZGZiZWFiYzRiMmNiMTFlNTllN2IyNmUwOTBlID0gTC5tYXJrZXIoCiAgICAgICAgICAgIFs0MC4yNTgwMzgsIC0xMDUuMjA2Mzg2XSwKICAgICAgICAgICAgewogICAgICAgICAgICAgICAgaWNvbjogbmV3IEwuSWNvbi5EZWZhdWx0KCkKICAgICAgICAgICAgICAgIH0KICAgICAgICAgICAgKS5hZGRUbyhtYXJrZXJfY2x1c3Rlcl9kZjI5ZjE2NjkwNmQ0NGIxOTZlMDlkYTlhYzNlNDIyMik7CiAgICAgICAgCiAgICAKICAgICAgICAgICAgdmFyIHBvcHVwXzEzZWE1NGE0MjMzOTQzMTBiNjRhYTVmY2E5NjEyNTE1ID0gTC5wb3B1cCh7bWF4V2lkdGg6ICczMDAnCiAgICAgICAgICAgIAogICAgICAgICAgICB9KTsKCiAgICAgICAgICAgIAogICAgICAgICAgICAgICAgdmFyIGh0bWxfZWFiM2E5ZDA1MTkwNGRhOTljZTE0NzhkZDJkNDQ4N2EgPSAkKCc8ZGl2IGlkPSJodG1sX2VhYjNhOWQwNTE5MDRkYTk5Y2UxNDc4ZGQyZDQ0ODdhIiBzdHlsZT0id2lkdGg6IDEwMC4wJTsgaGVpZ2h0OiAxMDAuMCU7Ij5OYW1lOiBMSVRUTEUgVEhPTVBTT04gUklWRVIgQVQgQ0FOWU9OIE1PVVRIIE5FQVIgQkVSVEhPVUQgUHJlY2lwOiAwLjQxPC9kaXY+JylbMF07CiAgICAgICAgICAgICAgICBwb3B1cF8xM2VhNTRhNDIzMzk0MzEwYjY0YWE1ZmNhOTYxMjUxNS5zZXRDb250ZW50KGh0bWxfZWFiM2E5ZDA1MTkwNGRhOTljZTE0NzhkZDJkNDQ4N2EpOwogICAgICAgICAgICAKCiAgICAgICAgICAgIG1hcmtlcl9lZWM1MGRmYmVhYmM0YjJjYjExZTU5ZTdiMjZlMDkwZS5iaW5kUG9wdXAocG9wdXBfMTNlYTU0YTQyMzM5NDMxMGI2NGFhNWZjYTk2MTI1MTUpCiAgICAgICAgICAgIDsKCiAgICAgICAgICAgIAogICAgICAgIAogICAgCiAgICAgICAgdmFyIG1hcmtlcl9hMzFkNGE2ZjBhN2Q0MTdiYjMzNGY2ZDNiZjhlNmUwYiA9IEwubWFya2VyKAogICAgICAgICAgICBbNDAuMTUzMzYzLCAtMTA1LjA4ODY5NV0sCiAgICAgICAgICAgIHsKICAgICAgICAgICAgICAgIGljb246IG5ldyBMLkljb24uRGVmYXVsdCgpCiAgICAgICAgICAgICAgICB9CiAgICAgICAgICAgICkuYWRkVG8obWFya2VyX2NsdXN0ZXJfZGYyOWYxNjY5MDZkNDRiMTk2ZTA5ZGE5YWMzZTQyMjIpOwogICAgICAgIAogICAgCiAgICAgICAgICAgIHZhciBwb3B1cF81ZGZlNTAwM2UzMDM0MWU0OGI4NzZlYmExNzc3ZWU4OSA9IEwucG9wdXAoe21heFdpZHRoOiAnMzAwJwogICAgICAgICAgICAKICAgICAgICAgICAgfSk7CgogICAgICAgICAgICAKICAgICAgICAgICAgICAgIHZhciBodG1sX2FkZWJhZmQ1Yzg4YTQ2ZTFhYmIyZWE0M2QxNmVkMWMzID0gJCgnPGRpdiBpZD0iaHRtbF9hZGViYWZkNWM4OGE0NmUxYWJiMmVhNDNkMTZlZDFjMyIgc3R5bGU9IndpZHRoOiAxMDAuMCU7IGhlaWdodDogMTAwLjAlOyI+TmFtZTogQk9OVVMgRElUQ0ggUHJlY2lwOiAwLjAwPC9kaXY+JylbMF07CiAgICAgICAgICAgICAgICBwb3B1cF81ZGZlNTAwM2UzMDM0MWU0OGI4NzZlYmExNzc3ZWU4OS5zZXRDb250ZW50KGh0bWxfYWRlYmFmZDVjODhhNDZlMWFiYjJlYTQzZDE2ZWQxYzMpOwogICAgICAgICAgICAKCiAgICAgICAgICAgIG1hcmtlcl9hMzFkNGE2ZjBhN2Q0MTdiYjMzNGY2ZDNiZjhlNmUwYi5iaW5kUG9wdXAocG9wdXBfNWRmZTUwMDNlMzAzNDFlNDhiODc2ZWJhMTc3N2VlODkpCiAgICAgICAgICAgIDsKCiAgICAgICAgICAgIAogICAgICAgIAogICAgCiAgICAgICAgdmFyIG1hcmtlcl9hNjUzZmFkNWI5Zjc0NGNjOGNhMDMxZWQ4NzE1YjU1MiA9IEwubWFya2VyKAogICAgICAgICAgICBbNDAuMjE2MjYzLCAtMTA1LjM2NTM2NV0sCiAgICAgICAgICAgIHsKICAgICAgICAgICAgICAgIGljb246IG5ldyBMLkljb24uRGVmYXVsdCgpCiAgICAgICAgICAgICAgICB9CiAgICAgICAgICAgICkuYWRkVG8obWFya2VyX2NsdXN0ZXJfZGYyOWYxNjY5MDZkNDRiMTk2ZTA5ZGE5YWMzZTQyMjIpOwogICAgICAgIAogICAgCiAgICAgICAgICAgIHZhciBwb3B1cF9iMjgwYjg0YmQ1ZGU0NTkwOTllMzM3YTk3N2E5YzA0NyA9IEwucG9wdXAoe21heFdpZHRoOiAnMzAwJwogICAgICAgICAgICAKICAgICAgICAgICAgfSk7CgogICAgICAgICAgICAKICAgICAgICAgICAgICAgIHZhciBodG1sXzE2YWU4YzljYTU4MjQ5NmNhYmYyZGVjZDAxOGQxMWMwID0gJCgnPGRpdiBpZD0iaHRtbF8xNmFlOGM5Y2E1ODI0OTZjYWJmMmRlY2QwMThkMTFjMCIgc3R5bGU9IndpZHRoOiAxMDAuMCU7IGhlaWdodDogMTAwLjAlOyI+TmFtZTogQlVUVE9OUk9DSyAoUkFMUEggUFJJQ0UpIFJFU0VSVk9JUiBQcmVjaXA6IDE0MDkzLjAwPC9kaXY+JylbMF07CiAgICAgICAgICAgICAgICBwb3B1cF9iMjgwYjg0YmQ1ZGU0NTkwOTllMzM3YTk3N2E5YzA0Ny5zZXRDb250ZW50KGh0bWxfMTZhZThjOWNhNTgyNDk2Y2FiZjJkZWNkMDE4ZDExYzApOwogICAgICAgICAgICAKCiAgICAgICAgICAgIG1hcmtlcl9hNjUzZmFkNWI5Zjc0NGNjOGNhMDMxZWQ4NzE1YjU1Mi5iaW5kUG9wdXAocG9wdXBfYjI4MGI4NGJkNWRlNDU5MDk5ZTMzN2E5NzdhOWMwNDcpCiAgICAgICAgICAgIDsKCiAgICAgICAgICAgIAogICAgICAgIAogICAgCiAgICAgICAgdmFyIG1hcmtlcl84ODRkOTA3NDkwNmE0ZGU4OTljMTJiN2RlNzZlNGJjOCA9IEwubWFya2VyKAogICAgICAgICAgICBbNDAuMTkzNzU4LCAtMTA1LjIxMDM5XSwKICAgICAgICAgICAgewogICAgICAgICAgICAgICAgaWNvbjogbmV3IEwuSWNvbi5EZWZhdWx0KCkKICAgICAgICAgICAgICAgIH0KICAgICAgICAgICAgKS5hZGRUbyhtYXJrZXJfY2x1c3Rlcl9kZjI5ZjE2NjkwNmQ0NGIxOTZlMDlkYTlhYzNlNDIyMik7CiAgICAgICAgCiAgICAKICAgICAgICAgICAgdmFyIHBvcHVwXzk3NWZmYTkxMjEyYjRmN2FhNjZhNGMyNzA2NjExMTI1ID0gTC5wb3B1cCh7bWF4V2lkdGg6ICczMDAnCiAgICAgICAgICAgIAogICAgICAgICAgICB9KTsKCiAgICAgICAgICAgIAogICAgICAgICAgICAgICAgdmFyIGh0bWxfYTVhZWQwMWI5YTY2NDQyYzlkYTM3MDYwNTE2ZjM0ZWMgPSAkKCc8ZGl2IGlkPSJodG1sX2E1YWVkMDFiOWE2NjQ0MmM5ZGEzNzA2MDUxNmYzNGVjIiBzdHlsZT0id2lkdGg6IDEwMC4wJTsgaGVpZ2h0OiAxMDAuMCU7Ij5OYW1lOiBDTE9VR0ggQU5EIFRSVUUgRElUQ0ggUHJlY2lwOiAwLjAwPC9kaXY+JylbMF07CiAgICAgICAgICAgICAgICBwb3B1cF85NzVmZmE5MTIxMmI0ZjdhYTY2YTRjMjcwNjYxMTEyNS5zZXRDb250ZW50KGh0bWxfYTVhZWQwMWI5YTY2NDQyYzlkYTM3MDYwNTE2ZjM0ZWMpOwogICAgICAgICAgICAKCiAgICAgICAgICAgIG1hcmtlcl84ODRkOTA3NDkwNmE0ZGU4OTljMTJiN2RlNzZlNGJjOC5iaW5kUG9wdXAocG9wdXBfOTc1ZmZhOTEyMTJiNGY3YWE2NmE0YzI3MDY2MTExMjUpCiAgICAgICAgICAgIDsKCiAgICAgICAgICAgIAogICAgICAgIAogICAgCiAgICAgICAgdmFyIG1hcmtlcl9mMmFhYmQ2Yjg3MTE0ZTBmYjExNzQ1YTUzYjUyZWVlNSA9IEwubWFya2VyKAogICAgICAgICAgICBbNDAuMTgxODgsIC0xMDUuMTk2Nzc1XSwKICAgICAgICAgICAgewogICAgICAgICAgICAgICAgaWNvbjogbmV3IEwuSWNvbi5EZWZhdWx0KCkKICAgICAgICAgICAgICAgIH0KICAgICAgICAgICAgKS5hZGRUbyhtYXJrZXJfY2x1c3Rlcl9kZjI5ZjE2NjkwNmQ0NGIxOTZlMDlkYTlhYzNlNDIyMik7CiAgICAgICAgCiAgICAKICAgICAgICAgICAgdmFyIHBvcHVwX2JjOWI5NTA4ZWVlODRiNTZiYzZlMDFjZGNkOWJkNjFhID0gTC5wb3B1cCh7bWF4V2lkdGg6ICczMDAnCiAgICAgICAgICAgIAogICAgICAgICAgICB9KTsKCiAgICAgICAgICAgIAogICAgICAgICAgICAgICAgdmFyIGh0bWxfNGJkNmI2OTk4NTgyNGUwYjhmMWVkN2UzZjMxYWVmM2MgPSAkKCc8ZGl2IGlkPSJodG1sXzRiZDZiNjk5ODU4MjRlMGI4ZjFlZDdlM2YzMWFlZjNjIiBzdHlsZT0id2lkdGg6IDEwMC4wJTsgaGVpZ2h0OiAxMDAuMCU7Ij5OYW1lOiBEQVZJUyBBTkQgRE9XTklORyBESVRDSCBQcmVjaXA6IDAuMDA8L2Rpdj4nKVswXTsKICAgICAgICAgICAgICAgIHBvcHVwX2JjOWI5NTA4ZWVlODRiNTZiYzZlMDFjZGNkOWJkNjFhLnNldENvbnRlbnQoaHRtbF80YmQ2YjY5OTg1ODI0ZTBiOGYxZWQ3ZTNmMzFhZWYzYyk7CiAgICAgICAgICAgIAoKICAgICAgICAgICAgbWFya2VyX2YyYWFiZDZiODcxMTRlMGZiMTE3NDVhNTNiNTJlZWU1LmJpbmRQb3B1cChwb3B1cF9iYzliOTUwOGVlZTg0YjU2YmM2ZTAxY2RjZDliZDYxYSkKICAgICAgICAgICAgOwoKICAgICAgICAgICAgCiAgICAgICAgCiAgICAKICAgICAgICB2YXIgbWFya2VyX2RhYWE4YTI5ZmY4ZjQ5MzVhODFmZjA0ZWViYjg1MjczID0gTC5tYXJrZXIoCiAgICAgICAgICAgIFs0MC4xODc1NzgsIC0xMDUuMTg5MTkxXSwKICAgICAgICAgICAgewogICAgICAgICAgICAgICAgaWNvbjogbmV3IEwuSWNvbi5EZWZhdWx0KCkKICAgICAgICAgICAgICAgIH0KICAgICAgICAgICAgKS5hZGRUbyhtYXJrZXJfY2x1c3Rlcl9kZjI5ZjE2NjkwNmQ0NGIxOTZlMDlkYTlhYzNlNDIyMik7CiAgICAgICAgCiAgICAKICAgICAgICAgICAgdmFyIHBvcHVwXzcxMTRjMjFkZGIwNDQzNjNhMDFjMDk2MjU3ZmU2NjRjID0gTC5wb3B1cCh7bWF4V2lkdGg6ICczMDAnCiAgICAgICAgICAgIAogICAgICAgICAgICB9KTsKCiAgICAgICAgICAgIAogICAgICAgICAgICAgICAgdmFyIGh0bWxfYmJjNzhhMmI5MzkyNGM2YWJhMjNhNmEzMDFmMjdjMGEgPSAkKCc8ZGl2IGlkPSJodG1sX2JiYzc4YTJiOTM5MjRjNmFiYTIzYTZhMzAxZjI3YzBhIiBzdHlsZT0id2lkdGg6IDEwMC4wJTsgaGVpZ2h0OiAxMDAuMCU7Ij5OYW1lOiBERU5JTyBUQVlMT1IgRElUQ0ggUHJlY2lwOiAwLjAwPC9kaXY+JylbMF07CiAgICAgICAgICAgICAgICBwb3B1cF83MTE0YzIxZGRiMDQ0MzYzYTAxYzA5NjI1N2ZlNjY0Yy5zZXRDb250ZW50KGh0bWxfYmJjNzhhMmI5MzkyNGM2YWJhMjNhNmEzMDFmMjdjMGEpOwogICAgICAgICAgICAKCiAgICAgICAgICAgIG1hcmtlcl9kYWFhOGEyOWZmOGY0OTM1YTgxZmYwNGVlYmI4NTI3My5iaW5kUG9wdXAocG9wdXBfNzExNGMyMWRkYjA0NDM2M2EwMWMwOTYyNTdmZTY2NGMpCiAgICAgICAgICAgIDsKCiAgICAgICAgICAgIAogICAgICAgIAogICAgCiAgICAgICAgdmFyIG1hcmtlcl8xY2IwZDQxNDUzY2Y0ZGI5YjFlNzI0OTUyMzRiMjg1ZiA9IEwubWFya2VyKAogICAgICAgICAgICBbNDAuMTk5MzIxLCAtMTA1LjIyMjYzOV0sCiAgICAgICAgICAgIHsKICAgICAgICAgICAgICAgIGljb246IG5ldyBMLkljb24uRGVmYXVsdCgpCiAgICAgICAgICAgICAgICB9CiAgICAgICAgICAgICkuYWRkVG8obWFya2VyX2NsdXN0ZXJfZGYyOWYxNjY5MDZkNDRiMTk2ZTA5ZGE5YWMzZTQyMjIpOwogICAgICAgIAogICAgCiAgICAgICAgICAgIHZhciBwb3B1cF9lYjVkYmIxNmU0YjI0MWNhOGIzNTYwNTJhZTNiNzdjOSA9IEwucG9wdXAoe21heFdpZHRoOiAnMzAwJwogICAgICAgICAgICAKICAgICAgICAgICAgfSk7CgogICAgICAgICAgICAKICAgICAgICAgICAgICAgIHZhciBodG1sXzVjZTJmODk3NjZkYzQ2ZGY5NDQ2ODRkZjkyNTc4NTY0ID0gJCgnPGRpdiBpZD0iaHRtbF81Y2UyZjg5NzY2ZGM0NmRmOTQ0Njg0ZGY5MjU3ODU2NCIgc3R5bGU9IndpZHRoOiAxMDAuMCU7IGhlaWdodDogMTAwLjAlOyI+TmFtZTogR09TUyBESVRDSCAxIFByZWNpcDogMC4wMDwvZGl2PicpWzBdOwogICAgICAgICAgICAgICAgcG9wdXBfZWI1ZGJiMTZlNGIyNDFjYThiMzU2MDUyYWUzYjc3Yzkuc2V0Q29udGVudChodG1sXzVjZTJmODk3NjZkYzQ2ZGY5NDQ2ODRkZjkyNTc4NTY0KTsKICAgICAgICAgICAgCgogICAgICAgICAgICBtYXJrZXJfMWNiMGQ0MTQ1M2NmNGRiOWIxZTcyNDk1MjM0YjI4NWYuYmluZFBvcHVwKHBvcHVwX2ViNWRiYjE2ZTRiMjQxY2E4YjM1NjA1MmFlM2I3N2M5KQogICAgICAgICAgICA7CgogICAgICAgICAgICAKICAgICAgICAKICAgIAogICAgICAgIHZhciBtYXJrZXJfMzQ4YzFhZmEwNjJiNDc3OGE5ZDQ3OWIzYjJmOGYxZTAgPSBMLm1hcmtlcigKICAgICAgICAgICAgWzQwLjE3NDg0NCwgLTEwNS4xNjc4NzNdLAogICAgICAgICAgICB7CiAgICAgICAgICAgICAgICBpY29uOiBuZXcgTC5JY29uLkRlZmF1bHQoKQogICAgICAgICAgICAgICAgfQogICAgICAgICAgICApLmFkZFRvKG1hcmtlcl9jbHVzdGVyX2RmMjlmMTY2OTA2ZDQ0YjE5NmUwOWRhOWFjM2U0MjIyKTsKICAgICAgICAKICAgIAogICAgICAgICAgICB2YXIgcG9wdXBfMTViYTVhMWFmZGZjNGM4YWFjOTQ2OTIyZTQ5MzRiOGMgPSBMLnBvcHVwKHttYXhXaWR0aDogJzMwMCcKICAgICAgICAgICAgCiAgICAgICAgICAgIH0pOwoKICAgICAgICAgICAgCiAgICAgICAgICAgICAgICB2YXIgaHRtbF83ZmIxMzhjNmFhMTI0OWZlYTQxYjkyMzQxNjY1ZWMyMiA9ICQoJzxkaXYgaWQ9Imh0bWxfN2ZiMTM4YzZhYTEyNDlmZWE0MWI5MjM0MTY2NWVjMjIiIHN0eWxlPSJ3aWR0aDogMTAwLjAlOyBoZWlnaHQ6IDEwMC4wJTsiPk5hbWU6IEhBR0VSIE1FQURPV1MgRElUQ0ggUHJlY2lwOiAwLjAzPC9kaXY+JylbMF07CiAgICAgICAgICAgICAgICBwb3B1cF8xNWJhNWExYWZkZmM0YzhhYWM5NDY5MjJlNDkzNGI4Yy5zZXRDb250ZW50KGh0bWxfN2ZiMTM4YzZhYTEyNDlmZWE0MWI5MjM0MTY2NWVjMjIpOwogICAgICAgICAgICAKCiAgICAgICAgICAgIG1hcmtlcl8zNDhjMWFmYTA2MmI0Nzc4YTlkNDc5YjNiMmY4ZjFlMC5iaW5kUG9wdXAocG9wdXBfMTViYTVhMWFmZGZjNGM4YWFjOTQ2OTIyZTQ5MzRiOGMpCiAgICAgICAgICAgIDsKCiAgICAgICAgICAgIAogICAgICAgIAogICAgCiAgICAgICAgdmFyIG1hcmtlcl8zNDg2YThkNjdhMGE0ZGY0OTk1MzNhY2YxYTQ1MWUyZiA9IEwubWFya2VyKAogICAgICAgICAgICBbNDAuMjE1MDQzLCAtMTA1LjI1NjAxN10sCiAgICAgICAgICAgIHsKICAgICAgICAgICAgICAgIGljb246IG5ldyBMLkljb24uRGVmYXVsdCgpCiAgICAgICAgICAgICAgICB9CiAgICAgICAgICAgICkuYWRkVG8obWFya2VyX2NsdXN0ZXJfZGYyOWYxNjY5MDZkNDRiMTk2ZTA5ZGE5YWMzZTQyMjIpOwogICAgICAgIAogICAgCiAgICAgICAgICAgIHZhciBwb3B1cF9hNGZhNmQ2YjExMGE0ZjEzOTMwZDJjNjA3ZmQ4OGY1YSA9IEwucG9wdXAoe21heFdpZHRoOiAnMzAwJwogICAgICAgICAgICAKICAgICAgICAgICAgfSk7CgogICAgICAgICAgICAKICAgICAgICAgICAgICAgIHZhciBodG1sXzg2Mzg5ZTE0NTE1YTRiNWJiYmU1M2JhYTc2NTI0ZWMzID0gJCgnPGRpdiBpZD0iaHRtbF84NjM4OWUxNDUxNWE0YjViYmJlNTNiYWE3NjUyNGVjMyIgc3R5bGU9IndpZHRoOiAxMDAuMCU7IGhlaWdodDogMTAwLjAlOyI+TmFtZTogSElHSExBTkQgRElUQ0ggQVQgTFlPTlMsIENPIFByZWNpcDogMTMuMTA8L2Rpdj4nKVswXTsKICAgICAgICAgICAgICAgIHBvcHVwX2E0ZmE2ZDZiMTEwYTRmMTM5MzBkMmM2MDdmZDg4ZjVhLnNldENvbnRlbnQoaHRtbF84NjM4OWUxNDUxNWE0YjViYmJlNTNiYWE3NjUyNGVjMyk7CiAgICAgICAgICAgIAoKICAgICAgICAgICAgbWFya2VyXzM0ODZhOGQ2N2EwYTRkZjQ5OTUzM2FjZjFhNDUxZTJmLmJpbmRQb3B1cChwb3B1cF9hNGZhNmQ2YjExMGE0ZjEzOTMwZDJjNjA3ZmQ4OGY1YSkKICAgICAgICAgICAgOwoKICAgICAgICAgICAgCiAgICAgICAgCiAgICAKICAgICAgICB2YXIgbWFya2VyXzdjZmI4YTU3NTAxMDRjYmI5OTBhMDM3NTczODYzY2NkID0gTC5tYXJrZXIoCiAgICAgICAgICAgIFs0MC4xODg1NzksIC0xMDUuMjA5MjgyXSwKICAgICAgICAgICAgewogICAgICAgICAgICAgICAgaWNvbjogbmV3IEwuSWNvbi5EZWZhdWx0KCkKICAgICAgICAgICAgICAgIH0KICAgICAgICAgICAgKS5hZGRUbyhtYXJrZXJfY2x1c3Rlcl9kZjI5ZjE2NjkwNmQ0NGIxOTZlMDlkYTlhYzNlNDIyMik7CiAgICAgICAgCiAgICAKICAgICAgICAgICAgdmFyIHBvcHVwX2QxYTllNDQyOTIwMjRjYTJiODQ1MmZiMzA2ZjkyNGZmID0gTC5wb3B1cCh7bWF4V2lkdGg6ICczMDAnCiAgICAgICAgICAgIAogICAgICAgICAgICB9KTsKCiAgICAgICAgICAgIAogICAgICAgICAgICAgICAgdmFyIGh0bWxfY2E2YjRjYWQ1N2NhNGM5YTkyMzE1ZTE1ZGQ3MWFhOGUgPSAkKCc8ZGl2IGlkPSJodG1sX2NhNmI0Y2FkNTdjYTRjOWE5MjMxNWUxNWRkNzFhYThlIiBzdHlsZT0id2lkdGg6IDEwMC4wJTsgaGVpZ2h0OiAxMDAuMCU7Ij5OYW1lOiBKQU1FUyBESVRDSCBQcmVjaXA6IDIuNTA8L2Rpdj4nKVswXTsKICAgICAgICAgICAgICAgIHBvcHVwX2QxYTllNDQyOTIwMjRjYTJiODQ1MmZiMzA2ZjkyNGZmLnNldENvbnRlbnQoaHRtbF9jYTZiNGNhZDU3Y2E0YzlhOTIzMTVlMTVkZDcxYWE4ZSk7CiAgICAgICAgICAgIAoKICAgICAgICAgICAgbWFya2VyXzdjZmI4YTU3NTAxMDRjYmI5OTBhMDM3NTczODYzY2NkLmJpbmRQb3B1cChwb3B1cF9kMWE5ZTQ0MjkyMDI0Y2EyYjg0NTJmYjMwNmY5MjRmZikKICAgICAgICAgICAgOwoKICAgICAgICAgICAgCiAgICAgICAgCiAgICAKICAgICAgICB2YXIgbWFya2VyXzRlMDNkZTA1NmY5NTRlMmFiNzU0YTdmNGU1ZWNkN2VkID0gTC5tYXJrZXIoCiAgICAgICAgICAgIFs0MC4xMzQyNzgsIC0xMDUuMTMwODE5XSwKICAgICAgICAgICAgewogICAgICAgICAgICAgICAgaWNvbjogbmV3IEwuSWNvbi5EZWZhdWx0KCkKICAgICAgICAgICAgICAgIH0KICAgICAgICAgICAgKS5hZGRUbyhtYXJrZXJfY2x1c3Rlcl9kZjI5ZjE2NjkwNmQ0NGIxOTZlMDlkYTlhYzNlNDIyMik7CiAgICAgICAgCiAgICAKICAgICAgICAgICAgdmFyIHBvcHVwXzBkNDkyZTZhYTNjYjQ1Mzg4ZDZmMmFhMmIzMTNjYzA2ID0gTC5wb3B1cCh7bWF4V2lkdGg6ICczMDAnCiAgICAgICAgICAgIAogICAgICAgICAgICB9KTsKCiAgICAgICAgICAgIAogICAgICAgICAgICAgICAgdmFyIGh0bWxfZjZiOTgyNDVmMTE3NDFlOGE1YzIxOTYyZGY2OTc1ODcgPSAkKCc8ZGl2IGlkPSJodG1sX2Y2Yjk4MjQ1ZjExNzQxZThhNWMyMTk2MmRmNjk3NTg3IiBzdHlsZT0id2lkdGg6IDEwMC4wJTsgaGVpZ2h0OiAxMDAuMCU7Ij5OYW1lOiBMRUZUIEhBTkQgQ1JFRUsgQVQgSE9WRVIgUk9BRCBORUFSIExPTkdNT05ULCBDTyBQcmVjaXA6IDUuMDc8L2Rpdj4nKVswXTsKICAgICAgICAgICAgICAgIHBvcHVwXzBkNDkyZTZhYTNjYjQ1Mzg4ZDZmMmFhMmIzMTNjYzA2LnNldENvbnRlbnQoaHRtbF9mNmI5ODI0NWYxMTc0MWU4YTVjMjE5NjJkZjY5NzU4Nyk7CiAgICAgICAgICAgIAoKICAgICAgICAgICAgbWFya2VyXzRlMDNkZTA1NmY5NTRlMmFiNzU0YTdmNGU1ZWNkN2VkLmJpbmRQb3B1cChwb3B1cF8wZDQ5MmU2YWEzY2I0NTM4OGQ2ZjJhYTJiMzEzY2MwNikKICAgICAgICAgICAgOwoKICAgICAgICAgICAgCiAgICAgICAgCiAgICAKICAgICAgICB2YXIgbWFya2VyXzRmNmE5NTAwOTQwYzQ2OWRiNmNiMGQ3NWQ0Y2YwMjgyID0gTC5tYXJrZXIoCiAgICAgICAgICAgIFs0MC4yMDQxOTMsIC0xMDUuMjE4Nzc3XSwKICAgICAgICAgICAgewogICAgICAgICAgICAgICAgaWNvbjogbmV3IEwuSWNvbi5EZWZhdWx0KCkKICAgICAgICAgICAgICAgIH0KICAgICAgICAgICAgKS5hZGRUbyhtYXJrZXJfY2x1c3Rlcl9kZjI5ZjE2NjkwNmQ0NGIxOTZlMDlkYTlhYzNlNDIyMik7CiAgICAgICAgCiAgICAKICAgICAgICAgICAgdmFyIHBvcHVwX2U4OTkzNGFkYjY1MDQxMzVhNjNiMjNkNTYzMTdmNGNhID0gTC5wb3B1cCh7bWF4V2lkdGg6ICczMDAnCiAgICAgICAgICAgIAogICAgICAgICAgICB9KTsKCiAgICAgICAgICAgIAogICAgICAgICAgICAgICAgdmFyIGh0bWxfMjMyN2M0NDg3ZDIwNDZhMGFlMTlkMTI1N2MxZDY3OGMgPSAkKCc8ZGl2IGlkPSJodG1sXzIzMjdjNDQ4N2QyMDQ2YTBhZTE5ZDEyNTdjMWQ2NzhjIiBzdHlsZT0id2lkdGg6IDEwMC4wJTsgaGVpZ2h0OiAxMDAuMCU7Ij5OYW1lOiBMT05HTU9OVCBTVVBQTFkgRElUQ0ggUHJlY2lwOiAwLjMzPC9kaXY+JylbMF07CiAgICAgICAgICAgICAgICBwb3B1cF9lODk5MzRhZGI2NTA0MTM1YTYzYjIzZDU2MzE3ZjRjYS5zZXRDb250ZW50KGh0bWxfMjMyN2M0NDg3ZDIwNDZhMGFlMTlkMTI1N2MxZDY3OGMpOwogICAgICAgICAgICAKCiAgICAgICAgICAgIG1hcmtlcl80ZjZhOTUwMDk0MGM0NjlkYjZjYjBkNzVkNGNmMDI4Mi5iaW5kUG9wdXAocG9wdXBfZTg5OTM0YWRiNjUwNDEzNWE2M2IyM2Q1NjMxN2Y0Y2EpCiAgICAgICAgICAgIDsKCiAgICAgICAgICAgIAogICAgICAgIAogICAgCiAgICAgICAgdmFyIG1hcmtlcl84NjkxMmYwYjUwNDQ0MWI1YWQ0ZjMzMTM5YzVmNDdlNiA9IEwubWFya2VyKAogICAgICAgICAgICBbNDAuMTczOTUsIC0xMDUuMTY5Mzc0XSwKICAgICAgICAgICAgewogICAgICAgICAgICAgICAgaWNvbjogbmV3IEwuSWNvbi5EZWZhdWx0KCkKICAgICAgICAgICAgICAgIH0KICAgICAgICAgICAgKS5hZGRUbyhtYXJrZXJfY2x1c3Rlcl9kZjI5ZjE2NjkwNmQ0NGIxOTZlMDlkYTlhYzNlNDIyMik7CiAgICAgICAgCiAgICAKICAgICAgICAgICAgdmFyIHBvcHVwXzk1YjI4NGRkODBjOTRkYzNhM2UxOGU0ZTQ0ZWNhNjMyID0gTC5wb3B1cCh7bWF4V2lkdGg6ICczMDAnCiAgICAgICAgICAgIAogICAgICAgICAgICB9KTsKCiAgICAgICAgICAgIAogICAgICAgICAgICAgICAgdmFyIGh0bWxfY2M3MzcyMjAwMDgzNDFhZDgwYjI4MzQ2Mjk0MTVlNjEgPSAkKCc8ZGl2IGlkPSJodG1sX2NjNzM3MjIwMDA4MzQxYWQ4MGIyODM0NjI5NDE1ZTYxIiBzdHlsZT0id2lkdGg6IDEwMC4wJTsgaGVpZ2h0OiAxMDAuMCU7Ij5OYW1lOiBOSVdPVCBESVRDSCBQcmVjaXA6IDAuNDc8L2Rpdj4nKVswXTsKICAgICAgICAgICAgICAgIHBvcHVwXzk1YjI4NGRkODBjOTRkYzNhM2UxOGU0ZTQ0ZWNhNjMyLnNldENvbnRlbnQoaHRtbF9jYzczNzIyMDAwODM0MWFkODBiMjgzNDYyOTQxNWU2MSk7CiAgICAgICAgICAgIAoKICAgICAgICAgICAgbWFya2VyXzg2OTEyZjBiNTA0NDQxYjVhZDRmMzMxMzljNWY0N2U2LmJpbmRQb3B1cChwb3B1cF85NWIyODRkZDgwYzk0ZGMzYTNlMThlNGU0NGVjYTYzMikKICAgICAgICAgICAgOwoKICAgICAgICAgICAgCiAgICAgICAgCiAgICAKICAgICAgICB2YXIgbWFya2VyXzE5N2E0MWY1ODgxMDRmZTI5ZmFlZjRkMmY5N2MzNWE1ID0gTC5tYXJrZXIoCiAgICAgICAgICAgIFs0MC4yMTU2NTgsIC0xMDUuMzYzNDIyXSwKICAgICAgICAgICAgewogICAgICAgICAgICAgICAgaWNvbjogbmV3IEwuSWNvbi5EZWZhdWx0KCkKICAgICAgICAgICAgICAgIH0KICAgICAgICAgICAgKS5hZGRUbyhtYXJrZXJfY2x1c3Rlcl9kZjI5ZjE2NjkwNmQ0NGIxOTZlMDlkYTlhYzNlNDIyMik7CiAgICAgICAgCiAgICAKICAgICAgICAgICAgdmFyIHBvcHVwXzU3NDdlMDM4MzQxNjQ2ZTZiMjE0MGY4YjQzNWUxYWE2ID0gTC5wb3B1cCh7bWF4V2lkdGg6ICczMDAnCiAgICAgICAgICAgIAogICAgICAgICAgICB9KTsKCiAgICAgICAgICAgIAogICAgICAgICAgICAgICAgdmFyIGh0bWxfNWFmYjQ3ODE0MTcyNGI5YTlmMzM5YmQ3ZDk1Zjg1ZmMgPSAkKCc8ZGl2IGlkPSJodG1sXzVhZmI0NzgxNDE3MjRiOWE5ZjMzOWJkN2Q5NWY4NWZjIiBzdHlsZT0id2lkdGg6IDEwMC4wJTsgaGVpZ2h0OiAxMDAuMCU7Ij5OYW1lOiBOT1JUSCBTQUlOVCBWUkFJTiBDUkVFSyBCRUxPVyBCVVRUT05ST0NLICAoUkFMUEggUFJJQ0UpIFJFU0VSVk9JUiBQcmVjaXA6IDI4LjQwPC9kaXY+JylbMF07CiAgICAgICAgICAgICAgICBwb3B1cF81NzQ3ZTAzODM0MTY0NmU2YjIxNDBmOGI0MzVlMWFhNi5zZXRDb250ZW50KGh0bWxfNWFmYjQ3ODE0MTcyNGI5YTlmMzM5YmQ3ZDk1Zjg1ZmMpOwogICAgICAgICAgICAKCiAgICAgICAgICAgIG1hcmtlcl8xOTdhNDFmNTg4MTA0ZmUyOWZhZWY0ZDJmOTdjMzVhNS5iaW5kUG9wdXAocG9wdXBfNTc0N2UwMzgzNDE2NDZlNmIyMTQwZjhiNDM1ZTFhYTYpCiAgICAgICAgICAgIDsKCiAgICAgICAgICAgIAogICAgICAgIAogICAgCiAgICAgICAgdmFyIG1hcmtlcl9iOWJmZDYxMmQwMGU0ZjlmOGNiNWRkYmIwNzhjMzM1ZCA9IEwubWFya2VyKAogICAgICAgICAgICBbNDAuMTcyOTI1LCAtMTA1LjE2NzYyMl0sCiAgICAgICAgICAgIHsKICAgICAgICAgICAgICAgIGljb246IG5ldyBMLkljb24uRGVmYXVsdCgpCiAgICAgICAgICAgICAgICB9CiAgICAgICAgICAgICkuYWRkVG8obWFya2VyX2NsdXN0ZXJfZGYyOWYxNjY5MDZkNDRiMTk2ZTA5ZGE5YWMzZTQyMjIpOwogICAgICAgIAogICAgCiAgICAgICAgICAgIHZhciBwb3B1cF8xNjQ2Y2FmNzczMWI0MDkwYjM3YzVjN2RhODhjZDNmNCA9IEwucG9wdXAoe21heFdpZHRoOiAnMzAwJwogICAgICAgICAgICAKICAgICAgICAgICAgfSk7CgogICAgICAgICAgICAKICAgICAgICAgICAgICAgIHZhciBodG1sX2M5ODg0MGMzOTFiNDQyZGJhM2FiZmM5NDViY2QxNjU4ID0gJCgnPGRpdiBpZD0iaHRtbF9jOTg4NDBjMzkxYjQ0MmRiYTNhYmZjOTQ1YmNkMTY1OCIgc3R5bGU9IndpZHRoOiAxMDAuMCU7IGhlaWdodDogMTAwLjAlOyI+TmFtZTogTk9SVEhXRVNUIE1VVFVBTCBESVRDSCBQcmVjaXA6IDAuMDc8L2Rpdj4nKVswXTsKICAgICAgICAgICAgICAgIHBvcHVwXzE2NDZjYWY3NzMxYjQwOTBiMzdjNWM3ZGE4OGNkM2Y0LnNldENvbnRlbnQoaHRtbF9jOTg4NDBjMzkxYjQ0MmRiYTNhYmZjOTQ1YmNkMTY1OCk7CiAgICAgICAgICAgIAoKICAgICAgICAgICAgbWFya2VyX2I5YmZkNjEyZDAwZTRmOWY4Y2I1ZGRiYjA3OGMzMzVkLmJpbmRQb3B1cChwb3B1cF8xNjQ2Y2FmNzczMWI0MDkwYjM3YzVjN2RhODhjZDNmNCkKICAgICAgICAgICAgOwoKICAgICAgICAgICAgCiAgICAgICAgCiAgICAKICAgICAgICB2YXIgbWFya2VyXzI1OWQwZmZmZDRhOTRkOTQ4ZWQ2YWFmZTAwZDFmZDYyID0gTC5tYXJrZXIoCiAgICAgICAgICAgIFs0MC4xOTY0MjIsIC0xMDUuMjA2NTkyXSwKICAgICAgICAgICAgewogICAgICAgICAgICAgICAgaWNvbjogbmV3IEwuSWNvbi5EZWZhdWx0KCkKICAgICAgICAgICAgICAgIH0KICAgICAgICAgICAgKS5hZGRUbyhtYXJrZXJfY2x1c3Rlcl9kZjI5ZjE2NjkwNmQ0NGIxOTZlMDlkYTlhYzNlNDIyMik7CiAgICAgICAgCiAgICAKICAgICAgICAgICAgdmFyIHBvcHVwXzliODBiMDVkYTYyNzQ0ZWViYTZjNDY2YWMzMTUzYjM1ID0gTC5wb3B1cCh7bWF4V2lkdGg6ICczMDAnCiAgICAgICAgICAgIAogICAgICAgICAgICB9KTsKCiAgICAgICAgICAgIAogICAgICAgICAgICAgICAgdmFyIGh0bWxfMzYxODJmMjMwNjE2NDg3Nzg4MmJkZWY3Y2RlZDQ5ZTQgPSAkKCc8ZGl2IGlkPSJodG1sXzM2MTgyZjIzMDYxNjQ4Nzc4ODJiZGVmN2NkZWQ0OWU0IiBzdHlsZT0id2lkdGg6IDEwMC4wJTsgaGVpZ2h0OiAxMDAuMCU7Ij5OYW1lOiBPTElHQVJDSFkgRElUQ0ggRElWRVJTSU9OIFByZWNpcDogMC4wMDwvZGl2PicpWzBdOwogICAgICAgICAgICAgICAgcG9wdXBfOWI4MGIwNWRhNjI3NDRlZWJhNmM0NjZhYzMxNTNiMzUuc2V0Q29udGVudChodG1sXzM2MTgyZjIzMDYxNjQ4Nzc4ODJiZGVmN2NkZWQ0OWU0KTsKICAgICAgICAgICAgCgogICAgICAgICAgICBtYXJrZXJfMjU5ZDBmZmZkNGE5NGQ5NDhlZDZhYWZlMDBkMWZkNjIuYmluZFBvcHVwKHBvcHVwXzliODBiMDVkYTYyNzQ0ZWViYTZjNDY2YWMzMTUzYjM1KQogICAgICAgICAgICA7CgogICAgICAgICAgICAKICAgICAgICAKICAgIAogICAgICAgIHZhciBtYXJrZXJfOGQ2ZTM1MGQ1NTkzNDZmMjkxZGU4NTRmM2FkODRiYzEgPSBMLm1hcmtlcigKICAgICAgICAgICAgWzQwLjIxMjUwNSwgLTEwNS4yNTE4MjZdLAogICAgICAgICAgICB7CiAgICAgICAgICAgICAgICBpY29uOiBuZXcgTC5JY29uLkRlZmF1bHQoKQogICAgICAgICAgICAgICAgfQogICAgICAgICAgICApLmFkZFRvKG1hcmtlcl9jbHVzdGVyX2RmMjlmMTY2OTA2ZDQ0YjE5NmUwOWRhOWFjM2U0MjIyKTsKICAgICAgICAKICAgIAogICAgICAgICAgICB2YXIgcG9wdXBfZWFhYmFiMGQxMTRkNDYwNGFkYmIyNjc4NTk0OTMyZGIgPSBMLnBvcHVwKHttYXhXaWR0aDogJzMwMCcKICAgICAgICAgICAgCiAgICAgICAgICAgIH0pOwoKICAgICAgICAgICAgCiAgICAgICAgICAgICAgICB2YXIgaHRtbF9hYzMyMDVlNzAzYzA0ZTlhODc1ZmY4M2JjYTQ3Y2VjOSA9ICQoJzxkaXYgaWQ9Imh0bWxfYWMzMjA1ZTcwM2MwNGU5YTg3NWZmODNiY2E0N2NlYzkiIHN0eWxlPSJ3aWR0aDogMTAwLjAlOyBoZWlnaHQ6IDEwMC4wJTsiPk5hbWU6IFBBTE1FUlRPTiBESVRDSCBQcmVjaXA6IDAuMDI8L2Rpdj4nKVswXTsKICAgICAgICAgICAgICAgIHBvcHVwX2VhYWJhYjBkMTE0ZDQ2MDRhZGJiMjY3ODU5NDkzMmRiLnNldENvbnRlbnQoaHRtbF9hYzMyMDVlNzAzYzA0ZTlhODc1ZmY4M2JjYTQ3Y2VjOSk7CiAgICAgICAgICAgIAoKICAgICAgICAgICAgbWFya2VyXzhkNmUzNTBkNTU5MzQ2ZjI5MWRlODU0ZjNhZDg0YmMxLmJpbmRQb3B1cChwb3B1cF9lYWFiYWIwZDExNGQ0NjA0YWRiYjI2Nzg1OTQ5MzJkYikKICAgICAgICAgICAgOwoKICAgICAgICAgICAgCiAgICAgICAgCiAgICAKICAgICAgICB2YXIgbWFya2VyX2I5Y2FkOWQ5MTkxMzRlYjk4ZTQxNmNmMDVlMmJiMjE1ID0gTC5tYXJrZXIoCiAgICAgICAgICAgIFs0MC4xNzcwOCwgLTEwNS4xNzg1NjddLAogICAgICAgICAgICB7CiAgICAgICAgICAgICAgICBpY29uOiBuZXcgTC5JY29uLkRlZmF1bHQoKQogICAgICAgICAgICAgICAgfQogICAgICAgICAgICApLmFkZFRvKG1hcmtlcl9jbHVzdGVyX2RmMjlmMTY2OTA2ZDQ0YjE5NmUwOWRhOWFjM2U0MjIyKTsKICAgICAgICAKICAgIAogICAgICAgICAgICB2YXIgcG9wdXBfMDZhZWExMTc0NzA0NGM2Y2IyOTlhNGY5ZTk2N2JiZTkgPSBMLnBvcHVwKHttYXhXaWR0aDogJzMwMCcKICAgICAgICAgICAgCiAgICAgICAgICAgIH0pOwoKICAgICAgICAgICAgCiAgICAgICAgICAgICAgICB2YXIgaHRtbF8zZTE0YjBhYTRhNTg0NzkyYWM3ZDEwMGRhOTM2MmIxNSA9ICQoJzxkaXYgaWQ9Imh0bWxfM2UxNGIwYWE0YTU4NDc5MmFjN2QxMDBkYTkzNjJiMTUiIHN0eWxlPSJ3aWR0aDogMTAwLjAlOyBoZWlnaHQ6IDEwMC4wJTsiPk5hbWU6IFBFQ0sgUEVMTEEgQ0xPVkVSIERJVENIIFByZWNpcDogMC40MzwvZGl2PicpWzBdOwogICAgICAgICAgICAgICAgcG9wdXBfMDZhZWExMTc0NzA0NGM2Y2IyOTlhNGY5ZTk2N2JiZTkuc2V0Q29udGVudChodG1sXzNlMTRiMGFhNGE1ODQ3OTJhYzdkMTAwZGE5MzYyYjE1KTsKICAgICAgICAgICAgCgogICAgICAgICAgICBtYXJrZXJfYjljYWQ5ZDkxOTEzNGViOThlNDE2Y2YwNWUyYmIyMTUuYmluZFBvcHVwKHBvcHVwXzA2YWVhMTE3NDcwNDRjNmNiMjk5YTRmOWU5NjdiYmU5KQogICAgICAgICAgICA7CgogICAgICAgICAgICAKICAgICAgICAKICAgIAogICAgICAgIHZhciBtYXJrZXJfZTBiMzUwYmYwYmY1NDRjMWI5YWUwZDBlZGI0MmQ1MzUgPSBMLm1hcmtlcigKICAgICAgICAgICAgWzQwLjIxMjY1OCwgLTEwNS4yNTE4MjZdLAogICAgICAgICAgICB7CiAgICAgICAgICAgICAgICBpY29uOiBuZXcgTC5JY29uLkRlZmF1bHQoKQogICAgICAgICAgICAgICAgfQogICAgICAgICAgICApLmFkZFRvKG1hcmtlcl9jbHVzdGVyX2RmMjlmMTY2OTA2ZDQ0YjE5NmUwOWRhOWFjM2U0MjIyKTsKICAgICAgICAKICAgIAogICAgICAgICAgICB2YXIgcG9wdXBfMjQ1MmU1YTkwMGNkNGM5NGI4OTVhMzE4NTcxNTYwYjggPSBMLnBvcHVwKHttYXhXaWR0aDogJzMwMCcKICAgICAgICAgICAgCiAgICAgICAgICAgIH0pOwoKICAgICAgICAgICAgCiAgICAgICAgICAgICAgICB2YXIgaHRtbF8yNzg3N2E2OTA4ZTg0NDI5ODJlYTYxMTg1YjQ1NmFhMSA9ICQoJzxkaXYgaWQ9Imh0bWxfMjc4NzdhNjkwOGU4NDQyOTgyZWE2MTE4NWI0NTZhYTEiIHN0eWxlPSJ3aWR0aDogMTAwLjAlOyBoZWlnaHQ6IDEwMC4wJTsiPk5hbWU6IFJPVUdIIEFORCBSRUFEWSBESVRDSCBQcmVjaXA6IDYuNDU8L2Rpdj4nKVswXTsKICAgICAgICAgICAgICAgIHBvcHVwXzI0NTJlNWE5MDBjZDRjOTRiODk1YTMxODU3MTU2MGI4LnNldENvbnRlbnQoaHRtbF8yNzg3N2E2OTA4ZTg0NDI5ODJlYTYxMTg1YjQ1NmFhMSk7CiAgICAgICAgICAgIAoKICAgICAgICAgICAgbWFya2VyX2UwYjM1MGJmMGJmNTQ0YzFiOWFlMGQwZWRiNDJkNTM1LmJpbmRQb3B1cChwb3B1cF8yNDUyZTVhOTAwY2Q0Yzk0Yjg5NWEzMTg1NzE1NjBiOCkKICAgICAgICAgICAgOwoKICAgICAgICAgICAgCiAgICAgICAgCiAgICAKICAgICAgICB2YXIgbWFya2VyX2MzMzE4ZDA5MDRhODRlNTM4OTBiYjY5YTJjOGI5YzY1ID0gTC5tYXJrZXIoCiAgICAgICAgICAgIFs0MC4xODc1MjQsIC0xMDUuMTg5MTMyXSwKICAgICAgICAgICAgewogICAgICAgICAgICAgICAgaWNvbjogbmV3IEwuSWNvbi5EZWZhdWx0KCkKICAgICAgICAgICAgICAgIH0KICAgICAgICAgICAgKS5hZGRUbyhtYXJrZXJfY2x1c3Rlcl9kZjI5ZjE2NjkwNmQ0NGIxOTZlMDlkYTlhYzNlNDIyMik7CiAgICAgICAgCiAgICAKICAgICAgICAgICAgdmFyIHBvcHVwX2I5YmViNzg5NzA4MTQ4ZGVhZjhkMzc2YjI1ZWJmNmFiID0gTC5wb3B1cCh7bWF4V2lkdGg6ICczMDAnCiAgICAgICAgICAgIAogICAgICAgICAgICB9KTsKCiAgICAgICAgICAgIAogICAgICAgICAgICAgICAgdmFyIGh0bWxfZDY1MmQ5ODgxNWI4NDhmMzg0ZGViMGY4Y2RjMDE2YzAgPSAkKCc8ZGl2IGlkPSJodG1sX2Q2NTJkOTg4MTViODQ4ZjM4NGRlYjBmOGNkYzAxNmMwIiBzdHlsZT0id2lkdGg6IDEwMC4wJTsgaGVpZ2h0OiAxMDAuMCU7Ij5OYW1lOiBSVU5ZT04gRElUQ0ggUHJlY2lwOiAwLjA2PC9kaXY+JylbMF07CiAgICAgICAgICAgICAgICBwb3B1cF9iOWJlYjc4OTcwODE0OGRlYWY4ZDM3NmIyNWViZjZhYi5zZXRDb250ZW50KGh0bWxfZDY1MmQ5ODgxNWI4NDhmMzg0ZGViMGY4Y2RjMDE2YzApOwogICAgICAgICAgICAKCiAgICAgICAgICAgIG1hcmtlcl9jMzMxOGQwOTA0YTg0ZTUzODkwYmI2OWEyYzhiOWM2NS5iaW5kUG9wdXAocG9wdXBfYjliZWI3ODk3MDgxNDhkZWFmOGQzNzZiMjVlYmY2YWIpCiAgICAgICAgICAgIDsKCiAgICAgICAgICAgIAogICAgICAgIAogICAgCiAgICAgICAgdmFyIG1hcmtlcl8zMzI4OGJjMjhlZTg0N2QwODFiNjQ1OGY3ZDhjMDIyMiA9IEwubWFya2VyKAogICAgICAgICAgICBbNDAuMTc3NDIzLCAtMTA1LjE3ODE0NV0sCiAgICAgICAgICAgIHsKICAgICAgICAgICAgICAgIGljb246IG5ldyBMLkljb24uRGVmYXVsdCgpCiAgICAgICAgICAgICAgICB9CiAgICAgICAgICAgICkuYWRkVG8obWFya2VyX2NsdXN0ZXJfZGYyOWYxNjY5MDZkNDRiMTk2ZTA5ZGE5YWMzZTQyMjIpOwogICAgICAgIAogICAgCiAgICAgICAgICAgIHZhciBwb3B1cF9jYjZkODMzZjg2M2M0MDZkODE5M2Y2YzE4YjE3NzFmZiA9IEwucG9wdXAoe21heFdpZHRoOiAnMzAwJwogICAgICAgICAgICAKICAgICAgICAgICAgfSk7CgogICAgICAgICAgICAKICAgICAgICAgICAgICAgIHZhciBodG1sX2QzMDJjNTQ4NWNmMzQ5MmRiMGYzOTAxODAyMDcwNTM4ID0gJCgnPGRpdiBpZD0iaHRtbF9kMzAyYzU0ODVjZjM0OTJkYjBmMzkwMTgwMjA3MDUzOCIgc3R5bGU9IndpZHRoOiAxMDAuMCU7IGhlaWdodDogMTAwLjAlOyI+TmFtZTogU0FJTlQgVlJBSU4gQ1JFRUsgQVQgSFlHSUVORSwgQ08gUHJlY2lwOiA3LjYwPC9kaXY+JylbMF07CiAgICAgICAgICAgICAgICBwb3B1cF9jYjZkODMzZjg2M2M0MDZkODE5M2Y2YzE4YjE3NzFmZi5zZXRDb250ZW50KGh0bWxfZDMwMmM1NDg1Y2YzNDkyZGIwZjM5MDE4MDIwNzA1MzgpOwogICAgICAgICAgICAKCiAgICAgICAgICAgIG1hcmtlcl8zMzI4OGJjMjhlZTg0N2QwODFiNjQ1OGY3ZDhjMDIyMi5iaW5kUG9wdXAocG9wdXBfY2I2ZDgzM2Y4NjNjNDA2ZDgxOTNmNmMxOGIxNzcxZmYpCiAgICAgICAgICAgIDsKCiAgICAgICAgICAgIAogICAgICAgIAogICAgCiAgICAgICAgdmFyIG1hcmtlcl9mZDA5Njc2MGYzNjU0ZDA5YTE4MzYwOWFhM2JhY2MwZCA9IEwubWFya2VyKAogICAgICAgICAgICBbNDAuMjIwNzAyLCAtMTA1LjI2MzQ5XSwKICAgICAgICAgICAgewogICAgICAgICAgICAgICAgaWNvbjogbmV3IEwuSWNvbi5EZWZhdWx0KCkKICAgICAgICAgICAgICAgIH0KICAgICAgICAgICAgKS5hZGRUbyhtYXJrZXJfY2x1c3Rlcl9kZjI5ZjE2NjkwNmQ0NGIxOTZlMDlkYTlhYzNlNDIyMik7CiAgICAgICAgCiAgICAKICAgICAgICAgICAgdmFyIHBvcHVwXzliM2E4MDMxYjY2ODRhZDZhZGJkNjcwZTc2NWVlZjM2ID0gTC5wb3B1cCh7bWF4V2lkdGg6ICczMDAnCiAgICAgICAgICAgIAogICAgICAgICAgICB9KTsKCiAgICAgICAgICAgIAogICAgICAgICAgICAgICAgdmFyIGh0bWxfNWU1NTg1OTI5NDBlNDgwMjk3YWRiMjcyMzg0MmMwZjcgPSAkKCc8ZGl2IGlkPSJodG1sXzVlNTU4NTkyOTQwZTQ4MDI5N2FkYjI3MjM4NDJjMGY3IiBzdHlsZT0id2lkdGg6IDEwMC4wJTsgaGVpZ2h0OiAxMDAuMCU7Ij5OYW1lOiBTQUlOVCBWUkFJTiBDUkVFSyBBVCBMWU9OUywgQ08gUHJlY2lwOiAyMS4yMDwvZGl2PicpWzBdOwogICAgICAgICAgICAgICAgcG9wdXBfOWIzYTgwMzFiNjY4NGFkNmFkYmQ2NzBlNzY1ZWVmMzYuc2V0Q29udGVudChodG1sXzVlNTU4NTkyOTQwZTQ4MDI5N2FkYjI3MjM4NDJjMGY3KTsKICAgICAgICAgICAgCgogICAgICAgICAgICBtYXJrZXJfZmQwOTY3NjBmMzY1NGQwOWExODM2MDlhYTNiYWNjMGQuYmluZFBvcHVwKHBvcHVwXzliM2E4MDMxYjY2ODRhZDZhZGJkNjcwZTc2NWVlZjM2KQogICAgICAgICAgICA7CgogICAgICAgICAgICAKICAgICAgICAKICAgIAogICAgICAgIHZhciBtYXJrZXJfNDJhODE4YTk5MTJhNDNiNzg0ODUyYjFlY2EwMzI1MDMgPSBMLm1hcmtlcigKICAgICAgICAgICAgWzQwLjE1MzM0MSwgLTEwNS4wNzU2OTVdLAogICAgICAgICAgICB7CiAgICAgICAgICAgICAgICBpY29uOiBuZXcgTC5JY29uLkRlZmF1bHQoKQogICAgICAgICAgICAgICAgfQogICAgICAgICAgICApLmFkZFRvKG1hcmtlcl9jbHVzdGVyX2RmMjlmMTY2OTA2ZDQ0YjE5NmUwOWRhOWFjM2U0MjIyKTsKICAgICAgICAKICAgIAogICAgICAgICAgICB2YXIgcG9wdXBfNjA4ZjM3OWQ4NTE3NDA0YWIyYWIwZjU1Yzg0MjVlNDYgPSBMLnBvcHVwKHttYXhXaWR0aDogJzMwMCcKICAgICAgICAgICAgCiAgICAgICAgICAgIH0pOwoKICAgICAgICAgICAgCiAgICAgICAgICAgICAgICB2YXIgaHRtbF80NTczMzNlMzM1ZjM0OGMzODYzZmE1ZTBjZjAwOTYwMCA9ICQoJzxkaXYgaWQ9Imh0bWxfNDU3MzMzZTMzNWYzNDhjMzg2M2ZhNWUwY2YwMDk2MDAiIHN0eWxlPSJ3aWR0aDogMTAwLjAlOyBoZWlnaHQ6IDEwMC4wJTsiPk5hbWU6IFNBSU5UIFZSQUlOIENSRUVLIEJFTE9XIEtFTiBQUkFUVCBCTFZEIEFUIExPTkdNT05ULCBDTyBQcmVjaXA6IDI0LjQwPC9kaXY+JylbMF07CiAgICAgICAgICAgICAgICBwb3B1cF82MDhmMzc5ZDg1MTc0MDRhYjJhYjBmNTVjODQyNWU0Ni5zZXRDb250ZW50KGh0bWxfNDU3MzMzZTMzNWYzNDhjMzg2M2ZhNWUwY2YwMDk2MDApOwogICAgICAgICAgICAKCiAgICAgICAgICAgIG1hcmtlcl80MmE4MThhOTkxMmE0M2I3ODQ4NTJiMWVjYTAzMjUwMy5iaW5kUG9wdXAocG9wdXBfNjA4ZjM3OWQ4NTE3NDA0YWIyYWIwZjU1Yzg0MjVlNDYpCiAgICAgICAgICAgIDsKCiAgICAgICAgICAgIAogICAgICAgIAogICAgCiAgICAgICAgdmFyIG1hcmtlcl81YTM4YjJlMDMxMzk0MDkyYjczYWMyZTlhMTE3OWFjZSA9IEwubWFya2VyKAogICAgICAgICAgICBbNDAuMjExMzg5LCAtMTA1LjI1MDk1Ml0sCiAgICAgICAgICAgIHsKICAgICAgICAgICAgICAgIGljb246IG5ldyBMLkljb24uRGVmYXVsdCgpCiAgICAgICAgICAgICAgICB9CiAgICAgICAgICAgICkuYWRkVG8obWFya2VyX2NsdXN0ZXJfZGYyOWYxNjY5MDZkNDRiMTk2ZTA5ZGE5YWMzZTQyMjIpOwogICAgICAgIAogICAgCiAgICAgICAgICAgIHZhciBwb3B1cF81ZGI5NzI3MDg0ODE0MzRhYjYwYjA1NDA4ZWIxOGY3OCA9IEwucG9wdXAoe21heFdpZHRoOiAnMzAwJwogICAgICAgICAgICAKICAgICAgICAgICAgfSk7CgogICAgICAgICAgICAKICAgICAgICAgICAgICAgIHZhciBodG1sXzkyMGQ3MzA0YmY0NDQzN2Y5N2U5MDQ2YzI4NWE2NjNhID0gJCgnPGRpdiBpZD0iaHRtbF85MjBkNzMwNGJmNDQ0MzdmOTdlOTA0NmMyODVhNjYzYSIgc3R5bGU9IndpZHRoOiAxMDAuMCU7IGhlaWdodDogMTAwLjAlOyI+TmFtZTogU01FQUQgRElUQ0ggUHJlY2lwOiAwLjcxPC9kaXY+JylbMF07CiAgICAgICAgICAgICAgICBwb3B1cF81ZGI5NzI3MDg0ODE0MzRhYjYwYjA1NDA4ZWIxOGY3OC5zZXRDb250ZW50KGh0bWxfOTIwZDczMDRiZjQ0NDM3Zjk3ZTkwNDZjMjg1YTY2M2EpOwogICAgICAgICAgICAKCiAgICAgICAgICAgIG1hcmtlcl81YTM4YjJlMDMxMzk0MDkyYjczYWMyZTlhMTE3OWFjZS5iaW5kUG9wdXAocG9wdXBfNWRiOTcyNzA4NDgxNDM0YWI2MGIwNTQwOGViMThmNzgpCiAgICAgICAgICAgIDsKCiAgICAgICAgICAgIAogICAgICAgIAogICAgCiAgICAgICAgdmFyIG1hcmtlcl80NWZjMjQ1MDA4MzU0OGM4YThiYWRhYzVhMTU2YzBkOCA9IEwubWFya2VyKAogICAgICAgICAgICBbNDAuMTcwOTk4LCAtMTA1LjE2MDg3Nl0sCiAgICAgICAgICAgIHsKICAgICAgICAgICAgICAgIGljb246IG5ldyBMLkljb24uRGVmYXVsdCgpCiAgICAgICAgICAgICAgICB9CiAgICAgICAgICAgICkuYWRkVG8obWFya2VyX2NsdXN0ZXJfZGYyOWYxNjY5MDZkNDRiMTk2ZTA5ZGE5YWMzZTQyMjIpOwogICAgICAgIAogICAgCiAgICAgICAgICAgIHZhciBwb3B1cF8wMGVkZTQ5ZTIxZWE0ZTBjYWQ4YjZkZTQ2NjAyNmUyNyA9IEwucG9wdXAoe21heFdpZHRoOiAnMzAwJwogICAgICAgICAgICAKICAgICAgICAgICAgfSk7CgogICAgICAgICAgICAKICAgICAgICAgICAgICAgIHZhciBodG1sXzVhYzZhYmZiNTk1NjQ4YzdhZDg5Y2JkMGU3MzJiNGMyID0gJCgnPGRpdiBpZD0iaHRtbF81YWM2YWJmYjU5NTY0OGM3YWQ4OWNiZDBlNzMyYjRjMiIgc3R5bGU9IndpZHRoOiAxMDAuMCU7IGhlaWdodDogMTAwLjAlOyI+TmFtZTogU09VVEggRkxBVCBESVRDSCBQcmVjaXA6IDAuMzg8L2Rpdj4nKVswXTsKICAgICAgICAgICAgICAgIHBvcHVwXzAwZWRlNDllMjFlYTRlMGNhZDhiNmRlNDY2MDI2ZTI3LnNldENvbnRlbnQoaHRtbF81YWM2YWJmYjU5NTY0OGM3YWQ4OWNiZDBlNzMyYjRjMik7CiAgICAgICAgICAgIAoKICAgICAgICAgICAgbWFya2VyXzQ1ZmMyNDUwMDgzNTQ4YzhhOGJhZGFjNWExNTZjMGQ4LmJpbmRQb3B1cChwb3B1cF8wMGVkZTQ5ZTIxZWE0ZTBjYWQ4YjZkZTQ2NjAyNmUyNykKICAgICAgICAgICAgOwoKICAgICAgICAgICAgCiAgICAgICAgCiAgICAKICAgICAgICB2YXIgbWFya2VyXzM4NGRjMWNiYTUxMzQwMDg4ZDMyOGMxODU2YjliNmMwID0gTC5tYXJrZXIoCiAgICAgICAgICAgIFs0MC4yMTkwNDYsIC0xMDUuMjU5Nzk1XSwKICAgICAgICAgICAgewogICAgICAgICAgICAgICAgaWNvbjogbmV3IEwuSWNvbi5EZWZhdWx0KCkKICAgICAgICAgICAgICAgIH0KICAgICAgICAgICAgKS5hZGRUbyhtYXJrZXJfY2x1c3Rlcl9kZjI5ZjE2NjkwNmQ0NGIxOTZlMDlkYTlhYzNlNDIyMik7CiAgICAgICAgCiAgICAKICAgICAgICAgICAgdmFyIHBvcHVwX2NhNjI5ODdjOTVmZjQzYzE5OGVhZTM1OTk0NWE5NmZhID0gTC5wb3B1cCh7bWF4V2lkdGg6ICczMDAnCiAgICAgICAgICAgIAogICAgICAgICAgICB9KTsKCiAgICAgICAgICAgIAogICAgICAgICAgICAgICAgdmFyIGh0bWxfY2IyNzg5ZTZmNmZiNGE5NGFhMjA4ZTdhMzVhZjhhNTggPSAkKCc8ZGl2IGlkPSJodG1sX2NiMjc4OWU2ZjZmYjRhOTRhYTIwOGU3YTM1YWY4YTU4IiBzdHlsZT0id2lkdGg6IDEwMC4wJTsgaGVpZ2h0OiAxMDAuMCU7Ij5OYW1lOiBTVVBQTFkgRElUQ0ggUHJlY2lwOiAxNi45MzwvZGl2PicpWzBdOwogICAgICAgICAgICAgICAgcG9wdXBfY2E2Mjk4N2M5NWZmNDNjMTk4ZWFlMzU5OTQ1YTk2ZmEuc2V0Q29udGVudChodG1sX2NiMjc4OWU2ZjZmYjRhOTRhYTIwOGU3YTM1YWY4YTU4KTsKICAgICAgICAgICAgCgogICAgICAgICAgICBtYXJrZXJfMzg0ZGMxY2JhNTEzNDAwODhkMzI4YzE4NTZiOWI2YzAuYmluZFBvcHVwKHBvcHVwX2NhNjI5ODdjOTVmZjQzYzE5OGVhZTM1OTk0NWE5NmZhKQogICAgICAgICAgICA7CgogICAgICAgICAgICAKICAgICAgICAKICAgIAogICAgICAgIHZhciBtYXJrZXJfYTQxOWJhYTYxNGUzNDg1ODljMjE2Y2VmODRhNmNiNWEgPSBMLm1hcmtlcigKICAgICAgICAgICAgWzQwLjIxMTA4MywgLTEwNS4yNTA5MjddLAogICAgICAgICAgICB7CiAgICAgICAgICAgICAgICBpY29uOiBuZXcgTC5JY29uLkRlZmF1bHQoKQogICAgICAgICAgICAgICAgfQogICAgICAgICAgICApLmFkZFRvKG1hcmtlcl9jbHVzdGVyX2RmMjlmMTY2OTA2ZDQ0YjE5NmUwOWRhOWFjM2U0MjIyKTsKICAgICAgICAKICAgIAogICAgICAgICAgICB2YXIgcG9wdXBfNDI5OWZiNGM3YmU4NDVjYWE0MTY2M2NkNjc0NGMzNDcgPSBMLnBvcHVwKHttYXhXaWR0aDogJzMwMCcKICAgICAgICAgICAgCiAgICAgICAgICAgIH0pOwoKICAgICAgICAgICAgCiAgICAgICAgICAgICAgICB2YXIgaHRtbF8yM2U1MWVjYTEyZjg0ODBmYjUyODkyYTQ0YzY1MTA5NSA9ICQoJzxkaXYgaWQ9Imh0bWxfMjNlNTFlY2ExMmY4NDgwZmI1Mjg5MmE0NGM2NTEwOTUiIHN0eWxlPSJ3aWR0aDogMTAwLjAlOyBoZWlnaHQ6IDEwMC4wJTsiPk5hbWU6IFNXRURFIERJVENIIFByZWNpcDogMC4wMDwvZGl2PicpWzBdOwogICAgICAgICAgICAgICAgcG9wdXBfNDI5OWZiNGM3YmU4NDVjYWE0MTY2M2NkNjc0NGMzNDcuc2V0Q29udGVudChodG1sXzIzZTUxZWNhMTJmODQ4MGZiNTI4OTJhNDRjNjUxMDk1KTsKICAgICAgICAgICAgCgogICAgICAgICAgICBtYXJrZXJfYTQxOWJhYTYxNGUzNDg1ODljMjE2Y2VmODRhNmNiNWEuYmluZFBvcHVwKHBvcHVwXzQyOTlmYjRjN2JlODQ1Y2FhNDE2NjNjZDY3NDRjMzQ3KQogICAgICAgICAgICA7CgogICAgICAgICAgICAKICAgICAgICAKICAgIAogICAgICAgIHZhciBtYXJrZXJfZTI0ODRlOWIyMTZmNDdhMGE2ZDlkNzAwN2E4ZTVlNGQgPSBMLm1hcmtlcigKICAgICAgICAgICAgWzQwLjE5MzAxOSwgLTEwNS4yMTAzODhdLAogICAgICAgICAgICB7CiAgICAgICAgICAgICAgICBpY29uOiBuZXcgTC5JY29uLkRlZmF1bHQoKQogICAgICAgICAgICAgICAgfQogICAgICAgICAgICApLmFkZFRvKG1hcmtlcl9jbHVzdGVyX2RmMjlmMTY2OTA2ZDQ0YjE5NmUwOWRhOWFjM2U0MjIyKTsKICAgICAgICAKICAgIAogICAgICAgICAgICB2YXIgcG9wdXBfMDUzM2IzNjg0ODBkNDg4OGJhZGM2NjE5YmFhZTRkNTIgPSBMLnBvcHVwKHttYXhXaWR0aDogJzMwMCcKICAgICAgICAgICAgCiAgICAgICAgICAgIH0pOwoKICAgICAgICAgICAgCiAgICAgICAgICAgICAgICB2YXIgaHRtbF9lNTc2MDg0NjRhMzY0ZGI1YTI3MmY3NGIyYTZiYzc0OSA9ICQoJzxkaXYgaWQ9Imh0bWxfZTU3NjA4NDY0YTM2NGRiNWEyNzJmNzRiMmE2YmM3NDkiIHN0eWxlPSJ3aWR0aDogMTAwLjAlOyBoZWlnaHQ6IDEwMC4wJTsiPk5hbWU6IFRSVUUgQU5EIFdFQlNURVIgRElUQ0ggUHJlY2lwOiAwLjAzPC9kaXY+JylbMF07CiAgICAgICAgICAgICAgICBwb3B1cF8wNTMzYjM2ODQ4MGQ0ODg4YmFkYzY2MTliYWFlNGQ1Mi5zZXRDb250ZW50KGh0bWxfZTU3NjA4NDY0YTM2NGRiNWEyNzJmNzRiMmE2YmM3NDkpOwogICAgICAgICAgICAKCiAgICAgICAgICAgIG1hcmtlcl9lMjQ4NGU5YjIxNmY0N2EwYTZkOWQ3MDA3YThlNWU0ZC5iaW5kUG9wdXAocG9wdXBfMDUzM2IzNjg0ODBkNDg4OGJhZGM2NjE5YmFhZTRkNTIpCiAgICAgICAgICAgIDsKCiAgICAgICAgICAgIAogICAgICAgIAogICAgCiAgICAgICAgdmFyIG1hcmtlcl9lM2M2MTc3MTJlY2M0YjNlYTY4ODNlOTgyMWJlNzc2ZiA9IEwubWFya2VyKAogICAgICAgICAgICBbNDAuMTkzMjgsIC0xMDUuMjEwNDI0XSwKICAgICAgICAgICAgewogICAgICAgICAgICAgICAgaWNvbjogbmV3IEwuSWNvbi5EZWZhdWx0KCkKICAgICAgICAgICAgICAgIH0KICAgICAgICAgICAgKS5hZGRUbyhtYXJrZXJfY2x1c3Rlcl9kZjI5ZjE2NjkwNmQ0NGIxOTZlMDlkYTlhYzNlNDIyMik7CiAgICAgICAgCiAgICAKICAgICAgICAgICAgdmFyIHBvcHVwXzJlYTU0NjA2MjBjYjQ1ZmQ4MjVhNGI5MjQzZTIzMDRkID0gTC5wb3B1cCh7bWF4V2lkdGg6ICczMDAnCiAgICAgICAgICAgIAogICAgICAgICAgICB9KTsKCiAgICAgICAgICAgIAogICAgICAgICAgICAgICAgdmFyIGh0bWxfY2Y0ZjI0OThlNTFlNDI3ZDk1YjkyMjFkNjBkYzRmZTcgPSAkKCc8ZGl2IGlkPSJodG1sX2NmNGYyNDk4ZTUxZTQyN2Q5NWI5MjIxZDYwZGM0ZmU3IiBzdHlsZT0id2lkdGg6IDEwMC4wJTsgaGVpZ2h0OiAxMDAuMCU7Ij5OYW1lOiBXRUJTVEVSIE1DQ0FTTElOIERJVENIIFByZWNpcDogMC4wMTwvZGl2PicpWzBdOwogICAgICAgICAgICAgICAgcG9wdXBfMmVhNTQ2MDYyMGNiNDVmZDgyNWE0YjkyNDNlMjMwNGQuc2V0Q29udGVudChodG1sX2NmNGYyNDk4ZTUxZTQyN2Q5NWI5MjIxZDYwZGM0ZmU3KTsKICAgICAgICAgICAgCgogICAgICAgICAgICBtYXJrZXJfZTNjNjE3NzEyZWNjNGIzZWE2ODgzZTk4MjFiZTc3NmYuYmluZFBvcHVwKHBvcHVwXzJlYTU0NjA2MjBjYjQ1ZmQ4MjVhNGI5MjQzZTIzMDRkKQogICAgICAgICAgICA7CgogICAgICAgICAgICAKICAgICAgICAKICAgIAogICAgICAgIHZhciBtYXJrZXJfNGQ5MGMxZTk3ODUxNDg4ODkzMDZiNzBjYjFkMmFlNmMgPSBMLm1hcmtlcigKICAgICAgICAgICAgWzQwLjE4NTAzMywgLTEwNS4xODU3ODldLAogICAgICAgICAgICB7CiAgICAgICAgICAgICAgICBpY29uOiBuZXcgTC5JY29uLkRlZmF1bHQoKQogICAgICAgICAgICAgICAgfQogICAgICAgICAgICApLmFkZFRvKG1hcmtlcl9jbHVzdGVyX2RmMjlmMTY2OTA2ZDQ0YjE5NmUwOWRhOWFjM2U0MjIyKTsKICAgICAgICAKICAgIAogICAgICAgICAgICB2YXIgcG9wdXBfODQ5NzY4NjM5YWY2NDcwNzhlMWE1MWEzODMzZGM2ZjkgPSBMLnBvcHVwKHttYXhXaWR0aDogJzMwMCcKICAgICAgICAgICAgCiAgICAgICAgICAgIH0pOwoKICAgICAgICAgICAgCiAgICAgICAgICAgICAgICB2YXIgaHRtbF8xM2E3MzY3MWE3NTg0Zjk2YTJiYzdlOWFmMjc4MzM0MCA9ICQoJzxkaXYgaWQ9Imh0bWxfMTNhNzM2NzFhNzU4NGY5NmEyYmM3ZTlhZjI3ODMzNDAiIHN0eWxlPSJ3aWR0aDogMTAwLjAlOyBoZWlnaHQ6IDEwMC4wJTsiPk5hbWU6IFpXRUNLIEFORCBUVVJORVIgRElUQ0ggUHJlY2lwOiAwLjEwPC9kaXY+JylbMF07CiAgICAgICAgICAgICAgICBwb3B1cF84NDk3Njg2MzlhZjY0NzA3OGUxYTUxYTM4MzNkYzZmOS5zZXRDb250ZW50KGh0bWxfMTNhNzM2NzFhNzU4NGY5NmEyYmM3ZTlhZjI3ODMzNDApOwogICAgICAgICAgICAKCiAgICAgICAgICAgIG1hcmtlcl80ZDkwYzFlOTc4NTE0ODg4OTMwNmI3MGNiMWQyYWU2Yy5iaW5kUG9wdXAocG9wdXBfODQ5NzY4NjM5YWY2NDcwNzhlMWE1MWEzODMzZGM2ZjkpCiAgICAgICAgICAgIDsKCiAgICAgICAgICAgIAogICAgICAgIAogICAgCiAgICAgICAgdmFyIG1hcmtlcl8xMjU1ZDRkNjI0MmE0M2FmYjVhYTVhZWVkYmU3YTgwNiA9IEwubWFya2VyKAogICAgICAgICAgICBbNDAuMDU5ODA5LCAtMTA1LjA5Nzg3Ml0sCiAgICAgICAgICAgIHsKICAgICAgICAgICAgICAgIGljb246IG5ldyBMLkljb24uRGVmYXVsdCgpCiAgICAgICAgICAgICAgICB9CiAgICAgICAgICAgICkuYWRkVG8obWFya2VyX2NsdXN0ZXJfZGYyOWYxNjY5MDZkNDRiMTk2ZTA5ZGE5YWMzZTQyMjIpOwogICAgICAgIAogICAgCiAgICAgICAgICAgIHZhciBwb3B1cF81M2I2YjhmMmE4MWY0NjFlYmFiN2JkNDFkN2VhMDA5MCA9IEwucG9wdXAoe21heFdpZHRoOiAnMzAwJwogICAgICAgICAgICAKICAgICAgICAgICAgfSk7CgogICAgICAgICAgICAKICAgICAgICAgICAgICAgIHZhciBodG1sXzQ5OTMyOTE5M2E1OTRhZjQ5YmE4N2FjN2I4Y2NiYWYzID0gJCgnPGRpdiBpZD0iaHRtbF80OTkzMjkxOTNhNTk0YWY0OWJhODdhYzdiOGNjYmFmMyIgc3R5bGU9IndpZHRoOiAxMDAuMCU7IGhlaWdodDogMTAwLjAlOyI+TmFtZTogQk9VTERFUiBDUkVFSyBBVCAxMDkgU1QgTkVBUiBFUklFLCBDTyBQcmVjaXA6IDQzLjUwPC9kaXY+JylbMF07CiAgICAgICAgICAgICAgICBwb3B1cF81M2I2YjhmMmE4MWY0NjFlYmFiN2JkNDFkN2VhMDA5MC5zZXRDb250ZW50KGh0bWxfNDk5MzI5MTkzYTU5NGFmNDliYTg3YWM3YjhjY2JhZjMpOwogICAgICAgICAgICAKCiAgICAgICAgICAgIG1hcmtlcl8xMjU1ZDRkNjI0MmE0M2FmYjVhYTVhZWVkYmU3YTgwNi5iaW5kUG9wdXAocG9wdXBfNTNiNmI4ZjJhODFmNDYxZWJhYjdiZDQxZDdlYTAwOTApCiAgICAgICAgICAgIDsKCiAgICAgICAgICAgIAogICAgICAgIAogICAgCiAgICAgICAgdmFyIG1hcmtlcl84ZWRiNjUxYThkYzk0OTE5YWZmMmRlZjJhOGM2NmJjOCA9IEwubWFya2VyKAogICAgICAgICAgICBbNDAuMDUxNjUyLCAtMTA1LjE3ODg3NV0sCiAgICAgICAgICAgIHsKICAgICAgICAgICAgICAgIGljb246IG5ldyBMLkljb24uRGVmYXVsdCgpCiAgICAgICAgICAgICAgICB9CiAgICAgICAgICAgICkuYWRkVG8obWFya2VyX2NsdXN0ZXJfZGYyOWYxNjY5MDZkNDRiMTk2ZTA5ZGE5YWMzZTQyMjIpOwogICAgICAgIAogICAgCiAgICAgICAgICAgIHZhciBwb3B1cF9lMjZjNzI2ZWVjZDY0Y2MwYjllYzY1ZmJkZWU0MjU2MyA9IEwucG9wdXAoe21heFdpZHRoOiAnMzAwJwogICAgICAgICAgICAKICAgICAgICAgICAgfSk7CgogICAgICAgICAgICAKICAgICAgICAgICAgICAgIHZhciBodG1sXzUwMjE1NTdiOWM2NDQ4YWE5ZmVkNGRiOWE3YzI3NGZjID0gJCgnPGRpdiBpZD0iaHRtbF81MDIxNTU3YjljNjQ0OGFhOWZlZDRkYjlhN2MyNzRmYyIgc3R5bGU9IndpZHRoOiAxMDAuMCU7IGhlaWdodDogMTAwLjAlOyI+TmFtZTogQk9VTERFUiBDUkVFSyBBVCBOT1JUSCA3NVRIIFNUUkVFVCBORUFSIEJPVUxERVIgUHJlY2lwOiAyNi44MDwvZGl2PicpWzBdOwogICAgICAgICAgICAgICAgcG9wdXBfZTI2YzcyNmVlY2Q2NGNjMGI5ZWM2NWZiZGVlNDI1NjMuc2V0Q29udGVudChodG1sXzUwMjE1NTdiOWM2NDQ4YWE5ZmVkNGRiOWE3YzI3NGZjKTsKICAgICAgICAgICAgCgogICAgICAgICAgICBtYXJrZXJfOGVkYjY1MWE4ZGM5NDkxOWFmZjJkZWYyYThjNjZiYzguYmluZFBvcHVwKHBvcHVwX2UyNmM3MjZlZWNkNjRjYzBiOWVjNjVmYmRlZTQyNTYzKQogICAgICAgICAgICA7CgogICAgICAgICAgICAKICAgICAgICAKICAgIAogICAgICAgIHZhciBtYXJrZXJfMTU4MmEyNzM0ZTBjNDYzYzg1MmNlMzEwMzU0ODVlZTYgPSBMLm1hcmtlcigKICAgICAgICAgICAgWzQwLjA1MzAzNSwgLTEwNS4xOTMwNDhdLAogICAgICAgICAgICB7CiAgICAgICAgICAgICAgICBpY29uOiBuZXcgTC5JY29uLkRlZmF1bHQoKQogICAgICAgICAgICAgICAgfQogICAgICAgICAgICApLmFkZFRvKG1hcmtlcl9jbHVzdGVyX2RmMjlmMTY2OTA2ZDQ0YjE5NmUwOWRhOWFjM2U0MjIyKTsKICAgICAgICAKICAgIAogICAgICAgICAgICB2YXIgcG9wdXBfNWY3ZDI5YjM5MjFjNDhiYzgyNzcxMzRkMGE0NTM5YWMgPSBMLnBvcHVwKHttYXhXaWR0aDogJzMwMCcKICAgICAgICAgICAgCiAgICAgICAgICAgIH0pOwoKICAgICAgICAgICAgCiAgICAgICAgICAgICAgICB2YXIgaHRtbF83NDU0NTg3N2U4YjM0MmU0OGFlMGYyNzlmOGQ4YTczNyA9ICQoJzxkaXYgaWQ9Imh0bWxfNzQ1NDU4NzdlOGIzNDJlNDhhZTBmMjc5ZjhkOGE3MzciIHN0eWxlPSJ3aWR0aDogMTAwLjAlOyBoZWlnaHQ6IDEwMC4wJTsiPk5hbWU6IEJPVUxERVIgQ1JFRUsgU1VQUExZIENBTkFMIFRPIEJPVUxERVIgQ1JFRUsgTkVBUiBCT1VMREVSIFByZWNpcDogMC45OTwvZGl2PicpWzBdOwogICAgICAgICAgICAgICAgcG9wdXBfNWY3ZDI5YjM5MjFjNDhiYzgyNzcxMzRkMGE0NTM5YWMuc2V0Q29udGVudChodG1sXzc0NTQ1ODc3ZThiMzQyZTQ4YWUwZjI3OWY4ZDhhNzM3KTsKICAgICAgICAgICAgCgogICAgICAgICAgICBtYXJrZXJfMTU4MmEyNzM0ZTBjNDYzYzg1MmNlMzEwMzU0ODVlZTYuYmluZFBvcHVwKHBvcHVwXzVmN2QyOWIzOTIxYzQ4YmM4Mjc3MTM0ZDBhNDUzOWFjKQogICAgICAgICAgICA7CgogICAgICAgICAgICAKICAgICAgICAKICAgIAogICAgICAgIHZhciBtYXJrZXJfODQ4ODI3YzkzOTJmNGNmZjg4ODk4MTQxYzY4OGVjOTAgPSBMLm1hcmtlcigKICAgICAgICAgICAgWzQwLjA3ODU2LCAtMTA1LjIyMDQ5N10sCiAgICAgICAgICAgIHsKICAgICAgICAgICAgICAgIGljb246IG5ldyBMLkljb24uRGVmYXVsdCgpCiAgICAgICAgICAgICAgICB9CiAgICAgICAgICAgICkuYWRkVG8obWFya2VyX2NsdXN0ZXJfZGYyOWYxNjY5MDZkNDRiMTk2ZTA5ZGE5YWMzZTQyMjIpOwogICAgICAgIAogICAgCiAgICAgICAgICAgIHZhciBwb3B1cF9jZjAyODAzNThhYTM0ZmNhODJkZDBkZTI5ZWU3MzlhMyA9IEwucG9wdXAoe21heFdpZHRoOiAnMzAwJwogICAgICAgICAgICAKICAgICAgICAgICAgfSk7CgogICAgICAgICAgICAKICAgICAgICAgICAgICAgIHZhciBodG1sX2MxNTdlMmZhNTU0NjRiNzVhZDg0Y2I3MmQxNzE0MWJhID0gJCgnPGRpdiBpZD0iaHRtbF9jMTU3ZTJmYTU1NDY0Yjc1YWQ4NGNiNzJkMTcxNDFiYSIgc3R5bGU9IndpZHRoOiAxMDAuMCU7IGhlaWdodDogMTAwLjAlOyI+TmFtZTogQk9VTERFUiBSRVNFUlZPSVIgUHJlY2lwOiA3OTY3LjAwPC9kaXY+JylbMF07CiAgICAgICAgICAgICAgICBwb3B1cF9jZjAyODAzNThhYTM0ZmNhODJkZDBkZTI5ZWU3MzlhMy5zZXRDb250ZW50KGh0bWxfYzE1N2UyZmE1NTQ2NGI3NWFkODRjYjcyZDE3MTQxYmEpOwogICAgICAgICAgICAKCiAgICAgICAgICAgIG1hcmtlcl84NDg4MjdjOTM5MmY0Y2ZmODg4OTgxNDFjNjg4ZWM5MC5iaW5kUG9wdXAocG9wdXBfY2YwMjgwMzU4YWEzNGZjYTgyZGQwZGUyOWVlNzM5YTMpCiAgICAgICAgICAgIDsKCiAgICAgICAgICAgIAogICAgICAgIAogICAgCiAgICAgICAgdmFyIG1hcmtlcl8xMjk5NzRkYWU5N2Q0MGE1OGE0YWYyZGIxMjZiZmMxZSA9IEwubWFya2VyKAogICAgICAgICAgICBbNDAuMDg2Mjc4LCAtMTA1LjIxNzUxOV0sCiAgICAgICAgICAgIHsKICAgICAgICAgICAgICAgIGljb246IG5ldyBMLkljb24uRGVmYXVsdCgpCiAgICAgICAgICAgICAgICB9CiAgICAgICAgICAgICkuYWRkVG8obWFya2VyX2NsdXN0ZXJfZGYyOWYxNjY5MDZkNDRiMTk2ZTA5ZGE5YWMzZTQyMjIpOwogICAgICAgIAogICAgCiAgICAgICAgICAgIHZhciBwb3B1cF9mOGM2MzMxOWUzMzc0ZmYyOWVhNDhjZGEwNjVmYjRkZSA9IEwucG9wdXAoe21heFdpZHRoOiAnMzAwJwogICAgICAgICAgICAKICAgICAgICAgICAgfSk7CgogICAgICAgICAgICAKICAgICAgICAgICAgICAgIHZhciBodG1sXzY5NmQ2YzZiMzZkMjQ2MTE5NTg1ZGI0M2FhYTM1ZjI2ID0gJCgnPGRpdiBpZD0iaHRtbF82OTZkNmM2YjM2ZDI0NjExOTU4NWRiNDNhYWEzNWYyNiIgc3R5bGU9IndpZHRoOiAxMDAuMCU7IGhlaWdodDogMTAwLjAlOyI+TmFtZTogQk9VTERFUiBSRVNFUlZPSVIgSU5MRVQgUHJlY2lwOiAxLjMwPC9kaXY+JylbMF07CiAgICAgICAgICAgICAgICBwb3B1cF9mOGM2MzMxOWUzMzc0ZmYyOWVhNDhjZGEwNjVmYjRkZS5zZXRDb250ZW50KGh0bWxfNjk2ZDZjNmIzNmQyNDYxMTk1ODVkYjQzYWFhMzVmMjYpOwogICAgICAgICAgICAKCiAgICAgICAgICAgIG1hcmtlcl8xMjk5NzRkYWU5N2Q0MGE1OGE0YWYyZGIxMjZiZmMxZS5iaW5kUG9wdXAocG9wdXBfZjhjNjMzMTllMzM3NGZmMjllYTQ4Y2RhMDY1ZmI0ZGUpCiAgICAgICAgICAgIDsKCiAgICAgICAgICAgIAogICAgICAgIAogICAgCiAgICAgICAgdmFyIG1hcmtlcl80NzUxYzE4NjdkMTI0NzU0YjEyMTAxYTE2NjcwM2QwZSA9IEwubWFya2VyKAogICAgICAgICAgICBbMzkuOTg2MTY5LCAtMTA1LjIxODY3N10sCiAgICAgICAgICAgIHsKICAgICAgICAgICAgICAgIGljb246IG5ldyBMLkljb24uRGVmYXVsdCgpCiAgICAgICAgICAgICAgICB9CiAgICAgICAgICAgICkuYWRkVG8obWFya2VyX2NsdXN0ZXJfZGYyOWYxNjY5MDZkNDRiMTk2ZTA5ZGE5YWMzZTQyMjIpOwogICAgICAgIAogICAgCiAgICAgICAgICAgIHZhciBwb3B1cF84NmY2NjA5MTFiY2Q0YjI2ODg0NGNlODc0ODk5OTE3OSA9IEwucG9wdXAoe21heFdpZHRoOiAnMzAwJwogICAgICAgICAgICAKICAgICAgICAgICAgfSk7CgogICAgICAgICAgICAKICAgICAgICAgICAgICAgIHZhciBodG1sX2MxZjUyMmQ3MTdiNDQwYmFhMDVhMmUxZjM4MTcyM2RkID0gJCgnPGRpdiBpZD0iaHRtbF9jMWY1MjJkNzE3YjQ0MGJhYTA1YTJlMWYzODE3MjNkZCIgc3R5bGU9IndpZHRoOiAxMDAuMCU7IGhlaWdodDogMTAwLjAlOyI+TmFtZTogRFJZIENSRUVLIENBUlJJRVIgUHJlY2lwOiAyLjc2PC9kaXY+JylbMF07CiAgICAgICAgICAgICAgICBwb3B1cF84NmY2NjA5MTFiY2Q0YjI2ODg0NGNlODc0ODk5OTE3OS5zZXRDb250ZW50KGh0bWxfYzFmNTIyZDcxN2I0NDBiYWEwNWEyZTFmMzgxNzIzZGQpOwogICAgICAgICAgICAKCiAgICAgICAgICAgIG1hcmtlcl80NzUxYzE4NjdkMTI0NzU0YjEyMTAxYTE2NjcwM2QwZS5iaW5kUG9wdXAocG9wdXBfODZmNjYwOTExYmNkNGIyNjg4NDRjZTg3NDg5OTkxNzkpCiAgICAgICAgICAgIDsKCiAgICAgICAgICAgIAogICAgICAgIAogICAgCiAgICAgICAgdmFyIG1hcmtlcl9mZTk2YjZiZmVlMTU0MWFmYWYxMmExYzNiYTI1MDQ5MCA9IEwubWFya2VyKAogICAgICAgICAgICBbNDAuMDQyMDI4LCAtMTA1LjM2NDkxN10sCiAgICAgICAgICAgIHsKICAgICAgICAgICAgICAgIGljb246IG5ldyBMLkljb24uRGVmYXVsdCgpCiAgICAgICAgICAgICAgICB9CiAgICAgICAgICAgICkuYWRkVG8obWFya2VyX2NsdXN0ZXJfZGYyOWYxNjY5MDZkNDRiMTk2ZTA5ZGE5YWMzZTQyMjIpOwogICAgICAgIAogICAgCiAgICAgICAgICAgIHZhciBwb3B1cF8wZTNlYzUwN2MxY2E0MjE5YTBhYzA1ZGViZDcwNmZiOCA9IEwucG9wdXAoe21heFdpZHRoOiAnMzAwJwogICAgICAgICAgICAKICAgICAgICAgICAgfSk7CgogICAgICAgICAgICAKICAgICAgICAgICAgICAgIHZhciBodG1sXzQzNjY3MzNlNGIwMDRjYjM5ZGJjYmZlNjFmMjMyNjA3ID0gJCgnPGRpdiBpZD0iaHRtbF80MzY2NzMzZTRiMDA0Y2IzOWRiY2JmZTYxZjIzMjYwNyIgc3R5bGU9IndpZHRoOiAxMDAuMCU7IGhlaWdodDogMTAwLjAlOyI+TmFtZTogRk9VUiBNSUxFIENSRUVLIEFUIExPR0FOIE1JTEwgUk9BRCBORUFSIENSSVNNQU4sIENPIFByZWNpcDogbmFuPC9kaXY+JylbMF07CiAgICAgICAgICAgICAgICBwb3B1cF8wZTNlYzUwN2MxY2E0MjE5YTBhYzA1ZGViZDcwNmZiOC5zZXRDb250ZW50KGh0bWxfNDM2NjczM2U0YjAwNGNiMzlkYmNiZmU2MWYyMzI2MDcpOwogICAgICAgICAgICAKCiAgICAgICAgICAgIG1hcmtlcl9mZTk2YjZiZmVlMTU0MWFmYWYxMmExYzNiYTI1MDQ5MC5iaW5kUG9wdXAocG9wdXBfMGUzZWM1MDdjMWNhNDIxOWEwYWMwNWRlYmQ3MDZmYjgpCiAgICAgICAgICAgIDsKCiAgICAgICAgICAgIAogICAgICAgIAogICAgCiAgICAgICAgdmFyIG1hcmtlcl83MWYzMGY0MGU3YmQ0NjNkYjRmMDE4YTQ2NWE0OGNhOSA9IEwubWFya2VyKAogICAgICAgICAgICBbNDAuMDE4NjY3LCAtMTA1LjMyNjI1XSwKICAgICAgICAgICAgewogICAgICAgICAgICAgICAgaWNvbjogbmV3IEwuSWNvbi5EZWZhdWx0KCkKICAgICAgICAgICAgICAgIH0KICAgICAgICAgICAgKS5hZGRUbyhtYXJrZXJfY2x1c3Rlcl9kZjI5ZjE2NjkwNmQ0NGIxOTZlMDlkYTlhYzNlNDIyMik7CiAgICAgICAgCiAgICAKICAgICAgICAgICAgdmFyIHBvcHVwX2IyOWQxYzFhNWVlNTQ1MTA5NmM4Zjg4MjZkOTEzNTRlID0gTC5wb3B1cCh7bWF4V2lkdGg6ICczMDAnCiAgICAgICAgICAgIAogICAgICAgICAgICB9KTsKCiAgICAgICAgICAgIAogICAgICAgICAgICAgICAgdmFyIGh0bWxfOWM5NDA0OGQ5NzY3NGVkMzhiOGIyNWQ0NTQ2YTA5MGQgPSAkKCc8ZGl2IGlkPSJodG1sXzljOTQwNDhkOTc2NzRlZDM4YjhiMjVkNDU0NmEwOTBkIiBzdHlsZT0id2lkdGg6IDEwMC4wJTsgaGVpZ2h0OiAxMDAuMCU7Ij5OYW1lOiBGT1VSTUlMRSBDUkVFSyBBVCBPUk9ERUxMLCBDTy4gUHJlY2lwOiAwLjQ1PC9kaXY+JylbMF07CiAgICAgICAgICAgICAgICBwb3B1cF9iMjlkMWMxYTVlZTU0NTEwOTZjOGY4ODI2ZDkxMzU0ZS5zZXRDb250ZW50KGh0bWxfOWM5NDA0OGQ5NzY3NGVkMzhiOGIyNWQ0NTQ2YTA5MGQpOwogICAgICAgICAgICAKCiAgICAgICAgICAgIG1hcmtlcl83MWYzMGY0MGU3YmQ0NjNkYjRmMDE4YTQ2NWE0OGNhOS5iaW5kUG9wdXAocG9wdXBfYjI5ZDFjMWE1ZWU1NDUxMDk2YzhmODgyNmQ5MTM1NGUpCiAgICAgICAgICAgIDsKCiAgICAgICAgICAgIAogICAgICAgIAogICAgCiAgICAgICAgdmFyIG1hcmtlcl9iM2NjODFhMzA4MDY0Y2Y5ODkxMmZjMTVkNTRjMjE0OSA9IEwubWFya2VyKAogICAgICAgICAgICBbMzkuOTQ3NzA0LCAtMTA1LjM1NzMwOF0sCiAgICAgICAgICAgIHsKICAgICAgICAgICAgICAgIGljb246IG5ldyBMLkljb24uRGVmYXVsdCgpCiAgICAgICAgICAgICAgICB9CiAgICAgICAgICAgICkuYWRkVG8obWFya2VyX2NsdXN0ZXJfZGYyOWYxNjY5MDZkNDRiMTk2ZTA5ZGE5YWMzZTQyMjIpOwogICAgICAgIAogICAgCiAgICAgICAgICAgIHZhciBwb3B1cF9lM2NiNThkZGMzZGE0MjY1OWMxNGQzZmU3NGI1N2ZkYiA9IEwucG9wdXAoe21heFdpZHRoOiAnMzAwJwogICAgICAgICAgICAKICAgICAgICAgICAgfSk7CgogICAgICAgICAgICAKICAgICAgICAgICAgICAgIHZhciBodG1sX2VjOGY1Nzg0MzUyNzRmODFhODViMWM0YjAwM2M3NmQyID0gJCgnPGRpdiBpZD0iaHRtbF9lYzhmNTc4NDM1Mjc0ZjgxYTg1YjFjNGIwMDNjNzZkMiIgc3R5bGU9IndpZHRoOiAxMDAuMCU7IGhlaWdodDogMTAwLjAlOyI+TmFtZTogR1JPU1MgUkVTRVJWT0lSICBQcmVjaXA6IDMwODUxLjAwPC9kaXY+JylbMF07CiAgICAgICAgICAgICAgICBwb3B1cF9lM2NiNThkZGMzZGE0MjY1OWMxNGQzZmU3NGI1N2ZkYi5zZXRDb250ZW50KGh0bWxfZWM4ZjU3ODQzNTI3NGY4MWE4NWIxYzRiMDAzYzc2ZDIpOwogICAgICAgICAgICAKCiAgICAgICAgICAgIG1hcmtlcl9iM2NjODFhMzA4MDY0Y2Y5ODkxMmZjMTVkNTRjMjE0OS5iaW5kUG9wdXAocG9wdXBfZTNjYjU4ZGRjM2RhNDI2NTljMTRkM2ZlNzRiNTdmZGIpCiAgICAgICAgICAgIDsKCiAgICAgICAgICAgIAogICAgICAgIAogICAgCiAgICAgICAgdmFyIG1hcmtlcl85ZWI5NjdjOTk4NzA0MDM2YTNiZmZhNWMwMWRlMTA4YiA9IEwubWFya2VyKAogICAgICAgICAgICBbNDAuMDUzNjYxLCAtMTA1LjE1MTE0M10sCiAgICAgICAgICAgIHsKICAgICAgICAgICAgICAgIGljb246IG5ldyBMLkljb24uRGVmYXVsdCgpCiAgICAgICAgICAgICAgICB9CiAgICAgICAgICAgICkuYWRkVG8obWFya2VyX2NsdXN0ZXJfZGYyOWYxNjY5MDZkNDRiMTk2ZTA5ZGE5YWMzZTQyMjIpOwogICAgICAgIAogICAgCiAgICAgICAgICAgIHZhciBwb3B1cF82ZjJmMmJkODE4ZTQ0NDM5YmYyZWM0MjA2ZjhlNGI2NyA9IEwucG9wdXAoe21heFdpZHRoOiAnMzAwJwogICAgICAgICAgICAKICAgICAgICAgICAgfSk7CgogICAgICAgICAgICAKICAgICAgICAgICAgICAgIHZhciBodG1sX2Q1MWE1YzFkNDAzMTQwMDFiNWYzYTVlYjYxYWFkMzAwID0gJCgnPGRpdiBpZD0iaHRtbF9kNTFhNWMxZDQwMzE0MDAxYjVmM2E1ZWI2MWFhZDMwMCIgc3R5bGU9IndpZHRoOiAxMDAuMCU7IGhlaWdodDogMTAwLjAlOyI+TmFtZTogTEVHR0VUVCBESVRDSCBQcmVjaXA6IDAuMDA8L2Rpdj4nKVswXTsKICAgICAgICAgICAgICAgIHBvcHVwXzZmMmYyYmQ4MThlNDQ0MzliZjJlYzQyMDZmOGU0YjY3LnNldENvbnRlbnQoaHRtbF9kNTFhNWMxZDQwMzE0MDAxYjVmM2E1ZWI2MWFhZDMwMCk7CiAgICAgICAgICAgIAoKICAgICAgICAgICAgbWFya2VyXzllYjk2N2M5OTg3MDQwMzZhM2JmZmE1YzAxZGUxMDhiLmJpbmRQb3B1cChwb3B1cF82ZjJmMmJkODE4ZTQ0NDM5YmYyZWM0MjA2ZjhlNGI2NykKICAgICAgICAgICAgOwoKICAgICAgICAgICAgCiAgICAgICAgCiAgICAKICAgICAgICB2YXIgbWFya2VyX2IwMjA2ZmJjMmMyMTQ5YTA5NjU2OTIyYzhmMzlmZTRiID0gTC5tYXJrZXIoCiAgICAgICAgICAgIFszOS45NjE2NTUsIC0xMDUuNTA0NDRdLAogICAgICAgICAgICB7CiAgICAgICAgICAgICAgICBpY29uOiBuZXcgTC5JY29uLkRlZmF1bHQoKQogICAgICAgICAgICAgICAgfQogICAgICAgICAgICApLmFkZFRvKG1hcmtlcl9jbHVzdGVyX2RmMjlmMTY2OTA2ZDQ0YjE5NmUwOWRhOWFjM2U0MjIyKTsKICAgICAgICAKICAgIAogICAgICAgICAgICB2YXIgcG9wdXBfNGE5NmEzNmNhYWRmNDlhZjgyYzg0NTZlNGVhZDJlN2MgPSBMLnBvcHVwKHttYXhXaWR0aDogJzMwMCcKICAgICAgICAgICAgCiAgICAgICAgICAgIH0pOwoKICAgICAgICAgICAgCiAgICAgICAgICAgICAgICB2YXIgaHRtbF9hOTUzZTFhZDgyZGQ0NjM2YTdiODZjN2VlMmMxNjg5OCA9ICQoJzxkaXYgaWQ9Imh0bWxfYTk1M2UxYWQ4MmRkNDYzNmE3Yjg2YzdlZTJjMTY4OTgiIHN0eWxlPSJ3aWR0aDogMTAwLjAlOyBoZWlnaHQ6IDEwMC4wJTsiPk5hbWU6IE1JRERMRSBCT1VMREVSIENSRUVLIEFUIE5FREVSTEFORCBQcmVjaXA6IDguMTA8L2Rpdj4nKVswXTsKICAgICAgICAgICAgICAgIHBvcHVwXzRhOTZhMzZjYWFkZjQ5YWY4MmM4NDU2ZTRlYWQyZTdjLnNldENvbnRlbnQoaHRtbF9hOTUzZTFhZDgyZGQ0NjM2YTdiODZjN2VlMmMxNjg5OCk7CiAgICAgICAgICAgIAoKICAgICAgICAgICAgbWFya2VyX2IwMjA2ZmJjMmMyMTQ5YTA5NjU2OTIyYzhmMzlmZTRiLmJpbmRQb3B1cChwb3B1cF80YTk2YTM2Y2FhZGY0OWFmODJjODQ1NmU0ZWFkMmU3YykKICAgICAgICAgICAgOwoKICAgICAgICAgICAgCiAgICAgICAgCiAgICAKICAgICAgICB2YXIgbWFya2VyXzUzODRlNzJkMGIxYzQxMWY5YTIxNzQ2NjZjYjVkMzExID0gTC5tYXJrZXIoCiAgICAgICAgICAgIFszOS45MzgzNTEsIC0xMDUuMzQ3OTA2XSwKICAgICAgICAgICAgewogICAgICAgICAgICAgICAgaWNvbjogbmV3IEwuSWNvbi5EZWZhdWx0KCkKICAgICAgICAgICAgICAgIH0KICAgICAgICAgICAgKS5hZGRUbyhtYXJrZXJfY2x1c3Rlcl9kZjI5ZjE2NjkwNmQ0NGIxOTZlMDlkYTlhYzNlNDIyMik7CiAgICAgICAgCiAgICAKICAgICAgICAgICAgdmFyIHBvcHVwXzUyMWY0NzFiNjg0ZTRjNzg4OGUyZjczNDJlOTY1Yjk1ID0gTC5wb3B1cCh7bWF4V2lkdGg6ICczMDAnCiAgICAgICAgICAgIAogICAgICAgICAgICB9KTsKCiAgICAgICAgICAgIAogICAgICAgICAgICAgICAgdmFyIGh0bWxfODI1MTM0ZWNiODVlNDgwNGI2MmJkZGEzMTk1NjcwMDcgPSAkKCc8ZGl2IGlkPSJodG1sXzgyNTEzNGVjYjg1ZTQ4MDRiNjJiZGRhMzE5NTY3MDA3IiBzdHlsZT0id2lkdGg6IDEwMC4wJTsgaGVpZ2h0OiAxMDAuMCU7Ij5OYW1lOiBTT1VUSCBCT1VMREVSIENSRUVLIEJFTE9XIEdST1NTIFJFU0VSVk9JUiBQcmVjaXA6IDgyLjkwPC9kaXY+JylbMF07CiAgICAgICAgICAgICAgICBwb3B1cF81MjFmNDcxYjY4NGU0Yzc4ODhlMmY3MzQyZTk2NWI5NS5zZXRDb250ZW50KGh0bWxfODI1MTM0ZWNiODVlNDgwNGI2MmJkZGEzMTk1NjcwMDcpOwogICAgICAgICAgICAKCiAgICAgICAgICAgIG1hcmtlcl81Mzg0ZTcyZDBiMWM0MTFmOWEyMTc0NjY2Y2I1ZDMxMS5iaW5kUG9wdXAocG9wdXBfNTIxZjQ3MWI2ODRlNGM3ODg4ZTJmNzM0MmU5NjViOTUpCiAgICAgICAgICAgIDsKCiAgICAgICAgICAgIAogICAgICAgIAogICAgCiAgICAgICAgdmFyIG1hcmtlcl9iNjZmZjZlYTU2Yjk0YTI4ODU4ZTY0OTcyZGI0ZGNhOCA9IEwubWFya2VyKAogICAgICAgICAgICBbMzkuOTMxODEzLCAtMTA1LjMwODQzMl0sCiAgICAgICAgICAgIHsKICAgICAgICAgICAgICAgIGljb246IG5ldyBMLkljb24uRGVmYXVsdCgpCiAgICAgICAgICAgICAgICB9CiAgICAgICAgICAgICkuYWRkVG8obWFya2VyX2NsdXN0ZXJfZGYyOWYxNjY5MDZkNDRiMTk2ZTA5ZGE5YWMzZTQyMjIpOwogICAgICAgIAogICAgCiAgICAgICAgICAgIHZhciBwb3B1cF83Mzg0NmY3MTI5OWU0ZTYzYTJhYTRiZWEwNGU0ZDg5YyA9IEwucG9wdXAoe21heFdpZHRoOiAnMzAwJwogICAgICAgICAgICAKICAgICAgICAgICAgfSk7CgogICAgICAgICAgICAKICAgICAgICAgICAgICAgIHZhciBodG1sXzY1YmJiNTJlNTAzMzQ5OWI5NTFjMDI5ZTQzMTQ3ODE2ID0gJCgnPGRpdiBpZD0iaHRtbF82NWJiYjUyZTUwMzM0OTliOTUxYzAyOWU0MzE0NzgxNiIgc3R5bGU9IndpZHRoOiAxMDAuMCU7IGhlaWdodDogMTAwLjAlOyI+TmFtZTogU09VVEggQk9VTERFUiBDUkVFSyBESVZFUlNJT04gTkVBUiBFTERPUkFETyBTUFJJTkdTIFByZWNpcDogNzYuMTA8L2Rpdj4nKVswXTsKICAgICAgICAgICAgICAgIHBvcHVwXzczODQ2ZjcxMjk5ZTRlNjNhMmFhNGJlYTA0ZTRkODljLnNldENvbnRlbnQoaHRtbF82NWJiYjUyZTUwMzM0OTliOTUxYzAyOWU0MzE0NzgxNik7CiAgICAgICAgICAgIAoKICAgICAgICAgICAgbWFya2VyX2I2NmZmNmVhNTZiOTRhMjg4NThlNjQ5NzJkYjRkY2E4LmJpbmRQb3B1cChwb3B1cF83Mzg0NmY3MTI5OWU0ZTYzYTJhYTRiZWEwNGU0ZDg5YykKICAgICAgICAgICAgOwoKICAgICAgICAgICAgCiAgICAgICAgCiAgICAKICAgICAgICB2YXIgbWFya2VyX2Q5ZTIzMjBmNzQ3ZTQ3ZWY4N2IyMTcxOWYyYmY4ZWZhID0gTC5tYXJrZXIoCiAgICAgICAgICAgIFszOS45MzE1OTcsIC0xMDUuMzA0OTldLAogICAgICAgICAgICB7CiAgICAgICAgICAgICAgICBpY29uOiBuZXcgTC5JY29uLkRlZmF1bHQoKQogICAgICAgICAgICAgICAgfQogICAgICAgICAgICApLmFkZFRvKG1hcmtlcl9jbHVzdGVyX2RmMjlmMTY2OTA2ZDQ0YjE5NmUwOWRhOWFjM2U0MjIyKTsKICAgICAgICAKICAgIAogICAgICAgICAgICB2YXIgcG9wdXBfYjM0Yjg0NTRmNzM1NDYwOGI5MmVlZDcyZTdmMjI2ODcgPSBMLnBvcHVwKHttYXhXaWR0aDogJzMwMCcKICAgICAgICAgICAgCiAgICAgICAgICAgIH0pOwoKICAgICAgICAgICAgCiAgICAgICAgICAgICAgICB2YXIgaHRtbF8zMzgwMDlhYzEyMTY0MjZiYjU0YTZiODYwZTZmZTA2MiA9ICQoJzxkaXYgaWQ9Imh0bWxfMzM4MDA5YWMxMjE2NDI2YmI1NGE2Yjg2MGU2ZmUwNjIiIHN0eWxlPSJ3aWR0aDogMTAwLjAlOyBoZWlnaHQ6IDEwMC4wJTsiPk5hbWU6IFNPVVRIIEJPVUxERVIgQ1JFRUsgTkVBUiBFTERPUkFETyBTUFJJTkdTIFByZWNpcDogMTAuNDA8L2Rpdj4nKVswXTsKICAgICAgICAgICAgICAgIHBvcHVwX2IzNGI4NDU0ZjczNTQ2MDhiOTJlZWQ3MmU3ZjIyNjg3LnNldENvbnRlbnQoaHRtbF8zMzgwMDlhYzEyMTY0MjZiYjU0YTZiODYwZTZmZTA2Mik7CiAgICAgICAgICAgIAoKICAgICAgICAgICAgbWFya2VyX2Q5ZTIzMjBmNzQ3ZTQ3ZWY4N2IyMTcxOWYyYmY4ZWZhLmJpbmRQb3B1cChwb3B1cF9iMzRiODQ1NGY3MzU0NjA4YjkyZWVkNzJlN2YyMjY4NykKICAgICAgICAgICAgOwoKICAgICAgICAgICAgCiAgICAgICAgCjwvc2NyaXB0Pg==" style="position:absolute;width:100%;height:100%;left:0;top:0;border:none !important;" allowfullscreen webkitallowfullscreen mozallowfullscreen></iframe></div></div>





<div class="notice--info" markdown="1">

## Additional Resources

* <a href="https://blog.datafiniti.co/4-reasons-you-should-use-json-instead-of-csv-2cac362f1943" target="_blank">Why you should use JSON instead of csv.</a>


* <a href="https://www.w3schools.com/js/js_json_intro.asp" target="_blank">W3schools JSON intro </a>

</div>
