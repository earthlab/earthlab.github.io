---
layout: single
title: 'Convert lat/lon coordinates to Landsat 8 path/row in Python'
date: 2016-08-04
modified: 2020-04-08
authors: [Zach Schira]
category: [tutorials]
excerpt: 'This tutorial demonstrates how to convert Landsat 8 path/row coordinates to latitude and longitude in Python.'
estimated-time: "20-30 minutes"
difficulty: "beginner"
sidebar:
  nav:
author_profile: false
comments: true
lang: [python]
lib: [ogr, shapely]
---
The Landsat 8 satellite uses the [WRS-2](https://landsat.gsfc.nasa.gov/the-worldwide-reference-system/) reference system to catalog data. This referece system uses paths and rows, which are derived from the satellites orbit. You may find it useful to be able to convert between the WRS-2 paths and rows to latitude and longitude coordinates. This tutorial will demonstrate how to programmatically perform the conversion in python.

## Objectives

- Import WRS-2 shapefiles
- Define point with given latitude and longitude coordinates
- Find corresponding path/row

## Dependencies

- ogr
- shapely.wkt
- shapely.geometry

{:.input}
```python
import io
import ogr
import shapely.wkt
import shapely.geometry
import urllib.request
import zipfile
```

First we need to download and unzip the WRS-2 shapefiles which can be found on the USGS Landsat website.
For this tutorial we will use the descending orbit (daytime) data for Landsat 4-8, but ascending data and data for Landsat 1-3 are also available: https://www.usgs.gov/land-resources/nli/landsat/landsat-path-row-shapefiles-and-kml-files

{:.input}
```python
url = "https://prd-wret.s3-us-west-2.amazonaws.com/assets/palladium/production/s3fs-public/atoms/files/WRS2_descending_0.zip"
r = urllib.request.urlopen(url)
zip_file = zipfile.ZipFile(io.BytesIO(r.read()))
zip_file.extractall("landsat-path-row")
zip_file.close()
```

Then we can read the shapefile that we just downloaded.

{:.input}
```python
shapefile = 'landsat-path-row/WRS2_descending.shp'
wrs = ogr.Open(shapefile)
layer = wrs.GetLayer(0)
```

Define latitude and longitude coordinates for your desired location. For this example we will use the coordinates of Boulder, Colorado. With these coordinates, we can create a point using shapely. You also must define the mode as ascending or descending ('A', 'D'). Ascending corresponds to nightime images, and descending to daytime images.

{:.input}
```python
lon = -105.2705
lat = 40.0150
point = shapely.geometry.Point(lon, lat)
mode = 'D'
```

Now we will define a helper function called `checkPoint`. This function will take the geometry from a feature, which corresponds to a specific path and row, and check to see if the point we are looking for is contained in the feature, and if it is the correct mode. We will then loop through each feature, until we find one with our point. After this is done, we will print the path and row corresponding to the desired point.

{:.input}
```python
def checkPoint(feature, point, mode):
    geom = feature.GetGeometryRef() #Get geometry from feature
    shape = shapely.wkt.loads(geom.ExportToWkt()) #Import geometry into shapely to easily work with our point
    if point.within(shape) and feature['MODE']==mode:
        return True
    else:
        return False

i=0
while not checkPoint(layer.GetFeature(i), point, mode):
    i += 1
feature = layer.GetFeature(i)
path = feature['PATH']
row = feature['ROW']
print('Path: ', path, 'Row: ', row)
```

{:.output}
    Path:  34 Row:  32



