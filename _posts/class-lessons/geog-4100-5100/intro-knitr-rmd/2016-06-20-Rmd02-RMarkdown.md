---
layout: single
title: "Document Code with R Markdown"
description: "This tutorial cover how to use R Markdown files to document code."
date: 2016-05-18
dateCreated: 2016-01-01
lastModified: 2016-06-10
estimatedTime:
packagesLibraries: [knitr, rmarkdown]
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
permalink: /tutorial-series/pre-institute3/rmd02
comments: true
---



You will need to have the `rmarkdown` and `knitr`
packages installed on your computer prior to completing this tutorial. Refer to
<a href="http://neon-workwithdata.github.io/neon-data-institute-2016/tutorial-series/install-R-packages" target="_blank"> the setup materials</a> to get these installed.

<div id="objectives" markdown="1">

# Learning Objectives
At the end of this activity, you will:

* Know how to create an R Markdown file in RStudio.
* Be able to write a script with text and R code chunks.
* Create an R Markdown document ready to be ‘knit’ into an HTML document to
share your code and results.

## Things You’ll Need To Complete This Tutorial

You will need the most current version of R and, preferably, RStudio loaded on
your computer to complete this tutorial.

### Install R Packages


* **knitr:** `install.packages("knitr")`
* **rmarkdown:** `install.packages("rmarkdown")`
* **raster:** `install.packages("raster")`
* **rgdal:** `install.packages("rgdal")`

### Download Data

{% include/dataSubsets/_data_Data-Institute-16-TEAK.html %}

You will want to create a **data** directory for all the Data Institute teaching
data sets. We suggest the pathway be `~/Documents/data/NEONDI-2016` or
the equivalent for your operating system. Once you've downloaded and unzipped
the dataset, move it to this directory.

<figure>
	<a href="{{ site.baseurl }}/images/pre-institute-content/pre-institute3-rmd/FileStructureScreenShot.png">
	<img src="{{ site.baseurl }}/images/pre-institute-content/pre-institute3-rmd/FileStructureScreenShot.png"></a>
	<figcaption> The <strong>data</strong> directory with the teaching data subset. This is the suggested organization for all Data Institute teaching data subsets.
	Source: National Ecological Observatory Network (NEON)
	</figcaption>
</figure>


## Additional Resources
* <a href="http://www.rstudio.com/wp-content/uploads/2016/03/rmarkdown-cheatsheet-2.0.pdf" target="_blank"> R Markdown Cheatsheet</a>: a very handy reference for using R
Markdown
* <a href="http://www.rstudio.com/wp-content/uploads/2015/03/rmarkdown-reference.pdf" target="_blank"> R Markdown Reference Guide</a>: a more expensive reference for R
Markdown
* <a href="http://rmarkdown.rstudio.com/articles_intro.html" target="_blank"> Introduction to R Markdown by Garrett Grolemund</a>: a tutorial for learning R Markdown

</div>

## Create a new RMarkdown file in RStudio

Our goal in week 3 is to document our workflow. We can do this by

1. Creating an R Markdown (RMD) file in R studio and
2. Rendering that RMD file to HTML using `knitr`.

Watch this 6:38 minute video below to learn more about how you can convert an R Markdown
file to HTML (or other formats) using `knitr` in RStudio.
The text size in the video is small so you may want to watch the video in
full screen mode.

<iframe width="560" height="315" src="https://www.youtube.com/embed/DNS7i2m4sB0" frameborder="0" allowfullscreen></iframe>

## Create an RMD File

Now that you have a sense of how R Markdown can be used in R studio, you are
ready to create your own RMD document. Do the following:

1. Create a new R Markdown file and choose HTML as the desired output format.
2. Enter a Title (Explore NEON LiDAR Data) and Author Name (your name). Then click OK.
3. Save the file using the following format: **LastName-institute-week3.rmd**
NOTE: The document title is not the same as the file name.
4. Hit the knit button in RStudio (as is done in the video above). What happens?

<figure>
	<a href="{{ site.baseurl }}/images/pre-institute-content/pre-institute3-rmd/KnitButton-screenshot.png">
	<img src="{{ site.baseurl }}/images/pre-institute-content/pre-institute3-rmd/KnitButton-screenshot.png"></a>
	<figcaption> Location of the knit button in RStudio in Version 0.99.486.
	Source: National Ecological Observatory Network (NEON)
	</figcaption>
</figure>

If everything went well, you should have an HTML format (web page) output
after you hit the knit button. Note that this HTML output is built from a
combination of code and documentation that was written using markdown syntax.


Next, we'll break down the structure of an R Markdown file.

## Understand Structure of an R Markdown file

 <figure>
	<a href="{{ site.baseurl }}/images/pre-institute-content/pre-institute3-rmd/NewRmd-html-screenshot.png">
	<img src="{{ site.baseurl }}/images/pre-institute-content/pre-institute3-rmd/NewRmd-html-screenshot.png"></a>
	<figcaption>Screenshot of a new R Markdown document in RStudio. Notice the different
	parts of the document.
	Source: National Ecological Observatory Network (NEON)
	</figcaption>
</figure>

<i class="fa fa-star"></i> **Data Tip:** Screenshots on this page are
from RStudio with appearance preferences set to `Twilight` with `Monaco` font. You
can change the appearance of your RStudio by **Tools** > **Options**
(or **Global Options** depending on the operating system). For more, see the
<a href="https://support.rstudio.com/hc/en-us/articles/200549016-Customizing-RStudio" target="_blank">Customizing RStudio page</a>.
{: .notice}

Let's next review the structure of an R Markdown (`.Rmd`) file. There are three
main content types:

* **Header:** the text at the top of the document, written in *YAML* format.
* **Markdown sections:** text that describes your workflow written using *markdown syntax*.
* **Code chunks:** Chunks of R code that can be run and also can be rendered
using knitr to an output document.

Next let's explore each section type.

### Header -- YAML block

An R Markdown file always starts with header written using
<a href="https://en.wikipedia.org/wiki/YAML" target="_blank">YAML syntax</a>.
There are four default elements in the RStudio generated YAML header:


* **title:** the title of your document. Note, this is not the same as the file name.
* **author:** who wrote the document.
* **date:** by default this is the date that the file is created.
* **output:** what format will the output be in. We will use HTML.

A YAML header may be structured differently depending upon how your are using it.
Learn more on the
<a href="http://rmarkdown.rstudio.com/authoring_quick_tour.html#output_options" target="_blank"> R Markdown documentation page</a>.

<div id="challenge" markdown="1">
## Activity: R Markdown YAML
Customize the header of your `.Rmd` file as follows:

* **Title:** Provide a title that fits the code that will be in your RMD.
* **Author:** Add your name here.
* **Output:** Leave the default output setting: `html_document`.
We will be rendering an HTML file.

</div>

### R Markdown Text / Markdown Blocks

An RMD document contains a mixture of code chunks and markdown blocks where
you can describe aspects of your processing workflow. The markdown blocks use the
**same** markdown syntax that we learned last week in week 2 materials. In these blocks
you might describe the data that you are using, how it's being processed and
and what the outputs are. You may even add some information that interprets
the outputs.

When you render your document to HTML, this markdown will appear as text on the
output HTML document.

<a class="btn btn-info" href="http://rmarkdown.rstudio.com/authoring_basics.html" target="_blank"> Learn More about RStudio Markdown Basics</a>

### Explore Your R Markdown File

Look closely at the pre-populated markdown and R code chunks in your RMD file.

Does any of the markdown syntax look familiar?

* Are any words in bold?
* Are any words in italics?
* Are any words highlighted as code?

If you are unsure, the answers are at the bottom of this page.

 <div id="challenge" markdown="1">
## Activity: R Markdown Text

1. Remove the template markdown and code chunks added to the RMD file by RStudio.
(Be sure to keep the YAML header!)
2. At the very top of your RMD document - after the YAML header, add
the bio and short research description that you wrote last week in markdown syntax to
the RMD file.
3. Between your profile and the research descriptions, add a header that says
**About My Project** (or something similar).
4. Add a new header stating **Week 3 Activity** and text below that explaining
that this page demonstrates using some of the NEON Teakettle LiDAR data products
in R. The wording of this text should clearly describe the code and outputs that
you will be adding the page.

</div>

<i class="fa fa-star"></i> **Data Tip**: You can add code output or an R object
name to markdown segments of an RMD. For more, view this
<a href="http://rmarkdown.rstudio.com/authoring_quick_tour.html#inline_r_code" target="_blank"> R Markdown documentation</a>.
{: .notice}

### Code chunks

Code chunks are where your R code goes. All code chunks start and end with
<code>```</code>  -- three backticks or graves. On
your keyboard, the backticks can be found on the same key as the tilde.
Graves are not the same as an apostrophe!

The initial line of a code chunk must appear as:

<pre><code> ```{r chunk-name-with-no-spaces}
# code goes here
 ```</code></pre>

The `r` part of the chunk header identifies this chunk as an R code chunk and is
mandatory. Next to the `{r}`, there is a chunk name. This name is not required
for basic knitting however, it is good practice to give each chunk a unique
name as it is required for more advanced knitting approaches.

<div id="challenge" markdown="1">

## Activity: Add Code Chunks to Your R Markdown File

Continue working on your document. Below the last section that you've just added,
create a code chunk that loads the packages required to work with raster data
in R, and sets the working directory.

<pre><code>```{r setup-read-data }
   library(rgdal)
   library(raster)

   # set working directory to ensure R can find the file we wish to import
   setwd("~/Documents/data/NEONDI-2016/")

 ```</code></pre>

(For help setting the working directory, see the NEON Data Skills tutorial
<a href="http://neondataskills.org/R/Set-Working-Directory" target="_blank">*Set A Working Directory in R*</a>.)

Then, add another chunk that loads the `TEAK_lidarDSM` raster file.

<pre><code>```{r load-dsm-raster }

   # import dsm
   teak_dsm <- raster("NEONdata/D17-California/TEAK/2013/lidar/TEAK_lidarDSM.tif")

 ```</code></pre>

Now run the code in this chunk.

You can run code chunks:

* **Line-by-line:** with cursor on current line, Ctrl + Enter (Windows/Linux) or
Command + Enter (Mac OS X).
* **By chunk:** You can run the entire chunk (or multiple chunks) by
clicking on the `Chunks` dropdown button in the upper right corner of the script
environment and choosing the appropriate option. Keyboard shortcuts are
available for these options.

</div>

### Code chunk options

You can also add arguments or options to each code chunk. These arguments allow
you to customize how or if you want code to be
processed or appear on the output HTML document. Code chunk arguments are added on
the first line of a code
chunk after the name, within the curly brackets.

The example below, is a code chunk that will not be "run", or evaluated, by R.
The code within the chunk will appear on the output document, however there
will be no outputs from the code.

<pre><code>```{r intro-option, eval=FALSE}
# the code here will not be processed by R
# but it will appear on your output document
1+2
 ```</code></pre>

We use `eval=FALSE` often when the chunk is exporting an file that we don't
need to re-export but we want to document the code used to export the file.

Three common code chunk options are:

* `eval = FALSE`: Do not **eval**uate (or run) this code chunk when
knitting the RMD document. The code in this chunk will still render in our knitted
HTML output, however it will not be evaluated or run by `R`.
* `echo=FALSE`: Hide the code in the output. The code is
evaluated when the RMD file is knit, however only the output is rendered on the
output document.
* `results=hide`: The code chunk will be evaluated but the results or the code
will not be rendered on the output document. This is useful if you are viewing the
structure of a large object (e.g. outputs of a large `data.frame`).

Multiple code chunk options can be used for the same chunk. For more on code
chunk options, read
<a href="http://rmarkdown.rstudio.com/authoring_rcodechunks.html" target="_blank"> the RStudio documentation</a>
or the
<a href="http://yihui.name/knitr/demo/output/" target="_blank"> knitr documentation</a>.

<div id="challenge" markdown="1">
## Activity: Add More Code to Your R Markdown

Update your RMD file as follows:

* Add a **new code chunk** that plots the `TEAK_lidarDSM` raster object that you imported above.
Experiment with plot colors and be sure to add a plot title.
* Run the code chunk that you just added to your RMD document in R (e.g. run in console, not
knitting). Does it create a plot with a title?
* In another new code chunk, import and plot another raster file from the NEON data subset
that you downloaded. The `TEAK_lidarCHM` is a good raster to plot.
* Finally, create histograms for both rasters that you've imported into R.
* Be sure to document your steps as you go using both **code comments** and
**markdown syntax** in between the code chunks.

For help opening and plotting raster data in `R`, see the NEON Data Skills tutorial
<a href="http://neondataskills.org/R/Plot-Rasters-In-R/" target="_blank">*Plot Raster Data in R*</a>.

We will knit this document to HTML in the next tutorial.
</div>

Now continue on to the
[next tutorial]({{site.baseurl}}/tutorial-series/pre-institute3/rmd03)
to learn how to knit this document into a HTML file.

## Answers to the Default Text Markdown Syntax Questions

* Are any words in bold? - Yes, “Knit” on line 10
* Are any words in italics? - No
* Are any words highlighted as code? - Yes, “echo = FALSE” on line 22
