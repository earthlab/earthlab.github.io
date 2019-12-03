---
title: "Intro to Metadata File Formats and Structure"
authors: [Leah Wasser]
contributors: [NEON Data Skills]
dateCreated: 2016-09-27
lastModified: 2016-11-29
packagesLibraries: [raster, rgdal, eml, devtools]
category: [course-materials]
excerpt: "This tutorial introduces the importance of metadata. It
also broadly covers embedded, structured and unstructured metadata."
permalink: course-materials/spatial-data/metadata-file-formats-structures
class-lesson: ['intro-spatial-data-r']
author_profile: false
sidebar:
  nav:
nav-title: 'metadata intro'
comments: false
order: 10
---


This tutorial introduces the importance of metadata. It
also broadly covers embedded, structured and unstructured metadata.

**R Skill Level:** Beginner

<div class="notice--success" markdown="1">


# Goals / Objectives

After completing this activity, you will:

* Understand that what metadata are and the various formats that you may
encounter metadata


### Install R Packages

**OPTIONAL** This tutorial uses these `R` packages in the examples.
 If you want to follow along, please make sure the following packages
 are installed:

* **raster:** `install.packages("raster")`
* **rgdal:** `install.packages("rgdal")`

* [More on Packages in R - Adapted from Software Carpentry.]({{site.baseurl}}R/Packages-In-R/)

****


### Additional Resources

* Information on the
<a href="http://cran.r-project.org/web/packages/raster/raster.pdf" target="_blank"> `raster` R package</a>

</div>

![ ]({{ site.baseurl }}/images/rfigs/dc-spatial-intro/10-metadata-formats-and-files/elevation-map-1.png)


<div class="notice--warning" markdown="1">
## Challenge: What Do I Know About My Data?

The figure above was created from a dataset that you are given called:
`HARV_dsmCrop.tif`.

* What other information would you like to know about the data
used to create the above map before you would feel comfortable using this data
to address a research question?
* Think about the data used to create this plot. If you had to share this data
with a colleague, what information do they need to know, to efficiently work
with it?

How does thinking about this plot and what you'd like to know about it influence
how you think about sharing data with a colleague?

</div>



## Why Do We Need Metadata?

Looking at the map above, we are missing information needed to begin working
with the data effectively, including:

**Spatial Information**

* **Spatial Extent:** What area does this dataset cover?
* **Coordinate reference system:** What spatial projection / coordinate reference
system is used to store the data? Will it line up with other data?
* **Resolution:** The data appears to be in **raster** format. This means it is
composed of pixels. What area on the ground does each pixel cover - i.e. What is
its spatial resolution?

**Data Collection / Processing Methods**

* **When was the data collected?** Is it recent or historical?
* **How was this data generated?** Is this an output from a model, is it an image
from a remote sensing instrument such as a satellite (e.g. Landsat) or collected
from an airplane? How were the data collected?
* **Units:** We can see a scale bar of values to the right of the data, however,
what metric and in what units does this represent? Temperature? Elevation? Precipitation?
* **How were the data processed?**

**Contact Information**

* **Who created this data?**
* **Who do we contact:** We might need permission to use it, have questions
about the data, or need more information to give correct attribution.

When we are given a dataset, or when we download it online, we do not know
anything about it without proper documentation. This documentation is called
**metadata** - data about the data.

## What are Metadata?
Metadata are structured information that describes a dataset. Metadata include
a suite of information about the data including:

* Contact information,
* Spatial attributes including: extent, coordinate reference system, resolution,
* Data collection & processing methods,
* and much more.

Without sufficient documentation, it is difficult for us to work with external
data - data that we did not collect ourselves.

### Why Are Metadata Needed?

We need metadata to work with external data. When metadata are embedded
in a file or in provided in a machine readable format, we can access it directly
in tools like `R` or `Python` to support automated workflows. We will talk about
different metadata formats, next.


## Metadata Formats

Metadata come in different formats. We will discuss three of those in this
tutorial:

* **Structured Embedded Metadata:** Some file formats supported embedded
metadata which you can access from a tool like `R` or `Python` directly from the
imported data (e.g. **GeoTIFF** and **HDF5**). This data is contained in the same
file (or file set as for shapefiles) as the data.
* **Structured Metadata Files:** Structured metadata files, such as the
Ecological Metadata Language (**EML**), are stored in a machine readable format
which means they can be accessed using a tool like `R` or `Python`. These files
must be shared with and accompany the separate data files. There are
different file formats and standards so it's important to understand that
standards will vary.
* **Unstructured Metadata Files:** This broad group includes text files,
web pages and other documentation that does not follow a particular standard or
format, but documents key attributes required to work with the data.

Structured metadata formats are ideal if you can find them because they are most
often:

* In a standard, documented format that others use.
* Are machine readable which means you can use them in scripts and algorithms.

<i class="fa fa-star"></i> **Data Note:** When you find metadata for a dataset
that you are working with, **DOWNLOAD AND SAVE IT** immediately to the directory
on your computer where you saved the data. It is also a good idea to document
the URL where you found the metadata and the data in a "readme" text file that
is also stored with the data!
{: .notice}
