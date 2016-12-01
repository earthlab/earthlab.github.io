## ----lat-long-example----------------------------------------------------

library(rgdal)
library(ggplot2)
library(rgeos)
library(raster)

# be sure to set your working directory
# setwd("~/Documents/data")

# read shapefile
worldBound <- readOGR(dsn="Global/Boundaries/ne_110m_land",
                      layer="ne_110m_land")

# convert to dataframe
worldBound_df <- fortify(worldBound)

# plot map
worldMap <- ggplot(worldBound_df, aes(long,lat, group=group)) +
  geom_polygon() +
  xlab("Longitude (Degrees)") + ylab("Latitude (Degrees)") +
  coord_equal() +
  ggtitle("Global Map - Geographic Coordinate System - WGS84 Datum\n Units: Degrees - Latitude / Longitude")

worldMap


## ----add-lat-long-locations----------------------------------------------

# define locations of Boulder, CO and Oslo, Norway
# store them in a data.frame format
loc.df <- data.frame(lon=c(-105.2519, 10.7500, 2.9833),
                lat=c(40.0274, 59.9500, 39.6167))

# only needed if the above is a spatial points object
# loc.df <- fortify(loc)

# add a point to the map
mapLocations <- worldMap + geom_point(data=loc.df,
                        aes(x=lon, y=lat, group=NULL),
                      colour = "springgreen",
                      size=5)

mapLocations + theme(legend.position="none")


## ----global-map-robinson-------------------------------------------------

# reproject from longlat to robinson
worldBound_robin <- spTransform(worldBound,
                                CRS("+proj=robin"))

worldBound_df_robin <- fortify(worldBound_robin)

# force R to plot x and y values without abbrev
options(scipen=100)

robMap <- ggplot(worldBound_df_robin, aes(long,lat, group=group)) +
  geom_polygon() +
  labs(title="World map (robinson)") +
  xlab("X Coordinates (meters)") + ylab("Y Coordinates (meters)") +
  coord_equal()

robMap

## ----add-locations-robinson----------------------------------------------

# add a point to the map
newMap <- robMap + geom_point(data=loc.df,
                      aes(x=lon, y=lat, group=NULL),
                      colour = "springgreen",
                      size=5)

newMap + theme(legend.position="none")


## ----reproject-robinson--------------------------------------------------

# define locations of Boulder, CO and Oslo, Norway
loc.df

# convert to spatial Points data frame
loc.spdf <- SpatialPointsDataFrame(coords = loc.df, data=loc.df,
                            proj4string=crs(worldBound))

loc.spdf
# reproject data to Robinson
loc.spdf.rob <- spTransform(loc.spdf, CRSobj = CRS("+proj=robin"))

loc.rob.df <- as.data.frame(cbind(loc.spdf.rob$lon, loc.spdf.rob$lat))
# rename each column
names(loc.rob.df ) <- c("X","Y")

# convert spatial object to a data.frame for ggplot
loc.rob <- fortify(loc.rob.df)

# notice the coordinate system in the Robinson projection (CRS) is DIFFERENT
# from the coordinate values for the same locations in a geographic CRS.
loc.rob
# add a point to the map
newMap <- robMap + geom_point(data=loc.rob,
                      aes(x=X, y=Y, group=NULL),
                      colour = "springgreen",
                      size=5)

newMap + theme(legend.position="none")


## ----plot-w-graticules, echo=FALSE, message=FALSE, warning=FALSE, results='hide'----
#this is not taught in the lesson but use it to display ggplot next to each other
require(gridExtra)

# turn off axis elements in ggplot for better visual comparison
newTheme <- list(theme(line = element_blank(),
      line = element_blank(),
      axis.text.x = element_blank(),
      axis.text.y = element_blank(),
      axis.ticks = element_blank(), #turn off ticks
      axis.title.x = element_blank(), #turn off titles
      axis.title.y = element_blank(),
      legend.position="none")) #turn off legend

## add graticules
graticule <- readOGR("Global/Boundaries/ne_110m_graticules_all",
                     layer="ne_110m_graticules_15")
# convert spatial object into a ggplot ready, data.frame
graticule_df <- fortify(graticule)

bbox <- readOGR("Global/Boundaries/ne_110m_graticules_all", layer="ne_110m_wgs84_bounding_box")
bbox_df<- fortify(bbox)


latLongMap <- ggplot(bbox_df, aes(long,lat, group=group)) +
  geom_polygon(fill="white") +
  geom_polygon(data=worldBound_df, aes(long,lat, group=group, fill=hole)) +
  geom_path(data=graticule_df, aes(long, lat, group=group, fill=NULL), linetype="dashed", color="grey70") +
  labs(title="World Map - Geographic (long/lat degrees)") +
  coord_equal() + newTheme +
  scale_fill_manual(values=c("black", "white"), guide="none") # change colors & remove legend

latLongMap <- latLongMap + geom_point(data=loc.df,
                      aes(x=lon, y=lat, group=NULL),
                      colour="springgreen",
                      size=5)

# reproject grat into robinson
graticule_robin <- spTransform(graticule, CRS("+proj=robin"))  # reproject graticule
grat_df_robin <- fortify(graticule_robin)
bbox_robin <- spTransform(bbox, CRS("+proj=robin"))  # reproject bounding box
bbox_robin_df <- fortify(bbox_robin)

# plot using robinson

finalRobMap <- ggplot(bbox_robin_df, aes(long,lat, group=group)) +
  geom_polygon(fill="white") +
  geom_polygon(data=worldBound_df_robin, aes(long,lat, group=group, fill=hole)) +
  geom_path(data=grat_df_robin, aes(long, lat, group=group, fill=NULL), linetype="dashed", color="grey70") +
  labs(title="World Map Projected - Robinson (Meters)") +
  coord_equal() + newTheme +
  scale_fill_manual(values=c("black", "white"), guide="none") # change colors & remove legend

# add a point to the map
finalRobMap <- finalRobMap + geom_point(data=loc.rob,
                      aes(x=X, y=Y, group=NULL),
                      colour="springgreen",
                      size=5)


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

