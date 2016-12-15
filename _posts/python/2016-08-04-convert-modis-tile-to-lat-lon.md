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
lib: [numpy, urllib2]
---

Many MODIS data products are organized in a tile grid based on a sinusoidal projection. 
You can find an online calculator [here](http://landweb.nascom.nasa.gov/cgi-bin/developer/tilemap.cgi), that will convert from tiles to latitude and longitude coordinates. 
This tutorial will demonstrate how to perform this conversion in Python.

## Objectives

- Read in MODIS tile bounding coordinates
- Define point with given latitude and longitude coordinates
- Find corresponding tile

## Dependencies

- wget
- numpy
- urllib2


```python
import numpy as np
import urllib2
```

MODIS provides a text file containing the range of latitude and longitude coordinates for each tile. We will load this data into a numpy two dimensional array. Next, we will define the coordinates of the point we would like to convert.


```python
!wget https://modis-land.gsfc.nasa.gov/pdf/sn_bound_10deg.txt
```

    --2016-12-14 16:28:08--  https://modis-land.gsfc.nasa.gov/pdf/sn_bound_10deg.txt
    Resolving modis-land.gsfc.nasa.gov... 129.164.179.244, 2001:4d0:2310:150::244
    Connecting to modis-land.gsfc.nasa.gov|129.164.179.244|:443... connected.
    HTTP request sent, awaiting response... 200 OK
    Length: 32585 (32K) [text/plain]
    Saving to: ‘sn_bound_10deg.txt’
    
    sn_bound_10deg.txt  100%[===================>]  31.82K  --.-KB/s    in 0.05s   
    
    2016-12-14 16:28:08 (610 KB/s) - ‘sn_bound_10deg.txt’ saved [32585/32585]
    



```python
# first seven rows contain header information
# bottom 3 rows are not data
data = np.genfromtxt('sn_bound_10deg.txt', 
                     skip_header = 7, 
                     skip_footer = 3)
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

    ('Vertical Tile:', 4.0, 'Horizontal Tile:', 9.0)

