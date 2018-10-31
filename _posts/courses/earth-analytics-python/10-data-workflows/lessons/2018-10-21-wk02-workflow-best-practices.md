---
layout: single
title: "Data Workflow Best Practices - Things to Consider When Processing Data"
excerpt: "Identifying aspects of a workflow that can be modularized can help you design data workflows. Learn best practices for designing efficient data workflows."
authors: ['Leah Wasser', 'Max Joseph', 'Lauren Herwehe','Jenny Palomino']
modified: 2018-10-31
category: [courses]
class-lesson: ['create-data-workflows']
permalink: /courses/earth-analytics-python/create-efficient-data-workflows/design-efficient-workflows/
nav-title: 'Best Practices'
week: 10
course: "earth-analytics-python"
sidebar:
  nav:
author_profile: false
comments: true
order: 2
topics:
  reproducible-science-and-programming: ['python']
---
{% include toc title="In This Lesson" icon="file-text" %}

<div class='notice--success' markdown="1">

## <i class="fa fa-graduation-cap" aria-hidden="true"></i> Learning Objectives

After completing this tutorial, you will be able to:

* Be able to approach a coding task with a modular, systematic approach. 
* Be able to write pseudo code.
* Be able to identify aspects of a workflow that can be modularized (i.e. ideal for functions).

## <i class="fa fa-check-square-o fa-2" aria-hidden="true"></i> What You Need

You will need a computer with internet access to complete this lesson and the data for week 10 of the course.

{% include/data_subsets/course_earth_analytics/_data-landsat-automation.md %}

</div>

## Design an Efficient Data Workflow

You have now identified your challenge - to plot average NDVI for every landsat scene individually across one year for two study locations:

1. <a href="https://www.neonscience.org/field-sites/field-sites-map/SJER" target="_blank">San Joaquin Experimental Range (SJER) in Southern California, United States</a>
2. <a href="https://www.neonscience.org/field-sites/field-sites-map/HARV" target="_blank">Harvard Forest (HARV) in the Eastern United States</a> 

You have been given Landsat 8 data and a study area boundary for each site. 
Your next step is to write out the steps that you need to follow to get to your end goal plot. 

You know you will need to do the following:
1. Open the data
2. Calculate NDVI
3. Save NDVI values to pandas dataframe with an associated date and the site name for plotting.

Begin your process by pseudo coding out - or writing out steps in plain English - everything that you will need to do in order to get to your end goal. The steps below will walk you through beginning this process of writing pseudocode.

## Write Pseudocode

1. Open up the data and crop it. 
Landsat 8 data is provided as a series of geotiff files - one for each band and one with the quality assurance information (e.g. cloud cover and shadows).

```
# Steps required to process one landsat scene for a site
1. Get a list of files in the directory
2. Subset the list to just the files required to calculate NDVI
3. Open and crop each band
4. Calculate average NDVI for that scene

```

Great! You have now identified the steps required to process a single landsat scene. Those steps now need to be repeated across all of the scenes for each site for a year.

```
# Steps required to process all landsat scenes for a site 
1. Get a list of all directories containing landsat scenes for the site 
2. “Open” each directory and calculate NDVI for the data in that directory (The steps your created above cover this step!)
3. Save NDVI values and date for that directory - which represents a day when landsat was collected (there are some steps here that you need to flesh out as well) to an object that contains average NDVI for each day at this site.

```

OK - now you are ready to put the workflow for a single site together. Of course, remember there are some sub steps that have not been fleshed out just yet but start with the basics and build from there.


```

# Steps required to process all landsat scenes for a site 
1. Get a list of all directories containing landsat scenes for the site. Each directory contains one scene of data collected on a particular date.
2. Use the data in each directory to calculate NDVI and be sure to grab the date associated with the NDVI calculation (The steps your created above cover this step!)
   # Steps required to process one landsat scene
    1. Get a list of files in the directory
    2. Subset the list to just the files required to calculate NDVI
    3. Open and crop each band
    4. Calculate NDVI for that scene
3. Save NDVI values and date for that directory - which represents a day when landsat was collected (there are some steps here that you need to flesh out as well) to an object that contains ndvi for each day at this site.

```

## Add Several Sites Worth of Data to your Workflow

Above you begin to think about the steps associated with creating a workflow for:
1. A single landsat scene where NDVI values 
2. A set of landsat scenes for a particular site

But you want to do this for two or more sites. You are not sure if you will have more than two sites but in this case you want to design a workflow that allows for two or more sites. Add an additional layer to your pseudo code. 

```
# Modular workflow for many sites
1. Get list of all directories and associated site names
2. Open each site directory, get landsat scenes and calculate mean NDVI for each scene for that site
3. Create summary NDVI by site by date data frame for all sites
4. Export NDVI values to csv. (optional “data product” output)

# Produce your plot!
```

In this example, an assumption is made that your data are nicely organized into a single directory for each site. Like this: 


{:.output}
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



You’ve now designed a workflow to process several sites worth of landsat data. But of course the work is just beginning. For each of the steps above you need to flesh out how you can accomplish each task. Before you design your workflow in more detail, consider the data workflow best practices discussed below. 


## Data Workflow Best Practices 
 
There are many things to keep in mind when creating a workflow. A few include:

### 1. Do not modify the raw data

Typically you do not want to modify the raw data, so that you can always reproduce your output from the same inputs. In some cases, this is less important, e.g., when you are not tasked with curating the raw data. For example you *could*  redownload the landsat data provided in this class. 

In other cases, this is extremely important - you wouldn’t want to recollect a summers worth of field collected data because you accidentally modified the original spreadsheet. 

A good rule of thumb is to create an “outputs” directory where you store outputs. An outputs directory is helpful because:
1. You can always delete and recreate the outputs without worrying about deleting your original data.
2. An outputs directory is expressive and reminds anyone looking at your project (including you in the future - i.e. your future self!) where the output products are - they don’t have to dig for the data. 

### 2. Create Expressive Intermediate File Names and Outputs

You want to carefully consider how you name your intermediate and end product outputs so that the names reflect your intention and the content. For instance - in this case you are creating an NDVI dataframe which would be exported to a csv.

Here are some naming options:
```
# Less than ideal name
data.csv
# OK Name
ndvi.csv`
# Expressive name
all-sites-ndvi.csv
```

### 3. Whenever Possible Create Modular Code 

As you are working on your pseudo code, consider the parts of your analysis that are well suited for functions. Ideally a Python function will have 1-3 inputs and will produce 1-2 outputs. 

Keep functions small and focused. A function should do one thing well. You can then combine many functions into a wrapper function to automate and make for a nicely crafted program.
