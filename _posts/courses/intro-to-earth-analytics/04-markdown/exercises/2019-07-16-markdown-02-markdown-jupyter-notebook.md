---
layout: single
title: 'Markdown In Jupyter Notebook'
excerpt: "This section reviews how to format text using Markdown in Jupyter Notebook files."
authors: ['Jenny Palomino', 'Leah Wasser']
category: [courses]
class-lesson: ['markdown']
permalink: /courses/intro-to-earth-analytics/markdown/use-markdown-in-jupyter-notebooks/
nav-title: "Markdown In Jupyter Notebook"
dateCreated: 2019-07-16
modified: 2019-07-17
module-type: 'class'
class-order: 1
course: "intro-to-earth-analytics"
week: 4
sidebar:
  nav:
author_profile: false
comments: true
order: 2
topics:
  reproducible-science-and-programming: ['markdown']
---
{% include toc title="In This Section" icon="file-text" %}

In this section, you will learn how to format text using `Markdown` in `Jupyter Notebook` files.

<div class='notice--success' markdown="1">

## <i class="fa fa-graduation-cap" aria-hidden="true"></i> Learning Objectives

After completing this lesson, you will be able to:

* Use `Markdown` syntax in `Jupyter Notebook` to:
    * Create headers and lists
    * Bold and italicize bold text
    * Render images and create hyperlinks to web pages


## <i class="fa fa-check-square-o fa-2" aria-hidden="true"></i> What You Need

Be sure that you have completed the previous chapter on <a href="{{ site.url }}/courses/intro-to-earth-analytics/jupyter-notebook/">Jupyter Notebook</a>.

</div>
 

## Markdown Styling in Jupyter Notebook

`Markdown` is simple plain text that is styled using special characters, including:

#: to create a header element

**: to bold text

*: to italicize text

In the previous chapter on `Jupyter Notebook`, you learned how to add new `Markdown` cells to your `Jupyter Notebook` files using Menu tools and Keyboard Shortcuts to create new cells. 

Function  | Keyboard Shortcut | Menu Tools
--- | --- | ---
Create new cell| Esc + a (above), Esc + b (below) | Insert→ Insert Cell Above OR Insert → Insert Cell Below 
Copy Cell | c  | Copy Key
Paste Cell | v | Paste Key

You also learned how to change the default type of the cell by clicking in the cell and selecting a new cell type (e.g. `Markdown`) in the cell type menu in the toolbar. Furthermore, you learned that in a `Jupyter Notebook` file, you can double-click in any `Markdown` cell to see the syntax, and then run the cell again to see the `Markdown` formatting.

**Note:** if you type text in a `Markdown` cell with no additional syntax, the text will appear as regular paragraph text. You can add additional syntax to that text to format it in different ways.

In this section, you will learn basic `Markdown` syntax for formatting text in `Jupyter Notebook` files. 


## Section Headers

You can create a heading using the pound (`#`) sign. For the headers to render properly, there must be a space between the `#` and the header text.

Heading one is denoted using one `#` sign, heading two is denoted using two `##` signs, etc, as follows:

```markdown
## Heading Two

### Heading Three

#### Heading Four
```

Here is a sample of the rendered `Markdown`:

### Heading Three

#### Heading Four

**Note**: the titles on this page are actually formatted using `Markdown` (e.g. the words **Section Headers** above are formatted as a heading two). 


## Lists

You can also use `Markdown` to create lists using the following syntax:

```markdown
* This is a bullet list
* This is a bullet list
* This is a bullet list


1. And you can also create ordered lists
2. by using numbers
3. and listing new items in the lists 
4. on their own lines
```

It will render as follows:

* This is a bullet list
* This is a bullet list
* This is a bullet list


1. And you can also create ordered lists
2. by using numbers
3. and listing new items in the lists 
4. on their own lines

Notice that you have space between the `*` or `1.` and the text. The space triggers the action to create the list using `Markdown`. 


## Bold and Italicize

You can also use `**` to bold or `*` to italicize words.  To bold and italicize words, the symbols have to be touching the word and have to be repeated before and after the word using the following syntax:

```markdown
*These are italicized words, not a bullet list*
**These are bold words, not a bullet list**

* **This is a bullet item with bold words**
* *This is a bullet item with italicized words*
```

It will render as follows:

*These are italicized words, not a bullet list*
**These are bold words, not a bullet list**

* **This is a bullet item with bold words**
* *This is a bullet item with italicized words*

## Highlight Code

If you want to highlight a function or some code within a plain text paragraph, you can use one backtick on each side of the text like this:

```markdown
`Here is some code!`
```
which renders like this: 

`Here is some code!`

The symbol used is the backtick, or grave; not an apostrophe (on most US keyboards, it is on the same key as the tilde (~)).


## Horizontal Lines (Rules)

You can also create a horizontal line or rule to highlight a block of `Markdown` syntax (similar to the highlighting a block of code using the backticks):

```markdown
***

Here is some important text!

***
```
which renders like this: 

***

Here is some important text!

***

## Hyperlinks

You can also use HTML in `Markdown` cells to create hyperlinks to websites using the following syntax:

```markdown
Our program website can be found at <a href="http://earthdatascience.org" target="_blank">this link</a>. 

```

It will render as follows:

Our program website can be found at <a href="http://earthdatascience.org" target="_blank">this link</a>.


## Render Images

You can also use `Markdown` to link to images on the web using the following syntax:

`![Markdown Logo is here.](https://www.fullstackpython.com/img/logos/markdown.png)`

It will render as follows:

![Markdown Logo is here.](https://www.fullstackpython.com/img/logos/markdown.png)


### Local Images Using Relative Computer Paths

You can also add images to a `Markdown` cell using relative paths to files in your directory structure using:

`![alt text here](path-to-image-here)`

For relative paths (images stored on your computer) to work in `Jupyter Notebook`, you need to place the image in a location on your computer that is RELATIVE to your `.ipynb` file. This is where good file management becomes extremely important.

For a simple example of using relative paths, imagine that you have a subdirectory named `images` in your `earth-analytics` directory (i.e. `earth-analytics/images/`).

If your `Jupyter Notebook` file (`.ipynb`) is located in root of this directory (i.e. `earth-analytics/notebook.ipynb`), and all images that you want to include in your report are located in the `images` subdirectory (i.e. `earth-analytics/images/`), then the path that you would use for each image is: 

`images/image-name.png`

If all of your images are in the `images` subdirectory, then you will be able to easily find them. This also follows good file management practices because all of the images that you use in your report are contained within your project directory.

<i class="fa fa-star"></i> **Data tip:**
There are many free `Markdown` editors out there! The
<a href="http://Atom.io" target="_blank">atom.io</a>
editor is a powerful text editor package by GitHub, that also has a `Markdown`
renderer that allows you to preview the rendered `Markdown` as you write.
{: .notice--success}

<div class="notice--warning" markdown="1">

## <i class="fa fa-pencil-square-o" aria-hidden="true"></i> Challenge 1

1. Open a new `Jupyter Notebook` file.

2. Add a new `Markdown` cell and include:
    * A title for the notebook (e.g. `Intro to Earth Analytics - Chapter Four`)
    * A **bullet list** with:
        * A bold word for `Author:` and then add text for your name. 
        * A bold word for `Date:` and then add text for today's date.

</div>

<div class="notice--warning" markdown="1">

## <i class="fa fa-pencil-square-o" aria-hidden="true"></i> Challenge 2

1. Add another `Markdown` cell and include:
    * A list of your three favorite foods (e.g. blueberries, chocolate bars, avocados)
    * A hyperlink (i.e. webpages) for each item in your list of favorite foods
    * An image for each item in your listed favorite foods

</div>

<div class="notice--info" markdown="1">

## Additional Resources 

* <a href="https://guides.github.com/features/mastering-markdown/" target="_blank">GitHub Guide on Markdown</a>
* <a href="http://jupyter-notebook.readthedocs.io/en/stable/examples/Notebook/Working%20With%20Markdown%20Cells.html" target="_blank"> Jupyter Notebook Markdown Resources</a>

</div>
