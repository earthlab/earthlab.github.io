---
layout: single
title: "Extract Raster Values At Point Locations in Python"
excerpt: "This lesson reviews how to extract data from a raster dataset using a
vector dataset. "
authors: ['Leah Wasser', 'Chris Holdgraf', 'Carson Farmer']
modified: 2018-10-08
category: [courses]
class-lesson: ['remote-sensing-uncertainty-python']
permalink: /courses/earth-analytics-python/lidar-remote-sensing-uncertainty/extract-data-from-raster/
nav-title: 'Extract Data From Raster'
course: 'earth-analytics-python'
week: 5
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

* Use the `rasterstats.zonal_stats()` function to extract raster pixel values using a vector extent or set of extents.

## <i class="fa fa-check-square-o fa-2" aria-hidden="true"></i> What You Need

You will need a computer with internet access to complete this lesson. You will also need the data you downloaded for last week of this class: `spatial-vector-lidar data subset`. 

{% include/data_subsets/course_earth_analytics/_data-spatial-lidar.md %}


</div>

In this lesson you will extract pixel values that cover each field plot area where trees were measured in the NEON Field Sites. The idea is that you can calculate the mean or max height value for all pixels that fall in each NEON site. Then you will compare that mean or max height value derived from the lidar data derived canopy height model pixels to height values calcualted using human tree height measurements. 

To do this, you need to do the following:

1. Import the canopy height model that you wish to extra tree height data from. 
2. Clean up that data. For instance if there are values of 0 for areas where there are no trees they will impact a mean value calculation. It is better to remove those values from the data.
3. Finally you will import and create a buffer zone that represents the area where trees were sampled in each NEON field site. 

To begin, import your python libraries. 

{:.input}
```python
import os
import numpy as np
import numpy.ma as ma
import matplotlib.pyplot as plt
import rasterio as rio
from rasterio.plot import plotting_extent
import geopandas as gpd
# Rasterstats contains the zonalstatistics function that you will use to extract raster values
import rasterstats as rs
import pandas as pd
import earthpy as et

os.chdir(os.path.join(et.io.HOME, 'earth-analytics'))
```

## Import Canopy Height Model

First, you will import a canopy height model created by the National Ecological Observatory Network (NEON). In the
previous lessons / weeks you learned how to make a canopy height model by
subtracting the Digital elevation model (DEM) from the Digital surface model (DSM).

## Context Managers and Rasterio

As you learned in the previous raster lessons, you will use a context manager `with` to create 
a connection to your raster dataset. This connection will be automatically closed at the end of the `with` statement.

{:.input}
```python
# Load & plot the data
with rio.open('data/spatial-vector-lidar/california/neon-sjer-site/2013/lidar/SJER_lidarCHM.tif') as sjer_lidar_chm_src:
    SJER_chm_data = sjer_lidar_chm_src.read(1, masked=True)
    sjer_chm_meta = sjer_lidar_chm_src.profile

fig, ax = plt.subplots(figsize=(8, 8))
ax.hist(SJER_chm_data.ravel(),
        color="purple")
ax.set_title('Distribution of Pixel Values \n Lidar Canopy Height Model',
             fontsize=18)
ax.set_xlabel("Lidar Estimated Tree Height (m)")

# Turn off scientific notation
ax.ticklabel_format(useOffset=False,
                    style='plain')
```

{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}//images/courses/earth-analytics-python/05-raster-vector-extract-data/in-class/2016-12-06-uncertainty02-extract-raster-values_4_0.png" alt = "Bar plot showing the distribution of lidar canopy height model pixel values.">
<figcaption>Bar plot showing the distribution of lidar canopy height model pixel values.</figcaption>

</figure>




{:.input}
```python
# View summary statistics of canopy height model
print('Mean:', SJER_chm_data.mean())
print('Max:', SJER_chm_data.max())
print('Min:', SJER_chm_data.min())
```

{:.output}
    Mean: 1.935586243204776
    Max: 45.879997
    Min: 0.0



## Clean Up Data - Remove 0's
Looking at the distribution of data, you can see there are many pixels that have a value of 0 - where there are no trees. Also, using the NEON data, values below 2m are normally set to 0 given the accuracy of the lidar instrument used to collect these data. 

Set all pixel values `==0` to `nan` as they will impact calculation of plot mean height. A mean calculated with values of 0 will be significantly lower than a mean calculated with just tree height values.  


{:.input}
```python
# Set CHM values of 0 to NAN (no data or not a number)
SJER_chm_data[SJER_chm_data == 0] = np.nan

# view summary statistics of canopy height model
print('Mean:', np.nanmean(SJER_chm_data))
print('Max:', np.nanmax(SJER_chm_data))
print('Min:', np.nanmin(SJER_chm_data))
```

{:.output}
    Mean: 8.213505
    Max: 45.879997
    Min: 2.0



Look at the histogram of the data with the 0's removed. Now you can see the true distribution of heights in the data. 
Notice that below to plot the histogram an additional step is taken to remove `nan` values from the data. There are several ways to do this but here, we simply subset the data using 

`SJER_chm_data[~np.isnan(SJER_chm_data)])` 

Then the data are flattened into a 1-dimensional array to create the histogram:

`SJER_chm_data[~np.isnan(SJER_chm_data)].ravel()`


{:.input}
```python
# Remove nans, flatten the data & plot historgram
SJER_chm_data_no_na = SJER_chm_data[~np.isnan(SJER_chm_data)].ravel()

fig, ax = plt.subplots(figsize=(10, 10))
ax.hist(SJER_chm_data_no_na, color="purple")
ax.set_title('Distribution of Pixel Values \n Lidar Canopy Height Model',
             fontsize=18)
ax.set_xlabel("Lidar Estimated Tree Height (m)")
ax.set_ylabel("Total Pixels")

ax.ticklabel_format(useOffset=False,
                    style='plain')
```

{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}//images/courses/earth-analytics-python/05-raster-vector-extract-data/in-class/2016-12-06-uncertainty02-extract-raster-values_9_0.png" alt = "Bar plot showing the distribution of lidar chm values with 0's removed.">
<figcaption>Bar plot showing the distribution of lidar chm values with 0's removed.</figcaption>

</figure>




## Import Plot Location Data & Create Buffer

You now have a cleaned canopy height model for your study area in California. However, how
do the height values extracted from the CHM compare to our manually collected,
field measured canopy height data? To figure this out, you will use *in situ* collected
tree height data, measured within circular plots across our study area. You will compare
the maximum measured tree height value to the maximum LiDAR derived height value
for each circular plot using regression.

First, import the shapefile that contains the plot centroid (the center point of each plot) locations using geopandas.

`data/spatial-vector-lidar/california/neon-sjer-site/vector_data/SJER_plot_centroids.shp`

{:.input}
```python
sjer_centroids_path = 'data/spatial-vector-lidar/california/neon-sjer-site/vector_data/SJER_plot_centroids.shp'
SJER_plots_points = gpd.read_file(sjer_centroids_path)
type(SJER_plots_points)
```

{:.output}
{:.execute_result}



    geopandas.geodataframe.GeoDataFrame





{:.input}
```python
# Ensure this is a points layer as you think it is
SJER_plots_points.geom_type.head()
```

{:.output}
{:.execute_result}



    0    Point
    1    Point
    2    Point
    3    Point
    4    Point
    dtype: object





### Overlay Points on Top Of Your Raster Data

Finally, a quick plot allows you to check that your points actually overlay on top of the canopy 
height model. This is a good sanity check just to ensure your data actually line up and are for the 
same location.

If you recall in week 2, we discussed the spatial extent of a raster. Here is where you will need to set the spatial 
extent when plotting raster using `imshow()`. If you do not specify a spatial extent, your raster will not line up 
properly with your geopandas object.

{:.input}
```python
fig, ax = plt.subplots(figsize=(10, 10))
ax.imshow(SJER_chm_data,
          # Here you must set the spatial extent or else the data will not line up with your geopandas layer
          extent=plotting_extent(sjer_lidar_chm_src),
          cmap='Greys')
SJER_plots_points.plot(ax=ax,
                       marker='s',
                       markersize=45,
                       color='purple')
ax.set_title("San Joachin Field Site \n Locations Vegetation Plot Locations",
             fontsize=20)
plt.show()
```

{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}//images/courses/earth-analytics-python/05-raster-vector-extract-data/in-class/2016-12-06-uncertainty02-extract-raster-values_14_0.png" alt = "Map showing SJER plot location points overlayed on top of the SJER Canopy Height Model.">
<figcaption>Map showing SJER plot location points overlayed on top of the SJER Canopy Height Model.</figcaption>

</figure>




## Create A Buffer Around Each Plot Point Location

Each point in your data represent the center location of a plot where trees were measured. You want to extract tree height values derived from the lidar data for the entire plot. To do this, you will need to create a BUFFER around the points representing the region of the plot where data were collected.

In this case your plot size is 40m. If you create a circular buffer with a 20m diameter it will closely approximate where trees were measured on the ground. 

You can use the `.buffer()` method to create the buffer. Here the buffer size is specified in the `()` of the function. We will send the new object to a new shapefile using `.to_file()` as follows:

`SJER_plots.buffer(20).to_file('path-to-shapefile-here.shp')`


<figure>
   <a href="{{ site.url }}/images/courses/earth-analytics/spatial-data/buffer-circular.png">
   <img src="{{ site.url }}/images/courses/earth-analytics/spatial-data/buffer-circular.png" alt="national geographic scaling trees graphic"></a>
   <figcaption>The extract function in R allows you to specify a circular buffer
    radius around an x,y point location. Values for all pixels in the specified
    raster that fall within the circular buffer are extracted. In this case, we
    will tell R to extract the maximum value of all pixels using the fun=max
    command. Source: Colin Williams, NEON
    </figcaption>
</figure>

Below you 
1. Make a copy of the points layer and create a new, to be created polygon layer
2. Buffer the points layer using the `.buffer()` method. This will produce a circle around each point that is x units radius. The units will coincide with the CRS of your data. This known as a buffer. 
3. When you perform the buffer, you UPDATE the "geometry" column of your new poly layer with the buffer output. 


{:.input}
```python
# Create a buffered polygon layer from your plot location points
SJER_plots_poly = SJER_plots_points.copy()

# Buffer each point using a 20 meter circle radius and replace the point geometry with the new buffered geometry
SJER_plots_poly["geometry"] = SJER_plots_points.geometry.buffer(20)
SJER_plots_poly.head()
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
      <th>Plot_ID</th>
      <th>Point</th>
      <th>northing</th>
      <th>easting</th>
      <th>plot_type</th>
      <th>geometry</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>SJER1068</td>
      <td>center</td>
      <td>4111567.818</td>
      <td>255852.376</td>
      <td>trees</td>
      <td>POLYGON ((255872.376 4111567.818, 255872.27969...</td>
    </tr>
    <tr>
      <th>1</th>
      <td>SJER112</td>
      <td>center</td>
      <td>4111298.971</td>
      <td>257406.967</td>
      <td>trees</td>
      <td>POLYGON ((257426.967 4111298.971, 257426.87069...</td>
    </tr>
    <tr>
      <th>2</th>
      <td>SJER116</td>
      <td>center</td>
      <td>4110819.876</td>
      <td>256838.760</td>
      <td>grass</td>
      <td>POLYGON ((256858.76 4110819.876, 256858.663694...</td>
    </tr>
    <tr>
      <th>3</th>
      <td>SJER117</td>
      <td>center</td>
      <td>4108752.026</td>
      <td>256176.947</td>
      <td>trees</td>
      <td>POLYGON ((256196.947 4108752.026, 256196.85069...</td>
    </tr>
    <tr>
      <th>4</th>
      <td>SJER120</td>
      <td>center</td>
      <td>4110476.079</td>
      <td>255968.372</td>
      <td>grass</td>
      <td>POLYGON ((255988.372 4110476.079, 255988.27569...</td>
    </tr>
  </tbody>
</table>
</div>





Finally, export the buffered layer as a new shapefile. You will use this layer when you use the zonalstats function.
Below you first check to ensure the outputs directory exists that you wish to write your data to. Then you export the data using the `to_file` method.

{:.input}
```python
# If the dir does not exist, create it
if not os.path.isdir('data/spatial-vector-lidar/outputs/'):
    os.mkdir('data/spatial-vector-lidar/outputs/')

# Export the buffered point layer as a shapefile to use in zonal stats
plot_buffer_path = 'data/spatial-vector-lidar/outputs/plot_buffer.shp'
SJER_plots_poly.to_file(plot_buffer_path)
```

## Extract Pixel Values For Each Plot 

Once you have the boundary for each plot location (a 20m diameter circle) you can extract all of the pixels that fall within each circle using the function `zonal_stats` in the `rasterstats` library. 

There are several ways to use the zonal_stats function. In this case we are providing the following

1. chm data (numpy array): `SJER_chm_data` in a numpy array format
2. Because a numpy array has no spatial information, you provide the affine data which is the spatial information needed to spatially located the array. 
3. `plot_buffer_path`: this is the path to the buffered point shapefile that you created at the top of this lesson


{:.input}
```python
# Extract zonal stats
sjer_tree_heights = rs.zonal_stats(plot_buffer_path,
                                   SJER_chm_data,
                                   affine=sjer_chm_meta['transform'],
                                   geojson_out=True,
                                   copy_properties=True,
                                   stats="count min mean max median")

# view object type
type(sjer_tree_heights)
```

{:.output}
{:.execute_result}



    list





Convert the list output to a geodataframe that you can plot the data. 

{:.input}
```python
# Turn extracted data into a pandas geodataframe
SJER_lidar_height_df = gpd.GeoDataFrame.from_features(sjer_tree_heights)
SJER_lidar_height_df.head()
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
      <th>Plot_ID</th>
      <th>Point</th>
      <th>count</th>
      <th>easting</th>
      <th>geometry</th>
      <th>max</th>
      <th>mean</th>
      <th>median</th>
      <th>min</th>
      <th>northing</th>
      <th>plot_type</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>SJER1068</td>
      <td>center</td>
      <td>161</td>
      <td>255852.376</td>
      <td>POLYGON ((255872.376 4111567.818, 255872.27969...</td>
      <td>19.049999</td>
      <td>11.544348</td>
      <td>12.62</td>
      <td>2.04</td>
      <td>4111567.818</td>
      <td>trees</td>
    </tr>
    <tr>
      <th>1</th>
      <td>SJER112</td>
      <td>center</td>
      <td>443</td>
      <td>257406.967</td>
      <td>POLYGON ((257426.967 4111298.971, 257426.87069...</td>
      <td>24.019999</td>
      <td>10.369277</td>
      <td>7.87</td>
      <td>2.10</td>
      <td>4111298.971</td>
      <td>trees</td>
    </tr>
    <tr>
      <th>2</th>
      <td>SJER116</td>
      <td>center</td>
      <td>643</td>
      <td>256838.760</td>
      <td>POLYGON ((256858.76 4110819.876, 256858.663694...</td>
      <td>16.070000</td>
      <td>7.518398</td>
      <td>6.80</td>
      <td>2.82</td>
      <td>4110819.876</td>
      <td>grass</td>
    </tr>
    <tr>
      <th>3</th>
      <td>SJER117</td>
      <td>center</td>
      <td>245</td>
      <td>256176.947</td>
      <td>POLYGON ((256196.947 4108752.026, 256196.85069...</td>
      <td>11.059999</td>
      <td>7.675347</td>
      <td>7.93</td>
      <td>3.24</td>
      <td>4108752.026</td>
      <td>trees</td>
    </tr>
    <tr>
      <th>4</th>
      <td>SJER120</td>
      <td>center</td>
      <td>17</td>
      <td>255968.372</td>
      <td>POLYGON ((255988.372 4110476.079, 255988.27569...</td>
      <td>5.740000</td>
      <td>4.591176</td>
      <td>4.45</td>
      <td>3.38</td>
      <td>4110476.079</td>
      <td>grass</td>
    </tr>
  </tbody>
</table>
</div>





Below is a bar plot of max lidar derived tree height by plot id. This plot allows you to see how vegetation height varies across the field sites. 

{:.input}
```python
fig, ax = plt.subplots(figsize=(10, 5))
ax.bar(SJER_lidar_height_df['Plot_ID'],
       SJER_lidar_height_df['max'])
ax.set(xlabel="Plot ID", ylabel="Max Height")
plt.setp(ax.get_xticklabels(), rotation=45, horizontalalignment='right')
plt.show()
```

{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}//images/courses/earth-analytics-python/05-raster-vector-extract-data/in-class/2016-12-06-uncertainty02-extract-raster-values_24_0.png" alt = "Bar plot showing maximum tree height per plot in SJER.">
<figcaption>Bar plot showing maximum tree height per plot in SJER.</figcaption>

</figure>




****

<div class="notice--info" markdown="1">

## OPTIONAL -- Explore The Data Distribution

You will not need to perform the steps below for this weeks homework. However, 
if you were really working with lidar data, you may want to look at the distribution
of pixels in each extracted set of cells for further analysis. The steps below show you how to do this.

If you want to explore the data distribution of pixel height values in each plot,
`rasterstats` includes the datapoints corresponding to each zone. To access
this, we included the `raster_out` keyword argument when we calculated the
raster stats.

The `raster_out` argument creates a small raster with just the pixel values for each individual plot. You can then plot a histogram of each plot to assess the distribution of data values. This step is helpful if you need to further
explore your data to identify potential issues or to better understand what is going on in the data.

Below you loop through the points included in each zone and show a histogram
of its values. Note that each set of points is stored as a _masked array_. This
is because images must be shaped as squares, while our zone may be any
shape that we wish. The mask tells us which pixels fall into the zone.

</div>


{:.input}
```python
# Extract zonal stats but retain the individual pixel values
sjer_tree_heights_ras = rs.zonal_stats(plot_buffer_path,
                                       SJER_chm_data,
                                       affine=sjer_chm_meta['transform'],
                                       geojson_out=True,
                                       raster_out=True,
                                       copy_properties=True,
                                       stats="count min mean max median")
# Convert to geodataframe
SJER_lidar_height_df_ras = gpd.GeoDataFrame.from_features(
    sjer_tree_heights_ras)
# View subset of the dataframe
SJER_lidar_height_df_ras[["Plot_ID", "count", "geometry",
                          "mini_raster_affine", "mini_raster_array"]].head()
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
      <th>Plot_ID</th>
      <th>count</th>
      <th>geometry</th>
      <th>mini_raster_affine</th>
      <th>mini_raster_array</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>SJER1068</td>
      <td>161</td>
      <td>POLYGON ((255872.376 4111567.818, 255872.27969...</td>
      <td>(1.0, 0.0, 255832.0, 0.0, -1.0, 4111588.0, 0.0...</td>
      <td>[[--, --, --, --, --, --, --, --, --, --, --, ...</td>
    </tr>
    <tr>
      <th>1</th>
      <td>SJER112</td>
      <td>443</td>
      <td>POLYGON ((257426.967 4111298.971, 257426.87069...</td>
      <td>(1.0, 0.0, 257386.0, 0.0, -1.0, 4111319.0, 0.0...</td>
      <td>[[--, --, --, --, --, --, --, --, --, --, --, ...</td>
    </tr>
    <tr>
      <th>2</th>
      <td>SJER116</td>
      <td>643</td>
      <td>POLYGON ((256858.76 4110819.876, 256858.663694...</td>
      <td>(1.0, 0.0, 256818.0, 0.0, -1.0, 4110840.0, 0.0...</td>
      <td>[[--, --, --, --, --, --, --, --, --, --, --, ...</td>
    </tr>
    <tr>
      <th>3</th>
      <td>SJER117</td>
      <td>245</td>
      <td>POLYGON ((256196.947 4108752.026, 256196.85069...</td>
      <td>(1.0, 0.0, 256156.0, 0.0, -1.0, 4108773.0, 0.0...</td>
      <td>[[--, --, --, --, --, --, --, --, --, --, --, ...</td>
    </tr>
    <tr>
      <th>4</th>
      <td>SJER120</td>
      <td>17</td>
      <td>POLYGON ((255988.372 4110476.079, 255988.27569...</td>
      <td>(1.0, 0.0, 255948.0, 0.0, -1.0, 4110497.0, 0.0...</td>
      <td>[[--, --, --, --, --, --, --, --, --, --, --, ...</td>
    </tr>
  </tbody>
</table>
</div>







Below you create a plot for each individual field site of all pixel values. You will need to loop through the data in order to create this plot. 

{:.input}
```python
# Plot a histogram of pixel values for each plot
n_columns = 3
n_rows = int(np.ceil(len(SJER_lidar_height_df) / n_columns))

fig, axs = plt.subplots(n_rows, n_columns, figsize=(5*n_columns, 5*n_rows),
                        sharex=True, sharey=True)
for (zone, ix), ax in zip(SJER_lidar_height_df.iterrows(), axs.ravel()):
    data = SJER_lidar_height_df_ras.iloc[zone]['mini_raster_array']
    null_value = SJER_lidar_height_df_ras.iloc[zone]['mini_raster_nodata']
    data_values = data.data[data.mask]
    data_values = data_values[~np.isnan(data_values)]

    ax.hist(data_values, color='purple')
    ax.set(title=SJER_lidar_height_df_ras.iloc[zone]['Plot_ID'],
           xlabel="Raster Values")
    plt.tight_layout()
```

{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}//images/courses/earth-analytics-python/05-raster-vector-extract-data/in-class/2016-12-06-uncertainty02-extract-raster-values_28_0.png" alt = "Bar plot showing the distribution of pixel values for each plot at the SJER field site.">
<figcaption>Bar plot showing the distribution of pixel values for each plot at the SJER field site.</figcaption>

</figure>



