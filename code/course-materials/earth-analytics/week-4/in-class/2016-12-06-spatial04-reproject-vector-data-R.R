## ----load-libraries------------------------------------------------------
# load spatial data packages
library(rgdal)
library(raster)

# set working directory to data folder
# setwd("pathToDirHere")


## ----read-csv------------------------------------------------------------
# Import the shapefile data into R
state_boundary_us <- readOGR("data/week4/usa-boundary-layers",
          "US-State-Boundaries-Census-2014")

# view data structure
class(state_boundary_us)

## ----find-coordinates----------------------------------------------------
# view column names
plot(state_boundary_us,
     main="Map of Continental US State Boundaries\n US Census Bureau Data")


## ----check-out-coordinates-----------------------------------------------
# Read the .csv file
country_boundary_us <- readOGR("data/week4/usa-boundary-layers",
          "US-Boundary-Dissolved-States")

# look at the data structure
class(country_boundary_us)

# view column names
plot(state_boundary_us,
     main="Map of Continental US State Boundaries\n US Census Bureau Data",
     border="gray40")

# view column names
plot(country_boundary_us,
     lwd=4,
     border="gray18",
     add = TRUE)


## ----explore-units, fig.cap="plot aoi"-----------------------------------
# Import a point shapefile
sjer_aoi <- readOGR("data/week4/california/SJER/vector_data",
                      "SJER_crop")
class(sjer_aoi)

# plot point - looks ok?
plot(sjer_aoi,
     pch = 19,
     col = "purple",
     main="San Joachin Experimental Range AOI")

## ----layer-point-on-states, fig.cap="plot states"------------------------
# plot state boundaries
plot(state_boundary_us,
     main="Map of Continental US State Boundaries \n with SJER AOI",
     border="gray40")

# add US border outline
plot(country_boundary_us,
     lwd=4,
     border="gray18",
     add = TRUE)

# add AOI boundary
plot(sjer_aoi,
     pch = 19,
     col = "purple",
     add = TRUE)


## ----crs-exploration-----------------------------------------------------
# view CRS of our site data
crs(sjer_aoi)

# view crs of census data
crs(state_boundary_us)
crs(country_boundary_us)

## ----view-extent---------------------------------------------------------
# extent & crs for AOI
extent(sjer_aoi)
crs(sjer_aoi)

# extent & crs for object in geographic
extent(state_boundary_us)
crs(state_boundary_us)


## ----crs-sptranform------------------------------------------------------
# reproject data
sjer_aoi_WGS84 <- spTransform(sjer_aoi,
                                crs(state_boundary_us))

# what is the CRS of the new object
crs(sjer_aoi_WGS84)
# does the extent look like decimal degrees?
extent(sjer_aoi_WGS84)

## ----plot-again, fig.cap="US Map with SJER AOI Location"-----------------
# plot state boundaries
plot(state_boundary_us,
     main="Map of Continental US State Boundaries\n With SJER AOI",
     border="gray40")

# add US border outline
plot(country_boundary_us,
     lwd=4,
     border="gray18",
     add = TRUE)

# add AOI
plot(sjer_aoi_WGS84,
     pch = 19,
     col = "purple",
     add = TRUE)


## ----plot-centroid, fig.cap="figure out AOI polygon centroid."-----------
# get coordinate center of the polygon
aoi_centroid <- coordinates(sjer_aoi_WGS84)

# plot state boundaries
plot(state_boundary_us,
     main="Map of Continental US State Boundaries\n With SJER AOI",
     border="gray40")

# add US border outline
plot(country_boundary_us,
     lwd=4,
     border="gray18",
     add = TRUE)

# add point location of the centroid to the plot
points(aoi_centroid, pch=8, col="magenta", cex=1.5)


## ----challenge-code-MASS-Map, include=TRUE, results="hide", echo=FALSE, warning=FALSE, fig.cap="challenge plot"----
# import data
sjer_aoi <- readOGR("data/week4/california/SJER/vector_data",
                      "SJER_crop")
sjer_roads <- readOGR("data/week4/california/madera-county-roads",
                      "tl_2013_06039_roads")

sjer_plots <- readOGR("data/week4/california/SJER/vector_data",
                      "SJER_plot_centroids")

# reproject line and point data
sjer_roads_utm  <- spTransform(sjer_roads,
                                crs(sjer_aoi))
# crop data
sjer_roads_utm <- crop(sjer_roads_utm, sjer_aoi)

par(xpd = T, mar = par()$mar + c(0,0,0,7))
# plot state boundaries
plot(sjer_aoi,
     main="SJER Area of Interest (AOI)",
     border="gray18",
     lwd=2)

# add point plot locations
plot(sjer_plots,
     pch = 19,
     col = "purple",
     add = TRUE)

# add roads
plot(sjer_roads_utm,
     col = "grey",
     add = TRUE)

# add legend
# to create a custom legend, we need to fake it
legend(258867.4, 4112362,
       legend=c("AOI Boundary", "Roads", "Plot Locations"),
       lty=c(1, 1, NA),
       pch=c(NA, NA, 19),
       col=c("black", "gray18","purple"),
       bty="n",
       cex=.9)


## ----dev-off, echo=F-----------------------------------------------------
# clean out the plot area
dev.off()

