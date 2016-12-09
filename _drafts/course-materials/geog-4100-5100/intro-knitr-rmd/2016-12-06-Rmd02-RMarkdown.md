---
layout: single
title: "Write Reports and Document Workflow Using R Markdown"
excerpt: 'This tutorial cover how to create an R Markdown file in R and then
render it to html using knitr.'
authors: [Leah Wasser, NEON Data Skills]
category: [course-materials]
class-lesson: ['intro-rmarkdown-knitr']
permalink: /course-materials/intro-rmarkdown-knitr2
nav-title: 'Create RMarkdown File'
sidebar:
  nav:
author_profile: false
comments: false
order: 2
---


## Getting Started
Let's dive deeper into the R Markdown file format. This tutorial will introduce you to working with R markdown files in `R` and
`R Studio`. We will create an R Markdown file and render it to html using the
`knitr` package.

<div class='notice--success' markdown="1">

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

</div>

## Create a new RMarkdown file in RStudio

Watch the 6:38 minute video below to see how we convert
an R Markdown file to HTML (or other formats) using `knitr` in `RStudio`.
**NOTE:** The text size in the video is small so you may want to watch the video in
full screen mode.

<iframe width="560" height="315" src="https://www.youtube.com/embed/DNS7i2m4sB0" frameborder="0" allowfullscreen></iframe>

## Create an RMD File

Now that you see how R Markdown can be used in RStudio, you are
ready to create your own `.RMD` document. Do the following:

1. Create a new R Markdown file and choose HTML as the desired output format.
2. Enter a Title (Earth Analytics Week 1) and Author Name (your name). Then click OK.
3. Save the file using the following format: **FirstInitial-LastName-week-1.rmd**
NOTE: The document title is not the same as the file name.
4. Hit the `knit` button in RStudio (as is done in the video above). What happens?

<figure>
	<a href="{{ site.url }}{{ site.baseurl }}/images/course-materials/geog-4100-5100/intro-knitr-rmd/KnitButton-screenshot.png">
	<img src="{{ site.url }}{{ site.baseurl }}/images/course-materials/geog-4100-5100/intro-knitr-rmd/KnitButton-screenshot.png"></a>
	<figcaption> Location of the knit button in RStudio in Version 0.99.486.
	Source: National Ecological Observatory Network (NEON)
	</figcaption>
</figure>

If everything went well, you should have an HTML format (web page) output
after you hit the knit button. Note that this HTML output is built from a
combination of code and text documentation that was written using markdown syntax.

*Don't worry if you don't know what markdown is. We will cover that in the next
lesson.*

Next, let's break down the structure of an R Markdown file.

## The Structure of an R Markdown file

 <figure>
	<a href="{{ site.url }}{{ site.baseurl }}/images/course-materials/geog-4100-5100/intro-knitr-rmd/NewRmd-html-screenshot.png">
	<img src="{{ site.url }}{{ site.baseurl }}/images/course-materials/geog-4100-5100/intro-knitr-rmd/NewRmd-html-screenshot.png"></a>
	<figcaption>Screenshot of a new R Markdown document in RStudio. Notice the different
	parts of the document.
	Source: National Ecological Observatory Network (NEON)
	</figcaption>
</figure>

<i class="fa fa-star"></i> **Data Tip:** Screenshots on this page are
from `RStudio` with appearance preferences set to `Twilight` with `Monaco` font. You
can change the appearance of your RStudio by **Tools** > **Options**
(or **Global Options** depending on the operating system). For more, see the
<a href="https://support.rstudio.com/hc/en-us/articles/200549016-Customizing-RStudio" target="_blank">Customizing RStudio page</a>.
{: .notice}

There are three parts to an `.RMD` file:

* **Header:** the text at the top of the document, written in *YAML* format.
* **Markdown sections:** text that describes your workflow written using *markdown syntax*.
* **Code chunks:** Chunks of R code that can be run and also can be rendered
using `knitr` to an output document.

Next, let's break down each of the parts listed above.

## 1. Header -- YAML Header (Front Matter)

An R Markdown file always starts with a header written using
<a href="https://en.wikipedia.org/wiki/YAML" target="_blank">YAML syntax</a>.
This header is sometimes referred to as the `front matter`.

There are four default elements in the RStudio YAML header:

* **title:** the title of your document. Note, this is not the same as the file name.
* **author:** who wrote the document.
* **date:** by default this is the date that the file is created.
* **output:** what format will the output be in. We will use HTML.

Note that a YAML header begins and ends with three
dashes `---`. Also notice that the value for each element, title, author, etc,
is in quotes `"value-here"` next to the element.  A YAML header may be structured differently depending upon how your are using it. Learn more on the
<a href="http://rmarkdown.rstudio.com/authoring_quick_tour.html#output_options" target="_blank"> R Markdown documentation page</a>.

Example YAML header in an R Studio R Markdown file:

```xml
---
title: "title"
author: "Your Name"
date: "December 4, 2016"
output: html_document
---
```

<div class="notice--warning" markdown="1">

## Activity: Customize your R Markdown File's Front Matter - YAML
Customize the header of your `.Rmd` file as follows:

* **Title:** Provide a title that fits the code that will be in your RMD.
* **Author:** Add your name here.
* **Date:** Today's date.
* **Output:** Leave the default output setting: `html_document`.
We will be rendering an HTML file.

</div>

### R Markdown Text / Markdown Blocks

The second part of a R Markdown document is the markdown itself which is used
to add documentation to your file (or write your report). We will cover markdown
in the next tutorial.
