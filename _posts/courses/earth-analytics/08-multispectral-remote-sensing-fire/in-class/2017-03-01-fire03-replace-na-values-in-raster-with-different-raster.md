---
layout: single
title: "How to Replace Raster Cell Values with Values from A Different Raster Data Set in R"
excerpt: "Often data have missing or bad data values that you need to replace. Learn how to replace missing or bad data values in a raster, with values from another raster in the same pixel location using the cover function in R."
authors: ['Leah Wasser']
modified: '2018-01-10'
category: [courses]
class-lesson: ['spectral-data-fire-2-r']
permalink: /courses/earth-analytics/multispectral-remote-sensing-modis/replace-raster-cell-values-in-remote-sensing-images-in-r/
nav-title: 'Replace Raster Cell Values'
week: 8
course: "earth-analytics"
sidebar:
  nav:
author_profile: false
comments: true
order: 3
topics:
  remote-sensing: ['landsat']
  earth-science: ['fire']
  spatial-data-and-gis: ['raster-data']
  find-and-manage-data: ['missing-data-nan']
lang-lib:
  r: []
---


{% include toc title="In This Lesson" icon="file-text" %}

<div class='notice--success' markdown="1">

## <i class="fa fa-graduation-cap" aria-hidden="true"></i> Learning Objectives

After completing this tutorial, you will be able to:

* Use the cover funcution in R to replace missing or bad data values in a raster with values from another raster

## <i class="fa fa-check-square-o fa-2" aria-hidden="true"></i> What You Need

You will need a computer with internet access to complete this lesson and the
data for week 7 - 9 of the course.

{% include /data_subsets/course_earth_analytics/_data-week6-7.md %}

</div>


First, import the "cleaner" better Landsat data.
Convert it to a rasterbrick.


```r
# import data with less cloud cover
all_landsat_bands_pre_nocloud <- list.files("data/week-07/Landsat/LC80340322016173-SC20170227185411",
                                pattern = glob2rx("*band*.tif$"),
                                full.names = TRUE)
all_landsat_bands_pre_nocloud_st <- stack(all_landsat_bands_pre_nocloud)
all_landsat_bands_pre_nocloud_br <- stack(all_landsat_bands_pre_nocloud_st)
plotRGB(all_landsat_bands_pre_nocloud_br, 4,3,2,
        stretch = 'lin')
```

<img src="{{ site.url }}/images/rfigs/courses/earth-analytics/08-multispectral-remote-sensing-fire/in-class/2017-03-01-fire03-replace-na-values-in-raster-with-different-raster/import-cleaned-data-1.png" title="imagery with fewer clouds" alt="imagery with fewer clouds" width="90%" />



```r
# import the data with the clouds
# create a list of all landsat files that have the extension .tif and contain the word band.
all_landsat_bands_cloudy <- list.files("data/week-07/Landsat/LC80340322016189-SC20170128091153/crop",
           pattern = glob2rx("*band*.tif$"),
           full.names = TRUE) # use the dollar sign at the end to get all files that END WITH
# create spatial raster stack from the list of file names
all_landsat_bands_cloudy_st <- stack(all_landsat_bands_cloudy)
all_landsat_bands_cloudy_br <- brick(all_landsat_bands_cloudy_st)
plotRGB(all_landsat_bands_cloudy_br,
        4,3,2,
        stretch = "lin")
```

<img src="{{ site.url }}/images/rfigs/courses/earth-analytics/08-multispectral-remote-sensing-fire/in-class/2017-03-01-fire03-replace-na-values-in-raster-with-different-raster/unnamed-chunk-1-1.png" title="plot of chunk unnamed-chunk-1" alt="plot of chunk unnamed-chunk-1" width="90%" />

Apply the cloud mask to the cloudy data.


```r
# open cloud mask layer
cloud_mask_189 <- raster("data/week-07/Landsat/LC80340322016189-SC20170128091153/crop/LC80340322016189LGN00_cfmask_crop.tif")

cloud_mask_189[cloud_mask_189 > 0] <- NA

all_landsat_bands_mask <- mask(all_landsat_bands_cloudy_br,
                               mask = cloud_mask_189)
plotRGB(all_landsat_bands_mask,
        4, 3, 2,
        stretch = "lin")
```

<img src="{{ site.url }}/images/rfigs/courses/earth-analytics/08-multispectral-remote-sensing-fire/in-class/2017-03-01-fire03-replace-na-values-in-raster-with-different-raster/unnamed-chunk-2-1.png" title="plot of chunk unnamed-chunk-2" alt="plot of chunk unnamed-chunk-2" width="90%" />


Check to see if the rasters are in the same extent and CRS.


```r
compareRaster(all_landsat_bands_pre_nocloud_br, all_landsat_bands_mask)
## Error in compareRaster(all_landsat_bands_pre_nocloud_br, all_landsat_bands_mask): different extent
```

The extents are different, let's crop one to the other.



```r

all_landsat_bands_pre_nocloud_br <- crop(all_landsat_bands_pre_nocloud_br, extent(all_landsat_bands_cloudy_br))
# are they in the same extent now?
compareRaster(all_landsat_bands_pre_nocloud_br, all_landsat_bands_mask)
## [1] TRUE
```

Use the cover() function to replace each pixel that has an assigned NA value with
the pixel reflectance value in the same band in the other raster.


```r
# crop the data using the extend of the other raster
cleaned_raster <- cover(all_landsat_bands_mask, all_landsat_bands_pre_nocloud_br)
plotRGB(cleaned_raster, 4,3,2, stretch = 'lin')
```

<img src="{{ site.url }}/images/rfigs/courses/earth-analytics/08-multispectral-remote-sensing-fire/in-class/2017-03-01-fire03-replace-na-values-in-raster-with-different-raster/unnamed-chunk-5-1.png" title="plot of chunk unnamed-chunk-5" alt="plot of chunk unnamed-chunk-5" width="90%" />


Things are looking a bit better but still this image has issues:

1. There are edge effects associated with the mask that you can see.
2. Shadows weren't handled well with that mask.

You might have more processing to do to truly get this image cleaned up.

In this case, it could be better to use the other image in your analysis rather
than trying to clean up the cloud image.
