---
layout: single
title: "GIS in R: Projected vs geographic Coordinate Reference Systems"
excerpt: "This tutorial describes key differences between projected and geographic coordinate reference systems (CRSs). We focus on the Universal Trans Mercator (UTM)
projected Coordinate Reference which divides the globe into zones to optimize
projection results in each zone and WGS84 which is a geographic (latitude and longitude) CRS. It also briefly introduces the concept of a datum."
authors: ['Leah Wasser']
modified: '2017-09-18'
category: [courses]
class-lesson: ['class-intro-spatial-r']
permalink: /courses/earth-analytics/spatial-data-r/geographic-vs-projected-coordinate-reference-systems-UTM/
nav-title: 'Geographic vs projected CRS'
week: 4
course: "earth-analytics"
sidebar:
  nav:
author_profile: false
comments: true
order: 4
topics:
  spatial-data-and-gis: ['vector-data', 'coordinate-reference-systems']
  reproducible-science-and-programming:
---


{% include toc title="In This Lesson" icon="file-text" %}



This lesson briefly discusses the key differences between projected vs. geographic
coordinate reference systems.

<div class='notice--success' markdown="1">

## <i class="fa fa-graduation-cap" aria-hidden="true"></i> Learning Objectives

After completing this tutorial, you will be able to:

* List 2-3 fundamental differences between a geographic and a projected `CRS`.
* Describe the elements of each zone within Universal Trans Mercator (UTM) CRS and Geographic (WGS84) CRSs

## <i class="fa fa-check-square-o fa-2" aria-hidden="true"></i> What you need

You will need a computer with internet access to complete this lesson and the data for week 5 of the course.

[<i class="fa fa-download" aria-hidden="true"></i> Download Week 5 Data (~500 MB)](https://ndownloader.figshare.com/files/7525363){:data-proofer-ignore='' .btn }

</div>

## Geographic vs Projected CRS

In the previous tutorial, we explored the basic concept of a coordinate reference system. During the lesson we looked at two different types of
 Coordinate Reference Systems:

1. **Geographic coordinate systems:** coordinate systems that span the entire
globe (e.g. latitude / longitude).
2. **Projected coordinate Systems:** coordinate systems that are localized to
minimize visual distortion in a particular region (e.g. Robinson, UTM, State Plane)

In this tutorial, we will discuss the differences between these CRSs in more
detail.

As we discussed in the previous lesson, each `CRS` is optimized to best represent the:

* shape and/or
* scale / distance and/or
* area

of features in a dataset. There is not a single CRS that does a great job at optimizing all three elements: shape, distance AND
area. Some CRSs are optimized for shape, some are optimized for distance and
some are optimized for area. Some CRSs are also optimized for particular regions
- for instance the United States, or Europe.

## Intro to Geographic coordinate reference systems

Geographic coordinate systems (which are often but not always in decimal degree
units) are often optimal when we need to locate places on the Earth. Or when
we need to create global maps. However, latitude and longitude
locations are not located using uniform measurement units. Thus, geographic
CRSs are not ideal for measuring distance. This is why other projected `CRS`
have been developed.

<figure>
	<a href="{{ site.url }}/images/courses/earth-analytics/week-5/LatLongfromGlobeCenter-ESRI.gif">
	<img src="{{ site.url }}/images/courses/earth-analytics/week-5/LatLongfromGlobeCenter-ESRI.gif" alt="Graphic showing lat long as it's placed over the globe by ESRI."></a>
	<figcaption>A geographic coordinate system locates latitude and longitude
	location using angles. Thus the spacing of each line of latitude moving north
	and south is not uniform.
	Source: ESRI
	</figcaption>
</figure>

## The structure of a geographic CRS

A geographic CRS uses a grid that wraps around the entire globe.
This means that each point on the globe is defined using the SAME coordinate
system and the same units as defined within that particular geographic CRS.
Geographic coordinate reference systems are best for global analysis however it
is important to remember that distance is distorted using a geographic lat / long
`CRS`.

The **geographic WGS84 lat/long** `CRS` has an origin - (0,0) -
located at the intersection of the
Equator (0° latitude) and Prime Meridian (0° longitude) on the globe.

Let's remind ourselves what data projects in a geographic CRS look like.

<img src="{{ site.url }}/images/rfigs/courses/earth-analytics/04-vector-data-gis-r/in-class/2017-02-15-spatial04-geographic-vs-projected-crs/geographic-WGS84-1.png" title="wgs 84 plot" alt="wgs 84 plot" width="90%" />


<i class="fa fa-star"></i> **Data Note:** The distance between the 2 degrees of
longitude at the equator (0°) is ~ 69 miles. The distance between 2 degrees of
longitude at 40°N (or S) is only 53 miles. This difference in actual distance relative to
"distance" between the actual parallels and meridians demonstrates how distance
calculations will be less accurate when using geographic CRSs
{: .notice--success}


## Projected Coordinate Reference Systems

As we learned above, geographic coordinate systems are ideal for creating
global maps. However, they are prone to error when quantifying distance. In contrast, various spatial projections have evolved that can be used to more accurately capture distance, shape and/or area.

### What is a spatial projection
Spatial projection refers to the mathematical calculations
performed to flatten the 3D data onto a 2D plane (our computer screen
or a paper map). Projecting data from a round surface onto a flat surface, results
in visual modifications to the data when plotted on a map. Some areas are stretched
and some some are compressed. We can see this distortion when we look at a map
of the entire globe.

The mathematical calculations used in spatial projections are designed to
optimize the relative size and shape of a particular region on the globe.

<figure>
    <a href="{{ site.url }}/images/courses/earth-analytics/week-5/dev-crs-surfaces.png">
    <img src="{{ site.url }}/images/courses/earth-analytics/week-5/dev-crs-surfaces.png" alt="projection surfaces graphic">
    </a>
    <figcaption>The 3-dimensional globe must be transformed to create a flat
    2-dimensional map. How that transformation or **projection** occurs changes
    the appearance of the final map and the relative size of objects in
    different parts of the map.
    Source: CA Furuti, progonos.com/furuti</figcaption>
</figure>


### About UTM

The **Universal Transverse Mercator** (UTM) system is a commonly used projected
coordinate reference system. UTM subdivides the globe into zones,
numbered 0-60 (equivalent to longitude) and regions (north and south)


<i class="fa fa-star"></i> **Data Note:** UTM zones are also defined using bands,
lettered C-X (equivalent to latitude) however, the band designation is often
dropped as it isn't essential to specifying the location.
{: .notice--success}

While UTM zones span the entire globe, UTM uses a regional projection and
associated coordinate system. The coordinate system grid for each
zone is projected individually using the **Mercator projection**.

The origin (0,0) for each UTM zone and associated region is located at the
intersection of the equator and a location, 500,000 meters east of the central
meridian of each zone. The origin location is placed outside of the boundary of
the UTM zone, to avoid negative Easting numbers.


<figure>
    <a href="{{ site.url }}/images/courses/earth-analytics/week-5/utm_zone_characteristics.png">
    <img src="{{ site.url }}/images/courses/earth-analytics/week-5/utm_zone_characteristics.png" alt="utm zone characteristics">
    </a>
    <figcaption>The 0,0 origin of each UTM zone is located in the <strong>Bottom left</strong> hand corner (south west) of the zone - exactly 500,000 m EAST from the central meridian of the zone.
    Source: Penn State E-education</figcaption>
</figure>

***



<figure>
    <a href="{{ site.url }}/images/courses/earth-analytics/week-5/800px-Utm-zones.jpg">
    <img src="{{ site.url }}/images/courses/earth-analytics/week-5/800px-Utm-zones.jpg" alt="Nasa image showing the UTM x and y zones">
    </a>
    <figcaption>The gridded UTM coordinate system across the globe.
    Source: NASA Earth Observatory</figcaption>
</figure>

### Understand UTM Coordinates

Let's compare coordinates for one location, but saved in two different CRSs to
better understand what this looks like. The coordinates for Boulder, Colorado in
UTM are:

`UTM Zone 13N easting: 476,911.31m, northing: 4,429,455.35`

Remember that N denotes that it is in the Northern hemisphere on the Earth.

Let's plot this coordinate on a map


```r
# create a data.frame with the x,y location
boulder_df <- data.frame(lon=c(476911.31),
                lat=c(4429455.35))

# plot boulder
ggplot() +
                geom_point(data=boulder_df,
                aes(x=lon, y=lat, group=NULL), colour = "springgreen",
                      size=5)
```

<img src="{{ site.url }}/images/rfigs/courses/earth-analytics/04-vector-data-gis-r/in-class/2017-02-15-spatial04-geographic-vs-projected-crs/plot-wgs842-1.png" title="Plot location - wgs84" alt="Plot location - wgs84" width="90%" />

```r
# convert to spatial points
coordinates(boulder_df) <- 1:2

class(boulder_df)
## [1] "SpatialPoints"
## attr(,"package")
## [1] "sp"
crs(boulder_df)
## CRS arguments: NA

# assign crs - we know it is utm zone 13N
crs(boulder_df) <- CRS("+init=epsg:2957")
```



Note the projection of our data in UTM +init=epsg:2957 +proj=utm +zone=13 +ellps=GRS80 +towgs84=0,0,0,0,0,0,0 +units=m +no_defs

If we spatially project our data into a geographic coordinate refence system,
notice how our new coordinates are different - yet they still represent the same
location.


```r
boulder_df_geog <- spTransform(boulder_df, crs(worldBound))
coordinates(boulder_df_geog)
##         lon   lat
## [1,] -105.3 40.01
```

Now we can plot our data on top of our world map which is also in a geographic CRS.


```r
boulder_df_geog <- as.data.frame(coordinates(boulder_df_geog))
# plot map
worldMap <- ggplot(worldBound_df, aes(long,lat, group=group)) +
  geom_polygon() +
  xlab("Longitude (Degrees)") + ylab("Latitude (Degrees)") +
  coord_equal() +
  ggtitle("Global Map - Geographic Coordinate System - WGS84 Datum\n Units: Degrees - Latitude / Longitude")

# map boulder
worldMap +
        geom_point(data=boulder_df_geog,
        aes(x=lon, y=lat, group=NULL), colour = "springgreen", size=5)
```

<img src="{{ site.url }}/images/rfigs/courses/earth-analytics/04-vector-data-gis-r/in-class/2017-02-15-spatial04-geographic-vs-projected-crs/plot-world-map-1.png" title="global map in wgs84 with points" alt="global map in wgs84 with points" width="90%" />



### Important

While sometimes UTM zones in the north vs south are specified using N and S
respectively (e.g. UTM Zone 18N) other times you may see a letter as follows:
Zone 18T, 730782m Easting, 4712631m Northing vs UTM Zone 18N, 730782m, 4712631m.

<i class="fa fa-star"></i>**Data Tip:**  The UTM system doesn't apply to polar
regions (>80°N or S). Universal Polar Stereographic (UPS) coordinate system is
used in these area. This is where zones A, B and Y, Z are used if you were
wondering why they weren't in the UTM lettering system.
{: .notice--success }


<div class="notice--warning" markdown="1">

## <i class="fa fa-pencil-square-o" aria-hidden="true"></i> Optional challenge

The penn state e-education institute has a nice interactive tool that you can
use to explore utm coordinate reference systems.

<a href="https://www.e-education.psu.edu/natureofgeoinfo/sites/www.e-education.psu.edu.natureofgeoinfo/files/flash/coord_practice_utm_v06.swf" target="_blank">View UTM Interactive tool</a>

</div>


### Datum

The datum describes the vertical and horizontal reference point of the coordinate
system. The vertical datum describes the relationship between a specific ellipsoid
(the top of the earth's surface) and the center of the earth. The datum also describes
the origin (0,0) of a coordinate system.

Frequently encountered datums:

* *WGS84* -- World Geodetic System (created in) 1984.  The origin is the center of
the earth.
* *NAD27* & *NAD83* -- North American Datum 1927 and 1983,
respectively.  The origin for NAD 27 is Meades Ranch in Kansas.
* *ED50* -- European Datum 1950



> NOTE: All coordinate reference systems have a vertical and horizontal datum
which defines a "0, 0" reference point. There are two models used to define
the datum: **ellipsoid** (or spheroid): a mathematically representation of the shape of
the earth. Visit
<a href="https://en.wikipedia.org/wiki/Earth_ellipsoid" target="_blank">Wikipedia's article on the earth ellipsoid </a>  for more information and **geoid**: a
model of the earth's gravitatinal field which approximates the mean sea level
across the entire earth.  It is from this that elevation is measured. Visit
<a href="https://en.wikipedia.org/wiki/Geoid" target="_blank">Wikipedia's geoid
article </a>for more information. We will not cover these concepts in this tutorial.



### Coordinate Reference System Formats

There are numerous formats that are used to document a **CRS**. In the next tutorial
we will discuss three of the commonly encountered formats including: **Proj4**,
**WKT** (Well Known Text) and **EPSG**.


<div class="notice--info" markdown="1">

## Additional Resources

### More about the UTM CRS
* <a href="https://www.e-education.psu.edu/natureofgeoinfo/c2_p22.html" target="_blank">
Penn State E-education overview of UTM</a>
* <a href="https://www.e-education.psu.edu/natureofgeoinfo/c2_p23.html
" target="_blank">
More about UTM Zones - Penn State E-education</a>

### More about Datums
*  <a href="http://help.arcgis.com/en/arcgisdesktop/10.0/help/index.html#/Datums/003r00000008000000/" target="_blank">ESRI's ArcGIS discussion of Datums.</a>
*  <a href="https://www.nceas.ucsb.edu/~frazier/RSpatialGuides/OverviewCoordinateReferenceSystems.pdf" target="_blank">page 2 in M. Fraiser's CRS Overview.</a>

</div>
