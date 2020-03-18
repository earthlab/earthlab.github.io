---
layout: single
title: "Open and Use MODIS Data in HDF4 format in Open Source Python"
excerpt: "Learn how to open and use MODIS data in HDF4 form in Open Source Python."
authors: ['Leah Wasser', 'Jenny Palomino']
dateCreated: 2020-03-01
modified: 2020-03-18
category: [courses]
class-lesson: ['hdf4']
permalink: /courses/use-data-open-source-python/hierarchical-data-formats-hdf/intro-to-hdf4/
nav-title: 'Intro to HDF4'
module-title: 'Introduction to the HDF4 File Format in Python'
module-description: 'MODIS is a remote sensing data type that is stored in the HDF4 file formal. Learn how to open and manipulate data stored in the HDF4 file format using open source python.'
module-nav-title: 'hdf4'
module-type: 'class'
chapter: 12
class-order: 1
week: 6
course: "intermediate-earth-data-science-textbook"
sidebar:
  nav:
author_profile: false
comments: true
order: 2
topics:
  remote-sensing: ['modis']
  reproducible-science-and-programming:
  spatial-data-and-gis: ['raster-data']
---
{% include toc title="In This Chapter" icon="file-text" %}

<div class='notice--success' markdown="1">


## <i class="fa fa-graduation-cap" aria-hidden="true"></i> Learning Objectives

After completing this lesson you will be able to:

* Read MODIS data in hdf4 format into Python using open source tools (rasterio)
* Extract metadata from hdf4 files
* Plot data extracted from hdf4 files using earthpy

</div>

In this lesson you will learn how to open a MODIS HDF4 format file using 
**rasterio**. To begin import your packages.


{:.input}
```python
import numpy as np
import numpy.ma as ma
import matplotlib.pyplot as plt
import os
import re  # regular expressions
import warnings

import rasterio as rio
from rasterio.plot import plotting_extent
import geopandas as gpd
import earthpy as et
import earthpy.plot as ep
import earthpy.spatial as es
import earthpy.mask as em

warnings.simplefilter('ignore')

# Get the data
et.data.get_data('cold-springs-modis-h5')
# This download is for the fire boundary
et.data.get_data('cold-springs-fire')
os.chdir(os.path.join(et.io.HOME, 'earth-analytics', 'data'))
```

{:.output}
    Downloading from https://ndownloader.figshare.com/files/10960112
    Extracted output to /root/earth-analytics/data/cold-springs-modis-h5/.
    Downloading from https://ndownloader.figshare.com/files/10960109
    Extracted output to /root/earth-analytics/data/cold-springs-fire/.






## Hierarchical Data Formats - HDF4 - EOS in Python

In the previous lesson, you learned about the hdf4 file format which is 
a commen format used to store MODIS remote sensing data. In this lesson 
you will learn how to open and process remote sensing data stored in hdf4 
format.

You can use gdal or rasterio (which wraps around gdal) to open hdf4 data. 
In this less you will use rasterio. Similar to opening .tif files using rasterio, 
you can use a context manager to open hdf4 files. However because the data are 
nested, you will see that loops will become important to open and explore the 
reflectance data stored within the h4 file. 

To begin, create a path to your hdf file.

NOTE: We are in the process of updating earthpy to download that data into a 
more appropriately named directory.

{:.input}
```python
# Create a path to the pre-fire MODIS h4 data
pre_fire_path = os.path.join("cold-springs-modis-h5",
                             "07_july_2016",
                             "MOD09GA.A2016189.h09v05.006.2016191073856.hdf")
```

## Open HDF Files Using Open Source Python - Rasterio

HDF files are hierarchical and self describing (the metadata is contained 
within the data). Because the data are hierarchical, you will have to loop
through the main dataset and the subdatasets nested within the main dataset 
to access the reflectance data (the bands) and the qa layers. 

The first context manager below opens the main h4 file. Notice that this layer has 
some metatadata associated with it. However, there is not CRS or proper affine 
information for the spatial layers contained within the file. 

You will need to access the bands which are stored as subdatasets within the 
h4 file. 

{:.input}
```python
# View dataset metadata
with rio.open(pre_fire_path) as dataset:
    print(dataset)
    hdf4_meta = dataset.meta

# Notice that there are metadata at the highest level of the file
hdf4_meta
```

{:.output}
    <open DatasetReader name='cold-springs-modis-h5/07_july_2016/MOD09GA.A2016189.h09v05.006.2016191073856.hdf' mode='r'>



{:.output}
{:.execute_result}



    {'driver': 'HDF4',
     'dtype': 'float_',
     'nodata': None,
     'width': 512,
     'height': 512,
     'count': 0,
     'crs': None,
     'transform': Affine(1.0, 0.0, 0.0,
            0.0, 1.0, 0.0)}





To access the spatial information stored within your H4 file, you will need 
to loop through the subdatasets. Below you open a connection to the main h4 file, 
then you loop through each subdataset in the file. The files with this pattern 
in the name:

`sur_refl_b01_1`  

are the bands which contain surface reflectance data. 

* **sur_refl_b01_1:** MODIS Band One
* **sur_refl_b02_1:** MODI Band Two

Below you loop through and print the name of each subdataset in the file.
Notice that there are some other layers in the file as well including the 
`state_1km` layer which contains the QA (cloud and quality assurance) information.

{:.input}
```python
# Print all of the subdatasets in the data
with rio.open(pre_fire_path) as dataset:
    crs = dataset.read_crs()
    for name in dataset.subdatasets:
        print(name)
```

{:.output}
    HDF4_EOS:EOS_GRID:cold-springs-modis-h5/07_july_2016/MOD09GA.A2016189.h09v05.006.2016191073856.hdf:MODIS_Grid_1km_2D:num_observations_1km
    HDF4_EOS:EOS_GRID:cold-springs-modis-h5/07_july_2016/MOD09GA.A2016189.h09v05.006.2016191073856.hdf:MODIS_Grid_1km_2D:granule_pnt_1
    HDF4_EOS:EOS_GRID:cold-springs-modis-h5/07_july_2016/MOD09GA.A2016189.h09v05.006.2016191073856.hdf:MODIS_Grid_500m_2D:num_observations_500m
    HDF4_EOS:EOS_GRID:cold-springs-modis-h5/07_july_2016/MOD09GA.A2016189.h09v05.006.2016191073856.hdf:MODIS_Grid_500m_2D:sur_refl_b01_1
    HDF4_EOS:EOS_GRID:cold-springs-modis-h5/07_july_2016/MOD09GA.A2016189.h09v05.006.2016191073856.hdf:MODIS_Grid_500m_2D:sur_refl_b02_1
    HDF4_EOS:EOS_GRID:cold-springs-modis-h5/07_july_2016/MOD09GA.A2016189.h09v05.006.2016191073856.hdf:MODIS_Grid_500m_2D:sur_refl_b03_1
    HDF4_EOS:EOS_GRID:cold-springs-modis-h5/07_july_2016/MOD09GA.A2016189.h09v05.006.2016191073856.hdf:MODIS_Grid_500m_2D:sur_refl_b04_1
    HDF4_EOS:EOS_GRID:cold-springs-modis-h5/07_july_2016/MOD09GA.A2016189.h09v05.006.2016191073856.hdf:MODIS_Grid_500m_2D:sur_refl_b05_1
    HDF4_EOS:EOS_GRID:cold-springs-modis-h5/07_july_2016/MOD09GA.A2016189.h09v05.006.2016191073856.hdf:MODIS_Grid_500m_2D:sur_refl_b06_1
    HDF4_EOS:EOS_GRID:cold-springs-modis-h5/07_july_2016/MOD09GA.A2016189.h09v05.006.2016191073856.hdf:MODIS_Grid_500m_2D:sur_refl_b07_1
    HDF4_EOS:EOS_GRID:cold-springs-modis-h5/07_july_2016/MOD09GA.A2016189.h09v05.006.2016191073856.hdf:MODIS_Grid_500m_2D:QC_500m_1
    HDF4_EOS:EOS_GRID:cold-springs-modis-h5/07_july_2016/MOD09GA.A2016189.h09v05.006.2016191073856.hdf:MODIS_Grid_1km_2D:state_1km_1
    HDF4_EOS:EOS_GRID:cold-springs-modis-h5/07_july_2016/MOD09GA.A2016189.h09v05.006.2016191073856.hdf:MODIS_Grid_500m_2D:obscov_500m_1
    HDF4_EOS:EOS_GRID:cold-springs-modis-h5/07_july_2016/MOD09GA.A2016189.h09v05.006.2016191073856.hdf:MODIS_Grid_500m_2D:iobs_res_1
    HDF4_EOS:EOS_GRID:cold-springs-modis-h5/07_july_2016/MOD09GA.A2016189.h09v05.006.2016191073856.hdf:MODIS_Grid_500m_2D:q_scan_1
    HDF4_EOS:EOS_GRID:cold-springs-modis-h5/07_july_2016/MOD09GA.A2016189.h09v05.006.2016191073856.hdf:MODIS_Grid_1km_2D:SensorZenith_1
    HDF4_EOS:EOS_GRID:cold-springs-modis-h5/07_july_2016/MOD09GA.A2016189.h09v05.006.2016191073856.hdf:MODIS_Grid_1km_2D:SensorAzimuth_1
    HDF4_EOS:EOS_GRID:cold-springs-modis-h5/07_july_2016/MOD09GA.A2016189.h09v05.006.2016191073856.hdf:MODIS_Grid_1km_2D:Range_1
    HDF4_EOS:EOS_GRID:cold-springs-modis-h5/07_july_2016/MOD09GA.A2016189.h09v05.006.2016191073856.hdf:MODIS_Grid_1km_2D:SolarZenith_1
    HDF4_EOS:EOS_GRID:cold-springs-modis-h5/07_july_2016/MOD09GA.A2016189.h09v05.006.2016191073856.hdf:MODIS_Grid_1km_2D:SolarAzimuth_1
    HDF4_EOS:EOS_GRID:cold-springs-modis-h5/07_july_2016/MOD09GA.A2016189.h09v05.006.2016191073856.hdf:MODIS_Grid_1km_2D:gflags_1
    HDF4_EOS:EOS_GRID:cold-springs-modis-h5/07_july_2016/MOD09GA.A2016189.h09v05.006.2016191073856.hdf:MODIS_Grid_1km_2D:orbit_pnt_1



## Process MODIS Bands Stored in a H4 File

Once you have accessed the subdatasets you are ready to extract the bands that 
you wish to work with. At this point you could export each band as 
a `.tif` file if you wanted. 

Below you collect all of the bands that you want and manipulate the data
as a numpy array. Below you do two things

1. You add a second context manager to the loop which will allow you to `read()` or crop the data using rasterio.
2. You add `re.search()` which uses regular expressions to filter out only the subdatasets that contain the string `b0` in them. This filters out the bands or surfance reflectance data that you will need to calculate vegetation indices. 

The data are appended to a list and stacked using `np.stack()`. This creates 
a single numpy array that only contains MODIS surface reflectance data (just 
the bands). 


{:.input}
```python
# Open & stack the prefire data
all_bands = []
# Just get the reflectance data - the bands
with rio.open(pre_fire_path) as dataset:
    for name in dataset.subdatasets:
        # Use regular expressions to grab data with b0 in the name (the bands)
        if re.search("b0.\_1$", name):
            with rio.open(name) as subdataset:
                modis_meta = subdataset.profile
                # read in the data as a 2 dim vs 3 dim arr
                all_bands.append(subdataset.read(1))

pre_fire_modis = np.stack(all_bands)
pre_fire_modis.shape
```

{:.output}
{:.execute_result}



    (7, 2400, 2400)





### Plot All MODIS Bands with EarthPy

You are now ready to plot your data using earthpy. Notice below that the 
images look washed out and there are large negative values in the data. 

This might be a good time to consider cleaning up your data by addressing 
`nodata` values.

{:.input}
```python
ep.plot_bands(pre_fire_modis,
              scale=False)
plt.show()
```

{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}/images/courses/intermediate-earth-data-science-textbook/06-hierchical-data-formats/01-hdf4/2020-03-02-hdf-02-open-hdf4-python/2020-03-02-hdf-02-open-hdf4-python_14_0.png">

</figure>




If you look at the table that <a href="{{ site.url }}/courses/earth-analytics-python/multispectral-remote-sensing-modis/modis-remote-sensing-data-in-python/" table in the MODIS documentation or that is on the earthdatascience.org intermediate textbook,</a> you will see that the
range of value values for MODIS spans from **-100 to 16000**. 

There is also a fill or no data value **-28672** to consider. You can access this nodata
value using the rasterio metadata object.

{:.input}
```python
# View entire metadata object for a MODIS band
modis_meta
```

{:.output}
{:.execute_result}



    {'driver': 'HDF4Image', 'dtype': 'int16', 'nodata': -28672.0, 'width': 2400, 'height': 2400, 'count': 1, 'crs': CRS.from_wkt('PROJCS["unnamed",GEOGCS["Unknown datum based upon the custom spheroid",DATUM["Not specified (based on custom spheroid)",SPHEROID["Custom spheroid",6371007.181,0]],PRIMEM["Greenwich",0],UNIT["degree",0.0174532925199433]],PROJECTION["Sinusoidal"],PARAMETER["longitude_of_center",0],PARAMETER["false_easting",0],PARAMETER["false_northing",0],UNIT["Meter",1]]'), 'transform': Affine(463.3127165279165, 0.0, -10007554.677,
           0.0, -463.3127165279167, 4447802.078667), 'tiled': False}





{:.input}
```python
# View just the nodata value
modis_meta["nodata"]
```

{:.output}
{:.execute_result}



    -28672.0





To address the valid range of values in your data, you can mask it using 
`numpy ma.masked_where()`. 

ma.masked_where(pre_fire_modis == modis_meta["nodata"], pre_fire_modis)

After masking the nodata values, the plot now shows a range of
values represented between **0-10,000** which is what you would expect.
The data also are also visibly less washed out!

{:.input}
```python
# Mask no data values
pre_fire_modis = ma.masked_where(
    pre_fire_modis == modis_meta["nodata"], pre_fire_modis)
```

{:.input}
```python
ep.plot_bands(pre_fire_modis,
              scale=False,
              figsize=(10, 7))
plt.show()
```

{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}/images/courses/intermediate-earth-data-science-textbook/06-hierchical-data-formats/01-hdf4/2020-03-02-hdf-02-open-hdf4-python/2020-03-02-hdf-02-open-hdf4-python_20_0.png">

</figure>




### RGB Image of MODIS Data Using EarthPy

Once you have your data cleaned up, you can plot an RGB image of your data 
to ensure it looks correct!

{:.input}
```python
# Plot MODIS RGB
ep.plot_rgb(pre_fire_modis,
            rgb=[0, 3, 2],
            title='RGB Image of MODIS Data',
            stretch=True,
            figsize=(7, 7))

plt.show()
```

{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}/images/courses/intermediate-earth-data-science-textbook/06-hierchical-data-formats/01-hdf4/2020-03-02-hdf-02-open-hdf4-python/2020-03-02-hdf-02-open-hdf4-python_22_0.png">

</figure>




{:.input}
```python
#extent_modis_pre = plotting_extent(pre_fire_modis[0], crop_meta["transform"])
```

## Crop MODIS Data

Above you opened and plotted MODIS reflectance data. However the data 
cover a larger study area than you need so it is a good idea to crop it
before moving any further. 

To begin you will want to check that th CRS of your crop layer (in this 
case the fire boundary layer that you have used in other lessons - 
`co_cold_springs_20160711_2200_dd83.shp`) is the same as your MODIS data. 

There are several different ways to check the CRS for your crop extent. 
You will need to get the CRS of the MODIS data prior to reprojecting the 
fire boundary. Below you do this by:

1. Creating a connection to the hdf4 file
2. Opening a connection to one single band 
3. Grabbing the CRS using the `src` object

Finally you use the CRS to check and reproject the fire boundary if it 
is not in the same CRS.

{:.input}
```python
# Open fire boundary
fire_boundary_path = os.path.join("cold-springs-fire",
                                  "vector_layers",
                                  "fire-boundary-geomac",
                                  "co_cold_springs_20160711_2200_dd83.shp")
fire_boundary = gpd.read_file(fire_boundary_path)
# Check the CRS
fire_boundary.crs
```

{:.output}
{:.execute_result}



    {'init': 'epsg:4269'}





First reproject the fire boundary. Note that you do not need all of the 
print statments included below. They are included to help you see what is 
happening in the code!

{:.input}
```python
# Check to see if you need to reproject the fire boundary
with rio.open(pre_fire_path) as dataset:
    for name in dataset.subdatasets:
        # get the first band
        if re.search("b01_1$", name):
            with rio.open(name) as subdataset:
                print("Fire Bound CRS:", fire_boundary.crs)
                print("MODIS CRS:", subdataset.crs)

                if not fire_boundary.crs == subdataset.crs:
                    print("I just reprojected the data!")
                    fire_bound_sin = fire_boundary.to_crs(subdataset.crs)
```

{:.output}
    Fire Bound CRS: {'init': 'epsg:4269'}
    MODIS CRS: PROJCS["unnamed",GEOGCS["Unknown datum based upon the custom spheroid",DATUM["Not specified (based on custom spheroid)",SPHEROID["Custom spheroid",6371007.181,0]],PRIMEM["Greenwich",0],UNIT["degree",0.0174532925199433]],PROJECTION["Sinusoidal"],PARAMETER["longitude_of_center",0],PARAMETER["false_easting",0],PARAMETER["false_northing",0],UNIT["Meter",1]]
    I just reprojected the data!



## Crop MODIS Data 

MODIS scenes are large. If your study area is small, you may want to crop the data.
Below you:

1. open up the fire boundary which you will use to crop your modis data. 
2. open and crop each band using earthpy's `crop_image()` function.
3. stack the data using `numpy.stack()`. 
4. address no data values using `numpy.ma.masked_where()`. 

Notice that the 
nodata value is pulled directly from the metadata object that you created 
in the loop. 

`ma.masked_where(pre_fire_modis_crop == modis_meta["nodata"], pre_fire_modis_crop)`


{:.input}
```python
# Open & stack the prefire reflectance data
all_bands = []

with rio.open(pre_fire_path) as dataset:
    for name in dataset.subdatasets:
        # Select only the bands (the reflectance data)
        if re.search("b0.\_1$", name):
            with rio.open(name) as subdataset:
                modis_meta = subdataset.profile
                crop_band, crop_meta = es.crop_image(
                    subdataset, fire_bound_sin)
                # Append the band to a list
                all_bands.append(np.squeeze(crop_band))

# Stack the data and handle no data values
pre_fire_modis_crop = np.stack(all_bands)
pre_fire_modis_crop = ma.masked_where(
    pre_fire_modis_crop == modis_meta["nodata"], pre_fire_modis_crop)

# Optional - define a plotting extent
# You only need this code if you want to overlay the fire boundary on top of your reflectance data
extent_modis_pre = plotting_extent(
    pre_fire_modis_crop[0], crop_meta["transform"])

# View shape of the final cropped array
pre_fire_modis_crop.shape
```

{:.output}
{:.execute_result}



    (7, 3, 8)





## Calculate NDVI Using MODIS Data

Once you have a stacked numpy array, you can process the data however you'd like.
Below, each band in the numpy array is plotted.

{:.input}
```python
# Plot the data
ep.plot_bands(pre_fire_modis_crop,
              figsize=(10, 5))
plt.show()
```

{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}/images/courses/intermediate-earth-data-science-textbook/06-hierchical-data-formats/01-hdf4/2020-03-02-hdf-02-open-hdf4-python/2020-03-02-hdf-02-open-hdf4-python_31_0.png">

</figure>




## Export MODIS Data in a Numpy Array as a Geotiff 

This last section is option. If you want to export your newly stacked MODIS 
data as a geotif you need to fix the metadata object. The metadata for each 
band represents a single array so the `count` element is 1. However you now 
are writing out a stacked array. You will need to adjust the `count` 
element in the metadata dictionary to account for this.

`es.crop_image()` returns the correct height, width and no data value so you 
do not need to account for those values!

2. write out a tif file
3. read it back in

{:.input}
```python
# View the metadata for a single band
crop_meta
```

{:.output}
{:.execute_result}



    {'driver': 'GTiff',
     'dtype': 'int16',
     'nodata': -28672.0,
     'width': 8,
     'height': 3,
     'count': 1,
     'crs': CRS.from_wkt('PROJCS["unnamed",GEOGCS["Unknown datum based upon the custom spheroid",DATUM["Not specified (based on custom spheroid)",SPHEROID["Custom spheroid",6371007.181,0]],PRIMEM["Greenwich",0],UNIT["degree",0.0174532925199433]],PROJECTION["Sinusoidal"],PARAMETER["longitude_of_center",0],PARAMETER["false_easting",0],PARAMETER["false_northing",0],UNIT["Meter",1]]'),
     'transform': Affine(463.3127165279165, 0.0, -8988730.01335511,
            0.0, -463.3127165279167, 4446412.140517416)}





{:.input}
```python
# Note that the count is 1 for a single band.
crop_meta["count"]
```

{:.output}
{:.execute_result}



    1





{:.input}
```python
# Adjust the count to represent the number of bands in the numpy stacked array.
crop_meta["count"] = pre_fire_modis_crop.shape[0]
crop_meta
```

{:.output}
{:.execute_result}



    {'driver': 'GTiff',
     'dtype': 'int16',
     'nodata': -28672.0,
     'width': 8,
     'height': 3,
     'count': 7,
     'crs': CRS.from_wkt('PROJCS["unnamed",GEOGCS["Unknown datum based upon the custom spheroid",DATUM["Not specified (based on custom spheroid)",SPHEROID["Custom spheroid",6371007.181,0]],PRIMEM["Greenwich",0],UNIT["degree",0.0174532925199433]],PROJECTION["Sinusoidal"],PARAMETER["longitude_of_center",0],PARAMETER["false_easting",0],PARAMETER["false_northing",0],UNIT["Meter",1]]'),
     'transform': Affine(463.3127165279165, 0.0, -8988730.01335511,
            0.0, -463.3127165279167, 4446412.140517416)}





{:.input}
```python
stacked_file_path = os.path.join(os.path.dirname(pre_fire_path), "stacked", "modis_stack.tif")
modis_dir_path = os.path.dirname(stacked_file_path)

print("file path:", modis_dir_path)
print("MODIS new file path:", stacked_file_path)

if not os.path.exists(modis_dir_path):
    os.mkdir(modis_dir_path)
    print("dir", pre_fire_path, " doesn't exist - creating it for you!")
```

{:.output}
    file path: cold-springs-modis-h5/07_july_2016/stacked
    MODIS new file path: cold-springs-modis-h5/07_july_2016/stacked/modis_stack.tif
    dir cold-springs-modis-h5/07_july_2016/MOD09GA.A2016189.h09v05.006.2016191073856.hdf  doesn't exist - creating it for you!



{:.input}
```python
# Export file as a geotiff
with rio.open(stacked_file_path, "w", **crop_meta) as dest:
    dest.write(pre_fire_modis_crop)
```

{:.input}
```python
# Open the file and have a look at just to make sure it's correct!

with rio.open(stacked_file_path) as src:
    modis_arr = src.read()
    
ep.plot_bands(modis_arr,
             figsize=(9,4))
plt.show()
```

{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}/images/courses/intermediate-earth-data-science-textbook/06-hierchical-data-formats/01-hdf4/2020-03-02-hdf-02-open-hdf4-python/2020-03-02-hdf-02-open-hdf4-python_38_0.png">

</figure>








{:.output}
{:.execute_result}



    (1200, 1200)










{:.input}
```python
# ## Import the data using rasterio
# # this could easily become a helper function -- assuming the students needed to import multiple datasets

# all_bands = []
# # Just get the reflectance data - the bands
# with rio.open(pre_fire_path) as dataset:
#     #crs = dataset.read_crs()
#     for name in dataset.subdatasets:
#         # Build out content on regex
#         if re.search("b0.\_1$", name):
#             with rio.open(name) as subdataset:
#                 # This is not ideal because it's reprojecting each time...
#                 fire_bound_sin = fire_boundary.to_crs(subdataset.crs)
#                 modis_meta = subdataset.profile
#                 crop_band, crop_meta = es.crop_image(subdataset, fire_bound_sin)
#                 # read in the data as a 2 dim vs 3 dim arr
#                 #all_bands.append(subdataset.read(1))
#                 all_bands.append(np.squeeze(crop_band))

# pre_fire_modis = np.stack(all_bands)
# extent_modis_pre = plotting_extent(pre_fire_modis[0], crop_meta["transform"])

# all_bands = []
# # Just get the reflectance data - the bands
# with rio.open(post_fire_path) as dataset:
#     #crs = dataset.read_crs()
#     for name in dataset.subdatasets:
#         if re.search("b0.\_1$", name):
#             with rio.open(name) as subdataset:
#                 # This is not ideal because it's reprojecting each time...
#                 fire_bound_sin = fire_boundary.to_crs(subdataset.crs)
#                 modis_meta = subdataset.profile
#                 crop_band, crop_meta = es.crop_image(subdataset, fire_bound_sin)
#                 # read in the data as a 2 dim vs 3 dim arr
#                 #all_bands.append(subdataset.read(1))
#                 all_bands.append(np.squeeze(crop_band))

# post_fire_modis = np.stack(all_bands)
# extent_modis_post = plotting_extent(post_fire_modis[0], crop_meta["transform"])
```

{:.input}
```python
# Plot the data
# ep.plot_bands(post_fire_modis, figsize=(12,6))
# plt.show()
```




