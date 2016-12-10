---
layout: single
title: 'Get Modis sinusoidal tile grid positions from latitude and longitude coordinates in Python'
date: 2016-08-04
authors: [Zach Schira]
category: [tutorials]
excerpt: 'This tutorial demonstrates how to convert Modis sinusoidal tile grid positions to latitude and longitude in Python.'
sidebar:
  nav:
author_profile: false
comments: true
lang: [python]
lib: [numpy]
---

Many Modis data products are organized in a tile grid based on a sinusoidal projection. 
You can find an online calculator [here](http://landweb.nascom.nasa.gov/cgi-bin/developer/tilemap.cgi), that will convert from tiles to latitude and longitude coordinates. 
This tutorial will demonstrate how to perform this conversion in Python.

## Objectives

- Read in Modis tile bounding coordinates
- Define point with given latitude and longitude coordinates
- Find corresponding tile

## Dependencies

- numpy


```python
import numpy as np
```

Modis provides a text file containing the range of latitude and longitude coordinates for each tile. We will load this data into a numpy two dimensional array. Next, we will define the coordinates of the point we would like to convert.


```python
data = np.loadtxt('../data/SinusoidalGrid.txt')
lat = 40.015
lon = -105.2705
```

Now we can loop through each row (corresponds to one tile) in the array and check to see if our point is contained in the range of coordinates for that tile.


```python
in_tile = False
i = 0
while(not in_tile):
    in_tile = lat >= data[i, 4] and lat <= data[i, 5] and lon >= data[i, 2] and lon <= data[i, 3]
    i += 1
```

Once you reach a tile including the point you are searching for the code will exit the loop, and you can print the vertical and horizontal position of the tile.


```python
vert = data[i-1, 0]
horiz = data[i-1, 1]
print('Vertical Tile:', vert, 'Horizontal Tile:', horiz)
```

    Vertical Tile: 4.0 Horizontal Tile: 9.0

