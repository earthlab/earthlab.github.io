---
layout: single 
title: 'Computing and plotting 2d spatial point density in R' 
date: 2016-07-07 
modified: '2020-04-20'
authors: [Max Joseph] 
category: [tutorials] 
excerpt: 'This tutorial demonstrates how to compute 2d spatial density and visualize the result using storm event data from NOAA.' 
estimated-time: "20-30 minutes"
difficulty: "intermediate"
sidebar: 
nav: 
author_profile: false 
comments: true 
lang: [r]
lib: [ggmap, viridis]
---


It is often useful to quickly compute a measure of point density and show it on a map. 
In this tutorial, we'll demonstrate this using crime data from Houston, Texas 
contained in the ggmap R package. 

## Objectives

- Compute 2d spatial density of points
- Plot the density surface with ggplot2

## Dependencies

- ggplot2
- ggmap

We'll start by loading libraries.
**Note** the ggmap package is no longer used in this lesson to generate a basemap, due changes in the way that maps are served from Google, but the data used in this tutorial are contained in the ggmap package. 


```r
library(ggplot2)
library(ggmap)
```

Then, we can load a built-in crime dataset for Houston, Texas. 


```r
data(crime)

# remove any rows with missing data
crime <- crime[complete.cases(crime), ]

# look at the structure of the crime data
str(crime)
## 'data.frame':	81803 obs. of  17 variables:
##  $ time    : POSIXct, format: "2010-01-01 06:00:00" "2010-01-01 06:00:00" ...
##  $ date    : chr  "1/1/2010" "1/1/2010" "1/1/2010" "1/1/2010" ...
##  $ hour    : int  0 0 0 0 0 0 0 0 0 0 ...
##  $ premise : chr  "18A" "13R" "20R" "20R" ...
##  $ offense : Factor w/ 7 levels "aggravated assault",..: 4 6 1 1 1 3 3 3 3 3 ...
##  $ beat    : chr  "15E30" "13D10" "16E20" "2A30" ...
##  $ block   : chr  "9600-9699" "4700-4799" "5000-5099" "1000-1099" ...
##  $ street  : chr  "marlive" "telephone" "wickview" "ashland" ...
##  $ type    : chr  "ln" "rd" "ln" "st" ...
##  $ suffix  : chr  "-" "-" "-" "-" ...
##  $ number  : int  1 1 1 1 1 1 1 1 1 1 ...
##  $ month   : Ord.factor w/ 8 levels "january"<"february"<..: 1 1 1 1 1 1 1 1 1 1 ...
##  $ day     : Ord.factor w/ 7 levels "monday"<"tuesday"<..: 5 5 5 5 5 5 5 5 5 5 ...
##  $ location: chr  "apartment parking lot" "road / street / sidewalk" "residence / house" "residence / house" ...
##  $ address : chr  "9650 marlive ln" "4750 telephone rd" "5050 wickview ln" "1050 ashland st" ...
##  $ lon     : num  -95.4 -95.3 -95.5 -95.4 -95.4 ...
##  $ lat     : num  29.7 29.7 29.6 29.8 29.7 ...
```

Let's plot the locations of crimes with ggplot2. 


```r
ggplot(crime, aes(x = lon, y = lat)) + 
  geom_point() + 
  coord_equal() + 
  xlab('Longitude') + 
  ylab('Latitude')
```

<img src="{{ site.url }}/images/tutorials/R/2016-07-07-visualize-2d-point-density-ggmap/basic-plot-1.png" title="plot of chunk basic-plot" alt="plot of chunk basic-plot" width="90%" />

There seems to be a fair bit of overplotting. 

Let's instead plot a density estimate. 
There are many ways to compute densities, and if the mechanics of density estimation are important for your application, it is worth investigating packages that specialize in point pattern analysis (e.g., [spatstat](https://cran.r-project.org/web/packages/spatstat/index.html)). 
If on the other hand, you're lookng for a quick and dirty implementation for the purposes of exploratory data analysis, you can also use ggplot's [`stat_density2d`](http://ggplot2.tidyverse.org/reference/geom_density_2d.html), which uses [`MASS::kde2d`](https://stat.ethz.ch/R-manual/R-devel/library/MASS/html/kde2d.html) on the backend to estimate the density using a bivariate normal kernel.



```r
ggplot(crime, aes(x = lon, y = lat)) + 
  coord_equal() + 
  xlab('Longitude') + 
  ylab('Latitude') + 
  stat_density2d(aes(fill = ..level..), alpha = .5,
                 geom = "polygon", data = crime) + 
  scale_fill_viridis_c() + 
  theme(legend.position = 'none')
```

<img src="{{ site.url }}/images/tutorials/R/2016-07-07-visualize-2d-point-density-ggmap/stat_density2d-1.png" title="plot of chunk stat_density2d" alt="plot of chunk stat_density2d" width="90%" />

You can pass arguments for `kde2d` through the call to `stat_density2d`. 
In this case, we alter the argument `h`, which is a bandwidth parameter related to the spatial range or smoothness of the density estimate. 



```r
ggplot(crime, aes(x = lon, y = lat)) + 
  coord_equal() + 
  xlab('Longitude') + 
  ylab('Latitude') + 
  stat_density2d(aes(fill = ..level..), alpha = .5,
                 h = .02, n = 300,
                 geom = "polygon", data = crime) + 
  scale_fill_viridis_c() + 
  theme(legend.position = 'none')
```

<img src="{{ site.url }}/images/tutorials/R/2016-07-07-visualize-2d-point-density-ggmap/stat_density2d-bw-1.png" title="plot of chunk stat_density2d-bw" alt="plot of chunk stat_density2d-bw" width="90%" />

As an alternative, we might consider plotting the raw data points with alpha transparency so that we can see the actual data, not just a model of the data.
We will also set coordinates to use as limits to focus in on downtown Houston. 


```r
ggplot(crime, aes(x = lon, y = lat)) + 
  geom_point(size = 0.1, alpha = 0.05) + 
  coord_equal() + 
  xlab('Longitude') + 
  ylab('Latitude') + 
  coord_cartesian(xlim = c(-95.1, -95.7), 
                  ylim = c(29.5, 30.1))
```

<img src="{{ site.url }}/images/tutorials/R/2016-07-07-visualize-2d-point-density-ggmap/little-pts-1.png" title="plot of chunk little-pts" alt="plot of chunk little-pts" width="90%" />

