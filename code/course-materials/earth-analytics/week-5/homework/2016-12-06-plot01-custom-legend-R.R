## ----load-libraries------------------------------------------------------
# load libraries
library(raster)
library(rgdal)

## ----convert-to-factor---------------------------------------------------
# import roads
sjer_roads <- readOGR("data/week4/california/madera-county-roads",
                      "tl_2013_06039_roads")
# view the original class of the TYPE column
class(sjer_roads$RTTYP)
unique(sjer_roads$RTTYP)

# set all NA values to "unknown" so they still plot
sjer_roads$RTTYP[is.na(sjer_roads$RTTYP)] <- "unknown"
unique(sjer_roads$RTTYP)

# view levels or categories - note that there are no categories yet in our data!
# the attributes are just read as a list of character elements.
levels(sjer_roads$RTTYP)

# Convert the TYPE attribute into a factor
# Only do this IF the data do not import as a factor!
sjer_roads$RTTYP <- as.factor(sjer_roads$RTTYP)
class(sjer_roads$RTTYP)
levels(sjer_roads$RTTYP)

# how many features are in each category or level?
summary(sjer_roads$RTTYP)

## ----palette-and-plot, fig.cap="Adjust colors on map by creating a palette."----
# count the number of unique values or levels
length(levels(sjer_roads$RTTYP))

# create a color palette of 4 colors - one for each factor level
roadPalette <- c("blue", "green", "grey", "purple")
roadPalette
# create a vector of colors - one for each feature in our vector object
# according to its attribute value
roadColors <- c("blue", "green", "grey", "purple")[sjer_roads$RTTYP]
head(roadColors)

# plot the lines data, apply a diff color to each factor level)
plot(sjer_roads,
     col=roadColors,
     lwd=2,
     main="Madera County Roads")


## ----adjust-line-width, fig.cap="map of madera roads"--------------------
# make all lines thicker
plot(sjer_roads,
     col=roadColors,
     main="Madera County Roads\n All Lines Thickness=6",
     lwd=6)


## ----line-width-unique, fig.cap="Map with legend that shows unique line widths."----
class(sjer_roads$RTTYP)
levels(sjer_roads$RTTYP)
# create vector of line widths
lineWidths <- (c(1, 2, 3, 4))[sjer_roads$RTTYP]
# adjust line width by level
# in this case, boardwalk (the first level) is the widest.
plot(sjer_roads,
     col=roadColors,
     main="Madera County Roads \n Line width varies by TYPE Attribute Value",
     lwd=lineWidths)

## ----roads-map, include=TRUE, results="hide", echo=FALSE, fig.cap="roads map modified"----
# view the factor levels
levels(sjer_roads$RTTYP)
# create vector of line width values
lineWidth <- c(1.5, 1, 2, 3)[sjer_roads$RTTYP]
# view vector
lineWidth

# in this case, boardwalk (the first level) is the widest.
plot(sjer_roads,
     col=roadColors,
     main="Madera County Roads \n Line width varies by Type Attribute Value",
     lwd=lineWidth)


## ----add-legend-to-plot, fig.cap="SJER roads map with custom legend."----
# add legend to plot
plot(sjer_roads,
     col=roadColors,
     main="Madera County Roads\n Default Legend")

# we can use the color object that we created above to color the legend objects
roadPalette

# add a legend to our map
legend("bottomright",   # location of legend
      legend=levels(sjer_roads$RTTYP), # categories or elements to render in
			 # the legend
      fill=roadPalette) # color palette to use to fill objects in legend.


## ----modify-legend-plot, fig.cap="modified custom legend"----------------
# adjust legend
plot(sjer_roads,
     col=roadColors,
     main="Madera County Roads \n Modified Legend - smaller font and no border")
# add a legend to our map
legend("bottomright",
       legend=levels(sjer_roads$RTTYP),
       fill=roadPalette,
       bty="n", # turn off the legend border
       cex=.8) # decrease the font / legend size


## ----plot-different-colors, fig.cap='adjust colors'----------------------

# manually set the colors for the plot!
newColors <- c("springgreen", "blue", "magenta", "orange")
newColors

# plot using new colors
plot(sjer_roads,
     col=(newColors)[sjer_roads$RTTYP],
     main="Madera County Roads \n Pretty Colors")

# add a legend to our map
legend("bottomright",
       levels(sjer_roads$RTTYP),
       fill=newColors,
       bty="n", cex=.8)


## ----road-map-2, include=TRUE, fig.cap='emphasize some attributes'-------
# view levels
levels(sjer_roads$RTTYP)
# make sure the attribute is of class "factor"
class(sjer_roads$RTTYP)

# convert to factor if necessary
sjer_roads$RTTYP <- as.factor(sjer_roads$RTTYP)
levels(sjer_roads$RTTYP)

# count factor levels
length(levels(sjer_roads$RTTYP))
# set colors so only the allowed roads are magenta
# note there are 3 levels so we need 3 colors
challengeColors <- c("magenta","grey","magenta","grey")
challengeColors

# plot using new colors
plot(sjer_roads,
     col=(challengeColors)[sjer_roads$RTTYP],
     lwd=c(4,1,1,1)[sjer_roads$RTTYP],
     main="SJER Roads")

# add a legend to our map
legend("bottomright",
       levels(sjer_roads$RTTYP),
       fill=challengeColors,
       bty="n", # turn off border
       cex=.8) # adjust font size


## ----final-custom-legend, fig.cap="Custom legend with lines"-------------
# plot using new colors
plot(sjer_roads,
     col=(challengeColors)[sjer_roads$RTTYP],
     lwd=c(4,1,2,1)[sjer_roads$RTTYP], # color each line in the map by attribute
     main="Madera County Roads\n County and State recognized roads")

# add a legend to our map
legend("bottomright",
       levels(sjer_roads$RTTYP),
       lty=c(1,1,1,1), # tell are which objects to be drawn as a line in the legend.
       lwd=c(4,1,2,1),  # set the WIDTH of each legend line
       col=challengeColors, # set the color of each legend line
       bty="n", # turn off border
       cex=.8) # adjust font size


## ----legend-points-lines, fig.cap="plot legend with points and lines"----
# import points layer
sjer_plots <- readOGR("data/week4/california/SJER/vector_data",
                      "SJER_plot_centroids")

sjer_plots$plot_type <- as.factor(sjer_plots$plot_type)
levels(sjer_plots$plot_type)

plot_colors <- c("brown", "blue", "green")

# plot using new colors
plot(sjer_plots,
     col=(plot_colors)[sjer_plots$plot_type],
     pch=8,
     main="Madera County Roads\n County and State recognized roads")


# add a legend to our map
legend("bottomright",
       legend = levels(sjer_plots$plot_type),
       pch=c(8,18,8),  # set the WIDTH of each legend line
       col=plot_colors, # set the color of each legend line
       bty="n", # turn off border
       cex=.9) # adjust legend font size


## ----reproject-data, echo=F, warning=F, message=F, fig.cap="plot legend with points and lines and subheading."----

# reproject line and point data
sjer_roads_utm  <- spTransform(sjer_roads,
                                crs(sjer_plots))

sjer_roads_utm <- crop(sjer_roads_utm, sjer_plots)


## ----create-legend-list--------------------------------------------------
c(levels(sjer_plots$plot_type), levels(sjer_roads$RTTYP))


## ----custom-legend-points-lines, fig.cap="final plot custom legend."-----

# plot using new colors
plot(sjer_plots,
     col=(plot_colors)[sjer_plots$plot_type],
     pch=8,
     main="Madera County Roads and plot locations")

# plot using new colors
plot(sjer_roads_utm,
     col=(plot_colors)[sjer_plots$plot_type],
     pch=8,
     add=T)

# add a legend to our map
legend("bottomright",
       legend = c(levels(sjer_plots$plot_type), levels(sjer_roads$RTTYP)),
       pch=c(8,18,8),  # set the WIDTH of each legend line
       col=plot_colors, # set the color of each legend line
       bty="n", # turn off border
       cex=.9) # adjust legend font size

## ----custom-legend-points-lines-2, fig.cap="Plot with points and lines customized."----

# plot using new colors
plot(sjer_plots,
     col=(plot_colors)[sjer_plots$plot_type],
     pch=8,
     main="Madera County Roads and plot locations")

# plot using new colors
plot(sjer_roads_utm,
     col=(plot_colors)[sjer_plots$plot_type],
     pch=8,
     add=T)

# add a legend to our map
legend("bottomright",
       legend = c(levels(sjer_plots$plot_type), levels(sjer_roads$RTTYP)),
       pch=c(8,18,8, NA, NA, NA, NA),  # set the symbol for each point
       lty=c(NA,NA, NA, 1, 1, 1, 1),
       col=plot_colors, # set the color of each legend line
       bty="n", # turn off border
       cex=.9) # adjust legend font size

## ----adjust-legend, fig.cap="plot with fixed legend"---------------------

# figure out where the upper RIGHT hand corner of our plot extent is

the_plot_extent <- extent(sjer_plots)
# grab the upper right hand corner coordinates
furthest_pt_east <- the_plot_extent@xmax
furthest_pt_north <- the_plot_extent@ymax

# set the plot rendering space parameters
par(xpd = T, mar = par()$mar + c(0,0,0,7))

# plot using new colors
plot(sjer_plots,
     col=(plot_colors)[sjer_plots$plot_type],
     pch=8,
     main="Madera County Roads and plot locations")

# plot using new colors
plot(sjer_roads_utm,
     col=(plot_colors)[sjer_plots$plot_type],
     pch=8,
     add=T)

# add a legend to our map
legend(x=furthest_pt_east, y=furthest_pt_north,
       legend = c(levels(sjer_plots$plot_type), levels(sjer_roads$RTTYP)),
       pch=c(8,18,8, NA, NA, NA, NA),  # set the symbol for each point
       lty=c(NA,NA, NA, 1, 1, 1, 1),
       col=plot_colors, # set the color of each legend line
       bty="n", # turn off border
       cex=.9) # adjust legend font size


## ----reset-margin--------------------------------------------------------
# important: remove margins - one you are done, reset the margins
dev.off()

## ----custom-legend-points-lines-3, echo=F, fig.cap="final legend with points and lines customized."----

# set the plot rendering space parameters
par(xpd = T, mar = par()$mar + c(0,0,0,7))

# plot using new colors
plot(sjer_plots,
     col=(plot_colors)[sjer_plots$plot_type],
     pch=8,
     main="Madera County Roads and plot locations")

# plot using new colors
plot(sjer_roads_utm,
     col=(plot_colors)[sjer_plots$plot_type],
     pch=8,
     add=T)

# add a legend to our map
legend(x=(furthest_pt_east+150), y=(furthest_pt_north-10),
       legend = c(levels(sjer_plots$plot_type), "", "Road Types", levels(sjer_roads$RTTYP)),
       pch=c(8,18,8, NA, NA, NA, NA, NA, NA),  # set the symbol for each point
       lty=c(NA,NA, NA, NA, NA,1, 1, 1, 1),
       col=plot_colors, # set the color of each legend line
       bty="n", # turn off border
       cex=.9) # adjust legend font size



## ----reset-margin2-------------------------------------------------------
# important: remove margins - one you are done, reset the margins
dev.off()

