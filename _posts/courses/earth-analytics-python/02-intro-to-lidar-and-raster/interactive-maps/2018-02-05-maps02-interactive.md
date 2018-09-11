---
layout: single
title: "Interactive Maps in Python"
excerpt: "This lesson covers creating interactive maps with Python in Jupyter Notebook."
authors: ['Leah Wasser', 'Martha Morrissey', 'Carson Farmer',  'Max Joseph']
modified: 2018-09-10
category: [courses]
class-lesson: ['hw-lidar']
permalink: /courses/earth-analytics-python/lidar-raster-data/interactive-maps/
nav-title: 'Interactive Maps'
week: 2
sidebar:
  nav:
author_profile: false
comments: true
course: "earth-analytics-python"
order: 2
topics:
  data-exploration-and-analysis: ['data-visualization']
  spatial-data-and-gis:
  reproducible-science-and-programming: ['jupyter-notebook']
---

{% include toc title="In This Lesson" icon="file-text" %}

This tutorial walks you through how to create interactive maps with `Python` in `Jupyter Notebook` using the `folium` package and how to overlay a raster on an interactive map created with `folium`. 

<div class='notice--success' markdown="1">

## <i class="fa fa-graduation-cap" aria-hidden="true"></i> Learning Objectives

After completing this tutorial, you will be able to:

* Create interactive map in `Jupyter Notebook` using the `folium` package for `Python`
* Overlay a raster on an interactive map created with `folium` 

## <i class="fa fa-check-square-o fa-2" aria-hidden="true"></i> What You Need

You will need a computer with internet access to complete this lesson.

</div>

## Why Use Interactive Maps

Interactive Maps are useful for earth data science because they: 

* Clearly convey complex information
* Are more engaging for viewers than static maps 
* Can be seamlessly integrated into `Jupyter Notebooks` 

There are two great `Python` packages for creating interactive maps: `folium` and `mapboxgl`. Both of these packages are build on top off the `javascript` library called `leaflet.js`. 

This lesson will focus on `folium`, which has been around longer than `mapboxgl` and thus, is well-documented by the `Python` community. 

One major difference between the two packages is that `mapboxgl` requires a MapBox Access Token. If you are interested in exploring `mapboxgl` on your own, note that the MapBox Access token is free to use, but does require making an account with MapBox. You can find more information on the <a href="https://github.com/mapbox/mapboxgl-jupyter" target="_blank">Github page for this package</a>.


## What is an API?

An API (or application programming interface) is an interface that opens a computer-based system to external requests and simplifies certain tasks, such as extracting subsets of data from a large repository or database. 

For example, web-based APIs allow you to access data available using web-based interfaces that are separate from the API that you are accessing. Thus, web APIs are a way to avoid the extraneous visual interfaces that you do not need and get the desired data into the tool that you want to use. 

Often, you access data from web-based APIs using a URL that contains sets of parameters that specifies the type and particular subset of data that you are interested in. You will learn more about using APIs later in this course. 

For this lesson, you simply need to know that the basemaps that you will access to create your interactive maps come from APIs that are provided by various organizations such as OpenStreetMap, MapBox, Stamen, Google, etc. 

{:.input}
```python
# Set working directory to earth-analytics
os.chdir(os.path.join(et.io.HOME, 'earth-analytics'))
```

## Simple Basemap

You can make an interactive map with `folium` using just one line of code! 

You can use the `Map()` function from `folium` and providing a latitude and longitude to center the map. The map is created using the default basemap from OpenStreetMap.

{:.input}
```python
# Create a map using the Map() function and the coordinates for Boulder, CO
m = folium.Map(location=[40.0150, -105.2705])

# Display the map
m
```

### Change Basemap

You can change the basemap for the map by providing a value for the `tiles` parameter of the `Map()` function. 

There are many different options including `Stamen Terrain`, `Stamen Toner` and `cartodbpositron`. More details and basemaps names available on the <a href="http://python-visualization.github.io/folium/docs-v0.5.0/modules.html#folium.map.Layer" target="_blank">Folium Documentation</a> for the `Map()` function.

{:.input}
```python
# Create a map using Stamen Terrain as the basemap
m = folium.Map(location=[40.0150, -105.2705],
              tiles = 'Stamen Terrain')

# Display map
m
```

### Add Markers

You can also add markers to label specific points on top of a `folium` basemap, such as the coordinates that are being used to center the map. You can even add a pop-up label for the marker that is activated when you click on it. 

{:.input}
```python
# Create a map using Stamen Terrain, centered on Boulder, CO
m = folium.Map(location=[40.0150, -105.2705], 
              tiles = 'Stamen Terrain')

# Add marker for Boulder, CO
folium.Marker(
    location=[40.009515, -105.242714], # coordinates for the marker (Earth Lab at CU Boulder)
    popup='Earth Lab at CU Boulder', # pop-up label for the marker
    icon=folium.Icon()
).add_to(m)

# Display m
m
```

## Raster Overlay on Interactive Map

You can also overlay rasters on `folium` basemaps. 

The default coordinate system and projection for web-based basemaps is WGS84 Web Mercator. To overlay data on web-based basemaps, the overlay data needs to be in the WGS84 coordinate system (<a href= "http://spatialreference.org/ref/epsg/wgs-84/" target="_blank">see this link for more information on this coordinate system</a>). 

Thus, to overlay a raster on a basemap, you first need to project the raster to WGS84 (EPSG 4326).

### Project Raster

You can use the `rasterio` package, which you imported as rio, to project a raster. In this example, you will use a raster for a post-flood digital terrain model (DTM) in the Northwest Boulder area: `post_DTM.tif`. 

{:.input}
```python
# Create variables for destination coordinate system and the name of the projected raster
dst_crs = 'EPSG:4326' 
out_path = 'data/colorado-flood/spatial/boulder-leehill-rd/outputs/reproj_post_DTM.tif'


# Use rasterio package as rio to open and project the raster
with rio.open('data/colorado-flood/spatial/boulder-leehill-rd/post-flood/lidar/post_DTM.tif') as src:
    transform, width, height = calculate_default_transform(
        src.crs, dst_crs, src.width, src.height, *src.bounds)
    kwargs = src.meta.copy()
    kwargs.update({
        'crs': dst_crs,
        'transform': transform,
        'width': width,
        'height': height
    })
 

    # Use rasterio package as rio to write out the new projected raster
    # Code uses loop to account for multi-band rasters
    with rio.open(out_path, 'w', **kwargs) as dst:
        for i in range(1, src.count + 1):
            reproject(
            source=rio.band(src, i),
            destination=rio.band(dst, i),
            src_transform=src.transform,
            src_crs=src.crs,
            dst_transform=transform,
            dst_crs=dst_crs,
            resampling=Resampling.nearest)    
```

{:.input}
```python
# Use rasterio to import the reprojected data as img
with rio.open(out_path) as src:
    boundary = src.bounds
    img = src.read()
    nodata = src.nodata
```

### Overlay Raster

Now that the raster is in the correct coordinate system (WGS84), you can overlay it on the basemp using the `add_child()` function and specifying the image (e.g. `img`) and setting an opacity and bounding box, if desired.

{:.input}
```python
# Create a map using Stamen Terrain, centered on study area with set zoom level
m = folium.Map(location=[40.06, -105.30],
                   tiles='Stamen Terrain', zoom_start = 13)

# Overlay raster called img using add_child() function (opacity and bounding box set)
m.add_child(plugins.ImageOverlay(img[0], opacity=1, 
                                 bounds =[[40.05577828237005, -105.32837712340124], [40.073923431943214, -105.28139535136515]]))

# Display map
m
```

<div class="notice--warning" markdown="1">

## <i class="fa fa-pencil-square-o" aria-hidden="true"></i> Optional Challenge 

Update the previously created map with the following characteristics:
* change the basemap to `Stamen Toner`
* add a marker for the study area (`40.06, -105.30`) and a pop-up label

</div>

<div class="notice--info" markdown="1">

## <i class="fa fa-pencil-square-o" aria-hidden="true"></i> Additional Resources

* <a href="http://python-visualization.github.io/folium/docs-v0.5.0/quickstart.html#Markers" target="_blank">Working with Markers in Folium</a>

* <a href="http://nbviewer.jupyter.org/github/python-visualization/folium/tree/master/examples/" target="_blank">Folium Example Maps</a>

* <a href="http://python-visualization.github.io/folium/docs-v0.5.0/modules.html" target="_blank">Folium Documentation</a>

</div>
