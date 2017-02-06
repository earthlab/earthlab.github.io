---
layout: single
title: "GIS in R: custom legends"
excerpt: "."
authors: ['Leah Wasser']
modified: '2017-02-06'
category: [course-materials]
class-lesson: ['hw-custom-legend-r']
permalink: /course-materials/earth-analytics/week-4/r-custom-legend/
nav-title: 'Create custom legend structure'
module-title: 'Custom plots in R'
module-description: 'This tutorial covers the basics of creating custom plot legends
in R'
module-nav-title: 'Spatial Data: Custom plots in R'
module-type: 'homework'
week: 4
sidebar:
  nav:
author_profile: false
comments: true
order: 1
---

{% include toc title="In This Lesson" icon="file-text" %}

<div class='notice--success' markdown="1">

## <i class="fa fa-graduation-cap" aria-hidden="true"></i> Learning Objectives

After completing this tutorial, you will be able to:

* Add a custom legend to a map in R.
* Plot a vector dataset by attributes in R.

## <i class="fa fa-check-square-o fa-2" aria-hidden="true"></i> What you need

You will need a computer with internet access to complete this lesson.

If you have not already downloaded the week 3 data, please do so now.
[<i class="fa fa-download" aria-hidden="true"></i> Download Week 3 Data (~250 MB)](https://ndownloader.figshare.com/files/7446715){:data-proofer-ignore='' .btn }

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
{: .notice}



```r
# load libraries
library(raster)
library(rgdal)
```


```r
# import roads
sjer_roads <- readOGR("data/week4/california/madera-county-roads",
                      "tl_2013_06039_roads")
## OGR data source with driver: ESRI Shapefile 
## Source: "data/week4/california/madera-county-roads", layer: "tl_2013_06039_roads"
## with 9640 features
## It has 4 fields
# view the original class of the TYPE column
class(sjer_roads$RTTYP)
## [1] "character"
unique(sjer_roads$RTTYP)
## [1] "M" NA  "S" "C"

# set all NA values to "unknown" so they still plot
sjer_roads$RTTYP[is.na(sjer_roads$RTTYP)] <- "unknown"
unique(sjer_roads$RTTYP)
## [1] "M"       "unknown" "S"       "C"

# view levels or categories - note that there are no categories yet in our data!
# the attributes are just read as a list of character elements.
levels(sjer_roads$RTTYP)
## NULL

# Convert the TYPE attribute into a factor
# Only do this IF the data do not import as a factor!
sjer_roads$RTTYP <- as.factor(sjer_roads$RTTYP)
class(sjer_roads$RTTYP)
## [1] "factor"
levels(sjer_roads$RTTYP)
## [1] "C"       "M"       "S"       "unknown"

# how many features are in each category or level?
summary(sjer_roads$RTTYP)
##       C       M       S unknown 
##      10    4456      25    5149
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
## [1] 4

# create a color palette of 4 colors - one for each factor level
roadPalette <- c("blue", "green", "grey", "purple")
roadPalette
## [1] "blue"   "green"  "grey"   "purple"
# create a vector of colors - one for each feature in our vector object
# according to its attribute value
roadColors <- c("blue", "green", "grey", "purple")[sjer_roads$RTTYP]
roadColors
##    [1] "green"  "green"  "green"  "green"  "green"  "green"  "green" 
##    [8] "green"  "green"  "green"  "green"  "green"  "green"  "green" 
##   [15] "green"  "green"  "green"  "green"  "green"  "green"  "green" 
##   [22] "green"  "green"  "green"  "green"  "green"  "green"  "green" 
##   [29] "green"  "green"  "green"  "green"  "green"  "green"  "green" 
##   [36] "green"  "green"  "green"  "green"  "green"  "green"  "green" 
##   [43] "green"  "green"  "green"  "green"  "green"  "green"  "green" 
##   [50] "green"  "green"  "green"  "green"  "green"  "green"  "green" 
##   [57] "green"  "green"  "green"  "green"  "green"  "green"  "green" 
##   [64] "green"  "green"  "green"  "green"  "green"  "green"  "green" 
##   [71] "green"  "green"  "green"  "green"  "green"  "green"  "green" 
##   [78] "green"  "green"  "green"  "green"  "green"  "green"  "green" 
##   [85] "green"  "green"  "green"  "green"  "green"  "green"  "green" 
##   [92] "green"  "green"  "green"  "green"  "green"  "green"  "green" 
##   [99] "green"  "green"  "green"  "green"  "green"  "green"  "green" 
##  [106] "green"  "green"  "green"  "green"  "green"  "green"  "green" 
##  [113] "green"  "green"  "green"  "green"  "green"  "green"  "green" 
##  [120] "green"  "green"  "green"  "green"  "green"  "green"  "green" 
##  [127] "green"  "green"  "green"  "green"  "green"  "green"  "green" 
##  [134] "green"  "green"  "green"  "green"  "green"  "green"  "green" 
##  [141] "green"  "green"  "green"  "green"  "green"  "green"  "green" 
##  [148] "green"  "green"  "green"  "green"  "green"  "green"  "green" 
##  [155] "green"  "green"  "green"  "green"  "green"  "green"  "green" 
##  [162] "green"  "green"  "green"  "green"  "green"  "green"  "green" 
##  [169] "green"  "green"  "green"  "green"  "green"  "green"  "green" 
##  [176] "green"  "green"  "green"  "green"  "green"  "green"  "green" 
##  [183] "green"  "green"  "green"  "green"  "green"  "green"  "green" 
##  [190] "green"  "green"  "green"  "green"  "green"  "green"  "green" 
##  [197] "green"  "green"  "green"  "green"  "green"  "green"  "green" 
##  [204] "green"  "green"  "green"  "green"  "green"  "green"  "green" 
##  [211] "green"  "green"  "green"  "green"  "green"  "green"  "green" 
##  [218] "green"  "green"  "green"  "green"  "green"  "green"  "green" 
##  [225] "green"  "green"  "green"  "green"  "green"  "green"  "green" 
##  [232] "green"  "green"  "green"  "green"  "green"  "green"  "green" 
##  [239] "green"  "green"  "green"  "green"  "green"  "green"  "green" 
##  [246] "green"  "green"  "green"  "green"  "green"  "green"  "green" 
##  [253] "green"  "green"  "green"  "green"  "green"  "green"  "green" 
##  [260] "green"  "green"  "green"  "green"  "green"  "green"  "green" 
##  [267] "green"  "green"  "green"  "green"  "green"  "green"  "green" 
##  [274] "green"  "green"  "green"  "green"  "green"  "green"  "green" 
##  [281] "green"  "green"  "green"  "green"  "green"  "green"  "green" 
##  [288] "green"  "green"  "green"  "green"  "green"  "green"  "green" 
##  [295] "green"  "green"  "green"  "green"  "green"  "green"  "green" 
##  [302] "green"  "green"  "green"  "green"  "green"  "green"  "green" 
##  [309] "green"  "green"  "green"  "green"  "green"  "green"  "green" 
##  [316] "green"  "green"  "green"  "green"  "green"  "green"  "green" 
##  [323] "green"  "green"  "green"  "green"  "green"  "green"  "green" 
##  [330] "green"  "green"  "green"  "green"  "green"  "green"  "green" 
##  [337] "green"  "green"  "green"  "green"  "purple" "purple" "green" 
##  [344] "green"  "green"  "green"  "green"  "green"  "purple" "green" 
##  [351] "green"  "green"  "green"  "green"  "green"  "purple" "green" 
##  [358] "green"  "purple" "purple" "green"  "purple" "purple" "green" 
##  [365] "green"  "green"  "green"  "green"  "purple" "purple" "purple"
##  [372] "purple" "green"  "green"  "green"  "green"  "green"  "purple"
##  [379] "purple" "green"  "green"  "purple" "purple" "green"  "purple"
##  [386] "purple" "green"  "purple" "green"  "green"  "green"  "purple"
##  [393] "green"  "green"  "purple" "purple" "green"  "green"  "green" 
##  [400] "purple" "green"  "green"  "green"  "green"  "green"  "green" 
##  [407] "green"  "green"  "green"  "green"  "green"  "green"  "green" 
##  [414] "green"  "green"  "purple" "purple" "green"  "green"  "green" 
##  [421] "green"  "purple" "purple" "purple" "grey"   "green"  "purple"
##  [428] "green"  "green"  "green"  "green"  "purple" "green"  "green" 
##  [435] "green"  "green"  "green"  "green"  "purple" "purple" "green" 
##  [442] "green"  "green"  "green"  "green"  "green"  "green"  "purple"
##  [449] "purple" "purple" "purple" "purple" "green"  "purple" "purple"
##  [456] "purple" "purple" "purple" "purple" "green"  "purple" "purple"
##  [463] "green"  "green"  "green"  "green"  "green"  "green"  "green" 
##  [470] "green"  "green"  "purple" "green"  "green"  "green"  "green" 
##  [477] "green"  "green"  "green"  "green"  "green"  "purple" "purple"
##  [484] "purple" "green"  "purple" "green"  "green"  "purple" "purple"
##  [491] "purple" "purple" "green"  "green"  "green"  "green"  "green" 
##  [498] "purple" "purple" "purple" "purple" "purple" "green"  "purple"
##  [505] "green"  "green"  "green"  "green"  "green"  "green"  "green" 
##  [512] "green"  "green"  "green"  "purple" "green"  "purple" "green" 
##  [519] "green"  "green"  "purple" "purple" "purple" "purple" "purple"
##  [526] "purple" "purple" "green"  "green"  "green"  "purple" "green" 
##  [533] "green"  "green"  "green"  "green"  "green"  "green"  "green" 
##  [540] "green"  "purple" "purple" "green"  "green"  "green"  "green" 
##  [547] "purple" "green"  "green"  "purple" "green"  "green"  "green" 
##  [554] "green"  "purple" "purple" "purple" "purple" "green"  "green" 
##  [561] "green"  "green"  "green"  "green"  "purple" "purple" "green" 
##  [568] "purple" "green"  "purple" "purple" "green"  "green"  "green" 
##  [575] "purple" "green"  "green"  "green"  "green"  "purple" "purple"
##  [582] "purple" "green"  "green"  "green"  "purple" "green"  "green" 
##  [589] "green"  "green"  "green"  "purple" "purple" "purple" "green" 
##  [596] "green"  "green"  "green"  "green"  "green"  "purple" "purple"
##  [603] "green"  "green"  "green"  "green"  "green"  "purple" "green" 
##  [610] "green"  "green"  "green"  "green"  "green"  "green"  "green" 
##  [617] "green"  "green"  "green"  "green"  "green"  "green"  "green" 
##  [624] "green"  "green"  "green"  "green"  "green"  "green"  "green" 
##  [631] "green"  "green"  "green"  "green"  "green"  "purple" "purple"
##  [638] "green"  "green"  "green"  "green"  "purple" "green"  "green" 
##  [645] "green"  "green"  "green"  "purple" "green"  "purple" "purple"
##  [652] "purple" "purple" "green"  "purple" "purple" "purple" "purple"
##  [659] "purple" "green"  "purple" "purple" "purple" "green"  "purple"
##  [666] "green"  "purple" "green"  "green"  "green"  "green"  "purple"
##  [673] "purple" "green"  "purple" "purple" "purple" "green"  "purple"
##  [680] "green"  "green"  "purple" "purple" "green"  "purple" "green" 
##  [687] "purple" "purple" "blue"   "purple" "purple" "green"  "purple"
##  [694] "purple" "green"  "purple" "purple" "purple" "grey"   "purple"
##  [701] "green"  "purple" "purple" "green"  "purple" "purple" "green" 
##  [708] "green"  "green"  "purple" "purple" "purple" "green"  "purple"
##  [715] "purple" "purple" "green"  "green"  "purple" "purple" "purple"
##  [722] "green"  "purple" "purple" "purple" "purple" "purple" "purple"
##  [729] "purple" "purple" "green"  "purple" "purple" "purple" "purple"
##  [736] "purple" "purple" "purple" "purple" "purple" "purple" "purple"
##  [743] "purple" "purple" "purple" "purple" "purple" "purple" "purple"
##  [750] "purple" "purple" "purple" "purple" "green"  "purple" "purple"
##  [757] "purple" "purple" "purple" "purple" "purple" "purple" "purple"
##  [764] "purple" "purple" "green"  "purple" "green"  "green"  "green" 
##  [771] "purple" "green"  "purple" "purple" "purple" "green"  "purple"
##  [778] "purple" "purple" "purple" "purple" "purple" "purple" "purple"
##  [785] "purple" "purple" "purple" "purple" "purple" "green"  "green" 
##  [792] "purple" "purple" "purple" "purple" "purple" "purple" "purple"
##  [799] "purple" "purple" "purple" "purple" "purple" "purple" "purple"
##  [806] "purple" "purple" "purple" "purple" "purple" "purple" "purple"
##  [813] "purple" "purple" "purple" "purple" "green"  "green"  "purple"
##  [820] "purple" "purple" "purple" "purple" "green"  "purple" "purple"
##  [827] "green"  "purple" "green"  "green"  "grey"   "green"  "purple"
##  [834] "purple" "green"  "green"  "purple" "purple" "green"  "green" 
##  [841] "green"  "purple" "green"  "green"  "purple" "purple" "purple"
##  [848] "purple" "green"  "green"  "purple" "purple" "purple" "purple"
##  [855] "purple" "purple" "purple" "green"  "green"  "green"  "green" 
##  [862] "purple" "purple" "purple" "purple" "purple" "purple" "purple"
##  [869] "green"  "purple" "purple" "purple" "purple" "purple" "purple"
##  [876] "green"  "green"  "purple" "purple" "purple" "purple" "purple"
##  [883] "purple" "green"  "purple" "purple" "purple" "purple" "purple"
##  [890] "purple" "purple" "green"  "purple" "green"  "purple" "green" 
##  [897] "purple" "purple" "green"  "green"  "purple" "purple" "purple"
##  [904] "green"  "green"  "purple" "purple" "purple" "purple" "purple"
##  [911] "purple" "purple" "purple" "purple" "purple" "green"  "green" 
##  [918] "purple" "purple" "green"  "purple" "purple" "purple" "purple"
##  [925] "purple" "purple" "purple" "purple" "purple" "purple" "purple"
##  [932] "purple" "purple" "purple" "purple" "purple" "purple" "green" 
##  [939] "grey"   "grey"   "purple" "purple" "purple" "green"  "green" 
##  [946] "purple" "purple" "purple" "purple" "green"  "purple" "green" 
##  [953] "green"  "green"  "purple" "green"  "green"  "green"  "green" 
##  [960] "purple" "purple" "purple" "purple" "green"  "purple" "purple"
##  [967] "green"  "purple" "purple" "purple" "green"  "purple" "green" 
##  [974] "purple" "green"  "green"  "green"  "purple" "purple" "green" 
##  [981] "green"  "green"  "green"  "green"  "green"  "purple" "green" 
##  [988] "purple" "green"  "purple" "purple" "purple" "purple" "purple"
##  [995] "green"  "purple" "purple" "green"  "purple" "purple"
##  [ reached getOption("max.print") -- omitted 8640 entries ]

# plot the lines data, apply a diff color to each factor level)
plot(sjer_roads,
     col=roadColors,
     lwd=2,
     main="Madera County Roads")
```

<img src="{{ site.url }}/images/rfigs/course-materials/earth-analytics/week-4/homework/2016-12-06-plot01-custom-legend-R/palette-and-plot-1.png" title=" " alt=" " width="100%" />

### Adjust Line Width
We can also adjust the width of our plot lines using `lwd`. We can set all lines
to be thicker or thinner using `lwd=`.


```r
# make all lines thicker
plot(sjer_roads,
     col=roadColors,
     main="Madera County Roads\n All Lines Thickness=6",
     lwd=6)
```

<img src="{{ site.url }}/images/rfigs/course-materials/earth-analytics/week-4/homework/2016-12-06-plot01-custom-legend-R/adjust-line-width-1.png" title="map of madera roads" alt="map of madera roads" width="100%" />

### Adjust Line Width by Attribute

If we want a unique line width for each factor level or attribute category
in our spatial object, we can use the same syntax that we used for colors, above.

`lwd=c("widthOne", "widthTwo","widthThree")[object$factor]`

Note that this requires the attribute to be of class `factor`. Let's give it a
try.


```r
class(sjer_roads$RTTYP)
## [1] "factor"
levels(sjer_roads$RTTYP)
## [1] "C"       "M"       "S"       "unknown"
# create vector of line widths
lineWidths <- (c(1, 2, 3, 4))[sjer_roads$RTTYP]
# adjust line width by level
# in this case, boardwalk (the first level) is the widest.
plot(sjer_roads,
     col=roadColors,
     main="Madera County Roads \n Line width varies by TYPE Attribute Value",
     lwd=lineWidths)
```

<img src="{{ site.url }}/images/rfigs/course-materials/earth-analytics/week-4/homework/2016-12-06-plot01-custom-legend-R/line-width-unique-1.png" title=" " alt=" " width="100%" />

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

<img src="{{ site.url }}/images/rfigs/course-materials/earth-analytics/week-4/homework/2016-12-06-plot01-custom-legend-R/roads-map-1.png" title="roads map modified" alt="roads map modified" width="100%" />

<i class="fa fa-star"></i> **Data Tip:** Given we have a factor with 4 levels,
we can create an vector of numbers, each of which specifies the thickness of each
feature in our `SpatialLinesDataFrame` by factor level (category): `c(6,4,1,2)[sjer_roads$RTTYP]`
{: .notice}

## Add Plot Legend
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

# we can use the color object that we created above to color the legend objects
roadPalette
## [1] "blue"   "green"  "grey"   "purple"

# add a legend to our map
legend("bottomright",   # location of legend
      legend=levels(sjer_roads$RTTYP), # categories or elements to render in
			 # the legend
      fill=roadPalette) # color palette to use to fill objects in legend.
```

<img src="{{ site.url }}/images/rfigs/course-materials/earth-analytics/week-4/homework/2016-12-06-plot01-custom-legend-R/add-legend-to-plot-1.png" title=" " alt=" " width="100%" />

We can tweak the appearance of our legend too.

* `bty=n`: turn off the legend BORDER
* `cex`: change the font size

Let's try it out.


```r
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
```

<img src="{{ site.url }}/images/rfigs/course-materials/earth-analytics/week-4/homework/2016-12-06-plot01-custom-legend-R/modify-legend-plot-1.png" title="custom legend" alt="custom legend" width="100%" />

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

# add a legend to our map
legend("bottomright",
       levels(sjer_roads$RTTYP),
       fill=newColors,
       bty="n", cex=.8)
```

<img src="{{ site.url }}/images/rfigs/course-materials/earth-analytics/week-4/homework/2016-12-06-plot01-custom-legend-R/plot-different-colors-1.png" title="adjust colors" alt="adjust colors" width="100%" />

<i class="fa fa-star"></i> **Data Tip:** You can modify the defaul R color palette
using the palette method. For example `palette(rainbow(6))` or
`palette(terrain.colors(6))`. You can reset the palette colors using
`palette("default")`!
{: .notice}

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
## [1] "C"       "M"       "S"       "unknown"
# make sure the attribute is of class "factor"
class(sjer_roads$RTTYP)
## [1] "factor"

# convert to factor if necessary
sjer_roads$RTTYP <- as.factor(sjer_roads$RTTYP)
levels(sjer_roads$RTTYP)
## [1] "C"       "M"       "S"       "unknown"

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
     main="NEON Harvard Forest Field Site\n Roads Where Bikes and Horses Are Allowed")

# add a legend to our map
legend("bottomright",
       levels(sjer_roads$RTTYP),
       fill=challengeColors, 
       bty="n", # turn off border
       cex=.8) # adjust font size
```

<img src="{{ site.url }}/images/rfigs/course-materials/earth-analytics/week-4/homework/2016-12-06-plot01-custom-legend-R/road-map-2-1.png" title="emphasize some attributes" alt="emphasize some attributes" width="100%" />

Finall, let's adjust the legend. We want the legend SYMBOLS to represent the 
actual symbology in the map - which contains lines, not polygons. 


```r
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
```

<img src="{{ site.url }}/images/rfigs/course-materials/earth-analytics/week-4/homework/2016-12-06-plot01-custom-legend-R/final-custom-legend-1.png" title="Custom legend with lines" alt="Custom legend with lines" width="100%" />

<!-- C = County
I = Interstate
M = Common Name
O = Other
S = State recognized
U = U.S.-->
