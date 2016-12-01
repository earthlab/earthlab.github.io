## ----load-libraries------------------------------------------------------

# load libraries
library(raster)
library(rgdal)

# set working directory to ensure R can find the file we wish to import
# setwd("working-dir-path-here")

# read in a GeoTIFF raster file (.tif) using the raster() function
DSM_HARV <- raster("NEON-DS-Airborne-Remote-Sensing/HARV/DSM/HARV_dsmCrop.tif")

# view Coordinate Reference System (note, this often contains horizontal units!)
crs(DSM_HARV)


## ----crs-class-----------------------------------------------------------
# assign crs to an object (class) to use for reprojection and other tasks
myCRS <- crs(DSM_HARV)
myCRS

# what class is the new CRS object?
class(myCRS)

# view spatial extent
extent(DSM_HARV)

# view spatial resolution
res(DSM_HARV)


## ----view-extent---------------------------------------------------------

# view object extent
myExtent <- extent(DSM_HARV)
myExtent
class(myExtent)

# print object name to return object metadata & attribute data

DSM_HARV

## ----challenge-extent, echo=FALSE----------------------------------------

# 1. they should create both objects
CHM.HARV <- raster("NEON-DS-Airborne-Remote-Sensing/HARV/CHM/HARV_chmCrop.tif")
crs(CHM.HARV)
extent(CHM.HARV)

# 2. the extent and CRS should be the same
# 3. The extent and CRS are different.
ndvi1.HARV <- raster("NEON-DS-Landsat-NDVI/HARV/2011/ndvi/005_HARV_ndvi_crop.tif")
crs(ndvi1.HARV)
extent(ndvi1.HARV)

