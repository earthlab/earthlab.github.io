---
layout: single
title: 'Basic Operators in Python'
excerpt: "Operators are symbols in Python that carry out a specific computation, or operation, such as arithmetic calculations. Learn how to use basic operators in Python."
authors: ['Jenny Palomino', 'Leah Wasser']
category: [courses]
class-lesson: ['python-fundamentals']
permalink: /courses/intro-to-earth-data-science/python-fundamentals/get-started-python/python-operators/
nav-title: "Python Operators"
dateCreated: 2019-07-01
modified: 2019-09-06
module-type: 'class'
class-order: 1
course: "intro-to-earth-data-science"
week: 4
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

* Explain how operators are used in **Python** to execute a specific computation or operation.
* Write **Python** code to run different operations on data (e.g. arithmetic calculations)

</div>


## What are Operators in Python?

Operators are symbols in Python that carry out a specific computation, or operation. The value or condition that the operator operates on is called the operand. 

The operand can be a variable (e.g. `jan_precip_in` which has some value, say, 0.70) or data structure like a list (e.g. `months`). The operand can also be an expression or statement (e.g. checking that list `months` contains the value `January`). 

There are <a href="https://python-reference.readthedocs.io/en/latest/docs/operators/" target="_blank">many different types of operators</a> in **Python** including: 

| Operator | Usage | Example |
|:-----------------------------------|:-----------------------------------|:-----------------------------------|
| Arithmetic  | to complete mathematical calculations | `boulder_precip_in * 25.4` |
| Assignment  | to assign new values (typically as a result of a arithmetic calculation) | `boulder_precip_in *= 25.4` |
| Comparison or Relational  | to compare operands (e.g. greater than symbol `>`)  | `boulder_precip_in > phoenix_precip_in`|
| Identity  | to check whether operands are the same | `boulder_precip_in is not phoenix_precip_in` |
| Membership  | to check whether one operand is contained within another operand | `"January" in months` |
| Logical  | to check whether operands are `true` | `"January" in months AND "Jan" in months` |

## Arithmetic Operators

In **Python**, there are <a href="https://docs.python.org/3/library/stdtypes.html#numeric-types-int-float-complex" target="_blank">many arithmetic operations</a> that can be completed, including operators for: 
* addition (`+`)
* subtraction (`-`)
* multiplication (`*`)
* division (`\`)
* exponents (`**`)

Review the cells below and notice that the output is automatically printed without the need to tell **Python** to display the output. 

{:.input}
```python
a = 2
b = 3

a + b
```

{:.output}
{:.execute_result}



    5





{:.input}
```python
b - a
```

{:.output}
{:.execute_result}



    1





{:.input}
```python
b / a
```

{:.output}
{:.execute_result}



    1.5





{:.input}
```python
a * b
```

{:.output}
{:.execute_result}



    6





{:.input}
```python
a ** b
```

{:.output}
{:.execute_result}



    8





For scientific workflows, these arithmetic operators are very useful for converting the units of measurements, for example, from inches to millimeters (1 inch = 25.4 mm) for precipitation values.

The example belows converts the average precipitation value for Boulder, CO in January from inches to millimeters.

{:.input}
```python
jan_precip = 0.70

jan_precip * 25.4
```

{:.output}
{:.execute_result}



    17.779999999999998





## Assignment Operators

While arithmetic operators are very useful for calculations, they do not change the original values. 

For example, the variable `jan_precip` continues to store the value `0.7` (the measurement in inches), even after the calculations completed above. 

{:.input}
```python
jan_precip
```

{:.output}
{:.execute_result}



    0.7





If you want to assign a new value as a result of a calculation, you can use an assignment operator, which combines the arithmetic operator (e.g. `*`) with the `=` to set a new value. 

For example, you can combine `*` and `=` to multiple a value and set the result equal to itself plus the new value. 

{:.input}
```python
jan_precip *= 25.4
```

Recall that on the previous page on working with lists, you also used an assignment operator to add items to the end of a list. 

This is a special case of the addition assignment operator `+=` because it is not actually completing a mathematical operation on the list.  It simply adds the values as new items to the end of the list. 

{:.input}
```python
months = ["January", "February"]

months
```

{:.output}
{:.execute_result}



    ['January', 'February']





{:.input}
```python
months += ["March", "April"]

months
```

{:.output}
{:.execute_result}



    ['January', 'February', 'March', 'April']





However, not all assignment operators can be used on all object types. For example, the following code will result in an error because lists cannot have mathmematical operations executed on them.  

```python
boulder_precip_in = [0.70, 0.75, 1.85]
boulder_precip_in *= 25.4
```

You can review the <a href="https://docs.python.org/3/library/stdtypes.html#" target="_blank">Python docs on types and operations</a> to see what kinds of operations can be run on different object types. 

## Print Output

Notice now that the output is not automatically printed.

{:.input}
```python
jan_precip = 0.70

jan_precip *= 25.4
```

To see the new value, you can call the variable name (e.g. `jan_precip`), or you can use the print statement (e.g. `print(jan_precip)`) to display the new value. 

Using the print statement can be very helpful because then you can print multiple values. 

For example, notice calling only the variable names (e.g. `a`, `jan_precip`, `b`), you are only shown the value of the last variable.

{:.input}
```python
a
jan_precip
b
```

{:.output}
{:.execute_result}



    3





Using `print()`, you can print as many things as you want. 

{:.input}
```python
print(a)
print(jan_precip)
print(b)
```

{:.output}
    2
    17.779999999999998
    3



You can even combine the variables with a text string in a print statement by including a text string `"text"` within the print statement.

To do this, simply separate the text string from the object that is being printed using a comma `,`. 

{:.input}
```python
print("January precipitation:", jan_precip)
```

{:.output}
    January precipitation: 17.779999999999998



Notice that the word `print` does not show up the output. Instead, you simply see the result, without the parentheses or quotations for the text string. 

**You have now deliberately used your first **Python** function!** Functions in **Python** are commands that can take inputs that are used to produce output. 

You will learn more about functions later in this textbook, and you will use the `print` function a lot, as it can be very handy for viewing results and for communicating the status of your code. 

 <div class="notice--info" markdown="1">

## Additional Resources

* <a href="https://docs.python.org/3/library/stdtypes.html#" target="_blank">Python docs on types and operations</a>

* <a href="https://python-reference.readthedocs.io/en/latest/docs/operators/" target="_blank">Reference docs on operators</a>

</div>   

<div class="notice--warning" markdown="1">

## <i class="fa fa-pencil-square-o" aria-hidden="true"></i> Practice Your Python Skills

Data on average monthly precipitation for <a href="https://www.esrl.noaa.gov/psd/boulder/Boulder.mm.precip.html" target="_blank">Boulder, Colorado provided by the U.S. National Oceanic and Atmospheric Administration (NOAA).</a> 

Month  | Precipitation (inches) |
--- | --- |
Jan | 0.70 |
Feb | 0.75 |
Mar | 1.85 |
Apr | 2.93 |
May | 3.05 |
June | 2.02 |
July | 1.93 |
Aug | 1.62 |
Sept | 1.84 |
Oct | 1.31 |
Nov | 1.39 |
Dec | 0.84 |

Test your `Python` skills to:

1. Create new variables for monthly average precipitation values (inches) for Boulder, CO for January through December.

2. Use the appropriate arithmetic operator to convert the monthly variables for `jan` to `dec` from inches to millimeters (1 inch = 25.4 mm).

3. Create a list that contains the converted monthly average precipitation values in millimeters. Print your list (hint: `print(list_name)`).

4. Create a list that contains the month names from the table above.

</div>


{:.output}
    [17.779999999999998, 19.049999999999997, 46.99, 74.422, 77.46999999999998, 51.308, 49.022, 41.148, 46.736, 33.274, 35.306, 21.336]



<div class="notice--warning" markdown="1">

## <i class="fa fa-pencil-square-o" aria-hidden="true"></i> Challenge Your Python Skills

Modify the following code to create a plot of your data:

```python
# Import necessary plot package
import matplotlib.pyplot as plt

# Plot monthly precipitation values
fig, ax = plt.subplots(figsize=(10, 10))
ax.bar(listname_months, listname_precip, color="blue")
ax.set(title="Add plot title here.",
       xlabel="Add x axis label here.", ylabel="Add y axis label here.");
```

Customize this plot by:
1. Replacing `listname_months` and `listname_precip` with the names of the lists that you created. 
2. Change the <a href="https://matplotlib.org/mpl_examples/color/named_colors.hires.png" target="_blank">color of the plot</a> to aqua.
3. Update the text for the titles and axes labels. 
4. Modifying the values in `figsize=(10, 10)` to change the size of your plot. 

For your titles and labels, be sure to think about the following pieces of information that could help someone easily interpret the plot:

* geographic coverage or extent of data.
* duration or temporal extent of the data.
* what was actually measured and/or represented by the data.
* units of measurement.

</div>

