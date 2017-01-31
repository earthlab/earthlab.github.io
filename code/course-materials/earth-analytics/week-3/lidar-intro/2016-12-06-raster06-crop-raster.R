## ----load-libraries, warning=FALSE, message=FALSE------------------------
# load the raster and rgdal libraries
library(raster)
library(rgdal)

## ----open-raster, warning=FALSE, message=FALSE, fig.cap="lidar chm plot"----
# open raster layer
lidar_chm <- raster("data/week3/BLDR_LeeHill/outputs/lidar_chm.tif")

# plot CHM
plot(lidar_chm,
     col=rev(terrain.colors(50)))


## ----plot-w-legend, warning=FALSE, message=FALSE, fig.cap="shapefile crop extent plot"----
# import the vector boundary
crop_extent <- readOGR("data/week3/BLDR_LeeHill/", 
                       "clip-extent")

# plot imported shapefile
# notice that we use add=T to add a layer on top of an existing plot in R. 
plot(crop_extent, 
     main="Shapefile imported into R - crop extent", 
     axes=T,
     border="blue")

## ----crop-and-plot-raster, fig.cap="lidar chm cropped with vector extent on top"----
# crop the lidar raster using the vector extent
lidar_chm_crop <- crop(lidar_chm, crop_extent)
plot(lidar_chm_crop, main="Cropped lidar chm")

# add shapefile on top of the existing raster
plot(crop_extent, add=T)


