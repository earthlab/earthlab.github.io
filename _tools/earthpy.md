---
layout: single
title: "EarthPy"
excerpt: "EarthPy makes it easier to plot and manipulate spatial data in Python."
splash_header: "EarthPy: A Python package for spatial data."
tool_page_title: "EarthPy for Open Source GIS in Python"
authors: ["Leah Wasser", "Max Joseph", "Joe McGlinchy"]
header:
  overlay_color: "#000080"
  overlay_filter: rgba(0, 0, 0, 0.3)
  cta_label: "EarthPy"
  teaser: earthpy.png
  image_alt: Earthpy Badge
published: true
---

EarthPy makes it easier to plot and manipulate spatial data in Python.

[![DOI](https://joss.theoj.org/papers/10.21105/joss.01886/status.svg)](https://doi.org/10.21105/joss.01886)
[![pyOpenSci](https://tinyurl.com/y22nb8up)](https://github.com/pyOpenSci/software-review/issues/12)
![PyPI](https://img.shields.io/pypi/v/earthpy.svg?color=purple&style=plastic)
![PyPI - Downloads](https://img.shields.io/pypi/dm/earthpy.svg?color=purple&label=pypi%20downloads&style=plastic)
![Conda](https://img.shields.io/conda/v/conda-forge/earthpy.svg?color=purple&style=plastic)
![Conda](https://img.shields.io/conda/dn/conda-forge/earthpy.svg?color=purple&label=conda-forge%20downloads&style=plastic)

## Why EarthPy?

Python is a generic programming language designed to support many different applications. Because of this, many commonly
performed spatial tasks for science including plotting and working with spatial data take many steps of code. EarthPy
builds upon the functionality developed for raster data (rasterio) and vector data (geopandas) in Python and simplifies the
code needed to:

* [Stack and crop raster bands from data such as Landsat into an easy to use numpy array](https://earthpy.readthedocs.io/en/latest/gallery_vignettes/plot_raster_stack_crop.html)
* [Work with masks to set bad pixels such a those covered by clouds and cloud-shadows to NA (`mask_pixels()`)](https://earthpy.readthedocs.io/en/latest/gallery_vignettes/plot_stack_masks.html#sphx-glr-gallery-vignettes-plot-stack-masks-py)
* [Plot rgb (color), color infrared and other 3 band combination images (`plot_rgb()`)](https://earthpy.readthedocs.io/en/latest/gallery_vignettes/plot_rgb.html)
* [Plot bands of a raster quickly using `plot_bands()`](https://earthpy.readthedocs.io/en/latest/gallery_vignettes/plot_bands_functionality.html)
* [Plot histograms for a set of raster files.](https://earthpy.readthedocs.io/en/latest/gallery_vignettes/plot_hist_functionality.html)
* [Create discrete (categorical) legends](https://earthpy.readthedocs.io/en/latest/gallery_vignettes/plot_draw_legend_docs.html)
* [Calculate vegetation indices such as Normalized Difference Vegetation Index (`normalized_diff()`)](https://earthpy.readthedocs.io/en/latest/gallery_vignettes/plot_calculate_classify_ndvi.html)
* [Create hillshade from a DEM](https://earthpy.readthedocs.io/en/latest/gallery_vignettes/plot_dem_hillshade.html)
* [Clip point, line, and polygon geometries](https://earthpy.readthedocs.io/en/latest/gallery_vignettes/plot_clip.html)

EarthPy also has an `io` module that allows users to

1. Quickly access pre-created data subsets used in the earth-analytics courses hosted
on [www.earthdatascience.org](https://www.earthdatascience.org)
2. Download other datasets that they may want to use in their workflows.

EarthPy's design was inspired by the `raster` and `sp` package functionality available to `R` users.

## View Example EarthPy Applications in Our Documentation Gallery  

Check out our [vignette gallery](https://earthpy.readthedocs.io/en/latest/gallery_vignettes/index.html) for
applied examples of using EarthPy in common spatial workflows.

[Find EarthPy on GitHub.](https://github.com/earthlab/earthpy)
