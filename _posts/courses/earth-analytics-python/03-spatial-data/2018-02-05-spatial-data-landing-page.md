---
layout: single
category: courses
title: "Introduction to Shapefiles and Vector Data in Open Source Python - Spatial Data"
permalink: /courses/earth-analytics-python/spatial-data-vector-shapefiles/
week-landing: 3
week: 3
modified: 2020-03-27
sidebar:
  nav:
comments: false
author_profile: false
course: "earth-analytics-python"
module-type: 'session'
---
{% include toc title="This Week" icon="file-text" %}





<div class="notice--info" markdown="1">

## <i class="fa fa-ship" aria-hidden="true"></i> Welcome to Week {{ page.week }}!

Welcome to week {{ page.week }} of Earth Analytics! This week, you will dive deeper into working with spatial data in `Python`. You will learn how to handle data in different coordinate reference systems, how to create custom maps and legends and how to extract data from a raster file. You are on your way towards integrating many different
types of data into your analysis which involves knowing how to deal with things
like coordinate reference systems and varying data structures.

## <i class="fa fa-check-square-o fa-2" aria-hidden="true"></i> What You Need

You will need a computer with internet access to complete this lesson and the
`spatial-vector-lidar` data subset created for the course. Note that the data download below is large (172MB)
however it contains data that you will use for the next 2 weeks! 
The best way to get the data is to use earthpy:

`et.data.get_data("spatial-vector-lidar")`

You can also download the data using the link below. 

{% include/data_subsets/course_earth_analytics/_data-spatial-lidar.md %}


</div>


### 1. Complete the Assignment Below

<div class="notice--warning" markdown="1">

## <i class="fa fa-pencil-square-o" aria-hidden="true"></i> Homework 

### The Homework Assignment for This Week Can Be Found on Github 

<a href="https://github.com/earthlab-education/ea-python-2020-03-spatial-vector-template" target="_blank">Click here to view the GitHub Repo with the assignment template. </a>

The lessons for this week have been moved to our <a href="https://www.earthdatascience.org/courses/use-data-open-source-python/">Intermediate Earth Analytics Textbook. </a>

Please read the following chapters to support completing this week's assignment:
* <a href="https://www.earthdatascience.org/courses/use-data-open-source-python/intro-vector-data-python/">Chapters 2-3 - Introduction to vector data- spatial data in open source python </a>

</div>





{:.output}
    Downloading from https://ndownloader.figshare.com/files/12459464
    Extracted output to /root/earth-analytics/data/spatial-vector-lidar/.




## Plot 1 - Roads Map and Legend





{:.output}
    /opt/conda/lib/python3.7/site-packages/geopandas/geoseries.py:358: UserWarning: GeoSeries.notna() previously returned False for both missing (None) and empty geometries. Now, it only returns False for missing values. Since the calling GeoSeries contains empty geometries, the result has changed compared to previous versions of GeoPandas.
    Given a GeoSeries 's', you can use '~s.is_empty & s.notna()' to get back the old behaviour.
    
    To further ignore this warning, you can do: 
    import warnings; warnings.filterwarnings('ignore', 'GeoSeries.notna', UserWarning)
      return self.notna()




{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}/images/courses/earth-analytics-python/03-spatial-data/2018-02-05-spatial-data-landing-page/2018-02-05-spatial-data-landing-page_10_0.png" alt = "Map showing the SJER field site roads and plot locations clipped to the site boundary.">
<figcaption>Map showing the SJER field site roads and plot locations clipped to the site boundary.</figcaption>

</figure>






## Plot 2 - Roads in Del Norte, Modoc & Siskiyou Counties in California



{:.output}
    /opt/conda/lib/python3.7/site-packages/geopandas/geoseries.py:358: UserWarning: GeoSeries.notna() previously returned False for both missing (None) and empty geometries. Now, it only returns False for missing values. Since the calling GeoSeries contains empty geometries, the result has changed compared to previous versions of GeoPandas.
    Given a GeoSeries 's', you can use '~s.is_empty & s.notna()' to get back the old behaviour.
    
    To further ignore this warning, you can do: 
    import warnings; warnings.filterwarnings('ignore', 'GeoSeries.notna', UserWarning)
      return self.notna()





{:.output}
    /opt/conda/lib/python3.7/site-packages/geopandas/geoseries.py:358: UserWarning: GeoSeries.notna() previously returned False for both missing (None) and empty geometries. Now, it only returns False for missing values. Since the calling GeoSeries contains empty geometries, the result has changed compared to previous versions of GeoPandas.
    Given a GeoSeries 's', you can use '~s.is_empty & s.notna()' to get back the old behaviour.
    
    To further ignore this warning, you can do: 
    import warnings; warnings.filterwarnings('ignore', 'GeoSeries.notna', UserWarning)
      return self.notna()






{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}/images/courses/earth-analytics-python/03-spatial-data/2018-02-05-spatial-data-landing-page/2018-02-05-spatial-data-landing-page_17_0.png" alt = "Map showing the roads layer clipped to the three counties and colored according to which county the road is in.">
<figcaption>Map showing the roads layer clipped to the three counties and colored according to which county the road is in.</figcaption>

</figure>
















## Plot 3 - Census Data

You can use the code below to download and unzip the data from the Natural Earth website.
Please note that the download function was written to take

1. a download path - this is the directory where you want to store your data
2. a url - this is the URL where the data are located. The URL below might look odd as it has two "http" strings in it but it is how the url's are organized on natural earth and should work. 

The `download()` function will unzip your data for you and place it in the directory that you specify. 


{:.output}
    Downloading from https://www.naturalearthdata.com/http//www.naturalearthdata.com/download/10m/cultural/ne_10m_admin_0_countries.zip
    Extracted output to /root/earth-analytics/data/earthpy-downloads/ne_10m_admin_0_countries




{:.output}
    /opt/conda/lib/python3.7/site-packages/pandas/core/reshape/merge.py:618: UserWarning: merging between different levels can give an unintended result (1 levels on the left, 2 on the right)
      warnings.warn(msg, UserWarning)




{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}/images/courses/earth-analytics-python/03-spatial-data/2018-02-05-spatial-data-landing-page/2018-02-05-spatial-data-landing-page_30_0.png" alt = "Natural Earth Global Mean population rank and total estimated population">
<figcaption>Natural Earth Global Mean population rank and total estimated population</figcaption>

</figure>



