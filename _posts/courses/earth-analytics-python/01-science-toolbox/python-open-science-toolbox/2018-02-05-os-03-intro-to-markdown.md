---
layout: single
title: 'Introduction to Markdown'
excerpt: 'This tutorial walks you through how to format text using markdown.'
authors: ['Leah Wasser', 'Martha Morrissey', 'Data Carpentry']
modified: 2018-07-27
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

This tutorial walks you through how to format text using markdown

<div class='notice--success' markdown="1">

## <i class="fa fa-graduation-cap" aria-hidden="true"></i> Learning Objectives

At the end of this activity, you will be able to:

* Define what the markdown syntax is
* Create  a heading 1, 2 or 3 using Markdown syntax
* Italicize and bold text using Markdown

 
</div>
 
 
## Markdown 

Markdown is a human readable syntax for formatting text documents. Markdown can be used to produce nicely formatted documents including pdf's and web pages. When you format text using markdown in a document, it is similar to using the format tools (bold, heading 1, heading 2, etc) in a word processing tool like Microsoft Word of Google Docs. However instead of using buttons to apply formatting, you use syntax such as `**this bolds text in markdown**` or `# Here is a heading`.Markdown allows you to format text - such as making headings, italics, bold, bulleted list, add links, format mathematical symbols and , make tables ect. 



<i class="fa fa-star"></i>**Data Tip:**
Learn more about [markdown](http://jupyter-notebook.readthedocs.io/en/stable/examples/Notebook/Working%20With%20Markdown%20Cells.html)
{: .notice--success }


### Markdown Syntax in Jupyter Notebook files

Jupyter notebooks allow you to combine code and Markdown in one document. A Jupyter notebook can contain text written using the markdown syntax, in a cell that is specified for markdown. 


<figure>
 <a href="{{ site.url }}/images/courses/earth-analytics/python-interface/md-cell.png">
 <img src="{{ site.url }}/images/courses/earth-analytics/python-interface/md-cell.png"></a>
 <figcaption> Jupyter Notebook with a markdown cell.
 </figcaption>
</figure>



The text that you add to a Jupyter notebook using Markdown can serve many different purposes. It could be used to:

* Document your workflow: You may add text to the document that describes the steps that you incorporated into your processing workflow
* Describe your data:It could describe the data that you are using, how it's being processed and what the outputs are. 
* Interpret code outputs: You may even add some text that interprets or discusses the outputs. 

When you render your document to HTML or pdf) this markdown will appear as text on the output document. 


<i class="fa fa-star"></i>**Data Tip:**
This web page that you are reading right now is generated from a markdown document. In this tutorial, we cover the basic syntax of markdown.
{: .notice--success }

## Get to Know the Markdown Syntax

Markdown is simple plain text, that is styled using special characters, including:

#: a header element

**: bold text

*: italic text

` : code blocks

Let's review some basic markdown syntax


### Paragraph Text

When you type text in a markdown document with no additional syntax, the text
will appear as paragraph text. You can add additional syntax to that text
to format it in different ways.

For example, if you want to highlight a function or some code within a plain text
paragraph, we can use one backtick on each side of the text ( <code>`code-goes-here`</code> ),
like this: <code>`Here is some code`</code>. This is the backtick, or grave; not
an apostrophe (on most US keyboards it is on the same key as the tilde (~)).

To add emphasis to other text you can use **bold** or *italics*.

Have a look at the markdown below:

```
The use of the highlight ( `text` ) will be reserved for denoting code.
To add emphasis to other text use **bold** or *italics*.
```

Notice that this sentence uses both a code highlight "``", bold and italics.
As a rendered markdown chunk, it looks like this:

***

The use of the highlight ( `text` ) will be reserve for denoting code when
used in text. To add emphasis to other text use **bold** or *italics*.

***

### Horizontal Lines (rules)

Create a rule:

	  ***


	  ***

### Here is rendered markdown: 

Section Headings
We create a heading using the pound (#) sign. For the headers to render
properly there must be a space between the # and the header text.
Heading one is 1 # sign, heading two is 2 ## signs, etc as follows:

## Heading two

### Heading three

#### Heading four


### Explore Markdown Cells in a Jupyter Notebook 

```python
print( "Hello Earth Analytics")
```

You should now be able to: 
*define markdown 
* make a heading 
*  **italicize** some text 


### Explore Markdown Cells in a Jupyter Notebook 

```python
print( "Hello Earth Analytics")
```

You should now be able to: 
*define markdown 
* make a heading 
*  **italicize** some text 


Check out the markdown cell above. Does any of the markdown syntax look familiar?
* Are any words in bold?
* Are any words in italics?
* Are any words highlighted as code?
* Is any of the text in a bulleted list ? 

If you are unsure, the answers are at the bottom of this page.



### Add an images in Markdown
You can add images to a cell of markdown using markdown syntax as follows:
![alt text here](path-to-image-here)
However, for this to work `python` will only be able to find your image if you
have placed it in the right place - RELATIVE to your .ipynb file. This is where
good file management becomes extremely important.

To make this simple, let's setup an directory named images in your earth-analytics project / working directory. If your .ipynb file is located in root of this directory, and all images that you want to include in your report are located in the
images directory within the earth-analytics directory, then the path that you
would use for each image would look like:
images/week3/image-name-here.png
Let's try it with an actual image.

<figure>
 <a href="{{ site.url }}/images/courses/earth-analytics/lidar-raster-data-r/silly-dog.png">
 <img src="{{ site.url }}/images/courses/earth-analytics/lidar-raster-data-r/silly-dog.png"></a>
 <figcaption> Silly dog.
 </figcaption>
</figure>



And here's what that code does IF the image is in the right place:
￼
If all of your images are in your images directory, then you will be able to easily find them. This also follows good file management practices because all of the images that you use in your report are contained within your project directory.





<div class="notice--info" markdown="1">

## Additional Resources 

* <a href="https://guides.github.com/features/mastering-markdown/" target="_blank">GitHub Guide on Markdown</a>
* <a href="http://jupyter-notebook.readthedocs.io/en/stable/examples/Notebook/Working%20With%20Markdown%20Cells.html" target="_blank"> Jupyter Notebook Markdown Resources</a>


</div>


Answers to the Default Text Markdown Syntax Questions
* Are any words in bold? - Yes, Italicize 
* Are any words in italics? - No 
* Are any words highlighted as code? - Yes (print “Earth Analytics Python”)
