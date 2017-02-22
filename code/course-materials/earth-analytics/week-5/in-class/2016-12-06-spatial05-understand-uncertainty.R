## ----standard-error, fig.cap="Distribution of tree heights."-------------
# create data frame containing made up tree heights
tree_heights <- data.frame(heights=c(10, 10.1, 9.9, 9.5, 9.7, 9.8,
                                     9.6, 10.5, 10.7, 10.3, 10.6))
# what is the average tree height
mean(tree_heights$heights)
# what is the standard deviation of measurements?
sd(tree_heights$heights)
boxplot(tree_heights$heights,
        main="Distribution of tree height measurements (m)",
        ylab="Height (m)",
        col="springgreen")


## ----hist-tree-height, fig.cap="Tree height distribution"----------------
# view distribution of tree height values
hist(tree_heights$heights, breaks=c(9,9.6,10.4,11),
     main="Distribution of measured tree height values",
     xlab="Height (m)", col="purple")


## ----uncertainty-lidar, echo=F, warning=FALSE, message=FALSE, results = "hide"----

# load libraries
library(raster)
library(rgdal)
library(rgeos)
library(ggplot2)
library(dplyr)

options(stringsAsFactors = FALSE)
SJER_chm <- raster("data/week5/california/SJER/2013/lidar/SJER_lidarCHM.tif")


SJER_chm[SJER_chm==0] <- NA

SJER_plots <- readOGR("data/week5/california/SJER/vector_data",
                      "SJER_plot_centroids")

# extract max height
SJER_height <- extract(SJER_chm,
                    SJER_plots,
                    buffer = 20, # specify a 20 m radius
                    fun=max, # extract the MEAN value from each plot
                    sp=TRUE, # create spatial object
                    stringsAsFactors=FALSE)

# import the centroid data and the vegetation structure data
SJER_insitu <- read.csv("data/week5/california/SJER/2013/insitu/veg_structure/D17_2013_SJER_vegStr.csv",
                        stringsAsFactors = FALSE)

# find the max and mean stem height for each plot
insitu_stem_height <- SJER_insitu %>%
  group_by(plotid) %>%
  summarise(insitu_max = max(stemheight))

# merge the insitu data into the centroids data.frame
SJER_height <- merge(SJER_height,
                     insitu_stem_height,
                   by.x = 'Plot_ID',
                   by.y = 'plotid')

## ----ggmap, echo=F, warning=F, message=F, results = "hide"---------------
library(ggmap)
cali_map <- get_map(location = "California",
          source="google",
          maptype="terrain", crop=FALSE,
          zoom=6)

# creating a sample data.frame with your lat/lon points
lon <- c(SJER_chm@extent@xmin)
lat <- c(SJER_chm@extent@ymin)

# import us data
state_boundary_us <- readOGR("data/week5/usa-boundary-layers",
          "US-State-Boundaries-Census-2014")
df <- as.data.frame(cbind(lon,lat))
site_location <- SpatialPoints(df, proj4string = crs(SJER_chm))
site_location_wgs84 <- spTransform(site_location, CRSobj = crs(state_boundary_us))

site_locat_points <- as.data.frame(coordinates(site_location_wgs84))

## ----ggmap-plot, echo=F, warning=F, message=F, results = "hide", fig.cap="ggmap of study area."----
# create a map with a point location for boulder.
ggmap(cali_map) + labs(x = "", y = "") +
  geom_point(data = site_locat_points, aes(x = lon, y = lat, fill = "red", alpha = 0.2), size = 5, shape = 19) +
  guides(fill=FALSE, alpha=FALSE, size=FALSE)


## ----plot-plots, fig.cap="plots", echo=F---------------------------------
# Overlay the centroid points and the stem locations on the CHM plot
plot(SJER_chm,
     main="Study area plot locations",
     col=gray.colors(100, start=.3, end=.9),
     legend=F,
     box=F, # turn off black border
     axes=F) # turn off axis labels and ticks

# pch 0 = square
plot(SJER_plots,
     pch = 15,
     cex = 2,
     col = "magenta",
     add=TRUE)
par(xpd=T)
legend(SJER_chm@extent@xmax+100, SJER_chm@extent@ymax,
       legend="Plot \nlocations",
       pch = 15,
       col = "magenta",
       bty="n")


## ----plot-data, fig.cap="final plot", echo=F, warning=F, message=F-------

# create plot
p <-ggplot(SJER_height@data, aes(x = insitu_max, y=SJER_lidarCHM)) +
  geom_point() +
  theme_bw() +
  xlab("Mean measured height (m)") +
  ylab("Mean LiDAR pixel (m)") +
  ggtitle("Lidar Derived Max Tree Height \nvs. InSitu Measured Max Tree Height") +
  geom_abline(intercept = 0, slope=1) +
  geom_smooth(method=lm)

p


## ----view-diff, echo=F, fig.cap="box plot showing differences between chm and measured heights."----
# Calculate difference
SJER_height@data$ht_diff <-  (SJER_height@data$SJER_lidarCHM - SJER_height@data$insitu_max)
SJER_height@data$Plot_ID <- gsub("SJER", "", SJER_height@data$Plot_ID)
# create bar plot using ggplot()
ggplot(data=SJER_height@data,
       aes(x=Plot_ID, y=ht_diff, fill=Plot_ID)) +
       geom_bar(stat="identity") +
       xlab("Plot Name") + ylab("Height difference (m)") +
       ggtitle("Difference: \nLidar Max height - in situ Max height (m)")


## ----ggplotly, echo=F, eval=F--------------------------------------------
## library(plotly)
## 
## Sys.setenv("plotly_username"="leahawasser")
## Sys.setenv("plotly_api_key"="#")
## 
## plotly_POST(p)
## 

