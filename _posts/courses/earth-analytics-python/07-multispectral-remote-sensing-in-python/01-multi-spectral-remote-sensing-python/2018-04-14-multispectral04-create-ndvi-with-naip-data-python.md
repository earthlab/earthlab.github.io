---
layout: single
title: "Calculate NDVI Using NAIP Remote Sensing Data in the Python Programming Language"
excerpt: "A vegetation index is a single value that quantifies vegetation health or structure. Learn how to calculate the NDVI vegetation index using NAIP data in Python."
authors: ['Leah Wasser', 'Chris Holdgraf']
modified: 2018-09-07
category: [courses]
class-lesson: ['multispectral-remote-sensing-data-python']
permalink: /courses/earth-analytics-python/multispectral-remote-sensing-in-python/vegetation-indices-NDVI-in-python/
nav-title: 'NDVI vegetation index'
week: 7
course: "earth-analytics-python"
sidebar:
  nav:
author_profile: false
comments: true
order: 4
topics:
  remote-sensing: ['landsat', 'modis']
  earth-science: ['fire']
  reproducible-science-and-programming:
  spatial-data-and-gis: ['raster-data']
lang-lib:
  python: []
---

<div class='notice--success' markdown="1">

## <i class="fa fa-graduation-cap" aria-hidden="true"></i> Learning Objectives

After completing this tutorial, you will be able to:

* Calculate NDVI using NAIP multispectral imagery in `Python`.
* Describe what a vegetation index is and how it is used with spectral remote sensing data.
* Export or write a raster to a `.tif` file from `Python`.

## <i class="fa fa-check-square-o fa-2" aria-hidden="true"></i> What You Need

You will need a computer with internet access to complete this lesson and the Cold Springs Fire
data.

{% include/data_subsets/course_earth_analytics/_data-cold-springs-fire.md %}
</div>

## About Vegetation Indices

A vegetation index is a single value that quantifies vegetation health or structure.
The math associated with calculating a vegetation index is derived from the physics
of light reflection and absorption across bands. For instance, it is known that
healthy vegetation reflects light strongly in the near infrared band and less strongly
in the visible portion of the spectrum. Thus, if you create a ratio between light
reflected in the near infrared and light reflected in the visible spectrum, it
will represent areas that potentially have healthy vegetation.


## Normalized Difference Vegetation Index (NDVI)

The Normalized Difference Vegetation Index (NDVI) is a quantitative index of
greenness ranging from 0-1 where 0 represents minimal or no greenness and 1
represents maximum greenness.

NDVI is often used for a quantitate proxy measure of vegetation health, cover
and phenology (life cycle stage) over large areas.

<figure>
 <a href="http://earthobservatory.nasa.gov/Features/MeasuringVegetation/Images/ndvi_example.jpg">
 <img src="http://earthobservatory.nasa.gov/Features/MeasuringVegetation/Images/ndvi_example.jpg" alt="NDVI image from NASA that shows reflectance."></a>
    <figcaption>NDVI is calculated from the visible and near-infrared light
    reflected by vegetation. Healthy vegetation (left) absorbs most of the
    visible light that hits it, and reflects a large portion of
    near-infrared light. Unhealthy or sparse vegetation (right) reflects more
    visible light and less near-infrared light. Source: NASA
    </figcaption>
</figure>

* <a href="http://earthobservatory.nasa.gov/Features/MeasuringVegetation/measuring_vegetation_2.php" target="_blank">
More on NDVI from NASA</a>

## Calculate NDVI in Python

Sometimes you can download already calculated NDVI data products from a data provider. 

However, in this case, you don't have a pre calculated NDVI product from NAIP data. You need to calculate NDVI using the NAIP imagery / reflectance data that you have downloaded from Earth Explorer.

### How to Derive the NDVI Vegetation Index From Multispectral Imagery

The normalized difference vegetation index (NDVI) uses a ratio between near infrared
and red light within the electromagnetic spectrum. To calculate NDVI you use the
following formula where NIR is near infrared light and
red represents red light. For your raster data, you will take the reflectance value
in the red and near infrared bands to calculate the index.

`(NIR - Red) / (NIR + Red)`

You can perform this calculation using matrix math with the `numpy` library.

To get started, load all of the required python libraries. 

{:.input}
```python
import rasterio as rio
import geopandas as gpd
import earthpy as et
import earthpy.spatial as es
import os
import matplotlib.pyplot as plt
from rasterio.plot import show
import numpy as np
plt.ion()
# set working directory to your home dir/earth-analytics
os.chdir(os.path.join(et.io.HOME, 'earth-analytics'))
import matplotlib as mpl
mpl.rcParams['figure.figsize'] = (14, 14)
mpl.rcParams['axes.titlesize'] = 20
```

Next, open up the NAIP data that you wish to calculate NDVI with. You will use the data from 2015 for this example that you downloaded for week 7 of this course:

`data/cold-springs-fire/naip/m_3910505_nw_13_1_20150919/crop/m_3910505_nw_13_1_20150919_crop.tif`

{:.input}
```python
with rio.open("data/cold-springs-fire/naip/m_3910505_nw_13_1_20150919/crop/m_3910505_nw_13_1_20150919_crop.tif") as src:
    naip_data = src.read()
    
# view shape of the data
naip_data.shape
```

{:.output}
{:.execute_result}



    (4, 2312, 4377)





Calculate NDVI using regular numpy array math. 

{:.input}
```python
naip_ndvi = (naip_data[3] - naip_data[0]) / (naip_data[3] + naip_data[0])
```

{:.input}
```python
# need to add a colorbar to this image
fig, ax = plt.subplots(figsize=(12,6))
ndvi = ax.imshow(naip_ndvi, cmap='PiYG')
es.colorbar(ndvi)
ax.set(title="NAIP Derived NDVI\n 19 September 2015 - Cold Springs Fire, Colorado")
ax.set_axis_off();
```

{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}//images/courses/earth-analytics-python/07-multispectral-remote-sensing-in-python/01-multi-spectral-remote-sensing-python/2018-04-14-multispectral04-create-ndvi-with-naip-data-python_8_0.png">

</figure>




If you'd like, you can use the earthpy colorbar function to ensure your colorbar is the 
same height as your image. You can also set the vmin and max arguments to -1 and 1 
to ensure your data colors are scaled to the full range of NDVI values. 

{:.input}
```python
# need to add a colorbar to this image
fig, ax = plt.subplots(figsize=(12,6))
ndvi = ax.imshow(naip_ndvi, cmap='PiYG',
                vmin=-1, vmax=1)
es.colorbar(ndvi)
ax.set(title="NAIP Derived NDVI\n 19 September 2015 - Cold Springs Fire, Colorado")
ax.set_axis_off();
```

{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}//images/courses/earth-analytics-python/07-multispectral-remote-sensing-in-python/01-multi-spectral-remote-sensing-python/2018-04-14-multispectral04-create-ndvi-with-naip-data-python_10_0.png">

</figure>




### View distribution of NDVI values

Using a histogram, you can view the distribution of pixel values in your NDVI output.

{:.input}
```python
es.hist(naip_ndvi,
       figsize=(12,6),
       titles=["NDVI: Distribution of pixels\n NAIP 2015 Cold Springs fire site"])
```

{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}//images/courses/earth-analytics-python/07-multispectral-remote-sensing-in-python/01-multi-spectral-remote-sensing-python/2018-04-14-multispectral04-create-ndvi-with-naip-data-python_12_0.png">

</figure>




## Export a Numpy Array to a Raster Geotiff in Python

When you are done, you can export your NDVI raster data so you could use them in
QGIS or ArcGIS or share them with your colleagues. To do this you use the `rio.write()`
function.

Exporting a raster in python is a bit different from what you may have learned using another language like `R`. In python, you need to: 

1. Create a new raster object with all of the metadata needed to define it. This metadata includes:
   * the shape (rows and columns) of the object
   * the coordinate reference system (crs)
   * the type of file (you will export a geotiff (.tif) in this lesson
   * and the type of data being stored (integer, float, etc). 
   
Lucky for you, all of this information can be accessed from the original NAIP data that you imported into python using attribute calls like:

`.transform` and
`.crs`

To implement this, below we will create a rasterio object (not using a context manager) to explore the attributes.
   

{:.input}
```python
with rio.open("data/cold-springs-fire/naip/m_3910505_nw_13_1_20150919/crop/m_3910505_nw_13_1_20150919_crop.tif") as src:
    naip_data_ras = src.read()
    naip_transform = src.transform
    naip_crs = src.crs
    naip_meta = src.profile

```

{:.output}
    /Users/lewa8222/anaconda3/envs/earth-analytics-python/lib/python3.6/site-packages/IPython/core/interactiveshell.py:2910: FutureWarning: The value of this property will change in version 1.0. Please see https://github.com/mapbox/rasterio/issues/86 for details.
      exec(code_obj, self.user_global_ns, self.user_ns)



{:.input}
```python
# view spatial attributes including transform information and 
# the CRS
naip_transform, naip_crs
```

{:.output}
{:.execute_result}



    ([457163.0, 1.0, 0.0, 4426952.0, 0.0, -1.0],
     CRS({'proj': 'utm', 'zone': 13, 'ellps': 'GRS80', 'towgs84': '0,0,0,0,0,0,0', 'units': 'm', 'no_defs': True}))





You can view the type of data stored within the ndvi array using `.dtype`.
Remember that the naip_ndvi object is a numpy array.

{:.input}
```python
type(naip_ndvi), naip_ndvi.dtype
```

{:.output}
{:.execute_result}



    (numpy.ndarray, dtype('float64'))





Use `rio.open()` to create a new blank raster 'template'. 
Then write the NDVI numpy array to to that template using `dst.write()`.

Note that when we write the data we need the following elements:

1. the driver or type of file that we want to write. 'Gtiff' is a geotiff format
2. dtype: the structure of the data that you are writing. We are writing floating point values (values with decimal places)
3. the heigth and width of the ndvi object (accessed using the .shape attribute)
4. the crs of the spatial object (accessed using the rasterio NAIP data)
5. the transform information (accessed using the rasterio NAIP data)

Finally you need to specify the name of the output file and the path to where it will be saved on your computer. 

You can manually specify each raster attribute when you export your geotiff.
```
# Write your the ndvi raster object
with rio.open('data/cold-springs-fire/outputs/naip_ndvi.tif', 'w', driver='GTiff', dtype='float64',
              height=naip_ndvi.shape[0], width=naip_ndvi.shape[1], count=1,
              crs=naip_data_ras.crs, transform=naip_data_ras.transform) as dst:
    dst.write(naip_ndvi, 1)
```


## Export a Numpy Array to a Raster Geotiff Using the Spatial Profile or Metadata of Another Raster
You can also use the naip_meta variable that we created above. This variable contains all of the spatial metadata for naip data.

In this case, the 

1. number of bands (we have only one band vs 4 in the color image) and
2. the data format (we have floating point numbers - numers with decimals - vs integers)

have changed. Update those values then write out the image.

{:.input}
```python
naip_meta

```

{:.output}
{:.execute_result}



    {'affine': Affine(1.0, 0.0, 457163.0,
           0.0, -1.0, 4426952.0),
     'compress': 'lzw',
     'count': 4,
     'crs': CRS({'proj': 'utm', 'zone': 13, 'ellps': 'GRS80', 'towgs84': '0,0,0,0,0,0,0', 'units': 'm', 'no_defs': True}),
     'driver': 'GTiff',
     'dtype': 'int16',
     'height': 2312,
     'interleave': 'band',
     'nodata': -32768.0,
     'tiled': False,
     'transform': (457163.0, 1.0, 0.0, 4426952.0, 0.0, -1.0),
     'width': 4377}





{:.input}
```python
# change the count or number of bands from 4 to 1
naip_meta['count'] = 1
# change the data type to float rather than integer
naip_meta['dtype'] = "float64"
naip_meta
```

{:.output}
{:.execute_result}



    {'affine': Affine(1.0, 0.0, 457163.0,
           0.0, -1.0, 4426952.0),
     'compress': 'lzw',
     'count': 1,
     'crs': CRS({'proj': 'utm', 'zone': 13, 'ellps': 'GRS80', 'towgs84': '0,0,0,0,0,0,0', 'units': 'm', 'no_defs': True}),
     'driver': 'GTiff',
     'dtype': 'float64',
     'height': 2312,
     'interleave': 'band',
     'nodata': -32768.0,
     'tiled': False,
     'transform': (457163.0, 1.0, 0.0, 4426952.0, 0.0, -1.0),
     'width': 4377}





Note below that when we write the raster, we use `**naip_meta`
The two ** tells Python to unpack all of the values in the naip_meta object to use as arguments when writing the geotiff file. We already updated the elements that we needed to above (count and dtype). So this naip_meta object is ready to be used for the NDVI raster. 

{:.input}
```python
# write your the ndvi raster object
with rio.open('data/cold-springs-fire/outputs/naip_ndvi.tif', 'w', **naip_meta) as dst:
    dst.write(naip_ndvi, 1)
```

{:.output}
    /Users/lewa8222/anaconda3/envs/earth-analytics-python/lib/python3.6/site-packages/rasterio/__init__.py:160: FutureWarning: GDAL-style transforms are deprecated and will not be supported in Rasterio 1.0.
      transform = guard_transform(transform)



## Post Fire NDVI

For your homework this week, you will get NAIP data from 2017 and will calculate the difference in NDVI between 2015 and 2017. The 2017 data is shown below for reference. 


{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}//images/courses/earth-analytics-python/07-multispectral-remote-sensing-in-python/01-multi-spectral-remote-sensing-python/2018-04-14-multispectral04-create-ndvi-with-naip-data-python_26_0.png">

</figure>




<div class="notice--info" markdown="1">

## Additional Resources

* <a href="https://phenology.cr.usgs.gov/ndvi_foundation.php" target="_blank">USGS Remote Sensing Phenology</a>
* <a href="http://earthobservatory.nasa.gov/Features/MeasuringVegetation/measuring_vegetation_2.php" target="_blank">NASA Earth Observatory - Vegetation Indices</a>

</div>
