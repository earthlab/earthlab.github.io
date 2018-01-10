---
layout: single
category: course-materials
title: "Final Project- Earth Analytics Course - GEOG 4563 / 5563"
nav-title: "Final Project"
permalink: /courses/earth-analytics/final-project/
module-type: 'overview'
comments: false
author_profile: false
overview-order: 4
week-landing: 0
course: "earth-analytics"
sidebar:
  nav:
---

{% include toc title="This Week" icon="file-text" %}


<div class="notice--info" markdown="1">

## <i class="fa fa-ship" aria-hidden="true"></i> About the Final Project

The final project in this course includes:

1. **A 10 minute group presentation (10%):** The structure of the presentation is discussed below.
2. **An individual report (20%):** Written in `R markdown` and submitted in either `.html` or `.pdf` format.
</div>


<div class="notice--warning" markdown="1">

## <i class="fa fa-pencil-square-o" aria-hidden="true"></i> Earth Analytics Course Final Project

### 1. Select a Science Question, Phenomenon or Event
Select a topic that you wish to address and better understand. Your topic can be 
related to something covered in class or something completely different! 
You must be able to ask and answer an explicit science question using data that you 
collect, download and find (not data that you have been given to use in this course).

### 2. Research Your Topic
Find papers and other documentation on your selected topic. Research your topic 
and craft a background section of your presentation that is founded in science. 
You will also use this to write your literature review for your final paper.

### 3. Find Data
Find *at least* 2 distinct datasets that are from different sources.
A source is defined as a collection method, type or sensor so for example the
Landsat sensor is a type of data. NDVI and NBR derived from Landsat are still data
from one source. You could however use Landsat and MODIS as two separate sources 
given the data come from two different sensors. You should use the data to answer 
the question that you select for your project.

### What to Submit & When

The final group presentations will occur during the last two weeks of class.
**IMPORTANT:** Submit your final presentation to D2L by 9am this day. I will
download all presentations to my computer. DO NOT EMAIL ME CHANGES TO YOUR
PRESENTATION after 9AM!

The final individual report is due the following week during finals:
**Submit your html / pdf file and your .Rmd file to D2L by Monday 18 December
2017 @ 9AM.**

* **NOTE 1:** I expect groups to be the same as the groups for the mid-term. However it is OK if you changed your topic, data sources, questions, etc. given feedback on the mid-term presentation.
* **NOTE 2:** You can decide whether you want to submit your report in `.html` vs `.pdf` format. If you want to include an interactive graphic you will need to use `.html` format!
</div>

## Final Group Presentation
For your final, as a group, you will present the following:

* The study area that you selected for your project. Be sure to include a map and context map that clearly shows where the study area is. Create your map using `R`.
* The science topic that you selected for your project.
* Why the topic, event or phenomenon is important (why should the class care). This should include some background that you develop via a literature review. Have other people studied it? What did they find?
* Plots showing *at least* 2 different types of data from different sources that allow you to answer questions about the topic.
* Explanation of where you got the data (the source).
* Explanation of how you processed the data in `R`.
* Results that you found by looking at the data.
* Challenges that you faced in working with the data.
* Any relevant conclusions.

This is a science presentation so be sure to clearly articulate the significance
of your project.

#### Important:

* You have exactly **10 minutes** to present your project to the class.
* Each member in each group needs to present!
* You can use any presentation tool that you wish for your presentation (powerpoint, rpres, pdf, etc.), as long as the entire class can see the final presentation and you can submit it to D2L for grading.
* Groups should be 2-3 people. It is OK if you decide you really want to work on your own but I prefer (and you will have a better project) if you work with others.
* You can reach out to the the experts who have presented in this course for guidance if you want!
  * Matthew Rossi (floods - Earth Lab)
  * Megan Cattau (fire - Earth Lab)
  * Lise (social media - Earth Lab)

****

## Individual Final Report

To complement your final presentation, create a report using `R markdown`. This report 
should be structured as a scientific paper or white paper. For your report, select 
a component of the project that you are most interested in. Perform a literature 
review on that topic. In your report be sure to cite in your text *at least* 
**2 peer reviewed journal articles** about that topic and then **2 other sources** 
(peer reviewed or not peer reviewed) including blogs, newspaper articles, 
etc. Also be sure to include data driven plots and maps as appropriate. Your report 
should include:

1. An **Introduction** that includes a map of the study area created in `R`.
2. Literature review that references to **at least** 2 scientific (peer reviewed) papers and 2 other sources on the topic.
2. A **Methods overview** that describes
  * The data that you used
  * The source of the data
  * How the data were processed in `R`.
3. **Results** - *at least* 4 maps and/or plots that answer the question that you decided to address or the phenomenon that you decided to explore using data.
4. **Summary** text - what did you learn about your topic? What did the data tell you?
5. **References** - list all references that you used to write your report (in text citations) at the end. **Don't forget to reference your data.**

The report should be written independently, however it is ok if you decide to
share code with your group members given you may all tackle different parts of
the data when you work on your project. It is also ok if you share interesting
articles and other sources of information about the topic.

**The writing of each report needs to be your own.**

The report should also include the code that you used to create maps and process
any data used. You can hide this code using code chunk arguments but be sure to
clearly document your process as you have been learning in class all semester!
We will grade your final pdf / html document and the code.

#### Report Notes

* Be sure all plots and maps have clearly labeled x and y axes (as appropriate) and legends.
* All plots / maps should also include a caption that describes what the data show. You can add the caption using `fig.cap =` OR if you prefer, add the caption in the markdown text of your document.
* **Spell and grammar check your paper BEFORE YOU SUBMIT**. This is worth 20% of your grade. Take time to make sure it's well written!
* Hide your code in the `.Rmd` document UNLESS you feel like your methods are important to call out (for example you may decide to show some of your methods in the methods section of the report).
* Turn off warnings and other messages so they do not appear in your final rendered report.
* Do not include **any** code in your submission that is not crucial to creating the output plots and analysis.
* Makre sure that the `.Rmd` (or `.ipynb`) file runs (we can hit knit in `Rstudio` and everything will work).
* Start early - make sure your reports renders to pdf or html WELL BEFORE the assignment is due!
* Proof your output **.html** file BEFORE your submit it.

## Graduate Students - Additional Report Elements
In addition to the requirement above, graduate students should include:

1. A more robust literature review on the selected topic. This literature review
should include 4 or more peer reviewed references and should be 1.5 to 2 pages in length (~700 words).
2. An abstract that provides the big picture of the topic that you selected. This abstract should follow the format of an abstract that your would write for a journal submission in your field.

## Submission

* **GROUP PRESENTATION:** The final group presentations will occur on the final
day of class. Submit your final presentation to the group D2L Drop Box **by
9AM on the class day that you present**. )

* **FINAL INDEPENDENT REPORT:** The final individual report is due on Monday
of finals week. **Submit your html / pdf file and your `.Rmd` file to D2L by Monday 18 Dec 2017 @ 9AM.**

* **DATA:** Please submit your data to D2L as a group to D2L by Monday 18 Dec 2017 @ 9AM. If you are using a specific dataset that you are not able to share, OR a data set that is particularly large, please shoot us a note and we will figure out an alternative! If the data are large, submitting an intermediate output that is smaller and will allow us to run your analysis is an option.

***

## Presentation Rubric

#### Science (50%)

| Full Credit | No Credit  |
|:----|----|
| The science question / topic is thoughtfully presented |  |
| The **importance of the project topic to those in the room** (the specific audience) is clearly articulated. Why should we (the earth analytics class) care?  |  |
| Results of data analysis are clearly articulated. (If the student presents the week prior their results may not be complete, thus expected results are articulated instead  | |
| The methods that clarify how the data were processed are clearly articulated as they relate to the science question / topic. | |
|===
| Conclusions associated with data analysis are clearly articulated and thoughtful. Conclusions consider the data analysis as presented. (If the student presents a week prior, conclusions may not be complete, but expected findings can be discussed.)| |


#### Data (25%)

| Full Credit | No Credit  |
|:----|----|
| 2 specific data sources are identified in the presentation  | |
| Each data source identified is described: how it's collected & where you downloaded it from or accessed it | |
| How the data were used to address the topic is clearly articulated | |
| Sources of uncertainty associated with the data and/or analysis are clearly articulated in the presentation ||
| The x, y axes, legends, associated units and other elements of each plot are clearly explained and labeled.  | |
|===
| An `R` generated study area map is included in the presentation to clearly articulate the study area.  | |


#### Presentation (20%)

| Full Credit | No Credit  |
|:----|----|
| Presentation is clear, concise and thoughtfully pulled together |  |
| Presenters are well prepared | |
| All students introduce themselves and their background (not just their names, but their major OR area of study) |  |
| The project topic is **clearly** and **concisely** introduced  | |
| Everyone in the group presents | |
|===
| The presentation spans no more than **10 minutes** (group will be stopped at 10 minutes). | |


#### Slide Presentation (5%)

| Full Credit | No Credit  |
|:----|----|
| Presentation "slides" are simple and easy to read  |  |
| Presentation graphics are relevant to the topic being presented  | |
| Data slides (containing maps or plots) area easy to read  | |
| Colors used in the slides are readable  | |
|===
| Slides can be read from the back of the room | |


***

## Final Report Rubric

### Report Structure & Text Writeup: 10%

| Full Credit | No Credit  |
|:----|----|
| `.pdf` or `.html` file and `.rmd` file is submitted and named appropriately |  |
| Summary text is provided for plots and plots are discussed in the text |  |
| Grammar & spelling are accurate throughout the report |  |
| Report contains atleast 2 (4 for grad students) scientific peer reviewed citations inserted using proper citation format (you chose the style) and 4 total citations |  |
|===
| References are included as both in text citations and as a list at the end of the report and include data sources. | |


### Report Code Structure & Format: 10%

| Full Credit | No Credit  |
|:----|----|
| Code is written using "clean" code practices following the <a href="http://style.tidyverse.org/" target = "_blank">Hadley Wickham style guide</a> | |
| Comments are used to document code | |
| There is no extraneous code in the report. All code included in the report is required to create the report output. | |
| Code chunks are hidden / visible as makes sense to support the report   | |
| All required `R` packages are listed at the top of the document in a code chunk | |
|===
| All code chunks run in the order they are presented in the `.Rmd` or `.ipynb` file| |

### Report Plots & Data Content: 20%

| Full Credit | No Credit  |
|:----|----|
| Report includes a study area map created in `R` | |
| Report contains *at least* 4 maps and/or plots that support discussion of the science question or phenomenon selected to study | |
|===
| All plots are labeled appropriately including units. Its contents are discussed in the paper as they related to the selected study topic | |

### Report Science Content: 60%

| Full Credit | No Credit  |
|:----|----|
| The project background is presented clearly and thoughtfully and includes the study area  | |
| Project background clearly discusses why the topic is important to study | |
| Project background introduces the topic in the context of the literature (both scientific and non scientific as relevant) | |
| Methods: data sources and how the data were acquired are clearly identified and discussed  | |
| Methods: processing and analysis methods are clearly articulated in the report and also align with comments and processing steps seen in the code implementation | |
| Results:  results include *at least* 4 plots and/or maps that support the report findings | |
| Results discuss findings making reference to the plots as makes sense | |
|===
| Conclusions associated with data analysis are clearly articulated and thoughtful. They consider the data analysis as presented.| |

## Graduate Student Additional Report Components

Graduate students: The science content portion of your paper will be worth 45% rather than 60% with the additional 15% coming from the section below which includes the
additional literature review and the abstract.

### Graduate Students - Abstract & Additional Literature Review: 15%

| Full Credit | No Credit  |
|:----|----|
| The literature review presents the topic in the context of other science that has been performed surrounding the selected topic | |
| The literature review is 1.5-2 pages ~ 700 words in length | |
|===
| The report abstract is concise and clearly summarizes the question, methods and high level results of the project | |
