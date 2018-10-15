---
layout: single
title: "How to Dissolve Polygons Using Geopandas: GIS in Python"
excerpt: "In this lesson you review how to dissolve polygons in python. A spatial join is when you assign attributes from one shapefile to another based upon its spatial location."
authors: ['Leah Wasser']
modified: 2018-10-08
category: [courses]
class-lesson: ['class-intro-spatial-python']
permalink: /courses/earth-analytics-python/spatial-data-vector-shapefiles/dissolve-polygons-in-python-geopandas-shapely/
nav-title: 'Dissolve Polygons'
course: 'earth-analytics-python'
week: 4
sidebar:
  nav:
author_profile: false
comments: true
order: 7
---
{% include toc title="In This Lesson" icon="file-text" %}

<div class='notice--success' markdown="1">

## <i class="fa fa-graduation-cap" aria-hidden="true"></i> Learning Objectives

After completing this tutorial, you will be able to:

* Dissolve polygons based upon an attribute using `geopandas` in `Python`.

## <i class="fa fa-check-square-o fa-2" aria-hidden="true"></i> What You Need

You will need a computer with internet access to complete this lesson and the
spatial-vector-lidar data subset created for the course.

{% include/data_subsets/course_earth_analytics/_data-spatial-lidar.md %}


</div>


Get started by loading your libraries. And be sure that your working directory is set. 

{:.input}
```python
# import libraries
import os
import numpy as np
import matplotlib.pyplot as plt
import matplotlib.lines as mlines
from matplotlib.colors import ListedColormap
import geopandas as gpd
import earthpy as et
from shapely.geometry import box

plt.ion()

os.chdir(os.path.join(et.io.HOME, 'earth-analytics'))
```

## Import Data

To begin, import the following foud shapefiles using `geopandas`. 

{:.input}
```python
# Define base path as it is repeated below
base_path = os.path.join("data", "spatial-vector-lidar")

# Define file paths
country_boundary_path = base_path + "/usa/usa-boundary-dissolved.shp"
state_boundary_path = base_path + "/usa/usa-states-census-2014.shp"
pop_places_path = base_path + \
    "/global/ne_110m_populated_places_simple/ne_110m_populated_places_simple.shp"

# Import the data
country_boundary_us = gpd.read_file(country_boundary_path)
state_boundary_us = gpd.read_file(state_boundary_path)
pop_places = gpd.read_file(pop_places_path)
```

## Dissolve Polygons Based On an Attribute with Geopandas
Next, you will learn how to dissolve polygon data. Dissolving polygons entails combining polygons based upon a unique attribute value and removing the interior geometry. 

<figure>
 <a href="{{ site.url }}/images/courses/earth-analytics/spatial-data/dissolve-polygons-esri.gif">
 <img src="{{ site.url }}/images/courses/earth-analytics/spatial-data/dissolve-polygons-esri.gif" alt="When you dissolve polygons you remove interior boundaries of a set of polygons with the same attribute value and create one new merged or combined polygon for each attribute value. In the case above US states are dissolved to regions in the United States. Source: ESRI"> 
 </a>
 <figcaption> When you dissolve polygons you remove interior boundaries of a set of polygons with the same attribute value and create one new "merged" or combined polygon for each attribute value. In the case above US states are dissolved to regions in the United States. Source: ESRI
 </figcaption>
</figure>

Below you will dissolve the US states polygons by the region that each state is in. When you dissolve, you will create a new set polygons - one for each regions in the United States.

To begin, explore your data. Using `.geom_type` you can see that you have a mix of single and multi polygons in your data. Sometimes multi-polygons can cause problems when processing. It's always good to check your geometry before you begin to better know what you are working with. 

{:.input}
```python
state_boundary_us.head()
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
      <th>STATEFP</th>
      <th>STATENS</th>
      <th>AFFGEOID</th>
      <th>GEOID</th>
      <th>STUSPS</th>
      <th>NAME</th>
      <th>LSAD</th>
      <th>ALAND</th>
      <th>AWATER</th>
      <th>region</th>
      <th>geometry</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>06</td>
      <td>01779778</td>
      <td>0400000US06</td>
      <td>06</td>
      <td>CA</td>
      <td>California</td>
      <td>00</td>
      <td>403483823181</td>
      <td>20483271881</td>
      <td>West</td>
      <td>(POLYGON Z ((-118.593969 33.467198 0, -118.484...</td>
    </tr>
    <tr>
      <th>1</th>
      <td>11</td>
      <td>01702382</td>
      <td>0400000US11</td>
      <td>11</td>
      <td>DC</td>
      <td>District of Columbia</td>
      <td>00</td>
      <td>158350578</td>
      <td>18633500</td>
      <td>Northeast</td>
      <td>POLYGON Z ((-77.119759 38.934343 0, -77.041017...</td>
    </tr>
    <tr>
      <th>2</th>
      <td>12</td>
      <td>00294478</td>
      <td>0400000US12</td>
      <td>12</td>
      <td>FL</td>
      <td>Florida</td>
      <td>00</td>
      <td>138903200855</td>
      <td>31407883551</td>
      <td>Southeast</td>
      <td>(POLYGON Z ((-81.81169299999999 24.568745 0, -...</td>
    </tr>
    <tr>
      <th>3</th>
      <td>13</td>
      <td>01705317</td>
      <td>0400000US13</td>
      <td>13</td>
      <td>GA</td>
      <td>Georgia</td>
      <td>00</td>
      <td>148963503399</td>
      <td>4947080103</td>
      <td>Southeast</td>
      <td>POLYGON Z ((-85.605165 34.984678 0, -85.474338...</td>
    </tr>
    <tr>
      <th>4</th>
      <td>16</td>
      <td>01779783</td>
      <td>0400000US16</td>
      <td>16</td>
      <td>ID</td>
      <td>Idaho</td>
      <td>00</td>
      <td>214045425549</td>
      <td>2397728105</td>
      <td>West</td>
      <td>POLYGON Z ((-117.243027 44.390974 0, -117.2150...</td>
    </tr>
  </tbody>
</table>
</div>





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





Next, select the columns that you with to use for the dissolve and keep. In this case we want to retain the:

* LSAD 
* geometry

columns. 

{:.input}
```python
state_boundary = state_boundary_us[['LSAD', 'geometry']]
cont_usa = state_boundary.dissolve(by='LSAD')
# View the resulting geodataframe
cont_usa
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
      <th>LSAD</th>
      <th></th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>00</th>
      <td>(POLYGON Z ((-81.81169299999999 24.568745 0, -...</td>
    </tr>
  </tbody>
</table>
</div>





And finally, plot the data. Note that when you dissolve, the column used to perform the dissolve becomes an index for the resultant geodataframe. Thus you will have to use the `reset_index()` method when you plot, to access the region "column". 

So this will work:

`us_regions.reset_index().plot(column = 'region', ax=ax)`

This will return an error as region is no longer a column, it is an index!
`us_regions.plot(column = 'region', ax=ax)`

{:.input}
```python
cont_usa.reset_index()
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
      <th>LSAD</th>
      <th>geometry</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>00</td>
      <td>(POLYGON Z ((-81.81169299999999 24.568745 0, -...</td>
    </tr>
  </tbody>
</table>
</div>





{:.input}
```python
# plot the data
fig, ax = plt.subplots(figsize=(10, 6))
cont_usa.reset_index().plot(column='LSAD',
                            ax=ax)
ax.set_axis_off()
plt.axis('equal')
plt.show() 
```

{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}//images/courses/earth-analytics-python/04-spatial-data/in-class/2018-02-05-spatial07-dissolve-polygons-python_12_0.png" alt = "The LSAD attribute value for every polygon in the data is 00. Thus when you dissolve by that attribute, you get one resulting polygon.">
<figcaption>The LSAD attribute value for every polygon in the data is 00. Thus when you dissolve by that attribute, you get one resulting polygon.</figcaption>

</figure>




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
# Select the columns that you wish to retain in the data
state_boundary = state_boundary_us[['region', 'geometry', 'ALAND', 'AWATER']]
# Then summarize the quantative columns by 'sum'
regions_agg = state_boundary.dissolve(by='region', aggfunc='sum')
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
fig, (ax1, ax2) = plt.subplots(2, 1, figsize=(10, 10))
regions_agg.plot(column='ALAND',
                 legend=True,
                 scheme='quantiles',
                 ax=ax1)
regions_agg.plot(column='AWATER',
                 scheme='quantiles',
                 legend=True,
                 ax=ax2)

plt.suptitle('Census Data - Total Land and Water by Region', fontsize=16)
ax1.set_axis_off()
ax2.set_axis_off()

plt.axis('equal')

plt.show()
```

{:.output}
    /Users/lewa8222/anaconda3/envs/earth-analytics-python/lib/python3.6/site-packages/pysal/__init__.py:65: VisibleDeprecationWarning: PySAL's API will be changed on 2018-12-31. The last release made with this API is version 1.14.4. A preview of the next API version is provided in the `pysal` 2.0 prelease candidate. The API changes and a guide on how to change imports is provided at https://pysal.org/about
      ), VisibleDeprecationWarning)



{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}//images/courses/earth-analytics-python/04-spatial-data/in-class/2018-02-05-spatial07-dissolve-polygons-python_15_1.png" alt = "In this example, you dissolved by region. There are 5 unique region values in the attributes. Thus you end up with 5 polygons. You also summarized attributes by ALAND and AWATER calculating the total value for each.">
<figcaption>In this example, you dissolved by region. There are 5 unique region values in the attributes. Thus you end up with 5 polygons. You also summarized attributes by ALAND and AWATER calculating the total value for each.</figcaption>

</figure>



