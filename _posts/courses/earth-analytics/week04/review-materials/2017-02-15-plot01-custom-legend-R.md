---
layout: single
title: "GIS in R: Plot spatial data and create custom legends in R"
excerpt: "In this lesson we break down the steps required to create a custom legend for spatial data in R. We discuss creating unique symbols per category, customizing colors and placing your legend outside of the plot using the xpd argument combined with x,y placement and margin settings."
authors: ['Leah Wasser']
modified: '2017-08-30'
category: [courses]
class-lesson: ['hw-custom-maps-r']
permalink: /courses/earth-analytics/week-4/r-create-custom-legend-with-base-plot/
nav-title: 'Maps with base plot'
module-title: 'Create maps and custom legends in R with ggplot and base plot'
module-description: 'Learn how to create maps with custom colors and legends in both base R and with ggplot in R.'
module-nav-title: 'Custom maps in R'
module-type: 'class'
week: 4
course: "earth-analytics"
sidebar:
  nav:
author_profile: false
comments: false
order: 1
class-order: 2
topics:
  spatial-data-and-gis: ['vector-data', 'coordinate-reference-systems', 'maps-in-r']
  reproducible-science-and-programming:
---



{% include toc title="In this lesson" icon="file-text" %}

<div class='notice--success' markdown="1">

## <i class="fa fa-graduation-cap" aria-hidden="true"></i> Learning objectives

After completing this tutorial, you will be able to:

* Add a custom legend to a map in `R`
* Plot a vector dataset by attributes in `R`

## <i class="fa fa-check-square-o fa-2" aria-hidden="true"></i> What you need

You will need a computer with internet access to complete this lesson and the data for week 5 of the course.

[<i class="fa fa-download" aria-hidden="true"></i> Download week 5 data (~500 MB)](https://ndownloader.figshare.com/files/7525363){:data-proofer-ignore='' .btn }

</div>

## Plot lines by attribute value
To plot vector data with the color of each objected determined by it's associated attribute values, the
attribute values must be class = `factor`. A **factor** is similar to a category
- you can group vector objects by a particular category value - for example you
can group all lines of `TYPE=footpath`. However, in `R`, a factor can also have
a determined *order*.

By default, `R` will import spatial object attributes as `factors`.

<i class="fa fa-star"></i> **Data tip:** If our data attribute values are not
read in as factors, we can convert the categorical
attribute values using `as.factor()`.
{: .notice--success}




```r
# load libraries
library(raster)
library(rgdal)
options(stringsAsFactors = FALSE)
```

Next, import and explore the data.


```r
# import roads
sjer_roads <- readOGR("data/week_03/california/madera-county-roads",
                      "tl_2013_06039_roads")
## Error in ogrInfo(dsn = dsn, layer = layer, encoding = encoding, use_iconv = use_iconv, : Cannot open data source
# view the original class of the TYPE column
class(sjer_roads$RTTYP)
## Error in eval(expr, envir, enclos): object 'sjer_roads' not found
unique(sjer_roads$RTTYP)
## Error in unique(sjer_roads$RTTYP): object 'sjer_roads' not found
```

It looks like we have some missing values in our road types. We want to plot all
road types even those that are `NA`. Let's change the roads with an `RTTYP` attribute of
`NA` to "unknown".

Following, we can convert the road attribute to a factor.


```r
# set all NA values to "unknown" so they still plot
sjer_roads$RTTYP[is.na(sjer_roads$RTTYP)] <- "Unknown"
## Error in sjer_roads$RTTYP[is.na(sjer_roads$RTTYP)] <- "Unknown": object 'sjer_roads' not found
unique(sjer_roads$RTTYP)
## Error in unique(sjer_roads$RTTYP): object 'sjer_roads' not found

# view levels or categories - note that there are no categories yet in our data!
# the attributes are just read as a list of character elements.
levels(sjer_roads$RTTYP)
## Error in levels(sjer_roads$RTTYP): object 'sjer_roads' not found

# Convert the TYPE attribute into a factor
# Only do this IF the data do not import as a factor!
sjer_roads$RTTYP <- as.factor(sjer_roads$RTTYP)
## Error in as.factor(sjer_roads$RTTYP): object 'sjer_roads' not found
class(sjer_roads$RTTYP)
## Error in eval(expr, envir, enclos): object 'sjer_roads' not found
levels(sjer_roads$RTTYP)
## Error in levels(sjer_roads$RTTYP): object 'sjer_roads' not found

# how many features are in each category or level?
summary(sjer_roads$RTTYP)
## Error in summary(sjer_roads$RTTYP): object 'sjer_roads' not found
```

When we use `plot()`, we can specify the colors to use for each attribute using
the `col=` element. To ensure that `R` renders each feature by it's associated
factor / attribute value, we need to create a `vector` or colors - one for each
feature, according to its associated attribute value / `factor` value.

To create this vector we can use the following syntax:

`c("colorOne", "colorTwo", "colorThree")[object$factor]`

Note in the above example we have

1. A vector of colors - one for each factor value (unique attribute value)
2. The attribute itself (`[object$factor]`) of class `factor`.

Let's give this a try.



```r
# count the number of unique values or levels
length(levels(sjer_roads$RTTYP))
## Error in levels(sjer_roads$RTTYP): object 'sjer_roads' not found

# create a color palette of 4 colors - one for each factor level
roadPalette <- c("blue", "green", "grey", "purple")
roadPalette
## [1] "blue"   "green"  "grey"   "purple"
# create a vector of colors - one for each feature in our vector object
# according to its attribute value
roadColors <- c("blue", "green", "grey", "purple")[sjer_roads$RTTYP]
## Error in eval(expr, envir, enclos): object 'sjer_roads' not found
head(roadColors)
## Error in head(roadColors): object 'roadColors' not found

# plot the lines data, apply a diff color to each factor level)
plot(sjer_roads,
     col=roadColors,
     lwd=2,
     main="Madera County Roads")
## Error in plot(sjer_roads, col = roadColors, lwd = 2, main = "Madera County Roads"): object 'sjer_roads' not found
```

### Adjust line width
We can also adjust the width of our plot lines using `lwd`. We can set all lines
to be thicker or thinner using `lwd=`.


```r
# make all lines thicker
plot(sjer_roads,
     col=roadColors,
     main="Madera County Roads\n All Lines Thickness=6",
     lwd=6)
## Error in plot(sjer_roads, col = roadColors, main = "Madera County Roads\n All Lines Thickness=6", : object 'sjer_roads' not found
```

### Adjust line width by attribute

If we want a unique line width for each factor level or attribute category
in our spatial object, we can use the same syntax that we used for colors, above.

`lwd=c("widthOne", "widthTwo","widthThree")[object$factor]`

Note that this requires the attribute to be of class `factor`. Let's give it a
try.


```r
class(sjer_roads$RTTYP)
## Error in eval(expr, envir, enclos): object 'sjer_roads' not found
levels(sjer_roads$RTTYP)
## Error in levels(sjer_roads$RTTYP): object 'sjer_roads' not found
# create vector of line widths
lineWidths <- (c(1, 2, 3, 4))[sjer_roads$RTTYP]
## Error in eval(expr, envir, enclos): object 'sjer_roads' not found
# adjust line width by level
# in this case, boardwalk (the first level) is the widest.
plot(sjer_roads,
     col=roadColors,
     main="Madera County Roads \n Line width varies by TYPE Attribute Value",
     lwd=lineWidths)
## Error in plot(sjer_roads, col = roadColors, main = "Madera County Roads \n Line width varies by TYPE Attribute Value", : object 'sjer_roads' not found
```

<div class="notice--warning" markdown="1">

## <i class="fa fa-pencil-square-o" aria-hidden="true"></i> Optional challenge: Plot line width by attribute

We can customize the width of each line, according to specific attribute value,
too. To do this, we create a vector of line width values, and map that vector
to the factor levels - using the same syntax that we used above for colors.
HINT: `lwd=(vector of line width thicknesses)[spatialObject$factorAttribute]`

Create a plot of roads using the following line thicknesses:

1. **unknown** lwd = 3
2. **M** lwd = 1
3. **S** lwd = 2
4. **C** lwd = 1.5

</div>


```
## Error in levels(sjer_roads$RTTYP): object 'sjer_roads' not found
## Error in eval(expr, envir, enclos): object 'sjer_roads' not found
## Error in eval(expr, envir, enclos): object 'lineWidth' not found
## Error in plot(sjer_roads, col = roadColors, main = "Madera County Roads \n Line width varies by Type Attribute Value", : object 'sjer_roads' not found
```

<i class="fa fa-star"></i> **Data tip:** Given we have a factor with 4 levels,
we can create an vector of numbers, each of which specifies the thickness of each
feature in our `SpatialLinesDataFrame` by factor level (category): `c(6,4,1,2)[sjer_roads$RTTYP]`
{: .notice--success}

## Add plot legend
We can add a legend to our plot too. When we add a legend, we use the following
elements to specify labels and colors:

* **location**: we can specify an x and Y location of the plot Or generally specify the location e.g. 'bottomright'
keyword. We could also use `top`, `topright`, etc.
* `levels(objectName$attributeName)`: Label the **legend elements** using the
categories of `levels` in an attribute (e.g., levels(sjer_roads$RTTYP) means use
the levels C, S, footpath, etc).
* `fill=`: apply unique **colors** to the boxes in our legend. `palette()` is
the default set of colors that `R` applies to all plots.

Let's add a legend to our plot.


```r
# add legend to plot
plot(sjer_roads,
     col=roadColors,
     main="Madera County Roads\n Default Legend")
## Error in plot(sjer_roads, col = roadColors, main = "Madera County Roads\n Default Legend"): object 'sjer_roads' not found

# we can use the color object that we created above to color the legend objects
roadPalette
## [1] "blue"   "green"  "grey"   "purple"

# add a legend to our map
legend("bottomright",   # location of legend
      legend=levels(sjer_roads$RTTYP), # categories or elements to render in
			 # the legend
      fill=roadPalette) # color palette to use to fill objects in legend.
## Error in levels(sjer_roads$RTTYP): object 'sjer_roads' not found
```

We can tweak the appearance of our legend too.

* `bty=n`: turn off the legend BORDER
* `cex`: change the font size

Let's try it out.


```r
# adjust legend
plot(sjer_roads,
     col=roadColors,
     main="Madera County Roads \n Modified Legend - smaller font and no border")
## Error in plot(sjer_roads, col = roadColors, main = "Madera County Roads \n Modified Legend - smaller font and no border"): object 'sjer_roads' not found
# add a legend to our map
legend("bottomright",
       legend=levels(sjer_roads$RTTYP),
       fill=roadPalette,
       bty="n", # turn off the legend border
       cex=.8) # decrease the font / legend size
## Error in levels(sjer_roads$RTTYP): object 'sjer_roads' not found
```

We can modify the colors used to plot our lines by creating a new color vector,
directly in the plot code too rather than creating a separate object.

`col=(newColors)[sjer_roads$RTTYP]`

Let's try it!


```r

# manually set the colors for the plot!
newColors <- c("springgreen", "blue", "magenta", "orange")
newColors
## [1] "springgreen" "blue"        "magenta"     "orange"

# plot using new colors
plot(sjer_roads,
     col=(newColors)[sjer_roads$RTTYP],
     main="Madera County Roads \n Pretty Colors")
## Error in plot(sjer_roads, col = (newColors)[sjer_roads$RTTYP], main = "Madera County Roads \n Pretty Colors"): object 'sjer_roads' not found

# add a legend to our map
legend("bottomright",
       levels(sjer_roads$RTTYP),
       fill=newColors,
       bty="n", cex=.8)
## Error in levels(sjer_roads$RTTYP): object 'sjer_roads' not found
```

<i class="fa fa-star"></i> **Data tip:** You can modify the defaul R color palette
using the palette method. For example `palette(rainbow(6))` or
`palette(terrain.colors(6))`. You can reset the palette colors using
`palette("default")`!
{: .notice--success}

##  Plot lines by attribute

Create a plot that emphasizes only roads designated as C or S (County or State).
To emphasize these types of roads, make the lines that are C or S, THICKER than
the other lines.
NOTE: this attribute information is located in the `sjer_roads$RTTYP`
attribute.

Be sure to add a title and legend to your map! You might consider a color
palette that has all County and State roads displayed in a bright color. All
other lines can be grey.


```r
# view levels
levels(sjer_roads$RTTYP)
## Error in levels(sjer_roads$RTTYP): object 'sjer_roads' not found
# make sure the attribute is of class "factor"
class(sjer_roads$RTTYP)
## Error in eval(expr, envir, enclos): object 'sjer_roads' not found

# convert to factor if necessary
sjer_roads$RTTYP <- as.factor(sjer_roads$RTTYP)
## Error in as.factor(sjer_roads$RTTYP): object 'sjer_roads' not found
levels(sjer_roads$RTTYP)
## Error in levels(sjer_roads$RTTYP): object 'sjer_roads' not found

# count factor levels
length(levels(sjer_roads$RTTYP))
## Error in levels(sjer_roads$RTTYP): object 'sjer_roads' not found
# set colors so only the allowed roads are magenta
# note there are 3 levels so we need 3 colors
challengeColors <- c("magenta","grey","magenta","grey")
challengeColors
## [1] "magenta" "grey"    "magenta" "grey"

# plot using new colors
plot(sjer_roads,
     col=(challengeColors)[sjer_roads$RTTYP],
     lwd=c(4,1,1,1)[sjer_roads$RTTYP],
     main="SJER Roads")
## Error in plot(sjer_roads, col = (challengeColors)[sjer_roads$RTTYP], lwd = c(4, : object 'sjer_roads' not found

# add a legend to our map
legend("bottomright",
       levels(sjer_roads$RTTYP),
       fill=challengeColors,
       bty="n", # turn off border
       cex=.8) # adjust font size
## Error in levels(sjer_roads$RTTYP): object 'sjer_roads' not found
```

Finall, let's adjust the legend. We want the legend SYMBOLS to represent the
actual symbology in the map - which contains lines, not polygons.


```r
# plot using new colors
plot(sjer_roads,
     col=(challengeColors)[sjer_roads$RTTYP],
     lwd=c(4,1,2,1)[sjer_roads$RTTYP], # color each line in the map by attribute
     main="Madera County Roads\n County and State recognized roads")
## Error in plot(sjer_roads, col = (challengeColors)[sjer_roads$RTTYP], lwd = c(4, : object 'sjer_roads' not found

# add a legend to our map
legend("bottomright",
       levels(sjer_roads$RTTYP),
       lty=c(1,1,1,1), # tell are which objects to be drawn as a line in the legend.
       lwd=c(4,1,2,1),  # set the WIDTH of each legend line
       col=challengeColors, # set the color of each legend line
       bty="n", # turn off border
       cex=.8) # adjust font size
## Error in levels(sjer_roads$RTTYP): object 'sjer_roads' not found
```

<!-- C = County
I = Interstate
M = Common Name
O = Other
S = State recognized
U = U.S.-->

## Adding point and lines to a legend

The last step in customizing a legend is adding different types of symbols to
the plot. In the example above, we just added lines. But what if we wanted to add
some POINTS too? We will do that next.

In the data below, we've create a custom legend where each symbol type and color
is defined using a vector. We have 3 levels: grass, soil and trees. Thus we
need to define 3 symbols and 3 colors for our legend and our plot.

`pch=c(8,18,8)`

`plot_colors <- c("chartreuse4", "burlywood4", "darkgreen")`


```r
# import points layer
sjer_plots <- readOGR("data/week_03/california/SJER/vector_data",
                      "SJER_plot_centroids")
## Error in ogrInfo(dsn = dsn, layer = layer, encoding = encoding, use_iconv = use_iconv, : Cannot open data source
```


```r
sjer_plots$plot_type <- as.factor(sjer_plots$plot_type)
## Error in as.factor(sjer_plots$plot_type): object 'sjer_plots' not found
levels(sjer_plots$plot_type)
## Error in levels(sjer_plots$plot_type): object 'sjer_plots' not found
# grass, soil trees
plot_colors <- c("chartreuse4", "burlywood4", "darkgreen")

# plot using new colors
plot(sjer_plots,
     col=(plot_colors)[sjer_plots$plot_type],
     pch=8,
     main="Madera County Roads\n County and State recognized roads")
## Error in plot(sjer_plots, col = (plot_colors)[sjer_plots$plot_type], pch = 8, : object 'sjer_plots' not found


# add a legend to our map
legend("bottomright",
       legend = levels(sjer_plots$plot_type),
       pch=c(8,18,8),  # set the WIDTH of each legend line
       col=plot_colors, # set the color of each legend line
       bty="n", # turn off border
       cex=.9) # adjust legend font size
## Error in levels(sjer_plots$plot_type): object 'sjer_plots' not found
```

Next, let's try to plot our roads on top of the plot locations. Then let's create
a custom legend that contains both lines and points. NOTE: in this example I've
fixed the projection for the roads layer and cropped it! You will have to do the same before
this code will work.


```
## Error in ogrInfo(dsn = dsn, layer = layer, encoding = encoding, use_iconv = use_iconv, : Cannot open data source
## Error in spTransform(sjer_roads, crs(sjer_aoi)): object 'sjer_roads' not found
## Error in crop(sjer_roads_utm, sjer_aoi): object 'sjer_roads_utm' not found
```

When we create a legend, we will have to add the labels for both the points
layer and the lines layer.

`c(levels(sjer_plots$plot_type), levels(sjer_roads$RTTYP))`


```r
# view all elements in legend
c(levels(sjer_plots$plot_type), levels(sjer_roads$RTTYP))
## Error in levels(sjer_plots$plot_type): object 'sjer_plots' not found
```



```r

# plot using new colors
plot(sjer_plots,
     col=(plot_colors)[sjer_plots$plot_type],
     pch=8,
     main="Madera County Roads and plot locations")
## Error in plot(sjer_plots, col = (plot_colors)[sjer_plots$plot_type], pch = 8, : object 'sjer_plots' not found

# plot using new colors
plot(sjer_roads_utm,
     col=(challengeColors)[sjer_plots$plot_type],
     pch=8,
     add=T)
## Error in plot(sjer_roads_utm, col = (challengeColors)[sjer_plots$plot_type], : object 'sjer_roads_utm' not found

# add a legend to our map
legend("bottomright",
       legend = c(levels(sjer_plots$plot_type), levels(sjer_roads$RTTYP)),
       pch=c(8,18,8),  # set the WIDTH of each legend line
       col=plot_colors, # set the color of each legend line
       bty="n", # turn off border
       cex=.9) # adjust legend font size
## Error in levels(sjer_plots$plot_type): object 'sjer_plots' not found
```


Next we have to tell `R`, which symbols are lines and which are point symbols. We
can do that using the lty argument. We have 3 unique point symbols and 4 unique
line symbols. We can include a `NA` for each element that should not be a line in
the `lty` argument:

`lty=c(NA, NA, NA, 1, 1, 1, 1)`

And we include a `NA` value for each element that should not be a symbol in the
`pch` argument:

`pch=c(8, 18, 8, NA, NA, NA, NA)``


```r

# plot using new colors
plot(sjer_plots,
     col=(plot_colors)[sjer_plots$plot_type],
     pch=8,
     main="Madera County Roads and plot locations")
## Error in plot(sjer_plots, col = (plot_colors)[sjer_plots$plot_type], pch = 8, : object 'sjer_plots' not found

# plot using new colors
plot(sjer_roads_utm,
     col=(challengeColors)[sjer_plots$plot_type],
     pch=8,
     add=T)
## Error in plot(sjer_roads_utm, col = (challengeColors)[sjer_plots$plot_type], : object 'sjer_roads_utm' not found

# add a legend to our map
legend("bottomright",
       legend = c(levels(sjer_plots$plot_type), levels(sjer_roads$RTTYP)),
       pch=c(8,18,8, NA, NA, NA, NA),  # set the symbol for each point
       lty=c(NA,NA, NA, 1, 1, 1, 1),
       col=c(plot_colors, challengeColors), # set the color of each legend line
       bty="n", # turn off border
       cex=.9) # adjust legend font size
## Error in levels(sjer_plots$plot_type): object 'sjer_plots' not found
```


## Force the legend to plot next to your plot

Refining the look of your plots takes a bit of patience in `R`, but it can be
done! Play with the code below to see if you can make your legend plot NEXT TO
rather than on top of your plot.

The steps are:

1. Place your legend on the OUTSIDE of the plot extent by grabbing the `xmax` and `ymax` values from one of the objects that you are plotting's `extent()`. This allows you to be precise in your legend placement.
2. Set the `xpd=T` argument in your legend to enforce plotting outside of the plot extent and
3. OPTIONAL:  adjust the plot **PAR**ameters using `par()`. You can set the **mar**gin
of your plot using `mar=`. This provides extra space on the right (if you'd like your legend to plot on the right) for your legend and avoids things being "chopped off". Provide the `mar=` argument in the
format: `c(bottom, left, top, right)`. The code below is telling `R` to add 7 units
of padding on the RIGHT hand side of our plot. The default units are INCHES.

**IMPORTANT:** be cautious with margins. Sometimes they can cause problems when you
knit - particularly if they are too large.

Let's give this a try. First, we grab the northwest corner location x and y. We
will use this to place our legend.


```r
# figure out where the upper RIGHT hand corner of our plot extent is
the_plot_extent <- extent(sjer_aoi)
## Error in extent(sjer_aoi): object 'sjer_aoi' not found

# grab the upper right hand corner coordinates
furthest_pt_east <- the_plot_extent@xmax
## Error in eval(expr, envir, enclos): object 'the_plot_extent' not found
furthest_pt_north <- the_plot_extent@ymax
## Error in eval(expr, envir, enclos): object 'the_plot_extent' not found
# view values
furthest_pt_east
## Error in eval(expr, envir, enclos): object 'furthest_pt_east' not found
furthest_pt_north
## Error in eval(expr, envir, enclos): object 'furthest_pt_north' not found

# plot using new colors
plot(sjer_plots,
     col=(plot_colors)[sjer_plots$plot_type],
     pch=8,
     main="Madera County Roads and plot locations")
## Error in plot(sjer_plots, col = (plot_colors)[sjer_plots$plot_type], pch = 8, : object 'sjer_plots' not found

# plot using new colors
plot(sjer_roads_utm,
     col=(challengeColors)[sjer_plots$plot_type],
     pch=8,
     add=T)
## Error in plot(sjer_roads_utm, col = (challengeColors)[sjer_plots$plot_type], : object 'sjer_roads_utm' not found

# add a legend to our map
legend(x=furthest_pt_east, y=furthest_pt_north,
       legend = c(levels(sjer_plots$plot_type), levels(sjer_roads$RTTYP)),
       pch=c(8, 18, 8, NA, NA, NA, NA),  # set the symbol for each point
       lty=c(NA, NA, NA, 1, 1, 1, 1) ,
       col=c(plot_colors, challengeColors), # set the color of each legend line
       bty="n", # turn off border
       cex=.9, # adjust legend font size
       xpd=T) # force the legend to plot outside of your extent
## Error in levels(sjer_plots$plot_type): object 'sjer_plots' not found
```



Let's use the margin parameter to clean things up. Also notice I'm using the
AOI extent layer to create a "box" around my plot. Now things are starting to
look much cleaner!

I've also added some "fake" legend elements to create subheadings like we
might add to a map legend in `QGIS` or `ArcGIS`.

`legend = c("Plots", levels(sjer_plots$plot_type), "Road Types", levels(sjer_roads$RTTYP))`


```r
# adjust margin to make room for the legend
par(mar=c(2, 2, 4, 7))
# plot using new colors
plot(sjer_aoi,
     border="grey",
     lwd=2,
     main="Madera County Roads and plot locations")
## Error in plot(sjer_aoi, border = "grey", lwd = 2, main = "Madera County Roads and plot locations"): object 'sjer_aoi' not found
plot(sjer_plots,
     col=(plot_colors)[sjer_plots$plot_type],
     add=T,
     pch=8)
## Error in plot(sjer_plots, col = (plot_colors)[sjer_plots$plot_type], add = T, : object 'sjer_plots' not found
# plot using new colors
plot(sjer_roads_utm,
     col=(challengeColors)[sjer_plots$plot_type],
     pch=8,
     add=T)
## Error in plot(sjer_roads_utm, col = (challengeColors)[sjer_plots$plot_type], : object 'sjer_roads_utm' not found

# add a legend to our map
legend(x=(furthest_pt_east+50), y=(furthest_pt_north-15),
       legend = c("Plots", levels(sjer_plots$plot_type), "Road Types", levels(sjer_roads$RTTYP)),
       pch=c(NA, 8, 18, 8, NA, NA, NA, NA, NA),  # set the symbol for each point
       lty=c(NA,NA,NA, NA, NA, 1, 1, 1, 1),
       col=c(plot_colors, challengeColors), # set the color of each legend line
       bty="n", # turn off border
       cex=.9, # adjust legend font size
       xpd=T)
## Error in levels(sjer_plots$plot_type): object 'sjer_plots' not found
```



Let's take customization a step further. I can adjust the font styles in the legend
too to make it look **even prettier**. To do this, we use the `text.font` argument.

The possible values for the `text.font` argument are:

* 1: normal
* 2: bold
* 3: italic
* 4: bold and italic

Notice below, i am passing a vector of values, one value to represent each
element in the legend.


```r
# adjust margin to make room for the legend
par(mar=c(2, 2, 4, 7))
# plot using new colors
plot(sjer_aoi,
     border="grey",
     lwd=2,
     main="Madera County Roads and plot locations")
## Error in plot(sjer_aoi, border = "grey", lwd = 2, main = "Madera County Roads and plot locations"): object 'sjer_aoi' not found
plot(sjer_plots,
     col=(plot_colors)[sjer_plots$plot_type],
     add=T,
     pch=8)
## Error in plot(sjer_plots, col = (plot_colors)[sjer_plots$plot_type], add = T, : object 'sjer_plots' not found
# plot using new colors
plot(sjer_roads_utm,
     col=(challengeColors)[sjer_plots$plot_type],
     pch=8,
     add=T)
## Error in plot(sjer_roads_utm, col = (challengeColors)[sjer_plots$plot_type], : object 'sjer_roads_utm' not found

# add a legend to our map
legend(x=(furthest_pt_east+50), y=(furthest_pt_north-15),
       legend = c("Plots", levels(sjer_plots$plot_type), "Road Types", levels(sjer_roads$RTTYP)),
       pch=c(NA, 8, 18, 8, NA, NA, NA, NA, NA),  # set the symbol for each point
       lty=c(NA,NA,NA, NA, NA, 1, 1, 1, 1),
       col=c(plot_colors, challengeColors), # set the color of each legend line
       bty="n", # turn off border
       cex=.9, # adjust legend font size
       xpd=T,
       text.font =c(2, 1, 1, 1, 2, 1, 1, 1, 1))
## Error in levels(sjer_plots$plot_type): object 'sjer_plots' not found
```



Now, if you want to move the legend out a bit further, what would you do?

## BONUS!

Any idea how I added a space to the legend below to create "sections"?


```
## Error in plot(sjer_aoi, border = "grey", lwd = 2, main = "Madera County Roads and plot locations"): object 'sjer_aoi' not found
## Error in plot(sjer_plots, col = (plot_colors)[sjer_plots$plot_type], add = T, : object 'sjer_plots' not found
## Error in plot(sjer_roads_utm, col = (challengeColors)[sjer_plots$plot_type], : object 'sjer_roads_utm' not found
## Error in levels(sjer_plots$plot_type): object 'sjer_plots' not found
```


```r
# important: once you are done, reset par which resets plot margins
# otherwise margins will carry over to your next plot and cause problems!
dev.off()
```
