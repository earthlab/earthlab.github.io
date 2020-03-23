---
layout: single
title: 'Programmatically Accessing Geospatial Data Using APIs'
excerpt: 'This lesson walks through the process of retrieving and manipulating surface water data housed in the Colorado Information Warehouse. These data are stored in JSON format with spatial x, y information that support mapping.'
authors: ['Carson Farmer', 'Leah Wasser', 'Max Joseph', 'Martha Morrissey', 'Jenny Palomino']
modified: 2020-03-23
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
      'date_time': '2020-03-23T12:00:00.000',
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
      'amount': '37.90',
      'station_type': 'Stream',
      'wd': '5',
      'http_linkage': {'url': 'https://dwr.state.co.us/SurfaceWater/data/detail_graph.aspx?ID=SVCLYOCO&MTYPE=DISCHRG'},
      'date_time': '2020-03-23T12:15:00.000',
      'county': 'BOULDER',
      'variable': 'DISCHRG',
      'stage': '2.96',
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
      <td>2020-03-23T12:00:00.000</td>
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
      <td>37.90</td>
      <td>Stream</td>
      <td>5</td>
      <td>2020-03-23T12:15:00.000</td>
      <td>BOULDER</td>
      <td>DISCHRG</td>
      <td>2.96</td>
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
      <td>9.46</td>
      <td>Diversion</td>
      <td>5</td>
      <td>2020-03-23T10:45:00.000</td>
      <td>BOULDER</td>
      <td>DISCHRG</td>
      <td>0.41</td>
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
      <td>2020-03-23T12:30:00.000</td>
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
      <td>2020-03-23T12:00:00.000</td>
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
      <td>0.14</td>
      <td>Diversion</td>
      <td>5</td>
      <td>2020-03-23T12:00:00.000</td>
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
      <td>37.90</td>
      <td>Stream</td>
      <td>5</td>
      <td>2020-03-23T12:15:00.000</td>
      <td>BOULDER</td>
      <td>DISCHRG</td>
      <td>2.96</td>
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
      <td>9.46</td>
      <td>Diversion</td>
      <td>5</td>
      <td>2020-03-23T10:45:00.000</td>
      <td>BOULDER</td>
      <td>DISCHRG</td>
      <td>0.41</td>
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
      <td>2020-03-23T12:30:00.000</td>
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
      <td>2020-03-23T12:00:00.000</td>
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



<div style="width:100%;"><div style="position:relative;width:100%;height:0;padding-bottom:60%;"><iframe src="about:blank" style="position:absolute;width:100%;height:100%;left:0;top:0;border:none !important;" data-html=PCFET0NUWVBFIGh0bWw+CjxoZWFkPiAgICAKICAgIDxtZXRhIGh0dHAtZXF1aXY9ImNvbnRlbnQtdHlwZSIgY29udGVudD0idGV4dC9odG1sOyBjaGFyc2V0PVVURi04IiAvPgogICAgCiAgICAgICAgPHNjcmlwdD4KICAgICAgICAgICAgTF9OT19UT1VDSCA9IGZhbHNlOwogICAgICAgICAgICBMX0RJU0FCTEVfM0QgPSBmYWxzZTsKICAgICAgICA8L3NjcmlwdD4KICAgIAogICAgPHNjcmlwdCBzcmM9Imh0dHBzOi8vY2RuLmpzZGVsaXZyLm5ldC9ucG0vbGVhZmxldEAxLjUuMS9kaXN0L2xlYWZsZXQuanMiPjwvc2NyaXB0PgogICAgPHNjcmlwdCBzcmM9Imh0dHBzOi8vY29kZS5qcXVlcnkuY29tL2pxdWVyeS0xLjEyLjQubWluLmpzIj48L3NjcmlwdD4KICAgIDxzY3JpcHQgc3JjPSJodHRwczovL21heGNkbi5ib290c3RyYXBjZG4uY29tL2Jvb3RzdHJhcC8zLjIuMC9qcy9ib290c3RyYXAubWluLmpzIj48L3NjcmlwdD4KICAgIDxzY3JpcHQgc3JjPSJodHRwczovL2NkbmpzLmNsb3VkZmxhcmUuY29tL2FqYXgvbGlicy9MZWFmbGV0LmF3ZXNvbWUtbWFya2Vycy8yLjAuMi9sZWFmbGV0LmF3ZXNvbWUtbWFya2Vycy5qcyI+PC9zY3JpcHQ+CiAgICA8bGluayByZWw9InN0eWxlc2hlZXQiIGhyZWY9Imh0dHBzOi8vY2RuLmpzZGVsaXZyLm5ldC9ucG0vbGVhZmxldEAxLjUuMS9kaXN0L2xlYWZsZXQuY3NzIi8+CiAgICA8bGluayByZWw9InN0eWxlc2hlZXQiIGhyZWY9Imh0dHBzOi8vbWF4Y2RuLmJvb3RzdHJhcGNkbi5jb20vYm9vdHN0cmFwLzMuMi4wL2Nzcy9ib290c3RyYXAubWluLmNzcyIvPgogICAgPGxpbmsgcmVsPSJzdHlsZXNoZWV0IiBocmVmPSJodHRwczovL21heGNkbi5ib290c3RyYXBjZG4uY29tL2Jvb3RzdHJhcC8zLjIuMC9jc3MvYm9vdHN0cmFwLXRoZW1lLm1pbi5jc3MiLz4KICAgIDxsaW5rIHJlbD0ic3R5bGVzaGVldCIgaHJlZj0iaHR0cHM6Ly9tYXhjZG4uYm9vdHN0cmFwY2RuLmNvbS9mb250LWF3ZXNvbWUvNC42LjMvY3NzL2ZvbnQtYXdlc29tZS5taW4uY3NzIi8+CiAgICA8bGluayByZWw9InN0eWxlc2hlZXQiIGhyZWY9Imh0dHBzOi8vY2RuanMuY2xvdWRmbGFyZS5jb20vYWpheC9saWJzL0xlYWZsZXQuYXdlc29tZS1tYXJrZXJzLzIuMC4yL2xlYWZsZXQuYXdlc29tZS1tYXJrZXJzLmNzcyIvPgogICAgPGxpbmsgcmVsPSJzdHlsZXNoZWV0IiBocmVmPSJodHRwczovL3Jhd2Nkbi5naXRoYWNrLmNvbS9weXRob24tdmlzdWFsaXphdGlvbi9mb2xpdW0vbWFzdGVyL2ZvbGl1bS90ZW1wbGF0ZXMvbGVhZmxldC5hd2Vzb21lLnJvdGF0ZS5jc3MiLz4KICAgIDxzdHlsZT5odG1sLCBib2R5IHt3aWR0aDogMTAwJTtoZWlnaHQ6IDEwMCU7bWFyZ2luOiAwO3BhZGRpbmc6IDA7fTwvc3R5bGU+CiAgICA8c3R5bGU+I21hcCB7cG9zaXRpb246YWJzb2x1dGU7dG9wOjA7Ym90dG9tOjA7cmlnaHQ6MDtsZWZ0OjA7fTwvc3R5bGU+CiAgICAKICAgICAgICAgICAgPG1ldGEgbmFtZT0idmlld3BvcnQiIGNvbnRlbnQ9IndpZHRoPWRldmljZS13aWR0aCwKICAgICAgICAgICAgICAgIGluaXRpYWwtc2NhbGU9MS4wLCBtYXhpbXVtLXNjYWxlPTEuMCwgdXNlci1zY2FsYWJsZT1ubyIgLz4KICAgICAgICAgICAgPHN0eWxlPgogICAgICAgICAgICAgICAgI21hcF9kZjVkZjkzN2IyNDI0MjgxOTFlMDA0ZDMzYzczNjRjMyB7CiAgICAgICAgICAgICAgICAgICAgcG9zaXRpb246IHJlbGF0aXZlOwogICAgICAgICAgICAgICAgICAgIHdpZHRoOiAxMDAuMCU7CiAgICAgICAgICAgICAgICAgICAgaGVpZ2h0OiAxMDAuMCU7CiAgICAgICAgICAgICAgICAgICAgbGVmdDogMC4wJTsKICAgICAgICAgICAgICAgICAgICB0b3A6IDAuMCU7CiAgICAgICAgICAgICAgICB9CiAgICAgICAgICAgIDwvc3R5bGU+CiAgICAgICAgCjwvaGVhZD4KPGJvZHk+ICAgIAogICAgCiAgICAgICAgICAgIDxkaXYgY2xhc3M9ImZvbGl1bS1tYXAiIGlkPSJtYXBfZGY1ZGY5MzdiMjQyNDI4MTkxZTAwNGQzM2M3MzY0YzMiID48L2Rpdj4KICAgICAgICAKPC9ib2R5Pgo8c2NyaXB0PiAgICAKICAgIAogICAgICAgICAgICB2YXIgbWFwX2RmNWRmOTM3YjI0MjQyODE5MWUwMDRkMzNjNzM2NGMzID0gTC5tYXAoCiAgICAgICAgICAgICAgICAibWFwX2RmNWRmOTM3YjI0MjQyODE5MWUwMDRkMzNjNzM2NGMzIiwKICAgICAgICAgICAgICAgIHsKICAgICAgICAgICAgICAgICAgICBjZW50ZXI6IFs0MC4wMSwgLTEwNS4yN10sCiAgICAgICAgICAgICAgICAgICAgY3JzOiBMLkNSUy5FUFNHMzg1NywKICAgICAgICAgICAgICAgICAgICB6b29tOiAxMCwKICAgICAgICAgICAgICAgICAgICB6b29tQ29udHJvbDogdHJ1ZSwKICAgICAgICAgICAgICAgICAgICBwcmVmZXJDYW52YXM6IGZhbHNlLAogICAgICAgICAgICAgICAgfQogICAgICAgICAgICApOwoKICAgICAgICAgICAgCgogICAgICAgIAogICAgCiAgICAgICAgICAgIHZhciB0aWxlX2xheWVyXzNiOTI5ZWZkOTYxZDQxMzk4ZGUyNTBmNmEzNGZmZDY3ID0gTC50aWxlTGF5ZXIoCiAgICAgICAgICAgICAgICAiaHR0cHM6Ly9jYXJ0b2RiLWJhc2VtYXBzLXtzfS5nbG9iYWwuc3NsLmZhc3RseS5uZXQvbGlnaHRfYWxsL3t6fS97eH0ve3l9LnBuZyIsCiAgICAgICAgICAgICAgICB7ImF0dHJpYnV0aW9uIjogIlx1MDAyNmNvcHk7IFx1MDAzY2EgaHJlZj1cImh0dHA6Ly93d3cub3BlbnN0cmVldG1hcC5vcmcvY29weXJpZ2h0XCJcdTAwM2VPcGVuU3RyZWV0TWFwXHUwMDNjL2FcdTAwM2UgY29udHJpYnV0b3JzIFx1MDAyNmNvcHk7IFx1MDAzY2EgaHJlZj1cImh0dHA6Ly9jYXJ0b2RiLmNvbS9hdHRyaWJ1dGlvbnNcIlx1MDAzZUNhcnRvREJcdTAwM2MvYVx1MDAzZSwgQ2FydG9EQiBcdTAwM2NhIGhyZWYgPVwiaHR0cDovL2NhcnRvZGIuY29tL2F0dHJpYnV0aW9uc1wiXHUwMDNlYXR0cmlidXRpb25zXHUwMDNjL2FcdTAwM2UiLCAiZGV0ZWN0UmV0aW5hIjogZmFsc2UsICJtYXhOYXRpdmVab29tIjogMTgsICJtYXhab29tIjogMTgsICJtaW5ab29tIjogMCwgIm5vV3JhcCI6IGZhbHNlLCAib3BhY2l0eSI6IDEsICJzdWJkb21haW5zIjogImFiYyIsICJ0bXMiOiBmYWxzZX0KICAgICAgICAgICAgKS5hZGRUbyhtYXBfZGY1ZGY5MzdiMjQyNDI4MTkxZTAwNGQzM2M3MzY0YzMpOwogICAgICAgIAogICAgCiAgICAgICAgZnVuY3Rpb24gZ2VvX2pzb25fMjVjMTEzMTkwNjIxNGY2MDgzYjYzMWRmMTc5MjAwNzdfb25FYWNoRmVhdHVyZShmZWF0dXJlLCBsYXllcikgewogICAgICAgICAgICBsYXllci5vbih7CiAgICAgICAgICAgICAgICBjbGljazogZnVuY3Rpb24oZSkgewogICAgICAgICAgICAgICAgICAgIG1hcF9kZjVkZjkzN2IyNDI0MjgxOTFlMDA0ZDMzYzczNjRjMy5maXRCb3VuZHMoZS50YXJnZXQuZ2V0Qm91bmRzKCkpOwogICAgICAgICAgICAgICAgfQogICAgICAgICAgICB9KTsKICAgICAgICB9OwogICAgICAgIHZhciBnZW9fanNvbl8yNWMxMTMxOTA2MjE0ZjYwODNiNjMxZGYxNzkyMDA3NyA9IEwuZ2VvSnNvbihudWxsLCB7CiAgICAgICAgICAgICAgICBvbkVhY2hGZWF0dXJlOiBnZW9fanNvbl8yNWMxMTMxOTA2MjE0ZjYwODNiNjMxZGYxNzkyMDA3N19vbkVhY2hGZWF0dXJlLAogICAgICAgICAgICAKICAgICAgICB9KTsKICAgICAgICBmdW5jdGlvbiBnZW9fanNvbl8yNWMxMTMxOTA2MjE0ZjYwODNiNjMxZGYxNzkyMDA3N19hZGQgKGRhdGEpIHsKICAgICAgICAgICAgZ2VvX2pzb25fMjVjMTEzMTkwNjIxNGY2MDgzYjYzMWRmMTc5MjAwNzcuYWRkRGF0YShkYXRhKQogICAgICAgICAgICAgICAgLmFkZFRvKG1hcF9kZjVkZjkzN2IyNDI0MjgxOTFlMDA0ZDMzYzczNjRjMyk7CiAgICAgICAgfQogICAgICAgICAgICBnZW9fanNvbl8yNWMxMTMxOTA2MjE0ZjYwODNiNjMxZGYxNzkyMDA3N19hZGQoeyJiYm94IjogWy0xMDUuNTA0NDQsIDM5LjkzMTU5NywgLTEwNS4wNzU2OTUwMDAwMDAwMSwgNDAuMjYwODI3XSwgImZlYXR1cmVzIjogW3siYmJveCI6IFstMTA1LjE4NTc4OSwgNDAuMTg1MDMzLCAtMTA1LjE4NTc4OSwgNDAuMTg1MDMzXSwgImdlb21ldHJ5IjogeyJjb29yZGluYXRlcyI6IFstMTA1LjE4NTc4OSwgNDAuMTg1MDMzXSwgInR5cGUiOiAiUG9pbnQifSwgImlkIjogIjAiLCAicHJvcGVydGllcyI6IHsiYW1vdW50IjogIjAuMTQiLCAiY291bnR5IjogIkJPVUxERVIiLCAiZGF0YV9zb3VyY2UiOiAiQ29vcGVyYXRpdmUgUHJvZ3JhbSBvZiBDRFdSLCBOQ1dDRCBcdTAwMjYgU1ZMSFdDRCIsICJkYXRlX3RpbWUiOiAiMjAyMC0wMy0yM1QxMjowMDowMC4wMDAiLCAiZGl2IjogIjEiLCAiZHdyX2FiYnJldiI6ICJaV0VUVVJDTyIsICJmbGFnIjogbnVsbCwgImh0dHBfbGlua2FnZS51cmwiOiAiaHR0cHM6Ly9kd3Iuc3RhdGUuY28udXMvU3VyZmFjZVdhdGVyL2RhdGEvZGV0YWlsX2dyYXBoLmFzcHg/SUQ9WldFVFVSQ09cdTAwMjZNVFlQRT1ESVNDSFJHIiwgImxvY2F0aW9uLmxhdGl0dWRlIjogNDAuMTg1MDMzLCAibG9jYXRpb24ubG9uZ2l0dWRlIjogLTEwNS4xODU3ODksICJsb2NhdGlvbi5uZWVkc19yZWNvZGluZyI6IGZhbHNlLCAic3RhZ2UiOiAiMC4wNSIsICJzdGF0aW9uX25hbWUiOiAiWldFQ0sgQU5EIFRVUk5FUiBESVRDSCIsICJzdGF0aW9uX3N0YXR1cyI6ICJBY3RpdmUiLCAic3RhdGlvbl90eXBlIjogIkRpdmVyc2lvbiIsICJ1c2dzX3N0YXRpb25faWQiOiBudWxsLCAidmFyaWFibGUiOiAiRElTQ0hSRyIsICJ3ZCI6ICI1In0sICJ0eXBlIjogIkZlYXR1cmUifSwgeyJiYm94IjogWy0xMDUuMjYzNDksIDQwLjIyMDcwMiwgLTEwNS4yNjM0OSwgNDAuMjIwNzAyXSwgImdlb21ldHJ5IjogeyJjb29yZGluYXRlcyI6IFstMTA1LjI2MzQ5LCA0MC4yMjA3MDJdLCAidHlwZSI6ICJQb2ludCJ9LCAiaWQiOiAiMSIsICJwcm9wZXJ0aWVzIjogeyJhbW91bnQiOiAiMzcuOTAiLCAiY291bnR5IjogIkJPVUxERVIiLCAiZGF0YV9zb3VyY2UiOiAiQ28uIERpdmlzaW9uIG9mIFdhdGVyIFJlc291cmNlcyIsICJkYXRlX3RpbWUiOiAiMjAyMC0wMy0yM1QxMjoxNTowMC4wMDAiLCAiZGl2IjogIjEiLCAiZHdyX2FiYnJldiI6ICJTVkNMWU9DTyIsICJmbGFnIjogbnVsbCwgImh0dHBfbGlua2FnZS51cmwiOiAiaHR0cHM6Ly9kd3Iuc3RhdGUuY28udXMvU3VyZmFjZVdhdGVyL2RhdGEvZGV0YWlsX2dyYXBoLmFzcHg/SUQ9U1ZDTFlPQ09cdTAwMjZNVFlQRT1ESVNDSFJHIiwgImxvY2F0aW9uLmxhdGl0dWRlIjogNDAuMjIwNzAyLCAibG9jYXRpb24ubG9uZ2l0dWRlIjogLTEwNS4yNjM0OSwgImxvY2F0aW9uLm5lZWRzX3JlY29kaW5nIjogZmFsc2UsICJzdGFnZSI6ICIyLjk2IiwgInN0YXRpb25fbmFtZSI6ICJTQUlOVCBWUkFJTiBDUkVFSyBBVCBMWU9OUywgQ08iLCAic3RhdGlvbl9zdGF0dXMiOiAiQWN0aXZlIiwgInN0YXRpb25fdHlwZSI6ICJTdHJlYW0iLCAidXNnc19zdGF0aW9uX2lkIjogIjA2NzI0MDAwIiwgInZhcmlhYmxlIjogIkRJU0NIUkciLCAid2QiOiAiNSJ9LCAidHlwZSI6ICJGZWF0dXJlIn0sIHsiYmJveCI6IFstMTA1LjIwNjU5MiwgNDAuMTk2NDIyLCAtMTA1LjIwNjU5MiwgNDAuMTk2NDIyXSwgImdlb21ldHJ5IjogeyJjb29yZGluYXRlcyI6IFstMTA1LjIwNjU5MiwgNDAuMTk2NDIyXSwgInR5cGUiOiAiUG9pbnQifSwgImlkIjogIjIiLCAicHJvcGVydGllcyI6IHsiYW1vdW50IjogIjkuNDYiLCAiY291bnR5IjogIkJPVUxERVIiLCAiZGF0YV9zb3VyY2UiOiAiQ29vcGVyYXRpdmUgUHJvZ3JhbSBvZiBDRFdSLCBOQ1dDRCBcdTAwMjYgU1ZMSFdDRCIsICJkYXRlX3RpbWUiOiAiMjAyMC0wMy0yM1QxMDo0NTowMC4wMDAiLCAiZGl2IjogIjEiLCAiZHdyX2FiYnJldiI6ICJPTElESVRDTyIsICJmbGFnIjogbnVsbCwgImh0dHBfbGlua2FnZS51cmwiOiAiaHR0cHM6Ly9kd3Iuc3RhdGUuY28udXMvU3VyZmFjZVdhdGVyL2RhdGEvZGV0YWlsX2dyYXBoLmFzcHg/SUQ9T0xJRElUQ09cdTAwMjZNVFlQRT1ESVNDSFJHIiwgImxvY2F0aW9uLmxhdGl0dWRlIjogNDAuMTk2NDIyLCAibG9jYXRpb24ubG9uZ2l0dWRlIjogLTEwNS4yMDY1OTIsICJsb2NhdGlvbi5uZWVkc19yZWNvZGluZyI6IGZhbHNlLCAic3RhZ2UiOiAiMC40MSIsICJzdGF0aW9uX25hbWUiOiAiT0xJR0FSQ0hZIERJVENIIERJVkVSU0lPTiIsICJzdGF0aW9uX3N0YXR1cyI6ICJBY3RpdmUiLCAic3RhdGlvbl90eXBlIjogIkRpdmVyc2lvbiIsICJ1c2dzX3N0YXRpb25faWQiOiBudWxsLCAidmFyaWFibGUiOiAiRElTQ0hSRyIsICJ3ZCI6ICI1In0sICJ0eXBlIjogIkZlYXR1cmUifSwgeyJiYm94IjogWy0xMDUuMzA4NDMyLCAzOS45MzE4MTMsIC0xMDUuMzA4NDMyLCAzOS45MzE4MTNdLCAiZ2VvbWV0cnkiOiB7ImNvb3JkaW5hdGVzIjogWy0xMDUuMzA4NDMyLCAzOS45MzE4MTNdLCAidHlwZSI6ICJQb2ludCJ9LCAiaWQiOiAiMyIsICJwcm9wZXJ0aWVzIjogeyJhbW91bnQiOiAiMC4wMCIsICJjb3VudHkiOiAiQk9VTERFUiIsICJkYXRhX3NvdXJjZSI6ICJDby4gRGl2aXNpb24gb2YgV2F0ZXIgUmVzb3VyY2VzIiwgImRhdGVfdGltZSI6ICIyMDIwLTAzLTIzVDEyOjMwOjAwLjAwMCIsICJkaXYiOiAiMSIsICJkd3JfYWJicmV2IjogIkJPU0RFTENPIiwgImZsYWciOiBudWxsLCAiaHR0cF9saW5rYWdlLnVybCI6ICJodHRwczovL2R3ci5zdGF0ZS5jby51cy9TdXJmYWNlV2F0ZXIvZGF0YS9kZXRhaWxfZ3JhcGguYXNweD9JRD1CT1NERUxDT1x1MDAyNk1UWVBFPURJU0NIUkciLCAibG9jYXRpb24ubGF0aXR1ZGUiOiAzOS45MzE4MTMsICJsb2NhdGlvbi5sb25naXR1ZGUiOiAtMTA1LjMwODQzMiwgImxvY2F0aW9uLm5lZWRzX3JlY29kaW5nIjogZmFsc2UsICJzdGFnZSI6ICItMS43MCIsICJzdGF0aW9uX25hbWUiOiAiU09VVEggQk9VTERFUiBDUkVFSyBESVZFUlNJT04gTkVBUiBFTERPUkFETyBTUFJJTkdTIiwgInN0YXRpb25fc3RhdHVzIjogIkFjdGl2ZSIsICJzdGF0aW9uX3R5cGUiOiAiRGl2ZXJzaW9uIiwgInVzZ3Nfc3RhdGlvbl9pZCI6IG51bGwsICJ2YXJpYWJsZSI6ICJESVNDSFJHIiwgIndkIjogIjYifSwgInR5cGUiOiAiRmVhdHVyZSJ9LCB7ImJib3giOiBbLTEwNS4yMTAzOSwgNDAuMTkzNzU4LCAtMTA1LjIxMDM5LCA0MC4xOTM3NThdLCAiZ2VvbWV0cnkiOiB7ImNvb3JkaW5hdGVzIjogWy0xMDUuMjEwMzksIDQwLjE5Mzc1OF0sICJ0eXBlIjogIlBvaW50In0sICJpZCI6ICI0IiwgInByb3BlcnRpZXMiOiB7ImFtb3VudCI6ICIwLjAwIiwgImNvdW50eSI6ICJCT1VMREVSIiwgImRhdGFfc291cmNlIjogIkNvb3BlcmF0aXZlIFByb2dyYW0gb2YgQ0RXUiwgTkNXQ0QgXHUwMDI2IFNWTEhXQ0QiLCAiZGF0ZV90aW1lIjogIjIwMjAtMDMtMjNUMTI6MDA6MDAuMDAwIiwgImRpdiI6ICIxIiwgImR3cl9hYmJyZXYiOiAiQ0xPRElUQ08iLCAiZmxhZyI6IG51bGwsICJodHRwX2xpbmthZ2UudXJsIjogImh0dHBzOi8vZHdyLnN0YXRlLmNvLnVzL1N1cmZhY2VXYXRlci9kYXRhL2RldGFpbF9ncmFwaC5hc3B4P0lEPUNMT0RJVENPXHUwMDI2TVRZUEU9RElTQ0hSRyIsICJsb2NhdGlvbi5sYXRpdHVkZSI6IDQwLjE5Mzc1OCwgImxvY2F0aW9uLmxvbmdpdHVkZSI6IC0xMDUuMjEwMzksICJsb2NhdGlvbi5uZWVkc19yZWNvZGluZyI6IGZhbHNlLCAic3RhZ2UiOiBudWxsLCAic3RhdGlvbl9uYW1lIjogIkNMT1VHSCBBTkQgVFJVRSBESVRDSCIsICJzdGF0aW9uX3N0YXR1cyI6ICJBY3RpdmUiLCAic3RhdGlvbl90eXBlIjogIkRpdmVyc2lvbiIsICJ1c2dzX3N0YXRpb25faWQiOiBudWxsLCAidmFyaWFibGUiOiAiRElTQ0hSRyIsICJ3ZCI6ICI1In0sICJ0eXBlIjogIkZlYXR1cmUifSwgeyJiYm94IjogWy0xMDUuMzMwODQxLCA0MC4wMDYzODAwMDAwMDAwMSwgLTEwNS4zMzA4NDEsIDQwLjAwNjM4MDAwMDAwMDAxXSwgImdlb21ldHJ5IjogeyJjb29yZGluYXRlcyI6IFstMTA1LjMzMDg0MSwgNDAuMDA2MzgwMDAwMDAwMDFdLCAidHlwZSI6ICJQb2ludCJ9LCAiaWQiOiAiNSIsICJwcm9wZXJ0aWVzIjogeyJhbW91bnQiOiAiOC43OCIsICJjb3VudHkiOiAiQk9VTERFUiIsICJkYXRhX3NvdXJjZSI6ICJDby4gRGl2aXNpb24gb2YgV2F0ZXIgUmVzb3VyY2VzIiwgImRhdGVfdGltZSI6ICIyMDIwLTAzLTIzVDEyOjE1OjAwLjAwMCIsICJkaXYiOiAiMSIsICJkd3JfYWJicmV2IjogIkJPQ09ST0NPIiwgImZsYWciOiAiSWNlIiwgImh0dHBfbGlua2FnZS51cmwiOiAiaHR0cHM6Ly9kd3Iuc3RhdGUuY28udXMvU3VyZmFjZVdhdGVyL2RhdGEvZGV0YWlsX2dyYXBoLmFzcHg/SUQ9Qk9DT1JPQ09cdTAwMjZNVFlQRT1ESVNDSFJHIiwgImxvY2F0aW9uLmxhdGl0dWRlIjogNDAuMDA2MzgsICJsb2NhdGlvbi5sb25naXR1ZGUiOiAtMTA1LjMzMDg0MSwgImxvY2F0aW9uLm5lZWRzX3JlY29kaW5nIjogZmFsc2UsICJzdGFnZSI6ICIxLjgyIiwgInN0YXRpb25fbmFtZSI6ICJCT1VMREVSIENSRUVLIE5FQVIgT1JPREVMTCwgQ08uIiwgInN0YXRpb25fc3RhdHVzIjogIkFjdGl2ZSIsICJzdGF0aW9uX3R5cGUiOiAiU3RyZWFtIiwgInVzZ3Nfc3RhdGlvbl9pZCI6ICIwNjcyNzAwMCIsICJ2YXJpYWJsZSI6ICJESVNDSFJHIiwgIndkIjogIjYifSwgInR5cGUiOiAiRmVhdHVyZSJ9LCB7ImJib3giOiBbLTEwNS4yMTg3NzcsIDQwLjIwNDE5MywgLTEwNS4yMTg3NzcsIDQwLjIwNDE5M10sICJnZW9tZXRyeSI6IHsiY29vcmRpbmF0ZXMiOiBbLTEwNS4yMTg3NzcsIDQwLjIwNDE5M10sICJ0eXBlIjogIlBvaW50In0sICJpZCI6ICI2IiwgInByb3BlcnRpZXMiOiB7ImFtb3VudCI6ICIwLjAwIiwgImNvdW50eSI6ICJCT1VMREVSIiwgImRhdGFfc291cmNlIjogIkNvb3BlcmF0aXZlIFByb2dyYW0gb2YgQ0RXUiwgTkNXQ0QgXHUwMDI2IFNWTEhXQ0QiLCAiZGF0ZV90aW1lIjogIjIwMjAtMDMtMjNUMTI6MDA6MDAuMDAwIiwgImRpdiI6ICIxIiwgImR3cl9hYmJyZXYiOiAiTE9OU1VQQ08iLCAiZmxhZyI6IG51bGwsICJodHRwX2xpbmthZ2UudXJsIjogImh0dHBzOi8vZHdyLnN0YXRlLmNvLnVzL1N1cmZhY2VXYXRlci9kYXRhL2RldGFpbF9ncmFwaC5hc3B4P0lEPUxPTlNVUENPXHUwMDI2TVRZUEU9RElTQ0hSRyIsICJsb2NhdGlvbi5sYXRpdHVkZSI6IDQwLjIwNDE5MywgImxvY2F0aW9uLmxvbmdpdHVkZSI6IC0xMDUuMjE4Nzc3LCAibG9jYXRpb24ubmVlZHNfcmVjb2RpbmciOiBmYWxzZSwgInN0YWdlIjogbnVsbCwgInN0YXRpb25fbmFtZSI6ICJMT05HTU9OVCBTVVBQTFkgRElUQ0giLCAic3RhdGlvbl9zdGF0dXMiOiAiQWN0aXZlIiwgInN0YXRpb25fdHlwZSI6ICJEaXZlcnNpb24iLCAidXNnc19zdGF0aW9uX2lkIjogbnVsbCwgInZhcmlhYmxlIjogIkRJU0NIUkciLCAid2QiOiAiNSJ9LCAidHlwZSI6ICJGZWF0dXJlIn0sIHsiYmJveCI6IFstMTA1LjE2NzYyMiwgNDAuMTcyOTI1LCAtMTA1LjE2NzYyMiwgNDAuMTcyOTI1XSwgImdlb21ldHJ5IjogeyJjb29yZGluYXRlcyI6IFstMTA1LjE2NzYyMiwgNDAuMTcyOTI1XSwgInR5cGUiOiAiUG9pbnQifSwgImlkIjogIjciLCAicHJvcGVydGllcyI6IHsiYW1vdW50IjogIjAuMDAiLCAiY291bnR5IjogIkJPVUxERVIiLCAiZGF0YV9zb3VyY2UiOiAiQ29vcGVyYXRpdmUgU0RSIFByb2dyYW0gb2YgQ0RXUiBcdTAwMjYgTkNXQ0QiLCAiZGF0ZV90aW1lIjogIjIwMjAtMDMtMjNUMTI6MDA6MDAuMDAwIiwgImRpdiI6ICIxIiwgImR3cl9hYmJyZXYiOiAiTk9STVVUQ08iLCAiZmxhZyI6IG51bGwsICJodHRwX2xpbmthZ2UudXJsIjogImh0dHBzOi8vZHdyLnN0YXRlLmNvLnVzL1N1cmZhY2VXYXRlci9kYXRhL2RldGFpbF9ncmFwaC5hc3B4P0lEPU5PUk1VVENPXHUwMDI2TVRZUEU9RElTQ0hSRyIsICJsb2NhdGlvbi5sYXRpdHVkZSI6IDQwLjE3MjkyNSwgImxvY2F0aW9uLmxvbmdpdHVkZSI6IC0xMDUuMTY3NjIyLCAibG9jYXRpb24ubmVlZHNfcmVjb2RpbmciOiBmYWxzZSwgInN0YWdlIjogbnVsbCwgInN0YXRpb25fbmFtZSI6ICJOT1JUSFdFU1QgTVVUVUFMIERJVENIIiwgInN0YXRpb25fc3RhdHVzIjogIkFjdGl2ZSIsICJzdGF0aW9uX3R5cGUiOiAiRGl2ZXJzaW9uIiwgInVzZ3Nfc3RhdGlvbl9pZCI6IG51bGwsICJ2YXJpYWJsZSI6ICJESVNDSFJHIiwgIndkIjogIjUifSwgInR5cGUiOiAiRmVhdHVyZSJ9LCB7ImJib3giOiBbLTEwNS4xMzA4MTksIDQwLjEzNDI3OCwgLTEwNS4xMzA4MTksIDQwLjEzNDI3OF0sICJnZW9tZXRyeSI6IHsiY29vcmRpbmF0ZXMiOiBbLTEwNS4xMzA4MTksIDQwLjEzNDI3OF0sICJ0eXBlIjogIlBvaW50In0sICJpZCI6ICI4IiwgInByb3BlcnRpZXMiOiB7ImFtb3VudCI6ICI0LjE4IiwgImNvdW50eSI6ICJCT1VMREVSIiwgImRhdGFfc291cmNlIjogIlUuUy4gR2VvbG9naWNhbCBTdXJ2ZXkiLCAiZGF0ZV90aW1lIjogIjIwMjAtMDMtMjNUMTI6MTA6MDAuMDAwIiwgImRpdiI6ICIxIiwgImR3cl9hYmJyZXYiOiAiTEVGVEhPQ08iLCAiZmxhZyI6IG51bGwsICJodHRwX2xpbmthZ2UudXJsIjogImh0dHBzOi8vd2F0ZXJkYXRhLnVzZ3MuZ292L253aXMvdXY/MDY3MjQ5NzAiLCAibG9jYXRpb24ubGF0aXR1ZGUiOiA0MC4xMzQyNzgsICJsb2NhdGlvbi5sb25naXR1ZGUiOiAtMTA1LjEzMDgxOSwgImxvY2F0aW9uLm5lZWRzX3JlY29kaW5nIjogZmFsc2UsICJzdGFnZSI6IG51bGwsICJzdGF0aW9uX25hbWUiOiAiTEVGVCBIQU5EIENSRUVLIEFUIEhPVkVSIFJPQUQgTkVBUiBMT05HTU9OVCwgQ08iLCAic3RhdGlvbl9zdGF0dXMiOiAiQWN0aXZlIiwgInN0YXRpb25fdHlwZSI6ICJTdHJlYW0iLCAidXNnc19zdGF0aW9uX2lkIjogIjA2NzI0OTcwIiwgInZhcmlhYmxlIjogIkRJU0NIUkciLCAid2QiOiAiNSJ9LCAidHlwZSI6ICJGZWF0dXJlIn0sIHsiYmJveCI6IFstMTA1LjIxODY3NywgMzkuOTg2MTY5LCAtMTA1LjIxODY3NywgMzkuOTg2MTY5XSwgImdlb21ldHJ5IjogeyJjb29yZGluYXRlcyI6IFstMTA1LjIxODY3NywgMzkuOTg2MTY5XSwgInR5cGUiOiAiUG9pbnQifSwgImlkIjogIjkiLCAicHJvcGVydGllcyI6IHsiYW1vdW50IjogIjAuMDAiLCAiY291bnR5IjogIkJPVUxERVIiLCAiZGF0YV9zb3VyY2UiOiAiQ29vcGVyYXRpdmUgUHJvZ3JhbSBvZiBDRFdSLCBOQ1dDRCBcdTAwMjYgTFNQV0NEIiwgImRhdGVfdGltZSI6ICIyMDIwLTAzLTIzVDExOjAwOjAwLjAwMCIsICJkaXYiOiAiMSIsICJkd3JfYWJicmV2IjogIkRSWUNBUkNPIiwgImZsYWciOiBudWxsLCAiaHR0cF9saW5rYWdlLnVybCI6ICJodHRwczovL2R3ci5zdGF0ZS5jby51cy9TdXJmYWNlV2F0ZXIvZGF0YS9kZXRhaWxfZ3JhcGguYXNweD9JRD1EUllDQVJDT1x1MDAyNk1UWVBFPURJU0NIUkciLCAibG9jYXRpb24ubGF0aXR1ZGUiOiAzOS45ODYxNjksICJsb2NhdGlvbi5sb25naXR1ZGUiOiAtMTA1LjIxODY3NywgImxvY2F0aW9uLm5lZWRzX3JlY29kaW5nIjogZmFsc2UsICJzdGFnZSI6IG51bGwsICJzdGF0aW9uX25hbWUiOiAiRFJZIENSRUVLIENBUlJJRVIiLCAic3RhdGlvbl9zdGF0dXMiOiAiQWN0aXZlIiwgInN0YXRpb25fdHlwZSI6ICJEaXZlcnNpb24iLCAidXNnc19zdGF0aW9uX2lkIjogbnVsbCwgInZhcmlhYmxlIjogIkRJU0NIUkciLCAid2QiOiAiNiJ9LCAidHlwZSI6ICJGZWF0dXJlIn0sIHsiYmJveCI6IFstMTA1LjE2ODQ3MSwgNDAuMTYwNzA1LCAtMTA1LjE2ODQ3MSwgNDAuMTYwNzA1XSwgImdlb21ldHJ5IjogeyJjb29yZGluYXRlcyI6IFstMTA1LjE2ODQ3MSwgNDAuMTYwNzA1XSwgInR5cGUiOiAiUG9pbnQifSwgImlkIjogIjEwIiwgInByb3BlcnRpZXMiOiB7ImFtb3VudCI6ICIwLjAwIiwgImNvdW50eSI6ICJCT1VMREVSIiwgImRhdGFfc291cmNlIjogIkNvLiBEaXZpc2lvbiBvZiBXYXRlciBSZXNvdXJjZXMiLCAiZGF0ZV90aW1lIjogIjIwMjAtMDMtMjNUMTA6NDU6MDAuMDAwIiwgImRpdiI6ICIxIiwgImR3cl9hYmJyZXYiOiAiUEVDUlROQ08iLCAiZmxhZyI6IG51bGwsICJodHRwX2xpbmthZ2UudXJsIjogImh0dHBzOi8vZHdyLnN0YXRlLmNvLnVzL1N1cmZhY2VXYXRlci9kYXRhL2RldGFpbF9ncmFwaC5hc3B4P0lEPVBFQ1JUTkNPXHUwMDI2TVRZUEU9RElTQ0hSRyIsICJsb2NhdGlvbi5sYXRpdHVkZSI6IDQwLjE2MDcwNSwgImxvY2F0aW9uLmxvbmdpdHVkZSI6IC0xMDUuMTY4NDcxLCAibG9jYXRpb24ubmVlZHNfcmVjb2RpbmciOiBmYWxzZSwgInN0YWdlIjogbnVsbCwgInN0YXRpb25fbmFtZSI6ICJQRUNLLVBFTExBIEFVR01FTlRBVElPTiBSRVRVUk4iLCAic3RhdGlvbl9zdGF0dXMiOiAiQWN0aXZlIiwgInN0YXRpb25fdHlwZSI6ICJEaXZlcnNpb24iLCAidXNnc19zdGF0aW9uX2lkIjogbnVsbCwgInZhcmlhYmxlIjogIkRJU0NIUkciLCAid2QiOiAiNSJ9LCAidHlwZSI6ICJGZWF0dXJlIn0sIHsiYmJveCI6IFstMTA1LjIyMjYzOSwgNDAuMTk5MzIxLCAtMTA1LjIyMjYzOSwgNDAuMTk5MzIxXSwgImdlb21ldHJ5IjogeyJjb29yZGluYXRlcyI6IFstMTA1LjIyMjYzOSwgNDAuMTk5MzIxXSwgInR5cGUiOiAiUG9pbnQifSwgImlkIjogIjExIiwgInByb3BlcnRpZXMiOiB7ImFtb3VudCI6ICIwLjAwIiwgImNvdW50eSI6ICJCT1VMREVSIiwgImRhdGFfc291cmNlIjogIkNvb3BlcmF0aXZlIFByb2dyYW0gb2YgQ0RXUiwgTkNXQ0QgXHUwMDI2IFNWTEhXQ0QiLCAiZGF0ZV90aW1lIjogIjIwMjAtMDMtMjNUMTE6NDU6MDAuMDAwIiwgImRpdiI6ICIxIiwgImR3cl9hYmJyZXYiOiAiR09ESVQxQ08iLCAiZmxhZyI6IG51bGwsICJodHRwX2xpbmthZ2UudXJsIjogImh0dHBzOi8vZHdyLnN0YXRlLmNvLnVzL1N1cmZhY2VXYXRlci9kYXRhL2RldGFpbF9ncmFwaC5hc3B4P0lEPUdPRElUMUNPXHUwMDI2TVRZUEU9RElTQ0hSRyIsICJsb2NhdGlvbi5sYXRpdHVkZSI6IDQwLjE5OTMyMSwgImxvY2F0aW9uLmxvbmdpdHVkZSI6IC0xMDUuMjIyNjM5LCAibG9jYXRpb24ubmVlZHNfcmVjb2RpbmciOiBmYWxzZSwgInN0YWdlIjogbnVsbCwgInN0YXRpb25fbmFtZSI6ICJHT1NTIERJVENIIDEiLCAic3RhdGlvbl9zdGF0dXMiOiAiQWN0aXZlIiwgInN0YXRpb25fdHlwZSI6ICJEaXZlcnNpb24iLCAidXNnc19zdGF0aW9uX2lkIjogbnVsbCwgInZhcmlhYmxlIjogIkRJU0NIUkciLCAid2QiOiAiNSJ9LCAidHlwZSI6ICJGZWF0dXJlIn0sIHsiYmJveCI6IFstMTA1LjIxMDQyNCwgNDAuMTkzMjgwMDAwMDAwMDEsIC0xMDUuMjEwNDI0LCA0MC4xOTMyODAwMDAwMDAwMV0sICJnZW9tZXRyeSI6IHsiY29vcmRpbmF0ZXMiOiBbLTEwNS4yMTA0MjQsIDQwLjE5MzI4MDAwMDAwMDAxXSwgInR5cGUiOiAiUG9pbnQifSwgImlkIjogIjEyIiwgInByb3BlcnRpZXMiOiB7ImFtb3VudCI6ICIwLjAwIiwgImNvdW50eSI6ICJCT1VMREVSIiwgImRhdGFfc291cmNlIjogIkNvb3BlcmF0aXZlIFByb2dyYW0gb2YgQ0RXUiwgTkNXQ0QgXHUwMDI2IFNWTEhXQ0QiLCAiZGF0ZV90aW1lIjogIjIwMjAtMDMtMjNUMTI6MDA6MDAuMDAwIiwgImRpdiI6ICIxIiwgImR3cl9hYmJyZXYiOiAiV0VCRElUQ08iLCAiZmxhZyI6IG51bGwsICJodHRwX2xpbmthZ2UudXJsIjogImh0dHBzOi8vZHdyLnN0YXRlLmNvLnVzL1N1cmZhY2VXYXRlci9kYXRhL2RldGFpbF9ncmFwaC5hc3B4P0lEPVdFQkRJVENPXHUwMDI2TVRZUEU9RElTQ0hSRyIsICJsb2NhdGlvbi5sYXRpdHVkZSI6IDQwLjE5MzI4LCAibG9jYXRpb24ubG9uZ2l0dWRlIjogLTEwNS4yMTA0MjQsICJsb2NhdGlvbi5uZWVkc19yZWNvZGluZyI6IGZhbHNlLCAic3RhZ2UiOiBudWxsLCAic3RhdGlvbl9uYW1lIjogIldFQlNURVIgTUNDQVNMSU4gRElUQ0giLCAic3RhdGlvbl9zdGF0dXMiOiAiQWN0aXZlIiwgInN0YXRpb25fdHlwZSI6ICJEaXZlcnNpb24iLCAidXNnc19zdGF0aW9uX2lkIjogbnVsbCwgInZhcmlhYmxlIjogIkRJU0NIUkciLCAid2QiOiAiNSJ9LCAidHlwZSI6ICJGZWF0dXJlIn0sIHsiYmJveCI6IFstMTA1LjE1MTE0MywgNDAuMDUzNjYxLCAtMTA1LjE1MTE0MywgNDAuMDUzNjYxXSwgImdlb21ldHJ5IjogeyJjb29yZGluYXRlcyI6IFstMTA1LjE1MTE0MywgNDAuMDUzNjYxXSwgInR5cGUiOiAiUG9pbnQifSwgImlkIjogIjEzIiwgInByb3BlcnRpZXMiOiB7ImFtb3VudCI6ICIyLjg0IiwgImNvdW50eSI6ICJCT1VMREVSIiwgImRhdGFfc291cmNlIjogIkNvb3BlcmF0aXZlIFByb2dyYW0gb2YgQ0RXUiwgTkNXQ0QgXHUwMDI2IExTUFdDRCIsICJkYXRlX3RpbWUiOiAiMjAyMC0wMy0yM1QxMjowMDowMC4wMDAiLCAiZGl2IjogIjEiLCAiZHdyX2FiYnJldiI6ICJMRUdESVRDTyIsICJmbGFnIjogbnVsbCwgImh0dHBfbGlua2FnZS51cmwiOiAiaHR0cHM6Ly9kd3Iuc3RhdGUuY28udXMvU3VyZmFjZVdhdGVyL2RhdGEvZGV0YWlsX2dyYXBoLmFzcHg/SUQ9TEVHRElUQ09cdTAwMjZNVFlQRT1ESVNDSFJHIiwgImxvY2F0aW9uLmxhdGl0dWRlIjogNDAuMDUzNjYxLCAibG9jYXRpb24ubG9uZ2l0dWRlIjogLTEwNS4xNTExNDMsICJsb2NhdGlvbi5uZWVkc19yZWNvZGluZyI6IGZhbHNlLCAic3RhZ2UiOiAiMC4yMiIsICJzdGF0aW9uX25hbWUiOiAiTEVHR0VUVCBESVRDSCIsICJzdGF0aW9uX3N0YXR1cyI6ICJBY3RpdmUiLCAic3RhdGlvbl90eXBlIjogIkRpdmVyc2lvbiIsICJ1c2dzX3N0YXRpb25faWQiOiBudWxsLCAidmFyaWFibGUiOiAiRElTQ0hSRyIsICJ3ZCI6ICI2In0sICJ0eXBlIjogIkZlYXR1cmUifSwgeyJiYm94IjogWy0xMDUuMzY1MzY1LCA0MC4yMTYyNjMsIC0xMDUuMzY1MzY1LCA0MC4yMTYyNjNdLCAiZ2VvbWV0cnkiOiB7ImNvb3JkaW5hdGVzIjogWy0xMDUuMzY1MzY1LCA0MC4yMTYyNjNdLCAidHlwZSI6ICJQb2ludCJ9LCAiaWQiOiAiMTQiLCAicHJvcGVydGllcyI6IHsiYW1vdW50IjogIjEyODg2LjAwIiwgImNvdW50eSI6ICJCT1VMREVSIiwgImRhdGFfc291cmNlIjogIkNvLiBEaXZpc2lvbiBvZiBXYXRlciBSZXNvdXJjZXMiLCAiZGF0ZV90aW1lIjogIjIwMjAtMDMtMjNUMTI6NDU6MDAuMDAwIiwgImRpdiI6ICIxIiwgImR3cl9hYmJyZXYiOiAiQlJLREFNQ08iLCAiZmxhZyI6IG51bGwsICJodHRwX2xpbmthZ2UudXJsIjogImh0dHBzOi8vZHdyLnN0YXRlLmNvLnVzL1N1cmZhY2VXYXRlci9kYXRhL2RldGFpbF9ncmFwaC5hc3B4P0lEPUJSS0RBTUNPXHUwMDI2TVRZUEU9U1RPUkFHRSIsICJsb2NhdGlvbi5sYXRpdHVkZSI6IDQwLjIxNjI2MywgImxvY2F0aW9uLmxvbmdpdHVkZSI6IC0xMDUuMzY1MzY1LCAibG9jYXRpb24ubmVlZHNfcmVjb2RpbmciOiBmYWxzZSwgInN0YWdlIjogIjYzODQuMDQiLCAic3RhdGlvbl9uYW1lIjogIkJVVFRPTlJPQ0sgKFJBTFBIIFBSSUNFKSBSRVNFUlZPSVIiLCAic3RhdGlvbl9zdGF0dXMiOiAiQWN0aXZlIiwgInN0YXRpb25fdHlwZSI6ICJSZXNlcnZvaXIiLCAidXNnc19zdGF0aW9uX2lkIjogbnVsbCwgInZhcmlhYmxlIjogIlNUT1JBR0UiLCAid2QiOiAiNSJ9LCAidHlwZSI6ICJGZWF0dXJlIn0sIHsiYmJveCI6IFstMTA1LjIwOTUsIDQwLjI1NTc3NiwgLTEwNS4yMDk1LCA0MC4yNTU3NzZdLCAiZ2VvbWV0cnkiOiB7ImNvb3JkaW5hdGVzIjogWy0xMDUuMjA5NSwgNDAuMjU1Nzc2XSwgInR5cGUiOiAiUG9pbnQifSwgImlkIjogIjE1IiwgInByb3BlcnRpZXMiOiB7ImFtb3VudCI6ICIwLjEwIiwgImNvdW50eSI6ICJCT1VMREVSIiwgImRhdGFfc291cmNlIjogIk5vcnRoZXJuIENvbG9yYWRvIFdhdGVyIENvbnNlcnZhbmN5IERpc3RyaWN0IiwgImRhdGVfdGltZSI6ICIyMDIwLTAzLTIzVDEyOjAwOjAwLjAwMCIsICJkaXYiOiAiMSIsICJkd3JfYWJicmV2IjogIkxJVFRIMkNPIiwgImZsYWciOiBudWxsLCAiaHR0cF9saW5rYWdlLnVybCI6ICJodHRwOi8vd3d3Lm5vcnRoZXJud2F0ZXIub3JnL1dhdGVyUHJvamVjdHMvV2F0ZXJEYXRhLmFzcHhFYXN0U2xvcGVXYXRlckRhdGEuYXNweCIsICJsb2NhdGlvbi5sYXRpdHVkZSI6IDQwLjI1NTc3NiwgImxvY2F0aW9uLmxvbmdpdHVkZSI6IC0xMDUuMjA5NSwgImxvY2F0aW9uLm5lZWRzX3JlY29kaW5nIjogZmFsc2UsICJzdGFnZSI6ICIwLjEwIiwgInN0YXRpb25fbmFtZSI6ICJMSVRUTEUgVEhPTVBTT04gIzIgRElUQ0giLCAic3RhdGlvbl9zdGF0dXMiOiAiQWN0aXZlIiwgInN0YXRpb25fdHlwZSI6ICJEaXZlcnNpb24iLCAidXNnc19zdGF0aW9uX2lkIjogIkVTMTkwMCIsICJ2YXJpYWJsZSI6ICJESVNDSFJHIiwgIndkIjogIjQifSwgInR5cGUiOiAiRmVhdHVyZSJ9LCB7ImJib3giOiBbLTEwNS4xNjQzOTcsIDQwLjI1Nzg0NCwgLTEwNS4xNjQzOTcsIDQwLjI1Nzg0NF0sICJnZW9tZXRyeSI6IHsiY29vcmRpbmF0ZXMiOiBbLTEwNS4xNjQzOTcsIDQwLjI1Nzg0NF0sICJ0eXBlIjogIlBvaW50In0sICJpZCI6ICIxNiIsICJwcm9wZXJ0aWVzIjogeyJhbW91bnQiOiAiMC4wMyIsICJjb3VudHkiOiAiQk9VTERFUiIsICJkYXRhX3NvdXJjZSI6ICJDb29wZXJhdGl2ZSBTRFIgUHJvZ3JhbSBvZiBDRFdSIFx1MDAyNiBOQ1dDRCIsICJkYXRlX3RpbWUiOiAiMjAyMC0wMy0yM1QxMjowMDowMC4wMDAiLCAiZGl2IjogIjEiLCAiZHdyX2FiYnJldiI6ICJCTFdESVRDTyIsICJmbGFnIjogbnVsbCwgImh0dHBfbGlua2FnZS51cmwiOiAiaHR0cHM6Ly9kd3Iuc3RhdGUuY28udXMvU3VyZmFjZVdhdGVyL2RhdGEvZGV0YWlsX2dyYXBoLmFzcHg/SUQ9QkxXRElUQ09cdTAwMjZNVFlQRT1ESVNDSFJHIiwgImxvY2F0aW9uLmxhdGl0dWRlIjogNDAuMjU3ODQ0LCAibG9jYXRpb24ubG9uZ2l0dWRlIjogLTEwNS4xNjQzOTcsICJsb2NhdGlvbi5uZWVkc19yZWNvZGluZyI6IGZhbHNlLCAic3RhZ2UiOiAiMC4wNCIsICJzdGF0aW9uX25hbWUiOiAiQkxPV0VSIERJVENIIiwgInN0YXRpb25fc3RhdHVzIjogIkFjdGl2ZSIsICJzdGF0aW9uX3R5cGUiOiAiRGl2ZXJzaW9uIiwgInVzZ3Nfc3RhdGlvbl9pZCI6IG51bGwsICJ2YXJpYWJsZSI6ICJESVNDSFJHIiwgIndkIjogIjQifSwgInR5cGUiOiAiRmVhdHVyZSJ9LCB7ImJib3giOiBbLTEwNS4zMDQ5OSwgMzkuOTMxNTk3LCAtMTA1LjMwNDk5LCAzOS45MzE1OTddLCAiZ2VvbWV0cnkiOiB7ImNvb3JkaW5hdGVzIjogWy0xMDUuMzA0OTksIDM5LjkzMTU5N10sICJ0eXBlIjogIlBvaW50In0sICJpZCI6ICIxNyIsICJwcm9wZXJ0aWVzIjogeyJhbW91bnQiOiAiMTYuMDAiLCAiY291bnR5IjogIkJPVUxERVIiLCAiZGF0YV9zb3VyY2UiOiAiQ28uIERpdmlzaW9uIG9mIFdhdGVyIFJlc291cmNlcyIsICJkYXRlX3RpbWUiOiAiMjAyMC0wMy0yM1QxMjoxNTowMC4wMDAiLCAiZGl2IjogIjEiLCAiZHdyX2FiYnJldiI6ICJCT0NFTFNDTyIsICJmbGFnIjogIkljZSIsICJodHRwX2xpbmthZ2UudXJsIjogImh0dHBzOi8vZHdyLnN0YXRlLmNvLnVzL1N1cmZhY2VXYXRlci9kYXRhL2RldGFpbF9ncmFwaC5hc3B4P0lEPUJPQ0VMU0NPXHUwMDI2TVRZUEU9RElTQ0hSRyIsICJsb2NhdGlvbi5sYXRpdHVkZSI6IDM5LjkzMTU5NywgImxvY2F0aW9uLmxvbmdpdHVkZSI6IC0xMDUuMzA0OTksICJsb2NhdGlvbi5uZWVkc19yZWNvZGluZyI6IGZhbHNlLCAic3RhZ2UiOiAiMi4yMSIsICJzdGF0aW9uX25hbWUiOiAiU09VVEggQk9VTERFUiBDUkVFSyBORUFSIEVMRE9SQURPIFNQUklOR1MsIENPLiIsICJzdGF0aW9uX3N0YXR1cyI6ICJBY3RpdmUiLCAic3RhdGlvbl90eXBlIjogIlN0cmVhbSIsICJ1c2dzX3N0YXRpb25faWQiOiBudWxsLCAidmFyaWFibGUiOiAiRElTQ0hSRyIsICJ3ZCI6ICI2In0sICJ0eXBlIjogIkZlYXR1cmUifSwgeyJiYm94IjogWy0xMDUuMTc4ODc1LCA0MC4wNTE2NTIsIC0xMDUuMTc4ODc1LCA0MC4wNTE2NTJdLCAiZ2VvbWV0cnkiOiB7ImNvb3JkaW5hdGVzIjogWy0xMDUuMTc4ODc1LCA0MC4wNTE2NTJdLCAidHlwZSI6ICJQb2ludCJ9LCAiaWQiOiAiMTgiLCAicHJvcGVydGllcyI6IHsiYW1vdW50IjogIjMzLjUwIiwgImNvdW50eSI6ICJCT1VMREVSIiwgImRhdGFfc291cmNlIjogIlUuUy4gR2VvbG9naWNhbCBTdXJ2ZXkiLCAiZGF0ZV90aW1lIjogIjIwMjAtMDMtMjNUMTI6MTU6MDAuMDAwIiwgImRpdiI6ICIxIiwgImR3cl9hYmJyZXYiOiAiQk9DTk9SQ08iLCAiZmxhZyI6IG51bGwsICJodHRwX2xpbmthZ2UudXJsIjogImh0dHBzOi8vd2F0ZXJkYXRhLnVzZ3MuZ292L253aXMvdXY/MDY3MzAyMDAiLCAibG9jYXRpb24ubGF0aXR1ZGUiOiA0MC4wNTE2NTIsICJsb2NhdGlvbi5sb25naXR1ZGUiOiAtMTA1LjE3ODg3NSwgImxvY2F0aW9uLm5lZWRzX3JlY29kaW5nIjogZmFsc2UsICJzdGFnZSI6IG51bGwsICJzdGF0aW9uX25hbWUiOiAiQk9VTERFUiBDUkVFSyBBVCBOT1JUSCA3NVRIIFNULiBORUFSIEJPVUxERVIsIENPIiwgInN0YXRpb25fc3RhdHVzIjogIkFjdGl2ZSIsICJzdGF0aW9uX3R5cGUiOiAiU3RyZWFtIiwgInVzZ3Nfc3RhdGlvbl9pZCI6ICIwNjczMDIwMCIsICJ2YXJpYWJsZSI6ICJESVNDSFJHIiwgIndkIjogIjYifSwgInR5cGUiOiAiRmVhdHVyZSJ9LCB7ImJib3giOiBbLTEwNS4xNjA4NzYsIDQwLjE3MDk5OCwgLTEwNS4xNjA4NzYsIDQwLjE3MDk5OF0sICJnZW9tZXRyeSI6IHsiY29vcmRpbmF0ZXMiOiBbLTEwNS4xNjA4NzYsIDQwLjE3MDk5OF0sICJ0eXBlIjogIlBvaW50In0sICJpZCI6ICIxOSIsICJwcm9wZXJ0aWVzIjogeyJhbW91bnQiOiAiMC4zOCIsICJjb3VudHkiOiAiQk9VTERFUiIsICJkYXRhX3NvdXJjZSI6ICJDb29wZXJhdGl2ZSBQcm9ncmFtIG9mIENEV1IsIE5DV0NEIFx1MDAyNiBTVkxIV0NEIiwgImRhdGVfdGltZSI6ICIyMDIwLTAzLTIzVDEyOjAwOjAwLjAwMCIsICJkaXYiOiAiMSIsICJkd3JfYWJicmV2IjogIlNGTERJVENPIiwgImZsYWciOiBudWxsLCAiaHR0cF9saW5rYWdlLnVybCI6ICJodHRwczovL2R3ci5zdGF0ZS5jby51cy9TdXJmYWNlV2F0ZXIvZGF0YS9kZXRhaWxfZ3JhcGguYXNweD9JRD1TRkxESVRDT1x1MDAyNk1UWVBFPURJU0NIUkciLCAibG9jYXRpb24ubGF0aXR1ZGUiOiA0MC4xNzA5OTgsICJsb2NhdGlvbi5sb25naXR1ZGUiOiAtMTA1LjE2MDg3NiwgImxvY2F0aW9uLm5lZWRzX3JlY29kaW5nIjogZmFsc2UsICJzdGFnZSI6ICIwLjExIiwgInN0YXRpb25fbmFtZSI6ICJTT1VUSCBGTEFUIERJVENIIiwgInN0YXRpb25fc3RhdHVzIjogIkFjdGl2ZSIsICJzdGF0aW9uX3R5cGUiOiAiRGl2ZXJzaW9uIiwgInVzZ3Nfc3RhdGlvbl9pZCI6IG51bGwsICJ2YXJpYWJsZSI6ICJESVNDSFJHIiwgIndkIjogIjUifSwgInR5cGUiOiAiRmVhdHVyZSJ9LCB7ImJib3giOiBbLTEwNS4wNzU2OTUwMDAwMDAwMSwgNDAuMTUzMzQxLCAtMTA1LjA3NTY5NTAwMDAwMDAxLCA0MC4xNTMzNDFdLCAiZ2VvbWV0cnkiOiB7ImNvb3JkaW5hdGVzIjogWy0xMDUuMDc1Njk1MDAwMDAwMDEsIDQwLjE1MzM0MV0sICJ0eXBlIjogIlBvaW50In0sICJpZCI6ICIyMCIsICJwcm9wZXJ0aWVzIjogeyJhbW91bnQiOiAiNDUuMTAiLCAiY291bnR5IjogIkJPVUxERVIiLCAiZGF0YV9zb3VyY2UiOiAiQ28uIERpdmlzaW9uIG9mIFdhdGVyIFJlc291cmNlcyIsICJkYXRlX3RpbWUiOiAiMjAyMC0wMy0yM1QxMjozMDowMC4wMDAiLCAiZGl2IjogIjEiLCAiZHdyX2FiYnJldiI6ICJTVkNMT1BDTyIsICJmbGFnIjogbnVsbCwgImh0dHBfbGlua2FnZS51cmwiOiAiaHR0cHM6Ly9kd3Iuc3RhdGUuY28udXMvU3VyZmFjZVdhdGVyL2RhdGEvZGV0YWlsX2dyYXBoLmFzcHg/SUQ9U1ZDTE9QQ09cdTAwMjZNVFlQRT1ESVNDSFJHIiwgImxvY2F0aW9uLmxhdGl0dWRlIjogNDAuMTUzMzQxLCAibG9jYXRpb24ubG9uZ2l0dWRlIjogLTEwNS4wNzU2OTUsICJsb2NhdGlvbi5uZWVkc19yZWNvZGluZyI6IGZhbHNlLCAic3RhZ2UiOiAiMy43MCIsICJzdGF0aW9uX25hbWUiOiAiU0FJTlQgVlJBSU4gQ1JFRUsgQkVMT1cgS0VOIFBSQVRUIEJMVkQgQVQgTE9OR01PTlQsIENPIiwgInN0YXRpb25fc3RhdHVzIjogIkFjdGl2ZSIsICJzdGF0aW9uX3R5cGUiOiAiU3RyZWFtIiwgInVzZ3Nfc3RhdGlvbl9pZCI6IG51bGwsICJ2YXJpYWJsZSI6ICJESVNDSFJHIiwgIndkIjogIjUifSwgInR5cGUiOiAiRmVhdHVyZSJ9LCB7ImJib3giOiBbLTEwNS41MDQ0NCwgMzkuOTYxNjU1LCAtMTA1LjUwNDQ0LCAzOS45NjE2NTVdLCAiZ2VvbWV0cnkiOiB7ImNvb3JkaW5hdGVzIjogWy0xMDUuNTA0NDQsIDM5Ljk2MTY1NV0sICJ0eXBlIjogIlBvaW50In0sICJpZCI6ICIyMSIsICJwcm9wZXJ0aWVzIjogeyJhbW91bnQiOiAiMjcuNjAiLCAiY291bnR5IjogIkJPVUxERVIiLCAiZGF0YV9zb3VyY2UiOiAiQ28uIERpdmlzaW9uIG9mIFdhdGVyIFJlc291cmNlcyIsICJkYXRlX3RpbWUiOiAiMjAyMC0wMy0yM1QxMjoxNTowMC4wMDAiLCAiZGl2IjogIjEiLCAiZHdyX2FiYnJldiI6ICJCT0NNSURDTyIsICJmbGFnIjogbnVsbCwgImh0dHBfbGlua2FnZS51cmwiOiAiaHR0cHM6Ly9kd3Iuc3RhdGUuY28udXMvU3VyZmFjZVdhdGVyL2RhdGEvZGV0YWlsX2dyYXBoLmFzcHg/SUQ9Qk9DTUlEQ09cdTAwMjZNVFlQRT1ESVNDSFJHIiwgImxvY2F0aW9uLmxhdGl0dWRlIjogMzkuOTYxNjU1LCAibG9jYXRpb24ubG9uZ2l0dWRlIjogLTEwNS41MDQ0NCwgImxvY2F0aW9uLm5lZWRzX3JlY29kaW5nIjogZmFsc2UsICJzdGFnZSI6ICIxLjE5IiwgInN0YXRpb25fbmFtZSI6ICJNSURETEUgQk9VTERFUiBDUkVFSyBBVCBORURFUkxBTkQsIENPLiIsICJzdGF0aW9uX3N0YXR1cyI6ICJBY3RpdmUiLCAic3RhdGlvbl90eXBlIjogIlN0cmVhbSIsICJ1c2dzX3N0YXRpb25faWQiOiAiMDY3MjU1MDAiLCAidmFyaWFibGUiOiAiRElTQ0hSRyIsICJ3ZCI6ICI2In0sICJ0eXBlIjogIkZlYXR1cmUifSwgeyJiYm94IjogWy0xMDUuMDk3ODcyLCA0MC4wNTk4MDksIC0xMDUuMDk3ODcyLCA0MC4wNTk4MDldLCAiZ2VvbWV0cnkiOiB7ImNvb3JkaW5hdGVzIjogWy0xMDUuMDk3ODcyLCA0MC4wNTk4MDldLCAidHlwZSI6ICJQb2ludCJ9LCAiaWQiOiAiMjIiLCAicHJvcGVydGllcyI6IHsiYW1vdW50IjogIjUzLjgwIiwgImNvdW50eSI6ICJCT1VMREVSIiwgImRhdGFfc291cmNlIjogIkNvLiBEaXZpc2lvbiBvZiBXYXRlciBSZXNvdXJjZXMiLCAiZGF0ZV90aW1lIjogIjIwMjAtMDMtMjNUMTE6NDU6MDAuMDAwIiwgImRpdiI6ICIxIiwgImR3cl9hYmJyZXYiOiAiQk9DMTA5Q08iLCAiZmxhZyI6IG51bGwsICJodHRwX2xpbmthZ2UudXJsIjogImh0dHBzOi8vZHdyLnN0YXRlLmNvLnVzL1N1cmZhY2VXYXRlci9kYXRhL2RldGFpbF9ncmFwaC5hc3B4P0lEPUJPQzEwOUNPXHUwMDI2TVRZUEU9RElTQ0hSRyIsICJsb2NhdGlvbi5sYXRpdHVkZSI6IDQwLjA1OTgwOSwgImxvY2F0aW9uLmxvbmdpdHVkZSI6IC0xMDUuMDk3ODcyLCAibG9jYXRpb24ubmVlZHNfcmVjb2RpbmciOiBmYWxzZSwgInN0YWdlIjogIjIuNjAiLCAic3RhdGlvbl9uYW1lIjogIkJPVUxERVIgQ1JFRUsgQVQgMTA5IFNUIE5FQVIgRVJJRSwgQ08iLCAic3RhdGlvbl9zdGF0dXMiOiAiQWN0aXZlIiwgInN0YXRpb25fdHlwZSI6ICJTdHJlYW0iLCAidXNnc19zdGF0aW9uX2lkIjogbnVsbCwgInZhcmlhYmxlIjogIkRJU0NIUkciLCAid2QiOiAiNiJ9LCAidHlwZSI6ICJGZWF0dXJlIn0sIHsiYmJveCI6IFstMTA1LjM2MzQyMiwgNDAuMjE1NjU4LCAtMTA1LjM2MzQyMiwgNDAuMjE1NjU4XSwgImdlb21ldHJ5IjogeyJjb29yZGluYXRlcyI6IFstMTA1LjM2MzQyMiwgNDAuMjE1NjU4XSwgInR5cGUiOiAiUG9pbnQifSwgImlkIjogIjIzIiwgInByb3BlcnRpZXMiOiB7ImFtb3VudCI6ICIxOS4zMCIsICJjb3VudHkiOiAiQk9VTERFUiIsICJkYXRhX3NvdXJjZSI6ICJDby4gRGl2aXNpb24gb2YgV2F0ZXIgUmVzb3VyY2VzIiwgImRhdGVfdGltZSI6ICIyMDIwLTAzLTIzVDExOjQ1OjAwLjAwMCIsICJkaXYiOiAiMSIsICJkd3JfYWJicmV2IjogIk5TVkJCUkNPIiwgImZsYWciOiBudWxsLCAiaHR0cF9saW5rYWdlLnVybCI6ICJodHRwczovL2R3ci5zdGF0ZS5jby51cy9TdXJmYWNlV2F0ZXIvZGF0YS9kZXRhaWxfZ3JhcGguYXNweD9JRD1OU1ZCQlJDT1x1MDAyNk1UWVBFPURJU0NIUkciLCAibG9jYXRpb24ubGF0aXR1ZGUiOiA0MC4yMTU2NTgsICJsb2NhdGlvbi5sb25naXR1ZGUiOiAtMTA1LjM2MzQyMiwgImxvY2F0aW9uLm5lZWRzX3JlY29kaW5nIjogZmFsc2UsICJzdGFnZSI6ICIwLjM0IiwgInN0YXRpb25fbmFtZSI6ICJOT1JUSCBTQUlOVCBWUkFJTiBDUkVFSyBCRUxPVyBCVVRUT05ST0NLICAoUkFMUEggUFJJQ0UpIFJFU0VSVk9JUiIsICJzdGF0aW9uX3N0YXR1cyI6ICJBY3RpdmUiLCAic3RhdGlvbl90eXBlIjogIlN0cmVhbSIsICJ1c2dzX3N0YXRpb25faWQiOiBudWxsLCAidmFyaWFibGUiOiAiRElTQ0hSRyIsICJ3ZCI6ICI1In0sICJ0eXBlIjogIkZlYXR1cmUifSwgeyJiYm94IjogWy0xMDUuMjE3NTE5LCA0MC4wODYyNzgsIC0xMDUuMjE3NTE5LCA0MC4wODYyNzhdLCAiZ2VvbWV0cnkiOiB7ImNvb3JkaW5hdGVzIjogWy0xMDUuMjE3NTE5LCA0MC4wODYyNzhdLCAidHlwZSI6ICJQb2ludCJ9LCAiaWQiOiAiMjQiLCAicHJvcGVydGllcyI6IHsiYW1vdW50IjogIjAuMDAiLCAiY291bnR5IjogIkJPVUxERVIiLCAiZGF0YV9zb3VyY2UiOiAiTm9ydGhlcm4gQ29sb3JhZG8gV2F0ZXIgQ29uc2VydmFuY3kgRGlzdHJpY3QiLCAiZGF0ZV90aW1lIjogIjIwMjAtMDMtMjNUMTI6MDA6MDAuMDAwIiwgImRpdiI6ICIxIiwgImR3cl9hYmJyZXYiOiAiQkZDSU5GQ08iLCAiZmxhZyI6IG51bGwsICJodHRwX2xpbmthZ2UudXJsIjogImh0dHA6Ly93d3cubm9ydGhlcm53YXRlci5vcmcvV2F0ZXJQcm9qZWN0cy9XYXRlckRhdGEuYXNweEVhc3RTbG9wZVdhdGVyRGF0YS5hc3B4IiwgImxvY2F0aW9uLmxhdGl0dWRlIjogNDAuMDg2Mjc4LCAibG9jYXRpb24ubG9uZ2l0dWRlIjogLTEwNS4yMTc1MTksICJsb2NhdGlvbi5uZWVkc19yZWNvZGluZyI6IGZhbHNlLCAic3RhZ2UiOiAiMC4wMSIsICJzdGF0aW9uX25hbWUiOiAiQk9VTERFUiBSRVNFUlZPSVIgSU5MRVQiLCAic3RhdGlvbl9zdGF0dXMiOiAiQWN0aXZlIiwgInN0YXRpb25fdHlwZSI6ICJTdHJlYW0iLCAidXNnc19zdGF0aW9uX2lkIjogIkVTMTkxNiIsICJ2YXJpYWJsZSI6ICJESVNDSFJHIiwgIndkIjogIjYifSwgInR5cGUiOiAiRmVhdHVyZSJ9LCB7ImJib3giOiBbLTEwNS4yMTAzODgwMDAwMDAwMSwgNDAuMTkzMDE5LCAtMTA1LjIxMDM4ODAwMDAwMDAxLCA0MC4xOTMwMTldLCAiZ2VvbWV0cnkiOiB7ImNvb3JkaW5hdGVzIjogWy0xMDUuMjEwMzg4MDAwMDAwMDEsIDQwLjE5MzAxOV0sICJ0eXBlIjogIlBvaW50In0sICJpZCI6ICIyNSIsICJwcm9wZXJ0aWVzIjogeyJhbW91bnQiOiAiMC4wMCIsICJjb3VudHkiOiAiQk9VTERFUiIsICJkYXRhX3NvdXJjZSI6ICJDb29wZXJhdGl2ZSBQcm9ncmFtIG9mIENEV1IsIE5DV0NEIFx1MDAyNiBTVkxIV0NEIiwgImRhdGVfdGltZSI6ICIyMDIwLTAzLTIzVDEyOjAwOjAwLjAwMCIsICJkaXYiOiAiMSIsICJkd3JfYWJicmV2IjogIlRSVURJVENPIiwgImZsYWciOiBudWxsLCAiaHR0cF9saW5rYWdlLnVybCI6ICJodHRwczovL2R3ci5zdGF0ZS5jby51cy9TdXJmYWNlV2F0ZXIvZGF0YS9kZXRhaWxfZ3JhcGguYXNweD9JRD1UUlVESVRDT1x1MDAyNk1UWVBFPURJU0NIUkciLCAibG9jYXRpb24ubGF0aXR1ZGUiOiA0MC4xOTMwMTksICJsb2NhdGlvbi5sb25naXR1ZGUiOiAtMTA1LjIxMDM4OCwgImxvY2F0aW9uLm5lZWRzX3JlY29kaW5nIjogZmFsc2UsICJzdGFnZSI6IG51bGwsICJzdGF0aW9uX25hbWUiOiAiVFJVRSBBTkQgV0VCU1RFUiBESVRDSCIsICJzdGF0aW9uX3N0YXR1cyI6ICJBY3RpdmUiLCAic3RhdGlvbl90eXBlIjogIkRpdmVyc2lvbiIsICJ1c2dzX3N0YXRpb25faWQiOiBudWxsLCAidmFyaWFibGUiOiAiRElTQ0hSRyIsICJ3ZCI6ICI1In0sICJ0eXBlIjogIkZlYXR1cmUifSwgeyJiYm94IjogWy0xMDUuMjUxODI2LCA0MC4yMTI2NTgsIC0xMDUuMjUxODI2LCA0MC4yMTI2NThdLCAiZ2VvbWV0cnkiOiB7ImNvb3JkaW5hdGVzIjogWy0xMDUuMjUxODI2LCA0MC4yMTI2NThdLCAidHlwZSI6ICJQb2ludCJ9LCAiaWQiOiAiMjYiLCAicHJvcGVydGllcyI6IHsiYW1vdW50IjogIjAuMDAiLCAiY291bnR5IjogIkJPVUxERVIiLCAiZGF0YV9zb3VyY2UiOiAiQ29vcGVyYXRpdmUgUHJvZ3JhbSBvZiBDRFdSLCBOQ1dDRCBcdTAwMjYgU1ZMSFdDRCIsICJkYXRlX3RpbWUiOiAiMjAyMC0wMy0yM1QxMjowMDowMC4wMDAiLCAiZGl2IjogIjEiLCAiZHdyX2FiYnJldiI6ICJST1VSRUFDTyIsICJmbGFnIjogbnVsbCwgImh0dHBfbGlua2FnZS51cmwiOiAiaHR0cHM6Ly9kd3Iuc3RhdGUuY28udXMvU3VyZmFjZVdhdGVyL2RhdGEvZGV0YWlsX2dyYXBoLmFzcHg/SUQ9Uk9VUkVBQ09cdTAwMjZNVFlQRT1ESVNDSFJHIiwgImxvY2F0aW9uLmxhdGl0dWRlIjogNDAuMjEyNjU4LCAibG9jYXRpb24ubG9uZ2l0dWRlIjogLTEwNS4yNTE4MjYsICJsb2NhdGlvbi5uZWVkc19yZWNvZGluZyI6IGZhbHNlLCAic3RhZ2UiOiBudWxsLCAic3RhdGlvbl9uYW1lIjogIlJPVUdIIEFORCBSRUFEWSBESVRDSCIsICJzdGF0aW9uX3N0YXR1cyI6ICJBY3RpdmUiLCAic3RhdGlvbl90eXBlIjogIkRpdmVyc2lvbiIsICJ1c2dzX3N0YXRpb25faWQiOiBudWxsLCAidmFyaWFibGUiOiAiRElTQ0hSRyIsICJ3ZCI6ICI1In0sICJ0eXBlIjogIkZlYXR1cmUifSwgeyJiYm94IjogWy0xMDUuMTY3ODczLCA0MC4xNzQ4NDQsIC0xMDUuMTY3ODczLCA0MC4xNzQ4NDRdLCAiZ2VvbWV0cnkiOiB7ImNvb3JkaW5hdGVzIjogWy0xMDUuMTY3ODczLCA0MC4xNzQ4NDRdLCAidHlwZSI6ICJQb2ludCJ9LCAiaWQiOiAiMjciLCAicHJvcGVydGllcyI6IHsiYW1vdW50IjogIjAuMTUiLCAiY291bnR5IjogIkJPVUxERVIiLCAiZGF0YV9zb3VyY2UiOiAiQ29vcGVyYXRpdmUgUHJvZ3JhbSBvZiBDRFdSLCBOQ1dDRCBcdTAwMjYgU1ZMSFdDRCIsICJkYXRlX3RpbWUiOiAiMjAyMC0wMy0yM1QxMTo0NTowMC4wMDAiLCAiZGl2IjogIjEiLCAiZHdyX2FiYnJldiI6ICJIR1JNRFdDTyIsICJmbGFnIjogbnVsbCwgImh0dHBfbGlua2FnZS51cmwiOiAiaHR0cHM6Ly9kd3Iuc3RhdGUuY28udXMvU3VyZmFjZVdhdGVyL2RhdGEvZGV0YWlsX2dyYXBoLmFzcHg/SUQ9SEdSTURXQ09cdTAwMjZNVFlQRT1ESVNDSFJHIiwgImxvY2F0aW9uLmxhdGl0dWRlIjogNDAuMTc0ODQ0LCAibG9jYXRpb24ubG9uZ2l0dWRlIjogLTEwNS4xNjc4NzMsICJsb2NhdGlvbi5uZWVkc19yZWNvZGluZyI6IGZhbHNlLCAic3RhZ2UiOiAiMC4wOCIsICJzdGF0aW9uX25hbWUiOiAiSEFHRVIgTUVBRE9XUyBESVRDSCIsICJzdGF0aW9uX3N0YXR1cyI6ICJBY3RpdmUiLCAic3RhdGlvbl90eXBlIjogIkRpdmVyc2lvbiIsICJ1c2dzX3N0YXRpb25faWQiOiBudWxsLCAidmFyaWFibGUiOiAiRElTQ0hSRyIsICJ3ZCI6ICI1In0sICJ0eXBlIjogIkZlYXR1cmUifSwgeyJiYm94IjogWy0xMDUuMjA5NDE2LCA0MC4yNTYyNzYwMDAwMDAwMSwgLTEwNS4yMDk0MTYsIDQwLjI1NjI3NjAwMDAwMDAxXSwgImdlb21ldHJ5IjogeyJjb29yZGluYXRlcyI6IFstMTA1LjIwOTQxNiwgNDAuMjU2Mjc2MDAwMDAwMDFdLCAidHlwZSI6ICJQb2ludCJ9LCAiaWQiOiAiMjgiLCAicHJvcGVydGllcyI6IHsiYW1vdW50IjogIjAuMDAiLCAiY291bnR5IjogIkJPVUxERVIiLCAiZGF0YV9zb3VyY2UiOiAiTm9ydGhlcm4gQ29sb3JhZG8gV2F0ZXIgQ29uc2VydmFuY3kgRGlzdHJpY3QiLCAiZGF0ZV90aW1lIjogIjIwMjAtMDMtMjNUMTI6MDA6MDAuMDAwIiwgImRpdiI6ICIxIiwgImR3cl9hYmJyZXYiOiAiTElUVEgxQ08iLCAiZmxhZyI6IG51bGwsICJodHRwX2xpbmthZ2UudXJsIjogImh0dHA6Ly93d3cubm9ydGhlcm53YXRlci5vcmcvV2F0ZXJQcm9qZWN0cy9XYXRlckRhdGEuYXNweEVhc3RTbG9wZVdhdGVyRGF0YS5hc3B4IiwgImxvY2F0aW9uLmxhdGl0dWRlIjogNDAuMjU2Mjc2LCAibG9jYXRpb24ubG9uZ2l0dWRlIjogLTEwNS4yMDk0MTYsICJsb2NhdGlvbi5uZWVkc19yZWNvZGluZyI6IGZhbHNlLCAic3RhZ2UiOiBudWxsLCAic3RhdGlvbl9uYW1lIjogIkxJVFRMRSBUSE9NUFNPTiAjMSBESVRDSCIsICJzdGF0aW9uX3N0YXR1cyI6ICJBY3RpdmUiLCAic3RhdGlvbl90eXBlIjogIkRpdmVyc2lvbiIsICJ1c2dzX3N0YXRpb25faWQiOiAiRVMxOTAxIiwgInZhcmlhYmxlIjogIkRJU0NIUkciLCAid2QiOiAiNCJ9LCAidHlwZSI6ICJGZWF0dXJlIn0sIHsiYmJveCI6IFstMTA1LjE5ODU2NywgNDAuMjYwODI3LCAtMTA1LjE5ODU2NywgNDAuMjYwODI3XSwgImdlb21ldHJ5IjogeyJjb29yZGluYXRlcyI6IFstMTA1LjE5ODU2NywgNDAuMjYwODI3XSwgInR5cGUiOiAiUG9pbnQifSwgImlkIjogIjI5IiwgInByb3BlcnRpZXMiOiB7ImFtb3VudCI6ICIwLjAwIiwgImNvdW50eSI6ICJCT1VMREVSIiwgImRhdGFfc291cmNlIjogIkNvb3BlcmF0aXZlIFNEUiBQcm9ncmFtIG9mIENEV1IgXHUwMDI2IE5DV0NEIiwgImRhdGVfdGltZSI6ICIyMDIwLTAzLTIzVDEyOjAwOjAwLjAwMCIsICJkaXYiOiAiMSIsICJkd3JfYWJicmV2IjogIkNVTERJVENPIiwgImZsYWciOiBudWxsLCAiaHR0cF9saW5rYWdlLnVybCI6ICJodHRwczovL2R3ci5zdGF0ZS5jby51cy9TdXJmYWNlV2F0ZXIvZGF0YS9kZXRhaWxfZ3JhcGguYXNweD9JRD1DVUxESVRDT1x1MDAyNk1UWVBFPURJU0NIUkciLCAibG9jYXRpb24ubGF0aXR1ZGUiOiA0MC4yNjA4MjcsICJsb2NhdGlvbi5sb25naXR1ZGUiOiAtMTA1LjE5ODU2NywgImxvY2F0aW9uLm5lZWRzX3JlY29kaW5nIjogZmFsc2UsICJzdGFnZSI6IG51bGwsICJzdGF0aW9uX25hbWUiOiAiQ1VMVkVSIERJVENIIiwgInN0YXRpb25fc3RhdHVzIjogIkFjdGl2ZSIsICJzdGF0aW9uX3R5cGUiOiAiRGl2ZXJzaW9uIiwgInVzZ3Nfc3RhdGlvbl9pZCI6IG51bGwsICJ2YXJpYWJsZSI6ICJESVNDSFJHIiwgIndkIjogIjQifSwgInR5cGUiOiAiRmVhdHVyZSJ9LCB7ImJib3giOiBbLTEwNS4yNTYwMTcsIDQwLjIxNTA0MywgLTEwNS4yNTYwMTcsIDQwLjIxNTA0M10sICJnZW9tZXRyeSI6IHsiY29vcmRpbmF0ZXMiOiBbLTEwNS4yNTYwMTcsIDQwLjIxNTA0M10sICJ0eXBlIjogIlBvaW50In0sICJpZCI6ICIzMCIsICJwcm9wZXJ0aWVzIjogeyJhbW91bnQiOiAiMzguMDAiLCAiY291bnR5IjogIkJPVUxERVIiLCAiZGF0YV9zb3VyY2UiOiAiQ28uIERpdmlzaW9uIG9mIFdhdGVyIFJlc291cmNlcyIsICJkYXRlX3RpbWUiOiAiMjAyMC0wMy0yM1QxMjozMDowMC4wMDAiLCAiZGl2IjogIjEiLCAiZHdyX2FiYnJldiI6ICJISUdITERDTyIsICJmbGFnIjogbnVsbCwgImh0dHBfbGlua2FnZS51cmwiOiAiaHR0cHM6Ly9kd3Iuc3RhdGUuY28udXMvU3VyZmFjZVdhdGVyL2RhdGEvZGV0YWlsX2dyYXBoLmFzcHg/SUQ9SElHSExEQ09cdTAwMjZNVFlQRT1ESVNDSFJHIiwgImxvY2F0aW9uLmxhdGl0dWRlIjogNDAuMjE1MDQzLCAibG9jYXRpb24ubG9uZ2l0dWRlIjogLTEwNS4yNTYwMTcsICJsb2NhdGlvbi5uZWVkc19yZWNvZGluZyI6IGZhbHNlLCAic3RhZ2UiOiAiMC43MSIsICJzdGF0aW9uX25hbWUiOiAiSElHSExBTkQgRElUQ0ggQVQgTFlPTlMsIENPIiwgInN0YXRpb25fc3RhdHVzIjogIkFjdGl2ZSIsICJzdGF0aW9uX3R5cGUiOiAiRGl2ZXJzaW9uIiwgInVzZ3Nfc3RhdGlvbl9pZCI6IG51bGwsICJ2YXJpYWJsZSI6ICJESVNDSFJHIiwgIndkIjogIjUifSwgInR5cGUiOiAiRmVhdHVyZSJ9LCB7ImJib3giOiBbLTEwNS4yMjA0OTcsIDQwLjA3ODU2LCAtMTA1LjIyMDQ5NywgNDAuMDc4NTZdLCAiZ2VvbWV0cnkiOiB7ImNvb3JkaW5hdGVzIjogWy0xMDUuMjIwNDk3LCA0MC4wNzg1Nl0sICJ0eXBlIjogIlBvaW50In0sICJpZCI6ICIzMSIsICJwcm9wZXJ0aWVzIjogeyJhbW91bnQiOiAiNTIyMi4wMCIsICJjb3VudHkiOiAiQk9VTERFUiIsICJkYXRhX3NvdXJjZSI6ICJOb3J0aGVybiBDb2xvcmFkbyBXYXRlciBDb25zZXJ2YW5jeSBEaXN0cmljdCIsICJkYXRlX3RpbWUiOiAiMjAyMC0wMy0yM1QxMjowMDowMC4wMDAiLCAiZGl2IjogIjEiLCAiZHdyX2FiYnJldiI6ICJCT1VSRVNDTyIsICJmbGFnIjogbnVsbCwgImh0dHBfbGlua2FnZS51cmwiOiAiaHR0cDovL3d3dy5ub3J0aGVybndhdGVyLm9yZy9XYXRlclByb2plY3RzL1dhdGVyRGF0YS5hc3B4RWFzdFNsb3BlV2F0ZXJEYXRhLmFzcHgiLCAibG9jYXRpb24ubGF0aXR1ZGUiOiA0MC4wNzg1NiwgImxvY2F0aW9uLmxvbmdpdHVkZSI6IC0xMDUuMjIwNDk3LCAibG9jYXRpb24ubmVlZHNfcmVjb2RpbmciOiBmYWxzZSwgInN0YWdlIjogbnVsbCwgInN0YXRpb25fbmFtZSI6ICJCT1VMREVSIFJFU0VSVk9JUiIsICJzdGF0aW9uX3N0YXR1cyI6ICJBY3RpdmUiLCAic3RhdGlvbl90eXBlIjogIlJlc2Vydm9pciIsICJ1c2dzX3N0YXRpb25faWQiOiAiRVIxOTE0IiwgInZhcmlhYmxlIjogIlNUT1JBR0UiLCAid2QiOiAiNiJ9LCAidHlwZSI6ICJGZWF0dXJlIn0sIHsiYmJveCI6IFstMTA1LjE2OTM3NCwgNDAuMTczOTUsIC0xMDUuMTY5Mzc0LCA0MC4xNzM5NV0sICJnZW9tZXRyeSI6IHsiY29vcmRpbmF0ZXMiOiBbLTEwNS4xNjkzNzQsIDQwLjE3Mzk1XSwgInR5cGUiOiAiUG9pbnQifSwgImlkIjogIjMyIiwgInByb3BlcnRpZXMiOiB7ImFtb3VudCI6ICIwLjE5IiwgImNvdW50eSI6ICJCT1VMREVSIiwgImRhdGFfc291cmNlIjogIkNvb3BlcmF0aXZlIFByb2dyYW0gb2YgQ0RXUiwgTkNXQ0QgXHUwMDI2IFNWTEhXQ0QiLCAiZGF0ZV90aW1lIjogIjIwMjAtMDMtMjNUMTE6MzA6MDAuMDAwIiwgImRpdiI6ICIxIiwgImR3cl9hYmJyZXYiOiAiTklXRElUQ08iLCAiZmxhZyI6IG51bGwsICJodHRwX2xpbmthZ2UudXJsIjogImh0dHBzOi8vZHdyLnN0YXRlLmNvLnVzL1N1cmZhY2VXYXRlci9kYXRhL2RldGFpbF9ncmFwaC5hc3B4P0lEPU5JV0RJVENPXHUwMDI2TVRZUEU9RElTQ0hSRyIsICJsb2NhdGlvbi5sYXRpdHVkZSI6IDQwLjE3Mzk1LCAibG9jYXRpb24ubG9uZ2l0dWRlIjogLTEwNS4xNjkzNzQsICJsb2NhdGlvbi5uZWVkc19yZWNvZGluZyI6IGZhbHNlLCAic3RhZ2UiOiAiMC4wOSIsICJzdGF0aW9uX25hbWUiOiAiTklXT1QgRElUQ0giLCAic3RhdGlvbl9zdGF0dXMiOiAiQWN0aXZlIiwgInN0YXRpb25fdHlwZSI6ICJEaXZlcnNpb24iLCAidXNnc19zdGF0aW9uX2lkIjogbnVsbCwgInZhcmlhYmxlIjogIkRJU0NIUkciLCAid2QiOiAiNSJ9LCAidHlwZSI6ICJGZWF0dXJlIn0sIHsiYmJveCI6IFstMTA1LjI1MDk1MiwgNDAuMjExMzg5LCAtMTA1LjI1MDk1MiwgNDAuMjExMzg5XSwgImdlb21ldHJ5IjogeyJjb29yZGluYXRlcyI6IFstMTA1LjI1MDk1MiwgNDAuMjExMzg5XSwgInR5cGUiOiAiUG9pbnQifSwgImlkIjogIjMzIiwgInByb3BlcnRpZXMiOiB7ImFtb3VudCI6ICIwLjAwIiwgImNvdW50eSI6ICJCT1VMREVSIiwgImRhdGFfc291cmNlIjogIkNvb3BlcmF0aXZlIFByb2dyYW0gb2YgQ0RXUiwgTkNXQ0QgXHUwMDI2IFNWTEhXQ0QiLCAiZGF0ZV90aW1lIjogIjIwMjAtMDMtMjNUMTE6MDA6MDAuMDAwIiwgImRpdiI6ICIxIiwgImR3cl9hYmJyZXYiOiAiU01FRElUQ08iLCAiZmxhZyI6IG51bGwsICJodHRwX2xpbmthZ2UudXJsIjogImh0dHBzOi8vZHdyLnN0YXRlLmNvLnVzL1N1cmZhY2VXYXRlci9kYXRhL2RldGFpbF9ncmFwaC5hc3B4P0lEPVNNRURJVENPXHUwMDI2TVRZUEU9RElTQ0hSRyIsICJsb2NhdGlvbi5sYXRpdHVkZSI6IDQwLjIxMTM4OSwgImxvY2F0aW9uLmxvbmdpdHVkZSI6IC0xMDUuMjUwOTUyLCAibG9jYXRpb24ubmVlZHNfcmVjb2RpbmciOiBmYWxzZSwgInN0YWdlIjogbnVsbCwgInN0YXRpb25fbmFtZSI6ICJTTUVBRCBESVRDSCIsICJzdGF0aW9uX3N0YXR1cyI6ICJBY3RpdmUiLCAic3RhdGlvbl90eXBlIjogIkRpdmVyc2lvbiIsICJ1c2dzX3N0YXRpb25faWQiOiBudWxsLCAidmFyaWFibGUiOiAiRElTQ0hSRyIsICJ3ZCI6ICI1In0sICJ0eXBlIjogIkZlYXR1cmUifSwgeyJiYm94IjogWy0xMDUuMDg4Njk1LCA0MC4xNTMzNjMsIC0xMDUuMDg4Njk1LCA0MC4xNTMzNjNdLCAiZ2VvbWV0cnkiOiB7ImNvb3JkaW5hdGVzIjogWy0xMDUuMDg4Njk1LCA0MC4xNTMzNjNdLCAidHlwZSI6ICJQb2ludCJ9LCAiaWQiOiAiMzQiLCAicHJvcGVydGllcyI6IHsiYW1vdW50IjogIjAuMTAiLCAiY291bnR5IjogIkJPVUxERVIiLCAiZGF0YV9zb3VyY2UiOiAiQ29vcGVyYXRpdmUgUHJvZ3JhbSBvZiBDRFdSLCBOQ1dDRCBcdTAwMjYgU1ZMSFdDRCIsICJkYXRlX3RpbWUiOiAiMjAyMC0wMy0yM1QxMjowMDowMC4wMDAiLCAiZGl2IjogIjEiLCAiZHdyX2FiYnJldiI6ICJCT05ESVRDTyIsICJmbGFnIjogbnVsbCwgImh0dHBfbGlua2FnZS51cmwiOiAiaHR0cHM6Ly9kd3Iuc3RhdGUuY28udXMvU3VyZmFjZVdhdGVyL2RhdGEvZGV0YWlsX2dyYXBoLmFzcHg/SUQ9Qk9ORElUQ09cdTAwMjZNVFlQRT1ESVNDSFJHIiwgImxvY2F0aW9uLmxhdGl0dWRlIjogNDAuMTUzMzYzLCAibG9jYXRpb24ubG9uZ2l0dWRlIjogLTEwNS4wODg2OTUsICJsb2NhdGlvbi5uZWVkc19yZWNvZGluZyI6IGZhbHNlLCAic3RhZ2UiOiAiMC4wNCIsICJzdGF0aW9uX25hbWUiOiAiQk9OVVMgRElUQ0giLCAic3RhdGlvbl9zdGF0dXMiOiAiQWN0aXZlIiwgInN0YXRpb25fdHlwZSI6ICJEaXZlcnNpb24iLCAidXNnc19zdGF0aW9uX2lkIjogbnVsbCwgInZhcmlhYmxlIjogIkRJU0NIUkciLCAid2QiOiAiNSJ9LCAidHlwZSI6ICJGZWF0dXJlIn0sIHsiYmJveCI6IFstMTA1LjI1MDkyNywgNDAuMjExMDgzLCAtMTA1LjI1MDkyNywgNDAuMjExMDgzXSwgImdlb21ldHJ5IjogeyJjb29yZGluYXRlcyI6IFstMTA1LjI1MDkyNywgNDAuMjExMDgzXSwgInR5cGUiOiAiUG9pbnQifSwgImlkIjogIjM1IiwgInByb3BlcnRpZXMiOiB7ImFtb3VudCI6ICIwLjAwIiwgImNvdW50eSI6ICJCT1VMREVSIiwgImRhdGFfc291cmNlIjogIkNvb3BlcmF0aXZlIFByb2dyYW0gb2YgQ0RXUiwgTkNXQ0QgXHUwMDI2IFNWTEhXQ0QiLCAiZGF0ZV90aW1lIjogIjIwMjAtMDMtMjNUMTE6MDA6MDAuMDAwIiwgImRpdiI6ICIxIiwgImR3cl9hYmJyZXYiOiAiU1dFRElUQ08iLCAiZmxhZyI6IG51bGwsICJodHRwX2xpbmthZ2UudXJsIjogImh0dHBzOi8vZHdyLnN0YXRlLmNvLnVzL1N1cmZhY2VXYXRlci9kYXRhL2RldGFpbF9ncmFwaC5hc3B4P0lEPVNXRURJVENPXHUwMDI2TVRZUEU9RElTQ0hSRyIsICJsb2NhdGlvbi5sYXRpdHVkZSI6IDQwLjIxMTA4MywgImxvY2F0aW9uLmxvbmdpdHVkZSI6IC0xMDUuMjUwOTI3LCAibG9jYXRpb24ubmVlZHNfcmVjb2RpbmciOiBmYWxzZSwgInN0YWdlIjogIi0wLjA1IiwgInN0YXRpb25fbmFtZSI6ICJTV0VERSBESVRDSCIsICJzdGF0aW9uX3N0YXR1cyI6ICJBY3RpdmUiLCAic3RhdGlvbl90eXBlIjogIkRpdmVyc2lvbiIsICJ1c2dzX3N0YXRpb25faWQiOiBudWxsLCAidmFyaWFibGUiOiAiRElTQ0hSRyIsICJ3ZCI6ICI1In0sICJ0eXBlIjogIkZlYXR1cmUifSwgeyJiYm94IjogWy0xMDUuMTg5MTMyLCA0MC4xODc1MjQsIC0xMDUuMTg5MTMyLCA0MC4xODc1MjRdLCAiZ2VvbWV0cnkiOiB7ImNvb3JkaW5hdGVzIjogWy0xMDUuMTg5MTMyLCA0MC4xODc1MjRdLCAidHlwZSI6ICJQb2ludCJ9LCAiaWQiOiAiMzYiLCAicHJvcGVydGllcyI6IHsiYW1vdW50IjogIjAuMDAiLCAiY291bnR5IjogIkJPVUxERVIiLCAiZGF0YV9zb3VyY2UiOiAiQ29vcGVyYXRpdmUgUHJvZ3JhbSBvZiBDRFdSLCBOQ1dDRCBcdTAwMjYgU1ZMSFdDRCIsICJkYXRlX3RpbWUiOiAiMjAyMC0wMy0yM1QxMjowMDowMC4wMDAiLCAiZGl2IjogIjEiLCAiZHdyX2FiYnJldiI6ICJSVU5ZT05DTyIsICJmbGFnIjogbnVsbCwgImh0dHBfbGlua2FnZS51cmwiOiAiaHR0cHM6Ly9kd3Iuc3RhdGUuY28udXMvU3VyZmFjZVdhdGVyL2RhdGEvZGV0YWlsX2dyYXBoLmFzcHg/SUQ9UlVOWU9OQ09cdTAwMjZNVFlQRT1ESVNDSFJHIiwgImxvY2F0aW9uLmxhdGl0dWRlIjogNDAuMTg3NTI0LCAibG9jYXRpb24ubG9uZ2l0dWRlIjogLTEwNS4xODkxMzIsICJsb2NhdGlvbi5uZWVkc19yZWNvZGluZyI6IGZhbHNlLCAic3RhZ2UiOiAiNTAuNzkiLCAic3RhdGlvbl9uYW1lIjogIlJVTllPTiBESVRDSCIsICJzdGF0aW9uX3N0YXR1cyI6ICJBY3RpdmUiLCAic3RhdGlvbl90eXBlIjogIkRpdmVyc2lvbiIsICJ1c2dzX3N0YXRpb25faWQiOiBudWxsLCAidmFyaWFibGUiOiAiRElTQ0hSRyIsICJ3ZCI6ICI1In0sICJ0eXBlIjogIkZlYXR1cmUifSwgeyJiYm94IjogWy0xMDUuMTk2Nzc1LCA0MC4xODE4OCwgLTEwNS4xOTY3NzUsIDQwLjE4MTg4XSwgImdlb21ldHJ5IjogeyJjb29yZGluYXRlcyI6IFstMTA1LjE5Njc3NSwgNDAuMTgxODhdLCAidHlwZSI6ICJQb2ludCJ9LCAiaWQiOiAiMzciLCAicHJvcGVydGllcyI6IHsiYW1vdW50IjogIjAuMDAiLCAiY291bnR5IjogIkJPVUxERVIiLCAiZGF0YV9zb3VyY2UiOiAiQ29vcGVyYXRpdmUgUHJvZ3JhbSBvZiBDRFdSLCBOQ1dDRCBcdTAwMjYgU1ZMSFdDRCIsICJkYXRlX3RpbWUiOiAiMjAyMC0wMy0yM1QxMTo0NTowMC4wMDAiLCAiZGl2IjogIjEiLCAiZHdyX2FiYnJldiI6ICJEQVZET1dDTyIsICJmbGFnIjogbnVsbCwgImh0dHBfbGlua2FnZS51cmwiOiAiaHR0cHM6Ly9kd3Iuc3RhdGUuY28udXMvU3VyZmFjZVdhdGVyL2RhdGEvZGV0YWlsX2dyYXBoLmFzcHg/SUQ9REFWRE9XQ09cdTAwMjZNVFlQRT1ESVNDSFJHIiwgImxvY2F0aW9uLmxhdGl0dWRlIjogNDAuMTgxODgsICJsb2NhdGlvbi5sb25naXR1ZGUiOiAtMTA1LjE5Njc3NSwgImxvY2F0aW9uLm5lZWRzX3JlY29kaW5nIjogZmFsc2UsICJzdGFnZSI6IG51bGwsICJzdGF0aW9uX25hbWUiOiAiREFWSVMgQU5EIERPV05JTkcgRElUQ0giLCAic3RhdGlvbl9zdGF0dXMiOiAiQWN0aXZlIiwgInN0YXRpb25fdHlwZSI6ICJEaXZlcnNpb24iLCAidXNnc19zdGF0aW9uX2lkIjogbnVsbCwgInZhcmlhYmxlIjogIkRJU0NIUkciLCAid2QiOiAiNSJ9LCAidHlwZSI6ICJGZWF0dXJlIn0sIHsiYmJveCI6IFstMTA1LjMyNjI1LCA0MC4wMTg2NjcsIC0xMDUuMzI2MjUsIDQwLjAxODY2N10sICJnZW9tZXRyeSI6IHsiY29vcmRpbmF0ZXMiOiBbLTEwNS4zMjYyNSwgNDAuMDE4NjY3XSwgInR5cGUiOiAiUG9pbnQifSwgImlkIjogIjM4IiwgInByb3BlcnRpZXMiOiB7ImFtb3VudCI6ICIwLjc0IiwgImNvdW50eSI6ICJCT1VMREVSIiwgImRhdGFfc291cmNlIjogIlUuUy4gR2VvbG9naWNhbCBTdXJ2ZXkiLCAiZGF0ZV90aW1lIjogIjIwMTktMTAtMDJUMTQ6NTA6MDAuMDAwIiwgImRpdiI6ICIxIiwgImR3cl9hYmJyZXYiOiAiRk9VT1JPQ08iLCAiZmxhZyI6IG51bGwsICJodHRwX2xpbmthZ2UudXJsIjogImh0dHBzOi8vd2F0ZXJkYXRhLnVzZ3MuZ292L253aXMvdXY/MDY3Mjc1MDAiLCAibG9jYXRpb24ubGF0aXR1ZGUiOiA0MC4wMTg2NjcsICJsb2NhdGlvbi5sb25naXR1ZGUiOiAtMTA1LjMyNjI1LCAibG9jYXRpb24ubmVlZHNfcmVjb2RpbmciOiBmYWxzZSwgInN0YWdlIjogbnVsbCwgInN0YXRpb25fbmFtZSI6ICJGT1VSTUlMRSBDUkVFSyBBVCBPUk9ERUxMLCBDTyIsICJzdGF0aW9uX3N0YXR1cyI6ICJBY3RpdmUiLCAic3RhdGlvbl90eXBlIjogIlN0cmVhbSIsICJ1c2dzX3N0YXRpb25faWQiOiAiMDY3Mjc1MDAiLCAidmFyaWFibGUiOiAiRElTQ0hSRyIsICJ3ZCI6ICI2In0sICJ0eXBlIjogIkZlYXR1cmUifSwgeyJiYm94IjogWy0xMDUuMjA5MjgyLCA0MC4xODg1NzksIC0xMDUuMjA5MjgyLCA0MC4xODg1NzldLCAiZ2VvbWV0cnkiOiB7ImNvb3JkaW5hdGVzIjogWy0xMDUuMjA5MjgyLCA0MC4xODg1NzldLCAidHlwZSI6ICJQb2ludCJ9LCAiaWQiOiAiMzkiLCAicHJvcGVydGllcyI6IHsiYW1vdW50IjogIjAuMTIiLCAiY291bnR5IjogIkJPVUxERVIiLCAiZGF0YV9zb3VyY2UiOiAiQ29vcGVyYXRpdmUgUHJvZ3JhbSBvZiBDRFdSLCBOQ1dDRCBcdTAwMjYgU1ZMSFdDRCIsICJkYXRlX3RpbWUiOiAiMjAyMC0wMy0yM1QxMTo0NTowMC4wMDAiLCAiZGl2IjogIjEiLCAiZHdyX2FiYnJldiI6ICJKQU1ESVRDTyIsICJmbGFnIjogbnVsbCwgImh0dHBfbGlua2FnZS51cmwiOiAiaHR0cHM6Ly9kd3Iuc3RhdGUuY28udXMvU3VyZmFjZVdhdGVyL2RhdGEvZGV0YWlsX2dyYXBoLmFzcHg/SUQ9SkFNRElUQ09cdTAwMjZNVFlQRT1ESVNDSFJHIiwgImxvY2F0aW9uLmxhdGl0dWRlIjogNDAuMTg4NTc5LCAibG9jYXRpb24ubG9uZ2l0dWRlIjogLTEwNS4yMDkyODIsICJsb2NhdGlvbi5uZWVkc19yZWNvZGluZyI6IGZhbHNlLCAic3RhZ2UiOiAiMC4wNCIsICJzdGF0aW9uX25hbWUiOiAiSkFNRVMgRElUQ0giLCAic3RhdGlvbl9zdGF0dXMiOiAiQWN0aXZlIiwgInN0YXRpb25fdHlwZSI6ICJEaXZlcnNpb24iLCAidXNnc19zdGF0aW9uX2lkIjogbnVsbCwgInZhcmlhYmxlIjogIkRJU0NIUkciLCAid2QiOiAiNSJ9LCAidHlwZSI6ICJGZWF0dXJlIn0sIHsiYmJveCI6IFstMTA1LjE5MzA0OCwgNDAuMDUzMDM1LCAtMTA1LjE5MzA0OCwgNDAuMDUzMDM1XSwgImdlb21ldHJ5IjogeyJjb29yZGluYXRlcyI6IFstMTA1LjE5MzA0OCwgNDAuMDUzMDM1XSwgInR5cGUiOiAiUG9pbnQifSwgImlkIjogIjQwIiwgInByb3BlcnRpZXMiOiB7ImFtb3VudCI6ICIwLjAwIiwgImNvdW50eSI6ICJCT1VMREVSIiwgImRhdGFfc291cmNlIjogIk5vcnRoZXJuIENvbG9yYWRvIFdhdGVyIENvbnNlcnZhbmN5IERpc3RyaWN0IiwgImRhdGVfdGltZSI6ICIyMDIwLTAzLTIzVDEyOjAwOjAwLjAwMCIsICJkaXYiOiAiMSIsICJkd3JfYWJicmV2IjogIkJDU0NCQ0NPIiwgImZsYWciOiBudWxsLCAiaHR0cF9saW5rYWdlLnVybCI6ICJodHRwOi8vd3d3Lm5vcnRoZXJud2F0ZXIub3JnL1dhdGVyUHJvamVjdHMvV2F0ZXJEYXRhLmFzcHhFYXN0U2xvcGVXYXRlckRhdGEuYXNweCIsICJsb2NhdGlvbi5sYXRpdHVkZSI6IDQwLjA1MzAzNSwgImxvY2F0aW9uLmxvbmdpdHVkZSI6IC0xMDUuMTkzMDQ4LCAibG9jYXRpb24ubmVlZHNfcmVjb2RpbmciOiBmYWxzZSwgInN0YWdlIjogIjAuMDAiLCAic3RhdGlvbl9uYW1lIjogIkJPVUxERVIgQ1JFRUsgU1VQUExZIENBTkFMIFRPIEJPVUxERVIgQ1JFRUsgTkVBUiBCT1VMREVSIiwgInN0YXRpb25fc3RhdHVzIjogIkFjdGl2ZSIsICJzdGF0aW9uX3R5cGUiOiAiRGl2ZXJzaW9uIiwgInVzZ3Nfc3RhdGlvbl9pZCI6ICJFUzE5MTciLCAidmFyaWFibGUiOiAiRElTQ0hSRyIsICJ3ZCI6ICI2In0sICJ0eXBlIjogIkZlYXR1cmUifSwgeyJiYm94IjogWy0xMDUuMTc0OTU3LCA0MC4yNTgzNjcsIC0xMDUuMTc0OTU3LCA0MC4yNTgzNjddLCAiZ2VvbWV0cnkiOiB7ImNvb3JkaW5hdGVzIjogWy0xMDUuMTc0OTU3LCA0MC4yNTgzNjddLCAidHlwZSI6ICJQb2ludCJ9LCAiaWQiOiAiNDEiLCAicHJvcGVydGllcyI6IHsiYW1vdW50IjogIjAuMDAiLCAiY291bnR5IjogIkJPVUxERVIiLCAiZGF0YV9zb3VyY2UiOiAiQ28uIERpdmlzaW9uIG9mIFdhdGVyIFJlc291cmNlcyIsICJkYXRlX3RpbWUiOiAiMjAyMC0wMy0yM1QxMjozMDowMC4wMDAiLCAiZGl2IjogIjEiLCAiZHdyX2FiYnJldiI6ICJCT1VMQVJDTyIsICJmbGFnIjogbnVsbCwgImh0dHBfbGlua2FnZS51cmwiOiAiaHR0cHM6Ly9kd3Iuc3RhdGUuY28udXMvU3VyZmFjZVdhdGVyL2RhdGEvZGV0YWlsX2dyYXBoLmFzcHg/SUQ9Qk9VTEFSQ09cdTAwMjZNVFlQRT1ESVNDSFJHIiwgImxvY2F0aW9uLmxhdGl0dWRlIjogNDAuMjU4MzY3LCAibG9jYXRpb24ubG9uZ2l0dWRlIjogLTEwNS4xNzQ5NTcsICJsb2NhdGlvbi5uZWVkc19yZWNvZGluZyI6IGZhbHNlLCAic3RhZ2UiOiAiLTAuMTIiLCAic3RhdGlvbl9uYW1lIjogIkJPVUxERVItTEFSSU1FUiBESVRDSCBORUFSIEJFUlRIT1VEIiwgInN0YXRpb25fc3RhdHVzIjogIkFjdGl2ZSIsICJzdGF0aW9uX3R5cGUiOiAiRGl2ZXJzaW9uIiwgInVzZ3Nfc3RhdGlvbl9pZCI6IG51bGwsICJ2YXJpYWJsZSI6ICJESVNDSFJHIiwgIndkIjogIjQifSwgInR5cGUiOiAiRmVhdHVyZSJ9LCB7ImJib3giOiBbLTEwNS4zNDc5MDYsIDM5LjkzODM1MSwgLTEwNS4zNDc5MDYsIDM5LjkzODM1MV0sICJnZW9tZXRyeSI6IHsiY29vcmRpbmF0ZXMiOiBbLTEwNS4zNDc5MDYsIDM5LjkzODM1MV0sICJ0eXBlIjogIlBvaW50In0sICJpZCI6ICI0MiIsICJwcm9wZXJ0aWVzIjogeyJhbW91bnQiOiAiMTYuNDAiLCAiY291bnR5IjogIkJPVUxERVIiLCAiZGF0YV9zb3VyY2UiOiAiQ28uIERpdmlzaW9uIG9mIFdhdGVyIFJlc291cmNlcyIsICJkYXRlX3RpbWUiOiAiMjAyMC0wMy0yM1QwOToxNTowMC4wMDAiLCAiZGl2IjogIjEiLCAiZHdyX2FiYnJldiI6ICJCT0NCR1JDTyIsICJmbGFnIjogbnVsbCwgImh0dHBfbGlua2FnZS51cmwiOiAiaHR0cHM6Ly9kd3Iuc3RhdGUuY28udXMvU3VyZmFjZVdhdGVyL2RhdGEvZGV0YWlsX2dyYXBoLmFzcHg/SUQ9Qk9DQkdSQ09cdTAwMjZNVFlQRT1ESVNDSFJHIiwgImxvY2F0aW9uLmxhdGl0dWRlIjogMzkuOTM4MzUxLCAibG9jYXRpb24ubG9uZ2l0dWRlIjogLTEwNS4zNDc5MDYsICJsb2NhdGlvbi5uZWVkc19yZWNvZGluZyI6IGZhbHNlLCAic3RhZ2UiOiAiMC4zNiIsICJzdGF0aW9uX25hbWUiOiAiU09VVEggQk9VTERFUiBDUkVFSyBCRUxPVyBHUk9TUyBSRVNFUlZPSVIiLCAic3RhdGlvbl9zdGF0dXMiOiAiQWN0aXZlIiwgInN0YXRpb25fdHlwZSI6ICJTdHJlYW0iLCAidXNnc19zdGF0aW9uX2lkIjogIjA2NzI5NDUwIiwgInZhcmlhYmxlIjogIkRJU0NIUkciLCAid2QiOiAiNiJ9LCAidHlwZSI6ICJGZWF0dXJlIn0sIHsiYmJveCI6IFstMTA1LjI1MTgyNiwgNDAuMjEyNTA1LCAtMTA1LjI1MTgyNiwgNDAuMjEyNTA1XSwgImdlb21ldHJ5IjogeyJjb29yZGluYXRlcyI6IFstMTA1LjI1MTgyNiwgNDAuMjEyNTA1XSwgInR5cGUiOiAiUG9pbnQifSwgImlkIjogIjQzIiwgInByb3BlcnRpZXMiOiB7ImFtb3VudCI6ICIwLjI3IiwgImNvdW50eSI6ICJCT1VMREVSIiwgImRhdGFfc291cmNlIjogIkNvb3BlcmF0aXZlIFByb2dyYW0gb2YgQ0RXUiwgTkNXQ0QgXHUwMDI2IFNWTEhXQ0QiLCAiZGF0ZV90aW1lIjogIjIwMjAtMDMtMjNUMTI6MDA6MDAuMDAwIiwgImRpdiI6ICIxIiwgImR3cl9hYmJyZXYiOiAiUEFMRElUQ08iLCAiZmxhZyI6IG51bGwsICJodHRwX2xpbmthZ2UudXJsIjogImh0dHBzOi8vZHdyLnN0YXRlLmNvLnVzL1N1cmZhY2VXYXRlci9kYXRhL2RldGFpbF9ncmFwaC5hc3B4P0lEPVBBTERJVENPXHUwMDI2TVRZUEU9RElTQ0hSRyIsICJsb2NhdGlvbi5sYXRpdHVkZSI6IDQwLjIxMjUwNSwgImxvY2F0aW9uLmxvbmdpdHVkZSI6IC0xMDUuMjUxODI2LCAibG9jYXRpb24ubmVlZHNfcmVjb2RpbmciOiBmYWxzZSwgInN0YWdlIjogIjAuMDUiLCAic3RhdGlvbl9uYW1lIjogIlBBTE1FUlRPTiBESVRDSCIsICJzdGF0aW9uX3N0YXR1cyI6ICJBY3RpdmUiLCAic3RhdGlvbl90eXBlIjogIkRpdmVyc2lvbiIsICJ1c2dzX3N0YXRpb25faWQiOiBudWxsLCAidmFyaWFibGUiOiAiRElTQ0hSRyIsICJ3ZCI6ICI1In0sICJ0eXBlIjogIkZlYXR1cmUifSwgeyJiYm94IjogWy0xMDUuMjU5Nzk1LCA0MC4yMTkwNDYsIC0xMDUuMjU5Nzk1LCA0MC4yMTkwNDZdLCAiZ2VvbWV0cnkiOiB7ImNvb3JkaW5hdGVzIjogWy0xMDUuMjU5Nzk1LCA0MC4yMTkwNDZdLCAidHlwZSI6ICJQb2ludCJ9LCAiaWQiOiAiNDQiLCAicHJvcGVydGllcyI6IHsiYW1vdW50IjogIjAuMDAiLCAiY291bnR5IjogIkJPVUxERVIiLCAiZGF0YV9zb3VyY2UiOiAiQ29vcGVyYXRpdmUgUHJvZ3JhbSBvZiBDRFdSLCBOQ1dDRCBcdTAwMjYgU1ZMSFdDRCIsICJkYXRlX3RpbWUiOiAiMjAyMC0wMy0yM1QxMTo0NTowMC4wMDAiLCAiZGl2IjogIjEiLCAiZHdyX2FiYnJldiI6ICJTVVBESVRDTyIsICJmbGFnIjogbnVsbCwgImh0dHBfbGlua2FnZS51cmwiOiAiaHR0cHM6Ly9kd3Iuc3RhdGUuY28udXMvU3VyZmFjZVdhdGVyL2RhdGEvZGV0YWlsX2dyYXBoLmFzcHg/SUQ9U1VQRElUQ09cdTAwMjZNVFlQRT1ESVNDSFJHIiwgImxvY2F0aW9uLmxhdGl0dWRlIjogNDAuMjE5MDQ2LCAibG9jYXRpb24ubG9uZ2l0dWRlIjogLTEwNS4yNTk3OTUsICJsb2NhdGlvbi5uZWVkc19yZWNvZGluZyI6IGZhbHNlLCAic3RhZ2UiOiAiMC4wMCIsICJzdGF0aW9uX25hbWUiOiAiU1VQUExZIERJVENIIiwgInN0YXRpb25fc3RhdHVzIjogIkFjdGl2ZSIsICJzdGF0aW9uX3R5cGUiOiAiRGl2ZXJzaW9uIiwgInVzZ3Nfc3RhdGlvbl9pZCI6IG51bGwsICJ2YXJpYWJsZSI6ICJESVNDSFJHIiwgIndkIjogIjUifSwgInR5cGUiOiAiRmVhdHVyZSJ9LCB7ImJib3giOiBbLTEwNS4xODkxOTEsIDQwLjE4NzU3OCwgLTEwNS4xODkxOTEsIDQwLjE4NzU3OF0sICJnZW9tZXRyeSI6IHsiY29vcmRpbmF0ZXMiOiBbLTEwNS4xODkxOTEsIDQwLjE4NzU3OF0sICJ0eXBlIjogIlBvaW50In0sICJpZCI6ICI0NSIsICJwcm9wZXJ0aWVzIjogeyJhbW91bnQiOiAiMjgxOS42OCIsICJjb3VudHkiOiAiQk9VTERFUiIsICJkYXRhX3NvdXJjZSI6ICJDb29wZXJhdGl2ZSBQcm9ncmFtIG9mIENEV1IsIE5DV0NEIFx1MDAyNiBTVkxIV0NEIiwgImRhdGVfdGltZSI6ICIyMDIwLTAzLTIzVDEyOjAwOjAwLjAwMCIsICJkaXYiOiAiMSIsICJkd3JfYWJicmV2IjogIkRFTlRBWUNPIiwgImZsYWciOiBudWxsLCAiaHR0cF9saW5rYWdlLnVybCI6ICJodHRwczovL2R3ci5zdGF0ZS5jby51cy9TdXJmYWNlV2F0ZXIvZGF0YS9kZXRhaWxfZ3JhcGguYXNweD9JRD1ERU5UQVlDT1x1MDAyNk1UWVBFPURJU0NIUkciLCAibG9jYXRpb24ubGF0aXR1ZGUiOiA0MC4xODc1NzgsICJsb2NhdGlvbi5sb25naXR1ZGUiOiAtMTA1LjE4OTE5MSwgImxvY2F0aW9uLm5lZWRzX3JlY29kaW5nIjogZmFsc2UsICJzdGFnZSI6ICI2Mi4zMSIsICJzdGF0aW9uX25hbWUiOiAiREVOSU8gVEFZTE9SIERJVENIIiwgInN0YXRpb25fc3RhdHVzIjogIkFjdGl2ZSIsICJzdGF0aW9uX3R5cGUiOiAiRGl2ZXJzaW9uIiwgInVzZ3Nfc3RhdGlvbl9pZCI6IG51bGwsICJ2YXJpYWJsZSI6ICJESVNDSFJHIiwgIndkIjogIjUifSwgInR5cGUiOiAiRmVhdHVyZSJ9LCB7ImJib3giOiBbLTEwNS4zNjQ5MTcwMDAwMDAwMiwgNDAuMDQyMDI4LCAtMTA1LjM2NDkxNzAwMDAwMDAyLCA0MC4wNDIwMjhdLCAiZ2VvbWV0cnkiOiB7ImNvb3JkaW5hdGVzIjogWy0xMDUuMzY0OTE3MDAwMDAwMDIsIDQwLjA0MjAyOF0sICJ0eXBlIjogIlBvaW50In0sICJpZCI6ICI0NiIsICJwcm9wZXJ0aWVzIjogeyJhbW91bnQiOiBudWxsLCAiY291bnR5IjogIkJPVUxERVIiLCAiZGF0YV9zb3VyY2UiOiAiVS5TLiBHZW9sb2dpY2FsIFN1cnZleSIsICJkYXRlX3RpbWUiOiAiMTk5OS0wOS0zMFQwMDowMDowMC4wMDAiLCAiZGl2IjogIjEiLCAiZHdyX2FiYnJldiI6ICJGUk1MTVJDTyIsICJmbGFnIjogbnVsbCwgImh0dHBfbGlua2FnZS51cmwiOiAiaHR0cHM6Ly93YXRlcmRhdGEudXNncy5nb3Yvbndpcy91dj8wNjcyNzQxMCIsICJsb2NhdGlvbi5sYXRpdHVkZSI6IDQwLjA0MjAyOCwgImxvY2F0aW9uLmxvbmdpdHVkZSI6IC0xMDUuMzY0OTE3LCAibG9jYXRpb24ubmVlZHNfcmVjb2RpbmciOiBmYWxzZSwgInN0YWdlIjogbnVsbCwgInN0YXRpb25fbmFtZSI6ICJGT1VSTUlMRSBDUkVFSyBBVCBMT0dBTiBNSUxMIFJPQUQgTkVBUiBDUklTTUFOLCBDTyIsICJzdGF0aW9uX3N0YXR1cyI6ICJBY3RpdmUiLCAic3RhdGlvbl90eXBlIjogIlN0cmVhbSIsICJ1c2dzX3N0YXRpb25faWQiOiAiMDY3Mjc0MTAiLCAidmFyaWFibGUiOiAiRElTQ0hSRyIsICJ3ZCI6ICI2In0sICJ0eXBlIjogIkZlYXR1cmUifSwgeyJiYm94IjogWy0xMDUuMTc4NTY3LCA0MC4xNzcwODAwMDAwMDAwMDQsIC0xMDUuMTc4NTY3LCA0MC4xNzcwODAwMDAwMDAwMDRdLCAiZ2VvbWV0cnkiOiB7ImNvb3JkaW5hdGVzIjogWy0xMDUuMTc4NTY3LCA0MC4xNzcwODAwMDAwMDAwMDRdLCAidHlwZSI6ICJQb2ludCJ9LCAiaWQiOiAiNDciLCAicHJvcGVydGllcyI6IHsiYW1vdW50IjogIjEuMjkiLCAiY291bnR5IjogIkJPVUxERVIiLCAiZGF0YV9zb3VyY2UiOiAiQ29vcGVyYXRpdmUgU0RSIFByb2dyYW0gb2YgQ0RXUiBcdTAwMjYgTkNXQ0QiLCAiZGF0ZV90aW1lIjogIjIwMjAtMDMtMjNUMTI6MDA6MDAuMDAwIiwgImRpdiI6ICIxIiwgImR3cl9hYmJyZXYiOiAiUENLUEVMQ08iLCAiZmxhZyI6IG51bGwsICJodHRwX2xpbmthZ2UudXJsIjogImh0dHBzOi8vZHdyLnN0YXRlLmNvLnVzL1N1cmZhY2VXYXRlci9kYXRhL2RldGFpbF9ncmFwaC5hc3B4P0lEPVBDS1BFTENPXHUwMDI2TVRZUEU9RElTQ0hSRyIsICJsb2NhdGlvbi5sYXRpdHVkZSI6IDQwLjE3NzA4LCAibG9jYXRpb24ubG9uZ2l0dWRlIjogLTEwNS4xNzg1NjcsICJsb2NhdGlvbi5uZWVkc19yZWNvZGluZyI6IGZhbHNlLCAic3RhZ2UiOiAiMC4xNiIsICJzdGF0aW9uX25hbWUiOiAiUEVDSyBQRUxMQSBDTE9WRVIgRElUQ0giLCAic3RhdGlvbl9zdGF0dXMiOiAiQWN0aXZlIiwgInN0YXRpb25fdHlwZSI6ICJEaXZlcnNpb24iLCAidXNnc19zdGF0aW9uX2lkIjogbnVsbCwgInZhcmlhYmxlIjogIkRJU0NIUkciLCAid2QiOiAiNSJ9LCAidHlwZSI6ICJGZWF0dXJlIn0sIHsiYmJveCI6IFstMTA1LjM1NzMwOCwgMzkuOTQ3NzA0LCAtMTA1LjM1NzMwOCwgMzkuOTQ3NzA0XSwgImdlb21ldHJ5IjogeyJjb29yZGluYXRlcyI6IFstMTA1LjM1NzMwOCwgMzkuOTQ3NzA0XSwgInR5cGUiOiAiUG9pbnQifSwgImlkIjogIjQ4IiwgInByb3BlcnRpZXMiOiB7ImFtb3VudCI6ICIxMTM2NS4wMCIsICJjb3VudHkiOiAiQk9VTERFUiIsICJkYXRhX3NvdXJjZSI6ICJDby4gRGl2aXNpb24gb2YgV2F0ZXIgUmVzb3VyY2VzIiwgImRhdGVfdGltZSI6ICIyMDIwLTAzLTIzVDEyOjMwOjAwLjAwMCIsICJkaXYiOiAiMSIsICJkd3JfYWJicmV2IjogIkdST1NSRUNPIiwgImZsYWciOiBudWxsLCAiaHR0cF9saW5rYWdlLnVybCI6ICJodHRwczovL2R3ci5zdGF0ZS5jby51cy9TdXJmYWNlV2F0ZXIvZGF0YS9kZXRhaWxfZ3JhcGguYXNweD9JRD1HUk9TUkVDT1x1MDAyNk1UWVBFPVNUT1JBR0UiLCAibG9jYXRpb24ubGF0aXR1ZGUiOiAzOS45NDc3MDQsICJsb2NhdGlvbi5sb25naXR1ZGUiOiAtMTA1LjM1NzMwOCwgImxvY2F0aW9uLm5lZWRzX3JlY29kaW5nIjogZmFsc2UsICJzdGFnZSI6ICI3MTc1LjYwIiwgInN0YXRpb25fbmFtZSI6ICJHUk9TUyBSRVNFUlZPSVIgIiwgInN0YXRpb25fc3RhdHVzIjogIkFjdGl2ZSIsICJzdGF0aW9uX3R5cGUiOiAiUmVzZXJ2b2lyIiwgInVzZ3Nfc3RhdGlvbl9pZCI6IG51bGwsICJ2YXJpYWJsZSI6ICJTVE9SQUdFIiwgIndkIjogIjYifSwgInR5cGUiOiAiRmVhdHVyZSJ9XSwgInR5cGUiOiAiRmVhdHVyZUNvbGxlY3Rpb24ifSk7CiAgICAgICAgCjwvc2NyaXB0Pg== onload="this.contentDocument.open();this.contentDocument.write(atob(this.getAttribute('data-html')));this.contentDocument.close();" allowfullscreen webkitallowfullscreen mozallowfullscreen></iframe></div></div>





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



<div style="width:100%;"><div style="position:relative;width:100%;height:0;padding-bottom:60%;"><iframe src="about:blank" style="position:absolute;width:100%;height:100%;left:0;top:0;border:none !important;" data-html=PCFET0NUWVBFIGh0bWw+CjxoZWFkPiAgICAKICAgIDxtZXRhIGh0dHAtZXF1aXY9ImNvbnRlbnQtdHlwZSIgY29udGVudD0idGV4dC9odG1sOyBjaGFyc2V0PVVURi04IiAvPgogICAgCiAgICAgICAgPHNjcmlwdD4KICAgICAgICAgICAgTF9OT19UT1VDSCA9IGZhbHNlOwogICAgICAgICAgICBMX0RJU0FCTEVfM0QgPSBmYWxzZTsKICAgICAgICA8L3NjcmlwdD4KICAgIAogICAgPHNjcmlwdCBzcmM9Imh0dHBzOi8vY2RuLmpzZGVsaXZyLm5ldC9ucG0vbGVhZmxldEAxLjUuMS9kaXN0L2xlYWZsZXQuanMiPjwvc2NyaXB0PgogICAgPHNjcmlwdCBzcmM9Imh0dHBzOi8vY29kZS5qcXVlcnkuY29tL2pxdWVyeS0xLjEyLjQubWluLmpzIj48L3NjcmlwdD4KICAgIDxzY3JpcHQgc3JjPSJodHRwczovL21heGNkbi5ib290c3RyYXBjZG4uY29tL2Jvb3RzdHJhcC8zLjIuMC9qcy9ib290c3RyYXAubWluLmpzIj48L3NjcmlwdD4KICAgIDxzY3JpcHQgc3JjPSJodHRwczovL2NkbmpzLmNsb3VkZmxhcmUuY29tL2FqYXgvbGlicy9MZWFmbGV0LmF3ZXNvbWUtbWFya2Vycy8yLjAuMi9sZWFmbGV0LmF3ZXNvbWUtbWFya2Vycy5qcyI+PC9zY3JpcHQ+CiAgICA8bGluayByZWw9InN0eWxlc2hlZXQiIGhyZWY9Imh0dHBzOi8vY2RuLmpzZGVsaXZyLm5ldC9ucG0vbGVhZmxldEAxLjUuMS9kaXN0L2xlYWZsZXQuY3NzIi8+CiAgICA8bGluayByZWw9InN0eWxlc2hlZXQiIGhyZWY9Imh0dHBzOi8vbWF4Y2RuLmJvb3RzdHJhcGNkbi5jb20vYm9vdHN0cmFwLzMuMi4wL2Nzcy9ib290c3RyYXAubWluLmNzcyIvPgogICAgPGxpbmsgcmVsPSJzdHlsZXNoZWV0IiBocmVmPSJodHRwczovL21heGNkbi5ib290c3RyYXBjZG4uY29tL2Jvb3RzdHJhcC8zLjIuMC9jc3MvYm9vdHN0cmFwLXRoZW1lLm1pbi5jc3MiLz4KICAgIDxsaW5rIHJlbD0ic3R5bGVzaGVldCIgaHJlZj0iaHR0cHM6Ly9tYXhjZG4uYm9vdHN0cmFwY2RuLmNvbS9mb250LWF3ZXNvbWUvNC42LjMvY3NzL2ZvbnQtYXdlc29tZS5taW4uY3NzIi8+CiAgICA8bGluayByZWw9InN0eWxlc2hlZXQiIGhyZWY9Imh0dHBzOi8vY2RuanMuY2xvdWRmbGFyZS5jb20vYWpheC9saWJzL0xlYWZsZXQuYXdlc29tZS1tYXJrZXJzLzIuMC4yL2xlYWZsZXQuYXdlc29tZS1tYXJrZXJzLmNzcyIvPgogICAgPGxpbmsgcmVsPSJzdHlsZXNoZWV0IiBocmVmPSJodHRwczovL3Jhd2Nkbi5naXRoYWNrLmNvbS9weXRob24tdmlzdWFsaXphdGlvbi9mb2xpdW0vbWFzdGVyL2ZvbGl1bS90ZW1wbGF0ZXMvbGVhZmxldC5hd2Vzb21lLnJvdGF0ZS5jc3MiLz4KICAgIDxzdHlsZT5odG1sLCBib2R5IHt3aWR0aDogMTAwJTtoZWlnaHQ6IDEwMCU7bWFyZ2luOiAwO3BhZGRpbmc6IDA7fTwvc3R5bGU+CiAgICA8c3R5bGU+I21hcCB7cG9zaXRpb246YWJzb2x1dGU7dG9wOjA7Ym90dG9tOjA7cmlnaHQ6MDtsZWZ0OjA7fTwvc3R5bGU+CiAgICAKICAgICAgICAgICAgPG1ldGEgbmFtZT0idmlld3BvcnQiIGNvbnRlbnQ9IndpZHRoPWRldmljZS13aWR0aCwKICAgICAgICAgICAgICAgIGluaXRpYWwtc2NhbGU9MS4wLCBtYXhpbXVtLXNjYWxlPTEuMCwgdXNlci1zY2FsYWJsZT1ubyIgLz4KICAgICAgICAgICAgPHN0eWxlPgogICAgICAgICAgICAgICAgI21hcF9jMjAwY2UyNDAzODY0NDQ1OGFlMDQwMmIwNGQ0MTRlNiB7CiAgICAgICAgICAgICAgICAgICAgcG9zaXRpb246IHJlbGF0aXZlOwogICAgICAgICAgICAgICAgICAgIHdpZHRoOiAxMDAuMCU7CiAgICAgICAgICAgICAgICAgICAgaGVpZ2h0OiAxMDAuMCU7CiAgICAgICAgICAgICAgICAgICAgbGVmdDogMC4wJTsKICAgICAgICAgICAgICAgICAgICB0b3A6IDAuMCU7CiAgICAgICAgICAgICAgICB9CiAgICAgICAgICAgIDwvc3R5bGU+CiAgICAgICAgCiAgICA8c2NyaXB0IHNyYz0iaHR0cHM6Ly9jZG5qcy5jbG91ZGZsYXJlLmNvbS9hamF4L2xpYnMvbGVhZmxldC5tYXJrZXJjbHVzdGVyLzEuMS4wL2xlYWZsZXQubWFya2VyY2x1c3Rlci5qcyI+PC9zY3JpcHQ+CiAgICA8bGluayByZWw9InN0eWxlc2hlZXQiIGhyZWY9Imh0dHBzOi8vY2RuanMuY2xvdWRmbGFyZS5jb20vYWpheC9saWJzL2xlYWZsZXQubWFya2VyY2x1c3Rlci8xLjEuMC9NYXJrZXJDbHVzdGVyLmNzcyIvPgogICAgPGxpbmsgcmVsPSJzdHlsZXNoZWV0IiBocmVmPSJodHRwczovL2NkbmpzLmNsb3VkZmxhcmUuY29tL2FqYXgvbGlicy9sZWFmbGV0Lm1hcmtlcmNsdXN0ZXIvMS4xLjAvTWFya2VyQ2x1c3Rlci5EZWZhdWx0LmNzcyIvPgo8L2hlYWQ+Cjxib2R5PiAgICAKICAgIAogICAgICAgICAgICA8ZGl2IGNsYXNzPSJmb2xpdW0tbWFwIiBpZD0ibWFwX2MyMDBjZTI0MDM4NjQ0NDU4YWUwNDAyYjA0ZDQxNGU2IiA+PC9kaXY+CiAgICAgICAgCjwvYm9keT4KPHNjcmlwdD4gICAgCiAgICAKICAgICAgICAgICAgdmFyIG1hcF9jMjAwY2UyNDAzODY0NDQ1OGFlMDQwMmIwNGQ0MTRlNiA9IEwubWFwKAogICAgICAgICAgICAgICAgIm1hcF9jMjAwY2UyNDAzODY0NDQ1OGFlMDQwMmIwNGQ0MTRlNiIsCiAgICAgICAgICAgICAgICB7CiAgICAgICAgICAgICAgICAgICAgY2VudGVyOiBbNDAuMDEsIC0xMDUuMjddLAogICAgICAgICAgICAgICAgICAgIGNyczogTC5DUlMuRVBTRzM4NTcsCiAgICAgICAgICAgICAgICAgICAgem9vbTogMTAsCiAgICAgICAgICAgICAgICAgICAgem9vbUNvbnRyb2w6IHRydWUsCiAgICAgICAgICAgICAgICAgICAgcHJlZmVyQ2FudmFzOiBmYWxzZSwKICAgICAgICAgICAgICAgIH0KICAgICAgICAgICAgKTsKCiAgICAgICAgICAgIAoKICAgICAgICAKICAgIAogICAgICAgICAgICB2YXIgdGlsZV9sYXllcl9mMjQxYjM0ZDIyNGU0ZTMyYTYzYjQ1OTUxNjRkMzY5MSA9IEwudGlsZUxheWVyKAogICAgICAgICAgICAgICAgImh0dHBzOi8vY2FydG9kYi1iYXNlbWFwcy17c30uZ2xvYmFsLnNzbC5mYXN0bHkubmV0L2xpZ2h0X2FsbC97en0ve3h9L3t5fS5wbmciLAogICAgICAgICAgICAgICAgeyJhdHRyaWJ1dGlvbiI6ICJcdTAwMjZjb3B5OyBcdTAwM2NhIGhyZWY9XCJodHRwOi8vd3d3Lm9wZW5zdHJlZXRtYXAub3JnL2NvcHlyaWdodFwiXHUwMDNlT3BlblN0cmVldE1hcFx1MDAzYy9hXHUwMDNlIGNvbnRyaWJ1dG9ycyBcdTAwMjZjb3B5OyBcdTAwM2NhIGhyZWY9XCJodHRwOi8vY2FydG9kYi5jb20vYXR0cmlidXRpb25zXCJcdTAwM2VDYXJ0b0RCXHUwMDNjL2FcdTAwM2UsIENhcnRvREIgXHUwMDNjYSBocmVmID1cImh0dHA6Ly9jYXJ0b2RiLmNvbS9hdHRyaWJ1dGlvbnNcIlx1MDAzZWF0dHJpYnV0aW9uc1x1MDAzYy9hXHUwMDNlIiwgImRldGVjdFJldGluYSI6IGZhbHNlLCAibWF4TmF0aXZlWm9vbSI6IDE4LCAibWF4Wm9vbSI6IDE4LCAibWluWm9vbSI6IDAsICJub1dyYXAiOiBmYWxzZSwgIm9wYWNpdHkiOiAxLCAic3ViZG9tYWlucyI6ICJhYmMiLCAidG1zIjogZmFsc2V9CiAgICAgICAgICAgICkuYWRkVG8obWFwX2MyMDBjZTI0MDM4NjQ0NDU4YWUwNDAyYjA0ZDQxNGU2KTsKICAgICAgICAKICAgIAogICAgICAgICAgICB2YXIgbWFya2VyX2NsdXN0ZXJfYzQ5MDZkZWRmODAxNDQyZGEzMjM3NWRlNTNiM2JiMGQgPSBMLm1hcmtlckNsdXN0ZXJHcm91cCgKICAgICAgICAgICAgICAgIHt9CiAgICAgICAgICAgICk7CiAgICAgICAgICAgIG1hcF9jMjAwY2UyNDAzODY0NDQ1OGFlMDQwMmIwNGQ0MTRlNi5hZGRMYXllcihtYXJrZXJfY2x1c3Rlcl9jNDkwNmRlZGY4MDE0NDJkYTMyMzc1ZGU1M2IzYmIwZCk7CiAgICAgICAgCiAgICAKICAgICAgICAgICAgdmFyIG1hcmtlcl9lNTA4YTEyZjRjN2I0ODRkYWJiOTUwYzYwZGM3MjBkMyA9IEwubWFya2VyKAogICAgICAgICAgICAgICAgWzQwLjE4NTAzMywgLTEwNS4xODU3ODldLAogICAgICAgICAgICAgICAge30KICAgICAgICAgICAgKS5hZGRUbyhtYXJrZXJfY2x1c3Rlcl9jNDkwNmRlZGY4MDE0NDJkYTMyMzc1ZGU1M2IzYmIwZCk7CiAgICAgICAgCiAgICAKICAgICAgICB2YXIgcG9wdXBfMTA4NTljOGRjMTBiNDdhNWEzZjNkMGVhM2FmMmUzNTcgPSBMLnBvcHVwKHsibWF4V2lkdGgiOiAiMTAwJSJ9KTsKCiAgICAgICAgCiAgICAgICAgICAgIHZhciBodG1sXzliNWIwNWNmNGM5NjQ5MDNhMzIzYWFjNTRjMTJhMjc0ID0gJChgPGRpdiBpZD0iaHRtbF85YjViMDVjZjRjOTY0OTAzYTMyM2FhYzU0YzEyYTI3NCIgc3R5bGU9IndpZHRoOiAxMDAuMCU7IGhlaWdodDogMTAwLjAlOyI+TmFtZTogWldFQ0sgQU5EIFRVUk5FUiBESVRDSCBQcmVjaXA6IDAuMTQ8L2Rpdj5gKVswXTsKICAgICAgICAgICAgcG9wdXBfMTA4NTljOGRjMTBiNDdhNWEzZjNkMGVhM2FmMmUzNTcuc2V0Q29udGVudChodG1sXzliNWIwNWNmNGM5NjQ5MDNhMzIzYWFjNTRjMTJhMjc0KTsKICAgICAgICAKCiAgICAgICAgbWFya2VyX2U1MDhhMTJmNGM3YjQ4NGRhYmI5NTBjNjBkYzcyMGQzLmJpbmRQb3B1cChwb3B1cF8xMDg1OWM4ZGMxMGI0N2E1YTNmM2QwZWEzYWYyZTM1NykKICAgICAgICA7CgogICAgICAgIAogICAgCiAgICAKICAgICAgICAgICAgdmFyIG1hcmtlcl8yZTk4YzhlMjUyYjc0ZTViOGEwZTA4N2YzMzQ3NWQ0OCA9IEwubWFya2VyKAogICAgICAgICAgICAgICAgWzQwLjIyMDcwMiwgLTEwNS4yNjM0OV0sCiAgICAgICAgICAgICAgICB7fQogICAgICAgICAgICApLmFkZFRvKG1hcmtlcl9jbHVzdGVyX2M0OTA2ZGVkZjgwMTQ0MmRhMzIzNzVkZTUzYjNiYjBkKTsKICAgICAgICAKICAgIAogICAgICAgIHZhciBwb3B1cF82ZWYxZDUwMTAxMjk0ZDg2YTg0YmY2NjNlMTg1ZmY1MCA9IEwucG9wdXAoeyJtYXhXaWR0aCI6ICIxMDAlIn0pOwoKICAgICAgICAKICAgICAgICAgICAgdmFyIGh0bWxfNjcxNzg1ODQxY2FmNDdiZDllYjc0NTEwYWU5ZmVmODQgPSAkKGA8ZGl2IGlkPSJodG1sXzY3MTc4NTg0MWNhZjQ3YmQ5ZWI3NDUxMGFlOWZlZjg0IiBzdHlsZT0id2lkdGg6IDEwMC4wJTsgaGVpZ2h0OiAxMDAuMCU7Ij5OYW1lOiBTQUlOVCBWUkFJTiBDUkVFSyBBVCBMWU9OUywgQ08gUHJlY2lwOiAzNy45MDwvZGl2PmApWzBdOwogICAgICAgICAgICBwb3B1cF82ZWYxZDUwMTAxMjk0ZDg2YTg0YmY2NjNlMTg1ZmY1MC5zZXRDb250ZW50KGh0bWxfNjcxNzg1ODQxY2FmNDdiZDllYjc0NTEwYWU5ZmVmODQpOwogICAgICAgIAoKICAgICAgICBtYXJrZXJfMmU5OGM4ZTI1MmI3NGU1YjhhMGUwODdmMzM0NzVkNDguYmluZFBvcHVwKHBvcHVwXzZlZjFkNTAxMDEyOTRkODZhODRiZjY2M2UxODVmZjUwKQogICAgICAgIDsKCiAgICAgICAgCiAgICAKICAgIAogICAgICAgICAgICB2YXIgbWFya2VyXzdmN2YxNjkwMDYzYTRiOGM5Nzg3ZTY2ZmRmNDlmMThjID0gTC5tYXJrZXIoCiAgICAgICAgICAgICAgICBbNDAuMTk2NDIyLCAtMTA1LjIwNjU5Ml0sCiAgICAgICAgICAgICAgICB7fQogICAgICAgICAgICApLmFkZFRvKG1hcmtlcl9jbHVzdGVyX2M0OTA2ZGVkZjgwMTQ0MmRhMzIzNzVkZTUzYjNiYjBkKTsKICAgICAgICAKICAgIAogICAgICAgIHZhciBwb3B1cF9hYzMxZTg3ZTNlNzk0MjZkOTM5NzIwZTQzNTdhYjFmOSA9IEwucG9wdXAoeyJtYXhXaWR0aCI6ICIxMDAlIn0pOwoKICAgICAgICAKICAgICAgICAgICAgdmFyIGh0bWxfOWNkOWU5NTdmMjBkNDQzMDg4MWExZWNhZmViZGZlNGYgPSAkKGA8ZGl2IGlkPSJodG1sXzljZDllOTU3ZjIwZDQ0MzA4ODFhMWVjYWZlYmRmZTRmIiBzdHlsZT0id2lkdGg6IDEwMC4wJTsgaGVpZ2h0OiAxMDAuMCU7Ij5OYW1lOiBPTElHQVJDSFkgRElUQ0ggRElWRVJTSU9OIFByZWNpcDogOS40NjwvZGl2PmApWzBdOwogICAgICAgICAgICBwb3B1cF9hYzMxZTg3ZTNlNzk0MjZkOTM5NzIwZTQzNTdhYjFmOS5zZXRDb250ZW50KGh0bWxfOWNkOWU5NTdmMjBkNDQzMDg4MWExZWNhZmViZGZlNGYpOwogICAgICAgIAoKICAgICAgICBtYXJrZXJfN2Y3ZjE2OTAwNjNhNGI4Yzk3ODdlNjZmZGY0OWYxOGMuYmluZFBvcHVwKHBvcHVwX2FjMzFlODdlM2U3OTQyNmQ5Mzk3MjBlNDM1N2FiMWY5KQogICAgICAgIDsKCiAgICAgICAgCiAgICAKICAgIAogICAgICAgICAgICB2YXIgbWFya2VyXzI5NmUzNjBiODliYjQ1ZjQ4OTJkMzUwODJlMDZkZTk3ID0gTC5tYXJrZXIoCiAgICAgICAgICAgICAgICBbMzkuOTMxODEzLCAtMTA1LjMwODQzMl0sCiAgICAgICAgICAgICAgICB7fQogICAgICAgICAgICApLmFkZFRvKG1hcmtlcl9jbHVzdGVyX2M0OTA2ZGVkZjgwMTQ0MmRhMzIzNzVkZTUzYjNiYjBkKTsKICAgICAgICAKICAgIAogICAgICAgIHZhciBwb3B1cF9jMTA4ZmM5MDdjZjk0N2VjODM3MzZhMDcwMzE4OGY0MiA9IEwucG9wdXAoeyJtYXhXaWR0aCI6ICIxMDAlIn0pOwoKICAgICAgICAKICAgICAgICAgICAgdmFyIGh0bWxfNmFhNDdkOThhOGJhNDNmZTk4MWRkOGQ5MzRmYTdmMDggPSAkKGA8ZGl2IGlkPSJodG1sXzZhYTQ3ZDk4YThiYTQzZmU5ODFkZDhkOTM0ZmE3ZjA4IiBzdHlsZT0id2lkdGg6IDEwMC4wJTsgaGVpZ2h0OiAxMDAuMCU7Ij5OYW1lOiBTT1VUSCBCT1VMREVSIENSRUVLIERJVkVSU0lPTiBORUFSIEVMRE9SQURPIFNQUklOR1MgUHJlY2lwOiAwLjAwPC9kaXY+YClbMF07CiAgICAgICAgICAgIHBvcHVwX2MxMDhmYzkwN2NmOTQ3ZWM4MzczNmEwNzAzMTg4ZjQyLnNldENvbnRlbnQoaHRtbF82YWE0N2Q5OGE4YmE0M2ZlOTgxZGQ4ZDkzNGZhN2YwOCk7CiAgICAgICAgCgogICAgICAgIG1hcmtlcl8yOTZlMzYwYjg5YmI0NWY0ODkyZDM1MDgyZTA2ZGU5Ny5iaW5kUG9wdXAocG9wdXBfYzEwOGZjOTA3Y2Y5NDdlYzgzNzM2YTA3MDMxODhmNDIpCiAgICAgICAgOwoKICAgICAgICAKICAgIAogICAgCiAgICAgICAgICAgIHZhciBtYXJrZXJfMGFkMmQ5N2VkOGI4NDZiNDliNzk5NmRhY2Q4ODk4ZWUgPSBMLm1hcmtlcigKICAgICAgICAgICAgICAgIFs0MC4xOTM3NTgsIC0xMDUuMjEwMzldLAogICAgICAgICAgICAgICAge30KICAgICAgICAgICAgKS5hZGRUbyhtYXJrZXJfY2x1c3Rlcl9jNDkwNmRlZGY4MDE0NDJkYTMyMzc1ZGU1M2IzYmIwZCk7CiAgICAgICAgCiAgICAKICAgICAgICB2YXIgcG9wdXBfYzRmZGQ0ODVlZjEzNGQwZDgzZDllNWFiNjUxOGI5ZDEgPSBMLnBvcHVwKHsibWF4V2lkdGgiOiAiMTAwJSJ9KTsKCiAgICAgICAgCiAgICAgICAgICAgIHZhciBodG1sXzRmODdiZWRlNDFmOTRlZDc4NjE2NmRlZmY2ODViM2E0ID0gJChgPGRpdiBpZD0iaHRtbF80Zjg3YmVkZTQxZjk0ZWQ3ODYxNjZkZWZmNjg1YjNhNCIgc3R5bGU9IndpZHRoOiAxMDAuMCU7IGhlaWdodDogMTAwLjAlOyI+TmFtZTogQ0xPVUdIIEFORCBUUlVFIERJVENIIFByZWNpcDogMC4wMDwvZGl2PmApWzBdOwogICAgICAgICAgICBwb3B1cF9jNGZkZDQ4NWVmMTM0ZDBkODNkOWU1YWI2NTE4YjlkMS5zZXRDb250ZW50KGh0bWxfNGY4N2JlZGU0MWY5NGVkNzg2MTY2ZGVmZjY4NWIzYTQpOwogICAgICAgIAoKICAgICAgICBtYXJrZXJfMGFkMmQ5N2VkOGI4NDZiNDliNzk5NmRhY2Q4ODk4ZWUuYmluZFBvcHVwKHBvcHVwX2M0ZmRkNDg1ZWYxMzRkMGQ4M2Q5ZTVhYjY1MThiOWQxKQogICAgICAgIDsKCiAgICAgICAgCiAgICAKICAgIAogICAgICAgICAgICB2YXIgbWFya2VyX2ZlNWZjMTFmZDUyYjRlZjM5ZjNmNzhlODZhYzllOGE5ID0gTC5tYXJrZXIoCiAgICAgICAgICAgICAgICBbNDAuMDA2MzgsIC0xMDUuMzMwODQxXSwKICAgICAgICAgICAgICAgIHt9CiAgICAgICAgICAgICkuYWRkVG8obWFya2VyX2NsdXN0ZXJfYzQ5MDZkZWRmODAxNDQyZGEzMjM3NWRlNTNiM2JiMGQpOwogICAgICAgIAogICAgCiAgICAgICAgdmFyIHBvcHVwXzM0MDIyNTVmMWI2NjQ5Mzg4ZWJkYjYwZjdhZjE3YzdjID0gTC5wb3B1cCh7Im1heFdpZHRoIjogIjEwMCUifSk7CgogICAgICAgIAogICAgICAgICAgICB2YXIgaHRtbF82NTExZjJkY2E2YWU0MDI1ODA4ZjVlMjJkMjhiMzJlNyA9ICQoYDxkaXYgaWQ9Imh0bWxfNjUxMWYyZGNhNmFlNDAyNTgwOGY1ZTIyZDI4YjMyZTciIHN0eWxlPSJ3aWR0aDogMTAwLjAlOyBoZWlnaHQ6IDEwMC4wJTsiPk5hbWU6IEJPVUxERVIgQ1JFRUsgTkVBUiBPUk9ERUxMLCBDTy4gUHJlY2lwOiA4Ljc4PC9kaXY+YClbMF07CiAgICAgICAgICAgIHBvcHVwXzM0MDIyNTVmMWI2NjQ5Mzg4ZWJkYjYwZjdhZjE3YzdjLnNldENvbnRlbnQoaHRtbF82NTExZjJkY2E2YWU0MDI1ODA4ZjVlMjJkMjhiMzJlNyk7CiAgICAgICAgCgogICAgICAgIG1hcmtlcl9mZTVmYzExZmQ1MmI0ZWYzOWYzZjc4ZTg2YWM5ZThhOS5iaW5kUG9wdXAocG9wdXBfMzQwMjI1NWYxYjY2NDkzODhlYmRiNjBmN2FmMTdjN2MpCiAgICAgICAgOwoKICAgICAgICAKICAgIAogICAgCiAgICAgICAgICAgIHZhciBtYXJrZXJfNWExYTAwMjFhZjg4NDg5NjgyMDI2NDRlM2I4YTIxYzcgPSBMLm1hcmtlcigKICAgICAgICAgICAgICAgIFs0MC4yMDQxOTMsIC0xMDUuMjE4Nzc3XSwKICAgICAgICAgICAgICAgIHt9CiAgICAgICAgICAgICkuYWRkVG8obWFya2VyX2NsdXN0ZXJfYzQ5MDZkZWRmODAxNDQyZGEzMjM3NWRlNTNiM2JiMGQpOwogICAgICAgIAogICAgCiAgICAgICAgdmFyIHBvcHVwXzk0MzNiZTI3MjEyZDQ5MDk5NThkZmUwYzg0ZGY5NjhjID0gTC5wb3B1cCh7Im1heFdpZHRoIjogIjEwMCUifSk7CgogICAgICAgIAogICAgICAgICAgICB2YXIgaHRtbF9iYTY3YzkxYTZkYWI0NWQ5ODcwOTMzNTkzNmRkZTJkMSA9ICQoYDxkaXYgaWQ9Imh0bWxfYmE2N2M5MWE2ZGFiNDVkOTg3MDkzMzU5MzZkZGUyZDEiIHN0eWxlPSJ3aWR0aDogMTAwLjAlOyBoZWlnaHQ6IDEwMC4wJTsiPk5hbWU6IExPTkdNT05UIFNVUFBMWSBESVRDSCBQcmVjaXA6IDAuMDA8L2Rpdj5gKVswXTsKICAgICAgICAgICAgcG9wdXBfOTQzM2JlMjcyMTJkNDkwOTk1OGRmZTBjODRkZjk2OGMuc2V0Q29udGVudChodG1sX2JhNjdjOTFhNmRhYjQ1ZDk4NzA5MzM1OTM2ZGRlMmQxKTsKICAgICAgICAKCiAgICAgICAgbWFya2VyXzVhMWEwMDIxYWY4ODQ4OTY4MjAyNjQ0ZTNiOGEyMWM3LmJpbmRQb3B1cChwb3B1cF85NDMzYmUyNzIxMmQ0OTA5OTU4ZGZlMGM4NGRmOTY4YykKICAgICAgICA7CgogICAgICAgIAogICAgCiAgICAKICAgICAgICAgICAgdmFyIG1hcmtlcl9iZGJhODMyMDc5NWE0YTg3YmJjZDQ1ZjBhZTMzMWI3NyA9IEwubWFya2VyKAogICAgICAgICAgICAgICAgWzQwLjE3MjkyNSwgLTEwNS4xNjc2MjJdLAogICAgICAgICAgICAgICAge30KICAgICAgICAgICAgKS5hZGRUbyhtYXJrZXJfY2x1c3Rlcl9jNDkwNmRlZGY4MDE0NDJkYTMyMzc1ZGU1M2IzYmIwZCk7CiAgICAgICAgCiAgICAKICAgICAgICB2YXIgcG9wdXBfMTMzMjc3YWNmOTQzNGIyYjhhMWJmNTlhYTBhMmRhMDAgPSBMLnBvcHVwKHsibWF4V2lkdGgiOiAiMTAwJSJ9KTsKCiAgICAgICAgCiAgICAgICAgICAgIHZhciBodG1sXzViMjc1MTE3NDFiMzQxNzBhZTcwNDIyZTU0YmNhMzZmID0gJChgPGRpdiBpZD0iaHRtbF81YjI3NTExNzQxYjM0MTcwYWU3MDQyMmU1NGJjYTM2ZiIgc3R5bGU9IndpZHRoOiAxMDAuMCU7IGhlaWdodDogMTAwLjAlOyI+TmFtZTogTk9SVEhXRVNUIE1VVFVBTCBESVRDSCBQcmVjaXA6IDAuMDA8L2Rpdj5gKVswXTsKICAgICAgICAgICAgcG9wdXBfMTMzMjc3YWNmOTQzNGIyYjhhMWJmNTlhYTBhMmRhMDAuc2V0Q29udGVudChodG1sXzViMjc1MTE3NDFiMzQxNzBhZTcwNDIyZTU0YmNhMzZmKTsKICAgICAgICAKCiAgICAgICAgbWFya2VyX2JkYmE4MzIwNzk1YTRhODdiYmNkNDVmMGFlMzMxYjc3LmJpbmRQb3B1cChwb3B1cF8xMzMyNzdhY2Y5NDM0YjJiOGExYmY1OWFhMGEyZGEwMCkKICAgICAgICA7CgogICAgICAgIAogICAgCiAgICAKICAgICAgICAgICAgdmFyIG1hcmtlcl85ZTk3ZmJmMWY5ZjE0NWMzYjA0YjdkMTlhNzlmNDY3YiA9IEwubWFya2VyKAogICAgICAgICAgICAgICAgWzQwLjEzNDI3OCwgLTEwNS4xMzA4MTldLAogICAgICAgICAgICAgICAge30KICAgICAgICAgICAgKS5hZGRUbyhtYXJrZXJfY2x1c3Rlcl9jNDkwNmRlZGY4MDE0NDJkYTMyMzc1ZGU1M2IzYmIwZCk7CiAgICAgICAgCiAgICAKICAgICAgICB2YXIgcG9wdXBfMGUwNDdlYjE3OGZhNDA3ODhiN2JlZDdiMDU1MzhkZWUgPSBMLnBvcHVwKHsibWF4V2lkdGgiOiAiMTAwJSJ9KTsKCiAgICAgICAgCiAgICAgICAgICAgIHZhciBodG1sXzE3NGVlMjlhNGJkZTRhMTlhMDVhMTAyZDgxYTBlZjYxID0gJChgPGRpdiBpZD0iaHRtbF8xNzRlZTI5YTRiZGU0YTE5YTA1YTEwMmQ4MWEwZWY2MSIgc3R5bGU9IndpZHRoOiAxMDAuMCU7IGhlaWdodDogMTAwLjAlOyI+TmFtZTogTEVGVCBIQU5EIENSRUVLIEFUIEhPVkVSIFJPQUQgTkVBUiBMT05HTU9OVCwgQ08gUHJlY2lwOiA0LjE4PC9kaXY+YClbMF07CiAgICAgICAgICAgIHBvcHVwXzBlMDQ3ZWIxNzhmYTQwNzg4YjdiZWQ3YjA1NTM4ZGVlLnNldENvbnRlbnQoaHRtbF8xNzRlZTI5YTRiZGU0YTE5YTA1YTEwMmQ4MWEwZWY2MSk7CiAgICAgICAgCgogICAgICAgIG1hcmtlcl85ZTk3ZmJmMWY5ZjE0NWMzYjA0YjdkMTlhNzlmNDY3Yi5iaW5kUG9wdXAocG9wdXBfMGUwNDdlYjE3OGZhNDA3ODhiN2JlZDdiMDU1MzhkZWUpCiAgICAgICAgOwoKICAgICAgICAKICAgIAogICAgCiAgICAgICAgICAgIHZhciBtYXJrZXJfZmY3ODc2NjQwOWUyNDFlOTlmNzk3MWFiZmQ1NDhlMjcgPSBMLm1hcmtlcigKICAgICAgICAgICAgICAgIFszOS45ODYxNjksIC0xMDUuMjE4Njc3XSwKICAgICAgICAgICAgICAgIHt9CiAgICAgICAgICAgICkuYWRkVG8obWFya2VyX2NsdXN0ZXJfYzQ5MDZkZWRmODAxNDQyZGEzMjM3NWRlNTNiM2JiMGQpOwogICAgICAgIAogICAgCiAgICAgICAgdmFyIHBvcHVwXzgwYWUwMWJlZGM3YjRkYzU4YWU1M2M2ZWRmNGU3YTk4ID0gTC5wb3B1cCh7Im1heFdpZHRoIjogIjEwMCUifSk7CgogICAgICAgIAogICAgICAgICAgICB2YXIgaHRtbF9lMjUzMmE1Mzc1ODY0ZDQyODBmOGZlYTQ2MTllNTc0ZSA9ICQoYDxkaXYgaWQ9Imh0bWxfZTI1MzJhNTM3NTg2NGQ0MjgwZjhmZWE0NjE5ZTU3NGUiIHN0eWxlPSJ3aWR0aDogMTAwLjAlOyBoZWlnaHQ6IDEwMC4wJTsiPk5hbWU6IERSWSBDUkVFSyBDQVJSSUVSIFByZWNpcDogMC4wMDwvZGl2PmApWzBdOwogICAgICAgICAgICBwb3B1cF84MGFlMDFiZWRjN2I0ZGM1OGFlNTNjNmVkZjRlN2E5OC5zZXRDb250ZW50KGh0bWxfZTI1MzJhNTM3NTg2NGQ0MjgwZjhmZWE0NjE5ZTU3NGUpOwogICAgICAgIAoKICAgICAgICBtYXJrZXJfZmY3ODc2NjQwOWUyNDFlOTlmNzk3MWFiZmQ1NDhlMjcuYmluZFBvcHVwKHBvcHVwXzgwYWUwMWJlZGM3YjRkYzU4YWU1M2M2ZWRmNGU3YTk4KQogICAgICAgIDsKCiAgICAgICAgCiAgICAKICAgIAogICAgICAgICAgICB2YXIgbWFya2VyXzZiYWE3YjBhN2I1ZTQzNjViOGVkODVlZjExMGY0OGFmID0gTC5tYXJrZXIoCiAgICAgICAgICAgICAgICBbNDAuMTYwNzA1LCAtMTA1LjE2ODQ3MV0sCiAgICAgICAgICAgICAgICB7fQogICAgICAgICAgICApLmFkZFRvKG1hcmtlcl9jbHVzdGVyX2M0OTA2ZGVkZjgwMTQ0MmRhMzIzNzVkZTUzYjNiYjBkKTsKICAgICAgICAKICAgIAogICAgICAgIHZhciBwb3B1cF9lNjEyNThlYjBkYjc0MDlhYTZjMTYzMzRhMTAyZTEwMiA9IEwucG9wdXAoeyJtYXhXaWR0aCI6ICIxMDAlIn0pOwoKICAgICAgICAKICAgICAgICAgICAgdmFyIGh0bWxfMzE4NmNmYzY4OTM5NGExNDkwMzhlNDE5OGQyM2I2NDMgPSAkKGA8ZGl2IGlkPSJodG1sXzMxODZjZmM2ODkzOTRhMTQ5MDM4ZTQxOThkMjNiNjQzIiBzdHlsZT0id2lkdGg6IDEwMC4wJTsgaGVpZ2h0OiAxMDAuMCU7Ij5OYW1lOiBQRUNLLVBFTExBIEFVR01FTlRBVElPTiBSRVRVUk4gUHJlY2lwOiAwLjAwPC9kaXY+YClbMF07CiAgICAgICAgICAgIHBvcHVwX2U2MTI1OGViMGRiNzQwOWFhNmMxNjMzNGExMDJlMTAyLnNldENvbnRlbnQoaHRtbF8zMTg2Y2ZjNjg5Mzk0YTE0OTAzOGU0MTk4ZDIzYjY0Myk7CiAgICAgICAgCgogICAgICAgIG1hcmtlcl82YmFhN2IwYTdiNWU0MzY1YjhlZDg1ZWYxMTBmNDhhZi5iaW5kUG9wdXAocG9wdXBfZTYxMjU4ZWIwZGI3NDA5YWE2YzE2MzM0YTEwMmUxMDIpCiAgICAgICAgOwoKICAgICAgICAKICAgIAogICAgCiAgICAgICAgICAgIHZhciBtYXJrZXJfZjZhOWZiOTQxZjU1NGJhMDg3NTAwZGVkNzkyNDNkNTMgPSBMLm1hcmtlcigKICAgICAgICAgICAgICAgIFs0MC4xOTkzMjEsIC0xMDUuMjIyNjM5XSwKICAgICAgICAgICAgICAgIHt9CiAgICAgICAgICAgICkuYWRkVG8obWFya2VyX2NsdXN0ZXJfYzQ5MDZkZWRmODAxNDQyZGEzMjM3NWRlNTNiM2JiMGQpOwogICAgICAgIAogICAgCiAgICAgICAgdmFyIHBvcHVwX2JhZTNjZDcyZGViZDRiMzk5NGY0Zjc5Zjc3MGEzNGE2ID0gTC5wb3B1cCh7Im1heFdpZHRoIjogIjEwMCUifSk7CgogICAgICAgIAogICAgICAgICAgICB2YXIgaHRtbF84YWI2N2Q0NzUzZjg0NWM5YWRjNTgzOTI4MDBmMmJlNSA9ICQoYDxkaXYgaWQ9Imh0bWxfOGFiNjdkNDc1M2Y4NDVjOWFkYzU4MzkyODAwZjJiZTUiIHN0eWxlPSJ3aWR0aDogMTAwLjAlOyBoZWlnaHQ6IDEwMC4wJTsiPk5hbWU6IEdPU1MgRElUQ0ggMSBQcmVjaXA6IDAuMDA8L2Rpdj5gKVswXTsKICAgICAgICAgICAgcG9wdXBfYmFlM2NkNzJkZWJkNGIzOTk0ZjRmNzlmNzcwYTM0YTYuc2V0Q29udGVudChodG1sXzhhYjY3ZDQ3NTNmODQ1YzlhZGM1ODM5MjgwMGYyYmU1KTsKICAgICAgICAKCiAgICAgICAgbWFya2VyX2Y2YTlmYjk0MWY1NTRiYTA4NzUwMGRlZDc5MjQzZDUzLmJpbmRQb3B1cChwb3B1cF9iYWUzY2Q3MmRlYmQ0YjM5OTRmNGY3OWY3NzBhMzRhNikKICAgICAgICA7CgogICAgICAgIAogICAgCiAgICAKICAgICAgICAgICAgdmFyIG1hcmtlcl9kOTU2MjE1Yjg2YTE0NmVmOGE2M2M3YmI3YzI5Y2I4ZiA9IEwubWFya2VyKAogICAgICAgICAgICAgICAgWzQwLjE5MzI4LCAtMTA1LjIxMDQyNF0sCiAgICAgICAgICAgICAgICB7fQogICAgICAgICAgICApLmFkZFRvKG1hcmtlcl9jbHVzdGVyX2M0OTA2ZGVkZjgwMTQ0MmRhMzIzNzVkZTUzYjNiYjBkKTsKICAgICAgICAKICAgIAogICAgICAgIHZhciBwb3B1cF8xYjQ1M2FlNjNiYjk0M2U5OTViNWJhZWJkZmYyODBmYiA9IEwucG9wdXAoeyJtYXhXaWR0aCI6ICIxMDAlIn0pOwoKICAgICAgICAKICAgICAgICAgICAgdmFyIGh0bWxfZDg0ZGE4NmZmMzRmNDIwZmIwMDYzMmNlMGJiYzBiMjUgPSAkKGA8ZGl2IGlkPSJodG1sX2Q4NGRhODZmZjM0ZjQyMGZiMDA2MzJjZTBiYmMwYjI1IiBzdHlsZT0id2lkdGg6IDEwMC4wJTsgaGVpZ2h0OiAxMDAuMCU7Ij5OYW1lOiBXRUJTVEVSIE1DQ0FTTElOIERJVENIIFByZWNpcDogMC4wMDwvZGl2PmApWzBdOwogICAgICAgICAgICBwb3B1cF8xYjQ1M2FlNjNiYjk0M2U5OTViNWJhZWJkZmYyODBmYi5zZXRDb250ZW50KGh0bWxfZDg0ZGE4NmZmMzRmNDIwZmIwMDYzMmNlMGJiYzBiMjUpOwogICAgICAgIAoKICAgICAgICBtYXJrZXJfZDk1NjIxNWI4NmExNDZlZjhhNjNjN2JiN2MyOWNiOGYuYmluZFBvcHVwKHBvcHVwXzFiNDUzYWU2M2JiOTQzZTk5NWI1YmFlYmRmZjI4MGZiKQogICAgICAgIDsKCiAgICAgICAgCiAgICAKICAgIAogICAgICAgICAgICB2YXIgbWFya2VyXzcyNmM3ZmEzM2Q3MzQ0NDA4Y2JmMmI4N2I1NGU0MDQzID0gTC5tYXJrZXIoCiAgICAgICAgICAgICAgICBbNDAuMDUzNjYxLCAtMTA1LjE1MTE0M10sCiAgICAgICAgICAgICAgICB7fQogICAgICAgICAgICApLmFkZFRvKG1hcmtlcl9jbHVzdGVyX2M0OTA2ZGVkZjgwMTQ0MmRhMzIzNzVkZTUzYjNiYjBkKTsKICAgICAgICAKICAgIAogICAgICAgIHZhciBwb3B1cF9lM2JkYzk1OTgzY2I0MzRmYmVmYjNmMDdlMWZhOTMwYiA9IEwucG9wdXAoeyJtYXhXaWR0aCI6ICIxMDAlIn0pOwoKICAgICAgICAKICAgICAgICAgICAgdmFyIGh0bWxfM2MxM2IwZDUwNjI4NDFiMWFhN2RlNDk2OTJjYzA2YTAgPSAkKGA8ZGl2IGlkPSJodG1sXzNjMTNiMGQ1MDYyODQxYjFhYTdkZTQ5NjkyY2MwNmEwIiBzdHlsZT0id2lkdGg6IDEwMC4wJTsgaGVpZ2h0OiAxMDAuMCU7Ij5OYW1lOiBMRUdHRVRUIERJVENIIFByZWNpcDogMi44NDwvZGl2PmApWzBdOwogICAgICAgICAgICBwb3B1cF9lM2JkYzk1OTgzY2I0MzRmYmVmYjNmMDdlMWZhOTMwYi5zZXRDb250ZW50KGh0bWxfM2MxM2IwZDUwNjI4NDFiMWFhN2RlNDk2OTJjYzA2YTApOwogICAgICAgIAoKICAgICAgICBtYXJrZXJfNzI2YzdmYTMzZDczNDQ0MDhjYmYyYjg3YjU0ZTQwNDMuYmluZFBvcHVwKHBvcHVwX2UzYmRjOTU5ODNjYjQzNGZiZWZiM2YwN2UxZmE5MzBiKQogICAgICAgIDsKCiAgICAgICAgCiAgICAKICAgIAogICAgICAgICAgICB2YXIgbWFya2VyXzRlMDYyODM5ZTMwZjQ4ZDRhZTRiYjMyN2JiMGIxMmFjID0gTC5tYXJrZXIoCiAgICAgICAgICAgICAgICBbNDAuMjE2MjYzLCAtMTA1LjM2NTM2NV0sCiAgICAgICAgICAgICAgICB7fQogICAgICAgICAgICApLmFkZFRvKG1hcmtlcl9jbHVzdGVyX2M0OTA2ZGVkZjgwMTQ0MmRhMzIzNzVkZTUzYjNiYjBkKTsKICAgICAgICAKICAgIAogICAgICAgIHZhciBwb3B1cF9iZDlhM2JjY2Q1MWM0MjM2YmQ4Njc1OWU2ODVlMTNiNSA9IEwucG9wdXAoeyJtYXhXaWR0aCI6ICIxMDAlIn0pOwoKICAgICAgICAKICAgICAgICAgICAgdmFyIGh0bWxfYmQxMjM4ZTM2NjJmNGU0MDgwNDMxMzE4YTQyY2JlNmUgPSAkKGA8ZGl2IGlkPSJodG1sX2JkMTIzOGUzNjYyZjRlNDA4MDQzMTMxOGE0MmNiZTZlIiBzdHlsZT0id2lkdGg6IDEwMC4wJTsgaGVpZ2h0OiAxMDAuMCU7Ij5OYW1lOiBCVVRUT05ST0NLIChSQUxQSCBQUklDRSkgUkVTRVJWT0lSIFByZWNpcDogMTI4ODYuMDA8L2Rpdj5gKVswXTsKICAgICAgICAgICAgcG9wdXBfYmQ5YTNiY2NkNTFjNDIzNmJkODY3NTllNjg1ZTEzYjUuc2V0Q29udGVudChodG1sX2JkMTIzOGUzNjYyZjRlNDA4MDQzMTMxOGE0MmNiZTZlKTsKICAgICAgICAKCiAgICAgICAgbWFya2VyXzRlMDYyODM5ZTMwZjQ4ZDRhZTRiYjMyN2JiMGIxMmFjLmJpbmRQb3B1cChwb3B1cF9iZDlhM2JjY2Q1MWM0MjM2YmQ4Njc1OWU2ODVlMTNiNSkKICAgICAgICA7CgogICAgICAgIAogICAgCiAgICAKICAgICAgICAgICAgdmFyIG1hcmtlcl9lMDMzOGI1MDM0NWM0YTkyYjQ0ODk5Nzc1NjkzODdlOCA9IEwubWFya2VyKAogICAgICAgICAgICAgICAgWzQwLjI1NTc3NiwgLTEwNS4yMDk1XSwKICAgICAgICAgICAgICAgIHt9CiAgICAgICAgICAgICkuYWRkVG8obWFya2VyX2NsdXN0ZXJfYzQ5MDZkZWRmODAxNDQyZGEzMjM3NWRlNTNiM2JiMGQpOwogICAgICAgIAogICAgCiAgICAgICAgdmFyIHBvcHVwXzUyZWUwNTE3NWNhZjQzNDBiZWRiMGU3N2I5NjRiNDMwID0gTC5wb3B1cCh7Im1heFdpZHRoIjogIjEwMCUifSk7CgogICAgICAgIAogICAgICAgICAgICB2YXIgaHRtbF82OTYzOGE1MTZhNGY0YjFhYWUyYTIxNWQ5YjdmZTMzYyA9ICQoYDxkaXYgaWQ9Imh0bWxfNjk2MzhhNTE2YTRmNGIxYWFlMmEyMTVkOWI3ZmUzM2MiIHN0eWxlPSJ3aWR0aDogMTAwLjAlOyBoZWlnaHQ6IDEwMC4wJTsiPk5hbWU6IExJVFRMRSBUSE9NUFNPTiAjMiBESVRDSCBQcmVjaXA6IDAuMTA8L2Rpdj5gKVswXTsKICAgICAgICAgICAgcG9wdXBfNTJlZTA1MTc1Y2FmNDM0MGJlZGIwZTc3Yjk2NGI0MzAuc2V0Q29udGVudChodG1sXzY5NjM4YTUxNmE0ZjRiMWFhZTJhMjE1ZDliN2ZlMzNjKTsKICAgICAgICAKCiAgICAgICAgbWFya2VyX2UwMzM4YjUwMzQ1YzRhOTJiNDQ4OTk3NzU2OTM4N2U4LmJpbmRQb3B1cChwb3B1cF81MmVlMDUxNzVjYWY0MzQwYmVkYjBlNzdiOTY0YjQzMCkKICAgICAgICA7CgogICAgICAgIAogICAgCiAgICAKICAgICAgICAgICAgdmFyIG1hcmtlcl85NzQ5YzMyNmY5MTQ0ZWNlOTc0MmI1OGIyZmRiMTRiZCA9IEwubWFya2VyKAogICAgICAgICAgICAgICAgWzQwLjI1Nzg0NCwgLTEwNS4xNjQzOTddLAogICAgICAgICAgICAgICAge30KICAgICAgICAgICAgKS5hZGRUbyhtYXJrZXJfY2x1c3Rlcl9jNDkwNmRlZGY4MDE0NDJkYTMyMzc1ZGU1M2IzYmIwZCk7CiAgICAgICAgCiAgICAKICAgICAgICB2YXIgcG9wdXBfZmJmZGU1NGY2OTgzNGU1NTlhODc3ZjU2MzY4NmI0NzggPSBMLnBvcHVwKHsibWF4V2lkdGgiOiAiMTAwJSJ9KTsKCiAgICAgICAgCiAgICAgICAgICAgIHZhciBodG1sXzQ3ZmFhMjEzNGY0NjQwYWNhMzliYjQyYTYwY2Y2ZjEzID0gJChgPGRpdiBpZD0iaHRtbF80N2ZhYTIxMzRmNDY0MGFjYTM5YmI0MmE2MGNmNmYxMyIgc3R5bGU9IndpZHRoOiAxMDAuMCU7IGhlaWdodDogMTAwLjAlOyI+TmFtZTogQkxPV0VSIERJVENIIFByZWNpcDogMC4wMzwvZGl2PmApWzBdOwogICAgICAgICAgICBwb3B1cF9mYmZkZTU0ZjY5ODM0ZTU1OWE4NzdmNTYzNjg2YjQ3OC5zZXRDb250ZW50KGh0bWxfNDdmYWEyMTM0ZjQ2NDBhY2EzOWJiNDJhNjBjZjZmMTMpOwogICAgICAgIAoKICAgICAgICBtYXJrZXJfOTc0OWMzMjZmOTE0NGVjZTk3NDJiNThiMmZkYjE0YmQuYmluZFBvcHVwKHBvcHVwX2ZiZmRlNTRmNjk4MzRlNTU5YTg3N2Y1NjM2ODZiNDc4KQogICAgICAgIDsKCiAgICAgICAgCiAgICAKICAgIAogICAgICAgICAgICB2YXIgbWFya2VyXzMyYmRjODFlZmFiNjQ2ZDFhMjQ0ZWEwY2VkZmNjY2E3ID0gTC5tYXJrZXIoCiAgICAgICAgICAgICAgICBbMzkuOTMxNTk3LCAtMTA1LjMwNDk5XSwKICAgICAgICAgICAgICAgIHt9CiAgICAgICAgICAgICkuYWRkVG8obWFya2VyX2NsdXN0ZXJfYzQ5MDZkZWRmODAxNDQyZGEzMjM3NWRlNTNiM2JiMGQpOwogICAgICAgIAogICAgCiAgICAgICAgdmFyIHBvcHVwXzFmYmY1OWUxYTlkNDQwYWE4MjYwOGE4NWJhZjdkZDlkID0gTC5wb3B1cCh7Im1heFdpZHRoIjogIjEwMCUifSk7CgogICAgICAgIAogICAgICAgICAgICB2YXIgaHRtbF83ZTdiYjNhNTY4NzM0YzgzYWU2NGZkZTVhYmJmYzkxMCA9ICQoYDxkaXYgaWQ9Imh0bWxfN2U3YmIzYTU2ODczNGM4M2FlNjRmZGU1YWJiZmM5MTAiIHN0eWxlPSJ3aWR0aDogMTAwLjAlOyBoZWlnaHQ6IDEwMC4wJTsiPk5hbWU6IFNPVVRIIEJPVUxERVIgQ1JFRUsgTkVBUiBFTERPUkFETyBTUFJJTkdTLCBDTy4gUHJlY2lwOiAxNi4wMDwvZGl2PmApWzBdOwogICAgICAgICAgICBwb3B1cF8xZmJmNTllMWE5ZDQ0MGFhODI2MDhhODViYWY3ZGQ5ZC5zZXRDb250ZW50KGh0bWxfN2U3YmIzYTU2ODczNGM4M2FlNjRmZGU1YWJiZmM5MTApOwogICAgICAgIAoKICAgICAgICBtYXJrZXJfMzJiZGM4MWVmYWI2NDZkMWEyNDRlYTBjZWRmY2NjYTcuYmluZFBvcHVwKHBvcHVwXzFmYmY1OWUxYTlkNDQwYWE4MjYwOGE4NWJhZjdkZDlkKQogICAgICAgIDsKCiAgICAgICAgCiAgICAKICAgIAogICAgICAgICAgICB2YXIgbWFya2VyXzUwMDZmMmVlZmYwMjRjMWJhMzdjMDdiNzZhOGUxMTQ4ID0gTC5tYXJrZXIoCiAgICAgICAgICAgICAgICBbNDAuMDUxNjUyLCAtMTA1LjE3ODg3NV0sCiAgICAgICAgICAgICAgICB7fQogICAgICAgICAgICApLmFkZFRvKG1hcmtlcl9jbHVzdGVyX2M0OTA2ZGVkZjgwMTQ0MmRhMzIzNzVkZTUzYjNiYjBkKTsKICAgICAgICAKICAgIAogICAgICAgIHZhciBwb3B1cF82OTAzODI1NGVjMjA0NTcwODk5NzNkMWRjMTRlNWZiNiA9IEwucG9wdXAoeyJtYXhXaWR0aCI6ICIxMDAlIn0pOwoKICAgICAgICAKICAgICAgICAgICAgdmFyIGh0bWxfZmFlZDc5MTYxNTc1NGJlN2JkYWFiYzc1MjQ3M2Y1ZDkgPSAkKGA8ZGl2IGlkPSJodG1sX2ZhZWQ3OTE2MTU3NTRiZTdiZGFhYmM3NTI0NzNmNWQ5IiBzdHlsZT0id2lkdGg6IDEwMC4wJTsgaGVpZ2h0OiAxMDAuMCU7Ij5OYW1lOiBCT1VMREVSIENSRUVLIEFUIE5PUlRIIDc1VEggU1QuIE5FQVIgQk9VTERFUiwgQ08gUHJlY2lwOiAzMy41MDwvZGl2PmApWzBdOwogICAgICAgICAgICBwb3B1cF82OTAzODI1NGVjMjA0NTcwODk5NzNkMWRjMTRlNWZiNi5zZXRDb250ZW50KGh0bWxfZmFlZDc5MTYxNTc1NGJlN2JkYWFiYzc1MjQ3M2Y1ZDkpOwogICAgICAgIAoKICAgICAgICBtYXJrZXJfNTAwNmYyZWVmZjAyNGMxYmEzN2MwN2I3NmE4ZTExNDguYmluZFBvcHVwKHBvcHVwXzY5MDM4MjU0ZWMyMDQ1NzA4OTk3M2QxZGMxNGU1ZmI2KQogICAgICAgIDsKCiAgICAgICAgCiAgICAKICAgIAogICAgICAgICAgICB2YXIgbWFya2VyX2QzMTZjNjQ4YTlmODQ5NDA5NjEyNzI3ZjVkODBkNTJiID0gTC5tYXJrZXIoCiAgICAgICAgICAgICAgICBbNDAuMTcwOTk4LCAtMTA1LjE2MDg3Nl0sCiAgICAgICAgICAgICAgICB7fQogICAgICAgICAgICApLmFkZFRvKG1hcmtlcl9jbHVzdGVyX2M0OTA2ZGVkZjgwMTQ0MmRhMzIzNzVkZTUzYjNiYjBkKTsKICAgICAgICAKICAgIAogICAgICAgIHZhciBwb3B1cF8yNGRkNTk2NjgwYTI0Y2I2YTg1MDk3MzVlZGZmYjg5NyA9IEwucG9wdXAoeyJtYXhXaWR0aCI6ICIxMDAlIn0pOwoKICAgICAgICAKICAgICAgICAgICAgdmFyIGh0bWxfNTU3OTczOTczOGVmNGY4ZDlmODllZGQ0MjhmMmE1OTggPSAkKGA8ZGl2IGlkPSJodG1sXzU1Nzk3Mzk3MzhlZjRmOGQ5Zjg5ZWRkNDI4ZjJhNTk4IiBzdHlsZT0id2lkdGg6IDEwMC4wJTsgaGVpZ2h0OiAxMDAuMCU7Ij5OYW1lOiBTT1VUSCBGTEFUIERJVENIIFByZWNpcDogMC4zODwvZGl2PmApWzBdOwogICAgICAgICAgICBwb3B1cF8yNGRkNTk2NjgwYTI0Y2I2YTg1MDk3MzVlZGZmYjg5Ny5zZXRDb250ZW50KGh0bWxfNTU3OTczOTczOGVmNGY4ZDlmODllZGQ0MjhmMmE1OTgpOwogICAgICAgIAoKICAgICAgICBtYXJrZXJfZDMxNmM2NDhhOWY4NDk0MDk2MTI3MjdmNWQ4MGQ1MmIuYmluZFBvcHVwKHBvcHVwXzI0ZGQ1OTY2ODBhMjRjYjZhODUwOTczNWVkZmZiODk3KQogICAgICAgIDsKCiAgICAgICAgCiAgICAKICAgIAogICAgICAgICAgICB2YXIgbWFya2VyXzgwZGUzYTM3ZWNhMDQzN2M4NGU3MDVkOTgyZGIzZGEwID0gTC5tYXJrZXIoCiAgICAgICAgICAgICAgICBbNDAuMTUzMzQxLCAtMTA1LjA3NTY5NV0sCiAgICAgICAgICAgICAgICB7fQogICAgICAgICAgICApLmFkZFRvKG1hcmtlcl9jbHVzdGVyX2M0OTA2ZGVkZjgwMTQ0MmRhMzIzNzVkZTUzYjNiYjBkKTsKICAgICAgICAKICAgIAogICAgICAgIHZhciBwb3B1cF84OTA5ZWI5YmIwZTY0ZTYzYjA1MzA0NzYwMDIyMTNmMiA9IEwucG9wdXAoeyJtYXhXaWR0aCI6ICIxMDAlIn0pOwoKICAgICAgICAKICAgICAgICAgICAgdmFyIGh0bWxfMTFjYzEwMThmNTllNDU3ZGJlYWQ3ZWQ2MDM0YjFmYmUgPSAkKGA8ZGl2IGlkPSJodG1sXzExY2MxMDE4ZjU5ZTQ1N2RiZWFkN2VkNjAzNGIxZmJlIiBzdHlsZT0id2lkdGg6IDEwMC4wJTsgaGVpZ2h0OiAxMDAuMCU7Ij5OYW1lOiBTQUlOVCBWUkFJTiBDUkVFSyBCRUxPVyBLRU4gUFJBVFQgQkxWRCBBVCBMT05HTU9OVCwgQ08gUHJlY2lwOiA0NS4xMDwvZGl2PmApWzBdOwogICAgICAgICAgICBwb3B1cF84OTA5ZWI5YmIwZTY0ZTYzYjA1MzA0NzYwMDIyMTNmMi5zZXRDb250ZW50KGh0bWxfMTFjYzEwMThmNTllNDU3ZGJlYWQ3ZWQ2MDM0YjFmYmUpOwogICAgICAgIAoKICAgICAgICBtYXJrZXJfODBkZTNhMzdlY2EwNDM3Yzg0ZTcwNWQ5ODJkYjNkYTAuYmluZFBvcHVwKHBvcHVwXzg5MDllYjliYjBlNjRlNjNiMDUzMDQ3NjAwMjIxM2YyKQogICAgICAgIDsKCiAgICAgICAgCiAgICAKICAgIAogICAgICAgICAgICB2YXIgbWFya2VyX2I4ZDc4NGU3ZTkxYzRlOTg5NDJlMWJiM2NlODNkMjcwID0gTC5tYXJrZXIoCiAgICAgICAgICAgICAgICBbMzkuOTYxNjU1LCAtMTA1LjUwNDQ0XSwKICAgICAgICAgICAgICAgIHt9CiAgICAgICAgICAgICkuYWRkVG8obWFya2VyX2NsdXN0ZXJfYzQ5MDZkZWRmODAxNDQyZGEzMjM3NWRlNTNiM2JiMGQpOwogICAgICAgIAogICAgCiAgICAgICAgdmFyIHBvcHVwXzFlNGFlYTE0NjE0MjRhMDJhYmM3YmQ2Mjc3OTZiYzZhID0gTC5wb3B1cCh7Im1heFdpZHRoIjogIjEwMCUifSk7CgogICAgICAgIAogICAgICAgICAgICB2YXIgaHRtbF8xOWE1NDg5YWE5Yjc0ZDE4OTgzZTNiMDU2NmJhYzBhOSA9ICQoYDxkaXYgaWQ9Imh0bWxfMTlhNTQ4OWFhOWI3NGQxODk4M2UzYjA1NjZiYWMwYTkiIHN0eWxlPSJ3aWR0aDogMTAwLjAlOyBoZWlnaHQ6IDEwMC4wJTsiPk5hbWU6IE1JRERMRSBCT1VMREVSIENSRUVLIEFUIE5FREVSTEFORCwgQ08uIFByZWNpcDogMjcuNjA8L2Rpdj5gKVswXTsKICAgICAgICAgICAgcG9wdXBfMWU0YWVhMTQ2MTQyNGEwMmFiYzdiZDYyNzc5NmJjNmEuc2V0Q29udGVudChodG1sXzE5YTU0ODlhYTliNzRkMTg5ODNlM2IwNTY2YmFjMGE5KTsKICAgICAgICAKCiAgICAgICAgbWFya2VyX2I4ZDc4NGU3ZTkxYzRlOTg5NDJlMWJiM2NlODNkMjcwLmJpbmRQb3B1cChwb3B1cF8xZTRhZWExNDYxNDI0YTAyYWJjN2JkNjI3Nzk2YmM2YSkKICAgICAgICA7CgogICAgICAgIAogICAgCiAgICAKICAgICAgICAgICAgdmFyIG1hcmtlcl9iZjgzNTgzMzkzODg0YWZlYWU1NTU3N2UwZmJiMjE3NyA9IEwubWFya2VyKAogICAgICAgICAgICAgICAgWzQwLjA1OTgwOSwgLTEwNS4wOTc4NzJdLAogICAgICAgICAgICAgICAge30KICAgICAgICAgICAgKS5hZGRUbyhtYXJrZXJfY2x1c3Rlcl9jNDkwNmRlZGY4MDE0NDJkYTMyMzc1ZGU1M2IzYmIwZCk7CiAgICAgICAgCiAgICAKICAgICAgICB2YXIgcG9wdXBfZDk1N2IyOTUwNmU5NGIwMzk4YzdiZDk2MDVmZDY5YTQgPSBMLnBvcHVwKHsibWF4V2lkdGgiOiAiMTAwJSJ9KTsKCiAgICAgICAgCiAgICAgICAgICAgIHZhciBodG1sXzliN2ZkOWQ3ZjYyNzQxOWM4ZGI0NGM5OThhNTgzZmQ5ID0gJChgPGRpdiBpZD0iaHRtbF85YjdmZDlkN2Y2Mjc0MTljOGRiNDRjOTk4YTU4M2ZkOSIgc3R5bGU9IndpZHRoOiAxMDAuMCU7IGhlaWdodDogMTAwLjAlOyI+TmFtZTogQk9VTERFUiBDUkVFSyBBVCAxMDkgU1QgTkVBUiBFUklFLCBDTyBQcmVjaXA6IDUzLjgwPC9kaXY+YClbMF07CiAgICAgICAgICAgIHBvcHVwX2Q5NTdiMjk1MDZlOTRiMDM5OGM3YmQ5NjA1ZmQ2OWE0LnNldENvbnRlbnQoaHRtbF85YjdmZDlkN2Y2Mjc0MTljOGRiNDRjOTk4YTU4M2ZkOSk7CiAgICAgICAgCgogICAgICAgIG1hcmtlcl9iZjgzNTgzMzkzODg0YWZlYWU1NTU3N2UwZmJiMjE3Ny5iaW5kUG9wdXAocG9wdXBfZDk1N2IyOTUwNmU5NGIwMzk4YzdiZDk2MDVmZDY5YTQpCiAgICAgICAgOwoKICAgICAgICAKICAgIAogICAgCiAgICAgICAgICAgIHZhciBtYXJrZXJfNWRjZDE0MWIzYmYyNDliMWJjNDBiZDQyYWY0ZTQ1NmIgPSBMLm1hcmtlcigKICAgICAgICAgICAgICAgIFs0MC4yMTU2NTgsIC0xMDUuMzYzNDIyXSwKICAgICAgICAgICAgICAgIHt9CiAgICAgICAgICAgICkuYWRkVG8obWFya2VyX2NsdXN0ZXJfYzQ5MDZkZWRmODAxNDQyZGEzMjM3NWRlNTNiM2JiMGQpOwogICAgICAgIAogICAgCiAgICAgICAgdmFyIHBvcHVwX2JiYmE2MGJmNmExOTRjOWQ4MDc1YjRhNzkzNWVhNGU0ID0gTC5wb3B1cCh7Im1heFdpZHRoIjogIjEwMCUifSk7CgogICAgICAgIAogICAgICAgICAgICB2YXIgaHRtbF85ZjI2ZGQ2MjZmYjk0YjQxOGEyMDczMGYyNzhhZGE3ZCA9ICQoYDxkaXYgaWQ9Imh0bWxfOWYyNmRkNjI2ZmI5NGI0MThhMjA3MzBmMjc4YWRhN2QiIHN0eWxlPSJ3aWR0aDogMTAwLjAlOyBoZWlnaHQ6IDEwMC4wJTsiPk5hbWU6IE5PUlRIIFNBSU5UIFZSQUlOIENSRUVLIEJFTE9XIEJVVFRPTlJPQ0sgIChSQUxQSCBQUklDRSkgUkVTRVJWT0lSIFByZWNpcDogMTkuMzA8L2Rpdj5gKVswXTsKICAgICAgICAgICAgcG9wdXBfYmJiYTYwYmY2YTE5NGM5ZDgwNzViNGE3OTM1ZWE0ZTQuc2V0Q29udGVudChodG1sXzlmMjZkZDYyNmZiOTRiNDE4YTIwNzMwZjI3OGFkYTdkKTsKICAgICAgICAKCiAgICAgICAgbWFya2VyXzVkY2QxNDFiM2JmMjQ5YjFiYzQwYmQ0MmFmNGU0NTZiLmJpbmRQb3B1cChwb3B1cF9iYmJhNjBiZjZhMTk0YzlkODA3NWI0YTc5MzVlYTRlNCkKICAgICAgICA7CgogICAgICAgIAogICAgCiAgICAKICAgICAgICAgICAgdmFyIG1hcmtlcl9mZjNlNzQxYTA2Mzk0Yzc2YWVhYjNkZTFlOGYzNzhkMSA9IEwubWFya2VyKAogICAgICAgICAgICAgICAgWzQwLjA4NjI3OCwgLTEwNS4yMTc1MTldLAogICAgICAgICAgICAgICAge30KICAgICAgICAgICAgKS5hZGRUbyhtYXJrZXJfY2x1c3Rlcl9jNDkwNmRlZGY4MDE0NDJkYTMyMzc1ZGU1M2IzYmIwZCk7CiAgICAgICAgCiAgICAKICAgICAgICB2YXIgcG9wdXBfYjY1NjFhNmJhY2FjNDc4NmEwZTE4OTI0ZDkyN2NiOTMgPSBMLnBvcHVwKHsibWF4V2lkdGgiOiAiMTAwJSJ9KTsKCiAgICAgICAgCiAgICAgICAgICAgIHZhciBodG1sXzM2YTk0NDg1MGVlNDRiNWJiN2ZlNzJlNzdmNzc0NjNlID0gJChgPGRpdiBpZD0iaHRtbF8zNmE5NDQ4NTBlZTQ0YjViYjdmZTcyZTc3Zjc3NDYzZSIgc3R5bGU9IndpZHRoOiAxMDAuMCU7IGhlaWdodDogMTAwLjAlOyI+TmFtZTogQk9VTERFUiBSRVNFUlZPSVIgSU5MRVQgUHJlY2lwOiAwLjAwPC9kaXY+YClbMF07CiAgICAgICAgICAgIHBvcHVwX2I2NTYxYTZiYWNhYzQ3ODZhMGUxODkyNGQ5MjdjYjkzLnNldENvbnRlbnQoaHRtbF8zNmE5NDQ4NTBlZTQ0YjViYjdmZTcyZTc3Zjc3NDYzZSk7CiAgICAgICAgCgogICAgICAgIG1hcmtlcl9mZjNlNzQxYTA2Mzk0Yzc2YWVhYjNkZTFlOGYzNzhkMS5iaW5kUG9wdXAocG9wdXBfYjY1NjFhNmJhY2FjNDc4NmEwZTE4OTI0ZDkyN2NiOTMpCiAgICAgICAgOwoKICAgICAgICAKICAgIAogICAgCiAgICAgICAgICAgIHZhciBtYXJrZXJfOTYzZjUxOGNmYTI5NDM1ZWI1MTUwYTU4M2U1MGE0NDkgPSBMLm1hcmtlcigKICAgICAgICAgICAgICAgIFs0MC4xOTMwMTksIC0xMDUuMjEwMzg4XSwKICAgICAgICAgICAgICAgIHt9CiAgICAgICAgICAgICkuYWRkVG8obWFya2VyX2NsdXN0ZXJfYzQ5MDZkZWRmODAxNDQyZGEzMjM3NWRlNTNiM2JiMGQpOwogICAgICAgIAogICAgCiAgICAgICAgdmFyIHBvcHVwXzEwY2Y1M2JhMDYyMDQ1OTg4ZmRmZWZlYTA3YjU2ZDM4ID0gTC5wb3B1cCh7Im1heFdpZHRoIjogIjEwMCUifSk7CgogICAgICAgIAogICAgICAgICAgICB2YXIgaHRtbF8xOGYyMDU5MjRkZWM0ZmJmOWExOWNhMGVlYTVmYTY2ZSA9ICQoYDxkaXYgaWQ9Imh0bWxfMThmMjA1OTI0ZGVjNGZiZjlhMTljYTBlZWE1ZmE2NmUiIHN0eWxlPSJ3aWR0aDogMTAwLjAlOyBoZWlnaHQ6IDEwMC4wJTsiPk5hbWU6IFRSVUUgQU5EIFdFQlNURVIgRElUQ0ggUHJlY2lwOiAwLjAwPC9kaXY+YClbMF07CiAgICAgICAgICAgIHBvcHVwXzEwY2Y1M2JhMDYyMDQ1OTg4ZmRmZWZlYTA3YjU2ZDM4LnNldENvbnRlbnQoaHRtbF8xOGYyMDU5MjRkZWM0ZmJmOWExOWNhMGVlYTVmYTY2ZSk7CiAgICAgICAgCgogICAgICAgIG1hcmtlcl85NjNmNTE4Y2ZhMjk0MzVlYjUxNTBhNTgzZTUwYTQ0OS5iaW5kUG9wdXAocG9wdXBfMTBjZjUzYmEwNjIwNDU5ODhmZGZlZmVhMDdiNTZkMzgpCiAgICAgICAgOwoKICAgICAgICAKICAgIAogICAgCiAgICAgICAgICAgIHZhciBtYXJrZXJfMDFlYTZjNGIyNDc2NGExZWE5OGI5M2VkNmVjN2E2ODMgPSBMLm1hcmtlcigKICAgICAgICAgICAgICAgIFs0MC4yMTI2NTgsIC0xMDUuMjUxODI2XSwKICAgICAgICAgICAgICAgIHt9CiAgICAgICAgICAgICkuYWRkVG8obWFya2VyX2NsdXN0ZXJfYzQ5MDZkZWRmODAxNDQyZGEzMjM3NWRlNTNiM2JiMGQpOwogICAgICAgIAogICAgCiAgICAgICAgdmFyIHBvcHVwXzgyZTlmNDExMzQ3YTRlNTNiZjMwYjZkMzhkMzg0YTc1ID0gTC5wb3B1cCh7Im1heFdpZHRoIjogIjEwMCUifSk7CgogICAgICAgIAogICAgICAgICAgICB2YXIgaHRtbF84M2E0YmY2NjhhY2E0ZDBkYWE1ODc1MDMzZWVlZjU4YyA9ICQoYDxkaXYgaWQ9Imh0bWxfODNhNGJmNjY4YWNhNGQwZGFhNTg3NTAzM2VlZWY1OGMiIHN0eWxlPSJ3aWR0aDogMTAwLjAlOyBoZWlnaHQ6IDEwMC4wJTsiPk5hbWU6IFJPVUdIIEFORCBSRUFEWSBESVRDSCBQcmVjaXA6IDAuMDA8L2Rpdj5gKVswXTsKICAgICAgICAgICAgcG9wdXBfODJlOWY0MTEzNDdhNGU1M2JmMzBiNmQzOGQzODRhNzUuc2V0Q29udGVudChodG1sXzgzYTRiZjY2OGFjYTRkMGRhYTU4NzUwMzNlZWVmNThjKTsKICAgICAgICAKCiAgICAgICAgbWFya2VyXzAxZWE2YzRiMjQ3NjRhMWVhOThiOTNlZDZlYzdhNjgzLmJpbmRQb3B1cChwb3B1cF84MmU5ZjQxMTM0N2E0ZTUzYmYzMGI2ZDM4ZDM4NGE3NSkKICAgICAgICA7CgogICAgICAgIAogICAgCiAgICAKICAgICAgICAgICAgdmFyIG1hcmtlcl8zYzc2MDczMzVlN2I0MGIyOWJhMjg1MDMyYmFkNzJiNyA9IEwubWFya2VyKAogICAgICAgICAgICAgICAgWzQwLjE3NDg0NCwgLTEwNS4xNjc4NzNdLAogICAgICAgICAgICAgICAge30KICAgICAgICAgICAgKS5hZGRUbyhtYXJrZXJfY2x1c3Rlcl9jNDkwNmRlZGY4MDE0NDJkYTMyMzc1ZGU1M2IzYmIwZCk7CiAgICAgICAgCiAgICAKICAgICAgICB2YXIgcG9wdXBfNTNiNzFhMWMyOTdhNGQwZmJkYzllNGM3MDA0ZDVjZjAgPSBMLnBvcHVwKHsibWF4V2lkdGgiOiAiMTAwJSJ9KTsKCiAgICAgICAgCiAgICAgICAgICAgIHZhciBodG1sXzNkMjU0ZTgzZjc1ZjQxYzA5MzM5Njk4ZGRlMjU0NGM0ID0gJChgPGRpdiBpZD0iaHRtbF8zZDI1NGU4M2Y3NWY0MWMwOTMzOTY5OGRkZTI1NDRjNCIgc3R5bGU9IndpZHRoOiAxMDAuMCU7IGhlaWdodDogMTAwLjAlOyI+TmFtZTogSEFHRVIgTUVBRE9XUyBESVRDSCBQcmVjaXA6IDAuMTU8L2Rpdj5gKVswXTsKICAgICAgICAgICAgcG9wdXBfNTNiNzFhMWMyOTdhNGQwZmJkYzllNGM3MDA0ZDVjZjAuc2V0Q29udGVudChodG1sXzNkMjU0ZTgzZjc1ZjQxYzA5MzM5Njk4ZGRlMjU0NGM0KTsKICAgICAgICAKCiAgICAgICAgbWFya2VyXzNjNzYwNzMzNWU3YjQwYjI5YmEyODUwMzJiYWQ3MmI3LmJpbmRQb3B1cChwb3B1cF81M2I3MWExYzI5N2E0ZDBmYmRjOWU0YzcwMDRkNWNmMCkKICAgICAgICA7CgogICAgICAgIAogICAgCiAgICAKICAgICAgICAgICAgdmFyIG1hcmtlcl8zMWE3ZjBiNDM0OGM0MTExOGRlMTc5NzI1ZGUwZDYwMyA9IEwubWFya2VyKAogICAgICAgICAgICAgICAgWzQwLjI1NjI3NiwgLTEwNS4yMDk0MTZdLAogICAgICAgICAgICAgICAge30KICAgICAgICAgICAgKS5hZGRUbyhtYXJrZXJfY2x1c3Rlcl9jNDkwNmRlZGY4MDE0NDJkYTMyMzc1ZGU1M2IzYmIwZCk7CiAgICAgICAgCiAgICAKICAgICAgICB2YXIgcG9wdXBfYzAwMDAwNDExYTIwNDU1Zjk5NzIwYzdlMzYxZjUwNWYgPSBMLnBvcHVwKHsibWF4V2lkdGgiOiAiMTAwJSJ9KTsKCiAgICAgICAgCiAgICAgICAgICAgIHZhciBodG1sX2QyMWNkMGIxMDczNjRiZDBiNDI1NmJiYjkyMjNiYWI0ID0gJChgPGRpdiBpZD0iaHRtbF9kMjFjZDBiMTA3MzY0YmQwYjQyNTZiYmI5MjIzYmFiNCIgc3R5bGU9IndpZHRoOiAxMDAuMCU7IGhlaWdodDogMTAwLjAlOyI+TmFtZTogTElUVExFIFRIT01QU09OICMxIERJVENIIFByZWNpcDogMC4wMDwvZGl2PmApWzBdOwogICAgICAgICAgICBwb3B1cF9jMDAwMDA0MTFhMjA0NTVmOTk3MjBjN2UzNjFmNTA1Zi5zZXRDb250ZW50KGh0bWxfZDIxY2QwYjEwNzM2NGJkMGI0MjU2YmJiOTIyM2JhYjQpOwogICAgICAgIAoKICAgICAgICBtYXJrZXJfMzFhN2YwYjQzNDhjNDExMThkZTE3OTcyNWRlMGQ2MDMuYmluZFBvcHVwKHBvcHVwX2MwMDAwMDQxMWEyMDQ1NWY5OTcyMGM3ZTM2MWY1MDVmKQogICAgICAgIDsKCiAgICAgICAgCiAgICAKICAgIAogICAgICAgICAgICB2YXIgbWFya2VyX2E2NmJhMWYxNTRiYjQ4ZDdhNmQ4OTY0MDBkZWI0YjhlID0gTC5tYXJrZXIoCiAgICAgICAgICAgICAgICBbNDAuMjYwODI3LCAtMTA1LjE5ODU2N10sCiAgICAgICAgICAgICAgICB7fQogICAgICAgICAgICApLmFkZFRvKG1hcmtlcl9jbHVzdGVyX2M0OTA2ZGVkZjgwMTQ0MmRhMzIzNzVkZTUzYjNiYjBkKTsKICAgICAgICAKICAgIAogICAgICAgIHZhciBwb3B1cF82NzQ5Y2ZhNzY0YTE0MzQ4OTg3Mjg3ODcwOTMyYWY5NSA9IEwucG9wdXAoeyJtYXhXaWR0aCI6ICIxMDAlIn0pOwoKICAgICAgICAKICAgICAgICAgICAgdmFyIGh0bWxfOTE3ZDBmZjU3ZDFmNDc2YTk2YTQ0ZDA3MDZkOTUwYTkgPSAkKGA8ZGl2IGlkPSJodG1sXzkxN2QwZmY1N2QxZjQ3NmE5NmE0NGQwNzA2ZDk1MGE5IiBzdHlsZT0id2lkdGg6IDEwMC4wJTsgaGVpZ2h0OiAxMDAuMCU7Ij5OYW1lOiBDVUxWRVIgRElUQ0ggUHJlY2lwOiAwLjAwPC9kaXY+YClbMF07CiAgICAgICAgICAgIHBvcHVwXzY3NDljZmE3NjRhMTQzNDg5ODcyODc4NzA5MzJhZjk1LnNldENvbnRlbnQoaHRtbF85MTdkMGZmNTdkMWY0NzZhOTZhNDRkMDcwNmQ5NTBhOSk7CiAgICAgICAgCgogICAgICAgIG1hcmtlcl9hNjZiYTFmMTU0YmI0OGQ3YTZkODk2NDAwZGViNGI4ZS5iaW5kUG9wdXAocG9wdXBfNjc0OWNmYTc2NGExNDM0ODk4NzI4Nzg3MDkzMmFmOTUpCiAgICAgICAgOwoKICAgICAgICAKICAgIAogICAgCiAgICAgICAgICAgIHZhciBtYXJrZXJfOGM4MDg0ZGQwNmQwNGYxY2E2YTMzNmVkMTZjNjQzMzMgPSBMLm1hcmtlcigKICAgICAgICAgICAgICAgIFs0MC4yMTUwNDMsIC0xMDUuMjU2MDE3XSwKICAgICAgICAgICAgICAgIHt9CiAgICAgICAgICAgICkuYWRkVG8obWFya2VyX2NsdXN0ZXJfYzQ5MDZkZWRmODAxNDQyZGEzMjM3NWRlNTNiM2JiMGQpOwogICAgICAgIAogICAgCiAgICAgICAgdmFyIHBvcHVwX2MxN2Q3N2JjOWUxMDRlN2U5OGI4ODJmMWJkMDJjNWY4ID0gTC5wb3B1cCh7Im1heFdpZHRoIjogIjEwMCUifSk7CgogICAgICAgIAogICAgICAgICAgICB2YXIgaHRtbF81YzhhNjE2Yzk2MTA0MWE0YWYwMjIzNjUzOGI1NmQzYyA9ICQoYDxkaXYgaWQ9Imh0bWxfNWM4YTYxNmM5NjEwNDFhNGFmMDIyMzY1MzhiNTZkM2MiIHN0eWxlPSJ3aWR0aDogMTAwLjAlOyBoZWlnaHQ6IDEwMC4wJTsiPk5hbWU6IEhJR0hMQU5EIERJVENIIEFUIExZT05TLCBDTyBQcmVjaXA6IDM4LjAwPC9kaXY+YClbMF07CiAgICAgICAgICAgIHBvcHVwX2MxN2Q3N2JjOWUxMDRlN2U5OGI4ODJmMWJkMDJjNWY4LnNldENvbnRlbnQoaHRtbF81YzhhNjE2Yzk2MTA0MWE0YWYwMjIzNjUzOGI1NmQzYyk7CiAgICAgICAgCgogICAgICAgIG1hcmtlcl84YzgwODRkZDA2ZDA0ZjFjYTZhMzM2ZWQxNmM2NDMzMy5iaW5kUG9wdXAocG9wdXBfYzE3ZDc3YmM5ZTEwNGU3ZTk4Yjg4MmYxYmQwMmM1ZjgpCiAgICAgICAgOwoKICAgICAgICAKICAgIAogICAgCiAgICAgICAgICAgIHZhciBtYXJrZXJfY2JmODk3MWViYjU5NGMyMGFmODhiMzBlMTEwZWZkNjkgPSBMLm1hcmtlcigKICAgICAgICAgICAgICAgIFs0MC4wNzg1NiwgLTEwNS4yMjA0OTddLAogICAgICAgICAgICAgICAge30KICAgICAgICAgICAgKS5hZGRUbyhtYXJrZXJfY2x1c3Rlcl9jNDkwNmRlZGY4MDE0NDJkYTMyMzc1ZGU1M2IzYmIwZCk7CiAgICAgICAgCiAgICAKICAgICAgICB2YXIgcG9wdXBfYjllYjFiZmVkMWU2NGQ2ZTgwODY0OWVmOThlYWEzNDAgPSBMLnBvcHVwKHsibWF4V2lkdGgiOiAiMTAwJSJ9KTsKCiAgICAgICAgCiAgICAgICAgICAgIHZhciBodG1sX2Y0M2JlNzYxNDhjMjQwYTY5MTZkNDNiMDc3OTdlNjZmID0gJChgPGRpdiBpZD0iaHRtbF9mNDNiZTc2MTQ4YzI0MGE2OTE2ZDQzYjA3Nzk3ZTY2ZiIgc3R5bGU9IndpZHRoOiAxMDAuMCU7IGhlaWdodDogMTAwLjAlOyI+TmFtZTogQk9VTERFUiBSRVNFUlZPSVIgUHJlY2lwOiA1MjIyLjAwPC9kaXY+YClbMF07CiAgICAgICAgICAgIHBvcHVwX2I5ZWIxYmZlZDFlNjRkNmU4MDg2NDllZjk4ZWFhMzQwLnNldENvbnRlbnQoaHRtbF9mNDNiZTc2MTQ4YzI0MGE2OTE2ZDQzYjA3Nzk3ZTY2Zik7CiAgICAgICAgCgogICAgICAgIG1hcmtlcl9jYmY4OTcxZWJiNTk0YzIwYWY4OGIzMGUxMTBlZmQ2OS5iaW5kUG9wdXAocG9wdXBfYjllYjFiZmVkMWU2NGQ2ZTgwODY0OWVmOThlYWEzNDApCiAgICAgICAgOwoKICAgICAgICAKICAgIAogICAgCiAgICAgICAgICAgIHZhciBtYXJrZXJfNzc3OGRlNDlkY2RjNDA0MDlkNGM5ZDJhMDJhMmQ1NzQgPSBMLm1hcmtlcigKICAgICAgICAgICAgICAgIFs0MC4xNzM5NSwgLTEwNS4xNjkzNzRdLAogICAgICAgICAgICAgICAge30KICAgICAgICAgICAgKS5hZGRUbyhtYXJrZXJfY2x1c3Rlcl9jNDkwNmRlZGY4MDE0NDJkYTMyMzc1ZGU1M2IzYmIwZCk7CiAgICAgICAgCiAgICAKICAgICAgICB2YXIgcG9wdXBfYjc4MjZkM2E0N2JjNGJmM2FjNWUwYzVhMmZkZTJmNGEgPSBMLnBvcHVwKHsibWF4V2lkdGgiOiAiMTAwJSJ9KTsKCiAgICAgICAgCiAgICAgICAgICAgIHZhciBodG1sXzRkMGY0NDM0ODgwNTRlZTM5OWI2YjAzNTRiN2YxZWU2ID0gJChgPGRpdiBpZD0iaHRtbF80ZDBmNDQzNDg4MDU0ZWUzOTliNmIwMzU0YjdmMWVlNiIgc3R5bGU9IndpZHRoOiAxMDAuMCU7IGhlaWdodDogMTAwLjAlOyI+TmFtZTogTklXT1QgRElUQ0ggUHJlY2lwOiAwLjE5PC9kaXY+YClbMF07CiAgICAgICAgICAgIHBvcHVwX2I3ODI2ZDNhNDdiYzRiZjNhYzVlMGM1YTJmZGUyZjRhLnNldENvbnRlbnQoaHRtbF80ZDBmNDQzNDg4MDU0ZWUzOTliNmIwMzU0YjdmMWVlNik7CiAgICAgICAgCgogICAgICAgIG1hcmtlcl83Nzc4ZGU0OWRjZGM0MDQwOWQ0YzlkMmEwMmEyZDU3NC5iaW5kUG9wdXAocG9wdXBfYjc4MjZkM2E0N2JjNGJmM2FjNWUwYzVhMmZkZTJmNGEpCiAgICAgICAgOwoKICAgICAgICAKICAgIAogICAgCiAgICAgICAgICAgIHZhciBtYXJrZXJfMTA3MmRlNWU3NDEwNDMzNDhiNGZmM2E1NzNiNzY4MjcgPSBMLm1hcmtlcigKICAgICAgICAgICAgICAgIFs0MC4yMTEzODksIC0xMDUuMjUwOTUyXSwKICAgICAgICAgICAgICAgIHt9CiAgICAgICAgICAgICkuYWRkVG8obWFya2VyX2NsdXN0ZXJfYzQ5MDZkZWRmODAxNDQyZGEzMjM3NWRlNTNiM2JiMGQpOwogICAgICAgIAogICAgCiAgICAgICAgdmFyIHBvcHVwX2E1N2EyZTQ3MTBkMTQzYTRhZjQxZjQ2YTcwYjVhNGVlID0gTC5wb3B1cCh7Im1heFdpZHRoIjogIjEwMCUifSk7CgogICAgICAgIAogICAgICAgICAgICB2YXIgaHRtbF84NDYyYmEwMGFiMjI0YzgzOTRlZGNhYmUwZjhmOGM4MCA9ICQoYDxkaXYgaWQ9Imh0bWxfODQ2MmJhMDBhYjIyNGM4Mzk0ZWRjYWJlMGY4ZjhjODAiIHN0eWxlPSJ3aWR0aDogMTAwLjAlOyBoZWlnaHQ6IDEwMC4wJTsiPk5hbWU6IFNNRUFEIERJVENIIFByZWNpcDogMC4wMDwvZGl2PmApWzBdOwogICAgICAgICAgICBwb3B1cF9hNTdhMmU0NzEwZDE0M2E0YWY0MWY0NmE3MGI1YTRlZS5zZXRDb250ZW50KGh0bWxfODQ2MmJhMDBhYjIyNGM4Mzk0ZWRjYWJlMGY4ZjhjODApOwogICAgICAgIAoKICAgICAgICBtYXJrZXJfMTA3MmRlNWU3NDEwNDMzNDhiNGZmM2E1NzNiNzY4MjcuYmluZFBvcHVwKHBvcHVwX2E1N2EyZTQ3MTBkMTQzYTRhZjQxZjQ2YTcwYjVhNGVlKQogICAgICAgIDsKCiAgICAgICAgCiAgICAKICAgIAogICAgICAgICAgICB2YXIgbWFya2VyXzllMmZlZDE4NGE1YjQ0ZGNhMWRhODI0NzM2ZjFkYjA3ID0gTC5tYXJrZXIoCiAgICAgICAgICAgICAgICBbNDAuMTUzMzYzLCAtMTA1LjA4ODY5NV0sCiAgICAgICAgICAgICAgICB7fQogICAgICAgICAgICApLmFkZFRvKG1hcmtlcl9jbHVzdGVyX2M0OTA2ZGVkZjgwMTQ0MmRhMzIzNzVkZTUzYjNiYjBkKTsKICAgICAgICAKICAgIAogICAgICAgIHZhciBwb3B1cF8xNjI0OGY4ZjAzNGE0YWFmYjhjYzA0MjU2NGIyNzk2ZCA9IEwucG9wdXAoeyJtYXhXaWR0aCI6ICIxMDAlIn0pOwoKICAgICAgICAKICAgICAgICAgICAgdmFyIGh0bWxfNDg5NzRmNWZmZGQ3NDQ3NTg3NzEwMzA4MTA5NTlkMTIgPSAkKGA8ZGl2IGlkPSJodG1sXzQ4OTc0ZjVmZmRkNzQ0NzU4NzcxMDMwODEwOTU5ZDEyIiBzdHlsZT0id2lkdGg6IDEwMC4wJTsgaGVpZ2h0OiAxMDAuMCU7Ij5OYW1lOiBCT05VUyBESVRDSCBQcmVjaXA6IDAuMTA8L2Rpdj5gKVswXTsKICAgICAgICAgICAgcG9wdXBfMTYyNDhmOGYwMzRhNGFhZmI4Y2MwNDI1NjRiMjc5NmQuc2V0Q29udGVudChodG1sXzQ4OTc0ZjVmZmRkNzQ0NzU4NzcxMDMwODEwOTU5ZDEyKTsKICAgICAgICAKCiAgICAgICAgbWFya2VyXzllMmZlZDE4NGE1YjQ0ZGNhMWRhODI0NzM2ZjFkYjA3LmJpbmRQb3B1cChwb3B1cF8xNjI0OGY4ZjAzNGE0YWFmYjhjYzA0MjU2NGIyNzk2ZCkKICAgICAgICA7CgogICAgICAgIAogICAgCiAgICAKICAgICAgICAgICAgdmFyIG1hcmtlcl9mZmZmZDA3YTNiNzI0NzU2YWYyYWIzMzc1YTNhZTI3NSA9IEwubWFya2VyKAogICAgICAgICAgICAgICAgWzQwLjIxMTA4MywgLTEwNS4yNTA5MjddLAogICAgICAgICAgICAgICAge30KICAgICAgICAgICAgKS5hZGRUbyhtYXJrZXJfY2x1c3Rlcl9jNDkwNmRlZGY4MDE0NDJkYTMyMzc1ZGU1M2IzYmIwZCk7CiAgICAgICAgCiAgICAKICAgICAgICB2YXIgcG9wdXBfZDhhODE4YTUzMmY4NDM1MGFlMTRkYmZmMWQ4ZjNiMDAgPSBMLnBvcHVwKHsibWF4V2lkdGgiOiAiMTAwJSJ9KTsKCiAgICAgICAgCiAgICAgICAgICAgIHZhciBodG1sXzgzNzYxODA2ZjIyYzQ0M2M4MWQ4MjNhZWMyMGUwNjNlID0gJChgPGRpdiBpZD0iaHRtbF84Mzc2MTgwNmYyMmM0NDNjODFkODIzYWVjMjBlMDYzZSIgc3R5bGU9IndpZHRoOiAxMDAuMCU7IGhlaWdodDogMTAwLjAlOyI+TmFtZTogU1dFREUgRElUQ0ggUHJlY2lwOiAwLjAwPC9kaXY+YClbMF07CiAgICAgICAgICAgIHBvcHVwX2Q4YTgxOGE1MzJmODQzNTBhZTE0ZGJmZjFkOGYzYjAwLnNldENvbnRlbnQoaHRtbF84Mzc2MTgwNmYyMmM0NDNjODFkODIzYWVjMjBlMDYzZSk7CiAgICAgICAgCgogICAgICAgIG1hcmtlcl9mZmZmZDA3YTNiNzI0NzU2YWYyYWIzMzc1YTNhZTI3NS5iaW5kUG9wdXAocG9wdXBfZDhhODE4YTUzMmY4NDM1MGFlMTRkYmZmMWQ4ZjNiMDApCiAgICAgICAgOwoKICAgICAgICAKICAgIAogICAgCiAgICAgICAgICAgIHZhciBtYXJrZXJfMTU5ZTk4YmZkYWQxNDhhOWE5ZWQxYmYzOWY0ZGVlOTUgPSBMLm1hcmtlcigKICAgICAgICAgICAgICAgIFs0MC4xODc1MjQsIC0xMDUuMTg5MTMyXSwKICAgICAgICAgICAgICAgIHt9CiAgICAgICAgICAgICkuYWRkVG8obWFya2VyX2NsdXN0ZXJfYzQ5MDZkZWRmODAxNDQyZGEzMjM3NWRlNTNiM2JiMGQpOwogICAgICAgIAogICAgCiAgICAgICAgdmFyIHBvcHVwXzQ3MjQ2NzYwZTM1NDQ4YWY4ZmZmMDc3NTFmMTRjMDNhID0gTC5wb3B1cCh7Im1heFdpZHRoIjogIjEwMCUifSk7CgogICAgICAgIAogICAgICAgICAgICB2YXIgaHRtbF85ZTJiNzY0ZGQ4MDc0MmY2YTA2NWQ2NjIxN2YzZTFhMyA9ICQoYDxkaXYgaWQ9Imh0bWxfOWUyYjc2NGRkODA3NDJmNmEwNjVkNjYyMTdmM2UxYTMiIHN0eWxlPSJ3aWR0aDogMTAwLjAlOyBoZWlnaHQ6IDEwMC4wJTsiPk5hbWU6IFJVTllPTiBESVRDSCBQcmVjaXA6IDAuMDA8L2Rpdj5gKVswXTsKICAgICAgICAgICAgcG9wdXBfNDcyNDY3NjBlMzU0NDhhZjhmZmYwNzc1MWYxNGMwM2Euc2V0Q29udGVudChodG1sXzllMmI3NjRkZDgwNzQyZjZhMDY1ZDY2MjE3ZjNlMWEzKTsKICAgICAgICAKCiAgICAgICAgbWFya2VyXzE1OWU5OGJmZGFkMTQ4YTlhOWVkMWJmMzlmNGRlZTk1LmJpbmRQb3B1cChwb3B1cF80NzI0Njc2MGUzNTQ0OGFmOGZmZjA3NzUxZjE0YzAzYSkKICAgICAgICA7CgogICAgICAgIAogICAgCiAgICAKICAgICAgICAgICAgdmFyIG1hcmtlcl8zMWU4ZGNmNmZjOWU0MTNjOWM5YTc1YzBmM2ZlODNmYSA9IEwubWFya2VyKAogICAgICAgICAgICAgICAgWzQwLjE4MTg4LCAtMTA1LjE5Njc3NV0sCiAgICAgICAgICAgICAgICB7fQogICAgICAgICAgICApLmFkZFRvKG1hcmtlcl9jbHVzdGVyX2M0OTA2ZGVkZjgwMTQ0MmRhMzIzNzVkZTUzYjNiYjBkKTsKICAgICAgICAKICAgIAogICAgICAgIHZhciBwb3B1cF8wMDczMmQyMGI2MmQ0ZmFkYTg1YjE4NTJiMWFiM2Q0ZiA9IEwucG9wdXAoeyJtYXhXaWR0aCI6ICIxMDAlIn0pOwoKICAgICAgICAKICAgICAgICAgICAgdmFyIGh0bWxfMDRhYzlhYTY5ZmUzNDQ2NjkzOWFjYTlkOWFjY2FiMjUgPSAkKGA8ZGl2IGlkPSJodG1sXzA0YWM5YWE2OWZlMzQ0NjY5MzlhY2E5ZDlhY2NhYjI1IiBzdHlsZT0id2lkdGg6IDEwMC4wJTsgaGVpZ2h0OiAxMDAuMCU7Ij5OYW1lOiBEQVZJUyBBTkQgRE9XTklORyBESVRDSCBQcmVjaXA6IDAuMDA8L2Rpdj5gKVswXTsKICAgICAgICAgICAgcG9wdXBfMDA3MzJkMjBiNjJkNGZhZGE4NWIxODUyYjFhYjNkNGYuc2V0Q29udGVudChodG1sXzA0YWM5YWE2OWZlMzQ0NjY5MzlhY2E5ZDlhY2NhYjI1KTsKICAgICAgICAKCiAgICAgICAgbWFya2VyXzMxZThkY2Y2ZmM5ZTQxM2M5YzlhNzVjMGYzZmU4M2ZhLmJpbmRQb3B1cChwb3B1cF8wMDczMmQyMGI2MmQ0ZmFkYTg1YjE4NTJiMWFiM2Q0ZikKICAgICAgICA7CgogICAgICAgIAogICAgCiAgICAKICAgICAgICAgICAgdmFyIG1hcmtlcl82MjBlYmEyNjZmODA0ZWUxOTNhZWI3Mjg2NDBhMDI3OSA9IEwubWFya2VyKAogICAgICAgICAgICAgICAgWzQwLjAxODY2NywgLTEwNS4zMjYyNV0sCiAgICAgICAgICAgICAgICB7fQogICAgICAgICAgICApLmFkZFRvKG1hcmtlcl9jbHVzdGVyX2M0OTA2ZGVkZjgwMTQ0MmRhMzIzNzVkZTUzYjNiYjBkKTsKICAgICAgICAKICAgIAogICAgICAgIHZhciBwb3B1cF9iZmYzZjY3YTVhNDU0OTk4ODhmMjdjYjJlNWQwYWRhNyA9IEwucG9wdXAoeyJtYXhXaWR0aCI6ICIxMDAlIn0pOwoKICAgICAgICAKICAgICAgICAgICAgdmFyIGh0bWxfN2RiYzlkYTE4ZjY0NDFiN2I3MmExYjg4OTRlZDVkNWMgPSAkKGA8ZGl2IGlkPSJodG1sXzdkYmM5ZGExOGY2NDQxYjdiNzJhMWI4ODk0ZWQ1ZDVjIiBzdHlsZT0id2lkdGg6IDEwMC4wJTsgaGVpZ2h0OiAxMDAuMCU7Ij5OYW1lOiBGT1VSTUlMRSBDUkVFSyBBVCBPUk9ERUxMLCBDTyBQcmVjaXA6IDAuNzQ8L2Rpdj5gKVswXTsKICAgICAgICAgICAgcG9wdXBfYmZmM2Y2N2E1YTQ1NDk5ODg4ZjI3Y2IyZTVkMGFkYTcuc2V0Q29udGVudChodG1sXzdkYmM5ZGExOGY2NDQxYjdiNzJhMWI4ODk0ZWQ1ZDVjKTsKICAgICAgICAKCiAgICAgICAgbWFya2VyXzYyMGViYTI2NmY4MDRlZTE5M2FlYjcyODY0MGEwMjc5LmJpbmRQb3B1cChwb3B1cF9iZmYzZjY3YTVhNDU0OTk4ODhmMjdjYjJlNWQwYWRhNykKICAgICAgICA7CgogICAgICAgIAogICAgCiAgICAKICAgICAgICAgICAgdmFyIG1hcmtlcl8wOWVkNDlmN2IyNDI0NjRhOTgzYjc5MWNmMDJjZTBkMiA9IEwubWFya2VyKAogICAgICAgICAgICAgICAgWzQwLjE4ODU3OSwgLTEwNS4yMDkyODJdLAogICAgICAgICAgICAgICAge30KICAgICAgICAgICAgKS5hZGRUbyhtYXJrZXJfY2x1c3Rlcl9jNDkwNmRlZGY4MDE0NDJkYTMyMzc1ZGU1M2IzYmIwZCk7CiAgICAgICAgCiAgICAKICAgICAgICB2YXIgcG9wdXBfNTQ3NDg0OGQ2OTIyNDIzODk5YTlhNjUyMTZmYTg4MmEgPSBMLnBvcHVwKHsibWF4V2lkdGgiOiAiMTAwJSJ9KTsKCiAgICAgICAgCiAgICAgICAgICAgIHZhciBodG1sXzkyM2E0YzVmYmE1ZTRmNzg5ZWRkY2Y5ODU4MTVlOTc0ID0gJChgPGRpdiBpZD0iaHRtbF85MjNhNGM1ZmJhNWU0Zjc4OWVkZGNmOTg1ODE1ZTk3NCIgc3R5bGU9IndpZHRoOiAxMDAuMCU7IGhlaWdodDogMTAwLjAlOyI+TmFtZTogSkFNRVMgRElUQ0ggUHJlY2lwOiAwLjEyPC9kaXY+YClbMF07CiAgICAgICAgICAgIHBvcHVwXzU0NzQ4NDhkNjkyMjQyMzg5OWE5YTY1MjE2ZmE4ODJhLnNldENvbnRlbnQoaHRtbF85MjNhNGM1ZmJhNWU0Zjc4OWVkZGNmOTg1ODE1ZTk3NCk7CiAgICAgICAgCgogICAgICAgIG1hcmtlcl8wOWVkNDlmN2IyNDI0NjRhOTgzYjc5MWNmMDJjZTBkMi5iaW5kUG9wdXAocG9wdXBfNTQ3NDg0OGQ2OTIyNDIzODk5YTlhNjUyMTZmYTg4MmEpCiAgICAgICAgOwoKICAgICAgICAKICAgIAogICAgCiAgICAgICAgICAgIHZhciBtYXJrZXJfNzhlY2RlOGVhZWIwNGEzOTk2MGEzMWUxMDFlZmJjNDQgPSBMLm1hcmtlcigKICAgICAgICAgICAgICAgIFs0MC4wNTMwMzUsIC0xMDUuMTkzMDQ4XSwKICAgICAgICAgICAgICAgIHt9CiAgICAgICAgICAgICkuYWRkVG8obWFya2VyX2NsdXN0ZXJfYzQ5MDZkZWRmODAxNDQyZGEzMjM3NWRlNTNiM2JiMGQpOwogICAgICAgIAogICAgCiAgICAgICAgdmFyIHBvcHVwX2JkZGQzZGFkZTY1MzRlMGFiZDdlOGU0OWNjZjBkY2IwID0gTC5wb3B1cCh7Im1heFdpZHRoIjogIjEwMCUifSk7CgogICAgICAgIAogICAgICAgICAgICB2YXIgaHRtbF8xZGUzNzk4MGZkMzI0Y2IyYjI4YmQ4MzI3ZjkwMzcwOCA9ICQoYDxkaXYgaWQ9Imh0bWxfMWRlMzc5ODBmZDMyNGNiMmIyOGJkODMyN2Y5MDM3MDgiIHN0eWxlPSJ3aWR0aDogMTAwLjAlOyBoZWlnaHQ6IDEwMC4wJTsiPk5hbWU6IEJPVUxERVIgQ1JFRUsgU1VQUExZIENBTkFMIFRPIEJPVUxERVIgQ1JFRUsgTkVBUiBCT1VMREVSIFByZWNpcDogMC4wMDwvZGl2PmApWzBdOwogICAgICAgICAgICBwb3B1cF9iZGRkM2RhZGU2NTM0ZTBhYmQ3ZThlNDljY2YwZGNiMC5zZXRDb250ZW50KGh0bWxfMWRlMzc5ODBmZDMyNGNiMmIyOGJkODMyN2Y5MDM3MDgpOwogICAgICAgIAoKICAgICAgICBtYXJrZXJfNzhlY2RlOGVhZWIwNGEzOTk2MGEzMWUxMDFlZmJjNDQuYmluZFBvcHVwKHBvcHVwX2JkZGQzZGFkZTY1MzRlMGFiZDdlOGU0OWNjZjBkY2IwKQogICAgICAgIDsKCiAgICAgICAgCiAgICAKICAgIAogICAgICAgICAgICB2YXIgbWFya2VyX2ZhNGE1YjcyZjA2MjRmNTU4ZGEzN2QyN2ZjN2ZmZDBjID0gTC5tYXJrZXIoCiAgICAgICAgICAgICAgICBbNDAuMjU4MzY3LCAtMTA1LjE3NDk1N10sCiAgICAgICAgICAgICAgICB7fQogICAgICAgICAgICApLmFkZFRvKG1hcmtlcl9jbHVzdGVyX2M0OTA2ZGVkZjgwMTQ0MmRhMzIzNzVkZTUzYjNiYjBkKTsKICAgICAgICAKICAgIAogICAgICAgIHZhciBwb3B1cF80YWIyNjkzNzM2ZWQ0MTNjYjNlN2Q4OTgzZTY5NWM2ZiA9IEwucG9wdXAoeyJtYXhXaWR0aCI6ICIxMDAlIn0pOwoKICAgICAgICAKICAgICAgICAgICAgdmFyIGh0bWxfNTAwZTE5OWU1ZWNjNGI1ZWI4ODRmN2M5NWI2OTZlNzUgPSAkKGA8ZGl2IGlkPSJodG1sXzUwMGUxOTllNWVjYzRiNWViODg0ZjdjOTViNjk2ZTc1IiBzdHlsZT0id2lkdGg6IDEwMC4wJTsgaGVpZ2h0OiAxMDAuMCU7Ij5OYW1lOiBCT1VMREVSLUxBUklNRVIgRElUQ0ggTkVBUiBCRVJUSE9VRCBQcmVjaXA6IDAuMDA8L2Rpdj5gKVswXTsKICAgICAgICAgICAgcG9wdXBfNGFiMjY5MzczNmVkNDEzY2IzZTdkODk4M2U2OTVjNmYuc2V0Q29udGVudChodG1sXzUwMGUxOTllNWVjYzRiNWViODg0ZjdjOTViNjk2ZTc1KTsKICAgICAgICAKCiAgICAgICAgbWFya2VyX2ZhNGE1YjcyZjA2MjRmNTU4ZGEzN2QyN2ZjN2ZmZDBjLmJpbmRQb3B1cChwb3B1cF80YWIyNjkzNzM2ZWQ0MTNjYjNlN2Q4OTgzZTY5NWM2ZikKICAgICAgICA7CgogICAgICAgIAogICAgCiAgICAKICAgICAgICAgICAgdmFyIG1hcmtlcl82MWI1NTgwYzA5ZWQ0OWI2OTc1MjhjYjQwYzkwYzA4OCA9IEwubWFya2VyKAogICAgICAgICAgICAgICAgWzM5LjkzODM1MSwgLTEwNS4zNDc5MDZdLAogICAgICAgICAgICAgICAge30KICAgICAgICAgICAgKS5hZGRUbyhtYXJrZXJfY2x1c3Rlcl9jNDkwNmRlZGY4MDE0NDJkYTMyMzc1ZGU1M2IzYmIwZCk7CiAgICAgICAgCiAgICAKICAgICAgICB2YXIgcG9wdXBfY2VmOThlMzQ5MjU0NGY0Y2IxNTFjZDY1MTI3Y2JhOTggPSBMLnBvcHVwKHsibWF4V2lkdGgiOiAiMTAwJSJ9KTsKCiAgICAgICAgCiAgICAgICAgICAgIHZhciBodG1sX2Q1NTJhMGU0MjM5YTRlZGRiMjE0YTBjMjc3Yjg2ZDg0ID0gJChgPGRpdiBpZD0iaHRtbF9kNTUyYTBlNDIzOWE0ZWRkYjIxNGEwYzI3N2I4NmQ4NCIgc3R5bGU9IndpZHRoOiAxMDAuMCU7IGhlaWdodDogMTAwLjAlOyI+TmFtZTogU09VVEggQk9VTERFUiBDUkVFSyBCRUxPVyBHUk9TUyBSRVNFUlZPSVIgUHJlY2lwOiAxNi40MDwvZGl2PmApWzBdOwogICAgICAgICAgICBwb3B1cF9jZWY5OGUzNDkyNTQ0ZjRjYjE1MWNkNjUxMjdjYmE5OC5zZXRDb250ZW50KGh0bWxfZDU1MmEwZTQyMzlhNGVkZGIyMTRhMGMyNzdiODZkODQpOwogICAgICAgIAoKICAgICAgICBtYXJrZXJfNjFiNTU4MGMwOWVkNDliNjk3NTI4Y2I0MGM5MGMwODguYmluZFBvcHVwKHBvcHVwX2NlZjk4ZTM0OTI1NDRmNGNiMTUxY2Q2NTEyN2NiYTk4KQogICAgICAgIDsKCiAgICAgICAgCiAgICAKICAgIAogICAgICAgICAgICB2YXIgbWFya2VyX2UxNDE2NjhmYzk3NzRiZmQ4NjI2Y2IwODMwYzFmZjdhID0gTC5tYXJrZXIoCiAgICAgICAgICAgICAgICBbNDAuMjEyNTA1LCAtMTA1LjI1MTgyNl0sCiAgICAgICAgICAgICAgICB7fQogICAgICAgICAgICApLmFkZFRvKG1hcmtlcl9jbHVzdGVyX2M0OTA2ZGVkZjgwMTQ0MmRhMzIzNzVkZTUzYjNiYjBkKTsKICAgICAgICAKICAgIAogICAgICAgIHZhciBwb3B1cF82ODI1ZmYwMTIwZDI0MzZkYjJiYWQ5MWEzZjkyYjk3YyA9IEwucG9wdXAoeyJtYXhXaWR0aCI6ICIxMDAlIn0pOwoKICAgICAgICAKICAgICAgICAgICAgdmFyIGh0bWxfZjI3ZWViNWZiOTJkNDJhMzk1ZjYyZjE2NDRjYzZjMTkgPSAkKGA8ZGl2IGlkPSJodG1sX2YyN2VlYjVmYjkyZDQyYTM5NWY2MmYxNjQ0Y2M2YzE5IiBzdHlsZT0id2lkdGg6IDEwMC4wJTsgaGVpZ2h0OiAxMDAuMCU7Ij5OYW1lOiBQQUxNRVJUT04gRElUQ0ggUHJlY2lwOiAwLjI3PC9kaXY+YClbMF07CiAgICAgICAgICAgIHBvcHVwXzY4MjVmZjAxMjBkMjQzNmRiMmJhZDkxYTNmOTJiOTdjLnNldENvbnRlbnQoaHRtbF9mMjdlZWI1ZmI5MmQ0MmEzOTVmNjJmMTY0NGNjNmMxOSk7CiAgICAgICAgCgogICAgICAgIG1hcmtlcl9lMTQxNjY4ZmM5Nzc0YmZkODYyNmNiMDgzMGMxZmY3YS5iaW5kUG9wdXAocG9wdXBfNjgyNWZmMDEyMGQyNDM2ZGIyYmFkOTFhM2Y5MmI5N2MpCiAgICAgICAgOwoKICAgICAgICAKICAgIAogICAgCiAgICAgICAgICAgIHZhciBtYXJrZXJfYzE5MDU2MTlmZjEzNGY2YmFlZGY3NWUxNzc2YWU3NTkgPSBMLm1hcmtlcigKICAgICAgICAgICAgICAgIFs0MC4yMTkwNDYsIC0xMDUuMjU5Nzk1XSwKICAgICAgICAgICAgICAgIHt9CiAgICAgICAgICAgICkuYWRkVG8obWFya2VyX2NsdXN0ZXJfYzQ5MDZkZWRmODAxNDQyZGEzMjM3NWRlNTNiM2JiMGQpOwogICAgICAgIAogICAgCiAgICAgICAgdmFyIHBvcHVwXzFjMmZjZWJiMGIxMjQyNzRhZGQyMmVmZjJjN2ExNWQzID0gTC5wb3B1cCh7Im1heFdpZHRoIjogIjEwMCUifSk7CgogICAgICAgIAogICAgICAgICAgICB2YXIgaHRtbF9jYzFjYmM4MTNlZTE0ZDNjYTNiNGU3MDBkZTM3ZjVlNSA9ICQoYDxkaXYgaWQ9Imh0bWxfY2MxY2JjODEzZWUxNGQzY2EzYjRlNzAwZGUzN2Y1ZTUiIHN0eWxlPSJ3aWR0aDogMTAwLjAlOyBoZWlnaHQ6IDEwMC4wJTsiPk5hbWU6IFNVUFBMWSBESVRDSCBQcmVjaXA6IDAuMDA8L2Rpdj5gKVswXTsKICAgICAgICAgICAgcG9wdXBfMWMyZmNlYmIwYjEyNDI3NGFkZDIyZWZmMmM3YTE1ZDMuc2V0Q29udGVudChodG1sX2NjMWNiYzgxM2VlMTRkM2NhM2I0ZTcwMGRlMzdmNWU1KTsKICAgICAgICAKCiAgICAgICAgbWFya2VyX2MxOTA1NjE5ZmYxMzRmNmJhZWRmNzVlMTc3NmFlNzU5LmJpbmRQb3B1cChwb3B1cF8xYzJmY2ViYjBiMTI0Mjc0YWRkMjJlZmYyYzdhMTVkMykKICAgICAgICA7CgogICAgICAgIAogICAgCiAgICAKICAgICAgICAgICAgdmFyIG1hcmtlcl81NWIyNGM3NzZmZDQ0NTc0OWIyYTU1NGE4MmFlYzNlNyA9IEwubWFya2VyKAogICAgICAgICAgICAgICAgWzQwLjE4NzU3OCwgLTEwNS4xODkxOTFdLAogICAgICAgICAgICAgICAge30KICAgICAgICAgICAgKS5hZGRUbyhtYXJrZXJfY2x1c3Rlcl9jNDkwNmRlZGY4MDE0NDJkYTMyMzc1ZGU1M2IzYmIwZCk7CiAgICAgICAgCiAgICAKICAgICAgICB2YXIgcG9wdXBfODdmZmM2M2U3YzExNGVkNzhlMWIyZWUyY2I5MDBlYjQgPSBMLnBvcHVwKHsibWF4V2lkdGgiOiAiMTAwJSJ9KTsKCiAgICAgICAgCiAgICAgICAgICAgIHZhciBodG1sX2EyMmExYmUyNGE0MzQ3Y2M5N2U2MmFjZGIzZDRkMjliID0gJChgPGRpdiBpZD0iaHRtbF9hMjJhMWJlMjRhNDM0N2NjOTdlNjJhY2RiM2Q0ZDI5YiIgc3R5bGU9IndpZHRoOiAxMDAuMCU7IGhlaWdodDogMTAwLjAlOyI+TmFtZTogREVOSU8gVEFZTE9SIERJVENIIFByZWNpcDogMjgxOS42ODwvZGl2PmApWzBdOwogICAgICAgICAgICBwb3B1cF84N2ZmYzYzZTdjMTE0ZWQ3OGUxYjJlZTJjYjkwMGViNC5zZXRDb250ZW50KGh0bWxfYTIyYTFiZTI0YTQzNDdjYzk3ZTYyYWNkYjNkNGQyOWIpOwogICAgICAgIAoKICAgICAgICBtYXJrZXJfNTViMjRjNzc2ZmQ0NDU3NDliMmE1NTRhODJhZWMzZTcuYmluZFBvcHVwKHBvcHVwXzg3ZmZjNjNlN2MxMTRlZDc4ZTFiMmVlMmNiOTAwZWI0KQogICAgICAgIDsKCiAgICAgICAgCiAgICAKICAgIAogICAgICAgICAgICB2YXIgbWFya2VyX2NiZmJlNjQzNWEyYTQ5MDE5MDg1MTVjMTEzNjAyZGVhID0gTC5tYXJrZXIoCiAgICAgICAgICAgICAgICBbNDAuMDQyMDI4LCAtMTA1LjM2NDkxN10sCiAgICAgICAgICAgICAgICB7fQogICAgICAgICAgICApLmFkZFRvKG1hcmtlcl9jbHVzdGVyX2M0OTA2ZGVkZjgwMTQ0MmRhMzIzNzVkZTUzYjNiYjBkKTsKICAgICAgICAKICAgIAogICAgICAgIHZhciBwb3B1cF8yNzNlY2FiYzA3OTc0YzM1OGY1YjgwNzgyYzMzNzhhNiA9IEwucG9wdXAoeyJtYXhXaWR0aCI6ICIxMDAlIn0pOwoKICAgICAgICAKICAgICAgICAgICAgdmFyIGh0bWxfMDA2OWUxMGQ5YjJkNDQ0OWFjNDExODRiZjVkMTAyYTAgPSAkKGA8ZGl2IGlkPSJodG1sXzAwNjllMTBkOWIyZDQ0NDlhYzQxMTg0YmY1ZDEwMmEwIiBzdHlsZT0id2lkdGg6IDEwMC4wJTsgaGVpZ2h0OiAxMDAuMCU7Ij5OYW1lOiBGT1VSTUlMRSBDUkVFSyBBVCBMT0dBTiBNSUxMIFJPQUQgTkVBUiBDUklTTUFOLCBDTyBQcmVjaXA6IG5hbjwvZGl2PmApWzBdOwogICAgICAgICAgICBwb3B1cF8yNzNlY2FiYzA3OTc0YzM1OGY1YjgwNzgyYzMzNzhhNi5zZXRDb250ZW50KGh0bWxfMDA2OWUxMGQ5YjJkNDQ0OWFjNDExODRiZjVkMTAyYTApOwogICAgICAgIAoKICAgICAgICBtYXJrZXJfY2JmYmU2NDM1YTJhNDkwMTkwODUxNWMxMTM2MDJkZWEuYmluZFBvcHVwKHBvcHVwXzI3M2VjYWJjMDc5NzRjMzU4ZjViODA3ODJjMzM3OGE2KQogICAgICAgIDsKCiAgICAgICAgCiAgICAKICAgIAogICAgICAgICAgICB2YXIgbWFya2VyXzZiNjhhYTllYjI3YTQyZDk5YjllZDVjMmI4ZjNkM2E1ID0gTC5tYXJrZXIoCiAgICAgICAgICAgICAgICBbNDAuMTc3MDgsIC0xMDUuMTc4NTY3XSwKICAgICAgICAgICAgICAgIHt9CiAgICAgICAgICAgICkuYWRkVG8obWFya2VyX2NsdXN0ZXJfYzQ5MDZkZWRmODAxNDQyZGEzMjM3NWRlNTNiM2JiMGQpOwogICAgICAgIAogICAgCiAgICAgICAgdmFyIHBvcHVwXzA5MmRjNDFkMDNkNDRkMDBhZTVhODhiNjBlZjYwNmU4ID0gTC5wb3B1cCh7Im1heFdpZHRoIjogIjEwMCUifSk7CgogICAgICAgIAogICAgICAgICAgICB2YXIgaHRtbF9mNWQ1NjE5ZGQ1NTU0NDI3YTc0MzI5ZjdlNWZmNjliMiA9ICQoYDxkaXYgaWQ9Imh0bWxfZjVkNTYxOWRkNTU1NDQyN2E3NDMyOWY3ZTVmZjY5YjIiIHN0eWxlPSJ3aWR0aDogMTAwLjAlOyBoZWlnaHQ6IDEwMC4wJTsiPk5hbWU6IFBFQ0sgUEVMTEEgQ0xPVkVSIERJVENIIFByZWNpcDogMS4yOTwvZGl2PmApWzBdOwogICAgICAgICAgICBwb3B1cF8wOTJkYzQxZDAzZDQ0ZDAwYWU1YTg4YjYwZWY2MDZlOC5zZXRDb250ZW50KGh0bWxfZjVkNTYxOWRkNTU1NDQyN2E3NDMyOWY3ZTVmZjY5YjIpOwogICAgICAgIAoKICAgICAgICBtYXJrZXJfNmI2OGFhOWViMjdhNDJkOTliOWVkNWMyYjhmM2QzYTUuYmluZFBvcHVwKHBvcHVwXzA5MmRjNDFkMDNkNDRkMDBhZTVhODhiNjBlZjYwNmU4KQogICAgICAgIDsKCiAgICAgICAgCiAgICAKICAgIAogICAgICAgICAgICB2YXIgbWFya2VyXzc0ODc3YTI4OTNhZjQ3OTBiYWQwNDMzMzhmMjM0NDM1ID0gTC5tYXJrZXIoCiAgICAgICAgICAgICAgICBbMzkuOTQ3NzA0LCAtMTA1LjM1NzMwOF0sCiAgICAgICAgICAgICAgICB7fQogICAgICAgICAgICApLmFkZFRvKG1hcmtlcl9jbHVzdGVyX2M0OTA2ZGVkZjgwMTQ0MmRhMzIzNzVkZTUzYjNiYjBkKTsKICAgICAgICAKICAgIAogICAgICAgIHZhciBwb3B1cF8wOWMyMWIwMzBkNzY0ODg5YTZmMTgzMDQwODBmMzIxOCA9IEwucG9wdXAoeyJtYXhXaWR0aCI6ICIxMDAlIn0pOwoKICAgICAgICAKICAgICAgICAgICAgdmFyIGh0bWxfODI4N2JhZDk2M2JiNDE4ZTk1MGJlNThlMmIxOWNmNGYgPSAkKGA8ZGl2IGlkPSJodG1sXzgyODdiYWQ5NjNiYjQxOGU5NTBiZTU4ZTJiMTljZjRmIiBzdHlsZT0id2lkdGg6IDEwMC4wJTsgaGVpZ2h0OiAxMDAuMCU7Ij5OYW1lOiBHUk9TUyBSRVNFUlZPSVIgIFByZWNpcDogMTEzNjUuMDA8L2Rpdj5gKVswXTsKICAgICAgICAgICAgcG9wdXBfMDljMjFiMDMwZDc2NDg4OWE2ZjE4MzA0MDgwZjMyMTguc2V0Q29udGVudChodG1sXzgyODdiYWQ5NjNiYjQxOGU5NTBiZTU4ZTJiMTljZjRmKTsKICAgICAgICAKCiAgICAgICAgbWFya2VyXzc0ODc3YTI4OTNhZjQ3OTBiYWQwNDMzMzhmMjM0NDM1LmJpbmRQb3B1cChwb3B1cF8wOWMyMWIwMzBkNzY0ODg5YTZmMTgzMDQwODBmMzIxOCkKICAgICAgICA7CgogICAgICAgIAogICAgCjwvc2NyaXB0Pg== onload="this.contentDocument.open();this.contentDocument.write(atob(this.getAttribute('data-html')));this.contentDocument.close();" allowfullscreen webkitallowfullscreen mozallowfullscreen></iframe></div></div>





<div class="notice--info" markdown="1">

## Additional Resources

* <a href="https://blog.datafiniti.co/4-reasons-you-should-use-json-instead-of-csv-2cac362f1943" target="_blank">Why you should use JSON instead of csv.</a>


* <a href="https://www.w3schools.com/js/js_json_intro.asp" target="_blank">W3schools JSON intro </a>

</div>

