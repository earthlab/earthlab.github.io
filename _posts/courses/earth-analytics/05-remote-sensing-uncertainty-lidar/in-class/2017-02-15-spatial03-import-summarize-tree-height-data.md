---
layout: single
title: "Import and summarize tree height data and compare it to lidar derived height in R"
excerpt: ". "
authors: ['Leah Wasser']
modified: '2017-09-29'
category: [courses]
class-lesson: ['remote-sensing-uncertainty-r']
permalink: /courses/earth-analytics/remote-sensing-uncertainty/import-summarize-tree-height-data/
nav-title: 'Compare ground to lidar data'
week: 5
course: "earth-analytics"
sidebar:
  nav:
author_profile: false
comments: true
order: 3
topics:
  remote-sensing: ['lidar']
  earth-science: ['vegetation', 'uncertainty']
  reproducible-science-and-programming:
  spatial-data-and-gis: ['vector-data', 'raster-data']
redirect_from:
---

{% include toc title="In This Lesson" icon="file-text" %}

<div class='notice--success' markdown="1">

## <i class="fa fa-graduation-cap" aria-hidden="true"></i> Learning Objectives

After completing this tutorial, you will be able to:

* Use pipes to summarize tree height data by plot stored in `.csv` format
* Merge a regular `data.frame` to a spatial `data.frame` object
* Create scatterplots using `ggplot()` that compare 2 variables using a 1:1 line

## <i class="fa fa-check-square-o fa-2" aria-hidden="true"></i> What You Need

You will need a computer with internet access to complete this lesson and the data for week 4 of the course.

[<i class="fa fa-download" aria-hidden="true"></i> Download Week 4 Data (~500 MB)](https://ndownloader.figshare.com/files/7525363){:data-proofer-ignore='' .btn }

</div>




In the last lesson we extracted canopy height data at each field site location
from a NEON Canopy Height Model. In this lesson, we will summarize our field
site data so that we can compare tree heights measured on the ground with
tree heights derived from lidar data.

We will use the `dplyr` library to manipulate our data.

## Extract Descriptive Stats From *In situ* Data

First let's import and explore our tree height data. Note that our tree
height data is stored in `.csv` format. How many unique plots are in the data?





```
## 'data.frame':	362 obs. of  30 variables:
##  $ siteid               : chr  "SJER" "SJER" "SJER" "SJER" ...
##  $ sitename             : chr  "San Joaquin" "San Joaquin" "San Joaquin" "San Joaquin" ...
##  $ plotid               : chr  "SJER128" "SJER2796" "SJER272" "SJER112" ...
##  $ easting              : num  257086 256048 256723 257421 256720 ...
##  $ northing             : num  4111382 4111548 4112170 4111308 4112177 ...
##  $ taxonid              : chr  "PISA2" "ARVI4" "ARVI4" "ARVI4" ...
##  $ scientificname       : chr  "Pinus sabiniana" "Arctostaphylos viscida" "Arctostaphylos viscida" "Arctostaphylos viscida" ...
##  $ indvidual_id         : int  1485 1622 1427 1511 1431 1507 1433 1620 1425 1506 ...
##  $ pointid              : chr  "center" "NE" "center" "center" ...
##  $ individualdistance   : num  9.7 5.8 6 17.2 9.9 15.1 6.8 10.5 2.6 15.9 ...
##  $ individualazimuth    : num  135.6 31.4 65.9 57.1 17.7 ...
##  $ dbh                  : num  67.4 NA NA NA 17.1 NA NA 18.6 NA NA ...
##  $ dbhheight            : num  130 130 130 130 10 130 130 1 130 130 ...
##  $ basalcanopydiam      : int  0 43 23 22 0 105 107 0 73 495 ...
##  $ basalcanopydiam_90deg: num  0 31 14 12 0 43 66 0 66 126 ...
##  $ maxcanopydiam        : num  15.1 5.7 5.9 2.5 5.2 8.5 3.3 6.5 3.3 7.5 ...
##  $ canopydiam_90deg     : num  12.4 4.8 4.3 2.1 4.6 6.1 2.5 5.2 2.1 6.9 ...
##  $ stemheight           : num  18.2 3.3 1.7 2.1 3 3.1 1.7 3.8 1.4 3.1 ...
##  $ stemremarks          : chr  "" "3 stems" "2 stems" "6 stems" ...
##  $ stemstatus           : chr  "" "" "" "" ...
##  $ canopyform           : chr  "" "Hemisphere" "Hemisphere" "Sphere" ...
##  $ livingcanopy         : int  100 70 35 70 80 85 0 85 85 55 ...
##  $ inplotcanopy         : int  100 100 100 100 100 100 100 100 100 100 ...
##  $ materialsampleid     : chr  "" "f095" "" "f035" ...
##  $ dbhqf                : int  0 0 0 0 0 0 0 0 0 0 ...
##  $ stemmapqf            : int  0 0 0 0 0 0 0 0 0 0 ...
##  $ plant_group          : logi  NA NA NA NA NA NA ...
##  $ common_name          : logi  NA NA NA NA NA NA ...
##  $ aop_plot             : logi  NA NA NA NA NA NA ...
##  $ unique_id            : logi  NA NA NA NA NA NA ...
##  [1] "SJER128"  "SJER2796" "SJER272"  "SJER112"  "SJER1068" "SJER916" 
##  [7] "SJER361"  "SJER3239" "SJER824"  "SJER8"    "SJER952"  "SJER116" 
## [13] "SJER117"  "SJER37"   "SJER4"    "SJER192"  "SJER36"   "SJER120"
##  [1] "SJER1068" "SJER112"  "SJER116"  "SJER117"  "SJER120"  "SJER128" 
##  [7] "SJER192"  "SJER272"  "SJER2796" "SJER3239" "SJER36"   "SJER361" 
## [13] "SJER37"   "SJER4"    "SJER8"    "SJER824"  "SJER916"  "SJER952"
##  [1] TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE
## [15] TRUE TRUE TRUE TRUE
## [1] TRUE
```

## Extract Max Tree Height

In the field measured data, you have tree heights for each tree measured in each site.
This is useful but really what your want is an average tree height value for all
trees in that plot location. You need to `summarise` our data by unique plot id.
In this case you need a mean and max tree height value for each plot.

You use `dplyr` to extract a summary tree height value for each plot. In
this case, we will calculate the mean MEASURED tree height value for each
plot. This value represents the average tree in each plot. You will also calculate
the max height representing the max height for each plot.

Finally, you will compare the mean measured tree height per plot to the mean
tree height extracted from the lidar `CHM`.


```
## # A tibble: 6 x 3
##     plotid insitu_max insitu_mean
##      <chr>      <dbl>       <dbl>
## 1 SJER1068       19.3    3.866667
## 2  SJER112       23.9    8.221429
## 3  SJER116       16.0    8.218750
## 4  SJER117       11.0    6.512500
## 5  SJER120        8.8    7.600000
## 6  SJER128       18.2    5.211765
```


Above you did a few things

1. group_by: You grouped by the *plotid* column
2. you created two new summary fields using `summarise`. One field is called insitu_max and the other insitu_mean. Each field is populated with the max tree height value per plot and the mean tree height value per plot respectively.
3. you created a new data.frame called `insitu_stem_height`

### Merge a regular data.frame with a spatial points data.frame

Once you have summarized the insitu data.frame, you can `merge` it into with the
plot centroids `spatial points data.frame`. Merge requires:

1. the name of the spatial points data frame
2. the name of the regular `data.frames` that you want to add to it.
3. the column names that contains the unique ID that we will merge the data on.


In this case, we will merge the data on the plot_id column. Notice that it's
spelled slightly differently in both `data.frames` so we'll need to tell `R`
what it's called in each `data.frame`.


```
##     Plot_ID  Point northing  easting plot_type lidar_mean_ht insitu_max
## 1  SJER1068 center  4111568 255852.4     trees     11.544348       19.3
## 2   SJER112 center  4111299 257407.0     trees     10.355685       23.9
## 3   SJER116 center  4110820 256838.8     grass      7.511956       16.0
## 4   SJER117 center  4108752 256176.9     trees      7.675347       11.0
## 5   SJER120 center  4110476 255968.4     grass      4.591176        8.8
## 6   SJER128 center  4111389 257078.9     trees      8.979005       18.2
## 7   SJER192 center  4111071 256683.4     grass      7.240118       13.7
## 8   SJER272 center  4112168 256717.5     trees      7.103862       12.4
## 9  SJER2796 center  4111534 256034.4      soil      6.405240        9.4
## 10 SJER3239 center  4109857 258497.1      soil      6.009128       17.9
## 11   SJER36 center  4110162 258277.8     trees      6.516288        9.2
## 12  SJER361 center  4107527 256961.8     grass     13.899027       11.8
## 13   SJER37 center  4107579 256148.2     trees      7.109851       11.5
## 14    SJER4 center  4109767 257228.3     trees      5.032620       10.8
## 15    SJER8 center  4110249 254738.6     trees      3.024286        5.2
## 16  SJER824 center  4110048 256185.6      soil      7.738203       26.5
## 17  SJER916 center  4109617 257460.5      soil     11.181955       18.4
## 18  SJER952 center  4110759 255871.2     grass      4.149286        7.7
##    insitu_mean
## 1     3.866667
## 2     8.221429
## 3     8.218750
## 4     6.512500
## 5     7.600000
## 6     5.211765
## 7     6.769565
## 8     6.819048
## 9     5.085714
## 10    3.920833
## 11    9.200000
## 12    2.451429
## 13    7.350000
## 14    5.910526
## 15    1.057143
## 16    5.357895
## 17    5.791667
## 18    1.558333
```


In the previous lesson we renamed the lidar height field. Notice how now this
makes our data.frame more "expressive" or easier to understand.


### Plot Data (CHM vs Measured)

Finally, create a scatterplot that illustrates the relationship between insitu
measured max canopy height values and lidar derived max canopy height values.


<img src="{{ site.url }}/images/rfigs/courses/earth-analytics/05-remote-sensing-uncertainty-lidar/in-class/2017-02-15-spatial03-import-summarize-tree-height-data/plot-w-ggplot-1.png" title="ggplot - measured vs lidar chm." alt="ggplot - measured vs lidar chm." width="90%" />

Next, let's fix the plot adding a 1:1 line and making the x and y axis the same .

<img src="{{ site.url }}/images/rfigs/courses/earth-analytics/05-remote-sensing-uncertainty-lidar/in-class/2017-02-15-spatial03-import-summarize-tree-height-data/plot-w-ggplot2-1.png" title="ggplot - measured vs lidar chm w one to one line." alt="ggplot - measured vs lidar chm w one to one line." width="90%" />

We can also add a regression fit to our plot. Explore the `GGPLOT` options and
customize your plot.

<img src="{{ site.url }}/images/rfigs/courses/earth-analytics/05-remote-sensing-uncertainty-lidar/in-class/2017-02-15-spatial03-import-summarize-tree-height-data/ggplot-data-1.png" title="Scatterplot measured height compared to lidar chm." alt="Scatterplot measured height compared to lidar chm." width="90%" />


## View Difference: Lidar vs Measured

<img src="{{ site.url }}/images/rfigs/courses/earth-analytics/05-remote-sensing-uncertainty-lidar/in-class/2017-02-15-spatial03-import-summarize-tree-height-data/view-diff-1.png" title="box plot showing differences between chm and measured heights." alt="box plot showing differences between chm and measured heights." width="90%" />

Remove the legend from the ggplot and remove the site name from the plotid column.
You will want to know how to modify a column for your homework assignment.

Use `gsub()` to remove all the text **SJER** from each plot id value
in the plotid column. gsub() takes 3 arguments

1. The text that ou want to replace in quotes `""`
2. What you want to replace that text with. To remove it use `""`
3. The thing that you want to do the find and replace on. In this case that thing is the plotid column in our `data.frame`.


<img src="{{ site.url }}/images/rfigs/courses/earth-analytics/05-remote-sensing-uncertainty-lidar/in-class/2017-02-15-spatial03-import-summarize-tree-height-data/barplot-nolegend-1.png" title=" " alt=" " width="90%" />

You have now successfully created a canopy height model using lidar data AND compared lidar
derived vegetation height, within plots, to actual measured tree height data.
Does the relationship look good or not? Would you use lidar data to estimate tree
height over larger areas? Would other metrics be a better comparison (see challenge
below).

<div class="notice--warning" markdown="1">

## <i class="fa fa-pencil-square-o" aria-hidden="true"></i> Test Your Skills: Lidar vs In Situ Comparison

Create a plot of lidar max height vs *in situ* max height. Add labels to your plot.
Customize the colors, fonts and the look of your plot. If you are happy with the
outcome, share your plot in the comments below!
 </div>


## Interactive Plot

<iframe width="460" height="293" frameborder="0" seamless="seamless" scrolling="no" src="https://plot.ly/~leahawasser/24.embed?width=460&height=293"></iframe>
