---
layout: single
title: "The GitHub Workflow - How to Contribute To Open Source Software"
excerpt: "Open source means that you can view and contribute to software code like packages you use in Python. Learn about the ways that you can contribute without being an expert progammer."
authors: ['Leah Wasser', 'Max Joseph', 'Lauren Herwehe']
modified: 2020-04-01
category: [courses]
class-lesson: ['open-source-software-python']
permalink: /courses/earth-analytics-python/contribute-to-open-source/contribute-to-open-source-on-github/
nav-title: 'Contribute with GitHub'
week: 13
course: "earth-analytics-python"
sidebar:
  nav:
author_profile: false
comments: true
order: 2
topics:
  reproducible-science-and-programming: ['python']
---

{% include toc title="In This Lesson" icon="file-text" %}

<div class='notice--success' markdown="1">

## <i class="fa fa-graduation-cap" aria-hidden="true"></i> Learning Objectives

After completing this tutorial, you will be able to:

* Be able to list the steps involved in contributing to an open source project
* Be able to make a small contribution through a pull request on GitHub to a repository.

## <i class="fa fa-check-square-o fa-2" aria-hidden="true"></i> What You Need

You will need a computer with internet access to complete this lesson.
</div>

## The Steps to Contributing to Open Source


This week you will contribute to the open source software package that you have been using in this class all semester - <a href="https://www.github.com/earthlab/earthpy" target="_blank">earthpy located on GitHub</a>. To contribute, follow the steps below.You can use the videos on Canvas to guide you through the steps listed below. 

### 1. Fork the Github Repo
Create a fork of the <a href="http://www.github.com/earthlab/earthpy" target="_blank">earthpy repository on GitHub</a>. Remember that a fork is a copy of a repository that is owned by someone else or an organization that lives in your GitHub account.

### 2. Clone Your Fork

Clone your fork of earthpy (remember your fork is the copy of earthpy in YOUR account), locally onto your computer so you can work on the required edits in a text editor rather than on GitHub. HINT: Clone means you are copying the repository from GitHub to your local computer.

### 3. Identify Changes That You Want to Make to earthpy Files

Study the earthpy code and documentation to identify what you’d like to update. Note that before you actually make changes you will submit an issue about those changes - so please keep reading before diving into your changes! But as you are studying the code, consider the different types of changes that you can make to earthpy without needing to be an expert programmer below:


* <a href="https://github.com/earthlab/earthpy/tree/master/docs" target="_blank">**Read the documentation:**</a> <a href="https://earthpy.readthedocs.io/" target="_blank">Documentation </a> can be found in the docs directory on earthpy as `.rst` files. You will notice that the earthpy documentation is limited. Pick a function that you have used in class that is missing documentation and update the `.rst` file! Or find documentation that has errors and needs to be fixed, you can update that too!
* **Update code syntax:**  Update the code to meet PEP 8 syntax standards. This type of update requires no coding expertise - it just requires you to know the PEP 8 syntax standards. HINT: You can use the autopep8 button in Jupyter Notebooks if you want to do this! For class this week if you update code, please edit the entire .py file. In general, however, you can make the smallest set of edits to code and they will likely be accepted with open arms! <a href="https://github.com/earthlab/earthpy/tree/master/earthpy" target="_blank">The earthpy code is located here in the earthpy subdirectory of the earthpy module.</a> You will often find code in a sub-directory that has the name of the main directory. 
* **Update function docstring documentation:** When you use the `help()` function in Python, the resulting text is what is found in the docstrings provided for each function in a Python package. Sometimes developers don’t have time to fully document all of the arguments, inputs and outputs of a function in a docstring as a function is updated. Other times you will find typos and mistakes. You can help fix these things!  
Following rasterio documentation, each function argument should be documented using the prescribed docstring syntax

```python
"""Text here describing what the function does.
    Wrapping like this.
    
    Parameters
    ----------
    argument-name : argument format (e.g. string) 
            Description of the variable indented by 4 spaces..

    Returns
    -------
    Whatever the function returns here. Follow the same format as arguments above.
    """
```
**Update, clean up and remove commented out code and extraneous comments from a function:** While finding messy code is less common in Python packages, there is plenty to clean up in earthpy. Dig in and identify items that could be removed! Submit your proposed changes as an issue and then a pull request if the issue is accepted. 


### 4. Submit a GitHub Issue About What You’d Like to Update

Before you submit any changes to a Python package, you need to consider communication etiquette. Open source developers often build packages to make your life easier because they are passionate about programming. They are donating their time to the community and as such, please approach package developers with respect and appreciation for what they contribute to the community! 

* To begin, review existing issues to ensure that the issue you have identified is not already being discussed. For the purposes of this class, you will review issues that have been opened by your classmates to ensure that no one else has submitted an issue to do the same thing. 
* Then open a new issue in the repository where the package lives. Be sure that the issue has a carefully crafted title that describes what you are proposing to fix. Some packages have templates associated with their issues that you can follow


<div class="notice--success" markdown="1">
<i class="fa fa-star"></i> **Pro Tip:**"
Make your GitHub issue title specific enough that people can tell what the issue is about without having to read all of the details. This makes it easier to quickly identify potentially overlapping issues. 
* For example a few good issue titles are below:
* Add readthedocs documentation to the `crop_image()` function.
* Update the spatial module (spatial.py) to following `PEP8` guidelines”. 

Bad / less descriptive issue title examples are below:
* Update documentation.
* Fix formatting
</div>
    

Consider including exactly what you want to change in the text of the issue. This might mean that you literally write the documentation text that you want to add to the issue. Or you might provide a code snipped that is not properly formatted and then an example of what you would fix (before and after code blocks). 

### 5. Submit a GitHub Pull Request (PR)

Once you have submitted your issue with the proposed changes, one of the developers of the package will review the issue. For the purposes of this class, someone from the earthlab team will review this issue and either:

* Suggest changes to your proposed edits or
* Encourage you to submit a pull request with the two identified changes.

When you have the go-ahead from someone in earthlab, you are ready to create and submit a pull request with your changes.

<i class="fa fa-star"></i> **Data Tip:** Be patient when you submit an issue to a repository. Developers are often busy and it’s likely that they will get to your issue with time. For this class you will find that because your instructors are also developing `earthpy`, you will get speedy responses! 
{: .notice--success}


#### Pull Request Criteria
Most packages have contributing guidelines. Read those first and follow them when submitting to a package. Earthpy is still developing their guidelines but that file is soon to come.

Once you have submitted an issue, and a developer from the package that you are submitting to (in this case the Earth Lab team) agrees to your proposed changes, you are ready to implement these changes locally on your computer and submit a pull request. 

## GitHub Workflow Summary

In summary, your workflow on GitHub will likely look something like this:

* `Fork` and `clone` the repository if you haven’t already done this. 
    * OPTIONAL: If you have already forked the repository but some time has passed. You should consider updating your fork. You can update your fork through a `reverse pull request` where the base is your copy of the repo - i.e. your fork (`your-username/earthpy`) and the head is the parent repository - i.e. (`earthlab/earthpy`). This will ensure that all of the files in your repository are current and will prevent merge conflicts. We won’t talk about merge conflicts this week in class but it’s good to be aware of this! 
* Make the desired changes to the repo on your computer locally. Test these changes as necessary. If the changes are to documentation, be sure to spell check! Then commit the changes and push them back to your fork. 
* Then finally, open a <kbd>Pull Request</kbd> to the parent repository, which for this class is:  earthlab/earthpy. In the text of the pull request, you should include a link to the URL of the issue that you opened (essentially linking the changes that your submitting to the problem that you are solving). This closes the documentation loop! 
* Finally, wait for the developers to review / comment on your PR. Be patient, this step can take time as people are busy and are often donating their time to this effort!

