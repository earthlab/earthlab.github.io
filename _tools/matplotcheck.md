---
layout: single
title: "matplotcheck"
excerpt: "Matplotcheck is a Python package that makes it easier to test plots. It can be used to support autograding Python homework assignments."
splash_header: "MatPlotCheck: Test and validate matplotlib plots in Python"
header:
  overlay_color: "#000080"
  teaser: matplotcheck.png
  image_alt: Matplotcheck Badge
published: true
---

[![DOI](https://zenodo.org/badge/138660604.svg)](https://zenodo.org/badge/latestdoi/138660604)

# MatPlotCheck
![PyPI](https://img.shields.io/pypi/v/matplotcheck.svg?color=purple&style=plastic)
![PyPI - Downloads](https://img.shields.io/pypi/dm/matplotcheck.svg?color=purple&label=pypi%20downloads&style=plastic)
![Conda](https://img.shields.io/conda/v/conda-forge/matplotcheck.svg?color=purple&style=plastic)
![Conda](https://img.shields.io/conda/dn/conda-forge/matplotcheck.svg?color=purple&label=conda-forge%20downloads&style=plastic)
[![Documentation Status](https://readthedocs.org/projects/matplotcheck/badge/?version=latest)](https://matplotcheck.readthedocs.io/en/latest/?badge=latest)

A package for testing different types of matplotlib plots including:

* basic matplotlib plots
* geopandas spatial vector plots
* raster plots
* time series plots
* folium plots

and more!

## Why MatPlotCheck?
There is often a need to test plots particularly when teaching data science
courses. The Matplotlib API can be complex to navigate when trying to write
tests. MatPlotCheck was developed to make it easier to test data, titles, axes
and other elements of Matplotlib plots in support of both autograding and other
testing needs.

MatPlotCheck was inspired by [plotChecker][cdeac58a] developed by Jess Hamrick.

  [cdeac58a]: https://github.com/jhamrick/plotchecker "Plot Checker"

We spoke with her about our development and decided to extend plotChecker to suite some of the grading needs in our classes which include plots with spatial data using numpy for images and geopandas for vector data.

[Find MatPlotCheck on GitHub.](https://github.com/earthlab/matplotcheck)
