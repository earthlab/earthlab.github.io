---
layout: single
title: "Calculate and Plot Difference Normalized Burn Ratio (dNBR) from Landsat Remote Sensing Data in R"
excerpt: "In this lesson you review how to calculate difference normalized burn ratio using pre and post fire NBR rasters in R. You finally will classify the dNBR raster."
authors: ['Leah Wasser','Megan Cattau']
modified: '2018-07-30'
category: [courses]
class-lesson: ['spectral-data-fire-2-r']
permalink: /courses/earth-analytics/multispectral-remote-sensing-modis/calculate-dNBR-R-Landsat/
nav-title: 'dNBR With Landsat'
class-order: 3
week: 8
course: "earth-analytics"
sidebar:
  nav:
author_profile: false
comments: true
order: 5
topics:
  remote-sensing: ['landsat', 'modis']
  earth-science: ['fire']
  reproducible-science-and-programming:
  spatial-data-and-gis: ['raster-data']
lang-lib:
  r: []
redirect_from:
   - "/courses/earth-analytics/week-6/calculate-dNBR-R-Landsat/"
   - "/courses/earth-analytics/spectral-remote-sensing-landsat/calculate-dNBR-R-Landsat/"

---

{% include toc title="In This Lesson" icon="file-text" %}

<div class='notice--success' markdown="1">

## <i class="fa fa-graduation-cap" aria-hidden="true"></i> Learning Objectives

After completing this tutorial, you will be able to:

* Calculate `dNBR` in `R` with Landsat data.

## <i class="fa fa-check-square-o fa-2" aria-hidden="true"></i> What You Need

You will need a computer with internet access to complete this lesson and the
data for week 7 - 9 of the course.

{% include /data_subsets/course_earth_analytics/_data-week6-7.md %}
</div>

As discussed in the previous lesson, you can use dNBR to map the extent and
severity of a fire. In this lesson, you learn how to create NBR using
Landsat data.

You calculate dNBR using the following steps:

1. Open up pre-fire data and calculate *NBR*
2. Open up the post-fire data and calculate *NBR*
3. Calculate **dNBR** (difference NBR) by subtracting post-fire NBR from pre-fire NBR (NBR pre - NBR post fire).
4. Classify the dNBR raster using the classification table provided below and isn the previous lesson.

Note the code to do this is hidden. You will need to figure
out what bands are required to calculate NBR using Landsat.

## Calculate dNBR Using Landsat Data

First, let's setup your spatial packages.


```r
# load spatial packages
library(raster)
library(rgdal)
library(rgeos)
library(RColorBrewer)
library(dplyr)
# turn off factors
options(stringsAsFactors = FALSE)

# source the normalized diff function that you write for week_7
source("ea-course-functions.R")
```




Next, open up the pre- Cold Springs fire Landsat data. Create a rasterbrick from the bands. Then calculate NBR. A plot of NBR is below.


```r
all_landsat_bands_post <- list.files("data/week-07/Landsat/LC80340322016205-SC20170127160728/crop",
           pattern = glob2rx("*band*.tif$"),
           full.names = TRUE) # use the dollar sign at the end to get all files that END WITH
all_landsat_bands_post
## [1] "data/week-07/Landsat/LC80340322016205-SC20170127160728/crop/LC80340322016205LGN00_sr_band1_crop.tif"
## [2] "data/week-07/Landsat/LC80340322016205-SC20170127160728/crop/LC80340322016205LGN00_sr_band2_crop.tif"
## [3] "data/week-07/Landsat/LC80340322016205-SC20170127160728/crop/LC80340322016205LGN00_sr_band3_crop.tif"
## [4] "data/week-07/Landsat/LC80340322016205-SC20170127160728/crop/LC80340322016205LGN00_sr_band4_crop.tif"
## [5] "data/week-07/Landsat/LC80340322016205-SC20170127160728/crop/LC80340322016205LGN00_sr_band5_crop.tif"
## [6] "data/week-07/Landsat/LC80340322016205-SC20170127160728/crop/LC80340322016205LGN00_sr_band6_crop.tif"
## [7] "data/week-07/Landsat/LC80340322016205-SC20170127160728/crop/LC80340322016205LGN00_sr_band7_crop.tif"

# stack the data
landsat_post_st <- stack(all_landsat_bands_post)
landsat_post_br <- brick(landsat_post_st)
```





```r

# this code shows you how to create a normalized Z value for your raster plots!
# it also uses color brewer to color the output raster
# display.brewer.all()
nbr_colors <- colorRampPalette(brewer.pal(11, "PiYG"))(100)

plot(landsat_nbr_prefire,
     main = "Landsat derived NBR\n Pre-Fire \n with fire boundary overlay",
     axes = FALSE,
     box = FALSE,
     col = nbr_colors,
     zlim = c(-1, 1))
plot(fire_boundary_utm,
     add = TRUE)
```

<img src="{{ site.url }}/images/rfigs/courses/earth-analytics/08-multispectral-remote-sensing-fire/in-class/2017-03-01-fire05-calculate-NBR-with-landsat-R/nbr-pre-fire-1.png" title="Pre fire landsat derived NBR plot" alt="Pre fire landsat derived NBR plot" width="90%" />

You can export the NBR raster if you want using `writeRaster()`.


```r
check_create_dir("data/week-07/outputs/landsat_nbr")
writeRaster(x = landsat_nbr_prefire,
              filename="data/week-07/outputs/landsat_nbr",
              format = "GTiff", # save as a tif
              datatype='INT2S', # save as a INTEGER rather than a float
              overwrite = TRUE)
```


Next, open the post-fire landsat data to calculate post-fire NBR.
If you want to use the post-fire data to CROP the pre fire data you may do
this in a different order.



Then you calculate NBR on the post data - note the code here is purposefully hidden.
You need to figure out what bands to use to perform the math!


```r
# notice that the data are plotting using the same z limits to fix the color ramp
plot(landsat_nbr_postfire,
     main = "Landsat derived Normalized Burn Index (NBR)\n Post Fire",
     axes = FALSE,
     box = FALSE,
     col = nbr_colors,
    zlim = c(-1, 1))
plot(fire_boundary_utm,
     add = TRUE)
```

<img src="{{ site.url }}/images/rfigs/courses/earth-analytics/08-multispectral-remote-sensing-fire/in-class/2017-03-01-fire05-calculate-NBR-with-landsat-R/calculate-nbr-post-1.png" title="landsat derived NBR post fire" alt="landsat derived NBR post fire" width="90%" />

Finally, calculate the DIFFERENCE between the pre and post NBR.


```r
# calculate difference
landsat_nbr_diff <- landsat_nbr_prefire - landsat_nbr_postfire
plot(landsat_nbr_diff,
     main = "Difference NBR map \n Pre minus post Cold Springs fire",
     axes = FALSE, box = FALSE)
```

<img src="{{ site.url }}/images/rfigs/courses/earth-analytics/08-multispectral-remote-sensing-fire/in-class/2017-03-01-fire05-calculate-NBR-with-landsat-R/unnamed-chunk-2-1.png" title="Difference NBR map" alt="Difference NBR map" width="90%" />

When you have calculated dNBR or the difference in NBR pre minus post fire,
classify the output raster using the `classify()` function and the classes below.
You learned how to classify rasters in the [Earth Analytics lidar lessons]({{ site.url }}/courses/earth-analytics/lidar-raster-data-r/classify-raster/)

| SEVERITY LEVEL  | | dNBR RANGE |
|------------------------------|
| Enhanced Regrowth | | > -.1 |
| Unburned       |  | -.1 to +.1 |
| Low Severity     | | +.1 to +.27 |
| Moderate Severity  | | +.27 to +.66 |
| High Severity     |  |  > +1.3 |

NOTE: your min an max values for NBR may be slightly different from the table
shown above! If you have a smaller min value (< -700) then adjust your first class
to that smallest number. If you have a largest max value (>1300) then adjust
your last class to that largest value in your data.

Alternatively, you can use the `Inf` to specify the smallest `-Inf` and largest
`Inf` values.




You classified map should look something like:

<img src="{{ site.url }}/images/rfigs/courses/earth-analytics/08-multispectral-remote-sensing-fire/in-class/2017-03-01-fire05-calculate-NBR-with-landsat-R/classify-output-plot-1.png" title="classified NBR output" alt="classified NBR output" width="90%" />

## Compare to Fire Boundary

As an example to see how your fire boundary relates to the boundary that you've
identified using MODIS data, you can create a map with both layers. I'm using
the shapefile in the folder:

`data/week-07/vector_layers/fire-boundary-geomac/co_cold_springs_20160711_2200_dd83.shp`

Add fire boundary to map. Note the "Spectral" colorbrewer ramp is used in the map
below.

<img src="{{ site.url }}/images/rfigs/courses/earth-analytics/08-multispectral-remote-sensing-fire/in-class/2017-03-01-fire05-calculate-NBR-with-landsat-R/classify-output-plot2-1.png" title="classified NBR output" alt="classified NBR output" width="90%" />




Make it look a bit nicer using a colorbrewer palette. I used the
`RdYlGn` palette:

`brewer.pal(5, 'RdYlGn')`


<img src="{{ site.url }}/images/rfigs/courses/earth-analytics/08-multispectral-remote-sensing-fire/in-class/2017-03-01-fire05-calculate-NBR-with-landsat-R/classify-output-plot3-1.png" title="classified NBR output" alt="classified NBR output" width="90%" />

Note that you will have to figure out what date these data are for! I purposefully
didn't include it in the title of this map.



Add labels to your barplot!


```r
barplot(nbr_classified,
        main = "Distribution of Classified NBR Values",
        col = the_colors,
        names.arg = c("Enhanced \nRegrowth", "Unburned", "Low \n Severity", "Moderate \n Severity", "High \nSeverity"))
```

<img src="{{ site.url }}/images/rfigs/courses/earth-analytics/08-multispectral-remote-sensing-fire/in-class/2017-03-01-fire05-calculate-NBR-with-landsat-R/view-barplot1-1.png" title="plot barplot of fire severity values with labels" alt="plot barplot of fire severity values with labels" width="90%" />

## Calculate Total Area of Burned Area

Once you have classified your data, you can calculate the total burn area.

To calculate this you could either

1. use the `extract()` function to extract pixels within the burn area boundary
2. `crop()` the data to the burn area boundary extent. This is an ok option however you have pixels represented that are outside of the burn boundary.



```r
landsat_pixels_in_fire_boundary <- raster::extract(nbr_classified, fire_boundary_utm,
                                           df = TRUE)

landsat_pixels_in_fire_boundary %>%
  group_by(layer) %>%
  summarize(count = n(), area_meters = n() * (30 * 30))
```




<div class="notice--info" markdown="1">

## Additional Resources

* <a href="http://gsp.humboldt.edu/olm_2015/Courses/GSP_216_Online/lesson5-1/NBR.html" target="_blank">Humboldt GSP Course online NBR lesson</a>

</div>
