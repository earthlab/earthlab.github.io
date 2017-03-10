---
layout: single
title: "dNBR with MODIS in R"
excerpt: ". "
authors: ['Megan Cattau', 'Leah Wasser']
modified: '2017-03-10'
category: [course-materials]
class-lesson: ['spectral-data-fire-r']
permalink: /course-materials/earth-analytics/week-6/calculate-dNBR-R-MODIS/
nav-title: 'dNBR with MODIS'
week: 6
sidebar:
  nav:
author_profile: false
comments: true
order: 6
---


{% include toc title="In This Lesson" icon="file-text" %}

<div class='notice--success' markdown="1">

## <i class="fa fa-graduation-cap" aria-hidden="true"></i> Learning Objectives

After completing this tutorial, you will be able to:

* Calculate `dNBR` in `R`
* Be able to describe how the `dNBR` index is used to quantify fire severity.

## <i class="fa fa-check-square-o fa-2" aria-hidden="true"></i> What you need

You will need a computer with internet access to complete this lesson and the
data for week 6 of the course.

[<i class="fa fa-download" aria-hidden="true"></i> Download Week 6 Data (~500 MB)](<a href="https://ndownloader.figshare.com/files/7677208){:data-proofer-ignore='' .btn }
</div>

As mentioned previously, we can use NBR to map the extent and severity of a fire.
Let's explore using MODIS data to calculate NBR. In the example below, we are using
the MODIS product **mod09GA** which we downloaded from Earth Explorer. This product
contains 7 bands including ones in the SWIR and NIR region of the spectrum which we
require to calculate NBR.


### NBR & MODIS

Similarly the table below shows the band ranges for the MODIS sensor. What bands
should we use to calculate NBR using MODIS?

| Band | Wavelength range (nm) | Spatial Resolution (m) | Spectral Width (nm)|
|-------------------------------------|------------------|--------------------|----------------|
| Band 1 - red | 620 - 670 | 250 | 2.0 |
| Band 2 - near infrared | 841 - 876 | 250 | 6.0 |
| Band 3 -  blue/green | 459 - 479 | 500 | 6.0 |
| Band 4 - green | 545 - 565 | 500 | 3.0 |
| Band 5 - near infrared  | 1230 – 1250 | 500 | 8.0  |
| Band 6 - mid-infrared | 1628 – 1652 | 500 | 18 |
| Band 7 - mid-infrared | 2105 - 2155 | 500 | 18 |




```r
# load spatial packages
library(raster)
library(rgdal)
library(rgeos)
library(RColorBrewer)
# turn off factors
options(stringsAsFactors = F)
```



```r
all_landsat_bands <- list.files("data/week6/Landsat/LC80340322016205-SC20170127160728/crop",
           pattern=glob2rx("*band*.tif$"),
           full.names = T) # use the dollar sign at the end to get all files that END WITH
all_landsat_bands
## [1] "data/week6/Landsat/LC80340322016205-SC20170127160728/crop/LC80340322016205LGN00_sr_band1_crop.tif"
## [2] "data/week6/Landsat/LC80340322016205-SC20170127160728/crop/LC80340322016205LGN00_sr_band2_crop.tif"
## [3] "data/week6/Landsat/LC80340322016205-SC20170127160728/crop/LC80340322016205LGN00_sr_band3_crop.tif"
## [4] "data/week6/Landsat/LC80340322016205-SC20170127160728/crop/LC80340322016205LGN00_sr_band4_crop.tif"
## [5] "data/week6/Landsat/LC80340322016205-SC20170127160728/crop/LC80340322016205LGN00_sr_band5_crop.tif"
## [6] "data/week6/Landsat/LC80340322016205-SC20170127160728/crop/LC80340322016205LGN00_sr_band6_crop.tif"
## [7] "data/week6/Landsat/LC80340322016205-SC20170127160728/crop/LC80340322016205LGN00_sr_band7_crop.tif"

# stack the data
landsat_stack_csf <- stack(all_landsat_bands)
```




<img src="{{ site.url }}/images/rfigs/course-materials/earth-analytics/week-6/2016-12-06-spectral06-calculate-NBR-with-MODIS-R/calculate-nbr-1.png" title="landsat derived NDVI plot" alt="landsat derived NDVI plot" width="100%" />

When you have calculated NBR - classify the output raster using the `classify()`
function and the classes below.

| SEVERITY LEVEL  | | dNBR RANGE |
|------------------------------|
| Enhanced Regrowth | | -700 to  -100 |
| Unburned       |  | -100 to +100 |
| Low Severity     | | +100 to +270 |
| Moderate Severity  | | +270 to +660 |
| High Severity     |  | +660 to +1300 |

NOTE: your min an max values for NBR may be slightly different from the table
shown above! If you have a smaller min value (< -700) then adjust your first class
to that smallest number. If you have a largest max value (>1300) then adjust
your last class to that largest value in your data.

Alternatively, you can set those values to NA if you think they are outside of
the valid range of NBR (in this case they are not).



You can export the rasters if you want.


```r
writeRaster(x = nbr_classified,
              filename="data/week6/outputs/nbr_classified.tif",
              format = "GTiff", # save as a tif
              datatype='INT2S', # save as a INTEGER rather than a float
              overwrite = T)

writeRaster(x = landsat_nbr,
              filename="data/week6/outputs/landsat_nbr",
              format = "GTiff", # save as a tif
              datatype='INT2S', # save as a INTEGER rather than a float
              overwrite = T)
```

Your classified map should look something like:

<img src="{{ site.url }}/images/rfigs/course-materials/earth-analytics/week-6/2016-12-06-spectral06-calculate-NBR-with-MODIS-R/classify-output-plot-1.png" title="classified NBR output" alt="classified NBR output" width="100%" />

## Compare to fire boundary

As an example to see how our fire boundary relates to the boundary that we've
identified using MODIS data, we can create a map with both layers. I'm using
the shapefile in the folder:

`data/week6/vector_layers/fire-boundary-geomac/co_cold_springs_20160711_2200_dd83.shp`

Add fire boundary to map.

<img src="{{ site.url }}/images/rfigs/course-materials/earth-analytics/week-6/2016-12-06-spectral06-calculate-NBR-with-MODIS-R/classify-output-plot2-1.png" title="classified NBR output" alt="classified NBR output" width="100%" />




Make it look a bit nicer using a colobrewer palette. I used the
`RdYlGn` palette:

`brewer.pal(5, 'RdYlGn')`

I also did a bit of legend trickery to get a box with a fill. There's probably
a better way to do this!


```r

legend(nbr_classified@extent@xmax-100, nbr_classified@extent@ymax,
       c("Enhanced Regrowth", "Unburned", "Low Severity", "Moderate Severity", "High Severity", "Fire boundary"),
       col=c(rev(the_colors), "black"),
       pch=c(15,15, 15, 15, 15,NA),
       lty = c(NA, NA, NA, NA, NA, 1),
       cex=.8,
       bty="n",
       pt.cex=c(1.75))
legend(nbr_classified@extent@xmax-100, nbr_classified@extent@ymax,
       c("Enhanced Regrowth", "Unburned", "Low Severity", "Moderate Severity", "High Severity", "Fire boundary"),
       col=c("black"),
       pch=c(22, 22, 22, 22, 22, NA),
       lty = c(NA, NA, NA, NA, NA, 1),
       cex=.8,
       bty="n",
       pt.cex=c(1.75))
```

<img src="{{ site.url }}/images/rfigs/course-materials/earth-analytics/week-6/2016-12-06-spectral06-calculate-NBR-with-MODIS-R/classify-output-plot3-1.png" title="classified NBR output" alt="classified NBR output" width="100%" />

Note that you will have to figure out what date these data are for! I purposefully
didn't include it in the title of this map.



<img src="{{ site.url }}/images/rfigs/course-materials/earth-analytics/week-6/2016-12-06-spectral06-calculate-NBR-with-MODIS-R/view-hist-1.png" title="plot hist" alt="plot hist" width="100%" />


<div class="notice--info" markdown="1">

## Additional Resources

* http://gsp.humboldt.edu/olm_2015/Courses/GSP_216_Online/lesson5-1/NBR.html

</div>
