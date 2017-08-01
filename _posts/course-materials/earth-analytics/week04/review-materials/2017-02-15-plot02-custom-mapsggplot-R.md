---
layout: single
title: "Create custom maps with ggplot in R - GIS in R"
excerpt: "In this lesson we break down the steps to create a map in R using ggplot."
authors: ['Leah Wasser']
modified: '2017-08-01'
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

* Create a map in `R` using `ggplot()`.
* Plot a vector dataset by attributes in `R` using `ggplot()`.

## <i class="fa fa-check-square-o fa-2" aria-hidden="true"></i> What you need

You will need a computer with internet access to complete this lesson and the data for week 5 of the course.

[<i class="fa fa-download" aria-hidden="true"></i> Download week 5 Data (~500 MB)](https://ndownloader.figshare.com/files/7525363){:data-proofer-ignore='' .btn }

</div>

## Making maps with GGPLOT

In the previous lesson, we used base plot() to create a map of vector data -
our roads data - in `R`. In this lesson we will create the same maps, however
instead we will use `ggplot()`. ggplot is a powerful tool for making custom maps.
Compared to base plot, you will find creating custom legends to be simpler and cleaner,
and creating nicely formatted themed maps to be simpler as well.

However, we will have to convert our data from spatial (`sp`) objects to data.frames
to use ggplot. The process isn't bad once you have the steps down! Let's check
it out.


<i class="fa fa-star"></i> **Data Tip:** If our data attribute values are not
read in as factors, we can convert the categorical
attribute values using `as.factor()`.
{: .notice--success}



First, let's import all of the needed libraries.


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
```

View attributes of and plot the data.


```r
# view the original class of the TYPE column
class(sjer_roads$RTTYP)
## [1] "character"
unique(sjer_roads$RTTYP)
## [1] "M" NA  "S" "C"
# quick plot using base plot
plot(sjer_roads,
     main = "Quick plot of roads data")
```

<img src="{{ site.url }}/images/rfigs/course-materials/earth-analytics/week04/review-materials/2017-02-15-plot02-custom-mapsggplot-R/convert-to-factor-1.png" title="Quick plot of the roads data." alt="Quick plot of the roads data." width="100%" />




It looks like we have some missing values in our road types. We want to plot all
road types even those that are NA. Let's change the roads with an `RTTYP` attribute of
NA to "unknown".


```r
# set all NA values to "unknown" so they still plot
sjer_roads$RTTYP[is.na(sjer_roads$RTTYP)] <- "Unknown"
unique(sjer_roads$RTTYP)
## [1] "M"       "Unknown" "S"       "C"
```

## Convert spatial data to a data.frame

When we're plotting with base `plot()`, we can plot spatial `sp` or `raster` objects directly
without converting them. However `ggplot()` requires a `data.frame`. Thus we will
need to convert our data. We can convert he data using the `tidy()` function from
the broom package in `R`.

<i class="fa fa-star"></i> **Data Tip:** the tidy function used to be the fortify
function! The code for the `tidy()` function is exactly the same as the `fortify()` code.
{: .notice--success}

Below we convert the data by:

1. Calling the `tidy()` function on our `sjer_roads` spatial object
1. Adding an id field to the spatial object data frame which represents each unique feature  (each road line) in the data
1. Joining the table from the spatial object to the data.frame output of the `tidy()` function

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

1. The x and y values are long and lat. These are columns that the `tidy()` function generates from a spatial object.
1. The group function allows `R` to figure out what vertices below to which feature. So in this case we are plotting lines - each of which consist of 2 or more vertices that are connected.


```r
# plot the lines data, apply a diff color to each factor level)
ggplot() +
  geom_path(data = sjer_roads_df, aes(x = long, y = lat, group = group)) +
  labs(title = "ggplot map of roads")
```

<img src="{{ site.url }}/images/rfigs/course-materials/earth-analytics/week04/review-materials/2017-02-15-plot02-custom-mapsggplot-R/plot-roads-data-1.png" title="Basic ggplot of roads." alt="Basic ggplot of roads." width="100%" />

We can color each line by type too by adding the attribute that we wish to use
for categories or types to the color  = argument.

Below we set the colors to `color = factor(RTTYP)`. Note that we are coercing the
attribute `RTTYP` to a factor. You can think of this as temporarily grouping the
data by the `RTTYP` category for plotting purposes only. We aren't modifying the
data we are just telling ggplot that the data are categorical with explicit groups.


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

1. We figure out how many unique road types we have
1. We specify the colors that we want to apply to each road type
1. Finally we plot the data - we will use the `scale_colour_manual(values = c("rdType1" = "color1", "rdType2" = "color2", "rdType3" = "color3", "rdType4" = "color4"))` to specify what colors we want to use for what attribute value.

Let's plot our roads data by the `RTTYP` attribute and apply unique colors.


```r
# count the number of unique values or levels
length(levels(sjer_roads$RTTYP))
## [1] 0

# create a color palette of 4 colors - one for each factor level
road_palette <- c("C" = "green", 
                  "M" = "grey40", 
                  "S" = "purple", 
                  "Unknown" = "grey")
road_palette
##        C        M        S  Unknown 
##  "green" "grey40" "purple"   "grey"

# plot with custom colors
# size adjusts the line width
ggplot() +
  geom_path(data = sjer_roads_df, aes(x = long, y = lat,
                                      group = group, color=factor(RTTYP))) +
      scale_colour_manual(values = road_palette) +
  labs(title = "Madera County Roads ",
       subtitle = "Colored by road type")
```

<img src="{{ site.url }}/images/rfigs/course-materials/earth-analytics/week04/review-materials/2017-02-15-plot02-custom-mapsggplot-R/palette-and-plot-1.png" title="Adjust colors on map by creating a palette." alt="Adjust colors on map by creating a palette." width="100%" />

Notice that above the colors are applied to each category (C, M, S and Unknown) in order.
In this case the order is alphabetical.

### Remove ggplot axis ticks

Finally we can remove the axis ticks and labels using a `theme()` element.
Themes are used in `ggplot()` to customize the look of a plot. You can customize
any element of the plot including fonts, colors and more!

Below we do the following:

1. We remove the x and y axis ticks and label using the theme argument
1. We remove the x and y labels using the `x =` and `y =` arguments in the `labs()` function
3. We customize the legend title using labs(`color =`)

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

Finally we can use `coord_fixed()` to scale the x and y axis equally by long and
lat values.


```r
# size adjusts the line width
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

<!--
# r for spatial analysis --
# https://us.sagepub.com/en-us/nam/an-introduction-to-r-for-spatial-analysis-and-mapping/book241031
-->

### Adjust Line Width

We can adjust the width of the lines on our plot using `size =`. If we use `size = 4`
with a numeric value (e.g. 4) then we set all of line features in our data to the
same size.


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
in our spatial object, we can use a similar syntax to the one we used for colors.
Here we use `scale_size_manual()` to set the line width for each category in the
`RTTYP` attribute. Similar to the colors set above, `ggplot()` will apply the line
width in the order of the factor levels in the data. This is by default alphabetical.

`scale_size_manual(values = c(.5, 1, 1, .5))`

However it's better to be explicit and set which attribute value should be 
associated with each line width. Like this:

`scale_size_manual(values = c("C" = .5, "M" = 1, "S" = 1, "Unknown" = .5))`


Note that similar to colors, we have adjusted the lines using two steps

1. We've set the size to `factor(RTTYP)` a
2. We've assigned the size using the `size_scale_manual()` function

Let's see how it looks.


```r
# size adjusts the line width
# still not working as expected - why does it plot 2 legends
# using size for a discrete variable is not advised error -- need to figure this out?
ggplot() +
  geom_path(data = sjer_roads_df, aes(x = long, y = lat,
                                      group = group,
                                      colour = factor(RTTYP),
                                      size = factor(RTTYP))) +
  scale_size_manual(values = c("C" = .5, "M" = 1, "S" = 1, "Unknown" = .5)) +
      scale_colour_manual(values = road_palette) +
  labs(title = "Madera County Roads ",
       subtitle = "With big fat lines!",
       color = "Road type",
       x = "", y = "") +
  theme(axis.text = element_blank(), axis.ticks = element_blank()) +
  coord_fixed()
```

<img src="{{ site.url }}/images/rfigs/course-materials/earth-analytics/week04/review-materials/2017-02-15-plot02-custom-mapsggplot-R/roads-line-width2-1.png" title="Roads ggplot map with line width set." alt="Roads ggplot map with line width set." width="100%" />

### Merge the legends

The map above looks ok but we have multiple legends when we really just want one
legend for both color and size. We can merge the legend using the `guides()` function.
Here we specify each legend element that we wish to merge together as follows:

`guides(colour = guide_legend("Legend title here"), size = guide_legend("Same legend title here"))`



```r
# size adjusts the line width
# still not working as expected - why does it plot 2 legends
# using size for a discrete variable is not advised error -- need to figure this out?
ggplot() +
  geom_path(data = sjer_roads_df, aes(x = long, y = lat,
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

But this is ugly, right? Let's make the line widths a bit thinner to clean
things up.


```r
# size adjusts the line width
# still not working as expected - why does it plot 2 legends
# using size for a discrete variable is not advised error -- need to figure this out?
ggplot() +
  geom_path(data = sjer_roads_df, aes(x = long, y = lat,
                                      group = group,
                                      colour = factor(RTTYP),
                                      size = factor(RTTYP))) +
  scale_size_manual(values = c(.3, .6, .6, .3)) +
      scale_colour_manual(values = road_palette) +
  guides(colour = guide_legend("Road Type"), size = guide_legend("Road Type")) +
  labs(title = "Madera County Roads ",
       subtitle = "With thinner lines (by attribute)!",
       color = "Road type",
       x = "", y = "") +
  theme(axis.text = element_blank(), axis.ticks = element_blank()) +
  coord_fixed()
```

<img src="{{ site.url }}/images/rfigs/course-materials/earth-analytics/week04/review-materials/2017-02-15-plot02-custom-mapsggplot-R/roads-line-width-custom2-1.png" title="Roads ggplot map with line width set. Thinner lines." alt="Roads ggplot map with line width set. Thinner lines." width="100%" />

<div class="notice--warning" markdown="1">

## <i class="fa fa-pencil-square-o" aria-hidden="true"></i> Optional challenge: Plot line width by attribute

Create your own custom map of roads. Adjust the line width and the colors
of the roads to make a map that emphasizes roads of value S (thicker lines) and that de-emphasizes
roads with an RTTYP attribute value of unknown (thinner lines, lighter color).

</div>


<img src="{{ site.url }}/images/rfigs/course-materials/earth-analytics/week04/review-materials/2017-02-15-plot02-custom-mapsggplot-R/road-map-2-1.png" title="emphasize some attributes" alt="emphasize some attributes" width="100%" />


<!-- C = County
I = Interstate
M = Common Name
O = Other
S = State recognized
U = U.S.-->

## Adding points and lines to a legend

Next, let's add points to our map and and of course the map legend too. 
We will import the shapefile `data/week5/california/SJER/vector_data/sjer_plot_centroids.shp` layer. This 
data represents study plot locations from our field work in southern 
California. 

Let's import that data and perform any cleanup that is required. 



```r
# import points layer
sjer_plots <- readOGR("data/week5/california/SJER/vector_data",
                      "SJER_plot_centroids")
# given we want to plot 2 layers together, let's check the crs before going any further
crs(sjer_plots)
crs(sjer_roads)

# reproject to lat / long
sjer_plots <- spTransform(sjer_plots, crs(sjer_roads))
```

Next we can `tidy()` up the data as we did before... or can we?


```r
sjer_plots_df <- tidy(sjer_plots, region = "id")
```

Note that this time we imported point data. We can't use the tidy function 
on points data. Instead, we simply convert it to a data.frame using the function
`as.data.frame`.



```r
# convert spatial object to a ggplot ready data frame
sjer_plots_df <- as.data.frame(sjer_plots, region = "id")
```

Next, let's plot the data using ggplot.



```r
# plot point data using ggplot
ggplot() +
  geom_point(data = sjer_plots_df, aes(x = coords.x1, y = coords.x2)) +
  labs(title = "Plot locations")
```

<img src="{{ site.url }}/images/rfigs/course-materials/earth-analytics/week04/review-materials/2017-02-15-plot02-custom-mapsggplot-R/ggplot-points-1.png" title="ggplot with points" alt="ggplot with points" width="100%" />

Great! We've now plotted our data using ggplot. Let's next combine the roads 
with the points in one clean map.

## Layering data in ggplot

We can layer multiple ggplot objects by adding a new `geom_` function to our plot.
For the roads data, we used `geom_path()` and for points we use `geom_point()`.
Note that we add an addition data layer to our ggplot map using the `+` sign. 


```r
# plot lines and points together
ggplot() +
  geom_path(data = sjer_roads_df, aes(x = long,
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
# import all layers
study_area <- readOGR("data/week5/california/SJER/vector_data/SJER_crop.shp")
sjer_plots <- readOGR("data/week5/california/SJER/vector_data/SJER_plot_centroids.shp")
sjer_roads <- readOGR("data/week5/california/madera-county-roads/tl_2013_06039_roads.shp")
```

Then explore the data to determine whether we need to clean the data up. 


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

<img src="{{ site.url }}/images/rfigs/course-materials/earth-analytics/week04/review-materials/2017-02-15-plot02-custom-mapsggplot-R/clean-data-1.png" title="quick plot of the data" alt="quick plot of the data" width="100%" />

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
In this case we only have one extent boundary for the study area - so we won't
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
Notice that plotting is much faster when we crop the data to only the study location
that we are interested in.

Weird stuff is happening with the legend and colors and stuff...

```r
# need to figure out how to plot with a black border and no fill
ggplot() +
  geom_polygon(data = study_area_df, aes(x = long, y = lat, group = group),
               fill = "white", color = "black") +
  geom_path(data = sjer_roads_df, aes(x = long, y = lat,
                                      group = group, colour = factor(RTTYP))) +
  geom_point(data = sjer_plots_df, aes(x = coords.x1,
                                       y = coords.x2, colour = 'school')) +
  guides(color = guide_legend(override.aes = list(shape = c(NA, NA, NA, 16), linetype = c(1,1,1,0))))
```

<img src="{{ site.url }}/images/rfigs/course-materials/earth-analytics/week04/review-materials/2017-02-15-plot02-custom-mapsggplot-R/combine-all-layers-1.png" title=" " alt=" " width="100%" />

```r
#+
#  guides(colour = guide_legend("Road Type"), size = guide_legend("Road Type"))

  #scale_colour_manual(values = c("purple", "green", "blue", "yellow", "magenta"),
   #                    guide = guide_legend(override.aes = list(
    #                     linetype = c(rep("blank", 4), "solid", "dashed"),
     #                    shape = c(rep(1, 7), NA, NA))))
  # sguide_legend(override.aes = list(shape = 22))

# guide_legend(override.aes = list(shape = 22, size = 5))) something like this to make it plot correctly
```




```r

# https://stackoverflow.com/questions/39185291/legends-for-multiple-fills-in-ggplot/39185552

ggplot() +
  geom_polygon(data = study_area_df, aes(x = long, y = lat, group = group),
               fill = "white", color = "black") +
  geom_path(data = sjer_roads_df, aes(x = long, y = lat,
                                      group = group, colour = factor(RTTYP), size = factor(RTTYP))) +
  scale_linetype_manual("Road Type", c("M" = 2, 3, 4)) +
  scale_size_manual("Road Type", values = c("M" = .5,
                                            "S" = 2,
                                            "Unknown" = .5)) +
  geom_point(data = sjer_plots_df, aes(x = coords.x1,
                                       y = coords.x2, shape = factor(plot_type)), size = 3) +

  scale_colour_manual("Road Type", values = c("M" = "grey",
                                "Unknown" = "grey",
                                 "S" = "magenta")) +
  scale_fill_manual("Plot Type", values = c("trees" = "springgreen",
                                 "grass" = "green",
                                 "soil" = "brown")) +
  scale_shape_manual("Plot Type", values = c("grass" = 21,
                                             "soil" = 12,
                                             "trees" = 18)) +
  scalebar(lon = -130, lat = 26, distanceLon = 500, distanceLat = 100, distanceLegend = 200, dist.unit = "km", orientation = FALSE)
## Error in plot.xy(xy.coords(x, y), type = type, ...): plot.new has not been called yet

#+
#  guides(color = guide_legend("Road Type", override.aes = list(shape = c(NA, NA, NA, 16, 16, 16), "sdf", linetype = c(1,1,1,0,0,0))))

## scale bars and legend
# http://oswaldosantos.github.io/ggsn/
```




```r
# get rid of this
sjer_plots$plot_type <- as.factor(sjer_plots$plot_type)
levels(sjer_plots$plot_type)
## [1] "grass" "soil"  "trees"
# grass, soil trees
plot_colors <- c("chartreuse4", "burlywood4", "darkgreen")
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






from the 
In the data below, we've create a custom legend where each symbol type and color
is defined using a vector. We have 3 levels: grass, soil and trees. Thus we
need to define 3 symbols and 3 colors for our legend and our plot.

`pch=c(8,18,8)`

`plot_colors <- c("chartreuse4", "burlywood4", "darkgreen")`

## note that because we are importing points, we have to do things a bit differently
We won't use tidy - istead we will simply coerce (convert) to a a data frame with xy values.

Next - let's plot the data with ggplot.
