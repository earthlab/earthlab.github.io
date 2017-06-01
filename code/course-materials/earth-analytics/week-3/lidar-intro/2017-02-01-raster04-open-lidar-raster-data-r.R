## ----setup, echo=FALSE---------------------------------------------------
knitr::opts_chunk$set(echo = TRUE, message = FALSE, warning=FALSE)

## ----load-libraries, warning=F, message=F--------------------------------
# load libraries
library(raster)
library(rgdal)

# Make sure your working directory is set to  wherever your 'earth-analytics' dir is
# setwd("earth-analytics-dir-path-here")


## ----open-plot-raster, fig.cap="digital surface model raster plot", warning=F, message=F----
# open raster data
lidar_dem <- raster(x="data/week3/BLDR_LeeHill/pre-flood/lidar/pre_DTM.tif")

# plot raster data
plot(lidar_dem,
     main="Digital Elevation Model - Pre 2013 Flood")


## ----plot-zoomed-in-raster, fig.cap="zoom in on a small part of a raster - see the pixels?", warning=F, message=F----
# zoom in to one region of the raster
plot(lidar_dem,
  xlim=c(473000, 473030), # define the x limits
  ylim=c(4434000, 4434030), # define y limits for the plot
     main="Lidar Raster - Zoomed into to one small region")


## ----view-resolution-units-----------------------------------------------
# view resolution units
crs(lidar_dem)

# assign crs to an object (class) to use for reprojection and other tasks
myCRS <- crs(lidar_dem)
myCRS


## ----view-res, warning=F, message=F--------------------------------------
# what is the x and y resolution for our raster data?
xres(lidar_dem)
yres(lidar_dem)


## ----crs-view, warning=F, message=F--------------------------------------
# view coordinate refence system
crs(lidar_dem)


