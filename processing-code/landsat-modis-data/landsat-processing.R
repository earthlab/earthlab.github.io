---
title: "Untitled"
author: "Leah A. Wasser"
date: "2/20/2017"
output: html_document
---


```{r process-data}
# load libraries
library(raster)
library(rgdal)
options(stringsAsFactors = F)
```

It's really useful to be able to grab a list of files


```{r get-tifs}
# get list of all tifs
list.files("data/week6/Landsat/LC80340322016205-SC20170127160728")

# but really we just want the tif files
all_landsat_bands <- list.files("data/week6/Landsat/LC80340322016205-SC20170127160728",
pattern="band",  # grab file names that contain "band" in the name
full.names = T)

# but really we just want the tif files
list.files("data/week6/Landsat/LC80340322016205-SC20170127160728",
pattern=".tif$") # use the dollar sign at the end to get all files that END WITH

```

We could open the files one by one... yawn
```{r}

band_one <- raster("data/week6/Landsat/LC80340322016205-SC20170127160728/LC80340322016205LGN00_sr_band5.tif")

plot(band_one)
crs(band_one)

# or we could create a raster stack this way
all_bands <- stack(all_landsat_bands)
plot(all_bands$LC80340322016205LGN00_sr_band1)

```

```{r cleanup-vector-data, eval=F, echo=F}

# import boundary
fire_boundary <- readOGR("data/week6/GeomacBoundary/co_cold_springs_20160711_2200_dd83.shp")

# create crop extent
fire_box <- extent(fire_boundary)
# turn extent object into spatial object
fire_box_spatial <- as(fire_box, 'SpatialPolygons')
crs(fire_box_spatial) <- crs(fire_boundary)

# reproject to UTM
fire_box_utm <- spTransform(fire_box_spatial,
crs(band_one))
# reproject
fire_boundary_utm <- spTransform(fire_boundary,
crs(band_one))

# expand extent 500 meters in each direction
buffer_dist <- 2000
fire_box_utm_ext <- extent(fire_box_utm)
new_ext <- extent(c(fire_box_utm_ext@xmin - buffer_dist,
fire_box_utm_ext@xmax + buffer_dist,
fire_box_utm_ext@ymax + buffer_dist,
fire_box_utm_ext@ymin - buffer_dist))
fire_box_spatial <- as(new_ext, 'SpatialPolygons')
crs(fire_box_spatial) <- crs(band_one)

poly_df <- data.frame(x=1)
# turn into spatial points data frame
fire_box_spatial_df <- SpatialPolygonsDataFrame(fire_box_spatial, poly_df)

# see how they plot
#plot(band_one)
plot(fire_box_spatial_df)
plot(fire_boundary_utm,
add=T)

# export new crop box
writeOGR(fire_box_spatial_df,
dsn="data/week6/vector_layers",
layer="fire_crop_box",
driver="ESRI Shapefile",
overwrite_layer = T)

# export reprojected fire boundary layer
#writeOGR(fire_boundary_utm,
#         dsn="data/week6/vector_layers",
#         layer="fire_boundary_utm",
#         driver="ESRI Shapefile",
#         overwrite_layer = T)

```



# let's crop all of the rasters


```{r helper-function-to-crop-rasters, echo=F}

# the_file <- all_tifs$theFiles[5]
# crop_extent <- fire_crop_box
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
  writeRaster(x = file_crop,
              filename=paste0(the_path, the_file_name),
              format = "GTiff",
              overwrite = T)
  
}
```


```{r data-cleanup-crop-all-tifs, echo=F, eval=F }
#
# this crops all of the tif files in the original data
# get list of tif files

# get crop extent
fire_crop_box <- readOGR("data/week6/vector_layers/fire_crop_box.shp")

all_tifs <- data.frame(theFiles=list.files("data/week6/Landsat/LC80340322016205-SC20170127160728",
                                           pattern=".tif$",
                                           full.names=T))

for(a_tif_file in all_tifs$theFiles){
  crop_all_tifs(a_tif_file,
                fire_crop_box) # our crop extent object
}



```

## Reproject the extent to the landsat data

The landsat data are much larger than the scene that we downloaded. I think we should crop all the layers to the study area but show them we've done that.

```{r begin-analysis}
# create raster stack
all_bands_tif <- data.frame(band_files=list.files("data/week6/Landsat/LC80340322016205-SC20170127160728/crop",
pattern="band",
full.names=T))
all_bands_tif$band_files

# stack the data
landsat_stack <- stack(all_bands_tif$band_files)
landsat_stack

plot(landsat_stack$LC80340322016205LGN00_sr_band1_crop)
plot(fire_boundary_utm, add=T)

# normalize to

hist(landsat_stack)

# plot band combinations
plotRGB(landsat_stack,
r=4, g=3, b=2,
scale=4000,
stretch="lin",
main="RGB")

# plot band combinations
plotRGB(landsat_stack,
r=3, g=2, b=1,
scale=4000,
stretch="lin")

```

Next, let's look at the cloud mask

```{r}

landsat_cloud_mask <- raster("data/week6/Landsat/LC80340322016205-SC20170127160728/crop/LC80340322016205LGN00_cfmask_crop.tif")
plot(landsat_cloud_mask)
hist(landsat_cloud_mask)

# set values where raster == 1 to NA to be the mask values
landsat_cloud_mask[landsat_cloud_mask==1] <- NA

# mask the stack
landsat_stack_cloudfree <- mask(landsat_stack, landsat_cloud_mask)

hist(landsat_stack_cloudfree)
# plot band combinations
plotRGB(landsat_stack_cloudfree,
        r=4, g=3, b=2,
        scale=4000,
        stretch="lin",
        main="RGB")

# plot band combinations
plotRGB(landsat_stack_cloudfree,
        r=3, g=2, b=1,
        scale=4000,
        stretch="lin")

rgb_stack <- stack(landsat_stack$LC80340322016205LGN00_sr_band3_crop,
                   landsat_stack$LC80340322016205LGN00_sr_band2_crop,
                   landsat_stack$LC80340322016205LGN00_sr_band1_crop)
plotRGB(rgb_stack, stretch="lin")

writeRaster(rgb_stack, filename = "data/week6/Landsat/outputs/rgb.tif")
rgb_image <- stack("data/week6/Landsat/outputs/rgb.tif")
plot(rgb_image)
plotRGB(rgb_image,
        stretch="lin")
```


```{r calculate-burn-index}
# we should make an veg index function
# (Band 4 - Band 7) / (Band 4 + Band 7)) x 1000 = NBR
burn_index <- (landsat_stack_cloudfree$LC80340322016205LGN00_sr_band4_crop - landsat_stack_cloudfree$LC80340322016205LGN00_sr_band7_crop) / (landsat_stack_cloudfree$LC80340322016205LGN00_sr_band4_crop + landsat_stack_cloudfree$LC80340322016205LGN00_sr_band7_crop)

plot(burn_index)

# create index function
spectral_index <- function(band1, band2){
  index <- (band1 - band2) / (band1 + band2)
  return(index)
}

burn_index2 <- spectral_index(landsat_stack_cloudfree$LC80340322016205LGN00_sr_band4_crop, landsat_stack_cloudfree$LC80340322016205LGN00_sr_band7_crop)

index_stack <- stack(landsat_stack_cloudfree$LC80340322016205LGN00_sr_band4_crop,
                     landsat_stack_cloudfree$LC80340322016205LGN00_sr_band7_crop)
# calculate index
burn_index3 <- overlay(index_stack,
                       fun = spectral_index)

plot(burn_index)
plot(burn_index2)
plot(burn_index3)

```