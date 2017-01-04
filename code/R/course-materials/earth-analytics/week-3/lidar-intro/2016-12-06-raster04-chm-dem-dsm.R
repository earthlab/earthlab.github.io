## ----load-libraries------------------------------------------------------

# load libraries
library(raster)
library(rgdal)

# set working directory to ensure R can find the file we wish to import
# setwd("working-dir-path-here")


## ----dem, fig.cap="digital elevation model plot"-------------------------

# open raster data
lidar_dem <- raster(x="data/week3/lidar/post-flood/postDSM3.tif")

# plot raster data
plot(lidar_dem,
     main="LiDAR Digital Elevation Model")


## ----dsm, fig.cap="digital surface model plot"---------------------------

# open raster data
lidar_dsm <- raster(x="data/week3/lidar/post-flood/postDSM3.tif")

# plot raster data
plot(lidar_dsm,
     main="LiDAR Digital Surface Model")


## ----chm, fig.cap="canopy height model plot"-----------------------------

# open raster data
lidar_chm <- lidar_dsm - lidar_dem

# plot raster data
plot(lidar_chm,
     main="LiDAR Canopy Height Model")


## ----chm-breaks, fig.cap="canopy height model breaks"--------------------

# plot raster data
plot(lidar_chm,
     breaks = c(300, 350, 400, 450),
     main="LiDAR Canopy Height Model")

