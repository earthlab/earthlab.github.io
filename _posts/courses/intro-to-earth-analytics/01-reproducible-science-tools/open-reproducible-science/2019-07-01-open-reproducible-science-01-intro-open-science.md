---
layout: single
title: 'What Is Open Reproducible Science'
excerpt: "Open reproducible science refers to developing workflows that others can easily understand and use. It enables you to build on others' work rather than starting from scratch. Learn about the importance and benefits of open reproducible science."
authors: ['Jenny Palomino', 'Leah Wasser', 'Max Joseph']
category: [courses]
class-lesson: ['open-reproducible-science']
permalink: /courses/intro-to-earth-data-science/open-reproducible-science/get-started-open-reproducible-science/
nav-title: "About Open Science"
dateCreated: 2019-07-01
modified: 2019-08-30
module-title: 'Open Reproducible Science Workflows and Tools'
module-nav-title: 'Open Reproducible Science Workflows'
module-description: 'Open science involves making scientific methods, data and outcomes available to everyone. Learn why open reproducible science is important. Discover tools that support open science including Shell (Bash), git and GitHub, and Jupyter.'
module-type: 'class'
class-order: 1
course: "intro-to-earth-data-science"
week: 1
sidebar:
  nav:
author_profile: false
comments: true
order: 1
topics:
  reproducible-science-and-programming: ['python']
redirect_from:
  - "/courses/earth-analytics-bootcamp/get-started-with-open-science/intro-open-science/"
---

{% include toc title="In This Chapter" icon="file-text" %}

<div class='notice--success' markdown="1">

## <i class="fa fa-ship" aria-hidden="true"></i> Chapter One - Open Reproducible Science

In this chapter, you will learn about open reproducible science and become familiar with a suite of open source tools that are often used in open reproducible science (and earth data science) workflows including `Shell`, `git` and `GitHub`, `Python`, and `Jupyter`. 


## <i class="fa fa-graduation-cap" aria-hidden="true"></i> Learning Objectives

After completing this chapter, you will be able to:

* Define open reproducible science and explain its importance.
* Describe how reproducibility can benefit yourself and others.
* List tools that can help you implement open reproducible science workflows.

</div>


## What is Open Reproducible Science

Open science involves making scientific methods, data, and outcomes available to everyone. It can be broken down into several parts (<a href="http://www.openscience.org/blog/?p=269" target="_blank">Gezelter 2009</a>) including:

* Transparency in data collection, processing and analysis methods, and derivation of outcomes.
* Publicly available data and associated processing methods.
* Transparent communication of results.

Open science is also often supported by collaboration.

Reproducible science is when anyone (including others and your future self) can understand and replicate the steps of an analysis, applied to the same or even new data. 

Together, open reproducible science results from open science workflows that allow you to easily share work and collaborate with others as well as openly publish your data and workflows to contribute to greater science knowledge. 

<figure>
 <a href="{{ site.url }}/images/courses/earth-analytics/bootcamp/open-science/workflow.png">
 <img src="{{ site.url }}/images/courses/earth-analytics/bootcamp/open-science/workflow.png" alt="This figure shows an open science workflow, highlighting the roles of data, code, and workflows. Source: Max Joseph, Earth Lab at University of Colorado, Boulder."></a>
 <figcaption> An open science workflow highlighting the roles of data, code, and workflows. Source: Max Joseph, Earth Lab at University of Colorado, Boulder.
 </figcaption>
</figure>

Click through the slideshow below to learn more about open science.

<a class="btn btn-info" href="{{ site.url }}/slide-shows/share-publish-archive/" target= "_blank"> <i class="fa fa-youtube-play" aria-hidden="true"></i>
View Slideshow: Share, Publish & Archive Code & Data</a>


<div class="notice--success" markdown="1">

<a href="https://www.youtube.com/watch?v=NGFO0kdbZmk&feature=youtu.be" target="_blank"><img src="http://img.youtube.com/vi/NGFO0kdbZmk/0.jpg" alt="Importance of Reproducibility in Science" width="560" height="315" border = "10" /></a>

>Watch this 15 minute video to learn more about the importance of reproducibility in science and the current reproducibility "crisis."

</div>


## Benefits of Open Reproducible Science

Benefits of openness and reproducibility in science include:
* Transparency in the scientific process, as anyone including the general public can access the data, methods, and results. 
* Ease of replication and extension of your work by others, which further supports peer review and collaborative learning in the scientific community. 
* It supports you! You can easily understand and re-run your own analyses as often as needed and after time has passed.  


## How Do You Make Your Work More Open and Reproducible?

The list below are things that you can begin to do to make your work more open and reproducible. It can be overwhelming to think about doing everything at once. However, each item is something that you could work towards. 

### Use Scientific Programming to Process Data

Scientific programming allows you to automate tasks, which facilitates your workflows to be quickly run and replicated. In contrast, graphical user interface (GUI) based workflows require interactive manual steps for processing, which become more difficult and time consuming to reproduce. If you use an open source programming language like `Python` or `R`, then anyone has access to your methods. However, if you use a tool that requires a license, then people without the resources to purchase that tool are excluded from fully reproducing your workflow. 

### Use Expressive Names for Files and Directories to Organize Your Work 

<a href="{{ site.url }}/courses/intro-to-earth-data-science/open-reproducible-science/get-started-open-reproducible-science/best-practices-for-organizing-open-reproducible-science/">Expressive file and directory names</a> allow you to quickly find what you need and also support reproducibility by facilitating others' understanding of your files and workflows (e.g. names can tell others what the file or directory contains and its purpose). Be sure to organize related files into directories (i.e. folders) that can help you easily categorize and find what you need (e.g. raw-data, scripts, results).

### Use FAIR Data to Enhance the Reproducibility of Projects

Make sure that the data used in your project adhere to the FAIR principles <a href="https://www.nature.com/articles/sdata201618" target="_blank">(Wilkinson et al. 2016)</a>, so that they are findable, accessible, interoperable, and re-usable, and there is documentation on how to access them and what they contain. FAIR principles also extend beyond the raw data to apply to the tools and workflows that are used to process and create new data. FAIR principles enhance the reproducibility of projects by supporting the reuse and expansion of your data and workflows, which contributes to greater discovery within the scientific community.  

### Protect Your Raw Data 

Don't modify (or overwrite) the raw data. Keep data outputs separate from inputs, so that you can easily re-run your workflow as needed. This is easily done if you organize your data into directories that separate the raw data from your results, etc. 

### Use Version Control and Share Your Code (If You Can)

Version control allows you to manage and track changes to your files (and even undo them!). If you can openly share your code, implement version control and then publish your code and workflows on the cloud. There are many free tools to do this including <a href="{{ site.url }}/workshops/intro-version-control-git/">Git and GitHub</a>. 

### Document Your Workflows

Documentation can mean many different things. It can be as basic as including (carefully crafted and to the point) comments throughout your code to explain the specific steps of your workflow. Documentation can also mean using tools such as Jupyter Notebooks or RMarkdown files to include a text narrative in Markdown format that is interspersed with code to provide high level explanation of a workflow. 

Documentation can also include <a href="{{ site.url }}/courses/earth-analytics-python/contribute-to-open-source/software-documentation-python/">docstrings</a>, which provide standardized documentation of Python functions, or even README files that describe the bigger picture of your workflow, directory structure, data, processing, and outputs.

### Design Workflows That Can Be Easily Recreated

You can design <a href="{{ site.url }}/courses/earth-analytics-python/create-efficient-data-workflows/design-efficient-workflows/">workflows that can be easily recreated and reproduced by others</a> by:
* listing all packages and dependencies required to run a workflow at the top of the code file (e.g. Jupyter Notebook or R Markdown files).
* organizing your code into sections, or code blocks, of related code and include comments to explain the code. 
* creating reusuable environments for Python workflows using tools like <a href="https://www.docker.com/resources/what-container"  target="_blank">docker containers</a>, <a href="https://docs.conda.io/en/latest/"  target="_blank">conda environments</a>, and <a href="https://mybinder.org/" target="_blank">interactive notebooks with binder</a>. 

<div class="notice--info" markdown="1">

## Open Reproducible Science - A Case Study

Chaya is a scientist at Generic University, studying the role of invasive grasses on fires in grassland areas. She is building models of fire spread as they relate to vegetation cover. This model uses data collected from satellites that detect wildfires and also plant cover maps. After documenting that an invasive plant drastically alters fire spread rates, she is eager to share her findings with the world. Chaya uses scientific programming rather than a graphical user interface tool such as Excel to process her data and run the model to ensure that the process is automated. Chaya writes a manuscript on her findings. When she is ready to submit her article to a journal, she first posts a preprint of the article on a preprint server, stores relevant data in a data repository and releases her code on GitHub. This way, the research community can provide feedback on her work, the reviewers and others can reproduce her analysis, and she has established precedent for her findings. 

In the first review of her paper, which is returned 3 months later, many changes are suggested which impact her final figures. Updating figures could be a tedious process. However, in this case, Chaya has developed these figures using the Python programming language. Thus, updating figures is easily done by modifying the processing methods used to create them. Further because she stored her data and code in a public repository on GitHub, it is easy and quick for Chaya three months later to find the original data and code that she used and to update the workflow as needed to produce the revised versions of her figures. Throughout the review process, the code (and perhaps data) are updated, and new versions of the code are tracked. Upon acceptance of the manuscript, the preprint can be updated, along with the code and data to ensure that the most recent version of the paper and analysis are openly available for anyone to use.

</div>

