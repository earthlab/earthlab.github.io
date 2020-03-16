---
layout: single
title: "Introduction to the HDF4 Data Format"
excerpt: "MODIS is remote sensing data that is stored in the HDF4 file format. Learn how to view and explore HDF4 files (and their metadata) using the free HDF viewer provided by the HDF group."
authors: ['Leah Wasser', 'Jenny Palomino']
dateCreated: 2020-03-01
modified: 2020-03-16
category: [courses]
class-lesson: ['hdf4']
permalink: /courses/use-data-open-source-python/hierarchical-data-formats-hdf/intro-to-hdf4/
nav-title: 'Intro to HDF4'
module-title: 'Introduction to the HDF4 File Format in Python'
module-description: 'MODIS is remote sensing data that is stored in the HDF4 file format. Learn how to open and manipulate data stored in the HDF4 file format using open source Python.'
module-nav-title: 'HDF4'
module-type: 'class'
chapter: 12
class-order: 1
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

## <i class="fa fa-ship" aria-hidden="true"></i> Chapter 12 - MODIS HDF4 Remote Sensing Data in Python

In this chapter, you will learn how to work with MODIS remote sensing data stored in the HDF4 file format using open source **Python**.


## <i class="fa fa-graduation-cap" aria-hidden="true"></i> Learning Objectives

After completing this chapter, you will be able to:

* Explain how data are structured and stored in HDF4 files.
* Explore HDF4 files (and their metadata) in a free HDF Viewer.
* Open and process HDF4 files in **Python**.


## <i class="fa fa-check-square-o fa-2" aria-hidden="true"></i> What You Need

You will need a computer with internet access to complete this lesson and the Cold Springs MODIS data, which you can download using **earthpy**:

`et.data.get_data("cold-springs-modis-h5")`

You will also need to download a <a href="https://www.hdfgroup.org/downloads/hdfview/" target="_blank">free HDF viewer</a> from the HDF Group website. Additional download and installation information are provided on this page. 

Be sure to download the data above, so that you can access the data in the free HDF viewer. 

</div>

## What are HDF4 Files?

On the landing page of this section, you learned about the general characteristics of Hierarchical Data Format (HDF) files and that there are many types of HDF files including HDF4, HDF5, and NetCDF. 

HDF files are open source file formats that support large, complex, heterogeneous data, using a "file directory" like structure. HDF formats also allow for embedding of metadata, making them *self-describing*. 

HDF4 is an older hierarchical data format as compared to HDF5, which is the latest version promoted by the HDF Group, the publisher of the libraries and standards for these formats. 

While the transition to HDF5 has occurred for many remote sensing products, HDF4 is still the primary data format that is adapted for MODIS data products published by NASA.

<i class="fa fa-star"></i> **Data Tip:** HDF4 is an older hierarchical data format. Most MODIS data are still delivered in an adapted version of this format. HDF5 (and NetCDF which is similar to the HDF5 format with different associated standards) are the preferred data structures to use for new data products.
{: .notice--success}

For more information on HDF4, review the <a href="https://portal.hdfgroup.org/display/HDF4/HDF4" target="_blank">HDF4 User Guide</a> and learn more about the <a href="https://support.hdfgroup.org/products/hdf5_tools/h4toh5/h4vsh5.html" target="_blank">differences between the HDF4 and HDF5 formats</a>. 


## HDF4 EOS Format for MODIS

Both the HDF4 and HDF5 formats have been adapted by NASA to publish data from Earth Observing System (EOS) missions. These adapted formats, referred to as <a href="http://www.hdfeos.org/" target="_blank">HDF-EOS</a>, contain additional geolocated data types (point, grid, swath) that can be used to store spatial information that are not supported within the original HDF structure.  

HDF4-EOS, the format adapted from HDF4, is the currently used format for MODIS data products. You can review the <a href="https://observer.gsfc.nasa.gov/ftp/edhs/hdfeos/latest_release/HDF-EOS_UG.pdf" target="_blank">HDF4-EOS User Guide (section 3.1)</a> to learn more about how the HDF4 format has been adapted to support these additional spatial data types. 

HDF4-EOS files are composed of a directory containing data objects (what we might think of as individual files in a computer directory). Each data object is listed as an individual entry in the directory, which allows the data object to be linked with related metadata. 

Related data objects can be grouped into datasets consisting of multiple data objects (what we might think of subdirectories to organize files within a computer directory).

<figure>
 <a href="{{ site.url }}/images/earth-analytics/hierarchical-data-formats/hdf4-modis-data-object.png">
 <img src="{{ site.url }}/images/earth-analytics/hierarchical-data-formats/hdf4-modis-data-object.png" alt = "An example of the MODIS HDF4 file structure containing data objects for each surface reflectance band."></a>
 <figcaption> The MODIS HDF4 file structure contains data objects for each surface reflectance band such as band 1. In this example, the surface reflectance bands are grouped into the dataset called MODIS_Grid_500m_2D, which contains data objects that have a spatial resolution of 500 meters. 
 </figcaption>
</figure>


## Explore HDF4 Files Using HDF Viewer 

To familiarize yourself with the HDF4 structure, and explore a particular file's data objects, you can use the free HDF Viewer published by the HDF group. 

The sections below walk you through downloading and installing the tool as well as exploring an HF4-EOS file included in the dataset that you downloaded at the top of this page (see: section on What You Need).

### Download and Install HDF Viewer

In order to download the <a href="https://www.hdfgroup.org/downloads/hdfview/" target="_blank">free HDF viewer</a> from the HDF Group website, you will need to first create a free account.

You can create a free account by clicking on the "Create Free Account" button on the top-right corner of the download page.  

During the process to create a free account, you will be asked to confirm your email address by entering a code that is emailed to the address that you provided. 

Once you have finished creating an account, you can select the appropriate installer for your operating system from the download page.

<i class="fa fa-exclamation-circle" aria-hidden="true"></i> **Windows Users:** you will need to select the appropriate installer based on your version of Windows. For example,  `HDFView-3.1.0-win10vs14_64.zip` is the appropriate installer for Windows version 10.0.14. After downloading the .zip file, you can extract the file and double-click on the .msi file to run the installation. 
{: .notice--success}


### Open HDF4 Files in HDF Viewer

Once installed, open the `HDFView` program on your computer. In the menu bar, click the first button `Open` to open a file. 

<figure>
 <a href="{{ site.url }}/images/earth-analytics/hierarchical-data-formats/hdf4-hdf-viewer-open-file.png">
 <img src="{{ site.url }}/images/earth-analytics/hierarchical-data-formats/hdf4-hdf-viewer-open-file.png" alt = "Location of the open file option in the HDF View interface."></a>
 <figcaption> Click on the Open button to open a new file in the HDF View interface. 
 </figcaption>
</figure>

Navigate to directory for the data download (see: section on What You Need). 





### Explore HDF4 Data Objects in HDF Viewer


#### View Surface Reflectance Bands



#### View Metadata for Surface Reflectance Bands






To explore additional functionality in the HDF viewer such as converting and exporting files, review the <a href="https://portal.hdfgroup.org/display/HDFVIEW/HDFView+3.x+User%27s+Guide" target="_blank">HDF Viewer User Guide</a>.
