---
layout: single
title: "How to Write Pseudocode"
excerpt: "Pseudcode can help you design data workflows through listing out the individual steps of workflow in plain language, so the focus is on the overall data process, rather than on the specific code needed. Learn best practices for writing pseudocode for data workflows."
authors: ['Leah Wasser', 'Jenny Palomino', 'Max Joseph', 'Lauren Herwehe']
modified: 2020-03-18
category: [courses]
class-lesson: ['create-data-workflows-tb']
permalink: /courses/use-data-open-source-python/earth-data-science-workflows/design-efficient-automated-data-workflows/pseudocode-data-workflows/
nav-title: 'Write Pseudocode'
week: 8
course: "intermediate-earth-data-science-textbook"
sidebar:
  nav:
author_profile: false
comments: true
order: 2
topics:
  reproducible-science-and-programming: ['python']
---

{% include toc title="On This Page" icon="file-text" %}

<div class='notice--success' markdown="1">

## <i class="fa fa-graduation-cap" aria-hidden="true"></i> Learning Objectives

* Be able to approach a coding task with a modular, systematic approach. 
* Be able to write pseudocode.

</div>

## Design an Efficient Data Workflow Using Pseudocode

You have now identified your challenge - to calculate and plot average normalized difference vegetation index (NDVI) for every Landsat scene (individually) across one year for two study locations:

1. <a href="https://www.neonscience.org/field-sites/field-sites-map/SJER" target="_blank">San Joaquin Experimental Range (SJER) in Southern California, United States</a>
2. <a href="https://www.neonscience.org/field-sites/field-sites-map/HARV" target="_blank">Harvard Forest (HARV) in the Eastern United States</a> 

You have been given Landsat 8 data and a study area boundary for each site. Your next step is to write out the steps that you need to follow to get to your end goal plot. 

You know you will need to do the following:
1. Open the data.
2. Calculate NDVI.
3. Save NDVI values to pandas dataframe with the associated date and site name for plotting.

Begin your process by pseudocoding - or writing out steps in plain English - everything that you will need to do in order to get to your end goal. The steps below will walk you through beginning this process of writing pseudocode.


## Begin With the Workflow for One Landsat Scene

1. Get a list of the data files for one Landsat scene.

Recall that Landsat 8 data is provided as a series of GeoTIFF files - one for each band (e.g. red, near-infrared) and one with the quality assurance information (e.g. cloud cover and shadows). 

Each Landsat scene (i.e. set of bands for a specific location) is organized into its own directory (e.g. `LC080130302017011201T1-SC20181023151858`) that contains all of the bands for that scene that were taken on a specific date. 


```
# Steps required to get data for one Landsat scene for a site
1. Get a list of GeoTIFF files in the directory for that scene.
2. Subset the list to just the files required to calculate NDVI.
3. Sort the list(!) so that the bands are in the right order.
```

2. Open and crop the data for one Landsat scene. 

Now that you have the steps to get the data for one Landsat scene, you can expand your pseudocode steps to include opening and cropping the data to the site boundary. 

```
# Steps required to process one Landsat scene for a site
1. Get a list of GeoTIFF files in the directory for that scene.
2. Subset the list to just the files required to calculate NDVI.
3. Sort the list(!) so that the bands are in the right order.
4. Open and crop the bands needed to calculate NDVI.
```

3. Calculate NDVI for one Landsat scene. 

Last, you can expand your pseudocode to include using the bands that you opened and cropped to calculate NDVI. 

```
# Steps required to process one Landsat scene for a site
1. Get a list of GeoTIFF files in the directory for that scene.
2. Subset the list to just the files required to calculate NDVI.
3. Sort the list(!) so that the bands are in the right order.
4. Open and crop the bands needed to calculate NDVI.
5. Calculate average NDVI for that scene.
```

## Expand Workflow to Include All Landsat Scenes for a Site

You have now identified the steps required to process a single Landsat scene (band). Those steps now need to be repeated across all of the scenes for each site for a year. 


```
# Steps required to process all Landsat scenes for a site 
1. Get a list of all directories for the Landsat scenes for the site. 
2. For each directory, use the steps outlined previously for one site to calculate NDVI for the data in that directory. (Grab the date associated with the NDVI calculation.)
3. Save NDVI values and the date for that directory - which represents the day that Landsat scene was collected (there are some steps here that you need to flesh out as well) - to a list or dataframe that contains average NDVI for each scene at this site.

```

OK - now you are ready to put the workflow for a single site together. Of course, remember there are some sub steps that have not been fleshed out just yet, but start with the basics and build from there.


```
# Steps required to process all Landsat scenes for a site 
1. Get a list of all directories for the Landsat scenes for the site. 
2. For each directory, use the steps outlined previously for one site to calculate NDVI for the data in that directory. (Grab the date associated with the NDVI calculation.)
    # Steps required to process one Landsat scene for a site
    1. Get a list of GeoTIFF files in the directory for that scene.
    2. Subset the list to just the files required to calculate NDVI.
    3. Sort the list(!) so that the bands are in the right order.
    4. Open and crop the bands needed to calculate NDVI.
    5. Calculate average NDVI for that scene.
3. Save NDVI values and the date for that directory - which represents the day that Landsat scene was collected (there are some steps here that you need to flesh out as well) - to a list or dataframe that contains average NDVI for each scene at this site.

```

## Add Multiple Sites Worth of Data to Your Workflow

Above you begin to think about the steps associated with creating a workflow for:
1. A single Landsat scene. 
2. A set of Landsat scenes for a particular site.

But you want to do this for two or more sites. You are not sure if you will have more than two sites but in this case you want to design a workflow that allows for two or more sites. Add an additional layer to your pseudo code. 

```
# Modular workflow for many sites
1. Get list of all directories and associated site names.
2. Open each site directory, get Landsat scenes, and calculate mean NDVI for each scene for that site.
3. Capture results (including mean NDVI, date, and site name) to a list or dataframe.
4. Export dataframe with mean NDVI values to csv. (i.e. a “data product” output that you can share with others)

# Create your plot!
```

In this example, an assumption is made that your data are nicely organized into a single directory for each site. Like this: 


{:.output}
    Downloading from https://ndownloader.figshare.com/files/13431344
    Extracted output to /root/earth-analytics/data/ndvi-automation/.
    data/ndvi-automation/sites/HARV/landsat-crop/LC080130302017011201T1-SC20181023151858
    data/ndvi-automation/sites/HARV/landsat-crop/LC080130302017012801T1-SC20181023151918
    data/ndvi-automation/sites/HARV/landsat-crop/LC080130302017021301T1-SC20181023152047
    data/ndvi-automation/sites/HARV/landsat-crop/LC080130302017030101T2-SC20181023151931
    data/ndvi-automation/sites/HARV/landsat-crop/LC080130302017031701T1-SC20181023151837
    data/ndvi-automation/sites/HARV/landsat-crop/LC080130302017040201T1-SC20181023152038
    data/ndvi-automation/sites/HARV/landsat-crop/LC080130302017041801T1-SC20181023152618
    data/ndvi-automation/sites/HARV/landsat-crop/LC080130302017050401T1-SC20181023152417
    data/ndvi-automation/sites/HARV/landsat-crop/LC080130302017052001T1-SC20181023151947
    data/ndvi-automation/sites/HARV/landsat-crop/LC080130302017060501T2-SC20181023151903
    data/ndvi-automation/sites/HARV/landsat-crop/LC080130302017062101T1-SC20181023151938
    data/ndvi-automation/sites/HARV/landsat-crop/LC080130302017070701T1-SC20181023152155
    data/ndvi-automation/sites/HARV/landsat-crop/LC080130302017072301T1-SC20181023152048
    data/ndvi-automation/sites/HARV/landsat-crop/LC080130302017080801T1-SC20181023151955
    data/ndvi-automation/sites/HARV/landsat-crop/LC080130302017082401T1-SC20181023152023
    data/ndvi-automation/sites/HARV/landsat-crop/LC080130302017090901T1-SC20181023151921
    data/ndvi-automation/sites/HARV/landsat-crop/LC080130302017092501T1-SC20181023152702
    data/ndvi-automation/sites/HARV/landsat-crop/LC080130302017101101T1-SC20181023151948
    data/ndvi-automation/sites/HARV/landsat-crop/LC080130302017102701T1-SC20181023151948
    data/ndvi-automation/sites/HARV/landsat-crop/LC080130302017111201T1-SC20181023151927
    data/ndvi-automation/sites/HARV/landsat-crop/LC080130302017112801T1-SC20181023151921
    data/ndvi-automation/sites/HARV/landsat-crop/LC080130302017121401T1-SC20181023152050
    data/ndvi-automation/sites/HARV/landsat-crop/LC080130302017123001T1-SC20181023151857
    data/ndvi-automation/sites/SJER/landsat-crop/LC080420342017010701T2-SC20181023153321
    data/ndvi-automation/sites/SJER/landsat-crop/LC080420342017012301T1-SC20181023170015
    data/ndvi-automation/sites/SJER/landsat-crop/LC080420342017020801T1-SC20181023162521
    data/ndvi-automation/sites/SJER/landsat-crop/LC080420342017022401T1-SC20181023152103
    data/ndvi-automation/sites/SJER/landsat-crop/LC080420342017031201T1-SC20181023152108
    data/ndvi-automation/sites/SJER/landsat-crop/LC080420342017032801T1-SC20181023162825
    data/ndvi-automation/sites/SJER/landsat-crop/LC080420342017041301T1-SC20181023170020
    data/ndvi-automation/sites/SJER/landsat-crop/LC080420342017042901T1-SC20181023153144
    data/ndvi-automation/sites/SJER/landsat-crop/LC080420342017051501T1-SC20181023151959
    data/ndvi-automation/sites/SJER/landsat-crop/LC080420342017053101T1-SC20181023151941
    data/ndvi-automation/sites/SJER/landsat-crop/LC080420342017061601T1-SC20181023152417
    data/ndvi-automation/sites/SJER/landsat-crop/LC080420342017070201T1-SC20181023153031
    data/ndvi-automation/sites/SJER/landsat-crop/LC080420342017071801T1-SC20181023153104
    data/ndvi-automation/sites/SJER/landsat-crop/LC080420342017080301T1-SC20181023185645
    data/ndvi-automation/sites/SJER/landsat-crop/LC080420342017081901T1-SC20181023153141
    data/ndvi-automation/sites/SJER/landsat-crop/LC080420342017090401T1-SC20181023162756
    data/ndvi-automation/sites/SJER/landsat-crop/LC080420342017092001T1-SC20181023170143
    data/ndvi-automation/sites/SJER/landsat-crop/LC080420342017100601T1-SC20181023152121
    data/ndvi-automation/sites/SJER/landsat-crop/LC080420342017102201T1-SC20181023153638
    data/ndvi-automation/sites/SJER/landsat-crop/LC080420342017110701T1-SC20181023170129
    data/ndvi-automation/sites/SJER/landsat-crop/LC080420342017112301T1-SC20181023170128
    data/ndvi-automation/sites/SJER/landsat-crop/LC080420342017120901T1-SC20181023152438
    data/ndvi-automation/sites/SJER/landsat-crop/LC080420342017122501T1-SC20181023152106



You have now designed a workflow using pseudocode to process several sites worth of landsat data. 

Of course, the pseudocode above is just beginning. For each of the steps above, you need to flesh out how you can accomplish each task. 

The next lesson in this chapter focuses on data workflow best practices that can help you implement your workflow efficiently and effectively. 
