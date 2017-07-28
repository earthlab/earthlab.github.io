---
layout: single
title: "Create custom maps with ggplot in R - GIS in R"
excerpt: "In this lesson we break down the steps to create a map in R using ggplot."
authors: ['Leah Wasser']
modified: '2017-07-28'
category: [course-materials]
class-lesson: ['hw-custom-maps-r']
permalink: /course-materials/earth-analytics/week-4/r-make-maps-with-ggplot-in-R/
nav-title: 'Maps with ggplot'
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

# remove module-type: 'class' so it doesn't render live

{% include toc title="In This Lesson" icon="file-text" %}

<div class='notice--success' markdown="1">

## <i class="fa fa-graduation-cap" aria-hidden="true"></i> Learning Objectives

After completing this tutorial, you will be able to:

* Add a custom legend to a map in `R`.
* Plot a vector dataset by attributes in `R`.

## <i class="fa fa-check-square-o fa-2" aria-hidden="true"></i> What you need

You will need a computer with internet access to complete this lesson and the data for week 5 of the course.

[<i class="fa fa-download" aria-hidden="true"></i> Download week 5 Data (~500 MB)](https://ndownloader.figshare.com/files/7525363){:data-proofer-ignore='' .btn }

</div>

## Plot Lines by Attribute Value

To plot vector data with the color of each objected determined by it's associated attribute values, the
attribute values must be class = `factor`. A **factor** is similar to a category
- you can group vector objects by a particular category value - for example you
can group all lines of `TYPE=footpath`. However, in `R`, a factor can also have
a determined *order*.

By default, `R` will import spatial object attributes as `factors`.

<i class="fa fa-star"></i> **Data Tip:** If our data attribute values are not
read in as factors, we can convert the categorical
attribute values using `as.factor()`.
{: .notice--success}




```r
# load libraries
library(raster)
library(rgdal)
library(ggplot2)
library(broom)
library(RColorBrewer)
library(rgeos)
library(dplyr)
# note that you don't need to call maptools to run the code below but it needs to be installed.
library(maptools)
options(stringsAsFactors = FALSE)
```

Next, import and explore the data.


```r
# import roads
sjer_roads <- readOGR("data/week5/california/madera-county-roads/tl_2013_06039_roads.shp")
## OGR data source with driver: ESRI Shapefile 
## Source: "data/week5/california/madera-county-roads/tl_2013_06039_roads.shp", layer: "tl_2013_06039_roads"
## with 9640 features
## It has 4 fields
# view the original class of the TYPE column
class(sjer_roads$RTTYP)
## [1] "character"
unique(sjer_roads$RTTYP)
## [1] "M" NA  "S" "C"
# quick plot
plot(sjer_roads)
```

<img src="{{ site.url }}/images/rfigs/course-materials/earth-analytics/week04/review-materials/2017-02-15-plot02-custom-mapsggplot-R/convert-to-factor-1.png" title=" " alt=" " width="100%" />

## Simplify geometry
This roads data contains many roads. The complexity of the data is slowing things
down in R. Given we are just going to plot the data, let's simplify it some by reducing the number of verticies. We can us `rgeos::Gsimplify` to do this.


```r
sjer_roads <- gSimplify(sjer_roads_full, tol = .001)
plot(sjer_roads,
     main = "Roads data - simplified vertices")
```

It looks like we have some missing values in our road types. We want to plot all
road types even those that are NA. Let's change the roads with an `RTTYP` attribute of
NA to "unknown".

Following, we can convert the road attribute to a factor.


```r
# set all NA values to "unknown" so they still plot
sjer_roads$RTTYP[is.na(sjer_roads$RTTYP)] <- "Unknown"
unique(sjer_roads$RTTYP)
## [1] "M"       "Unknown" "S"       "C"
sjer_roads$RTTYP <- as.factor(sjer_roads$RTTYP)

# how many features are in each category or level?
summary(sjer_roads$RTTYP)
##       C       M       S Unknown 
##      10    4456      25    5149
```

## Convert spatial data to a data.frame

When we're plotting with baseplot, we can plot spatial sp or raster objects directly
without convertting them. However `ggplot()` requires a data.frame. Thus we will
need to convert our data. We can convert he data using the `tidy()` function from
the broom package in R.

<i class="fa fa-star"></i> **Data Tip:** the tidy function used to be the fortify
function! The code for the `tidy()` function is exactly the same as the `fortify()` code.
{: .notice--success}

Below we convert the data by:

1. calling the tidy function on our `sjer_roads` spatial object
1. add an id field to the spatial object data frame
1. joining the table from the spatial object to the data.frame output of the tidy() function

Let's convert our spatial object to a `data.frame`.


```r
# convert spatial object to a ggplot ready data frame
sjer_roads_df <- tidy(sjer_roads, region = "id")
# make sure the shapefile attribute table has an id column
sjer_roads$id <- rownames(sjer_roads@data)
# join the attribute table from the spatial object to the new data frame
sjer_roads_df <- left_join(sjer_roads_df,
                           sjer_roads@data,
                           by = "id")
```

Once we've done this, we are ready to plot with `ggplot()`. Note the following when
we plot.

1. the x and y values are long and lat. These are columns that the `tidy()` function generates from a spatial object.
1. the group function allows R to figure out what vertices below to which feature. So in this case we are plotting lines - each of which consist of 2 or more vertices that are connected.


```r
# plot the lines data, apply a diff color to each factor level)
ggplot() +
  geom_path(data = sjer_roads_df, aes(x = long, y = lat, group = group)) +
  labs(title = "ggplot map of roads")
```

<img src="{{ site.url }}/images/rfigs/course-materials/earth-analytics/week04/review-materials/2017-02-15-plot02-custom-mapsggplot-R/plot-roads-data-1.png" title="Basic ggplot of roads." alt="Basic ggplot of roads." width="100%" />

We can color each line by type too by adding the attribute that we wish to use
for categories or types to the color  = argument.

Below we set the colors to `color = factor(RTTYP)`.


```r
# plot roads by attribute
ggplot() +
  geom_path(data = sjer_roads_df, aes(x = long, y = lat,
                                      group = group, color = factor(RTTYP))) +
labs(color = 'Road Types', # change the legend type
     title = "Roads colored by the RTTP attribute")
```

<img src="{{ site.url }}/images/rfigs/course-materials/earth-analytics/week04/review-materials/2017-02-15-plot02-custom-mapsggplot-R/roads-axis-cleaned-1.png" title="Basic plot with title and legend title" alt="Basic plot with title and legend title" width="100%" />

We can customize the colors on our map too. Below we do a few things

1. we figure out how many unique road types we have
1. we specify the colors that we want to apply to each road type
1. finally we plot the data - we will use the `scale_colour_manual(values = c("color1", "color2", "color3", "color4"))`

Let's plot our roads data by the `RTTP` attribute and apply unique colors.


```r
# count the number of unique values or levels
length(levels(sjer_roads$RTTYP))
## [1] 4

# create a color palette of 4 colors - one for each factor level
road_palette <- c("green", "grey40", "purple", "grey")
road_palette
## [1] "green"  "grey40" "purple" "grey"

# plot with custom colors
# size adjusts the line widht
ggplot() +
  geom_path(data = sjer_roads_df, aes(x = long, y = lat,
                                      group = group, color=factor(RTTYP))) +
      scale_colour_manual(values = road_palette) +
  labs(title = "Madera County Roads ",
       subtitle = "Colored by road type")
```

<img src="{{ site.url }}/images/rfigs/course-materials/earth-analytics/week04/review-materials/2017-02-15-plot02-custom-mapsggplot-R/palette-and-plot-1.png" title="Adjust colors on map by creating a palette." alt="Adjust colors on map by creating a palette." width="100%" />

Finally we can remove the axis ticks and labels using a theme() element.
Themes are used in `ggplot()` to customize the look of a plot. You can customize
any element of the plot including fonts, colors and more!

Below we do the following

1. we remove the x and y axis ticks and label using the theme argument
1. we remove the x and y labels using the x and y = elements in the labs() function
3. we customize the legend title using labs(`color =`)

Let's give it a try.


```r
# size adjusts the line widht
ggplot() +
  geom_path(data = sjer_roads_df, aes(x = long, y = lat,
                                      group = group, color = factor(RTTYP))) +
      scale_colour_manual(values = road_palette) +
  labs(title = "Madera County Roads ",
       subtitle = "Colored by road type",
       color = "Road type",
       x = "", y = "") +
  theme(axis.text = element_blank(), axis.ticks = element_blank())
```

<img src="{{ site.url }}/images/rfigs/course-materials/earth-analytics/week04/review-materials/2017-02-15-plot02-custom-mapsggplot-R/roads-axis-cleand-1.png" title="Roads ggplot map with axes customized." alt="Roads ggplot map with axes customized." width="100%" />

Finally we can use `coord_fixed()` to ensure a to scale x and y axis.


```r
# size adjusts the line widht
ggplot() +
  geom_path(data = sjer_roads_df, aes(x = long, y = lat,
                                      group = group, color = factor(RTTYP))) +
      scale_colour_manual(values = road_palette) +
  labs(title = "Madera County Roads ",
       subtitle = "Colored by road type",
       color = "Road type",
       x = "", y = "") +
  theme(axis.text = element_blank(), axis.ticks = element_blank()) +
  coord_fixed()
```

<img src="{{ site.url }}/images/rfigs/course-materials/earth-analytics/week04/review-materials/2017-02-15-plot02-custom-mapsggplot-R/roads-ratio-1.png" title="Roads ggplot map with aspect ratio fixed." alt="Roads ggplot map with aspect ratio fixed." width="100%" />

# r for spatial analysis --
# https://us.sagepub.com/en-us/nam/an-introduction-to-r-for-spatial-analysis-and-mapping/book241031

### Adjust Line Width

We can adjust the width of our plot lines using `size`. We can set all lines
to be thicker or thinner using `size =` argument. Note that you want to set the
size **outside** of the aesthetics function rather than within it!


```r
# size adjusts the line widht
ggplot() +
  geom_path(data = sjer_roads_df, aes(x = long, y = lat,
                                      group = group, color = factor(RTTYP)), size = 1.1) +
      scale_colour_manual(values = road_palette) +
  labs(title = "Madera County Roads ",
       subtitle = "With big fat lines!",
       color = "Road type",
       x = "", y = "") +
  theme(axis.text = element_blank(), axis.ticks = element_blank()) +
  coord_fixed()
```

<img src="{{ site.url }}/images/rfigs/course-materials/earth-analytics/week04/review-materials/2017-02-15-plot02-custom-mapsggplot-R/roads-line-width-1.png" title="Roads ggplot map with line width set." alt="Roads ggplot map with line width set." width="100%" />

### Adjust Line Width by Attribute

If we want a unique line width for each factor level or attribute category
in our spatial object, we can use the same syntax that we used for colors, above.

`lwd=c("widthOne", "widthTwo","widthThree")[object$factor]`

Note that this requires the attribute to be of class `factor`. Let's give it a
try.



```r
# size adjusts the line width
# still not working as expected - why does it plot 2 legends
# using size for a discrete variable is not advised error -- need to figure this out?
ggplot() +
  geom_line(data = sjer_roads_df, aes(x = long, y = lat,
                                      group = group,
                                      colour = factor(RTTYP),
                                      size = factor(RTTYP))) +
  scale_size_manual(values = c(.5, 1, 1, .5)) +
      scale_colour_manual(values = road_palette) +
  labs(title = "Madera County Roads ",
       subtitle = "With big fat lines!",
       color = "Road type",
       x = "", y = "") +
  theme(axis.text = element_blank(), axis.ticks = element_blank()) +
  coord_fixed()
```

<img src="{{ site.url }}/images/rfigs/course-materials/earth-analytics/week04/review-materials/2017-02-15-plot02-custom-mapsggplot-R/roads-line-width2-1.png" title="Roads ggplot map with line width set." alt="Roads ggplot map with line width set." width="100%" />


The map above looks ok but we have multiple legends when we really just want one 
legend for both color and size. We can merge the legend using the guides() function. 
Here we specify each legend element that we wish to merge together as follows:

`guides(colour = guide_legend("Legend title here"), size = guide_legend("Same legend title here"))`



```r
# size adjusts the line width
# still not working as expected - why does it plot 2 legends
# using size for a discrete variable is not advised error -- need to figure this out?
ggplot() +
  geom_line(data = sjer_roads_df, aes(x = long, y = lat,
                                      group = group,
                                      colour = factor(RTTYP),
                                      size = factor(RTTYP))) +
  scale_size_manual(values = c(.5, 1, 1, .5)) +
      scale_colour_manual(values = road_palette) +
  guides(colour = guide_legend("Road Type"), size = guide_legend("Road Type")) +
  labs(title = "Madera County Roads ",
       subtitle = "With big fat lines!",
       color = "Road type",
       x = "", y = "") +
  theme(axis.text = element_blank(), axis.ticks = element_blank()) +
  coord_fixed()
```

<img src="{{ site.url }}/images/rfigs/course-materials/earth-analytics/week04/review-materials/2017-02-15-plot02-custom-mapsggplot-R/roads-line-width-custom-1.png" title="Roads ggplot map with line width set." alt="Roads ggplot map with line width set." width="100%" />

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




<i class="fa fa-star"></i> **Data Tip:** We can modify the defaul R color palette
using the palette method. For example `palette(rainbow(6))` or
`palette(terrain.colors(6))`. You can reset the palette colors using
`palette("default")`!
{: .notice--success}


##  Plot Lines by Attribute

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
## [1] "C"       "M"       "S"       "Unknown"
# make sure the attribute is of class "factor"
class(sjer_roads$RTTYP)
## [1] "factor"

# convert to factor if necessary
sjer_roads$RTTYP <- as.factor(sjer_roads$RTTYP)
levels(sjer_roads$RTTYP)
## [1] "C"       "M"       "S"       "Unknown"

# count factor levels
length(levels(sjer_roads$RTTYP))
## [1] 4
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

# add a legend to our map
legend("bottomright",
       levels(sjer_roads$RTTYP),
       fill=challengeColors,
       bty="n", # turn off border
       cex=.8) # adjust font size
```

<img src="{{ site.url }}/images/rfigs/course-materials/earth-analytics/week04/review-materials/2017-02-15-plot02-custom-mapsggplot-R/road-map-2-1.png" title="emphasize some attributes" alt="emphasize some attributes" width="100%" />


<!-- C = County
I = Interstate
M = Common Name
O = Other
S = State recognized
U = U.S.-->

## Adding points and lines to a legend

The last step in customizing a legend is adding different types of symbols to
the plot. In the example above, we just added lines. But what if we wanted to add
some POINTS too? We will do that next.

In the data below, we've create a custom legend where each symbol type and color
is defined using a vector. We have 3 levels: grass, soil and trees. Thus we
need to define 3 symbols and 3 colors for our legend and our plot.

`pch=c(8,18,8)`

`plot_colors <- c("chartreuse4", "burlywood4", "darkgreen")`

## note that because we are importing points, we have to do things a bit differently
We won't use tidy - istead we will simply coerce (convert) to a a data frame with xy values.


```r
# import points layer
sjer_plots <- readOGR("data/week5/california/SJER/vector_data",
                      "SJER_plot_centroids")
# given we want to plot 2 layers together, let's check the crs before going any further
crs(sjer_plots)
crs(sjer_roads)

# reproject to lat / long
sjer_plots <- spTransform(sjer_plots, crs(sjer_roads))

# convert data to data frame to plot in ggplot
# convert spatial object to a ggplot ready data frame
sjer_plots_df <- as.data.frame(sjer_plots, region = "id")
```

Next - let's plot the data with ggplot.


```r

ggplot() +
  geom_point(data = sjer_plots_df, aes(x = coords.x1, y = coords.x2)) +
  labs(title = "Plot locations")
```

<img src="{{ site.url }}/images/rfigs/course-materials/earth-analytics/week04/review-materials/2017-02-15-plot02-custom-mapsggplot-R/ggplot-points-1.png" title="ggplot with points" alt="ggplot with points" width="100%" />

## Layering data in ggplot

We can layer multiple ggplot objects


```r
# plot lines and points together
ggplot() +
  geom_line(data = sjer_roads_df, aes(x = long,
                                      y = lat, group = group),
            color = "grey") +
  geom_point(data = sjer_plots_df, aes(x = coords.x1, y = coords.x2))
```

<img src="{{ site.url }}/images/rfigs/course-materials/earth-analytics/week04/review-materials/2017-02-15-plot02-custom-mapsggplot-R/combine-layers-1.png" title="Plot of both points and lines with ggplot" alt="Plot of both points and lines with ggplot" width="100%" />


Next we have a few options - our roads layer is a much larger spatial extent
compared to our plots layer. We could zoom in on our map using `coord_fixed()`


```r
# plot with ggplot adjusting the extent with coord_fixed()
ggplot() +
  geom_path(data = sjer_roads_df, aes(x = long,
                                      y = lat, group = group),
            color = "grey") +
  geom_point(data = sjer_plots_df, aes(x = coords.x1, y = coords.x2)) +
  coord_fixed(xlim = c(-119.8, -119.7), ylim = c(37.05, 37.15))
```

<img src="{{ site.url }}/images/rfigs/course-materials/earth-analytics/week04/review-materials/2017-02-15-plot02-custom-mapsggplot-R/combine-layers-custom-ext-1.png" title="Plot of both points and lines with ggplot with custom extent" alt="Plot of both points and lines with ggplot with custom extent" width="100%" />


## Data crop vs map zoom 

A better approach is to crop our data to a study region. That way we aren't
retaining information that we done need which will make plotting faster.

Let's walk through the steps that we did above, this time cropping and cleaning up
our data as we go.


```r
study_area <- readOGR("data/week5/california/SJER/vector_data/SJER_crop.shp")
## OGR data source with driver: ESRI Shapefile 
## Source: "data/week5/california/SJER/vector_data/SJER_crop.shp", layer: "SJER_crop"
## with 1 features
## It has 1 fields
sjer_plots <- readOGR("data/week5/california/SJER/vector_data/SJER_plot_centroids.shp")
## OGR data source with driver: ESRI Shapefile 
## Source: "data/week5/california/SJER/vector_data/SJER_plot_centroids.shp", layer: "SJER_plot_centroids"
## with 18 features
## It has 5 fields
sjer_roads <- readOGR("data/week5/california/madera-county-roads/tl_2013_06039_roads.shp")
## OGR data source with driver: ESRI Shapefile 
## Source: "data/week5/california/madera-county-roads/tl_2013_06039_roads.shp", layer: "tl_2013_06039_roads"
## with 9640 features
## It has 4 fields
# view crs of all layers
crs(study_area)
## CRS arguments:
##  +proj=utm +zone=11 +datum=WGS84 +units=m +no_defs +ellps=WGS84
## +towgs84=0,0,0
crs(sjer_plots)
## CRS arguments:
##  +proj=utm +zone=11 +datum=WGS84 +units=m +no_defs +ellps=WGS84
## +towgs84=0,0,0
crs(sjer_roads)
## CRS arguments:
##  +proj=longlat +datum=NAD83 +no_defs +ellps=GRS80 +towgs84=0,0,0

# reproject the roads to utm
sjer_roads_utm <- spTransform(sjer_roads, CRS = crs(study_area))
sjer_roads_utm$RTTYP[is.na(sjer_roads_utm$RTTYP)] <- "Unknown"
unique(sjer_roads_utm$RTTYP)
## [1] "M"       "Unknown" "S"       "C"
# crop the roads to our study area

sjer_roads_utmcrop <- crop(sjer_roads_utm, study_area)
# quick plot to make sure the data look like we expect them too post crop
plot(sjer_roads_utmcrop)
```

<img src="{{ site.url }}/images/rfigs/course-materials/earth-analytics/week04/review-materials/2017-02-15-plot02-custom-mapsggplot-R/import-clean-data-1.png" title="quick plot of cropped roads" alt="quick plot of cropped roads" width="100%" />

```r

# view crs of all layers
crs(study_area)
## CRS arguments:
##  +proj=utm +zone=11 +datum=WGS84 +units=m +no_defs +ellps=WGS84
## +towgs84=0,0,0
crs(sjer_plots)
## CRS arguments:
##  +proj=utm +zone=11 +datum=WGS84 +units=m +no_defs +ellps=WGS84
## +towgs84=0,0,0
crs(sjer_roads_utmcrop)
## CRS arguments:
##  +proj=utm +zone=11 +datum=WGS84 +units=m +no_defs +ellps=WGS84
## +towgs84=0,0,0
```

Convert the study_area object to a data frame for ggplot.
IN this case we only have one extent boundary for the study area - so we won't
need to add the attributes.


```r
# turn study area data into data frame
study_area$id <- rownames(study_area@data)
study_area_df <- tidy(study_area, region = "id")

# be sure your dataframe has an id column

# convert roads layer (utm projection) to data frame

# convert spatial object to a ggplot ready data frame
sjer_roads_df <- tidy(sjer_roads_utmcrop, region = "id")
# make sure the shapefile attribute table has an id column
sjer_roads_utmcrop$id <- rownames(sjer_roads_utmcrop@data)
# join the attribute table from the spatial object to the new data frame
sjer_roads_df <- left_join(sjer_roads_df,
                           sjer_roads_utmcrop@data,
                           by = "id")


# convert spatial object to a ggplot ready data frame
sjer_plots_df <- as.data.frame(sjer_plots, region = "id")
```

Now that we have all of our layers converted and cleaned up we can plot them.

Weird stuff is happening with the legend and colors and stuff...

```r
# need to figure out how to plot with a black border and no fill
ggplot() +
  geom_polygon(data = study_area_df, aes(x = long, y = lat, group = group),
               fill = "white", color = "black") +
  geom_path(data = sjer_roads_df, aes(x = long, y = lat,
                                      group = group, colour = RTTYP)) +
  geom_point(data = sjer_plots_df, aes(x = coords.x1,
                                       y = coords.x2, colour = 'school')) +
  #scale_colour_manual(values = c("purple", "green", "blue", "yellow", "magenta"),
   #                    guide = guide_legend(override.aes = list(
    #                     linetype = c(rep("blank", 4), "solid", "dashed"),
     #                    shape = c(rep(1, 7), NA, NA))))
  # sguide_legend(override.aes = list(shape = 22))

# guide_legend(override.aes = list(shape = 22, size = 5))) something like this to make it plot correctly
## Error: <text>:16:0: unexpected end of input
## 14: 
## 15: # guide_legend(override.aes = list(shape = 22, size = 5))) something like this to make it plot correctly
##    ^
```




```r
sjer_plots$plot_type <- as.factor(sjer_plots$plot_type)
levels(sjer_plots$plot_type)
## [1] "grass" "soil"  "trees"
# grass, soil trees
plot_colors <- c("chartreuse4", "burlywood4", "darkgreen")



# size adjusts the line widht
ggplot() +
  geom_path(data = sjer_roads_df, aes(x = long, y = lat,
                                      group = group, color = factor(RTTYP)), size = 1.1) +
  geom_point()
```

<img src="{{ site.url }}/images/rfigs/course-materials/earth-analytics/week04/review-materials/2017-02-15-plot02-custom-mapsggplot-R/legend-points-lines-1.png" title="plot legend with points and lines" alt="plot legend with points and lines" width="100%" />

```r


+
      scale_colour_manual(values = road_palette) +
  labs(title = "Madera County Roads ",
       subtitle = "With big fat lines!",
       color = "Road type",
       x = "", y = "") +
  theme(axis.text = element_blank(), axis.ticks = element_blank()) +
  coord_fixed()
## Error in +scale_colour_manual(values = road_palette): invalid argument to unary operator

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
```

<img src="{{ site.url }}/images/rfigs/course-materials/earth-analytics/week04/review-materials/2017-02-15-plot02-custom-mapsggplot-R/legend-points-lines-2.png" title="plot legend with points and lines" alt="plot legend with points and lines" width="100%" />

Next, let's try to plot our roads on top of the plot locations. Then let's create
a custom legend that contains both lines and points. NOTE: in this example i've
fixed the projection for the roads layer and cropped it! You will have to do the same before
this code will work.



When we create a legend, we will have to add the labels for both the points
layer and the lines layer.

`c(levels(sjer_plots$plot_type), levels(sjer_roads$RTTYP))`


```r
# view all elements in legend
c(levels(sjer_plots$plot_type), levels(sjer_roads$RTTYP))
## [1] "grass" "soil"  "trees"
```



```r

# plot using new colors
plot(sjer_plots,
     col=(plot_colors)[sjer_plots$plot_type],
     pch=8,
     main="Madera County Roads and plot locations")

# plot using new colors
plot(sjer_roads_utm,
     col=(challengeColors)[sjer_plots$plot_type],
     pch=8,
     add=T)

# add a legend to our map
legend("bottomright",
       legend = c(levels(sjer_plots$plot_type), levels(sjer_roads$RTTYP)),
       pch=c(8,18,8),  # set the WIDTH of each legend line
       col=plot_colors, # set the color of each legend line
       bty="n", # turn off border
       cex=.9) # adjust legend font size
```

<img src="{{ site.url }}/images/rfigs/course-materials/earth-analytics/week04/review-materials/2017-02-15-plot02-custom-mapsggplot-R/custom-legend-points-lines-1.png" title="final plot custom legend." alt="final plot custom legend." width="100%" />


Next we have to tell `R`, which symbols are lines and which are point symbols. We
can do that using the lty argument. We have 3 unique point symbols and 4 unique
line symbols. We can include a NA for each element that should not be a line in
the lty argument:

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

# plot using new colors
plot(sjer_roads_utm,
     col=(challengeColors)[sjer_plots$plot_type],
     pch=8,
     add=T)

# add a legend to our map
legend("bottomright",
       legend = c(levels(sjer_plots$plot_type), levels(sjer_roads$RTTYP)),
       pch=c(8,18,8, NA, NA, NA, NA),  # set the symbol for each point
       lty=c(NA,NA, NA, 1, 1, 1, 1),
       col=c(plot_colors, challengeColors), # set the color of each legend line
       bty="n", # turn off border
       cex=.9) # adjust legend font size
```

<img src="{{ site.url }}/images/rfigs/course-materials/earth-analytics/week04/review-materials/2017-02-15-plot02-custom-mapsggplot-R/custom-legend-points-lines-2-1.png" title="Plot with points and lines customized." alt="Plot with points and lines customized." width="100%" />


## Force the legend to plot next to your plot

Refining the look of your plots takes a bit of patience in R, but it can be
done! Play with the code below to see if you can make your legend plot NEXT TO
rather than on top of your plot.

The steps are:

1. Place your legend on the OUTSIDE of the plot extent by grabbing the `xmax` and `ymax` values from one of the objects that you are plotting's `extent()`. This allows you to be precise in your legend placement.
2. Set the `xpd=T` argument in your legend to enforce plotting outside of the plot extent and
3. OPTIONAL:  adjust the plot **PAR**ameters using `par()`. You can set the **mar**gin
of your plot using `mar=`. This provides extra space on the right (if you'd like your legend to plot on the right) for your legend and avoids things being "chopped off". Provide the `mar=` argument in the
format: `c(bottom, left, top, right)`. The code below is telling r to add 7 units
of padding on the RIGHT hand side of our plot. The default units are INCHES.

**IMPORTANT:** be cautious with margins. Sometimes they can cause problems when you
knit - particularly if they are too large.

Let's give this a try. First, we grab the northwest corner location x and y. We
will use this to place our legend.


```r
# figure out where the upper RIGHT hand corner of our plot extent is
the_plot_extent <- extent(sjer_aoi)

# grab the upper right hand corner coordinates
furthest_pt_east <- the_plot_extent@xmax
furthest_pt_north <- the_plot_extent@ymax
# view values
furthest_pt_east
## [1] 258867.4
furthest_pt_north
## [1] 4112362

# plot using new colors
plot(sjer_plots,
     col=(plot_colors)[sjer_plots$plot_type],
     pch=8,
     main="Madera County Roads and plot locations")

# plot using new colors
plot(sjer_roads_utm,
     col=(challengeColors)[sjer_plots$plot_type],
     pch=8,
     add=T)

# add a legend to our map
legend(x=furthest_pt_east, y=furthest_pt_north,
       legend = c(levels(sjer_plots$plot_type), levels(sjer_roads$RTTYP)),
       pch=c(8, 18, 8, NA, NA, NA, NA),  # set the symbol for each point
       lty=c(NA, NA, NA, 1, 1, 1, 1) ,
       col=c(plot_colors, challengeColors), # set the color of each legend line
       bty="n", # turn off border
       cex=.9, # adjust legend font size
       xpd=T) # force the legend to plot outside of your extent
```

<img src="{{ site.url }}/images/rfigs/course-materials/earth-analytics/week04/review-materials/2017-02-15-plot02-custom-mapsggplot-R/adjust-legend-1.png" title="plot with fixed legend" alt="plot with fixed legend" width="100%" />



Let's use the margin parameter to clean things up. Also notice i'm using the
AOI extent layer to create a "box" around my plot. Now things are starting to
look much cleaner!

I've also added some "fake" legend elements to create subheadings like we
might add to a map legend in QGIS or ArcGIS.

`legend = c("Plots", levels(sjer_plots$plot_type), "Road Types", levels(sjer_roads$RTTYP))`


```r
# adjust margin to make room for the legend
par(mar=c(2, 2, 4, 7))
# plot using new colors
plot(sjer_aoi,
     border="grey",
     lwd=2,
     main="Madera County Roads and plot locations")
plot(sjer_plots,
     col=(plot_colors)[sjer_plots$plot_type],
     add=T,
     pch=8)
# plot using new colors
plot(sjer_roads_utm,
     col=(challengeColors)[sjer_plots$plot_type],
     pch=8,
     add=T)

# add a legend to our map
legend(x=(furthest_pt_east+50), y=(furthest_pt_north-15),
       legend = c("Plots", levels(sjer_plots$plot_type), "Road Types", levels(sjer_roads$RTTYP)),
       pch=c(NA, 8, 18, 8, NA, NA, NA, NA, NA),  # set the symbol for each point
       lty=c(NA,NA,NA, NA, NA, 1, 1, 1, 1),
       col=c(plot_colors, challengeColors), # set the color of each legend line
       bty="n", # turn off border
       cex=.9, # adjust legend font size
       xpd=T)
```

<img src="{{ site.url }}/images/rfigs/course-materials/earth-analytics/week04/review-materials/2017-02-15-plot02-custom-mapsggplot-R/custom-legend-points-lines-22-1.png" title="final legend with points and lines customized 2ß." alt="final legend with points and lines customized 2ß." width="100%" />



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
plot(sjer_plots,
     col=(plot_colors)[sjer_plots$plot_type],
     add=T,
     pch=8)
# plot using new colors
plot(sjer_roads_utm,
     col=(challengeColors)[sjer_plots$plot_type],
     pch=8,
     add=T)

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
```

<img src="{{ site.url }}/images/rfigs/course-materials/earth-analytics/week04/review-materials/2017-02-15-plot02-custom-mapsggplot-R/custom-legend-points-lines-3-1.png" title="final legend with points and lines customized 2ß." alt="final legend with points and lines customized 2ß." width="100%" />



Now, if you want to move the legend out a bit further, what would you do?

## BONUS!

Any idea how I added a space to the legend below to create "sections"?

<img src="{{ site.url }}/images/rfigs/course-materials/earth-analytics/week04/review-materials/2017-02-15-plot02-custom-mapsggplot-R/custom-legend-points-lines-4-1.png" title="final legend with points and lines customized." alt="final legend with points and lines customized." width="100%" />


```r
# important: once you are done, reset par which resets plot margins
# otherwise margins will carry over to your next plot and cause problems!
dev.off()
```
