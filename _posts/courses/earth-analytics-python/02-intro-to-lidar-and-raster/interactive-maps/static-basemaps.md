---
layout: single
title: "Static Basemaps in Python"
excerpt: "This lesson covers creating static basemaps in Python"
authors: ['Leah Wasser', 'Martha Morrissey']
modified: 2018-09-25
category: [courses]
class-lesson: ['hw-lidar']
permalink: /courses/earth-analytics-python/lidar-raster-data/static-basemaps/
nav-title: 'Create static basemaps'
week: 2
sidebar:
  nav:
author_profile: false
comments: true
course: "earth-analytics-python"
order: 2
topics:
  data-exploration-and-analysis: ['data-visualization']
  spatial-data-and-gis:
  reproducible-science-and-programming: ['jupyter-notebook']
---
{% include toc title="In This Lesson" icon="file-text" %}

<div class='notice--success' markdown="1">

## <i class="fa fa-graduation-cap" aria-hidden="true"></i> Learning Objectives



After completing this tutorial, you will be able to:

* Create a quick basemap using contextily

* Or create a quick basemap using cartopy 


## <i class="fa fa-check-square-o fa-2" aria-hidden="true"></i> What You Need



You need `Python` and `Jupyter Notebooks` to complete this tutorial. Also you should have an `earth-analytics` directory setup on your computer with a `/data` directory with it.

</div>

{:.input}
```python
import contextily as ctx
import matplotlib.pyplot as plt
import geopandas as gpd
import geopy as gp
import numpy as np
import cartopy as cp
import cartopy.crs as ccrs
from cartopy.io import shapereader as shp
plt.ion()
```

{:.input}
```python
def zoom_bounds(minx, maxx, miny, maxy, factor):
    meanx = np.mean([minx, maxx])
    meany = np.mean([miny, maxy])

    width_start = maxx - minx
    height_start = maxy - miny
    if isinstance(factor, (list, tuple, np.ndarray)):
        fx, fy = factor
    else:
        fx = fy = factor
    
    width_new = width_start * fx
    height_new = height_start * fy
    
    newxmin = meanx - width_new / 2.
    newxmax = meanx + width_new / 2.
    newymin = meany - height_new / 2.
    newymax = meany + height_new / 2.
    
    return newxmin, newxmax, newymin, newymax
```

## Create basemap using Contextily

First, let's create a basemap that shows the location of our stream gage.

{:.input}
```python
myMap = ctx.Place('Boulder, Colorado', zoom_adjust=1)
```

{:.input}
```python
ax = ctx.plot_map(myMap, latlon=True)
ax.scatter(myMap.longitude, myMap.latitude, s=100);
```

Next, let's add a point to our map representing the location of our actual stream gage data.

Latitude: 40.051667
Longitude: 105.178333

USGS gage 06730200
40°03'06"	105°10'42"

{:.input}
```python
lat_lon = [-105.178333, 40.051667]
```

{:.input}
```python
ax = ctx.plot_map(myMap, latlon=True)
ax.scatter(*lat_lon, s=100, c='r');
```

## Create a basic map of the United States using Cartopy

{:.input}
```python
import matplotlib.patches as mpatches
import matplotlib.pyplot as plt
import shapely.geometry as sgeom

import cartopy.crs as ccrs
import cartopy.io.shapereader as shpreader
```

{:.input}
```python
def sample_data():
    """
    Return a list of latitudes and a list of longitudes (lons, lats)
    for Hurricane Katrina (2005).

    The data was originally sourced from the HURDAT2 dataset from AOML/NOAA:
    http://www.aoml.noaa.gov/hrd/hurdat/newhurdat-all.html on 14th Dec 2012.

    """
    lons = [-75.1, -75.7, -76.2, -76.5, -76.9, -77.7, -78.4, -79.0,
            -79.6, -80.1, -80.3, -81.3, -82.0, -82.6, -83.3, -84.0,
            -84.7, -85.3, -85.9, -86.7, -87.7, -88.6, -89.2, -89.6,
            -89.6, -89.6, -89.6, -89.6, -89.1, -88.6, -88.0, -87.0,
            -85.3, -82.9]

    lats = [23.1, 23.4, 23.8, 24.5, 25.4, 26.0, 26.1, 26.2, 26.2, 26.0,
            25.9, 25.4, 25.1, 24.9, 24.6, 24.4, 24.4, 24.5, 24.8, 25.2,
            25.7, 26.3, 27.2, 28.2, 29.3, 29.5, 30.2, 31.1, 32.6, 34.1,
            35.6, 37.0, 38.6, 40.1]

    return lons, lats


def main():
    fig = plt.figure()
    ax = fig.add_axes([0, 0, 1, 1], projection=ccrs.LambertConformal())

    ax.set_extent([-125, -66.5, 20, 50], ccrs.Geodetic())

    shapename = 'admin_1_states_provinces_lakes_shp'
    states_shp = shpreader.natural_earth(resolution='110m',
                                         category='cultural', name=shapename)

    lons, lats = sample_data()

    # to get the effect of having just the states without a map "background"
    # turn off the outline and background patches
    ax.background_patch.set_visible(False)
    ax.outline_patch.set_visible(False)

    ax.set_title('US States which intersect the track of '
                 'Hurricane Katrina (2005)')

    # turn the lons and lats into a shapely LineString
    track = sgeom.LineString(zip(lons, lats))

    # buffer the linestring by two degrees (note: this is a non-physical
    # distance)
    track_buffer = track.buffer(2)

    for state in shpreader.Reader(states_shp).geometries():
        # pick a default color for the land with a black outline,
        # this will change if the storm intersects with our track
        facecolor = [0.9375, 0.9375, 0.859375]
        edgecolor = 'black'

        if state.intersects(track):
            facecolor = 'red'
        elif state.intersects(track_buffer):
            facecolor = '#FF7E00'

        ax.add_geometries([state], ccrs.PlateCarree(),
                          facecolor=facecolor, edgecolor=edgecolor)

    ax.add_geometries([track_buffer], ccrs.PlateCarree(),
                      facecolor='#C8A2C8', alpha=0.5)
    ax.add_geometries([track], ccrs.PlateCarree(),
                      facecolor='none', edgecolor='k')

    # make two proxy artists to add to a legend
    direct_hit = mpatches.Rectangle((0, 0), 1, 1, facecolor="red")
    within_2_deg = mpatches.Rectangle((0, 0), 1, 1, facecolor="#FF7E00")
    labels = ['State directly intersects\nwith track',
              'State is within \n2 degrees of track']
    ax.legend([direct_hit, within_2_deg], labels,
              loc='lower left', bbox_to_anchor=(0.025, -0.1), fancybox=True)

    plt.show()


if __name__ == '__main__':
    main()
```

{:.output}
    Unknown exception thrown
    Unknown exception thrown
    Unknown exception thrown
    Unknown exception thrown
    Unknown exception thrown
    Unknown exception thrown
    Unknown exception thrown
    Unknown exception thrown
    Unknown exception thrown
    Unknown exception thrown
    Unknown exception thrown
    Unknown exception thrown
    Unknown exception thrown
    Unknown exception thrown
    Unknown exception thrown
    Unknown exception thrown
    Unknown exception thrown
    Unknown exception thrown
    Unknown exception thrown
    Unknown exception thrown
    Invalid argument (must be a Polygon)



{:.input}
```python
path = shp.natural_earth(category='cultural', name='admin_1_states_provinces_lakes_shp')
states = gpd.read_file(path)
#states = states.query('name not in ["Alaska", "Hawaii"]')
minx, miny, maxx, maxy = states.total_bounds
```

{:.input}
```python
path
```

{:.input}
```python
states.head()
```

{:.input}
```python
plt.plot(states)
```

{:.input}
```python
ax = plt.axes(projection=ccrs.PlateCarree())
gm = ax.add_geometries(states.geometry, ccrs.PlateCarree())
ax.set_title('USA')
ax.set_extent((minx, maxx, miny, maxy))
ax.figure.set_size_inches(10, 5)
```


Customize colors.




{:.input}
```python
ax = plt.axes(projection=ccrs.PlateCarree())
gm = ax.add_geometries(states.geometry, ccrs.PlateCarree(), alpha=.5, facecolor='darkgray', edgecolor='k')
ax.set_title('USA')
ax.set_extent((minx, maxx, miny, maxy))
ax.figure.set_size_inches(10, 5)
```

{:.input}
```python
# ```r

# map('state', col="darkgray", fill=TRUE, border="white")

# # add a title to your map

# title('Map of the United States')

# ```

```






Create a map of Colorado with county boundaries.






{:.input}
```python
# NOTE: We'll need to find a shapefile with county boundaries for this one...there isn't an auto search package
# in python like there is for R.
```

{:.input}
```python
from download import download
```

{:.input}
```python
url = "http://www2.census.gov/geo/tiger/GENZ2016/shp/cb_2016_us_county_500k.zip"
path = download(url, 'counties', '~/tmp/', zipfile=True)
```

{:.input}
```python
import os.path as op
path_data = op.join(path, 'cb_2016_us_county_500k.shp')
counties = gpd.read_file(path_data)
```

{:.input}
```python
counties = counties.query('STATEFP == "08"')
```

{:.input}
```python
colorado = states.query('name == "Colorado"')
bounds = colorado.bounds.values[0, [0, 2, 1, 3]]
bounds = zoom_bounds(*bounds, 1.2)
ax = plt.axes(projection=ccrs.PlateCarree())
gm = ax.add_geometries(colorado['geometry'], ccrs.PlateCarree(), alpha=.5, facecolor='darkgray', edgecolor='k')
ax.add_geometries(counties['geometry'], ccrs.PlateCarree(), facecolor='darkgray', edgecolor='k')
ax.set_title('Colorado')
ax.set_extent(bounds, crs=ccrs.PlateCarree())
ax.figure.set_size_inches(10, 5)
```

{:.input}
```python
# ```r

# map('county', regions="Colorado", col="darkgray", fill=TRUE, border="grey80")

# map('state', regions="Colorado", col="black", add=T)

# # add the x, y location of the stream guage using the points

# # notice i used two colors adn sized to may the symbol look a little brighter

# points(x=-105.178333, y=40.051667, pch=21, col="violetred4", cex=2)

# points(x=-105.178333, y=40.051667, pch=8, col="white", cex=1.3)

# # add a title to your map

# title('County Map of Colorado\nStream gage location')

# ```

```



<img src="{{ site.url }}/images/rfigs/course-materials/earth-analytics/week03/hw-ggmap-markdown/2017-02-01-hw02-ggmap/create-CO-map-colors-1.png" title="vector map of the CO with colors" alt="vector map of the CO with colors" width="100%" />



You can stack several map layers using `add=TRUE`. Notice you can create multi-line

titles using `\n`.






{:.input}
```python
fig = plt.figure()
ax = plt.axes(projection=ccrs.PlateCarree())

ax.add_geometries(states.geometry,
                  ccrs.PlateCarree(), alpha=.5, facecolor='darkgray', edgecolor='k')
ax.add_geometries(states.loc[states['name'] == "Colorado"].geometry,
                  ccrs.PlateCarree(), facecolor='green', edgecolor='w')
ax.set_title('Stream gage location\nBoulder, Colorado')
ax.set_extent(np.array(states.total_bounds)[[0, 2, 1, 3]])
ax.figure.set_size_inches(10, 5)

```

{:.input}
```python
# ```r



# map('state', fill=TRUE, col="darkgray", border="white", lwd=1)

# map(database = "usa", lwd=1, add=T)

# # add the adjacent parts of the US; can't forget my homeland

# map("state","colorado", col="springgreen",

#     lwd=1, fill=TRUE, add=TRUE)

# # add gage location

# title("Stream gage location\nBoulder, Colorado")

# # add the x, y location of hte stream guage using the points

# points(x=-105.178333, y=40.051667, pch=8, col="red", cex=1.3)

# ```

```

{:.input}
```python
print(cp.__version__)
```

{:.output}
    0.15.1



## Old Week3 HW 1 Question using contextily

{:.input}
```python
#PLOT 1: A basemap showing the location of the stream gage / study area created using folium

# gather data for map and stream gage coordinates
myMap = ctx.Place('Boulder, Colorado', zoom_adjust=1)
stream_coords = [-105.178333, 40.051667]

# create plot with 
ax = ctx.plot_map(myMap, latlon=True)
ax.scatter(*stream_coords, s=100);
```
