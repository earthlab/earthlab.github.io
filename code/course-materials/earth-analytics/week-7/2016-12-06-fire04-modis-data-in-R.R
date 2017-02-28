## ----crop-naip-imagey, echo=F, results='hide', message=F, warning=F------
library(raster)
library(rgeos)
library(rgdal)
# import stack
# import vector that we used to crop the data
# csf_crop <- readOGR("data/week6/vector_layers/fire_crop_box_500m.shp")


## ----work-with-modis-----------------------------------------------------
# open modis bands
all_modis_bands <-list.files("data/week6/modis/reflectance/07_july_2016/crop",
           pattern=glob2rx("*sur_refl*.tif$"),
           full.names = T)

all_modis_bands_st <- stack(all_modis_bands)
## 3 = blue, 4 = green, 1= red 2= nir
plotRGB(all_modis_bands_st,
        r=1, g =4, b=3,
        stretch="lin")

# view fire overlay boundary
fire_boundary <- readOGR("data/week6/vector_layers/fire-boundary-geomac/co_cold_springs_20160711_2200_dd83.shp")
fire_boundary_sin <- spTransform(fire_boundary,
                                 CRS=crs(all_modis_bands_st))

# export as sinusoidal
writeOGR(fire_boundary_sin,
         dsn = "data/week6/vector_layers/fire-boundary-geomac",
         layer="co_cold_springs_20160711_2200_sin",
         driver="ESRI Shapefile",
         overwrite_layer=TRUE)


# plot(fire_boundary_sin, lwd=100)



## ----create-apply-mask---------------------------------------------------
# import cloud mask
cloud_mask_7July <- raster("data/week6/modis/reflectance/07_july_2016/crop/cloud_mask_july7_500m.tif")
cloud_mask_7July[cloud_mask_7July > 0] <- NA
plot(cloud_mask_7July)

all_modis_bands_st_mask <- mask(all_modis_bands_st,
                                cloud_mask_7July)

## 3 = blue, 4 = green, 1= red 2= nir
plotRGB(all_modis_bands_st,
        r=1, g =4, b=3,
        stretch="lin")

## 3 = blue, 4 = green, 1= red 2= nir
plotRGB(all_modis_bands_st_mask,
        r=1, g =4, b=3,
        stretch="lin")

fire_bound_sin <- readOGR("data/week6/vector_layers/fire-boundary-geomac/co_cold_springs_20160711_2200_sin.shp")
plot(fire_bound_sin,
     add=T, col="yellow",
     lwd=1)

plotRGB(all_modis_bands_st_mask,
        r=1, g =4, b=3,
        stretch="lin",
        ext=extent(fire_bound_sin))
plot(fire_bound_sin, border="yellow", add=T)


## ----create-apply-mask2--------------------------------------------------

get_veg_index <- function(band1, band2){
  # calculate index
  index <- (band1-band2) /(band1+band2)
}

# calculate modis NBR
modis_nbr <- overlay(all_modis_bands_st_mask[[2]], all_modis_bands_st_mask[[7]],
                     fun=get_veg_index)

# create classification matrix
reclass <- c(cellStats(modis_nbr, min), -.1, 1,
             -.1, .1, 2,
             .1, .27, 3,
             .27, .66, 4,
             .66, cellStats(modis_nbr, max), 5)
# reshape the object into a matrix with columns and rows
reclass_m <- matrix(reclass,
                ncol=3,
                byrow=TRUE)

modis_nbr_cl <- reclassify(modis_nbr,
                     reclass_m)
# reclass data
plot(modis_nbr_cl, ext=extent(fire_bound_sin))
plot(fire_boundary_sin, add=T)

# get summary counts of each class in raster
freq(modis_nbr_cl, useNA='no')

# extract values for all pixels that fall within the fire scar zone
test <- extract(x = modis_nbr_cl,
                y = fire_boundary_sin,
                df=T)
length(test[test==4])
final_area <- length(test[test==4]) * 500

