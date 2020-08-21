---
layout: single
title: "Customize Map Extents in Python: GIS in Python"
excerpt: "When making maps, sometimes you want to zoom in to a specific area in your map. Learn how to adjust the x and y limits of your matplotlib and geopandas map to change the spatial extent that is displayed."
authors: ['Chris Holdgraf', 'Leah Wasser']
dateCreated: 2018-02-05
modified: 2020-07-21
category: [courses]
class-lesson: ['hw-custom-maps-python-tb']
permalink: /courses/scientists-guide-to-plotting-data-in-python/plot-spatial-data/customize-vector-plots/python-change-spatial-extent-of-map-matplotlib-geopandas/
nav-title: 'Adjust Map Extent'
course: 'scientists-guide-to-plotting-data-in-python-textbook'
week: 2
sidebar:
  nav:
author_profile: false
comments: true
order: 3
topics:
  reproducible-science-and-programming:
  data-exploration-and-analysis: ['data-visualization']
  spatial-data-and-gis: ['vector-data']
redirect_from:
  - "/courses/earth-analytics-python/spatial-data-vector-shapefiles/python-change-spatial-extent-of-map-matplotlib-geopandas/"
---

{% include toc title="On This Page" icon="file-text" %}

<div class='notice--success' markdown="1">

## <i class="fa fa-graduation-cap" aria-hidden="true"></i> Learning Objectives

* Visually "clip" or zoom in to a particular spatial extent in a plot.

</div>

### Import Packages and Data

Begin by importing the necessary packages including **geopandas** to import the vector data and **matplotlib** to create the map. 

{:.input}
```python
# Import libraries
import os
import matplotlib.pyplot as plt
import geopandas as gpd
import earthpy as et

# Get the data & set working dir
data = et.data.get_data('spatial-vector-lidar')
os.chdir(os.path.join(et.io.HOME, 'earth-analytics'))
```

{:.input}
```python
# Read in necessary files 
data_path = os.path.join("data", "spatial-vector-lidar")

sjer_aoi = gpd.read_file(os.path.join(data_path, "california" , 
                                      "neon-sjer-site", 
                                      "vector_data", "SJER_crop.shp"))

country_boundary_us = gpd.read_file(os.path.join(data_path, "usa", 
                                                 "usa-boundary-dissolved.shp"))

ne_roads = gpd.read_file(os.path.join(data_path, "global", 
                                      "ne_10m_roads", "ne_10m_n_america_roads.shp"))
```

## Change the Spatial Extent of a Plot in Python

Sometimes you modify your data by clipping it to a specified boundary. This is useful when you want to: 

1. Make your data smaller to speed up processing and reduce file size.
2. Make analysis simpler and faster given less data to work with.

However, if you just want to plot the data, you can consider adjusting the spatial extent of a plot to "zoom in".

Note that zooming in on a plot **does not change your data in any way** - it just changes how your plot renders!

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
    <a href="{{ site.url }}/images/earth-analytics/spatial-data/spatial-extent.png">
    <img src="{{ site.url }}/images/earth-analytics/spatial-data/spatial-extent.png" alt="The spatial extent represents the spatial area that a particular dataset covers."></a>
    <figcaption>The spatial extent of a shapefile or Python spatial object like a geopandas geodataframe represents the geographic edge or location that is the furthest north, south, east and
    west. This is the overall geographic coverage of the spatial object.
    Source: National Ecological Observatory Network (NEON)
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
fig, ax = plt.subplots(figsize=(14,6))

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

<img src = "{{ site.url }}/images/courses/plot-data-in-python-textbook/02-plot-spatial-data/vector-plots/2018-02-05-plot03-set-plot-x-y-limits-python/2018-02-05-plot03-set-plot-x-y-limits-python_8_0.png" alt = "Plot showing the North American roads overlaid on the continental US without x and y limits being set.">
<figcaption>Plot showing the North American roads overlaid on the continental US without x and y limits being set.</figcaption>

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

<img src = "{{ site.url }}/images/courses/plot-data-in-python-textbook/02-plot-spatial-data/vector-plots/2018-02-05-plot03-set-plot-x-y-limits-python/2018-02-05-plot03-set-plot-x-y-limits-python_12_0.png" alt = "Plot showing the North American roads overlaid on the continental US with x and y limits being set to the extent of the US layer.">
<figcaption>Plot showing the North American roads overlaid on the continental US with x and y limits being set to the extent of the US layer.</figcaption>

</figure>



