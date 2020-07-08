---
layout: single
title: 'Loops in Python Exercise'
excerpt: "Loops can be used to automate data tasks in Python by iteratively executing the same code on multiple data structures. Practice using loops to automate certain functionality in Python."
authors: ['Nathan Korinek', 'Leah Wasser']
category: [courses]
class-lesson: ['intro-loops-tb']
permalink: /courses/intro-to-earth-data-science/write-efficient-python-code/loops/loops-exercise
nav-title: "Loops Exercise"
dateCreated: 2020-07-08
modified: 2020-07-08
module-type: 'class'
chapter: 18
course: "intro-to-earth-data-science-textbook"
week: 7
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

This page of exercises will test the skills that you learned in the previous lessons in this chapter. You will practice using loops to help with common coding tasks, using for and while loops, and looping over different types of data. 

</div>

<div class="notice--warning" markdown="1">

## <i class="fa fa-pencil-square-o" aria-hidden="true"></i> Challenge 1: Modify Numeric Values in a List

Below is a list of values that represents the average monthly high temperature in Boulder, CO., collected by NOAA. They are currently in Fahrenheit, but can be converted to Celsius by subtracting 32, and multiplying by 5/9. 
```
(F - 32) * 5/9 = C
```

Create a new list with these same temperatures converted to Celsius using a for loop.

</div>

{:.input}
```python
# Data to convert to celsius

boulder_avg_high_temp_f = [
    47,
    49,
    57,
    64,
    72,
    83,
    89,
    87,
    79,
    67,
    55,
    47
]
```


{:.output}
{:.execute_result}



    [8.333333333333334,
     9.444444444444445,
     13.88888888888889,
     17.77777777777778,
     22.22222222222222,
     28.333333333333336,
     31.666666666666668,
     30.555555555555557,
     26.11111111111111,
     19.444444444444446,
     12.777777777777779,
     8.333333333333334]





<div class="notice--warning" markdown="1">

## <i class="fa fa-pencil-square-o" aria-hidden="true"></i> Challenge 2: Modify String Values in a List

Currently the Celsius list you created is a list of float values, but they don't have any context. For this exercise, take the list you just created and turn the float values into strings, and add on "° Celsius" to the string. Additionally, the conversion has made all of the temperatures have very long decimal values. Please also truncate the data to only have 2 decimal values for each temperature. 

To truncate decimal values, you can use the standard **Python** function `round()` to round a number to a certain number of decimal points. The first argument in the `round()` function is the number to round, and the second argument is the number of decimals you want after it's been rounded. See how this works below.

```
c = 7.3848234
round(c, 2)

# 7.38
```

Do all this inside a `for` loop going over your old list. 

</div>


{:.output}
{:.execute_result}



    ['8.33° Celsius',
     '9.44° Celsius',
     '13.89° Celsius',
     '17.78° Celsius',
     '22.22° Celsius',
     '28.33° Celsius',
     '31.67° Celsius',
     '30.56° Celsius',
     '26.11° Celsius',
     '19.44° Celsius',
     '12.78° Celsius',
     '8.33° Celsius']





<div class="notice--warning" markdown="1">

## <i class="fa fa-pencil-square-o" aria-hidden="true"></i> Bonus Challenge: Collatz Conjecture

The Collatz Conjecture is a mathematic rule that says that if the following rules are performed on any positive interger, the number will eventually reach 1. The rules are:

1. If the integer is even, the next integer is one half of the current integer.
2. If the integer is odd, the next term is 3 times the current integer plus 1. 

If these rules are followed, any integer will eventually reach one. Using a `while` loop, implement these rules so that a variable you enter into the while loop has these rules run on it until it equals one. Here are some helpful hints to help you implement these rules:

1. To check if a number is odd or even in **Python**, it is common practice to see if the remainder of the number divided by 2 equals zero. If you remember, `%` will get the remainder of a number divided by another number. So, to see if a number is even, the code `n%2 == 0` will return `True` if `n` is even, and `False` if `n` is odd.
2. The `while` loop will run until the input number equals one. But you also need to remember not to run the code on the number if it does equal one. So in the odd calculation, make sure that the number doesn't equal one before you run the calculation on it. 

Print out the number variable with each pass through of the while loop. Have your number variable equal `10000` before the `while` loop is run. Careful with this, it shouldn't take long to run. If it is taking a long time to run, there's probably a mistake in your code and your while loop will be running forever until you stop it! Once your code runs, change the number variable to see it run on any number you want!
</div>


{:.output}
    10000
    5000.0
    2500.0
    1250.0
    625.0
    1876.0
    938.0
    469.0
    1408.0
    704.0
    352.0
    176.0
    88.0
    44.0
    22.0
    11.0
    34.0
    17.0
    52.0
    26.0
    13.0
    40.0
    20.0
    10.0
    5.0
    16.0
    8.0
    4.0
    2.0
    1.0


