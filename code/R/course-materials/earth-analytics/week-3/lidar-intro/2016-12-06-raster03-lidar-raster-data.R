## ----load-libraries------------------------------------------------------

# load libraries
library(raster)
library(rgdal)

# set working directory to ensure R can find the file we wish to import
# setwd("working-dir-path-here")


## ----open-plot-raster, fig.caption="digital surface model raster plot"----

# open raster data
lidar_dem <- raster(x="data/week3/lidar/post-flood/postDSM3.tif")

# plot raster data
plot(lidar_dem)


## ----plot-zoomed-in-raster, fig.caption="zoom in on a small part of a raster - see the pixels?"----
plot(lidar_dem, xlim=c(473000, 473050), ylim=c(4434000, 4434050),
     main="Lidar Raster - Zoomed into to one small region")


## ----view-res------------------------------------------------------------

# what is the x and y resolution for our raster data?
xres(lidar_dem)
yres(lidar_dem)


## ----crs-view------------------------------------------------------------

# view coordinate refence system 
crs(lidar_dem)


## ----view-hist-----------------------------------------------------------
# plot histogram
hist(lidar_dem,
     main="Distribution of elevation values",
     xlab="elevation (meters)", ylab="frequency",
     col="springgreen")

