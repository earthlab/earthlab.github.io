---
layout: single
title: "Adjust plot extent in R."
excerpt: "In this lesson you will review how to adjust the extent of a spatial plot in R using the ext() or extent argument and the extent of another layer. "
authors: ['Leah Wasser']
modified: '2018-01-10'
category: [courses]
class-lesson: ['how-to-hints-week8']
permalink: /courses/earth-analytics/multispectral-remote-sensing-modis/adjust-plot-extent-R/
nav-title: 'Adjust plot extent'
week: 8
course: "earth-analytics"
sidebar:
  nav:
author_profile: false
comments: true
order: 4
topics:
  reproducible-science-and-programming:
  data-exploration-and-analysis: ['data-visualization']
  spatial-data-and-gis: ['raster-data']
lang-lib:
  r: []
redirect_from:
  - "/courses/earth-analytics/week-7/adjust-plot-extent-R/"
---

{% include toc title="In This Lesson" icon="file-text" %}

<div class='notice--success' markdown="1">

## <i class="fa fa-graduation-cap" aria-hidden="true"></i> Learning Objectives

After completing this tutorial, you will be able to:

* Adjust the spatial extent of a plot using the `ext=` argument in R.

## <i class="fa fa-check-square-o fa-2" aria-hidden="true"></i> What you need

You will need a computer with internet access to complete this lesson and the
data for week 6 of the course.

[<i class="fa fa-download" aria-hidden="true"></i> Download Week 6 Data (~500 MB)](https://ndownloader.figshare.com/files/7677208){:data-proofer-ignore='' .btn }
</div>



## Review: What is an extent?

<figure>
    <a href="{{ site.url }}/images/courses/earth-analytics/spatial-data/spatial-extent.png">
    <img src="{{ site.url }}/images/courses/earth-analytics/spatial-data/spatial-extent.png" alt="Spatial extent ">
    </a>
    <figcaption>Spatial extent.
    </figcaption>
</figure>







```r
all_landsat_bands <- list.files("data/week-07/Landsat/LC80340322016189-SC20170128091153/crop",
           pattern = glob2rx("*band*.tif$"),
           full.names = TRUE) # use the dollar sign at the end to get all files that END WITH

all_landsat_bands_st <- stack(all_landsat_bands)

# turn the axis color to white and turn off ticks
par(col.axis = "white", col.lab = "white", tck = 0)
# plot the data - be sure to turn AXES to T (you just color them white)
plotRGB(all_landsat_bands_st,
        r = 4, g = 3, b = 2,
        stretch = "hist",
        main = "Pre-fire RGB image with cloud\n Cold Springs Fire",
        axes = TRUE)
# turn the box to white so there is no border on your plot
box(col = "white")
```

<img src="{{ site.url }}/images/rfigs/courses/earth-analytics/08-multispectral-remote-sensing-fire/how-to/2017-03-01-howto04-adjust-plot-extent-R/plot-landsat-1.png" title="landsat plot" alt="landsat plot" width="90%" />

## Adjust plot extent

You can adjust the extent of a plot using `ext` argument.
You can give the argument the spatial extent of the fire boundary
layer that you want to plot.

If your object is called fire_boundary_utm, then you'd code: `ext=extent(fire_boundary_utm)`



```r
# import fire overlay boundary
fire_boundary <- readOGR("data/week-07/vector_layers/fire-boundary-geomac/co_cold_springs_20160711_2200_dd83.shp")
## OGR data source with driver: ESRI Shapefile 
## Source: "data/week-07/vector_layers/fire-boundary-geomac/co_cold_springs_20160711_2200_dd83.shp", layer: "co_cold_springs_20160711_2200_dd83"
## with 1 features
## It has 21 fields
# reproject the data
fire_boundary_utm <- spTransform(fire_boundary, CRS = crs(all_landsat_bands_st))

# turn the axis color to white and turn off ticks
par(col.axis = "white", col.lab = "white", tck = 0)
# plot the data - be sure to turn AXES to T (you just color them white)
plotRGB(all_landsat_bands_st,
        r = 4, g = 3, b = 2,
        stretch = "hist",
        main = "Pre-fire RGB image with cloud\n Cold Springs Fire\n Fire boundary extent",
        axes = TRUE,
        ext = extent(fire_boundary_utm))
# turn the box to white so there is no border on your plot
box(col = "white")
plot(fire_boundary_utm, add = TRUE)
```

<img src="{{ site.url }}/images/rfigs/courses/earth-analytics/08-multispectral-remote-sensing-fire/how-to/2017-03-01-howto04-adjust-plot-extent-R/plot-with-boundary-1.png" title="Plot with the fire boundary" alt="Plot with the fire boundary" width="90%" />
