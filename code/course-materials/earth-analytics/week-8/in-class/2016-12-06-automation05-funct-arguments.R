## ----import-raster, echo=F-----------------------------------------------
library(raster)
library(rgdal)

## ----plot-ndvi, fig.cap="ndvi plot", fig.width=7, fig.height=5-----------
# import and plot landsat
landsat_ndvi <- raster("data/week6/outputs/landsat_ndvi.tif")
plot(landsat_ndvi,
     main = "ndvi title - rendered using a function argument",
     axes = FALSE,
     box = FALSE)

## ---- eval=FALSE---------------------------------------------------------
## # view help for the csv function
## ?read.csv

## ---- eval=FALSE---------------------------------------------------------
## read.csv(file, header = TRUE, sep = ",", quote = "\"",
##          dec = ".", fill = TRUE, comment.char = "", ...)

## ---- results="hide", error = TRUE---------------------------------------
precip_data <- read.csv(FALSE, "data/week2/precipitation/precip-boulder-aug-oct-2013.csv")

## ---- eval=F-------------------------------------------------------------
## precip_data <- read.csv("data/week2/precipitation/precip-boulder-aug-oct-2013.csv",
##                 FALSE)

## ---- eval=F-------------------------------------------------------------
## # import csv
## precip_data <- read.csv(header = FALSE,
##                 file = "data/week2/precipitation/precip-boulder-aug-oct-2013.csv")
## 

## ---- error = TRUE-------------------------------------------------------
dat <- read.csv(FALSE,
                "data/week2/precipitation/precip-boulder-aug-oct-2013.csv")


