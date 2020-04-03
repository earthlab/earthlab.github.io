---
layout: single
title: "Find and Download Landsat 8 Remote Sensing Data From the USGS Earth Explorer Website"
excerpt: "Learn how to find and download Landsat 8 remote sensing data from the USGS Earth Explorer website."
authors: ['Leah Wasser']
dateCreated: 2017-03-01
modified: 2020-04-02
category: [courses]
class-lesson: ['multispectral-remote-sensing-data-python-landsat']
permalink: /courses/use-data-open-source-python/multispectral-remote-sensing/landsat-in-Python/get-landsat-data-earth-explorer/
nav-title: 'Get Landsat Data - Earth Explorer'
week: 5
course: "intermediate-earth-data-science-textbook"
sidebar:
  nav:
author_profile: false
comments: true
order: 5
topics:
  remote-sensing: ['landsat']
  earth-science: ['fire']
  reproducible-science-and-programming: 
  spatial-data-and-gis: ['raster-data']
redirect_from:
  - "/courses/earth-analytics-python/multispectral-remote-sensing-modis/get-landsat-data-earth-explorer/"
---

{% include toc title="On This Page" icon="file-text" %}

<div class='notice--success' markdown="1">

## <i class="fa fa-graduation-cap" aria-hidden="true"></i> Learning Objectives

* Find and download data from the USGS Earth Explorer Website.
* Filter data by cloud cover to find datasets with the least amount of clouds for a study area.

</div>


In this chapter, you will review how to grab Landsat data from the Earth Explorer website. The Earth Explorer website is a data portal run by the USGS. Here you can find many different types of remote sensing and other data for both the US and in some cases, the globe.

<i class="fa fa-star" aria-hidden="true"></i> **IMPORTANT:** Be sure to order your data several days ahead of time or else you
won't have it in time to finish your homework.
{: .notice--success}


## How to Download Landsat Remote Sensing Data from Earth Explorer

### Step 1: Define Your Study Area (AOI)

When searching for data, the first thing that you need to do is to define your
area of interest (AOI). Your AOI for this week, is defined by the boundary of the Cold Springs
fire extent. You could type in the x,y vertices of each corner of the boundary,
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
have too many vertices it won't work. Lucky for us there is a zip file already zipped
up and ready to go in your cold-springs-fire download!
  `data/cold-springs-fire/vector_layers/fire_boundary_box_shp.zip`
* Next, go to <a href="http://earthexplorer.usgs.gov" target="_blank">the Earth Explorer website</a>. Login. If you don't have a login already, create an account.

Be sure to create an account. You will need it to be able to use your shapefile
extent to search for data. Now, it's time to search for data.

* In the search criteria, click on <kbd>shapefile</kbd> tab. Select the zip file above as the shapefile that represents the SPATIAL EXTENT of your study area - the Cold Springs fire site.
* At the bottom of the search criteria window, select a range of dates. A month before and after the fire is a nice starting point.

<figure>
    <a href="{{ site.url }}/images/earth-analytics/raster-data/ee-search-criteria.png">
    <img src="{{ site.url }}/images/earth-analytics/raster-data/ee-search-criteria.png" alt="Earth explorer search criteria.">
    </a>
    <figcaption> Notice the shapefile tab mid way down in this image. This is the tab
    you need to click on to upload a zipped up shapefile extent to Earth Explorer.
    At the bottom of the image, notice there is a date range tab. This is where
    you set the data collection date range that you require. In your case you want all images collected around the Cold Springs fire which occurred July 10-14 2016.
    </figcaption>
</figure>

### Step 2: Define the Data That You Want to Download


* Next click on the <kbd>Data sets</kbd> tab. Notice that there are a lot of different data available from Earth Explorer! You are interested in Landsat - specifically Landsat 8.  You can find Landsat in the Landsat archive drop down. Expand that drop down to find:
  * Landsat - Landsat Collection 1 Level-2 (On-Demand)

<figure>
    <a href="{{ site.url }}/images/earth-analytics/raster-data/ee-select-landsat8.png">
    <img src="{{ site.url }}/images/earth-analytics/raster-data/ee-select-landsat8.png" alt="Earth explorer search criteria.">
    </a>
    <figcaption>The Landsat 8 data are located in the Pre-Collection drop down.
    Be sure to select Landsat 8 OLI/TIRS C1 Level-2.
    </figcaption>
</figure>


### Step 3: Define Selection Criteria

* Next select the <kbd>Additional Criteria</kbd> tab. Here is where you can limit results by % cloud cover. Start with **Less than 20%** cloud cover and see what you get as data results.


<figure>
    <a href="{{ site.url }}/images/earth-analytics/raster-data/ee-cloud-cover.png">
    <img src="{{ site.url }}/images/earth-analytics/raster-data/ee-cloud-cover.png" alt="Earth explorer search criteria.">
    </a>
    <figcaption>When you click on the additional criteria tab, you can further filter data results. In this case, low cloud cover is a priority for your analysis. You can select
    Less than 20% cloud cover as a starting place to see if you can find a scene with
    little to not cloud cover over your AOI (area of interest).
    </figcaption>
</figure>


### Step 4: View Results & Select Data to Order / Download

* Finally click on the Results tab. Here you see all of the scenes available for "order" from the website that cover your study area.
* Notice that you can click on the icons below the scene to see the scene itself rendered on the map and to see the footprint (or extent) of the scene relative to your study area.
* Pick a scene that is:
  * closest to the pre-fire date (July 10 2016) and also that has the least amount of cloud cover close to your study area.


### Step 5: Order Your Data

* Click the <i class="fa fa-shopping-cart" aria-hidden="true"></i>
shopping cart icon to add the data to your cart.
* Click on "item basket" in the upper right hand corner of your browser to see what you have ordered.
* Click on <kbd>Proceed to Checkout</kbd>
* Then finally, click on <kbd>Submit Order </kbd>

<i class="fa fa-star" aria-hidden="true"></i>**IMPORTANT:** It will take a few days for the link that you can use to download your
data to be emailed to your account. Order now!
{: .notice--success}

## Explore Newly Downloaded Data

In this case, you wanted to download a scene very close to Julian day 189. Notice that the spatial extent of
the data that you download from Earth Explorer is much broader than the data that you worked with for your homework last week. The extents are different because your instructor cropped the class data to make is easier to work with!





