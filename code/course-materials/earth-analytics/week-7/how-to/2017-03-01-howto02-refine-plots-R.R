## ----crop-naip-imagey, echo=F, results='hide', message=F, warning=F------
library(raster)
library(rgeos)
library(rgdal)
# import stack
# import vector that we used to crop the data
# csf_crop <- readOGR("data/week6/vector_layers/fire_crop_box_500m.shp")


## ----create-variable-----------------------------------------------------
# import landsat data
all_landsat_bands <- list.files("data/week6/Landsat/LC80340322016189-SC20170128091153/crop",
           pattern=glob2rx("*band*.tif$"),
           full.names = T) # use the dollar sign at the end to get all files that END WITH
# create spatial stack
all_landsat_bands_st <- stack(all_landsat_bands)

## ----plot-rgb, fig.cap="Remove axes labels."-----------------------------
plotRGB(all_landsat_bands_st,
        r=4,b=3,g=2,
        stretch="hist",
        main="title here")

## ----plot-rgb2, fig.cap="Remove axes labels."----------------------------
# adjust the parameters so the axes colors are white. Also turn off tick marks.
par(col.axis="white", col.lab="white", tck=0)
# plot
plotRGB(all_landsat_bands_st,
        r=4,b=3,g=2,
        stretch="hist",
        main="title here",
        axes=T)

## ----plot-rgb3, fig.cap="Remove axes labels."----------------------------
# adjust the parameters so the axes colors are white. Also turn off tick marks.
par(col.axis="white", col.lab="white", tck=0)
# plot
plotRGB(all_landsat_bands_st,
        r=4,b=3,g=2,
        stretch="hist",
        main="title here",
        axes=T)
# set bounding box to white as well
box(col="white") # turn all of the lines to white


## ----plot-rgb4, fig.cap="Adjust figure width and height.", fig.width=7, fig.height=6----
# adjust the parameters so the axes colors are white. Also turn off tick marks.
par(col.axis="white", col.lab="white", tck=0)
# plot
plotRGB(all_landsat_bands_st,
        r=4,b=3,g=2,
        stretch="hist",
        main="title here",
        axes=T)
# set bounding box to white as well
box(col="white") # turn all of the lines to white


## ----reset-dev, results='hide'-------------------------------------------
# reset dev (space where plots are rendered in RStudio)
dev.off()

## ----plot-ndvi2, echo=F--------------------------------------------------
# calculate NDVI
ndvi <- (all_landsat_bands_st[[5]] - all_landsat_bands_st[[4]]) / (all_landsat_bands_st[[5]] + all_landsat_bands_st[[4]])
# plot ndvi
# reclassify ndvi
# create classification matrix
reclass <- c(-1, .3, 1,
             .3, .5, 2,
             .5, 1, 3)
# reshape the object into a matrix with columns and rows
reclass_m <- matrix(reclass,
                ncol=3,
                byrow=TRUE)

ndvi_classified <- reclassify(ndvi,
                     reclass_m)
the_colors <- c("grey", "yellow", "springgreen")


## ----plot-data1, fig.cap="ndvi plot - no legend"-------------------------
# plot ndvi with legend
plot(ndvi_classified,
     main="ndvi plot",
     col=the_colors)

## ----plot-data2, fig.cap="ndvi plot - no legend"-------------------------
# plot ndvi with legend
plot(ndvi_classified,
     main="ndvi plot",
     col=the_colors,
     axes=F, box=F)


## ----plot-data3, fig.cap="ndvi plot - no legend"-------------------------
# plot ndvi with legend
plot(ndvi_classified,
     legend=F,
     main="ndvi plot",
     col=the_colors,
     axes=F, box=F)
legend("topright",
       legend=c("Healthy vegetation", "Less healthy vegetation", "No vegetation"),
       fill= the_colors)

## ----fix-plot-legend, fig.cap="plot with legend in the upper right. "----

# plot ndvi with legend
plot(ndvi_classified,
     legend=F,
     main="ndvi plot",
     col=the_colors,
     axes=F, box=F)
# set xpd to T to allow the legend to plot OUTSIDE of the plot area
par(xpd=T)
legend(x = ndvi_classified@extent@xmax, y=ndvi_classified@extent@ymax,
       legend=c("Healthy vegetation", "Less healthy vegetation", "No vegetation"),
       fill= rev(the_colors)) # use rev to reverse the order of colors for the legend

## ----fix-plot-legend22, fig.cap="plot with legend in the upper right. "----

# plot ndvi with legend
plot(ndvi_classified,
     legend=F,
     main="ndvi plot",
     col=the_colors,
     axes=F, box=F)
# set xpd to T to allow the legend to plot OUTSIDE of the plot area
par(xpd=T)
legend(x = ndvi_classified@extent@xmax, y=ndvi_classified@extent@ymax,
       legend=c("Healthy vegetation", "Less healthy vegetation", "No vegetation"),
       fill= rev(the_colors)) # use rev to reverse the order of colors for the legend

## ----fix-plot-legend3, fig.cap="plot with legend in the upper right. "----
# set a margin for our figure
par(xpd=F, mar=c(0,0,2,5))
# plot ndvi with legend
plot(ndvi_classified,
     legend=F,
     main="ndvi plot with axes & box turned off",
     col=the_colors,
     axes=F,
     box=F)
# set xpd to T to allow the legend to plot OUTSIDE of the plot area
par(xpd=T)
legend(x = ndvi_classified@extent@xmax, y=ndvi_classified@extent@ymax,
       legend=c("Healthy vegetation", "Less healthy vegetation", "No vegetation"),
       bty=F, # turn off legend border
       fill= rev(the_colors)) # use rev to reverse the order of colors for the legend

## ----dev-off-pls---------------------------------------------------------
dev.off()

## ----fix-plot-legend33, fig.cap="plot with legend in the upper right. "----
# set a margin for our figure
par(xpd=F, mar=c(0,0,2,5))
# plot ndvi with legend
plot(ndvi_classified,
     legend=F,
     main="ndvi plot with axes & box turned off",
     col=the_colors,
     axes=F,
     box=F)
# set xpd to T to allow the legend to plot OUTSIDE of the plot area
par(xpd=T)
legend(x = ndvi_classified@extent@xmax, y=ndvi_classified@extent@ymax,
       legend=c("Healthy vegetation", "Less healthy vegetation", "No vegetation"),
       fill= rev(the_colors),# use rev to reverse the order of colors for the legend
       bty="n", # turn off legend border
       cex=.9)  # adjust legend font size

## ----dev-off-pls2--------------------------------------------------------
dev.off()

## ----fix-plot-legend4, fig.cap="plot with legend in the upper right.", fig.width=6, fig.height=4----
# set a margin for our figure
par(xpd=F, mar=c(0,0,2,6))
# plot ndvi with legend
plot(ndvi_classified,
     legend=F,
     main="NDVI plot with axes & box turned off & custom margins\n to make room for the legend",
     col=the_colors,
     axes=F,
     box=F)
# set xpd to T to allow the legend to plot OUTSIDE of the plot area
par(xpd=T)
legend(x = ndvi_classified@extent@xmax, y=ndvi_classified@extent@ymax,
       legend=c("Healthy vegetation", "Less healthy vegetation", "No vegetation"),
       bty="n", # turn off legend border
       cex=.8, # make the legend font a bit smaller
       fill= rev(the_colors)) # use rev to reverse the order of colors for the legend

## ----import-shape, results="hide", fig.cap="add crop box", , fig.width=6, fig.height=4----
# import crop extent
crop_ext <- readOGR("data/week6/vector_layers/fire_crop_box_2000m.shp")
# set a margin for our figure
par(xpd=F, mar=c(0,0,2,6))
# plot ndvi with legend
plot(ndvi_classified,
     legend=F,
     main="NDVI plot with axes & box turned off & custom margins\n to make room for the legend",
     col=the_colors,
     axes=F,
     box=F)

plot(crop_ext,
     lwd=2,
     add=T)
# set xpd to T to allow the legend to plot OUTSIDE of the plot area
par(xpd=T)
legend(x = ndvi_classified@extent@xmax, y=ndvi_classified@extent@ymax,
       legend=c("Healthy vegetation", "Less healthy vegetation", "No vegetation"),
       bty="n", # turn off legend border
       cex=.8, # make the legend font a bit smaller
       fill= rev(the_colors)) # use rev to reverse the order of colors for the legend

## ----dev-off-pls3, message=F, warning=F, results="hide"------------------
dev.off()

