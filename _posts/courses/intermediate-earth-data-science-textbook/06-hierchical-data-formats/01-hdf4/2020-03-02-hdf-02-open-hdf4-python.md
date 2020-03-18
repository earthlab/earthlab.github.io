---
layout: single
title: "Open and Use MODIS Data in HDF4 format in Open Source Python"
excerpt: "MODIS is remote sensing data that is stored in the HDF4 file format. Learn how to open and use MODIS data in HDF4 form in Open Source Python."
authors: ['Leah Wasser', 'Jenny Palomino']
dateCreated: 2020-03-01
modified: 2020-03-18
category: [courses]
class-lesson: ['hdf4']
permalink: /courses/use-data-open-source-python/hierarchical-data-formats-hdf/open-MODIS-hdf4-files-python/
nav-title: 'Open HDF4'
module-type: 'class'
chapter: 12
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
{% include toc title="On This Page" icon="file-text" %}

<div class='notice--success' markdown="1">

## <i class="fa fa-graduation-cap" aria-hidden="true"></i> Learning Objectives

* Read MODIS data in HDF4 format into **Python** using open source packages (**rasterio**).
* Extract metadata from HDF4 files.
* Plot data extracted from HDF4 files using **earthpy**.

</div>

In this lesson, you will learn how to open a MODIS HDF4 format file using **rasterio**. 

To begin, import your packages.

{:.input}
```python
# Import packages
import os
import re  # regular expressions
import warnings
import matplotlib.pyplot as plt
import numpy as np
import numpy.ma as ma
import rasterio as rio
from rasterio.plot import plotting_extent
import geopandas as gpd
import earthpy as et
import earthpy.plot as ep
import earthpy.spatial as es
import earthpy.mask as em

warnings.simplefilter('ignore')

# Get the MODIS data
et.data.get_data('cold-springs-modis-h5')

# This download is for the fire boundary
et.data.get_data('cold-springs-fire')

# Set working directory
os.chdir(os.path.join(et.io.HOME, 'earth-analytics', 'data'))
```

{:.output}
    Downloading from https://ndownloader.figshare.com/files/10960112
    Extracted output to /root/earth-analytics/data/cold-springs-modis-h5/.






## Hierarchical Data Formats - HDF4 - EOS in Python

In the previous lesson, you learned about the HDF4 file format, which is 
a common format used to store MODIS remote sensing data. In this lesson, 
you will learn how to open and process remote sensing data stored in HDF4 
format.

You can use **gdal** or **rasterio** (which wraps around **gdal**) to open HDF4 data.

In this lesson, you will use rasterio. Similar to opening .tif files using **rasterio**, 
you can use a context manager to open HDF4 files. 

However, because the data are 
nested, you will see that loops will become important to open and explore the 
reflectance data stored within the HDF4 file. 

To begin, create a path to your HDF4 file.

{:.input}
```python
# Create a path to the pre-fire MODIS h4 data
pre_fire_path = os.path.join("cold-springs-modis-h5",
                             "07_july_2016",
                             "MOD09GA.A2016189.h09v05.006.2016191073856.hdf")
```

## Open HDF4 Files Using Open Source Python - Rasterio

HDF files are hierarchical and self describing (the metadata is contained 
within the data). Because the data are hierarchical, you will have to loop
through the main dataset and the subdatasets nested within the main dataset 
to access the reflectance data (the bands) and the qa layers. 

The first context manager below opens the main HDF4 file. 

Notice that this layer has 
some metatadata associated with it. However, there is not CRS or proper affine 
information for the spatial layers contained within the file. 

To access that information, you will need to access the bands which are stored as subdatasets within the 
HDF4 file. 

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





To access the spatial information stored within your HDF4 file, you will need 
to loop through the subdatasets. 

Below you open a connection to the main HDF4 file, 
then you loop through each subdataset in the file. 

The files with this pattern 
in the name:

`sur_refl_b01_1`  

are the bands which contain surface reflectance data. 

* **sur_refl_b01_1:** MODIS Band One
* **sur_refl_b02_1:** MODIS Band Two

etc.

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



## Process MODIS Bands Stored in a HDF4 File

Once you have accessed the subdatasets, you are ready to extract the bands that 
you wish to work with. At this point, you could export each band as 
a `.tif` file if you wanted. 

In the code below, you collect all of the bands that you want and manipulate the data
as a numpy array. Below you do two things:

1. Add a second context manager to the loop, which will allow you to `read()` or crop the data using rasterio.
2. Add `re.search()` which uses regular expressions to filter out only the subdatasets that contain the string `b0` in them. This filters out the bands or surfance reflectance data that you will need to calculate vegetation indices. 

The data are appended to a list and stacked using `np.stack()`. 

This creates 
a single numpy array that only contains MODIS surface reflectance data (just 
the bands). 

{:.input}
```python
# Create empty list to append arrays (of band data)
all_bands = []

# Open the pre-fire HDF4 file
with rio.open(pre_fire_path) as dataset:
    
    # Loop through each subdataset in HDF4 file
    for name in dataset.subdatasets:
        
        # Use regular expression to identify if subdataset has b0 in the name (the bands)
        if re.search("b0.\_1$", name):
            
            # Open the band subdataset
            with rio.open(name) as subdataset:
                modis_meta = subdataset.profile
                
                # Read band data as a 2 dim arr and append to list
                all_bands.append(subdataset.read(1))

# Stack pre-fire reflectance bands
pre_fire_modis = np.stack(all_bands)
pre_fire_modis.shape
```

{:.output}
{:.execute_result}



    (7, 2400, 2400)





### Plot All MODIS Bands with EarthPy

Now that you have a stack of all of the arrays for surface reflectance, you are now ready to plot your data using **earthpy**. 

Notice below that the 
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




If you look at the <a href="{{ site.url }}/courses/earth-analytics-python/multispectral-remote-sensing-modis/modis-remote-sensing-data-in-python/"> MODIS documentation table that is in the Introduction to MODIS chapter,</a> you will see that the
range of value values for MODIS spans from **-100 to 16000**. 

There is also a fill or no data value **-28672** to consider. You can access this nodata
value using the rasterio metadata object.

{:.input}
```python
# View entire metadata object 
# for the last MODIS band processed in loop
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





To address the valid range of values in your data, you can mask the data using 
`numpy ma.masked_where()` which will mask specific values within a numpy
array. 

`ma.masked_where(pre_fire_modis == modis_meta["nodata"], pre_fire_modis)`

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

Once you have your data cleaned up, you can also plot an RGB image of your data 
to ensure that it looks correct!

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





## Crop MODIS Data Using EarthPy

Above you opened and plotted MODIS reflectance data. However, the data 
cover a larger study area than you need. It is a good idea to crop it
the data to maximize processing efficiency.  

To begin, you will want to check that the CRS of your crop layer (in this 
case, the fire boundary layer that you have used in other lessons - 
`co_cold_springs_20160711_2200_dd83.shp`) is the same as your MODIS data. 

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





### Reproject the Clip Extent (Fire Boundary)

To check the CRS of MODIS data, you can:

1. Create a connection to the HDF4 file.
2. Open a connection to one single band.
3. Grab the CRS of the band using the `src` object.

You can then use the CRS of the band to check and reproject the fire boundary if it 
is not in the same CRS.

In the code below, you use these steps to reproject the fire boundary to match the HDF4 data. 

Note that you do not need all of the 
print statments included below. They are included to help you see what is 
happening in the code!

{:.input}
```python
# Open the pre-fire HDF4 file
with rio.open(pre_fire_path) as dataset:
    
    # Loop through each subdataset in HDF4 file
    for name in dataset.subdatasets:
        
        # Get the first band and check its CRS against the fire boundary
        if re.search("b01_1$", name):
            with rio.open(name) as subdataset:
                print("MODIS CRS:", subdataset.crs)
                print("Fire Bound CRS:", fire_boundary.crs)
                
                # Project the fire boundary if the CRS do not match
                if not fire_boundary.crs == subdataset.crs:
                    fire_bound_sin = fire_boundary.to_crs(subdataset.crs)
                    print("Crop boundary reprojected to match the MODIS bands.")
```

{:.output}
    MODIS CRS: PROJCS["unnamed",GEOGCS["Unknown datum based upon the custom spheroid",DATUM["Not specified (based on custom spheroid)",SPHEROID["Custom spheroid",6371007.181,0]],PRIMEM["Greenwich",0],UNIT["degree",0.0174532925199433]],PROJECTION["Sinusoidal"],PARAMETER["longitude_of_center",0],PARAMETER["false_easting",0],PARAMETER["false_northing",0],UNIT["Meter",1]]
    Fire Bound CRS: {'init': 'epsg:4269'}
    Crop boundary reprojected to match the MODIS bands.



### Crop MODIS Data Using Reprojected Fire Boundary

Once you have opened and reprojected your crop extent, you can 
crop your MODIS raster data. Below you:

1. open and crop each band to the reprojected fire boundary using the `crop_image()` function in **earthpy**.
2. stack the data using `numpy.stack()`. 
3. address no data values using `numpy.ma.masked_where()`. 

Notice that the **nodata** value is pulled directly from the metadata 
object that you created in the loop. 

`ma.masked_where(pre_fire_modis_crop == modis_meta["nodata"], pre_fire_modis_crop)`

{:.input}
```python
# Create empty list to append bands 
all_bands = []

# Open HDF file and loop through datasets
with rio.open(pre_fire_path) as dataset:
    for name in dataset.subdatasets:
        
        # Identify bands (the reflectance data)
        if re.search("b0.\_1$", name):
            with rio.open(name) as subdataset:
                modis_meta = subdataset.profile
                
                # Crop band using projected fire boundary
                crop_band, crop_meta = es.crop_image(
                    subdataset, fire_bound_sin)
                
                # Append the cropped band as 2D array to the list
                all_bands.append(np.squeeze(crop_band))

# Stack the bands and handle no data values
pre_fire_modis_crop = np.stack(all_bands)
pre_fire_modis_crop = ma.masked_where(
    pre_fire_modis_crop == modis_meta["nodata"], pre_fire_modis_crop)

# Optional - define a plotting extent
# Only needed to overlay the fire boundary on top of reflectance data
extent_modis_pre = plotting_extent(
    pre_fire_modis_crop[0], crop_meta["transform"])

# View shape of the final cropped array
pre_fire_modis_crop.shape
```

{:.output}
{:.execute_result}



    (7, 3, 8)





### Plot Your Cropped MODIS Data

Once you have a stacked numpy array, you can use the data for analysis or plotting.

The code belows plots each band in the stacked numpy array of the cropped data.

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




## Export MODIS Data in a Numpy Array as a GeoTIFF

This last section is optional. If you want to export your newly stacked MODIS 
data as a GeoTIFF, you need to fix the metadata object. 

The metadata for each 
band represents a single array, so the `count` element is **1**. However, you are now 
writing out a stacked array. You will need to adjust the `count` 
element in the metadata dictionary to account for this.

`es.crop_image()` returns the correct height, width and no-data value so you 
do not need to account for those values!

To get started, have a look at the metadata object for a single band. This 
has most of the information that you need to export a new GeoTIFF file. Pay
close attention to the **count** value.

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





Next, redefine the count to represent the number of layers or bands in your 
stack. 

In this case, there are 7 bands in the stacked array. You can grab this value from the `.shape`
attribute of your numpy array.

{:.input}
```python
# Check number of bands
print("Stacked array has", pre_fire_modis_crop.shape[0], "bands")

# Adjust count to represent number of bands in stacked array
crop_meta["count"] = pre_fire_modis_crop.shape[0]
crop_meta
```

{:.output}
    Stacked array has 7 bands



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





Finally, create an output directory to save your exported geotiff. 

Below, you 
create a directory called **stacked** within the MODIS directory that you've 
been working with.

{:.input}
```python
# Define path for exported file
stacked_file_path = os.path.join(os.path.dirname(pre_fire_path), 
                                 "stacked", "modis_stack.tif")

# Get the directory needed for the defined path
modis_dir_path = os.path.dirname(stacked_file_path)
print("Needed directory:", modis_dir_path)

# Create the needed directory if it does not exist
if not os.path.exists(modis_dir_path):
    os.mkdir(modis_dir_path)
    print("The directory", modis_dir_path, "did not exist - creating it now!")
```

{:.output}
    Needed directory: cold-springs-modis-h5/07_july_2016/stacked
    The directory cold-springs-modis-h5/07_july_2016/stacked did not exist - creating it now!



You can now export or write out a new GeoTIFF. To do this, you will create a 
context manager with a connection to a new file in write (`"w"`) mode. You 
will then use `.write(numpy_arr_here)` to export the file.

The `crop_meta` object has two stars (`**`) next to it as that tells rasterio 
to "unpack" the meta object into the various pieces that are required to 
save a spatially referenced GeoTIFF file.

{:.input}
```python
# Export file as a geotiff
with rio.open(stacked_file_path, "w", **crop_meta) as dest:
    dest.write(pre_fire_modis_crop)
```

Open and view your stacked GeoTIFF.

{:.input}
```python
# Open the file to make sure it's correct!
with rio.open(stacked_file_path) as src:
    modis_arr = src.read()
    
ep.plot_bands(modis_arr,
             figsize=(9,4))
plt.show()
```

{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}/images/courses/intermediate-earth-data-science-textbook/06-hierchical-data-formats/01-hdf4/2020-03-02-hdf-02-open-hdf4-python/2020-03-02-hdf-02-open-hdf4-python_42_0.png">

</figure>


















