## ----load-packages, warning=F, message=F, results='hide'-----------------
# load spatial packages
library(raster)
library(rgdal)
library(rgeos)
library(RColorBrewer)
# turn off factors
options(stringsAsFactors = F)

## ----create-landsat-stack------------------------------------------------
all_landsat_bands <- list.files("data/week6/Landsat/LC80340322016205-SC20170127160728/crop",
           pattern=glob2rx("*band*.tif$"),
           full.names = T) # use the dollar sign at the end to get all files that END WITH
all_landsat_bands

# stack the data
landsat_stack_csf <- stack(all_landsat_bands)

## ----calculate-ndvi, fig.cap="landsat derived NDVI plot"-----------------
# calculate NDVI
landsat_ndvi <- (landsat_stack_csf[[5]] - landsat_stack_csf[[4]]) / (landsat_stack_csf[[5]] + landsat_stack_csf[[4]])

plot(landsat_ndvi,
     main="Landsat derived NDVI\n 23 July 2016")

## ----ndvi-hist, fig.cap="histogram"--------------------------------------
# view distribution of NDVI values
hist(landsat_ndvi,
  main="NDVI: Distribution of pixels\n Landsat 2016 Cold Springs fire site",
  col="springgreen")


## ----export-raster, eval=F-----------------------------------------------
## # export raster
## # NOTE: this won't work if you don't have an outputs directory in your week6 dir!
## writeRaster(x = landsat_ndvi,
##               filename="data/week6/outputs/landsat_ndvi.tif",
##               format = "GTiff", # save as a tif
##               datatype='INT2S', # save as a INTEGER rather than a float
##               overwrite = T)  # OPTIONAL - be careful. this will OVERWRITE previous files.

