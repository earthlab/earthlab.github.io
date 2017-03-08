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



