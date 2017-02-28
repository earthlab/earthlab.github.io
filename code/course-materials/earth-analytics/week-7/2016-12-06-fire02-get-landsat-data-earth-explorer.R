## ----crop-naip-image, echo=F, results='hide', message=F, warning=F-------
library(raster)
library(rgeos)
library(rgdal)
# import stack
# import vector that we used to crop the data
# csf_crop <- readOGR("data/week6/vector_layers/fire_crop_box_500m.shp")


## ----import-landsat, echo=F, fig.cap="landsat new image"-----------------
# create a list of all landsat files that have the extension .tif and contain the word band.
all_landsat_bands_173 <- list.files("data/week6/Landsat/LC80340322016173-SC20170227185411",
           pattern=glob2rx("*band*.tif$"),
           full.names = T) # use the dollar sign at the end to get all files that END WITH
# create spatial raster stack from the list of file names
all_landsat_bands_173_st <- stack(all_landsat_bands_173)

# plot
par(col.axis="white", col.lab="white", tck=0)
plotRGB(all_landsat_bands_173_st,
        r=4, g=3, b=2,
        stretch="lin",
        axes=T,
        main="Newly downloaded landsat scene \nJulian day 173")
box(col="white")

## ---- echo=F, results="hide"---------------------------------------------
fire_boundary <- readOGR("data/week6/vector_layers/fire-boundary-geomac/co_cold_springs_20160711_2200_dd83.shp")
fire_boundary_utm <- spTransform(fire_boundary, CRS=crs(all_landsat_bands_st))
# export fire boundary as utm
# writeOGR(fire_boundary_utm,
#           dsn="data/week6/vector_layers/fire-boundary-geomac",
#           layer="co_cold_springs_20160711_2200_dd83_utm",
#           driver="ESRI Shapefile",
#           overwrite_layer = T)

## ----plot-extent, echo=F, fig.cap="rgb with the extent overlayed"--------
# plot
par(col.axis="white", col.lab="white", tck=0)
plotRGB(all_landsat_bands_173_st,
        r=4, g=3, b=2,
        stretch="lin",
        axes=T,
        main="Newly downloaded landsat scene \nJulian day 173")
box(col="white")
plot(fire_boundary_utm,
     border="yellow",
     add=T)

## ----import-cloud-mask, echo=F, fig.cap="cloud mask cropped layer", fig.width=7, fig.height=4----
# crop raster stack
all_landsat_bands_173_st <- crop(all_landsat_bands_173_st, fire_boundary_utm)
cloud_mask_173 <- raster("data/week6/Landsat/LC80340322016173-SC20170227185411/LC80340322016173LGN00_cfmask.tif")
cloud_mask_173_crop <- crop(cloud_mask_173, fire_boundary_utm)
plot(cloud_mask_173_crop,
     main="Cropped cloud mask layer for new Landsat scene", 
     legend=F,
     box=F, axes=F)
plot(fire_boundary_utm, add=T)
par(xpd=T)
legend(cloud_mask_173_crop@extent@xmax,cloud_mask_173_crop@extent@ymax,
       legend=c("0 - Clear"),
       fill="yellow",
       bty="n")

## ----cloud-mask-barplot, fig.cap="view cloud mask values"----------------
barplot(cloud_mask_173_crop,
     main="cloud mask values \n all 0's")

## ----plot-with-extent, fig.cap="plot w extent defined", fig.width=7, fig.height=4----
# plot
par(col.axis="white", col.lab="white", tck=0)
# plot RGB
plotRGB(all_landsat_bands_173_st,
        r=4, g=3, b=2,
        stretch="lin",
        main="Final landsat scene with the fire extent overlayed",
        axes=T)
box(col="white")
plot(fire_boundary_utm,
     add=T,
     border="yellow")

