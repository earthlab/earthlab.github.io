## ----setup, echo=FALSE---------------------------------------------------
knitr::opts_chunk$set(echo = TRUE, message = FALSE, warning=FALSE)

## ----load-libraries, warning=F, message=F--------------------------------

# devtools::install_github("tidyverse/ggplot2")
# load libraries
library(rgdal)
library(ggplot2)
library(rgeos)
library(raster)

#install.packages('sf')
# testing the sf package out for these lessons!
library(sf)
# set your working directory
# setwd("~/Documents/earth-analytics/")

## ----set-ggplot-theme----------------------------------------------------
# turn off axis elements in ggplot for better visual comparison
newTheme <- list(theme(line = element_blank(),
      axis.text.x = element_blank(),
      axis.text.y = element_blank(),
      axis.ticks = element_blank(), # turn off ticks
      axis.title.x = element_blank(), # turn off titles
      axis.title.y = element_blank(),
      legend.position="none")) # turn off legend

## ----plot-world-data, echo=FALSE, fig.cap="Plot of the world boundary using ggplot2."----
# import_data using sf
#worldBound_df <- st_read("data/week5/global/ne_110m_land/ne_110m_land.shp")
# get crs
#st_crs(worldBound)

ggplot(worldBound_df) +
  geom_sf(data= worldBound_df, aes(fill = ""))


## ----fortify-data, results='hide'----------------------------------------
# read shapefile
worldBound <- readOGR(dsn="data/week5/global/ne_110m_land",
                     layer="ne_110m_land")
# convert to dataframe
worldBound_df <- fortify(worldBound)

## ----load-plot-data, fig.cap="world map plot"----------------------------
# plot map using ggplot
worldMap <- ggplot(worldBound_df, aes(long,lat, group=group)) +
  geom_polygon() +
  coord_equal() +
  labs(x="Longitude (Degrees)",
       y="Latitude (Degrees)",
      title="Global Map - Geographic Coordinate System ",
      subtitle = "WGS84 Datum, Units: Degrees - Latitude / Longitude")

worldMap

## ----add-lat-long-locations, fig.cap="Map plotted using geographic projection with location points added."----
# define locations of Boulder, CO, Mallorca, Spain and  Oslo, Norway
# store coordinates in a data.frame
loc_df <- data.frame(lon=c(-105.2519, 10.7500, 2.9833),
                lat=c(40.0274, 59.9500, 39.6167))

# add a point to the map
mapLocations <- worldMap +
                geom_point(data=loc_df,
                aes(x=lon, y=lat, group=NULL), colour = "springgreen",
                      size=5)

mapLocations


## ----global-map-robinson, fig.cap="Map reprojected to robinson projection."----
# reproject data from longlat to robinson CRS
worldBound_robin <- spTransform(worldBound,
                                CRS("+proj=robin"))

worldBound_df_robin <- fortify(worldBound_robin)

# force R to plot x and y values without rounding digits
# options(scipen=100)

robMap <- ggplot(worldBound_df_robin, aes(long,lat, group=group)) +
  geom_polygon() +
  labs(title="World map (robinson)",
       x = "X Coordinates (meters)",
       y ="Y Coordinates (meters)") +
  coord_equal()

robMap

## ----add-locations-robinson, fig.cap="map with point locations added - robinson projection."----
# add a point to the map
newMap <- robMap + geom_point(data=loc_df,
                      aes(x=lon, y=lat, group=NULL),
                      colour = "springgreen",
                      size=5)

newMap


## ----reproject-robinson1, fig.cap="Map plotted using robinson projection."----
# data.frame containing locations of Boulder, CO and Oslo, Norway
loc_df

# convert dataframe to spatial points data frame
loc_spdf<- SpatialPointsDataFrame(coords = loc_df, data=loc_df,
                            proj4string=crs(worldBound))

loc_spdf

## ----transform-data------------------------------------------------------
# reproject data to Robinson
loc_spdf_rob <- spTransform(loc_spdf, CRSobj = CRS("+proj=robin"))


## ----plot-new-map, fig.cap="Map of the globe in robinson projection."----
# convert the spatial object into a data frame
loc_rob_df <- as.data.frame(coordinates(loc_spdf_rob))

# add a point to the map
newMap <- robMap + geom_point(data=loc_rob_df,
                      aes(x=lon, y=lat, group=NULL),
                      colour = "springgreen",
                      size=5)

newMap


## ----plot-w-graticules, results='hide'-----------------------------------
## import graticule shapefile data
graticule <- readOGR("data/week5/global/ne_110m_graticules_all",
                     layer="ne_110m_graticules_15")
# convert spatial sp object into a ggplot ready, data.frame
graticule_df <- fortify(graticule)

## ----plot-grat, fig.cap="graticules plot"--------------------------------
# plot graticules
ggplot() +
  geom_path(data=graticule_df, aes(long, lat, group=group), linetype="dashed", color="grey70")


## ----import-box, results='hide'------------------------------------------
bbox <- readOGR("data/week5/global/ne_110m_graticules_all/ne_110m_wgs84_bounding_box.shp")
bbox_df <- fortify(bbox)

latLongMap <- ggplot(bbox_df, aes(long,lat, group=group)) +
              geom_polygon(fill="white") +
              geom_polygon(data=worldBound_df, aes(long,lat, group=group, fill=hole)) +
              geom_path(data=graticule_df, aes(long, lat, group=group), linetype="dashed", color="grey70") +
  coord_equal() +  labs(title="World Map - Geographic (long/lat degrees)")  +
  newTheme +

  scale_fill_manual(values=c("black", "white"), guide="none") # change colors & remove legend

# add our location points to the map
latLongMap <- latLongMap +
              geom_point(data=loc_df,
                      aes(x=lon, y=lat, group=NULL),
                      colour="springgreen",
                      size=5)

## ----reproject-robinson--------------------------------------------------
# reproject grat into robinson
graticule_robin <- spTransform(graticule, CRS("+proj=robin"))  # reproject graticule
grat_df_robin <- fortify(graticule_robin)
bbox_robin <- spTransform(bbox, CRS("+proj=robin"))  # reproject bounding box
bbox_robin_df <- fortify(bbox_robin)

# plot using robinson

finalRobMap <- ggplot(bbox_robin_df, aes(long, lat, group=group)) +
  geom_polygon(fill="white") +
  geom_polygon(data=worldBound_df_robin, aes(long, lat, group=group, fill=hole)) +
  geom_path(data=grat_df_robin, aes(long, lat, group=group), linetype="dashed", color="grey70") +
  labs(title="World Map Projected - Robinson (Meters)") +
  coord_equal() + newTheme +
  scale_fill_manual(values=c("black", "white"), guide="none") # change colors & remove legend

# add a location layer in robinson as points to the map
finalRobMap <- finalRobMap + geom_point(data=loc_rob,
                      aes(x=X, y=Y, group=NULL),
                      colour="springgreen",
                      size=5)

## ----render-maps, fig.cap="plots in different projections, side by side."----
require(gridExtra)
# display side by side
grid.arrange(latLongMap, finalRobMap)


## ----challenge-1, echo=FALSE---------------------------------------------

## notes about robinson -- you will see distortion above 40 = 45 degrees latitude
## it is optimized for the latitudes between 0-45 (north and south).

## geographic - notice that the latitude lines are closer together are you move
## north...

# What each CRS optimizes:
## Mercator:
## ALbers Equal Area
## UTM Zone 11n
## Geographic WGS84 (lat/lon):

