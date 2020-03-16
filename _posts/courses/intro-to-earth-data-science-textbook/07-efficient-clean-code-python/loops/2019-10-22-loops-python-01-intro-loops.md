---
layout: single
title: "Intro to Loops in Python"
excerpt: "Loops can help reduce repetition in code by iteratively executing the same code on a range or list of values. Learn about the basic types of loops in Python and how they can be used to write Do Not Repeat Yourself, or DRY, code in Python."
authors: ['Jenny Palomino', 'Leah Wasser']
category: [courses]
class-lesson: ['intro-loops-tb']
permalink: /courses/intro-to-earth-data-science/write-efficient-python-code/loops/
nav-title: "Intro to Loops"
dateCreated: 2019-10-23
modified: 2020-01-08
module-title: 'Introduction to Loops in Python'
module-nav-title: 'Loops in Python'
module-description: 'Loops can help reduce repetition in code by iteratively executing the same code on a range or list of values. Learn how to write loops in Python to write Do Not Repeat Yourself, or DRY, code in Python.'
module-type: 'class'
class-order: 3
chapter: 18
course: "intro-to-earth-data-science-textbook"
week: 7
sidebar:
  nav:
author_profile: false
comments: true
order: 1
topics:
  reproducible-science-and-programming: ['python']
redirect_from:
  - "/courses/earth-analytics-bootcamp/loops/intro-loops/"
  - "/courses/intro-to-earth-data-science/dry-code-python/loops/"
---
{% include toc title="In This Chapter" icon="file-text" %}

<div class='notice--success' markdown="1">

## <i class="fa fa-ship" aria-hidden="true"></i> Chapter Eighteen - Loops

In this chapter, you will learn about the basic types of loops in **Python** and how you can use them to remove repetition in your code by iteratively executing code on a range or list of values. 


## <i class="fa fa-graduation-cap" aria-hidden="true"></i> Learning Objectives

After completing this chapter, you will be able to:

* Explain how using loops help you to write DRY (Don't Repeat Yourself) code in **Python**.
* Describe the syntax for two basic looping structures used in **Python**: `while` and `for`.
* Remove repetition in code by using loops to automate data tasks.  


## <i class="fa fa-check-square-o fa-2" aria-hidden="true"></i> What You Need

You should have Conda setup on your computer and the Earth Analytics Python Conda environment. Follow the <a href="{{ site.url }}/workshops/setup-earth-analytics-python/setup-git-bash-conda/">Set up Git, Bash, and Conda on your computer</a> to install these tools.

Be sure that you have completed the chapters on <a href="{{ site.url }}/courses/intro-to-earth-data-science/open-reproducible-science/jupyter-python/">Jupyter Notebook</a>, <a href="{{ site.url }}/courses/intro-to-earth-data-science/scientific-data-structures-python/numpy-arrays/">Numpy Arrays</a>, and <a href="{{ site.url }}/courses/intro-to-earth-data-science/scientific-data-structures-python/pandas-dataframes/">Pandas Dataframes</a>.

</div>


## Why Use Loops

A loop is a sequence of operations that are performed over and over in some specified order. Loops can help you to eliminate repetition in code by replacing duplicate lines of code with an iteration, meaning that you can iteratively execute the same code line or block until it reaches a specified end point.

Instead of copying and pasting the same code over and over to run it multiple times (say, on multiple variables or files), you can create a loop that contains one instance of the code and that executes that code block on a range or list of values that you provide. 

For example, the following lines could be replaced by a loop that iterates over a list of variable names and executes the `print()` function until it reaches the end of the list:

```python
print(avg_monthly_precip)
print(months)
print(precip_2002_2013)
```

You can create lists of variables, filenames, or other objects like data structures upon which you want to execute the same code. These lists can then be used to execute the code iteratively on each item in the list.

You can also provide a numerical range of values to control how many times the code is executed. 

In **Python**, there are two primary structures for loops: `while` and `for`. Below you will learn about each one and how they can help you to write DRY (Don't Repeat Yourself) code. 


## While Loops

A `while` loop is used to iteratively execute code until a pre-defined condition is no longer satisfied (i.e. results in a value of `False`). 

That condition could be a limit on how many times you want the code to run, or that results of the code reach a certain value (e.g. code will iteratively execute as long as the current value of the results is less than 5).

After the pre-defined condition is no longer `True`, the loop will not execute another iteration. 


```python
while x < 5:
    execute some code here
```

Notice that the loop begins with `while` followed by a condition that ends with a colon `:`. 

Also, notice that the code below the `while` statement is indented. This indentation is important, as it indicates that the code will be executed as part of the loop within it is contained, not after the loop is completed.

Check out the examples below to see the `while` loop in action.  

The first example uses a `while` loop to iteratively add a value of `1` to a variable `x`, as long as the current value of `x` does not exceed a specified value.

In this example, a comparison operator (e.g. `<`) is used to compare the value of `x` (which begins with value of `0`) to the value `10`, the designated end point.

Within the loop, an assignment operator (`+=`) is used to add a value of `1` to `x`, and the current value of `x` is printed. This process repeats each time that the code iterates, until the current value of `x` is no longer less than `10`.

{:.input}
```python
# Set x equal to 0
x = 0

# Add 1 to x until x is no longer less than 10
while x < 10:
    x += 1
    print(x)
```

{:.output}
    1
    2
    3
    4
    5
    6
    7
    8
    9
    10



Once `x` reaches 10, the condition is no longer true (as `x` is no longer less than `10`), so the loop ends and does not execute another iteration of the code. 

Note that to use the value of the variable `x` as a condition for the loop, you must use the correct variable name in the loop (e.g. `x`), so that the condition can check the status of `x` as the loop iterates.

Also, note that the code within the loop is executed in order, meaning that the `print()` function executes after the value of `1` is added to `x`. 

You can change that order if you want to see the value of `x`, before the value of `1` has been added.  

{:.input}
```python
# Reset x equal to 0
x = 0

# Add 1 to x until x is no longer less than 10
while x < 10:
    print(x)
    x += 1
    
print("Final value:", x)
```

{:.output}
    0
    1
    2
    3
    4
    5
    6
    7
    8
    9
    Final value: 10



In this version of the loop, the value of `x` is printed first, and then, the assignment operator is executed to add a value of `1` to `x`. 

Note that any code provided after the loop ends will be executed at that point (e.g. the printing of the final value). 

Compare the first `while` loop to the code below that you would have to write to accomplish the same task without a loop. 

The `while loop` not only replaces many lines of code to remove repetition, but it also makes the code easier to read *and* write, making the workflow easier for everyone involved. 

{:.input}
```python
# Reset x equal to 0
x = 0

# Add 1 to x
x += 1
print(x)

# Add 1 to x
x += 1
print(x)

# Add 1 to x
x += 1
print(x)

# Add 1 to x
x += 1
print(x)

# Add 1 to x
x += 1
print(x)

# Add 1 to x
x += 1
print(x)

# Add 1 to x
x += 1
print(x)

# Add 1 to x
x += 1
print(x)

# Add 1 to x
x += 1
print(x)

# Add 1 to x
x += 1
print(x)
```

{:.output}
    1
    2
    3
    4
    5
    6
    7
    8
    9
    10



In addition to using comparison operators to compare values, you can also specify a range of values to limit the duration of the `while` loop. 

The range is inclusive of the starting value, but not of the ending value. 

{:.input}
```python
# Set x equal to 1
x = 1

# Add 1 to x, while x is between 1 and 5
while x in range(1,5):
    x += 1
    print(x)
```

{:.output}
    2
    3
    4
    5



Note that the structure of the `while` loop remains the same, regarding the use of a condition, colon, and indentations of the code that will be iterated. 

In this example, rather than using an explicit comparison operator, you are stating that the code below can continue to execute as long as the value of `x` remains within a certain range.

Specifically, the code will execute as long as the value of `x` exists within a numeric range that begins at `1` to and ends with `5`, but is not inclusive of `5`. 

Thus, the loop ends when `x` reaches `5` and does not execute another iteration of the code.   


## For Loops

Another useful loop is a `for` loop, which will iteratively execute code for each item in a pre-defined list. 

This list can be composed of numeric values, filenames, individual characters in a text string, objects such as data structures, etc.  

Similar to the `while` loop, the syntax of a `for` loop includes rule (followed by a colon `:`) and indentations of the code lines that will be iterated. 

The main differences are that the loop begins with the word `for` and that a pre-defined list is explicitly referenced in the loop (e.g. `item_list` in the example below). The list to iterate upon is defined before the code for the `for` loop. 

```python
item_list = [item_1, item_2, item_3]

for i in item_list:
    execute some code here
```

There is also a placeholder in the loop (e.g. `i`) that represents the items of the list. The initial value of `i` is equal to the first item in the list; as the loop iterates through the list, the value of `i` changes to hold the value of the next item in the list.

In the first example below, a list with 4 non-sequential values is created. The loop executes the provided code (e.g. `print()`) on each item in the list. 

{:.input}
```python
# Create list of integers
num_list = [12, 5, 136, 47]

# For each item in list, add 10 and print new value
for i in num_list:
    i += 10
    print(i)    
```

{:.output}
    22
    15
    146
    57



Note that in this example, the values are not in sequential order or follow any kind of pattern. However, the loop is executed on each item, in the same order in which they are defined in the list. 

This is a unique characteristic of `for` loops; the placeholder represents the value of whichever item is being accessed from the list in that iteration. 

Thus, `i` is not a pre-defined variable, but rather a placeholder for the current item that the loop is working with in each iteration of the code.  

This means that you could use any word or character to indicate the placeholder, with the exception of numeric values. 

You simply need to reuse that same word or character in the code lines that are being executed, in order to use the placeholder to access the items in the list. 

For example, the placeholder could be called `x`, or even something completely unrelated like `banana`. 

{:.input}
```python
# Reset list of integers
num_list = [12, 5, 136, 47]

# For each item in list, add 10 and print new value
for x in num_list:
    x += 10
    print(x)   
```

{:.output}
    22
    15
    146
    57



{:.input}
```python
# Reset list of integers
num_list = [12, 5, 136, 47]

# For each item in list, add 10 and print new value
for banana in num_list:
    banana += 10
    print(banana)   
```

{:.output}
    22
    15
    146
    57



In this first example, `num_list` contains only numeric values, but you can also iterate on lists that contain other types, such as text strings for the names of files or data structures (including even the names of other lists!).  

### For Loops on Text Strings

In the example below, a list called `files` is defined with two text strings that represent two filenames. The `for` loop will run iteratively on each text string (represented by the placeholder `fname` in each iteration). 

In the first iteration of the loop, `fname` is equal to the text string `"months.txt"`; in the second iteration, `fname` represents the text string `"avg-monthly-precip.txt"`. 

{:.input}
```python
# List of filenames
files = ["months.txt", "avg-monthly-precip.txt"]

# For each item in list, print value
for fname in files:
    print(fname)   
```

{:.output}
    months.txt
    avg-monthly-precip.txt



Note that `print()` returns the text string that is the filename, but not the values in the file. 

This is because the list only contains text strings for the filenames, but does not actually contain the contents of the file. In fact, **Python** does not know that these text strings are filenames; it simply treats these as text string items in a list.  

Taking another look at the definition of the list, you can notice that the items are just text strings identified by quotes `""`.  The list does not contain variables or objects that have been defined (e.g. **numpy** arrays, **pandas** dataframes, or even other lists). 

Thus, it is important to remember that the objects that you use in the loop will determine what output you will receive.

### For Loops on Data Structures

For example, you can define a list that contains multiple objects (say, other lists). 

In the example below, the `print()` returns the actual values in each item in the list because the items are defined objects (in this example, each item is its own list of data values). 

In each iteration of the loop, `dlist` represents the data lists that you defined: in first iteration, `months`, and `avg_monthly_precip` in the second iteration. 

{:.input}
```python
# Create list of abbreviated month names
months = ["Jan", "Feb", "Mar", "Apr", "May", "June",
         "July", "Aug", "Sept", "Oct", "Nov", "Dec"]

# Create list of average monthly precip (inches) in Boulder, CO
avg_monthly_precip = [0.70,  0.75, 1.85, 2.93, 3.05, 2.02, 
                      1.93, 1.62, 1.84, 1.31, 1.39, 0.84]

# List of list names
lists = [months, avg_monthly_precip]

# For each item in list, print value
for dlist in lists:
    print(dlist)   
```

{:.output}
    ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'June', 'July', 'Aug', 'Sept', 'Oct', 'Nov', 'Dec']
    [0.7, 0.75, 1.85, 2.93, 3.05, 2.02, 1.93, 1.62, 1.84, 1.31, 1.39, 0.84]



When working with data structures such as lists, **numpy** arrays, or **pandas** dataframes, the code that is executed in the loop is still subject to the object type that is provided. 

For example, because the items in `lists` are lists, then you can execute any code that can run on the list object type, such as querying the length of the list or for a specific index value. 

{:.input}
```python
# For each list in lists, print the length
for dlist in lists:
    print(len(dlist))   
```

{:.output}
    12
    12



{:.input}
```python
# For each list in lists, print the value at last index
for dlist in lists:
    print(dlist[-1])
```

{:.output}
    Dec
    0.84



However, you would not be able to call a method or attribute that does not exist for that data structure.

For example, while `.shape` is an attribute of **numpy** arrays that provides the number of elements, or rows and columns, `.shape` is not an attribute of lists.

An attempt to call `.shape` on a list would result in an error, and thus, a failure of the loop as it cannot execute that code.

```python
# For each list in lists, print attribute shape
for dlist in lists:
    print(dlist.shape)
```

`AttributeError: 'list' object has no attribute 'shape'`

In the rest of this chapter, you will continue to apply loops to data structures, including lists,**numpy** arrays and **pandas dataframes** and learn how to automate data tasks using loops.
