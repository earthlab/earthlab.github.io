---
layout: single
title: "Plot grid of plots in R. "
excerpt: " "
authors: ['Leah Wasser']
modified: '2017-03-01'
category: [course-materials]
class-lesson: ['how-to-hints-week7']
permalink: /course-materials/earth-analytics/week-7/grid-of-plots-report/
nav-title: 'Grid of plots'
week: 7
sidebar:
  nav:
author_profile: false
comments: true
order: 3
---

{% include toc title="In This Lesson" icon="file-text" %}

<div class='notice--success' markdown="1">

## <i class="fa fa-graduation-cap" aria-hidden="true"></i> Learning Objectives

After completing this tutorial, you will be able to:

* Add a variable to the markdown chunk in your .Rmd report.

## <i class="fa fa-check-square-o fa-2" aria-hidden="true"></i> What you need

You will need a computer with internet access to complete this lesson and the
data for week 6/7 of the course.

[<i class="fa fa-download" aria-hidden="true"></i> Download Week 6/7 Data (~500 MB)](https://ndownloader.figshare.com/files/7677208){:data-proofer-ignore='' .btn }
</div>



```r
# load libraries
library(raster)
library(rgeos)
library(rgdal)
```


```r
# import landsat data
all_landsat_bands <- list.files("data/week6/Landsat/LC80340322016189-SC20170128091153/crop",
           pattern=glob2rx("*band*.tif$"),
           full.names = T) # use the dollar sign at the end to get all files that END WITH

all_landsat_bands_st <- stack(all_landsat_bands)
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
        r=4,b=3,g=2,
        stretch="hist",
        main="Plot 1 - RGB",
        axes=T)
box(col="white") # turn all of the lines to white

# plot 2
plotRGB(all_landsat_bands_st,
        r=5,b=3,g=2,
        stretch="hist",
        main="Plot 2 - CIR",
        axes=T)
box(col="white") # turn all of the lines to white

# plot 3
plotRGB(all_landsat_bands_st,
        r=7,b=5,g=4,
        stretch="hist",
        main="Plot 3 - Shortwave infrared",
        axes=T)
box(col="white") # turn all of the lines to white

# plot 4
plotRGB(all_landsat_bands_st,
        r=5,b=6,g=4,
        stretch="hist",
        main="Plot 4 - Land / Water",
        axes=T)
# set bounding box to white as well
box(col="white") # turn all of the lines to white

# add overall title to your layout
title("My Title", outer=TRUE)
```

<img src="{{ site.url }}/images/rfigs/course-materials/earth-analytics/week-7/how-to/2016-12-06-howto03-plot-grid-of-plots/plot-rgb3-1.png" title="Create 2 x 2 grid of plots." alt="Create 2 x 2 grid of plots." width="100%" />

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
        r=4,b=3,g=2,
        stretch="hist",
        main="Plot 1 - RGB",
        axes=T)
box(col="white") # turn all of the lines to white

# plot 2
plotRGB(all_landsat_bands_st,
        r=5,b=3,g=2,
        stretch="hist",
        main="Plot 2 - CIR",
        axes=T)
box(col="white") # turn all of the lines to white

# plot 3
plotRGB(all_landsat_bands_st,
        r=7,b=5,g=4,
        stretch="hist",
        main="Plot 3 - Shortwave infrared",
        axes=T)
box(col="white") # turn all of the lines to white


# plot 4
plotRGB(all_landsat_bands_st,
        r=5,b=6,g=4,
        stretch="hist",
        main="Plot 4 - Land / Water",
        axes=T)
# set bounding box to white as well
box(col="white") # turn all of the lines to white

# add overall title to your layout
title("My Title", outer=TRUE)
```

<img src="{{ site.url }}/images/rfigs/course-materials/earth-analytics/week-7/how-to/2016-12-06-howto03-plot-grid-of-plots/plot-rgb4-1.png" title="Remove axes labels." alt="Remove axes labels." width="100%" />

When you are done with plotting in a grid space, be sure to reset your plot space
using `dev.off()`.


```r
dev.off()
```

Your homework this week should look something like this:




<img src="{{ site.url }}/images/rfigs/course-materials/earth-analytics/week-7/how-to/2016-12-06-howto03-plot-grid-of-plots/plot-grid-naip-modis-landsat-1.png" title="grid of plots" alt="grid of plots" width="100%" />
