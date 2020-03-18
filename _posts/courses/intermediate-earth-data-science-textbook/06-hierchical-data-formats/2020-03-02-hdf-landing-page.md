---
layout: single
category: courses
title: "Introduction to Hierarchical Data Formats in Python"
permalink: /courses/use-data-open-source-python/hierarchical-data-formats-hdf/
week-landing: 6
modified: 2020-03-18
week: 6
sidebar:
  nav:
comments: false
author_profile: false
course: "intermediate-earth-data-science-textbook"
module-type: 'session'
---

{% include toc title="Section Six" icon="file-text" %}

<div class="notice--info" markdown="1">

## <i class="fa fa-ship" aria-hidden="true"></i> Section Six - Hierarchical Data Formats in Python

In section six of this textbook, you will learn about Hierarchical Data Formats (HDF) and how they can be used to store complex data (and related metadata) such as satellite imagery. You will learn how to open and process HDF files in **Python** to complete remote sensing analyses.


## <i class="fa fa-graduation-cap" aria-hidden="true"></i> Learning Objectives

After completing this section of the textbook, you will be able to:

* Explain what the Hierarchical Data Formats (HDF) are.
* List the different types of HDF files and the benefits of using these formats for storing data.
* List the types of data that can be stored in HDF files.
* Explain how data are structured and stored in HDF files.
* Open and process HDF files in **Python**.

</div>

## About Hierarchical Data Formats

Hierarchical Data Formats (HDF) are open source file formats that support large, complex, heterogeneous data.

HDF files use a "file directory" like structure that allows you to organize data within the file in many different structured ways, as you might do with files on your computer. HDF files also allow for embedding of metadata making them *self-describing*.


## Types of HDF Files

There are many different types of HDFs. For Earth Data Science, the most widely used HDFs are:
* HDF4: the format adapted by the MODIS data products.
* HDF5: the format used for many different products provided by NASA.
* NetCDF: a format frequently used to store climate data.

In the first chapter of this section, you will learn more about HDF4 files and process HDF4 files to complete remote sensing analyses with MODIS data. 


## Hierarchical Structure - A File Directory Within a File

HDF files can be thought of as a file system contained and described within one single file. 

Think about the files and folders stored on your computer. You might have a data directory with some temperature data for multiple field sites. This temperature data is collected every minute and summarized on an hourly, daily and weekly basis. 

Within **ONE** HDF file, you can store a similar set of data organized in the same way that you might organize files and folders on your computer. 

## HDFs Are Self Describing Files

HDF formats are self describing. This means that each file, group, or dataset can have associated metadata that describes exactly what the data are. 

Following the example above, you can embed information about each site to the file, such as:

* The full name and X,Y location of the site.
* Description of the site.
* Any documentation of interest.

Similarly, you might add information about how the data in the dataset were collected, such as descriptions of the sensor used to collect the temperature data. You can also attach information to each dataset within the site group about how the averaging was performed and over what time period data are available. 

One key benefit of having metadata that are attached to each file, group or dataset is that this facilitates automation without the need for a separate (and additional) metadata document. 

Using a programming language like **Python**, you can grab the information needed to process the dataset directly from the metadata that are associated with the dataset.


<figure>
 <a href="{{ site.url }}/images/earth-analytics/hierarchical-data-formats/hdf5-example-data-structure-with-metadata.jpg">
 <img src="{{ site.url }}/images/earth-analytics/hierarchical-data-formats/hdf5-example-data-structure-with-metadata.jpg" alt = "An example HDF5 file structure containing metadata for the file, groups, and datasets."></a>
 <figcaption> HDF files are self describing - this means that all elements (the file itself, groups and datasets) can have associated metadata that describes the information contained within the element. Source: NEON
 </figcaption>
</figure>



## HDFs Are Compressed and Facilitate Efficient Subsetting

HDF files are compressed formats. The size of all data contained within the HDF file is optimized, which makes the overall file size smaller. 

Even when compressed, however, HDF files often contain big data and can thus still be quite large. 

A powerful attribute of HDF is data slicing, by which a particular subset of a dataset can be extracted for processing. This means that the entire dataset does not have to be read into memory (RAM); which is very helpful in allowing us to more efficiently work with very large (gigabytes or more) datasets! 


## HDFs Can Store Heterogeneous Data Storage

HDF files can store many different types of data within in the same file. For example, one group may contain a set of datasets to contain integer (numeric) and text (string) data. 

One dataset can also contain heterogeneous data types (e.g., both text and numeric data in the same dataset). This means that HDF files can store any of the following (and more) in one file:

* Temperature, precipitation and PAR (photosynthetic active radiation) data for a site or for many sites 
* A set of images that cover one or more areas (each image can have specific spatial information associated with it - all in the same file)
* A multi or hyperspectral spatial dataset that contains thousands of bands.
* Field data for several sites characterizing insects, mammals, vegetation and climate.
* A set of images that cover one or more areas (each image can have unique spatial information associated with it)
* A multi or hyperspectral spatial dataset that contains thousands of bands
* Field data for several sites characterizing insects, mammals, vegetation and climate
* And much more!


## HDFs Are Open Data Formats

HDF formats are open and free to use. The supporting libraries and a free HDF viewer can be downloaded from the <a href="https://www.hdfgroup.org/downloads/" target="_blank">HDF Group </a> website.

As such, HDF files are widely supported in a host of programs, including open source programming languages like **Python**, and commercial programming tools like **Matlab** and **IDL**. Spatial data that are stored in HDF formats can also be used in GIS and imaging programs including QGIS, ArcGIS, and ENVI.


## Benefits of HDF Files 

* **Self-Describing** The datasets within HDF files are self describing. This allows you to efficiently extract metadata without needing an additional metadata document.
* **Support Heterogeneous Data**: Different types of datasets can be contained within one HDF file. 
* **Support Large, Complex Data**: HDF files are compressed formats that are designed to support large, heterogeneous, and complex datasets. 
* **Support Data Slicing:** Data slicing (or extracting portions of the dataset as needed for analysis) means that large files do not need to be completely read into the computer memory or RAM.
* **Open Format -  wide support in the many tools**: Because HDF formats are open, they are supported by a host of programming languages and tools, including open source languages like ** Python** and open GIS tools like QGIS.

{% include textbook-section-toc.html %}
