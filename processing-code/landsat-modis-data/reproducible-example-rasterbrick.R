getwd()
setwd("/Users/lewa8222/Documents/earth-analytics")


r1 <- r2 <- r3 <- raster(nrow=10, ncol=10)
# assign random values bewteen
# Assign random cell values

#  create rasters with  int values int2s structure
values(r1) <- floor(runif(ncell(r1), min=-32000, max=32000))
values(r2) <- floor(runif(ncell(r2), min=-32000, max=32000))
values(r3) <- floor(runif(ncell(r3), min=-32000, max=32000))
s <- stack(r1, r2, r3)
# it's a float now
str(s)
s
b <- brick(s)
b
s[s < -100] <- NA
s


## the same thing using modis data

library(raster)
library(rgeos)
library(rgdal)
options(stringsAsFactors=F)

# open modis bands (layers with sur_refl in the name)
all_modis_bands_july7 <-list.files("data/week6/modis/reflectance/07_july_2016/crop",
                                   pattern=glob2rx("*sur_refl*.tif$"),
                                   full.names = T)
# create spatial raster stack
all_modis_bands_st_july7 <- stack(all_modis_bands_july7)
# apply the scale factor to the data
all_modis_bands_st_july7 <- all_modis_bands_st_july7 * .0001
all_modis_bands_br_july7[[2]]
hist(all_modis_bands_st_july7)
#all_modis_bands_july7_br <- brick(all_modis_bands_st_july7, datatype='INT2S')
# view range of values in stack
all_modis_bands_st_july7[[2]]

# deal with nodata value --  -28672
all_modis_bands_st_july7[all_modis_bands_st_july7 < -100 ] <- NA
# options("scipen"=100, "digits"=4)
hist(all_modis_bands_st_july7[[2]])

