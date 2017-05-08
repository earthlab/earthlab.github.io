## ----setup, echo=FALSE---------------------------------------------------
knitr::opts_chunk$set(echo = TRUE, message = FALSE, warning=FALSE)

## ----load-libraries, warning=FALSE, message=FALSE, echo=FALSE------------
# load libraries
library(raster)
library(rgdal)

## ----open-raster, fig.cap="raster data example of embedded metadata", echo=FALSE----
# open raster data
lidar_dem <- raster(x="data/week3/BLDR_LeeHill/pre-flood/lidar/pre_DTM.tif")

# plot raster data
plot(lidar_dem,
  axes=FALSE, box=FALSE)

## ------------------------------------------------------------------------
# view attributes associated with our DTM geotiff
GDALinfo("data/week3/BLDR_LeeHill/pre-flood/lidar/pre_DTM.tif")

## ------------------------------------------------------------------------
# view attributes / metadata of raster
# open raster data
lidar_dem <- raster(x="data/week3/BLDR_LeeHill/pre-flood/lidar/pre_DTM.tif")
# view crs
crs(lidar_dem)

# view extent
lidar_dem@extent


## ------------------------------------------------------------------------
lidar_dsm <- raster(x="data/week3/BLDR_LeeHill/pre-flood/lidar/pre_DSM.tif")

extent_lidar_dsm <- extent(lidar_dsm)
extent_lidar_dem <- extent(lidar_dem)

# Do the two datasets cover the same spatial extents?
if(extent_lidar_dem == extent_lidar_dsm){
  print("Both datasets cover the same spatial extent")
}


