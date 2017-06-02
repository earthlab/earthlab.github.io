## ----setup, echo=FALSE---------------------------------------------------
knitr::opts_chunk$set(echo = TRUE, message = FALSE, warning=FALSE)

## ----load-libraries, fig.cap="digital surface model raster plot"---------
# load libraries
library(raster)
library(rgdal)

# Make sure your working directory is set to  wherever your 'earth-analytics' dir is
# setwd("earth-analytics-dir-path-here")

# open raster data
lidar_dem <- raster(x="data/week3/BLDR_LeeHill/pre-flood/lidar/pre_DTM.tif")

# plot raster data
plot(lidar_dem,
     main="Digital Elevation Model - Pre 2013 Flood")

## ----view-hist, fig.cap="histogram of DEM elevation values", warning=F, message=F----
# plot histogram
hist(lidar_dem,
     main="Distribution of surface elevation values",
     xlab="Elevation (meters)", ylab="Frequency",
     col="springgreen")

## ----view-hist2, fig.cap="histogram of DEM elevation values", warning=F, message=F----
# plot histogram
hist(lidar_dem,
     breaks=3,
     main="Distribution of surface elevation values with breaks",
     xlab="Elevation (meters)", ylab="Frequency",
     col="springgreen")

## ----view-hist3, fig.cap="histogram of DEM elevation values", warning=F, message=F----
# plot histogram
hist(lidar_dem,
     main="Distribution of surface elevation values",
     breaks=c(1600, 1800, 2000, 2100),
     xlab="Elevation (meters)", ylab="Frequency",
     col="wheat3")

## ----class-challenge, echo=F, fig.cap="DSM histogram and plot", warning=F, message=F----
lidar_dsm <- raster("data/week3/BLDR_LeeHill/pre-flood/lidar/pre_DSM_hill.tif")
hist(lidar_dsm,
     col="springgreen",
     xlab="elevation", ylab="frequency",
     main="DSM Histogram")

plot(lidar_dsm,
  main="Digital Surface Model")


