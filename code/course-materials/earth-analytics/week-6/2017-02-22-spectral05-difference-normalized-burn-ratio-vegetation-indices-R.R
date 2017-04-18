## ----load-packages, echo=FALSE, warning=FALSE, message=FALSE, results='hide'----
# load spatial packages
library(raster)
library(rgdal)
library(rgeos)
library(RColorBrewer)
# turn off factors
options(stringsAsFactors = F)

all_landsat_bands <- list.files("data/week6/Landsat/LC80340322016205-SC20170127160728/crop",
           pattern=glob2rx("*band*.tif$"),
           full.names = T) # use the dollar sign at the end to get all files that END WITH
all_landsat_bands

# stack the data
landsat_stack_csf <- stack(all_landsat_bands)

## ----calculate-nbr, echo=FALSE, fig.cap="landsat derived NDVI plot"------
# bands 7 and 5
landsat_nbr <- ((landsat_stack_csf[[5]] - landsat_stack_csf[[7]]) / (landsat_stack_csf[[5]] + landsat_stack_csf[[7]]))

plot(landsat_nbr,
     main="Landsat derived NBR\n Julian Day 205",
     axes=F,
     box=F)

## ----classify-output, echo=FALSE-----------------------------------------
# create classification matrix
reclass <- c(-Inf, -.1, 1,
             -.1, .1, 2,
             .1, .27, 3,
             .27, .66, 4,
             .66, Inf, 5)
# reshape the object into a matrix with columns and rows
reclass_m <- matrix(reclass,
                ncol=3,
                byrow=TRUE)

nbr_classified <- reclassify(landsat_nbr,
                     reclass_m)
the_colors = c("palevioletred4","palevioletred1","ivory1","seagreen1","seagreen4")

## ----classify-output-plot2, echo=FALSE, fig.cap="classified NBR output", results='hide'----
fire_boundary <- readOGR("data/week6/vector_layers/fire-boundary-geomac/co_cold_springs_20160711_2200_dd83.shp")
# reproject shapefile
fire_boundary_utm <- spTransform(fire_boundary, crs(nbr_classified))


## ----classify-output-plot3, echo=FALSE, fig.cap="classified NBR output"----
# look at colors
# display.brewer.all()
the_colors <- brewer.pal(5, 'RdYlGn')
# mar bottom, left, top and right
par(mar=c(0,0,2,5))
plot(nbr_classified,
     col=the_colors,
     legend=F,
     axes=F,
     box=F,
     main="Landsat NBR - Cold Spring fire site \n Add date of the data here")
     plot(fire_boundary_utm, add=T,
          lwd=5)
legend(nbr_classified@extent@xmax-100, nbr_classified@extent@ymax,
       c("Enhanced Regrowth", "Unburned", "Low Severity", "Moderate Severity", "High Severity", "Fire boundary"),
       col=c("black"),
       pch=c(22, 22, 22, 22, 22, NA),
       pt.bg=rev(the_colors),
       lty = c(NA, NA, NA, NA, NA, 1),
       cex=.8,
       bty="n",
       pt.cex=c(1.75), xpd=TRUE)


## ----dev-off, echo=FALSE, warning=FALSE, message=FALSE, results="hide"----
dev.off()

## ----view-barplot1, warning=FALSE, fig.cap="plot barplot of fire severity values with labels"----
barplot(nbr_classified,
        main="Distribution of Classified NBR Values",
        col=the_colors,
        names.arg = c("Enhanced \nRegrowth", "Unburned", "Low \n Severity", "Moderate \n Severity", "High \nSeverity"))

