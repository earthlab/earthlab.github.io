---
layout: single
title: "GIS in R: shp, shx and dbf + prj - the files that make up a shapefile"
excerpt: "This lesson reviews the core files that are required to use a shapefile including: shp, shx and dbf. It also covers the .prj format which is used to
define the coordinate reference system (CRS) of the data. "
authors: ['Leah Wasser']
modified: '2017-09-10'
category: [courses]
class-lesson: ['class-intro-spatial-r']
permalink: /courses/earth-analytics/spatial-data-r/shapefile-structure/
nav-title: 'Shapefile structure'
week: 4
sidebar:
  nav:
author_profile: false
comments: true
order: 2
course: "earth-analytics"
topics:
  spatial-data-and-gis: ['vector-data', 'coordinate-reference-systems']
---

{% include toc title="In this lesson" icon="file-text" %}

<div class='notice--success' markdown="1">

## <i class="fa fa-graduation-cap" aria-hidden="true"></i> Learning objectives

After completing this tutorial, you will be able to:

* Be able to list the 3 core files associated with a shapefile

## <i class="fa fa-check-square-o fa-2" aria-hidden="true"></i> What you need

You will need a computer with internet access to complete this lesson and the data for week 5 of the course.

[<i class="fa fa-download" aria-hidden="true"></i> Download week 5 data (~500 MB)](https://ndownloader.figshare.com/files/7525363){:data-proofer-ignore='' .btn }

</div>


## One dataset - many files

While text files often are self contained (one `CSV`) is composed of one unique file,
many spatial formats are composed of several files. A shapefile is created by
3 or more files, all of which must retain the same NAME and be
stored in the same file directory, in order for you to be able to work with them.

### Shapefile structure

There are 3 key files associated with any and all shapefiles:

* **`.shp`:** the file that contains the geometry for all features.
* **`.shx`:** the file that indexes the geometry.
* **`.dbf`:** the file that stores feature attributes in a tabular format.

These files need to have the **same name** and to be stored in the same
directory (folder) to open properly in a `GIS`, `R` or `Python` tool.

Sometimes, a shapefile will have other associated files including:

* `.prj`: the file that contains information on projection format including
the coordinate system and projection information. It is a plain text file
describing the projection using well-known text (`WKT`) format.
* `.sbn` and `.sbx`: the files that are a spatial index of the features.
* `.shp.xml`: the file that is the geospatial metadata in XML format, (e.g.
ISO 19115 or `XML` format).

## Data management - sharing shapefiles

When you work with a shapefile, you must keep all of the key associated
file types together. And when you share a shapefile with a colleague, it is
important to zip up all of these files into one package before you send it to
them!

<div class="notice--info" markdown="1">

## Additional resources:

* [Intro to Working With Vector Data in R - Data Carpentry / NEON series](http://neondataskills.org/tutorial-series/vector-data-series/).

</div>
