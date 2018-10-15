---
layout: single
title: "Calculate and Plot Difference Normalized Burn Ratio (dNBR) from Landsat Remote Sensing Data in R"
excerpt: "In this lesson you review how to calculate difference normalized burn ratio using pre and post fire NBR rasters in R. You finally will classify the dNBR raster."
authors: ['Leah Wasser','Megan Cattau']
modified: 2018-10-08
category: [courses]
class-lesson: ['modis-multispectral-rs-python']
permalink: /courses/earth-analytics-python/multispectral-remote-sensing-modis/calculate-dNBR-R-Landsat/
nav-title: 'dNBR With Landsat'
class-order: 3
week: 8
course: "earth-analytics-python"
sidebar:
  nav:
author_profile: false
comments: true
order: 5
topics:
  remote-sensing: ['landsat', 'modis']
  earth-science: ['fire']
  reproducible-science-and-programming:
  spatial-data-and-gis: ['raster-data']
lang-lib:
  r: []
redirect_from:
   - "/courses/earth-analytics/week-6/calculate-dNBR-R-Landsat/"
   - "/courses/earth-analytics/spectral-remote-sensing-landsat/calculate-dNBR-R-Landsat/"

---





{% include toc title="In This Lesson" icon="file-text" %}



<div class='notice--success' markdown="1">



## <i class="fa fa-graduation-cap" aria-hidden="true"></i> Learning Objectives



After completing this tutorial, you will be able to:



* Calculate `dNBR` in `R`

* Describe how the `dNBR` index is used to quantify fire severity.



## <i class="fa fa-check-square-o fa-2" aria-hidden="true"></i> What You Need



You will need a computer with internet access to complete this lesson and the

data for week 7 - 9 of the course.



{% include/data_subsets/course_earth_analytics/_data-cold-springs-fire.md %}

</div>



As discussed in the previous lesson, you can use dNBR to map the extent and

severity of a fire. In this lesson, you learn how to create NBR using

Landsat data.



You calculate dNBR using the following steps:



1. Open up pre-fire data and calculate *NBR*

2. Open up the post-fire data and calculate *NBR*

3. Calculate **dNBR** (difference NBR) by subtracting post-fire NBR from pre-fire NBR (NBR pre - NBR post fire).

4. Classify the dNBR raster using the classification table provided below and isn the previous lesson.



Note the code to do this is hidden. You will need to figure

out what bands are required to calculate NBR using Landsat.



## Calculate dNBR Using Landsat Data



First, let's setup your spatial packages.














Next, calculate NBR for the pre-fire data. Note that you will have to download the data that is being used below from Earth Explorer. The data that was provided to you have a large cloud covering the study area. 




You can export the NBR raster if you want using `writeRaster()`.









{:.input}
```python
import numpy.ma as ma 
import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
from matplotlib import patches as mpatches
from matplotlib.colors import ListedColormap
import matplotlib as mpl
import seaborn as sns
import rasterio as rio
import geopandas as gpd
from rasterio.plot import show
from rasterio.mask import mask
from shapely.geometry import mapping, box

from glob import glob
import os
import earthpy as et
import earthpy.spatial as es

plt.ion()
sns.set_style('white')

mpl.rcParams['figure.figsize'] = (10.0, 6.0);
mpl.rcParams['axes.titlesize'] = 20
os.chdir(os.path.join(et.io.HOME, 'earth-analytics'))
```

Import and stack the data 

{:.input}
```python
# import the post fire data

all_landsat_bands = glob("data/cold-springs-fire/landsat_collect/LC080340322016072301T1-SC20180214145802/crop/*band*.tif")

landsat_post_fire_path = "data/cold-springs-fire/outputs/landsat_post_fire.tif"
# stack the data using the earthpy package
es.stack_raster_tifs(all_landsat_bands, 
                             landsat_post_fire_path)
with rio.open(landsat_post_fire_path) as src:
    landsat_post_fire = src.read(masked= True)
    landsat_post_bounds = src.bounds
    landsat_post_meta = src.profile

```

{:.output}
    /Users/lewa8222/anaconda3/envs/earth-analytics-python/lib/python3.6/site-packages/rasterio/__init__.py:160: FutureWarning: GDAL-style transforms are deprecated and will not be supported in Rasterio 1.0.
      transform = guard_transform(transform)



Next, you can calculate NBR on the post fire data. Remember that NBR uses different bands than NDVI. For landsat 8 data you will be using bands 7 and 5. And remember because python starts counting at 0 (0-based indexing), that will be bands 6 and 4 when you access them in your numpy array. 

{:.input}
```python
# calculate NBR
landsat_postfire_nbr = es.normalized_diff(landsat_post_fire[6], landsat_post_fire[4])

# plot the data 
fig, ax = plt.subplots(figsize=(12,6))
ndvi = ax.imshow(landsat_postfire_nbr, cmap='PiYG_r', vmin=-1, vmax=1)
fig.colorbar(ndvi)
ax.set(title="Landsat derived Normalized Burn Ratio\n 23 July 2016 \n Post Cold Springs Fire")
ax.set_axis_off();
```

{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}//images/courses/earth-analytics-python/08-multispectral-remote-sensing-fire/in-class/2017-03-01-fire05-calculate-NBR-with-landsat-Python_11_0.png">

</figure>




## Compare to Fire Boundary

As an example to see how your fire boundary relates to the boundary that you've
identified using MODIS data, you can create a map with both layers. I'm using
the shapefile in the folder:

`data/cold-springs-fire/vector_layers/fire-boundary-geomac/co_cold_springs_20160711_2200_dd83.shp`

Add fire boundary to map. 

{:.input}
```python
# open fire boundary layer 
fire_boundary_path = "data/cold-springs-fire/vector_layers/fire-boundary-geomac/co_cold_springs_20160711_2200_dd83.shp"
fire_boundary = gpd.read_file(fire_boundary_path)
landsat_post_meta['crs']
# reproject
fire_bound_utmz13 = fire_boundary.to_crs(landsat_post_meta['crs'])

```

{:.input}
```python
# plot the data
bound_order = [0,2,1,3]
extent_landsat = [landsat_post_bounds[i] for i in bound_order]
```

{:.input}
```python
# plot the data 
fig, ax = plt.subplots(figsize=(12,6))
ndvi = ax.imshow(landsat_postfire_nbr, cmap='PiYG', vmin=-1, vmax=1,
                extent = extent_landsat)
fig.colorbar(ndvi)
fire_bound_utmz13.plot(ax = ax, color = 'None', 
                       edgecolor = 'black', linewidth=2)
ax.set(title="Landsat derived Normalized Burn Ratio\n 23 July 2016 \n Post Cold Springs Fire")
ax.set_axis_off();
```

{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}//images/courses/earth-analytics-python/08-multispectral-remote-sensing-fire/in-class/2017-03-01-fire05-calculate-NBR-with-landsat-Python_15_0.png">

</figure>




Next, calculate NBR for the pre-fire data. Note that you will have to download the data that is being used below from Earth Explorer. The data that was provided to you have a large cloud covering the study area. 


{:.input}
```python
# create clip extent using the post fire data
landsat_clip = mapping(box(*landsat_post_bounds))

path_landsat_pre_st = 'data/cold-springs-fire/outputs/landsat_pre_st_hw.tif'
# crop landsat data
with rio.open(path_landsat_pre_st) as landsat_pre:
    # crop landsat data using the fire boundary reprojected 
    landsat_pre_crop, landsat_pre_meta = es.crop_image(landsat_pre, [landsat_clip])
    with rio.open("data/cold-springs-fire/outputs/test.tif" , 'w', **landsat_pre_meta) as clip:
        landsat_pre_bounds = clip.bounds
    
```

{:.input}
```python
# check the extents - are they the same?
landsat_pre_bounds == landsat_post_bounds
```

{:.output}
{:.execute_result}



    True





Next you can calculate NBR on the pre-fire data. 

{:.input}
```python
nbr_landsat_pre_fire = es.normalized_diff(landsat_pre_crop[6], landsat_pre_crop[4])

# plot the data 
fig, ax = plt.subplots(figsize=(12,6))
ndvi = ax.imshow(nbr_landsat_pre_fire, cmap='PiYG', vmin=-1, vmax=1)
fig.colorbar(ndvi)
ax.set(title="Landsat derived Normalized Burn Ratio\n Pre Cold Springs Fire")
ax.set_axis_off();
```

{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}//images/courses/earth-analytics-python/08-multispectral-remote-sensing-fire/in-class/2017-03-01-fire05-calculate-NBR-with-landsat-Python_20_0.png">

</figure>




Finally, calculate the difference between the two rasters to calculate the Difference Normalized Burn Ratio (dNBR). Remember to subtract post fire from pre fire.

{:.input}
```python
# calculate dnbr
dnbr_landsat = nbr_landsat_pre_fire - landsat_postfire_nbr
```

Finally you can classify the data. Remember that dNBR has a set of classification bins and associated categories that are commonly used.  

When you have calculated NBR - classify the output raster using the `np.digitize()`
function. Use the dNBR classes below.

| SEVERITY LEVEL  | | dNBR RANGE |
|------------------------------|
| Enhanced Regrowth | |   > -.1 |
| Unburned       |  | -.1 to + .1 |
| Low Severity     | | +.1 to +.27 |
| Moderate Severity  | | +.27 to +.66 |
| High Severity     |  |  > +.66  |

NOTE: your min an max values for NBR may be slightly different from the table
shown above. In the code example above, `np.inf` is used to suggest "any values larger than `.66`. 



i class="fa fa-star"></i> **Data Tip:** You learned how to classify rasters in the [{{ site.url }}/courses/earth-analytics-python/raster-lidar-intro/classify-plot-raster-data-in-python/](week 3 lidar lessons)
{: .notice--success }



{:.input}
```python
# define dNBR classification bins
dnbr_class_bins = [-.1, .1, .27, .66, np.inf]

dnbr_landsat_class = np.digitize(dnbr_landsat, dnbr_class_bins)
#bin_means = [dnbr_landsat_class[dnbr_landsat_class == i].mean() for i in range(0, 5)]
dnbr_cat_names = ["Enhanced Regrowth", "Unburned", 
                  "Low Severity",
                  "Moderate Severity", "High Severity"]
nbr_colors = ["g", "yellowgreen", "peachpuff", "coral", "maroon"]
nbr_cmap = ListedColormap(nbr_colors)
```


You `Python` classified map should look something like:


{:.input}
```python
# plot the data
fig, ax = plt.subplots(figsize =(10,8))
im = ax.imshow(dnbr_landsat_class, cmap=nbr_cmap,
               extent=extent_landsat)

fire_bound_utmz13.plot(ax = ax, color = 'None', 
                       edgecolor = 'black', linewidth=2)
values = np.unique(dnbr_landsat_class.ravel())

colors = [im.cmap(im.norm(value)) for value in values]
patches = [mpatches.Patch(color = colors[i], 
                          label = "{l}".format(l=dnbr_cat_names[i])) for i in range(len(dnbr_cat_names))]
plt.legend(handles = patches, bbox_to_anchor = (1.05,1), 
            loc = 2, borderaxespad = 0.,
            prop={'size': 13})
ax.set_title("Landsat dNBR - Cold Spring Fire Site \n June 22, 2017 - July 24, 2017", 
             fontsize = 16)

# turn off ticks
ax.set_axis_off();
```

{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}//images/courses/earth-analytics-python/08-multispectral-remote-sensing-fire/in-class/2017-03-01-fire05-calculate-NBR-with-landsat-Python_26_0.png">

</figure>




### Histogram of dNBR values
A histogram of the data is useful to better understand the distribution. 

{:.input}
```python
unique, counts = np.unique(dnbr_landsat_class.ravel(), return_counts=True)

fig, ax = plt.subplots(figsize = (8,6))
ax.bar(unique, counts, 
       color = "purple")

ax.set_title("Histogram of Landsat dNBR values - \nthis is not a homework plot. \nyou can use it to check your results if you want", 
             fontsize = 16)
ax.set_xticks(unique)
# get just the labels for unique values
dnbr_lab = [dnbr_cat_names[i] for i in unique]
ax.set_xticklabels(dnbr_lab);

```

{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}//images/courses/earth-analytics-python/08-multispectral-remote-sensing-fire/in-class/2017-03-01-fire05-calculate-NBR-with-landsat-Python_28_0.png">

</figure>






## Calculate Total Area of Burned Area



Once you have classified your data, you can calculate the total burn area.



To calculate this you could either



1. use the `extract()` function to extract pixels within the burn area boundary

2. `crop()` the data to the burn area boundary extent. This is an ok option however you have pixels represented that are outside of the burn boundary.






{:.input}
```python
# to calculate area you'd multiple each bin by 30x30 to total square meters

```




## Export dNBR Raster to Geotiff
Finally you can export the newly created dNBR raster to a geotiff. You can use all of the same metadata as you've been using for the other landsat rasters. However, in this case we need to UPDATE the count or number of layers in the raster. We only have one layer in the dNBR raster vs 7 in our landsat stacks. 


{:.input}
```python
dnbr_meta = landsat_post_meta.copy()
dnbr_meta
```

{:.output}
{:.execute_result}



    {'affine': Affine(30.0, 0.0, 455655.0,
           0.0, -30.0, 4428465.0),
     'count': 7,
     'crs': CRS({'init': 'epsg:32613'}),
     'driver': 'GTiff',
     'dtype': 'int16',
     'height': 177,
     'interleave': 'pixel',
     'nodata': -32768.0,
     'tiled': False,
     'transform': (455655.0, 30.0, 0.0, 4428465.0, 0.0, -30.0),
     'width': 246}





{:.input}
```python
# update the metadata (i maybe want to make a copy of this ??)
dnbr_meta['count'] = 1
dnbr_meta 
```

{:.output}
{:.execute_result}



    {'affine': Affine(30.0, 0.0, 455655.0,
           0.0, -30.0, 4428465.0),
     'count': 1,
     'crs': CRS({'init': 'epsg:32613'}),
     'driver': 'GTiff',
     'dtype': 'int16',
     'height': 177,
     'interleave': 'pixel',
     'nodata': -32768.0,
     'tiled': False,
     'transform': (455655.0, 30.0, 0.0, 4428465.0, 0.0, -30.0),
     'width': 246}





{:.input}
```python
# add write dNBR raster here....
dnbr_path = "data/cold-springs-fire/outputs/dnbr_landsat.tif"
with rio.open(dnbr_path, "w", **dnbr_meta) as src:
    src.write(dnbr_landsat_class.astype(np.int16),1)
```

{:.output}
    /Users/lewa8222/anaconda3/envs/earth-analytics-python/lib/python3.6/site-packages/rasterio/__init__.py:160: FutureWarning: GDAL-style transforms are deprecated and will not be supported in Rasterio 1.0.
      transform = guard_transform(transform)


