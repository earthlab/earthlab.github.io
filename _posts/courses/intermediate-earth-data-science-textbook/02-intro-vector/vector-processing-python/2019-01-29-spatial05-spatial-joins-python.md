---
layout: single
title: "How to Join Attributes From One Shapefile to Another in Open Source Python Using Geopandas: GIS in Python"
excerpt: "A spatial join is when you assign attributes from one shapefile to another based upon its spatial location. Learn how to perform spatial joins in Python."
authors: ['Leah Wasser','Jenny Palomino']
dateCreated: 2018-02-05
modified: 2020-04-03
category: [courses]
class-lesson: ['vector-processing-python']
permalink: /courses/use-data-open-source-python/intro-vector-data-python/vector-data-processing/spatial-joins-in-python-geopandas-shapely/
nav-title: 'Spatial Joins'
course: 'intermediate-earth-data-science-textbook'
week: 2
sidebar:
  nav:
author_profile: false
comments: true
order: 5
topics:
  spatial-data-and-gis: ['vector-data']
redirect_from:
  - "/courses/earth-analytics-python/spatial-data-vector-shapefiles/spatial-joins-in-python-geopandas-shapely/"
---

{% include toc title="On This Page" icon="file-text" %}

<div class='notice--success' markdown="1">

## <i class="fa fa-graduation-cap" aria-hidden="true"></i> Learning Objectives

* Join spatial attributes from one shapefile to another using **geopandas** in **Python**.
* Calculate line segment length **geopandas** in **Python**.

</div>

Get started by loading your libraries and setting your working directory. 

{:.input}
```python
# Import libraries
import os
import matplotlib.pyplot as plt
import matplotlib.lines as mlines
from matplotlib.colors import ListedColormap
import numpy as np
import pandas as pd
from shapely.geometry import box
import geopandas as gpd
import earthpy as et

# Set working dir & get data
data = et.data.get_data('spatial-vector-lidar')
os.chdir(os.path.join(et.io.HOME, 'earth-analytics'))
```

{:.output}
    Downloading from https://ndownloader.figshare.com/files/12459464
    Extracted output to /root/earth-analytics/data/spatial-vector-lidar/.



{:.input}
```python
# Import data
data_path = os.path.join("data/spatial-vector-lidar")

country_bound_us = gpd.read_file(os.path.join(data_path, "usa", 
                                              "usa-boundary-dissolved.shp"))
                                 
state_bound_us = gpd.read_file(os.path.join(data_path, "usa", 
                                            "usa-states-census-2014.shp"))
                               
pop_places = gpd.read_file(os.path.join(data_path, "global", 
                                        "ne_110m_populated_places_simple", 
                                        "ne_110m_populated_places_simple.shp"))
                                        
ne_roads = gpd.read_file(os.path.join(data_path, "global", 
                                      "ne_10m_roads", "ne_10m_roads.shp"))
```

Next dissolve the state data by region like you did in the previous lesson. 

{:.input}
```python
# Simplify the country boundary just a little bit to make this run faster
country_bound_us_simp = country_bound_us.simplify(.2, preserve_topology=True)

# Clip the roads to the US boundary - this will take about a minute to execute
roads_cl = gpd.clip(ne_roads, country_bound_us_simp)
roads_cl.crs = ne_roads.crs

# Dissolve states by region
regions_agg = state_bound_us.dissolve(by="region")
```

{:.output}
    /opt/conda/lib/python3.7/site-packages/geopandas/geoseries.py:358: UserWarning: GeoSeries.notna() previously returned False for both missing (None) and empty geometries. Now, it only returns False for missing values. Since the calling GeoSeries contains empty geometries, the result has changed compared to previous versions of GeoPandas.
    Given a GeoSeries 's', you can use '~s.is_empty & s.notna()' to get back the old behaviour.
    
    To further ignore this warning, you can do: 
    import warnings; warnings.filterwarnings('ignore', 'GeoSeries.notna', UserWarning)
      return self.notna()



## Spatial Joins in Python

Just like you might do in ArcMap or QGIS you can perform spatial joins in Python too. A spatial join is when you append the attributes of one layer to another based upon its spatial relationship.

So - for example if you have a roads layer for the United States, and you want to apply the "region" attribute to every road that is spatially in a particular region, you would use a spatial join. To apply a join you can use the `geopandas.sjoin()` function as following:

`.sjoin(layer-to-add-region-to, region-polygon-layer)`

### Sjoin Arguments:

The `op` argument specifies the type of join that will be applied

* `intersects`: Returns True if the boundary and interior of the object intersect in any way with those of the other.
* `within`: Returns True if the object’s boundary and interior intersect only with the interior of the other (not its boundary or exterior).
* `contains`: Returns True if the object’s interior contains the boundary and interior of the other object and their boundaries do not touch at all.

<a href ="https://shapely.readthedocs.io/en/stable/manual.html?highlight=binary%20predicates#binary-predicates" target = "_blank">You can read more about each type here.</a>
 
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

# Notice once you have joins the data - you have attributes 
# from the regions_object (i.e. the region) attached to each road feature
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
      <th>1</th>
      <td>Road</td>
      <td>Midwest</td>
      <td>143794747023</td>
    </tr>
    <tr>
      <th>3</th>
      <td>Road</td>
      <td>Midwest</td>
      <td>143794747023</td>
    </tr>
    <tr>
      <th>6</th>
      <td>Road</td>
      <td>Midwest</td>
      <td>143794747023</td>
    </tr>
    <tr>
      <th>7</th>
      <td>Road</td>
      <td>Midwest</td>
      <td>143794747023</td>
    </tr>
    <tr>
      <th>54</th>
      <td>Road</td>
      <td>Midwest</td>
      <td>143794747023</td>
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

# Adjust legend location
leg = ax.get_legend()
leg.set_bbox_to_anchor((1.15,1))

ax.set_axis_off()
plt.axis('equal')
plt.show()
```

{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}/images/courses/intermediate-earth-data-science-textbook/02-intro-vector/vector-processing-python/2019-01-29-spatial05-spatial-joins-python/2019-01-29-spatial05-spatial-joins-python_11_0.png" alt = "Plot of roads colored by region with a standard geopandas legend.">
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
    
# This approach works to place the legend when you have defined labels
plt.legend(bbox_to_anchor=(1.0, 1), loc=2)
ax.set_axis_off()
plt.axis('equal')
plt.show()
```

{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}/images/courses/intermediate-earth-data-science-textbook/02-intro-vector/vector-processing-python/2019-01-29-spatial05-spatial-joins-python/2019-01-29-spatial05-spatial-joins-python_13_0.png" alt = "Plot of roads colored by region with a custom legend.">
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






