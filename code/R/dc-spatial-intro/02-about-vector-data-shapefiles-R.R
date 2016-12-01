## ----import-vector, warning=FALSE, collapse=T----------------------------

# load libraries required to work with spatial data
library(raster) # commands to view metadata from vector objects
library(rgdal) # library of common GIS functions

# Open shapefile
roads_HARV <- readOGR("NEON-DS-Site-Layout-Files/HARV","HARV_roads")

# view slots available for the object
slotNames(roads_HARV)

# view all methods available for that object
# methods(class = class(roads_HARV))


## ----view-lines-coordinates, collapse=T----------------------------------

# view the coordinates for each vertex, for the last feature in the spatial object
roads_HARV@lines[13]

# view the coordinates for the last feature in the spatial object
roads_HARV@lines[14]


## ----view-attributes, collapse=T-----------------------------------------
# view all attributes for a spatial object
# note, the code below just looks at the first 3 features
head(roads_HARV@data, 3)


## ----challenge-code-shapefiles, echo=FALSE-------------------------------


# Two. There are both points (study plots labelled in legend by the soil type)
# and lines (the boardwalk, footpath, stone walls, and woods road in legend) in
# this map. Since there are two different types of vectors (points & lines)
# there must be two shapefiles as a single shapefile can only contain 1 type of
# vector data.


