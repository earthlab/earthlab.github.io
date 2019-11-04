---
layout: single
title: 'DRY Code and Modularity'
excerpt: "DRY code . Learn how to ."
authors: ['Leah Wasser', 'Jenny Palomino']
category: [courses]
class-lesson: ['clean-expressive-code']
permalink: /courses/intro-to-earth-data-science/write-clean-expressive-code/intro-to-clean-code/dry-modular-code/
nav-title: "DRY Modular Code"
dateCreated: 2019-09-03
modified: 2019-11-04
module-type: 'class'
course: "intro-to-earth-data-science-textbook"
week: 5
sidebar:
  nav:
author_profile: false
comments: true
order: 4
topics:
  reproducible-science-and-programming: ['python']
---
{% include toc title="On This Page" icon="file-text" %}

<div class='notice--success' markdown="1">

## <i class="fa fa-graduation-cap" aria-hidden="true"></i> Learning Objectives

* 

</div>


### Don't Repeat Yourself  (DRY)

The DRY approach to programming refers to writing functions and automating sections of code that are repeated. If you perform the same task multiple times in your code, consider a function or a loop to make your workflow more
efficient.



<div class="notice--info" markdown="1">

## <i class="fa fa-pencil-square-o" aria-hidden="true"></i> Additional Resources

* <a href="https://www.python.org/dev/peps/pep-0008/" target="_blank">The PEP 8 Style Guide</a>.

* <a href="https://realpython.com/python-pep8/" target="_blank">How To Write Beautiful Python Code with PEP 8</a>.

* <a href="https://www.safaribooksonline.com/library/view/the-hitchhikers-guide/9781491933213/ch04.html" target="_blank">The Hitchhiker's Guide to Python by Tanya Schlusser and Kenneth Reitz</a>.
    
</div>

## <i class="fa fa-pencil-square-o" aria-hidden="true"></i> Practice Applying PEP 8 To Your Code

Take a look at the code below.

* Create a list of all of the things that could be improved to make the code easier to read / work with.
* Identify changes to specific items that would help the code adhere to the PEP 8 style guide.

<!--

Format Issues:
* missing spaces in between comments
* comments aren't useful to help me understand what is happening
* white space

Object Naming Issues
* didn't use useful object names that describe the object
* one very long object name
* used a mixture of underscore and case that will be easy to confused 

-->

</div>


{:.input}
```python
# Create variable
variable=3*6
meanvariable = variable

#calculate something important
mean_variable = meanvariable * 5

# last step of the workflow
finalthingthatineedtocalculate = mean_variable + 5
```
