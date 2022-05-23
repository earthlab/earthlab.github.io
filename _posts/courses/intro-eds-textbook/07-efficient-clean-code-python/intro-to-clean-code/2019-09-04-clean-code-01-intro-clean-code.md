---
layout: single
title: 'Introduction to Writing Clean Code and Literate Expressive Programming'
excerpt: "Clean code refers to writing code that runs efficiently, is not redundant and is easy for anyone to understand. Learn about the characteristics and benefits of writing clean, expressive code in Python."
authors: ['Leah Wasser', 'Jenny Palomino']
category: [courses]
class-lesson: ['clean-expressive-code-tb']
permalink: /courses/intro-to-earth-data-science/write-efficient-python-code/intro-to-clean-code/
nav-title: "What is Clean Code"
dateCreated: 2019-09-04
modified: 2020-09-03
module-title: 'Learn to Write Clean Code and Literate Expressive Programming'
module-nav-title: 'Write Clean Expressive Code'
module-description: "Clean code refers to writing code that runs efficiently, is not redundant and is easy for anyone to understand. Learn best practices for writing clean, expressive code in Python."
module-type: 'class'
chapter: 16
class-order: 1
course: "intro-to-earth-data-science-textbook"
week: 7
estimated-time: "2-3 hours"
difficulty: "beginner"
sidebar:
  nav:
author_profile: false
comments: true
order: 1
topics:
  reproducible-science-and-programming: ['python']
redirect_from:
  - "/courses/intro-to-earth-data-science/write-clean-expressive-code/intro-to-clean-code/"
  - "/courses/earth-analytics-python/use-time-series-data-in-python/write-clean-code-with-python/"
---
{% include toc title="In This Chapter" icon="file-text" %}

<div class='notice--success' markdown="1">

## <i class="fa fa-ship" aria-hidden="true"></i> Chapter Sixteen - Introduction to Clean Code and Literate Expressive Programming

In this chapter, you will learn about the characteristics and benefits of writing clean, expressive code. You will also learn best practices for writing clean, expressive code in **Python**, including the PEP 8 Style Guide standards.

After completing this chapter, you will be able to:

* List 2-4 characteristics of writing clean code.
* Apply the PEP 8 Style Guide standards to your **Python** code.


## <i class="fa fa-check-square-o fa-2" aria-hidden="true"></i> What You Need

Be sure that you have completed the instructions on <a href="{{ site.url }}/workshops/setup-earth-analytics-python/">Setting up Git, Bash, and Conda on your computer</a> to install the tools for your operating system (Windows, Mac, Linux). 

</div>


## What is Clean Code For Scientific Programming?

Clean code refers to code that is written in a way that is:

* easy to understand, 
* is efficient when run, and 
* is well-documented. 

Clean code will help not only you now, but also your future self if you need to revisit and work on the code in the future. It will also help your colleagues who you may share the code with.

Take a look at the code examples below. Which code block below is easier for you to understand?

Compare the variable `foovar` to `todays_date`. Which one tells you more about the information that it contains?


```python
# Non expressive variable name
>>> import datetime
>>> foovar = datetime.date.today().strftime("%y-%m-%d")
>>> foovar
# '19-09-04'
```

```python
# Expressive variable name 
>>> import datetime
>>> todays_date = datetime.date.today().strftime("%y-%m-%d")
>>> todays_date

# '19-09-04'
```

Now consider the code above if it was just a small part of a much larger script or tool that did many things. Imagine reading that code and trying to understand what the code actually does or its intent.


## Get Started Writing Clean Code in Python

There are several ways that you can begin to write clean code. A few of these include:

1. **Use Code Syntax Standards:** Each programming language has one or more standards or style guides that the community follows. This standard dictates guidelines for spacing, comments, variable names and more. When your code uses a standard syntax approach, it becomes that much easier to scan and understand for both yourself and others. In this textbook, you will learn about PEP 8 standards for **Python**.
1. **Create Expressive Variable and Function Names:** Expressive code uses meaningful variable names that represent the contents of that variable. In the example above, `todays_date` describes the contents of the variable (which is a date) better then `foovar`. Using expressive names makes your code easier to read.
1. **Write Modular Code and Practice: Don't Repeat Yourself (DRY):** rather than repeating chunks of code to automate a workflow, consider using loops and functions to automate tasks. If you use the same set of code more than once, it likely belongs in a function. You will learn more about functions later in this textbook.
2. **Document Your Code:** Documentation can mean many different things. When you are writing code, a combination of expressive names combined with sparsely added comments can go a long way towards making your code easier to read. 

A more advanced topic that you will learn about later in this textbook is pseudocode. Rather than writing code line by line, you should plan out your workflow first. Write out the steps in plain English (or whatever language you prefer!). Then, identify steps that may need to repeat tasks. Once you have a plan for your code, then begin to actually use **Python** to implement that plan. 


### What's Next?

In the next sections of this textbook, you will learn more about writing clean code in **Python**.
