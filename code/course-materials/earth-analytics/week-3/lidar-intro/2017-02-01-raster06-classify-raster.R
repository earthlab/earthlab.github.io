## ----setup, echo=FALSE---------------------------------------------------
knitr::opts_chunk$set(echo = TRUE, message = FALSE, warning=FALSE)

## ----load-libraries------------------------------------------------------
# load the raster and rgdal libraries
library(raster)
library(rgdal)

## ----open-raster---------------------------------------------------------
# open canopy height model
lidar_chm <- raster("data/week3/BLDR_LeeHill/outputs/lidar_chm.tif")

## ----view-sum-stats------------------------------------------------------
summary(lidar_chm)

## ----plot-histogram, fig.cap="histogram of lidar chm data"---------------
# plot histogram of data
hist(lidar_chm,
     main="Distribution of raster cell values in the DTM difference data",
     xlab="Height (m)", ylab="Number of Pixels",
     col="springgreen")


## ----hist-contrained, fig.cap="plot of chm histogram constrained above 0"----
# zoom in on x and y axis
hist(lidar_chm,
     xlim=c(2,25),
     ylim=c(0,4000),
     main="Histogram of canopy height model differences \nZoomed in to -2 to 2 on the x axis",
     col="springgreen")


## ----view-hist-info, fig.cap="histogram of lidar data - view data"-------
# see how R is breaking up the data
histinfo <- hist(lidar_chm)


## ----view-hist-stats-----------------------------------------------------
histinfo$counts
histinfo$breaks

## ----create-lidar-hist, fig.cap="histogram of lidar chm"-----------------
# zoom in on x and y axis
hist(lidar_chm,
     xlim=c(2,25),
     ylim=c(0,1000),
     breaks=100,
     main="Histogram of canopy height model differences \nZoomed in to -2 to 2 on the x axis",
     col="springgreen",
     xlab="Pixel value")

## ----histogram-breaks, fig.cap="histogram with custom breaks"------------
# We may want to explore breaks in our histogram before plotting our data
hist(lidar_chm,
     breaks=c(0, 5, 10, 15, 20, 30),
     main="Histogram with custom breaks",
     xlab="Height (m)" , ylab="Number of Pixels",
     col="springgreen")


## ----histogram-breaks2, fig.cap="histogram with custom breaks"-----------
# We may want to explore breaks in our histogram before plotting our data
hist(lidar_chm,
     breaks=c(0, 2, 4, 7, 30),
     main="Histogram with custom breaks",
     xlab="Height (m)" , ylab="Number of Pixels",
     col="springgreen")


## ----create-reclass------------------------------------------------------
# create classification matrix
reclass_df <- c(0, 2, NA,
              2, 4, 1,
             4, 7, 2,
             7, Inf, 3)
reclass_df

## ----create-matrix-------------------------------------------------------
# reshape the object into a matrix with columns and rows
reclass_m <- matrix(reclass_df,
                ncol=3,
                byrow=TRUE)
reclass_m


## ----reclassify-raster, warning=FALSE, message=FALSE---------------------
# reclassify the raster using the reclass object - reclass_m
chm_classified <- reclassify(lidar_chm,
                     reclass_m)


## ----barplot-pixels, fig.cap="create barplot of classified rasters"------
# view reclassified data
barplot(chm_classified,
        main="Number of pixels in each class")

## ----assign-na-value-----------------------------------------------------
# assign all pixels that equal 0 to NA or no data value
chm_classified[chm_classified==0] <- NA

## ----reclassify-plot-raster, fig.cap="classified chm plot"---------------
# plot reclassified data
plot(chm_classified,
     col=c("red", "blue", "green"))


## ----plot-w-legend, warning=FALSE, message=FALSE, fig.cap="classified chm with legend."----
# plot reclassified data
plot(chm_classified,
     legend=F,
     col=c("red", "blue", "green"), axes=F,
     main="Classified Canopy Height Model \n short, medium, tall trees")

legend("topright",
       legend = c("short trees", "medium trees", "tall trees"),
       fill = c("red", "blue", "green"),
       border = F,
       bty="n") # turn off legend border


## ----plot-w-legend-colors, fig.cap="classified chm with legend."---------
# create color object with nice new colors!
chm_colors <- c("palegoldenrod", "palegreen2", "palegreen4")

# plot reclassified data
plot(chm_classified,
     legend=F,
     col=chm_colors,
     axes=F,
     main="Classified Canopy Height Model \n short, medium, tall trees")

legend("topright",
       legend = c("short trees", "medium trees", "tall trees"),
       fill = chm_colors,
       border = F,
       bty="n")

## ----plot-w-legend-colors2, fig.cap="classified chm with legend."--------
# create color object with nice new colors!
chm_colors <- c("palegoldenrod", "palegreen2", "palegreen4")

# plot reclassified data
plot(chm_classified,
     legend=F,
     col=chm_colors,
     axes=F,
     box=F,
     main="Classified Canopy Height Model \n short, medium, tall trees")

legend("topright",
       legend = c("short trees", "medium trees", "tall trees"),
       fill = chm_colors,
       border = F,
       bty="n")

