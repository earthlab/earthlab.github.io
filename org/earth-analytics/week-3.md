---
layout: single
category: course-materials
title: "Week 3 - LiDAR Data "
permalink: /course-materials/earth-analytics/week-3/
week-landing: 3
week: 3
sidebar:
  nav:
comments: false
author_profile: false
---

{% include toc title="This Week" icon="file-text" %}


## IMPORTANT NEED TO ADD A LESSON ON ADDING IMAGES TO A REPORT

<div class="notice--info" markdown="1">

## <i class="fa fa-ship" aria-hidden="true"></i> Welcome to Week {{ page.week }}!

Welcome to week {{ page.week }} of Earth Analytics! In week 3 we will learn about
Light Detection and Ranging (LiDAR) data. We will cover using point cloud data and
lidar rasters in `R` and will explore using QGIS - a free, open-source GIS tool.

Your final 2013 Colorado flood report assignment is below. Read the assignment
carefully and make sure you've completed all of the steps and followed all of the
guidelines. Use all of the class and homework lessons that we've reviewed in the
first few weeks to help you complete the assignment.
</div>


## Part 1. Readings

Read the following articles and listen to the 7 minute interview with
Suzanne Anderson (faculty here at CU Boulder).

Read the following articles. They will help you write your report.

1. <a href="http://journals.ametsoc.org/doi/full/10.1175/BAMS-D-13-00241.1" target="_blank">Gochis, D., Schumacher, R., Friedrich, K., Doesken, N., Kelsch, M., Sun, J., Ikeda, K., Lindsey, D., Wood, A., Dolan, B., Matrosov, S., Newman, A., Mahoney, K., Rutledge, S., Johnson, R., Kucera, P., Kennedy, P., Sempere-Torres, D., Steiner, M., Roberts, R., Wilson, J., Yu, W., Chandrasekar, V., Rasmussen, R., Anderson, A., & Brown, B. (2014):  The great Colorado flood of September 2013.  Bull. Amer. Meteor. Soc. 96, 1461-1487, doi:10.1175/BAMS-D-13-00241.1.</a>

2. Coe, J.A., Kean, J.W., Godt, J.W., Baum, R.L., Jones, E.S., Gochis, D.J., & Anderson, G.S. (2014):  New insights into debris-flow hazards from an extraordinary event in the Colorado Front Range.  GSA Today 24 (10),  4-10, doi: 10.1130/GSATG214A.1.

3. Anderson, S.W., Anderson, S.P., & Anderson, R.S. (2015). Exhumation by debris flows in the 2013 Colorado Front Range storm. Geology 43 (5), 391-394, doi:10.1130/G36507.1. 

4. Read the short article and **listen to the 7 minute interview with Suzanne Anderson**: To listen - click on the "<i class="fa fa-volume-up" aria-hidden="true"></i>
Listen" icon on the page
<a href="http://www.cpr.org/news/story/study-2013-front-range-floods-caused-thousand-years-worth-erosion" target="_blank">Study: 2013 Front Range floods caused a thousand year's worth of erosion</a>


<div class="notice--warning" markdown="1">

## <i class="fa fa-pencil-square-o" aria-hidden="true"></i> Week 3 Assignment

### Produce a final report

Create a new R markdown document. Name it: lastName-firstInitial-floodreport.rmd
Carefully compose a report that summarized the 2013 Colorado flood event. When you
are done with your report, use knitr to convert it to PDF. You will submit both
the .Rmd file and the .pdf file.

Include the following parts in your report:

###  Background / overview of the flood

Include the following background in your report:

1. Where and when the disturbance event occured.
2. Discussion of the drivers that yielded the flooding in Boulder and discussion of the impacts of the flood.
3. Plots that show precipitation and discharge data during the flood period and around the flood period. Be sure to:
    * Discuss where the data came from and what it shows.
    * Discuss patterns that are evident in the data and how precipitation is or isn't linked to discharge.
    * Interpret your plots
4. Plots of lidar data that show before / after differences in elevation and tree cover.

### Summary / Discussion
A summary of the flood events, how drivers and impacts were quantified and
and what the data show you about those drivers and impacts.

### Important:

* Clearly state the source of each dataset that you use.
* Analyze / interpret each plot that you produce in your report. State what the source of the data are and what the plot shows as a driver or impact of the 2013 flood events.
* Clearly document that steps that you took to process the data by commenting your code or in the text of your report itself as it makes sense.
* Cite articles that you read or other sources of information that you used to write your report.
* Use clean coding practices - this includes comments, variable names that are informative, clean code spacing, following Hadley Wickham's code style guide.
* Spell check your report and check grammar.
* All plots should be clearly labeled with titles, and x and y axis labels are it makes sense. (Your map of lidar data doesn't need x and y labels).
* Include images as they make sense. Be sure to cite any graphics that you use that are not yours


### Deadline
Submit your report in both .Rmd and .PDF format by xXX @ 5pm.
</div>
