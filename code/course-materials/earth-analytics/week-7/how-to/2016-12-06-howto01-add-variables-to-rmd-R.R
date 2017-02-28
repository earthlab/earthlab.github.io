## ----crop-naip-imagey, echo=F, results='hide', message=F, warning=F------
library(raster)
library(rgeos)
library(rgdal)
# import stack
# import vector that we used to crop the data
# csf_crop <- readOGR("data/week6/vector_layers/fire_crop_box_500m.shp")


## ----create-variable-----------------------------------------------------

total_area <- (800 * 7) / 2

