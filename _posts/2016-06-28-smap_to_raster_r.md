---
author: Zach Schira
category: r
layout: single
tags:
- raster
- rgdal
- rhdf5
- sp
title: Create RasterStacks from arrays with hdf5 files in R
---




The National Snow and Ice Data Center hosts soil moisture data (from the NASA Soil Moisture Active Passive project, described [here](https://nsidc.org/data/smap), and hereafter referred to as SMAP) which is provided in .h5 format. HDF5 is a "hierarchical" data format, with multiple groups and datasets (further explained in Step 2) which are useful for storing and organizing large amounts of data. While this format is great for the large amount of data being collected, we often want to utilize a single dataset within the file.

This tutorial demonstrates how to access SMAP data, and how to generate raster output from an HDF5 file. A raster is a two dimensional array, with each element in the array containing a specific value. In this case, the two dimensions correspond to longitude and latitude, and the elements or values represent soil moisture.

## Objectives

- Read SMAP data from h5 file
- Create raster from desired dataset(s)
- Add rasters to raster stack, and save stack as geotiff file

## Dependencies

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
update.packages("sp", repos="http://cran.rstudio.com/")
update.packages("raster", repos="http://cran.rstudio.com/")
source("https://bioconductor.org/biocLite.R")
biocLite("rgdal")
biocLite("rhdf5")
```

## Getting Data

To access the SMAP data call download.file with the first argument being the url where the data is located, and the second being the file name and path where you want to store the data. This will work with any h5 files you would like to analyze.


```R
input_file <- 'SMAP.h5'#save h5 file here
download.file('ftp://n5eil01u.ecs.nsidc.org/SAN/SMAP/SPL4SMGP.001/2015.04.01/SMAP_L4_SM_gph_20150401T013000_Vb1010_001.h5',
             input_file)
```

## Reading SMAP

HDF5 files consist of 'Groups' and 'Datasets'. Datasets are multidimensional arrays of a homogenous type, and Groups are a container structure which hold numerous datasets. Groups are analogous to directories on your local file system. For more details on the structure of HDF5 files, see [this tutorial from the NEON Data Skills site](http://neondataskills.org/HDF5/About), or refer to the [HDF5 home page](https://www.hdfgroup.org/HDF5/).

The following chunk of code prints the datasets within the "Geophysical_Data" group. From here you can choose the datasets you would like to analyze. Loading the libraries is done within the the suppressWarnings function because they are built within a different version of R than what is run in the kernel. This should not cause any problems in running the code.


```R
# include necessary libraries
suppressWarnings(library(sp))
suppressWarnings(library(raster))
suppressWarnings(library(rhdf5))
suppressWarnings(library(rgdal))
# file name and group where data is located
group <- 'Geophysical_Data'
h5f <- H5Fopen(input_file)
h5f&'Geophysical_Data'#Print out all datasets in the geophysical data group
```

## Creating Raster from h5

The next step is define the datasets you would like to analyze, this example will use 'sm_rootzone' and 'heat_flux_ground' data. 

From here you can read in each dataset and create a raster layer from the data. These raster layers eventually be 'stacked' together to create the final raster stack.

`suppressWarnings()` is used here because the h5 file is already open, which creates a warning when reading the file, but should not cause any problems.


```R
# choose datasets to read
data_to_read <- c('sm_rootzone','heat_flux_ground')
num_sets <- length(data_to_read)
list_of_rasters <- vector("list", num_sets)

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
for (i in 1:length(list_of_rasters)) {
    data_array <- suppressWarnings(h5read(input_file, get_dataset(group, data_to_read[i])))
    raster_i <- raster(t(data_array),xmn, xmx, ymn, ymx, crs = crs_out)
    list_of_rasters[[i]] <- raster_i
}
```

## Creating Raster Stack

The `stack()` function takes a list of raster ojects as an argument and creates a raster stack with each layer being one of the rasters in the list


```R
# create raster stack
smap_stack <-stack(list_of_rasters)
# define layer names 
for (i in 1:num_sets) {
    names(smap_stack)[i]<-data_to_read[[i]]
}
# save raster stack to a geotiff file
writeRaster(smap_stack,'smap_stack.tif', format = 'GTiff', 
            overwrite=TRUE)
```

The raster library has many useful functions that allow you to better understand the data stored in the raster stack. The [names](http://www.inside-r.org/packages/cran/raster/docs/names) function, for example, allows you to see the what is in each layer, and change layer names as desired. [addLayer](http://www.inside-r.org/packages/cran/raster/docs/addLayer) and dropLayer allow you to add a layer to, or remove a layer from the stack