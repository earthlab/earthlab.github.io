## ----setup, echo=FALSE---------------------------------------------------
knitr::opts_chunk$set(echo = TRUE, message = FALSE, warning=FALSE)

## ---- geographic-WGS84, echo=FALSE, message=FALSE, results='hide'--------
# read shapefile
worldBound <- readOGR(dsn="data/week5/global/ne_110m_land",
                      layer="ne_110m_land")

# convert to dataframe
worldBound_df <- fortify(worldBound)

# read grat shapefile
worldGrat30 <- readOGR(dsn="data/week5/global/ne_110m_graticules_all/ne_110m_graticules_30.shp")
# convert to dataframe
worldGrat30_df <- fortify(worldGrat30)

#import box
wgs84Box <- readOGR("data/week5/global/ne_110m_graticules_all/ne_110m_wgs84_bounding_box.shp")
wgs84Box_df<- fortify(wgs84Box)

#plot data
ggplot(wgs84Box_df, aes(long,lat, group=group)) +
  geom_polygon(fill="white") +
  geom_polygon(data=worldBound_df, aes(long,lat, group=group, fill=hole))+
  geom_path(data=worldGrat30, aes(long, lat, group=group, fill=NULL), linetype="dashed", color="grey50") +
  labs(title="World Map - Geographic WGS84 (lat/lon)",
    x="Longitude (Degrees)",
    y="Latitude (Degrees)") +
  coord_equal() +
  scale_fill_manual(values=c("black", "white"), guide="none") # change colors &


## ------------------------------------------------------------------------
# create a data.frame with the x,y location
boulder_df <- data.frame(lon=c(476911.31),
                lat=c(4429455.35))

# plot boulder
ggplot() +
                geom_point(data=boulder_df,
                aes(x=lon, y=lat, group=NULL), colour = "springgreen",
                      size=5)
# convert to spatial points
coordinates(boulder_df) <- 1:2

class(boulder_df)
crs(boulder_df)

# assign crs - we know it is utm zone 13N
crs(boulder_df) <- CRS("+init=epsg:2957")

## ----echo=FALSE----------------------------------------------------------
boulder_crs <- crs(boulder_df)

## ------------------------------------------------------------------------
boulder_df_geog <- spTransform(boulder_df, crs(worldBound))
coordinates(boulder_df_geog)

## ------------------------------------------------------------------------
boulder_df_geog <- as.data.frame(coordinates(boulder_df_geog))
# plot map
worldMap <- ggplot(worldBound_df, aes(long,lat, group=group)) +
  geom_polygon() +
  xlab("Longitude (Degrees)") + ylab("Latitude (Degrees)") +
  coord_equal() +
  ggtitle("Global Map - Geographic Coordinate System - WGS84 Datum\n Units: Degrees - Latitude / Longitude")

# map boulder
worldMap +
        geom_point(data=boulder_df_geog,
        aes(x=lon, y=lat, group=NULL), colour = "springgreen", size=5)

