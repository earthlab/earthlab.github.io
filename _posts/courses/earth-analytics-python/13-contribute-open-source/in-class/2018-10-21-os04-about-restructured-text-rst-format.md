---
layout: single
title: "About the ReStructured Text Format - Introduction to .rst"
excerpt: "Restructured text (RST) is a text format similar to markdown that is often used to document python software. Learn how create headings, lists and code blocks in a text file using RST syntax."
authors: ['Leah Wasser', 'Max Joseph', 'Lauren Herwehe']
modified: 2020-04-01
category: [courses]
class-lesson: ['open-source-software-python']
permalink: /courses/earth-analytics-python/contribute-to-open-source/restructured-text-format-rst/
nav-title: 'Restructured Text'
week: 13
course: "earth-analytics-python"
sidebar:
  nav:
author_profile: false
comments: true
order: 4
topics:
  reproducible-science-and-programming: ['python']
---

{% include toc title="In This Lesson" icon="file-text" %}

<div class='notice--success' markdown="1">

## <i class="fa fa-graduation-cap" aria-hidden="true"></i> Learning Objectives

After completing this tutorial, you will be able to:

* Be able to create headings, lists and code blocks using the RST format

## <i class="fa fa-check-square-o fa-2" aria-hidden="true"></i> What You Need

You will need a computer with internet access to complete this lesson.
</div>

## Introduction to ReStructured Text (RST)

You will find that many open source Python packages use <a href="https://readthedocs.org/" target = “_blank">Readthedocs</a> and <a href="https://en.wikipedia.org/wiki/ReStructuredText" target="_blank">restructured text (RST)</a> to create their documentation. Readthedocs can accept markdown as a documentation format however, `RST` is much more flexible. 

The good news is that if you already know markdown, learning to work with `RST` isn’t a huge leap. The structure is a bit different. Below are a few examples of how to create headers and lists with RST. This should be enough for you to submit documentation to the earthpy package. 

## Headers

Headers are created by using a symbol below the text for the header. The symbol should be repeated and should equal the same number of characters as the header text. You will notice that in some packages the header symbol isn’t the same length as the header text. However, we will follow the convention that it should be for all `earthpy` documentation.

```xml

Main Section Header
================

Subsection Header
--------------------------
```

### Lists

Lists are created in a similar fashion to listed in markdown. You can use a `-` symbol to create a list. If you indent that dash, then you have a list sub item.

```xml
- A bulleted list item
- Second item

  - A sub item

- Spacing between items creates separate lists

- Third item

```

#### Enumerated (Numbered) Lists

Enumerated or numbered lists are created using a number just like in markdown. However, you will add a `)` after than number for it to render properly.


```xml
1) An enumerated list item

2) Second item

   a) Sub item that goes on at length and thus needs
      to be wrapped. Note that the indentation must
      match the beginning of the text, not the 
      enumerator.

      i) List items can even include

         paragraph breaks.

3) Third item

#) Another enumerated list item

#) Second item

```


## Code & Code Blocks

Code blocks in `.Rst` are created using the syntax 

`.. code-block:: python` 

where the name of the coding language used in the block is specified. 

```xml
.. code-block:: python

    >>> with rio.open('example.tif') as src:
    >>>      im = src.read()

```

If you want to highlight code inline (within a text paragraph for instance), you can use two ticks on either side like this:

```xml
Here is a sentence with some code in it - ``es.crop_image()`` and the sentence continues
```

