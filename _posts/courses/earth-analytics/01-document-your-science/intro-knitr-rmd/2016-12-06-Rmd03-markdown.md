---
layout: single
title: "Introduction to Markdown Syntax - a Primer"
excerpt: 'Learn how to write using the markdown syntax in an R Markdown document.'
authors: ['Leah Wasser', 'NEON Data Skills']
modified: '2018-01-10'
category: [courses]
class-lesson: ['intro-rmarkdown-knitr']
permalink: /courses/earth-analytics/document-your-science/intro-to-markdown/
nav-title: 'Intro to Markdown'
week: 1
sidebar:
  nav:
author_profile: false
comments: true
course: "earth-analytics"
order: 3
topics:
  reproducible-science-and-programming: ['rmarkdown']
---
{% include toc title="In this lesson" icon="file-text" %}

Here, we break down the basic syntax for a markdown file. We also cover how to
create and format markdown (`.md`) files.

<div class='notice--success' markdown="1">

## <i class="fa fa-graduation-cap" aria-hidden="true"></i> Learning Objectives
At the end of this activity, you will be able to:

* Use basic markdown syntax to format a document including: headers, bold and italics.
* Explain what the markdown format is.

## <i class="fa fa-check-square-o fa-2" aria-hidden="true"></i> What You Need

You will need the most current version of `R` and, preferably, `RStudio` loaded on
your computer to complete this tutorial.

</div>

## About Markdown

Markdown is a human readable syntax for formatting text documents. Markdown can
be used to produce nicely formatted documents including `pdf`s, web pages and more.
When you format text using markdown in a document, it is similar to using the
format tools (bold, heading 1, heading 2, etc) in a word processing tool like Microsoft
Word or Google Docs.

### Markdown Syntax in .Rmd Files

An `R Markdown` file can contain text written using the markdown syntax.
Markdown text, can be whatever you want. It may describe the data that you are
using, how it's being processed and what the outputs are. You may even add some
text that interprets or discusses the outputs.

When you render your document to `html`, this markdown will appear as text on the
output `html` document. We will learn about the markdown syntax next.


<i class="fa fa-star"></i> **Data Tip:** This web page that you are reading right now
is generated from a markdown document.
{: .notice--success}

In this tutorial, we cover the basic syntax of markdown.

## Markdown Syntax

Markdown is simple plain text, that is styled using special characters, including:

* ` #`: a header element.
* `**`: bold text.
* `*`: italic text.
* <code>` </code>: code blocks.

Let's review some basic markdown syntax.

### Paragraph Text

When you type text in a markdown document with not additional syntax, the text
will appear as paragraph text. You can add additional syntax to that text
to format it in different ways.

For example, if we want to highlight a function or some code within a plain text
paragraph, we can use one backtick on each side of the text ( <code>``</code> ),
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

Below is the rule rendered:

***

## Section Headings

We create a heading using the pound (`#`) sign. For the headers to render
properly there must be a space between the # and the header text.
Heading one is 1 `#` sign, heading two is 2 `##` signs, etc as follows:

## Heading Two
	## Heading Two

### Heading Three
	### Heading Three

#### Heading Four
	#### Heading Four




<i class="fa fa-star"></i> **Data tip:**
There are many free Markdown editors out there! The
<a href="http://Atom.io" target="_blank">atom.io</a>
editor is a powerful text editor package by GitHub, that also has a Markdown
renderer that allows you to preview the rendered Markdown as you write.
{: .notice--success}

### Explore Your R Markdown File

Look closely at the pre-populated markdown and R code chunks in the `.Rmd`
file that we created above.

Does any of the markdown syntax look familiar?

* Are any words in bold?
* Are any words in italics?
* Are any words highlighted as code?

If you are unsure, the answers are at the bottom of this page.

*Got questions? Leave your question in the comment box below.
It's likely some of your colleagues have the same question, too! And also
likely someone else knows the answer.*



<div class="notice--info" markdown="1">

## Additional Resources

* <a href="https://guides.github.com/features/mastering-markdown/" target="_blank">GitHub Guide on Markdown</a>
* <a href="http://rmarkdown.rstudio.com/authoring_basics.html" target="_blank"> RStudio Markdown Overview</a>

#### Answers to the Default Text Markdown Syntax Questions

* Are any words in bold? - Yes, 'Knit' on line 10
* Are any words in italics? - No
* Are any words highlighted as code? - Yes, 'echo = FALSE' on line 22

</div>
