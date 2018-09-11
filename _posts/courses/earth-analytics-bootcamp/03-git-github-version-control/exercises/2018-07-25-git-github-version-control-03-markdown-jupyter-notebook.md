---
layout: single
title: 'Markdown in Jupyter Notebook'
excerpt: "This lesson teaches you how to add Markdown to Jupyter Notebook files."
authors: ['Jenny Palomino', 'Leah Wasser']
category: [courses]
class-lesson: ['git-github-version-control']
permalink: /courses/earth-analytics-bootcamp/git-github-version-control/markdown-jupyter-notebook/
nav-title: "Markdown in Jupyter Notebook"
dateCreated: 2018-07-25
modified: 2018-09-10
odule-type: 'class'
class-order: 2
course: "earth-analytics-bootcamp"
week: 3
sidebar:
  nav:
author_profile: false
comments: true
order: 3
topics:
  reproducible-science-and-programming: ['markdown']
---
{% include toc title="In This Lesson" icon="file-text" %}

In this lesson, you will learn how to add `Markdown` documentation to `Jupyter Notebook` files (.ipynb).

<div class='notice--success' markdown="1">

## <i class="fa fa-graduation-cap" aria-hidden="true"></i> Learning Objectives

After completing this lesson, you will be able to:

* Add `Markdown` syntax for titles, lists, and hyperlinks to webpages and images
* Add `Markdown` syntax to bold and italicize words 


## <i class="fa fa-check-square-o fa-2" aria-hidden="true"></i> What You Need

Be sure that you have completed the lessons on <a href="{{ site.url }}/courses/earth-analytics-bootcamp/get-started-with-open-science/jupyter-notebook-interface/">The Jupyter Notebook Interface.</a>

</div>
 

## Markdown Styling

In previous lessons, you learned that Markdown is simple plain text that is styled using special characters, including:

#: to create a header element

**: to bold text

*: to italicize text

` : to indicate code blocks`

You also learned how to add new `Markdown` cells to your Jupyter Notebook using Menu tools and Keyboard Shortcuts to create new cells. You also learned how to change the default type of the cell by clicking in the cell and selecting a new cell type (e.g. `Markdown`) in the cell type menu in the toolbar. 

Function  | Keyboard Shortcut | Menu Tools
--- | --- | ---
Create new cell| Esc + a (above), Esc + b (below) | Insert→ Insert Cell Above OR Insert → Insert Cell Below 
Copy Cell | c  | Copy Key
Paste Cell | v | Paste Key


### Titles 

You also learned that you can use `Markdown` to create titles and subtitles using the following syntax:

```markdown
# This is the biggest title
## This is a subtitle
### This is a smaller subtitle
#### This is an even smaller subtitle
```

These titles are already present on this page as `Markdown` (e.g. **Markdown Styling** above is a subtitle). 

In a `Jupyter Notebook` file, you can double-click in any `Markdown` cell to see the syntax, and then run the cell again to see the `Markdown` formatting.


### Lists

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
*This is an italicized word, not a bullet list*
**This is a bold word, not a bullet list**

* **This is a bullet item with bold words**
* *This is a bullet item with italicized words*
```

It will render as follows:

*This is an italicized word, not a bullet list*
**This is a bold word, not a bullet list**

* **This is a bullet item with bold words**
* *This is a bullet item with italicized words*


### Hyperlinks

You can also use `Markdown` to create hyperlinks to websites using the following syntax:

```markdown
The course website can be found at <a href="http://earthdatascience.org/courses/earth-analytics-bootcamp/" target="_blank">this link</a>. 

```

It will render as follows:

The course website can be found at <a href="http://earthdatascience.org/courses/earth-analytics-bootcamp/" target="_blank">this link</a>.


### Images

You can also use `Markdown` to link to images on the web using the following syntax:

```markdown
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
   <img src="https://www.fullstackpython.com/img/logos/markdown.png" alt="Markdown Logo"></a>
   <figcaption> This is the Markdown logo. Source: Full Stack Python.
   </figcaption>
</figure>

<div class="notice--warning" markdown="1">

## <i class="fa fa-pencil-square-o" aria-hidden="true"></i> Optional Challenge 1

1. From your `ea-bootcamp-hw-1-yourusername` directory, open the `Jupyter Notebook` file for Homework 1 (`ea-bootcamp-hw-1.ipynb`). Notice that there are existing cells in this notebook. 

2. Add a new `Markdown` cell below the existing cells and include:
    * A title for the notebook (e.g. `Earth Analytics Bootcamp - Homework 1`)
    * A **bullet list** with:
        * A bold word for `Author:` and then add text for your name. 
        * A bold word for `Date:` and then add text for today's date.

</div>

<div class="notice--warning" markdown="1">

## <i class="fa fa-pencil-square-o" aria-hidden="true"></i> Optional Challenge 2

1. From your `markdown` directory created in the previous lesson, open the `Jupyter Notebook` file you created (e.g. `jpalomino-markdown.ipynb`).

2. Add a `Markdown` cell as the first cell of this empty notebook and include:
    * A title for the notebook (e.g. `Earth Analytics Bootcamp - Markdown Reference`)
    * A bold word for `Author:` and then add text for your name (e.g. `Jenny Palomino`)

3. Add another `Markdown` cell below your title cell and include:
    * A list of your three favorite foods (e.g. blueberries, chocolate bars, avocados)
    * A hyperlink (i.e. webpages) for each item in your list of favorite foods
    * An image for each item in your listed favorite foods

</div>
