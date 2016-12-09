---
layout: single
title: "Spatial Intro 01: Intro"
authors: [Leah Wasser]
contributors: [NEON Data Skills]
dateCreated: 2016-09-26
lastModified: 2016-11-29
packagesLibraries: [raster, rgdal, sp]
category: [course-materials]
excerpt: 'This tutorial covers the basics of key data formats that may
contain spatial information including shapefile, GeoTIFF and .csv. It also
provides a brief overview of other formats that you may encounter when working
with spatial data.'
sidebar:
  nav:
nav-title: 'spatial intro'
permalink: course-materials/intro-spatial-data-r
class-lesson: ['intro-spatial-data-r']
author_profile: false
comments: false
order: 1
---


This tutorial introduces issues associated with spatial data management.

**R Skill Level:** Beginner

<div class="notice--success" markdown="1">

# Goals / Objectives

After completing this activity, you will:

* know stuff

### Install R Packages

* **raster:** `install.packages("raster")`
* **rgdal:** `install.packages("rgdal")`


****

### Additional Resources

* Wikipedia article on
<a href="https://en.wikipedia.org/wiki/GIS_file_formats" target="_blank">
GIS file formats.</a>

</div>

This should introduce the user to spatial data management issues - that we
will discuss in this series.

## Get Started With Your Project -  File Organization

When we work with large, spatio-temporal data, it is a good idea to store large
data sets in a general data directory that you can easily access from many
projects. If you are working in a collaborative
environment, use a shared data directory.

## One Dataset - Many Files

While text files often are self contained (one CSV) is composed of one unique file,
many spatial formats contain several files. For instance, a shapefile (discussed
below) contains 3 or more files, all of which must retain the same NAME and be
stored in the same file directory, in order for you to be able to work with them.
We will discuss these issues as they related to two key spatial data formats -
.shp (shapefile) which stores **vector** data and .tif (geotiff) which stores
**raster** data in more detail, below.


# Basic Raster vs Vector overview
