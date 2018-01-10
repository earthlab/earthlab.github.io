---
layout: single
title: "GIS in R: Understand EPSG, WKT and other CRS definition styles"
excerpt: "This lesson discusses ways that coordinate reference system data are stored including  proj4, well known text (wkt) and EPSG codes. "
authors: ['Leah Wasser']
modified: '2018-01-10'
category: [courses]
class-lesson: ['class-intro-spatial-r']
permalink: /courses/earth-analytics/spatial-data-r/understand-epsg-wkt-and-other-crs-definition-file-types/
nav-title: 'EPSG, Proj4, WKT crs Formats'
week: 4
course: "earth-analytics"
sidebar:
  nav:
author_profile: false
comments: true
order: 5
topics:
  spatial-data-and-gis: ['vector-data', 'coordinate-reference-systems']
  reproducible-science-and-programming:
---


{% include toc title="In This Lesson" icon="file-text" %}



This lesson discusses ways that coordinate reference system data are stored
including `proj4`, well known text (`wkt`) and `EPSG` codes.

<div class='notice--success' markdown="1">

## <i class="fa fa-graduation-cap" aria-hidden="true"></i> Learning Objectives

After completing this tutorial, you will be able to:

* Identify the `proj4` vs `EPSG` vs `WKT` crs format when presented with all three formats.
* Look up a `CRS` definition in `proj4`, `EPSG` or `WKT` formats using spatialreference.org.
* Create a `proj4` string in `R` using an `EPSG` code.
* Look up an `proj4` string using an `epsg` code with `dplyr` pipes the the `make_EPSG()` function.

## <i class="fa fa-check-square-o fa-2" aria-hidden="true"></i> What You Need

You will need a computer with internet access to complete this lesson and the data 
for week 4 of the course.

[<i class="fa fa-download" aria-hidden="true"></i> Download Week 4 Data (~500 MB)](https://ndownloader.figshare.com/files/7525363){:data-proofer-ignore='' .btn }

</div>

In the previous lessons you learned what a coordinate reference system (`CRS`) is, the
components of a coordinate reference system and the general differences between
projected and geographic coordinate reference systems. In this lesson you will
cover the different ways that `CRS` information is stored.

### Coordinate Reference System Formats

There are numerous formats that are used to document a `CRS`. Three common
formats include:

* **proj.4**
* **EPSG**
* Well-known Text (**WKT**)
formats.

Often you have `CRS` information in one format and you need to translate and use it in a tool like `R`.

One of the most powerful websites to look up `CRS` strings is <a href="http://spatialreference.org/" target="_blank">Spatialreference.org</a>.
You can use the search on the site to find an `EPSG` code. Once you find the page
associated with your `CRS` of interest you can then look at all of the various formats
associated with that `CRS`:
<a href="http://spatialreference.org/ref/epsg/4326/" target="_blank">EPSG 4326 - WGS84 geographic</a>

#### PROJ or PROJ.4 Strings

`PROJ.4` strings are a compact way to identify a spatial or coordinate reference
system. `PROJ.4` strings are the primary output from many of the spatial data `R`
packages that you will use (e.g. `raster`, `rgdal`). Note that the `sf` package
is moving towards the more concise `EPSG` format.

Using the `PROJ.4` syntax, you specify the complete set of parameters including
the ellipse, datum, projection units and projection definition that define a particular `CRS`.

The `sp` package in `R`, by default often uses the `proj4` format to define
`CRS` of an object. Let's explore some data to see.


```r
# load packages
library(raster)
library(rgdal)
library(dplyr)
library(stringr)
```



```r
# import data
aoi <- readOGR("data/week-04/california/SJER/vector_data/sjer_crop.shp")
```


```r
# view crs of the aoi
crs(aoi)
## CRS arguments:
##  +proj=utm +zone=11 +datum=WGS84 +units=m +no_defs +ellps=WGS84
## +towgs84=0,0,0
```

Notice that the `CRS` returned from your crop data layer is a string of
characters and numbers that are combined using `+` signs. The `CRS` for your data are
in the `proj4` format. The string contains all of the individual `CRS` elements
that `R` or another `GIS` might need. Each element is specified with a `+` sign,
similar to how a `.csv` file is delimited or broken up by a `,`. After each `+`
you see the `CRS` element being defined. For example `+proj=` and `+datum=`.

This is a `proj4` string:

`+proj=utm +zone=11 +datum=WGS84 +units=m +no_defs +ellps=WGS84
+towgs84=0,0,0`

You can break down the proj4 string into its individual components (again, separated by + signs) as follows:

* **+proj=utm:** the projection is UTM, UTM has several zones
* **+zone=11:** the zone is 11 which is a zone on the west coast, USA
* **datum=WGS84:** the datum WGS84 (the datum refers to the 0,0 reference for
the coordinate system used in the projection)
* **+units=m:** the units for the coordinates are in METERS
* **+ellps=WGS84:** the ellipsoid (how the earth's roundness is calculated) for
the data is WGS84

Note that the `zone` is unique to the UTM projection. Not all `CRS`s will have a
zone.

Also note that while California is above the equator - in the northern hemisphere -
there is no N (specifying north) following the zone (i.e. 11N) South is explicitly
specified in the UTM `proj4` specification however if there is no S, then you can
assume it's a northern projection.


### Geographic (Lat / Long) Proj4 String

Next, let's have a look at another `CRS` definition.


```r
# import data
world <- readOGR("data/week-04/global/ne_110m_land/ne_110m_land.shp")
## OGR data source with driver: ESRI Shapefile 
## Source: "data/week-04/global/ne_110m_land/ne_110m_land.shp", layer: "ne_110m_land"
## with 127 features
## It has 2 fields
crs(world)
## CRS arguments:
##  +proj=longlat +datum=WGS84 +no_defs +ellps=WGS84 +towgs84=0,0,0
```

Your projection string for the `world` data imported above looks different:

`+proj=longlat +datum=WGS84 +no_defs +ellps=WGS84 +towgs84=0,0,0`

This is a lat/long or geographic projection. The components of the
`proj4` string are broken down below.

* **+proj=longlat:** the data are in a geographic (latitude and longitude)
coordinate system
* **datum=WGS84:** the datum WGS84 (the datum refers to the  0,0 reference for
the coordinate system used in the projection)
* **+ellps=WGS84:** the ellipsoid (how the earth's roundness is calculated)
is WGS84

Note that there are no specified units above. This is because this geographic
coordinate reference system is in latitude and longitude which is most
often recorded in *Decimal Degrees*.

<i class="fa fa-star"></i> **Data tip:** the last portion of each `proj4` string
is `+towgs84=0,0,0 `. This is a conversion factor that is used if a `datum`
conversion is required.
{: .notice--success}

<i class="fa fa-star"></i> **Data tip2:** sometimes you will encounter global
data layers where the longitude spans from 0-360 rather than -180 - 180. You can
use the `rotate()` function to transform a raster into -180-180 units to deal
with this in `R`.
{: .notice--success}


#### EPSG Codes
The `EPSG` codes are 4-5 digit numbers that represent `CRS` definitions. The
acronym `EPGS`, comes from the, now defunct, European Petroleum Survey Group. Each
code is a four-five digit number which represents a particular `CRS` definition.

<a href="http://spatialreference.org/ref/epsg/" target="_blank" class="btn">List of ESPG codes on spatialreference.org
</a>

You can create a list of EPSG codes using the `make_epsg()` function in
`rgdal` package in `R`. This can be useful if you need to look up a code and
you don't have internet access to look at the <a href="http://spatialreference.org" target="_blank">spatialreference.org website</a>.


```r
# create data frame of epsg codes
epsg <- make_EPSG()
# view data frame - top 6 results
head(epsg)
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
Once you have a `data.frame` of `EPSG` definitions, you can search it.
Let's search your `dat.frame` for 4326 to figure out what `CRS` it represents.
You can use `dplyr` pipes and the `filter()` function to quickly extract just
the column where the code = 4326. Notice that you use a double = sign (`==`) to
specify `equals to`.


```r
# view proj 4 string for the epsg code 4326
epsg %>%
  filter(code == 4326)
##   code     note                                prj4
## 1 4326 # WGS 84 +proj=longlat +datum=WGS84 +no_defs
```

Alternatively, you can use the `str_detect()` from the `stringr` package in your
pipe to find all `CRS` definitions that contain the string `longlat` to search for
a geographic `CRS`.


```r
latlong <- epsg %>%
  filter(str_detect(prj4, 'longlat'))
head(latlong)
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
This should once again return `EPSG` code 4326.

Similarly, let's search for UTM.


```r
utm <- epsg %>%
  filter(str_detect(prj4, 'utm'))
head(utm)
##   code                          note
## 1 2027    # NAD27(76) / UTM zone 15N
## 2 2028    # NAD27(76) / UTM zone 16N
## 3 2029    # NAD27(76) / UTM zone 17N
## 4 2030    # NAD27(76) / UTM zone 18N
## 5 2031 # NAD27(CGQ77) / UTM zone 17N
## 6 2032 # NAD27(CGQ77) / UTM zone 18N
##                                                 prj4
## 1 +proj=utm +zone=15 +ellps=clrk66 +units=m +no_defs
## 2 +proj=utm +zone=16 +ellps=clrk66 +units=m +no_defs
## 3 +proj=utm +zone=17 +ellps=clrk66 +units=m +no_defs
## 4 +proj=utm +zone=18 +ellps=clrk66 +units=m +no_defs
## 5 +proj=utm +zone=17 +ellps=clrk66 +units=m +no_defs
## 6 +proj=utm +zone=18 +ellps=clrk66 +units=m +no_defs
```

### Create CRS Objects

`R` has a class of type `crs`. You can use this to create `CRS` objects using both the
text string itself and / or the `EPSG` code. Let's give it a try. You will use your
geographic definition as an example.


```r
# create a crs definition by copying the proj 4 string
a_crs_object <- crs("+proj=longlat +datum=WGS84 +no_defs")
class(a_crs_object)
## [1] "CRS"
## attr(,"package")
## [1] "sp"
a_crs_object
## CRS arguments:
##  +proj=longlat +datum=WGS84 +no_defs +ellps=WGS84 +towgs84=0,0,0
```

Similarly you can use an `epsg` code to create a `proj4` string.


```r
# create crs using epsg code
a_crs_object_epsg <- crs("+init=epsg:4326")
class(a_crs_object_epsg)
## [1] "CRS"
## attr(,"package")
## [1] "sp"
a_crs_object_epsg
## CRS arguments:
##  +init=epsg:4326 +proj=longlat +datum=WGS84 +no_defs +ellps=WGS84
## +towgs84=0,0,0
```

#### WKT or Well-Known Text

We won't spend a lot of time on the Well-known text (`WKT`) format. However, it's
useful to recognize this format given many tools - including ESRI's `ArcMap` and
`ENVI` use this format. `WKT` is a compact machine- and
human-readable representation of geometric objects. It defines elements of
coordinate reference system (`CRS`) definitions using a combination of brackets `[]`
and elements separated by commas (`,`).

Here is an example of `WKT` for WGS84 geographic:

`GEOGCS["GCS_WGS_1984",DATUM["D_WGS_1984",SPHEROID["WGS_1984",6378137,298.257223563]],PRIMEM["Greenwich",0],UNIT["Degree",0.017453292519943295]]
`

Notice here that the elements are described explicitly using all caps - for example:

* UNIT
* DATUM

Sometimes `WKT` structured CRS information are embedded in a metadata file - similar
to the structure seen below:

```xml

GEOGCS["WGS 84",
    DATUM["WGS_1984",
        SPHEROID["WGS 84",6378137,298.257223563,
            AUTHORITY["EPSG","7030"]],
        AUTHORITY["EPSG","6326"]],
    PRIMEM["Greenwich",0,
        AUTHORITY["EPSG","8901"]],
    UNIT["degree",0.01745329251994328,
        AUTHORITY["EPSG","9122"]],
    AUTHORITY["EPSG","4326"]]

```


## How to Look Up a CRS

As previously mentioned, the best website to look-up CRS information is the
<a href="http://spatialreference.org" target="_blank">spatial reference.org website</a>.
This website has a useful search function that allows you to search
for strings such as:

* UTM 11N or
* WGS84

Once you find the CRS that you are looking for, you can explore definitions of
the `CRS` using various formats including `proj4`, `epsg`, `WKT` and others.

<div class="notice--info" markdown="1">

## Additional Resources

* <a href="http://docs.opengeospatial.org/is/12-063r5/12-063r5.html#43" target="_blank">Explore the WKT standard: Open Geospatial Consortium WKT document. </a>

* Read more about <a href="https://www.nceas.ucsb.edu/scicomp/recipes/projections" target="_blank">all three formats from the National Center for Ecological Analysis and Synthesis.</a>
* A handy four page overview of CRS <a href="https://www.nceas.ucsb.edu/~frazier/RSpatialGuides/OverviewCoordinateReferenceSystems.pdf" target="_blank">including file formats on page 1.</a>

* <a href="http://www.epsg-registry.org/" target="_blank">The EPSG registry. </a>
* <a href="http://spatialreference.org/" target="_blank">Spatialreference.org</a>
* <a href="http://spatialreference.org/ref/epsg/" target="_blank">List of ESPG codes.</a>

</div>
