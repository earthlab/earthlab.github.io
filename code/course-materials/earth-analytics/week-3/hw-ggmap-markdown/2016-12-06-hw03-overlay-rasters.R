## ----ggmap-setup, message=FALSE, warning=FALSE---------------------------
# load raster and rgdal libraries for spatial data
library(raster)
library(rgdal)


## ----create-base-map, fig.cap="overlay plot", warning=FALSE, message=FALSE----
# open raster DTM data
lidar_dem <- raster(x="data/week3/BLDR_LeeHill/pre-flood/lidar/pre_DTM.tif")

# open dem hillshade
lidar_dem_hill <- raster(x="data/week3/BLDR_LeeHill/pre-flood/lidar/pre_DTM_hill.tif")

# plot raster data
plot(lidar_dem_hill,
     main="Lidar Digital Elevation Model (DEM)",
     col=grey(1:100/100),
     legend=F)

plot(lidar_dem,
     main="Lidar Digital Elevation Model (DEM)",
     add=T, alpha=.5)


