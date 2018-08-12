---
layout: single
title: 'Python Lists'
excerpt: "This lesson walks you through creating and editing Python lists."
authors: ['Jenny Palomino', 'Software Carpentry']
category: [courses]
class-lesson: ['python-variables-lists']
permalink: /courses/earth-analytics-bootcamp/python-variables-lists/lists/
nav-title: "Python Lists"
dateCreated: 2019-07-10
modified: 2018-08-12
module-type: 'class'
class-order: 2
course: "earth-analytics-bootcamp"
week: 2
sidebar:
  nav:
author_profile: false
comments: true
order: 2
topics:
  reproducible-science-and-programming: ['python']
---
{% include toc title="In This Lesson" icon="file-text" %}

In this lesson, you will write `Python` code to create lists containing multiple data values and to edit lists to update, add, and remove items in the list.

<div class='notice--success' markdown="1">

## <i class="fa fa-graduation-cap" aria-hidden="true"></i> Learning Objectives

After completing this lesson, you will be able to:

* Create new `Python` lists to store collections of values for integers, floats and text strings
* Use indexing to update, add, and remove items in an existing `Python` list  

 
## <i class="fa fa-check-square-o fa-2" aria-hidden="true"></i> What You Need

Be sure that you have completed the previous lesson on <a href="{{ site.url }}/courses/earth-analytics-bootcamp/python-variables-lists/variables/">Variables</a>.

The code below is available in the **ea-bootcamp-day-2** repository that you cloned to `earth-analytics-bootcamp` under your home directory. 

</div>
 
## Python Lists

In the previous lesson, you created variables to store single data values such as the average precipitation value for January in Boulder, CO. You define these variables by assigning a data value to a variable name using `=` (e.g. `jan = 0.70`). 

You can create a list of multiple values by using brackets (`[]`) to contain the values and then assigning that bracketed list of values to a variablename (e.g. `variablename = [1, 2, 3]` or `[variablename = ["text1", "text2"]`). 

An interesting feature of `Python` lists is that they can be used to store data using any combination of values, including a mix of integers, decimals, text strings, and even other existing variables. 

For example, you can create lists that store multiple integers or text strings.

{:.input}
```python
precip = [0.70, 0.75, 1.85]

months = ["January", "February", "March"]

print(precip)

print(months)
```

{:.output}
    [0.7, 0.75, 1.85]
    ['January', 'February', 'March']



You can also create a list that contains different types of data (e.g. integers, decimals, text strings), including existing variables.

{:.input}
```python
jan = 17.7799

alldata = [1, jan, "January"]

print(alldata)
```

{:.output}
    [1, 17.7799, 'January']



You can also create lists that contain text strings of names of files and directories on your computer, or the names of other data structures such as other lists. 

<i class="fa fa-star" aria-hidden="true"></i> **Data Tip:** If you create a list using the names of files or variables, the list will only store the text strings of the name of the file, directory, or data structure but not the actual values contained in that variable. 
{: .notice--success}

{:.input}
```python
filenames = ["precip.txt", "months.txt"]

print(filenames)
```

{:.output}
    ['precip.txt', 'months.txt']



## Indexing For Python Lists

In `Python`, indexing is used by many data structures such as lists to organize data and manage the order of the items or elements within the data structure. 

Each item in a `Python` list has an index, or a specified location in the collection of values. 

By default, `Python` will always begin indexing with `[0]`. Thus, the first item in a list has an index `[0]`, the second item in a list has an index `[1]`, and so on. 

This means that you can use the index of an item to query its value. In the example below, you can use `preciplist[2]` to get the 3rd item in the list (`1.85`). 

```python
preciplist = [0.70, 0.75, 1.85]
```
In this lesson, you will create new lists and use indexing to update, add, and remove items in lists.

You will again use data on average monthly precipitation for <a href="https://www.esrl.noaa.gov/psd/boulder/Boulder.mm.precip.html" target="_blank">Boulder, Colorado provided by the U.S. National Oceanic and Atmospheric Administration (NOAA)</a>, so you can see learn how to work with lists using a familiar dataset.  

Month  | Precipitation (inches) 
--- | --- 
Jan | 0.70
Feb | 0.75
Mar | 1.85
Apr | 2.93
May | 3.05
June | 2.02
July | 1.93
Aug | 1.62
Sept | 1.84
Oct | 1.31
Nov | 1.39
Dec | 0.84

## Begin Writing Your Code

Remember that adding `Python` comments before each code block can help you to document and explain what is being accomplished with that code.

Begin by creating variables for average monthly precipitation that you can compile into a list. Create variables for January through October that convert the values from inches to millimeters (1 inch = 25.4 mm).

{:.input}
```python
# create variables for January through October and convert the values from inches to millimeters (1 inch = 25.4 mm)
jan = 0.70 * 25.4
feb = 0.75 * 25.4
mar = 1.85 * 25.4
apr = 2.93 * 25.4
may = 3.05 * 25.4
june = 2.02 * 25.4
july = 1.93 * 25.4
aug = 1.62 * 25.4
sept = 1.84 * 25.4
oct = 1.31 * 25.4
```

## Create Lists

Recall that you can create a list of multiple values by using brackets (`[]`) to contain the values and then assigning that bracketed list of values to a variablename (e.g. `variablename = [1.2, 2.5, 3.7]` or `variablename = ["text1", "text2", "text3"]`).

For example, you can create a list that contains the variables you created for January through October.

{:.input}
```python
# create list `precip` from these variables
precip = [jan, feb, mar, apr, may, june, july, aug, sept, oct]

# print the data in `precip`
print(precip)
```

{:.output}
    [17.779999999999998, 19.049999999999997, 46.99, 74.422, 77.46999999999998, 51.308, 49.022, 41.148, 46.736, 33.274]



You can also create a list that contains text strings of the month names.

{:.input}
```python
# create list `months` to store the monthly names from January to October only
months = ["Jan", "Feb", "Mar", "Apr", "May", "June", "July", "Aug", "Sept", "Oct"]

# print the data in `months`
print(months)
```

{:.output}
    ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'June', 'July', 'Aug', 'Sept', 'Oct']



## Print the Length of a List
 
To work efficiently with indexing, it is very helpful to know how long the list is, meaning how many items are stored in the list. 

You can use the function `len()` to query this information by including the name of the list as a parameter, or input, to the function (e.g. `len(listname)`). 

{:.input}
```python
# print the length of list `months`
len(months)
```

{:.output}
{:.execute_result}



    10





You can see that `months` contains 10 items because it only includes January through October. 

## Query Items in Lists

Since you know that `Python` indexing begins with `[0]`, you can use indexing to query the value of the 10th item with `month[index]`, where index is equal to `10-1` or `9`.

{:.input}
```python
# check the value at index = [9]
months[9]
```

{:.output}
{:.execute_result}



    'Oct'





Using an index value that is larger than `number of items - 1` will result in an error because the index does not exist. 

{:.input}
```python
# change the index value in this cell from 9 to 10 to check what happens when you query for an index location that does not exist
months[9]
```

{:.output}
{:.execute_result}



    'Oct'





## Update Items in Lists

In addition to querying values, you can also use indexing to update items in a list by assigning a new value to that index location. 

For example, if you want to update the value stored at `months[index]`, you can assign a new value with:
`months[index]` = "New Text Value"

{:.input}
```python
# update the value at index = [9] to `October`
months[9] = "October"

# print the data in `months`
print(months)
```

{:.output}
    ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'June', 'July', 'Aug', 'Sept', 'October']



{:.input}
```python
# update the value at index = [9] back to `Oct`
months[9] = "Oct"

# print the data in `months`
print(months)
```

{:.output}
    ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'June', 'July', 'Aug', 'Sept', 'Oct']



## Add Items to an Existing List

To add new items to the end of an existing list, you can use the combined operator `+=` , which adds (`+`) the listed values after the `=` to the end of an existing list. 

For example, you can add new text strings using `listname += ["New text 1", "New text 2"]` and new numeric values using `listname += [9999.9999, 0.0]`.

You can also add items to the beginning of an existing list using the following syntax: 
`listname = ["New Value 1", "New Value 2"] + listname`.

Expand your code to add a new item for `Nov` to the end of `months`. 

{:.input}
```python
# add new item for `Nov` to the end of `months`
months += ["Nov"]

# print the data in `months`
print(months)
```

{:.output}
    ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'June', 'July', 'Aug', 'Sept', 'Oct', 'Nov']



Now, add a new item to the end of `precip` for the average precipitation value for November. Notice that you will have to create a variable for `nov` first. 

{:.input}
```python
# create new variable `nov` to convert the original precipitation value from inches to millimeters
nov = 1.39 * 25.4

# add new value for `nov` to the end of `precip` 
precip += [nov]

# print the data in `precip`
print(precip)
```

{:.output}
    [17.779999999999998, 19.049999999999997, 46.99, 74.422, 77.46999999999998, 51.308, 49.022, 41.148, 46.736, 33.274, 35.306]



## Append Items to an Existing List

You can also use the `append()` function of lists (also, referred to as a method of the list object) to add a single value to the end of an existing list. 

You can do this by calling `listname.append()`, which indicates that this function is an inherent method of the list object that is being used. 

{:.input}
```python
# append the item "December" to the end of `months`
months.append("December")

# print the values in `months`
print(months)
```

{:.output}
    ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'June', 'July', 'Aug', 'Sept', 'Oct', 'Nov', 'December']



## Delete Items From an Existing List

You can delete unwanted items from an existing list using the `del` statement, followed by the listname and the index location of the items that we want to remove (e.g. `del list_name[index]`). 

Remember: checking the length and content of a list is helpful before using indexing to modify the list.

{:.input}
```python
# print the length of `months`
len(months)
```

{:.output}
{:.execute_result}



    12





You can see that `months` has 12 items and an unwanted last item with the value `December`. 

You can remove the unwanted item using the `del` statement (e.g. `del list_name[index]`). 

{:.input}
```python
# delete the last item "December" from the end of `months`
del months[11]

# print the data in `months`
print(months)
```

{:.output}
    ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'June', 'July', 'Aug', 'Sept', 'Oct', 'Nov']



You now know how to create lists and use indexing to update, add, and delete items in lists. 

<div class="notice--warning" markdown="1">

## <i class="fa fa-pencil-square-o" aria-hidden="true"></i> Optional Challenge 

Test your `Python` skills to complete the lists for January through December:

1. Create a variable of the precipitation value for December and add it to `precip` (hint: `listname += [value]`).

2. Add the month name for December to `months` (hint: `listname.append(value)`). Be sure to use a name that matches the style of the other names in the list. 

3. Print each list to see the final values.

</div>


{:.output}
    [17.779999999999998, 19.049999999999997, 46.99, 74.422, 77.46999999999998, 51.308, 49.022, 41.148, 46.736, 33.274, 35.306, 21.336]
    ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'June', 'July', 'Aug', 'Sept', 'Oct', 'Nov', 'Dec']


