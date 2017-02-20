# importa gdal
library(gdalUtils)
# set wd
setwd("~/Documents/earth-analytics/week6/modis")

# band_path <- the_file
export_modis_h4_tifs <- function(band_path){
  # this function exports all of the datasets in a MODIS h4 file
  
  # first get a list of layers
  layer_list <- get_subdatasets(band_path)
  # then 

# export the first layer to tif
  gdal_translate(band_path[2], dst_dataset = "/state_1km_1.tif")
state_rast <- raster("/state_1km_1.tif")

}

### file w 7 bands
the_file <- "MOD09GA.A2017045.h09v05.006.2017047102019.hdf"
#he_file <- "MOD09Q1.A2017033.h09v05.006.2017044220655.hdf"

# gdalinfo("/MOD09Q1.A2017033.h09v05.006.2017044220655.hdf")

# Tells me what subdatasets are within my hdf4 MODIS files and makes them into a list

sds <- get_subdatasets(the_file)
sds


# export the first layer to tif
gdal_translate(sds[1], dst_dataset = "/NPP2000.tif")

# Load and plot the new .tif
library(raster)
rast <- raster("/NPP2000.tif")
plot(rast)




### file w 7 bands
the_file_7bands <- "/MOD09GA.A2017045.h09v05.006.2017047102019.hdf"
sds <- get_subdatasets(the_file_7bands)
sds


# export the first layer to tif
gdal_translate(sds[2], dst_dataset = "/state_1km_1.tif")
state_rast <- raster("/state_1km_1.tif")
hist(state_rast)
plot(state_rast)



# get band 3 
gdal_translate(sds[14], dst_dataset = "/band3.tif")
band3 <- raster("/band3.tif")

# get band 1 
gdal_translate(sds[12], dst_dataset = "/band1.tif")
band1 <- raster("/band1.tif")

# get band 4 
gdal_translate(sds[15], dst_dataset = "/band4.tif")
band4 <- raster("/band4.tif")
the_stack <- stack(band1, band3, band4)

#band1 - red
#band 3 - green
#band 4 - green
plotRGB(the_stack, r=1, g=2, b=3,
        stretch="hist")

hist(band3)
plot(band3)

## unpack bits 
library(MODIS)

cloud_mask <- extractBits(state_rast, bitShift=0, bitMask=3,
                          decodeOnly=TRUE)

makeWeights(state_rast,bitShift=0, bitMask=3,
            decodeOnly=TRUE)
# get inFo about bit layer
detectBitInfo("MOD09GA")

plot(cloud_mask)
hist(cloud_mask)
