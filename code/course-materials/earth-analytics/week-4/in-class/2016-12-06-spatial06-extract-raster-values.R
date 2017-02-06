## ----import-plot-DSM, warning=FALSE--------------------------------------
# load libraries
library(raster)
library(rgdal)
library(ggplot2)
library(dplyr)

options(stringsAsFactors = FALSE)

# set working directory
# setwd("path-here/earth-analytics")

## ----import-chm, fig.cap="histogram of CHM values"-----------------------
# import canopy height model (CHM).
SJER_chm <- raster("data/week4//california/SJER/2013/lidar/SJER_lidarCHM.tif")
SJER_chm

# plot the data
hist(SJER_chm,
     main="Histogram of Canopy Height\n NEON SJER Field Site",
     col="springgreen",
     xlab="Height (m)")


## ----view-histogram-na-0, fig.cap="histogram of chm values"--------------

# set values of 0 to NA as these are not trees
SJER_chm[SJER_chm==0] <- NA

# plot the modified data
hist(SJER_chm,
     main="Histogram of Canopy Height\n NEON SJER Field Site, 0 values set to NA",
     col="springgreen",
     xlab="Height (m)")


## ----read-plot-data, fig.cap="canopy height model / plot locations plot"----
# import plot centroids
SJER_plots <- readOGR("data/week4/california/SJER/vector_data",
                      "SJER_plot_centroids")


# Overlay the centroid points and the stem locations on the CHM plot
plot(SJER_chm,
     main="SJER  Plot Locations",
     col=gray.colors(100, start=.3, end=.9))

# pch 0 = square
plot(SJER_plots,
     pch = 16,
     cex = 2,
     col = 2,
     add=TRUE)


## ----extract-plot-data---------------------------------------------------

# Insitu sampling took place within 40m x 40m square plots, so we use a 20m radius.
# Note that below will return a dataframe containing the max height
# calculated from all pixels in the buffer for each plot
SJER_height <- extract(SJER_chm,
                    SJER_plots,
                    buffer = 20, # specify a 20 m radius
                    fun=mean, # extract the MEAN value from each plot
                    sp=TRUE, # create spatial object
                    stringsAsFactors=FALSE)


## ----explore-data-distribution, eval=FALSE-------------------------------
## 
## # cent_ovrList <- extract(chm,centroid_sp,buffer = 20)
## # create histograms for the first 5 plots of data
## # for (i in 1:5) {
## #  hist(cent_ovrList[[i]], main=(paste("plot",i)))
## #  }
## 

## ----unique-plots--------------------------------------------------------

# import the centroid data and the vegetation structure data
SJER_insitu <- read.csv("data/week4/california/SJER/2013/insitu/veg_structure/D17_2013_SJER_vegStr.csv",
                        stringsAsFactors = FALSE)

# get list of unique plots
unique(SJER_plots$Plot_ID)


## ----analyze-plot-dplyr--------------------------------------------------

# find the max and averagestem height for each plot
insitu_stem_height <- SJER_insitu %>%
  group_by(plotid) %>%
  summarise(insitu_max = max(stemheight), insitu_avg = mean(stemheight))

head(insitu_stem_height)

# let's create better, self documenting column headers
names(insitu_stem_height) <- c("plotid", "insituMaxHt")
head(insitu_stem_height)


## ----merge-dataframe-----------------------------------------------------

# merge the insitu data into the centroids data.frame
SJER_height <- merge(SJER_height,
                     insitu_stem_height,
                   by.x = 'Plot_ID',
                   by.y = 'plotid')

SJER_height@data


## ----create-spatial-plot, fig.cap="Plots sized by vegetation height"-----
# plot canopy height model
plot(SJER_chm,
     main="Vegetation Plots \nSymbol size by Average Tree Height",
     legend=F)

# add plot location sized by tree height
plot(SJER_height,
     pch=19,
     cex=(SJER_height$SJER_lidarCHM)/10, # size symbols according to tree height attribute normalized by 10
     add=T)

legend('bottomright',
       legend="plot location \nsized by tree height",
       pch=19,
       bty='n')


## ----plot-w-ggplot, fig.cap="ggplot - measured vs lidar chm."------------

# create plot
ggplot(SJER_height@data, aes(x=SJER_lidarCHM, y = insituMaxHt)) +
  geom_point() +
  theme_bw() +
  ylab("Maximum measured height") +
  xlab("Maximum LiDAR pixel")+
  geom_abline(intercept = 0, slope=1) +
  ggtitle("Lidar Height Compared to InSitu Measured Height")


## ----ggplot-data, fig.cap="Scatterplot measured height compared to lidar chm."----

# plot with regression fit
p <- ggplot(SJER_height@data, aes(x=SJER_lidarCHM, y = insituMaxHt)) +
  geom_point() +
  ylab("Maximum Measured Height") +
  xlab("Maximum LiDAR Height")+
  geom_abline(intercept = 0, slope=1)+
  geom_smooth(method=lm)

p + theme(panel.background = element_rect(colour = "grey")) +
  ggtitle("LiDAR CHM Derived vs Measured Tree Height") +
  theme(plot.title=element_text(family="sans", face="bold", size=20, vjust=1.9)) +
  theme(axis.title.y = element_text(family="sans", face="bold", size=14, angle=90, hjust=0.54, vjust=1)) +
  theme(axis.title.x = element_text(family="sans", face="bold", size=14, angle=00, hjust=0.54, vjust=-.2))


## ----view-diff, fig.cap="box plot showing differences between chm and measured heights."----

SJER_height@data$ht_diff <-  (SJER_height@data$SJER_lidarCHM - SJER_height@data$insituMaxHt)

# base plot example below
# barplot(SJER_height@data$ht_diff,
#        xlab = SJER_height@data$Plot_ID)


# create bar plot using ggplot()
ggplot(data=SJER_height@data, aes(x=Plot_ID, y=ht_diff, fill=Plot_ID)) +
    geom_bar(stat="identity")


## ----create-plotly, eval=FALSE-------------------------------------------
## 
## library(plotly)
## 
## # you must be signed into Plot.ly online on the same computer for this code to work.
## # generate the plot
## ggplotly(p,
##         filename='NEON SJER CHM vs Insitu Tree Height')
## 
## 

