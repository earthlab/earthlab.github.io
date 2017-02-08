## ----setup---------------------------------------------------------------
# load libraries
library(raster)
library(rgdal)

# set working directory
setwd("~/Documents/earth-analytics")

## ----load-data-----------------------------------------------------------
# load data
pre_dtm <- raster("data/week3/BLDR_LeeHill/pre-flood/lidar/pre_DTM.tif")
pre_dsm <- raster("data/week3/BLDR_LeeHill/pre-flood/lidar/pre_DSM.tif")

post_dtm <- raster("data/week3/BLDR_LeeHill/post-flood/lidar/post_DTM.tif")
post_dsm <- raster("data/week3/BLDR_LeeHill/post-flood/lidar/post_DSM.tif")

# import crop extent
crop_ext <- readOGR("data/week3/BLDR_LeeHill", "clip-extent")


## ----diff-data-----------------------------------------------------------
# calculate dtm difference
dtm_diff_uncropped <- post_dtm - pre_dtm
plot(dtm_diff_uncropped)

## ----crop-data, fig.cap="cropped data"-----------------------------------
# crop the data
dtm_diff <- crop(dtm_diff_uncropped, crop_ext)
plot(dtm_diff,
     main="cropped data")

# get a quick glimpse at some of the values for a particular "row"
# note there are a LOT of values in this raster so this won't print all values.
# below i used the head() function to limit the n umber of values returned to 6.
# that way a lot of numbers don't print out in my final knitr output.
head(getValues(dtm_diff, row = 5))

# view max data values
dtm_diff@data@max
dtm_diff@data@min

## ----plot-histogram, fig.cap="initial histogram"-------------------------
# plot histogram of data
hist(dtm_diff,
     main="distribution of raster cell values in the data",
     xlab="Height (m)")

## ----plot-histogram-xlim, fig.cap="initial histogram w xlim to zoom in"----
hist(dtm_diff,
     xlim=c(-2,2),
     main="histogram \nzoomed in to -2 to 2 on the x axis",
     col="brown")

# see how R is breaking up the data
histinfo <- hist(dtm_diff)
histinfo

# how many breaks does R use in the default histogram
length(histinfo$breaks)

# summarize values in the data
summary(dtm_diff, na.rm=T)


## ----plot-histogram-breaks, fig.cap="initial histogram w xlim to zoom in and breaks"----
# where are most of our values?
hist(dtm_diff,
     xlim=c(-2,2),
     breaks=500,
     main="histogram \nzoomed in to -2-2 on the x axis w more breaks")

## ----plot-histogram-breaks2, fig.cap="histogram w custom breaks"---------
# We may want to explore breaks in our histogram before plotting our data
hist(dtm_diff,
     breaks=c(-20, -10, -3, -.5, .5, 3, 10, 50),
     main="Histogram with custom breaks",
     xlab="Height (m)",
     col="springgreen")


## ----plot-data, fig.cap="Plot difference dtm."---------------------------
# plot dtm difference with breaks
plot(dtm_diff,
     breaks=c(-20, -10, -3, -1, 1, 3, 10, 50),
     col=terrain.colors(7))

## ----set-colors----------------------------------------------------------
# how many breaks do we have?
# NOTE: we will have one less break than the length of this vector
length(c(-20,-10,-3,-1, 1, 3, 10, 50))

## ----plot-with-unique-colors, fig.cap="Plot difference dtm with custom colors."----
# create a vector of colors - one for each "bin" of raster cells
new_colors <- c("palevioletred4", "palevioletred2", "palevioletred1", "ivory1",
                "seagreen1","seagreen2","seagreen4")

plot(dtm_diff,
     breaks=c(-20, -10, -3, -.5, .5, 3, 10, 50),
     col=new_colors,
     legend=F,
     main="Plot of DTM differences\n custom colors")

# make sure legend plots outside of the plot area
par(xpd=T)
# add the legend to the plot
legend(x=dtm_diff@extent@xmax, y=dtm_diff@extent@ymax, # legend location
       legend=c("-20 to -10", "-10 to -3",
                "-3 to -.5", "-.5 to .5",
                ".5 to 3", "3 to 10", "10 to 50"),
       fill=new_colors,
       bty="n",
       cex=.7)


## ----create-new-extent, fig.cap="cropped dtm subset"---------------------

# new_extent <- drawExtent()
new_extent <- extent(473690, 474155.2, 4434849, 4435204)
new_extent
# crop the raster to a smaller area
dtm_diff_crop <- crop(dtm_diff, new_extent)

# Plot the cropped raster
plot(dtm_diff_crop,
     breaks=c(-20, -10, -3, -1, 1, 3, 10, 50),
     col=new_colors,
     legend=F,
     main="Lidar DTM Difference \n cropped subset")

# grab the upper right hand corner coordinates to place the legend.
legendx <- dtm_diff_crop@extent@xmax
legendy <- dtm_diff_crop@extent@ymax

par(xpd=TRUE)
legend(legendx+100, legendy,
       legend=c("-20 to -10", "-10 to -3",
                "-1 to 1", "1 to 3", "3 to 10", "10 to 50"),
       fill=new_colors,
       bty="n",
       cex=.8)

## ----clear-par-settings--------------------------------------------------
dev.off()

## ----classify-data-------------------------------------------------------

# -20,-10,-3,-1, 1, 3, 10, 50
# create reclass vector
reclass_vector <- c(-20,-10, -3,
                    -10,-3, -2,
                    -3, -.5, -1,
                    -.5, .5, 0,
                    .5, 3, 1,
                    3, 10, 2,
                    10, 50, 3)

reclass_matrix <- matrix(reclass_vector,
                         ncol=3,
                         byrow = T)

reclass_matrix


## ----reclassify-raster-diff, fig.cap="final plot"------------------------

diff_dtm_rcl <- reclassify(dtm_diff, reclass_matrix)

plot(diff_dtm_rcl,
     col=new_colors,
     legend=F)
par(xpd=T)
legend(dtm_diff@extent@xmax, dtm_diff@extent@ymax,
       legend=c("-20 to -10", "-10 to -3", "-3 to -.5",
                "-.5 to .5", "1 to 3", "3 to 10", "10 to 50"),
       fill=new_colors,
       bty="n",
       cex=.8)

## ----histogram-of-diff-rcl, fig.cap="histogram of differences"-----------
hist(diff_dtm_rcl,
     main="Histogram of reclassified data",
     xlab="Height Class")


## ----reclass, fig.cap="histogram of final cleaned data"------------------
# create a new raster object
diff_dtm_rcl_na <- diff_dtm_rcl
# assign values between -.5 and .5 to NA
diff_dtm_rcl_na[diff_dtm_rcl_na >= -.5 & diff_dtm_rcl_na <= .5] <- NA
# view histogram
hist(diff_dtm_rcl_na,
     main="Histogram of data \n values between -.5 and .5 set to NA",
     xlab="Difference Class")

# view summary of data
summary(diff_dtm_rcl_na)

