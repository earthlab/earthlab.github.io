---
layout: single
title: "Code Chunks in R Markdown"
excerpt: 'This tutorial cover how code chunks are written and formatted within an
R Markdown file in R Studio.'
authors: [Leah Wasser, NEON Data Skills]
category: [course-materials]
lastModified: 2016-12-20
class-lesson: ['intro-rmarkdown-knitr']
permalink: /course-materials/earth-analytics/wk1-disturbance-erosion-r/intro-rmarkdown-code-chunks/
nav-title: 'Code Chunks'
sidebar:
  nav:
author_profile: false
comments: false
order: 4
---

Next, we will talk about code chunks in `R markdown` files.

<div class='notice--success' markdown="1">

# Learning Objectives
At the end of this activity, you will:

* Be able to add code to a code chunk in an .rmd file
* Be able to add options to a code chunk in R Studio

## Things You’ll Need To Complete This Tutorial

You will need the most current version of R and, preferably, RStudio loaded on
your computer to complete this tutorial.

### Install R Packages

* **knitr:** `install.packages("knitr")`
* **rmarkdown:** `install.packages("rmarkdown")`

</div>

We have we have already learned that an `.Rmd` document contains three parts

1. A `YAML` header
2. Text chunks in markdown syntax that describe your processing workflow or are the text for your report.
3. Code chunks that process, visualize and/or analyze your data.

Let's break down code chunks in `.Rmd` files.


<i class="fa fa-star"></i> **Data Tip**: You can add code output or an R object
name to markdown segments of an RMD. For more, view this
<a href="http://rmarkdown.rstudio.com/authoring_quick_tour.html#inline_r_code" target="_blank"> R Markdown documentation</a>.
{: .notice}

## Code chunks

Code chunks in an R Markdown document contain your `R` code. All code chunks
 start and end with <code>```</code> -- three backticks or
graves. On your keyboard, the backticks can be found on the same key as the
tilde (~). Graves are not the same as an apostrophe!

A code chunk looks like this:

<pre><code>

```r
# code goes here
```
 </code></pre>

The first line: <code>```{r chunk-name-with-no-spaces}</code> contains the language (`r`) in this case, and the name of the chunk. Specifying
the language is mandatory. Next to the `{r}`, there is a chunk name. The chunk
name is not necessarily required however, it is good practice to give each
chunk a unique name to support more advanced knitting approaches.

<div class="notice--warning" markdown="1">

## Activity: Add Code Chunks to Your R Markdown File

Continue working on your document. Below the last section that you've just added,
create a code chunk that loads the packages required to work with raster data
in R, and sets the working directory.

<pre>
<code>
 
 ```r
 
   1+2
 ## [1] 3
 ```
 </code>
 </pre>


Then, add another chunk that does something?? .

<pre><code>```{r load-dsm-raster }

   # code here
   code here...

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

## Code Format

Notice that in each of our code chunks, we've introduced `comments`. Comments
are lines in our code that are not run by `R`. However they allow us to describe
the intent of our code. Get in the habit of adding comments as you code. We will discuss this further when we break down scientific programming in `R` in a
later tutorial.

## Code chunk options

You can add arguments or options to each code chunk. These arguments allow
us to customize how or if you want code to be
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
structure of a large object (e.g. outputs of a large `data.frame` which is
  the equivalent of a spreadsheet in `r`).

Multiple code chunk options can be used for the same chunk. For more on code
chunk options, read
<a href="http://rmarkdown.rstudio.com/authoring_rcodechunks.html" target="_blank"> the RStudio documentation</a>
or the
<a href="http://yihui.name/knitr/demo/output/" target="_blank"> knitr documentation</a>.

<div class="notice--warning" markdown="1">

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
