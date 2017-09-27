---
layout: single
title: "Plot grid of spatial plots in R. "
excerpt: "In this lesson we cover using par() or parameter settings in R to plot several raster RGB plots in R in a grid. "
authors: ['Leah Wasser']
modified: '2017-09-18'
category: [courses]
class-lesson: ['how-to-hints-week7']
permalink: /courses/earth-analytics/week-7/grid-of-plots-report/
nav-title: 'Grid of plots'
week: 7
course: "earth-analytics"
sidebar:
  nav:
author_profile: false
comments: true
order: 3
topics:
  reproducible-science-and-programming:
  data-exploration-and-analysis: ['data-visualization']
  spatial-data-and-gis: ['raster-data']
lang-lib:
  r: []
---

{% include toc title="In This Lesson" icon="file-text" %}

<div class='notice--success' markdown="1">

## <i class="fa fa-graduation-cap" aria-hidden="true"></i> Learning Objectives

After completing this tutorial, you will be able to:

* Plot several plots using baseplot functions in a "grid" as one graphic in `R`

## <i class="fa fa-check-square-o fa-2" aria-hidden="true"></i> What you need

You will need a computer with internet access to complete this lesson and the
data for week 6/7 of the course.

{% include/data_subsets/course_earth_analytics/_data-week6-7.md %}
</div>



```r
# load libraries
library(raster)
library(rgeos)
library(rgdal)
```



```r
# import landsat data
all_landsat_bands <- list.files("data/week06/Landsat/LC80340322016189-SC20170128091153/crop",
           pattern=glob2rx("*band*.tif$"),
           full.names = T) # use the dollar sign at the end to get all files that END WITH

all_landsat_bands_st <- stack(all_landsat_bands)
## Error in x[[1]]: subscript out of bounds
```

### Creating a grid of plots

You can plot several plots together in the same window using baseplot. To do
this, we use the parameter value `mfrow=c(x,y)` where x is the number of rows
that you wish to have in your plot and y is the number of columns. When you plot,
R will place each plot, in order by row within the grid that you define using
`mfrow`.

Below, we have created a 2 by 2 grid of plots using `mfrow=c(2,2)` within
the `par()` function. In this example we have 2 rows and 2 columns.



```r
# adjust the parameters so the axes colors are white. Also turn off tick marks.
par(mfrow=c(2,2), col.axis="white", col.lab="white", tck=0)
# plot 1
plotRGB(all_landsat_bands_st,
        r=4,g=3,b=2,
        stretch="hist",
        main = "Plot 1 - RGB",
        axes=T)
## Error in plotRGB(all_landsat_bands_st, r = 4, g = 3, b = 2, stretch = "hist", : object 'all_landsat_bands_st' not found
box(col = "white") # turn all of the lines to white
## Error in box(col = "white"): plot.new has not been called yet

# plot 2
plotRGB(all_landsat_bands_st,
        r=5,g=4,b=3,
        stretch="hist",
        main = "Plot 2 - Color Infrared (CIR)",
        axes=T)
## Error in plotRGB(all_landsat_bands_st, r = 5, g = 4, b = 3, stretch = "hist", : object 'all_landsat_bands_st' not found
box(col = "white") # turn all of the lines to white
## Error in box(col = "white"): plot.new has not been called yet

# plot 3
plotRGB(all_landsat_bands_st,
        r=7,g=5,b=4,
        stretch="hist",
        main = "Plot 3 - Shortwave infrared",
        axes=T)
## Error in plotRGB(all_landsat_bands_st, r = 7, g = 5, b = 4, stretch = "hist", : object 'all_landsat_bands_st' not found
box(col = "white") # turn all of the lines to white
## Error in box(col = "white"): plot.new has not been called yet

# plot 4
plotRGB(all_landsat_bands_st,
        r=5,g=6,b=4,
        stretch="hist",
        main = "Plot 4 - Land / Water",
        axes=T)
## Error in plotRGB(all_landsat_bands_st, r = 5, g = 6, b = 4, stretch = "hist", : object 'all_landsat_bands_st' not found
# set bounding box to white as well
box(col = "white") # turn all of the lines to white
## Error in box(col = "white"): plot.new has not been called yet

# add overall title to your layout
title("My Title", outer=TRUE)
## Error in title("My Title", outer = TRUE): plot.new has not been called yet
```

Above, we added an overall title to our grid of plots using the `title()` function.
However the title is chopped of because there is not enough of a margin at the
top for it. We can adjust for this too using the `oma=` parameter argument. `oma`
sets the outside (o) margin (ma).

`oma=` argument in our `par()` function. Let's try it.



```r
# adjust the parameters so the axes colors are white. Also turn off tick marks.
par(mfrow=c(2,2), oma=c(0,0,2,0), col.axis="white", col.lab="white", tck=0)
# plot 1
plotRGB(all_landsat_bands_st,
        r=4,g=3,b=2,
        stretch="hist",
        main = "Plot 1 - RGB",
        axes=T)
## Error in plotRGB(all_landsat_bands_st, r = 4, g = 3, b = 2, stretch = "hist", : object 'all_landsat_bands_st' not found
box(col = "white") # turn all of the lines to white
## Error in box(col = "white"): plot.new has not been called yet

# plot 2
plotRGB(all_landsat_bands_st,
        r=5,g=4,b=3,
        stretch="hist",
        main = "Plot 2 - Color Infrared (CIR)",
        axes=T)
## Error in plotRGB(all_landsat_bands_st, r = 5, g = 4, b = 3, stretch = "hist", : object 'all_landsat_bands_st' not found
box(col = "white") # turn all of the lines to white
## Error in box(col = "white"): plot.new has not been called yet

# plot 3
plotRGB(all_landsat_bands_st,
        r=7,g=5,b=4,
        stretch="hist",
        main = "Plot 3 - Shortwave infrared",
        axes=T)
## Error in plotRGB(all_landsat_bands_st, r = 7, g = 5, b = 4, stretch = "hist", : object 'all_landsat_bands_st' not found
box(col = "white") # turn all of the lines to white
## Error in box(col = "white"): plot.new has not been called yet

# plot 4
plotRGB(all_landsat_bands_st,
        r=5,g=6,b=4,
        stretch="hist",
        main = "Plot 4 - Land / Water",
        axes=T)
## Error in plotRGB(all_landsat_bands_st, r = 5, g = 6, b = 4, stretch = "hist", : object 'all_landsat_bands_st' not found
# set bounding box to white as well
box(col = "white") # turn all of the lines to white
## Error in box(col = "white"): plot.new has not been called yet

# add overall title to your layout
title("My Title", outer=TRUE)
## Error in title("My Title", outer = TRUE): plot.new has not been called yet
```

When you are done with plotting in a grid space, be sure to reset your plot space
using `dev.off()`.



```r
dev.off()
```

Your homework this week should look something like this:


```
## Error in ogrListLayers(dsn = dsn): Cannot open data source
```



```
## Error in .rasterObjectFromFile(x, objecttype = "RasterBrick", ...): Cannot create a RasterLayer object from this file. (file does not exist)
## Error in x[[1]]: subscript out of bounds
## Error in plotRGB(all_landsat_bands_st, 5, 4, 3, stretch = "hist", main = "landsat CIR image", : object 'all_landsat_bands_st' not found
## Error in x[[1]]: subscript out of bounds
## Error in crs(all_modis_bands_st): object 'all_modis_bands_st' not found
## Error in plotRGB(all_modis_bands_st, r = 2, g = 4, b = 3, stretch = "lin", : object 'all_modis_bands_st' not found
## Error in plot(fire_boundary_sin, add = T): object 'fire_boundary_sin' not found
```

<img src="{{ site.url }}/images/rfigs/courses/earth-analytics/week07/how-to/2017-03-01-howto03-plot-grid-of-plots/plot-grid-naip-modis-landsat-1.png" title="grid of plots" alt="grid of plots" width="90%" />
