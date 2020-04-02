---
layout: single
title: "Introduction to Open Source Software - What Is It and How Can You Help?"
excerpt: "Open source means that you can view and contribute to software code like packages you use in Python. Learn about the ways that you can contribute without being an expert progammer."
authors: ['Leah Wasser', 'Max Joseph', 'Tim Head', 'Lauren Herwehe', 'Jenny Palomino']
modified: 2020-04-01
category: [courses]
class-lesson: ['open-source-software-python']
module-title: 'How To Contribute to Open Source Software'
module-description: 'Learn how you can contribute to open source software.'
module-nav-title: 'Contribute To Open Source'
module-type: 'class'
class-order: 1
permalink: /courses/earth-analytics-python/contribute-to-open-source/intro-to-open-source-software-python/
nav-title: 'Intro to Open Source'
week: 13
course: "earth-analytics-python"
sidebar:
  nav:
author_profile: false
comments: true
order: 1
topics:
  reproducible-science-and-programming: ['python']
---

{% include toc title="In This Lesson" icon="file-text" %}

<div class='notice--success' markdown="1">

## <i class="fa fa-graduation-cap" aria-hidden="true"></i> Learning Objectives

After completing this tutorial, you will be able to:

* Describe 2-4 ways that a non expert programming can contribute to open source software
* Describe what open source software is and who contributes to it.

## <i class="fa fa-check-square-o fa-2" aria-hidden="true"></i> What You Need

You will need a computer with internet access to complete this lesson.
</div>


## Overview
The tools that you are using in Python including rasterio, geopandas, matplotlib and even Python itself are all open source tools. Open source means that you can view and even contribute to the source code of these software packages. Open source projects are often built and maintained by communities of developers and users.

## Who Develops Open Source Tools?

Anyone can develop open source tools. Sometimes the tools are developed by people like you who may have started learning on their own and developed their programming skills over time. Other times the people developing these tools are expert developers who do this as a part of their jobs. For example, <a href="https://github.com/mapbox/rasterio" target="_blank">rasterio</a> is developed by the staff at Mapbox to support company needs. However, this tool is also widely used by the Python spatial community to work with raster data. <a href="https://github.com/mapbox/rasterio" target="_blank">Geopandas</a>, on the other hand, another spatial tool devoted to working with spatial vector data in Python, is developed by a group of Python enthusiasts who have expert programming skills but who are not necessarily paid to build Geopandas.

## How Can You Contribute?
You may be thinking that you can’t contribute to open source software because “you are not an expert … yet”. However, you can actually contribute right now! 

### Two Tips To Help You Get Started

Below are two tips that can help you get started:
 
1. **Contribute to a tool or package that you already use:** You will be more familiar with a tool that you know, making it easier to contribute.  
2. **Start small:** The size of your contribution doesn’t matter. Every contribution counts! Start with small changes. For example, maybe you fix just a few words in the documentation instead of diving into code fixes. This allows you to practice contributing without worrying about the content (assuming you are a native English speaker). Small contributions are how most people who are now prolific open source contributors get started!

Here are some ways that you can contribute to open source without being an expert:

* **Identify a Bug:** You can submit an issue about a bug that is specific enough to troubleshoot. This issue needs to be VERY specific outlining what you tried, what you expected to happen, and what the outcome actually was. In addition, you want to let the developers know the version of Python and associated packages you are running and your operating system.
* **Add / Update / Edit Code Documentation:** Documentation is an important part of software development, but is often missing, unclear or outdated - especially if the developers are volunteering their time. This is where you can help. As a new user you bring fresh eyes to the project’s documentation, and may make fewer assumptions about how a function should work than an expert user. This means that you will catch things that someone working on the code might miss! You can submit an issue that describes the problem, and then update code documentation to resolve the issue. If the authors agree to your proposed changes, then your updates can be integrated into the documentation via GitHub. 
* **Improve function docstrings:** In Python, the function docstring is what you see when you use the `help(function-name-here)` function. Sometimes arguments within functions are not well defined in the code. Or perhaps there are typos in the definitions. There also may be a mismatch between the behavior described in the docstring and the actual behavior of the code as tools are updated by the community. You can submit an issue about updating code function or class documentation, and potentially update the docstrings to solve the issue.
* **Fix code syntax and formatting:** Is the package following strict PEP 8 guidelines? You could help the developers clean up their code by submitting an issue that proposes to fix syntax errors!

```python
def some-function(val):
“””
This is the docstring where you can document a function. This is what appears to describe the function when you type help(function-name) into the Python console.
parameters
--------------
   Val: int
        An integer that you wish to add 1 to.
“””
    newval = val+1
    return(newval)
```

## Improve Your Skills Through Contributing

Contributing to open source software not only helps the open source community, it helps you too:

1. You will get better at writing code by reading other developers' code. This is similar to how reading can help you improve your writing.
2. Documenting code makes you think critically about what the code does. You will find over time that writing good documentation that helps you use someone else's software will help you better document your own workflows.
3. Contributing to open source software on GitHub will help you beef up your git skills! You may feel shy about using git and GitHub but practice makes perfect.  
4. Build your online technical presence. Your GitHub profile can be a testament to *some* of your technical skills. Build your online presence early by putting your work online and contributing to other code bases - such as open source Python projects.

## Contributions to Open Source for Class This week
This week you will contribute to the open source software package that you have been using in this class all semester - <a href="https://www.github.com/earthlab/earthpy" target="_blank">earthpy located on GitHub</a>.

