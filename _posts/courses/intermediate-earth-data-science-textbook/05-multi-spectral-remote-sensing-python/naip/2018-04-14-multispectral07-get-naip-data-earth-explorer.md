---
layout: single
title: "Get NAIP Remote Sensing Data From the Earth Explorer Website"
excerpt: "In this lesson you will review how to find and download USDS NAIP imagery from the USGS Earth Explorere website."
authors: ['Leah Wasser']
dateCreated: 2018-04-14
modified: 2020-03-18
category: [courses]
class-lesson: ['multispectral-remote-sensing-data-python-naip']
permalink: /courses/use-data-open-source-python/multispectral-remote-sensing/intro-naip/get-naip-data-earth-explorer/
nav-title: 'Get NAIP Data - Earth Explorer'
week: 5
course: "intermediate-earth-data-science-textbook"
sidebar:
  nav:
author_profile: false
comments: true
order: 2
topics:
  remote-sensing: ['landsat']
  earth-science: ['fire']
  reproducible-science-and-programming: ['python']
  spatial-data-and-gis: ['raster-data']
redirect_from:
  - "/courses/earth-analytics-python/multispectral-remote-sensing-in-python/get-naip-data-earth-explorer/"
---

{% include toc title="On This Page" icon="file-text" %}

<div class='notice--success' markdown="1">


## <i class="fa fa-graduation-cap" aria-hidden="true"></i> Learning Objectives

* Find and download NAIP data from the USGS Earth Explorer Website.
* Filter data by cloud cover to find datasets with the least amount of clouds for a study area.

</div>


On this page,  you will review how to grab NAIP data from the Earth Explorer website. The Earth Explorer website is a data portal run by the USGS. Here you can find many different types of remote sensing and other data for both the US and in some cases, the globe.


<i class="fa fa-star" aria-hidden="true"></i> **IMPORTANT:** Be sure to order your data several days ahead of time or else you won't have it in time to finish your homework.
{: .notice--success}

## How to Download Landsat Remote Sensing Data from Earth Explorer

### Step 1: Define Your Study Area (AOI)

When searching for data, the first thing that you need to do is to define your
area of interest (AOI). Your AOI for this week, is defined by the boundary of the Cold Springs fire extent. You could type in the x,y vertices of each corner of the boundary,
but if you have an Earth Explorer account, you can upload a ZIPPED up shapefile that
contains the boundary instead.

<figure>
    <a href="{{ site.url }}/images/earth-analytics/spatial-data/spatial-extent.png">
    <img src="{{ site.url }}/images/earth-analytics/spatial-data/spatial-extent.png" alt="Spatial extent.">
    </a>
    <figcaption>Remember that the spatial extent of a spatial object, is the geographic area that your data cover on the ground. In the case of vector data - this represents
    the minimum and maximum x and y values for each corner boundary of the dataset.
    Source: Colin Williams, NEON.
    </figcaption>
</figure>

Important: Be sure to use a square / rectangular extent polygon. If you
have too many vertices in your extent polygon, the website won't accept it as an
extent file.

To define your AOI in Earth Explorer:

* Zip up extent file that you want to use. Be sure to use a square extent, if you have too many vertices it won't work. Lucky for us there is a zip file already zipped 
up and ready to go in the cold-springs-fire directory!

  `data/cold-springs-fire/vector_layers/fire_boundary_box_shp.zip`

* Next, go to <a href="http://earthexplorer.usgs.gov" target="_blank">the Earth Explorer website</a>. Login. If you don't have a login already, create an account.

Be sure to create an account. You will need it to be able to use your shapefile
extent to search for data. Now, it's time to search for data.

* In the search criteria, click on <kbd>shapefile</kbd> tab. Select the zip file above as the shapefile that represents the SPATIAL EXTENT of our study area - the cold springs fire site.

* At the bottom of the search criteria window, select a range of dates. A month before and after the fire is a nice starting point.

<figure>
    <a href="{{ site.url }}/images/earth-analytics/raster-data/earth-explorer-naip-date-options.png">
    <img src="{{ site.url }}/images/earth-analytics/raster-data/earth-explorer-naip-date-options.png" alt="Earth explorer search criteria.">
    </a>
    <figcaption> Notice the shapefile tab mid way down in this image. This is the tab
    you need to click on to upload a zipped up shapefile extent to Earth Explorer.
    At the bottom of the image, notice there is a date range tab. This is where
    you set the data collection date range that you require. In our case you want all images collected around the Cold springs fire which occurred July 10-14 2016.
    </figcaption>
</figure>


### Step 2: Define the Data That You Want to Download


* Next click on the <kbd>Data sets</kbd> tab. Notice that there are a lot of different data available from Earth Explorer! You want to find NAIP data which is under the Aerial Imagery category.  Select:

  * NAIP GEOTIFF 

<figure>
    <a href="{{ site.url }}/images/earth-analytics/raster-data/get-naip-data-earth-explorer.png">
    <img src="{{ site.url }}/images/earth-analytics/raster-data/get-naip-data-earth-explorer.png" alt="Earth explorer search criteria.">
    </a>
    <figcaption>NAIP data are located in the Aerial Imagery section of Earth Explorer.
    </figcaption>
</figure>


### Step 3: Click on Results


* Finally click on the Results tab. Here you see all of the NAIP tiles that are available to "order" from the website that cover your study area.

* Notice that you can click on the icons below the scene to see the scene itself rendered on the map and to see the footprint (or extent) of the scene relative to our study area.

* Pick a scene that is:

  * closest to the year following the pre-fire date (summer / fall 2017).
  
  HINT: view the footprint of the data in Earth Explorer to pick the tile the best covers your study area. There are a few tiles that cover some of the study area but only one that covers the entire area! 

### Step 4: Download Your Data


* Click the <i class="fa fa-download" aria-hidden="true"></i> download icon (3rd from the right) to download the image
* Place the image in your earth-analytics directory to use for your homework.

<!--
<i class="fa fa-star" aria-hidden="true"></i>**IMPORTANT:** It will take a few days for the link that you can use to download your data to be emailed to your account. Order now!
{: .notice--success}
-->

## Explore Newly Downloaded Data

Once you have downloaded the data, explore it a bit. You will likely notice that the spatial extent of the newly downloaded data is DIFFERENT from the data in the class cold-springs-fire directory. Be sure to account for that when you are doing your homework for this week!


