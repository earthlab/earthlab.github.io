---
layout: single
title: "Activity: Plot Spatial Raster Data in Python"
excerpt: "Practice your skills creating maps of raster and vector data using open source Python."
authors: ['Leah Wasser', 'Nathan Korinek']
dateCreated: 2020-02-26
modified: 2020-09-15
category: [courses]
class-lesson: ['plot-activities']
permalink: /courses/scientists-guide-to-plotting-data-in-python/plot-activities/practice-making-maps-python/
nav-title: 'Practice Making Maps'
week: 3
sidebar:
  nav:
author_profile: false
comments: true
order: 3
course: 'scientists-guide-to-plotting-data-in-python-textbook'
topics:
  reproducible-science-and-programming:
  data-exploration-and-analysis: ['data-visualization']
  spatial-data-and-gis: ['raster-data', 'vector-data']
---
{% include toc title="Section Three" icon="file-text" %}


<div class='notice--success' markdown="1">

## <i class="fa fa-graduation-cap" aria-hidden="true"></i> Learning Objectives

* Apply your skills in plotting spatial raster data using open source Python. 

</div>


## Plot Spatial Data in Python

Throughout these chapters, one of the main focuses has been opening, modifying, and plotting all forms of spatial data. The chapters have covered a wide array of these types of data, including all types of vector data, elevation data, imagery data, and more! You've used a combination of multiple libraries to open and plot spatial data, including **pandas**, **geopandas**, **matplotlib**, **earthpy**, and various others. Often earth analytics will combine vector and raster data to do more meaningful analysis on a research question. Plotting these various types of data together can be challenging, but also very informative. 

## Challenge Your Skills
In this challenge you will be asked to use the appropriate packages and tools to plot each type of spatial data that have been covered so far. First, you will plot out various forms of vector data, then raster data, and finally you will plot a combination of the raster and vector data. 


{:.input}
```python
# Import Packages

import os
from glob import glob
import matplotlib.pyplot as plt
import seaborn as sns
import pandas as pd
import geopandas as gpd
import rasterio as rio
from rasterio.plot import plotting_extent
import folium
import earthpy as et
import earthpy.plot as ep
import earthpy.spatial as es

import warnings
warnings.filterwarnings('ignore', 'GeoSeries.notna', UserWarning)

# Add seaborn general plot specifications
sns.set(font_scale=1.5, style="whitegrid")
```

{:.output}
    /opt/conda/lib/python3.8/site-packages/rasterio/plot.py:260: SyntaxWarning: "is" with a literal. Did you mean "=="?
      if len(arr.shape) is 2:



<div class="notice--warning" markdown="1">

## <i class="fa fa-pencil-square-o" aria-hidden="true"></i> Challenge 1: Create a Map Of RMNP Trails for the South Zone of the Park

The first plot you are going to make is a vector plot that displays 
hiking trails in Rocky Mountain National Park (RMNP) - which is located in Colorado. 

To make this plot, do the following: 

1. Read in the trails, trailsheads and ranger zones data for the Rocky Mountain National Park trails and the National Parks Service boundaries. The code to open the data is in the cell below for you to run.
2. Create a new GeoDataFrame that only contains the South Zone of the RMNP ranger zones `ranger_zones[ranger_zones["SUBDISTRIC"] == ["SOUTH"]` data  for the park.
3. Change the Coordinate Reference System of the boundary dataset to match the trails dataset. To get the Coordinate Reference System of the trails dataset, you can use `trails_dataframe_name.crs`. To set it to the boundary dataset, you can use the `to_crs()` function like so: `south_zone_boundary_geodataframe_name.to_crs(trails_dataframe_name.crs)`
4. Plot the trails data and the trailheads data together in a map. 
5. Add the polygon boundary of the South Ranger zone to the map. 
6. Change the symbology for the lines and points on the map. For lines, you will change the `linestyle=` argument [options for this argument here](https://matplotlib.org/3.1.0/gallery/lines_bars_and_markers/linestyles.html) and for points you will modify the `marker=` arguement [options for this argument here](https://matplotlib.org/api/markers_api.html).
7. We want a legend for this map, to show the symbology of trails and trail heads. To create this, in the plotting functions for your GeoDataFrames, add an argument `label=` and set it to what you want to call the trails and trailheads on your maps. Also, make sure you have the following lines of code in your plot. It will grab the labels you set in the plot functions and add them to the legend. 
```
handles, labels = ax.get_legend_handles_labels()
ax.legend(handles, labels)
```
8. Add a title to your plot. 

Your plot should look similar to the plot below.

</div>

****

<div class='notice--success alert alert-info' markdown="1">

<i class="fa fa-star"></i> **Data Tip:** 
- <a href="{{ site.baseurl }}/courses/use-data-open-source-python/intro-vector-data-python/vector-data-processing/reproject-vector-data-in-python/">If you're struggling with reprojecting the GeoDataFrames, check out this lesson explaining reprojecting data into a new CRS.</a>
- <a href="{{ site.baseurl }}/courses/scientists-guide-to-plotting-data-in-python/plot-spatial-data/customize-vector-plots/python-customize-map-legends-geopandas/">If you get stuck trying to add a legend to the plot, this lesson covering legends in vector plot may be useful.</a> 

</div>

{:.input}
```python
# Open RMNP Boundary -- we might not need this
# RMNP Boundary Layer: Lat lon 4326 -- direct download
rmnp_boundary = gpd.read_file(
    "https://opendata.arcgis.com/datasets/7cb5f22df8c44900a9f6632adb5f96a5_0.geojson")
```

{:.input}
```python
# Trails are UTM Zone 13N --  reproject to lat long
rmnp_trails = gpd.read_file(
    "https://opendata.arcgis.com/datasets/e1e0bcb87eb94960bc04f76e03936385_0.geojson")
rmnp_trails_4326 = rmnp_trails.to_crs(rmnp_boundary.crs)
```

{:.input}
```python
# Open ranger zones  - EPSG 4326
ranger_zones = gpd.read_file(
    "https://opendata.arcgis.com/datasets/fdffd3272ba546da9176416b814d2e8f_0.geojson")

# Trailheads - 4326
trailheads = gpd.read_file(
    "https://opendata.arcgis.com/datasets/55748f2f1d8a4db7aa26f7549e74be57_0.geojson")
```



{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}/images/courses/plot-data-in-python-textbook/03-plotting-activities/2020-06-24-activity-03-spatial-plots/2020-06-24-activity-03-spatial-plots_8_0.png" alt = "A map showing the boundary of the South Zone of Rocky Mountain National Park, with all of the hiking trails and trailheads mapped inside the boundary.">
<figcaption>A map showing the boundary of the South Zone of Rocky Mountain National Park, with all of the hiking trails and trailheads mapped inside the boundary.</figcaption>

</figure>




<div class="notice--warning" markdown="1">

## <i class="fa fa-pencil-square-o" aria-hidden="true"></i> Challenge 2: Overlay a Terrain Model on top of a Hillshade  

Next you will create a base map to put your trails on. In order to do this, you will use a Digital Elevation Model (`USGS_1_n41w106.tif`) for RMNP. The code to download the DEM is in the cell below. Once that is downloaded, you must complete the following steps to create the hillshade and plot the two rasters on top of each other. 

1. Read in the USGS DEM into a numpy array using rasterio. 
2. Clip the data to the extent of the south zone boundary you plotted earlier using this syntax inside of the context manager you used to open the array: 
```clipped_data, clipped_metadata = es.crop_image(rasterio_variable_name, south_zone_boundary_geodataframe_name)```
3. Create a hillshade from the clipped DEM using the syntax: `es.hillshade(clipped_data[0])`. This function outputs a numpy array with the hillshade data.
4. Overlay the clipped DEM array on top of the hillshade array you just created. 
5. Be sure to add a title to your plot.

Your plot should look similar to the plot below.

</div>

*****

<div class='notice--success alert alert-info' markdown="1">

<i class="fa fa-star"></i> **Data Note:** [The elevation data for this challenge was acquired through the National Map, a website that the U.S. Geological Survey uses to distribute data. This data is a DEM with 30 Meter resolution, which is to say that every pixel of the image represents a 30 by 30 meter square on the ground.](https://viewer.nationalmap.gov/basic/)

</div>

*****

<div class='notice--success alert alert-info' markdown="1">

<i class="fa fa-star"></i> **Data Tip:** <a href="{{ site.baseurl }}/courses/scientists-guide-to-plotting-data-in-python/plot-spatial-data/customize-raster-plots/">For more information about plotting raster data, see this chapter from the earth data science Scientist's Guide to Plotting Data in Python textbook.</a>

</div>

{:.input}
```python
# All these data are 4326 so reprojecting to that above makes sense
et.data.get_data(url="https://ndownloader.figshare.com/files/23399609")
os.chdir(os.path.join(et.io.HOME, "earth-analytics", "data"))
ned_30m_path = os.path.join("earthpy-downloads", "USGS_1_n41w106.tif")
```

{:.output}
    Downloading from https://ndownloader.figshare.com/files/23399609




{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}/images/courses/plot-data-in-python-textbook/03-plotting-activities/2020-06-24-activity-03-spatial-plots/2020-06-24-activity-03-spatial-plots_11_0.png" alt = "An elevation map of the the South Zone of Rocky Mountain National Park, overlaid on a hillshade map of the same area.">
<figcaption>An elevation map of the the South Zone of Rocky Mountain National Park, overlaid on a hillshade map of the same area.</figcaption>

</figure>




<div class="notice--warning" markdown="1">

## <i class="fa fa-pencil-square-o" aria-hidden="true"></i> Challenge 3: Overlay Trails on top of Elevation Data.

Next you will overlay the trails data on top of the elevation data that you plotted above.
Keep in mind a few things when you do this

1. You will need to create a plotting_extent object to use in the `extent=` plot parameter in `ep.plot_bands()` to ensure that your raster data line up with the vector data. Make sure you use the data and metadata that was the output of your clip to create the plotting_extent object so that the extent is correct. Your code should look like the following: 
```
ned_cl_extent = plotting_extent(clipped_data[0], clipped_metadata["transform"])
```
2. The legibility of data will change with the background data, so be sure to adjust colors/thickness of your data if you need to in order to make it visible. 
3. Be sure to add a title to your map. 

Your plot should look similar to the plot below.

</div>

******
<div class='notice--success alert alert-info' markdown="1">

<i class="fa fa-star"></i> **Data Tip:** <a href="{{ site.baseurl }}/courses/scientists-guide-to-plotting-data-in-python/plot-spatial-data/customize-raster-plots/plotting-extents/">If plotting extents are causing you trouble, this lesson covering plotting extents may help you.</a> 
</div>


{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}/images/courses/plot-data-in-python-textbook/03-plotting-activities/2020-06-24-activity-03-spatial-plots/2020-06-24-activity-03-spatial-plots_13_0.png" alt = "A map of the boundary of the South Zone of Rocky Mountain National Park, with hiking trails, trail heads, elevation data, and hillshade data mapped with it.">
<figcaption>A map of the boundary of the South Zone of Rocky Mountain National Park, with hiking trails, trail heads, elevation data, and hillshade data mapped with it.</figcaption>

</figure>




<div class="notice--warning" markdown="1">

## <i class="fa fa-pencil-square-o" aria-hidden="true"></i> Challenge 4: OPTIONAL Plot Interactive Vector Data

Below is a map that was made with **folium** to create an interactive map of the trails and trailheads in Rocky Mountain National Park. This is another way to give your data a background to give it context, besides using elevation or imagery data. Notice you can zoom in/out and move around the map by clicking and dragging. However, there are some aspects that you can change to make the map better! Here are some improvements you can give to the map: 

1. You can see where the lines are assigned colors with the `style` dictionary. Change the color to an easier color to see, as the green blends in with the background. 
2. The play icon is a nice marker for trailheads, but not the only option. Change the `icon=` argument in `folium.Icon()` to be another shape. There's a list of [usable icons here](https://fontawesome.com/icons?d=gallery). Note: Not all of the icons on that site will work, so if you pick one and it doesn't display try a different option!
3. When you click on the trailhead points, you will see it displays the `GEOMETRYID` value for the point. It may be more useful to display the `POINAME` column, which has the trail name stored in it. Change the column to the correct name so it displays properly. 
4. You may notice that the map initially starts really zoomed out. Change the `zoom_start` to make the map start close to the coverage of the data. 
</div>

*********

<div class='notice--success alert alert-info' markdown="1">

<i class="fa fa-star"></i> **Data Tip:** <a href="{{ site.baseurl }}/courses/scientists-guide-to-plotting-data-in-python/plot-spatial-data/customize-raster-plots/interactive-maps">For more information on interactive maps and adding vector data to them, please see this lesson from the earth data science Scientist's Guide to Plotting Data in Python textbook.</a>
</div>

{:.input}
```python
# Style Dictionary
style = {'color': 'green'}

# Adding the lines to the map
trails_south_json = trails_south.to_json()
interactive_map = folium.Map(location=[40.37244, -105.66472], zoom_start=7)
lines = folium.features.GeoJson(
    trails_south_json, style_function=lambda x: style)
interactive_map.add_child(lines)

# Adding the points to the map
for i in range(len(trailheads_south)):
    folium.Marker([trailheads_south.iloc[i].geometry.y, trailheads_south.iloc[i].geometry.x],
                  popup=trailheads_south.iloc[i]['GEOMETRYID'], icon=folium.Icon(icon='play')).add_to(interactive_map)
interactive_map
```
