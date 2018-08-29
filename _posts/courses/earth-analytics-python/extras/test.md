---
layout: single
title: "Customize your maps in python: GIS in Python"
excerpt: "In this lesson we review how to customize matplotlib maps created using vector data in Python. We will review how to add legends, titles and how to customize map colors."
authors: ['Chris Holdgraf', 'Leah Wasser']
modified: 2018-07-27
category: [courses]
class-lesson: ['hw-custom-maps-python']
permalink: /courses/earth-analytics-python/week-4/python-customize-map-legends-geopandas/
nav-title: 'Customize python maps'
module-title: 'Custom plots in Python'
module-description: 'This tutorial covers the basics of creating custom plot legends
in R'
module-nav-title: 'Spatial Data: Custom plots in Python'
module-type: 'homework'
course: 'earth-analytics-python'
week: 4
sidebar:
  nav:
author_profile: false
comments: true
order: 1
---

{:.input}
```python
print('not hidden')
```

{:.output}
    not hidden




{:.output}
    hidden



{:.input}
```python
import earthlab as et
e_class = et.io.EarthlabData()
e_class

```

{:.output}
{:.execute_result}



    Available Datasets: ['week_02', 'week_03', 'week_05', 'week_07', 'week_08', 'test']





{:.input}
```python
e_class.get_data= 'week_02', 
```
