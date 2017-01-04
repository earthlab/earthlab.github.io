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

## ----export-raster-------------------------------------------------------

# check to see if an output directory exists
!dir.exists("data/week3/outputs")

# if the output directory doesn't exist, create it
if (dir.exists("data/week3/outputs")) {
  print("the directory exists!") 
  } else {
    # if the directory doesn't exist, create it
    # recursive tells R to create the entire directory path (data/week3/outputs)
    dir.create("data/week3/outputs", recursive=TRUE) 
  }

# export CHM object to new GeotIFF
writeRaster(lidar_chm, "data/week3/outputs/lidar_chm.tiff",
            format="GTiff",  # output format = GeoTIFF
            overwrite=TRUE) # CAUTION: if this is true, it will overwrite an existing file
            


