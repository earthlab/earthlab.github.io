## ----load-libraries------------------------------------------------------
# load libraries
library(raster)
library(rgdal)

# Make sure your working directory is set to  wherever your 'earth-analytics' dir is
# setwd("earth-analytics-dir-path-here")


## ----open-plot-raster, fig.cap="digital surface model raster plot"-------
# open raster data
lidar_dem <- raster(x="data/week3/BLDR_LeeHill/pre-flood/lidar/pre_DTM.tif")

# plot raster data
plot(lidar_dem,
     main="Digital Elevation Model - Pre 2013 Flood")


## ----plot-zoomed-in-raster, fig.cap="zoom in on a small part of a raster - see the pixels?"----
# zoom in to one region of the raster
plot(lidar_dem, xlim=c(473000, 473030), ylim=c(4434000, 4434030),
     main="Lidar Raster - Zoomed into to one small region")


## ----view-res------------------------------------------------------------
# what is the x and y resolution for our raster data?
xres(lidar_dem)
yres(lidar_dem)


## ----crs-view------------------------------------------------------------
# view coordinate refence system
crs(lidar_dem)


## ----view-hist, fig.cap="histogram of DEM elevation values"--------------
# plot histogram
hist(lidar_dem,
     main="Distribution of surface elevation values",
     xlab="Elevation (meters)", ylab="Frequency",
     col="springgreen")

## ----class-challenge, echo=F, fig.cap="DSM histogram and plot"-----------
lidar_dsm <- raster("data/week3/BLDR_LeeHill/pre-flood/lidar/pre_DSM_hill.tif")
hist(lidar_dsm,
     col="springgreen", 
     xlab="elevation", ylab="frequency",
     main="DSM Histogram")

plot(lidar_dsm, main="Digital Surface Model")


