---
layout: single
title: 'Download MODIS data programmatically with pyModis'
date: 2016-09-13
authors: [Zach Schira]
category: [tutorials]
excerpt: 'This tutorial shows how to acquire Modis satellite data using Python and the pyModis package.'
sidebar:
  nav:
author_profile: false
comments: true
lang: [python]
lib: [pymodis, os, glob]
---

The [pyModis](http://webcache.googleusercontent.com/search?q=cache:http://www.pymodis.org/_static/pyModis.pdf#27) python package allows for easy programmatic access to [Modis](http://modis.gsfc.nasa.gov/) data. This tutorial will demonstrate how to acquire specific modis data products using pymodis.


## Objectives
- Use pymodis to search for desired product
- Download data
 
## Dependencies
- pymodis
- os
- glob

To install pymodis you will need to clone the github repo, which can be found [here](https://github.com/lucadelu/pyModis). Once you have cloned pymodis, you will want to navigate into the repo on your local machine using the command line. Next you will want to run the setup.py script with the following command.


```python
!python setup.py install
```

Now that pymodis is installed, you can import the `downmodis` module. Do not worry if you get a warning reading `WxPython missing, no GUI enabled`. This is only needed for the pymodis GUI, which we will not be using.


```python
from pymodis import downmodis
import os
import glob
```

    WxPython missing, no GUI enabled


First we will set some parameters that will be used by the `downModis` class. Important parameters to include are the destination, the start date, how many days you would like to download, the product, and the tiles (specifies location of data). For more information on the Modis grid look [here](http://modis-land.gsfc.nasa.gov/MODLAND_grid.html). Note that using delta to specify the number of days can be counterintuitive, because it counts backwards from the start date.
 
We will be using the default [http server](http://e4ftl01.cr.usgs.gov), with the default path, `MOLT/`, for this data. This server has recently been updated to require an earthdata account, so you will need to follow this [link](https://urs.earthdata.nasa.gov/users/new), and create your own account. Once you have done this, replace the username and password in the following section of code (the ones provided will not work). If you are looking for Modis data that is not available on this server you can provide your own url, as well as a path to the data. Note that using a different server can become difficult if the directories on the server you are using are organized in a way pymodis does not recognize.


```python
dest = "/temp"
#Create temp directory to store data
if(not os.path.exists(dest)):
    os.makedirs(dest)

tiles = "h17v04,h18v04"
product = "MOD14A1.005"
day = "2016-07-11"
# number of days to download
delta = 1
user = 'username'
password = '1234'
```

Now we can can create a `downmodis` object using these given parameters.


```python
modis = downmodis.downModis(destinationFolder=dest, product=product, tiles=tiles, delta=delta, user=user, password=password)
modis.connect()
```

This next command will download the data for every day you have specified.


```python
modis.getListDays()
modis.downloadsAllDay()
```

Now we will collect all of the downloaded hdf files using `glob`, and print the file names.


```python
files = glob.glob(os.path.join(dest, '*.hdf'))
print(files)
```

    ['/temp\\MOD14A1.A2016225.h17v04.005.2016234234423.hdf', '/temp\\MOD14A1.A2016225.h18v04.005.2016234234429.hdf']

