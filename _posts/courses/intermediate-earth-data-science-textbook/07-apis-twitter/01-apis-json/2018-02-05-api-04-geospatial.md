---
layout: single
title: 'Programmatically Accessing Geospatial Data Using APIs'
excerpt: 'This lesson walks through the process of retrieving and manipulating surface water data housed in the Colorado Information Warehouse. These data are stored in JSON format with spatial x, y information that support mapping.'
authors: ['Leah Wasser', 'Max Joseph', 'Martha Morrissey', 'Jenny Palomino', 'Carson Farmer']
modified: 2020-03-24
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



    [{'station_name': 'GROSS RESERVOIR ',
      'div': '1',
      'location': {'latitude': '39.947704',
       'needs_recoding': False,
       'longitude': '-105.357308'},
      'dwr_abbrev': 'GROSRECO',
      'data_source': 'Co. Division of Water Resources',
      'amount': '11368.00',
      'station_type': 'Reservoir',
      'wd': '6',
      'http_linkage': {'url': 'https://dwr.state.co.us/SurfaceWater/data/detail_graph.aspx?ID=GROSRECO&MTYPE=STORAGE'},
      'date_time': '2020-03-24T08:30:00.000',
      'county': 'BOULDER',
      'variable': 'STORAGE',
      'stage': '7175.62',
      'station_status': 'Active'},
     {'station_name': 'PECK PELLA CLOVER DITCH',
      'div': '1',
      'location': {'latitude': '40.17708',
       'needs_recoding': False,
       'longitude': '-105.178567'},
      'dwr_abbrev': 'PCKPELCO',
      'data_source': 'Cooperative SDR Program of CDWR & NCWCD',
      'amount': '1.42',
      'station_type': 'Diversion',
      'wd': '5',
      'http_linkage': {'url': 'https://dwr.state.co.us/SurfaceWater/data/detail_graph.aspx?ID=PCKPELCO&MTYPE=DISCHRG'},
      'date_time': '2020-03-24T09:00:00.000',
      'county': 'BOULDER',
      'variable': 'DISCHRG',
      'stage': '0.17',
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
      <td>GROSS RESERVOIR</td>
      <td>1</td>
      <td>GROSRECO</td>
      <td>Co. Division of Water Resources</td>
      <td>11368.00</td>
      <td>Reservoir</td>
      <td>6</td>
      <td>2020-03-24T08:30:00.000</td>
      <td>BOULDER</td>
      <td>STORAGE</td>
      <td>7175.62</td>
      <td>Active</td>
      <td>39.947704</td>
      <td>False</td>
      <td>-105.357308</td>
      <td>https://dwr.state.co.us/SurfaceWater/data/deta...</td>
      <td>NaN</td>
      <td>NaN</td>
    </tr>
    <tr>
      <th>1</th>
      <td>PECK PELLA CLOVER DITCH</td>
      <td>1</td>
      <td>PCKPELCO</td>
      <td>Cooperative SDR Program of CDWR &amp; NCWCD</td>
      <td>1.42</td>
      <td>Diversion</td>
      <td>5</td>
      <td>2020-03-24T09:00:00.000</td>
      <td>BOULDER</td>
      <td>DISCHRG</td>
      <td>0.17</td>
      <td>Active</td>
      <td>40.17708</td>
      <td>False</td>
      <td>-105.178567</td>
      <td>https://dwr.state.co.us/SurfaceWater/data/deta...</td>
      <td>NaN</td>
      <td>NaN</td>
    </tr>
    <tr>
      <th>2</th>
      <td>FOURMILE CREEK AT LOGAN MILL ROAD NEAR CRISMAN...</td>
      <td>1</td>
      <td>FRMLMRCO</td>
      <td>U.S. Geological Survey</td>
      <td>NaN</td>
      <td>Stream</td>
      <td>6</td>
      <td>1999-09-30T00:00:00.000</td>
      <td>BOULDER</td>
      <td>DISCHRG</td>
      <td>NaN</td>
      <td>Active</td>
      <td>40.042028</td>
      <td>False</td>
      <td>-105.364917</td>
      <td>https://waterdata.usgs.gov/nwis/uv?06727410</td>
      <td>06727410</td>
      <td>NaN</td>
    </tr>
    <tr>
      <th>3</th>
      <td>DENIO TAYLOR DITCH</td>
      <td>1</td>
      <td>DENTAYCO</td>
      <td>Cooperative Program of CDWR, NCWCD &amp; SVLHWCD</td>
      <td>2819.68</td>
      <td>Diversion</td>
      <td>5</td>
      <td>2020-03-24T09:00:00.000</td>
      <td>BOULDER</td>
      <td>DISCHRG</td>
      <td>62.31</td>
      <td>Active</td>
      <td>40.187578</td>
      <td>False</td>
      <td>-105.189191</td>
      <td>https://dwr.state.co.us/SurfaceWater/data/deta...</td>
      <td>NaN</td>
      <td>NaN</td>
    </tr>
    <tr>
      <th>4</th>
      <td>SUPPLY DITCH</td>
      <td>1</td>
      <td>SUPDITCO</td>
      <td>Cooperative Program of CDWR, NCWCD &amp; SVLHWCD</td>
      <td>0.00</td>
      <td>Diversion</td>
      <td>5</td>
      <td>2020-03-24T08:45:00.000</td>
      <td>BOULDER</td>
      <td>DISCHRG</td>
      <td>0.00</td>
      <td>Active</td>
      <td>40.219046</td>
      <td>False</td>
      <td>-105.259795</td>
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



    '39.947704'





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



    39.947704





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



    -105.357308





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
      <td>GROSS RESERVOIR</td>
      <td>1</td>
      <td>GROSRECO</td>
      <td>Co. Division of Water Resources</td>
      <td>11368.00</td>
      <td>Reservoir</td>
      <td>6</td>
      <td>2020-03-24T08:30:00.000</td>
      <td>BOULDER</td>
      <td>STORAGE</td>
      <td>7175.62</td>
      <td>Active</td>
      <td>39.947704</td>
      <td>False</td>
      <td>-105.357308</td>
      <td>https://dwr.state.co.us/SurfaceWater/data/deta...</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>POINT (-105.35731 39.94770)</td>
    </tr>
    <tr>
      <th>1</th>
      <td>PECK PELLA CLOVER DITCH</td>
      <td>1</td>
      <td>PCKPELCO</td>
      <td>Cooperative SDR Program of CDWR &amp; NCWCD</td>
      <td>1.42</td>
      <td>Diversion</td>
      <td>5</td>
      <td>2020-03-24T09:00:00.000</td>
      <td>BOULDER</td>
      <td>DISCHRG</td>
      <td>0.17</td>
      <td>Active</td>
      <td>40.177080</td>
      <td>False</td>
      <td>-105.178567</td>
      <td>https://dwr.state.co.us/SurfaceWater/data/deta...</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>POINT (-105.17857 40.17708)</td>
    </tr>
    <tr>
      <th>2</th>
      <td>FOURMILE CREEK AT LOGAN MILL ROAD NEAR CRISMAN...</td>
      <td>1</td>
      <td>FRMLMRCO</td>
      <td>U.S. Geological Survey</td>
      <td>NaN</td>
      <td>Stream</td>
      <td>6</td>
      <td>1999-09-30T00:00:00.000</td>
      <td>BOULDER</td>
      <td>DISCHRG</td>
      <td>NaN</td>
      <td>Active</td>
      <td>40.042028</td>
      <td>False</td>
      <td>-105.364917</td>
      <td>https://waterdata.usgs.gov/nwis/uv?06727410</td>
      <td>06727410</td>
      <td>NaN</td>
      <td>POINT (-105.36492 40.04203)</td>
    </tr>
    <tr>
      <th>3</th>
      <td>DENIO TAYLOR DITCH</td>
      <td>1</td>
      <td>DENTAYCO</td>
      <td>Cooperative Program of CDWR, NCWCD &amp; SVLHWCD</td>
      <td>2819.68</td>
      <td>Diversion</td>
      <td>5</td>
      <td>2020-03-24T09:00:00.000</td>
      <td>BOULDER</td>
      <td>DISCHRG</td>
      <td>62.31</td>
      <td>Active</td>
      <td>40.187578</td>
      <td>False</td>
      <td>-105.189191</td>
      <td>https://dwr.state.co.us/SurfaceWater/data/deta...</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>POINT (-105.18919 40.18758)</td>
    </tr>
    <tr>
      <th>4</th>
      <td>SUPPLY DITCH</td>
      <td>1</td>
      <td>SUPDITCO</td>
      <td>Cooperative Program of CDWR, NCWCD &amp; SVLHWCD</td>
      <td>0.00</td>
      <td>Diversion</td>
      <td>5</td>
      <td>2020-03-24T08:45:00.000</td>
      <td>BOULDER</td>
      <td>DISCHRG</td>
      <td>0.00</td>
      <td>Active</td>
      <td>40.219046</td>
      <td>False</td>
      <td>-105.259795</td>
      <td>https://dwr.state.co.us/SurfaceWater/data/deta...</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>POINT (-105.25979 40.21905)</td>
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



<div style="width:100%;"><div style="position:relative;width:100%;height:0;padding-bottom:60%;"><iframe src="data:text/html;charset=utf-8;base64,PCFET0NUWVBFIGh0bWw+CjxoZWFkPiAgICAKICAgIDxtZXRhIGh0dHAtZXF1aXY9ImNvbnRlbnQtdHlwZSIgY29udGVudD0idGV4dC9odG1sOyBjaGFyc2V0PVVURi04IiAvPgogICAgCiAgICAgICAgPHNjcmlwdD4KICAgICAgICAgICAgTF9OT19UT1VDSCA9IGZhbHNlOwogICAgICAgICAgICBMX0RJU0FCTEVfM0QgPSBmYWxzZTsKICAgICAgICA8L3NjcmlwdD4KICAgIAogICAgPHNjcmlwdCBzcmM9Imh0dHBzOi8vY2RuLmpzZGVsaXZyLm5ldC9ucG0vbGVhZmxldEAxLjUuMS9kaXN0L2xlYWZsZXQuanMiPjwvc2NyaXB0PgogICAgPHNjcmlwdCBzcmM9Imh0dHBzOi8vY29kZS5qcXVlcnkuY29tL2pxdWVyeS0xLjEyLjQubWluLmpzIj48L3NjcmlwdD4KICAgIDxzY3JpcHQgc3JjPSJodHRwczovL21heGNkbi5ib290c3RyYXBjZG4uY29tL2Jvb3RzdHJhcC8zLjIuMC9qcy9ib290c3RyYXAubWluLmpzIj48L3NjcmlwdD4KICAgIDxzY3JpcHQgc3JjPSJodHRwczovL2NkbmpzLmNsb3VkZmxhcmUuY29tL2FqYXgvbGlicy9MZWFmbGV0LmF3ZXNvbWUtbWFya2Vycy8yLjAuMi9sZWFmbGV0LmF3ZXNvbWUtbWFya2Vycy5qcyI+PC9zY3JpcHQ+CiAgICA8bGluayByZWw9InN0eWxlc2hlZXQiIGhyZWY9Imh0dHBzOi8vY2RuLmpzZGVsaXZyLm5ldC9ucG0vbGVhZmxldEAxLjUuMS9kaXN0L2xlYWZsZXQuY3NzIi8+CiAgICA8bGluayByZWw9InN0eWxlc2hlZXQiIGhyZWY9Imh0dHBzOi8vbWF4Y2RuLmJvb3RzdHJhcGNkbi5jb20vYm9vdHN0cmFwLzMuMi4wL2Nzcy9ib290c3RyYXAubWluLmNzcyIvPgogICAgPGxpbmsgcmVsPSJzdHlsZXNoZWV0IiBocmVmPSJodHRwczovL21heGNkbi5ib290c3RyYXBjZG4uY29tL2Jvb3RzdHJhcC8zLjIuMC9jc3MvYm9vdHN0cmFwLXRoZW1lLm1pbi5jc3MiLz4KICAgIDxsaW5rIHJlbD0ic3R5bGVzaGVldCIgaHJlZj0iaHR0cHM6Ly9tYXhjZG4uYm9vdHN0cmFwY2RuLmNvbS9mb250LWF3ZXNvbWUvNC42LjMvY3NzL2ZvbnQtYXdlc29tZS5taW4uY3NzIi8+CiAgICA8bGluayByZWw9InN0eWxlc2hlZXQiIGhyZWY9Imh0dHBzOi8vY2RuanMuY2xvdWRmbGFyZS5jb20vYWpheC9saWJzL0xlYWZsZXQuYXdlc29tZS1tYXJrZXJzLzIuMC4yL2xlYWZsZXQuYXdlc29tZS1tYXJrZXJzLmNzcyIvPgogICAgPGxpbmsgcmVsPSJzdHlsZXNoZWV0IiBocmVmPSJodHRwczovL3Jhd2Nkbi5naXRoYWNrLmNvbS9weXRob24tdmlzdWFsaXphdGlvbi9mb2xpdW0vbWFzdGVyL2ZvbGl1bS90ZW1wbGF0ZXMvbGVhZmxldC5hd2Vzb21lLnJvdGF0ZS5jc3MiLz4KICAgIDxzdHlsZT5odG1sLCBib2R5IHt3aWR0aDogMTAwJTtoZWlnaHQ6IDEwMCU7bWFyZ2luOiAwO3BhZGRpbmc6IDA7fTwvc3R5bGU+CiAgICA8c3R5bGU+I21hcCB7cG9zaXRpb246YWJzb2x1dGU7dG9wOjA7Ym90dG9tOjA7cmlnaHQ6MDtsZWZ0OjA7fTwvc3R5bGU+CiAgICAKICAgICAgICAgICAgPG1ldGEgbmFtZT0idmlld3BvcnQiIGNvbnRlbnQ9IndpZHRoPWRldmljZS13aWR0aCwKICAgICAgICAgICAgICAgIGluaXRpYWwtc2NhbGU9MS4wLCBtYXhpbXVtLXNjYWxlPTEuMCwgdXNlci1zY2FsYWJsZT1ubyIgLz4KICAgICAgICAgICAgPHN0eWxlPgogICAgICAgICAgICAgICAgI21hcF8xYzc0ZWYwZDZiMTU0OTZmYjkzYWU3MjVhOGQ0ZTBiYiB7CiAgICAgICAgICAgICAgICAgICAgcG9zaXRpb246IHJlbGF0aXZlOwogICAgICAgICAgICAgICAgICAgIHdpZHRoOiAxMDAuMCU7CiAgICAgICAgICAgICAgICAgICAgaGVpZ2h0OiAxMDAuMCU7CiAgICAgICAgICAgICAgICAgICAgbGVmdDogMC4wJTsKICAgICAgICAgICAgICAgICAgICB0b3A6IDAuMCU7CiAgICAgICAgICAgICAgICB9CiAgICAgICAgICAgIDwvc3R5bGU+CiAgICAgICAgCjwvaGVhZD4KPGJvZHk+ICAgIAogICAgCiAgICAgICAgICAgIDxkaXYgY2xhc3M9ImZvbGl1bS1tYXAiIGlkPSJtYXBfMWM3NGVmMGQ2YjE1NDk2ZmI5M2FlNzI1YThkNGUwYmIiID48L2Rpdj4KICAgICAgICAKPC9ib2R5Pgo8c2NyaXB0PiAgICAKICAgIAogICAgICAgICAgICB2YXIgbWFwXzFjNzRlZjBkNmIxNTQ5NmZiOTNhZTcyNWE4ZDRlMGJiID0gTC5tYXAoCiAgICAgICAgICAgICAgICAibWFwXzFjNzRlZjBkNmIxNTQ5NmZiOTNhZTcyNWE4ZDRlMGJiIiwKICAgICAgICAgICAgICAgIHsKICAgICAgICAgICAgICAgICAgICBjZW50ZXI6IFs0MC4wMSwgLTEwNS4yN10sCiAgICAgICAgICAgICAgICAgICAgY3JzOiBMLkNSUy5FUFNHMzg1NywKICAgICAgICAgICAgICAgICAgICB6b29tOiAxMCwKICAgICAgICAgICAgICAgICAgICB6b29tQ29udHJvbDogdHJ1ZSwKICAgICAgICAgICAgICAgICAgICBwcmVmZXJDYW52YXM6IGZhbHNlLAogICAgICAgICAgICAgICAgfQogICAgICAgICAgICApOwoKICAgICAgICAgICAgCgogICAgICAgIAogICAgCiAgICAgICAgICAgIHZhciB0aWxlX2xheWVyXzVhZGQyMmYzMWMyMjQ1ZTQ5OTE1YzFjZjQzYjVmYjIyID0gTC50aWxlTGF5ZXIoCiAgICAgICAgICAgICAgICAiaHR0cHM6Ly9jYXJ0b2RiLWJhc2VtYXBzLXtzfS5nbG9iYWwuc3NsLmZhc3RseS5uZXQvbGlnaHRfYWxsL3t6fS97eH0ve3l9LnBuZyIsCiAgICAgICAgICAgICAgICB7ImF0dHJpYnV0aW9uIjogIlx1MDAyNmNvcHk7IFx1MDAzY2EgaHJlZj1cImh0dHA6Ly93d3cub3BlbnN0cmVldG1hcC5vcmcvY29weXJpZ2h0XCJcdTAwM2VPcGVuU3RyZWV0TWFwXHUwMDNjL2FcdTAwM2UgY29udHJpYnV0b3JzIFx1MDAyNmNvcHk7IFx1MDAzY2EgaHJlZj1cImh0dHA6Ly9jYXJ0b2RiLmNvbS9hdHRyaWJ1dGlvbnNcIlx1MDAzZUNhcnRvREJcdTAwM2MvYVx1MDAzZSwgQ2FydG9EQiBcdTAwM2NhIGhyZWYgPVwiaHR0cDovL2NhcnRvZGIuY29tL2F0dHJpYnV0aW9uc1wiXHUwMDNlYXR0cmlidXRpb25zXHUwMDNjL2FcdTAwM2UiLCAiZGV0ZWN0UmV0aW5hIjogZmFsc2UsICJtYXhOYXRpdmVab29tIjogMTgsICJtYXhab29tIjogMTgsICJtaW5ab29tIjogMCwgIm5vV3JhcCI6IGZhbHNlLCAib3BhY2l0eSI6IDEsICJzdWJkb21haW5zIjogImFiYyIsICJ0bXMiOiBmYWxzZX0KICAgICAgICAgICAgKS5hZGRUbyhtYXBfMWM3NGVmMGQ2YjE1NDk2ZmI5M2FlNzI1YThkNGUwYmIpOwogICAgICAgIAogICAgCiAgICAgICAgZnVuY3Rpb24gZ2VvX2pzb25fODc1OTk5MTY4MGJiNDRkZGIyNzVkZjgyNTBmMjdlNzJfb25FYWNoRmVhdHVyZShmZWF0dXJlLCBsYXllcikgewogICAgICAgICAgICBsYXllci5vbih7CiAgICAgICAgICAgICAgICBjbGljazogZnVuY3Rpb24oZSkgewogICAgICAgICAgICAgICAgICAgIG1hcF8xYzc0ZWYwZDZiMTU0OTZmYjkzYWU3MjVhOGQ0ZTBiYi5maXRCb3VuZHMoZS50YXJnZXQuZ2V0Qm91bmRzKCkpOwogICAgICAgICAgICAgICAgfQogICAgICAgICAgICB9KTsKICAgICAgICB9OwogICAgICAgIHZhciBnZW9fanNvbl84NzU5OTkxNjgwYmI0NGRkYjI3NWRmODI1MGYyN2U3MiA9IEwuZ2VvSnNvbihudWxsLCB7CiAgICAgICAgICAgICAgICBvbkVhY2hGZWF0dXJlOiBnZW9fanNvbl84NzU5OTkxNjgwYmI0NGRkYjI3NWRmODI1MGYyN2U3Ml9vbkVhY2hGZWF0dXJlLAogICAgICAgICAgICAKICAgICAgICB9KTsKICAgICAgICBmdW5jdGlvbiBnZW9fanNvbl84NzU5OTkxNjgwYmI0NGRkYjI3NWRmODI1MGYyN2U3Ml9hZGQgKGRhdGEpIHsKICAgICAgICAgICAgZ2VvX2pzb25fODc1OTk5MTY4MGJiNDRkZGIyNzVkZjgyNTBmMjdlNzIuYWRkRGF0YShkYXRhKQogICAgICAgICAgICAgICAgLmFkZFRvKG1hcF8xYzc0ZWYwZDZiMTU0OTZmYjkzYWU3MjVhOGQ0ZTBiYik7CiAgICAgICAgfQogICAgICAgICAgICBnZW9fanNvbl84NzU5OTkxNjgwYmI0NGRkYjI3NWRmODI1MGYyN2U3Ml9hZGQoeyJiYm94IjogWy0xMDUuNTA0NDQsIDM5LjkzMTU5NywgLTEwNS4wNzU2OTUwMDAwMDAwMSwgNDAuMjYwODI3XSwgImZlYXR1cmVzIjogW3siYmJveCI6IFstMTA1LjM1NzMwOCwgMzkuOTQ3NzA0LCAtMTA1LjM1NzMwOCwgMzkuOTQ3NzA0XSwgImdlb21ldHJ5IjogeyJjb29yZGluYXRlcyI6IFstMTA1LjM1NzMwOCwgMzkuOTQ3NzA0XSwgInR5cGUiOiAiUG9pbnQifSwgImlkIjogIjAiLCAicHJvcGVydGllcyI6IHsiYW1vdW50IjogIjExMzY4LjAwIiwgImNvdW50eSI6ICJCT1VMREVSIiwgImRhdGFfc291cmNlIjogIkNvLiBEaXZpc2lvbiBvZiBXYXRlciBSZXNvdXJjZXMiLCAiZGF0ZV90aW1lIjogIjIwMjAtMDMtMjRUMDg6MzA6MDAuMDAwIiwgImRpdiI6ICIxIiwgImR3cl9hYmJyZXYiOiAiR1JPU1JFQ08iLCAiZmxhZyI6IG51bGwsICJodHRwX2xpbmthZ2UudXJsIjogImh0dHBzOi8vZHdyLnN0YXRlLmNvLnVzL1N1cmZhY2VXYXRlci9kYXRhL2RldGFpbF9ncmFwaC5hc3B4P0lEPUdST1NSRUNPXHUwMDI2TVRZUEU9U1RPUkFHRSIsICJsb2NhdGlvbi5sYXRpdHVkZSI6IDM5Ljk0NzcwNCwgImxvY2F0aW9uLmxvbmdpdHVkZSI6IC0xMDUuMzU3MzA4LCAibG9jYXRpb24ubmVlZHNfcmVjb2RpbmciOiBmYWxzZSwgInN0YWdlIjogIjcxNzUuNjIiLCAic3RhdGlvbl9uYW1lIjogIkdST1NTIFJFU0VSVk9JUiAiLCAic3RhdGlvbl9zdGF0dXMiOiAiQWN0aXZlIiwgInN0YXRpb25fdHlwZSI6ICJSZXNlcnZvaXIiLCAidXNnc19zdGF0aW9uX2lkIjogbnVsbCwgInZhcmlhYmxlIjogIlNUT1JBR0UiLCAid2QiOiAiNiJ9LCAidHlwZSI6ICJGZWF0dXJlIn0sIHsiYmJveCI6IFstMTA1LjE3ODU2NywgNDAuMTc3MDgwMDAwMDAwMDA0LCAtMTA1LjE3ODU2NywgNDAuMTc3MDgwMDAwMDAwMDA0XSwgImdlb21ldHJ5IjogeyJjb29yZGluYXRlcyI6IFstMTA1LjE3ODU2NywgNDAuMTc3MDgwMDAwMDAwMDA0XSwgInR5cGUiOiAiUG9pbnQifSwgImlkIjogIjEiLCAicHJvcGVydGllcyI6IHsiYW1vdW50IjogIjEuNDIiLCAiY291bnR5IjogIkJPVUxERVIiLCAiZGF0YV9zb3VyY2UiOiAiQ29vcGVyYXRpdmUgU0RSIFByb2dyYW0gb2YgQ0RXUiBcdTAwMjYgTkNXQ0QiLCAiZGF0ZV90aW1lIjogIjIwMjAtMDMtMjRUMDk6MDA6MDAuMDAwIiwgImRpdiI6ICIxIiwgImR3cl9hYmJyZXYiOiAiUENLUEVMQ08iLCAiZmxhZyI6IG51bGwsICJodHRwX2xpbmthZ2UudXJsIjogImh0dHBzOi8vZHdyLnN0YXRlLmNvLnVzL1N1cmZhY2VXYXRlci9kYXRhL2RldGFpbF9ncmFwaC5hc3B4P0lEPVBDS1BFTENPXHUwMDI2TVRZUEU9RElTQ0hSRyIsICJsb2NhdGlvbi5sYXRpdHVkZSI6IDQwLjE3NzA4LCAibG9jYXRpb24ubG9uZ2l0dWRlIjogLTEwNS4xNzg1NjcsICJsb2NhdGlvbi5uZWVkc19yZWNvZGluZyI6IGZhbHNlLCAic3RhZ2UiOiAiMC4xNyIsICJzdGF0aW9uX25hbWUiOiAiUEVDSyBQRUxMQSBDTE9WRVIgRElUQ0giLCAic3RhdGlvbl9zdGF0dXMiOiAiQWN0aXZlIiwgInN0YXRpb25fdHlwZSI6ICJEaXZlcnNpb24iLCAidXNnc19zdGF0aW9uX2lkIjogbnVsbCwgInZhcmlhYmxlIjogIkRJU0NIUkciLCAid2QiOiAiNSJ9LCAidHlwZSI6ICJGZWF0dXJlIn0sIHsiYmJveCI6IFstMTA1LjM2NDkxNzAwMDAwMDAyLCA0MC4wNDIwMjgsIC0xMDUuMzY0OTE3MDAwMDAwMDIsIDQwLjA0MjAyOF0sICJnZW9tZXRyeSI6IHsiY29vcmRpbmF0ZXMiOiBbLTEwNS4zNjQ5MTcwMDAwMDAwMiwgNDAuMDQyMDI4XSwgInR5cGUiOiAiUG9pbnQifSwgImlkIjogIjIiLCAicHJvcGVydGllcyI6IHsiYW1vdW50IjogbnVsbCwgImNvdW50eSI6ICJCT1VMREVSIiwgImRhdGFfc291cmNlIjogIlUuUy4gR2VvbG9naWNhbCBTdXJ2ZXkiLCAiZGF0ZV90aW1lIjogIjE5OTktMDktMzBUMDA6MDA6MDAuMDAwIiwgImRpdiI6ICIxIiwgImR3cl9hYmJyZXYiOiAiRlJNTE1SQ08iLCAiZmxhZyI6IG51bGwsICJodHRwX2xpbmthZ2UudXJsIjogImh0dHBzOi8vd2F0ZXJkYXRhLnVzZ3MuZ292L253aXMvdXY/MDY3Mjc0MTAiLCAibG9jYXRpb24ubGF0aXR1ZGUiOiA0MC4wNDIwMjgsICJsb2NhdGlvbi5sb25naXR1ZGUiOiAtMTA1LjM2NDkxNywgImxvY2F0aW9uLm5lZWRzX3JlY29kaW5nIjogZmFsc2UsICJzdGFnZSI6IG51bGwsICJzdGF0aW9uX25hbWUiOiAiRk9VUk1JTEUgQ1JFRUsgQVQgTE9HQU4gTUlMTCBST0FEIE5FQVIgQ1JJU01BTiwgQ08iLCAic3RhdGlvbl9zdGF0dXMiOiAiQWN0aXZlIiwgInN0YXRpb25fdHlwZSI6ICJTdHJlYW0iLCAidXNnc19zdGF0aW9uX2lkIjogIjA2NzI3NDEwIiwgInZhcmlhYmxlIjogIkRJU0NIUkciLCAid2QiOiAiNiJ9LCAidHlwZSI6ICJGZWF0dXJlIn0sIHsiYmJveCI6IFstMTA1LjE4OTE5MSwgNDAuMTg3NTc4LCAtMTA1LjE4OTE5MSwgNDAuMTg3NTc4XSwgImdlb21ldHJ5IjogeyJjb29yZGluYXRlcyI6IFstMTA1LjE4OTE5MSwgNDAuMTg3NTc4XSwgInR5cGUiOiAiUG9pbnQifSwgImlkIjogIjMiLCAicHJvcGVydGllcyI6IHsiYW1vdW50IjogIjI4MTkuNjgiLCAiY291bnR5IjogIkJPVUxERVIiLCAiZGF0YV9zb3VyY2UiOiAiQ29vcGVyYXRpdmUgUHJvZ3JhbSBvZiBDRFdSLCBOQ1dDRCBcdTAwMjYgU1ZMSFdDRCIsICJkYXRlX3RpbWUiOiAiMjAyMC0wMy0yNFQwOTowMDowMC4wMDAiLCAiZGl2IjogIjEiLCAiZHdyX2FiYnJldiI6ICJERU5UQVlDTyIsICJmbGFnIjogbnVsbCwgImh0dHBfbGlua2FnZS51cmwiOiAiaHR0cHM6Ly9kd3Iuc3RhdGUuY28udXMvU3VyZmFjZVdhdGVyL2RhdGEvZGV0YWlsX2dyYXBoLmFzcHg/SUQ9REVOVEFZQ09cdTAwMjZNVFlQRT1ESVNDSFJHIiwgImxvY2F0aW9uLmxhdGl0dWRlIjogNDAuMTg3NTc4LCAibG9jYXRpb24ubG9uZ2l0dWRlIjogLTEwNS4xODkxOTEsICJsb2NhdGlvbi5uZWVkc19yZWNvZGluZyI6IGZhbHNlLCAic3RhZ2UiOiAiNjIuMzEiLCAic3RhdGlvbl9uYW1lIjogIkRFTklPIFRBWUxPUiBESVRDSCIsICJzdGF0aW9uX3N0YXR1cyI6ICJBY3RpdmUiLCAic3RhdGlvbl90eXBlIjogIkRpdmVyc2lvbiIsICJ1c2dzX3N0YXRpb25faWQiOiBudWxsLCAidmFyaWFibGUiOiAiRElTQ0hSRyIsICJ3ZCI6ICI1In0sICJ0eXBlIjogIkZlYXR1cmUifSwgeyJiYm94IjogWy0xMDUuMjU5Nzk1LCA0MC4yMTkwNDYsIC0xMDUuMjU5Nzk1LCA0MC4yMTkwNDZdLCAiZ2VvbWV0cnkiOiB7ImNvb3JkaW5hdGVzIjogWy0xMDUuMjU5Nzk1LCA0MC4yMTkwNDZdLCAidHlwZSI6ICJQb2ludCJ9LCAiaWQiOiAiNCIsICJwcm9wZXJ0aWVzIjogeyJhbW91bnQiOiAiMC4wMCIsICJjb3VudHkiOiAiQk9VTERFUiIsICJkYXRhX3NvdXJjZSI6ICJDb29wZXJhdGl2ZSBQcm9ncmFtIG9mIENEV1IsIE5DV0NEIFx1MDAyNiBTVkxIV0NEIiwgImRhdGVfdGltZSI6ICIyMDIwLTAzLTI0VDA4OjQ1OjAwLjAwMCIsICJkaXYiOiAiMSIsICJkd3JfYWJicmV2IjogIlNVUERJVENPIiwgImZsYWciOiBudWxsLCAiaHR0cF9saW5rYWdlLnVybCI6ICJodHRwczovL2R3ci5zdGF0ZS5jby51cy9TdXJmYWNlV2F0ZXIvZGF0YS9kZXRhaWxfZ3JhcGguYXNweD9JRD1TVVBESVRDT1x1MDAyNk1UWVBFPURJU0NIUkciLCAibG9jYXRpb24ubGF0aXR1ZGUiOiA0MC4yMTkwNDYsICJsb2NhdGlvbi5sb25naXR1ZGUiOiAtMTA1LjI1OTc5NSwgImxvY2F0aW9uLm5lZWRzX3JlY29kaW5nIjogZmFsc2UsICJzdGFnZSI6ICIwLjAwIiwgInN0YXRpb25fbmFtZSI6ICJTVVBQTFkgRElUQ0giLCAic3RhdGlvbl9zdGF0dXMiOiAiQWN0aXZlIiwgInN0YXRpb25fdHlwZSI6ICJEaXZlcnNpb24iLCAidXNnc19zdGF0aW9uX2lkIjogbnVsbCwgInZhcmlhYmxlIjogIkRJU0NIUkciLCAid2QiOiAiNSJ9LCAidHlwZSI6ICJGZWF0dXJlIn0sIHsiYmJveCI6IFstMTA1LjI1MTgyNiwgNDAuMjEyNTA1LCAtMTA1LjI1MTgyNiwgNDAuMjEyNTA1XSwgImdlb21ldHJ5IjogeyJjb29yZGluYXRlcyI6IFstMTA1LjI1MTgyNiwgNDAuMjEyNTA1XSwgInR5cGUiOiAiUG9pbnQifSwgImlkIjogIjUiLCAicHJvcGVydGllcyI6IHsiYW1vdW50IjogIjAuMjciLCAiY291bnR5IjogIkJPVUxERVIiLCAiZGF0YV9zb3VyY2UiOiAiQ29vcGVyYXRpdmUgUHJvZ3JhbSBvZiBDRFdSLCBOQ1dDRCBcdTAwMjYgU1ZMSFdDRCIsICJkYXRlX3RpbWUiOiAiMjAyMC0wMy0yNFQwOTowMDowMC4wMDAiLCAiZGl2IjogIjEiLCAiZHdyX2FiYnJldiI6ICJQQUxESVRDTyIsICJmbGFnIjogbnVsbCwgImh0dHBfbGlua2FnZS51cmwiOiAiaHR0cHM6Ly9kd3Iuc3RhdGUuY28udXMvU3VyZmFjZVdhdGVyL2RhdGEvZGV0YWlsX2dyYXBoLmFzcHg/SUQ9UEFMRElUQ09cdTAwMjZNVFlQRT1ESVNDSFJHIiwgImxvY2F0aW9uLmxhdGl0dWRlIjogNDAuMjEyNTA1LCAibG9jYXRpb24ubG9uZ2l0dWRlIjogLTEwNS4yNTE4MjYsICJsb2NhdGlvbi5uZWVkc19yZWNvZGluZyI6IGZhbHNlLCAic3RhZ2UiOiAiMC4wNSIsICJzdGF0aW9uX25hbWUiOiAiUEFMTUVSVE9OIERJVENIIiwgInN0YXRpb25fc3RhdHVzIjogIkFjdGl2ZSIsICJzdGF0aW9uX3R5cGUiOiAiRGl2ZXJzaW9uIiwgInVzZ3Nfc3RhdGlvbl9pZCI6IG51bGwsICJ2YXJpYWJsZSI6ICJESVNDSFJHIiwgIndkIjogIjUifSwgInR5cGUiOiAiRmVhdHVyZSJ9LCB7ImJib3giOiBbLTEwNS4zNDc5MDYsIDM5LjkzODM1MSwgLTEwNS4zNDc5MDYsIDM5LjkzODM1MV0sICJnZW9tZXRyeSI6IHsiY29vcmRpbmF0ZXMiOiBbLTEwNS4zNDc5MDYsIDM5LjkzODM1MV0sICJ0eXBlIjogIlBvaW50In0sICJpZCI6ICI2IiwgInByb3BlcnRpZXMiOiB7ImFtb3VudCI6ICIxNi40MCIsICJjb3VudHkiOiAiQk9VTERFUiIsICJkYXRhX3NvdXJjZSI6ICJDby4gRGl2aXNpb24gb2YgV2F0ZXIgUmVzb3VyY2VzIiwgImRhdGVfdGltZSI6ICIyMDIwLTAzLTI0VDA5OjE1OjAwLjAwMCIsICJkaXYiOiAiMSIsICJkd3JfYWJicmV2IjogIkJPQ0JHUkNPIiwgImZsYWciOiBudWxsLCAiaHR0cF9saW5rYWdlLnVybCI6ICJodHRwczovL2R3ci5zdGF0ZS5jby51cy9TdXJmYWNlV2F0ZXIvZGF0YS9kZXRhaWxfZ3JhcGguYXNweD9JRD1CT0NCR1JDT1x1MDAyNk1UWVBFPURJU0NIUkciLCAibG9jYXRpb24ubGF0aXR1ZGUiOiAzOS45MzgzNTEsICJsb2NhdGlvbi5sb25naXR1ZGUiOiAtMTA1LjM0NzkwNiwgImxvY2F0aW9uLm5lZWRzX3JlY29kaW5nIjogZmFsc2UsICJzdGFnZSI6ICIwLjM2IiwgInN0YXRpb25fbmFtZSI6ICJTT1VUSCBCT1VMREVSIENSRUVLIEJFTE9XIEdST1NTIFJFU0VSVk9JUiIsICJzdGF0aW9uX3N0YXR1cyI6ICJBY3RpdmUiLCAic3RhdGlvbl90eXBlIjogIlN0cmVhbSIsICJ1c2dzX3N0YXRpb25faWQiOiAiMDY3Mjk0NTAiLCAidmFyaWFibGUiOiAiRElTQ0hSRyIsICJ3ZCI6ICI2In0sICJ0eXBlIjogIkZlYXR1cmUifSwgeyJiYm94IjogWy0xMDUuMTc0OTU3LCA0MC4yNTgzNjcsIC0xMDUuMTc0OTU3LCA0MC4yNTgzNjddLCAiZ2VvbWV0cnkiOiB7ImNvb3JkaW5hdGVzIjogWy0xMDUuMTc0OTU3LCA0MC4yNTgzNjddLCAidHlwZSI6ICJQb2ludCJ9LCAiaWQiOiAiNyIsICJwcm9wZXJ0aWVzIjogeyJhbW91bnQiOiAiMC4wMCIsICJjb3VudHkiOiAiQk9VTERFUiIsICJkYXRhX3NvdXJjZSI6ICJDby4gRGl2aXNpb24gb2YgV2F0ZXIgUmVzb3VyY2VzIiwgImRhdGVfdGltZSI6ICIyMDIwLTAzLTI0VDA4OjMwOjAwLjAwMCIsICJkaXYiOiAiMSIsICJkd3JfYWJicmV2IjogIkJPVUxBUkNPIiwgImZsYWciOiBudWxsLCAiaHR0cF9saW5rYWdlLnVybCI6ICJodHRwczovL2R3ci5zdGF0ZS5jby51cy9TdXJmYWNlV2F0ZXIvZGF0YS9kZXRhaWxfZ3JhcGguYXNweD9JRD1CT1VMQVJDT1x1MDAyNk1UWVBFPURJU0NIUkciLCAibG9jYXRpb24ubGF0aXR1ZGUiOiA0MC4yNTgzNjcsICJsb2NhdGlvbi5sb25naXR1ZGUiOiAtMTA1LjE3NDk1NywgImxvY2F0aW9uLm5lZWRzX3JlY29kaW5nIjogZmFsc2UsICJzdGFnZSI6ICItMC4xMiIsICJzdGF0aW9uX25hbWUiOiAiQk9VTERFUi1MQVJJTUVSIERJVENIIE5FQVIgQkVSVEhPVUQiLCAic3RhdGlvbl9zdGF0dXMiOiAiQWN0aXZlIiwgInN0YXRpb25fdHlwZSI6ICJEaXZlcnNpb24iLCAidXNnc19zdGF0aW9uX2lkIjogbnVsbCwgInZhcmlhYmxlIjogIkRJU0NIUkciLCAid2QiOiAiNCJ9LCAidHlwZSI6ICJGZWF0dXJlIn0sIHsiYmJveCI6IFstMTA1LjE5MzA0OCwgNDAuMDUzMDM1LCAtMTA1LjE5MzA0OCwgNDAuMDUzMDM1XSwgImdlb21ldHJ5IjogeyJjb29yZGluYXRlcyI6IFstMTA1LjE5MzA0OCwgNDAuMDUzMDM1XSwgInR5cGUiOiAiUG9pbnQifSwgImlkIjogIjgiLCAicHJvcGVydGllcyI6IHsiYW1vdW50IjogIjAuMDAiLCAiY291bnR5IjogIkJPVUxERVIiLCAiZGF0YV9zb3VyY2UiOiAiTm9ydGhlcm4gQ29sb3JhZG8gV2F0ZXIgQ29uc2VydmFuY3kgRGlzdHJpY3QiLCAiZGF0ZV90aW1lIjogIjIwMjAtMDMtMjRUMDg6MDA6MDAuMDAwIiwgImRpdiI6ICIxIiwgImR3cl9hYmJyZXYiOiAiQkNTQ0JDQ08iLCAiZmxhZyI6IG51bGwsICJodHRwX2xpbmthZ2UudXJsIjogImh0dHA6Ly93d3cubm9ydGhlcm53YXRlci5vcmcvV2F0ZXJQcm9qZWN0cy9XYXRlckRhdGEuYXNweEVhc3RTbG9wZVdhdGVyRGF0YS5hc3B4IiwgImxvY2F0aW9uLmxhdGl0dWRlIjogNDAuMDUzMDM1LCAibG9jYXRpb24ubG9uZ2l0dWRlIjogLTEwNS4xOTMwNDgsICJsb2NhdGlvbi5uZWVkc19yZWNvZGluZyI6IGZhbHNlLCAic3RhZ2UiOiAiMC4wMCIsICJzdGF0aW9uX25hbWUiOiAiQk9VTERFUiBDUkVFSyBTVVBQTFkgQ0FOQUwgVE8gQk9VTERFUiBDUkVFSyBORUFSIEJPVUxERVIiLCAic3RhdGlvbl9zdGF0dXMiOiAiQWN0aXZlIiwgInN0YXRpb25fdHlwZSI6ICJEaXZlcnNpb24iLCAidXNnc19zdGF0aW9uX2lkIjogIkVTMTkxNyIsICJ2YXJpYWJsZSI6ICJESVNDSFJHIiwgIndkIjogIjYifSwgInR5cGUiOiAiRmVhdHVyZSJ9LCB7ImJib3giOiBbLTEwNS4yMDkyODIsIDQwLjE4ODU3OSwgLTEwNS4yMDkyODIsIDQwLjE4ODU3OV0sICJnZW9tZXRyeSI6IHsiY29vcmRpbmF0ZXMiOiBbLTEwNS4yMDkyODIsIDQwLjE4ODU3OV0sICJ0eXBlIjogIlBvaW50In0sICJpZCI6ICI5IiwgInByb3BlcnRpZXMiOiB7ImFtb3VudCI6ICIwLjEyIiwgImNvdW50eSI6ICJCT1VMREVSIiwgImRhdGFfc291cmNlIjogIkNvb3BlcmF0aXZlIFByb2dyYW0gb2YgQ0RXUiwgTkNXQ0QgXHUwMDI2IFNWTEhXQ0QiLCAiZGF0ZV90aW1lIjogIjIwMjAtMDMtMjRUMDg6NDU6MDAuMDAwIiwgImRpdiI6ICIxIiwgImR3cl9hYmJyZXYiOiAiSkFNRElUQ08iLCAiZmxhZyI6IG51bGwsICJodHRwX2xpbmthZ2UudXJsIjogImh0dHBzOi8vZHdyLnN0YXRlLmNvLnVzL1N1cmZhY2VXYXRlci9kYXRhL2RldGFpbF9ncmFwaC5hc3B4P0lEPUpBTURJVENPXHUwMDI2TVRZUEU9RElTQ0hSRyIsICJsb2NhdGlvbi5sYXRpdHVkZSI6IDQwLjE4ODU3OSwgImxvY2F0aW9uLmxvbmdpdHVkZSI6IC0xMDUuMjA5MjgyLCAibG9jYXRpb24ubmVlZHNfcmVjb2RpbmciOiBmYWxzZSwgInN0YWdlIjogIjAuMDQiLCAic3RhdGlvbl9uYW1lIjogIkpBTUVTIERJVENIIiwgInN0YXRpb25fc3RhdHVzIjogIkFjdGl2ZSIsICJzdGF0aW9uX3R5cGUiOiAiRGl2ZXJzaW9uIiwgInVzZ3Nfc3RhdGlvbl9pZCI6IG51bGwsICJ2YXJpYWJsZSI6ICJESVNDSFJHIiwgIndkIjogIjUifSwgInR5cGUiOiAiRmVhdHVyZSJ9LCB7ImJib3giOiBbLTEwNS4zMjYyNSwgNDAuMDE4NjY3LCAtMTA1LjMyNjI1LCA0MC4wMTg2NjddLCAiZ2VvbWV0cnkiOiB7ImNvb3JkaW5hdGVzIjogWy0xMDUuMzI2MjUsIDQwLjAxODY2N10sICJ0eXBlIjogIlBvaW50In0sICJpZCI6ICIxMCIsICJwcm9wZXJ0aWVzIjogeyJhbW91bnQiOiAiMC43NCIsICJjb3VudHkiOiAiQk9VTERFUiIsICJkYXRhX3NvdXJjZSI6ICJVLlMuIEdlb2xvZ2ljYWwgU3VydmV5IiwgImRhdGVfdGltZSI6ICIyMDE5LTEwLTAyVDE0OjUwOjAwLjAwMCIsICJkaXYiOiAiMSIsICJkd3JfYWJicmV2IjogIkZPVU9ST0NPIiwgImZsYWciOiBudWxsLCAiaHR0cF9saW5rYWdlLnVybCI6ICJodHRwczovL3dhdGVyZGF0YS51c2dzLmdvdi9ud2lzL3V2PzA2NzI3NTAwIiwgImxvY2F0aW9uLmxhdGl0dWRlIjogNDAuMDE4NjY3LCAibG9jYXRpb24ubG9uZ2l0dWRlIjogLTEwNS4zMjYyNSwgImxvY2F0aW9uLm5lZWRzX3JlY29kaW5nIjogZmFsc2UsICJzdGFnZSI6IG51bGwsICJzdGF0aW9uX25hbWUiOiAiRk9VUk1JTEUgQ1JFRUsgQVQgT1JPREVMTCwgQ08iLCAic3RhdGlvbl9zdGF0dXMiOiAiQWN0aXZlIiwgInN0YXRpb25fdHlwZSI6ICJTdHJlYW0iLCAidXNnc19zdGF0aW9uX2lkIjogIjA2NzI3NTAwIiwgInZhcmlhYmxlIjogIkRJU0NIUkciLCAid2QiOiAiNiJ9LCAidHlwZSI6ICJGZWF0dXJlIn0sIHsiYmJveCI6IFstMTA1LjE5Njc3NSwgNDAuMTgxODgsIC0xMDUuMTk2Nzc1LCA0MC4xODE4OF0sICJnZW9tZXRyeSI6IHsiY29vcmRpbmF0ZXMiOiBbLTEwNS4xOTY3NzUsIDQwLjE4MTg4XSwgInR5cGUiOiAiUG9pbnQifSwgImlkIjogIjExIiwgInByb3BlcnRpZXMiOiB7ImFtb3VudCI6ICIwLjAwIiwgImNvdW50eSI6ICJCT1VMREVSIiwgImRhdGFfc291cmNlIjogIkNvb3BlcmF0aXZlIFByb2dyYW0gb2YgQ0RXUiwgTkNXQ0QgXHUwMDI2IFNWTEhXQ0QiLCAiZGF0ZV90aW1lIjogIjIwMjAtMDMtMjRUMDg6NDU6MDAuMDAwIiwgImRpdiI6ICIxIiwgImR3cl9hYmJyZXYiOiAiREFWRE9XQ08iLCAiZmxhZyI6IG51bGwsICJodHRwX2xpbmthZ2UudXJsIjogImh0dHBzOi8vZHdyLnN0YXRlLmNvLnVzL1N1cmZhY2VXYXRlci9kYXRhL2RldGFpbF9ncmFwaC5hc3B4P0lEPURBVkRPV0NPXHUwMDI2TVRZUEU9RElTQ0hSRyIsICJsb2NhdGlvbi5sYXRpdHVkZSI6IDQwLjE4MTg4LCAibG9jYXRpb24ubG9uZ2l0dWRlIjogLTEwNS4xOTY3NzUsICJsb2NhdGlvbi5uZWVkc19yZWNvZGluZyI6IGZhbHNlLCAic3RhZ2UiOiBudWxsLCAic3RhdGlvbl9uYW1lIjogIkRBVklTIEFORCBET1dOSU5HIERJVENIIiwgInN0YXRpb25fc3RhdHVzIjogIkFjdGl2ZSIsICJzdGF0aW9uX3R5cGUiOiAiRGl2ZXJzaW9uIiwgInVzZ3Nfc3RhdGlvbl9pZCI6IG51bGwsICJ2YXJpYWJsZSI6ICJESVNDSFJHIiwgIndkIjogIjUifSwgInR5cGUiOiAiRmVhdHVyZSJ9LCB7ImJib3giOiBbLTEwNS4xODkxMzIsIDQwLjE4NzUyNCwgLTEwNS4xODkxMzIsIDQwLjE4NzUyNF0sICJnZW9tZXRyeSI6IHsiY29vcmRpbmF0ZXMiOiBbLTEwNS4xODkxMzIsIDQwLjE4NzUyNF0sICJ0eXBlIjogIlBvaW50In0sICJpZCI6ICIxMiIsICJwcm9wZXJ0aWVzIjogeyJhbW91bnQiOiAiMC4wMCIsICJjb3VudHkiOiAiQk9VTERFUiIsICJkYXRhX3NvdXJjZSI6ICJDb29wZXJhdGl2ZSBQcm9ncmFtIG9mIENEV1IsIE5DV0NEIFx1MDAyNiBTVkxIV0NEIiwgImRhdGVfdGltZSI6ICIyMDIwLTAzLTI0VDA5OjAwOjAwLjAwMCIsICJkaXYiOiAiMSIsICJkd3JfYWJicmV2IjogIlJVTllPTkNPIiwgImZsYWciOiBudWxsLCAiaHR0cF9saW5rYWdlLnVybCI6ICJodHRwczovL2R3ci5zdGF0ZS5jby51cy9TdXJmYWNlV2F0ZXIvZGF0YS9kZXRhaWxfZ3JhcGguYXNweD9JRD1SVU5ZT05DT1x1MDAyNk1UWVBFPURJU0NIUkciLCAibG9jYXRpb24ubGF0aXR1ZGUiOiA0MC4xODc1MjQsICJsb2NhdGlvbi5sb25naXR1ZGUiOiAtMTA1LjE4OTEzMiwgImxvY2F0aW9uLm5lZWRzX3JlY29kaW5nIjogZmFsc2UsICJzdGFnZSI6ICI1MC43OSIsICJzdGF0aW9uX25hbWUiOiAiUlVOWU9OIERJVENIIiwgInN0YXRpb25fc3RhdHVzIjogIkFjdGl2ZSIsICJzdGF0aW9uX3R5cGUiOiAiRGl2ZXJzaW9uIiwgInVzZ3Nfc3RhdGlvbl9pZCI6IG51bGwsICJ2YXJpYWJsZSI6ICJESVNDSFJHIiwgIndkIjogIjUifSwgInR5cGUiOiAiRmVhdHVyZSJ9LCB7ImJib3giOiBbLTEwNS4yNTA5MjcsIDQwLjIxMTA4MywgLTEwNS4yNTA5MjcsIDQwLjIxMTA4M10sICJnZW9tZXRyeSI6IHsiY29vcmRpbmF0ZXMiOiBbLTEwNS4yNTA5MjcsIDQwLjIxMTA4M10sICJ0eXBlIjogIlBvaW50In0sICJpZCI6ICIxMyIsICJwcm9wZXJ0aWVzIjogeyJhbW91bnQiOiAiMC4wMCIsICJjb3VudHkiOiAiQk9VTERFUiIsICJkYXRhX3NvdXJjZSI6ICJDb29wZXJhdGl2ZSBQcm9ncmFtIG9mIENEV1IsIE5DV0NEIFx1MDAyNiBTVkxIV0NEIiwgImRhdGVfdGltZSI6ICIyMDIwLTAzLTI0VDA4OjAwOjAwLjAwMCIsICJkaXYiOiAiMSIsICJkd3JfYWJicmV2IjogIlNXRURJVENPIiwgImZsYWciOiBudWxsLCAiaHR0cF9saW5rYWdlLnVybCI6ICJodHRwczovL2R3ci5zdGF0ZS5jby51cy9TdXJmYWNlV2F0ZXIvZGF0YS9kZXRhaWxfZ3JhcGguYXNweD9JRD1TV0VESVRDT1x1MDAyNk1UWVBFPURJU0NIUkciLCAibG9jYXRpb24ubGF0aXR1ZGUiOiA0MC4yMTEwODMsICJsb2NhdGlvbi5sb25naXR1ZGUiOiAtMTA1LjI1MDkyNywgImxvY2F0aW9uLm5lZWRzX3JlY29kaW5nIjogZmFsc2UsICJzdGFnZSI6ICItMC4wNSIsICJzdGF0aW9uX25hbWUiOiAiU1dFREUgRElUQ0giLCAic3RhdGlvbl9zdGF0dXMiOiAiQWN0aXZlIiwgInN0YXRpb25fdHlwZSI6ICJEaXZlcnNpb24iLCAidXNnc19zdGF0aW9uX2lkIjogbnVsbCwgInZhcmlhYmxlIjogIkRJU0NIUkciLCAid2QiOiAiNSJ9LCAidHlwZSI6ICJGZWF0dXJlIn0sIHsiYmJveCI6IFstMTA1LjA4ODY5NSwgNDAuMTUzMzYzLCAtMTA1LjA4ODY5NSwgNDAuMTUzMzYzXSwgImdlb21ldHJ5IjogeyJjb29yZGluYXRlcyI6IFstMTA1LjA4ODY5NSwgNDAuMTUzMzYzXSwgInR5cGUiOiAiUG9pbnQifSwgImlkIjogIjE0IiwgInByb3BlcnRpZXMiOiB7ImFtb3VudCI6ICIwLjEwIiwgImNvdW50eSI6ICJCT1VMREVSIiwgImRhdGFfc291cmNlIjogIkNvb3BlcmF0aXZlIFByb2dyYW0gb2YgQ0RXUiwgTkNXQ0QgXHUwMDI2IFNWTEhXQ0QiLCAiZGF0ZV90aW1lIjogIjIwMjAtMDMtMjRUMDk6MDA6MDAuMDAwIiwgImRpdiI6ICIxIiwgImR3cl9hYmJyZXYiOiAiQk9ORElUQ08iLCAiZmxhZyI6IG51bGwsICJodHRwX2xpbmthZ2UudXJsIjogImh0dHBzOi8vZHdyLnN0YXRlLmNvLnVzL1N1cmZhY2VXYXRlci9kYXRhL2RldGFpbF9ncmFwaC5hc3B4P0lEPUJPTkRJVENPXHUwMDI2TVRZUEU9RElTQ0hSRyIsICJsb2NhdGlvbi5sYXRpdHVkZSI6IDQwLjE1MzM2MywgImxvY2F0aW9uLmxvbmdpdHVkZSI6IC0xMDUuMDg4Njk1LCAibG9jYXRpb24ubmVlZHNfcmVjb2RpbmciOiBmYWxzZSwgInN0YWdlIjogIjAuMDQiLCAic3RhdGlvbl9uYW1lIjogIkJPTlVTIERJVENIIiwgInN0YXRpb25fc3RhdHVzIjogIkFjdGl2ZSIsICJzdGF0aW9uX3R5cGUiOiAiRGl2ZXJzaW9uIiwgInVzZ3Nfc3RhdGlvbl9pZCI6IG51bGwsICJ2YXJpYWJsZSI6ICJESVNDSFJHIiwgIndkIjogIjUifSwgInR5cGUiOiAiRmVhdHVyZSJ9LCB7ImJib3giOiBbLTEwNS4yNTA5NTIsIDQwLjIxMTM4OSwgLTEwNS4yNTA5NTIsIDQwLjIxMTM4OV0sICJnZW9tZXRyeSI6IHsiY29vcmRpbmF0ZXMiOiBbLTEwNS4yNTA5NTIsIDQwLjIxMTM4OV0sICJ0eXBlIjogIlBvaW50In0sICJpZCI6ICIxNSIsICJwcm9wZXJ0aWVzIjogeyJhbW91bnQiOiAiMC4wMCIsICJjb3VudHkiOiAiQk9VTERFUiIsICJkYXRhX3NvdXJjZSI6ICJDb29wZXJhdGl2ZSBQcm9ncmFtIG9mIENEV1IsIE5DV0NEIFx1MDAyNiBTVkxIV0NEIiwgImRhdGVfdGltZSI6ICIyMDIwLTAzLTI0VDA4OjAwOjAwLjAwMCIsICJkaXYiOiAiMSIsICJkd3JfYWJicmV2IjogIlNNRURJVENPIiwgImZsYWciOiBudWxsLCAiaHR0cF9saW5rYWdlLnVybCI6ICJodHRwczovL2R3ci5zdGF0ZS5jby51cy9TdXJmYWNlV2F0ZXIvZGF0YS9kZXRhaWxfZ3JhcGguYXNweD9JRD1TTUVESVRDT1x1MDAyNk1UWVBFPURJU0NIUkciLCAibG9jYXRpb24ubGF0aXR1ZGUiOiA0MC4yMTEzODksICJsb2NhdGlvbi5sb25naXR1ZGUiOiAtMTA1LjI1MDk1MiwgImxvY2F0aW9uLm5lZWRzX3JlY29kaW5nIjogZmFsc2UsICJzdGFnZSI6IG51bGwsICJzdGF0aW9uX25hbWUiOiAiU01FQUQgRElUQ0giLCAic3RhdGlvbl9zdGF0dXMiOiAiQWN0aXZlIiwgInN0YXRpb25fdHlwZSI6ICJEaXZlcnNpb24iLCAidXNnc19zdGF0aW9uX2lkIjogbnVsbCwgInZhcmlhYmxlIjogIkRJU0NIUkciLCAid2QiOiAiNSJ9LCAidHlwZSI6ICJGZWF0dXJlIn0sIHsiYmJveCI6IFstMTA1LjE2OTM3NCwgNDAuMTczOTUsIC0xMDUuMTY5Mzc0LCA0MC4xNzM5NV0sICJnZW9tZXRyeSI6IHsiY29vcmRpbmF0ZXMiOiBbLTEwNS4xNjkzNzQsIDQwLjE3Mzk1XSwgInR5cGUiOiAiUG9pbnQifSwgImlkIjogIjE2IiwgInByb3BlcnRpZXMiOiB7ImFtb3VudCI6ICIwLjE5IiwgImNvdW50eSI6ICJCT1VMREVSIiwgImRhdGFfc291cmNlIjogIkNvb3BlcmF0aXZlIFByb2dyYW0gb2YgQ0RXUiwgTkNXQ0QgXHUwMDI2IFNWTEhXQ0QiLCAiZGF0ZV90aW1lIjogIjIwMjAtMDMtMjRUMDg6MzA6MDAuMDAwIiwgImRpdiI6ICIxIiwgImR3cl9hYmJyZXYiOiAiTklXRElUQ08iLCAiZmxhZyI6IG51bGwsICJodHRwX2xpbmthZ2UudXJsIjogImh0dHBzOi8vZHdyLnN0YXRlLmNvLnVzL1N1cmZhY2VXYXRlci9kYXRhL2RldGFpbF9ncmFwaC5hc3B4P0lEPU5JV0RJVENPXHUwMDI2TVRZUEU9RElTQ0hSRyIsICJsb2NhdGlvbi5sYXRpdHVkZSI6IDQwLjE3Mzk1LCAibG9jYXRpb24ubG9uZ2l0dWRlIjogLTEwNS4xNjkzNzQsICJsb2NhdGlvbi5uZWVkc19yZWNvZGluZyI6IGZhbHNlLCAic3RhZ2UiOiAiMC4wOSIsICJzdGF0aW9uX25hbWUiOiAiTklXT1QgRElUQ0giLCAic3RhdGlvbl9zdGF0dXMiOiAiQWN0aXZlIiwgInN0YXRpb25fdHlwZSI6ICJEaXZlcnNpb24iLCAidXNnc19zdGF0aW9uX2lkIjogbnVsbCwgInZhcmlhYmxlIjogIkRJU0NIUkciLCAid2QiOiAiNSJ9LCAidHlwZSI6ICJGZWF0dXJlIn0sIHsiYmJveCI6IFstMTA1LjIyMDQ5NywgNDAuMDc4NTYsIC0xMDUuMjIwNDk3LCA0MC4wNzg1Nl0sICJnZW9tZXRyeSI6IHsiY29vcmRpbmF0ZXMiOiBbLTEwNS4yMjA0OTcsIDQwLjA3ODU2XSwgInR5cGUiOiAiUG9pbnQifSwgImlkIjogIjE3IiwgInByb3BlcnRpZXMiOiB7ImFtb3VudCI6ICI1MTk3LjUwIiwgImNvdW50eSI6ICJCT1VMREVSIiwgImRhdGFfc291cmNlIjogIk5vcnRoZXJuIENvbG9yYWRvIFdhdGVyIENvbnNlcnZhbmN5IERpc3RyaWN0IiwgImRhdGVfdGltZSI6ICIyMDIwLTAzLTI0VDA4OjAwOjAwLjAwMCIsICJkaXYiOiAiMSIsICJkd3JfYWJicmV2IjogIkJPVVJFU0NPIiwgImZsYWciOiBudWxsLCAiaHR0cF9saW5rYWdlLnVybCI6ICJodHRwOi8vd3d3Lm5vcnRoZXJud2F0ZXIub3JnL1dhdGVyUHJvamVjdHMvV2F0ZXJEYXRhLmFzcHhFYXN0U2xvcGVXYXRlckRhdGEuYXNweCIsICJsb2NhdGlvbi5sYXRpdHVkZSI6IDQwLjA3ODU2LCAibG9jYXRpb24ubG9uZ2l0dWRlIjogLTEwNS4yMjA0OTcsICJsb2NhdGlvbi5uZWVkc19yZWNvZGluZyI6IGZhbHNlLCAic3RhZ2UiOiBudWxsLCAic3RhdGlvbl9uYW1lIjogIkJPVUxERVIgUkVTRVJWT0lSIiwgInN0YXRpb25fc3RhdHVzIjogIkFjdGl2ZSIsICJzdGF0aW9uX3R5cGUiOiAiUmVzZXJ2b2lyIiwgInVzZ3Nfc3RhdGlvbl9pZCI6ICJFUjE5MTQiLCAidmFyaWFibGUiOiAiU1RPUkFHRSIsICJ3ZCI6ICI2In0sICJ0eXBlIjogIkZlYXR1cmUifSwgeyJiYm94IjogWy0xMDUuMjU2MDE3LCA0MC4yMTUwNDMsIC0xMDUuMjU2MDE3LCA0MC4yMTUwNDNdLCAiZ2VvbWV0cnkiOiB7ImNvb3JkaW5hdGVzIjogWy0xMDUuMjU2MDE3LCA0MC4yMTUwNDNdLCAidHlwZSI6ICJQb2ludCJ9LCAiaWQiOiAiMTgiLCAicHJvcGVydGllcyI6IHsiYW1vdW50IjogIjM5LjcwIiwgImNvdW50eSI6ICJCT1VMREVSIiwgImRhdGFfc291cmNlIjogIkNvLiBEaXZpc2lvbiBvZiBXYXRlciBSZXNvdXJjZXMiLCAiZGF0ZV90aW1lIjogIjIwMjAtMDMtMjRUMDg6MzA6MDAuMDAwIiwgImRpdiI6ICIxIiwgImR3cl9hYmJyZXYiOiAiSElHSExEQ08iLCAiZmxhZyI6IG51bGwsICJodHRwX2xpbmthZ2UudXJsIjogImh0dHBzOi8vZHdyLnN0YXRlLmNvLnVzL1N1cmZhY2VXYXRlci9kYXRhL2RldGFpbF9ncmFwaC5hc3B4P0lEPUhJR0hMRENPXHUwMDI2TVRZUEU9RElTQ0hSRyIsICJsb2NhdGlvbi5sYXRpdHVkZSI6IDQwLjIxNTA0MywgImxvY2F0aW9uLmxvbmdpdHVkZSI6IC0xMDUuMjU2MDE3LCAibG9jYXRpb24ubmVlZHNfcmVjb2RpbmciOiBmYWxzZSwgInN0YWdlIjogIjAuNzMiLCAic3RhdGlvbl9uYW1lIjogIkhJR0hMQU5EIERJVENIIEFUIExZT05TLCBDTyIsICJzdGF0aW9uX3N0YXR1cyI6ICJBY3RpdmUiLCAic3RhdGlvbl90eXBlIjogIkRpdmVyc2lvbiIsICJ1c2dzX3N0YXRpb25faWQiOiBudWxsLCAidmFyaWFibGUiOiAiRElTQ0hSRyIsICJ3ZCI6ICI1In0sICJ0eXBlIjogIkZlYXR1cmUifSwgeyJiYm94IjogWy0xMDUuMTk4NTY3LCA0MC4yNjA4MjcsIC0xMDUuMTk4NTY3LCA0MC4yNjA4MjddLCAiZ2VvbWV0cnkiOiB7ImNvb3JkaW5hdGVzIjogWy0xMDUuMTk4NTY3LCA0MC4yNjA4MjddLCAidHlwZSI6ICJQb2ludCJ9LCAiaWQiOiAiMTkiLCAicHJvcGVydGllcyI6IHsiYW1vdW50IjogIjAuMDAiLCAiY291bnR5IjogIkJPVUxERVIiLCAiZGF0YV9zb3VyY2UiOiAiQ29vcGVyYXRpdmUgU0RSIFByb2dyYW0gb2YgQ0RXUiBcdTAwMjYgTkNXQ0QiLCAiZGF0ZV90aW1lIjogIjIwMjAtMDMtMjRUMDk6MDA6MDAuMDAwIiwgImRpdiI6ICIxIiwgImR3cl9hYmJyZXYiOiAiQ1VMRElUQ08iLCAiZmxhZyI6IG51bGwsICJodHRwX2xpbmthZ2UudXJsIjogImh0dHBzOi8vZHdyLnN0YXRlLmNvLnVzL1N1cmZhY2VXYXRlci9kYXRhL2RldGFpbF9ncmFwaC5hc3B4P0lEPUNVTERJVENPXHUwMDI2TVRZUEU9RElTQ0hSRyIsICJsb2NhdGlvbi5sYXRpdHVkZSI6IDQwLjI2MDgyNywgImxvY2F0aW9uLmxvbmdpdHVkZSI6IC0xMDUuMTk4NTY3LCAibG9jYXRpb24ubmVlZHNfcmVjb2RpbmciOiBmYWxzZSwgInN0YWdlIjogbnVsbCwgInN0YXRpb25fbmFtZSI6ICJDVUxWRVIgRElUQ0giLCAic3RhdGlvbl9zdGF0dXMiOiAiQWN0aXZlIiwgInN0YXRpb25fdHlwZSI6ICJEaXZlcnNpb24iLCAidXNnc19zdGF0aW9uX2lkIjogbnVsbCwgInZhcmlhYmxlIjogIkRJU0NIUkciLCAid2QiOiAiNCJ9LCAidHlwZSI6ICJGZWF0dXJlIn0sIHsiYmJveCI6IFstMTA1LjIwOTQxNiwgNDAuMjU2Mjc2MDAwMDAwMDEsIC0xMDUuMjA5NDE2LCA0MC4yNTYyNzYwMDAwMDAwMV0sICJnZW9tZXRyeSI6IHsiY29vcmRpbmF0ZXMiOiBbLTEwNS4yMDk0MTYsIDQwLjI1NjI3NjAwMDAwMDAxXSwgInR5cGUiOiAiUG9pbnQifSwgImlkIjogIjIwIiwgInByb3BlcnRpZXMiOiB7ImFtb3VudCI6ICIwLjAwIiwgImNvdW50eSI6ICJCT1VMREVSIiwgImRhdGFfc291cmNlIjogIk5vcnRoZXJuIENvbG9yYWRvIFdhdGVyIENvbnNlcnZhbmN5IERpc3RyaWN0IiwgImRhdGVfdGltZSI6ICIyMDIwLTAzLTI0VDA4OjAwOjAwLjAwMCIsICJkaXYiOiAiMSIsICJkd3JfYWJicmV2IjogIkxJVFRIMUNPIiwgImZsYWciOiBudWxsLCAiaHR0cF9saW5rYWdlLnVybCI6ICJodHRwOi8vd3d3Lm5vcnRoZXJud2F0ZXIub3JnL1dhdGVyUHJvamVjdHMvV2F0ZXJEYXRhLmFzcHhFYXN0U2xvcGVXYXRlckRhdGEuYXNweCIsICJsb2NhdGlvbi5sYXRpdHVkZSI6IDQwLjI1NjI3NiwgImxvY2F0aW9uLmxvbmdpdHVkZSI6IC0xMDUuMjA5NDE2LCAibG9jYXRpb24ubmVlZHNfcmVjb2RpbmciOiBmYWxzZSwgInN0YWdlIjogbnVsbCwgInN0YXRpb25fbmFtZSI6ICJMSVRUTEUgVEhPTVBTT04gIzEgRElUQ0giLCAic3RhdGlvbl9zdGF0dXMiOiAiQWN0aXZlIiwgInN0YXRpb25fdHlwZSI6ICJEaXZlcnNpb24iLCAidXNnc19zdGF0aW9uX2lkIjogIkVTMTkwMSIsICJ2YXJpYWJsZSI6ICJESVNDSFJHIiwgIndkIjogIjQifSwgInR5cGUiOiAiRmVhdHVyZSJ9LCB7ImJib3giOiBbLTEwNS4xNjc4NzMsIDQwLjE3NDg0NCwgLTEwNS4xNjc4NzMsIDQwLjE3NDg0NF0sICJnZW9tZXRyeSI6IHsiY29vcmRpbmF0ZXMiOiBbLTEwNS4xNjc4NzMsIDQwLjE3NDg0NF0sICJ0eXBlIjogIlBvaW50In0sICJpZCI6ICIyMSIsICJwcm9wZXJ0aWVzIjogeyJhbW91bnQiOiAiMC4xMCIsICJjb3VudHkiOiAiQk9VTERFUiIsICJkYXRhX3NvdXJjZSI6ICJDb29wZXJhdGl2ZSBQcm9ncmFtIG9mIENEV1IsIE5DV0NEIFx1MDAyNiBTVkxIV0NEIiwgImRhdGVfdGltZSI6ICIyMDIwLTAzLTI0VDA4OjQ1OjAwLjAwMCIsICJkaXYiOiAiMSIsICJkd3JfYWJicmV2IjogIkhHUk1EV0NPIiwgImZsYWciOiBudWxsLCAiaHR0cF9saW5rYWdlLnVybCI6ICJodHRwczovL2R3ci5zdGF0ZS5jby51cy9TdXJmYWNlV2F0ZXIvZGF0YS9kZXRhaWxfZ3JhcGguYXNweD9JRD1IR1JNRFdDT1x1MDAyNk1UWVBFPURJU0NIUkciLCAibG9jYXRpb24ubGF0aXR1ZGUiOiA0MC4xNzQ4NDQsICJsb2NhdGlvbi5sb25naXR1ZGUiOiAtMTA1LjE2Nzg3MywgImxvY2F0aW9uLm5lZWRzX3JlY29kaW5nIjogZmFsc2UsICJzdGFnZSI6ICIwLjA2IiwgInN0YXRpb25fbmFtZSI6ICJIQUdFUiBNRUFET1dTIERJVENIIiwgInN0YXRpb25fc3RhdHVzIjogIkFjdGl2ZSIsICJzdGF0aW9uX3R5cGUiOiAiRGl2ZXJzaW9uIiwgInVzZ3Nfc3RhdGlvbl9pZCI6IG51bGwsICJ2YXJpYWJsZSI6ICJESVNDSFJHIiwgIndkIjogIjUifSwgInR5cGUiOiAiRmVhdHVyZSJ9LCB7ImJib3giOiBbLTEwNS4yNTE4MjYsIDQwLjIxMjY1OCwgLTEwNS4yNTE4MjYsIDQwLjIxMjY1OF0sICJnZW9tZXRyeSI6IHsiY29vcmRpbmF0ZXMiOiBbLTEwNS4yNTE4MjYsIDQwLjIxMjY1OF0sICJ0eXBlIjogIlBvaW50In0sICJpZCI6ICIyMiIsICJwcm9wZXJ0aWVzIjogeyJhbW91bnQiOiAiMC4wMCIsICJjb3VudHkiOiAiQk9VTERFUiIsICJkYXRhX3NvdXJjZSI6ICJDb29wZXJhdGl2ZSBQcm9ncmFtIG9mIENEV1IsIE5DV0NEIFx1MDAyNiBTVkxIV0NEIiwgImRhdGVfdGltZSI6ICIyMDIwLTAzLTI0VDA5OjAwOjAwLjAwMCIsICJkaXYiOiAiMSIsICJkd3JfYWJicmV2IjogIlJPVVJFQUNPIiwgImZsYWciOiBudWxsLCAiaHR0cF9saW5rYWdlLnVybCI6ICJodHRwczovL2R3ci5zdGF0ZS5jby51cy9TdXJmYWNlV2F0ZXIvZGF0YS9kZXRhaWxfZ3JhcGguYXNweD9JRD1ST1VSRUFDT1x1MDAyNk1UWVBFPURJU0NIUkciLCAibG9jYXRpb24ubGF0aXR1ZGUiOiA0MC4yMTI2NTgsICJsb2NhdGlvbi5sb25naXR1ZGUiOiAtMTA1LjI1MTgyNiwgImxvY2F0aW9uLm5lZWRzX3JlY29kaW5nIjogZmFsc2UsICJzdGFnZSI6IG51bGwsICJzdGF0aW9uX25hbWUiOiAiUk9VR0ggQU5EIFJFQURZIERJVENIIiwgInN0YXRpb25fc3RhdHVzIjogIkFjdGl2ZSIsICJzdGF0aW9uX3R5cGUiOiAiRGl2ZXJzaW9uIiwgInVzZ3Nfc3RhdGlvbl9pZCI6IG51bGwsICJ2YXJpYWJsZSI6ICJESVNDSFJHIiwgIndkIjogIjUifSwgInR5cGUiOiAiRmVhdHVyZSJ9LCB7ImJib3giOiBbLTEwNS4yMTAzODgwMDAwMDAwMSwgNDAuMTkzMDE5LCAtMTA1LjIxMDM4ODAwMDAwMDAxLCA0MC4xOTMwMTldLCAiZ2VvbWV0cnkiOiB7ImNvb3JkaW5hdGVzIjogWy0xMDUuMjEwMzg4MDAwMDAwMDEsIDQwLjE5MzAxOV0sICJ0eXBlIjogIlBvaW50In0sICJpZCI6ICIyMyIsICJwcm9wZXJ0aWVzIjogeyJhbW91bnQiOiAiMC4wMCIsICJjb3VudHkiOiAiQk9VTERFUiIsICJkYXRhX3NvdXJjZSI6ICJDb29wZXJhdGl2ZSBQcm9ncmFtIG9mIENEV1IsIE5DV0NEIFx1MDAyNiBTVkxIV0NEIiwgImRhdGVfdGltZSI6ICIyMDIwLTAzLTI0VDA5OjAwOjAwLjAwMCIsICJkaXYiOiAiMSIsICJkd3JfYWJicmV2IjogIlRSVURJVENPIiwgImZsYWciOiBudWxsLCAiaHR0cF9saW5rYWdlLnVybCI6ICJodHRwczovL2R3ci5zdGF0ZS5jby51cy9TdXJmYWNlV2F0ZXIvZGF0YS9kZXRhaWxfZ3JhcGguYXNweD9JRD1UUlVESVRDT1x1MDAyNk1UWVBFPURJU0NIUkciLCAibG9jYXRpb24ubGF0aXR1ZGUiOiA0MC4xOTMwMTksICJsb2NhdGlvbi5sb25naXR1ZGUiOiAtMTA1LjIxMDM4OCwgImxvY2F0aW9uLm5lZWRzX3JlY29kaW5nIjogZmFsc2UsICJzdGFnZSI6IG51bGwsICJzdGF0aW9uX25hbWUiOiAiVFJVRSBBTkQgV0VCU1RFUiBESVRDSCIsICJzdGF0aW9uX3N0YXR1cyI6ICJBY3RpdmUiLCAic3RhdGlvbl90eXBlIjogIkRpdmVyc2lvbiIsICJ1c2dzX3N0YXRpb25faWQiOiBudWxsLCAidmFyaWFibGUiOiAiRElTQ0hSRyIsICJ3ZCI6ICI1In0sICJ0eXBlIjogIkZlYXR1cmUifSwgeyJiYm94IjogWy0xMDUuMjE3NTE5LCA0MC4wODYyNzgsIC0xMDUuMjE3NTE5LCA0MC4wODYyNzhdLCAiZ2VvbWV0cnkiOiB7ImNvb3JkaW5hdGVzIjogWy0xMDUuMjE3NTE5LCA0MC4wODYyNzhdLCAidHlwZSI6ICJQb2ludCJ9LCAiaWQiOiAiMjQiLCAicHJvcGVydGllcyI6IHsiYW1vdW50IjogIjAuMDAiLCAiY291bnR5IjogIkJPVUxERVIiLCAiZGF0YV9zb3VyY2UiOiAiTm9ydGhlcm4gQ29sb3JhZG8gV2F0ZXIgQ29uc2VydmFuY3kgRGlzdHJpY3QiLCAiZGF0ZV90aW1lIjogIjIwMjAtMDMtMjRUMDg6MDA6MDAuMDAwIiwgImRpdiI6ICIxIiwgImR3cl9hYmJyZXYiOiAiQkZDSU5GQ08iLCAiZmxhZyI6IG51bGwsICJodHRwX2xpbmthZ2UudXJsIjogImh0dHA6Ly93d3cubm9ydGhlcm53YXRlci5vcmcvV2F0ZXJQcm9qZWN0cy9XYXRlckRhdGEuYXNweEVhc3RTbG9wZVdhdGVyRGF0YS5hc3B4IiwgImxvY2F0aW9uLmxhdGl0dWRlIjogNDAuMDg2Mjc4LCAibG9jYXRpb24ubG9uZ2l0dWRlIjogLTEwNS4yMTc1MTksICJsb2NhdGlvbi5uZWVkc19yZWNvZGluZyI6IGZhbHNlLCAic3RhZ2UiOiAiMC4wMSIsICJzdGF0aW9uX25hbWUiOiAiQk9VTERFUiBSRVNFUlZPSVIgSU5MRVQiLCAic3RhdGlvbl9zdGF0dXMiOiAiQWN0aXZlIiwgInN0YXRpb25fdHlwZSI6ICJTdHJlYW0iLCAidXNnc19zdGF0aW9uX2lkIjogIkVTMTkxNiIsICJ2YXJpYWJsZSI6ICJESVNDSFJHIiwgIndkIjogIjYifSwgInR5cGUiOiAiRmVhdHVyZSJ9LCB7ImJib3giOiBbLTEwNS4zMDQ0MDQsIDQwLjEyNjM4OSwgLTEwNS4zMDQ0MDQsIDQwLjEyNjM4OV0sICJnZW9tZXRyeSI6IHsiY29vcmRpbmF0ZXMiOiBbLTEwNS4zMDQ0MDQsIDQwLjEyNjM4OV0sICJ0eXBlIjogIlBvaW50In0sICJpZCI6ICIyNSIsICJwcm9wZXJ0aWVzIjogeyJhbW91bnQiOiAiMTIuNjAiLCAiY291bnR5IjogIkJPVUxERVIiLCAiZGF0YV9zb3VyY2UiOiAiQ28uIERpdmlzaW9uIG9mIFdhdGVyIFJlc291cmNlcyIsICJkYXRlX3RpbWUiOiAiMjAyMC0wMy0yNFQwOToxNTowMC4wMDAiLCAiZGl2IjogIjEiLCAiZHdyX2FiYnJldiI6ICJMRUZDUkVDTyIsICJmbGFnIjogbnVsbCwgImh0dHBfbGlua2FnZS51cmwiOiAiaHR0cHM6Ly9kd3Iuc3RhdGUuY28udXMvU3VyZmFjZVdhdGVyL2RhdGEvZGV0YWlsX2dyYXBoLmFzcHg/SUQ9TEVGQ1JFQ09cdTAwMjZNVFlQRT1ESVNDSFJHIiwgImxvY2F0aW9uLmxhdGl0dWRlIjogNDAuMTI2Mzg5LCAibG9jYXRpb24ubG9uZ2l0dWRlIjogLTEwNS4zMDQ0MDQsICJsb2NhdGlvbi5uZWVkc19yZWNvZGluZyI6IGZhbHNlLCAic3RhZ2UiOiAiMC40NiIsICJzdGF0aW9uX25hbWUiOiAiTEVGVCBIQU5EIENSRUVLIE5FQVIgQk9VTERFUiwgQ08uIiwgInN0YXRpb25fc3RhdHVzIjogIkFjdGl2ZSIsICJzdGF0aW9uX3R5cGUiOiAiU3RyZWFtIiwgInVzZ3Nfc3RhdGlvbl9pZCI6ICIwNjcyNDUwMCIsICJ2YXJpYWJsZSI6ICJESVNDSFJHIiwgIndkIjogIjUifSwgInR5cGUiOiAiRmVhdHVyZSJ9LCB7ImJib3giOiBbLTEwNS4zNjM0MjIsIDQwLjIxNTY1OCwgLTEwNS4zNjM0MjIsIDQwLjIxNTY1OF0sICJnZW9tZXRyeSI6IHsiY29vcmRpbmF0ZXMiOiBbLTEwNS4zNjM0MjIsIDQwLjIxNTY1OF0sICJ0eXBlIjogIlBvaW50In0sICJpZCI6ICIyNiIsICJwcm9wZXJ0aWVzIjogeyJhbW91bnQiOiAiMTkuMzAiLCAiY291bnR5IjogIkJPVUxERVIiLCAiZGF0YV9zb3VyY2UiOiAiQ28uIERpdmlzaW9uIG9mIFdhdGVyIFJlc291cmNlcyIsICJkYXRlX3RpbWUiOiAiMjAyMC0wMy0yNFQwODo0NTowMC4wMDAiLCAiZGl2IjogIjEiLCAiZHdyX2FiYnJldiI6ICJOU1ZCQlJDTyIsICJmbGFnIjogbnVsbCwgImh0dHBfbGlua2FnZS51cmwiOiAiaHR0cHM6Ly9kd3Iuc3RhdGUuY28udXMvU3VyZmFjZVdhdGVyL2RhdGEvZGV0YWlsX2dyYXBoLmFzcHg/SUQ9TlNWQkJSQ09cdTAwMjZNVFlQRT1ESVNDSFJHIiwgImxvY2F0aW9uLmxhdGl0dWRlIjogNDAuMjE1NjU4LCAibG9jYXRpb24ubG9uZ2l0dWRlIjogLTEwNS4zNjM0MjIsICJsb2NhdGlvbi5uZWVkc19yZWNvZGluZyI6IGZhbHNlLCAic3RhZ2UiOiAiMC4zNCIsICJzdGF0aW9uX25hbWUiOiAiTk9SVEggU0FJTlQgVlJBSU4gQ1JFRUsgQkVMT1cgQlVUVE9OUk9DSyAgKFJBTFBIIFBSSUNFKSBSRVNFUlZPSVIiLCAic3RhdGlvbl9zdGF0dXMiOiAiQWN0aXZlIiwgInN0YXRpb25fdHlwZSI6ICJTdHJlYW0iLCAidXNnc19zdGF0aW9uX2lkIjogbnVsbCwgInZhcmlhYmxlIjogIkRJU0NIUkciLCAid2QiOiAiNSJ9LCAidHlwZSI6ICJGZWF0dXJlIn0sIHsiYmJveCI6IFstMTA1LjA5Nzg3MiwgNDAuMDU5ODA5LCAtMTA1LjA5Nzg3MiwgNDAuMDU5ODA5XSwgImdlb21ldHJ5IjogeyJjb29yZGluYXRlcyI6IFstMTA1LjA5Nzg3MiwgNDAuMDU5ODA5XSwgInR5cGUiOiAiUG9pbnQifSwgImlkIjogIjI3IiwgInByb3BlcnRpZXMiOiB7ImFtb3VudCI6ICI0NC42MCIsICJjb3VudHkiOiAiQk9VTERFUiIsICJkYXRhX3NvdXJjZSI6ICJDby4gRGl2aXNpb24gb2YgV2F0ZXIgUmVzb3VyY2VzIiwgImRhdGVfdGltZSI6ICIyMDIwLTAzLTI0VDA4OjQ1OjAwLjAwMCIsICJkaXYiOiAiMSIsICJkd3JfYWJicmV2IjogIkJPQzEwOUNPIiwgImZsYWciOiBudWxsLCAiaHR0cF9saW5rYWdlLnVybCI6ICJodHRwczovL2R3ci5zdGF0ZS5jby51cy9TdXJmYWNlV2F0ZXIvZGF0YS9kZXRhaWxfZ3JhcGguYXNweD9JRD1CT0MxMDlDT1x1MDAyNk1UWVBFPURJU0NIUkciLCAibG9jYXRpb24ubGF0aXR1ZGUiOiA0MC4wNTk4MDksICJsb2NhdGlvbi5sb25naXR1ZGUiOiAtMTA1LjA5Nzg3MiwgImxvY2F0aW9uLm5lZWRzX3JlY29kaW5nIjogZmFsc2UsICJzdGFnZSI6ICIyLjUyIiwgInN0YXRpb25fbmFtZSI6ICJCT1VMREVSIENSRUVLIEFUIDEwOSBTVCBORUFSIEVSSUUsIENPIiwgInN0YXRpb25fc3RhdHVzIjogIkFjdGl2ZSIsICJzdGF0aW9uX3R5cGUiOiAiU3RyZWFtIiwgInVzZ3Nfc3RhdGlvbl9pZCI6IG51bGwsICJ2YXJpYWJsZSI6ICJESVNDSFJHIiwgIndkIjogIjYifSwgInR5cGUiOiAiRmVhdHVyZSJ9LCB7ImJib3giOiBbLTEwNS41MDQ0NCwgMzkuOTYxNjU1LCAtMTA1LjUwNDQ0LCAzOS45NjE2NTVdLCAiZ2VvbWV0cnkiOiB7ImNvb3JkaW5hdGVzIjogWy0xMDUuNTA0NDQsIDM5Ljk2MTY1NV0sICJ0eXBlIjogIlBvaW50In0sICJpZCI6ICIyOCIsICJwcm9wZXJ0aWVzIjogeyJhbW91bnQiOiAiMjIuNTAiLCAiY291bnR5IjogIkJPVUxERVIiLCAiZGF0YV9zb3VyY2UiOiAiQ28uIERpdmlzaW9uIG9mIFdhdGVyIFJlc291cmNlcyIsICJkYXRlX3RpbWUiOiAiMjAyMC0wMy0yNFQwOToxNTowMC4wMDAiLCAiZGl2IjogIjEiLCAiZHdyX2FiYnJldiI6ICJCT0NNSURDTyIsICJmbGFnIjogbnVsbCwgImh0dHBfbGlua2FnZS51cmwiOiAiaHR0cHM6Ly9kd3Iuc3RhdGUuY28udXMvU3VyZmFjZVdhdGVyL2RhdGEvZGV0YWlsX2dyYXBoLmFzcHg/SUQ9Qk9DTUlEQ09cdTAwMjZNVFlQRT1ESVNDSFJHIiwgImxvY2F0aW9uLmxhdGl0dWRlIjogMzkuOTYxNjU1LCAibG9jYXRpb24ubG9uZ2l0dWRlIjogLTEwNS41MDQ0NCwgImxvY2F0aW9uLm5lZWRzX3JlY29kaW5nIjogZmFsc2UsICJzdGFnZSI6ICIxLjEwIiwgInN0YXRpb25fbmFtZSI6ICJNSURETEUgQk9VTERFUiBDUkVFSyBBVCBORURFUkxBTkQsIENPLiIsICJzdGF0aW9uX3N0YXR1cyI6ICJBY3RpdmUiLCAic3RhdGlvbl90eXBlIjogIlN0cmVhbSIsICJ1c2dzX3N0YXRpb25faWQiOiAiMDY3MjU1MDAiLCAidmFyaWFibGUiOiAiRElTQ0hSRyIsICJ3ZCI6ICI2In0sICJ0eXBlIjogIkZlYXR1cmUifSwgeyJiYm94IjogWy0xMDUuMDc1Njk1MDAwMDAwMDEsIDQwLjE1MzM0MSwgLTEwNS4wNzU2OTUwMDAwMDAwMSwgNDAuMTUzMzQxXSwgImdlb21ldHJ5IjogeyJjb29yZGluYXRlcyI6IFstMTA1LjA3NTY5NTAwMDAwMDAxLCA0MC4xNTMzNDFdLCAidHlwZSI6ICJQb2ludCJ9LCAiaWQiOiAiMjkiLCAicHJvcGVydGllcyI6IHsiYW1vdW50IjogIjM2LjMwIiwgImNvdW50eSI6ICJCT1VMREVSIiwgImRhdGFfc291cmNlIjogIkNvLiBEaXZpc2lvbiBvZiBXYXRlciBSZXNvdXJjZXMiLCAiZGF0ZV90aW1lIjogIjIwMjAtMDMtMjRUMDg6MzA6MDAuMDAwIiwgImRpdiI6ICIxIiwgImR3cl9hYmJyZXYiOiAiU1ZDTE9QQ08iLCAiZmxhZyI6IG51bGwsICJodHRwX2xpbmthZ2UudXJsIjogImh0dHBzOi8vZHdyLnN0YXRlLmNvLnVzL1N1cmZhY2VXYXRlci9kYXRhL2RldGFpbF9ncmFwaC5hc3B4P0lEPVNWQ0xPUENPXHUwMDI2TVRZUEU9RElTQ0hSRyIsICJsb2NhdGlvbi5sYXRpdHVkZSI6IDQwLjE1MzM0MSwgImxvY2F0aW9uLmxvbmdpdHVkZSI6IC0xMDUuMDc1Njk1LCAibG9jYXRpb24ubmVlZHNfcmVjb2RpbmciOiBmYWxzZSwgInN0YWdlIjogIjMuNTciLCAic3RhdGlvbl9uYW1lIjogIlNBSU5UIFZSQUlOIENSRUVLIEJFTE9XIEtFTiBQUkFUVCBCTFZEIEFUIExPTkdNT05ULCBDTyIsICJzdGF0aW9uX3N0YXR1cyI6ICJBY3RpdmUiLCAic3RhdGlvbl90eXBlIjogIlN0cmVhbSIsICJ1c2dzX3N0YXRpb25faWQiOiBudWxsLCAidmFyaWFibGUiOiAiRElTQ0hSRyIsICJ3ZCI6ICI1In0sICJ0eXBlIjogIkZlYXR1cmUifSwgeyJiYm94IjogWy0xMDUuMTYwODc2LCA0MC4xNzA5OTgsIC0xMDUuMTYwODc2LCA0MC4xNzA5OThdLCAiZ2VvbWV0cnkiOiB7ImNvb3JkaW5hdGVzIjogWy0xMDUuMTYwODc2LCA0MC4xNzA5OThdLCAidHlwZSI6ICJQb2ludCJ9LCAiaWQiOiAiMzAiLCAicHJvcGVydGllcyI6IHsiYW1vdW50IjogIjAuMzgiLCAiY291bnR5IjogIkJPVUxERVIiLCAiZGF0YV9zb3VyY2UiOiAiQ29vcGVyYXRpdmUgUHJvZ3JhbSBvZiBDRFdSLCBOQ1dDRCBcdTAwMjYgU1ZMSFdDRCIsICJkYXRlX3RpbWUiOiAiMjAyMC0wMy0yNFQwOTowMDowMC4wMDAiLCAiZGl2IjogIjEiLCAiZHdyX2FiYnJldiI6ICJTRkxESVRDTyIsICJmbGFnIjogbnVsbCwgImh0dHBfbGlua2FnZS51cmwiOiAiaHR0cHM6Ly9kd3Iuc3RhdGUuY28udXMvU3VyZmFjZVdhdGVyL2RhdGEvZGV0YWlsX2dyYXBoLmFzcHg/SUQ9U0ZMRElUQ09cdTAwMjZNVFlQRT1ESVNDSFJHIiwgImxvY2F0aW9uLmxhdGl0dWRlIjogNDAuMTcwOTk4LCAibG9jYXRpb24ubG9uZ2l0dWRlIjogLTEwNS4xNjA4NzYsICJsb2NhdGlvbi5uZWVkc19yZWNvZGluZyI6IGZhbHNlLCAic3RhZ2UiOiAiMC4xMSIsICJzdGF0aW9uX25hbWUiOiAiU09VVEggRkxBVCBESVRDSCIsICJzdGF0aW9uX3N0YXR1cyI6ICJBY3RpdmUiLCAic3RhdGlvbl90eXBlIjogIkRpdmVyc2lvbiIsICJ1c2dzX3N0YXRpb25faWQiOiBudWxsLCAidmFyaWFibGUiOiAiRElTQ0hSRyIsICJ3ZCI6ICI1In0sICJ0eXBlIjogIkZlYXR1cmUifSwgeyJiYm94IjogWy0xMDUuMTc4ODc1LCA0MC4wNTE2NTIsIC0xMDUuMTc4ODc1LCA0MC4wNTE2NTJdLCAiZ2VvbWV0cnkiOiB7ImNvb3JkaW5hdGVzIjogWy0xMDUuMTc4ODc1LCA0MC4wNTE2NTJdLCAidHlwZSI6ICJQb2ludCJ9LCAiaWQiOiAiMzEiLCAicHJvcGVydGllcyI6IHsiYW1vdW50IjogIjMxLjUwIiwgImNvdW50eSI6ICJCT1VMREVSIiwgImRhdGFfc291cmNlIjogIlUuUy4gR2VvbG9naWNhbCBTdXJ2ZXkiLCAiZGF0ZV90aW1lIjogIjIwMjAtMDMtMjRUMDk6MTU6MDAuMDAwIiwgImRpdiI6ICIxIiwgImR3cl9hYmJyZXYiOiAiQk9DTk9SQ08iLCAiZmxhZyI6IG51bGwsICJodHRwX2xpbmthZ2UudXJsIjogImh0dHBzOi8vd2F0ZXJkYXRhLnVzZ3MuZ292L253aXMvdXY/MDY3MzAyMDAiLCAibG9jYXRpb24ubGF0aXR1ZGUiOiA0MC4wNTE2NTIsICJsb2NhdGlvbi5sb25naXR1ZGUiOiAtMTA1LjE3ODg3NSwgImxvY2F0aW9uLm5lZWRzX3JlY29kaW5nIjogZmFsc2UsICJzdGFnZSI6IG51bGwsICJzdGF0aW9uX25hbWUiOiAiQk9VTERFUiBDUkVFSyBBVCBOT1JUSCA3NVRIIFNULiBORUFSIEJPVUxERVIsIENPIiwgInN0YXRpb25fc3RhdHVzIjogIkFjdGl2ZSIsICJzdGF0aW9uX3R5cGUiOiAiU3RyZWFtIiwgInVzZ3Nfc3RhdGlvbl9pZCI6ICIwNjczMDIwMCIsICJ2YXJpYWJsZSI6ICJESVNDSFJHIiwgIndkIjogIjYifSwgInR5cGUiOiAiRmVhdHVyZSJ9LCB7ImJib3giOiBbLTEwNS4zMDQ5OSwgMzkuOTMxNTk3LCAtMTA1LjMwNDk5LCAzOS45MzE1OTddLCAiZ2VvbWV0cnkiOiB7ImNvb3JkaW5hdGVzIjogWy0xMDUuMzA0OTksIDM5LjkzMTU5N10sICJ0eXBlIjogIlBvaW50In0sICJpZCI6ICIzMiIsICJwcm9wZXJ0aWVzIjogeyJhbW91bnQiOiAiMTYuMDAiLCAiY291bnR5IjogIkJPVUxERVIiLCAiZGF0YV9zb3VyY2UiOiAiQ28uIERpdmlzaW9uIG9mIFdhdGVyIFJlc291cmNlcyIsICJkYXRlX3RpbWUiOiAiMjAyMC0wMy0yNFQwOToxNTowMC4wMDAiLCAiZGl2IjogIjEiLCAiZHdyX2FiYnJldiI6ICJCT0NFTFNDTyIsICJmbGFnIjogIkljZSIsICJodHRwX2xpbmthZ2UudXJsIjogImh0dHBzOi8vZHdyLnN0YXRlLmNvLnVzL1N1cmZhY2VXYXRlci9kYXRhL2RldGFpbF9ncmFwaC5hc3B4P0lEPUJPQ0VMU0NPXHUwMDI2TVRZUEU9RElTQ0hSRyIsICJsb2NhdGlvbi5sYXRpdHVkZSI6IDM5LjkzMTU5NywgImxvY2F0aW9uLmxvbmdpdHVkZSI6IC0xMDUuMzA0OTksICJsb2NhdGlvbi5uZWVkc19yZWNvZGluZyI6IGZhbHNlLCAic3RhZ2UiOiAiMi4yMSIsICJzdGF0aW9uX25hbWUiOiAiU09VVEggQk9VTERFUiBDUkVFSyBORUFSIEVMRE9SQURPIFNQUklOR1MsIENPLiIsICJzdGF0aW9uX3N0YXR1cyI6ICJBY3RpdmUiLCAic3RhdGlvbl90eXBlIjogIlN0cmVhbSIsICJ1c2dzX3N0YXRpb25faWQiOiBudWxsLCAidmFyaWFibGUiOiAiRElTQ0hSRyIsICJ3ZCI6ICI2In0sICJ0eXBlIjogIkZlYXR1cmUifSwgeyJiYm94IjogWy0xMDUuMTY0Mzk3LCA0MC4yNTc4NDQsIC0xMDUuMTY0Mzk3LCA0MC4yNTc4NDRdLCAiZ2VvbWV0cnkiOiB7ImNvb3JkaW5hdGVzIjogWy0xMDUuMTY0Mzk3LCA0MC4yNTc4NDRdLCAidHlwZSI6ICJQb2ludCJ9LCAiaWQiOiAiMzMiLCAicHJvcGVydGllcyI6IHsiYW1vdW50IjogIjAuMDEiLCAiY291bnR5IjogIkJPVUxERVIiLCAiZGF0YV9zb3VyY2UiOiAiQ29vcGVyYXRpdmUgU0RSIFByb2dyYW0gb2YgQ0RXUiBcdTAwMjYgTkNXQ0QiLCAiZGF0ZV90aW1lIjogIjIwMjAtMDMtMjRUMDk6MDA6MDAuMDAwIiwgImRpdiI6ICIxIiwgImR3cl9hYmJyZXYiOiAiQkxXRElUQ08iLCAiZmxhZyI6IG51bGwsICJodHRwX2xpbmthZ2UudXJsIjogImh0dHBzOi8vZHdyLnN0YXRlLmNvLnVzL1N1cmZhY2VXYXRlci9kYXRhL2RldGFpbF9ncmFwaC5hc3B4P0lEPUJMV0RJVENPXHUwMDI2TVRZUEU9RElTQ0hSRyIsICJsb2NhdGlvbi5sYXRpdHVkZSI6IDQwLjI1Nzg0NCwgImxvY2F0aW9uLmxvbmdpdHVkZSI6IC0xMDUuMTY0Mzk3LCAibG9jYXRpb24ubmVlZHNfcmVjb2RpbmciOiBmYWxzZSwgInN0YWdlIjogIjAuMDMiLCAic3RhdGlvbl9uYW1lIjogIkJMT1dFUiBESVRDSCIsICJzdGF0aW9uX3N0YXR1cyI6ICJBY3RpdmUiLCAic3RhdGlvbl90eXBlIjogIkRpdmVyc2lvbiIsICJ1c2dzX3N0YXRpb25faWQiOiBudWxsLCAidmFyaWFibGUiOiAiRElTQ0hSRyIsICJ3ZCI6ICI0In0sICJ0eXBlIjogIkZlYXR1cmUifSwgeyJiYm94IjogWy0xMDUuMjA5NSwgNDAuMjU1Nzc2LCAtMTA1LjIwOTUsIDQwLjI1NTc3Nl0sICJnZW9tZXRyeSI6IHsiY29vcmRpbmF0ZXMiOiBbLTEwNS4yMDk1LCA0MC4yNTU3NzZdLCAidHlwZSI6ICJQb2ludCJ9LCAiaWQiOiAiMzQiLCAicHJvcGVydGllcyI6IHsiYW1vdW50IjogIjAuMTAiLCAiY291bnR5IjogIkJPVUxERVIiLCAiZGF0YV9zb3VyY2UiOiAiTm9ydGhlcm4gQ29sb3JhZG8gV2F0ZXIgQ29uc2VydmFuY3kgRGlzdHJpY3QiLCAiZGF0ZV90aW1lIjogIjIwMjAtMDMtMjRUMDg6MDA6MDAuMDAwIiwgImRpdiI6ICIxIiwgImR3cl9hYmJyZXYiOiAiTElUVEgyQ08iLCAiZmxhZyI6IG51bGwsICJodHRwX2xpbmthZ2UudXJsIjogImh0dHA6Ly93d3cubm9ydGhlcm53YXRlci5vcmcvV2F0ZXJQcm9qZWN0cy9XYXRlckRhdGEuYXNweEVhc3RTbG9wZVdhdGVyRGF0YS5hc3B4IiwgImxvY2F0aW9uLmxhdGl0dWRlIjogNDAuMjU1Nzc2LCAibG9jYXRpb24ubG9uZ2l0dWRlIjogLTEwNS4yMDk1LCAibG9jYXRpb24ubmVlZHNfcmVjb2RpbmciOiBmYWxzZSwgInN0YWdlIjogIjAuMTAiLCAic3RhdGlvbl9uYW1lIjogIkxJVFRMRSBUSE9NUFNPTiAjMiBESVRDSCIsICJzdGF0aW9uX3N0YXR1cyI6ICJBY3RpdmUiLCAic3RhdGlvbl90eXBlIjogIkRpdmVyc2lvbiIsICJ1c2dzX3N0YXRpb25faWQiOiAiRVMxOTAwIiwgInZhcmlhYmxlIjogIkRJU0NIUkciLCAid2QiOiAiNCJ9LCAidHlwZSI6ICJGZWF0dXJlIn0sIHsiYmJveCI6IFstMTA1LjM2NTM2NSwgNDAuMjE2MjYzLCAtMTA1LjM2NTM2NSwgNDAuMjE2MjYzXSwgImdlb21ldHJ5IjogeyJjb29yZGluYXRlcyI6IFstMTA1LjM2NTM2NSwgNDAuMjE2MjYzXSwgInR5cGUiOiAiUG9pbnQifSwgImlkIjogIjM1IiwgInByb3BlcnRpZXMiOiB7ImFtb3VudCI6ICIxMjg5MC4wMCIsICJjb3VudHkiOiAiQk9VTERFUiIsICJkYXRhX3NvdXJjZSI6ICJDby4gRGl2aXNpb24gb2YgV2F0ZXIgUmVzb3VyY2VzIiwgImRhdGVfdGltZSI6ICIyMDIwLTAzLTI0VDA4OjQ1OjAwLjAwMCIsICJkaXYiOiAiMSIsICJkd3JfYWJicmV2IjogIkJSS0RBTUNPIiwgImZsYWciOiBudWxsLCAiaHR0cF9saW5rYWdlLnVybCI6ICJodHRwczovL2R3ci5zdGF0ZS5jby51cy9TdXJmYWNlV2F0ZXIvZGF0YS9kZXRhaWxfZ3JhcGguYXNweD9JRD1CUktEQU1DT1x1MDAyNk1UWVBFPVNUT1JBR0UiLCAibG9jYXRpb24ubGF0aXR1ZGUiOiA0MC4yMTYyNjMsICJsb2NhdGlvbi5sb25naXR1ZGUiOiAtMTA1LjM2NTM2NSwgImxvY2F0aW9uLm5lZWRzX3JlY29kaW5nIjogZmFsc2UsICJzdGFnZSI6ICI2Mzg0LjA2IiwgInN0YXRpb25fbmFtZSI6ICJCVVRUT05ST0NLIChSQUxQSCBQUklDRSkgUkVTRVJWT0lSIiwgInN0YXRpb25fc3RhdHVzIjogIkFjdGl2ZSIsICJzdGF0aW9uX3R5cGUiOiAiUmVzZXJ2b2lyIiwgInVzZ3Nfc3RhdGlvbl9pZCI6IG51bGwsICJ2YXJpYWJsZSI6ICJTVE9SQUdFIiwgIndkIjogIjUifSwgInR5cGUiOiAiRmVhdHVyZSJ9LCB7ImJib3giOiBbLTEwNS4xNTExNDMsIDQwLjA1MzY2MSwgLTEwNS4xNTExNDMsIDQwLjA1MzY2MV0sICJnZW9tZXRyeSI6IHsiY29vcmRpbmF0ZXMiOiBbLTEwNS4xNTExNDMsIDQwLjA1MzY2MV0sICJ0eXBlIjogIlBvaW50In0sICJpZCI6ICIzNiIsICJwcm9wZXJ0aWVzIjogeyJhbW91bnQiOiAiMi44NCIsICJjb3VudHkiOiAiQk9VTERFUiIsICJkYXRhX3NvdXJjZSI6ICJDb29wZXJhdGl2ZSBQcm9ncmFtIG9mIENEV1IsIE5DV0NEIFx1MDAyNiBMU1BXQ0QiLCAiZGF0ZV90aW1lIjogIjIwMjAtMDMtMjRUMDk6MDA6MDAuMDAwIiwgImRpdiI6ICIxIiwgImR3cl9hYmJyZXYiOiAiTEVHRElUQ08iLCAiZmxhZyI6IG51bGwsICJodHRwX2xpbmthZ2UudXJsIjogImh0dHBzOi8vZHdyLnN0YXRlLmNvLnVzL1N1cmZhY2VXYXRlci9kYXRhL2RldGFpbF9ncmFwaC5hc3B4P0lEPUxFR0RJVENPXHUwMDI2TVRZUEU9RElTQ0hSRyIsICJsb2NhdGlvbi5sYXRpdHVkZSI6IDQwLjA1MzY2MSwgImxvY2F0aW9uLmxvbmdpdHVkZSI6IC0xMDUuMTUxMTQzLCAibG9jYXRpb24ubmVlZHNfcmVjb2RpbmciOiBmYWxzZSwgInN0YWdlIjogIjAuMjIiLCAic3RhdGlvbl9uYW1lIjogIkxFR0dFVFQgRElUQ0giLCAic3RhdGlvbl9zdGF0dXMiOiAiQWN0aXZlIiwgInN0YXRpb25fdHlwZSI6ICJEaXZlcnNpb24iLCAidXNnc19zdGF0aW9uX2lkIjogbnVsbCwgInZhcmlhYmxlIjogIkRJU0NIUkciLCAid2QiOiAiNiJ9LCAidHlwZSI6ICJGZWF0dXJlIn0sIHsiYmJveCI6IFstMTA1LjIxMDQyNCwgNDAuMTkzMjgwMDAwMDAwMDEsIC0xMDUuMjEwNDI0LCA0MC4xOTMyODAwMDAwMDAwMV0sICJnZW9tZXRyeSI6IHsiY29vcmRpbmF0ZXMiOiBbLTEwNS4yMTA0MjQsIDQwLjE5MzI4MDAwMDAwMDAxXSwgInR5cGUiOiAiUG9pbnQifSwgImlkIjogIjM3IiwgInByb3BlcnRpZXMiOiB7ImFtb3VudCI6ICIwLjAwIiwgImNvdW50eSI6ICJCT1VMREVSIiwgImRhdGFfc291cmNlIjogIkNvb3BlcmF0aXZlIFByb2dyYW0gb2YgQ0RXUiwgTkNXQ0QgXHUwMDI2IFNWTEhXQ0QiLCAiZGF0ZV90aW1lIjogIjIwMjAtMDMtMjRUMDk6MDA6MDAuMDAwIiwgImRpdiI6ICIxIiwgImR3cl9hYmJyZXYiOiAiV0VCRElUQ08iLCAiZmxhZyI6IG51bGwsICJodHRwX2xpbmthZ2UudXJsIjogImh0dHBzOi8vZHdyLnN0YXRlLmNvLnVzL1N1cmZhY2VXYXRlci9kYXRhL2RldGFpbF9ncmFwaC5hc3B4P0lEPVdFQkRJVENPXHUwMDI2TVRZUEU9RElTQ0hSRyIsICJsb2NhdGlvbi5sYXRpdHVkZSI6IDQwLjE5MzI4LCAibG9jYXRpb24ubG9uZ2l0dWRlIjogLTEwNS4yMTA0MjQsICJsb2NhdGlvbi5uZWVkc19yZWNvZGluZyI6IGZhbHNlLCAic3RhZ2UiOiBudWxsLCAic3RhdGlvbl9uYW1lIjogIldFQlNURVIgTUNDQVNMSU4gRElUQ0giLCAic3RhdGlvbl9zdGF0dXMiOiAiQWN0aXZlIiwgInN0YXRpb25fdHlwZSI6ICJEaXZlcnNpb24iLCAidXNnc19zdGF0aW9uX2lkIjogbnVsbCwgInZhcmlhYmxlIjogIkRJU0NIUkciLCAid2QiOiAiNSJ9LCAidHlwZSI6ICJGZWF0dXJlIn0sIHsiYmJveCI6IFstMTA1LjIyMjYzOSwgNDAuMTk5MzIxLCAtMTA1LjIyMjYzOSwgNDAuMTk5MzIxXSwgImdlb21ldHJ5IjogeyJjb29yZGluYXRlcyI6IFstMTA1LjIyMjYzOSwgNDAuMTk5MzIxXSwgInR5cGUiOiAiUG9pbnQifSwgImlkIjogIjM4IiwgInByb3BlcnRpZXMiOiB7ImFtb3VudCI6ICIwLjAwIiwgImNvdW50eSI6ICJCT1VMREVSIiwgImRhdGFfc291cmNlIjogIkNvb3BlcmF0aXZlIFByb2dyYW0gb2YgQ0RXUiwgTkNXQ0QgXHUwMDI2IFNWTEhXQ0QiLCAiZGF0ZV90aW1lIjogIjIwMjAtMDMtMjRUMDg6NDU6MDAuMDAwIiwgImRpdiI6ICIxIiwgImR3cl9hYmJyZXYiOiAiR09ESVQxQ08iLCAiZmxhZyI6IG51bGwsICJodHRwX2xpbmthZ2UudXJsIjogImh0dHBzOi8vZHdyLnN0YXRlLmNvLnVzL1N1cmZhY2VXYXRlci9kYXRhL2RldGFpbF9ncmFwaC5hc3B4P0lEPUdPRElUMUNPXHUwMDI2TVRZUEU9RElTQ0hSRyIsICJsb2NhdGlvbi5sYXRpdHVkZSI6IDQwLjE5OTMyMSwgImxvY2F0aW9uLmxvbmdpdHVkZSI6IC0xMDUuMjIyNjM5LCAibG9jYXRpb24ubmVlZHNfcmVjb2RpbmciOiBmYWxzZSwgInN0YWdlIjogbnVsbCwgInN0YXRpb25fbmFtZSI6ICJHT1NTIERJVENIIDEiLCAic3RhdGlvbl9zdGF0dXMiOiAiQWN0aXZlIiwgInN0YXRpb25fdHlwZSI6ICJEaXZlcnNpb24iLCAidXNnc19zdGF0aW9uX2lkIjogbnVsbCwgInZhcmlhYmxlIjogIkRJU0NIUkciLCAid2QiOiAiNSJ9LCAidHlwZSI6ICJGZWF0dXJlIn0sIHsiYmJveCI6IFstMTA1LjE2ODQ3MSwgNDAuMTYwNzA1LCAtMTA1LjE2ODQ3MSwgNDAuMTYwNzA1XSwgImdlb21ldHJ5IjogeyJjb29yZGluYXRlcyI6IFstMTA1LjE2ODQ3MSwgNDAuMTYwNzA1XSwgInR5cGUiOiAiUG9pbnQifSwgImlkIjogIjM5IiwgInByb3BlcnRpZXMiOiB7ImFtb3VudCI6ICIwLjAwIiwgImNvdW50eSI6ICJCT1VMREVSIiwgImRhdGFfc291cmNlIjogIkNvLiBEaXZpc2lvbiBvZiBXYXRlciBSZXNvdXJjZXMiLCAiZGF0ZV90aW1lIjogIjIwMjAtMDMtMjRUMDc6NDU6MDAuMDAwIiwgImRpdiI6ICIxIiwgImR3cl9hYmJyZXYiOiAiUEVDUlROQ08iLCAiZmxhZyI6IG51bGwsICJodHRwX2xpbmthZ2UudXJsIjogImh0dHBzOi8vZHdyLnN0YXRlLmNvLnVzL1N1cmZhY2VXYXRlci9kYXRhL2RldGFpbF9ncmFwaC5hc3B4P0lEPVBFQ1JUTkNPXHUwMDI2TVRZUEU9RElTQ0hSRyIsICJsb2NhdGlvbi5sYXRpdHVkZSI6IDQwLjE2MDcwNSwgImxvY2F0aW9uLmxvbmdpdHVkZSI6IC0xMDUuMTY4NDcxLCAibG9jYXRpb24ubmVlZHNfcmVjb2RpbmciOiBmYWxzZSwgInN0YWdlIjogbnVsbCwgInN0YXRpb25fbmFtZSI6ICJQRUNLLVBFTExBIEFVR01FTlRBVElPTiBSRVRVUk4iLCAic3RhdGlvbl9zdGF0dXMiOiAiQWN0aXZlIiwgInN0YXRpb25fdHlwZSI6ICJEaXZlcnNpb24iLCAidXNnc19zdGF0aW9uX2lkIjogbnVsbCwgInZhcmlhYmxlIjogIkRJU0NIUkciLCAid2QiOiAiNSJ9LCAidHlwZSI6ICJGZWF0dXJlIn0sIHsiYmJveCI6IFstMTA1LjIxODY3NywgMzkuOTg2MTY5LCAtMTA1LjIxODY3NywgMzkuOTg2MTY5XSwgImdlb21ldHJ5IjogeyJjb29yZGluYXRlcyI6IFstMTA1LjIxODY3NywgMzkuOTg2MTY5XSwgInR5cGUiOiAiUG9pbnQifSwgImlkIjogIjQwIiwgInByb3BlcnRpZXMiOiB7ImFtb3VudCI6ICIwLjAwIiwgImNvdW50eSI6ICJCT1VMREVSIiwgImRhdGFfc291cmNlIjogIkNvb3BlcmF0aXZlIFByb2dyYW0gb2YgQ0RXUiwgTkNXQ0QgXHUwMDI2IExTUFdDRCIsICJkYXRlX3RpbWUiOiAiMjAyMC0wMy0yNFQwODowMDowMC4wMDAiLCAiZGl2IjogIjEiLCAiZHdyX2FiYnJldiI6ICJEUllDQVJDTyIsICJmbGFnIjogbnVsbCwgImh0dHBfbGlua2FnZS51cmwiOiAiaHR0cHM6Ly9kd3Iuc3RhdGUuY28udXMvU3VyZmFjZVdhdGVyL2RhdGEvZGV0YWlsX2dyYXBoLmFzcHg/SUQ9RFJZQ0FSQ09cdTAwMjZNVFlQRT1ESVNDSFJHIiwgImxvY2F0aW9uLmxhdGl0dWRlIjogMzkuOTg2MTY5LCAibG9jYXRpb24ubG9uZ2l0dWRlIjogLTEwNS4yMTg2NzcsICJsb2NhdGlvbi5uZWVkc19yZWNvZGluZyI6IGZhbHNlLCAic3RhZ2UiOiBudWxsLCAic3RhdGlvbl9uYW1lIjogIkRSWSBDUkVFSyBDQVJSSUVSIiwgInN0YXRpb25fc3RhdHVzIjogIkFjdGl2ZSIsICJzdGF0aW9uX3R5cGUiOiAiRGl2ZXJzaW9uIiwgInVzZ3Nfc3RhdGlvbl9pZCI6IG51bGwsICJ2YXJpYWJsZSI6ICJESVNDSFJHIiwgIndkIjogIjYifSwgInR5cGUiOiAiRmVhdHVyZSJ9LCB7ImJib3giOiBbLTEwNS4xMzA4MTksIDQwLjEzNDI3OCwgLTEwNS4xMzA4MTksIDQwLjEzNDI3OF0sICJnZW9tZXRyeSI6IHsiY29vcmRpbmF0ZXMiOiBbLTEwNS4xMzA4MTksIDQwLjEzNDI3OF0sICJ0eXBlIjogIlBvaW50In0sICJpZCI6ICI0MSIsICJwcm9wZXJ0aWVzIjogeyJhbW91bnQiOiAiMy4zNCIsICJjb3VudHkiOiAiQk9VTERFUiIsICJkYXRhX3NvdXJjZSI6ICJVLlMuIEdlb2xvZ2ljYWwgU3VydmV5IiwgImRhdGVfdGltZSI6ICIyMDIwLTAzLTI0VDA5OjEwOjAwLjAwMCIsICJkaXYiOiAiMSIsICJkd3JfYWJicmV2IjogIkxFRlRIT0NPIiwgImZsYWciOiBudWxsLCAiaHR0cF9saW5rYWdlLnVybCI6ICJodHRwczovL3dhdGVyZGF0YS51c2dzLmdvdi9ud2lzL3V2PzA2NzI0OTcwIiwgImxvY2F0aW9uLmxhdGl0dWRlIjogNDAuMTM0Mjc4LCAibG9jYXRpb24ubG9uZ2l0dWRlIjogLTEwNS4xMzA4MTksICJsb2NhdGlvbi5uZWVkc19yZWNvZGluZyI6IGZhbHNlLCAic3RhZ2UiOiBudWxsLCAic3RhdGlvbl9uYW1lIjogIkxFRlQgSEFORCBDUkVFSyBBVCBIT1ZFUiBST0FEIE5FQVIgTE9OR01PTlQsIENPIiwgInN0YXRpb25fc3RhdHVzIjogIkFjdGl2ZSIsICJzdGF0aW9uX3R5cGUiOiAiU3RyZWFtIiwgInVzZ3Nfc3RhdGlvbl9pZCI6ICIwNjcyNDk3MCIsICJ2YXJpYWJsZSI6ICJESVNDSFJHIiwgIndkIjogIjUifSwgInR5cGUiOiAiRmVhdHVyZSJ9LCB7ImJib3giOiBbLTEwNS4xNjc2MjIsIDQwLjE3MjkyNSwgLTEwNS4xNjc2MjIsIDQwLjE3MjkyNV0sICJnZW9tZXRyeSI6IHsiY29vcmRpbmF0ZXMiOiBbLTEwNS4xNjc2MjIsIDQwLjE3MjkyNV0sICJ0eXBlIjogIlBvaW50In0sICJpZCI6ICI0MiIsICJwcm9wZXJ0aWVzIjogeyJhbW91bnQiOiAiMC4wMCIsICJjb3VudHkiOiAiQk9VTERFUiIsICJkYXRhX3NvdXJjZSI6ICJDb29wZXJhdGl2ZSBTRFIgUHJvZ3JhbSBvZiBDRFdSIFx1MDAyNiBOQ1dDRCIsICJkYXRlX3RpbWUiOiAiMjAyMC0wMy0yNFQwOTowMDowMC4wMDAiLCAiZGl2IjogIjEiLCAiZHdyX2FiYnJldiI6ICJOT1JNVVRDTyIsICJmbGFnIjogbnVsbCwgImh0dHBfbGlua2FnZS51cmwiOiAiaHR0cHM6Ly9kd3Iuc3RhdGUuY28udXMvU3VyZmFjZVdhdGVyL2RhdGEvZGV0YWlsX2dyYXBoLmFzcHg/SUQ9Tk9STVVUQ09cdTAwMjZNVFlQRT1ESVNDSFJHIiwgImxvY2F0aW9uLmxhdGl0dWRlIjogNDAuMTcyOTI1LCAibG9jYXRpb24ubG9uZ2l0dWRlIjogLTEwNS4xNjc2MjIsICJsb2NhdGlvbi5uZWVkc19yZWNvZGluZyI6IGZhbHNlLCAic3RhZ2UiOiBudWxsLCAic3RhdGlvbl9uYW1lIjogIk5PUlRIV0VTVCBNVVRVQUwgRElUQ0giLCAic3RhdGlvbl9zdGF0dXMiOiAiQWN0aXZlIiwgInN0YXRpb25fdHlwZSI6ICJEaXZlcnNpb24iLCAidXNnc19zdGF0aW9uX2lkIjogbnVsbCwgInZhcmlhYmxlIjogIkRJU0NIUkciLCAid2QiOiAiNSJ9LCAidHlwZSI6ICJGZWF0dXJlIn0sIHsiYmJveCI6IFstMTA1LjIxODc3NywgNDAuMjA0MTkzLCAtMTA1LjIxODc3NywgNDAuMjA0MTkzXSwgImdlb21ldHJ5IjogeyJjb29yZGluYXRlcyI6IFstMTA1LjIxODc3NywgNDAuMjA0MTkzXSwgInR5cGUiOiAiUG9pbnQifSwgImlkIjogIjQzIiwgInByb3BlcnRpZXMiOiB7ImFtb3VudCI6ICIwLjAwIiwgImNvdW50eSI6ICJCT1VMREVSIiwgImRhdGFfc291cmNlIjogIkNvb3BlcmF0aXZlIFByb2dyYW0gb2YgQ0RXUiwgTkNXQ0QgXHUwMDI2IFNWTEhXQ0QiLCAiZGF0ZV90aW1lIjogIjIwMjAtMDMtMjRUMDk6MDA6MDAuMDAwIiwgImRpdiI6ICIxIiwgImR3cl9hYmJyZXYiOiAiTE9OU1VQQ08iLCAiZmxhZyI6IG51bGwsICJodHRwX2xpbmthZ2UudXJsIjogImh0dHBzOi8vZHdyLnN0YXRlLmNvLnVzL1N1cmZhY2VXYXRlci9kYXRhL2RldGFpbF9ncmFwaC5hc3B4P0lEPUxPTlNVUENPXHUwMDI2TVRZUEU9RElTQ0hSRyIsICJsb2NhdGlvbi5sYXRpdHVkZSI6IDQwLjIwNDE5MywgImxvY2F0aW9uLmxvbmdpdHVkZSI6IC0xMDUuMjE4Nzc3LCAibG9jYXRpb24ubmVlZHNfcmVjb2RpbmciOiBmYWxzZSwgInN0YWdlIjogbnVsbCwgInN0YXRpb25fbmFtZSI6ICJMT05HTU9OVCBTVVBQTFkgRElUQ0giLCAic3RhdGlvbl9zdGF0dXMiOiAiQWN0aXZlIiwgInN0YXRpb25fdHlwZSI6ICJEaXZlcnNpb24iLCAidXNnc19zdGF0aW9uX2lkIjogbnVsbCwgInZhcmlhYmxlIjogIkRJU0NIUkciLCAid2QiOiAiNSJ9LCAidHlwZSI6ICJGZWF0dXJlIn0sIHsiYmJveCI6IFstMTA1LjMzMDg0MSwgNDAuMDA2MzgwMDAwMDAwMDEsIC0xMDUuMzMwODQxLCA0MC4wMDYzODAwMDAwMDAwMV0sICJnZW9tZXRyeSI6IHsiY29vcmRpbmF0ZXMiOiBbLTEwNS4zMzA4NDEsIDQwLjAwNjM4MDAwMDAwMDAxXSwgInR5cGUiOiAiUG9pbnQifSwgImlkIjogIjQ0IiwgInByb3BlcnRpZXMiOiB7ImFtb3VudCI6ICIxOS42MCIsICJjb3VudHkiOiAiQk9VTERFUiIsICJkYXRhX3NvdXJjZSI6ICJDby4gRGl2aXNpb24gb2YgV2F0ZXIgUmVzb3VyY2VzIiwgImRhdGVfdGltZSI6ICIyMDIwLTAzLTI0VDA5OjE1OjAwLjAwMCIsICJkaXYiOiAiMSIsICJkd3JfYWJicmV2IjogIkJPQ09ST0NPIiwgImZsYWciOiAiSWNlIiwgImh0dHBfbGlua2FnZS51cmwiOiAiaHR0cHM6Ly9kd3Iuc3RhdGUuY28udXMvU3VyZmFjZVdhdGVyL2RhdGEvZGV0YWlsX2dyYXBoLmFzcHg/SUQ9Qk9DT1JPQ09cdTAwMjZNVFlQRT1ESVNDSFJHIiwgImxvY2F0aW9uLmxhdGl0dWRlIjogNDAuMDA2MzgsICJsb2NhdGlvbi5sb25naXR1ZGUiOiAtMTA1LjMzMDg0MSwgImxvY2F0aW9uLm5lZWRzX3JlY29kaW5nIjogZmFsc2UsICJzdGFnZSI6ICIxLjgzIiwgInN0YXRpb25fbmFtZSI6ICJCT1VMREVSIENSRUVLIE5FQVIgT1JPREVMTCwgQ08uIiwgInN0YXRpb25fc3RhdHVzIjogIkFjdGl2ZSIsICJzdGF0aW9uX3R5cGUiOiAiU3RyZWFtIiwgInVzZ3Nfc3RhdGlvbl9pZCI6ICIwNjcyNzAwMCIsICJ2YXJpYWJsZSI6ICJESVNDSFJHIiwgIndkIjogIjYifSwgInR5cGUiOiAiRmVhdHVyZSJ9LCB7ImJib3giOiBbLTEwNS4yMTAzOSwgNDAuMTkzNzU4LCAtMTA1LjIxMDM5LCA0MC4xOTM3NThdLCAiZ2VvbWV0cnkiOiB7ImNvb3JkaW5hdGVzIjogWy0xMDUuMjEwMzksIDQwLjE5Mzc1OF0sICJ0eXBlIjogIlBvaW50In0sICJpZCI6ICI0NSIsICJwcm9wZXJ0aWVzIjogeyJhbW91bnQiOiAiMC4wMCIsICJjb3VudHkiOiAiQk9VTERFUiIsICJkYXRhX3NvdXJjZSI6ICJDb29wZXJhdGl2ZSBQcm9ncmFtIG9mIENEV1IsIE5DV0NEIFx1MDAyNiBTVkxIV0NEIiwgImRhdGVfdGltZSI6ICIyMDIwLTAzLTI0VDA5OjAwOjAwLjAwMCIsICJkaXYiOiAiMSIsICJkd3JfYWJicmV2IjogIkNMT0RJVENPIiwgImZsYWciOiBudWxsLCAiaHR0cF9saW5rYWdlLnVybCI6ICJodHRwczovL2R3ci5zdGF0ZS5jby51cy9TdXJmYWNlV2F0ZXIvZGF0YS9kZXRhaWxfZ3JhcGguYXNweD9JRD1DTE9ESVRDT1x1MDAyNk1UWVBFPURJU0NIUkciLCAibG9jYXRpb24ubGF0aXR1ZGUiOiA0MC4xOTM3NTgsICJsb2NhdGlvbi5sb25naXR1ZGUiOiAtMTA1LjIxMDM5LCAibG9jYXRpb24ubmVlZHNfcmVjb2RpbmciOiBmYWxzZSwgInN0YWdlIjogbnVsbCwgInN0YXRpb25fbmFtZSI6ICJDTE9VR0ggQU5EIFRSVUUgRElUQ0giLCAic3RhdGlvbl9zdGF0dXMiOiAiQWN0aXZlIiwgInN0YXRpb25fdHlwZSI6ICJEaXZlcnNpb24iLCAidXNnc19zdGF0aW9uX2lkIjogbnVsbCwgInZhcmlhYmxlIjogIkRJU0NIUkciLCAid2QiOiAiNSJ9LCAidHlwZSI6ICJGZWF0dXJlIn0sIHsiYmJveCI6IFstMTA1LjMwODQzMiwgMzkuOTMxODEzLCAtMTA1LjMwODQzMiwgMzkuOTMxODEzXSwgImdlb21ldHJ5IjogeyJjb29yZGluYXRlcyI6IFstMTA1LjMwODQzMiwgMzkuOTMxODEzXSwgInR5cGUiOiAiUG9pbnQifSwgImlkIjogIjQ2IiwgInByb3BlcnRpZXMiOiB7ImFtb3VudCI6ICIwLjAwIiwgImNvdW50eSI6ICJCT1VMREVSIiwgImRhdGFfc291cmNlIjogIkNvLiBEaXZpc2lvbiBvZiBXYXRlciBSZXNvdXJjZXMiLCAiZGF0ZV90aW1lIjogIjIwMjAtMDMtMjRUMDg6MzA6MDAuMDAwIiwgImRpdiI6ICIxIiwgImR3cl9hYmJyZXYiOiAiQk9TREVMQ08iLCAiZmxhZyI6IG51bGwsICJodHRwX2xpbmthZ2UudXJsIjogImh0dHBzOi8vZHdyLnN0YXRlLmNvLnVzL1N1cmZhY2VXYXRlci9kYXRhL2RldGFpbF9ncmFwaC5hc3B4P0lEPUJPU0RFTENPXHUwMDI2TVRZUEU9RElTQ0hSRyIsICJsb2NhdGlvbi5sYXRpdHVkZSI6IDM5LjkzMTgxMywgImxvY2F0aW9uLmxvbmdpdHVkZSI6IC0xMDUuMzA4NDMyLCAibG9jYXRpb24ubmVlZHNfcmVjb2RpbmciOiBmYWxzZSwgInN0YWdlIjogIi0xLjcwIiwgInN0YXRpb25fbmFtZSI6ICJTT1VUSCBCT1VMREVSIENSRUVLIERJVkVSU0lPTiBORUFSIEVMRE9SQURPIFNQUklOR1MiLCAic3RhdGlvbl9zdGF0dXMiOiAiQWN0aXZlIiwgInN0YXRpb25fdHlwZSI6ICJEaXZlcnNpb24iLCAidXNnc19zdGF0aW9uX2lkIjogbnVsbCwgInZhcmlhYmxlIjogIkRJU0NIUkciLCAid2QiOiAiNiJ9LCAidHlwZSI6ICJGZWF0dXJlIn0sIHsiYmJveCI6IFstMTA1LjIwNjU5MiwgNDAuMTk2NDIyLCAtMTA1LjIwNjU5MiwgNDAuMTk2NDIyXSwgImdlb21ldHJ5IjogeyJjb29yZGluYXRlcyI6IFstMTA1LjIwNjU5MiwgNDAuMTk2NDIyXSwgInR5cGUiOiAiUG9pbnQifSwgImlkIjogIjQ3IiwgInByb3BlcnRpZXMiOiB7ImFtb3VudCI6ICIzLjc1IiwgImNvdW50eSI6ICJCT1VMREVSIiwgImRhdGFfc291cmNlIjogIkNvb3BlcmF0aXZlIFByb2dyYW0gb2YgQ0RXUiwgTkNXQ0QgXHUwMDI2IFNWTEhXQ0QiLCAiZGF0ZV90aW1lIjogIjIwMjAtMDMtMjRUMDc6NDU6MDAuMDAwIiwgImRpdiI6ICIxIiwgImR3cl9hYmJyZXYiOiAiT0xJRElUQ08iLCAiZmxhZyI6IG51bGwsICJodHRwX2xpbmthZ2UudXJsIjogImh0dHBzOi8vZHdyLnN0YXRlLmNvLnVzL1N1cmZhY2VXYXRlci9kYXRhL2RldGFpbF9ncmFwaC5hc3B4P0lEPU9MSURJVENPXHUwMDI2TVRZUEU9RElTQ0hSRyIsICJsb2NhdGlvbi5sYXRpdHVkZSI6IDQwLjE5NjQyMiwgImxvY2F0aW9uLmxvbmdpdHVkZSI6IC0xMDUuMjA2NTkyLCAibG9jYXRpb24ubmVlZHNfcmVjb2RpbmciOiBmYWxzZSwgInN0YWdlIjogIjAuMjMiLCAic3RhdGlvbl9uYW1lIjogIk9MSUdBUkNIWSBESVRDSCBESVZFUlNJT04iLCAic3RhdGlvbl9zdGF0dXMiOiAiQWN0aXZlIiwgInN0YXRpb25fdHlwZSI6ICJEaXZlcnNpb24iLCAidXNnc19zdGF0aW9uX2lkIjogbnVsbCwgInZhcmlhYmxlIjogIkRJU0NIUkciLCAid2QiOiAiNSJ9LCAidHlwZSI6ICJGZWF0dXJlIn0sIHsiYmJveCI6IFstMTA1LjI2MzQ5LCA0MC4yMjA3MDIsIC0xMDUuMjYzNDksIDQwLjIyMDcwMl0sICJnZW9tZXRyeSI6IHsiY29vcmRpbmF0ZXMiOiBbLTEwNS4yNjM0OSwgNDAuMjIwNzAyXSwgInR5cGUiOiAiUG9pbnQifSwgImlkIjogIjQ4IiwgInByb3BlcnRpZXMiOiB7ImFtb3VudCI6ICI0MC41MCIsICJjb3VudHkiOiAiQk9VTERFUiIsICJkYXRhX3NvdXJjZSI6ICJDby4gRGl2aXNpb24gb2YgV2F0ZXIgUmVzb3VyY2VzIiwgImRhdGVfdGltZSI6ICIyMDIwLTAzLTI0VDA5OjE1OjAwLjAwMCIsICJkaXYiOiAiMSIsICJkd3JfYWJicmV2IjogIlNWQ0xZT0NPIiwgImZsYWciOiBudWxsLCAiaHR0cF9saW5rYWdlLnVybCI6ICJodHRwczovL2R3ci5zdGF0ZS5jby51cy9TdXJmYWNlV2F0ZXIvZGF0YS9kZXRhaWxfZ3JhcGguYXNweD9JRD1TVkNMWU9DT1x1MDAyNk1UWVBFPURJU0NIUkciLCAibG9jYXRpb24ubGF0aXR1ZGUiOiA0MC4yMjA3MDIsICJsb2NhdGlvbi5sb25naXR1ZGUiOiAtMTA1LjI2MzQ5LCAibG9jYXRpb24ubmVlZHNfcmVjb2RpbmciOiBmYWxzZSwgInN0YWdlIjogIjIuOTgiLCAic3RhdGlvbl9uYW1lIjogIlNBSU5UIFZSQUlOIENSRUVLIEFUIExZT05TLCBDTyIsICJzdGF0aW9uX3N0YXR1cyI6ICJBY3RpdmUiLCAic3RhdGlvbl90eXBlIjogIlN0cmVhbSIsICJ1c2dzX3N0YXRpb25faWQiOiAiMDY3MjQwMDAiLCAidmFyaWFibGUiOiAiRElTQ0hSRyIsICJ3ZCI6ICI1In0sICJ0eXBlIjogIkZlYXR1cmUifSwgeyJiYm94IjogWy0xMDUuMTg1Nzg5LCA0MC4xODUwMzMsIC0xMDUuMTg1Nzg5LCA0MC4xODUwMzNdLCAiZ2VvbWV0cnkiOiB7ImNvb3JkaW5hdGVzIjogWy0xMDUuMTg1Nzg5LCA0MC4xODUwMzNdLCAidHlwZSI6ICJQb2ludCJ9LCAiaWQiOiAiNDkiLCAicHJvcGVydGllcyI6IHsiYW1vdW50IjogIjAuMTQiLCAiY291bnR5IjogIkJPVUxERVIiLCAiZGF0YV9zb3VyY2UiOiAiQ29vcGVyYXRpdmUgUHJvZ3JhbSBvZiBDRFdSLCBOQ1dDRCBcdTAwMjYgU1ZMSFdDRCIsICJkYXRlX3RpbWUiOiAiMjAyMC0wMy0yNFQwOTowMDowMC4wMDAiLCAiZGl2IjogIjEiLCAiZHdyX2FiYnJldiI6ICJaV0VUVVJDTyIsICJmbGFnIjogbnVsbCwgImh0dHBfbGlua2FnZS51cmwiOiAiaHR0cHM6Ly9kd3Iuc3RhdGUuY28udXMvU3VyZmFjZVdhdGVyL2RhdGEvZGV0YWlsX2dyYXBoLmFzcHg/SUQ9WldFVFVSQ09cdTAwMjZNVFlQRT1ESVNDSFJHIiwgImxvY2F0aW9uLmxhdGl0dWRlIjogNDAuMTg1MDMzLCAibG9jYXRpb24ubG9uZ2l0dWRlIjogLTEwNS4xODU3ODksICJsb2NhdGlvbi5uZWVkc19yZWNvZGluZyI6IGZhbHNlLCAic3RhZ2UiOiAiMC4wNSIsICJzdGF0aW9uX25hbWUiOiAiWldFQ0sgQU5EIFRVUk5FUiBESVRDSCIsICJzdGF0aW9uX3N0YXR1cyI6ICJBY3RpdmUiLCAic3RhdGlvbl90eXBlIjogIkRpdmVyc2lvbiIsICJ1c2dzX3N0YXRpb25faWQiOiBudWxsLCAidmFyaWFibGUiOiAiRElTQ0hSRyIsICJ3ZCI6ICI1In0sICJ0eXBlIjogIkZlYXR1cmUifV0sICJ0eXBlIjogIkZlYXR1cmVDb2xsZWN0aW9uIn0pOwogICAgICAgIAo8L3NjcmlwdD4=" style="position:absolute;width:100%;height:100%;left:0;top:0;border:none !important;" allowfullscreen webkitallowfullscreen mozallowfullscreen></iframe></div></div>





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



<div style="width:100%;"><div style="position:relative;width:100%;height:0;padding-bottom:60%;"><iframe src="data:text/html;charset=utf-8;base64,PCFET0NUWVBFIGh0bWw+CjxoZWFkPiAgICAKICAgIDxtZXRhIGh0dHAtZXF1aXY9ImNvbnRlbnQtdHlwZSIgY29udGVudD0idGV4dC9odG1sOyBjaGFyc2V0PVVURi04IiAvPgogICAgCiAgICAgICAgPHNjcmlwdD4KICAgICAgICAgICAgTF9OT19UT1VDSCA9IGZhbHNlOwogICAgICAgICAgICBMX0RJU0FCTEVfM0QgPSBmYWxzZTsKICAgICAgICA8L3NjcmlwdD4KICAgIAogICAgPHNjcmlwdCBzcmM9Imh0dHBzOi8vY2RuLmpzZGVsaXZyLm5ldC9ucG0vbGVhZmxldEAxLjUuMS9kaXN0L2xlYWZsZXQuanMiPjwvc2NyaXB0PgogICAgPHNjcmlwdCBzcmM9Imh0dHBzOi8vY29kZS5qcXVlcnkuY29tL2pxdWVyeS0xLjEyLjQubWluLmpzIj48L3NjcmlwdD4KICAgIDxzY3JpcHQgc3JjPSJodHRwczovL21heGNkbi5ib290c3RyYXBjZG4uY29tL2Jvb3RzdHJhcC8zLjIuMC9qcy9ib290c3RyYXAubWluLmpzIj48L3NjcmlwdD4KICAgIDxzY3JpcHQgc3JjPSJodHRwczovL2NkbmpzLmNsb3VkZmxhcmUuY29tL2FqYXgvbGlicy9MZWFmbGV0LmF3ZXNvbWUtbWFya2Vycy8yLjAuMi9sZWFmbGV0LmF3ZXNvbWUtbWFya2Vycy5qcyI+PC9zY3JpcHQ+CiAgICA8bGluayByZWw9InN0eWxlc2hlZXQiIGhyZWY9Imh0dHBzOi8vY2RuLmpzZGVsaXZyLm5ldC9ucG0vbGVhZmxldEAxLjUuMS9kaXN0L2xlYWZsZXQuY3NzIi8+CiAgICA8bGluayByZWw9InN0eWxlc2hlZXQiIGhyZWY9Imh0dHBzOi8vbWF4Y2RuLmJvb3RzdHJhcGNkbi5jb20vYm9vdHN0cmFwLzMuMi4wL2Nzcy9ib290c3RyYXAubWluLmNzcyIvPgogICAgPGxpbmsgcmVsPSJzdHlsZXNoZWV0IiBocmVmPSJodHRwczovL21heGNkbi5ib290c3RyYXBjZG4uY29tL2Jvb3RzdHJhcC8zLjIuMC9jc3MvYm9vdHN0cmFwLXRoZW1lLm1pbi5jc3MiLz4KICAgIDxsaW5rIHJlbD0ic3R5bGVzaGVldCIgaHJlZj0iaHR0cHM6Ly9tYXhjZG4uYm9vdHN0cmFwY2RuLmNvbS9mb250LWF3ZXNvbWUvNC42LjMvY3NzL2ZvbnQtYXdlc29tZS5taW4uY3NzIi8+CiAgICA8bGluayByZWw9InN0eWxlc2hlZXQiIGhyZWY9Imh0dHBzOi8vY2RuanMuY2xvdWRmbGFyZS5jb20vYWpheC9saWJzL0xlYWZsZXQuYXdlc29tZS1tYXJrZXJzLzIuMC4yL2xlYWZsZXQuYXdlc29tZS1tYXJrZXJzLmNzcyIvPgogICAgPGxpbmsgcmVsPSJzdHlsZXNoZWV0IiBocmVmPSJodHRwczovL3Jhd2Nkbi5naXRoYWNrLmNvbS9weXRob24tdmlzdWFsaXphdGlvbi9mb2xpdW0vbWFzdGVyL2ZvbGl1bS90ZW1wbGF0ZXMvbGVhZmxldC5hd2Vzb21lLnJvdGF0ZS5jc3MiLz4KICAgIDxzdHlsZT5odG1sLCBib2R5IHt3aWR0aDogMTAwJTtoZWlnaHQ6IDEwMCU7bWFyZ2luOiAwO3BhZGRpbmc6IDA7fTwvc3R5bGU+CiAgICA8c3R5bGU+I21hcCB7cG9zaXRpb246YWJzb2x1dGU7dG9wOjA7Ym90dG9tOjA7cmlnaHQ6MDtsZWZ0OjA7fTwvc3R5bGU+CiAgICAKICAgICAgICAgICAgPG1ldGEgbmFtZT0idmlld3BvcnQiIGNvbnRlbnQ9IndpZHRoPWRldmljZS13aWR0aCwKICAgICAgICAgICAgICAgIGluaXRpYWwtc2NhbGU9MS4wLCBtYXhpbXVtLXNjYWxlPTEuMCwgdXNlci1zY2FsYWJsZT1ubyIgLz4KICAgICAgICAgICAgPHN0eWxlPgogICAgICAgICAgICAgICAgI21hcF8wMDRiOTlkOTFiYzk0M2QyOTBiYTE0N2UyNzYyMDBlMyB7CiAgICAgICAgICAgICAgICAgICAgcG9zaXRpb246IHJlbGF0aXZlOwogICAgICAgICAgICAgICAgICAgIHdpZHRoOiAxMDAuMCU7CiAgICAgICAgICAgICAgICAgICAgaGVpZ2h0OiAxMDAuMCU7CiAgICAgICAgICAgICAgICAgICAgbGVmdDogMC4wJTsKICAgICAgICAgICAgICAgICAgICB0b3A6IDAuMCU7CiAgICAgICAgICAgICAgICB9CiAgICAgICAgICAgIDwvc3R5bGU+CiAgICAgICAgCiAgICA8c2NyaXB0IHNyYz0iaHR0cHM6Ly9jZG5qcy5jbG91ZGZsYXJlLmNvbS9hamF4L2xpYnMvbGVhZmxldC5tYXJrZXJjbHVzdGVyLzEuMS4wL2xlYWZsZXQubWFya2VyY2x1c3Rlci5qcyI+PC9zY3JpcHQ+CiAgICA8bGluayByZWw9InN0eWxlc2hlZXQiIGhyZWY9Imh0dHBzOi8vY2RuanMuY2xvdWRmbGFyZS5jb20vYWpheC9saWJzL2xlYWZsZXQubWFya2VyY2x1c3Rlci8xLjEuMC9NYXJrZXJDbHVzdGVyLmNzcyIvPgogICAgPGxpbmsgcmVsPSJzdHlsZXNoZWV0IiBocmVmPSJodHRwczovL2NkbmpzLmNsb3VkZmxhcmUuY29tL2FqYXgvbGlicy9sZWFmbGV0Lm1hcmtlcmNsdXN0ZXIvMS4xLjAvTWFya2VyQ2x1c3Rlci5EZWZhdWx0LmNzcyIvPgo8L2hlYWQ+Cjxib2R5PiAgICAKICAgIAogICAgICAgICAgICA8ZGl2IGNsYXNzPSJmb2xpdW0tbWFwIiBpZD0ibWFwXzAwNGI5OWQ5MWJjOTQzZDI5MGJhMTQ3ZTI3NjIwMGUzIiA+PC9kaXY+CiAgICAgICAgCjwvYm9keT4KPHNjcmlwdD4gICAgCiAgICAKICAgICAgICAgICAgdmFyIG1hcF8wMDRiOTlkOTFiYzk0M2QyOTBiYTE0N2UyNzYyMDBlMyA9IEwubWFwKAogICAgICAgICAgICAgICAgIm1hcF8wMDRiOTlkOTFiYzk0M2QyOTBiYTE0N2UyNzYyMDBlMyIsCiAgICAgICAgICAgICAgICB7CiAgICAgICAgICAgICAgICAgICAgY2VudGVyOiBbNDAuMDEsIC0xMDUuMjddLAogICAgICAgICAgICAgICAgICAgIGNyczogTC5DUlMuRVBTRzM4NTcsCiAgICAgICAgICAgICAgICAgICAgem9vbTogMTAsCiAgICAgICAgICAgICAgICAgICAgem9vbUNvbnRyb2w6IHRydWUsCiAgICAgICAgICAgICAgICAgICAgcHJlZmVyQ2FudmFzOiBmYWxzZSwKICAgICAgICAgICAgICAgIH0KICAgICAgICAgICAgKTsKCiAgICAgICAgICAgIAoKICAgICAgICAKICAgIAogICAgICAgICAgICB2YXIgdGlsZV9sYXllcl85NDc2NmYxMGRjZjQ0YmViYmQwNjM2NTYxMTQxNjI1NyA9IEwudGlsZUxheWVyKAogICAgICAgICAgICAgICAgImh0dHBzOi8vY2FydG9kYi1iYXNlbWFwcy17c30uZ2xvYmFsLnNzbC5mYXN0bHkubmV0L2xpZ2h0X2FsbC97en0ve3h9L3t5fS5wbmciLAogICAgICAgICAgICAgICAgeyJhdHRyaWJ1dGlvbiI6ICJcdTAwMjZjb3B5OyBcdTAwM2NhIGhyZWY9XCJodHRwOi8vd3d3Lm9wZW5zdHJlZXRtYXAub3JnL2NvcHlyaWdodFwiXHUwMDNlT3BlblN0cmVldE1hcFx1MDAzYy9hXHUwMDNlIGNvbnRyaWJ1dG9ycyBcdTAwMjZjb3B5OyBcdTAwM2NhIGhyZWY9XCJodHRwOi8vY2FydG9kYi5jb20vYXR0cmlidXRpb25zXCJcdTAwM2VDYXJ0b0RCXHUwMDNjL2FcdTAwM2UsIENhcnRvREIgXHUwMDNjYSBocmVmID1cImh0dHA6Ly9jYXJ0b2RiLmNvbS9hdHRyaWJ1dGlvbnNcIlx1MDAzZWF0dHJpYnV0aW9uc1x1MDAzYy9hXHUwMDNlIiwgImRldGVjdFJldGluYSI6IGZhbHNlLCAibWF4TmF0aXZlWm9vbSI6IDE4LCAibWF4Wm9vbSI6IDE4LCAibWluWm9vbSI6IDAsICJub1dyYXAiOiBmYWxzZSwgIm9wYWNpdHkiOiAxLCAic3ViZG9tYWlucyI6ICJhYmMiLCAidG1zIjogZmFsc2V9CiAgICAgICAgICAgICkuYWRkVG8obWFwXzAwNGI5OWQ5MWJjOTQzZDI5MGJhMTQ3ZTI3NjIwMGUzKTsKICAgICAgICAKICAgIAogICAgICAgICAgICB2YXIgbWFya2VyX2NsdXN0ZXJfZmU0ZTFhZDc4OWU3NDZmMjk5OWRjMzQ4ZDZlNjQwMDMgPSBMLm1hcmtlckNsdXN0ZXJHcm91cCgKICAgICAgICAgICAgICAgIHt9CiAgICAgICAgICAgICk7CiAgICAgICAgICAgIG1hcF8wMDRiOTlkOTFiYzk0M2QyOTBiYTE0N2UyNzYyMDBlMy5hZGRMYXllcihtYXJrZXJfY2x1c3Rlcl9mZTRlMWFkNzg5ZTc0NmYyOTk5ZGMzNDhkNmU2NDAwMyk7CiAgICAgICAgCiAgICAKICAgICAgICAgICAgdmFyIG1hcmtlcl85OWE5ZGMyYzdkYzA0ZDMxYjI1OGU3ZDdlOGZiNDBhYiA9IEwubWFya2VyKAogICAgICAgICAgICAgICAgWzM5Ljk0NzcwNCwgLTEwNS4zNTczMDhdLAogICAgICAgICAgICAgICAge30KICAgICAgICAgICAgKS5hZGRUbyhtYXJrZXJfY2x1c3Rlcl9mZTRlMWFkNzg5ZTc0NmYyOTk5ZGMzNDhkNmU2NDAwMyk7CiAgICAgICAgCiAgICAKICAgICAgICB2YXIgcG9wdXBfMzdjM2ZhMWNjNjMxNGM4YTkyZTJhODM3OTBlMTI3NDUgPSBMLnBvcHVwKHsibWF4V2lkdGgiOiAiMTAwJSJ9KTsKCiAgICAgICAgCiAgICAgICAgICAgIHZhciBodG1sX2RlYmJlZWZjNGZhMDRmZWFhNDI2NTE4MjQ4OWE5MmQ2ID0gJChgPGRpdiBpZD0iaHRtbF9kZWJiZWVmYzRmYTA0ZmVhYTQyNjUxODI0ODlhOTJkNiIgc3R5bGU9IndpZHRoOiAxMDAuMCU7IGhlaWdodDogMTAwLjAlOyI+TmFtZTogR1JPU1MgUkVTRVJWT0lSICBQcmVjaXA6IDExMzY4LjAwPC9kaXY+YClbMF07CiAgICAgICAgICAgIHBvcHVwXzM3YzNmYTFjYzYzMTRjOGE5MmUyYTgzNzkwZTEyNzQ1LnNldENvbnRlbnQoaHRtbF9kZWJiZWVmYzRmYTA0ZmVhYTQyNjUxODI0ODlhOTJkNik7CiAgICAgICAgCgogICAgICAgIG1hcmtlcl85OWE5ZGMyYzdkYzA0ZDMxYjI1OGU3ZDdlOGZiNDBhYi5iaW5kUG9wdXAocG9wdXBfMzdjM2ZhMWNjNjMxNGM4YTkyZTJhODM3OTBlMTI3NDUpCiAgICAgICAgOwoKICAgICAgICAKICAgIAogICAgCiAgICAgICAgICAgIHZhciBtYXJrZXJfYmZhY2IyN2VkMGQ1NGU1MzgxOTdmNGI0Y2UxODNmYjAgPSBMLm1hcmtlcigKICAgICAgICAgICAgICAgIFs0MC4xNzcwOCwgLTEwNS4xNzg1NjddLAogICAgICAgICAgICAgICAge30KICAgICAgICAgICAgKS5hZGRUbyhtYXJrZXJfY2x1c3Rlcl9mZTRlMWFkNzg5ZTc0NmYyOTk5ZGMzNDhkNmU2NDAwMyk7CiAgICAgICAgCiAgICAKICAgICAgICB2YXIgcG9wdXBfZWE1MGNhNGJiZTI3NDdlNjhmOTdiNjVmNDI5Y2QxZmUgPSBMLnBvcHVwKHsibWF4V2lkdGgiOiAiMTAwJSJ9KTsKCiAgICAgICAgCiAgICAgICAgICAgIHZhciBodG1sX2MzODNmNjRlODY3NjRmZjI5OGIyYTg0ZWMxOGJkMzY2ID0gJChgPGRpdiBpZD0iaHRtbF9jMzgzZjY0ZTg2NzY0ZmYyOThiMmE4NGVjMThiZDM2NiIgc3R5bGU9IndpZHRoOiAxMDAuMCU7IGhlaWdodDogMTAwLjAlOyI+TmFtZTogUEVDSyBQRUxMQSBDTE9WRVIgRElUQ0ggUHJlY2lwOiAxLjQyPC9kaXY+YClbMF07CiAgICAgICAgICAgIHBvcHVwX2VhNTBjYTRiYmUyNzQ3ZTY4Zjk3YjY1ZjQyOWNkMWZlLnNldENvbnRlbnQoaHRtbF9jMzgzZjY0ZTg2NzY0ZmYyOThiMmE4NGVjMThiZDM2Nik7CiAgICAgICAgCgogICAgICAgIG1hcmtlcl9iZmFjYjI3ZWQwZDU0ZTUzODE5N2Y0YjRjZTE4M2ZiMC5iaW5kUG9wdXAocG9wdXBfZWE1MGNhNGJiZTI3NDdlNjhmOTdiNjVmNDI5Y2QxZmUpCiAgICAgICAgOwoKICAgICAgICAKICAgIAogICAgCiAgICAgICAgICAgIHZhciBtYXJrZXJfNGQyMTA4NTY4ODk0NDRkY2FhNmE5NmE1ZWJlNzQ4MjEgPSBMLm1hcmtlcigKICAgICAgICAgICAgICAgIFs0MC4wNDIwMjgsIC0xMDUuMzY0OTE3XSwKICAgICAgICAgICAgICAgIHt9CiAgICAgICAgICAgICkuYWRkVG8obWFya2VyX2NsdXN0ZXJfZmU0ZTFhZDc4OWU3NDZmMjk5OWRjMzQ4ZDZlNjQwMDMpOwogICAgICAgIAogICAgCiAgICAgICAgdmFyIHBvcHVwX2JjMGE1MGMxZTJmZTRkNGY4ZmUwYzAxMjYxYmVhOWI5ID0gTC5wb3B1cCh7Im1heFdpZHRoIjogIjEwMCUifSk7CgogICAgICAgIAogICAgICAgICAgICB2YXIgaHRtbF8xZWYzNTdlYzg0NDU0ZjIxYTcwZTUxMzgyYmQyYjUwYSA9ICQoYDxkaXYgaWQ9Imh0bWxfMWVmMzU3ZWM4NDQ1NGYyMWE3MGU1MTM4MmJkMmI1MGEiIHN0eWxlPSJ3aWR0aDogMTAwLjAlOyBoZWlnaHQ6IDEwMC4wJTsiPk5hbWU6IEZPVVJNSUxFIENSRUVLIEFUIExPR0FOIE1JTEwgUk9BRCBORUFSIENSSVNNQU4sIENPIFByZWNpcDogbmFuPC9kaXY+YClbMF07CiAgICAgICAgICAgIHBvcHVwX2JjMGE1MGMxZTJmZTRkNGY4ZmUwYzAxMjYxYmVhOWI5LnNldENvbnRlbnQoaHRtbF8xZWYzNTdlYzg0NDU0ZjIxYTcwZTUxMzgyYmQyYjUwYSk7CiAgICAgICAgCgogICAgICAgIG1hcmtlcl80ZDIxMDg1Njg4OTQ0NGRjYWE2YTk2YTVlYmU3NDgyMS5iaW5kUG9wdXAocG9wdXBfYmMwYTUwYzFlMmZlNGQ0ZjhmZTBjMDEyNjFiZWE5YjkpCiAgICAgICAgOwoKICAgICAgICAKICAgIAogICAgCiAgICAgICAgICAgIHZhciBtYXJrZXJfYzcwZTU4MTMzYjk2NGE0Yzg2NjQ3MzVjMzI2OWJiMDkgPSBMLm1hcmtlcigKICAgICAgICAgICAgICAgIFs0MC4xODc1NzgsIC0xMDUuMTg5MTkxXSwKICAgICAgICAgICAgICAgIHt9CiAgICAgICAgICAgICkuYWRkVG8obWFya2VyX2NsdXN0ZXJfZmU0ZTFhZDc4OWU3NDZmMjk5OWRjMzQ4ZDZlNjQwMDMpOwogICAgICAgIAogICAgCiAgICAgICAgdmFyIHBvcHVwXzY3NzRlMjA0NDk4MjQ1MDQ4OTVmNjZhMGZiOTJlMWQzID0gTC5wb3B1cCh7Im1heFdpZHRoIjogIjEwMCUifSk7CgogICAgICAgIAogICAgICAgICAgICB2YXIgaHRtbF85ODZlMmUzZmRmZTI0YWQyYjNhNjQ1NjY2YzYzNDVmYSA9ICQoYDxkaXYgaWQ9Imh0bWxfOTg2ZTJlM2ZkZmUyNGFkMmIzYTY0NTY2NmM2MzQ1ZmEiIHN0eWxlPSJ3aWR0aDogMTAwLjAlOyBoZWlnaHQ6IDEwMC4wJTsiPk5hbWU6IERFTklPIFRBWUxPUiBESVRDSCBQcmVjaXA6IDI4MTkuNjg8L2Rpdj5gKVswXTsKICAgICAgICAgICAgcG9wdXBfNjc3NGUyMDQ0OTgyNDUwNDg5NWY2NmEwZmI5MmUxZDMuc2V0Q29udGVudChodG1sXzk4NmUyZTNmZGZlMjRhZDJiM2E2NDU2NjZjNjM0NWZhKTsKICAgICAgICAKCiAgICAgICAgbWFya2VyX2M3MGU1ODEzM2I5NjRhNGM4NjY0NzM1YzMyNjliYjA5LmJpbmRQb3B1cChwb3B1cF82Nzc0ZTIwNDQ5ODI0NTA0ODk1ZjY2YTBmYjkyZTFkMykKICAgICAgICA7CgogICAgICAgIAogICAgCiAgICAKICAgICAgICAgICAgdmFyIG1hcmtlcl83YjhlM2IxNjgwN2Y0ZmZlOGQ3NmZkMTM1OGI5MDAyYyA9IEwubWFya2VyKAogICAgICAgICAgICAgICAgWzQwLjIxOTA0NiwgLTEwNS4yNTk3OTVdLAogICAgICAgICAgICAgICAge30KICAgICAgICAgICAgKS5hZGRUbyhtYXJrZXJfY2x1c3Rlcl9mZTRlMWFkNzg5ZTc0NmYyOTk5ZGMzNDhkNmU2NDAwMyk7CiAgICAgICAgCiAgICAKICAgICAgICB2YXIgcG9wdXBfODlmNjQwODY4N2I0NGJiNGIxYmQzYWM0YzQ2ZmU4YjEgPSBMLnBvcHVwKHsibWF4V2lkdGgiOiAiMTAwJSJ9KTsKCiAgICAgICAgCiAgICAgICAgICAgIHZhciBodG1sXzQ2NmVmNmVlN2I1NzQyNTA5NGMxMWVjYTU3YTA0YmM4ID0gJChgPGRpdiBpZD0iaHRtbF80NjZlZjZlZTdiNTc0MjUwOTRjMTFlY2E1N2EwNGJjOCIgc3R5bGU9IndpZHRoOiAxMDAuMCU7IGhlaWdodDogMTAwLjAlOyI+TmFtZTogU1VQUExZIERJVENIIFByZWNpcDogMC4wMDwvZGl2PmApWzBdOwogICAgICAgICAgICBwb3B1cF84OWY2NDA4Njg3YjQ0YmI0YjFiZDNhYzRjNDZmZThiMS5zZXRDb250ZW50KGh0bWxfNDY2ZWY2ZWU3YjU3NDI1MDk0YzExZWNhNTdhMDRiYzgpOwogICAgICAgIAoKICAgICAgICBtYXJrZXJfN2I4ZTNiMTY4MDdmNGZmZThkNzZmZDEzNThiOTAwMmMuYmluZFBvcHVwKHBvcHVwXzg5ZjY0MDg2ODdiNDRiYjRiMWJkM2FjNGM0NmZlOGIxKQogICAgICAgIDsKCiAgICAgICAgCiAgICAKICAgIAogICAgICAgICAgICB2YXIgbWFya2VyXzE5YzFkZmNlZTE2NjQxZWViZDFmOTdhYWYzOTk5NzgwID0gTC5tYXJrZXIoCiAgICAgICAgICAgICAgICBbNDAuMjEyNTA1LCAtMTA1LjI1MTgyNl0sCiAgICAgICAgICAgICAgICB7fQogICAgICAgICAgICApLmFkZFRvKG1hcmtlcl9jbHVzdGVyX2ZlNGUxYWQ3ODllNzQ2ZjI5OTlkYzM0OGQ2ZTY0MDAzKTsKICAgICAgICAKICAgIAogICAgICAgIHZhciBwb3B1cF8yMjI1NDIxZTc4MWY0OWEyOWZmNmZmYzg2MzI1NTkwOCA9IEwucG9wdXAoeyJtYXhXaWR0aCI6ICIxMDAlIn0pOwoKICAgICAgICAKICAgICAgICAgICAgdmFyIGh0bWxfZGQ3ZTVkYWMyNGFiNGNjY2E0YTU1ZGY1NDllNjBjYjEgPSAkKGA8ZGl2IGlkPSJodG1sX2RkN2U1ZGFjMjRhYjRjY2NhNGE1NWRmNTQ5ZTYwY2IxIiBzdHlsZT0id2lkdGg6IDEwMC4wJTsgaGVpZ2h0OiAxMDAuMCU7Ij5OYW1lOiBQQUxNRVJUT04gRElUQ0ggUHJlY2lwOiAwLjI3PC9kaXY+YClbMF07CiAgICAgICAgICAgIHBvcHVwXzIyMjU0MjFlNzgxZjQ5YTI5ZmY2ZmZjODYzMjU1OTA4LnNldENvbnRlbnQoaHRtbF9kZDdlNWRhYzI0YWI0Y2NjYTRhNTVkZjU0OWU2MGNiMSk7CiAgICAgICAgCgogICAgICAgIG1hcmtlcl8xOWMxZGZjZWUxNjY0MWVlYmQxZjk3YWFmMzk5OTc4MC5iaW5kUG9wdXAocG9wdXBfMjIyNTQyMWU3ODFmNDlhMjlmZjZmZmM4NjMyNTU5MDgpCiAgICAgICAgOwoKICAgICAgICAKICAgIAogICAgCiAgICAgICAgICAgIHZhciBtYXJrZXJfNTQ3YmFjZTk0Y2NmNDE1MGEzM2E3OTk3ZDgyNTFmMjUgPSBMLm1hcmtlcigKICAgICAgICAgICAgICAgIFszOS45MzgzNTEsIC0xMDUuMzQ3OTA2XSwKICAgICAgICAgICAgICAgIHt9CiAgICAgICAgICAgICkuYWRkVG8obWFya2VyX2NsdXN0ZXJfZmU0ZTFhZDc4OWU3NDZmMjk5OWRjMzQ4ZDZlNjQwMDMpOwogICAgICAgIAogICAgCiAgICAgICAgdmFyIHBvcHVwXzkyNzY5ZjkxM2M5ODQwZThiYzA3OWFiN2I5OGQxMmUwID0gTC5wb3B1cCh7Im1heFdpZHRoIjogIjEwMCUifSk7CgogICAgICAgIAogICAgICAgICAgICB2YXIgaHRtbF80Y2M5M2NmZWUzZWQ0MzM1YTI1M2EyODE1MDk5ZTQ3ZiA9ICQoYDxkaXYgaWQ9Imh0bWxfNGNjOTNjZmVlM2VkNDMzNWEyNTNhMjgxNTA5OWU0N2YiIHN0eWxlPSJ3aWR0aDogMTAwLjAlOyBoZWlnaHQ6IDEwMC4wJTsiPk5hbWU6IFNPVVRIIEJPVUxERVIgQ1JFRUsgQkVMT1cgR1JPU1MgUkVTRVJWT0lSIFByZWNpcDogMTYuNDA8L2Rpdj5gKVswXTsKICAgICAgICAgICAgcG9wdXBfOTI3NjlmOTEzYzk4NDBlOGJjMDc5YWI3Yjk4ZDEyZTAuc2V0Q29udGVudChodG1sXzRjYzkzY2ZlZTNlZDQzMzVhMjUzYTI4MTUwOTllNDdmKTsKICAgICAgICAKCiAgICAgICAgbWFya2VyXzU0N2JhY2U5NGNjZjQxNTBhMzNhNzk5N2Q4MjUxZjI1LmJpbmRQb3B1cChwb3B1cF85Mjc2OWY5MTNjOTg0MGU4YmMwNzlhYjdiOThkMTJlMCkKICAgICAgICA7CgogICAgICAgIAogICAgCiAgICAKICAgICAgICAgICAgdmFyIG1hcmtlcl9iY2FmN2FiYzNiOWY0MWRkYjkzMzI4Njg1MGUwNDhmZSA9IEwubWFya2VyKAogICAgICAgICAgICAgICAgWzQwLjI1ODM2NywgLTEwNS4xNzQ5NTddLAogICAgICAgICAgICAgICAge30KICAgICAgICAgICAgKS5hZGRUbyhtYXJrZXJfY2x1c3Rlcl9mZTRlMWFkNzg5ZTc0NmYyOTk5ZGMzNDhkNmU2NDAwMyk7CiAgICAgICAgCiAgICAKICAgICAgICB2YXIgcG9wdXBfYTBkMTgxNTk4NGRhNDg2MjlmYzZjN2EzNWJjNTcwYmMgPSBMLnBvcHVwKHsibWF4V2lkdGgiOiAiMTAwJSJ9KTsKCiAgICAgICAgCiAgICAgICAgICAgIHZhciBodG1sXzRhNmI4MjkwMjQzZTRhY2VhOTBlOWY3ZjhhNjMyOGQ2ID0gJChgPGRpdiBpZD0iaHRtbF80YTZiODI5MDI0M2U0YWNlYTkwZTlmN2Y4YTYzMjhkNiIgc3R5bGU9IndpZHRoOiAxMDAuMCU7IGhlaWdodDogMTAwLjAlOyI+TmFtZTogQk9VTERFUi1MQVJJTUVSIERJVENIIE5FQVIgQkVSVEhPVUQgUHJlY2lwOiAwLjAwPC9kaXY+YClbMF07CiAgICAgICAgICAgIHBvcHVwX2EwZDE4MTU5ODRkYTQ4NjI5ZmM2YzdhMzViYzU3MGJjLnNldENvbnRlbnQoaHRtbF80YTZiODI5MDI0M2U0YWNlYTkwZTlmN2Y4YTYzMjhkNik7CiAgICAgICAgCgogICAgICAgIG1hcmtlcl9iY2FmN2FiYzNiOWY0MWRkYjkzMzI4Njg1MGUwNDhmZS5iaW5kUG9wdXAocG9wdXBfYTBkMTgxNTk4NGRhNDg2MjlmYzZjN2EzNWJjNTcwYmMpCiAgICAgICAgOwoKICAgICAgICAKICAgIAogICAgCiAgICAgICAgICAgIHZhciBtYXJrZXJfYjZjOTg2MTIyNGU2NDk1M2JmNWRlZThkY2Y4YzY0ZTMgPSBMLm1hcmtlcigKICAgICAgICAgICAgICAgIFs0MC4wNTMwMzUsIC0xMDUuMTkzMDQ4XSwKICAgICAgICAgICAgICAgIHt9CiAgICAgICAgICAgICkuYWRkVG8obWFya2VyX2NsdXN0ZXJfZmU0ZTFhZDc4OWU3NDZmMjk5OWRjMzQ4ZDZlNjQwMDMpOwogICAgICAgIAogICAgCiAgICAgICAgdmFyIHBvcHVwX2JjYzdjYmU1NWU4MjQ0N2JhZTk5ZDgzZjIzYWMzMGQ0ID0gTC5wb3B1cCh7Im1heFdpZHRoIjogIjEwMCUifSk7CgogICAgICAgIAogICAgICAgICAgICB2YXIgaHRtbF84OWYyZmJjZWU4OTY0YThjYTQ4NDQzZDFmYjAxNWZlMSA9ICQoYDxkaXYgaWQ9Imh0bWxfODlmMmZiY2VlODk2NGE4Y2E0ODQ0M2QxZmIwMTVmZTEiIHN0eWxlPSJ3aWR0aDogMTAwLjAlOyBoZWlnaHQ6IDEwMC4wJTsiPk5hbWU6IEJPVUxERVIgQ1JFRUsgU1VQUExZIENBTkFMIFRPIEJPVUxERVIgQ1JFRUsgTkVBUiBCT1VMREVSIFByZWNpcDogMC4wMDwvZGl2PmApWzBdOwogICAgICAgICAgICBwb3B1cF9iY2M3Y2JlNTVlODI0NDdiYWU5OWQ4M2YyM2FjMzBkNC5zZXRDb250ZW50KGh0bWxfODlmMmZiY2VlODk2NGE4Y2E0ODQ0M2QxZmIwMTVmZTEpOwogICAgICAgIAoKICAgICAgICBtYXJrZXJfYjZjOTg2MTIyNGU2NDk1M2JmNWRlZThkY2Y4YzY0ZTMuYmluZFBvcHVwKHBvcHVwX2JjYzdjYmU1NWU4MjQ0N2JhZTk5ZDgzZjIzYWMzMGQ0KQogICAgICAgIDsKCiAgICAgICAgCiAgICAKICAgIAogICAgICAgICAgICB2YXIgbWFya2VyXzcxYjI1OWZiMzRiZDQ1NTg5ZjE3MWU2ZTAwNmM2NGI1ID0gTC5tYXJrZXIoCiAgICAgICAgICAgICAgICBbNDAuMTg4NTc5LCAtMTA1LjIwOTI4Ml0sCiAgICAgICAgICAgICAgICB7fQogICAgICAgICAgICApLmFkZFRvKG1hcmtlcl9jbHVzdGVyX2ZlNGUxYWQ3ODllNzQ2ZjI5OTlkYzM0OGQ2ZTY0MDAzKTsKICAgICAgICAKICAgIAogICAgICAgIHZhciBwb3B1cF8wNThlOTlmYmM3M2E0YzdkOWZjNDZiODkyZWViMTRhMSA9IEwucG9wdXAoeyJtYXhXaWR0aCI6ICIxMDAlIn0pOwoKICAgICAgICAKICAgICAgICAgICAgdmFyIGh0bWxfYTY2ODQxNGZjMTE2NDQzOWE5NjQ3OTFkNjU2MTc0MDEgPSAkKGA8ZGl2IGlkPSJodG1sX2E2Njg0MTRmYzExNjQ0MzlhOTY0NzkxZDY1NjE3NDAxIiBzdHlsZT0id2lkdGg6IDEwMC4wJTsgaGVpZ2h0OiAxMDAuMCU7Ij5OYW1lOiBKQU1FUyBESVRDSCBQcmVjaXA6IDAuMTI8L2Rpdj5gKVswXTsKICAgICAgICAgICAgcG9wdXBfMDU4ZTk5ZmJjNzNhNGM3ZDlmYzQ2Yjg5MmVlYjE0YTEuc2V0Q29udGVudChodG1sX2E2Njg0MTRmYzExNjQ0MzlhOTY0NzkxZDY1NjE3NDAxKTsKICAgICAgICAKCiAgICAgICAgbWFya2VyXzcxYjI1OWZiMzRiZDQ1NTg5ZjE3MWU2ZTAwNmM2NGI1LmJpbmRQb3B1cChwb3B1cF8wNThlOTlmYmM3M2E0YzdkOWZjNDZiODkyZWViMTRhMSkKICAgICAgICA7CgogICAgICAgIAogICAgCiAgICAKICAgICAgICAgICAgdmFyIG1hcmtlcl83ZmRmMmE1YWJhNjg0YjFkOWVlMmM5N2VmZGY3NTA3NiA9IEwubWFya2VyKAogICAgICAgICAgICAgICAgWzQwLjAxODY2NywgLTEwNS4zMjYyNV0sCiAgICAgICAgICAgICAgICB7fQogICAgICAgICAgICApLmFkZFRvKG1hcmtlcl9jbHVzdGVyX2ZlNGUxYWQ3ODllNzQ2ZjI5OTlkYzM0OGQ2ZTY0MDAzKTsKICAgICAgICAKICAgIAogICAgICAgIHZhciBwb3B1cF9hYjI0YjhiNjk4ZWI0ZDBhYjg5YTQyYTk1YjhjNTcwMCA9IEwucG9wdXAoeyJtYXhXaWR0aCI6ICIxMDAlIn0pOwoKICAgICAgICAKICAgICAgICAgICAgdmFyIGh0bWxfOGE1ZWJlYTk2MWMyNDlhNGI2NjEyZWYwYmNkZWEwZGUgPSAkKGA8ZGl2IGlkPSJodG1sXzhhNWViZWE5NjFjMjQ5YTRiNjYxMmVmMGJjZGVhMGRlIiBzdHlsZT0id2lkdGg6IDEwMC4wJTsgaGVpZ2h0OiAxMDAuMCU7Ij5OYW1lOiBGT1VSTUlMRSBDUkVFSyBBVCBPUk9ERUxMLCBDTyBQcmVjaXA6IDAuNzQ8L2Rpdj5gKVswXTsKICAgICAgICAgICAgcG9wdXBfYWIyNGI4YjY5OGViNGQwYWI4OWE0MmE5NWI4YzU3MDAuc2V0Q29udGVudChodG1sXzhhNWViZWE5NjFjMjQ5YTRiNjYxMmVmMGJjZGVhMGRlKTsKICAgICAgICAKCiAgICAgICAgbWFya2VyXzdmZGYyYTVhYmE2ODRiMWQ5ZWUyYzk3ZWZkZjc1MDc2LmJpbmRQb3B1cChwb3B1cF9hYjI0YjhiNjk4ZWI0ZDBhYjg5YTQyYTk1YjhjNTcwMCkKICAgICAgICA7CgogICAgICAgIAogICAgCiAgICAKICAgICAgICAgICAgdmFyIG1hcmtlcl9kNDViYjk1Y2EyYjA0ZThmOTUwMGU5OWYxNjExMjFjZCA9IEwubWFya2VyKAogICAgICAgICAgICAgICAgWzQwLjE4MTg4LCAtMTA1LjE5Njc3NV0sCiAgICAgICAgICAgICAgICB7fQogICAgICAgICAgICApLmFkZFRvKG1hcmtlcl9jbHVzdGVyX2ZlNGUxYWQ3ODllNzQ2ZjI5OTlkYzM0OGQ2ZTY0MDAzKTsKICAgICAgICAKICAgIAogICAgICAgIHZhciBwb3B1cF82MTY0NzRlZmNlNTM0ZWU1OGI4NmMzMmQzMmFjOTAwMyA9IEwucG9wdXAoeyJtYXhXaWR0aCI6ICIxMDAlIn0pOwoKICAgICAgICAKICAgICAgICAgICAgdmFyIGh0bWxfMWNkZTAxODgwMjYyNDg2NjlmMWY3ZWZjNGM0ZGM5NjkgPSAkKGA8ZGl2IGlkPSJodG1sXzFjZGUwMTg4MDI2MjQ4NjY5ZjFmN2VmYzRjNGRjOTY5IiBzdHlsZT0id2lkdGg6IDEwMC4wJTsgaGVpZ2h0OiAxMDAuMCU7Ij5OYW1lOiBEQVZJUyBBTkQgRE9XTklORyBESVRDSCBQcmVjaXA6IDAuMDA8L2Rpdj5gKVswXTsKICAgICAgICAgICAgcG9wdXBfNjE2NDc0ZWZjZTUzNGVlNThiODZjMzJkMzJhYzkwMDMuc2V0Q29udGVudChodG1sXzFjZGUwMTg4MDI2MjQ4NjY5ZjFmN2VmYzRjNGRjOTY5KTsKICAgICAgICAKCiAgICAgICAgbWFya2VyX2Q0NWJiOTVjYTJiMDRlOGY5NTAwZTk5ZjE2MTEyMWNkLmJpbmRQb3B1cChwb3B1cF82MTY0NzRlZmNlNTM0ZWU1OGI4NmMzMmQzMmFjOTAwMykKICAgICAgICA7CgogICAgICAgIAogICAgCiAgICAKICAgICAgICAgICAgdmFyIG1hcmtlcl8xODI3Njg0OGM1NGY0ZWY4ODhhNTQ5MTJjMWJmYTYyZiA9IEwubWFya2VyKAogICAgICAgICAgICAgICAgWzQwLjE4NzUyNCwgLTEwNS4xODkxMzJdLAogICAgICAgICAgICAgICAge30KICAgICAgICAgICAgKS5hZGRUbyhtYXJrZXJfY2x1c3Rlcl9mZTRlMWFkNzg5ZTc0NmYyOTk5ZGMzNDhkNmU2NDAwMyk7CiAgICAgICAgCiAgICAKICAgICAgICB2YXIgcG9wdXBfZGEyZjkyOWI2Zjk1NDhkYjk0ZjkxOWEzYjk1NDFlN2UgPSBMLnBvcHVwKHsibWF4V2lkdGgiOiAiMTAwJSJ9KTsKCiAgICAgICAgCiAgICAgICAgICAgIHZhciBodG1sXzAzOGNjNzhkYTAxODQ2MGViODY5ZTRhYTQ0NjQ1NDg5ID0gJChgPGRpdiBpZD0iaHRtbF8wMzhjYzc4ZGEwMTg0NjBlYjg2OWU0YWE0NDY0NTQ4OSIgc3R5bGU9IndpZHRoOiAxMDAuMCU7IGhlaWdodDogMTAwLjAlOyI+TmFtZTogUlVOWU9OIERJVENIIFByZWNpcDogMC4wMDwvZGl2PmApWzBdOwogICAgICAgICAgICBwb3B1cF9kYTJmOTI5YjZmOTU0OGRiOTRmOTE5YTNiOTU0MWU3ZS5zZXRDb250ZW50KGh0bWxfMDM4Y2M3OGRhMDE4NDYwZWI4NjllNGFhNDQ2NDU0ODkpOwogICAgICAgIAoKICAgICAgICBtYXJrZXJfMTgyNzY4NDhjNTRmNGVmODg4YTU0OTEyYzFiZmE2MmYuYmluZFBvcHVwKHBvcHVwX2RhMmY5MjliNmY5NTQ4ZGI5NGY5MTlhM2I5NTQxZTdlKQogICAgICAgIDsKCiAgICAgICAgCiAgICAKICAgIAogICAgICAgICAgICB2YXIgbWFya2VyX2JlYWY2OGRiNjY2ZTQwZjdhMGI0ZGU3ODcwMGM3NjNjID0gTC5tYXJrZXIoCiAgICAgICAgICAgICAgICBbNDAuMjExMDgzLCAtMTA1LjI1MDkyN10sCiAgICAgICAgICAgICAgICB7fQogICAgICAgICAgICApLmFkZFRvKG1hcmtlcl9jbHVzdGVyX2ZlNGUxYWQ3ODllNzQ2ZjI5OTlkYzM0OGQ2ZTY0MDAzKTsKICAgICAgICAKICAgIAogICAgICAgIHZhciBwb3B1cF8wMDA4ODIzYzE1ZmM0MjExYjFkYTFjN2JiYzI5MTczMyA9IEwucG9wdXAoeyJtYXhXaWR0aCI6ICIxMDAlIn0pOwoKICAgICAgICAKICAgICAgICAgICAgdmFyIGh0bWxfZmUyZDg5ODFiZDkxNGVjYTkwZjdhZjljY2Q3MWJmY2UgPSAkKGA8ZGl2IGlkPSJodG1sX2ZlMmQ4OTgxYmQ5MTRlY2E5MGY3YWY5Y2NkNzFiZmNlIiBzdHlsZT0id2lkdGg6IDEwMC4wJTsgaGVpZ2h0OiAxMDAuMCU7Ij5OYW1lOiBTV0VERSBESVRDSCBQcmVjaXA6IDAuMDA8L2Rpdj5gKVswXTsKICAgICAgICAgICAgcG9wdXBfMDAwODgyM2MxNWZjNDIxMWIxZGExYzdiYmMyOTE3MzMuc2V0Q29udGVudChodG1sX2ZlMmQ4OTgxYmQ5MTRlY2E5MGY3YWY5Y2NkNzFiZmNlKTsKICAgICAgICAKCiAgICAgICAgbWFya2VyX2JlYWY2OGRiNjY2ZTQwZjdhMGI0ZGU3ODcwMGM3NjNjLmJpbmRQb3B1cChwb3B1cF8wMDA4ODIzYzE1ZmM0MjExYjFkYTFjN2JiYzI5MTczMykKICAgICAgICA7CgogICAgICAgIAogICAgCiAgICAKICAgICAgICAgICAgdmFyIG1hcmtlcl9mN2NkNmNhMTI0MTg0YTY3YjdhYTQ2YjliM2ExNmZmYiA9IEwubWFya2VyKAogICAgICAgICAgICAgICAgWzQwLjE1MzM2MywgLTEwNS4wODg2OTVdLAogICAgICAgICAgICAgICAge30KICAgICAgICAgICAgKS5hZGRUbyhtYXJrZXJfY2x1c3Rlcl9mZTRlMWFkNzg5ZTc0NmYyOTk5ZGMzNDhkNmU2NDAwMyk7CiAgICAgICAgCiAgICAKICAgICAgICB2YXIgcG9wdXBfNzA5MmI1OWY2MjlmNDFjYjg5MDVkZmEzYzljZWMwNGEgPSBMLnBvcHVwKHsibWF4V2lkdGgiOiAiMTAwJSJ9KTsKCiAgICAgICAgCiAgICAgICAgICAgIHZhciBodG1sXzcxODQzYTEyNmY4ZTQ3MjA5ZTIyNTI0MGQwMTIyN2M3ID0gJChgPGRpdiBpZD0iaHRtbF83MTg0M2ExMjZmOGU0NzIwOWUyMjUyNDBkMDEyMjdjNyIgc3R5bGU9IndpZHRoOiAxMDAuMCU7IGhlaWdodDogMTAwLjAlOyI+TmFtZTogQk9OVVMgRElUQ0ggUHJlY2lwOiAwLjEwPC9kaXY+YClbMF07CiAgICAgICAgICAgIHBvcHVwXzcwOTJiNTlmNjI5ZjQxY2I4OTA1ZGZhM2M5Y2VjMDRhLnNldENvbnRlbnQoaHRtbF83MTg0M2ExMjZmOGU0NzIwOWUyMjUyNDBkMDEyMjdjNyk7CiAgICAgICAgCgogICAgICAgIG1hcmtlcl9mN2NkNmNhMTI0MTg0YTY3YjdhYTQ2YjliM2ExNmZmYi5iaW5kUG9wdXAocG9wdXBfNzA5MmI1OWY2MjlmNDFjYjg5MDVkZmEzYzljZWMwNGEpCiAgICAgICAgOwoKICAgICAgICAKICAgIAogICAgCiAgICAgICAgICAgIHZhciBtYXJrZXJfOGJlOTZmM2ZjYTBlNDQ3YmJlOTE2ODg4MTBkY2E3YTMgPSBMLm1hcmtlcigKICAgICAgICAgICAgICAgIFs0MC4yMTEzODksIC0xMDUuMjUwOTUyXSwKICAgICAgICAgICAgICAgIHt9CiAgICAgICAgICAgICkuYWRkVG8obWFya2VyX2NsdXN0ZXJfZmU0ZTFhZDc4OWU3NDZmMjk5OWRjMzQ4ZDZlNjQwMDMpOwogICAgICAgIAogICAgCiAgICAgICAgdmFyIHBvcHVwX2ZhYWQ0ZTI3OTMyMzRjZWZiNGY5YjU0ZjhiMzU3ZWU5ID0gTC5wb3B1cCh7Im1heFdpZHRoIjogIjEwMCUifSk7CgogICAgICAgIAogICAgICAgICAgICB2YXIgaHRtbF82ZDI1YzUyMmI3ZDA0Yzg2ODUyMTE5YzgzZDE4N2UwYSA9ICQoYDxkaXYgaWQ9Imh0bWxfNmQyNWM1MjJiN2QwNGM4Njg1MjExOWM4M2QxODdlMGEiIHN0eWxlPSJ3aWR0aDogMTAwLjAlOyBoZWlnaHQ6IDEwMC4wJTsiPk5hbWU6IFNNRUFEIERJVENIIFByZWNpcDogMC4wMDwvZGl2PmApWzBdOwogICAgICAgICAgICBwb3B1cF9mYWFkNGUyNzkzMjM0Y2VmYjRmOWI1NGY4YjM1N2VlOS5zZXRDb250ZW50KGh0bWxfNmQyNWM1MjJiN2QwNGM4Njg1MjExOWM4M2QxODdlMGEpOwogICAgICAgIAoKICAgICAgICBtYXJrZXJfOGJlOTZmM2ZjYTBlNDQ3YmJlOTE2ODg4MTBkY2E3YTMuYmluZFBvcHVwKHBvcHVwX2ZhYWQ0ZTI3OTMyMzRjZWZiNGY5YjU0ZjhiMzU3ZWU5KQogICAgICAgIDsKCiAgICAgICAgCiAgICAKICAgIAogICAgICAgICAgICB2YXIgbWFya2VyXzhjOWJhZDgyM2Q4YzQ0ZmJiNzJlYjAwN2FiYTNlODIzID0gTC5tYXJrZXIoCiAgICAgICAgICAgICAgICBbNDAuMTczOTUsIC0xMDUuMTY5Mzc0XSwKICAgICAgICAgICAgICAgIHt9CiAgICAgICAgICAgICkuYWRkVG8obWFya2VyX2NsdXN0ZXJfZmU0ZTFhZDc4OWU3NDZmMjk5OWRjMzQ4ZDZlNjQwMDMpOwogICAgICAgIAogICAgCiAgICAgICAgdmFyIHBvcHVwXzIzYzdhN2I3NmZkODRkMmI4NDZlYjk5MGVhYTc0MmE5ID0gTC5wb3B1cCh7Im1heFdpZHRoIjogIjEwMCUifSk7CgogICAgICAgIAogICAgICAgICAgICB2YXIgaHRtbF8xZWQ2ZTQ3NjYxYTU0MWUyOTMwYzg0MTIxNGFmYWY2OSA9ICQoYDxkaXYgaWQ9Imh0bWxfMWVkNmU0NzY2MWE1NDFlMjkzMGM4NDEyMTRhZmFmNjkiIHN0eWxlPSJ3aWR0aDogMTAwLjAlOyBoZWlnaHQ6IDEwMC4wJTsiPk5hbWU6IE5JV09UIERJVENIIFByZWNpcDogMC4xOTwvZGl2PmApWzBdOwogICAgICAgICAgICBwb3B1cF8yM2M3YTdiNzZmZDg0ZDJiODQ2ZWI5OTBlYWE3NDJhOS5zZXRDb250ZW50KGh0bWxfMWVkNmU0NzY2MWE1NDFlMjkzMGM4NDEyMTRhZmFmNjkpOwogICAgICAgIAoKICAgICAgICBtYXJrZXJfOGM5YmFkODIzZDhjNDRmYmI3MmViMDA3YWJhM2U4MjMuYmluZFBvcHVwKHBvcHVwXzIzYzdhN2I3NmZkODRkMmI4NDZlYjk5MGVhYTc0MmE5KQogICAgICAgIDsKCiAgICAgICAgCiAgICAKICAgIAogICAgICAgICAgICB2YXIgbWFya2VyX2FjODgyMjdhYjQ5ZTQxYWI4ODkwZWQ3MDExNTZmYjI1ID0gTC5tYXJrZXIoCiAgICAgICAgICAgICAgICBbNDAuMDc4NTYsIC0xMDUuMjIwNDk3XSwKICAgICAgICAgICAgICAgIHt9CiAgICAgICAgICAgICkuYWRkVG8obWFya2VyX2NsdXN0ZXJfZmU0ZTFhZDc4OWU3NDZmMjk5OWRjMzQ4ZDZlNjQwMDMpOwogICAgICAgIAogICAgCiAgICAgICAgdmFyIHBvcHVwXzRjYjgwNjRlYzZjZDRiNjRhZGY0OTBjMWMwMTdmY2ZhID0gTC5wb3B1cCh7Im1heFdpZHRoIjogIjEwMCUifSk7CgogICAgICAgIAogICAgICAgICAgICB2YXIgaHRtbF8wMzQwMzMwYmI2NTg0MDJjYjY1MzU4Y2VkNTJiNmU5YSA9ICQoYDxkaXYgaWQ9Imh0bWxfMDM0MDMzMGJiNjU4NDAyY2I2NTM1OGNlZDUyYjZlOWEiIHN0eWxlPSJ3aWR0aDogMTAwLjAlOyBoZWlnaHQ6IDEwMC4wJTsiPk5hbWU6IEJPVUxERVIgUkVTRVJWT0lSIFByZWNpcDogNTE5Ny41MDwvZGl2PmApWzBdOwogICAgICAgICAgICBwb3B1cF80Y2I4MDY0ZWM2Y2Q0YjY0YWRmNDkwYzFjMDE3ZmNmYS5zZXRDb250ZW50KGh0bWxfMDM0MDMzMGJiNjU4NDAyY2I2NTM1OGNlZDUyYjZlOWEpOwogICAgICAgIAoKICAgICAgICBtYXJrZXJfYWM4ODIyN2FiNDllNDFhYjg4OTBlZDcwMTE1NmZiMjUuYmluZFBvcHVwKHBvcHVwXzRjYjgwNjRlYzZjZDRiNjRhZGY0OTBjMWMwMTdmY2ZhKQogICAgICAgIDsKCiAgICAgICAgCiAgICAKICAgIAogICAgICAgICAgICB2YXIgbWFya2VyXzlkMmFlNTM5OThmNjRhZGE5ZWZlZGExMzNkZjJiN2ZlID0gTC5tYXJrZXIoCiAgICAgICAgICAgICAgICBbNDAuMjE1MDQzLCAtMTA1LjI1NjAxN10sCiAgICAgICAgICAgICAgICB7fQogICAgICAgICAgICApLmFkZFRvKG1hcmtlcl9jbHVzdGVyX2ZlNGUxYWQ3ODllNzQ2ZjI5OTlkYzM0OGQ2ZTY0MDAzKTsKICAgICAgICAKICAgIAogICAgICAgIHZhciBwb3B1cF9iZDAyYTVkZjBlMjM0ZDcwYTQ2ZjY3YTUyZmMwNWFjMSA9IEwucG9wdXAoeyJtYXhXaWR0aCI6ICIxMDAlIn0pOwoKICAgICAgICAKICAgICAgICAgICAgdmFyIGh0bWxfMDNhMmRkMTUwYTI1NGRmM2FlZDQ2MDEwZThkNjczN2QgPSAkKGA8ZGl2IGlkPSJodG1sXzAzYTJkZDE1MGEyNTRkZjNhZWQ0NjAxMGU4ZDY3MzdkIiBzdHlsZT0id2lkdGg6IDEwMC4wJTsgaGVpZ2h0OiAxMDAuMCU7Ij5OYW1lOiBISUdITEFORCBESVRDSCBBVCBMWU9OUywgQ08gUHJlY2lwOiAzOS43MDwvZGl2PmApWzBdOwogICAgICAgICAgICBwb3B1cF9iZDAyYTVkZjBlMjM0ZDcwYTQ2ZjY3YTUyZmMwNWFjMS5zZXRDb250ZW50KGh0bWxfMDNhMmRkMTUwYTI1NGRmM2FlZDQ2MDEwZThkNjczN2QpOwogICAgICAgIAoKICAgICAgICBtYXJrZXJfOWQyYWU1Mzk5OGY2NGFkYTllZmVkYTEzM2RmMmI3ZmUuYmluZFBvcHVwKHBvcHVwX2JkMDJhNWRmMGUyMzRkNzBhNDZmNjdhNTJmYzA1YWMxKQogICAgICAgIDsKCiAgICAgICAgCiAgICAKICAgIAogICAgICAgICAgICB2YXIgbWFya2VyXzBjMjZlYzFkNDFiMDQyNWNhODBjMTk5MDY2OGFjNGIwID0gTC5tYXJrZXIoCiAgICAgICAgICAgICAgICBbNDAuMjYwODI3LCAtMTA1LjE5ODU2N10sCiAgICAgICAgICAgICAgICB7fQogICAgICAgICAgICApLmFkZFRvKG1hcmtlcl9jbHVzdGVyX2ZlNGUxYWQ3ODllNzQ2ZjI5OTlkYzM0OGQ2ZTY0MDAzKTsKICAgICAgICAKICAgIAogICAgICAgIHZhciBwb3B1cF9mNTVhZjEyMjEwMDY0NGQxOTdkMDA4NmJkNTc3M2QxNiA9IEwucG9wdXAoeyJtYXhXaWR0aCI6ICIxMDAlIn0pOwoKICAgICAgICAKICAgICAgICAgICAgdmFyIGh0bWxfMGY4NjBmMWJjMDcyNDg1YTlkNjhkNGM1MzU1ZWJlMmQgPSAkKGA8ZGl2IGlkPSJodG1sXzBmODYwZjFiYzA3MjQ4NWE5ZDY4ZDRjNTM1NWViZTJkIiBzdHlsZT0id2lkdGg6IDEwMC4wJTsgaGVpZ2h0OiAxMDAuMCU7Ij5OYW1lOiBDVUxWRVIgRElUQ0ggUHJlY2lwOiAwLjAwPC9kaXY+YClbMF07CiAgICAgICAgICAgIHBvcHVwX2Y1NWFmMTIyMTAwNjQ0ZDE5N2QwMDg2YmQ1NzczZDE2LnNldENvbnRlbnQoaHRtbF8wZjg2MGYxYmMwNzI0ODVhOWQ2OGQ0YzUzNTVlYmUyZCk7CiAgICAgICAgCgogICAgICAgIG1hcmtlcl8wYzI2ZWMxZDQxYjA0MjVjYTgwYzE5OTA2NjhhYzRiMC5iaW5kUG9wdXAocG9wdXBfZjU1YWYxMjIxMDA2NDRkMTk3ZDAwODZiZDU3NzNkMTYpCiAgICAgICAgOwoKICAgICAgICAKICAgIAogICAgCiAgICAgICAgICAgIHZhciBtYXJrZXJfZjZhOGJhZTM0NDRkNDEyMDkyODc0NTZmMWY0YmNkZDcgPSBMLm1hcmtlcigKICAgICAgICAgICAgICAgIFs0MC4yNTYyNzYsIC0xMDUuMjA5NDE2XSwKICAgICAgICAgICAgICAgIHt9CiAgICAgICAgICAgICkuYWRkVG8obWFya2VyX2NsdXN0ZXJfZmU0ZTFhZDc4OWU3NDZmMjk5OWRjMzQ4ZDZlNjQwMDMpOwogICAgICAgIAogICAgCiAgICAgICAgdmFyIHBvcHVwX2I4NzVjN2QxYzBlMDRlNGI4YTIzZTU1MWM2NjAxNzEzID0gTC5wb3B1cCh7Im1heFdpZHRoIjogIjEwMCUifSk7CgogICAgICAgIAogICAgICAgICAgICB2YXIgaHRtbF9jMmJlN2E3MDY2ZGU0MWFiODRhNDU3NTNmMzI2N2E3MyA9ICQoYDxkaXYgaWQ9Imh0bWxfYzJiZTdhNzA2NmRlNDFhYjg0YTQ1NzUzZjMyNjdhNzMiIHN0eWxlPSJ3aWR0aDogMTAwLjAlOyBoZWlnaHQ6IDEwMC4wJTsiPk5hbWU6IExJVFRMRSBUSE9NUFNPTiAjMSBESVRDSCBQcmVjaXA6IDAuMDA8L2Rpdj5gKVswXTsKICAgICAgICAgICAgcG9wdXBfYjg3NWM3ZDFjMGUwNGU0YjhhMjNlNTUxYzY2MDE3MTMuc2V0Q29udGVudChodG1sX2MyYmU3YTcwNjZkZTQxYWI4NGE0NTc1M2YzMjY3YTczKTsKICAgICAgICAKCiAgICAgICAgbWFya2VyX2Y2YThiYWUzNDQ0ZDQxMjA5Mjg3NDU2ZjFmNGJjZGQ3LmJpbmRQb3B1cChwb3B1cF9iODc1YzdkMWMwZTA0ZTRiOGEyM2U1NTFjNjYwMTcxMykKICAgICAgICA7CgogICAgICAgIAogICAgCiAgICAKICAgICAgICAgICAgdmFyIG1hcmtlcl9hMjA5NDM0ODI4MWY0ZjYwYmExOWFhNzM4NDI3ZjMxOSA9IEwubWFya2VyKAogICAgICAgICAgICAgICAgWzQwLjE3NDg0NCwgLTEwNS4xNjc4NzNdLAogICAgICAgICAgICAgICAge30KICAgICAgICAgICAgKS5hZGRUbyhtYXJrZXJfY2x1c3Rlcl9mZTRlMWFkNzg5ZTc0NmYyOTk5ZGMzNDhkNmU2NDAwMyk7CiAgICAgICAgCiAgICAKICAgICAgICB2YXIgcG9wdXBfM2NjN2M3ZTY4ZmNjNDdlMzhlMTk1ZDYyYjYyZjU1MzYgPSBMLnBvcHVwKHsibWF4V2lkdGgiOiAiMTAwJSJ9KTsKCiAgICAgICAgCiAgICAgICAgICAgIHZhciBodG1sX2YwYzYyZTg0ZmZjZDQxNTFhODJjYmU2YzhjY2U5ZDkxID0gJChgPGRpdiBpZD0iaHRtbF9mMGM2MmU4NGZmY2Q0MTUxYTgyY2JlNmM4Y2NlOWQ5MSIgc3R5bGU9IndpZHRoOiAxMDAuMCU7IGhlaWdodDogMTAwLjAlOyI+TmFtZTogSEFHRVIgTUVBRE9XUyBESVRDSCBQcmVjaXA6IDAuMTA8L2Rpdj5gKVswXTsKICAgICAgICAgICAgcG9wdXBfM2NjN2M3ZTY4ZmNjNDdlMzhlMTk1ZDYyYjYyZjU1MzYuc2V0Q29udGVudChodG1sX2YwYzYyZTg0ZmZjZDQxNTFhODJjYmU2YzhjY2U5ZDkxKTsKICAgICAgICAKCiAgICAgICAgbWFya2VyX2EyMDk0MzQ4MjgxZjRmNjBiYTE5YWE3Mzg0MjdmMzE5LmJpbmRQb3B1cChwb3B1cF8zY2M3YzdlNjhmY2M0N2UzOGUxOTVkNjJiNjJmNTUzNikKICAgICAgICA7CgogICAgICAgIAogICAgCiAgICAKICAgICAgICAgICAgdmFyIG1hcmtlcl9lNTIyYzM0ZGRhN2E0M2I3OWY2MmJiNmYxNzJhNWZhOSA9IEwubWFya2VyKAogICAgICAgICAgICAgICAgWzQwLjIxMjY1OCwgLTEwNS4yNTE4MjZdLAogICAgICAgICAgICAgICAge30KICAgICAgICAgICAgKS5hZGRUbyhtYXJrZXJfY2x1c3Rlcl9mZTRlMWFkNzg5ZTc0NmYyOTk5ZGMzNDhkNmU2NDAwMyk7CiAgICAgICAgCiAgICAKICAgICAgICB2YXIgcG9wdXBfNGExOTFmYzg0MDI0NDNmZTk1Nzg0MWIyMDIwZmI1ZmMgPSBMLnBvcHVwKHsibWF4V2lkdGgiOiAiMTAwJSJ9KTsKCiAgICAgICAgCiAgICAgICAgICAgIHZhciBodG1sX2EyNTI1Njc0MjhjYzQ4NmY4YWVkZTJhZjgwMTI1NzYyID0gJChgPGRpdiBpZD0iaHRtbF9hMjUyNTY3NDI4Y2M0ODZmOGFlZGUyYWY4MDEyNTc2MiIgc3R5bGU9IndpZHRoOiAxMDAuMCU7IGhlaWdodDogMTAwLjAlOyI+TmFtZTogUk9VR0ggQU5EIFJFQURZIERJVENIIFByZWNpcDogMC4wMDwvZGl2PmApWzBdOwogICAgICAgICAgICBwb3B1cF80YTE5MWZjODQwMjQ0M2ZlOTU3ODQxYjIwMjBmYjVmYy5zZXRDb250ZW50KGh0bWxfYTI1MjU2NzQyOGNjNDg2ZjhhZWRlMmFmODAxMjU3NjIpOwogICAgICAgIAoKICAgICAgICBtYXJrZXJfZTUyMmMzNGRkYTdhNDNiNzlmNjJiYjZmMTcyYTVmYTkuYmluZFBvcHVwKHBvcHVwXzRhMTkxZmM4NDAyNDQzZmU5NTc4NDFiMjAyMGZiNWZjKQogICAgICAgIDsKCiAgICAgICAgCiAgICAKICAgIAogICAgICAgICAgICB2YXIgbWFya2VyX2I3YmY2YWJmNzI5NjQzYjg5MDQxZjE3NmYyNzMyNGQwID0gTC5tYXJrZXIoCiAgICAgICAgICAgICAgICBbNDAuMTkzMDE5LCAtMTA1LjIxMDM4OF0sCiAgICAgICAgICAgICAgICB7fQogICAgICAgICAgICApLmFkZFRvKG1hcmtlcl9jbHVzdGVyX2ZlNGUxYWQ3ODllNzQ2ZjI5OTlkYzM0OGQ2ZTY0MDAzKTsKICAgICAgICAKICAgIAogICAgICAgIHZhciBwb3B1cF85Mjk2OTQ1ZjY3MGI0OTJjYmEwNGE3MjUwYjBmOTk4YyA9IEwucG9wdXAoeyJtYXhXaWR0aCI6ICIxMDAlIn0pOwoKICAgICAgICAKICAgICAgICAgICAgdmFyIGh0bWxfZmI1ZjBmMDE1M2QxNDQzODkwNGE1OTU3NjkyYWM1ZjcgPSAkKGA8ZGl2IGlkPSJodG1sX2ZiNWYwZjAxNTNkMTQ0Mzg5MDRhNTk1NzY5MmFjNWY3IiBzdHlsZT0id2lkdGg6IDEwMC4wJTsgaGVpZ2h0OiAxMDAuMCU7Ij5OYW1lOiBUUlVFIEFORCBXRUJTVEVSIERJVENIIFByZWNpcDogMC4wMDwvZGl2PmApWzBdOwogICAgICAgICAgICBwb3B1cF85Mjk2OTQ1ZjY3MGI0OTJjYmEwNGE3MjUwYjBmOTk4Yy5zZXRDb250ZW50KGh0bWxfZmI1ZjBmMDE1M2QxNDQzODkwNGE1OTU3NjkyYWM1ZjcpOwogICAgICAgIAoKICAgICAgICBtYXJrZXJfYjdiZjZhYmY3Mjk2NDNiODkwNDFmMTc2ZjI3MzI0ZDAuYmluZFBvcHVwKHBvcHVwXzkyOTY5NDVmNjcwYjQ5MmNiYTA0YTcyNTBiMGY5OThjKQogICAgICAgIDsKCiAgICAgICAgCiAgICAKICAgIAogICAgICAgICAgICB2YXIgbWFya2VyXzIwYTk3ZWUxZWQ1NTRhMDY5ZGZkMjU0MDc5ODZkZjQ2ID0gTC5tYXJrZXIoCiAgICAgICAgICAgICAgICBbNDAuMDg2Mjc4LCAtMTA1LjIxNzUxOV0sCiAgICAgICAgICAgICAgICB7fQogICAgICAgICAgICApLmFkZFRvKG1hcmtlcl9jbHVzdGVyX2ZlNGUxYWQ3ODllNzQ2ZjI5OTlkYzM0OGQ2ZTY0MDAzKTsKICAgICAgICAKICAgIAogICAgICAgIHZhciBwb3B1cF9jYmM5OWM0MjVkYWY0MDkzODJjYTcwMjc5MmEzNGUzZSA9IEwucG9wdXAoeyJtYXhXaWR0aCI6ICIxMDAlIn0pOwoKICAgICAgICAKICAgICAgICAgICAgdmFyIGh0bWxfOTkwNWIyNGRjMTEwNDJlYWExM2Y2ZTQ4YzhiNDFiOTUgPSAkKGA8ZGl2IGlkPSJodG1sXzk5MDViMjRkYzExMDQyZWFhMTNmNmU0OGM4YjQxYjk1IiBzdHlsZT0id2lkdGg6IDEwMC4wJTsgaGVpZ2h0OiAxMDAuMCU7Ij5OYW1lOiBCT1VMREVSIFJFU0VSVk9JUiBJTkxFVCBQcmVjaXA6IDAuMDA8L2Rpdj5gKVswXTsKICAgICAgICAgICAgcG9wdXBfY2JjOTljNDI1ZGFmNDA5MzgyY2E3MDI3OTJhMzRlM2Uuc2V0Q29udGVudChodG1sXzk5MDViMjRkYzExMDQyZWFhMTNmNmU0OGM4YjQxYjk1KTsKICAgICAgICAKCiAgICAgICAgbWFya2VyXzIwYTk3ZWUxZWQ1NTRhMDY5ZGZkMjU0MDc5ODZkZjQ2LmJpbmRQb3B1cChwb3B1cF9jYmM5OWM0MjVkYWY0MDkzODJjYTcwMjc5MmEzNGUzZSkKICAgICAgICA7CgogICAgICAgIAogICAgCiAgICAKICAgICAgICAgICAgdmFyIG1hcmtlcl81OTFhOTkzOWZmYTA0NDRiODZlMTA1N2YyYmU5ZjZmYiA9IEwubWFya2VyKAogICAgICAgICAgICAgICAgWzQwLjEyNjM4OSwgLTEwNS4zMDQ0MDRdLAogICAgICAgICAgICAgICAge30KICAgICAgICAgICAgKS5hZGRUbyhtYXJrZXJfY2x1c3Rlcl9mZTRlMWFkNzg5ZTc0NmYyOTk5ZGMzNDhkNmU2NDAwMyk7CiAgICAgICAgCiAgICAKICAgICAgICB2YXIgcG9wdXBfNmI2NWYyM2ZjMjZkNDAyYThhNGM1NDBhMzM2OTM3OWQgPSBMLnBvcHVwKHsibWF4V2lkdGgiOiAiMTAwJSJ9KTsKCiAgICAgICAgCiAgICAgICAgICAgIHZhciBodG1sX2FiOGY1YTIyMTgxYTRjYTFhM2Q2YmI3MzM2MjY0OGU3ID0gJChgPGRpdiBpZD0iaHRtbF9hYjhmNWEyMjE4MWE0Y2ExYTNkNmJiNzMzNjI2NDhlNyIgc3R5bGU9IndpZHRoOiAxMDAuMCU7IGhlaWdodDogMTAwLjAlOyI+TmFtZTogTEVGVCBIQU5EIENSRUVLIE5FQVIgQk9VTERFUiwgQ08uIFByZWNpcDogMTIuNjA8L2Rpdj5gKVswXTsKICAgICAgICAgICAgcG9wdXBfNmI2NWYyM2ZjMjZkNDAyYThhNGM1NDBhMzM2OTM3OWQuc2V0Q29udGVudChodG1sX2FiOGY1YTIyMTgxYTRjYTFhM2Q2YmI3MzM2MjY0OGU3KTsKICAgICAgICAKCiAgICAgICAgbWFya2VyXzU5MWE5OTM5ZmZhMDQ0NGI4NmUxMDU3ZjJiZTlmNmZiLmJpbmRQb3B1cChwb3B1cF82YjY1ZjIzZmMyNmQ0MDJhOGE0YzU0MGEzMzY5Mzc5ZCkKICAgICAgICA7CgogICAgICAgIAogICAgCiAgICAKICAgICAgICAgICAgdmFyIG1hcmtlcl8wY2UyZTAwNjMxMjI0MjU2YjU5MTRiNjMxZTcwZGEzYSA9IEwubWFya2VyKAogICAgICAgICAgICAgICAgWzQwLjIxNTY1OCwgLTEwNS4zNjM0MjJdLAogICAgICAgICAgICAgICAge30KICAgICAgICAgICAgKS5hZGRUbyhtYXJrZXJfY2x1c3Rlcl9mZTRlMWFkNzg5ZTc0NmYyOTk5ZGMzNDhkNmU2NDAwMyk7CiAgICAgICAgCiAgICAKICAgICAgICB2YXIgcG9wdXBfMWZhOWQ1MGVhMGFjNGQ0M2JhMjBlYjczMjcyNjc5ZjkgPSBMLnBvcHVwKHsibWF4V2lkdGgiOiAiMTAwJSJ9KTsKCiAgICAgICAgCiAgICAgICAgICAgIHZhciBodG1sXzhiNGJjMTZhNmI5MjQ2ZjE4M2M0NTUwNTY4ZjgyZmFkID0gJChgPGRpdiBpZD0iaHRtbF84YjRiYzE2YTZiOTI0NmYxODNjNDU1MDU2OGY4MmZhZCIgc3R5bGU9IndpZHRoOiAxMDAuMCU7IGhlaWdodDogMTAwLjAlOyI+TmFtZTogTk9SVEggU0FJTlQgVlJBSU4gQ1JFRUsgQkVMT1cgQlVUVE9OUk9DSyAgKFJBTFBIIFBSSUNFKSBSRVNFUlZPSVIgUHJlY2lwOiAxOS4zMDwvZGl2PmApWzBdOwogICAgICAgICAgICBwb3B1cF8xZmE5ZDUwZWEwYWM0ZDQzYmEyMGViNzMyNzI2NzlmOS5zZXRDb250ZW50KGh0bWxfOGI0YmMxNmE2YjkyNDZmMTgzYzQ1NTA1NjhmODJmYWQpOwogICAgICAgIAoKICAgICAgICBtYXJrZXJfMGNlMmUwMDYzMTIyNDI1NmI1OTE0YjYzMWU3MGRhM2EuYmluZFBvcHVwKHBvcHVwXzFmYTlkNTBlYTBhYzRkNDNiYTIwZWI3MzI3MjY3OWY5KQogICAgICAgIDsKCiAgICAgICAgCiAgICAKICAgIAogICAgICAgICAgICB2YXIgbWFya2VyXzIwMDdkMzY5MDhkZTQ2OGE4MjY4ZTJjM2NjMTAzOTljID0gTC5tYXJrZXIoCiAgICAgICAgICAgICAgICBbNDAuMDU5ODA5LCAtMTA1LjA5Nzg3Ml0sCiAgICAgICAgICAgICAgICB7fQogICAgICAgICAgICApLmFkZFRvKG1hcmtlcl9jbHVzdGVyX2ZlNGUxYWQ3ODllNzQ2ZjI5OTlkYzM0OGQ2ZTY0MDAzKTsKICAgICAgICAKICAgIAogICAgICAgIHZhciBwb3B1cF8wOTU2ZDM5YjZiYTU0MWYyOTYwZWEyYzM2MGMxZWFhMiA9IEwucG9wdXAoeyJtYXhXaWR0aCI6ICIxMDAlIn0pOwoKICAgICAgICAKICAgICAgICAgICAgdmFyIGh0bWxfN2JhYzg4MGE5Y2M5NDI0NDg0OTU5M2U3YmQ5OTU0ZmMgPSAkKGA8ZGl2IGlkPSJodG1sXzdiYWM4ODBhOWNjOTQyNDQ4NDk1OTNlN2JkOTk1NGZjIiBzdHlsZT0id2lkdGg6IDEwMC4wJTsgaGVpZ2h0OiAxMDAuMCU7Ij5OYW1lOiBCT1VMREVSIENSRUVLIEFUIDEwOSBTVCBORUFSIEVSSUUsIENPIFByZWNpcDogNDQuNjA8L2Rpdj5gKVswXTsKICAgICAgICAgICAgcG9wdXBfMDk1NmQzOWI2YmE1NDFmMjk2MGVhMmMzNjBjMWVhYTIuc2V0Q29udGVudChodG1sXzdiYWM4ODBhOWNjOTQyNDQ4NDk1OTNlN2JkOTk1NGZjKTsKICAgICAgICAKCiAgICAgICAgbWFya2VyXzIwMDdkMzY5MDhkZTQ2OGE4MjY4ZTJjM2NjMTAzOTljLmJpbmRQb3B1cChwb3B1cF8wOTU2ZDM5YjZiYTU0MWYyOTYwZWEyYzM2MGMxZWFhMikKICAgICAgICA7CgogICAgICAgIAogICAgCiAgICAKICAgICAgICAgICAgdmFyIG1hcmtlcl83YTMzMDdjOTNhMGM0NTI5YWFhZmNmNzZjZjFhNjUwYiA9IEwubWFya2VyKAogICAgICAgICAgICAgICAgWzM5Ljk2MTY1NSwgLTEwNS41MDQ0NF0sCiAgICAgICAgICAgICAgICB7fQogICAgICAgICAgICApLmFkZFRvKG1hcmtlcl9jbHVzdGVyX2ZlNGUxYWQ3ODllNzQ2ZjI5OTlkYzM0OGQ2ZTY0MDAzKTsKICAgICAgICAKICAgIAogICAgICAgIHZhciBwb3B1cF85OTM4MDM5NjRlYmY0ZThiOTJiZDI2YmVhNDFmNDI0NyA9IEwucG9wdXAoeyJtYXhXaWR0aCI6ICIxMDAlIn0pOwoKICAgICAgICAKICAgICAgICAgICAgdmFyIGh0bWxfYjNlNzM2Y2ExMWUxNDhkMGE0ODU1NzAwMmJhMTA3OTAgPSAkKGA8ZGl2IGlkPSJodG1sX2IzZTczNmNhMTFlMTQ4ZDBhNDg1NTcwMDJiYTEwNzkwIiBzdHlsZT0id2lkdGg6IDEwMC4wJTsgaGVpZ2h0OiAxMDAuMCU7Ij5OYW1lOiBNSURETEUgQk9VTERFUiBDUkVFSyBBVCBORURFUkxBTkQsIENPLiBQcmVjaXA6IDIyLjUwPC9kaXY+YClbMF07CiAgICAgICAgICAgIHBvcHVwXzk5MzgwMzk2NGViZjRlOGI5MmJkMjZiZWE0MWY0MjQ3LnNldENvbnRlbnQoaHRtbF9iM2U3MzZjYTExZTE0OGQwYTQ4NTU3MDAyYmExMDc5MCk7CiAgICAgICAgCgogICAgICAgIG1hcmtlcl83YTMzMDdjOTNhMGM0NTI5YWFhZmNmNzZjZjFhNjUwYi5iaW5kUG9wdXAocG9wdXBfOTkzODAzOTY0ZWJmNGU4YjkyYmQyNmJlYTQxZjQyNDcpCiAgICAgICAgOwoKICAgICAgICAKICAgIAogICAgCiAgICAgICAgICAgIHZhciBtYXJrZXJfMjdhOTNlMTQzNDU5NGE0N2IyYmUwZjNjYWYyZTBjMWMgPSBMLm1hcmtlcigKICAgICAgICAgICAgICAgIFs0MC4xNTMzNDEsIC0xMDUuMDc1Njk1XSwKICAgICAgICAgICAgICAgIHt9CiAgICAgICAgICAgICkuYWRkVG8obWFya2VyX2NsdXN0ZXJfZmU0ZTFhZDc4OWU3NDZmMjk5OWRjMzQ4ZDZlNjQwMDMpOwogICAgICAgIAogICAgCiAgICAgICAgdmFyIHBvcHVwXzU0ZWU2YmI5YTc0NDQyYjJhN2Q0MzdhZmQxMjYxZWMzID0gTC5wb3B1cCh7Im1heFdpZHRoIjogIjEwMCUifSk7CgogICAgICAgIAogICAgICAgICAgICB2YXIgaHRtbF9iMGUxZDVjMjY0ZTI0ZjlmYjhlYzRiM2NiNTk5OTFmOCA9ICQoYDxkaXYgaWQ9Imh0bWxfYjBlMWQ1YzI2NGUyNGY5ZmI4ZWM0YjNjYjU5OTkxZjgiIHN0eWxlPSJ3aWR0aDogMTAwLjAlOyBoZWlnaHQ6IDEwMC4wJTsiPk5hbWU6IFNBSU5UIFZSQUlOIENSRUVLIEJFTE9XIEtFTiBQUkFUVCBCTFZEIEFUIExPTkdNT05ULCBDTyBQcmVjaXA6IDM2LjMwPC9kaXY+YClbMF07CiAgICAgICAgICAgIHBvcHVwXzU0ZWU2YmI5YTc0NDQyYjJhN2Q0MzdhZmQxMjYxZWMzLnNldENvbnRlbnQoaHRtbF9iMGUxZDVjMjY0ZTI0ZjlmYjhlYzRiM2NiNTk5OTFmOCk7CiAgICAgICAgCgogICAgICAgIG1hcmtlcl8yN2E5M2UxNDM0NTk0YTQ3YjJiZTBmM2NhZjJlMGMxYy5iaW5kUG9wdXAocG9wdXBfNTRlZTZiYjlhNzQ0NDJiMmE3ZDQzN2FmZDEyNjFlYzMpCiAgICAgICAgOwoKICAgICAgICAKICAgIAogICAgCiAgICAgICAgICAgIHZhciBtYXJrZXJfY2I4OWE4ZWNlY2FiNDIyYmEwZGVjMzdjOWU2NjU1MTcgPSBMLm1hcmtlcigKICAgICAgICAgICAgICAgIFs0MC4xNzA5OTgsIC0xMDUuMTYwODc2XSwKICAgICAgICAgICAgICAgIHt9CiAgICAgICAgICAgICkuYWRkVG8obWFya2VyX2NsdXN0ZXJfZmU0ZTFhZDc4OWU3NDZmMjk5OWRjMzQ4ZDZlNjQwMDMpOwogICAgICAgIAogICAgCiAgICAgICAgdmFyIHBvcHVwX2ZlNDgzMTcxYTZiNzQ2MzZhOGI2NDgwOGNiM2VlZWMwID0gTC5wb3B1cCh7Im1heFdpZHRoIjogIjEwMCUifSk7CgogICAgICAgIAogICAgICAgICAgICB2YXIgaHRtbF82NWZmZTZlNGY0MTQ0MTI0OGU0MDcwNTYxZWMxZmIxZCA9ICQoYDxkaXYgaWQ9Imh0bWxfNjVmZmU2ZTRmNDE0NDEyNDhlNDA3MDU2MWVjMWZiMWQiIHN0eWxlPSJ3aWR0aDogMTAwLjAlOyBoZWlnaHQ6IDEwMC4wJTsiPk5hbWU6IFNPVVRIIEZMQVQgRElUQ0ggUHJlY2lwOiAwLjM4PC9kaXY+YClbMF07CiAgICAgICAgICAgIHBvcHVwX2ZlNDgzMTcxYTZiNzQ2MzZhOGI2NDgwOGNiM2VlZWMwLnNldENvbnRlbnQoaHRtbF82NWZmZTZlNGY0MTQ0MTI0OGU0MDcwNTYxZWMxZmIxZCk7CiAgICAgICAgCgogICAgICAgIG1hcmtlcl9jYjg5YThlY2VjYWI0MjJiYTBkZWMzN2M5ZTY2NTUxNy5iaW5kUG9wdXAocG9wdXBfZmU0ODMxNzFhNmI3NDYzNmE4YjY0ODA4Y2IzZWVlYzApCiAgICAgICAgOwoKICAgICAgICAKICAgIAogICAgCiAgICAgICAgICAgIHZhciBtYXJrZXJfNWNiMmQ4MWJmNmZmNDAxMGEyN2M1M2Q2YjdkNmI3ZTEgPSBMLm1hcmtlcigKICAgICAgICAgICAgICAgIFs0MC4wNTE2NTIsIC0xMDUuMTc4ODc1XSwKICAgICAgICAgICAgICAgIHt9CiAgICAgICAgICAgICkuYWRkVG8obWFya2VyX2NsdXN0ZXJfZmU0ZTFhZDc4OWU3NDZmMjk5OWRjMzQ4ZDZlNjQwMDMpOwogICAgICAgIAogICAgCiAgICAgICAgdmFyIHBvcHVwX2RhNmE1NGZlYTU4YzRmYzdhNmQyZTlkOGZlYmY0MmM0ID0gTC5wb3B1cCh7Im1heFdpZHRoIjogIjEwMCUifSk7CgogICAgICAgIAogICAgICAgICAgICB2YXIgaHRtbF8yNTQyOTEzNjNiN2M0NDk2OTVlNzZjMTk2MzE3YmI5YSA9ICQoYDxkaXYgaWQ9Imh0bWxfMjU0MjkxMzYzYjdjNDQ5Njk1ZTc2YzE5NjMxN2JiOWEiIHN0eWxlPSJ3aWR0aDogMTAwLjAlOyBoZWlnaHQ6IDEwMC4wJTsiPk5hbWU6IEJPVUxERVIgQ1JFRUsgQVQgTk9SVEggNzVUSCBTVC4gTkVBUiBCT1VMREVSLCBDTyBQcmVjaXA6IDMxLjUwPC9kaXY+YClbMF07CiAgICAgICAgICAgIHBvcHVwX2RhNmE1NGZlYTU4YzRmYzdhNmQyZTlkOGZlYmY0MmM0LnNldENvbnRlbnQoaHRtbF8yNTQyOTEzNjNiN2M0NDk2OTVlNzZjMTk2MzE3YmI5YSk7CiAgICAgICAgCgogICAgICAgIG1hcmtlcl81Y2IyZDgxYmY2ZmY0MDEwYTI3YzUzZDZiN2Q2YjdlMS5iaW5kUG9wdXAocG9wdXBfZGE2YTU0ZmVhNThjNGZjN2E2ZDJlOWQ4ZmViZjQyYzQpCiAgICAgICAgOwoKICAgICAgICAKICAgIAogICAgCiAgICAgICAgICAgIHZhciBtYXJrZXJfY2M3MGU5MDA0MTE4NDU1OWFjNzUyZDQyMzk2MDlkNjAgPSBMLm1hcmtlcigKICAgICAgICAgICAgICAgIFszOS45MzE1OTcsIC0xMDUuMzA0OTldLAogICAgICAgICAgICAgICAge30KICAgICAgICAgICAgKS5hZGRUbyhtYXJrZXJfY2x1c3Rlcl9mZTRlMWFkNzg5ZTc0NmYyOTk5ZGMzNDhkNmU2NDAwMyk7CiAgICAgICAgCiAgICAKICAgICAgICB2YXIgcG9wdXBfYzA1MTlkM2QxN2FkNGVlM2I2NGVmMTdlNTZmNmIxOTQgPSBMLnBvcHVwKHsibWF4V2lkdGgiOiAiMTAwJSJ9KTsKCiAgICAgICAgCiAgICAgICAgICAgIHZhciBodG1sX2VjZDg3YzdmMzg3ODQwODU4ZDc1MjM4ZTBjMWQxMGExID0gJChgPGRpdiBpZD0iaHRtbF9lY2Q4N2M3ZjM4Nzg0MDg1OGQ3NTIzOGUwYzFkMTBhMSIgc3R5bGU9IndpZHRoOiAxMDAuMCU7IGhlaWdodDogMTAwLjAlOyI+TmFtZTogU09VVEggQk9VTERFUiBDUkVFSyBORUFSIEVMRE9SQURPIFNQUklOR1MsIENPLiBQcmVjaXA6IDE2LjAwPC9kaXY+YClbMF07CiAgICAgICAgICAgIHBvcHVwX2MwNTE5ZDNkMTdhZDRlZTNiNjRlZjE3ZTU2ZjZiMTk0LnNldENvbnRlbnQoaHRtbF9lY2Q4N2M3ZjM4Nzg0MDg1OGQ3NTIzOGUwYzFkMTBhMSk7CiAgICAgICAgCgogICAgICAgIG1hcmtlcl9jYzcwZTkwMDQxMTg0NTU5YWM3NTJkNDIzOTYwOWQ2MC5iaW5kUG9wdXAocG9wdXBfYzA1MTlkM2QxN2FkNGVlM2I2NGVmMTdlNTZmNmIxOTQpCiAgICAgICAgOwoKICAgICAgICAKICAgIAogICAgCiAgICAgICAgICAgIHZhciBtYXJrZXJfYmM3ZGQyZmIwOWI3NDcyMGJkOTU1NDJmZWMyMDE2OTMgPSBMLm1hcmtlcigKICAgICAgICAgICAgICAgIFs0MC4yNTc4NDQsIC0xMDUuMTY0Mzk3XSwKICAgICAgICAgICAgICAgIHt9CiAgICAgICAgICAgICkuYWRkVG8obWFya2VyX2NsdXN0ZXJfZmU0ZTFhZDc4OWU3NDZmMjk5OWRjMzQ4ZDZlNjQwMDMpOwogICAgICAgIAogICAgCiAgICAgICAgdmFyIHBvcHVwXzJmYzE2ZTdkM2Q5NjRlNWVhOWEyYzgyYTc5ZDljYTJmID0gTC5wb3B1cCh7Im1heFdpZHRoIjogIjEwMCUifSk7CgogICAgICAgIAogICAgICAgICAgICB2YXIgaHRtbF8xMmQyNDJlMzY4ZDI0MjNkOWQ5Yzk5ODFkMzY4Y2VjNSA9ICQoYDxkaXYgaWQ9Imh0bWxfMTJkMjQyZTM2OGQyNDIzZDlkOWM5OTgxZDM2OGNlYzUiIHN0eWxlPSJ3aWR0aDogMTAwLjAlOyBoZWlnaHQ6IDEwMC4wJTsiPk5hbWU6IEJMT1dFUiBESVRDSCBQcmVjaXA6IDAuMDE8L2Rpdj5gKVswXTsKICAgICAgICAgICAgcG9wdXBfMmZjMTZlN2QzZDk2NGU1ZWE5YTJjODJhNzlkOWNhMmYuc2V0Q29udGVudChodG1sXzEyZDI0MmUzNjhkMjQyM2Q5ZDljOTk4MWQzNjhjZWM1KTsKICAgICAgICAKCiAgICAgICAgbWFya2VyX2JjN2RkMmZiMDliNzQ3MjBiZDk1NTQyZmVjMjAxNjkzLmJpbmRQb3B1cChwb3B1cF8yZmMxNmU3ZDNkOTY0ZTVlYTlhMmM4MmE3OWQ5Y2EyZikKICAgICAgICA7CgogICAgICAgIAogICAgCiAgICAKICAgICAgICAgICAgdmFyIG1hcmtlcl81ZGQzZTY1OGRlNWM0OTZkYjQwYzM1OTk2NWUzZjZjZSA9IEwubWFya2VyKAogICAgICAgICAgICAgICAgWzQwLjI1NTc3NiwgLTEwNS4yMDk1XSwKICAgICAgICAgICAgICAgIHt9CiAgICAgICAgICAgICkuYWRkVG8obWFya2VyX2NsdXN0ZXJfZmU0ZTFhZDc4OWU3NDZmMjk5OWRjMzQ4ZDZlNjQwMDMpOwogICAgICAgIAogICAgCiAgICAgICAgdmFyIHBvcHVwXzk4ZWU5MmNjZWRmMjRlMmFhMzBlMWUxZmE4NWY0MDM0ID0gTC5wb3B1cCh7Im1heFdpZHRoIjogIjEwMCUifSk7CgogICAgICAgIAogICAgICAgICAgICB2YXIgaHRtbF9hMjI5ZWVjZTM5ZTY0MTdlOWI1OWU3OGUyNmE3Y2ViMCA9ICQoYDxkaXYgaWQ9Imh0bWxfYTIyOWVlY2UzOWU2NDE3ZTliNTllNzhlMjZhN2NlYjAiIHN0eWxlPSJ3aWR0aDogMTAwLjAlOyBoZWlnaHQ6IDEwMC4wJTsiPk5hbWU6IExJVFRMRSBUSE9NUFNPTiAjMiBESVRDSCBQcmVjaXA6IDAuMTA8L2Rpdj5gKVswXTsKICAgICAgICAgICAgcG9wdXBfOThlZTkyY2NlZGYyNGUyYWEzMGUxZTFmYTg1ZjQwMzQuc2V0Q29udGVudChodG1sX2EyMjllZWNlMzllNjQxN2U5YjU5ZTc4ZTI2YTdjZWIwKTsKICAgICAgICAKCiAgICAgICAgbWFya2VyXzVkZDNlNjU4ZGU1YzQ5NmRiNDBjMzU5OTY1ZTNmNmNlLmJpbmRQb3B1cChwb3B1cF85OGVlOTJjY2VkZjI0ZTJhYTMwZTFlMWZhODVmNDAzNCkKICAgICAgICA7CgogICAgICAgIAogICAgCiAgICAKICAgICAgICAgICAgdmFyIG1hcmtlcl8wNmRmODM2MGQxZjE0MTVmOTk3ZGUyNzlhNDhmZTcxZCA9IEwubWFya2VyKAogICAgICAgICAgICAgICAgWzQwLjIxNjI2MywgLTEwNS4zNjUzNjVdLAogICAgICAgICAgICAgICAge30KICAgICAgICAgICAgKS5hZGRUbyhtYXJrZXJfY2x1c3Rlcl9mZTRlMWFkNzg5ZTc0NmYyOTk5ZGMzNDhkNmU2NDAwMyk7CiAgICAgICAgCiAgICAKICAgICAgICB2YXIgcG9wdXBfNmQxOTRjYjI3MzI0NGVhZWEyMDg1MzZhZDNlY2Y4N2YgPSBMLnBvcHVwKHsibWF4V2lkdGgiOiAiMTAwJSJ9KTsKCiAgICAgICAgCiAgICAgICAgICAgIHZhciBodG1sXzMyY2EzOGQ0MTY5NDQ1NWY5ODhlNjgyYTFkZjM4Yjc2ID0gJChgPGRpdiBpZD0iaHRtbF8zMmNhMzhkNDE2OTQ0NTVmOTg4ZTY4MmExZGYzOGI3NiIgc3R5bGU9IndpZHRoOiAxMDAuMCU7IGhlaWdodDogMTAwLjAlOyI+TmFtZTogQlVUVE9OUk9DSyAoUkFMUEggUFJJQ0UpIFJFU0VSVk9JUiBQcmVjaXA6IDEyODkwLjAwPC9kaXY+YClbMF07CiAgICAgICAgICAgIHBvcHVwXzZkMTk0Y2IyNzMyNDRlYWVhMjA4NTM2YWQzZWNmODdmLnNldENvbnRlbnQoaHRtbF8zMmNhMzhkNDE2OTQ0NTVmOTg4ZTY4MmExZGYzOGI3Nik7CiAgICAgICAgCgogICAgICAgIG1hcmtlcl8wNmRmODM2MGQxZjE0MTVmOTk3ZGUyNzlhNDhmZTcxZC5iaW5kUG9wdXAocG9wdXBfNmQxOTRjYjI3MzI0NGVhZWEyMDg1MzZhZDNlY2Y4N2YpCiAgICAgICAgOwoKICAgICAgICAKICAgIAogICAgCiAgICAgICAgICAgIHZhciBtYXJrZXJfNzJhYWQxY2JlYjU0NGQzYTg5ZTUyMTFmYzc4ZDg2MjcgPSBMLm1hcmtlcigKICAgICAgICAgICAgICAgIFs0MC4wNTM2NjEsIC0xMDUuMTUxMTQzXSwKICAgICAgICAgICAgICAgIHt9CiAgICAgICAgICAgICkuYWRkVG8obWFya2VyX2NsdXN0ZXJfZmU0ZTFhZDc4OWU3NDZmMjk5OWRjMzQ4ZDZlNjQwMDMpOwogICAgICAgIAogICAgCiAgICAgICAgdmFyIHBvcHVwXzBlZjUyOTRmMzc1MTQ5NWI4OGY0YjE3NzI4MWI4YjE2ID0gTC5wb3B1cCh7Im1heFdpZHRoIjogIjEwMCUifSk7CgogICAgICAgIAogICAgICAgICAgICB2YXIgaHRtbF9kNGUxNTJhOGE0MGE0ZWQ1YjA2MmEzODgxOGY0ODIyNiA9ICQoYDxkaXYgaWQ9Imh0bWxfZDRlMTUyYThhNDBhNGVkNWIwNjJhMzg4MThmNDgyMjYiIHN0eWxlPSJ3aWR0aDogMTAwLjAlOyBoZWlnaHQ6IDEwMC4wJTsiPk5hbWU6IExFR0dFVFQgRElUQ0ggUHJlY2lwOiAyLjg0PC9kaXY+YClbMF07CiAgICAgICAgICAgIHBvcHVwXzBlZjUyOTRmMzc1MTQ5NWI4OGY0YjE3NzI4MWI4YjE2LnNldENvbnRlbnQoaHRtbF9kNGUxNTJhOGE0MGE0ZWQ1YjA2MmEzODgxOGY0ODIyNik7CiAgICAgICAgCgogICAgICAgIG1hcmtlcl83MmFhZDFjYmViNTQ0ZDNhODllNTIxMWZjNzhkODYyNy5iaW5kUG9wdXAocG9wdXBfMGVmNTI5NGYzNzUxNDk1Yjg4ZjRiMTc3MjgxYjhiMTYpCiAgICAgICAgOwoKICAgICAgICAKICAgIAogICAgCiAgICAgICAgICAgIHZhciBtYXJrZXJfNTJmZDAyYzU4NjAwNGU3MThlZjI5MjkzNTc4YTVkYTYgPSBMLm1hcmtlcigKICAgICAgICAgICAgICAgIFs0MC4xOTMyOCwgLTEwNS4yMTA0MjRdLAogICAgICAgICAgICAgICAge30KICAgICAgICAgICAgKS5hZGRUbyhtYXJrZXJfY2x1c3Rlcl9mZTRlMWFkNzg5ZTc0NmYyOTk5ZGMzNDhkNmU2NDAwMyk7CiAgICAgICAgCiAgICAKICAgICAgICB2YXIgcG9wdXBfODlkYTdkZTg1ZGU4NDZiNDhhNTMzMDZjZWM4MDMxZjYgPSBMLnBvcHVwKHsibWF4V2lkdGgiOiAiMTAwJSJ9KTsKCiAgICAgICAgCiAgICAgICAgICAgIHZhciBodG1sXzJiZjJkMzMyMzQ3MjRhOGNiMmIxOWE5YTRhYzE2NTZlID0gJChgPGRpdiBpZD0iaHRtbF8yYmYyZDMzMjM0NzI0YThjYjJiMTlhOWE0YWMxNjU2ZSIgc3R5bGU9IndpZHRoOiAxMDAuMCU7IGhlaWdodDogMTAwLjAlOyI+TmFtZTogV0VCU1RFUiBNQ0NBU0xJTiBESVRDSCBQcmVjaXA6IDAuMDA8L2Rpdj5gKVswXTsKICAgICAgICAgICAgcG9wdXBfODlkYTdkZTg1ZGU4NDZiNDhhNTMzMDZjZWM4MDMxZjYuc2V0Q29udGVudChodG1sXzJiZjJkMzMyMzQ3MjRhOGNiMmIxOWE5YTRhYzE2NTZlKTsKICAgICAgICAKCiAgICAgICAgbWFya2VyXzUyZmQwMmM1ODYwMDRlNzE4ZWYyOTI5MzU3OGE1ZGE2LmJpbmRQb3B1cChwb3B1cF84OWRhN2RlODVkZTg0NmI0OGE1MzMwNmNlYzgwMzFmNikKICAgICAgICA7CgogICAgICAgIAogICAgCiAgICAKICAgICAgICAgICAgdmFyIG1hcmtlcl8wMDQ4MzZmOWIzZjc0ODdkODVhNGM3ZGExN2FhOWUzZiA9IEwubWFya2VyKAogICAgICAgICAgICAgICAgWzQwLjE5OTMyMSwgLTEwNS4yMjI2MzldLAogICAgICAgICAgICAgICAge30KICAgICAgICAgICAgKS5hZGRUbyhtYXJrZXJfY2x1c3Rlcl9mZTRlMWFkNzg5ZTc0NmYyOTk5ZGMzNDhkNmU2NDAwMyk7CiAgICAgICAgCiAgICAKICAgICAgICB2YXIgcG9wdXBfZTQzOWYxOTQwZmM3NDg5Y2I4OGRlNDQ4ZDhkYWMwMzggPSBMLnBvcHVwKHsibWF4V2lkdGgiOiAiMTAwJSJ9KTsKCiAgICAgICAgCiAgICAgICAgICAgIHZhciBodG1sXzU3ZjEwMWMxOGMzNzQ1YjBiZDJlMTZiYmM0NGU4NzE1ID0gJChgPGRpdiBpZD0iaHRtbF81N2YxMDFjMThjMzc0NWIwYmQyZTE2YmJjNDRlODcxNSIgc3R5bGU9IndpZHRoOiAxMDAuMCU7IGhlaWdodDogMTAwLjAlOyI+TmFtZTogR09TUyBESVRDSCAxIFByZWNpcDogMC4wMDwvZGl2PmApWzBdOwogICAgICAgICAgICBwb3B1cF9lNDM5ZjE5NDBmYzc0ODljYjg4ZGU0NDhkOGRhYzAzOC5zZXRDb250ZW50KGh0bWxfNTdmMTAxYzE4YzM3NDViMGJkMmUxNmJiYzQ0ZTg3MTUpOwogICAgICAgIAoKICAgICAgICBtYXJrZXJfMDA0ODM2ZjliM2Y3NDg3ZDg1YTRjN2RhMTdhYTllM2YuYmluZFBvcHVwKHBvcHVwX2U0MzlmMTk0MGZjNzQ4OWNiODhkZTQ0OGQ4ZGFjMDM4KQogICAgICAgIDsKCiAgICAgICAgCiAgICAKICAgIAogICAgICAgICAgICB2YXIgbWFya2VyX2U0NTZhNWVjMjhkNDQ4OWY5ZDk0Y2MzZTM5NjU0MzZkID0gTC5tYXJrZXIoCiAgICAgICAgICAgICAgICBbNDAuMTYwNzA1LCAtMTA1LjE2ODQ3MV0sCiAgICAgICAgICAgICAgICB7fQogICAgICAgICAgICApLmFkZFRvKG1hcmtlcl9jbHVzdGVyX2ZlNGUxYWQ3ODllNzQ2ZjI5OTlkYzM0OGQ2ZTY0MDAzKTsKICAgICAgICAKICAgIAogICAgICAgIHZhciBwb3B1cF85YzkyYmEzZDI0NGM0YjhjYjc5MzI2NTU0NTkzMTI1MCA9IEwucG9wdXAoeyJtYXhXaWR0aCI6ICIxMDAlIn0pOwoKICAgICAgICAKICAgICAgICAgICAgdmFyIGh0bWxfOTI2ZGEwMjdmNGExNGE4YmFmMGE4N2IzOGM1ZThmMzggPSAkKGA8ZGl2IGlkPSJodG1sXzkyNmRhMDI3ZjRhMTRhOGJhZjBhODdiMzhjNWU4ZjM4IiBzdHlsZT0id2lkdGg6IDEwMC4wJTsgaGVpZ2h0OiAxMDAuMCU7Ij5OYW1lOiBQRUNLLVBFTExBIEFVR01FTlRBVElPTiBSRVRVUk4gUHJlY2lwOiAwLjAwPC9kaXY+YClbMF07CiAgICAgICAgICAgIHBvcHVwXzljOTJiYTNkMjQ0YzRiOGNiNzkzMjY1NTQ1OTMxMjUwLnNldENvbnRlbnQoaHRtbF85MjZkYTAyN2Y0YTE0YThiYWYwYTg3YjM4YzVlOGYzOCk7CiAgICAgICAgCgogICAgICAgIG1hcmtlcl9lNDU2YTVlYzI4ZDQ0ODlmOWQ5NGNjM2UzOTY1NDM2ZC5iaW5kUG9wdXAocG9wdXBfOWM5MmJhM2QyNDRjNGI4Y2I3OTMyNjU1NDU5MzEyNTApCiAgICAgICAgOwoKICAgICAgICAKICAgIAogICAgCiAgICAgICAgICAgIHZhciBtYXJrZXJfOWU2MDA3MjRhYjk1NDE5OGEwYjBlNWViOGNiMWI4YjEgPSBMLm1hcmtlcigKICAgICAgICAgICAgICAgIFszOS45ODYxNjksIC0xMDUuMjE4Njc3XSwKICAgICAgICAgICAgICAgIHt9CiAgICAgICAgICAgICkuYWRkVG8obWFya2VyX2NsdXN0ZXJfZmU0ZTFhZDc4OWU3NDZmMjk5OWRjMzQ4ZDZlNjQwMDMpOwogICAgICAgIAogICAgCiAgICAgICAgdmFyIHBvcHVwXzEyNmRhNjc2MjcyYjRjMzg5NGEwOWZiMmIzOWRlYTU2ID0gTC5wb3B1cCh7Im1heFdpZHRoIjogIjEwMCUifSk7CgogICAgICAgIAogICAgICAgICAgICB2YXIgaHRtbF9lZGQ2YjNlZDRhMzk0NzhkYmMwMDEwNjNmOWQ4ZDkwZCA9ICQoYDxkaXYgaWQ9Imh0bWxfZWRkNmIzZWQ0YTM5NDc4ZGJjMDAxMDYzZjlkOGQ5MGQiIHN0eWxlPSJ3aWR0aDogMTAwLjAlOyBoZWlnaHQ6IDEwMC4wJTsiPk5hbWU6IERSWSBDUkVFSyBDQVJSSUVSIFByZWNpcDogMC4wMDwvZGl2PmApWzBdOwogICAgICAgICAgICBwb3B1cF8xMjZkYTY3NjI3MmI0YzM4OTRhMDlmYjJiMzlkZWE1Ni5zZXRDb250ZW50KGh0bWxfZWRkNmIzZWQ0YTM5NDc4ZGJjMDAxMDYzZjlkOGQ5MGQpOwogICAgICAgIAoKICAgICAgICBtYXJrZXJfOWU2MDA3MjRhYjk1NDE5OGEwYjBlNWViOGNiMWI4YjEuYmluZFBvcHVwKHBvcHVwXzEyNmRhNjc2MjcyYjRjMzg5NGEwOWZiMmIzOWRlYTU2KQogICAgICAgIDsKCiAgICAgICAgCiAgICAKICAgIAogICAgICAgICAgICB2YXIgbWFya2VyXzMzMTAyYTgzMTU5MDRiNDhhYmQ2NGNjMjgyYTBjODA3ID0gTC5tYXJrZXIoCiAgICAgICAgICAgICAgICBbNDAuMTM0Mjc4LCAtMTA1LjEzMDgxOV0sCiAgICAgICAgICAgICAgICB7fQogICAgICAgICAgICApLmFkZFRvKG1hcmtlcl9jbHVzdGVyX2ZlNGUxYWQ3ODllNzQ2ZjI5OTlkYzM0OGQ2ZTY0MDAzKTsKICAgICAgICAKICAgIAogICAgICAgIHZhciBwb3B1cF9mZTM1N2Q0ZGM1MzI0ODdjODkwM2ExOTNhN2MzMTY5MSA9IEwucG9wdXAoeyJtYXhXaWR0aCI6ICIxMDAlIn0pOwoKICAgICAgICAKICAgICAgICAgICAgdmFyIGh0bWxfNTU0OGIwZDA1ZGRkNGZlZDliOGRiOWJmZWRkYmRhMTIgPSAkKGA8ZGl2IGlkPSJodG1sXzU1NDhiMGQwNWRkZDRmZWQ5YjhkYjliZmVkZGJkYTEyIiBzdHlsZT0id2lkdGg6IDEwMC4wJTsgaGVpZ2h0OiAxMDAuMCU7Ij5OYW1lOiBMRUZUIEhBTkQgQ1JFRUsgQVQgSE9WRVIgUk9BRCBORUFSIExPTkdNT05ULCBDTyBQcmVjaXA6IDMuMzQ8L2Rpdj5gKVswXTsKICAgICAgICAgICAgcG9wdXBfZmUzNTdkNGRjNTMyNDg3Yzg5MDNhMTkzYTdjMzE2OTEuc2V0Q29udGVudChodG1sXzU1NDhiMGQwNWRkZDRmZWQ5YjhkYjliZmVkZGJkYTEyKTsKICAgICAgICAKCiAgICAgICAgbWFya2VyXzMzMTAyYTgzMTU5MDRiNDhhYmQ2NGNjMjgyYTBjODA3LmJpbmRQb3B1cChwb3B1cF9mZTM1N2Q0ZGM1MzI0ODdjODkwM2ExOTNhN2MzMTY5MSkKICAgICAgICA7CgogICAgICAgIAogICAgCiAgICAKICAgICAgICAgICAgdmFyIG1hcmtlcl9lMGFjZWM4YmE3ODY0YzQ4YjFiMjNhNzlhMzE3ZjFlZCA9IEwubWFya2VyKAogICAgICAgICAgICAgICAgWzQwLjE3MjkyNSwgLTEwNS4xNjc2MjJdLAogICAgICAgICAgICAgICAge30KICAgICAgICAgICAgKS5hZGRUbyhtYXJrZXJfY2x1c3Rlcl9mZTRlMWFkNzg5ZTc0NmYyOTk5ZGMzNDhkNmU2NDAwMyk7CiAgICAgICAgCiAgICAKICAgICAgICB2YXIgcG9wdXBfN2E4YThkMTk1YzAwNDhjNzk3OTg1ZGJiNzQ1MWZlN2UgPSBMLnBvcHVwKHsibWF4V2lkdGgiOiAiMTAwJSJ9KTsKCiAgICAgICAgCiAgICAgICAgICAgIHZhciBodG1sX2E0N2RjOTU4ZDNmNDQ0ODliYjlmNmEzYjExN2Y1MDgyID0gJChgPGRpdiBpZD0iaHRtbF9hNDdkYzk1OGQzZjQ0NDg5YmI5ZjZhM2IxMTdmNTA4MiIgc3R5bGU9IndpZHRoOiAxMDAuMCU7IGhlaWdodDogMTAwLjAlOyI+TmFtZTogTk9SVEhXRVNUIE1VVFVBTCBESVRDSCBQcmVjaXA6IDAuMDA8L2Rpdj5gKVswXTsKICAgICAgICAgICAgcG9wdXBfN2E4YThkMTk1YzAwNDhjNzk3OTg1ZGJiNzQ1MWZlN2Uuc2V0Q29udGVudChodG1sX2E0N2RjOTU4ZDNmNDQ0ODliYjlmNmEzYjExN2Y1MDgyKTsKICAgICAgICAKCiAgICAgICAgbWFya2VyX2UwYWNlYzhiYTc4NjRjNDhiMWIyM2E3OWEzMTdmMWVkLmJpbmRQb3B1cChwb3B1cF83YThhOGQxOTVjMDA0OGM3OTc5ODVkYmI3NDUxZmU3ZSkKICAgICAgICA7CgogICAgICAgIAogICAgCiAgICAKICAgICAgICAgICAgdmFyIG1hcmtlcl81NzAzMjEzMmM1MzI0NDMyOGUxOGYyNDU2MjE1MGZkMyA9IEwubWFya2VyKAogICAgICAgICAgICAgICAgWzQwLjIwNDE5MywgLTEwNS4yMTg3NzddLAogICAgICAgICAgICAgICAge30KICAgICAgICAgICAgKS5hZGRUbyhtYXJrZXJfY2x1c3Rlcl9mZTRlMWFkNzg5ZTc0NmYyOTk5ZGMzNDhkNmU2NDAwMyk7CiAgICAgICAgCiAgICAKICAgICAgICB2YXIgcG9wdXBfMzdlYmVhYTQ1MWJjNGZmNjk2MGMxZjc1ZDk1MjA2ZWQgPSBMLnBvcHVwKHsibWF4V2lkdGgiOiAiMTAwJSJ9KTsKCiAgICAgICAgCiAgICAgICAgICAgIHZhciBodG1sXzNiODM2ZGY5ZWJkYzQyOTliMzQxODc5ZWFiNGFlMjNhID0gJChgPGRpdiBpZD0iaHRtbF8zYjgzNmRmOWViZGM0Mjk5YjM0MTg3OWVhYjRhZTIzYSIgc3R5bGU9IndpZHRoOiAxMDAuMCU7IGhlaWdodDogMTAwLjAlOyI+TmFtZTogTE9OR01PTlQgU1VQUExZIERJVENIIFByZWNpcDogMC4wMDwvZGl2PmApWzBdOwogICAgICAgICAgICBwb3B1cF8zN2ViZWFhNDUxYmM0ZmY2OTYwYzFmNzVkOTUyMDZlZC5zZXRDb250ZW50KGh0bWxfM2I4MzZkZjllYmRjNDI5OWIzNDE4NzllYWI0YWUyM2EpOwogICAgICAgIAoKICAgICAgICBtYXJrZXJfNTcwMzIxMzJjNTMyNDQzMjhlMThmMjQ1NjIxNTBmZDMuYmluZFBvcHVwKHBvcHVwXzM3ZWJlYWE0NTFiYzRmZjY5NjBjMWY3NWQ5NTIwNmVkKQogICAgICAgIDsKCiAgICAgICAgCiAgICAKICAgIAogICAgICAgICAgICB2YXIgbWFya2VyXzc3ZDVkZDBkZTllNTQ3MzFiYmJkZTNhZGIzNmYwODUyID0gTC5tYXJrZXIoCiAgICAgICAgICAgICAgICBbNDAuMDA2MzgsIC0xMDUuMzMwODQxXSwKICAgICAgICAgICAgICAgIHt9CiAgICAgICAgICAgICkuYWRkVG8obWFya2VyX2NsdXN0ZXJfZmU0ZTFhZDc4OWU3NDZmMjk5OWRjMzQ4ZDZlNjQwMDMpOwogICAgICAgIAogICAgCiAgICAgICAgdmFyIHBvcHVwX2JlMjQ3MGVhYjE4NTRkZWY5ODNiMDQ5MGQwZTI4Y2NkID0gTC5wb3B1cCh7Im1heFdpZHRoIjogIjEwMCUifSk7CgogICAgICAgIAogICAgICAgICAgICB2YXIgaHRtbF82ZjQwMmZiZDU0MTc0ZTZlOTU1ZWViM2VlN2NjOGVkMSA9ICQoYDxkaXYgaWQ9Imh0bWxfNmY0MDJmYmQ1NDE3NGU2ZTk1NWVlYjNlZTdjYzhlZDEiIHN0eWxlPSJ3aWR0aDogMTAwLjAlOyBoZWlnaHQ6IDEwMC4wJTsiPk5hbWU6IEJPVUxERVIgQ1JFRUsgTkVBUiBPUk9ERUxMLCBDTy4gUHJlY2lwOiAxOS42MDwvZGl2PmApWzBdOwogICAgICAgICAgICBwb3B1cF9iZTI0NzBlYWIxODU0ZGVmOTgzYjA0OTBkMGUyOGNjZC5zZXRDb250ZW50KGh0bWxfNmY0MDJmYmQ1NDE3NGU2ZTk1NWVlYjNlZTdjYzhlZDEpOwogICAgICAgIAoKICAgICAgICBtYXJrZXJfNzdkNWRkMGRlOWU1NDczMWJiYmRlM2FkYjM2ZjA4NTIuYmluZFBvcHVwKHBvcHVwX2JlMjQ3MGVhYjE4NTRkZWY5ODNiMDQ5MGQwZTI4Y2NkKQogICAgICAgIDsKCiAgICAgICAgCiAgICAKICAgIAogICAgICAgICAgICB2YXIgbWFya2VyXzEyMWE2MTBmZTg3YTRmYzliNjc0ZmZhMDFmY2FlNzI2ID0gTC5tYXJrZXIoCiAgICAgICAgICAgICAgICBbNDAuMTkzNzU4LCAtMTA1LjIxMDM5XSwKICAgICAgICAgICAgICAgIHt9CiAgICAgICAgICAgICkuYWRkVG8obWFya2VyX2NsdXN0ZXJfZmU0ZTFhZDc4OWU3NDZmMjk5OWRjMzQ4ZDZlNjQwMDMpOwogICAgICAgIAogICAgCiAgICAgICAgdmFyIHBvcHVwXzM1ZGVmMWM1OTZlYzQ0MDg4YzI1ZjFjODBlZmY1M2RiID0gTC5wb3B1cCh7Im1heFdpZHRoIjogIjEwMCUifSk7CgogICAgICAgIAogICAgICAgICAgICB2YXIgaHRtbF8zZTg4NDBjNmI5Mjg0MGM5YTJmYzY4YWE4ZWM4ODc1YiA9ICQoYDxkaXYgaWQ9Imh0bWxfM2U4ODQwYzZiOTI4NDBjOWEyZmM2OGFhOGVjODg3NWIiIHN0eWxlPSJ3aWR0aDogMTAwLjAlOyBoZWlnaHQ6IDEwMC4wJTsiPk5hbWU6IENMT1VHSCBBTkQgVFJVRSBESVRDSCBQcmVjaXA6IDAuMDA8L2Rpdj5gKVswXTsKICAgICAgICAgICAgcG9wdXBfMzVkZWYxYzU5NmVjNDQwODhjMjVmMWM4MGVmZjUzZGIuc2V0Q29udGVudChodG1sXzNlODg0MGM2YjkyODQwYzlhMmZjNjhhYThlYzg4NzViKTsKICAgICAgICAKCiAgICAgICAgbWFya2VyXzEyMWE2MTBmZTg3YTRmYzliNjc0ZmZhMDFmY2FlNzI2LmJpbmRQb3B1cChwb3B1cF8zNWRlZjFjNTk2ZWM0NDA4OGMyNWYxYzgwZWZmNTNkYikKICAgICAgICA7CgogICAgICAgIAogICAgCiAgICAKICAgICAgICAgICAgdmFyIG1hcmtlcl8zMTZkNDQ4YTIzMmM0MzI5ODUyY2Y5OWY2MDE2MThmYyA9IEwubWFya2VyKAogICAgICAgICAgICAgICAgWzM5LjkzMTgxMywgLTEwNS4zMDg0MzJdLAogICAgICAgICAgICAgICAge30KICAgICAgICAgICAgKS5hZGRUbyhtYXJrZXJfY2x1c3Rlcl9mZTRlMWFkNzg5ZTc0NmYyOTk5ZGMzNDhkNmU2NDAwMyk7CiAgICAgICAgCiAgICAKICAgICAgICB2YXIgcG9wdXBfNmM1YTU2MDVmNDZjNDlkZWFiNzhhMTZmMjZmYzNjY2MgPSBMLnBvcHVwKHsibWF4V2lkdGgiOiAiMTAwJSJ9KTsKCiAgICAgICAgCiAgICAgICAgICAgIHZhciBodG1sXzFkYTI2NDY4ODdiNzQwYzNhZDc5MTdjYmQ3YzQ4MGUzID0gJChgPGRpdiBpZD0iaHRtbF8xZGEyNjQ2ODg3Yjc0MGMzYWQ3OTE3Y2JkN2M0ODBlMyIgc3R5bGU9IndpZHRoOiAxMDAuMCU7IGhlaWdodDogMTAwLjAlOyI+TmFtZTogU09VVEggQk9VTERFUiBDUkVFSyBESVZFUlNJT04gTkVBUiBFTERPUkFETyBTUFJJTkdTIFByZWNpcDogMC4wMDwvZGl2PmApWzBdOwogICAgICAgICAgICBwb3B1cF82YzVhNTYwNWY0NmM0OWRlYWI3OGExNmYyNmZjM2NjYy5zZXRDb250ZW50KGh0bWxfMWRhMjY0Njg4N2I3NDBjM2FkNzkxN2NiZDdjNDgwZTMpOwogICAgICAgIAoKICAgICAgICBtYXJrZXJfMzE2ZDQ0OGEyMzJjNDMyOTg1MmNmOTlmNjAxNjE4ZmMuYmluZFBvcHVwKHBvcHVwXzZjNWE1NjA1ZjQ2YzQ5ZGVhYjc4YTE2ZjI2ZmMzY2NjKQogICAgICAgIDsKCiAgICAgICAgCiAgICAKICAgIAogICAgICAgICAgICB2YXIgbWFya2VyXzNkMzE2YmE4YjVjZTQyNDRiZTgwNWQ5MTUyNDhiZWFhID0gTC5tYXJrZXIoCiAgICAgICAgICAgICAgICBbNDAuMTk2NDIyLCAtMTA1LjIwNjU5Ml0sCiAgICAgICAgICAgICAgICB7fQogICAgICAgICAgICApLmFkZFRvKG1hcmtlcl9jbHVzdGVyX2ZlNGUxYWQ3ODllNzQ2ZjI5OTlkYzM0OGQ2ZTY0MDAzKTsKICAgICAgICAKICAgIAogICAgICAgIHZhciBwb3B1cF9hMjMzYjU3NWM5MzE0ZDJhOGM5NTU0ZjA1OThlMWVjOSA9IEwucG9wdXAoeyJtYXhXaWR0aCI6ICIxMDAlIn0pOwoKICAgICAgICAKICAgICAgICAgICAgdmFyIGh0bWxfODQ5ZmU2ZTNlY2E4NDk2OWJjMTMyMzE4ZDZjOTkxYzEgPSAkKGA8ZGl2IGlkPSJodG1sXzg0OWZlNmUzZWNhODQ5NjliYzEzMjMxOGQ2Yzk5MWMxIiBzdHlsZT0id2lkdGg6IDEwMC4wJTsgaGVpZ2h0OiAxMDAuMCU7Ij5OYW1lOiBPTElHQVJDSFkgRElUQ0ggRElWRVJTSU9OIFByZWNpcDogMy43NTwvZGl2PmApWzBdOwogICAgICAgICAgICBwb3B1cF9hMjMzYjU3NWM5MzE0ZDJhOGM5NTU0ZjA1OThlMWVjOS5zZXRDb250ZW50KGh0bWxfODQ5ZmU2ZTNlY2E4NDk2OWJjMTMyMzE4ZDZjOTkxYzEpOwogICAgICAgIAoKICAgICAgICBtYXJrZXJfM2QzMTZiYThiNWNlNDI0NGJlODA1ZDkxNTI0OGJlYWEuYmluZFBvcHVwKHBvcHVwX2EyMzNiNTc1YzkzMTRkMmE4Yzk1NTRmMDU5OGUxZWM5KQogICAgICAgIDsKCiAgICAgICAgCiAgICAKICAgIAogICAgICAgICAgICB2YXIgbWFya2VyX2I0ZTUwMWQ3MjYxMjQzMTk5YzFmMjY5MGY4ZjQxMzIyID0gTC5tYXJrZXIoCiAgICAgICAgICAgICAgICBbNDAuMjIwNzAyLCAtMTA1LjI2MzQ5XSwKICAgICAgICAgICAgICAgIHt9CiAgICAgICAgICAgICkuYWRkVG8obWFya2VyX2NsdXN0ZXJfZmU0ZTFhZDc4OWU3NDZmMjk5OWRjMzQ4ZDZlNjQwMDMpOwogICAgICAgIAogICAgCiAgICAgICAgdmFyIHBvcHVwXzhjZWU1YzEwY2EyNTQwYzc5MjQ1Mzc3MTg5YWZmOWNjID0gTC5wb3B1cCh7Im1heFdpZHRoIjogIjEwMCUifSk7CgogICAgICAgIAogICAgICAgICAgICB2YXIgaHRtbF9jNGJiZTVlZDNmMmE0NWZlYWJiYTFmMTBmZTc3NzAzOSA9ICQoYDxkaXYgaWQ9Imh0bWxfYzRiYmU1ZWQzZjJhNDVmZWFiYmExZjEwZmU3NzcwMzkiIHN0eWxlPSJ3aWR0aDogMTAwLjAlOyBoZWlnaHQ6IDEwMC4wJTsiPk5hbWU6IFNBSU5UIFZSQUlOIENSRUVLIEFUIExZT05TLCBDTyBQcmVjaXA6IDQwLjUwPC9kaXY+YClbMF07CiAgICAgICAgICAgIHBvcHVwXzhjZWU1YzEwY2EyNTQwYzc5MjQ1Mzc3MTg5YWZmOWNjLnNldENvbnRlbnQoaHRtbF9jNGJiZTVlZDNmMmE0NWZlYWJiYTFmMTBmZTc3NzAzOSk7CiAgICAgICAgCgogICAgICAgIG1hcmtlcl9iNGU1MDFkNzI2MTI0MzE5OWMxZjI2OTBmOGY0MTMyMi5iaW5kUG9wdXAocG9wdXBfOGNlZTVjMTBjYTI1NDBjNzkyNDUzNzcxODlhZmY5Y2MpCiAgICAgICAgOwoKICAgICAgICAKICAgIAogICAgCiAgICAgICAgICAgIHZhciBtYXJrZXJfZThmOGZiYzUxYTVjNGQ0Y2IwMzcwMzE4Njc5MGJhZTQgPSBMLm1hcmtlcigKICAgICAgICAgICAgICAgIFs0MC4xODUwMzMsIC0xMDUuMTg1Nzg5XSwKICAgICAgICAgICAgICAgIHt9CiAgICAgICAgICAgICkuYWRkVG8obWFya2VyX2NsdXN0ZXJfZmU0ZTFhZDc4OWU3NDZmMjk5OWRjMzQ4ZDZlNjQwMDMpOwogICAgICAgIAogICAgCiAgICAgICAgdmFyIHBvcHVwXzY4ZjRlMjYyN2UzOTQ2MmJhZmNjNDNhOWFkM2VlZTNhID0gTC5wb3B1cCh7Im1heFdpZHRoIjogIjEwMCUifSk7CgogICAgICAgIAogICAgICAgICAgICB2YXIgaHRtbF9mMzUyMjU4NGU0YzQ0OTY3YTAxODFlYjg2ZDE3Y2EyOSA9ICQoYDxkaXYgaWQ9Imh0bWxfZjM1MjI1ODRlNGM0NDk2N2EwMTgxZWI4NmQxN2NhMjkiIHN0eWxlPSJ3aWR0aDogMTAwLjAlOyBoZWlnaHQ6IDEwMC4wJTsiPk5hbWU6IFpXRUNLIEFORCBUVVJORVIgRElUQ0ggUHJlY2lwOiAwLjE0PC9kaXY+YClbMF07CiAgICAgICAgICAgIHBvcHVwXzY4ZjRlMjYyN2UzOTQ2MmJhZmNjNDNhOWFkM2VlZTNhLnNldENvbnRlbnQoaHRtbF9mMzUyMjU4NGU0YzQ0OTY3YTAxODFlYjg2ZDE3Y2EyOSk7CiAgICAgICAgCgogICAgICAgIG1hcmtlcl9lOGY4ZmJjNTFhNWM0ZDRjYjAzNzAzMTg2NzkwYmFlNC5iaW5kUG9wdXAocG9wdXBfNjhmNGUyNjI3ZTM5NDYyYmFmY2M0M2E5YWQzZWVlM2EpCiAgICAgICAgOwoKICAgICAgICAKICAgIAo8L3NjcmlwdD4=" style="position:absolute;width:100%;height:100%;left:0;top:0;border:none !important;" allowfullscreen webkitallowfullscreen mozallowfullscreen></iframe></div></div>





<div class="notice--info" markdown="1">

## Additional Resources

* <a href="https://blog.datafiniti.co/4-reasons-you-should-use-json-instead-of-csv-2cac362f1943" target="_blank">Why you should use JSON instead of csv.</a>


* <a href="https://www.w3schools.com/js/js_json_intro.asp" target="_blank">W3schools JSON intro </a>

</div>

