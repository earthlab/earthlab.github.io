---
layout: single
category: [courses]
title: "How to Dissolve Polygons Using Geopandas: GIS in Python"
excerpt: "In this lesson you review how to dissolve polygons in python. A spatial join is when you assign attributes from one shapefile to another based upon its spatial location."
authors: ['Leah Wasser', 'Jenny Palomino']
modified: 2018-09-21
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

* Aggregate the geometry of spatial data using `dissolve` based on an attribute in `Python`
* Aggregate the quantitative values in your attribute table when you perform a dissolve in `Python`


## <i class="fa fa-check-square-o fa-2" aria-hidden="true"></i> What You Need

You will need a computer with internet access to complete this lesson and the spatial-vector-lidar data subset created for the course. 

[<i class="fa fa-download" aria-hidden="true"></i> Download spatial-vector-lidar data subset (~172 MB)](https://ndownloader.figshare.com/files/12459464){:data-proofer-ignore='' .btn }

</div>

In this lesson, you will use `Python` to aggregate (i.e. dissolve) the spatial boundaries of the United States state boundaries using a region name that is an attribute of the dataset. Then, you will aggregate the values in the attribute table, so that the quantitative values in the attribute table will reflect the new spatial boundaries for regions. 


## Import Packages and Data 

To get started, `import` the packages you will need for this lesson into `Python` and set the current working directory. 

{:.input}
```python
# import necessary packages to work with spatial data in Python
import os
import numpy as np
import geopandas as gpd
import matplotlib.pyplot as plt
import matplotlib.lines as mlines
from matplotlib.colors import ListedColormap
import earthpy as et 

# make figures plot inline
plt.ion()
```

{:.input}
```python
# import United States state boundaries
state_boundary_us = gpd.read_file("data/spatial-vector-lidar/usa/usa-states-census-2014.shp")
```

## Dissolve Polygons Based On an Attribute with Geopandas

Dissolving polygons entails combining polygons based upon a unique attribute value and removing the interior geometry. 

<figure>
 <a href="{{ site.url }}/images/courses/earth-analytics/spatial-data/dissolve-polygons-esri.gif">
 <img src="{{ site.url }}/images/courses/earth-analytics/spatial-data/dissolve-polygons-esri.gif" alt = "Image showing how dissolve works on polygon data. When you dissolve polygons you remove interior boundaries of a set of polygons with the same attribute value and create one new merged (combined) polygon for each attribute value. In the case above US states are dissolved to regions in the United States. Source: ESRI." ></a>
 <figcaption>When you dissolve polygons you remove interior boundaries of a set of polygons with the same attribute value and create one new "merged" (or combined) polygon for each attribute value. In the case above US states are dissolved to regions in the United States. Source: ESRI.
 </figcaption>
</figure>

Below you will dissolve the US states polygons by the region that each state is in. When you dissolve, you will create a new set polygons - one for each region in the United States.

To begin, explore your data. Using `.geom_type` you can see that you have a mix of single and multi polygons in your data. Sometimes multi-polygons can cause problems when processing. It's always good to check your geometry before you begin to better know what you are working with. 

{:.input}
```python
# query the first few records of the geom_type column
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





Next, select the columns that you with to use for the dissolve and that will be retained. 

In this case, we want to retain the columns:

* region 
* geometry

{:.input}
```python
# select the columns that you with to use for the dissolve and that will be retained
state_boundary = state_boundary_us[['region', 'geometry']]

# dissolve the state boundary by region 
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





And finally, plot the data. Note that when you dissolve, the column used to perform the dissolve becomes an index for the resultant geodataframe. Thus, you will have to use the reset_index() method when you plot, to access the `region` column.

If you do not reset the index, the following will return and error, as region is no longer a column, it is an index!
`us_regions.plot(column = 'region', ax=ax)`

You can use `us_regions.reset_index().plot(column = 'region', ax=ax)` to reset the index when you plot the data.

{:.input}
```python
# create the plot
fig, ax = plt.subplots(figsize = (10,6))

# plot the data 
us_regions.reset_index().plot(column = 'region', ax=ax)

# Set plot axis to equal ratio
ax.set_axis_off()
plt.axis('equal');
```

{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}//images/workshops/spatial-data-python-intro/2018-07-20-spatial-06-dissolve-polygons-python_9_0.png" alt = "You can dissolve the boundaries between polygons based on an attribute label, such as region, as shown in this example.">
<figcaption>You can dissolve the boundaries between polygons based on an attribute label, such as region, as shown in this example.</figcaption>

</figure>




## Dissolve and Aggregate Data Attributes

In the example above, you dissolved the state level polygons to a region level. However, you did not aggregate or summarize the attributes associated with each polygon. 

Next, you will learn how to aggregate quantitative values in your attribute table when you perform a dissolve. To do this, you will add `aggfunc = 'summaryfunction'` to your dissolve call. 

You can choice a suite of different summary functions including:

* first
* last
* mean
* max

And more. <a href = "http://geopandas.org/aggregation_with_dissolve.html" target = "_blank">Read more about the dissolve function here.</a> 

Aggregate the data using the 'sum' method on the ALAND and AWATER attributes (total land and water area). 

The values for ALAND and AWATER will be added up for all of the states in a region. Those new summed values will be returned in the new dataframe. 

{:.input}
```python
# select the columns that you wish to retain in the data
state_boundary = state_boundary_us[['region', 'geometry', 'ALAND', 'AWATER']]

# then summarize the quantative columns by 'sum' 
regions_agg = state_boundary.dissolve(by='region', aggfunc = 'sum')

# display the new dataframe
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
# create the plot
fig, ax = plt.subplots(figsize = (12,8))

# plot the data using a quantile map of the new ALAND values
regions_agg.plot(column = 'ALAND', edgecolor = "black",
                 scheme='quantiles', cmap='YlOrRd', ax=ax, 
                 legend = True)


# Set plot axis to equal ratio
ax.set_axis_off()
plt.axis('equal');
```

{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}//images/workshops/spatial-data-python-intro/2018-07-20-spatial-06-dissolve-polygons-python_12_0.png" alt = "In addition to dissolving the boundaries between polygons based on an attribute label, you can also summarize the other attributes, such as calculating the sum of the land area, using the new polygon boundaries. You can also make a quantile map of the aggregated data, as shown in this example.">
<figcaption>In addition to dissolving the boundaries between polygons based on an attribute label, you can also summarize the other attributes, such as calculating the sum of the land area, using the new polygon boundaries. You can also make a quantile map of the aggregated data, as shown in this example.</figcaption>

</figure>




<div class="notice--warning" markdown="1">

## <i class="fa fa-pencil-square-o" aria-hidden="true"></i> Optional Challenge 1

Create a quantile map using the AWATER attribute column. 

</div>


{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}//images/workshops/spatial-data-python-intro/2018-07-20-spatial-06-dissolve-polygons-python_14_0.png" alt = "In addition to dissolving the boundaries between polygons based on an attribute label, you can also summarize the other attributes, such as calculating the sum of the area of water, using the new polygon boundaries. You can also make a quantile map of the aggregated data, as shown in this example.">
<figcaption>In addition to dissolving the boundaries between polygons based on an attribute label, you can also summarize the other attributes, such as calculating the sum of the area of water, using the new polygon boundaries. You can also make a quantile map of the aggregated data, as shown in this example.</figcaption>

</figure>




<div class="notice--warning" markdown="1">

## <i class="fa fa-pencil-square-o" aria-hidden="true"></i> Optional Challenge 2

Aggregate the data using the 'mean' method on the ALAND and AWATER attributes (total land and water area). Then create two maps:

1. a map of mean value for ALAND by region and 
2. a map of mean value for AWATER by region

</div>


{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}//images/workshops/spatial-data-python-intro/2018-07-20-spatial-06-dissolve-polygons-python_16_0.png" alt = "In addition to dissolving the boundaries between polygons based on an attribute label, you can also summarize the other attributes, such as calculating the means of the areas of land and water, using the new polygon boundaries. You can also make quantile maps of the aggregated data, as shown in these examples.">
<figcaption>In addition to dissolving the boundaries between polygons based on an attribute label, you can also summarize the other attributes, such as calculating the means of the areas of land and water, using the new polygon boundaries. You can also make quantile maps of the aggregated data, as shown in these examples.</figcaption>

</figure>




{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}//images/workshops/spatial-data-python-intro/2018-07-20-spatial-06-dissolve-polygons-python_16_1.png" alt = "In addition to dissolving the boundaries between polygons based on an attribute label, you can also summarize the other attributes, such as calculating the means of the areas of land and water, using the new polygon boundaries. You can also make quantile maps of the aggregated data, as shown in these examples.">
<figcaption>In addition to dissolving the boundaries between polygons based on an attribute label, you can also summarize the other attributes, such as calculating the means of the areas of land and water, using the new polygon boundaries. You can also make quantile maps of the aggregated data, as shown in these examples.</figcaption>

</figure>



