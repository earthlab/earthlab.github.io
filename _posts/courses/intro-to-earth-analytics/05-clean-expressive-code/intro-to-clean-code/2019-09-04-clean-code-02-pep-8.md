---
layout: single
title: 'How to Write Clean Code Using Python: Introduction to PEP 8 Style Guide'
excerpt: "Using a standard format and syntax when programming makes your code easier to read. Learn more about PEP 8, a set of guidelines for writing clean code in Python."
authors: ['Leah Wasser', 'Jenny Palomino']
category: [courses]
class-lesson: ['clean-expressive-code']
permalink: /courses/intro-to-earth-data-science/write-clean-expressive-code/intro-to-clean-code/python-pep-8-style-guide/
nav-title: "PEP 8 Style Guide"
dateCreated: 2019-09-03
modified: 2019-09-05
module-type: 'class'
class-order: 1
course: "intro-to-earth-data-science"
week: 5
sidebar:
  nav:
author_profile: false
comments: true
order: 2
topics:
  reproducible-science-and-programming: ['python']
redirect_from:
  - "/courses/earth-analytics-bootcamp/pep-8-style-guide/"
---

{% include toc title="On This Page" icon="file-text" %}

<div class='notice--success' markdown="1">

## <i class="fa fa-graduation-cap" aria-hidden="true"></i> Learning Objectives

* Describe the benefits of using code standards.
* Explain what the PEP 8 style guide is and how it helps promote code readibility.
* Describe key components of the PEP 8 style guide including naming conventions and white space.
* List tools that can help you apply the PEP 8 style guide to your code.  

</div>

## What Are Code Standards

Code standards refer to rules associated with how code is formatted. These rules can including things like:

* How to space things in a script
* How to create comments
* and even naming conventions


## Why Use Code Standards When Writing Python Code?

Code standards help make your code more readible. Consider reading this textbook. There are some conventions that you follow when you write text such as

* Capitalize the first letter of a sentence.
* Capitalize the first letter of someone's name.
* Add a space after the end of a sentence.
* Add a space after each word.

`This is a sentence. And another sentence with a Name.`

Now imagine reading a book that has no spacing, not capitalization and no conventions. This book would become increasingly hard to read.

`this is a sentence.nnd another sentence with a name.this 
text could go on forever. whatwouldhappenifweneverusedspaces?`

Code standards, just like any other language standard, are designed to make code easier to understand. 

Below, you will learn about the PEP 8 standard for the **Python** scientific programming language. This is the standard used by many **Python** users and the one that we will use in this textbook and in all of our **earth-analytics** courses.

## About the PEP 8 Standard for Python

PEP 8 is the style guide that is widely used in the **Python** community. This guide includes rules about naming objects, spacing rules and even how the code is layed out.  

**Python** is developed and maintained by an open source community, and thus, it is not really possible to enforce the standard in mandatory way. Rather, community members choose to adhere to PEP 8 recommendations whenever possible, so that they can contribute code that can easily be read and used by the greater community of users. 

PEP 8 covers many aspects of code readibility including:
* naming conventions
* use of comments
* line lengths
* use of white space


## PEP 8 Naming Conventions

The text in this section is summarized from the <a href="https://www.python.org/dev/peps/pep-0008/#naming-conventions" target="_blank">PEP8 Style Guide published by the Python Software Foundation</a>.


### PEP 8 Descriptive Naming Conventions

First, let's review some terminology associated with naming conventions. 


* **Lowercase letter:** `b` 

* **Uppercase letter:** `B`

* **lowercase:** `this is all lowercase words`

* **snake case:** when words are separated by underscores: `lower_case_with_underscores`

* **Uppercase:** All words are all uppercase letters: `UPPERCASE`

* **Snake case** upper case: `UPPER_CASE_WITH_UNDERSCORES`

* **CamelCase:** Every word is capitalized so they visually stand out: `CapitalizedWords`. This is sometimes also referred to as CapWords or StudlyCaps.

    * Note: When using acronyms in CamelCase, capitalize all the letters of the acronym. Thus HTTPServerError is better than HttpServerError.

* **mixedCase:** (differs from CapitalizedWords by initial lowercase character!)

* Capitalized_Words_With_Underscores (ugly!)


### Names to Avoid

Never use the characters 'l' (lowercase letter el), 'O' (uppercase letter oh), or 'I' (uppercase letter eye) as single character variable names.

In some fonts, these characters are indistinguishable from the numerals one and zero. When tempted to use 'l', use 'L' instead.


> [name=Leah Wasser] i think we should add links to the pep 8 pages that talk about each of these things somewhere?
> 
## Comments


https://www.python.org/dev/peps/pep-0008/#comments


PEP 8 guidelines specify the following

###  Single line comments (`#`)

Add a space after the pound sign and capitalize the first word - like this:

`# This is  a pep8 conforming comment`

The comment below does NOT conform to PEP8 standards
`#this is not a pep8 conforming comment`


###  Multi-line comments Used in Functions - docstrings

https://www.python.org/dev/peps/pep-0008/#documentation-strings

* Some ideas to add:
    * Format
    * Example


"""Returns a numpy array. 

Function that calculated somethign and returns a numpy array with values.
"""


## Line Length

PEP8 guidelines suggest that code should be 80 characters wide or less. 


* Some ideas to add:
    * Code line recommended length 
    * Comment line recommended length 


## White Space

* Some ideas to add:
    * add space after `#` in single line comments 

    * add blank line before a single line comment (unless it is the first line of a cell in Jupyter Notebook)
    * add blank line after a set of related code
    * spaces within code lines (e.g. `weight_kg=weight_lb*0.453592` vs `weight_kg = weight_lb * 0.453592` )

```python
    #poorly formatted  comments are missing the space after the pound sign.
    # good comments have a space after the pound sign
```


## Tools For Applying PEP 8 To Your Code

> *Conforming your Python code to PEP 8 is generally a good idea and helps make code more consistent when working on projects with other developers. The PEP 8 guidelines are explicit enough that they can be programmatically checked* (from the <a href="https://www.safaribooksonline.com/library/view/the-hitchhikers-guide/9781491933213/ch04.html" target="_blank">The Hitchhiker's Guide to Python by Tanya Schlusser and Kenneth Reitz</a>). 

There are a few packages developed by the `Python` community that can help you check that your code is adhering to PEP 8 standards:

* <a href="https://pep8.readthedocs.io/en/release-1.7.x/" target="_blank">pep8</a>, a `Python` package that can help you check your code for adherence to the PEP 8 style guide. 
* <a href="https://github.com/hhatto/autopep8" target="_blank">autopep8</a>, another `Python` package that can be used to modify files to the PEP 8 style guide.

`Python` community members expect that your code will adhere to the PEP 8 standard, and if it does not, they generally will not be shy to tell you that your code is not "Pythonic"! 

<div class="notice--info" markdown="1">

## <i class="fa fa-pencil-square-o" aria-hidden="true"></i> Additional Resources

* <a href="https://www.python.org/dev/peps/pep-0008/" target="_blank">The PEP 8 Style Guide</a>

* <a href="https://realpython.com/python-pep8/" target="_blank">How To Write Beautiful Python Code with PEP 8</a>

* <a href="https://www.safaribooksonline.com/library/view/the-hitchhikers-guide/9781491933213/ch04.html" target="_blank">The Hitchhiker's Guide to Python by Tanya Schlusser and Kenneth Reitz</a>
    
</div>
