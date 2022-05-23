---
layout: single
title: "Introduction to Writing Functions in Python"
excerpt: "A function is a reusable block of code that performs a specific task. Learn how functions can be used to write efficient and DRY (Do Not Repeat Yourself), code in Python."
authors: ['Jenny Palomino', 'Leah Wasser']
category: [courses]
class-lesson: ['intro-functions-tb']
permalink: /courses/intro-to-earth-data-science/write-efficient-python-code/functions-modular-code/
nav-title: "Intro to Functions"
dateCreated: 2019-11-05
modified: 2021-01-28
module-title: 'Introduction to Functions in Python'
module-nav-title: 'Intro to Functions in Python'
module-description: 'A function is a reusable block of code that performs a specific task and can help you to eliminate repetition and improve efficiency in your code through modularity. Learn how to write functions in Python to write Do Not Repeat Yourself, or DRY, code in Python.'
module-type: 'class'
class-order: 4
chapter: 19
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
  - "/courses/earth-analytics-bootcamp/functions/intro-functions/"
  - "/courses/intro-to-earth-data-science/write-efficient-python-code/functions/" 
---
{% include toc title="In This Chapter" icon="file-text" %}

<div class='notice--success' markdown="1">

## <i class="fa fa-ship" aria-hidden="true"></i> Chapter Nineteen - Functions

In this chapter, you will learn how functions can be used to write DRY and modular code that helps eliminate repetition and improve the efficiency of **Python** code.


## <i class="fa fa-graduation-cap" aria-hidden="true"></i> Learning Objectives

After completing this chapter, you will be able to:

* Explain how using functions help you to write DRY (Don't Repeat Yourself) code in **Python**.
* Describe the components needed to define a function in **Python**.
* Write and execute a custom function in **Python**.
* Write nested functions (functions inside of other functions) in **Python**. 


## <i class="fa fa-check-square-o fa-2" aria-hidden="true"></i> What You Need

You should have Conda setup on your computer and the Earth Analytics Python Conda environment. Follow the <a href="{{ site.url }}/workshops/setup-earth-analytics-python/setup-git-bash-conda/">Set up Git, Bash, and Conda on your computer</a> to install these tools.

Be sure that you have completed the chapters on <a href="{{ site.url }}/courses/intro-to-earth-data-science/open-reproducible-science/jupyter-python/">Jupyter Notebook</a>, <a href="{{ site.url }}/courses/intro-to-earth-data-science/scientific-data-structures-python/numpy-arrays/">Numpy Arrays</a>, and <a href="{{ site.url }}/courses/intro-to-earth-data-science/scientific-data-structures-python/pandas-dataframes/">Pandas Dataframes</a>.

</div>


## Write Efficient Modular Code Using Functions

In the introduction to DRY code, you learned about the DRY (i.e. Do Not Repeat Yourself) code principle. You were also introduced to three strategies for eliminating repetition and improving the efficiency of your code: 

1. loops, 
2. conditional statements, and 
3. functions. 

In previous chapters, you learned how to use conditional structures to control the flow of your code and how to loops to eliminate repetitive lines of code. In this chapter, you will learn how writing functions in **Python** can help you to execute a specific task.

A function is a reusable block of code that performs a specific task. Functions receive inputs to which code is applied and return outputs (or results) of the code. 

`input parameter –> function does something –> output results`

For example:

```python
x = 5

# Print value of input
print(x)
```

which returns:

```python
5

```

Functions can help you to both eliminate repetition and improve efficiency in your code through modularity. 

Modularity means that code is separated into independent units that can be reused and even be combined to complete a longer chain of tasks. 


<figure>
 <a href="{{ site.url }}/images/earth-analytics/clean-code/write-functions-for-all-things.png">
 <img src="{{ site.url }}/images/earth-analytics/clean-code/write-functions-for-all-things.png" alt="You can implement strategies such as loops and functions in your code to replace tasks that you are performing over and over. Source: Francois Michonneau."></a>
 <figcaption> You can implement strategies such as loops and functions in your code to replace tasks that you are performing over and over. Source: Francois Michonneau.
 </figcaption>
</figure>


## The Benefits of Functions

* Modularity: Functions only need to be defined once in a workflow (e.g. **Jupyter Notebook** file, script). Functions that you write for specific tasks can be used over and over, without needing to redefine the function again. A function that you write for one **Python** workflow can also be reused in other workflows!

* Fewer variables: When you run a function, the intermediate variables (i.e. placeholders) that it creates are not stored as explicit variables unless you specify otherwise. This saves memory and keeps your **Python** environment cleaner. 

* Better documentation: Well-documented functions help other users understand the steps of your processing and helps your future self to understand previously written code.

* Easier to maintain and edit your code: Because a function is only defined once in the workflow, you can simply just update the original function definition. Then, each instance in which you call that function in your code (i.e. when same task is performed) is automatically updated.

* Testing: You won’t learn about this in this class, but writing functions allows you to more easily test your code to identify issues (i.e. bugs).


### Write Modular Functions and Code

A well-defined function only does one thing, but it does it well and often in a variety of contexts. Often, the operations contained in a good function are generally useful for many tasks. 

Take, for instance, the **numpy** function called `mean()`, which computes mean values from a **numpy** array.

This function only does one thing (i.e. computes a mean); however, you may use the `np.mean()` function many times in your code on multiple **numpy** arrays because it has been defined to take any **numpy** array as an input. 

For example:

```python
arr = np.array([1, 2, 3])

# Calculate mean of input array
np.mean(arr)
```

which returns:

```python
2.0

```

The `np.mean()` function is modular, and it can be easily combined with other functions to accomplish a variety of tasks.

When you write modular functions, you can re-use them for other workflows and projects. Some people even write their own **Python** packages for personal and professional use that contain custom functions for tasks that they have to complete regularly.


### Functions Create Fewer Variables

When you code tasks line by line, you often create numerous intermediate variables that you do not need to use again. 

This is inefficient and can cause your code to be repetitive, if you are constantly creating variables that you will not use again. 

Functions allow you to focus on the inputs and the outputs of your workflow, rather than the intermediate steps, such as creating extra variables that are not needed.


## Reasons Why Functions Improve Code Readability

### Functions Can Result in Better Documentation

Ideally, your code is easy to understand and is well-documented with **Python** comments (and **Markdown** in **Jupyter Notebook**). However, what might seem clear to you now might not be clear 6 months from now, or even 3 weeks from now.

Well-written functions help you document your workflow because:
* They are well-documented by clearly outlining the inputs and outputs.
* They use descriptive names that help you better understand the task that the function performs.


### Expressive Function Names Make Code Self-Describing

When writing your own functions, you should name functions using verbs and/or clear labels to indicate what the function does (i.e. `in_to_mm` for converting inches to millimeters). 

This makes your code more expressive (or self-describing), and in turn, makes it easier to read for you, your future self, and your colleagues.


### Modular Code is Easier to Maintain and Edit

If all your code is written line by line (with repeated code in multiple parts of your document) it can be challenging to maintain and edit.

Imagine having to fix one element of a line of code that is repeated many times. You will have to find and replace that code to implement the fix in EVERY INSTANCE it occurs in your code!

You may also be duplicating your comments where you duplicate parts of your code. So how do you keep the duplicated comments in sync? 

A comment that is misleading because the code changed is actually worse than no comment at all.

Organizing your code using functions from the beginning allows you to explicitly document the tasks that your code performs, as all code and documentation for the function is contained in the function definition.


### You Can Incorporate Testing To Ensure Code Runs Properly

While you will not learn about testing in this chapter, note that functions are also very useful for testing. 

As your code gets longer and more complex, it is more prone to mistakes. For example, if your analysis relies on data that gets updated often, you may want to make sure that all the columns in your spreadsheet are present before performing an analysis. Or, that the new data are not formatted in a different way.

Changes in data structure and format could cause your code to not run. Or, in the worse case scenario, your code may run but return the wrong values!

If all your code is made up of functions (with built-in tests to ensure that they run as expected), then you can control the input to the function and test that the output returned is correct for that input. It is something that would be difficult to do if all of your code is written line by line with repeated steps.


## Summary of Writing Modular Code with Functions

It is a good idea to learn how to:

1. Modularize your code into generalizable tasks using functions.
2. Write functions for parts of your code which include repeated steps.
3. Document your functions clearly, specifying the structure of the inputs and outputs with clear comments about what the function can do.

In the rest of the chapter, you will learn about the components needed to define a function in **Python** and you will write and execute custom functions in **Python**.
