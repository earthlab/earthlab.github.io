## ----load-libraries, warning=FALSE, message=FALSE------------------------
# load the raster and rgdal libraries
library(raster)
library(rgdal)

## ----create-matrix-------------------------------------------------------
# create classification matrix
reclass_df <- c(0, 10, 1,
             10, 20, 2,
             20, 35, 3)
reclass_df

# reshape the object into a matrix with columns and rows
reclass_m <- matrix(reclass_df,
                ncol=3,
                byrow=TRUE)
reclass_m


## ----reclassify-raster, warning=FALSE, message=FALSE, fig.cap="classified chm plot"----
# open canopy height model
lidar_chm <- raster("data/week3/BLDR_LeeHill/outputs/lidar_chm.tif")

# reclassify the raster using the reclass object - reclass_m
chm_classified <- reclassify(lidar_chm,
                     reclass_m)
# plot reclassified data
plot(chm_classified,
     col=c("red", "blue", "green"))


## ----plot-w-legend, warning=FALSE, message=FALSE, fig.cap="classified chm with legend."----
# plot reclassified data
plot(chm_classified,
     legend=F,
     col=c("red", "blue", "green"), axes=F,
     main="Canopy Height Model - Classified: short, medium, tall trees")

legend("topright",
       legend = c("short trees", "medium trees", "tall trees"),
       fill = c("red", "blue", "green"),
       border = F,
       bty="n") # turn off legend border


