---
layout: single
title: "Clip a spatial vector layer in python using shapely & geopandas: GIS in Python"
excerpt: "In this lesson you review how to clip a vector data layer in python using geopandas and shapely."
authors: ['Leah Wasser', 'Martha Morrissey']
modified: 2018-07-27
category: [courses]
class-lesson: ['class-intro-spatial-python']
permalink: /courses/earth-analytics-python/spatial-data/clip-vector-data-in-python-geopandas-shapely/
nav-title: 'Clip vector data'
course: 'earth-analytics-python'
week: 4
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

* Clip a spatial vector point and line layer to the spatial extent of a polygon layer in `Python`
* Visually "clip" or zoom in to a particular spatial extent in a plot.

## <i class="fa fa-check-square-o fa-2" aria-hidden="true"></i> What You Need

You will need a computer with internet access to complete this lesson and the
spatial-vector-lidar data subset created for the course.

[<i class="fa fa-download" aria-hidden="true"></i> Download spatial-vector-lidar data subset (~172 MB)](https://ndownloader.figshare.com/files/12447845){:data-proofer-ignore='' .btn }

</div>


In this lesson, you will learn how to spatially clip data for easier plotting and analysis of smaller spatial areas. You will use the `geopandas` library and the `box` module from the `shapely` library. 

## How to Clip Vector Data in Python


### What Is Clipping or Cropping Data?
When you clip or crop spatial data you are removing the data outside of the clip extent. 
This means that your clipped dataset will be SMALLER (have a smaller spatial extent) than the original dataset.
This also means that objects in the data such as polygons or lines will be CUT based on the boundary of the clip object.

<figure>
    <a href="{{ site.baseurl }}/images/courses/earth-analytics/spatial-data/spatial-extent.png">
    <img src="{{ site.baseurl }}/images/courses/earth-analytics/spatial-data/spatial-extent.png" alt="the spatial extent represents the spatial area that a particular dataset covers."></a>
    <figcaption>The spatial extent of a shapefile or `Python` spatial object like a `geopandas` `geodataframe` represents
    the geographic "edge" or location that is the furthest north, south east and
    west. Thus is represents the overall geographic coverage of the spatial object.
    Image Source: National Ecological Observatory Network (NEON)
    </figcaption>
</figure>

### When Do You Want to Clip Data?
You may want to clip your data for several reasons:

1. You have more data than you need. For example you have data outside of your study area that you don't need to process. Clipping it to the study area boundary will make it smaller and easier to manage!
2. If you have data outside of your study area and you clip it, you can perform analysis on only that region - thus you won't need to subset the data further when you perform summary statistics for example.
3. When you plot the data  you will only see the study region.

You will learn how to both crop your data and zoom in on an extent below.  
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

## How to Clip Shapefiles in Python

In your dataset for this week you have 3 layers:

1. a country boundary for the USA and
2. a state boundary layer for the USA and 
3. populated places in the USA

The data are imported and plotted below. 

{:.input}
```python
country_boundary_us = gpd.read_file('data/spatial-vector-lidar/usa/usa-boundary-dissolved.shp')
state_boundary_us = gpd.read_file('data/spatial-vector-lidar/usa/usa-states-census-2014.shp')
pop_places = gpd.read_file('data/spatial-vector-lidar/global/ne_110m_populated_places_simple/ne_110m_populated_places_simple.shp')

# are the data all in the same crs?
print("country_boundary_us",country_boundary_us.crs)
print("state_boundary_us",state_boundary_us.crs)
print("pop_places",pop_places.crs)
```

{:.output}
    country_boundary_us {'init': 'epsg:4326'}
    state_boundary_us {'init': 'epsg:4326'}
    pop_places {'init': 'epsg:4326'}



{:.input}
```python
# plot the data
fig, ax = plt.subplots(figsize  = (12, 8))
country_boundary_us.plot(alpha = .5, ax = ax)
state_boundary_us.plot(cmap='Greys', ax=ax, alpha=.5)
pop_places.plot(ax=ax);

```

{:.output}
{:.display_data}

![png]({{ site.url }}//images/courses/earth-analytics-python/04-spatial-data/in-class/2018-02-05-spatial06-clip-vector-data-python_5_0.png)




In this case we have point locations that are outside of your study area which is the United States of America. But the data are all in the same projection. To make your analysis more efficient, you only want to include the points that are within the boundary of your study area. 

## Clip The Points Shapefile in Python Using Geopandas

To remove the points that are outside of your study area, you can clip the data. Removing or clipping data can make the data smaller and inturn plotting and analysis faster. 

<figure>
    <a href="{{ site.baseurl }}/images/courses/earth-analytics/spatial-data/vector-clip.png">
    <img src="{{ site.baseurl }}/images/courses/earth-analytics/spatial-data/vector-clip.png" alt="Clip vector data."></a>
    <figcaption> When you clip a vector data set with another layer, you remove points, lines or polygons that are outside of the spatial extent of the area that you use to clip the data. This images shows a circular clip region - you will be using a rectangular region in this example. Image Source: ESRI
    </figcaption>
</figure>

One way to clip a points layer is to:

1. Create a mask where every point that overlaps the polygon that you wish to clip to is set to true
2. Apply that mask to filter the geopandas dataframe.

To clip the data you first create a unified polygon object that represents the total area covered by your clip layer. If your study area contains only one polygon you can use `boundary.geometry[0]` to select the first (and only) polygon n the layer. You can also use `.unary_union` if you have many polygons in your clip boundary. `unary.union` will combine all of the polygons in your boundary layer into on vector object to use for clipping. Next you can use the `.intersects()` method to select just the points within the `pop_places` object that fall within the geometry in the `poly` object. 

The `.intersects()` method returns a boolean mask. Every point that is within the poly object is set to `True`. Points that do not fall within the boundary are set to `False`. Finally, you subset the `pop_places` object

`pop_places[pop_places.geometry.intersects(poly)]`

What will be returned are just the points that fall within the polygon region.  


{:.input}
```python
# "clip" a points layer to the boundary of a polygon
poly = country_boundary_us.geometry.unary_union
points_clip = pop_places[pop_places.geometry.intersects(poly)]
points_clip.head()
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
      <th>natscale</th>
      <th>labelrank</th>
      <th>featurecla</th>
      <th>name</th>
      <th>namepar</th>
      <th>namealt</th>
      <th>diffascii</th>
      <th>nameascii</th>
      <th>adm0cap</th>
      <th>...</th>
      <th>pop_other</th>
      <th>rank_max</th>
      <th>rank_min</th>
      <th>geonameid</th>
      <th>meganame</th>
      <th>ls_name</th>
      <th>ls_match</th>
      <th>checkme</th>
      <th>min_zoom</th>
      <th>geometry</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>175</th>
      <td>1</td>
      <td>300</td>
      <td>1</td>
      <td>Populated place</td>
      <td>San Francisco</td>
      <td></td>
      <td>San Francisco-Oakland</td>
      <td>0</td>
      <td>San Francisco</td>
      <td>0.0</td>
      <td>...</td>
      <td>27400</td>
      <td>12</td>
      <td>11</td>
      <td>5391959.0</td>
      <td>San Francisco-Oakland</td>
      <td>San Francisco1</td>
      <td>1</td>
      <td>0</td>
      <td>2.7</td>
      <td>POINT (-122.4171687735522 37.76919562968743)</td>
    </tr>
    <tr>
      <th>176</th>
      <td>1</td>
      <td>300</td>
      <td>1</td>
      <td>Admin-1 capital</td>
      <td>Denver</td>
      <td></td>
      <td>Denver-Aurora</td>
      <td>0</td>
      <td>Denver</td>
      <td>0.0</td>
      <td>...</td>
      <td>1521278</td>
      <td>12</td>
      <td>12</td>
      <td>5419384.0</td>
      <td>Denver-Aurora</td>
      <td>Denver</td>
      <td>1</td>
      <td>0</td>
      <td>3.7</td>
      <td>POINT (-104.9859618109682 39.7411339069655)</td>
    </tr>
    <tr>
      <th>177</th>
      <td>1</td>
      <td>300</td>
      <td>1</td>
      <td>Populated place</td>
      <td>Houston</td>
      <td></td>
      <td></td>
      <td>0</td>
      <td>Houston</td>
      <td>0.0</td>
      <td>...</td>
      <td>3607616</td>
      <td>12</td>
      <td>12</td>
      <td>4699066.0</td>
      <td>Houston</td>
      <td>Houston</td>
      <td>1</td>
      <td>0</td>
      <td>3.0</td>
      <td>POINT (-95.34192514914599 29.82192024318886)</td>
    </tr>
    <tr>
      <th>178</th>
      <td>1</td>
      <td>300</td>
      <td>1</td>
      <td>Populated place</td>
      <td>Miami</td>
      <td></td>
      <td></td>
      <td>0</td>
      <td>Miami</td>
      <td>0.0</td>
      <td>...</td>
      <td>1037811</td>
      <td>13</td>
      <td>10</td>
      <td>4164138.0</td>
      <td>Miami</td>
      <td>Miami</td>
      <td>1</td>
      <td>0</td>
      <td>2.1</td>
      <td>POINT (-80.22605193945003 25.78955655502153)</td>
    </tr>
    <tr>
      <th>179</th>
      <td>1</td>
      <td>300</td>
      <td>1</td>
      <td>Admin-1 capital</td>
      <td>Atlanta</td>
      <td></td>
      <td></td>
      <td>0</td>
      <td>Atlanta</td>
      <td>0.0</td>
      <td>...</td>
      <td>2874096</td>
      <td>12</td>
      <td>10</td>
      <td>4180439.0</td>
      <td>Atlanta</td>
      <td>Atlanta</td>
      <td>1</td>
      <td>0</td>
      <td>3.0</td>
      <td>POINT (-84.40189524187565 33.83195971260585)</td>
    </tr>
  </tbody>
</table>
<p>5 rows × 38 columns</p>
</div>





Now you can plot the data to see the newly "clipped" points layer. 

{:.input}
```python
# plot the data
fig, ax = plt.subplots(figsize  = (12, 8))
country_boundary_us.plot(alpha = 1, 
                         color="white", 
                         edgecolor = "black", 
                         ax = ax)
state_boundary_us.plot(cmap='Greys', 
                       ax=ax, 
                       alpha=.5)
points_clip.plot(ax=ax, 
                 column = 'name')
ax.set_axis_off()
plt.axis('equal');
# label each point
points_clip.apply(lambda x: ax.annotate(s=x['name'], 
                                        xy=x.geometry.coords[0], 
                                        xytext=(6, 6), textcoords="offset points", 
                                        backgroundcolor = "white"), 
                  axis=1);
```

{:.output}
{:.display_data}

![png]({{ site.url }}//images/courses/earth-analytics-python/04-spatial-data/in-class/2018-02-05-spatial06-clip-vector-data-python_9_0.png)




## Crop a Line or Polygon Layer to An Extent

The process for clipping a line or polygon layer is slightly different than clipping a set of points. To clip a line of polygon feature you will do the following:

1. Ensure that your polygon and line layer are in the same coordinate reference system
2. Identify what features in the lines layer fall WITHIN the boundary of the polygon layer
3. Subset the features within the geometry and reset the geometry of the newly clipped layer to be equal to the clipped data. 

This last step may seem unusual. When you clip data using shapely and geopandas the default behaviour is for it to only return the clipped geometry. However you may with to also retain the attributes associated with the geometry. This is where the `set_geometry()` methods comes into play.

For this example you will use the `country_boundary` layer and a clipped version of the natural earth 10m roads layer. * Import `ne_10m_n_america_roads.shp` into python. 
* Next, check to ensure that the roads and country boundary are in the same CRS. You may need to reproject the data.
* Because spatial operations take time, it's best if you subset your data as much as possible prior to clipping. 

{:.input}
```python
# open the roads layer
ne_roads = gpd.read_file('data/spatial-vector-lidar/global/ne_10m_roads/ne_10m_roads.shp')
# are both layers in the same CRS?
ne_roads.crs, country_boundary_us.crs
```

{:.output}
{:.execute_result}



    ({'init': 'epsg:4326'}, {'init': 'epsg:4326'})





## How to Clip Shapefiles in Python

In your dataset for this week you have 2 layers.

1. A global, natural earth roads layer and
2. A boundary for the United States.

The roads data are imported below. You imported the boundary layer above.  

If both layers are in the same CRS, you are ready to clip your data. Note that below you

1. `simplify` the clip geometry which is the United States boundary. You would want to carefully consider whether or not this step is approproiate for your analysis. You are only performing this step below to speed up the time it takes for python to perform the clip in this lesson.
2. subset the roads data to just the North American continent boundary - this further reduces the amount of data that you need to process. Subsetting is much faster than clipping.
3. clip the geometry using `.intersection()`
4. remove all rows in the geodataframe that have no geometry (this is explained below). 
5. update the original roads layer to contained only the clipped geometry

Note that below this process is run with a timer to demonstrate that it will take some time to run successfully. Without simplifying your geometry this intersection could take your computer 1 minute or longer. 

{:.input}
```python
import time
start = time.time()
# first simplify the clip geometry. 
simp_geom = country_boundary_us.simplify(.2, preserve_topology=True)
# subset to just the NA continent
na_roads = ne_roads[ne_roads['continent'] == "North America"]

# clip the roads layer to the sjer extent object
us_roads = na_roads.intersection(simp_geom.geometry[0])
# create boolean object for geometry that is not empty
valid_geom = us_roads.geometry.notnull()
# finally create a us roads only layer with updated, clipped geometry
us_roads_only = na_roads.loc[valid_geom].set_geometry(us_roads.geometry[valid_geom])
end = time.time()
print(end - start)
```

{:.output}
    11.880219221115112



Plot the cropped data. 

{:.input}
```python
# plot the data
fig, ax = plt.subplots(figsize  = (12, 8))
country_boundary_us.plot(alpha = 1, 
                         color="white", 
                         edgecolor = "black", 
                         ax = ax)
us_roads_only.plot(ax=ax)
ax.set_axis_off()
plt.axis('equal');
```

{:.output}
{:.display_data}

![png]({{ site.url }}//images/courses/earth-analytics-python/04-spatial-data/in-class/2018-02-05-spatial06-clip-vector-data-python_16_0.png)




Below the steps that you performed above to clip your data are explained. NOTE: the roads layer is for the entire United States. It may take a bit of time for this to run! To begin, look at the simplify function. The higher larger the tolerance that you use in this function, the fewer points or vertices will be kept in your geometry. This makes your shape appear "blockier" and is likely less accurate of a boundary layer. Conversely a smaller number will retain more points and will return a shape that is more true to your original polygon. 

{:.input}
```python
# a larger tolerance yields a blockier polygon
country_boundary_us.simplify(2, preserve_topology=True).plot();
```

{:.output}
{:.display_data}

![png]({{ site.url }}//images/courses/earth-analytics-python/04-spatial-data/in-class/2018-02-05-spatial06-clip-vector-data-python_18_0.png)




{:.input}
```python
# a smaller tolerance yields a smoother, but still simplified polygon 
country_boundary_us.simplify(.2, preserve_topology=True).plot();
```

{:.output}
{:.display_data}

![png]({{ site.url }}//images/courses/earth-analytics-python/04-spatial-data/in-class/2018-02-05-spatial06-clip-vector-data-python_19_0.png)




{:.input}
```python
# the simp_geom represents the country boundary with fewer vertices
simp_geom = country_boundary_us.simplify(.2, preserve_topology=True)
```

Next, you subset the data to just the roads that are in North America. Note that continent is an attribute field in your polygon geodataframe. Then you perform the intersection using the simplied geometry.

{:.input}
```python
# first subset the data to just the north american content (the less data you have the faster clipping will go)
na_roads = ne_roads[ne_roads['continent'] == "North America"]
# clip the roads layer to the sjer extent object- this step will take some time
us_roads = na_roads.intersection(simp_geom.geometry[0])
```

Finally, plot the data. 

{:.input}
```python
# plot the data
fig, ax = plt.subplots(figsize = (10,6))
us_roads.plot(ax=ax)
country_boundary_us.plot(ax=ax, 
                         color='none', 
                         edgecolor='black',
                         linewidth=3, zorder=10)

ax.set_axis_off()
plt.axis('equal');
```

{:.output}
{:.display_data}

![png]({{ site.url }}//images/courses/earth-analytics-python/04-spatial-data/in-class/2018-02-05-spatial06-clip-vector-data-python_24_0.png)




You can see above that `us_roads.head()` returns only geometry. There are no attributes associated with the newly clipped data. Further, rather than just returning the actual clipped lines, you get null values for any line segment that did not intersect the geometry, but that was in the original data.

{:.input}
```python
us_roads.head(5)
```

{:.output}
{:.execute_result}



    0                                                   ()
    1    LINESTRING Z (-100.5054284631781 42.8075293067...
    2    LINESTRING Z (-87.27431503977813 36.0243912267...
    3    LINESTRING Z (-87.72756620180824 44.1516534424...
    4    (LINESTRING Z (-74.75920259253698 39.143013260...
    dtype: object





To account for the null data, you can next, remove all rows containing empty geometry using `.notnull()`.

{:.input}
```python
# create boolean object for geometry that is not empty
valid_geom = us_roads.geometry.notnull()
valid_geom.head(6)
```

{:.output}
{:.execute_result}



    0    False
    1     True
    2     True
    3     True
    4     True
    5    False
    dtype: bool





You can use the boolean created above to subset the roads layer according to only the rows that have valid geometry. 

{:.input}
```python
# subset the roads data to only roads with geometry values
na_roads.loc[valid_geom].head()
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
      <td>LINESTRING (-100.5054284631781 42.807529306798...</td>
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
      <td>LINESTRING (-87.27431503977813 36.024391226761...</td>
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
      <td>LINESTRING (-87.72756620180824 44.151653442473...</td>
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
      <td>(LINESTRING (-74.75920259253698 39.14301326086...</td>
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
      <td>LINESTRING (-104.4509711456777 42.757168066572...</td>
    </tr>
  </tbody>
</table>
<p>5 rows × 32 columns</p>
</div>





Finally, you can use that subset and chain the `set_geometry()` function onto it to update the geometry of the original roads layer, with the new clipped layer. 

{:.input}
```python
# subset the data to the geometry that is "valid" or not empty
# then update the geometry to the clipped roads rather 
# than the entire road segments unclipped
us_roads_only = na_roads.loc[valid_geom].set_geometry(us_roads.geometry[valid_geom])
# now the attributes are reattached to the us roads layer
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





Finally you can plot the data. Notice that you now only have the road segments that fall within the US Country Boundary layer. 

{:.input}
```python
# plot the data
fig, ax = plt.subplots(figsize  = (12, 8))
country_boundary_us.plot(alpha = 1, 
                         color="white", 
                         edgecolor = "black", 
                         ax = ax)
us_roads_only.plot(ax=ax)
ax.set_axis_off()
plt.axis('equal');
```

{:.output}
{:.display_data}

![png]({{ site.url }}//images/courses/earth-analytics-python/04-spatial-data/in-class/2018-02-05-spatial06-clip-vector-data-python_34_0.png)




{:.input}
```python
us_roads_only[['type', 'geometry', 'level','name']].head()
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
      <th>type</th>
      <th>geometry</th>
      <th>level</th>
      <th>name</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>1</th>
      <td>Secondary Highway</td>
      <td>LINESTRING Z (-100.5054284631781 42.8075293067...</td>
      <td>Federal</td>
      <td>83</td>
    </tr>
    <tr>
      <th>2</th>
      <td>Secondary Highway</td>
      <td>LINESTRING Z (-87.27431503977813 36.0243912267...</td>
      <td>U/C</td>
      <td>840</td>
    </tr>
    <tr>
      <th>3</th>
      <td>Secondary Highway</td>
      <td>LINESTRING Z (-87.72756620180824 44.1516534424...</td>
      <td>Federal</td>
      <td>151</td>
    </tr>
    <tr>
      <th>4</th>
      <td>Major Highway</td>
      <td>(LINESTRING Z (-74.75920259253698 39.143013260...</td>
      <td>State</td>
      <td>GSP</td>
    </tr>
    <tr>
      <th>6</th>
      <td>Secondary Highway</td>
      <td>LINESTRING Z (-104.4509711456777 42.7571680665...</td>
      <td>Federal</td>
      <td>85</td>
    </tr>
  </tbody>
</table>
</div>





{:.input}
```python
# plot the data by attribute
fig, ax = plt.subplots(figsize  = (12, 8))
country_boundary_us.plot(alpha = 1, color="white", edgecolor = "black", ax = ax)
us_roads_only.plot(ax=ax, column='type', legend = True)
ax.set_axis_off()
plt.axis('equal');
```

{:.output}
{:.display_data}

![png]({{ site.url }}//images/courses/earth-analytics-python/04-spatial-data/in-class/2018-02-05-spatial06-clip-vector-data-python_36_0.png)




{:.input}
```python
# make it a bit nicer using a dictionary to assign colors and line widths
road_attrs = {'Beltway': ['black',2], 
               'Secondary Highway': ['grey',.5],
               'Road': ['grey',.5],
               'Bypass': ['grey', .5], 
               'Ferry Route': ['grey', .5], 
               'Major Highway': ['black', 1]}

# plot the data
fig, ax = plt.subplots(figsize  = (12, 8))

for ctype, data in us_roads_only.groupby('type'):
    data.plot(color=road_attrs[ctype][0], 
              label = ctype,
              ax = ax, 
              linewidth=road_attrs[ctype][1])

country_boundary_us.plot(alpha = 1, color="white", edgecolor = "black", ax = ax)
ax.legend(frameon=False)
ax.set_title("United States Roads by Type", fontsize=25)
ax.set_axis_off()
plt.axis('equal');
```

{:.output}
{:.display_data}

![png]({{ site.url }}//images/courses/earth-analytics-python/04-spatial-data/in-class/2018-02-05-spatial06-clip-vector-data-python_37_0.png)




### Clip a Spatial Layer to Shapefile Extent in Python

Above you clipped a geometry to the exact geometry of another polygon object. You can also clip data to the overall spatial extent of the shapefile. Remember that the spatial extent represents the total geographic area (min x, min y, max x and max y) that the shapefile covers. This object is a rectangle or a box.


To clip the data to the total extent, you first need to create a clip box from the boundary of the spatial layer. In this case we are using the sjer_aoi layer. 

First extract the boundary values (xmin,xmax, ymin,ymax) from the sjer_aoi layer using the syntax:

`box(*country_boundary_us.total_bounds)`

Note that the `*` in the code above expands the x and y min and max values of the sjer_aoi spatial extent so that python can turn them into the extent for a box.

this code is the same as using

`#xmin, xmax, ymin, ymax = country_boundary_us.total_bounds`

To create a clip boundary, you can use the same total_bounds attribute that you used above. however this time, you will create a spatial object - a box that you will use to clip the data. 

The example below crops the roads layer to a polygon. You can do this with geopandas.
You have to handle points separately. 

{:.input}
```python
# view country boundary total bounds (the spatial extent of the layer)
country_boundary_us.total_bounds

# create bounds object
bounds = box(*country_boundary_us.total_bounds)
```

You can be even more concise with your code too. Embed creating the box object with out intersection function


{:.input}
```python
ne_roads["geometry"] = ne_roads.geometry.intersection(box(*country_boundary_us.total_bounds))
# finally plot the output using geopandas .plot
fig, ax = plt.subplots(figsize=(10, 10))

country_boundary_us.plot(alpha = 1, 
                         color="white", 
                         edgecolor = "black", 
                         ax = ax,
                        linewidth=2)
ne_roads.plot(ax=ax)
ax.set_axis_off()
plt.axis('equal');
```

{:.output}
{:.display_data}

![png]({{ site.url }}//images/courses/earth-analytics-python/04-spatial-data/in-class/2018-02-05-spatial06-clip-vector-data-python_41_0.png)



