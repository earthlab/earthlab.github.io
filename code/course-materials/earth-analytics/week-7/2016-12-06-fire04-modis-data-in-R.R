## ----crop-naip-imagey, echo=F, results='hide', message=F, warning=F------
library(raster)
library(rgeos)
library(rgdal)
# import stack
# import vector that we used to crop the data
# csf_crop <- readOGR("data/week6/vector_layers/fire_crop_box_500m.shp")


## ----work-with-modis-----------------------------------------------------
# open modis bands (layers with sur_refl in the name)
all_modis_bands <-list.files("data/week6/modis/reflectance/07_july_2016/crop",
           pattern=glob2rx("*sur_refl*.tif$"),
           full.names = T)

all_modis_bands_st <- stack(all_modis_bands)

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

## ----plot-modis-layers, echo=F, fig.cap="plot MODIS stack"---------------
## 3 = blue, 4 = green, 1= red 2= nir
plotRGB(all_modis_bands_st,
        r=1, g =4, b=3,
        stretch="lin",
        main="MODIS post-fire RGB image\n Cold springs fire site")
# add fire boundary to plot
plot(fire_boundary_sin, 
     add=T,
     border="yellow",
     lwd=50)


## ----create-apply-mask, echo=F, fig.cap="cloud mask plot"----------------
# import cloud mask
cloud_mask_7July <- raster("data/week6/modis/reflectance/07_july_2016/crop/cloud_mask_july7_500m.tif")
cloud_mask_7July[cloud_mask_7July > 0] <- NA
plot(cloud_mask_7July)

## ----create-mask, fig.cap="Final stack masked"---------------------------
all_modis_bands_st_mask <- mask(all_modis_bands_st,
                                cloud_mask_7July)

## 3 = blue, 4 = green, 1= red 2= nir
plotRGB(all_modis_bands_st,
        r=1, g =4, b=3,
        stretch="lin")

## ----masked-data, echo=F, fig.cap="MODIS with cloud mask"----------------
## 3 = blue, 4 = green, 1= red 2= nir
plotRGB(all_modis_bands_st_mask,
        r=1, g =4, b=3,
        stretch="lin",
        main="MODIS data mask applied\n Cold springs fire AOI",
        axes=T)

plot(fire_boundary_sin,
     add=T, col="yellow",
     lwd=1)

## ----crop-data, echo=F, fig.cap="cropped data"---------------------------
all_modis_bands_st_mask <- crop(all_modis_bands_st_mask, fire_boundary_sin)

plotRGB(all_modis_bands_st_mask,
        r=1, g =4, b=3,
        stretch="lin",
        ext=extent(fire_boundary_sin))
plot(fire_boundary_sin, border="yellow", add=T)


## ----create-apply-mask2, echo=F------------------------------------------
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
reclass <- c(-700, -100, 1,
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


