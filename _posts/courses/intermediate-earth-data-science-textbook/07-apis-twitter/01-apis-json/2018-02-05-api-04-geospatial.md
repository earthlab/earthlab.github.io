---
layout: single
title: 'Programmatically Accessing Geospatial Data Using APIs'
excerpt: 'This lesson walks through the process of retrieving and manipulating surface water data housed in the Colorado Information Warehouse. These data are stored in JSON format with spatial x, y information that support mapping.'
authors: ['Leah Wasser', 'Max Joseph', 'Martha Morrissey', 'Jenny Palomino', 'Carson Farmer']
modified: 2020-03-31
category: [courses]
class-lesson: ['intro-APIs-python']
permalink: /courses/use-data-open-source-python/intro-to-apis/apis-in-python/co-water-data-spatial-python/
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
      'date_time': '2020-03-31T15:00:00.000',
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
      'amount': '33.00',
      'station_type': 'Stream',
      'wd': '5',
      'http_linkage': {'url': 'https://dwr.state.co.us/SurfaceWater/data/detail_graph.aspx?ID=SVCLYOCO&MTYPE=DISCHRG'},
      'date_time': '2020-03-31T15:15:00.000',
      'county': 'BOULDER',
      'variable': 'DISCHRG',
      'stage': '2.94',
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
      <td>2020-03-31T15:00:00.000</td>
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
      <td>33.00</td>
      <td>Stream</td>
      <td>5</td>
      <td>2020-03-31T15:15:00.000</td>
      <td>BOULDER</td>
      <td>DISCHRG</td>
      <td>2.94</td>
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
      <td>2020-03-31T13:45:00.000</td>
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
      <td>CLOUGH AND TRUE DITCH</td>
      <td>1</td>
      <td>CLODITCO</td>
      <td>Cooperative Program of CDWR, NCWCD &amp; SVLHWCD</td>
      <td>0.00</td>
      <td>Diversion</td>
      <td>5</td>
      <td>2020-03-31T15:00:00.000</td>
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
    <tr>
      <th>4</th>
      <td>BOULDER CREEK NEAR ORODELL, CO.</td>
      <td>1</td>
      <td>BOCOROCO</td>
      <td>Co. Division of Water Resources</td>
      <td>20.40</td>
      <td>Stream</td>
      <td>6</td>
      <td>2020-03-31T15:15:00.000</td>
      <td>BOULDER</td>
      <td>DISCHRG</td>
      <td>1.84</td>
      <td>Active</td>
      <td>40.00638</td>
      <td>False</td>
      <td>-105.330841</td>
      <td>https://dwr.state.co.us/SurfaceWater/data/deta...</td>
      <td>06727000</td>
      <td>Ice</td>
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



    (56, 18)





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
      <td>2020-03-31T15:00:00.000</td>
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
      <td>33.00</td>
      <td>Stream</td>
      <td>5</td>
      <td>2020-03-31T15:15:00.000</td>
      <td>BOULDER</td>
      <td>DISCHRG</td>
      <td>2.94</td>
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
      <td>2020-03-31T13:45:00.000</td>
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
      <td>CLOUGH AND TRUE DITCH</td>
      <td>1</td>
      <td>CLODITCO</td>
      <td>Cooperative Program of CDWR, NCWCD &amp; SVLHWCD</td>
      <td>0.00</td>
      <td>Diversion</td>
      <td>5</td>
      <td>2020-03-31T15:00:00.000</td>
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
    <tr>
      <th>4</th>
      <td>BOULDER CREEK NEAR ORODELL, CO.</td>
      <td>1</td>
      <td>BOCOROCO</td>
      <td>Co. Division of Water Resources</td>
      <td>20.40</td>
      <td>Stream</td>
      <td>6</td>
      <td>2020-03-31T15:15:00.000</td>
      <td>BOULDER</td>
      <td>DISCHRG</td>
      <td>1.84</td>
      <td>Active</td>
      <td>40.006380</td>
      <td>False</td>
      <td>-105.330841</td>
      <td>https://dwr.state.co.us/SurfaceWater/data/deta...</td>
      <td>06727000</td>
      <td>Ice</td>
      <td>POINT (-105.33084 40.00638)</td>
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



<div style="width:100%;"><div style="position:relative;width:100%;height:0;padding-bottom:60%;"><iframe src="data:text/html;charset=utf-8;base64,PCFET0NUWVBFIGh0bWw+CjxoZWFkPiAgICAKICAgIDxtZXRhIGh0dHAtZXF1aXY9ImNvbnRlbnQtdHlwZSIgY29udGVudD0idGV4dC9odG1sOyBjaGFyc2V0PVVURi04IiAvPgogICAgCiAgICAgICAgPHNjcmlwdD4KICAgICAgICAgICAgTF9OT19UT1VDSCA9IGZhbHNlOwogICAgICAgICAgICBMX0RJU0FCTEVfM0QgPSBmYWxzZTsKICAgICAgICA8L3NjcmlwdD4KICAgIAogICAgPHNjcmlwdCBzcmM9Imh0dHBzOi8vY2RuLmpzZGVsaXZyLm5ldC9ucG0vbGVhZmxldEAxLjUuMS9kaXN0L2xlYWZsZXQuanMiPjwvc2NyaXB0PgogICAgPHNjcmlwdCBzcmM9Imh0dHBzOi8vY29kZS5qcXVlcnkuY29tL2pxdWVyeS0xLjEyLjQubWluLmpzIj48L3NjcmlwdD4KICAgIDxzY3JpcHQgc3JjPSJodHRwczovL21heGNkbi5ib290c3RyYXBjZG4uY29tL2Jvb3RzdHJhcC8zLjIuMC9qcy9ib290c3RyYXAubWluLmpzIj48L3NjcmlwdD4KICAgIDxzY3JpcHQgc3JjPSJodHRwczovL2NkbmpzLmNsb3VkZmxhcmUuY29tL2FqYXgvbGlicy9MZWFmbGV0LmF3ZXNvbWUtbWFya2Vycy8yLjAuMi9sZWFmbGV0LmF3ZXNvbWUtbWFya2Vycy5qcyI+PC9zY3JpcHQ+CiAgICA8bGluayByZWw9InN0eWxlc2hlZXQiIGhyZWY9Imh0dHBzOi8vY2RuLmpzZGVsaXZyLm5ldC9ucG0vbGVhZmxldEAxLjUuMS9kaXN0L2xlYWZsZXQuY3NzIi8+CiAgICA8bGluayByZWw9InN0eWxlc2hlZXQiIGhyZWY9Imh0dHBzOi8vbWF4Y2RuLmJvb3RzdHJhcGNkbi5jb20vYm9vdHN0cmFwLzMuMi4wL2Nzcy9ib290c3RyYXAubWluLmNzcyIvPgogICAgPGxpbmsgcmVsPSJzdHlsZXNoZWV0IiBocmVmPSJodHRwczovL21heGNkbi5ib290c3RyYXBjZG4uY29tL2Jvb3RzdHJhcC8zLjIuMC9jc3MvYm9vdHN0cmFwLXRoZW1lLm1pbi5jc3MiLz4KICAgIDxsaW5rIHJlbD0ic3R5bGVzaGVldCIgaHJlZj0iaHR0cHM6Ly9tYXhjZG4uYm9vdHN0cmFwY2RuLmNvbS9mb250LWF3ZXNvbWUvNC42LjMvY3NzL2ZvbnQtYXdlc29tZS5taW4uY3NzIi8+CiAgICA8bGluayByZWw9InN0eWxlc2hlZXQiIGhyZWY9Imh0dHBzOi8vY2RuanMuY2xvdWRmbGFyZS5jb20vYWpheC9saWJzL0xlYWZsZXQuYXdlc29tZS1tYXJrZXJzLzIuMC4yL2xlYWZsZXQuYXdlc29tZS1tYXJrZXJzLmNzcyIvPgogICAgPGxpbmsgcmVsPSJzdHlsZXNoZWV0IiBocmVmPSJodHRwczovL3Jhd2Nkbi5naXRoYWNrLmNvbS9weXRob24tdmlzdWFsaXphdGlvbi9mb2xpdW0vbWFzdGVyL2ZvbGl1bS90ZW1wbGF0ZXMvbGVhZmxldC5hd2Vzb21lLnJvdGF0ZS5jc3MiLz4KICAgIDxzdHlsZT5odG1sLCBib2R5IHt3aWR0aDogMTAwJTtoZWlnaHQ6IDEwMCU7bWFyZ2luOiAwO3BhZGRpbmc6IDA7fTwvc3R5bGU+CiAgICA8c3R5bGU+I21hcCB7cG9zaXRpb246YWJzb2x1dGU7dG9wOjA7Ym90dG9tOjA7cmlnaHQ6MDtsZWZ0OjA7fTwvc3R5bGU+CiAgICAKICAgICAgICAgICAgPG1ldGEgbmFtZT0idmlld3BvcnQiIGNvbnRlbnQ9IndpZHRoPWRldmljZS13aWR0aCwKICAgICAgICAgICAgICAgIGluaXRpYWwtc2NhbGU9MS4wLCBtYXhpbXVtLXNjYWxlPTEuMCwgdXNlci1zY2FsYWJsZT1ubyIgLz4KICAgICAgICAgICAgPHN0eWxlPgogICAgICAgICAgICAgICAgI21hcF80NmNjZjhlNmRlNzQ0ZTU5YWQ5NmEyZmZhNjgyYjAxNiB7CiAgICAgICAgICAgICAgICAgICAgcG9zaXRpb246IHJlbGF0aXZlOwogICAgICAgICAgICAgICAgICAgIHdpZHRoOiAxMDAuMCU7CiAgICAgICAgICAgICAgICAgICAgaGVpZ2h0OiAxMDAuMCU7CiAgICAgICAgICAgICAgICAgICAgbGVmdDogMC4wJTsKICAgICAgICAgICAgICAgICAgICB0b3A6IDAuMCU7CiAgICAgICAgICAgICAgICB9CiAgICAgICAgICAgIDwvc3R5bGU+CiAgICAgICAgCjwvaGVhZD4KPGJvZHk+ICAgIAogICAgCiAgICAgICAgICAgIDxkaXYgY2xhc3M9ImZvbGl1bS1tYXAiIGlkPSJtYXBfNDZjY2Y4ZTZkZTc0NGU1OWFkOTZhMmZmYTY4MmIwMTYiID48L2Rpdj4KICAgICAgICAKPC9ib2R5Pgo8c2NyaXB0PiAgICAKICAgIAogICAgICAgICAgICB2YXIgbWFwXzQ2Y2NmOGU2ZGU3NDRlNTlhZDk2YTJmZmE2ODJiMDE2ID0gTC5tYXAoCiAgICAgICAgICAgICAgICAibWFwXzQ2Y2NmOGU2ZGU3NDRlNTlhZDk2YTJmZmE2ODJiMDE2IiwKICAgICAgICAgICAgICAgIHsKICAgICAgICAgICAgICAgICAgICBjZW50ZXI6IFs0MC4wMSwgLTEwNS4yN10sCiAgICAgICAgICAgICAgICAgICAgY3JzOiBMLkNSUy5FUFNHMzg1NywKICAgICAgICAgICAgICAgICAgICB6b29tOiAxMCwKICAgICAgICAgICAgICAgICAgICB6b29tQ29udHJvbDogdHJ1ZSwKICAgICAgICAgICAgICAgICAgICBwcmVmZXJDYW52YXM6IGZhbHNlLAogICAgICAgICAgICAgICAgfQogICAgICAgICAgICApOwoKICAgICAgICAgICAgCgogICAgICAgIAogICAgCiAgICAgICAgICAgIHZhciB0aWxlX2xheWVyXzQ4ZjdhMGVhY2JjYzQyMzc5NzAyN2M4OTc1MDNiZTI3ID0gTC50aWxlTGF5ZXIoCiAgICAgICAgICAgICAgICAiaHR0cHM6Ly9jYXJ0b2RiLWJhc2VtYXBzLXtzfS5nbG9iYWwuc3NsLmZhc3RseS5uZXQvbGlnaHRfYWxsL3t6fS97eH0ve3l9LnBuZyIsCiAgICAgICAgICAgICAgICB7ImF0dHJpYnV0aW9uIjogIlx1MDAyNmNvcHk7IFx1MDAzY2EgaHJlZj1cImh0dHA6Ly93d3cub3BlbnN0cmVldG1hcC5vcmcvY29weXJpZ2h0XCJcdTAwM2VPcGVuU3RyZWV0TWFwXHUwMDNjL2FcdTAwM2UgY29udHJpYnV0b3JzIFx1MDAyNmNvcHk7IFx1MDAzY2EgaHJlZj1cImh0dHA6Ly9jYXJ0b2RiLmNvbS9hdHRyaWJ1dGlvbnNcIlx1MDAzZUNhcnRvREJcdTAwM2MvYVx1MDAzZSwgQ2FydG9EQiBcdTAwM2NhIGhyZWYgPVwiaHR0cDovL2NhcnRvZGIuY29tL2F0dHJpYnV0aW9uc1wiXHUwMDNlYXR0cmlidXRpb25zXHUwMDNjL2FcdTAwM2UiLCAiZGV0ZWN0UmV0aW5hIjogZmFsc2UsICJtYXhOYXRpdmVab29tIjogMTgsICJtYXhab29tIjogMTgsICJtaW5ab29tIjogMCwgIm5vV3JhcCI6IGZhbHNlLCAib3BhY2l0eSI6IDEsICJzdWJkb21haW5zIjogImFiYyIsICJ0bXMiOiBmYWxzZX0KICAgICAgICAgICAgKS5hZGRUbyhtYXBfNDZjY2Y4ZTZkZTc0NGU1OWFkOTZhMmZmYTY4MmIwMTYpOwogICAgICAgIAogICAgCiAgICAgICAgZnVuY3Rpb24gZ2VvX2pzb25fOTk2YWE4ODQ2Yjg5NDI0MmFmN2VkMDcwODk3MmU5ZGJfb25FYWNoRmVhdHVyZShmZWF0dXJlLCBsYXllcikgewogICAgICAgICAgICBsYXllci5vbih7CiAgICAgICAgICAgICAgICBjbGljazogZnVuY3Rpb24oZSkgewogICAgICAgICAgICAgICAgICAgIG1hcF80NmNjZjhlNmRlNzQ0ZTU5YWQ5NmEyZmZhNjgyYjAxNi5maXRCb3VuZHMoZS50YXJnZXQuZ2V0Qm91bmRzKCkpOwogICAgICAgICAgICAgICAgfQogICAgICAgICAgICB9KTsKICAgICAgICB9OwogICAgICAgIHZhciBnZW9fanNvbl85OTZhYTg4NDZiODk0MjQyYWY3ZWQwNzA4OTcyZTlkYiA9IEwuZ2VvSnNvbihudWxsLCB7CiAgICAgICAgICAgICAgICBvbkVhY2hGZWF0dXJlOiBnZW9fanNvbl85OTZhYTg4NDZiODk0MjQyYWY3ZWQwNzA4OTcyZTlkYl9vbkVhY2hGZWF0dXJlLAogICAgICAgICAgICAKICAgICAgICB9KTsKICAgICAgICBmdW5jdGlvbiBnZW9fanNvbl85OTZhYTg4NDZiODk0MjQyYWY3ZWQwNzA4OTcyZTlkYl9hZGQgKGRhdGEpIHsKICAgICAgICAgICAgZ2VvX2pzb25fOTk2YWE4ODQ2Yjg5NDI0MmFmN2VkMDcwODk3MmU5ZGIuYWRkRGF0YShkYXRhKQogICAgICAgICAgICAgICAgLmFkZFRvKG1hcF80NmNjZjhlNmRlNzQ0ZTU5YWQ5NmEyZmZhNjgyYjAxNik7CiAgICAgICAgfQogICAgICAgICAgICBnZW9fanNvbl85OTZhYTg4NDZiODk0MjQyYWY3ZWQwNzA4OTcyZTlkYl9hZGQoeyJiYm94IjogWy0xMDUuNTA0NDQsIDM5LjkzMTU5NywgLTEwNS4wNzI1MDIsIDQwLjI2MDgyN10sICJmZWF0dXJlcyI6IFt7ImJib3giOiBbLTEwNS4xODU3ODksIDQwLjE4NTAzMywgLTEwNS4xODU3ODksIDQwLjE4NTAzM10sICJnZW9tZXRyeSI6IHsiY29vcmRpbmF0ZXMiOiBbLTEwNS4xODU3ODksIDQwLjE4NTAzM10sICJ0eXBlIjogIlBvaW50In0sICJpZCI6ICIwIiwgInByb3BlcnRpZXMiOiB7ImFtb3VudCI6ICIwLjE0IiwgImNvdW50eSI6ICJCT1VMREVSIiwgImRhdGFfc291cmNlIjogIkNvb3BlcmF0aXZlIFByb2dyYW0gb2YgQ0RXUiwgTkNXQ0QgXHUwMDI2IFNWTEhXQ0QiLCAiZGF0ZV90aW1lIjogIjIwMjAtMDMtMzFUMTU6MDA6MDAuMDAwIiwgImRpdiI6ICIxIiwgImR3cl9hYmJyZXYiOiAiWldFVFVSQ08iLCAiZmxhZyI6IG51bGwsICJodHRwX2xpbmthZ2UudXJsIjogImh0dHBzOi8vZHdyLnN0YXRlLmNvLnVzL1N1cmZhY2VXYXRlci9kYXRhL2RldGFpbF9ncmFwaC5hc3B4P0lEPVpXRVRVUkNPXHUwMDI2TVRZUEU9RElTQ0hSRyIsICJsb2NhdGlvbi5sYXRpdHVkZSI6IDQwLjE4NTAzMywgImxvY2F0aW9uLmxvbmdpdHVkZSI6IC0xMDUuMTg1Nzg5LCAibG9jYXRpb24ubmVlZHNfcmVjb2RpbmciOiBmYWxzZSwgInN0YWdlIjogIjAuMDUiLCAic3RhdGlvbl9uYW1lIjogIlpXRUNLIEFORCBUVVJORVIgRElUQ0giLCAic3RhdGlvbl9zdGF0dXMiOiAiQWN0aXZlIiwgInN0YXRpb25fdHlwZSI6ICJEaXZlcnNpb24iLCAidXNnc19zdGF0aW9uX2lkIjogbnVsbCwgInZhcmlhYmxlIjogIkRJU0NIUkciLCAid2QiOiAiNSJ9LCAidHlwZSI6ICJGZWF0dXJlIn0sIHsiYmJveCI6IFstMTA1LjI2MzQ5LCA0MC4yMjA3MDIsIC0xMDUuMjYzNDksIDQwLjIyMDcwMl0sICJnZW9tZXRyeSI6IHsiY29vcmRpbmF0ZXMiOiBbLTEwNS4yNjM0OSwgNDAuMjIwNzAyXSwgInR5cGUiOiAiUG9pbnQifSwgImlkIjogIjEiLCAicHJvcGVydGllcyI6IHsiYW1vdW50IjogIjMzLjAwIiwgImNvdW50eSI6ICJCT1VMREVSIiwgImRhdGFfc291cmNlIjogIkNvLiBEaXZpc2lvbiBvZiBXYXRlciBSZXNvdXJjZXMiLCAiZGF0ZV90aW1lIjogIjIwMjAtMDMtMzFUMTU6MTU6MDAuMDAwIiwgImRpdiI6ICIxIiwgImR3cl9hYmJyZXYiOiAiU1ZDTFlPQ08iLCAiZmxhZyI6IG51bGwsICJodHRwX2xpbmthZ2UudXJsIjogImh0dHBzOi8vZHdyLnN0YXRlLmNvLnVzL1N1cmZhY2VXYXRlci9kYXRhL2RldGFpbF9ncmFwaC5hc3B4P0lEPVNWQ0xZT0NPXHUwMDI2TVRZUEU9RElTQ0hSRyIsICJsb2NhdGlvbi5sYXRpdHVkZSI6IDQwLjIyMDcwMiwgImxvY2F0aW9uLmxvbmdpdHVkZSI6IC0xMDUuMjYzNDksICJsb2NhdGlvbi5uZWVkc19yZWNvZGluZyI6IGZhbHNlLCAic3RhZ2UiOiAiMi45NCIsICJzdGF0aW9uX25hbWUiOiAiU0FJTlQgVlJBSU4gQ1JFRUsgQVQgTFlPTlMsIENPIiwgInN0YXRpb25fc3RhdHVzIjogIkFjdGl2ZSIsICJzdGF0aW9uX3R5cGUiOiAiU3RyZWFtIiwgInVzZ3Nfc3RhdGlvbl9pZCI6ICIwNjcyNDAwMCIsICJ2YXJpYWJsZSI6ICJESVNDSFJHIiwgIndkIjogIjUifSwgInR5cGUiOiAiRmVhdHVyZSJ9LCB7ImJib3giOiBbLTEwNS4yMDY1OTIsIDQwLjE5NjQyMiwgLTEwNS4yMDY1OTIsIDQwLjE5NjQyMl0sICJnZW9tZXRyeSI6IHsiY29vcmRpbmF0ZXMiOiBbLTEwNS4yMDY1OTIsIDQwLjE5NjQyMl0sICJ0eXBlIjogIlBvaW50In0sICJpZCI6ICIyIiwgInByb3BlcnRpZXMiOiB7ImFtb3VudCI6ICIyLjc2IiwgImNvdW50eSI6ICJCT1VMREVSIiwgImRhdGFfc291cmNlIjogIkNvb3BlcmF0aXZlIFByb2dyYW0gb2YgQ0RXUiwgTkNXQ0QgXHUwMDI2IFNWTEhXQ0QiLCAiZGF0ZV90aW1lIjogIjIwMjAtMDMtMzFUMTM6NDU6MDAuMDAwIiwgImRpdiI6ICIxIiwgImR3cl9hYmJyZXYiOiAiT0xJRElUQ08iLCAiZmxhZyI6IG51bGwsICJodHRwX2xpbmthZ2UudXJsIjogImh0dHBzOi8vZHdyLnN0YXRlLmNvLnVzL1N1cmZhY2VXYXRlci9kYXRhL2RldGFpbF9ncmFwaC5hc3B4P0lEPU9MSURJVENPXHUwMDI2TVRZUEU9RElTQ0hSRyIsICJsb2NhdGlvbi5sYXRpdHVkZSI6IDQwLjE5NjQyMiwgImxvY2F0aW9uLmxvbmdpdHVkZSI6IC0xMDUuMjA2NTkyLCAibG9jYXRpb24ubmVlZHNfcmVjb2RpbmciOiBmYWxzZSwgInN0YWdlIjogIjAuMTkiLCAic3RhdGlvbl9uYW1lIjogIk9MSUdBUkNIWSBESVRDSCBESVZFUlNJT04iLCAic3RhdGlvbl9zdGF0dXMiOiAiQWN0aXZlIiwgInN0YXRpb25fdHlwZSI6ICJEaXZlcnNpb24iLCAidXNnc19zdGF0aW9uX2lkIjogbnVsbCwgInZhcmlhYmxlIjogIkRJU0NIUkciLCAid2QiOiAiNSJ9LCAidHlwZSI6ICJGZWF0dXJlIn0sIHsiYmJveCI6IFstMTA1LjIxMDM5LCA0MC4xOTM3NTgsIC0xMDUuMjEwMzksIDQwLjE5Mzc1OF0sICJnZW9tZXRyeSI6IHsiY29vcmRpbmF0ZXMiOiBbLTEwNS4yMTAzOSwgNDAuMTkzNzU4XSwgInR5cGUiOiAiUG9pbnQifSwgImlkIjogIjMiLCAicHJvcGVydGllcyI6IHsiYW1vdW50IjogIjAuMDAiLCAiY291bnR5IjogIkJPVUxERVIiLCAiZGF0YV9zb3VyY2UiOiAiQ29vcGVyYXRpdmUgUHJvZ3JhbSBvZiBDRFdSLCBOQ1dDRCBcdTAwMjYgU1ZMSFdDRCIsICJkYXRlX3RpbWUiOiAiMjAyMC0wMy0zMVQxNTowMDowMC4wMDAiLCAiZGl2IjogIjEiLCAiZHdyX2FiYnJldiI6ICJDTE9ESVRDTyIsICJmbGFnIjogbnVsbCwgImh0dHBfbGlua2FnZS51cmwiOiAiaHR0cHM6Ly9kd3Iuc3RhdGUuY28udXMvU3VyZmFjZVdhdGVyL2RhdGEvZGV0YWlsX2dyYXBoLmFzcHg/SUQ9Q0xPRElUQ09cdTAwMjZNVFlQRT1ESVNDSFJHIiwgImxvY2F0aW9uLmxhdGl0dWRlIjogNDAuMTkzNzU4LCAibG9jYXRpb24ubG9uZ2l0dWRlIjogLTEwNS4yMTAzOSwgImxvY2F0aW9uLm5lZWRzX3JlY29kaW5nIjogZmFsc2UsICJzdGFnZSI6IG51bGwsICJzdGF0aW9uX25hbWUiOiAiQ0xPVUdIIEFORCBUUlVFIERJVENIIiwgInN0YXRpb25fc3RhdHVzIjogIkFjdGl2ZSIsICJzdGF0aW9uX3R5cGUiOiAiRGl2ZXJzaW9uIiwgInVzZ3Nfc3RhdGlvbl9pZCI6IG51bGwsICJ2YXJpYWJsZSI6ICJESVNDSFJHIiwgIndkIjogIjUifSwgInR5cGUiOiAiRmVhdHVyZSJ9LCB7ImJib3giOiBbLTEwNS4zMzA4NDEsIDQwLjAwNjM4LCAtMTA1LjMzMDg0MSwgNDAuMDA2MzhdLCAiZ2VvbWV0cnkiOiB7ImNvb3JkaW5hdGVzIjogWy0xMDUuMzMwODQxLCA0MC4wMDYzOF0sICJ0eXBlIjogIlBvaW50In0sICJpZCI6ICI0IiwgInByb3BlcnRpZXMiOiB7ImFtb3VudCI6ICIyMC40MCIsICJjb3VudHkiOiAiQk9VTERFUiIsICJkYXRhX3NvdXJjZSI6ICJDby4gRGl2aXNpb24gb2YgV2F0ZXIgUmVzb3VyY2VzIiwgImRhdGVfdGltZSI6ICIyMDIwLTAzLTMxVDE1OjE1OjAwLjAwMCIsICJkaXYiOiAiMSIsICJkd3JfYWJicmV2IjogIkJPQ09ST0NPIiwgImZsYWciOiAiSWNlIiwgImh0dHBfbGlua2FnZS51cmwiOiAiaHR0cHM6Ly9kd3Iuc3RhdGUuY28udXMvU3VyZmFjZVdhdGVyL2RhdGEvZGV0YWlsX2dyYXBoLmFzcHg/SUQ9Qk9DT1JPQ09cdTAwMjZNVFlQRT1ESVNDSFJHIiwgImxvY2F0aW9uLmxhdGl0dWRlIjogNDAuMDA2MzgsICJsb2NhdGlvbi5sb25naXR1ZGUiOiAtMTA1LjMzMDg0MSwgImxvY2F0aW9uLm5lZWRzX3JlY29kaW5nIjogZmFsc2UsICJzdGFnZSI6ICIxLjg0IiwgInN0YXRpb25fbmFtZSI6ICJCT1VMREVSIENSRUVLIE5FQVIgT1JPREVMTCwgQ08uIiwgInN0YXRpb25fc3RhdHVzIjogIkFjdGl2ZSIsICJzdGF0aW9uX3R5cGUiOiAiU3RyZWFtIiwgInVzZ3Nfc3RhdGlvbl9pZCI6ICIwNjcyNzAwMCIsICJ2YXJpYWJsZSI6ICJESVNDSFJHIiwgIndkIjogIjYifSwgInR5cGUiOiAiRmVhdHVyZSJ9LCB7ImJib3giOiBbLTEwNS4yMTg3NzcsIDQwLjIwNDE5MywgLTEwNS4yMTg3NzcsIDQwLjIwNDE5M10sICJnZW9tZXRyeSI6IHsiY29vcmRpbmF0ZXMiOiBbLTEwNS4yMTg3NzcsIDQwLjIwNDE5M10sICJ0eXBlIjogIlBvaW50In0sICJpZCI6ICI1IiwgInByb3BlcnRpZXMiOiB7ImFtb3VudCI6ICIwLjAwIiwgImNvdW50eSI6ICJCT1VMREVSIiwgImRhdGFfc291cmNlIjogIkNvb3BlcmF0aXZlIFByb2dyYW0gb2YgQ0RXUiwgTkNXQ0QgXHUwMDI2IFNWTEhXQ0QiLCAiZGF0ZV90aW1lIjogIjIwMjAtMDMtMzFUMTU6MDA6MDAuMDAwIiwgImRpdiI6ICIxIiwgImR3cl9hYmJyZXYiOiAiTE9OU1VQQ08iLCAiZmxhZyI6IG51bGwsICJodHRwX2xpbmthZ2UudXJsIjogImh0dHBzOi8vZHdyLnN0YXRlLmNvLnVzL1N1cmZhY2VXYXRlci9kYXRhL2RldGFpbF9ncmFwaC5hc3B4P0lEPUxPTlNVUENPXHUwMDI2TVRZUEU9RElTQ0hSRyIsICJsb2NhdGlvbi5sYXRpdHVkZSI6IDQwLjIwNDE5MywgImxvY2F0aW9uLmxvbmdpdHVkZSI6IC0xMDUuMjE4Nzc3LCAibG9jYXRpb24ubmVlZHNfcmVjb2RpbmciOiBmYWxzZSwgInN0YWdlIjogbnVsbCwgInN0YXRpb25fbmFtZSI6ICJMT05HTU9OVCBTVVBQTFkgRElUQ0giLCAic3RhdGlvbl9zdGF0dXMiOiAiQWN0aXZlIiwgInN0YXRpb25fdHlwZSI6ICJEaXZlcnNpb24iLCAidXNnc19zdGF0aW9uX2lkIjogbnVsbCwgInZhcmlhYmxlIjogIkRJU0NIUkciLCAid2QiOiAiNSJ9LCAidHlwZSI6ICJGZWF0dXJlIn0sIHsiYmJveCI6IFstMTA1LjE3NTgxNywgNDAuMjU4NzI2LCAtMTA1LjE3NTgxNywgNDAuMjU4NzI2XSwgImdlb21ldHJ5IjogeyJjb29yZGluYXRlcyI6IFstMTA1LjE3NTgxNywgNDAuMjU4NzI2XSwgInR5cGUiOiAiUG9pbnQifSwgImlkIjogIjYiLCAicHJvcGVydGllcyI6IHsiYW1vdW50IjogIjExLjkwIiwgImNvdW50eSI6ICJCT1VMREVSIiwgImRhdGFfc291cmNlIjogIkNvLiBEaXZpc2lvbiBvZiBXYXRlciBSZXNvdXJjZXMiLCAiZGF0ZV90aW1lIjogIjIwMjAtMDMtMzFUMTU6MTU6MDAuMDAwIiwgImRpdiI6ICIxIiwgImR3cl9hYmJyZXYiOiAiQk9VQllQQ08iLCAiZmxhZyI6IG51bGwsICJodHRwX2xpbmthZ2UudXJsIjogImh0dHBzOi8vZHdyLnN0YXRlLmNvLnVzL1N1cmZhY2VXYXRlci9kYXRhL2RldGFpbF9ncmFwaC5hc3B4P0lEPUJPVUJZUENPXHUwMDI2TVRZUEU9RElTQ0hSRyIsICJsb2NhdGlvbi5sYXRpdHVkZSI6IDQwLjI1ODcyNiwgImxvY2F0aW9uLmxvbmdpdHVkZSI6IC0xMDUuMTc1ODE3LCAibG9jYXRpb24ubmVlZHNfcmVjb2RpbmciOiBmYWxzZSwgInN0YWdlIjogIjAuODMiLCAic3RhdGlvbl9uYW1lIjogIkJPVUxERVItTEFSSU1FUiBCWVBBU1MgTkVBUiBCRVJUSE9VRCIsICJzdGF0aW9uX3N0YXR1cyI6ICJBY3RpdmUiLCAic3RhdGlvbl90eXBlIjogIkRpdmVyc2lvbiIsICJ1c2dzX3N0YXRpb25faWQiOiBudWxsLCAidmFyaWFibGUiOiAiRElTQ0hSRyIsICJ3ZCI6ICI0In0sICJ0eXBlIjogIkZlYXR1cmUifSwgeyJiYm94IjogWy0xMDUuMjA2Mzg2LCA0MC4yNTgwMzgsIC0xMDUuMjA2Mzg2LCA0MC4yNTgwMzhdLCAiZ2VvbWV0cnkiOiB7ImNvb3JkaW5hdGVzIjogWy0xMDUuMjA2Mzg2LCA0MC4yNTgwMzhdLCAidHlwZSI6ICJQb2ludCJ9LCAiaWQiOiAiNyIsICJwcm9wZXJ0aWVzIjogeyJhbW91bnQiOiAiMTQuMjAiLCAiY291bnR5IjogIkJPVUxERVIiLCAiZGF0YV9zb3VyY2UiOiAiQ28uIERpdmlzaW9uIG9mIFdhdGVyIFJlc291cmNlcyIsICJkYXRlX3RpbWUiOiAiMjAyMC0wMy0zMVQxNTozMDowMC4wMDAiLCAiZGl2IjogIjEiLCAiZHdyX2FiYnJldiI6ICJMVENBTllDTyIsICJmbGFnIjogbnVsbCwgImh0dHBfbGlua2FnZS51cmwiOiAiaHR0cHM6Ly9kd3Iuc3RhdGUuY28udXMvU3VyZmFjZVdhdGVyL2RhdGEvZGV0YWlsX2dyYXBoLmFzcHg/SUQ9TFRDQU5ZQ09cdTAwMjZNVFlQRT1ESVNDSFJHIiwgImxvY2F0aW9uLmxhdGl0dWRlIjogNDAuMjU4MDM4LCAibG9jYXRpb24ubG9uZ2l0dWRlIjogLTEwNS4yMDYzODYsICJsb2NhdGlvbi5uZWVkc19yZWNvZGluZyI6IGZhbHNlLCAic3RhZ2UiOiAiMS41MCIsICJzdGF0aW9uX25hbWUiOiAiTElUVExFIFRIT01QU09OIFJJVkVSIEFUIENBTllPTiBNT1VUSCBORUFSIEJFUlRIT1VEIiwgInN0YXRpb25fc3RhdHVzIjogIkFjdGl2ZSIsICJzdGF0aW9uX3R5cGUiOiAiU3RyZWFtIiwgInVzZ3Nfc3RhdGlvbl9pZCI6IG51bGwsICJ2YXJpYWJsZSI6ICJESVNDSFJHIiwgIndkIjogIjQifSwgInR5cGUiOiAiRmVhdHVyZSJ9LCB7ImJib3giOiBbLTEwNS4xNjc2MjIsIDQwLjE3MjkyNSwgLTEwNS4xNjc2MjIsIDQwLjE3MjkyNV0sICJnZW9tZXRyeSI6IHsiY29vcmRpbmF0ZXMiOiBbLTEwNS4xNjc2MjIsIDQwLjE3MjkyNV0sICJ0eXBlIjogIlBvaW50In0sICJpZCI6ICI4IiwgInByb3BlcnRpZXMiOiB7ImFtb3VudCI6ICIwLjAwIiwgImNvdW50eSI6ICJCT1VMREVSIiwgImRhdGFfc291cmNlIjogIkNvb3BlcmF0aXZlIFNEUiBQcm9ncmFtIG9mIENEV1IgXHUwMDI2IE5DV0NEIiwgImRhdGVfdGltZSI6ICIyMDIwLTAzLTMxVDE1OjAwOjAwLjAwMCIsICJkaXYiOiAiMSIsICJkd3JfYWJicmV2IjogIk5PUk1VVENPIiwgImZsYWciOiBudWxsLCAiaHR0cF9saW5rYWdlLnVybCI6ICJodHRwczovL2R3ci5zdGF0ZS5jby51cy9TdXJmYWNlV2F0ZXIvZGF0YS9kZXRhaWxfZ3JhcGguYXNweD9JRD1OT1JNVVRDT1x1MDAyNk1UWVBFPURJU0NIUkciLCAibG9jYXRpb24ubGF0aXR1ZGUiOiA0MC4xNzI5MjUsICJsb2NhdGlvbi5sb25naXR1ZGUiOiAtMTA1LjE2NzYyMiwgImxvY2F0aW9uLm5lZWRzX3JlY29kaW5nIjogZmFsc2UsICJzdGFnZSI6IG51bGwsICJzdGF0aW9uX25hbWUiOiAiTk9SVEhXRVNUIE1VVFVBTCBESVRDSCIsICJzdGF0aW9uX3N0YXR1cyI6ICJBY3RpdmUiLCAic3RhdGlvbl90eXBlIjogIkRpdmVyc2lvbiIsICJ1c2dzX3N0YXRpb25faWQiOiBudWxsLCAidmFyaWFibGUiOiAiRElTQ0hSRyIsICJ3ZCI6ICI1In0sICJ0eXBlIjogIkZlYXR1cmUifSwgeyJiYm94IjogWy0xMDUuMTMwODE5LCA0MC4xMzQyNzgsIC0xMDUuMTMwODE5LCA0MC4xMzQyNzhdLCAiZ2VvbWV0cnkiOiB7ImNvb3JkaW5hdGVzIjogWy0xMDUuMTMwODE5LCA0MC4xMzQyNzhdLCAidHlwZSI6ICJQb2ludCJ9LCAiaWQiOiAiOSIsICJwcm9wZXJ0aWVzIjogeyJhbW91bnQiOiAiMy42MSIsICJjb3VudHkiOiAiQk9VTERFUiIsICJkYXRhX3NvdXJjZSI6ICJVLlMuIEdlb2xvZ2ljYWwgU3VydmV5IiwgImRhdGVfdGltZSI6ICIyMDIwLTAzLTMxVDE1OjEwOjAwLjAwMCIsICJkaXYiOiAiMSIsICJkd3JfYWJicmV2IjogIkxFRlRIT0NPIiwgImZsYWciOiBudWxsLCAiaHR0cF9saW5rYWdlLnVybCI6ICJodHRwczovL3dhdGVyZGF0YS51c2dzLmdvdi9ud2lzL3V2PzA2NzI0OTcwIiwgImxvY2F0aW9uLmxhdGl0dWRlIjogNDAuMTM0Mjc4LCAibG9jYXRpb24ubG9uZ2l0dWRlIjogLTEwNS4xMzA4MTksICJsb2NhdGlvbi5uZWVkc19yZWNvZGluZyI6IGZhbHNlLCAic3RhZ2UiOiBudWxsLCAic3RhdGlvbl9uYW1lIjogIkxFRlQgSEFORCBDUkVFSyBBVCBIT1ZFUiBST0FEIE5FQVIgTE9OR01PTlQsIENPIiwgInN0YXRpb25fc3RhdHVzIjogIkFjdGl2ZSIsICJzdGF0aW9uX3R5cGUiOiAiU3RyZWFtIiwgInVzZ3Nfc3RhdGlvbl9pZCI6ICIwNjcyNDk3MCIsICJ2YXJpYWJsZSI6ICJESVNDSFJHIiwgIndkIjogIjUifSwgInR5cGUiOiAiRmVhdHVyZSJ9LCB7ImJib3giOiBbLTEwNS4yMTg2NzcsIDM5Ljk4NjE2OSwgLTEwNS4yMTg2NzcsIDM5Ljk4NjE2OV0sICJnZW9tZXRyeSI6IHsiY29vcmRpbmF0ZXMiOiBbLTEwNS4yMTg2NzcsIDM5Ljk4NjE2OV0sICJ0eXBlIjogIlBvaW50In0sICJpZCI6ICIxMCIsICJwcm9wZXJ0aWVzIjogeyJhbW91bnQiOiAiMC4wMCIsICJjb3VudHkiOiAiQk9VTERFUiIsICJkYXRhX3NvdXJjZSI6ICJDb29wZXJhdGl2ZSBQcm9ncmFtIG9mIENEV1IsIE5DV0NEIFx1MDAyNiBMU1BXQ0QiLCAiZGF0ZV90aW1lIjogIjIwMjAtMDMtMzFUMTQ6MDA6MDAuMDAwIiwgImRpdiI6ICIxIiwgImR3cl9hYmJyZXYiOiAiRFJZQ0FSQ08iLCAiZmxhZyI6IG51bGwsICJodHRwX2xpbmthZ2UudXJsIjogImh0dHBzOi8vZHdyLnN0YXRlLmNvLnVzL1N1cmZhY2VXYXRlci9kYXRhL2RldGFpbF9ncmFwaC5hc3B4P0lEPURSWUNBUkNPXHUwMDI2TVRZUEU9RElTQ0hSRyIsICJsb2NhdGlvbi5sYXRpdHVkZSI6IDM5Ljk4NjE2OSwgImxvY2F0aW9uLmxvbmdpdHVkZSI6IC0xMDUuMjE4Njc3LCAibG9jYXRpb24ubmVlZHNfcmVjb2RpbmciOiBmYWxzZSwgInN0YWdlIjogbnVsbCwgInN0YXRpb25fbmFtZSI6ICJEUlkgQ1JFRUsgQ0FSUklFUiIsICJzdGF0aW9uX3N0YXR1cyI6ICJBY3RpdmUiLCAic3RhdGlvbl90eXBlIjogIkRpdmVyc2lvbiIsICJ1c2dzX3N0YXRpb25faWQiOiBudWxsLCAidmFyaWFibGUiOiAiRElTQ0hSRyIsICJ3ZCI6ICI2In0sICJ0eXBlIjogIkZlYXR1cmUifSwgeyJiYm94IjogWy0xMDUuMTY4NDcxLCA0MC4xNjA3MDUsIC0xMDUuMTY4NDcxLCA0MC4xNjA3MDVdLCAiZ2VvbWV0cnkiOiB7ImNvb3JkaW5hdGVzIjogWy0xMDUuMTY4NDcxLCA0MC4xNjA3MDVdLCAidHlwZSI6ICJQb2ludCJ9LCAiaWQiOiAiMTEiLCAicHJvcGVydGllcyI6IHsiYW1vdW50IjogIjAuMDAiLCAiY291bnR5IjogIkJPVUxERVIiLCAiZGF0YV9zb3VyY2UiOiAiQ28uIERpdmlzaW9uIG9mIFdhdGVyIFJlc291cmNlcyIsICJkYXRlX3RpbWUiOiAiMjAyMC0wMy0zMVQxMzo0NTowMC4wMDAiLCAiZGl2IjogIjEiLCAiZHdyX2FiYnJldiI6ICJQRUNSVE5DTyIsICJmbGFnIjogbnVsbCwgImh0dHBfbGlua2FnZS51cmwiOiAiaHR0cHM6Ly9kd3Iuc3RhdGUuY28udXMvU3VyZmFjZVdhdGVyL2RhdGEvZGV0YWlsX2dyYXBoLmFzcHg/SUQ9UEVDUlROQ09cdTAwMjZNVFlQRT1ESVNDSFJHIiwgImxvY2F0aW9uLmxhdGl0dWRlIjogNDAuMTYwNzA1LCAibG9jYXRpb24ubG9uZ2l0dWRlIjogLTEwNS4xNjg0NzEsICJsb2NhdGlvbi5uZWVkc19yZWNvZGluZyI6IGZhbHNlLCAic3RhZ2UiOiBudWxsLCAic3RhdGlvbl9uYW1lIjogIlBFQ0stUEVMTEEgQVVHTUVOVEFUSU9OIFJFVFVSTiIsICJzdGF0aW9uX3N0YXR1cyI6ICJBY3RpdmUiLCAic3RhdGlvbl90eXBlIjogIkRpdmVyc2lvbiIsICJ1c2dzX3N0YXRpb25faWQiOiBudWxsLCAidmFyaWFibGUiOiAiRElTQ0hSRyIsICJ3ZCI6ICI1In0sICJ0eXBlIjogIkZlYXR1cmUifSwgeyJiYm94IjogWy0xMDUuMjIyNjM5LCA0MC4xOTkzMjEsIC0xMDUuMjIyNjM5LCA0MC4xOTkzMjFdLCAiZ2VvbWV0cnkiOiB7ImNvb3JkaW5hdGVzIjogWy0xMDUuMjIyNjM5LCA0MC4xOTkzMjFdLCAidHlwZSI6ICJQb2ludCJ9LCAiaWQiOiAiMTIiLCAicHJvcGVydGllcyI6IHsiYW1vdW50IjogIjAuMDAiLCAiY291bnR5IjogIkJPVUxERVIiLCAiZGF0YV9zb3VyY2UiOiAiQ29vcGVyYXRpdmUgUHJvZ3JhbSBvZiBDRFdSLCBOQ1dDRCBcdTAwMjYgU1ZMSFdDRCIsICJkYXRlX3RpbWUiOiAiMjAyMC0wMy0zMVQxNDo0NTowMC4wMDAiLCAiZGl2IjogIjEiLCAiZHdyX2FiYnJldiI6ICJHT0RJVDFDTyIsICJmbGFnIjogbnVsbCwgImh0dHBfbGlua2FnZS51cmwiOiAiaHR0cHM6Ly9kd3Iuc3RhdGUuY28udXMvU3VyZmFjZVdhdGVyL2RhdGEvZGV0YWlsX2dyYXBoLmFzcHg/SUQ9R09ESVQxQ09cdTAwMjZNVFlQRT1ESVNDSFJHIiwgImxvY2F0aW9uLmxhdGl0dWRlIjogNDAuMTk5MzIxLCAibG9jYXRpb24ubG9uZ2l0dWRlIjogLTEwNS4yMjI2MzksICJsb2NhdGlvbi5uZWVkc19yZWNvZGluZyI6IGZhbHNlLCAic3RhZ2UiOiBudWxsLCAic3RhdGlvbl9uYW1lIjogIkdPU1MgRElUQ0ggMSIsICJzdGF0aW9uX3N0YXR1cyI6ICJBY3RpdmUiLCAic3RhdGlvbl90eXBlIjogIkRpdmVyc2lvbiIsICJ1c2dzX3N0YXRpb25faWQiOiBudWxsLCAidmFyaWFibGUiOiAiRElTQ0hSRyIsICJ3ZCI6ICI1In0sICJ0eXBlIjogIkZlYXR1cmUifSwgeyJiYm94IjogWy0xMDUuMjEwNDI0LCA0MC4xOTMyOCwgLTEwNS4yMTA0MjQsIDQwLjE5MzI4XSwgImdlb21ldHJ5IjogeyJjb29yZGluYXRlcyI6IFstMTA1LjIxMDQyNCwgNDAuMTkzMjhdLCAidHlwZSI6ICJQb2ludCJ9LCAiaWQiOiAiMTMiLCAicHJvcGVydGllcyI6IHsiYW1vdW50IjogIjAuMDAiLCAiY291bnR5IjogIkJPVUxERVIiLCAiZGF0YV9zb3VyY2UiOiAiQ29vcGVyYXRpdmUgUHJvZ3JhbSBvZiBDRFdSLCBOQ1dDRCBcdTAwMjYgU1ZMSFdDRCIsICJkYXRlX3RpbWUiOiAiMjAyMC0wMy0zMVQxNTowMDowMC4wMDAiLCAiZGl2IjogIjEiLCAiZHdyX2FiYnJldiI6ICJXRUJESVRDTyIsICJmbGFnIjogbnVsbCwgImh0dHBfbGlua2FnZS51cmwiOiAiaHR0cHM6Ly9kd3Iuc3RhdGUuY28udXMvU3VyZmFjZVdhdGVyL2RhdGEvZGV0YWlsX2dyYXBoLmFzcHg/SUQ9V0VCRElUQ09cdTAwMjZNVFlQRT1ESVNDSFJHIiwgImxvY2F0aW9uLmxhdGl0dWRlIjogNDAuMTkzMjgsICJsb2NhdGlvbi5sb25naXR1ZGUiOiAtMTA1LjIxMDQyNCwgImxvY2F0aW9uLm5lZWRzX3JlY29kaW5nIjogZmFsc2UsICJzdGFnZSI6IG51bGwsICJzdGF0aW9uX25hbWUiOiAiV0VCU1RFUiBNQ0NBU0xJTiBESVRDSCIsICJzdGF0aW9uX3N0YXR1cyI6ICJBY3RpdmUiLCAic3RhdGlvbl90eXBlIjogIkRpdmVyc2lvbiIsICJ1c2dzX3N0YXRpb25faWQiOiBudWxsLCAidmFyaWFibGUiOiAiRElTQ0hSRyIsICJ3ZCI6ICI1In0sICJ0eXBlIjogIkZlYXR1cmUifSwgeyJiYm94IjogWy0xMDUuMTUxMTQzLCA0MC4wNTM2NjEsIC0xMDUuMTUxMTQzLCA0MC4wNTM2NjFdLCAiZ2VvbWV0cnkiOiB7ImNvb3JkaW5hdGVzIjogWy0xMDUuMTUxMTQzLCA0MC4wNTM2NjFdLCAidHlwZSI6ICJQb2ludCJ9LCAiaWQiOiAiMTQiLCAicHJvcGVydGllcyI6IHsiYW1vdW50IjogIjIuMDYiLCAiY291bnR5IjogIkJPVUxERVIiLCAiZGF0YV9zb3VyY2UiOiAiQ29vcGVyYXRpdmUgUHJvZ3JhbSBvZiBDRFdSLCBOQ1dDRCBcdTAwMjYgTFNQV0NEIiwgImRhdGVfdGltZSI6ICIyMDIwLTAzLTMxVDE1OjAwOjAwLjAwMCIsICJkaXYiOiAiMSIsICJkd3JfYWJicmV2IjogIkxFR0RJVENPIiwgImZsYWciOiBudWxsLCAiaHR0cF9saW5rYWdlLnVybCI6ICJodHRwczovL2R3ci5zdGF0ZS5jby51cy9TdXJmYWNlV2F0ZXIvZGF0YS9kZXRhaWxfZ3JhcGguYXNweD9JRD1MRUdESVRDT1x1MDAyNk1UWVBFPURJU0NIUkciLCAibG9jYXRpb24ubGF0aXR1ZGUiOiA0MC4wNTM2NjEsICJsb2NhdGlvbi5sb25naXR1ZGUiOiAtMTA1LjE1MTE0MywgImxvY2F0aW9uLm5lZWRzX3JlY29kaW5nIjogZmFsc2UsICJzdGFnZSI6ICIwLjE4IiwgInN0YXRpb25fbmFtZSI6ICJMRUdHRVRUIERJVENIIiwgInN0YXRpb25fc3RhdHVzIjogIkFjdGl2ZSIsICJzdGF0aW9uX3R5cGUiOiAiRGl2ZXJzaW9uIiwgInVzZ3Nfc3RhdGlvbl9pZCI6IG51bGwsICJ2YXJpYWJsZSI6ICJESVNDSFJHIiwgIndkIjogIjYifSwgInR5cGUiOiAiRmVhdHVyZSJ9LCB7ImJib3giOiBbLTEwNS4zNjUzNjUsIDQwLjIxNjI2MywgLTEwNS4zNjUzNjUsIDQwLjIxNjI2M10sICJnZW9tZXRyeSI6IHsiY29vcmRpbmF0ZXMiOiBbLTEwNS4zNjUzNjUsIDQwLjIxNjI2M10sICJ0eXBlIjogIlBvaW50In0sICJpZCI6ICIxNSIsICJwcm9wZXJ0aWVzIjogeyJhbW91bnQiOiAiMTI5MTMuMDAiLCAiY291bnR5IjogIkJPVUxERVIiLCAiZGF0YV9zb3VyY2UiOiAiQ28uIERpdmlzaW9uIG9mIFdhdGVyIFJlc291cmNlcyIsICJkYXRlX3RpbWUiOiAiMjAyMC0wMy0zMVQxNDo0NTowMC4wMDAiLCAiZGl2IjogIjEiLCAiZHdyX2FiYnJldiI6ICJCUktEQU1DTyIsICJmbGFnIjogbnVsbCwgImh0dHBfbGlua2FnZS51cmwiOiAiaHR0cHM6Ly9kd3Iuc3RhdGUuY28udXMvU3VyZmFjZVdhdGVyL2RhdGEvZGV0YWlsX2dyYXBoLmFzcHg/SUQ9QlJLREFNQ09cdTAwMjZNVFlQRT1TVE9SQUdFIiwgImxvY2F0aW9uLmxhdGl0dWRlIjogNDAuMjE2MjYzLCAibG9jYXRpb24ubG9uZ2l0dWRlIjogLTEwNS4zNjUzNjUsICJsb2NhdGlvbi5uZWVkc19yZWNvZGluZyI6IGZhbHNlLCAic3RhZ2UiOiAiNjM4NC4xOCIsICJzdGF0aW9uX25hbWUiOiAiQlVUVE9OUk9DSyAoUkFMUEggUFJJQ0UpIFJFU0VSVk9JUiIsICJzdGF0aW9uX3N0YXR1cyI6ICJBY3RpdmUiLCAic3RhdGlvbl90eXBlIjogIlJlc2Vydm9pciIsICJ1c2dzX3N0YXRpb25faWQiOiBudWxsLCAidmFyaWFibGUiOiAiU1RPUkFHRSIsICJ3ZCI6ICI1In0sICJ0eXBlIjogIkZlYXR1cmUifSwgeyJiYm94IjogWy0xMDUuMjA5NSwgNDAuMjU1Nzc2LCAtMTA1LjIwOTUsIDQwLjI1NTc3Nl0sICJnZW9tZXRyeSI6IHsiY29vcmRpbmF0ZXMiOiBbLTEwNS4yMDk1LCA0MC4yNTU3NzZdLCAidHlwZSI6ICJQb2ludCJ9LCAiaWQiOiAiMTYiLCAicHJvcGVydGllcyI6IHsiYW1vdW50IjogIjAuMTAiLCAiY291bnR5IjogIkJPVUxERVIiLCAiZGF0YV9zb3VyY2UiOiAiTm9ydGhlcm4gQ29sb3JhZG8gV2F0ZXIgQ29uc2VydmFuY3kgRGlzdHJpY3QiLCAiZGF0ZV90aW1lIjogIjIwMjAtMDMtMzFUMTU6MDA6MDAuMDAwIiwgImRpdiI6ICIxIiwgImR3cl9hYmJyZXYiOiAiTElUVEgyQ08iLCAiZmxhZyI6IG51bGwsICJodHRwX2xpbmthZ2UudXJsIjogImh0dHA6Ly93d3cubm9ydGhlcm53YXRlci5vcmcvV2F0ZXJQcm9qZWN0cy9FYXN0U2xvcGVXYXRlckRhdGEuYXNweCIsICJsb2NhdGlvbi5sYXRpdHVkZSI6IDQwLjI1NTc3NiwgImxvY2F0aW9uLmxvbmdpdHVkZSI6IC0xMDUuMjA5NSwgImxvY2F0aW9uLm5lZWRzX3JlY29kaW5nIjogZmFsc2UsICJzdGFnZSI6ICIwLjEwIiwgInN0YXRpb25fbmFtZSI6ICJMSVRUTEUgVEhPTVBTT04gIzIgRElUQ0giLCAic3RhdGlvbl9zdGF0dXMiOiAiQWN0aXZlIiwgInN0YXRpb25fdHlwZSI6ICJEaXZlcnNpb24iLCAidXNnc19zdGF0aW9uX2lkIjogIkVTMTkwMCIsICJ2YXJpYWJsZSI6ICJESVNDSFJHIiwgIndkIjogIjQifSwgInR5cGUiOiAiRmVhdHVyZSJ9LCB7ImJib3giOiBbLTEwNS4xNjQzOTcsIDQwLjI1Nzg0NCwgLTEwNS4xNjQzOTcsIDQwLjI1Nzg0NF0sICJnZW9tZXRyeSI6IHsiY29vcmRpbmF0ZXMiOiBbLTEwNS4xNjQzOTcsIDQwLjI1Nzg0NF0sICJ0eXBlIjogIlBvaW50In0sICJpZCI6ICIxNyIsICJwcm9wZXJ0aWVzIjogeyJhbW91bnQiOiAiMC4wMCIsICJjb3VudHkiOiAiQk9VTERFUiIsICJkYXRhX3NvdXJjZSI6ICJDb29wZXJhdGl2ZSBTRFIgUHJvZ3JhbSBvZiBDRFdSIFx1MDAyNiBOQ1dDRCIsICJkYXRlX3RpbWUiOiAiMjAyMC0wMy0zMVQxNTowMDowMC4wMDAiLCAiZGl2IjogIjEiLCAiZHdyX2FiYnJldiI6ICJCTFdESVRDTyIsICJmbGFnIjogbnVsbCwgImh0dHBfbGlua2FnZS51cmwiOiAiaHR0cHM6Ly9kd3Iuc3RhdGUuY28udXMvU3VyZmFjZVdhdGVyL2RhdGEvZGV0YWlsX2dyYXBoLmFzcHg/SUQ9QkxXRElUQ09cdTAwMjZNVFlQRT1ESVNDSFJHIiwgImxvY2F0aW9uLmxhdGl0dWRlIjogNDAuMjU3ODQ0LCAibG9jYXRpb24ubG9uZ2l0dWRlIjogLTEwNS4xNjQzOTcsICJsb2NhdGlvbi5uZWVkc19yZWNvZGluZyI6IGZhbHNlLCAic3RhZ2UiOiAiMC4wMCIsICJzdGF0aW9uX25hbWUiOiAiQkxPV0VSIERJVENIIiwgInN0YXRpb25fc3RhdHVzIjogIkFjdGl2ZSIsICJzdGF0aW9uX3R5cGUiOiAiRGl2ZXJzaW9uIiwgInVzZ3Nfc3RhdGlvbl9pZCI6IG51bGwsICJ2YXJpYWJsZSI6ICJESVNDSFJHIiwgIndkIjogIjQifSwgInR5cGUiOiAiRmVhdHVyZSJ9LCB7ImJib3giOiBbLTEwNS4zNDc5MDYsIDM5LjkzODM1MSwgLTEwNS4zNDc5MDYsIDM5LjkzODM1MV0sICJnZW9tZXRyeSI6IHsiY29vcmRpbmF0ZXMiOiBbLTEwNS4zNDc5MDYsIDM5LjkzODM1MV0sICJ0eXBlIjogIlBvaW50In0sICJpZCI6ICIxOCIsICJwcm9wZXJ0aWVzIjogeyJhbW91bnQiOiAiMTYuNDAiLCAiY291bnR5IjogIkJPVUxERVIiLCAiZGF0YV9zb3VyY2UiOiAiQ28uIERpdmlzaW9uIG9mIFdhdGVyIFJlc291cmNlcyIsICJkYXRlX3RpbWUiOiAiMjAyMC0wMy0zMVQxNToxNTowMC4wMDAiLCAiZGl2IjogIjEiLCAiZHdyX2FiYnJldiI6ICJCT0NCR1JDTyIsICJmbGFnIjogbnVsbCwgImh0dHBfbGlua2FnZS51cmwiOiAiaHR0cHM6Ly9kd3Iuc3RhdGUuY28udXMvU3VyZmFjZVdhdGVyL2RhdGEvZGV0YWlsX2dyYXBoLmFzcHg/SUQ9Qk9DQkdSQ09cdTAwMjZNVFlQRT1ESVNDSFJHIiwgImxvY2F0aW9uLmxhdGl0dWRlIjogMzkuOTM4MzUxLCAibG9jYXRpb24ubG9uZ2l0dWRlIjogLTEwNS4zNDc5MDYsICJsb2NhdGlvbi5uZWVkc19yZWNvZGluZyI6IGZhbHNlLCAic3RhZ2UiOiAiMC4zNiIsICJzdGF0aW9uX25hbWUiOiAiU09VVEggQk9VTERFUiBDUkVFSyBCRUxPVyBHUk9TUyBSRVNFUlZPSVIiLCAic3RhdGlvbl9zdGF0dXMiOiAiQWN0aXZlIiwgInN0YXRpb25fdHlwZSI6ICJTdHJlYW0iLCAidXNnc19zdGF0aW9uX2lkIjogIjA2NzI5NDUwIiwgInZhcmlhYmxlIjogIkRJU0NIUkciLCAid2QiOiAiNiJ9LCAidHlwZSI6ICJGZWF0dXJlIn0sIHsiYmJveCI6IFstMTA1LjE3ODg3NSwgNDAuMDUxNjUyLCAtMTA1LjE3ODg3NSwgNDAuMDUxNjUyXSwgImdlb21ldHJ5IjogeyJjb29yZGluYXRlcyI6IFstMTA1LjE3ODg3NSwgNDAuMDUxNjUyXSwgInR5cGUiOiAiUG9pbnQifSwgImlkIjogIjE5IiwgInByb3BlcnRpZXMiOiB7ImFtb3VudCI6ICIyNS41MCIsICJjb3VudHkiOiAiQk9VTERFUiIsICJkYXRhX3NvdXJjZSI6ICJVLlMuIEdlb2xvZ2ljYWwgU3VydmV5IiwgImRhdGVfdGltZSI6ICIyMDIwLTAzLTMxVDE1OjE1OjAwLjAwMCIsICJkaXYiOiAiMSIsICJkd3JfYWJicmV2IjogIkJPQ05PUkNPIiwgImZsYWciOiBudWxsLCAiaHR0cF9saW5rYWdlLnVybCI6ICJodHRwczovL3dhdGVyZGF0YS51c2dzLmdvdi9ud2lzL3V2PzA2NzMwMjAwIiwgImxvY2F0aW9uLmxhdGl0dWRlIjogNDAuMDUxNjUyLCAibG9jYXRpb24ubG9uZ2l0dWRlIjogLTEwNS4xNzg4NzUsICJsb2NhdGlvbi5uZWVkc19yZWNvZGluZyI6IGZhbHNlLCAic3RhZ2UiOiBudWxsLCAic3RhdGlvbl9uYW1lIjogIkJPVUxERVIgQ1JFRUsgQVQgTk9SVEggNzVUSCBTVC4gTkVBUiBCT1VMREVSLCBDTyIsICJzdGF0aW9uX3N0YXR1cyI6ICJBY3RpdmUiLCAic3RhdGlvbl90eXBlIjogIlN0cmVhbSIsICJ1c2dzX3N0YXRpb25faWQiOiAiMDY3MzAyMDAiLCAidmFyaWFibGUiOiAiRElTQ0hSRyIsICJ3ZCI6ICI2In0sICJ0eXBlIjogIkZlYXR1cmUifSwgeyJiYm94IjogWy0xMDUuMTYwODc2LCA0MC4xNzA5OTgsIC0xMDUuMTYwODc2LCA0MC4xNzA5OThdLCAiZ2VvbWV0cnkiOiB7ImNvb3JkaW5hdGVzIjogWy0xMDUuMTYwODc2LCA0MC4xNzA5OThdLCAidHlwZSI6ICJQb2ludCJ9LCAiaWQiOiAiMjAiLCAicHJvcGVydGllcyI6IHsiYW1vdW50IjogIjAuMzgiLCAiY291bnR5IjogIkJPVUxERVIiLCAiZGF0YV9zb3VyY2UiOiAiQ29vcGVyYXRpdmUgUHJvZ3JhbSBvZiBDRFdSLCBOQ1dDRCBcdTAwMjYgU1ZMSFdDRCIsICJkYXRlX3RpbWUiOiAiMjAyMC0wMy0zMVQxNTowMDowMC4wMDAiLCAiZGl2IjogIjEiLCAiZHdyX2FiYnJldiI6ICJTRkxESVRDTyIsICJmbGFnIjogbnVsbCwgImh0dHBfbGlua2FnZS51cmwiOiAiaHR0cHM6Ly9kd3Iuc3RhdGUuY28udXMvU3VyZmFjZVdhdGVyL2RhdGEvZGV0YWlsX2dyYXBoLmFzcHg/SUQ9U0ZMRElUQ09cdTAwMjZNVFlQRT1ESVNDSFJHIiwgImxvY2F0aW9uLmxhdGl0dWRlIjogNDAuMTcwOTk4LCAibG9jYXRpb24ubG9uZ2l0dWRlIjogLTEwNS4xNjA4NzYsICJsb2NhdGlvbi5uZWVkc19yZWNvZGluZyI6IGZhbHNlLCAic3RhZ2UiOiAiMC4xMSIsICJzdGF0aW9uX25hbWUiOiAiU09VVEggRkxBVCBESVRDSCIsICJzdGF0aW9uX3N0YXR1cyI6ICJBY3RpdmUiLCAic3RhdGlvbl90eXBlIjogIkRpdmVyc2lvbiIsICJ1c2dzX3N0YXRpb25faWQiOiBudWxsLCAidmFyaWFibGUiOiAiRElTQ0hSRyIsICJ3ZCI6ICI1In0sICJ0eXBlIjogIkZlYXR1cmUifSwgeyJiYm94IjogWy0xMDUuMDc1Njk1LCA0MC4xNTMzNDEsIC0xMDUuMDc1Njk1LCA0MC4xNTMzNDFdLCAiZ2VvbWV0cnkiOiB7ImNvb3JkaW5hdGVzIjogWy0xMDUuMDc1Njk1LCA0MC4xNTMzNDFdLCAidHlwZSI6ICJQb2ludCJ9LCAiaWQiOiAiMjEiLCAicHJvcGVydGllcyI6IHsiYW1vdW50IjogIjMxLjQwIiwgImNvdW50eSI6ICJCT1VMREVSIiwgImRhdGFfc291cmNlIjogIkNvLiBEaXZpc2lvbiBvZiBXYXRlciBSZXNvdXJjZXMiLCAiZGF0ZV90aW1lIjogIjIwMjAtMDMtMzFUMTU6MzA6MDAuMDAwIiwgImRpdiI6ICIxIiwgImR3cl9hYmJyZXYiOiAiU1ZDTE9QQ08iLCAiZmxhZyI6IG51bGwsICJodHRwX2xpbmthZ2UudXJsIjogImh0dHBzOi8vZHdyLnN0YXRlLmNvLnVzL1N1cmZhY2VXYXRlci9kYXRhL2RldGFpbF9ncmFwaC5hc3B4P0lEPVNWQ0xPUENPXHUwMDI2TVRZUEU9RElTQ0hSRyIsICJsb2NhdGlvbi5sYXRpdHVkZSI6IDQwLjE1MzM0MSwgImxvY2F0aW9uLmxvbmdpdHVkZSI6IC0xMDUuMDc1Njk1LCAibG9jYXRpb24ubmVlZHNfcmVjb2RpbmciOiBmYWxzZSwgInN0YWdlIjogIjMuNDkiLCAic3RhdGlvbl9uYW1lIjogIlNBSU5UIFZSQUlOIENSRUVLIEJFTE9XIEtFTiBQUkFUVCBCTFZEIEFUIExPTkdNT05ULCBDTyIsICJzdGF0aW9uX3N0YXR1cyI6ICJBY3RpdmUiLCAic3RhdGlvbl90eXBlIjogIlN0cmVhbSIsICJ1c2dzX3N0YXRpb25faWQiOiBudWxsLCAidmFyaWFibGUiOiAiRElTQ0hSRyIsICJ3ZCI6ICI1In0sICJ0eXBlIjogIkZlYXR1cmUifSwgeyJiYm94IjogWy0xMDUuNTA0NDQsIDM5Ljk2MTY1NSwgLTEwNS41MDQ0NCwgMzkuOTYxNjU1XSwgImdlb21ldHJ5IjogeyJjb29yZGluYXRlcyI6IFstMTA1LjUwNDQ0LCAzOS45NjE2NTVdLCAidHlwZSI6ICJQb2ludCJ9LCAiaWQiOiAiMjIiLCAicHJvcGVydGllcyI6IHsiYW1vdW50IjogIjI0LjAwIiwgImNvdW50eSI6ICJCT1VMREVSIiwgImRhdGFfc291cmNlIjogIkNvLiBEaXZpc2lvbiBvZiBXYXRlciBSZXNvdXJjZXMiLCAiZGF0ZV90aW1lIjogIjIwMjAtMDMtMzFUMTU6MTU6MDAuMDAwIiwgImRpdiI6ICIxIiwgImR3cl9hYmJyZXYiOiAiQk9DTUlEQ08iLCAiZmxhZyI6ICJJY2UiLCAiaHR0cF9saW5rYWdlLnVybCI6ICJodHRwczovL2R3ci5zdGF0ZS5jby51cy9TdXJmYWNlV2F0ZXIvZGF0YS9kZXRhaWxfZ3JhcGguYXNweD9JRD1CT0NNSURDT1x1MDAyNk1UWVBFPURJU0NIUkciLCAibG9jYXRpb24ubGF0aXR1ZGUiOiAzOS45NjE2NTUsICJsb2NhdGlvbi5sb25naXR1ZGUiOiAtMTA1LjUwNDQ0LCAibG9jYXRpb24ubmVlZHNfcmVjb2RpbmciOiBmYWxzZSwgInN0YWdlIjogIjEuMTMiLCAic3RhdGlvbl9uYW1lIjogIk1JRERMRSBCT1VMREVSIENSRUVLIEFUIE5FREVSTEFORCwgQ08uIiwgInN0YXRpb25fc3RhdHVzIjogIkFjdGl2ZSIsICJzdGF0aW9uX3R5cGUiOiAiU3RyZWFtIiwgInVzZ3Nfc3RhdGlvbl9pZCI6ICIwNjcyNTUwMCIsICJ2YXJpYWJsZSI6ICJESVNDSFJHIiwgIndkIjogIjYifSwgInR5cGUiOiAiRmVhdHVyZSJ9LCB7ImJib3giOiBbLTEwNS4wOTc4NzIsIDQwLjA1OTgwOSwgLTEwNS4wOTc4NzIsIDQwLjA1OTgwOV0sICJnZW9tZXRyeSI6IHsiY29vcmRpbmF0ZXMiOiBbLTEwNS4wOTc4NzIsIDQwLjA1OTgwOV0sICJ0eXBlIjogIlBvaW50In0sICJpZCI6ICIyMyIsICJwcm9wZXJ0aWVzIjogeyJhbW91bnQiOiAiNTcuNjAiLCAiY291bnR5IjogIkJPVUxERVIiLCAiZGF0YV9zb3VyY2UiOiAiQ28uIERpdmlzaW9uIG9mIFdhdGVyIFJlc291cmNlcyIsICJkYXRlX3RpbWUiOiAiMjAyMC0wMy0zMVQxNDo0NTowMC4wMDAiLCAiZGl2IjogIjEiLCAiZHdyX2FiYnJldiI6ICJCT0MxMDlDTyIsICJmbGFnIjogbnVsbCwgImh0dHBfbGlua2FnZS51cmwiOiAiaHR0cHM6Ly9kd3Iuc3RhdGUuY28udXMvU3VyZmFjZVdhdGVyL2RhdGEvZGV0YWlsX2dyYXBoLmFzcHg/SUQ9Qk9DMTA5Q09cdTAwMjZNVFlQRT1ESVNDSFJHIiwgImxvY2F0aW9uLmxhdGl0dWRlIjogNDAuMDU5ODA5LCAibG9jYXRpb24ubG9uZ2l0dWRlIjogLTEwNS4wOTc4NzIsICJsb2NhdGlvbi5uZWVkc19yZWNvZGluZyI6IGZhbHNlLCAic3RhZ2UiOiAiMi42MyIsICJzdGF0aW9uX25hbWUiOiAiQk9VTERFUiBDUkVFSyBBVCAxMDkgU1QgTkVBUiBFUklFLCBDTyIsICJzdGF0aW9uX3N0YXR1cyI6ICJBY3RpdmUiLCAic3RhdGlvbl90eXBlIjogIlN0cmVhbSIsICJ1c2dzX3N0YXRpb25faWQiOiBudWxsLCAidmFyaWFibGUiOiAiRElTQ0hSRyIsICJ3ZCI6ICI2In0sICJ0eXBlIjogIkZlYXR1cmUifSwgeyJiYm94IjogWy0xMDUuMzYzNDIyLCA0MC4yMTU2NTgsIC0xMDUuMzYzNDIyLCA0MC4yMTU2NThdLCAiZ2VvbWV0cnkiOiB7ImNvb3JkaW5hdGVzIjogWy0xMDUuMzYzNDIyLCA0MC4yMTU2NThdLCAidHlwZSI6ICJQb2ludCJ9LCAiaWQiOiAiMjQiLCAicHJvcGVydGllcyI6IHsiYW1vdW50IjogIjE5LjMwIiwgImNvdW50eSI6ICJCT1VMREVSIiwgImRhdGFfc291cmNlIjogIkNvLiBEaXZpc2lvbiBvZiBXYXRlciBSZXNvdXJjZXMiLCAiZGF0ZV90aW1lIjogIjIwMjAtMDMtMzFUMTQ6NDU6MDAuMDAwIiwgImRpdiI6ICIxIiwgImR3cl9hYmJyZXYiOiAiTlNWQkJSQ08iLCAiZmxhZyI6IG51bGwsICJodHRwX2xpbmthZ2UudXJsIjogImh0dHBzOi8vZHdyLnN0YXRlLmNvLnVzL1N1cmZhY2VXYXRlci9kYXRhL2RldGFpbF9ncmFwaC5hc3B4P0lEPU5TVkJCUkNPXHUwMDI2TVRZUEU9RElTQ0hSRyIsICJsb2NhdGlvbi5sYXRpdHVkZSI6IDQwLjIxNTY1OCwgImxvY2F0aW9uLmxvbmdpdHVkZSI6IC0xMDUuMzYzNDIyLCAibG9jYXRpb24ubmVlZHNfcmVjb2RpbmciOiBmYWxzZSwgInN0YWdlIjogIjAuMzQiLCAic3RhdGlvbl9uYW1lIjogIk5PUlRIIFNBSU5UIFZSQUlOIENSRUVLIEJFTE9XIEJVVFRPTlJPQ0sgIChSQUxQSCBQUklDRSkgUkVTRVJWT0lSIiwgInN0YXRpb25fc3RhdHVzIjogIkFjdGl2ZSIsICJzdGF0aW9uX3R5cGUiOiAiU3RyZWFtIiwgInVzZ3Nfc3RhdGlvbl9pZCI6IG51bGwsICJ2YXJpYWJsZSI6ICJESVNDSFJHIiwgIndkIjogIjUifSwgInR5cGUiOiAiRmVhdHVyZSJ9LCB7ImJib3giOiBbLTEwNS4zMDQ0MDQsIDQwLjEyNjM4OSwgLTEwNS4zMDQ0MDQsIDQwLjEyNjM4OV0sICJnZW9tZXRyeSI6IHsiY29vcmRpbmF0ZXMiOiBbLTEwNS4zMDQ0MDQsIDQwLjEyNjM4OV0sICJ0eXBlIjogIlBvaW50In0sICJpZCI6ICIyNSIsICJwcm9wZXJ0aWVzIjogeyJhbW91bnQiOiAiMTMuNTAiLCAiY291bnR5IjogIkJPVUxERVIiLCAiZGF0YV9zb3VyY2UiOiAiQ28uIERpdmlzaW9uIG9mIFdhdGVyIFJlc291cmNlcyIsICJkYXRlX3RpbWUiOiAiMjAyMC0wMy0zMVQxNToxNTowMC4wMDAiLCAiZGl2IjogIjEiLCAiZHdyX2FiYnJldiI6ICJMRUZDUkVDTyIsICJmbGFnIjogbnVsbCwgImh0dHBfbGlua2FnZS51cmwiOiAiaHR0cHM6Ly9kd3Iuc3RhdGUuY28udXMvU3VyZmFjZVdhdGVyL2RhdGEvZGV0YWlsX2dyYXBoLmFzcHg/SUQ9TEVGQ1JFQ09cdTAwMjZNVFlQRT1ESVNDSFJHIiwgImxvY2F0aW9uLmxhdGl0dWRlIjogNDAuMTI2Mzg5LCAibG9jYXRpb24ubG9uZ2l0dWRlIjogLTEwNS4zMDQ0MDQsICJsb2NhdGlvbi5uZWVkc19yZWNvZGluZyI6IGZhbHNlLCAic3RhZ2UiOiAiMC40OCIsICJzdGF0aW9uX25hbWUiOiAiTEVGVCBIQU5EIENSRUVLIE5FQVIgQk9VTERFUiwgQ08uIiwgInN0YXRpb25fc3RhdHVzIjogIkFjdGl2ZSIsICJzdGF0aW9uX3R5cGUiOiAiU3RyZWFtIiwgInVzZ3Nfc3RhdGlvbl9pZCI6ICIwNjcyNDUwMCIsICJ2YXJpYWJsZSI6ICJESVNDSFJHIiwgIndkIjogIjUifSwgInR5cGUiOiAiRmVhdHVyZSJ9LCB7ImJib3giOiBbLTEwNS4yMTc1MTksIDQwLjA4NjI3OCwgLTEwNS4yMTc1MTksIDQwLjA4NjI3OF0sICJnZW9tZXRyeSI6IHsiY29vcmRpbmF0ZXMiOiBbLTEwNS4yMTc1MTksIDQwLjA4NjI3OF0sICJ0eXBlIjogIlBvaW50In0sICJpZCI6ICIyNiIsICJwcm9wZXJ0aWVzIjogeyJhbW91bnQiOiAiMC4wMCIsICJjb3VudHkiOiAiQk9VTERFUiIsICJkYXRhX3NvdXJjZSI6ICJOb3J0aGVybiBDb2xvcmFkbyBXYXRlciBDb25zZXJ2YW5jeSBEaXN0cmljdCIsICJkYXRlX3RpbWUiOiAiMjAyMC0wMy0zMVQxNTowMDowMC4wMDAiLCAiZGl2IjogIjEiLCAiZHdyX2FiYnJldiI6ICJCRkNJTkZDTyIsICJmbGFnIjogbnVsbCwgImh0dHBfbGlua2FnZS51cmwiOiAiaHR0cDovL3d3dy5ub3J0aGVybndhdGVyLm9yZy9XYXRlclByb2plY3RzL0Vhc3RTbG9wZVdhdGVyRGF0YS5hc3B4IiwgImxvY2F0aW9uLmxhdGl0dWRlIjogNDAuMDg2Mjc4LCAibG9jYXRpb24ubG9uZ2l0dWRlIjogLTEwNS4yMTc1MTksICJsb2NhdGlvbi5uZWVkc19yZWNvZGluZyI6IGZhbHNlLCAic3RhZ2UiOiAiMC4wMSIsICJzdGF0aW9uX25hbWUiOiAiQk9VTERFUiBSRVNFUlZPSVIgSU5MRVQiLCAic3RhdGlvbl9zdGF0dXMiOiAiQWN0aXZlIiwgInN0YXRpb25fdHlwZSI6ICJTdHJlYW0iLCAidXNnc19zdGF0aW9uX2lkIjogIkVTMTkxNiIsICJ2YXJpYWJsZSI6ICJESVNDSFJHIiwgIndkIjogIjYifSwgInR5cGUiOiAiRmVhdHVyZSJ9LCB7ImJib3giOiBbLTEwNS4yMTAzODgsIDQwLjE5MzAxOSwgLTEwNS4yMTAzODgsIDQwLjE5MzAxOV0sICJnZW9tZXRyeSI6IHsiY29vcmRpbmF0ZXMiOiBbLTEwNS4yMTAzODgsIDQwLjE5MzAxOV0sICJ0eXBlIjogIlBvaW50In0sICJpZCI6ICIyNyIsICJwcm9wZXJ0aWVzIjogeyJhbW91bnQiOiAiMC4wMCIsICJjb3VudHkiOiAiQk9VTERFUiIsICJkYXRhX3NvdXJjZSI6ICJDb29wZXJhdGl2ZSBQcm9ncmFtIG9mIENEV1IsIE5DV0NEIFx1MDAyNiBTVkxIV0NEIiwgImRhdGVfdGltZSI6ICIyMDIwLTAzLTMxVDE1OjAwOjAwLjAwMCIsICJkaXYiOiAiMSIsICJkd3JfYWJicmV2IjogIlRSVURJVENPIiwgImZsYWciOiBudWxsLCAiaHR0cF9saW5rYWdlLnVybCI6ICJodHRwczovL2R3ci5zdGF0ZS5jby51cy9TdXJmYWNlV2F0ZXIvZGF0YS9kZXRhaWxfZ3JhcGguYXNweD9JRD1UUlVESVRDT1x1MDAyNk1UWVBFPURJU0NIUkciLCAibG9jYXRpb24ubGF0aXR1ZGUiOiA0MC4xOTMwMTksICJsb2NhdGlvbi5sb25naXR1ZGUiOiAtMTA1LjIxMDM4OCwgImxvY2F0aW9uLm5lZWRzX3JlY29kaW5nIjogZmFsc2UsICJzdGFnZSI6IG51bGwsICJzdGF0aW9uX25hbWUiOiAiVFJVRSBBTkQgV0VCU1RFUiBESVRDSCIsICJzdGF0aW9uX3N0YXR1cyI6ICJBY3RpdmUiLCAic3RhdGlvbl90eXBlIjogIkRpdmVyc2lvbiIsICJ1c2dzX3N0YXRpb25faWQiOiBudWxsLCAidmFyaWFibGUiOiAiRElTQ0hSRyIsICJ3ZCI6ICI1In0sICJ0eXBlIjogIkZlYXR1cmUifSwgeyJiYm94IjogWy0xMDUuMjUxODI2LCA0MC4yMTI2NTgsIC0xMDUuMjUxODI2LCA0MC4yMTI2NThdLCAiZ2VvbWV0cnkiOiB7ImNvb3JkaW5hdGVzIjogWy0xMDUuMjUxODI2LCA0MC4yMTI2NThdLCAidHlwZSI6ICJQb2ludCJ9LCAiaWQiOiAiMjgiLCAicHJvcGVydGllcyI6IHsiYW1vdW50IjogIjAuMDAiLCAiY291bnR5IjogIkJPVUxERVIiLCAiZGF0YV9zb3VyY2UiOiAiQ29vcGVyYXRpdmUgUHJvZ3JhbSBvZiBDRFdSLCBOQ1dDRCBcdTAwMjYgU1ZMSFdDRCIsICJkYXRlX3RpbWUiOiAiMjAyMC0wMy0zMVQxNTowMDowMC4wMDAiLCAiZGl2IjogIjEiLCAiZHdyX2FiYnJldiI6ICJST1VSRUFDTyIsICJmbGFnIjogbnVsbCwgImh0dHBfbGlua2FnZS51cmwiOiAiaHR0cHM6Ly9kd3Iuc3RhdGUuY28udXMvU3VyZmFjZVdhdGVyL2RhdGEvZGV0YWlsX2dyYXBoLmFzcHg/SUQ9Uk9VUkVBQ09cdTAwMjZNVFlQRT1ESVNDSFJHIiwgImxvY2F0aW9uLmxhdGl0dWRlIjogNDAuMjEyNjU4LCAibG9jYXRpb24ubG9uZ2l0dWRlIjogLTEwNS4yNTE4MjYsICJsb2NhdGlvbi5uZWVkc19yZWNvZGluZyI6IGZhbHNlLCAic3RhZ2UiOiBudWxsLCAic3RhdGlvbl9uYW1lIjogIlJPVUdIIEFORCBSRUFEWSBESVRDSCIsICJzdGF0aW9uX3N0YXR1cyI6ICJBY3RpdmUiLCAic3RhdGlvbl90eXBlIjogIkRpdmVyc2lvbiIsICJ1c2dzX3N0YXRpb25faWQiOiBudWxsLCAidmFyaWFibGUiOiAiRElTQ0hSRyIsICJ3ZCI6ICI1In0sICJ0eXBlIjogIkZlYXR1cmUifSwgeyJiYm94IjogWy0xMDUuMTY3ODczLCA0MC4xNzQ4NDQsIC0xMDUuMTY3ODczLCA0MC4xNzQ4NDRdLCAiZ2VvbWV0cnkiOiB7ImNvb3JkaW5hdGVzIjogWy0xMDUuMTY3ODczLCA0MC4xNzQ4NDRdLCAidHlwZSI6ICJQb2ludCJ9LCAiaWQiOiAiMjkiLCAicHJvcGVydGllcyI6IHsiYW1vdW50IjogIjAuMTgiLCAiY291bnR5IjogIkJPVUxERVIiLCAiZGF0YV9zb3VyY2UiOiAiQ29vcGVyYXRpdmUgUHJvZ3JhbSBvZiBDRFdSLCBOQ1dDRCBcdTAwMjYgU1ZMSFdDRCIsICJkYXRlX3RpbWUiOiAiMjAyMC0wMy0zMVQxNDo0NTowMC4wMDAiLCAiZGl2IjogIjEiLCAiZHdyX2FiYnJldiI6ICJIR1JNRFdDTyIsICJmbGFnIjogbnVsbCwgImh0dHBfbGlua2FnZS51cmwiOiAiaHR0cHM6Ly9kd3Iuc3RhdGUuY28udXMvU3VyZmFjZVdhdGVyL2RhdGEvZGV0YWlsX2dyYXBoLmFzcHg/SUQ9SEdSTURXQ09cdTAwMjZNVFlQRT1ESVNDSFJHIiwgImxvY2F0aW9uLmxhdGl0dWRlIjogNDAuMTc0ODQ0LCAibG9jYXRpb24ubG9uZ2l0dWRlIjogLTEwNS4xNjc4NzMsICJsb2NhdGlvbi5uZWVkc19yZWNvZGluZyI6IGZhbHNlLCAic3RhZ2UiOiAiMC4wOSIsICJzdGF0aW9uX25hbWUiOiAiSEFHRVIgTUVBRE9XUyBESVRDSCIsICJzdGF0aW9uX3N0YXR1cyI6ICJBY3RpdmUiLCAic3RhdGlvbl90eXBlIjogIkRpdmVyc2lvbiIsICJ1c2dzX3N0YXRpb25faWQiOiBudWxsLCAidmFyaWFibGUiOiAiRElTQ0hSRyIsICJ3ZCI6ICI1In0sICJ0eXBlIjogIkZlYXR1cmUifSwgeyJiYm94IjogWy0xMDUuMjA5NDE2LCA0MC4yNTYyNzYsIC0xMDUuMjA5NDE2LCA0MC4yNTYyNzZdLCAiZ2VvbWV0cnkiOiB7ImNvb3JkaW5hdGVzIjogWy0xMDUuMjA5NDE2LCA0MC4yNTYyNzZdLCAidHlwZSI6ICJQb2ludCJ9LCAiaWQiOiAiMzAiLCAicHJvcGVydGllcyI6IHsiYW1vdW50IjogIjAuMDAiLCAiY291bnR5IjogIkJPVUxERVIiLCAiZGF0YV9zb3VyY2UiOiAiTm9ydGhlcm4gQ29sb3JhZG8gV2F0ZXIgQ29uc2VydmFuY3kgRGlzdHJpY3QiLCAiZGF0ZV90aW1lIjogIjIwMjAtMDMtMzFUMTU6MDA6MDAuMDAwIiwgImRpdiI6ICIxIiwgImR3cl9hYmJyZXYiOiAiTElUVEgxQ08iLCAiZmxhZyI6IG51bGwsICJodHRwX2xpbmthZ2UudXJsIjogImh0dHA6Ly93d3cubm9ydGhlcm53YXRlci5vcmcvV2F0ZXJQcm9qZWN0cy9FYXN0U2xvcGVXYXRlckRhdGEuYXNweCIsICJsb2NhdGlvbi5sYXRpdHVkZSI6IDQwLjI1NjI3NiwgImxvY2F0aW9uLmxvbmdpdHVkZSI6IC0xMDUuMjA5NDE2LCAibG9jYXRpb24ubmVlZHNfcmVjb2RpbmciOiBmYWxzZSwgInN0YWdlIjogbnVsbCwgInN0YXRpb25fbmFtZSI6ICJMSVRUTEUgVEhPTVBTT04gIzEgRElUQ0giLCAic3RhdGlvbl9zdGF0dXMiOiAiQWN0aXZlIiwgInN0YXRpb25fdHlwZSI6ICJEaXZlcnNpb24iLCAidXNnc19zdGF0aW9uX2lkIjogIkVTMTkwMSIsICJ2YXJpYWJsZSI6ICJESVNDSFJHIiwgIndkIjogIjQifSwgInR5cGUiOiAiRmVhdHVyZSJ9LCB7ImJib3giOiBbLTEwNS4xOTg1NjcsIDQwLjI2MDgyNywgLTEwNS4xOTg1NjcsIDQwLjI2MDgyN10sICJnZW9tZXRyeSI6IHsiY29vcmRpbmF0ZXMiOiBbLTEwNS4xOTg1NjcsIDQwLjI2MDgyN10sICJ0eXBlIjogIlBvaW50In0sICJpZCI6ICIzMSIsICJwcm9wZXJ0aWVzIjogeyJhbW91bnQiOiAiMC4wMCIsICJjb3VudHkiOiAiQk9VTERFUiIsICJkYXRhX3NvdXJjZSI6ICJDb29wZXJhdGl2ZSBTRFIgUHJvZ3JhbSBvZiBDRFdSIFx1MDAyNiBOQ1dDRCIsICJkYXRlX3RpbWUiOiAiMjAyMC0wMy0zMVQxNTowMDowMC4wMDAiLCAiZGl2IjogIjEiLCAiZHdyX2FiYnJldiI6ICJDVUxESVRDTyIsICJmbGFnIjogbnVsbCwgImh0dHBfbGlua2FnZS51cmwiOiAiaHR0cHM6Ly9kd3Iuc3RhdGUuY28udXMvU3VyZmFjZVdhdGVyL2RhdGEvZGV0YWlsX2dyYXBoLmFzcHg/SUQ9Q1VMRElUQ09cdTAwMjZNVFlQRT1ESVNDSFJHIiwgImxvY2F0aW9uLmxhdGl0dWRlIjogNDAuMjYwODI3LCAibG9jYXRpb24ubG9uZ2l0dWRlIjogLTEwNS4xOTg1NjcsICJsb2NhdGlvbi5uZWVkc19yZWNvZGluZyI6IGZhbHNlLCAic3RhZ2UiOiBudWxsLCAic3RhdGlvbl9uYW1lIjogIkNVTFZFUiBESVRDSCIsICJzdGF0aW9uX3N0YXR1cyI6ICJBY3RpdmUiLCAic3RhdGlvbl90eXBlIjogIkRpdmVyc2lvbiIsICJ1c2dzX3N0YXRpb25faWQiOiBudWxsLCAidmFyaWFibGUiOiAiRElTQ0hSRyIsICJ3ZCI6ICI0In0sICJ0eXBlIjogIkZlYXR1cmUifSwgeyJiYm94IjogWy0xMDUuMjU2MDE3LCA0MC4yMTUwNDMsIC0xMDUuMjU2MDE3LCA0MC4yMTUwNDNdLCAiZ2VvbWV0cnkiOiB7ImNvb3JkaW5hdGVzIjogWy0xMDUuMjU2MDE3LCA0MC4yMTUwNDNdLCAidHlwZSI6ICJQb2ludCJ9LCAiaWQiOiAiMzIiLCAicHJvcGVydGllcyI6IHsiYW1vdW50IjogIjM1LjYwIiwgImNvdW50eSI6ICJCT1VMREVSIiwgImRhdGFfc291cmNlIjogIkNvLiBEaXZpc2lvbiBvZiBXYXRlciBSZXNvdXJjZXMiLCAiZGF0ZV90aW1lIjogIjIwMjAtMDMtMzFUMTU6MzA6MDAuMDAwIiwgImRpdiI6ICIxIiwgImR3cl9hYmJyZXYiOiAiSElHSExEQ08iLCAiZmxhZyI6IG51bGwsICJodHRwX2xpbmthZ2UudXJsIjogImh0dHBzOi8vZHdyLnN0YXRlLmNvLnVzL1N1cmZhY2VXYXRlci9kYXRhL2RldGFpbF9ncmFwaC5hc3B4P0lEPUhJR0hMRENPXHUwMDI2TVRZUEU9RElTQ0hSRyIsICJsb2NhdGlvbi5sYXRpdHVkZSI6IDQwLjIxNTA0MywgImxvY2F0aW9uLmxvbmdpdHVkZSI6IC0xMDUuMjU2MDE3LCAibG9jYXRpb24ubmVlZHNfcmVjb2RpbmciOiBmYWxzZSwgInN0YWdlIjogIjAuNjgiLCAic3RhdGlvbl9uYW1lIjogIkhJR0hMQU5EIERJVENIIEFUIExZT05TLCBDTyIsICJzdGF0aW9uX3N0YXR1cyI6ICJBY3RpdmUiLCAic3RhdGlvbl90eXBlIjogIkRpdmVyc2lvbiIsICJ1c2dzX3N0YXRpb25faWQiOiBudWxsLCAidmFyaWFibGUiOiAiRElTQ0hSRyIsICJ3ZCI6ICI1In0sICJ0eXBlIjogIkZlYXR1cmUifSwgeyJiYm94IjogWy0xMDUuMjIwNDk3LCA0MC4wNzg1NiwgLTEwNS4yMjA0OTcsIDQwLjA3ODU2XSwgImdlb21ldHJ5IjogeyJjb29yZGluYXRlcyI6IFstMTA1LjIyMDQ5NywgNDAuMDc4NTZdLCAidHlwZSI6ICJQb2ludCJ9LCAiaWQiOiAiMzMiLCAicHJvcGVydGllcyI6IHsiYW1vdW50IjogIjUxMzcuNTAiLCAiY291bnR5IjogIkJPVUxERVIiLCAiZGF0YV9zb3VyY2UiOiAiTm9ydGhlcm4gQ29sb3JhZG8gV2F0ZXIgQ29uc2VydmFuY3kgRGlzdHJpY3QiLCAiZGF0ZV90aW1lIjogIjIwMjAtMDMtMzFUMTU6MDA6MDAuMDAwIiwgImRpdiI6ICIxIiwgImR3cl9hYmJyZXYiOiAiQk9VUkVTQ08iLCAiZmxhZyI6IG51bGwsICJodHRwX2xpbmthZ2UudXJsIjogImh0dHA6Ly93d3cubm9ydGhlcm53YXRlci5vcmcvV2F0ZXJQcm9qZWN0cy9FYXN0U2xvcGVXYXRlckRhdGEuYXNweCIsICJsb2NhdGlvbi5sYXRpdHVkZSI6IDQwLjA3ODU2LCAibG9jYXRpb24ubG9uZ2l0dWRlIjogLTEwNS4yMjA0OTcsICJsb2NhdGlvbi5uZWVkc19yZWNvZGluZyI6IGZhbHNlLCAic3RhZ2UiOiBudWxsLCAic3RhdGlvbl9uYW1lIjogIkJPVUxERVIgUkVTRVJWT0lSIiwgInN0YXRpb25fc3RhdHVzIjogIkFjdGl2ZSIsICJzdGF0aW9uX3R5cGUiOiAiUmVzZXJ2b2lyIiwgInVzZ3Nfc3RhdGlvbl9pZCI6ICJFUjE5MTQiLCAidmFyaWFibGUiOiAiU1RPUkFHRSIsICJ3ZCI6ICI2In0sICJ0eXBlIjogIkZlYXR1cmUifSwgeyJiYm94IjogWy0xMDUuMTY5Mzc0LCA0MC4xNzM5NSwgLTEwNS4xNjkzNzQsIDQwLjE3Mzk1XSwgImdlb21ldHJ5IjogeyJjb29yZGluYXRlcyI6IFstMTA1LjE2OTM3NCwgNDAuMTczOTVdLCAidHlwZSI6ICJQb2ludCJ9LCAiaWQiOiAiMzQiLCAicHJvcGVydGllcyI6IHsiYW1vdW50IjogIjAuMTkiLCAiY291bnR5IjogIkJPVUxERVIiLCAiZGF0YV9zb3VyY2UiOiAiQ29vcGVyYXRpdmUgUHJvZ3JhbSBvZiBDRFdSLCBOQ1dDRCBcdTAwMjYgU1ZMSFdDRCIsICJkYXRlX3RpbWUiOiAiMjAyMC0wMy0zMVQxNDozMDowMC4wMDAiLCAiZGl2IjogIjEiLCAiZHdyX2FiYnJldiI6ICJOSVdESVRDTyIsICJmbGFnIjogbnVsbCwgImh0dHBfbGlua2FnZS51cmwiOiAiaHR0cHM6Ly9kd3Iuc3RhdGUuY28udXMvU3VyZmFjZVdhdGVyL2RhdGEvZGV0YWlsX2dyYXBoLmFzcHg/SUQ9TklXRElUQ09cdTAwMjZNVFlQRT1ESVNDSFJHIiwgImxvY2F0aW9uLmxhdGl0dWRlIjogNDAuMTczOTUsICJsb2NhdGlvbi5sb25naXR1ZGUiOiAtMTA1LjE2OTM3NCwgImxvY2F0aW9uLm5lZWRzX3JlY29kaW5nIjogZmFsc2UsICJzdGFnZSI6ICIwLjA5IiwgInN0YXRpb25fbmFtZSI6ICJOSVdPVCBESVRDSCIsICJzdGF0aW9uX3N0YXR1cyI6ICJBY3RpdmUiLCAic3RhdGlvbl90eXBlIjogIkRpdmVyc2lvbiIsICJ1c2dzX3N0YXRpb25faWQiOiBudWxsLCAidmFyaWFibGUiOiAiRElTQ0hSRyIsICJ3ZCI6ICI1In0sICJ0eXBlIjogIkZlYXR1cmUifSwgeyJiYm94IjogWy0xMDUuMjUwOTUyLCA0MC4yMTEzODksIC0xMDUuMjUwOTUyLCA0MC4yMTEzODldLCAiZ2VvbWV0cnkiOiB7ImNvb3JkaW5hdGVzIjogWy0xMDUuMjUwOTUyLCA0MC4yMTEzODldLCAidHlwZSI6ICJQb2ludCJ9LCAiaWQiOiAiMzUiLCAicHJvcGVydGllcyI6IHsiYW1vdW50IjogIjAuMDAiLCAiY291bnR5IjogIkJPVUxERVIiLCAiZGF0YV9zb3VyY2UiOiAiQ29vcGVyYXRpdmUgUHJvZ3JhbSBvZiBDRFdSLCBOQ1dDRCBcdTAwMjYgU1ZMSFdDRCIsICJkYXRlX3RpbWUiOiAiMjAyMC0wMy0zMVQxNDowMDowMC4wMDAiLCAiZGl2IjogIjEiLCAiZHdyX2FiYnJldiI6ICJTTUVESVRDTyIsICJmbGFnIjogbnVsbCwgImh0dHBfbGlua2FnZS51cmwiOiAiaHR0cHM6Ly9kd3Iuc3RhdGUuY28udXMvU3VyZmFjZVdhdGVyL2RhdGEvZGV0YWlsX2dyYXBoLmFzcHg/SUQ9U01FRElUQ09cdTAwMjZNVFlQRT1ESVNDSFJHIiwgImxvY2F0aW9uLmxhdGl0dWRlIjogNDAuMjExMzg5LCAibG9jYXRpb24ubG9uZ2l0dWRlIjogLTEwNS4yNTA5NTIsICJsb2NhdGlvbi5uZWVkc19yZWNvZGluZyI6IGZhbHNlLCAic3RhZ2UiOiBudWxsLCAic3RhdGlvbl9uYW1lIjogIlNNRUFEIERJVENIIiwgInN0YXRpb25fc3RhdHVzIjogIkFjdGl2ZSIsICJzdGF0aW9uX3R5cGUiOiAiRGl2ZXJzaW9uIiwgInVzZ3Nfc3RhdGlvbl9pZCI6IG51bGwsICJ2YXJpYWJsZSI6ICJESVNDSFJHIiwgIndkIjogIjUifSwgInR5cGUiOiAiRmVhdHVyZSJ9LCB7ImJib3giOiBbLTEwNS4zMDg0MzIsIDM5LjkzMTgxMywgLTEwNS4zMDg0MzIsIDM5LjkzMTgxM10sICJnZW9tZXRyeSI6IHsiY29vcmRpbmF0ZXMiOiBbLTEwNS4zMDg0MzIsIDM5LjkzMTgxM10sICJ0eXBlIjogIlBvaW50In0sICJpZCI6ICIzNiIsICJwcm9wZXJ0aWVzIjogeyJhbW91bnQiOiAiMC4wMCIsICJjb3VudHkiOiAiQk9VTERFUiIsICJkYXRhX3NvdXJjZSI6ICJDby4gRGl2aXNpb24gb2YgV2F0ZXIgUmVzb3VyY2VzIiwgImRhdGVfdGltZSI6ICIyMDIwLTAzLTMxVDE1OjMwOjAwLjAwMCIsICJkaXYiOiAiMSIsICJkd3JfYWJicmV2IjogIkJPU0RFTENPIiwgImZsYWciOiBudWxsLCAiaHR0cF9saW5rYWdlLnVybCI6ICJodHRwczovL2R3ci5zdGF0ZS5jby51cy9TdXJmYWNlV2F0ZXIvZGF0YS9kZXRhaWxfZ3JhcGguYXNweD9JRD1CT1NERUxDT1x1MDAyNk1UWVBFPURJU0NIUkciLCAibG9jYXRpb24ubGF0aXR1ZGUiOiAzOS45MzE4MTMsICJsb2NhdGlvbi5sb25naXR1ZGUiOiAtMTA1LjMwODQzMiwgImxvY2F0aW9uLm5lZWRzX3JlY29kaW5nIjogZmFsc2UsICJzdGFnZSI6ICItMS43MCIsICJzdGF0aW9uX25hbWUiOiAiU09VVEggQk9VTERFUiBDUkVFSyBESVZFUlNJT04gTkVBUiBFTERPUkFETyBTUFJJTkdTIiwgInN0YXRpb25fc3RhdHVzIjogIkFjdGl2ZSIsICJzdGF0aW9uX3R5cGUiOiAiRGl2ZXJzaW9uIiwgInVzZ3Nfc3RhdGlvbl9pZCI6IG51bGwsICJ2YXJpYWJsZSI6ICJESVNDSFJHIiwgIndkIjogIjYifSwgInR5cGUiOiAiRmVhdHVyZSJ9LCB7ImJib3giOiBbLTEwNS4yNTgxMSwgNDAuMjE4MzM1LCAtMTA1LjI1ODExLCA0MC4yMTgzMzVdLCAiZ2VvbWV0cnkiOiB7ImNvb3JkaW5hdGVzIjogWy0xMDUuMjU4MTEsIDQwLjIxODMzNV0sICJ0eXBlIjogIlBvaW50In0sICJpZCI6ICIzNyIsICJwcm9wZXJ0aWVzIjogeyJhbW91bnQiOiAiOTQuOTAiLCAiY291bnR5IjogIkJPVUxERVIiLCAiZGF0YV9zb3VyY2UiOiAiTm9ydGhlcm4gQ29sb3JhZG8gV2F0ZXIgQ29uc2VydmFuY3kgRGlzdHJpY3QgKFN0YXRpb24gQ29vcGVyYXRvcikiLCAiZGF0ZV90aW1lIjogIjIwMjAtMDMtMzFUMTU6MzA6MDAuMDAwIiwgImRpdiI6ICIxIiwgImR3cl9hYmJyZXYiOiAiU1ZTTFlPQ08iLCAiZmxhZyI6IG51bGwsICJodHRwX2xpbmthZ2UudXJsIjogImh0dHBzOi8vZHdyLnN0YXRlLmNvLnVzL1N1cmZhY2VXYXRlci9kYXRhL2RldGFpbF9ncmFwaC5hc3B4P0lEPVNWU0xZT0NPXHUwMDI2TVRZUEU9RElTQ0hSRyIsICJsb2NhdGlvbi5sYXRpdHVkZSI6IDQwLjIxODMzNSwgImxvY2F0aW9uLmxvbmdpdHVkZSI6IC0xMDUuMjU4MTEsICJsb2NhdGlvbi5uZWVkc19yZWNvZGluZyI6IGZhbHNlLCAic3RhZ2UiOiAiMS4zOSIsICJzdGF0aW9uX25hbWUiOiAiU0FJTlQgVlJBSU4gU1VQUExZIENBTkFMIE5FQVIgTFlPTlMsIENPIiwgInN0YXRpb25fc3RhdHVzIjogIkFjdGl2ZSIsICJzdGF0aW9uX3R5cGUiOiAiRGl2ZXJzaW9uIiwgInVzZ3Nfc3RhdGlvbl9pZCI6IG51bGwsICJ2YXJpYWJsZSI6ICJESVNDSFJHIiwgIndkIjogIjUifSwgInR5cGUiOiAiRmVhdHVyZSJ9LCB7ImJib3giOiBbLTEwNS4wODg2OTUsIDQwLjE1MzM2MywgLTEwNS4wODg2OTUsIDQwLjE1MzM2M10sICJnZW9tZXRyeSI6IHsiY29vcmRpbmF0ZXMiOiBbLTEwNS4wODg2OTUsIDQwLjE1MzM2M10sICJ0eXBlIjogIlBvaW50In0sICJpZCI6ICIzOCIsICJwcm9wZXJ0aWVzIjogeyJhbW91bnQiOiAiMC4xMCIsICJjb3VudHkiOiAiQk9VTERFUiIsICJkYXRhX3NvdXJjZSI6ICJDb29wZXJhdGl2ZSBQcm9ncmFtIG9mIENEV1IsIE5DV0NEIFx1MDAyNiBTVkxIV0NEIiwgImRhdGVfdGltZSI6ICIyMDIwLTAzLTMxVDE1OjAwOjAwLjAwMCIsICJkaXYiOiAiMSIsICJkd3JfYWJicmV2IjogIkJPTkRJVENPIiwgImZsYWciOiBudWxsLCAiaHR0cF9saW5rYWdlLnVybCI6ICJodHRwczovL2R3ci5zdGF0ZS5jby51cy9TdXJmYWNlV2F0ZXIvZGF0YS9kZXRhaWxfZ3JhcGguYXNweD9JRD1CT05ESVRDT1x1MDAyNk1UWVBFPURJU0NIUkciLCAibG9jYXRpb24ubGF0aXR1ZGUiOiA0MC4xNTMzNjMsICJsb2NhdGlvbi5sb25naXR1ZGUiOiAtMTA1LjA4ODY5NSwgImxvY2F0aW9uLm5lZWRzX3JlY29kaW5nIjogZmFsc2UsICJzdGFnZSI6ICIwLjA0IiwgInN0YXRpb25fbmFtZSI6ICJCT05VUyBESVRDSCIsICJzdGF0aW9uX3N0YXR1cyI6ICJBY3RpdmUiLCAic3RhdGlvbl90eXBlIjogIkRpdmVyc2lvbiIsICJ1c2dzX3N0YXRpb25faWQiOiBudWxsLCAidmFyaWFibGUiOiAiRElTQ0hSRyIsICJ3ZCI6ICI1In0sICJ0eXBlIjogIkZlYXR1cmUifSwgeyJiYm94IjogWy0xMDUuMDkxMDU5LCA0MC4wOTYwMywgLTEwNS4wOTEwNTksIDQwLjA5NjAzXSwgImdlb21ldHJ5IjogeyJjb29yZGluYXRlcyI6IFstMTA1LjA5MTA1OSwgNDAuMDk2MDNdLCAidHlwZSI6ICJQb2ludCJ9LCAiaWQiOiAiMzkiLCAicHJvcGVydGllcyI6IHsiYW1vdW50IjogIjIyLjEwIiwgImNvdW50eSI6ICJCT1VMREVSIiwgImRhdGFfc291cmNlIjogIkNvLiBEaXZpc2lvbiBvZiBXYXRlciBSZXNvdXJjZXMiLCAiZGF0ZV90aW1lIjogIjIwMjAtMDMtMzFUMTQ6NDU6MDAuMDAwIiwgImRpdiI6ICIxIiwgImR3cl9hYmJyZXYiOiAiUE5NQUlOQ08iLCAiZmxhZyI6IG51bGwsICJodHRwX2xpbmthZ2UudXJsIjogImh0dHBzOi8vZHdyLnN0YXRlLmNvLnVzL1N1cmZhY2VXYXRlci9kYXRhL2RldGFpbF9ncmFwaC5hc3B4P0lEPVBOTUFJTkNPXHUwMDI2TVRZUEU9RElTQ0hSRyIsICJsb2NhdGlvbi5sYXRpdHVkZSI6IDQwLjA5NjAzLCAibG9jYXRpb24ubG9uZ2l0dWRlIjogLTEwNS4wOTEwNTksICJsb2NhdGlvbi5uZWVkc19yZWNvZGluZyI6IGZhbHNlLCAic3RhZ2UiOiBudWxsLCAic3RhdGlvbl9uYW1lIjogIlBBTkFNQSBSRVNFUlZPSVIgSU5MRVQiLCAic3RhdGlvbl9zdGF0dXMiOiAiQWN0aXZlIiwgInN0YXRpb25fdHlwZSI6ICJTdHJlYW0iLCAidXNnc19zdGF0aW9uX2lkIjogbnVsbCwgInZhcmlhYmxlIjogIkRJU0NIUkciLCAid2QiOiAiNiJ9LCAidHlwZSI6ICJGZWF0dXJlIn0sIHsiYmJveCI6IFstMTA1LjI1MDkyNywgNDAuMjExMDgzLCAtMTA1LjI1MDkyNywgNDAuMjExMDgzXSwgImdlb21ldHJ5IjogeyJjb29yZGluYXRlcyI6IFstMTA1LjI1MDkyNywgNDAuMjExMDgzXSwgInR5cGUiOiAiUG9pbnQifSwgImlkIjogIjQwIiwgInByb3BlcnRpZXMiOiB7ImFtb3VudCI6ICIwLjAwIiwgImNvdW50eSI6ICJCT1VMREVSIiwgImRhdGFfc291cmNlIjogIkNvb3BlcmF0aXZlIFByb2dyYW0gb2YgQ0RXUiwgTkNXQ0QgXHUwMDI2IFNWTEhXQ0QiLCAiZGF0ZV90aW1lIjogIjIwMjAtMDMtMzFUMTQ6MDA6MDAuMDAwIiwgImRpdiI6ICIxIiwgImR3cl9hYmJyZXYiOiAiU1dFRElUQ08iLCAiZmxhZyI6IG51bGwsICJodHRwX2xpbmthZ2UudXJsIjogImh0dHBzOi8vZHdyLnN0YXRlLmNvLnVzL1N1cmZhY2VXYXRlci9kYXRhL2RldGFpbF9ncmFwaC5hc3B4P0lEPVNXRURJVENPXHUwMDI2TVRZUEU9RElTQ0hSRyIsICJsb2NhdGlvbi5sYXRpdHVkZSI6IDQwLjIxMTA4MywgImxvY2F0aW9uLmxvbmdpdHVkZSI6IC0xMDUuMjUwOTI3LCAibG9jYXRpb24ubmVlZHNfcmVjb2RpbmciOiBmYWxzZSwgInN0YWdlIjogIi0wLjA2IiwgInN0YXRpb25fbmFtZSI6ICJTV0VERSBESVRDSCIsICJzdGF0aW9uX3N0YXR1cyI6ICJBY3RpdmUiLCAic3RhdGlvbl90eXBlIjogIkRpdmVyc2lvbiIsICJ1c2dzX3N0YXRpb25faWQiOiBudWxsLCAidmFyaWFibGUiOiAiRElTQ0hSRyIsICJ3ZCI6ICI1In0sICJ0eXBlIjogIkZlYXR1cmUifSwgeyJiYm94IjogWy0xMDUuMTg5MTMyLCA0MC4xODc1MjQsIC0xMDUuMTg5MTMyLCA0MC4xODc1MjRdLCAiZ2VvbWV0cnkiOiB7ImNvb3JkaW5hdGVzIjogWy0xMDUuMTg5MTMyLCA0MC4xODc1MjRdLCAidHlwZSI6ICJQb2ludCJ9LCAiaWQiOiAiNDEiLCAicHJvcGVydGllcyI6IHsiYW1vdW50IjogIjAuMDAiLCAiY291bnR5IjogIkJPVUxERVIiLCAiZGF0YV9zb3VyY2UiOiAiQ29vcGVyYXRpdmUgUHJvZ3JhbSBvZiBDRFdSLCBOQ1dDRCBcdTAwMjYgU1ZMSFdDRCIsICJkYXRlX3RpbWUiOiAiMjAyMC0wMy0zMVQxNTowMDowMC4wMDAiLCAiZGl2IjogIjEiLCAiZHdyX2FiYnJldiI6ICJSVU5ZT05DTyIsICJmbGFnIjogbnVsbCwgImh0dHBfbGlua2FnZS51cmwiOiAiaHR0cHM6Ly9kd3Iuc3RhdGUuY28udXMvU3VyZmFjZVdhdGVyL2RhdGEvZGV0YWlsX2dyYXBoLmFzcHg/SUQ9UlVOWU9OQ09cdTAwMjZNVFlQRT1ESVNDSFJHIiwgImxvY2F0aW9uLmxhdGl0dWRlIjogNDAuMTg3NTI0LCAibG9jYXRpb24ubG9uZ2l0dWRlIjogLTEwNS4xODkxMzIsICJsb2NhdGlvbi5uZWVkc19yZWNvZGluZyI6IGZhbHNlLCAic3RhZ2UiOiAiNTAuNzgiLCAic3RhdGlvbl9uYW1lIjogIlJVTllPTiBESVRDSCIsICJzdGF0aW9uX3N0YXR1cyI6ICJBY3RpdmUiLCAic3RhdGlvbl90eXBlIjogIkRpdmVyc2lvbiIsICJ1c2dzX3N0YXRpb25faWQiOiBudWxsLCAidmFyaWFibGUiOiAiRElTQ0hSRyIsICJ3ZCI6ICI1In0sICJ0eXBlIjogIkZlYXR1cmUifSwgeyJiYm94IjogWy0xMDUuMTk2Nzc1LCA0MC4xODE4OCwgLTEwNS4xOTY3NzUsIDQwLjE4MTg4XSwgImdlb21ldHJ5IjogeyJjb29yZGluYXRlcyI6IFstMTA1LjE5Njc3NSwgNDAuMTgxODhdLCAidHlwZSI6ICJQb2ludCJ9LCAiaWQiOiAiNDIiLCAicHJvcGVydGllcyI6IHsiYW1vdW50IjogIjAuMDAiLCAiY291bnR5IjogIkJPVUxERVIiLCAiZGF0YV9zb3VyY2UiOiAiQ29vcGVyYXRpdmUgUHJvZ3JhbSBvZiBDRFdSLCBOQ1dDRCBcdTAwMjYgU1ZMSFdDRCIsICJkYXRlX3RpbWUiOiAiMjAyMC0wMy0zMVQxNDo0NTowMC4wMDAiLCAiZGl2IjogIjEiLCAiZHdyX2FiYnJldiI6ICJEQVZET1dDTyIsICJmbGFnIjogbnVsbCwgImh0dHBfbGlua2FnZS51cmwiOiAiaHR0cHM6Ly9kd3Iuc3RhdGUuY28udXMvU3VyZmFjZVdhdGVyL2RhdGEvZGV0YWlsX2dyYXBoLmFzcHg/SUQ9REFWRE9XQ09cdTAwMjZNVFlQRT1ESVNDSFJHIiwgImxvY2F0aW9uLmxhdGl0dWRlIjogNDAuMTgxODgsICJsb2NhdGlvbi5sb25naXR1ZGUiOiAtMTA1LjE5Njc3NSwgImxvY2F0aW9uLm5lZWRzX3JlY29kaW5nIjogZmFsc2UsICJzdGFnZSI6IG51bGwsICJzdGF0aW9uX25hbWUiOiAiREFWSVMgQU5EIERPV05JTkcgRElUQ0giLCAic3RhdGlvbl9zdGF0dXMiOiAiQWN0aXZlIiwgInN0YXRpb25fdHlwZSI6ICJEaXZlcnNpb24iLCAidXNnc19zdGF0aW9uX2lkIjogbnVsbCwgInZhcmlhYmxlIjogIkRJU0NIUkciLCAid2QiOiAiNSJ9LCAidHlwZSI6ICJGZWF0dXJlIn0sIHsiYmJveCI6IFstMTA1LjMyNjI1LCA0MC4wMTg2NjcsIC0xMDUuMzI2MjUsIDQwLjAxODY2N10sICJnZW9tZXRyeSI6IHsiY29vcmRpbmF0ZXMiOiBbLTEwNS4zMjYyNSwgNDAuMDE4NjY3XSwgInR5cGUiOiAiUG9pbnQifSwgImlkIjogIjQzIiwgInByb3BlcnRpZXMiOiB7ImFtb3VudCI6ICIwLjc0IiwgImNvdW50eSI6ICJCT1VMREVSIiwgImRhdGFfc291cmNlIjogIlUuUy4gR2VvbG9naWNhbCBTdXJ2ZXkiLCAiZGF0ZV90aW1lIjogIjIwMTktMTAtMDJUMTQ6NTA6MDAuMDAwIiwgImRpdiI6ICIxIiwgImR3cl9hYmJyZXYiOiAiRk9VT1JPQ08iLCAiZmxhZyI6IG51bGwsICJodHRwX2xpbmthZ2UudXJsIjogImh0dHBzOi8vd2F0ZXJkYXRhLnVzZ3MuZ292L253aXMvdXY/MDY3Mjc1MDAiLCAibG9jYXRpb24ubGF0aXR1ZGUiOiA0MC4wMTg2NjcsICJsb2NhdGlvbi5sb25naXR1ZGUiOiAtMTA1LjMyNjI1LCAibG9jYXRpb24ubmVlZHNfcmVjb2RpbmciOiBmYWxzZSwgInN0YWdlIjogbnVsbCwgInN0YXRpb25fbmFtZSI6ICJGT1VSTUlMRSBDUkVFSyBBVCBPUk9ERUxMLCBDTyIsICJzdGF0aW9uX3N0YXR1cyI6ICJBY3RpdmUiLCAic3RhdGlvbl90eXBlIjogIlN0cmVhbSIsICJ1c2dzX3N0YXRpb25faWQiOiAiMDY3Mjc1MDAiLCAidmFyaWFibGUiOiAiRElTQ0hSRyIsICJ3ZCI6ICI2In0sICJ0eXBlIjogIkZlYXR1cmUifSwgeyJiYm94IjogWy0xMDUuMjA5MjgyLCA0MC4xODg1NzksIC0xMDUuMjA5MjgyLCA0MC4xODg1NzldLCAiZ2VvbWV0cnkiOiB7ImNvb3JkaW5hdGVzIjogWy0xMDUuMjA5MjgyLCA0MC4xODg1NzldLCAidHlwZSI6ICJQb2ludCJ9LCAiaWQiOiAiNDQiLCAicHJvcGVydGllcyI6IHsiYW1vdW50IjogIjAuMDAiLCAiY291bnR5IjogIkJPVUxERVIiLCAiZGF0YV9zb3VyY2UiOiAiQ29vcGVyYXRpdmUgUHJvZ3JhbSBvZiBDRFdSLCBOQ1dDRCBcdTAwMjYgU1ZMSFdDRCIsICJkYXRlX3RpbWUiOiAiMjAyMC0wMy0zMVQxNDo0NTowMC4wMDAiLCAiZGl2IjogIjEiLCAiZHdyX2FiYnJldiI6ICJKQU1ESVRDTyIsICJmbGFnIjogbnVsbCwgImh0dHBfbGlua2FnZS51cmwiOiAiaHR0cHM6Ly9kd3Iuc3RhdGUuY28udXMvU3VyZmFjZVdhdGVyL2RhdGEvZGV0YWlsX2dyYXBoLmFzcHg/SUQ9SkFNRElUQ09cdTAwMjZNVFlQRT1ESVNDSFJHIiwgImxvY2F0aW9uLmxhdGl0dWRlIjogNDAuMTg4NTc5LCAibG9jYXRpb24ubG9uZ2l0dWRlIjogLTEwNS4yMDkyODIsICJsb2NhdGlvbi5uZWVkc19yZWNvZGluZyI6IGZhbHNlLCAic3RhZ2UiOiAiMC4wMCIsICJzdGF0aW9uX25hbWUiOiAiSkFNRVMgRElUQ0giLCAic3RhdGlvbl9zdGF0dXMiOiAiQWN0aXZlIiwgInN0YXRpb25fdHlwZSI6ICJEaXZlcnNpb24iLCAidXNnc19zdGF0aW9uX2lkIjogbnVsbCwgInZhcmlhYmxlIjogIkRJU0NIUkciLCAid2QiOiAiNSJ9LCAidHlwZSI6ICJGZWF0dXJlIn0sIHsiYmJveCI6IFstMTA1LjE5MzA0OCwgNDAuMDUzMDM1LCAtMTA1LjE5MzA0OCwgNDAuMDUzMDM1XSwgImdlb21ldHJ5IjogeyJjb29yZGluYXRlcyI6IFstMTA1LjE5MzA0OCwgNDAuMDUzMDM1XSwgInR5cGUiOiAiUG9pbnQifSwgImlkIjogIjQ1IiwgInByb3BlcnRpZXMiOiB7ImFtb3VudCI6ICIxMC41OSIsICJjb3VudHkiOiAiQk9VTERFUiIsICJkYXRhX3NvdXJjZSI6ICJOb3J0aGVybiBDb2xvcmFkbyBXYXRlciBDb25zZXJ2YW5jeSBEaXN0cmljdCIsICJkYXRlX3RpbWUiOiAiMjAyMC0wMy0zMVQxNTowMDowMC4wMDAiLCAiZGl2IjogIjEiLCAiZHdyX2FiYnJldiI6ICJCQ1NDQkNDTyIsICJmbGFnIjogbnVsbCwgImh0dHBfbGlua2FnZS51cmwiOiAiaHR0cDovL3d3dy5ub3J0aGVybndhdGVyLm9yZy9XYXRlclByb2plY3RzL0Vhc3RTbG9wZVdhdGVyRGF0YS5hc3B4IiwgImxvY2F0aW9uLmxhdGl0dWRlIjogNDAuMDUzMDM1LCAibG9jYXRpb24ubG9uZ2l0dWRlIjogLTEwNS4xOTMwNDgsICJsb2NhdGlvbi5uZWVkc19yZWNvZGluZyI6IGZhbHNlLCAic3RhZ2UiOiAiMC40NCIsICJzdGF0aW9uX25hbWUiOiAiQk9VTERFUiBDUkVFSyBTVVBQTFkgQ0FOQUwgVE8gQk9VTERFUiBDUkVFSyBORUFSIEJPVUxERVIiLCAic3RhdGlvbl9zdGF0dXMiOiAiQWN0aXZlIiwgInN0YXRpb25fdHlwZSI6ICJEaXZlcnNpb24iLCAidXNnc19zdGF0aW9uX2lkIjogIkVTMTkxNyIsICJ2YXJpYWJsZSI6ICJESVNDSFJHIiwgIndkIjogIjYifSwgInR5cGUiOiAiRmVhdHVyZSJ9LCB7ImJib3giOiBbLTEwNS4xNzgxNDUsIDQwLjE3NzQyMywgLTEwNS4xNzgxNDUsIDQwLjE3NzQyM10sICJnZW9tZXRyeSI6IHsiY29vcmRpbmF0ZXMiOiBbLTEwNS4xNzgxNDUsIDQwLjE3NzQyM10sICJ0eXBlIjogIlBvaW50In0sICJpZCI6ICI0NiIsICJwcm9wZXJ0aWVzIjogeyJhbW91bnQiOiAiMi4xNCIsICJjb3VudHkiOiAiQk9VTERFUiIsICJkYXRhX3NvdXJjZSI6ICJDby4gRGl2aXNpb24gb2YgV2F0ZXIgUmVzb3VyY2VzIiwgImRhdGVfdGltZSI6ICIyMDIwLTAzLTMxVDE0OjQ1OjAwLjAwMCIsICJkaXYiOiAiMSIsICJkd3JfYWJicmV2IjogIlNWQ0hHSUNPIiwgImZsYWciOiBudWxsLCAiaHR0cF9saW5rYWdlLnVybCI6ICJodHRwczovL2R3ci5zdGF0ZS5jby51cy9TdXJmYWNlV2F0ZXIvZGF0YS9kZXRhaWxfZ3JhcGguYXNweD9JRD1TVkNIR0lDT1x1MDAyNk1UWVBFPURJU0NIUkciLCAibG9jYXRpb24ubGF0aXR1ZGUiOiA0MC4xNzc0MjMsICJsb2NhdGlvbi5sb25naXR1ZGUiOiAtMTA1LjE3ODE0NSwgImxvY2F0aW9uLm5lZWRzX3JlY29kaW5nIjogZmFsc2UsICJzdGFnZSI6ICIxLjQ5IiwgInN0YXRpb25fbmFtZSI6ICJTQUlOVCBWUkFJTiBDUkVFSyBBVCBIWUdJRU5FLCBDTyIsICJzdGF0aW9uX3N0YXR1cyI6ICJBY3RpdmUiLCAic3RhdGlvbl90eXBlIjogIlN0cmVhbSIsICJ1c2dzX3N0YXRpb25faWQiOiBudWxsLCAidmFyaWFibGUiOiAiRElTQ0hSRyIsICJ3ZCI6ICI1In0sICJ0eXBlIjogIkZlYXR1cmUifSwgeyJiYm94IjogWy0xMDUuMTc0OTU3LCA0MC4yNTgzNjcsIC0xMDUuMTc0OTU3LCA0MC4yNTgzNjddLCAiZ2VvbWV0cnkiOiB7ImNvb3JkaW5hdGVzIjogWy0xMDUuMTc0OTU3LCA0MC4yNTgzNjddLCAidHlwZSI6ICJQb2ludCJ9LCAiaWQiOiAiNDciLCAicHJvcGVydGllcyI6IHsiYW1vdW50IjogIjAuMDAiLCAiY291bnR5IjogIkJPVUxERVIiLCAiZGF0YV9zb3VyY2UiOiAiQ28uIERpdmlzaW9uIG9mIFdhdGVyIFJlc291cmNlcyIsICJkYXRlX3RpbWUiOiAiMjAyMC0wMy0zMVQxNTozMDowMC4wMDAiLCAiZGl2IjogIjEiLCAiZHdyX2FiYnJldiI6ICJCT1VMQVJDTyIsICJmbGFnIjogbnVsbCwgImh0dHBfbGlua2FnZS51cmwiOiAiaHR0cHM6Ly9kd3Iuc3RhdGUuY28udXMvU3VyZmFjZVdhdGVyL2RhdGEvZGV0YWlsX2dyYXBoLmFzcHg/SUQ9Qk9VTEFSQ09cdTAwMjZNVFlQRT1ESVNDSFJHIiwgImxvY2F0aW9uLmxhdGl0dWRlIjogNDAuMjU4MzY3LCAibG9jYXRpb24ubG9uZ2l0dWRlIjogLTEwNS4xNzQ5NTcsICJsb2NhdGlvbi5uZWVkc19yZWNvZGluZyI6IGZhbHNlLCAic3RhZ2UiOiAiLTAuMTMiLCAic3RhdGlvbl9uYW1lIjogIkJPVUxERVItTEFSSU1FUiBESVRDSCBORUFSIEJFUlRIT1VEIiwgInN0YXRpb25fc3RhdHVzIjogIkFjdGl2ZSIsICJzdGF0aW9uX3R5cGUiOiAiRGl2ZXJzaW9uIiwgInVzZ3Nfc3RhdGlvbl9pZCI6IG51bGwsICJ2YXJpYWJsZSI6ICJESVNDSFJHIiwgIndkIjogIjQifSwgInR5cGUiOiAiRmVhdHVyZSJ9LCB7ImJib3giOiBbLTEwNS4wNzI1MDIsIDQwLjA4NzU4MywgLTEwNS4wNzI1MDIsIDQwLjA4NzU4M10sICJnZW9tZXRyeSI6IHsiY29vcmRpbmF0ZXMiOiBbLTEwNS4wNzI1MDIsIDQwLjA4NzU4M10sICJ0eXBlIjogIlBvaW50In0sICJpZCI6ICI0OCIsICJwcm9wZXJ0aWVzIjogeyJhbW91bnQiOiAiMC4wNSIsICJjb3VudHkiOiAiQk9VTERFUiIsICJkYXRhX3NvdXJjZSI6ICJDby4gRGl2aXNpb24gb2YgV2F0ZXIgUmVzb3VyY2VzIiwgImRhdGVfdGltZSI6ICIyMDIwLTAzLTMxVDE0OjQ1OjAwLjAwMCIsICJkaXYiOiAiMSIsICJkd3JfYWJicmV2IjogIlBOTU9VVENPIiwgImZsYWciOiBudWxsLCAiaHR0cF9saW5rYWdlLnVybCI6ICJodHRwczovL2R3ci5zdGF0ZS5jby51cy9TdXJmYWNlV2F0ZXIvZGF0YS9kZXRhaWxfZ3JhcGguYXNweD9JRD1QTk1PVVRDT1x1MDAyNk1UWVBFPURJU0NIUkciLCAibG9jYXRpb24ubGF0aXR1ZGUiOiA0MC4wODc1ODMsICJsb2NhdGlvbi5sb25naXR1ZGUiOiAtMTA1LjA3MjUwMiwgImxvY2F0aW9uLm5lZWRzX3JlY29kaW5nIjogZmFsc2UsICJzdGFnZSI6IG51bGwsICJzdGF0aW9uX25hbWUiOiAiUEFOQU1BIFJFU0VSVk9JUiBPVVRMRVQiLCAic3RhdGlvbl9zdGF0dXMiOiAiQWN0aXZlIiwgInN0YXRpb25fdHlwZSI6ICJTdHJlYW0iLCAidXNnc19zdGF0aW9uX2lkIjogbnVsbCwgInZhcmlhYmxlIjogIkRJU0NIUkciLCAid2QiOiAiNiJ9LCAidHlwZSI6ICJGZWF0dXJlIn0sIHsiYmJveCI6IFstMTA1LjI1MTgyNiwgNDAuMjEyNTA1LCAtMTA1LjI1MTgyNiwgNDAuMjEyNTA1XSwgImdlb21ldHJ5IjogeyJjb29yZGluYXRlcyI6IFstMTA1LjI1MTgyNiwgNDAuMjEyNTA1XSwgInR5cGUiOiAiUG9pbnQifSwgImlkIjogIjQ5IiwgInByb3BlcnRpZXMiOiB7ImFtb3VudCI6ICIwLjI3IiwgImNvdW50eSI6ICJCT1VMREVSIiwgImRhdGFfc291cmNlIjogIkNvb3BlcmF0aXZlIFByb2dyYW0gb2YgQ0RXUiwgTkNXQ0QgXHUwMDI2IFNWTEhXQ0QiLCAiZGF0ZV90aW1lIjogIjIwMjAtMDMtMzFUMTU6MDA6MDAuMDAwIiwgImRpdiI6ICIxIiwgImR3cl9hYmJyZXYiOiAiUEFMRElUQ08iLCAiZmxhZyI6IG51bGwsICJodHRwX2xpbmthZ2UudXJsIjogImh0dHBzOi8vZHdyLnN0YXRlLmNvLnVzL1N1cmZhY2VXYXRlci9kYXRhL2RldGFpbF9ncmFwaC5hc3B4P0lEPVBBTERJVENPXHUwMDI2TVRZUEU9RElTQ0hSRyIsICJsb2NhdGlvbi5sYXRpdHVkZSI6IDQwLjIxMjUwNSwgImxvY2F0aW9uLmxvbmdpdHVkZSI6IC0xMDUuMjUxODI2LCAibG9jYXRpb24ubmVlZHNfcmVjb2RpbmciOiBmYWxzZSwgInN0YWdlIjogIjAuMDUiLCAic3RhdGlvbl9uYW1lIjogIlBBTE1FUlRPTiBESVRDSCIsICJzdGF0aW9uX3N0YXR1cyI6ICJBY3RpdmUiLCAic3RhdGlvbl90eXBlIjogIkRpdmVyc2lvbiIsICJ1c2dzX3N0YXRpb25faWQiOiBudWxsLCAidmFyaWFibGUiOiAiRElTQ0hSRyIsICJ3ZCI6ICI1In0sICJ0eXBlIjogIkZlYXR1cmUifSwgeyJiYm94IjogWy0xMDUuMjU5Nzk1LCA0MC4yMTkwNDYsIC0xMDUuMjU5Nzk1LCA0MC4yMTkwNDZdLCAiZ2VvbWV0cnkiOiB7ImNvb3JkaW5hdGVzIjogWy0xMDUuMjU5Nzk1LCA0MC4yMTkwNDZdLCAidHlwZSI6ICJQb2ludCJ9LCAiaWQiOiAiNTAiLCAicHJvcGVydGllcyI6IHsiYW1vdW50IjogIjAuMDAiLCAiY291bnR5IjogIkJPVUxERVIiLCAiZGF0YV9zb3VyY2UiOiAiQ29vcGVyYXRpdmUgUHJvZ3JhbSBvZiBDRFdSLCBOQ1dDRCBcdTAwMjYgU1ZMSFdDRCIsICJkYXRlX3RpbWUiOiAiMjAyMC0wMy0zMVQxNDo0NTowMC4wMDAiLCAiZGl2IjogIjEiLCAiZHdyX2FiYnJldiI6ICJTVVBESVRDTyIsICJmbGFnIjogbnVsbCwgImh0dHBfbGlua2FnZS51cmwiOiAiaHR0cHM6Ly9kd3Iuc3RhdGUuY28udXMvU3VyZmFjZVdhdGVyL2RhdGEvZGV0YWlsX2dyYXBoLmFzcHg/SUQ9U1VQRElUQ09cdTAwMjZNVFlQRT1ESVNDSFJHIiwgImxvY2F0aW9uLmxhdGl0dWRlIjogNDAuMjE5MDQ2LCAibG9jYXRpb24ubG9uZ2l0dWRlIjogLTEwNS4yNTk3OTUsICJsb2NhdGlvbi5uZWVkc19yZWNvZGluZyI6IGZhbHNlLCAic3RhZ2UiOiAiMC4wMCIsICJzdGF0aW9uX25hbWUiOiAiU1VQUExZIERJVENIIiwgInN0YXRpb25fc3RhdHVzIjogIkFjdGl2ZSIsICJzdGF0aW9uX3R5cGUiOiAiRGl2ZXJzaW9uIiwgInVzZ3Nfc3RhdGlvbl9pZCI6IG51bGwsICJ2YXJpYWJsZSI6ICJESVNDSFJHIiwgIndkIjogIjUifSwgInR5cGUiOiAiRmVhdHVyZSJ9LCB7ImJib3giOiBbLTEwNS4zMDQ5OSwgMzkuOTMxNTk3LCAtMTA1LjMwNDk5LCAzOS45MzE1OTddLCAiZ2VvbWV0cnkiOiB7ImNvb3JkaW5hdGVzIjogWy0xMDUuMzA0OTksIDM5LjkzMTU5N10sICJ0eXBlIjogIlBvaW50In0sICJpZCI6ICI1MSIsICJwcm9wZXJ0aWVzIjogeyJhbW91bnQiOiAiMTcuODAiLCAiY291bnR5IjogIkJPVUxERVIiLCAiZGF0YV9zb3VyY2UiOiAiQ28uIERpdmlzaW9uIG9mIFdhdGVyIFJlc291cmNlcyIsICJkYXRlX3RpbWUiOiAiMjAyMC0wMy0zMVQxNToxNTowMC4wMDAiLCAiZGl2IjogIjEiLCAiZHdyX2FiYnJldiI6ICJCT0NFTFNDTyIsICJmbGFnIjogbnVsbCwgImh0dHBfbGlua2FnZS51cmwiOiAiaHR0cHM6Ly9kd3Iuc3RhdGUuY28udXMvU3VyZmFjZVdhdGVyL2RhdGEvZGV0YWlsX2dyYXBoLmFzcHg/SUQ9Qk9DRUxTQ09cdTAwMjZNVFlQRT1ESVNDSFJHIiwgImxvY2F0aW9uLmxhdGl0dWRlIjogMzkuOTMxNTk3LCAibG9jYXRpb24ubG9uZ2l0dWRlIjogLTEwNS4zMDQ5OSwgImxvY2F0aW9uLm5lZWRzX3JlY29kaW5nIjogZmFsc2UsICJzdGFnZSI6ICIyLjI0IiwgInN0YXRpb25fbmFtZSI6ICJTT1VUSCBCT1VMREVSIENSRUVLIE5FQVIgRUxET1JBRE8gU1BSSU5HUywgQ08uIiwgInN0YXRpb25fc3RhdHVzIjogIkFjdGl2ZSIsICJzdGF0aW9uX3R5cGUiOiAiU3RyZWFtIiwgInVzZ3Nfc3RhdGlvbl9pZCI6IG51bGwsICJ2YXJpYWJsZSI6ICJESVNDSFJHIiwgIndkIjogIjYifSwgInR5cGUiOiAiRmVhdHVyZSJ9LCB7ImJib3giOiBbLTEwNS4xODkxOTEsIDQwLjE4NzU3OCwgLTEwNS4xODkxOTEsIDQwLjE4NzU3OF0sICJnZW9tZXRyeSI6IHsiY29vcmRpbmF0ZXMiOiBbLTEwNS4xODkxOTEsIDQwLjE4NzU3OF0sICJ0eXBlIjogIlBvaW50In0sICJpZCI6ICI1MiIsICJwcm9wZXJ0aWVzIjogeyJhbW91bnQiOiAiMjgxOS42OCIsICJjb3VudHkiOiAiQk9VTERFUiIsICJkYXRhX3NvdXJjZSI6ICJDb29wZXJhdGl2ZSBQcm9ncmFtIG9mIENEV1IsIE5DV0NEIFx1MDAyNiBTVkxIV0NEIiwgImRhdGVfdGltZSI6ICIyMDIwLTAzLTMxVDE1OjAwOjAwLjAwMCIsICJkaXYiOiAiMSIsICJkd3JfYWJicmV2IjogIkRFTlRBWUNPIiwgImZsYWciOiBudWxsLCAiaHR0cF9saW5rYWdlLnVybCI6ICJodHRwczovL2R3ci5zdGF0ZS5jby51cy9TdXJmYWNlV2F0ZXIvZGF0YS9kZXRhaWxfZ3JhcGguYXNweD9JRD1ERU5UQVlDT1x1MDAyNk1UWVBFPURJU0NIUkciLCAibG9jYXRpb24ubGF0aXR1ZGUiOiA0MC4xODc1NzgsICJsb2NhdGlvbi5sb25naXR1ZGUiOiAtMTA1LjE4OTE5MSwgImxvY2F0aW9uLm5lZWRzX3JlY29kaW5nIjogZmFsc2UsICJzdGFnZSI6ICI2Mi4zMSIsICJzdGF0aW9uX25hbWUiOiAiREVOSU8gVEFZTE9SIERJVENIIiwgInN0YXRpb25fc3RhdHVzIjogIkFjdGl2ZSIsICJzdGF0aW9uX3R5cGUiOiAiRGl2ZXJzaW9uIiwgInVzZ3Nfc3RhdGlvbl9pZCI6IG51bGwsICJ2YXJpYWJsZSI6ICJESVNDSFJHIiwgIndkIjogIjUifSwgInR5cGUiOiAiRmVhdHVyZSJ9LCB7ImJib3giOiBbLTEwNS4zNjQ5MTcsIDQwLjA0MjAyOCwgLTEwNS4zNjQ5MTcsIDQwLjA0MjAyOF0sICJnZW9tZXRyeSI6IHsiY29vcmRpbmF0ZXMiOiBbLTEwNS4zNjQ5MTcsIDQwLjA0MjAyOF0sICJ0eXBlIjogIlBvaW50In0sICJpZCI6ICI1MyIsICJwcm9wZXJ0aWVzIjogeyJhbW91bnQiOiBudWxsLCAiY291bnR5IjogIkJPVUxERVIiLCAiZGF0YV9zb3VyY2UiOiAiVS5TLiBHZW9sb2dpY2FsIFN1cnZleSIsICJkYXRlX3RpbWUiOiAiMTk5OS0wOS0zMFQwMDowMDowMC4wMDAiLCAiZGl2IjogIjEiLCAiZHdyX2FiYnJldiI6ICJGUk1MTVJDTyIsICJmbGFnIjogbnVsbCwgImh0dHBfbGlua2FnZS51cmwiOiAiaHR0cHM6Ly93YXRlcmRhdGEudXNncy5nb3Yvbndpcy91dj8wNjcyNzQxMCIsICJsb2NhdGlvbi5sYXRpdHVkZSI6IDQwLjA0MjAyOCwgImxvY2F0aW9uLmxvbmdpdHVkZSI6IC0xMDUuMzY0OTE3LCAibG9jYXRpb24ubmVlZHNfcmVjb2RpbmciOiBmYWxzZSwgInN0YWdlIjogbnVsbCwgInN0YXRpb25fbmFtZSI6ICJGT1VSTUlMRSBDUkVFSyBBVCBMT0dBTiBNSUxMIFJPQUQgTkVBUiBDUklTTUFOLCBDTyIsICJzdGF0aW9uX3N0YXR1cyI6ICJBY3RpdmUiLCAic3RhdGlvbl90eXBlIjogIlN0cmVhbSIsICJ1c2dzX3N0YXRpb25faWQiOiAiMDY3Mjc0MTAiLCAidmFyaWFibGUiOiAiRElTQ0hSRyIsICJ3ZCI6ICI2In0sICJ0eXBlIjogIkZlYXR1cmUifSwgeyJiYm94IjogWy0xMDUuMTc4NTY3LCA0MC4xNzcwOCwgLTEwNS4xNzg1NjcsIDQwLjE3NzA4XSwgImdlb21ldHJ5IjogeyJjb29yZGluYXRlcyI6IFstMTA1LjE3ODU2NywgNDAuMTc3MDhdLCAidHlwZSI6ICJQb2ludCJ9LCAiaWQiOiAiNTQiLCAicHJvcGVydGllcyI6IHsiYW1vdW50IjogIjEuMjkiLCAiY291bnR5IjogIkJPVUxERVIiLCAiZGF0YV9zb3VyY2UiOiAiQ29vcGVyYXRpdmUgU0RSIFByb2dyYW0gb2YgQ0RXUiBcdTAwMjYgTkNXQ0QiLCAiZGF0ZV90aW1lIjogIjIwMjAtMDMtMzFUMTU6MDA6MDAuMDAwIiwgImRpdiI6ICIxIiwgImR3cl9hYmJyZXYiOiAiUENLUEVMQ08iLCAiZmxhZyI6IG51bGwsICJodHRwX2xpbmthZ2UudXJsIjogImh0dHBzOi8vZHdyLnN0YXRlLmNvLnVzL1N1cmZhY2VXYXRlci9kYXRhL2RldGFpbF9ncmFwaC5hc3B4P0lEPVBDS1BFTENPXHUwMDI2TVRZUEU9RElTQ0hSRyIsICJsb2NhdGlvbi5sYXRpdHVkZSI6IDQwLjE3NzA4LCAibG9jYXRpb24ubG9uZ2l0dWRlIjogLTEwNS4xNzg1NjcsICJsb2NhdGlvbi5uZWVkc19yZWNvZGluZyI6IGZhbHNlLCAic3RhZ2UiOiAiMC4xNiIsICJzdGF0aW9uX25hbWUiOiAiUEVDSyBQRUxMQSBDTE9WRVIgRElUQ0giLCAic3RhdGlvbl9zdGF0dXMiOiAiQWN0aXZlIiwgInN0YXRpb25fdHlwZSI6ICJEaXZlcnNpb24iLCAidXNnc19zdGF0aW9uX2lkIjogbnVsbCwgInZhcmlhYmxlIjogIkRJU0NIUkciLCAid2QiOiAiNSJ9LCAidHlwZSI6ICJGZWF0dXJlIn0sIHsiYmJveCI6IFstMTA1LjM1NzMwOCwgMzkuOTQ3NzA0LCAtMTA1LjM1NzMwOCwgMzkuOTQ3NzA0XSwgImdlb21ldHJ5IjogeyJjb29yZGluYXRlcyI6IFstMTA1LjM1NzMwOCwgMzkuOTQ3NzA0XSwgInR5cGUiOiAiUG9pbnQifSwgImlkIjogIjU1IiwgInByb3BlcnRpZXMiOiB7ImFtb3VudCI6ICIxMTM5OC4wMCIsICJjb3VudHkiOiAiQk9VTERFUiIsICJkYXRhX3NvdXJjZSI6ICJDby4gRGl2aXNpb24gb2YgV2F0ZXIgUmVzb3VyY2VzIiwgImRhdGVfdGltZSI6ICIyMDIwLTAzLTMxVDE1OjMwOjAwLjAwMCIsICJkaXYiOiAiMSIsICJkd3JfYWJicmV2IjogIkdST1NSRUNPIiwgImZsYWciOiBudWxsLCAiaHR0cF9saW5rYWdlLnVybCI6ICJodHRwczovL2R3ci5zdGF0ZS5jby51cy9TdXJmYWNlV2F0ZXIvZGF0YS9kZXRhaWxfZ3JhcGguYXNweD9JRD1HUk9TUkVDT1x1MDAyNk1UWVBFPVNUT1JBR0UiLCAibG9jYXRpb24ubGF0aXR1ZGUiOiAzOS45NDc3MDQsICJsb2NhdGlvbi5sb25naXR1ZGUiOiAtMTA1LjM1NzMwOCwgImxvY2F0aW9uLm5lZWRzX3JlY29kaW5nIjogZmFsc2UsICJzdGFnZSI6ICI3MTc1LjgwIiwgInN0YXRpb25fbmFtZSI6ICJHUk9TUyBSRVNFUlZPSVIgIiwgInN0YXRpb25fc3RhdHVzIjogIkFjdGl2ZSIsICJzdGF0aW9uX3R5cGUiOiAiUmVzZXJ2b2lyIiwgInVzZ3Nfc3RhdGlvbl9pZCI6IG51bGwsICJ2YXJpYWJsZSI6ICJTVE9SQUdFIiwgIndkIjogIjYifSwgInR5cGUiOiAiRmVhdHVyZSJ9XSwgInR5cGUiOiAiRmVhdHVyZUNvbGxlY3Rpb24ifSk7CiAgICAgICAgCjwvc2NyaXB0Pg==" style="position:absolute;width:100%;height:100%;left:0;top:0;border:none !important;" allowfullscreen webkitallowfullscreen mozallowfullscreen></iframe></div></div>





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



<div style="width:100%;"><div style="position:relative;width:100%;height:0;padding-bottom:60%;"><iframe src="data:text/html;charset=utf-8;base64,PCFET0NUWVBFIGh0bWw+CjxoZWFkPiAgICAKICAgIDxtZXRhIGh0dHAtZXF1aXY9ImNvbnRlbnQtdHlwZSIgY29udGVudD0idGV4dC9odG1sOyBjaGFyc2V0PVVURi04IiAvPgogICAgCiAgICAgICAgPHNjcmlwdD4KICAgICAgICAgICAgTF9OT19UT1VDSCA9IGZhbHNlOwogICAgICAgICAgICBMX0RJU0FCTEVfM0QgPSBmYWxzZTsKICAgICAgICA8L3NjcmlwdD4KICAgIAogICAgPHNjcmlwdCBzcmM9Imh0dHBzOi8vY2RuLmpzZGVsaXZyLm5ldC9ucG0vbGVhZmxldEAxLjUuMS9kaXN0L2xlYWZsZXQuanMiPjwvc2NyaXB0PgogICAgPHNjcmlwdCBzcmM9Imh0dHBzOi8vY29kZS5qcXVlcnkuY29tL2pxdWVyeS0xLjEyLjQubWluLmpzIj48L3NjcmlwdD4KICAgIDxzY3JpcHQgc3JjPSJodHRwczovL21heGNkbi5ib290c3RyYXBjZG4uY29tL2Jvb3RzdHJhcC8zLjIuMC9qcy9ib290c3RyYXAubWluLmpzIj48L3NjcmlwdD4KICAgIDxzY3JpcHQgc3JjPSJodHRwczovL2NkbmpzLmNsb3VkZmxhcmUuY29tL2FqYXgvbGlicy9MZWFmbGV0LmF3ZXNvbWUtbWFya2Vycy8yLjAuMi9sZWFmbGV0LmF3ZXNvbWUtbWFya2Vycy5qcyI+PC9zY3JpcHQ+CiAgICA8bGluayByZWw9InN0eWxlc2hlZXQiIGhyZWY9Imh0dHBzOi8vY2RuLmpzZGVsaXZyLm5ldC9ucG0vbGVhZmxldEAxLjUuMS9kaXN0L2xlYWZsZXQuY3NzIi8+CiAgICA8bGluayByZWw9InN0eWxlc2hlZXQiIGhyZWY9Imh0dHBzOi8vbWF4Y2RuLmJvb3RzdHJhcGNkbi5jb20vYm9vdHN0cmFwLzMuMi4wL2Nzcy9ib290c3RyYXAubWluLmNzcyIvPgogICAgPGxpbmsgcmVsPSJzdHlsZXNoZWV0IiBocmVmPSJodHRwczovL21heGNkbi5ib290c3RyYXBjZG4uY29tL2Jvb3RzdHJhcC8zLjIuMC9jc3MvYm9vdHN0cmFwLXRoZW1lLm1pbi5jc3MiLz4KICAgIDxsaW5rIHJlbD0ic3R5bGVzaGVldCIgaHJlZj0iaHR0cHM6Ly9tYXhjZG4uYm9vdHN0cmFwY2RuLmNvbS9mb250LWF3ZXNvbWUvNC42LjMvY3NzL2ZvbnQtYXdlc29tZS5taW4uY3NzIi8+CiAgICA8bGluayByZWw9InN0eWxlc2hlZXQiIGhyZWY9Imh0dHBzOi8vY2RuanMuY2xvdWRmbGFyZS5jb20vYWpheC9saWJzL0xlYWZsZXQuYXdlc29tZS1tYXJrZXJzLzIuMC4yL2xlYWZsZXQuYXdlc29tZS1tYXJrZXJzLmNzcyIvPgogICAgPGxpbmsgcmVsPSJzdHlsZXNoZWV0IiBocmVmPSJodHRwczovL3Jhd2Nkbi5naXRoYWNrLmNvbS9weXRob24tdmlzdWFsaXphdGlvbi9mb2xpdW0vbWFzdGVyL2ZvbGl1bS90ZW1wbGF0ZXMvbGVhZmxldC5hd2Vzb21lLnJvdGF0ZS5jc3MiLz4KICAgIDxzdHlsZT5odG1sLCBib2R5IHt3aWR0aDogMTAwJTtoZWlnaHQ6IDEwMCU7bWFyZ2luOiAwO3BhZGRpbmc6IDA7fTwvc3R5bGU+CiAgICA8c3R5bGU+I21hcCB7cG9zaXRpb246YWJzb2x1dGU7dG9wOjA7Ym90dG9tOjA7cmlnaHQ6MDtsZWZ0OjA7fTwvc3R5bGU+CiAgICAKICAgICAgICAgICAgPG1ldGEgbmFtZT0idmlld3BvcnQiIGNvbnRlbnQ9IndpZHRoPWRldmljZS13aWR0aCwKICAgICAgICAgICAgICAgIGluaXRpYWwtc2NhbGU9MS4wLCBtYXhpbXVtLXNjYWxlPTEuMCwgdXNlci1zY2FsYWJsZT1ubyIgLz4KICAgICAgICAgICAgPHN0eWxlPgogICAgICAgICAgICAgICAgI21hcF9iMjgwNzI0OTQzYWU0NjQyODU0MDc1OWRlMWZmMjY1NiB7CiAgICAgICAgICAgICAgICAgICAgcG9zaXRpb246IHJlbGF0aXZlOwogICAgICAgICAgICAgICAgICAgIHdpZHRoOiAxMDAuMCU7CiAgICAgICAgICAgICAgICAgICAgaGVpZ2h0OiAxMDAuMCU7CiAgICAgICAgICAgICAgICAgICAgbGVmdDogMC4wJTsKICAgICAgICAgICAgICAgICAgICB0b3A6IDAuMCU7CiAgICAgICAgICAgICAgICB9CiAgICAgICAgICAgIDwvc3R5bGU+CiAgICAgICAgCiAgICA8c2NyaXB0IHNyYz0iaHR0cHM6Ly9jZG5qcy5jbG91ZGZsYXJlLmNvbS9hamF4L2xpYnMvbGVhZmxldC5tYXJrZXJjbHVzdGVyLzEuMS4wL2xlYWZsZXQubWFya2VyY2x1c3Rlci5qcyI+PC9zY3JpcHQ+CiAgICA8bGluayByZWw9InN0eWxlc2hlZXQiIGhyZWY9Imh0dHBzOi8vY2RuanMuY2xvdWRmbGFyZS5jb20vYWpheC9saWJzL2xlYWZsZXQubWFya2VyY2x1c3Rlci8xLjEuMC9NYXJrZXJDbHVzdGVyLmNzcyIvPgogICAgPGxpbmsgcmVsPSJzdHlsZXNoZWV0IiBocmVmPSJodHRwczovL2NkbmpzLmNsb3VkZmxhcmUuY29tL2FqYXgvbGlicy9sZWFmbGV0Lm1hcmtlcmNsdXN0ZXIvMS4xLjAvTWFya2VyQ2x1c3Rlci5EZWZhdWx0LmNzcyIvPgo8L2hlYWQ+Cjxib2R5PiAgICAKICAgIAogICAgICAgICAgICA8ZGl2IGNsYXNzPSJmb2xpdW0tbWFwIiBpZD0ibWFwX2IyODA3MjQ5NDNhZTQ2NDI4NTQwNzU5ZGUxZmYyNjU2IiA+PC9kaXY+CiAgICAgICAgCjwvYm9keT4KPHNjcmlwdD4gICAgCiAgICAKICAgICAgICAgICAgdmFyIG1hcF9iMjgwNzI0OTQzYWU0NjQyODU0MDc1OWRlMWZmMjY1NiA9IEwubWFwKAogICAgICAgICAgICAgICAgIm1hcF9iMjgwNzI0OTQzYWU0NjQyODU0MDc1OWRlMWZmMjY1NiIsCiAgICAgICAgICAgICAgICB7CiAgICAgICAgICAgICAgICAgICAgY2VudGVyOiBbNDAuMDEsIC0xMDUuMjddLAogICAgICAgICAgICAgICAgICAgIGNyczogTC5DUlMuRVBTRzM4NTcsCiAgICAgICAgICAgICAgICAgICAgem9vbTogMTAsCiAgICAgICAgICAgICAgICAgICAgem9vbUNvbnRyb2w6IHRydWUsCiAgICAgICAgICAgICAgICAgICAgcHJlZmVyQ2FudmFzOiBmYWxzZSwKICAgICAgICAgICAgICAgIH0KICAgICAgICAgICAgKTsKCiAgICAgICAgICAgIAoKICAgICAgICAKICAgIAogICAgICAgICAgICB2YXIgdGlsZV9sYXllcl85MGQ2ZTJhYTMxOTY0Y2E3OTRmNzhlMDgzYzBhOWU5NCA9IEwudGlsZUxheWVyKAogICAgICAgICAgICAgICAgImh0dHBzOi8vY2FydG9kYi1iYXNlbWFwcy17c30uZ2xvYmFsLnNzbC5mYXN0bHkubmV0L2xpZ2h0X2FsbC97en0ve3h9L3t5fS5wbmciLAogICAgICAgICAgICAgICAgeyJhdHRyaWJ1dGlvbiI6ICJcdTAwMjZjb3B5OyBcdTAwM2NhIGhyZWY9XCJodHRwOi8vd3d3Lm9wZW5zdHJlZXRtYXAub3JnL2NvcHlyaWdodFwiXHUwMDNlT3BlblN0cmVldE1hcFx1MDAzYy9hXHUwMDNlIGNvbnRyaWJ1dG9ycyBcdTAwMjZjb3B5OyBcdTAwM2NhIGhyZWY9XCJodHRwOi8vY2FydG9kYi5jb20vYXR0cmlidXRpb25zXCJcdTAwM2VDYXJ0b0RCXHUwMDNjL2FcdTAwM2UsIENhcnRvREIgXHUwMDNjYSBocmVmID1cImh0dHA6Ly9jYXJ0b2RiLmNvbS9hdHRyaWJ1dGlvbnNcIlx1MDAzZWF0dHJpYnV0aW9uc1x1MDAzYy9hXHUwMDNlIiwgImRldGVjdFJldGluYSI6IGZhbHNlLCAibWF4TmF0aXZlWm9vbSI6IDE4LCAibWF4Wm9vbSI6IDE4LCAibWluWm9vbSI6IDAsICJub1dyYXAiOiBmYWxzZSwgIm9wYWNpdHkiOiAxLCAic3ViZG9tYWlucyI6ICJhYmMiLCAidG1zIjogZmFsc2V9CiAgICAgICAgICAgICkuYWRkVG8obWFwX2IyODA3MjQ5NDNhZTQ2NDI4NTQwNzU5ZGUxZmYyNjU2KTsKICAgICAgICAKICAgIAogICAgICAgICAgICB2YXIgbWFya2VyX2NsdXN0ZXJfNDA2Yjg1YWRhNjkzNGIwOGFhZjYwZGEyMmZmYmVkZDMgPSBMLm1hcmtlckNsdXN0ZXJHcm91cCgKICAgICAgICAgICAgICAgIHt9CiAgICAgICAgICAgICk7CiAgICAgICAgICAgIG1hcF9iMjgwNzI0OTQzYWU0NjQyODU0MDc1OWRlMWZmMjY1Ni5hZGRMYXllcihtYXJrZXJfY2x1c3Rlcl80MDZiODVhZGE2OTM0YjA4YWFmNjBkYTIyZmZiZWRkMyk7CiAgICAgICAgCiAgICAKICAgICAgICAgICAgdmFyIG1hcmtlcl84N2NjNmNmNDI3ODY0MjFiYWQ5M2U0MTk2ZmIyNDY0NyA9IEwubWFya2VyKAogICAgICAgICAgICAgICAgWzQwLjE4NTAzMywgLTEwNS4xODU3ODldLAogICAgICAgICAgICAgICAge30KICAgICAgICAgICAgKS5hZGRUbyhtYXJrZXJfY2x1c3Rlcl80MDZiODVhZGE2OTM0YjA4YWFmNjBkYTIyZmZiZWRkMyk7CiAgICAgICAgCiAgICAKICAgICAgICB2YXIgcG9wdXBfOTBmYzliMzMyODk1NDhjM2JmMWI1NTRkNGQ3OWQ1MTMgPSBMLnBvcHVwKHsibWF4V2lkdGgiOiAiMTAwJSJ9KTsKCiAgICAgICAgCiAgICAgICAgICAgIHZhciBodG1sXzdkNDIyZTBjYTA5YTQyNGQ4YzNiNDExYWJhYjA5ZWQ4ID0gJChgPGRpdiBpZD0iaHRtbF83ZDQyMmUwY2EwOWE0MjRkOGMzYjQxMWFiYWIwOWVkOCIgc3R5bGU9IndpZHRoOiAxMDAuMCU7IGhlaWdodDogMTAwLjAlOyI+TmFtZTogWldFQ0sgQU5EIFRVUk5FUiBESVRDSCBQcmVjaXA6IDAuMTQ8L2Rpdj5gKVswXTsKICAgICAgICAgICAgcG9wdXBfOTBmYzliMzMyODk1NDhjM2JmMWI1NTRkNGQ3OWQ1MTMuc2V0Q29udGVudChodG1sXzdkNDIyZTBjYTA5YTQyNGQ4YzNiNDExYWJhYjA5ZWQ4KTsKICAgICAgICAKCiAgICAgICAgbWFya2VyXzg3Y2M2Y2Y0Mjc4NjQyMWJhZDkzZTQxOTZmYjI0NjQ3LmJpbmRQb3B1cChwb3B1cF85MGZjOWIzMzI4OTU0OGMzYmYxYjU1NGQ0ZDc5ZDUxMykKICAgICAgICA7CgogICAgICAgIAogICAgCiAgICAKICAgICAgICAgICAgdmFyIG1hcmtlcl82ODY3ZTYyMDFhODk0ZTk1OTlhNmExOTZmNDdkZDI0OSA9IEwubWFya2VyKAogICAgICAgICAgICAgICAgWzQwLjIyMDcwMiwgLTEwNS4yNjM0OV0sCiAgICAgICAgICAgICAgICB7fQogICAgICAgICAgICApLmFkZFRvKG1hcmtlcl9jbHVzdGVyXzQwNmI4NWFkYTY5MzRiMDhhYWY2MGRhMjJmZmJlZGQzKTsKICAgICAgICAKICAgIAogICAgICAgIHZhciBwb3B1cF8yMDBiZTNlZTRmM2E0MThlYmMzNTYzZDM3MGJjYzZmZSA9IEwucG9wdXAoeyJtYXhXaWR0aCI6ICIxMDAlIn0pOwoKICAgICAgICAKICAgICAgICAgICAgdmFyIGh0bWxfM2MzMjhmMzg5OTlmNGNlMDhkNjRhNzhiMmNmNGZhNTcgPSAkKGA8ZGl2IGlkPSJodG1sXzNjMzI4ZjM4OTk5ZjRjZTA4ZDY0YTc4YjJjZjRmYTU3IiBzdHlsZT0id2lkdGg6IDEwMC4wJTsgaGVpZ2h0OiAxMDAuMCU7Ij5OYW1lOiBTQUlOVCBWUkFJTiBDUkVFSyBBVCBMWU9OUywgQ08gUHJlY2lwOiAzMy4wMDwvZGl2PmApWzBdOwogICAgICAgICAgICBwb3B1cF8yMDBiZTNlZTRmM2E0MThlYmMzNTYzZDM3MGJjYzZmZS5zZXRDb250ZW50KGh0bWxfM2MzMjhmMzg5OTlmNGNlMDhkNjRhNzhiMmNmNGZhNTcpOwogICAgICAgIAoKICAgICAgICBtYXJrZXJfNjg2N2U2MjAxYTg5NGU5NTk5YTZhMTk2ZjQ3ZGQyNDkuYmluZFBvcHVwKHBvcHVwXzIwMGJlM2VlNGYzYTQxOGViYzM1NjNkMzcwYmNjNmZlKQogICAgICAgIDsKCiAgICAgICAgCiAgICAKICAgIAogICAgICAgICAgICB2YXIgbWFya2VyXzBkODE4NTk3NmNlZDQzYWI4NGNmNjIyYWI5N2I3ZTcyID0gTC5tYXJrZXIoCiAgICAgICAgICAgICAgICBbNDAuMTk2NDIyLCAtMTA1LjIwNjU5Ml0sCiAgICAgICAgICAgICAgICB7fQogICAgICAgICAgICApLmFkZFRvKG1hcmtlcl9jbHVzdGVyXzQwNmI4NWFkYTY5MzRiMDhhYWY2MGRhMjJmZmJlZGQzKTsKICAgICAgICAKICAgIAogICAgICAgIHZhciBwb3B1cF8xMWZmYmQwYzFiMjQ0YmQ2YjM1NzdmYTE2ODg2ZjAwNiA9IEwucG9wdXAoeyJtYXhXaWR0aCI6ICIxMDAlIn0pOwoKICAgICAgICAKICAgICAgICAgICAgdmFyIGh0bWxfMTA0OTNmNzQ4ZmVlNDZjMTg4YjkzZDAyNzYzMzUxNzIgPSAkKGA8ZGl2IGlkPSJodG1sXzEwNDkzZjc0OGZlZTQ2YzE4OGI5M2QwMjc2MzM1MTcyIiBzdHlsZT0id2lkdGg6IDEwMC4wJTsgaGVpZ2h0OiAxMDAuMCU7Ij5OYW1lOiBPTElHQVJDSFkgRElUQ0ggRElWRVJTSU9OIFByZWNpcDogMi43NjwvZGl2PmApWzBdOwogICAgICAgICAgICBwb3B1cF8xMWZmYmQwYzFiMjQ0YmQ2YjM1NzdmYTE2ODg2ZjAwNi5zZXRDb250ZW50KGh0bWxfMTA0OTNmNzQ4ZmVlNDZjMTg4YjkzZDAyNzYzMzUxNzIpOwogICAgICAgIAoKICAgICAgICBtYXJrZXJfMGQ4MTg1OTc2Y2VkNDNhYjg0Y2Y2MjJhYjk3YjdlNzIuYmluZFBvcHVwKHBvcHVwXzExZmZiZDBjMWIyNDRiZDZiMzU3N2ZhMTY4ODZmMDA2KQogICAgICAgIDsKCiAgICAgICAgCiAgICAKICAgIAogICAgICAgICAgICB2YXIgbWFya2VyXzQwMDg3NWJkMGQ2MjQ4OTliYTIyZDUxMmYzMGU2NTQzID0gTC5tYXJrZXIoCiAgICAgICAgICAgICAgICBbNDAuMTkzNzU4LCAtMTA1LjIxMDM5XSwKICAgICAgICAgICAgICAgIHt9CiAgICAgICAgICAgICkuYWRkVG8obWFya2VyX2NsdXN0ZXJfNDA2Yjg1YWRhNjkzNGIwOGFhZjYwZGEyMmZmYmVkZDMpOwogICAgICAgIAogICAgCiAgICAgICAgdmFyIHBvcHVwXzI3MGRlMzBhYzVkMjQ1NjlhOGI4NTQ1MjVhYmU3ZGE5ID0gTC5wb3B1cCh7Im1heFdpZHRoIjogIjEwMCUifSk7CgogICAgICAgIAogICAgICAgICAgICB2YXIgaHRtbF83OTlmMWExNjcwMzA0OTdlYmI3MmY2OGE1MmQxN2UxNiA9ICQoYDxkaXYgaWQ9Imh0bWxfNzk5ZjFhMTY3MDMwNDk3ZWJiNzJmNjhhNTJkMTdlMTYiIHN0eWxlPSJ3aWR0aDogMTAwLjAlOyBoZWlnaHQ6IDEwMC4wJTsiPk5hbWU6IENMT1VHSCBBTkQgVFJVRSBESVRDSCBQcmVjaXA6IDAuMDA8L2Rpdj5gKVswXTsKICAgICAgICAgICAgcG9wdXBfMjcwZGUzMGFjNWQyNDU2OWE4Yjg1NDUyNWFiZTdkYTkuc2V0Q29udGVudChodG1sXzc5OWYxYTE2NzAzMDQ5N2ViYjcyZjY4YTUyZDE3ZTE2KTsKICAgICAgICAKCiAgICAgICAgbWFya2VyXzQwMDg3NWJkMGQ2MjQ4OTliYTIyZDUxMmYzMGU2NTQzLmJpbmRQb3B1cChwb3B1cF8yNzBkZTMwYWM1ZDI0NTY5YThiODU0NTI1YWJlN2RhOSkKICAgICAgICA7CgogICAgICAgIAogICAgCiAgICAKICAgICAgICAgICAgdmFyIG1hcmtlcl8zOTBlM2FiODA0MjI0NDdjOTE2NTNkMDU3NjZiZDZmMyA9IEwubWFya2VyKAogICAgICAgICAgICAgICAgWzQwLjAwNjM4LCAtMTA1LjMzMDg0MV0sCiAgICAgICAgICAgICAgICB7fQogICAgICAgICAgICApLmFkZFRvKG1hcmtlcl9jbHVzdGVyXzQwNmI4NWFkYTY5MzRiMDhhYWY2MGRhMjJmZmJlZGQzKTsKICAgICAgICAKICAgIAogICAgICAgIHZhciBwb3B1cF8zNDhkYzE4YTJhZmY0MGJjYmFjZjYxNWQ2YWU4YjBlYyA9IEwucG9wdXAoeyJtYXhXaWR0aCI6ICIxMDAlIn0pOwoKICAgICAgICAKICAgICAgICAgICAgdmFyIGh0bWxfNjFkMmUzN2U3YzAxNDcyMzg0Mzk3NWQzNGQ4MDk4MDggPSAkKGA8ZGl2IGlkPSJodG1sXzYxZDJlMzdlN2MwMTQ3MjM4NDM5NzVkMzRkODA5ODA4IiBzdHlsZT0id2lkdGg6IDEwMC4wJTsgaGVpZ2h0OiAxMDAuMCU7Ij5OYW1lOiBCT1VMREVSIENSRUVLIE5FQVIgT1JPREVMTCwgQ08uIFByZWNpcDogMjAuNDA8L2Rpdj5gKVswXTsKICAgICAgICAgICAgcG9wdXBfMzQ4ZGMxOGEyYWZmNDBiY2JhY2Y2MTVkNmFlOGIwZWMuc2V0Q29udGVudChodG1sXzYxZDJlMzdlN2MwMTQ3MjM4NDM5NzVkMzRkODA5ODA4KTsKICAgICAgICAKCiAgICAgICAgbWFya2VyXzM5MGUzYWI4MDQyMjQ0N2M5MTY1M2QwNTc2NmJkNmYzLmJpbmRQb3B1cChwb3B1cF8zNDhkYzE4YTJhZmY0MGJjYmFjZjYxNWQ2YWU4YjBlYykKICAgICAgICA7CgogICAgICAgIAogICAgCiAgICAKICAgICAgICAgICAgdmFyIG1hcmtlcl9iYTkwMmQxZmJkODQ0MzQxODY4MTIwYmEzYjdlYmI0ZiA9IEwubWFya2VyKAogICAgICAgICAgICAgICAgWzQwLjIwNDE5MywgLTEwNS4yMTg3NzddLAogICAgICAgICAgICAgICAge30KICAgICAgICAgICAgKS5hZGRUbyhtYXJrZXJfY2x1c3Rlcl80MDZiODVhZGE2OTM0YjA4YWFmNjBkYTIyZmZiZWRkMyk7CiAgICAgICAgCiAgICAKICAgICAgICB2YXIgcG9wdXBfM2QzODAwYWNlNDBjNDljZmI3YTgzZGZlYWJhMjE4NDkgPSBMLnBvcHVwKHsibWF4V2lkdGgiOiAiMTAwJSJ9KTsKCiAgICAgICAgCiAgICAgICAgICAgIHZhciBodG1sX2ZmZTQxZjE0ODk2MjQ5MWJiY2QxOGIzNWQ1MWNlYzYzID0gJChgPGRpdiBpZD0iaHRtbF9mZmU0MWYxNDg5NjI0OTFiYmNkMThiMzVkNTFjZWM2MyIgc3R5bGU9IndpZHRoOiAxMDAuMCU7IGhlaWdodDogMTAwLjAlOyI+TmFtZTogTE9OR01PTlQgU1VQUExZIERJVENIIFByZWNpcDogMC4wMDwvZGl2PmApWzBdOwogICAgICAgICAgICBwb3B1cF8zZDM4MDBhY2U0MGM0OWNmYjdhODNkZmVhYmEyMTg0OS5zZXRDb250ZW50KGh0bWxfZmZlNDFmMTQ4OTYyNDkxYmJjZDE4YjM1ZDUxY2VjNjMpOwogICAgICAgIAoKICAgICAgICBtYXJrZXJfYmE5MDJkMWZiZDg0NDM0MTg2ODEyMGJhM2I3ZWJiNGYuYmluZFBvcHVwKHBvcHVwXzNkMzgwMGFjZTQwYzQ5Y2ZiN2E4M2RmZWFiYTIxODQ5KQogICAgICAgIDsKCiAgICAgICAgCiAgICAKICAgIAogICAgICAgICAgICB2YXIgbWFya2VyXzQyNmQ1NzM3YmY2MDRmYjFiZGM4ZTMzODU4OGQwZTVmID0gTC5tYXJrZXIoCiAgICAgICAgICAgICAgICBbNDAuMjU4NzI2LCAtMTA1LjE3NTgxN10sCiAgICAgICAgICAgICAgICB7fQogICAgICAgICAgICApLmFkZFRvKG1hcmtlcl9jbHVzdGVyXzQwNmI4NWFkYTY5MzRiMDhhYWY2MGRhMjJmZmJlZGQzKTsKICAgICAgICAKICAgIAogICAgICAgIHZhciBwb3B1cF9lMDkzMGE3MWFmMTc0ZjE1OTE1NzAyNDk0ZjliMmZhYSA9IEwucG9wdXAoeyJtYXhXaWR0aCI6ICIxMDAlIn0pOwoKICAgICAgICAKICAgICAgICAgICAgdmFyIGh0bWxfM2Q4MmNlNzc0YzQxNGNlNGJhZWI4NTEwZGM5YWJhZDQgPSAkKGA8ZGl2IGlkPSJodG1sXzNkODJjZTc3NGM0MTRjZTRiYWViODUxMGRjOWFiYWQ0IiBzdHlsZT0id2lkdGg6IDEwMC4wJTsgaGVpZ2h0OiAxMDAuMCU7Ij5OYW1lOiBCT1VMREVSLUxBUklNRVIgQllQQVNTIE5FQVIgQkVSVEhPVUQgUHJlY2lwOiAxMS45MDwvZGl2PmApWzBdOwogICAgICAgICAgICBwb3B1cF9lMDkzMGE3MWFmMTc0ZjE1OTE1NzAyNDk0ZjliMmZhYS5zZXRDb250ZW50KGh0bWxfM2Q4MmNlNzc0YzQxNGNlNGJhZWI4NTEwZGM5YWJhZDQpOwogICAgICAgIAoKICAgICAgICBtYXJrZXJfNDI2ZDU3MzdiZjYwNGZiMWJkYzhlMzM4NTg4ZDBlNWYuYmluZFBvcHVwKHBvcHVwX2UwOTMwYTcxYWYxNzRmMTU5MTU3MDI0OTRmOWIyZmFhKQogICAgICAgIDsKCiAgICAgICAgCiAgICAKICAgIAogICAgICAgICAgICB2YXIgbWFya2VyX2Q5ODc0OWFjMGRhNzQxNzFiYmY5OTViM2FmZDkzZjdlID0gTC5tYXJrZXIoCiAgICAgICAgICAgICAgICBbNDAuMjU4MDM4LCAtMTA1LjIwNjM4Nl0sCiAgICAgICAgICAgICAgICB7fQogICAgICAgICAgICApLmFkZFRvKG1hcmtlcl9jbHVzdGVyXzQwNmI4NWFkYTY5MzRiMDhhYWY2MGRhMjJmZmJlZGQzKTsKICAgICAgICAKICAgIAogICAgICAgIHZhciBwb3B1cF8wYTc0MzhiMTE1MDE0ZDliYjE3MmI1NGQyYzU2MGQzMiA9IEwucG9wdXAoeyJtYXhXaWR0aCI6ICIxMDAlIn0pOwoKICAgICAgICAKICAgICAgICAgICAgdmFyIGh0bWxfZWI3NGJiNWUwODkwNGNkMGJkOGUzZmY1NTE1NjI1OTUgPSAkKGA8ZGl2IGlkPSJodG1sX2ViNzRiYjVlMDg5MDRjZDBiZDhlM2ZmNTUxNTYyNTk1IiBzdHlsZT0id2lkdGg6IDEwMC4wJTsgaGVpZ2h0OiAxMDAuMCU7Ij5OYW1lOiBMSVRUTEUgVEhPTVBTT04gUklWRVIgQVQgQ0FOWU9OIE1PVVRIIE5FQVIgQkVSVEhPVUQgUHJlY2lwOiAxNC4yMDwvZGl2PmApWzBdOwogICAgICAgICAgICBwb3B1cF8wYTc0MzhiMTE1MDE0ZDliYjE3MmI1NGQyYzU2MGQzMi5zZXRDb250ZW50KGh0bWxfZWI3NGJiNWUwODkwNGNkMGJkOGUzZmY1NTE1NjI1OTUpOwogICAgICAgIAoKICAgICAgICBtYXJrZXJfZDk4NzQ5YWMwZGE3NDE3MWJiZjk5NWIzYWZkOTNmN2UuYmluZFBvcHVwKHBvcHVwXzBhNzQzOGIxMTUwMTRkOWJiMTcyYjU0ZDJjNTYwZDMyKQogICAgICAgIDsKCiAgICAgICAgCiAgICAKICAgIAogICAgICAgICAgICB2YXIgbWFya2VyXzE5NzAyODZmNGQxZTQzMzZhNTk3YTUzMWYxMjY0ZDFlID0gTC5tYXJrZXIoCiAgICAgICAgICAgICAgICBbNDAuMTcyOTI1LCAtMTA1LjE2NzYyMl0sCiAgICAgICAgICAgICAgICB7fQogICAgICAgICAgICApLmFkZFRvKG1hcmtlcl9jbHVzdGVyXzQwNmI4NWFkYTY5MzRiMDhhYWY2MGRhMjJmZmJlZGQzKTsKICAgICAgICAKICAgIAogICAgICAgIHZhciBwb3B1cF9iM2NlODMyY2Y3Y2Y0ZTk5YTlhN2Q1YzRmZDlkMDYxMSA9IEwucG9wdXAoeyJtYXhXaWR0aCI6ICIxMDAlIn0pOwoKICAgICAgICAKICAgICAgICAgICAgdmFyIGh0bWxfOTJiMmQ2MzcwNGUxNDMzMzlmNmM0MTZkMGU0Y2M2ODYgPSAkKGA8ZGl2IGlkPSJodG1sXzkyYjJkNjM3MDRlMTQzMzM5ZjZjNDE2ZDBlNGNjNjg2IiBzdHlsZT0id2lkdGg6IDEwMC4wJTsgaGVpZ2h0OiAxMDAuMCU7Ij5OYW1lOiBOT1JUSFdFU1QgTVVUVUFMIERJVENIIFByZWNpcDogMC4wMDwvZGl2PmApWzBdOwogICAgICAgICAgICBwb3B1cF9iM2NlODMyY2Y3Y2Y0ZTk5YTlhN2Q1YzRmZDlkMDYxMS5zZXRDb250ZW50KGh0bWxfOTJiMmQ2MzcwNGUxNDMzMzlmNmM0MTZkMGU0Y2M2ODYpOwogICAgICAgIAoKICAgICAgICBtYXJrZXJfMTk3MDI4NmY0ZDFlNDMzNmE1OTdhNTMxZjEyNjRkMWUuYmluZFBvcHVwKHBvcHVwX2IzY2U4MzJjZjdjZjRlOTlhOWE3ZDVjNGZkOWQwNjExKQogICAgICAgIDsKCiAgICAgICAgCiAgICAKICAgIAogICAgICAgICAgICB2YXIgbWFya2VyXzE4Y2E5ZWM1ZjcyMjQ0ODlhNTc5MjViMDU5NjE5NTFhID0gTC5tYXJrZXIoCiAgICAgICAgICAgICAgICBbNDAuMTM0Mjc4LCAtMTA1LjEzMDgxOV0sCiAgICAgICAgICAgICAgICB7fQogICAgICAgICAgICApLmFkZFRvKG1hcmtlcl9jbHVzdGVyXzQwNmI4NWFkYTY5MzRiMDhhYWY2MGRhMjJmZmJlZGQzKTsKICAgICAgICAKICAgIAogICAgICAgIHZhciBwb3B1cF82Yjg1YjliNDcyYzI0OGZmODk2YzI5YTU1MzMwZWFhOSA9IEwucG9wdXAoeyJtYXhXaWR0aCI6ICIxMDAlIn0pOwoKICAgICAgICAKICAgICAgICAgICAgdmFyIGh0bWxfMDU4NDI3MzhjMjYxNDUzNjljODM3MTUyNjJjZTU0OTcgPSAkKGA8ZGl2IGlkPSJodG1sXzA1ODQyNzM4YzI2MTQ1MzY5YzgzNzE1MjYyY2U1NDk3IiBzdHlsZT0id2lkdGg6IDEwMC4wJTsgaGVpZ2h0OiAxMDAuMCU7Ij5OYW1lOiBMRUZUIEhBTkQgQ1JFRUsgQVQgSE9WRVIgUk9BRCBORUFSIExPTkdNT05ULCBDTyBQcmVjaXA6IDMuNjE8L2Rpdj5gKVswXTsKICAgICAgICAgICAgcG9wdXBfNmI4NWI5YjQ3MmMyNDhmZjg5NmMyOWE1NTMzMGVhYTkuc2V0Q29udGVudChodG1sXzA1ODQyNzM4YzI2MTQ1MzY5YzgzNzE1MjYyY2U1NDk3KTsKICAgICAgICAKCiAgICAgICAgbWFya2VyXzE4Y2E5ZWM1ZjcyMjQ0ODlhNTc5MjViMDU5NjE5NTFhLmJpbmRQb3B1cChwb3B1cF82Yjg1YjliNDcyYzI0OGZmODk2YzI5YTU1MzMwZWFhOSkKICAgICAgICA7CgogICAgICAgIAogICAgCiAgICAKICAgICAgICAgICAgdmFyIG1hcmtlcl84ZWNiY2JkZmE5ODA0MmE4YjYwNzViYjFjOGUwODY5ZCA9IEwubWFya2VyKAogICAgICAgICAgICAgICAgWzM5Ljk4NjE2OSwgLTEwNS4yMTg2NzddLAogICAgICAgICAgICAgICAge30KICAgICAgICAgICAgKS5hZGRUbyhtYXJrZXJfY2x1c3Rlcl80MDZiODVhZGE2OTM0YjA4YWFmNjBkYTIyZmZiZWRkMyk7CiAgICAgICAgCiAgICAKICAgICAgICB2YXIgcG9wdXBfNTJiNWJkZTljZjc0NDUxY2IyZDExNGE3NTNlZWVkN2YgPSBMLnBvcHVwKHsibWF4V2lkdGgiOiAiMTAwJSJ9KTsKCiAgICAgICAgCiAgICAgICAgICAgIHZhciBodG1sX2ZhN2M2ZmMxNjZmZTRiYjZhYTUyOGNiMjgwZDkwZmY3ID0gJChgPGRpdiBpZD0iaHRtbF9mYTdjNmZjMTY2ZmU0YmI2YWE1MjhjYjI4MGQ5MGZmNyIgc3R5bGU9IndpZHRoOiAxMDAuMCU7IGhlaWdodDogMTAwLjAlOyI+TmFtZTogRFJZIENSRUVLIENBUlJJRVIgUHJlY2lwOiAwLjAwPC9kaXY+YClbMF07CiAgICAgICAgICAgIHBvcHVwXzUyYjViZGU5Y2Y3NDQ1MWNiMmQxMTRhNzUzZWVlZDdmLnNldENvbnRlbnQoaHRtbF9mYTdjNmZjMTY2ZmU0YmI2YWE1MjhjYjI4MGQ5MGZmNyk7CiAgICAgICAgCgogICAgICAgIG1hcmtlcl84ZWNiY2JkZmE5ODA0MmE4YjYwNzViYjFjOGUwODY5ZC5iaW5kUG9wdXAocG9wdXBfNTJiNWJkZTljZjc0NDUxY2IyZDExNGE3NTNlZWVkN2YpCiAgICAgICAgOwoKICAgICAgICAKICAgIAogICAgCiAgICAgICAgICAgIHZhciBtYXJrZXJfNjJkNjNkZWY3NGI5NGRmZDk4MDMxNTQ0NDYyYWJjNTcgPSBMLm1hcmtlcigKICAgICAgICAgICAgICAgIFs0MC4xNjA3MDUsIC0xMDUuMTY4NDcxXSwKICAgICAgICAgICAgICAgIHt9CiAgICAgICAgICAgICkuYWRkVG8obWFya2VyX2NsdXN0ZXJfNDA2Yjg1YWRhNjkzNGIwOGFhZjYwZGEyMmZmYmVkZDMpOwogICAgICAgIAogICAgCiAgICAgICAgdmFyIHBvcHVwXzE4ZjM1YzQ2NjNhMDQ0NDc5MDRjNDYwNTk0YTdiYTljID0gTC5wb3B1cCh7Im1heFdpZHRoIjogIjEwMCUifSk7CgogICAgICAgIAogICAgICAgICAgICB2YXIgaHRtbF9jYzQzODRhOGE5MmQ0ODA2YWIzZWVhZDYwY2YwZWI5MCA9ICQoYDxkaXYgaWQ9Imh0bWxfY2M0Mzg0YThhOTJkNDgwNmFiM2VlYWQ2MGNmMGViOTAiIHN0eWxlPSJ3aWR0aDogMTAwLjAlOyBoZWlnaHQ6IDEwMC4wJTsiPk5hbWU6IFBFQ0stUEVMTEEgQVVHTUVOVEFUSU9OIFJFVFVSTiBQcmVjaXA6IDAuMDA8L2Rpdj5gKVswXTsKICAgICAgICAgICAgcG9wdXBfMThmMzVjNDY2M2EwNDQ0NzkwNGM0NjA1OTRhN2JhOWMuc2V0Q29udGVudChodG1sX2NjNDM4NGE4YTkyZDQ4MDZhYjNlZWFkNjBjZjBlYjkwKTsKICAgICAgICAKCiAgICAgICAgbWFya2VyXzYyZDYzZGVmNzRiOTRkZmQ5ODAzMTU0NDQ2MmFiYzU3LmJpbmRQb3B1cChwb3B1cF8xOGYzNWM0NjYzYTA0NDQ3OTA0YzQ2MDU5NGE3YmE5YykKICAgICAgICA7CgogICAgICAgIAogICAgCiAgICAKICAgICAgICAgICAgdmFyIG1hcmtlcl80NjlhODhkMzVlMWQ0NjhiYTA5YjAyYzQwNzY5ZjZhYyA9IEwubWFya2VyKAogICAgICAgICAgICAgICAgWzQwLjE5OTMyMSwgLTEwNS4yMjI2MzldLAogICAgICAgICAgICAgICAge30KICAgICAgICAgICAgKS5hZGRUbyhtYXJrZXJfY2x1c3Rlcl80MDZiODVhZGE2OTM0YjA4YWFmNjBkYTIyZmZiZWRkMyk7CiAgICAgICAgCiAgICAKICAgICAgICB2YXIgcG9wdXBfNjllZmY3NGVkYzIxNGMyNDkzMDg5ZWViZTQ2YmQxYjggPSBMLnBvcHVwKHsibWF4V2lkdGgiOiAiMTAwJSJ9KTsKCiAgICAgICAgCiAgICAgICAgICAgIHZhciBodG1sX2E0ZjJiZWFhZGYzYzQ2MmJhYTA3M2QyMGE4ZjIxOWYwID0gJChgPGRpdiBpZD0iaHRtbF9hNGYyYmVhYWRmM2M0NjJiYWEwNzNkMjBhOGYyMTlmMCIgc3R5bGU9IndpZHRoOiAxMDAuMCU7IGhlaWdodDogMTAwLjAlOyI+TmFtZTogR09TUyBESVRDSCAxIFByZWNpcDogMC4wMDwvZGl2PmApWzBdOwogICAgICAgICAgICBwb3B1cF82OWVmZjc0ZWRjMjE0YzI0OTMwODllZWJlNDZiZDFiOC5zZXRDb250ZW50KGh0bWxfYTRmMmJlYWFkZjNjNDYyYmFhMDczZDIwYThmMjE5ZjApOwogICAgICAgIAoKICAgICAgICBtYXJrZXJfNDY5YTg4ZDM1ZTFkNDY4YmEwOWIwMmM0MDc2OWY2YWMuYmluZFBvcHVwKHBvcHVwXzY5ZWZmNzRlZGMyMTRjMjQ5MzA4OWVlYmU0NmJkMWI4KQogICAgICAgIDsKCiAgICAgICAgCiAgICAKICAgIAogICAgICAgICAgICB2YXIgbWFya2VyX2JkZWFlNmJlZmU4ZTRhYzlhMmMxMjg5ZmVlNjEyMDRmID0gTC5tYXJrZXIoCiAgICAgICAgICAgICAgICBbNDAuMTkzMjgsIC0xMDUuMjEwNDI0XSwKICAgICAgICAgICAgICAgIHt9CiAgICAgICAgICAgICkuYWRkVG8obWFya2VyX2NsdXN0ZXJfNDA2Yjg1YWRhNjkzNGIwOGFhZjYwZGEyMmZmYmVkZDMpOwogICAgICAgIAogICAgCiAgICAgICAgdmFyIHBvcHVwXzkzZDZjYzY0Mjk3ZDQwMDY4MDllOGUxNDI2ZmFmY2YyID0gTC5wb3B1cCh7Im1heFdpZHRoIjogIjEwMCUifSk7CgogICAgICAgIAogICAgICAgICAgICB2YXIgaHRtbF9mYzZiNmIwM2JmMGU0MGIyOWUxOWFhM2E1Y2RkZTQ1NSA9ICQoYDxkaXYgaWQ9Imh0bWxfZmM2YjZiMDNiZjBlNDBiMjllMTlhYTNhNWNkZGU0NTUiIHN0eWxlPSJ3aWR0aDogMTAwLjAlOyBoZWlnaHQ6IDEwMC4wJTsiPk5hbWU6IFdFQlNURVIgTUNDQVNMSU4gRElUQ0ggUHJlY2lwOiAwLjAwPC9kaXY+YClbMF07CiAgICAgICAgICAgIHBvcHVwXzkzZDZjYzY0Mjk3ZDQwMDY4MDllOGUxNDI2ZmFmY2YyLnNldENvbnRlbnQoaHRtbF9mYzZiNmIwM2JmMGU0MGIyOWUxOWFhM2E1Y2RkZTQ1NSk7CiAgICAgICAgCgogICAgICAgIG1hcmtlcl9iZGVhZTZiZWZlOGU0YWM5YTJjMTI4OWZlZTYxMjA0Zi5iaW5kUG9wdXAocG9wdXBfOTNkNmNjNjQyOTdkNDAwNjgwOWU4ZTE0MjZmYWZjZjIpCiAgICAgICAgOwoKICAgICAgICAKICAgIAogICAgCiAgICAgICAgICAgIHZhciBtYXJrZXJfNWQ0MGNlMjdkYWU3NDk1ZThiNzhlYTM0ZTZiYmI5MDEgPSBMLm1hcmtlcigKICAgICAgICAgICAgICAgIFs0MC4wNTM2NjEsIC0xMDUuMTUxMTQzXSwKICAgICAgICAgICAgICAgIHt9CiAgICAgICAgICAgICkuYWRkVG8obWFya2VyX2NsdXN0ZXJfNDA2Yjg1YWRhNjkzNGIwOGFhZjYwZGEyMmZmYmVkZDMpOwogICAgICAgIAogICAgCiAgICAgICAgdmFyIHBvcHVwXzM4N2Q2ZjY5Y2JhZjQ3YTliMTBkYzY0NzcyYzRlZDhkID0gTC5wb3B1cCh7Im1heFdpZHRoIjogIjEwMCUifSk7CgogICAgICAgIAogICAgICAgICAgICB2YXIgaHRtbF9lZThjYzk5MGQ2MDI0YjZjYWNhNzczOWExYWVmZmFhYSA9ICQoYDxkaXYgaWQ9Imh0bWxfZWU4Y2M5OTBkNjAyNGI2Y2FjYTc3MzlhMWFlZmZhYWEiIHN0eWxlPSJ3aWR0aDogMTAwLjAlOyBoZWlnaHQ6IDEwMC4wJTsiPk5hbWU6IExFR0dFVFQgRElUQ0ggUHJlY2lwOiAyLjA2PC9kaXY+YClbMF07CiAgICAgICAgICAgIHBvcHVwXzM4N2Q2ZjY5Y2JhZjQ3YTliMTBkYzY0NzcyYzRlZDhkLnNldENvbnRlbnQoaHRtbF9lZThjYzk5MGQ2MDI0YjZjYWNhNzczOWExYWVmZmFhYSk7CiAgICAgICAgCgogICAgICAgIG1hcmtlcl81ZDQwY2UyN2RhZTc0OTVlOGI3OGVhMzRlNmJiYjkwMS5iaW5kUG9wdXAocG9wdXBfMzg3ZDZmNjljYmFmNDdhOWIxMGRjNjQ3NzJjNGVkOGQpCiAgICAgICAgOwoKICAgICAgICAKICAgIAogICAgCiAgICAgICAgICAgIHZhciBtYXJrZXJfODljY2ZhOGFhZmQyNGI5ZmJmYWI0YzViMmVmM2JjMWQgPSBMLm1hcmtlcigKICAgICAgICAgICAgICAgIFs0MC4yMTYyNjMsIC0xMDUuMzY1MzY1XSwKICAgICAgICAgICAgICAgIHt9CiAgICAgICAgICAgICkuYWRkVG8obWFya2VyX2NsdXN0ZXJfNDA2Yjg1YWRhNjkzNGIwOGFhZjYwZGEyMmZmYmVkZDMpOwogICAgICAgIAogICAgCiAgICAgICAgdmFyIHBvcHVwXzRkYjZkMmVlODBjNzQ5ZjViOWNlYTg5ODUxMGQxMjg0ID0gTC5wb3B1cCh7Im1heFdpZHRoIjogIjEwMCUifSk7CgogICAgICAgIAogICAgICAgICAgICB2YXIgaHRtbF9hNDRkMjBkY2M4MjM0YmM2YjVjNWM5YzAzNjc2Y2U0MyA9ICQoYDxkaXYgaWQ9Imh0bWxfYTQ0ZDIwZGNjODIzNGJjNmI1YzVjOWMwMzY3NmNlNDMiIHN0eWxlPSJ3aWR0aDogMTAwLjAlOyBoZWlnaHQ6IDEwMC4wJTsiPk5hbWU6IEJVVFRPTlJPQ0sgKFJBTFBIIFBSSUNFKSBSRVNFUlZPSVIgUHJlY2lwOiAxMjkxMy4wMDwvZGl2PmApWzBdOwogICAgICAgICAgICBwb3B1cF80ZGI2ZDJlZTgwYzc0OWY1YjljZWE4OTg1MTBkMTI4NC5zZXRDb250ZW50KGh0bWxfYTQ0ZDIwZGNjODIzNGJjNmI1YzVjOWMwMzY3NmNlNDMpOwogICAgICAgIAoKICAgICAgICBtYXJrZXJfODljY2ZhOGFhZmQyNGI5ZmJmYWI0YzViMmVmM2JjMWQuYmluZFBvcHVwKHBvcHVwXzRkYjZkMmVlODBjNzQ5ZjViOWNlYTg5ODUxMGQxMjg0KQogICAgICAgIDsKCiAgICAgICAgCiAgICAKICAgIAogICAgICAgICAgICB2YXIgbWFya2VyXzA1M2JiNTRmM2YzZDRiZWViNWE1YzE3NGUzNDE0OWU1ID0gTC5tYXJrZXIoCiAgICAgICAgICAgICAgICBbNDAuMjU1Nzc2LCAtMTA1LjIwOTVdLAogICAgICAgICAgICAgICAge30KICAgICAgICAgICAgKS5hZGRUbyhtYXJrZXJfY2x1c3Rlcl80MDZiODVhZGE2OTM0YjA4YWFmNjBkYTIyZmZiZWRkMyk7CiAgICAgICAgCiAgICAKICAgICAgICB2YXIgcG9wdXBfODhlMjVjNDkzZmRkNDQzZGFiNWY2YTc3OGQwYjhkMmEgPSBMLnBvcHVwKHsibWF4V2lkdGgiOiAiMTAwJSJ9KTsKCiAgICAgICAgCiAgICAgICAgICAgIHZhciBodG1sXzZkNzFiMzZkMGQwODQ0ZDdiM2I4ZmJlNmY0NWNlNzJlID0gJChgPGRpdiBpZD0iaHRtbF82ZDcxYjM2ZDBkMDg0NGQ3YjNiOGZiZTZmNDVjZTcyZSIgc3R5bGU9IndpZHRoOiAxMDAuMCU7IGhlaWdodDogMTAwLjAlOyI+TmFtZTogTElUVExFIFRIT01QU09OICMyIERJVENIIFByZWNpcDogMC4xMDwvZGl2PmApWzBdOwogICAgICAgICAgICBwb3B1cF84OGUyNWM0OTNmZGQ0NDNkYWI1ZjZhNzc4ZDBiOGQyYS5zZXRDb250ZW50KGh0bWxfNmQ3MWIzNmQwZDA4NDRkN2IzYjhmYmU2ZjQ1Y2U3MmUpOwogICAgICAgIAoKICAgICAgICBtYXJrZXJfMDUzYmI1NGYzZjNkNGJlZWI1YTVjMTc0ZTM0MTQ5ZTUuYmluZFBvcHVwKHBvcHVwXzg4ZTI1YzQ5M2ZkZDQ0M2RhYjVmNmE3NzhkMGI4ZDJhKQogICAgICAgIDsKCiAgICAgICAgCiAgICAKICAgIAogICAgICAgICAgICB2YXIgbWFya2VyXzY4ODlkYWJlZGUxYjQyMzk5OTA3NTg2OGE0YWQ5YWU3ID0gTC5tYXJrZXIoCiAgICAgICAgICAgICAgICBbNDAuMjU3ODQ0LCAtMTA1LjE2NDM5N10sCiAgICAgICAgICAgICAgICB7fQogICAgICAgICAgICApLmFkZFRvKG1hcmtlcl9jbHVzdGVyXzQwNmI4NWFkYTY5MzRiMDhhYWY2MGRhMjJmZmJlZGQzKTsKICAgICAgICAKICAgIAogICAgICAgIHZhciBwb3B1cF84NTVmZDE3ZDRkYmY0OWNiYjM0YzA1MDA4ZjhkN2M4ZSA9IEwucG9wdXAoeyJtYXhXaWR0aCI6ICIxMDAlIn0pOwoKICAgICAgICAKICAgICAgICAgICAgdmFyIGh0bWxfOGU0N2E1ZjIwMmU2NDQ2MThlNjA4NzkxODUzNTIzNGQgPSAkKGA8ZGl2IGlkPSJodG1sXzhlNDdhNWYyMDJlNjQ0NjE4ZTYwODc5MTg1MzUyMzRkIiBzdHlsZT0id2lkdGg6IDEwMC4wJTsgaGVpZ2h0OiAxMDAuMCU7Ij5OYW1lOiBCTE9XRVIgRElUQ0ggUHJlY2lwOiAwLjAwPC9kaXY+YClbMF07CiAgICAgICAgICAgIHBvcHVwXzg1NWZkMTdkNGRiZjQ5Y2JiMzRjMDUwMDhmOGQ3YzhlLnNldENvbnRlbnQoaHRtbF84ZTQ3YTVmMjAyZTY0NDYxOGU2MDg3OTE4NTM1MjM0ZCk7CiAgICAgICAgCgogICAgICAgIG1hcmtlcl82ODg5ZGFiZWRlMWI0MjM5OTkwNzU4NjhhNGFkOWFlNy5iaW5kUG9wdXAocG9wdXBfODU1ZmQxN2Q0ZGJmNDljYmIzNGMwNTAwOGY4ZDdjOGUpCiAgICAgICAgOwoKICAgICAgICAKICAgIAogICAgCiAgICAgICAgICAgIHZhciBtYXJrZXJfNTcwZmU2NDUzY2FkNGIzYmI3NzQ2Nzc4YjY4YTE4YTQgPSBMLm1hcmtlcigKICAgICAgICAgICAgICAgIFszOS45MzgzNTEsIC0xMDUuMzQ3OTA2XSwKICAgICAgICAgICAgICAgIHt9CiAgICAgICAgICAgICkuYWRkVG8obWFya2VyX2NsdXN0ZXJfNDA2Yjg1YWRhNjkzNGIwOGFhZjYwZGEyMmZmYmVkZDMpOwogICAgICAgIAogICAgCiAgICAgICAgdmFyIHBvcHVwXzFmYjk1M2QzOGRkZDRhM2JiMmE1NWYwNDIzZjQ0MTFhID0gTC5wb3B1cCh7Im1heFdpZHRoIjogIjEwMCUifSk7CgogICAgICAgIAogICAgICAgICAgICB2YXIgaHRtbF81MTFjNzdhMTQ2YTI0NTcxYWZjYzdkN2RmNTBjNTA4OCA9ICQoYDxkaXYgaWQ9Imh0bWxfNTExYzc3YTE0NmEyNDU3MWFmY2M3ZDdkZjUwYzUwODgiIHN0eWxlPSJ3aWR0aDogMTAwLjAlOyBoZWlnaHQ6IDEwMC4wJTsiPk5hbWU6IFNPVVRIIEJPVUxERVIgQ1JFRUsgQkVMT1cgR1JPU1MgUkVTRVJWT0lSIFByZWNpcDogMTYuNDA8L2Rpdj5gKVswXTsKICAgICAgICAgICAgcG9wdXBfMWZiOTUzZDM4ZGRkNGEzYmIyYTU1ZjA0MjNmNDQxMWEuc2V0Q29udGVudChodG1sXzUxMWM3N2ExNDZhMjQ1NzFhZmNjN2Q3ZGY1MGM1MDg4KTsKICAgICAgICAKCiAgICAgICAgbWFya2VyXzU3MGZlNjQ1M2NhZDRiM2JiNzc0Njc3OGI2OGExOGE0LmJpbmRQb3B1cChwb3B1cF8xZmI5NTNkMzhkZGQ0YTNiYjJhNTVmMDQyM2Y0NDExYSkKICAgICAgICA7CgogICAgICAgIAogICAgCiAgICAKICAgICAgICAgICAgdmFyIG1hcmtlcl9jZWNkMWQwYjA3OTQ0NDY4Yjg0NGI4NWExOWQyZDRiMyA9IEwubWFya2VyKAogICAgICAgICAgICAgICAgWzQwLjA1MTY1MiwgLTEwNS4xNzg4NzVdLAogICAgICAgICAgICAgICAge30KICAgICAgICAgICAgKS5hZGRUbyhtYXJrZXJfY2x1c3Rlcl80MDZiODVhZGE2OTM0YjA4YWFmNjBkYTIyZmZiZWRkMyk7CiAgICAgICAgCiAgICAKICAgICAgICB2YXIgcG9wdXBfYzIwNzViYmEyMzI5NDMwMTk0MTU2ZGI1OTUzMjA2MjUgPSBMLnBvcHVwKHsibWF4V2lkdGgiOiAiMTAwJSJ9KTsKCiAgICAgICAgCiAgICAgICAgICAgIHZhciBodG1sXzRlYzI0NDY1YzM2NTQ5N2VhMTk5YjY2MGExOTA0YmVjID0gJChgPGRpdiBpZD0iaHRtbF80ZWMyNDQ2NWMzNjU0OTdlYTE5OWI2NjBhMTkwNGJlYyIgc3R5bGU9IndpZHRoOiAxMDAuMCU7IGhlaWdodDogMTAwLjAlOyI+TmFtZTogQk9VTERFUiBDUkVFSyBBVCBOT1JUSCA3NVRIIFNULiBORUFSIEJPVUxERVIsIENPIFByZWNpcDogMjUuNTA8L2Rpdj5gKVswXTsKICAgICAgICAgICAgcG9wdXBfYzIwNzViYmEyMzI5NDMwMTk0MTU2ZGI1OTUzMjA2MjUuc2V0Q29udGVudChodG1sXzRlYzI0NDY1YzM2NTQ5N2VhMTk5YjY2MGExOTA0YmVjKTsKICAgICAgICAKCiAgICAgICAgbWFya2VyX2NlY2QxZDBiMDc5NDQ0NjhiODQ0Yjg1YTE5ZDJkNGIzLmJpbmRQb3B1cChwb3B1cF9jMjA3NWJiYTIzMjk0MzAxOTQxNTZkYjU5NTMyMDYyNSkKICAgICAgICA7CgogICAgICAgIAogICAgCiAgICAKICAgICAgICAgICAgdmFyIG1hcmtlcl8wZjI4OTA0Zjg2ZTY0MTY4YmQyMmM5MjVmMDY5YTJhOSA9IEwubWFya2VyKAogICAgICAgICAgICAgICAgWzQwLjE3MDk5OCwgLTEwNS4xNjA4NzZdLAogICAgICAgICAgICAgICAge30KICAgICAgICAgICAgKS5hZGRUbyhtYXJrZXJfY2x1c3Rlcl80MDZiODVhZGE2OTM0YjA4YWFmNjBkYTIyZmZiZWRkMyk7CiAgICAgICAgCiAgICAKICAgICAgICB2YXIgcG9wdXBfNDE0MGQxMjg2NmVkNDIyY2IwYjIxZTk3MThjMGZjMzQgPSBMLnBvcHVwKHsibWF4V2lkdGgiOiAiMTAwJSJ9KTsKCiAgICAgICAgCiAgICAgICAgICAgIHZhciBodG1sXzNmNjFhNDY4YmE5ZjRlYTZhZWY0MmY5YmYwZTljMGIxID0gJChgPGRpdiBpZD0iaHRtbF8zZjYxYTQ2OGJhOWY0ZWE2YWVmNDJmOWJmMGU5YzBiMSIgc3R5bGU9IndpZHRoOiAxMDAuMCU7IGhlaWdodDogMTAwLjAlOyI+TmFtZTogU09VVEggRkxBVCBESVRDSCBQcmVjaXA6IDAuMzg8L2Rpdj5gKVswXTsKICAgICAgICAgICAgcG9wdXBfNDE0MGQxMjg2NmVkNDIyY2IwYjIxZTk3MThjMGZjMzQuc2V0Q29udGVudChodG1sXzNmNjFhNDY4YmE5ZjRlYTZhZWY0MmY5YmYwZTljMGIxKTsKICAgICAgICAKCiAgICAgICAgbWFya2VyXzBmMjg5MDRmODZlNjQxNjhiZDIyYzkyNWYwNjlhMmE5LmJpbmRQb3B1cChwb3B1cF80MTQwZDEyODY2ZWQ0MjJjYjBiMjFlOTcxOGMwZmMzNCkKICAgICAgICA7CgogICAgICAgIAogICAgCiAgICAKICAgICAgICAgICAgdmFyIG1hcmtlcl9lYWM0OGYyNWI4OTI0NzUxYjk1ZjAwMjMyZWNiOWIxYSA9IEwubWFya2VyKAogICAgICAgICAgICAgICAgWzQwLjE1MzM0MSwgLTEwNS4wNzU2OTVdLAogICAgICAgICAgICAgICAge30KICAgICAgICAgICAgKS5hZGRUbyhtYXJrZXJfY2x1c3Rlcl80MDZiODVhZGE2OTM0YjA4YWFmNjBkYTIyZmZiZWRkMyk7CiAgICAgICAgCiAgICAKICAgICAgICB2YXIgcG9wdXBfYjU3Y2JjMmVhM2M5NGUwZThjN2Q0MWFkMDg2NWVhOTAgPSBMLnBvcHVwKHsibWF4V2lkdGgiOiAiMTAwJSJ9KTsKCiAgICAgICAgCiAgICAgICAgICAgIHZhciBodG1sXzk2YzgyOGQyYWQ5NzQ2YTQ4NTU3N2NhYmU1ZTU3MWVmID0gJChgPGRpdiBpZD0iaHRtbF85NmM4MjhkMmFkOTc0NmE0ODU1NzdjYWJlNWU1NzFlZiIgc3R5bGU9IndpZHRoOiAxMDAuMCU7IGhlaWdodDogMTAwLjAlOyI+TmFtZTogU0FJTlQgVlJBSU4gQ1JFRUsgQkVMT1cgS0VOIFBSQVRUIEJMVkQgQVQgTE9OR01PTlQsIENPIFByZWNpcDogMzEuNDA8L2Rpdj5gKVswXTsKICAgICAgICAgICAgcG9wdXBfYjU3Y2JjMmVhM2M5NGUwZThjN2Q0MWFkMDg2NWVhOTAuc2V0Q29udGVudChodG1sXzk2YzgyOGQyYWQ5NzQ2YTQ4NTU3N2NhYmU1ZTU3MWVmKTsKICAgICAgICAKCiAgICAgICAgbWFya2VyX2VhYzQ4ZjI1Yjg5MjQ3NTFiOTVmMDAyMzJlY2I5YjFhLmJpbmRQb3B1cChwb3B1cF9iNTdjYmMyZWEzYzk0ZTBlOGM3ZDQxYWQwODY1ZWE5MCkKICAgICAgICA7CgogICAgICAgIAogICAgCiAgICAKICAgICAgICAgICAgdmFyIG1hcmtlcl9lZDMwYWFmYTcxZjI0NGYwYWU1M2UyNjljYzU0NmM2ZCA9IEwubWFya2VyKAogICAgICAgICAgICAgICAgWzM5Ljk2MTY1NSwgLTEwNS41MDQ0NF0sCiAgICAgICAgICAgICAgICB7fQogICAgICAgICAgICApLmFkZFRvKG1hcmtlcl9jbHVzdGVyXzQwNmI4NWFkYTY5MzRiMDhhYWY2MGRhMjJmZmJlZGQzKTsKICAgICAgICAKICAgIAogICAgICAgIHZhciBwb3B1cF9kZTExMDY5YmUyZDA0MmZiYTUxZTk4YWJlMzQxYWI3NyA9IEwucG9wdXAoeyJtYXhXaWR0aCI6ICIxMDAlIn0pOwoKICAgICAgICAKICAgICAgICAgICAgdmFyIGh0bWxfMGVkODM2YTBhYzI0NDMyYzg5YTBhM2JmNmRkNjg1ZGEgPSAkKGA8ZGl2IGlkPSJodG1sXzBlZDgzNmEwYWMyNDQzMmM4OWEwYTNiZjZkZDY4NWRhIiBzdHlsZT0id2lkdGg6IDEwMC4wJTsgaGVpZ2h0OiAxMDAuMCU7Ij5OYW1lOiBNSURETEUgQk9VTERFUiBDUkVFSyBBVCBORURFUkxBTkQsIENPLiBQcmVjaXA6IDI0LjAwPC9kaXY+YClbMF07CiAgICAgICAgICAgIHBvcHVwX2RlMTEwNjliZTJkMDQyZmJhNTFlOThhYmUzNDFhYjc3LnNldENvbnRlbnQoaHRtbF8wZWQ4MzZhMGFjMjQ0MzJjODlhMGEzYmY2ZGQ2ODVkYSk7CiAgICAgICAgCgogICAgICAgIG1hcmtlcl9lZDMwYWFmYTcxZjI0NGYwYWU1M2UyNjljYzU0NmM2ZC5iaW5kUG9wdXAocG9wdXBfZGUxMTA2OWJlMmQwNDJmYmE1MWU5OGFiZTM0MWFiNzcpCiAgICAgICAgOwoKICAgICAgICAKICAgIAogICAgCiAgICAgICAgICAgIHZhciBtYXJrZXJfOGIzMmJjMmFlMmU4NDQzZThiMWQ3MTJhYjc4OGU0ZWMgPSBMLm1hcmtlcigKICAgICAgICAgICAgICAgIFs0MC4wNTk4MDksIC0xMDUuMDk3ODcyXSwKICAgICAgICAgICAgICAgIHt9CiAgICAgICAgICAgICkuYWRkVG8obWFya2VyX2NsdXN0ZXJfNDA2Yjg1YWRhNjkzNGIwOGFhZjYwZGEyMmZmYmVkZDMpOwogICAgICAgIAogICAgCiAgICAgICAgdmFyIHBvcHVwXzUzYjU3NjdkOGI5ZjRmOWY4NTY1OTk0MzkyZTBkZjgwID0gTC5wb3B1cCh7Im1heFdpZHRoIjogIjEwMCUifSk7CgogICAgICAgIAogICAgICAgICAgICB2YXIgaHRtbF82ODU5ZGZhOGEyMjA0NTI5OGNmOGVlOTMwNWVhMjRmNCA9ICQoYDxkaXYgaWQ9Imh0bWxfNjg1OWRmYThhMjIwNDUyOThjZjhlZTkzMDVlYTI0ZjQiIHN0eWxlPSJ3aWR0aDogMTAwLjAlOyBoZWlnaHQ6IDEwMC4wJTsiPk5hbWU6IEJPVUxERVIgQ1JFRUsgQVQgMTA5IFNUIE5FQVIgRVJJRSwgQ08gUHJlY2lwOiA1Ny42MDwvZGl2PmApWzBdOwogICAgICAgICAgICBwb3B1cF81M2I1NzY3ZDhiOWY0ZjlmODU2NTk5NDM5MmUwZGY4MC5zZXRDb250ZW50KGh0bWxfNjg1OWRmYThhMjIwNDUyOThjZjhlZTkzMDVlYTI0ZjQpOwogICAgICAgIAoKICAgICAgICBtYXJrZXJfOGIzMmJjMmFlMmU4NDQzZThiMWQ3MTJhYjc4OGU0ZWMuYmluZFBvcHVwKHBvcHVwXzUzYjU3NjdkOGI5ZjRmOWY4NTY1OTk0MzkyZTBkZjgwKQogICAgICAgIDsKCiAgICAgICAgCiAgICAKICAgIAogICAgICAgICAgICB2YXIgbWFya2VyX2I0MGY2YTc2ZWU5NTRiMDE4ODMyN2M3NDcwZGQyYzhiID0gTC5tYXJrZXIoCiAgICAgICAgICAgICAgICBbNDAuMjE1NjU4LCAtMTA1LjM2MzQyMl0sCiAgICAgICAgICAgICAgICB7fQogICAgICAgICAgICApLmFkZFRvKG1hcmtlcl9jbHVzdGVyXzQwNmI4NWFkYTY5MzRiMDhhYWY2MGRhMjJmZmJlZGQzKTsKICAgICAgICAKICAgIAogICAgICAgIHZhciBwb3B1cF8zNDZkNzVhZDJiMmQ0YTE0OGQ5ZjIxNjA0YmQ1MzA4NSA9IEwucG9wdXAoeyJtYXhXaWR0aCI6ICIxMDAlIn0pOwoKICAgICAgICAKICAgICAgICAgICAgdmFyIGh0bWxfNWMzYmI4ZmU4ZmUyNDk4MDkwZDQ5YTFjNjU2OTA2MTYgPSAkKGA8ZGl2IGlkPSJodG1sXzVjM2JiOGZlOGZlMjQ5ODA5MGQ0OWExYzY1NjkwNjE2IiBzdHlsZT0id2lkdGg6IDEwMC4wJTsgaGVpZ2h0OiAxMDAuMCU7Ij5OYW1lOiBOT1JUSCBTQUlOVCBWUkFJTiBDUkVFSyBCRUxPVyBCVVRUT05ST0NLICAoUkFMUEggUFJJQ0UpIFJFU0VSVk9JUiBQcmVjaXA6IDE5LjMwPC9kaXY+YClbMF07CiAgICAgICAgICAgIHBvcHVwXzM0NmQ3NWFkMmIyZDRhMTQ4ZDlmMjE2MDRiZDUzMDg1LnNldENvbnRlbnQoaHRtbF81YzNiYjhmZThmZTI0OTgwOTBkNDlhMWM2NTY5MDYxNik7CiAgICAgICAgCgogICAgICAgIG1hcmtlcl9iNDBmNmE3NmVlOTU0YjAxODgzMjdjNzQ3MGRkMmM4Yi5iaW5kUG9wdXAocG9wdXBfMzQ2ZDc1YWQyYjJkNGExNDhkOWYyMTYwNGJkNTMwODUpCiAgICAgICAgOwoKICAgICAgICAKICAgIAogICAgCiAgICAgICAgICAgIHZhciBtYXJrZXJfMmZjMjdlYTllOThhNDFmN2JhM2JhZjA1ZjI2ZDJmMDQgPSBMLm1hcmtlcigKICAgICAgICAgICAgICAgIFs0MC4xMjYzODksIC0xMDUuMzA0NDA0XSwKICAgICAgICAgICAgICAgIHt9CiAgICAgICAgICAgICkuYWRkVG8obWFya2VyX2NsdXN0ZXJfNDA2Yjg1YWRhNjkzNGIwOGFhZjYwZGEyMmZmYmVkZDMpOwogICAgICAgIAogICAgCiAgICAgICAgdmFyIHBvcHVwXzhlNTc2ZDFlNzU4MjQyMGI4OWU0NTA4YTJhM2NjNDY0ID0gTC5wb3B1cCh7Im1heFdpZHRoIjogIjEwMCUifSk7CgogICAgICAgIAogICAgICAgICAgICB2YXIgaHRtbF84MTM1NjViMmM1NTM0NjMzYTg4OTk2MWQ2MWVmZGQ2NyA9ICQoYDxkaXYgaWQ9Imh0bWxfODEzNTY1YjJjNTUzNDYzM2E4ODk5NjFkNjFlZmRkNjciIHN0eWxlPSJ3aWR0aDogMTAwLjAlOyBoZWlnaHQ6IDEwMC4wJTsiPk5hbWU6IExFRlQgSEFORCBDUkVFSyBORUFSIEJPVUxERVIsIENPLiBQcmVjaXA6IDEzLjUwPC9kaXY+YClbMF07CiAgICAgICAgICAgIHBvcHVwXzhlNTc2ZDFlNzU4MjQyMGI4OWU0NTA4YTJhM2NjNDY0LnNldENvbnRlbnQoaHRtbF84MTM1NjViMmM1NTM0NjMzYTg4OTk2MWQ2MWVmZGQ2Nyk7CiAgICAgICAgCgogICAgICAgIG1hcmtlcl8yZmMyN2VhOWU5OGE0MWY3YmEzYmFmMDVmMjZkMmYwNC5iaW5kUG9wdXAocG9wdXBfOGU1NzZkMWU3NTgyNDIwYjg5ZTQ1MDhhMmEzY2M0NjQpCiAgICAgICAgOwoKICAgICAgICAKICAgIAogICAgCiAgICAgICAgICAgIHZhciBtYXJrZXJfODNjZjE4MTlhZmY4NDRkMWFkOWUxOGM3OWNlOTYyNGQgPSBMLm1hcmtlcigKICAgICAgICAgICAgICAgIFs0MC4wODYyNzgsIC0xMDUuMjE3NTE5XSwKICAgICAgICAgICAgICAgIHt9CiAgICAgICAgICAgICkuYWRkVG8obWFya2VyX2NsdXN0ZXJfNDA2Yjg1YWRhNjkzNGIwOGFhZjYwZGEyMmZmYmVkZDMpOwogICAgICAgIAogICAgCiAgICAgICAgdmFyIHBvcHVwXzhiODlhZWYwYjdhNzRiZDhiMjIyYzJiNTNjOGY5NzNkID0gTC5wb3B1cCh7Im1heFdpZHRoIjogIjEwMCUifSk7CgogICAgICAgIAogICAgICAgICAgICB2YXIgaHRtbF8zNjI3NjAxNGQxZDY0NTlmODkxMjE1YjhkMDRhNWM4MyA9ICQoYDxkaXYgaWQ9Imh0bWxfMzYyNzYwMTRkMWQ2NDU5Zjg5MTIxNWI4ZDA0YTVjODMiIHN0eWxlPSJ3aWR0aDogMTAwLjAlOyBoZWlnaHQ6IDEwMC4wJTsiPk5hbWU6IEJPVUxERVIgUkVTRVJWT0lSIElOTEVUIFByZWNpcDogMC4wMDwvZGl2PmApWzBdOwogICAgICAgICAgICBwb3B1cF84Yjg5YWVmMGI3YTc0YmQ4YjIyMmMyYjUzYzhmOTczZC5zZXRDb250ZW50KGh0bWxfMzYyNzYwMTRkMWQ2NDU5Zjg5MTIxNWI4ZDA0YTVjODMpOwogICAgICAgIAoKICAgICAgICBtYXJrZXJfODNjZjE4MTlhZmY4NDRkMWFkOWUxOGM3OWNlOTYyNGQuYmluZFBvcHVwKHBvcHVwXzhiODlhZWYwYjdhNzRiZDhiMjIyYzJiNTNjOGY5NzNkKQogICAgICAgIDsKCiAgICAgICAgCiAgICAKICAgIAogICAgICAgICAgICB2YXIgbWFya2VyXzNjMGZkODIwYzU3NDRjOTdhNzE4NTE1MjNkOTk1ZTExID0gTC5tYXJrZXIoCiAgICAgICAgICAgICAgICBbNDAuMTkzMDE5LCAtMTA1LjIxMDM4OF0sCiAgICAgICAgICAgICAgICB7fQogICAgICAgICAgICApLmFkZFRvKG1hcmtlcl9jbHVzdGVyXzQwNmI4NWFkYTY5MzRiMDhhYWY2MGRhMjJmZmJlZGQzKTsKICAgICAgICAKICAgIAogICAgICAgIHZhciBwb3B1cF9hM2QzYzdmODJlOTk0MDVkOTk5OWFiNzRhNDVhNWVlMyA9IEwucG9wdXAoeyJtYXhXaWR0aCI6ICIxMDAlIn0pOwoKICAgICAgICAKICAgICAgICAgICAgdmFyIGh0bWxfMjJhZWZkNTc4ZWE4NDE4NzhlODhiODljYjQxYzZkMTYgPSAkKGA8ZGl2IGlkPSJodG1sXzIyYWVmZDU3OGVhODQxODc4ZTg4Yjg5Y2I0MWM2ZDE2IiBzdHlsZT0id2lkdGg6IDEwMC4wJTsgaGVpZ2h0OiAxMDAuMCU7Ij5OYW1lOiBUUlVFIEFORCBXRUJTVEVSIERJVENIIFByZWNpcDogMC4wMDwvZGl2PmApWzBdOwogICAgICAgICAgICBwb3B1cF9hM2QzYzdmODJlOTk0MDVkOTk5OWFiNzRhNDVhNWVlMy5zZXRDb250ZW50KGh0bWxfMjJhZWZkNTc4ZWE4NDE4NzhlODhiODljYjQxYzZkMTYpOwogICAgICAgIAoKICAgICAgICBtYXJrZXJfM2MwZmQ4MjBjNTc0NGM5N2E3MTg1MTUyM2Q5OTVlMTEuYmluZFBvcHVwKHBvcHVwX2EzZDNjN2Y4MmU5OTQwNWQ5OTk5YWI3NGE0NWE1ZWUzKQogICAgICAgIDsKCiAgICAgICAgCiAgICAKICAgIAogICAgICAgICAgICB2YXIgbWFya2VyXzRjYjNjNGFmZjMxMzRiNDY5MzVmMGY4MmI1Y2U3ODhjID0gTC5tYXJrZXIoCiAgICAgICAgICAgICAgICBbNDAuMjEyNjU4LCAtMTA1LjI1MTgyNl0sCiAgICAgICAgICAgICAgICB7fQogICAgICAgICAgICApLmFkZFRvKG1hcmtlcl9jbHVzdGVyXzQwNmI4NWFkYTY5MzRiMDhhYWY2MGRhMjJmZmJlZGQzKTsKICAgICAgICAKICAgIAogICAgICAgIHZhciBwb3B1cF8xZGMwYzM4NDkyMWE0NTQ0YTA2MTM5MTRjMDYxNzhjZCA9IEwucG9wdXAoeyJtYXhXaWR0aCI6ICIxMDAlIn0pOwoKICAgICAgICAKICAgICAgICAgICAgdmFyIGh0bWxfZDBjY2E5Zjk5NzYyNGQ0N2JlZTAyZDgwOGI5NTM3MGYgPSAkKGA8ZGl2IGlkPSJodG1sX2QwY2NhOWY5OTc2MjRkNDdiZWUwMmQ4MDhiOTUzNzBmIiBzdHlsZT0id2lkdGg6IDEwMC4wJTsgaGVpZ2h0OiAxMDAuMCU7Ij5OYW1lOiBST1VHSCBBTkQgUkVBRFkgRElUQ0ggUHJlY2lwOiAwLjAwPC9kaXY+YClbMF07CiAgICAgICAgICAgIHBvcHVwXzFkYzBjMzg0OTIxYTQ1NDRhMDYxMzkxNGMwNjE3OGNkLnNldENvbnRlbnQoaHRtbF9kMGNjYTlmOTk3NjI0ZDQ3YmVlMDJkODA4Yjk1MzcwZik7CiAgICAgICAgCgogICAgICAgIG1hcmtlcl80Y2IzYzRhZmYzMTM0YjQ2OTM1ZjBmODJiNWNlNzg4Yy5iaW5kUG9wdXAocG9wdXBfMWRjMGMzODQ5MjFhNDU0NGEwNjEzOTE0YzA2MTc4Y2QpCiAgICAgICAgOwoKICAgICAgICAKICAgIAogICAgCiAgICAgICAgICAgIHZhciBtYXJrZXJfY2NiM2JmNDkyM2MyNDI3MGFiNzc2OWNmNTk4NmQyMDEgPSBMLm1hcmtlcigKICAgICAgICAgICAgICAgIFs0MC4xNzQ4NDQsIC0xMDUuMTY3ODczXSwKICAgICAgICAgICAgICAgIHt9CiAgICAgICAgICAgICkuYWRkVG8obWFya2VyX2NsdXN0ZXJfNDA2Yjg1YWRhNjkzNGIwOGFhZjYwZGEyMmZmYmVkZDMpOwogICAgICAgIAogICAgCiAgICAgICAgdmFyIHBvcHVwXzk5NDYxZTIzYTM2ZDRiYWQ4NTE1ZTNhMjMxMGIzNTljID0gTC5wb3B1cCh7Im1heFdpZHRoIjogIjEwMCUifSk7CgogICAgICAgIAogICAgICAgICAgICB2YXIgaHRtbF81N2UzNDAwMDhlMTc0MGVhODdiNmI1OWZiYjFkMDBmZiA9ICQoYDxkaXYgaWQ9Imh0bWxfNTdlMzQwMDA4ZTE3NDBlYTg3YjZiNTlmYmIxZDAwZmYiIHN0eWxlPSJ3aWR0aDogMTAwLjAlOyBoZWlnaHQ6IDEwMC4wJTsiPk5hbWU6IEhBR0VSIE1FQURPV1MgRElUQ0ggUHJlY2lwOiAwLjE4PC9kaXY+YClbMF07CiAgICAgICAgICAgIHBvcHVwXzk5NDYxZTIzYTM2ZDRiYWQ4NTE1ZTNhMjMxMGIzNTljLnNldENvbnRlbnQoaHRtbF81N2UzNDAwMDhlMTc0MGVhODdiNmI1OWZiYjFkMDBmZik7CiAgICAgICAgCgogICAgICAgIG1hcmtlcl9jY2IzYmY0OTIzYzI0MjcwYWI3NzY5Y2Y1OTg2ZDIwMS5iaW5kUG9wdXAocG9wdXBfOTk0NjFlMjNhMzZkNGJhZDg1MTVlM2EyMzEwYjM1OWMpCiAgICAgICAgOwoKICAgICAgICAKICAgIAogICAgCiAgICAgICAgICAgIHZhciBtYXJrZXJfMWI1MTkyNjI4MGI4NDQ4YjhmYzQxNTkzMDgwZmU2ZmUgPSBMLm1hcmtlcigKICAgICAgICAgICAgICAgIFs0MC4yNTYyNzYsIC0xMDUuMjA5NDE2XSwKICAgICAgICAgICAgICAgIHt9CiAgICAgICAgICAgICkuYWRkVG8obWFya2VyX2NsdXN0ZXJfNDA2Yjg1YWRhNjkzNGIwOGFhZjYwZGEyMmZmYmVkZDMpOwogICAgICAgIAogICAgCiAgICAgICAgdmFyIHBvcHVwX2NkZDBmYjIzY2YyMzRiYzU4NGY0ZjQ0NTljN2ZiYWIxID0gTC5wb3B1cCh7Im1heFdpZHRoIjogIjEwMCUifSk7CgogICAgICAgIAogICAgICAgICAgICB2YXIgaHRtbF83NzI0MWU4NjFlYmI0YjgxYjJkY2JkNjc5ZWE4Nzc4ZCA9ICQoYDxkaXYgaWQ9Imh0bWxfNzcyNDFlODYxZWJiNGI4MWIyZGNiZDY3OWVhODc3OGQiIHN0eWxlPSJ3aWR0aDogMTAwLjAlOyBoZWlnaHQ6IDEwMC4wJTsiPk5hbWU6IExJVFRMRSBUSE9NUFNPTiAjMSBESVRDSCBQcmVjaXA6IDAuMDA8L2Rpdj5gKVswXTsKICAgICAgICAgICAgcG9wdXBfY2RkMGZiMjNjZjIzNGJjNTg0ZjRmNDQ1OWM3ZmJhYjEuc2V0Q29udGVudChodG1sXzc3MjQxZTg2MWViYjRiODFiMmRjYmQ2NzllYTg3NzhkKTsKICAgICAgICAKCiAgICAgICAgbWFya2VyXzFiNTE5MjYyODBiODQ0OGI4ZmM0MTU5MzA4MGZlNmZlLmJpbmRQb3B1cChwb3B1cF9jZGQwZmIyM2NmMjM0YmM1ODRmNGY0NDU5YzdmYmFiMSkKICAgICAgICA7CgogICAgICAgIAogICAgCiAgICAKICAgICAgICAgICAgdmFyIG1hcmtlcl80MDEzNjQ4NzcwYjI0ZTFiYjg4YjJmYTY2YzY0ZDdmOCA9IEwubWFya2VyKAogICAgICAgICAgICAgICAgWzQwLjI2MDgyNywgLTEwNS4xOTg1NjddLAogICAgICAgICAgICAgICAge30KICAgICAgICAgICAgKS5hZGRUbyhtYXJrZXJfY2x1c3Rlcl80MDZiODVhZGE2OTM0YjA4YWFmNjBkYTIyZmZiZWRkMyk7CiAgICAgICAgCiAgICAKICAgICAgICB2YXIgcG9wdXBfYzc5OWRmYzBiYjBkNDdkNGI1M2NhZTg2YjMyOWUyMTggPSBMLnBvcHVwKHsibWF4V2lkdGgiOiAiMTAwJSJ9KTsKCiAgICAgICAgCiAgICAgICAgICAgIHZhciBodG1sX2ZmN2VkMjIwY2M5YzQ4NThhNjQ5MzJkNTlhZDgzMjk1ID0gJChgPGRpdiBpZD0iaHRtbF9mZjdlZDIyMGNjOWM0ODU4YTY0OTMyZDU5YWQ4MzI5NSIgc3R5bGU9IndpZHRoOiAxMDAuMCU7IGhlaWdodDogMTAwLjAlOyI+TmFtZTogQ1VMVkVSIERJVENIIFByZWNpcDogMC4wMDwvZGl2PmApWzBdOwogICAgICAgICAgICBwb3B1cF9jNzk5ZGZjMGJiMGQ0N2Q0YjUzY2FlODZiMzI5ZTIxOC5zZXRDb250ZW50KGh0bWxfZmY3ZWQyMjBjYzljNDg1OGE2NDkzMmQ1OWFkODMyOTUpOwogICAgICAgIAoKICAgICAgICBtYXJrZXJfNDAxMzY0ODc3MGIyNGUxYmI4OGIyZmE2NmM2NGQ3ZjguYmluZFBvcHVwKHBvcHVwX2M3OTlkZmMwYmIwZDQ3ZDRiNTNjYWU4NmIzMjllMjE4KQogICAgICAgIDsKCiAgICAgICAgCiAgICAKICAgIAogICAgICAgICAgICB2YXIgbWFya2VyX2I3MWU2MGI2NTEzNzQwN2I4NzUxZGVhMTRlZmY1ZTg3ID0gTC5tYXJrZXIoCiAgICAgICAgICAgICAgICBbNDAuMjE1MDQzLCAtMTA1LjI1NjAxN10sCiAgICAgICAgICAgICAgICB7fQogICAgICAgICAgICApLmFkZFRvKG1hcmtlcl9jbHVzdGVyXzQwNmI4NWFkYTY5MzRiMDhhYWY2MGRhMjJmZmJlZGQzKTsKICAgICAgICAKICAgIAogICAgICAgIHZhciBwb3B1cF8zZTg5M2E4MTI0NzI0MmQ2OTNhM2Q5Njg3NDY0NDI2MCA9IEwucG9wdXAoeyJtYXhXaWR0aCI6ICIxMDAlIn0pOwoKICAgICAgICAKICAgICAgICAgICAgdmFyIGh0bWxfZjgwNzYxMDE3ZDIyNDEwNWI0OGZhZjBkNjUyNjExMjEgPSAkKGA8ZGl2IGlkPSJodG1sX2Y4MDc2MTAxN2QyMjQxMDViNDhmYWYwZDY1MjYxMTIxIiBzdHlsZT0id2lkdGg6IDEwMC4wJTsgaGVpZ2h0OiAxMDAuMCU7Ij5OYW1lOiBISUdITEFORCBESVRDSCBBVCBMWU9OUywgQ08gUHJlY2lwOiAzNS42MDwvZGl2PmApWzBdOwogICAgICAgICAgICBwb3B1cF8zZTg5M2E4MTI0NzI0MmQ2OTNhM2Q5Njg3NDY0NDI2MC5zZXRDb250ZW50KGh0bWxfZjgwNzYxMDE3ZDIyNDEwNWI0OGZhZjBkNjUyNjExMjEpOwogICAgICAgIAoKICAgICAgICBtYXJrZXJfYjcxZTYwYjY1MTM3NDA3Yjg3NTFkZWExNGVmZjVlODcuYmluZFBvcHVwKHBvcHVwXzNlODkzYTgxMjQ3MjQyZDY5M2EzZDk2ODc0NjQ0MjYwKQogICAgICAgIDsKCiAgICAgICAgCiAgICAKICAgIAogICAgICAgICAgICB2YXIgbWFya2VyXzZmYjI2NGZjN2ExODRmZmI4MWQzOGQ1M2M3YTBkN2U0ID0gTC5tYXJrZXIoCiAgICAgICAgICAgICAgICBbNDAuMDc4NTYsIC0xMDUuMjIwNDk3XSwKICAgICAgICAgICAgICAgIHt9CiAgICAgICAgICAgICkuYWRkVG8obWFya2VyX2NsdXN0ZXJfNDA2Yjg1YWRhNjkzNGIwOGFhZjYwZGEyMmZmYmVkZDMpOwogICAgICAgIAogICAgCiAgICAgICAgdmFyIHBvcHVwXzY4N2QzNWVlY2U0NDQwODE5ZmQ4NmExY2IxZTQxZGFjID0gTC5wb3B1cCh7Im1heFdpZHRoIjogIjEwMCUifSk7CgogICAgICAgIAogICAgICAgICAgICB2YXIgaHRtbF9jZGYxN2NiOGMwNjQ0MzUzOWNkNDI3YjJjYjVmMWIxYiA9ICQoYDxkaXYgaWQ9Imh0bWxfY2RmMTdjYjhjMDY0NDM1MzljZDQyN2IyY2I1ZjFiMWIiIHN0eWxlPSJ3aWR0aDogMTAwLjAlOyBoZWlnaHQ6IDEwMC4wJTsiPk5hbWU6IEJPVUxERVIgUkVTRVJWT0lSIFByZWNpcDogNTEzNy41MDwvZGl2PmApWzBdOwogICAgICAgICAgICBwb3B1cF82ODdkMzVlZWNlNDQ0MDgxOWZkODZhMWNiMWU0MWRhYy5zZXRDb250ZW50KGh0bWxfY2RmMTdjYjhjMDY0NDM1MzljZDQyN2IyY2I1ZjFiMWIpOwogICAgICAgIAoKICAgICAgICBtYXJrZXJfNmZiMjY0ZmM3YTE4NGZmYjgxZDM4ZDUzYzdhMGQ3ZTQuYmluZFBvcHVwKHBvcHVwXzY4N2QzNWVlY2U0NDQwODE5ZmQ4NmExY2IxZTQxZGFjKQogICAgICAgIDsKCiAgICAgICAgCiAgICAKICAgIAogICAgICAgICAgICB2YXIgbWFya2VyXzM2NWRiNzZkODhlNjRhNjI4ZmQzYzExNjg3YmYyMTQyID0gTC5tYXJrZXIoCiAgICAgICAgICAgICAgICBbNDAuMTczOTUsIC0xMDUuMTY5Mzc0XSwKICAgICAgICAgICAgICAgIHt9CiAgICAgICAgICAgICkuYWRkVG8obWFya2VyX2NsdXN0ZXJfNDA2Yjg1YWRhNjkzNGIwOGFhZjYwZGEyMmZmYmVkZDMpOwogICAgICAgIAogICAgCiAgICAgICAgdmFyIHBvcHVwXzQzM2ExODcxMzMxNTQ2Y2NiNjkxMTU3MjMzNTRhNmMyID0gTC5wb3B1cCh7Im1heFdpZHRoIjogIjEwMCUifSk7CgogICAgICAgIAogICAgICAgICAgICB2YXIgaHRtbF9iNWVkZWJlMGIxMGU0MjJlOWRkZjMzOTdiNGZiYTkyNyA9ICQoYDxkaXYgaWQ9Imh0bWxfYjVlZGViZTBiMTBlNDIyZTlkZGYzMzk3YjRmYmE5MjciIHN0eWxlPSJ3aWR0aDogMTAwLjAlOyBoZWlnaHQ6IDEwMC4wJTsiPk5hbWU6IE5JV09UIERJVENIIFByZWNpcDogMC4xOTwvZGl2PmApWzBdOwogICAgICAgICAgICBwb3B1cF80MzNhMTg3MTMzMTU0NmNjYjY5MTE1NzIzMzU0YTZjMi5zZXRDb250ZW50KGh0bWxfYjVlZGViZTBiMTBlNDIyZTlkZGYzMzk3YjRmYmE5MjcpOwogICAgICAgIAoKICAgICAgICBtYXJrZXJfMzY1ZGI3NmQ4OGU2NGE2MjhmZDNjMTE2ODdiZjIxNDIuYmluZFBvcHVwKHBvcHVwXzQzM2ExODcxMzMxNTQ2Y2NiNjkxMTU3MjMzNTRhNmMyKQogICAgICAgIDsKCiAgICAgICAgCiAgICAKICAgIAogICAgICAgICAgICB2YXIgbWFya2VyX2JhMWYwNWE0NjBiZTQ2ODI5NjBkMGFmZjI4ZDBkOGYyID0gTC5tYXJrZXIoCiAgICAgICAgICAgICAgICBbNDAuMjExMzg5LCAtMTA1LjI1MDk1Ml0sCiAgICAgICAgICAgICAgICB7fQogICAgICAgICAgICApLmFkZFRvKG1hcmtlcl9jbHVzdGVyXzQwNmI4NWFkYTY5MzRiMDhhYWY2MGRhMjJmZmJlZGQzKTsKICAgICAgICAKICAgIAogICAgICAgIHZhciBwb3B1cF8yNWRmNDU2NGZlZmQ0N2UyYTZlMjllMWRiODNmODlmOCA9IEwucG9wdXAoeyJtYXhXaWR0aCI6ICIxMDAlIn0pOwoKICAgICAgICAKICAgICAgICAgICAgdmFyIGh0bWxfMWJmYzc4MDBhODRlNGI1ZGFmZTI0OWIxMWQ3MzUyNDYgPSAkKGA8ZGl2IGlkPSJodG1sXzFiZmM3ODAwYTg0ZTRiNWRhZmUyNDliMTFkNzM1MjQ2IiBzdHlsZT0id2lkdGg6IDEwMC4wJTsgaGVpZ2h0OiAxMDAuMCU7Ij5OYW1lOiBTTUVBRCBESVRDSCBQcmVjaXA6IDAuMDA8L2Rpdj5gKVswXTsKICAgICAgICAgICAgcG9wdXBfMjVkZjQ1NjRmZWZkNDdlMmE2ZTI5ZTFkYjgzZjg5Zjguc2V0Q29udGVudChodG1sXzFiZmM3ODAwYTg0ZTRiNWRhZmUyNDliMTFkNzM1MjQ2KTsKICAgICAgICAKCiAgICAgICAgbWFya2VyX2JhMWYwNWE0NjBiZTQ2ODI5NjBkMGFmZjI4ZDBkOGYyLmJpbmRQb3B1cChwb3B1cF8yNWRmNDU2NGZlZmQ0N2UyYTZlMjllMWRiODNmODlmOCkKICAgICAgICA7CgogICAgICAgIAogICAgCiAgICAKICAgICAgICAgICAgdmFyIG1hcmtlcl85NmNkMjAzYTViZTA0Nzc0OTkwN2RiNzIwMjViZTIyYiA9IEwubWFya2VyKAogICAgICAgICAgICAgICAgWzM5LjkzMTgxMywgLTEwNS4zMDg0MzJdLAogICAgICAgICAgICAgICAge30KICAgICAgICAgICAgKS5hZGRUbyhtYXJrZXJfY2x1c3Rlcl80MDZiODVhZGE2OTM0YjA4YWFmNjBkYTIyZmZiZWRkMyk7CiAgICAgICAgCiAgICAKICAgICAgICB2YXIgcG9wdXBfMDE4NTZhOTAwMWRiNDg5YmFjODUwMjU4NDJiMjkzOWQgPSBMLnBvcHVwKHsibWF4V2lkdGgiOiAiMTAwJSJ9KTsKCiAgICAgICAgCiAgICAgICAgICAgIHZhciBodG1sXzU2ZmMwYzg4MWYxNDRmMjRhZTM1MDFmZTYyMDkzN2IwID0gJChgPGRpdiBpZD0iaHRtbF81NmZjMGM4ODFmMTQ0ZjI0YWUzNTAxZmU2MjA5MzdiMCIgc3R5bGU9IndpZHRoOiAxMDAuMCU7IGhlaWdodDogMTAwLjAlOyI+TmFtZTogU09VVEggQk9VTERFUiBDUkVFSyBESVZFUlNJT04gTkVBUiBFTERPUkFETyBTUFJJTkdTIFByZWNpcDogMC4wMDwvZGl2PmApWzBdOwogICAgICAgICAgICBwb3B1cF8wMTg1NmE5MDAxZGI0ODliYWM4NTAyNTg0MmIyOTM5ZC5zZXRDb250ZW50KGh0bWxfNTZmYzBjODgxZjE0NGYyNGFlMzUwMWZlNjIwOTM3YjApOwogICAgICAgIAoKICAgICAgICBtYXJrZXJfOTZjZDIwM2E1YmUwNDc3NDk5MDdkYjcyMDI1YmUyMmIuYmluZFBvcHVwKHBvcHVwXzAxODU2YTkwMDFkYjQ4OWJhYzg1MDI1ODQyYjI5MzlkKQogICAgICAgIDsKCiAgICAgICAgCiAgICAKICAgIAogICAgICAgICAgICB2YXIgbWFya2VyX2M5MGJhMTI2ZjQyYjQ2OWY4OTE5YzNkN2I0NzAwZjZjID0gTC5tYXJrZXIoCiAgICAgICAgICAgICAgICBbNDAuMjE4MzM1LCAtMTA1LjI1ODExXSwKICAgICAgICAgICAgICAgIHt9CiAgICAgICAgICAgICkuYWRkVG8obWFya2VyX2NsdXN0ZXJfNDA2Yjg1YWRhNjkzNGIwOGFhZjYwZGEyMmZmYmVkZDMpOwogICAgICAgIAogICAgCiAgICAgICAgdmFyIHBvcHVwXzRjMzkxZDQ4ZjFiZjQ3YmM5ZWQ5MjQ1OWIxZjA3ZWE3ID0gTC5wb3B1cCh7Im1heFdpZHRoIjogIjEwMCUifSk7CgogICAgICAgIAogICAgICAgICAgICB2YXIgaHRtbF9iYWI4OTNiN2YwMGY0MjU3OTJhNjZiMzYwNTc4NzZmNiA9ICQoYDxkaXYgaWQ9Imh0bWxfYmFiODkzYjdmMDBmNDI1NzkyYTY2YjM2MDU3ODc2ZjYiIHN0eWxlPSJ3aWR0aDogMTAwLjAlOyBoZWlnaHQ6IDEwMC4wJTsiPk5hbWU6IFNBSU5UIFZSQUlOIFNVUFBMWSBDQU5BTCBORUFSIExZT05TLCBDTyBQcmVjaXA6IDk0LjkwPC9kaXY+YClbMF07CiAgICAgICAgICAgIHBvcHVwXzRjMzkxZDQ4ZjFiZjQ3YmM5ZWQ5MjQ1OWIxZjA3ZWE3LnNldENvbnRlbnQoaHRtbF9iYWI4OTNiN2YwMGY0MjU3OTJhNjZiMzYwNTc4NzZmNik7CiAgICAgICAgCgogICAgICAgIG1hcmtlcl9jOTBiYTEyNmY0MmI0NjlmODkxOWMzZDdiNDcwMGY2Yy5iaW5kUG9wdXAocG9wdXBfNGMzOTFkNDhmMWJmNDdiYzllZDkyNDU5YjFmMDdlYTcpCiAgICAgICAgOwoKICAgICAgICAKICAgIAogICAgCiAgICAgICAgICAgIHZhciBtYXJrZXJfNjFhZjJlY2NkOGVjNDc0ODlhYzZkMGI0YWMyYmUzYTcgPSBMLm1hcmtlcigKICAgICAgICAgICAgICAgIFs0MC4xNTMzNjMsIC0xMDUuMDg4Njk1XSwKICAgICAgICAgICAgICAgIHt9CiAgICAgICAgICAgICkuYWRkVG8obWFya2VyX2NsdXN0ZXJfNDA2Yjg1YWRhNjkzNGIwOGFhZjYwZGEyMmZmYmVkZDMpOwogICAgICAgIAogICAgCiAgICAgICAgdmFyIHBvcHVwXzgwMWYzMGIzOTA4OTQ4MTZhODcxYTg2MTM5NzY2YTNmID0gTC5wb3B1cCh7Im1heFdpZHRoIjogIjEwMCUifSk7CgogICAgICAgIAogICAgICAgICAgICB2YXIgaHRtbF9kYmJhNmNlMzY2ZWI0NjBmOWE3ZmIyZDY4YmFlZTg5MCA9ICQoYDxkaXYgaWQ9Imh0bWxfZGJiYTZjZTM2NmViNDYwZjlhN2ZiMmQ2OGJhZWU4OTAiIHN0eWxlPSJ3aWR0aDogMTAwLjAlOyBoZWlnaHQ6IDEwMC4wJTsiPk5hbWU6IEJPTlVTIERJVENIIFByZWNpcDogMC4xMDwvZGl2PmApWzBdOwogICAgICAgICAgICBwb3B1cF84MDFmMzBiMzkwODk0ODE2YTg3MWE4NjEzOTc2NmEzZi5zZXRDb250ZW50KGh0bWxfZGJiYTZjZTM2NmViNDYwZjlhN2ZiMmQ2OGJhZWU4OTApOwogICAgICAgIAoKICAgICAgICBtYXJrZXJfNjFhZjJlY2NkOGVjNDc0ODlhYzZkMGI0YWMyYmUzYTcuYmluZFBvcHVwKHBvcHVwXzgwMWYzMGIzOTA4OTQ4MTZhODcxYTg2MTM5NzY2YTNmKQogICAgICAgIDsKCiAgICAgICAgCiAgICAKICAgIAogICAgICAgICAgICB2YXIgbWFya2VyXzEzNzc2NTRiNGUyZTQzZDNhY2EwNGYxY2I1YjkzZmY0ID0gTC5tYXJrZXIoCiAgICAgICAgICAgICAgICBbNDAuMDk2MDMsIC0xMDUuMDkxMDU5XSwKICAgICAgICAgICAgICAgIHt9CiAgICAgICAgICAgICkuYWRkVG8obWFya2VyX2NsdXN0ZXJfNDA2Yjg1YWRhNjkzNGIwOGFhZjYwZGEyMmZmYmVkZDMpOwogICAgICAgIAogICAgCiAgICAgICAgdmFyIHBvcHVwXzBhYjI0ZTFhZmVhMjRmNWI5ZDViNGEyYjk0YTk4MGE1ID0gTC5wb3B1cCh7Im1heFdpZHRoIjogIjEwMCUifSk7CgogICAgICAgIAogICAgICAgICAgICB2YXIgaHRtbF81ZDg5ZGRlMjc5YjU0OWNkODc2NjYwOWMxYWY4ZWVjMSA9ICQoYDxkaXYgaWQ9Imh0bWxfNWQ4OWRkZTI3OWI1NDljZDg3NjY2MDljMWFmOGVlYzEiIHN0eWxlPSJ3aWR0aDogMTAwLjAlOyBoZWlnaHQ6IDEwMC4wJTsiPk5hbWU6IFBBTkFNQSBSRVNFUlZPSVIgSU5MRVQgUHJlY2lwOiAyMi4xMDwvZGl2PmApWzBdOwogICAgICAgICAgICBwb3B1cF8wYWIyNGUxYWZlYTI0ZjViOWQ1YjRhMmI5NGE5ODBhNS5zZXRDb250ZW50KGh0bWxfNWQ4OWRkZTI3OWI1NDljZDg3NjY2MDljMWFmOGVlYzEpOwogICAgICAgIAoKICAgICAgICBtYXJrZXJfMTM3NzY1NGI0ZTJlNDNkM2FjYTA0ZjFjYjViOTNmZjQuYmluZFBvcHVwKHBvcHVwXzBhYjI0ZTFhZmVhMjRmNWI5ZDViNGEyYjk0YTk4MGE1KQogICAgICAgIDsKCiAgICAgICAgCiAgICAKICAgIAogICAgICAgICAgICB2YXIgbWFya2VyXzMzNDE0YmYwNzQ2NzQ2NmM4MDJhNWNmYTU1ZjdjYWZiID0gTC5tYXJrZXIoCiAgICAgICAgICAgICAgICBbNDAuMjExMDgzLCAtMTA1LjI1MDkyN10sCiAgICAgICAgICAgICAgICB7fQogICAgICAgICAgICApLmFkZFRvKG1hcmtlcl9jbHVzdGVyXzQwNmI4NWFkYTY5MzRiMDhhYWY2MGRhMjJmZmJlZGQzKTsKICAgICAgICAKICAgIAogICAgICAgIHZhciBwb3B1cF83Mzc4NWEzMWU0ZmU0OTgzYjBhMWQ5NDJmNzdmM2ZkYiA9IEwucG9wdXAoeyJtYXhXaWR0aCI6ICIxMDAlIn0pOwoKICAgICAgICAKICAgICAgICAgICAgdmFyIGh0bWxfODJiMzNhNWRiMWNlNDk5MWFjYmNmOWE4ZjgzMzFiNDMgPSAkKGA8ZGl2IGlkPSJodG1sXzgyYjMzYTVkYjFjZTQ5OTFhY2JjZjlhOGY4MzMxYjQzIiBzdHlsZT0id2lkdGg6IDEwMC4wJTsgaGVpZ2h0OiAxMDAuMCU7Ij5OYW1lOiBTV0VERSBESVRDSCBQcmVjaXA6IDAuMDA8L2Rpdj5gKVswXTsKICAgICAgICAgICAgcG9wdXBfNzM3ODVhMzFlNGZlNDk4M2IwYTFkOTQyZjc3ZjNmZGIuc2V0Q29udGVudChodG1sXzgyYjMzYTVkYjFjZTQ5OTFhY2JjZjlhOGY4MzMxYjQzKTsKICAgICAgICAKCiAgICAgICAgbWFya2VyXzMzNDE0YmYwNzQ2NzQ2NmM4MDJhNWNmYTU1ZjdjYWZiLmJpbmRQb3B1cChwb3B1cF83Mzc4NWEzMWU0ZmU0OTgzYjBhMWQ5NDJmNzdmM2ZkYikKICAgICAgICA7CgogICAgICAgIAogICAgCiAgICAKICAgICAgICAgICAgdmFyIG1hcmtlcl80OTFhMGU0ZGI2NGM0OGUxYWM1ZjQ5MWY4OTFhMzA3NCA9IEwubWFya2VyKAogICAgICAgICAgICAgICAgWzQwLjE4NzUyNCwgLTEwNS4xODkxMzJdLAogICAgICAgICAgICAgICAge30KICAgICAgICAgICAgKS5hZGRUbyhtYXJrZXJfY2x1c3Rlcl80MDZiODVhZGE2OTM0YjA4YWFmNjBkYTIyZmZiZWRkMyk7CiAgICAgICAgCiAgICAKICAgICAgICB2YXIgcG9wdXBfNDUzZWY3MzZkZTVjNGNkOTg1ZTFmZDA2NGRiYWE5MDcgPSBMLnBvcHVwKHsibWF4V2lkdGgiOiAiMTAwJSJ9KTsKCiAgICAgICAgCiAgICAgICAgICAgIHZhciBodG1sXzYwZWY1OTRiYmY1NjQ4NGU4ZWUyMzA2MWM5N2JlNTMzID0gJChgPGRpdiBpZD0iaHRtbF82MGVmNTk0YmJmNTY0ODRlOGVlMjMwNjFjOTdiZTUzMyIgc3R5bGU9IndpZHRoOiAxMDAuMCU7IGhlaWdodDogMTAwLjAlOyI+TmFtZTogUlVOWU9OIERJVENIIFByZWNpcDogMC4wMDwvZGl2PmApWzBdOwogICAgICAgICAgICBwb3B1cF80NTNlZjczNmRlNWM0Y2Q5ODVlMWZkMDY0ZGJhYTkwNy5zZXRDb250ZW50KGh0bWxfNjBlZjU5NGJiZjU2NDg0ZThlZTIzMDYxYzk3YmU1MzMpOwogICAgICAgIAoKICAgICAgICBtYXJrZXJfNDkxYTBlNGRiNjRjNDhlMWFjNWY0OTFmODkxYTMwNzQuYmluZFBvcHVwKHBvcHVwXzQ1M2VmNzM2ZGU1YzRjZDk4NWUxZmQwNjRkYmFhOTA3KQogICAgICAgIDsKCiAgICAgICAgCiAgICAKICAgIAogICAgICAgICAgICB2YXIgbWFya2VyX2M0ZTY3NmU1OWNjZDRlMjE4YTU5ZmJhOWY0ZDNhNGZiID0gTC5tYXJrZXIoCiAgICAgICAgICAgICAgICBbNDAuMTgxODgsIC0xMDUuMTk2Nzc1XSwKICAgICAgICAgICAgICAgIHt9CiAgICAgICAgICAgICkuYWRkVG8obWFya2VyX2NsdXN0ZXJfNDA2Yjg1YWRhNjkzNGIwOGFhZjYwZGEyMmZmYmVkZDMpOwogICAgICAgIAogICAgCiAgICAgICAgdmFyIHBvcHVwXzNlYWFiODNjMGVjODQ2NWE5OThlNmFkNmIxMjM0ZmVmID0gTC5wb3B1cCh7Im1heFdpZHRoIjogIjEwMCUifSk7CgogICAgICAgIAogICAgICAgICAgICB2YXIgaHRtbF9iNDkyNGQwOTJjZjI0ZTY5YWVhNTYyZjA2NmE0MTRjYSA9ICQoYDxkaXYgaWQ9Imh0bWxfYjQ5MjRkMDkyY2YyNGU2OWFlYTU2MmYwNjZhNDE0Y2EiIHN0eWxlPSJ3aWR0aDogMTAwLjAlOyBoZWlnaHQ6IDEwMC4wJTsiPk5hbWU6IERBVklTIEFORCBET1dOSU5HIERJVENIIFByZWNpcDogMC4wMDwvZGl2PmApWzBdOwogICAgICAgICAgICBwb3B1cF8zZWFhYjgzYzBlYzg0NjVhOTk4ZTZhZDZiMTIzNGZlZi5zZXRDb250ZW50KGh0bWxfYjQ5MjRkMDkyY2YyNGU2OWFlYTU2MmYwNjZhNDE0Y2EpOwogICAgICAgIAoKICAgICAgICBtYXJrZXJfYzRlNjc2ZTU5Y2NkNGUyMThhNTlmYmE5ZjRkM2E0ZmIuYmluZFBvcHVwKHBvcHVwXzNlYWFiODNjMGVjODQ2NWE5OThlNmFkNmIxMjM0ZmVmKQogICAgICAgIDsKCiAgICAgICAgCiAgICAKICAgIAogICAgICAgICAgICB2YXIgbWFya2VyX2QyOThkYTgzZDkyYjQzMWQ4YmFkNTEzN2UxMDhiZjVhID0gTC5tYXJrZXIoCiAgICAgICAgICAgICAgICBbNDAuMDE4NjY3LCAtMTA1LjMyNjI1XSwKICAgICAgICAgICAgICAgIHt9CiAgICAgICAgICAgICkuYWRkVG8obWFya2VyX2NsdXN0ZXJfNDA2Yjg1YWRhNjkzNGIwOGFhZjYwZGEyMmZmYmVkZDMpOwogICAgICAgIAogICAgCiAgICAgICAgdmFyIHBvcHVwXzE0MzU2MDllYTU2ZjQxM2Y5M2MxZDAyYzI5MzZiMDdkID0gTC5wb3B1cCh7Im1heFdpZHRoIjogIjEwMCUifSk7CgogICAgICAgIAogICAgICAgICAgICB2YXIgaHRtbF8xYmU1ODUzZjYzNTc0YjAzOWQ4NTk0ZTJiNjMxMTJhMCA9ICQoYDxkaXYgaWQ9Imh0bWxfMWJlNTg1M2Y2MzU3NGIwMzlkODU5NGUyYjYzMTEyYTAiIHN0eWxlPSJ3aWR0aDogMTAwLjAlOyBoZWlnaHQ6IDEwMC4wJTsiPk5hbWU6IEZPVVJNSUxFIENSRUVLIEFUIE9ST0RFTEwsIENPIFByZWNpcDogMC43NDwvZGl2PmApWzBdOwogICAgICAgICAgICBwb3B1cF8xNDM1NjA5ZWE1NmY0MTNmOTNjMWQwMmMyOTM2YjA3ZC5zZXRDb250ZW50KGh0bWxfMWJlNTg1M2Y2MzU3NGIwMzlkODU5NGUyYjYzMTEyYTApOwogICAgICAgIAoKICAgICAgICBtYXJrZXJfZDI5OGRhODNkOTJiNDMxZDhiYWQ1MTM3ZTEwOGJmNWEuYmluZFBvcHVwKHBvcHVwXzE0MzU2MDllYTU2ZjQxM2Y5M2MxZDAyYzI5MzZiMDdkKQogICAgICAgIDsKCiAgICAgICAgCiAgICAKICAgIAogICAgICAgICAgICB2YXIgbWFya2VyX2ZmNzU1M2EzODA5ODRjZDQ4YjhiZGZkOGFhY2MzNTU4ID0gTC5tYXJrZXIoCiAgICAgICAgICAgICAgICBbNDAuMTg4NTc5LCAtMTA1LjIwOTI4Ml0sCiAgICAgICAgICAgICAgICB7fQogICAgICAgICAgICApLmFkZFRvKG1hcmtlcl9jbHVzdGVyXzQwNmI4NWFkYTY5MzRiMDhhYWY2MGRhMjJmZmJlZGQzKTsKICAgICAgICAKICAgIAogICAgICAgIHZhciBwb3B1cF9iNTMzMWE0ZDI4MmE0ZTJmOGMwZWIyYTIzZmRjOGY0ZiA9IEwucG9wdXAoeyJtYXhXaWR0aCI6ICIxMDAlIn0pOwoKICAgICAgICAKICAgICAgICAgICAgdmFyIGh0bWxfOTMxN2FjYzQxMWI3NDMxZjhlZWFjZDNkNzYzOWUzYzkgPSAkKGA8ZGl2IGlkPSJodG1sXzkzMTdhY2M0MTFiNzQzMWY4ZWVhY2QzZDc2MzllM2M5IiBzdHlsZT0id2lkdGg6IDEwMC4wJTsgaGVpZ2h0OiAxMDAuMCU7Ij5OYW1lOiBKQU1FUyBESVRDSCBQcmVjaXA6IDAuMDA8L2Rpdj5gKVswXTsKICAgICAgICAgICAgcG9wdXBfYjUzMzFhNGQyODJhNGUyZjhjMGViMmEyM2ZkYzhmNGYuc2V0Q29udGVudChodG1sXzkzMTdhY2M0MTFiNzQzMWY4ZWVhY2QzZDc2MzllM2M5KTsKICAgICAgICAKCiAgICAgICAgbWFya2VyX2ZmNzU1M2EzODA5ODRjZDQ4YjhiZGZkOGFhY2MzNTU4LmJpbmRQb3B1cChwb3B1cF9iNTMzMWE0ZDI4MmE0ZTJmOGMwZWIyYTIzZmRjOGY0ZikKICAgICAgICA7CgogICAgICAgIAogICAgCiAgICAKICAgICAgICAgICAgdmFyIG1hcmtlcl8xYjUzNjI1NGE1NmI0MTNmOGE0ZmRiZmMwOWI4Mjc3ZCA9IEwubWFya2VyKAogICAgICAgICAgICAgICAgWzQwLjA1MzAzNSwgLTEwNS4xOTMwNDhdLAogICAgICAgICAgICAgICAge30KICAgICAgICAgICAgKS5hZGRUbyhtYXJrZXJfY2x1c3Rlcl80MDZiODVhZGE2OTM0YjA4YWFmNjBkYTIyZmZiZWRkMyk7CiAgICAgICAgCiAgICAKICAgICAgICB2YXIgcG9wdXBfNDk4ZTJhNThlN2I3NGI1OGI1MGM2MjIzYWVlNjA4ZjQgPSBMLnBvcHVwKHsibWF4V2lkdGgiOiAiMTAwJSJ9KTsKCiAgICAgICAgCiAgICAgICAgICAgIHZhciBodG1sX2M2MjA1OTIzNjAyYzQ3MjY5NmFiNmJhNzYwMTBjODI5ID0gJChgPGRpdiBpZD0iaHRtbF9jNjIwNTkyMzYwMmM0NzI2OTZhYjZiYTc2MDEwYzgyOSIgc3R5bGU9IndpZHRoOiAxMDAuMCU7IGhlaWdodDogMTAwLjAlOyI+TmFtZTogQk9VTERFUiBDUkVFSyBTVVBQTFkgQ0FOQUwgVE8gQk9VTERFUiBDUkVFSyBORUFSIEJPVUxERVIgUHJlY2lwOiAxMC41OTwvZGl2PmApWzBdOwogICAgICAgICAgICBwb3B1cF80OThlMmE1OGU3Yjc0YjU4YjUwYzYyMjNhZWU2MDhmNC5zZXRDb250ZW50KGh0bWxfYzYyMDU5MjM2MDJjNDcyNjk2YWI2YmE3NjAxMGM4MjkpOwogICAgICAgIAoKICAgICAgICBtYXJrZXJfMWI1MzYyNTRhNTZiNDEzZjhhNGZkYmZjMDliODI3N2QuYmluZFBvcHVwKHBvcHVwXzQ5OGUyYTU4ZTdiNzRiNThiNTBjNjIyM2FlZTYwOGY0KQogICAgICAgIDsKCiAgICAgICAgCiAgICAKICAgIAogICAgICAgICAgICB2YXIgbWFya2VyX2FmNjY0YzNlMzM2NzQwMGI5YzA1YzU5NzUwOGM0ZTk2ID0gTC5tYXJrZXIoCiAgICAgICAgICAgICAgICBbNDAuMTc3NDIzLCAtMTA1LjE3ODE0NV0sCiAgICAgICAgICAgICAgICB7fQogICAgICAgICAgICApLmFkZFRvKG1hcmtlcl9jbHVzdGVyXzQwNmI4NWFkYTY5MzRiMDhhYWY2MGRhMjJmZmJlZGQzKTsKICAgICAgICAKICAgIAogICAgICAgIHZhciBwb3B1cF82MWM4OTJlZWFhZjM0OGY1YjA2NjMxZjliZWZjNWJlZSA9IEwucG9wdXAoeyJtYXhXaWR0aCI6ICIxMDAlIn0pOwoKICAgICAgICAKICAgICAgICAgICAgdmFyIGh0bWxfOTgyNDU0OGU0ZTUzNDJhYmEwNjY5Mjg1ODM3OTFjM2QgPSAkKGA8ZGl2IGlkPSJodG1sXzk4MjQ1NDhlNGU1MzQyYWJhMDY2OTI4NTgzNzkxYzNkIiBzdHlsZT0id2lkdGg6IDEwMC4wJTsgaGVpZ2h0OiAxMDAuMCU7Ij5OYW1lOiBTQUlOVCBWUkFJTiBDUkVFSyBBVCBIWUdJRU5FLCBDTyBQcmVjaXA6IDIuMTQ8L2Rpdj5gKVswXTsKICAgICAgICAgICAgcG9wdXBfNjFjODkyZWVhYWYzNDhmNWIwNjYzMWY5YmVmYzViZWUuc2V0Q29udGVudChodG1sXzk4MjQ1NDhlNGU1MzQyYWJhMDY2OTI4NTgzNzkxYzNkKTsKICAgICAgICAKCiAgICAgICAgbWFya2VyX2FmNjY0YzNlMzM2NzQwMGI5YzA1YzU5NzUwOGM0ZTk2LmJpbmRQb3B1cChwb3B1cF82MWM4OTJlZWFhZjM0OGY1YjA2NjMxZjliZWZjNWJlZSkKICAgICAgICA7CgogICAgICAgIAogICAgCiAgICAKICAgICAgICAgICAgdmFyIG1hcmtlcl83Mzc5ZTZiZDgzNTI0MGQ3YjU1Njg1ZTY1YjZkNTgzNiA9IEwubWFya2VyKAogICAgICAgICAgICAgICAgWzQwLjI1ODM2NywgLTEwNS4xNzQ5NTddLAogICAgICAgICAgICAgICAge30KICAgICAgICAgICAgKS5hZGRUbyhtYXJrZXJfY2x1c3Rlcl80MDZiODVhZGE2OTM0YjA4YWFmNjBkYTIyZmZiZWRkMyk7CiAgICAgICAgCiAgICAKICAgICAgICB2YXIgcG9wdXBfNTU4ZDhiNDM1OGJiNDFjYjljYTk4YjQ3MzgzNDAzZWQgPSBMLnBvcHVwKHsibWF4V2lkdGgiOiAiMTAwJSJ9KTsKCiAgICAgICAgCiAgICAgICAgICAgIHZhciBodG1sXzMyN2M5NmFjOGFkNTRiYmY5NTM5ODE1ZDNkMzI0ZmEyID0gJChgPGRpdiBpZD0iaHRtbF8zMjdjOTZhYzhhZDU0YmJmOTUzOTgxNWQzZDMyNGZhMiIgc3R5bGU9IndpZHRoOiAxMDAuMCU7IGhlaWdodDogMTAwLjAlOyI+TmFtZTogQk9VTERFUi1MQVJJTUVSIERJVENIIE5FQVIgQkVSVEhPVUQgUHJlY2lwOiAwLjAwPC9kaXY+YClbMF07CiAgICAgICAgICAgIHBvcHVwXzU1OGQ4YjQzNThiYjQxY2I5Y2E5OGI0NzM4MzQwM2VkLnNldENvbnRlbnQoaHRtbF8zMjdjOTZhYzhhZDU0YmJmOTUzOTgxNWQzZDMyNGZhMik7CiAgICAgICAgCgogICAgICAgIG1hcmtlcl83Mzc5ZTZiZDgzNTI0MGQ3YjU1Njg1ZTY1YjZkNTgzNi5iaW5kUG9wdXAocG9wdXBfNTU4ZDhiNDM1OGJiNDFjYjljYTk4YjQ3MzgzNDAzZWQpCiAgICAgICAgOwoKICAgICAgICAKICAgIAogICAgCiAgICAgICAgICAgIHZhciBtYXJrZXJfY2NhZTExZWM2Nzc0NDhkMDg4NDNlOTc1MDkwMGE3MzcgPSBMLm1hcmtlcigKICAgICAgICAgICAgICAgIFs0MC4wODc1ODMsIC0xMDUuMDcyNTAyXSwKICAgICAgICAgICAgICAgIHt9CiAgICAgICAgICAgICkuYWRkVG8obWFya2VyX2NsdXN0ZXJfNDA2Yjg1YWRhNjkzNGIwOGFhZjYwZGEyMmZmYmVkZDMpOwogICAgICAgIAogICAgCiAgICAgICAgdmFyIHBvcHVwX2NiZDM0ODgxMjM3MTRlMGE5ZjNjMTMzODBhN2EzNDAxID0gTC5wb3B1cCh7Im1heFdpZHRoIjogIjEwMCUifSk7CgogICAgICAgIAogICAgICAgICAgICB2YXIgaHRtbF82NzI1MzU5NDE0MTA0YmRmODdlODk2ZjI5MjIzMGEwNiA9ICQoYDxkaXYgaWQ9Imh0bWxfNjcyNTM1OTQxNDEwNGJkZjg3ZTg5NmYyOTIyMzBhMDYiIHN0eWxlPSJ3aWR0aDogMTAwLjAlOyBoZWlnaHQ6IDEwMC4wJTsiPk5hbWU6IFBBTkFNQSBSRVNFUlZPSVIgT1VUTEVUIFByZWNpcDogMC4wNTwvZGl2PmApWzBdOwogICAgICAgICAgICBwb3B1cF9jYmQzNDg4MTIzNzE0ZTBhOWYzYzEzMzgwYTdhMzQwMS5zZXRDb250ZW50KGh0bWxfNjcyNTM1OTQxNDEwNGJkZjg3ZTg5NmYyOTIyMzBhMDYpOwogICAgICAgIAoKICAgICAgICBtYXJrZXJfY2NhZTExZWM2Nzc0NDhkMDg4NDNlOTc1MDkwMGE3MzcuYmluZFBvcHVwKHBvcHVwX2NiZDM0ODgxMjM3MTRlMGE5ZjNjMTMzODBhN2EzNDAxKQogICAgICAgIDsKCiAgICAgICAgCiAgICAKICAgIAogICAgICAgICAgICB2YXIgbWFya2VyX2QzODcyYzJiNTJiMDQ2YWRiZmE3OGFhYmZmMjMyYWRhID0gTC5tYXJrZXIoCiAgICAgICAgICAgICAgICBbNDAuMjEyNTA1LCAtMTA1LjI1MTgyNl0sCiAgICAgICAgICAgICAgICB7fQogICAgICAgICAgICApLmFkZFRvKG1hcmtlcl9jbHVzdGVyXzQwNmI4NWFkYTY5MzRiMDhhYWY2MGRhMjJmZmJlZGQzKTsKICAgICAgICAKICAgIAogICAgICAgIHZhciBwb3B1cF83OTgwMzBkMzQxZGQ0MDc3ODYwZWNkOTIzNDMwNjU4NiA9IEwucG9wdXAoeyJtYXhXaWR0aCI6ICIxMDAlIn0pOwoKICAgICAgICAKICAgICAgICAgICAgdmFyIGh0bWxfODBiYTIxNTRjYTdlNGY1YzhmMGYwY2M1YTI0MWFiNWQgPSAkKGA8ZGl2IGlkPSJodG1sXzgwYmEyMTU0Y2E3ZTRmNWM4ZjBmMGNjNWEyNDFhYjVkIiBzdHlsZT0id2lkdGg6IDEwMC4wJTsgaGVpZ2h0OiAxMDAuMCU7Ij5OYW1lOiBQQUxNRVJUT04gRElUQ0ggUHJlY2lwOiAwLjI3PC9kaXY+YClbMF07CiAgICAgICAgICAgIHBvcHVwXzc5ODAzMGQzNDFkZDQwNzc4NjBlY2Q5MjM0MzA2NTg2LnNldENvbnRlbnQoaHRtbF84MGJhMjE1NGNhN2U0ZjVjOGYwZjBjYzVhMjQxYWI1ZCk7CiAgICAgICAgCgogICAgICAgIG1hcmtlcl9kMzg3MmMyYjUyYjA0NmFkYmZhNzhhYWJmZjIzMmFkYS5iaW5kUG9wdXAocG9wdXBfNzk4MDMwZDM0MWRkNDA3Nzg2MGVjZDkyMzQzMDY1ODYpCiAgICAgICAgOwoKICAgICAgICAKICAgIAogICAgCiAgICAgICAgICAgIHZhciBtYXJrZXJfOGYyYmExMjM5MWNmNGY0ZTkwODkwMzA3NDBiOTg2YjkgPSBMLm1hcmtlcigKICAgICAgICAgICAgICAgIFs0MC4yMTkwNDYsIC0xMDUuMjU5Nzk1XSwKICAgICAgICAgICAgICAgIHt9CiAgICAgICAgICAgICkuYWRkVG8obWFya2VyX2NsdXN0ZXJfNDA2Yjg1YWRhNjkzNGIwOGFhZjYwZGEyMmZmYmVkZDMpOwogICAgICAgIAogICAgCiAgICAgICAgdmFyIHBvcHVwXzhiZWI1NWYxODI5MzRkMWM4OTkyOWFhZDk1ZGQ3NmRlID0gTC5wb3B1cCh7Im1heFdpZHRoIjogIjEwMCUifSk7CgogICAgICAgIAogICAgICAgICAgICB2YXIgaHRtbF9jODQ5NjM1YTQ3ZDA0OGE0OTI2Mjc5MDFhMWVlMTJmZSA9ICQoYDxkaXYgaWQ9Imh0bWxfYzg0OTYzNWE0N2QwNDhhNDkyNjI3OTAxYTFlZTEyZmUiIHN0eWxlPSJ3aWR0aDogMTAwLjAlOyBoZWlnaHQ6IDEwMC4wJTsiPk5hbWU6IFNVUFBMWSBESVRDSCBQcmVjaXA6IDAuMDA8L2Rpdj5gKVswXTsKICAgICAgICAgICAgcG9wdXBfOGJlYjU1ZjE4MjkzNGQxYzg5OTI5YWFkOTVkZDc2ZGUuc2V0Q29udGVudChodG1sX2M4NDk2MzVhNDdkMDQ4YTQ5MjYyNzkwMWExZWUxMmZlKTsKICAgICAgICAKCiAgICAgICAgbWFya2VyXzhmMmJhMTIzOTFjZjRmNGU5MDg5MDMwNzQwYjk4NmI5LmJpbmRQb3B1cChwb3B1cF84YmViNTVmMTgyOTM0ZDFjODk5MjlhYWQ5NWRkNzZkZSkKICAgICAgICA7CgogICAgICAgIAogICAgCiAgICAKICAgICAgICAgICAgdmFyIG1hcmtlcl8zMDY3NTU5NzJiNTk0NTBhYWVlMzYxMjgwMWU3NDc2OSA9IEwubWFya2VyKAogICAgICAgICAgICAgICAgWzM5LjkzMTU5NywgLTEwNS4zMDQ5OV0sCiAgICAgICAgICAgICAgICB7fQogICAgICAgICAgICApLmFkZFRvKG1hcmtlcl9jbHVzdGVyXzQwNmI4NWFkYTY5MzRiMDhhYWY2MGRhMjJmZmJlZGQzKTsKICAgICAgICAKICAgIAogICAgICAgIHZhciBwb3B1cF8xMjAxMzI0NGVmMjg0Y2I2YWNmZmNmZGNjN2JmYjY1MCA9IEwucG9wdXAoeyJtYXhXaWR0aCI6ICIxMDAlIn0pOwoKICAgICAgICAKICAgICAgICAgICAgdmFyIGh0bWxfMzY3MjlhZmJmYmQ1NGUwNjhhYWY1MzRhY2Y0YjY5ZWYgPSAkKGA8ZGl2IGlkPSJodG1sXzM2NzI5YWZiZmJkNTRlMDY4YWFmNTM0YWNmNGI2OWVmIiBzdHlsZT0id2lkdGg6IDEwMC4wJTsgaGVpZ2h0OiAxMDAuMCU7Ij5OYW1lOiBTT1VUSCBCT1VMREVSIENSRUVLIE5FQVIgRUxET1JBRE8gU1BSSU5HUywgQ08uIFByZWNpcDogMTcuODA8L2Rpdj5gKVswXTsKICAgICAgICAgICAgcG9wdXBfMTIwMTMyNDRlZjI4NGNiNmFjZmZjZmRjYzdiZmI2NTAuc2V0Q29udGVudChodG1sXzM2NzI5YWZiZmJkNTRlMDY4YWFmNTM0YWNmNGI2OWVmKTsKICAgICAgICAKCiAgICAgICAgbWFya2VyXzMwNjc1NTk3MmI1OTQ1MGFhZWUzNjEyODAxZTc0NzY5LmJpbmRQb3B1cChwb3B1cF8xMjAxMzI0NGVmMjg0Y2I2YWNmZmNmZGNjN2JmYjY1MCkKICAgICAgICA7CgogICAgICAgIAogICAgCiAgICAKICAgICAgICAgICAgdmFyIG1hcmtlcl9iNWM1YWI3N2IwN2Y0YjA2OTRjNzc2MGVhM2VhZWJlNyA9IEwubWFya2VyKAogICAgICAgICAgICAgICAgWzQwLjE4NzU3OCwgLTEwNS4xODkxOTFdLAogICAgICAgICAgICAgICAge30KICAgICAgICAgICAgKS5hZGRUbyhtYXJrZXJfY2x1c3Rlcl80MDZiODVhZGE2OTM0YjA4YWFmNjBkYTIyZmZiZWRkMyk7CiAgICAgICAgCiAgICAKICAgICAgICB2YXIgcG9wdXBfNGY1NzdiMmJjNzdiNGFjMWFiODQ0NzVmNTg2Y2YyNzUgPSBMLnBvcHVwKHsibWF4V2lkdGgiOiAiMTAwJSJ9KTsKCiAgICAgICAgCiAgICAgICAgICAgIHZhciBodG1sX2M3MDNhNDNlMDNiOTRlZjU5MjdhZjBiMmE3MWJjYzgyID0gJChgPGRpdiBpZD0iaHRtbF9jNzAzYTQzZTAzYjk0ZWY1OTI3YWYwYjJhNzFiY2M4MiIgc3R5bGU9IndpZHRoOiAxMDAuMCU7IGhlaWdodDogMTAwLjAlOyI+TmFtZTogREVOSU8gVEFZTE9SIERJVENIIFByZWNpcDogMjgxOS42ODwvZGl2PmApWzBdOwogICAgICAgICAgICBwb3B1cF80ZjU3N2IyYmM3N2I0YWMxYWI4NDQ3NWY1ODZjZjI3NS5zZXRDb250ZW50KGh0bWxfYzcwM2E0M2UwM2I5NGVmNTkyN2FmMGIyYTcxYmNjODIpOwogICAgICAgIAoKICAgICAgICBtYXJrZXJfYjVjNWFiNzdiMDdmNGIwNjk0Yzc3NjBlYTNlYWViZTcuYmluZFBvcHVwKHBvcHVwXzRmNTc3YjJiYzc3YjRhYzFhYjg0NDc1ZjU4NmNmMjc1KQogICAgICAgIDsKCiAgICAgICAgCiAgICAKICAgIAogICAgICAgICAgICB2YXIgbWFya2VyX2VhZDNjMjM2Yjk0NjRlZmZhMTNmNWI0ZjM4YmFjMDYwID0gTC5tYXJrZXIoCiAgICAgICAgICAgICAgICBbNDAuMDQyMDI4LCAtMTA1LjM2NDkxN10sCiAgICAgICAgICAgICAgICB7fQogICAgICAgICAgICApLmFkZFRvKG1hcmtlcl9jbHVzdGVyXzQwNmI4NWFkYTY5MzRiMDhhYWY2MGRhMjJmZmJlZGQzKTsKICAgICAgICAKICAgIAogICAgICAgIHZhciBwb3B1cF9iYzMzZmVlMGE3M2Q0OTc5ODJjYzE0NzAxMGU3YjZmMSA9IEwucG9wdXAoeyJtYXhXaWR0aCI6ICIxMDAlIn0pOwoKICAgICAgICAKICAgICAgICAgICAgdmFyIGh0bWxfZjkxZmVhYjk3NTZmNGNlN2JhN2JjYjQ1Njc2NWE4N2QgPSAkKGA8ZGl2IGlkPSJodG1sX2Y5MWZlYWI5NzU2ZjRjZTdiYTdiY2I0NTY3NjVhODdkIiBzdHlsZT0id2lkdGg6IDEwMC4wJTsgaGVpZ2h0OiAxMDAuMCU7Ij5OYW1lOiBGT1VSTUlMRSBDUkVFSyBBVCBMT0dBTiBNSUxMIFJPQUQgTkVBUiBDUklTTUFOLCBDTyBQcmVjaXA6IG5hbjwvZGl2PmApWzBdOwogICAgICAgICAgICBwb3B1cF9iYzMzZmVlMGE3M2Q0OTc5ODJjYzE0NzAxMGU3YjZmMS5zZXRDb250ZW50KGh0bWxfZjkxZmVhYjk3NTZmNGNlN2JhN2JjYjQ1Njc2NWE4N2QpOwogICAgICAgIAoKICAgICAgICBtYXJrZXJfZWFkM2MyMzZiOTQ2NGVmZmExM2Y1YjRmMzhiYWMwNjAuYmluZFBvcHVwKHBvcHVwX2JjMzNmZWUwYTczZDQ5Nzk4MmNjMTQ3MDEwZTdiNmYxKQogICAgICAgIDsKCiAgICAgICAgCiAgICAKICAgIAogICAgICAgICAgICB2YXIgbWFya2VyXzQxYTg1NzE3NjZlOTQ4MzRiMjkyMDA0ZDA4MzBjMzRlID0gTC5tYXJrZXIoCiAgICAgICAgICAgICAgICBbNDAuMTc3MDgsIC0xMDUuMTc4NTY3XSwKICAgICAgICAgICAgICAgIHt9CiAgICAgICAgICAgICkuYWRkVG8obWFya2VyX2NsdXN0ZXJfNDA2Yjg1YWRhNjkzNGIwOGFhZjYwZGEyMmZmYmVkZDMpOwogICAgICAgIAogICAgCiAgICAgICAgdmFyIHBvcHVwXzg3YWI2ZWZlMDdmZDRlN2M5OWI2YzZkNmQ2NTFlOTY5ID0gTC5wb3B1cCh7Im1heFdpZHRoIjogIjEwMCUifSk7CgogICAgICAgIAogICAgICAgICAgICB2YXIgaHRtbF84MjE2NzAyZWVlYWU0MDgyYTcyMmQ4MDRhYWExODRlZiA9ICQoYDxkaXYgaWQ9Imh0bWxfODIxNjcwMmVlZWFlNDA4MmE3MjJkODA0YWFhMTg0ZWYiIHN0eWxlPSJ3aWR0aDogMTAwLjAlOyBoZWlnaHQ6IDEwMC4wJTsiPk5hbWU6IFBFQ0sgUEVMTEEgQ0xPVkVSIERJVENIIFByZWNpcDogMS4yOTwvZGl2PmApWzBdOwogICAgICAgICAgICBwb3B1cF84N2FiNmVmZTA3ZmQ0ZTdjOTliNmM2ZDZkNjUxZTk2OS5zZXRDb250ZW50KGh0bWxfODIxNjcwMmVlZWFlNDA4MmE3MjJkODA0YWFhMTg0ZWYpOwogICAgICAgIAoKICAgICAgICBtYXJrZXJfNDFhODU3MTc2NmU5NDgzNGIyOTIwMDRkMDgzMGMzNGUuYmluZFBvcHVwKHBvcHVwXzg3YWI2ZWZlMDdmZDRlN2M5OWI2YzZkNmQ2NTFlOTY5KQogICAgICAgIDsKCiAgICAgICAgCiAgICAKICAgIAogICAgICAgICAgICB2YXIgbWFya2VyXzcyN2Y0ZGMwNjgxMTQ0MzU4YmEzYjU3NGQxZWYxODVlID0gTC5tYXJrZXIoCiAgICAgICAgICAgICAgICBbMzkuOTQ3NzA0LCAtMTA1LjM1NzMwOF0sCiAgICAgICAgICAgICAgICB7fQogICAgICAgICAgICApLmFkZFRvKG1hcmtlcl9jbHVzdGVyXzQwNmI4NWFkYTY5MzRiMDhhYWY2MGRhMjJmZmJlZGQzKTsKICAgICAgICAKICAgIAogICAgICAgIHZhciBwb3B1cF83MWZmOWNlMDEzYzA0OTJjODJiNWYyZGU5N2IxOGMxZSA9IEwucG9wdXAoeyJtYXhXaWR0aCI6ICIxMDAlIn0pOwoKICAgICAgICAKICAgICAgICAgICAgdmFyIGh0bWxfNDcxNzc0ZDhlNjA2NGQ2YTgwZjIwODJlMmE3NjAxYjkgPSAkKGA8ZGl2IGlkPSJodG1sXzQ3MTc3NGQ4ZTYwNjRkNmE4MGYyMDgyZTJhNzYwMWI5IiBzdHlsZT0id2lkdGg6IDEwMC4wJTsgaGVpZ2h0OiAxMDAuMCU7Ij5OYW1lOiBHUk9TUyBSRVNFUlZPSVIgIFByZWNpcDogMTEzOTguMDA8L2Rpdj5gKVswXTsKICAgICAgICAgICAgcG9wdXBfNzFmZjljZTAxM2MwNDkyYzgyYjVmMmRlOTdiMThjMWUuc2V0Q29udGVudChodG1sXzQ3MTc3NGQ4ZTYwNjRkNmE4MGYyMDgyZTJhNzYwMWI5KTsKICAgICAgICAKCiAgICAgICAgbWFya2VyXzcyN2Y0ZGMwNjgxMTQ0MzU4YmEzYjU3NGQxZWYxODVlLmJpbmRQb3B1cChwb3B1cF83MWZmOWNlMDEzYzA0OTJjODJiNWYyZGU5N2IxOGMxZSkKICAgICAgICA7CgogICAgICAgIAogICAgCjwvc2NyaXB0Pg==" style="position:absolute;width:100%;height:100%;left:0;top:0;border:none !important;" allowfullscreen webkitallowfullscreen mozallowfullscreen></iframe></div></div>





<div class="notice--info" markdown="1">

## Additional Resources

* <a href="https://blog.datafiniti.co/4-reasons-you-should-use-json-instead-of-csv-2cac362f1943" target="_blank">Why you should use JSON instead of csv.</a>


* <a href="https://www.w3schools.com/js/js_json_intro.asp" target="_blank">W3schools JSON intro </a>

</div>

