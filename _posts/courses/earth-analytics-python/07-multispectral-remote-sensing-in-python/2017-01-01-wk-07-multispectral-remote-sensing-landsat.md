---
layout: single
category: courses
title: "Multispectral Imagery Python - NAIP, Landsat, Fire & Remote Sensing"
permalink: /courses/earth-analytics-python/multispectral-remote-sensing-in-python/
modified: 2018-10-16
week-landing: 7
week: 7
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

Welcome to week {{ page.week }} of Earth Analytics!

At the end of this week you will be able to:

* Describe what a spectral band is in remote sensing data.
* Create maps of spectral remote sensing data using different band combinations including CIR and RGB.
* Calculate NDVI in `Python` using.
* Get NAIP remote sensing data from Earth Explorer.
* Use the Landsat file naming convention to determine correct band combinations for plotting and calculating NDVI.
* Define additive color model.

{% include /data_subsets/course_earth_analytics/_data-cold-springs-fire.md %}


</div>


|  Time | Topic   | Speaker   |
|---|---|---|---|---|
| 20 minutes | Review / questions |   |
| 20-30 minutes  | Introduction to multispectral remote sensing  |  |
| Coding part I  | Coding Session: Multispectral data in Python using Rasterio |    |
|===
| Coding part II   | Vegetation indices and NDVI in Python |    |

### 1a. Remote Sensing Readings

* <a href="https://landsat.gsfc.nasa.gov/landsat-data-continuity-mission/" target="_blank">NASA Overview of Landsat 8</a>
* <a href="https://www.e-education.psu.edu/natureofgeoinfo/c8_p12.html" target="_blank">Penn State e-Education post on multi-spectral data. Note they discuss AVHRR at the top which you won't use in this lesson but be sure to read about Landsat.</a>




{:.output}
    /Users/lewa8222/anaconda3/envs/earth-analytics-python/lib/python3.6/site-packages/earthpy/spatial.py:372: FutureWarning: Using a non-tuple sequence for multidimensional indexing is deprecated; use `arr[tuple(seq)]` instead of `arr[seq]`. In the future this will be interpreted as an array index, `arr[np.array(seq)]`, which will result either in an error or a different result.
      rgb_bands = arr[[rgb]]



{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}//images/courses/earth-analytics-python/07-multispectral-remote-sensing-in-python/2017-01-01-wk-07-multispectral-remote-sensing-landsat_2_1.png" alt = "Homework plots 1 & 2 RGB and CIR images using NAIP data from 2017.">
<figcaption>Homework plots 1 & 2 RGB and CIR images using NAIP data from 2017.</figcaption>

</figure>




The intermediate NDVI plots below are not required for your homework. They are here so you can compare intermediate outputs if you want to! You will need to create these datasets to process the final NDVI difference plot that is a homework item!


{:.output}
    /Users/leah-su/anaconda3/envs/earth-analytics-python/lib/python3.6/site-packages/matplotlib/tight_layout.py:177: UserWarning: The left and right margins cannot be made large enough to accommodate all axes decorations. 
      warnings.warn('The left and right margins cannot be made large '
    /Users/leah-su/anaconda3/envs/earth-analytics-python/lib/python3.6/site-packages/matplotlib/tight_layout.py:182: UserWarning: The bottom and top margins cannot be made large enough to accommodate all axes decorations. 
      warnings.warn('The bottom and top margins cannot be made large '
    /Users/leah-su/anaconda3/envs/earth-analytics-python/lib/python3.6/site-packages/matplotlib/tight_layout.py:209: UserWarning: tight_layout cannot make axes height small enough to accommodate all axes decorations
      warnings.warn('tight_layout cannot make axes height small enough '



{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}//images/courses/earth-analytics-python/07-multispectral-remote-sensing-in-python/2017-01-01-wk-07-multispectral-remote-sensing-landsat_4_1.png" alt = "COMPARISON plots - intermediate NDVI NAIP outputs. These plots are just here if you want to compare your intermediate outputs with the instructors.">
<figcaption>COMPARISON plots - intermediate NDVI NAIP outputs. These plots are just here if you want to compare your intermediate outputs with the instructors.</figcaption>

</figure>





{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}//images/courses/earth-analytics-python/07-multispectral-remote-sensing-in-python/2017-01-01-wk-07-multispectral-remote-sensing-landsat_5_0.png" alt = "Homework plot 3 NDVI difference using NAIP 2017 - NAIP 2015.">
<figcaption>Homework plot 3 NDVI difference using NAIP 2017 - NAIP 2015.</figcaption>

</figure>





{:.output}

    ---------------------------------------------------------------------------

    AttributeError                            Traceback (most recent call last)

    <ipython-input-33-e68fbe548849> in <module>()
          6 # Stack landsat tif files using es.stack_raster_tifs - earthpy
          7 
    ----> 8 landsat_pre, landsat_pre_meta = es.stack_raster_tifs(all_landsat_band_paths, landsat_pre_out)
          9 extent_landsat = plotting_extent(landsat_pre[0], landsat_pre_meta["transform"])


    ~/anaconda3/envs/earth-analytics-python/lib/python3.6/site-packages/earthpy/spatial.py in stack_raster_tifs(band_paths, out_path)
         80         # save out a stacked gtif file
         81         with rio.open(out_path, 'w', **dest_kwargs) as dest:
    ---> 82             return stack(sources, dest)
         83 
         84 


    ~/anaconda3/envs/earth-analytics-python/lib/python3.6/site-packages/earthpy/spatial.py in stack(sources, dest)
        100     #    raise ValueError("The output directory path that you provided does not exist")
        101 
    --> 102     if not type(sources[0]) == rio._io.RasterReader:
        103         raise ValueError("The sources object should be of type: rasterio.RasterReader")
        104 


    AttributeError: module 'rasterio._io' has no attribute 'RasterReader'


