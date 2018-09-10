---
layout: single
title: "How to Join Attributes From One Shapefile to Another in Open Source Python Using Geopandas: GIS in Python"
excerpt: "In this lesson you review how to perform spatial joins in python. A spatial join is when you assign attributes from one shapefile to another based upon it's spatial location."
authors: ['Leah Wasser']
modified: 2018-09-07
category: [courses]
class-lesson: ['class-intro-spatial-python']
permalink: /courses/earth-analytics-python/spatial-data/spatial-joins-in-python-geopandas-shapely/
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

## <i class="fa fa-check-square-o fa-2" aria-hidden="true"></i> What You Need

You will need a computer with internet access to complete this lesson and the
spatial-vector-lidar data subset created for the course.

[<i class="fa fa-download" aria-hidden="true"></i> Download spatial-vector-lidar data subset (~172 MB)](https://ndownloader.figshare.com/files/12447845){:data-proofer-ignore='' .btn }

</div>



Get started by loading your libraries and setting your working directory. 

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

## Spatial Joins in Python

Just like you might do in ArcMap or QGIS you can perform spatial joins in Python too. A spatial join is when you append the attributes of one layer to another based upon it's spatial relationship.

So - for example if you have a roads layer for the United States, and you want to apply the "region" attribute to every road that is spatially in a particular region, you would use a spatial join. To apply a join you can use the `geopandas.sjoin()` function as following

.sjoin(layer-to-add-region-to, region-polygon-layer

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
# roads within region
roads_region = gpd.sjoin(us_roads_only, regions_agg, how="inner", op='intersects')
roads_region.head()
```

{:.output}

    ---------------------------------------------------------------------------

    NameError                                 Traceback (most recent call last)

    <ipython-input-6-cc9016b3db20> in <module>()
          1 # roads within region
    ----> 2 roads_region = gpd.sjoin(us_roads_only, regions_agg, how="inner", op='intersects')
          3 roads_region.head()


    NameError: name 'regions_agg' is not defined



Plot the data.

{:.input}
```python
# reproject to make a nicer looking map
country_albers = country_boundary_us.to_crs({'init': 'epsg:5070'})
roads_albers = roads_region.to_crs({'init': 'epsg:5070'})
```

{:.input}
```python
regions = np.unique(roads_albers['index_right'])

# plotting using geopandas
road_colors = ['black', 'grey', 'grey', 'black', 'grey', 'grey' ]
line_widths = [1, .5, .5, 1, .5, .5]

# plot the data
fig, ax = plt.subplots(figsize  = (12, 8))
country_albers.plot(alpha = 1, facecolor="none", 
                         edgecolor = "black", zorder=10, ax=ax)
roads_albers.plot(column='index_right', 
                  ax=ax, legend = True)

# leg1 = ax.legend(lines, [lines.get_label() for lines in lines], loc=(1.1, .1), 
#                   prop={'size': 16},
#                    frameon=False, 
#                   title='Plot Type')

#roads = [mlines.Line2D([0], [0], color=c, linewidth = width) for c, width in zip(road_colors, line_widths)]
#road_names = np.unique(us_roads_only['type'])

#plt.legend(roads, road_names, loc = 'best')
ax.set_axis_off()
plt.axis('equal');
```

{:.input}
```python
# turn off scientific notation
pd.options.display.float_format = '{:.4f}'.format

# calculate the total length of road 
road_albers_length = roads_albers[['index_right', 'length_km']]
# sum existing columns
roads_albers.groupby('index_right').sum()

roads_albers['rdlength'] = roads_albers.length
sub = roads_albers[['rdlength', 'index_right']].groupby('index_right').sum()
sub
```

* http://darribas.org/gds16/content/labs/lab_02.html
