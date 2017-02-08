---
layout: single
title: "Raster analysis workflow in R."
excerpt: "."
authors: ['Leah Wasser']
modified: '2017-02-08'
category: [course-materials]
class-lesson: ['week4-review-r']
permalink: /course-materials/earth-analytics/week-4/raster-analysis-workflow-r/
nav-title: 'Raster analysis in R'
week: 4
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

*

## <i class="fa fa-check-square-o fa-2" aria-hidden="true"></i> What you need

You will need a computer with internet access to complete this lesson and the data for week 4 of the course.

[<i class="fa fa-download" aria-hidden="true"></i> Download Week 4 Data (~500 MB)](https://ndownloader.figshare.com/files/7525363){:data-proofer-ignore='' .btn }

</div>

We can break our data analysis workflow into several steps as follows:

* *Data Processing:* load and "clean" the data. This may include cropping, dealing with NA values, etc
* *Data Exploration:* understand the range and distribution of values in your data. This may involve plotting histograms scatter plots, etc
* *More Data Processing & Analysis:* This may include the final data processing steps that you determined based upon the data exploration phase.
* Final data anslysis
* Presentation


```r
# load libraries
library(raster)
library(rgdal)

# set working directory
setwd("~/Documents/earth-analytics")
```

# try mapview


```r
# load data
pre_dtm <- raster("data/week3/BLDR_LeeHill/pre-flood/lidar/pre_DTM.tif")
pre_dsm <- raster("data/week3/BLDR_LeeHill/pre-flood/lidar/pre_DSM.tif")

post_dtm <- raster("data/week3/BLDR_LeeHill/post-flood/lidar/post_DTM.tif")
post_dsm <- raster("data/week3/BLDR_LeeHill/post-flood/lidar/post_DSM.tif")

# import crop extent
crop_ext <- readOGR("data/week3/BLDR_LeeHill", "clip-extent")
## OGR data source with driver: ESRI Shapefile 
## Source: "data/week3/BLDR_LeeHill", layer: "clip-extent"
## with 1 features
## It has 1 fields
## Integer64 fields read as strings:  id
```


```r
# calculate dtm difference
dtm_diff_uncropped <- post_dtm - pre_dtm
plot(dtm_diff_uncropped)
```

<img src="{{ site.url }}/images/rfigs/course-materials/earth-analytics/week-4/in-class/2016-12-06-review02-raster-analysis-workflow-R/diff-data-1.png" title=" " alt=" " width="100%" />

Next, crop the data.


```r
# crop the data
dtm_diff <- crop(dtm_diff_uncropped, crop_ext)
plot(dtm_diff,
     main="cropped data")
```

<img src="{{ site.url }}/images/rfigs/course-materials/earth-analytics/week-4/in-class/2016-12-06-review02-raster-analysis-workflow-R/crop-data-1.png" title="cropped data" alt="cropped data" width="100%" />

```r

# get a quick glimpse at some of the values for a particular "row"
# note there are a LOT of values in this raster so this won't print all values.
getValues(dtm_diff, row = 5)
##    [1]  0.049926758 -0.020019531 -0.109985352 -0.130004883 -0.020019531
##    [6] -0.209960938 -0.150024414 -0.050048828 -0.099975586 -0.099975586
##   [11] -0.010009766 -0.150024414 -0.250000000 -0.140014648 -0.040039062
##   [16] -0.020019531  0.140014648  0.089965820  0.229980469  0.200073242
##   [21]  0.050048828  0.239990234  0.339965820  0.219970703  0.050048828
##   [26]  0.089965820 -0.009887695 -0.140014648 -0.030029297  0.030029297
##   [31] -0.040039062  0.199951172  0.510009766  0.289916992 -0.020019531
##   [36] -0.090087891  0.019897461  0.090087891  0.130004883  0.020019531
##   [41] -0.060058594 -0.170043945 -0.050048828  0.020019531 -0.040039062
##   [46] -0.010009766 -0.140014648  0.000000000 -0.020019531 -0.229980469
##   [51] -0.010009766  0.030029297  0.099975586 -0.229980469 -0.090087891
##   [56]  0.140014648  0.220092773  0.140014648  0.079956055  0.080078125
##   [61]  0.070068359 -0.050048828 -0.180053711  0.040039062  0.330078125
##   [66]  0.170043945  0.149902344  0.089965820  0.080078125  0.269897461
##   [71]  0.069946289 -0.020019531 -0.060058594 -0.079956055 -0.079956055
##   [76] -0.179931641 -0.089965820  0.119995117  0.059936523 -0.019897461
##   [81] -0.010009766 -0.099975586  0.030029297 -0.130004883 -0.339965820
##   [86]  0.089965820 -0.010009766 -0.020019531  0.080078125 -0.119995117
##   [91] -0.090087891 -0.119995117  0.219970703  0.049926758  0.109985352
##   [96]  0.020019531 -0.080078125  0.090087891  0.099975586 -0.040039062
##  [101] -0.010009766  0.090087891  0.250000000  0.030029297 -0.020019531
##  [106] -0.030029297  0.089965820 -0.070068359  0.180053711 -0.010009766
##  [111] -0.010009766 -0.020019531 -0.160034180  0.119995117  0.069946289
##  [116] -0.030029297  0.130004883  0.219970703  0.010009766 -0.089965820
##  [121] -0.010009766 -0.140014648 -0.229980469 -0.270019531 -0.130004883
##  [126] -0.069946289  0.029907227 -0.090087891 -0.100097656  0.000000000
##  [131] -0.030029297  0.060058594  0.060058594  0.040039062  0.190063477
##  [136]  0.030029297 -0.040039062  0.000000000  0.060058594  0.119995117
##  [141]  0.030029297  0.179931641  0.050048828  0.020019531  0.060058594
##  [146] -0.030029297  0.049926758  0.130004883 -0.070068359  0.280029297
##  [151]  0.089965820  0.119995117  0.030029297 -0.079956055  0.119995117
##  [156]  0.140014648  0.689941406  0.929931641  0.849975586  0.689941406
##  [161]  0.069946289 -0.010009766 -0.410034180 -0.590087891 -0.229980469
##  [166] -0.099975586 -0.079956055  0.039916992 -0.349975586 -0.239990234
##  [171] -0.119995117 -0.280029297 -0.520019531 -0.199951172 -0.240112305
##  [176] -0.609985352 -0.070068359  0.270019531  0.179931641 -0.100097656
##  [181] -0.270019531 -0.449951172 -0.329956055 -0.330078125  0.189941406
##  [186] -0.199951172 -0.070068359 -0.150024414 -0.259887695 -0.359985352
##  [191] -0.319946289 -0.299926758 -0.189941406 -0.099975586 -0.429931641
##  [196] -0.500000000 -0.439941406 -0.219970703  0.190063477  0.160034180
##  [201] -0.109985352 -0.250000000 -0.090087891 -0.209960938  0.020019531
##  [206] -0.219970703 -0.059936523 -0.089965820 -0.079956055 -0.039916992
##  [211]  0.000000000 -0.070068359 -0.170043945 -0.059936523 -0.069946289
##  [216] -0.119995117 -0.109985352  0.000000000 -0.219970703 -0.140014648
##  [221] -0.050048828  0.270019531  0.159912109  0.199951172 -0.319946289
##  [226] -0.239990234 -0.079956055 -0.099975586 -0.069946289 -0.119995117
##  [231] -0.409912109 -0.380004883  0.119995117  0.229980469 -0.150024414
##  [236] -0.089965820 -0.059936523 -0.149902344  0.059936523  0.050048828
##  [241] -0.030029297 -0.109985352 -0.099975586  0.000000000 -0.069946289
##  [246] -0.080078125  0.060058594  0.010009766  0.199951172  0.219970703
##  [251]  0.050048828  0.010009766  0.020019531  0.010009766  0.030029297
##  [256] -0.160034180 -0.099975586 -0.050048828  0.140014648  0.230102539
##  [261] -0.089965820 -0.099975586 -0.090087891 -0.070068359 -0.010009766
##  [266]  0.040039062  0.000000000  0.020019531 -0.170043945  0.050048828
##  [271] -0.010009766  0.010009766  0.089965820 -0.069946289 -0.270019531
##  [276] -0.060058594 -0.030029297 -0.020019531 -0.270019531 -0.280029297
##  [281] -0.190063477 -0.150024414 -0.140014648 -0.099975586 -0.020019531
##  [286]  0.099975586 -0.020019531 -0.049926758 -0.159912109 -0.089965820
##  [291] -0.160034180  0.000000000  0.140014648  0.220092773 -0.050048828
##  [296]  0.010009766  0.109985352  0.070068359  0.030029297  0.070068359
##  [301]  0.140014648 -0.229980469 -0.460083008 -0.609985352 -0.279907227
##  [306]  0.010009766 -0.010009766 -0.029907227 -0.069946289  0.030029297
##  [311]  0.090087891 -0.170043945 -0.220092773 -0.220092773  0.059936523
##  [316] -0.359985352  0.339965820  0.210083008 -0.070068359  0.000000000
##  [321]  0.160034180  0.319946289  0.450073242  0.229980469 -0.099975586
##  [326] -0.119995117 -0.170043945  0.199951172  0.440063477  0.369995117
##  [331]  0.309936523  0.160034180  0.089965820  0.160034180 -0.150024414
##  [336]  0.050048828  0.029907227 -0.029907227 -0.079956055 -0.109985352
##  [341] -0.180053711 -0.119995117  0.029907227  0.139892578 -0.010009766
##  [346] -0.010009766  0.510009766  0.030029297  0.020019531  0.000000000
##  [351] -0.050048828 -0.069946289 -0.020019531 -0.050048828 -0.079956055
##  [356] -0.160034180 -0.119995117 -0.010009766 -0.089965820 -0.119995117
##  [361] -0.039916992 -0.089965820  0.020019531 -0.059936523 -0.060058594
##  [366] -0.079956055  0.020019531 -0.169921875  0.060058594  0.000000000
##  [371]  0.089965820 -0.159912109 -0.160034180 -0.130004883 -0.219970703
##  [376]  0.030029297 -0.109985352 -0.109985352 -0.049926758 -0.030029297
##  [381]  0.010009766 -0.030029297  0.020019531 -0.089965820 -0.060058594
##  [386]  0.049926758  0.089965820 -0.119995117 -0.030029297 -0.190063477
##  [391] -0.059936523 -0.039916992 -0.030029297 -0.059936523  0.040039062
##  [396] -0.030029297 -0.020019531  0.059936523  0.059936523  0.029907227
##  [401]  0.039916992  0.059936523  0.000000000  0.030029297 -0.030029297
##  [406]  0.000000000 -0.059936523 -0.059936523 -0.099975586 -0.079956055
##  [411]  0.010009766 -0.020019531 -0.089965820 -0.130004883 -0.070068359
##  [416] -0.119995117 -0.020019531 -0.069946289 -0.150024414 -0.140014648
##  [421] -0.059936523 -0.089965820 -0.099975586 -0.140014648  0.059936523
##  [426] -0.080078125 -0.090087891 -0.099975586 -0.049926758  0.010009766
##  [431]  0.020019531  0.179931641  0.000000000  0.000000000  0.040039062
##  [436] -0.040039062 -0.130004883 -0.089965820 -0.119995117 -0.219970703
##  [441] -0.069946289 -0.079956055 -0.160034180  0.020019531  0.079956055
##  [446]  0.020019531 -0.099975586 -0.069946289 -0.209960938  0.040039062
##  [451]  0.109985352  0.069946289 -0.119995117  0.130004883  0.359985352
##  [456]  0.439941406  0.010009766  0.010009766  0.030029297 -0.040039062
##  [461]  0.020019531 -0.010009766  0.030029297  0.079956055  0.109985352
##  [466]  0.060058594  0.040039062 -0.040039062 -0.049926758 -0.059936523
##  [471] -0.049926758 -0.020019531 -0.029907227 -0.009887695 -0.020019531
##  [476] -0.130004883 -0.050048828  0.079956055  0.069946289 -0.140014648
##  [481]  0.020019531 -0.020019531  0.020019531  0.219970703  0.359985352
##  [486]  0.430053711  0.520019531  0.630004883  0.540039062  0.190063477
##  [491]  0.250000000  0.000000000  0.010009766  0.010009766  0.119995117
##  [496]  0.020019531  0.109985352  0.319946289  0.010009766 -0.079956055
##  [501] -0.159912109 -0.189941406  0.059936523  0.050048828  0.079956055
##  [506] -0.079956055 -0.130004883 -0.070068359  0.079956055  0.119995117
##  [511]  0.019897461  0.049926758  0.109985352  0.050048828  0.089965820
##  [516]  0.150024414  0.039916992  0.010009766  0.040039062  0.210083008
##  [521] -0.059936523  0.229980469  0.059936523 -0.080078125 -0.049926758
##  [526]  0.140014648  0.070068359  0.069946289  0.010009766 -0.060058594
##  [531]  0.150024414 -0.089965820 -0.080078125  0.099975586  0.259887695
##  [536]  0.349975586  0.159912109  0.190063477  0.119995117 -0.019897461
##  [541]  0.069946289 -0.060058594 -0.160034180 -0.040039062  0.020019531
##  [546]  0.000000000  0.000000000 -0.040039062 -0.050048828  0.059936523
##  [551] -0.020019531  0.010009766  0.109985352 -0.059936523 -0.010009766
##  [556]  0.050048828  0.030029297  0.150024414  0.179931641 -0.099975586
##  [561]  0.049926758  0.270019531  0.039916992 -0.049926758  0.069946289
##  [566] -0.050048828  0.000000000 -0.109985352 -0.119995117 -0.060058594
##  [571]  0.000000000  0.020019531 -0.010009766 -0.250000000 -0.170043945
##  [576]  0.000000000 -0.040039062 -0.049926758 -0.100097656 -0.079956055
##  [581] -0.040039062  0.060058594  0.130004883  0.079956055 -0.020019531
##  [586] -0.040039062 -0.130004883 -0.069946289  0.089965820  0.010009766
##  [591]  0.150024414  0.000000000  0.109985352  0.050048828 -0.030029297
##  [596]  0.010009766  0.020019531  0.060058594 -0.119995117 -0.020019531
##  [601]  0.210083008  0.179931641  0.190063477  0.130004883  0.140014648
##  [606]  0.020019531  0.069946289 -0.110107422 -0.070068359  0.150024414
##  [611] -0.510009766  0.309936523  0.449951172  0.310058594  0.140014648
##  [616]  0.039916992 -0.030029297 -0.089965820 -0.150024414 -0.039916992
##  [621]  0.119995117  0.059936523 -0.140014648 -0.109985352 -0.220092773
##  [626] -0.119995117 -0.190063477 -0.209960938 -0.229980469 -0.239990234
##  [631] -0.209960938  0.099975586  0.080078125  0.029907227 -0.030029297
##  [636] -0.099975586 -0.150024414 -0.209960938 -0.260009766 -0.319946289
##  [641] -0.259887695 -0.269897461 -0.369995117 -0.169921875  0.000000000
##  [646]  0.030029297 -0.030029297  0.000000000  0.039916992 -0.010009766
##  [651] -0.030029297 -0.049926758 -0.069946289 -0.160034180 -0.130004883
##  [656] -0.099975586 -0.029907227 -0.170043945 -0.140014648 -0.400024414
##  [661]  0.159912109 -0.010009766  0.020019531 -0.040039062 -0.109985352
##  [666] -0.049926758  0.079956055  0.099975586  0.059936523  0.000000000
##  [671] -0.010009766 -0.020019531 -0.020019531  0.079956055  0.020019531
##  [676] -0.069946289 -0.049926758 -0.069946289 -0.010009766 -0.069946289
##  [681]  0.000000000  0.179931641  0.069946289 -0.099975586 -0.189941406
##  [686] -0.170043945 -0.069946289 -0.180053711 -0.130004883 -0.149902344
##  [691] -0.380004883 -0.369995117 -0.449951172 -0.160034180  0.070068359
##  [696]  0.189941406 -0.029907227 -0.060058594 -0.190063477 -0.229980469
##  [701] -0.089965820 -0.100097656 -0.080078125 -0.369995117 -0.189941406
##  [706] -0.049926758  0.250000000 -0.069946289 -0.210083008 -0.190063477
##  [711] -0.029907227  0.030029297  0.050048828 -0.190063477 -0.410034180
##  [716] -0.010009766  0.119995117 -0.019897461 -0.160034180 -0.179931641
##  [721] -0.150024414 -0.019897461 -0.059936523 -0.109985352 -0.040039062
##  [726] -0.190063477 -0.280029297 -0.189941406 -0.190063477 -0.109985352
##  [731] -0.099975586 -0.039916992 -0.039916992 -0.130004883 -0.209960938
##  [736] -0.199951172 -0.369995117 -0.099975586 -0.080078125 -0.020019531
##  [741] -0.229980469 -0.189941406 -0.099975586 -0.010009766  0.040039062
##  [746]  0.099975586  0.060058594  0.079956055 -0.309936523 -0.319946289
##  [751] -0.089965820 -0.150024414 -0.200073242 -0.280029297 -0.250000000
##  [756] -0.009887695 -0.030029297 -0.010009766 -0.079956055 -0.040039062
##  [761] -0.030029297 -0.060058594 -0.219970703 -0.089965820 -0.180053711
##  [766] -0.069946289 -0.120117188 -0.119995117 -0.030029297  0.010009766
##  [771] -0.099975586 -0.079956055 -0.119995117 -0.170043945 -0.069946289
##  [776] -0.060058594 -0.010009766  0.060058594  0.079956055  0.020019531
##  [781]  0.089965820  0.040039062 -0.130004883 -0.079956055 -0.099975586
##  [786] -0.109985352 -0.039916992  0.079956055  0.030029297 -0.130004883
##  [791] -0.349975586  0.010009766  0.280029297  0.279907227 -0.049926758
##  [796]  0.060058594 -0.039916992 -0.119995117 -0.109985352 -0.039916992
##  [801] -0.169921875 -0.179931641 -0.230102539 -0.010009766  0.109985352
##  [806]  0.039916992 -0.190063477 -0.090087891 -0.039916992  0.030029297
##  [811] -0.140014648 -0.209960938 -0.130004883  0.119995117  0.000000000
##  [816] -0.029907227 -0.070068359  0.020019531 -0.069946289 -0.130004883
##  [821] -0.119995117 -0.069946289 -0.060058594 -0.070068359 -0.040039062
##  [826] -0.230102539 -0.020019531  0.010009766 -0.040039062 -0.089965820
##  [831] -0.030029297  0.010009766 -0.019897461 -0.130004883  0.049926758
##  [836] -0.100097656  0.000000000  0.000000000  0.079956055  0.090087891
##  [841]  0.019897461  0.070068359  0.069946289  0.040039062  0.010009766
##  [846] -0.030029297  0.010009766 -0.029907227 -0.020019531 -0.079956055
##  [851] -0.039916992 -0.050048828 -0.010009766 -0.030029297 -0.049926758
##  [856] -0.020019531  0.010009766 -0.069946289 -0.100097656 -0.040039062
##  [861]  0.030029297  0.059936523 -0.049926758  0.010009766  0.059936523
##  [866] -0.039916992 -0.079956055 -0.170043945 -0.089965820 -0.050048828
##  [871] -0.010009766 -0.010009766  0.050048828  0.000000000 -0.190063477
##  [876] -0.170043945 -0.130004883 -0.060058594 -0.089965820 -0.039916992
##  [881] -0.029907227  0.079956055 -0.130004883 -0.380004883 -0.060058594
##  [886] -0.040039062  0.030029297  0.089965820  0.010009766  0.220092773
##  [891]  0.310058594  0.569946289  0.640014648  0.219970703  0.159912109
##  [896]  0.099975586 -0.040039062 -0.010009766  0.040039062 -0.010009766
##  [901]  0.020019531 -0.010009766  0.079956055  0.069946289  0.030029297
##  [906] -0.020019531  0.050048828  0.070068359  0.059936523  0.099975586
##  [911]  0.099975586  0.140014648  0.039916992  0.039916992 -0.010009766
##  [916]  0.030029297  0.139892578  0.080078125  0.059936523  0.130004883
##  [921]  0.039916992 -0.020019531  0.089965820  0.210083008  0.169921875
##  [926]  0.140014648  0.139892578  0.130004883  0.070068359  0.010009766
##  [931]  0.020019531  0.000000000  0.059936523 -0.010009766  0.019897461
##  [936]  0.040039062  0.039916992  0.040039062 -0.020019531  0.119995117
##  [941]  0.060058594  0.000000000  0.040039062  0.070068359 -0.030029297
##  [946] -0.019897461  0.019897461 -0.039916992  0.020019531  0.030029297
##  [951] -0.020019531 -0.069946289 -0.050048828  0.020019531  0.109985352
##  [956] -0.010009766 -0.160034180  0.070068359 -0.060058594 -0.180053711
##  [961] -0.030029297 -0.049926758 -0.030029297 -0.020019531 -0.020019531
##  [966] -0.109985352 -0.049926758  0.069946289 -0.060058594 -0.050048828
##  [971] -0.109985352 -0.069946289 -0.030029297  0.049926758 -0.040039062
##  [976]  0.069946289  0.049926758  0.019897461  0.020019531  0.050048828
##  [981] -0.049926758 -0.010009766 -0.060058594 -0.030029297 -0.049926758
##  [986] -0.090087891  0.020019531 -0.039916992 -0.040039062 -0.080078125
##  [991] -0.059936523  0.089965820  0.119995117  0.160034180 -0.040039062
##  [996] -0.050048828  0.010009766  0.010009766  0.000000000 -0.079956055
##  [ reached getOption("max.print") -- omitted 2490 entries ]

# view max data values
dtm_diff@data@max
## [1] 15.09998
dtm_diff@data@min
## [1] -10.53003
```



```r
# plot histogram of data
hist(dtm_diff,
     main="distribution of raster cell values in the data",
     xlab="Height (m)")
```

<img src="{{ site.url }}/images/rfigs/course-materials/earth-analytics/week-4/in-class/2016-12-06-review02-raster-analysis-workflow-R/plot-histogram-1.png" title="initial histogram" alt="initial histogram" width="100%" />


```r
hist(dtm_diff,
     xlim=c(-2,2),
     main="histogram \nzoomed in to -2-2 on the x axis",
     col="brown")
```

<img src="{{ site.url }}/images/rfigs/course-materials/earth-analytics/week-4/in-class/2016-12-06-review02-raster-analysis-workflow-R/plot-histogram-xlim-1.png" title="initial histogram w xlim to zoom in" alt="initial histogram w xlim to zoom in" width="100%" />

```r

# see how R is breaking up the data
histinfo <- hist(dtm_diff)
```

<img src="{{ site.url }}/images/rfigs/course-materials/earth-analytics/week-4/in-class/2016-12-06-review02-raster-analysis-workflow-R/plot-histogram-xlim-2.png" title="initial histogram w xlim to zoom in" alt="initial histogram w xlim to zoom in" width="100%" />

```r
histinfo
## $breaks
##  [1] -11 -10  -9  -8  -7  -6  -5  -4  -3  -2  -1   0   1   2   3   4   5
## [18]   6   7   8   9  10  11  12  13  14  15  16
## 
## $counts
##  [1]      15      21      65      85     191     306     990    2296
##  [9]    8934   39467 3380797 3522363   18939    3131     883     618
## [17]     524     172      63     111      23       2       2       1
## [25]       0       0       1
## 
## $density
##  [1] 2.148997e-06 3.008596e-06 9.312321e-06 1.217765e-05 2.736390e-05
##  [6] 4.383954e-05 1.418338e-04 3.289398e-04 1.279943e-03 5.654298e-03
## [11] 4.843549e-01 5.046365e-01 2.713324e-03 4.485673e-04 1.265043e-04
## [16] 8.853868e-05 7.507163e-05 2.464183e-05 9.025788e-06 1.590258e-05
## [21] 3.295129e-06 2.865330e-07 2.865330e-07 1.432665e-07 0.000000e+00
## [26] 0.000000e+00 1.432665e-07
## 
## $mids
##  [1] -10.5  -9.5  -8.5  -7.5  -6.5  -5.5  -4.5  -3.5  -2.5  -1.5  -0.5
## [12]   0.5   1.5   2.5   3.5   4.5   5.5   6.5   7.5   8.5   9.5  10.5
## [23]  11.5  12.5  13.5  14.5  15.5
## 
## $xname
## [1] "v"
## 
## $equidist
## [1] TRUE
## 
## attr(,"class")
## [1] "histogram"

# how many breaks does R use in the default histogram
length(histinfo$breaks)
## [1] 28

# summarize values in the data
summary(dtm_diff, na.rm=T)
##                layer
## Min.    -10.53002930
## 1st Qu.  -0.06994629
## Median    0.01000977
## 3rd Qu.   0.07995605
## Max.     15.09997559
## NA's      0.00000000
```

## Breaks

Above, we saw that we can see how R breaks up our data to create a histogram.
R, by default, creates 35 bins to plot a histogram of our raster data. We can increase the number of breaks or bins that the hist0gram uses with the
argument:

`breaks=number`

In the example below, I used a very large number - 500 so we can see the bins.


```r
# where are most of our values?
hist(dtm_diff,
     xlim=c(-2,2),
     breaks=500,
     main="histogram \nzoomed in to -2-2 on the x axis w more breaks")
```

<img src="{{ site.url }}/images/rfigs/course-materials/earth-analytics/week-4/in-class/2016-12-06-review02-raster-analysis-workflow-R/plot-histogram-breaks-1.png" title="initial histogram w xlim to zoom in and breaks" alt="initial histogram w xlim to zoom in and breaks" width="100%" />

### Histogram with custom breaks

We can create custom breaks or bins in a histogram too. To do this, we pass the same `breaks`
argument a vector of numbers that represent the range for each bin in our histogram.



```r
# We may want to explore breaks in our histogram before plotting our data
hist(dtm_diff,
     breaks=c(-20, -10, -3, -.5, .5, 3, 10, 50),
     main="Histogram with custom breaks",
     xlab="Height (m)",
     col="springgreen")
```

<img src="{{ site.url }}/images/rfigs/course-materials/earth-analytics/week-4/in-class/2016-12-06-review02-raster-analysis-workflow-R/plot-histogram-breaks2-1.png" title="histogram w custom breaks" alt="histogram w custom breaks" width="100%" />

Finally, let's plot the data using the breaks that we created for our histogram
above. We know that there is a high number of cells with a value between -1 and 1.
So let's consider that when we select the colors for our plot.


```r
# plot dtm difference with breaks
plot(dtm_diff,
     breaks=c(-20, -10, -3, -1, 1, 3, 10, 50),
     col=terrain.colors(7))
```

<img src="{{ site.url }}/images/rfigs/course-materials/earth-analytics/week-4/in-class/2016-12-06-review02-raster-analysis-workflow-R/plot-data-1.png" title="Plot difference dtm." alt="Plot difference dtm." width="100%" />

## Custom plot colors

Next, let's adjust the colors that we use to plot our raster. to do that we will
create a vector of colors, each or which will represent one of our numeric "bins"
of raster values.

This mimics a classified map - we are still exploring our data!


```r
# how many breaks do we have?
# NOTE: we will have one less break than the length of this vector
length(c(-20,-10,-3,-1, 1, 3, 10, 50))
## [1] 8
```

Set number of colors based upon how many breaks or bins we have in our data
above we have 8 numbers in our breaks vector. this translates to 7 bins each or which requires a unique color.


```r
# create a vector of colors - one for each "bin" of raster cells
new_colors <- c("palevioletred4", "palevioletred2", "palevioletred1", "ivory1",
                "seagreen1","seagreen2","seagreen4")

plot(dtm_diff,
     breaks=c(-20, -10, -3, -.5, .5, 3, 10, 50),
     col=new_colors,
     legend=F,
     main="Plot of DTM differences\n custom colors")

# make sure legend plots outside of the plot area
par(xpd=T)
# add the legend to the plot
legend(x=dtm_diff@extent@xmax, y=dtm_diff@extent@ymax, # legend location
       legend=c("-20 to -10", "-10 to -3",
                "-3 to -.5", "-.5 to .5",
                ".5 to 3", "3 to 10", "10 to 50"),
       fill=new_colors,
       bty="n",
       cex=.7)
```

<img src="{{ site.url }}/images/rfigs/course-materials/earth-analytics/week-4/in-class/2016-12-06-review02-raster-analysis-workflow-R/plot-with-unique-colors-1.png" title="Plot difference dtm with custom colors." alt="Plot difference dtm with custom colors." width="100%" />

## Crop and replot

We can zoom into a part of the raster manually - by first cropping the data
using a manually created plot extent. Then plotting the newly cropped raster subset.


```r

# new_extent <- drawExtent()
new_extent <- extent(473690, 474155.2, 4434849, 4435204)
new_extent
## class       : Extent 
## xmin        : 473690 
## xmax        : 474155.2 
## ymin        : 4434849 
## ymax        : 4435204
# crop the raster to a smaller area
dtm_diff_crop <- crop(dtm_diff, new_extent)

# Plot the cropped raster
plot(dtm_diff_crop,
     breaks=c(-20, -10, -3, -1, 1, 3, 10, 50),
     col=new_colors,
     legend=F,
     main="Lidar DTM Difference \n cropped subset")

# grab the upper right hand corner coordinates to place the legend.
legendx <- dtm_diff_crop@extent@xmax
legendy <- dtm_diff_crop@extent@ymax

par(xpd=TRUE)
legend(legendx+100, legendy,
       legend=c("-20 to -10", "-10 to -3",
                "-1 to 1", "1 to 3", "3 to 10", "10 to 50"),
       fill=new_colors,
       bty="n",
       cex=.8)
```

<img src="{{ site.url }}/images/rfigs/course-materials/earth-analytics/week-4/in-class/2016-12-06-review02-raster-analysis-workflow-R/create-new-extent-1.png" title="cropped dtm subset" alt="cropped dtm subset" width="100%" />


```r
dev.off()
## RStudioGD 
##         2
```

## Create a final classified dataset

When we have decided what break points work best for our data, then we may chose
to classify the data.


```r

# -20,-10,-3,-1, 1, 3, 10, 50
# create reclass vector
reclass_vector <- c(-20,-10, -3,
                    -10,-3, -2,
                    -3, -.5, -1,
                    -.5, .5, 0,
                    .5, 3, 1,
                    3, 10, 2,
                    10, 50, 3)

reclass_matrix <- matrix(reclass_vector,
                         ncol=3,
                         byrow = T)

reclass_matrix
##       [,1]  [,2] [,3]
## [1,] -20.0 -10.0   -3
## [2,] -10.0  -3.0   -2
## [3,]  -3.0  -0.5   -1
## [4,]  -0.5   0.5    0
## [5,]   0.5   3.0    1
## [6,]   3.0  10.0    2
## [7,]  10.0  50.0    3
```

## Reclassify difference raster


```r

diff_dtm_rcl <- reclassify(dtm_diff, reclass_matrix)

plot(diff_dtm_rcl,
     col=new_colors,
     legend=F)
par(xpd=T)
legend(dtm_diff@extent@xmax, dtm_diff@extent@ymax,
       legend=c("-20 to -10", "-10 to -3", "-3 to -.5",
                "-.5 to .5", "1 to 3", "3 to 10", "10 to 50"),
       fill=new_colors,
       bty="n",
       cex=.8)
```

<img src="{{ site.url }}/images/rfigs/course-materials/earth-analytics/week-4/in-class/2016-12-06-review02-raster-analysis-workflow-R/reclassify-raster-diff-1.png" title="final plot" alt="final plot" width="100%" />

Finally view the final histogram


```r
hist(diff_dtm_rcl,
     main="Histogram of reclassified data",
     xlab="Height Class")
```

<img src="{{ site.url }}/images/rfigs/course-materials/earth-analytics/week-4/in-class/2016-12-06-review02-raster-analysis-workflow-R/histogram-of-diff-rcl-1.png" title="histogram of differences" alt="histogram of differences" width="100%" />

Now let's look at one last thing. What would the distribution look like if
we set all values between -.5 to .5 to NA?


```r
# create a new raster object
diff_dtm_rcl_na <- diff_dtm_rcl
# assign values between -.5 and .5 to NA
diff_dtm_rcl_na[diff_dtm_rcl_na >= -.5 & diff_dtm_rcl_na <= .5] <- NA
# view histogram
hist(diff_dtm_rcl_na,
     main="Histogram of data \n values between -.5 and .5 set to NA",
     xlab="Difference Class")
```

<img src="{{ site.url }}/images/rfigs/course-materials/earth-analytics/week-4/in-class/2016-12-06-review02-raster-analysis-workflow-R/reclass-1.png" title="histogram of final cleaned data" alt="histogram of final cleaned data" width="100%" />

```r

# view summary of data
summary(diff_dtm_rcl_na)
##           layer
## Min.         -3
## 1st Qu.      -1
## Median       -1
## 3rd Qu.       1
## Max.          3
## NA's    6761395
```
