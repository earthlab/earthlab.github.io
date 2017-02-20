## ----process-data--------------------------------------------------------
library(raster)
library(rgdal)
options(stringsAsFactors = F)


## ----get-tifs------------------------------------------------------------
# get list of all tifs
list.files("data/week6/Landsat/LC80340322016205-SC20170127160728")

# but really we just want the tif files
all_landsat_bands <- list.files("data/week6/Landsat/LC80340322016205-SC20170127160728",
          pattern="band",  # grab file names that contain "band" in the name
          full.names = T,
            )

# but really we just want the tif files
list.files("data/week6/Landsat/LC80340322016205-SC20170127160728",
          pattern=".tif$") # use the dollar sign at the end to get all files that END WITH 


## ------------------------------------------------------------------------

band_one <- raster("data/week6/Landsat/LC80340322016205-SC20170127160728/LC80340322016205LGN00_sr_band5.tif")

plot(band_one)
crs(band_one)

# or we could create a raster stack this way
all_bands <- stack(all_landsat_bands)
plot(all_bands$LC80340322016205LGN00_sr_band1)


## ----cleanup-vector-data, eval=F, echo=F---------------------------------
## 
## # import boundary
## fire_boundary <- readOGR("data/week6/GeomacBoundary/co_cold_springs_20160711_2200_dd83.shp")
## 
## # create crop extent
## fire_box <- extent(fire_boundary)
## # turn extent object into spatial object
## fire_box_spatial <- as(fire_box, 'SpatialPolygons')
## crs(fire_box_spatial) <- crs(fire_boundary)
## 
## # reproject to UTM
## fire_box_utm <- spTransform(fire_box_spatial,
##                         crs(band_one))
## # reproject
## fire_boundary_utm <- spTransform(fire_boundary,
##                         crs(band_one))
## 
## # expand extent 1000 meters in each direction
## buffer_dist <- 1000
## fire_box_utm_ext <- extent(fire_box_utm)
## new_ext <- extent(c(fire_box_utm_ext@xmin - buffer_dist,
##              fire_box_utm_ext@xmax + buffer_dist,
##              fire_box_utm_ext@ymax + buffer_dist,
##              fire_box_utm_ext@ymin - buffer_dist))
## fire_box_spatial <- as(new_ext, 'SpatialPolygons')
## crs(fire_box_spatial) <- crs(band_one)
## 
## poly_df <- data.frame(x=1)
## # turn into spatial points data frame
## fire_box_spatial_df <- SpatialPolygonsDataFrame(fire_box_spatial, poly_df)
## 
## # see how they plot
## #plot(band_one)
## plot(fire_box_spatial_df)
## plot(fire_boundary_utm,
##      add=T)
## 
## # export new crop box
## writeOGR(fire_box_spatial_df,
##          dsn="data/week6/vector_layers",
##          layer="fire_crop_box",
##          driver="ESRI Shapefile")
## 

## ----helper-function-to-crop-rasters, echo=F-----------------------------
## Function to crop all rasters
crop_all_tifs <- function(the_file, crop_extent){
  
  # create raster
  the_file_raster <- raster(the_file)
  # create the new filename
  the_path <- paste0(dirname(the_file), "/crop/")
  the_file_name <- gsub(".tif", "_crop.tif", basename(the_file))

  # make sure the path exists
  if(!dir.exists(the_path)){
    # create the dir
    dir.create(the_path, 
               recursive=T)
  }
  
  # crop to extent
  file_crop <- crop(the_file_raster, 
                    crop_extent)
  
  # export raster to the crop folder
  writeRaster(x = the_file_raster,
              filename=paste0(the_path, the_file_name),
              format = "GTiff",
              overwrite = T)
  
}

## ----data-cleanup-crop-all-tifs, echo=F, eval=F--------------------------
## #
## # this crops all of the tif files in the original data
## # get list of tif files
## 
## all_tifs <- data.frame(theFiles=list.files("data/week6/Landsat/LC80340322016205-SC20170127160728",
##           pattern=".tif$",
##           full.names=T))
## 
## for(a_tif_file in all_tifs$theFiles){
##   crop_all_tifs(a_tif_file,
##               fire_box_spatial) # our crop extent object
## }
## 
## 
## 

## ----begin-analysis------------------------------------------------------





