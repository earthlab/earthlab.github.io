---
layout: single
title: 'Introduction to the Google Earth Engine code editor'
date: 2016-09-01
authors: [Matt Oakley]
category: [tutorials]
excerpt: 'This tutorial introduces the code editor in Google Earth Engine and shows how to use LandSat imagery using the JavaScript API.'
sidebar:
  nav:
author_profile: false
comments: true
lang: [javascript]
lib:
---

Google Earth Engine is a geospatial processing platform which allows for the visualization and analysis of data on a planetary scale. 
Since this application is cloud-based, this allows for much faster processing speeds compared to running such an application on your local machine. 
Additionally, by using Google Earth Engine, you'll have access to Google's Data Catalog/Archive which hosts over 40 years of historical and current data in Landsat (4, 5, 7, and 8) and Moderate Resolution Imaging Spectro-Radiometer (MODIS) formats. 
You can upload your own raster/vector data which can be kept private or made publicly available. 
This tutorial introduces the JavaScript API for Google Earth Engine.

## Accessing Google Earth Engine

While Google Earth Engine is free to use, you still need to register your Google account in order to gain access to the service. 
Head to the [Google Earth Engine Signup Page](https://signup.earthengine.google.com) and provide the necessary credentials. 
You will receive an email with links to the web-based IDE, documentation, etc. 
Please note that it may take ~24 hours to receive this confirmation email.

## Google Earth Engine Code Editor (IDE)

Earth Engine can be used straight from your web browser via the Earth Engine Code Editor. 
This allows for much quicker data processing and the ability to immediately visualize your data. 
Once you've received the confirmation email, open up the [Code Editor](https://code.earthengine.google.com/) in your browser.

### Features

The Code Editor is split up into 4 different modules: Manager, Code Editor, Console, and Map.

**Manager** 

The Manager (top-left) can be thought of as an elementary file system for Earth Engine. 
The Manager is split up into 3 different sub-modules: 

- Scripts (where your scripts are stored in addition to examples provided by Google) 
- Docs (documentation for Earth Engine) 
- Assets (where you can upload local files to Earth Engine). 

**Code Editor**

The Code Editor (top-center) is where you can write and execute scripts written in JavaScript. 
This editor will format your code, underline code with problems, autocomplete, and offer completion hints for Earth Engine functions. 
Buttons to run/reset/save your scripts are found above the code editor itself.

**Console** 

The Console (top-right) is split up into 3 different sub-modules: Inspector, Console, and Tasks. 
The Inspector allows you to interactively query the map via clicking aspects on the Map. 
The Console is where any text from print() statements in your scripts will be printed - typically to get metadata from files being used in your script. 
The Tasks sub-module is used to view jobs/tasks that you've submitted which are going to take a large amount of time to complete.

**Map** 

The Map (bottom) is where any visual output from your script will be present and viewable on top of a 15-meter base map image of Earth.

### Introduction to JavaScript

Scripts written in the code editor on the web-based IDE must be written in JavaScript. 
JavaScript is a fairly straight-forward programming language to use/learn. 
JavaScript datatypes consist of Strings, Numbers, Booleans, Arrays, and Objects. 
All of the basic operators are supported such as + (add/concatenation), = (assignment), === (equality), ! (negation), !== (not equal), etc. 
Essentially everything in Javascript such as a variable or function is an *object* due to the fact that JavaScript is an object-oriented programming language. 
A simple 'Hello World!' program written in JavaScript is below. 
More documentation on the basics of JavaScript can be found [here](https://developer.mozilla.org/en-US/Learn/Getting_started_with_the_web/JavaScript_basics).

```
/* The below script will print 'Hello World!' to the console */
var string_to_print = 'Hello World!'
string_to_print
```

Additionally, Earth Engine has specialized data structures such as *Image* and *Feature* which correspond to raster and vector data, respectively. 
Features on the map are composed of a *Geometry*. 
A stack of images is an *ImageCollection* and a collection of features is a *FeatureCollection*. 
Other fundamental JavaScript data structures such as dictionaries, lists, arrays, number, string, etc. are also available.

### Using Landsat imagery in Earth Engine

Now it's time to start creating and running scripts on Earth Engine. 
Copy and paste the below line into the Code Editor and press 'Run'.

```
print(ee.Image('LANDSAT/LC8_L1T/LC80440342014077LGN00'));
```

Earth Engine gives you access to an enormous amount of data hosted by Google. 
The above line is utilizing the LC80440342014077LGN00 Landsat file from Google's archive. 
You'll see metadata for this file such as the type, id, band names, extents, etc. printed to the Console. 
After running the above line and inspecting the metadata for the file, copy and paste the below line and press 'Run'.

```
/* Load an image and store it in a variable called 'image' */
var image = ee.Image('LANDSAT/LC8_L1T/LC80440342014077LGN00');

/* Center the map on the image and set the zoom level to 9*/
Map.centerObject(image, 9);

/* Display the image */
Map.addLayer(image);
```

After running the above script, the Map should now be zoomed in to the coast of Central California with a dark, Landsat image overlaid on top of the default map. 
This is the core functionality of Google Earth Engine: acquire data, load it in, and display/visualize it onto the Map.

As another example, copy and paste the code below into the Code Editor and press 'Run'.

```
/* Load the image from the archive */
var image = ee.Image('LANDSAT/LC8_L1T/LC80440342014077LGN00');

/* Define visualization parameters in an object literal */
var vizParams = {bands: ['B5', 'B4', 'B3'], min: 5000, max: 15000, gamma: 1.3};

/* Center the map on the image and display */
Map.centerObject(image, 9);
Map.addLayer(image, vizParams, 'Landsat 8 false color');
```

This script will visualize the same data but now only use bands named 'B5', 'B4', and 'B3' with additional parameters such as min, max, and gamma extents.

Add the below code segment to the editor and press 'Run' again.

```
var counties = ee.FeatureCollection('ft:1S4EB6319wWW2sWQDPhDvmSBIVrD3iEmCLYB7nMM');
Map.addLayer(counties, {}, 'counties');
```

Now all of the counties in the US should be visualized on the Map.

### Next steps

While the above section conveyed some of the core aspects of Google Earth Engine, the example provided is about as simple as it gets. 
If you're interested in diving deeper into Google Earth Engine, you can read the [Earth Engine Documentation](https://developers.google.com/earth-engine/getstarted) which explains and provides examples for mechanisms such as filtering, sorting, band math, mapping, reducing, masking, etc.

A complete listing of all data that you have access to via Google's Data Catalog can be found [here](https://code.earthengine.google.com/datasets).
