## ------------------------------------------------------------------------
# load packages
library(raster)
library(rgdal)
library(dplyr)
library(stringr)

## ---- results='hide'-----------------------------------------------------
# import data
aoi <- readOGR("data/week5/california/SJER/vector_data/sjer_crop.shp")


## ------------------------------------------------------------------------
# view crs of the aoi
crs(aoi)

## ------------------------------------------------------------------------
# import data
world <- readOGR("data/week5/global/ne_110m_land/ne_110m_land.shp")
crs(world)

## ----crs-strings---------------------------------------------------------
# create data frame of epsg codes
epsg <- make_EPSG()
# view data frame - top 6 results
head(epsg)

## ------------------------------------------------------------------------
# view proj 4 string for the epsg code 4326
epsg %>% 
  filter(code==4326)


## ------------------------------------------------------------------------
latlong <- epsg %>% 
  filter(str_detect(prj4, 'longlat'))
head(latlong)

## ------------------------------------------------------------------------
utm <- epsg %>% 
  filter(str_detect(prj4, 'utm'))
head(utm)

## ------------------------------------------------------------------------
# create a crs definition by copying the proj 4 string
a_crs_object <- crs("+proj=longlat +datum=WGS84 +no_defs")
class(a_crs_object)
a_crs_object

## ------------------------------------------------------------------------
# create crs using epsg code
a_crs_object_epsg <- crs("+init=epsg:4326")
class(a_crs_object_epsg)
a_crs_object_epsg


