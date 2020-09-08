---
layout: single
title: 'Write Functions in Python'
excerpt: "A function is a reusable block of code that performs a specific task. Learn how to write functions in Python to eliminate repetition and improve efficiency in your code."
authors: ['Jenny Palomino', 'Leah Wasser']
category: [courses]
class-lesson: ['intro-functions-tb']
permalink: /courses/intro-to-earth-data-science/write-efficient-python-code/functions-modular-code/write-functions-in-python/
nav-title: "Write Functions in Python"
dateCreated: 2019-11-05
modified: 2020-09-03
module-type: 'class'
chapter: 19
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
  - "/courses/earth-analytics-bootcamp/functions/write-functions/"
  - "/courses/earth-analytics-python/use-time-series-data-in-python/python-syntax-and-using-functions/"
  - "/courses/intro-to-earth-data-science/write-efficient-python-code/functions/write-functions-in-python/" 
---
{% include toc title="On This Page" icon="file-text" %}

<div class='notice--success' markdown="1">

## <i class="fa fa-graduation-cap" aria-hidden="true"></i> Learning Objectives

* Describe the components needed to define a function in **Python**.
* Write and execute a custom function in **Python**.
 
</div>


## How to Define Functions in Python

There are several components needed to define a function in **Python**, including the `def` keyword, function name, parameters (inputs), and the `return` statement, which specifies the output of the function. 

```python
def function_name(parameter):
    some code here    
    return output
```

### def Keyword and Function Name

In **Python**, function definitions begin with the keyword **`def`** to indicate the start of a definition for a new function. This keyword is followed by the function name. 

```python
def function_name():
```

The function name is the name that you use when you want to call the function (e.g. `print()`). 

Function names should follow <a href="{{ site.url }}/courses/intro-to-earth-data-science/write-efficient-python-code/intro-to-clean-code/expressive-variable-names-make-code-easier-to-read/">PEP 8 recommendations for function names</a> and should be concise but descriptive of what the function does. 


### Input Parameter(s)

The input parameter is the required information that you pass to the function for it to run successfully. The function will take the value or object provided as the input parameter and use it to perform some task.

In **Python**, the required parameters are provided within parenthesis `()`, as shown below.

```python
def function_name(parameter):       
```    

You can define an input parameter for a function using a placeholder variable, such as `data`, which represents the value or object that will be acted upon in the function. 


```python
def function_name(data):
```   


When the function is called, a user can provide any value for `data` that the function can take as input (e.g. single value variable, list, **numpy** array, **pandas** dataframe column). 

If you are defining a function for a specific object type, you can consider using a more specific placeholder variable, such as `arr` for a **numpy** array.


```python
def function_name(arr):
```   

Note that functions in **Python** can be defined with multiple input parameters as needed: 


```python
def function_name(arr_1, arr_2):
```  


### Return Statement

In **Python**, function definitions need a `return` statement to specify the output that will be returned by the function. 


```python
def function_name(data):
    some code here    
    return output
```

Just like with loops and conditional statements, the code lines executed by the function, including the `return` statement, are provided on new lines after a colon `:` and are indented once to indicate that they are part of the function.

The `return` statement can return one or more values or objects and can follow multiple lines of code as needed to 
complete the task (i.e. code to create the output that will be returned by the function). 


### Docstring 

In **Python**, functions should also contain a <a href="https://www.python.org/dev/peps/pep-0008/#documentation-strings" target="_blank">docstring</a>, or a multi-line documentation comment, that provides details about the function, including the specifics of the input parameters and the returns (e.g. type of objects, additional description) and any other important documentation about how to use the function. 


```python
def function_name(data):
    """Docstrings should include a description of the function here 
    as well as identify the parameters (inputs) that the function 
    can take and the return (output) provided by the function,
    as shown below. 
    
    Parameters
    ----------
    input : type
        Description of input.
    
    Returns
    ------
    output : type
        Description of output.
    """
    some code here
    
    return output
```

Note that a docstring is not required for the function to work in **Python**. However, good documentation will save you time in the future when you need to use this code again, and it also helps others understand how they can use your function.

You can learn more about docstrings in the <a href="https://www.python.org/dev/peps/pep-0257/" target="_blank">PEP 257 guidelines</a> focused on docstrings. This textbook uses the docstring standard that is outlined in the <a href="https://numpydoc.readthedocs.io/en/latest/format.html#docstring-standard" target="_blank">**numpy**  documentation</a>.  


## Write a Function in Python

Imagine that you want define a function that will convert values from millimeters to inches (1 inch = 25.4 millimeters). To define the function, you can work through each component below to build each piece and bring them together. 


### def Keyword and Function Name

Function names should be concise but descriptive, so an appropriate function name could be `mm_to_in`. Recall that the function name is provided after the `def` keyword, as shown below. 


```python
def mm_to_in():
```

### Input Parameter

To decide on an appropriate placeholder name for the input parameter, it is helpful to think about what inputs the function code needs in order to execute successfully.

You need a placeholder variable that represents the original value in millimeters, so an appropriate placeholder could simply be `mm`. 


```python
def mm_to_in(mm):
```

### Return Statement 

You know that 1 inch is equal to 25.4 millimeters, so to convert from millimeters to inches, you will need to divide the original value in millimeters by 25.4. 

Using this information, you can write the code to convert the input value and store the converted value in an variable called `inches`. 

Then, you can write the `return` statement to return the new value `inches`. 

{:.input}
```python
# Convert input from mm to inches
def mm_to_in(mm):    
    inches = mm / 25.4    
    return inches
```

### Docstring

The function above is complete regarding code. However, as previously discussed, good documentation can help you and others to easily use and adapt this function as needed. 

**Python** promotes the use of docstrings for documenting functions. This docstring should contain a brief description of the function (i.e. how it works, purpose) as well as identify the input parameters (i.e. type, description) and the returned output (i.e. type, description).

#### Function Description

Begin with the description of the function. Some functions may require longer description than others. For the `mm_to_in()` function, it can be short but descriptive as shown below. 

{:.input}
```python
def mm_to_in(mm):
    """Convert input from millimeters to inches. 
    
    Parameters
    ----------
    input : type
        Description of input.
    
    Returns
    ------
    output : type
        Description of output.
    """
    inches = mm / 25.4    
    return inches
```

#### Input Parameter Description

Next, think about the required input for the `mm_to_in` function. 

You need a numeric value in millimeters, represented by the variable `mm` in the code. You can identify the input in the docstring specifically as `mm` and provide a type (int, float) and short description that provides details on the units. 

{:.input}
```python
def mm_to_in(mm):
    """Convert input from millimeters to inches. 
    
    Parameters
    ----------
    mm : int or float
        Numeric value with units in millimeters.
    
    Returns
    ------
    output : type
        Description of output.
    """
    inches = mm / 25.4    
    return inches
```

#### Return Description

By looking at the code in the function, you know that the final output is returned using the variable `inches`. 

You can provide a short description to specify that the returned output is a numeric value with units in inches.  

{:.input}
```python
def mm_to_in(mm):
    """Convert input from millimeters to inches. 
    
    Parameters
    ----------
    mm : int or float
        Numeric value with units in millimeters.

    Returns
    ------
    inches : int or float
        Numeric value with units in inches.
    """
    inches = mm / 25.4    
    return inches
```

## Call Custom Functions in Python

Now that you have defined the function `mm_to_in()`, you can call it as needed to convert units. 

Below is an example call to this function, specifying a single value variable that will be represented by `mm` in the function.

{:.input}
```python
# Average monthly precip (mm) in Jan for Boulder, CO
precip_jan_mm = 17.78

# Convert to inches
mm_to_in(mm = precip_jan_mm)
```

{:.output}
{:.execute_result}



    0.7000000000000001





Notice that the output is provided but you have not actually changed the original values of `precip_jan_mm`.  

{:.input}
```python
precip_jan_mm
```

{:.output}
{:.execute_result}



    17.78





You can create a new variable to store the output of the function as follows:

{:.input}
```python
# Create new variable with converted values
precip_jan_in = mm_to_in(mm = precip_jan_mm)

precip_jan_in
```

{:.output}
{:.execute_result}



    0.7000000000000001





### Placeholder Variables in Functions

Notice that in the function call above, you provided a pre-defined variable (`precip_jan_mm`) to the parameter `mm` using:

`mm = precip_jan_mm`

In the function, `mm` is the placeholder variable for the input and has not been pre-defined outside of the function. The same holds true for `inches`, which is the placeholder variable for the output of the function.

Rather than containing pre-defined values, `mm` takes on the values of the input parameter to the function (e.g. `precip_jan_mm`), and `inches` holds the values resulting from the calculation in the function. 

Thus, `mm` and `inches` will hold different values each time that the function is called.

Another important note about the placeholder variables in functions is that they do not exist outside of the function. 

If you try to call these placeholder variables (e.g. `mm` or `inches`) outside of the function, you will get an error. 

For example, the following code:

```python
print(inches)
```

will return the error:

```python
NameError: name 'inches' is not defined
```

This is because `inches` is used by the function to return the result of the code, but it is not actually stored as a variable that is independent of the function.  

Note that this is a difference from placeholders that are used in loops, which can be called when the loop is completed its run. 


### Applying the Same Function to Multiple Object Types

Since you know that numeric values can also be stored in **numpy** arrays, you can also provide a **numpy** array as an input to the function. 

{:.input}
```python
# Import necessary packages
import numpy as np
```

{:.input}
```python
# Average monthly precip (mm) for Boulder, CO
avg_monthly_precip_mm = np.array([17.78, 19.05, 46.99, 74.422, 
                                  77.47, 51.308, 49.022, 41.148, 
                                  46.736, 33.274, 35.306, 21.336])

# Convert to inches
mm_to_in(mm = avg_monthly_precip_mm)
```

{:.output}
{:.execute_result}



    array([0.7 , 0.75, 1.85, 2.93, 3.05, 2.02, 1.93, 1.62, 1.84, 1.31, 1.39,
           0.84])





Again, notice that the output is provided but you have not actually changed the original values of the **numpy** array. 

{:.input}
```python
avg_monthly_precip_mm
```

{:.output}
{:.execute_result}



    array([17.78 , 19.05 , 46.99 , 74.422, 77.47 , 51.308, 49.022, 41.148,
           46.736, 33.274, 35.306, 21.336])





To do this, recall that you can save the output of a function to a new object:

{:.input}
```python
# Convert to inches
avg_monthly_precip_in = mm_to_in(mm = avg_monthly_precip_mm)

avg_monthly_precip_in
```

{:.output}
{:.execute_result}



    array([0.7 , 0.75, 1.85, 2.93, 3.05, 2.02, 1.93, 1.62, 1.84, 1.31, 1.39,
           0.84])





Similarly, you know that numeric values can be stored in a column in a **pandas** dataframe, so you can also provide a column in a **pandas** dataframe as an input to the function and store the results of the function in a new column.  

{:.input}
```python
# Import necessary packages
import pandas as pd
```

{:.input}
```python
# Average monthly precip (mm) in 2002 for Boulder, CO
precip_2002 = pd.DataFrame(columns=["month", "precip_mm"],
                           data=[
                                ["Jan", 27.178],  ["Feb", 11.176],
                                ["Mar", 38.100],  ["Apr", 5.080],
                                ["May", 81.280],  ["June", 29.972],
                                ["July", 2.286],  ["Aug", 36.576],
                                ["Sept", 38.608], ["Oct", 61.976],
                                ["Nov", 19.812],  ["Dec", 0.508]
                           ])
```

{:.input}
```python
# Create new column with precip in inches
precip_2002["precip_in"] = mm_to_in(mm = precip_2002["precip_mm"])

precip_2002
```

{:.output}
{:.execute_result}



<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>month</th>
      <th>precip_mm</th>
      <th>precip_in</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>Jan</td>
      <td>27.178</td>
      <td>1.07</td>
    </tr>
    <tr>
      <th>1</th>
      <td>Feb</td>
      <td>11.176</td>
      <td>0.44</td>
    </tr>
    <tr>
      <th>2</th>
      <td>Mar</td>
      <td>38.100</td>
      <td>1.50</td>
    </tr>
    <tr>
      <th>3</th>
      <td>Apr</td>
      <td>5.080</td>
      <td>0.20</td>
    </tr>
    <tr>
      <th>4</th>
      <td>May</td>
      <td>81.280</td>
      <td>3.20</td>
    </tr>
    <tr>
      <th>5</th>
      <td>June</td>
      <td>29.972</td>
      <td>1.18</td>
    </tr>
    <tr>
      <th>6</th>
      <td>July</td>
      <td>2.286</td>
      <td>0.09</td>
    </tr>
    <tr>
      <th>7</th>
      <td>Aug</td>
      <td>36.576</td>
      <td>1.44</td>
    </tr>
    <tr>
      <th>8</th>
      <td>Sept</td>
      <td>38.608</td>
      <td>1.52</td>
    </tr>
    <tr>
      <th>9</th>
      <td>Oct</td>
      <td>61.976</td>
      <td>2.44</td>
    </tr>
    <tr>
      <th>10</th>
      <td>Nov</td>
      <td>19.812</td>
      <td>0.78</td>
    </tr>
    <tr>
      <th>11</th>
      <td>Dec</td>
      <td>0.508</td>
      <td>0.02</td>
    </tr>
  </tbody>
</table>
</div>





### Determining Appropriate Inputs to Functions

Can the function `mm_to_in()` to take a list as an input? Look again at the code that the function executes. 

{:.input}
```python
def mm_to_in(mm):
    """Convert input from millimeters to inches. 
    
    Parameters
    ----------
    mm : int or float
        Numeric value with units in millimeters.

    Returns
    ------
    inches : int or float
        Numeric value with units in inches.
    """
    inches = mm / 25.4    
    return inches
```

Since you know that numeric calculations cannot be performed directly on a list, you know that this function will not execute successfully if provided a list as an input. 

This is an important idea to keep in mind as you write functions in **Python**. 

If the code will not execute outside of a function (e.g. numerical operation on a list), then the code will also not execute using a function, as the code is still subject to the rules governing the objects to which it is applied. 

This also highlights the importance of docstrings to provide clear descriptions of the type of inputs and outputs that are provided by the function. 


## Call Help on a Custom Function

Just like you can call `help()` on a function provided by a **Python** package such as **numpy** (e.g. `help(np.mean)`, you can also call `help()` on custom functions.  

{:.input}
```python
# Call help on mean function from numpy
help(np.mean)
```

{:.output}
    Help on function mean in module numpy:
    
    mean(a, axis=None, dtype=None, out=None, keepdims=<no value>)
        Compute the arithmetic mean along the specified axis.
        
        Returns the average of the array elements.  The average is taken over
        the flattened array by default, otherwise over the specified axis.
        `float64` intermediate and return values are used for integer inputs.
        
        Parameters
        ----------
        a : array_like
            Array containing numbers whose mean is desired. If `a` is not an
            array, a conversion is attempted.
        axis : None or int or tuple of ints, optional
            Axis or axes along which the means are computed. The default is to
            compute the mean of the flattened array.
        
            .. versionadded:: 1.7.0
        
            If this is a tuple of ints, a mean is performed over multiple axes,
            instead of a single axis or all the axes as before.
        dtype : data-type, optional
            Type to use in computing the mean.  For integer inputs, the default
            is `float64`; for floating point inputs, it is the same as the
            input dtype.
        out : ndarray, optional
            Alternate output array in which to place the result.  The default
            is ``None``; if provided, it must have the same shape as the
            expected output, but the type will be cast if necessary.
            See `ufuncs-output-type` for more details.
        
        keepdims : bool, optional
            If this is set to True, the axes which are reduced are left
            in the result as dimensions with size one. With this option,
            the result will broadcast correctly against the input array.
        
            If the default value is passed, then `keepdims` will not be
            passed through to the `mean` method of sub-classes of
            `ndarray`, however any non-default value will be.  If the
            sub-class' method does not implement `keepdims` any
            exceptions will be raised.
        
        Returns
        -------
        m : ndarray, see dtype parameter above
            If `out=None`, returns a new array containing the mean values,
            otherwise a reference to the output array is returned.
        
        See Also
        --------
        average : Weighted average
        std, var, nanmean, nanstd, nanvar
        
        Notes
        -----
        The arithmetic mean is the sum of the elements along the axis divided
        by the number of elements.
        
        Note that for floating-point input, the mean is computed using the
        same precision the input has.  Depending on the input data, this can
        cause the results to be inaccurate, especially for `float32` (see
        example below).  Specifying a higher-precision accumulator using the
        `dtype` keyword can alleviate this issue.
        
        By default, `float16` results are computed using `float32` intermediates
        for extra precision.
        
        Examples
        --------
        >>> a = np.array([[1, 2], [3, 4]])
        >>> np.mean(a)
        2.5
        >>> np.mean(a, axis=0)
        array([2., 3.])
        >>> np.mean(a, axis=1)
        array([1.5, 3.5])
        
        In single precision, `mean` can be inaccurate:
        
        >>> a = np.zeros((2, 512*512), dtype=np.float32)
        >>> a[0, :] = 1.0
        >>> a[1, :] = 0.1
        >>> np.mean(a)
        0.54999924
        
        Computing the mean in float64 is more accurate:
        
        >>> np.mean(a, dtype=np.float64)
        0.55000000074505806 # may vary
    



{:.input}
```python
# Call help on custom function
help(mm_to_in)
```

{:.output}
    Help on function mm_to_in in module __main__:
    
    mm_to_in(mm)
        Convert input from millimeters to inches. 
        
        Parameters
        ----------
        mm : int or float
            Numeric value with units in millimeters.
        
        Returns
        ------
        inches : int or float
            Numeric value with units in inches.
    



Notice that when you call `help()` on custom functions (e.g. `mm_to_in`), you will see the docstring that has been included in the function definition.  

The `help()` results for `np.mean` are simply longer because the docstring contains more information such as sections for Notes and Examples. 


## Combine Multiple Function Calls on a Single Object in Python

Imagine that you want to convert the units of a **numpy** array using the function `mm_to_in()` and then calculate a mean using `np.mean()`.

You could write code to complete each task one at a time:

{:.input}
```python
# Convert units and save to new array
avg_monthly_precip_in = mm_to_in(mm = avg_monthly_precip_mm)

# Calculate mean and save value
avg_monthly_precip_mean_in = np.mean(avg_monthly_precip_in)

print(avg_monthly_precip_mean_in)
```

{:.output}
    1.6858333333333333



However, you will end up with intermediate variables (e.g. `avg_monthly_precip_in`) that are not really needed.

Luckily, in **Python**, you can actually combine the calls to both of these functions into one line. 

To do this, you can use the function call: 

`mm_to_in(mm = avg_monthtly_precip_mm)`

as the input to `np.mean()` function, as shown below.

{:.input}
```python
# Convert to inches and calculate mean
avg_monthly_precip_mean_in = np.mean(mm_to_in(mm = avg_monthly_precip_mm))

avg_monthly_precip_mean_in
```

{:.output}
{:.execute_result}



    1.6858333333333333





In this example, the values of `avg_monthtly_precip_mm` are converted to inches first and then the mean of the converted values is calculated and stored as a new variable `avg_monthly_precip_mean_in`. 

Notice that the original function call to `mm_to_in()` looks the same as when you have called it before:

`mm_to_in(mm = avg_monthtly_precip_mm)`

It is now simply enclosed within the parenthesis `()` of the `np.mean()` function to tell **Python** that the output of `mm_to_in()` will be the input to the function `np.mean()`.

Combining related function calls into a single line of code allows you to write code that is much more efficient and less repetitive, assisting you in writing DRY code in **Python**. 

Congratulations! You have now written and executed your first custom functions in **Python** to efficiently modularize and execute tasks as needed.
