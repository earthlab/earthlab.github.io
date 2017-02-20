---
layout: single
title: "Working with multiple bands in R."
excerpt: ". "
authors: ['Leah Wasser']
modified: '2017-02-18'
category: [course-materials]
class-lesson: ['spectral-data-fire-r']
permalink: /course-materials/earth-analytics/week-6/use-landsat-raster-stacks-in-r/
nav-title: 'Rasterstacks in R.'
week: 6
sidebar:
  nav:
author_profile: false
comments: true
order: 2
---

{% include toc title="In This Lesson" icon="file-text" %}

<div class='notice--success' markdown="1">

## <i class="fa fa-graduation-cap" aria-hidden="true"></i> Learning Objectives

After completing this tutorial, you will be able to:


## <i class="fa fa-check-square-o fa-2" aria-hidden="true"></i> What you need

You will need a computer with internet access to complete this lesson and the data for week 6 of the course.
</div>





## About Raster Bands in R

In the previous weeks, we've worked with rasters derived from lidar remote sensing
instruments. These rasters consisted of one layer or band. In this lesson, we'll
learn how to work with rasters with multiple bands in `R`.



<figure>
    <a href="{{ site.url }}/images/course-materials/earth-analytics/week-6/single_multi_raster.png">
    <img src="{{ site.url }}/images/course-materials/earth-analytics/week-6/single_multi_raster.png">
    </a>
    <figcaption>A raster can contain one or more bands. We can use the
    raster function to import one single band from a single OR multi-band
    raster.  Source: Colin Williams, NEON.</figcaption>
</figure>

To work with multi-band rasters in `R`, we need to change how we import and plot
our data in several ways.

* To import multi band raster data we will use the `stack()` function.
* If our multi-band data are imagery that we wish to composite, we can use
`plotRGB()` (instead of `plot()`) to plot a 3 band raster image.

## About Multi-Band Imagery
One type of multi-band raster dataset that is familiar to many of us is a color
image. A basic color image consists of three bands: red, green, and blue. Each
band represents light reflected from the red, green or blue portions of the
electromagnetic spectrum. The pixel brightness for each band, when composited
creates the colors that we see in an image.

<figure>
    <a href="{{ site.url }}/images/course-materials/earth-analytics/week-6/RGBSTack_1.jpg">
    <img src="{{ site.url }}/images/course-materials/earth-analytics/week-6/RGBSTack_1.jpg"></a>
    <figcaption>A color image consists of 3 bands - red, green and blue. When
    rendered together in a GIS, or even a tool like Photoshop or any other
    image software, they create a color image.
	Source: National Ecological Observatory Network (NEON).
    </figcaption>
</figure>

We can plot each band of a multi-band image individually.

<i class="fa fa-star"></i> **Data Tip:** In many GIS applications, a single band
would render as a single image in grayscale. We will therefore use a grayscale
palette to render individual bands.
{: .notice }

## we should have a multi band image. maybe i'll create one from landsat. 

<img src="{{ site.url }}/images/rfigs/course-materials/earth-analytics/week-6/2016-12-06-spectral02-multi-band-landsat-data-R/demonstrate-RGB-Image-1.png" title=" " alt=" " width="100%" /><img src="{{ site.url }}/images/rfigs/course-materials/earth-analytics/week-6/2016-12-06-spectral02-multi-band-landsat-data-R/demonstrate-RGB-Image-2.png" title=" " alt=" " width="100%" /><img src="{{ site.url }}/images/rfigs/course-materials/earth-analytics/week-6/2016-12-06-spectral02-multi-band-landsat-data-R/demonstrate-RGB-Image-3.png" title=" " alt=" " width="100%" />

```
## [1] "rgb.1" "rgb.2" "rgb.3"
```

<img src="{{ site.url }}/images/rfigs/course-materials/earth-analytics/week-6/2016-12-06-spectral02-multi-band-landsat-data-R/demonstrate-RGB-Image-4.png" title=" " alt=" " width="100%" />

Or we can composite all three bands together to make a color image.

<img src="{{ site.url }}/images/rfigs/course-materials/earth-analytics/week-6/2016-12-06-spectral02-multi-band-landsat-data-R/plot-RGB-now-1.png" title=" " alt=" " width="100%" />


```r
dev.off()
## RStudioGD 
##         2
```

All rasters in a raster stack must have the same *extent*,
*CRS* and *resolution*.


## Other Types of Multi-band Raster Data

Multi-band raster data might also contain:

1. **Time series:** the same variable, over the same area, over time. 
2. **Multi or hyperspectral imagery:** image rasters that have 4 or more
(multi-spectral) or more than 10-15 (hyperspectral) bands. 

## Work with Landsat data in R  

Now, we have learned that basic concepts associated with a raster stack. We want 
to work with Landsat data to better understand our study site - which is the cold
springs fire scare in Colorado. 

Landsat has multiple bands - 

## which landsat are we using?? we need to figure that out. probably 7?

To work with multi-band raster data we will use the `raster` and `rgdal`
packages.


```r
# load spatial packages
library(raster)
library(rgdal)
```



```r

# Read in multi-band raster with raster function.
# Default is the first band only.
rgb_coldsprings_landsat <- raster("data/week6/Landsat/outputs/rgb.tif")

# create a grayscale color palette to use for the image.
grayscale_colors <- gray.colors(100,            # number of different color levels
                                start = 0.0,    # how black (0) to go
                                end = 1.0,      # how white (1) to go
                                gamma = 2.2,    # correction between how a digital
                                # camera sees the world and how human eyes see it
                                alpha = NULL)   #Null=colors are not transparent

# Plot band 1
plot(rgb_coldsprings_landsat,
     col=grayscale_colors,
     axes=FALSE,
     main="RGB Imagery - Band 1-Red\nNEON Harvard Forest Field Site")
```

<img src="{{ site.url }}/images/rfigs/course-materials/earth-analytics/week-6/2016-12-06-spectral02-multi-band-landsat-data-R/read-single-band-1.png" title=" " alt=" " width="100%" />

```r

# view attributes: Check out dimension, CRS, resolution, values attributes, and
# band.
rgb_coldsprings_landsat
## class       : RasterLayer 
## band        : 1  (of  3  bands)
## dimensions  : 177, 246, 43542  (nrow, ncol, ncell)
## resolution  : 30, 30  (x, y)
## extent      : 455655, 463035, 4423155, 4428465  (xmin, xmax, ymin, ymax)
## coord. ref. : +proj=utm +zone=13 +datum=WGS84 +units=m +no_defs +ellps=WGS84 +towgs84=0,0,0 
## data source : /Users/lewa8222/Documents/earth-analytics/data/week6/Landsat/outputs/rgb.tif 
## names       : rgb 
## values      : 0, 4746  (min, max)
```

Notice that when we look at the attributes of RGB_Band1, we see :

`band: 1  (of  3  bands)`

This is `R` telling us that this particular raster object has more bands (3)
associated with it.

<i class="fa fa-star"></i> **Data Tip:** The number of bands associated with a
raster object can also be determined using the `nbands` slot. Syntax is
`ObjectName@file@nbands`, or specifically for our file: `RGB_band1@file@nbands`.
{: .notice}

### Image Raster Data Values
Let's next examine the raster's min and max values. What is the value range?


```r
# view min value
minValue(rgb_coldsprings_landsat)
## [1] 0

# view max value
maxValue(rgb_coldsprings_landsat)
## [1] 4746
```

This raster contains values between 0 and 255. These values
represent degrees of brightness associated with the image band. In
the case of a RGB image (red, green and blue), band 1 is the red band. When
we plot the red band, larger numbers (towards 255) represent pixels with more
red in them (a strong red reflection). Smaller numbers (towards 0) represent
pixels with less red in them (less red was reflected). To
plot an RGB image, we mix red + green + blue values into one single color to
create a full color image - similar to the color image a digital camera creates.

### Import A Specific Band
We can use the `raster()` function to import specific bands in our raster object
by specifying which band we want with `band=N` (N represents the band number we
want to work with). To import the green band, we would use `band=2`.


```r
# Can specify which band we want to read in
rgb_band2 <- raster("data/week6/Landsat/outputs/rgb.tif",
             band = 2)

# plot band 2
plot(rgb_band2,
     col=grayscale_colors, # we already created this palette & can use it again
     axes=FALSE,
     main="RGB Imagery - Band 2 - Green\nCold Springs Fire Scar")
```

<img src="{{ site.url }}/images/rfigs/course-materials/earth-analytics/week-6/2016-12-06-spectral02-multi-band-landsat-data-R/read-specific-band-1.png" title=" " alt=" " width="100%" />

```r

# view attributes of band 2
rgb_band2
## class       : RasterLayer 
## band        : 2  (of  3  bands)
## dimensions  : 177, 246, 43542  (nrow, ncol, ncell)
## resolution  : 30, 30  (x, y)
## extent      : 455655, 463035, 4423155, 4428465  (xmin, xmax, ymin, ymax)
## coord. ref. : +proj=utm +zone=13 +datum=WGS84 +units=m +no_defs +ellps=WGS84 +towgs84=0,0,0 
## data source : /Users/lewa8222/Documents/earth-analytics/data/week6/Landsat/outputs/rgb.tif 
## names       : rgb 
## values      : 0, 3843  (min, max)
```

Notice that band 2 is the second of 3 bands `band: 2  (of  3  bands)`.

<div id="challenge" markdown="1">
## Challenge: Making Sense of Single Band Images
Compare the plots of band 1 (red) and band 2 (green). Is the forested area
darker or lighter in band 2 (the green band) compared to band 1 (the red band)?
</div>



## Raster Stacks in R
Next, we will work with all three image bands (red, green and blue) as an `R`
`RasterStack` object. We will then plot a 3-band composite, or full color,
image.

To bring in all bands of a multi-band raster, we use the`stack()` function.


```r

# Use stack function to read in all bands
rgb_stack_landsat <-
  stack("data/week6/Landsat/outputs/rgb.tif")

# view attributes of stack object
rgb_stack_landsat
## class       : RasterStack 
## dimensions  : 177, 246, 43542, 3  (nrow, ncol, ncell, nlayers)
## resolution  : 30, 30  (x, y)
## extent      : 455655, 463035, 4423155, 4428465  (xmin, xmax, ymin, ymax)
## coord. ref. : +proj=utm +zone=13 +datum=WGS84 +units=m +no_defs +ellps=WGS84 +towgs84=0,0,0 
## names       : rgb.1, rgb.2, rgb.3 
## min values  :     0,     0,     0 
## max values  :  4746,  3843,  3488
```

We can view the attributes of each band the stack using `rgb_stack_landsat@layers`.
Or we if we have hundreds of bands, we can specify which band we'd like to view
attributes for using an index value: `rgb_stack_landsat[[1]]`. We can also use the
 `plot()` and `hist()` functions on the `RasterStack` to plot and view the
 distribution of raster band values.


```r
# view raster attributes
rgb_stack_landsat@layers
## [[1]]
## class       : RasterLayer 
## band        : 1  (of  3  bands)
## dimensions  : 177, 246, 43542  (nrow, ncol, ncell)
## resolution  : 30, 30  (x, y)
## extent      : 455655, 463035, 4423155, 4428465  (xmin, xmax, ymin, ymax)
## coord. ref. : +proj=utm +zone=13 +datum=WGS84 +units=m +no_defs +ellps=WGS84 +towgs84=0,0,0 
## data source : /Users/lewa8222/Documents/earth-analytics/data/week6/Landsat/outputs/rgb.tif 
## names       : rgb.1 
## values      : 0, 4746  (min, max)
## 
## 
## [[2]]
## class       : RasterLayer 
## band        : 2  (of  3  bands)
## dimensions  : 177, 246, 43542  (nrow, ncol, ncell)
## resolution  : 30, 30  (x, y)
## extent      : 455655, 463035, 4423155, 4428465  (xmin, xmax, ymin, ymax)
## coord. ref. : +proj=utm +zone=13 +datum=WGS84 +units=m +no_defs +ellps=WGS84 +towgs84=0,0,0 
## data source : /Users/lewa8222/Documents/earth-analytics/data/week6/Landsat/outputs/rgb.tif 
## names       : rgb.2 
## values      : 0, 3843  (min, max)
## 
## 
## [[3]]
## class       : RasterLayer 
## band        : 3  (of  3  bands)
## dimensions  : 177, 246, 43542  (nrow, ncol, ncell)
## resolution  : 30, 30  (x, y)
## extent      : 455655, 463035, 4423155, 4428465  (xmin, xmax, ymin, ymax)
## coord. ref. : +proj=utm +zone=13 +datum=WGS84 +units=m +no_defs +ellps=WGS84 +towgs84=0,0,0 
## data source : /Users/lewa8222/Documents/earth-analytics/data/week6/Landsat/outputs/rgb.tif 
## names       : rgb.3 
## values      : 0, 3488  (min, max)

# view attributes for one band
rgb_stack_landsat[[1]]
## class       : RasterLayer 
## band        : 1  (of  3  bands)
## dimensions  : 177, 246, 43542  (nrow, ncol, ncell)
## resolution  : 30, 30  (x, y)
## extent      : 455655, 463035, 4423155, 4428465  (xmin, xmax, ymin, ymax)
## coord. ref. : +proj=utm +zone=13 +datum=WGS84 +units=m +no_defs +ellps=WGS84 +towgs84=0,0,0 
## data source : /Users/lewa8222/Documents/earth-analytics/data/week6/Landsat/outputs/rgb.tif 
## names       : rgb.1 
## values      : 0, 4746  (min, max)

# view histogram of all 3 bands
hist(rgb_stack_landsat,
     maxpixels=ncell(rgb_stack_landsat))

# plot all three bands separately
plot(rgb_stack_landsat,
     col=grayscale_colors)
```

<img src="{{ site.url }}/images/rfigs/course-materials/earth-analytics/week-6/2016-12-06-spectral02-multi-band-landsat-data-R/plot-raster-layers-1.png" title=" " alt=" " width="100%" /><img src="{{ site.url }}/images/rfigs/course-materials/earth-analytics/week-6/2016-12-06-spectral02-multi-band-landsat-data-R/plot-raster-layers-2.png" title=" " alt=" " width="100%" />

```r

# revert to a single plot layout
par(mfrow=c(1,1))

# plot band 2
plot(rgb_stack_landsat[[2]],
     main="Band 2\n NEON Harvard Forest Field Site",
     col=grayscale_colors)
```

<img src="{{ site.url }}/images/rfigs/course-materials/earth-analytics/week-6/2016-12-06-spectral02-multi-band-landsat-data-R/plot-raster-layers-3.png" title=" " alt=" " width="100%" />


### Create A Three Band Image
To render a final 3 band, color image in `R`, we use `plotRGB()`.

This function allows us to:

1. Identify what bands we want to render in the red, green and blue regions. The
`plotRGB()` function defaults to a 1=red, 2=green, and 3=blue band order. However,
you can define what bands you'd like to plot manually. Manual definition of
bands is useful if you have, for example a near-infrared band and want to create
a color infrared image.
2. Adjust the `stretch` of the image to increase or decrease contrast.

Let's plot our 3-band image.


```r

# Create an RGB image from the raster stack
plotRGB(rgb_stack_landsat,
        r = 1, g = 2, b = 3,
        stretch="lin")
```

<img src="{{ site.url }}/images/rfigs/course-materials/earth-analytics/week-6/2016-12-06-spectral02-multi-band-landsat-data-R/plot-rgb-image-1.png" title=" " alt=" " width="100%" />

The image above looks pretty good. We can explore whether applying a stretch to
the image might improve clarity and contrast using  `stretch="lin"` or
`stretch="hist"`.

<figure>
    <a href="{{ site.url }}/images/course-materials/earth-analytics/week-6/imageStretch_dark.jpg">
    <img src="{{ site.url }}/images/course-materials/earth-analytics/week-6/imageStretch_dark.jpg">
    </a>
    <figcaption>When the range of pixel brightness values is closer to 0, a
    darker image is rendered by default. We can stretch the values to extend to
    the full 0-255 range of potential values to increase the visual contrast of
    the image.
    </figcaption>
</figure>

<figure>
    <a href="{{ site.url }}/images/course-materials/earth-analytics/week-6/imageStretch_light.jpg">
    <img src="{{ site.url }}/images/course-materials/earth-analytics/week-6/imageStretch_light.jpg">
    </a>
    <figcaption>When the range of pixel brightness values is closer to 255, a
    lighter image is rendered by default. We can stretch the values to extend to
    the full 0-255 range of potential values to increase the visual contrast of
    the image.
    </figcaption>
</figure>


```r

# what does stretch do?
plotRGB(rgb_stack_landsat,
        r = 1, g = 2, b = 3,
        scale=800,
        stretch = "lin")
```

<img src="{{ site.url }}/images/rfigs/course-materials/earth-analytics/week-6/2016-12-06-spectral02-multi-band-landsat-data-R/image-stretch-1.png" title=" " alt=" " width="100%" />

```r

plotRGB(rgb_stack_landsat,
        r = 1, g = 2, b = 3,
        scale=800,
        stretch = "hist")
```

<img src="{{ site.url }}/images/rfigs/course-materials/earth-analytics/week-6/2016-12-06-spectral02-multi-band-landsat-data-R/image-stretch-2.png" title=" " alt=" " width="100%" />

In this case, the stretch doesn't enhance the contrast our image significantly
given the distribution of reflectance (or brightness) values is distributed well
between 0 and 255.

<div id="challenge" markdown="1">
## Challenge - NoData Values
Let's explore what happens with NoData values when using `RasterStack` and
`plotRGB`. We will use the `HARV_Ortho_wNA.tif` GeoTIFF in the
`NEON-DS-Airborne-Remote-Sensing/HARVRGB_Imagery/` directory.

1. View the files attributes. Are there `NoData` values assigned for this file?
2. If so, what is the `NoData` Value?
3. How many bands does it have?
4. Open the multi-band raster file in `R`.
5. Plot the object as a true color image.
6. What happened to the black edges in the data?
7. What does this tell us about the difference in the data structure between
`HARV_Ortho_wNA.tif` and `HARV_RGB_Ortho.tif` (`R` object `RGB_stack`). How can
you check?

Answer the questions above using the functions we have covered so far in this
tutorial.

</div>


```
## Error in .local(.Object, ...):
## Error in .rasterObjectFromFile(x, objecttype = "RasterBrick", ...): Cannot create a RasterLayer object from this file. (file does not exist)
## Error in plotRGB(HARV_NA, r = 1, g = 2, b = 3): object 'HARV_NA' not found
```

<i class="fa fa-star"></i> **Data Tip:** We can create a RasterStack from
several, individual single-band GeoTIFFs too. Check out:
[Raster Time Series Data in R]({{ site.baseurl }}/R/Raster-Times-Series-Data-In-R/)
for a tutorial on how to do this.
{: .notice}

## RasterStack vs RasterBrick in R

The `R` `RasterStack` and `RasterBrick` object types can both store multiple bands.
However, how they store each band is different. The bands in a `RasterStack` are
stored as links to raster data that is located somewhere on our computer. A
`RasterBrick` contains all of the objects stored within the actual `R` object.
In most cases, we can work with a `RasterBrick` in the same way we might work
with a `RasterStack`. However a `RasterBrick` is often more efficient and faster
to process - which is important when working with larger files.

* <a href="http://www.inside-r.org/packages/cran/raster/docs/brick" target="_blank">
More on Raster Bricks</a>

We can turn a `RasterStack` into a `RasterBrick` in `R` by using
`brick(StackName)`. Let's use the `object.size()` function to compare `stack`
and `brick` `R` objects.


```r

# view size of the RGB_stack object that contains our 3 band image
object.size(rgb_stack_landsat)
## 40456 bytes

# convert stack to a brick
RGB_brick_HARV <- brick(rgb_stack_landsat)

# view size of the brick
object.size(RGB_brick_HARV)
## 1057560 bytes
```

Notice that in the `RasterBrick`, all of the bands are stored within the actual
object. Thus, the `RasterBrick` object size is much larger than the
`RasterStack` object.

You use `plotRGB` to block a `RasterBrick` too.


```r
# plot brick
plotRGB(RGB_brick_HARV)
```

<img src="{{ site.url }}/images/rfigs/course-materials/earth-analytics/week-6/2016-12-06-spectral02-multi-band-landsat-data-R/plot-brick-1.png" title=" " alt=" " width="100%" />


<div id="challenge" markdown="1">
## Challenge: What Methods Can Be Used on an R Object?
We can view various methods available to call on an `R` object with
`methods(class=class(objectNameHere))`. Use this to figure out:

1. What methods can be used to call on the `rgb_stack_landsat` object?
2. What methods are available for a single band within `rgb_stack_landsat`?
3. Why do you think there is a difference?

</div>




### The end








</div>



<div class="notice--info" markdown="1">

## Additional resources


</div>
