## ----import-libraries----------------------------------------------------
# import spatial packages
library(raster)
library(rgdal)
library(rgeos)
# turn off factors
options(stringsAsFactors = F)


## ----load-band-tifs, fig.cap="RGB image of our landsat data."------------
all_landsat_bands <- list.files("data/week6/Landsat/LC80340322016189-SC20170128091153/crop",
           pattern=glob2rx("*band*.tif$"),
           full.names = T) # use the dollar sign at the end to get all files that END WITH

all_landsat_bands_st <- stack(all_landsat_bands)


## ----plotRGB-landsat, fig.cap="RGB image of our landsat data."-----------
# turn the axis color to white and turn off ticks
par(col.axis="white", col.lab="white", tck=0)
# plot the data - be sure to turn AXES to T (we just color them white)
plotRGB(all_landsat_bands_st,
        r=4, g=3, b=2,
        stretch="hist",
        main="Pre-fire RGB image with cloud\n Cold Springs Fire",
        axes=T)
# turn the box to white so there is no border on our plot
box(col="white")

## ----cloud-mask, fig.cap="cloud mask - no shadows."----------------------
cloud_mask_189_conf <- raster("data/week6/Landsat/LC80340322016189-SC20170128091153/crop/LC80340322016189LGN00_cfmask_conf_crop.tif")
plot(cloud_mask_189_conf)


## ----view-cloud-mask-with-shadows, fig.cap="cloud mask with shadows"-----
# apply shadow mask
cloud_mask_189 <- raster("data/week6/Landsat/LC80340322016189-SC20170128091153/crop/LC80340322016189LGN00_cfmask_crop.tif")
plot(cloud_mask_189)

## ----create-mask, fig.cap="raster mask. green values are not masked."----
# Create cloud & cloud shadow mask
cloud_mask_189[cloud_mask_189 > 0] <- NA
plot(cloud_mask_189,
     main="Our new raster mask",
     col=c("green"),
     legend=F,
     axes=F,
     box=F)

legend("topright",
       c("Not masked", "Masked"),
       fill=c("green", "white"))


## ----apply-mask, fig.cap="apply raster mask to stack and plot."----------
# mask the stack
all_landsat_bands_mask <- mask(all_landsat_bands_st, mask = cloud_mask_189)
# plot RGB image
# first turn all axes to the color white and turn off ticks
par(col.axis="white", col.lab="white", tck=0)
# then plot the data
plotRGB(all_landsat_bands_mask,
        r=4, g=3, b=2,
        stretch="hist",
        main="RGB image - are all of the clouds gone from our image?",
        axes=F)
box(col="white")


## ----test----------------------------------------------------------------

## Create a function to calculate a veg index
get_veg_index <- function(band1, band2){
  # this function calculates the normalize difference between two bands
  # output: a new raster with index values bewteen -1 and 1
  new_index <- (band2 - band1) / (band2 + band1)
  return(new_index)
}

# calculate NBR

landsat_nbr <- overlay(all_landsat_bands_mask[[4]], all_landsat_bands_mask[[5]],
                       fun=get_veg_index)
plot(landsat_nbr)

