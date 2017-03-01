## ----crop-naip-imagey, echo=F, results='hide', message=F, warning=F------
library(raster)
library(rgeos)
library(rgdal)
# import stack
# import vector that we used to crop the data
# csf_crop <- readOGR("data/week6/vector_layers/fire_crop_box_500m.shp")


## ----work-with-modis-----------------------------------------------------
# open modis bands (layers with sur_refl in the name)
all_modis_bands_july7 <-list.files("data/week6/modis/reflectance/07_july_2016/crop",
           pattern=glob2rx("*sur_refl*.tif$"),
           full.names = T)
# create spatial raster stack
all_modis_bands_st_july7 <- stack(all_modis_bands_july7)

# view range of values in stack
all_modis_bands_st_july7[[2]]

## ----assign-no-data------------------------------------------------------
# deal with nodata value --  -28672 
all_modis_bands_st_july7[all_modis_bands_st_july7 < -100 ] <- NA
# options("scipen"=100, "digits"=4)
plot(all_modis_bands_st_july7[[2]])

## ----import-shapefile, results='hide', echo=F----------------------------
# view fire overlay boundary
fire_boundary <- readOGR("data/week6/vector_layers/fire-boundary-geomac/co_cold_springs_20160711_2200_dd83.shp")
fire_boundary_sin <- spTransform(fire_boundary,
                                 CRS=crs(all_modis_bands_st))
# export as sinusoidal
# writeOGR(fire_boundary_sin,
#          dsn = "data/week6/vector_layers/fire-boundary-geomac",
#          layer="co_cold_springs_20160711_2200_sin",
#          driver="ESRI Shapefile",
#          overwrite_layer=TRUE)

## ----plot-modis-layers, echo=F, fig.cap="plot MODIS stack", fig.width=5, fig.height=5----
## 3 = blue, 4 = green, 1= red 2= nir
par(col.axis="white", col.lab="white", tck=0)
plotRGB(all_modis_bands_st_july7,
        r=1, g =4, b=3,
        stretch="lin",
        main="MODIS post-fire RGB image\n Cold springs fire site",
        axes=T)
box(col="white")
# add fire boundary to plot
plot(fire_boundary_sin, 
     add=T,
     border="yellow",
     lwd=50)


## ----reset-dev, warning='hide', echo=F, message=F------------------------
dev.off()

## ----create-apply-mask, echo=F, fig.cap="cloud mask plot"----------------
# import cloud mask
cloud_mask_7July <- raster("data/week6/modis/reflectance/07_july_2016/crop/cloud_mask_july7_500m.tif")
cloud_mask_7July[cloud_mask_7July > 0] <- NA
plot(cloud_mask_7July,
     main="Landsat cloud mask layer",
     legend=F,
     axes=F, box=F)
legend('topright',
       legend=c("Cloud free", "Clouds"),
       fill=c("yellow", "white"))

## ----create-mask, fig.cap="Final stack masked", echo=F-------------------
all_modis_bands_st_mask <- mask(all_modis_bands_st_july7,
                                cloud_mask_7July)

## 3 = blue, 4 = green, 1= red 2= nir

## ----masked-data, echo=F, fig.cap="MODIS with cloud mask", fig.width=7, fig.height=4----
## 3 = blue, 4 = green, 1= red 2= nir
par(col.axis="white", col.lab="white", tck=0)
plotRGB(all_modis_bands_st_mask,
        r=1, g =4, b=3,
        stretch="lin",
        main="MODIS data mask applied\n Cold springs fire AOI",
        axes=T)
box(col="white")
plot(fire_boundary_sin,
     add=T, col="yellow",
     lwd=1)

## ----crop-data, echo=F, fig.cap="cropped data"---------------------------
all_modis_bands_st_mask <- crop(all_modis_bands_st_mask, fire_boundary_sin)
par(col.axis="white", col.lab="white", tck=0)
plotRGB(all_modis_bands_st_mask,
        r=1, g =4, b=3,
        stretch="lin",
        ext=extent(fire_boundary_sin),
        axes=T,
        main="Final landsat masked data \n Cold Springs fire scar site")
box(col="white")
plot(fire_boundary_sin, border="yellow", add=T)


## ----create-apply-mask2, echo=F, fig.cap="Classified pre fire NBR"-------
# Band 4 includes wavelengths from 0.76-0.90 µm (NIR) and 
# Band 7 includes wavelengths between 2.09-2.35 µm (SWIR).
# B2 - B7 / b2 + b7
get_veg_index <- function(band1, band2){
  # calculate index
  index <- (band1 - band2) / (band1 + band2)
  return(index)
}

# calculate modis NBR
modis_nbr <- overlay(all_modis_bands_st_mask[[2]], all_modis_bands_st_mask[[7]],
                     fun=get_veg_index)
modis_nbr <- modis_nbr * 1000

# create classification matrix
reclass <- c(-1001, -100, 1,
             -100, 100, 2,
             100, 270, 3,
             270, 660, 4,
             660, 1500, 5)
# reshape the object into a matrix with columns and rows
reclass_m <- matrix(reclass,
                ncol=3,
                byrow=TRUE)

modis_nbr_cl <- reclassify(modis_nbr,
                     reclass_m)
# reclass data
plot(modis_nbr_cl,
     main="MODIS NBR for the Cold Springs site")
plot(fire_boundary_sin, 
     add=T)


## ----get-pixel-values----------------------------------------------------
# get summary counts of each class in raster
freq(modis_nbr_cl, useNA='no')

final_burn_area_high_sev <- freq(modis_nbr_cl, useNA='no', value=5)
final_burn_area_moderate_sev <- freq(modis_nbr_cl, useNA='no', value=4)


## ----open-post-fire, echo=F----------------------------------------------

# open modis bands (layers with sur_refl in the name)
all_modis_bands_july17 <-list.files("data/week6/modis/reflectance/17_july_2016/crop",
           pattern=glob2rx("*sur_refl*.tif$"),
           full.names = T)

all_modis_bands_st_july17 <- stack(all_modis_bands_july17)

# deal with nodata value --  -28672 
all_modis_bands_st_july17[all_modis_bands_st_july17 < -100] <- NA

# import cloud mask & Mask data
cloud_mask_17July <- raster("data/week6/modis/reflectance/17_july_2016/crop/cloud_mask_july17_500m.tif")
cloud_mask_17July[cloud_mask_17July > 0] <- NA
all_modis_bands_st_mask_july17 <- mask(all_modis_bands_st_july17,
                                cloud_mask_17July)


## ----plot-rgb-post-fire, fig.cap="RGB post fire"-------------------------
# clouds removed 
plotRGB(all_modis_bands_st_mask_july17, 
        1,4,3,
        stretch="lin",
        main="Final data with mask")

## ----mask-data, echo=F---------------------------------------------------
# calculate NBR
modis_nbr_july17 <- overlay(all_modis_bands_st_mask_july17[[2]], 
                            all_modis_bands_st_mask_july17[[7]],
                            fun=get_veg_index)

modis_nbr_july17 <- modis_nbr_july17 * 1000

modis_nbr_july17_cl <- reclassify(modis_nbr_july17,
                     reclass_m)
# crop to final extent 

modis_nbr_july17_cl <- crop(modis_nbr_july17_cl, fire_boundary_sin)

## ----view-barplot, fig.cap="barplot of final post fire classified data."----
the_colors = c("palevioletred4","palevioletred1","ivory1")
barplot(modis_nbr_july17_cl,
        main="Distribution of burn values",
        col=rev(the_colors),
        names.arg=c("Low Severity","Moderate Severity","High Severity"))

## ----plot-data-reclass, echo=F-------------------------------------------
# the_colors = c("palevioletred4","palevioletred1","ivory1","seagreen1","seagreen4")
the_colors = c("ivory1","palevioletred1","palevioletred4")

# reclass data
# mar bottom, left, top and right
par(xpd = F, mar=c(0,0,2,5))
plot(modis_nbr_july17_cl,
     main="MODIS NBR for the Cold Springs site",
     ext=extent(fire_boundary_sin),
     col=the_colors,
     axes=F,
     box=F,
     legend=F)
plot(fire_boundary_sin, 
     add=T)
par(xpd = TRUE)
legend(modis_nbr_july17_cl@extent@xmax-100, modis_nbr_july17_cl@extent@ymax,
       c("Low Severity", "Moderate Severity", "High Severity"),
       fill=the_colors,
       cex=.9,
       bty="n")

final_burn_area_high_sev <- freq(modis_nbr_july17_cl, useNA='no', value=5)
final_burn_area_moderate_sev <- freq(modis_nbr_july17_cl, useNA='no', value=4)

## ----dev-off, echo=F, results='hide'-------------------------------------
dev.off()

