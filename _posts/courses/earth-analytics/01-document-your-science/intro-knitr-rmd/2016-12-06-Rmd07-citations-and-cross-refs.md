---
layout: single
title: "Add Citations and Cross References to an R Markdown Report with Bookdown"
excerpt: "Learn how to use bookdown in R to add citations and cross references to your data-driven reports."
authors: ['Leah Wasser']
modified: '2018-01-10'
category: [courses]
class-lesson: ['intro-rmarkdown-knitr']
permalink: /courses/earth-analytics/document-your-science/add-citations-to-rmarkdown-report/
nav-title: 'Add Citations to R Markdown'
course: "earth-analytics"
week: 1
sidebar:
  nav:
author_profile: false
comments: true
order: 7
topics:
  reproducible-science-and-programming: ['rmarkdown']
---

{% include toc title="In This Lesson" icon="file-text" %}


<div class='notice--success' markdown="1">

## <i class="fa fa-graduation-cap" aria-hidden="true"></i> Learning Objectives

After completing this tutorial, you will be able to:

* Add citations to an `R Markdown` report.
* Create a `BibTex` file to store citation data to use with `R Markdown`.

## <i class="fa fa-check-square-o fa-2" aria-hidden="true"></i> What You Need

You need `R` and `RStudio` to complete this tutorial. Also you should have
an `earth-analytics` directory set up on your computer with a `/data`
directory with it.

* [How to set up R / RStudio](/courses/earth-analytics/document-your-science/setup-r-rstudio/)
* [Set up your working directory](/courses/earth-analytics/document-your-science/setup-working-directory/)

</div>

To begin, be sure that `bookdown` is already installed on your computer.


```r

# make sure bookdown is installed
install.packages("bookdown")

```

## Introducing Bookdown

`Bookdown` is an `R Markdown` extension that can be used to create reports. In
this lesson however you will review briefly how to use `bookdown` to create single
document reports. The steps are as follows:

### 1. Add the Following Code to Your YAML Header in Your R Markdown Document

Note that this code replaces the `output: html_document` that is the default for
R Markdown.

```md
output:
  bookdown::html_document2: default
```

This tells `R` to use `bookdown` rather than the conventional `R Markdown`. Notice below
you use `html_document2` to create html output with inline citations.

To achieve different styling and formats, you can replace `html_document2` with other outputs including:

* `tufte_html2`,
* `pdf_document2`,
* `word_document2`,
* `tufte_handout2`,
* and `tufte_book2`

<a href="https://bookdown.org/yihui/bookdown/a-single-document.html#ref-R-rticles" target="_blank">Learn more about bookdown output options here.</a>

Your R Markdown YAML header will thus look like this:

```md
---
title: "Your title here"
author: "Your name here"
output:
  bookdown::html_document2: default
---

```

### 2. Create a BibTex File Containing References

Next, create a `BibTex` file containing all of the citations that you will use
in your report. A `BibTex` file is a text formatted, machine readable reference
list. You can create BibTex reference lists in many reference manager tools
including **Zotero** and **Mendeley** or you can go the hard route and make one
on your own. A `BibTex` file should be named with a `.bib` extension for example
`references.bib` and needs to be saved using the UTF-8 encoding.

An example of a `BibText` formatted citation is below.

```md
@Manual{anderson2015,
  title = {Exhumation by debris flows in the 2013 Colorado Front Range storm},
  author = { S.W. Anderson and S.P. Anderson and R.S Anderson},
  journal = {Geology},
  year = {2015},
  pages = {31,94},
  url = {https://www.R-project.org/},
}

```

Be sure to save that file in the same working directory with your .Rmd file!

### 3. Add a Link to Your BibText File to the YAML Header

Using the code below, add a link to your BibTex file.

```md
bibliography: your-bib-file.bib
```

Now your entire YAML header looks like this:

```md
---
title: "Your title here"
author: "Your name here"
output:
  bookdown::html_document2: default
bibliography: your-bib-file.bib
---
```

You can also add the link-citations: yes argument to your YAML header to ensure
that R creates links from your citation to the bibliography below. Like this:

```md
---
title: "Your title here"
author: "Your name here"
output:
  bookdown::html_document2: default
bibliography: your-bib-file.bib
link-citations: yes
---
```

## Add In-text Citations / References to Your Report

Finally you can add citations to a report. To do this you use the syntax

`@anderson2015`

Where anderson2015 is the **name** of the Anderson citation (used an example below).
The `@` sign tells `R` to find that particular citation in the `.bib` file.

## Add Unique Styles

If you want - you can also apply custom stylesheets (you have to create the .css
file or use someone elses!), add figure captions, apply themes that are built
into `R Markdown` and `bookdown` and specify a table of contents.

Explore the options below to see what they do when you add them to your YAML
output at the top of your `R Markdown` document.

```md
---
title: "Your title here"
author: "Your name here"
output:
  bookdown::html_document2:
    css: styles.css
    fig_caption: yes
    theme: flatly
    toc: yes
    toc_depth: 1
bibliography: your-bib-file.bib
link-citations: yes
---
```

<div class="notice--info" markdown="1">

## Additional Resources

* <a href="https://bookdown.org/yihui/bookdown/a-single-document.html#ref-R-rticles" target="_blank">Bookdown for authoring a single report</a>
* <a href="https://bookdown.org/yihui/bookdown/citations.html" target="_blank">Bookdown for citations - full guide</a>
* <a href="https://en.wikipedia.org/wiki/BibTeX" target = "_blank">Learn more about the BibText format here. </a>

</div>
