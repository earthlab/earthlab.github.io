---
layout: single
title: "matplotcheck"
excerpt: "A package for testing different types of matplotlib plots."
header:
  image: matplotcheck.png
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

[![Build Status](https://travis-ci.com/earthlab/matplotcheck.svg?branch=master)](https://travis-ci.com/earthlab/matplotcheck)
[![Build status](https://ci.appveyor.com/api/projects/status/xgf5g4ms8qhgtp21?svg=true)](https://ci.appveyor.com/project/earthlab/matplotcheck)
[![codecov](https://codecov.io/gh/earthlab/matPlotCheck/branch/master/graph/badge.svg)](https://codecov.io/gh/earthlab/matPlotCheck)
[![Documentation Status](https://readthedocs.org/projects/matplotcheck/badge/?version=latest)](https://matplotcheck.readthedocs.io/en/latest/?badge=latest)
[![Code style: black](https://img.shields.io/badge/code%20style-black-000000.svg)](https://img.shields.io/badge/code%20style-black-000000.svg)

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

[Find it on GitHub.](https://github.com/earthlab/matplotcheck)