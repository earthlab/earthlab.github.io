---
layout: single
title: 'Format Text In Jupyter Notebook With Markdown'
excerpt: "Markdown allows you to format text using simple, plain-text syntax and can be used to document code in a variety of tools, including Jupyter Notebook. Learn how to format text in Jupyter Notebook using Markdown."
authors: ['Jenny Palomino', 'Leah Wasser']
category: [courses]
class-lesson: ['text-file-formats']
permalink: /courses/intro-to-earth-data-science/file-formats/use-text-files/format-text-with-markdown-jupyter-notebook/
nav-title: "Markdown in Jupyter Notebook"
dateCreated: 2019-08-29
modified: 2019-08-29
module-type: 'class'
class-order: 1
course: "intro-to-earth-data-science"
week: 2
sidebar:
  nav:
author_profile: false
comments: true
order: 2
topics:
  reproducible-science-and-programming: ['markdown']
redirect_from:
   - "/courses/earth-analytics-bootcamp/git-github-version-control/markdown-jupyter-notebook/"
---

{% include toc title="On This Page" icon="file-text" %}

<div class='notice--success' markdown="1">

## <i class="fa fa-graduation-cap" aria-hidden="true"></i> Learning Objectives

* Explain what the `Markdown` format is.
* Describe the role of `Markdown` for documentation of earth data science workflows.
* Use `Markdown` syntax in `Jupyter Notebook` to:
    * Create headers and lists
    * Bold and italicize bold text
    * Render images and create hyperlinks to web pages

</div>


## What is Markdown?

`Markdown` is a human readable syntax (also referred to as a markup language) for formatting text documents. `Markdown` can be used to produce nicely formatted documents including PDFs and web pages. 

When you format text using `Markdown` in a document, it is similar to using the format tools (e.g. bold, heading 1, heading 2) in a word processing tool like Microsoft Word or Google Docs. However, instead of using buttons to apply formatting, you use syntax such as `**this syntax bolds text in markdown**` or `# Here is a heading`. 

`Markdown` syntax allows you to format text in many ways, such as making headings, bolding and italicizing words, creating bulleted lists, adding links, formatting mathematical symbols and making tables. These options allow you to format text in visually appealing and organized ways to present your ideas. 

You can use Markdown to format text in many different tools including <a href="https://guides.github.com/features/mastering-markdown/" target="_blank">GitHub.com</a>, R using <a href="https://rmarkdown.rstudio.com/lesson-1.html" target="_blank">RMarkdown</a>, and Jupyter Notebook, which you will learn more about this page.  

<i class="fa fa-star"></i> **Data Tip:**
Learn more about how you can use <a href="https://www.markdownguide.org/" target="_blank">Markdown</a> to format text and document workflows in a variety of tools. 
{: .notice--success }

### Markdown in Jupyter Notebook

A great benefit of `Jupyter Notebook` is that it allows you to combine both code (e.g. `Python`) and `Markdown` in one document, so that you can easily document your workflows. 

A `Jupyter Notebook` file uses cells to organize content, and it can contain both cells that render text written using the `Markdown` syntax as well as cells that contain and run `Python` code. 

Thus, you can use a combination of `Markdown` and `Python` code cells to organize and document your `Jupyter Notebook` for others to easily read and follow your workflow.

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
In fact, this web page that you are reading right now is generated from a `Markdown` document! On this page, you will learn the basic syntax of `Markdown`.
{: .notice--success }


### Benefits of Markdown for Earth Data Science

Being able to include both `Markdown` and code (e.g. `Python`) cells in a `Jupyter Notebook` file supports reproducible science by allowing you to:

* Document your workflow: You can add text to the document that describes the steps of your processing workflow (e.g. how data is being processed and what results are produced).
* Describe your data: You can describe the data that you are using (e.g. source, pre-processing, metadata). 
* Interpret code outputs: You can add some text that interprets or discusses the outputs. 

all in one document! 

When used effectively, `Markdown` documentation can help anyone who opens your `Jupyter Notebook` to follow, understand and even reproduce your workflow.


## Format Text in Jupyter Notebook with Markdown

### Markdown Cells in Jupyter Notebook

In the previous chapter on `Jupyter Notebook`, you learned how to add new `Markdown` cells to your `Jupyter Notebook` files using Menu tools and Keyboard Shortcuts to create new cells. 

Function  | Keyboard Shortcut | Menu Tools
--- | --- | ---
Create new cell| Esc + a (above), Esc + b (below) | Insert→ Insert Cell Above OR Insert → Insert Cell Below 
Copy Cell | c  | Copy Key
Paste Cell | v | Paste Key

You also learned how to change the default type of the cell by clicking in the cell and selecting a new cell type (e.g. `Markdown`) in the cell type menu in the toolbar. Furthermore, you learned that in a `Jupyter Notebook` file, you can double-click in any `Markdown` cell to see the syntax, and then run the cell again to see the `Markdown` formatting.

**Note:** if you type text in a `Markdown` cell with no additional syntax, the text will appear as regular paragraph text. You can add additional syntax to that text to format it in different ways.

On this page, you will learn basic `Markdown` syntax that you can use to format text in `Jupyter Notebook` files. 


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

<i class="fa fa-star"></i> **Data tip:** There are many free `Markdown` editors out there! The <a href="http://Atom.io" target="_blank">atom.io</a> editor is a powerful text editor package by GitHub, that also has a `Markdown` renderer that allows you to preview the rendered `Markdown` as you write.
{: .notice--success}


<div class="notice--info" markdown="1">

## Additional Resources 

* <a href="https://guides.github.com/features/mastering-markdown/" target="_blank">GitHub Guide on Markdown</a>
* <a href="http://jupyter-notebook.readthedocs.io/en/stable/examples/Notebook/Working%20With%20Markdown%20Cells.html" target="_blank"> Jupyter Notebook Markdown Resources</a>

</div>


<div class="notice--warning" markdown="1">

## <i class="fa fa-pencil-square-o" aria-hidden="true"></i> Practice Your Markdown Skills

1. Open or create a new `Jupyter Notebook` file.

2. Add a new `Markdown` cell and include:
    * A title for the notebook (e.g. `Intro to Earth Analytics - Chapter Four`)
    * A **bullet list** with:
        * A bold word for `Author:` and then add text for your name. 
        * A bold word for `Date:` and then add text for today's date.
        
3. Add another `Markdown` cell and include:
    * A list of your top three favorite foods (e.g. blueberries, chocolate bars, avocados).
        * Italicize the first item in your list. 
        * Add a hyperlink (i.e. webpages) for the second item in your list (include the name of the food in the title of the hyperlink).
        * Add an image for the last item in your list (include the name in the alt text of the image).

</div>
