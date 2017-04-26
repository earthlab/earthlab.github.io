## ---- geographic-WGS84, echo=FALSE, message=FALSE, results='hide'--------

# read grat shapefile
worldGrat30 <- readOGR(dsn="../../Global/Boundaries/ne_110m_graticules_all",
                      layer="ne_110m_graticules_30")
# convert to dataframe
worldGrat30_df <- fortify(worldGrat30)

#import box
wgs84Box <- readOGR("../../Global/Boundaries/ne_110m_graticules_all",
                    layer="ne_110m_wgs84_bounding_box")
wgs84Box_df<- fortify(wgs84Box)

#plot data
ggplot(wgs84Box_df, aes(long,lat, group=group)) +
  geom_polygon(fill="white") +
  xlab("Longitude (Degrees)") + ylab("Latitude (Degrees)") +
  ggtitle("World Map - Geographic WGS84 (lat/lon)") +
  geom_polygon(data=worldBound_df, aes(long,lat, group=group, fill=hole))+
  geom_path(data=worldGrat30, aes(long, lat, group=group, fill=NULL), linetype="dashed", color="grey50") +
  labs(title="World map + graticule (longlat)") +
  coord_equal() +
  scale_fill_manual(values=c("black", "white"), guide="none") # change colors &

