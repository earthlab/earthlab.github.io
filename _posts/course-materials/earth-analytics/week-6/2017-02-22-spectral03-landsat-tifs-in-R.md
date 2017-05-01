---
layout: single
title: "Landsat tif files in R"
excerpt: "In this lesson we will cover the basics of using LAndsat 7 and 8 in R. We will learn how to import landsat data stored in .tif format - where each .tif file represents a single band rather than a stack of bands. Finally we will plot the data using various 3 band combinations including RGB and color-infrared."
authors: ['Leah Wasser']
modified: '2017-05-01'
category: [course-materials]
class-lesson: ['spectral-data-fire-r']
permalink: /course-materials/earth-analytics/week-6/landsat-bands-geotif-in-R/
nav-title: 'Landsat tifs in R'
week: 6
sidebar:
  nav:
author_profile: false
comments: true
order: 3
tags2:
  remote-sensing: ['landsat']
  earth-science: ['fire']
  scientific-programming: ['r']
  spatial-data-and-gis: ['raster-data']
lang-lib:
  r: []
---

{% include toc title="In This Lesson" icon="file-text" %}

<div class='notice--success' markdown="1">

## <i class="fa fa-graduation-cap" aria-hidden="true"></i> Learning Objectives

After completing this tutorial, you will be able to:

* Use `list.files()` to create a subsetted list of file names within a specified directory on your computer.
* Create a raster stack from a list of .tif files in R.
* Plot various band combinations using a rasterstack in R with `plotRGB()`.

## <i class="fa fa-check-square-o fa-2" aria-hidden="true"></i> What you need

You will need a computer with internet access to complete this lesson and the
data for week 6 of the course.

{% include/data_subsets/course_earth_analytics/_data-week6-7.md %}
</div>

In the previous lesson, we learned how to import a multi-band image into R using
the `stack()` function. We then plotted the data as a composite, RGB (and CIR) image
using `plotRGB()`. However, sometimes data are downloaded in individual bands rather
than a composite raster stack.

In this lesson we will learn how to work with Landsat data in `R`. In this case, our
data are downloaded in `.tif` format with each `.tif` file representing a single
band rather than a stack of bands.

## About Landsat data

> At over 40 years, the Landsat series of satellites provides the longest temporal record of moderate resolution multispectral data of the Earth’s surface on a global basis. The Landsat record has remained remarkably unbroken, proving a unique resource to assist a broad range of specialists in managing the world’s food, water, forests, and other natural resources for a growing world population.  It is a record unmatched in quality, detail, coverage, and value. Source: <a href="<a href="https://landsat.usgs.gov/about-landsat" target="_blank">USGS</a>



<figure>
    <a href="{{ site.url }}/images/course-materials/earth-analytics/week-6/TimelineOnlyForWebRGB.png">
    <img src="{{ site.url }}/images/course-materials/earth-analytics/week-6/TimelineOnlyForWebRGB.png" alt="Landsat 40 year timeline source: USGS.">
    </a>
    <figcaption>The 40 year history of landsat missions. Source: USGS - <a href="https://landsat.usgs.gov/landsat-missions-timeline
    </figcaption>
</figure>

Landsat data is a spectral dataset, collected from space. The spectral bands
and associated spatial resolution of the first 9 bands in the Landsat 8 sensor
are listed below.

#### Landsat 8 Bands

| Band | Wavelength range (nanometers) | Spatial Resolution (m) | Spectral Width (nm)|
|-------------------------------------|------------------|--------------------|----------------|
| Band 1 - Coastal aerosol | 430 - 450 | 30 | 2.0 |
| Band 2 - Blue | 450 - 510 | 30 | 6.0 |
| Band 3 - Green | 530 - 590 | 30 | 6.0 |
| Band 4 - Red | 640 - 670 | 30 | 0.03 |
| Band 5 - Near Infrared (NIR) | 850 - 880 | 30 | 3.0 |
| Band 6 - SWIR 1 | 1570 - 1650 | 30 | 8.0  |
| Band 7 - SWIR 2 | 2110 - 2290 | 30 | 18 |
| Band 8 - Panchromatic | 500 - 680 | 15 | 18 |
| Band 9 - Cirrus | 1360 - 1380 | 30 | 2.0 |

### Understanding landsat
When working with landsat, it is important to understand both the metadata and
the file naming convention. The metadata tell us about how the data were processed,
where the data are from and how they are structured.

The file names, tell us what sensor collected the data, the date the data were collected, and more.

<a href="<a href="https://landsat.usgs.gov/what-are-naming-conventions-landsat-scene-identifiers" target="_blank">Landsat file naming convention</a>

<figure>
    <a href="{{ site.url }}/images/course-materials/earth-analytics/week-6/Collection_FileNameDiffs.png">
    <img src="{{ site.url }}/images/course-materials/earth-analytics/week-6/Collection_FileNameDiffs.png" alt="landsat file naming convention">
    </a>
    <figcaption>Landsat file names Source: USGS Landsat - <a href="https://landsat.usgs.gov/what-are-naming-conventions-landsat-scene-identifiers
    </figcaption>
</figure>


Let's have a look at one of the files and use the image above to guide us through
underanding the file name.

File: `LC80340322016205LGN00_sr_band1_crop.tif`

| Sensor | Sensor | Satellite | WRS path | WRS row | | | | |
|-------|
| L | C | 8 | 034| 032| 2016 |205 | LGN | 00 |
| Landsat | OLI & TIRS | Landsat 8 | path = 034 | row = 032 | year = 2016 | Julian day= 205 | Ground station: LGN | Archive (first version): 00 |

* L: Landsat
* X: Sensor
  * C = OLI & TIRS
    O = OLI only
    T = IRS only
    E = ETM+
    T = TM
    M = MSS

* S Satelite
* PPP
* RRR
* YYYY = Year
* DDD = Julian DAY of the year
* GSI - Ground station ID
* VV = Archive Version

<a href="http://gisgeography.com/landsat-file-naming-convention/" target="_blank"> More here breaking down the file name.</a>

## Julian day

We won't spend a lot of time on Julian days. For the purpose of working with Landsat
and MODIS data, what you need to know that the calendar year Julian day represents
the numeric day of the year. So jan 1 = day 1. Feb 1 = day 32. And so on.

There are several links at the bottom of this page that provide tables that help
you <a href="<a href="https://landweb.modaps.eosdis.nasa.gov/browse/calendar.html" target="_blank">convert julian days to actual date</a>.


## Landsat tif files in R

Now that we understand how our file is named.


```r
# load spatial packages
library(raster)
library(rgdal)
library(rgeos)
# turn off factors
options(stringsAsFactors = F)
```

If we look at the directory that contains our landsat data, we will see that
each of the individual bands is stored individually as a geotiff rather than
being stored as a stacked or layered raster.

Why would they store the data this way?

Conventionally landsat was stored in a file format called HDF - hierarchical
data format. However that format, while extremely efficient, is a bit more
challenging to work with. In recent years USGS has started to make each band
of a landsat scene available as a .tif file. This makes it a bit easier to use
across many different programs and platforms.

We have already been working with the geotiff file format in this class! We
will thus use many of the same functions we used previously, to work with Landsat.

## Get list of files

To begin, let's explore our file directory in R, We can use `list.files()` to
grab a list of all files within any directory on our computer.


```r
# get list of all tifs
list.files("data/week6/landsat/LC80340322016205-SC20170127160728/crop")
##  [1] "LC80340322016205LGN00_bqa_crop.tif"        
##  [2] "LC80340322016205LGN00_cfmask_conf_crop.tif"
##  [3] "LC80340322016205LGN00_cfmask_crop.tif"     
##  [4] "LC80340322016205LGN00_sr_band1_crop.tif"   
##  [5] "LC80340322016205LGN00_sr_band2_crop.tif"   
##  [6] "LC80340322016205LGN00_sr_band3_crop.tif"   
##  [7] "LC80340322016205LGN00_sr_band4_crop.tif"   
##  [8] "LC80340322016205LGN00_sr_band5_crop.tif"   
##  [9] "LC80340322016205LGN00_sr_band6_crop.tif"   
## [10] "LC80340322016205LGN00_sr_band7_crop.tif"   
## [11] "LC80340322016205LGN00_sr_cloud_crop.tif"   
## [12] "LC80340322016205LGN00_sr_ipflag_crop.tif"
```

We can also use list.files with the pattern argument. This allows us to specify
a particular pattern that further subsets our data. In this case, we just want
to look at a list of files with the extention: `.tif`. Note that it is important
that the file **ends with** .tif. So we use the dollar sign at the end of our
pattern to tell R to only grab files that end with .tif.

`pattern=".tif$"`



```r
# but really we just want the tif files
all_landsat_bands <- list.files("data/week6/Landsat/LC80340322016205-SC20170127160728/crop",
                      pattern=".tif$",
                      full.names = T) # make sure we have the full path to the file
all_landsat_bands
##  [1] "data/week6/Landsat/LC80340322016205-SC20170127160728/crop/LC80340322016205LGN00_bqa_crop.tif"        
##  [2] "data/week6/Landsat/LC80340322016205-SC20170127160728/crop/LC80340322016205LGN00_cfmask_conf_crop.tif"
##  [3] "data/week6/Landsat/LC80340322016205-SC20170127160728/crop/LC80340322016205LGN00_cfmask_crop.tif"     
##  [4] "data/week6/Landsat/LC80340322016205-SC20170127160728/crop/LC80340322016205LGN00_sr_band1_crop.tif"   
##  [5] "data/week6/Landsat/LC80340322016205-SC20170127160728/crop/LC80340322016205LGN00_sr_band2_crop.tif"   
##  [6] "data/week6/Landsat/LC80340322016205-SC20170127160728/crop/LC80340322016205LGN00_sr_band3_crop.tif"   
##  [7] "data/week6/Landsat/LC80340322016205-SC20170127160728/crop/LC80340322016205LGN00_sr_band4_crop.tif"   
##  [8] "data/week6/Landsat/LC80340322016205-SC20170127160728/crop/LC80340322016205LGN00_sr_band5_crop.tif"   
##  [9] "data/week6/Landsat/LC80340322016205-SC20170127160728/crop/LC80340322016205LGN00_sr_band6_crop.tif"   
## [10] "data/week6/Landsat/LC80340322016205-SC20170127160728/crop/LC80340322016205LGN00_sr_band7_crop.tif"   
## [11] "data/week6/Landsat/LC80340322016205-SC20170127160728/crop/LC80340322016205LGN00_sr_cloud_crop.tif"   
## [12] "data/week6/Landsat/LC80340322016205-SC20170127160728/crop/LC80340322016205LGN00_sr_ipflag_crop.tif"
```

Above, we use the $ after .tif to tell R to look for files that end with .tif.
This is a good start but there is one more condition that we'd like to meet. We
only want the .tif files that are spectral bands. Notice that some of our files
have text that includes "mask", flags, etc. Those are all additional layers that
we don't need right now. We just need the spectral data saved in bands 1_7.

Thus, we want to grab all bands that both end with `.tif` AND contain the text
"band" in them. To do this we use the function `glob2rx()` which allows us to specify
both conditions. Here we tell R to select all files that have the word **band**
in the filename. We use a * sign before and after band because we don't know
exactly what text will occur before or after band. We use `.tif$` to tell R that
each file needs to end with .tif.



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
```

Now we have a list of all of the landsat bands in our folder. We could chose to
open each file individually using the `raster()` function.


```r
# get first file
all_landsat_bands[2]
## [1] "data/week6/Landsat/LC80340322016205-SC20170127160728/crop/LC80340322016205LGN00_sr_band2_crop.tif"
landsat_band2 <- raster(all_landsat_bands[2])
plot(landsat_band2,
     main="Landsat cropped band 2\nColdsprings fire scar",
     col=gray(0:100 / 100))
```

<img src="{{ site.url }}/images/rfigs/course-materials/earth-analytics/week-6/2017-02-22-spectral03-landsat-tifs-in-R/plot-landsat-band2-1.png" title="Landsat band 2 plot" alt="Landsat band 2 plot" width="100%" />

However, that is not a very efficient approach.
It's more efficiently to open all of the layers together as a stack. Then we can
access each of the bands and plot / use them as we want. We can do that using the
`stack()` function.


```r
# stack the data
landsat_stack_csf <- stack(all_landsat_bands)
# view stack attributes
landsat_stack_csf
## class       : RasterStack 
## dimensions  : 177, 246, 43542, 7  (nrow, ncol, ncell, nlayers)
## resolution  : 30, 30  (x, y)
## extent      : 455655, 463035, 4423155, 4428465  (xmin, xmax, ymin, ymax)
## coord. ref. : +proj=utm +zone=13 +datum=WGS84 +units=m +no_defs +ellps=WGS84 +towgs84=0,0,0 
## names       : LC8034032//band1_crop, LC8034032//band2_crop, LC8034032//band3_crop, LC8034032//band4_crop, LC8034032//band5_crop, LC8034032//band6_crop, LC8034032//band7_crop 
## min values  :                     0,                     0,                     0,                     0,                     0,                     0,                     0 
## max values  :                  3488,                  3843,                  4746,                  5152,                  5674,                  4346,                  3767
```

Let's plot each individual band in our stack.


```r
plot(landsat_stack_csf,
     col=gray(20:100 / 100))
```

<img src="{{ site.url }}/images/rfigs/course-materials/earth-analytics/week-6/2017-02-22-spectral03-landsat-tifs-in-R/plot-stack-1.png" title="plot individual landsat bands" alt="plot individual landsat bands" width="100%" />



```r
# get list of each layer name
names(landsat_stack_csf)
## [1] "LC80340322016205LGN00_sr_band1_crop"
## [2] "LC80340322016205LGN00_sr_band2_crop"
## [3] "LC80340322016205LGN00_sr_band3_crop"
## [4] "LC80340322016205LGN00_sr_band4_crop"
## [5] "LC80340322016205LGN00_sr_band5_crop"
## [6] "LC80340322016205LGN00_sr_band6_crop"
## [7] "LC80340322016205LGN00_sr_band7_crop"
# remove the filename from each band name for pretty plotting
names(landsat_stack_csf) <- gsub(pattern = "LC80340322016205LGN00_sr_", replacement = "", names(landsat_stack_csf))
plot(landsat_stack_csf,
     col=gray(20:100 / 100))
```

<img src="{{ site.url }}/images/rfigs/course-materials/earth-analytics/week-6/2017-02-22-spectral03-landsat-tifs-in-R/clean-upnames-1.png" title="plot individual landsat bands good names" alt="plot individual landsat bands good names" width="100%" />

## Plot RGB image

Next, let's plot an RGB image using landsat. Refer to the landsat bands in the table
at the top of this page to figure out the red, green and blue bands. Or read the
<a href="<a href="https://blogs.esri.com/esri/arcgis/2013/07/24/band-combinations-for-landsat-8/" target="_blank">ESRI landsat 8 band combinations</a> post.


```r
par(col.axis="white", col.lab="white", tck=0)
plotRGB(landsat_stack_csf,
     r=4, g=3, b=2,
     stretch="lin",
     axes=T,
     main="RGB composite image\n Landsat Bands 4, 3, 2")
box(col="white")
```

<img src="{{ site.url }}/images/rfigs/course-materials/earth-analytics/week-6/2017-02-22-spectral03-landsat-tifs-in-R/plot-rgb-1.png" title="plot rgb composite" alt="plot rgb composite" width="100%" />

Now we've created a red, green blue color composite image. Remember this is what
our eye would see. What happens if we plot the near infrared band instead of red?
Try the following combination:



```r
par(col.axis="white", col.lab="white", tck=0)
plotRGB(landsat_stack_csf,
     r=5, g=4, b=3,
     stretch="lin",
     axes=T,
     main="Color infrared composite image\n Landsat Bands 5, 4, 3")
box(col="white")
```

<img src="{{ site.url }}/images/rfigs/course-materials/earth-analytics/week-6/2017-02-22-spectral03-landsat-tifs-in-R/plot-cir-1.png" title="plot rgb composite" alt="plot rgb composite" width="100%" />


<div class="notice--warning" markdown="1">

## <i class="fa fa-pencil-square-o" aria-hidden="true"></i> optional challenge
Using the <a href="<a href="https://blogs.esri.com/esri/arcgis/2013/07/24/band-combinations-for-landsat-8/" target="_blank">ESRI landsat 8 band combinations</a> post as a guide. Plot the
following landsat band combinations:

* False color
* Color infrared
* Agriculture
* Healthy vegetation

Be sure to add a title to each of your plots that specifies the band combination.

</div>


<div class="notice--info" markdown="1">

## Additional resources

* <a href="<a href="https://disc.gsfc.nasa.gov/julian_calendar.html" target="_blank">Julian day lookup</a>
* <a href="<a href="https://landweb.modaps.eosdis.nasa.gov/browse/calendar.html" target="_blank">Landweb NASA Julian day lookup</a>

</div>
