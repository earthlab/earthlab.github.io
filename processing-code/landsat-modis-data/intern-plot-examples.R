# plot # load spatial packages
library(raster)
library(rgdal)
library(rgeos)
library(RColorBrewer)
# turn off factors
options(stringsAsFactors = F)



## Load fire boundary 

setwd("~/Documents/earth-analytics")

all_landsat_bands <- list.files("data/week6/Landsat/LC80340322016205-SC20170127160728/crop",
                                pattern=glob2rx("*band*.tif$"),
                                full.names = T) # use the dollar sign at the end to get all files that END WITH


# stack the data
landsat_stack_csf_post <- stack(all_landsat_bands)


# import shapefile.
fire_boundary <- readOGR("data/week6/vector_layers/fire-boundary-geomac/co_cold_springs_20160711_2200_dd83.shp")
fire_boundary_utm <- spTransform(fire_boundary, CRS=crs(landsat_stack_csf_post))


# calculate NDVI
landsat_ndvi <- (landsat_stack_csf_post[[5]] - landsat_stack_csf_post[[4]]) / (landsat_stack_csf_post[[5]] + landsat_stack_csf_post[[4]])
plot(landsat_ndvi,
     main="NDVI")

plot(landsat_ndvi,
     main="Landsat derived NDVI\n 23 July 2016")

##### PRE FIRE ######################
## Pre-fire

all_landsat_bands_pre <- list.files("data/week6/Landsat/LC80340322016173-SC20170227185411/",
                                pattern=glob2rx("*band*.tif$"),
                                full.names = T) # use the dollar sign at the end to get all files that END WITH


# stack the data
landsat_stack_csf_pre <- stack(all_landsat_bands_pre)
landsat_stack_csf_pre <- crop(landsat_stack_csf_pre, extent(landsat_stack_csf_post))


# calculate NDVI
landsat_ndvi_pre <- (landsat_stack_csf_pre[[5]] - landsat_stack_csf_pre[[4]]) / (landsat_stack_csf_pre[[5]] + landsat_stack_csf_pre[[4]])

plot(landsat_ndvi_pre,
     main="Landsat derived NDVI\n 7 July 2016")

# calculate difference

ndvi_diff <- landsat_ndvi - landsat_ndvi_pre


# create classification matrix
reclass <- c(-1, -.2, 1,
             -.2, .2, 2,
             .2, 1, 3)
# reshape the object into a matrix with columns and rows
reclass_m <- matrix(reclass,
                    ncol=3,
                    byrow=TRUE)

ndvi_diff_rcl <- reclassify(ndvi_diff,
                             reclass_m)
 

# use this map for the "bad example" 
plot(ndvi_diff)

plot(ndvi_diff_rcl,
     main="ndvi difference")

plot(ndvi_diff_rcl,
     main="Change in greeness: Post vs pre Fire \n Landsat NDVI - Cold springs Fire July 2016")
barplot(ndvi_diff_rcl,
        col=the_colors)

## Nice reclassified map
the_colors = c("palevioletred4","ivory1","seagreen4")
dev.off()
par(xpd=F, mar=c(1,0,4,12), cex.main=1.5)
plot(ndvi_diff_rcl,
     main="Change in greeness\n Post vs pre Fire",
     legend=F, box=F, axes=F,
     col=the_colors)
mtext("Landsat NDVI - Cold springs Fire July 2016")
plot(fire_boundary_utm, add=T,
     border="blue", lwd=2, lty=4)
plot(extent(ndvi_diff_rcl), 
     lwd=2,
     add=T)
legend(ndvi_diff_rcl@extent@xmax-100, ndvi_diff_rcl@extent@ymax,
       c("Decrease (< -.2)", "No change (-.2-.2)", "Increase (>.2)", "Fire Border"),
       pch=c(15, 15, 15, NA),
       col=the_colors,
       cex=1.3,
       bty="n",
       lty=c(NA, NA, NA, 4),
       xpd = TRUE)
legend(ndvi_diff_rcl@extent@xmax-100, ndvi_diff_rcl@extent@ymax,
       c("", "", "", ""),
       pch=c(22, 22, 22, NA),
       col="black",
       cex=1.3,
       bty="n",
       lty=c(NA, NA, NA, 4),
       xpd = TRUE)



################# NBR PLOTS ##############

# calculate NDVI
landsat_nbr_pre <- (landsat_stack_csf_pre[[5]] - landsat_stack_csf_pre[[7]]) / (landsat_stack_csf_pre[[5]] + landsat_stack_csf_pre[[7]])

plot(landsat_nbr_pre,
     main=" NBR")


landsat_nbr_post <- (landsat_stack_csf_post[[5]] - landsat_stack_csf_post[[7]]) / (landsat_stack_csf_post[[5]] + landsat_stack_csf_post[[7]])

plot(landsat_nbr_post,
     main="NBR")


plot(landsat_nbr_pre,
     main="Landsat derived NBR\n 7 July 2016")
plot(landsat_nbr_post,
     main="Landsat derived NBR\n 23 July 2016")

cols <- brewer.pal(11,"PiYG")
colfunc <- colorRampPalette(c(cols))

display.brewer.all()
par(mfrow=c(1,2), mar = c(0, 0, 3, 5), oma = c(0, 0, 3, 0))
plot(landsat_nbr_pre,
     main="7 July 2016",
     axes=F, box=F,
     zlim=c(-.7,.91),
     legend=F, col=colfunc(100))
plot(fire_boundary_utm, add=T)
plot(landsat_nbr_post,
     axes=F, box=F,
     zlim=c(-.7,.91),
     main="23 July 2016",
     col=colfunc(100))
plot(fire_boundary_utm, add=T)
title("Lansat derived NBR \n Cold Springs Fire Site - Nederland, CO", outer=TRUE)


