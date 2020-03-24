---
layout: single
title: 'Programmatically Accessing Geospatial Data Using APIs'
excerpt: 'This lesson walks through the process of retrieving and manipulating surface water data housed in the Colorado Information Warehouse. These data are stored in JSON format with spatial x, y information that support mapping.'
authors: ['Leah Wasser', 'Max Joseph', 'Martha Morrissey', 'Jenny Palomino', 'Carson Farmer']
modified: 2020-03-24
category: [courses]
class-lesson: ['intro-APIs-python']
/courses/use-data-open-source-python/using-apis-natural-language-processing-twitter/co-water-data-spatial-python/
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
      <td>2020-03-24T14:30:00.000</td>
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
      <td>2020-03-24T14:30:00.000</td>
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



<div style="width:100%;"><div style="position:relative;width:100%;height:0;padding-bottom:60%;"><iframe src="data:text/html;charset=utf-8;base64,PCFET0NUWVBFIGh0bWw+CjxoZWFkPiAgICAKICAgIDxtZXRhIGh0dHAtZXF1aXY9ImNvbnRlbnQtdHlwZSIgY29udGVudD0idGV4dC9odG1sOyBjaGFyc2V0PVVURi04IiAvPgogICAgCiAgICAgICAgPHNjcmlwdD4KICAgICAgICAgICAgTF9OT19UT1VDSCA9IGZhbHNlOwogICAgICAgICAgICBMX0RJU0FCTEVfM0QgPSBmYWxzZTsKICAgICAgICA8L3NjcmlwdD4KICAgIAogICAgPHNjcmlwdCBzcmM9Imh0dHBzOi8vY2RuLmpzZGVsaXZyLm5ldC9ucG0vbGVhZmxldEAxLjUuMS9kaXN0L2xlYWZsZXQuanMiPjwvc2NyaXB0PgogICAgPHNjcmlwdCBzcmM9Imh0dHBzOi8vY29kZS5qcXVlcnkuY29tL2pxdWVyeS0xLjEyLjQubWluLmpzIj48L3NjcmlwdD4KICAgIDxzY3JpcHQgc3JjPSJodHRwczovL21heGNkbi5ib290c3RyYXBjZG4uY29tL2Jvb3RzdHJhcC8zLjIuMC9qcy9ib290c3RyYXAubWluLmpzIj48L3NjcmlwdD4KICAgIDxzY3JpcHQgc3JjPSJodHRwczovL2NkbmpzLmNsb3VkZmxhcmUuY29tL2FqYXgvbGlicy9MZWFmbGV0LmF3ZXNvbWUtbWFya2Vycy8yLjAuMi9sZWFmbGV0LmF3ZXNvbWUtbWFya2Vycy5qcyI+PC9zY3JpcHQ+CiAgICA8bGluayByZWw9InN0eWxlc2hlZXQiIGhyZWY9Imh0dHBzOi8vY2RuLmpzZGVsaXZyLm5ldC9ucG0vbGVhZmxldEAxLjUuMS9kaXN0L2xlYWZsZXQuY3NzIi8+CiAgICA8bGluayByZWw9InN0eWxlc2hlZXQiIGhyZWY9Imh0dHBzOi8vbWF4Y2RuLmJvb3RzdHJhcGNkbi5jb20vYm9vdHN0cmFwLzMuMi4wL2Nzcy9ib290c3RyYXAubWluLmNzcyIvPgogICAgPGxpbmsgcmVsPSJzdHlsZXNoZWV0IiBocmVmPSJodHRwczovL21heGNkbi5ib290c3RyYXBjZG4uY29tL2Jvb3RzdHJhcC8zLjIuMC9jc3MvYm9vdHN0cmFwLXRoZW1lLm1pbi5jc3MiLz4KICAgIDxsaW5rIHJlbD0ic3R5bGVzaGVldCIgaHJlZj0iaHR0cHM6Ly9tYXhjZG4uYm9vdHN0cmFwY2RuLmNvbS9mb250LWF3ZXNvbWUvNC42LjMvY3NzL2ZvbnQtYXdlc29tZS5taW4uY3NzIi8+CiAgICA8bGluayByZWw9InN0eWxlc2hlZXQiIGhyZWY9Imh0dHBzOi8vY2RuanMuY2xvdWRmbGFyZS5jb20vYWpheC9saWJzL0xlYWZsZXQuYXdlc29tZS1tYXJrZXJzLzIuMC4yL2xlYWZsZXQuYXdlc29tZS1tYXJrZXJzLmNzcyIvPgogICAgPGxpbmsgcmVsPSJzdHlsZXNoZWV0IiBocmVmPSJodHRwczovL3Jhd2Nkbi5naXRoYWNrLmNvbS9weXRob24tdmlzdWFsaXphdGlvbi9mb2xpdW0vbWFzdGVyL2ZvbGl1bS90ZW1wbGF0ZXMvbGVhZmxldC5hd2Vzb21lLnJvdGF0ZS5jc3MiLz4KICAgIDxzdHlsZT5odG1sLCBib2R5IHt3aWR0aDogMTAwJTtoZWlnaHQ6IDEwMCU7bWFyZ2luOiAwO3BhZGRpbmc6IDA7fTwvc3R5bGU+CiAgICA8c3R5bGU+I21hcCB7cG9zaXRpb246YWJzb2x1dGU7dG9wOjA7Ym90dG9tOjA7cmlnaHQ6MDtsZWZ0OjA7fTwvc3R5bGU+CiAgICAKICAgICAgICAgICAgPG1ldGEgbmFtZT0idmlld3BvcnQiIGNvbnRlbnQ9IndpZHRoPWRldmljZS13aWR0aCwKICAgICAgICAgICAgICAgIGluaXRpYWwtc2NhbGU9MS4wLCBtYXhpbXVtLXNjYWxlPTEuMCwgdXNlci1zY2FsYWJsZT1ubyIgLz4KICAgICAgICAgICAgPHN0eWxlPgogICAgICAgICAgICAgICAgI21hcF85NWE1YjVmYzU1N2E0NTgwYTI0ODYwZjkwYzY5MzA3MSB7CiAgICAgICAgICAgICAgICAgICAgcG9zaXRpb246IHJlbGF0aXZlOwogICAgICAgICAgICAgICAgICAgIHdpZHRoOiAxMDAuMCU7CiAgICAgICAgICAgICAgICAgICAgaGVpZ2h0OiAxMDAuMCU7CiAgICAgICAgICAgICAgICAgICAgbGVmdDogMC4wJTsKICAgICAgICAgICAgICAgICAgICB0b3A6IDAuMCU7CiAgICAgICAgICAgICAgICB9CiAgICAgICAgICAgIDwvc3R5bGU+CiAgICAgICAgCjwvaGVhZD4KPGJvZHk+ICAgIAogICAgCiAgICAgICAgICAgIDxkaXYgY2xhc3M9ImZvbGl1bS1tYXAiIGlkPSJtYXBfOTVhNWI1ZmM1NTdhNDU4MGEyNDg2MGY5MGM2OTMwNzEiID48L2Rpdj4KICAgICAgICAKPC9ib2R5Pgo8c2NyaXB0PiAgICAKICAgIAogICAgICAgICAgICB2YXIgbWFwXzk1YTViNWZjNTU3YTQ1ODBhMjQ4NjBmOTBjNjkzMDcxID0gTC5tYXAoCiAgICAgICAgICAgICAgICAibWFwXzk1YTViNWZjNTU3YTQ1ODBhMjQ4NjBmOTBjNjkzMDcxIiwKICAgICAgICAgICAgICAgIHsKICAgICAgICAgICAgICAgICAgICBjZW50ZXI6IFs0MC4wMSwgLTEwNS4yN10sCiAgICAgICAgICAgICAgICAgICAgY3JzOiBMLkNSUy5FUFNHMzg1NywKICAgICAgICAgICAgICAgICAgICB6b29tOiAxMCwKICAgICAgICAgICAgICAgICAgICB6b29tQ29udHJvbDogdHJ1ZSwKICAgICAgICAgICAgICAgICAgICBwcmVmZXJDYW52YXM6IGZhbHNlLAogICAgICAgICAgICAgICAgfQogICAgICAgICAgICApOwoKICAgICAgICAgICAgCgogICAgICAgIAogICAgCiAgICAgICAgICAgIHZhciB0aWxlX2xheWVyXzY2ZTkxYjdiOTZiNjQ5OWY5NmU4YmRkOTA1NWYwY2ZkID0gTC50aWxlTGF5ZXIoCiAgICAgICAgICAgICAgICAiaHR0cHM6Ly9jYXJ0b2RiLWJhc2VtYXBzLXtzfS5nbG9iYWwuc3NsLmZhc3RseS5uZXQvbGlnaHRfYWxsL3t6fS97eH0ve3l9LnBuZyIsCiAgICAgICAgICAgICAgICB7ImF0dHJpYnV0aW9uIjogIlx1MDAyNmNvcHk7IFx1MDAzY2EgaHJlZj1cImh0dHA6Ly93d3cub3BlbnN0cmVldG1hcC5vcmcvY29weXJpZ2h0XCJcdTAwM2VPcGVuU3RyZWV0TWFwXHUwMDNjL2FcdTAwM2UgY29udHJpYnV0b3JzIFx1MDAyNmNvcHk7IFx1MDAzY2EgaHJlZj1cImh0dHA6Ly9jYXJ0b2RiLmNvbS9hdHRyaWJ1dGlvbnNcIlx1MDAzZUNhcnRvREJcdTAwM2MvYVx1MDAzZSwgQ2FydG9EQiBcdTAwM2NhIGhyZWYgPVwiaHR0cDovL2NhcnRvZGIuY29tL2F0dHJpYnV0aW9uc1wiXHUwMDNlYXR0cmlidXRpb25zXHUwMDNjL2FcdTAwM2UiLCAiZGV0ZWN0UmV0aW5hIjogZmFsc2UsICJtYXhOYXRpdmVab29tIjogMTgsICJtYXhab29tIjogMTgsICJtaW5ab29tIjogMCwgIm5vV3JhcCI6IGZhbHNlLCAib3BhY2l0eSI6IDEsICJzdWJkb21haW5zIjogImFiYyIsICJ0bXMiOiBmYWxzZX0KICAgICAgICAgICAgKS5hZGRUbyhtYXBfOTVhNWI1ZmM1NTdhNDU4MGEyNDg2MGY5MGM2OTMwNzEpOwogICAgICAgIAogICAgCiAgICAgICAgZnVuY3Rpb24gZ2VvX2pzb25fYWNiMjU5MWRmNmNkNDI0N2JkZjJmNjA1NzM4ZmM3MWRfb25FYWNoRmVhdHVyZShmZWF0dXJlLCBsYXllcikgewogICAgICAgICAgICBsYXllci5vbih7CiAgICAgICAgICAgICAgICBjbGljazogZnVuY3Rpb24oZSkgewogICAgICAgICAgICAgICAgICAgIG1hcF85NWE1YjVmYzU1N2E0NTgwYTI0ODYwZjkwYzY5MzA3MS5maXRCb3VuZHMoZS50YXJnZXQuZ2V0Qm91bmRzKCkpOwogICAgICAgICAgICAgICAgfQogICAgICAgICAgICB9KTsKICAgICAgICB9OwogICAgICAgIHZhciBnZW9fanNvbl9hY2IyNTkxZGY2Y2Q0MjQ3YmRmMmY2MDU3MzhmYzcxZCA9IEwuZ2VvSnNvbihudWxsLCB7CiAgICAgICAgICAgICAgICBvbkVhY2hGZWF0dXJlOiBnZW9fanNvbl9hY2IyNTkxZGY2Y2Q0MjQ3YmRmMmY2MDU3MzhmYzcxZF9vbkVhY2hGZWF0dXJlLAogICAgICAgICAgICAKICAgICAgICB9KTsKICAgICAgICBmdW5jdGlvbiBnZW9fanNvbl9hY2IyNTkxZGY2Y2Q0MjQ3YmRmMmY2MDU3MzhmYzcxZF9hZGQgKGRhdGEpIHsKICAgICAgICAgICAgZ2VvX2pzb25fYWNiMjU5MWRmNmNkNDI0N2JkZjJmNjA1NzM4ZmM3MWQuYWRkRGF0YShkYXRhKQogICAgICAgICAgICAgICAgLmFkZFRvKG1hcF85NWE1YjVmYzU1N2E0NTgwYTI0ODYwZjkwYzY5MzA3MSk7CiAgICAgICAgfQogICAgICAgICAgICBnZW9fanNvbl9hY2IyNTkxZGY2Y2Q0MjQ3YmRmMmY2MDU3MzhmYzcxZF9hZGQoeyJiYm94IjogWy0xMDUuNTA0NDQsIDM5LjkzMTU5NywgLTEwNS4wNzU2OTUwMDAwMDAwMSwgNDAuMjYwODI3XSwgImZlYXR1cmVzIjogW3siYmJveCI6IFstMTA1LjE4NTc4OSwgNDAuMTg1MDMzLCAtMTA1LjE4NTc4OSwgNDAuMTg1MDMzXSwgImdlb21ldHJ5IjogeyJjb29yZGluYXRlcyI6IFstMTA1LjE4NTc4OSwgNDAuMTg1MDMzXSwgInR5cGUiOiAiUG9pbnQifSwgImlkIjogIjAiLCAicHJvcGVydGllcyI6IHsiYW1vdW50IjogIjAuMTQiLCAiY291bnR5IjogIkJPVUxERVIiLCAiZGF0YV9zb3VyY2UiOiAiQ29vcGVyYXRpdmUgUHJvZ3JhbSBvZiBDRFdSLCBOQ1dDRCBcdTAwMjYgU1ZMSFdDRCIsICJkYXRlX3RpbWUiOiAiMjAyMC0wMy0yNFQxNTowMDowMC4wMDAiLCAiZGl2IjogIjEiLCAiZHdyX2FiYnJldiI6ICJaV0VUVVJDTyIsICJmbGFnIjogbnVsbCwgImh0dHBfbGlua2FnZS51cmwiOiAiaHR0cHM6Ly9kd3Iuc3RhdGUuY28udXMvU3VyZmFjZVdhdGVyL2RhdGEvZGV0YWlsX2dyYXBoLmFzcHg/SUQ9WldFVFVSQ09cdTAwMjZNVFlQRT1ESVNDSFJHIiwgImxvY2F0aW9uLmxhdGl0dWRlIjogNDAuMTg1MDMzLCAibG9jYXRpb24ubG9uZ2l0dWRlIjogLTEwNS4xODU3ODksICJsb2NhdGlvbi5uZWVkc19yZWNvZGluZyI6IGZhbHNlLCAic3RhZ2UiOiAiMC4wNSIsICJzdGF0aW9uX25hbWUiOiAiWldFQ0sgQU5EIFRVUk5FUiBESVRDSCIsICJzdGF0aW9uX3N0YXR1cyI6ICJBY3RpdmUiLCAic3RhdGlvbl90eXBlIjogIkRpdmVyc2lvbiIsICJ1c2dzX3N0YXRpb25faWQiOiBudWxsLCAidmFyaWFibGUiOiAiRElTQ0hSRyIsICJ3ZCI6ICI1In0sICJ0eXBlIjogIkZlYXR1cmUifSwgeyJiYm94IjogWy0xMDUuMjYzNDksIDQwLjIyMDcwMiwgLTEwNS4yNjM0OSwgNDAuMjIwNzAyXSwgImdlb21ldHJ5IjogeyJjb29yZGluYXRlcyI6IFstMTA1LjI2MzQ5LCA0MC4yMjA3MDJdLCAidHlwZSI6ICJQb2ludCJ9LCAiaWQiOiAiMSIsICJwcm9wZXJ0aWVzIjogeyJhbW91bnQiOiAiMzkuMjAiLCAiY291bnR5IjogIkJPVUxERVIiLCAiZGF0YV9zb3VyY2UiOiAiQ28uIERpdmlzaW9uIG9mIFdhdGVyIFJlc291cmNlcyIsICJkYXRlX3RpbWUiOiAiMjAyMC0wMy0yNFQxNToxNTowMC4wMDAiLCAiZGl2IjogIjEiLCAiZHdyX2FiYnJldiI6ICJTVkNMWU9DTyIsICJmbGFnIjogbnVsbCwgImh0dHBfbGlua2FnZS51cmwiOiAiaHR0cHM6Ly9kd3Iuc3RhdGUuY28udXMvU3VyZmFjZVdhdGVyL2RhdGEvZGV0YWlsX2dyYXBoLmFzcHg/SUQ9U1ZDTFlPQ09cdTAwMjZNVFlQRT1ESVNDSFJHIiwgImxvY2F0aW9uLmxhdGl0dWRlIjogNDAuMjIwNzAyLCAibG9jYXRpb24ubG9uZ2l0dWRlIjogLTEwNS4yNjM0OSwgImxvY2F0aW9uLm5lZWRzX3JlY29kaW5nIjogZmFsc2UsICJzdGFnZSI6ICIyLjk3IiwgInN0YXRpb25fbmFtZSI6ICJTQUlOVCBWUkFJTiBDUkVFSyBBVCBMWU9OUywgQ08iLCAic3RhdGlvbl9zdGF0dXMiOiAiQWN0aXZlIiwgInN0YXRpb25fdHlwZSI6ICJTdHJlYW0iLCAidXNnc19zdGF0aW9uX2lkIjogIjA2NzI0MDAwIiwgInZhcmlhYmxlIjogIkRJU0NIUkciLCAid2QiOiAiNSJ9LCAidHlwZSI6ICJGZWF0dXJlIn0sIHsiYmJveCI6IFstMTA1LjIwNjU5MiwgNDAuMTk2NDIyLCAtMTA1LjIwNjU5MiwgNDAuMTk2NDIyXSwgImdlb21ldHJ5IjogeyJjb29yZGluYXRlcyI6IFstMTA1LjIwNjU5MiwgNDAuMTk2NDIyXSwgInR5cGUiOiAiUG9pbnQifSwgImlkIjogIjIiLCAicHJvcGVydGllcyI6IHsiYW1vdW50IjogIjMuNzUiLCAiY291bnR5IjogIkJPVUxERVIiLCAiZGF0YV9zb3VyY2UiOiAiQ29vcGVyYXRpdmUgUHJvZ3JhbSBvZiBDRFdSLCBOQ1dDRCBcdTAwMjYgU1ZMSFdDRCIsICJkYXRlX3RpbWUiOiAiMjAyMC0wMy0yNFQxMzo0NTowMC4wMDAiLCAiZGl2IjogIjEiLCAiZHdyX2FiYnJldiI6ICJPTElESVRDTyIsICJmbGFnIjogbnVsbCwgImh0dHBfbGlua2FnZS51cmwiOiAiaHR0cHM6Ly9kd3Iuc3RhdGUuY28udXMvU3VyZmFjZVdhdGVyL2RhdGEvZGV0YWlsX2dyYXBoLmFzcHg/SUQ9T0xJRElUQ09cdTAwMjZNVFlQRT1ESVNDSFJHIiwgImxvY2F0aW9uLmxhdGl0dWRlIjogNDAuMTk2NDIyLCAibG9jYXRpb24ubG9uZ2l0dWRlIjogLTEwNS4yMDY1OTIsICJsb2NhdGlvbi5uZWVkc19yZWNvZGluZyI6IGZhbHNlLCAic3RhZ2UiOiAiMC4yMyIsICJzdGF0aW9uX25hbWUiOiAiT0xJR0FSQ0hZIERJVENIIERJVkVSU0lPTiIsICJzdGF0aW9uX3N0YXR1cyI6ICJBY3RpdmUiLCAic3RhdGlvbl90eXBlIjogIkRpdmVyc2lvbiIsICJ1c2dzX3N0YXRpb25faWQiOiBudWxsLCAidmFyaWFibGUiOiAiRElTQ0hSRyIsICJ3ZCI6ICI1In0sICJ0eXBlIjogIkZlYXR1cmUifSwgeyJiYm94IjogWy0xMDUuMzA4NDMyLCAzOS45MzE4MTMsIC0xMDUuMzA4NDMyLCAzOS45MzE4MTNdLCAiZ2VvbWV0cnkiOiB7ImNvb3JkaW5hdGVzIjogWy0xMDUuMzA4NDMyLCAzOS45MzE4MTNdLCAidHlwZSI6ICJQb2ludCJ9LCAiaWQiOiAiMyIsICJwcm9wZXJ0aWVzIjogeyJhbW91bnQiOiAiMC4wMCIsICJjb3VudHkiOiAiQk9VTERFUiIsICJkYXRhX3NvdXJjZSI6ICJDby4gRGl2aXNpb24gb2YgV2F0ZXIgUmVzb3VyY2VzIiwgImRhdGVfdGltZSI6ICIyMDIwLTAzLTI0VDE0OjMwOjAwLjAwMCIsICJkaXYiOiAiMSIsICJkd3JfYWJicmV2IjogIkJPU0RFTENPIiwgImZsYWciOiBudWxsLCAiaHR0cF9saW5rYWdlLnVybCI6ICJodHRwczovL2R3ci5zdGF0ZS5jby51cy9TdXJmYWNlV2F0ZXIvZGF0YS9kZXRhaWxfZ3JhcGguYXNweD9JRD1CT1NERUxDT1x1MDAyNk1UWVBFPURJU0NIUkciLCAibG9jYXRpb24ubGF0aXR1ZGUiOiAzOS45MzE4MTMsICJsb2NhdGlvbi5sb25naXR1ZGUiOiAtMTA1LjMwODQzMiwgImxvY2F0aW9uLm5lZWRzX3JlY29kaW5nIjogZmFsc2UsICJzdGFnZSI6ICItMS43MCIsICJzdGF0aW9uX25hbWUiOiAiU09VVEggQk9VTERFUiBDUkVFSyBESVZFUlNJT04gTkVBUiBFTERPUkFETyBTUFJJTkdTIiwgInN0YXRpb25fc3RhdHVzIjogIkFjdGl2ZSIsICJzdGF0aW9uX3R5cGUiOiAiRGl2ZXJzaW9uIiwgInVzZ3Nfc3RhdGlvbl9pZCI6IG51bGwsICJ2YXJpYWJsZSI6ICJESVNDSFJHIiwgIndkIjogIjYifSwgInR5cGUiOiAiRmVhdHVyZSJ9LCB7ImJib3giOiBbLTEwNS4yMTAzOSwgNDAuMTkzNzU4LCAtMTA1LjIxMDM5LCA0MC4xOTM3NThdLCAiZ2VvbWV0cnkiOiB7ImNvb3JkaW5hdGVzIjogWy0xMDUuMjEwMzksIDQwLjE5Mzc1OF0sICJ0eXBlIjogIlBvaW50In0sICJpZCI6ICI0IiwgInByb3BlcnRpZXMiOiB7ImFtb3VudCI6ICIwLjAwIiwgImNvdW50eSI6ICJCT1VMREVSIiwgImRhdGFfc291cmNlIjogIkNvb3BlcmF0aXZlIFByb2dyYW0gb2YgQ0RXUiwgTkNXQ0QgXHUwMDI2IFNWTEhXQ0QiLCAiZGF0ZV90aW1lIjogIjIwMjAtMDMtMjRUMTU6MDA6MDAuMDAwIiwgImRpdiI6ICIxIiwgImR3cl9hYmJyZXYiOiAiQ0xPRElUQ08iLCAiZmxhZyI6IG51bGwsICJodHRwX2xpbmthZ2UudXJsIjogImh0dHBzOi8vZHdyLnN0YXRlLmNvLnVzL1N1cmZhY2VXYXRlci9kYXRhL2RldGFpbF9ncmFwaC5hc3B4P0lEPUNMT0RJVENPXHUwMDI2TVRZUEU9RElTQ0hSRyIsICJsb2NhdGlvbi5sYXRpdHVkZSI6IDQwLjE5Mzc1OCwgImxvY2F0aW9uLmxvbmdpdHVkZSI6IC0xMDUuMjEwMzksICJsb2NhdGlvbi5uZWVkc19yZWNvZGluZyI6IGZhbHNlLCAic3RhZ2UiOiBudWxsLCAic3RhdGlvbl9uYW1lIjogIkNMT1VHSCBBTkQgVFJVRSBESVRDSCIsICJzdGF0aW9uX3N0YXR1cyI6ICJBY3RpdmUiLCAic3RhdGlvbl90eXBlIjogIkRpdmVyc2lvbiIsICJ1c2dzX3N0YXRpb25faWQiOiBudWxsLCAidmFyaWFibGUiOiAiRElTQ0hSRyIsICJ3ZCI6ICI1In0sICJ0eXBlIjogIkZlYXR1cmUifSwgeyJiYm94IjogWy0xMDUuMzMwODQxLCA0MC4wMDYzODAwMDAwMDAwMSwgLTEwNS4zMzA4NDEsIDQwLjAwNjM4MDAwMDAwMDAxXSwgImdlb21ldHJ5IjogeyJjb29yZGluYXRlcyI6IFstMTA1LjMzMDg0MSwgNDAuMDA2MzgwMDAwMDAwMDFdLCAidHlwZSI6ICJQb2ludCJ9LCAiaWQiOiAiNSIsICJwcm9wZXJ0aWVzIjogeyJhbW91bnQiOiAiMjAuNDAiLCAiY291bnR5IjogIkJPVUxERVIiLCAiZGF0YV9zb3VyY2UiOiAiQ28uIERpdmlzaW9uIG9mIFdhdGVyIFJlc291cmNlcyIsICJkYXRlX3RpbWUiOiAiMjAyMC0wMy0yNFQxNToxNTowMC4wMDAiLCAiZGl2IjogIjEiLCAiZHdyX2FiYnJldiI6ICJCT0NPUk9DTyIsICJmbGFnIjogIkljZSIsICJodHRwX2xpbmthZ2UudXJsIjogImh0dHBzOi8vZHdyLnN0YXRlLmNvLnVzL1N1cmZhY2VXYXRlci9kYXRhL2RldGFpbF9ncmFwaC5hc3B4P0lEPUJPQ09ST0NPXHUwMDI2TVRZUEU9RElTQ0hSRyIsICJsb2NhdGlvbi5sYXRpdHVkZSI6IDQwLjAwNjM4LCAibG9jYXRpb24ubG9uZ2l0dWRlIjogLTEwNS4zMzA4NDEsICJsb2NhdGlvbi5uZWVkc19yZWNvZGluZyI6IGZhbHNlLCAic3RhZ2UiOiAiMS44NCIsICJzdGF0aW9uX25hbWUiOiAiQk9VTERFUiBDUkVFSyBORUFSIE9ST0RFTEwsIENPLiIsICJzdGF0aW9uX3N0YXR1cyI6ICJBY3RpdmUiLCAic3RhdGlvbl90eXBlIjogIlN0cmVhbSIsICJ1c2dzX3N0YXRpb25faWQiOiAiMDY3MjcwMDAiLCAidmFyaWFibGUiOiAiRElTQ0hSRyIsICJ3ZCI6ICI2In0sICJ0eXBlIjogIkZlYXR1cmUifSwgeyJiYm94IjogWy0xMDUuMjE4Nzc3LCA0MC4yMDQxOTMsIC0xMDUuMjE4Nzc3LCA0MC4yMDQxOTNdLCAiZ2VvbWV0cnkiOiB7ImNvb3JkaW5hdGVzIjogWy0xMDUuMjE4Nzc3LCA0MC4yMDQxOTNdLCAidHlwZSI6ICJQb2ludCJ9LCAiaWQiOiAiNiIsICJwcm9wZXJ0aWVzIjogeyJhbW91bnQiOiAiMC4wMCIsICJjb3VudHkiOiAiQk9VTERFUiIsICJkYXRhX3NvdXJjZSI6ICJDb29wZXJhdGl2ZSBQcm9ncmFtIG9mIENEV1IsIE5DV0NEIFx1MDAyNiBTVkxIV0NEIiwgImRhdGVfdGltZSI6ICIyMDIwLTAzLTI0VDE1OjAwOjAwLjAwMCIsICJkaXYiOiAiMSIsICJkd3JfYWJicmV2IjogIkxPTlNVUENPIiwgImZsYWciOiBudWxsLCAiaHR0cF9saW5rYWdlLnVybCI6ICJodHRwczovL2R3ci5zdGF0ZS5jby51cy9TdXJmYWNlV2F0ZXIvZGF0YS9kZXRhaWxfZ3JhcGguYXNweD9JRD1MT05TVVBDT1x1MDAyNk1UWVBFPURJU0NIUkciLCAibG9jYXRpb24ubGF0aXR1ZGUiOiA0MC4yMDQxOTMsICJsb2NhdGlvbi5sb25naXR1ZGUiOiAtMTA1LjIxODc3NywgImxvY2F0aW9uLm5lZWRzX3JlY29kaW5nIjogZmFsc2UsICJzdGFnZSI6IG51bGwsICJzdGF0aW9uX25hbWUiOiAiTE9OR01PTlQgU1VQUExZIERJVENIIiwgInN0YXRpb25fc3RhdHVzIjogIkFjdGl2ZSIsICJzdGF0aW9uX3R5cGUiOiAiRGl2ZXJzaW9uIiwgInVzZ3Nfc3RhdGlvbl9pZCI6IG51bGwsICJ2YXJpYWJsZSI6ICJESVNDSFJHIiwgIndkIjogIjUifSwgInR5cGUiOiAiRmVhdHVyZSJ9LCB7ImJib3giOiBbLTEwNS4xNjc2MjIsIDQwLjE3MjkyNSwgLTEwNS4xNjc2MjIsIDQwLjE3MjkyNV0sICJnZW9tZXRyeSI6IHsiY29vcmRpbmF0ZXMiOiBbLTEwNS4xNjc2MjIsIDQwLjE3MjkyNV0sICJ0eXBlIjogIlBvaW50In0sICJpZCI6ICI3IiwgInByb3BlcnRpZXMiOiB7ImFtb3VudCI6ICIwLjAwIiwgImNvdW50eSI6ICJCT1VMREVSIiwgImRhdGFfc291cmNlIjogIkNvb3BlcmF0aXZlIFNEUiBQcm9ncmFtIG9mIENEV1IgXHUwMDI2IE5DV0NEIiwgImRhdGVfdGltZSI6ICIyMDIwLTAzLTI0VDE1OjAwOjAwLjAwMCIsICJkaXYiOiAiMSIsICJkd3JfYWJicmV2IjogIk5PUk1VVENPIiwgImZsYWciOiBudWxsLCAiaHR0cF9saW5rYWdlLnVybCI6ICJodHRwczovL2R3ci5zdGF0ZS5jby51cy9TdXJmYWNlV2F0ZXIvZGF0YS9kZXRhaWxfZ3JhcGguYXNweD9JRD1OT1JNVVRDT1x1MDAyNk1UWVBFPURJU0NIUkciLCAibG9jYXRpb24ubGF0aXR1ZGUiOiA0MC4xNzI5MjUsICJsb2NhdGlvbi5sb25naXR1ZGUiOiAtMTA1LjE2NzYyMiwgImxvY2F0aW9uLm5lZWRzX3JlY29kaW5nIjogZmFsc2UsICJzdGFnZSI6IG51bGwsICJzdGF0aW9uX25hbWUiOiAiTk9SVEhXRVNUIE1VVFVBTCBESVRDSCIsICJzdGF0aW9uX3N0YXR1cyI6ICJBY3RpdmUiLCAic3RhdGlvbl90eXBlIjogIkRpdmVyc2lvbiIsICJ1c2dzX3N0YXRpb25faWQiOiBudWxsLCAidmFyaWFibGUiOiAiRElTQ0hSRyIsICJ3ZCI6ICI1In0sICJ0eXBlIjogIkZlYXR1cmUifSwgeyJiYm94IjogWy0xMDUuMTMwODE5LCA0MC4xMzQyNzgsIC0xMDUuMTMwODE5LCA0MC4xMzQyNzhdLCAiZ2VvbWV0cnkiOiB7ImNvb3JkaW5hdGVzIjogWy0xMDUuMTMwODE5LCA0MC4xMzQyNzhdLCAidHlwZSI6ICJQb2ludCJ9LCAiaWQiOiAiOCIsICJwcm9wZXJ0aWVzIjogeyJhbW91bnQiOiAiMy4zNCIsICJjb3VudHkiOiAiQk9VTERFUiIsICJkYXRhX3NvdXJjZSI6ICJVLlMuIEdlb2xvZ2ljYWwgU3VydmV5IiwgImRhdGVfdGltZSI6ICIyMDIwLTAzLTI0VDE1OjEwOjAwLjAwMCIsICJkaXYiOiAiMSIsICJkd3JfYWJicmV2IjogIkxFRlRIT0NPIiwgImZsYWciOiBudWxsLCAiaHR0cF9saW5rYWdlLnVybCI6ICJodHRwczovL3dhdGVyZGF0YS51c2dzLmdvdi9ud2lzL3V2PzA2NzI0OTcwIiwgImxvY2F0aW9uLmxhdGl0dWRlIjogNDAuMTM0Mjc4LCAibG9jYXRpb24ubG9uZ2l0dWRlIjogLTEwNS4xMzA4MTksICJsb2NhdGlvbi5uZWVkc19yZWNvZGluZyI6IGZhbHNlLCAic3RhZ2UiOiBudWxsLCAic3RhdGlvbl9uYW1lIjogIkxFRlQgSEFORCBDUkVFSyBBVCBIT1ZFUiBST0FEIE5FQVIgTE9OR01PTlQsIENPIiwgInN0YXRpb25fc3RhdHVzIjogIkFjdGl2ZSIsICJzdGF0aW9uX3R5cGUiOiAiU3RyZWFtIiwgInVzZ3Nfc3RhdGlvbl9pZCI6ICIwNjcyNDk3MCIsICJ2YXJpYWJsZSI6ICJESVNDSFJHIiwgIndkIjogIjUifSwgInR5cGUiOiAiRmVhdHVyZSJ9LCB7ImJib3giOiBbLTEwNS4yMTg2NzcsIDM5Ljk4NjE2OSwgLTEwNS4yMTg2NzcsIDM5Ljk4NjE2OV0sICJnZW9tZXRyeSI6IHsiY29vcmRpbmF0ZXMiOiBbLTEwNS4yMTg2NzcsIDM5Ljk4NjE2OV0sICJ0eXBlIjogIlBvaW50In0sICJpZCI6ICI5IiwgInByb3BlcnRpZXMiOiB7ImFtb3VudCI6ICIwLjAwIiwgImNvdW50eSI6ICJCT1VMREVSIiwgImRhdGFfc291cmNlIjogIkNvb3BlcmF0aXZlIFByb2dyYW0gb2YgQ0RXUiwgTkNXQ0QgXHUwMDI2IExTUFdDRCIsICJkYXRlX3RpbWUiOiAiMjAyMC0wMy0yNFQxNDowMDowMC4wMDAiLCAiZGl2IjogIjEiLCAiZHdyX2FiYnJldiI6ICJEUllDQVJDTyIsICJmbGFnIjogbnVsbCwgImh0dHBfbGlua2FnZS51cmwiOiAiaHR0cHM6Ly9kd3Iuc3RhdGUuY28udXMvU3VyZmFjZVdhdGVyL2RhdGEvZGV0YWlsX2dyYXBoLmFzcHg/SUQ9RFJZQ0FSQ09cdTAwMjZNVFlQRT1ESVNDSFJHIiwgImxvY2F0aW9uLmxhdGl0dWRlIjogMzkuOTg2MTY5LCAibG9jYXRpb24ubG9uZ2l0dWRlIjogLTEwNS4yMTg2NzcsICJsb2NhdGlvbi5uZWVkc19yZWNvZGluZyI6IGZhbHNlLCAic3RhZ2UiOiBudWxsLCAic3RhdGlvbl9uYW1lIjogIkRSWSBDUkVFSyBDQVJSSUVSIiwgInN0YXRpb25fc3RhdHVzIjogIkFjdGl2ZSIsICJzdGF0aW9uX3R5cGUiOiAiRGl2ZXJzaW9uIiwgInVzZ3Nfc3RhdGlvbl9pZCI6IG51bGwsICJ2YXJpYWJsZSI6ICJESVNDSFJHIiwgIndkIjogIjYifSwgInR5cGUiOiAiRmVhdHVyZSJ9LCB7ImJib3giOiBbLTEwNS4xNjg0NzEsIDQwLjE2MDcwNSwgLTEwNS4xNjg0NzEsIDQwLjE2MDcwNV0sICJnZW9tZXRyeSI6IHsiY29vcmRpbmF0ZXMiOiBbLTEwNS4xNjg0NzEsIDQwLjE2MDcwNV0sICJ0eXBlIjogIlBvaW50In0sICJpZCI6ICIxMCIsICJwcm9wZXJ0aWVzIjogeyJhbW91bnQiOiAiMC4wMCIsICJjb3VudHkiOiAiQk9VTERFUiIsICJkYXRhX3NvdXJjZSI6ICJDby4gRGl2aXNpb24gb2YgV2F0ZXIgUmVzb3VyY2VzIiwgImRhdGVfdGltZSI6ICIyMDIwLTAzLTI0VDEzOjQ1OjAwLjAwMCIsICJkaXYiOiAiMSIsICJkd3JfYWJicmV2IjogIlBFQ1JUTkNPIiwgImZsYWciOiBudWxsLCAiaHR0cF9saW5rYWdlLnVybCI6ICJodHRwczovL2R3ci5zdGF0ZS5jby51cy9TdXJmYWNlV2F0ZXIvZGF0YS9kZXRhaWxfZ3JhcGguYXNweD9JRD1QRUNSVE5DT1x1MDAyNk1UWVBFPURJU0NIUkciLCAibG9jYXRpb24ubGF0aXR1ZGUiOiA0MC4xNjA3MDUsICJsb2NhdGlvbi5sb25naXR1ZGUiOiAtMTA1LjE2ODQ3MSwgImxvY2F0aW9uLm5lZWRzX3JlY29kaW5nIjogZmFsc2UsICJzdGFnZSI6IG51bGwsICJzdGF0aW9uX25hbWUiOiAiUEVDSy1QRUxMQSBBVUdNRU5UQVRJT04gUkVUVVJOIiwgInN0YXRpb25fc3RhdHVzIjogIkFjdGl2ZSIsICJzdGF0aW9uX3R5cGUiOiAiRGl2ZXJzaW9uIiwgInVzZ3Nfc3RhdGlvbl9pZCI6IG51bGwsICJ2YXJpYWJsZSI6ICJESVNDSFJHIiwgIndkIjogIjUifSwgInR5cGUiOiAiRmVhdHVyZSJ9LCB7ImJib3giOiBbLTEwNS4yMjI2MzksIDQwLjE5OTMyMSwgLTEwNS4yMjI2MzksIDQwLjE5OTMyMV0sICJnZW9tZXRyeSI6IHsiY29vcmRpbmF0ZXMiOiBbLTEwNS4yMjI2MzksIDQwLjE5OTMyMV0sICJ0eXBlIjogIlBvaW50In0sICJpZCI6ICIxMSIsICJwcm9wZXJ0aWVzIjogeyJhbW91bnQiOiAiMC4wMCIsICJjb3VudHkiOiAiQk9VTERFUiIsICJkYXRhX3NvdXJjZSI6ICJDb29wZXJhdGl2ZSBQcm9ncmFtIG9mIENEV1IsIE5DV0NEIFx1MDAyNiBTVkxIV0NEIiwgImRhdGVfdGltZSI6ICIyMDIwLTAzLTI0VDE0OjQ1OjAwLjAwMCIsICJkaXYiOiAiMSIsICJkd3JfYWJicmV2IjogIkdPRElUMUNPIiwgImZsYWciOiBudWxsLCAiaHR0cF9saW5rYWdlLnVybCI6ICJodHRwczovL2R3ci5zdGF0ZS5jby51cy9TdXJmYWNlV2F0ZXIvZGF0YS9kZXRhaWxfZ3JhcGguYXNweD9JRD1HT0RJVDFDT1x1MDAyNk1UWVBFPURJU0NIUkciLCAibG9jYXRpb24ubGF0aXR1ZGUiOiA0MC4xOTkzMjEsICJsb2NhdGlvbi5sb25naXR1ZGUiOiAtMTA1LjIyMjYzOSwgImxvY2F0aW9uLm5lZWRzX3JlY29kaW5nIjogZmFsc2UsICJzdGFnZSI6IG51bGwsICJzdGF0aW9uX25hbWUiOiAiR09TUyBESVRDSCAxIiwgInN0YXRpb25fc3RhdHVzIjogIkFjdGl2ZSIsICJzdGF0aW9uX3R5cGUiOiAiRGl2ZXJzaW9uIiwgInVzZ3Nfc3RhdGlvbl9pZCI6IG51bGwsICJ2YXJpYWJsZSI6ICJESVNDSFJHIiwgIndkIjogIjUifSwgInR5cGUiOiAiRmVhdHVyZSJ9LCB7ImJib3giOiBbLTEwNS4yMTA0MjQsIDQwLjE5MzI4MDAwMDAwMDAxLCAtMTA1LjIxMDQyNCwgNDAuMTkzMjgwMDAwMDAwMDFdLCAiZ2VvbWV0cnkiOiB7ImNvb3JkaW5hdGVzIjogWy0xMDUuMjEwNDI0LCA0MC4xOTMyODAwMDAwMDAwMV0sICJ0eXBlIjogIlBvaW50In0sICJpZCI6ICIxMiIsICJwcm9wZXJ0aWVzIjogeyJhbW91bnQiOiAiMC4wMCIsICJjb3VudHkiOiAiQk9VTERFUiIsICJkYXRhX3NvdXJjZSI6ICJDb29wZXJhdGl2ZSBQcm9ncmFtIG9mIENEV1IsIE5DV0NEIFx1MDAyNiBTVkxIV0NEIiwgImRhdGVfdGltZSI6ICIyMDIwLTAzLTI0VDE1OjAwOjAwLjAwMCIsICJkaXYiOiAiMSIsICJkd3JfYWJicmV2IjogIldFQkRJVENPIiwgImZsYWciOiBudWxsLCAiaHR0cF9saW5rYWdlLnVybCI6ICJodHRwczovL2R3ci5zdGF0ZS5jby51cy9TdXJmYWNlV2F0ZXIvZGF0YS9kZXRhaWxfZ3JhcGguYXNweD9JRD1XRUJESVRDT1x1MDAyNk1UWVBFPURJU0NIUkciLCAibG9jYXRpb24ubGF0aXR1ZGUiOiA0MC4xOTMyOCwgImxvY2F0aW9uLmxvbmdpdHVkZSI6IC0xMDUuMjEwNDI0LCAibG9jYXRpb24ubmVlZHNfcmVjb2RpbmciOiBmYWxzZSwgInN0YWdlIjogbnVsbCwgInN0YXRpb25fbmFtZSI6ICJXRUJTVEVSIE1DQ0FTTElOIERJVENIIiwgInN0YXRpb25fc3RhdHVzIjogIkFjdGl2ZSIsICJzdGF0aW9uX3R5cGUiOiAiRGl2ZXJzaW9uIiwgInVzZ3Nfc3RhdGlvbl9pZCI6IG51bGwsICJ2YXJpYWJsZSI6ICJESVNDSFJHIiwgIndkIjogIjUifSwgInR5cGUiOiAiRmVhdHVyZSJ9LCB7ImJib3giOiBbLTEwNS4xNTExNDMsIDQwLjA1MzY2MSwgLTEwNS4xNTExNDMsIDQwLjA1MzY2MV0sICJnZW9tZXRyeSI6IHsiY29vcmRpbmF0ZXMiOiBbLTEwNS4xNTExNDMsIDQwLjA1MzY2MV0sICJ0eXBlIjogIlBvaW50In0sICJpZCI6ICIxMyIsICJwcm9wZXJ0aWVzIjogeyJhbW91bnQiOiAiMi42MyIsICJjb3VudHkiOiAiQk9VTERFUiIsICJkYXRhX3NvdXJjZSI6ICJDb29wZXJhdGl2ZSBQcm9ncmFtIG9mIENEV1IsIE5DV0NEIFx1MDAyNiBMU1BXQ0QiLCAiZGF0ZV90aW1lIjogIjIwMjAtMDMtMjRUMTU6MDA6MDAuMDAwIiwgImRpdiI6ICIxIiwgImR3cl9hYmJyZXYiOiAiTEVHRElUQ08iLCAiZmxhZyI6IG51bGwsICJodHRwX2xpbmthZ2UudXJsIjogImh0dHBzOi8vZHdyLnN0YXRlLmNvLnVzL1N1cmZhY2VXYXRlci9kYXRhL2RldGFpbF9ncmFwaC5hc3B4P0lEPUxFR0RJVENPXHUwMDI2TVRZUEU9RElTQ0hSRyIsICJsb2NhdGlvbi5sYXRpdHVkZSI6IDQwLjA1MzY2MSwgImxvY2F0aW9uLmxvbmdpdHVkZSI6IC0xMDUuMTUxMTQzLCAibG9jYXRpb24ubmVlZHNfcmVjb2RpbmciOiBmYWxzZSwgInN0YWdlIjogIjAuMjEiLCAic3RhdGlvbl9uYW1lIjogIkxFR0dFVFQgRElUQ0giLCAic3RhdGlvbl9zdGF0dXMiOiAiQWN0aXZlIiwgInN0YXRpb25fdHlwZSI6ICJEaXZlcnNpb24iLCAidXNnc19zdGF0aW9uX2lkIjogbnVsbCwgInZhcmlhYmxlIjogIkRJU0NIUkciLCAid2QiOiAiNiJ9LCAidHlwZSI6ICJGZWF0dXJlIn0sIHsiYmJveCI6IFstMTA1LjM2NTM2NSwgNDAuMjE2MjYzLCAtMTA1LjM2NTM2NSwgNDAuMjE2MjYzXSwgImdlb21ldHJ5IjogeyJjb29yZGluYXRlcyI6IFstMTA1LjM2NTM2NSwgNDAuMjE2MjYzXSwgInR5cGUiOiAiUG9pbnQifSwgImlkIjogIjE0IiwgInByb3BlcnRpZXMiOiB7ImFtb3VudCI6ICIxMjkxMS4wMCIsICJjb3VudHkiOiAiQk9VTERFUiIsICJkYXRhX3NvdXJjZSI6ICJDby4gRGl2aXNpb24gb2YgV2F0ZXIgUmVzb3VyY2VzIiwgImRhdGVfdGltZSI6ICIyMDIwLTAzLTI0VDE0OjQ1OjAwLjAwMCIsICJkaXYiOiAiMSIsICJkd3JfYWJicmV2IjogIkJSS0RBTUNPIiwgImZsYWciOiBudWxsLCAiaHR0cF9saW5rYWdlLnVybCI6ICJodHRwczovL2R3ci5zdGF0ZS5jby51cy9TdXJmYWNlV2F0ZXIvZGF0YS9kZXRhaWxfZ3JhcGguYXNweD9JRD1CUktEQU1DT1x1MDAyNk1UWVBFPVNUT1JBR0UiLCAibG9jYXRpb24ubGF0aXR1ZGUiOiA0MC4yMTYyNjMsICJsb2NhdGlvbi5sb25naXR1ZGUiOiAtMTA1LjM2NTM2NSwgImxvY2F0aW9uLm5lZWRzX3JlY29kaW5nIjogZmFsc2UsICJzdGFnZSI6ICI2Mzg0LjE3IiwgInN0YXRpb25fbmFtZSI6ICJCVVRUT05ST0NLIChSQUxQSCBQUklDRSkgUkVTRVJWT0lSIiwgInN0YXRpb25fc3RhdHVzIjogIkFjdGl2ZSIsICJzdGF0aW9uX3R5cGUiOiAiUmVzZXJ2b2lyIiwgInVzZ3Nfc3RhdGlvbl9pZCI6IG51bGwsICJ2YXJpYWJsZSI6ICJTVE9SQUdFIiwgIndkIjogIjUifSwgInR5cGUiOiAiRmVhdHVyZSJ9LCB7ImJib3giOiBbLTEwNS4yMDk1LCA0MC4yNTU3NzYsIC0xMDUuMjA5NSwgNDAuMjU1Nzc2XSwgImdlb21ldHJ5IjogeyJjb29yZGluYXRlcyI6IFstMTA1LjIwOTUsIDQwLjI1NTc3Nl0sICJ0eXBlIjogIlBvaW50In0sICJpZCI6ICIxNSIsICJwcm9wZXJ0aWVzIjogeyJhbW91bnQiOiAiMC4xMCIsICJjb3VudHkiOiAiQk9VTERFUiIsICJkYXRhX3NvdXJjZSI6ICJOb3J0aGVybiBDb2xvcmFkbyBXYXRlciBDb25zZXJ2YW5jeSBEaXN0cmljdCIsICJkYXRlX3RpbWUiOiAiMjAyMC0wMy0yNFQxNDowMDowMC4wMDAiLCAiZGl2IjogIjEiLCAiZHdyX2FiYnJldiI6ICJMSVRUSDJDTyIsICJmbGFnIjogbnVsbCwgImh0dHBfbGlua2FnZS51cmwiOiAiaHR0cDovL3d3dy5ub3J0aGVybndhdGVyLm9yZy9XYXRlclByb2plY3RzL1dhdGVyRGF0YS5hc3B4RWFzdFNsb3BlV2F0ZXJEYXRhLmFzcHgiLCAibG9jYXRpb24ubGF0aXR1ZGUiOiA0MC4yNTU3NzYsICJsb2NhdGlvbi5sb25naXR1ZGUiOiAtMTA1LjIwOTUsICJsb2NhdGlvbi5uZWVkc19yZWNvZGluZyI6IGZhbHNlLCAic3RhZ2UiOiAiMC4xMCIsICJzdGF0aW9uX25hbWUiOiAiTElUVExFIFRIT01QU09OICMyIERJVENIIiwgInN0YXRpb25fc3RhdHVzIjogIkFjdGl2ZSIsICJzdGF0aW9uX3R5cGUiOiAiRGl2ZXJzaW9uIiwgInVzZ3Nfc3RhdGlvbl9pZCI6ICJFUzE5MDAiLCAidmFyaWFibGUiOiAiRElTQ0hSRyIsICJ3ZCI6ICI0In0sICJ0eXBlIjogIkZlYXR1cmUifSwgeyJiYm94IjogWy0xMDUuMTY0Mzk3LCA0MC4yNTc4NDQsIC0xMDUuMTY0Mzk3LCA0MC4yNTc4NDRdLCAiZ2VvbWV0cnkiOiB7ImNvb3JkaW5hdGVzIjogWy0xMDUuMTY0Mzk3LCA0MC4yNTc4NDRdLCAidHlwZSI6ICJQb2ludCJ9LCAiaWQiOiAiMTYiLCAicHJvcGVydGllcyI6IHsiYW1vdW50IjogIjAuMDEiLCAiY291bnR5IjogIkJPVUxERVIiLCAiZGF0YV9zb3VyY2UiOiAiQ29vcGVyYXRpdmUgU0RSIFByb2dyYW0gb2YgQ0RXUiBcdTAwMjYgTkNXQ0QiLCAiZGF0ZV90aW1lIjogIjIwMjAtMDMtMjRUMTU6MDA6MDAuMDAwIiwgImRpdiI6ICIxIiwgImR3cl9hYmJyZXYiOiAiQkxXRElUQ08iLCAiZmxhZyI6IG51bGwsICJodHRwX2xpbmthZ2UudXJsIjogImh0dHBzOi8vZHdyLnN0YXRlLmNvLnVzL1N1cmZhY2VXYXRlci9kYXRhL2RldGFpbF9ncmFwaC5hc3B4P0lEPUJMV0RJVENPXHUwMDI2TVRZUEU9RElTQ0hSRyIsICJsb2NhdGlvbi5sYXRpdHVkZSI6IDQwLjI1Nzg0NCwgImxvY2F0aW9uLmxvbmdpdHVkZSI6IC0xMDUuMTY0Mzk3LCAibG9jYXRpb24ubmVlZHNfcmVjb2RpbmciOiBmYWxzZSwgInN0YWdlIjogIjAuMDMiLCAic3RhdGlvbl9uYW1lIjogIkJMT1dFUiBESVRDSCIsICJzdGF0aW9uX3N0YXR1cyI6ICJBY3RpdmUiLCAic3RhdGlvbl90eXBlIjogIkRpdmVyc2lvbiIsICJ1c2dzX3N0YXRpb25faWQiOiBudWxsLCAidmFyaWFibGUiOiAiRElTQ0hSRyIsICJ3ZCI6ICI0In0sICJ0eXBlIjogIkZlYXR1cmUifSwgeyJiYm94IjogWy0xMDUuMzA0OTksIDM5LjkzMTU5NywgLTEwNS4zMDQ5OSwgMzkuOTMxNTk3XSwgImdlb21ldHJ5IjogeyJjb29yZGluYXRlcyI6IFstMTA1LjMwNDk5LCAzOS45MzE1OTddLCAidHlwZSI6ICJQb2ludCJ9LCAiaWQiOiAiMTciLCAicHJvcGVydGllcyI6IHsiYW1vdW50IjogIjE3LjIwIiwgImNvdW50eSI6ICJCT1VMREVSIiwgImRhdGFfc291cmNlIjogIkNvLiBEaXZpc2lvbiBvZiBXYXRlciBSZXNvdXJjZXMiLCAiZGF0ZV90aW1lIjogIjIwMjAtMDMtMjRUMTU6MTU6MDAuMDAwIiwgImRpdiI6ICIxIiwgImR3cl9hYmJyZXYiOiAiQk9DRUxTQ08iLCAiZmxhZyI6ICJJY2UiLCAiaHR0cF9saW5rYWdlLnVybCI6ICJodHRwczovL2R3ci5zdGF0ZS5jby51cy9TdXJmYWNlV2F0ZXIvZGF0YS9kZXRhaWxfZ3JhcGguYXNweD9JRD1CT0NFTFNDT1x1MDAyNk1UWVBFPURJU0NIUkciLCAibG9jYXRpb24ubGF0aXR1ZGUiOiAzOS45MzE1OTcsICJsb2NhdGlvbi5sb25naXR1ZGUiOiAtMTA1LjMwNDk5LCAibG9jYXRpb24ubmVlZHNfcmVjb2RpbmciOiBmYWxzZSwgInN0YWdlIjogIjIuMjMiLCAic3RhdGlvbl9uYW1lIjogIlNPVVRIIEJPVUxERVIgQ1JFRUsgTkVBUiBFTERPUkFETyBTUFJJTkdTLCBDTy4iLCAic3RhdGlvbl9zdGF0dXMiOiAiQWN0aXZlIiwgInN0YXRpb25fdHlwZSI6ICJTdHJlYW0iLCAidXNnc19zdGF0aW9uX2lkIjogbnVsbCwgInZhcmlhYmxlIjogIkRJU0NIUkciLCAid2QiOiAiNiJ9LCAidHlwZSI6ICJGZWF0dXJlIn0sIHsiYmJveCI6IFstMTA1LjE3ODg3NSwgNDAuMDUxNjUyLCAtMTA1LjE3ODg3NSwgNDAuMDUxNjUyXSwgImdlb21ldHJ5IjogeyJjb29yZGluYXRlcyI6IFstMTA1LjE3ODg3NSwgNDAuMDUxNjUyXSwgInR5cGUiOiAiUG9pbnQifSwgImlkIjogIjE4IiwgInByb3BlcnRpZXMiOiB7ImFtb3VudCI6ICIzMC4yMCIsICJjb3VudHkiOiAiQk9VTERFUiIsICJkYXRhX3NvdXJjZSI6ICJVLlMuIEdlb2xvZ2ljYWwgU3VydmV5IiwgImRhdGVfdGltZSI6ICIyMDIwLTAzLTI0VDE1OjE1OjAwLjAwMCIsICJkaXYiOiAiMSIsICJkd3JfYWJicmV2IjogIkJPQ05PUkNPIiwgImZsYWciOiBudWxsLCAiaHR0cF9saW5rYWdlLnVybCI6ICJodHRwczovL3dhdGVyZGF0YS51c2dzLmdvdi9ud2lzL3V2PzA2NzMwMjAwIiwgImxvY2F0aW9uLmxhdGl0dWRlIjogNDAuMDUxNjUyLCAibG9jYXRpb24ubG9uZ2l0dWRlIjogLTEwNS4xNzg4NzUsICJsb2NhdGlvbi5uZWVkc19yZWNvZGluZyI6IGZhbHNlLCAic3RhZ2UiOiBudWxsLCAic3RhdGlvbl9uYW1lIjogIkJPVUxERVIgQ1JFRUsgQVQgTk9SVEggNzVUSCBTVC4gTkVBUiBCT1VMREVSLCBDTyIsICJzdGF0aW9uX3N0YXR1cyI6ICJBY3RpdmUiLCAic3RhdGlvbl90eXBlIjogIlN0cmVhbSIsICJ1c2dzX3N0YXRpb25faWQiOiAiMDY3MzAyMDAiLCAidmFyaWFibGUiOiAiRElTQ0hSRyIsICJ3ZCI6ICI2In0sICJ0eXBlIjogIkZlYXR1cmUifSwgeyJiYm94IjogWy0xMDUuMTYwODc2LCA0MC4xNzA5OTgsIC0xMDUuMTYwODc2LCA0MC4xNzA5OThdLCAiZ2VvbWV0cnkiOiB7ImNvb3JkaW5hdGVzIjogWy0xMDUuMTYwODc2LCA0MC4xNzA5OThdLCAidHlwZSI6ICJQb2ludCJ9LCAiaWQiOiAiMTkiLCAicHJvcGVydGllcyI6IHsiYW1vdW50IjogIjAuMzgiLCAiY291bnR5IjogIkJPVUxERVIiLCAiZGF0YV9zb3VyY2UiOiAiQ29vcGVyYXRpdmUgUHJvZ3JhbSBvZiBDRFdSLCBOQ1dDRCBcdTAwMjYgU1ZMSFdDRCIsICJkYXRlX3RpbWUiOiAiMjAyMC0wMy0yNFQxNTowMDowMC4wMDAiLCAiZGl2IjogIjEiLCAiZHdyX2FiYnJldiI6ICJTRkxESVRDTyIsICJmbGFnIjogbnVsbCwgImh0dHBfbGlua2FnZS51cmwiOiAiaHR0cHM6Ly9kd3Iuc3RhdGUuY28udXMvU3VyZmFjZVdhdGVyL2RhdGEvZGV0YWlsX2dyYXBoLmFzcHg/SUQ9U0ZMRElUQ09cdTAwMjZNVFlQRT1ESVNDSFJHIiwgImxvY2F0aW9uLmxhdGl0dWRlIjogNDAuMTcwOTk4LCAibG9jYXRpb24ubG9uZ2l0dWRlIjogLTEwNS4xNjA4NzYsICJsb2NhdGlvbi5uZWVkc19yZWNvZGluZyI6IGZhbHNlLCAic3RhZ2UiOiAiMC4xMSIsICJzdGF0aW9uX25hbWUiOiAiU09VVEggRkxBVCBESVRDSCIsICJzdGF0aW9uX3N0YXR1cyI6ICJBY3RpdmUiLCAic3RhdGlvbl90eXBlIjogIkRpdmVyc2lvbiIsICJ1c2dzX3N0YXRpb25faWQiOiBudWxsLCAidmFyaWFibGUiOiAiRElTQ0hSRyIsICJ3ZCI6ICI1In0sICJ0eXBlIjogIkZlYXR1cmUifSwgeyJiYm94IjogWy0xMDUuMDc1Njk1MDAwMDAwMDEsIDQwLjE1MzM0MSwgLTEwNS4wNzU2OTUwMDAwMDAwMSwgNDAuMTUzMzQxXSwgImdlb21ldHJ5IjogeyJjb29yZGluYXRlcyI6IFstMTA1LjA3NTY5NTAwMDAwMDAxLCA0MC4xNTMzNDFdLCAidHlwZSI6ICJQb2ludCJ9LCAiaWQiOiAiMjAiLCAicHJvcGVydGllcyI6IHsiYW1vdW50IjogIjM0LjQwIiwgImNvdW50eSI6ICJCT1VMREVSIiwgImRhdGFfc291cmNlIjogIkNvLiBEaXZpc2lvbiBvZiBXYXRlciBSZXNvdXJjZXMiLCAiZGF0ZV90aW1lIjogIjIwMjAtMDMtMjRUMTQ6MzA6MDAuMDAwIiwgImRpdiI6ICIxIiwgImR3cl9hYmJyZXYiOiAiU1ZDTE9QQ08iLCAiZmxhZyI6IG51bGwsICJodHRwX2xpbmthZ2UudXJsIjogImh0dHBzOi8vZHdyLnN0YXRlLmNvLnVzL1N1cmZhY2VXYXRlci9kYXRhL2RldGFpbF9ncmFwaC5hc3B4P0lEPVNWQ0xPUENPXHUwMDI2TVRZUEU9RElTQ0hSRyIsICJsb2NhdGlvbi5sYXRpdHVkZSI6IDQwLjE1MzM0MSwgImxvY2F0aW9uLmxvbmdpdHVkZSI6IC0xMDUuMDc1Njk1LCAibG9jYXRpb24ubmVlZHNfcmVjb2RpbmciOiBmYWxzZSwgInN0YWdlIjogIjMuNTQiLCAic3RhdGlvbl9uYW1lIjogIlNBSU5UIFZSQUlOIENSRUVLIEJFTE9XIEtFTiBQUkFUVCBCTFZEIEFUIExPTkdNT05ULCBDTyIsICJzdGF0aW9uX3N0YXR1cyI6ICJBY3RpdmUiLCAic3RhdGlvbl90eXBlIjogIlN0cmVhbSIsICJ1c2dzX3N0YXRpb25faWQiOiBudWxsLCAidmFyaWFibGUiOiAiRElTQ0hSRyIsICJ3ZCI6ICI1In0sICJ0eXBlIjogIkZlYXR1cmUifSwgeyJiYm94IjogWy0xMDUuNTA0NDQsIDM5Ljk2MTY1NSwgLTEwNS41MDQ0NCwgMzkuOTYxNjU1XSwgImdlb21ldHJ5IjogeyJjb29yZGluYXRlcyI6IFstMTA1LjUwNDQ0LCAzOS45NjE2NTVdLCAidHlwZSI6ICJQb2ludCJ9LCAiaWQiOiAiMjEiLCAicHJvcGVydGllcyI6IHsiYW1vdW50IjogIjI0LjYwIiwgImNvdW50eSI6ICJCT1VMREVSIiwgImRhdGFfc291cmNlIjogIkNvLiBEaXZpc2lvbiBvZiBXYXRlciBSZXNvdXJjZXMiLCAiZGF0ZV90aW1lIjogIjIwMjAtMDMtMjRUMTU6MTU6MDAuMDAwIiwgImRpdiI6ICIxIiwgImR3cl9hYmJyZXYiOiAiQk9DTUlEQ08iLCAiZmxhZyI6IG51bGwsICJodHRwX2xpbmthZ2UudXJsIjogImh0dHBzOi8vZHdyLnN0YXRlLmNvLnVzL1N1cmZhY2VXYXRlci9kYXRhL2RldGFpbF9ncmFwaC5hc3B4P0lEPUJPQ01JRENPXHUwMDI2TVRZUEU9RElTQ0hSRyIsICJsb2NhdGlvbi5sYXRpdHVkZSI6IDM5Ljk2MTY1NSwgImxvY2F0aW9uLmxvbmdpdHVkZSI6IC0xMDUuNTA0NDQsICJsb2NhdGlvbi5uZWVkc19yZWNvZGluZyI6IGZhbHNlLCAic3RhZ2UiOiAiMS4xNCIsICJzdGF0aW9uX25hbWUiOiAiTUlERExFIEJPVUxERVIgQ1JFRUsgQVQgTkVERVJMQU5ELCBDTy4iLCAic3RhdGlvbl9zdGF0dXMiOiAiQWN0aXZlIiwgInN0YXRpb25fdHlwZSI6ICJTdHJlYW0iLCAidXNnc19zdGF0aW9uX2lkIjogIjA2NzI1NTAwIiwgInZhcmlhYmxlIjogIkRJU0NIUkciLCAid2QiOiAiNiJ9LCAidHlwZSI6ICJGZWF0dXJlIn0sIHsiYmJveCI6IFstMTA1LjA5Nzg3MiwgNDAuMDU5ODA5LCAtMTA1LjA5Nzg3MiwgNDAuMDU5ODA5XSwgImdlb21ldHJ5IjogeyJjb29yZGluYXRlcyI6IFstMTA1LjA5Nzg3MiwgNDAuMDU5ODA5XSwgInR5cGUiOiAiUG9pbnQifSwgImlkIjogIjIyIiwgInByb3BlcnRpZXMiOiB7ImFtb3VudCI6ICI1MC4yMCIsICJjb3VudHkiOiAiQk9VTERFUiIsICJkYXRhX3NvdXJjZSI6ICJDby4gRGl2aXNpb24gb2YgV2F0ZXIgUmVzb3VyY2VzIiwgImRhdGVfdGltZSI6ICIyMDIwLTAzLTI0VDE0OjQ1OjAwLjAwMCIsICJkaXYiOiAiMSIsICJkd3JfYWJicmV2IjogIkJPQzEwOUNPIiwgImZsYWciOiBudWxsLCAiaHR0cF9saW5rYWdlLnVybCI6ICJodHRwczovL2R3ci5zdGF0ZS5jby51cy9TdXJmYWNlV2F0ZXIvZGF0YS9kZXRhaWxfZ3JhcGguYXNweD9JRD1CT0MxMDlDT1x1MDAyNk1UWVBFPURJU0NIUkciLCAibG9jYXRpb24ubGF0aXR1ZGUiOiA0MC4wNTk4MDksICJsb2NhdGlvbi5sb25naXR1ZGUiOiAtMTA1LjA5Nzg3MiwgImxvY2F0aW9uLm5lZWRzX3JlY29kaW5nIjogZmFsc2UsICJzdGFnZSI6ICIyLjU3IiwgInN0YXRpb25fbmFtZSI6ICJCT1VMREVSIENSRUVLIEFUIDEwOSBTVCBORUFSIEVSSUUsIENPIiwgInN0YXRpb25fc3RhdHVzIjogIkFjdGl2ZSIsICJzdGF0aW9uX3R5cGUiOiAiU3RyZWFtIiwgInVzZ3Nfc3RhdGlvbl9pZCI6IG51bGwsICJ2YXJpYWJsZSI6ICJESVNDSFJHIiwgIndkIjogIjYifSwgInR5cGUiOiAiRmVhdHVyZSJ9LCB7ImJib3giOiBbLTEwNS4zNjM0MjIsIDQwLjIxNTY1OCwgLTEwNS4zNjM0MjIsIDQwLjIxNTY1OF0sICJnZW9tZXRyeSI6IHsiY29vcmRpbmF0ZXMiOiBbLTEwNS4zNjM0MjIsIDQwLjIxNTY1OF0sICJ0eXBlIjogIlBvaW50In0sICJpZCI6ICIyMyIsICJwcm9wZXJ0aWVzIjogeyJhbW91bnQiOiAiMTkuMzAiLCAiY291bnR5IjogIkJPVUxERVIiLCAiZGF0YV9zb3VyY2UiOiAiQ28uIERpdmlzaW9uIG9mIFdhdGVyIFJlc291cmNlcyIsICJkYXRlX3RpbWUiOiAiMjAyMC0wMy0yNFQxNDo0NTowMC4wMDAiLCAiZGl2IjogIjEiLCAiZHdyX2FiYnJldiI6ICJOU1ZCQlJDTyIsICJmbGFnIjogbnVsbCwgImh0dHBfbGlua2FnZS51cmwiOiAiaHR0cHM6Ly9kd3Iuc3RhdGUuY28udXMvU3VyZmFjZVdhdGVyL2RhdGEvZGV0YWlsX2dyYXBoLmFzcHg/SUQ9TlNWQkJSQ09cdTAwMjZNVFlQRT1ESVNDSFJHIiwgImxvY2F0aW9uLmxhdGl0dWRlIjogNDAuMjE1NjU4LCAibG9jYXRpb24ubG9uZ2l0dWRlIjogLTEwNS4zNjM0MjIsICJsb2NhdGlvbi5uZWVkc19yZWNvZGluZyI6IGZhbHNlLCAic3RhZ2UiOiAiMC4zNCIsICJzdGF0aW9uX25hbWUiOiAiTk9SVEggU0FJTlQgVlJBSU4gQ1JFRUsgQkVMT1cgQlVUVE9OUk9DSyAgKFJBTFBIIFBSSUNFKSBSRVNFUlZPSVIiLCAic3RhdGlvbl9zdGF0dXMiOiAiQWN0aXZlIiwgInN0YXRpb25fdHlwZSI6ICJTdHJlYW0iLCAidXNnc19zdGF0aW9uX2lkIjogbnVsbCwgInZhcmlhYmxlIjogIkRJU0NIUkciLCAid2QiOiAiNSJ9LCAidHlwZSI6ICJGZWF0dXJlIn0sIHsiYmJveCI6IFstMTA1LjMwNDQwNCwgNDAuMTI2Mzg5LCAtMTA1LjMwNDQwNCwgNDAuMTI2Mzg5XSwgImdlb21ldHJ5IjogeyJjb29yZGluYXRlcyI6IFstMTA1LjMwNDQwNCwgNDAuMTI2Mzg5XSwgInR5cGUiOiAiUG9pbnQifSwgImlkIjogIjI0IiwgInByb3BlcnRpZXMiOiB7ImFtb3VudCI6ICIxMi42MCIsICJjb3VudHkiOiAiQk9VTERFUiIsICJkYXRhX3NvdXJjZSI6ICJDby4gRGl2aXNpb24gb2YgV2F0ZXIgUmVzb3VyY2VzIiwgImRhdGVfdGltZSI6ICIyMDIwLTAzLTI0VDE1OjE1OjAwLjAwMCIsICJkaXYiOiAiMSIsICJkd3JfYWJicmV2IjogIkxFRkNSRUNPIiwgImZsYWciOiBudWxsLCAiaHR0cF9saW5rYWdlLnVybCI6ICJodHRwczovL2R3ci5zdGF0ZS5jby51cy9TdXJmYWNlV2F0ZXIvZGF0YS9kZXRhaWxfZ3JhcGguYXNweD9JRD1MRUZDUkVDT1x1MDAyNk1UWVBFPURJU0NIUkciLCAibG9jYXRpb24ubGF0aXR1ZGUiOiA0MC4xMjYzODksICJsb2NhdGlvbi5sb25naXR1ZGUiOiAtMTA1LjMwNDQwNCwgImxvY2F0aW9uLm5lZWRzX3JlY29kaW5nIjogZmFsc2UsICJzdGFnZSI6ICIwLjQ2IiwgInN0YXRpb25fbmFtZSI6ICJMRUZUIEhBTkQgQ1JFRUsgTkVBUiBCT1VMREVSLCBDTy4iLCAic3RhdGlvbl9zdGF0dXMiOiAiQWN0aXZlIiwgInN0YXRpb25fdHlwZSI6ICJTdHJlYW0iLCAidXNnc19zdGF0aW9uX2lkIjogIjA2NzI0NTAwIiwgInZhcmlhYmxlIjogIkRJU0NIUkciLCAid2QiOiAiNSJ9LCAidHlwZSI6ICJGZWF0dXJlIn0sIHsiYmJveCI6IFstMTA1LjIxNzUxOSwgNDAuMDg2Mjc4LCAtMTA1LjIxNzUxOSwgNDAuMDg2Mjc4XSwgImdlb21ldHJ5IjogeyJjb29yZGluYXRlcyI6IFstMTA1LjIxNzUxOSwgNDAuMDg2Mjc4XSwgInR5cGUiOiAiUG9pbnQifSwgImlkIjogIjI1IiwgInByb3BlcnRpZXMiOiB7ImFtb3VudCI6ICIwLjAwIiwgImNvdW50eSI6ICJCT1VMREVSIiwgImRhdGFfc291cmNlIjogIk5vcnRoZXJuIENvbG9yYWRvIFdhdGVyIENvbnNlcnZhbmN5IERpc3RyaWN0IiwgImRhdGVfdGltZSI6ICIyMDIwLTAzLTI0VDE0OjAwOjAwLjAwMCIsICJkaXYiOiAiMSIsICJkd3JfYWJicmV2IjogIkJGQ0lORkNPIiwgImZsYWciOiBudWxsLCAiaHR0cF9saW5rYWdlLnVybCI6ICJodHRwOi8vd3d3Lm5vcnRoZXJud2F0ZXIub3JnL1dhdGVyUHJvamVjdHMvV2F0ZXJEYXRhLmFzcHhFYXN0U2xvcGVXYXRlckRhdGEuYXNweCIsICJsb2NhdGlvbi5sYXRpdHVkZSI6IDQwLjA4NjI3OCwgImxvY2F0aW9uLmxvbmdpdHVkZSI6IC0xMDUuMjE3NTE5LCAibG9jYXRpb24ubmVlZHNfcmVjb2RpbmciOiBmYWxzZSwgInN0YWdlIjogIjAuMDEiLCAic3RhdGlvbl9uYW1lIjogIkJPVUxERVIgUkVTRVJWT0lSIElOTEVUIiwgInN0YXRpb25fc3RhdHVzIjogIkFjdGl2ZSIsICJzdGF0aW9uX3R5cGUiOiAiU3RyZWFtIiwgInVzZ3Nfc3RhdGlvbl9pZCI6ICJFUzE5MTYiLCAidmFyaWFibGUiOiAiRElTQ0hSRyIsICJ3ZCI6ICI2In0sICJ0eXBlIjogIkZlYXR1cmUifSwgeyJiYm94IjogWy0xMDUuMjEwMzg4MDAwMDAwMDEsIDQwLjE5MzAxOSwgLTEwNS4yMTAzODgwMDAwMDAwMSwgNDAuMTkzMDE5XSwgImdlb21ldHJ5IjogeyJjb29yZGluYXRlcyI6IFstMTA1LjIxMDM4ODAwMDAwMDAxLCA0MC4xOTMwMTldLCAidHlwZSI6ICJQb2ludCJ9LCAiaWQiOiAiMjYiLCAicHJvcGVydGllcyI6IHsiYW1vdW50IjogIjAuMDAiLCAiY291bnR5IjogIkJPVUxERVIiLCAiZGF0YV9zb3VyY2UiOiAiQ29vcGVyYXRpdmUgUHJvZ3JhbSBvZiBDRFdSLCBOQ1dDRCBcdTAwMjYgU1ZMSFdDRCIsICJkYXRlX3RpbWUiOiAiMjAyMC0wMy0yNFQxNTowMDowMC4wMDAiLCAiZGl2IjogIjEiLCAiZHdyX2FiYnJldiI6ICJUUlVESVRDTyIsICJmbGFnIjogbnVsbCwgImh0dHBfbGlua2FnZS51cmwiOiAiaHR0cHM6Ly9kd3Iuc3RhdGUuY28udXMvU3VyZmFjZVdhdGVyL2RhdGEvZGV0YWlsX2dyYXBoLmFzcHg/SUQ9VFJVRElUQ09cdTAwMjZNVFlQRT1ESVNDSFJHIiwgImxvY2F0aW9uLmxhdGl0dWRlIjogNDAuMTkzMDE5LCAibG9jYXRpb24ubG9uZ2l0dWRlIjogLTEwNS4yMTAzODgsICJsb2NhdGlvbi5uZWVkc19yZWNvZGluZyI6IGZhbHNlLCAic3RhZ2UiOiBudWxsLCAic3RhdGlvbl9uYW1lIjogIlRSVUUgQU5EIFdFQlNURVIgRElUQ0giLCAic3RhdGlvbl9zdGF0dXMiOiAiQWN0aXZlIiwgInN0YXRpb25fdHlwZSI6ICJEaXZlcnNpb24iLCAidXNnc19zdGF0aW9uX2lkIjogbnVsbCwgInZhcmlhYmxlIjogIkRJU0NIUkciLCAid2QiOiAiNSJ9LCAidHlwZSI6ICJGZWF0dXJlIn0sIHsiYmJveCI6IFstMTA1LjI1MTgyNiwgNDAuMjEyNjU4LCAtMTA1LjI1MTgyNiwgNDAuMjEyNjU4XSwgImdlb21ldHJ5IjogeyJjb29yZGluYXRlcyI6IFstMTA1LjI1MTgyNiwgNDAuMjEyNjU4XSwgInR5cGUiOiAiUG9pbnQifSwgImlkIjogIjI3IiwgInByb3BlcnRpZXMiOiB7ImFtb3VudCI6ICIwLjAwIiwgImNvdW50eSI6ICJCT1VMREVSIiwgImRhdGFfc291cmNlIjogIkNvb3BlcmF0aXZlIFByb2dyYW0gb2YgQ0RXUiwgTkNXQ0QgXHUwMDI2IFNWTEhXQ0QiLCAiZGF0ZV90aW1lIjogIjIwMjAtMDMtMjRUMTU6MDA6MDAuMDAwIiwgImRpdiI6ICIxIiwgImR3cl9hYmJyZXYiOiAiUk9VUkVBQ08iLCAiZmxhZyI6IG51bGwsICJodHRwX2xpbmthZ2UudXJsIjogImh0dHBzOi8vZHdyLnN0YXRlLmNvLnVzL1N1cmZhY2VXYXRlci9kYXRhL2RldGFpbF9ncmFwaC5hc3B4P0lEPVJPVVJFQUNPXHUwMDI2TVRZUEU9RElTQ0hSRyIsICJsb2NhdGlvbi5sYXRpdHVkZSI6IDQwLjIxMjY1OCwgImxvY2F0aW9uLmxvbmdpdHVkZSI6IC0xMDUuMjUxODI2LCAibG9jYXRpb24ubmVlZHNfcmVjb2RpbmciOiBmYWxzZSwgInN0YWdlIjogbnVsbCwgInN0YXRpb25fbmFtZSI6ICJST1VHSCBBTkQgUkVBRFkgRElUQ0giLCAic3RhdGlvbl9zdGF0dXMiOiAiQWN0aXZlIiwgInN0YXRpb25fdHlwZSI6ICJEaXZlcnNpb24iLCAidXNnc19zdGF0aW9uX2lkIjogbnVsbCwgInZhcmlhYmxlIjogIkRJU0NIUkciLCAid2QiOiAiNSJ9LCAidHlwZSI6ICJGZWF0dXJlIn0sIHsiYmJveCI6IFstMTA1LjE2Nzg3MywgNDAuMTc0ODQ0LCAtMTA1LjE2Nzg3MywgNDAuMTc0ODQ0XSwgImdlb21ldHJ5IjogeyJjb29yZGluYXRlcyI6IFstMTA1LjE2Nzg3MywgNDAuMTc0ODQ0XSwgInR5cGUiOiAiUG9pbnQifSwgImlkIjogIjI4IiwgInByb3BlcnRpZXMiOiB7ImFtb3VudCI6ICIwLjEyIiwgImNvdW50eSI6ICJCT1VMREVSIiwgImRhdGFfc291cmNlIjogIkNvb3BlcmF0aXZlIFByb2dyYW0gb2YgQ0RXUiwgTkNXQ0QgXHUwMDI2IFNWTEhXQ0QiLCAiZGF0ZV90aW1lIjogIjIwMjAtMDMtMjRUMTQ6NDU6MDAuMDAwIiwgImRpdiI6ICIxIiwgImR3cl9hYmJyZXYiOiAiSEdSTURXQ08iLCAiZmxhZyI6IG51bGwsICJodHRwX2xpbmthZ2UudXJsIjogImh0dHBzOi8vZHdyLnN0YXRlLmNvLnVzL1N1cmZhY2VXYXRlci9kYXRhL2RldGFpbF9ncmFwaC5hc3B4P0lEPUhHUk1EV0NPXHUwMDI2TVRZUEU9RElTQ0hSRyIsICJsb2NhdGlvbi5sYXRpdHVkZSI6IDQwLjE3NDg0NCwgImxvY2F0aW9uLmxvbmdpdHVkZSI6IC0xMDUuMTY3ODczLCAibG9jYXRpb24ubmVlZHNfcmVjb2RpbmciOiBmYWxzZSwgInN0YWdlIjogIjAuMDciLCAic3RhdGlvbl9uYW1lIjogIkhBR0VSIE1FQURPV1MgRElUQ0giLCAic3RhdGlvbl9zdGF0dXMiOiAiQWN0aXZlIiwgInN0YXRpb25fdHlwZSI6ICJEaXZlcnNpb24iLCAidXNnc19zdGF0aW9uX2lkIjogbnVsbCwgInZhcmlhYmxlIjogIkRJU0NIUkciLCAid2QiOiAiNSJ9LCAidHlwZSI6ICJGZWF0dXJlIn0sIHsiYmJveCI6IFstMTA1LjIwOTQxNiwgNDAuMjU2Mjc2MDAwMDAwMDEsIC0xMDUuMjA5NDE2LCA0MC4yNTYyNzYwMDAwMDAwMV0sICJnZW9tZXRyeSI6IHsiY29vcmRpbmF0ZXMiOiBbLTEwNS4yMDk0MTYsIDQwLjI1NjI3NjAwMDAwMDAxXSwgInR5cGUiOiAiUG9pbnQifSwgImlkIjogIjI5IiwgInByb3BlcnRpZXMiOiB7ImFtb3VudCI6ICIwLjAwIiwgImNvdW50eSI6ICJCT1VMREVSIiwgImRhdGFfc291cmNlIjogIk5vcnRoZXJuIENvbG9yYWRvIFdhdGVyIENvbnNlcnZhbmN5IERpc3RyaWN0IiwgImRhdGVfdGltZSI6ICIyMDIwLTAzLTI0VDE0OjAwOjAwLjAwMCIsICJkaXYiOiAiMSIsICJkd3JfYWJicmV2IjogIkxJVFRIMUNPIiwgImZsYWciOiBudWxsLCAiaHR0cF9saW5rYWdlLnVybCI6ICJodHRwOi8vd3d3Lm5vcnRoZXJud2F0ZXIub3JnL1dhdGVyUHJvamVjdHMvV2F0ZXJEYXRhLmFzcHhFYXN0U2xvcGVXYXRlckRhdGEuYXNweCIsICJsb2NhdGlvbi5sYXRpdHVkZSI6IDQwLjI1NjI3NiwgImxvY2F0aW9uLmxvbmdpdHVkZSI6IC0xMDUuMjA5NDE2LCAibG9jYXRpb24ubmVlZHNfcmVjb2RpbmciOiBmYWxzZSwgInN0YWdlIjogbnVsbCwgInN0YXRpb25fbmFtZSI6ICJMSVRUTEUgVEhPTVBTT04gIzEgRElUQ0giLCAic3RhdGlvbl9zdGF0dXMiOiAiQWN0aXZlIiwgInN0YXRpb25fdHlwZSI6ICJEaXZlcnNpb24iLCAidXNnc19zdGF0aW9uX2lkIjogIkVTMTkwMSIsICJ2YXJpYWJsZSI6ICJESVNDSFJHIiwgIndkIjogIjQifSwgInR5cGUiOiAiRmVhdHVyZSJ9LCB7ImJib3giOiBbLTEwNS4xOTg1NjcsIDQwLjI2MDgyNywgLTEwNS4xOTg1NjcsIDQwLjI2MDgyN10sICJnZW9tZXRyeSI6IHsiY29vcmRpbmF0ZXMiOiBbLTEwNS4xOTg1NjcsIDQwLjI2MDgyN10sICJ0eXBlIjogIlBvaW50In0sICJpZCI6ICIzMCIsICJwcm9wZXJ0aWVzIjogeyJhbW91bnQiOiAiMC4wMCIsICJjb3VudHkiOiAiQk9VTERFUiIsICJkYXRhX3NvdXJjZSI6ICJDb29wZXJhdGl2ZSBTRFIgUHJvZ3JhbSBvZiBDRFdSIFx1MDAyNiBOQ1dDRCIsICJkYXRlX3RpbWUiOiAiMjAyMC0wMy0yNFQxNTowMDowMC4wMDAiLCAiZGl2IjogIjEiLCAiZHdyX2FiYnJldiI6ICJDVUxESVRDTyIsICJmbGFnIjogbnVsbCwgImh0dHBfbGlua2FnZS51cmwiOiAiaHR0cHM6Ly9kd3Iuc3RhdGUuY28udXMvU3VyZmFjZVdhdGVyL2RhdGEvZGV0YWlsX2dyYXBoLmFzcHg/SUQ9Q1VMRElUQ09cdTAwMjZNVFlQRT1ESVNDSFJHIiwgImxvY2F0aW9uLmxhdGl0dWRlIjogNDAuMjYwODI3LCAibG9jYXRpb24ubG9uZ2l0dWRlIjogLTEwNS4xOTg1NjcsICJsb2NhdGlvbi5uZWVkc19yZWNvZGluZyI6IGZhbHNlLCAic3RhZ2UiOiBudWxsLCAic3RhdGlvbl9uYW1lIjogIkNVTFZFUiBESVRDSCIsICJzdGF0aW9uX3N0YXR1cyI6ICJBY3RpdmUiLCAic3RhdGlvbl90eXBlIjogIkRpdmVyc2lvbiIsICJ1c2dzX3N0YXRpb25faWQiOiBudWxsLCAidmFyaWFibGUiOiAiRElTQ0hSRyIsICJ3ZCI6ICI0In0sICJ0eXBlIjogIkZlYXR1cmUifSwgeyJiYm94IjogWy0xMDUuMjU2MDE3LCA0MC4yMTUwNDMsIC0xMDUuMjU2MDE3LCA0MC4yMTUwNDNdLCAiZ2VvbWV0cnkiOiB7ImNvb3JkaW5hdGVzIjogWy0xMDUuMjU2MDE3LCA0MC4yMTUwNDNdLCAidHlwZSI6ICJQb2ludCJ9LCAiaWQiOiAiMzEiLCAicHJvcGVydGllcyI6IHsiYW1vdW50IjogIjM4LjkwIiwgImNvdW50eSI6ICJCT1VMREVSIiwgImRhdGFfc291cmNlIjogIkNvLiBEaXZpc2lvbiBvZiBXYXRlciBSZXNvdXJjZXMiLCAiZGF0ZV90aW1lIjogIjIwMjAtMDMtMjRUMTQ6MzA6MDAuMDAwIiwgImRpdiI6ICIxIiwgImR3cl9hYmJyZXYiOiAiSElHSExEQ08iLCAiZmxhZyI6IG51bGwsICJodHRwX2xpbmthZ2UudXJsIjogImh0dHBzOi8vZHdyLnN0YXRlLmNvLnVzL1N1cmZhY2VXYXRlci9kYXRhL2RldGFpbF9ncmFwaC5hc3B4P0lEPUhJR0hMRENPXHUwMDI2TVRZUEU9RElTQ0hSRyIsICJsb2NhdGlvbi5sYXRpdHVkZSI6IDQwLjIxNTA0MywgImxvY2F0aW9uLmxvbmdpdHVkZSI6IC0xMDUuMjU2MDE3LCAibG9jYXRpb24ubmVlZHNfcmVjb2RpbmciOiBmYWxzZSwgInN0YWdlIjogIjAuNzIiLCAic3RhdGlvbl9uYW1lIjogIkhJR0hMQU5EIERJVENIIEFUIExZT05TLCBDTyIsICJzdGF0aW9uX3N0YXR1cyI6ICJBY3RpdmUiLCAic3RhdGlvbl90eXBlIjogIkRpdmVyc2lvbiIsICJ1c2dzX3N0YXRpb25faWQiOiBudWxsLCAidmFyaWFibGUiOiAiRElTQ0hSRyIsICJ3ZCI6ICI1In0sICJ0eXBlIjogIkZlYXR1cmUifSwgeyJiYm94IjogWy0xMDUuMjIwNDk3LCA0MC4wNzg1NiwgLTEwNS4yMjA0OTcsIDQwLjA3ODU2XSwgImdlb21ldHJ5IjogeyJjb29yZGluYXRlcyI6IFstMTA1LjIyMDQ5NywgNDAuMDc4NTZdLCAidHlwZSI6ICJQb2ludCJ9LCAiaWQiOiAiMzIiLCAicHJvcGVydGllcyI6IHsiYW1vdW50IjogIjUyMDYuMjAiLCAiY291bnR5IjogIkJPVUxERVIiLCAiZGF0YV9zb3VyY2UiOiAiTm9ydGhlcm4gQ29sb3JhZG8gV2F0ZXIgQ29uc2VydmFuY3kgRGlzdHJpY3QiLCAiZGF0ZV90aW1lIjogIjIwMjAtMDMtMjRUMTQ6MDA6MDAuMDAwIiwgImRpdiI6ICIxIiwgImR3cl9hYmJyZXYiOiAiQk9VUkVTQ08iLCAiZmxhZyI6IG51bGwsICJodHRwX2xpbmthZ2UudXJsIjogImh0dHA6Ly93d3cubm9ydGhlcm53YXRlci5vcmcvV2F0ZXJQcm9qZWN0cy9XYXRlckRhdGEuYXNweEVhc3RTbG9wZVdhdGVyRGF0YS5hc3B4IiwgImxvY2F0aW9uLmxhdGl0dWRlIjogNDAuMDc4NTYsICJsb2NhdGlvbi5sb25naXR1ZGUiOiAtMTA1LjIyMDQ5NywgImxvY2F0aW9uLm5lZWRzX3JlY29kaW5nIjogZmFsc2UsICJzdGFnZSI6IG51bGwsICJzdGF0aW9uX25hbWUiOiAiQk9VTERFUiBSRVNFUlZPSVIiLCAic3RhdGlvbl9zdGF0dXMiOiAiQWN0aXZlIiwgInN0YXRpb25fdHlwZSI6ICJSZXNlcnZvaXIiLCAidXNnc19zdGF0aW9uX2lkIjogIkVSMTkxNCIsICJ2YXJpYWJsZSI6ICJTVE9SQUdFIiwgIndkIjogIjYifSwgInR5cGUiOiAiRmVhdHVyZSJ9LCB7ImJib3giOiBbLTEwNS4xNjkzNzQsIDQwLjE3Mzk1LCAtMTA1LjE2OTM3NCwgNDAuMTczOTVdLCAiZ2VvbWV0cnkiOiB7ImNvb3JkaW5hdGVzIjogWy0xMDUuMTY5Mzc0LCA0MC4xNzM5NV0sICJ0eXBlIjogIlBvaW50In0sICJpZCI6ICIzMyIsICJwcm9wZXJ0aWVzIjogeyJhbW91bnQiOiAiMC4xOSIsICJjb3VudHkiOiAiQk9VTERFUiIsICJkYXRhX3NvdXJjZSI6ICJDb29wZXJhdGl2ZSBQcm9ncmFtIG9mIENEV1IsIE5DV0NEIFx1MDAyNiBTVkxIV0NEIiwgImRhdGVfdGltZSI6ICIyMDIwLTAzLTI0VDE0OjMwOjAwLjAwMCIsICJkaXYiOiAiMSIsICJkd3JfYWJicmV2IjogIk5JV0RJVENPIiwgImZsYWciOiBudWxsLCAiaHR0cF9saW5rYWdlLnVybCI6ICJodHRwczovL2R3ci5zdGF0ZS5jby51cy9TdXJmYWNlV2F0ZXIvZGF0YS9kZXRhaWxfZ3JhcGguYXNweD9JRD1OSVdESVRDT1x1MDAyNk1UWVBFPURJU0NIUkciLCAibG9jYXRpb24ubGF0aXR1ZGUiOiA0MC4xNzM5NSwgImxvY2F0aW9uLmxvbmdpdHVkZSI6IC0xMDUuMTY5Mzc0LCAibG9jYXRpb24ubmVlZHNfcmVjb2RpbmciOiBmYWxzZSwgInN0YWdlIjogIjAuMDkiLCAic3RhdGlvbl9uYW1lIjogIk5JV09UIERJVENIIiwgInN0YXRpb25fc3RhdHVzIjogIkFjdGl2ZSIsICJzdGF0aW9uX3R5cGUiOiAiRGl2ZXJzaW9uIiwgInVzZ3Nfc3RhdGlvbl9pZCI6IG51bGwsICJ2YXJpYWJsZSI6ICJESVNDSFJHIiwgIndkIjogIjUifSwgInR5cGUiOiAiRmVhdHVyZSJ9LCB7ImJib3giOiBbLTEwNS4yNTA5NTIsIDQwLjIxMTM4OSwgLTEwNS4yNTA5NTIsIDQwLjIxMTM4OV0sICJnZW9tZXRyeSI6IHsiY29vcmRpbmF0ZXMiOiBbLTEwNS4yNTA5NTIsIDQwLjIxMTM4OV0sICJ0eXBlIjogIlBvaW50In0sICJpZCI6ICIzNCIsICJwcm9wZXJ0aWVzIjogeyJhbW91bnQiOiAiMC4wMCIsICJjb3VudHkiOiAiQk9VTERFUiIsICJkYXRhX3NvdXJjZSI6ICJDb29wZXJhdGl2ZSBQcm9ncmFtIG9mIENEV1IsIE5DV0NEIFx1MDAyNiBTVkxIV0NEIiwgImRhdGVfdGltZSI6ICIyMDIwLTAzLTI0VDE0OjAwOjAwLjAwMCIsICJkaXYiOiAiMSIsICJkd3JfYWJicmV2IjogIlNNRURJVENPIiwgImZsYWciOiBudWxsLCAiaHR0cF9saW5rYWdlLnVybCI6ICJodHRwczovL2R3ci5zdGF0ZS5jby51cy9TdXJmYWNlV2F0ZXIvZGF0YS9kZXRhaWxfZ3JhcGguYXNweD9JRD1TTUVESVRDT1x1MDAyNk1UWVBFPURJU0NIUkciLCAibG9jYXRpb24ubGF0aXR1ZGUiOiA0MC4yMTEzODksICJsb2NhdGlvbi5sb25naXR1ZGUiOiAtMTA1LjI1MDk1MiwgImxvY2F0aW9uLm5lZWRzX3JlY29kaW5nIjogZmFsc2UsICJzdGFnZSI6IG51bGwsICJzdGF0aW9uX25hbWUiOiAiU01FQUQgRElUQ0giLCAic3RhdGlvbl9zdGF0dXMiOiAiQWN0aXZlIiwgInN0YXRpb25fdHlwZSI6ICJEaXZlcnNpb24iLCAidXNnc19zdGF0aW9uX2lkIjogbnVsbCwgInZhcmlhYmxlIjogIkRJU0NIUkciLCAid2QiOiAiNSJ9LCAidHlwZSI6ICJGZWF0dXJlIn0sIHsiYmJveCI6IFstMTA1LjA4ODY5NSwgNDAuMTUzMzYzLCAtMTA1LjA4ODY5NSwgNDAuMTUzMzYzXSwgImdlb21ldHJ5IjogeyJjb29yZGluYXRlcyI6IFstMTA1LjA4ODY5NSwgNDAuMTUzMzYzXSwgInR5cGUiOiAiUG9pbnQifSwgImlkIjogIjM1IiwgInByb3BlcnRpZXMiOiB7ImFtb3VudCI6ICIwLjEwIiwgImNvdW50eSI6ICJCT1VMREVSIiwgImRhdGFfc291cmNlIjogIkNvb3BlcmF0aXZlIFByb2dyYW0gb2YgQ0RXUiwgTkNXQ0QgXHUwMDI2IFNWTEhXQ0QiLCAiZGF0ZV90aW1lIjogIjIwMjAtMDMtMjRUMTU6MDA6MDAuMDAwIiwgImRpdiI6ICIxIiwgImR3cl9hYmJyZXYiOiAiQk9ORElUQ08iLCAiZmxhZyI6IG51bGwsICJodHRwX2xpbmthZ2UudXJsIjogImh0dHBzOi8vZHdyLnN0YXRlLmNvLnVzL1N1cmZhY2VXYXRlci9kYXRhL2RldGFpbF9ncmFwaC5hc3B4P0lEPUJPTkRJVENPXHUwMDI2TVRZUEU9RElTQ0hSRyIsICJsb2NhdGlvbi5sYXRpdHVkZSI6IDQwLjE1MzM2MywgImxvY2F0aW9uLmxvbmdpdHVkZSI6IC0xMDUuMDg4Njk1LCAibG9jYXRpb24ubmVlZHNfcmVjb2RpbmciOiBmYWxzZSwgInN0YWdlIjogIjAuMDQiLCAic3RhdGlvbl9uYW1lIjogIkJPTlVTIERJVENIIiwgInN0YXRpb25fc3RhdHVzIjogIkFjdGl2ZSIsICJzdGF0aW9uX3R5cGUiOiAiRGl2ZXJzaW9uIiwgInVzZ3Nfc3RhdGlvbl9pZCI6IG51bGwsICJ2YXJpYWJsZSI6ICJESVNDSFJHIiwgIndkIjogIjUifSwgInR5cGUiOiAiRmVhdHVyZSJ9LCB7ImJib3giOiBbLTEwNS4yNTA5MjcsIDQwLjIxMTA4MywgLTEwNS4yNTA5MjcsIDQwLjIxMTA4M10sICJnZW9tZXRyeSI6IHsiY29vcmRpbmF0ZXMiOiBbLTEwNS4yNTA5MjcsIDQwLjIxMTA4M10sICJ0eXBlIjogIlBvaW50In0sICJpZCI6ICIzNiIsICJwcm9wZXJ0aWVzIjogeyJhbW91bnQiOiAiMC4wMCIsICJjb3VudHkiOiAiQk9VTERFUiIsICJkYXRhX3NvdXJjZSI6ICJDb29wZXJhdGl2ZSBQcm9ncmFtIG9mIENEV1IsIE5DV0NEIFx1MDAyNiBTVkxIV0NEIiwgImRhdGVfdGltZSI6ICIyMDIwLTAzLTI0VDE0OjAwOjAwLjAwMCIsICJkaXYiOiAiMSIsICJkd3JfYWJicmV2IjogIlNXRURJVENPIiwgImZsYWciOiBudWxsLCAiaHR0cF9saW5rYWdlLnVybCI6ICJodHRwczovL2R3ci5zdGF0ZS5jby51cy9TdXJmYWNlV2F0ZXIvZGF0YS9kZXRhaWxfZ3JhcGguYXNweD9JRD1TV0VESVRDT1x1MDAyNk1UWVBFPURJU0NIUkciLCAibG9jYXRpb24ubGF0aXR1ZGUiOiA0MC4yMTEwODMsICJsb2NhdGlvbi5sb25naXR1ZGUiOiAtMTA1LjI1MDkyNywgImxvY2F0aW9uLm5lZWRzX3JlY29kaW5nIjogZmFsc2UsICJzdGFnZSI6ICItMC4wNSIsICJzdGF0aW9uX25hbWUiOiAiU1dFREUgRElUQ0giLCAic3RhdGlvbl9zdGF0dXMiOiAiQWN0aXZlIiwgInN0YXRpb25fdHlwZSI6ICJEaXZlcnNpb24iLCAidXNnc19zdGF0aW9uX2lkIjogbnVsbCwgInZhcmlhYmxlIjogIkRJU0NIUkciLCAid2QiOiAiNSJ9LCAidHlwZSI6ICJGZWF0dXJlIn0sIHsiYmJveCI6IFstMTA1LjE4OTEzMiwgNDAuMTg3NTI0LCAtMTA1LjE4OTEzMiwgNDAuMTg3NTI0XSwgImdlb21ldHJ5IjogeyJjb29yZGluYXRlcyI6IFstMTA1LjE4OTEzMiwgNDAuMTg3NTI0XSwgInR5cGUiOiAiUG9pbnQifSwgImlkIjogIjM3IiwgInByb3BlcnRpZXMiOiB7ImFtb3VudCI6ICIwLjAwIiwgImNvdW50eSI6ICJCT1VMREVSIiwgImRhdGFfc291cmNlIjogIkNvb3BlcmF0aXZlIFByb2dyYW0gb2YgQ0RXUiwgTkNXQ0QgXHUwMDI2IFNWTEhXQ0QiLCAiZGF0ZV90aW1lIjogIjIwMjAtMDMtMjRUMTU6MDA6MDAuMDAwIiwgImRpdiI6ICIxIiwgImR3cl9hYmJyZXYiOiAiUlVOWU9OQ08iLCAiZmxhZyI6IG51bGwsICJodHRwX2xpbmthZ2UudXJsIjogImh0dHBzOi8vZHdyLnN0YXRlLmNvLnVzL1N1cmZhY2VXYXRlci9kYXRhL2RldGFpbF9ncmFwaC5hc3B4P0lEPVJVTllPTkNPXHUwMDI2TVRZUEU9RElTQ0hSRyIsICJsb2NhdGlvbi5sYXRpdHVkZSI6IDQwLjE4NzUyNCwgImxvY2F0aW9uLmxvbmdpdHVkZSI6IC0xMDUuMTg5MTMyLCAibG9jYXRpb24ubmVlZHNfcmVjb2RpbmciOiBmYWxzZSwgInN0YWdlIjogIjUwLjc5IiwgInN0YXRpb25fbmFtZSI6ICJSVU5ZT04gRElUQ0giLCAic3RhdGlvbl9zdGF0dXMiOiAiQWN0aXZlIiwgInN0YXRpb25fdHlwZSI6ICJEaXZlcnNpb24iLCAidXNnc19zdGF0aW9uX2lkIjogbnVsbCwgInZhcmlhYmxlIjogIkRJU0NIUkciLCAid2QiOiAiNSJ9LCAidHlwZSI6ICJGZWF0dXJlIn0sIHsiYmJveCI6IFstMTA1LjE5Njc3NSwgNDAuMTgxODgsIC0xMDUuMTk2Nzc1LCA0MC4xODE4OF0sICJnZW9tZXRyeSI6IHsiY29vcmRpbmF0ZXMiOiBbLTEwNS4xOTY3NzUsIDQwLjE4MTg4XSwgInR5cGUiOiAiUG9pbnQifSwgImlkIjogIjM4IiwgInByb3BlcnRpZXMiOiB7ImFtb3VudCI6ICIwLjAwIiwgImNvdW50eSI6ICJCT1VMREVSIiwgImRhdGFfc291cmNlIjogIkNvb3BlcmF0aXZlIFByb2dyYW0gb2YgQ0RXUiwgTkNXQ0QgXHUwMDI2IFNWTEhXQ0QiLCAiZGF0ZV90aW1lIjogIjIwMjAtMDMtMjRUMTQ6NDU6MDAuMDAwIiwgImRpdiI6ICIxIiwgImR3cl9hYmJyZXYiOiAiREFWRE9XQ08iLCAiZmxhZyI6IG51bGwsICJodHRwX2xpbmthZ2UudXJsIjogImh0dHBzOi8vZHdyLnN0YXRlLmNvLnVzL1N1cmZhY2VXYXRlci9kYXRhL2RldGFpbF9ncmFwaC5hc3B4P0lEPURBVkRPV0NPXHUwMDI2TVRZUEU9RElTQ0hSRyIsICJsb2NhdGlvbi5sYXRpdHVkZSI6IDQwLjE4MTg4LCAibG9jYXRpb24ubG9uZ2l0dWRlIjogLTEwNS4xOTY3NzUsICJsb2NhdGlvbi5uZWVkc19yZWNvZGluZyI6IGZhbHNlLCAic3RhZ2UiOiBudWxsLCAic3RhdGlvbl9uYW1lIjogIkRBVklTIEFORCBET1dOSU5HIERJVENIIiwgInN0YXRpb25fc3RhdHVzIjogIkFjdGl2ZSIsICJzdGF0aW9uX3R5cGUiOiAiRGl2ZXJzaW9uIiwgInVzZ3Nfc3RhdGlvbl9pZCI6IG51bGwsICJ2YXJpYWJsZSI6ICJESVNDSFJHIiwgIndkIjogIjUifSwgInR5cGUiOiAiRmVhdHVyZSJ9LCB7ImJib3giOiBbLTEwNS4zMjYyNSwgNDAuMDE4NjY3LCAtMTA1LjMyNjI1LCA0MC4wMTg2NjddLCAiZ2VvbWV0cnkiOiB7ImNvb3JkaW5hdGVzIjogWy0xMDUuMzI2MjUsIDQwLjAxODY2N10sICJ0eXBlIjogIlBvaW50In0sICJpZCI6ICIzOSIsICJwcm9wZXJ0aWVzIjogeyJhbW91bnQiOiAiMC43NCIsICJjb3VudHkiOiAiQk9VTERFUiIsICJkYXRhX3NvdXJjZSI6ICJVLlMuIEdlb2xvZ2ljYWwgU3VydmV5IiwgImRhdGVfdGltZSI6ICIyMDE5LTEwLTAyVDE0OjUwOjAwLjAwMCIsICJkaXYiOiAiMSIsICJkd3JfYWJicmV2IjogIkZPVU9ST0NPIiwgImZsYWciOiBudWxsLCAiaHR0cF9saW5rYWdlLnVybCI6ICJodHRwczovL3dhdGVyZGF0YS51c2dzLmdvdi9ud2lzL3V2PzA2NzI3NTAwIiwgImxvY2F0aW9uLmxhdGl0dWRlIjogNDAuMDE4NjY3LCAibG9jYXRpb24ubG9uZ2l0dWRlIjogLTEwNS4zMjYyNSwgImxvY2F0aW9uLm5lZWRzX3JlY29kaW5nIjogZmFsc2UsICJzdGFnZSI6IG51bGwsICJzdGF0aW9uX25hbWUiOiAiRk9VUk1JTEUgQ1JFRUsgQVQgT1JPREVMTCwgQ08iLCAic3RhdGlvbl9zdGF0dXMiOiAiQWN0aXZlIiwgInN0YXRpb25fdHlwZSI6ICJTdHJlYW0iLCAidXNnc19zdGF0aW9uX2lkIjogIjA2NzI3NTAwIiwgInZhcmlhYmxlIjogIkRJU0NIUkciLCAid2QiOiAiNiJ9LCAidHlwZSI6ICJGZWF0dXJlIn0sIHsiYmJveCI6IFstMTA1LjIwOTI4MiwgNDAuMTg4NTc5LCAtMTA1LjIwOTI4MiwgNDAuMTg4NTc5XSwgImdlb21ldHJ5IjogeyJjb29yZGluYXRlcyI6IFstMTA1LjIwOTI4MiwgNDAuMTg4NTc5XSwgInR5cGUiOiAiUG9pbnQifSwgImlkIjogIjQwIiwgInByb3BlcnRpZXMiOiB7ImFtb3VudCI6ICIwLjEyIiwgImNvdW50eSI6ICJCT1VMREVSIiwgImRhdGFfc291cmNlIjogIkNvb3BlcmF0aXZlIFByb2dyYW0gb2YgQ0RXUiwgTkNXQ0QgXHUwMDI2IFNWTEhXQ0QiLCAiZGF0ZV90aW1lIjogIjIwMjAtMDMtMjRUMTQ6NDU6MDAuMDAwIiwgImRpdiI6ICIxIiwgImR3cl9hYmJyZXYiOiAiSkFNRElUQ08iLCAiZmxhZyI6IG51bGwsICJodHRwX2xpbmthZ2UudXJsIjogImh0dHBzOi8vZHdyLnN0YXRlLmNvLnVzL1N1cmZhY2VXYXRlci9kYXRhL2RldGFpbF9ncmFwaC5hc3B4P0lEPUpBTURJVENPXHUwMDI2TVRZUEU9RElTQ0hSRyIsICJsb2NhdGlvbi5sYXRpdHVkZSI6IDQwLjE4ODU3OSwgImxvY2F0aW9uLmxvbmdpdHVkZSI6IC0xMDUuMjA5MjgyLCAibG9jYXRpb24ubmVlZHNfcmVjb2RpbmciOiBmYWxzZSwgInN0YWdlIjogIjAuMDQiLCAic3RhdGlvbl9uYW1lIjogIkpBTUVTIERJVENIIiwgInN0YXRpb25fc3RhdHVzIjogIkFjdGl2ZSIsICJzdGF0aW9uX3R5cGUiOiAiRGl2ZXJzaW9uIiwgInVzZ3Nfc3RhdGlvbl9pZCI6IG51bGwsICJ2YXJpYWJsZSI6ICJESVNDSFJHIiwgIndkIjogIjUifSwgInR5cGUiOiAiRmVhdHVyZSJ9LCB7ImJib3giOiBbLTEwNS4xOTMwNDgsIDQwLjA1MzAzNSwgLTEwNS4xOTMwNDgsIDQwLjA1MzAzNV0sICJnZW9tZXRyeSI6IHsiY29vcmRpbmF0ZXMiOiBbLTEwNS4xOTMwNDgsIDQwLjA1MzAzNV0sICJ0eXBlIjogIlBvaW50In0sICJpZCI6ICI0MSIsICJwcm9wZXJ0aWVzIjogeyJhbW91bnQiOiAiMC4wMCIsICJjb3VudHkiOiAiQk9VTERFUiIsICJkYXRhX3NvdXJjZSI6ICJOb3J0aGVybiBDb2xvcmFkbyBXYXRlciBDb25zZXJ2YW5jeSBEaXN0cmljdCIsICJkYXRlX3RpbWUiOiAiMjAyMC0wMy0yNFQxNDowMDowMC4wMDAiLCAiZGl2IjogIjEiLCAiZHdyX2FiYnJldiI6ICJCQ1NDQkNDTyIsICJmbGFnIjogbnVsbCwgImh0dHBfbGlua2FnZS51cmwiOiAiaHR0cDovL3d3dy5ub3J0aGVybndhdGVyLm9yZy9XYXRlclByb2plY3RzL1dhdGVyRGF0YS5hc3B4RWFzdFNsb3BlV2F0ZXJEYXRhLmFzcHgiLCAibG9jYXRpb24ubGF0aXR1ZGUiOiA0MC4wNTMwMzUsICJsb2NhdGlvbi5sb25naXR1ZGUiOiAtMTA1LjE5MzA0OCwgImxvY2F0aW9uLm5lZWRzX3JlY29kaW5nIjogZmFsc2UsICJzdGFnZSI6ICIwLjAwIiwgInN0YXRpb25fbmFtZSI6ICJCT1VMREVSIENSRUVLIFNVUFBMWSBDQU5BTCBUTyBCT1VMREVSIENSRUVLIE5FQVIgQk9VTERFUiIsICJzdGF0aW9uX3N0YXR1cyI6ICJBY3RpdmUiLCAic3RhdGlvbl90eXBlIjogIkRpdmVyc2lvbiIsICJ1c2dzX3N0YXRpb25faWQiOiAiRVMxOTE3IiwgInZhcmlhYmxlIjogIkRJU0NIUkciLCAid2QiOiAiNiJ9LCAidHlwZSI6ICJGZWF0dXJlIn0sIHsiYmJveCI6IFstMTA1LjE3NDk1NywgNDAuMjU4MzY3LCAtMTA1LjE3NDk1NywgNDAuMjU4MzY3XSwgImdlb21ldHJ5IjogeyJjb29yZGluYXRlcyI6IFstMTA1LjE3NDk1NywgNDAuMjU4MzY3XSwgInR5cGUiOiAiUG9pbnQifSwgImlkIjogIjQyIiwgInByb3BlcnRpZXMiOiB7ImFtb3VudCI6ICIwLjAwIiwgImNvdW50eSI6ICJCT1VMREVSIiwgImRhdGFfc291cmNlIjogIkNvLiBEaXZpc2lvbiBvZiBXYXRlciBSZXNvdXJjZXMiLCAiZGF0ZV90aW1lIjogIjIwMjAtMDMtMjRUMTQ6MzA6MDAuMDAwIiwgImRpdiI6ICIxIiwgImR3cl9hYmJyZXYiOiAiQk9VTEFSQ08iLCAiZmxhZyI6IG51bGwsICJodHRwX2xpbmthZ2UudXJsIjogImh0dHBzOi8vZHdyLnN0YXRlLmNvLnVzL1N1cmZhY2VXYXRlci9kYXRhL2RldGFpbF9ncmFwaC5hc3B4P0lEPUJPVUxBUkNPXHUwMDI2TVRZUEU9RElTQ0hSRyIsICJsb2NhdGlvbi5sYXRpdHVkZSI6IDQwLjI1ODM2NywgImxvY2F0aW9uLmxvbmdpdHVkZSI6IC0xMDUuMTc0OTU3LCAibG9jYXRpb24ubmVlZHNfcmVjb2RpbmciOiBmYWxzZSwgInN0YWdlIjogIi0wLjEyIiwgInN0YXRpb25fbmFtZSI6ICJCT1VMREVSLUxBUklNRVIgRElUQ0ggTkVBUiBCRVJUSE9VRCIsICJzdGF0aW9uX3N0YXR1cyI6ICJBY3RpdmUiLCAic3RhdGlvbl90eXBlIjogIkRpdmVyc2lvbiIsICJ1c2dzX3N0YXRpb25faWQiOiBudWxsLCAidmFyaWFibGUiOiAiRElTQ0hSRyIsICJ3ZCI6ICI0In0sICJ0eXBlIjogIkZlYXR1cmUifSwgeyJiYm94IjogWy0xMDUuMzQ3OTA2LCAzOS45MzgzNTEsIC0xMDUuMzQ3OTA2LCAzOS45MzgzNTFdLCAiZ2VvbWV0cnkiOiB7ImNvb3JkaW5hdGVzIjogWy0xMDUuMzQ3OTA2LCAzOS45MzgzNTFdLCAidHlwZSI6ICJQb2ludCJ9LCAiaWQiOiAiNDMiLCAicHJvcGVydGllcyI6IHsiYW1vdW50IjogIjE2LjQwIiwgImNvdW50eSI6ICJCT1VMREVSIiwgImRhdGFfc291cmNlIjogIkNvLiBEaXZpc2lvbiBvZiBXYXRlciBSZXNvdXJjZXMiLCAiZGF0ZV90aW1lIjogIjIwMjAtMDMtMjRUMTU6MTU6MDAuMDAwIiwgImRpdiI6ICIxIiwgImR3cl9hYmJyZXYiOiAiQk9DQkdSQ08iLCAiZmxhZyI6IG51bGwsICJodHRwX2xpbmthZ2UudXJsIjogImh0dHBzOi8vZHdyLnN0YXRlLmNvLnVzL1N1cmZhY2VXYXRlci9kYXRhL2RldGFpbF9ncmFwaC5hc3B4P0lEPUJPQ0JHUkNPXHUwMDI2TVRZUEU9RElTQ0hSRyIsICJsb2NhdGlvbi5sYXRpdHVkZSI6IDM5LjkzODM1MSwgImxvY2F0aW9uLmxvbmdpdHVkZSI6IC0xMDUuMzQ3OTA2LCAibG9jYXRpb24ubmVlZHNfcmVjb2RpbmciOiBmYWxzZSwgInN0YWdlIjogIjAuMzYiLCAic3RhdGlvbl9uYW1lIjogIlNPVVRIIEJPVUxERVIgQ1JFRUsgQkVMT1cgR1JPU1MgUkVTRVJWT0lSIiwgInN0YXRpb25fc3RhdHVzIjogIkFjdGl2ZSIsICJzdGF0aW9uX3R5cGUiOiAiU3RyZWFtIiwgInVzZ3Nfc3RhdGlvbl9pZCI6ICIwNjcyOTQ1MCIsICJ2YXJpYWJsZSI6ICJESVNDSFJHIiwgIndkIjogIjYifSwgInR5cGUiOiAiRmVhdHVyZSJ9LCB7ImJib3giOiBbLTEwNS4yNTE4MjYsIDQwLjIxMjUwNSwgLTEwNS4yNTE4MjYsIDQwLjIxMjUwNV0sICJnZW9tZXRyeSI6IHsiY29vcmRpbmF0ZXMiOiBbLTEwNS4yNTE4MjYsIDQwLjIxMjUwNV0sICJ0eXBlIjogIlBvaW50In0sICJpZCI6ICI0NCIsICJwcm9wZXJ0aWVzIjogeyJhbW91bnQiOiAiMS4wOCIsICJjb3VudHkiOiAiQk9VTERFUiIsICJkYXRhX3NvdXJjZSI6ICJDb29wZXJhdGl2ZSBQcm9ncmFtIG9mIENEV1IsIE5DV0NEIFx1MDAyNiBTVkxIV0NEIiwgImRhdGVfdGltZSI6ICIyMDIwLTAzLTI0VDE1OjAwOjAwLjAwMCIsICJkaXYiOiAiMSIsICJkd3JfYWJicmV2IjogIlBBTERJVENPIiwgImZsYWciOiBudWxsLCAiaHR0cF9saW5rYWdlLnVybCI6ICJodHRwczovL2R3ci5zdGF0ZS5jby51cy9TdXJmYWNlV2F0ZXIvZGF0YS9kZXRhaWxfZ3JhcGguYXNweD9JRD1QQUxESVRDT1x1MDAyNk1UWVBFPURJU0NIUkciLCAibG9jYXRpb24ubGF0aXR1ZGUiOiA0MC4yMTI1MDUsICJsb2NhdGlvbi5sb25naXR1ZGUiOiAtMTA1LjI1MTgyNiwgImxvY2F0aW9uLm5lZWRzX3JlY29kaW5nIjogZmFsc2UsICJzdGFnZSI6ICIwLjEyIiwgInN0YXRpb25fbmFtZSI6ICJQQUxNRVJUT04gRElUQ0giLCAic3RhdGlvbl9zdGF0dXMiOiAiQWN0aXZlIiwgInN0YXRpb25fdHlwZSI6ICJEaXZlcnNpb24iLCAidXNnc19zdGF0aW9uX2lkIjogbnVsbCwgInZhcmlhYmxlIjogIkRJU0NIUkciLCAid2QiOiAiNSJ9LCAidHlwZSI6ICJGZWF0dXJlIn0sIHsiYmJveCI6IFstMTA1LjI1OTc5NSwgNDAuMjE5MDQ2LCAtMTA1LjI1OTc5NSwgNDAuMjE5MDQ2XSwgImdlb21ldHJ5IjogeyJjb29yZGluYXRlcyI6IFstMTA1LjI1OTc5NSwgNDAuMjE5MDQ2XSwgInR5cGUiOiAiUG9pbnQifSwgImlkIjogIjQ1IiwgInByb3BlcnRpZXMiOiB7ImFtb3VudCI6ICIwLjAwIiwgImNvdW50eSI6ICJCT1VMREVSIiwgImRhdGFfc291cmNlIjogIkNvb3BlcmF0aXZlIFByb2dyYW0gb2YgQ0RXUiwgTkNXQ0QgXHUwMDI2IFNWTEhXQ0QiLCAiZGF0ZV90aW1lIjogIjIwMjAtMDMtMjRUMTQ6NDU6MDAuMDAwIiwgImRpdiI6ICIxIiwgImR3cl9hYmJyZXYiOiAiU1VQRElUQ08iLCAiZmxhZyI6IG51bGwsICJodHRwX2xpbmthZ2UudXJsIjogImh0dHBzOi8vZHdyLnN0YXRlLmNvLnVzL1N1cmZhY2VXYXRlci9kYXRhL2RldGFpbF9ncmFwaC5hc3B4P0lEPVNVUERJVENPXHUwMDI2TVRZUEU9RElTQ0hSRyIsICJsb2NhdGlvbi5sYXRpdHVkZSI6IDQwLjIxOTA0NiwgImxvY2F0aW9uLmxvbmdpdHVkZSI6IC0xMDUuMjU5Nzk1LCAibG9jYXRpb24ubmVlZHNfcmVjb2RpbmciOiBmYWxzZSwgInN0YWdlIjogIjAuMDAiLCAic3RhdGlvbl9uYW1lIjogIlNVUFBMWSBESVRDSCIsICJzdGF0aW9uX3N0YXR1cyI6ICJBY3RpdmUiLCAic3RhdGlvbl90eXBlIjogIkRpdmVyc2lvbiIsICJ1c2dzX3N0YXRpb25faWQiOiBudWxsLCAidmFyaWFibGUiOiAiRElTQ0hSRyIsICJ3ZCI6ICI1In0sICJ0eXBlIjogIkZlYXR1cmUifSwgeyJiYm94IjogWy0xMDUuMTg5MTkxLCA0MC4xODc1NzgsIC0xMDUuMTg5MTkxLCA0MC4xODc1NzhdLCAiZ2VvbWV0cnkiOiB7ImNvb3JkaW5hdGVzIjogWy0xMDUuMTg5MTkxLCA0MC4xODc1NzhdLCAidHlwZSI6ICJQb2ludCJ9LCAiaWQiOiAiNDYiLCAicHJvcGVydGllcyI6IHsiYW1vdW50IjogIjI4MTkuNjgiLCAiY291bnR5IjogIkJPVUxERVIiLCAiZGF0YV9zb3VyY2UiOiAiQ29vcGVyYXRpdmUgUHJvZ3JhbSBvZiBDRFdSLCBOQ1dDRCBcdTAwMjYgU1ZMSFdDRCIsICJkYXRlX3RpbWUiOiAiMjAyMC0wMy0yNFQxNTowMDowMC4wMDAiLCAiZGl2IjogIjEiLCAiZHdyX2FiYnJldiI6ICJERU5UQVlDTyIsICJmbGFnIjogbnVsbCwgImh0dHBfbGlua2FnZS51cmwiOiAiaHR0cHM6Ly9kd3Iuc3RhdGUuY28udXMvU3VyZmFjZVdhdGVyL2RhdGEvZGV0YWlsX2dyYXBoLmFzcHg/SUQ9REVOVEFZQ09cdTAwMjZNVFlQRT1ESVNDSFJHIiwgImxvY2F0aW9uLmxhdGl0dWRlIjogNDAuMTg3NTc4LCAibG9jYXRpb24ubG9uZ2l0dWRlIjogLTEwNS4xODkxOTEsICJsb2NhdGlvbi5uZWVkc19yZWNvZGluZyI6IGZhbHNlLCAic3RhZ2UiOiAiNjIuMzEiLCAic3RhdGlvbl9uYW1lIjogIkRFTklPIFRBWUxPUiBESVRDSCIsICJzdGF0aW9uX3N0YXR1cyI6ICJBY3RpdmUiLCAic3RhdGlvbl90eXBlIjogIkRpdmVyc2lvbiIsICJ1c2dzX3N0YXRpb25faWQiOiBudWxsLCAidmFyaWFibGUiOiAiRElTQ0hSRyIsICJ3ZCI6ICI1In0sICJ0eXBlIjogIkZlYXR1cmUifSwgeyJiYm94IjogWy0xMDUuMzY0OTE3MDAwMDAwMDIsIDQwLjA0MjAyOCwgLTEwNS4zNjQ5MTcwMDAwMDAwMiwgNDAuMDQyMDI4XSwgImdlb21ldHJ5IjogeyJjb29yZGluYXRlcyI6IFstMTA1LjM2NDkxNzAwMDAwMDAyLCA0MC4wNDIwMjhdLCAidHlwZSI6ICJQb2ludCJ9LCAiaWQiOiAiNDciLCAicHJvcGVydGllcyI6IHsiYW1vdW50IjogbnVsbCwgImNvdW50eSI6ICJCT1VMREVSIiwgImRhdGFfc291cmNlIjogIlUuUy4gR2VvbG9naWNhbCBTdXJ2ZXkiLCAiZGF0ZV90aW1lIjogIjE5OTktMDktMzBUMDA6MDA6MDAuMDAwIiwgImRpdiI6ICIxIiwgImR3cl9hYmJyZXYiOiAiRlJNTE1SQ08iLCAiZmxhZyI6IG51bGwsICJodHRwX2xpbmthZ2UudXJsIjogImh0dHBzOi8vd2F0ZXJkYXRhLnVzZ3MuZ292L253aXMvdXY/MDY3Mjc0MTAiLCAibG9jYXRpb24ubGF0aXR1ZGUiOiA0MC4wNDIwMjgsICJsb2NhdGlvbi5sb25naXR1ZGUiOiAtMTA1LjM2NDkxNywgImxvY2F0aW9uLm5lZWRzX3JlY29kaW5nIjogZmFsc2UsICJzdGFnZSI6IG51bGwsICJzdGF0aW9uX25hbWUiOiAiRk9VUk1JTEUgQ1JFRUsgQVQgTE9HQU4gTUlMTCBST0FEIE5FQVIgQ1JJU01BTiwgQ08iLCAic3RhdGlvbl9zdGF0dXMiOiAiQWN0aXZlIiwgInN0YXRpb25fdHlwZSI6ICJTdHJlYW0iLCAidXNnc19zdGF0aW9uX2lkIjogIjA2NzI3NDEwIiwgInZhcmlhYmxlIjogIkRJU0NIUkciLCAid2QiOiAiNiJ9LCAidHlwZSI6ICJGZWF0dXJlIn0sIHsiYmJveCI6IFstMTA1LjE3ODU2NywgNDAuMTc3MDgwMDAwMDAwMDA0LCAtMTA1LjE3ODU2NywgNDAuMTc3MDgwMDAwMDAwMDA0XSwgImdlb21ldHJ5IjogeyJjb29yZGluYXRlcyI6IFstMTA1LjE3ODU2NywgNDAuMTc3MDgwMDAwMDAwMDA0XSwgInR5cGUiOiAiUG9pbnQifSwgImlkIjogIjQ4IiwgInByb3BlcnRpZXMiOiB7ImFtb3VudCI6ICIxLjI5IiwgImNvdW50eSI6ICJCT1VMREVSIiwgImRhdGFfc291cmNlIjogIkNvb3BlcmF0aXZlIFNEUiBQcm9ncmFtIG9mIENEV1IgXHUwMDI2IE5DV0NEIiwgImRhdGVfdGltZSI6ICIyMDIwLTAzLTI0VDE1OjAwOjAwLjAwMCIsICJkaXYiOiAiMSIsICJkd3JfYWJicmV2IjogIlBDS1BFTENPIiwgImZsYWciOiBudWxsLCAiaHR0cF9saW5rYWdlLnVybCI6ICJodHRwczovL2R3ci5zdGF0ZS5jby51cy9TdXJmYWNlV2F0ZXIvZGF0YS9kZXRhaWxfZ3JhcGguYXNweD9JRD1QQ0tQRUxDT1x1MDAyNk1UWVBFPURJU0NIUkciLCAibG9jYXRpb24ubGF0aXR1ZGUiOiA0MC4xNzcwOCwgImxvY2F0aW9uLmxvbmdpdHVkZSI6IC0xMDUuMTc4NTY3LCAibG9jYXRpb24ubmVlZHNfcmVjb2RpbmciOiBmYWxzZSwgInN0YWdlIjogIjAuMTYiLCAic3RhdGlvbl9uYW1lIjogIlBFQ0sgUEVMTEEgQ0xPVkVSIERJVENIIiwgInN0YXRpb25fc3RhdHVzIjogIkFjdGl2ZSIsICJzdGF0aW9uX3R5cGUiOiAiRGl2ZXJzaW9uIiwgInVzZ3Nfc3RhdGlvbl9pZCI6IG51bGwsICJ2YXJpYWJsZSI6ICJESVNDSFJHIiwgIndkIjogIjUifSwgInR5cGUiOiAiRmVhdHVyZSJ9LCB7ImJib3giOiBbLTEwNS4zNTczMDgsIDM5Ljk0NzcwNCwgLTEwNS4zNTczMDgsIDM5Ljk0NzcwNF0sICJnZW9tZXRyeSI6IHsiY29vcmRpbmF0ZXMiOiBbLTEwNS4zNTczMDgsIDM5Ljk0NzcwNF0sICJ0eXBlIjogIlBvaW50In0sICJpZCI6ICI0OSIsICJwcm9wZXJ0aWVzIjogeyJhbW91bnQiOiAiMTEzNjcuMDAiLCAiY291bnR5IjogIkJPVUxERVIiLCAiZGF0YV9zb3VyY2UiOiAiQ28uIERpdmlzaW9uIG9mIFdhdGVyIFJlc291cmNlcyIsICJkYXRlX3RpbWUiOiAiMjAyMC0wMy0yNFQxNDozMDowMC4wMDAiLCAiZGl2IjogIjEiLCAiZHdyX2FiYnJldiI6ICJHUk9TUkVDTyIsICJmbGFnIjogbnVsbCwgImh0dHBfbGlua2FnZS51cmwiOiAiaHR0cHM6Ly9kd3Iuc3RhdGUuY28udXMvU3VyZmFjZVdhdGVyL2RhdGEvZGV0YWlsX2dyYXBoLmFzcHg/SUQ9R1JPU1JFQ09cdTAwMjZNVFlQRT1TVE9SQUdFIiwgImxvY2F0aW9uLmxhdGl0dWRlIjogMzkuOTQ3NzA0LCAibG9jYXRpb24ubG9uZ2l0dWRlIjogLTEwNS4zNTczMDgsICJsb2NhdGlvbi5uZWVkc19yZWNvZGluZyI6IGZhbHNlLCAic3RhZ2UiOiAiNzE3NS42MSIsICJzdGF0aW9uX25hbWUiOiAiR1JPU1MgUkVTRVJWT0lSICIsICJzdGF0aW9uX3N0YXR1cyI6ICJBY3RpdmUiLCAic3RhdGlvbl90eXBlIjogIlJlc2Vydm9pciIsICJ1c2dzX3N0YXRpb25faWQiOiBudWxsLCAidmFyaWFibGUiOiAiU1RPUkFHRSIsICJ3ZCI6ICI2In0sICJ0eXBlIjogIkZlYXR1cmUifV0sICJ0eXBlIjogIkZlYXR1cmVDb2xsZWN0aW9uIn0pOwogICAgICAgIAo8L3NjcmlwdD4=" style="position:absolute;width:100%;height:100%;left:0;top:0;border:none !important;" allowfullscreen webkitallowfullscreen mozallowfullscreen></iframe></div></div>





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



<div style="width:100%;"><div style="position:relative;width:100%;height:0;padding-bottom:60%;"><iframe src="data:text/html;charset=utf-8;base64,PCFET0NUWVBFIGh0bWw+CjxoZWFkPiAgICAKICAgIDxtZXRhIGh0dHAtZXF1aXY9ImNvbnRlbnQtdHlwZSIgY29udGVudD0idGV4dC9odG1sOyBjaGFyc2V0PVVURi04IiAvPgogICAgCiAgICAgICAgPHNjcmlwdD4KICAgICAgICAgICAgTF9OT19UT1VDSCA9IGZhbHNlOwogICAgICAgICAgICBMX0RJU0FCTEVfM0QgPSBmYWxzZTsKICAgICAgICA8L3NjcmlwdD4KICAgIAogICAgPHNjcmlwdCBzcmM9Imh0dHBzOi8vY2RuLmpzZGVsaXZyLm5ldC9ucG0vbGVhZmxldEAxLjUuMS9kaXN0L2xlYWZsZXQuanMiPjwvc2NyaXB0PgogICAgPHNjcmlwdCBzcmM9Imh0dHBzOi8vY29kZS5qcXVlcnkuY29tL2pxdWVyeS0xLjEyLjQubWluLmpzIj48L3NjcmlwdD4KICAgIDxzY3JpcHQgc3JjPSJodHRwczovL21heGNkbi5ib290c3RyYXBjZG4uY29tL2Jvb3RzdHJhcC8zLjIuMC9qcy9ib290c3RyYXAubWluLmpzIj48L3NjcmlwdD4KICAgIDxzY3JpcHQgc3JjPSJodHRwczovL2NkbmpzLmNsb3VkZmxhcmUuY29tL2FqYXgvbGlicy9MZWFmbGV0LmF3ZXNvbWUtbWFya2Vycy8yLjAuMi9sZWFmbGV0LmF3ZXNvbWUtbWFya2Vycy5qcyI+PC9zY3JpcHQ+CiAgICA8bGluayByZWw9InN0eWxlc2hlZXQiIGhyZWY9Imh0dHBzOi8vY2RuLmpzZGVsaXZyLm5ldC9ucG0vbGVhZmxldEAxLjUuMS9kaXN0L2xlYWZsZXQuY3NzIi8+CiAgICA8bGluayByZWw9InN0eWxlc2hlZXQiIGhyZWY9Imh0dHBzOi8vbWF4Y2RuLmJvb3RzdHJhcGNkbi5jb20vYm9vdHN0cmFwLzMuMi4wL2Nzcy9ib290c3RyYXAubWluLmNzcyIvPgogICAgPGxpbmsgcmVsPSJzdHlsZXNoZWV0IiBocmVmPSJodHRwczovL21heGNkbi5ib290c3RyYXBjZG4uY29tL2Jvb3RzdHJhcC8zLjIuMC9jc3MvYm9vdHN0cmFwLXRoZW1lLm1pbi5jc3MiLz4KICAgIDxsaW5rIHJlbD0ic3R5bGVzaGVldCIgaHJlZj0iaHR0cHM6Ly9tYXhjZG4uYm9vdHN0cmFwY2RuLmNvbS9mb250LWF3ZXNvbWUvNC42LjMvY3NzL2ZvbnQtYXdlc29tZS5taW4uY3NzIi8+CiAgICA8bGluayByZWw9InN0eWxlc2hlZXQiIGhyZWY9Imh0dHBzOi8vY2RuanMuY2xvdWRmbGFyZS5jb20vYWpheC9saWJzL0xlYWZsZXQuYXdlc29tZS1tYXJrZXJzLzIuMC4yL2xlYWZsZXQuYXdlc29tZS1tYXJrZXJzLmNzcyIvPgogICAgPGxpbmsgcmVsPSJzdHlsZXNoZWV0IiBocmVmPSJodHRwczovL3Jhd2Nkbi5naXRoYWNrLmNvbS9weXRob24tdmlzdWFsaXphdGlvbi9mb2xpdW0vbWFzdGVyL2ZvbGl1bS90ZW1wbGF0ZXMvbGVhZmxldC5hd2Vzb21lLnJvdGF0ZS5jc3MiLz4KICAgIDxzdHlsZT5odG1sLCBib2R5IHt3aWR0aDogMTAwJTtoZWlnaHQ6IDEwMCU7bWFyZ2luOiAwO3BhZGRpbmc6IDA7fTwvc3R5bGU+CiAgICA8c3R5bGU+I21hcCB7cG9zaXRpb246YWJzb2x1dGU7dG9wOjA7Ym90dG9tOjA7cmlnaHQ6MDtsZWZ0OjA7fTwvc3R5bGU+CiAgICAKICAgICAgICAgICAgPG1ldGEgbmFtZT0idmlld3BvcnQiIGNvbnRlbnQ9IndpZHRoPWRldmljZS13aWR0aCwKICAgICAgICAgICAgICAgIGluaXRpYWwtc2NhbGU9MS4wLCBtYXhpbXVtLXNjYWxlPTEuMCwgdXNlci1zY2FsYWJsZT1ubyIgLz4KICAgICAgICAgICAgPHN0eWxlPgogICAgICAgICAgICAgICAgI21hcF8zMmQ5MGJkNDY0YjU0MTkyYTAwYzU5MDhjMjIyZjMyMiB7CiAgICAgICAgICAgICAgICAgICAgcG9zaXRpb246IHJlbGF0aXZlOwogICAgICAgICAgICAgICAgICAgIHdpZHRoOiAxMDAuMCU7CiAgICAgICAgICAgICAgICAgICAgaGVpZ2h0OiAxMDAuMCU7CiAgICAgICAgICAgICAgICAgICAgbGVmdDogMC4wJTsKICAgICAgICAgICAgICAgICAgICB0b3A6IDAuMCU7CiAgICAgICAgICAgICAgICB9CiAgICAgICAgICAgIDwvc3R5bGU+CiAgICAgICAgCiAgICA8c2NyaXB0IHNyYz0iaHR0cHM6Ly9jZG5qcy5jbG91ZGZsYXJlLmNvbS9hamF4L2xpYnMvbGVhZmxldC5tYXJrZXJjbHVzdGVyLzEuMS4wL2xlYWZsZXQubWFya2VyY2x1c3Rlci5qcyI+PC9zY3JpcHQ+CiAgICA8bGluayByZWw9InN0eWxlc2hlZXQiIGhyZWY9Imh0dHBzOi8vY2RuanMuY2xvdWRmbGFyZS5jb20vYWpheC9saWJzL2xlYWZsZXQubWFya2VyY2x1c3Rlci8xLjEuMC9NYXJrZXJDbHVzdGVyLmNzcyIvPgogICAgPGxpbmsgcmVsPSJzdHlsZXNoZWV0IiBocmVmPSJodHRwczovL2NkbmpzLmNsb3VkZmxhcmUuY29tL2FqYXgvbGlicy9sZWFmbGV0Lm1hcmtlcmNsdXN0ZXIvMS4xLjAvTWFya2VyQ2x1c3Rlci5EZWZhdWx0LmNzcyIvPgo8L2hlYWQ+Cjxib2R5PiAgICAKICAgIAogICAgICAgICAgICA8ZGl2IGNsYXNzPSJmb2xpdW0tbWFwIiBpZD0ibWFwXzMyZDkwYmQ0NjRiNTQxOTJhMDBjNTkwOGMyMjJmMzIyIiA+PC9kaXY+CiAgICAgICAgCjwvYm9keT4KPHNjcmlwdD4gICAgCiAgICAKICAgICAgICAgICAgdmFyIG1hcF8zMmQ5MGJkNDY0YjU0MTkyYTAwYzU5MDhjMjIyZjMyMiA9IEwubWFwKAogICAgICAgICAgICAgICAgIm1hcF8zMmQ5MGJkNDY0YjU0MTkyYTAwYzU5MDhjMjIyZjMyMiIsCiAgICAgICAgICAgICAgICB7CiAgICAgICAgICAgICAgICAgICAgY2VudGVyOiBbNDAuMDEsIC0xMDUuMjddLAogICAgICAgICAgICAgICAgICAgIGNyczogTC5DUlMuRVBTRzM4NTcsCiAgICAgICAgICAgICAgICAgICAgem9vbTogMTAsCiAgICAgICAgICAgICAgICAgICAgem9vbUNvbnRyb2w6IHRydWUsCiAgICAgICAgICAgICAgICAgICAgcHJlZmVyQ2FudmFzOiBmYWxzZSwKICAgICAgICAgICAgICAgIH0KICAgICAgICAgICAgKTsKCiAgICAgICAgICAgIAoKICAgICAgICAKICAgIAogICAgICAgICAgICB2YXIgdGlsZV9sYXllcl8xOGJjYTgzYzIyNmI0OWE4Yjk2MWJjNGQ1NjdkNGUwYiA9IEwudGlsZUxheWVyKAogICAgICAgICAgICAgICAgImh0dHBzOi8vY2FydG9kYi1iYXNlbWFwcy17c30uZ2xvYmFsLnNzbC5mYXN0bHkubmV0L2xpZ2h0X2FsbC97en0ve3h9L3t5fS5wbmciLAogICAgICAgICAgICAgICAgeyJhdHRyaWJ1dGlvbiI6ICJcdTAwMjZjb3B5OyBcdTAwM2NhIGhyZWY9XCJodHRwOi8vd3d3Lm9wZW5zdHJlZXRtYXAub3JnL2NvcHlyaWdodFwiXHUwMDNlT3BlblN0cmVldE1hcFx1MDAzYy9hXHUwMDNlIGNvbnRyaWJ1dG9ycyBcdTAwMjZjb3B5OyBcdTAwM2NhIGhyZWY9XCJodHRwOi8vY2FydG9kYi5jb20vYXR0cmlidXRpb25zXCJcdTAwM2VDYXJ0b0RCXHUwMDNjL2FcdTAwM2UsIENhcnRvREIgXHUwMDNjYSBocmVmID1cImh0dHA6Ly9jYXJ0b2RiLmNvbS9hdHRyaWJ1dGlvbnNcIlx1MDAzZWF0dHJpYnV0aW9uc1x1MDAzYy9hXHUwMDNlIiwgImRldGVjdFJldGluYSI6IGZhbHNlLCAibWF4TmF0aXZlWm9vbSI6IDE4LCAibWF4Wm9vbSI6IDE4LCAibWluWm9vbSI6IDAsICJub1dyYXAiOiBmYWxzZSwgIm9wYWNpdHkiOiAxLCAic3ViZG9tYWlucyI6ICJhYmMiLCAidG1zIjogZmFsc2V9CiAgICAgICAgICAgICkuYWRkVG8obWFwXzMyZDkwYmQ0NjRiNTQxOTJhMDBjNTkwOGMyMjJmMzIyKTsKICAgICAgICAKICAgIAogICAgICAgICAgICB2YXIgbWFya2VyX2NsdXN0ZXJfMzEyNzJjMzUzZGQ5NDVlNmE4NTI2ZTI5ODE0ZjU2YjcgPSBMLm1hcmtlckNsdXN0ZXJHcm91cCgKICAgICAgICAgICAgICAgIHt9CiAgICAgICAgICAgICk7CiAgICAgICAgICAgIG1hcF8zMmQ5MGJkNDY0YjU0MTkyYTAwYzU5MDhjMjIyZjMyMi5hZGRMYXllcihtYXJrZXJfY2x1c3Rlcl8zMTI3MmMzNTNkZDk0NWU2YTg1MjZlMjk4MTRmNTZiNyk7CiAgICAgICAgCiAgICAKICAgICAgICAgICAgdmFyIG1hcmtlcl8wM2I2OGE1MjJiNmE0NmExYmY3YmRlMDZhYjlkNGQzMCA9IEwubWFya2VyKAogICAgICAgICAgICAgICAgWzQwLjE4NTAzMywgLTEwNS4xODU3ODldLAogICAgICAgICAgICAgICAge30KICAgICAgICAgICAgKS5hZGRUbyhtYXJrZXJfY2x1c3Rlcl8zMTI3MmMzNTNkZDk0NWU2YTg1MjZlMjk4MTRmNTZiNyk7CiAgICAgICAgCiAgICAKICAgICAgICB2YXIgcG9wdXBfYTZkM2Q2MmYyOGU5NDE4ZGI3ZjMxMGQwYjEyNTRmM2MgPSBMLnBvcHVwKHsibWF4V2lkdGgiOiAiMTAwJSJ9KTsKCiAgICAgICAgCiAgICAgICAgICAgIHZhciBodG1sXzZkOWY2YTg4ZWIzNTQ4NjFhNWYzMzM2M2FmOGI0OGQyID0gJChgPGRpdiBpZD0iaHRtbF82ZDlmNmE4OGViMzU0ODYxYTVmMzMzNjNhZjhiNDhkMiIgc3R5bGU9IndpZHRoOiAxMDAuMCU7IGhlaWdodDogMTAwLjAlOyI+TmFtZTogWldFQ0sgQU5EIFRVUk5FUiBESVRDSCBQcmVjaXA6IDAuMTQ8L2Rpdj5gKVswXTsKICAgICAgICAgICAgcG9wdXBfYTZkM2Q2MmYyOGU5NDE4ZGI3ZjMxMGQwYjEyNTRmM2Muc2V0Q29udGVudChodG1sXzZkOWY2YTg4ZWIzNTQ4NjFhNWYzMzM2M2FmOGI0OGQyKTsKICAgICAgICAKCiAgICAgICAgbWFya2VyXzAzYjY4YTUyMmI2YTQ2YTFiZjdiZGUwNmFiOWQ0ZDMwLmJpbmRQb3B1cChwb3B1cF9hNmQzZDYyZjI4ZTk0MThkYjdmMzEwZDBiMTI1NGYzYykKICAgICAgICA7CgogICAgICAgIAogICAgCiAgICAKICAgICAgICAgICAgdmFyIG1hcmtlcl9iNGZhOTIzMzIzMGU0ZGRhOTdmNTFiMGU1NTdhYjYzYiA9IEwubWFya2VyKAogICAgICAgICAgICAgICAgWzQwLjIyMDcwMiwgLTEwNS4yNjM0OV0sCiAgICAgICAgICAgICAgICB7fQogICAgICAgICAgICApLmFkZFRvKG1hcmtlcl9jbHVzdGVyXzMxMjcyYzM1M2RkOTQ1ZTZhODUyNmUyOTgxNGY1NmI3KTsKICAgICAgICAKICAgIAogICAgICAgIHZhciBwb3B1cF85ZTBkZDEwMjk5YmE0YjEyYjdhZTc1NGM1OGNhODllNCA9IEwucG9wdXAoeyJtYXhXaWR0aCI6ICIxMDAlIn0pOwoKICAgICAgICAKICAgICAgICAgICAgdmFyIGh0bWxfMWE1NDAwZjVmNWM4NGQ3YTk0YjA1YWYyNDhkYWNjZGQgPSAkKGA8ZGl2IGlkPSJodG1sXzFhNTQwMGY1ZjVjODRkN2E5NGIwNWFmMjQ4ZGFjY2RkIiBzdHlsZT0id2lkdGg6IDEwMC4wJTsgaGVpZ2h0OiAxMDAuMCU7Ij5OYW1lOiBTQUlOVCBWUkFJTiBDUkVFSyBBVCBMWU9OUywgQ08gUHJlY2lwOiAzOS4yMDwvZGl2PmApWzBdOwogICAgICAgICAgICBwb3B1cF85ZTBkZDEwMjk5YmE0YjEyYjdhZTc1NGM1OGNhODllNC5zZXRDb250ZW50KGh0bWxfMWE1NDAwZjVmNWM4NGQ3YTk0YjA1YWYyNDhkYWNjZGQpOwogICAgICAgIAoKICAgICAgICBtYXJrZXJfYjRmYTkyMzMyMzBlNGRkYTk3ZjUxYjBlNTU3YWI2M2IuYmluZFBvcHVwKHBvcHVwXzllMGRkMTAyOTliYTRiMTJiN2FlNzU0YzU4Y2E4OWU0KQogICAgICAgIDsKCiAgICAgICAgCiAgICAKICAgIAogICAgICAgICAgICB2YXIgbWFya2VyXzdhZDEwY2ZlODRiMTQ2ZDI4ZTU1NDE2ZTZkNDliM2ZkID0gTC5tYXJrZXIoCiAgICAgICAgICAgICAgICBbNDAuMTk2NDIyLCAtMTA1LjIwNjU5Ml0sCiAgICAgICAgICAgICAgICB7fQogICAgICAgICAgICApLmFkZFRvKG1hcmtlcl9jbHVzdGVyXzMxMjcyYzM1M2RkOTQ1ZTZhODUyNmUyOTgxNGY1NmI3KTsKICAgICAgICAKICAgIAogICAgICAgIHZhciBwb3B1cF9hMGY5ZWI3MDY5NDM0MGYzYTJhYzQzNDQwNTUxMzljOCA9IEwucG9wdXAoeyJtYXhXaWR0aCI6ICIxMDAlIn0pOwoKICAgICAgICAKICAgICAgICAgICAgdmFyIGh0bWxfZTYxZjRmZDkyNzljNDVmNWJiZDI5ZTI2ZGQxYzFjOWYgPSAkKGA8ZGl2IGlkPSJodG1sX2U2MWY0ZmQ5Mjc5YzQ1ZjViYmQyOWUyNmRkMWMxYzlmIiBzdHlsZT0id2lkdGg6IDEwMC4wJTsgaGVpZ2h0OiAxMDAuMCU7Ij5OYW1lOiBPTElHQVJDSFkgRElUQ0ggRElWRVJTSU9OIFByZWNpcDogMy43NTwvZGl2PmApWzBdOwogICAgICAgICAgICBwb3B1cF9hMGY5ZWI3MDY5NDM0MGYzYTJhYzQzNDQwNTUxMzljOC5zZXRDb250ZW50KGh0bWxfZTYxZjRmZDkyNzljNDVmNWJiZDI5ZTI2ZGQxYzFjOWYpOwogICAgICAgIAoKICAgICAgICBtYXJrZXJfN2FkMTBjZmU4NGIxNDZkMjhlNTU0MTZlNmQ0OWIzZmQuYmluZFBvcHVwKHBvcHVwX2EwZjllYjcwNjk0MzQwZjNhMmFjNDM0NDA1NTEzOWM4KQogICAgICAgIDsKCiAgICAgICAgCiAgICAKICAgIAogICAgICAgICAgICB2YXIgbWFya2VyX2YyYzViMzQ1MWZlYTQwYmM4MGNhNzEyNmNmZDU2NmZhID0gTC5tYXJrZXIoCiAgICAgICAgICAgICAgICBbMzkuOTMxODEzLCAtMTA1LjMwODQzMl0sCiAgICAgICAgICAgICAgICB7fQogICAgICAgICAgICApLmFkZFRvKG1hcmtlcl9jbHVzdGVyXzMxMjcyYzM1M2RkOTQ1ZTZhODUyNmUyOTgxNGY1NmI3KTsKICAgICAgICAKICAgIAogICAgICAgIHZhciBwb3B1cF84ZDFjZjgwN2ZhYTg0ZGU4OTRjMmY2NTNlMDZkNWIyOCA9IEwucG9wdXAoeyJtYXhXaWR0aCI6ICIxMDAlIn0pOwoKICAgICAgICAKICAgICAgICAgICAgdmFyIGh0bWxfYzUxMzJiYzdkMzdhNDk5NGEyZDk5OThjYzk3NjZkMWMgPSAkKGA8ZGl2IGlkPSJodG1sX2M1MTMyYmM3ZDM3YTQ5OTRhMmQ5OTk4Y2M5NzY2ZDFjIiBzdHlsZT0id2lkdGg6IDEwMC4wJTsgaGVpZ2h0OiAxMDAuMCU7Ij5OYW1lOiBTT1VUSCBCT1VMREVSIENSRUVLIERJVkVSU0lPTiBORUFSIEVMRE9SQURPIFNQUklOR1MgUHJlY2lwOiAwLjAwPC9kaXY+YClbMF07CiAgICAgICAgICAgIHBvcHVwXzhkMWNmODA3ZmFhODRkZTg5NGMyZjY1M2UwNmQ1YjI4LnNldENvbnRlbnQoaHRtbF9jNTEzMmJjN2QzN2E0OTk0YTJkOTk5OGNjOTc2NmQxYyk7CiAgICAgICAgCgogICAgICAgIG1hcmtlcl9mMmM1YjM0NTFmZWE0MGJjODBjYTcxMjZjZmQ1NjZmYS5iaW5kUG9wdXAocG9wdXBfOGQxY2Y4MDdmYWE4NGRlODk0YzJmNjUzZTA2ZDViMjgpCiAgICAgICAgOwoKICAgICAgICAKICAgIAogICAgCiAgICAgICAgICAgIHZhciBtYXJrZXJfNTIwOWM1ZDc4MjRlNDlhNjhlZjc4YjdmZWJhZGYyNzQgPSBMLm1hcmtlcigKICAgICAgICAgICAgICAgIFs0MC4xOTM3NTgsIC0xMDUuMjEwMzldLAogICAgICAgICAgICAgICAge30KICAgICAgICAgICAgKS5hZGRUbyhtYXJrZXJfY2x1c3Rlcl8zMTI3MmMzNTNkZDk0NWU2YTg1MjZlMjk4MTRmNTZiNyk7CiAgICAgICAgCiAgICAKICAgICAgICB2YXIgcG9wdXBfNDkwYjAwMjY1MjQ2NDRhM2FlZGVkZGU3ZGNiNmU0NTIgPSBMLnBvcHVwKHsibWF4V2lkdGgiOiAiMTAwJSJ9KTsKCiAgICAgICAgCiAgICAgICAgICAgIHZhciBodG1sXzA5MDEwYTk1NDgxOTRmOWE5NjkzZGQwMDcwMGQwMjA4ID0gJChgPGRpdiBpZD0iaHRtbF8wOTAxMGE5NTQ4MTk0ZjlhOTY5M2RkMDA3MDBkMDIwOCIgc3R5bGU9IndpZHRoOiAxMDAuMCU7IGhlaWdodDogMTAwLjAlOyI+TmFtZTogQ0xPVUdIIEFORCBUUlVFIERJVENIIFByZWNpcDogMC4wMDwvZGl2PmApWzBdOwogICAgICAgICAgICBwb3B1cF80OTBiMDAyNjUyNDY0NGEzYWVkZWRkZTdkY2I2ZTQ1Mi5zZXRDb250ZW50KGh0bWxfMDkwMTBhOTU0ODE5NGY5YTk2OTNkZDAwNzAwZDAyMDgpOwogICAgICAgIAoKICAgICAgICBtYXJrZXJfNTIwOWM1ZDc4MjRlNDlhNjhlZjc4YjdmZWJhZGYyNzQuYmluZFBvcHVwKHBvcHVwXzQ5MGIwMDI2NTI0NjQ0YTNhZWRlZGRlN2RjYjZlNDUyKQogICAgICAgIDsKCiAgICAgICAgCiAgICAKICAgIAogICAgICAgICAgICB2YXIgbWFya2VyXzNhODMwYWZjNDhkMjQ2MmM4MGI4OTQ3ZTQwYzk0NzRkID0gTC5tYXJrZXIoCiAgICAgICAgICAgICAgICBbNDAuMDA2MzgsIC0xMDUuMzMwODQxXSwKICAgICAgICAgICAgICAgIHt9CiAgICAgICAgICAgICkuYWRkVG8obWFya2VyX2NsdXN0ZXJfMzEyNzJjMzUzZGQ5NDVlNmE4NTI2ZTI5ODE0ZjU2YjcpOwogICAgICAgIAogICAgCiAgICAgICAgdmFyIHBvcHVwXzBiZGRiODA1Y2Y2NjQ5ZjdiMGNkNjE1MGJlNjUzNWE0ID0gTC5wb3B1cCh7Im1heFdpZHRoIjogIjEwMCUifSk7CgogICAgICAgIAogICAgICAgICAgICB2YXIgaHRtbF82YWE0MzUzYzA5ZTc0ZTdmOGE4YWYxOGVmYWU4MjMyOSA9ICQoYDxkaXYgaWQ9Imh0bWxfNmFhNDM1M2MwOWU3NGU3ZjhhOGFmMThlZmFlODIzMjkiIHN0eWxlPSJ3aWR0aDogMTAwLjAlOyBoZWlnaHQ6IDEwMC4wJTsiPk5hbWU6IEJPVUxERVIgQ1JFRUsgTkVBUiBPUk9ERUxMLCBDTy4gUHJlY2lwOiAyMC40MDwvZGl2PmApWzBdOwogICAgICAgICAgICBwb3B1cF8wYmRkYjgwNWNmNjY0OWY3YjBjZDYxNTBiZTY1MzVhNC5zZXRDb250ZW50KGh0bWxfNmFhNDM1M2MwOWU3NGU3ZjhhOGFmMThlZmFlODIzMjkpOwogICAgICAgIAoKICAgICAgICBtYXJrZXJfM2E4MzBhZmM0OGQyNDYyYzgwYjg5NDdlNDBjOTQ3NGQuYmluZFBvcHVwKHBvcHVwXzBiZGRiODA1Y2Y2NjQ5ZjdiMGNkNjE1MGJlNjUzNWE0KQogICAgICAgIDsKCiAgICAgICAgCiAgICAKICAgIAogICAgICAgICAgICB2YXIgbWFya2VyXzBhYjJiYjU2ZDFjOTRiNTM4NjcwYzIwOTNjZTdiNWQ1ID0gTC5tYXJrZXIoCiAgICAgICAgICAgICAgICBbNDAuMjA0MTkzLCAtMTA1LjIxODc3N10sCiAgICAgICAgICAgICAgICB7fQogICAgICAgICAgICApLmFkZFRvKG1hcmtlcl9jbHVzdGVyXzMxMjcyYzM1M2RkOTQ1ZTZhODUyNmUyOTgxNGY1NmI3KTsKICAgICAgICAKICAgIAogICAgICAgIHZhciBwb3B1cF9lMDk3YTZlMzE1MGI0ZWNlOTdmYTY4MmM0ZmIwYzRlMSA9IEwucG9wdXAoeyJtYXhXaWR0aCI6ICIxMDAlIn0pOwoKICAgICAgICAKICAgICAgICAgICAgdmFyIGh0bWxfNWYyMTc4MGNmMzA4NDk3MzhkM2E1Y2I3MzVjMzQwMmQgPSAkKGA8ZGl2IGlkPSJodG1sXzVmMjE3ODBjZjMwODQ5NzM4ZDNhNWNiNzM1YzM0MDJkIiBzdHlsZT0id2lkdGg6IDEwMC4wJTsgaGVpZ2h0OiAxMDAuMCU7Ij5OYW1lOiBMT05HTU9OVCBTVVBQTFkgRElUQ0ggUHJlY2lwOiAwLjAwPC9kaXY+YClbMF07CiAgICAgICAgICAgIHBvcHVwX2UwOTdhNmUzMTUwYjRlY2U5N2ZhNjgyYzRmYjBjNGUxLnNldENvbnRlbnQoaHRtbF81ZjIxNzgwY2YzMDg0OTczOGQzYTVjYjczNWMzNDAyZCk7CiAgICAgICAgCgogICAgICAgIG1hcmtlcl8wYWIyYmI1NmQxYzk0YjUzODY3MGMyMDkzY2U3YjVkNS5iaW5kUG9wdXAocG9wdXBfZTA5N2E2ZTMxNTBiNGVjZTk3ZmE2ODJjNGZiMGM0ZTEpCiAgICAgICAgOwoKICAgICAgICAKICAgIAogICAgCiAgICAgICAgICAgIHZhciBtYXJrZXJfMDNlNGEwZjIwZTk3NDE0OWJkZTgyNGM5MWQzMGFiOGQgPSBMLm1hcmtlcigKICAgICAgICAgICAgICAgIFs0MC4xNzI5MjUsIC0xMDUuMTY3NjIyXSwKICAgICAgICAgICAgICAgIHt9CiAgICAgICAgICAgICkuYWRkVG8obWFya2VyX2NsdXN0ZXJfMzEyNzJjMzUzZGQ5NDVlNmE4NTI2ZTI5ODE0ZjU2YjcpOwogICAgICAgIAogICAgCiAgICAgICAgdmFyIHBvcHVwXzI1MWQ1NGM0N2Q4YjQxOWFiMzgxZGZiY2U2MWNiMzg4ID0gTC5wb3B1cCh7Im1heFdpZHRoIjogIjEwMCUifSk7CgogICAgICAgIAogICAgICAgICAgICB2YXIgaHRtbF9kMGE1N2EyNjYzMDg0ZDgwYjU5ZWM4NTM1MmY5NDczZSA9ICQoYDxkaXYgaWQ9Imh0bWxfZDBhNTdhMjY2MzA4NGQ4MGI1OWVjODUzNTJmOTQ3M2UiIHN0eWxlPSJ3aWR0aDogMTAwLjAlOyBoZWlnaHQ6IDEwMC4wJTsiPk5hbWU6IE5PUlRIV0VTVCBNVVRVQUwgRElUQ0ggUHJlY2lwOiAwLjAwPC9kaXY+YClbMF07CiAgICAgICAgICAgIHBvcHVwXzI1MWQ1NGM0N2Q4YjQxOWFiMzgxZGZiY2U2MWNiMzg4LnNldENvbnRlbnQoaHRtbF9kMGE1N2EyNjYzMDg0ZDgwYjU5ZWM4NTM1MmY5NDczZSk7CiAgICAgICAgCgogICAgICAgIG1hcmtlcl8wM2U0YTBmMjBlOTc0MTQ5YmRlODI0YzkxZDMwYWI4ZC5iaW5kUG9wdXAocG9wdXBfMjUxZDU0YzQ3ZDhiNDE5YWIzODFkZmJjZTYxY2IzODgpCiAgICAgICAgOwoKICAgICAgICAKICAgIAogICAgCiAgICAgICAgICAgIHZhciBtYXJrZXJfZjFkYTRkYTIzN2NhNDc2ZTgxYjQ3N2JjNTAyNzE3ZGEgPSBMLm1hcmtlcigKICAgICAgICAgICAgICAgIFs0MC4xMzQyNzgsIC0xMDUuMTMwODE5XSwKICAgICAgICAgICAgICAgIHt9CiAgICAgICAgICAgICkuYWRkVG8obWFya2VyX2NsdXN0ZXJfMzEyNzJjMzUzZGQ5NDVlNmE4NTI2ZTI5ODE0ZjU2YjcpOwogICAgICAgIAogICAgCiAgICAgICAgdmFyIHBvcHVwX2NmN2M1MGU1NDNmNjQxYTNhMzkzYTc2YzUyYmY1OGQ4ID0gTC5wb3B1cCh7Im1heFdpZHRoIjogIjEwMCUifSk7CgogICAgICAgIAogICAgICAgICAgICB2YXIgaHRtbF9jM2U1NjY0M2VjNWE0MjlmYTQzNDI3ZDljYTRmZmE0YiA9ICQoYDxkaXYgaWQ9Imh0bWxfYzNlNTY2NDNlYzVhNDI5ZmE0MzQyN2Q5Y2E0ZmZhNGIiIHN0eWxlPSJ3aWR0aDogMTAwLjAlOyBoZWlnaHQ6IDEwMC4wJTsiPk5hbWU6IExFRlQgSEFORCBDUkVFSyBBVCBIT1ZFUiBST0FEIE5FQVIgTE9OR01PTlQsIENPIFByZWNpcDogMy4zNDwvZGl2PmApWzBdOwogICAgICAgICAgICBwb3B1cF9jZjdjNTBlNTQzZjY0MWEzYTM5M2E3NmM1MmJmNThkOC5zZXRDb250ZW50KGh0bWxfYzNlNTY2NDNlYzVhNDI5ZmE0MzQyN2Q5Y2E0ZmZhNGIpOwogICAgICAgIAoKICAgICAgICBtYXJrZXJfZjFkYTRkYTIzN2NhNDc2ZTgxYjQ3N2JjNTAyNzE3ZGEuYmluZFBvcHVwKHBvcHVwX2NmN2M1MGU1NDNmNjQxYTNhMzkzYTc2YzUyYmY1OGQ4KQogICAgICAgIDsKCiAgICAgICAgCiAgICAKICAgIAogICAgICAgICAgICB2YXIgbWFya2VyXzBmOTQ3OTY5OTBkNDQ3YzI5NGYzZWMyMTk1ZGUyY2MwID0gTC5tYXJrZXIoCiAgICAgICAgICAgICAgICBbMzkuOTg2MTY5LCAtMTA1LjIxODY3N10sCiAgICAgICAgICAgICAgICB7fQogICAgICAgICAgICApLmFkZFRvKG1hcmtlcl9jbHVzdGVyXzMxMjcyYzM1M2RkOTQ1ZTZhODUyNmUyOTgxNGY1NmI3KTsKICAgICAgICAKICAgIAogICAgICAgIHZhciBwb3B1cF8zMjU3YzliOTIxYjY0MWM0YjBiMTVhNjk1YTcwMzEwYyA9IEwucG9wdXAoeyJtYXhXaWR0aCI6ICIxMDAlIn0pOwoKICAgICAgICAKICAgICAgICAgICAgdmFyIGh0bWxfMGYzOGE2YWU3MWZmNDgwZGJmZGI0YjBmY2MxMTQ3NjggPSAkKGA8ZGl2IGlkPSJodG1sXzBmMzhhNmFlNzFmZjQ4MGRiZmRiNGIwZmNjMTE0NzY4IiBzdHlsZT0id2lkdGg6IDEwMC4wJTsgaGVpZ2h0OiAxMDAuMCU7Ij5OYW1lOiBEUlkgQ1JFRUsgQ0FSUklFUiBQcmVjaXA6IDAuMDA8L2Rpdj5gKVswXTsKICAgICAgICAgICAgcG9wdXBfMzI1N2M5YjkyMWI2NDFjNGIwYjE1YTY5NWE3MDMxMGMuc2V0Q29udGVudChodG1sXzBmMzhhNmFlNzFmZjQ4MGRiZmRiNGIwZmNjMTE0NzY4KTsKICAgICAgICAKCiAgICAgICAgbWFya2VyXzBmOTQ3OTY5OTBkNDQ3YzI5NGYzZWMyMTk1ZGUyY2MwLmJpbmRQb3B1cChwb3B1cF8zMjU3YzliOTIxYjY0MWM0YjBiMTVhNjk1YTcwMzEwYykKICAgICAgICA7CgogICAgICAgIAogICAgCiAgICAKICAgICAgICAgICAgdmFyIG1hcmtlcl9mMDJkMWQyODAxN2E0ZDk3ODk0OTM2NWIzZTE4MWNhYiA9IEwubWFya2VyKAogICAgICAgICAgICAgICAgWzQwLjE2MDcwNSwgLTEwNS4xNjg0NzFdLAogICAgICAgICAgICAgICAge30KICAgICAgICAgICAgKS5hZGRUbyhtYXJrZXJfY2x1c3Rlcl8zMTI3MmMzNTNkZDk0NWU2YTg1MjZlMjk4MTRmNTZiNyk7CiAgICAgICAgCiAgICAKICAgICAgICB2YXIgcG9wdXBfNzk0N2UzMTFkYzg3NGEwZmIwMWRmMGE3OWZmZGVkNzQgPSBMLnBvcHVwKHsibWF4V2lkdGgiOiAiMTAwJSJ9KTsKCiAgICAgICAgCiAgICAgICAgICAgIHZhciBodG1sXzQ0YzY4YTE2NDQ5ZDQyZDk5YTllYzhiNDNiNDRkZGYwID0gJChgPGRpdiBpZD0iaHRtbF80NGM2OGExNjQ0OWQ0MmQ5OWE5ZWM4YjQzYjQ0ZGRmMCIgc3R5bGU9IndpZHRoOiAxMDAuMCU7IGhlaWdodDogMTAwLjAlOyI+TmFtZTogUEVDSy1QRUxMQSBBVUdNRU5UQVRJT04gUkVUVVJOIFByZWNpcDogMC4wMDwvZGl2PmApWzBdOwogICAgICAgICAgICBwb3B1cF83OTQ3ZTMxMWRjODc0YTBmYjAxZGYwYTc5ZmZkZWQ3NC5zZXRDb250ZW50KGh0bWxfNDRjNjhhMTY0NDlkNDJkOTlhOWVjOGI0M2I0NGRkZjApOwogICAgICAgIAoKICAgICAgICBtYXJrZXJfZjAyZDFkMjgwMTdhNGQ5Nzg5NDkzNjViM2UxODFjYWIuYmluZFBvcHVwKHBvcHVwXzc5NDdlMzExZGM4NzRhMGZiMDFkZjBhNzlmZmRlZDc0KQogICAgICAgIDsKCiAgICAgICAgCiAgICAKICAgIAogICAgICAgICAgICB2YXIgbWFya2VyX2VlNmNhY2FmMDBjYzQ0OGRhYWY1NjJlMzNhMzYxMmM5ID0gTC5tYXJrZXIoCiAgICAgICAgICAgICAgICBbNDAuMTk5MzIxLCAtMTA1LjIyMjYzOV0sCiAgICAgICAgICAgICAgICB7fQogICAgICAgICAgICApLmFkZFRvKG1hcmtlcl9jbHVzdGVyXzMxMjcyYzM1M2RkOTQ1ZTZhODUyNmUyOTgxNGY1NmI3KTsKICAgICAgICAKICAgIAogICAgICAgIHZhciBwb3B1cF9jOTM5NTQwZTY2Yjc0YTYyOWI0ZDU1OGU3ZjI4OWM5YyA9IEwucG9wdXAoeyJtYXhXaWR0aCI6ICIxMDAlIn0pOwoKICAgICAgICAKICAgICAgICAgICAgdmFyIGh0bWxfNzUxMzBkNjgxOTFkNGZlY2E2N2I5MTVkYTgyMTZkMjAgPSAkKGA8ZGl2IGlkPSJodG1sXzc1MTMwZDY4MTkxZDRmZWNhNjdiOTE1ZGE4MjE2ZDIwIiBzdHlsZT0id2lkdGg6IDEwMC4wJTsgaGVpZ2h0OiAxMDAuMCU7Ij5OYW1lOiBHT1NTIERJVENIIDEgUHJlY2lwOiAwLjAwPC9kaXY+YClbMF07CiAgICAgICAgICAgIHBvcHVwX2M5Mzk1NDBlNjZiNzRhNjI5YjRkNTU4ZTdmMjg5YzljLnNldENvbnRlbnQoaHRtbF83NTEzMGQ2ODE5MWQ0ZmVjYTY3YjkxNWRhODIxNmQyMCk7CiAgICAgICAgCgogICAgICAgIG1hcmtlcl9lZTZjYWNhZjAwY2M0NDhkYWFmNTYyZTMzYTM2MTJjOS5iaW5kUG9wdXAocG9wdXBfYzkzOTU0MGU2NmI3NGE2MjliNGQ1NThlN2YyODljOWMpCiAgICAgICAgOwoKICAgICAgICAKICAgIAogICAgCiAgICAgICAgICAgIHZhciBtYXJrZXJfNDc5NmY2MGZiMDI0NDZjZGFmODQ0ODA2ZDljOWI0NjggPSBMLm1hcmtlcigKICAgICAgICAgICAgICAgIFs0MC4xOTMyOCwgLTEwNS4yMTA0MjRdLAogICAgICAgICAgICAgICAge30KICAgICAgICAgICAgKS5hZGRUbyhtYXJrZXJfY2x1c3Rlcl8zMTI3MmMzNTNkZDk0NWU2YTg1MjZlMjk4MTRmNTZiNyk7CiAgICAgICAgCiAgICAKICAgICAgICB2YXIgcG9wdXBfNDkyMzJmNmU2YjY4NGI1N2FlNGYyNTY3ZGQ3NTgwZjMgPSBMLnBvcHVwKHsibWF4V2lkdGgiOiAiMTAwJSJ9KTsKCiAgICAgICAgCiAgICAgICAgICAgIHZhciBodG1sXzlkNzkyZDA5YTY2YTQyNjRhOWMxNGMzNjc5OWM0YzBmID0gJChgPGRpdiBpZD0iaHRtbF85ZDc5MmQwOWE2NmE0MjY0YTljMTRjMzY3OTljNGMwZiIgc3R5bGU9IndpZHRoOiAxMDAuMCU7IGhlaWdodDogMTAwLjAlOyI+TmFtZTogV0VCU1RFUiBNQ0NBU0xJTiBESVRDSCBQcmVjaXA6IDAuMDA8L2Rpdj5gKVswXTsKICAgICAgICAgICAgcG9wdXBfNDkyMzJmNmU2YjY4NGI1N2FlNGYyNTY3ZGQ3NTgwZjMuc2V0Q29udGVudChodG1sXzlkNzkyZDA5YTY2YTQyNjRhOWMxNGMzNjc5OWM0YzBmKTsKICAgICAgICAKCiAgICAgICAgbWFya2VyXzQ3OTZmNjBmYjAyNDQ2Y2RhZjg0NDgwNmQ5YzliNDY4LmJpbmRQb3B1cChwb3B1cF80OTIzMmY2ZTZiNjg0YjU3YWU0ZjI1NjdkZDc1ODBmMykKICAgICAgICA7CgogICAgICAgIAogICAgCiAgICAKICAgICAgICAgICAgdmFyIG1hcmtlcl8wNDc1ZDBkZmNjN2I0ZTg2YjQyNGU0M2VlOGNkNWMyNSA9IEwubWFya2VyKAogICAgICAgICAgICAgICAgWzQwLjA1MzY2MSwgLTEwNS4xNTExNDNdLAogICAgICAgICAgICAgICAge30KICAgICAgICAgICAgKS5hZGRUbyhtYXJrZXJfY2x1c3Rlcl8zMTI3MmMzNTNkZDk0NWU2YTg1MjZlMjk4MTRmNTZiNyk7CiAgICAgICAgCiAgICAKICAgICAgICB2YXIgcG9wdXBfY2ZlNGY3MWQ5YTFiNDkyNWEzODRhMDczMTljNDAxMDMgPSBMLnBvcHVwKHsibWF4V2lkdGgiOiAiMTAwJSJ9KTsKCiAgICAgICAgCiAgICAgICAgICAgIHZhciBodG1sXzY0OTg4YjA0MDliNzQyMzM4NDZkY2IxZjNkNWI2N2FmID0gJChgPGRpdiBpZD0iaHRtbF82NDk4OGIwNDA5Yjc0MjMzODQ2ZGNiMWYzZDViNjdhZiIgc3R5bGU9IndpZHRoOiAxMDAuMCU7IGhlaWdodDogMTAwLjAlOyI+TmFtZTogTEVHR0VUVCBESVRDSCBQcmVjaXA6IDIuNjM8L2Rpdj5gKVswXTsKICAgICAgICAgICAgcG9wdXBfY2ZlNGY3MWQ5YTFiNDkyNWEzODRhMDczMTljNDAxMDMuc2V0Q29udGVudChodG1sXzY0OTg4YjA0MDliNzQyMzM4NDZkY2IxZjNkNWI2N2FmKTsKICAgICAgICAKCiAgICAgICAgbWFya2VyXzA0NzVkMGRmY2M3YjRlODZiNDI0ZTQzZWU4Y2Q1YzI1LmJpbmRQb3B1cChwb3B1cF9jZmU0ZjcxZDlhMWI0OTI1YTM4NGEwNzMxOWM0MDEwMykKICAgICAgICA7CgogICAgICAgIAogICAgCiAgICAKICAgICAgICAgICAgdmFyIG1hcmtlcl82NDE4OGUxOTYwNTg0YmJkYTFiNWI0YzYyNWVmNjZiYiA9IEwubWFya2VyKAogICAgICAgICAgICAgICAgWzQwLjIxNjI2MywgLTEwNS4zNjUzNjVdLAogICAgICAgICAgICAgICAge30KICAgICAgICAgICAgKS5hZGRUbyhtYXJrZXJfY2x1c3Rlcl8zMTI3MmMzNTNkZDk0NWU2YTg1MjZlMjk4MTRmNTZiNyk7CiAgICAgICAgCiAgICAKICAgICAgICB2YXIgcG9wdXBfZmJhMzRmMDhiMzYzNGM4ZmFlYzQzZDMyYTgyYTE1MTUgPSBMLnBvcHVwKHsibWF4V2lkdGgiOiAiMTAwJSJ9KTsKCiAgICAgICAgCiAgICAgICAgICAgIHZhciBodG1sX2ViNTEyNjkxMGZmYzRlZTE5ZWVmZTc4YzhjM2QwZDZmID0gJChgPGRpdiBpZD0iaHRtbF9lYjUxMjY5MTBmZmM0ZWUxOWVlZmU3OGM4YzNkMGQ2ZiIgc3R5bGU9IndpZHRoOiAxMDAuMCU7IGhlaWdodDogMTAwLjAlOyI+TmFtZTogQlVUVE9OUk9DSyAoUkFMUEggUFJJQ0UpIFJFU0VSVk9JUiBQcmVjaXA6IDEyOTExLjAwPC9kaXY+YClbMF07CiAgICAgICAgICAgIHBvcHVwX2ZiYTM0ZjA4YjM2MzRjOGZhZWM0M2QzMmE4MmExNTE1LnNldENvbnRlbnQoaHRtbF9lYjUxMjY5MTBmZmM0ZWUxOWVlZmU3OGM4YzNkMGQ2Zik7CiAgICAgICAgCgogICAgICAgIG1hcmtlcl82NDE4OGUxOTYwNTg0YmJkYTFiNWI0YzYyNWVmNjZiYi5iaW5kUG9wdXAocG9wdXBfZmJhMzRmMDhiMzYzNGM4ZmFlYzQzZDMyYTgyYTE1MTUpCiAgICAgICAgOwoKICAgICAgICAKICAgIAogICAgCiAgICAgICAgICAgIHZhciBtYXJrZXJfNzE0NTQxYjYzNGM3NGUzNzhlYTFmNGEwYWZkOTNjZDMgPSBMLm1hcmtlcigKICAgICAgICAgICAgICAgIFs0MC4yNTU3NzYsIC0xMDUuMjA5NV0sCiAgICAgICAgICAgICAgICB7fQogICAgICAgICAgICApLmFkZFRvKG1hcmtlcl9jbHVzdGVyXzMxMjcyYzM1M2RkOTQ1ZTZhODUyNmUyOTgxNGY1NmI3KTsKICAgICAgICAKICAgIAogICAgICAgIHZhciBwb3B1cF8xMGUxMmUxMmEzZjY0YjAwODZkYjJkZjYxNjA5ZWY1ZiA9IEwucG9wdXAoeyJtYXhXaWR0aCI6ICIxMDAlIn0pOwoKICAgICAgICAKICAgICAgICAgICAgdmFyIGh0bWxfNmJlN2JhMzNiNDI5NGFiODkxYzY4Njk4YzkyYWY5MDMgPSAkKGA8ZGl2IGlkPSJodG1sXzZiZTdiYTMzYjQyOTRhYjg5MWM2ODY5OGM5MmFmOTAzIiBzdHlsZT0id2lkdGg6IDEwMC4wJTsgaGVpZ2h0OiAxMDAuMCU7Ij5OYW1lOiBMSVRUTEUgVEhPTVBTT04gIzIgRElUQ0ggUHJlY2lwOiAwLjEwPC9kaXY+YClbMF07CiAgICAgICAgICAgIHBvcHVwXzEwZTEyZTEyYTNmNjRiMDA4NmRiMmRmNjE2MDllZjVmLnNldENvbnRlbnQoaHRtbF82YmU3YmEzM2I0Mjk0YWI4OTFjNjg2OThjOTJhZjkwMyk7CiAgICAgICAgCgogICAgICAgIG1hcmtlcl83MTQ1NDFiNjM0Yzc0ZTM3OGVhMWY0YTBhZmQ5M2NkMy5iaW5kUG9wdXAocG9wdXBfMTBlMTJlMTJhM2Y2NGIwMDg2ZGIyZGY2MTYwOWVmNWYpCiAgICAgICAgOwoKICAgICAgICAKICAgIAogICAgCiAgICAgICAgICAgIHZhciBtYXJrZXJfMmRjOTZhZTYwNjY5NGZmNzkwYzNkOTQ2MzBmZmYxMjAgPSBMLm1hcmtlcigKICAgICAgICAgICAgICAgIFs0MC4yNTc4NDQsIC0xMDUuMTY0Mzk3XSwKICAgICAgICAgICAgICAgIHt9CiAgICAgICAgICAgICkuYWRkVG8obWFya2VyX2NsdXN0ZXJfMzEyNzJjMzUzZGQ5NDVlNmE4NTI2ZTI5ODE0ZjU2YjcpOwogICAgICAgIAogICAgCiAgICAgICAgdmFyIHBvcHVwXzQxMTY4OTY3NTJmMTRiNTk5MTE4OTUwN2YzZjgxNDJiID0gTC5wb3B1cCh7Im1heFdpZHRoIjogIjEwMCUifSk7CgogICAgICAgIAogICAgICAgICAgICB2YXIgaHRtbF9jNGFjNThmMjYxNjI0ZGU4YTVjODk1ZDU5ZGNiNjA0YiA9ICQoYDxkaXYgaWQ9Imh0bWxfYzRhYzU4ZjI2MTYyNGRlOGE1Yzg5NWQ1OWRjYjYwNGIiIHN0eWxlPSJ3aWR0aDogMTAwLjAlOyBoZWlnaHQ6IDEwMC4wJTsiPk5hbWU6IEJMT1dFUiBESVRDSCBQcmVjaXA6IDAuMDE8L2Rpdj5gKVswXTsKICAgICAgICAgICAgcG9wdXBfNDExNjg5Njc1MmYxNGI1OTkxMTg5NTA3ZjNmODE0MmIuc2V0Q29udGVudChodG1sX2M0YWM1OGYyNjE2MjRkZThhNWM4OTVkNTlkY2I2MDRiKTsKICAgICAgICAKCiAgICAgICAgbWFya2VyXzJkYzk2YWU2MDY2OTRmZjc5MGMzZDk0NjMwZmZmMTIwLmJpbmRQb3B1cChwb3B1cF80MTE2ODk2NzUyZjE0YjU5OTExODk1MDdmM2Y4MTQyYikKICAgICAgICA7CgogICAgICAgIAogICAgCiAgICAKICAgICAgICAgICAgdmFyIG1hcmtlcl82YjFmOTI1YzQ1N2Y0NjQ0OGJkZTJiMWU1NTc4ZGI5MyA9IEwubWFya2VyKAogICAgICAgICAgICAgICAgWzM5LjkzMTU5NywgLTEwNS4zMDQ5OV0sCiAgICAgICAgICAgICAgICB7fQogICAgICAgICAgICApLmFkZFRvKG1hcmtlcl9jbHVzdGVyXzMxMjcyYzM1M2RkOTQ1ZTZhODUyNmUyOTgxNGY1NmI3KTsKICAgICAgICAKICAgIAogICAgICAgIHZhciBwb3B1cF80NmRhNDcxMzM1ODE0ZGZhOWQwYjczMTE1ZjdlNjdjMCA9IEwucG9wdXAoeyJtYXhXaWR0aCI6ICIxMDAlIn0pOwoKICAgICAgICAKICAgICAgICAgICAgdmFyIGh0bWxfYmNhMGUzNmI0YTg3NDA3YjhiNTgyYjQ3ODRkZThmNDggPSAkKGA8ZGl2IGlkPSJodG1sX2JjYTBlMzZiNGE4NzQwN2I4YjU4MmI0Nzg0ZGU4ZjQ4IiBzdHlsZT0id2lkdGg6IDEwMC4wJTsgaGVpZ2h0OiAxMDAuMCU7Ij5OYW1lOiBTT1VUSCBCT1VMREVSIENSRUVLIE5FQVIgRUxET1JBRE8gU1BSSU5HUywgQ08uIFByZWNpcDogMTcuMjA8L2Rpdj5gKVswXTsKICAgICAgICAgICAgcG9wdXBfNDZkYTQ3MTMzNTgxNGRmYTlkMGI3MzExNWY3ZTY3YzAuc2V0Q29udGVudChodG1sX2JjYTBlMzZiNGE4NzQwN2I4YjU4MmI0Nzg0ZGU4ZjQ4KTsKICAgICAgICAKCiAgICAgICAgbWFya2VyXzZiMWY5MjVjNDU3ZjQ2NDQ4YmRlMmIxZTU1NzhkYjkzLmJpbmRQb3B1cChwb3B1cF80NmRhNDcxMzM1ODE0ZGZhOWQwYjczMTE1ZjdlNjdjMCkKICAgICAgICA7CgogICAgICAgIAogICAgCiAgICAKICAgICAgICAgICAgdmFyIG1hcmtlcl8yYmZmYzgwYjBiNjg0MjY3YjE5MDRhN2E3NGQ0MGExNSA9IEwubWFya2VyKAogICAgICAgICAgICAgICAgWzQwLjA1MTY1MiwgLTEwNS4xNzg4NzVdLAogICAgICAgICAgICAgICAge30KICAgICAgICAgICAgKS5hZGRUbyhtYXJrZXJfY2x1c3Rlcl8zMTI3MmMzNTNkZDk0NWU2YTg1MjZlMjk4MTRmNTZiNyk7CiAgICAgICAgCiAgICAKICAgICAgICB2YXIgcG9wdXBfYjM3ZjE2YmI5NWQyNDEzY2IzOTA5MDk0YjQ5NTgyNjUgPSBMLnBvcHVwKHsibWF4V2lkdGgiOiAiMTAwJSJ9KTsKCiAgICAgICAgCiAgICAgICAgICAgIHZhciBodG1sXzJhN2VkOTUyY2M0YTRmZGZhYmE5YTFkYzU1ZWJjOWY3ID0gJChgPGRpdiBpZD0iaHRtbF8yYTdlZDk1MmNjNGE0ZmRmYWJhOWExZGM1NWViYzlmNyIgc3R5bGU9IndpZHRoOiAxMDAuMCU7IGhlaWdodDogMTAwLjAlOyI+TmFtZTogQk9VTERFUiBDUkVFSyBBVCBOT1JUSCA3NVRIIFNULiBORUFSIEJPVUxERVIsIENPIFByZWNpcDogMzAuMjA8L2Rpdj5gKVswXTsKICAgICAgICAgICAgcG9wdXBfYjM3ZjE2YmI5NWQyNDEzY2IzOTA5MDk0YjQ5NTgyNjUuc2V0Q29udGVudChodG1sXzJhN2VkOTUyY2M0YTRmZGZhYmE5YTFkYzU1ZWJjOWY3KTsKICAgICAgICAKCiAgICAgICAgbWFya2VyXzJiZmZjODBiMGI2ODQyNjdiMTkwNGE3YTc0ZDQwYTE1LmJpbmRQb3B1cChwb3B1cF9iMzdmMTZiYjk1ZDI0MTNjYjM5MDkwOTRiNDk1ODI2NSkKICAgICAgICA7CgogICAgICAgIAogICAgCiAgICAKICAgICAgICAgICAgdmFyIG1hcmtlcl9lMzkzYjI0N2MxNTk0YTJjODUzMGMxYzQ1NTQyNmEzYyA9IEwubWFya2VyKAogICAgICAgICAgICAgICAgWzQwLjE3MDk5OCwgLTEwNS4xNjA4NzZdLAogICAgICAgICAgICAgICAge30KICAgICAgICAgICAgKS5hZGRUbyhtYXJrZXJfY2x1c3Rlcl8zMTI3MmMzNTNkZDk0NWU2YTg1MjZlMjk4MTRmNTZiNyk7CiAgICAgICAgCiAgICAKICAgICAgICB2YXIgcG9wdXBfNDI4ZGZkZTBkMjJlNDc2MGI3ZjEwZGJkOGM2ODFmNDUgPSBMLnBvcHVwKHsibWF4V2lkdGgiOiAiMTAwJSJ9KTsKCiAgICAgICAgCiAgICAgICAgICAgIHZhciBodG1sX2RlNGVjNmJmMWZmNTRlOGY4ZjgyZjQ3MTEwNjdlOGViID0gJChgPGRpdiBpZD0iaHRtbF9kZTRlYzZiZjFmZjU0ZThmOGY4MmY0NzExMDY3ZThlYiIgc3R5bGU9IndpZHRoOiAxMDAuMCU7IGhlaWdodDogMTAwLjAlOyI+TmFtZTogU09VVEggRkxBVCBESVRDSCBQcmVjaXA6IDAuMzg8L2Rpdj5gKVswXTsKICAgICAgICAgICAgcG9wdXBfNDI4ZGZkZTBkMjJlNDc2MGI3ZjEwZGJkOGM2ODFmNDUuc2V0Q29udGVudChodG1sX2RlNGVjNmJmMWZmNTRlOGY4ZjgyZjQ3MTEwNjdlOGViKTsKICAgICAgICAKCiAgICAgICAgbWFya2VyX2UzOTNiMjQ3YzE1OTRhMmM4NTMwYzFjNDU1NDI2YTNjLmJpbmRQb3B1cChwb3B1cF80MjhkZmRlMGQyMmU0NzYwYjdmMTBkYmQ4YzY4MWY0NSkKICAgICAgICA7CgogICAgICAgIAogICAgCiAgICAKICAgICAgICAgICAgdmFyIG1hcmtlcl8yZjY4NDlhNDI3NjM0ODU5ODhiYzYwMjNkZGQwNzM3NCA9IEwubWFya2VyKAogICAgICAgICAgICAgICAgWzQwLjE1MzM0MSwgLTEwNS4wNzU2OTVdLAogICAgICAgICAgICAgICAge30KICAgICAgICAgICAgKS5hZGRUbyhtYXJrZXJfY2x1c3Rlcl8zMTI3MmMzNTNkZDk0NWU2YTg1MjZlMjk4MTRmNTZiNyk7CiAgICAgICAgCiAgICAKICAgICAgICB2YXIgcG9wdXBfODY1OTNhMGRkMzA4NDM2ZGJmNmI5MjVmMGQzNmEzNTEgPSBMLnBvcHVwKHsibWF4V2lkdGgiOiAiMTAwJSJ9KTsKCiAgICAgICAgCiAgICAgICAgICAgIHZhciBodG1sX2ZjMTZkODUyYjFkYjQ2YmViZjgwZGNmNDRmYzViYTNlID0gJChgPGRpdiBpZD0iaHRtbF9mYzE2ZDg1MmIxZGI0NmJlYmY4MGRjZjQ0ZmM1YmEzZSIgc3R5bGU9IndpZHRoOiAxMDAuMCU7IGhlaWdodDogMTAwLjAlOyI+TmFtZTogU0FJTlQgVlJBSU4gQ1JFRUsgQkVMT1cgS0VOIFBSQVRUIEJMVkQgQVQgTE9OR01PTlQsIENPIFByZWNpcDogMzQuNDA8L2Rpdj5gKVswXTsKICAgICAgICAgICAgcG9wdXBfODY1OTNhMGRkMzA4NDM2ZGJmNmI5MjVmMGQzNmEzNTEuc2V0Q29udGVudChodG1sX2ZjMTZkODUyYjFkYjQ2YmViZjgwZGNmNDRmYzViYTNlKTsKICAgICAgICAKCiAgICAgICAgbWFya2VyXzJmNjg0OWE0Mjc2MzQ4NTk4OGJjNjAyM2RkZDA3Mzc0LmJpbmRQb3B1cChwb3B1cF84NjU5M2EwZGQzMDg0MzZkYmY2YjkyNWYwZDM2YTM1MSkKICAgICAgICA7CgogICAgICAgIAogICAgCiAgICAKICAgICAgICAgICAgdmFyIG1hcmtlcl8yMGExMTczMDA3YTI0ZjgyYWU1MDNjMzI3YzI4NDZlMyA9IEwubWFya2VyKAogICAgICAgICAgICAgICAgWzM5Ljk2MTY1NSwgLTEwNS41MDQ0NF0sCiAgICAgICAgICAgICAgICB7fQogICAgICAgICAgICApLmFkZFRvKG1hcmtlcl9jbHVzdGVyXzMxMjcyYzM1M2RkOTQ1ZTZhODUyNmUyOTgxNGY1NmI3KTsKICAgICAgICAKICAgIAogICAgICAgIHZhciBwb3B1cF9jMGM0NDQ3NDFhNDY0YzY2YWQ0YTk4ZGM2MDBhYWMzOSA9IEwucG9wdXAoeyJtYXhXaWR0aCI6ICIxMDAlIn0pOwoKICAgICAgICAKICAgICAgICAgICAgdmFyIGh0bWxfYzkwYTRhMzU1NGZkNGRlMWI3OWY0ZmMxMWM5ZmM3NTIgPSAkKGA8ZGl2IGlkPSJodG1sX2M5MGE0YTM1NTRmZDRkZTFiNzlmNGZjMTFjOWZjNzUyIiBzdHlsZT0id2lkdGg6IDEwMC4wJTsgaGVpZ2h0OiAxMDAuMCU7Ij5OYW1lOiBNSURETEUgQk9VTERFUiBDUkVFSyBBVCBORURFUkxBTkQsIENPLiBQcmVjaXA6IDI0LjYwPC9kaXY+YClbMF07CiAgICAgICAgICAgIHBvcHVwX2MwYzQ0NDc0MWE0NjRjNjZhZDRhOThkYzYwMGFhYzM5LnNldENvbnRlbnQoaHRtbF9jOTBhNGEzNTU0ZmQ0ZGUxYjc5ZjRmYzExYzlmYzc1Mik7CiAgICAgICAgCgogICAgICAgIG1hcmtlcl8yMGExMTczMDA3YTI0ZjgyYWU1MDNjMzI3YzI4NDZlMy5iaW5kUG9wdXAocG9wdXBfYzBjNDQ0NzQxYTQ2NGM2NmFkNGE5OGRjNjAwYWFjMzkpCiAgICAgICAgOwoKICAgICAgICAKICAgIAogICAgCiAgICAgICAgICAgIHZhciBtYXJrZXJfNDY4ZTFjYWQ1MDY4NDg1MTlhYzhkMGUxMWY2MjJjNWYgPSBMLm1hcmtlcigKICAgICAgICAgICAgICAgIFs0MC4wNTk4MDksIC0xMDUuMDk3ODcyXSwKICAgICAgICAgICAgICAgIHt9CiAgICAgICAgICAgICkuYWRkVG8obWFya2VyX2NsdXN0ZXJfMzEyNzJjMzUzZGQ5NDVlNmE4NTI2ZTI5ODE0ZjU2YjcpOwogICAgICAgIAogICAgCiAgICAgICAgdmFyIHBvcHVwX2UwYTg0N2UwMGFlYzQ3Mzg5ZTQ5NjgwM2IxOWVhMzE4ID0gTC5wb3B1cCh7Im1heFdpZHRoIjogIjEwMCUifSk7CgogICAgICAgIAogICAgICAgICAgICB2YXIgaHRtbF9kY2JjOWZiN2I4ZDI0MzE4YjcwMjM4NGJhMjQwOWQ2NiA9ICQoYDxkaXYgaWQ9Imh0bWxfZGNiYzlmYjdiOGQyNDMxOGI3MDIzODRiYTI0MDlkNjYiIHN0eWxlPSJ3aWR0aDogMTAwLjAlOyBoZWlnaHQ6IDEwMC4wJTsiPk5hbWU6IEJPVUxERVIgQ1JFRUsgQVQgMTA5IFNUIE5FQVIgRVJJRSwgQ08gUHJlY2lwOiA1MC4yMDwvZGl2PmApWzBdOwogICAgICAgICAgICBwb3B1cF9lMGE4NDdlMDBhZWM0NzM4OWU0OTY4MDNiMTllYTMxOC5zZXRDb250ZW50KGh0bWxfZGNiYzlmYjdiOGQyNDMxOGI3MDIzODRiYTI0MDlkNjYpOwogICAgICAgIAoKICAgICAgICBtYXJrZXJfNDY4ZTFjYWQ1MDY4NDg1MTlhYzhkMGUxMWY2MjJjNWYuYmluZFBvcHVwKHBvcHVwX2UwYTg0N2UwMGFlYzQ3Mzg5ZTQ5NjgwM2IxOWVhMzE4KQogICAgICAgIDsKCiAgICAgICAgCiAgICAKICAgIAogICAgICAgICAgICB2YXIgbWFya2VyX2FjODFlNTU2M2FmMDQzMmNhZjdlNjc2NjVjYTAzOTUyID0gTC5tYXJrZXIoCiAgICAgICAgICAgICAgICBbNDAuMjE1NjU4LCAtMTA1LjM2MzQyMl0sCiAgICAgICAgICAgICAgICB7fQogICAgICAgICAgICApLmFkZFRvKG1hcmtlcl9jbHVzdGVyXzMxMjcyYzM1M2RkOTQ1ZTZhODUyNmUyOTgxNGY1NmI3KTsKICAgICAgICAKICAgIAogICAgICAgIHZhciBwb3B1cF85ZWIyOGU3M2VjNTM0MzkxODMwNDc1OGI2MzFkMDc0NCA9IEwucG9wdXAoeyJtYXhXaWR0aCI6ICIxMDAlIn0pOwoKICAgICAgICAKICAgICAgICAgICAgdmFyIGh0bWxfYTVkMjU4MGZmYjE3NDcwN2IzZTFhNjI4MGE5NjAxZDAgPSAkKGA8ZGl2IGlkPSJodG1sX2E1ZDI1ODBmZmIxNzQ3MDdiM2UxYTYyODBhOTYwMWQwIiBzdHlsZT0id2lkdGg6IDEwMC4wJTsgaGVpZ2h0OiAxMDAuMCU7Ij5OYW1lOiBOT1JUSCBTQUlOVCBWUkFJTiBDUkVFSyBCRUxPVyBCVVRUT05ST0NLICAoUkFMUEggUFJJQ0UpIFJFU0VSVk9JUiBQcmVjaXA6IDE5LjMwPC9kaXY+YClbMF07CiAgICAgICAgICAgIHBvcHVwXzllYjI4ZTczZWM1MzQzOTE4MzA0NzU4YjYzMWQwNzQ0LnNldENvbnRlbnQoaHRtbF9hNWQyNTgwZmZiMTc0NzA3YjNlMWE2MjgwYTk2MDFkMCk7CiAgICAgICAgCgogICAgICAgIG1hcmtlcl9hYzgxZTU1NjNhZjA0MzJjYWY3ZTY3NjY1Y2EwMzk1Mi5iaW5kUG9wdXAocG9wdXBfOWViMjhlNzNlYzUzNDM5MTgzMDQ3NThiNjMxZDA3NDQpCiAgICAgICAgOwoKICAgICAgICAKICAgIAogICAgCiAgICAgICAgICAgIHZhciBtYXJrZXJfYWE2ODE4NmU4MTQ5NGJmMjkyY2ZlN2MwMmI4ZWRkZmUgPSBMLm1hcmtlcigKICAgICAgICAgICAgICAgIFs0MC4xMjYzODksIC0xMDUuMzA0NDA0XSwKICAgICAgICAgICAgICAgIHt9CiAgICAgICAgICAgICkuYWRkVG8obWFya2VyX2NsdXN0ZXJfMzEyNzJjMzUzZGQ5NDVlNmE4NTI2ZTI5ODE0ZjU2YjcpOwogICAgICAgIAogICAgCiAgICAgICAgdmFyIHBvcHVwXzM1Mjk5YmNhNzZjMjRmODdhNGNlODAwNjJjMzU0ZTRjID0gTC5wb3B1cCh7Im1heFdpZHRoIjogIjEwMCUifSk7CgogICAgICAgIAogICAgICAgICAgICB2YXIgaHRtbF81MjcxNDUwN2Q1MmM0ZTkyYjcxN2QzYmQwMGU1YWViZiA9ICQoYDxkaXYgaWQ9Imh0bWxfNTI3MTQ1MDdkNTJjNGU5MmI3MTdkM2JkMDBlNWFlYmYiIHN0eWxlPSJ3aWR0aDogMTAwLjAlOyBoZWlnaHQ6IDEwMC4wJTsiPk5hbWU6IExFRlQgSEFORCBDUkVFSyBORUFSIEJPVUxERVIsIENPLiBQcmVjaXA6IDEyLjYwPC9kaXY+YClbMF07CiAgICAgICAgICAgIHBvcHVwXzM1Mjk5YmNhNzZjMjRmODdhNGNlODAwNjJjMzU0ZTRjLnNldENvbnRlbnQoaHRtbF81MjcxNDUwN2Q1MmM0ZTkyYjcxN2QzYmQwMGU1YWViZik7CiAgICAgICAgCgogICAgICAgIG1hcmtlcl9hYTY4MTg2ZTgxNDk0YmYyOTJjZmU3YzAyYjhlZGRmZS5iaW5kUG9wdXAocG9wdXBfMzUyOTliY2E3NmMyNGY4N2E0Y2U4MDA2MmMzNTRlNGMpCiAgICAgICAgOwoKICAgICAgICAKICAgIAogICAgCiAgICAgICAgICAgIHZhciBtYXJrZXJfNzlkYzM3NGQyZjliNGFkMjliYjg4M2ViNjJlYzJhODYgPSBMLm1hcmtlcigKICAgICAgICAgICAgICAgIFs0MC4wODYyNzgsIC0xMDUuMjE3NTE5XSwKICAgICAgICAgICAgICAgIHt9CiAgICAgICAgICAgICkuYWRkVG8obWFya2VyX2NsdXN0ZXJfMzEyNzJjMzUzZGQ5NDVlNmE4NTI2ZTI5ODE0ZjU2YjcpOwogICAgICAgIAogICAgCiAgICAgICAgdmFyIHBvcHVwXzVjN2NkZDU1MTBiMDQ2ZGE5MjJmNmQzNDkzNTIzZWQ1ID0gTC5wb3B1cCh7Im1heFdpZHRoIjogIjEwMCUifSk7CgogICAgICAgIAogICAgICAgICAgICB2YXIgaHRtbF9kYWZiMzUxZjFkNTY0Y2VlOTFhYjg5MmQ5ZWNmNzY0MCA9ICQoYDxkaXYgaWQ9Imh0bWxfZGFmYjM1MWYxZDU2NGNlZTkxYWI4OTJkOWVjZjc2NDAiIHN0eWxlPSJ3aWR0aDogMTAwLjAlOyBoZWlnaHQ6IDEwMC4wJTsiPk5hbWU6IEJPVUxERVIgUkVTRVJWT0lSIElOTEVUIFByZWNpcDogMC4wMDwvZGl2PmApWzBdOwogICAgICAgICAgICBwb3B1cF81YzdjZGQ1NTEwYjA0NmRhOTIyZjZkMzQ5MzUyM2VkNS5zZXRDb250ZW50KGh0bWxfZGFmYjM1MWYxZDU2NGNlZTkxYWI4OTJkOWVjZjc2NDApOwogICAgICAgIAoKICAgICAgICBtYXJrZXJfNzlkYzM3NGQyZjliNGFkMjliYjg4M2ViNjJlYzJhODYuYmluZFBvcHVwKHBvcHVwXzVjN2NkZDU1MTBiMDQ2ZGE5MjJmNmQzNDkzNTIzZWQ1KQogICAgICAgIDsKCiAgICAgICAgCiAgICAKICAgIAogICAgICAgICAgICB2YXIgbWFya2VyXzE2ZDVjZmQxODVlZjQyY2ZiNmNmNjU0NWU2NmI4ODFhID0gTC5tYXJrZXIoCiAgICAgICAgICAgICAgICBbNDAuMTkzMDE5LCAtMTA1LjIxMDM4OF0sCiAgICAgICAgICAgICAgICB7fQogICAgICAgICAgICApLmFkZFRvKG1hcmtlcl9jbHVzdGVyXzMxMjcyYzM1M2RkOTQ1ZTZhODUyNmUyOTgxNGY1NmI3KTsKICAgICAgICAKICAgIAogICAgICAgIHZhciBwb3B1cF9jYmFhZjlhNjYzOGI0YmVhOTIwODQ0NjhhNjYyNTdiMSA9IEwucG9wdXAoeyJtYXhXaWR0aCI6ICIxMDAlIn0pOwoKICAgICAgICAKICAgICAgICAgICAgdmFyIGh0bWxfZGQ3YjZkN2IwMWNmNDFjMTk3Y2VjNjdiYzcyYjA2ODEgPSAkKGA8ZGl2IGlkPSJodG1sX2RkN2I2ZDdiMDFjZjQxYzE5N2NlYzY3YmM3MmIwNjgxIiBzdHlsZT0id2lkdGg6IDEwMC4wJTsgaGVpZ2h0OiAxMDAuMCU7Ij5OYW1lOiBUUlVFIEFORCBXRUJTVEVSIERJVENIIFByZWNpcDogMC4wMDwvZGl2PmApWzBdOwogICAgICAgICAgICBwb3B1cF9jYmFhZjlhNjYzOGI0YmVhOTIwODQ0NjhhNjYyNTdiMS5zZXRDb250ZW50KGh0bWxfZGQ3YjZkN2IwMWNmNDFjMTk3Y2VjNjdiYzcyYjA2ODEpOwogICAgICAgIAoKICAgICAgICBtYXJrZXJfMTZkNWNmZDE4NWVmNDJjZmI2Y2Y2NTQ1ZTY2Yjg4MWEuYmluZFBvcHVwKHBvcHVwX2NiYWFmOWE2NjM4YjRiZWE5MjA4NDQ2OGE2NjI1N2IxKQogICAgICAgIDsKCiAgICAgICAgCiAgICAKICAgIAogICAgICAgICAgICB2YXIgbWFya2VyXzhmZWFhMzg4ZWVhNzRiYmViMDM0YjdlZDFhNzMzNWY4ID0gTC5tYXJrZXIoCiAgICAgICAgICAgICAgICBbNDAuMjEyNjU4LCAtMTA1LjI1MTgyNl0sCiAgICAgICAgICAgICAgICB7fQogICAgICAgICAgICApLmFkZFRvKG1hcmtlcl9jbHVzdGVyXzMxMjcyYzM1M2RkOTQ1ZTZhODUyNmUyOTgxNGY1NmI3KTsKICAgICAgICAKICAgIAogICAgICAgIHZhciBwb3B1cF8yMmI0ZjQwYmRjZjg0NThjYTBlN2VjMDU1NTlkODEyNiA9IEwucG9wdXAoeyJtYXhXaWR0aCI6ICIxMDAlIn0pOwoKICAgICAgICAKICAgICAgICAgICAgdmFyIGh0bWxfZjUwNGQ1Y2EwZjJhNDFmZTkyYzM2ZWNjYTQ1ZDI0NWYgPSAkKGA8ZGl2IGlkPSJodG1sX2Y1MDRkNWNhMGYyYTQxZmU5MmMzNmVjY2E0NWQyNDVmIiBzdHlsZT0id2lkdGg6IDEwMC4wJTsgaGVpZ2h0OiAxMDAuMCU7Ij5OYW1lOiBST1VHSCBBTkQgUkVBRFkgRElUQ0ggUHJlY2lwOiAwLjAwPC9kaXY+YClbMF07CiAgICAgICAgICAgIHBvcHVwXzIyYjRmNDBiZGNmODQ1OGNhMGU3ZWMwNTU1OWQ4MTI2LnNldENvbnRlbnQoaHRtbF9mNTA0ZDVjYTBmMmE0MWZlOTJjMzZlY2NhNDVkMjQ1Zik7CiAgICAgICAgCgogICAgICAgIG1hcmtlcl84ZmVhYTM4OGVlYTc0YmJlYjAzNGI3ZWQxYTczMzVmOC5iaW5kUG9wdXAocG9wdXBfMjJiNGY0MGJkY2Y4NDU4Y2EwZTdlYzA1NTU5ZDgxMjYpCiAgICAgICAgOwoKICAgICAgICAKICAgIAogICAgCiAgICAgICAgICAgIHZhciBtYXJrZXJfNjMxOWYzMzMxNzEzNDg4ZTgxZTE1MWEzMDgxNDUzYjcgPSBMLm1hcmtlcigKICAgICAgICAgICAgICAgIFs0MC4xNzQ4NDQsIC0xMDUuMTY3ODczXSwKICAgICAgICAgICAgICAgIHt9CiAgICAgICAgICAgICkuYWRkVG8obWFya2VyX2NsdXN0ZXJfMzEyNzJjMzUzZGQ5NDVlNmE4NTI2ZTI5ODE0ZjU2YjcpOwogICAgICAgIAogICAgCiAgICAgICAgdmFyIHBvcHVwXzRmM2E1OGU4YmNjZDQzMmU5YjUzOTI2NjQyY2I4Y2JiID0gTC5wb3B1cCh7Im1heFdpZHRoIjogIjEwMCUifSk7CgogICAgICAgIAogICAgICAgICAgICB2YXIgaHRtbF9jMjUwZDJlNmYwMTQ0NWFiYWI0ZmZlZGI5YThmNDk1NSA9ICQoYDxkaXYgaWQ9Imh0bWxfYzI1MGQyZTZmMDE0NDVhYmFiNGZmZWRiOWE4ZjQ5NTUiIHN0eWxlPSJ3aWR0aDogMTAwLjAlOyBoZWlnaHQ6IDEwMC4wJTsiPk5hbWU6IEhBR0VSIE1FQURPV1MgRElUQ0ggUHJlY2lwOiAwLjEyPC9kaXY+YClbMF07CiAgICAgICAgICAgIHBvcHVwXzRmM2E1OGU4YmNjZDQzMmU5YjUzOTI2NjQyY2I4Y2JiLnNldENvbnRlbnQoaHRtbF9jMjUwZDJlNmYwMTQ0NWFiYWI0ZmZlZGI5YThmNDk1NSk7CiAgICAgICAgCgogICAgICAgIG1hcmtlcl82MzE5ZjMzMzE3MTM0ODhlODFlMTUxYTMwODE0NTNiNy5iaW5kUG9wdXAocG9wdXBfNGYzYTU4ZThiY2NkNDMyZTliNTM5MjY2NDJjYjhjYmIpCiAgICAgICAgOwoKICAgICAgICAKICAgIAogICAgCiAgICAgICAgICAgIHZhciBtYXJrZXJfZmQyOGJmOTQ3MDY3NDZkMmJjNzU1ZGEzY2Q1ZjM2YzIgPSBMLm1hcmtlcigKICAgICAgICAgICAgICAgIFs0MC4yNTYyNzYsIC0xMDUuMjA5NDE2XSwKICAgICAgICAgICAgICAgIHt9CiAgICAgICAgICAgICkuYWRkVG8obWFya2VyX2NsdXN0ZXJfMzEyNzJjMzUzZGQ5NDVlNmE4NTI2ZTI5ODE0ZjU2YjcpOwogICAgICAgIAogICAgCiAgICAgICAgdmFyIHBvcHVwXzQyMmEwYzA2Yjk4YzQyZTRiMjg2M2RkNDU2YzE2MDc5ID0gTC5wb3B1cCh7Im1heFdpZHRoIjogIjEwMCUifSk7CgogICAgICAgIAogICAgICAgICAgICB2YXIgaHRtbF8wMjVmYzQxODk5ZjY0NWI3OGM0NTYyYThjZTViODdhNyA9ICQoYDxkaXYgaWQ9Imh0bWxfMDI1ZmM0MTg5OWY2NDViNzhjNDU2MmE4Y2U1Yjg3YTciIHN0eWxlPSJ3aWR0aDogMTAwLjAlOyBoZWlnaHQ6IDEwMC4wJTsiPk5hbWU6IExJVFRMRSBUSE9NUFNPTiAjMSBESVRDSCBQcmVjaXA6IDAuMDA8L2Rpdj5gKVswXTsKICAgICAgICAgICAgcG9wdXBfNDIyYTBjMDZiOThjNDJlNGIyODYzZGQ0NTZjMTYwNzkuc2V0Q29udGVudChodG1sXzAyNWZjNDE4OTlmNjQ1Yjc4YzQ1NjJhOGNlNWI4N2E3KTsKICAgICAgICAKCiAgICAgICAgbWFya2VyX2ZkMjhiZjk0NzA2NzQ2ZDJiYzc1NWRhM2NkNWYzNmMyLmJpbmRQb3B1cChwb3B1cF80MjJhMGMwNmI5OGM0MmU0YjI4NjNkZDQ1NmMxNjA3OSkKICAgICAgICA7CgogICAgICAgIAogICAgCiAgICAKICAgICAgICAgICAgdmFyIG1hcmtlcl81YjNjMmQwNzEwZDM0M2UwYTQyOGFjY2Y3ZjljMGM2OSA9IEwubWFya2VyKAogICAgICAgICAgICAgICAgWzQwLjI2MDgyNywgLTEwNS4xOTg1NjddLAogICAgICAgICAgICAgICAge30KICAgICAgICAgICAgKS5hZGRUbyhtYXJrZXJfY2x1c3Rlcl8zMTI3MmMzNTNkZDk0NWU2YTg1MjZlMjk4MTRmNTZiNyk7CiAgICAgICAgCiAgICAKICAgICAgICB2YXIgcG9wdXBfNjY3MzdlNTc0ZjJkNGQxMWFiYjZkNDdhMjIxNmE4NmYgPSBMLnBvcHVwKHsibWF4V2lkdGgiOiAiMTAwJSJ9KTsKCiAgICAgICAgCiAgICAgICAgICAgIHZhciBodG1sX2IwMjg1NmQ2OGQzYzQ0NmRiYzdjOWUzOGY4OTEzOGU4ID0gJChgPGRpdiBpZD0iaHRtbF9iMDI4NTZkNjhkM2M0NDZkYmM3YzllMzhmODkxMzhlOCIgc3R5bGU9IndpZHRoOiAxMDAuMCU7IGhlaWdodDogMTAwLjAlOyI+TmFtZTogQ1VMVkVSIERJVENIIFByZWNpcDogMC4wMDwvZGl2PmApWzBdOwogICAgICAgICAgICBwb3B1cF82NjczN2U1NzRmMmQ0ZDExYWJiNmQ0N2EyMjE2YTg2Zi5zZXRDb250ZW50KGh0bWxfYjAyODU2ZDY4ZDNjNDQ2ZGJjN2M5ZTM4Zjg5MTM4ZTgpOwogICAgICAgIAoKICAgICAgICBtYXJrZXJfNWIzYzJkMDcxMGQzNDNlMGE0MjhhY2NmN2Y5YzBjNjkuYmluZFBvcHVwKHBvcHVwXzY2NzM3ZTU3NGYyZDRkMTFhYmI2ZDQ3YTIyMTZhODZmKQogICAgICAgIDsKCiAgICAgICAgCiAgICAKICAgIAogICAgICAgICAgICB2YXIgbWFya2VyX2ZhYjNiOTNlZTA2NTRlZWJhNzVmOWMxZDVkNTFkZTA0ID0gTC5tYXJrZXIoCiAgICAgICAgICAgICAgICBbNDAuMjE1MDQzLCAtMTA1LjI1NjAxN10sCiAgICAgICAgICAgICAgICB7fQogICAgICAgICAgICApLmFkZFRvKG1hcmtlcl9jbHVzdGVyXzMxMjcyYzM1M2RkOTQ1ZTZhODUyNmUyOTgxNGY1NmI3KTsKICAgICAgICAKICAgIAogICAgICAgIHZhciBwb3B1cF9kMTc2YjUzYjM4ZjY0NzA2ODcxMDZkNDYzOGE4ZDRhNSA9IEwucG9wdXAoeyJtYXhXaWR0aCI6ICIxMDAlIn0pOwoKICAgICAgICAKICAgICAgICAgICAgdmFyIGh0bWxfNDcxMDVmNTAwM2UxNDk1OWJhM2VmZTUxYzZjYWUwZGQgPSAkKGA8ZGl2IGlkPSJodG1sXzQ3MTA1ZjUwMDNlMTQ5NTliYTNlZmU1MWM2Y2FlMGRkIiBzdHlsZT0id2lkdGg6IDEwMC4wJTsgaGVpZ2h0OiAxMDAuMCU7Ij5OYW1lOiBISUdITEFORCBESVRDSCBBVCBMWU9OUywgQ08gUHJlY2lwOiAzOC45MDwvZGl2PmApWzBdOwogICAgICAgICAgICBwb3B1cF9kMTc2YjUzYjM4ZjY0NzA2ODcxMDZkNDYzOGE4ZDRhNS5zZXRDb250ZW50KGh0bWxfNDcxMDVmNTAwM2UxNDk1OWJhM2VmZTUxYzZjYWUwZGQpOwogICAgICAgIAoKICAgICAgICBtYXJrZXJfZmFiM2I5M2VlMDY1NGVlYmE3NWY5YzFkNWQ1MWRlMDQuYmluZFBvcHVwKHBvcHVwX2QxNzZiNTNiMzhmNjQ3MDY4NzEwNmQ0NjM4YThkNGE1KQogICAgICAgIDsKCiAgICAgICAgCiAgICAKICAgIAogICAgICAgICAgICB2YXIgbWFya2VyXzFjMDRhOWMxY2QxMjQyNzc4OGIyN2FmYzRjMzE4MmYyID0gTC5tYXJrZXIoCiAgICAgICAgICAgICAgICBbNDAuMDc4NTYsIC0xMDUuMjIwNDk3XSwKICAgICAgICAgICAgICAgIHt9CiAgICAgICAgICAgICkuYWRkVG8obWFya2VyX2NsdXN0ZXJfMzEyNzJjMzUzZGQ5NDVlNmE4NTI2ZTI5ODE0ZjU2YjcpOwogICAgICAgIAogICAgCiAgICAgICAgdmFyIHBvcHVwX2NmZmJkOWIzMGVkYjRmM2RiNDNjMmVjNjAzZGFhNjRhID0gTC5wb3B1cCh7Im1heFdpZHRoIjogIjEwMCUifSk7CgogICAgICAgIAogICAgICAgICAgICB2YXIgaHRtbF9mZDI1YjZiOTUyN2E0NjcxYjE5NzUwZTE3ZDU2MmFlNSA9ICQoYDxkaXYgaWQ9Imh0bWxfZmQyNWI2Yjk1MjdhNDY3MWIxOTc1MGUxN2Q1NjJhZTUiIHN0eWxlPSJ3aWR0aDogMTAwLjAlOyBoZWlnaHQ6IDEwMC4wJTsiPk5hbWU6IEJPVUxERVIgUkVTRVJWT0lSIFByZWNpcDogNTIwNi4yMDwvZGl2PmApWzBdOwogICAgICAgICAgICBwb3B1cF9jZmZiZDliMzBlZGI0ZjNkYjQzYzJlYzYwM2RhYTY0YS5zZXRDb250ZW50KGh0bWxfZmQyNWI2Yjk1MjdhNDY3MWIxOTc1MGUxN2Q1NjJhZTUpOwogICAgICAgIAoKICAgICAgICBtYXJrZXJfMWMwNGE5YzFjZDEyNDI3Nzg4YjI3YWZjNGMzMTgyZjIuYmluZFBvcHVwKHBvcHVwX2NmZmJkOWIzMGVkYjRmM2RiNDNjMmVjNjAzZGFhNjRhKQogICAgICAgIDsKCiAgICAgICAgCiAgICAKICAgIAogICAgICAgICAgICB2YXIgbWFya2VyXzc0MTY2YTI4NWVmNDQ4NDE4ZGIxNDlkNjg0ZWU4OTAxID0gTC5tYXJrZXIoCiAgICAgICAgICAgICAgICBbNDAuMTczOTUsIC0xMDUuMTY5Mzc0XSwKICAgICAgICAgICAgICAgIHt9CiAgICAgICAgICAgICkuYWRkVG8obWFya2VyX2NsdXN0ZXJfMzEyNzJjMzUzZGQ5NDVlNmE4NTI2ZTI5ODE0ZjU2YjcpOwogICAgICAgIAogICAgCiAgICAgICAgdmFyIHBvcHVwXzBiNDdkYmY3MGFhNzRhMzRhMjk3NzAzYWQ5M2NhZWU5ID0gTC5wb3B1cCh7Im1heFdpZHRoIjogIjEwMCUifSk7CgogICAgICAgIAogICAgICAgICAgICB2YXIgaHRtbF82OTJiZTQwNDY2MjY0MDMzYTMwNjljYzk1ZjExMDUzMyA9ICQoYDxkaXYgaWQ9Imh0bWxfNjkyYmU0MDQ2NjI2NDAzM2EzMDY5Y2M5NWYxMTA1MzMiIHN0eWxlPSJ3aWR0aDogMTAwLjAlOyBoZWlnaHQ6IDEwMC4wJTsiPk5hbWU6IE5JV09UIERJVENIIFByZWNpcDogMC4xOTwvZGl2PmApWzBdOwogICAgICAgICAgICBwb3B1cF8wYjQ3ZGJmNzBhYTc0YTM0YTI5NzcwM2FkOTNjYWVlOS5zZXRDb250ZW50KGh0bWxfNjkyYmU0MDQ2NjI2NDAzM2EzMDY5Y2M5NWYxMTA1MzMpOwogICAgICAgIAoKICAgICAgICBtYXJrZXJfNzQxNjZhMjg1ZWY0NDg0MThkYjE0OWQ2ODRlZTg5MDEuYmluZFBvcHVwKHBvcHVwXzBiNDdkYmY3MGFhNzRhMzRhMjk3NzAzYWQ5M2NhZWU5KQogICAgICAgIDsKCiAgICAgICAgCiAgICAKICAgIAogICAgICAgICAgICB2YXIgbWFya2VyXzkyZmI4Y2U5ZDRhYjQ4MjFiNjE1NDE3MTk1OWI3MTg4ID0gTC5tYXJrZXIoCiAgICAgICAgICAgICAgICBbNDAuMjExMzg5LCAtMTA1LjI1MDk1Ml0sCiAgICAgICAgICAgICAgICB7fQogICAgICAgICAgICApLmFkZFRvKG1hcmtlcl9jbHVzdGVyXzMxMjcyYzM1M2RkOTQ1ZTZhODUyNmUyOTgxNGY1NmI3KTsKICAgICAgICAKICAgIAogICAgICAgIHZhciBwb3B1cF9jNzQ3MTExYjkyMmE0MTQ0OTE3MWQzZjczZWZhMTFmNCA9IEwucG9wdXAoeyJtYXhXaWR0aCI6ICIxMDAlIn0pOwoKICAgICAgICAKICAgICAgICAgICAgdmFyIGh0bWxfYzc3NzczNjJhZTI3NDBjODg0YTI3NDZmYWRkZGFkMzggPSAkKGA8ZGl2IGlkPSJodG1sX2M3Nzc3MzYyYWUyNzQwYzg4NGEyNzQ2ZmFkZGRhZDM4IiBzdHlsZT0id2lkdGg6IDEwMC4wJTsgaGVpZ2h0OiAxMDAuMCU7Ij5OYW1lOiBTTUVBRCBESVRDSCBQcmVjaXA6IDAuMDA8L2Rpdj5gKVswXTsKICAgICAgICAgICAgcG9wdXBfYzc0NzExMWI5MjJhNDE0NDkxNzFkM2Y3M2VmYTExZjQuc2V0Q29udGVudChodG1sX2M3Nzc3MzYyYWUyNzQwYzg4NGEyNzQ2ZmFkZGRhZDM4KTsKICAgICAgICAKCiAgICAgICAgbWFya2VyXzkyZmI4Y2U5ZDRhYjQ4MjFiNjE1NDE3MTk1OWI3MTg4LmJpbmRQb3B1cChwb3B1cF9jNzQ3MTExYjkyMmE0MTQ0OTE3MWQzZjczZWZhMTFmNCkKICAgICAgICA7CgogICAgICAgIAogICAgCiAgICAKICAgICAgICAgICAgdmFyIG1hcmtlcl8yZTdhNWViMjYzNmE0ZjgwYTMzNTQ1MmQyMWUyMGI1MyA9IEwubWFya2VyKAogICAgICAgICAgICAgICAgWzQwLjE1MzM2MywgLTEwNS4wODg2OTVdLAogICAgICAgICAgICAgICAge30KICAgICAgICAgICAgKS5hZGRUbyhtYXJrZXJfY2x1c3Rlcl8zMTI3MmMzNTNkZDk0NWU2YTg1MjZlMjk4MTRmNTZiNyk7CiAgICAgICAgCiAgICAKICAgICAgICB2YXIgcG9wdXBfZDQ3MjI1N2Y4ZjA5NGMxZTkwMzdhMjNhOTM2MjEzNmYgPSBMLnBvcHVwKHsibWF4V2lkdGgiOiAiMTAwJSJ9KTsKCiAgICAgICAgCiAgICAgICAgICAgIHZhciBodG1sXzhjMGJjNDMwMTA5ZjQyMDFiYzRlZDlhNmIxODM0OTI3ID0gJChgPGRpdiBpZD0iaHRtbF84YzBiYzQzMDEwOWY0MjAxYmM0ZWQ5YTZiMTgzNDkyNyIgc3R5bGU9IndpZHRoOiAxMDAuMCU7IGhlaWdodDogMTAwLjAlOyI+TmFtZTogQk9OVVMgRElUQ0ggUHJlY2lwOiAwLjEwPC9kaXY+YClbMF07CiAgICAgICAgICAgIHBvcHVwX2Q0NzIyNTdmOGYwOTRjMWU5MDM3YTIzYTkzNjIxMzZmLnNldENvbnRlbnQoaHRtbF84YzBiYzQzMDEwOWY0MjAxYmM0ZWQ5YTZiMTgzNDkyNyk7CiAgICAgICAgCgogICAgICAgIG1hcmtlcl8yZTdhNWViMjYzNmE0ZjgwYTMzNTQ1MmQyMWUyMGI1My5iaW5kUG9wdXAocG9wdXBfZDQ3MjI1N2Y4ZjA5NGMxZTkwMzdhMjNhOTM2MjEzNmYpCiAgICAgICAgOwoKICAgICAgICAKICAgIAogICAgCiAgICAgICAgICAgIHZhciBtYXJrZXJfZGM1ZjBiNDZhNTZjNGY2NmFmMjQ1MjljNjM0ZjJkYzMgPSBMLm1hcmtlcigKICAgICAgICAgICAgICAgIFs0MC4yMTEwODMsIC0xMDUuMjUwOTI3XSwKICAgICAgICAgICAgICAgIHt9CiAgICAgICAgICAgICkuYWRkVG8obWFya2VyX2NsdXN0ZXJfMzEyNzJjMzUzZGQ5NDVlNmE4NTI2ZTI5ODE0ZjU2YjcpOwogICAgICAgIAogICAgCiAgICAgICAgdmFyIHBvcHVwXzczOGE3NzlkYWU3ZDQzNDJhMjMxMjQyMjkwYmQ5NTI2ID0gTC5wb3B1cCh7Im1heFdpZHRoIjogIjEwMCUifSk7CgogICAgICAgIAogICAgICAgICAgICB2YXIgaHRtbF80ZDgyOGY4MDgzMDA0Y2UyYmVhZWIwYjk4NzZkOGQ4MiA9ICQoYDxkaXYgaWQ9Imh0bWxfNGQ4MjhmODA4MzAwNGNlMmJlYWViMGI5ODc2ZDhkODIiIHN0eWxlPSJ3aWR0aDogMTAwLjAlOyBoZWlnaHQ6IDEwMC4wJTsiPk5hbWU6IFNXRURFIERJVENIIFByZWNpcDogMC4wMDwvZGl2PmApWzBdOwogICAgICAgICAgICBwb3B1cF83MzhhNzc5ZGFlN2Q0MzQyYTIzMTI0MjI5MGJkOTUyNi5zZXRDb250ZW50KGh0bWxfNGQ4MjhmODA4MzAwNGNlMmJlYWViMGI5ODc2ZDhkODIpOwogICAgICAgIAoKICAgICAgICBtYXJrZXJfZGM1ZjBiNDZhNTZjNGY2NmFmMjQ1MjljNjM0ZjJkYzMuYmluZFBvcHVwKHBvcHVwXzczOGE3NzlkYWU3ZDQzNDJhMjMxMjQyMjkwYmQ5NTI2KQogICAgICAgIDsKCiAgICAgICAgCiAgICAKICAgIAogICAgICAgICAgICB2YXIgbWFya2VyXzNjZDFkYTg2NjVlNzRjMjBhOGMwNTg2NDZlODUyZTU2ID0gTC5tYXJrZXIoCiAgICAgICAgICAgICAgICBbNDAuMTg3NTI0LCAtMTA1LjE4OTEzMl0sCiAgICAgICAgICAgICAgICB7fQogICAgICAgICAgICApLmFkZFRvKG1hcmtlcl9jbHVzdGVyXzMxMjcyYzM1M2RkOTQ1ZTZhODUyNmUyOTgxNGY1NmI3KTsKICAgICAgICAKICAgIAogICAgICAgIHZhciBwb3B1cF8xMTdiYzE5NzE5NTI0MDc2OTg5ODQyZWFlYWRhZTE5NiA9IEwucG9wdXAoeyJtYXhXaWR0aCI6ICIxMDAlIn0pOwoKICAgICAgICAKICAgICAgICAgICAgdmFyIGh0bWxfZTMwNTMzYzUwNDIyNDExODlmZjU0YWI0ZTk5ZjAzZWUgPSAkKGA8ZGl2IGlkPSJodG1sX2UzMDUzM2M1MDQyMjQxMTg5ZmY1NGFiNGU5OWYwM2VlIiBzdHlsZT0id2lkdGg6IDEwMC4wJTsgaGVpZ2h0OiAxMDAuMCU7Ij5OYW1lOiBSVU5ZT04gRElUQ0ggUHJlY2lwOiAwLjAwPC9kaXY+YClbMF07CiAgICAgICAgICAgIHBvcHVwXzExN2JjMTk3MTk1MjQwNzY5ODk4NDJlYWVhZGFlMTk2LnNldENvbnRlbnQoaHRtbF9lMzA1MzNjNTA0MjI0MTE4OWZmNTRhYjRlOTlmMDNlZSk7CiAgICAgICAgCgogICAgICAgIG1hcmtlcl8zY2QxZGE4NjY1ZTc0YzIwYThjMDU4NjQ2ZTg1MmU1Ni5iaW5kUG9wdXAocG9wdXBfMTE3YmMxOTcxOTUyNDA3Njk4OTg0MmVhZWFkYWUxOTYpCiAgICAgICAgOwoKICAgICAgICAKICAgIAogICAgCiAgICAgICAgICAgIHZhciBtYXJrZXJfMTIxYTg4NzUxMjk3NDE0Yzg2NTg0NzRiNWRkNmFiNjggPSBMLm1hcmtlcigKICAgICAgICAgICAgICAgIFs0MC4xODE4OCwgLTEwNS4xOTY3NzVdLAogICAgICAgICAgICAgICAge30KICAgICAgICAgICAgKS5hZGRUbyhtYXJrZXJfY2x1c3Rlcl8zMTI3MmMzNTNkZDk0NWU2YTg1MjZlMjk4MTRmNTZiNyk7CiAgICAgICAgCiAgICAKICAgICAgICB2YXIgcG9wdXBfNzFjYmI4ODVkYjBiNDFmN2I4ODQ5Y2Y1OWQyMzFmZTkgPSBMLnBvcHVwKHsibWF4V2lkdGgiOiAiMTAwJSJ9KTsKCiAgICAgICAgCiAgICAgICAgICAgIHZhciBodG1sX2M5NjU4NjAzYzMyNjRhNTlhY2MyMGZlYjM0NjhkYzYyID0gJChgPGRpdiBpZD0iaHRtbF9jOTY1ODYwM2MzMjY0YTU5YWNjMjBmZWIzNDY4ZGM2MiIgc3R5bGU9IndpZHRoOiAxMDAuMCU7IGhlaWdodDogMTAwLjAlOyI+TmFtZTogREFWSVMgQU5EIERPV05JTkcgRElUQ0ggUHJlY2lwOiAwLjAwPC9kaXY+YClbMF07CiAgICAgICAgICAgIHBvcHVwXzcxY2JiODg1ZGIwYjQxZjdiODg0OWNmNTlkMjMxZmU5LnNldENvbnRlbnQoaHRtbF9jOTY1ODYwM2MzMjY0YTU5YWNjMjBmZWIzNDY4ZGM2Mik7CiAgICAgICAgCgogICAgICAgIG1hcmtlcl8xMjFhODg3NTEyOTc0MTRjODY1ODQ3NGI1ZGQ2YWI2OC5iaW5kUG9wdXAocG9wdXBfNzFjYmI4ODVkYjBiNDFmN2I4ODQ5Y2Y1OWQyMzFmZTkpCiAgICAgICAgOwoKICAgICAgICAKICAgIAogICAgCiAgICAgICAgICAgIHZhciBtYXJrZXJfMTg0YWY5ZmM0NmFhNGI5MGEwYzNjODcxMjE0YTU5YTcgPSBMLm1hcmtlcigKICAgICAgICAgICAgICAgIFs0MC4wMTg2NjcsIC0xMDUuMzI2MjVdLAogICAgICAgICAgICAgICAge30KICAgICAgICAgICAgKS5hZGRUbyhtYXJrZXJfY2x1c3Rlcl8zMTI3MmMzNTNkZDk0NWU2YTg1MjZlMjk4MTRmNTZiNyk7CiAgICAgICAgCiAgICAKICAgICAgICB2YXIgcG9wdXBfMTQ5NjA5NGU0NDE5NGY3ZWE2ZGYzM2UzODFjOTk5MWQgPSBMLnBvcHVwKHsibWF4V2lkdGgiOiAiMTAwJSJ9KTsKCiAgICAgICAgCiAgICAgICAgICAgIHZhciBodG1sX2MxNjhhYjBmNmFkYjQ2NWJiNTBjMWRmNGFjYjQ0ODFkID0gJChgPGRpdiBpZD0iaHRtbF9jMTY4YWIwZjZhZGI0NjViYjUwYzFkZjRhY2I0NDgxZCIgc3R5bGU9IndpZHRoOiAxMDAuMCU7IGhlaWdodDogMTAwLjAlOyI+TmFtZTogRk9VUk1JTEUgQ1JFRUsgQVQgT1JPREVMTCwgQ08gUHJlY2lwOiAwLjc0PC9kaXY+YClbMF07CiAgICAgICAgICAgIHBvcHVwXzE0OTYwOTRlNDQxOTRmN2VhNmRmMzNlMzgxYzk5OTFkLnNldENvbnRlbnQoaHRtbF9jMTY4YWIwZjZhZGI0NjViYjUwYzFkZjRhY2I0NDgxZCk7CiAgICAgICAgCgogICAgICAgIG1hcmtlcl8xODRhZjlmYzQ2YWE0YjkwYTBjM2M4NzEyMTRhNTlhNy5iaW5kUG9wdXAocG9wdXBfMTQ5NjA5NGU0NDE5NGY3ZWE2ZGYzM2UzODFjOTk5MWQpCiAgICAgICAgOwoKICAgICAgICAKICAgIAogICAgCiAgICAgICAgICAgIHZhciBtYXJrZXJfMmNhZjhkM2VmOThkNDRjZTg2ODljYTIyZTlmMmFmY2YgPSBMLm1hcmtlcigKICAgICAgICAgICAgICAgIFs0MC4xODg1NzksIC0xMDUuMjA5MjgyXSwKICAgICAgICAgICAgICAgIHt9CiAgICAgICAgICAgICkuYWRkVG8obWFya2VyX2NsdXN0ZXJfMzEyNzJjMzUzZGQ5NDVlNmE4NTI2ZTI5ODE0ZjU2YjcpOwogICAgICAgIAogICAgCiAgICAgICAgdmFyIHBvcHVwXzg1MmY5MjVlMjYwNTQwZjk5ZDJiMmJhOTY4ZWM3ZDUzID0gTC5wb3B1cCh7Im1heFdpZHRoIjogIjEwMCUifSk7CgogICAgICAgIAogICAgICAgICAgICB2YXIgaHRtbF82MDkyZTU0MmY2ZDY0NDgyYTMzOWI0YzYyZGI1YWUzNCA9ICQoYDxkaXYgaWQ9Imh0bWxfNjA5MmU1NDJmNmQ2NDQ4MmEzMzliNGM2MmRiNWFlMzQiIHN0eWxlPSJ3aWR0aDogMTAwLjAlOyBoZWlnaHQ6IDEwMC4wJTsiPk5hbWU6IEpBTUVTIERJVENIIFByZWNpcDogMC4xMjwvZGl2PmApWzBdOwogICAgICAgICAgICBwb3B1cF84NTJmOTI1ZTI2MDU0MGY5OWQyYjJiYTk2OGVjN2Q1My5zZXRDb250ZW50KGh0bWxfNjA5MmU1NDJmNmQ2NDQ4MmEzMzliNGM2MmRiNWFlMzQpOwogICAgICAgIAoKICAgICAgICBtYXJrZXJfMmNhZjhkM2VmOThkNDRjZTg2ODljYTIyZTlmMmFmY2YuYmluZFBvcHVwKHBvcHVwXzg1MmY5MjVlMjYwNTQwZjk5ZDJiMmJhOTY4ZWM3ZDUzKQogICAgICAgIDsKCiAgICAgICAgCiAgICAKICAgIAogICAgICAgICAgICB2YXIgbWFya2VyXzFiZmY2NjQ0YjdhNDQyZjBhNTFlN2ZjZWZiY2QxZjkyID0gTC5tYXJrZXIoCiAgICAgICAgICAgICAgICBbNDAuMDUzMDM1LCAtMTA1LjE5MzA0OF0sCiAgICAgICAgICAgICAgICB7fQogICAgICAgICAgICApLmFkZFRvKG1hcmtlcl9jbHVzdGVyXzMxMjcyYzM1M2RkOTQ1ZTZhODUyNmUyOTgxNGY1NmI3KTsKICAgICAgICAKICAgIAogICAgICAgIHZhciBwb3B1cF8yNWNkYWJiNTEwNDA0NTc1YjRjMDE5M2RkYjNhZTgxYSA9IEwucG9wdXAoeyJtYXhXaWR0aCI6ICIxMDAlIn0pOwoKICAgICAgICAKICAgICAgICAgICAgdmFyIGh0bWxfNTM2ZjlkMDhiNDNkNGQwNGI4OTdiZjIzNWI2ZTNmYjkgPSAkKGA8ZGl2IGlkPSJodG1sXzUzNmY5ZDA4YjQzZDRkMDRiODk3YmYyMzViNmUzZmI5IiBzdHlsZT0id2lkdGg6IDEwMC4wJTsgaGVpZ2h0OiAxMDAuMCU7Ij5OYW1lOiBCT1VMREVSIENSRUVLIFNVUFBMWSBDQU5BTCBUTyBCT1VMREVSIENSRUVLIE5FQVIgQk9VTERFUiBQcmVjaXA6IDAuMDA8L2Rpdj5gKVswXTsKICAgICAgICAgICAgcG9wdXBfMjVjZGFiYjUxMDQwNDU3NWI0YzAxOTNkZGIzYWU4MWEuc2V0Q29udGVudChodG1sXzUzNmY5ZDA4YjQzZDRkMDRiODk3YmYyMzViNmUzZmI5KTsKICAgICAgICAKCiAgICAgICAgbWFya2VyXzFiZmY2NjQ0YjdhNDQyZjBhNTFlN2ZjZWZiY2QxZjkyLmJpbmRQb3B1cChwb3B1cF8yNWNkYWJiNTEwNDA0NTc1YjRjMDE5M2RkYjNhZTgxYSkKICAgICAgICA7CgogICAgICAgIAogICAgCiAgICAKICAgICAgICAgICAgdmFyIG1hcmtlcl85NTJmNDY4OWIzZjQ0Yjk1YjJlZjA4ZDE2NDEwYjM2ZSA9IEwubWFya2VyKAogICAgICAgICAgICAgICAgWzQwLjI1ODM2NywgLTEwNS4xNzQ5NTddLAogICAgICAgICAgICAgICAge30KICAgICAgICAgICAgKS5hZGRUbyhtYXJrZXJfY2x1c3Rlcl8zMTI3MmMzNTNkZDk0NWU2YTg1MjZlMjk4MTRmNTZiNyk7CiAgICAgICAgCiAgICAKICAgICAgICB2YXIgcG9wdXBfMDI1ODFmYjcyNGUwNDIwYzk4ZWFhYzAyYTBlZjdkM2QgPSBMLnBvcHVwKHsibWF4V2lkdGgiOiAiMTAwJSJ9KTsKCiAgICAgICAgCiAgICAgICAgICAgIHZhciBodG1sX2Q4MWJhZDk5ZDFjODRkOTZiYWNjNDdmNjIxZTM2NDJhID0gJChgPGRpdiBpZD0iaHRtbF9kODFiYWQ5OWQxYzg0ZDk2YmFjYzQ3ZjYyMWUzNjQyYSIgc3R5bGU9IndpZHRoOiAxMDAuMCU7IGhlaWdodDogMTAwLjAlOyI+TmFtZTogQk9VTERFUi1MQVJJTUVSIERJVENIIE5FQVIgQkVSVEhPVUQgUHJlY2lwOiAwLjAwPC9kaXY+YClbMF07CiAgICAgICAgICAgIHBvcHVwXzAyNTgxZmI3MjRlMDQyMGM5OGVhYWMwMmEwZWY3ZDNkLnNldENvbnRlbnQoaHRtbF9kODFiYWQ5OWQxYzg0ZDk2YmFjYzQ3ZjYyMWUzNjQyYSk7CiAgICAgICAgCgogICAgICAgIG1hcmtlcl85NTJmNDY4OWIzZjQ0Yjk1YjJlZjA4ZDE2NDEwYjM2ZS5iaW5kUG9wdXAocG9wdXBfMDI1ODFmYjcyNGUwNDIwYzk4ZWFhYzAyYTBlZjdkM2QpCiAgICAgICAgOwoKICAgICAgICAKICAgIAogICAgCiAgICAgICAgICAgIHZhciBtYXJrZXJfNDY4YTgwNWUyYjhiNDNiNDg2NDVmMDgyMGRhODRhNTkgPSBMLm1hcmtlcigKICAgICAgICAgICAgICAgIFszOS45MzgzNTEsIC0xMDUuMzQ3OTA2XSwKICAgICAgICAgICAgICAgIHt9CiAgICAgICAgICAgICkuYWRkVG8obWFya2VyX2NsdXN0ZXJfMzEyNzJjMzUzZGQ5NDVlNmE4NTI2ZTI5ODE0ZjU2YjcpOwogICAgICAgIAogICAgCiAgICAgICAgdmFyIHBvcHVwXzEwNjdkNDBjY2I3YjRmYTZiMjk5NjEwNzNiZDRlMWJiID0gTC5wb3B1cCh7Im1heFdpZHRoIjogIjEwMCUifSk7CgogICAgICAgIAogICAgICAgICAgICB2YXIgaHRtbF83YzM3YTRjNmI5YzI0MTE1YmM5YWU3ZTZmOWYzZmU5NCA9ICQoYDxkaXYgaWQ9Imh0bWxfN2MzN2E0YzZiOWMyNDExNWJjOWFlN2U2ZjlmM2ZlOTQiIHN0eWxlPSJ3aWR0aDogMTAwLjAlOyBoZWlnaHQ6IDEwMC4wJTsiPk5hbWU6IFNPVVRIIEJPVUxERVIgQ1JFRUsgQkVMT1cgR1JPU1MgUkVTRVJWT0lSIFByZWNpcDogMTYuNDA8L2Rpdj5gKVswXTsKICAgICAgICAgICAgcG9wdXBfMTA2N2Q0MGNjYjdiNGZhNmIyOTk2MTA3M2JkNGUxYmIuc2V0Q29udGVudChodG1sXzdjMzdhNGM2YjljMjQxMTViYzlhZTdlNmY5ZjNmZTk0KTsKICAgICAgICAKCiAgICAgICAgbWFya2VyXzQ2OGE4MDVlMmI4YjQzYjQ4NjQ1ZjA4MjBkYTg0YTU5LmJpbmRQb3B1cChwb3B1cF8xMDY3ZDQwY2NiN2I0ZmE2YjI5OTYxMDczYmQ0ZTFiYikKICAgICAgICA7CgogICAgICAgIAogICAgCiAgICAKICAgICAgICAgICAgdmFyIG1hcmtlcl80NTUwYjY2OGRjY2U0ZDRkYmZiYzdkM2RmZTg0Yzk1YSA9IEwubWFya2VyKAogICAgICAgICAgICAgICAgWzQwLjIxMjUwNSwgLTEwNS4yNTE4MjZdLAogICAgICAgICAgICAgICAge30KICAgICAgICAgICAgKS5hZGRUbyhtYXJrZXJfY2x1c3Rlcl8zMTI3MmMzNTNkZDk0NWU2YTg1MjZlMjk4MTRmNTZiNyk7CiAgICAgICAgCiAgICAKICAgICAgICB2YXIgcG9wdXBfYjY5N2YwNzNhZDFhNDBiZGJkNmFhYmU4NzAyNWEzNmYgPSBMLnBvcHVwKHsibWF4V2lkdGgiOiAiMTAwJSJ9KTsKCiAgICAgICAgCiAgICAgICAgICAgIHZhciBodG1sX2EyNTA3NzRiZmIxYjQ4YmY5N2FlY2E3MjNlOWUxMWVmID0gJChgPGRpdiBpZD0iaHRtbF9hMjUwNzc0YmZiMWI0OGJmOTdhZWNhNzIzZTllMTFlZiIgc3R5bGU9IndpZHRoOiAxMDAuMCU7IGhlaWdodDogMTAwLjAlOyI+TmFtZTogUEFMTUVSVE9OIERJVENIIFByZWNpcDogMS4wODwvZGl2PmApWzBdOwogICAgICAgICAgICBwb3B1cF9iNjk3ZjA3M2FkMWE0MGJkYmQ2YWFiZTg3MDI1YTM2Zi5zZXRDb250ZW50KGh0bWxfYTI1MDc3NGJmYjFiNDhiZjk3YWVjYTcyM2U5ZTExZWYpOwogICAgICAgIAoKICAgICAgICBtYXJrZXJfNDU1MGI2NjhkY2NlNGQ0ZGJmYmM3ZDNkZmU4NGM5NWEuYmluZFBvcHVwKHBvcHVwX2I2OTdmMDczYWQxYTQwYmRiZDZhYWJlODcwMjVhMzZmKQogICAgICAgIDsKCiAgICAgICAgCiAgICAKICAgIAogICAgICAgICAgICB2YXIgbWFya2VyXzczMGYyY2QzODliMzRhNzk5M2JkMzg5OGFlNTc0ODQ2ID0gTC5tYXJrZXIoCiAgICAgICAgICAgICAgICBbNDAuMjE5MDQ2LCAtMTA1LjI1OTc5NV0sCiAgICAgICAgICAgICAgICB7fQogICAgICAgICAgICApLmFkZFRvKG1hcmtlcl9jbHVzdGVyXzMxMjcyYzM1M2RkOTQ1ZTZhODUyNmUyOTgxNGY1NmI3KTsKICAgICAgICAKICAgIAogICAgICAgIHZhciBwb3B1cF9mYTg5NTQ1YzcwODQ0ZWUyOThlODM3ZWIyNmRhZWM0MiA9IEwucG9wdXAoeyJtYXhXaWR0aCI6ICIxMDAlIn0pOwoKICAgICAgICAKICAgICAgICAgICAgdmFyIGh0bWxfMmIyODBjYWNmODA2NGNiZDg4ODFjMTU5MGVjYmY4NGEgPSAkKGA8ZGl2IGlkPSJodG1sXzJiMjgwY2FjZjgwNjRjYmQ4ODgxYzE1OTBlY2JmODRhIiBzdHlsZT0id2lkdGg6IDEwMC4wJTsgaGVpZ2h0OiAxMDAuMCU7Ij5OYW1lOiBTVVBQTFkgRElUQ0ggUHJlY2lwOiAwLjAwPC9kaXY+YClbMF07CiAgICAgICAgICAgIHBvcHVwX2ZhODk1NDVjNzA4NDRlZTI5OGU4MzdlYjI2ZGFlYzQyLnNldENvbnRlbnQoaHRtbF8yYjI4MGNhY2Y4MDY0Y2JkODg4MWMxNTkwZWNiZjg0YSk7CiAgICAgICAgCgogICAgICAgIG1hcmtlcl83MzBmMmNkMzg5YjM0YTc5OTNiZDM4OThhZTU3NDg0Ni5iaW5kUG9wdXAocG9wdXBfZmE4OTU0NWM3MDg0NGVlMjk4ZTgzN2ViMjZkYWVjNDIpCiAgICAgICAgOwoKICAgICAgICAKICAgIAogICAgCiAgICAgICAgICAgIHZhciBtYXJrZXJfNmMyNWM0ZDVhMjQwNDg4NmJjYzNjNjlmMzM1ODRkMWIgPSBMLm1hcmtlcigKICAgICAgICAgICAgICAgIFs0MC4xODc1NzgsIC0xMDUuMTg5MTkxXSwKICAgICAgICAgICAgICAgIHt9CiAgICAgICAgICAgICkuYWRkVG8obWFya2VyX2NsdXN0ZXJfMzEyNzJjMzUzZGQ5NDVlNmE4NTI2ZTI5ODE0ZjU2YjcpOwogICAgICAgIAogICAgCiAgICAgICAgdmFyIHBvcHVwXzI1NzI2M2FhZjEzYzQ2NmY4MjRlNjUyZGIxMGQ4NTEwID0gTC5wb3B1cCh7Im1heFdpZHRoIjogIjEwMCUifSk7CgogICAgICAgIAogICAgICAgICAgICB2YXIgaHRtbF9jOWVkY2FhYTE0MTM0MDA4OGIxZjEwOTAzOTMzNDg5NSA9ICQoYDxkaXYgaWQ9Imh0bWxfYzllZGNhYWExNDEzNDAwODhiMWYxMDkwMzkzMzQ4OTUiIHN0eWxlPSJ3aWR0aDogMTAwLjAlOyBoZWlnaHQ6IDEwMC4wJTsiPk5hbWU6IERFTklPIFRBWUxPUiBESVRDSCBQcmVjaXA6IDI4MTkuNjg8L2Rpdj5gKVswXTsKICAgICAgICAgICAgcG9wdXBfMjU3MjYzYWFmMTNjNDY2ZjgyNGU2NTJkYjEwZDg1MTAuc2V0Q29udGVudChodG1sX2M5ZWRjYWFhMTQxMzQwMDg4YjFmMTA5MDM5MzM0ODk1KTsKICAgICAgICAKCiAgICAgICAgbWFya2VyXzZjMjVjNGQ1YTI0MDQ4ODZiY2MzYzY5ZjMzNTg0ZDFiLmJpbmRQb3B1cChwb3B1cF8yNTcyNjNhYWYxM2M0NjZmODI0ZTY1MmRiMTBkODUxMCkKICAgICAgICA7CgogICAgICAgIAogICAgCiAgICAKICAgICAgICAgICAgdmFyIG1hcmtlcl85NjE5MGVmNDY0OTg0Y2ZlOTRmZDgxZTg2NDY3YTk3OCA9IEwubWFya2VyKAogICAgICAgICAgICAgICAgWzQwLjA0MjAyOCwgLTEwNS4zNjQ5MTddLAogICAgICAgICAgICAgICAge30KICAgICAgICAgICAgKS5hZGRUbyhtYXJrZXJfY2x1c3Rlcl8zMTI3MmMzNTNkZDk0NWU2YTg1MjZlMjk4MTRmNTZiNyk7CiAgICAgICAgCiAgICAKICAgICAgICB2YXIgcG9wdXBfN2I0NWIzZmM2MTMwNGI3YWE2MmY5NmQxNzAwOGRiZjkgPSBMLnBvcHVwKHsibWF4V2lkdGgiOiAiMTAwJSJ9KTsKCiAgICAgICAgCiAgICAgICAgICAgIHZhciBodG1sXzMxYmZhOThjMmViYjQ1ZGZhNjU2ZGFhNjQwZTZmYTM4ID0gJChgPGRpdiBpZD0iaHRtbF8zMWJmYTk4YzJlYmI0NWRmYTY1NmRhYTY0MGU2ZmEzOCIgc3R5bGU9IndpZHRoOiAxMDAuMCU7IGhlaWdodDogMTAwLjAlOyI+TmFtZTogRk9VUk1JTEUgQ1JFRUsgQVQgTE9HQU4gTUlMTCBST0FEIE5FQVIgQ1JJU01BTiwgQ08gUHJlY2lwOiBuYW48L2Rpdj5gKVswXTsKICAgICAgICAgICAgcG9wdXBfN2I0NWIzZmM2MTMwNGI3YWE2MmY5NmQxNzAwOGRiZjkuc2V0Q29udGVudChodG1sXzMxYmZhOThjMmViYjQ1ZGZhNjU2ZGFhNjQwZTZmYTM4KTsKICAgICAgICAKCiAgICAgICAgbWFya2VyXzk2MTkwZWY0NjQ5ODRjZmU5NGZkODFlODY0NjdhOTc4LmJpbmRQb3B1cChwb3B1cF83YjQ1YjNmYzYxMzA0YjdhYTYyZjk2ZDE3MDA4ZGJmOSkKICAgICAgICA7CgogICAgICAgIAogICAgCiAgICAKICAgICAgICAgICAgdmFyIG1hcmtlcl80M2U5MDFhNjBkMzc0ZmJiYjY1MTA3YmNkMDgyZWViNCA9IEwubWFya2VyKAogICAgICAgICAgICAgICAgWzQwLjE3NzA4LCAtMTA1LjE3ODU2N10sCiAgICAgICAgICAgICAgICB7fQogICAgICAgICAgICApLmFkZFRvKG1hcmtlcl9jbHVzdGVyXzMxMjcyYzM1M2RkOTQ1ZTZhODUyNmUyOTgxNGY1NmI3KTsKICAgICAgICAKICAgIAogICAgICAgIHZhciBwb3B1cF83OTVmYmY0NDU3NTg0ZTMyOTVhZWE3ZWE5ZTY4MDEzMCA9IEwucG9wdXAoeyJtYXhXaWR0aCI6ICIxMDAlIn0pOwoKICAgICAgICAKICAgICAgICAgICAgdmFyIGh0bWxfNzQxOGI5NzRmMGEwNDkwMWEwNDhlOWIzZmZlYjU0ZWYgPSAkKGA8ZGl2IGlkPSJodG1sXzc0MThiOTc0ZjBhMDQ5MDFhMDQ4ZTliM2ZmZWI1NGVmIiBzdHlsZT0id2lkdGg6IDEwMC4wJTsgaGVpZ2h0OiAxMDAuMCU7Ij5OYW1lOiBQRUNLIFBFTExBIENMT1ZFUiBESVRDSCBQcmVjaXA6IDEuMjk8L2Rpdj5gKVswXTsKICAgICAgICAgICAgcG9wdXBfNzk1ZmJmNDQ1NzU4NGUzMjk1YWVhN2VhOWU2ODAxMzAuc2V0Q29udGVudChodG1sXzc0MThiOTc0ZjBhMDQ5MDFhMDQ4ZTliM2ZmZWI1NGVmKTsKICAgICAgICAKCiAgICAgICAgbWFya2VyXzQzZTkwMWE2MGQzNzRmYmJiNjUxMDdiY2QwODJlZWI0LmJpbmRQb3B1cChwb3B1cF83OTVmYmY0NDU3NTg0ZTMyOTVhZWE3ZWE5ZTY4MDEzMCkKICAgICAgICA7CgogICAgICAgIAogICAgCiAgICAKICAgICAgICAgICAgdmFyIG1hcmtlcl8yOTdmZTI4ODEzMTg0MWY4ODg3YzI4NmI0MDViZGQ0MSA9IEwubWFya2VyKAogICAgICAgICAgICAgICAgWzM5Ljk0NzcwNCwgLTEwNS4zNTczMDhdLAogICAgICAgICAgICAgICAge30KICAgICAgICAgICAgKS5hZGRUbyhtYXJrZXJfY2x1c3Rlcl8zMTI3MmMzNTNkZDk0NWU2YTg1MjZlMjk4MTRmNTZiNyk7CiAgICAgICAgCiAgICAKICAgICAgICB2YXIgcG9wdXBfN2JkNjFiNDRmZDg2NGMxZWE5OWY4ZDViZmMwY2EyODUgPSBMLnBvcHVwKHsibWF4V2lkdGgiOiAiMTAwJSJ9KTsKCiAgICAgICAgCiAgICAgICAgICAgIHZhciBodG1sXzVjOGIyYmJhODhjNjQ5MDQ4ZDg5OTk2MDQ5MzU0NDMwID0gJChgPGRpdiBpZD0iaHRtbF81YzhiMmJiYTg4YzY0OTA0OGQ4OTk5NjA0OTM1NDQzMCIgc3R5bGU9IndpZHRoOiAxMDAuMCU7IGhlaWdodDogMTAwLjAlOyI+TmFtZTogR1JPU1MgUkVTRVJWT0lSICBQcmVjaXA6IDExMzY3LjAwPC9kaXY+YClbMF07CiAgICAgICAgICAgIHBvcHVwXzdiZDYxYjQ0ZmQ4NjRjMWVhOTlmOGQ1YmZjMGNhMjg1LnNldENvbnRlbnQoaHRtbF81YzhiMmJiYTg4YzY0OTA0OGQ4OTk5NjA0OTM1NDQzMCk7CiAgICAgICAgCgogICAgICAgIG1hcmtlcl8yOTdmZTI4ODEzMTg0MWY4ODg3YzI4NmI0MDViZGQ0MS5iaW5kUG9wdXAocG9wdXBfN2JkNjFiNDRmZDg2NGMxZWE5OWY4ZDViZmMwY2EyODUpCiAgICAgICAgOwoKICAgICAgICAKICAgIAo8L3NjcmlwdD4=" style="position:absolute;width:100%;height:100%;left:0;top:0;border:none !important;" allowfullscreen webkitallowfullscreen mozallowfullscreen></iframe></div></div>





<div class="notice--info" markdown="1">

## Additional Resources

* <a href="https://blog.datafiniti.co/4-reasons-you-should-use-json-instead-of-csv-2cac362f1943" target="_blank">Why you should use JSON instead of csv.</a>


* <a href="https://www.w3schools.com/js/js_json_intro.asp" target="_blank">W3schools JSON intro </a>

</div>

