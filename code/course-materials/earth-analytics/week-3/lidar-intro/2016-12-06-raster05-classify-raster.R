## ----create-matrix-------------------------------------------------------

# create classification matrix
class.m <- c(0, 10, 1,
             10, 20, 2,
             20, 35, 3)
class.m

# reshape the object into a matrix with columns and rows
rcl.m <- matrix(class.m,
                ncol=3,
                byrow=TRUE)
rcl.m


## ----reclassify-raster---------------------------------------------------
# open canopy height model
lidar_chm <- raster("data/week3/outputs/lidar_chm.tif")

# reclassify the raster using the reclass object - rcl.m
chm_classified <- reclassify(lidar_chm,
                     rcl.m)
# plot reclassified data
plot(chm_classified,
     col=c("red", "blue", "green"))


## ----plot-w-legend-------------------------------------------------------
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


