---
layout: single
title: "Introduction to the CMIP and MACA v2 Climate data and the NetCDF 4 Hierarhical Data Format"
excerpt: "In this lesson you will learn the basics of what CMIP and MACA v 2 data are. You will also learn about that netcdf 4 data format which is commonly used to store climate data."
authors: ['Leah Wasser']
dateCreated: 2020-10-23
modified: 2020-10-30
category: [courses]
class-lesson: ['netcdf4']
permalink: /courses/use-data-open-source-python/hierarchical-data-formats-hdf/intro-to-climate-data/
nav-title: 'Intro to Climate Data'
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

* 

## <i class="fa fa-check-square-o fa-2" aria-hidden="true"></i> What You Need

OPTIONAL: If you want to explore the netcdf 4 files in a graphics based tool, you can download th <a href="https://www.hdfgroup.org/downloads/hdfview/" target="_blank">free HDF viewer</a> from the HDF Group website. 

</div>

## What is netCDF data?

NetCDF (network Common Data Form) is a hierarchical data format similar to hdf4 and hdf5. It is what’s known as a “self-describing” data structure which means that metadata (descriptions of the data) are included in the file itself and can be parsed programmatically (accessed using code) to build automated and reproducible workflows. The NetCDF format can store data with multiple dimensions. It can also store different types of data including arrays which can store geospatial imagery, rasters, terrain data, climate data, text which supports metadata and more making it highly flexible. NetCDF was developed and is supported by UCAR who maintains standards and software that support the use of this format. 

### NetCDF 4 for Climate Data
The hierarchical and flexible nature of netcdf files supports storing data in many different ways. This flexibility is nice, however, similar to challenges faced with hdf5 data formats, it can be challenging when communities make different decisions about how and where they store data in a netcdf file. The netCDF 4 data model is a common standard used broadly by the climate science community to store climate data. Climate data are:
often delivered in a time series  format (months and years worth of historic or future projected data)
spatial in nature covering regions such as the United States or even the world
Driven by models which require documentation making the self describing aspect of netCDF files useful.

The netCDF 4 model supports data stored in an array format. Arrays are used to store raster spatial data (terrain layers, gridded temperature data, etc) and also point based time series data (for example temperature for a single location over 10 years). Climate data typically have three dimensions:
x and y representing latitude / longitude location for a  point or a grid cell location on the earth's surface
Time

The x/y locations often store a data value such as temperature, humidity, precipitation or wind direction. 

