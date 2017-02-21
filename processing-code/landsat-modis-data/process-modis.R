# importa gdal
library(gdalUtils)
library(MODIS)
# set wd
setwd("~/Documents/earth-analytics/week6/modis")


### HELPER FUNCTION  to write an individual layer as a tif. ####
# the_layer <- modis_july7[2]
# h4_file_path <- the_file_7bands

export_modis_as_tif <- function(the_layer, h4_file_path){
  # build layer name   
  name <- unlist(strsplit(the_layer,":"))
  the_layer_name <- name[5]
  file_name <- gsub(".hdf", "", basename(h4_file_path))
  crop_dir <- paste0(dirname(h4_file_path), "/crop/")
  layer_name <- paste0(crop_dir, file_name, "_", the_layer_name, ".tif")
  
  # export to layer tif
  gdal_translate(the_layer, 
                 dst_dataset = layer_name)
}

the_file_7bands <- "modis/reflectance/07_july_2016/MOD09GA.A2016189.h09v05.006.2016191073856.hdf"

process_modis_bands <- function(the_file_7bands){
  # get layers for file
  h4_layers <- get_subdatasets(the_file_7bands)
  
  # build crop_dir path
  crop_dir <- paste0(dirname(the_file_7bands), "/crop/")
  # make sure crop directory exists
  if(!dir.exists(crop_dir)){
    dir.create(crop_dir, recursive = T)
  }
  
  # go through layers 12-18 and export a tif
  # i <- 12
  for(i in seq(from=12, to=18, by=1)){
    export_modis_as_tif(h4_layers[i], the_file_7bands)
  }

  # finally, export single state layer
  export_modis_as_tif(modis_july7[2], the_file_7bands)

}

#################
# run function on a h4 file
the_file <- "modis/reflectance/17_july_2016/MOD09GA.A2016199.h09v05.006.2016201065406.hdf"
process_modis_bands(the_file)






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
the_file <- "modis/reflectance/7-july-2016/MOD09GA.A2016189.h09v05.006.2016191073856.hdf"
get_subdatasets(the_file)

#he_file <- "MOD09Q1.A2017033.h09v05.006.2017044220655.hdf"

gdalinfo("reflectance/MOD09Q1.A2017033.h09v05.006.2017044220655.hdf")
get_subdatasets("reflectance/MYD09Q1.A2016185.h09v05.005.2016200115336.hdf")
get_subdatasets("reflectance/MYD09Q1.A2016185.h09v05.005.2016200115336.hdf")

# Tells me what subdatasets are within my hdf4 MODIS files and makes them into a list

sds <- get_subdatasets(the_file)
sds


# export the first layer to tif
gdal_translate(sds[1], dst_dataset = "/NPP2000.tif")

# Load and plot the new .tif
library(raster)
rast <- raster("/NPP2000.tif")
plot(rast)


### Open reflectance file w 7 bands
the_file_7bands <- "modis/reflectance/07_july_2016/MOD09GA.A2016189.h09v05.006.2016191073856.hdf"
modis_july7 <- get_subdatasets(the_file_7bands)
modis_july7


# build layer name   
name <- unlist(strsplit(modis_july7[12],":"))
the_layer <- name[5]
file_name <- gsub(".hdf", "", basename(the_file_7bands))
layer_name <- paste0(file_name, "_", the_layer)
crop_dir <- paste0(dirname(the_file_7bands), "/crop/")

# make sure crop directory exists
if(!dir.exists(crop_dir)){
  dir.create(crop_dir, recursive = T)
}

# go through layers 12-18 and export a tif
# i <- 12
for(i in seq(from=12, to=18, by=1)){
  # build layer name   
  name <- unlist(strsplit(modis_july7[i],":"))
  the_layer <- name[5]
  file_name <- gsub(".hdf", "", basename(the_file_7bands))
  crop_dir <- paste0(dirname(the_file_7bands), "/crop/")
  layer_name <- paste0(crop_dir,file_name, "_", the_layer, ".tif")
  
  # export to layer tif
  gdal_translate(modis_july7[i], 
                 dst_dataset = layer_name)
  
}
# then add the cloud bitmask
gdal_translate(modis_july7[2], dst_dataset = "/state_1km_1.tif")








gdal_translate(modis_july7[12], dst_dataset = "/state_1km_1.tif")


# export the state layer to tif
# this contains the cloud mask and is the second layer in the hdf file
gdal_translate(modis_july7[2], dst_dataset = "/state_1km_1.tif")
state_rast <- raster("/state_1km_1.tif")


# export the state layer to tif
# this contains the cloud mask and is the second layer in the hdf file
gdal_translate(sds[2], dst_dataset = "/state_1km_1.tif")
state_rast <- raster("/state_1km_1.tif")
hist(state_rast)
plot(state_rast)




### file w 7 bands
the_file_7bands <- "reflectance/MOD09GA.A2017045.h09v05.006.2017047102019.hdf"
sds <- get_subdatasets(the_file_7bands)
sds






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
