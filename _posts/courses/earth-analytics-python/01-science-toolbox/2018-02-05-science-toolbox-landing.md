---
layout: single
category: courses
title: "Get Started with Data in Python / Jupyter Notebooks"
permalink: /courses/earth-analytics-python/python-open-science-toolbox/
week-landing: 1
week: 1
sidebar:
  nav:
comments: false
author_profile: false
course: "earth-analytics-python"
module-type: 'session'
---
{% include toc title="This Week" icon="file-text" %}

<div class="notice--info" markdown="1">

## <i class="fa fa-ship" aria-hidden="true"></i> Welcome to Week One!

Welcome to week one of Earth Analytics Python! In week 1 we will explore data together
in class related to the 2013 Colorado Floods. In your homework, you will set up
`Python` and `Jupyter Notebook` on your laptop and learn how to create a `Jupyter Notebook`
document and convert it to an `.html`. 

<a class="btn btn-info btn--x-large" href="{{ site.url }}/slide-shows/4-earth-analytics-spring-2017-intro/" target= "_blank"> <i class="fa fa-youtube-play" aria-hidden="true"></i> View course overview slideshow
</a>

<!--
<a class="btn btn-info btn--large" href="https://docs.google.com/document/d/1EY9vxr3bAi81xfuIcNvjMRQqbSkXc9qoau0Pn3cahLQ/edit" target= "_blank"> View climate change google doc
</a>
<a class="btn btn-info btn--large" href="https://docs.google.com/document/d/1XuPS0oHh6lRo47sQ4XB-WSWvRQBoS2HWksNc6v_JSic/edit#
" target= "_blank"> View FLOODING change google doc
</a>
-->

</div>

## <i class="fa fa-pencil"></i> Homework Week 1

As a part of the homework for week one, do the following.

### 1. Read the Following Articles On Reproducible Science

* <a href="https://genomebiology.biomedcentral.com/articles/10.1186/s13059-015-0850-7" target="_blank">Five selfish reasons to work reproducibly - Florian Markowetz</a>
* <a href="http://journals.plos.org/plosbiology/article?id=10.1371/journal.pbio.1002303" target="_blank"> Computing Workflows for Biologists: A Roadmap</a>


### 2. Watch A Short Video On the 2013 Floods

This 4 minute video will help you understand what happened during the 2013
floods in Colorado. It will also help you understand the data that we will use in 
this class as it relates to the floods.

<iframe width="560" height="315" src="https://www.youtube.com/embed/IHIckvWhwoo" frameborder="0" allowfullscreen></iframe>

#### Before / After Google Earth Fly Through

This 40 second video shows imagery collected before and after the 2013 floods in the Lee Hill Road, Boulder area.

<iframe width="560" height="315" src="https://www.youtube.com/embed/bUcWERTM-OA?rel=0&loop=1" frameborder="0" allowfullscreen></iframe>

### 3. Review Open Science Slides

These slides provide and overview of open science. Some of this will be a review from what was covered in the Earth Analytics Bootcamp course that you took in the summer.

<a class="btn btn-info" href="{{ site.url }}/slide-shows/share-publish-archive/" target= "_blank"> <i class="fa fa-youtube-play" aria-hidden="true"></i>
View Slideshow: Share, Publish & Archive Code & Data</a>

### 4. Review lessons

The last part of your homework assignment is to review the homework lessons (see links
on the left hand side of this page).
Following the lessons, setup `Python`, `Jupyter Notebook` and a
`working directory` that will contain the data we will use for week one and the
rest of the semester on your laptop.

Once everything is setup, complete the second set of lessons which walk you
through creating and working with `Jupyter Notebooks` and exporting them to `.html` format. Some of these lessons 
will be review from the Earth Analytics Bootcamp course. 

<i class="fa fa-star" aria-hidden="true"></i> **Important:** Review
ALL of the lessons and have your computer setup BEFORE class begins next week.
You will be behind if these things are not setup / complete before week 2.
{: .notice--success}

### 5. Complete assignment below

After you have complete the tasks above, complete the assignment below.
Submit your `.html` document and `.ipynb` document to Canvas
by **Wed 25 January 2017 at NOON Mountain Time.**

<!-- start homework activity -->


<div class="notice--warning" markdown="1">

## <i class="fa fa-pencil-square-o" aria-hidden="true"></i> Homework Submission: Create A Report Using Jupyter Notebooks

* Create a new notebook `.ipynb` file in `Jupyter Notebook`. Name the file:
`yourLastName-firstInitial-week1.ipynb` example: `wasser-l-week1.ipynb`

* Add an author in a cell of markdown at the top of the document
* Give your file an appropriate title. Suggestion: `Earth Analytics Spring 2017: Homework - Week 1`
* At the top of the notebook make a markdown cell and add some text
that describes:

   * What an `.ipynb` file is
   * Why using `Jupyter Notebooks` to create reports can be helpful to both you and your colleagues that you work with on a project.

* Create a new CODE CHUNK
* Copy and paste the code BELOW into the code chunk that you just created.
* Below the code chunk in your document, add some TEXT that describes what the plot that you created
shows - interpret what you see in the data.
* Finally, in your own words, summarize what you think the plot shows / tells us about
the flood and also how the data that produced the plot were likely collected. Use the video
about the Boulder Floods as a reference when you write this summery.

BONUS: If you know `python`, clean up the plot by adding labels and a title. 

</div>


```python

# import libraries
import urllib.request
import pandas as pd
import numpy as np 
import matplotlib.pyplot as plt

# download data from figshare
# note that you are downloading the data into your data directory
url = 'https://ndownloader.figshare.com/files/7010681'
destfile = "data/boulder-precip.csv"
urllib.request.urlretrieve(url, destfile)

# import data to a pandas dataframe
boulder_precip = pd.read_csv(destfile)

# view the first few rows of data
display(boulder_precip.head())

# view each column of the data frame using it's name/header
display(boulder_precip['DATE'])
display(boulder_precip['PRECIP'])

# create plot using matplotlib
plt.plot('DATE','PRECIP',data=boulder_precip)

# rotate x tick labels to be legible
plt.xticks(rotation=90)

# draw plot
plt.show()

```

/images/python-screenshots/hw/hw-01-ex-nb.png

<figure>
<a href="/images/courses/earth-analytics/python-interface/hw01-simple-plot.png">
<img src="/images/courses/earth-analytics/python-interface/hw01-simple-plot.png" alt="example plot.">
</a>
<figcaption>
If your code ran properly, the resulting plot should look like this one.
</figcaption>
</figure>

<figure>
<a href="/images/courses/earth-analytics/python-interface/hw-01-ex-nb.png">
<img src="/images/courses/earth-analytics/python-interface/hw-01-ex-nb.png" alt="Jupyter Notebook example image.">
</a>
<figcaption>
Your Jupyter Notebook should look something like the one above (with your own text
added to it). Note that the image above is CROPPED at the bottom. Your Jupyter Notebook
file will have more code in it.
</figcaption>
</figure>

### Troubleshooting: missing plot

If the code above did not produce a plot, please check the following:

#### Check your working directory

If the path to your file is not correct, then the data won't load into `python`.
If the data don't load into `python`, then you can't work with it or plot it.

To figure out your current working directory use the command: `os.getcwd()`
    
Next, go to your finder or file explorer on your computer. Navigate to the path
that `python` gives you when you type `` in the console. It will look something
like the path example: `/Users/your-username/documents/earth-analytics`

```python 

# check your working directory
import os
os.getcwd()

## [1] "/Users/lewa8222/documents/earth-analytics"
```

In the example above, note that my USER directory is called `lewa8222`. Yours
is called something different. Is there a `data` directory within the earth-analytics
directory?

<figure>
<a href="/images/courses/earth-analytics/python-interface/working-dir-os.png">
<img src="/images/courses/earth-analytics/python-interface/working-dir-os.png" alt="data directory example image.">
</a>
<figcaption>
Your working directory should contain a `/data` directory.
</figcaption>
</figure>

If not, review the [working directory lesson](/courses/earth-analytics-python/get-started-with-python-jupyter/introduction-to-bash-shell/)
to ensure your working directory is SETUP properly.

<!-- end homework activity -->
