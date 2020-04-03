---
layout: single
title: "Clip a spatial vector layer in Python using Shapely & GeoPandas: GIS in Python"
excerpt: "Sometimes you may want to spatially clip a vector data layer to a specified boundary for easier plotting and analysis of smaller spatial areas. Learn how to clip a vector data layer in Python using GeoPandas and Shapely."
authors: ['Leah Wasser', 'Martha Morrissey']
dateCreated: 2018-02-05
modified: 2020-03-06
category: [courses]
class-lesson: ['vector-processing-python']
permalink: /courses/use-data-open-source-python/intro-vector-data-python/vector-data-processing/clip-vector-data-in-python-geopandas-shapely/
nav-title: 'Clip Vector Data'
course: 'intermediate-earth-data-science-textbook'
week: 2
sidebar:
  nav:
author_profile: false
comments: true
order: 3
topics:
  spatial-data-and-gis: ['vector-data']
redirect_from:
  - "/courses/earth-analytics-python/spatial-data-vector-shapefiles/clip-vector-data-in-python-geopandas-shapely/"
---

{% include toc title="On This Page" icon="file-text" %}

<div class='notice--success' markdown="1">

## <i class="fa fa-graduation-cap" aria-hidden="true"></i> Learning Objectives

* Clip a spatial vector point and line layer to the spatial extent of a polygon layer in **Python** using **geopandas**.
* Plot data with custom legends.

</div>


## How to Clip Vector Data in Python


### What Is Clipping or Cropping Data?
When you clip or crop spatial data you are removing the data outside of the clip extent. 
This means that your clipped dataset will be SMALLER (have a smaller spatial extent) than the original dataset.
This also means that objects in the data such as polygons or lines will be CUT based on the boundary of the clip object.

<figure>
    <a href="{{ site.baseurl }}/images/earth-analytics/spatial-data/spatial-extent.png">
    <img src="{{ site.baseurl }}/images/earth-analytics/spatial-data/spatial-extent.png" alt="the spatial extent represents the spatial area that a particular dataset covers."></a>
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

In this lesson you will find examples of how to clip point and line data using geopandas. At the bottom of the lesson you will see a set of functions that can be used to clip the data in just one line of code. This lesson explains how those functions are built. 

{:.input}
```python
# Import libraries
import os
import numpy as np
import matplotlib.pyplot as plt
import matplotlib.lines as mlines
from matplotlib.colors import ListedColormap
import geopandas as gpd

# Load the box module from shapely to create box objects
from shapely.geometry import box
import earthpy as et
from earthpy import clip as cl
import seaborn as sns

# Ignore warning about missing/empty geometries
import warnings
warnings.filterwarnings('ignore', 'GeoSeries.notna', UserWarning)

# Adjust plot font sizes
sns.set(font_scale=1.5)
sns.set_style("white")

# Set working dir & get data
data = et.data.get_data('spatial-vector-lidar')
os.chdir(os.path.join(et.io.HOME, 'earth-analytics'))
```

## How to Clip Shapefiles in Python

In your dataset for this week you have 3 layers:

1. A country boundary for the USA and
2. A state boundary layer for the USA and 
3. Populated places in the USA

The data are imported and plotted below. Notice that there are points outside of your study area which is the continental USA. Your goal is the clip the points out that you NEED for your project - the points that overlay on top of the continental United States.

{:.input}
```python
# Import all of your data at the top of your notebook to keep things organized.
country_boundary_us_path = os.path.join("data", "spatial-vector-lidar", 
                                        "usa", "usa-boundary-dissolved.shp")
country_boundary_us = gpd.read_file(country_boundary_us_path)

state_boundary_us_path = os.path.join("data", "spatial-vector-lidar", 
                                      "usa", "usa-states-census-2014.shp")
state_boundary_us = gpd.read_file(state_boundary_us_path)

pop_places_path = os.path.join("data", "spatial-vector-lidar", "global", 
                               "ne_110m_populated_places_simple", "ne_110m_populated_places_simple.shp")
pop_places = gpd.read_file(pop_places_path)

# Are the data all in the same crs?
print("country_boundary_us", country_boundary_us.crs)
print("state_boundary_us", state_boundary_us.crs)
print("pop_places", pop_places.crs)
```

{:.output}
    country_boundary_us {'init': 'epsg:4326'}
    state_boundary_us {'init': 'epsg:4326'}
    pop_places {'init': 'epsg:4326'}




{:.input}
```python
# Plot the data
fig, ax = plt.subplots(figsize=(12, 8))

country_boundary_us.plot(alpha=.5,
                         ax=ax)

state_boundary_us.plot(cmap='Greys',
                       ax=ax,
                       alpha=.5)
pop_places.plot(ax=ax)

plt.axis('equal')
ax.set_axis_off()
plt.show()
```

{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}/images/courses/intermediate-earth-data-science-textbook/02-intro-vector/vector-processing-python/2018-02-05-spatial06-clip-vector-data-python/2018-02-05-spatial06-clip-vector-data-python_6_0.png" alt = "Plot showing populated places for the entire globe overlayed on top of the Continental United States. If your study area is the USA, then you might not need all of the additional points. In this instance, you can clip or crop your data.">
<figcaption>Plot showing populated places for the entire globe overlayed on top of the Continental United States. If your study area is the USA, then you might not need all of the additional points. In this instance, you can clip or crop your data.</figcaption>

</figure>




## Clip The Points Shapefile in Python Using Geopandas

To remove the points that are outside of your study area, you can clip the data. Removing or clipping data can make the data smaller and inturn plotting and analysis faster. 

<figure>
    <a href="{{ site.url }}/images/earth-analytics/spatial-data/vector-clip.png">
    <img src="{{ site.url }}/images/earth-analytics/spatial-data/vector-clip.png" alt="Clip vector data."></a>
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


The process for clipping points, lines and polygons is different. However, to streamline things, for this class, your instructor has created a `clip_shp()` function that you imported above as a module to use in this lesson.

`import clip_data`

If you wanted to clip data using geopandas you use the `.intersection()` method as follows:

```python
# "clip" a points layer to the boundary of a polygon
poly = country_boundary_us.geometry.unary_union
points_clip = pop_places[pop_places.geometry.intersects(poly)]
```

However if you use the `clip_shp()` shape function, it will take care of all of these steps for you.
Clip shape takes two arguments:

* shp: the vector layer (point, line or polygon) that you wish to clip and
* clip_obj: the polygon that you wish to use to clip your data

`clip_shp()` will clip the data to the boundary of the polygon layer that you select. If there are multiple polygons in your clip_obj object, `clip_shp()` will clip the data to the total boundary of all polygons in the layer.

{:.input}
```python
# Clip the data using the clip_data module
points_clip = cl.clip_shp(pop_places, country_boundary_us)

# View the first 6 rows and a few select columns
points_clip[['name', 'geometry', 'scalerank', 'natscale', ]].head()
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
      <th>name</th>
      <th>geometry</th>
      <th>scalerank</th>
      <th>natscale</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>175</th>
      <td>San Francisco</td>
      <td>POINT (-122.41717 37.76920)</td>
      <td>1</td>
      <td>300</td>
    </tr>
    <tr>
      <th>176</th>
      <td>Denver</td>
      <td>POINT (-104.98596 39.74113)</td>
      <td>1</td>
      <td>300</td>
    </tr>
    <tr>
      <th>177</th>
      <td>Houston</td>
      <td>POINT (-95.34193 29.82192)</td>
      <td>1</td>
      <td>300</td>
    </tr>
    <tr>
      <th>178</th>
      <td>Miami</td>
      <td>POINT (-80.22605 25.78956)</td>
      <td>1</td>
      <td>300</td>
    </tr>
    <tr>
      <th>179</th>
      <td>Atlanta</td>
      <td>POINT (-84.40190 33.83196)</td>
      <td>1</td>
      <td>300</td>
    </tr>
  </tbody>
</table>
</div>





Now you can plot the data to see the newly "clipped" points layer. 

{:.input}
```python
# Plot the data
fig, ax = plt.subplots(figsize=(12, 8))

country_boundary_us.plot(alpha=1,
                         color="white",
                         edgecolor="black",
                         ax=ax)

state_boundary_us.plot(cmap='Greys',
                       ax=ax,
                       alpha=.5)

points_clip.plot(ax=ax,
                 column='name')
ax.set_axis_off()
plt.axis('equal')

# Label each point - note this is just shown here optionally but is not required for your homework
points_clip.apply(lambda x: ax.annotate(s=x['name'],
                                        xy=x.geometry.coords[0],
                                        xytext=(6, 6), textcoords="offset points",
                                        backgroundcolor="white"),
                  axis=1)
plt.show()
```

{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}/images/courses/intermediate-earth-data-science-textbook/02-intro-vector/vector-processing-python/2018-02-05-spatial06-clip-vector-data-python/2018-02-05-spatial06-clip-vector-data-python_10_0.png" alt = "Once you have clipped the points layer to your USA extent, you have fewer points to work with. This will make processing your data more efficient.">
<figcaption>Once you have clipped the points layer to your USA extent, you have fewer points to work with. This will make processing your data more efficient.</figcaption>

</figure>




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
# Open the roads layer
ne_roads_path = os.path.join("data", "spatial-vector-lidar", "global", 
                             "ne_10m_roads", "ne_10m_roads.shp")
ne_roads = gpd.read_file(ne_roads_path)

# Are both layers in the same CRS?
if (ne_roads.crs == country_boundary_us.crs):
    print("Both layers are in the same crs!",
          ne_roads.crs, country_boundary_us.crs)
```

{:.output}
    Both layers are in the same crs! {'init': 'epsg:4326'} {'init': 'epsg:4326'}



## How to Clip Lines and Polygons in Python

In your dataset for this week you have 2 layers.

1. A global, natural earth roads layer and
2. A boundary for the United States.

The roads data are imported below. You imported the boundary layer above.  


If both layers are in the same CRS, you are ready to clip your data. Because the clip functions are new and little testing has been done with them, you will see all of the lines of code required to clip your data. However you can use the `clip_shp()` function to clip your data for this week's class! 

Be patient while your clip code below runs. 



To make your code run faster, you can simplify the geometry of your country boundary. Simplify should be used with caution as it does modify your data.

{:.input}
```python
# Simplify the geometry of the clip extent for faster processing
# Use this with caution as it modifies your data.
country_boundary_us_sim = country_boundary_us.simplify(
    .2, preserve_topology=True)
```

Clip and plot the data. Be patient. It may take up to a minute to clip the data. 

{:.input}
```python
# Clip data
ne_roads_clip = cl.clip_shp(ne_roads, country_boundary_us_sim)

# Ignore missing/empty geometries
ne_roads_clip = ne_roads_clip[~ne_roads_clip.is_empty]

print("The clipped data have fewer line objects (represented by rows):",
      ne_roads_clip.shape, ne_roads.shape)
```

{:.output}
    The clipped data have fewer line objects (represented by rows): (7346, 32) (56601, 32)



{:.input}
```python
fig, (ax1, ax2) = plt.subplots(2, 1, figsize=(10, 10))

ne_roads.plot(ax=ax1)
ne_roads_clip.plot(ax=ax2)

ax1.set_title("Unclipped roads")
ax2.set_title("Clipped roads")

ax1.set_axis_off()
ax2.set_axis_off()

plt.axis('equal')
plt.show()
```

{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}/images/courses/intermediate-earth-data-science-textbook/02-intro-vector/vector-processing-python/2018-02-05-spatial06-clip-vector-data-python/2018-02-05-spatial06-clip-vector-data-python_22_0.png" alt = "Clipped vs unclipped roads layer. ">
<figcaption>Clipped vs unclipped roads layer. </figcaption>

</figure>






Plot the cropped data. 

{:.input}
```python
# Plot the data
fig, ax = plt.subplots(figsize=(12, 8))

country_boundary_us.plot(alpha=1,
                         color="white",
                         edgecolor="black",
                         ax=ax)

ne_roads_clip.plot(ax=ax)

ax.set_axis_off()
plt.axis('equal')
plt.show()
```

{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}/images/courses/intermediate-earth-data-science-textbook/02-intro-vector/vector-processing-python/2018-02-05-spatial06-clip-vector-data-python/2018-02-05-spatial06-clip-vector-data-python_26_0.png" alt = "Final plot showing the clipped roads drawn on top of the country boundary. Notice that there are no road segments outside of the country boundary.">
<figcaption>Final plot showing the clipped roads drawn on top of the country boundary. Notice that there are no road segments outside of the country boundary.</figcaption>

</figure>




<div class="notice" markdown="1">
<i class="fa fa-star"></i>**How Clip_shp() works:** 

Here are the steps involved with clipping data in geopandas - these steps are completed when you use the `clip_shp()` function which is provided to you as a `.py` script that you can import into this lesson as a module. They are simply described below just in case you ever need to clip data in python and that function doesn't work for you.

1. Subset the roads data using a spatial index.
1. Clip the geometry using `.intersection()`
1. Remove all rows in the geodataframe that have no geometry (this is explained below). 
1. Update the original roads layer to contained only the clipped geometry


```python
# Create a single polygon object for clipping
poly = clip_obj.geometry.unary_union
spatial_index = shp.sindex

# Create a box for the initial intersection
bbox = poly.bounds
# Get a list of id's for each road line that overlaps the bounding box and subset the data to just those lines
sidx = list(spatial_index.intersection(bbox))
shp_sub = shp.iloc[sidx]

# Clip the data - with these data
clipped = shp_sub.copy()
clipped['geometry'] = shp_sub.intersection(poly)

# Return the clipped layer with no null geometry values
final_clipped = clipped[clipped.geometry.notnull()]
```
</div>

## What Does Simplify Do?

{:.input}
```python
fig, (ax1, ax2) = plt.subplots(2, 1, figsize=(10, 10))

# Set a larger tolerance yields a blockier polygon
country_boundary_us.simplify(2, preserve_topology=True).plot(ax=ax1)

# Set  a larger tolerance yields a blockier polygon
country_boundary_us.simplify(.2, preserve_topology=True).plot(ax=ax2)

ax1.set_title(
    "Data with a higher tolerance value will become visually blockier as there are fewer vertices")
ax2.set_title(
    "Data with a very low tolerance value will look smoother but will take longer to process")

ax1.set_axis_off()
ax2.set_axis_off()
plt.show()
```

{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}/images/courses/intermediate-earth-data-science-textbook/02-intro-vector/vector-processing-python/2018-02-05-spatial06-clip-vector-data-python/2018-02-05-spatial06-clip-vector-data-python_29_0.png" alt = "Simplify removes vertices or points from a complex object effectively smoothing the data. Use this method with caution as it will impact any outcome statistics of your data.">
<figcaption>Simplify removes vertices or points from a complex object effectively smoothing the data. Use this method with caution as it will impact any outcome statistics of your data.</figcaption>

</figure>




{:.input}
```python
# Plot the data by attribute
fig, ax = plt.subplots(figsize=(12, 8))

country_boundary_us.plot(alpha=1, 
                         color="white", 
                         edgecolor="black", 
                         ax=ax)

ne_roads_clip.plot(ax=ax, 
                   column='type', 
                   legend=True)
ax.set_axis_off()
plt.axis('equal')
plt.show()
```

{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}/images/courses/intermediate-earth-data-science-textbook/02-intro-vector/vector-processing-python/2018-02-05-spatial06-clip-vector-data-python/2018-02-05-spatial06-clip-vector-data-python_30_0.png" alt = "The final clipped roads layer. When you use the default pandas plotting, your legend will have circles for each attribute type. If you want to represent line data using lines in the legend, then you will need to create a custom plot and legend as demonstrated below.">
<figcaption>The final clipped roads layer. When you use the default pandas plotting, your legend will have circles for each attribute type. If you want to represent line data using lines in the legend, then you will need to create a custom plot and legend as demonstrated below.</figcaption>

</figure>






Below, you create a custom legend. There are many different approaches to this. One is below.

To begin you create a python dictionary for each attribute value in your legend. Below you will see each road type has a dictionary entry and two associated values - a color and a number representing the width of the line in your legend.

`'Beltway': ['black', 2]` Color the line for beltway black with a line width of 2.

Next you loop through the dictionary to plot the data. In the loop below, you select each attribute value, and plot it using the color and line width assigned in the dictionary above. 

```python
for ctype, data in ne_roads_clip.groupby('type'):
    data.plot(color=road_attrs[ctype][0],
              label=ctype,
              linewidth=road_attrs[ctype][1],
              ax=ax)
```
Finally, a call to `ax.legend()` renders the legend using the colors applied in the loop above.

{:.input}
```python
# Plot with a custom legend

# First, create a dictionary with the attributes of each legend item
road_attrs = {'Beltway': ['black', 2],
              'Secondary Highway': ['grey', .5],
              'Road': ['grey', .5],
              'Bypass': ['grey', .5],
              'Ferry Route': ['grey', .5],
              'Major Highway': ['black', 1]}

# Plot the data
fig, ax = plt.subplots(figsize=(12, 8))

for ctype, data in ne_roads_clip.groupby('type'):
    data.plot(color=road_attrs[ctype][0],
              label=ctype,
              ax=ax,
              linewidth=road_attrs[ctype][1])

country_boundary_us.plot(alpha=1, color="white", edgecolor="black", ax=ax)

ax.legend(frameon=False, 
          loc = (0.1, -0.1))

ax.set_title("United States Roads by Type", fontsize=25)
ax.set_axis_off()

plt.axis('equal')
plt.show()
```

{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}/images/courses/intermediate-earth-data-science-textbook/02-intro-vector/vector-processing-python/2018-02-05-spatial06-clip-vector-data-python/2018-02-05-spatial06-clip-vector-data-python_34_0.png" alt = "Currently geopandas does not support too much customization of plot legends. Thus if you want to create a custom legend, you will need to create a dictionary of colors and other legend attributes that you'll need to create the custom legend.">
<figcaption>Currently geopandas does not support too much customization of plot legends. Thus if you want to create a custom legend, you will need to create a dictionary of colors and other legend attributes that you'll need to create the custom legend.</figcaption>

</figure>













