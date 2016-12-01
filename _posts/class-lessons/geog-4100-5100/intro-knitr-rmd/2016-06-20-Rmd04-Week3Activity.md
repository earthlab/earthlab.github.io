---
layout: single
title: "Pre-Institute Week 3 Assignment"
description: "This page details how to complete the assignment for pre-Institute week 3."
date: 2016-05-16
dateCreated: 2016-01-01
lastModified: 2016-06-10
estimatedTime:
packagesLibraries:
authors:
categories: [tutorial-series]
tags:
mainTag: pre-institute3-rmd
tutorialSeries: pre-institute3-rmd
code1:
image:
 feature: data-institute-2016.png
 credit:
 creditlink:
permalink: /tutorial-series/pre-institute3/pre-week-3-activity
comments: true
---

## About
This tutorial covers the NEON Pre-Institute Week 3 assignment. If you already
are familiar with `R Markdown` and `knitr`, you may be able to complete the
assignment without working through the tutorials.

<div id="objectives" markdown="1">

# Deadlines
**Due:** Please submit your activity R Markdown and HTML files to the
**NEON-WorkWithData/DI16-NEON-participants** GitHub repo as a **pull request**
by 11:59pm on 16 June 2016.

## Download Data

{% include/dataSubsets/_data_Data-Institute-16-TEAK.html %}

</div>


To begin, please do the following:

1. Download data from the Lower Teakettle field site - from the NEON Data Skills
Figshare repository.
2. Unzip the data into (or transfer the unzipped data into) a `data` directory
on your computer. The path to your data will look like this:

`~Documents\data\NEONDI-2016\`

<figure>
	<a href="{{ site.baseurl }}/images/pre-institute-content/pre-institute3-rmd/FileStructureScreenShot.png">
	<img src="{{ site.baseurl }}/images/pre-institute-content/pre-institute3-rmd/FileStructureScreenShot.png"></a>
	<figcaption> The <strong>data</strong> directory with the TEAK teaching data
	subset. This is the suggested organization for all Data Institute teaching
	data subsets.
	Source: National Ecological Observatory Network (NEON)
	</figcaption>
</figure>

We will be using the GeoTIFF raster files in the **lidar** subdirectory of the
teaching data subset.

## Create R Markdown File

The three tutorials in this series walk you through how to create, edit, and knit
R Markdown files. The components of the finished RMD and HTML files should include:

* A .Rmd file that will be knit to an HTML output.
* Your name as an author of the file.
* At the top of the .Rmd file, add your **bio** and **project summary**
that
[you wrote and submitted in week 2 as a `.md` file]({{ site.baseurl }}/tutorial-series/pre-institute2/git-culmination).
Please update your project summary if you have changes.

* In the RMD file, create a script that does the following:
  * Open and plot at least 2 raster files in the `lidar` directory using the `plot()`
  function in the `raster` R package.
  * Create a histogram for each raster file that shows the distribution of values
  in the file.
  * All plots should be labelled appropriately.
* Include 3 or more named R code chunks.
* OPTIONAL: Code chunk options in at least 1 chunk, e.g.`warnings = FALSE`.
* Break up your code into R Markdown chunks that makes sense to you. Use
Markdown syntax to document the steps that you are taking to "process" the data.
Provide some summary discussion of the results at the end of the document.
HINT: the raster `TEAK_lidarCHM` represents **tree height** for the field site.
You might comment on how tall the trees are on average at the site.

## Knitr: RMD to HTML

Once you have completed the steps above:

* Knit your .Rmd file to HTML.
* Submit both the .Rmd and the .html documents to the
**/participants/pre-institute3-rmd** directory in the
**NEON-WorkWithData/DI16-NEON-participants** GitHub repository.

## Supporting Materials

If you would like a primer on plotting raster files in R, visit the NEON Data Skills tutorial: <a href="http://neondataskills.org/R/Plot-Rasters-In-R/" target="_blank">*Plot Raster Data in R*</a>.
