---
layout: single
title: "Get Landsat Remote Sensing Data From the Earth Explorer Website"
excerpt: "In this lesson you will review how to find and download Landsat imagery from the USGS Earth Explorere website."
authors: ['Leah Wasser']
modified: '2018-01-10'
category: [courses]
class-lesson: ['spectral-data-fire-2-r']
permalink: /courses/earth-analytics/multispectral-remote-sensing-modis/get-data-earth-explorer/
nav-title: 'Get Data - Earth Explorer'
week: 8
course: "earth-analytics"
sidebar:
  nav:
author_profile: false
comments: true
order: 2
topics:
  remote-sensing: ['landsat']
  earth-science: ['fire']
  reproducible-science-and-programming:
  spatial-data-and-gis: ['raster-data']
  find-and-manage-data: ['find-data']
lang-lib:
  r: []
redirect_from:
  - "/courses/earth-analytics/week-7/get-data-earth-explorer/"
---


{% include toc title="In This Lesson" icon="file-text" %}

<div class='notice--success' markdown="1">

## <i class="fa fa-graduation-cap" aria-hidden="true"></i> Learning Objectives

After completing this tutorial, you will be able to:

* Find and download data from the USGS Earth Explorer Website.
* Filter data by cloud cover to find datasets with the least amount of clouds for a study area.

## <i class="fa fa-check-square-o fa-2" aria-hidden="true"></i> What You Need

You will need a computer with internet access to complete this lesson and the
data for week 7 - 9 of the course.

{% include /data_subsets/course_earth_analytics/_data-week6-7.md %}

</div>

In class this week, you will review how to grab data from the Earth Explorer website.
The Earth Explorer website is a data portal run by the USGS. Here you can find
many different types of remote sensing and other data for both the US and in
some cases, the globe.


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
    <a href="{{ site.url }}/images/courses/earth-analytics/spatial-data/spatial-extent.png">
    <img src="{{ site.url }}/images/courses/earth-analytics/spatial-data/spatial-extent.png" alt="Spatial extent.">
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
up and ready to go in your week 6 data!
  `data/week-07/vector_layers/fire_boundary_box_shp.zip`
* Next, go to <a href="http://earthexplorer.usgs.gov" target="_blank">the Earth Explorer website</a>. Login. If you don't have a login already, create an account.

Be sure to create an account. You will need it to be able to use your shapefile
extent to search for data. Now, it's time to search for data.

* In the search criteria, click on <kbd>shapefile</kbd> tab. Select the zip file above as the shapefile that represents the SPATIAL EXTENT of your study area - the Cold Springs fire site.
* At the bottom of the search criteria window, select a range of dates. A month before and after the fire is a nice starting point.

<figure>
    <a href="{{ site.url }}/images/courses/earth-analytics/week-7/ee-search-criteria.png">
    <img src="{{ site.url }}/images/courses/earth-analytics/week-7/ee-search-criteria.png" alt="Earth explorer search criteria.">
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
    <a href="{{ site.url }}/images/courses/earth-analytics/week-7/ee-select-landsat8.png">
    <img src="{{ site.url }}/images/courses/earth-analytics/week-7/ee-select-landsat8.png" alt="Earth explorer search criteria.">
    </a>
    <figcaption>The Landsat 8 data are located in the Pre-Collection drop down.
    Be sure to select Land Surface Reflectance.
    </figcaption>
</figure>


### Step 3: Define Selection Criteria

* Next select the <kbd>Additional Criteria</kbd> tab. Here is where you can limit results by % cloud cover. Start with **Less than 20%** cloud cover and see what you get as data results.


<figure>
    <a href="{{ site.url }}/images/courses/earth-analytics/week-7/ee-cloud-cover.png">
    <img src="{{ site.url }}/images/courses/earth-analytics/week-7/ee-cloud-cover.png" alt="Earth explorer search criteria.">
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

In this case, you want to download a scene very close to Julian day 189. An
example of what the data look like is below. Notice that the spatial extent of
the data that you download from Earth Explorer is much broader than the
data that you worked with for your homework last week. The extents are different
because your instructor cropped the class data to make is easier to work with!



## Import New Scene

First, let's import your new data and create a raster stack. The code is hidden
because you already know how to do this!

<img src="{{ site.url }}/images/rfigs/courses/earth-analytics/08-multispectral-remote-sensing-fire/in-class/2017-03-01-fire02-get-landsat-data-earth-explorer/import-landsat-1.png" title="landsat new image" alt="landsat new image" width="90%" />

Next, plot the fire boundary extent on top of the newly downloaded Landsat 8 image.




<img src="{{ site.url }}/images/rfigs/courses/earth-analytics/08-multispectral-remote-sensing-fire/in-class/2017-03-01-fire02-get-landsat-data-earth-explorer/plot-extent-1.png" title="rgb with the extent overlayed" alt="rgb with the extent overlayed" width="90%" />

If you look closely at the image above, you'll see the tiny yellow boundary
that represents the Cold Springs fire boundary. This
landsat scene is MUCH larger than your Cold Springs Fire study area. You have 2 options:

1. **Crop the data:** this will make it easier to work with as it will be smaller. A good move.
2. **Plot only the study area extent:** this is ok if you just want to plot your data and don't need to do any additional processing on it.

Below i've plotted the cloud mask for the data that I downloaded. It looks like
the data in your study area are cloud free. How do I know that?

<img src="{{ site.url }}/images/rfigs/courses/earth-analytics/08-multispectral-remote-sensing-fire/in-class/2017-03-01-fire02-get-landsat-data-earth-explorer/import-cloud-mask-1.png" title="cloud mask cropped layer" alt="cloud mask cropped layer" width="90%" />

All of the pixels within your study area are cloud free. This means you have
downloaded the right scene. This also means that you don't have to worry about
applying a cloud mask to the data.


```r
# turn axes to white
par(col.axis = "white", col.lab = "white", tck = 0)
# plot RGB
plotRGB(all_landsat_bands_173_st,
        r = 4, g = 3, b = 2,
        stretch = "lin",
        main = "Final landsat scene with the fire extent overlayed",
        axes = TRUE)
box(col = "white")
plot(fire_boundary_utm,
     add = TRUE,
     border = "yellow")
```

<img src="{{ site.url }}/images/rfigs/courses/earth-analytics/08-multispectral-remote-sensing-fire/in-class/2017-03-01-fire02-get-landsat-data-earth-explorer/plot-with-extent-1.png" title="plot w extent defined" alt="plot w extent defined" width="90%" />

Now that you have some cloud free data covering the study area, you can proceed to calculate NBR on the pre-fire data.
