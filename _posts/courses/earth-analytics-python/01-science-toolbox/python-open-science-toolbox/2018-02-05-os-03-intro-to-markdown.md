---
layout: single
title: 'Introduction to Markdown'
excerpt: 'This tutorial walks you through how to format text using Markdown.'
authors: ['Leah Wasser', 'Martha Morrissey', 'Data Carpentry']
modified: 2018-09-25
category: [courses]
class-lesson: ['open-science-python']
permalink: /courses/earth-analytics-python/python-open-science-toolbox/use-markdown-in-jupyter-notebooks/
nav-title: 'Intro to Markdown'
week: 1
sidebar:
    nav:
author_profile: false
comments: true
order: 3
course: "earth-analytics-python"
topics:
    reproducible-science-and-programming: ['markdown']
---
{% include toc title="In This Lesson" icon="file-text" %}

This tutorial walks you through how to format text using `Markdown` to document your workflows in `Jupyter Notebook` files.

<div class='notice--success' markdown="1">

## <i class="fa fa-graduation-cap" aria-hidden="true"></i> Learning Objectives

At the end of this activity, you will be able to:

* Explain the role `Markdown` syntax for documentation
* Create headings using `Markdown` in `Jupyter Notebook`
* Italicize and bold text using `Markdown` in `Jupyter Notebook`
* Render images using `Markdown` in `Jupyter Notebook`
 
</div>

 
## Markdown 

`Markdown` is a human readable syntax for formatting text documents. `Markdown` can be used to produce nicely formatted documents including PDFs and web pages. When you format text using `Markdown` in a document, it is similar to using the format tools (e.g. bold, heading 1, heading 2) in a word processing tool like Microsoft Word or Google Docs. 

However, instead of using buttons to apply formatting, you use syntax such as `**this syntax bolds text in markdown**` or `# Here is a heading`. `Markdown` allows you to format text - such as making headings, bolding and italicizing words, creating bulleted lists, adding links, formatting mathematical symbols and making tables. 


<i class="fa fa-star"></i> **Data Tip:**
Learn more about <a href="http://jupyter-notebook.readthedocs.io/en/stable/examples/Notebook/Working%20With%20Markdown%20Cells.html" target="_blank">Markdown</a>
{: .notice--success }


### Markdown Syntax in Jupyter Notebook files

`Jupyter Notebook` allows you to combine code (e.g. `Python`) and `Markdown` in one document using cells. A `Jupyter Notebook` file can contain cells that render text written using the `Markdown` syntax as well as cells that contain and run `Python` code. 

<figure>
 <a href="{{ site.url }}/images/courses/earth-analytics/python-interface/md-cell.png">
 <img src="{{ site.url }}/images/courses/earth-analytics/python-interface/md-cell.png" alt="An example Markdown cell in Jupyter Notebook."></a>
 <figcaption> An example Markdown cell in Jupyter Notebook.
 </figcaption>
</figure>

You can use `Markdown` in a `Jupyter Notebook` file for many different purposes. It could be used to:

* Document your workflow: You can add text to the document that describes the steps that you incorporated into your processing workflow (e.g. how data is being processed and what results are produced).
* Describe your data: You can describe the data that you are using (e.g. source, pre-processing, metadata). 
* Interpret code outputs: You may even add some text that interprets or discusses the outputs. 

If you render your `Jupyter Notebook` file to HTML or PDF, this `Markdown` will appear as text on the output document. 

<i class="fa fa-star"></i> **Data Tip:**
This web page that you are reading right now is generated from a markdown document. In this tutorial, we cover the basic syntax of markdown.
{: .notice--success }

## Get to Know the Markdown Syntax

Markdown is simple plain text, that is styled using special characters, including:

#: a header element

**: bold text

*: italic text

` `: code blocks

Explore using some basic `Markdown` syntax. 

### Emphasize Code and Words in Markdown

When you type text in a `Markdown` document with no additional syntax, the text will appear as paragraph text. You can add additional syntax to that text to format it in different ways.

For example, if you want to highlight a function or some code within a plain text paragraph, you can use one backtick on each side of the text ( <code>`code-goes-here`</code> ), like this: <code>`Here is some code`</code>. 

This is the backtick, or grave; not an apostrophe (on most US keyboards, it is on the same key as the tilde (~)).

To add emphasis to other text, you can use also use the following syntax to **bold** or *italicize* words.

For example:

```
The use of the backtick (e.g. `text` ) will be reserved for denoting code.
To add emphasis to other text, use **bold** or *italics*.
```

Notice that this sentence uses both a code highlight (`text`), bolding (**text**) and italics (*text*).

As rendered `Markdown`, it looks like this:

***

The use of the highlight ( `text` ) will be reserve for denoting code when
used in text. To add emphasis to other text use **bold** or *italics*.

***

### Horizontal Lines (Rules)

You can also create a horizonal line or rule to highlight a block of `Markdown` syntax (similar to the highlighting a block of code using ` `):

	  ***


	  ***

### Section Headings 

You can create a heading using the pound (`#`) sign. For the headers to render properly, there must be a space between the `#` and the header text.

Heading one is denoted using one `#` sign, heading two is denoted using two `##` signs, etc, as follows:

`## Heading Two

### Heading Three

#### Heading Four
`

Here is the rendered `Markdown`:

## Heading Two

### Heading Three

#### Heading Four


### Images

<!--
You can use `Markdown` to link to images on the web using the following syntax:

```
<figure>
   <a href="https://www.fullstackpython.com/img/logos/markdown.png">
   <img src="https://www.fullstackpython.com/img/logos/markdown.png" alt="You can use Markdown to add images to Jupyter Notebook files, such as this image of the Markdown logo. Source: Full Stack Python."></a>
   <figcaption> You can use Markdown to add images to Jupyter Notebook files, such as this image of the Markdown logo. Source: Full Stack Python.
   </figcaption>
</figure>
```

It will render as follows:

<figure>
   <a href="https://www.fullstackpython.com/img/logos/markdown.png">
   <img src="https://www.fullstackpython.com/img/logos/markdown.png" alt="You can use Markdown to add images to Jupyter Notebook files, such as this image of the Markdown logo. Source: Full Stack Python."></a>
   <figcaption> You can use Markdown to add images to Jupyter Notebook files, such as this image of the Markdown logo. Source: Full Stack Python.
   </figcaption>
</figure>


You can also add images to a `Markdown` cell using relative paths to files on in your directory structure using:
-->

`![alt text here](path-to-image-here)`

If you want to embed an image from a website, you can use the following syntax:

`![Markdown Logo is here.](https://www.fullstackpython.com/img/logos/markdown.png)`

It will look like this:

![Markdown Logo is here.](https://www.fullstackpython.com/img/logos/markdown.png)

For relative paths (images stored on your computer) to work in `Python`, you need to place the image in the right location on your computer - RELATIVE to your `.ipynb` file. This is where good file management becomes extremely important.

For a simple example of using relative paths, create a directory named `images` in your `earth-analytics` directory. 

If your `Jupyter Notebook` file (`.ipynb`) is located in root of this directory, and all images that you want to include in your report are located in the `images` directory within `earth-analytics`, then the path that you
would use for each image is: 

`images/image-name.png`


<figure class="half">
 <a href="{{ site.url }}/images/courses/earth-analytics/lidar-raster-data-r/silly-dog.png">
 <img src="{{ site.url }}/images/courses/earth-analytics/lidar-raster-data-r/silly-dog.png" alt="This image of a silly dog is rendered using a relative path to this webpage created using Jupyter Notebook."></a>
 <figcaption> This image of a silly dog is rendered using a relative path to this webpage created using Jupyter Notebook.</figcaption>
</figure>


If all of your images are in the `images` directory, then you will be able to easily find them. This also follows good file management practices because all of the images that you use in your report are contained within your project directory.

<div class="notice--info" markdown="1">

## Additional Resources 

* <a href="https://guides.github.com/features/mastering-markdown/" target="_blank">GitHub Guide on Markdown</a>
* <a href="http://jupyter-notebook.readthedocs.io/en/stable/examples/Notebook/Working%20With%20Markdown%20Cells.html" target="_blank"> Jupyter Notebook Markdown Resources</a>
</div>
