## ----load-libraries,  message=F, warning=F-------------------------------
# load libraries
library(raster)
library(rgdal)

# set working directory to ensure R can find the file we wish to import
# setwd("working-dir-path-here")

## ----dem, fig.cap="digital elevation model plot", warning=F, message=F----
# open raster data
lidar_dem <- raster(x="data/week3/BLDR_LeeHill/pre-flood/lidar/pre_DTM.tif")

# plot raster data
plot(lidar_dem,
     main="Lidar Digital Elevation Model (DEM)")


## ----dsm, fig.cap="digital surface model plot", warning=F, message=F-----
# open raster data
lidar_dsm <- raster(x="data/week3/BLDR_LeeHill/pre-flood/lidar/pre_DSM.tif")

# plot raster data
plot(lidar_dsm,
     main="Lidar Digital Surface Model (DSM)")

## ----chm, fig.cap="canopy height model plot", warning=F, message=F-------
# open raster data
lidar_chm <- lidar_dsm - lidar_dem

# plot raster data
plot(lidar_chm,
     main="Lidar Canopy Height Model (CHM)")

## ----chm-breaks, fig.cap="canopy height model breaks", warning=F, message=F----
# plot raster data
plot(lidar_chm,
     breaks = c(0, 2, 10, 20, 30),
     main="Lidar Canopy Height Model",
     col=c("white","brown","springgreen","darkgreen"))


## ----export-raster, warning=F, message=FALSE-----------------------------
# check to see if an output directory exists
dir.exists("data/week3/outputs")

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



