---
layout: single
category: course-materials
title: "Week 1 - Getting Started with Data and R / RStudio"
permalink: /course-materials/earth-analytics/week-1/
week-landing: 1
week: 1
sidebar:
  nav:
comments: false
author_profile: false
---
{% include toc title="This Week" icon="file-text" %}


<div class="notice--info" markdown="1">

## <i class="fa fa-ship" aria-hidden="true"></i> Welcome to Week One!

Welcome to week one of Earth Analytics! In week 1 we will explore data together
in class related to the 2013 Colorado Floods. In your homework, you will set
`R` and `RStudio` setup on your laptop and learn how to create an R Markdown
document and convert it to a pdf using `knitr`.

<a class="btn btn-info btn--x-large" href="{{ site.url }}/slide-shows/4-earth-analytics-spring-2017-intro/" target= "_blank"> <i class="fa fa-youtube-play" aria-hidden="true"></i> View course overview slideshow
</a>

<a class="btn btn-info btn--large" href="https://docs.google.com/document/d/1EY9vxr3bAi81xfuIcNvjMRQqbSkXc9qoau0Pn3cahLQ/edit" target= "_blank"> View climate change google doc
</a>
<a class="btn btn-info btn--large" href="https://docs.google.com/document/d/1XuPS0oHh6lRo47sQ4XB-WSWvRQBoS2HWksNc6v_JSic/edit#
" target= "_blank"> View climate change google doc
</a>


</div>

## <i class="fa fa-pencil"></i> Homework Week 1

### 1. Readings

* <a href="https://genomebiology.biomedcentral.com/articles/10.1186/s13059-015-0850-7" target="_blank">Five selfish reasons to work reproducibly - Florian Markowetz</a>
* <a href="http://journals.plos.org/plosbiology/article?id=10.1371/journal.pbio.1002303" target="_blank"> Computing Workflows for Biologists: A Roadmap</a>
* <a href="http://science.sciencemag.org/content/330/6006/916" target="_blank">Earth System Science for Global Sustainability: Grand Challenges (read the full article)</a>


### 2. Watch flood video
First, watch this video to learn more about the 2013 Colorado floods and some
of the data that can be used to better understand the drivers and impacts of those
floods.

<iframe width="560" height="315" src="https://www.youtube.com/embed/IHIckvWhwoo" frameborder="0" allowfullscreen></iframe>

#### Before / after google earth fly through

<iframe width="560" height="315" src="https://www.youtube.com/embed/bUcWERTM-OA?rel=0&loop=1" frameborder="0" allowfullscreen></iframe>

### 3. Review open science slide show
Note: these were also linked in the lessons below.

<a class="btn btn-info" href="{{ site.url }}/slide-shows/share-publish-archive/" target= "_blank"> <i class="fa fa-youtube-play" aria-hidden="true"></i>
View Slideshow: Share, Publish & Archive Code & Data</a>

### 4. Review lessons
The second part of your homework assignment is to review the homework lessons (see links
on the left hand side of this page).
Following the lessons, setup `R`, `RStudio` and a
`working directory` that will contain the data we will use for week one and the
rest of the semester on your laptop.

Once everything is setup, complete the second set of lessons which walk you
through creating R markdown documents and knitting them to `.pdf` format. If you
already know `rmarkdown`, be sure to review the lessons anyway - particularly
the ones about file organization and why we use this workflow in science.

<i class="fa fa-star" aria-hidden="true"></i> **Important:** Review
ALL of the lessons and have your computer setup BEFORE class begins next week.
You will be behind if these things are not setup / complete before week 2.
{: .notice }

### 5. Complete assignment below

After you have reviewed the lessons above, complete the assignment below.
Submit your `.pdf` document and `R Markdown` document to the D2L course drop box
by **Wed 25 January 2017 at NOON Mountain Time.**

<!-- start homework activity -->


<div class="notice--warning" markdown="1">

## <i class="fa fa-pencil-square-o" aria-hidden="true"></i> Homework Submission: Create A Report Using Knitr & RMarkdown

* Create a new rmarkdown `.Rmd` file in `Rstudio`. Name the file:
`yourLastName-firstInitial-week1.Rmd` example: `wasser-l-week1.Rmd`

* Add an `author:` line to the `YAML` header at the top of your `.Rmd` document.
* Give your file an appropriate title. Suggestion: `Earth Analytics Spring 2017: Homework - Week 1`
* At the top of the rmarkdown document (BELOW THE YAML HEADER), add some text
that describes:

   * What an `.Rmd` file is
   * How you can use `knitr` in `R` and what it does.
   * Why using `Rmarkdown` to create reports can be helpful to both you and your colleagues that you work with on a project.

* Create a new CODE CHUNK
* Copy and paste the code BELOW into the code chunk that you just created.
* Below the code chunk in your `rmarkdown` document, add some TEXT that describes what the plot that you created
shows - interpret what you see in the data.
* Finally, in your own words, summarize what you think the plot shows / tells us about
the flood and also how the data that produced the plot were likely collected. Use the video
about the Boulder Floods as a reference when you write this summery.

BONUS: If you know `R`, clean up the plot by adding labels and a title. Or better
yet, use `ggplot2`!

</div>


```r

# load the ggplot2 library for plotting
library(ggplot2)

# download data from figshare
# note that we are downloaded the data into your
download.file(url = "https://ndownloader.figshare.com/files/7010681",
              destfile = "data/boulder-precip.csv")

# import data
boulder.precip <- read.csv(file="data/boulder-precip.csv")

# view first few rows of the data
head(boulder.precip)

# when we download the data we create a dataframe
# view each column of the data frame using it's name (or header)
boulder.precip$DATE

# view the precip column
boulder.precip$PRECIP

# q plot stands for quick plot. Let's use it to plot our data
qplot(x=boulder.precip$DATE,
      y=boulder.precip$PRECIP)

```

<figure class="half">
<a href="/images/rfigs/course-materials/earth-analytics/week-1/intro-knitr-rmd/2016-12-06-Rmd05-knitr/render-plot-1.png">
<img src="/images/rfigs/course-materials/earth-analytics/week-1/intro-knitr-rmd/2016-12-06-Rmd05-knitr/render-plot-1.png" alt="example of the plot">
</a>
<figcaption>
If your code ran properly, the resulting plot should look like this one.
</figcaption>
</figure>


<figure>
<a href="/images/course-materials/earth-analytics/week-1/setup-r-rstudio/r-markdown-wk-1.png">
<img src="/images/course-materials/earth-analytics/week-1/setup-r-rstudio/r-markdown-wk-1.png" alt="R markdown example image.">
</a>
<figcaption>
Your rmarkdown file should look something like the one above (with your own text
added to it). Note that the image above is CROPPED at the bottom. Your rmarkdown
file will have more code in it.
</figcaption>
</figure>

### Troubleshooting: missing plot

If the code above did not produce a plot, please check the following:

#### Check your working directory

If the path to your file is not correct, then the data won't load into `R`.
If the data don't load into `R`, then you can't work with it or plot it.

To figure out your current working directory use the command: `getwd()`
Next, go to your finder or file explorer on your computer. Navigate to the path
that `R` gives you when you type `getwd()` in the console. It will look something
like the path example: `/Users/your-username/documents/earth-analytics`

```r
# check your working directory
getwd()

## [1] "/Users/lewa8222/documents/earth-analytics"
```

In the example above, note that my USER directory is called `lewa8222`. Yours
is called something different. Is there a `data` directory within the earth-analytics
directory?

<figure>
<a href="/images/course-materials/earth-analytics/week-1/setup-r-rstudio/data-dir-wk-1.png">
<img src="/images/course-materials/earth-analytics/week-1/setup-r-rstudio/data-dir-wk-1.png" alt="data directory example image.">
</a>
<figcaption>
Your working directory should contain a `/data` directory.
</figcaption>
</figure>

If not, review the [working directory lesson](/course-materials/earth-analytics/week-1/setup-working-directory/)
to ensure your working directory is SETUP properly on your computer and in `RStudio`.


<!-- end homework activity -->
