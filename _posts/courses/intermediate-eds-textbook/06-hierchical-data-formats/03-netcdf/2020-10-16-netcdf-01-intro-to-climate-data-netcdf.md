---
layout: single
title: "Introduction to the NetCDF4 Hierarchical Data Format"
excerpt: "In this lesson you will learn about that netcdf 4 data format which is a format, commonly used to store climate data. In later lessons you will learn how to open climate data using open source Python tools."
authors: ['Leah Wasser']
dateCreated: 2020-10-23
modified: 2020-11-12
category: [courses]
class-lesson: ['netcdf4']
permalink: /courses/use-data-open-source-python/hierarchical-data-formats-hdf/intro-to-climate-data/
nav-title: 'Intro to netcdf4'
module-title: 'Introduction to the netcdf 4 File Format in Python'
module-description: 'Learn how to work with MACA v2 climate data stored in netcdf 4 format using open source Python and the xarray package.'
module-nav-title: 'NETCDF'
module-type: 'class'
chapter: 13
class-order: 2
week: 6
course: "intermediate-earth-data-science-textbook"
sidebar:
  nav:
author_profile: false
comments: true
order: 1
topics:
  remote-sensing: ['modis']
  reproducible-science-and-programming:
  spatial-data-and-gis: ['raster-data']
---

{% include toc title="In This Chapter" icon="file-text" %}

<div class='notice--success' markdown="1">

## <i class="fa fa-ship" aria-hidden="true"></i> Chapter 13 - NETCDF 4 Climate Data in Open Source Python 

In this chapter, you will learn how to work with Climate Data Sets (MACA v2 for the United states) stored in netcdf 4 format using open source **Python**.


## <i class="fa fa-graduation-cap" aria-hidden="true"></i> Learning Objectives

After completing this chapter, you will be able to:

* Describe the netcdf data format as it is used to store climate data
* Define the characteristics of MACAv2 and CMIP5 data.
* Explain what downscaling is.


## <i class="fa fa-check-square-o fa-2" aria-hidden="true"></i> What You Need

OPTIONAL: If you want to explore the netcdf 4 files in a graphics based tool, you can download th <a href="https://www.hdfgroup.org/downloads/hdfview/" target="_blank">free HDF viewer</a> from the HDF Group website. 

</div>

## What is netCDF Data?

NetCDF (network Common Data Form) is a hierarchical data format similar to <a href="{{ site.url }}/courses/use-data-open-source-python/hierarchical-data-formats-hdf/intro-to-hdf4/">hdf4</a> and hdf5. It is what is known as a “self-describing” data structure which means that metadata, or descriptions of the data, are included in the file itself and can be parsed programmatically, meaning that they can be accessed using code to build automated and reproducible workflows. 

The NetCDF format can store data with multiple dimensions. It can also store different types of data through arrays that can contain geospatial imagery, rasters, terrain data, climate data, and text. These arrays support metadata, making the netCDF format highly flexible. NetCDF was developed and is supported by UCAR who maintains standards and software that support the use of the format.


### NetCDF4 Format for Climate Data
The hierarchical and flexible nature of netcdf files supports storing data in many different ways. This flexibility is nice, however, similar to hdf5 data formats, it can be challenging when communities make different decisions about how and where they store data in a netCDF file. The netCDF4 data standard is used broadly by the climate science community to store climate data. Climate data are:

* often delivered in a time series  format (months and years of historic or future projected data).
* spatial in nature, covering regions such as the United States or even the world.
* driven by models which require documentation making the self describing aspect of netCDF files useful.

The netCDF4 format supports data stored in an array format. Arrays are used to store raster spatial data (terrain layers, gridded temperature data, etc) and also point based time series data (for example temperature for a single location over 10 years). Climate data typically have three dimensions---x and y values representing latitude and longitude location for a  point or a grid cell location on the earth's surface and time.

The x/y locations often store a data value such as temperature, humidity, precipitation or wind direction. 


### NetCDF is Self Describing

One of the biggest benefits of working with a data type like netCDF is that it is self-describing. This means that all of the metadata needed to work with the data is often contained within the netCDF file (the `.nc` file) itself.

<figure>

<img src = "{{ site.url }}/images/earth-analytics/hierarchical-data-formats/hdf5-example-data-structure.jpg" alt = "netcdf is a hierarchical data format. It is self describing meaning that the metadata for the file is contained within the file itself. Self-contained metadata makes it easier to create a fully reproducible workflow given you can pull metadata elements such as coordinate reference systems and units directly from the file itself.">
<figcaption>Netcdf is a hierarchical data format. It is self describing meaning that the metadata for the file is contained within the file itself. Self-contained metadata makes it easier to create a fully reproducible workflow given you can pull metadata elements such as coordinate reference systems and units directly from the file itself. </figcaption>

</figure>



## Tools to Work With NetCDF Data

Python also has several open source  tools that are useful for processing netcdf files including:

* `Xarray`: one of the most common tools used to process netcdf data. Xarray knows how to open netcdf 4 files automatically giving you access to the data and metadata in spatial formats.
* `rioxarray`: a wrapper that adds spatial functionality such as reproject and export to geotiff to xarray objects.
* `Regionmask`: regionmask builds on top of xarray to support spatial subsetting and AOIs for xarray objects. 


In the next lessons you will learn more about climate data and how to open climate data stored in **netCDF** format using open source Python tools. Read the section below to learn more about the climate data itself. 

