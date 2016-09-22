---
author: Zach Schira
category: r
layout: single
tags:
- raster
- rgdal
- rhdf5
- sp
title: Project SMAP data onto Landsat data in R
---




The National Snow and Ice Data Center hosts soil moisture data (from the NASA Soil Moisture Active Passive project, described [here](https://nsidc.org/data/smap), and hereafter referred to as SMAP). An important skill for analyzing the SMAP data is the ability to re-project the spatial data to spatial data collected from seperate sources, and covering different spatial extents. One such data source is the joint U.S. Geological Services (USGS) and NASA [Landsat Project](http://landsat.usgs.gov//about_project_descriptions.php). 

This tutorial outlines how to acquire SMAP and Landsat data, project SMAP data onto Landsat images, and create a Raster containing all of the resulting data. This will briefly cover creating a Raster from SMAP data (which comes in hdf5 format), but for a more detailed explanation refer to the smap_to_raster template.

## Objectives

- Read SMAP data from h5 file
- Create raster
- Create rasters from Landsat data
- Project SMAP data onto Landsat data
- Create raster stack containing bands from Landsat data and projection of SMAP data

## Prerequisites

Necessary libraries- 
    - rhdf5
    - raster
    - rdgal
    - sp
Install these packages using the following code


```R
install.packages("sp", repos="http://cran.rstudio.com/")
install.packages("raster", repos="http://cran.rstudio.com/")
install.packages("rgdal", repos="http://cran.rstudio.com/")
source("https://bioconductor.org/biocLite.R")
biocLite("rhdf5")
```

If you already have these packages installed confirm that you are using the most up-to-date versions


```R
update.packages("sp",repos="http://cran.rstudio.com/")
update.packages("raster",repos="http://cran.rstudio.com/")
source("https://bioconductor.org/biocLite.R")
biocLite("rgdal")
biocLite("rhdf5")
```

## Getting Data

### SMAP

To access the SMAP data call download.file, with the first argument being the url where the data is located, and the second being the file name and path where you want to store the data this can be repeated with as many files as are needed.


```R
input_file='SMAP.h5'#file name and path
download.file('ftp://n5eil01u.ecs.nsidc.org/SAN/SMAP/SPL4SMGP.001/2015.04.01/SMAP_L4_SM_gph_20150401T013000_Vb1010_001.h5',
             input_file)
```

### Landsat

To acquire landsat data you will need the landsat-util command line utility. Information on installation can be found [here](http://landsat-util.readthedocs.io/en/latest/installation.html). If you are using windows be sure to first install [Docker](https://docs.docker.com/windows/), and follow the instructions under the landsat-util installation instructions in the Docker section. 

Once you have installed landsat-util you can use the landsat commands described [here](http://landsat-util.readthedocs.io/en/latest/overview.html), to search for and download landsat data. Remember if you are using windows this will all be done in the Docker teminal, and each landsat command must be proceeded with:

docker run -it -v ~/landsat:/root/landsat developmentseed/landsat-util:latest

## Reading SMAP

Include necessary packages, and find the dataset(s) you would like to read in


```R
suppressWarnings(library(sp))
suppressWarnings(library(raster))
suppressWarnings(library(rhdf5))
suppressWarnings(library(rgdal))

#File name and group where data is located
input_file='SMAP.h5'#file name and path
group='Geophysical_Data'
h5f <- H5Fopen(input_file)
h5f&'Geophysical_Data'#Print out all datasets in the geophysical data group
```

Define datasets to read from SMAP h5 file


```R
#Define datasets
data_to_read <- 'sm_rootzone'#possible set to read in
missing_vals <- -9999
```

Create vectors of longitude and latitude and define extent for projection using these ranges and create SMAP rasters


```R
get_dataset <- function(group, dataset) {
  # helper function to create dataset paths, given a group and dataset
  dataset_path <- paste0('/', group, '/', dataset)
  dataset_path
}
# find spacial extent of SMAP image
lat <- suppressWarnings(apply(h5read(input_file, '/cell_lat'), 2, unique))
lon <- suppressWarnings(apply(h5read(input_file, '/cell_lon'), 2, unique))
xmn <- min(lat)
xmx <- max(lat)
ymn <- min(lon)
ymx <- max(lon)
crs_out = "+init=epsg:4326"

# read in each dataset and create raster
data_array <- suppressWarnings(h5read(input_file, get_dataset(group, data_to_read)))
data_array <- t(data_array)
smap <- raster(data_array, xmn, xmx, ymn, ymx, crs_out)
```

## Process and create raster stack

Change `all_bands` if you want to use all available bands


```R
all_bands <- FALSE#true if using all bands
```

If using specific bands create a list with just those bands


```R
#if using specific bands
if (!all_bands) {
    bands <- c(2,3,4,5,9)#possible selection of bands
}
```

If using all bands list will contain all available bands


```R
#if using all bands
if (all_bands) {
    num_bands <- 9#?
    bands <- range(1,num_bands)
}
```

Loop through list of bands (works with all or specific bands) and create raster from each geotiff file then add raster to list. to be added to stack


```R
get_lsat_file <- function(dir_path, scenId, band_number) {
    #helper function to create file name for each lsat band
    lsat_file <- paste0(dir_path, sceneID, '_B', band_number,'.tif')
}

# standard lsat file name contains the seceneID_band number
sceneID <- 'LC80330322015099LGN00'
dir_path <- 'data/'# path to where lsat data is saved
#list of each raster to be contained in stack (all bands plus SMAP)
raster_list <- vector("list",length(bands)+1)
# loop through each band and create raster
j <- 1
for (i in bands) {
    lsat_file <- get_lsat_file(dir_path, sceneID, i)
    if(file.exists(lsat_file)){
        raster_list[[j]] <- raster(lsat_file)#read file
    } else {
        raster_list[[j]] <- NULL  # if file doesn't exist exclude band from stack
    }
    j <- j + 1
}
raster_list[[j-1]]
smap
```

The [projectRaster](http://www.inside-r.org/packages/cran/raster/docs/projectRaster) and [mask](http://www.inside-r.org/packages/cran/raster/docs/mask) functions are used to create the final projection. By including the Landsat raster as the second argument in the `projectRaster()` function the resolution and extent of the SMAP raster will automatically be matched to those of Landsat. The `mask()` function then takes the missing values in the SMAP data (set to NA earlier), and masks them with values from the Landsat image.


```R
# match resolution/extent of smap and lsat data
suppressWarnings(smap <- projectRaster(smap, to = raster_list[[1]]))
# match extent
smap <- mask(smap, raster_list[[1]])
raster_list[[j]] <- smap
```

Create raster stack, and save to geotiff file.


```R
# create raster stack
projected_stack <- stack(raster_list)
# save raster stack to a geotiff file
writeRaster(projected_stack,'lsat_smap_stack.tif', 
            format = 'GTiff', overwrite=TRUE)
```