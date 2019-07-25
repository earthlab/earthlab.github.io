---
layout: single
title: 'What Is Markdown'
excerpt: "This section explains what the Markdown format is and how it supports the documentation of reproducible science workflows."
authors: ['Jenny Palomino', 'Leah Wasser']
category: [courses]
class-lesson: ['markdown']
permalink: /courses/intro-to-earth-analytics/markdown/intro-markdown/
nav-title: "What Is Markdown"
dateCreated: 2019-07-16
modified: 2019-07-17
module-title: 'Markdown for Jupyter Notebook'
module-nav-title: 'Markdown for Jupyter Notebook'
module-description: 'This chapter explains how Markdown can be used for documentation of reproducible science workflows and introduces basic Markdown syntax to format text in Jupyter Notebook.'
module-type: 'class'
class-order: 1
course: "intro-to-earth-analytics"
week: 4
sidebar:
  nav:
author_profile: false
comments: true
order: 1
topics:
  reproducible-science-and-programming: ['markdown']
---
{% include toc title="In This Section" icon="file-text" %}

In this section, you will learn what the `Markdown` format is and how it can be used to document reproducible science workflows.

<div class='notice--success' markdown="1">

## <i class="fa fa-graduation-cap" aria-hidden="true"></i> Learning Objectives

After completing this lesson, you will be able to:

* Explain what the `Markdown` format is.
* Describe the role of `Markdown` syntax for documentation of `Jupyter Notebook` files.


## <i class="fa fa-check-square-o fa-2" aria-hidden="true"></i> What You Need

Be sure that you have completed the previous chapter on <a href="{{ site.url }}/courses/intro-to-earth-analytics/jupyter-notebook/">Jupyter Notebook</a>.

</div>


## What is Markdown?

`Markdown` is a human readable syntax for formatting text documents. `Markdown` can be used to produce nicely formatted documents including PDFs and web pages. When you format text using `Markdown` in a document, it is similar to using the format tools (e.g. bold, heading 1, heading 2) in a word processing tool like Microsoft Word or Google Docs. 

However, instead of using buttons to apply formatting, you use syntax such as `**this syntax bolds text in markdown**` or `# Here is a heading`. 

`Markdown` syntax allows you to format text in many ways, such as making headings, bolding and italicizing words, creating bulleted lists, adding links, formatting mathematical symbols and making tables. These options allow you to format text in visually appealing and organized ways to present your ideas. 


### Markdown Syntax in Jupyter Notebook

A great benefit of `Jupyter Notebook` is that it allows you to combine both code (e.g. `Python`) and `Markdown` in one document using cells. 

A `Jupyter Notebook` file can contain both cells that render text written using the `Markdown` syntax as well as cells that contain and run `Python` code. Thus, you can use a combination of `Markdown` and `Python` code cells to organize and document your `Jupyter Notebook` for others to easily read and follow your workflow.

<figure>
 <a href="{{ site.url }}/images/courses/earth-analytics/python-interface/md-cell.png">
 <img src="{{ site.url }}/images/courses/earth-analytics/python-interface/md-cell.png" alt="An example Markdown cell in Jupyter Notebook."></a>
 <figcaption> An example Markdown cell in Jupyter Notebook.
 </figcaption>
</figure>

<i class="fa fa-star"></i> **Data Tip:**
Learn more about <a href="http://jupyter-notebook.readthedocs.io/en/stable/examples/Notebook/Working%20With%20Markdown%20Cells.html" target="_blank">Markdown for Jupyter Notebook</a>.
{: .notice--success }

If you render your `Jupyter Notebook` file to HTML or PDF, this `Markdown` will appear as formatted text in the output document. 

<i class="fa fa-star"></i> **Data Tip:**
In fact, this web page that you are reading right now is generated from a `Markdown` document! In this chapter, you will learn the basic syntax of `Markdown`.
{: .notice--success }


## Benefits of Markdown for Reproducible Science

Being able to include both `Markdown` and code (e.g. `Python`) cells in a `Jupyter Notebook` file supports reproducible science by allowing you to:

* Document your workflow: You can add text to the document that describes the steps of your processing workflow (e.g. how data is being processed and what results are produced).
* Describe your data: You can describe the data that you are using (e.g. source, pre-processing, metadata). 
* Interpret code outputs: You can add some text that interprets or discusses the outputs. 

all in one document! 

When used effectively, `Markdown` documentation can help anyone who opens your `Jupyter Notebook` to follow, understand and even reproduce your workflow.
