---
layout: single
title: "Find and Download MODIS Data From the USGS Earth Explorer Website"
excerpt: "Learn how to find and download MODIS data from the USGS Earth Explorer website."
authors: ['Nathan Korinek', 'Leah Wasser', 'Jenny Palomino']
dateCreated: 2020-03-01
modified: 2020-03-18
category: [courses]
class-lesson: ['modis-multispectral-rs-python']
permalink: /courses/use-data-open-source-python/hierarchical-data-formats-hdf/intro-to-hdf4/download-hdf4-data
nav-title: 'Get MODIS data'
week: 5
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

* Learn different MODIS products available on EarthExplorer and their unique qualities
* Get MODIS data from EarthExplorer

</div>

In this lesson you will learn how to download MODIS data from EarthExplorer, and about the distinct qualities of the different MODIS products available.


## MODIS Products

### Aqua and Terra

MODIS, unlike Landsat satellites, is not just one satellite. MODIS consists of two seperate satellites with distinct missions. The appropriately named Aqua and Terra satellites both focus their data collection on their area of specialty, water and land respectively. For land based earth analytics projects, such as calculating NDVI or NBR, you should generally be getting your data from the Terra satellite, as it is the one that focuses on land based data collection.

### Products made with MODIS data

Where Landsat 8 collects 11 bands of data, the MODIS satellites collect 36. Due to the large number of bands, much of the MODIS data that is available for download is pre-processed heavily to make it more easily accessible. Below is a list of all of the MODIS products available to download from USGS EarthExplorer. 


<figure>
   <a href="{{ site.url }}/images/earth-analytics/remote-sensing/hdf4-list-of-dataset.png">
   <img src="{{ site.url }}/images/earth-analytics/remote-sensing/hdf4-list-of-dataset.png" alt="List of Product Types for MODIS available on EarthExplorer">
    </a>
   <figcaption>List of Product Types for MODIS data available on the USGS EarthExplorer website.  
   </figcaption>
</figure>


As you can see there are a lot of them! For general earth analytics products, such as calculating NDVI or NBR, the surface reflectance products are fairly standard products to use. You can see a complete list of available products that use MODIS data <a href="https://modis.gsfc.nasa.gov/data/dataprod/" target="_blank">here</a>. Note that it is much easier to use the pre-processed data such as surface reflectance, and not the more raw data like the raw radiance product. Surface reflectance, and other products like it, has already been geolocated, and has had a number of atmospheric corrections applied to it. Raw reflectance, and other Level 1 products, has not had any of that processing done.

### Surface Reflectance Products

You may notice that once we narrow our search down to just the surface reflectance products from MODIS, we still have many options (seen below). 


<figure>
   <a href="{{ site.url }}/images/earth-analytics/remote-sensing/hdf4-list-of-surf-refl.png">
   <img src="{{ site.url }}/images/earth-analytics/remote-sensing/hdf4-list-of-surf-refl.png" alt="List of surfance reflectance products from MODIS available on EarthExplorer">
    </a>
   <figcaption>List of surface reflectance products available on the USGS EarthExplorer website.  
   </figcaption>
</figure>


The name of each product contains some information about what the products consist of. For surface reflectance, the second letter of the name is either an `O` or a `Y`. `O` means that the data came from the Terra satellite, and `Y` means that the data came from the Aqua satellite. So if you want land based data, you would be looking to choose a product that begins with `MO`.

By hovering over each products name, you can find out more about the product. You can also find more data on each product on the <a href="https://modis.gsfc.nasa.gov/data/dataprod/mod09.php" target="_blank">MODIS website</a>. MODIS products can vary widly. MODIS makes a complete pass of the Earth daily. Some products are created daily based on the individual readings for the day, and others are weekly averages of an area, to help account for cloud cover or other interference that can occur from day to day. Some products are even yearly, such as the MODIS land cover product, which is a composite of an entire year's worth of data. 

In the surface reflectance category you can see these differences in spatial and temporal resolution. 

A product like `MOD09GA` is the highest resolution daily product that has all seven wavelengths available in it. It is the base for many of the other products created from MODIS data, and used frequently for earth analytics projects.

You'll notice that there is also a daily surface reflectance product with a higher resolution called `MOD09GQ`. However, this product only has bands 1 and 2, as the rest of the MODIS bands are not high enough resolution to be released in this product. 

For surface reflection, there are also averages that are collected over 8 days, such as `MOD09A1`. An advantage of this data over the daily data is that since it's a week long average, it allows for some layers of the data, such as the `Surface reflectance 500m state flags` QC layer, to be higher resolution than the daily products. 

## How to Download MODIS data

Downloading MODIS data is fairly simple, and very similar to downloading any other type of satellite data, such as Landsat data. 


### Step 1: Define Your Study Area (AOI)

When searching for data, the first thing that you need to do is to define your
area of interest (AOI). You could type in the x,y vertices of each corner of a boundary,
but if you have an Earth Explorer account, you can upload a ZIPPED up shapefile that
contains the boundary instead.

<figure>
    <a href="{{ site.url }}/images/earth-analytics/spatial-data/spatial-extent.png">
    <img src="{{ site.url }}/images/earth-analytics/spatial-data/spatial-extent.png" alt="Spatial extent.">
    </a>
    <figcaption>Remember that the spatial extent of a spatial object, is the geographic area that
    your data cover on the ground. In the case of vector data - this represents
    the minimum and maximum x and y values for each corner boundary of the dataset.
    Source: Colin Williams, NEON.
    </figcaption>
</figure>

Important: Be sure to use a square / rectangular extent polygon. If you
have too many vertices in your extent polygon, the website won't accept it as an
extent file.

To define your AOI in Earth Explorer:

* Zip up extent file that you want to use. Be sure to use a square extent, if you
have too many vertices it won't work.
* Next, go to <a href="http://earthexplorer.usgs.gov" target="_blank">the Earth Explorer website</a>. Login. If you don't have a login already, create an account.

Be sure to create an account. You will need it to be able to use your shapefile
extent to search for data. Now, it's time to search for data.

* In the search criteria, click on <kbd>KML/Shapefile Upload</kbd> tab. Use the drop down menu to select <kdb>Shapefile</kdb>, than click the <kdb>Select File</kdb> button. Select the zip file above as the shapefile that represents the SPATIAL EXTENT of your study area.
* At the bottom of the search criteria window, select a range of dates. 

<figure>
    <a href="{{ site.url }}/images/earth-analytics/remote-sensing/hdf4-aoi-selection.png">
    <img src="{{ site.url }}/images/earth-analytics/remote-sensing/hdf4-aoi-selection.png" alt="Earth explorer search criteria.">
    </a>
    <figcaption> Notice the KML/Shapefile Upload tab mid way down in this image. This is the tab
    you need to click on to upload a zipped up shapefile extent to Earth Explorer.
    At the bottom of the image, notice there is a date range tab. This is where
    you set the data collection date range that you require. 
    </figcaption>
</figure>

### Step 2: Define the Data That You Want to Download


* Next click on the <kbd>Data sets</kbd> tab. A common dataset to use is MOD09GA, so let's use that. You can find MOD09GA in the NASA LPDAAC Collections drop down. Expand that drop down to find:
  * MODIS Land Surface Reflectance - V6
  
* Once you've found MODIS Land Surface Reflectance - V6, select the checkbox labelled:
    * MODIS MOD09GA V6

* Note that if you hover over the option, a pop up appears on your cursor telling you more details about the product and what makes it unique from the of MODIS Land Surface Reflectance options. 
  

<figure>
    <a href="{{ site.url }}/images/earth-analytics/remote-sensing/hdf4-MODIS-info.png">
   <img src="{{ site.url }}/images/earth-analytics/remote-sensing/hdf4-MODIS-info.png" alt="Hover text for MODIS data.">
    </a>
    <figcaption>Hover text data provided by Earth Explorer to show more information on each MODIS product.
    </figcaption>
</figure>


### Step 3: Define Selection Criteria

* Next select the <kbd>Additional Criteria</kbd> tab. Unlike Landsat data, you cannot limit results by % cloud cover. However, you can limit results to just be images taken during the day, which is helpful to narrow down the results.


<figure>
    <a href="{{ site.url }}/images/earth-analytics/remote-sensing/hdf4-additional-criteria.png">
    <img src="{{ site.url }}/images/earth-analytics/remote-sensing/hdf4-additional-criteria.png" alt="Earth explorer search criteria.">
    </a>
    <figcaption>When you click on the additional criteria tab, you can further filter data results. In this case, we have few options as how to filter our data, but we can at least make sure our study area data was collected during the day. 
    </figcaption>
</figure>


### Step 4: View Results & Select Data to Order / Download

* Finally click on the Results tab. Here you see all of the scenes available for download from the website that cover your study area.
* Notice that you can click on the icons below the scene to see the scene itself rendered on the map and to see the footprint (or extent) of the scene relative to your study area. 


### Step 5: Download Your Data

* Click the <i class="fa fa-download" aria-hidden="true"></i> download data icon to being the download process.
* Click on the download button next to the "HDF Format" option in the pop up window.
* A pop up will appear stating that "https://urs.earthdata.nasa.gov is requesting your username and password." You must sign in to a valid Earthdata account through NASA in order to access the data. 
    * **IMPORTANT:** If you do not have a sign in for Earthdata, you have to create one at this <a href="https://urs.earthdata.nasa.gov//users/new">link here</a>. You're required to give an email, and if you don't want them to email you anything besides a confirmation email, make sure to uncheck all boxes that aren't the acknowledgement of their data policies at the end of the page. 
* Once you've successfully logged into your Earthdata account, the download will begin, and you can start using your MODIS data! 
