## ----elevation-map, include=TRUE, results="hide", echo=FALSE-------------
library(raster)
# render DSM for lesson content background
DSM_HARV <- raster("NEON-DS-Airborne-Remote-Sensing/HARV/DSM/HARV_dsmCrop.tif")

# code output here - DEM rendered on the screen
plot(DSM_HARV,
      main="A Dataset You Are Given\n What metric does it represent?\nHow Was It Processed??")


## ----challenge-know-the-data, echo=FALSE---------------------------------

# Everything! We have no idea what this raster represents (what metric),
# what the units are, what the scale represents, when it was collected, etc.
# When we create data it needs to be documented sufficiently (and efficiently)
# for sharing with others.


