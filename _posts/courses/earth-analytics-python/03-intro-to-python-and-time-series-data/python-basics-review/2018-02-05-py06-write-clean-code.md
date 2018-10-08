---
layout: single
title: "Write Clean Python Code - Expressive programming 101"
excerpt: 'This lesson covers the basics of clean coding meaning that we ensure that the code that we write is easy for someone else to understand. We will briefly cover style guides, consistent spacing, literate object naming best practices.'
authors: ['Leah Wasser', 'Data Carpentry']
modified: 2018-10-08
category: [courses]
class-lesson: ['get-to-know-python']
course: 'earth-analytics-python'
nav-title: 'Write Clean Code'
permalink: /courses/earth-analytics-python/use-time-series-data-in-python/write-clean-code-with-python/
module-type: 'class'
week: 3
sidebar:
  nav:
author_profile: false
comments: true
order: 6
topics:
  reproducible-science-and-programming: ['python']
---


{% include toc title="In This Lesson" icon="file-text" %}



This lesson reviews best practices associated with clean coding.



<div class='notice--success' markdown="1">



## <i class="fa fa-graduation-cap" aria-hidden="true"></i> Learning Objectives

At the end of this activity, you will be able to:



* write code using the PEP 8 style guide



## <i class="fa fa-check-square-o fa-2" aria-hidden="true"></i> What You Need



You need `Python 3.x` and `Jupyter notebooks` to complete this tutorial. Also you should have an `earth-analytics` directory setup on your computer with a `/data` directory with it.


***



### Resources

* <a href="https://www.python.org/dev/peps/pep-0008/" target="_blank" data-proofer-ignore=''>PEP 8 Python Style Guide</a>



</div>


Clean code means that your code is organized in a way that is easy for you and for someone else to follow / read. Certain conventions are suggested to make code easier to read. For example, many guides suggest the use of a space after a comment. Like so:


```python

#poorly formatted  comments are missing the space after the pound sign.

# good comments have a space after the pound sign

```

While these types of guidelines may seem unimportant when you first begin to code, after a while you're realize that consistently formatted code is much easier for your eye to scan and quickly understand.



## Consistent, Clean Code

Take some time to review <a href="https://www.python.org/dev/peps/pep-0008/" target="_blank" data-proofer-ignore=''>PEP 8 Python Style Guide</a>. From here on in, we will follow this guide for all of the assignments in this class.



## Object Naming Best Practices

1. **Keep object names short:** this makes them easier to read when scanning through code.

2. **Use meaningful names:** For example: `precip` is a more useful name that tells us something about the object compared to `x`

3. **Don't start names with numbers!** Objects that start with a number are NOT VALID in `Python`.

4. **Avoid names that are existing functions in Python:** e.g., `if`, `else`, `for`, see [here](https://www.programiz.com/python-programming/keywords-identifier) for more reserved names.



A few other notes about object names in `Python`:

* `Python` is case sensitive (e.g., `weight_kg` is different from `Weight_kg`).
* Avoid other function names (e.g. `mean`,).
* Use nouns for variable names, and verbs for function names.
* Avoid using dots in object names - e.g. `my.dataset` - dots have a special meaning in R (for methods) and other programming languages. Instead use underscores `my_dataset`.

<div class="notice--warning" markdown="1">


## <i class="fa fa-pencil-square-o" aria-hidden="true"></i> Challenge

Take a look at the code below.

* Create a list of all of the things that could be improved to make the code easier to read / work with.
* Add to that list things that don't fit the PEP 8 style guide standards.
* Try to run the code in `Python`. Any issues?


<!--

FORMAT Issues:
* missing spaces in between comments
* comments aren't useful to help me understand what is happening



Object Naming Issues
* didn't use useful object names that describe the object
* one very long object name
* used a mixture of underscore and case that will be easy to confused 


-->

</div>

{:.input}
```python
variable = 3 * 6
meanvariable = variable


# calculate something important
mean_variable = meanvariable * 5

thefinalthingthatineedtocalculate = mean_variable + 5
```

{:.input}
```python
# get things that are important
import pandas as pd
%matplotlib inline
```

{:.input}
```python
import earthpy as et
paths = et.data.get_data('week_02')
my_data = pd.read_csv(paths[0])
my_data.head()
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
      <th>Unnamed: 0</th>
      <th>DATE</th>
      <th>PRECIP</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>756</td>
      <td>2013-08-21</td>
      <td>0.1</td>
    </tr>
    <tr>
      <th>1</th>
      <td>757</td>
      <td>2013-08-26</td>
      <td>0.1</td>
    </tr>
    <tr>
      <th>2</th>
      <td>758</td>
      <td>2013-08-27</td>
      <td>0.1</td>
    </tr>
    <tr>
      <th>3</th>
      <td>759</td>
      <td>2013-09-01</td>
      <td>0.0</td>
    </tr>
    <tr>
      <th>4</th>
      <td>760</td>
      <td>2013-09-09</td>
      <td>0.1</td>
    </tr>
  </tbody>
</table>
</div>





{:.input}
```python
my_data.plot('DATE', 'PRECIP', figsize = (20, 20), color = 'purple');
```

{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}//images/courses/earth-analytics-python/03-intro-to-python-and-time-series-data/python-basics-review/2018-02-05-py06-write-clean-code_5_0.png" alt = "You can create a simple plot of a pandas dataframe using the plot function and providing the columns containing the x and y axes. This example plots display daily precipitation data in the fall of 2013 in Boulder, CO.">
<figcaption>You can create a simple plot of a pandas dataframe using the plot function and providing the columns containing the x and y axes. This example plots display daily precipitation data in the fall of 2013 in Boulder, CO.</figcaption>

</figure>



