---
layout: single
title: "Classify a Raster in R."
excerpt: "This lesson presents how to classify a raster dataset and export it as a
new raster in R."
authors: ['Leah Wasser']
modified: '2018-01-10'
category: [courses]
class-lesson: ['intro-lidar-raster-r']
permalink: /courses/earth-analytics/lidar-raster-data-r/classify-raster/
nav-title: 'Classify a Raster'
week: 3
course: "earth-analytics"
sidebar:
  nav:
author_profile: false
comments: true
order: 5
topics:
  reproducible-science-and-programming:
  remote-sensing: ['lidar']
  earth-science: ['vegetation']
  spatial-data-and-gis: ['raster-data']
---

{% include toc title="In This Lesson" icon="file-text" %}



<div class='notice--success' markdown="1">

## <i class="fa fa-graduation-cap" aria-hidden="true"></i> Learning Objectives

After completing this tutorial, you will be able to:

* Reclassify a raster dataset in `R` using a set of defined values.
* Describe the difference between using breaks to plot a raster compared to
reclassifying a raster object.

## <i class="fa fa-check-square-o fa-2" aria-hidden="true"></i> What You Need

You need `R` and `RStudio` to complete this tutorial. Also you should have
an `earth-analytics` directory set up on your computer with a `/data`
directory with it.

* [How to set up R / RStudio](/courses/earth-analytics/document-your-science/setup-r-rstudio/)
* [Set up your working directory](/courses/earth-analytics/document-your-science/setup-working-directory/)
* [Intro to the R & RStudio interface](/courses/earth-analytics/document-your-science/intro-to-r-and-rstudio)

### R Libraries to Install:

* **raster:** `install.packages("raster")`
* **rgdal:** `install.packages("rgdal")`

If you have not already downloaded the week 3 data, please do so now.
[<i class="fa fa-download" aria-hidden="true"></i> Download Week 3 Data (~250 MB)](https://ndownloader.figshare.com/files/7446715){:data-proofer-ignore='' .btn }

</div>

### Reclassification vs. Breaks

In this lesson, you will learn how to reclassify a raster dataset in `R`. Previously,
you plotted a raster value using break points - that is to say, you colored particular
ranges of raster pixels using a defined set of values that you call `breaks`.
In this lesson, you will learn how to reclassify a raster. When you reclassify
a raster you create a **new** raster object / file that can be exported and shared
with colleagues and / or opened in other tools such as `QGIS`.


<figure>
<img src="http://resources.esri.com/help/9.3/arcgisdesktop/com/gp_toolref/geoprocessing_with_3d_analyst/Reclass_Reclass2.gif" alt="reclassification process by ESRI">
<figcaption>When you reclassify a raster you create a new raster. In that raster, each cell from the old raster is mapped to the new raster. The values in the new raster are applied using a defined range of values or a raster map. For example above you can see that all cells that
contain the values 1-3 are assigned the new value of 5. Image source: ESRI.
</figcaption>
</figure>

## Load Libraries




```r
# load the raster and rgdal libraries
library(raster)
library(rgdal)
```

## Raster Classification Steps

You can break your raster processing workflow into several steps as follows:

* **Data import / cleanup:** Load and "clean" the data. This may include cropping, dealing with `NA` values, etc.
* **Data exploration:** Understand the range and distribution of values in your data. This may involve plotting histograms scatter plots, etc.
* **More data processing & analysis:** This may include the final data processing steps that you determined based upon the data exploration phase.
* **Final data analysis:** The final steps of your analysis - often performed using information gathered in the early data processing / exploration stages of your workflow.
* **Presentation:** Refining your results into a final plot or set of plots that are cleaned up, labeled, etc.

Please note - working with data is not a linear process. There are no defined
steps. As you work with data more, you will develop your own workflow and approach.

To get started, let's first open up your raster. In this case you are using the lidar
canopy height model (`CHM`) that you calculated in the previous lesson.


```r
# open canopy height model
lidar_chm <- raster("data/week-03/BLDR_LeeHill/outputs/lidar_chm.tif")
```

### What Classification Values to Use?

You want to classify your raster into 3 classes:

* Short
* Medium
* Tall

However, what value represents a tall vs a short tree? You need to better
understand your data before assigning classification values to it. Let's begin
by looking at the `min` and `max` values in your `CHM`.


```r
summary(lidar_chm)
##         lidar_chm
## Min.     0.000000
## 1st Qu.  0.000000
## Median   0.000000
## 3rd Qu.  0.710083
## Max.    24.989990
## NA's     0.000000
```

Looking at the summary above, it appears as if you have a range of values from
0 to 26.9300537.

Let's explore the data further by looking at a histogram. A histogram quantifies
the distribution of values found in your data.


```r
# plot histogram of data
hist(lidar_chm,
     main = "Distribution of raster cell values in the DTM difference data",
     xlab = "Height (m)", ylab = "Number of Pixels",
     col = "springgreen")
```

<img src="{{ site.url }}/images/rfigs/courses/earth-analytics/03-lidar-raster-data/lidar-raster-intro/2017-02-01-raster05-classify-raster/plot-histogram-1.png" title="histogram of lidar chm data" alt="histogram of lidar chm data" width="90%" />

You can further explore your histogram by constraining the `x axis` limits using the
`lims` argument. The lims argument visually
zooms in on the data in the plot. It does not modify the data!


```r
# zoom in on x and y axis
hist(lidar_chm,
     xlim = c(2, 25),
     ylim = c(0, 4000),
     main = "Histogram of canopy height model differences \nZoomed in to -2 to 2 on the x axis",
     col = "springgreen")
```

<img src="{{ site.url }}/images/rfigs/courses/earth-analytics/03-lidar-raster-data/lidar-raster-intro/2017-02-01-raster05-classify-raster/hist-contrained-1.png" title="plot of chm histogram constrained above 0" alt="plot of chm histogram constrained above 0" width="90%" />

You can look at the values that `R` used to draw your histogram too. To do this, you assign
your `hist()` function to a new variable. Then you look at the variable contents. This
shows you the breaks used to bin your histogram data.




```r
# see how R is breaking up the data
histinfo <- hist(lidar_chm)
```

<img src="{{ site.url }}/images/rfigs/courses/earth-analytics/03-lidar-raster-data/lidar-raster-intro/2017-02-01-raster05-classify-raster/view-hist-info-1.png" title="histogram of lidar data - view data" alt="histogram of lidar data - view data" width="90%" />

Each bin represents a bar on your histogram plot. Each bar represents the frequency
or number of pixels that have a value within that bin. For instance, there
is a break between 0 and 1 in the histogram results above. And there are 76,057 pixels
in the counts element that fall into that bin.


```r
histinfo$counts
##  [1] 76134  3478  3149  2820  2383  2096  1996  1793  1500  1185   950
## [12]   749   556   411   282   199   134    87    52    25     8     8
## [23]     1     3     1
histinfo$breaks
##  [1]  0  1  2  3  4  5  6  7  8  9 10 11 12 13 14 15 16 17 18 19 20 21 22
## [24] 23 24 25
```

If you want to customize your histogram further, you can customize the number of
breaks that `R` uses to create it.


```r
# zoom in on x and y axis
hist(lidar_chm,
     xlim = c(2, 25),
     ylim = c(0, 1000),
     breaks = 100,
     main = "Histogram of canopy height model differences \nZoomed in to -2 to 2 on the x axis",
     col = "springgreen",
     xlab = "Pixel value")
```

<img src="{{ site.url }}/images/rfigs/courses/earth-analytics/03-lidar-raster-data/lidar-raster-intro/2017-02-01-raster05-classify-raster/create-lidar-hist-1.png" title="histogram of lidar chm" alt="histogram of lidar chm" width="90%" />

Notice that I've adjusted the x and y lims to zoom into the region of the histogram
that I am interested in exploring.

### Histogram with Custom Breaks

You can create custom breaks or bins in a histogram too. To do this, you pass the
same breaks argument a vector of numbers that represent the range for each bin
in your histogram.

By using custom breaks, you can explore how your data may look when you classify it.


```r
# You may want to explore breaks in your histogram before plotting your data
hist(lidar_chm,
     breaks = c(0, 5, 10, 15, 20, 30),
     main = "Histogram with custom breaks",
     xlab = "Height (m)" , ylab = "Number of Pixels",
     col = "springgreen")
```

<img src="{{ site.url }}/images/rfigs/courses/earth-analytics/03-lidar-raster-data/lidar-raster-intro/2017-02-01-raster05-classify-raster/histogram-breaks-1.png" title="histogram with custom breaks" alt="histogram with custom breaks" width="90%" />

You may want to play with the distribution of breaks. Below it appears as if
there are many values close to 0. In the case of this lidar instrument you know that
values between 0 and 2 meters are not reliable (you know this if you read the documentation
about the NEON sensor and how these data were processed). Let's create a bin between 0-2.

You know you want to create bins for short, medium and tall trees so let's experiment
with those bins also.

Below I use the following breaks:

* 0 - 2 = no trees
* 2 - 4 = short trees
* 4 - 7 = medium trees
* `>` 7 = tall trees



```r
# You may want to explore breaks in your histogram before plotting your data
hist(lidar_chm,
     breaks = c(0, 2, 4, 7, 30),
     main = "Histogram with custom breaks",
     xlab = "Height (m)" , ylab = "Number of Pixels",
     col = "springgreen")
```

<img src="{{ site.url }}/images/rfigs/courses/earth-analytics/03-lidar-raster-data/lidar-raster-intro/2017-02-01-raster05-classify-raster/histogram-breaks2-1.png" title="histogram with custom breaks" alt="histogram with custom breaks" width="90%" />

You may want to play around with the classes further. Or you may have a scientific
reason to select particular classes. Regardless, let's use the classes above to
reclassify your `CHM` raster.

## Map Raster Values to New Values

To reclassify your raster, first you need to create a reclassification matrix. This
matrix MAPS a range of values to a new defined value. Let's create a classified
canopy height model where you designate short, medium and tall trees.

The newly defined values will be as follows:

* No trees: (0m - 2m tall) = NA
* Short trees: (2m - 4m tall) = 1
* Medium trees: (4m - 7m tall) = 2
* Tall trees:  (> 7m tall) = 3

Notice in the list above that you set cells with a value between 0 and 2 meters to
`NA` or no data value. This means you are assuming that there are no trees in those
locations!

Notice in the matrix below that you use `Inf` to represent the largest or `max` value
found in the raster. So your assignment is as follows:

* 0 - 2 meters -> NA
* 2 - 4 meters -> 1 (short trees)
* 4-7 meters -> 2 (medium trees)
* `>` 7 or 7 - Inf -> 3 (tall trees)

Let's create the matrix!


```r
# create classification matrix
reclass_df <- c(0, 2, NA,
              2, 4, 1,
             4, 7, 2,
             7, Inf, 3)
reclass_df
##  [1]   0   2  NA   2   4   1   4   7   2   7 Inf   3
```

Next, you reshape your list of numbers below into a matrix with rows and columns.
The matrix data format supports numeric data and can be one or more dimensions.
Your matrix below is similar to a spreadsheet with rows and columns.


```r
# reshape the object into a matrix with columns and rows
reclass_m <- matrix(reclass_df,
                ncol = 3,
                byrow = TRUE)
reclass_m
##      [,1] [,2] [,3]
## [1,]    0    2   NA
## [2,]    2    4    1
## [3,]    4    7    2
## [4,]    7  Inf    3
```

## Reclassify Raster

Once you have created your classification matrix, you can reclassify your `CHM` raster
using the `reclassify()` function.


```r
# reclassify the raster using the reclass object - reclass_m
chm_classified <- reclassify(lidar_chm,
                     reclass_m)
```

You can view the distribution of pixels assigned to each class using the `barplot()`.
Note that I am not using the histogram function in this case given you only have 3 classes!


```r
# view reclassified data
barplot(chm_classified,
        main = "Number of pixels in each class")
```

<img src="{{ site.url }}/images/rfigs/courses/earth-analytics/03-lidar-raster-data/lidar-raster-intro/2017-02-01-raster05-classify-raster/barplot-pixels-1.png" title="create barplot of classified rasters" alt="create barplot of classified rasters" width="90%" />

If the raster classification output has values of 0, you can set those to `NA` using
the syntax below. The left side of this syntax tells `R` to first select ALL pixels
in the raster where
the pixel value = 0. `chm_classified[chm_classified == 0]`. Notice the use of two equal
signs `==` in this statement.

The right side of the code says "assign to NA" `<- NA`


```r
# assign all pixels that equal 0 to NA or no data value
chm_classified[chm_classified == 0] <- NA
```

Then, finally you can plot your raster. Notice the colors that I selected are not ideal!
You can pick better colors for your plot.


```r
# plot reclassified data
plot(chm_classified,
     col = c("red", "blue", "green"))
```

<img src="{{ site.url }}/images/rfigs/courses/earth-analytics/03-lidar-raster-data/lidar-raster-intro/2017-02-01-raster05-classify-raster/reclassify-plot-raster-1.png" title="classified chm plot" alt="classified chm plot" width="90%" />

## Add Custom Legend

Your plot looks OK but the legend doesn't represent the data well. The legend is
continuous - with a range between 0 and 3. However you want to plot the data using
discrete bins.

Let's clean up your plot legend. Given you have discrete values you will
create a CUSTOM legend with the 3 categories that you created in your classification matrix.



```r
# plot reclassified data
plot(chm_classified,
     legend = FALSE,
     col = c("red", "blue", "green"), axes = FALSE,
     main = "Classified Canopy Height Model \n short, medium, tall trees")

legend("topright",
       legend = c("short trees", "medium trees", "tall trees"),
       fill = c("red", "blue", "green"),
       border = FALSE,
       bty = "n") # turn off legend border
```

<img src="{{ site.url }}/images/rfigs/courses/earth-analytics/03-lidar-raster-data/lidar-raster-intro/2017-02-01-raster05-classify-raster/plot-w-legend-1.png" title="classified chm with legend." alt="classified chm with legend." width="90%" />

Finally, let's create a color object so you don't have to type out the colors twice.


```r
# create color object with nice new colors!
chm_colors <- c("palegoldenrod", "palegreen2", "palegreen4")

# plot reclassified data
plot(chm_classified,
     legend = FALSE,
     col = chm_colors,
     axes = FALSE,
     # remove the box around the plot
     box = FALSE,
     main = "Classified Canopy Height Model \n short, medium, tall trees")

legend("topright",
       legend = c("short trees", "medium trees", "tall trees"),
       fill = chm_colors,
       border = FALSE,
       bty = "n")
```

<img src="{{ site.url }}/images/rfigs/courses/earth-analytics/03-lidar-raster-data/lidar-raster-intro/2017-02-01-raster05-classify-raster/plot-w-legend-colors-1.png" title="classified chm with legend." alt="classified chm with legend." width="90%" />

Finally, you may want to remove the box from your plot.


```r
# create color object with nice new colors!
chm_colors <- c("palegoldenrod", "palegreen2", "palegreen4")

# plot reclassified data
plot(chm_classified,
     legend = FALSE,
     col = chm_colors,
     axes = FALSE,
     box = FALSE,
     main = "Classified Canopy Height Model \n short, medium, tall trees")

legend("topright",
       legend = c("short trees", "medium trees", "tall trees"),
       fill = chm_colors,
       border = FALSE,
       bty = "n")
```

<img src="{{ site.url }}/images/rfigs/courses/earth-analytics/03-lidar-raster-data/lidar-raster-intro/2017-02-01-raster05-classify-raster/plot-w-legend-colors2-1.png" title="classified chm with legend." alt="classified chm with legend." width="90%" />

<div class="notice--warning" markdown="1">

## <i class="fa fa-pencil-square-o" aria-hidden="true"></i> Optional Challenge: Plot Change Over Time

1. Create a classified raster map that shows **positive and negative change**
in the canopy height model before and after the flood. To do this you will need
to calculate the difference between two canopy height models.
2. Create a classified raster map that shows **positive and negative change**
in terrain extracted from the pre and post flood Digital Terrain Models before
and after the flood.

For each plot, be sure to:

* Add a legend that clearly shows what each color in your classified raster represents.
* Use better colors than I used in my example above!
* Add a title to your plot.

You will include these plots in your final report due next week.

Check out <a href="https://www.nceas.ucsb.edu/~frazier/RSpatialGuides/colorPaletteCheatsheet.pdf" target="_blank">this cheatsheet for more on colors in `R`. </a>

Or type: `grDevices::colors()` into the r console for a nice list of colors!
</div>
