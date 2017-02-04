---
layout: single
title: "Introduction to LiDAR Data"
excerpt: "This lesson reviews what Lidar remote sensing is and discusses the core
components of a lidar remote sensing system."
authors: ['Leah Wasser']
modified: '2017-02-03'
category: [course-materials]
class-lesson: ['class-lidar-r']
permalink: /course-materials/earth-analytics/week-4/lidar-to-insitu/
nav-title: 'LiDAR Data Intro'
module-title: 'Compare remote sensing with in situ data in  R'
module-description: 'This tutorial covers the basic principles of LiDAR remote sensing and
the three commonly used data products: the digital elevation model, digital surface model and the canopy height model. Finally it walks through opening lidar derived raster data in R / RStudio'
module-nav-title: 'Spatial Data in R'
module-type: 'class'
week: 3
sidebar:
  nav:
author_profile: false
comments: true
order: 1
---

{% include toc title="In This Lesson" icon="file-text" %}

<div class='notice--success' markdown="1">

## <i class="fa fa-graduation-cap" aria-hidden="true"></i> Learning Objectives

After completing this tutorial, you will be able to:

* List and briefly describe the 3 core components of a lidar remote sensing system.
* Describe what a lidar system measures.
* Define an active remote sensing system.

## <i class="fa fa-check-square-o fa-2" aria-hidden="true"></i> What you need

You will need a computer with internet access to complete this lesson.

If you have not already downloaded the week 3 data, please do so now.
[<i class="fa fa-download" aria-hidden="true"></i> Download Week 3 Data (~250 MB)](https://ndownloader.figshare.com/files/7446715){:data-proofer-ignore='' .btn }

</div>

## Background ####
NEON (National Ecological Observatory Network) will provide derived LiDAR products as one
of its many free ecological data products. These products will come in a
<a href="http://trac.osgeo.org/geotiff/" target="_blank"> GeoTIFF</a> 
format, which is a `tif` raster format that is spatially located on the earth. 
Geotiffs can be accessed using the `raster` package in R.

A common first analysis using LiDAR data is to derive top of the canopy height 
values from the LiDAR data. These values are often used to track changes in 
forest structure over time, to calculate biomass, and even Leaf Area Index (LAI). 
Let's dive into the basics of working with raster formatted LiDAR data in R! 
Before we begin, make sure you've downloaded the data required to run the code 
below.

<div id="objectives" markdown="1">

### Recommended Reading
<a href="http://neondataskills.org/remote-sensing/2_LiDAR-Data-Concepts_Activity2/">
What is a CHM, DSM and DTM? About Gridded, Raster LiDAR Data</a>

</div>



```r

# Import DSM into R
library(raster)
library(rgdal)
library(ggplot2)
library(dplyr)

options(stringsAsFactors = FALSE)

# set working directory
# setwd("path-here/earth-analytics")
```

## Import NEON CHM

First, we will import the NEON canopy height model.


```r

# import canopy height model (CHM).
SJER_chm <- raster("data/week4/NEONdata/D17-California/SJER/2013/lidar/SJER_lidarCHM.tif")
SJER_chm
## class       : RasterLayer 
## dimensions  : 5059, 4296, 21733464  (nrow, ncol, ncell)
## resolution  : 1, 1  (x, y)
## extent      : 254571, 258867, 4107303, 4112362  (xmin, xmax, ymin, ymax)
## coord. ref. : +proj=utm +zone=11 +datum=WGS84 +units=m +no_defs +ellps=WGS84 +towgs84=0,0,0 
## data source : /Users/lewa8222/Documents/earth-analytics/data/week4/NEONdata/D17-California/SJER/2013/lidar/SJER_lidarCHM.tif 
## names       : SJER_lidarCHM 
## values      : 0, 45.88  (min, max)

# set values of 0 to NA as these are not trees
SJER_chm[SJER_chm==0] <- NA

# plot the data
hist(SJER_chm,
     main="Histogram of Canopy Height\n NEON SJER Field Site",
     col="springgreen",
     xlab="Height (m)")
```

![ ]({{ site.url }}/images/rfigs/course-materials/earth-analytics/week-4/2016-12-06-spatial01-intro-vector-data-R/import-chm-1.png)


## Part 2. How does our CHM data compare to field measured tree heights?

We now have a canopy height model for our study area in California. However, how
do the height values extracted from the CHM compare to our laboriously collected,
field measured canopy height data? To figure this out, we will use *in situ* collected
tree height data, measured within circular plots across our study area. We will compare
the maximum measured tree height value to the maximum LiDAR derived height value
for each circular plot using regression.

For this activity, we will use the a `csv` (comma separate value) file,
located in `SJER/2013/insitu/veg_structure/D17_2013_SJER_vegStr.csv`.


```r

# import plot centroids
SJER_plots <- readOGR("data/week4/NEONdata/D17-California/SJER/vector_data",
                      "SJER_plot_centroids")
## OGR data source with driver: ESRI Shapefile 
## Source: "data/week4/NEONdata/D17-California/SJER/vector_data", layer: "SJER_plot_centroids"
## with 18 features
## It has 5 fields


# Overlay the centroid points and the stem locations on the CHM plot
plot(SJER_chm,
     main="Plot Locations",
     col=gray.colors(100, start=.3, end=.9))

# pch 0 = square
plot(SJER_plots,
     pch = 16,
     cex = 2,
     col = 2,
     add=TRUE)
```

![ ]({{ site.url }}/images/rfigs/course-materials/earth-analytics/week-4/2016-12-06-spatial01-intro-vector-data-R/read-plot-data-1.png)

### Extract CMH data within 20 m radius of each plot centroid.

Next, we will create a boundary region (called a buffer) representing the spatial
extent of each plot (where trees were measured). We will then extract all CHM pixels
that fall within the plot boundary to use to estimate tree height for that plot.

There are a few ways to go about this task. If your plots are circular, then the
extract tool will do the job!

<figure>
    <img src="{{ site.baseurl }}/images/spatialData/BufferCircular.png">
    <figcaption>The extract function in R allows you to specify a circular buffer
    radius around an x,y point location. Values for all pixels in the specified
    raster that fall within the circular buffer are extracted. In this case, we
    will tell R to extract the maximum value of all pixels using the fun=max
    command.
    </figcaption>
</figure>

### Extract Plot Data Using Circle: 20m Radius Plots


```r

# Insitu sampling took place within 40m x 40m square plots, so we use a 20m radius.
# Note that below will return a dataframe containing the max height
# calculated from all pixels in the buffer for each plot
SJER_height <- extract(SJER_chm,
                    SJER_plots,
                    buffer = 20,
                    fun=max,
                    sp=TRUE,
                    stringsAsFactors=FALSE)
```

#### If you want to explore The Data Distribution

If you want to explore the data distribution of pixel height values in each plot,
you could remove the `fun` call to max and generate a list.
`cent_ovrList <- extract(chm,centroid_sp,buffer = 20)`. It's good to look at the
distribution of values we've extracted for each plot. Then you could generate a
histogram for each plot `hist(cent_ovrList[[2]])`. If we wanted, we could loop
through several plots and create histograms using a `for loop`.


```r

# cent_ovrList <- extract(chm,centroid_sp,buffer = 20)
# create histograms for the first 5 plots of data
# for (i in 1:5) {
#  hist(cent_ovrList[[i]], main=(paste("plot",i)))
#  }

```



### Variation 3: Derive Square Plot boundaries, then CHM values around a point
For how to extract square plots using a plot centroid value, check out the
<a href="http://neondataskills.org/working-with-field-data/Field-Data-Polygons-From-Centroids" target="_blank"> extracting square shapes activity </a>.

 <figure>
    <img src="{{ site.baseurl }}/images/spatialData/BufferSquare.png">
    <figcaption>If you had square shaped plots, the code in the link above would
    extract pixel values within a square shaped buffer.
    </figcaption>
</figure>



## Extract descriptive stats from Insitu Data
In our final step, we will extract summary height values from our field data.
We will use the `dplyr` library to do this efficiently. We'll demonstrate both below

### Extract stats from our spatial `data.frame` using the `DPLYR` package.

First let's see how many plots are in the centroid folder.


```r

# import the centroid data and the vegetation structure data
SJER_insitu <- read.csv("NEONdata/D17-California/SJER/2013/insitu/veg_structure/D17_2013_SJER_vegStr.csv",
                        stringsAsFactors = FALSE)
## Warning in file(file, "rt"): cannot open file 'NEONdata/D17-California/
## SJER/2013/insitu/veg_structure/D17_2013_SJER_vegStr.csv': No such file or
## directory
## Error in file(file, "rt"): cannot open the connection

# get list of unique plots
unique(SJER_plots$Plot_ID)
##  [1] "SJER1068" "SJER112"  "SJER116"  "SJER117"  "SJER120"  "SJER128" 
##  [7] "SJER192"  "SJER272"  "SJER2796" "SJER3239" "SJER36"   "SJER361" 
## [13] "SJER37"   "SJER4"    "SJER8"    "SJER824"  "SJER916"  "SJER952"
```

## Extract Max Tree Height

Next, find the maximum MEASURED tree height value for each plot. This value represents
the tallest tree in each plot. We will compare
this value to the max lidar CHM value.


```r

# find the max stem height for each plot
insitu_maxStemHeight <- SJER_insitu %>%
  group_by(plotid) %>%
  summarise(max = max(stemheight))
## Error in eval(expr, envir, enclos): object 'SJER_insitu' not found

head(insitu_maxStemHeight)
## Error in head(insitu_maxStemHeight): object 'insitu_maxStemHeight' not found

# let's create better, self documenting column headers
names(insitu_maxStemHeight) <- c("plotid","insituMaxHt")
## Error in names(insitu_maxStemHeight) <- c("plotid", "insituMaxHt"): object 'insitu_maxStemHeight' not found
head(insitu_maxStemHeight)
## Error in head(insitu_maxStemHeight): object 'insitu_maxStemHeight' not found
```


### Merge InSitu Data With Spatial data.frame

Once we have our summarized insitu data, we can `merge` it into the centroids
`data.frame`. Merge requires two data.frames and the names of the columns
containing the unique ID that we will merge the data on. In this case, we will
merge the data on the plot_id column. Notice that it's spelled slightly differently
in both data.frames so we'll need to tell R what it's called in each data.frame.


```r

# merge to create a new spatial df
#SJER_height@data <- data.frame(SJER_height@data,
#                               insitu_maxStemHeight[match(SJER_height@data[,"Plot_ID"], #insitu_maxStemHeight$plotid),])

# the code below is another way to use MERGE however it creates a normal data.frame
# rather than a spatial object. Above, we reassigned the "data" slot to
# a newly merged data frame
# merge the insitu data into the centroids data.frame
SJER_height <- merge(SJER_height,
                     insitu_maxStemHeight,
                   by.x = 'Plot_ID',
                   by.y = 'plotid')
## Error in merge(SJER_height, insitu_maxStemHeight, by.x = "Plot_ID", by.y = "plotid"): object 'insitu_maxStemHeight' not found

SJER_height@data
##     Plot_ID  Point northing  easting Remarks SJER_lidarCHM
## 1  SJER1068 center  4111568 255852.4    <NA>         19.05
## 2   SJER112 center  4111299 257407.0    <NA>         24.02
## 3   SJER116 center  4110820 256838.8    <NA>         16.07
## 4   SJER117 center  4108752 256176.9    <NA>         11.06
## 5   SJER120 center  4110476 255968.4    <NA>          5.74
## 6   SJER128 center  4111389 257078.9    <NA>         19.14
## 7   SJER192 center  4111071 256683.4    <NA>         16.55
## 8   SJER272 center  4112168 256717.5    <NA>         11.84
## 9  SJER2796 center  4111534 256034.4    <NA>         20.28
## 10 SJER3239 center  4109857 258497.1    <NA>         12.91
## 11   SJER36 center  4110162 258277.8    <NA>          8.99
## 12  SJER361 center  4107527 256961.8    <NA>         18.73
## 13   SJER37 center  4107579 256148.2    <NA>         11.49
## 14    SJER4 center  4109767 257228.3    <NA>          9.53
## 15    SJER8 center  4110249 254738.6    <NA>          4.15
## 16  SJER824 center  4110048 256185.6    <NA>         25.66
## 17  SJER916 center  4109617 257460.5    <NA>         18.73
## 18  SJER952 center  4110759 255871.2    <NA>          6.38
```

### Plot Data (CHM vs Measured)
Let's create a plot that illustrates the relationship between in situ measured
max canopy height values and lidar derived max canopy height values.



```r

# create plot
ggplot(SJER_height@data, aes(x=SJER_lidarCHM, y = insituMaxHt)) +
  geom_point() +
  theme_bw() +
  ylab("Maximum measured height") +
  xlab("Maximum LiDAR pixel")+
  geom_abline(intercept = 0, slope=1) +
  ggtitle("Lidar Height Compared to InSitu Measured Height")
## Error in eval(expr, envir, enclos): object 'insituMaxHt' not found
```

![ ]({{ site.url }}/images/rfigs/course-materials/earth-analytics/week-4/2016-12-06-spatial01-intro-vector-data-R/plot-w-ggplot-1.png)


We can also add a regression fit to our plot. Explore the GGPLOT options and
customize your plot.


```r

#plot with regression fit
p <- ggplot(SJER_height@data, aes(x=SJER_lidarCHM, y = insituMaxHt)) +
  geom_point() +
  ylab("Maximum Measured Height") +
  xlab("Maximum LiDAR Height")+
  geom_abline(intercept = 0, slope=1)+
  geom_smooth(method=lm)

p + theme(panel.background = element_rect(colour = "grey")) +
  ggtitle("LiDAR CHM Derived vs Measured Tree Height") +
  theme(plot.title=element_text(family="sans", face="bold", size=20, vjust=1.9)) +
  theme(axis.title.y = element_text(family="sans", face="bold", size=14, angle=90, hjust=0.54, vjust=1)) +
  theme(axis.title.x = element_text(family="sans", face="bold", size=14, angle=00, hjust=0.54, vjust=-.2))
## Error in eval(expr, envir, enclos): object 'insituMaxHt' not found
```

![ ]({{ site.url }}/images/rfigs/course-materials/earth-analytics/week-4/2016-12-06-spatial01-intro-vector-data-R/ggplot-data-1.png)


## View Differences


```r

SJER_height@data$ht_diff <-  (SJER_height@data$SJER_lidarCHM - SJER_height@data$insituMaxHt)
## Error in `$<-.data.frame`(`*tmp*`, "ht_diff", value = numeric(0)): replacement has 0 rows, data has 18

boxplot(SJER_height@data$ht_diff)
## Warning in is.na(x): is.na() applied to non-(list or vector) of type 'NULL'

## Warning in is.na(x): is.na() applied to non-(list or vector) of type 'NULL'

## Warning in is.na(x): is.na() applied to non-(list or vector) of type 'NULL'
## Warning in min(x): no non-missing arguments to min; returning Inf
## Warning in max(x): no non-missing arguments to max; returning -Inf
## Error in plot.window(xlim = xlim, ylim = ylim, log = log, yaxs = pars$yaxs): need finite 'ylim' values
```

![ ]({{ site.url }}/images/rfigs/course-materials/earth-analytics/week-4/2016-12-06-spatial01-intro-vector-data-R/view-diff-1.png)

```r
barplot(SJER_height@data$ht_diff,
        xlab = SJER_height@data$Plot_ID)
## Error in barplot.default(SJER_height@data$ht_diff, xlab = SJER_height@data$Plot_ID): 'height' must be a vector or a matrix


# create bar plot
library(ggplot2)
ggplot(data=SJER_height@data, aes(x=Plot_ID, y=ht_diff, fill=Plot_ID)) +
    geom_bar(stat="identity")
## Error in eval(expr, envir, enclos): object 'ht_diff' not found
```

## QGIS Check

Here's a link to add imagery to QGIS.
<a href="https://ieqgis.wordpress.com/2014/08/09/adding-esris-online-world-imagery-dataset-to-qgis/" target="_blank">Add Imagery to QGIS</a>


You have now successfully created a canopy height model using LiDAR data AND compared LiDAR
derived vegetation height, within plots, to actual measured tree height data!

<div id="challenge" markdown="1">

## Challenge: LiDAR vs Insitu Comparison

Create a plot of LiDAR 95th percentile value vs *insitu* max height. Or LiDAR 95th
percentile vs *insitu* 95th percentile. Add labels to your plot. Customize the
colors, fonts and the look of your plot. If you are happy with the outcome, share
your plot in the comments below!
 </div>

## Create Plot.ly Interactive Plot

Plot.ly is a free to use, online interactive data viz site. If you have the
plot.ly library installed, you can quickly export a ggplot graphic into plot.ly!
 (NOTE: it also works for python matplotlib)!! To use plot.ly, you need to setup
an account. Once you've setup an account, you can get your key from the plot.ly
site (under Settings > API Keys) to make the code below work.

You must be signed into plot.ly online, from your current computer, at the time 
you use the `plotly_POST` command to upload you plot to your plot.ly account.  



```r

library(plotly)

# setup your plot.ly credentials
Sys.setenv("plotly_username"="Your-User-Name")
Sys.setenv("plotly_api_key"="Your-plotly-key")

# you must be signed into Plot.ly online on the same computer for this code to work. 
# generate the plot
plotly_POST(p,
            filename='NEON SJER CHM vs Insitu Tree Height') # let anyone in the world see the plot!

```

Check out the results!

NEON Remote Sensing Data compared to NEON Terrestrial Measurements for the SJER Field Site

<iframe width="460" height="293" frameborder="0" seamless="seamless" scrolling="no" src="https://plot.ly/~leahawasser/24.embed?width=460&height=293"></iframe>
