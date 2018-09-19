---
layout: single
category: courses
title: "Document Your Science Using R Markdown and R"
permalink: /courses/earth-analytics/document-your-science/
modified: '2018-07-30'
week-landing: 1
week: 1
sidebar:
  nav:
comments: false
author_profile: false
course: "earth-analytics"
module-type: 'session'
---

{% include toc title="This Week" icon="file-text" %}


<div class="notice--info" markdown="1">

## <i class="fa fa-ship" aria-hidden="true"></i> Welcome to Week One!

Welcome to week {{ page.week }} of Earth Analytics! In week 1 you will explore data
related to the 2013 Colorado Floods. In your homework, you will get
`R` and `RStudio` set up on your laptop and learn how to create an `R Markdown`
document and convert it to a pdf using `knitr`. Finally you will create a short
report after reading articles on the 2013 Colorado Floods.

<a class="btn btn-info btn--x-large" href="{{ site.url }}/slide-shows/4-earth-analytics-course-intro/" target= "_blank"> <i class="fa fa-youtube-play" aria-hidden="true"></i> View course overview slideshow
</a>

<a class="btn btn-info btn--large" href="https://docs.google.com/document/d/1EY9vxr3bAi81xfuIcNvjMRQqbSkXc9qoau0Pn3cahLQ/edit" target= "_blank"> View climate change google doc (for CU students only)
</a>
<a class="btn btn-info btn--large" href="https://docs.google.com/document/d/1XuPS0oHh6lRo47sQ4XB-WSWvRQBoS2HWksNc6v_JSic/edit#
" target= "_blank"> View flooding change google doc (for CU students only)
</a>


</div>

## <i class="fa fa-pencil"></i> Homework Week 1

## Due: **Friday 8 September 2017 by 8PM Mountain Time**

### 1. Readings

### Open Science Readings
Read the open science related articles below.

1. <a href="https://phys.org/news/2016-08-science-movement.html" target="_blank">The value of open science</a>
1. <a href="https://genomebiology.biomedcentral.com/articles/10.1186/s13059-015-0850-7" target="_blank">Five selfish reasons to work reproducibly - Florian Markowetz</a>
1. <a href="http://journals.plos.org/plosbiology/article?id=10.1371/journal.pbio.1002303" target="_blank"> Computing Workflows for Biologists: A Roadmap</a>

<a class="btn btn-info" href="{{ site.url }}/slide-shows/share-publish-archive/" target= "_blank"> <i class="fa fa-youtube-play" aria-hidden="true"></i>
View Slideshow: Share, Publish & Archive Code & Data</a>

### Flood Readings
Read the following articles and listen to the 7 minute interview with
Suzanne Anderson (faculty here at CU Boulder).

1. <a href="http://journals.ametsoc.org/doi/full/10.1175/BAMS-D-13-00241.1" target="_blank">Gochis, D. et al. (2014): The great Colorado flood of September 2013. Bull. Amer. Meteor. Soc. 96, 1461-1487, doi:10.1175/BAMS-D-13-00241.1.</a>

2. <a href="ftp://rock.geosociety.org/pub/GSAToday/gt1410.pdf" target="_blank">Coe, J.A. et al (2014): New insights into debris-flow hazards from an extraordinary event in the Colorado Front Range. GSA Today 24 (10), 4-10, doi: 10.1130/GSATG214A.1.</a>

3. <a href="http://geology.gsapubs.org/content/early/2015/03/27/G36507.1" target="_blank">Anderson, S.W., Anderson, S.P., & Anderson, R.S. (2015). Exhumation by debris flows in the 2013 Colorado Front Range storm. Geology 43 (5), 391-394, doi:10.1130/G36507.1. </a>

4. Read the short article and **listen to the 7 minute interview with Suzanne Anderson**: To listen - click on the "<i class="fa fa-volume-up" aria-hidden="true"></i>
Listen" icon on the page
<a href="http://www.cpr.org/news/story/study-2013-front-range-floods-caused-thousand-years-worth-erosion" target="_blank">Study: 2013 Front Range floods caused a thousand year's worth of erosion</a>

### 2. Watch Flood Video
Watch this video to learn more about the 2013 Colorado floods and some
of the data that can be used to better understand the drivers and impacts of those
floods.

<iframe width="560" height="315" src="https://www.youtube.com/embed/IHIckvWhwoo" frameborder="0" allowfullscreen></iframe>

#### Before and After Google Earth Fly Through

<iframe width="560" height="315" src="https://www.youtube.com/embed/bUcWERTM-OA?rel=0&loop=1" frameborder="0" allowfullscreen></iframe>

### 3. Review Lessons
After you've read the readings and watched the videos, complete the homework
assignment below. Review the **Set Up R** lessons. (see links
on the left hand side of this page).
Following the lessons, setup `R`, `RStudio` and a
`working directory` that will contain the data you will use for the entire course.
IMPORTANT: if you working directory is not setup right - you won't be able to
follow along in class. Also you won't be able to test your code when you submit assignments
to give you partial credit!

Once everything is setup, review the second set of lessons (R Markdown intro) which walk you
through creating R Markdown documents and knitting them to `.html` format. If you
already know `rmarkdown`, be sure to review the lessons anyway - particularly
the ones about file organization and why you use this workflow in science.

<i class="fa fa-star" aria-hidden="true"></i> **Important:** Review
ALL of the lessons and have your computer setup BEFORE class begins next week.
You will be behind if these things are not setup / complete before week 2.
{: .notice--success }

### 4. Complete Assignment Below

After you have reviewed the lessons above, complete the assignment below.
Submit your `.html` document and `R Markdown` document to the D2L course drop box
by **Friday 8 September 2017 by 8PM Mountain Time.**

<!-- start homework activity -->

<div class="notice--warning" markdown="1">

## <i class="fa fa-pencil-square-o" aria-hidden="true"></i> Homework Submission: Create A Report Using Knitr & RMarkdown

## 1. Create R Markdown file
* Create a new rmarkdown `.Rmd` file in `Rstudio`. Name the file:
`yourLastName-firstInitial-week01.Rmd` example: `wasser-l-week01.Rmd`
    * Save your `.Rmd` file in the ``\earth-analytics\` working directory that you created for this class using the lessons. IMPORTANT: do not save the `.Rmd` file in the `\data` directory. Your code won't run!
    * Add an `author:` line to the `YAML` header at the top of your `.Rmd` document.
    * Make sure the YAML has a `date:` element.
    * Add a `title:` that represents the contents of your report. Example: `2013 Colorado floods - earth analytics fall 2017`

## 2. Write Up the Following

At the top of the `R Markdown` document (BELOW THE YAML HEADER), writeup the following (Use the readings and video assigned above to answer these questions):

1. Write a 1 page overview of the events that lead to the flooding that occurred in 2013. In this writeup, be sure to explain how the floods impacts people in Colorado. NOTE: this text will be used in the final report that you create about the 2013 floods so the better this text is now, the less you will have to do later! Read the articles and craft this write up carefully. Be sure to cite at least 3 of the articles above (or others that you find) in your write up.
1. At the bottom of your report, write 1-2 paragraphs that describe:
     * What open science is and why it is important
     * How approaches including using `R Markdown` can be helpful to both you and your colleagues that you work with on a project and to following open science principles in general.

## 3. Add Code to Your Document

* Create a new CODE CHUNK.
* Copy and paste the code BELOW into the code chunk that you just created.
* Below the code chunk in your `R Markdown` document, add some TEXT that describes what the plot that you created
shows - interpret what you see in the data.

BONUS: If you know `R`, clean up the plot by adding labels and a title. Or better
yet, use `ggplot2`!

</div>



```r

# load the ggplot2 library for plotting
library(ggplot2)

# download data from figshare
# note that you are downloading the data into your data directory
download.file(url = "https://ndownloader.figshare.com/files/7010681",
              destfile = "data/boulder-precip.csv",
              method = "libcurl")

# if the code above doesn't allow you to download the data, remove the method =
# "libcurl" argument! Also note that you may get a warning that you are not able to
# download the data twice. That is ok!

# import data
boulder_precip <- read.csv(file="data/boulder-precip.csv")

# view first few rows of the data
head(boulder_precip)
##     X       DATE PRECIP
## 1 756 2013-08-21    0.1
## 2 757 2013-08-26    0.1
## 3 758 2013-08-27    0.1
## 4 759 2013-09-01    0.0
## 5 760 2013-09-09    0.1
## 6 761 2013-09-10    1.0

# when you download the data you create a `data.frame`
# view each column of the data frame using it's name (or header)
boulder_precip$DATE
##  [1] "2013-08-21" "2013-08-26" "2013-08-27" "2013-09-01" "2013-09-09"
##  [6] "2013-09-10" "2013-09-11" "2013-09-12" "2013-09-13" "2013-09-15"
## [11] "2013-09-16" "2013-09-22" "2013-09-23" "2013-09-27" "2013-09-28"
## [16] "2013-10-01" "2013-10-04" "2013-10-11"

# view the precip column
boulder_precip$PRECIP
##  [1] 0.1 0.1 0.1 0.0 0.1 1.0 2.3 9.8 1.9 1.4 0.4 0.1 0.3 0.3 0.1 0.0 0.9
## [18] 0.1

# qplot stands for quick plot. It is a function in the ggplot2 library.
# Let's use it to plot our data
qplot(x = boulder_precip$DATE,
      y = boulder_precip$PRECIP)
```

<img src="{{ site.url }}/images/rfigs/courses/earth-analytics/01-document-your-science/2017-01-01-week-01-document-your-science/student-example-code-1.png" title="Plot of precip over time that a student should see as output after running code." alt="Plot of precip over time that a student should see as output after running code." width="90%" />


If your code ran properly, the plot output should look like the image above.



<figure>
<a href="/images/courses/earth-analytics/document-your-science/setup-r-rstudio/r-markdown-wk-1.png">
<img src="/images/courses/earth-analytics/document-your-science/setup-r-rstudio/r-markdown-wk-1.png" alt="R Markdown example image.">
</a>
<figcaption>
Your `R Markdown` file should look something like the one above (with your own text
added to it). Note that the image above is CROPPED at the bottom. Your `R Markdown`
file will have more code in it.
</figcaption>
</figure>

### Troubleshooting: Missing Plot

If the code above did not produce a plot, please check the following:

#### Check Your Working Directory

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
<a href="/images/courses/earth-analytics/document-your-science/setup-r-rstudio/data-dir-wk-1.png">
<img src="/images/courses/earth-analytics/document-your-science/setup-r-rstudio/data-dir-wk-1.png" alt="data directory example image.">
</a>
<figcaption>
Your working directory should contain a `/data` directory. If it does not, then
the above code won't run as it downloads the data to your /data directory!
</figcaption>
</figure>

If not, review the [working directory lesson](/courses/earth-analytics/document-your-science/setup-working-directory/)
to ensure your working directory is SETUP properly on your computer and in `RStudio`.


## Class Participation - Flood Diagram Activity

While attendance is not explicitly tracked, participation in this course counts
towards your grade. This week, please be sure that your name is associated with
one of the diagrams posted in the <a href="https://piazza.com/class/j6e3f29h57k694?cid=10" target = "_blank">piazza forum</a>. In class you worked in groups so it is ok if multiple
people are associated with one diagram. Just be sure your name is there so you
get credit and if it isn't - please edit your post and add your names above
the image!
<!-- end homework activity -->

<div class="notice--info" markdown="1">

## Grade Rubric

Your assignment will be graded using the rubric below.
Remember as always - NO LATE ASSIGNMENTS will be accepted. Please do not ask.
Submit what you  have done - as is - ON TIME!

### R Markdown Report Syntax & Code (20%)

| Full credit                                          |  | No credit |
|:-----------------------------------------------------|:-|:----------|
| HTML and RMD submitted                                |  |           |
| YAML contains title, author and date                 |  |           |
| File is named with last name-first initial week 1    |  | |         |
| ===                                                  |  |           |
| Grammar and spelling is excellent - no misspellings  |  |           |


### R Markdown Report Code Runs (20%)

| Full credit                                                    |  | No credit |
|:---------------------------------------------------------------|:-|:----------|
| Code chunk contains code and runs (a correct plot is produced) |  |           |
| ===                                                            |  |           |
| Code chunk is formatted correctly                              |  |           |

### R Markdown Report Writeup (60%)

| Full credit                                                                                                                    |  | No credit |
|:-------------------------------------------------------------------------------------------------------------------------------|:-|:----------|
| 1 page overview of the flood is thoughtful, accurately describes the flood events and location and clearly references readings |  |           |
| Flood report identifies the drivers and impacts of the flood                                                                   |  |           |
| Flood report discusses the elements that triggered the 2013 colorado floods                                                    |  |           |
| Open science writeup references readings                                                                                       |  |           |
| ===                                                                                                                            |  |           |
| Open science writeup defines open science correctly and documents its importance following the readings                        |  |           |

</div>
