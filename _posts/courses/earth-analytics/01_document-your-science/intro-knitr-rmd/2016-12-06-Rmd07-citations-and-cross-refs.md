---
layout: single
title: "Add citations and cross references to an R Markdown report - bookdown"
excerpt: "Learn how to use bookdown in R to add citations and cross references to your data-driven reports."
authors: ['Leah Wasser']
modified: '2017-08-15'
category: [courses]
class-lesson: ['intro-rmarkdown-knitr']
permalink: /courses/earth-analytics/document-your-science/add-citations-to-rmarkdown-report/
nav-title: 'Add citations to R Markdown'
course: "earth-analytics"
week: 0
sidebar:
  nav:
author_profile: false
comments: true
order: 7
topics:
  reproducible-science-and-programming: ['rmarkdown']
---

{% include toc title="In this lesson" icon="file-text" %}


<div class='notice--success' markdown="1">

## <i class="fa fa-graduation-cap" aria-hidden="true"></i> Learning objectives

After completing this tutorial, you will be able to:

* Add citations to an R Markdown report
* Create a `BibTex` file to store citation data to use with `R Markdown`

## <i class="fa fa-check-square-o fa-2" aria-hidden="true"></i> What you need

You need `R` and `RStudio` to complete this tutorial. Also you should have
an `earth-analytics` directory set up on your computer with a `/data`
directory with it.

* [How to setup R / RStudio](/courses/earth-analytics/document-your-science/setup-r-rstudio/)
* [Setup your working directory](/courses/earth-analytics/document-your-science/setup-working-directory/)

</div>



To begin, be sure that bookdown is already installed on your computer.



```r
# install.packages("bookdown")

```

## Introducing bookdown  

Bookdown is an R Markdown extention that can be used to create reports. In 
this lesson however we will review briefly how to use bookdown to create single
document reports.

To begin using bookdown we can add the following text to our rmarkdown document.
This tells `R` to use bookdown rather than the conventional rmarkdown. Notice below 
you use `html_document2` to create html output with inline citations.

You can select other outputs including: 

* tufte_html2(), 
* pdf_document2(), 
* word_document2(), 
* tufte_handout2(), 
* and tufte_book2()

<a href="https://bookdown.org/yihui/bookdown/a-single-document.html#ref-R-rticles" target="_blank">Learn more about output options here.</a>


```md
output:
  bookdown::html_document2: default
```

If you want - you can also apply custom stylesheets (you have to create the .css 
file or use someone elses!), add figure captions, apply themes that are built 
into `R Markdown` and `bookdown` and specify a table of contents. 

Explore the options below to see what they do when you add them to your YAML 
output at the top of your R Markdown document.

```md
output:
  bookdown::html_document2:
    css: styles.css
    fig_caption: yes
    theme: flatly
    toc: yes
    toc_depth: 1```
```

## Adding citations

Finally we can add citations to our report. To do this you need to do the following


1. Create a BibTex file containing all of the citations that you will use in your report
2. Make references to that cutation using whatever name you used to "name" your citation in the BibTex file. @R-base


```md
@Manual{anderson-2015,
  title = {Exhumation by debris flows in the 2013 Colorado Front Range storm},
  author = { S.W. Anderson and S.P. Anderson and R.S Anderson},
  journal = {Geology},
  year = {2015},
  pages = {31,94}
  url = {https://www.R-project.org/},
}

```

<a href="https://en.wikipedia.org/wiki/BibTeX" target = "_blank">Learn more about the BibText format here. </a>

To reference a citation in your document, simply use `@` and the name of the 
reference that ou wish to add. In the case above you'd use `@anderson-2015`.


<div class="notice--info" markdown="1">

## Additional resources

* <a href="https://bookdown.org/yihui/bookdown/a-single-document.html#ref-R-rticles" target="_blank">Bookdown for authoring a single report</a>
* <a href="https://bookdown.org/yihui/bookdown/citations.html" target="_blank">Bookdown for citations - full guide</a>

</div>
