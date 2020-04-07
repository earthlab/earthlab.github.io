---
layout: single
title: 'Programmatically Accessing Geospatial Data Using APIs'
excerpt: 'This lesson walks through the process of retrieving and manipulating surface water data housed in the Colorado Information Warehouse. These data are stored in JSON format with spatial x, y information that support mapping.'
authors: ['Leah Wasser', 'Max Joseph', 'Martha Morrissey', 'Jenny Palomino', 'Carson Farmer']
modified: 2020-04-01
category: [courses]
class-lesson: ['intro-APIs-python']
permalink: /courses/use-data-open-source-python/intro-to-apis/spatial-data-using-apis/
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
      'amount': '0.10',
      'station_type': 'Diversion',
      'wd': '5',
      'http_linkage': {'url': 'https://dwr.state.co.us/SurfaceWater/data/detail_graph.aspx?ID=ZWETURCO&MTYPE=DISCHRG'},
      'date_time': '2020-04-01T10:00:00.000',
      'county': 'BOULDER',
      'variable': 'DISCHRG',
      'stage': '0.04',
      'station_status': 'Active'},
     {'station_name': 'SAINT VRAIN CREEK AT LYONS, CO',
      'div': '1',
      'location': {'latitude': '40.220702',
       'needs_recoding': False,
       'longitude': '-105.26349'},
      'dwr_abbrev': 'SVCLYOCO',
      'data_source': 'Co. Division of Water Resources',
      'usgs_station_id': '06724000',
      'amount': '34.20',
      'station_type': 'Stream',
      'wd': '5',
      'http_linkage': {'url': 'https://dwr.state.co.us/SurfaceWater/data/detail_graph.aspx?ID=SVCLYOCO&MTYPE=DISCHRG'},
      'date_time': '2020-04-01T10:15:00.000',
      'county': 'BOULDER',
      'variable': 'DISCHRG',
      'stage': '2.95',
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
      <td>0.10</td>
      <td>Diversion</td>
      <td>5</td>
      <td>2020-04-01T10:00:00.000</td>
      <td>BOULDER</td>
      <td>DISCHRG</td>
      <td>0.04</td>
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
      <td>34.20</td>
      <td>Stream</td>
      <td>5</td>
      <td>2020-04-01T10:15:00.000</td>
      <td>BOULDER</td>
      <td>DISCHRG</td>
      <td>2.95</td>
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
      <td>2.76</td>
      <td>Diversion</td>
      <td>5</td>
      <td>2020-04-01T08:45:00.000</td>
      <td>BOULDER</td>
      <td>DISCHRG</td>
      <td>0.19</td>
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
      <td>PANAMA RESERVOIR OUTLET</td>
      <td>1</td>
      <td>PNMOUTCO</td>
      <td>Co. Division of Water Resources</td>
      <td>0.07</td>
      <td>Stream</td>
      <td>6</td>
      <td>2020-04-01T10:45:00.000</td>
      <td>BOULDER</td>
      <td>DISCHRG</td>
      <td>NaN</td>
      <td>Active</td>
      <td>40.087583</td>
      <td>False</td>
      <td>-105.072502</td>
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
      <td>2020-04-01T10:00:00.000</td>
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



    (57, 18)





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
      <td>0.10</td>
      <td>Diversion</td>
      <td>5</td>
      <td>2020-04-01T10:00:00.000</td>
      <td>BOULDER</td>
      <td>DISCHRG</td>
      <td>0.04</td>
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
      <td>34.20</td>
      <td>Stream</td>
      <td>5</td>
      <td>2020-04-01T10:15:00.000</td>
      <td>BOULDER</td>
      <td>DISCHRG</td>
      <td>2.95</td>
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
      <td>2.76</td>
      <td>Diversion</td>
      <td>5</td>
      <td>2020-04-01T08:45:00.000</td>
      <td>BOULDER</td>
      <td>DISCHRG</td>
      <td>0.19</td>
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
      <td>PANAMA RESERVOIR OUTLET</td>
      <td>1</td>
      <td>PNMOUTCO</td>
      <td>Co. Division of Water Resources</td>
      <td>0.07</td>
      <td>Stream</td>
      <td>6</td>
      <td>2020-04-01T10:45:00.000</td>
      <td>BOULDER</td>
      <td>DISCHRG</td>
      <td>NaN</td>
      <td>Active</td>
      <td>40.087583</td>
      <td>False</td>
      <td>-105.072502</td>
      <td>https://dwr.state.co.us/SurfaceWater/data/deta...</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>POINT (-105.07250 40.08758)</td>
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
      <td>2020-04-01T10:00:00.000</td>
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



<div style="width:100%;"><div style="position:relative;width:100%;height:0;padding-bottom:60%;"><iframe src="data:text/html;charset=utf-8;base64,PCFET0NUWVBFIGh0bWw+CjxoZWFkPiAgICAKICAgIDxtZXRhIGh0dHAtZXF1aXY9ImNvbnRlbnQtdHlwZSIgY29udGVudD0idGV4dC9odG1sOyBjaGFyc2V0PVVURi04IiAvPgogICAgCiAgICAgICAgPHNjcmlwdD4KICAgICAgICAgICAgTF9OT19UT1VDSCA9IGZhbHNlOwogICAgICAgICAgICBMX0RJU0FCTEVfM0QgPSBmYWxzZTsKICAgICAgICA8L3NjcmlwdD4KICAgIAogICAgPHNjcmlwdCBzcmM9Imh0dHBzOi8vY2RuLmpzZGVsaXZyLm5ldC9ucG0vbGVhZmxldEAxLjUuMS9kaXN0L2xlYWZsZXQuanMiPjwvc2NyaXB0PgogICAgPHNjcmlwdCBzcmM9Imh0dHBzOi8vY29kZS5qcXVlcnkuY29tL2pxdWVyeS0xLjEyLjQubWluLmpzIj48L3NjcmlwdD4KICAgIDxzY3JpcHQgc3JjPSJodHRwczovL21heGNkbi5ib290c3RyYXBjZG4uY29tL2Jvb3RzdHJhcC8zLjIuMC9qcy9ib290c3RyYXAubWluLmpzIj48L3NjcmlwdD4KICAgIDxzY3JpcHQgc3JjPSJodHRwczovL2NkbmpzLmNsb3VkZmxhcmUuY29tL2FqYXgvbGlicy9MZWFmbGV0LmF3ZXNvbWUtbWFya2Vycy8yLjAuMi9sZWFmbGV0LmF3ZXNvbWUtbWFya2Vycy5qcyI+PC9zY3JpcHQ+CiAgICA8bGluayByZWw9InN0eWxlc2hlZXQiIGhyZWY9Imh0dHBzOi8vY2RuLmpzZGVsaXZyLm5ldC9ucG0vbGVhZmxldEAxLjUuMS9kaXN0L2xlYWZsZXQuY3NzIi8+CiAgICA8bGluayByZWw9InN0eWxlc2hlZXQiIGhyZWY9Imh0dHBzOi8vbWF4Y2RuLmJvb3RzdHJhcGNkbi5jb20vYm9vdHN0cmFwLzMuMi4wL2Nzcy9ib290c3RyYXAubWluLmNzcyIvPgogICAgPGxpbmsgcmVsPSJzdHlsZXNoZWV0IiBocmVmPSJodHRwczovL21heGNkbi5ib290c3RyYXBjZG4uY29tL2Jvb3RzdHJhcC8zLjIuMC9jc3MvYm9vdHN0cmFwLXRoZW1lLm1pbi5jc3MiLz4KICAgIDxsaW5rIHJlbD0ic3R5bGVzaGVldCIgaHJlZj0iaHR0cHM6Ly9tYXhjZG4uYm9vdHN0cmFwY2RuLmNvbS9mb250LWF3ZXNvbWUvNC42LjMvY3NzL2ZvbnQtYXdlc29tZS5taW4uY3NzIi8+CiAgICA8bGluayByZWw9InN0eWxlc2hlZXQiIGhyZWY9Imh0dHBzOi8vY2RuanMuY2xvdWRmbGFyZS5jb20vYWpheC9saWJzL0xlYWZsZXQuYXdlc29tZS1tYXJrZXJzLzIuMC4yL2xlYWZsZXQuYXdlc29tZS1tYXJrZXJzLmNzcyIvPgogICAgPGxpbmsgcmVsPSJzdHlsZXNoZWV0IiBocmVmPSJodHRwczovL3Jhd2Nkbi5naXRoYWNrLmNvbS9weXRob24tdmlzdWFsaXphdGlvbi9mb2xpdW0vbWFzdGVyL2ZvbGl1bS90ZW1wbGF0ZXMvbGVhZmxldC5hd2Vzb21lLnJvdGF0ZS5jc3MiLz4KICAgIDxzdHlsZT5odG1sLCBib2R5IHt3aWR0aDogMTAwJTtoZWlnaHQ6IDEwMCU7bWFyZ2luOiAwO3BhZGRpbmc6IDA7fTwvc3R5bGU+CiAgICA8c3R5bGU+I21hcCB7cG9zaXRpb246YWJzb2x1dGU7dG9wOjA7Ym90dG9tOjA7cmlnaHQ6MDtsZWZ0OjA7fTwvc3R5bGU+CiAgICAKICAgICAgICAgICAgPG1ldGEgbmFtZT0idmlld3BvcnQiIGNvbnRlbnQ9IndpZHRoPWRldmljZS13aWR0aCwKICAgICAgICAgICAgICAgIGluaXRpYWwtc2NhbGU9MS4wLCBtYXhpbXVtLXNjYWxlPTEuMCwgdXNlci1zY2FsYWJsZT1ubyIgLz4KICAgICAgICAgICAgPHN0eWxlPgogICAgICAgICAgICAgICAgI21hcF82NTcxOTQ5YzViMTg0NmJmYjQ5ODlhZjZmNTdiZGFhNCB7CiAgICAgICAgICAgICAgICAgICAgcG9zaXRpb246IHJlbGF0aXZlOwogICAgICAgICAgICAgICAgICAgIHdpZHRoOiAxMDAuMCU7CiAgICAgICAgICAgICAgICAgICAgaGVpZ2h0OiAxMDAuMCU7CiAgICAgICAgICAgICAgICAgICAgbGVmdDogMC4wJTsKICAgICAgICAgICAgICAgICAgICB0b3A6IDAuMCU7CiAgICAgICAgICAgICAgICB9CiAgICAgICAgICAgIDwvc3R5bGU+CiAgICAgICAgCjwvaGVhZD4KPGJvZHk+ICAgIAogICAgCiAgICAgICAgICAgIDxkaXYgY2xhc3M9ImZvbGl1bS1tYXAiIGlkPSJtYXBfNjU3MTk0OWM1YjE4NDZiZmI0OTg5YWY2ZjU3YmRhYTQiID48L2Rpdj4KICAgICAgICAKPC9ib2R5Pgo8c2NyaXB0PiAgICAKICAgIAogICAgICAgICAgICB2YXIgbWFwXzY1NzE5NDljNWIxODQ2YmZiNDk4OWFmNmY1N2JkYWE0ID0gTC5tYXAoCiAgICAgICAgICAgICAgICAibWFwXzY1NzE5NDljNWIxODQ2YmZiNDk4OWFmNmY1N2JkYWE0IiwKICAgICAgICAgICAgICAgIHsKICAgICAgICAgICAgICAgICAgICBjZW50ZXI6IFs0MC4wMSwgLTEwNS4yN10sCiAgICAgICAgICAgICAgICAgICAgY3JzOiBMLkNSUy5FUFNHMzg1NywKICAgICAgICAgICAgICAgICAgICB6b29tOiAxMCwKICAgICAgICAgICAgICAgICAgICB6b29tQ29udHJvbDogdHJ1ZSwKICAgICAgICAgICAgICAgICAgICBwcmVmZXJDYW52YXM6IGZhbHNlLAogICAgICAgICAgICAgICAgfQogICAgICAgICAgICApOwoKICAgICAgICAgICAgCgogICAgICAgIAogICAgCiAgICAgICAgICAgIHZhciB0aWxlX2xheWVyX2E0YTY5YWI3NGQyZDQ5Mzc4OGNmNDJjNTA3MzA3YmQ0ID0gTC50aWxlTGF5ZXIoCiAgICAgICAgICAgICAgICAiaHR0cHM6Ly9jYXJ0b2RiLWJhc2VtYXBzLXtzfS5nbG9iYWwuc3NsLmZhc3RseS5uZXQvbGlnaHRfYWxsL3t6fS97eH0ve3l9LnBuZyIsCiAgICAgICAgICAgICAgICB7ImF0dHJpYnV0aW9uIjogIlx1MDAyNmNvcHk7IFx1MDAzY2EgaHJlZj1cImh0dHA6Ly93d3cub3BlbnN0cmVldG1hcC5vcmcvY29weXJpZ2h0XCJcdTAwM2VPcGVuU3RyZWV0TWFwXHUwMDNjL2FcdTAwM2UgY29udHJpYnV0b3JzIFx1MDAyNmNvcHk7IFx1MDAzY2EgaHJlZj1cImh0dHA6Ly9jYXJ0b2RiLmNvbS9hdHRyaWJ1dGlvbnNcIlx1MDAzZUNhcnRvREJcdTAwM2MvYVx1MDAzZSwgQ2FydG9EQiBcdTAwM2NhIGhyZWYgPVwiaHR0cDovL2NhcnRvZGIuY29tL2F0dHJpYnV0aW9uc1wiXHUwMDNlYXR0cmlidXRpb25zXHUwMDNjL2FcdTAwM2UiLCAiZGV0ZWN0UmV0aW5hIjogZmFsc2UsICJtYXhOYXRpdmVab29tIjogMTgsICJtYXhab29tIjogMTgsICJtaW5ab29tIjogMCwgIm5vV3JhcCI6IGZhbHNlLCAib3BhY2l0eSI6IDEsICJzdWJkb21haW5zIjogImFiYyIsICJ0bXMiOiBmYWxzZX0KICAgICAgICAgICAgKS5hZGRUbyhtYXBfNjU3MTk0OWM1YjE4NDZiZmI0OTg5YWY2ZjU3YmRhYTQpOwogICAgICAgIAogICAgCiAgICAgICAgZnVuY3Rpb24gZ2VvX2pzb25fY2E4Y2E2NTk0MmYzNDA3M2FhY2E3MDQ0ZjYzNzlkYmJfb25FYWNoRmVhdHVyZShmZWF0dXJlLCBsYXllcikgewogICAgICAgICAgICBsYXllci5vbih7CiAgICAgICAgICAgICAgICBjbGljazogZnVuY3Rpb24oZSkgewogICAgICAgICAgICAgICAgICAgIG1hcF82NTcxOTQ5YzViMTg0NmJmYjQ5ODlhZjZmNTdiZGFhNC5maXRCb3VuZHMoZS50YXJnZXQuZ2V0Qm91bmRzKCkpOwogICAgICAgICAgICAgICAgfQogICAgICAgICAgICB9KTsKICAgICAgICB9OwogICAgICAgIHZhciBnZW9fanNvbl9jYThjYTY1OTQyZjM0MDczYWFjYTcwNDRmNjM3OWRiYiA9IEwuZ2VvSnNvbihudWxsLCB7CiAgICAgICAgICAgICAgICBvbkVhY2hGZWF0dXJlOiBnZW9fanNvbl9jYThjYTY1OTQyZjM0MDczYWFjYTcwNDRmNjM3OWRiYl9vbkVhY2hGZWF0dXJlLAogICAgICAgICAgICAKICAgICAgICB9KTsKICAgICAgICBmdW5jdGlvbiBnZW9fanNvbl9jYThjYTY1OTQyZjM0MDczYWFjYTcwNDRmNjM3OWRiYl9hZGQgKGRhdGEpIHsKICAgICAgICAgICAgZ2VvX2pzb25fY2E4Y2E2NTk0MmYzNDA3M2FhY2E3MDQ0ZjYzNzlkYmIuYWRkRGF0YShkYXRhKQogICAgICAgICAgICAgICAgLmFkZFRvKG1hcF82NTcxOTQ5YzViMTg0NmJmYjQ5ODlhZjZmNTdiZGFhNCk7CiAgICAgICAgfQogICAgICAgICAgICBnZW9fanNvbl9jYThjYTY1OTQyZjM0MDczYWFjYTcwNDRmNjM3OWRiYl9hZGQoeyJiYm94IjogWy0xMDUuNTA0NDQsIDM5LjkzMTU5NywgLTEwNS4wNzI1MDIsIDQwLjI2MDgyN10sICJmZWF0dXJlcyI6IFt7ImJib3giOiBbLTEwNS4xODU3ODksIDQwLjE4NTAzMywgLTEwNS4xODU3ODksIDQwLjE4NTAzM10sICJnZW9tZXRyeSI6IHsiY29vcmRpbmF0ZXMiOiBbLTEwNS4xODU3ODksIDQwLjE4NTAzM10sICJ0eXBlIjogIlBvaW50In0sICJpZCI6ICIwIiwgInByb3BlcnRpZXMiOiB7ImFtb3VudCI6ICIwLjEwIiwgImNvdW50eSI6ICJCT1VMREVSIiwgImRhdGFfc291cmNlIjogIkNvb3BlcmF0aXZlIFByb2dyYW0gb2YgQ0RXUiwgTkNXQ0QgXHUwMDI2IFNWTEhXQ0QiLCAiZGF0ZV90aW1lIjogIjIwMjAtMDQtMDFUMTA6MDA6MDAuMDAwIiwgImRpdiI6ICIxIiwgImR3cl9hYmJyZXYiOiAiWldFVFVSQ08iLCAiZmxhZyI6IG51bGwsICJodHRwX2xpbmthZ2UudXJsIjogImh0dHBzOi8vZHdyLnN0YXRlLmNvLnVzL1N1cmZhY2VXYXRlci9kYXRhL2RldGFpbF9ncmFwaC5hc3B4P0lEPVpXRVRVUkNPXHUwMDI2TVRZUEU9RElTQ0hSRyIsICJsb2NhdGlvbi5sYXRpdHVkZSI6IDQwLjE4NTAzMywgImxvY2F0aW9uLmxvbmdpdHVkZSI6IC0xMDUuMTg1Nzg5LCAibG9jYXRpb24ubmVlZHNfcmVjb2RpbmciOiBmYWxzZSwgInN0YWdlIjogIjAuMDQiLCAic3RhdGlvbl9uYW1lIjogIlpXRUNLIEFORCBUVVJORVIgRElUQ0giLCAic3RhdGlvbl9zdGF0dXMiOiAiQWN0aXZlIiwgInN0YXRpb25fdHlwZSI6ICJEaXZlcnNpb24iLCAidXNnc19zdGF0aW9uX2lkIjogbnVsbCwgInZhcmlhYmxlIjogIkRJU0NIUkciLCAid2QiOiAiNSJ9LCAidHlwZSI6ICJGZWF0dXJlIn0sIHsiYmJveCI6IFstMTA1LjI2MzQ5LCA0MC4yMjA3MDIsIC0xMDUuMjYzNDksIDQwLjIyMDcwMl0sICJnZW9tZXRyeSI6IHsiY29vcmRpbmF0ZXMiOiBbLTEwNS4yNjM0OSwgNDAuMjIwNzAyXSwgInR5cGUiOiAiUG9pbnQifSwgImlkIjogIjEiLCAicHJvcGVydGllcyI6IHsiYW1vdW50IjogIjM0LjIwIiwgImNvdW50eSI6ICJCT1VMREVSIiwgImRhdGFfc291cmNlIjogIkNvLiBEaXZpc2lvbiBvZiBXYXRlciBSZXNvdXJjZXMiLCAiZGF0ZV90aW1lIjogIjIwMjAtMDQtMDFUMTA6MTU6MDAuMDAwIiwgImRpdiI6ICIxIiwgImR3cl9hYmJyZXYiOiAiU1ZDTFlPQ08iLCAiZmxhZyI6IG51bGwsICJodHRwX2xpbmthZ2UudXJsIjogImh0dHBzOi8vZHdyLnN0YXRlLmNvLnVzL1N1cmZhY2VXYXRlci9kYXRhL2RldGFpbF9ncmFwaC5hc3B4P0lEPVNWQ0xZT0NPXHUwMDI2TVRZUEU9RElTQ0hSRyIsICJsb2NhdGlvbi5sYXRpdHVkZSI6IDQwLjIyMDcwMiwgImxvY2F0aW9uLmxvbmdpdHVkZSI6IC0xMDUuMjYzNDksICJsb2NhdGlvbi5uZWVkc19yZWNvZGluZyI6IGZhbHNlLCAic3RhZ2UiOiAiMi45NSIsICJzdGF0aW9uX25hbWUiOiAiU0FJTlQgVlJBSU4gQ1JFRUsgQVQgTFlPTlMsIENPIiwgInN0YXRpb25fc3RhdHVzIjogIkFjdGl2ZSIsICJzdGF0aW9uX3R5cGUiOiAiU3RyZWFtIiwgInVzZ3Nfc3RhdGlvbl9pZCI6ICIwNjcyNDAwMCIsICJ2YXJpYWJsZSI6ICJESVNDSFJHIiwgIndkIjogIjUifSwgInR5cGUiOiAiRmVhdHVyZSJ9LCB7ImJib3giOiBbLTEwNS4yMDY1OTIsIDQwLjE5NjQyMiwgLTEwNS4yMDY1OTIsIDQwLjE5NjQyMl0sICJnZW9tZXRyeSI6IHsiY29vcmRpbmF0ZXMiOiBbLTEwNS4yMDY1OTIsIDQwLjE5NjQyMl0sICJ0eXBlIjogIlBvaW50In0sICJpZCI6ICIyIiwgInByb3BlcnRpZXMiOiB7ImFtb3VudCI6ICIyLjc2IiwgImNvdW50eSI6ICJCT1VMREVSIiwgImRhdGFfc291cmNlIjogIkNvb3BlcmF0aXZlIFByb2dyYW0gb2YgQ0RXUiwgTkNXQ0QgXHUwMDI2IFNWTEhXQ0QiLCAiZGF0ZV90aW1lIjogIjIwMjAtMDQtMDFUMDg6NDU6MDAuMDAwIiwgImRpdiI6ICIxIiwgImR3cl9hYmJyZXYiOiAiT0xJRElUQ08iLCAiZmxhZyI6IG51bGwsICJodHRwX2xpbmthZ2UudXJsIjogImh0dHBzOi8vZHdyLnN0YXRlLmNvLnVzL1N1cmZhY2VXYXRlci9kYXRhL2RldGFpbF9ncmFwaC5hc3B4P0lEPU9MSURJVENPXHUwMDI2TVRZUEU9RElTQ0hSRyIsICJsb2NhdGlvbi5sYXRpdHVkZSI6IDQwLjE5NjQyMiwgImxvY2F0aW9uLmxvbmdpdHVkZSI6IC0xMDUuMjA2NTkyLCAibG9jYXRpb24ubmVlZHNfcmVjb2RpbmciOiBmYWxzZSwgInN0YWdlIjogIjAuMTkiLCAic3RhdGlvbl9uYW1lIjogIk9MSUdBUkNIWSBESVRDSCBESVZFUlNJT04iLCAic3RhdGlvbl9zdGF0dXMiOiAiQWN0aXZlIiwgInN0YXRpb25fdHlwZSI6ICJEaXZlcnNpb24iLCAidXNnc19zdGF0aW9uX2lkIjogbnVsbCwgInZhcmlhYmxlIjogIkRJU0NIUkciLCAid2QiOiAiNSJ9LCAidHlwZSI6ICJGZWF0dXJlIn0sIHsiYmJveCI6IFstMTA1LjA3MjUwMiwgNDAuMDg3NTgzLCAtMTA1LjA3MjUwMiwgNDAuMDg3NTgzXSwgImdlb21ldHJ5IjogeyJjb29yZGluYXRlcyI6IFstMTA1LjA3MjUwMiwgNDAuMDg3NTgzXSwgInR5cGUiOiAiUG9pbnQifSwgImlkIjogIjMiLCAicHJvcGVydGllcyI6IHsiYW1vdW50IjogIjAuMDciLCAiY291bnR5IjogIkJPVUxERVIiLCAiZGF0YV9zb3VyY2UiOiAiQ28uIERpdmlzaW9uIG9mIFdhdGVyIFJlc291cmNlcyIsICJkYXRlX3RpbWUiOiAiMjAyMC0wNC0wMVQxMDo0NTowMC4wMDAiLCAiZGl2IjogIjEiLCAiZHdyX2FiYnJldiI6ICJQTk1PVVRDTyIsICJmbGFnIjogbnVsbCwgImh0dHBfbGlua2FnZS51cmwiOiAiaHR0cHM6Ly9kd3Iuc3RhdGUuY28udXMvU3VyZmFjZVdhdGVyL2RhdGEvZGV0YWlsX2dyYXBoLmFzcHg/SUQ9UE5NT1VUQ09cdTAwMjZNVFlQRT1ESVNDSFJHIiwgImxvY2F0aW9uLmxhdGl0dWRlIjogNDAuMDg3NTgzLCAibG9jYXRpb24ubG9uZ2l0dWRlIjogLTEwNS4wNzI1MDIsICJsb2NhdGlvbi5uZWVkc19yZWNvZGluZyI6IGZhbHNlLCAic3RhZ2UiOiBudWxsLCAic3RhdGlvbl9uYW1lIjogIlBBTkFNQSBSRVNFUlZPSVIgT1VUTEVUIiwgInN0YXRpb25fc3RhdHVzIjogIkFjdGl2ZSIsICJzdGF0aW9uX3R5cGUiOiAiU3RyZWFtIiwgInVzZ3Nfc3RhdGlvbl9pZCI6IG51bGwsICJ2YXJpYWJsZSI6ICJESVNDSFJHIiwgIndkIjogIjYifSwgInR5cGUiOiAiRmVhdHVyZSJ9LCB7ImJib3giOiBbLTEwNS4yMTAzOSwgNDAuMTkzNzU4LCAtMTA1LjIxMDM5LCA0MC4xOTM3NThdLCAiZ2VvbWV0cnkiOiB7ImNvb3JkaW5hdGVzIjogWy0xMDUuMjEwMzksIDQwLjE5Mzc1OF0sICJ0eXBlIjogIlBvaW50In0sICJpZCI6ICI0IiwgInByb3BlcnRpZXMiOiB7ImFtb3VudCI6ICIwLjAwIiwgImNvdW50eSI6ICJCT1VMREVSIiwgImRhdGFfc291cmNlIjogIkNvb3BlcmF0aXZlIFByb2dyYW0gb2YgQ0RXUiwgTkNXQ0QgXHUwMDI2IFNWTEhXQ0QiLCAiZGF0ZV90aW1lIjogIjIwMjAtMDQtMDFUMTA6MDA6MDAuMDAwIiwgImRpdiI6ICIxIiwgImR3cl9hYmJyZXYiOiAiQ0xPRElUQ08iLCAiZmxhZyI6IG51bGwsICJodHRwX2xpbmthZ2UudXJsIjogImh0dHBzOi8vZHdyLnN0YXRlLmNvLnVzL1N1cmZhY2VXYXRlci9kYXRhL2RldGFpbF9ncmFwaC5hc3B4P0lEPUNMT0RJVENPXHUwMDI2TVRZUEU9RElTQ0hSRyIsICJsb2NhdGlvbi5sYXRpdHVkZSI6IDQwLjE5Mzc1OCwgImxvY2F0aW9uLmxvbmdpdHVkZSI6IC0xMDUuMjEwMzksICJsb2NhdGlvbi5uZWVkc19yZWNvZGluZyI6IGZhbHNlLCAic3RhZ2UiOiBudWxsLCAic3RhdGlvbl9uYW1lIjogIkNMT1VHSCBBTkQgVFJVRSBESVRDSCIsICJzdGF0aW9uX3N0YXR1cyI6ICJBY3RpdmUiLCAic3RhdGlvbl90eXBlIjogIkRpdmVyc2lvbiIsICJ1c2dzX3N0YXRpb25faWQiOiBudWxsLCAidmFyaWFibGUiOiAiRElTQ0hSRyIsICJ3ZCI6ICI1In0sICJ0eXBlIjogIkZlYXR1cmUifSwgeyJiYm94IjogWy0xMDUuMzMwODQxLCA0MC4wMDYzOCwgLTEwNS4zMzA4NDEsIDQwLjAwNjM4XSwgImdlb21ldHJ5IjogeyJjb29yZGluYXRlcyI6IFstMTA1LjMzMDg0MSwgNDAuMDA2MzhdLCAidHlwZSI6ICJQb2ludCJ9LCAiaWQiOiAiNSIsICJwcm9wZXJ0aWVzIjogeyJhbW91bnQiOiAiMjMuOTAiLCAiY291bnR5IjogIkJPVUxERVIiLCAiZGF0YV9zb3VyY2UiOiAiQ28uIERpdmlzaW9uIG9mIFdhdGVyIFJlc291cmNlcyIsICJkYXRlX3RpbWUiOiAiMjAyMC0wNC0wMVQxMDoxNTowMC4wMDAiLCAiZGl2IjogIjEiLCAiZHdyX2FiYnJldiI6ICJCT0NPUk9DTyIsICJmbGFnIjogIkljZSIsICJodHRwX2xpbmthZ2UudXJsIjogImh0dHBzOi8vZHdyLnN0YXRlLmNvLnVzL1N1cmZhY2VXYXRlci9kYXRhL2RldGFpbF9ncmFwaC5hc3B4P0lEPUJPQ09ST0NPXHUwMDI2TVRZUEU9RElTQ0hSRyIsICJsb2NhdGlvbi5sYXRpdHVkZSI6IDQwLjAwNjM4LCAibG9jYXRpb24ubG9uZ2l0dWRlIjogLTEwNS4zMzA4NDEsICJsb2NhdGlvbi5uZWVkc19yZWNvZGluZyI6IGZhbHNlLCAic3RhZ2UiOiAiMS44OCIsICJzdGF0aW9uX25hbWUiOiAiQk9VTERFUiBDUkVFSyBORUFSIE9ST0RFTEwsIENPLiIsICJzdGF0aW9uX3N0YXR1cyI6ICJBY3RpdmUiLCAic3RhdGlvbl90eXBlIjogIlN0cmVhbSIsICJ1c2dzX3N0YXRpb25faWQiOiAiMDY3MjcwMDAiLCAidmFyaWFibGUiOiAiRElTQ0hSRyIsICJ3ZCI6ICI2In0sICJ0eXBlIjogIkZlYXR1cmUifSwgeyJiYm94IjogWy0xMDUuMjE4Nzc3LCA0MC4yMDQxOTMsIC0xMDUuMjE4Nzc3LCA0MC4yMDQxOTNdLCAiZ2VvbWV0cnkiOiB7ImNvb3JkaW5hdGVzIjogWy0xMDUuMjE4Nzc3LCA0MC4yMDQxOTNdLCAidHlwZSI6ICJQb2ludCJ9LCAiaWQiOiAiNiIsICJwcm9wZXJ0aWVzIjogeyJhbW91bnQiOiAiMC4wMCIsICJjb3VudHkiOiAiQk9VTERFUiIsICJkYXRhX3NvdXJjZSI6ICJDb29wZXJhdGl2ZSBQcm9ncmFtIG9mIENEV1IsIE5DV0NEIFx1MDAyNiBTVkxIV0NEIiwgImRhdGVfdGltZSI6ICIyMDIwLTA0LTAxVDEwOjAwOjAwLjAwMCIsICJkaXYiOiAiMSIsICJkd3JfYWJicmV2IjogIkxPTlNVUENPIiwgImZsYWciOiBudWxsLCAiaHR0cF9saW5rYWdlLnVybCI6ICJodHRwczovL2R3ci5zdGF0ZS5jby51cy9TdXJmYWNlV2F0ZXIvZGF0YS9kZXRhaWxfZ3JhcGguYXNweD9JRD1MT05TVVBDT1x1MDAyNk1UWVBFPURJU0NIUkciLCAibG9jYXRpb24ubGF0aXR1ZGUiOiA0MC4yMDQxOTMsICJsb2NhdGlvbi5sb25naXR1ZGUiOiAtMTA1LjIxODc3NywgImxvY2F0aW9uLm5lZWRzX3JlY29kaW5nIjogZmFsc2UsICJzdGFnZSI6IG51bGwsICJzdGF0aW9uX25hbWUiOiAiTE9OR01PTlQgU1VQUExZIERJVENIIiwgInN0YXRpb25fc3RhdHVzIjogIkFjdGl2ZSIsICJzdGF0aW9uX3R5cGUiOiAiRGl2ZXJzaW9uIiwgInVzZ3Nfc3RhdGlvbl9pZCI6IG51bGwsICJ2YXJpYWJsZSI6ICJESVNDSFJHIiwgIndkIjogIjUifSwgInR5cGUiOiAiRmVhdHVyZSJ9LCB7ImJib3giOiBbLTEwNS4xNzU4MTcsIDQwLjI1ODcyNiwgLTEwNS4xNzU4MTcsIDQwLjI1ODcyNl0sICJnZW9tZXRyeSI6IHsiY29vcmRpbmF0ZXMiOiBbLTEwNS4xNzU4MTcsIDQwLjI1ODcyNl0sICJ0eXBlIjogIlBvaW50In0sICJpZCI6ICI3IiwgInByb3BlcnRpZXMiOiB7ImFtb3VudCI6ICI0LjA3IiwgImNvdW50eSI6ICJCT1VMREVSIiwgImRhdGFfc291cmNlIjogIkNvLiBEaXZpc2lvbiBvZiBXYXRlciBSZXNvdXJjZXMiLCAiZGF0ZV90aW1lIjogIjIwMjAtMDQtMDFUMTA6MTU6MDAuMDAwIiwgImRpdiI6ICIxIiwgImR3cl9hYmJyZXYiOiAiQk9VQllQQ08iLCAiZmxhZyI6IG51bGwsICJodHRwX2xpbmthZ2UudXJsIjogImh0dHBzOi8vZHdyLnN0YXRlLmNvLnVzL1N1cmZhY2VXYXRlci9kYXRhL2RldGFpbF9ncmFwaC5hc3B4P0lEPUJPVUJZUENPXHUwMDI2TVRZUEU9RElTQ0hSRyIsICJsb2NhdGlvbi5sYXRpdHVkZSI6IDQwLjI1ODcyNiwgImxvY2F0aW9uLmxvbmdpdHVkZSI6IC0xMDUuMTc1ODE3LCAibG9jYXRpb24ubmVlZHNfcmVjb2RpbmciOiBmYWxzZSwgInN0YWdlIjogIjAuNDEiLCAic3RhdGlvbl9uYW1lIjogIkJPVUxERVItTEFSSU1FUiBCWVBBU1MgTkVBUiBCRVJUSE9VRCIsICJzdGF0aW9uX3N0YXR1cyI6ICJBY3RpdmUiLCAic3RhdGlvbl90eXBlIjogIkRpdmVyc2lvbiIsICJ1c2dzX3N0YXRpb25faWQiOiBudWxsLCAidmFyaWFibGUiOiAiRElTQ0hSRyIsICJ3ZCI6ICI0In0sICJ0eXBlIjogIkZlYXR1cmUifSwgeyJiYm94IjogWy0xMDUuMjA2Mzg2LCA0MC4yNTgwMzgsIC0xMDUuMjA2Mzg2LCA0MC4yNTgwMzhdLCAiZ2VvbWV0cnkiOiB7ImNvb3JkaW5hdGVzIjogWy0xMDUuMjA2Mzg2LCA0MC4yNTgwMzhdLCAidHlwZSI6ICJQb2ludCJ9LCAiaWQiOiAiOCIsICJwcm9wZXJ0aWVzIjogeyJhbW91bnQiOiAiMTMuMDAiLCAiY291bnR5IjogIkJPVUxERVIiLCAiZGF0YV9zb3VyY2UiOiAiQ28uIERpdmlzaW9uIG9mIFdhdGVyIFJlc291cmNlcyIsICJkYXRlX3RpbWUiOiAiMjAyMC0wNC0wMVQxMDozMDowMC4wMDAiLCAiZGl2IjogIjEiLCAiZHdyX2FiYnJldiI6ICJMVENBTllDTyIsICJmbGFnIjogbnVsbCwgImh0dHBfbGlua2FnZS51cmwiOiAiaHR0cHM6Ly9kd3Iuc3RhdGUuY28udXMvU3VyZmFjZVdhdGVyL2RhdGEvZGV0YWlsX2dyYXBoLmFzcHg/SUQ9TFRDQU5ZQ09cdTAwMjZNVFlQRT1ESVNDSFJHIiwgImxvY2F0aW9uLmxhdGl0dWRlIjogNDAuMjU4MDM4LCAibG9jYXRpb24ubG9uZ2l0dWRlIjogLTEwNS4yMDYzODYsICJsb2NhdGlvbi5uZWVkc19yZWNvZGluZyI6IGZhbHNlLCAic3RhZ2UiOiAiMS40OCIsICJzdGF0aW9uX25hbWUiOiAiTElUVExFIFRIT01QU09OIFJJVkVSIEFUIENBTllPTiBNT1VUSCBORUFSIEJFUlRIT1VEIiwgInN0YXRpb25fc3RhdHVzIjogIkFjdGl2ZSIsICJzdGF0aW9uX3R5cGUiOiAiU3RyZWFtIiwgInVzZ3Nfc3RhdGlvbl9pZCI6IG51bGwsICJ2YXJpYWJsZSI6ICJESVNDSFJHIiwgIndkIjogIjQifSwgInR5cGUiOiAiRmVhdHVyZSJ9LCB7ImJib3giOiBbLTEwNS4xNjc2MjIsIDQwLjE3MjkyNSwgLTEwNS4xNjc2MjIsIDQwLjE3MjkyNV0sICJnZW9tZXRyeSI6IHsiY29vcmRpbmF0ZXMiOiBbLTEwNS4xNjc2MjIsIDQwLjE3MjkyNV0sICJ0eXBlIjogIlBvaW50In0sICJpZCI6ICI5IiwgInByb3BlcnRpZXMiOiB7ImFtb3VudCI6ICIwLjAwIiwgImNvdW50eSI6ICJCT1VMREVSIiwgImRhdGFfc291cmNlIjogIkNvb3BlcmF0aXZlIFNEUiBQcm9ncmFtIG9mIENEV1IgXHUwMDI2IE5DV0NEIiwgImRhdGVfdGltZSI6ICIyMDIwLTA0LTAxVDEwOjAwOjAwLjAwMCIsICJkaXYiOiAiMSIsICJkd3JfYWJicmV2IjogIk5PUk1VVENPIiwgImZsYWciOiBudWxsLCAiaHR0cF9saW5rYWdlLnVybCI6ICJodHRwczovL2R3ci5zdGF0ZS5jby51cy9TdXJmYWNlV2F0ZXIvZGF0YS9kZXRhaWxfZ3JhcGguYXNweD9JRD1OT1JNVVRDT1x1MDAyNk1UWVBFPURJU0NIUkciLCAibG9jYXRpb24ubGF0aXR1ZGUiOiA0MC4xNzI5MjUsICJsb2NhdGlvbi5sb25naXR1ZGUiOiAtMTA1LjE2NzYyMiwgImxvY2F0aW9uLm5lZWRzX3JlY29kaW5nIjogZmFsc2UsICJzdGFnZSI6IG51bGwsICJzdGF0aW9uX25hbWUiOiAiTk9SVEhXRVNUIE1VVFVBTCBESVRDSCIsICJzdGF0aW9uX3N0YXR1cyI6ICJBY3RpdmUiLCAic3RhdGlvbl90eXBlIjogIkRpdmVyc2lvbiIsICJ1c2dzX3N0YXRpb25faWQiOiBudWxsLCAidmFyaWFibGUiOiAiRElTQ0hSRyIsICJ3ZCI6ICI1In0sICJ0eXBlIjogIkZlYXR1cmUifSwgeyJiYm94IjogWy0xMDUuMTMwODE5LCA0MC4xMzQyNzgsIC0xMDUuMTMwODE5LCA0MC4xMzQyNzhdLCAiZ2VvbWV0cnkiOiB7ImNvb3JkaW5hdGVzIjogWy0xMDUuMTMwODE5LCA0MC4xMzQyNzhdLCAidHlwZSI6ICJQb2ludCJ9LCAiaWQiOiAiMTAiLCAicHJvcGVydGllcyI6IHsiYW1vdW50IjogIjMuODkiLCAiY291bnR5IjogIkJPVUxERVIiLCAiZGF0YV9zb3VyY2UiOiAiVS5TLiBHZW9sb2dpY2FsIFN1cnZleSIsICJkYXRlX3RpbWUiOiAiMjAyMC0wNC0wMVQxMDoxMDowMC4wMDAiLCAiZGl2IjogIjEiLCAiZHdyX2FiYnJldiI6ICJMRUZUSE9DTyIsICJmbGFnIjogbnVsbCwgImh0dHBfbGlua2FnZS51cmwiOiAiaHR0cHM6Ly93YXRlcmRhdGEudXNncy5nb3Yvbndpcy91dj8wNjcyNDk3MCIsICJsb2NhdGlvbi5sYXRpdHVkZSI6IDQwLjEzNDI3OCwgImxvY2F0aW9uLmxvbmdpdHVkZSI6IC0xMDUuMTMwODE5LCAibG9jYXRpb24ubmVlZHNfcmVjb2RpbmciOiBmYWxzZSwgInN0YWdlIjogbnVsbCwgInN0YXRpb25fbmFtZSI6ICJMRUZUIEhBTkQgQ1JFRUsgQVQgSE9WRVIgUk9BRCBORUFSIExPTkdNT05ULCBDTyIsICJzdGF0aW9uX3N0YXR1cyI6ICJBY3RpdmUiLCAic3RhdGlvbl90eXBlIjogIlN0cmVhbSIsICJ1c2dzX3N0YXRpb25faWQiOiAiMDY3MjQ5NzAiLCAidmFyaWFibGUiOiAiRElTQ0hSRyIsICJ3ZCI6ICI1In0sICJ0eXBlIjogIkZlYXR1cmUifSwgeyJiYm94IjogWy0xMDUuMjE4Njc3LCAzOS45ODYxNjksIC0xMDUuMjE4Njc3LCAzOS45ODYxNjldLCAiZ2VvbWV0cnkiOiB7ImNvb3JkaW5hdGVzIjogWy0xMDUuMjE4Njc3LCAzOS45ODYxNjldLCAidHlwZSI6ICJQb2ludCJ9LCAiaWQiOiAiMTEiLCAicHJvcGVydGllcyI6IHsiYW1vdW50IjogIjAuMDAiLCAiY291bnR5IjogIkJPVUxERVIiLCAiZGF0YV9zb3VyY2UiOiAiQ29vcGVyYXRpdmUgUHJvZ3JhbSBvZiBDRFdSLCBOQ1dDRCBcdTAwMjYgTFNQV0NEIiwgImRhdGVfdGltZSI6ICIyMDIwLTA0LTAxVDA5OjAwOjAwLjAwMCIsICJkaXYiOiAiMSIsICJkd3JfYWJicmV2IjogIkRSWUNBUkNPIiwgImZsYWciOiBudWxsLCAiaHR0cF9saW5rYWdlLnVybCI6ICJodHRwczovL2R3ci5zdGF0ZS5jby51cy9TdXJmYWNlV2F0ZXIvZGF0YS9kZXRhaWxfZ3JhcGguYXNweD9JRD1EUllDQVJDT1x1MDAyNk1UWVBFPURJU0NIUkciLCAibG9jYXRpb24ubGF0aXR1ZGUiOiAzOS45ODYxNjksICJsb2NhdGlvbi5sb25naXR1ZGUiOiAtMTA1LjIxODY3NywgImxvY2F0aW9uLm5lZWRzX3JlY29kaW5nIjogZmFsc2UsICJzdGFnZSI6IG51bGwsICJzdGF0aW9uX25hbWUiOiAiRFJZIENSRUVLIENBUlJJRVIiLCAic3RhdGlvbl9zdGF0dXMiOiAiQWN0aXZlIiwgInN0YXRpb25fdHlwZSI6ICJEaXZlcnNpb24iLCAidXNnc19zdGF0aW9uX2lkIjogbnVsbCwgInZhcmlhYmxlIjogIkRJU0NIUkciLCAid2QiOiAiNiJ9LCAidHlwZSI6ICJGZWF0dXJlIn0sIHsiYmJveCI6IFstMTA1LjMwNDk5LCAzOS45MzE1OTcsIC0xMDUuMzA0OTksIDM5LjkzMTU5N10sICJnZW9tZXRyeSI6IHsiY29vcmRpbmF0ZXMiOiBbLTEwNS4zMDQ5OSwgMzkuOTMxNTk3XSwgInR5cGUiOiAiUG9pbnQifSwgImlkIjogIjEyIiwgInByb3BlcnRpZXMiOiB7ImFtb3VudCI6ICIxOC40MCIsICJjb3VudHkiOiAiQk9VTERFUiIsICJkYXRhX3NvdXJjZSI6ICJDby4gRGl2aXNpb24gb2YgV2F0ZXIgUmVzb3VyY2VzIiwgImRhdGVfdGltZSI6ICIyMDIwLTA0LTAxVDEwOjE1OjAwLjAwMCIsICJkaXYiOiAiMSIsICJkd3JfYWJicmV2IjogIkJPQ0VMU0NPIiwgImZsYWciOiBudWxsLCAiaHR0cF9saW5rYWdlLnVybCI6ICJodHRwczovL2R3ci5zdGF0ZS5jby51cy9TdXJmYWNlV2F0ZXIvZGF0YS9kZXRhaWxfZ3JhcGguYXNweD9JRD1CT0NFTFNDT1x1MDAyNk1UWVBFPURJU0NIUkciLCAibG9jYXRpb24ubGF0aXR1ZGUiOiAzOS45MzE1OTcsICJsb2NhdGlvbi5sb25naXR1ZGUiOiAtMTA1LjMwNDk5LCAibG9jYXRpb24ubmVlZHNfcmVjb2RpbmciOiBmYWxzZSwgInN0YWdlIjogIjIuMjUiLCAic3RhdGlvbl9uYW1lIjogIlNPVVRIIEJPVUxERVIgQ1JFRUsgTkVBUiBFTERPUkFETyBTUFJJTkdTLCBDTy4iLCAic3RhdGlvbl9zdGF0dXMiOiAiQWN0aXZlIiwgInN0YXRpb25fdHlwZSI6ICJTdHJlYW0iLCAidXNnc19zdGF0aW9uX2lkIjogbnVsbCwgInZhcmlhYmxlIjogIkRJU0NIUkciLCAid2QiOiAiNiJ9LCAidHlwZSI6ICJGZWF0dXJlIn0sIHsiYmJveCI6IFstMTA1LjE2ODQ3MSwgNDAuMTYwNzA1LCAtMTA1LjE2ODQ3MSwgNDAuMTYwNzA1XSwgImdlb21ldHJ5IjogeyJjb29yZGluYXRlcyI6IFstMTA1LjE2ODQ3MSwgNDAuMTYwNzA1XSwgInR5cGUiOiAiUG9pbnQifSwgImlkIjogIjEzIiwgInByb3BlcnRpZXMiOiB7ImFtb3VudCI6ICIwLjAwIiwgImNvdW50eSI6ICJCT1VMREVSIiwgImRhdGFfc291cmNlIjogIkNvLiBEaXZpc2lvbiBvZiBXYXRlciBSZXNvdXJjZXMiLCAiZGF0ZV90aW1lIjogIjIwMjAtMDQtMDFUMDk6NDU6MDAuMDAwIiwgImRpdiI6ICIxIiwgImR3cl9hYmJyZXYiOiAiUEVDUlROQ08iLCAiZmxhZyI6IG51bGwsICJodHRwX2xpbmthZ2UudXJsIjogImh0dHBzOi8vZHdyLnN0YXRlLmNvLnVzL1N1cmZhY2VXYXRlci9kYXRhL2RldGFpbF9ncmFwaC5hc3B4P0lEPVBFQ1JUTkNPXHUwMDI2TVRZUEU9RElTQ0hSRyIsICJsb2NhdGlvbi5sYXRpdHVkZSI6IDQwLjE2MDcwNSwgImxvY2F0aW9uLmxvbmdpdHVkZSI6IC0xMDUuMTY4NDcxLCAibG9jYXRpb24ubmVlZHNfcmVjb2RpbmciOiBmYWxzZSwgInN0YWdlIjogbnVsbCwgInN0YXRpb25fbmFtZSI6ICJQRUNLLVBFTExBIEFVR01FTlRBVElPTiBSRVRVUk4iLCAic3RhdGlvbl9zdGF0dXMiOiAiQWN0aXZlIiwgInN0YXRpb25fdHlwZSI6ICJEaXZlcnNpb24iLCAidXNnc19zdGF0aW9uX2lkIjogbnVsbCwgInZhcmlhYmxlIjogIkRJU0NIUkciLCAid2QiOiAiNSJ9LCAidHlwZSI6ICJGZWF0dXJlIn0sIHsiYmJveCI6IFstMTA1LjIyMjYzOSwgNDAuMTk5MzIxLCAtMTA1LjIyMjYzOSwgNDAuMTk5MzIxXSwgImdlb21ldHJ5IjogeyJjb29yZGluYXRlcyI6IFstMTA1LjIyMjYzOSwgNDAuMTk5MzIxXSwgInR5cGUiOiAiUG9pbnQifSwgImlkIjogIjE0IiwgInByb3BlcnRpZXMiOiB7ImFtb3VudCI6ICIwLjAwIiwgImNvdW50eSI6ICJCT1VMREVSIiwgImRhdGFfc291cmNlIjogIkNvb3BlcmF0aXZlIFByb2dyYW0gb2YgQ0RXUiwgTkNXQ0QgXHUwMDI2IFNWTEhXQ0QiLCAiZGF0ZV90aW1lIjogIjIwMjAtMDQtMDFUMDk6NDU6MDAuMDAwIiwgImRpdiI6ICIxIiwgImR3cl9hYmJyZXYiOiAiR09ESVQxQ08iLCAiZmxhZyI6IG51bGwsICJodHRwX2xpbmthZ2UudXJsIjogImh0dHBzOi8vZHdyLnN0YXRlLmNvLnVzL1N1cmZhY2VXYXRlci9kYXRhL2RldGFpbF9ncmFwaC5hc3B4P0lEPUdPRElUMUNPXHUwMDI2TVRZUEU9RElTQ0hSRyIsICJsb2NhdGlvbi5sYXRpdHVkZSI6IDQwLjE5OTMyMSwgImxvY2F0aW9uLmxvbmdpdHVkZSI6IC0xMDUuMjIyNjM5LCAibG9jYXRpb24ubmVlZHNfcmVjb2RpbmciOiBmYWxzZSwgInN0YWdlIjogbnVsbCwgInN0YXRpb25fbmFtZSI6ICJHT1NTIERJVENIIDEiLCAic3RhdGlvbl9zdGF0dXMiOiAiQWN0aXZlIiwgInN0YXRpb25fdHlwZSI6ICJEaXZlcnNpb24iLCAidXNnc19zdGF0aW9uX2lkIjogbnVsbCwgInZhcmlhYmxlIjogIkRJU0NIUkciLCAid2QiOiAiNSJ9LCAidHlwZSI6ICJGZWF0dXJlIn0sIHsiYmJveCI6IFstMTA1LjIxMDQyNCwgNDAuMTkzMjgsIC0xMDUuMjEwNDI0LCA0MC4xOTMyOF0sICJnZW9tZXRyeSI6IHsiY29vcmRpbmF0ZXMiOiBbLTEwNS4yMTA0MjQsIDQwLjE5MzI4XSwgInR5cGUiOiAiUG9pbnQifSwgImlkIjogIjE1IiwgInByb3BlcnRpZXMiOiB7ImFtb3VudCI6ICIwLjAwIiwgImNvdW50eSI6ICJCT1VMREVSIiwgImRhdGFfc291cmNlIjogIkNvb3BlcmF0aXZlIFByb2dyYW0gb2YgQ0RXUiwgTkNXQ0QgXHUwMDI2IFNWTEhXQ0QiLCAiZGF0ZV90aW1lIjogIjIwMjAtMDQtMDFUMTA6MDA6MDAuMDAwIiwgImRpdiI6ICIxIiwgImR3cl9hYmJyZXYiOiAiV0VCRElUQ08iLCAiZmxhZyI6IG51bGwsICJodHRwX2xpbmthZ2UudXJsIjogImh0dHBzOi8vZHdyLnN0YXRlLmNvLnVzL1N1cmZhY2VXYXRlci9kYXRhL2RldGFpbF9ncmFwaC5hc3B4P0lEPVdFQkRJVENPXHUwMDI2TVRZUEU9RElTQ0hSRyIsICJsb2NhdGlvbi5sYXRpdHVkZSI6IDQwLjE5MzI4LCAibG9jYXRpb24ubG9uZ2l0dWRlIjogLTEwNS4yMTA0MjQsICJsb2NhdGlvbi5uZWVkc19yZWNvZGluZyI6IGZhbHNlLCAic3RhZ2UiOiBudWxsLCAic3RhdGlvbl9uYW1lIjogIldFQlNURVIgTUNDQVNMSU4gRElUQ0giLCAic3RhdGlvbl9zdGF0dXMiOiAiQWN0aXZlIiwgInN0YXRpb25fdHlwZSI6ICJEaXZlcnNpb24iLCAidXNnc19zdGF0aW9uX2lkIjogbnVsbCwgInZhcmlhYmxlIjogIkRJU0NIUkciLCAid2QiOiAiNSJ9LCAidHlwZSI6ICJGZWF0dXJlIn0sIHsiYmJveCI6IFstMTA1LjIyMDQ3NywgMzkuOTg4NDgxLCAtMTA1LjIyMDQ3NywgMzkuOTg4NDgxXSwgImdlb21ldHJ5IjogeyJjb29yZGluYXRlcyI6IFstMTA1LjIyMDQ3NywgMzkuOTg4NDgxXSwgInR5cGUiOiAiUG9pbnQifSwgImlkIjogIjE2IiwgInByb3BlcnRpZXMiOiB7ImFtb3VudCI6ICIwLjAwIiwgImNvdW50eSI6ICJCT1VMREVSIiwgImRhdGFfc291cmNlIjogIkNvLiBEaXZpc2lvbiBvZiBXYXRlciBSZXNvdXJjZXMiLCAiZGF0ZV90aW1lIjogIjIwMjAtMDQtMDFUMTA6NDU6MDAuMDAwIiwgImRpdiI6ICIxIiwgImR3cl9hYmJyZXYiOiAiSE9XRElUQ08iLCAiZmxhZyI6IG51bGwsICJodHRwX2xpbmthZ2UudXJsIjogImh0dHBzOi8vZHdyLnN0YXRlLmNvLnVzL1N1cmZhY2VXYXRlci9kYXRhL2RldGFpbF9ncmFwaC5hc3B4P0lEPUhPV0RJVENPXHUwMDI2TVRZUEU9RElTQ0hSRyIsICJsb2NhdGlvbi5sYXRpdHVkZSI6IDM5Ljk4ODQ4MSwgImxvY2F0aW9uLmxvbmdpdHVkZSI6IC0xMDUuMjIwNDc3LCAibG9jYXRpb24ubmVlZHNfcmVjb2RpbmciOiBmYWxzZSwgInN0YWdlIjogbnVsbCwgInN0YXRpb25fbmFtZSI6ICJIT1dBUkQgRElUQ0giLCAic3RhdGlvbl9zdGF0dXMiOiAiQWN0aXZlIiwgInN0YXRpb25fdHlwZSI6ICJEaXZlcnNpb24iLCAidXNnc19zdGF0aW9uX2lkIjogbnVsbCwgInZhcmlhYmxlIjogIkRJU0NIUkciLCAid2QiOiAiNiJ9LCAidHlwZSI6ICJGZWF0dXJlIn0sIHsiYmJveCI6IFstMTA1LjM2NTM2NSwgNDAuMjE2MjYzLCAtMTA1LjM2NTM2NSwgNDAuMjE2MjYzXSwgImdlb21ldHJ5IjogeyJjb29yZGluYXRlcyI6IFstMTA1LjM2NTM2NSwgNDAuMjE2MjYzXSwgInR5cGUiOiAiUG9pbnQifSwgImlkIjogIjE3IiwgInByb3BlcnRpZXMiOiB7ImFtb3VudCI6ICIxMjkxMS4wMCIsICJjb3VudHkiOiAiQk9VTERFUiIsICJkYXRhX3NvdXJjZSI6ICJDby4gRGl2aXNpb24gb2YgV2F0ZXIgUmVzb3VyY2VzIiwgImRhdGVfdGltZSI6ICIyMDIwLTA0LTAxVDEwOjQ1OjAwLjAwMCIsICJkaXYiOiAiMSIsICJkd3JfYWJicmV2IjogIkJSS0RBTUNPIiwgImZsYWciOiBudWxsLCAiaHR0cF9saW5rYWdlLnVybCI6ICJodHRwczovL2R3ci5zdGF0ZS5jby51cy9TdXJmYWNlV2F0ZXIvZGF0YS9kZXRhaWxfZ3JhcGguYXNweD9JRD1CUktEQU1DT1x1MDAyNk1UWVBFPVNUT1JBR0UiLCAibG9jYXRpb24ubGF0aXR1ZGUiOiA0MC4yMTYyNjMsICJsb2NhdGlvbi5sb25naXR1ZGUiOiAtMTA1LjM2NTM2NSwgImxvY2F0aW9uLm5lZWRzX3JlY29kaW5nIjogZmFsc2UsICJzdGFnZSI6ICI2Mzg0LjE3IiwgInN0YXRpb25fbmFtZSI6ICJCVVRUT05ST0NLIChSQUxQSCBQUklDRSkgUkVTRVJWT0lSIiwgInN0YXRpb25fc3RhdHVzIjogIkFjdGl2ZSIsICJzdGF0aW9uX3R5cGUiOiAiUmVzZXJ2b2lyIiwgInVzZ3Nfc3RhdGlvbl9pZCI6IG51bGwsICJ2YXJpYWJsZSI6ICJTVE9SQUdFIiwgIndkIjogIjUifSwgInR5cGUiOiAiRmVhdHVyZSJ9LCB7ImJib3giOiBbLTEwNS4yMDk1LCA0MC4yNTU3NzYsIC0xMDUuMjA5NSwgNDAuMjU1Nzc2XSwgImdlb21ldHJ5IjogeyJjb29yZGluYXRlcyI6IFstMTA1LjIwOTUsIDQwLjI1NTc3Nl0sICJ0eXBlIjogIlBvaW50In0sICJpZCI6ICIxOCIsICJwcm9wZXJ0aWVzIjogeyJhbW91bnQiOiAiMC4xMCIsICJjb3VudHkiOiAiQk9VTERFUiIsICJkYXRhX3NvdXJjZSI6ICJOb3J0aGVybiBDb2xvcmFkbyBXYXRlciBDb25zZXJ2YW5jeSBEaXN0cmljdCIsICJkYXRlX3RpbWUiOiAiMjAyMC0wNC0wMVQxMDowMDowMC4wMDAiLCAiZGl2IjogIjEiLCAiZHdyX2FiYnJldiI6ICJMSVRUSDJDTyIsICJmbGFnIjogbnVsbCwgImh0dHBfbGlua2FnZS51cmwiOiAiaHR0cDovL3d3dy5ub3J0aGVybndhdGVyLm9yZy9XYXRlclByb2plY3RzL0Vhc3RTbG9wZVdhdGVyRGF0YS5hc3B4IiwgImxvY2F0aW9uLmxhdGl0dWRlIjogNDAuMjU1Nzc2LCAibG9jYXRpb24ubG9uZ2l0dWRlIjogLTEwNS4yMDk1LCAibG9jYXRpb24ubmVlZHNfcmVjb2RpbmciOiBmYWxzZSwgInN0YWdlIjogIjAuMTAiLCAic3RhdGlvbl9uYW1lIjogIkxJVFRMRSBUSE9NUFNPTiAjMiBESVRDSCIsICJzdGF0aW9uX3N0YXR1cyI6ICJBY3RpdmUiLCAic3RhdGlvbl90eXBlIjogIkRpdmVyc2lvbiIsICJ1c2dzX3N0YXRpb25faWQiOiAiRVMxOTAwIiwgInZhcmlhYmxlIjogIkRJU0NIUkciLCAid2QiOiAiNCJ9LCAidHlwZSI6ICJGZWF0dXJlIn0sIHsiYmJveCI6IFstMTA1LjE2NDM5NywgNDAuMjU3ODQ0LCAtMTA1LjE2NDM5NywgNDAuMjU3ODQ0XSwgImdlb21ldHJ5IjogeyJjb29yZGluYXRlcyI6IFstMTA1LjE2NDM5NywgNDAuMjU3ODQ0XSwgInR5cGUiOiAiUG9pbnQifSwgImlkIjogIjE5IiwgInByb3BlcnRpZXMiOiB7ImFtb3VudCI6ICIwLjAwIiwgImNvdW50eSI6ICJCT1VMREVSIiwgImRhdGFfc291cmNlIjogIkNvb3BlcmF0aXZlIFNEUiBQcm9ncmFtIG9mIENEV1IgXHUwMDI2IE5DV0NEIiwgImRhdGVfdGltZSI6ICIyMDIwLTA0LTAxVDEwOjAwOjAwLjAwMCIsICJkaXYiOiAiMSIsICJkd3JfYWJicmV2IjogIkJMV0RJVENPIiwgImZsYWciOiBudWxsLCAiaHR0cF9saW5rYWdlLnVybCI6ICJodHRwczovL2R3ci5zdGF0ZS5jby51cy9TdXJmYWNlV2F0ZXIvZGF0YS9kZXRhaWxfZ3JhcGguYXNweD9JRD1CTFdESVRDT1x1MDAyNk1UWVBFPURJU0NIUkciLCAibG9jYXRpb24ubGF0aXR1ZGUiOiA0MC4yNTc4NDQsICJsb2NhdGlvbi5sb25naXR1ZGUiOiAtMTA1LjE2NDM5NywgImxvY2F0aW9uLm5lZWRzX3JlY29kaW5nIjogZmFsc2UsICJzdGFnZSI6IG51bGwsICJzdGF0aW9uX25hbWUiOiAiQkxPV0VSIERJVENIIiwgInN0YXRpb25fc3RhdHVzIjogIkFjdGl2ZSIsICJzdGF0aW9uX3R5cGUiOiAiRGl2ZXJzaW9uIiwgInVzZ3Nfc3RhdGlvbl9pZCI6IG51bGwsICJ2YXJpYWJsZSI6ICJESVNDSFJHIiwgIndkIjogIjQifSwgInR5cGUiOiAiRmVhdHVyZSJ9LCB7ImJib3giOiBbLTEwNS4xNzg4NzUsIDQwLjA1MTY1MiwgLTEwNS4xNzg4NzUsIDQwLjA1MTY1Ml0sICJnZW9tZXRyeSI6IHsiY29vcmRpbmF0ZXMiOiBbLTEwNS4xNzg4NzUsIDQwLjA1MTY1Ml0sICJ0eXBlIjogIlBvaW50In0sICJpZCI6ICIyMCIsICJwcm9wZXJ0aWVzIjogeyJhbW91bnQiOiAiMTcuNjAiLCAiY291bnR5IjogIkJPVUxERVIiLCAiZGF0YV9zb3VyY2UiOiAiVS5TLiBHZW9sb2dpY2FsIFN1cnZleSIsICJkYXRlX3RpbWUiOiAiMjAyMC0wNC0wMVQxMDoxNTowMC4wMDAiLCAiZGl2IjogIjEiLCAiZHdyX2FiYnJldiI6ICJCT0NOT1JDTyIsICJmbGFnIjogbnVsbCwgImh0dHBfbGlua2FnZS51cmwiOiAiaHR0cHM6Ly93YXRlcmRhdGEudXNncy5nb3Yvbndpcy91dj8wNjczMDIwMCIsICJsb2NhdGlvbi5sYXRpdHVkZSI6IDQwLjA1MTY1MiwgImxvY2F0aW9uLmxvbmdpdHVkZSI6IC0xMDUuMTc4ODc1LCAibG9jYXRpb24ubmVlZHNfcmVjb2RpbmciOiBmYWxzZSwgInN0YWdlIjogbnVsbCwgInN0YXRpb25fbmFtZSI6ICJCT1VMREVSIENSRUVLIEFUIE5PUlRIIDc1VEggU1QuIE5FQVIgQk9VTERFUiwgQ08iLCAic3RhdGlvbl9zdGF0dXMiOiAiQWN0aXZlIiwgInN0YXRpb25fdHlwZSI6ICJTdHJlYW0iLCAidXNnc19zdGF0aW9uX2lkIjogIjA2NzMwMjAwIiwgInZhcmlhYmxlIjogIkRJU0NIUkciLCAid2QiOiAiNiJ9LCAidHlwZSI6ICJGZWF0dXJlIn0sIHsiYmJveCI6IFstMTA1LjE2MDg3NiwgNDAuMTcwOTk4LCAtMTA1LjE2MDg3NiwgNDAuMTcwOTk4XSwgImdlb21ldHJ5IjogeyJjb29yZGluYXRlcyI6IFstMTA1LjE2MDg3NiwgNDAuMTcwOTk4XSwgInR5cGUiOiAiUG9pbnQifSwgImlkIjogIjIxIiwgInByb3BlcnRpZXMiOiB7ImFtb3VudCI6ICIwLjM4IiwgImNvdW50eSI6ICJCT1VMREVSIiwgImRhdGFfc291cmNlIjogIkNvb3BlcmF0aXZlIFByb2dyYW0gb2YgQ0RXUiwgTkNXQ0QgXHUwMDI2IFNWTEhXQ0QiLCAiZGF0ZV90aW1lIjogIjIwMjAtMDQtMDFUMTA6MDA6MDAuMDAwIiwgImRpdiI6ICIxIiwgImR3cl9hYmJyZXYiOiAiU0ZMRElUQ08iLCAiZmxhZyI6IG51bGwsICJodHRwX2xpbmthZ2UudXJsIjogImh0dHBzOi8vZHdyLnN0YXRlLmNvLnVzL1N1cmZhY2VXYXRlci9kYXRhL2RldGFpbF9ncmFwaC5hc3B4P0lEPVNGTERJVENPXHUwMDI2TVRZUEU9RElTQ0hSRyIsICJsb2NhdGlvbi5sYXRpdHVkZSI6IDQwLjE3MDk5OCwgImxvY2F0aW9uLmxvbmdpdHVkZSI6IC0xMDUuMTYwODc2LCAibG9jYXRpb24ubmVlZHNfcmVjb2RpbmciOiBmYWxzZSwgInN0YWdlIjogIjAuMTEiLCAic3RhdGlvbl9uYW1lIjogIlNPVVRIIEZMQVQgRElUQ0giLCAic3RhdGlvbl9zdGF0dXMiOiAiQWN0aXZlIiwgInN0YXRpb25fdHlwZSI6ICJEaXZlcnNpb24iLCAidXNnc19zdGF0aW9uX2lkIjogbnVsbCwgInZhcmlhYmxlIjogIkRJU0NIUkciLCAid2QiOiAiNSJ9LCAidHlwZSI6ICJGZWF0dXJlIn0sIHsiYmJveCI6IFstMTA1LjA3NTY5NSwgNDAuMTUzMzQxLCAtMTA1LjA3NTY5NSwgNDAuMTUzMzQxXSwgImdlb21ldHJ5IjogeyJjb29yZGluYXRlcyI6IFstMTA1LjA3NTY5NSwgNDAuMTUzMzQxXSwgInR5cGUiOiAiUG9pbnQifSwgImlkIjogIjIyIiwgInByb3BlcnRpZXMiOiB7ImFtb3VudCI6ICIzMC45MCIsICJjb3VudHkiOiAiQk9VTERFUiIsICJkYXRhX3NvdXJjZSI6ICJDby4gRGl2aXNpb24gb2YgV2F0ZXIgUmVzb3VyY2VzIiwgImRhdGVfdGltZSI6ICIyMDIwLTA0LTAxVDEwOjMwOjAwLjAwMCIsICJkaXYiOiAiMSIsICJkd3JfYWJicmV2IjogIlNWQ0xPUENPIiwgImZsYWciOiBudWxsLCAiaHR0cF9saW5rYWdlLnVybCI6ICJodHRwczovL2R3ci5zdGF0ZS5jby51cy9TdXJmYWNlV2F0ZXIvZGF0YS9kZXRhaWxfZ3JhcGguYXNweD9JRD1TVkNMT1BDT1x1MDAyNk1UWVBFPURJU0NIUkciLCAibG9jYXRpb24ubGF0aXR1ZGUiOiA0MC4xNTMzNDEsICJsb2NhdGlvbi5sb25naXR1ZGUiOiAtMTA1LjA3NTY5NSwgImxvY2F0aW9uLm5lZWRzX3JlY29kaW5nIjogZmFsc2UsICJzdGFnZSI6ICIzLjQ4IiwgInN0YXRpb25fbmFtZSI6ICJTQUlOVCBWUkFJTiBDUkVFSyBCRUxPVyBLRU4gUFJBVFQgQkxWRCBBVCBMT05HTU9OVCwgQ08iLCAic3RhdGlvbl9zdGF0dXMiOiAiQWN0aXZlIiwgInN0YXRpb25fdHlwZSI6ICJTdHJlYW0iLCAidXNnc19zdGF0aW9uX2lkIjogbnVsbCwgInZhcmlhYmxlIjogIkRJU0NIUkciLCAid2QiOiAiNSJ9LCAidHlwZSI6ICJGZWF0dXJlIn0sIHsiYmJveCI6IFstMTA1LjE1MTE0MywgNDAuMDUzNjYxLCAtMTA1LjE1MTE0MywgNDAuMDUzNjYxXSwgImdlb21ldHJ5IjogeyJjb29yZGluYXRlcyI6IFstMTA1LjE1MTE0MywgNDAuMDUzNjYxXSwgInR5cGUiOiAiUG9pbnQifSwgImlkIjogIjIzIiwgInByb3BlcnRpZXMiOiB7ImFtb3VudCI6ICIyLjI0IiwgImNvdW50eSI6ICJCT1VMREVSIiwgImRhdGFfc291cmNlIjogIkNvb3BlcmF0aXZlIFByb2dyYW0gb2YgQ0RXUiwgTkNXQ0QgXHUwMDI2IExTUFdDRCIsICJkYXRlX3RpbWUiOiAiMjAyMC0wNC0wMVQxMDowMDowMC4wMDAiLCAiZGl2IjogIjEiLCAiZHdyX2FiYnJldiI6ICJMRUdESVRDTyIsICJmbGFnIjogbnVsbCwgImh0dHBfbGlua2FnZS51cmwiOiAiaHR0cHM6Ly9kd3Iuc3RhdGUuY28udXMvU3VyZmFjZVdhdGVyL2RhdGEvZGV0YWlsX2dyYXBoLmFzcHg/SUQ9TEVHRElUQ09cdTAwMjZNVFlQRT1ESVNDSFJHIiwgImxvY2F0aW9uLmxhdGl0dWRlIjogNDAuMDUzNjYxLCAibG9jYXRpb24ubG9uZ2l0dWRlIjogLTEwNS4xNTExNDMsICJsb2NhdGlvbi5uZWVkc19yZWNvZGluZyI6IGZhbHNlLCAic3RhZ2UiOiAiMC4xOSIsICJzdGF0aW9uX25hbWUiOiAiTEVHR0VUVCBESVRDSCIsICJzdGF0aW9uX3N0YXR1cyI6ICJBY3RpdmUiLCAic3RhdGlvbl90eXBlIjogIkRpdmVyc2lvbiIsICJ1c2dzX3N0YXRpb25faWQiOiBudWxsLCAidmFyaWFibGUiOiAiRElTQ0hSRyIsICJ3ZCI6ICI2In0sICJ0eXBlIjogIkZlYXR1cmUifSwgeyJiYm94IjogWy0xMDUuMDk3ODcyLCA0MC4wNTk4MDksIC0xMDUuMDk3ODcyLCA0MC4wNTk4MDldLCAiZ2VvbWV0cnkiOiB7ImNvb3JkaW5hdGVzIjogWy0xMDUuMDk3ODcyLCA0MC4wNTk4MDldLCAidHlwZSI6ICJQb2ludCJ9LCAiaWQiOiAiMjQiLCAicHJvcGVydGllcyI6IHsiYW1vdW50IjogIjI5LjUwIiwgImNvdW50eSI6ICJCT1VMREVSIiwgImRhdGFfc291cmNlIjogIkNvLiBEaXZpc2lvbiBvZiBXYXRlciBSZXNvdXJjZXMiLCAiZGF0ZV90aW1lIjogIjIwMjAtMDQtMDFUMTA6NDU6MDAuMDAwIiwgImRpdiI6ICIxIiwgImR3cl9hYmJyZXYiOiAiQk9DMTA5Q08iLCAiZmxhZyI6IG51bGwsICJodHRwX2xpbmthZ2UudXJsIjogImh0dHBzOi8vZHdyLnN0YXRlLmNvLnVzL1N1cmZhY2VXYXRlci9kYXRhL2RldGFpbF9ncmFwaC5hc3B4P0lEPUJPQzEwOUNPXHUwMDI2TVRZUEU9RElTQ0hSRyIsICJsb2NhdGlvbi5sYXRpdHVkZSI6IDQwLjA1OTgwOSwgImxvY2F0aW9uLmxvbmdpdHVkZSI6IC0xMDUuMDk3ODcyLCAibG9jYXRpb24ubmVlZHNfcmVjb2RpbmciOiBmYWxzZSwgInN0YWdlIjogIjIuMzYiLCAic3RhdGlvbl9uYW1lIjogIkJPVUxERVIgQ1JFRUsgQVQgMTA5IFNUIE5FQVIgRVJJRSwgQ08iLCAic3RhdGlvbl9zdGF0dXMiOiAiQWN0aXZlIiwgInN0YXRpb25fdHlwZSI6ICJTdHJlYW0iLCAidXNnc19zdGF0aW9uX2lkIjogbnVsbCwgInZhcmlhYmxlIjogIkRJU0NIUkciLCAid2QiOiAiNiJ9LCAidHlwZSI6ICJGZWF0dXJlIn0sIHsiYmJveCI6IFstMTA1LjM2MzQyMiwgNDAuMjE1NjU4LCAtMTA1LjM2MzQyMiwgNDAuMjE1NjU4XSwgImdlb21ldHJ5IjogeyJjb29yZGluYXRlcyI6IFstMTA1LjM2MzQyMiwgNDAuMjE1NjU4XSwgInR5cGUiOiAiUG9pbnQifSwgImlkIjogIjI1IiwgInByb3BlcnRpZXMiOiB7ImFtb3VudCI6ICIxOS4zMCIsICJjb3VudHkiOiAiQk9VTERFUiIsICJkYXRhX3NvdXJjZSI6ICJDby4gRGl2aXNpb24gb2YgV2F0ZXIgUmVzb3VyY2VzIiwgImRhdGVfdGltZSI6ICIyMDIwLTA0LTAxVDEwOjQ1OjAwLjAwMCIsICJkaXYiOiAiMSIsICJkd3JfYWJicmV2IjogIk5TVkJCUkNPIiwgImZsYWciOiBudWxsLCAiaHR0cF9saW5rYWdlLnVybCI6ICJodHRwczovL2R3ci5zdGF0ZS5jby51cy9TdXJmYWNlV2F0ZXIvZGF0YS9kZXRhaWxfZ3JhcGguYXNweD9JRD1OU1ZCQlJDT1x1MDAyNk1UWVBFPURJU0NIUkciLCAibG9jYXRpb24ubGF0aXR1ZGUiOiA0MC4yMTU2NTgsICJsb2NhdGlvbi5sb25naXR1ZGUiOiAtMTA1LjM2MzQyMiwgImxvY2F0aW9uLm5lZWRzX3JlY29kaW5nIjogZmFsc2UsICJzdGFnZSI6ICIwLjM0IiwgInN0YXRpb25fbmFtZSI6ICJOT1JUSCBTQUlOVCBWUkFJTiBDUkVFSyBCRUxPVyBCVVRUT05ST0NLICAoUkFMUEggUFJJQ0UpIFJFU0VSVk9JUiIsICJzdGF0aW9uX3N0YXR1cyI6ICJBY3RpdmUiLCAic3RhdGlvbl90eXBlIjogIlN0cmVhbSIsICJ1c2dzX3N0YXRpb25faWQiOiBudWxsLCAidmFyaWFibGUiOiAiRElTQ0hSRyIsICJ3ZCI6ICI1In0sICJ0eXBlIjogIkZlYXR1cmUifSwgeyJiYm94IjogWy0xMDUuMzA0NDA0LCA0MC4xMjYzODksIC0xMDUuMzA0NDA0LCA0MC4xMjYzODldLCAiZ2VvbWV0cnkiOiB7ImNvb3JkaW5hdGVzIjogWy0xMDUuMzA0NDA0LCA0MC4xMjYzODldLCAidHlwZSI6ICJQb2ludCJ9LCAiaWQiOiAiMjYiLCAicHJvcGVydGllcyI6IHsiYW1vdW50IjogIjE0LjAwIiwgImNvdW50eSI6ICJCT1VMREVSIiwgImRhdGFfc291cmNlIjogIkNvLiBEaXZpc2lvbiBvZiBXYXRlciBSZXNvdXJjZXMiLCAiZGF0ZV90aW1lIjogIjIwMjAtMDQtMDFUMTA6MTU6MDAuMDAwIiwgImRpdiI6ICIxIiwgImR3cl9hYmJyZXYiOiAiTEVGQ1JFQ08iLCAiZmxhZyI6IG51bGwsICJodHRwX2xpbmthZ2UudXJsIjogImh0dHBzOi8vZHdyLnN0YXRlLmNvLnVzL1N1cmZhY2VXYXRlci9kYXRhL2RldGFpbF9ncmFwaC5hc3B4P0lEPUxFRkNSRUNPXHUwMDI2TVRZUEU9RElTQ0hSRyIsICJsb2NhdGlvbi5sYXRpdHVkZSI6IDQwLjEyNjM4OSwgImxvY2F0aW9uLmxvbmdpdHVkZSI6IC0xMDUuMzA0NDA0LCAibG9jYXRpb24ubmVlZHNfcmVjb2RpbmciOiBmYWxzZSwgInN0YWdlIjogIjAuNDkiLCAic3RhdGlvbl9uYW1lIjogIkxFRlQgSEFORCBDUkVFSyBORUFSIEJPVUxERVIsIENPLiIsICJzdGF0aW9uX3N0YXR1cyI6ICJBY3RpdmUiLCAic3RhdGlvbl90eXBlIjogIlN0cmVhbSIsICJ1c2dzX3N0YXRpb25faWQiOiAiMDY3MjQ1MDAiLCAidmFyaWFibGUiOiAiRElTQ0hSRyIsICJ3ZCI6ICI1In0sICJ0eXBlIjogIkZlYXR1cmUifSwgeyJiYm94IjogWy0xMDUuMjE3NTE5LCA0MC4wODYyNzgsIC0xMDUuMjE3NTE5LCA0MC4wODYyNzhdLCAiZ2VvbWV0cnkiOiB7ImNvb3JkaW5hdGVzIjogWy0xMDUuMjE3NTE5LCA0MC4wODYyNzhdLCAidHlwZSI6ICJQb2ludCJ9LCAiaWQiOiAiMjciLCAicHJvcGVydGllcyI6IHsiYW1vdW50IjogIjQzLjI3IiwgImNvdW50eSI6ICJCT1VMREVSIiwgImRhdGFfc291cmNlIjogIk5vcnRoZXJuIENvbG9yYWRvIFdhdGVyIENvbnNlcnZhbmN5IERpc3RyaWN0IiwgImRhdGVfdGltZSI6ICIyMDIwLTA0LTAxVDEwOjAwOjAwLjAwMCIsICJkaXYiOiAiMSIsICJkd3JfYWJicmV2IjogIkJGQ0lORkNPIiwgImZsYWciOiBudWxsLCAiaHR0cF9saW5rYWdlLnVybCI6ICJodHRwOi8vd3d3Lm5vcnRoZXJud2F0ZXIub3JnL1dhdGVyUHJvamVjdHMvRWFzdFNsb3BlV2F0ZXJEYXRhLmFzcHgiLCAibG9jYXRpb24ubGF0aXR1ZGUiOiA0MC4wODYyNzgsICJsb2NhdGlvbi5sb25naXR1ZGUiOiAtMTA1LjIxNzUxOSwgImxvY2F0aW9uLm5lZWRzX3JlY29kaW5nIjogZmFsc2UsICJzdGFnZSI6ICIyLjEzIiwgInN0YXRpb25fbmFtZSI6ICJCT1VMREVSIFJFU0VSVk9JUiBJTkxFVCIsICJzdGF0aW9uX3N0YXR1cyI6ICJBY3RpdmUiLCAic3RhdGlvbl90eXBlIjogIlN0cmVhbSIsICJ1c2dzX3N0YXRpb25faWQiOiAiRVMxOTE2IiwgInZhcmlhYmxlIjogIkRJU0NIUkciLCAid2QiOiAiNiJ9LCAidHlwZSI6ICJGZWF0dXJlIn0sIHsiYmJveCI6IFstMTA1LjIxMDM4OCwgNDAuMTkzMDE5LCAtMTA1LjIxMDM4OCwgNDAuMTkzMDE5XSwgImdlb21ldHJ5IjogeyJjb29yZGluYXRlcyI6IFstMTA1LjIxMDM4OCwgNDAuMTkzMDE5XSwgInR5cGUiOiAiUG9pbnQifSwgImlkIjogIjI4IiwgInByb3BlcnRpZXMiOiB7ImFtb3VudCI6ICIwLjAwIiwgImNvdW50eSI6ICJCT1VMREVSIiwgImRhdGFfc291cmNlIjogIkNvb3BlcmF0aXZlIFByb2dyYW0gb2YgQ0RXUiwgTkNXQ0QgXHUwMDI2IFNWTEhXQ0QiLCAiZGF0ZV90aW1lIjogIjIwMjAtMDQtMDFUMTA6MDA6MDAuMDAwIiwgImRpdiI6ICIxIiwgImR3cl9hYmJyZXYiOiAiVFJVRElUQ08iLCAiZmxhZyI6IG51bGwsICJodHRwX2xpbmthZ2UudXJsIjogImh0dHBzOi8vZHdyLnN0YXRlLmNvLnVzL1N1cmZhY2VXYXRlci9kYXRhL2RldGFpbF9ncmFwaC5hc3B4P0lEPVRSVURJVENPXHUwMDI2TVRZUEU9RElTQ0hSRyIsICJsb2NhdGlvbi5sYXRpdHVkZSI6IDQwLjE5MzAxOSwgImxvY2F0aW9uLmxvbmdpdHVkZSI6IC0xMDUuMjEwMzg4LCAibG9jYXRpb24ubmVlZHNfcmVjb2RpbmciOiBmYWxzZSwgInN0YWdlIjogbnVsbCwgInN0YXRpb25fbmFtZSI6ICJUUlVFIEFORCBXRUJTVEVSIERJVENIIiwgInN0YXRpb25fc3RhdHVzIjogIkFjdGl2ZSIsICJzdGF0aW9uX3R5cGUiOiAiRGl2ZXJzaW9uIiwgInVzZ3Nfc3RhdGlvbl9pZCI6IG51bGwsICJ2YXJpYWJsZSI6ICJESVNDSFJHIiwgIndkIjogIjUifSwgInR5cGUiOiAiRmVhdHVyZSJ9LCB7ImJib3giOiBbLTEwNS4yNTE4MjYsIDQwLjIxMjY1OCwgLTEwNS4yNTE4MjYsIDQwLjIxMjY1OF0sICJnZW9tZXRyeSI6IHsiY29vcmRpbmF0ZXMiOiBbLTEwNS4yNTE4MjYsIDQwLjIxMjY1OF0sICJ0eXBlIjogIlBvaW50In0sICJpZCI6ICIyOSIsICJwcm9wZXJ0aWVzIjogeyJhbW91bnQiOiAiMC4wMCIsICJjb3VudHkiOiAiQk9VTERFUiIsICJkYXRhX3NvdXJjZSI6ICJDb29wZXJhdGl2ZSBQcm9ncmFtIG9mIENEV1IsIE5DV0NEIFx1MDAyNiBTVkxIV0NEIiwgImRhdGVfdGltZSI6ICIyMDIwLTA0LTAxVDEwOjAwOjAwLjAwMCIsICJkaXYiOiAiMSIsICJkd3JfYWJicmV2IjogIlJPVVJFQUNPIiwgImZsYWciOiBudWxsLCAiaHR0cF9saW5rYWdlLnVybCI6ICJodHRwczovL2R3ci5zdGF0ZS5jby51cy9TdXJmYWNlV2F0ZXIvZGF0YS9kZXRhaWxfZ3JhcGguYXNweD9JRD1ST1VSRUFDT1x1MDAyNk1UWVBFPURJU0NIUkciLCAibG9jYXRpb24ubGF0aXR1ZGUiOiA0MC4yMTI2NTgsICJsb2NhdGlvbi5sb25naXR1ZGUiOiAtMTA1LjI1MTgyNiwgImxvY2F0aW9uLm5lZWRzX3JlY29kaW5nIjogZmFsc2UsICJzdGFnZSI6IG51bGwsICJzdGF0aW9uX25hbWUiOiAiUk9VR0ggQU5EIFJFQURZIERJVENIIiwgInN0YXRpb25fc3RhdHVzIjogIkFjdGl2ZSIsICJzdGF0aW9uX3R5cGUiOiAiRGl2ZXJzaW9uIiwgInVzZ3Nfc3RhdGlvbl9pZCI6IG51bGwsICJ2YXJpYWJsZSI6ICJESVNDSFJHIiwgIndkIjogIjUifSwgInR5cGUiOiAiRmVhdHVyZSJ9LCB7ImJib3giOiBbLTEwNS4xNjc4NzMsIDQwLjE3NDg0NCwgLTEwNS4xNjc4NzMsIDQwLjE3NDg0NF0sICJnZW9tZXRyeSI6IHsiY29vcmRpbmF0ZXMiOiBbLTEwNS4xNjc4NzMsIDQwLjE3NDg0NF0sICJ0eXBlIjogIlBvaW50In0sICJpZCI6ICIzMCIsICJwcm9wZXJ0aWVzIjogeyJhbW91bnQiOiAiMC4xMiIsICJjb3VudHkiOiAiQk9VTERFUiIsICJkYXRhX3NvdXJjZSI6ICJDb29wZXJhdGl2ZSBQcm9ncmFtIG9mIENEV1IsIE5DV0NEIFx1MDAyNiBTVkxIV0NEIiwgImRhdGVfdGltZSI6ICIyMDIwLTA0LTAxVDA5OjQ1OjAwLjAwMCIsICJkaXYiOiAiMSIsICJkd3JfYWJicmV2IjogIkhHUk1EV0NPIiwgImZsYWciOiBudWxsLCAiaHR0cF9saW5rYWdlLnVybCI6ICJodHRwczovL2R3ci5zdGF0ZS5jby51cy9TdXJmYWNlV2F0ZXIvZGF0YS9kZXRhaWxfZ3JhcGguYXNweD9JRD1IR1JNRFdDT1x1MDAyNk1UWVBFPURJU0NIUkciLCAibG9jYXRpb24ubGF0aXR1ZGUiOiA0MC4xNzQ4NDQsICJsb2NhdGlvbi5sb25naXR1ZGUiOiAtMTA1LjE2Nzg3MywgImxvY2F0aW9uLm5lZWRzX3JlY29kaW5nIjogZmFsc2UsICJzdGFnZSI6ICIwLjA3IiwgInN0YXRpb25fbmFtZSI6ICJIQUdFUiBNRUFET1dTIERJVENIIiwgInN0YXRpb25fc3RhdHVzIjogIkFjdGl2ZSIsICJzdGF0aW9uX3R5cGUiOiAiRGl2ZXJzaW9uIiwgInVzZ3Nfc3RhdGlvbl9pZCI6IG51bGwsICJ2YXJpYWJsZSI6ICJESVNDSFJHIiwgIndkIjogIjUifSwgInR5cGUiOiAiRmVhdHVyZSJ9LCB7ImJib3giOiBbLTEwNS4yMDk0MTYsIDQwLjI1NjI3NiwgLTEwNS4yMDk0MTYsIDQwLjI1NjI3Nl0sICJnZW9tZXRyeSI6IHsiY29vcmRpbmF0ZXMiOiBbLTEwNS4yMDk0MTYsIDQwLjI1NjI3Nl0sICJ0eXBlIjogIlBvaW50In0sICJpZCI6ICIzMSIsICJwcm9wZXJ0aWVzIjogeyJhbW91bnQiOiAiMC4wMCIsICJjb3VudHkiOiAiQk9VTERFUiIsICJkYXRhX3NvdXJjZSI6ICJOb3J0aGVybiBDb2xvcmFkbyBXYXRlciBDb25zZXJ2YW5jeSBEaXN0cmljdCIsICJkYXRlX3RpbWUiOiAiMjAyMC0wNC0wMVQxMDowMDowMC4wMDAiLCAiZGl2IjogIjEiLCAiZHdyX2FiYnJldiI6ICJMSVRUSDFDTyIsICJmbGFnIjogbnVsbCwgImh0dHBfbGlua2FnZS51cmwiOiAiaHR0cDovL3d3dy5ub3J0aGVybndhdGVyLm9yZy9XYXRlclByb2plY3RzL0Vhc3RTbG9wZVdhdGVyRGF0YS5hc3B4IiwgImxvY2F0aW9uLmxhdGl0dWRlIjogNDAuMjU2Mjc2LCAibG9jYXRpb24ubG9uZ2l0dWRlIjogLTEwNS4yMDk0MTYsICJsb2NhdGlvbi5uZWVkc19yZWNvZGluZyI6IGZhbHNlLCAic3RhZ2UiOiBudWxsLCAic3RhdGlvbl9uYW1lIjogIkxJVFRMRSBUSE9NUFNPTiAjMSBESVRDSCIsICJzdGF0aW9uX3N0YXR1cyI6ICJBY3RpdmUiLCAic3RhdGlvbl90eXBlIjogIkRpdmVyc2lvbiIsICJ1c2dzX3N0YXRpb25faWQiOiAiRVMxOTAxIiwgInZhcmlhYmxlIjogIkRJU0NIUkciLCAid2QiOiAiNCJ9LCAidHlwZSI6ICJGZWF0dXJlIn0sIHsiYmJveCI6IFstMTA1LjE5ODU2NywgNDAuMjYwODI3LCAtMTA1LjE5ODU2NywgNDAuMjYwODI3XSwgImdlb21ldHJ5IjogeyJjb29yZGluYXRlcyI6IFstMTA1LjE5ODU2NywgNDAuMjYwODI3XSwgInR5cGUiOiAiUG9pbnQifSwgImlkIjogIjMyIiwgInByb3BlcnRpZXMiOiB7ImFtb3VudCI6ICIwLjAwIiwgImNvdW50eSI6ICJCT1VMREVSIiwgImRhdGFfc291cmNlIjogIkNvb3BlcmF0aXZlIFNEUiBQcm9ncmFtIG9mIENEV1IgXHUwMDI2IE5DV0NEIiwgImRhdGVfdGltZSI6ICIyMDIwLTA0LTAxVDEwOjAwOjAwLjAwMCIsICJkaXYiOiAiMSIsICJkd3JfYWJicmV2IjogIkNVTERJVENPIiwgImZsYWciOiBudWxsLCAiaHR0cF9saW5rYWdlLnVybCI6ICJodHRwczovL2R3ci5zdGF0ZS5jby51cy9TdXJmYWNlV2F0ZXIvZGF0YS9kZXRhaWxfZ3JhcGguYXNweD9JRD1DVUxESVRDT1x1MDAyNk1UWVBFPURJU0NIUkciLCAibG9jYXRpb24ubGF0aXR1ZGUiOiA0MC4yNjA4MjcsICJsb2NhdGlvbi5sb25naXR1ZGUiOiAtMTA1LjE5ODU2NywgImxvY2F0aW9uLm5lZWRzX3JlY29kaW5nIjogZmFsc2UsICJzdGFnZSI6IG51bGwsICJzdGF0aW9uX25hbWUiOiAiQ1VMVkVSIERJVENIIiwgInN0YXRpb25fc3RhdHVzIjogIkFjdGl2ZSIsICJzdGF0aW9uX3R5cGUiOiAiRGl2ZXJzaW9uIiwgInVzZ3Nfc3RhdGlvbl9pZCI6IG51bGwsICJ2YXJpYWJsZSI6ICJESVNDSFJHIiwgIndkIjogIjQifSwgInR5cGUiOiAiRmVhdHVyZSJ9LCB7ImJib3giOiBbLTEwNS4yNTYwMTcsIDQwLjIxNTA0MywgLTEwNS4yNTYwMTcsIDQwLjIxNTA0M10sICJnZW9tZXRyeSI6IHsiY29vcmRpbmF0ZXMiOiBbLTEwNS4yNTYwMTcsIDQwLjIxNTA0M10sICJ0eXBlIjogIlBvaW50In0sICJpZCI6ICIzMyIsICJwcm9wZXJ0aWVzIjogeyJhbW91bnQiOiAiMzcuMjAiLCAiY291bnR5IjogIkJPVUxERVIiLCAiZGF0YV9zb3VyY2UiOiAiQ28uIERpdmlzaW9uIG9mIFdhdGVyIFJlc291cmNlcyIsICJkYXRlX3RpbWUiOiAiMjAyMC0wNC0wMVQxMDozMDowMC4wMDAiLCAiZGl2IjogIjEiLCAiZHdyX2FiYnJldiI6ICJISUdITERDTyIsICJmbGFnIjogbnVsbCwgImh0dHBfbGlua2FnZS51cmwiOiAiaHR0cHM6Ly9kd3Iuc3RhdGUuY28udXMvU3VyZmFjZVdhdGVyL2RhdGEvZGV0YWlsX2dyYXBoLmFzcHg/SUQ9SElHSExEQ09cdTAwMjZNVFlQRT1ESVNDSFJHIiwgImxvY2F0aW9uLmxhdGl0dWRlIjogNDAuMjE1MDQzLCAibG9jYXRpb24ubG9uZ2l0dWRlIjogLTEwNS4yNTYwMTcsICJsb2NhdGlvbi5uZWVkc19yZWNvZGluZyI6IGZhbHNlLCAic3RhZ2UiOiAiMC43MCIsICJzdGF0aW9uX25hbWUiOiAiSElHSExBTkQgRElUQ0ggQVQgTFlPTlMsIENPIiwgInN0YXRpb25fc3RhdHVzIjogIkFjdGl2ZSIsICJzdGF0aW9uX3R5cGUiOiAiRGl2ZXJzaW9uIiwgInVzZ3Nfc3RhdGlvbl9pZCI6IG51bGwsICJ2YXJpYWJsZSI6ICJESVNDSFJHIiwgIndkIjogIjUifSwgInR5cGUiOiAiRmVhdHVyZSJ9LCB7ImJib3giOiBbLTEwNS4yMjA0OTcsIDQwLjA3ODU2LCAtMTA1LjIyMDQ5NywgNDAuMDc4NTZdLCAiZ2VvbWV0cnkiOiB7ImNvb3JkaW5hdGVzIjogWy0xMDUuMjIwNDk3LCA0MC4wNzg1Nl0sICJ0eXBlIjogIlBvaW50In0sICJpZCI6ICIzNCIsICJwcm9wZXJ0aWVzIjogeyJhbW91bnQiOiAiNTE3NS4wMCIsICJjb3VudHkiOiAiQk9VTERFUiIsICJkYXRhX3NvdXJjZSI6ICJOb3J0aGVybiBDb2xvcmFkbyBXYXRlciBDb25zZXJ2YW5jeSBEaXN0cmljdCIsICJkYXRlX3RpbWUiOiAiMjAyMC0wNC0wMVQxMDowMDowMC4wMDAiLCAiZGl2IjogIjEiLCAiZHdyX2FiYnJldiI6ICJCT1VSRVNDTyIsICJmbGFnIjogbnVsbCwgImh0dHBfbGlua2FnZS51cmwiOiAiaHR0cDovL3d3dy5ub3J0aGVybndhdGVyLm9yZy9XYXRlclByb2plY3RzL0Vhc3RTbG9wZVdhdGVyRGF0YS5hc3B4IiwgImxvY2F0aW9uLmxhdGl0dWRlIjogNDAuMDc4NTYsICJsb2NhdGlvbi5sb25naXR1ZGUiOiAtMTA1LjIyMDQ5NywgImxvY2F0aW9uLm5lZWRzX3JlY29kaW5nIjogZmFsc2UsICJzdGFnZSI6IG51bGwsICJzdGF0aW9uX25hbWUiOiAiQk9VTERFUiBSRVNFUlZPSVIiLCAic3RhdGlvbl9zdGF0dXMiOiAiQWN0aXZlIiwgInN0YXRpb25fdHlwZSI6ICJSZXNlcnZvaXIiLCAidXNnc19zdGF0aW9uX2lkIjogIkVSMTkxNCIsICJ2YXJpYWJsZSI6ICJTVE9SQUdFIiwgIndkIjogIjYifSwgInR5cGUiOiAiRmVhdHVyZSJ9LCB7ImJib3giOiBbLTEwNS4xNjkzNzQsIDQwLjE3Mzk1LCAtMTA1LjE2OTM3NCwgNDAuMTczOTVdLCAiZ2VvbWV0cnkiOiB7ImNvb3JkaW5hdGVzIjogWy0xMDUuMTY5Mzc0LCA0MC4xNzM5NV0sICJ0eXBlIjogIlBvaW50In0sICJpZCI6ICIzNSIsICJwcm9wZXJ0aWVzIjogeyJhbW91bnQiOiAiMC4xOSIsICJjb3VudHkiOiAiQk9VTERFUiIsICJkYXRhX3NvdXJjZSI6ICJDb29wZXJhdGl2ZSBQcm9ncmFtIG9mIENEV1IsIE5DV0NEIFx1MDAyNiBTVkxIV0NEIiwgImRhdGVfdGltZSI6ICIyMDIwLTA0LTAxVDA5OjMwOjAwLjAwMCIsICJkaXYiOiAiMSIsICJkd3JfYWJicmV2IjogIk5JV0RJVENPIiwgImZsYWciOiBudWxsLCAiaHR0cF9saW5rYWdlLnVybCI6ICJodHRwczovL2R3ci5zdGF0ZS5jby51cy9TdXJmYWNlV2F0ZXIvZGF0YS9kZXRhaWxfZ3JhcGguYXNweD9JRD1OSVdESVRDT1x1MDAyNk1UWVBFPURJU0NIUkciLCAibG9jYXRpb24ubGF0aXR1ZGUiOiA0MC4xNzM5NSwgImxvY2F0aW9uLmxvbmdpdHVkZSI6IC0xMDUuMTY5Mzc0LCAibG9jYXRpb24ubmVlZHNfcmVjb2RpbmciOiBmYWxzZSwgInN0YWdlIjogIjAuMDkiLCAic3RhdGlvbl9uYW1lIjogIk5JV09UIERJVENIIiwgInN0YXRpb25fc3RhdHVzIjogIkFjdGl2ZSIsICJzdGF0aW9uX3R5cGUiOiAiRGl2ZXJzaW9uIiwgInVzZ3Nfc3RhdGlvbl9pZCI6IG51bGwsICJ2YXJpYWJsZSI6ICJESVNDSFJHIiwgIndkIjogIjUifSwgInR5cGUiOiAiRmVhdHVyZSJ9LCB7ImJib3giOiBbLTEwNS4yNTA5NTIsIDQwLjIxMTM4OSwgLTEwNS4yNTA5NTIsIDQwLjIxMTM4OV0sICJnZW9tZXRyeSI6IHsiY29vcmRpbmF0ZXMiOiBbLTEwNS4yNTA5NTIsIDQwLjIxMTM4OV0sICJ0eXBlIjogIlBvaW50In0sICJpZCI6ICIzNiIsICJwcm9wZXJ0aWVzIjogeyJhbW91bnQiOiAiMC4wMCIsICJjb3VudHkiOiAiQk9VTERFUiIsICJkYXRhX3NvdXJjZSI6ICJDb29wZXJhdGl2ZSBQcm9ncmFtIG9mIENEV1IsIE5DV0NEIFx1MDAyNiBTVkxIV0NEIiwgImRhdGVfdGltZSI6ICIyMDIwLTA0LTAxVDA5OjAwOjAwLjAwMCIsICJkaXYiOiAiMSIsICJkd3JfYWJicmV2IjogIlNNRURJVENPIiwgImZsYWciOiBudWxsLCAiaHR0cF9saW5rYWdlLnVybCI6ICJodHRwczovL2R3ci5zdGF0ZS5jby51cy9TdXJmYWNlV2F0ZXIvZGF0YS9kZXRhaWxfZ3JhcGguYXNweD9JRD1TTUVESVRDT1x1MDAyNk1UWVBFPURJU0NIUkciLCAibG9jYXRpb24ubGF0aXR1ZGUiOiA0MC4yMTEzODksICJsb2NhdGlvbi5sb25naXR1ZGUiOiAtMTA1LjI1MDk1MiwgImxvY2F0aW9uLm5lZWRzX3JlY29kaW5nIjogZmFsc2UsICJzdGFnZSI6IG51bGwsICJzdGF0aW9uX25hbWUiOiAiU01FQUQgRElUQ0giLCAic3RhdGlvbl9zdGF0dXMiOiAiQWN0aXZlIiwgInN0YXRpb25fdHlwZSI6ICJEaXZlcnNpb24iLCAidXNnc19zdGF0aW9uX2lkIjogbnVsbCwgInZhcmlhYmxlIjogIkRJU0NIUkciLCAid2QiOiAiNSJ9LCAidHlwZSI6ICJGZWF0dXJlIn0sIHsiYmJveCI6IFstMTA1LjM0NzkwNiwgMzkuOTM4MzUxLCAtMTA1LjM0NzkwNiwgMzkuOTM4MzUxXSwgImdlb21ldHJ5IjogeyJjb29yZGluYXRlcyI6IFstMTA1LjM0NzkwNiwgMzkuOTM4MzUxXSwgInR5cGUiOiAiUG9pbnQifSwgImlkIjogIjM3IiwgInByb3BlcnRpZXMiOiB7ImFtb3VudCI6ICIxNi40MCIsICJjb3VudHkiOiAiQk9VTERFUiIsICJkYXRhX3NvdXJjZSI6ICJDby4gRGl2aXNpb24gb2YgV2F0ZXIgUmVzb3VyY2VzIiwgImRhdGVfdGltZSI6ICIyMDIwLTA0LTAxVDEwOjE1OjAwLjAwMCIsICJkaXYiOiAiMSIsICJkd3JfYWJicmV2IjogIkJPQ0JHUkNPIiwgImZsYWciOiBudWxsLCAiaHR0cF9saW5rYWdlLnVybCI6ICJodHRwczovL2R3ci5zdGF0ZS5jby51cy9TdXJmYWNlV2F0ZXIvZGF0YS9kZXRhaWxfZ3JhcGguYXNweD9JRD1CT0NCR1JDT1x1MDAyNk1UWVBFPURJU0NIUkciLCAibG9jYXRpb24ubGF0aXR1ZGUiOiAzOS45MzgzNTEsICJsb2NhdGlvbi5sb25naXR1ZGUiOiAtMTA1LjM0NzkwNiwgImxvY2F0aW9uLm5lZWRzX3JlY29kaW5nIjogZmFsc2UsICJzdGFnZSI6ICIwLjM2IiwgInN0YXRpb25fbmFtZSI6ICJTT1VUSCBCT1VMREVSIENSRUVLIEJFTE9XIEdST1NTIFJFU0VSVk9JUiIsICJzdGF0aW9uX3N0YXR1cyI6ICJBY3RpdmUiLCAic3RhdGlvbl90eXBlIjogIlN0cmVhbSIsICJ1c2dzX3N0YXRpb25faWQiOiAiMDY3Mjk0NTAiLCAidmFyaWFibGUiOiAiRElTQ0hSRyIsICJ3ZCI6ICI2In0sICJ0eXBlIjogIkZlYXR1cmUifSwgeyJiYm94IjogWy0xMDUuMjU4MTEsIDQwLjIxODMzNSwgLTEwNS4yNTgxMSwgNDAuMjE4MzM1XSwgImdlb21ldHJ5IjogeyJjb29yZGluYXRlcyI6IFstMTA1LjI1ODExLCA0MC4yMTgzMzVdLCAidHlwZSI6ICJQb2ludCJ9LCAiaWQiOiAiMzgiLCAicHJvcGVydGllcyI6IHsiYW1vdW50IjogIjQzLjMwIiwgImNvdW50eSI6ICJCT1VMREVSIiwgImRhdGFfc291cmNlIjogIk5vcnRoZXJuIENvbG9yYWRvIFdhdGVyIENvbnNlcnZhbmN5IERpc3RyaWN0IChTdGF0aW9uIENvb3BlcmF0b3IpIiwgImRhdGVfdGltZSI6ICIyMDIwLTA0LTAxVDEwOjMwOjAwLjAwMCIsICJkaXYiOiAiMSIsICJkd3JfYWJicmV2IjogIlNWU0xZT0NPIiwgImZsYWciOiBudWxsLCAiaHR0cF9saW5rYWdlLnVybCI6ICJodHRwczovL2R3ci5zdGF0ZS5jby51cy9TdXJmYWNlV2F0ZXIvZGF0YS9kZXRhaWxfZ3JhcGguYXNweD9JRD1TVlNMWU9DT1x1MDAyNk1UWVBFPURJU0NIUkciLCAibG9jYXRpb24ubGF0aXR1ZGUiOiA0MC4yMTgzMzUsICJsb2NhdGlvbi5sb25naXR1ZGUiOiAtMTA1LjI1ODExLCAibG9jYXRpb24ubmVlZHNfcmVjb2RpbmciOiBmYWxzZSwgInN0YWdlIjogIjAuODciLCAic3RhdGlvbl9uYW1lIjogIlNBSU5UIFZSQUlOIFNVUFBMWSBDQU5BTCBORUFSIExZT05TLCBDTyIsICJzdGF0aW9uX3N0YXR1cyI6ICJBY3RpdmUiLCAic3RhdGlvbl90eXBlIjogIkRpdmVyc2lvbiIsICJ1c2dzX3N0YXRpb25faWQiOiBudWxsLCAidmFyaWFibGUiOiAiRElTQ0hSRyIsICJ3ZCI6ICI1In0sICJ0eXBlIjogIkZlYXR1cmUifSwgeyJiYm94IjogWy0xMDUuMDg4Njk1LCA0MC4xNTMzNjMsIC0xMDUuMDg4Njk1LCA0MC4xNTMzNjNdLCAiZ2VvbWV0cnkiOiB7ImNvb3JkaW5hdGVzIjogWy0xMDUuMDg4Njk1LCA0MC4xNTMzNjNdLCAidHlwZSI6ICJQb2ludCJ9LCAiaWQiOiAiMzkiLCAicHJvcGVydGllcyI6IHsiYW1vdW50IjogIjAuMTAiLCAiY291bnR5IjogIkJPVUxERVIiLCAiZGF0YV9zb3VyY2UiOiAiQ29vcGVyYXRpdmUgUHJvZ3JhbSBvZiBDRFdSLCBOQ1dDRCBcdTAwMjYgU1ZMSFdDRCIsICJkYXRlX3RpbWUiOiAiMjAyMC0wNC0wMVQxMDowMDowMC4wMDAiLCAiZGl2IjogIjEiLCAiZHdyX2FiYnJldiI6ICJCT05ESVRDTyIsICJmbGFnIjogbnVsbCwgImh0dHBfbGlua2FnZS51cmwiOiAiaHR0cHM6Ly9kd3Iuc3RhdGUuY28udXMvU3VyZmFjZVdhdGVyL2RhdGEvZGV0YWlsX2dyYXBoLmFzcHg/SUQ9Qk9ORElUQ09cdTAwMjZNVFlQRT1ESVNDSFJHIiwgImxvY2F0aW9uLmxhdGl0dWRlIjogNDAuMTUzMzYzLCAibG9jYXRpb24ubG9uZ2l0dWRlIjogLTEwNS4wODg2OTUsICJsb2NhdGlvbi5uZWVkc19yZWNvZGluZyI6IGZhbHNlLCAic3RhZ2UiOiAiMC4wNCIsICJzdGF0aW9uX25hbWUiOiAiQk9OVVMgRElUQ0giLCAic3RhdGlvbl9zdGF0dXMiOiAiQWN0aXZlIiwgInN0YXRpb25fdHlwZSI6ICJEaXZlcnNpb24iLCAidXNnc19zdGF0aW9uX2lkIjogbnVsbCwgInZhcmlhYmxlIjogIkRJU0NIUkciLCAid2QiOiAiNSJ9LCAidHlwZSI6ICJGZWF0dXJlIn0sIHsiYmJveCI6IFstMTA1LjUwNDQ0LCAzOS45NjE2NTUsIC0xMDUuNTA0NDQsIDM5Ljk2MTY1NV0sICJnZW9tZXRyeSI6IHsiY29vcmRpbmF0ZXMiOiBbLTEwNS41MDQ0NCwgMzkuOTYxNjU1XSwgInR5cGUiOiAiUG9pbnQifSwgImlkIjogIjQwIiwgInByb3BlcnRpZXMiOiB7ImFtb3VudCI6ICIyNC42MCIsICJjb3VudHkiOiAiQk9VTERFUiIsICJkYXRhX3NvdXJjZSI6ICJDby4gRGl2aXNpb24gb2YgV2F0ZXIgUmVzb3VyY2VzIiwgImRhdGVfdGltZSI6ICIyMDIwLTA0LTAxVDEwOjE1OjAwLjAwMCIsICJkaXYiOiAiMSIsICJkd3JfYWJicmV2IjogIkJPQ01JRENPIiwgImZsYWciOiAiSWNlIiwgImh0dHBfbGlua2FnZS51cmwiOiAiaHR0cHM6Ly9kd3Iuc3RhdGUuY28udXMvU3VyZmFjZVdhdGVyL2RhdGEvZGV0YWlsX2dyYXBoLmFzcHg/SUQ9Qk9DTUlEQ09cdTAwMjZNVFlQRT1ESVNDSFJHIiwgImxvY2F0aW9uLmxhdGl0dWRlIjogMzkuOTYxNjU1LCAibG9jYXRpb24ubG9uZ2l0dWRlIjogLTEwNS41MDQ0NCwgImxvY2F0aW9uLm5lZWRzX3JlY29kaW5nIjogZmFsc2UsICJzdGFnZSI6ICIxLjE0IiwgInN0YXRpb25fbmFtZSI6ICJNSURETEUgQk9VTERFUiBDUkVFSyBBVCBORURFUkxBTkQsIENPLiIsICJzdGF0aW9uX3N0YXR1cyI6ICJBY3RpdmUiLCAic3RhdGlvbl90eXBlIjogIlN0cmVhbSIsICJ1c2dzX3N0YXRpb25faWQiOiAiMDY3MjU1MDAiLCAidmFyaWFibGUiOiAiRElTQ0hSRyIsICJ3ZCI6ICI2In0sICJ0eXBlIjogIkZlYXR1cmUifSwgeyJiYm94IjogWy0xMDUuMjUwOTI3LCA0MC4yMTEwODMsIC0xMDUuMjUwOTI3LCA0MC4yMTEwODNdLCAiZ2VvbWV0cnkiOiB7ImNvb3JkaW5hdGVzIjogWy0xMDUuMjUwOTI3LCA0MC4yMTEwODNdLCAidHlwZSI6ICJQb2ludCJ9LCAiaWQiOiAiNDEiLCAicHJvcGVydGllcyI6IHsiYW1vdW50IjogIjAuMDAiLCAiY291bnR5IjogIkJPVUxERVIiLCAiZGF0YV9zb3VyY2UiOiAiQ29vcGVyYXRpdmUgUHJvZ3JhbSBvZiBDRFdSLCBOQ1dDRCBcdTAwMjYgU1ZMSFdDRCIsICJkYXRlX3RpbWUiOiAiMjAyMC0wNC0wMVQwOTowMDowMC4wMDAiLCAiZGl2IjogIjEiLCAiZHdyX2FiYnJldiI6ICJTV0VESVRDTyIsICJmbGFnIjogbnVsbCwgImh0dHBfbGlua2FnZS51cmwiOiAiaHR0cHM6Ly9kd3Iuc3RhdGUuY28udXMvU3VyZmFjZVdhdGVyL2RhdGEvZGV0YWlsX2dyYXBoLmFzcHg/SUQ9U1dFRElUQ09cdTAwMjZNVFlQRT1ESVNDSFJHIiwgImxvY2F0aW9uLmxhdGl0dWRlIjogNDAuMjExMDgzLCAibG9jYXRpb24ubG9uZ2l0dWRlIjogLTEwNS4yNTA5MjcsICJsb2NhdGlvbi5uZWVkc19yZWNvZGluZyI6IGZhbHNlLCAic3RhZ2UiOiAiLTAuMDYiLCAic3RhdGlvbl9uYW1lIjogIlNXRURFIERJVENIIiwgInN0YXRpb25fc3RhdHVzIjogIkFjdGl2ZSIsICJzdGF0aW9uX3R5cGUiOiAiRGl2ZXJzaW9uIiwgInVzZ3Nfc3RhdGlvbl9pZCI6IG51bGwsICJ2YXJpYWJsZSI6ICJESVNDSFJHIiwgIndkIjogIjUifSwgInR5cGUiOiAiRmVhdHVyZSJ9LCB7ImJib3giOiBbLTEwNS4xODkxMzIsIDQwLjE4NzUyNCwgLTEwNS4xODkxMzIsIDQwLjE4NzUyNF0sICJnZW9tZXRyeSI6IHsiY29vcmRpbmF0ZXMiOiBbLTEwNS4xODkxMzIsIDQwLjE4NzUyNF0sICJ0eXBlIjogIlBvaW50In0sICJpZCI6ICI0MiIsICJwcm9wZXJ0aWVzIjogeyJhbW91bnQiOiAiMC4wMCIsICJjb3VudHkiOiAiQk9VTERFUiIsICJkYXRhX3NvdXJjZSI6ICJDb29wZXJhdGl2ZSBQcm9ncmFtIG9mIENEV1IsIE5DV0NEIFx1MDAyNiBTVkxIV0NEIiwgImRhdGVfdGltZSI6ICIyMDIwLTA0LTAxVDEwOjAwOjAwLjAwMCIsICJkaXYiOiAiMSIsICJkd3JfYWJicmV2IjogIlJVTllPTkNPIiwgImZsYWciOiBudWxsLCAiaHR0cF9saW5rYWdlLnVybCI6ICJodHRwczovL2R3ci5zdGF0ZS5jby51cy9TdXJmYWNlV2F0ZXIvZGF0YS9kZXRhaWxfZ3JhcGguYXNweD9JRD1SVU5ZT05DT1x1MDAyNk1UWVBFPURJU0NIUkciLCAibG9jYXRpb24ubGF0aXR1ZGUiOiA0MC4xODc1MjQsICJsb2NhdGlvbi5sb25naXR1ZGUiOiAtMTA1LjE4OTEzMiwgImxvY2F0aW9uLm5lZWRzX3JlY29kaW5nIjogZmFsc2UsICJzdGFnZSI6ICI1MC43OCIsICJzdGF0aW9uX25hbWUiOiAiUlVOWU9OIERJVENIIiwgInN0YXRpb25fc3RhdHVzIjogIkFjdGl2ZSIsICJzdGF0aW9uX3R5cGUiOiAiRGl2ZXJzaW9uIiwgInVzZ3Nfc3RhdGlvbl9pZCI6IG51bGwsICJ2YXJpYWJsZSI6ICJESVNDSFJHIiwgIndkIjogIjUifSwgInR5cGUiOiAiRmVhdHVyZSJ9LCB7ImJib3giOiBbLTEwNS4xOTY3NzUsIDQwLjE4MTg4LCAtMTA1LjE5Njc3NSwgNDAuMTgxODhdLCAiZ2VvbWV0cnkiOiB7ImNvb3JkaW5hdGVzIjogWy0xMDUuMTk2Nzc1LCA0MC4xODE4OF0sICJ0eXBlIjogIlBvaW50In0sICJpZCI6ICI0MyIsICJwcm9wZXJ0aWVzIjogeyJhbW91bnQiOiAiMC4wMCIsICJjb3VudHkiOiAiQk9VTERFUiIsICJkYXRhX3NvdXJjZSI6ICJDb29wZXJhdGl2ZSBQcm9ncmFtIG9mIENEV1IsIE5DV0NEIFx1MDAyNiBTVkxIV0NEIiwgImRhdGVfdGltZSI6ICIyMDIwLTA0LTAxVDA5OjQ1OjAwLjAwMCIsICJkaXYiOiAiMSIsICJkd3JfYWJicmV2IjogIkRBVkRPV0NPIiwgImZsYWciOiBudWxsLCAiaHR0cF9saW5rYWdlLnVybCI6ICJodHRwczovL2R3ci5zdGF0ZS5jby51cy9TdXJmYWNlV2F0ZXIvZGF0YS9kZXRhaWxfZ3JhcGguYXNweD9JRD1EQVZET1dDT1x1MDAyNk1UWVBFPURJU0NIUkciLCAibG9jYXRpb24ubGF0aXR1ZGUiOiA0MC4xODE4OCwgImxvY2F0aW9uLmxvbmdpdHVkZSI6IC0xMDUuMTk2Nzc1LCAibG9jYXRpb24ubmVlZHNfcmVjb2RpbmciOiBmYWxzZSwgInN0YWdlIjogbnVsbCwgInN0YXRpb25fbmFtZSI6ICJEQVZJUyBBTkQgRE9XTklORyBESVRDSCIsICJzdGF0aW9uX3N0YXR1cyI6ICJBY3RpdmUiLCAic3RhdGlvbl90eXBlIjogIkRpdmVyc2lvbiIsICJ1c2dzX3N0YXRpb25faWQiOiBudWxsLCAidmFyaWFibGUiOiAiRElTQ0hSRyIsICJ3ZCI6ICI1In0sICJ0eXBlIjogIkZlYXR1cmUifSwgeyJiYm94IjogWy0xMDUuMzI2MjUsIDQwLjAxODY2NywgLTEwNS4zMjYyNSwgNDAuMDE4NjY3XSwgImdlb21ldHJ5IjogeyJjb29yZGluYXRlcyI6IFstMTA1LjMyNjI1LCA0MC4wMTg2NjddLCAidHlwZSI6ICJQb2ludCJ9LCAiaWQiOiAiNDQiLCAicHJvcGVydGllcyI6IHsiYW1vdW50IjogIjYuMDQiLCAiY291bnR5IjogIkJPVUxERVIiLCAiZGF0YV9zb3VyY2UiOiAiVS5TLiBHZW9sb2dpY2FsIFN1cnZleSIsICJkYXRlX3RpbWUiOiAiMjAyMC0wNC0wMVQxMDo1MDowMC4wMDAiLCAiZGl2IjogIjEiLCAiZHdyX2FiYnJldiI6ICJGT1VPUk9DTyIsICJmbGFnIjogbnVsbCwgImh0dHBfbGlua2FnZS51cmwiOiAiaHR0cHM6Ly93YXRlcmRhdGEudXNncy5nb3Yvbndpcy91dj8wNjcyNzUwMCIsICJsb2NhdGlvbi5sYXRpdHVkZSI6IDQwLjAxODY2NywgImxvY2F0aW9uLmxvbmdpdHVkZSI6IC0xMDUuMzI2MjUsICJsb2NhdGlvbi5uZWVkc19yZWNvZGluZyI6IGZhbHNlLCAic3RhZ2UiOiBudWxsLCAic3RhdGlvbl9uYW1lIjogIkZPVVJNSUxFIENSRUVLIEFUIE9ST0RFTEwsIENPIiwgInN0YXRpb25fc3RhdHVzIjogIkFjdGl2ZSIsICJzdGF0aW9uX3R5cGUiOiAiU3RyZWFtIiwgInVzZ3Nfc3RhdGlvbl9pZCI6ICIwNjcyNzUwMCIsICJ2YXJpYWJsZSI6ICJESVNDSFJHIiwgIndkIjogIjYifSwgInR5cGUiOiAiRmVhdHVyZSJ9LCB7ImJib3giOiBbLTEwNS4yMDkyODIsIDQwLjE4ODU3OSwgLTEwNS4yMDkyODIsIDQwLjE4ODU3OV0sICJnZW9tZXRyeSI6IHsiY29vcmRpbmF0ZXMiOiBbLTEwNS4yMDkyODIsIDQwLjE4ODU3OV0sICJ0eXBlIjogIlBvaW50In0sICJpZCI6ICI0NSIsICJwcm9wZXJ0aWVzIjogeyJhbW91bnQiOiAiMC4wMCIsICJjb3VudHkiOiAiQk9VTERFUiIsICJkYXRhX3NvdXJjZSI6ICJDb29wZXJhdGl2ZSBQcm9ncmFtIG9mIENEV1IsIE5DV0NEIFx1MDAyNiBTVkxIV0NEIiwgImRhdGVfdGltZSI6ICIyMDIwLTA0LTAxVDA5OjQ1OjAwLjAwMCIsICJkaXYiOiAiMSIsICJkd3JfYWJicmV2IjogIkpBTURJVENPIiwgImZsYWciOiBudWxsLCAiaHR0cF9saW5rYWdlLnVybCI6ICJodHRwczovL2R3ci5zdGF0ZS5jby51cy9TdXJmYWNlV2F0ZXIvZGF0YS9kZXRhaWxfZ3JhcGguYXNweD9JRD1KQU1ESVRDT1x1MDAyNk1UWVBFPURJU0NIUkciLCAibG9jYXRpb24ubGF0aXR1ZGUiOiA0MC4xODg1NzksICJsb2NhdGlvbi5sb25naXR1ZGUiOiAtMTA1LjIwOTI4MiwgImxvY2F0aW9uLm5lZWRzX3JlY29kaW5nIjogZmFsc2UsICJzdGFnZSI6IG51bGwsICJzdGF0aW9uX25hbWUiOiAiSkFNRVMgRElUQ0giLCAic3RhdGlvbl9zdGF0dXMiOiAiQWN0aXZlIiwgInN0YXRpb25fdHlwZSI6ICJEaXZlcnNpb24iLCAidXNnc19zdGF0aW9uX2lkIjogbnVsbCwgInZhcmlhYmxlIjogIkRJU0NIUkciLCAid2QiOiAiNSJ9LCAidHlwZSI6ICJGZWF0dXJlIn0sIHsiYmJveCI6IFstMTA1LjE5MzA0OCwgNDAuMDUzMDM1LCAtMTA1LjE5MzA0OCwgNDAuMDUzMDM1XSwgImdlb21ldHJ5IjogeyJjb29yZGluYXRlcyI6IFstMTA1LjE5MzA0OCwgNDAuMDUzMDM1XSwgInR5cGUiOiAiUG9pbnQifSwgImlkIjogIjQ2IiwgInByb3BlcnRpZXMiOiB7ImFtb3VudCI6ICIzLjQzIiwgImNvdW50eSI6ICJCT1VMREVSIiwgImRhdGFfc291cmNlIjogIk5vcnRoZXJuIENvbG9yYWRvIFdhdGVyIENvbnNlcnZhbmN5IERpc3RyaWN0IiwgImRhdGVfdGltZSI6ICIyMDIwLTA0LTAxVDEwOjAwOjAwLjAwMCIsICJkaXYiOiAiMSIsICJkd3JfYWJicmV2IjogIkJDU0NCQ0NPIiwgImZsYWciOiBudWxsLCAiaHR0cF9saW5rYWdlLnVybCI6ICJodHRwOi8vd3d3Lm5vcnRoZXJud2F0ZXIub3JnL1dhdGVyUHJvamVjdHMvRWFzdFNsb3BlV2F0ZXJEYXRhLmFzcHgiLCAibG9jYXRpb24ubGF0aXR1ZGUiOiA0MC4wNTMwMzUsICJsb2NhdGlvbi5sb25naXR1ZGUiOiAtMTA1LjE5MzA0OCwgImxvY2F0aW9uLm5lZWRzX3JlY29kaW5nIjogZmFsc2UsICJzdGFnZSI6ICIwLjIyIiwgInN0YXRpb25fbmFtZSI6ICJCT1VMREVSIENSRUVLIFNVUFBMWSBDQU5BTCBUTyBCT1VMREVSIENSRUVLIE5FQVIgQk9VTERFUiIsICJzdGF0aW9uX3N0YXR1cyI6ICJBY3RpdmUiLCAic3RhdGlvbl90eXBlIjogIkRpdmVyc2lvbiIsICJ1c2dzX3N0YXRpb25faWQiOiAiRVMxOTE3IiwgInZhcmlhYmxlIjogIkRJU0NIUkciLCAid2QiOiAiNiJ9LCAidHlwZSI6ICJGZWF0dXJlIn0sIHsiYmJveCI6IFstMTA1LjE3ODE0NSwgNDAuMTc3NDIzLCAtMTA1LjE3ODE0NSwgNDAuMTc3NDIzXSwgImdlb21ldHJ5IjogeyJjb29yZGluYXRlcyI6IFstMTA1LjE3ODE0NSwgNDAuMTc3NDIzXSwgInR5cGUiOiAiUG9pbnQifSwgImlkIjogIjQ3IiwgInByb3BlcnRpZXMiOiB7ImFtb3VudCI6ICIyLjI1IiwgImNvdW50eSI6ICJCT1VMREVSIiwgImRhdGFfc291cmNlIjogIkNvLiBEaXZpc2lvbiBvZiBXYXRlciBSZXNvdXJjZXMiLCAiZGF0ZV90aW1lIjogIjIwMjAtMDQtMDFUMTA6NDU6MDAuMDAwIiwgImRpdiI6ICIxIiwgImR3cl9hYmJyZXYiOiAiU1ZDSEdJQ08iLCAiZmxhZyI6IG51bGwsICJodHRwX2xpbmthZ2UudXJsIjogImh0dHBzOi8vZHdyLnN0YXRlLmNvLnVzL1N1cmZhY2VXYXRlci9kYXRhL2RldGFpbF9ncmFwaC5hc3B4P0lEPVNWQ0hHSUNPXHUwMDI2TVRZUEU9RElTQ0hSRyIsICJsb2NhdGlvbi5sYXRpdHVkZSI6IDQwLjE3NzQyMywgImxvY2F0aW9uLmxvbmdpdHVkZSI6IC0xMDUuMTc4MTQ1LCAibG9jYXRpb24ubmVlZHNfcmVjb2RpbmciOiBmYWxzZSwgInN0YWdlIjogIjEuNTAiLCAic3RhdGlvbl9uYW1lIjogIlNBSU5UIFZSQUlOIENSRUVLIEFUIEhZR0lFTkUsIENPIiwgInN0YXRpb25fc3RhdHVzIjogIkFjdGl2ZSIsICJzdGF0aW9uX3R5cGUiOiAiU3RyZWFtIiwgInVzZ3Nfc3RhdGlvbl9pZCI6IG51bGwsICJ2YXJpYWJsZSI6ICJESVNDSFJHIiwgIndkIjogIjUifSwgInR5cGUiOiAiRmVhdHVyZSJ9LCB7ImJib3giOiBbLTEwNS4xNzQ5NTcsIDQwLjI1ODM2NywgLTEwNS4xNzQ5NTcsIDQwLjI1ODM2N10sICJnZW9tZXRyeSI6IHsiY29vcmRpbmF0ZXMiOiBbLTEwNS4xNzQ5NTcsIDQwLjI1ODM2N10sICJ0eXBlIjogIlBvaW50In0sICJpZCI6ICI0OCIsICJwcm9wZXJ0aWVzIjogeyJhbW91bnQiOiAiMTEuMzAiLCAiY291bnR5IjogIkJPVUxERVIiLCAiZGF0YV9zb3VyY2UiOiAiQ28uIERpdmlzaW9uIG9mIFdhdGVyIFJlc291cmNlcyIsICJkYXRlX3RpbWUiOiAiMjAyMC0wNC0wMVQxMDozMDowMC4wMDAiLCAiZGl2IjogIjEiLCAiZHdyX2FiYnJldiI6ICJCT1VMQVJDTyIsICJmbGFnIjogbnVsbCwgImh0dHBfbGlua2FnZS51cmwiOiAiaHR0cHM6Ly9kd3Iuc3RhdGUuY28udXMvU3VyZmFjZVdhdGVyL2RhdGEvZGV0YWlsX2dyYXBoLmFzcHg/SUQ9Qk9VTEFSQ09cdTAwMjZNVFlQRT1ESVNDSFJHIiwgImxvY2F0aW9uLmxhdGl0dWRlIjogNDAuMjU4MzY3LCAibG9jYXRpb24ubG9uZ2l0dWRlIjogLTEwNS4xNzQ5NTcsICJsb2NhdGlvbi5uZWVkc19yZWNvZGluZyI6IGZhbHNlLCAic3RhZ2UiOiAiMC4zNiIsICJzdGF0aW9uX25hbWUiOiAiQk9VTERFUi1MQVJJTUVSIERJVENIIE5FQVIgQkVSVEhPVUQiLCAic3RhdGlvbl9zdGF0dXMiOiAiQWN0aXZlIiwgInN0YXRpb25fdHlwZSI6ICJEaXZlcnNpb24iLCAidXNnc19zdGF0aW9uX2lkIjogbnVsbCwgInZhcmlhYmxlIjogIkRJU0NIUkciLCAid2QiOiAiNCJ9LCAidHlwZSI6ICJGZWF0dXJlIn0sIHsiYmJveCI6IFstMTA1LjA5MTA1OSwgNDAuMDk2MDMsIC0xMDUuMDkxMDU5LCA0MC4wOTYwM10sICJnZW9tZXRyeSI6IHsiY29vcmRpbmF0ZXMiOiBbLTEwNS4wOTEwNTksIDQwLjA5NjAzXSwgInR5cGUiOiAiUG9pbnQifSwgImlkIjogIjQ5IiwgInByb3BlcnRpZXMiOiB7ImFtb3VudCI6ICIyMi4xMCIsICJjb3VudHkiOiAiQk9VTERFUiIsICJkYXRhX3NvdXJjZSI6ICJDby4gRGl2aXNpb24gb2YgV2F0ZXIgUmVzb3VyY2VzIiwgImRhdGVfdGltZSI6ICIyMDIwLTA0LTAxVDEwOjQ1OjAwLjAwMCIsICJkaXYiOiAiMSIsICJkd3JfYWJicmV2IjogIlBOTUFJTkNPIiwgImZsYWciOiBudWxsLCAiaHR0cF9saW5rYWdlLnVybCI6ICJodHRwczovL2R3ci5zdGF0ZS5jby51cy9TdXJmYWNlV2F0ZXIvZGF0YS9kZXRhaWxfZ3JhcGguYXNweD9JRD1QTk1BSU5DT1x1MDAyNk1UWVBFPURJU0NIUkciLCAibG9jYXRpb24ubGF0aXR1ZGUiOiA0MC4wOTYwMywgImxvY2F0aW9uLmxvbmdpdHVkZSI6IC0xMDUuMDkxMDU5LCAibG9jYXRpb24ubmVlZHNfcmVjb2RpbmciOiBmYWxzZSwgInN0YWdlIjogbnVsbCwgInN0YXRpb25fbmFtZSI6ICJQQU5BTUEgUkVTRVJWT0lSIElOTEVUIiwgInN0YXRpb25fc3RhdHVzIjogIkFjdGl2ZSIsICJzdGF0aW9uX3R5cGUiOiAiU3RyZWFtIiwgInVzZ3Nfc3RhdGlvbl9pZCI6IG51bGwsICJ2YXJpYWJsZSI6ICJESVNDSFJHIiwgIndkIjogIjYifSwgInR5cGUiOiAiRmVhdHVyZSJ9LCB7ImJib3giOiBbLTEwNS4yNTE4MjYsIDQwLjIxMjUwNSwgLTEwNS4yNTE4MjYsIDQwLjIxMjUwNV0sICJnZW9tZXRyeSI6IHsiY29vcmRpbmF0ZXMiOiBbLTEwNS4yNTE4MjYsIDQwLjIxMjUwNV0sICJ0eXBlIjogIlBvaW50In0sICJpZCI6ICI1MCIsICJwcm9wZXJ0aWVzIjogeyJhbW91bnQiOiAiMC4yNyIsICJjb3VudHkiOiAiQk9VTERFUiIsICJkYXRhX3NvdXJjZSI6ICJDb29wZXJhdGl2ZSBQcm9ncmFtIG9mIENEV1IsIE5DV0NEIFx1MDAyNiBTVkxIV0NEIiwgImRhdGVfdGltZSI6ICIyMDIwLTA0LTAxVDEwOjAwOjAwLjAwMCIsICJkaXYiOiAiMSIsICJkd3JfYWJicmV2IjogIlBBTERJVENPIiwgImZsYWciOiBudWxsLCAiaHR0cF9saW5rYWdlLnVybCI6ICJodHRwczovL2R3ci5zdGF0ZS5jby51cy9TdXJmYWNlV2F0ZXIvZGF0YS9kZXRhaWxfZ3JhcGguYXNweD9JRD1QQUxESVRDT1x1MDAyNk1UWVBFPURJU0NIUkciLCAibG9jYXRpb24ubGF0aXR1ZGUiOiA0MC4yMTI1MDUsICJsb2NhdGlvbi5sb25naXR1ZGUiOiAtMTA1LjI1MTgyNiwgImxvY2F0aW9uLm5lZWRzX3JlY29kaW5nIjogZmFsc2UsICJzdGFnZSI6ICIwLjA1IiwgInN0YXRpb25fbmFtZSI6ICJQQUxNRVJUT04gRElUQ0giLCAic3RhdGlvbl9zdGF0dXMiOiAiQWN0aXZlIiwgInN0YXRpb25fdHlwZSI6ICJEaXZlcnNpb24iLCAidXNnc19zdGF0aW9uX2lkIjogbnVsbCwgInZhcmlhYmxlIjogIkRJU0NIUkciLCAid2QiOiAiNSJ9LCAidHlwZSI6ICJGZWF0dXJlIn0sIHsiYmJveCI6IFstMTA1LjI1OTc5NSwgNDAuMjE5MDQ2LCAtMTA1LjI1OTc5NSwgNDAuMjE5MDQ2XSwgImdlb21ldHJ5IjogeyJjb29yZGluYXRlcyI6IFstMTA1LjI1OTc5NSwgNDAuMjE5MDQ2XSwgInR5cGUiOiAiUG9pbnQifSwgImlkIjogIjUxIiwgInByb3BlcnRpZXMiOiB7ImFtb3VudCI6ICIwLjAwIiwgImNvdW50eSI6ICJCT1VMREVSIiwgImRhdGFfc291cmNlIjogIkNvb3BlcmF0aXZlIFByb2dyYW0gb2YgQ0RXUiwgTkNXQ0QgXHUwMDI2IFNWTEhXQ0QiLCAiZGF0ZV90aW1lIjogIjIwMjAtMDQtMDFUMDk6NDU6MDAuMDAwIiwgImRpdiI6ICIxIiwgImR3cl9hYmJyZXYiOiAiU1VQRElUQ08iLCAiZmxhZyI6IG51bGwsICJodHRwX2xpbmthZ2UudXJsIjogImh0dHBzOi8vZHdyLnN0YXRlLmNvLnVzL1N1cmZhY2VXYXRlci9kYXRhL2RldGFpbF9ncmFwaC5hc3B4P0lEPVNVUERJVENPXHUwMDI2TVRZUEU9RElTQ0hSRyIsICJsb2NhdGlvbi5sYXRpdHVkZSI6IDQwLjIxOTA0NiwgImxvY2F0aW9uLmxvbmdpdHVkZSI6IC0xMDUuMjU5Nzk1LCAibG9jYXRpb24ubmVlZHNfcmVjb2RpbmciOiBmYWxzZSwgInN0YWdlIjogIjAuMDAiLCAic3RhdGlvbl9uYW1lIjogIlNVUFBMWSBESVRDSCIsICJzdGF0aW9uX3N0YXR1cyI6ICJBY3RpdmUiLCAic3RhdGlvbl90eXBlIjogIkRpdmVyc2lvbiIsICJ1c2dzX3N0YXRpb25faWQiOiBudWxsLCAidmFyaWFibGUiOiAiRElTQ0hSRyIsICJ3ZCI6ICI1In0sICJ0eXBlIjogIkZlYXR1cmUifSwgeyJiYm94IjogWy0xMDUuMzA4NDMyLCAzOS45MzE4MTMsIC0xMDUuMzA4NDMyLCAzOS45MzE4MTNdLCAiZ2VvbWV0cnkiOiB7ImNvb3JkaW5hdGVzIjogWy0xMDUuMzA4NDMyLCAzOS45MzE4MTNdLCAidHlwZSI6ICJQb2ludCJ9LCAiaWQiOiAiNTIiLCAicHJvcGVydGllcyI6IHsiYW1vdW50IjogIjAuMDAiLCAiY291bnR5IjogIkJPVUxERVIiLCAiZGF0YV9zb3VyY2UiOiAiQ28uIERpdmlzaW9uIG9mIFdhdGVyIFJlc291cmNlcyIsICJkYXRlX3RpbWUiOiAiMjAyMC0wNC0wMVQxMDozMDowMC4wMDAiLCAiZGl2IjogIjEiLCAiZHdyX2FiYnJldiI6ICJCT1NERUxDTyIsICJmbGFnIjogbnVsbCwgImh0dHBfbGlua2FnZS51cmwiOiAiaHR0cHM6Ly9kd3Iuc3RhdGUuY28udXMvU3VyZmFjZVdhdGVyL2RhdGEvZGV0YWlsX2dyYXBoLmFzcHg/SUQ9Qk9TREVMQ09cdTAwMjZNVFlQRT1ESVNDSFJHIiwgImxvY2F0aW9uLmxhdGl0dWRlIjogMzkuOTMxODEzLCAibG9jYXRpb24ubG9uZ2l0dWRlIjogLTEwNS4zMDg0MzIsICJsb2NhdGlvbi5uZWVkc19yZWNvZGluZyI6IGZhbHNlLCAic3RhZ2UiOiAiLTEuNzAiLCAic3RhdGlvbl9uYW1lIjogIlNPVVRIIEJPVUxERVIgQ1JFRUsgRElWRVJTSU9OIE5FQVIgRUxET1JBRE8gU1BSSU5HUyIsICJzdGF0aW9uX3N0YXR1cyI6ICJBY3RpdmUiLCAic3RhdGlvbl90eXBlIjogIkRpdmVyc2lvbiIsICJ1c2dzX3N0YXRpb25faWQiOiBudWxsLCAidmFyaWFibGUiOiAiRElTQ0hSRyIsICJ3ZCI6ICI2In0sICJ0eXBlIjogIkZlYXR1cmUifSwgeyJiYm94IjogWy0xMDUuMTg5MTkxLCA0MC4xODc1NzgsIC0xMDUuMTg5MTkxLCA0MC4xODc1NzhdLCAiZ2VvbWV0cnkiOiB7ImNvb3JkaW5hdGVzIjogWy0xMDUuMTg5MTkxLCA0MC4xODc1NzhdLCAidHlwZSI6ICJQb2ludCJ9LCAiaWQiOiAiNTMiLCAicHJvcGVydGllcyI6IHsiYW1vdW50IjogIjI4MTkuNjgiLCAiY291bnR5IjogIkJPVUxERVIiLCAiZGF0YV9zb3VyY2UiOiAiQ29vcGVyYXRpdmUgUHJvZ3JhbSBvZiBDRFdSLCBOQ1dDRCBcdTAwMjYgU1ZMSFdDRCIsICJkYXRlX3RpbWUiOiAiMjAyMC0wNC0wMVQxMDowMDowMC4wMDAiLCAiZGl2IjogIjEiLCAiZHdyX2FiYnJldiI6ICJERU5UQVlDTyIsICJmbGFnIjogbnVsbCwgImh0dHBfbGlua2FnZS51cmwiOiAiaHR0cHM6Ly9kd3Iuc3RhdGUuY28udXMvU3VyZmFjZVdhdGVyL2RhdGEvZGV0YWlsX2dyYXBoLmFzcHg/SUQ9REVOVEFZQ09cdTAwMjZNVFlQRT1ESVNDSFJHIiwgImxvY2F0aW9uLmxhdGl0dWRlIjogNDAuMTg3NTc4LCAibG9jYXRpb24ubG9uZ2l0dWRlIjogLTEwNS4xODkxOTEsICJsb2NhdGlvbi5uZWVkc19yZWNvZGluZyI6IGZhbHNlLCAic3RhZ2UiOiAiNjIuMzEiLCAic3RhdGlvbl9uYW1lIjogIkRFTklPIFRBWUxPUiBESVRDSCIsICJzdGF0aW9uX3N0YXR1cyI6ICJBY3RpdmUiLCAic3RhdGlvbl90eXBlIjogIkRpdmVyc2lvbiIsICJ1c2dzX3N0YXRpb25faWQiOiBudWxsLCAidmFyaWFibGUiOiAiRElTQ0hSRyIsICJ3ZCI6ICI1In0sICJ0eXBlIjogIkZlYXR1cmUifSwgeyJiYm94IjogWy0xMDUuMzY0OTE3LCA0MC4wNDIwMjgsIC0xMDUuMzY0OTE3LCA0MC4wNDIwMjhdLCAiZ2VvbWV0cnkiOiB7ImNvb3JkaW5hdGVzIjogWy0xMDUuMzY0OTE3LCA0MC4wNDIwMjhdLCAidHlwZSI6ICJQb2ludCJ9LCAiaWQiOiAiNTQiLCAicHJvcGVydGllcyI6IHsiYW1vdW50IjogbnVsbCwgImNvdW50eSI6ICJCT1VMREVSIiwgImRhdGFfc291cmNlIjogIlUuUy4gR2VvbG9naWNhbCBTdXJ2ZXkiLCAiZGF0ZV90aW1lIjogIjE5OTktMDktMzBUMDA6MDA6MDAuMDAwIiwgImRpdiI6ICIxIiwgImR3cl9hYmJyZXYiOiAiRlJNTE1SQ08iLCAiZmxhZyI6IG51bGwsICJodHRwX2xpbmthZ2UudXJsIjogImh0dHBzOi8vd2F0ZXJkYXRhLnVzZ3MuZ292L253aXMvdXY/MDY3Mjc0MTAiLCAibG9jYXRpb24ubGF0aXR1ZGUiOiA0MC4wNDIwMjgsICJsb2NhdGlvbi5sb25naXR1ZGUiOiAtMTA1LjM2NDkxNywgImxvY2F0aW9uLm5lZWRzX3JlY29kaW5nIjogZmFsc2UsICJzdGFnZSI6IG51bGwsICJzdGF0aW9uX25hbWUiOiAiRk9VUk1JTEUgQ1JFRUsgQVQgTE9HQU4gTUlMTCBST0FEIE5FQVIgQ1JJU01BTiwgQ08iLCAic3RhdGlvbl9zdGF0dXMiOiAiQWN0aXZlIiwgInN0YXRpb25fdHlwZSI6ICJTdHJlYW0iLCAidXNnc19zdGF0aW9uX2lkIjogIjA2NzI3NDEwIiwgInZhcmlhYmxlIjogIkRJU0NIUkciLCAid2QiOiAiNiJ9LCAidHlwZSI6ICJGZWF0dXJlIn0sIHsiYmJveCI6IFstMTA1LjE3ODU2NywgNDAuMTc3MDgsIC0xMDUuMTc4NTY3LCA0MC4xNzcwOF0sICJnZW9tZXRyeSI6IHsiY29vcmRpbmF0ZXMiOiBbLTEwNS4xNzg1NjcsIDQwLjE3NzA4XSwgInR5cGUiOiAiUG9pbnQifSwgImlkIjogIjU1IiwgInByb3BlcnRpZXMiOiB7ImFtb3VudCI6ICIxLjI5IiwgImNvdW50eSI6ICJCT1VMREVSIiwgImRhdGFfc291cmNlIjogIkNvb3BlcmF0aXZlIFNEUiBQcm9ncmFtIG9mIENEV1IgXHUwMDI2IE5DV0NEIiwgImRhdGVfdGltZSI6ICIyMDIwLTA0LTAxVDEwOjAwOjAwLjAwMCIsICJkaXYiOiAiMSIsICJkd3JfYWJicmV2IjogIlBDS1BFTENPIiwgImZsYWciOiBudWxsLCAiaHR0cF9saW5rYWdlLnVybCI6ICJodHRwczovL2R3ci5zdGF0ZS5jby51cy9TdXJmYWNlV2F0ZXIvZGF0YS9kZXRhaWxfZ3JhcGguYXNweD9JRD1QQ0tQRUxDT1x1MDAyNk1UWVBFPURJU0NIUkciLCAibG9jYXRpb24ubGF0aXR1ZGUiOiA0MC4xNzcwOCwgImxvY2F0aW9uLmxvbmdpdHVkZSI6IC0xMDUuMTc4NTY3LCAibG9jYXRpb24ubmVlZHNfcmVjb2RpbmciOiBmYWxzZSwgInN0YWdlIjogIjAuMTYiLCAic3RhdGlvbl9uYW1lIjogIlBFQ0sgUEVMTEEgQ0xPVkVSIERJVENIIiwgInN0YXRpb25fc3RhdHVzIjogIkFjdGl2ZSIsICJzdGF0aW9uX3R5cGUiOiAiRGl2ZXJzaW9uIiwgInVzZ3Nfc3RhdGlvbl9pZCI6IG51bGwsICJ2YXJpYWJsZSI6ICJESVNDSFJHIiwgIndkIjogIjUifSwgInR5cGUiOiAiRmVhdHVyZSJ9LCB7ImJib3giOiBbLTEwNS4zNTczMDgsIDM5Ljk0NzcwNCwgLTEwNS4zNTczMDgsIDM5Ljk0NzcwNF0sICJnZW9tZXRyeSI6IHsiY29vcmRpbmF0ZXMiOiBbLTEwNS4zNTczMDgsIDM5Ljk0NzcwNF0sICJ0eXBlIjogIlBvaW50In0sICJpZCI6ICI1NiIsICJwcm9wZXJ0aWVzIjogeyJhbW91bnQiOiAiMTE0MDEuMDAiLCAiY291bnR5IjogIkJPVUxERVIiLCAiZGF0YV9zb3VyY2UiOiAiQ28uIERpdmlzaW9uIG9mIFdhdGVyIFJlc291cmNlcyIsICJkYXRlX3RpbWUiOiAiMjAyMC0wNC0wMVQxMDozMDowMC4wMDAiLCAiZGl2IjogIjEiLCAiZHdyX2FiYnJldiI6ICJHUk9TUkVDTyIsICJmbGFnIjogbnVsbCwgImh0dHBfbGlua2FnZS51cmwiOiAiaHR0cHM6Ly9kd3Iuc3RhdGUuY28udXMvU3VyZmFjZVdhdGVyL2RhdGEvZGV0YWlsX2dyYXBoLmFzcHg/SUQ9R1JPU1JFQ09cdTAwMjZNVFlQRT1TVE9SQUdFIiwgImxvY2F0aW9uLmxhdGl0dWRlIjogMzkuOTQ3NzA0LCAibG9jYXRpb24ubG9uZ2l0dWRlIjogLTEwNS4zNTczMDgsICJsb2NhdGlvbi5uZWVkc19yZWNvZGluZyI6IGZhbHNlLCAic3RhZ2UiOiAiNzE3NS44MiIsICJzdGF0aW9uX25hbWUiOiAiR1JPU1MgUkVTRVJWT0lSICIsICJzdGF0aW9uX3N0YXR1cyI6ICJBY3RpdmUiLCAic3RhdGlvbl90eXBlIjogIlJlc2Vydm9pciIsICJ1c2dzX3N0YXRpb25faWQiOiBudWxsLCAidmFyaWFibGUiOiAiU1RPUkFHRSIsICJ3ZCI6ICI2In0sICJ0eXBlIjogIkZlYXR1cmUifV0sICJ0eXBlIjogIkZlYXR1cmVDb2xsZWN0aW9uIn0pOwogICAgICAgIAo8L3NjcmlwdD4=" style="position:absolute;width:100%;height:100%;left:0;top:0;border:none !important;" allowfullscreen webkitallowfullscreen mozallowfullscreen></iframe></div></div>





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



<div style="width:100%;"><div style="position:relative;width:100%;height:0;padding-bottom:60%;"><iframe src="data:text/html;charset=utf-8;base64,PCFET0NUWVBFIGh0bWw+CjxoZWFkPiAgICAKICAgIDxtZXRhIGh0dHAtZXF1aXY9ImNvbnRlbnQtdHlwZSIgY29udGVudD0idGV4dC9odG1sOyBjaGFyc2V0PVVURi04IiAvPgogICAgCiAgICAgICAgPHNjcmlwdD4KICAgICAgICAgICAgTF9OT19UT1VDSCA9IGZhbHNlOwogICAgICAgICAgICBMX0RJU0FCTEVfM0QgPSBmYWxzZTsKICAgICAgICA8L3NjcmlwdD4KICAgIAogICAgPHNjcmlwdCBzcmM9Imh0dHBzOi8vY2RuLmpzZGVsaXZyLm5ldC9ucG0vbGVhZmxldEAxLjUuMS9kaXN0L2xlYWZsZXQuanMiPjwvc2NyaXB0PgogICAgPHNjcmlwdCBzcmM9Imh0dHBzOi8vY29kZS5qcXVlcnkuY29tL2pxdWVyeS0xLjEyLjQubWluLmpzIj48L3NjcmlwdD4KICAgIDxzY3JpcHQgc3JjPSJodHRwczovL21heGNkbi5ib290c3RyYXBjZG4uY29tL2Jvb3RzdHJhcC8zLjIuMC9qcy9ib290c3RyYXAubWluLmpzIj48L3NjcmlwdD4KICAgIDxzY3JpcHQgc3JjPSJodHRwczovL2NkbmpzLmNsb3VkZmxhcmUuY29tL2FqYXgvbGlicy9MZWFmbGV0LmF3ZXNvbWUtbWFya2Vycy8yLjAuMi9sZWFmbGV0LmF3ZXNvbWUtbWFya2Vycy5qcyI+PC9zY3JpcHQ+CiAgICA8bGluayByZWw9InN0eWxlc2hlZXQiIGhyZWY9Imh0dHBzOi8vY2RuLmpzZGVsaXZyLm5ldC9ucG0vbGVhZmxldEAxLjUuMS9kaXN0L2xlYWZsZXQuY3NzIi8+CiAgICA8bGluayByZWw9InN0eWxlc2hlZXQiIGhyZWY9Imh0dHBzOi8vbWF4Y2RuLmJvb3RzdHJhcGNkbi5jb20vYm9vdHN0cmFwLzMuMi4wL2Nzcy9ib290c3RyYXAubWluLmNzcyIvPgogICAgPGxpbmsgcmVsPSJzdHlsZXNoZWV0IiBocmVmPSJodHRwczovL21heGNkbi5ib290c3RyYXBjZG4uY29tL2Jvb3RzdHJhcC8zLjIuMC9jc3MvYm9vdHN0cmFwLXRoZW1lLm1pbi5jc3MiLz4KICAgIDxsaW5rIHJlbD0ic3R5bGVzaGVldCIgaHJlZj0iaHR0cHM6Ly9tYXhjZG4uYm9vdHN0cmFwY2RuLmNvbS9mb250LWF3ZXNvbWUvNC42LjMvY3NzL2ZvbnQtYXdlc29tZS5taW4uY3NzIi8+CiAgICA8bGluayByZWw9InN0eWxlc2hlZXQiIGhyZWY9Imh0dHBzOi8vY2RuanMuY2xvdWRmbGFyZS5jb20vYWpheC9saWJzL0xlYWZsZXQuYXdlc29tZS1tYXJrZXJzLzIuMC4yL2xlYWZsZXQuYXdlc29tZS1tYXJrZXJzLmNzcyIvPgogICAgPGxpbmsgcmVsPSJzdHlsZXNoZWV0IiBocmVmPSJodHRwczovL3Jhd2Nkbi5naXRoYWNrLmNvbS9weXRob24tdmlzdWFsaXphdGlvbi9mb2xpdW0vbWFzdGVyL2ZvbGl1bS90ZW1wbGF0ZXMvbGVhZmxldC5hd2Vzb21lLnJvdGF0ZS5jc3MiLz4KICAgIDxzdHlsZT5odG1sLCBib2R5IHt3aWR0aDogMTAwJTtoZWlnaHQ6IDEwMCU7bWFyZ2luOiAwO3BhZGRpbmc6IDA7fTwvc3R5bGU+CiAgICA8c3R5bGU+I21hcCB7cG9zaXRpb246YWJzb2x1dGU7dG9wOjA7Ym90dG9tOjA7cmlnaHQ6MDtsZWZ0OjA7fTwvc3R5bGU+CiAgICAKICAgICAgICAgICAgPG1ldGEgbmFtZT0idmlld3BvcnQiIGNvbnRlbnQ9IndpZHRoPWRldmljZS13aWR0aCwKICAgICAgICAgICAgICAgIGluaXRpYWwtc2NhbGU9MS4wLCBtYXhpbXVtLXNjYWxlPTEuMCwgdXNlci1zY2FsYWJsZT1ubyIgLz4KICAgICAgICAgICAgPHN0eWxlPgogICAgICAgICAgICAgICAgI21hcF82YTEzZjZkNDI5YTM0MmJmYmQxYjlkMjRiZTc4NmFhMSB7CiAgICAgICAgICAgICAgICAgICAgcG9zaXRpb246IHJlbGF0aXZlOwogICAgICAgICAgICAgICAgICAgIHdpZHRoOiAxMDAuMCU7CiAgICAgICAgICAgICAgICAgICAgaGVpZ2h0OiAxMDAuMCU7CiAgICAgICAgICAgICAgICAgICAgbGVmdDogMC4wJTsKICAgICAgICAgICAgICAgICAgICB0b3A6IDAuMCU7CiAgICAgICAgICAgICAgICB9CiAgICAgICAgICAgIDwvc3R5bGU+CiAgICAgICAgCiAgICA8c2NyaXB0IHNyYz0iaHR0cHM6Ly9jZG5qcy5jbG91ZGZsYXJlLmNvbS9hamF4L2xpYnMvbGVhZmxldC5tYXJrZXJjbHVzdGVyLzEuMS4wL2xlYWZsZXQubWFya2VyY2x1c3Rlci5qcyI+PC9zY3JpcHQ+CiAgICA8bGluayByZWw9InN0eWxlc2hlZXQiIGhyZWY9Imh0dHBzOi8vY2RuanMuY2xvdWRmbGFyZS5jb20vYWpheC9saWJzL2xlYWZsZXQubWFya2VyY2x1c3Rlci8xLjEuMC9NYXJrZXJDbHVzdGVyLmNzcyIvPgogICAgPGxpbmsgcmVsPSJzdHlsZXNoZWV0IiBocmVmPSJodHRwczovL2NkbmpzLmNsb3VkZmxhcmUuY29tL2FqYXgvbGlicy9sZWFmbGV0Lm1hcmtlcmNsdXN0ZXIvMS4xLjAvTWFya2VyQ2x1c3Rlci5EZWZhdWx0LmNzcyIvPgo8L2hlYWQ+Cjxib2R5PiAgICAKICAgIAogICAgICAgICAgICA8ZGl2IGNsYXNzPSJmb2xpdW0tbWFwIiBpZD0ibWFwXzZhMTNmNmQ0MjlhMzQyYmZiZDFiOWQyNGJlNzg2YWExIiA+PC9kaXY+CiAgICAgICAgCjwvYm9keT4KPHNjcmlwdD4gICAgCiAgICAKICAgICAgICAgICAgdmFyIG1hcF82YTEzZjZkNDI5YTM0MmJmYmQxYjlkMjRiZTc4NmFhMSA9IEwubWFwKAogICAgICAgICAgICAgICAgIm1hcF82YTEzZjZkNDI5YTM0MmJmYmQxYjlkMjRiZTc4NmFhMSIsCiAgICAgICAgICAgICAgICB7CiAgICAgICAgICAgICAgICAgICAgY2VudGVyOiBbNDAuMDEsIC0xMDUuMjddLAogICAgICAgICAgICAgICAgICAgIGNyczogTC5DUlMuRVBTRzM4NTcsCiAgICAgICAgICAgICAgICAgICAgem9vbTogMTAsCiAgICAgICAgICAgICAgICAgICAgem9vbUNvbnRyb2w6IHRydWUsCiAgICAgICAgICAgICAgICAgICAgcHJlZmVyQ2FudmFzOiBmYWxzZSwKICAgICAgICAgICAgICAgIH0KICAgICAgICAgICAgKTsKCiAgICAgICAgICAgIAoKICAgICAgICAKICAgIAogICAgICAgICAgICB2YXIgdGlsZV9sYXllcl82OGM2NjZjNGRjNzM0MDlmOGRmNmJjMmY1Y2ExNjkwMyA9IEwudGlsZUxheWVyKAogICAgICAgICAgICAgICAgImh0dHBzOi8vY2FydG9kYi1iYXNlbWFwcy17c30uZ2xvYmFsLnNzbC5mYXN0bHkubmV0L2xpZ2h0X2FsbC97en0ve3h9L3t5fS5wbmciLAogICAgICAgICAgICAgICAgeyJhdHRyaWJ1dGlvbiI6ICJcdTAwMjZjb3B5OyBcdTAwM2NhIGhyZWY9XCJodHRwOi8vd3d3Lm9wZW5zdHJlZXRtYXAub3JnL2NvcHlyaWdodFwiXHUwMDNlT3BlblN0cmVldE1hcFx1MDAzYy9hXHUwMDNlIGNvbnRyaWJ1dG9ycyBcdTAwMjZjb3B5OyBcdTAwM2NhIGhyZWY9XCJodHRwOi8vY2FydG9kYi5jb20vYXR0cmlidXRpb25zXCJcdTAwM2VDYXJ0b0RCXHUwMDNjL2FcdTAwM2UsIENhcnRvREIgXHUwMDNjYSBocmVmID1cImh0dHA6Ly9jYXJ0b2RiLmNvbS9hdHRyaWJ1dGlvbnNcIlx1MDAzZWF0dHJpYnV0aW9uc1x1MDAzYy9hXHUwMDNlIiwgImRldGVjdFJldGluYSI6IGZhbHNlLCAibWF4TmF0aXZlWm9vbSI6IDE4LCAibWF4Wm9vbSI6IDE4LCAibWluWm9vbSI6IDAsICJub1dyYXAiOiBmYWxzZSwgIm9wYWNpdHkiOiAxLCAic3ViZG9tYWlucyI6ICJhYmMiLCAidG1zIjogZmFsc2V9CiAgICAgICAgICAgICkuYWRkVG8obWFwXzZhMTNmNmQ0MjlhMzQyYmZiZDFiOWQyNGJlNzg2YWExKTsKICAgICAgICAKICAgIAogICAgICAgICAgICB2YXIgbWFya2VyX2NsdXN0ZXJfNTk1NDRlZjBiNTFlNDRlN2JmNDk2NDBhY2E5ZTA3MjcgPSBMLm1hcmtlckNsdXN0ZXJHcm91cCgKICAgICAgICAgICAgICAgIHt9CiAgICAgICAgICAgICk7CiAgICAgICAgICAgIG1hcF82YTEzZjZkNDI5YTM0MmJmYmQxYjlkMjRiZTc4NmFhMS5hZGRMYXllcihtYXJrZXJfY2x1c3Rlcl81OTU0NGVmMGI1MWU0NGU3YmY0OTY0MGFjYTllMDcyNyk7CiAgICAgICAgCiAgICAKICAgICAgICAgICAgdmFyIG1hcmtlcl83NTZlNWU5NzQ0NTk0NzNlOWEyY2I5ZGE2NTc2ZDYwYSA9IEwubWFya2VyKAogICAgICAgICAgICAgICAgWzQwLjE4NTAzMywgLTEwNS4xODU3ODldLAogICAgICAgICAgICAgICAge30KICAgICAgICAgICAgKS5hZGRUbyhtYXJrZXJfY2x1c3Rlcl81OTU0NGVmMGI1MWU0NGU3YmY0OTY0MGFjYTllMDcyNyk7CiAgICAgICAgCiAgICAKICAgICAgICB2YXIgcG9wdXBfMTdmNjU1OWZkNTFjNDJmMmJiNTkzMWVlNzA4MGFlN2QgPSBMLnBvcHVwKHsibWF4V2lkdGgiOiAiMTAwJSJ9KTsKCiAgICAgICAgCiAgICAgICAgICAgIHZhciBodG1sX2RlMmI2OGQ4Y2JhMzQxMDliMWY0OGNkOWVlN2FiNjlhID0gJChgPGRpdiBpZD0iaHRtbF9kZTJiNjhkOGNiYTM0MTA5YjFmNDhjZDllZTdhYjY5YSIgc3R5bGU9IndpZHRoOiAxMDAuMCU7IGhlaWdodDogMTAwLjAlOyI+TmFtZTogWldFQ0sgQU5EIFRVUk5FUiBESVRDSCBQcmVjaXA6IDAuMTA8L2Rpdj5gKVswXTsKICAgICAgICAgICAgcG9wdXBfMTdmNjU1OWZkNTFjNDJmMmJiNTkzMWVlNzA4MGFlN2Quc2V0Q29udGVudChodG1sX2RlMmI2OGQ4Y2JhMzQxMDliMWY0OGNkOWVlN2FiNjlhKTsKICAgICAgICAKCiAgICAgICAgbWFya2VyXzc1NmU1ZTk3NDQ1OTQ3M2U5YTJjYjlkYTY1NzZkNjBhLmJpbmRQb3B1cChwb3B1cF8xN2Y2NTU5ZmQ1MWM0MmYyYmI1OTMxZWU3MDgwYWU3ZCkKICAgICAgICA7CgogICAgICAgIAogICAgCiAgICAKICAgICAgICAgICAgdmFyIG1hcmtlcl8zNTUzMjIzMzMwMTk0YzAwYjk0OThkOGZhOGQ0NmJiZSA9IEwubWFya2VyKAogICAgICAgICAgICAgICAgWzQwLjIyMDcwMiwgLTEwNS4yNjM0OV0sCiAgICAgICAgICAgICAgICB7fQogICAgICAgICAgICApLmFkZFRvKG1hcmtlcl9jbHVzdGVyXzU5NTQ0ZWYwYjUxZTQ0ZTdiZjQ5NjQwYWNhOWUwNzI3KTsKICAgICAgICAKICAgIAogICAgICAgIHZhciBwb3B1cF8wNmI1NjkxYTI1NWM0NmM2ODY2MzIwOTA5NTNiYjAxMCA9IEwucG9wdXAoeyJtYXhXaWR0aCI6ICIxMDAlIn0pOwoKICAgICAgICAKICAgICAgICAgICAgdmFyIGh0bWxfMGYwYzIzOTExMWFmNGIxZWI2ZWY1NWUzYWFlZDcyNTYgPSAkKGA8ZGl2IGlkPSJodG1sXzBmMGMyMzkxMTFhZjRiMWViNmVmNTVlM2FhZWQ3MjU2IiBzdHlsZT0id2lkdGg6IDEwMC4wJTsgaGVpZ2h0OiAxMDAuMCU7Ij5OYW1lOiBTQUlOVCBWUkFJTiBDUkVFSyBBVCBMWU9OUywgQ08gUHJlY2lwOiAzNC4yMDwvZGl2PmApWzBdOwogICAgICAgICAgICBwb3B1cF8wNmI1NjkxYTI1NWM0NmM2ODY2MzIwOTA5NTNiYjAxMC5zZXRDb250ZW50KGh0bWxfMGYwYzIzOTExMWFmNGIxZWI2ZWY1NWUzYWFlZDcyNTYpOwogICAgICAgIAoKICAgICAgICBtYXJrZXJfMzU1MzIyMzMzMDE5NGMwMGI5NDk4ZDhmYThkNDZiYmUuYmluZFBvcHVwKHBvcHVwXzA2YjU2OTFhMjU1YzQ2YzY4NjYzMjA5MDk1M2JiMDEwKQogICAgICAgIDsKCiAgICAgICAgCiAgICAKICAgIAogICAgICAgICAgICB2YXIgbWFya2VyX2ZlNjUwZGE3NjBiZDQyZjY5ZGRjOWVjMmQ2Y2I0Y2U4ID0gTC5tYXJrZXIoCiAgICAgICAgICAgICAgICBbNDAuMTk2NDIyLCAtMTA1LjIwNjU5Ml0sCiAgICAgICAgICAgICAgICB7fQogICAgICAgICAgICApLmFkZFRvKG1hcmtlcl9jbHVzdGVyXzU5NTQ0ZWYwYjUxZTQ0ZTdiZjQ5NjQwYWNhOWUwNzI3KTsKICAgICAgICAKICAgIAogICAgICAgIHZhciBwb3B1cF9iYWZjODk4ZGVmODA0ZmI3ODQyZDIwYjUxMzlkZjhkZCA9IEwucG9wdXAoeyJtYXhXaWR0aCI6ICIxMDAlIn0pOwoKICAgICAgICAKICAgICAgICAgICAgdmFyIGh0bWxfZWU0MmEwNTExZmI5NDI1ZWFjYjNjOTg0NTRhOTJlZGYgPSAkKGA8ZGl2IGlkPSJodG1sX2VlNDJhMDUxMWZiOTQyNWVhY2IzYzk4NDU0YTkyZWRmIiBzdHlsZT0id2lkdGg6IDEwMC4wJTsgaGVpZ2h0OiAxMDAuMCU7Ij5OYW1lOiBPTElHQVJDSFkgRElUQ0ggRElWRVJTSU9OIFByZWNpcDogMi43NjwvZGl2PmApWzBdOwogICAgICAgICAgICBwb3B1cF9iYWZjODk4ZGVmODA0ZmI3ODQyZDIwYjUxMzlkZjhkZC5zZXRDb250ZW50KGh0bWxfZWU0MmEwNTExZmI5NDI1ZWFjYjNjOTg0NTRhOTJlZGYpOwogICAgICAgIAoKICAgICAgICBtYXJrZXJfZmU2NTBkYTc2MGJkNDJmNjlkZGM5ZWMyZDZjYjRjZTguYmluZFBvcHVwKHBvcHVwX2JhZmM4OThkZWY4MDRmYjc4NDJkMjBiNTEzOWRmOGRkKQogICAgICAgIDsKCiAgICAgICAgCiAgICAKICAgIAogICAgICAgICAgICB2YXIgbWFya2VyX2Q1NWYxYTE5NGZhNjQ5OWY5YjQxODU0MmZkMzZjYmQ5ID0gTC5tYXJrZXIoCiAgICAgICAgICAgICAgICBbNDAuMDg3NTgzLCAtMTA1LjA3MjUwMl0sCiAgICAgICAgICAgICAgICB7fQogICAgICAgICAgICApLmFkZFRvKG1hcmtlcl9jbHVzdGVyXzU5NTQ0ZWYwYjUxZTQ0ZTdiZjQ5NjQwYWNhOWUwNzI3KTsKICAgICAgICAKICAgIAogICAgICAgIHZhciBwb3B1cF8wZTFhZDkwMmM2ZWM0YTQ2OGFiNjUzMTgwZDE0ZGM0YyA9IEwucG9wdXAoeyJtYXhXaWR0aCI6ICIxMDAlIn0pOwoKICAgICAgICAKICAgICAgICAgICAgdmFyIGh0bWxfYmQ5OGVmMzFkMDgzNGY5N2E5ZDg0MjNjZjhhZjk0MzQgPSAkKGA8ZGl2IGlkPSJodG1sX2JkOThlZjMxZDA4MzRmOTdhOWQ4NDIzY2Y4YWY5NDM0IiBzdHlsZT0id2lkdGg6IDEwMC4wJTsgaGVpZ2h0OiAxMDAuMCU7Ij5OYW1lOiBQQU5BTUEgUkVTRVJWT0lSIE9VVExFVCBQcmVjaXA6IDAuMDc8L2Rpdj5gKVswXTsKICAgICAgICAgICAgcG9wdXBfMGUxYWQ5MDJjNmVjNGE0NjhhYjY1MzE4MGQxNGRjNGMuc2V0Q29udGVudChodG1sX2JkOThlZjMxZDA4MzRmOTdhOWQ4NDIzY2Y4YWY5NDM0KTsKICAgICAgICAKCiAgICAgICAgbWFya2VyX2Q1NWYxYTE5NGZhNjQ5OWY5YjQxODU0MmZkMzZjYmQ5LmJpbmRQb3B1cChwb3B1cF8wZTFhZDkwMmM2ZWM0YTQ2OGFiNjUzMTgwZDE0ZGM0YykKICAgICAgICA7CgogICAgICAgIAogICAgCiAgICAKICAgICAgICAgICAgdmFyIG1hcmtlcl9jNGE5NjMxYzk4YTE0YTJhYTQ2MTA0M2VhNTk5OGNiZSA9IEwubWFya2VyKAogICAgICAgICAgICAgICAgWzQwLjE5Mzc1OCwgLTEwNS4yMTAzOV0sCiAgICAgICAgICAgICAgICB7fQogICAgICAgICAgICApLmFkZFRvKG1hcmtlcl9jbHVzdGVyXzU5NTQ0ZWYwYjUxZTQ0ZTdiZjQ5NjQwYWNhOWUwNzI3KTsKICAgICAgICAKICAgIAogICAgICAgIHZhciBwb3B1cF81MDRkMmUzYWY3YmY0Nzg0OTc2YjVhYWM4ZWRhYjI3ZiA9IEwucG9wdXAoeyJtYXhXaWR0aCI6ICIxMDAlIn0pOwoKICAgICAgICAKICAgICAgICAgICAgdmFyIGh0bWxfZjNjNTA3NzAzMTc5NDIzZGE1YWNmZDJjMjk3YjcyZmQgPSAkKGA8ZGl2IGlkPSJodG1sX2YzYzUwNzcwMzE3OTQyM2RhNWFjZmQyYzI5N2I3MmZkIiBzdHlsZT0id2lkdGg6IDEwMC4wJTsgaGVpZ2h0OiAxMDAuMCU7Ij5OYW1lOiBDTE9VR0ggQU5EIFRSVUUgRElUQ0ggUHJlY2lwOiAwLjAwPC9kaXY+YClbMF07CiAgICAgICAgICAgIHBvcHVwXzUwNGQyZTNhZjdiZjQ3ODQ5NzZiNWFhYzhlZGFiMjdmLnNldENvbnRlbnQoaHRtbF9mM2M1MDc3MDMxNzk0MjNkYTVhY2ZkMmMyOTdiNzJmZCk7CiAgICAgICAgCgogICAgICAgIG1hcmtlcl9jNGE5NjMxYzk4YTE0YTJhYTQ2MTA0M2VhNTk5OGNiZS5iaW5kUG9wdXAocG9wdXBfNTA0ZDJlM2FmN2JmNDc4NDk3NmI1YWFjOGVkYWIyN2YpCiAgICAgICAgOwoKICAgICAgICAKICAgIAogICAgCiAgICAgICAgICAgIHZhciBtYXJrZXJfOWY3Nzc5Mjc4MDRkNGIxNGJiZmIyNzVlNDQ5Zjc4OWQgPSBMLm1hcmtlcigKICAgICAgICAgICAgICAgIFs0MC4wMDYzOCwgLTEwNS4zMzA4NDFdLAogICAgICAgICAgICAgICAge30KICAgICAgICAgICAgKS5hZGRUbyhtYXJrZXJfY2x1c3Rlcl81OTU0NGVmMGI1MWU0NGU3YmY0OTY0MGFjYTllMDcyNyk7CiAgICAgICAgCiAgICAKICAgICAgICB2YXIgcG9wdXBfNDJhODQ4YjdmNjc3NDY5ZmJmNDE1NjhlMWM5YmZlNWMgPSBMLnBvcHVwKHsibWF4V2lkdGgiOiAiMTAwJSJ9KTsKCiAgICAgICAgCiAgICAgICAgICAgIHZhciBodG1sXzk5MTFjNDM2NjIzNDQwY2FhYWMwYjQyNjJlYjdhOTg2ID0gJChgPGRpdiBpZD0iaHRtbF85OTExYzQzNjYyMzQ0MGNhYWFjMGI0MjYyZWI3YTk4NiIgc3R5bGU9IndpZHRoOiAxMDAuMCU7IGhlaWdodDogMTAwLjAlOyI+TmFtZTogQk9VTERFUiBDUkVFSyBORUFSIE9ST0RFTEwsIENPLiBQcmVjaXA6IDIzLjkwPC9kaXY+YClbMF07CiAgICAgICAgICAgIHBvcHVwXzQyYTg0OGI3ZjY3NzQ2OWZiZjQxNTY4ZTFjOWJmZTVjLnNldENvbnRlbnQoaHRtbF85OTExYzQzNjYyMzQ0MGNhYWFjMGI0MjYyZWI3YTk4Nik7CiAgICAgICAgCgogICAgICAgIG1hcmtlcl85Zjc3NzkyNzgwNGQ0YjE0YmJmYjI3NWU0NDlmNzg5ZC5iaW5kUG9wdXAocG9wdXBfNDJhODQ4YjdmNjc3NDY5ZmJmNDE1NjhlMWM5YmZlNWMpCiAgICAgICAgOwoKICAgICAgICAKICAgIAogICAgCiAgICAgICAgICAgIHZhciBtYXJrZXJfOTlkNmUwNThiZmE0NDM3OGFkNGRmZmY2M2Q1ZjM1YjcgPSBMLm1hcmtlcigKICAgICAgICAgICAgICAgIFs0MC4yMDQxOTMsIC0xMDUuMjE4Nzc3XSwKICAgICAgICAgICAgICAgIHt9CiAgICAgICAgICAgICkuYWRkVG8obWFya2VyX2NsdXN0ZXJfNTk1NDRlZjBiNTFlNDRlN2JmNDk2NDBhY2E5ZTA3MjcpOwogICAgICAgIAogICAgCiAgICAgICAgdmFyIHBvcHVwXzUyMjk5MWU0MzY2YTRmODI5MGQ4ZmRjNzNiNTcwOWNkID0gTC5wb3B1cCh7Im1heFdpZHRoIjogIjEwMCUifSk7CgogICAgICAgIAogICAgICAgICAgICB2YXIgaHRtbF80NzU3ZDIyNDhhMjg0YTRiOWZhNDQ4ZDJkZTE2ZTk2ZSA9ICQoYDxkaXYgaWQ9Imh0bWxfNDc1N2QyMjQ4YTI4NGE0YjlmYTQ0OGQyZGUxNmU5NmUiIHN0eWxlPSJ3aWR0aDogMTAwLjAlOyBoZWlnaHQ6IDEwMC4wJTsiPk5hbWU6IExPTkdNT05UIFNVUFBMWSBESVRDSCBQcmVjaXA6IDAuMDA8L2Rpdj5gKVswXTsKICAgICAgICAgICAgcG9wdXBfNTIyOTkxZTQzNjZhNGY4MjkwZDhmZGM3M2I1NzA5Y2Quc2V0Q29udGVudChodG1sXzQ3NTdkMjI0OGEyODRhNGI5ZmE0NDhkMmRlMTZlOTZlKTsKICAgICAgICAKCiAgICAgICAgbWFya2VyXzk5ZDZlMDU4YmZhNDQzNzhhZDRkZmZmNjNkNWYzNWI3LmJpbmRQb3B1cChwb3B1cF81MjI5OTFlNDM2NmE0ZjgyOTBkOGZkYzczYjU3MDljZCkKICAgICAgICA7CgogICAgICAgIAogICAgCiAgICAKICAgICAgICAgICAgdmFyIG1hcmtlcl9iMDNlMDk1NzZkZTA0NDJlOGUyZDMwYjZjNWM3NmI1NiA9IEwubWFya2VyKAogICAgICAgICAgICAgICAgWzQwLjI1ODcyNiwgLTEwNS4xNzU4MTddLAogICAgICAgICAgICAgICAge30KICAgICAgICAgICAgKS5hZGRUbyhtYXJrZXJfY2x1c3Rlcl81OTU0NGVmMGI1MWU0NGU3YmY0OTY0MGFjYTllMDcyNyk7CiAgICAgICAgCiAgICAKICAgICAgICB2YXIgcG9wdXBfOWE4ODJiZjRiY2NhNDFjZWE2ODFlZDA2NWQ2MGI1ZGYgPSBMLnBvcHVwKHsibWF4V2lkdGgiOiAiMTAwJSJ9KTsKCiAgICAgICAgCiAgICAgICAgICAgIHZhciBodG1sX2JiOThjMWQyNGEzZjRlMjM4OWEwYWM4YjUyN2FmODBiID0gJChgPGRpdiBpZD0iaHRtbF9iYjk4YzFkMjRhM2Y0ZTIzODlhMGFjOGI1MjdhZjgwYiIgc3R5bGU9IndpZHRoOiAxMDAuMCU7IGhlaWdodDogMTAwLjAlOyI+TmFtZTogQk9VTERFUi1MQVJJTUVSIEJZUEFTUyBORUFSIEJFUlRIT1VEIFByZWNpcDogNC4wNzwvZGl2PmApWzBdOwogICAgICAgICAgICBwb3B1cF85YTg4MmJmNGJjY2E0MWNlYTY4MWVkMDY1ZDYwYjVkZi5zZXRDb250ZW50KGh0bWxfYmI5OGMxZDI0YTNmNGUyMzg5YTBhYzhiNTI3YWY4MGIpOwogICAgICAgIAoKICAgICAgICBtYXJrZXJfYjAzZTA5NTc2ZGUwNDQyZThlMmQzMGI2YzVjNzZiNTYuYmluZFBvcHVwKHBvcHVwXzlhODgyYmY0YmNjYTQxY2VhNjgxZWQwNjVkNjBiNWRmKQogICAgICAgIDsKCiAgICAgICAgCiAgICAKICAgIAogICAgICAgICAgICB2YXIgbWFya2VyX2Q1MWViMDAxYmE5MDQwZTU4ZTU5ZDBmY2Q2MjUwNGEwID0gTC5tYXJrZXIoCiAgICAgICAgICAgICAgICBbNDAuMjU4MDM4LCAtMTA1LjIwNjM4Nl0sCiAgICAgICAgICAgICAgICB7fQogICAgICAgICAgICApLmFkZFRvKG1hcmtlcl9jbHVzdGVyXzU5NTQ0ZWYwYjUxZTQ0ZTdiZjQ5NjQwYWNhOWUwNzI3KTsKICAgICAgICAKICAgIAogICAgICAgIHZhciBwb3B1cF85ZDA5MDFkNWYwZTc0NGVjODFkZWMxMGJiODk3ZGM2ZCA9IEwucG9wdXAoeyJtYXhXaWR0aCI6ICIxMDAlIn0pOwoKICAgICAgICAKICAgICAgICAgICAgdmFyIGh0bWxfM2VhNjZhYTc2ODRjNDU1NGI4NjM4M2M0ZWM1YTYzYjYgPSAkKGA8ZGl2IGlkPSJodG1sXzNlYTY2YWE3Njg0YzQ1NTRiODYzODNjNGVjNWE2M2I2IiBzdHlsZT0id2lkdGg6IDEwMC4wJTsgaGVpZ2h0OiAxMDAuMCU7Ij5OYW1lOiBMSVRUTEUgVEhPTVBTT04gUklWRVIgQVQgQ0FOWU9OIE1PVVRIIE5FQVIgQkVSVEhPVUQgUHJlY2lwOiAxMy4wMDwvZGl2PmApWzBdOwogICAgICAgICAgICBwb3B1cF85ZDA5MDFkNWYwZTc0NGVjODFkZWMxMGJiODk3ZGM2ZC5zZXRDb250ZW50KGh0bWxfM2VhNjZhYTc2ODRjNDU1NGI4NjM4M2M0ZWM1YTYzYjYpOwogICAgICAgIAoKICAgICAgICBtYXJrZXJfZDUxZWIwMDFiYTkwNDBlNThlNTlkMGZjZDYyNTA0YTAuYmluZFBvcHVwKHBvcHVwXzlkMDkwMWQ1ZjBlNzQ0ZWM4MWRlYzEwYmI4OTdkYzZkKQogICAgICAgIDsKCiAgICAgICAgCiAgICAKICAgIAogICAgICAgICAgICB2YXIgbWFya2VyXzc0NzJlOTM2ZTJmYjQ3OTg4ZTM1ZGI5OGQwODBkMWIwID0gTC5tYXJrZXIoCiAgICAgICAgICAgICAgICBbNDAuMTcyOTI1LCAtMTA1LjE2NzYyMl0sCiAgICAgICAgICAgICAgICB7fQogICAgICAgICAgICApLmFkZFRvKG1hcmtlcl9jbHVzdGVyXzU5NTQ0ZWYwYjUxZTQ0ZTdiZjQ5NjQwYWNhOWUwNzI3KTsKICAgICAgICAKICAgIAogICAgICAgIHZhciBwb3B1cF9iZGY3ZGQyZjhmNDc0NmU4OWJjNTZjYTliYTU3ZGEzNiA9IEwucG9wdXAoeyJtYXhXaWR0aCI6ICIxMDAlIn0pOwoKICAgICAgICAKICAgICAgICAgICAgdmFyIGh0bWxfNThjMjJhOTcxZmZmNGQxMjgwMTZhNWY4NzVhMGQ3Y2MgPSAkKGA8ZGl2IGlkPSJodG1sXzU4YzIyYTk3MWZmZjRkMTI4MDE2YTVmODc1YTBkN2NjIiBzdHlsZT0id2lkdGg6IDEwMC4wJTsgaGVpZ2h0OiAxMDAuMCU7Ij5OYW1lOiBOT1JUSFdFU1QgTVVUVUFMIERJVENIIFByZWNpcDogMC4wMDwvZGl2PmApWzBdOwogICAgICAgICAgICBwb3B1cF9iZGY3ZGQyZjhmNDc0NmU4OWJjNTZjYTliYTU3ZGEzNi5zZXRDb250ZW50KGh0bWxfNThjMjJhOTcxZmZmNGQxMjgwMTZhNWY4NzVhMGQ3Y2MpOwogICAgICAgIAoKICAgICAgICBtYXJrZXJfNzQ3MmU5MzZlMmZiNDc5ODhlMzVkYjk4ZDA4MGQxYjAuYmluZFBvcHVwKHBvcHVwX2JkZjdkZDJmOGY0NzQ2ZTg5YmM1NmNhOWJhNTdkYTM2KQogICAgICAgIDsKCiAgICAgICAgCiAgICAKICAgIAogICAgICAgICAgICB2YXIgbWFya2VyXzlmMmM0ZmY4ZjVmMzQ5YjdhMzcyMWY2MDdjYTM2ODRlID0gTC5tYXJrZXIoCiAgICAgICAgICAgICAgICBbNDAuMTM0Mjc4LCAtMTA1LjEzMDgxOV0sCiAgICAgICAgICAgICAgICB7fQogICAgICAgICAgICApLmFkZFRvKG1hcmtlcl9jbHVzdGVyXzU5NTQ0ZWYwYjUxZTQ0ZTdiZjQ5NjQwYWNhOWUwNzI3KTsKICAgICAgICAKICAgIAogICAgICAgIHZhciBwb3B1cF85Nzc3N2MwNTQ2NGY0MTdkOTc5ZDY4NWU4YjQwODYyZCA9IEwucG9wdXAoeyJtYXhXaWR0aCI6ICIxMDAlIn0pOwoKICAgICAgICAKICAgICAgICAgICAgdmFyIGh0bWxfZDQ1MDJlNTk3MWU0NDJhY2FjYzYxN2FhN2NmMzBkNGUgPSAkKGA8ZGl2IGlkPSJodG1sX2Q0NTAyZTU5NzFlNDQyYWNhY2M2MTdhYTdjZjMwZDRlIiBzdHlsZT0id2lkdGg6IDEwMC4wJTsgaGVpZ2h0OiAxMDAuMCU7Ij5OYW1lOiBMRUZUIEhBTkQgQ1JFRUsgQVQgSE9WRVIgUk9BRCBORUFSIExPTkdNT05ULCBDTyBQcmVjaXA6IDMuODk8L2Rpdj5gKVswXTsKICAgICAgICAgICAgcG9wdXBfOTc3NzdjMDU0NjRmNDE3ZDk3OWQ2ODVlOGI0MDg2MmQuc2V0Q29udGVudChodG1sX2Q0NTAyZTU5NzFlNDQyYWNhY2M2MTdhYTdjZjMwZDRlKTsKICAgICAgICAKCiAgICAgICAgbWFya2VyXzlmMmM0ZmY4ZjVmMzQ5YjdhMzcyMWY2MDdjYTM2ODRlLmJpbmRQb3B1cChwb3B1cF85Nzc3N2MwNTQ2NGY0MTdkOTc5ZDY4NWU4YjQwODYyZCkKICAgICAgICA7CgogICAgICAgIAogICAgCiAgICAKICAgICAgICAgICAgdmFyIG1hcmtlcl85NDE2MWJhOGVkYzM0ZTVmOTRiMjY0OTZjYzM1M2M0OCA9IEwubWFya2VyKAogICAgICAgICAgICAgICAgWzM5Ljk4NjE2OSwgLTEwNS4yMTg2NzddLAogICAgICAgICAgICAgICAge30KICAgICAgICAgICAgKS5hZGRUbyhtYXJrZXJfY2x1c3Rlcl81OTU0NGVmMGI1MWU0NGU3YmY0OTY0MGFjYTllMDcyNyk7CiAgICAgICAgCiAgICAKICAgICAgICB2YXIgcG9wdXBfMWVkNzU4NTYyOTA1NDVkM2FjMzU2MWZmMThhM2RmMzIgPSBMLnBvcHVwKHsibWF4V2lkdGgiOiAiMTAwJSJ9KTsKCiAgICAgICAgCiAgICAgICAgICAgIHZhciBodG1sXzUyYjZlNjU1MjFlYzQyYWViZjVmYTNmMmYwNjhhNTkwID0gJChgPGRpdiBpZD0iaHRtbF81MmI2ZTY1NTIxZWM0MmFlYmY1ZmEzZjJmMDY4YTU5MCIgc3R5bGU9IndpZHRoOiAxMDAuMCU7IGhlaWdodDogMTAwLjAlOyI+TmFtZTogRFJZIENSRUVLIENBUlJJRVIgUHJlY2lwOiAwLjAwPC9kaXY+YClbMF07CiAgICAgICAgICAgIHBvcHVwXzFlZDc1ODU2MjkwNTQ1ZDNhYzM1NjFmZjE4YTNkZjMyLnNldENvbnRlbnQoaHRtbF81MmI2ZTY1NTIxZWM0MmFlYmY1ZmEzZjJmMDY4YTU5MCk7CiAgICAgICAgCgogICAgICAgIG1hcmtlcl85NDE2MWJhOGVkYzM0ZTVmOTRiMjY0OTZjYzM1M2M0OC5iaW5kUG9wdXAocG9wdXBfMWVkNzU4NTYyOTA1NDVkM2FjMzU2MWZmMThhM2RmMzIpCiAgICAgICAgOwoKICAgICAgICAKICAgIAogICAgCiAgICAgICAgICAgIHZhciBtYXJrZXJfNjZjYmM0NmU4MzQxNDlmY2IyNzk1MjVmYWU2NjYwNjYgPSBMLm1hcmtlcigKICAgICAgICAgICAgICAgIFszOS45MzE1OTcsIC0xMDUuMzA0OTldLAogICAgICAgICAgICAgICAge30KICAgICAgICAgICAgKS5hZGRUbyhtYXJrZXJfY2x1c3Rlcl81OTU0NGVmMGI1MWU0NGU3YmY0OTY0MGFjYTllMDcyNyk7CiAgICAgICAgCiAgICAKICAgICAgICB2YXIgcG9wdXBfYzRhOWY3NWNiZjBjNDRhMGI1YTUyMjI4MWI0NmQ5ZDAgPSBMLnBvcHVwKHsibWF4V2lkdGgiOiAiMTAwJSJ9KTsKCiAgICAgICAgCiAgICAgICAgICAgIHZhciBodG1sXzg2ZTA1ZjZkMTE3MTQ2NzU4NzRjNzM3MzEzZGM3ZmVjID0gJChgPGRpdiBpZD0iaHRtbF84NmUwNWY2ZDExNzE0Njc1ODc0YzczNzMxM2RjN2ZlYyIgc3R5bGU9IndpZHRoOiAxMDAuMCU7IGhlaWdodDogMTAwLjAlOyI+TmFtZTogU09VVEggQk9VTERFUiBDUkVFSyBORUFSIEVMRE9SQURPIFNQUklOR1MsIENPLiBQcmVjaXA6IDE4LjQwPC9kaXY+YClbMF07CiAgICAgICAgICAgIHBvcHVwX2M0YTlmNzVjYmYwYzQ0YTBiNWE1MjIyODFiNDZkOWQwLnNldENvbnRlbnQoaHRtbF84NmUwNWY2ZDExNzE0Njc1ODc0YzczNzMxM2RjN2ZlYyk7CiAgICAgICAgCgogICAgICAgIG1hcmtlcl82NmNiYzQ2ZTgzNDE0OWZjYjI3OTUyNWZhZTY2NjA2Ni5iaW5kUG9wdXAocG9wdXBfYzRhOWY3NWNiZjBjNDRhMGI1YTUyMjI4MWI0NmQ5ZDApCiAgICAgICAgOwoKICAgICAgICAKICAgIAogICAgCiAgICAgICAgICAgIHZhciBtYXJrZXJfZjNiOTlkYWNhYTQ1NDllY2FjNGJkZWQwODU0YzU3MDIgPSBMLm1hcmtlcigKICAgICAgICAgICAgICAgIFs0MC4xNjA3MDUsIC0xMDUuMTY4NDcxXSwKICAgICAgICAgICAgICAgIHt9CiAgICAgICAgICAgICkuYWRkVG8obWFya2VyX2NsdXN0ZXJfNTk1NDRlZjBiNTFlNDRlN2JmNDk2NDBhY2E5ZTA3MjcpOwogICAgICAgIAogICAgCiAgICAgICAgdmFyIHBvcHVwXzVmNDFmZTRkZTI5MTQ5MTViOTkwYzlmMzcyYzdjZDUzID0gTC5wb3B1cCh7Im1heFdpZHRoIjogIjEwMCUifSk7CgogICAgICAgIAogICAgICAgICAgICB2YXIgaHRtbF85ZWFmNGY3MWVmOWU0NzQ3ODEwMWRhNWM0ZDAzMzhjNSA9ICQoYDxkaXYgaWQ9Imh0bWxfOWVhZjRmNzFlZjllNDc0NzgxMDFkYTVjNGQwMzM4YzUiIHN0eWxlPSJ3aWR0aDogMTAwLjAlOyBoZWlnaHQ6IDEwMC4wJTsiPk5hbWU6IFBFQ0stUEVMTEEgQVVHTUVOVEFUSU9OIFJFVFVSTiBQcmVjaXA6IDAuMDA8L2Rpdj5gKVswXTsKICAgICAgICAgICAgcG9wdXBfNWY0MWZlNGRlMjkxNDkxNWI5OTBjOWYzNzJjN2NkNTMuc2V0Q29udGVudChodG1sXzllYWY0ZjcxZWY5ZTQ3NDc4MTAxZGE1YzRkMDMzOGM1KTsKICAgICAgICAKCiAgICAgICAgbWFya2VyX2YzYjk5ZGFjYWE0NTQ5ZWNhYzRiZGVkMDg1NGM1NzAyLmJpbmRQb3B1cChwb3B1cF81ZjQxZmU0ZGUyOTE0OTE1Yjk5MGM5ZjM3MmM3Y2Q1MykKICAgICAgICA7CgogICAgICAgIAogICAgCiAgICAKICAgICAgICAgICAgdmFyIG1hcmtlcl9iNzg1MjllYmM3YTE0NTI3OWQxNzA2MGNmMTI1MjQ3ZiA9IEwubWFya2VyKAogICAgICAgICAgICAgICAgWzQwLjE5OTMyMSwgLTEwNS4yMjI2MzldLAogICAgICAgICAgICAgICAge30KICAgICAgICAgICAgKS5hZGRUbyhtYXJrZXJfY2x1c3Rlcl81OTU0NGVmMGI1MWU0NGU3YmY0OTY0MGFjYTllMDcyNyk7CiAgICAgICAgCiAgICAKICAgICAgICB2YXIgcG9wdXBfM2VhNzY3ODYxZDg1NDRjMzhkNmMyMzZkMDk2MzJlMzAgPSBMLnBvcHVwKHsibWF4V2lkdGgiOiAiMTAwJSJ9KTsKCiAgICAgICAgCiAgICAgICAgICAgIHZhciBodG1sX2MyMmRmNjNhZTllMDQyODM4ZmNlMGQyNDljNDFiNmZmID0gJChgPGRpdiBpZD0iaHRtbF9jMjJkZjYzYWU5ZTA0MjgzOGZjZTBkMjQ5YzQxYjZmZiIgc3R5bGU9IndpZHRoOiAxMDAuMCU7IGhlaWdodDogMTAwLjAlOyI+TmFtZTogR09TUyBESVRDSCAxIFByZWNpcDogMC4wMDwvZGl2PmApWzBdOwogICAgICAgICAgICBwb3B1cF8zZWE3Njc4NjFkODU0NGMzOGQ2YzIzNmQwOTYzMmUzMC5zZXRDb250ZW50KGh0bWxfYzIyZGY2M2FlOWUwNDI4MzhmY2UwZDI0OWM0MWI2ZmYpOwogICAgICAgIAoKICAgICAgICBtYXJrZXJfYjc4NTI5ZWJjN2ExNDUyNzlkMTcwNjBjZjEyNTI0N2YuYmluZFBvcHVwKHBvcHVwXzNlYTc2Nzg2MWQ4NTQ0YzM4ZDZjMjM2ZDA5NjMyZTMwKQogICAgICAgIDsKCiAgICAgICAgCiAgICAKICAgIAogICAgICAgICAgICB2YXIgbWFya2VyX2E3ZmRiYjI3YWI0ZjRkNjk4MjMzMDE1NWU1NzEyYWZhID0gTC5tYXJrZXIoCiAgICAgICAgICAgICAgICBbNDAuMTkzMjgsIC0xMDUuMjEwNDI0XSwKICAgICAgICAgICAgICAgIHt9CiAgICAgICAgICAgICkuYWRkVG8obWFya2VyX2NsdXN0ZXJfNTk1NDRlZjBiNTFlNDRlN2JmNDk2NDBhY2E5ZTA3MjcpOwogICAgICAgIAogICAgCiAgICAgICAgdmFyIHBvcHVwXzA3MDNiZGU0NTMzZjQ4NTk5NTAwMjNmZTllZDkxMDM2ID0gTC5wb3B1cCh7Im1heFdpZHRoIjogIjEwMCUifSk7CgogICAgICAgIAogICAgICAgICAgICB2YXIgaHRtbF9hYzEzOTZmOGUwMjc0MTU1YjgwYTkzNjkwMmExODIyNiA9ICQoYDxkaXYgaWQ9Imh0bWxfYWMxMzk2ZjhlMDI3NDE1NWI4MGE5MzY5MDJhMTgyMjYiIHN0eWxlPSJ3aWR0aDogMTAwLjAlOyBoZWlnaHQ6IDEwMC4wJTsiPk5hbWU6IFdFQlNURVIgTUNDQVNMSU4gRElUQ0ggUHJlY2lwOiAwLjAwPC9kaXY+YClbMF07CiAgICAgICAgICAgIHBvcHVwXzA3MDNiZGU0NTMzZjQ4NTk5NTAwMjNmZTllZDkxMDM2LnNldENvbnRlbnQoaHRtbF9hYzEzOTZmOGUwMjc0MTU1YjgwYTkzNjkwMmExODIyNik7CiAgICAgICAgCgogICAgICAgIG1hcmtlcl9hN2ZkYmIyN2FiNGY0ZDY5ODIzMzAxNTVlNTcxMmFmYS5iaW5kUG9wdXAocG9wdXBfMDcwM2JkZTQ1MzNmNDg1OTk1MDAyM2ZlOWVkOTEwMzYpCiAgICAgICAgOwoKICAgICAgICAKICAgIAogICAgCiAgICAgICAgICAgIHZhciBtYXJrZXJfMGNmOTI0MDc1MzMwNDc5NWI5ZmVjMzAwOWRjZGNhMDggPSBMLm1hcmtlcigKICAgICAgICAgICAgICAgIFszOS45ODg0ODEsIC0xMDUuMjIwNDc3XSwKICAgICAgICAgICAgICAgIHt9CiAgICAgICAgICAgICkuYWRkVG8obWFya2VyX2NsdXN0ZXJfNTk1NDRlZjBiNTFlNDRlN2JmNDk2NDBhY2E5ZTA3MjcpOwogICAgICAgIAogICAgCiAgICAgICAgdmFyIHBvcHVwX2JiNGExZjI2NWVhOTQyZTg4NTVlNGMxMjYxOTVjYjc0ID0gTC5wb3B1cCh7Im1heFdpZHRoIjogIjEwMCUifSk7CgogICAgICAgIAogICAgICAgICAgICB2YXIgaHRtbF8wMGNiYmEyNjIxYzE0ZjRhOTcwOTlmZTMyOTM4M2I4YiA9ICQoYDxkaXYgaWQ9Imh0bWxfMDBjYmJhMjYyMWMxNGY0YTk3MDk5ZmUzMjkzODNiOGIiIHN0eWxlPSJ3aWR0aDogMTAwLjAlOyBoZWlnaHQ6IDEwMC4wJTsiPk5hbWU6IEhPV0FSRCBESVRDSCBQcmVjaXA6IDAuMDA8L2Rpdj5gKVswXTsKICAgICAgICAgICAgcG9wdXBfYmI0YTFmMjY1ZWE5NDJlODg1NWU0YzEyNjE5NWNiNzQuc2V0Q29udGVudChodG1sXzAwY2JiYTI2MjFjMTRmNGE5NzA5OWZlMzI5MzgzYjhiKTsKICAgICAgICAKCiAgICAgICAgbWFya2VyXzBjZjkyNDA3NTMzMDQ3OTViOWZlYzMwMDlkY2RjYTA4LmJpbmRQb3B1cChwb3B1cF9iYjRhMWYyNjVlYTk0MmU4ODU1ZTRjMTI2MTk1Y2I3NCkKICAgICAgICA7CgogICAgICAgIAogICAgCiAgICAKICAgICAgICAgICAgdmFyIG1hcmtlcl9iNDk3OTQ1NmEyMmY0MmEyOGRmNmI1ZjhjZjlhMzMwOCA9IEwubWFya2VyKAogICAgICAgICAgICAgICAgWzQwLjIxNjI2MywgLTEwNS4zNjUzNjVdLAogICAgICAgICAgICAgICAge30KICAgICAgICAgICAgKS5hZGRUbyhtYXJrZXJfY2x1c3Rlcl81OTU0NGVmMGI1MWU0NGU3YmY0OTY0MGFjYTllMDcyNyk7CiAgICAgICAgCiAgICAKICAgICAgICB2YXIgcG9wdXBfMjA4NTE3MjhlNTFhNGFlNzhkZjhhYjE0ODBhMTBmOGIgPSBMLnBvcHVwKHsibWF4V2lkdGgiOiAiMTAwJSJ9KTsKCiAgICAgICAgCiAgICAgICAgICAgIHZhciBodG1sX2ZiODA5MTI2YjRhMjQ5MzZhMzU0NmIxNjRiZTEzMWJhID0gJChgPGRpdiBpZD0iaHRtbF9mYjgwOTEyNmI0YTI0OTM2YTM1NDZiMTY0YmUxMzFiYSIgc3R5bGU9IndpZHRoOiAxMDAuMCU7IGhlaWdodDogMTAwLjAlOyI+TmFtZTogQlVUVE9OUk9DSyAoUkFMUEggUFJJQ0UpIFJFU0VSVk9JUiBQcmVjaXA6IDEyOTExLjAwPC9kaXY+YClbMF07CiAgICAgICAgICAgIHBvcHVwXzIwODUxNzI4ZTUxYTRhZTc4ZGY4YWIxNDgwYTEwZjhiLnNldENvbnRlbnQoaHRtbF9mYjgwOTEyNmI0YTI0OTM2YTM1NDZiMTY0YmUxMzFiYSk7CiAgICAgICAgCgogICAgICAgIG1hcmtlcl9iNDk3OTQ1NmEyMmY0MmEyOGRmNmI1ZjhjZjlhMzMwOC5iaW5kUG9wdXAocG9wdXBfMjA4NTE3MjhlNTFhNGFlNzhkZjhhYjE0ODBhMTBmOGIpCiAgICAgICAgOwoKICAgICAgICAKICAgIAogICAgCiAgICAgICAgICAgIHZhciBtYXJrZXJfYThkYzg3N2ViYjk5NDY2ZmIwNjk1M2YyZDBmNjY1NWUgPSBMLm1hcmtlcigKICAgICAgICAgICAgICAgIFs0MC4yNTU3NzYsIC0xMDUuMjA5NV0sCiAgICAgICAgICAgICAgICB7fQogICAgICAgICAgICApLmFkZFRvKG1hcmtlcl9jbHVzdGVyXzU5NTQ0ZWYwYjUxZTQ0ZTdiZjQ5NjQwYWNhOWUwNzI3KTsKICAgICAgICAKICAgIAogICAgICAgIHZhciBwb3B1cF9kNzExNGFhYWFjOWQ0NjhhYjNjMTczYjc3YTYwZDFjMCA9IEwucG9wdXAoeyJtYXhXaWR0aCI6ICIxMDAlIn0pOwoKICAgICAgICAKICAgICAgICAgICAgdmFyIGh0bWxfMzJiZGY2YTQ2MmRhNDMzOGE0MGI4YzMyMjdkODdkNjkgPSAkKGA8ZGl2IGlkPSJodG1sXzMyYmRmNmE0NjJkYTQzMzhhNDBiOGMzMjI3ZDg3ZDY5IiBzdHlsZT0id2lkdGg6IDEwMC4wJTsgaGVpZ2h0OiAxMDAuMCU7Ij5OYW1lOiBMSVRUTEUgVEhPTVBTT04gIzIgRElUQ0ggUHJlY2lwOiAwLjEwPC9kaXY+YClbMF07CiAgICAgICAgICAgIHBvcHVwX2Q3MTE0YWFhYWM5ZDQ2OGFiM2MxNzNiNzdhNjBkMWMwLnNldENvbnRlbnQoaHRtbF8zMmJkZjZhNDYyZGE0MzM4YTQwYjhjMzIyN2Q4N2Q2OSk7CiAgICAgICAgCgogICAgICAgIG1hcmtlcl9hOGRjODc3ZWJiOTk0NjZmYjA2OTUzZjJkMGY2NjU1ZS5iaW5kUG9wdXAocG9wdXBfZDcxMTRhYWFhYzlkNDY4YWIzYzE3M2I3N2E2MGQxYzApCiAgICAgICAgOwoKICAgICAgICAKICAgIAogICAgCiAgICAgICAgICAgIHZhciBtYXJrZXJfZjllY2Q1ZTRiNjg3NDNkNjliMTE1OTdlNTllZWMxNzQgPSBMLm1hcmtlcigKICAgICAgICAgICAgICAgIFs0MC4yNTc4NDQsIC0xMDUuMTY0Mzk3XSwKICAgICAgICAgICAgICAgIHt9CiAgICAgICAgICAgICkuYWRkVG8obWFya2VyX2NsdXN0ZXJfNTk1NDRlZjBiNTFlNDRlN2JmNDk2NDBhY2E5ZTA3MjcpOwogICAgICAgIAogICAgCiAgICAgICAgdmFyIHBvcHVwXzMyYzUzZmQ3ZGVmOTRiMjI5MTBmMTFiYWNhZTljZTJkID0gTC5wb3B1cCh7Im1heFdpZHRoIjogIjEwMCUifSk7CgogICAgICAgIAogICAgICAgICAgICB2YXIgaHRtbF8wMzQ4MzQ3NmNhZjI0YjQwYmM2MTYyNWY3YzVkMjU3YiA9ICQoYDxkaXYgaWQ9Imh0bWxfMDM0ODM0NzZjYWYyNGI0MGJjNjE2MjVmN2M1ZDI1N2IiIHN0eWxlPSJ3aWR0aDogMTAwLjAlOyBoZWlnaHQ6IDEwMC4wJTsiPk5hbWU6IEJMT1dFUiBESVRDSCBQcmVjaXA6IDAuMDA8L2Rpdj5gKVswXTsKICAgICAgICAgICAgcG9wdXBfMzJjNTNmZDdkZWY5NGIyMjkxMGYxMWJhY2FlOWNlMmQuc2V0Q29udGVudChodG1sXzAzNDgzNDc2Y2FmMjRiNDBiYzYxNjI1ZjdjNWQyNTdiKTsKICAgICAgICAKCiAgICAgICAgbWFya2VyX2Y5ZWNkNWU0YjY4NzQzZDY5YjExNTk3ZTU5ZWVjMTc0LmJpbmRQb3B1cChwb3B1cF8zMmM1M2ZkN2RlZjk0YjIyOTEwZjExYmFjYWU5Y2UyZCkKICAgICAgICA7CgogICAgICAgIAogICAgCiAgICAKICAgICAgICAgICAgdmFyIG1hcmtlcl9lODA4NGI5NmQ3MTg0MTFlYjlmOTA4ODJlMGE2OTQzNyA9IEwubWFya2VyKAogICAgICAgICAgICAgICAgWzQwLjA1MTY1MiwgLTEwNS4xNzg4NzVdLAogICAgICAgICAgICAgICAge30KICAgICAgICAgICAgKS5hZGRUbyhtYXJrZXJfY2x1c3Rlcl81OTU0NGVmMGI1MWU0NGU3YmY0OTY0MGFjYTllMDcyNyk7CiAgICAgICAgCiAgICAKICAgICAgICB2YXIgcG9wdXBfZGNkY2Y0NzM0MmZmNGY4MDlhOWEwYTBmZDNlN2Y5MzggPSBMLnBvcHVwKHsibWF4V2lkdGgiOiAiMTAwJSJ9KTsKCiAgICAgICAgCiAgICAgICAgICAgIHZhciBodG1sXzQxYTgzYWQ0Y2Q1NzQzODBiY2Y0ZGFhY2I5ODhhN2UxID0gJChgPGRpdiBpZD0iaHRtbF80MWE4M2FkNGNkNTc0MzgwYmNmNGRhYWNiOTg4YTdlMSIgc3R5bGU9IndpZHRoOiAxMDAuMCU7IGhlaWdodDogMTAwLjAlOyI+TmFtZTogQk9VTERFUiBDUkVFSyBBVCBOT1JUSCA3NVRIIFNULiBORUFSIEJPVUxERVIsIENPIFByZWNpcDogMTcuNjA8L2Rpdj5gKVswXTsKICAgICAgICAgICAgcG9wdXBfZGNkY2Y0NzM0MmZmNGY4MDlhOWEwYTBmZDNlN2Y5Mzguc2V0Q29udGVudChodG1sXzQxYTgzYWQ0Y2Q1NzQzODBiY2Y0ZGFhY2I5ODhhN2UxKTsKICAgICAgICAKCiAgICAgICAgbWFya2VyX2U4MDg0Yjk2ZDcxODQxMWViOWY5MDg4MmUwYTY5NDM3LmJpbmRQb3B1cChwb3B1cF9kY2RjZjQ3MzQyZmY0ZjgwOWE5YTBhMGZkM2U3ZjkzOCkKICAgICAgICA7CgogICAgICAgIAogICAgCiAgICAKICAgICAgICAgICAgdmFyIG1hcmtlcl9jN2ZiNmIwMGNkMTU0ZjU1ODczZGYyMzA4OWVjZmEwNiA9IEwubWFya2VyKAogICAgICAgICAgICAgICAgWzQwLjE3MDk5OCwgLTEwNS4xNjA4NzZdLAogICAgICAgICAgICAgICAge30KICAgICAgICAgICAgKS5hZGRUbyhtYXJrZXJfY2x1c3Rlcl81OTU0NGVmMGI1MWU0NGU3YmY0OTY0MGFjYTllMDcyNyk7CiAgICAgICAgCiAgICAKICAgICAgICB2YXIgcG9wdXBfN2UzNzVmNTJmYWFmNDg5Y2E4ODY4OTliOWY1ZmM1YjUgPSBMLnBvcHVwKHsibWF4V2lkdGgiOiAiMTAwJSJ9KTsKCiAgICAgICAgCiAgICAgICAgICAgIHZhciBodG1sXzUyMGYxMDg1MGFkMjRlYTM5YmM0NzI2M2JkODYyMjdkID0gJChgPGRpdiBpZD0iaHRtbF81MjBmMTA4NTBhZDI0ZWEzOWJjNDcyNjNiZDg2MjI3ZCIgc3R5bGU9IndpZHRoOiAxMDAuMCU7IGhlaWdodDogMTAwLjAlOyI+TmFtZTogU09VVEggRkxBVCBESVRDSCBQcmVjaXA6IDAuMzg8L2Rpdj5gKVswXTsKICAgICAgICAgICAgcG9wdXBfN2UzNzVmNTJmYWFmNDg5Y2E4ODY4OTliOWY1ZmM1YjUuc2V0Q29udGVudChodG1sXzUyMGYxMDg1MGFkMjRlYTM5YmM0NzI2M2JkODYyMjdkKTsKICAgICAgICAKCiAgICAgICAgbWFya2VyX2M3ZmI2YjAwY2QxNTRmNTU4NzNkZjIzMDg5ZWNmYTA2LmJpbmRQb3B1cChwb3B1cF83ZTM3NWY1MmZhYWY0ODljYTg4Njg5OWI5ZjVmYzViNSkKICAgICAgICA7CgogICAgICAgIAogICAgCiAgICAKICAgICAgICAgICAgdmFyIG1hcmtlcl85OTM5MTJiMTRmZGY0MWMxODUwYzdlZDRhNjg4MmEyOCA9IEwubWFya2VyKAogICAgICAgICAgICAgICAgWzQwLjE1MzM0MSwgLTEwNS4wNzU2OTVdLAogICAgICAgICAgICAgICAge30KICAgICAgICAgICAgKS5hZGRUbyhtYXJrZXJfY2x1c3Rlcl81OTU0NGVmMGI1MWU0NGU3YmY0OTY0MGFjYTllMDcyNyk7CiAgICAgICAgCiAgICAKICAgICAgICB2YXIgcG9wdXBfZDE2MzM5ZWM0MmFlNDdmY2E4NzkwNTg4NmY4NmE1NmQgPSBMLnBvcHVwKHsibWF4V2lkdGgiOiAiMTAwJSJ9KTsKCiAgICAgICAgCiAgICAgICAgICAgIHZhciBodG1sXzk2Nzc3Y2YwYzg5NDRmYmQ5Yzg4Y2U5MDBmNGY5NWUzID0gJChgPGRpdiBpZD0iaHRtbF85Njc3N2NmMGM4OTQ0ZmJkOWM4OGNlOTAwZjRmOTVlMyIgc3R5bGU9IndpZHRoOiAxMDAuMCU7IGhlaWdodDogMTAwLjAlOyI+TmFtZTogU0FJTlQgVlJBSU4gQ1JFRUsgQkVMT1cgS0VOIFBSQVRUIEJMVkQgQVQgTE9OR01PTlQsIENPIFByZWNpcDogMzAuOTA8L2Rpdj5gKVswXTsKICAgICAgICAgICAgcG9wdXBfZDE2MzM5ZWM0MmFlNDdmY2E4NzkwNTg4NmY4NmE1NmQuc2V0Q29udGVudChodG1sXzk2Nzc3Y2YwYzg5NDRmYmQ5Yzg4Y2U5MDBmNGY5NWUzKTsKICAgICAgICAKCiAgICAgICAgbWFya2VyXzk5MzkxMmIxNGZkZjQxYzE4NTBjN2VkNGE2ODgyYTI4LmJpbmRQb3B1cChwb3B1cF9kMTYzMzllYzQyYWU0N2ZjYTg3OTA1ODg2Zjg2YTU2ZCkKICAgICAgICA7CgogICAgICAgIAogICAgCiAgICAKICAgICAgICAgICAgdmFyIG1hcmtlcl9hYmI5OTRmYzZkZDQ0NzExYTVhMWU1OWU2MWJkNmE0NCA9IEwubWFya2VyKAogICAgICAgICAgICAgICAgWzQwLjA1MzY2MSwgLTEwNS4xNTExNDNdLAogICAgICAgICAgICAgICAge30KICAgICAgICAgICAgKS5hZGRUbyhtYXJrZXJfY2x1c3Rlcl81OTU0NGVmMGI1MWU0NGU3YmY0OTY0MGFjYTllMDcyNyk7CiAgICAgICAgCiAgICAKICAgICAgICB2YXIgcG9wdXBfYWU2ZTZmNjE0ZWQ3NDA5MGEzMjZiZmY1ODE3ZWUxM2IgPSBMLnBvcHVwKHsibWF4V2lkdGgiOiAiMTAwJSJ9KTsKCiAgICAgICAgCiAgICAgICAgICAgIHZhciBodG1sX2QwZjQyZWU1NWIzNDQ5MTE5MGU2OWY5NTg3MGFiOWZmID0gJChgPGRpdiBpZD0iaHRtbF9kMGY0MmVlNTViMzQ0OTExOTBlNjlmOTU4NzBhYjlmZiIgc3R5bGU9IndpZHRoOiAxMDAuMCU7IGhlaWdodDogMTAwLjAlOyI+TmFtZTogTEVHR0VUVCBESVRDSCBQcmVjaXA6IDIuMjQ8L2Rpdj5gKVswXTsKICAgICAgICAgICAgcG9wdXBfYWU2ZTZmNjE0ZWQ3NDA5MGEzMjZiZmY1ODE3ZWUxM2Iuc2V0Q29udGVudChodG1sX2QwZjQyZWU1NWIzNDQ5MTE5MGU2OWY5NTg3MGFiOWZmKTsKICAgICAgICAKCiAgICAgICAgbWFya2VyX2FiYjk5NGZjNmRkNDQ3MTFhNWExZTU5ZTYxYmQ2YTQ0LmJpbmRQb3B1cChwb3B1cF9hZTZlNmY2MTRlZDc0MDkwYTMyNmJmZjU4MTdlZTEzYikKICAgICAgICA7CgogICAgICAgIAogICAgCiAgICAKICAgICAgICAgICAgdmFyIG1hcmtlcl9mOTAyZjRmOWQxYTU0OGE4YWJmYWNmMzQ5ZjljZWQzZiA9IEwubWFya2VyKAogICAgICAgICAgICAgICAgWzQwLjA1OTgwOSwgLTEwNS4wOTc4NzJdLAogICAgICAgICAgICAgICAge30KICAgICAgICAgICAgKS5hZGRUbyhtYXJrZXJfY2x1c3Rlcl81OTU0NGVmMGI1MWU0NGU3YmY0OTY0MGFjYTllMDcyNyk7CiAgICAgICAgCiAgICAKICAgICAgICB2YXIgcG9wdXBfY2E3ODg3YzlkOTRlNDhmMDlhZmZmZTk0Yzk4YzJlNmIgPSBMLnBvcHVwKHsibWF4V2lkdGgiOiAiMTAwJSJ9KTsKCiAgICAgICAgCiAgICAgICAgICAgIHZhciBodG1sX2MyZDBjYTI4YTkxZDRkYzlhYzcwNjE0ODc1ZmYzNWY4ID0gJChgPGRpdiBpZD0iaHRtbF9jMmQwY2EyOGE5MWQ0ZGM5YWM3MDYxNDg3NWZmMzVmOCIgc3R5bGU9IndpZHRoOiAxMDAuMCU7IGhlaWdodDogMTAwLjAlOyI+TmFtZTogQk9VTERFUiBDUkVFSyBBVCAxMDkgU1QgTkVBUiBFUklFLCBDTyBQcmVjaXA6IDI5LjUwPC9kaXY+YClbMF07CiAgICAgICAgICAgIHBvcHVwX2NhNzg4N2M5ZDk0ZTQ4ZjA5YWZmZmU5NGM5OGMyZTZiLnNldENvbnRlbnQoaHRtbF9jMmQwY2EyOGE5MWQ0ZGM5YWM3MDYxNDg3NWZmMzVmOCk7CiAgICAgICAgCgogICAgICAgIG1hcmtlcl9mOTAyZjRmOWQxYTU0OGE4YWJmYWNmMzQ5ZjljZWQzZi5iaW5kUG9wdXAocG9wdXBfY2E3ODg3YzlkOTRlNDhmMDlhZmZmZTk0Yzk4YzJlNmIpCiAgICAgICAgOwoKICAgICAgICAKICAgIAogICAgCiAgICAgICAgICAgIHZhciBtYXJrZXJfZDQ3MTVlNzVhN2I0NDdjZWFhZDAzZjNjMTRjMDg5NzUgPSBMLm1hcmtlcigKICAgICAgICAgICAgICAgIFs0MC4yMTU2NTgsIC0xMDUuMzYzNDIyXSwKICAgICAgICAgICAgICAgIHt9CiAgICAgICAgICAgICkuYWRkVG8obWFya2VyX2NsdXN0ZXJfNTk1NDRlZjBiNTFlNDRlN2JmNDk2NDBhY2E5ZTA3MjcpOwogICAgICAgIAogICAgCiAgICAgICAgdmFyIHBvcHVwXzMxNzUxZTNlYWE5ZDRkNmY4MDQ3MzI0OTk2MDM0ZjYxID0gTC5wb3B1cCh7Im1heFdpZHRoIjogIjEwMCUifSk7CgogICAgICAgIAogICAgICAgICAgICB2YXIgaHRtbF81Yzk1ZmRmNmFiMTQ0YTI4ODM1MzgzNTdmY2ZkMzQ5MyA9ICQoYDxkaXYgaWQ9Imh0bWxfNWM5NWZkZjZhYjE0NGEyODgzNTM4MzU3ZmNmZDM0OTMiIHN0eWxlPSJ3aWR0aDogMTAwLjAlOyBoZWlnaHQ6IDEwMC4wJTsiPk5hbWU6IE5PUlRIIFNBSU5UIFZSQUlOIENSRUVLIEJFTE9XIEJVVFRPTlJPQ0sgIChSQUxQSCBQUklDRSkgUkVTRVJWT0lSIFByZWNpcDogMTkuMzA8L2Rpdj5gKVswXTsKICAgICAgICAgICAgcG9wdXBfMzE3NTFlM2VhYTlkNGQ2ZjgwNDczMjQ5OTYwMzRmNjEuc2V0Q29udGVudChodG1sXzVjOTVmZGY2YWIxNDRhMjg4MzUzODM1N2ZjZmQzNDkzKTsKICAgICAgICAKCiAgICAgICAgbWFya2VyX2Q0NzE1ZTc1YTdiNDQ3Y2VhYWQwM2YzYzE0YzA4OTc1LmJpbmRQb3B1cChwb3B1cF8zMTc1MWUzZWFhOWQ0ZDZmODA0NzMyNDk5NjAzNGY2MSkKICAgICAgICA7CgogICAgICAgIAogICAgCiAgICAKICAgICAgICAgICAgdmFyIG1hcmtlcl8yZDIyMzRkYThhZjI0YjJlYWJiMzI3NWQ1M2M0MWVhNyA9IEwubWFya2VyKAogICAgICAgICAgICAgICAgWzQwLjEyNjM4OSwgLTEwNS4zMDQ0MDRdLAogICAgICAgICAgICAgICAge30KICAgICAgICAgICAgKS5hZGRUbyhtYXJrZXJfY2x1c3Rlcl81OTU0NGVmMGI1MWU0NGU3YmY0OTY0MGFjYTllMDcyNyk7CiAgICAgICAgCiAgICAKICAgICAgICB2YXIgcG9wdXBfMTdlYzA3MjAxYWJjNDk3ZGJlNjEzMWE2NGVjZjlmM2MgPSBMLnBvcHVwKHsibWF4V2lkdGgiOiAiMTAwJSJ9KTsKCiAgICAgICAgCiAgICAgICAgICAgIHZhciBodG1sXzI4ZTBjMzcwMjFhYzQ5ZGE4NmEwNWY5ZTJjNTM0YjM5ID0gJChgPGRpdiBpZD0iaHRtbF8yOGUwYzM3MDIxYWM0OWRhODZhMDVmOWUyYzUzNGIzOSIgc3R5bGU9IndpZHRoOiAxMDAuMCU7IGhlaWdodDogMTAwLjAlOyI+TmFtZTogTEVGVCBIQU5EIENSRUVLIE5FQVIgQk9VTERFUiwgQ08uIFByZWNpcDogMTQuMDA8L2Rpdj5gKVswXTsKICAgICAgICAgICAgcG9wdXBfMTdlYzA3MjAxYWJjNDk3ZGJlNjEzMWE2NGVjZjlmM2Muc2V0Q29udGVudChodG1sXzI4ZTBjMzcwMjFhYzQ5ZGE4NmEwNWY5ZTJjNTM0YjM5KTsKICAgICAgICAKCiAgICAgICAgbWFya2VyXzJkMjIzNGRhOGFmMjRiMmVhYmIzMjc1ZDUzYzQxZWE3LmJpbmRQb3B1cChwb3B1cF8xN2VjMDcyMDFhYmM0OTdkYmU2MTMxYTY0ZWNmOWYzYykKICAgICAgICA7CgogICAgICAgIAogICAgCiAgICAKICAgICAgICAgICAgdmFyIG1hcmtlcl8zZjA5Zjg2MWVjMzI0MWE1OGY2NGI1NWMyMjU5M2Y0OCA9IEwubWFya2VyKAogICAgICAgICAgICAgICAgWzQwLjA4NjI3OCwgLTEwNS4yMTc1MTldLAogICAgICAgICAgICAgICAge30KICAgICAgICAgICAgKS5hZGRUbyhtYXJrZXJfY2x1c3Rlcl81OTU0NGVmMGI1MWU0NGU3YmY0OTY0MGFjYTllMDcyNyk7CiAgICAgICAgCiAgICAKICAgICAgICB2YXIgcG9wdXBfMGQ3YzkxY2M0ZDVhNDJjZGI5ZTc2ZjY2ZDhjZjAyNDAgPSBMLnBvcHVwKHsibWF4V2lkdGgiOiAiMTAwJSJ9KTsKCiAgICAgICAgCiAgICAgICAgICAgIHZhciBodG1sX2U5NjMwZDk0MjZjMjRiOGFhYzNjOWVlYTRjY2ZkYmUzID0gJChgPGRpdiBpZD0iaHRtbF9lOTYzMGQ5NDI2YzI0YjhhYWMzYzllZWE0Y2NmZGJlMyIgc3R5bGU9IndpZHRoOiAxMDAuMCU7IGhlaWdodDogMTAwLjAlOyI+TmFtZTogQk9VTERFUiBSRVNFUlZPSVIgSU5MRVQgUHJlY2lwOiA0My4yNzwvZGl2PmApWzBdOwogICAgICAgICAgICBwb3B1cF8wZDdjOTFjYzRkNWE0MmNkYjllNzZmNjZkOGNmMDI0MC5zZXRDb250ZW50KGh0bWxfZTk2MzBkOTQyNmMyNGI4YWFjM2M5ZWVhNGNjZmRiZTMpOwogICAgICAgIAoKICAgICAgICBtYXJrZXJfM2YwOWY4NjFlYzMyNDFhNThmNjRiNTVjMjI1OTNmNDguYmluZFBvcHVwKHBvcHVwXzBkN2M5MWNjNGQ1YTQyY2RiOWU3NmY2NmQ4Y2YwMjQwKQogICAgICAgIDsKCiAgICAgICAgCiAgICAKICAgIAogICAgICAgICAgICB2YXIgbWFya2VyX2Y4ZjEwOGQzMjY1NjQwNjg5ODcwYjA5NTM2YTIxMTdiID0gTC5tYXJrZXIoCiAgICAgICAgICAgICAgICBbNDAuMTkzMDE5LCAtMTA1LjIxMDM4OF0sCiAgICAgICAgICAgICAgICB7fQogICAgICAgICAgICApLmFkZFRvKG1hcmtlcl9jbHVzdGVyXzU5NTQ0ZWYwYjUxZTQ0ZTdiZjQ5NjQwYWNhOWUwNzI3KTsKICAgICAgICAKICAgIAogICAgICAgIHZhciBwb3B1cF82NjlhNDQ1MDQ0N2Q0NmY0YTdiOGUwMjBiNzUyNTExNSA9IEwucG9wdXAoeyJtYXhXaWR0aCI6ICIxMDAlIn0pOwoKICAgICAgICAKICAgICAgICAgICAgdmFyIGh0bWxfNGRhNTZhYzk2MGY1NDM0OGJhODU4NTkyZmZjZjA2NWUgPSAkKGA8ZGl2IGlkPSJodG1sXzRkYTU2YWM5NjBmNTQzNDhiYTg1ODU5MmZmY2YwNjVlIiBzdHlsZT0id2lkdGg6IDEwMC4wJTsgaGVpZ2h0OiAxMDAuMCU7Ij5OYW1lOiBUUlVFIEFORCBXRUJTVEVSIERJVENIIFByZWNpcDogMC4wMDwvZGl2PmApWzBdOwogICAgICAgICAgICBwb3B1cF82NjlhNDQ1MDQ0N2Q0NmY0YTdiOGUwMjBiNzUyNTExNS5zZXRDb250ZW50KGh0bWxfNGRhNTZhYzk2MGY1NDM0OGJhODU4NTkyZmZjZjA2NWUpOwogICAgICAgIAoKICAgICAgICBtYXJrZXJfZjhmMTA4ZDMyNjU2NDA2ODk4NzBiMDk1MzZhMjExN2IuYmluZFBvcHVwKHBvcHVwXzY2OWE0NDUwNDQ3ZDQ2ZjRhN2I4ZTAyMGI3NTI1MTE1KQogICAgICAgIDsKCiAgICAgICAgCiAgICAKICAgIAogICAgICAgICAgICB2YXIgbWFya2VyX2VmNzIzM2FkYWM4NDRjZGVhNGJhZjUzMTM0YzQzMmFiID0gTC5tYXJrZXIoCiAgICAgICAgICAgICAgICBbNDAuMjEyNjU4LCAtMTA1LjI1MTgyNl0sCiAgICAgICAgICAgICAgICB7fQogICAgICAgICAgICApLmFkZFRvKG1hcmtlcl9jbHVzdGVyXzU5NTQ0ZWYwYjUxZTQ0ZTdiZjQ5NjQwYWNhOWUwNzI3KTsKICAgICAgICAKICAgIAogICAgICAgIHZhciBwb3B1cF8yNzU2Y2U5NTViYTg0MGY3YTg0ZjU5MGFhYjE2MmMzOSA9IEwucG9wdXAoeyJtYXhXaWR0aCI6ICIxMDAlIn0pOwoKICAgICAgICAKICAgICAgICAgICAgdmFyIGh0bWxfNWE4OGUzZGNkYTQ2NGI2YWEwNDAzZGM1NmNkZTNhYjYgPSAkKGA8ZGl2IGlkPSJodG1sXzVhODhlM2RjZGE0NjRiNmFhMDQwM2RjNTZjZGUzYWI2IiBzdHlsZT0id2lkdGg6IDEwMC4wJTsgaGVpZ2h0OiAxMDAuMCU7Ij5OYW1lOiBST1VHSCBBTkQgUkVBRFkgRElUQ0ggUHJlY2lwOiAwLjAwPC9kaXY+YClbMF07CiAgICAgICAgICAgIHBvcHVwXzI3NTZjZTk1NWJhODQwZjdhODRmNTkwYWFiMTYyYzM5LnNldENvbnRlbnQoaHRtbF81YTg4ZTNkY2RhNDY0YjZhYTA0MDNkYzU2Y2RlM2FiNik7CiAgICAgICAgCgogICAgICAgIG1hcmtlcl9lZjcyMzNhZGFjODQ0Y2RlYTRiYWY1MzEzNGM0MzJhYi5iaW5kUG9wdXAocG9wdXBfMjc1NmNlOTU1YmE4NDBmN2E4NGY1OTBhYWIxNjJjMzkpCiAgICAgICAgOwoKICAgICAgICAKICAgIAogICAgCiAgICAgICAgICAgIHZhciBtYXJrZXJfMTY2MTgwNTUxN2QwNDUzZGFkOWY3ZjRjN2IwNjgxYzAgPSBMLm1hcmtlcigKICAgICAgICAgICAgICAgIFs0MC4xNzQ4NDQsIC0xMDUuMTY3ODczXSwKICAgICAgICAgICAgICAgIHt9CiAgICAgICAgICAgICkuYWRkVG8obWFya2VyX2NsdXN0ZXJfNTk1NDRlZjBiNTFlNDRlN2JmNDk2NDBhY2E5ZTA3MjcpOwogICAgICAgIAogICAgCiAgICAgICAgdmFyIHBvcHVwXzJhOWUwNjg4YjEwOTQ5NzA5OWEzNWZmNTVlNDEzNTA3ID0gTC5wb3B1cCh7Im1heFdpZHRoIjogIjEwMCUifSk7CgogICAgICAgIAogICAgICAgICAgICB2YXIgaHRtbF9lZDgzMmViNDkwOGY0ZTc4OTczODAwNGY1YWJmZWFjYiA9ICQoYDxkaXYgaWQ9Imh0bWxfZWQ4MzJlYjQ5MDhmNGU3ODk3MzgwMDRmNWFiZmVhY2IiIHN0eWxlPSJ3aWR0aDogMTAwLjAlOyBoZWlnaHQ6IDEwMC4wJTsiPk5hbWU6IEhBR0VSIE1FQURPV1MgRElUQ0ggUHJlY2lwOiAwLjEyPC9kaXY+YClbMF07CiAgICAgICAgICAgIHBvcHVwXzJhOWUwNjg4YjEwOTQ5NzA5OWEzNWZmNTVlNDEzNTA3LnNldENvbnRlbnQoaHRtbF9lZDgzMmViNDkwOGY0ZTc4OTczODAwNGY1YWJmZWFjYik7CiAgICAgICAgCgogICAgICAgIG1hcmtlcl8xNjYxODA1NTE3ZDA0NTNkYWQ5ZjdmNGM3YjA2ODFjMC5iaW5kUG9wdXAocG9wdXBfMmE5ZTA2ODhiMTA5NDk3MDk5YTM1ZmY1NWU0MTM1MDcpCiAgICAgICAgOwoKICAgICAgICAKICAgIAogICAgCiAgICAgICAgICAgIHZhciBtYXJrZXJfN2I2NTFhN2U3ZjcxNDYzMDlmZmVjMjk0Y2IzMDIxZGYgPSBMLm1hcmtlcigKICAgICAgICAgICAgICAgIFs0MC4yNTYyNzYsIC0xMDUuMjA5NDE2XSwKICAgICAgICAgICAgICAgIHt9CiAgICAgICAgICAgICkuYWRkVG8obWFya2VyX2NsdXN0ZXJfNTk1NDRlZjBiNTFlNDRlN2JmNDk2NDBhY2E5ZTA3MjcpOwogICAgICAgIAogICAgCiAgICAgICAgdmFyIHBvcHVwXzZmZmNhZTRhYzFmNzRlYzE4ZDllZjUzZGM1Y2MyZTZlID0gTC5wb3B1cCh7Im1heFdpZHRoIjogIjEwMCUifSk7CgogICAgICAgIAogICAgICAgICAgICB2YXIgaHRtbF8yYjdlNDZiZjI4NzA0NGE2OTIwYzQwYjlkNTE4ZDc1OCA9ICQoYDxkaXYgaWQ9Imh0bWxfMmI3ZTQ2YmYyODcwNDRhNjkyMGM0MGI5ZDUxOGQ3NTgiIHN0eWxlPSJ3aWR0aDogMTAwLjAlOyBoZWlnaHQ6IDEwMC4wJTsiPk5hbWU6IExJVFRMRSBUSE9NUFNPTiAjMSBESVRDSCBQcmVjaXA6IDAuMDA8L2Rpdj5gKVswXTsKICAgICAgICAgICAgcG9wdXBfNmZmY2FlNGFjMWY3NGVjMThkOWVmNTNkYzVjYzJlNmUuc2V0Q29udGVudChodG1sXzJiN2U0NmJmMjg3MDQ0YTY5MjBjNDBiOWQ1MThkNzU4KTsKICAgICAgICAKCiAgICAgICAgbWFya2VyXzdiNjUxYTdlN2Y3MTQ2MzA5ZmZlYzI5NGNiMzAyMWRmLmJpbmRQb3B1cChwb3B1cF82ZmZjYWU0YWMxZjc0ZWMxOGQ5ZWY1M2RjNWNjMmU2ZSkKICAgICAgICA7CgogICAgICAgIAogICAgCiAgICAKICAgICAgICAgICAgdmFyIG1hcmtlcl9kYjAyNmU1ZjAwZjY0NjQ5YTUzYjk3NDk4NTg1NzY1YyA9IEwubWFya2VyKAogICAgICAgICAgICAgICAgWzQwLjI2MDgyNywgLTEwNS4xOTg1NjddLAogICAgICAgICAgICAgICAge30KICAgICAgICAgICAgKS5hZGRUbyhtYXJrZXJfY2x1c3Rlcl81OTU0NGVmMGI1MWU0NGU3YmY0OTY0MGFjYTllMDcyNyk7CiAgICAgICAgCiAgICAKICAgICAgICB2YXIgcG9wdXBfMTEyZWRjYTIxODFhNGIwNWI4YjEwMjM3OWEyYTNjY2YgPSBMLnBvcHVwKHsibWF4V2lkdGgiOiAiMTAwJSJ9KTsKCiAgICAgICAgCiAgICAgICAgICAgIHZhciBodG1sXzg1MjgzZWQ1MGU2NDQwZWI5OTE1ZDU1MDA3NTAwZmZkID0gJChgPGRpdiBpZD0iaHRtbF84NTI4M2VkNTBlNjQ0MGViOTkxNWQ1NTAwNzUwMGZmZCIgc3R5bGU9IndpZHRoOiAxMDAuMCU7IGhlaWdodDogMTAwLjAlOyI+TmFtZTogQ1VMVkVSIERJVENIIFByZWNpcDogMC4wMDwvZGl2PmApWzBdOwogICAgICAgICAgICBwb3B1cF8xMTJlZGNhMjE4MWE0YjA1YjhiMTAyMzc5YTJhM2NjZi5zZXRDb250ZW50KGh0bWxfODUyODNlZDUwZTY0NDBlYjk5MTVkNTUwMDc1MDBmZmQpOwogICAgICAgIAoKICAgICAgICBtYXJrZXJfZGIwMjZlNWYwMGY2NDY0OWE1M2I5NzQ5ODU4NTc2NWMuYmluZFBvcHVwKHBvcHVwXzExMmVkY2EyMTgxYTRiMDViOGIxMDIzNzlhMmEzY2NmKQogICAgICAgIDsKCiAgICAgICAgCiAgICAKICAgIAogICAgICAgICAgICB2YXIgbWFya2VyXzE3Zjc0MTQ0NjIzNTRmMWY5ZjU5MGM2Y2RkZDdiYzA4ID0gTC5tYXJrZXIoCiAgICAgICAgICAgICAgICBbNDAuMjE1MDQzLCAtMTA1LjI1NjAxN10sCiAgICAgICAgICAgICAgICB7fQogICAgICAgICAgICApLmFkZFRvKG1hcmtlcl9jbHVzdGVyXzU5NTQ0ZWYwYjUxZTQ0ZTdiZjQ5NjQwYWNhOWUwNzI3KTsKICAgICAgICAKICAgIAogICAgICAgIHZhciBwb3B1cF80M2MwNDk3ODMzNmU0OTE1YTc5ODU5N2M3ZTYxYzEyYiA9IEwucG9wdXAoeyJtYXhXaWR0aCI6ICIxMDAlIn0pOwoKICAgICAgICAKICAgICAgICAgICAgdmFyIGh0bWxfYjVjNDJhNTI0ZTM1NDhkMWJiNWFjNDllODMwNzBiYzEgPSAkKGA8ZGl2IGlkPSJodG1sX2I1YzQyYTUyNGUzNTQ4ZDFiYjVhYzQ5ZTgzMDcwYmMxIiBzdHlsZT0id2lkdGg6IDEwMC4wJTsgaGVpZ2h0OiAxMDAuMCU7Ij5OYW1lOiBISUdITEFORCBESVRDSCBBVCBMWU9OUywgQ08gUHJlY2lwOiAzNy4yMDwvZGl2PmApWzBdOwogICAgICAgICAgICBwb3B1cF80M2MwNDk3ODMzNmU0OTE1YTc5ODU5N2M3ZTYxYzEyYi5zZXRDb250ZW50KGh0bWxfYjVjNDJhNTI0ZTM1NDhkMWJiNWFjNDllODMwNzBiYzEpOwogICAgICAgIAoKICAgICAgICBtYXJrZXJfMTdmNzQxNDQ2MjM1NGYxZjlmNTkwYzZjZGRkN2JjMDguYmluZFBvcHVwKHBvcHVwXzQzYzA0OTc4MzM2ZTQ5MTVhNzk4NTk3YzdlNjFjMTJiKQogICAgICAgIDsKCiAgICAgICAgCiAgICAKICAgIAogICAgICAgICAgICB2YXIgbWFya2VyX2JhMWI1MjMzMjU2YTQwZThhOGM4YzYzNGM2YTY5NjNhID0gTC5tYXJrZXIoCiAgICAgICAgICAgICAgICBbNDAuMDc4NTYsIC0xMDUuMjIwNDk3XSwKICAgICAgICAgICAgICAgIHt9CiAgICAgICAgICAgICkuYWRkVG8obWFya2VyX2NsdXN0ZXJfNTk1NDRlZjBiNTFlNDRlN2JmNDk2NDBhY2E5ZTA3MjcpOwogICAgICAgIAogICAgCiAgICAgICAgdmFyIHBvcHVwXzExMjk1ZGVmZThhZDRiZGNhNjg2MzMyOWFiOWVlOGNjID0gTC5wb3B1cCh7Im1heFdpZHRoIjogIjEwMCUifSk7CgogICAgICAgIAogICAgICAgICAgICB2YXIgaHRtbF82ZDAyYmE5ZGRmZDI0OGViOTc5ZWQzN2IxYTRjNWMwMyA9ICQoYDxkaXYgaWQ9Imh0bWxfNmQwMmJhOWRkZmQyNDhlYjk3OWVkMzdiMWE0YzVjMDMiIHN0eWxlPSJ3aWR0aDogMTAwLjAlOyBoZWlnaHQ6IDEwMC4wJTsiPk5hbWU6IEJPVUxERVIgUkVTRVJWT0lSIFByZWNpcDogNTE3NS4wMDwvZGl2PmApWzBdOwogICAgICAgICAgICBwb3B1cF8xMTI5NWRlZmU4YWQ0YmRjYTY4NjMzMjlhYjllZThjYy5zZXRDb250ZW50KGh0bWxfNmQwMmJhOWRkZmQyNDhlYjk3OWVkMzdiMWE0YzVjMDMpOwogICAgICAgIAoKICAgICAgICBtYXJrZXJfYmExYjUyMzMyNTZhNDBlOGE4YzhjNjM0YzZhNjk2M2EuYmluZFBvcHVwKHBvcHVwXzExMjk1ZGVmZThhZDRiZGNhNjg2MzMyOWFiOWVlOGNjKQogICAgICAgIDsKCiAgICAgICAgCiAgICAKICAgIAogICAgICAgICAgICB2YXIgbWFya2VyXzlhNjg5M2IxMDJlNTQ1YzBiYzAxNjJhM2I1YjdmZjA5ID0gTC5tYXJrZXIoCiAgICAgICAgICAgICAgICBbNDAuMTczOTUsIC0xMDUuMTY5Mzc0XSwKICAgICAgICAgICAgICAgIHt9CiAgICAgICAgICAgICkuYWRkVG8obWFya2VyX2NsdXN0ZXJfNTk1NDRlZjBiNTFlNDRlN2JmNDk2NDBhY2E5ZTA3MjcpOwogICAgICAgIAogICAgCiAgICAgICAgdmFyIHBvcHVwX2NmYjY4Y2RjN2M5ZjQ0M2RiOWVkOTcwNzQwNWZmYzdjID0gTC5wb3B1cCh7Im1heFdpZHRoIjogIjEwMCUifSk7CgogICAgICAgIAogICAgICAgICAgICB2YXIgaHRtbF83ZmYwZWMwYzBjNWQ0ODkzYjdmMWQ5MjRkOTg0YmY0MSA9ICQoYDxkaXYgaWQ9Imh0bWxfN2ZmMGVjMGMwYzVkNDg5M2I3ZjFkOTI0ZDk4NGJmNDEiIHN0eWxlPSJ3aWR0aDogMTAwLjAlOyBoZWlnaHQ6IDEwMC4wJTsiPk5hbWU6IE5JV09UIERJVENIIFByZWNpcDogMC4xOTwvZGl2PmApWzBdOwogICAgICAgICAgICBwb3B1cF9jZmI2OGNkYzdjOWY0NDNkYjllZDk3MDc0MDVmZmM3Yy5zZXRDb250ZW50KGh0bWxfN2ZmMGVjMGMwYzVkNDg5M2I3ZjFkOTI0ZDk4NGJmNDEpOwogICAgICAgIAoKICAgICAgICBtYXJrZXJfOWE2ODkzYjEwMmU1NDVjMGJjMDE2MmEzYjViN2ZmMDkuYmluZFBvcHVwKHBvcHVwX2NmYjY4Y2RjN2M5ZjQ0M2RiOWVkOTcwNzQwNWZmYzdjKQogICAgICAgIDsKCiAgICAgICAgCiAgICAKICAgIAogICAgICAgICAgICB2YXIgbWFya2VyXzg2NjFkZGZmZDMxYjQwMTU5MzBiNzg4YmEzNDYxMTRjID0gTC5tYXJrZXIoCiAgICAgICAgICAgICAgICBbNDAuMjExMzg5LCAtMTA1LjI1MDk1Ml0sCiAgICAgICAgICAgICAgICB7fQogICAgICAgICAgICApLmFkZFRvKG1hcmtlcl9jbHVzdGVyXzU5NTQ0ZWYwYjUxZTQ0ZTdiZjQ5NjQwYWNhOWUwNzI3KTsKICAgICAgICAKICAgIAogICAgICAgIHZhciBwb3B1cF9mN2YwODkxZDQ3ZGY0ZGY0YjA4ZmFjMGFkYmQyZjA4NSA9IEwucG9wdXAoeyJtYXhXaWR0aCI6ICIxMDAlIn0pOwoKICAgICAgICAKICAgICAgICAgICAgdmFyIGh0bWxfMzI2ZTkzY2MwNWJlNDk0MzkzZTQ0OGI4YjRkZTg1ZmMgPSAkKGA8ZGl2IGlkPSJodG1sXzMyNmU5M2NjMDViZTQ5NDM5M2U0NDhiOGI0ZGU4NWZjIiBzdHlsZT0id2lkdGg6IDEwMC4wJTsgaGVpZ2h0OiAxMDAuMCU7Ij5OYW1lOiBTTUVBRCBESVRDSCBQcmVjaXA6IDAuMDA8L2Rpdj5gKVswXTsKICAgICAgICAgICAgcG9wdXBfZjdmMDg5MWQ0N2RmNGRmNGIwOGZhYzBhZGJkMmYwODUuc2V0Q29udGVudChodG1sXzMyNmU5M2NjMDViZTQ5NDM5M2U0NDhiOGI0ZGU4NWZjKTsKICAgICAgICAKCiAgICAgICAgbWFya2VyXzg2NjFkZGZmZDMxYjQwMTU5MzBiNzg4YmEzNDYxMTRjLmJpbmRQb3B1cChwb3B1cF9mN2YwODkxZDQ3ZGY0ZGY0YjA4ZmFjMGFkYmQyZjA4NSkKICAgICAgICA7CgogICAgICAgIAogICAgCiAgICAKICAgICAgICAgICAgdmFyIG1hcmtlcl9hNzU5ZTE0NTU3ZmQ0ZmQ0ODdlMmQ5NWQ3ZGY0NTViMSA9IEwubWFya2VyKAogICAgICAgICAgICAgICAgWzM5LjkzODM1MSwgLTEwNS4zNDc5MDZdLAogICAgICAgICAgICAgICAge30KICAgICAgICAgICAgKS5hZGRUbyhtYXJrZXJfY2x1c3Rlcl81OTU0NGVmMGI1MWU0NGU3YmY0OTY0MGFjYTllMDcyNyk7CiAgICAgICAgCiAgICAKICAgICAgICB2YXIgcG9wdXBfZGVjZWQyZTBiMWQxNDk2MmFjOWVkOTU3MTNlMDM2NDYgPSBMLnBvcHVwKHsibWF4V2lkdGgiOiAiMTAwJSJ9KTsKCiAgICAgICAgCiAgICAgICAgICAgIHZhciBodG1sX2U4MTg5YTUyZjkxZjQ1NjE4MjQ3NmVlYmUzNmMxZjM1ID0gJChgPGRpdiBpZD0iaHRtbF9lODE4OWE1MmY5MWY0NTYxODI0NzZlZWJlMzZjMWYzNSIgc3R5bGU9IndpZHRoOiAxMDAuMCU7IGhlaWdodDogMTAwLjAlOyI+TmFtZTogU09VVEggQk9VTERFUiBDUkVFSyBCRUxPVyBHUk9TUyBSRVNFUlZPSVIgUHJlY2lwOiAxNi40MDwvZGl2PmApWzBdOwogICAgICAgICAgICBwb3B1cF9kZWNlZDJlMGIxZDE0OTYyYWM5ZWQ5NTcxM2UwMzY0Ni5zZXRDb250ZW50KGh0bWxfZTgxODlhNTJmOTFmNDU2MTgyNDc2ZWViZTM2YzFmMzUpOwogICAgICAgIAoKICAgICAgICBtYXJrZXJfYTc1OWUxNDU1N2ZkNGZkNDg3ZTJkOTVkN2RmNDU1YjEuYmluZFBvcHVwKHBvcHVwX2RlY2VkMmUwYjFkMTQ5NjJhYzllZDk1NzEzZTAzNjQ2KQogICAgICAgIDsKCiAgICAgICAgCiAgICAKICAgIAogICAgICAgICAgICB2YXIgbWFya2VyX2UyOWJmYWM2ZTY0MDRkMTViZDgzNmI1ODRkMDczOTU0ID0gTC5tYXJrZXIoCiAgICAgICAgICAgICAgICBbNDAuMjE4MzM1LCAtMTA1LjI1ODExXSwKICAgICAgICAgICAgICAgIHt9CiAgICAgICAgICAgICkuYWRkVG8obWFya2VyX2NsdXN0ZXJfNTk1NDRlZjBiNTFlNDRlN2JmNDk2NDBhY2E5ZTA3MjcpOwogICAgICAgIAogICAgCiAgICAgICAgdmFyIHBvcHVwXzFiNTliNDU5YmE4ODQ0YjI4ZDIwODA1NWQ1NWRhOWY3ID0gTC5wb3B1cCh7Im1heFdpZHRoIjogIjEwMCUifSk7CgogICAgICAgIAogICAgICAgICAgICB2YXIgaHRtbF9lMmU4OGY2YWVmZmI0ODU3YTgzMTY3MGNmNjI5Mzk2NSA9ICQoYDxkaXYgaWQ9Imh0bWxfZTJlODhmNmFlZmZiNDg1N2E4MzE2NzBjZjYyOTM5NjUiIHN0eWxlPSJ3aWR0aDogMTAwLjAlOyBoZWlnaHQ6IDEwMC4wJTsiPk5hbWU6IFNBSU5UIFZSQUlOIFNVUFBMWSBDQU5BTCBORUFSIExZT05TLCBDTyBQcmVjaXA6IDQzLjMwPC9kaXY+YClbMF07CiAgICAgICAgICAgIHBvcHVwXzFiNTliNDU5YmE4ODQ0YjI4ZDIwODA1NWQ1NWRhOWY3LnNldENvbnRlbnQoaHRtbF9lMmU4OGY2YWVmZmI0ODU3YTgzMTY3MGNmNjI5Mzk2NSk7CiAgICAgICAgCgogICAgICAgIG1hcmtlcl9lMjliZmFjNmU2NDA0ZDE1YmQ4MzZiNTg0ZDA3Mzk1NC5iaW5kUG9wdXAocG9wdXBfMWI1OWI0NTliYTg4NDRiMjhkMjA4MDU1ZDU1ZGE5ZjcpCiAgICAgICAgOwoKICAgICAgICAKICAgIAogICAgCiAgICAgICAgICAgIHZhciBtYXJrZXJfYjA5NmMxMDA1YjM0NGQ4OGJjMjQyN2U4NjJlYzBlZDQgPSBMLm1hcmtlcigKICAgICAgICAgICAgICAgIFs0MC4xNTMzNjMsIC0xMDUuMDg4Njk1XSwKICAgICAgICAgICAgICAgIHt9CiAgICAgICAgICAgICkuYWRkVG8obWFya2VyX2NsdXN0ZXJfNTk1NDRlZjBiNTFlNDRlN2JmNDk2NDBhY2E5ZTA3MjcpOwogICAgICAgIAogICAgCiAgICAgICAgdmFyIHBvcHVwXzI4M2ZkMGNhZTc5NjQ1NzM5YmNmMDNiNjdiM2JmMWU2ID0gTC5wb3B1cCh7Im1heFdpZHRoIjogIjEwMCUifSk7CgogICAgICAgIAogICAgICAgICAgICB2YXIgaHRtbF9jMWIwYWM5MjNhMDQ0Nzc5YTlmYTYyMmZiMDE3M2E1MSA9ICQoYDxkaXYgaWQ9Imh0bWxfYzFiMGFjOTIzYTA0NDc3OWE5ZmE2MjJmYjAxNzNhNTEiIHN0eWxlPSJ3aWR0aDogMTAwLjAlOyBoZWlnaHQ6IDEwMC4wJTsiPk5hbWU6IEJPTlVTIERJVENIIFByZWNpcDogMC4xMDwvZGl2PmApWzBdOwogICAgICAgICAgICBwb3B1cF8yODNmZDBjYWU3OTY0NTczOWJjZjAzYjY3YjNiZjFlNi5zZXRDb250ZW50KGh0bWxfYzFiMGFjOTIzYTA0NDc3OWE5ZmE2MjJmYjAxNzNhNTEpOwogICAgICAgIAoKICAgICAgICBtYXJrZXJfYjA5NmMxMDA1YjM0NGQ4OGJjMjQyN2U4NjJlYzBlZDQuYmluZFBvcHVwKHBvcHVwXzI4M2ZkMGNhZTc5NjQ1NzM5YmNmMDNiNjdiM2JmMWU2KQogICAgICAgIDsKCiAgICAgICAgCiAgICAKICAgIAogICAgICAgICAgICB2YXIgbWFya2VyX2MxN2JlOGRiZDNjMjQ4NTk5NTJjNWEyNzUyZDA2OGVhID0gTC5tYXJrZXIoCiAgICAgICAgICAgICAgICBbMzkuOTYxNjU1LCAtMTA1LjUwNDQ0XSwKICAgICAgICAgICAgICAgIHt9CiAgICAgICAgICAgICkuYWRkVG8obWFya2VyX2NsdXN0ZXJfNTk1NDRlZjBiNTFlNDRlN2JmNDk2NDBhY2E5ZTA3MjcpOwogICAgICAgIAogICAgCiAgICAgICAgdmFyIHBvcHVwXzA2NzRhZjQ4YjU1ODQ0MWI4MDVlNWE5MWQ4MzljNmU2ID0gTC5wb3B1cCh7Im1heFdpZHRoIjogIjEwMCUifSk7CgogICAgICAgIAogICAgICAgICAgICB2YXIgaHRtbF9jN2QzOTNmZDliZGE0YzMzYTViOGUwNzZhZTAyN2FhZSA9ICQoYDxkaXYgaWQ9Imh0bWxfYzdkMzkzZmQ5YmRhNGMzM2E1YjhlMDc2YWUwMjdhYWUiIHN0eWxlPSJ3aWR0aDogMTAwLjAlOyBoZWlnaHQ6IDEwMC4wJTsiPk5hbWU6IE1JRERMRSBCT1VMREVSIENSRUVLIEFUIE5FREVSTEFORCwgQ08uIFByZWNpcDogMjQuNjA8L2Rpdj5gKVswXTsKICAgICAgICAgICAgcG9wdXBfMDY3NGFmNDhiNTU4NDQxYjgwNWU1YTkxZDgzOWM2ZTYuc2V0Q29udGVudChodG1sX2M3ZDM5M2ZkOWJkYTRjMzNhNWI4ZTA3NmFlMDI3YWFlKTsKICAgICAgICAKCiAgICAgICAgbWFya2VyX2MxN2JlOGRiZDNjMjQ4NTk5NTJjNWEyNzUyZDA2OGVhLmJpbmRQb3B1cChwb3B1cF8wNjc0YWY0OGI1NTg0NDFiODA1ZTVhOTFkODM5YzZlNikKICAgICAgICA7CgogICAgICAgIAogICAgCiAgICAKICAgICAgICAgICAgdmFyIG1hcmtlcl9mMmU2YTRiODVmMzY0N2Y2YWMxMTE5MzgxOWIwYTM3YyA9IEwubWFya2VyKAogICAgICAgICAgICAgICAgWzQwLjIxMTA4MywgLTEwNS4yNTA5MjddLAogICAgICAgICAgICAgICAge30KICAgICAgICAgICAgKS5hZGRUbyhtYXJrZXJfY2x1c3Rlcl81OTU0NGVmMGI1MWU0NGU3YmY0OTY0MGFjYTllMDcyNyk7CiAgICAgICAgCiAgICAKICAgICAgICB2YXIgcG9wdXBfZjNhNzM1N2U3YWNkNGRmMzhlNmUxNWQyY2MyYTg2MWEgPSBMLnBvcHVwKHsibWF4V2lkdGgiOiAiMTAwJSJ9KTsKCiAgICAgICAgCiAgICAgICAgICAgIHZhciBodG1sX2MxOWIxMGJkM2QwODRmYTE5MzQzOGI5NDkyZDg3YTRjID0gJChgPGRpdiBpZD0iaHRtbF9jMTliMTBiZDNkMDg0ZmExOTM0MzhiOTQ5MmQ4N2E0YyIgc3R5bGU9IndpZHRoOiAxMDAuMCU7IGhlaWdodDogMTAwLjAlOyI+TmFtZTogU1dFREUgRElUQ0ggUHJlY2lwOiAwLjAwPC9kaXY+YClbMF07CiAgICAgICAgICAgIHBvcHVwX2YzYTczNTdlN2FjZDRkZjM4ZTZlMTVkMmNjMmE4NjFhLnNldENvbnRlbnQoaHRtbF9jMTliMTBiZDNkMDg0ZmExOTM0MzhiOTQ5MmQ4N2E0Yyk7CiAgICAgICAgCgogICAgICAgIG1hcmtlcl9mMmU2YTRiODVmMzY0N2Y2YWMxMTE5MzgxOWIwYTM3Yy5iaW5kUG9wdXAocG9wdXBfZjNhNzM1N2U3YWNkNGRmMzhlNmUxNWQyY2MyYTg2MWEpCiAgICAgICAgOwoKICAgICAgICAKICAgIAogICAgCiAgICAgICAgICAgIHZhciBtYXJrZXJfYzQxNDg5YWE4NTIyNDJhMGI0NzU0YWJmNDkxODc5M2QgPSBMLm1hcmtlcigKICAgICAgICAgICAgICAgIFs0MC4xODc1MjQsIC0xMDUuMTg5MTMyXSwKICAgICAgICAgICAgICAgIHt9CiAgICAgICAgICAgICkuYWRkVG8obWFya2VyX2NsdXN0ZXJfNTk1NDRlZjBiNTFlNDRlN2JmNDk2NDBhY2E5ZTA3MjcpOwogICAgICAgIAogICAgCiAgICAgICAgdmFyIHBvcHVwX2ZiNjE0ZTU5OGUyMjRhNDM4MzJhOGFhOWY4ZDc1NTFlID0gTC5wb3B1cCh7Im1heFdpZHRoIjogIjEwMCUifSk7CgogICAgICAgIAogICAgICAgICAgICB2YXIgaHRtbF8xOTM5MjRhZGRhMzI0YWMzOGIyNDQ0YjFjYWE2NWJmMyA9ICQoYDxkaXYgaWQ9Imh0bWxfMTkzOTI0YWRkYTMyNGFjMzhiMjQ0NGIxY2FhNjViZjMiIHN0eWxlPSJ3aWR0aDogMTAwLjAlOyBoZWlnaHQ6IDEwMC4wJTsiPk5hbWU6IFJVTllPTiBESVRDSCBQcmVjaXA6IDAuMDA8L2Rpdj5gKVswXTsKICAgICAgICAgICAgcG9wdXBfZmI2MTRlNTk4ZTIyNGE0MzgzMmE4YWE5ZjhkNzU1MWUuc2V0Q29udGVudChodG1sXzE5MzkyNGFkZGEzMjRhYzM4YjI0NDRiMWNhYTY1YmYzKTsKICAgICAgICAKCiAgICAgICAgbWFya2VyX2M0MTQ4OWFhODUyMjQyYTBiNDc1NGFiZjQ5MTg3OTNkLmJpbmRQb3B1cChwb3B1cF9mYjYxNGU1OThlMjI0YTQzODMyYThhYTlmOGQ3NTUxZSkKICAgICAgICA7CgogICAgICAgIAogICAgCiAgICAKICAgICAgICAgICAgdmFyIG1hcmtlcl8xZWFkMWQ3ZDI5ODg0NmNkYTNmM2NhMGRmOWNkYWRmMiA9IEwubWFya2VyKAogICAgICAgICAgICAgICAgWzQwLjE4MTg4LCAtMTA1LjE5Njc3NV0sCiAgICAgICAgICAgICAgICB7fQogICAgICAgICAgICApLmFkZFRvKG1hcmtlcl9jbHVzdGVyXzU5NTQ0ZWYwYjUxZTQ0ZTdiZjQ5NjQwYWNhOWUwNzI3KTsKICAgICAgICAKICAgIAogICAgICAgIHZhciBwb3B1cF84NmVkODYwNDkyYTg0YmUyYTQzMzY0M2E4NmVhMGNmNyA9IEwucG9wdXAoeyJtYXhXaWR0aCI6ICIxMDAlIn0pOwoKICAgICAgICAKICAgICAgICAgICAgdmFyIGh0bWxfMDAyZDFlZDUwODRjNDc0Yjg1NWRiYzc5MjRmNThmOTcgPSAkKGA8ZGl2IGlkPSJodG1sXzAwMmQxZWQ1MDg0YzQ3NGI4NTVkYmM3OTI0ZjU4Zjk3IiBzdHlsZT0id2lkdGg6IDEwMC4wJTsgaGVpZ2h0OiAxMDAuMCU7Ij5OYW1lOiBEQVZJUyBBTkQgRE9XTklORyBESVRDSCBQcmVjaXA6IDAuMDA8L2Rpdj5gKVswXTsKICAgICAgICAgICAgcG9wdXBfODZlZDg2MDQ5MmE4NGJlMmE0MzM2NDNhODZlYTBjZjcuc2V0Q29udGVudChodG1sXzAwMmQxZWQ1MDg0YzQ3NGI4NTVkYmM3OTI0ZjU4Zjk3KTsKICAgICAgICAKCiAgICAgICAgbWFya2VyXzFlYWQxZDdkMjk4ODQ2Y2RhM2YzY2EwZGY5Y2RhZGYyLmJpbmRQb3B1cChwb3B1cF84NmVkODYwNDkyYTg0YmUyYTQzMzY0M2E4NmVhMGNmNykKICAgICAgICA7CgogICAgICAgIAogICAgCiAgICAKICAgICAgICAgICAgdmFyIG1hcmtlcl8wOTIxOWEwMzA2MzU0YWU2OTRmMWFmYzY5NGZmOWQyOSA9IEwubWFya2VyKAogICAgICAgICAgICAgICAgWzQwLjAxODY2NywgLTEwNS4zMjYyNV0sCiAgICAgICAgICAgICAgICB7fQogICAgICAgICAgICApLmFkZFRvKG1hcmtlcl9jbHVzdGVyXzU5NTQ0ZWYwYjUxZTQ0ZTdiZjQ5NjQwYWNhOWUwNzI3KTsKICAgICAgICAKICAgIAogICAgICAgIHZhciBwb3B1cF85OWRjZWJjNzQ0MDg0YmIwOTE3MzJmODNlNDAyNjNhZCA9IEwucG9wdXAoeyJtYXhXaWR0aCI6ICIxMDAlIn0pOwoKICAgICAgICAKICAgICAgICAgICAgdmFyIGh0bWxfOWFjNzUxMmQwNzQwNGQ3ZTg0NTIxOTVkYTEyY2JhOTIgPSAkKGA8ZGl2IGlkPSJodG1sXzlhYzc1MTJkMDc0MDRkN2U4NDUyMTk1ZGExMmNiYTkyIiBzdHlsZT0id2lkdGg6IDEwMC4wJTsgaGVpZ2h0OiAxMDAuMCU7Ij5OYW1lOiBGT1VSTUlMRSBDUkVFSyBBVCBPUk9ERUxMLCBDTyBQcmVjaXA6IDYuMDQ8L2Rpdj5gKVswXTsKICAgICAgICAgICAgcG9wdXBfOTlkY2ViYzc0NDA4NGJiMDkxNzMyZjgzZTQwMjYzYWQuc2V0Q29udGVudChodG1sXzlhYzc1MTJkMDc0MDRkN2U4NDUyMTk1ZGExMmNiYTkyKTsKICAgICAgICAKCiAgICAgICAgbWFya2VyXzA5MjE5YTAzMDYzNTRhZTY5NGYxYWZjNjk0ZmY5ZDI5LmJpbmRQb3B1cChwb3B1cF85OWRjZWJjNzQ0MDg0YmIwOTE3MzJmODNlNDAyNjNhZCkKICAgICAgICA7CgogICAgICAgIAogICAgCiAgICAKICAgICAgICAgICAgdmFyIG1hcmtlcl9hZTc0MWMyZTllNzY0Yjc1ODgwNTE2NDkyZTdkMGZjYSA9IEwubWFya2VyKAogICAgICAgICAgICAgICAgWzQwLjE4ODU3OSwgLTEwNS4yMDkyODJdLAogICAgICAgICAgICAgICAge30KICAgICAgICAgICAgKS5hZGRUbyhtYXJrZXJfY2x1c3Rlcl81OTU0NGVmMGI1MWU0NGU3YmY0OTY0MGFjYTllMDcyNyk7CiAgICAgICAgCiAgICAKICAgICAgICB2YXIgcG9wdXBfNThkY2RhOTA3NWQyNGU2ZTg4MTQ3ZDhjN2M0ZGM3YWUgPSBMLnBvcHVwKHsibWF4V2lkdGgiOiAiMTAwJSJ9KTsKCiAgICAgICAgCiAgICAgICAgICAgIHZhciBodG1sXzQzMjZlNTg5MWQxMDQxOWNiYzg4NjFlNmMzY2FiNGU4ID0gJChgPGRpdiBpZD0iaHRtbF80MzI2ZTU4OTFkMTA0MTljYmM4ODYxZTZjM2NhYjRlOCIgc3R5bGU9IndpZHRoOiAxMDAuMCU7IGhlaWdodDogMTAwLjAlOyI+TmFtZTogSkFNRVMgRElUQ0ggUHJlY2lwOiAwLjAwPC9kaXY+YClbMF07CiAgICAgICAgICAgIHBvcHVwXzU4ZGNkYTkwNzVkMjRlNmU4ODE0N2Q4YzdjNGRjN2FlLnNldENvbnRlbnQoaHRtbF80MzI2ZTU4OTFkMTA0MTljYmM4ODYxZTZjM2NhYjRlOCk7CiAgICAgICAgCgogICAgICAgIG1hcmtlcl9hZTc0MWMyZTllNzY0Yjc1ODgwNTE2NDkyZTdkMGZjYS5iaW5kUG9wdXAocG9wdXBfNThkY2RhOTA3NWQyNGU2ZTg4MTQ3ZDhjN2M0ZGM3YWUpCiAgICAgICAgOwoKICAgICAgICAKICAgIAogICAgCiAgICAgICAgICAgIHZhciBtYXJrZXJfYjUyOTQ3ZGUyYzRiNGFlYjlmNzk1ZmMyZGQxOTJkYTkgPSBMLm1hcmtlcigKICAgICAgICAgICAgICAgIFs0MC4wNTMwMzUsIC0xMDUuMTkzMDQ4XSwKICAgICAgICAgICAgICAgIHt9CiAgICAgICAgICAgICkuYWRkVG8obWFya2VyX2NsdXN0ZXJfNTk1NDRlZjBiNTFlNDRlN2JmNDk2NDBhY2E5ZTA3MjcpOwogICAgICAgIAogICAgCiAgICAgICAgdmFyIHBvcHVwXzBkZTBmMmFiMzFkMjQ5ZTJhOTRhZDZmMDY5NTE0ZWJhID0gTC5wb3B1cCh7Im1heFdpZHRoIjogIjEwMCUifSk7CgogICAgICAgIAogICAgICAgICAgICB2YXIgaHRtbF85YjFiZTA1ZmZjMjg0Mjc3OTFlNDE5NWMzMmU1MzJlMSA9ICQoYDxkaXYgaWQ9Imh0bWxfOWIxYmUwNWZmYzI4NDI3NzkxZTQxOTVjMzJlNTMyZTEiIHN0eWxlPSJ3aWR0aDogMTAwLjAlOyBoZWlnaHQ6IDEwMC4wJTsiPk5hbWU6IEJPVUxERVIgQ1JFRUsgU1VQUExZIENBTkFMIFRPIEJPVUxERVIgQ1JFRUsgTkVBUiBCT1VMREVSIFByZWNpcDogMy40MzwvZGl2PmApWzBdOwogICAgICAgICAgICBwb3B1cF8wZGUwZjJhYjMxZDI0OWUyYTk0YWQ2ZjA2OTUxNGViYS5zZXRDb250ZW50KGh0bWxfOWIxYmUwNWZmYzI4NDI3NzkxZTQxOTVjMzJlNTMyZTEpOwogICAgICAgIAoKICAgICAgICBtYXJrZXJfYjUyOTQ3ZGUyYzRiNGFlYjlmNzk1ZmMyZGQxOTJkYTkuYmluZFBvcHVwKHBvcHVwXzBkZTBmMmFiMzFkMjQ5ZTJhOTRhZDZmMDY5NTE0ZWJhKQogICAgICAgIDsKCiAgICAgICAgCiAgICAKICAgIAogICAgICAgICAgICB2YXIgbWFya2VyX2Q2NzU1MmM1NjVjNTQ4YjI4NDVmN2Q5NzFkYzBhMzQzID0gTC5tYXJrZXIoCiAgICAgICAgICAgICAgICBbNDAuMTc3NDIzLCAtMTA1LjE3ODE0NV0sCiAgICAgICAgICAgICAgICB7fQogICAgICAgICAgICApLmFkZFRvKG1hcmtlcl9jbHVzdGVyXzU5NTQ0ZWYwYjUxZTQ0ZTdiZjQ5NjQwYWNhOWUwNzI3KTsKICAgICAgICAKICAgIAogICAgICAgIHZhciBwb3B1cF9hMjA1YWE4YTkzYTc0MmRiOGUzNjA1M2NiZTI2ZWJhYSA9IEwucG9wdXAoeyJtYXhXaWR0aCI6ICIxMDAlIn0pOwoKICAgICAgICAKICAgICAgICAgICAgdmFyIGh0bWxfZmI0OGI5YzIwNWMzNDkxZmIxMmUzYmM4N2NkMWU2NzMgPSAkKGA8ZGl2IGlkPSJodG1sX2ZiNDhiOWMyMDVjMzQ5MWZiMTJlM2JjODdjZDFlNjczIiBzdHlsZT0id2lkdGg6IDEwMC4wJTsgaGVpZ2h0OiAxMDAuMCU7Ij5OYW1lOiBTQUlOVCBWUkFJTiBDUkVFSyBBVCBIWUdJRU5FLCBDTyBQcmVjaXA6IDIuMjU8L2Rpdj5gKVswXTsKICAgICAgICAgICAgcG9wdXBfYTIwNWFhOGE5M2E3NDJkYjhlMzYwNTNjYmUyNmViYWEuc2V0Q29udGVudChodG1sX2ZiNDhiOWMyMDVjMzQ5MWZiMTJlM2JjODdjZDFlNjczKTsKICAgICAgICAKCiAgICAgICAgbWFya2VyX2Q2NzU1MmM1NjVjNTQ4YjI4NDVmN2Q5NzFkYzBhMzQzLmJpbmRQb3B1cChwb3B1cF9hMjA1YWE4YTkzYTc0MmRiOGUzNjA1M2NiZTI2ZWJhYSkKICAgICAgICA7CgogICAgICAgIAogICAgCiAgICAKICAgICAgICAgICAgdmFyIG1hcmtlcl8wOTg4MWY0MmUwZTA0MmJkODM0NDA5NDkwNWI1NjUyNiA9IEwubWFya2VyKAogICAgICAgICAgICAgICAgWzQwLjI1ODM2NywgLTEwNS4xNzQ5NTddLAogICAgICAgICAgICAgICAge30KICAgICAgICAgICAgKS5hZGRUbyhtYXJrZXJfY2x1c3Rlcl81OTU0NGVmMGI1MWU0NGU3YmY0OTY0MGFjYTllMDcyNyk7CiAgICAgICAgCiAgICAKICAgICAgICB2YXIgcG9wdXBfOWIwZGU3ZDM0OGQxNDIyYmI3OTQyOTJmMmE5ZThhNmIgPSBMLnBvcHVwKHsibWF4V2lkdGgiOiAiMTAwJSJ9KTsKCiAgICAgICAgCiAgICAgICAgICAgIHZhciBodG1sXzJkY2IzMDAyOWNmZTRhODQ5NDFjYmFmOGRlODc5Yjc4ID0gJChgPGRpdiBpZD0iaHRtbF8yZGNiMzAwMjljZmU0YTg0OTQxY2JhZjhkZTg3OWI3OCIgc3R5bGU9IndpZHRoOiAxMDAuMCU7IGhlaWdodDogMTAwLjAlOyI+TmFtZTogQk9VTERFUi1MQVJJTUVSIERJVENIIE5FQVIgQkVSVEhPVUQgUHJlY2lwOiAxMS4zMDwvZGl2PmApWzBdOwogICAgICAgICAgICBwb3B1cF85YjBkZTdkMzQ4ZDE0MjJiYjc5NDI5MmYyYTllOGE2Yi5zZXRDb250ZW50KGh0bWxfMmRjYjMwMDI5Y2ZlNGE4NDk0MWNiYWY4ZGU4NzliNzgpOwogICAgICAgIAoKICAgICAgICBtYXJrZXJfMDk4ODFmNDJlMGUwNDJiZDgzNDQwOTQ5MDViNTY1MjYuYmluZFBvcHVwKHBvcHVwXzliMGRlN2QzNDhkMTQyMmJiNzk0MjkyZjJhOWU4YTZiKQogICAgICAgIDsKCiAgICAgICAgCiAgICAKICAgIAogICAgICAgICAgICB2YXIgbWFya2VyXzhiZDI1NzQ4YWQyZDQ4NmQ4MzIwOTNjNGNhNDU3MDAxID0gTC5tYXJrZXIoCiAgICAgICAgICAgICAgICBbNDAuMDk2MDMsIC0xMDUuMDkxMDU5XSwKICAgICAgICAgICAgICAgIHt9CiAgICAgICAgICAgICkuYWRkVG8obWFya2VyX2NsdXN0ZXJfNTk1NDRlZjBiNTFlNDRlN2JmNDk2NDBhY2E5ZTA3MjcpOwogICAgICAgIAogICAgCiAgICAgICAgdmFyIHBvcHVwX2ZkYzRlMjJjZDBlODRlOWQ5NDhiMjJhZjhjMjJkN2Y2ID0gTC5wb3B1cCh7Im1heFdpZHRoIjogIjEwMCUifSk7CgogICAgICAgIAogICAgICAgICAgICB2YXIgaHRtbF8xM2RjZGMxYjNiOTU0ZjFlYTQzMDc5NzhkM2IzNTdhMiA9ICQoYDxkaXYgaWQ9Imh0bWxfMTNkY2RjMWIzYjk1NGYxZWE0MzA3OTc4ZDNiMzU3YTIiIHN0eWxlPSJ3aWR0aDogMTAwLjAlOyBoZWlnaHQ6IDEwMC4wJTsiPk5hbWU6IFBBTkFNQSBSRVNFUlZPSVIgSU5MRVQgUHJlY2lwOiAyMi4xMDwvZGl2PmApWzBdOwogICAgICAgICAgICBwb3B1cF9mZGM0ZTIyY2QwZTg0ZTlkOTQ4YjIyYWY4YzIyZDdmNi5zZXRDb250ZW50KGh0bWxfMTNkY2RjMWIzYjk1NGYxZWE0MzA3OTc4ZDNiMzU3YTIpOwogICAgICAgIAoKICAgICAgICBtYXJrZXJfOGJkMjU3NDhhZDJkNDg2ZDgzMjA5M2M0Y2E0NTcwMDEuYmluZFBvcHVwKHBvcHVwX2ZkYzRlMjJjZDBlODRlOWQ5NDhiMjJhZjhjMjJkN2Y2KQogICAgICAgIDsKCiAgICAgICAgCiAgICAKICAgIAogICAgICAgICAgICB2YXIgbWFya2VyX2ZkZjFkMzgyNTQ0YzRhNjZiYjhlNTg1YjE0MThkNWJjID0gTC5tYXJrZXIoCiAgICAgICAgICAgICAgICBbNDAuMjEyNTA1LCAtMTA1LjI1MTgyNl0sCiAgICAgICAgICAgICAgICB7fQogICAgICAgICAgICApLmFkZFRvKG1hcmtlcl9jbHVzdGVyXzU5NTQ0ZWYwYjUxZTQ0ZTdiZjQ5NjQwYWNhOWUwNzI3KTsKICAgICAgICAKICAgIAogICAgICAgIHZhciBwb3B1cF9hNGE2YTk2MWU2ZjY0OTMwOWI0MjM5NjQ4MjExOWE0MyA9IEwucG9wdXAoeyJtYXhXaWR0aCI6ICIxMDAlIn0pOwoKICAgICAgICAKICAgICAgICAgICAgdmFyIGh0bWxfZWVkNjg0YmJlMThiNDljMWFhMDA5N2ZjZjdmYTQ4OTQgPSAkKGA8ZGl2IGlkPSJodG1sX2VlZDY4NGJiZTE4YjQ5YzFhYTAwOTdmY2Y3ZmE0ODk0IiBzdHlsZT0id2lkdGg6IDEwMC4wJTsgaGVpZ2h0OiAxMDAuMCU7Ij5OYW1lOiBQQUxNRVJUT04gRElUQ0ggUHJlY2lwOiAwLjI3PC9kaXY+YClbMF07CiAgICAgICAgICAgIHBvcHVwX2E0YTZhOTYxZTZmNjQ5MzA5YjQyMzk2NDgyMTE5YTQzLnNldENvbnRlbnQoaHRtbF9lZWQ2ODRiYmUxOGI0OWMxYWEwMDk3ZmNmN2ZhNDg5NCk7CiAgICAgICAgCgogICAgICAgIG1hcmtlcl9mZGYxZDM4MjU0NGM0YTY2YmI4ZTU4NWIxNDE4ZDViYy5iaW5kUG9wdXAocG9wdXBfYTRhNmE5NjFlNmY2NDkzMDliNDIzOTY0ODIxMTlhNDMpCiAgICAgICAgOwoKICAgICAgICAKICAgIAogICAgCiAgICAgICAgICAgIHZhciBtYXJrZXJfMGNjZmUxNmU1NGIzNGEwNDg5OTA0MDNmM2JlMzgyMzYgPSBMLm1hcmtlcigKICAgICAgICAgICAgICAgIFs0MC4yMTkwNDYsIC0xMDUuMjU5Nzk1XSwKICAgICAgICAgICAgICAgIHt9CiAgICAgICAgICAgICkuYWRkVG8obWFya2VyX2NsdXN0ZXJfNTk1NDRlZjBiNTFlNDRlN2JmNDk2NDBhY2E5ZTA3MjcpOwogICAgICAgIAogICAgCiAgICAgICAgdmFyIHBvcHVwXzU4NWRlOTMxMDdjNzQ2OWM5YWU4ZDQ5NzNkOWI4YWFkID0gTC5wb3B1cCh7Im1heFdpZHRoIjogIjEwMCUifSk7CgogICAgICAgIAogICAgICAgICAgICB2YXIgaHRtbF82M2EyZTM1MzA3MjI0YjZkODI2ZWNjNzBiYzJkMTNiNCA9ICQoYDxkaXYgaWQ9Imh0bWxfNjNhMmUzNTMwNzIyNGI2ZDgyNmVjYzcwYmMyZDEzYjQiIHN0eWxlPSJ3aWR0aDogMTAwLjAlOyBoZWlnaHQ6IDEwMC4wJTsiPk5hbWU6IFNVUFBMWSBESVRDSCBQcmVjaXA6IDAuMDA8L2Rpdj5gKVswXTsKICAgICAgICAgICAgcG9wdXBfNTg1ZGU5MzEwN2M3NDY5YzlhZThkNDk3M2Q5YjhhYWQuc2V0Q29udGVudChodG1sXzYzYTJlMzUzMDcyMjRiNmQ4MjZlY2M3MGJjMmQxM2I0KTsKICAgICAgICAKCiAgICAgICAgbWFya2VyXzBjY2ZlMTZlNTRiMzRhMDQ4OTkwNDAzZjNiZTM4MjM2LmJpbmRQb3B1cChwb3B1cF81ODVkZTkzMTA3Yzc0NjljOWFlOGQ0OTczZDliOGFhZCkKICAgICAgICA7CgogICAgICAgIAogICAgCiAgICAKICAgICAgICAgICAgdmFyIG1hcmtlcl82NjhkNGM2YjQ3Mjg0MDcxYjU2ZGRhNmJiYzk4OTVlZiA9IEwubWFya2VyKAogICAgICAgICAgICAgICAgWzM5LjkzMTgxMywgLTEwNS4zMDg0MzJdLAogICAgICAgICAgICAgICAge30KICAgICAgICAgICAgKS5hZGRUbyhtYXJrZXJfY2x1c3Rlcl81OTU0NGVmMGI1MWU0NGU3YmY0OTY0MGFjYTllMDcyNyk7CiAgICAgICAgCiAgICAKICAgICAgICB2YXIgcG9wdXBfYWYzYTk1YmE1NTk1NDFiZmJkOWI2ODc5OTA3YTVhMzYgPSBMLnBvcHVwKHsibWF4V2lkdGgiOiAiMTAwJSJ9KTsKCiAgICAgICAgCiAgICAgICAgICAgIHZhciBodG1sXzMzMjE3YzcwMGI1NjQ4ZDg4OTRkNTM5OGE1ZTBiMzk4ID0gJChgPGRpdiBpZD0iaHRtbF8zMzIxN2M3MDBiNTY0OGQ4ODk0ZDUzOThhNWUwYjM5OCIgc3R5bGU9IndpZHRoOiAxMDAuMCU7IGhlaWdodDogMTAwLjAlOyI+TmFtZTogU09VVEggQk9VTERFUiBDUkVFSyBESVZFUlNJT04gTkVBUiBFTERPUkFETyBTUFJJTkdTIFByZWNpcDogMC4wMDwvZGl2PmApWzBdOwogICAgICAgICAgICBwb3B1cF9hZjNhOTViYTU1OTU0MWJmYmQ5YjY4Nzk5MDdhNWEzNi5zZXRDb250ZW50KGh0bWxfMzMyMTdjNzAwYjU2NDhkODg5NGQ1Mzk4YTVlMGIzOTgpOwogICAgICAgIAoKICAgICAgICBtYXJrZXJfNjY4ZDRjNmI0NzI4NDA3MWI1NmRkYTZiYmM5ODk1ZWYuYmluZFBvcHVwKHBvcHVwX2FmM2E5NWJhNTU5NTQxYmZiZDliNjg3OTkwN2E1YTM2KQogICAgICAgIDsKCiAgICAgICAgCiAgICAKICAgIAogICAgICAgICAgICB2YXIgbWFya2VyXzgwZGNmNjMzNjBiMTRmNmRhMWVjY2I4NjBkNWYzMzAyID0gTC5tYXJrZXIoCiAgICAgICAgICAgICAgICBbNDAuMTg3NTc4LCAtMTA1LjE4OTE5MV0sCiAgICAgICAgICAgICAgICB7fQogICAgICAgICAgICApLmFkZFRvKG1hcmtlcl9jbHVzdGVyXzU5NTQ0ZWYwYjUxZTQ0ZTdiZjQ5NjQwYWNhOWUwNzI3KTsKICAgICAgICAKICAgIAogICAgICAgIHZhciBwb3B1cF82MTkzNjEyZjliNjE0ZTA4YmU4Njg5NmEzMDMzMmRlZSA9IEwucG9wdXAoeyJtYXhXaWR0aCI6ICIxMDAlIn0pOwoKICAgICAgICAKICAgICAgICAgICAgdmFyIGh0bWxfNDliOWRmMGFhOGRhNDZmNWFhYTA5YjQzYTk5NzUyOTAgPSAkKGA8ZGl2IGlkPSJodG1sXzQ5YjlkZjBhYThkYTQ2ZjVhYWEwOWI0M2E5OTc1MjkwIiBzdHlsZT0id2lkdGg6IDEwMC4wJTsgaGVpZ2h0OiAxMDAuMCU7Ij5OYW1lOiBERU5JTyBUQVlMT1IgRElUQ0ggUHJlY2lwOiAyODE5LjY4PC9kaXY+YClbMF07CiAgICAgICAgICAgIHBvcHVwXzYxOTM2MTJmOWI2MTRlMDhiZTg2ODk2YTMwMzMyZGVlLnNldENvbnRlbnQoaHRtbF80OWI5ZGYwYWE4ZGE0NmY1YWFhMDliNDNhOTk3NTI5MCk7CiAgICAgICAgCgogICAgICAgIG1hcmtlcl84MGRjZjYzMzYwYjE0ZjZkYTFlY2NiODYwZDVmMzMwMi5iaW5kUG9wdXAocG9wdXBfNjE5MzYxMmY5YjYxNGUwOGJlODY4OTZhMzAzMzJkZWUpCiAgICAgICAgOwoKICAgICAgICAKICAgIAogICAgCiAgICAgICAgICAgIHZhciBtYXJrZXJfYzQwOGIwYzAzZTcyNDcwNWJmYzFlMjJjZmU3M2NlZTAgPSBMLm1hcmtlcigKICAgICAgICAgICAgICAgIFs0MC4wNDIwMjgsIC0xMDUuMzY0OTE3XSwKICAgICAgICAgICAgICAgIHt9CiAgICAgICAgICAgICkuYWRkVG8obWFya2VyX2NsdXN0ZXJfNTk1NDRlZjBiNTFlNDRlN2JmNDk2NDBhY2E5ZTA3MjcpOwogICAgICAgIAogICAgCiAgICAgICAgdmFyIHBvcHVwXzhhOWQwNGRhODc3YTRmNGE5OTY0ZmRkYTc4ZjFlM2M3ID0gTC5wb3B1cCh7Im1heFdpZHRoIjogIjEwMCUifSk7CgogICAgICAgIAogICAgICAgICAgICB2YXIgaHRtbF9lMTk1N2NiMzQ0ODA0MjRhYjQ2NGI1ZGUxOGU2YWQ4ZCA9ICQoYDxkaXYgaWQ9Imh0bWxfZTE5NTdjYjM0NDgwNDI0YWI0NjRiNWRlMThlNmFkOGQiIHN0eWxlPSJ3aWR0aDogMTAwLjAlOyBoZWlnaHQ6IDEwMC4wJTsiPk5hbWU6IEZPVVJNSUxFIENSRUVLIEFUIExPR0FOIE1JTEwgUk9BRCBORUFSIENSSVNNQU4sIENPIFByZWNpcDogbmFuPC9kaXY+YClbMF07CiAgICAgICAgICAgIHBvcHVwXzhhOWQwNGRhODc3YTRmNGE5OTY0ZmRkYTc4ZjFlM2M3LnNldENvbnRlbnQoaHRtbF9lMTk1N2NiMzQ0ODA0MjRhYjQ2NGI1ZGUxOGU2YWQ4ZCk7CiAgICAgICAgCgogICAgICAgIG1hcmtlcl9jNDA4YjBjMDNlNzI0NzA1YmZjMWUyMmNmZTczY2VlMC5iaW5kUG9wdXAocG9wdXBfOGE5ZDA0ZGE4NzdhNGY0YTk5NjRmZGRhNzhmMWUzYzcpCiAgICAgICAgOwoKICAgICAgICAKICAgIAogICAgCiAgICAgICAgICAgIHZhciBtYXJrZXJfNDExODIyNmRjMGIwNGJhMWJkYThhZDU1ZmFjMTQ2NTQgPSBMLm1hcmtlcigKICAgICAgICAgICAgICAgIFs0MC4xNzcwOCwgLTEwNS4xNzg1NjddLAogICAgICAgICAgICAgICAge30KICAgICAgICAgICAgKS5hZGRUbyhtYXJrZXJfY2x1c3Rlcl81OTU0NGVmMGI1MWU0NGU3YmY0OTY0MGFjYTllMDcyNyk7CiAgICAgICAgCiAgICAKICAgICAgICB2YXIgcG9wdXBfYzE3ZjUxNzZmMTYzNDdkNTg2NGUwNmM5NDEwYzI2MTQgPSBMLnBvcHVwKHsibWF4V2lkdGgiOiAiMTAwJSJ9KTsKCiAgICAgICAgCiAgICAgICAgICAgIHZhciBodG1sXzJlNmU2YzFlNGUwNDQwMzJiNjNjNzIwNTljY2E5NDEwID0gJChgPGRpdiBpZD0iaHRtbF8yZTZlNmMxZTRlMDQ0MDMyYjYzYzcyMDU5Y2NhOTQxMCIgc3R5bGU9IndpZHRoOiAxMDAuMCU7IGhlaWdodDogMTAwLjAlOyI+TmFtZTogUEVDSyBQRUxMQSBDTE9WRVIgRElUQ0ggUHJlY2lwOiAxLjI5PC9kaXY+YClbMF07CiAgICAgICAgICAgIHBvcHVwX2MxN2Y1MTc2ZjE2MzQ3ZDU4NjRlMDZjOTQxMGMyNjE0LnNldENvbnRlbnQoaHRtbF8yZTZlNmMxZTRlMDQ0MDMyYjYzYzcyMDU5Y2NhOTQxMCk7CiAgICAgICAgCgogICAgICAgIG1hcmtlcl80MTE4MjI2ZGMwYjA0YmExYmRhOGFkNTVmYWMxNDY1NC5iaW5kUG9wdXAocG9wdXBfYzE3ZjUxNzZmMTYzNDdkNTg2NGUwNmM5NDEwYzI2MTQpCiAgICAgICAgOwoKICAgICAgICAKICAgIAogICAgCiAgICAgICAgICAgIHZhciBtYXJrZXJfM2ZlMWM5MzkwM2UwNGMyZDkxOTAzZjU2NTkzM2VjZmYgPSBMLm1hcmtlcigKICAgICAgICAgICAgICAgIFszOS45NDc3MDQsIC0xMDUuMzU3MzA4XSwKICAgICAgICAgICAgICAgIHt9CiAgICAgICAgICAgICkuYWRkVG8obWFya2VyX2NsdXN0ZXJfNTk1NDRlZjBiNTFlNDRlN2JmNDk2NDBhY2E5ZTA3MjcpOwogICAgICAgIAogICAgCiAgICAgICAgdmFyIHBvcHVwX2ViOGVkZTNmODhhMzQ0ZTI4ZjU2Mjc5MjVlYzgzNzhlID0gTC5wb3B1cCh7Im1heFdpZHRoIjogIjEwMCUifSk7CgogICAgICAgIAogICAgICAgICAgICB2YXIgaHRtbF8zYjE4YzE4OTMxZmI0NDQxOGZlNTU2MTBiMTNhOTVmZSA9ICQoYDxkaXYgaWQ9Imh0bWxfM2IxOGMxODkzMWZiNDQ0MThmZTU1NjEwYjEzYTk1ZmUiIHN0eWxlPSJ3aWR0aDogMTAwLjAlOyBoZWlnaHQ6IDEwMC4wJTsiPk5hbWU6IEdST1NTIFJFU0VSVk9JUiAgUHJlY2lwOiAxMTQwMS4wMDwvZGl2PmApWzBdOwogICAgICAgICAgICBwb3B1cF9lYjhlZGUzZjg4YTM0NGUyOGY1NjI3OTI1ZWM4Mzc4ZS5zZXRDb250ZW50KGh0bWxfM2IxOGMxODkzMWZiNDQ0MThmZTU1NjEwYjEzYTk1ZmUpOwogICAgICAgIAoKICAgICAgICBtYXJrZXJfM2ZlMWM5MzkwM2UwNGMyZDkxOTAzZjU2NTkzM2VjZmYuYmluZFBvcHVwKHBvcHVwX2ViOGVkZTNmODhhMzQ0ZTI4ZjU2Mjc5MjVlYzgzNzhlKQogICAgICAgIDsKCiAgICAgICAgCiAgICAKPC9zY3JpcHQ+" style="position:absolute;width:100%;height:100%;left:0;top:0;border:none !important;" allowfullscreen webkitallowfullscreen mozallowfullscreen></iframe></div></div>





<div class="notice--info" markdown="1">

## Additional Resources

* <a href="https://blog.datafiniti.co/4-reasons-you-should-use-json-instead-of-csv-2cac362f1943" target="_blank">Why you should use JSON instead of csv.</a>


* <a href="https://www.w3schools.com/js/js_json_intro.asp" target="_blank">W3schools JSON intro </a>

</div>

