## ------------------------------------------------------------------------

# set working dir
setwd("~/Documents/earth-analytics")

# load spatial packages
library(raster)
library(rgdal)
library(rgeos)
library(RColorBrewer)
# turn off factors
options(stringsAsFactors = F)

# set colors

nbr_colors = c("palevioletred4","palevioletred1","ivory1","seagreen1","seagreen4")
ndvi_colors = c("brown","ivory1","seagreen1","seagreen4")

# get list of tif files
all_landsat_bands <- list.files("data/week6/Landsat/LC80340322016189-SC20170128091153/crop",
                                pattern=glob2rx("*band*.tif$"),
                                full.names = T)

# stack the data (create spatial object)
landsat_stack_csf <- stack(all_landsat_bands)

# calculate normalized index - NDVI
landsat_ndvi <- (landsat_stack_csf[[5]] - landsat_stack_csf[[4]]) / (landsat_stack_csf[[5]] + landsat_stack_csf[[4]])

# create classification matrix
# note i line it up like this so it looks more like the arcgis reclass table!
reclass <- c(-1, -.2, 1,
             -.2, .2, 2,
             .2, .5, 3,
             .5, 1, 4)
# reshape the object into a matrix with columns and rows
reclass_m <- matrix(reclass,
                    ncol=3,
                    byrow=TRUE)

ndvi_classified <- reclassify(landsat_ndvi,
                             reclass_m)

# set colors
the_colors = c("palevioletred4","palevioletred1","ivory1","seagreen1","seagreen4")
# plot classified data
plot(ndvi_classified,
     box=F, axes=F, legend=F,
     main="NDVI - Pre fire")
legend(ndvi_classified@extent@xmax, ndvi_classified@extent@ymax,
       legend=c("class one", "class two", "class three"),
       fill = the_colors, bty="n", xpd=T)


## ------------------------------------------------------------------------
# calculate normalized index = NBR
landsat_nbr <- (landsat_stack_csf[[4]] - landsat_stack_csf[[7]]) / (landsat_stack_csf[[4]] + landsat_stack_csf[[7]])

# create classification matrix
reclass <- c(-1.0, -.1, 1,
             -.1, .1, 2,
             .1, .27, 3,
             .27, .66, 4,
             .66, 1.3, 5)
# reshape the object into a matrix with columns and rows
reclass_m <- matrix(reclass,
                ncol=3,
                byrow=TRUE)

nbr_classified <- reclassify(landsat_nbr,
                     reclass_m)

# plot classified data
plot(ndvi_classified,
     box=F, axes=F, legend=F,
     main="Landsat NBR - Pre Fire \n Julian Day 189")
legend(nbr_classified@extent@xmax-100, nbr_classified@extent@ymax,
       c("Enhanced Regrowth", "Unburned", "Low Severity", "Moderate Severity", "High Severity"),
       fill=rev(the_colors),
       cex=.9, bty="n", xpd=T)

## ---- eval=F-------------------------------------------------------------
## # code to go here

