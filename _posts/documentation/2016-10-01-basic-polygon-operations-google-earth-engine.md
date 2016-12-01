---
layout: single
title: 'Calculating the area of polygons in Google Earth Engine'
date: 2016-10-01
authors: [Matt Oakley]
category: [tutorials]
excerpt: 'This tutorial demonstrates polygon creation, perimeter and area calculations, and visualization using the JavaScript interface to Google Earth Engine.'
sidebar:
  nav:
author_profile: false
comments: true
lang: [javascript]
lib:
---

As we've seen in previous tutorials covering the Google Earth Engine IDE and Python API, Earth Engine is an extremely powerful and fast way to analyze and visualize geospatial data. 
This tutorial will cover creating a polygon on the map and computing/printing out to the console information such as area, perimeter, etc about the polygon.

## Objectives

- Plot a polygon onto the map
- Compute and print out information about the polygon

## Dependencies

- Access to [Google Earth Engine's Code Editor](https://code.earthengine.google.com/)

## Creating/Plotting a Polygon

Our first objective will be to create a polygon and display it on the map. 
Let's have this polygon cover all of Boulder, CO. 
Copy and paste the following code into the Earth Engine Code Editor:

```
// Create a geodesic polygon containing Boulder, CO
var boulder = ee.Geometry.Polygon([
  [[-105.35, 39.95], [-105.35, 40.05],[-105.2, 40.05], [-105.2, 39.95], [-105.2, 39.95]]
]);

// Display the polygon on the map
Map.centerObject(boulder);
Map.addLayer(boulder, {color: 'FF0000'}, 'geodesic polygon');
```

After running the following script, you should see a red rectangle displayed on the map centered in Boulder, CO.

![Imgur](https://i.imgur.com/64yOQOh.png)

## Computing polygon area and perimeter

Copy and paste the following code into the Code Editor under the code that we've already ran:

```
// Print polygon area in square kilometers.
print('Polygon area: ', boulder.area().divide(1000 * 1000));

// Print polygon perimeter length in kilometers.
print('Polygon perimeter: ', boulder.perimeter().divide(1000));
```

After running this, you should see values for the area (km^2) and perimeter (km) printed to the Console. 
Earth Engine can provide us with additional information/output which may be useful.

```
// Print the geometry as a GeoJSON string.
print('Polygon GeoJSON: ', boulder.toGeoJSONString());

// Print the GeoJSON 'type'.
print('Geometry type: ', boulder.type());

// Print the coordinates as lists.
print('Polygon coordinates: ', boulder.coordinates());

// Print whether the geometry is geodesic.
print('Geodesic? ', boulder.geodesic());
```
