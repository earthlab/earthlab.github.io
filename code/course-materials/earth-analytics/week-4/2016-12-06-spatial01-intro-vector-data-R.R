## ----load-libraries------------------------------------------------------
# work with spatial data; sp package will load with rgdal.
library(rgdal)
# for metadata/attributes- vectors or rasters
library(raster)

# set working directory to earth-analytics dir
# setwd("pathToDirHere")

## ----Import-Shapefile----------------------------------------------------

# Import a polygon shapefile: readOGR("path","fileName")
# no extension needed as readOGR only imports shapefiles

sjer_plot_locations <- readOGR("data/week4/california/SJER/vector_data/",
                      layer="SJER_plot_centroids")



## ----view-metadata-------------------------------------------------------
# view just the class for the shapefile
class(sjer_plot_locations)

# view just the crs for the shapefile
crs(sjer_plot_locations)

# view just the extent for the shapefile
extent(sjer_plot_locations)

# view all metadata at same time
sjer_plot_locations

## ----Shapefile-attributes-2----------------------------------------------
# alternate way to view attributes
sjer_plot_locations@data


## ----shapefile-summary---------------------------------------------------
# view a summary of metadata & attributes associated with the spatial object
summary(sjer_plot_locations)


## ----plot-shapefile, fig.cap="SJER plot locations."----------------------
# create a plot of the shapefile
# 'lwd' sets the line width
# 'col' sets internal color
# 'border' sets line color
plot(sjer_plot_locations, col="blue",
     pch=8,
     main="Plot Locations")


## ----import-point-line, echo=FALSE, results="hide"-----------------------
# import line shapefile
sjer_roads <- readOGR("data/week4/california/madera-county-roads",
                      layer = "tl_2013_06039_roads")

sjer_crop_extent <- readOGR("data/week4/california/SJER/vector_data/",
                            "SJER_crop")

# 1
class(sjer_roads)
class(sjer_plot_locations)

# 2
crs(sjer_roads)
extent(sjer_roads)
crs(sjer_plot_locations)
extent(sjer_plot_locations)

# 3
#sjer_roads contains only lines and sjer_plot_locations contains only 1 point

# 4 -> numerous ways to find this; sjer_roads=13,
length(sjer_roads)  #easiest, but not previously taught
sjer_roads  #look at 'features'
attributes(sjer_roads)  #found in the $data section as above

# Alternative code for 1-4: view metadata/attributes all at once
sjer_roads
attributes(sjer_roads)


## ----plot-multiple-shapefiles--------------------------------------------
# Plot multiple shapefiles
plot(sjer_crop_extent, col = "lightgreen",
     main="NEON Harvard Forest\nField Site")
plot(sjer_roads, add = TRUE)

# use the pch element to adjust the symbology of the points
plot(sjer_plot_locations, add  = TRUE, pch = 19, col = "purple")

