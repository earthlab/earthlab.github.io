---
author: Zach Schira
category: python
layout: single
tags:
- cenpy
- pandas
- pysal
title: Acquiring U.S. census data with Python and cenpy
---



There are several useful online sources for accessing census data provided both by the US census Bureau ([American Factfinder](http://factfinder.census.gov)), and outside sources. These sources, however, are not conducive to large scale data aquisition and analysis. The [Cenpy](https://pypi.python.org/pypi/cenpy/0.9.1) python package allows for programmitic access of this data through the [Census Bureau's API](http://www.census.gov/data/developers/data-sets.html).

This tutorial outlines the use of the Cenpy package to search for, and acquire specific census data. Cenpy saves this data as a [Pandas](http://pandas.pydata.org/) dataframe. These dataframes allow for easy access and analysis of data within python. For easy visualization of this data look into the [GeoPandas](http://geopandas.org/) package. This package builds on the base Pandas package to add tools for geospatial data analysis.

## Objectives
- Install Cenpy package
- Search for desired census data
- Download and store data

## Dependencies 
The Cenpy package depends on pandas and [requests](http://docs.python-requests.org/en/master/). Ensure that python and pip are already properly installed then use the following commands to install cenpy.


```python
!pip install pandas
!pip install requests
!pip install cenpy
!pip install pysal
```


```python
import pandas as pd
import cenpy as cen
import pysal
```

## Finding Data
The cenpy explorer module allows you to view all of the available [United States Census Bureau API's](http://www.census.gov/data/developers/data-sets.html). 


```python
datasets = list(cen.explorer.available(verbose=True).items())

# print first rows of the dataframe containing datasets
pd.DataFrame(datasets).head()
```




<div>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>0</th>
      <th>1</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>2012acs3</td>
      <td>2012 American Community Survey: 3-Year Estimates</td>
    </tr>
    <tr>
      <th>1</th>
      <td>NONEMP2013</td>
      <td>2013 Nonemployer Statistics: Non Employer Stat...</td>
    </tr>
    <tr>
      <th>2</th>
      <td>BDSFirms</td>
      <td>Time Series Business Dynamics Statistics: Firm...</td>
    </tr>
    <tr>
      <th>3</th>
      <td>POPESTprmagesex2013</td>
      <td>Vintage 2013 Population Estimates: Puerto Rico...</td>
    </tr>
    <tr>
      <th>4</th>
      <td>POPESTcty2013</td>
      <td>Vintage 2013 Population Estimates: County Tota...</td>
    </tr>
  </tbody>
</table>
</div>



Passing the name of a specific API to `explorer.explain()` will give a description of the data available. For this example, we will use the 2012 [American Community Service](https://www.census.gov/programs-surveys/acs/) 1 year data (`2012acs1`).


```python
dataset = '2012acs1'
cen.explorer.explain(dataset)
```




    {'2012 American Community Survey: 1-Year Estimates': "The American Community Survey (ACS) is a nationwide survey designed to provide communities a fresh look at how they are changing. The ACS replaced the decennial census long form in 2010 and thereafter by collecting long form type information throughout the decade rather than only once every 10 years.  Questionnaires are mailed to a sample of addresses to obtain information about households -- that is, about each person and the housing unit itself.  The American Community Survey produces demographic, social, housing and economic estimates in the form of 1-year, 3-year and 5-year estimates based on population thresholds. The strength of the ACS is in estimating population and housing characteristics. It produces estimates for small areas, including census tracts and population subgroups.  Although the ACS produces population, demographic and housing unit estimates,it is the Census Bureau's Population Estimates Program that produces and disseminates the official estimates of the population for the nation, states, counties, cities and towns, and estimates of housing units for states and counties.  For 2010 and other decennial census years, the Decennial Census provides the official counts of population and housing units."}



The base module allows you to establish a connection with the desired API that will be used later to acquire data.


```python
con = cen.base.Connection(dataset)
con
```




    Connection to 2012 American Community Survey: 1-Year Estimates (ID: http://api.census.gov/data/id/2012acs1)



## Acquiring Data

### Geographical specification

Cenpy uses [FIPS codes](https://www.census.gov/geo/reference/codes/cou.html) to specify the geographical extent of the data to be downloaded. The object `con` is our connection to the api, and the attribute `geographies` is a dictionary.


```python
print(type(con))
print(type(con.geographies))
print(con.geographies.keys())
```

    <class 'cenpy.remote.APIConnection'>
    <class 'dict'>
    dict_keys(['fips'])



```python
# print head of data frame in the geographies dictionary
con.geographies['fips'].head()
```




<div>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>geoLevelId</th>
      <th>name</th>
      <th>optionalWithWCFor</th>
      <th>requires</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>500</td>
      <td>congressional district</td>
      <td>state</td>
      <td>[state]</td>
    </tr>
    <tr>
      <th>1</th>
      <td>060</td>
      <td>county subdivision</td>
      <td>NaN</td>
      <td>[state, county]</td>
    </tr>
    <tr>
      <th>2</th>
      <td>795</td>
      <td>public use microdata area</td>
      <td>NaN</td>
      <td>[state]</td>
    </tr>
    <tr>
      <th>3</th>
      <td>320</td>
      <td>metropolitan statistical area/micropolitan sta...</td>
      <td>NaN</td>
      <td>[state]</td>
    </tr>
    <tr>
      <th>4</th>
      <td>310</td>
      <td>metropolitan statistical area/micropolitan sta...</td>
      <td>NaN</td>
      <td>NaN</td>
    </tr>
  </tbody>
</table>
</div>



`geo_unit` and `geo_filter` are both necessary arguments for the `query()` function. `geo_unit` specifies the scale at which data should be taken. `geo_filter` then creates a filter to ensure too much data is not downloaded. The following example will download data from all counties in Colorado (state FIPS codes are accessible [here](https://www.mcc.co.mercer.pa.us/dps/state_fips_code_listing.htm)).


```python
g_unit = 'county:*'
g_filter = {'state':'8'}
```

### Specifying variables to extract

The other argument taken by `query()` is cols. This is a list of columns taken from the variables of the API. These variables can be displayed using the `variables` function, however, due to the number of variables it is easier to use the [Social Explorer](https://www.socialexplorer.com/) site to find data you are interested in.


```python
var = con.variables
print('Number of variables in', dataset, ':', len(var))
con.variables.head()
```

    Number of variables in 2012acs1 : 68401





<div>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>concept</th>
      <th>label</th>
      <th>predicateOnly</th>
      <th>predicateType</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>AIANHH</th>
      <td>NaN</td>
      <td>American Indian Area/Alaska Native Area/Hawaii...</td>
      <td>NaN</td>
      <td>NaN</td>
    </tr>
    <tr>
      <th>AIANHHFP</th>
      <td>NaN</td>
      <td>American Indian Area/Alaska Native Area/Hawaii...</td>
      <td>NaN</td>
      <td>NaN</td>
    </tr>
    <tr>
      <th>AIHHTLI</th>
      <td>NaN</td>
      <td>American Indian Trust Land/Hawaiian Home Land ...</td>
      <td>NaN</td>
      <td>NaN</td>
    </tr>
    <tr>
      <th>AITS</th>
      <td>NaN</td>
      <td>American Indian Tribal Subdivision (FIPS)</td>
      <td>NaN</td>
      <td>NaN</td>
    </tr>
    <tr>
      <th>AITSCE</th>
      <td>NaN</td>
      <td>American Indian Tribal Subdivision (Census)</td>
      <td>NaN</td>
      <td>NaN</td>
    </tr>
  </tbody>
</table>
</div>



Related columns of data will always start with the same base prefix, so cenpy has an included function, `varslike`, that will create a list of column names that match the input pattern. It is also useful to add on the `NAME` and `GEOID` columns, as these will provide the name and geographic id of all data. In this example, we will use the [B01001A](https://www.socialexplorer.com/data/ACS2013/metadata/?ds=ACS13&table=B01001A), which gives data for sex by age within the desired geography. The identifier at the end corresponds to males or females of different age groups.


```python
cols = con.varslike('B01001A_')
cols.extend(['NAME', 'GEOID'])
```

With the three necessary arguments, data can be downloaded and saved as a pandas dataframe.


```python
data = con.query(cols, geo_unit=g_unit, geo_filter=g_filter)
# prints a deprecation warning because of how cenpy calls pandas
```

    /home/max/anaconda3/lib/python3.5/site-packages/cenpy/remote.py:167: FutureWarning: convert_objects is deprecated.  Use the data-type specific converters pd.to_datetime, pd.to_timedelta and pd.to_numeric.
      df[cols] = df[cols].convert_objects(convert_numeric=convert_numeric)


It is useful to replace the default index with the data from the `NAME` or `GEOID` column, as these will give a more useful description of the data.


```python
data.index = data.NAME

# print first five rows and last five columns
data.ix[:5, -5:]
```




<div>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>B01001A_030M</th>
      <th>B01001A_031E</th>
      <th>B01001A_031M</th>
      <th>NAME</th>
      <th>GEOID</th>
    </tr>
    <tr>
      <th>NAME</th>
      <th></th>
      <th></th>
      <th></th>
      <th></th>
      <th></th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>Adams County, Colorado</th>
      <td>671</td>
      <td>2483</td>
      <td>670</td>
      <td>Adams County, Colorado</td>
      <td>05000US08001</td>
    </tr>
    <tr>
      <th>Arapahoe County, Colorado</th>
      <td>701</td>
      <td>5125</td>
      <td>688</td>
      <td>Arapahoe County, Colorado</td>
      <td>05000US08005</td>
    </tr>
    <tr>
      <th>Boulder County, Colorado</th>
      <td>636</td>
      <td>2985</td>
      <td>645</td>
      <td>Boulder County, Colorado</td>
      <td>05000US08013</td>
    </tr>
    <tr>
      <th>Denver County, Colorado</th>
      <td>654</td>
      <td>5408</td>
      <td>650</td>
      <td>Denver County, Colorado</td>
      <td>05000US08031</td>
    </tr>
    <tr>
      <th>Douglas County, Colorado</th>
      <td>384</td>
      <td>1177</td>
      <td>366</td>
      <td>Douglas County, Colorado</td>
      <td>05000US08035</td>
    </tr>
  </tbody>
</table>
</div>



### Topologically Integrated Geographic Encoding and Referencing (TIGER) data

The Census [TIGER API](https://www.census.gov/geo/maps-data/data/tiger.html) provides geomotries for desired geographic regions. For instance, perhaps we want to have additional information on each county such as area.


```python
cen.tiger.available()
```




    [{'name': 'AIANNHA', 'type': 'MapServer'},
     {'name': 'CBSA', 'type': 'MapServer'},
     {'name': 'Hydro_LargeScale', 'type': 'MapServer'},
     {'name': 'Hydro', 'type': 'MapServer'},
     {'name': 'Labels', 'type': 'MapServer'},
     {'name': 'Legislative', 'type': 'MapServer'},
     {'name': 'Places_CouSub_ConCity_SubMCD', 'type': 'MapServer'},
     {'name': 'PUMA_TAD_TAZ_UGA_ZCTA', 'type': 'MapServer'},
     {'name': 'Region_Division', 'type': 'MapServer'},
     {'name': 'School', 'type': 'MapServer'},
     {'name': 'Special_Land_Use_Areas', 'type': 'MapServer'},
     {'name': 'State_County', 'type': 'MapServer'},
     {'name': 'tigerWMS_ACS2013', 'type': 'MapServer'},
     {'name': 'tigerWMS_ACS2014', 'type': 'MapServer'},
     {'name': 'tigerWMS_ACS2015', 'type': 'MapServer'},
     {'name': 'tigerWMS_Census2010', 'type': 'MapServer'},
     {'name': 'tigerWMS_Current', 'type': 'MapServer'},
     {'name': 'tigerWMS_Econ2012', 'type': 'MapServer'},
     {'name': 'tigerWMS_PhysicalFeatures', 'type': 'MapServer'},
     {'name': 'Tracts_Blocks', 'type': 'MapServer'},
     {'name': 'Transportation_LargeScale', 'type': 'MapServer'},
     {'name': 'Transportation', 'type': 'MapServer'},
     {'name': 'TribalTracts', 'type': 'MapServer'},
     {'name': 'Urban', 'type': 'MapServer'},
     {'name': 'USLandmass', 'type': 'MapServer'}]



First, you must establish a connection to the TIGER API, then you can display the avaialable layers. No Tiger data is available for ACS 2012, so we will use the ACS 2013 for the sake of example, but ideally you will be able to find corresponding Tiger data.


```python
con.set_mapservice('tigerWMS_ACS2013')

# print layers
con.mapservice.layers
```




    {0: (ESRILayer) 2010 Census Public Use Microdata Areas,
     1: (ESRILayer) 2010 Census Public Use Microdata Areas Labels,
     2: (ESRILayer) 2010 Census ZIP Code Tabulation Areas,
     3: (ESRILayer) 2010 Census ZIP Code Tabulation Areas Labels,
     4: (ESRILayer) Tribal Census Tracts,
     5: (ESRILayer) Tribal Census Tracts Labels,
     6: (ESRILayer) Tribal Block Groups,
     7: (ESRILayer) Tribal Block Groups Labels,
     8: (ESRILayer) Census Tracts,
     9: (ESRILayer) Census Tracts Labels,
     10: (ESRILayer) Census Block Groups,
     11: (ESRILayer) Census Block Groups Labels,
     12: (ESRILayer) Unified School Districts,
     13: (ESRILayer) Unified School Districts Labels,
     14: (ESRILayer) Secondary School Districts,
     15: (ESRILayer) Secondary School Districts Labels,
     16: (ESRILayer) Elementary School Districts,
     17: (ESRILayer) Elementary School Districts Labels,
     18: (ESRILayer) Estates,
     19: (ESRILayer) Estates Labels,
     20: (ESRILayer) County Subdivisions,
     21: (ESRILayer) County Subdivisions Labels,
     22: (ESRILayer) Subbarrios,
     23: (ESRILayer) Subbarrios Labels,
     24: (ESRILayer) Consolidated Cities,
     25: (ESRILayer) Consolidated Cities Labels,
     26: (ESRILayer) Incorporated Places,
     27: (ESRILayer) Incorporated Places Labels,
     28: (ESRILayer) Census Designated Places,
     29: (ESRILayer) Census Designated Places Labels,
     30: (ESRILayer) Alaska Native Regional Corporations,
     31: (ESRILayer) Alaska Native Regional Corporations Labels,
     32: (ESRILayer) Tribal Subdivisions,
     33: (ESRILayer) Tribal Subdivisions Labels,
     34: (ESRILayer) Federal American Indian Reservations,
     35: (ESRILayer) Federal American Indian Reservations Labels,
     36: (ESRILayer) Off-Reservation Trust Lands,
     37: (ESRILayer) Off-Reservation Trust Lands Labels,
     38: (ESRILayer) State American Indian Reservations,
     39: (ESRILayer) State American Indian Reservations Labels,
     40: (ESRILayer) Hawaiian Home Lands,
     41: (ESRILayer) Hawaiian Home Lands Labels,
     42: (ESRILayer) Alaska Native Village Statistical Areas,
     43: (ESRILayer) Alaska Native Village Statistical Areas Labels,
     44: (ESRILayer) Oklahoma Tribal Statistical Areas,
     45: (ESRILayer) Oklahoma Tribal Statistical Areas Labels,
     46: (ESRILayer) State Designated Tribal Statistical Areas,
     47: (ESRILayer) State Designated Tribal Statistical Areas Labels,
     48: (ESRILayer) Tribal Designated Statistical Areas,
     49: (ESRILayer) Tribal Designated Statistical Areas Labels,
     50: (ESRILayer) American Indian Joint-Use Areas,
     51: (ESRILayer) American Indian Joint-Use Areas Labels,
     52: (ESRILayer) 113th Congressional Districts,
     53: (ESRILayer) 113th Congressional Districts Labels,
     54: (ESRILayer) 2013 State Legislative Districts - Upper,
     55: (ESRILayer) 2013 State Legislative Districts - Upper Labels,
     56: (ESRILayer) 2013 State Legislative Districts - Lower,
     57: (ESRILayer) 2013 State Legislative Districts - Lower Labels,
     58: (ESRILayer) Census Divisions,
     59: (ESRILayer) Census Divisions Labels,
     60: (ESRILayer) Census Regions,
     61: (ESRILayer) Census Regions Labels,
     62: (ESRILayer) 2010 Census Urbanized Areas,
     63: (ESRILayer) 2010 Census Urbanized Areas Labels,
     64: (ESRILayer) 2010 Census Urban Clusters,
     65: (ESRILayer) 2010 Census Urban Clusters Labels,
     66: (ESRILayer) Combined New England City and Town Areas,
     67: (ESRILayer) Combined New England City and Town Areas Labels,
     68: (ESRILayer) New England City and Town Area Divisions,
     69: (ESRILayer) New England City and Town Area  Divisions Labels,
     70: (ESRILayer) Metropolitan New England City and Town Areas,
     71: (ESRILayer) Metropolitan New England City and Town Areas Labels,
     72: (ESRILayer) Micropolitan New England City and Town Areas,
     73: (ESRILayer) Micropolitan New England City and Town Areas Labels,
     74: (ESRILayer) Combined Statistical Areas,
     75: (ESRILayer) Combined Statistical Areas Labels,
     76: (ESRILayer) Metropolitan Divisions,
     77: (ESRILayer) Metropolitan Divisions Labels,
     78: (ESRILayer) Metropolitan Statistical Areas,
     79: (ESRILayer) Metropolitan Statistical Areas Labels,
     80: (ESRILayer) Micropolitan Statistical Areas,
     81: (ESRILayer) Micropolitan Statistical Areas Labels,
     82: (ESRILayer) States,
     83: (ESRILayer) States Labels,
     84: (ESRILayer) Counties,
     85: (ESRILayer) Counties Labels}



The data retrieved earlier was at the county level, so we will use layer 84. Using the tiger connection, `query()` can retrieve the data, taking the layer and the geographic location as arguments.


```python
geodata = con.mapservice.query(layer=84, where='STATE=8')
```


```python
# preview geodata
geodata.ix[:5, :5]
```




<div>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>AREALAND</th>
      <th>AREAWATER</th>
      <th>BASENAME</th>
      <th>CENTLAT</th>
      <th>CENTLON</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>1881237983</td>
      <td>36592000</td>
      <td>Boulder</td>
      <td>+40.0924502</td>
      <td>-105.3577112</td>
    </tr>
    <tr>
      <th>1</th>
      <td>396290895</td>
      <td>4208401</td>
      <td>Denver</td>
      <td>+39.7620189</td>
      <td>-104.8765880</td>
    </tr>
    <tr>
      <th>2</th>
      <td>6179976050</td>
      <td>30284242</td>
      <td>Pueblo</td>
      <td>+38.1732359</td>
      <td>-104.5127778</td>
    </tr>
    <tr>
      <th>3</th>
      <td>85478497</td>
      <td>1411781</td>
      <td>Broomfield</td>
      <td>+39.9541268</td>
      <td>-105.0527108</td>
    </tr>
    <tr>
      <th>4</th>
      <td>2958007403</td>
      <td>16886462</td>
      <td>Delta</td>
      <td>+38.8613998</td>
      <td>-107.8631974</td>
    </tr>
    <tr>
      <th>5</th>
      <td>4605714129</td>
      <td>8166134</td>
      <td>Cheyenne</td>
      <td>+38.8281780</td>
      <td>-102.6034141</td>
    </tr>
  </tbody>
</table>
</div>



This data can now be merged with the original data to create one pandas dataframe containing all of the relevant data.


```python
newdata = pd.merge(data, geodata, left_on='county', right_on='COUNTY')
newdata.ix[:5, -5:]
```




<div>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>NAME_y</th>
      <th>OBJECTID</th>
      <th>OID</th>
      <th>STATE</th>
      <th>geometry</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>Adams County</td>
      <td>1226</td>
      <td>27553700234319</td>
      <td>08</td>
      <td>&lt;pysal.cg.shapes.Polygon object at 0x7f6173163...</td>
    </tr>
    <tr>
      <th>1</th>
      <td>Arapahoe County</td>
      <td>2980</td>
      <td>27553703789414</td>
      <td>08</td>
      <td>&lt;pysal.cg.shapes.Polygon object at 0x7f617096c...</td>
    </tr>
    <tr>
      <th>2</th>
      <td>Boulder County</td>
      <td>512</td>
      <td>27553701435070</td>
      <td>08</td>
      <td>&lt;pysal.cg.shapes.Polygon object at 0x7f617448c...</td>
    </tr>
    <tr>
      <th>3</th>
      <td>Denver County</td>
      <td>529</td>
      <td>27553700234321</td>
      <td>08</td>
      <td>&lt;pysal.cg.shapes.Polygon object at 0x7f617448c...</td>
    </tr>
    <tr>
      <th>4</th>
      <td>Douglas County</td>
      <td>2762</td>
      <td>27553711656416</td>
      <td>08</td>
      <td>&lt;pysal.cg.shapes.Polygon object at 0x7f6173058...</td>
    </tr>
    <tr>
      <th>5</th>
      <td>El Paso County</td>
      <td>2878</td>
      <td>27553704502958</td>
      <td>08</td>
      <td>&lt;pysal.cg.shapes.Polygon object at 0x7f6171448...</td>
    </tr>
  </tbody>
</table>
</div>




```python

```