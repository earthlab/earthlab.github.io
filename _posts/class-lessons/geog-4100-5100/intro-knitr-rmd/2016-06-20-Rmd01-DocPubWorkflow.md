---
layout: single
title: "Document & Publish Your Workflow: R Markdown & knitr"
description: "This tutorial introduces the importance of tools supporting documenting & publishing a workflow."
date: 2016-05-19
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
permalink: /tutorial-series/pre-institute3/rmd01
comments: true
---



This tutorial we will work with the `knitr` and `rmarkdown` packages within
`RStudio` to learn how to effectively and efficiently document and publish our
workflows online.

<div id="objectives" markdown="1">

# Learning Objectives
At the end of this activity, you will be able to:

* Explain why documenting and publishing one's code is important.
* Describe two tools that enable ease of publishing code & output: R Markdown and
the `knitr` package.

</div>

## Documentation Is Important

As we read in
<a href="http://neon-workwithdata.github.io/neon-data-institute-2016/tutorial-series/pre-institute1/rep-sci" target="_blank"> week 1</a>,
the four facets of reproducible science are:

* Documentation
* Organization,
* Automation and
* Dissemination.

This week we will learn about the R Markdown file format (and R package) which
can be used with the `knitr` package to document and publish (disseminate) your
code and code output.

<a class="btn btn-info" href="http://neon-workwithdata.github.io/slide-shows/share-publish-archive-slideshow.html" target= "_blank"> View Slideshow: Share, Publish & Archive -  from the Reproducible Science Curriculum</a>

## The Tools We Will Use

### R Markdown

> “R Markdown is an authoring format that enables easy creation of dynamic
documents, presentations, and reports from R. It combines the core syntax of
markdown (an easy to write plain text format) with embedded R code chunks that
are run so their output can be included in the final document. R Markdown
documents are fully reproducible (they can be automatically regenerated whenever
underlying R code or data changes)."
-- <a href="http://rmarkdown.rstudio.com/" target="_blank">RStudio documentation</a>.

We use markdown syntax in R Markdown (.rmd) files to document workflows and
to share data processing, analysis and visualization outputs. We can also use it
to create documents that combine R code, output and text.

<i class="fa fa-star"></i> **Data Tip:** Most of the
<a href="https://github.com/NEONInc/NEON-Data-Skills" target="_blank">neondataskills.org </a>
and the
<a href="https://github.com/NEON-WorkWithData/neon-data-institute-2016" target="_blank">Data Institute </a>
sites are built using R Markdown files.
{: .notice}


### Why R Markdown?
There are many advantages to using R Markdown in your work:

* Human readable syntax.
* Simple syntax - it can be learned quickly.
* All components of your work are clearly documented. You don't have to remember
what steps, assumptions, tests were used.
* You can easily extend or refine analyses by modifying existing or adding new
code blocks.
* Analysis results can be disseminated in various formats including HTML, PDF,
slide shows and more.
* Code and data can be shared with a colleague to replicate the workflow.

<i class="fa fa-star"></i> **Data Tip:**
<a href="https://rpubs.com/" target= "_blank ">RPubs</a>
is a quick way to share and publish code.
{: .notice}

## Knitr

The `knitr` package for R allows us to create readable documents from R Markdown
files.

<figure class="half">
	<a href="{{ site.baseurl }}/images/pre-institute-content/pre-institute3-rmd/rmd-file.png">
	<img src="{{ site.baseurl }}/images/pre-institute-content/pre-institute3-rmd/rmd-file.png">
	</a>
	<a href="{{ site.baseurl }}/images/pre-institute-content/pre-institute3-rmd/knitr-output.png">
	<img src="{{ site.baseurl }}/images/pre-institute-content/pre-institute3-rmd/knitr-output.png">
	</a>
	<figcaption>R Markdown script (left) and the HTML produced from the knit R
	Markdown script (right). Source: National Ecological Observatory Network (NEON)
	</figcaption>
</figure>
>The knitr package was designed to be a transparent engine for dynamic report
generation with R --
<a href="http://yihui.name/knitr/" target="_blank"> Yihui Xi -- knitr package creator</a>


In the
[next tutorial]({{site.baseurl}}/tutorial-series/pre-institute3/rmd02)
we will learn more about working with the R Markdown format in R Studio.
