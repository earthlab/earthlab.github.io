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
      'date_time': '2020-03-31T18:00:00.000',
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
      'amount': '33.00',
      'station_type': 'Stream',
      'wd': '5',
      'http_linkage': {'url': 'https://dwr.state.co.us/SurfaceWater/data/detail_graph.aspx?ID=SVCLYOCO&MTYPE=DISCHRG'},
      'date_time': '2020-03-31T18:15:00.000',
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
      <td>0.10</td>
      <td>Diversion</td>
      <td>5</td>
      <td>2020-03-31T18:00:00.000</td>
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
      <td>33.00</td>
      <td>Stream</td>
      <td>5</td>
      <td>2020-03-31T18:15:00.000</td>
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
      <td>2020-03-31T16:45:00.000</td>
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
      <td>0.05</td>
      <td>Stream</td>
      <td>6</td>
      <td>2020-03-31T17:45:00.000</td>
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
      <td>2020-03-31T18:00:00.000</td>
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
      <td>2020-03-31T18:00:00.000</td>
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
      <td>33.00</td>
      <td>Stream</td>
      <td>5</td>
      <td>2020-03-31T18:15:00.000</td>
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
      <td>2020-03-31T16:45:00.000</td>
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
      <td>0.05</td>
      <td>Stream</td>
      <td>6</td>
      <td>2020-03-31T17:45:00.000</td>
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
      <td>2020-03-31T18:00:00.000</td>
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



<div style="width:100%;"><div style="position:relative;width:100%;height:0;padding-bottom:60%;"><iframe src="data:text/html;charset=utf-8;base64,PCFET0NUWVBFIGh0bWw+CjxoZWFkPiAgICAKICAgIDxtZXRhIGh0dHAtZXF1aXY9ImNvbnRlbnQtdHlwZSIgY29udGVudD0idGV4dC9odG1sOyBjaGFyc2V0PVVURi04IiAvPgogICAgCiAgICAgICAgPHNjcmlwdD4KICAgICAgICAgICAgTF9OT19UT1VDSCA9IGZhbHNlOwogICAgICAgICAgICBMX0RJU0FCTEVfM0QgPSBmYWxzZTsKICAgICAgICA8L3NjcmlwdD4KICAgIAogICAgPHNjcmlwdCBzcmM9Imh0dHBzOi8vY2RuLmpzZGVsaXZyLm5ldC9ucG0vbGVhZmxldEAxLjUuMS9kaXN0L2xlYWZsZXQuanMiPjwvc2NyaXB0PgogICAgPHNjcmlwdCBzcmM9Imh0dHBzOi8vY29kZS5qcXVlcnkuY29tL2pxdWVyeS0xLjEyLjQubWluLmpzIj48L3NjcmlwdD4KICAgIDxzY3JpcHQgc3JjPSJodHRwczovL21heGNkbi5ib290c3RyYXBjZG4uY29tL2Jvb3RzdHJhcC8zLjIuMC9qcy9ib290c3RyYXAubWluLmpzIj48L3NjcmlwdD4KICAgIDxzY3JpcHQgc3JjPSJodHRwczovL2NkbmpzLmNsb3VkZmxhcmUuY29tL2FqYXgvbGlicy9MZWFmbGV0LmF3ZXNvbWUtbWFya2Vycy8yLjAuMi9sZWFmbGV0LmF3ZXNvbWUtbWFya2Vycy5qcyI+PC9zY3JpcHQ+CiAgICA8bGluayByZWw9InN0eWxlc2hlZXQiIGhyZWY9Imh0dHBzOi8vY2RuLmpzZGVsaXZyLm5ldC9ucG0vbGVhZmxldEAxLjUuMS9kaXN0L2xlYWZsZXQuY3NzIi8+CiAgICA8bGluayByZWw9InN0eWxlc2hlZXQiIGhyZWY9Imh0dHBzOi8vbWF4Y2RuLmJvb3RzdHJhcGNkbi5jb20vYm9vdHN0cmFwLzMuMi4wL2Nzcy9ib290c3RyYXAubWluLmNzcyIvPgogICAgPGxpbmsgcmVsPSJzdHlsZXNoZWV0IiBocmVmPSJodHRwczovL21heGNkbi5ib290c3RyYXBjZG4uY29tL2Jvb3RzdHJhcC8zLjIuMC9jc3MvYm9vdHN0cmFwLXRoZW1lLm1pbi5jc3MiLz4KICAgIDxsaW5rIHJlbD0ic3R5bGVzaGVldCIgaHJlZj0iaHR0cHM6Ly9tYXhjZG4uYm9vdHN0cmFwY2RuLmNvbS9mb250LWF3ZXNvbWUvNC42LjMvY3NzL2ZvbnQtYXdlc29tZS5taW4uY3NzIi8+CiAgICA8bGluayByZWw9InN0eWxlc2hlZXQiIGhyZWY9Imh0dHBzOi8vY2RuanMuY2xvdWRmbGFyZS5jb20vYWpheC9saWJzL0xlYWZsZXQuYXdlc29tZS1tYXJrZXJzLzIuMC4yL2xlYWZsZXQuYXdlc29tZS1tYXJrZXJzLmNzcyIvPgogICAgPGxpbmsgcmVsPSJzdHlsZXNoZWV0IiBocmVmPSJodHRwczovL3Jhd2Nkbi5naXRoYWNrLmNvbS9weXRob24tdmlzdWFsaXphdGlvbi9mb2xpdW0vbWFzdGVyL2ZvbGl1bS90ZW1wbGF0ZXMvbGVhZmxldC5hd2Vzb21lLnJvdGF0ZS5jc3MiLz4KICAgIDxzdHlsZT5odG1sLCBib2R5IHt3aWR0aDogMTAwJTtoZWlnaHQ6IDEwMCU7bWFyZ2luOiAwO3BhZGRpbmc6IDA7fTwvc3R5bGU+CiAgICA8c3R5bGU+I21hcCB7cG9zaXRpb246YWJzb2x1dGU7dG9wOjA7Ym90dG9tOjA7cmlnaHQ6MDtsZWZ0OjA7fTwvc3R5bGU+CiAgICAKICAgICAgICAgICAgPG1ldGEgbmFtZT0idmlld3BvcnQiIGNvbnRlbnQ9IndpZHRoPWRldmljZS13aWR0aCwKICAgICAgICAgICAgICAgIGluaXRpYWwtc2NhbGU9MS4wLCBtYXhpbXVtLXNjYWxlPTEuMCwgdXNlci1zY2FsYWJsZT1ubyIgLz4KICAgICAgICAgICAgPHN0eWxlPgogICAgICAgICAgICAgICAgI21hcF81YjNkMTM1YzVkODM0ZjU1ODdhMzJiNDExYThhNWViZiB7CiAgICAgICAgICAgICAgICAgICAgcG9zaXRpb246IHJlbGF0aXZlOwogICAgICAgICAgICAgICAgICAgIHdpZHRoOiAxMDAuMCU7CiAgICAgICAgICAgICAgICAgICAgaGVpZ2h0OiAxMDAuMCU7CiAgICAgICAgICAgICAgICAgICAgbGVmdDogMC4wJTsKICAgICAgICAgICAgICAgICAgICB0b3A6IDAuMCU7CiAgICAgICAgICAgICAgICB9CiAgICAgICAgICAgIDwvc3R5bGU+CiAgICAgICAgCjwvaGVhZD4KPGJvZHk+ICAgIAogICAgCiAgICAgICAgICAgIDxkaXYgY2xhc3M9ImZvbGl1bS1tYXAiIGlkPSJtYXBfNWIzZDEzNWM1ZDgzNGY1NTg3YTMyYjQxMWE4YTVlYmYiID48L2Rpdj4KICAgICAgICAKPC9ib2R5Pgo8c2NyaXB0PiAgICAKICAgIAogICAgICAgICAgICB2YXIgbWFwXzViM2QxMzVjNWQ4MzRmNTU4N2EzMmI0MTFhOGE1ZWJmID0gTC5tYXAoCiAgICAgICAgICAgICAgICAibWFwXzViM2QxMzVjNWQ4MzRmNTU4N2EzMmI0MTFhOGE1ZWJmIiwKICAgICAgICAgICAgICAgIHsKICAgICAgICAgICAgICAgICAgICBjZW50ZXI6IFs0MC4wMSwgLTEwNS4yN10sCiAgICAgICAgICAgICAgICAgICAgY3JzOiBMLkNSUy5FUFNHMzg1NywKICAgICAgICAgICAgICAgICAgICB6b29tOiAxMCwKICAgICAgICAgICAgICAgICAgICB6b29tQ29udHJvbDogdHJ1ZSwKICAgICAgICAgICAgICAgICAgICBwcmVmZXJDYW52YXM6IGZhbHNlLAogICAgICAgICAgICAgICAgfQogICAgICAgICAgICApOwoKICAgICAgICAgICAgCgogICAgICAgIAogICAgCiAgICAgICAgICAgIHZhciB0aWxlX2xheWVyXzUwOGUzMmQ0NjE0YTRhYTY5YWE4OGVkNjUxM2I1ODYzID0gTC50aWxlTGF5ZXIoCiAgICAgICAgICAgICAgICAiaHR0cHM6Ly9jYXJ0b2RiLWJhc2VtYXBzLXtzfS5nbG9iYWwuc3NsLmZhc3RseS5uZXQvbGlnaHRfYWxsL3t6fS97eH0ve3l9LnBuZyIsCiAgICAgICAgICAgICAgICB7ImF0dHJpYnV0aW9uIjogIlx1MDAyNmNvcHk7IFx1MDAzY2EgaHJlZj1cImh0dHA6Ly93d3cub3BlbnN0cmVldG1hcC5vcmcvY29weXJpZ2h0XCJcdTAwM2VPcGVuU3RyZWV0TWFwXHUwMDNjL2FcdTAwM2UgY29udHJpYnV0b3JzIFx1MDAyNmNvcHk7IFx1MDAzY2EgaHJlZj1cImh0dHA6Ly9jYXJ0b2RiLmNvbS9hdHRyaWJ1dGlvbnNcIlx1MDAzZUNhcnRvREJcdTAwM2MvYVx1MDAzZSwgQ2FydG9EQiBcdTAwM2NhIGhyZWYgPVwiaHR0cDovL2NhcnRvZGIuY29tL2F0dHJpYnV0aW9uc1wiXHUwMDNlYXR0cmlidXRpb25zXHUwMDNjL2FcdTAwM2UiLCAiZGV0ZWN0UmV0aW5hIjogZmFsc2UsICJtYXhOYXRpdmVab29tIjogMTgsICJtYXhab29tIjogMTgsICJtaW5ab29tIjogMCwgIm5vV3JhcCI6IGZhbHNlLCAib3BhY2l0eSI6IDEsICJzdWJkb21haW5zIjogImFiYyIsICJ0bXMiOiBmYWxzZX0KICAgICAgICAgICAgKS5hZGRUbyhtYXBfNWIzZDEzNWM1ZDgzNGY1NTg3YTMyYjQxMWE4YTVlYmYpOwogICAgICAgIAogICAgCiAgICAgICAgZnVuY3Rpb24gZ2VvX2pzb25fYTk2NzFmODk3NDhlNGZjY2JjNjNhNDYyYzZkMTY0M2Ffb25FYWNoRmVhdHVyZShmZWF0dXJlLCBsYXllcikgewogICAgICAgICAgICBsYXllci5vbih7CiAgICAgICAgICAgICAgICBjbGljazogZnVuY3Rpb24oZSkgewogICAgICAgICAgICAgICAgICAgIG1hcF81YjNkMTM1YzVkODM0ZjU1ODdhMzJiNDExYThhNWViZi5maXRCb3VuZHMoZS50YXJnZXQuZ2V0Qm91bmRzKCkpOwogICAgICAgICAgICAgICAgfQogICAgICAgICAgICB9KTsKICAgICAgICB9OwogICAgICAgIHZhciBnZW9fanNvbl9hOTY3MWY4OTc0OGU0ZmNjYmM2M2E0NjJjNmQxNjQzYSA9IEwuZ2VvSnNvbihudWxsLCB7CiAgICAgICAgICAgICAgICBvbkVhY2hGZWF0dXJlOiBnZW9fanNvbl9hOTY3MWY4OTc0OGU0ZmNjYmM2M2E0NjJjNmQxNjQzYV9vbkVhY2hGZWF0dXJlLAogICAgICAgICAgICAKICAgICAgICB9KTsKICAgICAgICBmdW5jdGlvbiBnZW9fanNvbl9hOTY3MWY4OTc0OGU0ZmNjYmM2M2E0NjJjNmQxNjQzYV9hZGQgKGRhdGEpIHsKICAgICAgICAgICAgZ2VvX2pzb25fYTk2NzFmODk3NDhlNGZjY2JjNjNhNDYyYzZkMTY0M2EuYWRkRGF0YShkYXRhKQogICAgICAgICAgICAgICAgLmFkZFRvKG1hcF81YjNkMTM1YzVkODM0ZjU1ODdhMzJiNDExYThhNWViZik7CiAgICAgICAgfQogICAgICAgICAgICBnZW9fanNvbl9hOTY3MWY4OTc0OGU0ZmNjYmM2M2E0NjJjNmQxNjQzYV9hZGQoeyJiYm94IjogWy0xMDUuNTA0NDQsIDM5LjkzMTU5NywgLTEwNS4wNzI1MDIsIDQwLjI2MDgyN10sICJmZWF0dXJlcyI6IFt7ImJib3giOiBbLTEwNS4xODU3ODksIDQwLjE4NTAzMywgLTEwNS4xODU3ODksIDQwLjE4NTAzM10sICJnZW9tZXRyeSI6IHsiY29vcmRpbmF0ZXMiOiBbLTEwNS4xODU3ODksIDQwLjE4NTAzM10sICJ0eXBlIjogIlBvaW50In0sICJpZCI6ICIwIiwgInByb3BlcnRpZXMiOiB7ImFtb3VudCI6ICIwLjEwIiwgImNvdW50eSI6ICJCT1VMREVSIiwgImRhdGFfc291cmNlIjogIkNvb3BlcmF0aXZlIFByb2dyYW0gb2YgQ0RXUiwgTkNXQ0QgXHUwMDI2IFNWTEhXQ0QiLCAiZGF0ZV90aW1lIjogIjIwMjAtMDMtMzFUMTg6MDA6MDAuMDAwIiwgImRpdiI6ICIxIiwgImR3cl9hYmJyZXYiOiAiWldFVFVSQ08iLCAiZmxhZyI6IG51bGwsICJodHRwX2xpbmthZ2UudXJsIjogImh0dHBzOi8vZHdyLnN0YXRlLmNvLnVzL1N1cmZhY2VXYXRlci9kYXRhL2RldGFpbF9ncmFwaC5hc3B4P0lEPVpXRVRVUkNPXHUwMDI2TVRZUEU9RElTQ0hSRyIsICJsb2NhdGlvbi5sYXRpdHVkZSI6IDQwLjE4NTAzMywgImxvY2F0aW9uLmxvbmdpdHVkZSI6IC0xMDUuMTg1Nzg5LCAibG9jYXRpb24ubmVlZHNfcmVjb2RpbmciOiBmYWxzZSwgInN0YWdlIjogIjAuMDQiLCAic3RhdGlvbl9uYW1lIjogIlpXRUNLIEFORCBUVVJORVIgRElUQ0giLCAic3RhdGlvbl9zdGF0dXMiOiAiQWN0aXZlIiwgInN0YXRpb25fdHlwZSI6ICJEaXZlcnNpb24iLCAidXNnc19zdGF0aW9uX2lkIjogbnVsbCwgInZhcmlhYmxlIjogIkRJU0NIUkciLCAid2QiOiAiNSJ9LCAidHlwZSI6ICJGZWF0dXJlIn0sIHsiYmJveCI6IFstMTA1LjI2MzQ5LCA0MC4yMjA3MDIsIC0xMDUuMjYzNDksIDQwLjIyMDcwMl0sICJnZW9tZXRyeSI6IHsiY29vcmRpbmF0ZXMiOiBbLTEwNS4yNjM0OSwgNDAuMjIwNzAyXSwgInR5cGUiOiAiUG9pbnQifSwgImlkIjogIjEiLCAicHJvcGVydGllcyI6IHsiYW1vdW50IjogIjMzLjAwIiwgImNvdW50eSI6ICJCT1VMREVSIiwgImRhdGFfc291cmNlIjogIkNvLiBEaXZpc2lvbiBvZiBXYXRlciBSZXNvdXJjZXMiLCAiZGF0ZV90aW1lIjogIjIwMjAtMDMtMzFUMTg6MTU6MDAuMDAwIiwgImRpdiI6ICIxIiwgImR3cl9hYmJyZXYiOiAiU1ZDTFlPQ08iLCAiZmxhZyI6IG51bGwsICJodHRwX2xpbmthZ2UudXJsIjogImh0dHBzOi8vZHdyLnN0YXRlLmNvLnVzL1N1cmZhY2VXYXRlci9kYXRhL2RldGFpbF9ncmFwaC5hc3B4P0lEPVNWQ0xZT0NPXHUwMDI2TVRZUEU9RElTQ0hSRyIsICJsb2NhdGlvbi5sYXRpdHVkZSI6IDQwLjIyMDcwMiwgImxvY2F0aW9uLmxvbmdpdHVkZSI6IC0xMDUuMjYzNDksICJsb2NhdGlvbi5uZWVkc19yZWNvZGluZyI6IGZhbHNlLCAic3RhZ2UiOiAiMi45NCIsICJzdGF0aW9uX25hbWUiOiAiU0FJTlQgVlJBSU4gQ1JFRUsgQVQgTFlPTlMsIENPIiwgInN0YXRpb25fc3RhdHVzIjogIkFjdGl2ZSIsICJzdGF0aW9uX3R5cGUiOiAiU3RyZWFtIiwgInVzZ3Nfc3RhdGlvbl9pZCI6ICIwNjcyNDAwMCIsICJ2YXJpYWJsZSI6ICJESVNDSFJHIiwgIndkIjogIjUifSwgInR5cGUiOiAiRmVhdHVyZSJ9LCB7ImJib3giOiBbLTEwNS4yMDY1OTIsIDQwLjE5NjQyMiwgLTEwNS4yMDY1OTIsIDQwLjE5NjQyMl0sICJnZW9tZXRyeSI6IHsiY29vcmRpbmF0ZXMiOiBbLTEwNS4yMDY1OTIsIDQwLjE5NjQyMl0sICJ0eXBlIjogIlBvaW50In0sICJpZCI6ICIyIiwgInByb3BlcnRpZXMiOiB7ImFtb3VudCI6ICIyLjc2IiwgImNvdW50eSI6ICJCT1VMREVSIiwgImRhdGFfc291cmNlIjogIkNvb3BlcmF0aXZlIFByb2dyYW0gb2YgQ0RXUiwgTkNXQ0QgXHUwMDI2IFNWTEhXQ0QiLCAiZGF0ZV90aW1lIjogIjIwMjAtMDMtMzFUMTY6NDU6MDAuMDAwIiwgImRpdiI6ICIxIiwgImR3cl9hYmJyZXYiOiAiT0xJRElUQ08iLCAiZmxhZyI6IG51bGwsICJodHRwX2xpbmthZ2UudXJsIjogImh0dHBzOi8vZHdyLnN0YXRlLmNvLnVzL1N1cmZhY2VXYXRlci9kYXRhL2RldGFpbF9ncmFwaC5hc3B4P0lEPU9MSURJVENPXHUwMDI2TVRZUEU9RElTQ0hSRyIsICJsb2NhdGlvbi5sYXRpdHVkZSI6IDQwLjE5NjQyMiwgImxvY2F0aW9uLmxvbmdpdHVkZSI6IC0xMDUuMjA2NTkyLCAibG9jYXRpb24ubmVlZHNfcmVjb2RpbmciOiBmYWxzZSwgInN0YWdlIjogIjAuMTkiLCAic3RhdGlvbl9uYW1lIjogIk9MSUdBUkNIWSBESVRDSCBESVZFUlNJT04iLCAic3RhdGlvbl9zdGF0dXMiOiAiQWN0aXZlIiwgInN0YXRpb25fdHlwZSI6ICJEaXZlcnNpb24iLCAidXNnc19zdGF0aW9uX2lkIjogbnVsbCwgInZhcmlhYmxlIjogIkRJU0NIUkciLCAid2QiOiAiNSJ9LCAidHlwZSI6ICJGZWF0dXJlIn0sIHsiYmJveCI6IFstMTA1LjA3MjUwMiwgNDAuMDg3NTgzLCAtMTA1LjA3MjUwMiwgNDAuMDg3NTgzXSwgImdlb21ldHJ5IjogeyJjb29yZGluYXRlcyI6IFstMTA1LjA3MjUwMiwgNDAuMDg3NTgzXSwgInR5cGUiOiAiUG9pbnQifSwgImlkIjogIjMiLCAicHJvcGVydGllcyI6IHsiYW1vdW50IjogIjAuMDUiLCAiY291bnR5IjogIkJPVUxERVIiLCAiZGF0YV9zb3VyY2UiOiAiQ28uIERpdmlzaW9uIG9mIFdhdGVyIFJlc291cmNlcyIsICJkYXRlX3RpbWUiOiAiMjAyMC0wMy0zMVQxNzo0NTowMC4wMDAiLCAiZGl2IjogIjEiLCAiZHdyX2FiYnJldiI6ICJQTk1PVVRDTyIsICJmbGFnIjogbnVsbCwgImh0dHBfbGlua2FnZS51cmwiOiAiaHR0cHM6Ly9kd3Iuc3RhdGUuY28udXMvU3VyZmFjZVdhdGVyL2RhdGEvZGV0YWlsX2dyYXBoLmFzcHg/SUQ9UE5NT1VUQ09cdTAwMjZNVFlQRT1ESVNDSFJHIiwgImxvY2F0aW9uLmxhdGl0dWRlIjogNDAuMDg3NTgzLCAibG9jYXRpb24ubG9uZ2l0dWRlIjogLTEwNS4wNzI1MDIsICJsb2NhdGlvbi5uZWVkc19yZWNvZGluZyI6IGZhbHNlLCAic3RhZ2UiOiBudWxsLCAic3RhdGlvbl9uYW1lIjogIlBBTkFNQSBSRVNFUlZPSVIgT1VUTEVUIiwgInN0YXRpb25fc3RhdHVzIjogIkFjdGl2ZSIsICJzdGF0aW9uX3R5cGUiOiAiU3RyZWFtIiwgInVzZ3Nfc3RhdGlvbl9pZCI6IG51bGwsICJ2YXJpYWJsZSI6ICJESVNDSFJHIiwgIndkIjogIjYifSwgInR5cGUiOiAiRmVhdHVyZSJ9LCB7ImJib3giOiBbLTEwNS4yMTAzOSwgNDAuMTkzNzU4LCAtMTA1LjIxMDM5LCA0MC4xOTM3NThdLCAiZ2VvbWV0cnkiOiB7ImNvb3JkaW5hdGVzIjogWy0xMDUuMjEwMzksIDQwLjE5Mzc1OF0sICJ0eXBlIjogIlBvaW50In0sICJpZCI6ICI0IiwgInByb3BlcnRpZXMiOiB7ImFtb3VudCI6ICIwLjAwIiwgImNvdW50eSI6ICJCT1VMREVSIiwgImRhdGFfc291cmNlIjogIkNvb3BlcmF0aXZlIFByb2dyYW0gb2YgQ0RXUiwgTkNXQ0QgXHUwMDI2IFNWTEhXQ0QiLCAiZGF0ZV90aW1lIjogIjIwMjAtMDMtMzFUMTg6MDA6MDAuMDAwIiwgImRpdiI6ICIxIiwgImR3cl9hYmJyZXYiOiAiQ0xPRElUQ08iLCAiZmxhZyI6IG51bGwsICJodHRwX2xpbmthZ2UudXJsIjogImh0dHBzOi8vZHdyLnN0YXRlLmNvLnVzL1N1cmZhY2VXYXRlci9kYXRhL2RldGFpbF9ncmFwaC5hc3B4P0lEPUNMT0RJVENPXHUwMDI2TVRZUEU9RElTQ0hSRyIsICJsb2NhdGlvbi5sYXRpdHVkZSI6IDQwLjE5Mzc1OCwgImxvY2F0aW9uLmxvbmdpdHVkZSI6IC0xMDUuMjEwMzksICJsb2NhdGlvbi5uZWVkc19yZWNvZGluZyI6IGZhbHNlLCAic3RhZ2UiOiBudWxsLCAic3RhdGlvbl9uYW1lIjogIkNMT1VHSCBBTkQgVFJVRSBESVRDSCIsICJzdGF0aW9uX3N0YXR1cyI6ICJBY3RpdmUiLCAic3RhdGlvbl90eXBlIjogIkRpdmVyc2lvbiIsICJ1c2dzX3N0YXRpb25faWQiOiBudWxsLCAidmFyaWFibGUiOiAiRElTQ0hSRyIsICJ3ZCI6ICI1In0sICJ0eXBlIjogIkZlYXR1cmUifSwgeyJiYm94IjogWy0xMDUuMzMwODQxLCA0MC4wMDYzOCwgLTEwNS4zMzA4NDEsIDQwLjAwNjM4XSwgImdlb21ldHJ5IjogeyJjb29yZGluYXRlcyI6IFstMTA1LjMzMDg0MSwgNDAuMDA2MzhdLCAidHlwZSI6ICJQb2ludCJ9LCAiaWQiOiAiNSIsICJwcm9wZXJ0aWVzIjogeyJhbW91bnQiOiAiMjIuMTAiLCAiY291bnR5IjogIkJPVUxERVIiLCAiZGF0YV9zb3VyY2UiOiAiQ28uIERpdmlzaW9uIG9mIFdhdGVyIFJlc291cmNlcyIsICJkYXRlX3RpbWUiOiAiMjAyMC0wMy0zMVQxODoxNTowMC4wMDAiLCAiZGl2IjogIjEiLCAiZHdyX2FiYnJldiI6ICJCT0NPUk9DTyIsICJmbGFnIjogIkljZSIsICJodHRwX2xpbmthZ2UudXJsIjogImh0dHBzOi8vZHdyLnN0YXRlLmNvLnVzL1N1cmZhY2VXYXRlci9kYXRhL2RldGFpbF9ncmFwaC5hc3B4P0lEPUJPQ09ST0NPXHUwMDI2TVRZUEU9RElTQ0hSRyIsICJsb2NhdGlvbi5sYXRpdHVkZSI6IDQwLjAwNjM4LCAibG9jYXRpb24ubG9uZ2l0dWRlIjogLTEwNS4zMzA4NDEsICJsb2NhdGlvbi5uZWVkc19yZWNvZGluZyI6IGZhbHNlLCAic3RhZ2UiOiAiMS44NiIsICJzdGF0aW9uX25hbWUiOiAiQk9VTERFUiBDUkVFSyBORUFSIE9ST0RFTEwsIENPLiIsICJzdGF0aW9uX3N0YXR1cyI6ICJBY3RpdmUiLCAic3RhdGlvbl90eXBlIjogIlN0cmVhbSIsICJ1c2dzX3N0YXRpb25faWQiOiAiMDY3MjcwMDAiLCAidmFyaWFibGUiOiAiRElTQ0hSRyIsICJ3ZCI6ICI2In0sICJ0eXBlIjogIkZlYXR1cmUifSwgeyJiYm94IjogWy0xMDUuMjE4Nzc3LCA0MC4yMDQxOTMsIC0xMDUuMjE4Nzc3LCA0MC4yMDQxOTNdLCAiZ2VvbWV0cnkiOiB7ImNvb3JkaW5hdGVzIjogWy0xMDUuMjE4Nzc3LCA0MC4yMDQxOTNdLCAidHlwZSI6ICJQb2ludCJ9LCAiaWQiOiAiNiIsICJwcm9wZXJ0aWVzIjogeyJhbW91bnQiOiAiMC4wMCIsICJjb3VudHkiOiAiQk9VTERFUiIsICJkYXRhX3NvdXJjZSI6ICJDb29wZXJhdGl2ZSBQcm9ncmFtIG9mIENEV1IsIE5DV0NEIFx1MDAyNiBTVkxIV0NEIiwgImRhdGVfdGltZSI6ICIyMDIwLTAzLTMxVDE4OjAwOjAwLjAwMCIsICJkaXYiOiAiMSIsICJkd3JfYWJicmV2IjogIkxPTlNVUENPIiwgImZsYWciOiBudWxsLCAiaHR0cF9saW5rYWdlLnVybCI6ICJodHRwczovL2R3ci5zdGF0ZS5jby51cy9TdXJmYWNlV2F0ZXIvZGF0YS9kZXRhaWxfZ3JhcGguYXNweD9JRD1MT05TVVBDT1x1MDAyNk1UWVBFPURJU0NIUkciLCAibG9jYXRpb24ubGF0aXR1ZGUiOiA0MC4yMDQxOTMsICJsb2NhdGlvbi5sb25naXR1ZGUiOiAtMTA1LjIxODc3NywgImxvY2F0aW9uLm5lZWRzX3JlY29kaW5nIjogZmFsc2UsICJzdGFnZSI6IG51bGwsICJzdGF0aW9uX25hbWUiOiAiTE9OR01PTlQgU1VQUExZIERJVENIIiwgInN0YXRpb25fc3RhdHVzIjogIkFjdGl2ZSIsICJzdGF0aW9uX3R5cGUiOiAiRGl2ZXJzaW9uIiwgInVzZ3Nfc3RhdGlvbl9pZCI6IG51bGwsICJ2YXJpYWJsZSI6ICJESVNDSFJHIiwgIndkIjogIjUifSwgInR5cGUiOiAiRmVhdHVyZSJ9LCB7ImJib3giOiBbLTEwNS4xNzU4MTcsIDQwLjI1ODcyNiwgLTEwNS4xNzU4MTcsIDQwLjI1ODcyNl0sICJnZW9tZXRyeSI6IHsiY29vcmRpbmF0ZXMiOiBbLTEwNS4xNzU4MTcsIDQwLjI1ODcyNl0sICJ0eXBlIjogIlBvaW50In0sICJpZCI6ICI3IiwgInByb3BlcnRpZXMiOiB7ImFtb3VudCI6ICIxMS45MCIsICJjb3VudHkiOiAiQk9VTERFUiIsICJkYXRhX3NvdXJjZSI6ICJDby4gRGl2aXNpb24gb2YgV2F0ZXIgUmVzb3VyY2VzIiwgImRhdGVfdGltZSI6ICIyMDIwLTAzLTMxVDE4OjE1OjAwLjAwMCIsICJkaXYiOiAiMSIsICJkd3JfYWJicmV2IjogIkJPVUJZUENPIiwgImZsYWciOiBudWxsLCAiaHR0cF9saW5rYWdlLnVybCI6ICJodHRwczovL2R3ci5zdGF0ZS5jby51cy9TdXJmYWNlV2F0ZXIvZGF0YS9kZXRhaWxfZ3JhcGguYXNweD9JRD1CT1VCWVBDT1x1MDAyNk1UWVBFPURJU0NIUkciLCAibG9jYXRpb24ubGF0aXR1ZGUiOiA0MC4yNTg3MjYsICJsb2NhdGlvbi5sb25naXR1ZGUiOiAtMTA1LjE3NTgxNywgImxvY2F0aW9uLm5lZWRzX3JlY29kaW5nIjogZmFsc2UsICJzdGFnZSI6ICIwLjgzIiwgInN0YXRpb25fbmFtZSI6ICJCT1VMREVSLUxBUklNRVIgQllQQVNTIE5FQVIgQkVSVEhPVUQiLCAic3RhdGlvbl9zdGF0dXMiOiAiQWN0aXZlIiwgInN0YXRpb25fdHlwZSI6ICJEaXZlcnNpb24iLCAidXNnc19zdGF0aW9uX2lkIjogbnVsbCwgInZhcmlhYmxlIjogIkRJU0NIUkciLCAid2QiOiAiNCJ9LCAidHlwZSI6ICJGZWF0dXJlIn0sIHsiYmJveCI6IFstMTA1LjIwNjM4NiwgNDAuMjU4MDM4LCAtMTA1LjIwNjM4NiwgNDAuMjU4MDM4XSwgImdlb21ldHJ5IjogeyJjb29yZGluYXRlcyI6IFstMTA1LjIwNjM4NiwgNDAuMjU4MDM4XSwgInR5cGUiOiAiUG9pbnQifSwgImlkIjogIjgiLCAicHJvcGVydGllcyI6IHsiYW1vdW50IjogIjEzLjYwIiwgImNvdW50eSI6ICJCT1VMREVSIiwgImRhdGFfc291cmNlIjogIkNvLiBEaXZpc2lvbiBvZiBXYXRlciBSZXNvdXJjZXMiLCAiZGF0ZV90aW1lIjogIjIwMjAtMDMtMzFUMTg6MzA6MDAuMDAwIiwgImRpdiI6ICIxIiwgImR3cl9hYmJyZXYiOiAiTFRDQU5ZQ08iLCAiZmxhZyI6IG51bGwsICJodHRwX2xpbmthZ2UudXJsIjogImh0dHBzOi8vZHdyLnN0YXRlLmNvLnVzL1N1cmZhY2VXYXRlci9kYXRhL2RldGFpbF9ncmFwaC5hc3B4P0lEPUxUQ0FOWUNPXHUwMDI2TVRZUEU9RElTQ0hSRyIsICJsb2NhdGlvbi5sYXRpdHVkZSI6IDQwLjI1ODAzOCwgImxvY2F0aW9uLmxvbmdpdHVkZSI6IC0xMDUuMjA2Mzg2LCAibG9jYXRpb24ubmVlZHNfcmVjb2RpbmciOiBmYWxzZSwgInN0YWdlIjogIjEuNDkiLCAic3RhdGlvbl9uYW1lIjogIkxJVFRMRSBUSE9NUFNPTiBSSVZFUiBBVCBDQU5ZT04gTU9VVEggTkVBUiBCRVJUSE9VRCIsICJzdGF0aW9uX3N0YXR1cyI6ICJBY3RpdmUiLCAic3RhdGlvbl90eXBlIjogIlN0cmVhbSIsICJ1c2dzX3N0YXRpb25faWQiOiBudWxsLCAidmFyaWFibGUiOiAiRElTQ0hSRyIsICJ3ZCI6ICI0In0sICJ0eXBlIjogIkZlYXR1cmUifSwgeyJiYm94IjogWy0xMDUuMTY3NjIyLCA0MC4xNzI5MjUsIC0xMDUuMTY3NjIyLCA0MC4xNzI5MjVdLCAiZ2VvbWV0cnkiOiB7ImNvb3JkaW5hdGVzIjogWy0xMDUuMTY3NjIyLCA0MC4xNzI5MjVdLCAidHlwZSI6ICJQb2ludCJ9LCAiaWQiOiAiOSIsICJwcm9wZXJ0aWVzIjogeyJhbW91bnQiOiAiMC4wMCIsICJjb3VudHkiOiAiQk9VTERFUiIsICJkYXRhX3NvdXJjZSI6ICJDb29wZXJhdGl2ZSBTRFIgUHJvZ3JhbSBvZiBDRFdSIFx1MDAyNiBOQ1dDRCIsICJkYXRlX3RpbWUiOiAiMjAyMC0wMy0zMVQxODowMDowMC4wMDAiLCAiZGl2IjogIjEiLCAiZHdyX2FiYnJldiI6ICJOT1JNVVRDTyIsICJmbGFnIjogbnVsbCwgImh0dHBfbGlua2FnZS51cmwiOiAiaHR0cHM6Ly9kd3Iuc3RhdGUuY28udXMvU3VyZmFjZVdhdGVyL2RhdGEvZGV0YWlsX2dyYXBoLmFzcHg/SUQ9Tk9STVVUQ09cdTAwMjZNVFlQRT1ESVNDSFJHIiwgImxvY2F0aW9uLmxhdGl0dWRlIjogNDAuMTcyOTI1LCAibG9jYXRpb24ubG9uZ2l0dWRlIjogLTEwNS4xNjc2MjIsICJsb2NhdGlvbi5uZWVkc19yZWNvZGluZyI6IGZhbHNlLCAic3RhZ2UiOiBudWxsLCAic3RhdGlvbl9uYW1lIjogIk5PUlRIV0VTVCBNVVRVQUwgRElUQ0giLCAic3RhdGlvbl9zdGF0dXMiOiAiQWN0aXZlIiwgInN0YXRpb25fdHlwZSI6ICJEaXZlcnNpb24iLCAidXNnc19zdGF0aW9uX2lkIjogbnVsbCwgInZhcmlhYmxlIjogIkRJU0NIUkciLCAid2QiOiAiNSJ9LCAidHlwZSI6ICJGZWF0dXJlIn0sIHsiYmJveCI6IFstMTA1LjEzMDgxOSwgNDAuMTM0Mjc4LCAtMTA1LjEzMDgxOSwgNDAuMTM0Mjc4XSwgImdlb21ldHJ5IjogeyJjb29yZGluYXRlcyI6IFstMTA1LjEzMDgxOSwgNDAuMTM0Mjc4XSwgInR5cGUiOiAiUG9pbnQifSwgImlkIjogIjEwIiwgInByb3BlcnRpZXMiOiB7ImFtb3VudCI6ICIzLjM0IiwgImNvdW50eSI6ICJCT1VMREVSIiwgImRhdGFfc291cmNlIjogIlUuUy4gR2VvbG9naWNhbCBTdXJ2ZXkiLCAiZGF0ZV90aW1lIjogIjIwMjAtMDMtMzFUMTg6MTA6MDAuMDAwIiwgImRpdiI6ICIxIiwgImR3cl9hYmJyZXYiOiAiTEVGVEhPQ08iLCAiZmxhZyI6IG51bGwsICJodHRwX2xpbmthZ2UudXJsIjogImh0dHBzOi8vd2F0ZXJkYXRhLnVzZ3MuZ292L253aXMvdXY/MDY3MjQ5NzAiLCAibG9jYXRpb24ubGF0aXR1ZGUiOiA0MC4xMzQyNzgsICJsb2NhdGlvbi5sb25naXR1ZGUiOiAtMTA1LjEzMDgxOSwgImxvY2F0aW9uLm5lZWRzX3JlY29kaW5nIjogZmFsc2UsICJzdGFnZSI6IG51bGwsICJzdGF0aW9uX25hbWUiOiAiTEVGVCBIQU5EIENSRUVLIEFUIEhPVkVSIFJPQUQgTkVBUiBMT05HTU9OVCwgQ08iLCAic3RhdGlvbl9zdGF0dXMiOiAiQWN0aXZlIiwgInN0YXRpb25fdHlwZSI6ICJTdHJlYW0iLCAidXNnc19zdGF0aW9uX2lkIjogIjA2NzI0OTcwIiwgInZhcmlhYmxlIjogIkRJU0NIUkciLCAid2QiOiAiNSJ9LCAidHlwZSI6ICJGZWF0dXJlIn0sIHsiYmJveCI6IFstMTA1LjIxODY3NywgMzkuOTg2MTY5LCAtMTA1LjIxODY3NywgMzkuOTg2MTY5XSwgImdlb21ldHJ5IjogeyJjb29yZGluYXRlcyI6IFstMTA1LjIxODY3NywgMzkuOTg2MTY5XSwgInR5cGUiOiAiUG9pbnQifSwgImlkIjogIjExIiwgInByb3BlcnRpZXMiOiB7ImFtb3VudCI6ICIwLjAwIiwgImNvdW50eSI6ICJCT1VMREVSIiwgImRhdGFfc291cmNlIjogIkNvb3BlcmF0aXZlIFByb2dyYW0gb2YgQ0RXUiwgTkNXQ0QgXHUwMDI2IExTUFdDRCIsICJkYXRlX3RpbWUiOiAiMjAyMC0wMy0zMVQxNzowMDowMC4wMDAiLCAiZGl2IjogIjEiLCAiZHdyX2FiYnJldiI6ICJEUllDQVJDTyIsICJmbGFnIjogbnVsbCwgImh0dHBfbGlua2FnZS51cmwiOiAiaHR0cHM6Ly9kd3Iuc3RhdGUuY28udXMvU3VyZmFjZVdhdGVyL2RhdGEvZGV0YWlsX2dyYXBoLmFzcHg/SUQ9RFJZQ0FSQ09cdTAwMjZNVFlQRT1ESVNDSFJHIiwgImxvY2F0aW9uLmxhdGl0dWRlIjogMzkuOTg2MTY5LCAibG9jYXRpb24ubG9uZ2l0dWRlIjogLTEwNS4yMTg2NzcsICJsb2NhdGlvbi5uZWVkc19yZWNvZGluZyI6IGZhbHNlLCAic3RhZ2UiOiBudWxsLCAic3RhdGlvbl9uYW1lIjogIkRSWSBDUkVFSyBDQVJSSUVSIiwgInN0YXRpb25fc3RhdHVzIjogIkFjdGl2ZSIsICJzdGF0aW9uX3R5cGUiOiAiRGl2ZXJzaW9uIiwgInVzZ3Nfc3RhdGlvbl9pZCI6IG51bGwsICJ2YXJpYWJsZSI6ICJESVNDSFJHIiwgIndkIjogIjYifSwgInR5cGUiOiAiRmVhdHVyZSJ9LCB7ImJib3giOiBbLTEwNS4zMDQ5OSwgMzkuOTMxNTk3LCAtMTA1LjMwNDk5LCAzOS45MzE1OTddLCAiZ2VvbWV0cnkiOiB7ImNvb3JkaW5hdGVzIjogWy0xMDUuMzA0OTksIDM5LjkzMTU5N10sICJ0eXBlIjogIlBvaW50In0sICJpZCI6ICIxMiIsICJwcm9wZXJ0aWVzIjogeyJhbW91bnQiOiAiMTcuODAiLCAiY291bnR5IjogIkJPVUxERVIiLCAiZGF0YV9zb3VyY2UiOiAiQ28uIERpdmlzaW9uIG9mIFdhdGVyIFJlc291cmNlcyIsICJkYXRlX3RpbWUiOiAiMjAyMC0wMy0zMVQxODoxNTowMC4wMDAiLCAiZGl2IjogIjEiLCAiZHdyX2FiYnJldiI6ICJCT0NFTFNDTyIsICJmbGFnIjogbnVsbCwgImh0dHBfbGlua2FnZS51cmwiOiAiaHR0cHM6Ly9kd3Iuc3RhdGUuY28udXMvU3VyZmFjZVdhdGVyL2RhdGEvZGV0YWlsX2dyYXBoLmFzcHg/SUQ9Qk9DRUxTQ09cdTAwMjZNVFlQRT1ESVNDSFJHIiwgImxvY2F0aW9uLmxhdGl0dWRlIjogMzkuOTMxNTk3LCAibG9jYXRpb24ubG9uZ2l0dWRlIjogLTEwNS4zMDQ5OSwgImxvY2F0aW9uLm5lZWRzX3JlY29kaW5nIjogZmFsc2UsICJzdGFnZSI6ICIyLjI0IiwgInN0YXRpb25fbmFtZSI6ICJTT1VUSCBCT1VMREVSIENSRUVLIE5FQVIgRUxET1JBRE8gU1BSSU5HUywgQ08uIiwgInN0YXRpb25fc3RhdHVzIjogIkFjdGl2ZSIsICJzdGF0aW9uX3R5cGUiOiAiU3RyZWFtIiwgInVzZ3Nfc3RhdGlvbl9pZCI6IG51bGwsICJ2YXJpYWJsZSI6ICJESVNDSFJHIiwgIndkIjogIjYifSwgInR5cGUiOiAiRmVhdHVyZSJ9LCB7ImJib3giOiBbLTEwNS4xNjg0NzEsIDQwLjE2MDcwNSwgLTEwNS4xNjg0NzEsIDQwLjE2MDcwNV0sICJnZW9tZXRyeSI6IHsiY29vcmRpbmF0ZXMiOiBbLTEwNS4xNjg0NzEsIDQwLjE2MDcwNV0sICJ0eXBlIjogIlBvaW50In0sICJpZCI6ICIxMyIsICJwcm9wZXJ0aWVzIjogeyJhbW91bnQiOiAiMC4wMCIsICJjb3VudHkiOiAiQk9VTERFUiIsICJkYXRhX3NvdXJjZSI6ICJDby4gRGl2aXNpb24gb2YgV2F0ZXIgUmVzb3VyY2VzIiwgImRhdGVfdGltZSI6ICIyMDIwLTAzLTMxVDE2OjQ1OjAwLjAwMCIsICJkaXYiOiAiMSIsICJkd3JfYWJicmV2IjogIlBFQ1JUTkNPIiwgImZsYWciOiBudWxsLCAiaHR0cF9saW5rYWdlLnVybCI6ICJodHRwczovL2R3ci5zdGF0ZS5jby51cy9TdXJmYWNlV2F0ZXIvZGF0YS9kZXRhaWxfZ3JhcGguYXNweD9JRD1QRUNSVE5DT1x1MDAyNk1UWVBFPURJU0NIUkciLCAibG9jYXRpb24ubGF0aXR1ZGUiOiA0MC4xNjA3MDUsICJsb2NhdGlvbi5sb25naXR1ZGUiOiAtMTA1LjE2ODQ3MSwgImxvY2F0aW9uLm5lZWRzX3JlY29kaW5nIjogZmFsc2UsICJzdGFnZSI6IG51bGwsICJzdGF0aW9uX25hbWUiOiAiUEVDSy1QRUxMQSBBVUdNRU5UQVRJT04gUkVUVVJOIiwgInN0YXRpb25fc3RhdHVzIjogIkFjdGl2ZSIsICJzdGF0aW9uX3R5cGUiOiAiRGl2ZXJzaW9uIiwgInVzZ3Nfc3RhdGlvbl9pZCI6IG51bGwsICJ2YXJpYWJsZSI6ICJESVNDSFJHIiwgIndkIjogIjUifSwgInR5cGUiOiAiRmVhdHVyZSJ9LCB7ImJib3giOiBbLTEwNS4yMjI2MzksIDQwLjE5OTMyMSwgLTEwNS4yMjI2MzksIDQwLjE5OTMyMV0sICJnZW9tZXRyeSI6IHsiY29vcmRpbmF0ZXMiOiBbLTEwNS4yMjI2MzksIDQwLjE5OTMyMV0sICJ0eXBlIjogIlBvaW50In0sICJpZCI6ICIxNCIsICJwcm9wZXJ0aWVzIjogeyJhbW91bnQiOiAiMC4wMCIsICJjb3VudHkiOiAiQk9VTERFUiIsICJkYXRhX3NvdXJjZSI6ICJDb29wZXJhdGl2ZSBQcm9ncmFtIG9mIENEV1IsIE5DV0NEIFx1MDAyNiBTVkxIV0NEIiwgImRhdGVfdGltZSI6ICIyMDIwLTAzLTMxVDE3OjQ1OjAwLjAwMCIsICJkaXYiOiAiMSIsICJkd3JfYWJicmV2IjogIkdPRElUMUNPIiwgImZsYWciOiBudWxsLCAiaHR0cF9saW5rYWdlLnVybCI6ICJodHRwczovL2R3ci5zdGF0ZS5jby51cy9TdXJmYWNlV2F0ZXIvZGF0YS9kZXRhaWxfZ3JhcGguYXNweD9JRD1HT0RJVDFDT1x1MDAyNk1UWVBFPURJU0NIUkciLCAibG9jYXRpb24ubGF0aXR1ZGUiOiA0MC4xOTkzMjEsICJsb2NhdGlvbi5sb25naXR1ZGUiOiAtMTA1LjIyMjYzOSwgImxvY2F0aW9uLm5lZWRzX3JlY29kaW5nIjogZmFsc2UsICJzdGFnZSI6IG51bGwsICJzdGF0aW9uX25hbWUiOiAiR09TUyBESVRDSCAxIiwgInN0YXRpb25fc3RhdHVzIjogIkFjdGl2ZSIsICJzdGF0aW9uX3R5cGUiOiAiRGl2ZXJzaW9uIiwgInVzZ3Nfc3RhdGlvbl9pZCI6IG51bGwsICJ2YXJpYWJsZSI6ICJESVNDSFJHIiwgIndkIjogIjUifSwgInR5cGUiOiAiRmVhdHVyZSJ9LCB7ImJib3giOiBbLTEwNS4yMTA0MjQsIDQwLjE5MzI4LCAtMTA1LjIxMDQyNCwgNDAuMTkzMjhdLCAiZ2VvbWV0cnkiOiB7ImNvb3JkaW5hdGVzIjogWy0xMDUuMjEwNDI0LCA0MC4xOTMyOF0sICJ0eXBlIjogIlBvaW50In0sICJpZCI6ICIxNSIsICJwcm9wZXJ0aWVzIjogeyJhbW91bnQiOiAiMC4wMCIsICJjb3VudHkiOiAiQk9VTERFUiIsICJkYXRhX3NvdXJjZSI6ICJDb29wZXJhdGl2ZSBQcm9ncmFtIG9mIENEV1IsIE5DV0NEIFx1MDAyNiBTVkxIV0NEIiwgImRhdGVfdGltZSI6ICIyMDIwLTAzLTMxVDE4OjAwOjAwLjAwMCIsICJkaXYiOiAiMSIsICJkd3JfYWJicmV2IjogIldFQkRJVENPIiwgImZsYWciOiBudWxsLCAiaHR0cF9saW5rYWdlLnVybCI6ICJodHRwczovL2R3ci5zdGF0ZS5jby51cy9TdXJmYWNlV2F0ZXIvZGF0YS9kZXRhaWxfZ3JhcGguYXNweD9JRD1XRUJESVRDT1x1MDAyNk1UWVBFPURJU0NIUkciLCAibG9jYXRpb24ubGF0aXR1ZGUiOiA0MC4xOTMyOCwgImxvY2F0aW9uLmxvbmdpdHVkZSI6IC0xMDUuMjEwNDI0LCAibG9jYXRpb24ubmVlZHNfcmVjb2RpbmciOiBmYWxzZSwgInN0YWdlIjogbnVsbCwgInN0YXRpb25fbmFtZSI6ICJXRUJTVEVSIE1DQ0FTTElOIERJVENIIiwgInN0YXRpb25fc3RhdHVzIjogIkFjdGl2ZSIsICJzdGF0aW9uX3R5cGUiOiAiRGl2ZXJzaW9uIiwgInVzZ3Nfc3RhdGlvbl9pZCI6IG51bGwsICJ2YXJpYWJsZSI6ICJESVNDSFJHIiwgIndkIjogIjUifSwgInR5cGUiOiAiRmVhdHVyZSJ9LCB7ImJib3giOiBbLTEwNS4yMjA0NzcsIDM5Ljk4ODQ4MSwgLTEwNS4yMjA0NzcsIDM5Ljk4ODQ4MV0sICJnZW9tZXRyeSI6IHsiY29vcmRpbmF0ZXMiOiBbLTEwNS4yMjA0NzcsIDM5Ljk4ODQ4MV0sICJ0eXBlIjogIlBvaW50In0sICJpZCI6ICIxNiIsICJwcm9wZXJ0aWVzIjogeyJhbW91bnQiOiAiMC4wMCIsICJjb3VudHkiOiAiQk9VTERFUiIsICJkYXRhX3NvdXJjZSI6ICJDby4gRGl2aXNpb24gb2YgV2F0ZXIgUmVzb3VyY2VzIiwgImRhdGVfdGltZSI6ICIyMDIwLTAzLTMxVDE3OjQ1OjAwLjAwMCIsICJkaXYiOiAiMSIsICJkd3JfYWJicmV2IjogIkhPV0RJVENPIiwgImZsYWciOiBudWxsLCAiaHR0cF9saW5rYWdlLnVybCI6ICJodHRwczovL2R3ci5zdGF0ZS5jby51cy9TdXJmYWNlV2F0ZXIvZGF0YS9kZXRhaWxfZ3JhcGguYXNweD9JRD1IT1dESVRDT1x1MDAyNk1UWVBFPURJU0NIUkciLCAibG9jYXRpb24ubGF0aXR1ZGUiOiAzOS45ODg0ODEsICJsb2NhdGlvbi5sb25naXR1ZGUiOiAtMTA1LjIyMDQ3NywgImxvY2F0aW9uLm5lZWRzX3JlY29kaW5nIjogZmFsc2UsICJzdGFnZSI6IG51bGwsICJzdGF0aW9uX25hbWUiOiAiSE9XQVJEIERJVENIIiwgInN0YXRpb25fc3RhdHVzIjogIkFjdGl2ZSIsICJzdGF0aW9uX3R5cGUiOiAiRGl2ZXJzaW9uIiwgInVzZ3Nfc3RhdGlvbl9pZCI6IG51bGwsICJ2YXJpYWJsZSI6ICJESVNDSFJHIiwgIndkIjogIjYifSwgInR5cGUiOiAiRmVhdHVyZSJ9LCB7ImJib3giOiBbLTEwNS4zNjUzNjUsIDQwLjIxNjI2MywgLTEwNS4zNjUzNjUsIDQwLjIxNjI2M10sICJnZW9tZXRyeSI6IHsiY29vcmRpbmF0ZXMiOiBbLTEwNS4zNjUzNjUsIDQwLjIxNjI2M10sICJ0eXBlIjogIlBvaW50In0sICJpZCI6ICIxNyIsICJwcm9wZXJ0aWVzIjogeyJhbW91bnQiOiAiMTI5MTcuMDAiLCAiY291bnR5IjogIkJPVUxERVIiLCAiZGF0YV9zb3VyY2UiOiAiQ28uIERpdmlzaW9uIG9mIFdhdGVyIFJlc291cmNlcyIsICJkYXRlX3RpbWUiOiAiMjAyMC0wMy0zMVQxODo0NTowMC4wMDAiLCAiZGl2IjogIjEiLCAiZHdyX2FiYnJldiI6ICJCUktEQU1DTyIsICJmbGFnIjogbnVsbCwgImh0dHBfbGlua2FnZS51cmwiOiAiaHR0cHM6Ly9kd3Iuc3RhdGUuY28udXMvU3VyZmFjZVdhdGVyL2RhdGEvZGV0YWlsX2dyYXBoLmFzcHg/SUQ9QlJLREFNQ09cdTAwMjZNVFlQRT1TVE9SQUdFIiwgImxvY2F0aW9uLmxhdGl0dWRlIjogNDAuMjE2MjYzLCAibG9jYXRpb24ubG9uZ2l0dWRlIjogLTEwNS4zNjUzNjUsICJsb2NhdGlvbi5uZWVkc19yZWNvZGluZyI6IGZhbHNlLCAic3RhZ2UiOiAiNjM4NC4yMCIsICJzdGF0aW9uX25hbWUiOiAiQlVUVE9OUk9DSyAoUkFMUEggUFJJQ0UpIFJFU0VSVk9JUiIsICJzdGF0aW9uX3N0YXR1cyI6ICJBY3RpdmUiLCAic3RhdGlvbl90eXBlIjogIlJlc2Vydm9pciIsICJ1c2dzX3N0YXRpb25faWQiOiBudWxsLCAidmFyaWFibGUiOiAiU1RPUkFHRSIsICJ3ZCI6ICI1In0sICJ0eXBlIjogIkZlYXR1cmUifSwgeyJiYm94IjogWy0xMDUuMjA5NSwgNDAuMjU1Nzc2LCAtMTA1LjIwOTUsIDQwLjI1NTc3Nl0sICJnZW9tZXRyeSI6IHsiY29vcmRpbmF0ZXMiOiBbLTEwNS4yMDk1LCA0MC4yNTU3NzZdLCAidHlwZSI6ICJQb2ludCJ9LCAiaWQiOiAiMTgiLCAicHJvcGVydGllcyI6IHsiYW1vdW50IjogIjAuMTAiLCAiY291bnR5IjogIkJPVUxERVIiLCAiZGF0YV9zb3VyY2UiOiAiTm9ydGhlcm4gQ29sb3JhZG8gV2F0ZXIgQ29uc2VydmFuY3kgRGlzdHJpY3QiLCAiZGF0ZV90aW1lIjogIjIwMjAtMDMtMzFUMTg6MDA6MDAuMDAwIiwgImRpdiI6ICIxIiwgImR3cl9hYmJyZXYiOiAiTElUVEgyQ08iLCAiZmxhZyI6IG51bGwsICJodHRwX2xpbmthZ2UudXJsIjogImh0dHA6Ly93d3cubm9ydGhlcm53YXRlci5vcmcvV2F0ZXJQcm9qZWN0cy9FYXN0U2xvcGVXYXRlckRhdGEuYXNweCIsICJsb2NhdGlvbi5sYXRpdHVkZSI6IDQwLjI1NTc3NiwgImxvY2F0aW9uLmxvbmdpdHVkZSI6IC0xMDUuMjA5NSwgImxvY2F0aW9uLm5lZWRzX3JlY29kaW5nIjogZmFsc2UsICJzdGFnZSI6ICIwLjEwIiwgInN0YXRpb25fbmFtZSI6ICJMSVRUTEUgVEhPTVBTT04gIzIgRElUQ0giLCAic3RhdGlvbl9zdGF0dXMiOiAiQWN0aXZlIiwgInN0YXRpb25fdHlwZSI6ICJEaXZlcnNpb24iLCAidXNnc19zdGF0aW9uX2lkIjogIkVTMTkwMCIsICJ2YXJpYWJsZSI6ICJESVNDSFJHIiwgIndkIjogIjQifSwgInR5cGUiOiAiRmVhdHVyZSJ9LCB7ImJib3giOiBbLTEwNS4xNjQzOTcsIDQwLjI1Nzg0NCwgLTEwNS4xNjQzOTcsIDQwLjI1Nzg0NF0sICJnZW9tZXRyeSI6IHsiY29vcmRpbmF0ZXMiOiBbLTEwNS4xNjQzOTcsIDQwLjI1Nzg0NF0sICJ0eXBlIjogIlBvaW50In0sICJpZCI6ICIxOSIsICJwcm9wZXJ0aWVzIjogeyJhbW91bnQiOiAiMC4wMCIsICJjb3VudHkiOiAiQk9VTERFUiIsICJkYXRhX3NvdXJjZSI6ICJDb29wZXJhdGl2ZSBTRFIgUHJvZ3JhbSBvZiBDRFdSIFx1MDAyNiBOQ1dDRCIsICJkYXRlX3RpbWUiOiAiMjAyMC0wMy0zMVQxODowMDowMC4wMDAiLCAiZGl2IjogIjEiLCAiZHdyX2FiYnJldiI6ICJCTFdESVRDTyIsICJmbGFnIjogbnVsbCwgImh0dHBfbGlua2FnZS51cmwiOiAiaHR0cHM6Ly9kd3Iuc3RhdGUuY28udXMvU3VyZmFjZVdhdGVyL2RhdGEvZGV0YWlsX2dyYXBoLmFzcHg/SUQ9QkxXRElUQ09cdTAwMjZNVFlQRT1ESVNDSFJHIiwgImxvY2F0aW9uLmxhdGl0dWRlIjogNDAuMjU3ODQ0LCAibG9jYXRpb24ubG9uZ2l0dWRlIjogLTEwNS4xNjQzOTcsICJsb2NhdGlvbi5uZWVkc19yZWNvZGluZyI6IGZhbHNlLCAic3RhZ2UiOiAiMC4wMCIsICJzdGF0aW9uX25hbWUiOiAiQkxPV0VSIERJVENIIiwgInN0YXRpb25fc3RhdHVzIjogIkFjdGl2ZSIsICJzdGF0aW9uX3R5cGUiOiAiRGl2ZXJzaW9uIiwgInVzZ3Nfc3RhdGlvbl9pZCI6IG51bGwsICJ2YXJpYWJsZSI6ICJESVNDSFJHIiwgIndkIjogIjQifSwgInR5cGUiOiAiRmVhdHVyZSJ9LCB7ImJib3giOiBbLTEwNS4xNzg4NzUsIDQwLjA1MTY1MiwgLTEwNS4xNzg4NzUsIDQwLjA1MTY1Ml0sICJnZW9tZXRyeSI6IHsiY29vcmRpbmF0ZXMiOiBbLTEwNS4xNzg4NzUsIDQwLjA1MTY1Ml0sICJ0eXBlIjogIlBvaW50In0sICJpZCI6ICIyMCIsICJwcm9wZXJ0aWVzIjogeyJhbW91bnQiOiAiMjEuMzAiLCAiY291bnR5IjogIkJPVUxERVIiLCAiZGF0YV9zb3VyY2UiOiAiVS5TLiBHZW9sb2dpY2FsIFN1cnZleSIsICJkYXRlX3RpbWUiOiAiMjAyMC0wMy0zMVQxNjoxNTowMC4wMDAiLCAiZGl2IjogIjEiLCAiZHdyX2FiYnJldiI6ICJCT0NOT1JDTyIsICJmbGFnIjogbnVsbCwgImh0dHBfbGlua2FnZS51cmwiOiAiaHR0cHM6Ly93YXRlcmRhdGEudXNncy5nb3Yvbndpcy91dj8wNjczMDIwMCIsICJsb2NhdGlvbi5sYXRpdHVkZSI6IDQwLjA1MTY1MiwgImxvY2F0aW9uLmxvbmdpdHVkZSI6IC0xMDUuMTc4ODc1LCAibG9jYXRpb24ubmVlZHNfcmVjb2RpbmciOiBmYWxzZSwgInN0YWdlIjogbnVsbCwgInN0YXRpb25fbmFtZSI6ICJCT1VMREVSIENSRUVLIEFUIE5PUlRIIDc1VEggU1QuIE5FQVIgQk9VTERFUiwgQ08iLCAic3RhdGlvbl9zdGF0dXMiOiAiQWN0aXZlIiwgInN0YXRpb25fdHlwZSI6ICJTdHJlYW0iLCAidXNnc19zdGF0aW9uX2lkIjogIjA2NzMwMjAwIiwgInZhcmlhYmxlIjogIkRJU0NIUkciLCAid2QiOiAiNiJ9LCAidHlwZSI6ICJGZWF0dXJlIn0sIHsiYmJveCI6IFstMTA1LjE2MDg3NiwgNDAuMTcwOTk4LCAtMTA1LjE2MDg3NiwgNDAuMTcwOTk4XSwgImdlb21ldHJ5IjogeyJjb29yZGluYXRlcyI6IFstMTA1LjE2MDg3NiwgNDAuMTcwOTk4XSwgInR5cGUiOiAiUG9pbnQifSwgImlkIjogIjIxIiwgInByb3BlcnRpZXMiOiB7ImFtb3VudCI6ICIwLjM4IiwgImNvdW50eSI6ICJCT1VMREVSIiwgImRhdGFfc291cmNlIjogIkNvb3BlcmF0aXZlIFByb2dyYW0gb2YgQ0RXUiwgTkNXQ0QgXHUwMDI2IFNWTEhXQ0QiLCAiZGF0ZV90aW1lIjogIjIwMjAtMDMtMzFUMTg6MDA6MDAuMDAwIiwgImRpdiI6ICIxIiwgImR3cl9hYmJyZXYiOiAiU0ZMRElUQ08iLCAiZmxhZyI6IG51bGwsICJodHRwX2xpbmthZ2UudXJsIjogImh0dHBzOi8vZHdyLnN0YXRlLmNvLnVzL1N1cmZhY2VXYXRlci9kYXRhL2RldGFpbF9ncmFwaC5hc3B4P0lEPVNGTERJVENPXHUwMDI2TVRZUEU9RElTQ0hSRyIsICJsb2NhdGlvbi5sYXRpdHVkZSI6IDQwLjE3MDk5OCwgImxvY2F0aW9uLmxvbmdpdHVkZSI6IC0xMDUuMTYwODc2LCAibG9jYXRpb24ubmVlZHNfcmVjb2RpbmciOiBmYWxzZSwgInN0YWdlIjogIjAuMTEiLCAic3RhdGlvbl9uYW1lIjogIlNPVVRIIEZMQVQgRElUQ0giLCAic3RhdGlvbl9zdGF0dXMiOiAiQWN0aXZlIiwgInN0YXRpb25fdHlwZSI6ICJEaXZlcnNpb24iLCAidXNnc19zdGF0aW9uX2lkIjogbnVsbCwgInZhcmlhYmxlIjogIkRJU0NIUkciLCAid2QiOiAiNSJ9LCAidHlwZSI6ICJGZWF0dXJlIn0sIHsiYmJveCI6IFstMTA1LjA3NTY5NSwgNDAuMTUzMzQxLCAtMTA1LjA3NTY5NSwgNDAuMTUzMzQxXSwgImdlb21ldHJ5IjogeyJjb29yZGluYXRlcyI6IFstMTA1LjA3NTY5NSwgNDAuMTUzMzQxXSwgInR5cGUiOiAiUG9pbnQifSwgImlkIjogIjIyIiwgInByb3BlcnRpZXMiOiB7ImFtb3VudCI6ICIzMi4wMCIsICJjb3VudHkiOiAiQk9VTERFUiIsICJkYXRhX3NvdXJjZSI6ICJDby4gRGl2aXNpb24gb2YgV2F0ZXIgUmVzb3VyY2VzIiwgImRhdGVfdGltZSI6ICIyMDIwLTAzLTMxVDE4OjMwOjAwLjAwMCIsICJkaXYiOiAiMSIsICJkd3JfYWJicmV2IjogIlNWQ0xPUENPIiwgImZsYWciOiBudWxsLCAiaHR0cF9saW5rYWdlLnVybCI6ICJodHRwczovL2R3ci5zdGF0ZS5jby51cy9TdXJmYWNlV2F0ZXIvZGF0YS9kZXRhaWxfZ3JhcGguYXNweD9JRD1TVkNMT1BDT1x1MDAyNk1UWVBFPURJU0NIUkciLCAibG9jYXRpb24ubGF0aXR1ZGUiOiA0MC4xNTMzNDEsICJsb2NhdGlvbi5sb25naXR1ZGUiOiAtMTA1LjA3NTY5NSwgImxvY2F0aW9uLm5lZWRzX3JlY29kaW5nIjogZmFsc2UsICJzdGFnZSI6ICIzLjUwIiwgInN0YXRpb25fbmFtZSI6ICJTQUlOVCBWUkFJTiBDUkVFSyBCRUxPVyBLRU4gUFJBVFQgQkxWRCBBVCBMT05HTU9OVCwgQ08iLCAic3RhdGlvbl9zdGF0dXMiOiAiQWN0aXZlIiwgInN0YXRpb25fdHlwZSI6ICJTdHJlYW0iLCAidXNnc19zdGF0aW9uX2lkIjogbnVsbCwgInZhcmlhYmxlIjogIkRJU0NIUkciLCAid2QiOiAiNSJ9LCAidHlwZSI6ICJGZWF0dXJlIn0sIHsiYmJveCI6IFstMTA1LjE1MTE0MywgNDAuMDUzNjYxLCAtMTA1LjE1MTE0MywgNDAuMDUzNjYxXSwgImdlb21ldHJ5IjogeyJjb29yZGluYXRlcyI6IFstMTA1LjE1MTE0MywgNDAuMDUzNjYxXSwgInR5cGUiOiAiUG9pbnQifSwgImlkIjogIjIzIiwgInByb3BlcnRpZXMiOiB7ImFtb3VudCI6ICIyLjA2IiwgImNvdW50eSI6ICJCT1VMREVSIiwgImRhdGFfc291cmNlIjogIkNvb3BlcmF0aXZlIFByb2dyYW0gb2YgQ0RXUiwgTkNXQ0QgXHUwMDI2IExTUFdDRCIsICJkYXRlX3RpbWUiOiAiMjAyMC0wMy0zMVQxODowMDowMC4wMDAiLCAiZGl2IjogIjEiLCAiZHdyX2FiYnJldiI6ICJMRUdESVRDTyIsICJmbGFnIjogbnVsbCwgImh0dHBfbGlua2FnZS51cmwiOiAiaHR0cHM6Ly9kd3Iuc3RhdGUuY28udXMvU3VyZmFjZVdhdGVyL2RhdGEvZGV0YWlsX2dyYXBoLmFzcHg/SUQ9TEVHRElUQ09cdTAwMjZNVFlQRT1ESVNDSFJHIiwgImxvY2F0aW9uLmxhdGl0dWRlIjogNDAuMDUzNjYxLCAibG9jYXRpb24ubG9uZ2l0dWRlIjogLTEwNS4xNTExNDMsICJsb2NhdGlvbi5uZWVkc19yZWNvZGluZyI6IGZhbHNlLCAic3RhZ2UiOiAiMC4xOCIsICJzdGF0aW9uX25hbWUiOiAiTEVHR0VUVCBESVRDSCIsICJzdGF0aW9uX3N0YXR1cyI6ICJBY3RpdmUiLCAic3RhdGlvbl90eXBlIjogIkRpdmVyc2lvbiIsICJ1c2dzX3N0YXRpb25faWQiOiBudWxsLCAidmFyaWFibGUiOiAiRElTQ0hSRyIsICJ3ZCI6ICI2In0sICJ0eXBlIjogIkZlYXR1cmUifSwgeyJiYm94IjogWy0xMDUuMDk3ODcyLCA0MC4wNTk4MDksIC0xMDUuMDk3ODcyLCA0MC4wNTk4MDldLCAiZ2VvbWV0cnkiOiB7ImNvb3JkaW5hdGVzIjogWy0xMDUuMDk3ODcyLCA0MC4wNTk4MDldLCAidHlwZSI6ICJQb2ludCJ9LCAiaWQiOiAiMjQiLCAicHJvcGVydGllcyI6IHsiYW1vdW50IjogIjQ2LjgwIiwgImNvdW50eSI6ICJCT1VMREVSIiwgImRhdGFfc291cmNlIjogIkNvLiBEaXZpc2lvbiBvZiBXYXRlciBSZXNvdXJjZXMiLCAiZGF0ZV90aW1lIjogIjIwMjAtMDMtMzFUMTc6NDU6MDAuMDAwIiwgImRpdiI6ICIxIiwgImR3cl9hYmJyZXYiOiAiQk9DMTA5Q08iLCAiZmxhZyI6IG51bGwsICJodHRwX2xpbmthZ2UudXJsIjogImh0dHBzOi8vZHdyLnN0YXRlLmNvLnVzL1N1cmZhY2VXYXRlci9kYXRhL2RldGFpbF9ncmFwaC5hc3B4P0lEPUJPQzEwOUNPXHUwMDI2TVRZUEU9RElTQ0hSRyIsICJsb2NhdGlvbi5sYXRpdHVkZSI6IDQwLjA1OTgwOSwgImxvY2F0aW9uLmxvbmdpdHVkZSI6IC0xMDUuMDk3ODcyLCAibG9jYXRpb24ubmVlZHNfcmVjb2RpbmciOiBmYWxzZSwgInN0YWdlIjogIjIuNTQiLCAic3RhdGlvbl9uYW1lIjogIkJPVUxERVIgQ1JFRUsgQVQgMTA5IFNUIE5FQVIgRVJJRSwgQ08iLCAic3RhdGlvbl9zdGF0dXMiOiAiQWN0aXZlIiwgInN0YXRpb25fdHlwZSI6ICJTdHJlYW0iLCAidXNnc19zdGF0aW9uX2lkIjogbnVsbCwgInZhcmlhYmxlIjogIkRJU0NIUkciLCAid2QiOiAiNiJ9LCAidHlwZSI6ICJGZWF0dXJlIn0sIHsiYmJveCI6IFstMTA1LjM2MzQyMiwgNDAuMjE1NjU4LCAtMTA1LjM2MzQyMiwgNDAuMjE1NjU4XSwgImdlb21ldHJ5IjogeyJjb29yZGluYXRlcyI6IFstMTA1LjM2MzQyMiwgNDAuMjE1NjU4XSwgInR5cGUiOiAiUG9pbnQifSwgImlkIjogIjI1IiwgInByb3BlcnRpZXMiOiB7ImFtb3VudCI6ICIxOS4zMCIsICJjb3VudHkiOiAiQk9VTERFUiIsICJkYXRhX3NvdXJjZSI6ICJDby4gRGl2aXNpb24gb2YgV2F0ZXIgUmVzb3VyY2VzIiwgImRhdGVfdGltZSI6ICIyMDIwLTAzLTMxVDE3OjQ1OjAwLjAwMCIsICJkaXYiOiAiMSIsICJkd3JfYWJicmV2IjogIk5TVkJCUkNPIiwgImZsYWciOiBudWxsLCAiaHR0cF9saW5rYWdlLnVybCI6ICJodHRwczovL2R3ci5zdGF0ZS5jby51cy9TdXJmYWNlV2F0ZXIvZGF0YS9kZXRhaWxfZ3JhcGguYXNweD9JRD1OU1ZCQlJDT1x1MDAyNk1UWVBFPURJU0NIUkciLCAibG9jYXRpb24ubGF0aXR1ZGUiOiA0MC4yMTU2NTgsICJsb2NhdGlvbi5sb25naXR1ZGUiOiAtMTA1LjM2MzQyMiwgImxvY2F0aW9uLm5lZWRzX3JlY29kaW5nIjogZmFsc2UsICJzdGFnZSI6ICIwLjM0IiwgInN0YXRpb25fbmFtZSI6ICJOT1JUSCBTQUlOVCBWUkFJTiBDUkVFSyBCRUxPVyBCVVRUT05ST0NLICAoUkFMUEggUFJJQ0UpIFJFU0VSVk9JUiIsICJzdGF0aW9uX3N0YXR1cyI6ICJBY3RpdmUiLCAic3RhdGlvbl90eXBlIjogIlN0cmVhbSIsICJ1c2dzX3N0YXRpb25faWQiOiBudWxsLCAidmFyaWFibGUiOiAiRElTQ0hSRyIsICJ3ZCI6ICI1In0sICJ0eXBlIjogIkZlYXR1cmUifSwgeyJiYm94IjogWy0xMDUuMzA0NDA0LCA0MC4xMjYzODksIC0xMDUuMzA0NDA0LCA0MC4xMjYzODldLCAiZ2VvbWV0cnkiOiB7ImNvb3JkaW5hdGVzIjogWy0xMDUuMzA0NDA0LCA0MC4xMjYzODldLCAidHlwZSI6ICJQb2ludCJ9LCAiaWQiOiAiMjYiLCAicHJvcGVydGllcyI6IHsiYW1vdW50IjogIjEzLjUwIiwgImNvdW50eSI6ICJCT1VMREVSIiwgImRhdGFfc291cmNlIjogIkNvLiBEaXZpc2lvbiBvZiBXYXRlciBSZXNvdXJjZXMiLCAiZGF0ZV90aW1lIjogIjIwMjAtMDMtMzFUMTg6MTU6MDAuMDAwIiwgImRpdiI6ICIxIiwgImR3cl9hYmJyZXYiOiAiTEVGQ1JFQ08iLCAiZmxhZyI6IG51bGwsICJodHRwX2xpbmthZ2UudXJsIjogImh0dHBzOi8vZHdyLnN0YXRlLmNvLnVzL1N1cmZhY2VXYXRlci9kYXRhL2RldGFpbF9ncmFwaC5hc3B4P0lEPUxFRkNSRUNPXHUwMDI2TVRZUEU9RElTQ0hSRyIsICJsb2NhdGlvbi5sYXRpdHVkZSI6IDQwLjEyNjM4OSwgImxvY2F0aW9uLmxvbmdpdHVkZSI6IC0xMDUuMzA0NDA0LCAibG9jYXRpb24ubmVlZHNfcmVjb2RpbmciOiBmYWxzZSwgInN0YWdlIjogIjAuNDgiLCAic3RhdGlvbl9uYW1lIjogIkxFRlQgSEFORCBDUkVFSyBORUFSIEJPVUxERVIsIENPLiIsICJzdGF0aW9uX3N0YXR1cyI6ICJBY3RpdmUiLCAic3RhdGlvbl90eXBlIjogIlN0cmVhbSIsICJ1c2dzX3N0YXRpb25faWQiOiAiMDY3MjQ1MDAiLCAidmFyaWFibGUiOiAiRElTQ0hSRyIsICJ3ZCI6ICI1In0sICJ0eXBlIjogIkZlYXR1cmUifSwgeyJiYm94IjogWy0xMDUuMjE3NTE5LCA0MC4wODYyNzgsIC0xMDUuMjE3NTE5LCA0MC4wODYyNzhdLCAiZ2VvbWV0cnkiOiB7ImNvb3JkaW5hdGVzIjogWy0xMDUuMjE3NTE5LCA0MC4wODYyNzhdLCAidHlwZSI6ICJQb2ludCJ9LCAiaWQiOiAiMjciLCAicHJvcGVydGllcyI6IHsiYW1vdW50IjogIjAuMDAiLCAiY291bnR5IjogIkJPVUxERVIiLCAiZGF0YV9zb3VyY2UiOiAiTm9ydGhlcm4gQ29sb3JhZG8gV2F0ZXIgQ29uc2VydmFuY3kgRGlzdHJpY3QiLCAiZGF0ZV90aW1lIjogIjIwMjAtMDMtMzFUMTg6MDA6MDAuMDAwIiwgImRpdiI6ICIxIiwgImR3cl9hYmJyZXYiOiAiQkZDSU5GQ08iLCAiZmxhZyI6IG51bGwsICJodHRwX2xpbmthZ2UudXJsIjogImh0dHA6Ly93d3cubm9ydGhlcm53YXRlci5vcmcvV2F0ZXJQcm9qZWN0cy9FYXN0U2xvcGVXYXRlckRhdGEuYXNweCIsICJsb2NhdGlvbi5sYXRpdHVkZSI6IDQwLjA4NjI3OCwgImxvY2F0aW9uLmxvbmdpdHVkZSI6IC0xMDUuMjE3NTE5LCAibG9jYXRpb24ubmVlZHNfcmVjb2RpbmciOiBmYWxzZSwgInN0YWdlIjogIjAuMDEiLCAic3RhdGlvbl9uYW1lIjogIkJPVUxERVIgUkVTRVJWT0lSIElOTEVUIiwgInN0YXRpb25fc3RhdHVzIjogIkFjdGl2ZSIsICJzdGF0aW9uX3R5cGUiOiAiU3RyZWFtIiwgInVzZ3Nfc3RhdGlvbl9pZCI6ICJFUzE5MTYiLCAidmFyaWFibGUiOiAiRElTQ0hSRyIsICJ3ZCI6ICI2In0sICJ0eXBlIjogIkZlYXR1cmUifSwgeyJiYm94IjogWy0xMDUuMjEwMzg4LCA0MC4xOTMwMTksIC0xMDUuMjEwMzg4LCA0MC4xOTMwMTldLCAiZ2VvbWV0cnkiOiB7ImNvb3JkaW5hdGVzIjogWy0xMDUuMjEwMzg4LCA0MC4xOTMwMTldLCAidHlwZSI6ICJQb2ludCJ9LCAiaWQiOiAiMjgiLCAicHJvcGVydGllcyI6IHsiYW1vdW50IjogIjAuMDAiLCAiY291bnR5IjogIkJPVUxERVIiLCAiZGF0YV9zb3VyY2UiOiAiQ29vcGVyYXRpdmUgUHJvZ3JhbSBvZiBDRFdSLCBOQ1dDRCBcdTAwMjYgU1ZMSFdDRCIsICJkYXRlX3RpbWUiOiAiMjAyMC0wMy0zMVQxODowMDowMC4wMDAiLCAiZGl2IjogIjEiLCAiZHdyX2FiYnJldiI6ICJUUlVESVRDTyIsICJmbGFnIjogbnVsbCwgImh0dHBfbGlua2FnZS51cmwiOiAiaHR0cHM6Ly9kd3Iuc3RhdGUuY28udXMvU3VyZmFjZVdhdGVyL2RhdGEvZGV0YWlsX2dyYXBoLmFzcHg/SUQ9VFJVRElUQ09cdTAwMjZNVFlQRT1ESVNDSFJHIiwgImxvY2F0aW9uLmxhdGl0dWRlIjogNDAuMTkzMDE5LCAibG9jYXRpb24ubG9uZ2l0dWRlIjogLTEwNS4yMTAzODgsICJsb2NhdGlvbi5uZWVkc19yZWNvZGluZyI6IGZhbHNlLCAic3RhZ2UiOiBudWxsLCAic3RhdGlvbl9uYW1lIjogIlRSVUUgQU5EIFdFQlNURVIgRElUQ0giLCAic3RhdGlvbl9zdGF0dXMiOiAiQWN0aXZlIiwgInN0YXRpb25fdHlwZSI6ICJEaXZlcnNpb24iLCAidXNnc19zdGF0aW9uX2lkIjogbnVsbCwgInZhcmlhYmxlIjogIkRJU0NIUkciLCAid2QiOiAiNSJ9LCAidHlwZSI6ICJGZWF0dXJlIn0sIHsiYmJveCI6IFstMTA1LjI1MTgyNiwgNDAuMjEyNjU4LCAtMTA1LjI1MTgyNiwgNDAuMjEyNjU4XSwgImdlb21ldHJ5IjogeyJjb29yZGluYXRlcyI6IFstMTA1LjI1MTgyNiwgNDAuMjEyNjU4XSwgInR5cGUiOiAiUG9pbnQifSwgImlkIjogIjI5IiwgInByb3BlcnRpZXMiOiB7ImFtb3VudCI6ICIwLjAwIiwgImNvdW50eSI6ICJCT1VMREVSIiwgImRhdGFfc291cmNlIjogIkNvb3BlcmF0aXZlIFByb2dyYW0gb2YgQ0RXUiwgTkNXQ0QgXHUwMDI2IFNWTEhXQ0QiLCAiZGF0ZV90aW1lIjogIjIwMjAtMDMtMzFUMTg6MDA6MDAuMDAwIiwgImRpdiI6ICIxIiwgImR3cl9hYmJyZXYiOiAiUk9VUkVBQ08iLCAiZmxhZyI6IG51bGwsICJodHRwX2xpbmthZ2UudXJsIjogImh0dHBzOi8vZHdyLnN0YXRlLmNvLnVzL1N1cmZhY2VXYXRlci9kYXRhL2RldGFpbF9ncmFwaC5hc3B4P0lEPVJPVVJFQUNPXHUwMDI2TVRZUEU9RElTQ0hSRyIsICJsb2NhdGlvbi5sYXRpdHVkZSI6IDQwLjIxMjY1OCwgImxvY2F0aW9uLmxvbmdpdHVkZSI6IC0xMDUuMjUxODI2LCAibG9jYXRpb24ubmVlZHNfcmVjb2RpbmciOiBmYWxzZSwgInN0YWdlIjogbnVsbCwgInN0YXRpb25fbmFtZSI6ICJST1VHSCBBTkQgUkVBRFkgRElUQ0giLCAic3RhdGlvbl9zdGF0dXMiOiAiQWN0aXZlIiwgInN0YXRpb25fdHlwZSI6ICJEaXZlcnNpb24iLCAidXNnc19zdGF0aW9uX2lkIjogbnVsbCwgInZhcmlhYmxlIjogIkRJU0NIUkciLCAid2QiOiAiNSJ9LCAidHlwZSI6ICJGZWF0dXJlIn0sIHsiYmJveCI6IFstMTA1LjE2Nzg3MywgNDAuMTc0ODQ0LCAtMTA1LjE2Nzg3MywgNDAuMTc0ODQ0XSwgImdlb21ldHJ5IjogeyJjb29yZGluYXRlcyI6IFstMTA1LjE2Nzg3MywgNDAuMTc0ODQ0XSwgInR5cGUiOiAiUG9pbnQifSwgImlkIjogIjMwIiwgInByb3BlcnRpZXMiOiB7ImFtb3VudCI6ICIwLjE1IiwgImNvdW50eSI6ICJCT1VMREVSIiwgImRhdGFfc291cmNlIjogIkNvb3BlcmF0aXZlIFByb2dyYW0gb2YgQ0RXUiwgTkNXQ0QgXHUwMDI2IFNWTEhXQ0QiLCAiZGF0ZV90aW1lIjogIjIwMjAtMDMtMzFUMTc6NDU6MDAuMDAwIiwgImRpdiI6ICIxIiwgImR3cl9hYmJyZXYiOiAiSEdSTURXQ08iLCAiZmxhZyI6IG51bGwsICJodHRwX2xpbmthZ2UudXJsIjogImh0dHBzOi8vZHdyLnN0YXRlLmNvLnVzL1N1cmZhY2VXYXRlci9kYXRhL2RldGFpbF9ncmFwaC5hc3B4P0lEPUhHUk1EV0NPXHUwMDI2TVRZUEU9RElTQ0hSRyIsICJsb2NhdGlvbi5sYXRpdHVkZSI6IDQwLjE3NDg0NCwgImxvY2F0aW9uLmxvbmdpdHVkZSI6IC0xMDUuMTY3ODczLCAibG9jYXRpb24ubmVlZHNfcmVjb2RpbmciOiBmYWxzZSwgInN0YWdlIjogIjAuMDgiLCAic3RhdGlvbl9uYW1lIjogIkhBR0VSIE1FQURPV1MgRElUQ0giLCAic3RhdGlvbl9zdGF0dXMiOiAiQWN0aXZlIiwgInN0YXRpb25fdHlwZSI6ICJEaXZlcnNpb24iLCAidXNnc19zdGF0aW9uX2lkIjogbnVsbCwgInZhcmlhYmxlIjogIkRJU0NIUkciLCAid2QiOiAiNSJ9LCAidHlwZSI6ICJGZWF0dXJlIn0sIHsiYmJveCI6IFstMTA1LjIwOTQxNiwgNDAuMjU2Mjc2LCAtMTA1LjIwOTQxNiwgNDAuMjU2Mjc2XSwgImdlb21ldHJ5IjogeyJjb29yZGluYXRlcyI6IFstMTA1LjIwOTQxNiwgNDAuMjU2Mjc2XSwgInR5cGUiOiAiUG9pbnQifSwgImlkIjogIjMxIiwgInByb3BlcnRpZXMiOiB7ImFtb3VudCI6ICIwLjAwIiwgImNvdW50eSI6ICJCT1VMREVSIiwgImRhdGFfc291cmNlIjogIk5vcnRoZXJuIENvbG9yYWRvIFdhdGVyIENvbnNlcnZhbmN5IERpc3RyaWN0IiwgImRhdGVfdGltZSI6ICIyMDIwLTAzLTMxVDE4OjAwOjAwLjAwMCIsICJkaXYiOiAiMSIsICJkd3JfYWJicmV2IjogIkxJVFRIMUNPIiwgImZsYWciOiBudWxsLCAiaHR0cF9saW5rYWdlLnVybCI6ICJodHRwOi8vd3d3Lm5vcnRoZXJud2F0ZXIub3JnL1dhdGVyUHJvamVjdHMvRWFzdFNsb3BlV2F0ZXJEYXRhLmFzcHgiLCAibG9jYXRpb24ubGF0aXR1ZGUiOiA0MC4yNTYyNzYsICJsb2NhdGlvbi5sb25naXR1ZGUiOiAtMTA1LjIwOTQxNiwgImxvY2F0aW9uLm5lZWRzX3JlY29kaW5nIjogZmFsc2UsICJzdGFnZSI6IG51bGwsICJzdGF0aW9uX25hbWUiOiAiTElUVExFIFRIT01QU09OICMxIERJVENIIiwgInN0YXRpb25fc3RhdHVzIjogIkFjdGl2ZSIsICJzdGF0aW9uX3R5cGUiOiAiRGl2ZXJzaW9uIiwgInVzZ3Nfc3RhdGlvbl9pZCI6ICJFUzE5MDEiLCAidmFyaWFibGUiOiAiRElTQ0hSRyIsICJ3ZCI6ICI0In0sICJ0eXBlIjogIkZlYXR1cmUifSwgeyJiYm94IjogWy0xMDUuMTk4NTY3LCA0MC4yNjA4MjcsIC0xMDUuMTk4NTY3LCA0MC4yNjA4MjddLCAiZ2VvbWV0cnkiOiB7ImNvb3JkaW5hdGVzIjogWy0xMDUuMTk4NTY3LCA0MC4yNjA4MjddLCAidHlwZSI6ICJQb2ludCJ9LCAiaWQiOiAiMzIiLCAicHJvcGVydGllcyI6IHsiYW1vdW50IjogIjAuMDAiLCAiY291bnR5IjogIkJPVUxERVIiLCAiZGF0YV9zb3VyY2UiOiAiQ29vcGVyYXRpdmUgU0RSIFByb2dyYW0gb2YgQ0RXUiBcdTAwMjYgTkNXQ0QiLCAiZGF0ZV90aW1lIjogIjIwMjAtMDMtMzFUMTg6MDA6MDAuMDAwIiwgImRpdiI6ICIxIiwgImR3cl9hYmJyZXYiOiAiQ1VMRElUQ08iLCAiZmxhZyI6IG51bGwsICJodHRwX2xpbmthZ2UudXJsIjogImh0dHBzOi8vZHdyLnN0YXRlLmNvLnVzL1N1cmZhY2VXYXRlci9kYXRhL2RldGFpbF9ncmFwaC5hc3B4P0lEPUNVTERJVENPXHUwMDI2TVRZUEU9RElTQ0hSRyIsICJsb2NhdGlvbi5sYXRpdHVkZSI6IDQwLjI2MDgyNywgImxvY2F0aW9uLmxvbmdpdHVkZSI6IC0xMDUuMTk4NTY3LCAibG9jYXRpb24ubmVlZHNfcmVjb2RpbmciOiBmYWxzZSwgInN0YWdlIjogbnVsbCwgInN0YXRpb25fbmFtZSI6ICJDVUxWRVIgRElUQ0giLCAic3RhdGlvbl9zdGF0dXMiOiAiQWN0aXZlIiwgInN0YXRpb25fdHlwZSI6ICJEaXZlcnNpb24iLCAidXNnc19zdGF0aW9uX2lkIjogbnVsbCwgInZhcmlhYmxlIjogIkRJU0NIUkciLCAid2QiOiAiNCJ9LCAidHlwZSI6ICJGZWF0dXJlIn0sIHsiYmJveCI6IFstMTA1LjI1NjAxNywgNDAuMjE1MDQzLCAtMTA1LjI1NjAxNywgNDAuMjE1MDQzXSwgImdlb21ldHJ5IjogeyJjb29yZGluYXRlcyI6IFstMTA1LjI1NjAxNywgNDAuMjE1MDQzXSwgInR5cGUiOiAiUG9pbnQifSwgImlkIjogIjMzIiwgInByb3BlcnRpZXMiOiB7ImFtb3VudCI6ICIzNS42MCIsICJjb3VudHkiOiAiQk9VTERFUiIsICJkYXRhX3NvdXJjZSI6ICJDby4gRGl2aXNpb24gb2YgV2F0ZXIgUmVzb3VyY2VzIiwgImRhdGVfdGltZSI6ICIyMDIwLTAzLTMxVDE4OjMwOjAwLjAwMCIsICJkaXYiOiAiMSIsICJkd3JfYWJicmV2IjogIkhJR0hMRENPIiwgImZsYWciOiBudWxsLCAiaHR0cF9saW5rYWdlLnVybCI6ICJodHRwczovL2R3ci5zdGF0ZS5jby51cy9TdXJmYWNlV2F0ZXIvZGF0YS9kZXRhaWxfZ3JhcGguYXNweD9JRD1ISUdITERDT1x1MDAyNk1UWVBFPURJU0NIUkciLCAibG9jYXRpb24ubGF0aXR1ZGUiOiA0MC4yMTUwNDMsICJsb2NhdGlvbi5sb25naXR1ZGUiOiAtMTA1LjI1NjAxNywgImxvY2F0aW9uLm5lZWRzX3JlY29kaW5nIjogZmFsc2UsICJzdGFnZSI6ICIwLjY4IiwgInN0YXRpb25fbmFtZSI6ICJISUdITEFORCBESVRDSCBBVCBMWU9OUywgQ08iLCAic3RhdGlvbl9zdGF0dXMiOiAiQWN0aXZlIiwgInN0YXRpb25fdHlwZSI6ICJEaXZlcnNpb24iLCAidXNnc19zdGF0aW9uX2lkIjogbnVsbCwgInZhcmlhYmxlIjogIkRJU0NIUkciLCAid2QiOiAiNSJ9LCAidHlwZSI6ICJGZWF0dXJlIn0sIHsiYmJveCI6IFstMTA1LjIyMDQ5NywgNDAuMDc4NTYsIC0xMDUuMjIwNDk3LCA0MC4wNzg1Nl0sICJnZW9tZXRyeSI6IHsiY29vcmRpbmF0ZXMiOiBbLTEwNS4yMjA0OTcsIDQwLjA3ODU2XSwgInR5cGUiOiAiUG9pbnQifSwgImlkIjogIjM0IiwgInByb3BlcnRpZXMiOiB7ImFtb3VudCI6ICI1MTMyLjUwIiwgImNvdW50eSI6ICJCT1VMREVSIiwgImRhdGFfc291cmNlIjogIk5vcnRoZXJuIENvbG9yYWRvIFdhdGVyIENvbnNlcnZhbmN5IERpc3RyaWN0IiwgImRhdGVfdGltZSI6ICIyMDIwLTAzLTMxVDE4OjAwOjAwLjAwMCIsICJkaXYiOiAiMSIsICJkd3JfYWJicmV2IjogIkJPVVJFU0NPIiwgImZsYWciOiBudWxsLCAiaHR0cF9saW5rYWdlLnVybCI6ICJodHRwOi8vd3d3Lm5vcnRoZXJud2F0ZXIub3JnL1dhdGVyUHJvamVjdHMvRWFzdFNsb3BlV2F0ZXJEYXRhLmFzcHgiLCAibG9jYXRpb24ubGF0aXR1ZGUiOiA0MC4wNzg1NiwgImxvY2F0aW9uLmxvbmdpdHVkZSI6IC0xMDUuMjIwNDk3LCAibG9jYXRpb24ubmVlZHNfcmVjb2RpbmciOiBmYWxzZSwgInN0YWdlIjogbnVsbCwgInN0YXRpb25fbmFtZSI6ICJCT1VMREVSIFJFU0VSVk9JUiIsICJzdGF0aW9uX3N0YXR1cyI6ICJBY3RpdmUiLCAic3RhdGlvbl90eXBlIjogIlJlc2Vydm9pciIsICJ1c2dzX3N0YXRpb25faWQiOiAiRVIxOTE0IiwgInZhcmlhYmxlIjogIlNUT1JBR0UiLCAid2QiOiAiNiJ9LCAidHlwZSI6ICJGZWF0dXJlIn0sIHsiYmJveCI6IFstMTA1LjE2OTM3NCwgNDAuMTczOTUsIC0xMDUuMTY5Mzc0LCA0MC4xNzM5NV0sICJnZW9tZXRyeSI6IHsiY29vcmRpbmF0ZXMiOiBbLTEwNS4xNjkzNzQsIDQwLjE3Mzk1XSwgInR5cGUiOiAiUG9pbnQifSwgImlkIjogIjM1IiwgInByb3BlcnRpZXMiOiB7ImFtb3VudCI6ICIwLjE5IiwgImNvdW50eSI6ICJCT1VMREVSIiwgImRhdGFfc291cmNlIjogIkNvb3BlcmF0aXZlIFByb2dyYW0gb2YgQ0RXUiwgTkNXQ0QgXHUwMDI2IFNWTEhXQ0QiLCAiZGF0ZV90aW1lIjogIjIwMjAtMDMtMzFUMTc6MzA6MDAuMDAwIiwgImRpdiI6ICIxIiwgImR3cl9hYmJyZXYiOiAiTklXRElUQ08iLCAiZmxhZyI6IG51bGwsICJodHRwX2xpbmthZ2UudXJsIjogImh0dHBzOi8vZHdyLnN0YXRlLmNvLnVzL1N1cmZhY2VXYXRlci9kYXRhL2RldGFpbF9ncmFwaC5hc3B4P0lEPU5JV0RJVENPXHUwMDI2TVRZUEU9RElTQ0hSRyIsICJsb2NhdGlvbi5sYXRpdHVkZSI6IDQwLjE3Mzk1LCAibG9jYXRpb24ubG9uZ2l0dWRlIjogLTEwNS4xNjkzNzQsICJsb2NhdGlvbi5uZWVkc19yZWNvZGluZyI6IGZhbHNlLCAic3RhZ2UiOiAiMC4wOSIsICJzdGF0aW9uX25hbWUiOiAiTklXT1QgRElUQ0giLCAic3RhdGlvbl9zdGF0dXMiOiAiQWN0aXZlIiwgInN0YXRpb25fdHlwZSI6ICJEaXZlcnNpb24iLCAidXNnc19zdGF0aW9uX2lkIjogbnVsbCwgInZhcmlhYmxlIjogIkRJU0NIUkciLCAid2QiOiAiNSJ9LCAidHlwZSI6ICJGZWF0dXJlIn0sIHsiYmJveCI6IFstMTA1LjI1MDk1MiwgNDAuMjExMzg5LCAtMTA1LjI1MDk1MiwgNDAuMjExMzg5XSwgImdlb21ldHJ5IjogeyJjb29yZGluYXRlcyI6IFstMTA1LjI1MDk1MiwgNDAuMjExMzg5XSwgInR5cGUiOiAiUG9pbnQifSwgImlkIjogIjM2IiwgInByb3BlcnRpZXMiOiB7ImFtb3VudCI6ICIwLjAwIiwgImNvdW50eSI6ICJCT1VMREVSIiwgImRhdGFfc291cmNlIjogIkNvb3BlcmF0aXZlIFByb2dyYW0gb2YgQ0RXUiwgTkNXQ0QgXHUwMDI2IFNWTEhXQ0QiLCAiZGF0ZV90aW1lIjogIjIwMjAtMDMtMzFUMTc6MDA6MDAuMDAwIiwgImRpdiI6ICIxIiwgImR3cl9hYmJyZXYiOiAiU01FRElUQ08iLCAiZmxhZyI6IG51bGwsICJodHRwX2xpbmthZ2UudXJsIjogImh0dHBzOi8vZHdyLnN0YXRlLmNvLnVzL1N1cmZhY2VXYXRlci9kYXRhL2RldGFpbF9ncmFwaC5hc3B4P0lEPVNNRURJVENPXHUwMDI2TVRZUEU9RElTQ0hSRyIsICJsb2NhdGlvbi5sYXRpdHVkZSI6IDQwLjIxMTM4OSwgImxvY2F0aW9uLmxvbmdpdHVkZSI6IC0xMDUuMjUwOTUyLCAibG9jYXRpb24ubmVlZHNfcmVjb2RpbmciOiBmYWxzZSwgInN0YWdlIjogbnVsbCwgInN0YXRpb25fbmFtZSI6ICJTTUVBRCBESVRDSCIsICJzdGF0aW9uX3N0YXR1cyI6ICJBY3RpdmUiLCAic3RhdGlvbl90eXBlIjogIkRpdmVyc2lvbiIsICJ1c2dzX3N0YXRpb25faWQiOiBudWxsLCAidmFyaWFibGUiOiAiRElTQ0hSRyIsICJ3ZCI6ICI1In0sICJ0eXBlIjogIkZlYXR1cmUifSwgeyJiYm94IjogWy0xMDUuMzQ3OTA2LCAzOS45MzgzNTEsIC0xMDUuMzQ3OTA2LCAzOS45MzgzNTFdLCAiZ2VvbWV0cnkiOiB7ImNvb3JkaW5hdGVzIjogWy0xMDUuMzQ3OTA2LCAzOS45MzgzNTFdLCAidHlwZSI6ICJQb2ludCJ9LCAiaWQiOiAiMzciLCAicHJvcGVydGllcyI6IHsiYW1vdW50IjogIjE2LjQwIiwgImNvdW50eSI6ICJCT1VMREVSIiwgImRhdGFfc291cmNlIjogIkNvLiBEaXZpc2lvbiBvZiBXYXRlciBSZXNvdXJjZXMiLCAiZGF0ZV90aW1lIjogIjIwMjAtMDMtMzFUMTg6MTU6MDAuMDAwIiwgImRpdiI6ICIxIiwgImR3cl9hYmJyZXYiOiAiQk9DQkdSQ08iLCAiZmxhZyI6IG51bGwsICJodHRwX2xpbmthZ2UudXJsIjogImh0dHBzOi8vZHdyLnN0YXRlLmNvLnVzL1N1cmZhY2VXYXRlci9kYXRhL2RldGFpbF9ncmFwaC5hc3B4P0lEPUJPQ0JHUkNPXHUwMDI2TVRZUEU9RElTQ0hSRyIsICJsb2NhdGlvbi5sYXRpdHVkZSI6IDM5LjkzODM1MSwgImxvY2F0aW9uLmxvbmdpdHVkZSI6IC0xMDUuMzQ3OTA2LCAibG9jYXRpb24ubmVlZHNfcmVjb2RpbmciOiBmYWxzZSwgInN0YWdlIjogIjAuMzYiLCAic3RhdGlvbl9uYW1lIjogIlNPVVRIIEJPVUxERVIgQ1JFRUsgQkVMT1cgR1JPU1MgUkVTRVJWT0lSIiwgInN0YXRpb25fc3RhdHVzIjogIkFjdGl2ZSIsICJzdGF0aW9uX3R5cGUiOiAiU3RyZWFtIiwgInVzZ3Nfc3RhdGlvbl9pZCI6ICIwNjcyOTQ1MCIsICJ2YXJpYWJsZSI6ICJESVNDSFJHIiwgIndkIjogIjYifSwgInR5cGUiOiAiRmVhdHVyZSJ9LCB7ImJib3giOiBbLTEwNS4yNTgxMSwgNDAuMjE4MzM1LCAtMTA1LjI1ODExLCA0MC4yMTgzMzVdLCAiZ2VvbWV0cnkiOiB7ImNvb3JkaW5hdGVzIjogWy0xMDUuMjU4MTEsIDQwLjIxODMzNV0sICJ0eXBlIjogIlBvaW50In0sICJpZCI6ICIzOCIsICJwcm9wZXJ0aWVzIjogeyJhbW91bnQiOiAiNTAuMzAiLCAiY291bnR5IjogIkJPVUxERVIiLCAiZGF0YV9zb3VyY2UiOiAiTm9ydGhlcm4gQ29sb3JhZG8gV2F0ZXIgQ29uc2VydmFuY3kgRGlzdHJpY3QgKFN0YXRpb24gQ29vcGVyYXRvcikiLCAiZGF0ZV90aW1lIjogIjIwMjAtMDMtMzFUMTg6MzA6MDAuMDAwIiwgImRpdiI6ICIxIiwgImR3cl9hYmJyZXYiOiAiU1ZTTFlPQ08iLCAiZmxhZyI6IG51bGwsICJodHRwX2xpbmthZ2UudXJsIjogImh0dHBzOi8vZHdyLnN0YXRlLmNvLnVzL1N1cmZhY2VXYXRlci9kYXRhL2RldGFpbF9ncmFwaC5hc3B4P0lEPVNWU0xZT0NPXHUwMDI2TVRZUEU9RElTQ0hSRyIsICJsb2NhdGlvbi5sYXRpdHVkZSI6IDQwLjIxODMzNSwgImxvY2F0aW9uLmxvbmdpdHVkZSI6IC0xMDUuMjU4MTEsICJsb2NhdGlvbi5uZWVkc19yZWNvZGluZyI6IGZhbHNlLCAic3RhZ2UiOiAiMC45NSIsICJzdGF0aW9uX25hbWUiOiAiU0FJTlQgVlJBSU4gU1VQUExZIENBTkFMIE5FQVIgTFlPTlMsIENPIiwgInN0YXRpb25fc3RhdHVzIjogIkFjdGl2ZSIsICJzdGF0aW9uX3R5cGUiOiAiRGl2ZXJzaW9uIiwgInVzZ3Nfc3RhdGlvbl9pZCI6IG51bGwsICJ2YXJpYWJsZSI6ICJESVNDSFJHIiwgIndkIjogIjUifSwgInR5cGUiOiAiRmVhdHVyZSJ9LCB7ImJib3giOiBbLTEwNS4wODg2OTUsIDQwLjE1MzM2MywgLTEwNS4wODg2OTUsIDQwLjE1MzM2M10sICJnZW9tZXRyeSI6IHsiY29vcmRpbmF0ZXMiOiBbLTEwNS4wODg2OTUsIDQwLjE1MzM2M10sICJ0eXBlIjogIlBvaW50In0sICJpZCI6ICIzOSIsICJwcm9wZXJ0aWVzIjogeyJhbW91bnQiOiAiMC4xMCIsICJjb3VudHkiOiAiQk9VTERFUiIsICJkYXRhX3NvdXJjZSI6ICJDb29wZXJhdGl2ZSBQcm9ncmFtIG9mIENEV1IsIE5DV0NEIFx1MDAyNiBTVkxIV0NEIiwgImRhdGVfdGltZSI6ICIyMDIwLTAzLTMxVDE4OjAwOjAwLjAwMCIsICJkaXYiOiAiMSIsICJkd3JfYWJicmV2IjogIkJPTkRJVENPIiwgImZsYWciOiBudWxsLCAiaHR0cF9saW5rYWdlLnVybCI6ICJodHRwczovL2R3ci5zdGF0ZS5jby51cy9TdXJmYWNlV2F0ZXIvZGF0YS9kZXRhaWxfZ3JhcGguYXNweD9JRD1CT05ESVRDT1x1MDAyNk1UWVBFPURJU0NIUkciLCAibG9jYXRpb24ubGF0aXR1ZGUiOiA0MC4xNTMzNjMsICJsb2NhdGlvbi5sb25naXR1ZGUiOiAtMTA1LjA4ODY5NSwgImxvY2F0aW9uLm5lZWRzX3JlY29kaW5nIjogZmFsc2UsICJzdGFnZSI6ICIwLjA0IiwgInN0YXRpb25fbmFtZSI6ICJCT05VUyBESVRDSCIsICJzdGF0aW9uX3N0YXR1cyI6ICJBY3RpdmUiLCAic3RhdGlvbl90eXBlIjogIkRpdmVyc2lvbiIsICJ1c2dzX3N0YXRpb25faWQiOiBudWxsLCAidmFyaWFibGUiOiAiRElTQ0hSRyIsICJ3ZCI6ICI1In0sICJ0eXBlIjogIkZlYXR1cmUifSwgeyJiYm94IjogWy0xMDUuNTA0NDQsIDM5Ljk2MTY1NSwgLTEwNS41MDQ0NCwgMzkuOTYxNjU1XSwgImdlb21ldHJ5IjogeyJjb29yZGluYXRlcyI6IFstMTA1LjUwNDQ0LCAzOS45NjE2NTVdLCAidHlwZSI6ICJQb2ludCJ9LCAiaWQiOiAiNDAiLCAicHJvcGVydGllcyI6IHsiYW1vdW50IjogIjI1LjIwIiwgImNvdW50eSI6ICJCT1VMREVSIiwgImRhdGFfc291cmNlIjogIkNvLiBEaXZpc2lvbiBvZiBXYXRlciBSZXNvdXJjZXMiLCAiZGF0ZV90aW1lIjogIjIwMjAtMDMtMzFUMTg6MTU6MDAuMDAwIiwgImRpdiI6ICIxIiwgImR3cl9hYmJyZXYiOiAiQk9DTUlEQ08iLCAiZmxhZyI6ICJJY2UiLCAiaHR0cF9saW5rYWdlLnVybCI6ICJodHRwczovL2R3ci5zdGF0ZS5jby51cy9TdXJmYWNlV2F0ZXIvZGF0YS9kZXRhaWxfZ3JhcGguYXNweD9JRD1CT0NNSURDT1x1MDAyNk1UWVBFPURJU0NIUkciLCAibG9jYXRpb24ubGF0aXR1ZGUiOiAzOS45NjE2NTUsICJsb2NhdGlvbi5sb25naXR1ZGUiOiAtMTA1LjUwNDQ0LCAibG9jYXRpb24ubmVlZHNfcmVjb2RpbmciOiBmYWxzZSwgInN0YWdlIjogIjEuMTUiLCAic3RhdGlvbl9uYW1lIjogIk1JRERMRSBCT1VMREVSIENSRUVLIEFUIE5FREVSTEFORCwgQ08uIiwgInN0YXRpb25fc3RhdHVzIjogIkFjdGl2ZSIsICJzdGF0aW9uX3R5cGUiOiAiU3RyZWFtIiwgInVzZ3Nfc3RhdGlvbl9pZCI6ICIwNjcyNTUwMCIsICJ2YXJpYWJsZSI6ICJESVNDSFJHIiwgIndkIjogIjYifSwgInR5cGUiOiAiRmVhdHVyZSJ9LCB7ImJib3giOiBbLTEwNS4yNTA5MjcsIDQwLjIxMTA4MywgLTEwNS4yNTA5MjcsIDQwLjIxMTA4M10sICJnZW9tZXRyeSI6IHsiY29vcmRpbmF0ZXMiOiBbLTEwNS4yNTA5MjcsIDQwLjIxMTA4M10sICJ0eXBlIjogIlBvaW50In0sICJpZCI6ICI0MSIsICJwcm9wZXJ0aWVzIjogeyJhbW91bnQiOiAiMC4wMCIsICJjb3VudHkiOiAiQk9VTERFUiIsICJkYXRhX3NvdXJjZSI6ICJDb29wZXJhdGl2ZSBQcm9ncmFtIG9mIENEV1IsIE5DV0NEIFx1MDAyNiBTVkxIV0NEIiwgImRhdGVfdGltZSI6ICIyMDIwLTAzLTMxVDE3OjAwOjAwLjAwMCIsICJkaXYiOiAiMSIsICJkd3JfYWJicmV2IjogIlNXRURJVENPIiwgImZsYWciOiBudWxsLCAiaHR0cF9saW5rYWdlLnVybCI6ICJodHRwczovL2R3ci5zdGF0ZS5jby51cy9TdXJmYWNlV2F0ZXIvZGF0YS9kZXRhaWxfZ3JhcGguYXNweD9JRD1TV0VESVRDT1x1MDAyNk1UWVBFPURJU0NIUkciLCAibG9jYXRpb24ubGF0aXR1ZGUiOiA0MC4yMTEwODMsICJsb2NhdGlvbi5sb25naXR1ZGUiOiAtMTA1LjI1MDkyNywgImxvY2F0aW9uLm5lZWRzX3JlY29kaW5nIjogZmFsc2UsICJzdGFnZSI6ICItMC4wNiIsICJzdGF0aW9uX25hbWUiOiAiU1dFREUgRElUQ0giLCAic3RhdGlvbl9zdGF0dXMiOiAiQWN0aXZlIiwgInN0YXRpb25fdHlwZSI6ICJEaXZlcnNpb24iLCAidXNnc19zdGF0aW9uX2lkIjogbnVsbCwgInZhcmlhYmxlIjogIkRJU0NIUkciLCAid2QiOiAiNSJ9LCAidHlwZSI6ICJGZWF0dXJlIn0sIHsiYmJveCI6IFstMTA1LjE4OTEzMiwgNDAuMTg3NTI0LCAtMTA1LjE4OTEzMiwgNDAuMTg3NTI0XSwgImdlb21ldHJ5IjogeyJjb29yZGluYXRlcyI6IFstMTA1LjE4OTEzMiwgNDAuMTg3NTI0XSwgInR5cGUiOiAiUG9pbnQifSwgImlkIjogIjQyIiwgInByb3BlcnRpZXMiOiB7ImFtb3VudCI6ICIwLjAwIiwgImNvdW50eSI6ICJCT1VMREVSIiwgImRhdGFfc291cmNlIjogIkNvb3BlcmF0aXZlIFByb2dyYW0gb2YgQ0RXUiwgTkNXQ0QgXHUwMDI2IFNWTEhXQ0QiLCAiZGF0ZV90aW1lIjogIjIwMjAtMDMtMzFUMTg6MDA6MDAuMDAwIiwgImRpdiI6ICIxIiwgImR3cl9hYmJyZXYiOiAiUlVOWU9OQ08iLCAiZmxhZyI6IG51bGwsICJodHRwX2xpbmthZ2UudXJsIjogImh0dHBzOi8vZHdyLnN0YXRlLmNvLnVzL1N1cmZhY2VXYXRlci9kYXRhL2RldGFpbF9ncmFwaC5hc3B4P0lEPVJVTllPTkNPXHUwMDI2TVRZUEU9RElTQ0hSRyIsICJsb2NhdGlvbi5sYXRpdHVkZSI6IDQwLjE4NzUyNCwgImxvY2F0aW9uLmxvbmdpdHVkZSI6IC0xMDUuMTg5MTMyLCAibG9jYXRpb24ubmVlZHNfcmVjb2RpbmciOiBmYWxzZSwgInN0YWdlIjogIjUwLjc4IiwgInN0YXRpb25fbmFtZSI6ICJSVU5ZT04gRElUQ0giLCAic3RhdGlvbl9zdGF0dXMiOiAiQWN0aXZlIiwgInN0YXRpb25fdHlwZSI6ICJEaXZlcnNpb24iLCAidXNnc19zdGF0aW9uX2lkIjogbnVsbCwgInZhcmlhYmxlIjogIkRJU0NIUkciLCAid2QiOiAiNSJ9LCAidHlwZSI6ICJGZWF0dXJlIn0sIHsiYmJveCI6IFstMTA1LjE5Njc3NSwgNDAuMTgxODgsIC0xMDUuMTk2Nzc1LCA0MC4xODE4OF0sICJnZW9tZXRyeSI6IHsiY29vcmRpbmF0ZXMiOiBbLTEwNS4xOTY3NzUsIDQwLjE4MTg4XSwgInR5cGUiOiAiUG9pbnQifSwgImlkIjogIjQzIiwgInByb3BlcnRpZXMiOiB7ImFtb3VudCI6ICIwLjAwIiwgImNvdW50eSI6ICJCT1VMREVSIiwgImRhdGFfc291cmNlIjogIkNvb3BlcmF0aXZlIFByb2dyYW0gb2YgQ0RXUiwgTkNXQ0QgXHUwMDI2IFNWTEhXQ0QiLCAiZGF0ZV90aW1lIjogIjIwMjAtMDMtMzFUMTc6NDU6MDAuMDAwIiwgImRpdiI6ICIxIiwgImR3cl9hYmJyZXYiOiAiREFWRE9XQ08iLCAiZmxhZyI6IG51bGwsICJodHRwX2xpbmthZ2UudXJsIjogImh0dHBzOi8vZHdyLnN0YXRlLmNvLnVzL1N1cmZhY2VXYXRlci9kYXRhL2RldGFpbF9ncmFwaC5hc3B4P0lEPURBVkRPV0NPXHUwMDI2TVRZUEU9RElTQ0hSRyIsICJsb2NhdGlvbi5sYXRpdHVkZSI6IDQwLjE4MTg4LCAibG9jYXRpb24ubG9uZ2l0dWRlIjogLTEwNS4xOTY3NzUsICJsb2NhdGlvbi5uZWVkc19yZWNvZGluZyI6IGZhbHNlLCAic3RhZ2UiOiBudWxsLCAic3RhdGlvbl9uYW1lIjogIkRBVklTIEFORCBET1dOSU5HIERJVENIIiwgInN0YXRpb25fc3RhdHVzIjogIkFjdGl2ZSIsICJzdGF0aW9uX3R5cGUiOiAiRGl2ZXJzaW9uIiwgInVzZ3Nfc3RhdGlvbl9pZCI6IG51bGwsICJ2YXJpYWJsZSI6ICJESVNDSFJHIiwgIndkIjogIjUifSwgInR5cGUiOiAiRmVhdHVyZSJ9LCB7ImJib3giOiBbLTEwNS4zMjYyNSwgNDAuMDE4NjY3LCAtMTA1LjMyNjI1LCA0MC4wMTg2NjddLCAiZ2VvbWV0cnkiOiB7ImNvb3JkaW5hdGVzIjogWy0xMDUuMzI2MjUsIDQwLjAxODY2N10sICJ0eXBlIjogIlBvaW50In0sICJpZCI6ICI0NCIsICJwcm9wZXJ0aWVzIjogeyJhbW91bnQiOiAiMC43NCIsICJjb3VudHkiOiAiQk9VTERFUiIsICJkYXRhX3NvdXJjZSI6ICJVLlMuIEdlb2xvZ2ljYWwgU3VydmV5IiwgImRhdGVfdGltZSI6ICIyMDE5LTEwLTAyVDE0OjUwOjAwLjAwMCIsICJkaXYiOiAiMSIsICJkd3JfYWJicmV2IjogIkZPVU9ST0NPIiwgImZsYWciOiBudWxsLCAiaHR0cF9saW5rYWdlLnVybCI6ICJodHRwczovL3dhdGVyZGF0YS51c2dzLmdvdi9ud2lzL3V2PzA2NzI3NTAwIiwgImxvY2F0aW9uLmxhdGl0dWRlIjogNDAuMDE4NjY3LCAibG9jYXRpb24ubG9uZ2l0dWRlIjogLTEwNS4zMjYyNSwgImxvY2F0aW9uLm5lZWRzX3JlY29kaW5nIjogZmFsc2UsICJzdGFnZSI6IG51bGwsICJzdGF0aW9uX25hbWUiOiAiRk9VUk1JTEUgQ1JFRUsgQVQgT1JPREVMTCwgQ08iLCAic3RhdGlvbl9zdGF0dXMiOiAiQWN0aXZlIiwgInN0YXRpb25fdHlwZSI6ICJTdHJlYW0iLCAidXNnc19zdGF0aW9uX2lkIjogIjA2NzI3NTAwIiwgInZhcmlhYmxlIjogIkRJU0NIUkciLCAid2QiOiAiNiJ9LCAidHlwZSI6ICJGZWF0dXJlIn0sIHsiYmJveCI6IFstMTA1LjIwOTI4MiwgNDAuMTg4NTc5LCAtMTA1LjIwOTI4MiwgNDAuMTg4NTc5XSwgImdlb21ldHJ5IjogeyJjb29yZGluYXRlcyI6IFstMTA1LjIwOTI4MiwgNDAuMTg4NTc5XSwgInR5cGUiOiAiUG9pbnQifSwgImlkIjogIjQ1IiwgInByb3BlcnRpZXMiOiB7ImFtb3VudCI6ICIwLjAwIiwgImNvdW50eSI6ICJCT1VMREVSIiwgImRhdGFfc291cmNlIjogIkNvb3BlcmF0aXZlIFByb2dyYW0gb2YgQ0RXUiwgTkNXQ0QgXHUwMDI2IFNWTEhXQ0QiLCAiZGF0ZV90aW1lIjogIjIwMjAtMDMtMzFUMTc6NDU6MDAuMDAwIiwgImRpdiI6ICIxIiwgImR3cl9hYmJyZXYiOiAiSkFNRElUQ08iLCAiZmxhZyI6IG51bGwsICJodHRwX2xpbmthZ2UudXJsIjogImh0dHBzOi8vZHdyLnN0YXRlLmNvLnVzL1N1cmZhY2VXYXRlci9kYXRhL2RldGFpbF9ncmFwaC5hc3B4P0lEPUpBTURJVENPXHUwMDI2TVRZUEU9RElTQ0hSRyIsICJsb2NhdGlvbi5sYXRpdHVkZSI6IDQwLjE4ODU3OSwgImxvY2F0aW9uLmxvbmdpdHVkZSI6IC0xMDUuMjA5MjgyLCAibG9jYXRpb24ubmVlZHNfcmVjb2RpbmciOiBmYWxzZSwgInN0YWdlIjogbnVsbCwgInN0YXRpb25fbmFtZSI6ICJKQU1FUyBESVRDSCIsICJzdGF0aW9uX3N0YXR1cyI6ICJBY3RpdmUiLCAic3RhdGlvbl90eXBlIjogIkRpdmVyc2lvbiIsICJ1c2dzX3N0YXRpb25faWQiOiBudWxsLCAidmFyaWFibGUiOiAiRElTQ0hSRyIsICJ3ZCI6ICI1In0sICJ0eXBlIjogIkZlYXR1cmUifSwgeyJiYm94IjogWy0xMDUuMTkzMDQ4LCA0MC4wNTMwMzUsIC0xMDUuMTkzMDQ4LCA0MC4wNTMwMzVdLCAiZ2VvbWV0cnkiOiB7ImNvb3JkaW5hdGVzIjogWy0xMDUuMTkzMDQ4LCA0MC4wNTMwMzVdLCAidHlwZSI6ICJQb2ludCJ9LCAiaWQiOiAiNDYiLCAicHJvcGVydGllcyI6IHsiYW1vdW50IjogIjQuNjIiLCAiY291bnR5IjogIkJPVUxERVIiLCAiZGF0YV9zb3VyY2UiOiAiTm9ydGhlcm4gQ29sb3JhZG8gV2F0ZXIgQ29uc2VydmFuY3kgRGlzdHJpY3QiLCAiZGF0ZV90aW1lIjogIjIwMjAtMDMtMzFUMTg6MDA6MDAuMDAwIiwgImRpdiI6ICIxIiwgImR3cl9hYmJyZXYiOiAiQkNTQ0JDQ08iLCAiZmxhZyI6IG51bGwsICJodHRwX2xpbmthZ2UudXJsIjogImh0dHA6Ly93d3cubm9ydGhlcm53YXRlci5vcmcvV2F0ZXJQcm9qZWN0cy9FYXN0U2xvcGVXYXRlckRhdGEuYXNweCIsICJsb2NhdGlvbi5sYXRpdHVkZSI6IDQwLjA1MzAzNSwgImxvY2F0aW9uLmxvbmdpdHVkZSI6IC0xMDUuMTkzMDQ4LCAibG9jYXRpb24ubmVlZHNfcmVjb2RpbmciOiBmYWxzZSwgInN0YWdlIjogIjAuMjYiLCAic3RhdGlvbl9uYW1lIjogIkJPVUxERVIgQ1JFRUsgU1VQUExZIENBTkFMIFRPIEJPVUxERVIgQ1JFRUsgTkVBUiBCT1VMREVSIiwgInN0YXRpb25fc3RhdHVzIjogIkFjdGl2ZSIsICJzdGF0aW9uX3R5cGUiOiAiRGl2ZXJzaW9uIiwgInVzZ3Nfc3RhdGlvbl9pZCI6ICJFUzE5MTciLCAidmFyaWFibGUiOiAiRElTQ0hSRyIsICJ3ZCI6ICI2In0sICJ0eXBlIjogIkZlYXR1cmUifSwgeyJiYm94IjogWy0xMDUuMTc4MTQ1LCA0MC4xNzc0MjMsIC0xMDUuMTc4MTQ1LCA0MC4xNzc0MjNdLCAiZ2VvbWV0cnkiOiB7ImNvb3JkaW5hdGVzIjogWy0xMDUuMTc4MTQ1LCA0MC4xNzc0MjNdLCAidHlwZSI6ICJQb2ludCJ9LCAiaWQiOiAiNDciLCAicHJvcGVydGllcyI6IHsiYW1vdW50IjogIjIuMTQiLCAiY291bnR5IjogIkJPVUxERVIiLCAiZGF0YV9zb3VyY2UiOiAiQ28uIERpdmlzaW9uIG9mIFdhdGVyIFJlc291cmNlcyIsICJkYXRlX3RpbWUiOiAiMjAyMC0wMy0zMVQxNzo0NTowMC4wMDAiLCAiZGl2IjogIjEiLCAiZHdyX2FiYnJldiI6ICJTVkNIR0lDTyIsICJmbGFnIjogbnVsbCwgImh0dHBfbGlua2FnZS51cmwiOiAiaHR0cHM6Ly9kd3Iuc3RhdGUuY28udXMvU3VyZmFjZVdhdGVyL2RhdGEvZGV0YWlsX2dyYXBoLmFzcHg/SUQ9U1ZDSEdJQ09cdTAwMjZNVFlQRT1ESVNDSFJHIiwgImxvY2F0aW9uLmxhdGl0dWRlIjogNDAuMTc3NDIzLCAibG9jYXRpb24ubG9uZ2l0dWRlIjogLTEwNS4xNzgxNDUsICJsb2NhdGlvbi5uZWVkc19yZWNvZGluZyI6IGZhbHNlLCAic3RhZ2UiOiAiMS40OSIsICJzdGF0aW9uX25hbWUiOiAiU0FJTlQgVlJBSU4gQ1JFRUsgQVQgSFlHSUVORSwgQ08iLCAic3RhdGlvbl9zdGF0dXMiOiAiQWN0aXZlIiwgInN0YXRpb25fdHlwZSI6ICJTdHJlYW0iLCAidXNnc19zdGF0aW9uX2lkIjogbnVsbCwgInZhcmlhYmxlIjogIkRJU0NIUkciLCAid2QiOiAiNSJ9LCAidHlwZSI6ICJGZWF0dXJlIn0sIHsiYmJveCI6IFstMTA1LjE3NDk1NywgNDAuMjU4MzY3LCAtMTA1LjE3NDk1NywgNDAuMjU4MzY3XSwgImdlb21ldHJ5IjogeyJjb29yZGluYXRlcyI6IFstMTA1LjE3NDk1NywgNDAuMjU4MzY3XSwgInR5cGUiOiAiUG9pbnQifSwgImlkIjogIjQ4IiwgInByb3BlcnRpZXMiOiB7ImFtb3VudCI6ICIwLjAwIiwgImNvdW50eSI6ICJCT1VMREVSIiwgImRhdGFfc291cmNlIjogIkNvLiBEaXZpc2lvbiBvZiBXYXRlciBSZXNvdXJjZXMiLCAiZGF0ZV90aW1lIjogIjIwMjAtMDMtMzFUMTg6MzA6MDAuMDAwIiwgImRpdiI6ICIxIiwgImR3cl9hYmJyZXYiOiAiQk9VTEFSQ08iLCAiZmxhZyI6IG51bGwsICJodHRwX2xpbmthZ2UudXJsIjogImh0dHBzOi8vZHdyLnN0YXRlLmNvLnVzL1N1cmZhY2VXYXRlci9kYXRhL2RldGFpbF9ncmFwaC5hc3B4P0lEPUJPVUxBUkNPXHUwMDI2TVRZUEU9RElTQ0hSRyIsICJsb2NhdGlvbi5sYXRpdHVkZSI6IDQwLjI1ODM2NywgImxvY2F0aW9uLmxvbmdpdHVkZSI6IC0xMDUuMTc0OTU3LCAibG9jYXRpb24ubmVlZHNfcmVjb2RpbmciOiBmYWxzZSwgInN0YWdlIjogIi0wLjEzIiwgInN0YXRpb25fbmFtZSI6ICJCT1VMREVSLUxBUklNRVIgRElUQ0ggTkVBUiBCRVJUSE9VRCIsICJzdGF0aW9uX3N0YXR1cyI6ICJBY3RpdmUiLCAic3RhdGlvbl90eXBlIjogIkRpdmVyc2lvbiIsICJ1c2dzX3N0YXRpb25faWQiOiBudWxsLCAidmFyaWFibGUiOiAiRElTQ0hSRyIsICJ3ZCI6ICI0In0sICJ0eXBlIjogIkZlYXR1cmUifSwgeyJiYm94IjogWy0xMDUuMDkxMDU5LCA0MC4wOTYwMywgLTEwNS4wOTEwNTksIDQwLjA5NjAzXSwgImdlb21ldHJ5IjogeyJjb29yZGluYXRlcyI6IFstMTA1LjA5MTA1OSwgNDAuMDk2MDNdLCAidHlwZSI6ICJQb2ludCJ9LCAiaWQiOiAiNDkiLCAicHJvcGVydGllcyI6IHsiYW1vdW50IjogIjIyLjEwIiwgImNvdW50eSI6ICJCT1VMREVSIiwgImRhdGFfc291cmNlIjogIkNvLiBEaXZpc2lvbiBvZiBXYXRlciBSZXNvdXJjZXMiLCAiZGF0ZV90aW1lIjogIjIwMjAtMDMtMzFUMTc6NDU6MDAuMDAwIiwgImRpdiI6ICIxIiwgImR3cl9hYmJyZXYiOiAiUE5NQUlOQ08iLCAiZmxhZyI6IG51bGwsICJodHRwX2xpbmthZ2UudXJsIjogImh0dHBzOi8vZHdyLnN0YXRlLmNvLnVzL1N1cmZhY2VXYXRlci9kYXRhL2RldGFpbF9ncmFwaC5hc3B4P0lEPVBOTUFJTkNPXHUwMDI2TVRZUEU9RElTQ0hSRyIsICJsb2NhdGlvbi5sYXRpdHVkZSI6IDQwLjA5NjAzLCAibG9jYXRpb24ubG9uZ2l0dWRlIjogLTEwNS4wOTEwNTksICJsb2NhdGlvbi5uZWVkc19yZWNvZGluZyI6IGZhbHNlLCAic3RhZ2UiOiBudWxsLCAic3RhdGlvbl9uYW1lIjogIlBBTkFNQSBSRVNFUlZPSVIgSU5MRVQiLCAic3RhdGlvbl9zdGF0dXMiOiAiQWN0aXZlIiwgInN0YXRpb25fdHlwZSI6ICJTdHJlYW0iLCAidXNnc19zdGF0aW9uX2lkIjogbnVsbCwgInZhcmlhYmxlIjogIkRJU0NIUkciLCAid2QiOiAiNiJ9LCAidHlwZSI6ICJGZWF0dXJlIn0sIHsiYmJveCI6IFstMTA1LjI1MTgyNiwgNDAuMjEyNTA1LCAtMTA1LjI1MTgyNiwgNDAuMjEyNTA1XSwgImdlb21ldHJ5IjogeyJjb29yZGluYXRlcyI6IFstMTA1LjI1MTgyNiwgNDAuMjEyNTA1XSwgInR5cGUiOiAiUG9pbnQifSwgImlkIjogIjUwIiwgInByb3BlcnRpZXMiOiB7ImFtb3VudCI6ICIwLjI3IiwgImNvdW50eSI6ICJCT1VMREVSIiwgImRhdGFfc291cmNlIjogIkNvb3BlcmF0aXZlIFByb2dyYW0gb2YgQ0RXUiwgTkNXQ0QgXHUwMDI2IFNWTEhXQ0QiLCAiZGF0ZV90aW1lIjogIjIwMjAtMDMtMzFUMTg6MDA6MDAuMDAwIiwgImRpdiI6ICIxIiwgImR3cl9hYmJyZXYiOiAiUEFMRElUQ08iLCAiZmxhZyI6IG51bGwsICJodHRwX2xpbmthZ2UudXJsIjogImh0dHBzOi8vZHdyLnN0YXRlLmNvLnVzL1N1cmZhY2VXYXRlci9kYXRhL2RldGFpbF9ncmFwaC5hc3B4P0lEPVBBTERJVENPXHUwMDI2TVRZUEU9RElTQ0hSRyIsICJsb2NhdGlvbi5sYXRpdHVkZSI6IDQwLjIxMjUwNSwgImxvY2F0aW9uLmxvbmdpdHVkZSI6IC0xMDUuMjUxODI2LCAibG9jYXRpb24ubmVlZHNfcmVjb2RpbmciOiBmYWxzZSwgInN0YWdlIjogIjAuMDUiLCAic3RhdGlvbl9uYW1lIjogIlBBTE1FUlRPTiBESVRDSCIsICJzdGF0aW9uX3N0YXR1cyI6ICJBY3RpdmUiLCAic3RhdGlvbl90eXBlIjogIkRpdmVyc2lvbiIsICJ1c2dzX3N0YXRpb25faWQiOiBudWxsLCAidmFyaWFibGUiOiAiRElTQ0hSRyIsICJ3ZCI6ICI1In0sICJ0eXBlIjogIkZlYXR1cmUifSwgeyJiYm94IjogWy0xMDUuMjU5Nzk1LCA0MC4yMTkwNDYsIC0xMDUuMjU5Nzk1LCA0MC4yMTkwNDZdLCAiZ2VvbWV0cnkiOiB7ImNvb3JkaW5hdGVzIjogWy0xMDUuMjU5Nzk1LCA0MC4yMTkwNDZdLCAidHlwZSI6ICJQb2ludCJ9LCAiaWQiOiAiNTEiLCAicHJvcGVydGllcyI6IHsiYW1vdW50IjogIjAuMDAiLCAiY291bnR5IjogIkJPVUxERVIiLCAiZGF0YV9zb3VyY2UiOiAiQ29vcGVyYXRpdmUgUHJvZ3JhbSBvZiBDRFdSLCBOQ1dDRCBcdTAwMjYgU1ZMSFdDRCIsICJkYXRlX3RpbWUiOiAiMjAyMC0wMy0zMVQxNzo0NTowMC4wMDAiLCAiZGl2IjogIjEiLCAiZHdyX2FiYnJldiI6ICJTVVBESVRDTyIsICJmbGFnIjogbnVsbCwgImh0dHBfbGlua2FnZS51cmwiOiAiaHR0cHM6Ly9kd3Iuc3RhdGUuY28udXMvU3VyZmFjZVdhdGVyL2RhdGEvZGV0YWlsX2dyYXBoLmFzcHg/SUQ9U1VQRElUQ09cdTAwMjZNVFlQRT1ESVNDSFJHIiwgImxvY2F0aW9uLmxhdGl0dWRlIjogNDAuMjE5MDQ2LCAibG9jYXRpb24ubG9uZ2l0dWRlIjogLTEwNS4yNTk3OTUsICJsb2NhdGlvbi5uZWVkc19yZWNvZGluZyI6IGZhbHNlLCAic3RhZ2UiOiAiMC4wMCIsICJzdGF0aW9uX25hbWUiOiAiU1VQUExZIERJVENIIiwgInN0YXRpb25fc3RhdHVzIjogIkFjdGl2ZSIsICJzdGF0aW9uX3R5cGUiOiAiRGl2ZXJzaW9uIiwgInVzZ3Nfc3RhdGlvbl9pZCI6IG51bGwsICJ2YXJpYWJsZSI6ICJESVNDSFJHIiwgIndkIjogIjUifSwgInR5cGUiOiAiRmVhdHVyZSJ9LCB7ImJib3giOiBbLTEwNS4zMDg0MzIsIDM5LjkzMTgxMywgLTEwNS4zMDg0MzIsIDM5LjkzMTgxM10sICJnZW9tZXRyeSI6IHsiY29vcmRpbmF0ZXMiOiBbLTEwNS4zMDg0MzIsIDM5LjkzMTgxM10sICJ0eXBlIjogIlBvaW50In0sICJpZCI6ICI1MiIsICJwcm9wZXJ0aWVzIjogeyJhbW91bnQiOiAiMC4wMCIsICJjb3VudHkiOiAiQk9VTERFUiIsICJkYXRhX3NvdXJjZSI6ICJDby4gRGl2aXNpb24gb2YgV2F0ZXIgUmVzb3VyY2VzIiwgImRhdGVfdGltZSI6ICIyMDIwLTAzLTMxVDE4OjMwOjAwLjAwMCIsICJkaXYiOiAiMSIsICJkd3JfYWJicmV2IjogIkJPU0RFTENPIiwgImZsYWciOiBudWxsLCAiaHR0cF9saW5rYWdlLnVybCI6ICJodHRwczovL2R3ci5zdGF0ZS5jby51cy9TdXJmYWNlV2F0ZXIvZGF0YS9kZXRhaWxfZ3JhcGguYXNweD9JRD1CT1NERUxDT1x1MDAyNk1UWVBFPURJU0NIUkciLCAibG9jYXRpb24ubGF0aXR1ZGUiOiAzOS45MzE4MTMsICJsb2NhdGlvbi5sb25naXR1ZGUiOiAtMTA1LjMwODQzMiwgImxvY2F0aW9uLm5lZWRzX3JlY29kaW5nIjogZmFsc2UsICJzdGFnZSI6ICItMS43MCIsICJzdGF0aW9uX25hbWUiOiAiU09VVEggQk9VTERFUiBDUkVFSyBESVZFUlNJT04gTkVBUiBFTERPUkFETyBTUFJJTkdTIiwgInN0YXRpb25fc3RhdHVzIjogIkFjdGl2ZSIsICJzdGF0aW9uX3R5cGUiOiAiRGl2ZXJzaW9uIiwgInVzZ3Nfc3RhdGlvbl9pZCI6IG51bGwsICJ2YXJpYWJsZSI6ICJESVNDSFJHIiwgIndkIjogIjYifSwgInR5cGUiOiAiRmVhdHVyZSJ9LCB7ImJib3giOiBbLTEwNS4xODkxOTEsIDQwLjE4NzU3OCwgLTEwNS4xODkxOTEsIDQwLjE4NzU3OF0sICJnZW9tZXRyeSI6IHsiY29vcmRpbmF0ZXMiOiBbLTEwNS4xODkxOTEsIDQwLjE4NzU3OF0sICJ0eXBlIjogIlBvaW50In0sICJpZCI6ICI1MyIsICJwcm9wZXJ0aWVzIjogeyJhbW91bnQiOiAiMjgxOS4wMCIsICJjb3VudHkiOiAiQk9VTERFUiIsICJkYXRhX3NvdXJjZSI6ICJDb29wZXJhdGl2ZSBQcm9ncmFtIG9mIENEV1IsIE5DV0NEIFx1MDAyNiBTVkxIV0NEIiwgImRhdGVfdGltZSI6ICIyMDIwLTAzLTMxVDE4OjAwOjAwLjAwMCIsICJkaXYiOiAiMSIsICJkd3JfYWJicmV2IjogIkRFTlRBWUNPIiwgImZsYWciOiBudWxsLCAiaHR0cF9saW5rYWdlLnVybCI6ICJodHRwczovL2R3ci5zdGF0ZS5jby51cy9TdXJmYWNlV2F0ZXIvZGF0YS9kZXRhaWxfZ3JhcGguYXNweD9JRD1ERU5UQVlDT1x1MDAyNk1UWVBFPURJU0NIUkciLCAibG9jYXRpb24ubGF0aXR1ZGUiOiA0MC4xODc1NzgsICJsb2NhdGlvbi5sb25naXR1ZGUiOiAtMTA1LjE4OTE5MSwgImxvY2F0aW9uLm5lZWRzX3JlY29kaW5nIjogZmFsc2UsICJzdGFnZSI6ICI2Mi4zMCIsICJzdGF0aW9uX25hbWUiOiAiREVOSU8gVEFZTE9SIERJVENIIiwgInN0YXRpb25fc3RhdHVzIjogIkFjdGl2ZSIsICJzdGF0aW9uX3R5cGUiOiAiRGl2ZXJzaW9uIiwgInVzZ3Nfc3RhdGlvbl9pZCI6IG51bGwsICJ2YXJpYWJsZSI6ICJESVNDSFJHIiwgIndkIjogIjUifSwgInR5cGUiOiAiRmVhdHVyZSJ9LCB7ImJib3giOiBbLTEwNS4zNjQ5MTcsIDQwLjA0MjAyOCwgLTEwNS4zNjQ5MTcsIDQwLjA0MjAyOF0sICJnZW9tZXRyeSI6IHsiY29vcmRpbmF0ZXMiOiBbLTEwNS4zNjQ5MTcsIDQwLjA0MjAyOF0sICJ0eXBlIjogIlBvaW50In0sICJpZCI6ICI1NCIsICJwcm9wZXJ0aWVzIjogeyJhbW91bnQiOiBudWxsLCAiY291bnR5IjogIkJPVUxERVIiLCAiZGF0YV9zb3VyY2UiOiAiVS5TLiBHZW9sb2dpY2FsIFN1cnZleSIsICJkYXRlX3RpbWUiOiAiMTk5OS0wOS0zMFQwMDowMDowMC4wMDAiLCAiZGl2IjogIjEiLCAiZHdyX2FiYnJldiI6ICJGUk1MTVJDTyIsICJmbGFnIjogbnVsbCwgImh0dHBfbGlua2FnZS51cmwiOiAiaHR0cHM6Ly93YXRlcmRhdGEudXNncy5nb3Yvbndpcy91dj8wNjcyNzQxMCIsICJsb2NhdGlvbi5sYXRpdHVkZSI6IDQwLjA0MjAyOCwgImxvY2F0aW9uLmxvbmdpdHVkZSI6IC0xMDUuMzY0OTE3LCAibG9jYXRpb24ubmVlZHNfcmVjb2RpbmciOiBmYWxzZSwgInN0YWdlIjogbnVsbCwgInN0YXRpb25fbmFtZSI6ICJGT1VSTUlMRSBDUkVFSyBBVCBMT0dBTiBNSUxMIFJPQUQgTkVBUiBDUklTTUFOLCBDTyIsICJzdGF0aW9uX3N0YXR1cyI6ICJBY3RpdmUiLCAic3RhdGlvbl90eXBlIjogIlN0cmVhbSIsICJ1c2dzX3N0YXRpb25faWQiOiAiMDY3Mjc0MTAiLCAidmFyaWFibGUiOiAiRElTQ0hSRyIsICJ3ZCI6ICI2In0sICJ0eXBlIjogIkZlYXR1cmUifSwgeyJiYm94IjogWy0xMDUuMTc4NTY3LCA0MC4xNzcwOCwgLTEwNS4xNzg1NjcsIDQwLjE3NzA4XSwgImdlb21ldHJ5IjogeyJjb29yZGluYXRlcyI6IFstMTA1LjE3ODU2NywgNDAuMTc3MDhdLCAidHlwZSI6ICJQb2ludCJ9LCAiaWQiOiAiNTUiLCAicHJvcGVydGllcyI6IHsiYW1vdW50IjogIjEuMjkiLCAiY291bnR5IjogIkJPVUxERVIiLCAiZGF0YV9zb3VyY2UiOiAiQ29vcGVyYXRpdmUgU0RSIFByb2dyYW0gb2YgQ0RXUiBcdTAwMjYgTkNXQ0QiLCAiZGF0ZV90aW1lIjogIjIwMjAtMDMtMzFUMTg6MDA6MDAuMDAwIiwgImRpdiI6ICIxIiwgImR3cl9hYmJyZXYiOiAiUENLUEVMQ08iLCAiZmxhZyI6IG51bGwsICJodHRwX2xpbmthZ2UudXJsIjogImh0dHBzOi8vZHdyLnN0YXRlLmNvLnVzL1N1cmZhY2VXYXRlci9kYXRhL2RldGFpbF9ncmFwaC5hc3B4P0lEPVBDS1BFTENPXHUwMDI2TVRZUEU9RElTQ0hSRyIsICJsb2NhdGlvbi5sYXRpdHVkZSI6IDQwLjE3NzA4LCAibG9jYXRpb24ubG9uZ2l0dWRlIjogLTEwNS4xNzg1NjcsICJsb2NhdGlvbi5uZWVkc19yZWNvZGluZyI6IGZhbHNlLCAic3RhZ2UiOiAiMC4xNiIsICJzdGF0aW9uX25hbWUiOiAiUEVDSyBQRUxMQSBDTE9WRVIgRElUQ0giLCAic3RhdGlvbl9zdGF0dXMiOiAiQWN0aXZlIiwgInN0YXRpb25fdHlwZSI6ICJEaXZlcnNpb24iLCAidXNnc19zdGF0aW9uX2lkIjogbnVsbCwgInZhcmlhYmxlIjogIkRJU0NIUkciLCAid2QiOiAiNSJ9LCAidHlwZSI6ICJGZWF0dXJlIn0sIHsiYmJveCI6IFstMTA1LjM1NzMwOCwgMzkuOTQ3NzA0LCAtMTA1LjM1NzMwOCwgMzkuOTQ3NzA0XSwgImdlb21ldHJ5IjogeyJjb29yZGluYXRlcyI6IFstMTA1LjM1NzMwOCwgMzkuOTQ3NzA0XSwgInR5cGUiOiAiUG9pbnQifSwgImlkIjogIjU2IiwgInByb3BlcnRpZXMiOiB7ImFtb3VudCI6ICIxMTM5Ni4wMCIsICJjb3VudHkiOiAiQk9VTERFUiIsICJkYXRhX3NvdXJjZSI6ICJDby4gRGl2aXNpb24gb2YgV2F0ZXIgUmVzb3VyY2VzIiwgImRhdGVfdGltZSI6ICIyMDIwLTAzLTMxVDE4OjMwOjAwLjAwMCIsICJkaXYiOiAiMSIsICJkd3JfYWJicmV2IjogIkdST1NSRUNPIiwgImZsYWciOiBudWxsLCAiaHR0cF9saW5rYWdlLnVybCI6ICJodHRwczovL2R3ci5zdGF0ZS5jby51cy9TdXJmYWNlV2F0ZXIvZGF0YS9kZXRhaWxfZ3JhcGguYXNweD9JRD1HUk9TUkVDT1x1MDAyNk1UWVBFPVNUT1JBR0UiLCAibG9jYXRpb24ubGF0aXR1ZGUiOiAzOS45NDc3MDQsICJsb2NhdGlvbi5sb25naXR1ZGUiOiAtMTA1LjM1NzMwOCwgImxvY2F0aW9uLm5lZWRzX3JlY29kaW5nIjogZmFsc2UsICJzdGFnZSI6ICI3MTc1Ljc5IiwgInN0YXRpb25fbmFtZSI6ICJHUk9TUyBSRVNFUlZPSVIgIiwgInN0YXRpb25fc3RhdHVzIjogIkFjdGl2ZSIsICJzdGF0aW9uX3R5cGUiOiAiUmVzZXJ2b2lyIiwgInVzZ3Nfc3RhdGlvbl9pZCI6IG51bGwsICJ2YXJpYWJsZSI6ICJTVE9SQUdFIiwgIndkIjogIjYifSwgInR5cGUiOiAiRmVhdHVyZSJ9XSwgInR5cGUiOiAiRmVhdHVyZUNvbGxlY3Rpb24ifSk7CiAgICAgICAgCjwvc2NyaXB0Pg==" style="position:absolute;width:100%;height:100%;left:0;top:0;border:none !important;" allowfullscreen webkitallowfullscreen mozallowfullscreen></iframe></div></div>





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



<div style="width:100%;"><div style="position:relative;width:100%;height:0;padding-bottom:60%;"><iframe src="data:text/html;charset=utf-8;base64,PCFET0NUWVBFIGh0bWw+CjxoZWFkPiAgICAKICAgIDxtZXRhIGh0dHAtZXF1aXY9ImNvbnRlbnQtdHlwZSIgY29udGVudD0idGV4dC9odG1sOyBjaGFyc2V0PVVURi04IiAvPgogICAgCiAgICAgICAgPHNjcmlwdD4KICAgICAgICAgICAgTF9OT19UT1VDSCA9IGZhbHNlOwogICAgICAgICAgICBMX0RJU0FCTEVfM0QgPSBmYWxzZTsKICAgICAgICA8L3NjcmlwdD4KICAgIAogICAgPHNjcmlwdCBzcmM9Imh0dHBzOi8vY2RuLmpzZGVsaXZyLm5ldC9ucG0vbGVhZmxldEAxLjUuMS9kaXN0L2xlYWZsZXQuanMiPjwvc2NyaXB0PgogICAgPHNjcmlwdCBzcmM9Imh0dHBzOi8vY29kZS5qcXVlcnkuY29tL2pxdWVyeS0xLjEyLjQubWluLmpzIj48L3NjcmlwdD4KICAgIDxzY3JpcHQgc3JjPSJodHRwczovL21heGNkbi5ib290c3RyYXBjZG4uY29tL2Jvb3RzdHJhcC8zLjIuMC9qcy9ib290c3RyYXAubWluLmpzIj48L3NjcmlwdD4KICAgIDxzY3JpcHQgc3JjPSJodHRwczovL2NkbmpzLmNsb3VkZmxhcmUuY29tL2FqYXgvbGlicy9MZWFmbGV0LmF3ZXNvbWUtbWFya2Vycy8yLjAuMi9sZWFmbGV0LmF3ZXNvbWUtbWFya2Vycy5qcyI+PC9zY3JpcHQ+CiAgICA8bGluayByZWw9InN0eWxlc2hlZXQiIGhyZWY9Imh0dHBzOi8vY2RuLmpzZGVsaXZyLm5ldC9ucG0vbGVhZmxldEAxLjUuMS9kaXN0L2xlYWZsZXQuY3NzIi8+CiAgICA8bGluayByZWw9InN0eWxlc2hlZXQiIGhyZWY9Imh0dHBzOi8vbWF4Y2RuLmJvb3RzdHJhcGNkbi5jb20vYm9vdHN0cmFwLzMuMi4wL2Nzcy9ib290c3RyYXAubWluLmNzcyIvPgogICAgPGxpbmsgcmVsPSJzdHlsZXNoZWV0IiBocmVmPSJodHRwczovL21heGNkbi5ib290c3RyYXBjZG4uY29tL2Jvb3RzdHJhcC8zLjIuMC9jc3MvYm9vdHN0cmFwLXRoZW1lLm1pbi5jc3MiLz4KICAgIDxsaW5rIHJlbD0ic3R5bGVzaGVldCIgaHJlZj0iaHR0cHM6Ly9tYXhjZG4uYm9vdHN0cmFwY2RuLmNvbS9mb250LWF3ZXNvbWUvNC42LjMvY3NzL2ZvbnQtYXdlc29tZS5taW4uY3NzIi8+CiAgICA8bGluayByZWw9InN0eWxlc2hlZXQiIGhyZWY9Imh0dHBzOi8vY2RuanMuY2xvdWRmbGFyZS5jb20vYWpheC9saWJzL0xlYWZsZXQuYXdlc29tZS1tYXJrZXJzLzIuMC4yL2xlYWZsZXQuYXdlc29tZS1tYXJrZXJzLmNzcyIvPgogICAgPGxpbmsgcmVsPSJzdHlsZXNoZWV0IiBocmVmPSJodHRwczovL3Jhd2Nkbi5naXRoYWNrLmNvbS9weXRob24tdmlzdWFsaXphdGlvbi9mb2xpdW0vbWFzdGVyL2ZvbGl1bS90ZW1wbGF0ZXMvbGVhZmxldC5hd2Vzb21lLnJvdGF0ZS5jc3MiLz4KICAgIDxzdHlsZT5odG1sLCBib2R5IHt3aWR0aDogMTAwJTtoZWlnaHQ6IDEwMCU7bWFyZ2luOiAwO3BhZGRpbmc6IDA7fTwvc3R5bGU+CiAgICA8c3R5bGU+I21hcCB7cG9zaXRpb246YWJzb2x1dGU7dG9wOjA7Ym90dG9tOjA7cmlnaHQ6MDtsZWZ0OjA7fTwvc3R5bGU+CiAgICAKICAgICAgICAgICAgPG1ldGEgbmFtZT0idmlld3BvcnQiIGNvbnRlbnQ9IndpZHRoPWRldmljZS13aWR0aCwKICAgICAgICAgICAgICAgIGluaXRpYWwtc2NhbGU9MS4wLCBtYXhpbXVtLXNjYWxlPTEuMCwgdXNlci1zY2FsYWJsZT1ubyIgLz4KICAgICAgICAgICAgPHN0eWxlPgogICAgICAgICAgICAgICAgI21hcF82YTA0OWY5NWUwNjk0ZTVkYTFkNzliZDNiYTUzYjVlNyB7CiAgICAgICAgICAgICAgICAgICAgcG9zaXRpb246IHJlbGF0aXZlOwogICAgICAgICAgICAgICAgICAgIHdpZHRoOiAxMDAuMCU7CiAgICAgICAgICAgICAgICAgICAgaGVpZ2h0OiAxMDAuMCU7CiAgICAgICAgICAgICAgICAgICAgbGVmdDogMC4wJTsKICAgICAgICAgICAgICAgICAgICB0b3A6IDAuMCU7CiAgICAgICAgICAgICAgICB9CiAgICAgICAgICAgIDwvc3R5bGU+CiAgICAgICAgCiAgICA8c2NyaXB0IHNyYz0iaHR0cHM6Ly9jZG5qcy5jbG91ZGZsYXJlLmNvbS9hamF4L2xpYnMvbGVhZmxldC5tYXJrZXJjbHVzdGVyLzEuMS4wL2xlYWZsZXQubWFya2VyY2x1c3Rlci5qcyI+PC9zY3JpcHQ+CiAgICA8bGluayByZWw9InN0eWxlc2hlZXQiIGhyZWY9Imh0dHBzOi8vY2RuanMuY2xvdWRmbGFyZS5jb20vYWpheC9saWJzL2xlYWZsZXQubWFya2VyY2x1c3Rlci8xLjEuMC9NYXJrZXJDbHVzdGVyLmNzcyIvPgogICAgPGxpbmsgcmVsPSJzdHlsZXNoZWV0IiBocmVmPSJodHRwczovL2NkbmpzLmNsb3VkZmxhcmUuY29tL2FqYXgvbGlicy9sZWFmbGV0Lm1hcmtlcmNsdXN0ZXIvMS4xLjAvTWFya2VyQ2x1c3Rlci5EZWZhdWx0LmNzcyIvPgo8L2hlYWQ+Cjxib2R5PiAgICAKICAgIAogICAgICAgICAgICA8ZGl2IGNsYXNzPSJmb2xpdW0tbWFwIiBpZD0ibWFwXzZhMDQ5Zjk1ZTA2OTRlNWRhMWQ3OWJkM2JhNTNiNWU3IiA+PC9kaXY+CiAgICAgICAgCjwvYm9keT4KPHNjcmlwdD4gICAgCiAgICAKICAgICAgICAgICAgdmFyIG1hcF82YTA0OWY5NWUwNjk0ZTVkYTFkNzliZDNiYTUzYjVlNyA9IEwubWFwKAogICAgICAgICAgICAgICAgIm1hcF82YTA0OWY5NWUwNjk0ZTVkYTFkNzliZDNiYTUzYjVlNyIsCiAgICAgICAgICAgICAgICB7CiAgICAgICAgICAgICAgICAgICAgY2VudGVyOiBbNDAuMDEsIC0xMDUuMjddLAogICAgICAgICAgICAgICAgICAgIGNyczogTC5DUlMuRVBTRzM4NTcsCiAgICAgICAgICAgICAgICAgICAgem9vbTogMTAsCiAgICAgICAgICAgICAgICAgICAgem9vbUNvbnRyb2w6IHRydWUsCiAgICAgICAgICAgICAgICAgICAgcHJlZmVyQ2FudmFzOiBmYWxzZSwKICAgICAgICAgICAgICAgIH0KICAgICAgICAgICAgKTsKCiAgICAgICAgICAgIAoKICAgICAgICAKICAgIAogICAgICAgICAgICB2YXIgdGlsZV9sYXllcl9mMzEwYjdkMDk4OWI0ODFhYTRkZWE1ZGRmNDEwMTI1MyA9IEwudGlsZUxheWVyKAogICAgICAgICAgICAgICAgImh0dHBzOi8vY2FydG9kYi1iYXNlbWFwcy17c30uZ2xvYmFsLnNzbC5mYXN0bHkubmV0L2xpZ2h0X2FsbC97en0ve3h9L3t5fS5wbmciLAogICAgICAgICAgICAgICAgeyJhdHRyaWJ1dGlvbiI6ICJcdTAwMjZjb3B5OyBcdTAwM2NhIGhyZWY9XCJodHRwOi8vd3d3Lm9wZW5zdHJlZXRtYXAub3JnL2NvcHlyaWdodFwiXHUwMDNlT3BlblN0cmVldE1hcFx1MDAzYy9hXHUwMDNlIGNvbnRyaWJ1dG9ycyBcdTAwMjZjb3B5OyBcdTAwM2NhIGhyZWY9XCJodHRwOi8vY2FydG9kYi5jb20vYXR0cmlidXRpb25zXCJcdTAwM2VDYXJ0b0RCXHUwMDNjL2FcdTAwM2UsIENhcnRvREIgXHUwMDNjYSBocmVmID1cImh0dHA6Ly9jYXJ0b2RiLmNvbS9hdHRyaWJ1dGlvbnNcIlx1MDAzZWF0dHJpYnV0aW9uc1x1MDAzYy9hXHUwMDNlIiwgImRldGVjdFJldGluYSI6IGZhbHNlLCAibWF4TmF0aXZlWm9vbSI6IDE4LCAibWF4Wm9vbSI6IDE4LCAibWluWm9vbSI6IDAsICJub1dyYXAiOiBmYWxzZSwgIm9wYWNpdHkiOiAxLCAic3ViZG9tYWlucyI6ICJhYmMiLCAidG1zIjogZmFsc2V9CiAgICAgICAgICAgICkuYWRkVG8obWFwXzZhMDQ5Zjk1ZTA2OTRlNWRhMWQ3OWJkM2JhNTNiNWU3KTsKICAgICAgICAKICAgIAogICAgICAgICAgICB2YXIgbWFya2VyX2NsdXN0ZXJfNWZlYWZjMDJmNjRlNGEyOTg4YzlkY2I5ZTMxMmRhMjUgPSBMLm1hcmtlckNsdXN0ZXJHcm91cCgKICAgICAgICAgICAgICAgIHt9CiAgICAgICAgICAgICk7CiAgICAgICAgICAgIG1hcF82YTA0OWY5NWUwNjk0ZTVkYTFkNzliZDNiYTUzYjVlNy5hZGRMYXllcihtYXJrZXJfY2x1c3Rlcl81ZmVhZmMwMmY2NGU0YTI5ODhjOWRjYjllMzEyZGEyNSk7CiAgICAgICAgCiAgICAKICAgICAgICAgICAgdmFyIG1hcmtlcl83OTY1NWM2YThjZDc0MzcyOTFlZjI3ZjdmMjg5ODkyNyA9IEwubWFya2VyKAogICAgICAgICAgICAgICAgWzQwLjE4NTAzMywgLTEwNS4xODU3ODldLAogICAgICAgICAgICAgICAge30KICAgICAgICAgICAgKS5hZGRUbyhtYXJrZXJfY2x1c3Rlcl81ZmVhZmMwMmY2NGU0YTI5ODhjOWRjYjllMzEyZGEyNSk7CiAgICAgICAgCiAgICAKICAgICAgICB2YXIgcG9wdXBfYmE3NDZjOWIzODcyNDcwNmE4YmUwZDk1YzE0ODBlZTUgPSBMLnBvcHVwKHsibWF4V2lkdGgiOiAiMTAwJSJ9KTsKCiAgICAgICAgCiAgICAgICAgICAgIHZhciBodG1sXzk3NjI2MTk0OGJiOTQ3MDg5NTk2OWMwNjc4NDFiNTQwID0gJChgPGRpdiBpZD0iaHRtbF85NzYyNjE5NDhiYjk0NzA4OTU5NjljMDY3ODQxYjU0MCIgc3R5bGU9IndpZHRoOiAxMDAuMCU7IGhlaWdodDogMTAwLjAlOyI+TmFtZTogWldFQ0sgQU5EIFRVUk5FUiBESVRDSCBQcmVjaXA6IDAuMTA8L2Rpdj5gKVswXTsKICAgICAgICAgICAgcG9wdXBfYmE3NDZjOWIzODcyNDcwNmE4YmUwZDk1YzE0ODBlZTUuc2V0Q29udGVudChodG1sXzk3NjI2MTk0OGJiOTQ3MDg5NTk2OWMwNjc4NDFiNTQwKTsKICAgICAgICAKCiAgICAgICAgbWFya2VyXzc5NjU1YzZhOGNkNzQzNzI5MWVmMjdmN2YyODk4OTI3LmJpbmRQb3B1cChwb3B1cF9iYTc0NmM5YjM4NzI0NzA2YThiZTBkOTVjMTQ4MGVlNSkKICAgICAgICA7CgogICAgICAgIAogICAgCiAgICAKICAgICAgICAgICAgdmFyIG1hcmtlcl8xZDQ5NDU1N2I1YTI0M2IzYjQ1YmQzZmMwOTc2YzU4YSA9IEwubWFya2VyKAogICAgICAgICAgICAgICAgWzQwLjIyMDcwMiwgLTEwNS4yNjM0OV0sCiAgICAgICAgICAgICAgICB7fQogICAgICAgICAgICApLmFkZFRvKG1hcmtlcl9jbHVzdGVyXzVmZWFmYzAyZjY0ZTRhMjk4OGM5ZGNiOWUzMTJkYTI1KTsKICAgICAgICAKICAgIAogICAgICAgIHZhciBwb3B1cF9iNDA1MzAxNzg0OTE0MzU5YmNjZmQwMmQ5YjFhNGQ0NCA9IEwucG9wdXAoeyJtYXhXaWR0aCI6ICIxMDAlIn0pOwoKICAgICAgICAKICAgICAgICAgICAgdmFyIGh0bWxfMjM3NzUyOWNlZjRlNGQ3MDk5MzAwYTAzZWM3NzNlOTUgPSAkKGA8ZGl2IGlkPSJodG1sXzIzNzc1MjljZWY0ZTRkNzA5OTMwMGEwM2VjNzczZTk1IiBzdHlsZT0id2lkdGg6IDEwMC4wJTsgaGVpZ2h0OiAxMDAuMCU7Ij5OYW1lOiBTQUlOVCBWUkFJTiBDUkVFSyBBVCBMWU9OUywgQ08gUHJlY2lwOiAzMy4wMDwvZGl2PmApWzBdOwogICAgICAgICAgICBwb3B1cF9iNDA1MzAxNzg0OTE0MzU5YmNjZmQwMmQ5YjFhNGQ0NC5zZXRDb250ZW50KGh0bWxfMjM3NzUyOWNlZjRlNGQ3MDk5MzAwYTAzZWM3NzNlOTUpOwogICAgICAgIAoKICAgICAgICBtYXJrZXJfMWQ0OTQ1NTdiNWEyNDNiM2I0NWJkM2ZjMDk3NmM1OGEuYmluZFBvcHVwKHBvcHVwX2I0MDUzMDE3ODQ5MTQzNTliY2NmZDAyZDliMWE0ZDQ0KQogICAgICAgIDsKCiAgICAgICAgCiAgICAKICAgIAogICAgICAgICAgICB2YXIgbWFya2VyXzkzMDhkODMzNzE0ZjRjZWRhOGFiNDU5MmQzNzRmMGYzID0gTC5tYXJrZXIoCiAgICAgICAgICAgICAgICBbNDAuMTk2NDIyLCAtMTA1LjIwNjU5Ml0sCiAgICAgICAgICAgICAgICB7fQogICAgICAgICAgICApLmFkZFRvKG1hcmtlcl9jbHVzdGVyXzVmZWFmYzAyZjY0ZTRhMjk4OGM5ZGNiOWUzMTJkYTI1KTsKICAgICAgICAKICAgIAogICAgICAgIHZhciBwb3B1cF80NWIzMzcwZWFhNWQ0NWMyOWMzMDdlMWRmYmNmMzY3ZiA9IEwucG9wdXAoeyJtYXhXaWR0aCI6ICIxMDAlIn0pOwoKICAgICAgICAKICAgICAgICAgICAgdmFyIGh0bWxfNGM5OTQwNzY3YTJiNDk3N2FkNzE4NzdjYzY1N2U4ODAgPSAkKGA8ZGl2IGlkPSJodG1sXzRjOTk0MDc2N2EyYjQ5NzdhZDcxODc3Y2M2NTdlODgwIiBzdHlsZT0id2lkdGg6IDEwMC4wJTsgaGVpZ2h0OiAxMDAuMCU7Ij5OYW1lOiBPTElHQVJDSFkgRElUQ0ggRElWRVJTSU9OIFByZWNpcDogMi43NjwvZGl2PmApWzBdOwogICAgICAgICAgICBwb3B1cF80NWIzMzcwZWFhNWQ0NWMyOWMzMDdlMWRmYmNmMzY3Zi5zZXRDb250ZW50KGh0bWxfNGM5OTQwNzY3YTJiNDk3N2FkNzE4NzdjYzY1N2U4ODApOwogICAgICAgIAoKICAgICAgICBtYXJrZXJfOTMwOGQ4MzM3MTRmNGNlZGE4YWI0NTkyZDM3NGYwZjMuYmluZFBvcHVwKHBvcHVwXzQ1YjMzNzBlYWE1ZDQ1YzI5YzMwN2UxZGZiY2YzNjdmKQogICAgICAgIDsKCiAgICAgICAgCiAgICAKICAgIAogICAgICAgICAgICB2YXIgbWFya2VyXzUxNDNhNzM4YjMyYTQ3MTRiMmZlMTgwODAxZDQxNGEzID0gTC5tYXJrZXIoCiAgICAgICAgICAgICAgICBbNDAuMDg3NTgzLCAtMTA1LjA3MjUwMl0sCiAgICAgICAgICAgICAgICB7fQogICAgICAgICAgICApLmFkZFRvKG1hcmtlcl9jbHVzdGVyXzVmZWFmYzAyZjY0ZTRhMjk4OGM5ZGNiOWUzMTJkYTI1KTsKICAgICAgICAKICAgIAogICAgICAgIHZhciBwb3B1cF8xMzkyZjhlYmJmMmE0ZTU0YWI0NmUxMTg4ZWM4YWYwMCA9IEwucG9wdXAoeyJtYXhXaWR0aCI6ICIxMDAlIn0pOwoKICAgICAgICAKICAgICAgICAgICAgdmFyIGh0bWxfOTZjNTM5ODY0NDU2NDc3Yjk2MjI4YTZiMWMyZmY3MmMgPSAkKGA8ZGl2IGlkPSJodG1sXzk2YzUzOTg2NDQ1NjQ3N2I5NjIyOGE2YjFjMmZmNzJjIiBzdHlsZT0id2lkdGg6IDEwMC4wJTsgaGVpZ2h0OiAxMDAuMCU7Ij5OYW1lOiBQQU5BTUEgUkVTRVJWT0lSIE9VVExFVCBQcmVjaXA6IDAuMDU8L2Rpdj5gKVswXTsKICAgICAgICAgICAgcG9wdXBfMTM5MmY4ZWJiZjJhNGU1NGFiNDZlMTE4OGVjOGFmMDAuc2V0Q29udGVudChodG1sXzk2YzUzOTg2NDQ1NjQ3N2I5NjIyOGE2YjFjMmZmNzJjKTsKICAgICAgICAKCiAgICAgICAgbWFya2VyXzUxNDNhNzM4YjMyYTQ3MTRiMmZlMTgwODAxZDQxNGEzLmJpbmRQb3B1cChwb3B1cF8xMzkyZjhlYmJmMmE0ZTU0YWI0NmUxMTg4ZWM4YWYwMCkKICAgICAgICA7CgogICAgICAgIAogICAgCiAgICAKICAgICAgICAgICAgdmFyIG1hcmtlcl9lZmFkOGI4MmE4Y2E0NTUyYTE4YTZmODUzOTc4YWE4YSA9IEwubWFya2VyKAogICAgICAgICAgICAgICAgWzQwLjE5Mzc1OCwgLTEwNS4yMTAzOV0sCiAgICAgICAgICAgICAgICB7fQogICAgICAgICAgICApLmFkZFRvKG1hcmtlcl9jbHVzdGVyXzVmZWFmYzAyZjY0ZTRhMjk4OGM5ZGNiOWUzMTJkYTI1KTsKICAgICAgICAKICAgIAogICAgICAgIHZhciBwb3B1cF84Y2ZiMjY5ODczMDA0MWUwOGIyMzYzMjZiYzkyOTI3ZSA9IEwucG9wdXAoeyJtYXhXaWR0aCI6ICIxMDAlIn0pOwoKICAgICAgICAKICAgICAgICAgICAgdmFyIGh0bWxfOTg3MjA2MDJmZGU3NDMzMDkxODc4MTBmN2YxOGMzNDAgPSAkKGA8ZGl2IGlkPSJodG1sXzk4NzIwNjAyZmRlNzQzMzA5MTg3ODEwZjdmMThjMzQwIiBzdHlsZT0id2lkdGg6IDEwMC4wJTsgaGVpZ2h0OiAxMDAuMCU7Ij5OYW1lOiBDTE9VR0ggQU5EIFRSVUUgRElUQ0ggUHJlY2lwOiAwLjAwPC9kaXY+YClbMF07CiAgICAgICAgICAgIHBvcHVwXzhjZmIyNjk4NzMwMDQxZTA4YjIzNjMyNmJjOTI5MjdlLnNldENvbnRlbnQoaHRtbF85ODcyMDYwMmZkZTc0MzMwOTE4NzgxMGY3ZjE4YzM0MCk7CiAgICAgICAgCgogICAgICAgIG1hcmtlcl9lZmFkOGI4MmE4Y2E0NTUyYTE4YTZmODUzOTc4YWE4YS5iaW5kUG9wdXAocG9wdXBfOGNmYjI2OTg3MzAwNDFlMDhiMjM2MzI2YmM5MjkyN2UpCiAgICAgICAgOwoKICAgICAgICAKICAgIAogICAgCiAgICAgICAgICAgIHZhciBtYXJrZXJfZWVmNmQ4MzBhNDk2NDY4NmE4MDY0NTdlZTI0YjIwNjggPSBMLm1hcmtlcigKICAgICAgICAgICAgICAgIFs0MC4wMDYzOCwgLTEwNS4zMzA4NDFdLAogICAgICAgICAgICAgICAge30KICAgICAgICAgICAgKS5hZGRUbyhtYXJrZXJfY2x1c3Rlcl81ZmVhZmMwMmY2NGU0YTI5ODhjOWRjYjllMzEyZGEyNSk7CiAgICAgICAgCiAgICAKICAgICAgICB2YXIgcG9wdXBfNzdiMTg0ZTE4ZDI3NDA3Nzg1Mzk4YmY4YzA5MDQ2ODkgPSBMLnBvcHVwKHsibWF4V2lkdGgiOiAiMTAwJSJ9KTsKCiAgICAgICAgCiAgICAgICAgICAgIHZhciBodG1sXzMxYTYxMjcwNWYzNTQwYmViZDFjODMyOWQ5MWIwYzMyID0gJChgPGRpdiBpZD0iaHRtbF8zMWE2MTI3MDVmMzU0MGJlYmQxYzgzMjlkOTFiMGMzMiIgc3R5bGU9IndpZHRoOiAxMDAuMCU7IGhlaWdodDogMTAwLjAlOyI+TmFtZTogQk9VTERFUiBDUkVFSyBORUFSIE9ST0RFTEwsIENPLiBQcmVjaXA6IDIyLjEwPC9kaXY+YClbMF07CiAgICAgICAgICAgIHBvcHVwXzc3YjE4NGUxOGQyNzQwNzc4NTM5OGJmOGMwOTA0Njg5LnNldENvbnRlbnQoaHRtbF8zMWE2MTI3MDVmMzU0MGJlYmQxYzgzMjlkOTFiMGMzMik7CiAgICAgICAgCgogICAgICAgIG1hcmtlcl9lZWY2ZDgzMGE0OTY0Njg2YTgwNjQ1N2VlMjRiMjA2OC5iaW5kUG9wdXAocG9wdXBfNzdiMTg0ZTE4ZDI3NDA3Nzg1Mzk4YmY4YzA5MDQ2ODkpCiAgICAgICAgOwoKICAgICAgICAKICAgIAogICAgCiAgICAgICAgICAgIHZhciBtYXJrZXJfYzU0MWQ0ZGI1MzQwNDc4MGIzYzc2ZTFmMDcxZjE3MzIgPSBMLm1hcmtlcigKICAgICAgICAgICAgICAgIFs0MC4yMDQxOTMsIC0xMDUuMjE4Nzc3XSwKICAgICAgICAgICAgICAgIHt9CiAgICAgICAgICAgICkuYWRkVG8obWFya2VyX2NsdXN0ZXJfNWZlYWZjMDJmNjRlNGEyOTg4YzlkY2I5ZTMxMmRhMjUpOwogICAgICAgIAogICAgCiAgICAgICAgdmFyIHBvcHVwX2RlZDVlMWE2NjAxNDRlNDc5ZWEwMzcyZTkwYjAyYTQwID0gTC5wb3B1cCh7Im1heFdpZHRoIjogIjEwMCUifSk7CgogICAgICAgIAogICAgICAgICAgICB2YXIgaHRtbF85NGM0ZjE4ZWRhNDk0ZWEzODQ2MjZlM2U3MWNhM2E0MiA9ICQoYDxkaXYgaWQ9Imh0bWxfOTRjNGYxOGVkYTQ5NGVhMzg0NjI2ZTNlNzFjYTNhNDIiIHN0eWxlPSJ3aWR0aDogMTAwLjAlOyBoZWlnaHQ6IDEwMC4wJTsiPk5hbWU6IExPTkdNT05UIFNVUFBMWSBESVRDSCBQcmVjaXA6IDAuMDA8L2Rpdj5gKVswXTsKICAgICAgICAgICAgcG9wdXBfZGVkNWUxYTY2MDE0NGU0NzllYTAzNzJlOTBiMDJhNDAuc2V0Q29udGVudChodG1sXzk0YzRmMThlZGE0OTRlYTM4NDYyNmUzZTcxY2EzYTQyKTsKICAgICAgICAKCiAgICAgICAgbWFya2VyX2M1NDFkNGRiNTM0MDQ3ODBiM2M3NmUxZjA3MWYxNzMyLmJpbmRQb3B1cChwb3B1cF9kZWQ1ZTFhNjYwMTQ0ZTQ3OWVhMDM3MmU5MGIwMmE0MCkKICAgICAgICA7CgogICAgICAgIAogICAgCiAgICAKICAgICAgICAgICAgdmFyIG1hcmtlcl82ODViNjVmZGIzMmU0ODE3ODI5ZTZjNDgwYjhlNTJjYyA9IEwubWFya2VyKAogICAgICAgICAgICAgICAgWzQwLjI1ODcyNiwgLTEwNS4xNzU4MTddLAogICAgICAgICAgICAgICAge30KICAgICAgICAgICAgKS5hZGRUbyhtYXJrZXJfY2x1c3Rlcl81ZmVhZmMwMmY2NGU0YTI5ODhjOWRjYjllMzEyZGEyNSk7CiAgICAgICAgCiAgICAKICAgICAgICB2YXIgcG9wdXBfMjcxODRhOTNiNDIxNDRmOWE4ZTNhNDJlZTAzMjY3OGMgPSBMLnBvcHVwKHsibWF4V2lkdGgiOiAiMTAwJSJ9KTsKCiAgICAgICAgCiAgICAgICAgICAgIHZhciBodG1sXzUwODM0Y2Y4MGE0NTRkOWU4ODI1M2UzMDZkZWZiODk1ID0gJChgPGRpdiBpZD0iaHRtbF81MDgzNGNmODBhNDU0ZDllODgyNTNlMzA2ZGVmYjg5NSIgc3R5bGU9IndpZHRoOiAxMDAuMCU7IGhlaWdodDogMTAwLjAlOyI+TmFtZTogQk9VTERFUi1MQVJJTUVSIEJZUEFTUyBORUFSIEJFUlRIT1VEIFByZWNpcDogMTEuOTA8L2Rpdj5gKVswXTsKICAgICAgICAgICAgcG9wdXBfMjcxODRhOTNiNDIxNDRmOWE4ZTNhNDJlZTAzMjY3OGMuc2V0Q29udGVudChodG1sXzUwODM0Y2Y4MGE0NTRkOWU4ODI1M2UzMDZkZWZiODk1KTsKICAgICAgICAKCiAgICAgICAgbWFya2VyXzY4NWI2NWZkYjMyZTQ4MTc4MjllNmM0ODBiOGU1MmNjLmJpbmRQb3B1cChwb3B1cF8yNzE4NGE5M2I0MjE0NGY5YThlM2E0MmVlMDMyNjc4YykKICAgICAgICA7CgogICAgICAgIAogICAgCiAgICAKICAgICAgICAgICAgdmFyIG1hcmtlcl8zY2U1M2NlZmZiODQ0YWU2YmRhMTY2NWRjYTBkNTA2ZCA9IEwubWFya2VyKAogICAgICAgICAgICAgICAgWzQwLjI1ODAzOCwgLTEwNS4yMDYzODZdLAogICAgICAgICAgICAgICAge30KICAgICAgICAgICAgKS5hZGRUbyhtYXJrZXJfY2x1c3Rlcl81ZmVhZmMwMmY2NGU0YTI5ODhjOWRjYjllMzEyZGEyNSk7CiAgICAgICAgCiAgICAKICAgICAgICB2YXIgcG9wdXBfYjhlZjhhYmY5ODk4NGFhZGE3NjY5NjU1Zjc4MDlkOGMgPSBMLnBvcHVwKHsibWF4V2lkdGgiOiAiMTAwJSJ9KTsKCiAgICAgICAgCiAgICAgICAgICAgIHZhciBodG1sXzgzM2I3Yzg4NDJiMTQ5ODA5YTk1YjE4N2UwZjkxZGNiID0gJChgPGRpdiBpZD0iaHRtbF84MzNiN2M4ODQyYjE0OTgwOWE5NWIxODdlMGY5MWRjYiIgc3R5bGU9IndpZHRoOiAxMDAuMCU7IGhlaWdodDogMTAwLjAlOyI+TmFtZTogTElUVExFIFRIT01QU09OIFJJVkVSIEFUIENBTllPTiBNT1VUSCBORUFSIEJFUlRIT1VEIFByZWNpcDogMTMuNjA8L2Rpdj5gKVswXTsKICAgICAgICAgICAgcG9wdXBfYjhlZjhhYmY5ODk4NGFhZGE3NjY5NjU1Zjc4MDlkOGMuc2V0Q29udGVudChodG1sXzgzM2I3Yzg4NDJiMTQ5ODA5YTk1YjE4N2UwZjkxZGNiKTsKICAgICAgICAKCiAgICAgICAgbWFya2VyXzNjZTUzY2VmZmI4NDRhZTZiZGExNjY1ZGNhMGQ1MDZkLmJpbmRQb3B1cChwb3B1cF9iOGVmOGFiZjk4OTg0YWFkYTc2Njk2NTVmNzgwOWQ4YykKICAgICAgICA7CgogICAgICAgIAogICAgCiAgICAKICAgICAgICAgICAgdmFyIG1hcmtlcl82ZTZlOTk2OTJjOTY0MDc2YTM1OGMyZGVkMWMxNmZiYyA9IEwubWFya2VyKAogICAgICAgICAgICAgICAgWzQwLjE3MjkyNSwgLTEwNS4xNjc2MjJdLAogICAgICAgICAgICAgICAge30KICAgICAgICAgICAgKS5hZGRUbyhtYXJrZXJfY2x1c3Rlcl81ZmVhZmMwMmY2NGU0YTI5ODhjOWRjYjllMzEyZGEyNSk7CiAgICAgICAgCiAgICAKICAgICAgICB2YXIgcG9wdXBfMGFhZGU5ZjRhMzEzNDc0MWJlOTk2ZjVlNGI1YTRiMTcgPSBMLnBvcHVwKHsibWF4V2lkdGgiOiAiMTAwJSJ9KTsKCiAgICAgICAgCiAgICAgICAgICAgIHZhciBodG1sXzU3MWNlYTk0NDc3ZjRhMzdhZTViYjBmZGUxNWM5ZjA1ID0gJChgPGRpdiBpZD0iaHRtbF81NzFjZWE5NDQ3N2Y0YTM3YWU1YmIwZmRlMTVjOWYwNSIgc3R5bGU9IndpZHRoOiAxMDAuMCU7IGhlaWdodDogMTAwLjAlOyI+TmFtZTogTk9SVEhXRVNUIE1VVFVBTCBESVRDSCBQcmVjaXA6IDAuMDA8L2Rpdj5gKVswXTsKICAgICAgICAgICAgcG9wdXBfMGFhZGU5ZjRhMzEzNDc0MWJlOTk2ZjVlNGI1YTRiMTcuc2V0Q29udGVudChodG1sXzU3MWNlYTk0NDc3ZjRhMzdhZTViYjBmZGUxNWM5ZjA1KTsKICAgICAgICAKCiAgICAgICAgbWFya2VyXzZlNmU5OTY5MmM5NjQwNzZhMzU4YzJkZWQxYzE2ZmJjLmJpbmRQb3B1cChwb3B1cF8wYWFkZTlmNGEzMTM0NzQxYmU5OTZmNWU0YjVhNGIxNykKICAgICAgICA7CgogICAgICAgIAogICAgCiAgICAKICAgICAgICAgICAgdmFyIG1hcmtlcl9mMGI2ZTAyNTkyODM0Njk5OGI2ZWMxMzZkMmM5Zjg4MyA9IEwubWFya2VyKAogICAgICAgICAgICAgICAgWzQwLjEzNDI3OCwgLTEwNS4xMzA4MTldLAogICAgICAgICAgICAgICAge30KICAgICAgICAgICAgKS5hZGRUbyhtYXJrZXJfY2x1c3Rlcl81ZmVhZmMwMmY2NGU0YTI5ODhjOWRjYjllMzEyZGEyNSk7CiAgICAgICAgCiAgICAKICAgICAgICB2YXIgcG9wdXBfZmJjNjlhMjY5ZjdhNDlhYjkxODViYjhiZTUyNzJjMjEgPSBMLnBvcHVwKHsibWF4V2lkdGgiOiAiMTAwJSJ9KTsKCiAgICAgICAgCiAgICAgICAgICAgIHZhciBodG1sX2FhMTg3ZjE0OGQ5OTRmNTE5Y2JjODFhYjFhYzA3MjgzID0gJChgPGRpdiBpZD0iaHRtbF9hYTE4N2YxNDhkOTk0ZjUxOWNiYzgxYWIxYWMwNzI4MyIgc3R5bGU9IndpZHRoOiAxMDAuMCU7IGhlaWdodDogMTAwLjAlOyI+TmFtZTogTEVGVCBIQU5EIENSRUVLIEFUIEhPVkVSIFJPQUQgTkVBUiBMT05HTU9OVCwgQ08gUHJlY2lwOiAzLjM0PC9kaXY+YClbMF07CiAgICAgICAgICAgIHBvcHVwX2ZiYzY5YTI2OWY3YTQ5YWI5MTg1YmI4YmU1MjcyYzIxLnNldENvbnRlbnQoaHRtbF9hYTE4N2YxNDhkOTk0ZjUxOWNiYzgxYWIxYWMwNzI4Myk7CiAgICAgICAgCgogICAgICAgIG1hcmtlcl9mMGI2ZTAyNTkyODM0Njk5OGI2ZWMxMzZkMmM5Zjg4My5iaW5kUG9wdXAocG9wdXBfZmJjNjlhMjY5ZjdhNDlhYjkxODViYjhiZTUyNzJjMjEpCiAgICAgICAgOwoKICAgICAgICAKICAgIAogICAgCiAgICAgICAgICAgIHZhciBtYXJrZXJfM2Y4YzI1MzNiNWZjNDA0NGE0MGZhZTczNDk4ZTYzZTAgPSBMLm1hcmtlcigKICAgICAgICAgICAgICAgIFszOS45ODYxNjksIC0xMDUuMjE4Njc3XSwKICAgICAgICAgICAgICAgIHt9CiAgICAgICAgICAgICkuYWRkVG8obWFya2VyX2NsdXN0ZXJfNWZlYWZjMDJmNjRlNGEyOTg4YzlkY2I5ZTMxMmRhMjUpOwogICAgICAgIAogICAgCiAgICAgICAgdmFyIHBvcHVwXzljM2FlYjRlZGZmYTQyOTA5ZDQ5YjYxZWQyYTE1NzgzID0gTC5wb3B1cCh7Im1heFdpZHRoIjogIjEwMCUifSk7CgogICAgICAgIAogICAgICAgICAgICB2YXIgaHRtbF9lMWY1MDMyODg2NmE0NWMzYTI3ZTBhNTZhZmYyMjZjMCA9ICQoYDxkaXYgaWQ9Imh0bWxfZTFmNTAzMjg4NjZhNDVjM2EyN2UwYTU2YWZmMjI2YzAiIHN0eWxlPSJ3aWR0aDogMTAwLjAlOyBoZWlnaHQ6IDEwMC4wJTsiPk5hbWU6IERSWSBDUkVFSyBDQVJSSUVSIFByZWNpcDogMC4wMDwvZGl2PmApWzBdOwogICAgICAgICAgICBwb3B1cF85YzNhZWI0ZWRmZmE0MjkwOWQ0OWI2MWVkMmExNTc4My5zZXRDb250ZW50KGh0bWxfZTFmNTAzMjg4NjZhNDVjM2EyN2UwYTU2YWZmMjI2YzApOwogICAgICAgIAoKICAgICAgICBtYXJrZXJfM2Y4YzI1MzNiNWZjNDA0NGE0MGZhZTczNDk4ZTYzZTAuYmluZFBvcHVwKHBvcHVwXzljM2FlYjRlZGZmYTQyOTA5ZDQ5YjYxZWQyYTE1NzgzKQogICAgICAgIDsKCiAgICAgICAgCiAgICAKICAgIAogICAgICAgICAgICB2YXIgbWFya2VyXzdkZGJmNGZhZTkwNjRhMGM4MTMyYjBjYWExN2U4YjU0ID0gTC5tYXJrZXIoCiAgICAgICAgICAgICAgICBbMzkuOTMxNTk3LCAtMTA1LjMwNDk5XSwKICAgICAgICAgICAgICAgIHt9CiAgICAgICAgICAgICkuYWRkVG8obWFya2VyX2NsdXN0ZXJfNWZlYWZjMDJmNjRlNGEyOTg4YzlkY2I5ZTMxMmRhMjUpOwogICAgICAgIAogICAgCiAgICAgICAgdmFyIHBvcHVwX2M4Y2VjY2YyYTk4ZTRkN2Y4OThhY2ExODg3MDcwNzdiID0gTC5wb3B1cCh7Im1heFdpZHRoIjogIjEwMCUifSk7CgogICAgICAgIAogICAgICAgICAgICB2YXIgaHRtbF8yOWUzZGM4MTM5ZGM0ZmYxYTg2NTIzYTI4NGMwMDFhYSA9ICQoYDxkaXYgaWQ9Imh0bWxfMjllM2RjODEzOWRjNGZmMWE4NjUyM2EyODRjMDAxYWEiIHN0eWxlPSJ3aWR0aDogMTAwLjAlOyBoZWlnaHQ6IDEwMC4wJTsiPk5hbWU6IFNPVVRIIEJPVUxERVIgQ1JFRUsgTkVBUiBFTERPUkFETyBTUFJJTkdTLCBDTy4gUHJlY2lwOiAxNy44MDwvZGl2PmApWzBdOwogICAgICAgICAgICBwb3B1cF9jOGNlY2NmMmE5OGU0ZDdmODk4YWNhMTg4NzA3MDc3Yi5zZXRDb250ZW50KGh0bWxfMjllM2RjODEzOWRjNGZmMWE4NjUyM2EyODRjMDAxYWEpOwogICAgICAgIAoKICAgICAgICBtYXJrZXJfN2RkYmY0ZmFlOTA2NGEwYzgxMzJiMGNhYTE3ZThiNTQuYmluZFBvcHVwKHBvcHVwX2M4Y2VjY2YyYTk4ZTRkN2Y4OThhY2ExODg3MDcwNzdiKQogICAgICAgIDsKCiAgICAgICAgCiAgICAKICAgIAogICAgICAgICAgICB2YXIgbWFya2VyX2Y0NDk2YmQyNTRkYTQ1MjE5MzE3N2RhY2VkNjEwODRiID0gTC5tYXJrZXIoCiAgICAgICAgICAgICAgICBbNDAuMTYwNzA1LCAtMTA1LjE2ODQ3MV0sCiAgICAgICAgICAgICAgICB7fQogICAgICAgICAgICApLmFkZFRvKG1hcmtlcl9jbHVzdGVyXzVmZWFmYzAyZjY0ZTRhMjk4OGM5ZGNiOWUzMTJkYTI1KTsKICAgICAgICAKICAgIAogICAgICAgIHZhciBwb3B1cF8wN2Y3Y2U4YjA5Mzk0NTU1YmJlNzlmYmE5MjM4ZWUzYSA9IEwucG9wdXAoeyJtYXhXaWR0aCI6ICIxMDAlIn0pOwoKICAgICAgICAKICAgICAgICAgICAgdmFyIGh0bWxfNWRlNzZhODJlYmExNDdkY2JkYTdmNzA1ZTgxOWFmYzkgPSAkKGA8ZGl2IGlkPSJodG1sXzVkZTc2YTgyZWJhMTQ3ZGNiZGE3ZjcwNWU4MTlhZmM5IiBzdHlsZT0id2lkdGg6IDEwMC4wJTsgaGVpZ2h0OiAxMDAuMCU7Ij5OYW1lOiBQRUNLLVBFTExBIEFVR01FTlRBVElPTiBSRVRVUk4gUHJlY2lwOiAwLjAwPC9kaXY+YClbMF07CiAgICAgICAgICAgIHBvcHVwXzA3ZjdjZThiMDkzOTQ1NTViYmU3OWZiYTkyMzhlZTNhLnNldENvbnRlbnQoaHRtbF81ZGU3NmE4MmViYTE0N2RjYmRhN2Y3MDVlODE5YWZjOSk7CiAgICAgICAgCgogICAgICAgIG1hcmtlcl9mNDQ5NmJkMjU0ZGE0NTIxOTMxNzdkYWNlZDYxMDg0Yi5iaW5kUG9wdXAocG9wdXBfMDdmN2NlOGIwOTM5NDU1NWJiZTc5ZmJhOTIzOGVlM2EpCiAgICAgICAgOwoKICAgICAgICAKICAgIAogICAgCiAgICAgICAgICAgIHZhciBtYXJrZXJfNDYxZTA0NzVjY2IwNGViMWEzYjk3NzJmYmYzZGY1MGUgPSBMLm1hcmtlcigKICAgICAgICAgICAgICAgIFs0MC4xOTkzMjEsIC0xMDUuMjIyNjM5XSwKICAgICAgICAgICAgICAgIHt9CiAgICAgICAgICAgICkuYWRkVG8obWFya2VyX2NsdXN0ZXJfNWZlYWZjMDJmNjRlNGEyOTg4YzlkY2I5ZTMxMmRhMjUpOwogICAgICAgIAogICAgCiAgICAgICAgdmFyIHBvcHVwX2ZhMzM4NjEwNTA2ZDQ5ZTI4YzgzNWUzYmJhNjQxMTQzID0gTC5wb3B1cCh7Im1heFdpZHRoIjogIjEwMCUifSk7CgogICAgICAgIAogICAgICAgICAgICB2YXIgaHRtbF9kMTM2YjFiYWIzYzM0ZmQ5OWNlMDExZDg4MDhjYjkwZSA9ICQoYDxkaXYgaWQ9Imh0bWxfZDEzNmIxYmFiM2MzNGZkOTljZTAxMWQ4ODA4Y2I5MGUiIHN0eWxlPSJ3aWR0aDogMTAwLjAlOyBoZWlnaHQ6IDEwMC4wJTsiPk5hbWU6IEdPU1MgRElUQ0ggMSBQcmVjaXA6IDAuMDA8L2Rpdj5gKVswXTsKICAgICAgICAgICAgcG9wdXBfZmEzMzg2MTA1MDZkNDllMjhjODM1ZTNiYmE2NDExNDMuc2V0Q29udGVudChodG1sX2QxMzZiMWJhYjNjMzRmZDk5Y2UwMTFkODgwOGNiOTBlKTsKICAgICAgICAKCiAgICAgICAgbWFya2VyXzQ2MWUwNDc1Y2NiMDRlYjFhM2I5NzcyZmJmM2RmNTBlLmJpbmRQb3B1cChwb3B1cF9mYTMzODYxMDUwNmQ0OWUyOGM4MzVlM2JiYTY0MTE0MykKICAgICAgICA7CgogICAgICAgIAogICAgCiAgICAKICAgICAgICAgICAgdmFyIG1hcmtlcl9lODlmMDI3NzljMjI0Njk5OTk4ODU1OWFkZDFlMmQ3ZCA9IEwubWFya2VyKAogICAgICAgICAgICAgICAgWzQwLjE5MzI4LCAtMTA1LjIxMDQyNF0sCiAgICAgICAgICAgICAgICB7fQogICAgICAgICAgICApLmFkZFRvKG1hcmtlcl9jbHVzdGVyXzVmZWFmYzAyZjY0ZTRhMjk4OGM5ZGNiOWUzMTJkYTI1KTsKICAgICAgICAKICAgIAogICAgICAgIHZhciBwb3B1cF84OGZjZTk5YTAyOWU0MDBiYTc1OGFjYzNhODk5MjI5NCA9IEwucG9wdXAoeyJtYXhXaWR0aCI6ICIxMDAlIn0pOwoKICAgICAgICAKICAgICAgICAgICAgdmFyIGh0bWxfZWRiMDRmZDBiMTIwNGNjZDgyNzUwYTU2OWVlYWE5NzAgPSAkKGA8ZGl2IGlkPSJodG1sX2VkYjA0ZmQwYjEyMDRjY2Q4Mjc1MGE1NjllZWFhOTcwIiBzdHlsZT0id2lkdGg6IDEwMC4wJTsgaGVpZ2h0OiAxMDAuMCU7Ij5OYW1lOiBXRUJTVEVSIE1DQ0FTTElOIERJVENIIFByZWNpcDogMC4wMDwvZGl2PmApWzBdOwogICAgICAgICAgICBwb3B1cF84OGZjZTk5YTAyOWU0MDBiYTc1OGFjYzNhODk5MjI5NC5zZXRDb250ZW50KGh0bWxfZWRiMDRmZDBiMTIwNGNjZDgyNzUwYTU2OWVlYWE5NzApOwogICAgICAgIAoKICAgICAgICBtYXJrZXJfZTg5ZjAyNzc5YzIyNDY5OTk5ODg1NTlhZGQxZTJkN2QuYmluZFBvcHVwKHBvcHVwXzg4ZmNlOTlhMDI5ZTQwMGJhNzU4YWNjM2E4OTkyMjk0KQogICAgICAgIDsKCiAgICAgICAgCiAgICAKICAgIAogICAgICAgICAgICB2YXIgbWFya2VyX2QwMmZkOWE1YmQ1YTQzZDNiZjQ5MTNiZWNhOTU0MDI5ID0gTC5tYXJrZXIoCiAgICAgICAgICAgICAgICBbMzkuOTg4NDgxLCAtMTA1LjIyMDQ3N10sCiAgICAgICAgICAgICAgICB7fQogICAgICAgICAgICApLmFkZFRvKG1hcmtlcl9jbHVzdGVyXzVmZWFmYzAyZjY0ZTRhMjk4OGM5ZGNiOWUzMTJkYTI1KTsKICAgICAgICAKICAgIAogICAgICAgIHZhciBwb3B1cF9iOGFiYWY1YTdhOTM0ZmNjYmFlZjQzYjcwZGE4ODFjMyA9IEwucG9wdXAoeyJtYXhXaWR0aCI6ICIxMDAlIn0pOwoKICAgICAgICAKICAgICAgICAgICAgdmFyIGh0bWxfYzdlZmEyNWYyNjVlNDlmZmEzZDFiMTQ3MTlmMDBkNzkgPSAkKGA8ZGl2IGlkPSJodG1sX2M3ZWZhMjVmMjY1ZTQ5ZmZhM2QxYjE0NzE5ZjAwZDc5IiBzdHlsZT0id2lkdGg6IDEwMC4wJTsgaGVpZ2h0OiAxMDAuMCU7Ij5OYW1lOiBIT1dBUkQgRElUQ0ggUHJlY2lwOiAwLjAwPC9kaXY+YClbMF07CiAgICAgICAgICAgIHBvcHVwX2I4YWJhZjVhN2E5MzRmY2NiYWVmNDNiNzBkYTg4MWMzLnNldENvbnRlbnQoaHRtbF9jN2VmYTI1ZjI2NWU0OWZmYTNkMWIxNDcxOWYwMGQ3OSk7CiAgICAgICAgCgogICAgICAgIG1hcmtlcl9kMDJmZDlhNWJkNWE0M2QzYmY0OTEzYmVjYTk1NDAyOS5iaW5kUG9wdXAocG9wdXBfYjhhYmFmNWE3YTkzNGZjY2JhZWY0M2I3MGRhODgxYzMpCiAgICAgICAgOwoKICAgICAgICAKICAgIAogICAgCiAgICAgICAgICAgIHZhciBtYXJrZXJfYTZkMDAwYWIwMDZjNDE1N2I4ZDQ3N2MzYTRhNGUyZGYgPSBMLm1hcmtlcigKICAgICAgICAgICAgICAgIFs0MC4yMTYyNjMsIC0xMDUuMzY1MzY1XSwKICAgICAgICAgICAgICAgIHt9CiAgICAgICAgICAgICkuYWRkVG8obWFya2VyX2NsdXN0ZXJfNWZlYWZjMDJmNjRlNGEyOTg4YzlkY2I5ZTMxMmRhMjUpOwogICAgICAgIAogICAgCiAgICAgICAgdmFyIHBvcHVwX2RiZTczMDA3ODFhZjRkYmFhNjY0MzkwZDY1OGU0OGQwID0gTC5wb3B1cCh7Im1heFdpZHRoIjogIjEwMCUifSk7CgogICAgICAgIAogICAgICAgICAgICB2YXIgaHRtbF9hMjY4ZTY3NzcyNDE0NWNkODM3Y2QwNzAxMGIxNDU4ZSA9ICQoYDxkaXYgaWQ9Imh0bWxfYTI2OGU2Nzc3MjQxNDVjZDgzN2NkMDcwMTBiMTQ1OGUiIHN0eWxlPSJ3aWR0aDogMTAwLjAlOyBoZWlnaHQ6IDEwMC4wJTsiPk5hbWU6IEJVVFRPTlJPQ0sgKFJBTFBIIFBSSUNFKSBSRVNFUlZPSVIgUHJlY2lwOiAxMjkxNy4wMDwvZGl2PmApWzBdOwogICAgICAgICAgICBwb3B1cF9kYmU3MzAwNzgxYWY0ZGJhYTY2NDM5MGQ2NThlNDhkMC5zZXRDb250ZW50KGh0bWxfYTI2OGU2Nzc3MjQxNDVjZDgzN2NkMDcwMTBiMTQ1OGUpOwogICAgICAgIAoKICAgICAgICBtYXJrZXJfYTZkMDAwYWIwMDZjNDE1N2I4ZDQ3N2MzYTRhNGUyZGYuYmluZFBvcHVwKHBvcHVwX2RiZTczMDA3ODFhZjRkYmFhNjY0MzkwZDY1OGU0OGQwKQogICAgICAgIDsKCiAgICAgICAgCiAgICAKICAgIAogICAgICAgICAgICB2YXIgbWFya2VyXzU5YmIyOTc4MDg4ZDQ2YjA4NTBhODdiMzczYTIwMWZhID0gTC5tYXJrZXIoCiAgICAgICAgICAgICAgICBbNDAuMjU1Nzc2LCAtMTA1LjIwOTVdLAogICAgICAgICAgICAgICAge30KICAgICAgICAgICAgKS5hZGRUbyhtYXJrZXJfY2x1c3Rlcl81ZmVhZmMwMmY2NGU0YTI5ODhjOWRjYjllMzEyZGEyNSk7CiAgICAgICAgCiAgICAKICAgICAgICB2YXIgcG9wdXBfODdjOGU0MzE3Y2YxNDI1ODhmMzExN2ZlNjAzNTEwYTIgPSBMLnBvcHVwKHsibWF4V2lkdGgiOiAiMTAwJSJ9KTsKCiAgICAgICAgCiAgICAgICAgICAgIHZhciBodG1sXzU3YzkzOWI0ODI2NDQ4N2E4YWFkYzAzN2ExZDRmMzQ3ID0gJChgPGRpdiBpZD0iaHRtbF81N2M5MzliNDgyNjQ0ODdhOGFhZGMwMzdhMWQ0ZjM0NyIgc3R5bGU9IndpZHRoOiAxMDAuMCU7IGhlaWdodDogMTAwLjAlOyI+TmFtZTogTElUVExFIFRIT01QU09OICMyIERJVENIIFByZWNpcDogMC4xMDwvZGl2PmApWzBdOwogICAgICAgICAgICBwb3B1cF84N2M4ZTQzMTdjZjE0MjU4OGYzMTE3ZmU2MDM1MTBhMi5zZXRDb250ZW50KGh0bWxfNTdjOTM5YjQ4MjY0NDg3YThhYWRjMDM3YTFkNGYzNDcpOwogICAgICAgIAoKICAgICAgICBtYXJrZXJfNTliYjI5NzgwODhkNDZiMDg1MGE4N2IzNzNhMjAxZmEuYmluZFBvcHVwKHBvcHVwXzg3YzhlNDMxN2NmMTQyNTg4ZjMxMTdmZTYwMzUxMGEyKQogICAgICAgIDsKCiAgICAgICAgCiAgICAKICAgIAogICAgICAgICAgICB2YXIgbWFya2VyXzQ0YmVhOThhZTc1MjQwMjhhMDMzZmNlZjM3YTc5OWFlID0gTC5tYXJrZXIoCiAgICAgICAgICAgICAgICBbNDAuMjU3ODQ0LCAtMTA1LjE2NDM5N10sCiAgICAgICAgICAgICAgICB7fQogICAgICAgICAgICApLmFkZFRvKG1hcmtlcl9jbHVzdGVyXzVmZWFmYzAyZjY0ZTRhMjk4OGM5ZGNiOWUzMTJkYTI1KTsKICAgICAgICAKICAgIAogICAgICAgIHZhciBwb3B1cF9kYjkxZTUxZjYzZDE0NDAyOGU3ZDM3OGY4NGM0MmE1YiA9IEwucG9wdXAoeyJtYXhXaWR0aCI6ICIxMDAlIn0pOwoKICAgICAgICAKICAgICAgICAgICAgdmFyIGh0bWxfOWNkMGQ5YTIwNDlmNGEyNmFiOTdmMGYwMzBjMTg3NjkgPSAkKGA8ZGl2IGlkPSJodG1sXzljZDBkOWEyMDQ5ZjRhMjZhYjk3ZjBmMDMwYzE4NzY5IiBzdHlsZT0id2lkdGg6IDEwMC4wJTsgaGVpZ2h0OiAxMDAuMCU7Ij5OYW1lOiBCTE9XRVIgRElUQ0ggUHJlY2lwOiAwLjAwPC9kaXY+YClbMF07CiAgICAgICAgICAgIHBvcHVwX2RiOTFlNTFmNjNkMTQ0MDI4ZTdkMzc4Zjg0YzQyYTViLnNldENvbnRlbnQoaHRtbF85Y2QwZDlhMjA0OWY0YTI2YWI5N2YwZjAzMGMxODc2OSk7CiAgICAgICAgCgogICAgICAgIG1hcmtlcl80NGJlYTk4YWU3NTI0MDI4YTAzM2ZjZWYzN2E3OTlhZS5iaW5kUG9wdXAocG9wdXBfZGI5MWU1MWY2M2QxNDQwMjhlN2QzNzhmODRjNDJhNWIpCiAgICAgICAgOwoKICAgICAgICAKICAgIAogICAgCiAgICAgICAgICAgIHZhciBtYXJrZXJfYmUzM2EzMGFlNmE4NGEzZGIzM2IzZjI0MDk4YWYzZGEgPSBMLm1hcmtlcigKICAgICAgICAgICAgICAgIFs0MC4wNTE2NTIsIC0xMDUuMTc4ODc1XSwKICAgICAgICAgICAgICAgIHt9CiAgICAgICAgICAgICkuYWRkVG8obWFya2VyX2NsdXN0ZXJfNWZlYWZjMDJmNjRlNGEyOTg4YzlkY2I5ZTMxMmRhMjUpOwogICAgICAgIAogICAgCiAgICAgICAgdmFyIHBvcHVwXzNlYWY0ZTE4YTc0MDQ5ZmI5MzU3Y2RiZTVkMjlkNTgxID0gTC5wb3B1cCh7Im1heFdpZHRoIjogIjEwMCUifSk7CgogICAgICAgIAogICAgICAgICAgICB2YXIgaHRtbF9lYTdhNTIyYzk4OTI0OTNkOThiOTI3YjFlNmY4ZjgwNSA9ICQoYDxkaXYgaWQ9Imh0bWxfZWE3YTUyMmM5ODkyNDkzZDk4YjkyN2IxZTZmOGY4MDUiIHN0eWxlPSJ3aWR0aDogMTAwLjAlOyBoZWlnaHQ6IDEwMC4wJTsiPk5hbWU6IEJPVUxERVIgQ1JFRUsgQVQgTk9SVEggNzVUSCBTVC4gTkVBUiBCT1VMREVSLCBDTyBQcmVjaXA6IDIxLjMwPC9kaXY+YClbMF07CiAgICAgICAgICAgIHBvcHVwXzNlYWY0ZTE4YTc0MDQ5ZmI5MzU3Y2RiZTVkMjlkNTgxLnNldENvbnRlbnQoaHRtbF9lYTdhNTIyYzk4OTI0OTNkOThiOTI3YjFlNmY4ZjgwNSk7CiAgICAgICAgCgogICAgICAgIG1hcmtlcl9iZTMzYTMwYWU2YTg0YTNkYjMzYjNmMjQwOThhZjNkYS5iaW5kUG9wdXAocG9wdXBfM2VhZjRlMThhNzQwNDlmYjkzNTdjZGJlNWQyOWQ1ODEpCiAgICAgICAgOwoKICAgICAgICAKICAgIAogICAgCiAgICAgICAgICAgIHZhciBtYXJrZXJfNzVkZDk5MmMxOGI3NGYxMzg4Mjg1NTgxOTViZmJiYWUgPSBMLm1hcmtlcigKICAgICAgICAgICAgICAgIFs0MC4xNzA5OTgsIC0xMDUuMTYwODc2XSwKICAgICAgICAgICAgICAgIHt9CiAgICAgICAgICAgICkuYWRkVG8obWFya2VyX2NsdXN0ZXJfNWZlYWZjMDJmNjRlNGEyOTg4YzlkY2I5ZTMxMmRhMjUpOwogICAgICAgIAogICAgCiAgICAgICAgdmFyIHBvcHVwX2EzYzgwZTk3Mzk2ODQyOWQ4NWU3NGI2YzI5NDkxNTUxID0gTC5wb3B1cCh7Im1heFdpZHRoIjogIjEwMCUifSk7CgogICAgICAgIAogICAgICAgICAgICB2YXIgaHRtbF9iMjUxZTk2OTU4YWU0YTBhOWU4ZTk2MGJmMDRjZWU1MSA9ICQoYDxkaXYgaWQ9Imh0bWxfYjI1MWU5Njk1OGFlNGEwYTllOGU5NjBiZjA0Y2VlNTEiIHN0eWxlPSJ3aWR0aDogMTAwLjAlOyBoZWlnaHQ6IDEwMC4wJTsiPk5hbWU6IFNPVVRIIEZMQVQgRElUQ0ggUHJlY2lwOiAwLjM4PC9kaXY+YClbMF07CiAgICAgICAgICAgIHBvcHVwX2EzYzgwZTk3Mzk2ODQyOWQ4NWU3NGI2YzI5NDkxNTUxLnNldENvbnRlbnQoaHRtbF9iMjUxZTk2OTU4YWU0YTBhOWU4ZTk2MGJmMDRjZWU1MSk7CiAgICAgICAgCgogICAgICAgIG1hcmtlcl83NWRkOTkyYzE4Yjc0ZjEzODgyODU1ODE5NWJmYmJhZS5iaW5kUG9wdXAocG9wdXBfYTNjODBlOTczOTY4NDI5ZDg1ZTc0YjZjMjk0OTE1NTEpCiAgICAgICAgOwoKICAgICAgICAKICAgIAogICAgCiAgICAgICAgICAgIHZhciBtYXJrZXJfMzQyMTlhMjcwZDgwNDU5ZTgyODBmNzM2OGE3YTU3NmEgPSBMLm1hcmtlcigKICAgICAgICAgICAgICAgIFs0MC4xNTMzNDEsIC0xMDUuMDc1Njk1XSwKICAgICAgICAgICAgICAgIHt9CiAgICAgICAgICAgICkuYWRkVG8obWFya2VyX2NsdXN0ZXJfNWZlYWZjMDJmNjRlNGEyOTg4YzlkY2I5ZTMxMmRhMjUpOwogICAgICAgIAogICAgCiAgICAgICAgdmFyIHBvcHVwX2E2Mzc1MWQ0ZjZhNjQyZWQ4OTA1OWQzMTk3NjA3MGFkID0gTC5wb3B1cCh7Im1heFdpZHRoIjogIjEwMCUifSk7CgogICAgICAgIAogICAgICAgICAgICB2YXIgaHRtbF84NTkyNWE2YmFiYWQ0Y2U2ODM3YjIyNmI2YzY5YTJlZiA9ICQoYDxkaXYgaWQ9Imh0bWxfODU5MjVhNmJhYmFkNGNlNjgzN2IyMjZiNmM2OWEyZWYiIHN0eWxlPSJ3aWR0aDogMTAwLjAlOyBoZWlnaHQ6IDEwMC4wJTsiPk5hbWU6IFNBSU5UIFZSQUlOIENSRUVLIEJFTE9XIEtFTiBQUkFUVCBCTFZEIEFUIExPTkdNT05ULCBDTyBQcmVjaXA6IDMyLjAwPC9kaXY+YClbMF07CiAgICAgICAgICAgIHBvcHVwX2E2Mzc1MWQ0ZjZhNjQyZWQ4OTA1OWQzMTk3NjA3MGFkLnNldENvbnRlbnQoaHRtbF84NTkyNWE2YmFiYWQ0Y2U2ODM3YjIyNmI2YzY5YTJlZik7CiAgICAgICAgCgogICAgICAgIG1hcmtlcl8zNDIxOWEyNzBkODA0NTllODI4MGY3MzY4YTdhNTc2YS5iaW5kUG9wdXAocG9wdXBfYTYzNzUxZDRmNmE2NDJlZDg5MDU5ZDMxOTc2MDcwYWQpCiAgICAgICAgOwoKICAgICAgICAKICAgIAogICAgCiAgICAgICAgICAgIHZhciBtYXJrZXJfZWY5YTA0Y2QxMzNkNDllYjkzMzcyMDhmMmY1NDhlZDkgPSBMLm1hcmtlcigKICAgICAgICAgICAgICAgIFs0MC4wNTM2NjEsIC0xMDUuMTUxMTQzXSwKICAgICAgICAgICAgICAgIHt9CiAgICAgICAgICAgICkuYWRkVG8obWFya2VyX2NsdXN0ZXJfNWZlYWZjMDJmNjRlNGEyOTg4YzlkY2I5ZTMxMmRhMjUpOwogICAgICAgIAogICAgCiAgICAgICAgdmFyIHBvcHVwX2NhOGExMTJkYmFmYjRhZmM5NDE1ODlhOWMyNGRlZTA5ID0gTC5wb3B1cCh7Im1heFdpZHRoIjogIjEwMCUifSk7CgogICAgICAgIAogICAgICAgICAgICB2YXIgaHRtbF9iYWQ0YTQ5OGE3NTE0ZTEwOWQ1ZDdmNThkZTllM2JjNiA9ICQoYDxkaXYgaWQ9Imh0bWxfYmFkNGE0OThhNzUxNGUxMDlkNWQ3ZjU4ZGU5ZTNiYzYiIHN0eWxlPSJ3aWR0aDogMTAwLjAlOyBoZWlnaHQ6IDEwMC4wJTsiPk5hbWU6IExFR0dFVFQgRElUQ0ggUHJlY2lwOiAyLjA2PC9kaXY+YClbMF07CiAgICAgICAgICAgIHBvcHVwX2NhOGExMTJkYmFmYjRhZmM5NDE1ODlhOWMyNGRlZTA5LnNldENvbnRlbnQoaHRtbF9iYWQ0YTQ5OGE3NTE0ZTEwOWQ1ZDdmNThkZTllM2JjNik7CiAgICAgICAgCgogICAgICAgIG1hcmtlcl9lZjlhMDRjZDEzM2Q0OWViOTMzNzIwOGYyZjU0OGVkOS5iaW5kUG9wdXAocG9wdXBfY2E4YTExMmRiYWZiNGFmYzk0MTU4OWE5YzI0ZGVlMDkpCiAgICAgICAgOwoKICAgICAgICAKICAgIAogICAgCiAgICAgICAgICAgIHZhciBtYXJrZXJfZTQ2MWFkNTU0YTRlNGRkYzk2YzI2MmMxYmNlYjMzZTQgPSBMLm1hcmtlcigKICAgICAgICAgICAgICAgIFs0MC4wNTk4MDksIC0xMDUuMDk3ODcyXSwKICAgICAgICAgICAgICAgIHt9CiAgICAgICAgICAgICkuYWRkVG8obWFya2VyX2NsdXN0ZXJfNWZlYWZjMDJmNjRlNGEyOTg4YzlkY2I5ZTMxMmRhMjUpOwogICAgICAgIAogICAgCiAgICAgICAgdmFyIHBvcHVwXzczYzY5MzBhMzVjNjQyNWZhMzI0NDAxNWI2MGJhY2JhID0gTC5wb3B1cCh7Im1heFdpZHRoIjogIjEwMCUifSk7CgogICAgICAgIAogICAgICAgICAgICB2YXIgaHRtbF9mM2ViMDQwNzA5ZTk0OTBhODUxNDgzMTAzMzY2ODY4OCA9ICQoYDxkaXYgaWQ9Imh0bWxfZjNlYjA0MDcwOWU5NDkwYTg1MTQ4MzEwMzM2Njg2ODgiIHN0eWxlPSJ3aWR0aDogMTAwLjAlOyBoZWlnaHQ6IDEwMC4wJTsiPk5hbWU6IEJPVUxERVIgQ1JFRUsgQVQgMTA5IFNUIE5FQVIgRVJJRSwgQ08gUHJlY2lwOiA0Ni44MDwvZGl2PmApWzBdOwogICAgICAgICAgICBwb3B1cF83M2M2OTMwYTM1YzY0MjVmYTMyNDQwMTViNjBiYWNiYS5zZXRDb250ZW50KGh0bWxfZjNlYjA0MDcwOWU5NDkwYTg1MTQ4MzEwMzM2Njg2ODgpOwogICAgICAgIAoKICAgICAgICBtYXJrZXJfZTQ2MWFkNTU0YTRlNGRkYzk2YzI2MmMxYmNlYjMzZTQuYmluZFBvcHVwKHBvcHVwXzczYzY5MzBhMzVjNjQyNWZhMzI0NDAxNWI2MGJhY2JhKQogICAgICAgIDsKCiAgICAgICAgCiAgICAKICAgIAogICAgICAgICAgICB2YXIgbWFya2VyX2JkNDA1ZWM1NzgxYzQ0YTJhYzQxZTAwNGU0MTIyNmU5ID0gTC5tYXJrZXIoCiAgICAgICAgICAgICAgICBbNDAuMjE1NjU4LCAtMTA1LjM2MzQyMl0sCiAgICAgICAgICAgICAgICB7fQogICAgICAgICAgICApLmFkZFRvKG1hcmtlcl9jbHVzdGVyXzVmZWFmYzAyZjY0ZTRhMjk4OGM5ZGNiOWUzMTJkYTI1KTsKICAgICAgICAKICAgIAogICAgICAgIHZhciBwb3B1cF9lYWExYmQ2NjNjMzg0NmMwYjAyOGYzODg0YTI2YTBjZiA9IEwucG9wdXAoeyJtYXhXaWR0aCI6ICIxMDAlIn0pOwoKICAgICAgICAKICAgICAgICAgICAgdmFyIGh0bWxfNDhjYzMwZDI0ODIzNDg5NmFkZTBkMzE2ZDgyYjUzODkgPSAkKGA8ZGl2IGlkPSJodG1sXzQ4Y2MzMGQyNDgyMzQ4OTZhZGUwZDMxNmQ4MmI1Mzg5IiBzdHlsZT0id2lkdGg6IDEwMC4wJTsgaGVpZ2h0OiAxMDAuMCU7Ij5OYW1lOiBOT1JUSCBTQUlOVCBWUkFJTiBDUkVFSyBCRUxPVyBCVVRUT05ST0NLICAoUkFMUEggUFJJQ0UpIFJFU0VSVk9JUiBQcmVjaXA6IDE5LjMwPC9kaXY+YClbMF07CiAgICAgICAgICAgIHBvcHVwX2VhYTFiZDY2M2MzODQ2YzBiMDI4ZjM4ODRhMjZhMGNmLnNldENvbnRlbnQoaHRtbF80OGNjMzBkMjQ4MjM0ODk2YWRlMGQzMTZkODJiNTM4OSk7CiAgICAgICAgCgogICAgICAgIG1hcmtlcl9iZDQwNWVjNTc4MWM0NGEyYWM0MWUwMDRlNDEyMjZlOS5iaW5kUG9wdXAocG9wdXBfZWFhMWJkNjYzYzM4NDZjMGIwMjhmMzg4NGEyNmEwY2YpCiAgICAgICAgOwoKICAgICAgICAKICAgIAogICAgCiAgICAgICAgICAgIHZhciBtYXJrZXJfMTMwOWE3YmQ3MWNmNGJhN2JlYWNkOWEyNTRlZjAzOGUgPSBMLm1hcmtlcigKICAgICAgICAgICAgICAgIFs0MC4xMjYzODksIC0xMDUuMzA0NDA0XSwKICAgICAgICAgICAgICAgIHt9CiAgICAgICAgICAgICkuYWRkVG8obWFya2VyX2NsdXN0ZXJfNWZlYWZjMDJmNjRlNGEyOTg4YzlkY2I5ZTMxMmRhMjUpOwogICAgICAgIAogICAgCiAgICAgICAgdmFyIHBvcHVwX2ZmNTM5MDE2ZTUxMTQ0MjY5YjM2NTc4NDI1YzY4ZjVlID0gTC5wb3B1cCh7Im1heFdpZHRoIjogIjEwMCUifSk7CgogICAgICAgIAogICAgICAgICAgICB2YXIgaHRtbF8wODE3OTE2NDBkM2U0ZjgzODg5NjE3MTJkNzFkNzRlNSA9ICQoYDxkaXYgaWQ9Imh0bWxfMDgxNzkxNjQwZDNlNGY4Mzg4OTYxNzEyZDcxZDc0ZTUiIHN0eWxlPSJ3aWR0aDogMTAwLjAlOyBoZWlnaHQ6IDEwMC4wJTsiPk5hbWU6IExFRlQgSEFORCBDUkVFSyBORUFSIEJPVUxERVIsIENPLiBQcmVjaXA6IDEzLjUwPC9kaXY+YClbMF07CiAgICAgICAgICAgIHBvcHVwX2ZmNTM5MDE2ZTUxMTQ0MjY5YjM2NTc4NDI1YzY4ZjVlLnNldENvbnRlbnQoaHRtbF8wODE3OTE2NDBkM2U0ZjgzODg5NjE3MTJkNzFkNzRlNSk7CiAgICAgICAgCgogICAgICAgIG1hcmtlcl8xMzA5YTdiZDcxY2Y0YmE3YmVhY2Q5YTI1NGVmMDM4ZS5iaW5kUG9wdXAocG9wdXBfZmY1MzkwMTZlNTExNDQyNjliMzY1Nzg0MjVjNjhmNWUpCiAgICAgICAgOwoKICAgICAgICAKICAgIAogICAgCiAgICAgICAgICAgIHZhciBtYXJrZXJfZDBlMjlhOGIyYjNlNDBkZDg0MmE2NjRmM2RiZjQ1MDUgPSBMLm1hcmtlcigKICAgICAgICAgICAgICAgIFs0MC4wODYyNzgsIC0xMDUuMjE3NTE5XSwKICAgICAgICAgICAgICAgIHt9CiAgICAgICAgICAgICkuYWRkVG8obWFya2VyX2NsdXN0ZXJfNWZlYWZjMDJmNjRlNGEyOTg4YzlkY2I5ZTMxMmRhMjUpOwogICAgICAgIAogICAgCiAgICAgICAgdmFyIHBvcHVwXzk0ODczZmJlMTlmNjQ1MDE4YWFiNGU2Y2NkOGNjMGUwID0gTC5wb3B1cCh7Im1heFdpZHRoIjogIjEwMCUifSk7CgogICAgICAgIAogICAgICAgICAgICB2YXIgaHRtbF8wYmUyZmY1YjY4YjQ0N2YzOTI5YzcxMDc5Y2NmNGJkMiA9ICQoYDxkaXYgaWQ9Imh0bWxfMGJlMmZmNWI2OGI0NDdmMzkyOWM3MTA3OWNjZjRiZDIiIHN0eWxlPSJ3aWR0aDogMTAwLjAlOyBoZWlnaHQ6IDEwMC4wJTsiPk5hbWU6IEJPVUxERVIgUkVTRVJWT0lSIElOTEVUIFByZWNpcDogMC4wMDwvZGl2PmApWzBdOwogICAgICAgICAgICBwb3B1cF85NDg3M2ZiZTE5ZjY0NTAxOGFhYjRlNmNjZDhjYzBlMC5zZXRDb250ZW50KGh0bWxfMGJlMmZmNWI2OGI0NDdmMzkyOWM3MTA3OWNjZjRiZDIpOwogICAgICAgIAoKICAgICAgICBtYXJrZXJfZDBlMjlhOGIyYjNlNDBkZDg0MmE2NjRmM2RiZjQ1MDUuYmluZFBvcHVwKHBvcHVwXzk0ODczZmJlMTlmNjQ1MDE4YWFiNGU2Y2NkOGNjMGUwKQogICAgICAgIDsKCiAgICAgICAgCiAgICAKICAgIAogICAgICAgICAgICB2YXIgbWFya2VyXzkzYTFjMDBiZTU5ZTRiYjk5NTk4ZjdhMjA2NTVmNjhkID0gTC5tYXJrZXIoCiAgICAgICAgICAgICAgICBbNDAuMTkzMDE5LCAtMTA1LjIxMDM4OF0sCiAgICAgICAgICAgICAgICB7fQogICAgICAgICAgICApLmFkZFRvKG1hcmtlcl9jbHVzdGVyXzVmZWFmYzAyZjY0ZTRhMjk4OGM5ZGNiOWUzMTJkYTI1KTsKICAgICAgICAKICAgIAogICAgICAgIHZhciBwb3B1cF83YTg2ZWIyN2RmZGM0NTg2YTE0NDkzNGQxMzlkMmY2MCA9IEwucG9wdXAoeyJtYXhXaWR0aCI6ICIxMDAlIn0pOwoKICAgICAgICAKICAgICAgICAgICAgdmFyIGh0bWxfOTI0MTAzZDQ3YTYyNGRjY2EzMzE4YjFhNmJmYzE5NmQgPSAkKGA8ZGl2IGlkPSJodG1sXzkyNDEwM2Q0N2E2MjRkY2NhMzMxOGIxYTZiZmMxOTZkIiBzdHlsZT0id2lkdGg6IDEwMC4wJTsgaGVpZ2h0OiAxMDAuMCU7Ij5OYW1lOiBUUlVFIEFORCBXRUJTVEVSIERJVENIIFByZWNpcDogMC4wMDwvZGl2PmApWzBdOwogICAgICAgICAgICBwb3B1cF83YTg2ZWIyN2RmZGM0NTg2YTE0NDkzNGQxMzlkMmY2MC5zZXRDb250ZW50KGh0bWxfOTI0MTAzZDQ3YTYyNGRjY2EzMzE4YjFhNmJmYzE5NmQpOwogICAgICAgIAoKICAgICAgICBtYXJrZXJfOTNhMWMwMGJlNTllNGJiOTk1OThmN2EyMDY1NWY2OGQuYmluZFBvcHVwKHBvcHVwXzdhODZlYjI3ZGZkYzQ1ODZhMTQ0OTM0ZDEzOWQyZjYwKQogICAgICAgIDsKCiAgICAgICAgCiAgICAKICAgIAogICAgICAgICAgICB2YXIgbWFya2VyXzAyYjcxNzRkYjhhZTQ2ZDc4MDc0Y2YxZWY0MmVhYjc0ID0gTC5tYXJrZXIoCiAgICAgICAgICAgICAgICBbNDAuMjEyNjU4LCAtMTA1LjI1MTgyNl0sCiAgICAgICAgICAgICAgICB7fQogICAgICAgICAgICApLmFkZFRvKG1hcmtlcl9jbHVzdGVyXzVmZWFmYzAyZjY0ZTRhMjk4OGM5ZGNiOWUzMTJkYTI1KTsKICAgICAgICAKICAgIAogICAgICAgIHZhciBwb3B1cF8yNTY2MmZjMWExNDY0OWQ0OTFmM2EwZDA0ZDM2NjgzNSA9IEwucG9wdXAoeyJtYXhXaWR0aCI6ICIxMDAlIn0pOwoKICAgICAgICAKICAgICAgICAgICAgdmFyIGh0bWxfZGY1MzIyZDk1ZDUxNDk4MjkyNTBkZjUxN2IyMDQ5NjAgPSAkKGA8ZGl2IGlkPSJodG1sX2RmNTMyMmQ5NWQ1MTQ5ODI5MjUwZGY1MTdiMjA0OTYwIiBzdHlsZT0id2lkdGg6IDEwMC4wJTsgaGVpZ2h0OiAxMDAuMCU7Ij5OYW1lOiBST1VHSCBBTkQgUkVBRFkgRElUQ0ggUHJlY2lwOiAwLjAwPC9kaXY+YClbMF07CiAgICAgICAgICAgIHBvcHVwXzI1NjYyZmMxYTE0NjQ5ZDQ5MWYzYTBkMDRkMzY2ODM1LnNldENvbnRlbnQoaHRtbF9kZjUzMjJkOTVkNTE0OTgyOTI1MGRmNTE3YjIwNDk2MCk7CiAgICAgICAgCgogICAgICAgIG1hcmtlcl8wMmI3MTc0ZGI4YWU0NmQ3ODA3NGNmMWVmNDJlYWI3NC5iaW5kUG9wdXAocG9wdXBfMjU2NjJmYzFhMTQ2NDlkNDkxZjNhMGQwNGQzNjY4MzUpCiAgICAgICAgOwoKICAgICAgICAKICAgIAogICAgCiAgICAgICAgICAgIHZhciBtYXJrZXJfNzBmOWIzODE5YjQzNDNjMThiMTM2ZDIxOTY2MDFjNTUgPSBMLm1hcmtlcigKICAgICAgICAgICAgICAgIFs0MC4xNzQ4NDQsIC0xMDUuMTY3ODczXSwKICAgICAgICAgICAgICAgIHt9CiAgICAgICAgICAgICkuYWRkVG8obWFya2VyX2NsdXN0ZXJfNWZlYWZjMDJmNjRlNGEyOTg4YzlkY2I5ZTMxMmRhMjUpOwogICAgICAgIAogICAgCiAgICAgICAgdmFyIHBvcHVwX2I0YWU4ODc1OWNmMzQyYjA4YTM3NDBhYjgwN2I2NjIzID0gTC5wb3B1cCh7Im1heFdpZHRoIjogIjEwMCUifSk7CgogICAgICAgIAogICAgICAgICAgICB2YXIgaHRtbF8wZjkzNjFjYzU3ZTQ0YTY1OTQ5OTQzZjQ5ZDFiZWFjMCA9ICQoYDxkaXYgaWQ9Imh0bWxfMGY5MzYxY2M1N2U0NGE2NTk0OTk0M2Y0OWQxYmVhYzAiIHN0eWxlPSJ3aWR0aDogMTAwLjAlOyBoZWlnaHQ6IDEwMC4wJTsiPk5hbWU6IEhBR0VSIE1FQURPV1MgRElUQ0ggUHJlY2lwOiAwLjE1PC9kaXY+YClbMF07CiAgICAgICAgICAgIHBvcHVwX2I0YWU4ODc1OWNmMzQyYjA4YTM3NDBhYjgwN2I2NjIzLnNldENvbnRlbnQoaHRtbF8wZjkzNjFjYzU3ZTQ0YTY1OTQ5OTQzZjQ5ZDFiZWFjMCk7CiAgICAgICAgCgogICAgICAgIG1hcmtlcl83MGY5YjM4MTliNDM0M2MxOGIxMzZkMjE5NjYwMWM1NS5iaW5kUG9wdXAocG9wdXBfYjRhZTg4NzU5Y2YzNDJiMDhhMzc0MGFiODA3YjY2MjMpCiAgICAgICAgOwoKICAgICAgICAKICAgIAogICAgCiAgICAgICAgICAgIHZhciBtYXJrZXJfM2MzZTQ5OTE0MjE0NGM0NTg1Y2I1NWI0NTZhMTE5YzkgPSBMLm1hcmtlcigKICAgICAgICAgICAgICAgIFs0MC4yNTYyNzYsIC0xMDUuMjA5NDE2XSwKICAgICAgICAgICAgICAgIHt9CiAgICAgICAgICAgICkuYWRkVG8obWFya2VyX2NsdXN0ZXJfNWZlYWZjMDJmNjRlNGEyOTg4YzlkY2I5ZTMxMmRhMjUpOwogICAgICAgIAogICAgCiAgICAgICAgdmFyIHBvcHVwXzQzZjVlMjRjZGFmYjRkMzlhMGZlMDQ4MzhhMDkyZmUxID0gTC5wb3B1cCh7Im1heFdpZHRoIjogIjEwMCUifSk7CgogICAgICAgIAogICAgICAgICAgICB2YXIgaHRtbF8zYTlmOGNlY2QzYmU0ODMxYmU4MTkyNzdmMDE4Y2VkZiA9ICQoYDxkaXYgaWQ9Imh0bWxfM2E5ZjhjZWNkM2JlNDgzMWJlODE5Mjc3ZjAxOGNlZGYiIHN0eWxlPSJ3aWR0aDogMTAwLjAlOyBoZWlnaHQ6IDEwMC4wJTsiPk5hbWU6IExJVFRMRSBUSE9NUFNPTiAjMSBESVRDSCBQcmVjaXA6IDAuMDA8L2Rpdj5gKVswXTsKICAgICAgICAgICAgcG9wdXBfNDNmNWUyNGNkYWZiNGQzOWEwZmUwNDgzOGEwOTJmZTEuc2V0Q29udGVudChodG1sXzNhOWY4Y2VjZDNiZTQ4MzFiZTgxOTI3N2YwMThjZWRmKTsKICAgICAgICAKCiAgICAgICAgbWFya2VyXzNjM2U0OTkxNDIxNDRjNDU4NWNiNTViNDU2YTExOWM5LmJpbmRQb3B1cChwb3B1cF80M2Y1ZTI0Y2RhZmI0ZDM5YTBmZTA0ODM4YTA5MmZlMSkKICAgICAgICA7CgogICAgICAgIAogICAgCiAgICAKICAgICAgICAgICAgdmFyIG1hcmtlcl81YjczMDJkYWMyZWY0YjhiOTQxYTc0MmI3NWZlZDYwOCA9IEwubWFya2VyKAogICAgICAgICAgICAgICAgWzQwLjI2MDgyNywgLTEwNS4xOTg1NjddLAogICAgICAgICAgICAgICAge30KICAgICAgICAgICAgKS5hZGRUbyhtYXJrZXJfY2x1c3Rlcl81ZmVhZmMwMmY2NGU0YTI5ODhjOWRjYjllMzEyZGEyNSk7CiAgICAgICAgCiAgICAKICAgICAgICB2YXIgcG9wdXBfZTJkZTlhOWY5MTZmNGNiOWJkMzcyYzFmYjcwYmZlZDQgPSBMLnBvcHVwKHsibWF4V2lkdGgiOiAiMTAwJSJ9KTsKCiAgICAgICAgCiAgICAgICAgICAgIHZhciBodG1sX2MzMWQ4ZjVjMjI0NTRiZmQ5YzM4MjEzMzViYzliYzAzID0gJChgPGRpdiBpZD0iaHRtbF9jMzFkOGY1YzIyNDU0YmZkOWMzODIxMzM1YmM5YmMwMyIgc3R5bGU9IndpZHRoOiAxMDAuMCU7IGhlaWdodDogMTAwLjAlOyI+TmFtZTogQ1VMVkVSIERJVENIIFByZWNpcDogMC4wMDwvZGl2PmApWzBdOwogICAgICAgICAgICBwb3B1cF9lMmRlOWE5ZjkxNmY0Y2I5YmQzNzJjMWZiNzBiZmVkNC5zZXRDb250ZW50KGh0bWxfYzMxZDhmNWMyMjQ1NGJmZDljMzgyMTMzNWJjOWJjMDMpOwogICAgICAgIAoKICAgICAgICBtYXJrZXJfNWI3MzAyZGFjMmVmNGI4Yjk0MWE3NDJiNzVmZWQ2MDguYmluZFBvcHVwKHBvcHVwX2UyZGU5YTlmOTE2ZjRjYjliZDM3MmMxZmI3MGJmZWQ0KQogICAgICAgIDsKCiAgICAgICAgCiAgICAKICAgIAogICAgICAgICAgICB2YXIgbWFya2VyXzE5YzA1ZWQ5NzRjNjRkYWU5YjExMjJlYTQ5ZmQyNDQ2ID0gTC5tYXJrZXIoCiAgICAgICAgICAgICAgICBbNDAuMjE1MDQzLCAtMTA1LjI1NjAxN10sCiAgICAgICAgICAgICAgICB7fQogICAgICAgICAgICApLmFkZFRvKG1hcmtlcl9jbHVzdGVyXzVmZWFmYzAyZjY0ZTRhMjk4OGM5ZGNiOWUzMTJkYTI1KTsKICAgICAgICAKICAgIAogICAgICAgIHZhciBwb3B1cF8wOGViNzYzYzk3MTg0NmI2YmU4MzYzMjJjYjE1NzQyNyA9IEwucG9wdXAoeyJtYXhXaWR0aCI6ICIxMDAlIn0pOwoKICAgICAgICAKICAgICAgICAgICAgdmFyIGh0bWxfYjk3YmNmZWJhMzE5NDE3YjllNDM5MWUwY2EzZTUxMWUgPSAkKGA8ZGl2IGlkPSJodG1sX2I5N2JjZmViYTMxOTQxN2I5ZTQzOTFlMGNhM2U1MTFlIiBzdHlsZT0id2lkdGg6IDEwMC4wJTsgaGVpZ2h0OiAxMDAuMCU7Ij5OYW1lOiBISUdITEFORCBESVRDSCBBVCBMWU9OUywgQ08gUHJlY2lwOiAzNS42MDwvZGl2PmApWzBdOwogICAgICAgICAgICBwb3B1cF8wOGViNzYzYzk3MTg0NmI2YmU4MzYzMjJjYjE1NzQyNy5zZXRDb250ZW50KGh0bWxfYjk3YmNmZWJhMzE5NDE3YjllNDM5MWUwY2EzZTUxMWUpOwogICAgICAgIAoKICAgICAgICBtYXJrZXJfMTljMDVlZDk3NGM2NGRhZTliMTEyMmVhNDlmZDI0NDYuYmluZFBvcHVwKHBvcHVwXzA4ZWI3NjNjOTcxODQ2YjZiZTgzNjMyMmNiMTU3NDI3KQogICAgICAgIDsKCiAgICAgICAgCiAgICAKICAgIAogICAgICAgICAgICB2YXIgbWFya2VyXzJiMGRhMWJlN2RmYjQ0N2ViMjUzOGUzNzZkNjU2MWNmID0gTC5tYXJrZXIoCiAgICAgICAgICAgICAgICBbNDAuMDc4NTYsIC0xMDUuMjIwNDk3XSwKICAgICAgICAgICAgICAgIHt9CiAgICAgICAgICAgICkuYWRkVG8obWFya2VyX2NsdXN0ZXJfNWZlYWZjMDJmNjRlNGEyOTg4YzlkY2I5ZTMxMmRhMjUpOwogICAgICAgIAogICAgCiAgICAgICAgdmFyIHBvcHVwXzQ5YTQ2N2EyZjIyODQ5NGY5N2ExMTAyYWZjNmJlMDVlID0gTC5wb3B1cCh7Im1heFdpZHRoIjogIjEwMCUifSk7CgogICAgICAgIAogICAgICAgICAgICB2YXIgaHRtbF81ZDVkY2M4YmFlZjQ0MzBmODllYjYzMjA5NDE3MTRlYSA9ICQoYDxkaXYgaWQ9Imh0bWxfNWQ1ZGNjOGJhZWY0NDMwZjg5ZWI2MzIwOTQxNzE0ZWEiIHN0eWxlPSJ3aWR0aDogMTAwLjAlOyBoZWlnaHQ6IDEwMC4wJTsiPk5hbWU6IEJPVUxERVIgUkVTRVJWT0lSIFByZWNpcDogNTEzMi41MDwvZGl2PmApWzBdOwogICAgICAgICAgICBwb3B1cF80OWE0NjdhMmYyMjg0OTRmOTdhMTEwMmFmYzZiZTA1ZS5zZXRDb250ZW50KGh0bWxfNWQ1ZGNjOGJhZWY0NDMwZjg5ZWI2MzIwOTQxNzE0ZWEpOwogICAgICAgIAoKICAgICAgICBtYXJrZXJfMmIwZGExYmU3ZGZiNDQ3ZWIyNTM4ZTM3NmQ2NTYxY2YuYmluZFBvcHVwKHBvcHVwXzQ5YTQ2N2EyZjIyODQ5NGY5N2ExMTAyYWZjNmJlMDVlKQogICAgICAgIDsKCiAgICAgICAgCiAgICAKICAgIAogICAgICAgICAgICB2YXIgbWFya2VyXzYwM2M0NDY1ZTFkYjQ3NjlhMjFjNjhmOTY4NWUzMmU4ID0gTC5tYXJrZXIoCiAgICAgICAgICAgICAgICBbNDAuMTczOTUsIC0xMDUuMTY5Mzc0XSwKICAgICAgICAgICAgICAgIHt9CiAgICAgICAgICAgICkuYWRkVG8obWFya2VyX2NsdXN0ZXJfNWZlYWZjMDJmNjRlNGEyOTg4YzlkY2I5ZTMxMmRhMjUpOwogICAgICAgIAogICAgCiAgICAgICAgdmFyIHBvcHVwXzI1MjIwNjQ5OTIxYjRiZmU4YzQ3NDg0ZDkwMDQwNjgwID0gTC5wb3B1cCh7Im1heFdpZHRoIjogIjEwMCUifSk7CgogICAgICAgIAogICAgICAgICAgICB2YXIgaHRtbF84NWNmMTg1YWE2NjQ0ZTE1OWUzOWRkMGYxNGRlZjk0MiA9ICQoYDxkaXYgaWQ9Imh0bWxfODVjZjE4NWFhNjY0NGUxNTllMzlkZDBmMTRkZWY5NDIiIHN0eWxlPSJ3aWR0aDogMTAwLjAlOyBoZWlnaHQ6IDEwMC4wJTsiPk5hbWU6IE5JV09UIERJVENIIFByZWNpcDogMC4xOTwvZGl2PmApWzBdOwogICAgICAgICAgICBwb3B1cF8yNTIyMDY0OTkyMWI0YmZlOGM0NzQ4NGQ5MDA0MDY4MC5zZXRDb250ZW50KGh0bWxfODVjZjE4NWFhNjY0NGUxNTllMzlkZDBmMTRkZWY5NDIpOwogICAgICAgIAoKICAgICAgICBtYXJrZXJfNjAzYzQ0NjVlMWRiNDc2OWEyMWM2OGY5Njg1ZTMyZTguYmluZFBvcHVwKHBvcHVwXzI1MjIwNjQ5OTIxYjRiZmU4YzQ3NDg0ZDkwMDQwNjgwKQogICAgICAgIDsKCiAgICAgICAgCiAgICAKICAgIAogICAgICAgICAgICB2YXIgbWFya2VyXzk4Y2EwNTgyMzM1ZTQ1MzNhODIxNGNjMTBiNDhiMWViID0gTC5tYXJrZXIoCiAgICAgICAgICAgICAgICBbNDAuMjExMzg5LCAtMTA1LjI1MDk1Ml0sCiAgICAgICAgICAgICAgICB7fQogICAgICAgICAgICApLmFkZFRvKG1hcmtlcl9jbHVzdGVyXzVmZWFmYzAyZjY0ZTRhMjk4OGM5ZGNiOWUzMTJkYTI1KTsKICAgICAgICAKICAgIAogICAgICAgIHZhciBwb3B1cF82NWRkMmU2YjYyYmQ0MzMyYThjNTYxMDE1OTE3MmUxZSA9IEwucG9wdXAoeyJtYXhXaWR0aCI6ICIxMDAlIn0pOwoKICAgICAgICAKICAgICAgICAgICAgdmFyIGh0bWxfYzkxYThkZmEyYTJiNDc5NmI2ZjY4M2QzNTJlODhmNTYgPSAkKGA8ZGl2IGlkPSJodG1sX2M5MWE4ZGZhMmEyYjQ3OTZiNmY2ODNkMzUyZTg4ZjU2IiBzdHlsZT0id2lkdGg6IDEwMC4wJTsgaGVpZ2h0OiAxMDAuMCU7Ij5OYW1lOiBTTUVBRCBESVRDSCBQcmVjaXA6IDAuMDA8L2Rpdj5gKVswXTsKICAgICAgICAgICAgcG9wdXBfNjVkZDJlNmI2MmJkNDMzMmE4YzU2MTAxNTkxNzJlMWUuc2V0Q29udGVudChodG1sX2M5MWE4ZGZhMmEyYjQ3OTZiNmY2ODNkMzUyZTg4ZjU2KTsKICAgICAgICAKCiAgICAgICAgbWFya2VyXzk4Y2EwNTgyMzM1ZTQ1MzNhODIxNGNjMTBiNDhiMWViLmJpbmRQb3B1cChwb3B1cF82NWRkMmU2YjYyYmQ0MzMyYThjNTYxMDE1OTE3MmUxZSkKICAgICAgICA7CgogICAgICAgIAogICAgCiAgICAKICAgICAgICAgICAgdmFyIG1hcmtlcl9mN2QyNzA5MTYwNDk0ZjYxYTY0MTA4NzdjN2VmMWI1MCA9IEwubWFya2VyKAogICAgICAgICAgICAgICAgWzM5LjkzODM1MSwgLTEwNS4zNDc5MDZdLAogICAgICAgICAgICAgICAge30KICAgICAgICAgICAgKS5hZGRUbyhtYXJrZXJfY2x1c3Rlcl81ZmVhZmMwMmY2NGU0YTI5ODhjOWRjYjllMzEyZGEyNSk7CiAgICAgICAgCiAgICAKICAgICAgICB2YXIgcG9wdXBfYjdiY2Y0MmNmNmQ0NGI2NGI1Zjc3ZTIyZDJhNmQ2MjggPSBMLnBvcHVwKHsibWF4V2lkdGgiOiAiMTAwJSJ9KTsKCiAgICAgICAgCiAgICAgICAgICAgIHZhciBodG1sX2UyODI2MzkxMTdmOTRiNjE5NzQ4Y2M3NDMxNDE0Mzc4ID0gJChgPGRpdiBpZD0iaHRtbF9lMjgyNjM5MTE3Zjk0YjYxOTc0OGNjNzQzMTQxNDM3OCIgc3R5bGU9IndpZHRoOiAxMDAuMCU7IGhlaWdodDogMTAwLjAlOyI+TmFtZTogU09VVEggQk9VTERFUiBDUkVFSyBCRUxPVyBHUk9TUyBSRVNFUlZPSVIgUHJlY2lwOiAxNi40MDwvZGl2PmApWzBdOwogICAgICAgICAgICBwb3B1cF9iN2JjZjQyY2Y2ZDQ0YjY0YjVmNzdlMjJkMmE2ZDYyOC5zZXRDb250ZW50KGh0bWxfZTI4MjYzOTExN2Y5NGI2MTk3NDhjYzc0MzE0MTQzNzgpOwogICAgICAgIAoKICAgICAgICBtYXJrZXJfZjdkMjcwOTE2MDQ5NGY2MWE2NDEwODc3YzdlZjFiNTAuYmluZFBvcHVwKHBvcHVwX2I3YmNmNDJjZjZkNDRiNjRiNWY3N2UyMmQyYTZkNjI4KQogICAgICAgIDsKCiAgICAgICAgCiAgICAKICAgIAogICAgICAgICAgICB2YXIgbWFya2VyX2Y2MDYxZGJlYWJhZDQyNzY4OWJkZDg3NjNkMjQ5YTI5ID0gTC5tYXJrZXIoCiAgICAgICAgICAgICAgICBbNDAuMjE4MzM1LCAtMTA1LjI1ODExXSwKICAgICAgICAgICAgICAgIHt9CiAgICAgICAgICAgICkuYWRkVG8obWFya2VyX2NsdXN0ZXJfNWZlYWZjMDJmNjRlNGEyOTg4YzlkY2I5ZTMxMmRhMjUpOwogICAgICAgIAogICAgCiAgICAgICAgdmFyIHBvcHVwXzI3YWYxNGU1MjA2MTQ5NjdhZWU0N2M3ZWM5YmE1NjhiID0gTC5wb3B1cCh7Im1heFdpZHRoIjogIjEwMCUifSk7CgogICAgICAgIAogICAgICAgICAgICB2YXIgaHRtbF8xNmQzZDQzOTM2ZGY0NGExYmZmZWRmZWQyZDYxMDE2YSA9ICQoYDxkaXYgaWQ9Imh0bWxfMTZkM2Q0MzkzNmRmNDRhMWJmZmVkZmVkMmQ2MTAxNmEiIHN0eWxlPSJ3aWR0aDogMTAwLjAlOyBoZWlnaHQ6IDEwMC4wJTsiPk5hbWU6IFNBSU5UIFZSQUlOIFNVUFBMWSBDQU5BTCBORUFSIExZT05TLCBDTyBQcmVjaXA6IDUwLjMwPC9kaXY+YClbMF07CiAgICAgICAgICAgIHBvcHVwXzI3YWYxNGU1MjA2MTQ5NjdhZWU0N2M3ZWM5YmE1NjhiLnNldENvbnRlbnQoaHRtbF8xNmQzZDQzOTM2ZGY0NGExYmZmZWRmZWQyZDYxMDE2YSk7CiAgICAgICAgCgogICAgICAgIG1hcmtlcl9mNjA2MWRiZWFiYWQ0Mjc2ODliZGQ4NzYzZDI0OWEyOS5iaW5kUG9wdXAocG9wdXBfMjdhZjE0ZTUyMDYxNDk2N2FlZTQ3YzdlYzliYTU2OGIpCiAgICAgICAgOwoKICAgICAgICAKICAgIAogICAgCiAgICAgICAgICAgIHZhciBtYXJrZXJfNDU0NDg5ZDQyMzZmNDZiZDk3MGExNjUyMWFjZjVjZTUgPSBMLm1hcmtlcigKICAgICAgICAgICAgICAgIFs0MC4xNTMzNjMsIC0xMDUuMDg4Njk1XSwKICAgICAgICAgICAgICAgIHt9CiAgICAgICAgICAgICkuYWRkVG8obWFya2VyX2NsdXN0ZXJfNWZlYWZjMDJmNjRlNGEyOTg4YzlkY2I5ZTMxMmRhMjUpOwogICAgICAgIAogICAgCiAgICAgICAgdmFyIHBvcHVwXzZiZWFlZTU1ZmNkZTQxYTZiNjY0ZjhkMGE5NzQxZTU1ID0gTC5wb3B1cCh7Im1heFdpZHRoIjogIjEwMCUifSk7CgogICAgICAgIAogICAgICAgICAgICB2YXIgaHRtbF82M2ViZDViOGQzNjg0NzgxYWQ0YjJmYWZmNTg3ZTlmNiA9ICQoYDxkaXYgaWQ9Imh0bWxfNjNlYmQ1YjhkMzY4NDc4MWFkNGIyZmFmZjU4N2U5ZjYiIHN0eWxlPSJ3aWR0aDogMTAwLjAlOyBoZWlnaHQ6IDEwMC4wJTsiPk5hbWU6IEJPTlVTIERJVENIIFByZWNpcDogMC4xMDwvZGl2PmApWzBdOwogICAgICAgICAgICBwb3B1cF82YmVhZWU1NWZjZGU0MWE2YjY2NGY4ZDBhOTc0MWU1NS5zZXRDb250ZW50KGh0bWxfNjNlYmQ1YjhkMzY4NDc4MWFkNGIyZmFmZjU4N2U5ZjYpOwogICAgICAgIAoKICAgICAgICBtYXJrZXJfNDU0NDg5ZDQyMzZmNDZiZDk3MGExNjUyMWFjZjVjZTUuYmluZFBvcHVwKHBvcHVwXzZiZWFlZTU1ZmNkZTQxYTZiNjY0ZjhkMGE5NzQxZTU1KQogICAgICAgIDsKCiAgICAgICAgCiAgICAKICAgIAogICAgICAgICAgICB2YXIgbWFya2VyXzk2MDU4NGExNDA1MDQ3MTFiYjA5Zjk2NWMxMjhlZjBlID0gTC5tYXJrZXIoCiAgICAgICAgICAgICAgICBbMzkuOTYxNjU1LCAtMTA1LjUwNDQ0XSwKICAgICAgICAgICAgICAgIHt9CiAgICAgICAgICAgICkuYWRkVG8obWFya2VyX2NsdXN0ZXJfNWZlYWZjMDJmNjRlNGEyOTg4YzlkY2I5ZTMxMmRhMjUpOwogICAgICAgIAogICAgCiAgICAgICAgdmFyIHBvcHVwXzM4MmEyOGVmMjUyODQ2OWZhOGI5ZTM1NDQ3YjQxNGI3ID0gTC5wb3B1cCh7Im1heFdpZHRoIjogIjEwMCUifSk7CgogICAgICAgIAogICAgICAgICAgICB2YXIgaHRtbF9lYWEyZmEyZTgwNDc0NzQxODFkYzQwMDQyMTcyNjFhZSA9ICQoYDxkaXYgaWQ9Imh0bWxfZWFhMmZhMmU4MDQ3NDc0MTgxZGM0MDA0MjE3MjYxYWUiIHN0eWxlPSJ3aWR0aDogMTAwLjAlOyBoZWlnaHQ6IDEwMC4wJTsiPk5hbWU6IE1JRERMRSBCT1VMREVSIENSRUVLIEFUIE5FREVSTEFORCwgQ08uIFByZWNpcDogMjUuMjA8L2Rpdj5gKVswXTsKICAgICAgICAgICAgcG9wdXBfMzgyYTI4ZWYyNTI4NDY5ZmE4YjllMzU0NDdiNDE0Yjcuc2V0Q29udGVudChodG1sX2VhYTJmYTJlODA0NzQ3NDE4MWRjNDAwNDIxNzI2MWFlKTsKICAgICAgICAKCiAgICAgICAgbWFya2VyXzk2MDU4NGExNDA1MDQ3MTFiYjA5Zjk2NWMxMjhlZjBlLmJpbmRQb3B1cChwb3B1cF8zODJhMjhlZjI1Mjg0NjlmYThiOWUzNTQ0N2I0MTRiNykKICAgICAgICA7CgogICAgICAgIAogICAgCiAgICAKICAgICAgICAgICAgdmFyIG1hcmtlcl9lZGQ0ZTU2MTEyYzc0MjRiYmI1N2E1NzJjN2QyOTFlMSA9IEwubWFya2VyKAogICAgICAgICAgICAgICAgWzQwLjIxMTA4MywgLTEwNS4yNTA5MjddLAogICAgICAgICAgICAgICAge30KICAgICAgICAgICAgKS5hZGRUbyhtYXJrZXJfY2x1c3Rlcl81ZmVhZmMwMmY2NGU0YTI5ODhjOWRjYjllMzEyZGEyNSk7CiAgICAgICAgCiAgICAKICAgICAgICB2YXIgcG9wdXBfMWM0ODZhMDc4YWI0NDljMDk2YmRlNjkxNTFhZDFjY2YgPSBMLnBvcHVwKHsibWF4V2lkdGgiOiAiMTAwJSJ9KTsKCiAgICAgICAgCiAgICAgICAgICAgIHZhciBodG1sX2ZhMDliZGMxOTY5ZjQ4NjRiZjM0NTc4NmFkYmFiZWMxID0gJChgPGRpdiBpZD0iaHRtbF9mYTA5YmRjMTk2OWY0ODY0YmYzNDU3ODZhZGJhYmVjMSIgc3R5bGU9IndpZHRoOiAxMDAuMCU7IGhlaWdodDogMTAwLjAlOyI+TmFtZTogU1dFREUgRElUQ0ggUHJlY2lwOiAwLjAwPC9kaXY+YClbMF07CiAgICAgICAgICAgIHBvcHVwXzFjNDg2YTA3OGFiNDQ5YzA5NmJkZTY5MTUxYWQxY2NmLnNldENvbnRlbnQoaHRtbF9mYTA5YmRjMTk2OWY0ODY0YmYzNDU3ODZhZGJhYmVjMSk7CiAgICAgICAgCgogICAgICAgIG1hcmtlcl9lZGQ0ZTU2MTEyYzc0MjRiYmI1N2E1NzJjN2QyOTFlMS5iaW5kUG9wdXAocG9wdXBfMWM0ODZhMDc4YWI0NDljMDk2YmRlNjkxNTFhZDFjY2YpCiAgICAgICAgOwoKICAgICAgICAKICAgIAogICAgCiAgICAgICAgICAgIHZhciBtYXJrZXJfYmE5MWY4N2FjZmY1NDYxODllMGQ3MWM0N2Q2ZGRhMjEgPSBMLm1hcmtlcigKICAgICAgICAgICAgICAgIFs0MC4xODc1MjQsIC0xMDUuMTg5MTMyXSwKICAgICAgICAgICAgICAgIHt9CiAgICAgICAgICAgICkuYWRkVG8obWFya2VyX2NsdXN0ZXJfNWZlYWZjMDJmNjRlNGEyOTg4YzlkY2I5ZTMxMmRhMjUpOwogICAgICAgIAogICAgCiAgICAgICAgdmFyIHBvcHVwXzY2NTk4MzZiMzI2MDRjYTVhOTc3NjVmNzZkY2YwMWI0ID0gTC5wb3B1cCh7Im1heFdpZHRoIjogIjEwMCUifSk7CgogICAgICAgIAogICAgICAgICAgICB2YXIgaHRtbF81NTU4MWFmZTMxOWU0NGY3YWQ5MTFhMjQ5ZDc1ZWFiNSA9ICQoYDxkaXYgaWQ9Imh0bWxfNTU1ODFhZmUzMTllNDRmN2FkOTExYTI0OWQ3NWVhYjUiIHN0eWxlPSJ3aWR0aDogMTAwLjAlOyBoZWlnaHQ6IDEwMC4wJTsiPk5hbWU6IFJVTllPTiBESVRDSCBQcmVjaXA6IDAuMDA8L2Rpdj5gKVswXTsKICAgICAgICAgICAgcG9wdXBfNjY1OTgzNmIzMjYwNGNhNWE5Nzc2NWY3NmRjZjAxYjQuc2V0Q29udGVudChodG1sXzU1NTgxYWZlMzE5ZTQ0ZjdhZDkxMWEyNDlkNzVlYWI1KTsKICAgICAgICAKCiAgICAgICAgbWFya2VyX2JhOTFmODdhY2ZmNTQ2MTg5ZTBkNzFjNDdkNmRkYTIxLmJpbmRQb3B1cChwb3B1cF82NjU5ODM2YjMyNjA0Y2E1YTk3NzY1Zjc2ZGNmMDFiNCkKICAgICAgICA7CgogICAgICAgIAogICAgCiAgICAKICAgICAgICAgICAgdmFyIG1hcmtlcl80Yjc4NTIxOTkzZjg0N2RlYTkwYTFjNTdmZjYzNjE5MCA9IEwubWFya2VyKAogICAgICAgICAgICAgICAgWzQwLjE4MTg4LCAtMTA1LjE5Njc3NV0sCiAgICAgICAgICAgICAgICB7fQogICAgICAgICAgICApLmFkZFRvKG1hcmtlcl9jbHVzdGVyXzVmZWFmYzAyZjY0ZTRhMjk4OGM5ZGNiOWUzMTJkYTI1KTsKICAgICAgICAKICAgIAogICAgICAgIHZhciBwb3B1cF8wN2EzMDBkYWVmOTE0MWY2OTk3ODlkM2RkMmE3ZDEzYSA9IEwucG9wdXAoeyJtYXhXaWR0aCI6ICIxMDAlIn0pOwoKICAgICAgICAKICAgICAgICAgICAgdmFyIGh0bWxfNTMzMzcwODA3ZmIxNGYwZWI2MzRiNDNlNmY5NDVlMTIgPSAkKGA8ZGl2IGlkPSJodG1sXzUzMzM3MDgwN2ZiMTRmMGViNjM0YjQzZTZmOTQ1ZTEyIiBzdHlsZT0id2lkdGg6IDEwMC4wJTsgaGVpZ2h0OiAxMDAuMCU7Ij5OYW1lOiBEQVZJUyBBTkQgRE9XTklORyBESVRDSCBQcmVjaXA6IDAuMDA8L2Rpdj5gKVswXTsKICAgICAgICAgICAgcG9wdXBfMDdhMzAwZGFlZjkxNDFmNjk5Nzg5ZDNkZDJhN2QxM2Euc2V0Q29udGVudChodG1sXzUzMzM3MDgwN2ZiMTRmMGViNjM0YjQzZTZmOTQ1ZTEyKTsKICAgICAgICAKCiAgICAgICAgbWFya2VyXzRiNzg1MjE5OTNmODQ3ZGVhOTBhMWM1N2ZmNjM2MTkwLmJpbmRQb3B1cChwb3B1cF8wN2EzMDBkYWVmOTE0MWY2OTk3ODlkM2RkMmE3ZDEzYSkKICAgICAgICA7CgogICAgICAgIAogICAgCiAgICAKICAgICAgICAgICAgdmFyIG1hcmtlcl82NDUxZDQ1YTM3MzE0ZmQ0ODQ5Mzg2MzIxOGE2ZDUzYiA9IEwubWFya2VyKAogICAgICAgICAgICAgICAgWzQwLjAxODY2NywgLTEwNS4zMjYyNV0sCiAgICAgICAgICAgICAgICB7fQogICAgICAgICAgICApLmFkZFRvKG1hcmtlcl9jbHVzdGVyXzVmZWFmYzAyZjY0ZTRhMjk4OGM5ZGNiOWUzMTJkYTI1KTsKICAgICAgICAKICAgIAogICAgICAgIHZhciBwb3B1cF81Y2I2YmI4NGNhYjM0ZTZhOWFmZDZiZmQ3NzY4MmM3OCA9IEwucG9wdXAoeyJtYXhXaWR0aCI6ICIxMDAlIn0pOwoKICAgICAgICAKICAgICAgICAgICAgdmFyIGh0bWxfMGEyYjA4MTUxMTAwNDljZjhmNWFmODViZDcwMDIzZTUgPSAkKGA8ZGl2IGlkPSJodG1sXzBhMmIwODE1MTEwMDQ5Y2Y4ZjVhZjg1YmQ3MDAyM2U1IiBzdHlsZT0id2lkdGg6IDEwMC4wJTsgaGVpZ2h0OiAxMDAuMCU7Ij5OYW1lOiBGT1VSTUlMRSBDUkVFSyBBVCBPUk9ERUxMLCBDTyBQcmVjaXA6IDAuNzQ8L2Rpdj5gKVswXTsKICAgICAgICAgICAgcG9wdXBfNWNiNmJiODRjYWIzNGU2YTlhZmQ2YmZkNzc2ODJjNzguc2V0Q29udGVudChodG1sXzBhMmIwODE1MTEwMDQ5Y2Y4ZjVhZjg1YmQ3MDAyM2U1KTsKICAgICAgICAKCiAgICAgICAgbWFya2VyXzY0NTFkNDVhMzczMTRmZDQ4NDkzODYzMjE4YTZkNTNiLmJpbmRQb3B1cChwb3B1cF81Y2I2YmI4NGNhYjM0ZTZhOWFmZDZiZmQ3NzY4MmM3OCkKICAgICAgICA7CgogICAgICAgIAogICAgCiAgICAKICAgICAgICAgICAgdmFyIG1hcmtlcl9hNTliMGYzOGMyMGM0NzIyYTUzMjJhY2ZkYzVmYjkwOCA9IEwubWFya2VyKAogICAgICAgICAgICAgICAgWzQwLjE4ODU3OSwgLTEwNS4yMDkyODJdLAogICAgICAgICAgICAgICAge30KICAgICAgICAgICAgKS5hZGRUbyhtYXJrZXJfY2x1c3Rlcl81ZmVhZmMwMmY2NGU0YTI5ODhjOWRjYjllMzEyZGEyNSk7CiAgICAgICAgCiAgICAKICAgICAgICB2YXIgcG9wdXBfY2M3ZGM2ZGJjYTc3NDI5NTlmNDJlZDMzY2Q1YzliNDQgPSBMLnBvcHVwKHsibWF4V2lkdGgiOiAiMTAwJSJ9KTsKCiAgICAgICAgCiAgICAgICAgICAgIHZhciBodG1sXzFhZWRlNTJlYjA4ZjQzZDg4MDU4YmZlOTQxNjc4YWRiID0gJChgPGRpdiBpZD0iaHRtbF8xYWVkZTUyZWIwOGY0M2Q4ODA1OGJmZTk0MTY3OGFkYiIgc3R5bGU9IndpZHRoOiAxMDAuMCU7IGhlaWdodDogMTAwLjAlOyI+TmFtZTogSkFNRVMgRElUQ0ggUHJlY2lwOiAwLjAwPC9kaXY+YClbMF07CiAgICAgICAgICAgIHBvcHVwX2NjN2RjNmRiY2E3NzQyOTU5ZjQyZWQzM2NkNWM5YjQ0LnNldENvbnRlbnQoaHRtbF8xYWVkZTUyZWIwOGY0M2Q4ODA1OGJmZTk0MTY3OGFkYik7CiAgICAgICAgCgogICAgICAgIG1hcmtlcl9hNTliMGYzOGMyMGM0NzIyYTUzMjJhY2ZkYzVmYjkwOC5iaW5kUG9wdXAocG9wdXBfY2M3ZGM2ZGJjYTc3NDI5NTlmNDJlZDMzY2Q1YzliNDQpCiAgICAgICAgOwoKICAgICAgICAKICAgIAogICAgCiAgICAgICAgICAgIHZhciBtYXJrZXJfYjkxN2U5ZTZkNDJlNDZhMzhjMDU3NmYxOWI2MWQ0YmMgPSBMLm1hcmtlcigKICAgICAgICAgICAgICAgIFs0MC4wNTMwMzUsIC0xMDUuMTkzMDQ4XSwKICAgICAgICAgICAgICAgIHt9CiAgICAgICAgICAgICkuYWRkVG8obWFya2VyX2NsdXN0ZXJfNWZlYWZjMDJmNjRlNGEyOTg4YzlkY2I5ZTMxMmRhMjUpOwogICAgICAgIAogICAgCiAgICAgICAgdmFyIHBvcHVwXzcwMTU3NDczN2RjZTRiM2JhZjJjMmViMDBhMjZjM2I3ID0gTC5wb3B1cCh7Im1heFdpZHRoIjogIjEwMCUifSk7CgogICAgICAgIAogICAgICAgICAgICB2YXIgaHRtbF9jMmQ3ODNiNjY2NTg0ZWZlOGEzOWIwMTMzNjBhZGY0NiA9ICQoYDxkaXYgaWQ9Imh0bWxfYzJkNzgzYjY2NjU4NGVmZThhMzliMDEzMzYwYWRmNDYiIHN0eWxlPSJ3aWR0aDogMTAwLjAlOyBoZWlnaHQ6IDEwMC4wJTsiPk5hbWU6IEJPVUxERVIgQ1JFRUsgU1VQUExZIENBTkFMIFRPIEJPVUxERVIgQ1JFRUsgTkVBUiBCT1VMREVSIFByZWNpcDogNC42MjwvZGl2PmApWzBdOwogICAgICAgICAgICBwb3B1cF83MDE1NzQ3MzdkY2U0YjNiYWYyYzJlYjAwYTI2YzNiNy5zZXRDb250ZW50KGh0bWxfYzJkNzgzYjY2NjU4NGVmZThhMzliMDEzMzYwYWRmNDYpOwogICAgICAgIAoKICAgICAgICBtYXJrZXJfYjkxN2U5ZTZkNDJlNDZhMzhjMDU3NmYxOWI2MWQ0YmMuYmluZFBvcHVwKHBvcHVwXzcwMTU3NDczN2RjZTRiM2JhZjJjMmViMDBhMjZjM2I3KQogICAgICAgIDsKCiAgICAgICAgCiAgICAKICAgIAogICAgICAgICAgICB2YXIgbWFya2VyXzZjNjQyZjMxMzNjNDQ5M2E4NGZiNTg1YzE5MWE4YThjID0gTC5tYXJrZXIoCiAgICAgICAgICAgICAgICBbNDAuMTc3NDIzLCAtMTA1LjE3ODE0NV0sCiAgICAgICAgICAgICAgICB7fQogICAgICAgICAgICApLmFkZFRvKG1hcmtlcl9jbHVzdGVyXzVmZWFmYzAyZjY0ZTRhMjk4OGM5ZGNiOWUzMTJkYTI1KTsKICAgICAgICAKICAgIAogICAgICAgIHZhciBwb3B1cF84NDMzMjg3YTI4ZjE0MDM1OGJiY2ViYjE2YjY3MmE4NSA9IEwucG9wdXAoeyJtYXhXaWR0aCI6ICIxMDAlIn0pOwoKICAgICAgICAKICAgICAgICAgICAgdmFyIGh0bWxfNDU0MWFhZWQyOTgxNDFlZTg4YWRhYzk5MWRiMzQ2OTggPSAkKGA8ZGl2IGlkPSJodG1sXzQ1NDFhYWVkMjk4MTQxZWU4OGFkYWM5OTFkYjM0Njk4IiBzdHlsZT0id2lkdGg6IDEwMC4wJTsgaGVpZ2h0OiAxMDAuMCU7Ij5OYW1lOiBTQUlOVCBWUkFJTiBDUkVFSyBBVCBIWUdJRU5FLCBDTyBQcmVjaXA6IDIuMTQ8L2Rpdj5gKVswXTsKICAgICAgICAgICAgcG9wdXBfODQzMzI4N2EyOGYxNDAzNThiYmNlYmIxNmI2NzJhODUuc2V0Q29udGVudChodG1sXzQ1NDFhYWVkMjk4MTQxZWU4OGFkYWM5OTFkYjM0Njk4KTsKICAgICAgICAKCiAgICAgICAgbWFya2VyXzZjNjQyZjMxMzNjNDQ5M2E4NGZiNTg1YzE5MWE4YThjLmJpbmRQb3B1cChwb3B1cF84NDMzMjg3YTI4ZjE0MDM1OGJiY2ViYjE2YjY3MmE4NSkKICAgICAgICA7CgogICAgICAgIAogICAgCiAgICAKICAgICAgICAgICAgdmFyIG1hcmtlcl84ZDE4YzE1ZjljNDc0MDAwOWZkYTVmZTdiOTM0N2MwYiA9IEwubWFya2VyKAogICAgICAgICAgICAgICAgWzQwLjI1ODM2NywgLTEwNS4xNzQ5NTddLAogICAgICAgICAgICAgICAge30KICAgICAgICAgICAgKS5hZGRUbyhtYXJrZXJfY2x1c3Rlcl81ZmVhZmMwMmY2NGU0YTI5ODhjOWRjYjllMzEyZGEyNSk7CiAgICAgICAgCiAgICAKICAgICAgICB2YXIgcG9wdXBfMjE3YWFkZGY4MDViNDk0N2FkZjVhMjdiYTQ2NDJkNGQgPSBMLnBvcHVwKHsibWF4V2lkdGgiOiAiMTAwJSJ9KTsKCiAgICAgICAgCiAgICAgICAgICAgIHZhciBodG1sX2U5MGFiOGY5MGZjZjRmMGFhMDAzZTk1ZDVjNjg1YmQwID0gJChgPGRpdiBpZD0iaHRtbF9lOTBhYjhmOTBmY2Y0ZjBhYTAwM2U5NWQ1YzY4NWJkMCIgc3R5bGU9IndpZHRoOiAxMDAuMCU7IGhlaWdodDogMTAwLjAlOyI+TmFtZTogQk9VTERFUi1MQVJJTUVSIERJVENIIE5FQVIgQkVSVEhPVUQgUHJlY2lwOiAwLjAwPC9kaXY+YClbMF07CiAgICAgICAgICAgIHBvcHVwXzIxN2FhZGRmODA1YjQ5NDdhZGY1YTI3YmE0NjQyZDRkLnNldENvbnRlbnQoaHRtbF9lOTBhYjhmOTBmY2Y0ZjBhYTAwM2U5NWQ1YzY4NWJkMCk7CiAgICAgICAgCgogICAgICAgIG1hcmtlcl84ZDE4YzE1ZjljNDc0MDAwOWZkYTVmZTdiOTM0N2MwYi5iaW5kUG9wdXAocG9wdXBfMjE3YWFkZGY4MDViNDk0N2FkZjVhMjdiYTQ2NDJkNGQpCiAgICAgICAgOwoKICAgICAgICAKICAgIAogICAgCiAgICAgICAgICAgIHZhciBtYXJrZXJfMTFhNWUyZWU5NGFlNDc1NThjMmRlNDI2ZDVjNTM2ZGEgPSBMLm1hcmtlcigKICAgICAgICAgICAgICAgIFs0MC4wOTYwMywgLTEwNS4wOTEwNTldLAogICAgICAgICAgICAgICAge30KICAgICAgICAgICAgKS5hZGRUbyhtYXJrZXJfY2x1c3Rlcl81ZmVhZmMwMmY2NGU0YTI5ODhjOWRjYjllMzEyZGEyNSk7CiAgICAgICAgCiAgICAKICAgICAgICB2YXIgcG9wdXBfN2JjNGVmMTlmYTEwNDNkMzg5MjZkYzQ1NzBjMGU0ZGQgPSBMLnBvcHVwKHsibWF4V2lkdGgiOiAiMTAwJSJ9KTsKCiAgICAgICAgCiAgICAgICAgICAgIHZhciBodG1sXzg5OGE0ZmVmMWRjNTRkNzZhYzViYWE2Yzc5M2EzNDA3ID0gJChgPGRpdiBpZD0iaHRtbF84OThhNGZlZjFkYzU0ZDc2YWM1YmFhNmM3OTNhMzQwNyIgc3R5bGU9IndpZHRoOiAxMDAuMCU7IGhlaWdodDogMTAwLjAlOyI+TmFtZTogUEFOQU1BIFJFU0VSVk9JUiBJTkxFVCBQcmVjaXA6IDIyLjEwPC9kaXY+YClbMF07CiAgICAgICAgICAgIHBvcHVwXzdiYzRlZjE5ZmExMDQzZDM4OTI2ZGM0NTcwYzBlNGRkLnNldENvbnRlbnQoaHRtbF84OThhNGZlZjFkYzU0ZDc2YWM1YmFhNmM3OTNhMzQwNyk7CiAgICAgICAgCgogICAgICAgIG1hcmtlcl8xMWE1ZTJlZTk0YWU0NzU1OGMyZGU0MjZkNWM1MzZkYS5iaW5kUG9wdXAocG9wdXBfN2JjNGVmMTlmYTEwNDNkMzg5MjZkYzQ1NzBjMGU0ZGQpCiAgICAgICAgOwoKICAgICAgICAKICAgIAogICAgCiAgICAgICAgICAgIHZhciBtYXJrZXJfOWMzNWRlNDNmNjlhNDgzNzk2ZjA4YjIzZTViNzJhZGYgPSBMLm1hcmtlcigKICAgICAgICAgICAgICAgIFs0MC4yMTI1MDUsIC0xMDUuMjUxODI2XSwKICAgICAgICAgICAgICAgIHt9CiAgICAgICAgICAgICkuYWRkVG8obWFya2VyX2NsdXN0ZXJfNWZlYWZjMDJmNjRlNGEyOTg4YzlkY2I5ZTMxMmRhMjUpOwogICAgICAgIAogICAgCiAgICAgICAgdmFyIHBvcHVwX2RmMDVmYTJlZTJlMDRmOTU4NWZmOTg4MTU1NGNjMjA5ID0gTC5wb3B1cCh7Im1heFdpZHRoIjogIjEwMCUifSk7CgogICAgICAgIAogICAgICAgICAgICB2YXIgaHRtbF8xN2UyYmFlNTcyN2M0MmE5OWExMjM5MDdjZTJkNWNiNCA9ICQoYDxkaXYgaWQ9Imh0bWxfMTdlMmJhZTU3MjdjNDJhOTlhMTIzOTA3Y2UyZDVjYjQiIHN0eWxlPSJ3aWR0aDogMTAwLjAlOyBoZWlnaHQ6IDEwMC4wJTsiPk5hbWU6IFBBTE1FUlRPTiBESVRDSCBQcmVjaXA6IDAuMjc8L2Rpdj5gKVswXTsKICAgICAgICAgICAgcG9wdXBfZGYwNWZhMmVlMmUwNGY5NTg1ZmY5ODgxNTU0Y2MyMDkuc2V0Q29udGVudChodG1sXzE3ZTJiYWU1NzI3YzQyYTk5YTEyMzkwN2NlMmQ1Y2I0KTsKICAgICAgICAKCiAgICAgICAgbWFya2VyXzljMzVkZTQzZjY5YTQ4Mzc5NmYwOGIyM2U1YjcyYWRmLmJpbmRQb3B1cChwb3B1cF9kZjA1ZmEyZWUyZTA0Zjk1ODVmZjk4ODE1NTRjYzIwOSkKICAgICAgICA7CgogICAgICAgIAogICAgCiAgICAKICAgICAgICAgICAgdmFyIG1hcmtlcl8yYWNhZGE5NjRkZjk0M2ExYjFjMzZiZTAwMDMzODA1ZiA9IEwubWFya2VyKAogICAgICAgICAgICAgICAgWzQwLjIxOTA0NiwgLTEwNS4yNTk3OTVdLAogICAgICAgICAgICAgICAge30KICAgICAgICAgICAgKS5hZGRUbyhtYXJrZXJfY2x1c3Rlcl81ZmVhZmMwMmY2NGU0YTI5ODhjOWRjYjllMzEyZGEyNSk7CiAgICAgICAgCiAgICAKICAgICAgICB2YXIgcG9wdXBfMTM1YTZhMzU5YjM5NGU4ZTk0Zjk3OTVjNzMwNTJjZmIgPSBMLnBvcHVwKHsibWF4V2lkdGgiOiAiMTAwJSJ9KTsKCiAgICAgICAgCiAgICAgICAgICAgIHZhciBodG1sX2UxOWNmYmU0Nzc5ZjRiMDc4Yzg1MjEzMjY2YjU2Y2E1ID0gJChgPGRpdiBpZD0iaHRtbF9lMTljZmJlNDc3OWY0YjA3OGM4NTIxMzI2NmI1NmNhNSIgc3R5bGU9IndpZHRoOiAxMDAuMCU7IGhlaWdodDogMTAwLjAlOyI+TmFtZTogU1VQUExZIERJVENIIFByZWNpcDogMC4wMDwvZGl2PmApWzBdOwogICAgICAgICAgICBwb3B1cF8xMzVhNmEzNTliMzk0ZThlOTRmOTc5NWM3MzA1MmNmYi5zZXRDb250ZW50KGh0bWxfZTE5Y2ZiZTQ3NzlmNGIwNzhjODUyMTMyNjZiNTZjYTUpOwogICAgICAgIAoKICAgICAgICBtYXJrZXJfMmFjYWRhOTY0ZGY5NDNhMWIxYzM2YmUwMDAzMzgwNWYuYmluZFBvcHVwKHBvcHVwXzEzNWE2YTM1OWIzOTRlOGU5NGY5Nzk1YzczMDUyY2ZiKQogICAgICAgIDsKCiAgICAgICAgCiAgICAKICAgIAogICAgICAgICAgICB2YXIgbWFya2VyXzk0NjIyOTIyZjUzZDQ3ZWI4MTBmOTljY2EwN2Q4OTU4ID0gTC5tYXJrZXIoCiAgICAgICAgICAgICAgICBbMzkuOTMxODEzLCAtMTA1LjMwODQzMl0sCiAgICAgICAgICAgICAgICB7fQogICAgICAgICAgICApLmFkZFRvKG1hcmtlcl9jbHVzdGVyXzVmZWFmYzAyZjY0ZTRhMjk4OGM5ZGNiOWUzMTJkYTI1KTsKICAgICAgICAKICAgIAogICAgICAgIHZhciBwb3B1cF8wZmU0YTRiMDFiNjM0MDdiOTA4OWU4ZTIyNWU4NTgyZCA9IEwucG9wdXAoeyJtYXhXaWR0aCI6ICIxMDAlIn0pOwoKICAgICAgICAKICAgICAgICAgICAgdmFyIGh0bWxfZjU5ZjliOGI4YWNmNDc2NTkzOGI3MDhlZDljODUwMjAgPSAkKGA8ZGl2IGlkPSJodG1sX2Y1OWY5YjhiOGFjZjQ3NjU5MzhiNzA4ZWQ5Yzg1MDIwIiBzdHlsZT0id2lkdGg6IDEwMC4wJTsgaGVpZ2h0OiAxMDAuMCU7Ij5OYW1lOiBTT1VUSCBCT1VMREVSIENSRUVLIERJVkVSU0lPTiBORUFSIEVMRE9SQURPIFNQUklOR1MgUHJlY2lwOiAwLjAwPC9kaXY+YClbMF07CiAgICAgICAgICAgIHBvcHVwXzBmZTRhNGIwMWI2MzQwN2I5MDg5ZThlMjI1ZTg1ODJkLnNldENvbnRlbnQoaHRtbF9mNTlmOWI4YjhhY2Y0NzY1OTM4YjcwOGVkOWM4NTAyMCk7CiAgICAgICAgCgogICAgICAgIG1hcmtlcl85NDYyMjkyMmY1M2Q0N2ViODEwZjk5Y2NhMDdkODk1OC5iaW5kUG9wdXAocG9wdXBfMGZlNGE0YjAxYjYzNDA3YjkwODllOGUyMjVlODU4MmQpCiAgICAgICAgOwoKICAgICAgICAKICAgIAogICAgCiAgICAgICAgICAgIHZhciBtYXJrZXJfYmZhODZjYzMzMDE1NDI0MzlhZmY4YTk4ZjkyYWIxMDMgPSBMLm1hcmtlcigKICAgICAgICAgICAgICAgIFs0MC4xODc1NzgsIC0xMDUuMTg5MTkxXSwKICAgICAgICAgICAgICAgIHt9CiAgICAgICAgICAgICkuYWRkVG8obWFya2VyX2NsdXN0ZXJfNWZlYWZjMDJmNjRlNGEyOTg4YzlkY2I5ZTMxMmRhMjUpOwogICAgICAgIAogICAgCiAgICAgICAgdmFyIHBvcHVwXzgwNTkyMTU0NWFkODRlYjBhYTk4M2JmYTgzMmQ1YmJmID0gTC5wb3B1cCh7Im1heFdpZHRoIjogIjEwMCUifSk7CgogICAgICAgIAogICAgICAgICAgICB2YXIgaHRtbF8zMWM1YjdmNzAzMmQ0M2RmYWQxOWFiZjgxNTdkYjA3NCA9ICQoYDxkaXYgaWQ9Imh0bWxfMzFjNWI3ZjcwMzJkNDNkZmFkMTlhYmY4MTU3ZGIwNzQiIHN0eWxlPSJ3aWR0aDogMTAwLjAlOyBoZWlnaHQ6IDEwMC4wJTsiPk5hbWU6IERFTklPIFRBWUxPUiBESVRDSCBQcmVjaXA6IDI4MTkuMDA8L2Rpdj5gKVswXTsKICAgICAgICAgICAgcG9wdXBfODA1OTIxNTQ1YWQ4NGViMGFhOTgzYmZhODMyZDViYmYuc2V0Q29udGVudChodG1sXzMxYzViN2Y3MDMyZDQzZGZhZDE5YWJmODE1N2RiMDc0KTsKICAgICAgICAKCiAgICAgICAgbWFya2VyX2JmYTg2Y2MzMzAxNTQyNDM5YWZmOGE5OGY5MmFiMTAzLmJpbmRQb3B1cChwb3B1cF84MDU5MjE1NDVhZDg0ZWIwYWE5ODNiZmE4MzJkNWJiZikKICAgICAgICA7CgogICAgICAgIAogICAgCiAgICAKICAgICAgICAgICAgdmFyIG1hcmtlcl80NTg0NGZjODE2ZWI0YTEzYmFjNDQzY2FlNTdhOTNlZSA9IEwubWFya2VyKAogICAgICAgICAgICAgICAgWzQwLjA0MjAyOCwgLTEwNS4zNjQ5MTddLAogICAgICAgICAgICAgICAge30KICAgICAgICAgICAgKS5hZGRUbyhtYXJrZXJfY2x1c3Rlcl81ZmVhZmMwMmY2NGU0YTI5ODhjOWRjYjllMzEyZGEyNSk7CiAgICAgICAgCiAgICAKICAgICAgICB2YXIgcG9wdXBfYTVhYjdhMDQwYTU2NDlkZDk4YTk3Nzg1MmNlMjIxNGYgPSBMLnBvcHVwKHsibWF4V2lkdGgiOiAiMTAwJSJ9KTsKCiAgICAgICAgCiAgICAgICAgICAgIHZhciBodG1sXzMzOWVhODE2Y2IwMTRmYzdiYzI0NDQ3NWZiZTc4YTYwID0gJChgPGRpdiBpZD0iaHRtbF8zMzllYTgxNmNiMDE0ZmM3YmMyNDQ0NzVmYmU3OGE2MCIgc3R5bGU9IndpZHRoOiAxMDAuMCU7IGhlaWdodDogMTAwLjAlOyI+TmFtZTogRk9VUk1JTEUgQ1JFRUsgQVQgTE9HQU4gTUlMTCBST0FEIE5FQVIgQ1JJU01BTiwgQ08gUHJlY2lwOiBuYW48L2Rpdj5gKVswXTsKICAgICAgICAgICAgcG9wdXBfYTVhYjdhMDQwYTU2NDlkZDk4YTk3Nzg1MmNlMjIxNGYuc2V0Q29udGVudChodG1sXzMzOWVhODE2Y2IwMTRmYzdiYzI0NDQ3NWZiZTc4YTYwKTsKICAgICAgICAKCiAgICAgICAgbWFya2VyXzQ1ODQ0ZmM4MTZlYjRhMTNiYWM0NDNjYWU1N2E5M2VlLmJpbmRQb3B1cChwb3B1cF9hNWFiN2EwNDBhNTY0OWRkOThhOTc3ODUyY2UyMjE0ZikKICAgICAgICA7CgogICAgICAgIAogICAgCiAgICAKICAgICAgICAgICAgdmFyIG1hcmtlcl82NTVlMTYwNDE4NjE0ZmU5YTkxNmJmOTA2NDgwZWZjMyA9IEwubWFya2VyKAogICAgICAgICAgICAgICAgWzQwLjE3NzA4LCAtMTA1LjE3ODU2N10sCiAgICAgICAgICAgICAgICB7fQogICAgICAgICAgICApLmFkZFRvKG1hcmtlcl9jbHVzdGVyXzVmZWFmYzAyZjY0ZTRhMjk4OGM5ZGNiOWUzMTJkYTI1KTsKICAgICAgICAKICAgIAogICAgICAgIHZhciBwb3B1cF9jMDY2NDUwMzgxNzE0Nzk1OTMyZmM2YmFmMzQyOWE1NCA9IEwucG9wdXAoeyJtYXhXaWR0aCI6ICIxMDAlIn0pOwoKICAgICAgICAKICAgICAgICAgICAgdmFyIGh0bWxfZmZiMTI5Nzg5ZmI0NDNkY2E2ZjU5OWUxMTM2ZDgxYWEgPSAkKGA8ZGl2IGlkPSJodG1sX2ZmYjEyOTc4OWZiNDQzZGNhNmY1OTllMTEzNmQ4MWFhIiBzdHlsZT0id2lkdGg6IDEwMC4wJTsgaGVpZ2h0OiAxMDAuMCU7Ij5OYW1lOiBQRUNLIFBFTExBIENMT1ZFUiBESVRDSCBQcmVjaXA6IDEuMjk8L2Rpdj5gKVswXTsKICAgICAgICAgICAgcG9wdXBfYzA2NjQ1MDM4MTcxNDc5NTkzMmZjNmJhZjM0MjlhNTQuc2V0Q29udGVudChodG1sX2ZmYjEyOTc4OWZiNDQzZGNhNmY1OTllMTEzNmQ4MWFhKTsKICAgICAgICAKCiAgICAgICAgbWFya2VyXzY1NWUxNjA0MTg2MTRmZTlhOTE2YmY5MDY0ODBlZmMzLmJpbmRQb3B1cChwb3B1cF9jMDY2NDUwMzgxNzE0Nzk1OTMyZmM2YmFmMzQyOWE1NCkKICAgICAgICA7CgogICAgICAgIAogICAgCiAgICAKICAgICAgICAgICAgdmFyIG1hcmtlcl80N2ZkMjlmZDBkNWE0NDdhODBkZGU3NTMyYTU0ZTcxNSA9IEwubWFya2VyKAogICAgICAgICAgICAgICAgWzM5Ljk0NzcwNCwgLTEwNS4zNTczMDhdLAogICAgICAgICAgICAgICAge30KICAgICAgICAgICAgKS5hZGRUbyhtYXJrZXJfY2x1c3Rlcl81ZmVhZmMwMmY2NGU0YTI5ODhjOWRjYjllMzEyZGEyNSk7CiAgICAgICAgCiAgICAKICAgICAgICB2YXIgcG9wdXBfMDgyY2MzZmNmNjE2NDlkNzk1MTVlYzE2OGY0NWFmMzggPSBMLnBvcHVwKHsibWF4V2lkdGgiOiAiMTAwJSJ9KTsKCiAgICAgICAgCiAgICAgICAgICAgIHZhciBodG1sXzg5OGE3MjA5ZTk0NjRkNzliMDEzNTY0Y2U1MWRlNjFiID0gJChgPGRpdiBpZD0iaHRtbF84OThhNzIwOWU5NDY0ZDc5YjAxMzU2NGNlNTFkZTYxYiIgc3R5bGU9IndpZHRoOiAxMDAuMCU7IGhlaWdodDogMTAwLjAlOyI+TmFtZTogR1JPU1MgUkVTRVJWT0lSICBQcmVjaXA6IDExMzk2LjAwPC9kaXY+YClbMF07CiAgICAgICAgICAgIHBvcHVwXzA4MmNjM2ZjZjYxNjQ5ZDc5NTE1ZWMxNjhmNDVhZjM4LnNldENvbnRlbnQoaHRtbF84OThhNzIwOWU5NDY0ZDc5YjAxMzU2NGNlNTFkZTYxYik7CiAgICAgICAgCgogICAgICAgIG1hcmtlcl80N2ZkMjlmZDBkNWE0NDdhODBkZGU3NTMyYTU0ZTcxNS5iaW5kUG9wdXAocG9wdXBfMDgyY2MzZmNmNjE2NDlkNzk1MTVlYzE2OGY0NWFmMzgpCiAgICAgICAgOwoKICAgICAgICAKICAgIAo8L3NjcmlwdD4=" style="position:absolute;width:100%;height:100%;left:0;top:0;border:none !important;" allowfullscreen webkitallowfullscreen mozallowfullscreen></iframe></div></div>





<div class="notice--info" markdown="1">

## Additional Resources

* <a href="https://blog.datafiniti.co/4-reasons-you-should-use-json-instead-of-csv-2cac362f1943" target="_blank">Why you should use JSON instead of csv.</a>


* <a href="https://www.w3schools.com/js/js_json_intro.asp" target="_blank">W3schools JSON intro </a>

</div>

