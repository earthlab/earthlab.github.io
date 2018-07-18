---
layout: single
category: [courses]
title: "How to Dissolve Polygons Using Geopandas: GIS in Python"
excerpt: "In this lesson you review how to dissolve polygons in python. A spatial join is when you assign attributes from one shapefile to another based upon its spatial location."
authors: ['Leah Wasser']
modified: 2018-07-18
module-type: 'workshop'
module: "spatial-data-open-source-python"
permalink: /workshops/gis-open-source-python/dissolve-polygons-in-python-geopandas-shapely/
nav-title: 'Dissolve Polygons'
sidebar:
  nav:
author_profile: false
comments: true
order: 6
---
{% include toc title="In This Lesson" icon="file-text" %}

<div class='notice--success' markdown="1">

## <i class="fa fa-graduation-cap" aria-hidden="true"></i> Learning Objectives

After completing this tutorial, you will be able to:

* 

## <i class="fa fa-check-square-o fa-2" aria-hidden="true"></i> What You Need

You will need a computer with internet access to complete this lesson and the
spatial-vector-lidar data subset created for the course.

[<i class="fa fa-download" aria-hidden="true"></i> Download spatial-vector-lidar data subset (~172 MB)](https://ndownloader.figshare.com/files/12447845){:data-proofer-ignore='' .btn }

</div>


Get started by loading your libraries. And be sure that your working directory is set. 

{:.input}
```python
# import libraries
import os
import numpy as np
import geopandas as gpd
import matplotlib.pyplot as plt
import matplotlib.lines as mlines
from matplotlib.colors import ListedColormap
import earthpy as et 
# make figures plot inline
plt.ion()
# load the box module from shapely
from shapely.geometry import box
```

{:.input}
```python
country_boundary_us = gpd.read_file('data/spatial-vector-lidar/usa/usa-boundary-dissolved.shp')
state_boundary_us = gpd.read_file('data/spatial-vector-lidar/usa/usa-states-census-2014.shp')
pop_places = gpd.read_file('data/spatial-vector-lidar/global/ne_110m_populated_places_simple/ne_110m_populated_places_simple.shp')
ne_roads = gpd.read_file('data/spatial-vector-lidar/global/ne_10m_roads/ne_10m_roads.shp')

```

{:.input}
```python
# clip the roads to the US (this is what we did in the previous lesson)
na_roads = ne_roads[ne_roads['continent'] == "North America"]
# than the entire road segments unclipped
us_roads = ne_roads.intersection(country_boundary_us.geometry[0])
valid_geom = us_roads.geometry.notnull()
us_roads_only = ne_roads.loc[valid_geom].set_geometry(us_roads.geometry[valid_geom])
```

{:.input}
```python
f, ax = plt.subplots(figsize = (10,6))
us_roads_only.plot(ax=ax)
country_boundary_us.plot(ax=ax, 
                         facecolor = 'none',
                         edgecolor = "black", 
                         zorder = 10)
ax.set_axis_off()
plt.axis('equal');
```

{:.output}
{:.display_data}

![png]({{ site.url }}//images/workshops/spatial-data-python-intro/2018-07-20-spatial-06-dissolve-polygons-python_5_0.png)




{:.input}
```python
us_roads_only.head()
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
      <th>scalerank</th>
      <th>featurecla</th>
      <th>type</th>
      <th>sov_a3</th>
      <th>note</th>
      <th>edited</th>
      <th>name</th>
      <th>namealt</th>
      <th>namealtt</th>
      <th>routeraw</th>
      <th>...</th>
      <th>rwdb_rd_id</th>
      <th>orig_fid</th>
      <th>prefix</th>
      <th>uident</th>
      <th>continent</th>
      <th>expressway</th>
      <th>level</th>
      <th>min_zoom</th>
      <th>min_label</th>
      <th>geometry</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>1</th>
      <td>7</td>
      <td>Road</td>
      <td>Secondary Highway</td>
      <td>USA</td>
      <td></td>
      <td>Version 1.5: Changed alignment, a few adds in ...</td>
      <td>83</td>
      <td></td>
      <td></td>
      <td></td>
      <td>...</td>
      <td>0</td>
      <td>0</td>
      <td></td>
      <td>108105</td>
      <td>North America</td>
      <td>0</td>
      <td>Federal</td>
      <td>7.0</td>
      <td>8.6</td>
      <td>LINESTRING Z (-100.5054284631781 42.8075293067...</td>
    </tr>
    <tr>
      <th>2</th>
      <td>7</td>
      <td>Road</td>
      <td>Secondary Highway</td>
      <td>USA</td>
      <td></td>
      <td>Version 1.5: Changed alignment, a few adds in ...</td>
      <td>840</td>
      <td></td>
      <td></td>
      <td></td>
      <td>...</td>
      <td>0</td>
      <td>0</td>
      <td></td>
      <td>0</td>
      <td>North America</td>
      <td>0</td>
      <td>U/C</td>
      <td>7.0</td>
      <td>9.5</td>
      <td>LINESTRING Z (-87.27431503977813 36.0243912267...</td>
    </tr>
    <tr>
      <th>3</th>
      <td>8</td>
      <td>Road</td>
      <td>Secondary Highway</td>
      <td>USA</td>
      <td></td>
      <td>Version 1.5: Changed alignment, a few adds in ...</td>
      <td>151</td>
      <td></td>
      <td></td>
      <td></td>
      <td>...</td>
      <td>0</td>
      <td>0</td>
      <td></td>
      <td>0</td>
      <td>North America</td>
      <td>0</td>
      <td>Federal</td>
      <td>7.1</td>
      <td>9.6</td>
      <td>LINESTRING Z (-87.72756620180824 44.1516534424...</td>
    </tr>
    <tr>
      <th>4</th>
      <td>6</td>
      <td>Road</td>
      <td>Major Highway</td>
      <td>USA</td>
      <td></td>
      <td>Version 1.5: Changed alignment, a few adds in ...</td>
      <td>GSP</td>
      <td></td>
      <td></td>
      <td></td>
      <td>...</td>
      <td>0</td>
      <td>0</td>
      <td></td>
      <td>311305</td>
      <td>North America</td>
      <td>1</td>
      <td>State</td>
      <td>6.0</td>
      <td>8.5</td>
      <td>(LINESTRING Z (-74.75920259253698 39.143013260...</td>
    </tr>
    <tr>
      <th>6</th>
      <td>8</td>
      <td>Road</td>
      <td>Secondary Highway</td>
      <td>USA</td>
      <td></td>
      <td>Version 1.5: Changed alignment, a few adds in ...</td>
      <td>85</td>
      <td></td>
      <td></td>
      <td></td>
      <td>...</td>
      <td>0</td>
      <td>0</td>
      <td></td>
      <td>81005</td>
      <td>North America</td>
      <td>0</td>
      <td>Federal</td>
      <td>7.1</td>
      <td>9.0</td>
      <td>LINESTRING Z (-104.4509711456777 42.7571680665...</td>
    </tr>
  </tbody>
</table>
<p>5 rows × 32 columns</p>
</div>





## Dissolve Polygons Based On an Attribute with Geopandas
Next, you will learn how to dissolve polygon data. Dissolving polygons entails combining polygons based upon a unique attribute value and removing the interior geometry. 

<figure>
 <a href="{{ site.url }}/images/courses/earth-analytics/spatial-data/dissolve-polygons-esri.gif">
 <img src="{{ site.url }}/images/courses/earth-analytics/spatial-data/dissolve-polygons-esri.gif"></a>
 <figcaption> When you dissolve polygons you remove interior boundaries of a set of polygons with the same attribute value and create one new "merged" or combined polygon for each attribute value. In the case above US states are dissolved to regions in the United States. Source: ESRI
 </figcaption>
</figure>

Below you will dissolve the US states polygons by the region that each state is in. When you dissolve, you will create a new set polygons - one for each regions in the United States.

To begin, explore your data. Using `.geom_type` you can see that you have a mix of single and multi polygons in your data. Sometimes multi-polygons can cause problems when processing. It's always good to check your geometry before you begin to better know what you are working with. 

{:.input}
```python
state_boundary_us.geom_type.head()
```

{:.output}
{:.execute_result}



    0    MultiPolygon
    1         Polygon
    2    MultiPolygon
    3         Polygon
    4         Polygon
    dtype: object





Next, select the columns that you with to use for the dissolve and keep. In this case we want to retain the 

* region 
* geometry

columns. 

{:.input}
```python
state_boundary = state_boundary_us[['region', 'geometry']]
us_regions = state_boundary.dissolve(by='region')
# view the resulting geodataframe
us_regions
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
      <th>geometry</th>
    </tr>
    <tr>
      <th>region</th>
      <th></th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>Midwest</th>
      <td>(POLYGON Z ((-82.863342 41.693693 0, -82.82571...</td>
    </tr>
    <tr>
      <th>Northeast</th>
      <td>(POLYGON Z ((-76.04621299999999 38.025533 0, -...</td>
    </tr>
    <tr>
      <th>Southeast</th>
      <td>(POLYGON Z ((-81.81169299999999 24.568745 0, -...</td>
    </tr>
    <tr>
      <th>Southwest</th>
      <td>POLYGON Z ((-94.48587499999999 33.637867 0, -9...</td>
    </tr>
    <tr>
      <th>West</th>
      <td>(POLYGON Z ((-118.594033 33.035951 0, -118.540...</td>
    </tr>
  </tbody>
</table>
</div>





And finally, plot the data. Note that when you dissolve, the column used to perform the dissolve becomes an index for the resultant geodataframe. Thus you will have to use the reset_index() method when you plot, to access the region "column". 

So this will work:

`us_regions.reset_index().plot(column = 'region', ax=ax)`

This will return an error as region is no longer a column, it is an index!
`us_regions.plot(column = 'region', ax=ax)`

{:.input}
```python
us_regions.reset_index
```

{:.output}
{:.execute_result}



    <bound method DataFrame.reset_index of                                                     geometry
    region                                                      
    Midwest    (POLYGON Z ((-82.863342 41.693693 0, -82.82571...
    Northeast  (POLYGON Z ((-76.04621299999999 38.025533 0, -...
    Southeast  (POLYGON Z ((-81.81169299999999 24.568745 0, -...
    Southwest  POLYGON Z ((-94.48587499999999 33.637867 0, -9...
    West       (POLYGON Z ((-118.594033 33.035951 0, -118.540...>





{:.input}
```python
# plot the data
fig, ax = plt.subplots(figsize = (10,6))
us_regions.reset_index().plot(column = 'region', ax=ax)
ax.set_axis_off()
plt.axis('equal');
```

{:.output}
{:.display_data}

![png]({{ site.url }}//images/workshops/spatial-data-python-intro/2018-07-20-spatial-06-dissolve-polygons-python_13_0.png)




## Dissolve and Aggregate Data

In the example above, you dissolved the state level polygons to a region level. However you did not aggregate or summarize the attributes associated with each polygon. Next, you will learn how to aggregate quantitative values in your attribute table when you perform a dissolve. To do this, you will add 

`aggfunc = 'fun-here'`

to your dissolve call. You can choice a suite of different summary functions including:

* first
* last
* mean
* max

And more. <a href = "http://geopandas.org/aggregation_with_dissolve.html" target = "_blank">Read more about the dissolve function here.</a> 

Below the data are aggregated by the 'sum' method. this means that the values for ALAND are added up for all of the states in a region. That summary sum value will be returned in the new dataframe. 

{:.input}
```python
# select the columns that you wish to retain in the data
state_boundary = state_boundary_us[['region', 'geometry', 'ALAND', 'AWATER']]
# then summarize the quantative columns by 'sum' 
regions_agg = state_boundary.dissolve(by='region', aggfunc = 'sum')
regions_agg
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
      <th>geometry</th>
      <th>ALAND</th>
      <th>AWATER</th>
    </tr>
    <tr>
      <th>region</th>
      <th></th>
      <th></th>
      <th></th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>Midwest</th>
      <td>(POLYGON Z ((-82.863342 41.693693 0, -82.82571...</td>
      <td>1943869253244</td>
      <td>184383393833</td>
    </tr>
    <tr>
      <th>Northeast</th>
      <td>(POLYGON Z ((-76.04621299999999 38.025533 0, -...</td>
      <td>869066138232</td>
      <td>108922434345</td>
    </tr>
    <tr>
      <th>Southeast</th>
      <td>(POLYGON Z ((-81.81169299999999 24.568745 0, -...</td>
      <td>1364632039655</td>
      <td>103876652998</td>
    </tr>
    <tr>
      <th>Southwest</th>
      <td>POLYGON Z ((-94.48587499999999 33.637867 0, -9...</td>
      <td>1462631530997</td>
      <td>24217682268</td>
    </tr>
    <tr>
      <th>West</th>
      <td>(POLYGON Z ((-118.594033 33.035951 0, -118.540...</td>
      <td>2432336444730</td>
      <td>57568049509</td>
    </tr>
  </tbody>
</table>
</div>





{:.input}
```python
fig, ax = plt.subplots(figsize = (12,8))
regions_agg.plot(column = 'ALAND', edgecolor = "black",
                 scheme='quantiles', cmap='YlOrRd', ax=ax, 
                 legend = True)
ax.set_axis_off()
plt.axis('equal');
```

{:.output}
{:.display_data}

![png]({{ site.url }}//images/workshops/spatial-data-python-intro/2018-07-20-spatial-06-dissolve-polygons-python_16_0.png)




* http://darribas.org/gds16/content/labs/lab_02.html
