---
layout: single
title: "Get landsat data - Earth Explorer"
excerpt: "In this lesson we will review how to find and download Landsat imagery from the USGS Earth Explorere website."
authors: ['Leah Wasser']
modified: '2017-03-01'
category: [course-materials]
class-lesson: ['spectral-data-fire-2-r']
permalink: /course-materials/earth-analytics/week-7/get-data-earth-explorer/
nav-title: 'Get data - earth explorer'
week: 7
sidebar:
  nav:
author_profile: false
comments: true
order: 2
---

{% include toc title="In This Lesson" icon="file-text" %}

<div class='notice--success' markdown="1">

## <i class="fa fa-graduation-cap" aria-hidden="true"></i> Learning Objectives

After completing this tutorial, you will be able to:

* Find and download data from the USGS Earth Explorer Website
* Filter data by cloud cover to find datasets with the least amount of clouds for a study area.

## <i class="fa fa-check-square-o fa-2" aria-hidden="true"></i> What you need

You will need a computer with internet access to complete this lesson and the
data for week 6 / 7 of the course.

[<i class="fa fa-download" aria-hidden="true"></i> Download Week 6/7 Data (~500 MB)](https://ndownloader.figshare.com/files/7677208){:data-proofer-ignore='' .btn }
</div>


In class this week, we will review how to grab data from the Earth Explorer website.
The Earth Explorer website is a data portal run by the USGS. Here you can find
many different types of remote sensing and other data for both the US and in
some cases, the globe.

**IMPORTANT:** Be sure to order your data several days ahead of time or else you won't have it
in time to finish this assignment.

## The Steps: Earth Explorer Data Download

### Define study area (AOI)

When searching for data, the first thing we need to do is  to define our area of
interest (AOI). Our AOI is defined by the boundary of the
fire extent. We could type in the x,y vertices of each corner of the boundary,
but if we have an Earth Explorer account,  we can upload a ZIPPED up shapefile that
contains the boundary instead!

<figure>
    <a href="{{ site.url }}/images/course-materials/earth-analytics/week-5/spatial_extent.png">
    <img src="{{ site.url }}/images/course-materials/earth-analytics/week-5/spatial_extent.png" alt="Spatial extent.">
    </a>
    <figcaption>Remember that the spatial extent, is the geographic area that
    our data cover on the ground. In the case of vector data - this represents
    the minimum and maximum x and y values for each corner boundary of the dataset.
    Source: Colin Williams, NEON.
    </figcaption>
</figure>

Important: Be sure to use a square extent. If you
have too many vertices in your extent polygon, the website won't accept it as an
extent file.

To begin:

* Zip up extent file that you want to use. Be sure to use a square extent, if you
have too many vertices it won't work. Lucky for us there is a zip file already zipped
up and ready to go in our week6 data!
  `data/week6/vector_layers/fire_boundary_box_shp.zip`
* Next, go to <a href="http://earthexplorer.usgs.gov" target="_blank">the Earth Explorer website</a>. Login. If you don't have a login already, create an account.

Now, it's time to search for data.

* In the search criteria, click on <kbd>shapefile</kbd> tab. Select the zip file above as the shapefile that represents the SPATIAL EXTENT of our study area - the cold springs fire site.
* At the bottom of the search criteria window, select a range of dates. A month before and after the fire is a nice starting point.

<figure>
    <a href="{{ site.url }}/images/course-materials/earth-analytics/week-7/ee-search-criteria.png">
    <img src="{{ site.url }}/images/course-materials/earth-analytics/week-7/ee-search-criteria.png" alt="Earth explorer search criteria.">
    </a>
    <figcaption> Notice the shapefile tab mid way down in this image. This is the tab
    you need to click on to upload a zipped up shapefile extent to Earth Explorer.
    At the bottom of the image, notice there is a date range tab. This is where
    you set the data collection date range that you require. In our case we want all images collected around the Cold springs fire which occurred July 10-14 2016.
    </figcaption>
</figure>


* Next click on the <kbd>Data sets</kbd> tab. Notice that there are a lot of different data available from Earth Explorer! We are interested in Landsat - specifically Landsat 8.  You can find Landsat in the Landsat archive drop down. Expand that drop down to find:
  * Pre-Collection -> Landsat Surface Reflectance - L8 OLI/TIRS

<figure>
    <a href="{{ site.url }}/images/course-materials/earth-analytics/week-7/ee-select-landsat8.png">
    <img src="{{ site.url }}/images/course-materials/earth-analytics/week-7/ee-select-landsat8.png" alt="Earth explorer search criteria.">
    </a>
    <figcaption>The Landsat 8 data are located in the Pre-Collection drop down.
    Be sure to select Land Surface Reflectance.
    </figcaption>
</figure>

* Next select the <kbd>Additional Criteria</kbd> tab. Here is where you can limit results by % cloud cover. Let's start with **Less than 20%** cloud cover and see what we get as data results.


<figure>
    <a href="{{ site.url }}/images/course-materials/earth-analytics/week-7/ee-cloud-cover.png">
    <img src="{{ site.url }}/images/course-materials/earth-analytics/week-7/ee-cloud-cover.png" alt="Earth explorer search criteria.">
    </a>
    <figcaption>When you click on the additional criteria tab, you can further filter data results. In this case, low cloud cover is a priority for our analysis. We can select
    Less than 20% cloud cover as a starting place to see if we can find a scene with
    little to not cloud cover over our AOI (area of interest).
    </figcaption>
</figure>

* Finally click on the Results tab. Here you see all of the scenes available for "order" from the website that cover our study area.
* Notice that you can click on the icons below the scene to see the scene itself rendered on the map and to see the footprint (or extent) of the scene relative to our study area.
* Pick a scene that is
  * closest to the pre-fire date (July 10 2016) and also that has the least amount of cloud cover close to our study area.


#### Order your data
* Click the <i class="fa fa-shopping-cart" aria-hidden="true"></i>
shopping cart icon to add the data to your cart.
* Click on "item basket" in the upper right hand corner of your browser to see what you have ordered.
* Click on <kbd>Proceed to Checkout</kbd>
* Then finally, click on <kbd>Submit Order </kbd>

<i fa fa-star></i>**IMPORTANT:** It will take a few days for the link that you can use to download your
data to be emailed to your account. Order now!
{: .notice}


In this case, I downloaded a scene very close to Julian day 189.



## Import new scene

First, let's import our new data and create a raster stack. The code is hidden
because you already know how to do this!

<img src="{{ site.url }}/images/rfigs/course-materials/earth-analytics/week-7/2016-12-06-fire02-get-landsat-data-earth-explorer/import-landsat-1.png" title="landsat new image" alt="landsat new image" width="100%" />

Next I plotted the fire boundary extent on top of my landsat image.




<img src="{{ site.url }}/images/rfigs/course-materials/earth-analytics/week-7/2016-12-06-fire02-get-landsat-data-earth-explorer/plot-extent-1.png" title="rgb with the extent overlayed" alt="rgb with the extent overlayed" width="100%" />

It's hard to see but can you see the tiny YELLOW outline of our study area? This
landsat scene is MUCH larger than our study area. We have 2 options

1. **Crop the data:** this will make it easier to work with as it will be smaller. A good move.
2. **Plot only the study area extent:** this is ok if we just want to plot our data and don't need to do any additional processing on it.

Below i've plotted the cloud mask for the data that I downloaded. It looks like
the data in our study area are cloud free. How do I know that?

<img src="{{ site.url }}/images/rfigs/course-materials/earth-analytics/week-7/2016-12-06-fire02-get-landsat-data-earth-explorer/import-cloud-mask-1.png" title="cloud mask cropped layer" alt="cloud mask cropped layer" width="100%" />



```r
barplot(cloud_mask_173_crop,
     main="cloud mask values \n all 0's")
```

<img src="{{ site.url }}/images/rfigs/course-materials/earth-analytics/week-7/2016-12-06-fire02-get-landsat-data-earth-explorer/cloud-mask-barplot-1.png" title="view cloud mask values" alt="view cloud mask values" width="100%" />


Given our data are all 0's we can assume we downloaded the right scene! There
are no clouds in our study area image. This means we don't have to worry about masking.


```r
# turn axes to white
par(col.axis="white", col.lab="white", tck=0)
# plot RGB
plotRGB(all_landsat_bands_173_st,
        r=4, g=3, b=2,
        stretch="lin",
        main="Final landsat scene with the fire extent overlayed",
        axes=T)
box(col="white")
plot(fire_boundary_utm,
     add=T,
     border="yellow")
```

<img src="{{ site.url }}/images/rfigs/course-materials/earth-analytics/week-7/2016-12-06-fire02-get-landsat-data-earth-explorer/plot-with-extent-1.png" title="plot w extent defined" alt="plot w extent defined" width="100%" />

Now we can proceed to calculate NBR on the pre-fire landsat image. How does it
look?
