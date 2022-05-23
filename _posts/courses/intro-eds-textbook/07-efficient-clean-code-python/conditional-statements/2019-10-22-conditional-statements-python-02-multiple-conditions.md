---
layout: single
title: 'Conditional Statements with Alternative or Combined Conditions'
excerpt: "Conditional statements in Python can be written to check for alternative conditions or combinations of multiple conditions. Learn how to write conditional statements in Python that choose betweeen alternative conditions or check for combinations of conditions before executing code."
authors: ['Jenny Palomino', 'Leah Wasser']
category: [courses]
class-lesson: ['intro-conditional-statements-tb']
permalink: /courses/intro-to-earth-data-science/write-efficient-python-code/conditional-statements/alternative-multiple-conditions/
nav-title: "Alternative and Multiple Conditions"
dateCreated: 2019-10-22
modified: 2021-01-28
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
  - "/courses/earth-analytics-bootcamp/conditional-statements/control-flow/"
  - "/courses/intro-to-earth-data-science/dry-code-python/conditional-statements/alternative-multiple-conditions/"
  - "/courses/intro-to-earth-data-science/write-efficient-python-code/alternative-multiple-conditions/" 
---
{% include toc title="On This Page" icon="file-text" %}

<div class='notice--success' markdown="1">

## <i class="fa fa-graduation-cap" aria-hidden="true"></i> Learning Objectives

* Describe the syntax for conditional statements with alternative conditions or combinations of conditions in **Python**.
* Write conditional statements with alternative conditions or combinations of conditions in **Python**.

</div>


## Conditional Statements With Alternative Conditions

On the previous page, you learned how to write conditional statements that check for one condition before executing some code: 

```python
if condition:
    print("Condition is true.")
else:
    print("Condition is false (i.e. not true).")
```

You can expand on this syntax to check for an alternative condition with an `elif` statement: 

```python
if condition:
    some code here
elif alternative_condition:
    some other code here
else:
    some final code here
```

If the first condition provided with the `if` statement is not satisfied (i.e. results in value of `False`) , then **Python** will check the condition provided with the `elif` statement.

If the condition for `elif` is satisfied, then the code provided with it will execute.

However, if neither the `if` nor `elif` conditions are satisfied, then the code provided with `else` will execute.


```python
if condition:
    print("First condition is true.")
elif alternative_condition:
    print("First condition is not true but alternative condition is true.")
else:
    print("Neither of these conditions is true, so this statement is printed.")
```

### Spacing and Execution of Code Lines 

Recall that the `print` code in the examples above can be replaced by any code that will execute in **Python**.

As the code provided with the `if`, `elif`, and `else` statements gets longer, it is common to add blank lines to make it easier to see which code will be executed with whitch statement. However, the indentation remains an important part of the syntax of the conditional statement.

Check out the examples below to see `elif` in action and see how `print` statements can be replaced with other code.

In the first example, `x` is compared to `y`. The first condition checks whether `x` is less than `y`, while the alternative condition checks whether `x` is greater than `y`.  

As `x` is equal to a value less than `y`, the first condition is satisfied, which results in a value of 5 being added to `x`. 

{:.input}
```python
# Set x equal to 5 and y equal to 10
x = 5
y = 10

# Execute code based on comparison of x to y
if x < y:
    print("x started with value of", x)
    x += 5
    print("It now has a value of", x, "which is equal to y.")

elif x > y:
    print("x started with value of", x)
    x -= 5
    print("It now has a value of", x, "which is equal to y.")

else:
    print("x started with a value of", x, "which is already equal to y.")
```

{:.output}
    x started with value of 5
    It now has a value of 10 which is equal to y.



In this second example below, `x` is equal to a value greater than `y`, so the first condition is no longer satisfied. However, the second condition is satisfied, which results in a value of 5 being subtracted from `x`. 

{:.input}
```python
# Set x equal to 15 
x = 15

# Execute code based on comparison of x to y
if x < y:
    print("x started with value of", x)
    x += 5
    print("It now has a value of", x, "which is equal to y.")

elif x > y:
    print("x started with value of", x)
    x -= 5
    print("It now has a value of", x, "which is equal to y.")

else:
    print("x started with a value of", x, "which is already equal to y.")
```

{:.output}
    x started with value of 15
    It now has a value of 10 which is equal to y.



However, if `x` is set to same value as `y`, neither the first nor second conditions are met, and the code provided with `else` is executed. 

{:.input}
```python
# Set x equal to 10 
x = 10

# Execute code based on comparison of x to y
if x < y:
    print("x started with value of", x)
    x += 5
    print("It now has a value of", x, "which is equal to y.")

elif x > y:
    print("x started with value of", x)
    x -= 5
    print("It now has a value of", x, "which is equal to y.")

else:
    print("x started with a value of", x, "which is already equal to y.")
```

{:.output}
    x started with a value of 10 which is already equal to y.



You can also apply the `elif` syntax to structure conditional statements that use other operators or check values for text strings or objects.  

For example, you can check if a text string is contained within another text string and define a filename based on which condition is satisfied. 

{:.input}
```python
# Set fname based on which text string contains "precip"
if "precip" in "avg_monthly_temp":
    fname = "avg_monthly_temp"
    print(fname)

elif "precip" in "avg_monthly_precip":
    fname = "avg_monthly_precip"
    print(fname)  

else:
    print("Neither textstring contains the word precip.")
```

{:.output}
    avg_monthly_precip



As another example, you can add values to a list depending on which condition is satisfied.

In the example below, the first condition checks whether the last value of the list (using index `[-1]`) is equal to 0.84, the average precipitation value for December. 

As the last value in the list is actually 1.39 (November precipitation), the first condition is not satisfied. 

Thus, the second condition is initiated to check whether the last value is 1.39. Since it is indeed the last value in the list, the second condition results in value of `True`. 

The code provided for `elif` is then executed, adding the value of December to the list. 

{:.input}
```python
# List of average monthly precip (inches) in Boulder, CO without Dec value
avg_monthly_precip = [0.70,  0.75, 1.85, 2.93, 3.05, 2.02, 
                      1.93, 1.62, 1.84, 1.31, 1.39]

# Add value to list depending on existing last value
if avg_monthly_precip[-1] == 0.84:   
    print(avg_monthly_precip[-1]) # Print last value in the list

elif avg_monthly_precip[-1] == 1.39:   
    avg_monthly_precip += [0.84] # Add Dec value
    print(avg_monthly_precip)    

else:     
    print("The last item in the list is neither 0.84 nor 1.39.")
```

{:.output}
    [0.7, 0.75, 1.85, 2.93, 3.05, 2.02, 1.93, 1.62, 1.84, 1.31, 1.39, 0.84]



## Conditional Statements With Combinations of Conditions

Logical operators (e.g. `and`, `or`, `not`) allow you to create conditional statements that can check for combinations of conditions.  You can use:

* `and` to execute code if all specified conditions have been met
* `or` to execute code if at least one specified condition has been met 
* `not` to execute code only if the specified condition has not been met (note that you can use `not` in combination with `and` or `or` to check whether multiple conditions are not met)

### Check For Two Conditions Using `and`

You can check for multiple conditions by including `and` between two conditions. 

Both conditions have to be satisfied in order for the code provided with the `if` statement to be executed. 

This means that if one condition is not satisfied, then the conditional statement executes the code provided with `else`. 

```python
# Check that both conditions are true
if condition1 and condition2:
    print("Conditions 1 and 2 are both true.")
else:
    print("One condition (either 1 or 2) is not true.")
```

For example, you can check whether two variables are both integers, and if so, then add them together. 

{:.input}
```python
# Set x equal to 5 and y equal to 10
x = 5
y = 10

# Add x and y if they are both integers
if type(x) is int and type(y) is int:
    print(x + y)
else:
    print("Either x or y is not an integer.")
```

{:.output}
    15



{:.input}
```python
# Set x equal to 5 and y equal to text string
x = 5
y = "Some text"

# Add x and y if they are both integers
if type(x) is int and type(y) is int:
    print(x + y)
else:
    print("Either x or y is not an integer, so they cannot be added.")
```

{:.output}
    Either x or y is not an integer, so they cannot be added.



You can also check whether two objects are of the same type and length, such as two lists.

{:.input}
```python
# Create list of abbreviated month names without Dec
months = ["Jan", "Feb", "Mar", "Apr", "May", "June",
          "July", "Aug", "Sept", "Oct", "Nov"]

# Length of avg_monthly_precip
precip_len = len(avg_monthly_precip) 
print(precip_len)

# Length of months
months_len = len(months)
print(months_len)
```

{:.output}
    12
    11



{:.input}
```python
# Check whether both type and length of avg_monthly_precip and months match
if type(avg_monthly_precip) is type(months) and precip_len == months_len:
    print("Objects are of the same type and have the same length.")
else:
    print("Objects are not of the same type or do not have same length.")
```

{:.output}
    Objects are not of the same type or do not have same length.



In the example above, the first condition is satisfied because both objects are lists. 

However, the second condition is not satistifed because the `months` list is missing `Dec` (leaving it with only 11 values). 

Because one of the conditions is not satisfied, the conditional statement executes the code provided with `else`.  

### Check For At Least One Condition Using `or`

You can also write conditional statements that check whether at least one condition is true by including `or` between two conditions. 

Only one condition has to pass in order for the conditional statement to execute code provided with `if`. 

```python
# Check that at least one condition is true
if condition1 or condition2:
    print("Either condition 1 or 2 is true.")
else:
    print("Neither of these conditions is true.")
```

For example:

{:.input}
```python
# Set x equal to 0 and y equal to 10
x = 0
y = 10

# Check whether either is equal to zero
if x == 0 or y == 0:
    print("Either x or y is equal to 0.")
    x += 1
    y += 1
    print("x is now", x, "and y is now", y)

else:
    print("Neither x nor y is equal to 0.")
```

{:.output}
    Either x or y is equal to 0.
    x is now 1 and y is now 11



For another example, recall the conditional statement comparing the types and lengths of two lists. 

The first condition is true, as both objects are lists, but the second condition is not true because the `months` list is missing `Dec` (leaving it with only 11 values). 

By using the `or` statement, only one condition has to be true, in order for the `if` statement to be satisfied and for the code provided with `if` to execute. 

{:.input}
```python
# Check match for either type and length of avg_monthly_precip and months
if type(avg_monthly_precip) is type(months) or precip_len == months_len:
    print("Objects have either the same type or length.")
else:
    print("Objects either do not have the same type or same length.")
```

{:.output}
    Objects have either the same type or length.



You have now learned how to control the flow of your code using conditional statements. In the next chapter, you will learn how to write loops, in order to execute a task multiple times without having to repeat the code. 
