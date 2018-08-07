---
layout: single
title: "How to create an R Markdown File in R Studio and the R Markdown File Structure"
excerpt: 'Learn about the format of a R Markdown file including a YAML header, R code and markdown formatted text.'
authors: ['Leah Wasser', 'NEON Data Skills']
modified: '2018-01-10'
category: [courses]
class-lesson: ['intro-rmarkdown-knitr']
permalink: /courses/earth-analytics/document-your-science/intro-to-the-rmarkdown-format-and-knitr/
nav-title: 'Create R Markdown File'
week: 1
sidebar:
  nav:
author_profile: false
comments: true
order: 2
course: "earth-analytics"
topics:
  reproducible-science-and-programming: ['rmarkdown']
---
{% include toc title="In this lesson" icon="file-text" %}


## Getting Started
Let's dive deeper into the `R Markdown` file format. This tutorial will introduce
you to working with `R Markdown` files in `R` and `R Studio`. You will create an
`R Markdown` file and render it to html using the `knitr` package.

<div class='notice--success' markdown="1">

## <i class="fa fa-graduation-cap" aria-hidden="true"></i> Learning Objectives
At the end of this activity, you will:

* Know how to create an `R Markdown` file in `RStudio`.
* Be able to write a script with text and `R` code chunks.
* Create an `R Markdown` document ready to be 'knit' into an `html` document to
share your code and results.

## <i class="fa fa-check-square-o fa-2" aria-hidden="true"></i> What You Need

You will need the most current version of `R` and, preferably, `RStudio` loaded on
your computer to complete this tutorial.

### Install R Packages

* **knitr:** `install.packages("knitr")`
* **rmarkdown:** `install.packages("rmarkdown")`

</div>

##  <i class="fa fa-youtube-play" aria-hidden="true"></i> Create a New R Markdown File in RStudio

Watch the 6:38 minute video below to see how you convert
an `R Markdown` file to `html` (or other formats) using `knitr` in `RStudio`.
**NOTE:** The text size in the video is small so you may want to watch the video in
full screen mode.

<iframe width="560" height="315" src="https://www.youtube.com/embed/DNS7i2m4sB0" frameborder="0" allowfullscreen></iframe>

### Create Your .Rmd File

Now that you see how `R Markdown` can be used in `RStudio`, you are
ready to create your own `.Rmd` document. Do the following:

1. Create a new `R Markdown` file and choose `html` as the desired output format.
2. Enter a Title (Earth Analytics Week 1) and Author Name (your name). Then click OK.
3. Save the file using the following format: **FirstInitial-LastName-document-your-science/.Rmd**
NOTE: The document title is not the same as the file name.
4. Hit the <kbd>`Knit HTML`</kbd> drop down button in `RStudio` (as is done in the video above). What happens?

<figure class="half">
<a href="{{ site.url }}/images/courses/earth-analytics/document-your-science/intro-knitr-rmd/create-rmd.png">
<img src="{{ site.url }}/images/courses/earth-analytics/document-your-science/intro-knitr-rmd/create-rmd.png" alt="knitr button screenshot"></a>
	<a href="{{ site.url }}/images/courses/earth-analytics/document-your-science/intro-knitr-rmd/KnitButton-screenshot.png">
	<img src="{{ site.url }}/images/courses/earth-analytics/document-your-science/intro-knitr-rmd/KnitButton-screenshot.png" alt="knitr button screenshot"></a>
	<figcaption> LEFT: Create a new RMD file using the file drop down menu in
  R Studio. RIGHT: Location of the knit button in RStudio in Version 0.99.903.
	</figcaption>
</figure>

If everything went well, you should have an `html` format (web page) output
after you hit the knit button. Note that this `html` output is built from a
combination of code and text documentation that was written using markdown syntax.

*Don't worry if you don't know what markdown is. You will learn that in the next
lesson.*

Next, let's break down the structure of an `R Markdown` file.

## The Structure of an R Markdown File

 <figure>
	<a href="{{ site.url }}/images/courses/earth-analytics/document-your-science/intro-knitr-rmd/NewRmd-html-screenshot.png">
	<img src="{{ site.url }}/images/courses/earth-analytics/document-your-science/intro-knitr-rmd/NewRmd-html-screenshot.png" alt="create new rmd document"></a>
	<figcaption>Screenshot of a new R Markdown document in RStudio. Checkout the three
  types of information: 1. the YAML header at the very top 2. Chunks of r code
  separated by <code>```</code> and 3. Text written using markdown syntax.
	</figcaption>
</figure>

<i class="fa fa-star"></i> **Data Tip:** Screenshots on this page are
from `RStudio` with appearance preferences set to `Twilight` with `Monaco` font. You
can change the appearance of your RStudio by **Tools** > **Options**
(or **Global options** depending on the operating system). For more, see the
<a href="https://support.rstudio.com/hc/en-us/articles/200549016-Customizing-RStudio" target="_blank">Customizing RStudio page</a>.
{: .notice--success}

There are three parts to an `.Rmd` file:

* **Header:** The text at the top of the document, written in *YAML* format.
* **Markdown sections:** Text that describes your workflow written using *markdown syntax*.
* **Code chunks:** Chunks of `R` code that can be run and also can be rendered
using `knitr` to an output document.

Next, let's break down each of the parts listed above.

### YAML Header (front matter)

An R Markdown file always starts with a header written using
<a href="https://en.wikipedia.org/wiki/YAML" target="_blank">YAML syntax</a>.
This header is sometimes referred to as the `front matter`.

There are four default elements in the `RStudio` `YAML` header:

* **title:** The title of your document. Note, this is not the same as the file name.
* **author:** Who wrote the document.
* **date:** By default this is the date that the file is created.
* **output:** What format will the output be in. You will use `html`.

Note that a YAML header begins and ends with three
dashes `---`. Also notice that the value for each element, title, author, etc,
is in quotes `"value-here"` next to the element.  A YAML header may be structured
differently depending upon how your are using it. Learn more on the
<a href="http://rmarkdown.rstudio.com/authoring_quick_tour.html#output_options" target="_blank"> R Markdown documentation page</a>.

Example YAML header in an `RStudio` `R Markdown` file:

```xml
---
title: "title"
author: "Your Name"
date: "December 4, 2016"
output: html_document
---
```

### R Markdown Text & Markdown Blocks

The second part of a `R Markdown` document is the markdown itself which is used
to add documentation to your file (or write your report). You will learn markdown
in the next tutorial.

<div class="notice--warning" markdown="1">

## <i class="fa fa-pencil-square-o" aria-hidden="true"></i> Activity: Customize Your R Markdown File's Front Matter - YAML
Customize the header of your `.Rmd` file as follows:

* **Title:** Provide a title that fits the code that will be in your RMD.
* **Author:** Add your name here.
* **Date:** Today's date.
* **Output:** Leave the default output setting: `html_document`.You will be rendering an `html` file.

</div>
