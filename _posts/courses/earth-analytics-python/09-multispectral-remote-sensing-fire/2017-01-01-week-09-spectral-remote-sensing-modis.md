---
layout: single
category: courses
title: "Quantify the Impacts of a Fire Using MODIS and Landsat Remote Sensing Data in Python"
permalink: /courses/earth-analytics-python/multispectral-remote-sensing-modis/
modified: 2020-03-10
week-landing: 9
week: 9
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

Welcome to week {{ page.week }} of Earth Analytics! This week you will work with MODIS and 
Landsat data to calculate burn indices.  

{% include/data_subsets/course_earth_analytics/_data-cold-springs-fire.md %}

</div>

### 2. Complete the Assignment Using the Template for this week. 
(10 points)
Please note that like the flood report, this assignment is worth more points than
a usual weekly assignment. 








{:.output}
    Downloading from https://ndownloader.figshare.com/files/10960211?private_link=18f892d9f3645344b2fe
    Extracted output to /root/earth-analytics/data/cs-test-naip/.
    Downloading from https://ndownloader.figshare.com/files/10960109
    Extracted output to /root/earth-analytics/data/cold-springs-fire/.
    Downloading from https://ndownloader.figshare.com/files/10960112
    Extracted output to /root/earth-analytics/data/cold-springs-modis-h5/.
    Downloading from https://ndownloader.figshare.com/files/21941085
    Extracted output to /root/earth-analytics/data/earthpy-downloads/landsat-coldsprings-hw









{:.input}
```python
def stack_modis_bands(h4_path, crop_bound):

    # BEGIN SOLUTION
    """A function that returns a stacked numpy array of bands and a 
    plotting extent

    Parameters:

    h4_path: string
        Path to the MODIS H4 data of interest

    Returns:
        numpy array, plotting extent, metadata

    """

    # Open & stack the prefire data
    all_bands = []
    # Just get the reflectance data - the bands
    with rio.open(h4_path) as dataset:
        for name in dataset.subdatasets:
            # Build out content on regex
            if re.search("b0.\_1$", name):
                with rio.open(name) as subdataset:
                    # print(name)
                    modis_meta = subdataset.profile

                    # Check CRS and reproject if need be
                    if subdataset.crs != crop_bound.crs:
                        crop_bound = crop_bound.to_crs(subdataset.crs)
                    # Crop data
                    crop_band, crop_meta = es.crop_image(
                        subdataset, crop_bound)
                    all_bands.append(np.squeeze(crop_band))

            # If you wanted to you could run a count and update the metadata here
    stacked_arr = np.stack(all_bands)

    return (stacked_arr, crop_meta)
```

{:.input}
```python
modis_path_dirs = glob(os.path.join("cold-springs-modis-h5") + "/*/")

modis_cleaned_data = {}
modis_veg_index = {}

for adir in modis_path_dirs:

    # Get date for data
    modis_date = os.path.basename(os.path.normpath(adir))
    modis_h4_path = glob(os.path.join(adir, "*.hdf"))[0]

    modis_arr, modis_meta = stack_modis_bands(modis_h4_path,
                                              fire_boundary)
    # Clean data
    modis_arr = ma.masked_where(modis_arr < 0, modis_arr)

    modis_cleaned_data[modis_date] = [modis_arr, modis_meta]

    # Calculate Veg Indices
    modis_veg_index[modis_date] = {"ndvi": es.normalized_diff(modis_arr[1], modis_arr[0]),
                                   "nbr": es.normalized_diff(modis_arr[1], modis_arr[6])}

# Calculate veg indices
modis_ndvi_diff = modis_veg_index["17_july_2016"]['ndvi'] - \
    modis_veg_index["07_july_2016"]['ndvi']
modis_dnbr = modis_veg_index["07_july_2016"]['nbr'] - \
    modis_veg_index["17_july_2016"]['nbr']
modis_dnbr_class = classify_dnbr(modis_dnbr)

# Create plotting extent for final plots & fire bound
# not there is a better way to do this but for now this works
extent_modis_pre = plotting_extent(modis_arr[0], modis_meta["transform"])

# Reproject fire boundary
fire_bound_sin = fire_boundary.to_crs(modis_meta["crs"])
extent_modis_post = plotting_extent(modis_arr[0],
                                    modis_meta["transform"])
```





## Homework Plot 1 - Grid of 3 - 3 band CIR plots post fire

{:.input}
```python
# Plot NAIP, Landsat & MODIS together

fig, (ax1, ax2, ax3) = plt.subplots(3, 1, figsize=(12, 15))
ep.plot_rgb(naip_data, ax=ax1,
            rgb=[3, 2, 1], extent=extent_naip,
            title="Naip CIR Composite Image | 1 meter \n Post Fire")
fire_bound_utmz13.plot(ax=ax1, color='None',
                       edgecolor='white', linewidth=2)

ep.plot_rgb(landsat_cleaned_data["20160723"], ax=ax2, rgb=[4, 3, 2],
            title="Landsat CIR Composite Image | 30 meters \n Post Cold Springs Fire \n July 23, 2016",
            extent=extent_landsat)
fire_bound_utmz13.plot(ax=ax2, color='None',
                       edgecolor='white', linewidth=2)

ep.plot_rgb(modis_cleaned_data["17_july_2016"][0],
            ax=ax3,
            rgb=[1, 0, 3],
            title="Modis CIR Composite Image | 500 meters \n Post Cold Springs Fire \n July 17, 2016",
            extent=extent_modis_post)

fire_bound_sin.plot(ax=ax3, color='None',
                    edgecolor='white', linewidth=2)

plt.tight_layout()
```

{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}/images/courses/earth-analytics-python/09-multispectral-remote-sensing-fire/2017-01-01-week-09-spectral-remote-sensing-modis/2017-01-01-week-09-spectral-remote-sensing-modis_19_0.png">

</figure>










{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}/images/courses/earth-analytics-python/09-multispectral-remote-sensing-fire/2017-01-01-week-09-spectral-remote-sensing-modis/2017-01-01-week-09-spectral-remote-sensing-modis_24_0.png">

</figure>










{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}/images/courses/earth-analytics-python/09-multispectral-remote-sensing-fire/2017-01-01-week-09-spectral-remote-sensing-modis/2017-01-01-week-09-spectral-remote-sensing-modis_30_0.png">

</figure>







## Homework Plot 2 & 3 : Landsat & MODIS Difference Normalized Burn Ration  dNBR



{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}/images/courses/earth-analytics-python/09-multispectral-remote-sensing-fire/2017-01-01-week-09-spectral-remote-sensing-modis/2017-01-01-week-09-spectral-remote-sensing-modis_35_0.png">

</figure>









{:.output}
    Burned Landsat class 1:
    Burned Landsat class 2:
    Burned MODIS class 1:
    Burned MODIS class 2:
    Burned Landsat class 4:
    Burned Landsat class 5:
    Burned MODIS class 4:
    Burned MODIS class 5:









{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}/images/courses/earth-analytics-python/09-multispectral-remote-sensing-fire/2017-01-01-week-09-spectral-remote-sensing-modis/2017-01-01-week-09-spectral-remote-sensing-modis_44_0.png">

</figure>








{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}/images/courses/earth-analytics-python/09-multispectral-remote-sensing-fire/2017-01-01-week-09-spectral-remote-sensing-modis/2017-01-01-week-09-spectral-remote-sensing-modis_47_0.png">

</figure>



