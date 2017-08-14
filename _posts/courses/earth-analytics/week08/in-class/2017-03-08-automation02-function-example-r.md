---
layout: single
title: "An example of creating modular code in R - Efficient scientific programming"
excerpt: "This lesson provides an example of modularizing code in R. "
authors: ['Max Joseph', 'Software Carpentry', 'Leah Wasser']
modified: '2017-08-14'
category: [course-materials]
class-lesson: ['automating-your-science-r']
permalink: /courses/earth-analytics/week-8/function-example-modular-code-r/
nav-title: 'Applying functions'
week: 8
course: "earth-analytics"
sidebar:
  nav:
author_profile: false
comments: true
topics:
  reproducible-science-and-programming: ['literate-expressive-programming', 'functions']
order: 2
---


{% include toc title="In This Lesson" icon="file-text" %}

<div class='notice--success' markdown="1">

## <i class="fa fa-graduation-cap" aria-hidden="true"></i> Learning Objectives

After completing this tutorial, you will be able to:

* Describe how functions can make your code easier to read / follow

## <i class="fa fa-check-square-o fa-2" aria-hidden="true"></i> What you need

You will need a computer with internet access to complete this lesson and the
data that we already downloaded for week 6 of the course.

{% include/data_subsets/course_earth_analytics/_data-week6-7.md %}
</div>



```r

# set working dir
setwd("~/Documents/earth-analytics")

# load spatial packages
library(raster)
library(rgdal)
# turn off factors
options(stringsAsFactors = F)
```



```r
# get list of tif files
all_landsat_bands <- list.files("data/week6/Landsat/LC80340322016189-SC20170128091153/crop",
                                pattern=glob2rx("*band*.tif$"),
                                full.names = T)

# stack the data (create spatial object)
landsat_stack_csf <- stack(all_landsat_bands)

par(col.axis="white", col.lab="white", tck=0)
# plot brick
plotRGB(landsat_stack_csf,
  r=4,g=3, b=2,
  main="RGB Landsat Stack \n pre-fire",
  axes=T,
  stretch="hist")
box(col="white") # turn all of the lines to white
```

<img src="{{ site.url }}/images/rfigs/courses/earth-analytics/week08/in-class/2017-03-08-automation02-function-example-r/plot-landsat-first, -1.png" title="landsat pre fire raster stack plot" alt="landsat pre fire raster stack plot" width="100%" />



```r

# we can do the same things with functions
get_stack_bands <- function(the_dir_path, the_pattern){
  # get list of tif files
  all_landsat_bands <- list.files(the_dir_path,
                                pattern=glob2rx(the_pattern),
                                full.names = T)

  # stack the data (create spatial object)
  landsat_stack_csf <- stack(all_landsat_bands)
  return(landsat_stack_csf)

}

```


# Example using functions

Here's we've reduced the code by a few lines using a get bands function. Then we
can plot like we did before.


```r
landsat_pre_fire <- get_stack_bands(the_dir_path = "data/week6/Landsat/LC80340322016189-SC20170128091153/crop",
                the_pattern = "*band*.tif$")

par(col.axis="white", col.lab="white", tck=0)
# plot brick
plotRGB(landsat_pre_fire,
  r=4,g=3, b=2,
  main="RGB Landsat Stack \n pre-fire",
  axes=T,
  stretch="lin")
box(col="white") # turn all of the lines to white
```

<img src="{{ site.url }}/images/rfigs/courses/earth-analytics/week08/in-class/2017-03-08-automation02-function-example-r/plot-landsat-pre-1.png" title="landsat pre fire raster stack plot" alt="landsat pre fire raster stack plot" width="100%" />


Now, what if we created a function that adjusted
all of the parameters that we wanted to set to plot an RGB image? Here we
will require the user to send the function a stack with the bands in the order
that they want to plot the data.


```r
create_rgb_plot <-function(a_raster_stack, the_plot_title, r=3, g=2, b=1, the_stretch=NULL){
  # this function plots an RGB image with a title
  # it sets the plot border and box to white
  # Inputs a_raster_stack - a given raster stack with multiple spectral bands
  # the_plot_title - teh title of the plot - text string format in quotes
  # red, green, blue - the numeric index location of the bands that you want
  #  to plot on the red, green and blue channels respectively
  # the_stretch -- defaults to NULL - can take "hist" or "lin" as an option
  par(col.axis="white", col.lab="white", tck=0)
  # plot brick
  plotRGB(a_raster_stack,
    main=the_plot_title,
    r=r, g=g, b=b,
    axes=T,
    stretch=the_stretch)
  box(col="white") # turn all of the lines to white
}
```

Let's use the code to plot pre-fire RGB image.


```r
landsat_pre_fire <- get_stack_bands(the_dir_path = "data/week6/Landsat/LC80340322016189-SC20170128091153/crop",
                the_pattern = "*band*.tif$")

# plot the data
create_rgb_plot(a_raster_stack = landsat_pre_fire,
                r=4, g = 3, b=2,
                the_plot_title = "RGB image",
                the_stretch="hist")
```

<img src="{{ site.url }}/images/rfigs/courses/earth-analytics/week08/in-class/2017-03-08-automation02-function-example-r/plot-rgb-function-1.png" title="raster stack plot - rgb" alt="raster stack plot - rgb" width="100%" />

Once our plot parameters are setup, we can use the same code to plot our data
over and over without having to set parameters each time!

Now we can plot a CIR fire image with one function!


```r
# plot the data
create_rgb_plot(a_raster_stack = landsat_pre_fire,
                r=5, g = 4, b = 3,
                the_plot_title = "RGB image",
                the_stretch="hist")
```

<img src="{{ site.url }}/images/rfigs/courses/earth-analytics/week08/in-class/2017-03-08-automation02-function-example-r/plot-one-cir-1.png" title="pre-fire cir image" alt="pre-fire cir image" width="100%" />

Let's run the same functions on another landsat dataset  - post fire.


```r
# create stack
landsat_post_fire <- get_stack_bands(the_dir_path = "data/week6/Landsat/LC80340322016205-SC20170127160728/crop",
                the_pattern = "*band*.tif$")

# plot the 3 band image of the data
create_rgb_plot(a_raster_stack = landsat_post_fire,
                r=4, g = 3, b=2,
                the_plot_title = "RGB image",
                the_stretch="hist")
```

<img src="{{ site.url }}/images/rfigs/courses/earth-analytics/week08/in-class/2017-03-08-automation02-function-example-r/plot-landsat-post-1.png" title="landsat post fire raster stack plot" alt="landsat post fire raster stack plot" width="100%" />

What if we want to plot a CIR image post fire?


```r
# plot the 3 band image of the data
create_rgb_plot(a_raster_stack = landsat_post_fire,
                r=5, g = 4, b = 3,
                the_plot_title = "Landsat post fire CIR image",
                the_stretch="hist")
```

<img src="{{ site.url }}/images/rfigs/courses/earth-analytics/week08/in-class/2017-03-08-automation02-function-example-r/plot-landsat-post-CIR-1.png" title="landsat CIR post fire raster stack plot" alt="landsat CIR post fire raster stack plot" width="100%" />

Are our functions general enough to work with MODIS?


```r
# import MODIS
modis_pre_fire <- get_stack_bands(the_dir_path = "data/week6/modis/reflectance/07_july_2016/crop",
                the_pattern = "*sur_refl*.tif$")

# plot the data
create_rgb_plot(a_raster_stack = modis_pre_fire,
                r=1, g = 4, b=3,
                the_plot_title = "MODIS RGB image",
                the_stretch="hist")
```

<img src="{{ site.url }}/images/rfigs/courses/earth-analytics/week08/in-class/2017-03-08-automation02-function-example-r/plot-modis-1.png" title="pre-fire rgb image MODIS" alt="pre-fire rgb image MODIS" width="100%" />

Looks like it works!
