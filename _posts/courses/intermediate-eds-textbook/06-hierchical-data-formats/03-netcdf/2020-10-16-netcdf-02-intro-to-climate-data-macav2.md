---
layout: single
title: "Introduction to the CMIP and MACA v2 Climate Data"
excerpt: "In this lesson you will learn the basics of what CMIP5 and MACA v 2 data are and how global climate data are downscaled to higher resolutions to support regional analysis."
authors: ['Leah Wasser']
dateCreated: 2020-10-23
modified: 2021-11-19
category: [courses]
class-lesson: ['netcdf4']
permalink: /courses/use-data-open-source-python/hierarchical-data-formats-hdf/intro-to-MACAv2-cmip5-data/
nav-title: 'Intro to Climate Data'
week: 6
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

## <i class="fa fa-ship" aria-hidden="true"></i> Introduction to Climate Data in Open Source Python 

In this lesson, you will learn more about the MACA v2 climate data which is a downsampled data set 
created from the global CMIP5 climate data. 

## <i class="fa fa-graduation-cap" aria-hidden="true"></i> Learning Objectives

After completing this chapter, you will be able to:

* Define the characteristics of MACAv2 and CMIP5 data.
* Explain what downscaling is.

</div>

## About Climate Data: What is CMIP5 data?
The Climate Model Intercomparison Project, better known as CMIP, is a framework for analyzing and comparing Global Climate Models (GCMs) to better understand climate change occuring now and into the future. GCMs are a type of climate models that simulate the global and regional scale climate processes that include the general circulation of atmosphere and oceans and its interaction with the land, radiative fluxes, cloud processes, and land surface processes that include hydrology and biological feedbacks. CMIP5, phase 5 of the project, is the current and most extensive CMIP, drawing data from over 40 GCMs from countries around the world. 

## What is MACA v2 Metdata?
The CMIP models are global and thus cover the entire world. Due to this global coverage they are delivered at a coarse resolution ranging from 100-300km. Multivariate Adaptive Constructed Analogs (MACA) is a statistical method for downscaling GCM data from its coarse format to a higher spatial resolution for the Continental United States (CONUS). The MACA downscaling approach takes 20 GCMs from CMIP5 and downscales them to 4km or 6km resolution data. The resolution of MACA v2 Metdata is 4km. 

The data variables include temperature, precipitation, humidity, downward shortwave solar radiation, and eastward and northward wind. Data are also provided for historical time periods from 1950-2005 and future scenarios spanning from 2006-2100.

## About Downscaling Data - Creating Higher Resolution Climate Data For the United States Using Lower Resolution Global Data

Downscaling refers to the process of taking climate projections data produced at a large scale, with bigger pixels covering larger areas (100-300 km), and increasing its spatial resolution so that the pixels are smaller and cover smaller areas (1-50 km). Downscaling processes also generally tend to remove biases (often referred to as bias correction) between the simulated GCM climatology and the real world climatology. Downscaling allows us to have future climate projections available at a much finer spatial  scale and more representative of a region’s climate and therefore more applicable for regional-scale applications. For example, it is more appropriate for discerning projected hydrological changes at a watershed scale  as opposed to taking those projections directly from a GCM output. Overall, downscaling makes the data more useful on a local and regional level, which is important because adaptation strategies are generally identified and implemented on regional and local scales. This allows resource managers to identify vulnerable areas and prioritize adaptation efforts there. 

<figure>

<img src = "{{ site.url }}/images/earth-analytics/climate-data/downscale-climate-data-met.jpg" alt = "An example of the downscaling process, converting coarse data to a higher resolution. Source: Databasin.org.">
<figcaption>An example of the downscaling process, converting coarse data to a higher resolution. Source: Databasin.org. </figcaption>

</figure>

Downscaling however comes with its challenges. There are many different processing and statistical approaches that can be used to downscale GCM data, each of which produce different levels and types of uncertainty. The MACA downscaling method uses a constructed analog approach that is a more advanced form of statistical downscaling and has been getting greater acceptability and usability in the user community. For example, the recent National Climate Assessment (NCA4) considered Localized Constructed Analogs (LOCA) downscaled data, while a 2020 Resources Planning Act (RPA) Assessment by the US Forest Service considered MACA v2 Metdata. The constructed analog approach also provides climate projections at daily timescales which is usually not available for most other downscaled datasets. Additionally, MACA v2 Metdata also applies  a  multivariate approach by combining temperature and humidity variables. It has now been extensively vetted by the research community, and has been found suitable for a wide range of applications.


## What Formats Are MACA v2 Data In?

* Tabular (txt and csv) - Learn how to work with txt and csv data <a href="https://www.earthdatascience.org/courses/intro-to-earth-data-science/file-formats/use-text-files/use-tabular-data/">in this lesson</a>.
* GeoTIFF - Learn how to work with geotiff data  <a href="https://www.earthdatascience.org/courses/use-data-open-source-python/intro-raster-data-python/fundamentals-raster-data/intro-to-the-geotiff-file-format/">in this lesson</a>.
* netCDF - Get more detail on the netCDF documentation from UCAR <a href="https://www.unidata.ucar.edu/software/netcdf/docs/netcdf_introduction.html" target="_blank">here</a>.


## How do you get MACA v2 data?

There are several different options for downloading MACA v2 data including:

* <a href="https://climate.northwestknowledge.net/MACA/data_portal.php" target="_blank">Through the MACA v2 Data portal </a>
* <a href="http://thredds.northwestknowledge.net:8080/thredds/reacch_climate_CMIP5_aggregated_macav2_monthly_catalog.html" target="_blank">Through the MACA v2 Catalog </a>
* <a href="https://cida.usgs.gov/gdp/client/#!catalog/gdp/dataset/5752f2d9e4b053f0edd15628" target="_blank">Through the USGS GeoData Portal </a>
* <a href="https://github.com/earthlab/cft" target="_blank">Using the `R` Climate Futures Toolbox (CFT)</a>, an R tool created by CU Boulder Earth Lab
* <a href="https://climatetoolbox.org/tool/Climate-Mapper">The Climate Mapper Toolbox</a>, a tool from the <a href="https://climatetoolbox.org/" target="_blank">Climate Toolbox</a>

<div class="notice--warning" markdown="1">
## The Climate Toolbox
The <a href="https://climatetoolbox.org/tool/climate-mapper"  target="_blank">Climate Toolbox </a>is a collection of approximately 20 web-based tools that allow the user to visualize past and future projected climate, agriculture, wildfire, and hydrological data for the United States. It is maintained by the University of California, Merced in collaboration with government organizations including the USDA, NOAA, and the USGS.

### The Climate Toolbox Climate Mapper Tool
The Climate Mapper Tool allows you to map climate data extracted from MACA v2 Metdata, display current conditions, forecasts, and future projections for the U.S. The data includes variables related to climate, agriculture, wildfire, and hydrology. The tool aims to help scientists and decision-makers visualize climate information in a straightforward and easy-to-use way. 

</div>

<div class="notice--info" markdown="1">

## Additional Resources  

* Learn more about <a href="http://www.climatologylab.org/maca.html" target="_blank">MACA v2 data</a> from its creators at the University of California Merced.
* See <a href="https://www.earthdatascience.org/cft/articles/cft-intro.html">example applications of MACA v2 data</a> .
* Explore the <a href="https://climatetoolbox.org/" target=”_blank”>Climate Toolbox</a>
* Use the <a href="https://climatetoolbox.org/tool/Climate-Mapper" target=”_blank”>Climate Mapper Tool</a>

</div>


