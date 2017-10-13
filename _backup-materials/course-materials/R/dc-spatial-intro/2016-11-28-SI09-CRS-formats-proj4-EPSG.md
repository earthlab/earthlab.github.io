---
title: "A Abridged Overview of CRS Formats - Proj4 & EPSG - in R"
authors: [Leah Wasser]
contributors: [NEON Data Skills]
dateCreated: 2016-02-26
lastModified: 2016-11-29
packagesLibraries: [ ]
category: [course-materials]
excerpt: "This lesson covers formats that CRS information may be in including
proj4 and EPGS and how to work with them in R."
permalink: course-materials/spatial-data/intro-to-CRS-formats-proj4-EPSG-R
sidebar:
  nav:
class-lesson: ['intro-spatial-data-r']
author_profile: false
comments: false
nav-title: 'proj4 & epsg'
order: 9
---


## About

This lesson covers formats that CRS information may be in including
proj4 and EPGS and how to work with them in R.

**R Skill Level:** Beginner - you've got the basics of `R` down.

<div id="objectives" markdown="1">

# Goals / Objectives

After completing this activity, you will:

*


## Things You’ll Need To Complete This Lesson

To complete this lesson you will need the most current version of `R`, and
preferably, `RStudio` loaded on your computer.

### Install R Packages

* **NAME:** `install.packages("NAME")`

[More on Packages in R - Adapted from Software Carpentry.]({{site.baseurl}}R/Packages-In-R/)

### Download Data


****

**Spatial-Temporal Data & Data Management Lesson Series:** This lesson is part
of a lesson series introducing
[spatial data and data management in `R` ]({{ site.baseurl }}tutorial/URL).
It is also part of a larger
[spatio-temporal Data Carpentry Workshop ]({{ site.baseurl }}workshops/spatio-temporal-workshop)
that includes working with
[raster data in `R` ]({{ site.baseurl }}tutorial/spatial-raster-series),
[vector data in `R` ]({{ site.baseurl }}tutorial/spatial-vector-series)
and
[tabular time series in `R` ]({{ site.baseurl }}tutorial/tabular-time-series).

****

### Additional Resources
* Read more on coordinate systems in the
<a href="http://docs.qgis.org/2.0/en/docs/gentle_gis_introduction/coordinate_reference_systems.html" target="_blank">
QGIS documentation.</a>
* NEON Data Skills Lesson <a href="{{ site.baseurl }}/GIS-Spatial-Data/Working-With-Rasters/" target="_blank">The Relationship Between Raster Resolution, Spatial extent & Number of Pixels - in R</a>

</div>

## What is a Coordinate Reference System

To define the location of something we often use a coordinate system. This system
consists of an X and a Y value, located within a 2 (or more) -dimensional
(as shown below) space.

<figure>
	<a href="http://open.senecac.on.ca/clea/label/projectImages/15_276_xy-grid.jpg">
	<img src="http://open.senecac.on.ca/clea/label/projectImages/15_276_xy-grid.jpg"></a>
	<figcaption> We use coordinate systems with X, Y (and sometimes Z axes) to
	define the location of objects in space.
	Source: http://open.senecac.on.ca
	</figcaption>
</figure>


### Coordinate Reference System Formats

There are numerous formats that are used to document a `CRS`. Three common
formats include:

* **proj.4**
* **EPSG**
* Well-known Text (**WKT**)
formats.

#### PROJ or PROJ.4 strings

PROJ.4 strings are a compact way to identify a spatial or coordinate reference
system. PROJ.4 strings are the primary output from most of the spatial data `R`
packages that we will use (e.g. `raster`, `rgdal`).

Using the PROJ.4 syntax, we specify the complete set of parameters (e.g. ellipse, datum,
units, etc) that define a particular CRS.


## Understanding CRS in Proj4 Format
The `CRS` for our data are given to us by `R` in `proj4` format. Let's break
down the pieces of `proj4` string. The string contains all of the individual
`CRS` elements that `R` or another `GIS` might need. Each element is specified
with a `+` sign, similar to how a `.csv` file is delimited or broken up by
a `,`. After each `+` we see the `CRS` element being defined. For example
`+proj=` and `+datum=`.

### UTM Proj4 String
Our project string for `point_HARV` specifies the UTM projection as follows:

`+proj=utm +zone=18 +datum=WGS84 +units=m +no_defs +ellps=WGS84 +towgs84=0,0,0`

* **+proj=utm:** the projection is UTM, UTM has several zones.
* **+zone=18:** the zone is 18
* **datum=WGS84:** the datum WGS84 (the datum refers to the  0,0 reference for
the coordinate system used in the projection)
* **+units=m:** the units for the coordinates are in METERS.
* **+ellps=WGS84:** the ellipsoid (how the earth's  roundness is calculated) for
the data is WGS84

Note that the `zone` is unique to the UTM projection. Not all `CRS` will have a
zone.

### Geographic (lat / long) Proj4 String

Our project string for `State.boundary.US` and `Country.boundary.US` specifies
the lat/long projection as follows:

`+proj=longlat +datum=WGS84 +no_defs +ellps=WGS84 +towgs84=0,0,0`

* **+proj=longlat:** the data are in a geographic (latitude and longitude)
coordinate system
* **datum=WGS84:** the datum WGS84 (the datum refers to the  0,0 reference for
the coordinate system used in the projection)
* **+ellps=WGS84:** the ellipsoid (how the earth's roundness is calculated)
is WGS84

Note that there are no specified units above. This is because this geographic
coordinate reference system is in latitude and longitude which is most
often recorded in *Decimal Degrees*.

<i class="fa fa-star"></i> **Data Tip:** the last portion of each `proj4` string
is `+towgs84=0,0,0 `. This is a conversion factor that is used if a `datum`
conversion is required. We will not deal with datums in this particular series.
{: .notice}


* Read more about <a href="https://www.nceas.ucsb.edu/scicomp/recipes/projections" target="_blank">all three formats from the National Center for Ecological Analysis and Synthesis.</a>

* A handy four page overview of CRS <a href="https://www.nceas.ucsb.edu/~frazier/RSpatialGuides/OverviewCoordinateReferenceSystems.pdf" target="_blank">including file formats on page 1.</a>

#### EPSG codes
The EPSG codes are a structured dataset of CRSs that are used around the world. They were
originally compiled by the, now defunct, European Petroleum Survey Group, hence the
EPSG acronym. Each code is a four digit number.

The codes and more information can be found on these websites:
* <a href="http://www.epsg-registry.org/" target="_blank">The EPSG registry. </a>
* <a href="http://spatialreference.org/" target="_blank">Spatialreference.org</a>
* <a href="http://spatialreference.org/ref/epsg/" target="_blank">list of ESPG codes.</a>


```r
library('rgdal')
epsg = make_EPSG()
# View(epsg)
head(epsg)
```

```
##   code                                               note
## 1 3819                                           # HD1909
## 2 3821                                            # TWD67
## 3 3824                                            # TWD97
## 4 3889                                             # IGRS
## 5 3906                                         # MGI 1901
## 6 4001 # Unknown datum based upon the Airy 1830 ellipsoid
##                                                                                            prj4
## 1 +proj=longlat +ellps=bessel +towgs84=595.48,121.69,515.35,4.115,-2.9383,0.853,-3.408 +no_defs
## 2                                                         +proj=longlat +ellps=aust_SA +no_defs
## 3                                    +proj=longlat +ellps=GRS80 +towgs84=0,0,0,0,0,0,0 +no_defs
## 4                                    +proj=longlat +ellps=GRS80 +towgs84=0,0,0,0,0,0,0 +no_defs
## 5                            +proj=longlat +ellps=bessel +towgs84=682,-203,480,0,0,0,0 +no_defs
## 6                                                            +proj=longlat +ellps=airy +no_defs
```

#### WKT or Well-known Text
Well-known Text (WKT) allows for compact machine- and human-readable representation of
geometric objects as well as to consisely describing the critical elements of
coordinate reference system (CRS) definitions.

The codes and more information can be found on these websites:
* <a href="http://docs.opengeospatial.org/is/12-063r5/12-063r5.html#43" target="_blank">Open Geospatial Consortium WKT document. </a>


***
##Additional Resources
ESRI help on CRS
QGIS help on CRS
NCEAS cheatsheets
