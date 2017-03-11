## ----load-packages, warning=F, message=F, results='hide'-----------------
# load spatial packages
library(raster)
library(rgdal)
library(rgeos)
library(RColorBrewer)
# turn off factors
options(stringsAsFactors = F)

## ----create-landsat-stack------------------------------------------------
# create stack
all_landsat_bands_pre <- list.files("data/week6/Landsat/LC80340322016189-SC20170128091153/crop",
           pattern=glob2rx("*band*.tif$"),
           full.names = T) # use the dollar sign at the end to get all files that END WITH
all_landsat_bands_pre

# stack the data
landsat_stack_pre <- stack(all_landsat_bands_pre)

## ----calculate-nbr, echo=F, fig.cap="landsat derived NDVI plot"----------
# Landsat 8 requires bands 7 and 5
landsat_nbr_pre <- ((landsat_stack_pre[[5]] - landsat_stack_pre[[7]]) / (landsat_stack_pre[[5]] + landsat_stack_pre[[7]]))

plot(landsat_nbr_pre,
     main="Landsat derived Normalized Burn Index (NBR)\n Pre-fire - you will need to figure out the date using the Julian Day",
     axes=F,
     box=F)

## ----export-rasters, eval=F----------------------------------------------
## writeRaster(x = landsat_nbr_pre,
##               filename="data/week6/outputs/landsat_nbr",
##               format = "GTiff", # save as a tif
##               datatype='INT2S', # save as a INTEGER rather than a float
##               overwrite = T)

## ----create-landsat-stack-post-------------------------------------------
all_landsat_bands_post <- list.files("data/week6/Landsat/LC80340322016205-SC20170127160728/crop",
           pattern=glob2rx("*band*.tif$"),
           full.names = T) # use the dollar sign at the end to get all files that END WITH
all_landsat_bands_post

# stack the data
landsat_stack_post <- stack(all_landsat_bands_post)

## ----calculate-nbr-post, echo=F, fig.cap="landsat derived NBR post fire"----
# Landsat 8 requires bands 7 and 5
landsat_nbr_post <- ((landsat_stack_post[[5]] - landsat_stack_post[[7]]) / (landsat_stack_post[[5]] + landsat_stack_post[[7]]))

plot(landsat_nbr_post,
     main="Landsat derived Normalized Burn Index (NBR)\n Post Fire",
     axes=F,
     box=F)

## ---- fig.cap="Difference NBR map"---------------------------------------
# calculate difference
landsat_nbr_diff <- landsat_nbr_pre - landsat_nbr_post
plot(landsat_nbr_diff,
     main="Difference NBR map \n Pre minus post Cold Springs fire",
     axes=F, box=F)

## ----classify-output, echo=F---------------------------------------------
# create classification matrix
reclass <- c(-Inf, -.1, 1,
             -.1, .1, 2,
             .1, .27, 3,
             .27, .66, 4,
             .66, Inf , 5)
# reshape the object into a matrix with columns and rows
reclass_m <- matrix(reclass,
                ncol=3,
                byrow=TRUE)

nbr_classified <- reclassify(landsat_nbr_diff,
                     reclass_m)
the_colors = c("seagreen4", "seagreen1", "ivory1", "palevioletred1", "palevioletred4")

## ----classify-output-plot, echo=F, fig.cap="classified NBR output"-------
# mar bottom, left, top and right
par(xpd = F, mar=c(0,0,2,5))
plot(nbr_classified,
     col=the_colors,
     legend=F,
     axes=F,
     box=F,
     main="Landsat NBR - Cold Spring fire site \n Add date of the data here")
par(xpd = TRUE)
legend(nbr_classified@extent@xmax-100, nbr_classified@extent@ymax,
       c("Enhanced Regrowth", "Unburned", "Low Severity", "Moderate Severity", "High Severity"),
       fill=the_colors,
       cex=.9,
       bty="n")


## ----classify-output-plot2, echo=F, fig.cap="classified NBR output", results='hide'----
fire_boundary <- readOGR("data/week6/vector_layers/fire-boundary-geomac/co_cold_springs_20160711_2200_dd83.shp")
# reproject shapefile
fire_boundary_utm <- spTransform(fire_boundary, crs(nbr_classified))


# mar bottom, left, top and right
par(xpd = F, mar=c(0,0,2,5))
plot(nbr_classified,
     col=the_colors,
     legend=F,
     axes=F,
     box=F,
     main="Landsat NBR - Cold Spring fire site \n Add date of the data here")
plot(fire_boundary_utm, add=T,
     lwd=5)
par(xpd = TRUE)
legend(nbr_classified@extent@xmax-100, nbr_classified@extent@ymax,
       c("Enhanced Regrowth", "Unburned", "Low Severity", "Moderate Severity", "High Severity", "Fire boundary"),
       col=c(rev(the_colors), "black"),
       pch=c(15,15, 15, 15, 15,NA),
       lty = c(NA, NA, NA, NA, NA, 1),
       cex=.8,
       bty="n",
       pt.cex=c(1.75))
legend(nbr_classified@extent@xmax-100, nbr_classified@extent@ymax,
       c("Enhanced Regrowth", "Unburned", "Low Severity", "Moderate Severity", "High Severity", "Fire boundary"),
       col=c("black"),
       pch=c(22, 22, 22, 22, 22, NA),
       lty = c(NA, NA, NA, NA, NA, 1),
       cex=.8,
       bty="n",
       pt.cex=c(1.75))


## ----dev-off1, echo=F, warning=F, message=F, results="hide"--------------
dev.off()

## ----new-legend, eval=F--------------------------------------------------
## 
## legend(nbr_classified@extent@xmax-100, nbr_classified@extent@ymax,
##        c("Enhanced Regrowth", "Unburned", "Low Severity", "Moderate Severity", "High Severity", "Fire boundary"),
##        col=c(rev(the_colors), "black"),
##        pch=c(15,15, 15, 15, 15,NA),
##        lty = c(NA, NA, NA, NA, NA, 1),
##        cex=.8,
##        bty="n",
##        pt.cex=c(1.75))
## legend(nbr_classified@extent@xmax-100, nbr_classified@extent@ymax,
##        c("Enhanced Regrowth", "Unburned", "Low Severity", "Moderate Severity", "High Severity", "Fire boundary"),
##        col=c("black"),
##        pch=c(22, 22, 22, 22, 22, NA),
##        lty = c(NA, NA, NA, NA, NA, 1),
##        cex=.8,
##        bty="n",
##        pt.cex=c(1.75))

## ----classify-output-plot3, echo=F, fig.cap="classified NBR output"------
# look at colors
# display.brewer.all()
the_colors <- brewer.pal(5, 'RdYlGn')
# mar bottom, left, top and right
par(xpd = F, mar=c(0,0,2,5))
plot(nbr_classified,
     col=the_colors,
     legend=F,
     axes=F,
     box=F,
     main="Landsat NBR - Cold Spring fire site \n Add date of the data here")
     plot(fire_boundary_utm, add=T,
          lwd=5)
par(xpd = TRUE)
legend(nbr_classified@extent@xmax-100, nbr_classified@extent@ymax,
       c("Enhanced Regrowth", "Unburned", "Low Severity", "Moderate Severity", "High Severity", "Fire boundary"),
       col=c(rev(the_colors), "black"),
       pch=c(15,15, 15, 15, 15,NA),
       lty = c(NA, NA, NA, NA, NA, 1),
       cex=.8,
       bty="n",
       pt.cex=c(1.75))
legend(nbr_classified@extent@xmax-100, nbr_classified@extent@ymax,
       c("Enhanced Regrowth", "Unburned", "Low Severity", "Moderate Severity", "High Severity", "Fire boundary"),
       col=c("black"),
       pch=c(22, 22, 22, 22, 22, NA),
       lty = c(NA, NA, NA, NA, NA, 1),
       cex=.8,
       bty="n",
       pt.cex=c(1.75))


## ----dev-off, echo=F, warning=F, message=F, results="hide"---------------
dev.off()

## ----view-hist, warning=F, echo=F, fig.cap="plot hist"-------------------
barplot(nbr_classified,
        main="Distribution of Classified NBR Values",
        col=the_colors)

