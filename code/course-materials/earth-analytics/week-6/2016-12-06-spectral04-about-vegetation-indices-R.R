## ----load-packages, warning=F, message=F, results="hide"-----------------
# load spatial packages
library(raster)
library(rgdal)
library(rgeos)
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

landsat_ndvi <- (landsat_stack_csf[[5]] - landsat_stack_csf[[4]]) / (landsat_stack_csf[[5]] + landsat_stack_csf[[4]])

plot(landsat_ndvi,
     main="Landsat derived NDVI\n 23 July 2016")

## ----ndvi-hist, fig.cap="histogram"--------------------------------------
# view distribution of NDVI values
hist(landsat_ndvi)


## ----calculate-nbr, echo=F, fig.cap="landsat derived NDVI plot"----------
# bands 7 and 5
landsat_nbr <- (landsat_stack_csf[[5]] - landsat_stack_csf[[7]]) / (landsat_stack_csf[[5]] + landsat_stack_csf[[7]])

plot(landsat_nbr,
     main="Landsat derived NBR\n 23 July 2016",
     axes=F,
     box=F)

