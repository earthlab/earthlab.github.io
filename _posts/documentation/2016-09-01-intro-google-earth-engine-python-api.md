---
layout: single
title: 'Introduction to the Google Earth Engine Python API'
date: 2016-09-01
authors: [Matt Oakley]
category: [tutorials]
excerpt: 'This tutorial outlines the process of installing the Google Earth Engine Python API client.'
sidebar:
  nav:
author_profile: false
comments: true
lang: [python]
lib: [ee]
---

In addition to the web-based IDE Google Earth Engine also provides a Python API that can be used on your local machine without the need to utilize a browser, although the capabilities of this API are reduced compared to the Code Editor/IDE.
This tutorial will go over how to setup the API on your machine as well as some basic Python scripts utilizing the API. 
It is important to note that the Python API does not support any kind of visual output; therefore, it is highly recommended that you use the Code Editor IDE.

## Setup

1. [Download Python](https://www.python.org/downloads/)
2. [Download pip](https://pip.pypa.io/en/stable/installing/)
3. Run the below command from a command-line to download/install the Python API client
    ```
    pip install google-api-python-client
    ```
4. Run the below command from a command-line to ensure you have the proper crypto libraries installed
    ```
    python -c "from oauth2client import crypt"
    ```
    If running this command results in an error message, you will need to download and install the proper crypto libraries. This can be accomplished by running the below command.
    ```
    pip install pyCrypto
    ```
5. Run the below command from a command-line to download/install the Earth Engine Python library
    ```
    pip install earthengine-api
    ```
6. Run the below command from a command-line to initialize the API and verify your account
    ```
    python -c "import ee; ee.Initialize()"
    ```
    This will result in an error message due to the fact that Google still needs to verify your account with Earth Engine and it currently does not have the proper credentials. 
    Therefore, run:
    ```
    earthengine authenticate
    ```
    This will open your default web-browser (ensure that you're currently logged into your Google account) and provide you with a unique key to verify your account. 
    Copy and paste the key into the terminal when prompted for the key.
7. Run python so that you're utilizing the Python Command Line Interface (CLI) and run the following commands to ensure that the Earth Engine Python API is properly installed
    ```
    python
    >>> import ee
    >>> ee.Initialize()
    >>> image = ee.Image('srtm90_v4')
    >>> print(image.getInfo())
    ```
    If you see metadata printed to the terminal and there are no errors then the Python API for Earth Engine is properly installed and you are ready to use it. If you were stuck or ran into errors not outline in this tutorial, a more in-depth tutorial can be found [here](https://developers.google.com/earth-engine/python_install)
    
## Examples
**Downloading Data** - Running below script will print the path used to download some elevation data from the NASA [Shuttle Radar Topography Mission](http://www2.jpl.nasa.gov/srtm/):

```
import ee

ee.Initialize()

# Get a download URL for an image.
image1 = ee.Image('srtm90_v4')
path = image1.getDownloadUrl({
    'scale': 30,
    'crs': 'EPSG:4326',
    'region': '[[-120, 35], [-119, 35], [-119, 34], [-120, 34]]'
})
print path
```

Many other examples can be found on [Google's Earth Engine API Repository on Github](https://github.com/google/earthengine-api/tree/master/python/examples).



