## ----load-packages, warning=F, message=F, results="hide"-----------------
# load spatial packages
library(raster)
library(rgdal)
library(rgeos)
# turn off factors
options(stringsAsFactors = F)

## ----get-tifs------------------------------------------------------------
# get list of all tifs
list.files("data/week6/landsat/LC80340322016205-SC20170127160728/crop")

# but really we just want the tif files
all_landsat_bands <- list.files("data/week6/Landsat/LC80340322016205-SC20170127160728/crop",
                      pattern=".tif$",
                      full.names = T) # make sure we have the full path to the file
all_landsat_bands


## ----get-all-tif-bands---------------------------------------------------
all_landsat_bands <- list.files("data/week6/Landsat/LC80340322016205-SC20170127160728/crop",
           pattern=glob2rx("*band*.tif$"),
           full.names = T) # use the dollar sign at the end to get all files that END WITH
all_landsat_bands

## ------------------------------------------------------------------------
# get first file
all_landsat_bands[2]
landsat_band1 <- raster(all_landsat_bands[2])
plot(landsat_band1,
     main="Landsat cropped band 1\nColdsprings fire scar",
     col=gray(0:100 / 100))

## ----create-landsat-stack------------------------------------------------
# stack the data
landsat_stack_csf <- stack(all_landsat_bands)
# view stack attributes
landsat_stack_csf

## ----plot-stack, fig.cap="plot individual landsat bands"-----------------
plot(landsat_stack_csf,
     col=gray(20:100 / 100))

## ----plot-rgb, fig.cap="plot rgb composite"------------------------------
par(col.axis="white", col.lab="white", tck=0)
plotRGB(landsat_stack_csf,
     r=4, g=3, b=2,
     stretch="lin",
     axes=T,
     main="RGB composite image\n Landsat Bands 4, 3, 2")
box(col="white")

## ----plot-cir, fig.cap="plot rgb composite"------------------------------
par(col.axis="white", col.lab="white", tck=0)
plotRGB(landsat_stack_csf,
     r=5, g=4, b=3,
     stretch="lin",
     axes=T,
     main="Color infrared composite image\n Landsat Bands 5, 4, 3")
box(col="white")

