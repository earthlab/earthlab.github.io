## ----view-extent, collapse=T---------------------------------------------

# load raster library
library(raster)
library(rgdal)

# import canopy height model
chm_HARV <- raster("NEON-DS-Airborne-Remote-Sensing/HARV/CHM/HARV_chmCrop.tif")

# View the extent of the raster
chm_HARV@extent


## ----calculate-raster-extent, collapse=T---------------------------------
# create a raster from the matrix
myRaster1 <- raster(nrow=4, ncol=4)

# assign some random data to the raster
myRaster1[]<- 1:ncell(myRaster1)

# view attributes of the raster
myRaster1

# is the CRS defined?
myRaster1@crs

# what are the data extents?
myRaster1@extent
plot(myRaster1, main="Raster with 16 pixels")


## ----raster-attributes, collapse=T---------------------------------------


# import canopy height model
chm_HARV <- raster("NEON-DS-Airborne-Remote-Sensing/HARV/CHM/HARV_chmCrop.tif")

chm_HARV


