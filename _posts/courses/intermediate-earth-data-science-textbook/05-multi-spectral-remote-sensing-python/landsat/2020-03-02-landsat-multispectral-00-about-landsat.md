---
layout: single
title: "Work with Landsat Remote Sensing Data in Python"
excerpt: "Landsat 8 data are downloaded in tif file format. Learn how to open and manipulate Landsat 8 data in Python. Also learn how to create RGB and color infrared Landsat image composites."
authors: ['Leah Wasser']
dateCreated: 2018-04-14
modified: 2020-04-02
category: [courses]
class-lesson: ['multispectral-remote-sensing-data-python-landsat']
permalink: /courses/use-data-open-source-python/multispectral-remote-sensing/landsat-in-Python/
nav-title: 'About Landsat Data'
module-title: 'Learn How to Work With Landsat Multispectral Remote Sensing Data in Python'
module-description: 'Learn how to work with Landsat multi-band raster data stored in .tif format in Python using Rasterio'
module-nav-title: 'Landsat'
module-type: 'class'
week: 5
chapter: 9
class-order: 3
course: "intermediate-earth-data-science-textbook"
sidebar:
  nav:
author_profile: false
comments: true
order: 1
topics:
  remote-sensing: ['landsat']
  reproducible-science-and-programming: ['python']
  spatial-data-and-gis: ['raster-data']
redirect_from:
  - "/courses/earth-analytics-python/multispectral-remote-sensing-in-python/landsat-bands-geotif-in-Python/"
---

{% include toc title="In This Chapter" icon="file-text" %}

<div class='notice--success' markdown="1">

## <i class="fa fa-ship" aria-hidden="true"></i> Chapter Nine - Landsat Data in Python

In this chapter, you will learn how to work with Landsat multi-band raster data stored in `.tif` format in **Python** using **rasterio**.

## <i class="fa fa-graduation-cap" aria-hidden="true"></i> Learning Objectives

After completing this chapter, you will be able to:

* Use `glob()` to create a subsetted list of file names within a specified directory on your computer.
* Create a raster stack from a list of `.tif` files in **Python**.
* Crop rasters to a desired extent in **Python**.
* Plot various band combinations using a numpy array in **Python**.

## <i class="fa fa-check-square-o fa-2" aria-hidden="true"></i> What You Need

You will need a computer with internet access to complete this lesson and the Cold Springs Fire data.

{% include /data_subsets/course_earth_analytics/_data-cold-springs-fire.md %}

</div>


In the previous lessons in this textbook, you learned how to import a multi-band image into **Python** using
**rasterio**. You then plotted the data as a composite, RGB (and CIR) image using `imshow()` and calculated NDVI. 

In that case, all bands of the data were stored in a single `.tif` file. However, sometimes data are downloaded in individual bands rather than a single file.

In this chapter, you will learn how to work with Landsat data in **Python**. Each band in a landsat scene is often stored in an individual `.tif` file.  Thus you will need to grab the bands that you want to work with and then bring them into a `numpy` array. 


## About Landsat Data

> At over 40 years, the Landsat series of satellites provides the longest temporal record of moderate resolution multispectral data of the Earth’s surface on a global basis. The Landsat record has remained remarkably unbroken, proving a unique resource to assist a broad range of specialists in managing the world’s food, water, forests, and other natural resources for a growing world population.  It is a record unmatched in quality, detail, coverage, and value. Source: <a href="https://www.usgs.gov/land-resources/nli/landsat/about?qt-science_support_page_related_con=2#qt-science_support_page_related_con" target="_blank">USGS</a>


<figure>
    <a href="{{ site.url }}/images/earth-analytics/remote-sensing/timeline-only-for-webRGB.png">
    <img src="{{ site.url }}/images/earth-analytics/remote-sensing/timeline-only-for-webRGB.png" alt="Landsat 40 year timeline source: USGS.">
    </a>
    <figcaption>The 40 year history of landsat missions. Source: USGS - <a href="https://www.usgs.gov/land-resources/nli/landsat/landsat-satellite-missions?qt-science_support_page_related_con=2#qt-science_support_page_related_con" target = "_blank">USGS Landsat Timeline</a>
    </figcaption>
</figure>

Landsat data are spectral and collected using a platform mounted on a satellite in space that orbits the earth. The spectral bands
and associated spatial resolution of the first 9 bands in the Landsat 8 sensor
are listed below.

#### Landsat 8 Bands

| Band | Wavelength range (nanometers) | Spatial Resolution (m) | Spectral Width (nm)| Units | Data Type | Fill Value (no data) |  Range |Valid Range | Scale Factor |
|-------------------------------------|------------------|--------------------|----------------|----------------|----------------|----------------|---------------------| ----------------|----------------|
| Band 1 - Coastal aerosol | 430 - 450 | 30 | 2.0 | Reflectance | 16-bit signed integer (int16) | -9999 | -2000 to 16000 |0 to 10000 | 0.0001 |
| Band 2 - Blue | 450 - 510 | 30 | 6.0 |  Reflectance | 16-bit signed integer (int16) | -9999 | -2000 to 16000 |0 to 10000 | 0.0001 |
| Band 3 - Green | 530 - 590 | 30 | 6.0 |  Reflectance | 16-bit signed integer (int16) | -9999 | -2000 to 16000 |0 to 10000 | 0.0001 |
| Band 4 - Red | 640 - 670 | 30 | 0.03 |  Reflectance | 16-bit signed integer (int16) | -9999 | -2000 to 16000 |0 to 10000 | 0.0001 |
| Band 5 - Near Infrared (NIR) | 850 - 880 | 30 | 3.0 |  Reflectance | 16-bit signed integer (int16) | -9999 | -2000 to 16000 |0 to 10000 | 0.0001 |
| Band 6 - SWIR 1 | 1570 - 1650 | 30 | 8.0  |  Reflectance | 16-bit signed integer (int16) | -9999 | -2000 to 16000 |0 to 10000 | 0.0001 |
| Band 7 - SWIR 2 | 2110 - 2290 | 30 | 18 |  Reflectance | 16-bit signed integer (int16) | -9999 | -2000 to 16000 |0 to 10000 | 0.0001 |

Review the <a href="https://prd-wret.s3.us-west-2.amazonaws.com/assets/palladium/production/atoms/files/LSDS-1368_L8_SurfaceReflectanceCode-LASRC_ProductGuide-v2.pdf" target="_blank">Landsat 8 Surface Reflectance Product Guide</a> for more details.

There are additional collected bands that are not distributed within the Landsat 8 Surface Reflectance Product such as the panchromatic band, which provides a finer resolution, gray scale image of the landscape, and the cirrus cloud band, which is used in the quality assessment process:


| Band | Wavelength range (nanometers) | Spatial Resolution (m) | Spectral Width (nm)|
|-------------------------------------|------------------|--------------------|----------------|
| Band 8 - Panchromatic | 500 - 680 | 15 | 18 |  
| Band 9 - Cirrus | 1360 - 1380 | 30 | 2.0 |  


### Understand Landsat Data

When working with landsat, it is important to understand both the metadata and
the file naming convention. The metadata tell you how the data were processed,
where the data are from and how they are structured.

The file names, tell you what sensor collected the data, the date the data were collected, and more.

<figure>
    <a href="{{ site.url }}/images/earth-analytics/remote-sensing/collection-filename-diffs.png">
    <img src="{{ site.url }}/images/earth-analytics/remote-sensing/collection-filename-diffs.png" alt="landsat file naming convention">
    </a>
    <figcaption>Landsat file names Source: USGS Landsat - <a href="https://www.usgs.gov/faqs/what-naming-convention-landsat-collections-level-1-scenes?qt-news_science_products=0#qt-news_science_products" target = "_blank">Landsat Scene Naming Conventions</a>
    </figcaption>
</figure>

### Landsat File Naming Convention

Landsat and many other satellite remote sensing data is named in a way that tells you a about:

* When the data were collected and processed
* What sensor was used to collect the data
* What satellite was used to collect the data.

And more. 

Here you will learn a few key components of the landsat 8 collection file name. The first scene that you work with below is named:

`LC080340322016072301T1-SC20180214145802`

First, we have LC08

* **L:** Landsat Sensor
* **C:** OLI / TIRS combined platform
* **08:** Landsat 8 (not 7)

* **034032:** The next 6 digits represent the path and row of the scene. This identifies the spatial coverage of the scene

Finally, you have a date. In your case as follows:

* **20160723:** representing the year, month and day that the data were collected.

The second part of the file name above tells you more about when the data were last processed. You can read more about this naming convention using the link below.

<a href="https://www.usgs.gov/faqs/what-naming-convention-landsat-collections-level-1-scenes?qt-news_science_products=0#qt-news_science_products" target="_blank">Learn more about Landsat 8 file naming conventions.</a>

As you work with these data, it is good to double check that you are working with the sensor (Landsat 8) and the time period that you intend. Having this information in the file name makes it easier to keep track of this as you process your data. 

{:.input}
```python
import os
from glob import glob # File manipulation
import matplotlib.pyplot as plt
import numpy as np
import geopandas as gpd
import rasterio as rio
import earthpy as et
import earthpy.spatial as es
import earthpy.plot as ep

# Download data and set working directory
data = et.data.get_data('cold-springs-fire')
os.chdir(os.path.join(et.io.HOME, 'earth-analytics'))
```

{:.output}
    Downloading from https://ndownloader.figshare.com/files/10960109
    Extracted output to /root/earth-analytics/data/cold-springs-fire/.



{:.input}
```python
# Get list of all pre-cropped data and sort the data

path = os.path.join("data", "cold-springs-fire", "landsat_collect", 
                    "LC080340322016072301T1-SC20180214145802", "crop")

all_landsat_post_bands = glob(path + "/*band*.tif")

all_landsat_post_bands.sort()
```

{:.input}
```python
# Create an output array of all the landsat data stacked
landsat_post_fire_path = os.path.join("data", "cold-springs-fire", 
                                      "outputs", "landsat_post_fire.tif")

# This will create a new stacked raster with all bands 
land_stack, land_meta = es.stack(all_landsat_post_bands,
                                 landsat_post_fire_path)
```

#### Open The New Raster Stack 

Once you have stacked your data, you can import it and work with it as you need to!


{:.input}
```python
with rio.open(landsat_post_fire_path) as src:
    landsat_post_fire = src.read()
```

## Plot RGB image

Just like you did with NAIP data, you can plot 3 band color composite images with Landsat too. Below you will plot an RGB image using landsat. Refer to the landsat bands in the table
at the top of this page to figure out the red, green and blue bands. Or read the
<a href="https://blogs.esri.com/esri/arcgis/2013/07/24/band-combinations-for-landsat-8/" target="_blank">ESRI landsat 8 band combinations</a> post.

To make plotting less code intensive we have created a plot_rgb function that allows you to quickly make a 3 band raster plot. To use it simply provide 

1. the numpy array containing the bands that you wish to plot. 

IMPORTANT: this array should be in rasterio band order (bands first). 

2. The bands that you wish to plot in the array.

Optionally you can chose to provide a title for the plot, and the figure size if you'd like. 

{:.input}
```python
ep.plot_rgb(landsat_post_fire,
            rgb=[3, 2, 1],
            title="RGB Composite Image\n Post Fire Landsat Data")
plt.show()
```

{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}/images/courses/intermediate-earth-data-science-textbook/05-multi-spectral-remote-sensing-python/landsat/2020-03-02-landsat-multispectral-00-about-landsat/2020-03-02-landsat-multispectral-00-about-landsat_8_0.png" alt = "Landsat 8 3 band color RGB composite.">
<figcaption>Landsat 8 3 band color RGB composite.</figcaption>

</figure>




Notice that the image above looks dark. You can stretch the image as you did with the NAIP data, too.
Below you use the stretch argument built into the earthpy `plot_rgb()` function. The `str_clip` argument allows you to specify how much of the tails of the data that you want to clip off. The larger the number, the most the data will be stretched or brightened.

<figure>
    <a href="{{ site.url }}/images/earth-analytics/raster-data/raster-image-stretch-dark.jpg">
    <img src="{{ site.url }}/images/earth-analytics/raster-data/raster-image-stretch-dark.jpg" alt="When the range of pixel brightness values is closer to 0, a
    darker image is rendered by default. You can stretch the values to extend to
    the full 0-255 range of potential values to increase the visual contrast of
    the image.">
    </a>
    <figcaption>When the range of pixel brightness values is closer to 0, a
    darker image is rendered by default. You can stretch the values to extend to
    the full 0-255 range of potential values to increase the visual contrast of
    the image.
    </figcaption>
</figure>

<figure>
    <a href="{{ site.url }}/images/earth-analytics/raster-data/raster-image-stretch-light.jpg">
    <img src="{{ site.url }}/images/earth-analytics/raster-data/raster-image-stretch-light.jpg" alt="When the range of pixel brightness values is closer to 255, a
    lighter image is rendered by default. You can stretch the values to extend to
    the full 0-255 range of potential values to increase the visual contrast of
    the image.">
    </a>
    <figcaption>When the range of pixel brightness values is closer to 255, a
    lighter image is rendered by default. You can stretch the values to extend to
    the full 0-255 range of potential values to increase the visual contrast of
    the image.
    </figcaption>
</figure>

{:.input}
```python
ep.plot_rgb(landsat_post_fire,
            rgb=[3, 2, 1],
            title="Landsat RGB Image\n Linear Stretch Applied",
            stretch=True,
            str_clip=1)
plt.show()
```

{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}/images/courses/intermediate-earth-data-science-textbook/05-multi-spectral-remote-sensing-python/landsat/2020-03-02-landsat-multispectral-00-about-landsat/2020-03-02-landsat-multispectral-00-about-landsat_10_0.png" alt = "Landsat 3 band RGB color composite with stretch applied.">
<figcaption>Landsat 3 band RGB color composite with stretch applied.</figcaption>

</figure>




{:.input}
```python
# Adjust the amount of linear stretch to futher brighten the image
ep.plot_rgb(landsat_post_fire,
            rgb=[3, 2, 1],
            title="Landsat RGB Image\n Linear Stretch Applied",
            stretch=True,
            str_clip=4)
plt.show()
```

{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}/images/courses/intermediate-earth-data-science-textbook/05-multi-spectral-remote-sensing-python/landsat/2020-03-02-landsat-multispectral-00-about-landsat/2020-03-02-landsat-multispectral-00-about-landsat_11_0.png" alt = "Landsat 3 band RGB color composite with stretch and more clip applied.">
<figcaption>Landsat 3 band RGB color composite with stretch and more clip applied.</figcaption>

</figure>




## Raster Pixel Histograms

You can create a histogram to view the distribution of pixel values in the rgb bands plotted above. 

{:.input}
```python
# Plot all band histograms using earthpy
band_titles = ["Band 1", "Blue", "Green", "Red", 
               "NIR", "Band 6", "Band7"]

ep.hist(landsat_post_fire,
        title=band_titles)

plt.show()
```

{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}/images/courses/intermediate-earth-data-science-textbook/05-multi-spectral-remote-sensing-python/landsat/2020-03-02-landsat-multispectral-00-about-landsat/2020-03-02-landsat-multispectral-00-about-landsat_13_0.png" alt = "Landsat 8 histogram for each band.">
<figcaption>Landsat 8 histogram for each band.</figcaption>

</figure>





### Plot CIR

Now you've created a red, green blue color composite image. Remember red green and blue are colors that
your eye can see. 

Next, create a color infrared image (CIR) using landsat bands: 4,3,2.

{:.input}
```python
ep.plot_rgb(landsat_post_fire, rgb=[4, 3, 2],
            title="CIR Landsat Image Pre-Cold Springs Fire",
            figsize=(10, 10))
plt.show()
```

{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}/images/courses/intermediate-earth-data-science-textbook/05-multi-spectral-remote-sensing-python/landsat/2020-03-02-landsat-multispectral-00-about-landsat/2020-03-02-landsat-multispectral-00-about-landsat_16_0.png" alt = "Landsat 8 CIR color composite image.">
<figcaption>Landsat 8 CIR color composite image.</figcaption>

</figure>




<div class="notice--success" markdown="1">
<i class="fa fa-star"></i> **Data Tip:** Landsat 8 Pre Collections Data

If you are working with Landsat data downloaded pre USGS collections, your data may be formatted and named slightly differently than the example shown on this page. Below is an explanation of the legacy Landsat 8 naming convention. 

File: `LC08_L1TP_034032_20160707_20170221_01_T1_sr_band1_crop.tif`

| Sensor | Sensor | Satellite | WRS path | WRS row | | | | |
|-------|
| L | C | 8 | 034| 032| 2016 |0707 | 20170221 | 01 |
| Landsat | OLI & TIRS | Landsat 8 | path = 034 | row = 032 | year = 2016 | Month = 7, day = 7 | Processing Date: 2017-02-21 (feb 21 2017) | Archive (second version): 01 |

* L: Landsat
* X: Sensor
  * C = OLI & TIRS
    O = OLI only
    T = IRS only
    E = ETM+
    T = TM
    M = MSS

* S Satelite
* PPP
* RRR
* YYYY = Year
* DDD = Julian DAY of the year
* GSI - Ground station ID
* VV = Archive Version

<a href="http://gisgeography.com/landsat-file-naming-convention/" target="_blank"> More here breaking down the file name.</a>

## Julian day

We won't spend a lot of time on Julian days. The julian day used to be used in Landsat pre collections file naming. However recently they have switched to a normal year-month-date format

See this link that provide tables to help you <a href="https://landweb.modaps.eosdis.nasa.gov/browse/calendar.html" target="_blank">convert julian days to actual date</a>.


</div>
