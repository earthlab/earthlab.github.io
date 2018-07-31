---
layout: single
title: 'Programmatically Accessing Geospatial Data Using APIs'
excerpt: 'This lesson walks through the process of retrieving and manipulating surface water data housed in the Colorado Information Warehouse. These data are stored in JSON format with spatial x, y information that support mapping.'
authors: ['Carson Farmer', 'Leah Wasser', 'Max Joseph', 'Martha Morrissey']
modified: 2018-07-27
category: [courses]
class-lesson: ['intro-APIs-python']
permalink: /courses/earth-analytics-python/get-data-using-apis/co-water-data-spatial-python/
nav-title: 'Geospatial Data From APIs'
week: 12
sidebar:
    nav:
author_profile: false
comments: true
order: 3
course: "earth-analytics-python"
topics:
    find-and-manage-data: ['apis']
---
{% include toc title = "In This Lesson" icon="file-text" %}

<div class='notice--success' markdown="1">

## <i class="fa fa-graduation-cap" aria-hidden="true"></i> Learning Objectives

After completing this tutorial, you will be able to:

* Extract geospatial (x,y) coordinate information embedded within a JSON hierarchical data structure.
* Convert data imported in JSON format into a `DataFrame`.
* Create a map of geospatial data.


## <i class="fa fa-check-square-o fa-2" aria-hidden="true"></i> What You Need

You will need a computer with internet access to complete this lesson.

</div>

In the previous lesson, you learned how to work with JSON data accessed via the Colorado information warehouse. In this lesson, you will explore another dataset however this time, the data will contain geospatial information nested
within it that will allow us to create a map of the data.


## Working with Geospatial Data

Check out the map <a href="https://data.colorado.gov/Water/DWR-Current-Surface-Water-Conditions-Map-Statewide/j5pc-4t32" target="_blank"> Colorado DWR Current Surface Water Conditions map</a>. If you remember from the previous lesson, APIs can be used for many different things. Web developers (people who program and create web sites and
cool applications) can use API's to create user friendly interfaces - like the map in this link that allow us to look at and interact with data. These API's are similar to - if not the same as the ones that you often use to access data in `Python`.


In this lesson, you will access the data used to create the map at the link above -
in `Python`.

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
# get URL
water_base_url = "https://data.colorado.gov/resource/j5pc-4t32.json?"
water_full_url = water_base_url + "station_status=Active" + "&county=BOULDER"
```

<i class="fa fa-lightbulb-o" aria-hidden="true"></i> **ATTENTION WINDOWS USERS:**
We have noticed a bug where on windows machines, sometimes the https URL doesn't work.
Instead try the same url as above but without the `s` - like this: `water_base_url <- "http://data.colorado.gov/resource/j5pc-4t32.json?"` This change has resolved many
issues on windows machines so give it a try if you are having problems with the API.
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
import requests
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



    [{'amount': '1.92',
      'county': 'BOULDER',
      'data_source': 'Cooperative SDR Program of CDWR & NCWCD',
      'date_time': '2018-05-18T15:00:00',
      'div': '1',
      'dwr_abbrev': 'BLWDITCO',
      'http_linkage': {'url': 'http://www.dwr.state.co.us/SurfaceWater/data/detail_graph.aspx?ID=BLWDITCO&MTYPE=DISCHRG'},
      'location': {'latitude': '40.257844',
       'longitude': '-105.164397',
       'needs_recoding': False},
      'stage': '0.33',
      'station_name': 'BLOWER DITCH',
      'station_status': 'Active',
      'station_type': 'Diversion',
      'usgs_station_id': 'BLWDITCO',
      'variable': 'DISCHRG',
      'wd': '4'},
     {'amount': '0.80',
      'county': 'BOULDER',
      'data_source': 'Co. Division of Water Resources',
      'date_time': '2018-05-18T15:15:00',
      'div': '1',
      'dwr_abbrev': 'BOUBYPCO',
      'http_linkage': {'url': 'http://www.dwr.state.co.us/SurfaceWater/data/detail_graph.aspx?ID=BOUBYPCO&MTYPE=DISCHRG'},
      'location': {'latitude': '40.258726',
       'longitude': '-105.175817',
       'needs_recoding': False},
      'stage': '0.15',
      'station_name': 'BOULDER-LARIMER BYPASS NEAR BERTHOUD',
      'station_status': 'Active',
      'station_type': 'Diversion',
      'variable': 'DISCHRG',
      'wd': '4'}]





## Convert JSON to DataFrame

Now that you have pulled down the data from the website you have it in the json format. Next step you'll use the `json_normalize` function from the `Pandas` library to convert this data into a `DataFrame.` This function helps organize and flatten data into a semi-structed table. To learn more check out the [documentaton](https://pandas.pydata.org/pandas-docs/stable/generated/pandas.io.json.json_normalize.html)! 

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
      <td>1.92</td>
      <td>BOULDER</td>
      <td>Cooperative SDR Program of CDWR &amp; NCWCD</td>
      <td>2018-05-18T15:00:00</td>
      <td>1</td>
      <td>BLWDITCO</td>
      <td>http://www.dwr.state.co.us/SurfaceWater/data/d...</td>
      <td>40.257844</td>
      <td>-105.164397</td>
      <td>False</td>
      <td>0.33</td>
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
      <td>2018-05-18T15:15:00</td>
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
      <td>7.54</td>
      <td>BOULDER</td>
      <td>Co. Division of Water Resources</td>
      <td>2018-05-18T15:30:00</td>
      <td>1</td>
      <td>BOULARCO</td>
      <td>http://www.dwr.state.co.us/SurfaceWater/data/d...</td>
      <td>40.258367</td>
      <td>-105.174957</td>
      <td>False</td>
      <td>0.28</td>
      <td>BOULDER-LARIMER DITCH NEAR BERTHOUD</td>
      <td>Active</td>
      <td>Diversion</td>
      <td>NaN</td>
      <td>DISCHRG</td>
      <td>4</td>
    </tr>
    <tr>
      <th>3</th>
      <td>5.83</td>
      <td>BOULDER</td>
      <td>Cooperative SDR Program of CDWR &amp; NCWCD</td>
      <td>2018-05-18T15:00:00</td>
      <td>1</td>
      <td>CULDITCO</td>
      <td>http://www.dwr.state.co.us/SurfaceWater/data/d...</td>
      <td>40.260827</td>
      <td>-105.198567</td>
      <td>False</td>
      <td>0.46</td>
      <td>CULVER DITCH</td>
      <td>Active</td>
      <td>Diversion</td>
      <td>CULDITCO</td>
      <td>DISCHRG</td>
      <td>4</td>
    </tr>
    <tr>
      <th>4</th>
      <td>0.00</td>
      <td>BOULDER</td>
      <td>Northern Colorado Water Conservancy District (...</td>
      <td>2018-05-18T15:00:00</td>
      <td>1</td>
      <td>LITTH1CO</td>
      <td>http://www.northernwater.org/WaterProjects/Eas...</td>
      <td>40.256276</td>
      <td>-105.209416</td>
      <td>False</td>
      <td>NaN</td>
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





Now that you have numerica values for mapping make sure that are are no missing values. 

{:.input}
```python
result.shape
```

{:.output}
{:.execute_result}



    (55, 17)





{:.input}
```python
pd.isnull(result['location.longitude'])
```

{:.output}
{:.execute_result}



    0     False
    1     False
    2     False
    3     False
    4     False
    5     False
    6     False
    7     False
    8     False
    9     False
    10    False
    11    False
    12    False
    13    False
    14    False
    15    False
    16    False
    17    False
    18    False
    19    False
    20    False
    21    False
    22    False
    23    False
    24    False
    25    False
    26    False
    27    False
    28    False
    29    False
    30    False
    31    False
    32    False
    33    False
    34    False
    35    False
    36    False
    37    False
    38    False
    39    False
    40    False
    41    False
    42    False
    43    False
    44    False
    45    False
    46    False
    47    False
    48    False
    49    False
    50    False
    51    False
    52    False
    53    False
    54    False
    Name: location.longitude, dtype: bool





{:.input}
```python
pd.isnull(result['location.latitude'])
```

{:.output}
{:.execute_result}



    0     False
    1     False
    2     False
    3     False
    4     False
    5     False
    6     False
    7     False
    8     False
    9     False
    10    False
    11    False
    12    False
    13    False
    14    False
    15    False
    16    False
    17    False
    18    False
    19    False
    20    False
    21    False
    22    False
    23    False
    24    False
    25    False
    26    False
    27    False
    28    False
    29    False
    30    False
    31    False
    32    False
    33    False
    34    False
    35    False
    36    False
    37    False
    38    False
    39    False
    40    False
    41    False
    42    False
    43    False
    44    False
    45    False
    46    False
    47    False
    48    False
    49    False
    50    False
    51    False
    52    False
    53    False
    54    False
    Name: location.latitude, dtype: bool





There are no `nan` values in this data, but if there were,to remove rows where a column has a `nan` value in a specific column you could do: 
`result_nona = result.dropna(subset=['location.longitude', 'location.latitude'])`

## Data Visualiztion 

You will use the `folium` package to visualize data. One approach you could take, would be to convert your `Pandas DataFarem` to a `geopandas DataFrame`

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
      <td>1.92</td>
      <td>BOULDER</td>
      <td>Cooperative SDR Program of CDWR &amp; NCWCD</td>
      <td>2018-05-18T15:00:00</td>
      <td>1</td>
      <td>BLWDITCO</td>
      <td>http://www.dwr.state.co.us/SurfaceWater/data/d...</td>
      <td>40.257844</td>
      <td>-105.164397</td>
      <td>False</td>
      <td>0.33</td>
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
      <td>2018-05-18T15:15:00</td>
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
      <td>7.54</td>
      <td>BOULDER</td>
      <td>Co. Division of Water Resources</td>
      <td>2018-05-18T15:30:00</td>
      <td>1</td>
      <td>BOULARCO</td>
      <td>http://www.dwr.state.co.us/SurfaceWater/data/d...</td>
      <td>40.258367</td>
      <td>-105.174957</td>
      <td>False</td>
      <td>0.28</td>
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
      <td>5.83</td>
      <td>BOULDER</td>
      <td>Cooperative SDR Program of CDWR &amp; NCWCD</td>
      <td>2018-05-18T15:00:00</td>
      <td>1</td>
      <td>CULDITCO</td>
      <td>http://www.dwr.state.co.us/SurfaceWater/data/d...</td>
      <td>40.260827</td>
      <td>-105.198567</td>
      <td>False</td>
      <td>0.46</td>
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
      <td>0.00</td>
      <td>BOULDER</td>
      <td>Northern Colorado Water Conservancy District (...</td>
      <td>2018-05-18T15:00:00</td>
      <td>1</td>
      <td>LITTH1CO</td>
      <td>http://www.northernwater.org/WaterProjects/Eas...</td>
      <td>40.256276</td>
      <td>-105.209416</td>
      <td>False</td>
      <td>NaN</td>
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





{:.input}
```python
m = folium.Map([40.01, -105.27], zoom_start= 10, tiles='cartodbpositron')
folium.GeoJson(gdf).add_to(m)
m
```

{:.output}
{:.execute_result}



<div style="width:100%;"><div style="position:relative;width:100%;height:0;padding-bottom:60%;"><iframe src="data:text/html;charset=utf-8;base64,PCFET0NUWVBFIGh0bWw+CjxoZWFkPiAgICAKICAgIDxtZXRhIGh0dHAtZXF1aXY9ImNvbnRlbnQtdHlwZSIgY29udGVudD0idGV4dC9odG1sOyBjaGFyc2V0PVVURi04IiAvPgogICAgPHNjcmlwdD5MX1BSRUZFUl9DQU5WQVMgPSBmYWxzZTsgTF9OT19UT1VDSCA9IGZhbHNlOyBMX0RJU0FCTEVfM0QgPSBmYWxzZTs8L3NjcmlwdD4KICAgIDxzY3JpcHQgc3JjPSJodHRwczovL2Nkbi5qc2RlbGl2ci5uZXQvbnBtL2xlYWZsZXRAMS4yLjAvZGlzdC9sZWFmbGV0LmpzIj48L3NjcmlwdD4KICAgIDxzY3JpcHQgc3JjPSJodHRwczovL2FqYXguZ29vZ2xlYXBpcy5jb20vYWpheC9saWJzL2pxdWVyeS8xLjExLjEvanF1ZXJ5Lm1pbi5qcyI+PC9zY3JpcHQ+CiAgICA8c2NyaXB0IHNyYz0iaHR0cHM6Ly9tYXhjZG4uYm9vdHN0cmFwY2RuLmNvbS9ib290c3RyYXAvMy4yLjAvanMvYm9vdHN0cmFwLm1pbi5qcyI+PC9zY3JpcHQ+CiAgICA8c2NyaXB0IHNyYz0iaHR0cHM6Ly9jZG5qcy5jbG91ZGZsYXJlLmNvbS9hamF4L2xpYnMvTGVhZmxldC5hd2Vzb21lLW1hcmtlcnMvMi4wLjIvbGVhZmxldC5hd2Vzb21lLW1hcmtlcnMuanMiPjwvc2NyaXB0PgogICAgPGxpbmsgcmVsPSJzdHlsZXNoZWV0IiBocmVmPSJodHRwczovL2Nkbi5qc2RlbGl2ci5uZXQvbnBtL2xlYWZsZXRAMS4yLjAvZGlzdC9sZWFmbGV0LmNzcyIgLz4KICAgIDxsaW5rIHJlbD0ic3R5bGVzaGVldCIgaHJlZj0iaHR0cHM6Ly9tYXhjZG4uYm9vdHN0cmFwY2RuLmNvbS9ib290c3RyYXAvMy4yLjAvY3NzL2Jvb3RzdHJhcC5taW4uY3NzIiAvPgogICAgPGxpbmsgcmVsPSJzdHlsZXNoZWV0IiBocmVmPSJodHRwczovL21heGNkbi5ib290c3RyYXBjZG4uY29tL2Jvb3RzdHJhcC8zLjIuMC9jc3MvYm9vdHN0cmFwLXRoZW1lLm1pbi5jc3MiIC8+CiAgICA8bGluayByZWw9InN0eWxlc2hlZXQiIGhyZWY9Imh0dHBzOi8vbWF4Y2RuLmJvb3RzdHJhcGNkbi5jb20vZm9udC1hd2Vzb21lLzQuNi4zL2Nzcy9mb250LWF3ZXNvbWUubWluLmNzcyIgLz4KICAgIDxsaW5rIHJlbD0ic3R5bGVzaGVldCIgaHJlZj0iaHR0cHM6Ly9jZG5qcy5jbG91ZGZsYXJlLmNvbS9hamF4L2xpYnMvTGVhZmxldC5hd2Vzb21lLW1hcmtlcnMvMi4wLjIvbGVhZmxldC5hd2Vzb21lLW1hcmtlcnMuY3NzIiAvPgogICAgPGxpbmsgcmVsPSJzdHlsZXNoZWV0IiBocmVmPSJodHRwczovL3Jhd2dpdC5jb20vcHl0aG9uLXZpc3VhbGl6YXRpb24vZm9saXVtL21hc3Rlci9mb2xpdW0vdGVtcGxhdGVzL2xlYWZsZXQuYXdlc29tZS5yb3RhdGUuY3NzIiAvPgogICAgPHN0eWxlPmh0bWwsIGJvZHkge3dpZHRoOiAxMDAlO2hlaWdodDogMTAwJTttYXJnaW46IDA7cGFkZGluZzogMDt9PC9zdHlsZT4KICAgIDxzdHlsZT4jbWFwIHtwb3NpdGlvbjphYnNvbHV0ZTt0b3A6MDtib3R0b206MDtyaWdodDowO2xlZnQ6MDt9PC9zdHlsZT4KICAgIAogICAgICAgICAgICA8c3R5bGU+ICNtYXBfNzBjMTg1MDMyN2EzNGE5Njk5ZWVlZGFlNzk0MmFhZDYgewogICAgICAgICAgICAgICAgcG9zaXRpb24gOiByZWxhdGl2ZTsKICAgICAgICAgICAgICAgIHdpZHRoIDogMTAwLjAlOwogICAgICAgICAgICAgICAgaGVpZ2h0OiAxMDAuMCU7CiAgICAgICAgICAgICAgICBsZWZ0OiAwLjAlOwogICAgICAgICAgICAgICAgdG9wOiAwLjAlOwogICAgICAgICAgICAgICAgfQogICAgICAgICAgICA8L3N0eWxlPgogICAgICAgIAo8L2hlYWQ+Cjxib2R5PiAgICAKICAgIAogICAgICAgICAgICA8ZGl2IGNsYXNzPSJmb2xpdW0tbWFwIiBpZD0ibWFwXzcwYzE4NTAzMjdhMzRhOTY5OWVlZWRhZTc5NDJhYWQ2IiA+PC9kaXY+CiAgICAgICAgCjwvYm9keT4KPHNjcmlwdD4gICAgCiAgICAKCiAgICAgICAgICAgIAogICAgICAgICAgICAgICAgdmFyIGJvdW5kcyA9IG51bGw7CiAgICAgICAgICAgIAoKICAgICAgICAgICAgdmFyIG1hcF83MGMxODUwMzI3YTM0YTk2OTllZWVkYWU3OTQyYWFkNiA9IEwubWFwKAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgJ21hcF83MGMxODUwMzI3YTM0YTk2OTllZWVkYWU3OTQyYWFkNicsCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICB7Y2VudGVyOiBbNDAuMDEsLTEwNS4yN10sCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICB6b29tOiAxMCwKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIG1heEJvdW5kczogYm91bmRzLAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgbGF5ZXJzOiBbXSwKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIHdvcmxkQ29weUp1bXA6IGZhbHNlLAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgY3JzOiBMLkNSUy5FUFNHMzg1NwogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICB9KTsKICAgICAgICAgICAgCiAgICAgICAgCiAgICAKICAgICAgICAgICAgdmFyIHRpbGVfbGF5ZXJfZjY5OGU2ZThjODUzNDBlOTgzOTQwNTQ2MjZmYTJiOGIgPSBMLnRpbGVMYXllcigKICAgICAgICAgICAgICAgICdodHRwczovL2NhcnRvZGItYmFzZW1hcHMte3N9Lmdsb2JhbC5zc2wuZmFzdGx5Lm5ldC9saWdodF9hbGwve3p9L3t4fS97eX0ucG5nJywKICAgICAgICAgICAgICAgIHsKICAiYXR0cmlidXRpb24iOiBudWxsLAogICJkZXRlY3RSZXRpbmEiOiBmYWxzZSwKICAibWF4Wm9vbSI6IDE4LAogICJtaW5ab29tIjogMSwKICAibm9XcmFwIjogZmFsc2UsCiAgInN1YmRvbWFpbnMiOiAiYWJjIgp9CiAgICAgICAgICAgICAgICApLmFkZFRvKG1hcF83MGMxODUwMzI3YTM0YTk2OTllZWVkYWU3OTQyYWFkNik7CiAgICAgICAgCiAgICAKCiAgICAgICAgICAgIAoKICAgICAgICAgICAgICAgIHZhciBnZW9fanNvbl9iZDcwNzc5YjAyMTM0ZmQyODAzODE4NDU3YjhmYTQwYyA9IEwuZ2VvSnNvbigKICAgICAgICAgICAgICAgICAgICB7ImJib3giOiBbLTEwNS41MTcxMTEsIDM5LjkzMTU5NywgLTEwNS4wNzU2OTUwMDAwMDAwMSwgNDAuMjYwODI3XSwgImZlYXR1cmVzIjogW3siYmJveCI6IFstMTA1LjE2NDM5NywgNDAuMjU3ODQ0LCAtMTA1LjE2NDM5NywgNDAuMjU3ODQ0XSwgImdlb21ldHJ5IjogeyJjb29yZGluYXRlcyI6IFstMTA1LjE2NDM5NywgNDAuMjU3ODQ0XSwgInR5cGUiOiAiUG9pbnQifSwgImlkIjogIjAiLCAicHJvcGVydGllcyI6IHsiYW1vdW50IjogIjEuOTIiLCAiY291bnR5IjogIkJPVUxERVIiLCAiZGF0YV9zb3VyY2UiOiAiQ29vcGVyYXRpdmUgU0RSIFByb2dyYW0gb2YgQ0RXUiAmIE5DV0NEIiwgImRhdGVfdGltZSI6ICIyMDE4LTA1LTE4VDE1OjAwOjAwIiwgImRpdiI6ICIxIiwgImR3cl9hYmJyZXYiOiAiQkxXRElUQ08iLCAiaGlnaGxpZ2h0Ijoge30sICJodHRwX2xpbmthZ2UudXJsIjogImh0dHA6Ly93d3cuZHdyLnN0YXRlLmNvLnVzL1N1cmZhY2VXYXRlci9kYXRhL2RldGFpbF9ncmFwaC5hc3B4P0lEPUJMV0RJVENPJk1UWVBFPURJU0NIUkciLCAibG9jYXRpb24ubGF0aXR1ZGUiOiA0MC4yNTc4NDQsICJsb2NhdGlvbi5sb25naXR1ZGUiOiAtMTA1LjE2NDM5NywgImxvY2F0aW9uLm5lZWRzX3JlY29kaW5nIjogZmFsc2UsICJzdGFnZSI6ICIwLjMzIiwgInN0YXRpb25fbmFtZSI6ICJCTE9XRVIgRElUQ0giLCAic3RhdGlvbl9zdGF0dXMiOiAiQWN0aXZlIiwgInN0YXRpb25fdHlwZSI6ICJEaXZlcnNpb24iLCAic3R5bGUiOiB7fSwgInVzZ3Nfc3RhdGlvbl9pZCI6ICJCTFdESVRDTyIsICJ2YXJpYWJsZSI6ICJESVNDSFJHIiwgIndkIjogIjQifSwgInR5cGUiOiAiRmVhdHVyZSJ9LCB7ImJib3giOiBbLTEwNS4xNzU4MTcsIDQwLjI1ODcyNiwgLTEwNS4xNzU4MTcsIDQwLjI1ODcyNl0sICJnZW9tZXRyeSI6IHsiY29vcmRpbmF0ZXMiOiBbLTEwNS4xNzU4MTcsIDQwLjI1ODcyNl0sICJ0eXBlIjogIlBvaW50In0sICJpZCI6ICIxIiwgInByb3BlcnRpZXMiOiB7ImFtb3VudCI6ICIwLjgwIiwgImNvdW50eSI6ICJCT1VMREVSIiwgImRhdGFfc291cmNlIjogIkNvLiBEaXZpc2lvbiBvZiBXYXRlciBSZXNvdXJjZXMiLCAiZGF0ZV90aW1lIjogIjIwMTgtMDUtMThUMTU6MTU6MDAiLCAiZGl2IjogIjEiLCAiZHdyX2FiYnJldiI6ICJCT1VCWVBDTyIsICJoaWdobGlnaHQiOiB7fSwgImh0dHBfbGlua2FnZS51cmwiOiAiaHR0cDovL3d3dy5kd3Iuc3RhdGUuY28udXMvU3VyZmFjZVdhdGVyL2RhdGEvZGV0YWlsX2dyYXBoLmFzcHg/SUQ9Qk9VQllQQ08mTVRZUEU9RElTQ0hSRyIsICJsb2NhdGlvbi5sYXRpdHVkZSI6IDQwLjI1ODcyNiwgImxvY2F0aW9uLmxvbmdpdHVkZSI6IC0xMDUuMTc1ODE3LCAibG9jYXRpb24ubmVlZHNfcmVjb2RpbmciOiBmYWxzZSwgInN0YWdlIjogIjAuMTUiLCAic3RhdGlvbl9uYW1lIjogIkJPVUxERVItTEFSSU1FUiBCWVBBU1MgTkVBUiBCRVJUSE9VRCIsICJzdGF0aW9uX3N0YXR1cyI6ICJBY3RpdmUiLCAic3RhdGlvbl90eXBlIjogIkRpdmVyc2lvbiIsICJzdHlsZSI6IHt9LCAidXNnc19zdGF0aW9uX2lkIjogbnVsbCwgInZhcmlhYmxlIjogIkRJU0NIUkciLCAid2QiOiAiNCJ9LCAidHlwZSI6ICJGZWF0dXJlIn0sIHsiYmJveCI6IFstMTA1LjE3NDk1NywgNDAuMjU4MzY3LCAtMTA1LjE3NDk1NywgNDAuMjU4MzY3XSwgImdlb21ldHJ5IjogeyJjb29yZGluYXRlcyI6IFstMTA1LjE3NDk1NywgNDAuMjU4MzY3XSwgInR5cGUiOiAiUG9pbnQifSwgImlkIjogIjIiLCAicHJvcGVydGllcyI6IHsiYW1vdW50IjogIjcuNTQiLCAiY291bnR5IjogIkJPVUxERVIiLCAiZGF0YV9zb3VyY2UiOiAiQ28uIERpdmlzaW9uIG9mIFdhdGVyIFJlc291cmNlcyIsICJkYXRlX3RpbWUiOiAiMjAxOC0wNS0xOFQxNTozMDowMCIsICJkaXYiOiAiMSIsICJkd3JfYWJicmV2IjogIkJPVUxBUkNPIiwgImhpZ2hsaWdodCI6IHt9LCAiaHR0cF9saW5rYWdlLnVybCI6ICJodHRwOi8vd3d3LmR3ci5zdGF0ZS5jby51cy9TdXJmYWNlV2F0ZXIvZGF0YS9kZXRhaWxfZ3JhcGguYXNweD9JRD1CT1VMQVJDTyZNVFlQRT1ESVNDSFJHIiwgImxvY2F0aW9uLmxhdGl0dWRlIjogNDAuMjU4MzY3LCAibG9jYXRpb24ubG9uZ2l0dWRlIjogLTEwNS4xNzQ5NTcsICJsb2NhdGlvbi5uZWVkc19yZWNvZGluZyI6IGZhbHNlLCAic3RhZ2UiOiAiMC4yOCIsICJzdGF0aW9uX25hbWUiOiAiQk9VTERFUi1MQVJJTUVSIERJVENIIE5FQVIgQkVSVEhPVUQiLCAic3RhdGlvbl9zdGF0dXMiOiAiQWN0aXZlIiwgInN0YXRpb25fdHlwZSI6ICJEaXZlcnNpb24iLCAic3R5bGUiOiB7fSwgInVzZ3Nfc3RhdGlvbl9pZCI6IG51bGwsICJ2YXJpYWJsZSI6ICJESVNDSFJHIiwgIndkIjogIjQifSwgInR5cGUiOiAiRmVhdHVyZSJ9LCB7ImJib3giOiBbLTEwNS4xOTg1NjcsIDQwLjI2MDgyNywgLTEwNS4xOTg1NjcsIDQwLjI2MDgyN10sICJnZW9tZXRyeSI6IHsiY29vcmRpbmF0ZXMiOiBbLTEwNS4xOTg1NjcsIDQwLjI2MDgyN10sICJ0eXBlIjogIlBvaW50In0sICJpZCI6ICIzIiwgInByb3BlcnRpZXMiOiB7ImFtb3VudCI6ICI1LjgzIiwgImNvdW50eSI6ICJCT1VMREVSIiwgImRhdGFfc291cmNlIjogIkNvb3BlcmF0aXZlIFNEUiBQcm9ncmFtIG9mIENEV1IgJiBOQ1dDRCIsICJkYXRlX3RpbWUiOiAiMjAxOC0wNS0xOFQxNTowMDowMCIsICJkaXYiOiAiMSIsICJkd3JfYWJicmV2IjogIkNVTERJVENPIiwgImhpZ2hsaWdodCI6IHt9LCAiaHR0cF9saW5rYWdlLnVybCI6ICJodHRwOi8vd3d3LmR3ci5zdGF0ZS5jby51cy9TdXJmYWNlV2F0ZXIvZGF0YS9kZXRhaWxfZ3JhcGguYXNweD9JRD1DVUxESVRDTyZNVFlQRT1ESVNDSFJHIiwgImxvY2F0aW9uLmxhdGl0dWRlIjogNDAuMjYwODI3LCAibG9jYXRpb24ubG9uZ2l0dWRlIjogLTEwNS4xOTg1NjcsICJsb2NhdGlvbi5uZWVkc19yZWNvZGluZyI6IGZhbHNlLCAic3RhZ2UiOiAiMC40NiIsICJzdGF0aW9uX25hbWUiOiAiQ1VMVkVSIERJVENIIiwgInN0YXRpb25fc3RhdHVzIjogIkFjdGl2ZSIsICJzdGF0aW9uX3R5cGUiOiAiRGl2ZXJzaW9uIiwgInN0eWxlIjoge30sICJ1c2dzX3N0YXRpb25faWQiOiAiQ1VMRElUQ08iLCAidmFyaWFibGUiOiAiRElTQ0hSRyIsICJ3ZCI6ICI0In0sICJ0eXBlIjogIkZlYXR1cmUifSwgeyJiYm94IjogWy0xMDUuMjA5NDE2LCA0MC4yNTYyNzYwMDAwMDAwMSwgLTEwNS4yMDk0MTYsIDQwLjI1NjI3NjAwMDAwMDAxXSwgImdlb21ldHJ5IjogeyJjb29yZGluYXRlcyI6IFstMTA1LjIwOTQxNiwgNDAuMjU2Mjc2MDAwMDAwMDFdLCAidHlwZSI6ICJQb2ludCJ9LCAiaWQiOiAiNCIsICJwcm9wZXJ0aWVzIjogeyJhbW91bnQiOiAiMC4wMCIsICJjb3VudHkiOiAiQk9VTERFUiIsICJkYXRhX3NvdXJjZSI6ICJOb3J0aGVybiBDb2xvcmFkbyBXYXRlciBDb25zZXJ2YW5jeSBEaXN0cmljdCAoRGF0YSBQcm92aWRlcikiLCAiZGF0ZV90aW1lIjogIjIwMTgtMDUtMThUMTU6MDA6MDAiLCAiZGl2IjogIjEiLCAiZHdyX2FiYnJldiI6ICJMSVRUSDFDTyIsICJoaWdobGlnaHQiOiB7fSwgImh0dHBfbGlua2FnZS51cmwiOiAiaHR0cDovL3d3dy5ub3J0aGVybndhdGVyLm9yZy9XYXRlclByb2plY3RzL0Vhc3RTbG9wZVdhdGVyRGF0YS5hc3B4IiwgImxvY2F0aW9uLmxhdGl0dWRlIjogNDAuMjU2Mjc2LCAibG9jYXRpb24ubG9uZ2l0dWRlIjogLTEwNS4yMDk0MTYsICJsb2NhdGlvbi5uZWVkc19yZWNvZGluZyI6IGZhbHNlLCAic3RhZ2UiOiBudWxsLCAic3RhdGlvbl9uYW1lIjogIkxJVFRMRSBUSE9NUFNPTiAjMSBESVRDSCIsICJzdGF0aW9uX3N0YXR1cyI6ICJBY3RpdmUiLCAic3RhdGlvbl90eXBlIjogIkRpdmVyc2lvbiIsICJzdHlsZSI6IHt9LCAidXNnc19zdGF0aW9uX2lkIjogIkVTMTkwMSIsICJ2YXJpYWJsZSI6ICJESVNDSFJHIiwgIndkIjogIjQifSwgInR5cGUiOiAiRmVhdHVyZSJ9LCB7ImJib3giOiBbLTEwNS4yMDk1LCA0MC4yNTU3NzYsIC0xMDUuMjA5NSwgNDAuMjU1Nzc2XSwgImdlb21ldHJ5IjogeyJjb29yZGluYXRlcyI6IFstMTA1LjIwOTUsIDQwLjI1NTc3Nl0sICJ0eXBlIjogIlBvaW50In0sICJpZCI6ICI1IiwgInByb3BlcnRpZXMiOiB7ImFtb3VudCI6ICIwLjAwIiwgImNvdW50eSI6ICJCT1VMREVSIiwgImRhdGFfc291cmNlIjogIk5vcnRoZXJuIENvbG9yYWRvIFdhdGVyIENvbnNlcnZhbmN5IERpc3RyaWN0IChEYXRhIFByb3ZpZGVyKSIsICJkYXRlX3RpbWUiOiAiMjAxOC0wNS0xOFQxNTowMDowMCIsICJkaXYiOiAiMSIsICJkd3JfYWJicmV2IjogIkxJVFRIMkNPIiwgImhpZ2hsaWdodCI6IHt9LCAiaHR0cF9saW5rYWdlLnVybCI6ICJodHRwOi8vd3d3Lm5vcnRoZXJud2F0ZXIub3JnL1dhdGVyUHJvamVjdHMvRWFzdFNsb3BlV2F0ZXJEYXRhLmFzcHgiLCAibG9jYXRpb24ubGF0aXR1ZGUiOiA0MC4yNTU3NzYsICJsb2NhdGlvbi5sb25naXR1ZGUiOiAtMTA1LjIwOTUsICJsb2NhdGlvbi5uZWVkc19yZWNvZGluZyI6IGZhbHNlLCAic3RhZ2UiOiAiMC4wMCIsICJzdGF0aW9uX25hbWUiOiAiTElUVExFIFRIT01QU09OICMyIERJVENIIiwgInN0YXRpb25fc3RhdHVzIjogIkFjdGl2ZSIsICJzdGF0aW9uX3R5cGUiOiAiRGl2ZXJzaW9uIiwgInN0eWxlIjoge30sICJ1c2dzX3N0YXRpb25faWQiOiAiRVMxOTAwIiwgInZhcmlhYmxlIjogIkRJU0NIUkciLCAid2QiOiAiNCJ9LCAidHlwZSI6ICJGZWF0dXJlIn0sIHsiYmJveCI6IFstMTA1LjIwNjM4NiwgNDAuMjU4MDM4LCAtMTA1LjIwNjM4NiwgNDAuMjU4MDM4XSwgImdlb21ldHJ5IjogeyJjb29yZGluYXRlcyI6IFstMTA1LjIwNjM4NiwgNDAuMjU4MDM4XSwgInR5cGUiOiAiUG9pbnQifSwgImlkIjogIjYiLCAicHJvcGVydGllcyI6IHsiYW1vdW50IjogIjE0LjIwIiwgImNvdW50eSI6ICJCT1VMREVSIiwgImRhdGFfc291cmNlIjogIkNvLiBEaXZpc2lvbiBvZiBXYXRlciBSZXNvdXJjZXMiLCAiZGF0ZV90aW1lIjogIjIwMTgtMDUtMThUMTU6MzA6MDAiLCAiZGl2IjogIjEiLCAiZHdyX2FiYnJldiI6ICJMVENBTllDTyIsICJoaWdobGlnaHQiOiB7fSwgImh0dHBfbGlua2FnZS51cmwiOiAiaHR0cDovL3d3dy5kd3Iuc3RhdGUuY28udXMvU3VyZmFjZVdhdGVyL2RhdGEvZGV0YWlsX2dyYXBoLmFzcHg/SUQ9TFRDQU5ZQ08mTVRZUEU9RElTQ0hSRyIsICJsb2NhdGlvbi5sYXRpdHVkZSI6IDQwLjI1ODAzOCwgImxvY2F0aW9uLmxvbmdpdHVkZSI6IC0xMDUuMjA2Mzg2LCAibG9jYXRpb24ubmVlZHNfcmVjb2RpbmciOiBmYWxzZSwgInN0YWdlIjogIjEuNDkiLCAic3RhdGlvbl9uYW1lIjogIkxJVFRMRSBUSE9NUFNPTiBSSVZFUiBBVCBDQU5ZT04gTU9VVEggTkVBUiBCRVJUSE9VRCIsICJzdGF0aW9uX3N0YXR1cyI6ICJBY3RpdmUiLCAic3RhdGlvbl90eXBlIjogIlN0cmVhbSIsICJzdHlsZSI6IHt9LCAidXNnc19zdGF0aW9uX2lkIjogbnVsbCwgInZhcmlhYmxlIjogIkRJU0NIUkciLCAid2QiOiAiNCJ9LCAidHlwZSI6ICJGZWF0dXJlIn0sIHsiYmJveCI6IFstMTA1LjA4ODY5NSwgNDAuMTUzMzYzLCAtMTA1LjA4ODY5NSwgNDAuMTUzMzYzXSwgImdlb21ldHJ5IjogeyJjb29yZGluYXRlcyI6IFstMTA1LjA4ODY5NSwgNDAuMTUzMzYzXSwgInR5cGUiOiAiUG9pbnQifSwgImlkIjogIjciLCAicHJvcGVydGllcyI6IHsiYW1vdW50IjogIjAuMDMiLCAiY291bnR5IjogIkJPVUxERVIiLCAiZGF0YV9zb3VyY2UiOiAiQ29vcGVyYXRpdmUgUHJvZ3JhbSBvZiBDRFdSLCBOQ1dDRCAmIFNWTEhXQ0QiLCAiZGF0ZV90aW1lIjogIjIwMTgtMDUtMThUMTU6MDA6MDAiLCAiZGl2IjogIjEiLCAiZHdyX2FiYnJldiI6ICJCT05ESVRDTyIsICJoaWdobGlnaHQiOiB7fSwgImh0dHBfbGlua2FnZS51cmwiOiAiaHR0cDovL3d3dy5kd3Iuc3RhdGUuY28udXMvU3VyZmFjZVdhdGVyL2RhdGEvZGV0YWlsX2dyYXBoLmFzcHg/SUQ9Qk9ORElUQ08mTVRZUEU9RElTQ0hSRyIsICJsb2NhdGlvbi5sYXRpdHVkZSI6IDQwLjE1MzM2MywgImxvY2F0aW9uLmxvbmdpdHVkZSI6IC0xMDUuMDg4Njk1LCAibG9jYXRpb24ubmVlZHNfcmVjb2RpbmciOiBmYWxzZSwgInN0YWdlIjogIjAuMDIiLCAic3RhdGlvbl9uYW1lIjogIkJPTlVTIERJVENIIiwgInN0YXRpb25fc3RhdHVzIjogIkFjdGl2ZSIsICJzdGF0aW9uX3R5cGUiOiAiRGl2ZXJzaW9uIiwgInN0eWxlIjoge30sICJ1c2dzX3N0YXRpb25faWQiOiAiQk9ORElUQ08iLCAidmFyaWFibGUiOiAiRElTQ0hSRyIsICJ3ZCI6ICI1In0sICJ0eXBlIjogIkZlYXR1cmUifSwgeyJiYm94IjogWy0xMDUuMzY1MzY1LCA0MC4yMTYyNjMsIC0xMDUuMzY1MzY1LCA0MC4yMTYyNjNdLCAiZ2VvbWV0cnkiOiB7ImNvb3JkaW5hdGVzIjogWy0xMDUuMzY1MzY1LCA0MC4yMTYyNjNdLCAidHlwZSI6ICJQb2ludCJ9LCAiaWQiOiAiOCIsICJwcm9wZXJ0aWVzIjogeyJhbW91bnQiOiAiMTYyNzEuMDAiLCAiY291bnR5IjogIkJPVUxERVIiLCAiZGF0YV9zb3VyY2UiOiAiQ28uIERpdmlzaW9uIG9mIFdhdGVyIFJlc291cmNlcyIsICJkYXRlX3RpbWUiOiAiMjAxOC0wNS0xOFQxNTo0NTowMCIsICJkaXYiOiAiMSIsICJkd3JfYWJicmV2IjogIkJSS0RBTUNPIiwgImhpZ2hsaWdodCI6IHt9LCAiaHR0cF9saW5rYWdlLnVybCI6ICJodHRwOi8vd3d3LmR3ci5zdGF0ZS5jby51cy9TdXJmYWNlV2F0ZXIvZGF0YS9kZXRhaWxfZ3JhcGguYXNweD9JRD1CUktEQU1DTyZNVFlQRT1TVE9SQUdFIiwgImxvY2F0aW9uLmxhdGl0dWRlIjogNDAuMjE2MjYzLCAibG9jYXRpb24ubG9uZ2l0dWRlIjogLTEwNS4zNjUzNjUsICJsb2NhdGlvbi5uZWVkc19yZWNvZGluZyI6IGZhbHNlLCAic3RhZ2UiOiAiNjQwMC4zMyIsICJzdGF0aW9uX25hbWUiOiAiQlVUVE9OUk9DSyAoUkFMUEggUFJJQ0UpIFJFU0VSVk9JUiIsICJzdGF0aW9uX3N0YXR1cyI6ICJBY3RpdmUiLCAic3RhdGlvbl90eXBlIjogIlJlc2Vydm9pciIsICJzdHlsZSI6IHt9LCAidXNnc19zdGF0aW9uX2lkIjogIkJSS0RBTUNPIiwgInZhcmlhYmxlIjogIlNUT1JBR0UiLCAid2QiOiAiNSJ9LCAidHlwZSI6ICJGZWF0dXJlIn0sIHsiYmJveCI6IFstMTA1LjIxMDM5LCA0MC4xOTM3NTgsIC0xMDUuMjEwMzksIDQwLjE5Mzc1OF0sICJnZW9tZXRyeSI6IHsiY29vcmRpbmF0ZXMiOiBbLTEwNS4yMTAzOSwgNDAuMTkzNzU4XSwgInR5cGUiOiAiUG9pbnQifSwgImlkIjogIjkiLCAicHJvcGVydGllcyI6IHsiYW1vdW50IjogIjMuOTMiLCAiY291bnR5IjogIkJPVUxERVIiLCAiZGF0YV9zb3VyY2UiOiAiQ29vcGVyYXRpdmUgUHJvZ3JhbSBvZiBDRFdSLCBOQ1dDRCAmIFNWTEhXQ0QiLCAiZGF0ZV90aW1lIjogIjIwMTgtMDUtMThUMTU6MDA6MDAiLCAiZGl2IjogIjEiLCAiZHdyX2FiYnJldiI6ICJDTE9ESVRDTyIsICJoaWdobGlnaHQiOiB7fSwgImh0dHBfbGlua2FnZS51cmwiOiAiaHR0cDovL3d3dy5kd3Iuc3RhdGUuY28udXMvU3VyZmFjZVdhdGVyL2RhdGEvZGV0YWlsX2dyYXBoLmFzcHg/SUQ9Q0xPRElUQ08mTVRZUEU9RElTQ0hSRyIsICJsb2NhdGlvbi5sYXRpdHVkZSI6IDQwLjE5Mzc1OCwgImxvY2F0aW9uLmxvbmdpdHVkZSI6IC0xMDUuMjEwMzksICJsb2NhdGlvbi5uZWVkc19yZWNvZGluZyI6IGZhbHNlLCAic3RhZ2UiOiAiMC43NiIsICJzdGF0aW9uX25hbWUiOiAiQ0xPVUdIIEFORCBUUlVFIERJVENIIiwgInN0YXRpb25fc3RhdHVzIjogIkFjdGl2ZSIsICJzdGF0aW9uX3R5cGUiOiAiRGl2ZXJzaW9uIiwgInN0eWxlIjoge30sICJ1c2dzX3N0YXRpb25faWQiOiAiQ0xPRElUQ08iLCAidmFyaWFibGUiOiAiRElTQ0hSRyIsICJ3ZCI6ICI1In0sICJ0eXBlIjogIkZlYXR1cmUifSwgeyJiYm94IjogWy0xMDUuMTk2Nzc1LCA0MC4xODE4OCwgLTEwNS4xOTY3NzUsIDQwLjE4MTg4XSwgImdlb21ldHJ5IjogeyJjb29yZGluYXRlcyI6IFstMTA1LjE5Njc3NSwgNDAuMTgxODhdLCAidHlwZSI6ICJQb2ludCJ9LCAiaWQiOiAiMTAiLCAicHJvcGVydGllcyI6IHsiYW1vdW50IjogIjYuNDEiLCAiY291bnR5IjogIkJPVUxERVIiLCAiZGF0YV9zb3VyY2UiOiAiQ29vcGVyYXRpdmUgUHJvZ3JhbSBvZiBDRFdSLCBOQ1dDRCAmIFNWTEhXQ0QiLCAiZGF0ZV90aW1lIjogIjIwMTgtMDUtMThUMTQ6NDU6MDAiLCAiZGl2IjogIjEiLCAiZHdyX2FiYnJldiI6ICJEQVZET1dDTyIsICJoaWdobGlnaHQiOiB7fSwgImh0dHBfbGlua2FnZS51cmwiOiAiaHR0cDovL3d3dy5kd3Iuc3RhdGUuY28udXMvU3VyZmFjZVdhdGVyL2RhdGEvZGV0YWlsX2dyYXBoLmFzcHg/SUQ9REFWRE9XQ08mTVRZUEU9RElTQ0hSRyIsICJsb2NhdGlvbi5sYXRpdHVkZSI6IDQwLjE4MTg4LCAibG9jYXRpb24ubG9uZ2l0dWRlIjogLTEwNS4xOTY3NzUsICJsb2NhdGlvbi5uZWVkc19yZWNvZGluZyI6IGZhbHNlLCAic3RhZ2UiOiAiMC41NiIsICJzdGF0aW9uX25hbWUiOiAiREFWSVMgQU5EIERPV05JTkcgRElUQ0giLCAic3RhdGlvbl9zdGF0dXMiOiAiQWN0aXZlIiwgInN0YXRpb25fdHlwZSI6ICJEaXZlcnNpb24iLCAic3R5bGUiOiB7fSwgInVzZ3Nfc3RhdGlvbl9pZCI6ICJEQVZET1dDTyIsICJ2YXJpYWJsZSI6ICJESVNDSFJHIiwgIndkIjogIjUifSwgInR5cGUiOiAiRmVhdHVyZSJ9LCB7ImJib3giOiBbLTEwNS4xODkxOTEsIDQwLjE4NzU3OCwgLTEwNS4xODkxOTEsIDQwLjE4NzU3OF0sICJnZW9tZXRyeSI6IHsiY29vcmRpbmF0ZXMiOiBbLTEwNS4xODkxOTEsIDQwLjE4NzU3OF0sICJ0eXBlIjogIlBvaW50In0sICJpZCI6ICIxMSIsICJwcm9wZXJ0aWVzIjogeyJhbW91bnQiOiAiMi4yOCIsICJjb3VudHkiOiAiQk9VTERFUiIsICJkYXRhX3NvdXJjZSI6ICJDb29wZXJhdGl2ZSBQcm9ncmFtIG9mIENEV1IsIE5DV0NEICYgU1ZMSFdDRCIsICJkYXRlX3RpbWUiOiAiMjAxOC0wNS0xOFQxNTowMDowMCIsICJkaXYiOiAiMSIsICJkd3JfYWJicmV2IjogIkRFTlRBWUNPIiwgImhpZ2hsaWdodCI6IHt9LCAiaHR0cF9saW5rYWdlLnVybCI6ICJodHRwOi8vd3d3LmR3ci5zdGF0ZS5jby51cy9TdXJmYWNlV2F0ZXIvZGF0YS9kZXRhaWxfZ3JhcGguYXNweD9JRD1ERU5UQVlDTyZNVFlQRT1ESVNDSFJHIiwgImxvY2F0aW9uLmxhdGl0dWRlIjogNDAuMTg3NTc4LCAibG9jYXRpb24ubG9uZ2l0dWRlIjogLTEwNS4xODkxOTEsICJsb2NhdGlvbi5uZWVkc19yZWNvZGluZyI6IGZhbHNlLCAic3RhZ2UiOiAiMC41NyIsICJzdGF0aW9uX25hbWUiOiAiREVOSU8gVEFZTE9SIERJVENIIiwgInN0YXRpb25fc3RhdHVzIjogIkFjdGl2ZSIsICJzdGF0aW9uX3R5cGUiOiAiRGl2ZXJzaW9uIiwgInN0eWxlIjoge30sICJ1c2dzX3N0YXRpb25faWQiOiAiREVOVEFZQ08iLCAidmFyaWFibGUiOiAiRElTQ0hSRyIsICJ3ZCI6ICI1In0sICJ0eXBlIjogIkZlYXR1cmUifSwgeyJiYm94IjogWy0xMDUuMjIyNjM5LCA0MC4xOTkzMjEsIC0xMDUuMjIyNjM5LCA0MC4xOTkzMjFdLCAiZ2VvbWV0cnkiOiB7ImNvb3JkaW5hdGVzIjogWy0xMDUuMjIyNjM5LCA0MC4xOTkzMjFdLCAidHlwZSI6ICJQb2ludCJ9LCAiaWQiOiAiMTIiLCAicHJvcGVydGllcyI6IHsiYW1vdW50IjogIjExLjczIiwgImNvdW50eSI6ICJCT1VMREVSIiwgImRhdGFfc291cmNlIjogIkNvb3BlcmF0aXZlIFByb2dyYW0gb2YgQ0RXUiwgTkNXQ0QgJiBTVkxIV0NEIiwgImRhdGVfdGltZSI6ICIyMDE4LTA1LTE4VDE0OjQ1OjAwIiwgImRpdiI6ICIxIiwgImR3cl9hYmJyZXYiOiAiR09ESVQxQ08iLCAiaGlnaGxpZ2h0Ijoge30sICJodHRwX2xpbmthZ2UudXJsIjogImh0dHA6Ly93d3cuZHdyLnN0YXRlLmNvLnVzL1N1cmZhY2VXYXRlci9kYXRhL2RldGFpbF9ncmFwaC5hc3B4P0lEPUdPRElUMUNPJk1UWVBFPURJU0NIUkciLCAibG9jYXRpb24ubGF0aXR1ZGUiOiA0MC4xOTkzMjEsICJsb2NhdGlvbi5sb25naXR1ZGUiOiAtMTA1LjIyMjYzOSwgImxvY2F0aW9uLm5lZWRzX3JlY29kaW5nIjogZmFsc2UsICJzdGFnZSI6ICIxLjI4IiwgInN0YXRpb25fbmFtZSI6ICJHT1NTIERJVENIIDEiLCAic3RhdGlvbl9zdGF0dXMiOiAiQWN0aXZlIiwgInN0YXRpb25fdHlwZSI6ICJEaXZlcnNpb24iLCAic3R5bGUiOiB7fSwgInVzZ3Nfc3RhdGlvbl9pZCI6ICJHT0RJVDFDTyIsICJ2YXJpYWJsZSI6ICJESVNDSFJHIiwgIndkIjogIjUifSwgInR5cGUiOiAiRmVhdHVyZSJ9LCB7ImJib3giOiBbLTEwNS4xNjc4NzMsIDQwLjE3NDg0NCwgLTEwNS4xNjc4NzMsIDQwLjE3NDg0NF0sICJnZW9tZXRyeSI6IHsiY29vcmRpbmF0ZXMiOiBbLTEwNS4xNjc4NzMsIDQwLjE3NDg0NF0sICJ0eXBlIjogIlBvaW50In0sICJpZCI6ICIxMyIsICJwcm9wZXJ0aWVzIjogeyJhbW91bnQiOiAiMi42NyIsICJjb3VudHkiOiAiQk9VTERFUiIsICJkYXRhX3NvdXJjZSI6ICJDb29wZXJhdGl2ZSBQcm9ncmFtIG9mIENEV1IsIE5DV0NEICYgU1ZMSFdDRCIsICJkYXRlX3RpbWUiOiAiMjAxOC0wNS0xOFQxNDo0NTowMCIsICJkaXYiOiAiMSIsICJkd3JfYWJicmV2IjogIkhHUk1EV0NPIiwgImhpZ2hsaWdodCI6IHt9LCAiaHR0cF9saW5rYWdlLnVybCI6ICJodHRwOi8vd3d3LmR3ci5zdGF0ZS5jby51cy9TdXJmYWNlV2F0ZXIvZGF0YS9kZXRhaWxfZ3JhcGguYXNweD9JRD1IR1JNRFdDTyZNVFlQRT1ESVNDSFJHIiwgImxvY2F0aW9uLmxhdGl0dWRlIjogNDAuMTc0ODQ0LCAibG9jYXRpb24ubG9uZ2l0dWRlIjogLTEwNS4xNjc4NzMsICJsb2NhdGlvbi5uZWVkc19yZWNvZGluZyI6IGZhbHNlLCAic3RhZ2UiOiAiMC41NCIsICJzdGF0aW9uX25hbWUiOiAiSEFHRVIgTUVBRE9XUyBESVRDSCIsICJzdGF0aW9uX3N0YXR1cyI6ICJBY3RpdmUiLCAic3RhdGlvbl90eXBlIjogIkRpdmVyc2lvbiIsICJzdHlsZSI6IHt9LCAidXNnc19zdGF0aW9uX2lkIjogIkhHUk1EV0NPIiwgInZhcmlhYmxlIjogIkRJU0NIUkciLCAid2QiOiAiNSJ9LCAidHlwZSI6ICJGZWF0dXJlIn0sIHsiYmJveCI6IFstMTA1LjI1NjAxNywgNDAuMjE1MDQzLCAtMTA1LjI1NjAxNywgNDAuMjE1MDQzXSwgImdlb21ldHJ5IjogeyJjb29yZGluYXRlcyI6IFstMTA1LjI1NjAxNywgNDAuMjE1MDQzXSwgInR5cGUiOiAiUG9pbnQifSwgImlkIjogIjE0IiwgInByb3BlcnRpZXMiOiB7ImFtb3VudCI6ICI5Mi43MCIsICJjb3VudHkiOiAiQk9VTERFUiIsICJkYXRhX3NvdXJjZSI6ICJDby4gRGl2aXNpb24gb2YgV2F0ZXIgUmVzb3VyY2VzIiwgImRhdGVfdGltZSI6ICIyMDE4LTA1LTE4VDE1OjMwOjAwIiwgImRpdiI6ICIxIiwgImR3cl9hYmJyZXYiOiAiSElHSExEQ08iLCAiaGlnaGxpZ2h0Ijoge30sICJodHRwX2xpbmthZ2UudXJsIjogImh0dHA6Ly93d3cuZHdyLnN0YXRlLmNvLnVzL1N1cmZhY2VXYXRlci9kYXRhL2RldGFpbF9ncmFwaC5hc3B4P0lEPUhJR0hMRENPJk1UWVBFPURJU0NIUkciLCAibG9jYXRpb24ubGF0aXR1ZGUiOiA0MC4yMTUwNDMsICJsb2NhdGlvbi5sb25naXR1ZGUiOiAtMTA1LjI1NjAxNywgImxvY2F0aW9uLm5lZWRzX3JlY29kaW5nIjogZmFsc2UsICJzdGFnZSI6ICIxLjI4IiwgInN0YXRpb25fbmFtZSI6ICJISUdITEFORCBESVRDSCBBVCBMWU9OUywgQ08iLCAic3RhdGlvbl9zdGF0dXMiOiAiQWN0aXZlIiwgInN0YXRpb25fdHlwZSI6ICJEaXZlcnNpb24iLCAic3R5bGUiOiB7fSwgInVzZ3Nfc3RhdGlvbl9pZCI6IG51bGwsICJ2YXJpYWJsZSI6ICJESVNDSFJHIiwgIndkIjogIjUifSwgInR5cGUiOiAiRmVhdHVyZSJ9LCB7ImJib3giOiBbLTEwNS4yMDkyODIsIDQwLjE4ODU3OSwgLTEwNS4yMDkyODIsIDQwLjE4ODU3OV0sICJnZW9tZXRyeSI6IHsiY29vcmRpbmF0ZXMiOiBbLTEwNS4yMDkyODIsIDQwLjE4ODU3OV0sICJ0eXBlIjogIlBvaW50In0sICJpZCI6ICIxNSIsICJwcm9wZXJ0aWVzIjogeyJhbW91bnQiOiAiNC40OSIsICJjb3VudHkiOiAiQk9VTERFUiIsICJkYXRhX3NvdXJjZSI6ICJDb29wZXJhdGl2ZSBQcm9ncmFtIG9mIENEV1IsIE5DV0NEICYgU1ZMSFdDRCIsICJkYXRlX3RpbWUiOiAiMjAxOC0wNS0xOFQxNDo0NTowMCIsICJkaXYiOiAiMSIsICJkd3JfYWJicmV2IjogIkpBTURJVENPIiwgImhpZ2hsaWdodCI6IHt9LCAiaHR0cF9saW5rYWdlLnVybCI6ICJodHRwOi8vd3d3LmR3ci5zdGF0ZS5jby51cy9TdXJmYWNlV2F0ZXIvZGF0YS9kZXRhaWxfZ3JhcGguYXNweD9JRD1KQU1ESVRDTyZNVFlQRT1ESVNDSFJHIiwgImxvY2F0aW9uLmxhdGl0dWRlIjogNDAuMTg4NTc5LCAibG9jYXRpb24ubG9uZ2l0dWRlIjogLTEwNS4yMDkyODIsICJsb2NhdGlvbi5uZWVkc19yZWNvZGluZyI6IGZhbHNlLCAic3RhZ2UiOiAiMC4zOSIsICJzdGF0aW9uX25hbWUiOiAiSkFNRVMgRElUQ0giLCAic3RhdGlvbl9zdGF0dXMiOiAiQWN0aXZlIiwgInN0YXRpb25fdHlwZSI6ICJEaXZlcnNpb24iLCAic3R5bGUiOiB7fSwgInVzZ3Nfc3RhdGlvbl9pZCI6ICJKQU1ESVRDTyIsICJ2YXJpYWJsZSI6ICJESVNDSFJHIiwgIndkIjogIjUifSwgInR5cGUiOiAiRmVhdHVyZSJ9LCB7ImJib3giOiBbLTEwNS4xMzA4MTksIDQwLjEzNDI3OCwgLTEwNS4xMzA4MTksIDQwLjEzNDI3OF0sICJnZW9tZXRyeSI6IHsiY29vcmRpbmF0ZXMiOiBbLTEwNS4xMzA4MTksIDQwLjEzNDI3OF0sICJ0eXBlIjogIlBvaW50In0sICJpZCI6ICIxNiIsICJwcm9wZXJ0aWVzIjogeyJhbW91bnQiOiAiNDUuMjAiLCAiY291bnR5IjogIkJPVUxERVIiLCAiZGF0YV9zb3VyY2UiOiAiVS5TLiBHZW9sb2dpY2FsIFN1cnZleSAoRGF0YSBQcm92aWRlcikiLCAiZGF0ZV90aW1lIjogIjIwMTgtMDUtMThUMTU6MTA6MDAiLCAiZGl2IjogIjEiLCAiZHdyX2FiYnJldiI6ICJMRUZUSE9DTyIsICJoaWdobGlnaHQiOiB7fSwgImh0dHBfbGlua2FnZS51cmwiOiAiaHR0cDovL3dhdGVyZGF0YS51c2dzLmdvdi9ud2lzL3V2PzA2NzI0OTcwIiwgImxvY2F0aW9uLmxhdGl0dWRlIjogNDAuMTM0Mjc4LCAibG9jYXRpb24ubG9uZ2l0dWRlIjogLTEwNS4xMzA4MTksICJsb2NhdGlvbi5uZWVkc19yZWNvZGluZyI6IGZhbHNlLCAic3RhZ2UiOiBudWxsLCAic3RhdGlvbl9uYW1lIjogIkxFRlQgSEFORCBDUkVFSyBBVCBIT1ZFUiBST0FEIE5FQVIgTE9OR01PTlQsIENPIiwgInN0YXRpb25fc3RhdHVzIjogIkFjdGl2ZSIsICJzdGF0aW9uX3R5cGUiOiAiU3RyZWFtIiwgInN0eWxlIjoge30sICJ1c2dzX3N0YXRpb25faWQiOiAiMDY3MjQ5NzAiLCAidmFyaWFibGUiOiAiRElTQ0hSRyIsICJ3ZCI6ICI1In0sICJ0eXBlIjogIkZlYXR1cmUifSwgeyJiYm94IjogWy0xMDUuMzA0NDA0LCA0MC4xMjYzODksIC0xMDUuMzA0NDA0LCA0MC4xMjYzODldLCAiZ2VvbWV0cnkiOiB7ImNvb3JkaW5hdGVzIjogWy0xMDUuMzA0NDA0LCA0MC4xMjYzODldLCAidHlwZSI6ICJQb2ludCJ9LCAiaWQiOiAiMTciLCAicHJvcGVydGllcyI6IHsiYW1vdW50IjogIjEwMy4wMCIsICJjb3VudHkiOiAiQk9VTERFUiIsICJkYXRhX3NvdXJjZSI6ICJDby4gRGl2aXNpb24gb2YgV2F0ZXIgUmVzb3VyY2VzIiwgImRhdGVfdGltZSI6ICIyMDE4LTA1LTE4VDE1OjE1OjAwIiwgImRpdiI6ICIxIiwgImR3cl9hYmJyZXYiOiAiTEVGQ1JFQ08iLCAiaGlnaGxpZ2h0Ijoge30sICJodHRwX2xpbmthZ2UudXJsIjogImh0dHA6Ly93d3cuZHdyLnN0YXRlLmNvLnVzL1N1cmZhY2VXYXRlci9kYXRhL2RldGFpbF9ncmFwaC5hc3B4P0lEPUxFRkNSRUNPJk1UWVBFPURJU0NIUkciLCAibG9jYXRpb24ubGF0aXR1ZGUiOiA0MC4xMjYzODksICJsb2NhdGlvbi5sb25naXR1ZGUiOiAtMTA1LjMwNDQwNCwgImxvY2F0aW9uLm5lZWRzX3JlY29kaW5nIjogZmFsc2UsICJzdGFnZSI6ICIxLjY2IiwgInN0YXRpb25fbmFtZSI6ICJMRUZUIEhBTkQgQ1JFRUsgTkVBUiBCT1VMREVSLCBDTy4iLCAic3RhdGlvbl9zdGF0dXMiOiAiQWN0aXZlIiwgInN0YXRpb25fdHlwZSI6ICJTdHJlYW0iLCAic3R5bGUiOiB7fSwgInVzZ3Nfc3RhdGlvbl9pZCI6ICIwNjcyNDUwMCIsICJ2YXJpYWJsZSI6ICJESVNDSFJHIiwgIndkIjogIjUifSwgInR5cGUiOiAiRmVhdHVyZSJ9LCB7ImJib3giOiBbLTEwNS4yMTg3NzcsIDQwLjIwNDE5MywgLTEwNS4yMTg3NzcsIDQwLjIwNDE5M10sICJnZW9tZXRyeSI6IHsiY29vcmRpbmF0ZXMiOiBbLTEwNS4yMTg3NzcsIDQwLjIwNDE5M10sICJ0eXBlIjogIlBvaW50In0sICJpZCI6ICIxOCIsICJwcm9wZXJ0aWVzIjogeyJhbW91bnQiOiAiNS4yNSIsICJjb3VudHkiOiAiQk9VTERFUiIsICJkYXRhX3NvdXJjZSI6ICJDb29wZXJhdGl2ZSBQcm9ncmFtIG9mIENEV1IsIE5DV0NEICYgU1ZMSFdDRCIsICJkYXRlX3RpbWUiOiAiMjAxOC0wNS0xOFQxNTowMDowMCIsICJkaXYiOiAiMSIsICJkd3JfYWJicmV2IjogIkxPTlNVUENPIiwgImhpZ2hsaWdodCI6IHt9LCAiaHR0cF9saW5rYWdlLnVybCI6ICJodHRwOi8vd3d3LmR3ci5zdGF0ZS5jby51cy9TdXJmYWNlV2F0ZXIvZGF0YS9kZXRhaWxfZ3JhcGguYXNweD9JRD1MT05TVVBDTyZNVFlQRT1ESVNDSFJHIiwgImxvY2F0aW9uLmxhdGl0dWRlIjogNDAuMjA0MTkzLCAibG9jYXRpb24ubG9uZ2l0dWRlIjogLTEwNS4yMTg3NzcsICJsb2NhdGlvbi5uZWVkc19yZWNvZGluZyI6IGZhbHNlLCAic3RhZ2UiOiAiMC41OSIsICJzdGF0aW9uX25hbWUiOiAiTE9OR01PTlQgU1VQUExZIERJVENIIiwgInN0YXRpb25fc3RhdHVzIjogIkFjdGl2ZSIsICJzdGF0aW9uX3R5cGUiOiAiRGl2ZXJzaW9uIiwgInN0eWxlIjoge30sICJ1c2dzX3N0YXRpb25faWQiOiAiTE9OU1VQQ08iLCAidmFyaWFibGUiOiAiRElTQ0hSRyIsICJ3ZCI6ICI1In0sICJ0eXBlIjogIkZlYXR1cmUifSwgeyJiYm94IjogWy0xMDUuNTE3MTExLCA0MC4xMjk4MDYsIC0xMDUuNTE3MTExLCA0MC4xMjk4MDZdLCAiZ2VvbWV0cnkiOiB7ImNvb3JkaW5hdGVzIjogWy0xMDUuNTE3MTExLCA0MC4xMjk4MDZdLCAidHlwZSI6ICJQb2ludCJ9LCAiaWQiOiAiMTkiLCAicHJvcGVydGllcyI6IHsiYW1vdW50IjogIjk2LjAwIiwgImNvdW50eSI6ICJCT1VMREVSIiwgImRhdGFfc291cmNlIjogIkNvLiBEaXZpc2lvbiBvZiBXYXRlciBSZXNvdXJjZXMiLCAiZGF0ZV90aW1lIjogIjIwMTgtMDUtMThUMTU6MDA6MDAiLCAiZGl2IjogIjEiLCAiZHdyX2FiYnJldiI6ICJNSURTVEVDTyIsICJoaWdobGlnaHQiOiB7fSwgImh0dHBfbGlua2FnZS51cmwiOiAiaHR0cDovL3d3dy5kd3Iuc3RhdGUuY28udXMvU3VyZmFjZVdhdGVyL2RhdGEvZGV0YWlsX2dyYXBoLmFzcHg/SUQ9TUlEU1RFQ08mTVRZUEU9RElTQ0hSRyIsICJsb2NhdGlvbi5sYXRpdHVkZSI6IDQwLjEyOTgwNiwgImxvY2F0aW9uLmxvbmdpdHVkZSI6IC0xMDUuNTE3MTExLCAibG9jYXRpb24ubmVlZHNfcmVjb2RpbmciOiBmYWxzZSwgInN0YWdlIjogIjMuNzAiLCAic3RhdGlvbl9uYW1lIjogIk1JRERMRSBTQUlOVCBWUkFJTiBBVCBQRUFDRUZVTCBWQUxMRVkiLCAic3RhdGlvbl9zdGF0dXMiOiAiQWN0aXZlIiwgInN0YXRpb25fdHlwZSI6ICJTdHJlYW0iLCAic3R5bGUiOiB7fSwgInVzZ3Nfc3RhdGlvbl9pZCI6IG51bGwsICJ2YXJpYWJsZSI6ICJESVNDSFJHIiwgIndkIjogIjUifSwgInR5cGUiOiAiRmVhdHVyZSJ9LCB7ImJib3giOiBbLTEwNS4xNjkzNzQsIDQwLjE3Mzk1LCAtMTA1LjE2OTM3NCwgNDAuMTczOTVdLCAiZ2VvbWV0cnkiOiB7ImNvb3JkaW5hdGVzIjogWy0xMDUuMTY5Mzc0LCA0MC4xNzM5NV0sICJ0eXBlIjogIlBvaW50In0sICJpZCI6ICIyMCIsICJwcm9wZXJ0aWVzIjogeyJhbW91bnQiOiAiNS41NSIsICJjb3VudHkiOiAiQk9VTERFUiIsICJkYXRhX3NvdXJjZSI6ICJDb29wZXJhdGl2ZSBQcm9ncmFtIG9mIENEV1IsIE5DV0NEICYgU1ZMSFdDRCIsICJkYXRlX3RpbWUiOiAiMjAxOC0wNS0xOFQxNDo0NTowMCIsICJkaXYiOiAiMSIsICJkd3JfYWJicmV2IjogIk5JV0RJVENPIiwgImhpZ2hsaWdodCI6IHt9LCAiaHR0cF9saW5rYWdlLnVybCI6ICJodHRwOi8vd3d3LmR3ci5zdGF0ZS5jby51cy9TdXJmYWNlV2F0ZXIvZGF0YS9kZXRhaWxfZ3JhcGguYXNweD9JRD1OSVdESVRDTyZNVFlQRT1ESVNDSFJHIiwgImxvY2F0aW9uLmxhdGl0dWRlIjogNDAuMTczOTUsICJsb2NhdGlvbi5sb25naXR1ZGUiOiAtMTA1LjE2OTM3NCwgImxvY2F0aW9uLm5lZWRzX3JlY29kaW5nIjogZmFsc2UsICJzdGFnZSI6ICIwLjc5IiwgInN0YXRpb25fbmFtZSI6ICJOSVdPVCBESVRDSCIsICJzdGF0aW9uX3N0YXR1cyI6ICJBY3RpdmUiLCAic3RhdGlvbl90eXBlIjogIkRpdmVyc2lvbiIsICJzdHlsZSI6IHt9LCAidXNnc19zdGF0aW9uX2lkIjogIk5JV0RJVENPIiwgInZhcmlhYmxlIjogIkRJU0NIUkciLCAid2QiOiAiNSJ9LCAidHlwZSI6ICJGZWF0dXJlIn0sIHsiYmJveCI6IFstMTA1LjM2MzQyMiwgNDAuMjE1NjU4LCAtMTA1LjM2MzQyMiwgNDAuMjE1NjU4XSwgImdlb21ldHJ5IjogeyJjb29yZGluYXRlcyI6IFstMTA1LjM2MzQyMiwgNDAuMjE1NjU4XSwgInR5cGUiOiAiUG9pbnQifSwgImlkIjogIjIxIiwgInByb3BlcnRpZXMiOiB7ImFtb3VudCI6ICIxNTguMDAiLCAiY291bnR5IjogIkJPVUxERVIiLCAiZGF0YV9zb3VyY2UiOiAiQ28uIERpdmlzaW9uIG9mIFdhdGVyIFJlc291cmNlcyIsICJkYXRlX3RpbWUiOiAiMjAxOC0wNS0xOFQxNTo0NTowMCIsICJkaXYiOiAiMSIsICJkd3JfYWJicmV2IjogIk5TVkJCUkNPIiwgImhpZ2hsaWdodCI6IHt9LCAiaHR0cF9saW5rYWdlLnVybCI6ICJodHRwOi8vd3d3LmR3ci5zdGF0ZS5jby51cy9TdXJmYWNlV2F0ZXIvZGF0YS9kZXRhaWxfZ3JhcGguYXNweD9JRD1OU1ZCQlJDTyZNVFlQRT1ESVNDSFJHIiwgImxvY2F0aW9uLmxhdGl0dWRlIjogNDAuMjE1NjU4LCAibG9jYXRpb24ubG9uZ2l0dWRlIjogLTEwNS4zNjM0MjIsICJsb2NhdGlvbi5uZWVkc19yZWNvZGluZyI6IGZhbHNlLCAic3RhZ2UiOiAiMS4xMyIsICJzdGF0aW9uX25hbWUiOiAiTk9SVEggU0FJTlQgVlJBSU4gQ1JFRUsgQkVMT1cgQlVUVE9OUk9DSyAgKFJBTFBIIFBSSUNFKSBSRVNFUlZPSVIiLCAic3RhdGlvbl9zdGF0dXMiOiAiQWN0aXZlIiwgInN0YXRpb25fdHlwZSI6ICJTdHJlYW0iLCAic3R5bGUiOiB7fSwgInVzZ3Nfc3RhdGlvbl9pZCI6ICJOU1ZCQlJDTyIsICJ2YXJpYWJsZSI6ICJESVNDSFJHIiwgIndkIjogIjUifSwgInR5cGUiOiAiRmVhdHVyZSJ9LCB7ImJib3giOiBbLTEwNS4xNjc2MjIsIDQwLjE3MjkyNSwgLTEwNS4xNjc2MjIsIDQwLjE3MjkyNV0sICJnZW9tZXRyeSI6IHsiY29vcmRpbmF0ZXMiOiBbLTEwNS4xNjc2MjIsIDQwLjE3MjkyNV0sICJ0eXBlIjogIlBvaW50In0sICJpZCI6ICIyMiIsICJwcm9wZXJ0aWVzIjogeyJhbW91bnQiOiAiMS42MSIsICJjb3VudHkiOiAiQk9VTERFUiIsICJkYXRhX3NvdXJjZSI6ICJDb29wZXJhdGl2ZSBTRFIgUHJvZ3JhbSBvZiBDRFdSICYgTkNXQ0QiLCAiZGF0ZV90aW1lIjogIjIwMTgtMDUtMThUMTU6MDA6MDAiLCAiZGl2IjogIjEiLCAiZHdyX2FiYnJldiI6ICJOT1JNVVRDTyIsICJoaWdobGlnaHQiOiB7fSwgImh0dHBfbGlua2FnZS51cmwiOiAiaHR0cDovL3d3dy5kd3Iuc3RhdGUuY28udXMvU3VyZmFjZVdhdGVyL2RhdGEvZGV0YWlsX2dyYXBoLmFzcHg/SUQ9Tk9STVVUQ08mTVRZUEU9RElTQ0hSRyIsICJsb2NhdGlvbi5sYXRpdHVkZSI6IDQwLjE3MjkyNSwgImxvY2F0aW9uLmxvbmdpdHVkZSI6IC0xMDUuMTY3NjIyLCAibG9jYXRpb24ubmVlZHNfcmVjb2RpbmciOiBmYWxzZSwgInN0YWdlIjogIjAuNTUiLCAic3RhdGlvbl9uYW1lIjogIk5PUlRIV0VTVCBNVVRVQUwgRElUQ0giLCAic3RhdGlvbl9zdGF0dXMiOiAiQWN0aXZlIiwgInN0YXRpb25fdHlwZSI6ICJEaXZlcnNpb24iLCAic3R5bGUiOiB7fSwgInVzZ3Nfc3RhdGlvbl9pZCI6ICJOT1JNVVRDTyIsICJ2YXJpYWJsZSI6ICJESVNDSFJHIiwgIndkIjogIjUifSwgInR5cGUiOiAiRmVhdHVyZSJ9LCB7ImJib3giOiBbLTEwNS4yMDY1OTIsIDQwLjE5NjQyMiwgLTEwNS4yMDY1OTIsIDQwLjE5NjQyMl0sICJnZW9tZXRyeSI6IHsiY29vcmRpbmF0ZXMiOiBbLTEwNS4yMDY1OTIsIDQwLjE5NjQyMl0sICJ0eXBlIjogIlBvaW50In0sICJpZCI6ICIyMyIsICJwcm9wZXJ0aWVzIjogeyJhbW91bnQiOiAiMjUuMzgiLCAiY291bnR5IjogIkJPVUxERVIiLCAiZGF0YV9zb3VyY2UiOiAiQ29vcGVyYXRpdmUgUHJvZ3JhbSBvZiBDRFdSLCBOQ1dDRCAmIFNWTEhXQ0QiLCAiZGF0ZV90aW1lIjogIjIwMTgtMDUtMTVUMTI6MDA6MDAiLCAiZGl2IjogIjEiLCAiZHdyX2FiYnJldiI6ICJPTElESVRDTyIsICJoaWdobGlnaHQiOiB7fSwgImh0dHBfbGlua2FnZS51cmwiOiAiaHR0cDovL3d3dy5kd3Iuc3RhdGUuY28udXMvU3VyZmFjZVdhdGVyL2RhdGEvZGV0YWlsX2dyYXBoLmFzcHg/SUQ9T0xJRElUQ08mTVRZUEU9RElTQ0hSRyIsICJsb2NhdGlvbi5sYXRpdHVkZSI6IDQwLjE5NjQyMiwgImxvY2F0aW9uLmxvbmdpdHVkZSI6IC0xMDUuMjA2NTkyLCAibG9jYXRpb24ubmVlZHNfcmVjb2RpbmciOiBmYWxzZSwgInN0YWdlIjogIjAuNzYiLCAic3RhdGlvbl9uYW1lIjogIk9MSUdBUkNIWSBESVRDSCBESVZFUlNJT04iLCAic3RhdGlvbl9zdGF0dXMiOiAiQWN0aXZlIiwgInN0YXRpb25fdHlwZSI6ICJEaXZlcnNpb24iLCAic3R5bGUiOiB7fSwgInVzZ3Nfc3RhdGlvbl9pZCI6IG51bGwsICJ2YXJpYWJsZSI6ICJESVNDSFJHIiwgIndkIjogIjUifSwgInR5cGUiOiAiRmVhdHVyZSJ9LCB7ImJib3giOiBbLTEwNS4yNTE4MjYsIDQwLjIxMjUwNSwgLTEwNS4yNTE4MjYsIDQwLjIxMjUwNV0sICJnZW9tZXRyeSI6IHsiY29vcmRpbmF0ZXMiOiBbLTEwNS4yNTE4MjYsIDQwLjIxMjUwNV0sICJ0eXBlIjogIlBvaW50In0sICJpZCI6ICIyNCIsICJwcm9wZXJ0aWVzIjogeyJhbW91bnQiOiAiMjYuNTYiLCAiY291bnR5IjogIkJPVUxERVIiLCAiZGF0YV9zb3VyY2UiOiAiQ29vcGVyYXRpdmUgUHJvZ3JhbSBvZiBDRFdSLCBOQ1dDRCAmIFNWTEhXQ0QiLCAiZGF0ZV90aW1lIjogIjIwMTgtMDUtMThUMTQ6MDA6MDAiLCAiZGl2IjogIjEiLCAiZHdyX2FiYnJldiI6ICJQQUxESVRDTyIsICJoaWdobGlnaHQiOiB7fSwgImh0dHBfbGlua2FnZS51cmwiOiAiaHR0cDovL3d3dy5kd3Iuc3RhdGUuY28udXMvU3VyZmFjZVdhdGVyL2RhdGEvZGV0YWlsX2dyYXBoLmFzcHg/SUQ9UEFMRElUQ08mTVRZUEU9RElTQ0hSRyIsICJsb2NhdGlvbi5sYXRpdHVkZSI6IDQwLjIxMjUwNSwgImxvY2F0aW9uLmxvbmdpdHVkZSI6IC0xMDUuMjUxODI2LCAibG9jYXRpb24ubmVlZHNfcmVjb2RpbmciOiBmYWxzZSwgInN0YWdlIjogIjAuODkiLCAic3RhdGlvbl9uYW1lIjogIlBBTE1FUlRPTiBESVRDSCIsICJzdGF0aW9uX3N0YXR1cyI6ICJBY3RpdmUiLCAic3RhdGlvbl90eXBlIjogIkRpdmVyc2lvbiIsICJzdHlsZSI6IHt9LCAidXNnc19zdGF0aW9uX2lkIjogIlBBTERJVENPIiwgInZhcmlhYmxlIjogIkRJU0NIUkciLCAid2QiOiAiNSJ9LCAidHlwZSI6ICJGZWF0dXJlIn0sIHsiYmJveCI6IFstMTA1LjE3ODU2NywgNDAuMTc3MDgwMDAwMDAwMDA0LCAtMTA1LjE3ODU2NywgNDAuMTc3MDgwMDAwMDAwMDA0XSwgImdlb21ldHJ5IjogeyJjb29yZGluYXRlcyI6IFstMTA1LjE3ODU2NywgNDAuMTc3MDgwMDAwMDAwMDA0XSwgInR5cGUiOiAiUG9pbnQifSwgImlkIjogIjI1IiwgInByb3BlcnRpZXMiOiB7ImFtb3VudCI6ICIxLjI5IiwgImNvdW50eSI6ICJCT1VMREVSIiwgImRhdGFfc291cmNlIjogIkNvb3BlcmF0aXZlIFNEUiBQcm9ncmFtIG9mIENEV1IgJiBOQ1dDRCIsICJkYXRlX3RpbWUiOiAiMjAxOC0wNS0xN1QxMzowMDowMCIsICJkaXYiOiAiMSIsICJkd3JfYWJicmV2IjogIlBDS1BFTENPIiwgImhpZ2hsaWdodCI6IHt9LCAiaHR0cF9saW5rYWdlLnVybCI6ICJodHRwOi8vd3d3LmR3ci5zdGF0ZS5jby51cy9TdXJmYWNlV2F0ZXIvZGF0YS9kZXRhaWxfZ3JhcGguYXNweD9JRD1QQ0tQRUxDTyZNVFlQRT1ESVNDSFJHIiwgImxvY2F0aW9uLmxhdGl0dWRlIjogNDAuMTc3MDgsICJsb2NhdGlvbi5sb25naXR1ZGUiOiAtMTA1LjE3ODU2NywgImxvY2F0aW9uLm5lZWRzX3JlY29kaW5nIjogZmFsc2UsICJzdGFnZSI6ICIwLjE2IiwgInN0YXRpb25fbmFtZSI6ICJQRUNLIFBFTExBIENMT1ZFUiBESVRDSCIsICJzdGF0aW9uX3N0YXR1cyI6ICJBY3RpdmUiLCAic3RhdGlvbl90eXBlIjogIkRpdmVyc2lvbiIsICJzdHlsZSI6IHt9LCAidXNnc19zdGF0aW9uX2lkIjogIlBDS1BFTENPIiwgInZhcmlhYmxlIjogIkRJU0NIUkciLCAid2QiOiAiNSJ9LCAidHlwZSI6ICJGZWF0dXJlIn0sIHsiYmJveCI6IFstMTA1LjI1MTgyNiwgNDAuMjEyNjU4LCAtMTA1LjI1MTgyNiwgNDAuMjEyNjU4XSwgImdlb21ldHJ5IjogeyJjb29yZGluYXRlcyI6IFstMTA1LjI1MTgyNiwgNDAuMjEyNjU4XSwgInR5cGUiOiAiUG9pbnQifSwgImlkIjogIjI2IiwgInByb3BlcnRpZXMiOiB7ImFtb3VudCI6ICIzMi45NiIsICJjb3VudHkiOiAiQk9VTERFUiIsICJkYXRhX3NvdXJjZSI6ICJDb29wZXJhdGl2ZSBQcm9ncmFtIG9mIENEV1IsIE5DV0NEICYgU1ZMSFdDRCIsICJkYXRlX3RpbWUiOiAiMjAxOC0wNS0xOFQxNTowMDowMCIsICJkaXYiOiAiMSIsICJkd3JfYWJicmV2IjogIlJPVVJFQUNPIiwgImhpZ2hsaWdodCI6IHt9LCAiaHR0cF9saW5rYWdlLnVybCI6ICJodHRwOi8vd3d3LmR3ci5zdGF0ZS5jby51cy9TdXJmYWNlV2F0ZXIvZGF0YS9kZXRhaWxfZ3JhcGguYXNweD9JRD1ST1VSRUFDTyZNVFlQRT1ESVNDSFJHIiwgImxvY2F0aW9uLmxhdGl0dWRlIjogNDAuMjEyNjU4LCAibG9jYXRpb24ubG9uZ2l0dWRlIjogLTEwNS4yNTE4MjYsICJsb2NhdGlvbi5uZWVkc19yZWNvZGluZyI6IGZhbHNlLCAic3RhZ2UiOiAiMS4zNyIsICJzdGF0aW9uX25hbWUiOiAiUk9VR0ggQU5EIFJFQURZIERJVENIIiwgInN0YXRpb25fc3RhdHVzIjogIkFjdGl2ZSIsICJzdGF0aW9uX3R5cGUiOiAiRGl2ZXJzaW9uIiwgInN0eWxlIjoge30sICJ1c2dzX3N0YXRpb25faWQiOiAiUk9VUkVBQ08iLCAidmFyaWFibGUiOiAiRElTQ0hSRyIsICJ3ZCI6ICI1In0sICJ0eXBlIjogIkZlYXR1cmUifSwgeyJiYm94IjogWy0xMDUuMTg5MTMyLCA0MC4xODc1MjQsIC0xMDUuMTg5MTMyLCA0MC4xODc1MjRdLCAiZ2VvbWV0cnkiOiB7ImNvb3JkaW5hdGVzIjogWy0xMDUuMTg5MTMyLCA0MC4xODc1MjRdLCAidHlwZSI6ICJQb2ludCJ9LCAiaWQiOiAiMjciLCAicHJvcGVydGllcyI6IHsiYW1vdW50IjogIjAuMDAiLCAiY291bnR5IjogIkJPVUxERVIiLCAiZGF0YV9zb3VyY2UiOiAiQ29vcGVyYXRpdmUgUHJvZ3JhbSBvZiBDRFdSLCBOQ1dDRCAmIFNWTEhXQ0QiLCAiZGF0ZV90aW1lIjogIjIwMTgtMDUtMThUMTU6MDA6MDAiLCAiZGl2IjogIjEiLCAiZHdyX2FiYnJldiI6ICJSVU5ZT05DTyIsICJoaWdobGlnaHQiOiB7fSwgImh0dHBfbGlua2FnZS51cmwiOiAiaHR0cDovL3d3dy5kd3Iuc3RhdGUuY28udXMvU3VyZmFjZVdhdGVyL2RhdGEvZGV0YWlsX2dyYXBoLmFzcHg/SUQ9UlVOWU9OQ08mTVRZUEU9RElTQ0hSRyIsICJsb2NhdGlvbi5sYXRpdHVkZSI6IDQwLjE4NzUyNCwgImxvY2F0aW9uLmxvbmdpdHVkZSI6IC0xMDUuMTg5MTMyLCAibG9jYXRpb24ubmVlZHNfcmVjb2RpbmciOiBmYWxzZSwgInN0YWdlIjogbnVsbCwgInN0YXRpb25fbmFtZSI6ICJSVU5ZT04gRElUQ0giLCAic3RhdGlvbl9zdGF0dXMiOiAiQWN0aXZlIiwgInN0YXRpb25fdHlwZSI6ICJEaXZlcnNpb24iLCAic3R5bGUiOiB7fSwgInVzZ3Nfc3RhdGlvbl9pZCI6ICJSVU5ZT05DTyIsICJ2YXJpYWJsZSI6ICJESVNDSFJHIiwgIndkIjogIjUifSwgInR5cGUiOiAiRmVhdHVyZSJ9LCB7ImJib3giOiBbLTEwNS4xNzgxNDUsIDQwLjE3NzQyMywgLTEwNS4xNzgxNDUsIDQwLjE3NzQyM10sICJnZW9tZXRyeSI6IHsiY29vcmRpbmF0ZXMiOiBbLTEwNS4xNzgxNDUsIDQwLjE3NzQyM10sICJ0eXBlIjogIlBvaW50In0sICJpZCI6ICIyOCIsICJwcm9wZXJ0aWVzIjogeyJhbW91bnQiOiAiNDQuMjAiLCAiY291bnR5IjogIkJPVUxERVIiLCAiZGF0YV9zb3VyY2UiOiAiQ28uIERpdmlzaW9uIG9mIFdhdGVyIFJlc291cmNlcyIsICJkYXRlX3RpbWUiOiAiMjAxOC0wNS0xOFQxNTo0NTowMCIsICJkaXYiOiAiMSIsICJkd3JfYWJicmV2IjogIlNWQ0hHSUNPIiwgImhpZ2hsaWdodCI6IHt9LCAiaHR0cF9saW5rYWdlLnVybCI6ICJodHRwOi8vd3d3LmR3ci5zdGF0ZS5jby51cy9TdXJmYWNlV2F0ZXIvZGF0YS9kZXRhaWxfZ3JhcGguYXNweD9JRD1TVkNIR0lDTyZNVFlQRT1ESVNDSFJHIiwgImxvY2F0aW9uLmxhdGl0dWRlIjogNDAuMTc3NDIzLCAibG9jYXRpb24ubG9uZ2l0dWRlIjogLTEwNS4xNzgxNDUsICJsb2NhdGlvbi5uZWVkc19yZWNvZGluZyI6IGZhbHNlLCAic3RhZ2UiOiAiMi41MiIsICJzdGF0aW9uX25hbWUiOiAiU0FJTlQgVlJBSU4gQ1JFRUsgQVQgSFlHSUVORSwgQ08iLCAic3RhdGlvbl9zdGF0dXMiOiAiQWN0aXZlIiwgInN0YXRpb25fdHlwZSI6ICJTdHJlYW0iLCAic3R5bGUiOiB7fSwgInVzZ3Nfc3RhdGlvbl9pZCI6ICJTVkNIR0lDTyIsICJ2YXJpYWJsZSI6ICJESVNDSFJHIiwgIndkIjogIjUifSwgInR5cGUiOiAiRmVhdHVyZSJ9LCB7ImJib3giOiBbLTEwNS4yNjM0OSwgNDAuMjIwNzAyLCAtMTA1LjI2MzQ5LCA0MC4yMjA3MDJdLCAiZ2VvbWV0cnkiOiB7ImNvb3JkaW5hdGVzIjogWy0xMDUuMjYzNDksIDQwLjIyMDcwMl0sICJ0eXBlIjogIlBvaW50In0sICJpZCI6ICIyOSIsICJwcm9wZXJ0aWVzIjogeyJhbW91bnQiOiAiMjQ1LjAwIiwgImNvdW50eSI6ICJCT1VMREVSIiwgImRhdGFfc291cmNlIjogIkNvLiBEaXZpc2lvbiBvZiBXYXRlciBSZXNvdXJjZXMiLCAiZGF0ZV90aW1lIjogIjIwMTgtMDUtMThUMTU6MTU6MDAiLCAiZGl2IjogIjEiLCAiZHdyX2FiYnJldiI6ICJTVkNMWU9DTyIsICJoaWdobGlnaHQiOiB7fSwgImh0dHBfbGlua2FnZS51cmwiOiAiaHR0cDovL3d3dy5kd3Iuc3RhdGUuY28udXMvU3VyZmFjZVdhdGVyL2RhdGEvZGV0YWlsX2dyYXBoLmFzcHg/SUQ9U1ZDTFlPQ08mTVRZUEU9RElTQ0hSRyIsICJsb2NhdGlvbi5sYXRpdHVkZSI6IDQwLjIyMDcwMiwgImxvY2F0aW9uLmxvbmdpdHVkZSI6IC0xMDUuMjYzNDksICJsb2NhdGlvbi5uZWVkc19yZWNvZGluZyI6IGZhbHNlLCAic3RhZ2UiOiAiMy45OCIsICJzdGF0aW9uX25hbWUiOiAiU0FJTlQgVlJBSU4gQ1JFRUsgQVQgTFlPTlMsIENPIiwgInN0YXRpb25fc3RhdHVzIjogIkFjdGl2ZSIsICJzdGF0aW9uX3R5cGUiOiAiU3RyZWFtIiwgInN0eWxlIjoge30sICJ1c2dzX3N0YXRpb25faWQiOiAiMDY3MjQwMDAiLCAidmFyaWFibGUiOiAiRElTQ0hSRyIsICJ3ZCI6ICI1In0sICJ0eXBlIjogIkZlYXR1cmUifSwgeyJiYm94IjogWy0xMDUuMDc1Njk1MDAwMDAwMDEsIDQwLjE1MzM0MSwgLTEwNS4wNzU2OTUwMDAwMDAwMSwgNDAuMTUzMzQxXSwgImdlb21ldHJ5IjogeyJjb29yZGluYXRlcyI6IFstMTA1LjA3NTY5NTAwMDAwMDAxLCA0MC4xNTMzNDFdLCAidHlwZSI6ICJQb2ludCJ9LCAiaWQiOiAiMzAiLCAicHJvcGVydGllcyI6IHsiYW1vdW50IjogIjExMy4wMCIsICJjb3VudHkiOiAiQk9VTERFUiIsICJkYXRhX3NvdXJjZSI6ICJDby4gRGl2aXNpb24gb2YgV2F0ZXIgUmVzb3VyY2VzIiwgImRhdGVfdGltZSI6ICIyMDE4LTA1LTE4VDE1OjMwOjAwIiwgImRpdiI6ICIxIiwgImR3cl9hYmJyZXYiOiAiU1ZDTE9QQ08iLCAiaGlnaGxpZ2h0Ijoge30sICJodHRwX2xpbmthZ2UudXJsIjogImh0dHA6Ly93d3cuZHdyLnN0YXRlLmNvLnVzL1N1cmZhY2VXYXRlci9kYXRhL2RldGFpbF9ncmFwaC5hc3B4P0lEPVNWQ0xPUENPJk1UWVBFPURJU0NIUkciLCAibG9jYXRpb24ubGF0aXR1ZGUiOiA0MC4xNTMzNDEsICJsb2NhdGlvbi5sb25naXR1ZGUiOiAtMTA1LjA3NTY5NSwgImxvY2F0aW9uLm5lZWRzX3JlY29kaW5nIjogZmFsc2UsICJzdGFnZSI6ICI0LjQ4IiwgInN0YXRpb25fbmFtZSI6ICJTQUlOVCBWUkFJTiBDUkVFSyBCRUxPVyBLRU4gUFJBVFQgQkxWRCBBVCBMT05HTU9OVCwgQ08iLCAic3RhdGlvbl9zdGF0dXMiOiAiQWN0aXZlIiwgInN0YXRpb25fdHlwZSI6ICJTdHJlYW0iLCAic3R5bGUiOiB7fSwgInVzZ3Nfc3RhdGlvbl9pZCI6ICJTVkNMT1BDTyIsICJ2YXJpYWJsZSI6ICJESVNDSFJHIiwgIndkIjogIjUifSwgInR5cGUiOiAiRmVhdHVyZSJ9LCB7ImJib3giOiBbLTEwNS4yNTgxMSwgNDAuMjE4MzM1LCAtMTA1LjI1ODExLCA0MC4yMTgzMzVdLCAiZ2VvbWV0cnkiOiB7ImNvb3JkaW5hdGVzIjogWy0xMDUuMjU4MTEsIDQwLjIxODMzNV0sICJ0eXBlIjogIlBvaW50In0sICJpZCI6ICIzMSIsICJwcm9wZXJ0aWVzIjogeyJhbW91bnQiOiAiNTguNTAiLCAiY291bnR5IjogIkJPVUxERVIiLCAiZGF0YV9zb3VyY2UiOiAiTm9ydGhlcm4gQ29sb3JhZG8gV2F0ZXIgQ29uc2VydmFuY3kgRGlzdHJpY3QgKFN0YXRpb24gQ29vcGVyYXRvcikiLCAiZGF0ZV90aW1lIjogIjIwMTgtMDUtMThUMTU6MzA6MDAiLCAiZGl2IjogIjEiLCAiZHdyX2FiYnJldiI6ICJTVlNMWU9DTyIsICJoaWdobGlnaHQiOiB7fSwgImh0dHBfbGlua2FnZS51cmwiOiAiaHR0cDovL3d3dy5kd3Iuc3RhdGUuY28udXMvU3VyZmFjZVdhdGVyL2RhdGEvZGV0YWlsX2dyYXBoLmFzcHg/SUQ9U1ZTTFlPQ08mTVRZUEU9RElTQ0hSRyIsICJsb2NhdGlvbi5sYXRpdHVkZSI6IDQwLjIxODMzNSwgImxvY2F0aW9uLmxvbmdpdHVkZSI6IC0xMDUuMjU4MTEsICJsb2NhdGlvbi5uZWVkc19yZWNvZGluZyI6IGZhbHNlLCAic3RhZ2UiOiAiMS4wMiIsICJzdGF0aW9uX25hbWUiOiAiU0FJTlQgVlJBSU4gU1VQUExZIENBTkFMIE5FQVIgTFlPTlMsIENPIiwgInN0YXRpb25fc3RhdHVzIjogIkFjdGl2ZSIsICJzdGF0aW9uX3R5cGUiOiAiRGl2ZXJzaW9uIiwgInN0eWxlIjoge30sICJ1c2dzX3N0YXRpb25faWQiOiBudWxsLCAidmFyaWFibGUiOiAiRElTQ0hSRyIsICJ3ZCI6ICI1In0sICJ0eXBlIjogIkZlYXR1cmUifSwgeyJiYm94IjogWy0xMDUuMjUwOTUyLCA0MC4yMTEzODksIC0xMDUuMjUwOTUyLCA0MC4yMTEzODldLCAiZ2VvbWV0cnkiOiB7ImNvb3JkaW5hdGVzIjogWy0xMDUuMjUwOTUyLCA0MC4yMTEzODldLCAidHlwZSI6ICJQb2ludCJ9LCAiaWQiOiAiMzIiLCAicHJvcGVydGllcyI6IHsiYW1vdW50IjogIjEuODgiLCAiY291bnR5IjogIkJPVUxERVIiLCAiZGF0YV9zb3VyY2UiOiAiQ29vcGVyYXRpdmUgUHJvZ3JhbSBvZiBDRFdSLCBOQ1dDRCAmIFNWTEhXQ0QiLCAiZGF0ZV90aW1lIjogIjIwMTgtMDUtMThUMTQ6MDA6MDAiLCAiZGl2IjogIjEiLCAiZHdyX2FiYnJldiI6ICJTTUVESVRDTyIsICJoaWdobGlnaHQiOiB7fSwgImh0dHBfbGlua2FnZS51cmwiOiAiaHR0cDovL3d3dy5kd3Iuc3RhdGUuY28udXMvU3VyZmFjZVdhdGVyL2RhdGEvZGV0YWlsX2dyYXBoLmFzcHg/SUQ9U01FRElUQ08mTVRZUEU9RElTQ0hSRyIsICJsb2NhdGlvbi5sYXRpdHVkZSI6IDQwLjIxMTM4OSwgImxvY2F0aW9uLmxvbmdpdHVkZSI6IC0xMDUuMjUwOTUyLCAibG9jYXRpb24ubmVlZHNfcmVjb2RpbmciOiBmYWxzZSwgInN0YWdlIjogIjAuNDciLCAic3RhdGlvbl9uYW1lIjogIlNNRUFEIERJVENIIiwgInN0YXRpb25fc3RhdHVzIjogIkFjdGl2ZSIsICJzdGF0aW9uX3R5cGUiOiAiRGl2ZXJzaW9uIiwgInN0eWxlIjoge30sICJ1c2dzX3N0YXRpb25faWQiOiAiU01FRElUQ08iLCAidmFyaWFibGUiOiAiRElTQ0hSRyIsICJ3ZCI6ICI1In0sICJ0eXBlIjogIkZlYXR1cmUifSwgeyJiYm94IjogWy0xMDUuMTYwODc2LCA0MC4xNzA5OTgsIC0xMDUuMTYwODc2LCA0MC4xNzA5OThdLCAiZ2VvbWV0cnkiOiB7ImNvb3JkaW5hdGVzIjogWy0xMDUuMTYwODc2LCA0MC4xNzA5OThdLCAidHlwZSI6ICJQb2ludCJ9LCAiaWQiOiAiMzMiLCAicHJvcGVydGllcyI6IHsiYW1vdW50IjogIjIuMTEiLCAiY291bnR5IjogIkJPVUxERVIiLCAiZGF0YV9zb3VyY2UiOiAiQ29vcGVyYXRpdmUgUHJvZ3JhbSBvZiBDRFdSLCBOQ1dDRCAmIFNWTEhXQ0QiLCAiZGF0ZV90aW1lIjogIjIwMTgtMDUtMThUMTU6MDA6MDAiLCAiZGl2IjogIjEiLCAiZHdyX2FiYnJldiI6ICJTRkxESVRDTyIsICJoaWdobGlnaHQiOiB7fSwgImh0dHBfbGlua2FnZS51cmwiOiAiaHR0cDovL3d3dy5kd3Iuc3RhdGUuY28udXMvU3VyZmFjZVdhdGVyL2RhdGEvZGV0YWlsX2dyYXBoLmFzcHg/SUQ9U0ZMRElUQ08mTVRZUEU9RElTQ0hSRyIsICJsb2NhdGlvbi5sYXRpdHVkZSI6IDQwLjE3MDk5OCwgImxvY2F0aW9uLmxvbmdpdHVkZSI6IC0xMDUuMTYwODc2LCAibG9jYXRpb24ubmVlZHNfcmVjb2RpbmciOiBmYWxzZSwgInN0YWdlIjogIjAuMzMiLCAic3RhdGlvbl9uYW1lIjogIlNPVVRIIEZMQVQgRElUQ0giLCAic3RhdGlvbl9zdGF0dXMiOiAiQWN0aXZlIiwgInN0YXRpb25fdHlwZSI6ICJEaXZlcnNpb24iLCAic3R5bGUiOiB7fSwgInVzZ3Nfc3RhdGlvbl9pZCI6ICJTRkxESVRDTyIsICJ2YXJpYWJsZSI6ICJESVNDSFJHIiwgIndkIjogIjUifSwgInR5cGUiOiAiRmVhdHVyZSJ9LCB7ImJib3giOiBbLTEwNS41MTQ0NDIsIDQwLjA5MDgyMDAwMDAwMDAxLCAtMTA1LjUxNDQ0MiwgNDAuMDkwODIwMDAwMDAwMDFdLCAiZ2VvbWV0cnkiOiB7ImNvb3JkaW5hdGVzIjogWy0xMDUuNTE0NDQyLCA0MC4wOTA4MjAwMDAwMDAwMV0sICJ0eXBlIjogIlBvaW50In0sICJpZCI6ICIzNCIsICJwcm9wZXJ0aWVzIjogeyJhbW91bnQiOiAiNTguMTAiLCAiY291bnR5IjogIkJPVUxERVIiLCAiZGF0YV9zb3VyY2UiOiAiQ28uIERpdmlzaW9uIG9mIFdhdGVyIFJlc291cmNlcyIsICJkYXRlX3RpbWUiOiAiMjAxOC0wNS0xOFQxNTozMDowMCIsICJkaXYiOiAiMSIsICJkd3JfYWJicmV2IjogIlNTVldBUkNPIiwgImhpZ2hsaWdodCI6IHt9LCAiaHR0cF9saW5rYWdlLnVybCI6ICJodHRwOi8vd3d3LmR3ci5zdGF0ZS5jby51cy9TdXJmYWNlV2F0ZXIvZGF0YS9kZXRhaWxfZ3JhcGguYXNweD9JRD1TU1ZXQVJDTyZNVFlQRT1ESVNDSFJHIiwgImxvY2F0aW9uLmxhdGl0dWRlIjogNDAuMDkwODIsICJsb2NhdGlvbi5sb25naXR1ZGUiOiAtMTA1LjUxNDQ0MiwgImxvY2F0aW9uLm5lZWRzX3JlY29kaW5nIjogZmFsc2UsICJzdGFnZSI6ICIyLjIwIiwgInN0YXRpb25fbmFtZSI6ICJTT1VUSCBTQUlOVCBWUkFJTiBORUFSIFdBUkQiLCAic3RhdGlvbl9zdGF0dXMiOiAiQWN0aXZlIiwgInN0YXRpb25fdHlwZSI6ICJTdHJlYW0iLCAic3R5bGUiOiB7fSwgInVzZ3Nfc3RhdGlvbl9pZCI6ICIwNjcyMjUwMCIsICJ2YXJpYWJsZSI6ICJESVNDSFJHIiwgIndkIjogIjUifSwgInR5cGUiOiAiRmVhdHVyZSJ9LCB7ImJib3giOiBbLTEwNS4yNTk3OTUsIDQwLjIxOTA0NiwgLTEwNS4yNTk3OTUsIDQwLjIxOTA0Nl0sICJnZW9tZXRyeSI6IHsiY29vcmRpbmF0ZXMiOiBbLTEwNS4yNTk3OTUsIDQwLjIxOTA0Nl0sICJ0eXBlIjogIlBvaW50In0sICJpZCI6ICIzNSIsICJwcm9wZXJ0aWVzIjogeyJhbW91bnQiOiAiMTguODAiLCAiY291bnR5IjogIkJPVUxERVIiLCAiZGF0YV9zb3VyY2UiOiAiQ29vcGVyYXRpdmUgUHJvZ3JhbSBvZiBDRFdSLCBOQ1dDRCAmIFNWTEhXQ0QiLCAiZGF0ZV90aW1lIjogIjIwMTgtMDUtMThUMTQ6NDU6MDAiLCAiZGl2IjogIjEiLCAiZHdyX2FiYnJldiI6ICJTVVBESVRDTyIsICJoaWdobGlnaHQiOiB7fSwgImh0dHBfbGlua2FnZS51cmwiOiAiaHR0cDovL3d3dy5kd3Iuc3RhdGUuY28udXMvU3VyZmFjZVdhdGVyL2RhdGEvZGV0YWlsX2dyYXBoLmFzcHg/SUQ9U1VQRElUQ08mTVRZUEU9RElTQ0hSRyIsICJsb2NhdGlvbi5sYXRpdHVkZSI6IDQwLjIxOTA0NiwgImxvY2F0aW9uLmxvbmdpdHVkZSI6IC0xMDUuMjU5Nzk1LCAibG9jYXRpb24ubmVlZHNfcmVjb2RpbmciOiBmYWxzZSwgInN0YWdlIjogIjAuNjMiLCAic3RhdGlvbl9uYW1lIjogIlNVUFBMWSBESVRDSCIsICJzdGF0aW9uX3N0YXR1cyI6ICJBY3RpdmUiLCAic3RhdGlvbl90eXBlIjogIkRpdmVyc2lvbiIsICJzdHlsZSI6IHt9LCAidXNnc19zdGF0aW9uX2lkIjogIlNVUERJVENPIiwgInZhcmlhYmxlIjogIkRJU0NIUkciLCAid2QiOiAiNSJ9LCAidHlwZSI6ICJGZWF0dXJlIn0sIHsiYmJveCI6IFstMTA1LjI1MDkyNywgNDAuMjExMDgzLCAtMTA1LjI1MDkyNywgNDAuMjExMDgzXSwgImdlb21ldHJ5IjogeyJjb29yZGluYXRlcyI6IFstMTA1LjI1MDkyNywgNDAuMjExMDgzXSwgInR5cGUiOiAiUG9pbnQifSwgImlkIjogIjM2IiwgInByb3BlcnRpZXMiOiB7ImFtb3VudCI6ICIyNS4zOSIsICJjb3VudHkiOiAiQk9VTERFUiIsICJkYXRhX3NvdXJjZSI6ICJDb29wZXJhdGl2ZSBQcm9ncmFtIG9mIENEV1IsIE5DV0NEICYgU1ZMSFdDRCIsICJkYXRlX3RpbWUiOiAiMjAxOC0wNS0xOFQxMzo0NTowMCIsICJkaXYiOiAiMSIsICJkd3JfYWJicmV2IjogIlNXRURJVENPIiwgImhpZ2hsaWdodCI6IHt9LCAiaHR0cF9saW5rYWdlLnVybCI6ICJodHRwOi8vd3d3LmR3ci5zdGF0ZS5jby51cy9TdXJmYWNlV2F0ZXIvZGF0YS9kZXRhaWxfZ3JhcGguYXNweD9JRD1TV0VESVRDTyZNVFlQRT1ESVNDSFJHIiwgImxvY2F0aW9uLmxhdGl0dWRlIjogNDAuMjExMDgzLCAibG9jYXRpb24ubG9uZ2l0dWRlIjogLTEwNS4yNTA5MjcsICJsb2NhdGlvbi5uZWVkc19yZWNvZGluZyI6IGZhbHNlLCAic3RhZ2UiOiAiMS4zNCIsICJzdGF0aW9uX25hbWUiOiAiU1dFREUgRElUQ0giLCAic3RhdGlvbl9zdGF0dXMiOiAiQWN0aXZlIiwgInN0YXRpb25fdHlwZSI6ICJEaXZlcnNpb24iLCAic3R5bGUiOiB7fSwgInVzZ3Nfc3RhdGlvbl9pZCI6IG51bGwsICJ2YXJpYWJsZSI6ICJESVNDSFJHIiwgIndkIjogIjUifSwgInR5cGUiOiAiRmVhdHVyZSJ9LCB7ImJib3giOiBbLTEwNS4yMTAzODgwMDAwMDAwMSwgNDAuMTkzMDE5LCAtMTA1LjIxMDM4ODAwMDAwMDAxLCA0MC4xOTMwMTldLCAiZ2VvbWV0cnkiOiB7ImNvb3JkaW5hdGVzIjogWy0xMDUuMjEwMzg4MDAwMDAwMDEsIDQwLjE5MzAxOV0sICJ0eXBlIjogIlBvaW50In0sICJpZCI6ICIzNyIsICJwcm9wZXJ0aWVzIjogeyJhbW91bnQiOiAiMC4wNCIsICJjb3VudHkiOiAiQk9VTERFUiIsICJkYXRhX3NvdXJjZSI6ICJDb29wZXJhdGl2ZSBQcm9ncmFtIG9mIENEV1IsIE5DV0NEICYgU1ZMSFdDRCIsICJkYXRlX3RpbWUiOiAiMjAxOC0wNS0xOFQxNTowMDowMCIsICJkaXYiOiAiMSIsICJkd3JfYWJicmV2IjogIlRSVURJVENPIiwgImhpZ2hsaWdodCI6IHt9LCAiaHR0cF9saW5rYWdlLnVybCI6ICJodHRwOi8vd3d3LmR3ci5zdGF0ZS5jby51cy9TdXJmYWNlV2F0ZXIvZGF0YS9kZXRhaWxfZ3JhcGguYXNweD9JRD1UUlVESVRDTyZNVFlQRT1ESVNDSFJHIiwgImxvY2F0aW9uLmxhdGl0dWRlIjogNDAuMTkzMDE5LCAibG9jYXRpb24ubG9uZ2l0dWRlIjogLTEwNS4yMTAzODgsICJsb2NhdGlvbi5uZWVkc19yZWNvZGluZyI6IGZhbHNlLCAic3RhZ2UiOiAiMC4wNSIsICJzdGF0aW9uX25hbWUiOiAiVFJVRSBBTkQgV0VCU1RFUiBESVRDSCIsICJzdGF0aW9uX3N0YXR1cyI6ICJBY3RpdmUiLCAic3RhdGlvbl90eXBlIjogIkRpdmVyc2lvbiIsICJzdHlsZSI6IHt9LCAidXNnc19zdGF0aW9uX2lkIjogIlRSVURJVENPIiwgInZhcmlhYmxlIjogIkRJU0NIUkciLCAid2QiOiAiNSJ9LCAidHlwZSI6ICJGZWF0dXJlIn0sIHsiYmJveCI6IFstMTA1LjIxMDQyNCwgNDAuMTkzMjgwMDAwMDAwMDEsIC0xMDUuMjEwNDI0LCA0MC4xOTMyODAwMDAwMDAwMV0sICJnZW9tZXRyeSI6IHsiY29vcmRpbmF0ZXMiOiBbLTEwNS4yMTA0MjQsIDQwLjE5MzI4MDAwMDAwMDAxXSwgInR5cGUiOiAiUG9pbnQifSwgImlkIjogIjM4IiwgInByb3BlcnRpZXMiOiB7ImFtb3VudCI6ICI1LjI4IiwgImNvdW50eSI6ICJCT1VMREVSIiwgImRhdGFfc291cmNlIjogIkNvb3BlcmF0aXZlIFByb2dyYW0gb2YgQ0RXUiwgTkNXQ0QgJiBTVkxIV0NEIiwgImRhdGVfdGltZSI6ICIyMDE4LTA1LTE4VDE1OjAwOjAwIiwgImRpdiI6ICIxIiwgImR3cl9hYmJyZXYiOiAiV0VCRElUQ08iLCAiaGlnaGxpZ2h0Ijoge30sICJodHRwX2xpbmthZ2UudXJsIjogImh0dHA6Ly93d3cuZHdyLnN0YXRlLmNvLnVzL1N1cmZhY2VXYXRlci9kYXRhL2RldGFpbF9ncmFwaC5hc3B4P0lEPVdFQkRJVENPJk1UWVBFPURJU0NIUkciLCAibG9jYXRpb24ubGF0aXR1ZGUiOiA0MC4xOTMyOCwgImxvY2F0aW9uLmxvbmdpdHVkZSI6IC0xMDUuMjEwNDI0LCAibG9jYXRpb24ubmVlZHNfcmVjb2RpbmciOiBmYWxzZSwgInN0YWdlIjogIjAuOTIiLCAic3RhdGlvbl9uYW1lIjogIldFQlNURVIgTUNDQVNMSU4gRElUQ0giLCAic3RhdGlvbl9zdGF0dXMiOiAiQWN0aXZlIiwgInN0YXRpb25fdHlwZSI6ICJEaXZlcnNpb24iLCAic3R5bGUiOiB7fSwgInVzZ3Nfc3RhdGlvbl9pZCI6ICJXRUJESVRDTyIsICJ2YXJpYWJsZSI6ICJESVNDSFJHIiwgIndkIjogIjUifSwgInR5cGUiOiAiRmVhdHVyZSJ9LCB7ImJib3giOiBbLTEwNS4xODU3ODksIDQwLjE4NTAzMywgLTEwNS4xODU3ODksIDQwLjE4NTAzM10sICJnZW9tZXRyeSI6IHsiY29vcmRpbmF0ZXMiOiBbLTEwNS4xODU3ODksIDQwLjE4NTAzM10sICJ0eXBlIjogIlBvaW50In0sICJpZCI6ICIzOSIsICJwcm9wZXJ0aWVzIjogeyJhbW91bnQiOiAiNy4zNCIsICJjb3VudHkiOiAiQk9VTERFUiIsICJkYXRhX3NvdXJjZSI6ICJDb29wZXJhdGl2ZSBQcm9ncmFtIG9mIENEV1IsIE5DV0NEICYgU1ZMSFdDRCIsICJkYXRlX3RpbWUiOiAiMjAxOC0wNS0xOFQxNTowMDowMCIsICJkaXYiOiAiMSIsICJkd3JfYWJicmV2IjogIlpXRVRVUkNPIiwgImhpZ2hsaWdodCI6IHt9LCAiaHR0cF9saW5rYWdlLnVybCI6ICJodHRwOi8vd3d3LmR3ci5zdGF0ZS5jby51cy9TdXJmYWNlV2F0ZXIvZGF0YS9kZXRhaWxfZ3JhcGguYXNweD9JRD1aV0VUVVJDTyZNVFlQRT1ESVNDSFJHIiwgImxvY2F0aW9uLmxhdGl0dWRlIjogNDAuMTg1MDMzLCAibG9jYXRpb24ubG9uZ2l0dWRlIjogLTEwNS4xODU3ODksICJsb2NhdGlvbi5uZWVkc19yZWNvZGluZyI6IGZhbHNlLCAic3RhZ2UiOiAiMC42MSIsICJzdGF0aW9uX25hbWUiOiAiWldFQ0sgQU5EIFRVUk5FUiBESVRDSCIsICJzdGF0aW9uX3N0YXR1cyI6ICJBY3RpdmUiLCAic3RhdGlvbl90eXBlIjogIkRpdmVyc2lvbiIsICJzdHlsZSI6IHt9LCAidXNnc19zdGF0aW9uX2lkIjogIlpXRVRVUkNPIiwgInZhcmlhYmxlIjogIkRJU0NIUkciLCAid2QiOiAiNSJ9LCAidHlwZSI6ICJGZWF0dXJlIn0sIHsiYmJveCI6IFstMTA1LjA5Nzg3MiwgNDAuMDU5ODA5LCAtMTA1LjA5Nzg3MiwgNDAuMDU5ODA5XSwgImdlb21ldHJ5IjogeyJjb29yZGluYXRlcyI6IFstMTA1LjA5Nzg3MiwgNDAuMDU5ODA5XSwgInR5cGUiOiAiUG9pbnQifSwgImlkIjogIjQwIiwgInByb3BlcnRpZXMiOiB7ImFtb3VudCI6ICI1MC4yMCIsICJjb3VudHkiOiAiQk9VTERFUiIsICJkYXRhX3NvdXJjZSI6ICJDby4gRGl2aXNpb24gb2YgV2F0ZXIgUmVzb3VyY2VzIiwgImRhdGVfdGltZSI6ICIyMDE4LTA1LTE4VDE1OjQ1OjAwIiwgImRpdiI6ICIxIiwgImR3cl9hYmJyZXYiOiAiQk9DMTA5Q08iLCAiaGlnaGxpZ2h0Ijoge30sICJodHRwX2xpbmthZ2UudXJsIjogImh0dHA6Ly93d3cuZHdyLnN0YXRlLmNvLnVzL1N1cmZhY2VXYXRlci9kYXRhL2RldGFpbF9ncmFwaC5hc3B4P0lEPUJPQzEwOUNPJk1UWVBFPURJU0NIUkciLCAibG9jYXRpb24ubGF0aXR1ZGUiOiA0MC4wNTk4MDksICJsb2NhdGlvbi5sb25naXR1ZGUiOiAtMTA1LjA5Nzg3MiwgImxvY2F0aW9uLm5lZWRzX3JlY29kaW5nIjogZmFsc2UsICJzdGFnZSI6ICIyLjU0IiwgInN0YXRpb25fbmFtZSI6ICJCT1VMREVSIENSRUVLIEFUIDEwOSBTVCBORUFSIEVSSUUsIENPIiwgInN0YXRpb25fc3RhdHVzIjogIkFjdGl2ZSIsICJzdGF0aW9uX3R5cGUiOiAiU3RyZWFtIiwgInN0eWxlIjoge30sICJ1c2dzX3N0YXRpb25faWQiOiAiQk9DMTA5Q08iLCAidmFyaWFibGUiOiAiRElTQ0hSRyIsICJ3ZCI6ICI2In0sICJ0eXBlIjogIkZlYXR1cmUifSwgeyJiYm94IjogWy0xMDUuMTc4ODc1LCA0MC4wNTE2NTIsIC0xMDUuMTc4ODc1LCA0MC4wNTE2NTJdLCAiZ2VvbWV0cnkiOiB7ImNvb3JkaW5hdGVzIjogWy0xMDUuMTc4ODc1LCA0MC4wNTE2NTJdLCAidHlwZSI6ICJQb2ludCJ9LCAiaWQiOiAiNDEiLCAicHJvcGVydGllcyI6IHsiYW1vdW50IjogIjEyOC4wMCIsICJjb3VudHkiOiAiQk9VTERFUiIsICJkYXRhX3NvdXJjZSI6ICJVLlMuIEdlb2xvZ2ljYWwgU3VydmV5IChEYXRhIFByb3ZpZGVyKSIsICJkYXRlX3RpbWUiOiAiMjAxOC0wNS0xOFQxNToxNTowMCIsICJkaXYiOiAiMSIsICJkd3JfYWJicmV2IjogIkJPQ05PUkNPIiwgImhpZ2hsaWdodCI6IHt9LCAiaHR0cF9saW5rYWdlLnVybCI6ICJodHRwOi8vd2F0ZXJkYXRhLnVzZ3MuZ292L253aXMvdXY/MDY3MzAyMDAiLCAibG9jYXRpb24ubGF0aXR1ZGUiOiA0MC4wNTE2NTIsICJsb2NhdGlvbi5sb25naXR1ZGUiOiAtMTA1LjE3ODg3NSwgImxvY2F0aW9uLm5lZWRzX3JlY29kaW5nIjogZmFsc2UsICJzdGFnZSI6IG51bGwsICJzdGF0aW9uX25hbWUiOiAiQk9VTERFUiBDUkVFSyBBVCBOT1JUSCA3NVRIIFNUUkVFVCBORUFSIEJPVUxERVIiLCAic3RhdGlvbl9zdGF0dXMiOiAiQWN0aXZlIiwgInN0YXRpb25fdHlwZSI6ICJTdHJlYW0iLCAic3R5bGUiOiB7fSwgInVzZ3Nfc3RhdGlvbl9pZCI6ICIwNjczMDIwMCIsICJ2YXJpYWJsZSI6ICJESVNDSFJHIiwgIndkIjogIjYifSwgInR5cGUiOiAiRmVhdHVyZSJ9LCB7ImJib3giOiBbLTEwNS4xOTMwNDgsIDQwLjA1MzAzNSwgLTEwNS4xOTMwNDgsIDQwLjA1MzAzNV0sICJnZW9tZXRyeSI6IHsiY29vcmRpbmF0ZXMiOiBbLTEwNS4xOTMwNDgsIDQwLjA1MzAzNV0sICJ0eXBlIjogIlBvaW50In0sICJpZCI6ICI0MiIsICJwcm9wZXJ0aWVzIjogeyJhbW91bnQiOiAiMy44MSIsICJjb3VudHkiOiAiQk9VTERFUiIsICJkYXRhX3NvdXJjZSI6ICJOb3J0aGVybiBDb2xvcmFkbyBXYXRlciBDb25zZXJ2YW5jeSBEaXN0cmljdCAoRGF0YSBQcm92aWRlcikiLCAiZGF0ZV90aW1lIjogIjIwMTgtMDUtMThUMTU6MDA6MDAiLCAiZGl2IjogIjEiLCAiZHdyX2FiYnJldiI6ICJCQ1NDQkNDTyIsICJoaWdobGlnaHQiOiB7fSwgImh0dHBfbGlua2FnZS51cmwiOiAiaHR0cDovL3d3dy5ub3J0aGVybndhdGVyLm9yZy9XYXRlclByb2plY3RzL0Vhc3RTbG9wZVdhdGVyRGF0YS5hc3B4IiwgImxvY2F0aW9uLmxhdGl0dWRlIjogNDAuMDUzMDM1LCAibG9jYXRpb24ubG9uZ2l0dWRlIjogLTEwNS4xOTMwNDgsICJsb2NhdGlvbi5uZWVkc19yZWNvZGluZyI6IGZhbHNlLCAic3RhZ2UiOiAiMC4yMyIsICJzdGF0aW9uX25hbWUiOiAiQk9VTERFUiBDUkVFSyBTVVBQTFkgQ0FOQUwgVE8gQk9VTERFUiBDUkVFSyBORUFSIEJPVUxERVIiLCAic3RhdGlvbl9zdGF0dXMiOiAiQWN0aXZlIiwgInN0YXRpb25fdHlwZSI6ICJEaXZlcnNpb24iLCAic3R5bGUiOiB7fSwgInVzZ3Nfc3RhdGlvbl9pZCI6ICJFUzE5MTciLCAidmFyaWFibGUiOiAiRElTQ0hSRyIsICJ3ZCI6ICI2In0sICJ0eXBlIjogIkZlYXR1cmUifSwgeyJiYm94IjogWy0xMDUuMjIwNDk3LCA0MC4wNzg1NiwgLTEwNS4yMjA0OTcsIDQwLjA3ODU2XSwgImdlb21ldHJ5IjogeyJjb29yZGluYXRlcyI6IFstMTA1LjIyMDQ5NywgNDAuMDc4NTZdLCAidHlwZSI6ICJQb2ludCJ9LCAiaWQiOiAiNDMiLCAicHJvcGVydGllcyI6IHsiYW1vdW50IjogIjc0MDMuMDAiLCAiY291bnR5IjogIkJPVUxERVIiLCAiZGF0YV9zb3VyY2UiOiAiTm9ydGhlcm4gQ29sb3JhZG8gV2F0ZXIgQ29uc2VydmFuY3kgRGlzdHJpY3QgKERhdGEgUHJvdmlkZXIpIiwgImRhdGVfdGltZSI6ICIyMDE4LTA1LTE4VDE1OjE1OjAwIiwgImRpdiI6ICIxIiwgImR3cl9hYmJyZXYiOiAiQk9VUkVTQ08iLCAiaGlnaGxpZ2h0Ijoge30sICJodHRwX2xpbmthZ2UudXJsIjogImh0dHA6Ly93d3cubm9ydGhlcm53YXRlci5vcmcvV2F0ZXJQcm9qZWN0cy9FYXN0U2xvcGVXYXRlckRhdGEuYXNweCIsICJsb2NhdGlvbi5sYXRpdHVkZSI6IDQwLjA3ODU2LCAibG9jYXRpb24ubG9uZ2l0dWRlIjogLTEwNS4yMjA0OTcsICJsb2NhdGlvbi5uZWVkc19yZWNvZGluZyI6IGZhbHNlLCAic3RhZ2UiOiBudWxsLCAic3RhdGlvbl9uYW1lIjogIkJPVUxERVIgUkVTRVJWT0lSIiwgInN0YXRpb25fc3RhdHVzIjogIkFjdGl2ZSIsICJzdGF0aW9uX3R5cGUiOiAiUmVzZXJ2b2lyIiwgInN0eWxlIjoge30sICJ1c2dzX3N0YXRpb25faWQiOiAiRVIxOTE0IiwgInZhcmlhYmxlIjogIlNUT1JBR0UiLCAid2QiOiAiNiJ9LCAidHlwZSI6ICJGZWF0dXJlIn0sIHsiYmJveCI6IFstMTA1LjIxNzUxOSwgNDAuMDg2Mjc4LCAtMTA1LjIxNzUxOSwgNDAuMDg2Mjc4XSwgImdlb21ldHJ5IjogeyJjb29yZGluYXRlcyI6IFstMTA1LjIxNzUxOSwgNDAuMDg2Mjc4XSwgInR5cGUiOiAiUG9pbnQifSwgImlkIjogIjQ0IiwgInByb3BlcnRpZXMiOiB7ImFtb3VudCI6ICIzMi4wMCIsICJjb3VudHkiOiAiQk9VTERFUiIsICJkYXRhX3NvdXJjZSI6ICJOb3J0aGVybiBDb2xvcmFkbyBXYXRlciBDb25zZXJ2YW5jeSBEaXN0cmljdCAoRGF0YSBQcm92aWRlcikiLCAiZGF0ZV90aW1lIjogIjIwMTgtMDUtMThUMTU6MDA6MDAiLCAiZGl2IjogIjEiLCAiZHdyX2FiYnJldiI6ICJCRkNJTkZDTyIsICJoaWdobGlnaHQiOiB7fSwgImh0dHBfbGlua2FnZS51cmwiOiAiaHR0cDovL3d3dy5ub3J0aGVybndhdGVyLm9yZy9XYXRlclByb2plY3RzL0Vhc3RTbG9wZVdhdGVyRGF0YS5hc3B4IiwgImxvY2F0aW9uLmxhdGl0dWRlIjogNDAuMDg2Mjc4LCAibG9jYXRpb24ubG9uZ2l0dWRlIjogLTEwNS4yMTc1MTksICJsb2NhdGlvbi5uZWVkc19yZWNvZGluZyI6IGZhbHNlLCAic3RhZ2UiOiAiMS43OSIsICJzdGF0aW9uX25hbWUiOiAiQk9VTERFUiBSRVNFUlZPSVIgSU5MRVQiLCAic3RhdGlvbl9zdGF0dXMiOiAiQWN0aXZlIiwgInN0YXRpb25fdHlwZSI6ICJTdHJlYW0iLCAic3R5bGUiOiB7fSwgInVzZ3Nfc3RhdGlvbl9pZCI6ICJFUzE5MTYiLCAidmFyaWFibGUiOiAiRElTQ0hSRyIsICJ3ZCI6ICI2In0sICJ0eXBlIjogIkZlYXR1cmUifSwgeyJiYm94IjogWy0xMDUuMjE4Njc3LCAzOS45ODYxNjksIC0xMDUuMjE4Njc3LCAzOS45ODYxNjldLCAiZ2VvbWV0cnkiOiB7ImNvb3JkaW5hdGVzIjogWy0xMDUuMjE4Njc3LCAzOS45ODYxNjldLCAidHlwZSI6ICJQb2ludCJ9LCAiaWQiOiAiNDUiLCAicHJvcGVydGllcyI6IHsiYW1vdW50IjogIjE0LjI2IiwgImNvdW50eSI6ICJCT1VMREVSIiwgImRhdGFfc291cmNlIjogIkNvb3BlcmF0aXZlIFByb2dyYW0gb2YgQ0RXUiwgTkNXQ0QgJiBMU1BXQ0QiLCAiZGF0ZV90aW1lIjogIjIwMTgtMDUtMThUMTQ6MDA6MDAiLCAiZGl2IjogIjEiLCAiZHdyX2FiYnJldiI6ICJEUllDQVJDTyIsICJoaWdobGlnaHQiOiB7fSwgImh0dHBfbGlua2FnZS51cmwiOiAiaHR0cDovL3d3dy5kd3Iuc3RhdGUuY28udXMvU3VyZmFjZVdhdGVyL2RhdGEvZGV0YWlsX2dyYXBoLmFzcHg/SUQ9RFJZQ0FSQ08mTVRZUEU9RElTQ0hSRyIsICJsb2NhdGlvbi5sYXRpdHVkZSI6IDM5Ljk4NjE2OSwgImxvY2F0aW9uLmxvbmdpdHVkZSI6IC0xMDUuMjE4Njc3LCAibG9jYXRpb24ubmVlZHNfcmVjb2RpbmciOiBmYWxzZSwgInN0YWdlIjogIjAuNTMiLCAic3RhdGlvbl9uYW1lIjogIkRSWSBDUkVFSyBDQVJSSUVSIiwgInN0YXRpb25fc3RhdHVzIjogIkFjdGl2ZSIsICJzdGF0aW9uX3R5cGUiOiAiRGl2ZXJzaW9uIiwgInN0eWxlIjoge30sICJ1c2dzX3N0YXRpb25faWQiOiBudWxsLCAidmFyaWFibGUiOiAiRElTQ0hSRyIsICJ3ZCI6ICI2In0sICJ0eXBlIjogIkZlYXR1cmUifSwgeyJiYm94IjogWy0xMDUuMzY0OTE3MDAwMDAwMDIsIDQwLjA0MjAyOCwgLTEwNS4zNjQ5MTcwMDAwMDAwMiwgNDAuMDQyMDI4XSwgImdlb21ldHJ5IjogeyJjb29yZGluYXRlcyI6IFstMTA1LjM2NDkxNzAwMDAwMDAyLCA0MC4wNDIwMjhdLCAidHlwZSI6ICJQb2ludCJ9LCAiaWQiOiAiNDYiLCAicHJvcGVydGllcyI6IHsiYW1vdW50IjogIjE3LjAwIiwgImNvdW50eSI6ICJCT1VMREVSIiwgImRhdGFfc291cmNlIjogIlUuUy4gR2VvbG9naWNhbCBTdXJ2ZXkgKERhdGEgUHJvdmlkZXIpIiwgImRhdGVfdGltZSI6ICIyMDEzLTA5LTIwVDA4OjEwOjAwIiwgImRpdiI6ICIxIiwgImR3cl9hYmJyZXYiOiAiRlJNTE1SQ08iLCAiaGlnaGxpZ2h0Ijoge30sICJodHRwX2xpbmthZ2UudXJsIjogImh0dHA6Ly93YXRlcmRhdGEudXNncy5nb3Yvbndpcy91dj8wNjcyNzQxMCIsICJsb2NhdGlvbi5sYXRpdHVkZSI6IDQwLjA0MjAyOCwgImxvY2F0aW9uLmxvbmdpdHVkZSI6IC0xMDUuMzY0OTE3LCAibG9jYXRpb24ubmVlZHNfcmVjb2RpbmciOiBmYWxzZSwgInN0YWdlIjogbnVsbCwgInN0YXRpb25fbmFtZSI6ICJGT1VSIE1JTEUgQ1JFRUsgQVQgTE9HQU4gTUlMTCBST0FEIE5FQVIgQ1JJU01BTiwgQ08iLCAic3RhdGlvbl9zdGF0dXMiOiAiQWN0aXZlIiwgInN0YXRpb25fdHlwZSI6ICJTdHJlYW0iLCAic3R5bGUiOiB7fSwgInVzZ3Nfc3RhdGlvbl9pZCI6ICIwNjcyNzQxMCIsICJ2YXJpYWJsZSI6ICJESVNDSFJHIiwgIndkIjogIjYifSwgInR5cGUiOiAiRmVhdHVyZSJ9LCB7ImJib3giOiBbLTEwNS4zMjYyNSwgNDAuMDE4NjY3LCAtMTA1LjMyNjI1LCA0MC4wMTg2NjddLCAiZ2VvbWV0cnkiOiB7ImNvb3JkaW5hdGVzIjogWy0xMDUuMzI2MjUsIDQwLjAxODY2N10sICJ0eXBlIjogIlBvaW50In0sICJpZCI6ICI0NyIsICJwcm9wZXJ0aWVzIjogeyJhbW91bnQiOiAiMjQuODAiLCAiY291bnR5IjogIkJPVUxERVIiLCAiZGF0YV9zb3VyY2UiOiAiVS5TLiBHZW9sb2dpY2FsIFN1cnZleSAoRGF0YSBQcm92aWRlcikiLCAiZGF0ZV90aW1lIjogIjIwMTgtMDUtMThUMTU6NTA6MDAiLCAiZGl2IjogIjEiLCAiZHdyX2FiYnJldiI6ICJGT1VPUk9DTyIsICJoaWdobGlnaHQiOiB7fSwgImh0dHBfbGlua2FnZS51cmwiOiAiaHR0cDovL3dhdGVyZGF0YS51c2dzLmdvdi9ud2lzL3V2PzA2NzI3NTAwIiwgImxvY2F0aW9uLmxhdGl0dWRlIjogNDAuMDE4NjY3LCAibG9jYXRpb24ubG9uZ2l0dWRlIjogLTEwNS4zMjYyNSwgImxvY2F0aW9uLm5lZWRzX3JlY29kaW5nIjogZmFsc2UsICJzdGFnZSI6IG51bGwsICJzdGF0aW9uX25hbWUiOiAiRk9VUk1JTEUgQ1JFRUsgQVQgT1JPREVMTCwgQ08uIiwgInN0YXRpb25fc3RhdHVzIjogIkFjdGl2ZSIsICJzdGF0aW9uX3R5cGUiOiAiU3RyZWFtIiwgInN0eWxlIjoge30sICJ1c2dzX3N0YXRpb25faWQiOiAiMDY3Mjc1MDAiLCAidmFyaWFibGUiOiAiRElTQ0hSRyIsICJ3ZCI6ICI2In0sICJ0eXBlIjogIkZlYXR1cmUifSwgeyJiYm94IjogWy0xMDUuMzU3MzA4LCAzOS45NDc3MDQsIC0xMDUuMzU3MzA4LCAzOS45NDc3MDRdLCAiZ2VvbWV0cnkiOiB7ImNvb3JkaW5hdGVzIjogWy0xMDUuMzU3MzA4LCAzOS45NDc3MDRdLCAidHlwZSI6ICJQb2ludCJ9LCAiaWQiOiAiNDgiLCAicHJvcGVydGllcyI6IHsiYW1vdW50IjogIjI1NTUzLjAwIiwgImNvdW50eSI6ICJCT1VMREVSIiwgImRhdGFfc291cmNlIjogIkNvLiBEaXZpc2lvbiBvZiBXYXRlciBSZXNvdXJjZXMiLCAiZGF0ZV90aW1lIjogIjIwMTgtMDUtMThUMTU6MzA6MDAiLCAiZGl2IjogIjEiLCAiZHdyX2FiYnJldiI6ICJHUk9TUkVDTyIsICJoaWdobGlnaHQiOiB7fSwgImh0dHBfbGlua2FnZS51cmwiOiAiaHR0cDovL3d3dy5kd3Iuc3RhdGUuY28udXMvU3VyZmFjZVdhdGVyL2RhdGEvZGV0YWlsX2dyYXBoLmFzcHg/SUQ9R1JPU1JFQ08mTVRZUEU9U1RPUkFHRSIsICJsb2NhdGlvbi5sYXRpdHVkZSI6IDM5Ljk0NzcwNCwgImxvY2F0aW9uLmxvbmdpdHVkZSI6IC0xMDUuMzU3MzA4LCAibG9jYXRpb24ubmVlZHNfcmVjb2RpbmciOiBmYWxzZSwgInN0YWdlIjogIjcyMzYuNjUiLCAic3RhdGlvbl9uYW1lIjogIkdST1NTIFJFU0VSVk9JUiAiLCAic3RhdGlvbl9zdGF0dXMiOiAiQWN0aXZlIiwgInN0YXRpb25fdHlwZSI6ICJSZXNlcnZvaXIiLCAic3R5bGUiOiB7fSwgInVzZ3Nfc3RhdGlvbl9pZCI6ICJHUk9TUkVDTyIsICJ2YXJpYWJsZSI6ICJTVE9SQUdFIiwgIndkIjogIjYifSwgInR5cGUiOiAiRmVhdHVyZSJ9LCB7ImJib3giOiBbLTEwNS4xNTExNDMsIDQwLjA1MzY2MSwgLTEwNS4xNTExNDMsIDQwLjA1MzY2MV0sICJnZW9tZXRyeSI6IHsiY29vcmRpbmF0ZXMiOiBbLTEwNS4xNTExNDMsIDQwLjA1MzY2MV0sICJ0eXBlIjogIlBvaW50In0sICJpZCI6ICI0OSIsICJwcm9wZXJ0aWVzIjogeyJhbW91bnQiOiAiMTcuNjciLCAiY291bnR5IjogIkJPVUxERVIiLCAiZGF0YV9zb3VyY2UiOiAiQ29vcGVyYXRpdmUgUHJvZ3JhbSBvZiBDRFdSLCBOQ1dDRCAmIExTUFdDRCIsICJkYXRlX3RpbWUiOiAiMjAxOC0wNS0xOFQxNTowMDowMCIsICJkaXYiOiAiMSIsICJkd3JfYWJicmV2IjogIkxFR0RJVENPIiwgImhpZ2hsaWdodCI6IHt9LCAiaHR0cF9saW5rYWdlLnVybCI6ICJodHRwOi8vd3d3LmR3ci5zdGF0ZS5jby51cy9TdXJmYWNlV2F0ZXIvZGF0YS9kZXRhaWxfZ3JhcGguYXNweD9JRD1MRUdESVRDTyZNVFlQRT1ESVNDSFJHIiwgImxvY2F0aW9uLmxhdGl0dWRlIjogNDAuMDUzNjYxLCAibG9jYXRpb24ubG9uZ2l0dWRlIjogLTEwNS4xNTExNDMsICJsb2NhdGlvbi5uZWVkc19yZWNvZGluZyI6IGZhbHNlLCAic3RhZ2UiOiAiMC42OSIsICJzdGF0aW9uX25hbWUiOiAiTEVHR0VUVCBESVRDSCIsICJzdGF0aW9uX3N0YXR1cyI6ICJBY3RpdmUiLCAic3RhdGlvbl90eXBlIjogIkRpdmVyc2lvbiIsICJzdHlsZSI6IHt9LCAidXNnc19zdGF0aW9uX2lkIjogIkxFR0RJVENPIiwgInZhcmlhYmxlIjogIkRJU0NIUkciLCAid2QiOiAiNiJ9LCAidHlwZSI6ICJGZWF0dXJlIn0sIHsiYmJveCI6IFstMTA1LjUwNDQ0LCAzOS45NjE2NTUsIC0xMDUuNTA0NDQsIDM5Ljk2MTY1NV0sICJnZW9tZXRyeSI6IHsiY29vcmRpbmF0ZXMiOiBbLTEwNS41MDQ0NCwgMzkuOTYxNjU1XSwgInR5cGUiOiAiUG9pbnQifSwgImlkIjogIjUwIiwgInByb3BlcnRpZXMiOiB7ImFtb3VudCI6ICIxNTEuMDAiLCAiY291bnR5IjogIkJPVUxERVIiLCAiZGF0YV9zb3VyY2UiOiAiQ28uIERpdmlzaW9uIG9mIFdhdGVyIFJlc291cmNlcyIsICJkYXRlX3RpbWUiOiAiMjAxOC0wNS0xOFQxNToxNTowMCIsICJkaXYiOiAiMSIsICJkd3JfYWJicmV2IjogIkJPQ01JRENPIiwgImhpZ2hsaWdodCI6IHt9LCAiaHR0cF9saW5rYWdlLnVybCI6ICJodHRwOi8vd3d3LmR3ci5zdGF0ZS5jby51cy9TdXJmYWNlV2F0ZXIvZGF0YS9kZXRhaWxfZ3JhcGguYXNweD9JRD1CT0NNSURDTyZNVFlQRT1ESVNDSFJHIiwgImxvY2F0aW9uLmxhdGl0dWRlIjogMzkuOTYxNjU1LCAibG9jYXRpb24ubG9uZ2l0dWRlIjogLTEwNS41MDQ0NCwgImxvY2F0aW9uLm5lZWRzX3JlY29kaW5nIjogZmFsc2UsICJzdGFnZSI6ICIxLjgxIiwgInN0YXRpb25fbmFtZSI6ICJNSURETEUgQk9VTERFUiBDUkVFSyBBVCBORURFUkxBTkQiLCAic3RhdGlvbl9zdGF0dXMiOiAiQWN0aXZlIiwgInN0YXRpb25fdHlwZSI6ICJTdHJlYW0iLCAic3R5bGUiOiB7fSwgInVzZ3Nfc3RhdGlvbl9pZCI6ICIwNjcyNTUwMCIsICJ2YXJpYWJsZSI6ICJESVNDSFJHIiwgIndkIjogIjYifSwgInR5cGUiOiAiRmVhdHVyZSJ9LCB7ImJib3giOiBbLTEwNS40MjI5ODUsIDM5LjkzMTY1OSwgLTEwNS40MjI5ODUsIDM5LjkzMTY1OV0sICJnZW9tZXRyeSI6IHsiY29vcmRpbmF0ZXMiOiBbLTEwNS40MjI5ODUsIDM5LjkzMTY1OV0sICJ0eXBlIjogIlBvaW50In0sICJpZCI6ICI1MSIsICJwcm9wZXJ0aWVzIjogeyJhbW91bnQiOiAiNzAzLjAwIiwgImNvdW50eSI6ICJCT1VMREVSIiwgImRhdGFfc291cmNlIjogIkNvLiBEaXZpc2lvbiBvZiBXYXRlciBSZXNvdXJjZXMiLCAiZGF0ZV90aW1lIjogIjIwMTgtMDUtMThUMTU6NDU6MDAiLCAiZGl2IjogIjEiLCAiZHdyX2FiYnJldiI6ICJCT0NQSU5DTyIsICJoaWdobGlnaHQiOiB7fSwgImh0dHBfbGlua2FnZS51cmwiOiAiaHR0cDovL3d3dy5kd3Iuc3RhdGUuY28udXMvU3VyZmFjZVdhdGVyL2RhdGEvZGV0YWlsX2dyYXBoLmFzcHg/SUQ9Qk9DUElOQ08mTVRZUEU9RElTQ0hSRyIsICJsb2NhdGlvbi5sYXRpdHVkZSI6IDM5LjkzMTY1OSwgImxvY2F0aW9uLmxvbmdpdHVkZSI6IC0xMDUuNDIyOTg1LCAibG9jYXRpb24ubmVlZHNfcmVjb2RpbmciOiBmYWxzZSwgInN0YWdlIjogIjMuNTAiLCAic3RhdGlvbl9uYW1lIjogIlNPVVRIIEJPVUxERVIgQ1JFRUsgQUJPVkUgR1JPU1MgUkVTRVJWT0lSIEFUIFBJTkVDTElGRkUiLCAic3RhdGlvbl9zdGF0dXMiOiAiQWN0aXZlIiwgInN0YXRpb25fdHlwZSI6ICJTdHJlYW0iLCAic3R5bGUiOiB7fSwgInVzZ3Nfc3RhdGlvbl9pZCI6IG51bGwsICJ2YXJpYWJsZSI6ICJESVNDSFJHIiwgIndkIjogIjYifSwgInR5cGUiOiAiRmVhdHVyZSJ9LCB7ImJib3giOiBbLTEwNS4zNDc5MDYsIDM5LjkzODM1MSwgLTEwNS4zNDc5MDYsIDM5LjkzODM1MV0sICJnZW9tZXRyeSI6IHsiY29vcmRpbmF0ZXMiOiBbLTEwNS4zNDc5MDYsIDM5LjkzODM1MV0sICJ0eXBlIjogIlBvaW50In0sICJpZCI6ICI1MiIsICJwcm9wZXJ0aWVzIjogeyJhbW91bnQiOiAiMjAxLjAwIiwgImNvdW50eSI6ICJCT1VMREVSIiwgImRhdGFfc291cmNlIjogIkNvLiBEaXZpc2lvbiBvZiBXYXRlciBSZXNvdXJjZXMiLCAiZGF0ZV90aW1lIjogIjIwMTgtMDUtMThUMTU6MTU6MDAiLCAiZGl2IjogIjEiLCAiZHdyX2FiYnJldiI6ICJCT0NCR1JDTyIsICJoaWdobGlnaHQiOiB7fSwgImh0dHBfbGlua2FnZS51cmwiOiAiaHR0cDovL3d3dy5kd3Iuc3RhdGUuY28udXMvU3VyZmFjZVdhdGVyL2RhdGEvZGV0YWlsX2dyYXBoLmFzcHg/SUQ9Qk9DQkdSQ08mTVRZUEU9RElTQ0hSRyIsICJsb2NhdGlvbi5sYXRpdHVkZSI6IDM5LjkzODM1MSwgImxvY2F0aW9uLmxvbmdpdHVkZSI6IC0xMDUuMzQ3OTA2LCAibG9jYXRpb24ubmVlZHNfcmVjb2RpbmciOiBmYWxzZSwgInN0YWdlIjogIjEuNTgiLCAic3RhdGlvbl9uYW1lIjogIlNPVVRIIEJPVUxERVIgQ1JFRUsgQkVMT1cgR1JPU1MgUkVTRVJWT0lSIiwgInN0YXRpb25fc3RhdHVzIjogIkFjdGl2ZSIsICJzdGF0aW9uX3R5cGUiOiAiU3RyZWFtIiwgInN0eWxlIjoge30sICJ1c2dzX3N0YXRpb25faWQiOiAiMDY3Mjk0NTAiLCAidmFyaWFibGUiOiAiRElTQ0hSRyIsICJ3ZCI6ICI2In0sICJ0eXBlIjogIkZlYXR1cmUifSwgeyJiYm94IjogWy0xMDUuMzA4NDMyLCAzOS45MzE4MTMsIC0xMDUuMzA4NDMyLCAzOS45MzE4MTNdLCAiZ2VvbWV0cnkiOiB7ImNvb3JkaW5hdGVzIjogWy0xMDUuMzA4NDMyLCAzOS45MzE4MTNdLCAidHlwZSI6ICJQb2ludCJ9LCAiaWQiOiAiNTMiLCAicHJvcGVydGllcyI6IHsiYW1vdW50IjogIjEwMy4wMCIsICJjb3VudHkiOiAiQk9VTERFUiIsICJkYXRhX3NvdXJjZSI6ICJDby4gRGl2aXNpb24gb2YgV2F0ZXIgUmVzb3VyY2VzIiwgImRhdGVfdGltZSI6ICIyMDE4LTA1LTE4VDE1OjMwOjAwIiwgImRpdiI6ICIxIiwgImR3cl9hYmJyZXYiOiAiQk9TREVMQ08iLCAiaGlnaGxpZ2h0Ijoge30sICJodHRwX2xpbmthZ2UudXJsIjogImh0dHA6Ly93d3cuZHdyLnN0YXRlLmNvLnVzL1N1cmZhY2VXYXRlci9kYXRhL2RldGFpbF9ncmFwaC5hc3B4P0lEPUJPU0RFTENPJk1UWVBFPURJU0NIUkciLCAibG9jYXRpb24ubGF0aXR1ZGUiOiAzOS45MzE4MTMsICJsb2NhdGlvbi5sb25naXR1ZGUiOiAtMTA1LjMwODQzMiwgImxvY2F0aW9uLm5lZWRzX3JlY29kaW5nIjogZmFsc2UsICJzdGFnZSI6ICIxLjYxIiwgInN0YXRpb25fbmFtZSI6ICJTT1VUSCBCT1VMREVSIENSRUVLIERJVkVSU0lPTiBORUFSIEVMRE9SQURPIFNQUklOR1MiLCAic3RhdGlvbl9zdGF0dXMiOiAiQWN0aXZlIiwgInN0YXRpb25fdHlwZSI6ICJEaXZlcnNpb24iLCAic3R5bGUiOiB7fSwgInVzZ3Nfc3RhdGlvbl9pZCI6IG51bGwsICJ2YXJpYWJsZSI6ICJESVNDSFJHIiwgIndkIjogIjYifSwgInR5cGUiOiAiRmVhdHVyZSJ9LCB7ImJib3giOiBbLTEwNS4zMDQ5OSwgMzkuOTMxNTk3LCAtMTA1LjMwNDk5LCAzOS45MzE1OTddLCAiZ2VvbWV0cnkiOiB7ImNvb3JkaW5hdGVzIjogWy0xMDUuMzA0OTksIDM5LjkzMTU5N10sICJ0eXBlIjogIlBvaW50In0sICJpZCI6ICI1NCIsICJwcm9wZXJ0aWVzIjogeyJhbW91bnQiOiAiOTcuMTAiLCAiY291bnR5IjogIkJPVUxERVIiLCAiZGF0YV9zb3VyY2UiOiAiQ28uIERpdmlzaW9uIG9mIFdhdGVyIFJlc291cmNlcyIsICJkYXRlX3RpbWUiOiAiMjAxOC0wNS0xOFQxNToxNTowMCIsICJkaXYiOiAiMSIsICJkd3JfYWJicmV2IjogIkJPQ0VMU0NPIiwgImhpZ2hsaWdodCI6IHt9LCAiaHR0cF9saW5rYWdlLnVybCI6ICJodHRwOi8vd3d3LmR3ci5zdGF0ZS5jby51cy9TdXJmYWNlV2F0ZXIvZGF0YS9kZXRhaWxfZ3JhcGguYXNweD9JRD1CT0NFTFNDTyZNVFlQRT1ESVNDSFJHIiwgImxvY2F0aW9uLmxhdGl0dWRlIjogMzkuOTMxNTk3LCAibG9jYXRpb24ubG9uZ2l0dWRlIjogLTEwNS4zMDQ5OSwgImxvY2F0aW9uLm5lZWRzX3JlY29kaW5nIjogZmFsc2UsICJzdGFnZSI6ICIyLjg3IiwgInN0YXRpb25fbmFtZSI6ICJTT1VUSCBCT1VMREVSIENSRUVLIE5FQVIgRUxET1JBRE8gU1BSSU5HUyIsICJzdGF0aW9uX3N0YXR1cyI6ICJBY3RpdmUiLCAic3RhdGlvbl90eXBlIjogIlN0cmVhbSIsICJzdHlsZSI6IHt9LCAidXNnc19zdGF0aW9uX2lkIjogbnVsbCwgInZhcmlhYmxlIjogIkRJU0NIUkciLCAid2QiOiAiNiJ9LCAidHlwZSI6ICJGZWF0dXJlIn1dLCAidHlwZSI6ICJGZWF0dXJlQ29sbGVjdGlvbiJ9CiAgICAgICAgICAgICAgICAgICAgCiAgICAgICAgICAgICAgICAgICAgKS5hZGRUbyhtYXBfNzBjMTg1MDMyN2EzNGE5Njk5ZWVlZGFlNzk0MmFhZDYpOwogICAgICAgICAgICAgICAgZ2VvX2pzb25fYmQ3MDc3OWIwMjEzNGZkMjgwMzgxODQ1N2I4ZmE0MGMuc2V0U3R5bGUoZnVuY3Rpb24oZmVhdHVyZSkge3JldHVybiBmZWF0dXJlLnByb3BlcnRpZXMuc3R5bGU7fSk7CgogICAgICAgICAgICAKPC9zY3JpcHQ+" style="position:absolute;width:100%;height:100%;left:0;top:0;border:none !important;" allowfullscreen webkitallowfullscreen mozallowfullscreen></iframe></div></div>





Great you have a map! Cluser then markers, and add popup to each marker so you can give your viewers more information about station: such as its name, and amount of precipiation measured.

In this example you will work with a `Pandas DataFrame` instead of a `Geopandas GeoDataFrame.`

{:.input}
```python
locations = result[['location.latitude', 'location.longitude']]
coords = locations.values.tolist()
```

{:.input}
```python
m = folium.Map([40.01, -105.27], zoom_start= 10, tiles='cartodbpositron')
for point in range(0, len(coords)):
    folium.Marker(coords[point], popup= 'Name: ' + result['station_name'][point]+ ' '+ 'Amount: ' + result['amount'][point]).add_to(m)
    
m
```

{:.output}
{:.execute_result}



<div style="width:100%;"><div style="position:relative;width:100%;height:0;padding-bottom:60%;"><iframe src="data:text/html;charset=utf-8;base64,PCFET0NUWVBFIGh0bWw+CjxoZWFkPiAgICAKICAgIDxtZXRhIGh0dHAtZXF1aXY9ImNvbnRlbnQtdHlwZSIgY29udGVudD0idGV4dC9odG1sOyBjaGFyc2V0PVVURi04IiAvPgogICAgPHNjcmlwdD5MX1BSRUZFUl9DQU5WQVMgPSBmYWxzZTsgTF9OT19UT1VDSCA9IGZhbHNlOyBMX0RJU0FCTEVfM0QgPSBmYWxzZTs8L3NjcmlwdD4KICAgIDxzY3JpcHQgc3JjPSJodHRwczovL2Nkbi5qc2RlbGl2ci5uZXQvbnBtL2xlYWZsZXRAMS4yLjAvZGlzdC9sZWFmbGV0LmpzIj48L3NjcmlwdD4KICAgIDxzY3JpcHQgc3JjPSJodHRwczovL2FqYXguZ29vZ2xlYXBpcy5jb20vYWpheC9saWJzL2pxdWVyeS8xLjExLjEvanF1ZXJ5Lm1pbi5qcyI+PC9zY3JpcHQ+CiAgICA8c2NyaXB0IHNyYz0iaHR0cHM6Ly9tYXhjZG4uYm9vdHN0cmFwY2RuLmNvbS9ib290c3RyYXAvMy4yLjAvanMvYm9vdHN0cmFwLm1pbi5qcyI+PC9zY3JpcHQ+CiAgICA8c2NyaXB0IHNyYz0iaHR0cHM6Ly9jZG5qcy5jbG91ZGZsYXJlLmNvbS9hamF4L2xpYnMvTGVhZmxldC5hd2Vzb21lLW1hcmtlcnMvMi4wLjIvbGVhZmxldC5hd2Vzb21lLW1hcmtlcnMuanMiPjwvc2NyaXB0PgogICAgPGxpbmsgcmVsPSJzdHlsZXNoZWV0IiBocmVmPSJodHRwczovL2Nkbi5qc2RlbGl2ci5uZXQvbnBtL2xlYWZsZXRAMS4yLjAvZGlzdC9sZWFmbGV0LmNzcyIgLz4KICAgIDxsaW5rIHJlbD0ic3R5bGVzaGVldCIgaHJlZj0iaHR0cHM6Ly9tYXhjZG4uYm9vdHN0cmFwY2RuLmNvbS9ib290c3RyYXAvMy4yLjAvY3NzL2Jvb3RzdHJhcC5taW4uY3NzIiAvPgogICAgPGxpbmsgcmVsPSJzdHlsZXNoZWV0IiBocmVmPSJodHRwczovL21heGNkbi5ib290c3RyYXBjZG4uY29tL2Jvb3RzdHJhcC8zLjIuMC9jc3MvYm9vdHN0cmFwLXRoZW1lLm1pbi5jc3MiIC8+CiAgICA8bGluayByZWw9InN0eWxlc2hlZXQiIGhyZWY9Imh0dHBzOi8vbWF4Y2RuLmJvb3RzdHJhcGNkbi5jb20vZm9udC1hd2Vzb21lLzQuNi4zL2Nzcy9mb250LWF3ZXNvbWUubWluLmNzcyIgLz4KICAgIDxsaW5rIHJlbD0ic3R5bGVzaGVldCIgaHJlZj0iaHR0cHM6Ly9jZG5qcy5jbG91ZGZsYXJlLmNvbS9hamF4L2xpYnMvTGVhZmxldC5hd2Vzb21lLW1hcmtlcnMvMi4wLjIvbGVhZmxldC5hd2Vzb21lLW1hcmtlcnMuY3NzIiAvPgogICAgPGxpbmsgcmVsPSJzdHlsZXNoZWV0IiBocmVmPSJodHRwczovL3Jhd2dpdC5jb20vcHl0aG9uLXZpc3VhbGl6YXRpb24vZm9saXVtL21hc3Rlci9mb2xpdW0vdGVtcGxhdGVzL2xlYWZsZXQuYXdlc29tZS5yb3RhdGUuY3NzIiAvPgogICAgPHN0eWxlPmh0bWwsIGJvZHkge3dpZHRoOiAxMDAlO2hlaWdodDogMTAwJTttYXJnaW46IDA7cGFkZGluZzogMDt9PC9zdHlsZT4KICAgIDxzdHlsZT4jbWFwIHtwb3NpdGlvbjphYnNvbHV0ZTt0b3A6MDtib3R0b206MDtyaWdodDowO2xlZnQ6MDt9PC9zdHlsZT4KICAgIAogICAgICAgICAgICA8c3R5bGU+ICNtYXBfY2ZkZDU4Y2M0ZTFjNDhiYjhhOTFhNGZlYjg2ODc1MmEgewogICAgICAgICAgICAgICAgcG9zaXRpb24gOiByZWxhdGl2ZTsKICAgICAgICAgICAgICAgIHdpZHRoIDogMTAwLjAlOwogICAgICAgICAgICAgICAgaGVpZ2h0OiAxMDAuMCU7CiAgICAgICAgICAgICAgICBsZWZ0OiAwLjAlOwogICAgICAgICAgICAgICAgdG9wOiAwLjAlOwogICAgICAgICAgICAgICAgfQogICAgICAgICAgICA8L3N0eWxlPgogICAgICAgIAo8L2hlYWQ+Cjxib2R5PiAgICAKICAgIAogICAgICAgICAgICA8ZGl2IGNsYXNzPSJmb2xpdW0tbWFwIiBpZD0ibWFwX2NmZGQ1OGNjNGUxYzQ4YmI4YTkxYTRmZWI4Njg3NTJhIiA+PC9kaXY+CiAgICAgICAgCjwvYm9keT4KPHNjcmlwdD4gICAgCiAgICAKCiAgICAgICAgICAgIAogICAgICAgICAgICAgICAgdmFyIGJvdW5kcyA9IG51bGw7CiAgICAgICAgICAgIAoKICAgICAgICAgICAgdmFyIG1hcF9jZmRkNThjYzRlMWM0OGJiOGE5MWE0ZmViODY4NzUyYSA9IEwubWFwKAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgJ21hcF9jZmRkNThjYzRlMWM0OGJiOGE5MWE0ZmViODY4NzUyYScsCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICB7Y2VudGVyOiBbNDAuMDEsLTEwNS4yN10sCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICB6b29tOiAxMCwKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIG1heEJvdW5kczogYm91bmRzLAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgbGF5ZXJzOiBbXSwKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIHdvcmxkQ29weUp1bXA6IGZhbHNlLAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgY3JzOiBMLkNSUy5FUFNHMzg1NwogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICB9KTsKICAgICAgICAgICAgCiAgICAgICAgCiAgICAKICAgICAgICAgICAgdmFyIHRpbGVfbGF5ZXJfZDQ4MTJiMjZlOTgwNGRhNzhiNThkMTk1MmM1OWY2MzggPSBMLnRpbGVMYXllcigKICAgICAgICAgICAgICAgICdodHRwczovL2NhcnRvZGItYmFzZW1hcHMte3N9Lmdsb2JhbC5zc2wuZmFzdGx5Lm5ldC9saWdodF9hbGwve3p9L3t4fS97eX0ucG5nJywKICAgICAgICAgICAgICAgIHsKICAiYXR0cmlidXRpb24iOiBudWxsLAogICJkZXRlY3RSZXRpbmEiOiBmYWxzZSwKICAibWF4Wm9vbSI6IDE4LAogICJtaW5ab29tIjogMSwKICAibm9XcmFwIjogZmFsc2UsCiAgInN1YmRvbWFpbnMiOiAiYWJjIgp9CiAgICAgICAgICAgICAgICApLmFkZFRvKG1hcF9jZmRkNThjYzRlMWM0OGJiOGE5MWE0ZmViODY4NzUyYSk7CiAgICAgICAgCiAgICAKCiAgICAgICAgICAgIHZhciBtYXJrZXJfOTk4ZTE3NDUxMGYzNDM2YThmOTA5Nzk4ZTkxZjVlZjQgPSBMLm1hcmtlcigKICAgICAgICAgICAgICAgIFs0MC4yNTc4NDQsLTEwNS4xNjQzOTddLAogICAgICAgICAgICAgICAgewogICAgICAgICAgICAgICAgICAgIGljb246IG5ldyBMLkljb24uRGVmYXVsdCgpCiAgICAgICAgICAgICAgICAgICAgfQogICAgICAgICAgICAgICAgKQogICAgICAgICAgICAgICAgLmFkZFRvKG1hcF9jZmRkNThjYzRlMWM0OGJiOGE5MWE0ZmViODY4NzUyYSk7CiAgICAgICAgICAgIAogICAgCiAgICAgICAgICAgIHZhciBwb3B1cF9mODEzOGJjYWE5MGI0MDVmYjA0NDJlOGRhNWFkNDIzZiA9IEwucG9wdXAoe21heFdpZHRoOiAnMzAwJ30pOwoKICAgICAgICAgICAgCiAgICAgICAgICAgICAgICB2YXIgaHRtbF82YTkxZjY0YjE3NmM0ZTE5OGFjNTBhZTgzOGQyYWY4NiA9ICQoJzxkaXYgaWQ9Imh0bWxfNmE5MWY2NGIxNzZjNGUxOThhYzUwYWU4MzhkMmFmODYiIHN0eWxlPSJ3aWR0aDogMTAwLjAlOyBoZWlnaHQ6IDEwMC4wJTsiPk5hbWU6IEJMT1dFUiBESVRDSCBBbW91bnQ6IDEuOTI8L2Rpdj4nKVswXTsKICAgICAgICAgICAgICAgIHBvcHVwX2Y4MTM4YmNhYTkwYjQwNWZiMDQ0MmU4ZGE1YWQ0MjNmLnNldENvbnRlbnQoaHRtbF82YTkxZjY0YjE3NmM0ZTE5OGFjNTBhZTgzOGQyYWY4Nik7CiAgICAgICAgICAgIAoKICAgICAgICAgICAgbWFya2VyXzk5OGUxNzQ1MTBmMzQzNmE4ZjkwOTc5OGU5MWY1ZWY0LmJpbmRQb3B1cChwb3B1cF9mODEzOGJjYWE5MGI0MDVmYjA0NDJlOGRhNWFkNDIzZik7CgogICAgICAgICAgICAKICAgICAgICAKICAgIAoKICAgICAgICAgICAgdmFyIG1hcmtlcl82NjE3NjI2Y2NkNjc0NjJjOGI0MWE2Njc5MjMwOGE2YiA9IEwubWFya2VyKAogICAgICAgICAgICAgICAgWzQwLjI1ODcyNiwtMTA1LjE3NTgxN10sCiAgICAgICAgICAgICAgICB7CiAgICAgICAgICAgICAgICAgICAgaWNvbjogbmV3IEwuSWNvbi5EZWZhdWx0KCkKICAgICAgICAgICAgICAgICAgICB9CiAgICAgICAgICAgICAgICApCiAgICAgICAgICAgICAgICAuYWRkVG8obWFwX2NmZGQ1OGNjNGUxYzQ4YmI4YTkxYTRmZWI4Njg3NTJhKTsKICAgICAgICAgICAgCiAgICAKICAgICAgICAgICAgdmFyIHBvcHVwXzY3Nzg0ZGJkZTI3YTQyMWJiZTIyNjI1NjdiOWNiMjdlID0gTC5wb3B1cCh7bWF4V2lkdGg6ICczMDAnfSk7CgogICAgICAgICAgICAKICAgICAgICAgICAgICAgIHZhciBodG1sXzI0MmI0YjA5ZGY3ODRiNzNiNDEyYTBlODcyMDdmMDFhID0gJCgnPGRpdiBpZD0iaHRtbF8yNDJiNGIwOWRmNzg0YjczYjQxMmEwZTg3MjA3ZjAxYSIgc3R5bGU9IndpZHRoOiAxMDAuMCU7IGhlaWdodDogMTAwLjAlOyI+TmFtZTogQk9VTERFUi1MQVJJTUVSIEJZUEFTUyBORUFSIEJFUlRIT1VEIEFtb3VudDogMC44MDwvZGl2PicpWzBdOwogICAgICAgICAgICAgICAgcG9wdXBfNjc3ODRkYmRlMjdhNDIxYmJlMjI2MjU2N2I5Y2IyN2Uuc2V0Q29udGVudChodG1sXzI0MmI0YjA5ZGY3ODRiNzNiNDEyYTBlODcyMDdmMDFhKTsKICAgICAgICAgICAgCgogICAgICAgICAgICBtYXJrZXJfNjYxNzYyNmNjZDY3NDYyYzhiNDFhNjY3OTIzMDhhNmIuYmluZFBvcHVwKHBvcHVwXzY3Nzg0ZGJkZTI3YTQyMWJiZTIyNjI1NjdiOWNiMjdlKTsKCiAgICAgICAgICAgIAogICAgICAgIAogICAgCgogICAgICAgICAgICB2YXIgbWFya2VyXzM0NGNhZTM1ZTYwZTQ0OThhZjEyMzY2MzQ3MDM1MjA4ID0gTC5tYXJrZXIoCiAgICAgICAgICAgICAgICBbNDAuMjU4MzY3LC0xMDUuMTc0OTU3XSwKICAgICAgICAgICAgICAgIHsKICAgICAgICAgICAgICAgICAgICBpY29uOiBuZXcgTC5JY29uLkRlZmF1bHQoKQogICAgICAgICAgICAgICAgICAgIH0KICAgICAgICAgICAgICAgICkKICAgICAgICAgICAgICAgIC5hZGRUbyhtYXBfY2ZkZDU4Y2M0ZTFjNDhiYjhhOTFhNGZlYjg2ODc1MmEpOwogICAgICAgICAgICAKICAgIAogICAgICAgICAgICB2YXIgcG9wdXBfZmRkMDdkZGUzYTM2NDVlNWEyMDYxMjQ5MWVkNDI5YmIgPSBMLnBvcHVwKHttYXhXaWR0aDogJzMwMCd9KTsKCiAgICAgICAgICAgIAogICAgICAgICAgICAgICAgdmFyIGh0bWxfMjNhZTk2Y2JiZmY4NDc0NDk2OTAyNThiYTVkMTFlM2UgPSAkKCc8ZGl2IGlkPSJodG1sXzIzYWU5NmNiYmZmODQ3NDQ5NjkwMjU4YmE1ZDExZTNlIiBzdHlsZT0id2lkdGg6IDEwMC4wJTsgaGVpZ2h0OiAxMDAuMCU7Ij5OYW1lOiBCT1VMREVSLUxBUklNRVIgRElUQ0ggTkVBUiBCRVJUSE9VRCBBbW91bnQ6IDcuNTQ8L2Rpdj4nKVswXTsKICAgICAgICAgICAgICAgIHBvcHVwX2ZkZDA3ZGRlM2EzNjQ1ZTVhMjA2MTI0OTFlZDQyOWJiLnNldENvbnRlbnQoaHRtbF8yM2FlOTZjYmJmZjg0NzQ0OTY5MDI1OGJhNWQxMWUzZSk7CiAgICAgICAgICAgIAoKICAgICAgICAgICAgbWFya2VyXzM0NGNhZTM1ZTYwZTQ0OThhZjEyMzY2MzQ3MDM1MjA4LmJpbmRQb3B1cChwb3B1cF9mZGQwN2RkZTNhMzY0NWU1YTIwNjEyNDkxZWQ0MjliYik7CgogICAgICAgICAgICAKICAgICAgICAKICAgIAoKICAgICAgICAgICAgdmFyIG1hcmtlcl82NjQxMTIzYzY1OTQ0MjYwYWNhZjkxNjk0MDE2ZTRlNSA9IEwubWFya2VyKAogICAgICAgICAgICAgICAgWzQwLjI2MDgyNywtMTA1LjE5ODU2N10sCiAgICAgICAgICAgICAgICB7CiAgICAgICAgICAgICAgICAgICAgaWNvbjogbmV3IEwuSWNvbi5EZWZhdWx0KCkKICAgICAgICAgICAgICAgICAgICB9CiAgICAgICAgICAgICAgICApCiAgICAgICAgICAgICAgICAuYWRkVG8obWFwX2NmZGQ1OGNjNGUxYzQ4YmI4YTkxYTRmZWI4Njg3NTJhKTsKICAgICAgICAgICAgCiAgICAKICAgICAgICAgICAgdmFyIHBvcHVwXzhlZTJiNGVkY2Q0NDQ0ZWY4NjRhOWYyYzJkYTFkMzA3ID0gTC5wb3B1cCh7bWF4V2lkdGg6ICczMDAnfSk7CgogICAgICAgICAgICAKICAgICAgICAgICAgICAgIHZhciBodG1sX2EwNTEzYjU0MjI5NzQ4NmQ4YzJmNmJhOGYzZTcxYmU0ID0gJCgnPGRpdiBpZD0iaHRtbF9hMDUxM2I1NDIyOTc0ODZkOGMyZjZiYThmM2U3MWJlNCIgc3R5bGU9IndpZHRoOiAxMDAuMCU7IGhlaWdodDogMTAwLjAlOyI+TmFtZTogQ1VMVkVSIERJVENIIEFtb3VudDogNS44MzwvZGl2PicpWzBdOwogICAgICAgICAgICAgICAgcG9wdXBfOGVlMmI0ZWRjZDQ0NDRlZjg2NGE5ZjJjMmRhMWQzMDcuc2V0Q29udGVudChodG1sX2EwNTEzYjU0MjI5NzQ4NmQ4YzJmNmJhOGYzZTcxYmU0KTsKICAgICAgICAgICAgCgogICAgICAgICAgICBtYXJrZXJfNjY0MTEyM2M2NTk0NDI2MGFjYWY5MTY5NDAxNmU0ZTUuYmluZFBvcHVwKHBvcHVwXzhlZTJiNGVkY2Q0NDQ0ZWY4NjRhOWYyYzJkYTFkMzA3KTsKCiAgICAgICAgICAgIAogICAgICAgIAogICAgCgogICAgICAgICAgICB2YXIgbWFya2VyXzI5NjE3Y2QyNjMyNzQ4NTQ4NTA1NDE2MjcxMTZiOGU0ID0gTC5tYXJrZXIoCiAgICAgICAgICAgICAgICBbNDAuMjU2Mjc2LC0xMDUuMjA5NDE2XSwKICAgICAgICAgICAgICAgIHsKICAgICAgICAgICAgICAgICAgICBpY29uOiBuZXcgTC5JY29uLkRlZmF1bHQoKQogICAgICAgICAgICAgICAgICAgIH0KICAgICAgICAgICAgICAgICkKICAgICAgICAgICAgICAgIC5hZGRUbyhtYXBfY2ZkZDU4Y2M0ZTFjNDhiYjhhOTFhNGZlYjg2ODc1MmEpOwogICAgICAgICAgICAKICAgIAogICAgICAgICAgICB2YXIgcG9wdXBfMTc0YTAxM2M2ZDQxNDYzZTg3YTE3MDQwODZiMGIzMWEgPSBMLnBvcHVwKHttYXhXaWR0aDogJzMwMCd9KTsKCiAgICAgICAgICAgIAogICAgICAgICAgICAgICAgdmFyIGh0bWxfODkyYjNjYjkyMGNhNGI3ZjkwNjIxYmI4Y2ZiODgxYTYgPSAkKCc8ZGl2IGlkPSJodG1sXzg5MmIzY2I5MjBjYTRiN2Y5MDYyMWJiOGNmYjg4MWE2IiBzdHlsZT0id2lkdGg6IDEwMC4wJTsgaGVpZ2h0OiAxMDAuMCU7Ij5OYW1lOiBMSVRUTEUgVEhPTVBTT04gIzEgRElUQ0ggQW1vdW50OiAwLjAwPC9kaXY+JylbMF07CiAgICAgICAgICAgICAgICBwb3B1cF8xNzRhMDEzYzZkNDE0NjNlODdhMTcwNDA4NmIwYjMxYS5zZXRDb250ZW50KGh0bWxfODkyYjNjYjkyMGNhNGI3ZjkwNjIxYmI4Y2ZiODgxYTYpOwogICAgICAgICAgICAKCiAgICAgICAgICAgIG1hcmtlcl8yOTYxN2NkMjYzMjc0ODU0ODUwNTQxNjI3MTE2YjhlNC5iaW5kUG9wdXAocG9wdXBfMTc0YTAxM2M2ZDQxNDYzZTg3YTE3MDQwODZiMGIzMWEpOwoKICAgICAgICAgICAgCiAgICAgICAgCiAgICAKCiAgICAgICAgICAgIHZhciBtYXJrZXJfNmE0ZjE4MGZkMmIzNGVlMmIyOGI2NjlhMDVmM2FlMjIgPSBMLm1hcmtlcigKICAgICAgICAgICAgICAgIFs0MC4yNTU3NzYsLTEwNS4yMDk1XSwKICAgICAgICAgICAgICAgIHsKICAgICAgICAgICAgICAgICAgICBpY29uOiBuZXcgTC5JY29uLkRlZmF1bHQoKQogICAgICAgICAgICAgICAgICAgIH0KICAgICAgICAgICAgICAgICkKICAgICAgICAgICAgICAgIC5hZGRUbyhtYXBfY2ZkZDU4Y2M0ZTFjNDhiYjhhOTFhNGZlYjg2ODc1MmEpOwogICAgICAgICAgICAKICAgIAogICAgICAgICAgICB2YXIgcG9wdXBfZTY1MGJkZDZhY2VkNDJiYWFlYmJkNmU4MzVjMmU0ODUgPSBMLnBvcHVwKHttYXhXaWR0aDogJzMwMCd9KTsKCiAgICAgICAgICAgIAogICAgICAgICAgICAgICAgdmFyIGh0bWxfYTU0ZjExYjI1ZjhjNDAyNGFlNWU0MjEzMjAyN2ZlZmIgPSAkKCc8ZGl2IGlkPSJodG1sX2E1NGYxMWIyNWY4YzQwMjRhZTVlNDIxMzIwMjdmZWZiIiBzdHlsZT0id2lkdGg6IDEwMC4wJTsgaGVpZ2h0OiAxMDAuMCU7Ij5OYW1lOiBMSVRUTEUgVEhPTVBTT04gIzIgRElUQ0ggQW1vdW50OiAwLjAwPC9kaXY+JylbMF07CiAgICAgICAgICAgICAgICBwb3B1cF9lNjUwYmRkNmFjZWQ0MmJhYWViYmQ2ZTgzNWMyZTQ4NS5zZXRDb250ZW50KGh0bWxfYTU0ZjExYjI1ZjhjNDAyNGFlNWU0MjEzMjAyN2ZlZmIpOwogICAgICAgICAgICAKCiAgICAgICAgICAgIG1hcmtlcl82YTRmMTgwZmQyYjM0ZWUyYjI4YjY2OWEwNWYzYWUyMi5iaW5kUG9wdXAocG9wdXBfZTY1MGJkZDZhY2VkNDJiYWFlYmJkNmU4MzVjMmU0ODUpOwoKICAgICAgICAgICAgCiAgICAgICAgCiAgICAKCiAgICAgICAgICAgIHZhciBtYXJrZXJfYzE5NWViMzRjZDAyNGU4Njg5MGYxODgxN2JjMTU0MTkgPSBMLm1hcmtlcigKICAgICAgICAgICAgICAgIFs0MC4yNTgwMzgsLTEwNS4yMDYzODZdLAogICAgICAgICAgICAgICAgewogICAgICAgICAgICAgICAgICAgIGljb246IG5ldyBMLkljb24uRGVmYXVsdCgpCiAgICAgICAgICAgICAgICAgICAgfQogICAgICAgICAgICAgICAgKQogICAgICAgICAgICAgICAgLmFkZFRvKG1hcF9jZmRkNThjYzRlMWM0OGJiOGE5MWE0ZmViODY4NzUyYSk7CiAgICAgICAgICAgIAogICAgCiAgICAgICAgICAgIHZhciBwb3B1cF8wNWNkODNkYjU2OGM0YzY2OTVjYzllYTUyM2VlOTVhYiA9IEwucG9wdXAoe21heFdpZHRoOiAnMzAwJ30pOwoKICAgICAgICAgICAgCiAgICAgICAgICAgICAgICB2YXIgaHRtbF81ZmQyMDRhMjhjMDQ0Y2U5YjExYzk2Zjc1MTQxMjNlOSA9ICQoJzxkaXYgaWQ9Imh0bWxfNWZkMjA0YTI4YzA0NGNlOWIxMWM5NmY3NTE0MTIzZTkiIHN0eWxlPSJ3aWR0aDogMTAwLjAlOyBoZWlnaHQ6IDEwMC4wJTsiPk5hbWU6IExJVFRMRSBUSE9NUFNPTiBSSVZFUiBBVCBDQU5ZT04gTU9VVEggTkVBUiBCRVJUSE9VRCBBbW91bnQ6IDE0LjIwPC9kaXY+JylbMF07CiAgICAgICAgICAgICAgICBwb3B1cF8wNWNkODNkYjU2OGM0YzY2OTVjYzllYTUyM2VlOTVhYi5zZXRDb250ZW50KGh0bWxfNWZkMjA0YTI4YzA0NGNlOWIxMWM5NmY3NTE0MTIzZTkpOwogICAgICAgICAgICAKCiAgICAgICAgICAgIG1hcmtlcl9jMTk1ZWIzNGNkMDI0ZTg2ODkwZjE4ODE3YmMxNTQxOS5iaW5kUG9wdXAocG9wdXBfMDVjZDgzZGI1NjhjNGM2Njk1Y2M5ZWE1MjNlZTk1YWIpOwoKICAgICAgICAgICAgCiAgICAgICAgCiAgICAKCiAgICAgICAgICAgIHZhciBtYXJrZXJfNjU4ZGMxZWM1NWI0NGNiYzhlZTljMWI1OGFhY2YyZjIgPSBMLm1hcmtlcigKICAgICAgICAgICAgICAgIFs0MC4xNTMzNjMsLTEwNS4wODg2OTVdLAogICAgICAgICAgICAgICAgewogICAgICAgICAgICAgICAgICAgIGljb246IG5ldyBMLkljb24uRGVmYXVsdCgpCiAgICAgICAgICAgICAgICAgICAgfQogICAgICAgICAgICAgICAgKQogICAgICAgICAgICAgICAgLmFkZFRvKG1hcF9jZmRkNThjYzRlMWM0OGJiOGE5MWE0ZmViODY4NzUyYSk7CiAgICAgICAgICAgIAogICAgCiAgICAgICAgICAgIHZhciBwb3B1cF83NGJkZDU5NWQ0MDA0MTJkODM4NjI2NmJmZWM3ZWMzZSA9IEwucG9wdXAoe21heFdpZHRoOiAnMzAwJ30pOwoKICAgICAgICAgICAgCiAgICAgICAgICAgICAgICB2YXIgaHRtbF9iYzMxOWQxMzg2NTE0ZGQzODdiYzVhMmQ4NmFmMjU1YyA9ICQoJzxkaXYgaWQ9Imh0bWxfYmMzMTlkMTM4NjUxNGRkMzg3YmM1YTJkODZhZjI1NWMiIHN0eWxlPSJ3aWR0aDogMTAwLjAlOyBoZWlnaHQ6IDEwMC4wJTsiPk5hbWU6IEJPTlVTIERJVENIIEFtb3VudDogMC4wMzwvZGl2PicpWzBdOwogICAgICAgICAgICAgICAgcG9wdXBfNzRiZGQ1OTVkNDAwNDEyZDgzODYyNjZiZmVjN2VjM2Uuc2V0Q29udGVudChodG1sX2JjMzE5ZDEzODY1MTRkZDM4N2JjNWEyZDg2YWYyNTVjKTsKICAgICAgICAgICAgCgogICAgICAgICAgICBtYXJrZXJfNjU4ZGMxZWM1NWI0NGNiYzhlZTljMWI1OGFhY2YyZjIuYmluZFBvcHVwKHBvcHVwXzc0YmRkNTk1ZDQwMDQxMmQ4Mzg2MjY2YmZlYzdlYzNlKTsKCiAgICAgICAgICAgIAogICAgICAgIAogICAgCgogICAgICAgICAgICB2YXIgbWFya2VyX2M0YjUzZjkyMTZhMzQ4OGY4MWY1M2UwZGMxMDkxOTJlID0gTC5tYXJrZXIoCiAgICAgICAgICAgICAgICBbNDAuMjE2MjYzLC0xMDUuMzY1MzY1XSwKICAgICAgICAgICAgICAgIHsKICAgICAgICAgICAgICAgICAgICBpY29uOiBuZXcgTC5JY29uLkRlZmF1bHQoKQogICAgICAgICAgICAgICAgICAgIH0KICAgICAgICAgICAgICAgICkKICAgICAgICAgICAgICAgIC5hZGRUbyhtYXBfY2ZkZDU4Y2M0ZTFjNDhiYjhhOTFhNGZlYjg2ODc1MmEpOwogICAgICAgICAgICAKICAgIAogICAgICAgICAgICB2YXIgcG9wdXBfMTA4OGY0OGE3NTExNGRlZmFmZjI2Njc5ZTkyYWUyZTcgPSBMLnBvcHVwKHttYXhXaWR0aDogJzMwMCd9KTsKCiAgICAgICAgICAgIAogICAgICAgICAgICAgICAgdmFyIGh0bWxfZGMzNzY0ZTE2MzUwNGRjYjhkNDQ5N2U1MzEzM2E5NzEgPSAkKCc8ZGl2IGlkPSJodG1sX2RjMzc2NGUxNjM1MDRkY2I4ZDQ0OTdlNTMxMzNhOTcxIiBzdHlsZT0id2lkdGg6IDEwMC4wJTsgaGVpZ2h0OiAxMDAuMCU7Ij5OYW1lOiBCVVRUT05ST0NLIChSQUxQSCBQUklDRSkgUkVTRVJWT0lSIEFtb3VudDogMTYyNzEuMDA8L2Rpdj4nKVswXTsKICAgICAgICAgICAgICAgIHBvcHVwXzEwODhmNDhhNzUxMTRkZWZhZmYyNjY3OWU5MmFlMmU3LnNldENvbnRlbnQoaHRtbF9kYzM3NjRlMTYzNTA0ZGNiOGQ0NDk3ZTUzMTMzYTk3MSk7CiAgICAgICAgICAgIAoKICAgICAgICAgICAgbWFya2VyX2M0YjUzZjkyMTZhMzQ4OGY4MWY1M2UwZGMxMDkxOTJlLmJpbmRQb3B1cChwb3B1cF8xMDg4ZjQ4YTc1MTE0ZGVmYWZmMjY2NzllOTJhZTJlNyk7CgogICAgICAgICAgICAKICAgICAgICAKICAgIAoKICAgICAgICAgICAgdmFyIG1hcmtlcl85MjNiMGU3ODY4MjY0ZGNkODY4N2U4Y2Y5YTlmYjU2MSA9IEwubWFya2VyKAogICAgICAgICAgICAgICAgWzQwLjE5Mzc1OCwtMTA1LjIxMDM5XSwKICAgICAgICAgICAgICAgIHsKICAgICAgICAgICAgICAgICAgICBpY29uOiBuZXcgTC5JY29uLkRlZmF1bHQoKQogICAgICAgICAgICAgICAgICAgIH0KICAgICAgICAgICAgICAgICkKICAgICAgICAgICAgICAgIC5hZGRUbyhtYXBfY2ZkZDU4Y2M0ZTFjNDhiYjhhOTFhNGZlYjg2ODc1MmEpOwogICAgICAgICAgICAKICAgIAogICAgICAgICAgICB2YXIgcG9wdXBfOTZiZWRjYTNkYzNmNDNmN2I4MzFkNDFmNzE3NjU5OTkgPSBMLnBvcHVwKHttYXhXaWR0aDogJzMwMCd9KTsKCiAgICAgICAgICAgIAogICAgICAgICAgICAgICAgdmFyIGh0bWxfYmNlMWViZmZiMjYyNGQ5Njk0NjNlMGEyYTQwM2E1MzMgPSAkKCc8ZGl2IGlkPSJodG1sX2JjZTFlYmZmYjI2MjRkOTY5NDYzZTBhMmE0MDNhNTMzIiBzdHlsZT0id2lkdGg6IDEwMC4wJTsgaGVpZ2h0OiAxMDAuMCU7Ij5OYW1lOiBDTE9VR0ggQU5EIFRSVUUgRElUQ0ggQW1vdW50OiAzLjkzPC9kaXY+JylbMF07CiAgICAgICAgICAgICAgICBwb3B1cF85NmJlZGNhM2RjM2Y0M2Y3YjgzMWQ0MWY3MTc2NTk5OS5zZXRDb250ZW50KGh0bWxfYmNlMWViZmZiMjYyNGQ5Njk0NjNlMGEyYTQwM2E1MzMpOwogICAgICAgICAgICAKCiAgICAgICAgICAgIG1hcmtlcl85MjNiMGU3ODY4MjY0ZGNkODY4N2U4Y2Y5YTlmYjU2MS5iaW5kUG9wdXAocG9wdXBfOTZiZWRjYTNkYzNmNDNmN2I4MzFkNDFmNzE3NjU5OTkpOwoKICAgICAgICAgICAgCiAgICAgICAgCiAgICAKCiAgICAgICAgICAgIHZhciBtYXJrZXJfOTMzOGQ4NWEzY2I0NDU4YTkwZWFiMDg0MGUxYzFkYzIgPSBMLm1hcmtlcigKICAgICAgICAgICAgICAgIFs0MC4xODE4OCwtMTA1LjE5Njc3NV0sCiAgICAgICAgICAgICAgICB7CiAgICAgICAgICAgICAgICAgICAgaWNvbjogbmV3IEwuSWNvbi5EZWZhdWx0KCkKICAgICAgICAgICAgICAgICAgICB9CiAgICAgICAgICAgICAgICApCiAgICAgICAgICAgICAgICAuYWRkVG8obWFwX2NmZGQ1OGNjNGUxYzQ4YmI4YTkxYTRmZWI4Njg3NTJhKTsKICAgICAgICAgICAgCiAgICAKICAgICAgICAgICAgdmFyIHBvcHVwXzVhMGZlOWVkZTNiMzQ2M2JhZGUwZjIyNjg1NjlhYTRkID0gTC5wb3B1cCh7bWF4V2lkdGg6ICczMDAnfSk7CgogICAgICAgICAgICAKICAgICAgICAgICAgICAgIHZhciBodG1sX2RjYWU0NzA1MTIzMTQyZDg4ZWQ2MDk0ODU5MTg5M2I2ID0gJCgnPGRpdiBpZD0iaHRtbF9kY2FlNDcwNTEyMzE0MmQ4OGVkNjA5NDg1OTE4OTNiNiIgc3R5bGU9IndpZHRoOiAxMDAuMCU7IGhlaWdodDogMTAwLjAlOyI+TmFtZTogREFWSVMgQU5EIERPV05JTkcgRElUQ0ggQW1vdW50OiA2LjQxPC9kaXY+JylbMF07CiAgICAgICAgICAgICAgICBwb3B1cF81YTBmZTllZGUzYjM0NjNiYWRlMGYyMjY4NTY5YWE0ZC5zZXRDb250ZW50KGh0bWxfZGNhZTQ3MDUxMjMxNDJkODhlZDYwOTQ4NTkxODkzYjYpOwogICAgICAgICAgICAKCiAgICAgICAgICAgIG1hcmtlcl85MzM4ZDg1YTNjYjQ0NThhOTBlYWIwODQwZTFjMWRjMi5iaW5kUG9wdXAocG9wdXBfNWEwZmU5ZWRlM2IzNDYzYmFkZTBmMjI2ODU2OWFhNGQpOwoKICAgICAgICAgICAgCiAgICAgICAgCiAgICAKCiAgICAgICAgICAgIHZhciBtYXJrZXJfZGM1NjZjMzgwMTE2NDBhNGE2ZDc0M2FlYjczNDJiZmIgPSBMLm1hcmtlcigKICAgICAgICAgICAgICAgIFs0MC4xODc1NzgsLTEwNS4xODkxOTFdLAogICAgICAgICAgICAgICAgewogICAgICAgICAgICAgICAgICAgIGljb246IG5ldyBMLkljb24uRGVmYXVsdCgpCiAgICAgICAgICAgICAgICAgICAgfQogICAgICAgICAgICAgICAgKQogICAgICAgICAgICAgICAgLmFkZFRvKG1hcF9jZmRkNThjYzRlMWM0OGJiOGE5MWE0ZmViODY4NzUyYSk7CiAgICAgICAgICAgIAogICAgCiAgICAgICAgICAgIHZhciBwb3B1cF80MDcxNGFhYmE2ZGU0N2NhOGU1N2Q3NmYyNmFjNTJjMSA9IEwucG9wdXAoe21heFdpZHRoOiAnMzAwJ30pOwoKICAgICAgICAgICAgCiAgICAgICAgICAgICAgICB2YXIgaHRtbF9kYjc1MDVlYjM1MTY0MWNhYTM1MjFlMzNjNzdkNDRiNSA9ICQoJzxkaXYgaWQ9Imh0bWxfZGI3NTA1ZWIzNTE2NDFjYWEzNTIxZTMzYzc3ZDQ0YjUiIHN0eWxlPSJ3aWR0aDogMTAwLjAlOyBoZWlnaHQ6IDEwMC4wJTsiPk5hbWU6IERFTklPIFRBWUxPUiBESVRDSCBBbW91bnQ6IDIuMjg8L2Rpdj4nKVswXTsKICAgICAgICAgICAgICAgIHBvcHVwXzQwNzE0YWFiYTZkZTQ3Y2E4ZTU3ZDc2ZjI2YWM1MmMxLnNldENvbnRlbnQoaHRtbF9kYjc1MDVlYjM1MTY0MWNhYTM1MjFlMzNjNzdkNDRiNSk7CiAgICAgICAgICAgIAoKICAgICAgICAgICAgbWFya2VyX2RjNTY2YzM4MDExNjQwYTRhNmQ3NDNhZWI3MzQyYmZiLmJpbmRQb3B1cChwb3B1cF80MDcxNGFhYmE2ZGU0N2NhOGU1N2Q3NmYyNmFjNTJjMSk7CgogICAgICAgICAgICAKICAgICAgICAKICAgIAoKICAgICAgICAgICAgdmFyIG1hcmtlcl9lYjQwNzBjNGY4YWY0NThlYjlhZjZkMTRhNTdmNTc2YSA9IEwubWFya2VyKAogICAgICAgICAgICAgICAgWzQwLjE5OTMyMSwtMTA1LjIyMjYzOV0sCiAgICAgICAgICAgICAgICB7CiAgICAgICAgICAgICAgICAgICAgaWNvbjogbmV3IEwuSWNvbi5EZWZhdWx0KCkKICAgICAgICAgICAgICAgICAgICB9CiAgICAgICAgICAgICAgICApCiAgICAgICAgICAgICAgICAuYWRkVG8obWFwX2NmZGQ1OGNjNGUxYzQ4YmI4YTkxYTRmZWI4Njg3NTJhKTsKICAgICAgICAgICAgCiAgICAKICAgICAgICAgICAgdmFyIHBvcHVwX2YxZTgwZTU4NzQ2MDQ1Mjk4YjgwYjdlZGEzMTQ4MDBjID0gTC5wb3B1cCh7bWF4V2lkdGg6ICczMDAnfSk7CgogICAgICAgICAgICAKICAgICAgICAgICAgICAgIHZhciBodG1sXzVkNTU2NzViMDRiMjRmODg4NTQyOTllNzEzY2YwMGVlID0gJCgnPGRpdiBpZD0iaHRtbF81ZDU1Njc1YjA0YjI0Zjg4ODU0Mjk5ZTcxM2NmMDBlZSIgc3R5bGU9IndpZHRoOiAxMDAuMCU7IGhlaWdodDogMTAwLjAlOyI+TmFtZTogR09TUyBESVRDSCAxIEFtb3VudDogMTEuNzM8L2Rpdj4nKVswXTsKICAgICAgICAgICAgICAgIHBvcHVwX2YxZTgwZTU4NzQ2MDQ1Mjk4YjgwYjdlZGEzMTQ4MDBjLnNldENvbnRlbnQoaHRtbF81ZDU1Njc1YjA0YjI0Zjg4ODU0Mjk5ZTcxM2NmMDBlZSk7CiAgICAgICAgICAgIAoKICAgICAgICAgICAgbWFya2VyX2ViNDA3MGM0ZjhhZjQ1OGViOWFmNmQxNGE1N2Y1NzZhLmJpbmRQb3B1cChwb3B1cF9mMWU4MGU1ODc0NjA0NTI5OGI4MGI3ZWRhMzE0ODAwYyk7CgogICAgICAgICAgICAKICAgICAgICAKICAgIAoKICAgICAgICAgICAgdmFyIG1hcmtlcl81ZmVkMzc3NDI1OWI0NGIwOTczNmJmZmM0OGNmOWM2OSA9IEwubWFya2VyKAogICAgICAgICAgICAgICAgWzQwLjE3NDg0NCwtMTA1LjE2Nzg3M10sCiAgICAgICAgICAgICAgICB7CiAgICAgICAgICAgICAgICAgICAgaWNvbjogbmV3IEwuSWNvbi5EZWZhdWx0KCkKICAgICAgICAgICAgICAgICAgICB9CiAgICAgICAgICAgICAgICApCiAgICAgICAgICAgICAgICAuYWRkVG8obWFwX2NmZGQ1OGNjNGUxYzQ4YmI4YTkxYTRmZWI4Njg3NTJhKTsKICAgICAgICAgICAgCiAgICAKICAgICAgICAgICAgdmFyIHBvcHVwXzA3ZDUxOTlmNTQ2MzQ4M2JhMDU1MmUyMjBhOTNlNDgxID0gTC5wb3B1cCh7bWF4V2lkdGg6ICczMDAnfSk7CgogICAgICAgICAgICAKICAgICAgICAgICAgICAgIHZhciBodG1sX2E3MTZhNDRkZjc1MjQ4YTJhNzQxNGMwMjMzNmQwYmQ0ID0gJCgnPGRpdiBpZD0iaHRtbF9hNzE2YTQ0ZGY3NTI0OGEyYTc0MTRjMDIzMzZkMGJkNCIgc3R5bGU9IndpZHRoOiAxMDAuMCU7IGhlaWdodDogMTAwLjAlOyI+TmFtZTogSEFHRVIgTUVBRE9XUyBESVRDSCBBbW91bnQ6IDIuNjc8L2Rpdj4nKVswXTsKICAgICAgICAgICAgICAgIHBvcHVwXzA3ZDUxOTlmNTQ2MzQ4M2JhMDU1MmUyMjBhOTNlNDgxLnNldENvbnRlbnQoaHRtbF9hNzE2YTQ0ZGY3NTI0OGEyYTc0MTRjMDIzMzZkMGJkNCk7CiAgICAgICAgICAgIAoKICAgICAgICAgICAgbWFya2VyXzVmZWQzNzc0MjU5YjQ0YjA5NzM2YmZmYzQ4Y2Y5YzY5LmJpbmRQb3B1cChwb3B1cF8wN2Q1MTk5ZjU0NjM0ODNiYTA1NTJlMjIwYTkzZTQ4MSk7CgogICAgICAgICAgICAKICAgICAgICAKICAgIAoKICAgICAgICAgICAgdmFyIG1hcmtlcl83OTRjYTRkNDQ0N2U0N2I5ODJmNmQzNWM3MjUzMmVkMyA9IEwubWFya2VyKAogICAgICAgICAgICAgICAgWzQwLjIxNTA0MywtMTA1LjI1NjAxN10sCiAgICAgICAgICAgICAgICB7CiAgICAgICAgICAgICAgICAgICAgaWNvbjogbmV3IEwuSWNvbi5EZWZhdWx0KCkKICAgICAgICAgICAgICAgICAgICB9CiAgICAgICAgICAgICAgICApCiAgICAgICAgICAgICAgICAuYWRkVG8obWFwX2NmZGQ1OGNjNGUxYzQ4YmI4YTkxYTRmZWI4Njg3NTJhKTsKICAgICAgICAgICAgCiAgICAKICAgICAgICAgICAgdmFyIHBvcHVwXzQ3MTFiZjI1Njc4NjQ1OWE5MDFlMmUxMDViZDJhNjRiID0gTC5wb3B1cCh7bWF4V2lkdGg6ICczMDAnfSk7CgogICAgICAgICAgICAKICAgICAgICAgICAgICAgIHZhciBodG1sX2Q3Njc1NTljNGYwNzQzODg5N2E4NjAzYzk5YjAzZTA2ID0gJCgnPGRpdiBpZD0iaHRtbF9kNzY3NTU5YzRmMDc0Mzg4OTdhODYwM2M5OWIwM2UwNiIgc3R5bGU9IndpZHRoOiAxMDAuMCU7IGhlaWdodDogMTAwLjAlOyI+TmFtZTogSElHSExBTkQgRElUQ0ggQVQgTFlPTlMsIENPIEFtb3VudDogOTIuNzA8L2Rpdj4nKVswXTsKICAgICAgICAgICAgICAgIHBvcHVwXzQ3MTFiZjI1Njc4NjQ1OWE5MDFlMmUxMDViZDJhNjRiLnNldENvbnRlbnQoaHRtbF9kNzY3NTU5YzRmMDc0Mzg4OTdhODYwM2M5OWIwM2UwNik7CiAgICAgICAgICAgIAoKICAgICAgICAgICAgbWFya2VyXzc5NGNhNGQ0NDQ3ZTQ3Yjk4MmY2ZDM1YzcyNTMyZWQzLmJpbmRQb3B1cChwb3B1cF80NzExYmYyNTY3ODY0NTlhOTAxZTJlMTA1YmQyYTY0Yik7CgogICAgICAgICAgICAKICAgICAgICAKICAgIAoKICAgICAgICAgICAgdmFyIG1hcmtlcl83M2E1ZDhhMDFiODI0YzgxYWU2ZDgzOTRiZTE3OTE4YyA9IEwubWFya2VyKAogICAgICAgICAgICAgICAgWzQwLjE4ODU3OSwtMTA1LjIwOTI4Ml0sCiAgICAgICAgICAgICAgICB7CiAgICAgICAgICAgICAgICAgICAgaWNvbjogbmV3IEwuSWNvbi5EZWZhdWx0KCkKICAgICAgICAgICAgICAgICAgICB9CiAgICAgICAgICAgICAgICApCiAgICAgICAgICAgICAgICAuYWRkVG8obWFwX2NmZGQ1OGNjNGUxYzQ4YmI4YTkxYTRmZWI4Njg3NTJhKTsKICAgICAgICAgICAgCiAgICAKICAgICAgICAgICAgdmFyIHBvcHVwXzhmMjlmNzM0YjU3ZTQ1ZDI4Mzg4YWYyMWRhMjg2NjgyID0gTC5wb3B1cCh7bWF4V2lkdGg6ICczMDAnfSk7CgogICAgICAgICAgICAKICAgICAgICAgICAgICAgIHZhciBodG1sXzAyNjQxMzA3YjViZTQ0MmU4ZGQ1OGM3MTg4MWU0YWZlID0gJCgnPGRpdiBpZD0iaHRtbF8wMjY0MTMwN2I1YmU0NDJlOGRkNThjNzE4ODFlNGFmZSIgc3R5bGU9IndpZHRoOiAxMDAuMCU7IGhlaWdodDogMTAwLjAlOyI+TmFtZTogSkFNRVMgRElUQ0ggQW1vdW50OiA0LjQ5PC9kaXY+JylbMF07CiAgICAgICAgICAgICAgICBwb3B1cF84ZjI5ZjczNGI1N2U0NWQyODM4OGFmMjFkYTI4NjY4Mi5zZXRDb250ZW50KGh0bWxfMDI2NDEzMDdiNWJlNDQyZThkZDU4YzcxODgxZTRhZmUpOwogICAgICAgICAgICAKCiAgICAgICAgICAgIG1hcmtlcl83M2E1ZDhhMDFiODI0YzgxYWU2ZDgzOTRiZTE3OTE4Yy5iaW5kUG9wdXAocG9wdXBfOGYyOWY3MzRiNTdlNDVkMjgzODhhZjIxZGEyODY2ODIpOwoKICAgICAgICAgICAgCiAgICAgICAgCiAgICAKCiAgICAgICAgICAgIHZhciBtYXJrZXJfMzlmN2YxZTFiMWVmNGQyM2E1MTVlNTk5Y2JhYjNkYmYgPSBMLm1hcmtlcigKICAgICAgICAgICAgICAgIFs0MC4xMzQyNzgsLTEwNS4xMzA4MTldLAogICAgICAgICAgICAgICAgewogICAgICAgICAgICAgICAgICAgIGljb246IG5ldyBMLkljb24uRGVmYXVsdCgpCiAgICAgICAgICAgICAgICAgICAgfQogICAgICAgICAgICAgICAgKQogICAgICAgICAgICAgICAgLmFkZFRvKG1hcF9jZmRkNThjYzRlMWM0OGJiOGE5MWE0ZmViODY4NzUyYSk7CiAgICAgICAgICAgIAogICAgCiAgICAgICAgICAgIHZhciBwb3B1cF8xZDA1N2NjNzRhNjc0YjllYjFhNDBiNzdhM2FlMWQxOSA9IEwucG9wdXAoe21heFdpZHRoOiAnMzAwJ30pOwoKICAgICAgICAgICAgCiAgICAgICAgICAgICAgICB2YXIgaHRtbF9kNzQ3NjU3MWQ5NzU0NjZhYmE1MDI4MjU5OTZmOTBiMiA9ICQoJzxkaXYgaWQ9Imh0bWxfZDc0NzY1NzFkOTc1NDY2YWJhNTAyODI1OTk2ZjkwYjIiIHN0eWxlPSJ3aWR0aDogMTAwLjAlOyBoZWlnaHQ6IDEwMC4wJTsiPk5hbWU6IExFRlQgSEFORCBDUkVFSyBBVCBIT1ZFUiBST0FEIE5FQVIgTE9OR01PTlQsIENPIEFtb3VudDogNDUuMjA8L2Rpdj4nKVswXTsKICAgICAgICAgICAgICAgIHBvcHVwXzFkMDU3Y2M3NGE2NzRiOWViMWE0MGI3N2EzYWUxZDE5LnNldENvbnRlbnQoaHRtbF9kNzQ3NjU3MWQ5NzU0NjZhYmE1MDI4MjU5OTZmOTBiMik7CiAgICAgICAgICAgIAoKICAgICAgICAgICAgbWFya2VyXzM5ZjdmMWUxYjFlZjRkMjNhNTE1ZTU5OWNiYWIzZGJmLmJpbmRQb3B1cChwb3B1cF8xZDA1N2NjNzRhNjc0YjllYjFhNDBiNzdhM2FlMWQxOSk7CgogICAgICAgICAgICAKICAgICAgICAKICAgIAoKICAgICAgICAgICAgdmFyIG1hcmtlcl82MTJjZjE4ZGRiNDQ0OGIzYmIzMmZkMmY2MjMxMDE0MCA9IEwubWFya2VyKAogICAgICAgICAgICAgICAgWzQwLjEyNjM4OSwtMTA1LjMwNDQwNF0sCiAgICAgICAgICAgICAgICB7CiAgICAgICAgICAgICAgICAgICAgaWNvbjogbmV3IEwuSWNvbi5EZWZhdWx0KCkKICAgICAgICAgICAgICAgICAgICB9CiAgICAgICAgICAgICAgICApCiAgICAgICAgICAgICAgICAuYWRkVG8obWFwX2NmZGQ1OGNjNGUxYzQ4YmI4YTkxYTRmZWI4Njg3NTJhKTsKICAgICAgICAgICAgCiAgICAKICAgICAgICAgICAgdmFyIHBvcHVwX2Y2ZTMxOGEzMmFmYzQ4Yzc5Y2YwYzg4ZDJhMjM1NDZjID0gTC5wb3B1cCh7bWF4V2lkdGg6ICczMDAnfSk7CgogICAgICAgICAgICAKICAgICAgICAgICAgICAgIHZhciBodG1sX2MzNzM1MTZlN2Q1MDQzMTRhYmQxZjZhYTRlM2U1ZTE1ID0gJCgnPGRpdiBpZD0iaHRtbF9jMzczNTE2ZTdkNTA0MzE0YWJkMWY2YWE0ZTNlNWUxNSIgc3R5bGU9IndpZHRoOiAxMDAuMCU7IGhlaWdodDogMTAwLjAlOyI+TmFtZTogTEVGVCBIQU5EIENSRUVLIE5FQVIgQk9VTERFUiwgQ08uIEFtb3VudDogMTAzLjAwPC9kaXY+JylbMF07CiAgICAgICAgICAgICAgICBwb3B1cF9mNmUzMThhMzJhZmM0OGM3OWNmMGM4OGQyYTIzNTQ2Yy5zZXRDb250ZW50KGh0bWxfYzM3MzUxNmU3ZDUwNDMxNGFiZDFmNmFhNGUzZTVlMTUpOwogICAgICAgICAgICAKCiAgICAgICAgICAgIG1hcmtlcl82MTJjZjE4ZGRiNDQ0OGIzYmIzMmZkMmY2MjMxMDE0MC5iaW5kUG9wdXAocG9wdXBfZjZlMzE4YTMyYWZjNDhjNzljZjBjODhkMmEyMzU0NmMpOwoKICAgICAgICAgICAgCiAgICAgICAgCiAgICAKCiAgICAgICAgICAgIHZhciBtYXJrZXJfZDg1OGFhZmE1YWI2NGFhN2EzNzYyNjk0ZThjZTVhMTAgPSBMLm1hcmtlcigKICAgICAgICAgICAgICAgIFs0MC4yMDQxOTMsLTEwNS4yMTg3NzddLAogICAgICAgICAgICAgICAgewogICAgICAgICAgICAgICAgICAgIGljb246IG5ldyBMLkljb24uRGVmYXVsdCgpCiAgICAgICAgICAgICAgICAgICAgfQogICAgICAgICAgICAgICAgKQogICAgICAgICAgICAgICAgLmFkZFRvKG1hcF9jZmRkNThjYzRlMWM0OGJiOGE5MWE0ZmViODY4NzUyYSk7CiAgICAgICAgICAgIAogICAgCiAgICAgICAgICAgIHZhciBwb3B1cF81YjBhNTdhNDBjMDQ0OTdiODgxYTI1NWJmYWY4ZjQyMiA9IEwucG9wdXAoe21heFdpZHRoOiAnMzAwJ30pOwoKICAgICAgICAgICAgCiAgICAgICAgICAgICAgICB2YXIgaHRtbF9hZTE4NzFhOWU1Yjg0ZDBjYTBhYjI4MWE5OGVkMDk2YiA9ICQoJzxkaXYgaWQ9Imh0bWxfYWUxODcxYTllNWI4NGQwY2EwYWIyODFhOThlZDA5NmIiIHN0eWxlPSJ3aWR0aDogMTAwLjAlOyBoZWlnaHQ6IDEwMC4wJTsiPk5hbWU6IExPTkdNT05UIFNVUFBMWSBESVRDSCBBbW91bnQ6IDUuMjU8L2Rpdj4nKVswXTsKICAgICAgICAgICAgICAgIHBvcHVwXzViMGE1N2E0MGMwNDQ5N2I4ODFhMjU1YmZhZjhmNDIyLnNldENvbnRlbnQoaHRtbF9hZTE4NzFhOWU1Yjg0ZDBjYTBhYjI4MWE5OGVkMDk2Yik7CiAgICAgICAgICAgIAoKICAgICAgICAgICAgbWFya2VyX2Q4NThhYWZhNWFiNjRhYTdhMzc2MjY5NGU4Y2U1YTEwLmJpbmRQb3B1cChwb3B1cF81YjBhNTdhNDBjMDQ0OTdiODgxYTI1NWJmYWY4ZjQyMik7CgogICAgICAgICAgICAKICAgICAgICAKICAgIAoKICAgICAgICAgICAgdmFyIG1hcmtlcl81ZDBlMzY4YmQ4YTI0M2Q2YjdlYmRiNTJmNTE3M2VlYSA9IEwubWFya2VyKAogICAgICAgICAgICAgICAgWzQwLjEyOTgwNiwtMTA1LjUxNzExMV0sCiAgICAgICAgICAgICAgICB7CiAgICAgICAgICAgICAgICAgICAgaWNvbjogbmV3IEwuSWNvbi5EZWZhdWx0KCkKICAgICAgICAgICAgICAgICAgICB9CiAgICAgICAgICAgICAgICApCiAgICAgICAgICAgICAgICAuYWRkVG8obWFwX2NmZGQ1OGNjNGUxYzQ4YmI4YTkxYTRmZWI4Njg3NTJhKTsKICAgICAgICAgICAgCiAgICAKICAgICAgICAgICAgdmFyIHBvcHVwXzBhYTk0NmJlOTc1OTQyZGNhMjEyMmRkZjY4MjdiYzgwID0gTC5wb3B1cCh7bWF4V2lkdGg6ICczMDAnfSk7CgogICAgICAgICAgICAKICAgICAgICAgICAgICAgIHZhciBodG1sX2U4ODIwZjY3OTg3ZTQwYmZiZTQ2NzcyNjVhMDY1YzVjID0gJCgnPGRpdiBpZD0iaHRtbF9lODgyMGY2Nzk4N2U0MGJmYmU0Njc3MjY1YTA2NWM1YyIgc3R5bGU9IndpZHRoOiAxMDAuMCU7IGhlaWdodDogMTAwLjAlOyI+TmFtZTogTUlERExFIFNBSU5UIFZSQUlOIEFUIFBFQUNFRlVMIFZBTExFWSBBbW91bnQ6IDk2LjAwPC9kaXY+JylbMF07CiAgICAgICAgICAgICAgICBwb3B1cF8wYWE5NDZiZTk3NTk0MmRjYTIxMjJkZGY2ODI3YmM4MC5zZXRDb250ZW50KGh0bWxfZTg4MjBmNjc5ODdlNDBiZmJlNDY3NzI2NWEwNjVjNWMpOwogICAgICAgICAgICAKCiAgICAgICAgICAgIG1hcmtlcl81ZDBlMzY4YmQ4YTI0M2Q2YjdlYmRiNTJmNTE3M2VlYS5iaW5kUG9wdXAocG9wdXBfMGFhOTQ2YmU5NzU5NDJkY2EyMTIyZGRmNjgyN2JjODApOwoKICAgICAgICAgICAgCiAgICAgICAgCiAgICAKCiAgICAgICAgICAgIHZhciBtYXJrZXJfNzE4MDA4YTczMTM0NDhiYmIyNDZmMjA5NzkzZjZlM2EgPSBMLm1hcmtlcigKICAgICAgICAgICAgICAgIFs0MC4xNzM5NSwtMTA1LjE2OTM3NF0sCiAgICAgICAgICAgICAgICB7CiAgICAgICAgICAgICAgICAgICAgaWNvbjogbmV3IEwuSWNvbi5EZWZhdWx0KCkKICAgICAgICAgICAgICAgICAgICB9CiAgICAgICAgICAgICAgICApCiAgICAgICAgICAgICAgICAuYWRkVG8obWFwX2NmZGQ1OGNjNGUxYzQ4YmI4YTkxYTRmZWI4Njg3NTJhKTsKICAgICAgICAgICAgCiAgICAKICAgICAgICAgICAgdmFyIHBvcHVwX2RjMjYzNWMyOTgwODRjOGQ5NmI4ZmU3NTlhZTM3YTI4ID0gTC5wb3B1cCh7bWF4V2lkdGg6ICczMDAnfSk7CgogICAgICAgICAgICAKICAgICAgICAgICAgICAgIHZhciBodG1sX2Y1ZjMxZTJjYTFiNDRiYmNhYmZmMWZmM2JmNzU4YTBkID0gJCgnPGRpdiBpZD0iaHRtbF9mNWYzMWUyY2ExYjQ0YmJjYWJmZjFmZjNiZjc1OGEwZCIgc3R5bGU9IndpZHRoOiAxMDAuMCU7IGhlaWdodDogMTAwLjAlOyI+TmFtZTogTklXT1QgRElUQ0ggQW1vdW50OiA1LjU1PC9kaXY+JylbMF07CiAgICAgICAgICAgICAgICBwb3B1cF9kYzI2MzVjMjk4MDg0YzhkOTZiOGZlNzU5YWUzN2EyOC5zZXRDb250ZW50KGh0bWxfZjVmMzFlMmNhMWI0NGJiY2FiZmYxZmYzYmY3NThhMGQpOwogICAgICAgICAgICAKCiAgICAgICAgICAgIG1hcmtlcl83MTgwMDhhNzMxMzQ0OGJiYjI0NmYyMDk3OTNmNmUzYS5iaW5kUG9wdXAocG9wdXBfZGMyNjM1YzI5ODA4NGM4ZDk2YjhmZTc1OWFlMzdhMjgpOwoKICAgICAgICAgICAgCiAgICAgICAgCiAgICAKCiAgICAgICAgICAgIHZhciBtYXJrZXJfY2RjNTY0ZmQyMGZlNDRiODk1MmVmYmRlODI5MGE3YjcgPSBMLm1hcmtlcigKICAgICAgICAgICAgICAgIFs0MC4yMTU2NTgsLTEwNS4zNjM0MjJdLAogICAgICAgICAgICAgICAgewogICAgICAgICAgICAgICAgICAgIGljb246IG5ldyBMLkljb24uRGVmYXVsdCgpCiAgICAgICAgICAgICAgICAgICAgfQogICAgICAgICAgICAgICAgKQogICAgICAgICAgICAgICAgLmFkZFRvKG1hcF9jZmRkNThjYzRlMWM0OGJiOGE5MWE0ZmViODY4NzUyYSk7CiAgICAgICAgICAgIAogICAgCiAgICAgICAgICAgIHZhciBwb3B1cF9iYjFhM2U5YmFhZjU0ZTBlODk3ZWFlY2RmMzkzMzEzNCA9IEwucG9wdXAoe21heFdpZHRoOiAnMzAwJ30pOwoKICAgICAgICAgICAgCiAgICAgICAgICAgICAgICB2YXIgaHRtbF83YzM3MTFlODZjNDQ0ZGUxOWJiODliNWY1Mjg4NWNiZCA9ICQoJzxkaXYgaWQ9Imh0bWxfN2MzNzExZTg2YzQ0NGRlMTliYjg5YjVmNTI4ODVjYmQiIHN0eWxlPSJ3aWR0aDogMTAwLjAlOyBoZWlnaHQ6IDEwMC4wJTsiPk5hbWU6IE5PUlRIIFNBSU5UIFZSQUlOIENSRUVLIEJFTE9XIEJVVFRPTlJPQ0sgIChSQUxQSCBQUklDRSkgUkVTRVJWT0lSIEFtb3VudDogMTU4LjAwPC9kaXY+JylbMF07CiAgICAgICAgICAgICAgICBwb3B1cF9iYjFhM2U5YmFhZjU0ZTBlODk3ZWFlY2RmMzkzMzEzNC5zZXRDb250ZW50KGh0bWxfN2MzNzExZTg2YzQ0NGRlMTliYjg5YjVmNTI4ODVjYmQpOwogICAgICAgICAgICAKCiAgICAgICAgICAgIG1hcmtlcl9jZGM1NjRmZDIwZmU0NGI4OTUyZWZiZGU4MjkwYTdiNy5iaW5kUG9wdXAocG9wdXBfYmIxYTNlOWJhYWY1NGUwZTg5N2VhZWNkZjM5MzMxMzQpOwoKICAgICAgICAgICAgCiAgICAgICAgCiAgICAKCiAgICAgICAgICAgIHZhciBtYXJrZXJfYzBiZDUzMDg2ZGZkNDEyYWE0NTkwNGFmYzBmMTBiOWYgPSBMLm1hcmtlcigKICAgICAgICAgICAgICAgIFs0MC4xNzI5MjUsLTEwNS4xNjc2MjJdLAogICAgICAgICAgICAgICAgewogICAgICAgICAgICAgICAgICAgIGljb246IG5ldyBMLkljb24uRGVmYXVsdCgpCiAgICAgICAgICAgICAgICAgICAgfQogICAgICAgICAgICAgICAgKQogICAgICAgICAgICAgICAgLmFkZFRvKG1hcF9jZmRkNThjYzRlMWM0OGJiOGE5MWE0ZmViODY4NzUyYSk7CiAgICAgICAgICAgIAogICAgCiAgICAgICAgICAgIHZhciBwb3B1cF8wZGFlY2VmZjNmNzc0OTgxOTVkM2JjOTUzMjZkNGVmNSA9IEwucG9wdXAoe21heFdpZHRoOiAnMzAwJ30pOwoKICAgICAgICAgICAgCiAgICAgICAgICAgICAgICB2YXIgaHRtbF8xN2E0NmU1NmI4NDU0NDIyYmIxYzU3ZGFhODI4ZTNlYiA9ICQoJzxkaXYgaWQ9Imh0bWxfMTdhNDZlNTZiODQ1NDQyMmJiMWM1N2RhYTgyOGUzZWIiIHN0eWxlPSJ3aWR0aDogMTAwLjAlOyBoZWlnaHQ6IDEwMC4wJTsiPk5hbWU6IE5PUlRIV0VTVCBNVVRVQUwgRElUQ0ggQW1vdW50OiAxLjYxPC9kaXY+JylbMF07CiAgICAgICAgICAgICAgICBwb3B1cF8wZGFlY2VmZjNmNzc0OTgxOTVkM2JjOTUzMjZkNGVmNS5zZXRDb250ZW50KGh0bWxfMTdhNDZlNTZiODQ1NDQyMmJiMWM1N2RhYTgyOGUzZWIpOwogICAgICAgICAgICAKCiAgICAgICAgICAgIG1hcmtlcl9jMGJkNTMwODZkZmQ0MTJhYTQ1OTA0YWZjMGYxMGI5Zi5iaW5kUG9wdXAocG9wdXBfMGRhZWNlZmYzZjc3NDk4MTk1ZDNiYzk1MzI2ZDRlZjUpOwoKICAgICAgICAgICAgCiAgICAgICAgCiAgICAKCiAgICAgICAgICAgIHZhciBtYXJrZXJfNTZjZWM5MDIwMTYwNDQ4YmJlY2YyMGIyYzIwZWJiZDMgPSBMLm1hcmtlcigKICAgICAgICAgICAgICAgIFs0MC4xOTY0MjIsLTEwNS4yMDY1OTJdLAogICAgICAgICAgICAgICAgewogICAgICAgICAgICAgICAgICAgIGljb246IG5ldyBMLkljb24uRGVmYXVsdCgpCiAgICAgICAgICAgICAgICAgICAgfQogICAgICAgICAgICAgICAgKQogICAgICAgICAgICAgICAgLmFkZFRvKG1hcF9jZmRkNThjYzRlMWM0OGJiOGE5MWE0ZmViODY4NzUyYSk7CiAgICAgICAgICAgIAogICAgCiAgICAgICAgICAgIHZhciBwb3B1cF8zYmUwMTk4YWViNWQ0MmEzYTcxM2M1M2ExMTUwNzE2MCA9IEwucG9wdXAoe21heFdpZHRoOiAnMzAwJ30pOwoKICAgICAgICAgICAgCiAgICAgICAgICAgICAgICB2YXIgaHRtbF8zMzA1MGQ3MGE0NzM0YzcwYjQ3YzE5MTAwYjYzMjc5MSA9ICQoJzxkaXYgaWQ9Imh0bWxfMzMwNTBkNzBhNDczNGM3MGI0N2MxOTEwMGI2MzI3OTEiIHN0eWxlPSJ3aWR0aDogMTAwLjAlOyBoZWlnaHQ6IDEwMC4wJTsiPk5hbWU6IE9MSUdBUkNIWSBESVRDSCBESVZFUlNJT04gQW1vdW50OiAyNS4zODwvZGl2PicpWzBdOwogICAgICAgICAgICAgICAgcG9wdXBfM2JlMDE5OGFlYjVkNDJhM2E3MTNjNTNhMTE1MDcxNjAuc2V0Q29udGVudChodG1sXzMzMDUwZDcwYTQ3MzRjNzBiNDdjMTkxMDBiNjMyNzkxKTsKICAgICAgICAgICAgCgogICAgICAgICAgICBtYXJrZXJfNTZjZWM5MDIwMTYwNDQ4YmJlY2YyMGIyYzIwZWJiZDMuYmluZFBvcHVwKHBvcHVwXzNiZTAxOThhZWI1ZDQyYTNhNzEzYzUzYTExNTA3MTYwKTsKCiAgICAgICAgICAgIAogICAgICAgIAogICAgCgogICAgICAgICAgICB2YXIgbWFya2VyXzg4NWFlODRlOGU2YzRlZDBiN2U4ZjM2ZGZiMDhjZGEzID0gTC5tYXJrZXIoCiAgICAgICAgICAgICAgICBbNDAuMjEyNTA1LC0xMDUuMjUxODI2XSwKICAgICAgICAgICAgICAgIHsKICAgICAgICAgICAgICAgICAgICBpY29uOiBuZXcgTC5JY29uLkRlZmF1bHQoKQogICAgICAgICAgICAgICAgICAgIH0KICAgICAgICAgICAgICAgICkKICAgICAgICAgICAgICAgIC5hZGRUbyhtYXBfY2ZkZDU4Y2M0ZTFjNDhiYjhhOTFhNGZlYjg2ODc1MmEpOwogICAgICAgICAgICAKICAgIAogICAgICAgICAgICB2YXIgcG9wdXBfNjMwMDAzNDRiNzBjNGY0NjkxMzI4OWRiOGEyNGZjYmIgPSBMLnBvcHVwKHttYXhXaWR0aDogJzMwMCd9KTsKCiAgICAgICAgICAgIAogICAgICAgICAgICAgICAgdmFyIGh0bWxfMjczNGEyOTgyNmQ0NDc2MTg2M2RmZjI5NjlhMjlhYTMgPSAkKCc8ZGl2IGlkPSJodG1sXzI3MzRhMjk4MjZkNDQ3NjE4NjNkZmYyOTY5YTI5YWEzIiBzdHlsZT0id2lkdGg6IDEwMC4wJTsgaGVpZ2h0OiAxMDAuMCU7Ij5OYW1lOiBQQUxNRVJUT04gRElUQ0ggQW1vdW50OiAyNi41NjwvZGl2PicpWzBdOwogICAgICAgICAgICAgICAgcG9wdXBfNjMwMDAzNDRiNzBjNGY0NjkxMzI4OWRiOGEyNGZjYmIuc2V0Q29udGVudChodG1sXzI3MzRhMjk4MjZkNDQ3NjE4NjNkZmYyOTY5YTI5YWEzKTsKICAgICAgICAgICAgCgogICAgICAgICAgICBtYXJrZXJfODg1YWU4NGU4ZTZjNGVkMGI3ZThmMzZkZmIwOGNkYTMuYmluZFBvcHVwKHBvcHVwXzYzMDAwMzQ0YjcwYzRmNDY5MTMyODlkYjhhMjRmY2JiKTsKCiAgICAgICAgICAgIAogICAgICAgIAogICAgCgogICAgICAgICAgICB2YXIgbWFya2VyXzllNzJlNzZkNTNmNDRiMzhhM2M5ZGU3ZTM1MjlhN2I0ID0gTC5tYXJrZXIoCiAgICAgICAgICAgICAgICBbNDAuMTc3MDgsLTEwNS4xNzg1NjddLAogICAgICAgICAgICAgICAgewogICAgICAgICAgICAgICAgICAgIGljb246IG5ldyBMLkljb24uRGVmYXVsdCgpCiAgICAgICAgICAgICAgICAgICAgfQogICAgICAgICAgICAgICAgKQogICAgICAgICAgICAgICAgLmFkZFRvKG1hcF9jZmRkNThjYzRlMWM0OGJiOGE5MWE0ZmViODY4NzUyYSk7CiAgICAgICAgICAgIAogICAgCiAgICAgICAgICAgIHZhciBwb3B1cF9iNzRmODM3ZWQxYTc0ZjZlOGMwODE4YTkwMjhhMTM4YyA9IEwucG9wdXAoe21heFdpZHRoOiAnMzAwJ30pOwoKICAgICAgICAgICAgCiAgICAgICAgICAgICAgICB2YXIgaHRtbF8wNzI3NGI2ZWM4MmE0Y2VmOTM0NGI3MTA3ZWNiM2Y5MCA9ICQoJzxkaXYgaWQ9Imh0bWxfMDcyNzRiNmVjODJhNGNlZjkzNDRiNzEwN2VjYjNmOTAiIHN0eWxlPSJ3aWR0aDogMTAwLjAlOyBoZWlnaHQ6IDEwMC4wJTsiPk5hbWU6IFBFQ0sgUEVMTEEgQ0xPVkVSIERJVENIIEFtb3VudDogMS4yOTwvZGl2PicpWzBdOwogICAgICAgICAgICAgICAgcG9wdXBfYjc0ZjgzN2VkMWE3NGY2ZThjMDgxOGE5MDI4YTEzOGMuc2V0Q29udGVudChodG1sXzA3Mjc0YjZlYzgyYTRjZWY5MzQ0YjcxMDdlY2IzZjkwKTsKICAgICAgICAgICAgCgogICAgICAgICAgICBtYXJrZXJfOWU3MmU3NmQ1M2Y0NGIzOGEzYzlkZTdlMzUyOWE3YjQuYmluZFBvcHVwKHBvcHVwX2I3NGY4MzdlZDFhNzRmNmU4YzA4MThhOTAyOGExMzhjKTsKCiAgICAgICAgICAgIAogICAgICAgIAogICAgCgogICAgICAgICAgICB2YXIgbWFya2VyX2Y0NzA1YjIwMGYwMDQzZmQ5MWE2OWYwNjU3MzM3YTNhID0gTC5tYXJrZXIoCiAgICAgICAgICAgICAgICBbNDAuMjEyNjU4LC0xMDUuMjUxODI2XSwKICAgICAgICAgICAgICAgIHsKICAgICAgICAgICAgICAgICAgICBpY29uOiBuZXcgTC5JY29uLkRlZmF1bHQoKQogICAgICAgICAgICAgICAgICAgIH0KICAgICAgICAgICAgICAgICkKICAgICAgICAgICAgICAgIC5hZGRUbyhtYXBfY2ZkZDU4Y2M0ZTFjNDhiYjhhOTFhNGZlYjg2ODc1MmEpOwogICAgICAgICAgICAKICAgIAogICAgICAgICAgICB2YXIgcG9wdXBfOTM5OTk1OWM4ODMxNDk2OTk0YTJjZDVkZTNjOGY5YmUgPSBMLnBvcHVwKHttYXhXaWR0aDogJzMwMCd9KTsKCiAgICAgICAgICAgIAogICAgICAgICAgICAgICAgdmFyIGh0bWxfOGY2NGFkMzY1MDI5NGU3YWIzMjE5MzJlNzA0NGQzOWMgPSAkKCc8ZGl2IGlkPSJodG1sXzhmNjRhZDM2NTAyOTRlN2FiMzIxOTMyZTcwNDRkMzljIiBzdHlsZT0id2lkdGg6IDEwMC4wJTsgaGVpZ2h0OiAxMDAuMCU7Ij5OYW1lOiBST1VHSCBBTkQgUkVBRFkgRElUQ0ggQW1vdW50OiAzMi45NjwvZGl2PicpWzBdOwogICAgICAgICAgICAgICAgcG9wdXBfOTM5OTk1OWM4ODMxNDk2OTk0YTJjZDVkZTNjOGY5YmUuc2V0Q29udGVudChodG1sXzhmNjRhZDM2NTAyOTRlN2FiMzIxOTMyZTcwNDRkMzljKTsKICAgICAgICAgICAgCgogICAgICAgICAgICBtYXJrZXJfZjQ3MDViMjAwZjAwNDNmZDkxYTY5ZjA2NTczMzdhM2EuYmluZFBvcHVwKHBvcHVwXzkzOTk5NTljODgzMTQ5Njk5NGEyY2Q1ZGUzYzhmOWJlKTsKCiAgICAgICAgICAgIAogICAgICAgIAogICAgCgogICAgICAgICAgICB2YXIgbWFya2VyXzM5NjIyYjMwZjgwYjRmNjhiN2Q1NmIzZDNlYzFmMTgzID0gTC5tYXJrZXIoCiAgICAgICAgICAgICAgICBbNDAuMTg3NTI0LC0xMDUuMTg5MTMyXSwKICAgICAgICAgICAgICAgIHsKICAgICAgICAgICAgICAgICAgICBpY29uOiBuZXcgTC5JY29uLkRlZmF1bHQoKQogICAgICAgICAgICAgICAgICAgIH0KICAgICAgICAgICAgICAgICkKICAgICAgICAgICAgICAgIC5hZGRUbyhtYXBfY2ZkZDU4Y2M0ZTFjNDhiYjhhOTFhNGZlYjg2ODc1MmEpOwogICAgICAgICAgICAKICAgIAogICAgICAgICAgICB2YXIgcG9wdXBfZGYwOGNkYmYyMmNhNDM3MDkzODcwMmU4ZTgwYWY1MDkgPSBMLnBvcHVwKHttYXhXaWR0aDogJzMwMCd9KTsKCiAgICAgICAgICAgIAogICAgICAgICAgICAgICAgdmFyIGh0bWxfZmUzYzM2N2NmODg5NGMwYmI5MmQ5MDczMTZiZDg1MjcgPSAkKCc8ZGl2IGlkPSJodG1sX2ZlM2MzNjdjZjg4OTRjMGJiOTJkOTA3MzE2YmQ4NTI3IiBzdHlsZT0id2lkdGg6IDEwMC4wJTsgaGVpZ2h0OiAxMDAuMCU7Ij5OYW1lOiBSVU5ZT04gRElUQ0ggQW1vdW50OiAwLjAwPC9kaXY+JylbMF07CiAgICAgICAgICAgICAgICBwb3B1cF9kZjA4Y2RiZjIyY2E0MzcwOTM4NzAyZThlODBhZjUwOS5zZXRDb250ZW50KGh0bWxfZmUzYzM2N2NmODg5NGMwYmI5MmQ5MDczMTZiZDg1MjcpOwogICAgICAgICAgICAKCiAgICAgICAgICAgIG1hcmtlcl8zOTYyMmIzMGY4MGI0ZjY4YjdkNTZiM2QzZWMxZjE4My5iaW5kUG9wdXAocG9wdXBfZGYwOGNkYmYyMmNhNDM3MDkzODcwMmU4ZTgwYWY1MDkpOwoKICAgICAgICAgICAgCiAgICAgICAgCiAgICAKCiAgICAgICAgICAgIHZhciBtYXJrZXJfYjllNDk0ODU5MmMyNDdmNGJiYmJiNTkyMzFmMmExM2EgPSBMLm1hcmtlcigKICAgICAgICAgICAgICAgIFs0MC4xNzc0MjMsLTEwNS4xNzgxNDVdLAogICAgICAgICAgICAgICAgewogICAgICAgICAgICAgICAgICAgIGljb246IG5ldyBMLkljb24uRGVmYXVsdCgpCiAgICAgICAgICAgICAgICAgICAgfQogICAgICAgICAgICAgICAgKQogICAgICAgICAgICAgICAgLmFkZFRvKG1hcF9jZmRkNThjYzRlMWM0OGJiOGE5MWE0ZmViODY4NzUyYSk7CiAgICAgICAgICAgIAogICAgCiAgICAgICAgICAgIHZhciBwb3B1cF9jMWRiMzQxMGUzOTY0ZmE4YjQ5MjdmOWFmNmM0N2ZhMCA9IEwucG9wdXAoe21heFdpZHRoOiAnMzAwJ30pOwoKICAgICAgICAgICAgCiAgICAgICAgICAgICAgICB2YXIgaHRtbF9mYWY3YWYwOWEyZGY0YjM0OWM1NDcxOGMxMGRlNWU4MyA9ICQoJzxkaXYgaWQ9Imh0bWxfZmFmN2FmMDlhMmRmNGIzNDljNTQ3MThjMTBkZTVlODMiIHN0eWxlPSJ3aWR0aDogMTAwLjAlOyBoZWlnaHQ6IDEwMC4wJTsiPk5hbWU6IFNBSU5UIFZSQUlOIENSRUVLIEFUIEhZR0lFTkUsIENPIEFtb3VudDogNDQuMjA8L2Rpdj4nKVswXTsKICAgICAgICAgICAgICAgIHBvcHVwX2MxZGIzNDEwZTM5NjRmYThiNDkyN2Y5YWY2YzQ3ZmEwLnNldENvbnRlbnQoaHRtbF9mYWY3YWYwOWEyZGY0YjM0OWM1NDcxOGMxMGRlNWU4Myk7CiAgICAgICAgICAgIAoKICAgICAgICAgICAgbWFya2VyX2I5ZTQ5NDg1OTJjMjQ3ZjRiYmJiYjU5MjMxZjJhMTNhLmJpbmRQb3B1cChwb3B1cF9jMWRiMzQxMGUzOTY0ZmE4YjQ5MjdmOWFmNmM0N2ZhMCk7CgogICAgICAgICAgICAKICAgICAgICAKICAgIAoKICAgICAgICAgICAgdmFyIG1hcmtlcl9jNjZmYzgxZjViZjk0NjQ4YmJlYTA2MDExMGNhYzA2MiA9IEwubWFya2VyKAogICAgICAgICAgICAgICAgWzQwLjIyMDcwMiwtMTA1LjI2MzQ5XSwKICAgICAgICAgICAgICAgIHsKICAgICAgICAgICAgICAgICAgICBpY29uOiBuZXcgTC5JY29uLkRlZmF1bHQoKQogICAgICAgICAgICAgICAgICAgIH0KICAgICAgICAgICAgICAgICkKICAgICAgICAgICAgICAgIC5hZGRUbyhtYXBfY2ZkZDU4Y2M0ZTFjNDhiYjhhOTFhNGZlYjg2ODc1MmEpOwogICAgICAgICAgICAKICAgIAogICAgICAgICAgICB2YXIgcG9wdXBfYTFjZmIwYWU1M2NmNDNmYjgzZjIwYjNlMWZkNTFlNGQgPSBMLnBvcHVwKHttYXhXaWR0aDogJzMwMCd9KTsKCiAgICAgICAgICAgIAogICAgICAgICAgICAgICAgdmFyIGh0bWxfYzZlMWE4NDBmODhiNDcyYWI5NWRjYzNiYTNkMzM0MDYgPSAkKCc8ZGl2IGlkPSJodG1sX2M2ZTFhODQwZjg4YjQ3MmFiOTVkY2MzYmEzZDMzNDA2IiBzdHlsZT0id2lkdGg6IDEwMC4wJTsgaGVpZ2h0OiAxMDAuMCU7Ij5OYW1lOiBTQUlOVCBWUkFJTiBDUkVFSyBBVCBMWU9OUywgQ08gQW1vdW50OiAyNDUuMDA8L2Rpdj4nKVswXTsKICAgICAgICAgICAgICAgIHBvcHVwX2ExY2ZiMGFlNTNjZjQzZmI4M2YyMGIzZTFmZDUxZTRkLnNldENvbnRlbnQoaHRtbF9jNmUxYTg0MGY4OGI0NzJhYjk1ZGNjM2JhM2QzMzQwNik7CiAgICAgICAgICAgIAoKICAgICAgICAgICAgbWFya2VyX2M2NmZjODFmNWJmOTQ2NDhiYmVhMDYwMTEwY2FjMDYyLmJpbmRQb3B1cChwb3B1cF9hMWNmYjBhZTUzY2Y0M2ZiODNmMjBiM2UxZmQ1MWU0ZCk7CgogICAgICAgICAgICAKICAgICAgICAKICAgIAoKICAgICAgICAgICAgdmFyIG1hcmtlcl9jNDhiN2M2OWZkZTU0NzdkYWI2NjVjMGNjZjc1NDhiOCA9IEwubWFya2VyKAogICAgICAgICAgICAgICAgWzQwLjE1MzM0MSwtMTA1LjA3NTY5NV0sCiAgICAgICAgICAgICAgICB7CiAgICAgICAgICAgICAgICAgICAgaWNvbjogbmV3IEwuSWNvbi5EZWZhdWx0KCkKICAgICAgICAgICAgICAgICAgICB9CiAgICAgICAgICAgICAgICApCiAgICAgICAgICAgICAgICAuYWRkVG8obWFwX2NmZGQ1OGNjNGUxYzQ4YmI4YTkxYTRmZWI4Njg3NTJhKTsKICAgICAgICAgICAgCiAgICAKICAgICAgICAgICAgdmFyIHBvcHVwX2I2N2U5YjgyYjNjYjQwNzM4OWEzZTRmMDk0M2MzYjE4ID0gTC5wb3B1cCh7bWF4V2lkdGg6ICczMDAnfSk7CgogICAgICAgICAgICAKICAgICAgICAgICAgICAgIHZhciBodG1sXzlkY2E5Mjc0ZjVmMTQzYTZhMWRkZjIzZDI1N2Q5ZjZjID0gJCgnPGRpdiBpZD0iaHRtbF85ZGNhOTI3NGY1ZjE0M2E2YTFkZGYyM2QyNTdkOWY2YyIgc3R5bGU9IndpZHRoOiAxMDAuMCU7IGhlaWdodDogMTAwLjAlOyI+TmFtZTogU0FJTlQgVlJBSU4gQ1JFRUsgQkVMT1cgS0VOIFBSQVRUIEJMVkQgQVQgTE9OR01PTlQsIENPIEFtb3VudDogMTEzLjAwPC9kaXY+JylbMF07CiAgICAgICAgICAgICAgICBwb3B1cF9iNjdlOWI4MmIzY2I0MDczODlhM2U0ZjA5NDNjM2IxOC5zZXRDb250ZW50KGh0bWxfOWRjYTkyNzRmNWYxNDNhNmExZGRmMjNkMjU3ZDlmNmMpOwogICAgICAgICAgICAKCiAgICAgICAgICAgIG1hcmtlcl9jNDhiN2M2OWZkZTU0NzdkYWI2NjVjMGNjZjc1NDhiOC5iaW5kUG9wdXAocG9wdXBfYjY3ZTliODJiM2NiNDA3Mzg5YTNlNGYwOTQzYzNiMTgpOwoKICAgICAgICAgICAgCiAgICAgICAgCiAgICAKCiAgICAgICAgICAgIHZhciBtYXJrZXJfNTI5Y2Q5MjgzY2UxNDBjMzhhNTkxOGFjYjllNTY1MTggPSBMLm1hcmtlcigKICAgICAgICAgICAgICAgIFs0MC4yMTgzMzUsLTEwNS4yNTgxMV0sCiAgICAgICAgICAgICAgICB7CiAgICAgICAgICAgICAgICAgICAgaWNvbjogbmV3IEwuSWNvbi5EZWZhdWx0KCkKICAgICAgICAgICAgICAgICAgICB9CiAgICAgICAgICAgICAgICApCiAgICAgICAgICAgICAgICAuYWRkVG8obWFwX2NmZGQ1OGNjNGUxYzQ4YmI4YTkxYTRmZWI4Njg3NTJhKTsKICAgICAgICAgICAgCiAgICAKICAgICAgICAgICAgdmFyIHBvcHVwXzdiMzRmZDA4ZjAwZjQ4Nzg5ZTVkM2NhMzcyNzYxMzE5ID0gTC5wb3B1cCh7bWF4V2lkdGg6ICczMDAnfSk7CgogICAgICAgICAgICAKICAgICAgICAgICAgICAgIHZhciBodG1sXzg0Y2M0ZGUwNGM4MzRkMDliYzg2ZWY0NjM5NDM1Y2NkID0gJCgnPGRpdiBpZD0iaHRtbF84NGNjNGRlMDRjODM0ZDA5YmM4NmVmNDYzOTQzNWNjZCIgc3R5bGU9IndpZHRoOiAxMDAuMCU7IGhlaWdodDogMTAwLjAlOyI+TmFtZTogU0FJTlQgVlJBSU4gU1VQUExZIENBTkFMIE5FQVIgTFlPTlMsIENPIEFtb3VudDogNTguNTA8L2Rpdj4nKVswXTsKICAgICAgICAgICAgICAgIHBvcHVwXzdiMzRmZDA4ZjAwZjQ4Nzg5ZTVkM2NhMzcyNzYxMzE5LnNldENvbnRlbnQoaHRtbF84NGNjNGRlMDRjODM0ZDA5YmM4NmVmNDYzOTQzNWNjZCk7CiAgICAgICAgICAgIAoKICAgICAgICAgICAgbWFya2VyXzUyOWNkOTI4M2NlMTQwYzM4YTU5MThhY2I5ZTU2NTE4LmJpbmRQb3B1cChwb3B1cF83YjM0ZmQwOGYwMGY0ODc4OWU1ZDNjYTM3Mjc2MTMxOSk7CgogICAgICAgICAgICAKICAgICAgICAKICAgIAoKICAgICAgICAgICAgdmFyIG1hcmtlcl8wOGQ1ZDQwY2MwNmE0YmMyYTI2YmYzZDYzYTc0ZTJiYSA9IEwubWFya2VyKAogICAgICAgICAgICAgICAgWzQwLjIxMTM4OSwtMTA1LjI1MDk1Ml0sCiAgICAgICAgICAgICAgICB7CiAgICAgICAgICAgICAgICAgICAgaWNvbjogbmV3IEwuSWNvbi5EZWZhdWx0KCkKICAgICAgICAgICAgICAgICAgICB9CiAgICAgICAgICAgICAgICApCiAgICAgICAgICAgICAgICAuYWRkVG8obWFwX2NmZGQ1OGNjNGUxYzQ4YmI4YTkxYTRmZWI4Njg3NTJhKTsKICAgICAgICAgICAgCiAgICAKICAgICAgICAgICAgdmFyIHBvcHVwXzQ3ZTZlNDY4ODA4MzQ5ZWI5YTQ1ZGU4MzM3MmQwZWJmID0gTC5wb3B1cCh7bWF4V2lkdGg6ICczMDAnfSk7CgogICAgICAgICAgICAKICAgICAgICAgICAgICAgIHZhciBodG1sX2EwMGZjNzg4NDczYjQxYjFiZDk1ODk5M2NjYjliZDZjID0gJCgnPGRpdiBpZD0iaHRtbF9hMDBmYzc4ODQ3M2I0MWIxYmQ5NTg5OTNjY2I5YmQ2YyIgc3R5bGU9IndpZHRoOiAxMDAuMCU7IGhlaWdodDogMTAwLjAlOyI+TmFtZTogU01FQUQgRElUQ0ggQW1vdW50OiAxLjg4PC9kaXY+JylbMF07CiAgICAgICAgICAgICAgICBwb3B1cF80N2U2ZTQ2ODgwODM0OWViOWE0NWRlODMzNzJkMGViZi5zZXRDb250ZW50KGh0bWxfYTAwZmM3ODg0NzNiNDFiMWJkOTU4OTkzY2NiOWJkNmMpOwogICAgICAgICAgICAKCiAgICAgICAgICAgIG1hcmtlcl8wOGQ1ZDQwY2MwNmE0YmMyYTI2YmYzZDYzYTc0ZTJiYS5iaW5kUG9wdXAocG9wdXBfNDdlNmU0Njg4MDgzNDllYjlhNDVkZTgzMzcyZDBlYmYpOwoKICAgICAgICAgICAgCiAgICAgICAgCiAgICAKCiAgICAgICAgICAgIHZhciBtYXJrZXJfZTcyMGUyNTA3ZDBlNDU1Mjk0NTE0OWQwY2VjZjNiMzIgPSBMLm1hcmtlcigKICAgICAgICAgICAgICAgIFs0MC4xNzA5OTgsLTEwNS4xNjA4NzZdLAogICAgICAgICAgICAgICAgewogICAgICAgICAgICAgICAgICAgIGljb246IG5ldyBMLkljb24uRGVmYXVsdCgpCiAgICAgICAgICAgICAgICAgICAgfQogICAgICAgICAgICAgICAgKQogICAgICAgICAgICAgICAgLmFkZFRvKG1hcF9jZmRkNThjYzRlMWM0OGJiOGE5MWE0ZmViODY4NzUyYSk7CiAgICAgICAgICAgIAogICAgCiAgICAgICAgICAgIHZhciBwb3B1cF81ZDRiNGM2ZjNlMTE0NGQ4OTU4ZmFjOTU2Yzc1ZDQ0MCA9IEwucG9wdXAoe21heFdpZHRoOiAnMzAwJ30pOwoKICAgICAgICAgICAgCiAgICAgICAgICAgICAgICB2YXIgaHRtbF9jYzAxOTQ5N2NkMmM0MGMzOWE2YWUyNjA4N2VmZjIzNCA9ICQoJzxkaXYgaWQ9Imh0bWxfY2MwMTk0OTdjZDJjNDBjMzlhNmFlMjYwODdlZmYyMzQiIHN0eWxlPSJ3aWR0aDogMTAwLjAlOyBoZWlnaHQ6IDEwMC4wJTsiPk5hbWU6IFNPVVRIIEZMQVQgRElUQ0ggQW1vdW50OiAyLjExPC9kaXY+JylbMF07CiAgICAgICAgICAgICAgICBwb3B1cF81ZDRiNGM2ZjNlMTE0NGQ4OTU4ZmFjOTU2Yzc1ZDQ0MC5zZXRDb250ZW50KGh0bWxfY2MwMTk0OTdjZDJjNDBjMzlhNmFlMjYwODdlZmYyMzQpOwogICAgICAgICAgICAKCiAgICAgICAgICAgIG1hcmtlcl9lNzIwZTI1MDdkMGU0NTUyOTQ1MTQ5ZDBjZWNmM2IzMi5iaW5kUG9wdXAocG9wdXBfNWQ0YjRjNmYzZTExNDRkODk1OGZhYzk1NmM3NWQ0NDApOwoKICAgICAgICAgICAgCiAgICAgICAgCiAgICAKCiAgICAgICAgICAgIHZhciBtYXJrZXJfOTc1ZjdlNmJlZTQ3NGQ4OWIyMTVhZGY0MjA5Yjc4ZjcgPSBMLm1hcmtlcigKICAgICAgICAgICAgICAgIFs0MC4wOTA4MiwtMTA1LjUxNDQ0Ml0sCiAgICAgICAgICAgICAgICB7CiAgICAgICAgICAgICAgICAgICAgaWNvbjogbmV3IEwuSWNvbi5EZWZhdWx0KCkKICAgICAgICAgICAgICAgICAgICB9CiAgICAgICAgICAgICAgICApCiAgICAgICAgICAgICAgICAuYWRkVG8obWFwX2NmZGQ1OGNjNGUxYzQ4YmI4YTkxYTRmZWI4Njg3NTJhKTsKICAgICAgICAgICAgCiAgICAKICAgICAgICAgICAgdmFyIHBvcHVwX2RlZTAxYmIzN2QzYzQ4NWNiYTM3YjdiY2EyZWNmZDk4ID0gTC5wb3B1cCh7bWF4V2lkdGg6ICczMDAnfSk7CgogICAgICAgICAgICAKICAgICAgICAgICAgICAgIHZhciBodG1sXzJlYWMyODljNDY5YjQ3ZDg4ODgwOGM4M2JlYWY5YTY5ID0gJCgnPGRpdiBpZD0iaHRtbF8yZWFjMjg5YzQ2OWI0N2Q4ODg4MDhjODNiZWFmOWE2OSIgc3R5bGU9IndpZHRoOiAxMDAuMCU7IGhlaWdodDogMTAwLjAlOyI+TmFtZTogU09VVEggU0FJTlQgVlJBSU4gTkVBUiBXQVJEIEFtb3VudDogNTguMTA8L2Rpdj4nKVswXTsKICAgICAgICAgICAgICAgIHBvcHVwX2RlZTAxYmIzN2QzYzQ4NWNiYTM3YjdiY2EyZWNmZDk4LnNldENvbnRlbnQoaHRtbF8yZWFjMjg5YzQ2OWI0N2Q4ODg4MDhjODNiZWFmOWE2OSk7CiAgICAgICAgICAgIAoKICAgICAgICAgICAgbWFya2VyXzk3NWY3ZTZiZWU0NzRkODliMjE1YWRmNDIwOWI3OGY3LmJpbmRQb3B1cChwb3B1cF9kZWUwMWJiMzdkM2M0ODVjYmEzN2I3YmNhMmVjZmQ5OCk7CgogICAgICAgICAgICAKICAgICAgICAKICAgIAoKICAgICAgICAgICAgdmFyIG1hcmtlcl9mYjc3NjQzMzAwODM0OTA4YjhlNTFjNjRjNDNiMWVjZSA9IEwubWFya2VyKAogICAgICAgICAgICAgICAgWzQwLjIxOTA0NiwtMTA1LjI1OTc5NV0sCiAgICAgICAgICAgICAgICB7CiAgICAgICAgICAgICAgICAgICAgaWNvbjogbmV3IEwuSWNvbi5EZWZhdWx0KCkKICAgICAgICAgICAgICAgICAgICB9CiAgICAgICAgICAgICAgICApCiAgICAgICAgICAgICAgICAuYWRkVG8obWFwX2NmZGQ1OGNjNGUxYzQ4YmI4YTkxYTRmZWI4Njg3NTJhKTsKICAgICAgICAgICAgCiAgICAKICAgICAgICAgICAgdmFyIHBvcHVwXzg3N2UzNjcwNzIzYzRkZjBiYjIxZGNjYzVmMTU5MTJjID0gTC5wb3B1cCh7bWF4V2lkdGg6ICczMDAnfSk7CgogICAgICAgICAgICAKICAgICAgICAgICAgICAgIHZhciBodG1sX2NkMjY0MTQyMzI0YTQ5MmJiNGNiYjc1YzYzN2ExYjMxID0gJCgnPGRpdiBpZD0iaHRtbF9jZDI2NDE0MjMyNGE0OTJiYjRjYmI3NWM2MzdhMWIzMSIgc3R5bGU9IndpZHRoOiAxMDAuMCU7IGhlaWdodDogMTAwLjAlOyI+TmFtZTogU1VQUExZIERJVENIIEFtb3VudDogMTguODA8L2Rpdj4nKVswXTsKICAgICAgICAgICAgICAgIHBvcHVwXzg3N2UzNjcwNzIzYzRkZjBiYjIxZGNjYzVmMTU5MTJjLnNldENvbnRlbnQoaHRtbF9jZDI2NDE0MjMyNGE0OTJiYjRjYmI3NWM2MzdhMWIzMSk7CiAgICAgICAgICAgIAoKICAgICAgICAgICAgbWFya2VyX2ZiNzc2NDMzMDA4MzQ5MDhiOGU1MWM2NGM0M2IxZWNlLmJpbmRQb3B1cChwb3B1cF84NzdlMzY3MDcyM2M0ZGYwYmIyMWRjY2M1ZjE1OTEyYyk7CgogICAgICAgICAgICAKICAgICAgICAKICAgIAoKICAgICAgICAgICAgdmFyIG1hcmtlcl8wMTEwOGUxMzY0MGQ0YjhlOTU0YzYwMDc4Y2Y3NmJkNSA9IEwubWFya2VyKAogICAgICAgICAgICAgICAgWzQwLjIxMTA4MywtMTA1LjI1MDkyN10sCiAgICAgICAgICAgICAgICB7CiAgICAgICAgICAgICAgICAgICAgaWNvbjogbmV3IEwuSWNvbi5EZWZhdWx0KCkKICAgICAgICAgICAgICAgICAgICB9CiAgICAgICAgICAgICAgICApCiAgICAgICAgICAgICAgICAuYWRkVG8obWFwX2NmZGQ1OGNjNGUxYzQ4YmI4YTkxYTRmZWI4Njg3NTJhKTsKICAgICAgICAgICAgCiAgICAKICAgICAgICAgICAgdmFyIHBvcHVwXzEzMmMxMjc0NjE4ODQ0OGY5MGQ1NzU3OTFkMWQ3NzczID0gTC5wb3B1cCh7bWF4V2lkdGg6ICczMDAnfSk7CgogICAgICAgICAgICAKICAgICAgICAgICAgICAgIHZhciBodG1sXzI3NjhlNjNmZjliNTQxOTg5MzkwMzZlNThkMGZiNDU2ID0gJCgnPGRpdiBpZD0iaHRtbF8yNzY4ZTYzZmY5YjU0MTk4OTM5MDM2ZTU4ZDBmYjQ1NiIgc3R5bGU9IndpZHRoOiAxMDAuMCU7IGhlaWdodDogMTAwLjAlOyI+TmFtZTogU1dFREUgRElUQ0ggQW1vdW50OiAyNS4zOTwvZGl2PicpWzBdOwogICAgICAgICAgICAgICAgcG9wdXBfMTMyYzEyNzQ2MTg4NDQ4ZjkwZDU3NTc5MWQxZDc3NzMuc2V0Q29udGVudChodG1sXzI3NjhlNjNmZjliNTQxOTg5MzkwMzZlNThkMGZiNDU2KTsKICAgICAgICAgICAgCgogICAgICAgICAgICBtYXJrZXJfMDExMDhlMTM2NDBkNGI4ZTk1NGM2MDA3OGNmNzZiZDUuYmluZFBvcHVwKHBvcHVwXzEzMmMxMjc0NjE4ODQ0OGY5MGQ1NzU3OTFkMWQ3NzczKTsKCiAgICAgICAgICAgIAogICAgICAgIAogICAgCgogICAgICAgICAgICB2YXIgbWFya2VyX2RjNzQ1NzlkNjBmNzQ0YjNiNTk0ZDAyODBmZjc4MGU1ID0gTC5tYXJrZXIoCiAgICAgICAgICAgICAgICBbNDAuMTkzMDE5LC0xMDUuMjEwMzg4XSwKICAgICAgICAgICAgICAgIHsKICAgICAgICAgICAgICAgICAgICBpY29uOiBuZXcgTC5JY29uLkRlZmF1bHQoKQogICAgICAgICAgICAgICAgICAgIH0KICAgICAgICAgICAgICAgICkKICAgICAgICAgICAgICAgIC5hZGRUbyhtYXBfY2ZkZDU4Y2M0ZTFjNDhiYjhhOTFhNGZlYjg2ODc1MmEpOwogICAgICAgICAgICAKICAgIAogICAgICAgICAgICB2YXIgcG9wdXBfYzY5NGIwZmI1ZjhiNDY4MDgxMjRjMmU0YjAzZTg1ZTggPSBMLnBvcHVwKHttYXhXaWR0aDogJzMwMCd9KTsKCiAgICAgICAgICAgIAogICAgICAgICAgICAgICAgdmFyIGh0bWxfNDY5ZTQ0MTc1OGVjNGI5Y2I2ODMwM2YyNTRiN2IxYTIgPSAkKCc8ZGl2IGlkPSJodG1sXzQ2OWU0NDE3NThlYzRiOWNiNjgzMDNmMjU0YjdiMWEyIiBzdHlsZT0id2lkdGg6IDEwMC4wJTsgaGVpZ2h0OiAxMDAuMCU7Ij5OYW1lOiBUUlVFIEFORCBXRUJTVEVSIERJVENIIEFtb3VudDogMC4wNDwvZGl2PicpWzBdOwogICAgICAgICAgICAgICAgcG9wdXBfYzY5NGIwZmI1ZjhiNDY4MDgxMjRjMmU0YjAzZTg1ZTguc2V0Q29udGVudChodG1sXzQ2OWU0NDE3NThlYzRiOWNiNjgzMDNmMjU0YjdiMWEyKTsKICAgICAgICAgICAgCgogICAgICAgICAgICBtYXJrZXJfZGM3NDU3OWQ2MGY3NDRiM2I1OTRkMDI4MGZmNzgwZTUuYmluZFBvcHVwKHBvcHVwX2M2OTRiMGZiNWY4YjQ2ODA4MTI0YzJlNGIwM2U4NWU4KTsKCiAgICAgICAgICAgIAogICAgICAgIAogICAgCgogICAgICAgICAgICB2YXIgbWFya2VyXzlmYmI0ODQ3MWJlYjQ0NzdiYjk1YjhlNjk4ZjcwMzZmID0gTC5tYXJrZXIoCiAgICAgICAgICAgICAgICBbNDAuMTkzMjgsLTEwNS4yMTA0MjRdLAogICAgICAgICAgICAgICAgewogICAgICAgICAgICAgICAgICAgIGljb246IG5ldyBMLkljb24uRGVmYXVsdCgpCiAgICAgICAgICAgICAgICAgICAgfQogICAgICAgICAgICAgICAgKQogICAgICAgICAgICAgICAgLmFkZFRvKG1hcF9jZmRkNThjYzRlMWM0OGJiOGE5MWE0ZmViODY4NzUyYSk7CiAgICAgICAgICAgIAogICAgCiAgICAgICAgICAgIHZhciBwb3B1cF9jZGJkZjhiZmZhZWU0OGU4OWNhOWZhMTAzNzg1NTYxMyA9IEwucG9wdXAoe21heFdpZHRoOiAnMzAwJ30pOwoKICAgICAgICAgICAgCiAgICAgICAgICAgICAgICB2YXIgaHRtbF80MjM5NTE3NDE5YmE0NTA1YWYxNDFmZTFkMDE0NGVlNSA9ICQoJzxkaXYgaWQ9Imh0bWxfNDIzOTUxNzQxOWJhNDUwNWFmMTQxZmUxZDAxNDRlZTUiIHN0eWxlPSJ3aWR0aDogMTAwLjAlOyBoZWlnaHQ6IDEwMC4wJTsiPk5hbWU6IFdFQlNURVIgTUNDQVNMSU4gRElUQ0ggQW1vdW50OiA1LjI4PC9kaXY+JylbMF07CiAgICAgICAgICAgICAgICBwb3B1cF9jZGJkZjhiZmZhZWU0OGU4OWNhOWZhMTAzNzg1NTYxMy5zZXRDb250ZW50KGh0bWxfNDIzOTUxNzQxOWJhNDUwNWFmMTQxZmUxZDAxNDRlZTUpOwogICAgICAgICAgICAKCiAgICAgICAgICAgIG1hcmtlcl85ZmJiNDg0NzFiZWI0NDc3YmI5NWI4ZTY5OGY3MDM2Zi5iaW5kUG9wdXAocG9wdXBfY2RiZGY4YmZmYWVlNDhlODljYTlmYTEwMzc4NTU2MTMpOwoKICAgICAgICAgICAgCiAgICAgICAgCiAgICAKCiAgICAgICAgICAgIHZhciBtYXJrZXJfMTc0ZDZjYWY1NDEwNGM2Y2I3ODlmZDVlMzQ5NDMwNmMgPSBMLm1hcmtlcigKICAgICAgICAgICAgICAgIFs0MC4xODUwMzMsLTEwNS4xODU3ODldLAogICAgICAgICAgICAgICAgewogICAgICAgICAgICAgICAgICAgIGljb246IG5ldyBMLkljb24uRGVmYXVsdCgpCiAgICAgICAgICAgICAgICAgICAgfQogICAgICAgICAgICAgICAgKQogICAgICAgICAgICAgICAgLmFkZFRvKG1hcF9jZmRkNThjYzRlMWM0OGJiOGE5MWE0ZmViODY4NzUyYSk7CiAgICAgICAgICAgIAogICAgCiAgICAgICAgICAgIHZhciBwb3B1cF80N2NhZjgyOGViN2I0OWM0OWQyY2QzOGY3NWFhNjNlMiA9IEwucG9wdXAoe21heFdpZHRoOiAnMzAwJ30pOwoKICAgICAgICAgICAgCiAgICAgICAgICAgICAgICB2YXIgaHRtbF9lNTRhYjM0YTk0NWM0YmQ3YjUyZTY5YjVlMzllYjliYSA9ICQoJzxkaXYgaWQ9Imh0bWxfZTU0YWIzNGE5NDVjNGJkN2I1MmU2OWI1ZTM5ZWI5YmEiIHN0eWxlPSJ3aWR0aDogMTAwLjAlOyBoZWlnaHQ6IDEwMC4wJTsiPk5hbWU6IFpXRUNLIEFORCBUVVJORVIgRElUQ0ggQW1vdW50OiA3LjM0PC9kaXY+JylbMF07CiAgICAgICAgICAgICAgICBwb3B1cF80N2NhZjgyOGViN2I0OWM0OWQyY2QzOGY3NWFhNjNlMi5zZXRDb250ZW50KGh0bWxfZTU0YWIzNGE5NDVjNGJkN2I1MmU2OWI1ZTM5ZWI5YmEpOwogICAgICAgICAgICAKCiAgICAgICAgICAgIG1hcmtlcl8xNzRkNmNhZjU0MTA0YzZjYjc4OWZkNWUzNDk0MzA2Yy5iaW5kUG9wdXAocG9wdXBfNDdjYWY4MjhlYjdiNDljNDlkMmNkMzhmNzVhYTYzZTIpOwoKICAgICAgICAgICAgCiAgICAgICAgCiAgICAKCiAgICAgICAgICAgIHZhciBtYXJrZXJfN2RkNDFhNzdiZDViNDMxYzljZTM1MGZiYTk0OGI3MjkgPSBMLm1hcmtlcigKICAgICAgICAgICAgICAgIFs0MC4wNTk4MDksLTEwNS4wOTc4NzJdLAogICAgICAgICAgICAgICAgewogICAgICAgICAgICAgICAgICAgIGljb246IG5ldyBMLkljb24uRGVmYXVsdCgpCiAgICAgICAgICAgICAgICAgICAgfQogICAgICAgICAgICAgICAgKQogICAgICAgICAgICAgICAgLmFkZFRvKG1hcF9jZmRkNThjYzRlMWM0OGJiOGE5MWE0ZmViODY4NzUyYSk7CiAgICAgICAgICAgIAogICAgCiAgICAgICAgICAgIHZhciBwb3B1cF81MzAxODRkNzI2YjA0YWMwOGVlNzNmZmM0ZmQ3ZjY5YSA9IEwucG9wdXAoe21heFdpZHRoOiAnMzAwJ30pOwoKICAgICAgICAgICAgCiAgICAgICAgICAgICAgICB2YXIgaHRtbF8yYzJmMzZjZjZhNzc0MzA1YTU2NjUwOWIzYWFiNGVkMiA9ICQoJzxkaXYgaWQ9Imh0bWxfMmMyZjM2Y2Y2YTc3NDMwNWE1NjY1MDliM2FhYjRlZDIiIHN0eWxlPSJ3aWR0aDogMTAwLjAlOyBoZWlnaHQ6IDEwMC4wJTsiPk5hbWU6IEJPVUxERVIgQ1JFRUsgQVQgMTA5IFNUIE5FQVIgRVJJRSwgQ08gQW1vdW50OiA1MC4yMDwvZGl2PicpWzBdOwogICAgICAgICAgICAgICAgcG9wdXBfNTMwMTg0ZDcyNmIwNGFjMDhlZTczZmZjNGZkN2Y2OWEuc2V0Q29udGVudChodG1sXzJjMmYzNmNmNmE3NzQzMDVhNTY2NTA5YjNhYWI0ZWQyKTsKICAgICAgICAgICAgCgogICAgICAgICAgICBtYXJrZXJfN2RkNDFhNzdiZDViNDMxYzljZTM1MGZiYTk0OGI3MjkuYmluZFBvcHVwKHBvcHVwXzUzMDE4NGQ3MjZiMDRhYzA4ZWU3M2ZmYzRmZDdmNjlhKTsKCiAgICAgICAgICAgIAogICAgICAgIAogICAgCgogICAgICAgICAgICB2YXIgbWFya2VyX2VjYmU0YzBmZmVlYzRkNjU4MTg0NTllNDA2ZjRmMGUxID0gTC5tYXJrZXIoCiAgICAgICAgICAgICAgICBbNDAuMDUxNjUyLC0xMDUuMTc4ODc1XSwKICAgICAgICAgICAgICAgIHsKICAgICAgICAgICAgICAgICAgICBpY29uOiBuZXcgTC5JY29uLkRlZmF1bHQoKQogICAgICAgICAgICAgICAgICAgIH0KICAgICAgICAgICAgICAgICkKICAgICAgICAgICAgICAgIC5hZGRUbyhtYXBfY2ZkZDU4Y2M0ZTFjNDhiYjhhOTFhNGZlYjg2ODc1MmEpOwogICAgICAgICAgICAKICAgIAogICAgICAgICAgICB2YXIgcG9wdXBfMTdiYTI2MTUzMWZjNDNiY2JjZDkzNWJlNmYyNDYzYTEgPSBMLnBvcHVwKHttYXhXaWR0aDogJzMwMCd9KTsKCiAgICAgICAgICAgIAogICAgICAgICAgICAgICAgdmFyIGh0bWxfNWQyMGVmNDM5YTNhNGYwZTk3ZjEwNzg4ZGQzNmVhZjUgPSAkKCc8ZGl2IGlkPSJodG1sXzVkMjBlZjQzOWEzYTRmMGU5N2YxMDc4OGRkMzZlYWY1IiBzdHlsZT0id2lkdGg6IDEwMC4wJTsgaGVpZ2h0OiAxMDAuMCU7Ij5OYW1lOiBCT1VMREVSIENSRUVLIEFUIE5PUlRIIDc1VEggU1RSRUVUIE5FQVIgQk9VTERFUiBBbW91bnQ6IDEyOC4wMDwvZGl2PicpWzBdOwogICAgICAgICAgICAgICAgcG9wdXBfMTdiYTI2MTUzMWZjNDNiY2JjZDkzNWJlNmYyNDYzYTEuc2V0Q29udGVudChodG1sXzVkMjBlZjQzOWEzYTRmMGU5N2YxMDc4OGRkMzZlYWY1KTsKICAgICAgICAgICAgCgogICAgICAgICAgICBtYXJrZXJfZWNiZTRjMGZmZWVjNGQ2NTgxODQ1OWU0MDZmNGYwZTEuYmluZFBvcHVwKHBvcHVwXzE3YmEyNjE1MzFmYzQzYmNiY2Q5MzViZTZmMjQ2M2ExKTsKCiAgICAgICAgICAgIAogICAgICAgIAogICAgCgogICAgICAgICAgICB2YXIgbWFya2VyXzMzZjhjZTM1YTllMDRlOTliNTBkNDMwYmZhMjczNzY5ID0gTC5tYXJrZXIoCiAgICAgICAgICAgICAgICBbNDAuMDUzMDM1LC0xMDUuMTkzMDQ4XSwKICAgICAgICAgICAgICAgIHsKICAgICAgICAgICAgICAgICAgICBpY29uOiBuZXcgTC5JY29uLkRlZmF1bHQoKQogICAgICAgICAgICAgICAgICAgIH0KICAgICAgICAgICAgICAgICkKICAgICAgICAgICAgICAgIC5hZGRUbyhtYXBfY2ZkZDU4Y2M0ZTFjNDhiYjhhOTFhNGZlYjg2ODc1MmEpOwogICAgICAgICAgICAKICAgIAogICAgICAgICAgICB2YXIgcG9wdXBfZGExMWVhMzcxNDdjNDY2Nzk5MjY5ZDAyMmEzZjZiN2EgPSBMLnBvcHVwKHttYXhXaWR0aDogJzMwMCd9KTsKCiAgICAgICAgICAgIAogICAgICAgICAgICAgICAgdmFyIGh0bWxfM2EyMDFhMjk5OTRkNDMyNWE3ZjNkMTk5ZmJhZmNkMmYgPSAkKCc8ZGl2IGlkPSJodG1sXzNhMjAxYTI5OTk0ZDQzMjVhN2YzZDE5OWZiYWZjZDJmIiBzdHlsZT0id2lkdGg6IDEwMC4wJTsgaGVpZ2h0OiAxMDAuMCU7Ij5OYW1lOiBCT1VMREVSIENSRUVLIFNVUFBMWSBDQU5BTCBUTyBCT1VMREVSIENSRUVLIE5FQVIgQk9VTERFUiBBbW91bnQ6IDMuODE8L2Rpdj4nKVswXTsKICAgICAgICAgICAgICAgIHBvcHVwX2RhMTFlYTM3MTQ3YzQ2Njc5OTI2OWQwMjJhM2Y2YjdhLnNldENvbnRlbnQoaHRtbF8zYTIwMWEyOTk5NGQ0MzI1YTdmM2QxOTlmYmFmY2QyZik7CiAgICAgICAgICAgIAoKICAgICAgICAgICAgbWFya2VyXzMzZjhjZTM1YTllMDRlOTliNTBkNDMwYmZhMjczNzY5LmJpbmRQb3B1cChwb3B1cF9kYTExZWEzNzE0N2M0NjY3OTkyNjlkMDIyYTNmNmI3YSk7CgogICAgICAgICAgICAKICAgICAgICAKICAgIAoKICAgICAgICAgICAgdmFyIG1hcmtlcl9mMDNlNTdkYWU5ODg0YmEzOTU5OTdhMjJhNmRjOWFlNiA9IEwubWFya2VyKAogICAgICAgICAgICAgICAgWzQwLjA3ODU2LC0xMDUuMjIwNDk3XSwKICAgICAgICAgICAgICAgIHsKICAgICAgICAgICAgICAgICAgICBpY29uOiBuZXcgTC5JY29uLkRlZmF1bHQoKQogICAgICAgICAgICAgICAgICAgIH0KICAgICAgICAgICAgICAgICkKICAgICAgICAgICAgICAgIC5hZGRUbyhtYXBfY2ZkZDU4Y2M0ZTFjNDhiYjhhOTFhNGZlYjg2ODc1MmEpOwogICAgICAgICAgICAKICAgIAogICAgICAgICAgICB2YXIgcG9wdXBfMzAxZWY0Y2JkNjFiNGQzNzk0YTY4ODEwOWE1NzI2OTkgPSBMLnBvcHVwKHttYXhXaWR0aDogJzMwMCd9KTsKCiAgICAgICAgICAgIAogICAgICAgICAgICAgICAgdmFyIGh0bWxfMWU0Yzk1ZmNhNTUyNGM4ZWEwYzk2M2FmMGU4ODA4YjIgPSAkKCc8ZGl2IGlkPSJodG1sXzFlNGM5NWZjYTU1MjRjOGVhMGM5NjNhZjBlODgwOGIyIiBzdHlsZT0id2lkdGg6IDEwMC4wJTsgaGVpZ2h0OiAxMDAuMCU7Ij5OYW1lOiBCT1VMREVSIFJFU0VSVk9JUiBBbW91bnQ6IDc0MDMuMDA8L2Rpdj4nKVswXTsKICAgICAgICAgICAgICAgIHBvcHVwXzMwMWVmNGNiZDYxYjRkMzc5NGE2ODgxMDlhNTcyNjk5LnNldENvbnRlbnQoaHRtbF8xZTRjOTVmY2E1NTI0YzhlYTBjOTYzYWYwZTg4MDhiMik7CiAgICAgICAgICAgIAoKICAgICAgICAgICAgbWFya2VyX2YwM2U1N2RhZTk4ODRiYTM5NTk5N2EyMmE2ZGM5YWU2LmJpbmRQb3B1cChwb3B1cF8zMDFlZjRjYmQ2MWI0ZDM3OTRhNjg4MTA5YTU3MjY5OSk7CgogICAgICAgICAgICAKICAgICAgICAKICAgIAoKICAgICAgICAgICAgdmFyIG1hcmtlcl80ZWY2ZWJkMmJjOTg0NGVhYmFlYjcwMDIzNTcxMmJhNSA9IEwubWFya2VyKAogICAgICAgICAgICAgICAgWzQwLjA4NjI3OCwtMTA1LjIxNzUxOV0sCiAgICAgICAgICAgICAgICB7CiAgICAgICAgICAgICAgICAgICAgaWNvbjogbmV3IEwuSWNvbi5EZWZhdWx0KCkKICAgICAgICAgICAgICAgICAgICB9CiAgICAgICAgICAgICAgICApCiAgICAgICAgICAgICAgICAuYWRkVG8obWFwX2NmZGQ1OGNjNGUxYzQ4YmI4YTkxYTRmZWI4Njg3NTJhKTsKICAgICAgICAgICAgCiAgICAKICAgICAgICAgICAgdmFyIHBvcHVwXzlkNzk3NWRjNmIwMzRhOWU5YWU4MDUyMmE2ODRlODE5ID0gTC5wb3B1cCh7bWF4V2lkdGg6ICczMDAnfSk7CgogICAgICAgICAgICAKICAgICAgICAgICAgICAgIHZhciBodG1sXzI1NmMyNjk1ZGRmNjQ3M2Q4NmU2YzU5ODQ4NzkwNWQ4ID0gJCgnPGRpdiBpZD0iaHRtbF8yNTZjMjY5NWRkZjY0NzNkODZlNmM1OTg0ODc5MDVkOCIgc3R5bGU9IndpZHRoOiAxMDAuMCU7IGhlaWdodDogMTAwLjAlOyI+TmFtZTogQk9VTERFUiBSRVNFUlZPSVIgSU5MRVQgQW1vdW50OiAzMi4wMDwvZGl2PicpWzBdOwogICAgICAgICAgICAgICAgcG9wdXBfOWQ3OTc1ZGM2YjAzNGE5ZTlhZTgwNTIyYTY4NGU4MTkuc2V0Q29udGVudChodG1sXzI1NmMyNjk1ZGRmNjQ3M2Q4NmU2YzU5ODQ4NzkwNWQ4KTsKICAgICAgICAgICAgCgogICAgICAgICAgICBtYXJrZXJfNGVmNmViZDJiYzk4NDRlYWJhZWI3MDAyMzU3MTJiYTUuYmluZFBvcHVwKHBvcHVwXzlkNzk3NWRjNmIwMzRhOWU5YWU4MDUyMmE2ODRlODE5KTsKCiAgICAgICAgICAgIAogICAgICAgIAogICAgCgogICAgICAgICAgICB2YXIgbWFya2VyX2Q5YTMyOTkyNWZhNzRjY2ViYThiYzQxNmU2Y2FiMmYxID0gTC5tYXJrZXIoCiAgICAgICAgICAgICAgICBbMzkuOTg2MTY5LC0xMDUuMjE4Njc3XSwKICAgICAgICAgICAgICAgIHsKICAgICAgICAgICAgICAgICAgICBpY29uOiBuZXcgTC5JY29uLkRlZmF1bHQoKQogICAgICAgICAgICAgICAgICAgIH0KICAgICAgICAgICAgICAgICkKICAgICAgICAgICAgICAgIC5hZGRUbyhtYXBfY2ZkZDU4Y2M0ZTFjNDhiYjhhOTFhNGZlYjg2ODc1MmEpOwogICAgICAgICAgICAKICAgIAogICAgICAgICAgICB2YXIgcG9wdXBfNWU2ZTcyODkyYWNmNDZkMGI2NTQ4MmNiZjc1YzBmMjIgPSBMLnBvcHVwKHttYXhXaWR0aDogJzMwMCd9KTsKCiAgICAgICAgICAgIAogICAgICAgICAgICAgICAgdmFyIGh0bWxfZDZlYzQzNTY0ZjIxNDA5NWEyNmQzODZkNTkyNjA0ZjAgPSAkKCc8ZGl2IGlkPSJodG1sX2Q2ZWM0MzU2NGYyMTQwOTVhMjZkMzg2ZDU5MjYwNGYwIiBzdHlsZT0id2lkdGg6IDEwMC4wJTsgaGVpZ2h0OiAxMDAuMCU7Ij5OYW1lOiBEUlkgQ1JFRUsgQ0FSUklFUiBBbW91bnQ6IDE0LjI2PC9kaXY+JylbMF07CiAgICAgICAgICAgICAgICBwb3B1cF81ZTZlNzI4OTJhY2Y0NmQwYjY1NDgyY2JmNzVjMGYyMi5zZXRDb250ZW50KGh0bWxfZDZlYzQzNTY0ZjIxNDA5NWEyNmQzODZkNTkyNjA0ZjApOwogICAgICAgICAgICAKCiAgICAgICAgICAgIG1hcmtlcl9kOWEzMjk5MjVmYTc0Y2NlYmE4YmM0MTZlNmNhYjJmMS5iaW5kUG9wdXAocG9wdXBfNWU2ZTcyODkyYWNmNDZkMGI2NTQ4MmNiZjc1YzBmMjIpOwoKICAgICAgICAgICAgCiAgICAgICAgCiAgICAKCiAgICAgICAgICAgIHZhciBtYXJrZXJfYWUxNTRlMGE4YjZkNGZjOTk3MTBlNmE5MWU0Zjk0MzkgPSBMLm1hcmtlcigKICAgICAgICAgICAgICAgIFs0MC4wNDIwMjgsLTEwNS4zNjQ5MTddLAogICAgICAgICAgICAgICAgewogICAgICAgICAgICAgICAgICAgIGljb246IG5ldyBMLkljb24uRGVmYXVsdCgpCiAgICAgICAgICAgICAgICAgICAgfQogICAgICAgICAgICAgICAgKQogICAgICAgICAgICAgICAgLmFkZFRvKG1hcF9jZmRkNThjYzRlMWM0OGJiOGE5MWE0ZmViODY4NzUyYSk7CiAgICAgICAgICAgIAogICAgCiAgICAgICAgICAgIHZhciBwb3B1cF9kMmNlY2ZmOTA0NTM0MmQwYjkyODhkZDM2YmJjZTEwYSA9IEwucG9wdXAoe21heFdpZHRoOiAnMzAwJ30pOwoKICAgICAgICAgICAgCiAgICAgICAgICAgICAgICB2YXIgaHRtbF82MjIxNGVmNzI1M2U0Mjc1OWU2N2Q0OTM1N2UwM2ZkNyA9ICQoJzxkaXYgaWQ9Imh0bWxfNjIyMTRlZjcyNTNlNDI3NTllNjdkNDkzNTdlMDNmZDciIHN0eWxlPSJ3aWR0aDogMTAwLjAlOyBoZWlnaHQ6IDEwMC4wJTsiPk5hbWU6IEZPVVIgTUlMRSBDUkVFSyBBVCBMT0dBTiBNSUxMIFJPQUQgTkVBUiBDUklTTUFOLCBDTyBBbW91bnQ6IDE3LjAwPC9kaXY+JylbMF07CiAgICAgICAgICAgICAgICBwb3B1cF9kMmNlY2ZmOTA0NTM0MmQwYjkyODhkZDM2YmJjZTEwYS5zZXRDb250ZW50KGh0bWxfNjIyMTRlZjcyNTNlNDI3NTllNjdkNDkzNTdlMDNmZDcpOwogICAgICAgICAgICAKCiAgICAgICAgICAgIG1hcmtlcl9hZTE1NGUwYThiNmQ0ZmM5OTcxMGU2YTkxZTRmOTQzOS5iaW5kUG9wdXAocG9wdXBfZDJjZWNmZjkwNDUzNDJkMGI5Mjg4ZGQzNmJiY2UxMGEpOwoKICAgICAgICAgICAgCiAgICAgICAgCiAgICAKCiAgICAgICAgICAgIHZhciBtYXJrZXJfYzk4MmE3YjhkMGM3NDlhYWJjNzAxNmVlNmM5Mzc5NjggPSBMLm1hcmtlcigKICAgICAgICAgICAgICAgIFs0MC4wMTg2NjcsLTEwNS4zMjYyNV0sCiAgICAgICAgICAgICAgICB7CiAgICAgICAgICAgICAgICAgICAgaWNvbjogbmV3IEwuSWNvbi5EZWZhdWx0KCkKICAgICAgICAgICAgICAgICAgICB9CiAgICAgICAgICAgICAgICApCiAgICAgICAgICAgICAgICAuYWRkVG8obWFwX2NmZGQ1OGNjNGUxYzQ4YmI4YTkxYTRmZWI4Njg3NTJhKTsKICAgICAgICAgICAgCiAgICAKICAgICAgICAgICAgdmFyIHBvcHVwX2ZjZTY2ZTlhMmUxMjQ2NDRiYWZmOTZkYjczYzdlNzBlID0gTC5wb3B1cCh7bWF4V2lkdGg6ICczMDAnfSk7CgogICAgICAgICAgICAKICAgICAgICAgICAgICAgIHZhciBodG1sXzlhM2Q4ZGI2N2MyMzQ0NjVhMGFmY2QwZGE5ZWFiOTg5ID0gJCgnPGRpdiBpZD0iaHRtbF85YTNkOGRiNjdjMjM0NDY1YTBhZmNkMGRhOWVhYjk4OSIgc3R5bGU9IndpZHRoOiAxMDAuMCU7IGhlaWdodDogMTAwLjAlOyI+TmFtZTogRk9VUk1JTEUgQ1JFRUsgQVQgT1JPREVMTCwgQ08uIEFtb3VudDogMjQuODA8L2Rpdj4nKVswXTsKICAgICAgICAgICAgICAgIHBvcHVwX2ZjZTY2ZTlhMmUxMjQ2NDRiYWZmOTZkYjczYzdlNzBlLnNldENvbnRlbnQoaHRtbF85YTNkOGRiNjdjMjM0NDY1YTBhZmNkMGRhOWVhYjk4OSk7CiAgICAgICAgICAgIAoKICAgICAgICAgICAgbWFya2VyX2M5ODJhN2I4ZDBjNzQ5YWFiYzcwMTZlZTZjOTM3OTY4LmJpbmRQb3B1cChwb3B1cF9mY2U2NmU5YTJlMTI0NjQ0YmFmZjk2ZGI3M2M3ZTcwZSk7CgogICAgICAgICAgICAKICAgICAgICAKICAgIAoKICAgICAgICAgICAgdmFyIG1hcmtlcl9iNWVjZmUzOThlODg0NDBhYjYwMTlkYzVkNjRiNDk3OSA9IEwubWFya2VyKAogICAgICAgICAgICAgICAgWzM5Ljk0NzcwNCwtMTA1LjM1NzMwOF0sCiAgICAgICAgICAgICAgICB7CiAgICAgICAgICAgICAgICAgICAgaWNvbjogbmV3IEwuSWNvbi5EZWZhdWx0KCkKICAgICAgICAgICAgICAgICAgICB9CiAgICAgICAgICAgICAgICApCiAgICAgICAgICAgICAgICAuYWRkVG8obWFwX2NmZGQ1OGNjNGUxYzQ4YmI4YTkxYTRmZWI4Njg3NTJhKTsKICAgICAgICAgICAgCiAgICAKICAgICAgICAgICAgdmFyIHBvcHVwXzRkZGM0MmMyNzY1NTRkMmZiN2VmZTk1MWFkZjk2MzNmID0gTC5wb3B1cCh7bWF4V2lkdGg6ICczMDAnfSk7CgogICAgICAgICAgICAKICAgICAgICAgICAgICAgIHZhciBodG1sX2U4MjNkMjcyYWI0ZjRiZTE4ZTgwOWJmZGMwYTBlYTM1ID0gJCgnPGRpdiBpZD0iaHRtbF9lODIzZDI3MmFiNGY0YmUxOGU4MDliZmRjMGEwZWEzNSIgc3R5bGU9IndpZHRoOiAxMDAuMCU7IGhlaWdodDogMTAwLjAlOyI+TmFtZTogR1JPU1MgUkVTRVJWT0lSICBBbW91bnQ6IDI1NTUzLjAwPC9kaXY+JylbMF07CiAgICAgICAgICAgICAgICBwb3B1cF80ZGRjNDJjMjc2NTU0ZDJmYjdlZmU5NTFhZGY5NjMzZi5zZXRDb250ZW50KGh0bWxfZTgyM2QyNzJhYjRmNGJlMThlODA5YmZkYzBhMGVhMzUpOwogICAgICAgICAgICAKCiAgICAgICAgICAgIG1hcmtlcl9iNWVjZmUzOThlODg0NDBhYjYwMTlkYzVkNjRiNDk3OS5iaW5kUG9wdXAocG9wdXBfNGRkYzQyYzI3NjU1NGQyZmI3ZWZlOTUxYWRmOTYzM2YpOwoKICAgICAgICAgICAgCiAgICAgICAgCiAgICAKCiAgICAgICAgICAgIHZhciBtYXJrZXJfZGU0Y2QxN2M0NTQwNGExZjkyZThjMWFmMzJmMDQ1NzcgPSBMLm1hcmtlcigKICAgICAgICAgICAgICAgIFs0MC4wNTM2NjEsLTEwNS4xNTExNDNdLAogICAgICAgICAgICAgICAgewogICAgICAgICAgICAgICAgICAgIGljb246IG5ldyBMLkljb24uRGVmYXVsdCgpCiAgICAgICAgICAgICAgICAgICAgfQogICAgICAgICAgICAgICAgKQogICAgICAgICAgICAgICAgLmFkZFRvKG1hcF9jZmRkNThjYzRlMWM0OGJiOGE5MWE0ZmViODY4NzUyYSk7CiAgICAgICAgICAgIAogICAgCiAgICAgICAgICAgIHZhciBwb3B1cF81YWM1MWFjNGZjYjk0NTBiYmFkZDYzOWJlZDVhMTQ1YiA9IEwucG9wdXAoe21heFdpZHRoOiAnMzAwJ30pOwoKICAgICAgICAgICAgCiAgICAgICAgICAgICAgICB2YXIgaHRtbF80MDA4YzY5MGRkYmY0MDBjYTM0YTEzNGY1ZDlkYzVlNSA9ICQoJzxkaXYgaWQ9Imh0bWxfNDAwOGM2OTBkZGJmNDAwY2EzNGExMzRmNWQ5ZGM1ZTUiIHN0eWxlPSJ3aWR0aDogMTAwLjAlOyBoZWlnaHQ6IDEwMC4wJTsiPk5hbWU6IExFR0dFVFQgRElUQ0ggQW1vdW50OiAxNy42NzwvZGl2PicpWzBdOwogICAgICAgICAgICAgICAgcG9wdXBfNWFjNTFhYzRmY2I5NDUwYmJhZGQ2MzliZWQ1YTE0NWIuc2V0Q29udGVudChodG1sXzQwMDhjNjkwZGRiZjQwMGNhMzRhMTM0ZjVkOWRjNWU1KTsKICAgICAgICAgICAgCgogICAgICAgICAgICBtYXJrZXJfZGU0Y2QxN2M0NTQwNGExZjkyZThjMWFmMzJmMDQ1NzcuYmluZFBvcHVwKHBvcHVwXzVhYzUxYWM0ZmNiOTQ1MGJiYWRkNjM5YmVkNWExNDViKTsKCiAgICAgICAgICAgIAogICAgICAgIAogICAgCgogICAgICAgICAgICB2YXIgbWFya2VyXzMyOTJjZjgyNDE4ZTRkNTVhNGRmYWMwMTgzODI5Zjk0ID0gTC5tYXJrZXIoCiAgICAgICAgICAgICAgICBbMzkuOTYxNjU1LC0xMDUuNTA0NDRdLAogICAgICAgICAgICAgICAgewogICAgICAgICAgICAgICAgICAgIGljb246IG5ldyBMLkljb24uRGVmYXVsdCgpCiAgICAgICAgICAgICAgICAgICAgfQogICAgICAgICAgICAgICAgKQogICAgICAgICAgICAgICAgLmFkZFRvKG1hcF9jZmRkNThjYzRlMWM0OGJiOGE5MWE0ZmViODY4NzUyYSk7CiAgICAgICAgICAgIAogICAgCiAgICAgICAgICAgIHZhciBwb3B1cF9mOGYxNDEyOTcwMGQ0OGVjOTQ1YzcxMmVhOWJlNmYzYSA9IEwucG9wdXAoe21heFdpZHRoOiAnMzAwJ30pOwoKICAgICAgICAgICAgCiAgICAgICAgICAgICAgICB2YXIgaHRtbF81MzY3NzM3ZjBiY2E0MzIxOWZjYWM4ZTE3ZjZhNGI4NiA9ICQoJzxkaXYgaWQ9Imh0bWxfNTM2NzczN2YwYmNhNDMyMTlmY2FjOGUxN2Y2YTRiODYiIHN0eWxlPSJ3aWR0aDogMTAwLjAlOyBoZWlnaHQ6IDEwMC4wJTsiPk5hbWU6IE1JRERMRSBCT1VMREVSIENSRUVLIEFUIE5FREVSTEFORCBBbW91bnQ6IDE1MS4wMDwvZGl2PicpWzBdOwogICAgICAgICAgICAgICAgcG9wdXBfZjhmMTQxMjk3MDBkNDhlYzk0NWM3MTJlYTliZTZmM2Euc2V0Q29udGVudChodG1sXzUzNjc3MzdmMGJjYTQzMjE5ZmNhYzhlMTdmNmE0Yjg2KTsKICAgICAgICAgICAgCgogICAgICAgICAgICBtYXJrZXJfMzI5MmNmODI0MThlNGQ1NWE0ZGZhYzAxODM4MjlmOTQuYmluZFBvcHVwKHBvcHVwX2Y4ZjE0MTI5NzAwZDQ4ZWM5NDVjNzEyZWE5YmU2ZjNhKTsKCiAgICAgICAgICAgIAogICAgICAgIAogICAgCgogICAgICAgICAgICB2YXIgbWFya2VyXzI1NDFhOWVjZGNiMzRiNDU4NzEwOThiMzM5MzdjNTFhID0gTC5tYXJrZXIoCiAgICAgICAgICAgICAgICBbMzkuOTMxNjU5LC0xMDUuNDIyOTg1XSwKICAgICAgICAgICAgICAgIHsKICAgICAgICAgICAgICAgICAgICBpY29uOiBuZXcgTC5JY29uLkRlZmF1bHQoKQogICAgICAgICAgICAgICAgICAgIH0KICAgICAgICAgICAgICAgICkKICAgICAgICAgICAgICAgIC5hZGRUbyhtYXBfY2ZkZDU4Y2M0ZTFjNDhiYjhhOTFhNGZlYjg2ODc1MmEpOwogICAgICAgICAgICAKICAgIAogICAgICAgICAgICB2YXIgcG9wdXBfODM2NzA4NTJmZDgyNDNkMGEzMzIwOTY0YjFmNDgzMGQgPSBMLnBvcHVwKHttYXhXaWR0aDogJzMwMCd9KTsKCiAgICAgICAgICAgIAogICAgICAgICAgICAgICAgdmFyIGh0bWxfZDU2MTA3MGVkN2Q2NDFjZjhlZGI1Mzc3YjdhYThhZDQgPSAkKCc8ZGl2IGlkPSJodG1sX2Q1NjEwNzBlZDdkNjQxY2Y4ZWRiNTM3N2I3YWE4YWQ0IiBzdHlsZT0id2lkdGg6IDEwMC4wJTsgaGVpZ2h0OiAxMDAuMCU7Ij5OYW1lOiBTT1VUSCBCT1VMREVSIENSRUVLIEFCT1ZFIEdST1NTIFJFU0VSVk9JUiBBVCBQSU5FQ0xJRkZFIEFtb3VudDogNzAzLjAwPC9kaXY+JylbMF07CiAgICAgICAgICAgICAgICBwb3B1cF84MzY3MDg1MmZkODI0M2QwYTMzMjA5NjRiMWY0ODMwZC5zZXRDb250ZW50KGh0bWxfZDU2MTA3MGVkN2Q2NDFjZjhlZGI1Mzc3YjdhYThhZDQpOwogICAgICAgICAgICAKCiAgICAgICAgICAgIG1hcmtlcl8yNTQxYTllY2RjYjM0YjQ1ODcxMDk4YjMzOTM3YzUxYS5iaW5kUG9wdXAocG9wdXBfODM2NzA4NTJmZDgyNDNkMGEzMzIwOTY0YjFmNDgzMGQpOwoKICAgICAgICAgICAgCiAgICAgICAgCiAgICAKCiAgICAgICAgICAgIHZhciBtYXJrZXJfNTVkZjA4NDYxNGM5NDRlNWIwZWEwMzczZGY3NDg1ZGMgPSBMLm1hcmtlcigKICAgICAgICAgICAgICAgIFszOS45MzgzNTEsLTEwNS4zNDc5MDZdLAogICAgICAgICAgICAgICAgewogICAgICAgICAgICAgICAgICAgIGljb246IG5ldyBMLkljb24uRGVmYXVsdCgpCiAgICAgICAgICAgICAgICAgICAgfQogICAgICAgICAgICAgICAgKQogICAgICAgICAgICAgICAgLmFkZFRvKG1hcF9jZmRkNThjYzRlMWM0OGJiOGE5MWE0ZmViODY4NzUyYSk7CiAgICAgICAgICAgIAogICAgCiAgICAgICAgICAgIHZhciBwb3B1cF85NzIyYzgxY2ViYjk0OTM4ODY4NTMwZjI4Y2E2ZjY0YSA9IEwucG9wdXAoe21heFdpZHRoOiAnMzAwJ30pOwoKICAgICAgICAgICAgCiAgICAgICAgICAgICAgICB2YXIgaHRtbF80ZjhmNWQzYWI1MTY0NzE4YTBhZWVhMTcwZDE3M2M5ZSA9ICQoJzxkaXYgaWQ9Imh0bWxfNGY4ZjVkM2FiNTE2NDcxOGEwYWVlYTE3MGQxNzNjOWUiIHN0eWxlPSJ3aWR0aDogMTAwLjAlOyBoZWlnaHQ6IDEwMC4wJTsiPk5hbWU6IFNPVVRIIEJPVUxERVIgQ1JFRUsgQkVMT1cgR1JPU1MgUkVTRVJWT0lSIEFtb3VudDogMjAxLjAwPC9kaXY+JylbMF07CiAgICAgICAgICAgICAgICBwb3B1cF85NzIyYzgxY2ViYjk0OTM4ODY4NTMwZjI4Y2E2ZjY0YS5zZXRDb250ZW50KGh0bWxfNGY4ZjVkM2FiNTE2NDcxOGEwYWVlYTE3MGQxNzNjOWUpOwogICAgICAgICAgICAKCiAgICAgICAgICAgIG1hcmtlcl81NWRmMDg0NjE0Yzk0NGU1YjBlYTAzNzNkZjc0ODVkYy5iaW5kUG9wdXAocG9wdXBfOTcyMmM4MWNlYmI5NDkzODg2ODUzMGYyOGNhNmY2NGEpOwoKICAgICAgICAgICAgCiAgICAgICAgCiAgICAKCiAgICAgICAgICAgIHZhciBtYXJrZXJfNmM0YWIyYjkwNWU3NDVjNWFlNzVlOTUxMDA0NDJmODIgPSBMLm1hcmtlcigKICAgICAgICAgICAgICAgIFszOS45MzE4MTMsLTEwNS4zMDg0MzJdLAogICAgICAgICAgICAgICAgewogICAgICAgICAgICAgICAgICAgIGljb246IG5ldyBMLkljb24uRGVmYXVsdCgpCiAgICAgICAgICAgICAgICAgICAgfQogICAgICAgICAgICAgICAgKQogICAgICAgICAgICAgICAgLmFkZFRvKG1hcF9jZmRkNThjYzRlMWM0OGJiOGE5MWE0ZmViODY4NzUyYSk7CiAgICAgICAgICAgIAogICAgCiAgICAgICAgICAgIHZhciBwb3B1cF84ZDQ1YmEwNGQyNTY0YTcxYmRkM2Y2ZDJjZmU1ZjZhMiA9IEwucG9wdXAoe21heFdpZHRoOiAnMzAwJ30pOwoKICAgICAgICAgICAgCiAgICAgICAgICAgICAgICB2YXIgaHRtbF9mNzFiODY1YWFhZTE0OGY2YjgwN2Y2Y2E5ZWQ0ODAyYSA9ICQoJzxkaXYgaWQ9Imh0bWxfZjcxYjg2NWFhYWUxNDhmNmI4MDdmNmNhOWVkNDgwMmEiIHN0eWxlPSJ3aWR0aDogMTAwLjAlOyBoZWlnaHQ6IDEwMC4wJTsiPk5hbWU6IFNPVVRIIEJPVUxERVIgQ1JFRUsgRElWRVJTSU9OIE5FQVIgRUxET1JBRE8gU1BSSU5HUyBBbW91bnQ6IDEwMy4wMDwvZGl2PicpWzBdOwogICAgICAgICAgICAgICAgcG9wdXBfOGQ0NWJhMDRkMjU2NGE3MWJkZDNmNmQyY2ZlNWY2YTIuc2V0Q29udGVudChodG1sX2Y3MWI4NjVhYWFlMTQ4ZjZiODA3ZjZjYTllZDQ4MDJhKTsKICAgICAgICAgICAgCgogICAgICAgICAgICBtYXJrZXJfNmM0YWIyYjkwNWU3NDVjNWFlNzVlOTUxMDA0NDJmODIuYmluZFBvcHVwKHBvcHVwXzhkNDViYTA0ZDI1NjRhNzFiZGQzZjZkMmNmZTVmNmEyKTsKCiAgICAgICAgICAgIAogICAgICAgIAogICAgCgogICAgICAgICAgICB2YXIgbWFya2VyXzQ3NzY0YzM0ZDUxOTQ0MWY5OGFlZWRjODEyNzYxNDU1ID0gTC5tYXJrZXIoCiAgICAgICAgICAgICAgICBbMzkuOTMxNTk3LC0xMDUuMzA0OTldLAogICAgICAgICAgICAgICAgewogICAgICAgICAgICAgICAgICAgIGljb246IG5ldyBMLkljb24uRGVmYXVsdCgpCiAgICAgICAgICAgICAgICAgICAgfQogICAgICAgICAgICAgICAgKQogICAgICAgICAgICAgICAgLmFkZFRvKG1hcF9jZmRkNThjYzRlMWM0OGJiOGE5MWE0ZmViODY4NzUyYSk7CiAgICAgICAgICAgIAogICAgCiAgICAgICAgICAgIHZhciBwb3B1cF84YjZjNWZhMzM1NGU0ZTY5OWU3M2FjZjc4MGE4YzFhNiA9IEwucG9wdXAoe21heFdpZHRoOiAnMzAwJ30pOwoKICAgICAgICAgICAgCiAgICAgICAgICAgICAgICB2YXIgaHRtbF81Y2Y4Nzk1ZmZmMWM0YTg1ODhjNjU3ZGQ0ZjU4OGU1YiA9ICQoJzxkaXYgaWQ9Imh0bWxfNWNmODc5NWZmZjFjNGE4NTg4YzY1N2RkNGY1ODhlNWIiIHN0eWxlPSJ3aWR0aDogMTAwLjAlOyBoZWlnaHQ6IDEwMC4wJTsiPk5hbWU6IFNPVVRIIEJPVUxERVIgQ1JFRUsgTkVBUiBFTERPUkFETyBTUFJJTkdTIEFtb3VudDogOTcuMTA8L2Rpdj4nKVswXTsKICAgICAgICAgICAgICAgIHBvcHVwXzhiNmM1ZmEzMzU0ZTRlNjk5ZTczYWNmNzgwYThjMWE2LnNldENvbnRlbnQoaHRtbF81Y2Y4Nzk1ZmZmMWM0YTg1ODhjNjU3ZGQ0ZjU4OGU1Yik7CiAgICAgICAgICAgIAoKICAgICAgICAgICAgbWFya2VyXzQ3NzY0YzM0ZDUxOTQ0MWY5OGFlZWRjODEyNzYxNDU1LmJpbmRQb3B1cChwb3B1cF84YjZjNWZhMzM1NGU0ZTY5OWU3M2FjZjc4MGE4YzFhNik7CgogICAgICAgICAgICAKICAgICAgICAKPC9zY3JpcHQ+" style="position:absolute;width:100%;height:100%;left:0;top:0;border:none !important;" allowfullscreen webkitallowfullscreen mozallowfullscreen></iframe></div></div>





## More Leaflet Styling and Customization

<div class="notice--info" markdown="1">

## Additional Resources

* <a href="https://blog.datafiniti.co/4-reasons-you-should-use-json-instead-of-csv-2cac362f1943" target="_blank">Why you should use JSON instead of csv.</a>


* <a href="https://www.w3schools.com/js/js_json_intro.asp" target="_blank">W3schools JSON intro </a>

</div>
