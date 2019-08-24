---
layout: single
title: "How to Download and Install QGIS"
excerpt: "QGIS is a free, open-souce GIS tool that is comparable to ArcMap. This lesson walks through how to install QGIS on your computer."
authors: ['Leah Wasser']
modified: 2016-12-30
category: [courses]
class-lesson: ['write-clean-code']
permalink: /courses/earth-analytics/time-series-data/download-install-qgis/
nav-title: 'Install QGIS'
week: 2
sidebar:
  nav:
author_profile: false
comments: true
order: 3
course: "earth-analytics"
topics:
  spatial-data-and-gis:
---


{% include toc title="In This Lesson" icon="file-text" %}

This lesson walks you through installing `QGIS` on your laptop.

<div class='notice--success' markdown="1">

## <i class="fa fa-graduation-cap" aria-hidden="true"></i> Learning Objectives

After completing this tutorial, you will be able to:

* Install `QGIS` on your laptop.

To install `QGIS`, you'll need a laptop with admin privileges to install software.

</div>

## Install QGIS
`QGIS` is a free, open-source **GIS** program. It is the open source
equivalent to ESRI's `ArcGIS`. To install `QGIS`:

Download the `QGIS` installer on the
<a href="http://www.qgis.org/en/site/forusers/download.html" target="_blank">
QGIS download page here</a>. Follow the installation directions below for your
operating system.

### Windows

1. Select the appropriate **QGIS Standalone Installer Version** for your computer.
2. The download will automatically start.
3. Open the `.exe` file and follow prompts to install (installation may take a
while).
4. Open `QGIS` to ensure that it is properly downloaded and installed.

### Mac OS X

1. Select <a href="http://www.kyngchaos.com/software/qgis/" target="_blank">
KyngChaos `QGIS` download page</a>. This will take you to a new page.
2. Select the current version of `QGIS`. The file download (`.dmg` format) should
start automatically.
3. Once downloaded, run the `.dmg` file. When you run the `.dmg`, it will create a
directory of installer packages that you need to run in a particular order.
IMPORTANT: **read the READ ME BEFORE INSTALLING.rtf file**!

Install the packages in the directory in the order indicated.

1. `GDAL Complete.pkg`
2. `NumPy.pkg`
3. `matplotlib.pkg`
4. `QGIS.pkg` - **NOTE: you need to install `GDAL`, `NumPy` and `matplotlib` in order to successfully install `QGIS` on your Mac!**

<i class="fa fa-star"></i> **Data tip:** If your computer doesn't allow you to
open these packages because they are from an unknown developer, right click on
the package and select Open With >Installer (default). You will then be asked
if you want to open the package. Select Open, and the installer will open.
{: .notice--success}

Once all of the packages are installed, open `QGIS` to ensure that it is properly
installed.

### LINUX

1. Select the appropriate download for your computer system.
2. Note: if you have previous versions of `QGIS` installed on your system, you may
run into problems. Check out
<a href="https://www.qgis.org/en/site/forusers/alldownloads.html" target="_blank">
this page from `QGIS` for additional information</a>.
3. Finally, open `QGIS` to ensure that it is properly downloaded and installed.
