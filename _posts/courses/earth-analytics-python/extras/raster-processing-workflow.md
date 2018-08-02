---
layout: single
title: "Customize your maps in python: GIS in Python"
excerpt: "In this lesson we review how to customize matplotlib maps created using vector data in Python. We will review how to add legends, titles and how to customize map colors."
authors: ['Chris Holdgraf', 'Leah Wasser']
modified: 2018-08-01
category: [courses]
class-lesson: ['hw-custom-maps-python']
permalink: /courses/earth-analytics-python/week-4/python-customize-map-legends-geopandas/
nav-title: 'Customize python maps'
module-title: 'Custom plots in Python'
module-description: 'This tutorial covers the basics of creating custom plot legends
in R'
module-nav-title: 'Spatial Data: Custom plots in Python'
module-type: 'homework'
course: 'earth-analytics-python'
week: 4
sidebar:
  nav:
author_profile: false
comments: true
order: 1
---

{:.input}
```python
from scipy.misc import bytescale
import numpy.ma as ma 
import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
from matplotlib import patches as mpatches
from matplotlib.colors import ListedColormap
import matplotlib as mpl
import seaborn as sns

import rasterio as rio
import rasterio.mask
import geopandas as gpd
from rasterio.plot import show
from rasterio.mask import mask
from shapely.geometry import mapping

from glob import glob
import os
import earthpy as et

plt.ion()
sns.set_style('white')

mpl.rcParams['figure.figsize'] = (10.0, 6.0);
mpl.rcParams['axes.titlesize'] = 20
os.chdir(os.path.join(et.io.HOME, 'earth-analytics'))
```

{:.input}
```python
foo(a=5, b=6, c=7)
foo
```

{:.input}
```python


foo(**kwds):
    print(kwds)
    

```

{:.input}
```python
# Get List of All Modis bands
modis_bands_pre = glob("data/week_07/modis/reflectance/07_july_2016/crop/MOD09GA.A2016189.h09v05.006.2016191073856_sur_refl_*b*")
modis_bands_post = glob("data/week_07/modis/reflectance/17_july_2016/crop/MOD09GA.A2016199.h09v05.006.2016201065406_sur_refl_*b*")
modis_bands_post
```

You can set no datavals when you import 
https://github.com/mapbox/rasterio/issues/299

{:.input}
```python
for path in band_paths:
    print(path)
```

{:.input}
```python
band_paths = modis_bands_post
out_path = "data/week_07/outputs/modis_post_stacked.tif"

import contextlib
# removeing **kwds 
with contextlib.ExitStack() as stack:
    sources = [stack.enter_context(rio.open(path)) for path in band_paths]

    dest_kwargs = sources[0].meta
    dest_count = sum(src.count for src in sources)
    dest_kwargs['count'] = dest_count

    with rasterio.open(out_path, 'w', **dest_kwargs) as dest:
        stack(sources, dest) 
```

{:.input}
```python
sources
dest
?stack()
```

{:.input}
```python
import contextlib
sources
```

{:.input}
```python
def stack(band_paths, out_path, return_raster=True):
    """Stack a set of bands into a single file.

    Parameters
    ----------
    bands : list of file paths
        A list with paths to the bands you wish to stack. Bands
        will be stacked in the order given in this list.
    out_path : string
        A path for the output file.
    return_raster : bool
        Whether to return a refernce to the opened output
        raster file.
    """
    # Read in metadata
    first_band = rio.open(band_paths[0], 'r')
    meta = first_band.meta.copy()

    # Replace metadata with new count
    counts = 0
    for ifile in band_paths:
        with rio.open(ifile, 'r') as ff:
            counts += ff.meta['count']
    meta.update(count=counts)

    # create a new file
    with rio.open(out_path, 'w', **meta) as ff:
        for ii, ifile in tqdm(enumerate(band_paths)):
            bands = rio.open(ifile, 'r').read()
            if bands.ndim != 3:
                bands = bands[np.newaxis, ...]
            for band in bands:
                ff.write(band, ii+1)

    if return_raster is True:
        return rio.open(out_path)
```

{:.input}
```python
ifile
modis_bands_pre = glob("data/week_07/modis/reflectance/07_july_2016/crop/MOD09GA.A2016189.h09v05.006.2016191073856_sur_refl_*b*")
modis_bands_pre[0]
```

{:.input}
```python
ifile

# open a band - this is already done
test = rio.open(modis_bands_pre[0], 'r')
# in the function
# read in the data
bands = test.read()
# not sure what this does - it ensures 3 dimensions but why would it have less then 3?
if bands.ndim != 3:
    bands = bands[np.newaxis, ...]
for band in bands:
    ff.write(band, ii+1)    
    
```

{:.input}
```python
sources = [(rio.open(path, **kwds)) for path in band_paths]
if not type(sources[0]) == rasterio._io.RasterReader:
    print("yes")


```

{:.input}
```python

band_sources = sources
out_path = "data/week_07/outputs/modis_post_st.tif"

# this should return a graceful "dir doesn't exist" if it doesn't exist
# create a new stacked tif file
with rio.open(out_path, 'w', **meta) as ff:
    for ii, ifile in tqdm(enumerate(band_sources)):
            bands = sources[ii].read()
            if bands.ndim != 3:
                bands = bands[np.newaxis, ...]
            for band in bands:
                ff.write(band, ii+1)

    #if return_raster is True:
     #   return rio.open(out_path)
```

{:.input}
```python
the_dir = "data/week_07/outputs/testing.tif"
os.path.dirname(the_dir)
#os.path.isdir(the_dir)
```

{:.input}
```python
if not os.path.exists(out_path):
    raise ValueError("The output directory path that you provided does not exist")
```

{:.input}
```python
import contextlib

# EL function 
# we probably want to include a no data value here if provided ...
def stack_raster_tifs(band_paths, dest):
    """Take a list of raster paths and turn into an ouput raster stack.
    Note that this function depends upon the stack() function to be submitted to rasterio. 

    Parameters
    ----------
    band_paths : list of file paths
        A list with paths to the bands you wish to stack. Bands
        will be stacked in the order given in this list.
    dest : string
        A path for the output stacked raster file.    
    """
    
    if not os.path.exists(dest):
        raise ValueError("The output directory path that you provided does not exist")
    
    # the with statement ensures that all files are closed at the end of the with statement
    with contextlib.ExitStack() as context:
        sources = [context.enter_context(rio.open(path, **kwds)) for path in band_paths]

        dest_kwargs = sources[0].meta
        dest_count = sum(src.count for src in sources)
        dest_kwargs['count'] = dest_count

        # save out a stacked gtif file
        with rio.open(out_path, 'w', **dest_kwargs) as dest:
            return (stack(sources, dest))
        
        
# function to be submitted to rasterio
#  add unit tests: some are here: https://github.com/mapbox/rasterio/blob/master/rasterio/mask.py
# remove tqdm although it is nice
def stack(sources, dest):
    """Stack a set of bands into a single file.

    Parameters
    ----------
    sources : list of rasterio dataset objects
        A list with paths to the bands you wish to stack. Objects
        will be stacked in the order provided in this list.
    dest : string
        A path for the output stacked raster file.
    """
    if not os.path.exists(dest):
        raise ValueError("The output directory path that you provided does not exist")
        
    if not type(sources[0]) == rasterio._io.RasterReader:
        raise ValueError("The sources object should be of type: rasterio.RasterReader")
    
    for ii, ifile in tqdm(enumerate(sources)):
            bands = sources[ii].read()
            if bands.ndim != 3:
                bands = bands[np.newaxis, ...]
            for band in bands:
                dest.write(band, ii+1)
```

{:.input}
```python
# testing the above
band_paths = modis_bands_post
out_path = "data/week_07/outputs/modis_post_stacked_2.tif"

stack_raster_tifs(band_paths, out_path)
```

{:.input}
```python
# https://github.com/mapbox/rasterio/issues/1273
band_paths = modis_bands_post
out_path = "data/week_07/outputs/modis_post_stacked.tif"

kwds = {'mode': 'r'}

import contextlib
# the with statement ensures that all files are closed at the end of the with statement
with contextlib.ExitStack() as context:
    sources = [context.enter_context(rio.open(path, **kwds)) for path in band_paths]

    dest_kwargs = sources[0].meta
    dest_count = sum(src.count for src in sources)
    dest_kwargs['count'] = dest_count
    
    # save out a stacked gtif file
    with rio.open(out_path, 'w', **dest_kwargs) as dest:
        stack(sources, dest, return_raster=False) 
```

{:.input}
```python
# https://github.com/mapbox/rasterio/issues/1273
# this code works
band_paths = modis_bands_post
out_path = "data/week_07/outputs/modis_post_stacked.tif"

kwds = {'mode': 'r'}

import contextlib
# the with statement ensures that all files are closed at the end of the with statement
with contextlib.ExitStack() as context:
    sources = [context.enter_context(rio.open(path, **kwds)) for path in band_paths]

    dest_kwargs = sources[0].meta
    dest_count = sum(src.count for src in sources)
    dest_kwargs['count'] = dest_count
    
    with rio.open(out_path, 'w', **dest_kwargs) as dest:
        #stack(sources, dest) 
        for ii, ifile in tqdm(enumerate(band_sources)):
            bands = sources[ii].read()
            if bands.ndim != 3:
                bands = bands[np.newaxis, ...]
            for band in bands:
                dest.write(band, ii+1)
```

{:.input}
```python
import rasterio
import logging
import warnings

import numpy as np

#from rasterio.errors import WindowError
from rasterio.features import geometry_mask, geometry_window
```

{:.output}

    ---------------------------------------------------------------------------

    ImportError                               Traceback (most recent call last)

    <ipython-input-11-b8f8d363f091> in <module>()
          6 
          7 #from rasterio.errors import WindowError
    ----> 8 from rasterio.features import geometry_mask, geometry_window
    

    ImportError: cannot import name 'geometry_window'



{:.input}
```python
from rasterio.features import geometry_mask
```

{:.input}
```python
"""Mask the area outside of the input shapes with no data."""

import logging
import warnings

import numpy as np

#from rasterio.errors import WindowError

#from rasterio.features import geometry_mask, geometry_window


logger = logging.getLogger(__name__)


def raster_geometry_mask(dataset, shapes, all_touched=False, invert=False,
                         crop=False, pad=False):
    """Create a mask from shapes, transform, and optional window within original
    raster.

    By default, mask is intended for use as a numpy mask, where pixels that
    overlap shapes are False.

    If shapes do not overlap the raster and crop=True, a ValueError is
    raised.  Otherwise, a warning is raised, and a completely True mask
    is returned (if invert is False).

    Parameters
    ----------
    dataset: a dataset object opened in 'r' mode
        Raster for which the mask will be created.
    shapes: list of polygons
        GeoJSON-like dict representation of polygons that will be used to
        create the mask.
    all_touched: bool (opt)
        Include a pixel in the mask if it touches any of the shapes.
        If False (default), include a pixel only if its center is within one of
        the shapes, or if it is selected by Bresenham's line algorithm.
    invert: bool (opt)
        If False (default), mask will be `False` inside shapes and `True`
        outside.  If True, mask will be `True` inside shapes and `False`
        outside.
    crop: bool (opt)
        Whether to crop the dataset to the extent of the shapes. Defaults to
        False.
    pad: bool (opt)
        If True, the features will be padded in each direction by
        one half of a pixel prior to cropping dataset. Defaults to False.

    Returns
    -------
    tuple

        Three elements:

            mask : numpy ndarray of type 'bool'
                Mask that is `True` outside shapes, and `False` within shapes.

            out_transform : affine.Affine()
                Information for mapping pixel coordinates in `masked` to another
                coordinate system.

            window: rasterio.windows.Window instance
                Window within original raster covered by shapes.  None if crop
                is False.
    """
    if crop and invert:
        raise ValueError("crop and invert cannot both be True.")

    if crop and pad:
        pad_x = 0.5  # pad by 1/2 of pixel size
        pad_y = 0.5
    else:
        pad_x = 0
        pad_y = 0

    north_up = dataset.transform.e <= 0
    rotated = dataset.transform.b != 0 or dataset.transform.d != 0 

    try:
        window = geometry_window(dataset, shapes, north_up=north_up, rotated=rotated,
                                 pad_x=pad_x, pad_y=pad_y)

    except WindowError:
        # If shapes do not overlap raster, raise Exception or UserWarning
        # depending on value of crop
        if crop:
            raise ValueError('Input shapes do not overlap raster.')
        else:
            warnings.warn('shapes are outside bounds of raster. '
                          'Are they in different coordinate reference systems?')

        # Return an entirely True mask (if invert is False)
        mask = np.ones(shape=dataset.shape[-2:], dtype='bool') * (not invert)
        return mask, dataset.transform, None

    if crop:
        transform = dataset.window_transform(window)
        out_shape = (int(window.height), int(window.width))

    else:
        window = None
        transform = dataset.transform
        out_shape = (int(dataset.height), int(dataset.width))

    mask = geometry_mask(shapes, transform=transform, invert=invert,
                         out_shape=out_shape, all_touched=all_touched)

    return mask, transform, window


def mask(dataset, shapes, all_touched=False, invert=False, nodata=None,
         filled=True, crop=False, pad=False, indexes=None):
    """Creates a masked or filled array using input shapes.
    Pixels are masked or set to nodata outside the input shapes, unless
    `invert` is `True`.

    If shapes do not overlap the raster and crop=True, a ValueError is
    raised.  Otherwise, a warning is raised.

    Parameters
    ----------
    dataset: a dataset object opened in 'r' mode
        Raster to which the mask will be applied.
    shapes: list of polygons
        GeoJSON-like dict representation of polygons that will be used to
        create the mask.
    all_touched: bool (opt)
        Include a pixel in the mask if it touches any of the shapes.
        If False (default), include a pixel only if its center is within one of
        the shapes, or if it is selected by Bresenham's line algorithm.
    invert: bool (opt)
        If False (default) pixels outside shapes will be masked.  If True,
        pixels inside shape will be masked.
    nodata: int or float (opt)
        Value representing nodata within each raster band. If not set,
        defaults to the nodata value for the input raster. If there is no
        set nodata value for the raster, it defaults to 0.
    filled: bool (opt)
        If True, the pixels outside the features will be set to nodata.
        If False, the output array will contain the original pixel data,
        and only the mask will be based on shapes.  Defaults to True.
    crop: bool (opt)
        Whether to crop the raster to the extent of the shapes. Defaults to
        False.
    pad: bool (opt)
        If True, the features will be padded in each direction by
        one half of a pixel prior to cropping raster. Defaults to False.
    indexes : list of ints or a single int (opt)
        If `indexes` is a list, the result is a 3D array, but is
        a 2D array if it is a band index number.

    Returns
    -------
    tuple

        Two elements:

            masked : numpy ndarray or numpy.ma.MaskedArray
                Data contained in the raster after applying the mask. If
                `filled` is `True` and `invert` is `False`, the return will be
                an array where pixels outside shapes are set to the nodata value
                (or nodata inside shapes if `invert` is `True`).

                If `filled` is `False`, the return will be a MaskedArray in
                which pixels outside shapes are `True` (or `False` if `invert`
                is `True`).

            out_transform : affine.Affine()
                Information for mapping pixel coordinates in `masked` to another
                coordinate system.
    """

    if nodata is None:
        if dataset.nodata is not None:
            nodata = dataset.nodata
        else:
            nodata = 0

    shape_mask, transform, window = raster_geometry_mask(
        dataset, shapes, all_touched=all_touched, invert=invert, crop=crop,
        pad=pad)

    if indexes is None:
        out_shape = (dataset.count, ) + shape_mask.shape
    elif isinstance(indexes, int):
        out_shape = shape_mask.shape
    else:
        out_shape = (len(indexes), ) + shape_mask.shape

    out_image = dataset.read(
        window=window, out_shape=out_shape, masked=True, indexes=indexes)

    out_image.mask = out_image.mask | shape_mask

    if filled:
        out_image = out_image.filled(nodata)

    return out_image, transform


```

{:.input}
```python
import rasterio

class RasterDataset:
    # Every class needs an __init__ special method
    def __init__(self, array, **meta):
        self.__dict__ = meta
        self._data = array
        self._meta = meta  # Might not even need this...
    
    @property
    def shape(self):
        return self._data.shape

    # Static or class method. There's no 'self' here, but you'll return an instance
    @staticmethod
    def from_file(filepath, **kwargs):
        with rasterio.open(filepath, **kwargs) as f:
            return RasterDataset(f.read(), **f.meta)
            
    # Instance method, always start with self... you also have access to self.{attributes}
    def to_file(self, filepath, **kwargs):
        with rasterio.open(filepath, **dict(**kwargs, **self._meta)) as f:
            f.write(self._data)
            
    # Double underlines are all special methods in Python
    def __str__(self):
        return str(repr(self))
        
    def __repr__(self):
        return "RasterDataset({}, {})".format(self._data, self._meta)
        
    


```

{:.input}
```python
rd = RasterDataset.from_file("data/colorado-flood/spatial/boulder-leehill-rd/post-flood/lidar/post_DSM.tif")
rd.to_file("data/colorado-flood/spatial/outputs/test.tif", mode="w")
rd
```

{:.output}
    /Users/lewa8222/anaconda3/envs/earth-analytics-python/lib/python3.6/site-packages/rasterio/__init__.py:160: FutureWarning: GDAL-style transforms are deprecated and will not be supported in Rasterio 1.0.
      transform = guard_transform(transform)



{:.output}
{:.execute_result}



    RasterDataset([[[2020.25   2019.4199 2018.8099 ... 1695.58   1695.5299 1696.51  ]
      [2019.99   2019.23   2018.5499 ... 1695.6599 1695.52   1696.97  ]
      [2019.83   2019.0599 2018.39   ... 1695.52   1695.4299 1695.49  ]
      ...
      [1911.74   1911.57   1911.4099 ... 1682.87   1682.8099 1682.8099]
      [1911.32   1911.1699 1911.0599 ... 1682.3999 1682.5499 1682.63  ]
      [1910.96   1910.73   1910.64   ... 1682.19   1682.2799 1682.35  ]]], {'driver': 'GTiff', 'dtype': 'float32', 'nodata': -3.4028234663852886e+38, 'width': 4000, 'height': 2000, 'count': 1, 'crs': CRS({'init': 'epsg:32613'}), 'transform': (472000.0, 1.0, 0.0, 4436000.0, 0.0, -1.0), 'affine': Affine(1.0, 0.0, 472000.0,
           0.0, -1.0, 4436000.0), '_data': array([[[2020.25  , 2019.4199, 2018.8099, ..., 1695.58  , 1695.5299,
             1696.51  ],
            [2019.99  , 2019.23  , 2018.5499, ..., 1695.6599, 1695.52  ,
             1696.97  ],
            [2019.83  , 2019.0599, 2018.39  , ..., 1695.52  , 1695.4299,
             1695.49  ],
            ...,
            [1911.74  , 1911.57  , 1911.4099, ..., 1682.87  , 1682.8099,
             1682.8099],
            [1911.32  , 1911.1699, 1911.0599, ..., 1682.3999, 1682.5499,
             1682.63  ],
            [1910.96  , 1910.73  , 1910.64  , ..., 1682.19  , 1682.2799,
             1682.35  ]]], dtype=float32), '_meta': {...}})




