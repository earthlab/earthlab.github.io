## ----import-tif, collapse=T----------------------------------------------

# view attributes for a geotif file
GDALinfo("NEON-DS-Airborne-Remote-Sensing/HARV/CHM/HARV_chmCrop.tif")

# import geotiff
chm_HARV <- raster("NEON-DS-Airborne-Remote-Sensing/HARV/CHM/HARV_chmCrop.tif")

chm_HARV


## ----na-value-tiff, eval=FALSE-------------------------------------------
## 
## # if you want a NA value of -9999, then you have to specify this when you
## # export a raster file in R
## exampleRaster <- writeRaster(rasterObject,  # object to export/write
##                              FileName.tif,  # name of new .tif file
##                              datatype = "INT1U",  # the data type
##                              NAflag = -9999)  # your desired NA or noData value

