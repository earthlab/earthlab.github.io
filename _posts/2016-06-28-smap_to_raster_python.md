---
author: Matt Oakley
category: python
layout: single
tags:
- ftplib
- h5py
- numpy
- osgeo
- urllib
title: HDF5 to Raster Tutorial with Python
---




The National Snow and Ice Data Center hosts soil moisture data (from the NASA Soil Moisture Active Passive project, described [here](https://nsidc.org/data/smap), and hereafter referred to as SMAP) which is provided in .h5 format. HDF5 is a "hierarchical" data format, with multiple groups and datasets (further explained in Step 2) which are useful for storing and organizing large amounts of data. While this format is great for the large amount of data being collected, we often want to utilize a single dataset within the file. 

This tutorial demonstrates how to access SMAP data, and how to generate raster output from an HDF5 file. A raster is a two dimensional array, with each element in the array containing a specific value. In this case, the two dimensions correspond to longitude and latitude, and the elements or values represent soil moisture.
    
## Objectives

1. Read in SMAP data file (in .h5 format)
2. Extract specified data
3. Create a raster object

### Dependencies

This tutorial requires h5py, gdal, and numpy. Ensure that you already have python and pip installed.


```python
!pip install h5py
!pip install gdal==1.11.2
!pip install numpy -U
```

    Requirement already satisfied (use --upgrade to upgrade): h5py in /Users/majo3748/anaconda/envs/py27/lib/python2.7/site-packages
    Requirement already satisfied (use --upgrade to upgrade): numpy>=1.6.1 in /Users/majo3748/anaconda/envs/py27/lib/python2.7/site-packages (from h5py)
    Requirement already satisfied (use --upgrade to upgrade): six in /Users/majo3748/anaconda/envs/py27/lib/python2.7/site-packages (from h5py)
    Requirement already satisfied (use --upgrade to upgrade): gdal==1.11.2 in /Users/majo3748/anaconda/envs/py27/lib/python2.7/site-packages
    Requirement already up-to-date: numpy in /Users/majo3748/anaconda/envs/py27/lib/python2.7/site-packages



```python
import urllib
import ftplib
import sys
import h5py
import numpy as np
from osgeo import gdal
from osgeo import gdal_array
from osgeo import osr

#Useful information about the system being used
print(sys.version)
```

    2.7.11 |Anaconda 4.0.0 (x86_64)| (default, Dec  6 2015, 18:57:58) 
    [GCC 4.2.1 (Apple Inc. build 5577)]


# Step 1: Getting our data

NOTE: The .h5 file is over 130 MB and may take some time to download. The download has completed when the asterisk in the 'In' parameter has become a numeric value and there is output below the cell. The following code chunk pulls one SMAP data file from the NSIDC FTP server.


```python
ftp = ftplib.FTP("n5eil01u.ecs.nsidc.org")
ftp.login()

path = "SAN/SMAP/SPL4SMGP.001/2015.03.31/"
ftp.cwd(path)

filename = "SMAP_L4_SM_gph_20150331T013000_Vb1010_001.h5"
ftp.retrbinary("RETR " + filename, open(filename, "wb"). write)

ftp.quit()
```




    '221-You have transferred 139218579 bytes in 1 files.\n221-Total traffic for this session was 139219588 bytes in 1 transfers.\n221-Thank you for using the FTP service on ftphost.\n221 Goodbye.'



# Step 2: Inspecting the contents of an HDF5 file

HDF5 files consist of 'Groups' and 'Datasets'. Datasets are multidimensional arrays of a homogenous type, and Groups are a container structure which hold numerous datasets. Groups are analogous to directories on your local file system. For more details on the structure of HDF5 files, see [this tutorial from the NEON Data Skills site](http://neondataskills.org/HDF5/About), or refer to the [HDF5 home page](https://www.hdfgroup.org/HDF5/).

The following chunk of code prints the datasets within the "Geophysical_Data" group. The file that we downloaded is called SMAP_L4_SM_gph_20150331T013000_Vb1010_001.h5. If you have another .h5 file, you can replace the value of `file_path`. If you wish to inspect another group, you can replace `which_group`. For interactive exploration of HDF5 file contents, try [HDFView](https://www.hdfgroup.org/products/java/hdfview/index.html).


```python
file_path = 'SMAP_L4_SM_gph_20150331T013000_Vb1010_001.h5'
h5file = h5py.File(file_path, 'r') 

which_group = 'Geophysical_Data'
group = h5file.get(which_group)
datasets = np.array(group)
print datasets
```

    [u'surface_pressure' u'heat_flux_ground' u'land_fraction_wilting'
     u'soil_temp_layer5' u'sm_rootzone' u'radiation_longwave_absorbed_flux'
     u'specific_humidity_lowatmmodlay' u'surface_temp' u'temp_lowatmmodlay'
     u'net_downward_longwave_flux' u'snow_mass'
     u'precipitation_total_surface_flux' u'sm_surface_wetness'
     u'sm_profile_wetness' u'snow_depth' u'height_lowatmmodlay'
     u'baseflow_flux' u'sm_profile_pctl' u'land_fraction_saturated'
     u'snowfall_surface_flux' u'land_fraction_unsaturated'
     u'sm_rootzone_wetness' u'leaf_area_index'
     u'radiation_shortwave_downward_flux' u'sm_surface' u'soil_temp_layer1'
     u'heat_flux_sensible' u'soil_temp_layer4' u'soil_temp_layer6'
     u'land_fraction_snow_covered' u'land_evapotranspiration_flux'
     u'vegetation_greenness_fraction' u'sm_profile' u'soil_temp_layer3'
     u'overland_runoff_flux' u'snow_melt_flux' u'heat_flux_latent'
     u'soil_water_infiltration_flux' u'windspeed_lowatmmodlay'
     u'sm_rootzone_pctl' u'net_downward_shortwave_flux' u'soil_temp_layer2']


Each element in this array represents a different Dataset contained in the group `Geophysical_Data`. We will work with `sm_surface_wetness`, `soil_temp_layer2` in this tutorial. 

# Step 3: Using our data to create a Raster

Now that we've decided which group(s) and dataset(s) we wish to use we need to create a raster object from the data. Because we are interested in two different datasets, we will extract both and subsequently "stack" them on top of one another.

The following code chunk defines a function `smap2raster`, which we use for the generation of rasters from specific datasets in the SMAP data file. 


```python
def smap2raster(inputFile, group, dataset):
    """Converts SMAP data to a Raster object
Input:  
    inputFile - SMAP data file
    group - The groupt containing the dataset we want to pull data from
    dataset - Which specific dataset we want to pull data from
Output: 
    A raster image in .tif format, saved to the current working directory
    """
    #Read in the SMAP file in h5 format
    h5File = h5py.File(inputFile, 'r')
    
    #Get the data from the specific group/dataset
    data = h5File.get(group + '/' + dataset)
    lat = h5File.get('cell_lat')
    lon = h5File.get('cell_lon')
    
    #Convert this data into numpy arrays
    np_data = np.array(data)
    np_lat = np.array(lat)
    np_lon = np.array(lon)
    
    #Get the spatial extents of the data
    num_cols = float(np_data.shape[1])
    num_rows = float(np_data.shape[0])
    xmin = np_lon.min()
    xmax = np_lon.max()
    ymin = np_lat.min()
    ymax = np_lat.max()
    xres = (xmax - xmin)/num_cols
    yres = (ymax - ymin)/num_rows
    
    #Set up the transformation necessary to create the raster
    geotransform = (xmin, xres, 0, ymax, 0, -yres)
    
    #Create the raster object with the proper coordinate encoding and geographic transformation
    driver = gdal.GetDriverByName('GTiff')
    raster = driver.Create(dataset+'Raster.tif', int(num_cols), int(num_rows), 1, gdal.GDT_Float32)
    raster.SetGeoTransform(geotransform)
    srs = osr.SpatialReference()
    srs.ImportFromEPSG(4326)
    
    #Export and write the data array to the raster
    raster.SetProjection( srs.ExportToWkt() )
    raster.GetRasterBand(1).WriteArray(np_data)
    h5File.close()

#Create an array of the datasets we want to use
#Replace 'snow_mass' and 'snow_depth' with the datasets you want to use
datasets = ['sm_surface_wetness', 'soil_temp_layer2']

#Loop through the datasets and create individual rasters from them
for i in range(0, len(datasets)):
    smap2raster(file_path, which_group, datasets[i])
```

# Step 4: Creating a Raster Stack

After running the above code, we have individual raster images (.tif files); the number of which depends on the amount of datasets you used (in this example we used two). Now that we have these individual rasters, we want to merge or "stack" them on top of each other. GDAL has a python script which accomplishes just this. The result of running this will be a new .tif file called out.tif which is the merging or 'stacking' of the 2 rasters we created in Step 2.


```python
# download python helper script to create raster stacks
pythonfileDL = urllib.URLopener()
url = 'https://svn.osgeo.org/gdal/trunk/gdal/swig/python/scripts/gdal_merge.py'
pythonfileDL.retrieve(url, 'gdal_merge.py')
```




    ('gdal_merge.py', <httplib.HTTPMessage instance at 0x106546830>)




```python
# create raster stacks
%run gdal_merge.py sm_surface_wetnessRaster.tif soil_temp_layer2Raster.tif
```