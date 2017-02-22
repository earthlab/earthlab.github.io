## ----crop-naip-imagey, echo=F, results='hide', message=F, warning=F------
library(raster)
library(rgeos)
library(rgdal)
# import stack
rgb_image_3bands <- stack("data/week6/naip/m_3910505_nw_13_1_20130926/crop/m_3910505_nw_13_1_20130926_crop.tif")
# import vector that we used to crop the data
# csf_crop <- readOGR("data/week6/vector_layers/fire_crop_box_500m.shp")


## ----demonstrate-RGB-Image, echo=FALSE, fig.cap="single band image"------
# plot 1 band
rgb_image <- raster("data/week6/naip/m_3910505_nw_13_1_20130926/crop/m_3910505_nw_13_1_20130926_crop.tif")
# does this look like a color image?
plot(rgb_image,
     main="Plot of one band in a multi-band raster",
     col=gray(0:100 / 100))

## ----plot-3-bands, echo=F, fig.cap="All bands plotted separately"--------
# use stack function to read in all bands of a color image
rgb_image_3bands <- stack("data/week6/naip/m_3910505_nw_13_1_20130926/crop/m_3910505_nw_13_1_20130926_crop.tif")
names(rgb_image_3bands) <- c("red_band", "green_band", "blue_band", "near_infrared_band")

plot(rgb_image_3bands,
     col=gray(0:100 / 100))


## ----plot-rgb-example, echo=F, fig.cap="3 band image plot rgb"-----------
# Create an RGB image from the raster stack
par(col.axis="white", col.lab="white", tck=0)
plotRGB(rgb_image_3bands,
        stretch="lin",
        axes=TRUE,
        main="Red, green, blue composite image")
box(col="white") # turn all of the lines to white

## ----cir-image, echo=F, fig.cap="3 band cir image"-----------------------
# Create an RGB image from the raster stack
par(col.axis="white",col.lab="white",tck=0)
# CIR image
plotRGB(rgb_image_3bands,
        r=4,g=3,b=2,
        main="Color infrared image\n Near infrared, green, blue",
        axes=T)
box(col="white") # turn all of the lines to white


## ---- echo=F, warning=F, message=F, results="hide"-----------------------
dev.off()

## ----load-packages, warning=F, message=F, results="hide"-----------------
# load spatial packages
library(raster)
library(rgdal)
library(rgeos)


## ----read-single-band, fig.cap="naip imagery single band plot."----------
# Read in multi-band raster with raster function.
# the first band will be read in automatically
# csf = cold springs fire!
naip_csf <- raster("data/week6/naip/m_3910505_nw_13_1_20130926/crop/m_3910505_nw_13_1_20130926_crop.tif")

# Plot band 1
plot(naip_csf,
     col=gray(0:100 / 100),
     axes=FALSE,
     main="NAIP RGB Imagery - Band 1-Red\nCold Springs Fire Scar")

# view data dimensions, CRS, resolution, attributes, and band info
naip_csf

## ----min-max-image-------------------------------------------------------
# view min value
minValue(naip_csf)

# view max value
maxValue(naip_csf)

## ----read-specific-band, fig.cap="naip imagery band 2 plot."-------------
# Can specify which band we want to read in
rgb_band2 <- raster("data/week6/naip/m_3910505_nw_13_1_20130926/crop/m_3910505_nw_13_1_20130926_crop.tif",
             band = 2)

# plot band 2
plot(rgb_band2,
     col=gray(0:100 / 100),
     axes=FALSE,
     main="RGB Imagery - Band 2 - Green\nCold Springs Fire Scar")

# view attributes of band 2
rgb_band2

## ----intro-to-raster-stacks----------------------------------------------
# Use stack function to read in all bands
naip_stack_csf <-
  stack("data/week6/naip/m_3910505_nw_13_1_20130926/crop/m_3910505_nw_13_1_20130926_crop.tif")

# view attributes of stack object
naip_stack_csf


## ----view-layers---------------------------------------------------------
# view raster attributes
naip_stack_csf@layers

## ----view-one-band-------------------------------------------------------
# view attributes for one band
naip_stack_csf[[1]]

## ----hist-all-layers, fig.cap="histogram of each band for a total of 4 bands"----
# view histogram for each band
hist(naip_stack_csf,
     maxpixels=ncell(naip_stack_csf),
     col="purple")

## ----plot-all-layers, fig.cap="plot each band for a total of 4 bands"----
# plot 4 bands separately
plot(naip_stack_csf,
     col=gray(0:100 / 100))

## ----plot-individual-bands, fig.cap="plot individual band - band 2"------
# plot band 2
plot(naip_stack_csf[[2]],
     main="NAIP Band 2\n Coldsprings Fire Site",
     col=gray(0:100 / 100))

## ----challenge1-answer, eval=FALSE, echo=FALSE---------------------------
## # We'd expect a *brighter* value for the forest in band 2 (green) than in
## # band 1 (red) because the leaves on trees of most often appear "green" -
## # healthy leaves reflect MORE green light compared to red light
## # however the brightest values should be in the NIR band.
## 

## ----clear-dev, echo=F, warning=F, message=F, results='hide'-------------
dev.off()

## ----plot-rgb-image, fig.cap="RGB image of NAIP imagery."----------------
# Create an RGB image from the raster stack
plotRGB(naip_stack_csf,
        r = 1, g = 2, b = 3,
        main="RGB image \nColdsprings fire scar")

## ----plot-rgb-image-title, fig.cap="RGB image of NAIP imagery."----------
# adjust the plot parameters to render the axes using white
# this is a way to "trick" R
par(col.axis="white", col.lab="white", tck=0)
plotRGB(naip_stack_csf,
        r = 1, g = 2, b = 3,
        axes=T,
        main="NAIP RGB image \nColdsprings fire scar")
box(col="white") # turn all of the lines to white


## ----image-stretch, fig.cap="lin stretch rgb image"----------------------
# what does stretch do?
plotRGB(naip_stack_csf,
        r = 1, g = 2, b = 3,
        axes=T,
        stretch = "lin",
        main="NAIP RGB plot with linear stretch\nColdsprings fire scar")

## ----plot-rgb-hist-stretch, fig.cap="plot RGB with his stretch"----------
par(col.axis="white", col.lab="white", tck=0)
plotRGB(naip_stack_csf,
        r = 1, g = 2, b = 3,
        axes=T,
        scale=800,
        stretch = "hist",
        main="NAIP RGB plot with hist stretch\nColdsprings fire scar")
box(col="white") # turn all of the lines to white


## ----raster-bricks-------------------------------------------------------
# view size of the RGB_stack object that contains our 3 band image
object.size(naip_stack_csf)

# convert stack to a brick
naip_brick_csf <- brick(naip_stack_csf)

# view size of the brick
object.size(naip_brick_csf)


## ----plot-brick----------------------------------------------------------
par(col.axis="white", col.lab="white", tck=0)
# plot brick
plotRGB(naip_brick_csf,
  main="NAIP plot from a rasterbrick",
  axes=T)
box(col="white") # turn all of the lines to white


## ----challenge, echo=F, warning=F, message=F, fig.cap="challenge rgb plot 2015 data"----
# import and plot data
csf_2015_naip_stack <- stack("data/week6/naip/m_3910505_nw_13_1_20150919/crop/m_3910505_nw_13_1_20150919_crop.tif")

#csf_2015_naip_stack <- stack("data/week6/naip/m_3910505_nw_13_1_20150919/m_3910505_nw_13_1_20150919.tif")
par(col.axis="white", col.lab="white", tck=0)
plotRGB(csf_2015_naip_stack,
        main="NAIP RGB plot \nColdsprings fire scar",
        axes=T)
box(col="white") # turn all of the lines to white


## ----challenge2, echo=F, warning=F, message=F, fig.cap="challenge cir plot 2015 data"----
par(col.axis="white", col.lab="white", tck=0)
# rgb image
plotRGB(csf_2015_naip_stack,
        r=4, g=3, b=2,
        axes=T,
        main="NAIP CIR plot \nColdsprings fire scar")
box(col="white") # turn all of the lines to white


## ----challenge-code-calling-methods, include=TRUE, results="hide", echo=FALSE----
# 1
# methods for calling a stack
methods(class=class(naip_stack_csf))
# 143 methods!

# 2
# methods for calling a band (1) with a stack
methods(class=class(naip_stack_csf[1]))

#3 There are far more thing one could or wants to ask of a full stack than of
# a single band.

