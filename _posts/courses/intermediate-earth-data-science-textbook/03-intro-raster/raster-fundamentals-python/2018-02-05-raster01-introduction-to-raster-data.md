---
layout: single
title: "What is Raster Data"
excerpt: "Rasters are gridded data composed of pixels that store values. Learn more about the structure of raster data and how to use them to store data, such as imagery or elevation values."
authors: ['Leah Wasser', 'Chris Holdgraf', 'Martha Morrissey']
dateCreated: 2018-02-05
modified: 2020-04-07
category: [courses]
class-lesson: ['intro-raster-python-tb']
permalink: /courses/use-data-open-source-python/intro-raster-data-python/fundamentals-raster-data/
nav-title: 'Intro to Raster Data'
module-title: 'Fundamentals of Raster Data in Python'
module-description: 'The GeoTIFF file format is often used to store raster data. Learn how to to open and explore raster data stored as GeoTIFF files in Python.'
module-nav-title: 'Intro to Raster Data in Python'
module-type: 'class'
week: 3
course: 'intermediate-earth-data-science-textbook'
chapter: 4
estimated-time: "2-3 hours"
difficulty: "intermediate"
sidebar:
  nav:
author_profile: false
comments: false
class-order: 1
order: 1
topics:
  remote-sensing: ['lidar']
  earth-science: ['vegetation']
  spatial-data-and-gis: ['raster-data']
redirect_from:
  - "/courses/earth-analytics-python/lidar-raster-data/lidar-raster-data/"
  - "/courses/use-data-open-source-python/intro-raster-data-python/fundamentals-raster-data/intro-raster-data/"
---

{% include toc title="In This Chapter" icon="file-text" %}

<div class='notice--success' markdown="1">

## <i class="fa fa-ship" aria-hidden="true"></i> Chapter Four - Fundamentals of Raster Data in Python 

In this chapter, you will learn fundamental concepts related to working with raster data in **Python**, including understanding the spatial attributes of raster data, how to open raster data and access its metadata, and how to explore the distribution of values in a raster dataset. 


## <i class="fa fa-graduation-cap" aria-hidden="true"></i> Learning Objectives

After completing this chapter, you will be able to:

* Open raster data using **Python**.
* Be able to list and identify 3 spatial attributes of a raster dataset: extent, crs and resolution.
* Explore and plot the distribution of values within a raster using histograms.
* Access metadata stored within a GeoTIFF raster file via TIF tags in **Python**.

## <i class="fa fa-check-square-o fa-2" aria-hidden="true"></i> What You Need

You will need a computer with internet access to complete this lesson.

{% include/data_subsets/course_earth_analytics/_data-colorado-flood.md %}

</div>

The <a href="{{ site.url }}/courses/use-data-open-source-python/data-stories/lidar-raster-data/lidar-intro/" target="_blank">data story on Lidar data</a> reviews the basic principles behind Lidar raster datasets.

In this chapter, you will learn how to open and plot a lidar raster dataset in **Python**. You will also learn about key attributes of a raster dataset:

1. Spatial resolution
2. Spatial extent and
3. Coordinate reference systems


## What is a Raster?

Raster or “gridded” data are stored as a grid of values which are rendered on a map as pixels. Each pixel value represents an area on the Earth’s surface. A raster file is composed of regular grid of cells, all of which are the same size. 

You've looked at and used rasters before if you've looked at photographs or imagery in a tool like Google Earth. However, the raster files that you will work with are different from photographs in that they are spatially referenced. Each pixel represents an area of land on the ground. That area is defined by the spatial **resolution** of the raster.

<figure>
   <a href="{{ site.url }}/images/earth-analytics/raster-data/raster-concept.png" target="_blank">
   <img src="{{ site.url }}/images/earth-analytics/raster-data/raster-concept.png" alt="Raster data concept diagram."></a>
   <figcaption>A raster is composed of a regular grid of cells. Each cell is the same
   size in the x and y direction. Source: Colin Williams, NEON.
   </figcaption>
</figure>


### Raster Facts

A few notes about rasters:

-  Each cell is called a pixel.
-  And each pixel represents an area on the ground.
-  The resolution of the raster represents the area that each pixel represents on the ground. So, a 1 meter resolution raster, means that each pixel represents a 1 m by 1 m area on the ground.

A raster dataset can have attributes associated with it as well. For instance in a Lidar derived digital elevation model (DEM), each cell represents an elevation value for that location on the earth. In a LIDAR derived intensity image, each cell represents a Lidar intensity value or the amount of light energy returned to and recorded by the sensor.


<figure>
   <a href="{{ site.url }}/images/earth-analytics/raster-data/raster-resolution.png" target="_blank">
   <img src="{{ site.url }}/images/earth-analytics/raster-data/raster-resolution.png" alt="Raster data resolution concept diagram."></a>
   <figcaption>Rasters can be stored at different resolutions. The resolution simply
   represents the size of each pixel cell. Source: Colin Williams, NEON.
   </figcaption>
</figure>


In the next lesson, you will learn how to open a lidar raster dataset in **Python**.

