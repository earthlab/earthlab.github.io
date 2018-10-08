---
layout: single
title: "For Loops in Python Refresher"
excerpt: "In this lesson you will review the basics of for loops in Python."
authors: ['Software Carpentry', 'Martha Morrissey']
modified: 2018-10-08
category: [courses]
class-lesson: ['hw-custom-maps-python']
permalink: /courses/earth-analytics-python/spatial-data-vector-shapefiles/python-for-loops-refresher/
nav-title: 'For Loop Refresher'
course: 'earth-analytics-python'
week: 4
sidebar:
  nav:
author_profile: false
comments: true
order: 3
---
{% include toc title="In This Lesson" icon="file-text" %}

<div class='notice--success' markdown="1">

## <i class="fa fa-graduation-cap" aria-hidden="true"></i> Learning Objectives

After completing this tutorial, you will be able to:

* Explain what a `for` loop does.
* Create and use for loops in `Python`

## <i class="fa fa-check-square-o fa-2" aria-hidden="true"></i> What You Need

You will need a computer with internet access to complete this lesson.

</div>

## Repeating Tasks with For Loops in `Python`

An example task that you might want to repeat is printing each character in a word on a line of its own.

word = 'lead'

You can access a character in a string using its index. For example, you can get the first character of the word `lead`, by using `word[0]`. One way to print each character is to use four print statements:

{:.input}
```python
word = 'lead'

print(word[0])
print(word[1])
print(word[2])
print(word[3])
```

{:.output}
    l
    e
    a
    d



This is a bad approach for two reasons:

1. It doesn't scale: if you want to print the characters in a string that's hundreds of letters long, you'd be better off just typing them in.

2. It's fragile: if you give it a longer string, it only prints part of the data, and if you give it a shorter one, it produces an error because you're asking for characters that don't exist.

{:.input}
```python
word = 'tin'
print(word[0])
print(word[1])
print(word[2])
print(word[3])
```

{:.output}
    t
    i
    n



{:.output}

    ---------------------------------------------------------------------------

    IndexError                                Traceback (most recent call last)

    <ipython-input-3-e59d5eac5430> in <module>()
          3 print(word[1])
          4 print(word[2])
    ----> 5 print(word[3])
    

    IndexError: string index out of range



Here's a better approach:

{:.input}
```python
word = 'lead'
for char in word:
    print(char)
```

{:.output}
    l
    e
    a
    d



This is shorter --- certainly shorter than something that prints every character in a hundred-letter string --- and more robust as well:

{:.input}
```python
word = 'oxygen'
for char in word:
    print(char)
```

{:.output}
    o
    x
    y
    g
    e
    n



### For Loop Structure 

The general form of a loop is:

`for variable in collection:
    do things with variable`
    
Variable can be any word you like, but it should relate to what you are looping through, to make your code easier for you and others to understand. There must be a colon at the end of the line starting the loop, and you must indent anything you want to run inside the loop. Unlike many other languages, there is no command to signify the end of the loop body (e.g. end for); what is indented after the for statement belongs to the loop.

Here's another loop that repeatedly updates a variable:

{:.input}
```python
length = 0
for vowel in 'aeiou':
    length = length + 1
print('There are', length, 'vowels')
```

{:.output}
    There are 5 vowels



It's worth tracing the execution of this little program step by step. Since there are five characters in `aeiou`, the statement on line 3 will be executed five times. The first time around, length is zero (the value assigned to it on line 1) and vowel is `a`. The statement adds 1 to the old value of length, producing 1, and updates length to refer to that new value. The next time around, vowel is `e` and length is 1, so length is updated to be 2. After three more updates, length is 5; since there is nothing left in 'aeiou' for Python to process, the loop finishes and the print statement on line 4 gives the final answer.

Note that a loop variable is just a variable that's being used to record progress in a loop. It still exists after the loop is over, and you can re-use variables previously defined as loop variables as well:

{:.input}
```python
letter = 'z'
for letter in 'abc':
    print(letter)
print('after the loop, letter is', letter)
```

{:.output}
    a
    b
    c
    after the loop, letter is c



### Range in Python

`Python` has a built-in function called `range` that creates a sequence of numbers. `Range` can accept 1, 2, or 3 parameters. `Range` is often used with `for` loops in `Python.`

* If one parameter is given, range creates an array of that length, starting at zero and incrementing by 1. For example, `range(3)` produces the numbers `0, 1, 2`.

* If two parameters are given, range starts at the first and ends just before the second, incrementing by one. For example, `range(2, 5)` produces `2, 3, 4`.

* If range is given 3 parameters, it starts at the first one, ends just before the second one, and increments by the third one. For exmaple `range(3, 10, 2)` produces `3, 5, 7, 9`.

Using range, you can write a loop that uses range to print the first 3 natural numbers:

{:.input}
```python
for i in range(1, 4):
   print(i)
```

{:.output}
    1
    2
    3


