---
layout: single
title: "Handle missing spatial attribute data Python: GIS in Python"
excerpt: "This lesson introduces what vector data are and how to open vector data stored in
shapefile format in Python. "
authors: ['Chris Holdgraf', 'Leah Wasser', 'Martha Morrissey']
modified: 2018-10-08
category: [courses]
class-lesson: ['class-intro-spatial-python']
permalink: /courses/earth-analytics-python/spatial-data-vector-shapefiles/missing-data-vector-data-in-python/
nav-title: 'Missing spatial data'
module-type: 'class'
course: 'earth-analytics-python'
week: 4
sidebar:
  nav:
author_profile: false
comments: true
order: 9
---
{% include toc title="In This Lesson" icon="file-text" %}

<div class='notice--success' markdown="1">

## <i class="fa fa-graduation-cap" aria-hidden="true"></i> Learning Objectives

After completing this tutorial, you will be able to:

* work with data sets that have missing data

* replace missing data values 

## <i class="fa fa-check-square-o fa-2" aria-hidden="true"></i> What You Need

You will need a computer with internet access to complete this lesson and the
spatial-vector-lidar data subset created for the course.

{% include/data_subsets/course_earth_analytics/_data-spatial-lidar.md %}


</div>

{:.input}
```python
import os
import pandas as pd
import numpy as np
import geopandas as gpd
import earthpy as et 
os.chdir(os.path.join(et.io.HOME, 'earth-analytics'))
```

This lesson covers how to rename and clean up attribute data using  `geopandas.`

{:.input}
```python
# Import roads shapefile
sjer_roads = gpd.read_file("data/spatial-vector-lidar/california/madera-county-roads/tl_2013_06039_roads.shp")
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
      <td>LINESTRING (-120.272267 37.116151, -120.27244 ...</td>
    </tr>
    <tr>
      <th>1</th>
      <td>110454239052</td>
      <td>N 11th St</td>
      <td>M</td>
      <td>S1400</td>
      <td>LINESTRING (-120.267877 37.116672, -120.268072...</td>
    </tr>
    <tr>
      <th>2</th>
      <td>110454239056</td>
      <td>N 12th St</td>
      <td>M</td>
      <td>S1400</td>
      <td>LINESTRING (-120.27053 37.117494, -120.270448 ...</td>
    </tr>
    <tr>
      <th>3</th>
      <td>110454239047</td>
      <td>N 10th St</td>
      <td>M</td>
      <td>S1400</td>
      <td>LINESTRING (-120.267028 37.11734599999999, -12...</td>
    </tr>
    <tr>
      <th>4</th>
      <td>110454243091</td>
      <td>N Westberry Blvd</td>
      <td>M</td>
      <td>S1400</td>
      <td>LINESTRING (-120.101219 36.96524099999999, -12...</td>
    </tr>
  </tbody>
</table>
</div>





## Removing Values

In some specific instances you will want to remove `NaN` values from your `DataFrame`, to do this you can use the `pandas` `.dropna` function, note that this function will remove all rows from the dataframe that have a `Nan` value in any of the columns. 
