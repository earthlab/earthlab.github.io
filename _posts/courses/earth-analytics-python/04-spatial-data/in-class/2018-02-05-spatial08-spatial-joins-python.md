---
layout: single
title: "How to Join Attributes From One Shapefile to Another in Open Source Python Using Geopandas: GIS in Python"
excerpt: "In this lesson you review how to perform spatial joins in python. A spatial join is when you assign attributes from one shapefile to another based upon it's spatial location."
authors: ['Leah Wasser','Jenny Palomino']
modified: 2018-10-08
category: [courses]
class-lesson: ['class-intro-spatial-python']
permalink: /courses/earth-analytics-python/spatial-data-vector-shapefiles/spatial-joins-in-python-geopandas-shapely/
nav-title: 'Spatial Joins'
course: 'earth-analytics-python'
week: 4
sidebar:
  nav:
author_profile: false
comments: true
order: 8
---
{% include toc title="In This Lesson" icon="file-text" %}

<div class='notice--success' markdown="1">

## <i class="fa fa-graduation-cap" aria-hidden="true"></i> Learning Objectives

After completing this tutorial, you will be able to:

* Join spatial attributes from one shapefile to another using geopandas in python.
* Calculate line segment length using `geopandas`

## <i class="fa fa-check-square-o fa-2" aria-hidden="true"></i> What You Need

You will need a computer with internet access to complete this lesson and the
spatial-vector-lidar data subset created for the course.

{% include/data_subsets/course_earth_analytics/_data-spatial-lidar.md %}

</div>

Get started by loading your libraries and setting your working directory. 

{:.input}
```python
# Import libraries
import os
import numpy as np
import matplotlib.pyplot as plt
import matplotlib.lines as mlines
from matplotlib.colors import ListedColormap
import pandas as pd
import geopandas as gpd
import earthpy as et 
# Plot figures  inline
plt.ion()
from shapely.geometry import box

os.chdir(os.path.join(et.io.HOME, 'earth-analytics'))

# Import clip_data.py as a module so you can access the clip data functions
import clip_data as cl
```

{:.input}
```python
# Import data
country_bound_us = gpd.read_file('data/spatial-vector-lidar/usa/usa-boundary-dissolved.shp')
state_bound_us = gpd.read_file('data/spatial-vector-lidar/usa/usa-states-census-2014.shp')
pop_places = gpd.read_file('data/spatial-vector-lidar/global/ne_110m_populated_places_simple/ne_110m_populated_places_simple.shp')
ne_roads = gpd.read_file('data/spatial-vector-lidar/global/ne_10m_roads/ne_10m_roads.shp')

```

Next dissolve the state data by region like you did in the previous lesson. 

{:.input}
```python
# Simplify the country boundary just a little bit to make this run faster
country_bound_us_simp = country_bound_us.simplify(.2, preserve_topology=True)
# Clip the roads to the US boundary - this will take about a minute to execute
roads_cl = cl.clip_shp(ne_roads, country_bound_us_simp)
# Dissolve states by region
regions_agg = state_bound_us.dissolve(by="region")
```

## Spatial Joins in Python

Just like you might do in ArcMap or QGIS you can perform spatial joins in Python too. A spatial join is when you append the attributes of one layer to another based upon its spatial relationship.

So - for example if you have a roads layer for the United States, and you want to apply the "region" attribute to every road that is spatially in a particular region, you would use a spatial join. To apply a join you can use the `geopandas.sjoin()` function as following:

`.sjoin(layer-to-add-region-to, region-polygon-layer)`

### Sjoin Arguments:
The `op` argument specifies the type of join that will be applied

* `intersects`: Returns True if the boundary and interior of the object intersect in any way with those of the other.
* `within`: Returns True if the object’s boundary and interior intersect only with the interior of the other (not its boundary or exterior).
* `contains`: Returns True if the object’s interior contains the boundary and interior of the other object and their boundaries do not touch at all.

<a href ="http://toblerity.org/shapely/manual.html#binary-predicates" target = "_blank">You can read more about each type here.</a>
 
How allows the following options: (this is taken directly from the <a href = "https://github.com/geopandas/geopandas/blob/master/geopandas/tools/sjoin.py#L18" target = "_blank">geopandas code on github!</a>

* 'left': use keys from left_df; retain only left_df geometry column
* 'right': use keys from right_df; retain only right_df geometry column
* 'inner': use intersection of keys from both dfs; retain only
          left_df geometry column 

{:.input}
```python
# Roads within region
roads_region = gpd.sjoin(roads_cl, 
                         regions_agg, 
                         how="inner", 
                         op='intersects')
# Notice once you have joins the data - you have attributes from the regions_object (ie the region) 
# attached to each road feature
roads_region[["featurecla", "index_right", "ALAND"]].head()
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
      <th>featurecla</th>
      <th>index_right</th>
      <th>ALAND</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>1453</th>
      <td>Road</td>
      <td>West</td>
      <td>403483823181</td>
    </tr>
    <tr>
      <th>1434</th>
      <td>Road</td>
      <td>West</td>
      <td>403483823181</td>
    </tr>
    <tr>
      <th>1492</th>
      <td>Road</td>
      <td>West</td>
      <td>403483823181</td>
    </tr>
    <tr>
      <th>50512</th>
      <td>Road</td>
      <td>West</td>
      <td>403483823181</td>
    </tr>
    <tr>
      <th>49677</th>
      <td>Road</td>
      <td>West</td>
      <td>403483823181</td>
    </tr>
  </tbody>
</table>
</div>





Plot the data.

{:.input}
```python
# Reproject to Albers for plotting
country_albers = country_bound_us.to_crs({'init': 'epsg:5070'})
roads_albers = roads_region.to_crs({'init': 'epsg:5070'})
```

{:.input}
```python
# Plot the data
fig, ax = plt.subplots(figsize=(12, 8))
country_albers.plot(alpha=1,
                    facecolor="none",
                    edgecolor="black",
                    zorder=10,
                    ax=ax)
roads_albers.plot(column='index_right',
                  ax=ax,
                  legend=True)
ax.set_axis_off()
plt.axis('equal')
plt.show()
```

{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}//images/courses/earth-analytics-python/04-spatial-data/in-class/2018-02-05-spatial08-spatial-joins-python_10_0.png" alt = "Plot of roads colored by region with a standard geopandas legend.">
<figcaption>Plot of roads colored by region with a standard geopandas legend.</figcaption>

</figure>




If you want to customize your legend even further, you can once again use loops to do so.


{:.input}
```python
# First, create a dictionary with the attributes of each legend item
road_attrs = {'Midwest': ['black'],
              'Northeast': ['grey'],
              'Southeast': ['m'],
              'Southwest': ['purple'],
              'West': ['green']}

# Plot the data
fig, ax = plt.subplots(figsize=(12, 8))
regions_agg.plot(edgecolor="black",
                 ax=ax)
country_albers.plot(alpha=1,
                    facecolor="none",
                    edgecolor="black",
                    zorder=10,
                    ax=ax)

for ctype, data in roads_albers.groupby('index_right'):
    data.plot(color=road_attrs[ctype][0],
              label=ctype,
              ax=ax)
plt.legend(bbox_to_anchor=(1.0, 1), loc=2)
ax.set_axis_off()
plt.axis('equal')
plt.show()
```

{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}//images/courses/earth-analytics-python/04-spatial-data/in-class/2018-02-05-spatial08-spatial-joins-python_12_0.png" alt = "Plot of roads colored by region with a custom legend.">
<figcaption>Plot of roads colored by region with a custom legend.</figcaption>

</figure>




## Calculate Line Segment Length

{:.input}
```python
# Turn off scientific notation
pd.options.display.float_format = '{:.4f}'.format

# Calculate the total length of road 
road_albers_length = roads_albers[['index_right', 'length_km']]
# Sum existing columns
roads_albers.groupby('index_right').sum()

roads_albers['rdlength'] = roads_albers.length
sub = roads_albers[['rdlength', 'index_right']].groupby('index_right').sum()
sub
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
      <th>rdlength</th>
    </tr>
    <tr>
      <th>index_right</th>
      <th></th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>Midwest</th>
      <td>86575020.6373</td>
    </tr>
    <tr>
      <th>Northeast</th>
      <td>33786036.8608</td>
    </tr>
    <tr>
      <th>Southeast</th>
      <td>84343077.8904</td>
    </tr>
    <tr>
      <th>Southwest</th>
      <td>49373104.8209</td>
    </tr>
    <tr>
      <th>West</th>
      <td>61379830.5534</td>
    </tr>
  </tbody>
</table>
</div>




