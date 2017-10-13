---
layout: single
title: 'Create rasters from SMAP data in Python'
date: 2016-06-28
authors: [Matt Oakley, Zach Schira]
category: [tutorials]
excerpt: 'This tutorial demonstrates how to access SMAP data, and how to generate raster output from this data.'
sidebar:
  nav:
author_profile: false
comments: true
lang: [python]
lib: [requests, xml, gdal, numpy, zipfile, os]
---

The National Snow and Ice Data Center hosts soil moisture data (from the NASA Soil Moisture Active Passive project, described [here](https://nsidc.org/data/smap), and hereafter referred to as SMAP) which is provided in Several different formats. For most uses it will be easiest to access save this data in GeoTIFF files, which is a common file format for saving spatially referenced data.

This tutorial demonstrates how to access SMAP data, and how to generate raster output from that data. A raster is a two dimensional array, with each element in the array containing a specific value. In this case, the two dimensions correspond to longitude and latitude, and the elements or values represent soil moisture.
    
## Objectives

1. Read in SMAP data file (in .h5 format)
2. Extract specified data
3. Create a raster object

### Dependencies

This tutorial requires h5py, gdal, and numpy. Ensure that you already have python and pip installed.


```python
import requests
from xml.etree import ElementTree
import gdal
import zipfile
import numpy as np
import os
```

# Step 1: Getting our data

To access SMAP data programmatically you will need to start by creating Earthdata login credentials [here](https://urs.earthdata.nasa.gov/). Once you have registered with Earthdata you will need to obtain a token for accessing the api. To do this you must post a small piece of xml to an https server. To do this replace `my_username`, `my_password`, and `my_ip_address` with your personal credentials. If you have used valid login info, you should be able to run the following section of code and obtain a response containing your token. More information on creating a token can be found [here](https://wiki.earthdata.nasa.gov/display/CMR/Creating+a+Token+Common).


```python
xml = """<token>
            <username>zasc3143</username>
            <password>Didkokpyd3#</password>
            <client_id>earthlab</client_id>
            <user_ip_address>2601:281:8200:b0fe:8d6:2b5c:88a9:1043</user_ip_address>
          </token>"""
headers = {'Content-Type': 'application/xml'} # set what your server accepts
r = requests.post('https://cmr.earthdata.nasa.gov/legacy-services/rest/tokens', data=xml, headers=headers)
```

This piece of code will parse the xml response, and extract your token.


```python
tree = ElementTree.fromstring(r.content)
token = tree[0].text
```

This code demonstrates how to actually obtain data. You will need to replace the email field with the email you used to register with Earthdata. You can also replace any of these other fields to fit the data you would like to retrieve. To view all options for these fields, as well as more fields that can be used, go [here](https://nsidc.org/support/how/how-do-i-programmatically-request-data-services) and scroll down to step 3.


```python
name = "SPL3SMP"
version = "004"
form = "GeoTIFF"
time = "2016-12-11,2016-12-15"
cov = "/Soil_Moisture_Retrieval_Data_AM/soil_moisture"
proj = "Geographic"
email = "zasc3143@colorado.edu"
url = "https://n5eil01u.ecs.nsidc.org/egi/request?short_name={}&version={}&format={}&time={}&Coverage={}&projection={}&token={}&email={}".format(
    name,version,form,time,cov,proj,token,email)
response = requests.get(url,stream=True)
```


```python
print(response.headers)
```

    {'Content-Disposition': 'attachment; filename="5000000040233.zip"', 'Transfer-Encoding': 'chunked', 'Keep-Alive': 'timeout=15, max=100', 'Server': 'Apache', 'Connection': 'Keep-Alive', 'Date': 'Fri, 22 Sep 2017 16:41:07 GMT', 'X-Frame-Options': 'SAMEORIGIN', 'Content-Type': 'application/xml'}


To save the data to a zip file run the following code.


```python
filename = 'smap.zip'
with open(filename, 'wb') as handle:
    for block in response.iter_content(1024):
        handle.write(block)
```

Now you will want to extract the zip file to access the data directly.


```python
zip_ref = zipfile.ZipFile(filename, 'r')
zip_ref.extractall('smap')
zip_ref.close()
```

Once the data has been extracted you can load the GeoTIFF files using GDAL to create a raster.


```python
directory = "smap/"
subdirects = os.listdir(directory)

gtiff = os.listdir(directory + subdirects[0] + "/")
raster = gdal.Open("smap/" + subdirects[0] + "/" + gtiff[0])
```

This next code block demonstrates how to create a raster stack. Each layer in this stack is taken from one of the GeoTIFFs downloaded in the previous steps. 


```python
stack = "stack.tif"
# Get the size of the geotiffs
x_pixels = raster.RasterXSize
y_pixels = raster.RasterYSize

# Get transformation/projection info
geotransform = raster.GetGeoTransform()
proj = raster.GetProjection()

# Create new tiff to store a raster stack as a single tiff
driver = gdal.GetDriverByName('GTiff')
dataset = driver.Create(
        stack,
        x_pixels,
        y_pixels,
        5,
        gdal.GDT_Float32)

# Set transform/proj from those found above
dataset.SetGeoTransform(geotransform)
dataset.SetProjection(proj)

# Read in individual tiff files, and save to bands in stack
band = 1
for subdirect in subdirects:
    files = os.listdir("smap/" + subdirect + "/")
    for gtiff in files:
        raster = gdal.Open("smap/" + subdirect + "/" + gtiff)
        raster = np.array(raster.GetRasterBand(1).ReadAsArray())
        dataset.GetRasterBand(band).WriteArray(raster)
        band = band + 1
```
