


```{r load-libraries, warning=FALSE, message=FALSE, echo=FALSE}
# load libraries
library(raster)
library(rgdal)
```

```{r open-raster, fig.cap="raster data example of embedded metadata", echo=FALSE}
# open raster data
lidar_dem <- raster(x="data/week3/BLDR_LeeHill/pre-flood/lidar/pre_DTM.tif")

# plot raster data
plot(lidar_dem,
  axes=FALSE, box=FALSE)
```

<div class="notice--warning" markdown="1">
## Understand metadata

The figure above was created from a dataset that you are given called:
`pre_DTM.tif`. Looking at the figure, what do you know about that data? Can
you answer any of the following questions:

* What is the resolution of the data?
* What is the spatial extent (what area does the data cover)?
* Who collected the data?
* How were the data collected?

Consider these data. If you had to share this
with a colleague, what information do they need to know, to efficiently work
with it?

</div>

## What are Metadata?
To address many if not all of the questions posed above, we use metadata.
Metadata are (sometimes) structured information that describes a dataset. Metadata
can include a suite of information about the data including:

* Contact information,
* Spatial attributes including: extent, coordinate reference system, resolution,
* Data collection & processing methods,
* and much more.

Without sufficient documentation, it is difficult for us to work with external
data - data that we did not collect ourselves.

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

### Why Are Metadata Needed?

We need metadata to understand how to work with our data. FOr example we may need
to know what the spatial resolution is (pixel size) of a raster. The metadata
can provide this information. When metadata are embedded
in a file or in provided in a machine readable format, we can access it directly
in tools like `R` or `Python` to support automated workflows.

## Metadata Formats

Metadata come in different formats. In this lesson we will focus on structured
metadata associated with the geotiff file format. However below we mention
several different structures that can be used to format metadata:

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

<i class="fa fa-star"></i> **Data Note:** When you find metadata stored on a website
for a dataset that you are working with, **DOWNLOAD AND SAVE IT** immediately to
the directory on your computer where you saved the data. It is also a good idea to document
the URL where you found the metadata and the data in a "readme" text file that
is also stored with the data!
{: .notice}


## Embedded Metadata - GeoTIFF

If we want to automate workflows, it's ideal for key metadata required to
process our data to be embedded directly in our data files. The **GeoTIFF**
(`fileName.tif`) is one common spatial data format that can store
**metadata** directly in the `.tif` file itself.
