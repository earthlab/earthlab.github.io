---
layout: single
category: course-materials
title: "Earth Analytics Final Project"
permalink: /course-materials/earth-analytics/final-project/
sidebar:
  nav: earth-analytics-2017
comments: false
author_profile: false
---

{% include toc title="This Week" icon="file-text" %}


<div class="notice--info" markdown="1">

## <i class="fa fa-ship" aria-hidden="true"></i> About the final project

The final project in this course includes:

1. **A 12-15 minute group presentation (20%):** The structure of the presentation is discussed below.
2. **An individual report (20%):** written in `Rmarkdown` and submitted in either `.html` or `.pdf` format
</div>


<div class="notice--warning" markdown="1">

## <i class="fa fa-pencil-square-o" aria-hidden="true"></i> Final project

Select a science question, phenomenon or event that you wish to address / better
understand. Your topic can be related to something we've covered in class or to
something completely different! You must be able to ask and answer an explicit science
question using data that you collect / download / find (not data that we have
used in this course).

You will research the topic that you select finding papers and other documentation
about it. This research will be the basis of the background of your presentation
and also of the literature review for your final paper. You will also find *atleast*
2 distinct data types that are from different sources. A source is defined as a
collection method / type or sensor so for example the Landsat sensor is type of data.
NLCD and NDVI could both come from Landsat. That represents one data source. You could
however use Landsat and MODIS as two separate sources given the data come from
two different sensors. The data should be used to answer the question that you
select for your project.

The final group presentations will occur on the final day of class: **Wednesday 3 May 2017 during class.** IMPORTANT: Submit your final presentation to D2L PRIOR to class
on 3 May 2017.

The final individual report is due the following week during finals: **Submit your html / pdf file and your .rmd file to D2L by Tuesday 9 May 2017 @ 5PM.**

* NOTE 1: we expect groups to be the same as the groups for the mid-term. However it
is OK if you changed your topic, data sources, questions, etc given feedback on
the mid term presentation.
* NOTE 2: You can decide whether you want to submit your report in `.html` vs `.pdf` format. If you want to include an interactive graphic you will need to use `.html` format!
</div>

## Final group presentation (20%)
For your final, as a group, you will present the following:

* The study area that you selected for your project. Be sure to include a map and context map that clearly shows where the study area is. Create your map using R.
* The science topic that you selected for your project.
* Why the topic / event / phenomenon is important (why should the class care) - this should include some background that you develop via a literature review.  Have other people studied it? What did they find?
* Plots showing *atleast* 2 different types of data from different sources that allow you to answer questions about the topic.
* Explanation of where you got the data (the source).
* Explanation of how you processed the data in `R`.
* Results that you found by looking at the data.
* Challenges that you faced in working with the data.
* Any relevant conclusions.

This is a science presentation so be sure to clearly articulate the significance
of your project.

#### Important:

* You have no more than **12-15 minutes** to present your project to the class.
* Each member in each group needs to present!
* You can use any presentation tool that you wish for your presentation. Powerpoint, rpres, pdf, etc. As long as the entire class can see the final presentation and you can SUBMIT IT to D2l.
* Groups should be 2-3 people. It is OK if you decide you really want to work on your own but we prefer (and you will have a better project) if you work with others.
* You can reach out to the the experts who have presented in this course for guidance / with questions if you want!
  * Chris Crosby (lidar - UNAVCO / Open Topography)
  * Mariela Perignon (floods and modeling - CSDMS)
  * Megan Cattau (fire - Earth Lab)
  * Lise (social media - Earth Lab)

****

## Individual Final Report (20%)
To complement your final presentation, you will also create a  report using
rmarkdown and knitr. This report should be structured as a scientific paper /
white paper. For your report, select a component of the project that you are most
interested in. Perform a literature review on that topic. In your report be sure
to cite in your text *atleast* **2 peer reviewed journal articles** about that
topic and then **2 other sources** that can be peer reviewed or not peer review
including blogs, newspaper articles, etc. Also be sure to include data driven plots
and maps as appropriate. Your report should include:

1. An introduction that includes a map of the study area created in `R`.
2. Literature review that references to **atleast** 2 scientific (peer reviewed) papers and 2 non peer reviewed sources on the topic.
2. An written overview of the methods that describes
  * The data that you used
  * The source of the data
  * How the data were processed in `R`.
3. Results - *atleast* 4 maps / plots that answer the question that you decided to address or the phenomenon that you decided to explore using data.
4. Summary text - what did you learn about your topic? What did the data tell you?
5. References - list all references that you used to write your report at the end. IMPORTANT: you should also reference your data - where did it come from?!

The report should be written INDEPENDENTLY. We will check for this when grading.
However it is OK if you decide to share code with your colleagues given you may
all tackle different parts of the data when you work on your project. It is also
ok if you share interesting articles and other sources of information about the
topic.

The writing of each report however needs to be your own.

The report should also include the code that you used to create maps and process
any data used. You can hide this code using code chunk arguments but be sure to
clearly document your process as we have been discussing in class all semester!
We will grade your final pdf / html document and the code.


#### IMPORTANT
* Be sure all plots / maps have clearly labeled x and y axes (as apprpriate) and legends
* All plots / maps should also include a caption that describes what hte data show. You can add the caption in whatever way you'd like to. It is ok if you write your caption using fig.cap= OR if you prefer, add the caption in the markdown text of your document.
* Spell check / grammar check your paper BEFORE YOU SUBMIT. this is worth 20% of your grade. Take time to make sure it's well written!
* Hide your code in the .Rmd document UNLESS you feel like your methods are important to call out. (for example you may decide to show some of your methods in the methods section of the report).
* Turn off warnings and other messages so they do not appear in your final rendered report.
* Start early - make sure your reports renders to pdf or html WELL BEFORE the assignment is due!  

## Graduate students - additional report elements
In addition to the requirement above, graduate students should develop

1. A more robust literature review on the selected topic. This literature review
should include 4 or more peer reviewed references and should be 1.5 to 2 pages in length (~700 words). We won't be counting words, we
simply want you to create a robust literature review that is of the quality of a
review that you would include in a paper.
2. An abstract that provides the big picture of the topic that you selected. This abstract should follow the format of an abstract that your would write for a journal submission in your field.


## Submission

* **GROUP PRESENTATION:** The final group presentations will occur on the final
day of class: **Wednesday 3 May 2017 during class.** IMPORTANT: Submit your final presentation to the GROUP DROP
BOX on D2L PRIOR to class on 3 May 2017.

* **FINAL INDEPENDENT REPORT:** The final individual report is due the following week during finals: **Submit your html / pdf file and your .rmd file to D2L by Tuesday 9 May 2017 @ 5PM.**
