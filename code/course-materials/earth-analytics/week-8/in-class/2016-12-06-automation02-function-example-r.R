<<<<<<< HEAD
## ------------------------------------------------------------------------

# set working dir
setwd("~/Documents/earth-analytics")

# load spatial packages
library(raster)
library(rgdal)
# turn off factors
options(stringsAsFactors = F)

# get list of tif files
all_landsat_bands <- list.files("data/week6/Landsat/LC80340322016189-SC20170128091153/crop",
                                pattern=glob2rx("*band*.tif$"),
                                full.names = T)

# stack the data (create spatial object)
landsat_stack_csf <- stack(all_landsat_bands)

par(col.axis="white", col.lab="white", tck=0)
# plot brick
plotRGB(landsat_stack_csf,
  r=4,g=3, b=2, 
  main="RGB Landsat Stack \n pre-fire",
  axes=T,
  stretch="hist")
box(col="white") # turn all of the lines to white




## ------------------------------------------------------------------------

# we can do the same things with functions
get_stack_bands <- function(the_dir_path, the_pattern){
  # get list of tif files
  all_landsat_bands <- list.files(the_dir_path,
                                pattern=glob2rx(the_pattern),
                                full.names = T)

  # stack the data (create spatial object)
  landsat_stack_csf <- stack(all_landsat_bands)
  return(landsat_stack_csf)
  
}




## ---- eval=F-------------------------------------------------------------
=======
## ----setup-dir-----------------------------------------------------------
## 
## # set working dir
## setwd("~/Documents/earth-analytics")
## 
## # load spatial packages
## library(raster)
## library(rgdal)
## # turn off factors
## options(stringsAsFactors = F)

## ----plot-landsat-first, , fig.cap="landsat pre fire raster stack plot"----
## # get list of tif files
## all_landsat_bands <- list.files("data/week6/Landsat/LC80340322016189-SC20170128091153/crop",
##                                 pattern=glob2rx("*band*.tif$"),
##                                 full.names = T)
## 
## # stack the data (create spatial object)
## landsat_stack_csf <- stack(all_landsat_bands)
## 
## par(col.axis="white", col.lab="white", tck=0)
## # plot brick
## plotRGB(landsat_stack_csf,
##   r=4,g=3, b=2,
##   main="RGB Landsat Stack \n pre-fire",
##   axes=T,
##   stretch="hist")
## box(col="white") # turn all of the lines to white
## 
## 

## ------------------------------------------------------------------------
## 
## # we can do the same things with functions
## get_stack_bands <- function(the_dir_path, the_pattern){
##   # get list of tif files
##   all_landsat_bands <- list.files(the_dir_path,
##                                 pattern=glob2rx(the_pattern),
##                                 full.names = T)
## 
##   # stack the data (create spatial object)
##   landsat_stack_csf <- stack(all_landsat_bands)
##   return(landsat_stack_csf)
## 
## }
## 
## 
## 

## ----plot-landsat-pre, fig.cap="landsat pre fire raster stack plot"------
## # code to go here
## landsat_pre_fire <- get_stack_bands(the_dir_path = "data/week6/Landsat/LC80340322016189-SC20170128091153/crop",
##                 the_pattern = "*band*.tif$")
## 
## 
## par(col.axis="white", col.lab="white", tck=0)
## # plot brick
## plotRGB(landsat_pre_fire,
##   r=4,g=3, b=2,
##   main="RGB Landsat Stack \n pre-fire",
##   axes=T,
##   stretch="lin")
## box(col="white") # turn all of the lines to white
## 

## ----create-plot-function------------------------------------------------
## # notice here i set a default stretch to blank
## create_rgb_plot <-function(a_raster_stack, the_plot_title, r=3, g=2, b=1, the_stretch=NULL){
##   # this function plots an RGB image with a title
##   # it sets the plot border and box to white
##   # Inputs a_raster_stack - a given raster stack with multiple spectral bands
##   # the_plot_title - teh title of the plot - text string format in quotes
##   # red, green, blue - the numeric index location of the bands that you want
##   #  to plot on the red, green and blue channels respectively
##   # the_stretch -- defaults to NULL - can take "hist" or "lin" as an option
##   par(col.axis="white", col.lab="white", tck=0)
##   # plot brick
##   plotRGB(a_raster_stack,
##     main=the_plot_title,
##     r=r, g=g, b=b,
##     axes=T,
##     stretch=the_stretch)
##   box(col="white") # turn all of the lines to white
## 
## }
## 

## ----plot-one, fig.cap="pre-fire rgb image"------------------------------
>>>>>>> 599b097850692cf12d3ae1162a6118646c5b54e7
## # code to go here
## landsat_pre_fire <- get_stack_bands(the_dir_path = "data/week6/Landsat/LC80340322016189-SC20170128091153/crop",
##                 the_pattern = "*band*.tif$")
## 
<<<<<<< HEAD
## 
## par(col.axis="white", col.lab="white", tck=0)
## # plot brick
## plotRGB(landsat_pre_fire,
##   r=4,g=3, b=2,
##   main="RGB Landsat Stack \n pre-fire",
##   axes=T,
##   stretch="lin")
## box(col="white") # turn all of the lines to white
## 

## ----create-plot-function------------------------------------------------
# notice here i set a default stretch to blank
create_rgb_plot <-function(a_raster_stack, the_plot_title, the_stretch=""){
  par(col.axis="white", col.lab="white", tck=0)
  # plot brick
  plotRGB(a_raster_stack, 
    main=the_plot_title,
    axes=T,
    stretch=the_stretch)
  box(col="white") # turn all of the lines to white
  
}


## ------------------------------------------------------------------------
# code to go here
landsat_pre_fire <- get_stack_bands(the_dir_path = "data/week6/Landsat/LC80340322016189-SC20170128091153/crop",
                the_pattern = "*band*.tif$")

# stack the data in the order that you want to plot
landsat_pre_fire_RGB <- stack(landsat_pre_fire[[4]], landsat_pre_fire[[3]], landsat_pre_fire[[2]])

# plot the data 
create_rgb_plot(a_raster_stack = landsat_pre_fire_RGB,
                the_plot_title = "RGB image",
                the_stretch="hist")

## ------------------------------------------------------------------------


=======
## # plot the data
## create_rgb_plot(a_raster_stack = landsat_pre_fire,
##                 r=4, g = 3, b=2,
##                 the_plot_title = "RGB image",
##                 the_stretch="hist")

## ----plot-one-cir, fig.cap="pre-fire cir image"--------------------------
## # plot the data
## create_rgb_plot(a_raster_stack = landsat_pre_fire,
##                 r=5, g = 4, b = 3,
##                 the_plot_title = "RGB image",
##                 the_stretch="hist")

## ----plot-landsat-post, fig.cap="landsat post fire raster stack plot"----
## # create stack
## landsat_post_fire <- get_stack_bands(the_dir_path = "data/week6/Landsat/LC80340322016205-SC20170127160728/crop",
##                 the_pattern = "*band*.tif$")
## 
## # plot the 3 band image of the data
## create_rgb_plot(a_raster_stack = landsat_post_fire,
##                 r=4, g = 3, b=2,
##                 the_plot_title = "RGB image",
##                 the_stretch="hist")
## 

## ----plot-landsat-post-CIR, fig.cap="landsat CIR post fire raster stack plot"----
## # plot the 3 band image of the data
## create_rgb_plot(a_raster_stack = landsat_post_fire,
##                 r=5, g = 4, b = 3,
##                 the_plot_title = "Landsat post fire CIR image",
##                 the_stretch="hist")
## 

## ----plot-modis, fig.cap="pre-fire rgb image MODIS"----------------------
## # import MODIS
## modis_pre_fire <- get_stack_bands(the_dir_path = "data/week6/modis/reflectance/07_july_2016/crop",
##                 the_pattern = "*sur_refl*.tif$")
## 
## # plot the data
## create_rgb_plot(a_raster_stack = modis_pre_fire,
##                 r=1, g = 4, b=3,
##                 the_plot_title = "MODIS RGB image",
##                 the_stretch="hist")
>>>>>>> 599b097850692cf12d3ae1162a6118646c5b54e7

