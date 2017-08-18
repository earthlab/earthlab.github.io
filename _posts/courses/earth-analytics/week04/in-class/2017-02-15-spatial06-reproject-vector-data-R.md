---
layout: single
title: "GIS in R: how to reproject vector data in different coordinate reference systems (crs) in R"
excerpt: "In this lesson we cover how to reproject a vector dataset using the spTransform() function in R. "
authors: ['Leah Wasser']
modified: '2017-08-18'
category: [courses]
class-lesson: ['class-intro-spatial-r']
permalink: /courses/earth-analytics/week-4/reproject-vector-data/
nav-title: 'Reproject vector data'
week: 4
course: "earth-analytics"
sidebar:
  nav:
author_profile: false
comments: true
order: 6
topics:
  spatial-data-and-gis: ['vector-data', 'coordinate-reference-systems']
  reproducible-science-and-programming:
---

{% include toc title="In This Lesson" icon="file-text" %}

<div class='notice--success' markdown="1">

## <i class="fa fa-graduation-cap" aria-hidden="true"></i> Learning Objectives

After completing this tutorial, you will be able to:

* Describe atleast 2 reasons that a data provider may chose to store a dataset in a particular CRS.
* Reproject a vector dataset to another CRS in R.
* Identify the CRS of a spatial dataset in R.

## <i class="fa fa-check-square-o fa-2" aria-hidden="true"></i> What you need

You will need a computer with internet access to complete this lesson and the data for week 5 of the course.

[<i class="fa fa-download" aria-hidden="true"></i> Download Week 5 Data (~500 MB)](https://ndownloader.figshare.com/files/7525363){:data-proofer-ignore='' .btn }

</div>

## Working With Spatial Data From Different Sources

We often need to gather spatial datasets for from
different sources and/or data that cover different spatial `extents`. Spatial
data from different sources and that cover different extents are often in
different Coordinate Reference Systems (CRS).

Some reasons for data being in different CRSs include:

1. The data are stored in a particular CRS convention used by the data
provider which might be a federal agency, or a state planning office.
2. The data are stored in a particular CRS that is customized to a region.
For instance, many states prefer to use a **State Plane** projection customized
for that state.

<figure>
    <a href="{{ site.url }}/images/courses/earth-analytics/week-5/different_projections.jpg">
    <img src="{{ site.url }}/images/courses/earth-analytics/week-5/different_projections.jpg" alt="Maps of the United States using data in different projections.">
    </a>

    <figcaption>Maps of the United States using data in different projections.
    Notice the differences in shape associated with each different projection.
    These differences are a direct result of the calculations used to "flatten"
    the data onto a 2-dimensional map. Often data are stored purposefully in a
    particular projection that optimizes the relative shape and size of
    surrounding geographic boundaries (states, counties, countries, etc).
    Source: opennews.org</figcaption>
</figure>


In this tutorial we will learn how to identify and manage spatial data
in different projections. We will learn how to `reproject` the data so that they
are in the same projection to support plotting / mapping. Note that these skills
are also required for any geoprocessing / spatial analysis. Data need to be in
the same CRS to ensure accurate results.

We will use the `rgdal` and `raster` libraries in this tutorial.


```r
# load spatial data packages
library(rgdal)
library(raster)
library(rgeos)
options(stringsAsFactors = F)
# set working directory to data folder
# setwd("pathToDirHere")
```

## Import US Boundaries - Census Data

There are many good sources of boundary base layers that we can use to create a
basemap. Some `R` packages even have these base layers built in to support quick
and efficient mapping. In this tutorial, we will use boundary layers for the
United States, provided by the
<a href="https://www.census.gov/geo/maps-data/data/cbf/cbf_state.html" target="_blank" data-proofer-ignore=''> United States Census Bureau.</a>

It is useful to have shapefiles to work with because we can add additional
attributes to them if need be - for project specific mapping.

## Read US Boundary File

We will use the `readOGR()` function to import the
`/usa-boundary-layers/US-State-Boundaries-Census-2014` layer into `R`. This layer
contains the boundaries of all continental states in the U.S. Please note that
these data have been modified and reprojected from the original data downloaded
from the Census website to support the learning goals of this tutorial.


```r
# Import the shapefile data into R
state_boundary_us <- readOGR("data/week_03/usa-boundary-layers",
          "US-State-Boundaries-Census-2014")
## Error in ogrInfo(dsn = dsn, layer = layer, encoding = encoding, use_iconv = use_iconv, : Cannot open data source

# view data structure
class(state_boundary_us)
## Error in eval(expr, envir, enclos): object 'state_boundary_us' not found
```

Note: the Z-dimension warning is normal. The `readOGR()` function doesn't import
z (vertical dimension or height) data by default. This is because not all
shapefiles contain z dimension data.
<a href="https://www.rdocumentation.org/packages/gdalUtils/versions/2.0.1.7/topics/ogrinfo" target="_blank">More on readOGR</a>

Next, let's plot the U.S. states data.


```r
# view column names
plot(state_boundary_us,
     main="Map of Continental US State Boundaries\n US Census Bureau Data")
## Error in plot(state_boundary_us, main = "Map of Continental US State Boundaries\n US Census Bureau Data"): object 'state_boundary_us' not found
```

## U.S. Boundary Layer

We can add a boundary layer of the United States to our map - to make it look
nicer. We will import
`data/week_03/usa-boundary-layers/US-Boundary-Dissolved-States`.
If we specify a thicker line width using `lwd=4` for the border layer, it will
make our map pop!


```r
# Read the .csv file
country_boundary_us <- readOGR("data/week_03/usa-boundary-layers",
          "US-Boundary-Dissolved-States")
## Error in ogrInfo(dsn = dsn, layer = layer, encoding = encoding, use_iconv = use_iconv, : Cannot open data source

# look at the data structure
class(country_boundary_us)
## Error in eval(expr, envir, enclos): object 'country_boundary_us' not found

# view column names
plot(state_boundary_us,
     main="Map of Continental US State Boundaries\n US Census Bureau Data",
     border="gray40")
## Error in plot(state_boundary_us, main = "Map of Continental US State Boundaries\n US Census Bureau Data", : object 'state_boundary_us' not found

# view column names
plot(country_boundary_us,
     lwd=4,
     border="gray18",
     add = TRUE)
## Error in plot(country_boundary_us, lwd = 4, border = "gray18", add = TRUE): object 'country_boundary_us' not found
```

Next, let's add the location of our study area sites.
As we are adding these layers, take note of the class of each object. We will use
AOI to represent "Area of Interest" in our data.


```r
# Import a polygon shapefile
sjer_aoi <- readOGR("data/week_03/california/SJER/vector_data",
                      "SJER_crop")
## Error in ogrInfo(dsn = dsn, layer = layer, encoding = encoding, use_iconv = use_iconv, : Cannot open data source
class(sjer_aoi)
## Error in eval(expr, envir, enclos): object 'sjer_aoi' not found

# plot point - looks ok?
plot(sjer_aoi,
     pch = 19,
     col = "purple",
     main="San Joachin Experimental Range AOI")
## Error in plot(sjer_aoi, pch = 19, col = "purple", main = "San Joachin Experimental Range AOI"): object 'sjer_aoi' not found
```

Our SJER AOI layer plots nicely. Let's next add it as a layer on top of the U.S. states and boundary
layers in our basemap plot.


```r
# plot state boundaries
plot(state_boundary_us,
     main="Map of Continental US State Boundaries \n with SJER AOI",
     border="gray40")
## Error in plot(state_boundary_us, main = "Map of Continental US State Boundaries \n with SJER AOI", : object 'state_boundary_us' not found

# add US border outline
plot(country_boundary_us,
     lwd=4,
     border="gray18",
     add = TRUE)
## Error in plot(country_boundary_us, lwd = 4, border = "gray18", add = TRUE): object 'country_boundary_us' not found

# add AOI boundary
plot(sjer_aoi,
     pch = 19,
     col = "purple",
     add = TRUE)
## Error in plot(sjer_aoi, pch = 19, col = "purple", add = TRUE): object 'sjer_aoi' not found
```

What do you notice about the resultant plot? Do you see the AOI boundary in the California area? Is something wrong?

Let's check out the CRS (`crs()`) of both datasets to see if we can identify any
issues that might cause the point location to not plot properly on top of our
U.S. boundary layers.


```r
# view CRS of our site data
crs(sjer_aoi)
## Error in crs(sjer_aoi): object 'sjer_aoi' not found

# view crs of census data
crs(state_boundary_us)
## Error in crs(state_boundary_us): object 'state_boundary_us' not found
crs(country_boundary_us)
## Error in crs(country_boundary_us): object 'country_boundary_us' not found
```

It looks like our data are in different CRS. We can tell this by looking at
the CRS strings in `proj4` format.

## Understanding CRS in Proj4 Format
The CRS for our data are given to us by `R` in `proj4` format. Let's break
down the pieces of `proj4` string. The string contains all of the individual
CRS elements that `R` or another GIS might need. Each element is specified
with a `+` sign, similar to how a `.csv` file is delimited or broken up by
a `,`. After each `+` we see the CRS element being defined. For example
projection (`proj=`) and datum (`datum=`).

### UTM Proj4 String
Our project string for `sjer_aoi` specifies the UTM projection as follows:

`+proj=utm +zone=18 +datum=WGS84 +units=m +no_defs +ellps=WGS84 +towgs84=0,0,0`

* **proj=utm:** the projection is UTM, UTM has several zones.
* **zone=18:** the zone is 18
* **datum=WGS84:** the datum WGS84 (the datum refers to the  0,0 reference for
the coordinate system used in the projection)
* **units=m:** the units for the coordinates are in METERS.
* **ellps=WGS84:** the ellipsoid (how the earth's  roundness is calculated) for
the data is WGS84

Note that the `zone` is unique to the UTM projection. Not all CRS will have a
zone.

### Geographic (lat / long) Proj4 String

Our project string for `state_boundary_us` and `country_boundary_us` specifies
the lat/long projection as follows:

`+proj=longlat +datum=WGS84 +no_defs +ellps=WGS84 +towgs84=0,0,0`

* **proj=longlat:** the data are in a geographic (latitude and longitude)
coordinate system
* **datum=WGS84:** the datum WGS84 (the datum refers to the  0,0 reference for
the coordinate system used in the projection)
* **ellps=WGS84:** the ellipsoid (how the earth's roundness is calculated)
is WGS84

Note that there are no specified units above. This is because this geographic
coordinate reference system is in latitude and longitude which is most
often recorded in *Decimal Degrees*.

<i class="fa fa-star"></i> **Data Tip:** the last portion of each `proj4` string
is `+towgs84=0,0,0 `. This is a conversion factor that is used if a datum
conversion is required. We will not deal with datums in this tutorial series.
{: .notice--success}

## CRS Units - View Object Extent

Next, let's view the extent or spatial coverage for the `sjer_aoi` spatial
object compared to the `state_boundary_us` object.


```r
# extent & crs for AOI
extent(sjer_aoi)
## Error in extent(sjer_aoi): object 'sjer_aoi' not found
crs(sjer_aoi)
## Error in crs(sjer_aoi): object 'sjer_aoi' not found

# extent & crs for object in geographic
extent(state_boundary_us)
## Error in extent(state_boundary_us): object 'state_boundary_us' not found
crs(state_boundary_us)
## Error in crs(state_boundary_us): object 'state_boundary_us' not found
```

Note the difference in the units for each object. The extent for
`state_boundary_us` is in latitude and longitude which yields smaller numbers
representing decimal degree units. Our AOI boundary point is in UTM, is
represented in meters.

***

## Proj4 & CRS Resources

* <a href="http://proj.maptools.org/faq.html" target="_blank">More information on the proj4 format.</a>
* <a href="http://spatialreference.org" target="_blank">A fairly comprehensive list of CRS by format.</a>
* To view a list of datum conversion factors type: `projInfo(type = "datum")`
into the `R` console.

***

## Reproject Vector Data

Now we know our data are in different CRS. To address this, we have to modify
or **reproject** the data so they are all in the **same** CRS. We can use
`spTransform()` function to reproject our data. When we reproject the data, we
specify the CRS that we wish to transform our data to. This CRS contains
the datum, units and other information that `R` needs to **reproject** our data.

The `spTransform()` function requires two inputs:

1. the name of the object that you wish to transform
2. the CRS that you wish to transform that object too. In this case we can
use the `crs()` of the `state_boundary_us` object as follows:
`crs(state_boundary_us)`

<i class="fa fa-star"></i> **Data Tip:** `spTransform()` will only work if your
original spatial object has a CRS assigned to it AND if that CRS is the
correct CRS!
{: .notice--success}

Next, let's reproject our point layer into the geographic - latitude and
longitude `WGS84` coordinate reference system (CRS).


```r
# reproject data
sjer_aoi_WGS84 <- spTransform(sjer_aoi,
                                crs(state_boundary_us))
## Error in spTransform(sjer_aoi, crs(state_boundary_us)): object 'sjer_aoi' not found

# what is the CRS of the new object
crs(sjer_aoi_WGS84)
## Error in crs(sjer_aoi_WGS84): object 'sjer_aoi_WGS84' not found
# does the extent look like decimal degrees?
extent(sjer_aoi_WGS84)
## Error in extent(sjer_aoi_WGS84): object 'sjer_aoi_WGS84' not found
```

Once our data are reprojected, we can try to plot again.


```r
# plot state boundaries
plot(state_boundary_us,
     main="Map of Continental US State Boundaries\n With SJER AOI",
     border="gray40")
## Error in plot(state_boundary_us, main = "Map of Continental US State Boundaries\n With SJER AOI", : object 'state_boundary_us' not found

# add US border outline
plot(country_boundary_us,
     lwd=4,
     border="gray18",
     add = TRUE)
## Error in plot(country_boundary_us, lwd = 4, border = "gray18", add = TRUE): object 'country_boundary_us' not found

# add AOI
plot(sjer_aoi_WGS84,
     pch = 19,
     col = "purple",
     add = TRUE)
## Error in plot(sjer_aoi_WGS84, pch = 19, col = "purple", add = TRUE): object 'sjer_aoi_WGS84' not found
```

But now, the aoi is a polygon and it's too small to see on the map. Let's convert
the polygon to a polygon CENTROID and plot yet again.


```r
# get coordinate center of the polygon
aoi_centroid <- coordinates(sjer_aoi_WGS84)
## Error in coordinates(sjer_aoi_WGS84): object 'sjer_aoi_WGS84' not found

# plot state boundaries
plot(state_boundary_us,
     main="Map of Continental US State Boundaries\n With SJER AOI",
     border="gray40")
## Error in plot(state_boundary_us, main = "Map of Continental US State Boundaries\n With SJER AOI", : object 'state_boundary_us' not found

# add US border outline
plot(country_boundary_us,
     lwd=4,
     border="gray18",
     add = TRUE)
## Error in plot(country_boundary_us, lwd = 4, border = "gray18", add = TRUE): object 'country_boundary_us' not found

# add point location of the centroid to the plot
points(aoi_centroid, pch=8, col="magenta", cex=1.5)
## Error in points(aoi_centroid, pch = 8, col = "magenta", cex = 1.5): object 'aoi_centroid' not found
```

Reprojecting our data ensured that things line up on our map! It will also
allow us to perform any required geoprocessing (spatial calculations /
transformations) on our data.

<div class="notice--warning" markdown="1">

## <i class="fa fa-pencil-square-o" aria-hidden="true"></i> Test your skills: crop, reproject, plot data

Create a map of our SJER study area as follows:

1. Import the `madera-county-roads/tl_2013_06039_roads.shp` layer located in your week4 data download.
2. Create a map that shows the roads layer, study site locations and the sjer_aoi boundary.
3. Add a **title** to your plot.
4. Add a **legend** to your plot that shows both the roads and the plot locations.
5. Plot the roads by road type and add each type to the legend. HINT: use the metadata included in your data download to figure out what each type of road represents ("C", "S", etc.). [Use the homework lesson on custom legends]({{ site.url }}/courses/earth-analytics/week-4/r-create-custom-legend-with-base-plot/) to help build the legend.
6. BONUS: Plot the plots by type - adjust the symbology of the plot locations (choose a symbol using pch for each type and adjust the color of the points).
7. Do your best to make the map look nice!

IMPORTANT: be sure that all of the data are within the same EXTENT and crs of the sjer_aoi
layer. This means that you may have to CROP and reproject your data prior to plotting it!

Your map should look something like the map below. You should of course use the
actual roads types that you find in the metadata rather than "Road type 1, etc"

NOTE: this is also a plot you will submit as a part of your homework this week!

</div>


```
## Error in ogrInfo(dsn = dsn, layer = layer, encoding = encoding, use_iconv = use_iconv, : Cannot open data source
## Error in ogrInfo(dsn = dsn, layer = layer, encoding = encoding, use_iconv = use_iconv, : Cannot open data source
## Error in ogrInfo(dsn = dsn, layer = layer, encoding = encoding, use_iconv = use_iconv, : Cannot open data source
## Error in spTransform(sjer_roads, crs(sjer_aoi)): object 'sjer_roads' not found
## Error in crop(sjer_roads_utm, sjer_aoi): object 'sjer_roads_utm' not found
## Error in sjer_roads_utm$RTTYP[is.na(sjer_roads_utm$RTTYP)] <- "unknown": object 'sjer_roads_utm' not found
## Error in as.factor(sjer_roads_utm$RTTYP): object 'sjer_roads_utm' not found
## Error in plot(sjer_aoi, main = "SJER Area of Interest (AOI)", border = "gray18", : object 'sjer_aoi' not found
## Error in plot(sjer_plots, pch = c(19, 8, 19)[factor(sjer_plots$plot_type)], : object 'sjer_plots' not found
## Error in plot(sjer_roads_utm, col = c("orange", "black", "brown")[sjer_roads_utm$RTTYP], : object 'sjer_roads_utm' not found
## Error in factor(sjer_plots$plot_type): object 'sjer_plots' not found
```



```
## null device 
##           1
```
