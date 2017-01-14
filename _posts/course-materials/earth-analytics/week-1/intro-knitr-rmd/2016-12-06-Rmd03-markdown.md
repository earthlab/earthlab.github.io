---
layout: single
title: "Intro to Markdown"
excerpt: 'This tutorial cover how to use Markdown syntax in R and then
render it to html using knitr.'
authors: [Leah Wasser, NEON Data Skills]
modified: '2017-01-13'
category: [course-materials]
class-lesson: ['intro-rmarkdown-knitr']
permalink: /course-materials/earth-analytics/week-1/intro-to-markdown/
nav-title: 'Intro to Markdown'
week: 1
sidebar:
  nav:
author_profile: false
comments: true
order: 3
---
{% include toc title="This Lesson" icon="file-text" %}

Here, we break down the basic syntax for a markdown file. We also cover how to
create and format markdown (`.md`) files.

<div class='notice--success' markdown="1">

## <i class="fa fa-graduation-cap" aria-hidden="true"></i> Learning Objectives
At the end of this activity, you will be able to:

* Use basic markdown syntax to format a document including: headers, bold and italics.
* Be able to explain what the markdown format is.

## <i class="fa fa-check-square-o fa-2" aria-hidden="true"></i> What you need

You will need the most current version of `R` and, preferably, `RStudio` loaded on
your computer to complete this tutorial.

</div>

## About markdown

Markdown is a human readable syntax for formatting text documents. Markdown can
be used to produce nicely formatted documents including pdf's, web pages and more.
When you format text using markdown in a document, it is similar to using the
format tools (bold, heading 1, heading 2, etc) in a word processing tool like Microsoft
Word of Google Docs.

### Markdown Syntax in .Rmd files

An `R Markdown` file can contain text written using the markdown syntax.
Markdown text, can be whatever you want. It may describe the data that you are
using, how it's being processed and what the outputs are. You may even add some
text that interprets or discusses the outputs.

When you render your document to HTML, this markdown will appear as text on the
output HTML document. We will learn about the markdown syntax next.


<i class="fa fa-star"></i> **Data Tip:** This web page that you are reading right now
is generated from a markdown document.
{: .notice }

In this tutorial, we cover the basic syntax of markdown.

## Markdown Syntax

Markdown is simple plain text, that is styled using special characters, including:

* ` #`: a header element
* `**`: bold text
* `*`: italic text
* <code>` </code>: code blocks

Let's review some basic markdown syntax.

### Paragraph text

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

## Heading two
	## Heading two

### Heading three
	### Heading three

#### Heading four
	#### Heading four




<i class="fa fa-star"></i> **Data Tip:**
There are many free Markdown editors out there! The
<a href="http://Atom.io" target="_blank">atom.io</a>
editor is a powerful text editor package by GitHub, that also has a Markdown
renderer that allows you to preview the rendered Markdown as you write.
{: .notice }

### Explore Your R Markdown File

Look closely at the pre-populated markdown and R code chunks in the `.Rmd`
file that we created above.

Does any of the markdown syntax look familiar?

* Are any words in bold?
* Are any words in italics?
* Are any words highlighted as code?

If you are unsure, the answers are at the bottom of this page.

<div class="notice--warning" markdown="1">

## <i class="fa fa-pencil-square-o" aria-hidden="true"></i> Activity: R Markdown Text

1. Remove the template markdown and code chunks added to the `.Rmd` file by `RStudio`.
(Be sure to keep the YAML header!)
2. At the very top of your .Rmd document - after the YAML header, add
the bio and short research description that you wrote last week in markdown syntax to
the .Rmd file.
3. Between your profile and the research descriptions, add a header that says
**About My Project** (or something similar).
4. Add a new header titled: **Data Activity**. Write some text below that header
that describes what you are learning in this lesson and demonstrates the use of
bold, italics and code formatting within a paragraph of text.

</div>

*Got questions? Leave your question in the comment box below.
It's likely some of your colleagues have the same question, too! And also
likely someone else knows the answer.*



<div class="notice--info" markdown="1">

## Additional Resources

* <a href="https://guides.github.com/features/mastering-markdown/" target="_blank">GitHub Guide on Markdown</a>
* <a href="http://rmarkdown.rstudio.com/authoring_basics.html" target="_blank"> RStudio Markdown Overview</a>

#### Answers to the Default Text Markdown Syntax Questions

* Are any words in bold? - Yes, “Knit” on line 10
* Are any words in italics? - No
* Are any words highlighted as code? - Yes, “echo = FALSE” on line 22

</div>
