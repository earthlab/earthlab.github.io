## ----load-packages, warning=F, message=F, results="hide"-----------------
# load spatial packages
library(raster)
library(rgdal)
library(rgeos)
# turn off factors
options(stringsAsFactors = F)

## ----create-landsat-stack------------------------------------------------
all_landsat_bands <- list.files("data/week6/Landsat/LC80340322016205-SC20170127160728/crop",
           pattern=glob2rx("*band*.tif$"),
           full.names = T) # use the dollar sign at the end to get all files that END WITH
all_landsat_bands

# stack the data
landsat_stack_csf <- stack(all_landsat_bands)

## ----calculate-ndvi, fig.cap="landsat derived NDVI plot"-----------------

landsat_ndvi <- (landsat_stack_csf[[5]] - landsat_stack_csf[[4]]) / (landsat_stack_csf[[5]] + landsat_stack_csf[[4]])

plot(landsat_ndvi,
     main="Landsat derived NDVI\n 23 July 2016")

## ----ndvi-hist, fig.cap="histogram"--------------------------------------
# view distribution of NDVI values
hist(landsat_ndvi)


## ----export-raster, eval=F-----------------------------------------------
## # export raster
## # NOTE: this won't work if you don't have an outputs directory in your week6 dir!
## writeRaster(x = landsat_ndvi,
##               filename="data/week6/outputs/landsat_ndvi.tif",
##               format = "GTiff", # save as a tif
##               datatype='INT2S', # save as a INTEGER rather than a float
##               overwrite = T)  # OPTIONAL - be careful. this will OVERWRITE previous files.

## ----calculate-nbr, echo=F, fig.cap="landsat derived NDVI plot"----------
# bands 7 and 5
landsat_nbr <- ((landsat_stack_csf[[5]] - landsat_stack_csf[[7]]) / (landsat_stack_csf[[5]] + landsat_stack_csf[[7]])) * 1000

plot(landsat_nbr,
     main="Landsat derived NBR\n 23 July 2016",
     axes=F,
     box=F)

## ----classify-output, echo=F, fig.cap="classified NBR output"------------
# create classification matrix
reclass <- c(-500, -100, 1,
             -100, 99, 2,
             100, 269, 3,
             270, 660, 4,
             660, 1300, 5)
# reshape the object into a matrix with columns and rows
reclass_m <- matrix(reclass,
                ncol=3,
                byrow=TRUE)

nbr_classified <- reclassify(landsat_nbr,
                     reclass_m)
the_colors = c("palevioletred4","palevioletred1","ivory1","seagreen1","seagreen4")

# mar bottom, left, top and right
par(xpd = F, mar=c(0,0,0,5))
plot(nbr_classified,
     col=the_colors,
     legend=F,
     main="NBR",
     axes=F,
     box=F)
par(xpd = TRUE)
legend(nbr_classified@extent@xmax-100, nbr_classified@extent@ymax,
       c("Enhanced Regrowth", "Unburned", "Low Severity", "Moderate Severity", "High Severity"),
       fill=the_colors,
       cex=.9,
       bty="n")



## ----dev-off, warning=F, message=F, results="hide"-----------------------
dev.off()

## ----view-hist, warning=F, echo=F, fig.cap="plot hist"-------------------
barplot(nbr_classified,
        main="Distribution of Classified NBR Values",
        col=the_colors)

