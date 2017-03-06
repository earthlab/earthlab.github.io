
# Code examples

setwd("~/Documents/earth-analytics")


## 
# the students will do this several times if they need to reclassify say 3 landsat datasets and 3 modis datasets. It's the same process over and over!

# load spatial packages
library(raster)
library(rgdal)
library(rgeos)
library(RColorBrewer)
# turn off factors
options(stringsAsFactors = F)


source(".r")
#### Function: get tif files, make stack ####
# get list of tif files
all_landsat_bands <- list.files("data/week6/Landsat/LC80340322016205-SC20170127160728/crop",
                                pattern=glob2rx("*band*.tif$"),
                                full.names = T) # use the dollar sign at the end to get all files that END WITH

# stack the data (create spatial object)
landsat_stack_csf <- stack(all_landsat_bands)


#### CREATE Vegetation index #### 
## This could be a function
# create index function
calculate_normalized_index <- function(band1, band2){
  index <- (band1 - band2) / (band1 + band2)
  return(index)
}

# then use overlay to calculate NDVI rather than raster math which is inefficient
landsat_ndvi <- overlay(landsat_stack_csf[[5]],landsat_stack_csf[[4]], 
                        fun=calculate_normalized_index)


# calculate NDVI (the way they've been doing it is inefficient but they don't know functions yet)
landsat_ndvi <- (landsat_stack_csf[[5]] - landsat_stack_csf[[4]]) / (landsat_stack_csf[[5]] + landsat_stack_csf[[4]])


#### FUNCTION reclassify data using some reclass range of values  ####
# this could return a raster classified object

# create classification matrix
# note i line it up like this so it looks more like the arcgis reclass table! 
reclass <- c(-1, -.2, 1,
             -.2, .2, 2,
             .2, .5, 3,
             .5, 1, 4)
# reshape the object into a matrix with columns and rows
reclass_m <- matrix(reclass,
                    ncol=3,
                    byrow=TRUE)

ndvi_classified <- reclassify(landsat_ndvi,
                              reclass_m)

plot(ndvi_classified)

#### Plot with legend it's so annoying to do this over and over ####
# but it's not necessarily the best multi-purpose function
plot(ndvi_classified,
     box=F, axes=F, legend=F,
     main="Title here")
# par(xpd=T) # you may want to modify par here so this may not be an ideal function
legend(ndvi_classified@extent@xmax, ndvi_classified@extent@ymax,
       legend=c("class one", "class two", "class three"),
       fill = the_colors, bty="n", xpd=T)

dev.size()
dev.off()
the_colors = c("palevioletred4","palevioletred1","ivory1","seagreen1","seagreen4")

### Optional -- export NDVI raster with unique name 
writeRaster(x = landsat_ndvi,
            filename="data/week6/outputs/landsat_ndvi.tif",
            format = "GTiff", # save as a tif
            datatype='INT2S', # save as a INTEGER rather than a float
            overwrite = T)  # OPTIONAL - be careful. this will OVERWRITE previous files.

plot(landsat_ndvi,
     main="Landsat derived NDVI\n 23 July 2016")

# ideas for loops
# loop through a list of files and crop each one using a crop extent (i had to do this)
# crop a raster but make sure the crop layer is in the right CRS


#### Function: get tif files, make stack ####
# get list of tif files
all_landsat_bands <- list.files("data/week6/Landsat/LC80340322016205-SC20170127160728/crop",
                                pattern=glob2rx("*band*.tif$"),
                                full.names = T) # use the dollar sign at the end to get all files that END WITH

# stack the data (create spatial object)
landsat_stack_csf <- stack(all_landsat_bands)


#### CREATE Vegetation index #### 
## This could be a function
# create index function
calculate_normalized_index <- function(band1, band2){
  index <- (band1 - band2) / (band1 + band2)
  return(index)
}

# then use overlay to calculate NDVI rather than raster math which is inefficient
landsat_ndvi <- overlay(landsat_stack_csf[[5]],landsat_stack_csf[[4]], 
                        fun=calculate_normalized_index)


# calculate NDVI (the way they've been doing it is inefficient but they don't know functions yet)
landsat_ndvi <- (landsat_stack_csf[[5]] - landsat_stack_csf[[4]]) / (landsat_stack_csf[[5]] + landsat_stack_csf[[4]])


#### FUNCTION reclassify data using some reclass range of values  ####
# this could return a raster classified object

# create classification matrix
# note i line it up like this so it looks more like the arcgis reclass table! 
reclass <- c(-1, -.2, 1,
             -.2, .2, 2,
             .2, .5, 3,
             .5, 1, 4)
# reshape the object into a matrix with columns and rows
reclass_m <- matrix(reclass,
                    ncol=3,
                    byrow=TRUE)

ndvi_classified <- reclassify(landsat_ndvi,
                              reclass_m)

plot(ndvi_classified)

#### Plot with legend it's so annoying to do this over and over ####
# but it's not necessarily the best multi-purpose function
plot(ndvi_classified,
     box=F, axes=F, legend=F,
     main="Title here")
# par(xpd=T) # you may want to modify par here so this may not be an ideal function
legend(ndvi_classified@extent@xmax, ndvi_classified@extent@ymax,
       legend=c("class one", "class two", "class three"),
       fill = the_colors, bty="n", xpd=T)

dev.size()
dev.off()
the_colors = c("palevioletred4","palevioletred1","ivory1","seagreen1","seagreen4")

### Optional -- export NDVI raster with unique name 
writeRaster(x = landsat_ndvi,
            filename="data/week6/outputs/landsat_ndvi.tif",
            format = "GTiff", # save as a tif
            datatype='INT2S', # save as a INTEGER rather than a float
            overwrite = T)  # OPTIONAL - be careful. this will OVERWRITE previous files.

plot(landsat_ndvi,
     main="Landsat derived NDVI\n 23 July 2016")

