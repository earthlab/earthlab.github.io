---
layout: single
title: 'Clean Code Syntax for Python: Introduction to PEP 8 Style Guide'
excerpt: "Using a standard format and syntax when programming makes your code easier to read. Learn more about PEP 8, a set of guidelines for writing clean code in Python."
authors: ['Leah Wasser', 'Jenny Palomino']
category: [courses]
class-lesson: ['clean-expressive-code-tb']
permalink: /courses/intro-to-earth-data-science/write-efficient-python-code/intro-to-clean-code/python-pep-8-style-guide/
nav-title: "PEP 8 Style Guide"
dateCreated: 2019-09-03
modified: 2020-09-23
module-type: 'class'
course: "intro-to-earth-data-science-textbook"
week: 7
sidebar:
  nav:
author_profile: false
comments: true
order: 2
topics:
  reproducible-science-and-programming: ['python']
redirect_from:
  - "/courses/earth-analytics-bootcamp/pep-8-style-guide/"
  - "/courses/intro-to-earth-data-science/write-clean-expressive-code/intro-to-clean-code/python-pep-8-style-guide/"
---
{% include toc title="On This Page" icon="file-text" %}

<div class='notice--success' markdown="1">

## <i class="fa fa-graduation-cap" aria-hidden="true"></i> Learning Objectives

* Describe the benefits of using code standards.
* Explain what the PEP 8 style guide is and how it helps promote code readibility.
* Describe key components of the PEP 8 style guide including naming conventions and white space.
* List tools that can help you apply the PEP 8 style guide to your code.  

</div>

## What Are Code Syntax Standards

Code syntax standards refer to rules associated with how code is formatted. These rules can including things like:

* How to space code elements in a script
* How to format and create comments
* Naming conventions for variables, functions and classes


## Why Use Code Standards When Writing Python Code

Code standards help make your code more readable. Consider reading this textbook. There are some conventions that are followed in this textbook that most of us are familiar with (but may not even think about). These conventions include:  

* Capitalize the first letter of a sentence.
* Capitalize the first letter of someone's name.
* Add a space after the end of a sentence.
* Add a space after each word.

These conventions lead to text that you can read easily, like this:

`This is a sentence. And another sentence with a Name and a location like Florida, USA.`

Now imagine reading a book that has no spacing, no capitalization and didn't follow the regular English language writing conventions that you know. This book would become increasingly hard to read. For example have a look at the example below:

`this is a sentence.and another sentence with a name.this 
text could go on forever. whatwouldhappenifweneverusedspaces?`

Code standards, just like any other language standard, are designed to make code easier to understand. 

Below, you will learn about the PEP 8 standard for the **Python** scientific programming language. This is the standard used by many **Python** users and the one that we will use in this textbook and in all of our **earth-analytics** courses.

## About the PEP 8 Standard for Python

PEP 8 is the style guide that is widely used in the **Python** community. This guide includes rules about naming objects, spacing rules and even how the code is laid out.  

**Python** is developed and maintained by an open source community, and thus, it is not really possible to enforce the standard in mandatory way. Rather, community members choose to adhere to PEP 8 recommendations whenever possible, so that they can contribute code that can easily be read and used by the greater community of users. 

PEP 8 covers many aspects of code readibility including:
* naming conventions
* use of comments
* line lengths
* use of white space


## PEP 8 Naming Conventions

The text in this section is summarized from the <a href="https://www.python.org/dev/peps/pep-0008/#naming-conventions" target="_blank">PEP 8 Style Guide published by the Python Software Foundation</a>.


### Naming Convention Terminology Review 

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

* **Capitalized_Words_With_Underscores:** This approach is not recommended. Use one convention and stick with it.


### Name Variables Using snake_case And All Lower Case
In general, it is recommended that you keep naming conventions standard in your code. We suggest a convention that uses **snake_case** and all lowercase letters in your code for variable and function names.

```
variable_one
variable_two
```


### Name Classes Using CamelCase or CapsCase
While regular variables and functions should use snake_case, PEP 8
suggests that you use `CamelCase` for class definitions.

```
class PlotBasicObject(object):
```

### Avoid Using Single Character Letters That Could Be Confused with Numbers  

Avoid using the characters:

* 'l' (lowercase letter el), 
* 'O' (uppercase letter oh), or
* 'I' (uppercase letter eye) 
 
as single character variable names.

These characters can be difficult to distinguish from numbers when 
using certain font families. 

For example, the letter `l` can sometimes look a lot like the number `1`. If you need to use the letter `l` as a variable (this is not suggested!), considering user an uppercase letter instead. 

## Python PEP 8 Documentation Standards for Comments

Documentation is an important part of writing great code. Below are some 
of the important PEP 8 conventions associated with documentation.

### 1. Python Comments Should Have a Space After the `#` Sign with the First Word Capitalized 

Following <a href="https://www.python.org/dev/peps/pep-0008/#comments" target="_blank">the PEP8 style guide</a>, single line comments should 
start with the `#` sign followed by a space. The first word of the comment should be capitalized. Like this:

`# This is a PEP 8 conforming comment`

The comment below does NOT conform to PEP8 standards

`#this comment does not conform to PEP 8 standards`


###  2. Multi-line comments Used in Functions (docstrings) Should Have a Short Single Line Description Followed By More Text

Multi-line comments are most commonly used when creating docstrings. A docstring is the text that follows a function definition. This text helps you or someone using a function understand what the function does. You 
will learn more about docstrings later in this textbook.

Following <a href="https://www.python.org/dev/peps/pep-0008/#documentation-strings" target="_blank">the PEP8 style guide</a>, you create a function docstring using three quotes `"""`. The first line or text following the quotes should be a short, concise description of what the function does. 

Below that, you can add as much text as you'd like that provides more detail about what the function does.  

example:

```python
def calculate_sum(rainfall, time="month"):

"""Returns a single sum value of all precipitation. 

This function takes a pandas dataframe with time series as the index, 
and calculates the total sum, aggregated by month. 
"""
# Code here 

return the_total_sum
```


## Line Length

PEP 8 guidelines suggest that each line of code (as well as comment lines) should be 79 characters wide or less. This is a common standard that is also used in other languages including **R**.

<i fa fa-star></i>**Data Tip:** Most text editors allow you to set up guides that allow you to see how long your code is. You can then use these guides to create line breaks in your code. 
{: .notice--success }


## Python PEP 8 Rules for White Space

Some of the white space rules have already been discussed above. These including adding a single space after a comment `# Comment here`. 

There are also rules associated with spacing throughout your code. These include:

* **Add blank line before a single line comment (unless it is the first line of a cell in Jupyter Notebook)** Blank lines help to visually break up code. Consider reading this textbook, if all of the text was mashed together in one long paragraph, it would be more difficult to read. However, when you break the text up into related paragraphs, it becomes a lot easier to read.

```python

# Perform some math
a = 1+2
b = 3+4
c = a+b 

# Read in and plot some 
precip_timeseries = pd.readcsv("precip-2019.csv")
precip_timeseries.plot()
```

The code below is more difficult to read as the spacing does not break up the text.

```python
# Perform some math and do some things 
a=1+2
b=3+4
c=a+b 
data=pd.readcsv("precip-2019.csv")
data.plot()
```


* **Break up sections of code with white space:** As you are writing code, it's always good to consider readability and to break up sections of code accordingly. Breaking up your 
code becomes even more important when you start working in Jupyter Notebooks which offer individual cells where you can add Markdown and code.


```python
# Process some data here 
data=pd.readcsv("precip-2019.csv")

# Plot data - notice how separating code into sections makes it easier to read
fig, ax = plot.subplots()
data.plot(ax=ax)
plt.show()
```

## Summary -- PEP 8 and Python

The text above provides a broad overview of some of the PEP 8 guidelines and conventions for writing **Python** code. It is not fully inclusive all of all the standards which are included in the full, online PEP 8 documentation. 


## Tools For Applying PEP 8 Formatting To Your Code

There are many different tools that can help you write code that is PEP 8 compliant. A tool that checks the format of your code is called a linter.

Some linters will reformat your code for you to match the standards. These include tools like Black. Or the autopep8 tool for Jupyter Notebook. 

Other linters will simply check your code and tell you if things need to be fixed. A few **Python** packages that perform linting are listed below. 

In the earth-analytics courses, you will learn how to use the **autopep8** tool within Jupyter Notebook.


* <a href="https://pep8.readthedocs.io/en/release-1.7.x/" target="_blank">pep8</a>, a `Python` package that can help you check your code for adherence to the PEP 8 style guide. 
* <a href="https://github.com/hhatto/autopep8" target="_blank">autopep8</a>, another `Python` package that can be used to modify files to the PEP 8 style guide.

`Python` community members expect that your code will adhere to the PEP 8 standard, and if it does not, they generally will not be shy to tell you that your code is not "Pythonic"! 

<div class="notice--info" markdown="1">

## <i class="fa fa-pencil-square-o" aria-hidden="true"></i> Additional Resources

* <a href="https://www.python.org/dev/peps/pep-0008/" target="_blank">The PEP 8 Style Guide</a>

* <a href="https://realpython.com/python-pep8/" target="_blank">How To Write Beautiful Python Code with PEP 8</a>

* <a href="https://www.safaribooksonline.com/library/view/the-hitchhikers-guide/9781491933213/ch04.html" target="_blank">The Hitchhiker's Guide to Python by Tanya Schlusser and Kenneth Reitz</a>
    
</div>
