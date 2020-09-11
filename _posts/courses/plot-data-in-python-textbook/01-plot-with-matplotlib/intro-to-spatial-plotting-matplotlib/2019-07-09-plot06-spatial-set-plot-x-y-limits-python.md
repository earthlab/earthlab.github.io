---
layout: single
title: "Customize your Maps in Python: GIS in Python"
excerpt: "In this lesson you will learn how to adjust the x and y limits of your matplotlib and geopandas map to change the spatial extent.."
authors: ['Chris Holdgraf', 'Leah Wasser']
modified: 2020-09-10
category: [courses]
class-lesson: ['hw-custom-maps-python']
permalink: /courses/earth-analytics-python/spatial-data-vector-shapefiles/python-change-spatial-extent-of-map-matplotlib-geopandas/
nav-title: 'Adjust Map Extent'
course: 'earth-analytics-python'
week: 4
sidebar:
  nav:
author_profile: false
comments: true
order: 2
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

{% include/data_subsets/course_earth_analytics/_data-spatial-lidar.md %}


</div>


In this lesson, you will learn how to spatially clip data for easier plotting and analysis of smaller spatial areas. You will use the `geopandas` library and the `box` module from the `shapely` library. 

{:.input}
```python
# Import libraries
import os
import numpy as np
import matplotlib.pyplot as plt
import geopandas as gpd
import earthpy as et

# Get the data
data = et.data.get_data('spatial-vector-lidar')

os.chdir(os.path.join(et.io.HOME, 'earth-analytics'))
```

{:.output}
    Downloading from https://ndownloader.figshare.com/files/12459464
    Extracted output to /root/earth-analytics/data/spatial-vector-lidar/.



{:.input}
```python
# Read in necessary files 
sjer_aoi = gpd.read_file(
    "data/spatial-vector-lidar/california/neon-sjer-site/vector_data/SJER_crop.shp")
country_boundary_us = gpd.read_file("data/spatial-vector-lidar/usa/usa-boundary-dissolved.shp")
ne_roads = gpd.read_file("data/spatial-vector-lidar/global/ne_10m_roads/ne_10m_n_america_roads.shp")
```



## Change the Spatial Extent of a Plot in Python

Above you modified your data by clipping it. This is useful when you want to 

1. Make your data smaller to speed up processing and reduce file size
2. Make analysis simpler and faster given less data to work with.

However, if you just want to plot the data, you can consider adjusting the spatial extent of a plot to "zoom in". Note that zooming in on a plot **does not change your data in any way** - it just changes how your plot renders!

To zoom in on a region of your plot, you first need to grab the spatial extent of the object 

{:.input}
```python
# Get spatial extent  - to zoom in on the map rather than clipping
aoi_bounds = sjer_aoi.geometry.total_bounds
aoi_bounds
```

{:.output}
{:.execute_result}



    array([ 254570.567     , 4107303.07684455,  258867.40933092,
           4112361.92026107])





The `total_bounds` attribute represents the total spatial extent for the aoi layer. This is the total external boundary of the layer - thus if there are multiple polygons in the layer it will take the furtherst edge in the north, south, east and west directions to create the spatial extent box. 

<figure>
    <a href="{{ site.baseurl }}/images/courses/earth-analytics/spatial-data/spatial-extent.png">
    <img src="{{ site.baseurl }}/images/courses/earth-analytics/spatial-data/spatial-extent.png" alt="the spatial extent represents the spatial area that a particular dataset covers."></a>
    <figcaption>The spatial extent of a shapefile or `Python` spatial object like a `geopandas` `geodataframe` represents
    the geographic "edge" or location that is the furthest north, south east and
    west. Thus is represents the overall geographic coverage of the spatial object.
    Image Source: National Ecological Observatory Network (NEON)
    </figcaption>
</figure>

The object that is returned is a tuple - a non editable object containing 4 values:
`(xmin, ymin, xmax, ymax)`. If you want you can assign each value to a new variable as follows

{:.input}
```python
# Create x and y min and max objects to use in the plot boundaries
xmin, ymin, xmax, ymax = aoi_bounds
```

{:.input}
```python
fig, ax = plt.subplots(figsize  = (14, 6))
country_boundary_us.plot(alpha = .5, ax = ax)
ne_roads.plot(color='purple', ax=ax, alpha=.5)
ax.set(title='Natural Earth Global Roads Layer')
ax.set_axis_off()
plt.axis('equal')
plt.show()
```

{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}/images/courses/plot-data-in-python-textbook/01-plot-with-matplotlib/intro-to-spatial-plotting-matplotlib/2019-07-09-plot06-spatial-set-plot-x-y-limits-python/2019-07-09-plot06-spatial-set-plot-x-y-limits-python_8_0.png" alt = "Plot of major North American roads in Canada, the United States, and Mexico, plotted on top of the boundary of the United States.">
<figcaption>Plot of major North American roads in Canada, the United States, and Mexico, plotted on top of the boundary of the United States.</figcaption>

</figure>




You can set the x and **ylim**its of the plot using the x and y min and max values from your bounds object that you created above to zoom in your map. 

{:.input}
```python
# Use the country boundary to set the min and max values for the plot
country_boundary_us.total_bounds
```

{:.output}
{:.execute_result}



    array([-124.725839,   24.498131,  -66.949895,   49.384358])





Notice in the plot below, you can still see roads that fall outside of the US Boundary area but are within the rectangular spatial extent of the boundary layer. Hopefully this helps you better understand the difference between clipping the data to a polygon shape vs simply plotting a small geographic region. 

{:.input}
```python
# Plot the data with a modified spatial extent
fig, ax = plt.subplots(figsize = (10,6))
xlim = ([country_boundary_us.total_bounds[0],  country_boundary_us.total_bounds[2]])
ylim = ([country_boundary_us.total_bounds[1],  country_boundary_us.total_bounds[3]])

ax.set_xlim(xlim)
ax.set_ylim(ylim)

country_boundary_us.plot(alpha = .5, ax = ax)
ne_roads.plot(color='purple', ax=ax, alpha=.5)

ax.set(title='Natural Earth Global Roads \n Zoomed into the United States')
ax.set_axis_off()
plt.show()
```

{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}/images/courses/plot-data-in-python-textbook/01-plot-with-matplotlib/intro-to-spatial-plotting-matplotlib/2019-07-09-plot06-spatial-set-plot-x-y-limits-python/2019-07-09-plot06-spatial-set-plot-x-y-limits-python_12_0.png" alt = "Plot of major North American roads in Canada, the United States, and Mexico, plotted on top of the boundary of the United States. The extent is set so you can only see the United States.">
<figcaption>Plot of major North American roads in Canada, the United States, and Mexico, plotted on top of the boundary of the United States. The extent is set so you can only see the United States.</figcaption>

</figure>



