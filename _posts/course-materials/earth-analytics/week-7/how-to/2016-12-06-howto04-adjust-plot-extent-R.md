---
layout: single
title: "Adjust plot extent in R."
excerpt: "In this lesson we will review how to adjust the extent of a spatial plot in R using the ext or extent argument and the extent of another layer. "
authors: ['Megan Cattau', 'Leah Wasser']
modified: '2017-02-28'
category: [course-materials]
class-lesson: ['how-to-hints-week7']
permalink: /course-materials/earth-analytics/week-7/adjust-plot-extent-R/
nav-title: 'Adjust plot extent'
week: 7
sidebar:
  nav:
author_profile: false
comments: true
order: 4
---

{% include toc title="In This Lesson" icon="file-text" %}

<div class='notice--success' markdown="1">

## <i class="fa fa-graduation-cap" aria-hidden="true"></i> Learning Objectives

After completing this tutorial, you will be able to:

*

## <i class="fa fa-check-square-o fa-2" aria-hidden="true"></i> What you need

You will need a computer with internet access to complete this lesson and the
data for week 6 of the course.

[<i class="fa fa-download" aria-hidden="true"></i> Download Week 6 Data (~500 MB)](https://ndownloader.figshare.com/files/7677208){:data-proofer-ignore='' .btn }
</div>



## Review: What is an extent?

<figure>
    <a href="{{ site.url }}/images/course-materials/earth-analytics/week-5/spatial_extent.png">
    <img src="{{ site.url }}/images/course-materials/earth-analytics/week-5/spatial_extent.png" alt="Spatial extent ">
    </a>
    <figcaption>Spatial extent.
    </figcaption>
</figure>







```r
all_landsat_bands <- list.files("data/week6/Landsat/LC80340322016189-SC20170128091153/crop",
           pattern=glob2rx("*band*.tif$"),
           full.names = T) # use the dollar sign at the end to get all files that END WITH

all_landsat_bands_st <- stack(all_landsat_bands)

# turn the axis color to white and turn off ticks
par(col.axis="white", col.lab="white", tck=0)
# plot the data - be sure to turn AXES to T (we just color them white)
plotRGB(all_landsat_bands_st,
        r=4, g=3, b=2,
        stretch="hist",
        main="Pre-fire RGB image with cloud\n Cold Springs Fire",
        axes=T)
# turn the box to white so there is no border on our plot
box(col="white")
```

<img src="{{ site.url }}/images/rfigs/course-materials/earth-analytics/week-7/how-to/2016-12-06-howto04-adjust-plot-extent-R/plot-landsat-1.png" title=" " alt=" " width="100%" />

## Adjust plot extent

We can adjust the extent of a plot using `ext` argument.
We can give the argument the spatial extent of the fire boundary
layer that we want to plot.

If our object is called fire_boundary_utm, then we'd code: `ext=extent(fire_boundary_utm)`



```r
# import fire overlay boundary
fire_boundary <- readOGR("data/week6/vector_layers/fire-boundary-geomac/co_cold_springs_20160711_2200_dd83.shp")
## OGR data source with driver: ESRI Shapefile 
## Source: "data/week6/vector_layers/fire-boundary-geomac/co_cold_springs_20160711_2200_dd83.shp", layer: "co_cold_springs_20160711_2200_dd83"
## with 1 features
## It has 21 fields
# reproject the data
fire_boundary_utm <- spTransform(fire_boundary, CRS=crs(all_landsat_bands_st))

# turn the axis color to white and turn off ticks
par(col.axis="white", col.lab="white", tck=0)
# plot the data - be sure to turn AXES to T (we just color them white)
plotRGB(all_landsat_bands_st,
        r=4, g=3, b=2,
        stretch="hist",
        main="Pre-fire RGB image with cloud\n Cold Springs Fire\n Fire boundary extent",
        axes=T,
        ext=extent(fire_boundary_utm))
# turn the box to white so there is no border on our plot
box(col="white")
plot(fire_boundary_utm, add=T)
```

<img src="{{ site.url }}/images/rfigs/course-materials/earth-analytics/week-7/how-to/2016-12-06-howto04-adjust-plot-extent-R/plot-with-boundary-1.png" title="Plot with the fire boundary" alt="Plot with the fire boundary" width="100%" />
