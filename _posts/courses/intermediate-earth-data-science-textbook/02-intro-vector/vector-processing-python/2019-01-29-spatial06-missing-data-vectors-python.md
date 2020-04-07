---
layout: single
title: "Handle missing spatial attribute data: GIS in Python"
excerpt: "Sometimes vector data are missing attribute data, and it can be helpful to clean up your data. Learn how to handle missing attribute data in Python using GeoPandas."  
authors: ['Chris Holdgraf', 'Leah Wasser', 'Martha Morrissey']
dateCreated: 2018-02-05
modified: 2020-04-04
category: [courses]
class-lesson: ['vector-processing-python']
permalink: /courses/use-data-open-source-python/intro-vector-data-python/vector-data-processing/missing-data-vector-data-in-python/
nav-title: 'Missing spatial data'
module-type: 'class'
course: 'intermediate-earth-data-science-textbook'
week: 2
sidebar:
  nav:
author_profile: false
comments: true
order: 6
topics:
  spatial-data-and-gis: ['vector-data']
redirect_from:
  - "/courses/earth-analytics-python/spatial-data-vector-shapefiles/missing-data-vector-data-in-python/"
---

{% include toc title="On This Page" icon="file-text" %}

<div class='notice--success' markdown="1">

## <i class="fa fa-graduation-cap" aria-hidden="true"></i> Learning Objectives

* Work with data sets that have missing data.
* Replace missing data values 

</div>

This lesson covers how to rename and clean up attribute data using **geopandas.

{:.input}
```python
import os
import numpy as np
import pandas as pd
import geopandas as gpd
import earthpy as et 

# Set working dir & get data
data = et.data.get_data('spatial-vector-lidar')
os.chdir(os.path.join(et.io.HOME, 'earth-analytics'))
```

{:.input}
```python
# Import roads shapefile
sjer_roads_path = os.path.join("data", "spatial-vector-lidar", "california", 
                               "madera-county-roads", "tl_2013_06039_roads.shp")
sjer_roads = gpd.read_file(sjer_roads_path)

type(sjer_roads)
```

{:.output}
{:.execute_result}



    geopandas.geodataframe.GeoDataFrame





## Explore Data Values 

There are several ways to use `pandas` to explore your data and determine if you have any missing values.

* To find the number of missing values per column in a DataFrame you can run `dfname.is_null().sum()`
* Look at the unique values for a specific column of a DataFrame `dfname['column'].unique()`

{:.input}
```python
sjer_roads.isnull().sum()
```

{:.output}
{:.execute_result}



    LINEARID       0
    FULLNAME    5149
    RTTYP       5149
    MTFCC          0
    geometry       0
    dtype: int64





Based on this method there are no `NaN` or `None` type obejcts as values in the `geodataframe`. Double check the unique values in the road type column. 

{:.input}
```python
# View data type 
print(type(sjer_roads['RTTYP']))

# View unique attributes for each road in the data
print(sjer_roads['RTTYP'].unique())
```

{:.output}
    <class 'pandas.core.series.Series'>
    ['M' None 'S' 'C']



## Replacing Values

* If the value you want to replace is a `Nan` or `Nonetype` you can use 
    `dfname.loc[dfname['column'].isnull(), 'column' = 'newvaluu'`
    
* Or you can use the `pandas` `.fillna()` method and .`fullna` takes in the value that you want to replace. 

Hmmmm there's a road type that's given an empty `string` as a name. It would be helpful to fix this before doing more analyis or mapping with this dataset. 

There are several ways to deal with this issue. One is to use the `.replace` method to replace all instances of None in the attribute data with some new value. In this case, you will use - 'Unknown'. 

{:.input}
```python
# Map each value to a new value 
sjer_roads["RTTYP"] = sjer_roads["RTTYP"].fillna("Unknown")
print(sjer_roads['RTTYP'].unique())
```

{:.output}
    ['M' 'Unknown' 'S' 'C']



Alternatively you can use the `.isnull()` function to select all attribute cells with a value equal to `null` and set those to 'Unknown'.

If the value you want to change is not `NaN` or a `Nonetype` then you will have to specify the origina value that you want to change, as shown below. 

{:.input}
```python
sjer_roads.head()
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
      <th>LINEARID</th>
      <th>FULLNAME</th>
      <th>RTTYP</th>
      <th>MTFCC</th>
      <th>geometry</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>110454239066</td>
      <td>N 14th St</td>
      <td>M</td>
      <td>S1400</td>
      <td>LINESTRING (-120.27227 37.11615, -120.27244 37...</td>
    </tr>
    <tr>
      <th>1</th>
      <td>110454239052</td>
      <td>N 11th St</td>
      <td>M</td>
      <td>S1400</td>
      <td>LINESTRING (-120.26788 37.11667, -120.26807 37...</td>
    </tr>
    <tr>
      <th>2</th>
      <td>110454239056</td>
      <td>N 12th St</td>
      <td>M</td>
      <td>S1400</td>
      <td>LINESTRING (-120.27053 37.11749, -120.27045 37...</td>
    </tr>
    <tr>
      <th>3</th>
      <td>110454239047</td>
      <td>N 10th St</td>
      <td>M</td>
      <td>S1400</td>
      <td>LINESTRING (-120.26703 37.11735, -120.26721 37...</td>
    </tr>
    <tr>
      <th>4</th>
      <td>110454243091</td>
      <td>N Westberry Blvd</td>
      <td>M</td>
      <td>S1400</td>
      <td>LINESTRING (-120.10122 36.96524, -120.10123 36...</td>
    </tr>
  </tbody>
</table>
</div>





## Removing Values

In some specific instances you will want to remove `NaN` values from your `DataFrame`, to do this you can use the `pandas` `.dropna` function, note that this function will remove all rows from the dataframe that have a `Nan` value in any of the columns. 

<div class="notice--success" markdown="1">
## <i class="fa fa-pencil-square-o" aria-hidden="true"></i> Optional Challenge: Import & Plot Roads Shapefile

Import the madera-county-roads layer - `california/madera-county-roads/tl_2013_06039_roads.shp`. Plot the roads.

Next, try to overlay the plot locations `california/SJER/vector_data/SJER_plot_centroids.shp` and sjer_crop- `california/SJER/vector_data/SJER_crop.shp` on top of the
SJER crop extent. What happens?

* Check the CRS of both layers. What do you notice?

</div>
