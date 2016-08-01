---
author: Zach Schira
category: python
layout: single
tags:
- numpy
- pysal
- pysal.spreg
title: Introductory to Spatial Regression in Python
---



Regression analysis allows you to model and predict some process based on its relationship to a specific dependent variable or variables. Often times, however, a standard regression model is insufficient for modeling data with a spatial dependency. This happens when the data is spatially autocorrelated. In these cases, you may want to instead use a spatial regression model.

Spatial regression analysis allows you to encorporate spatial dependencies into your model. This tutorial will outline how to use the [PySAL](https://pypi.python.org/pypi/PySAL) Python package to use these spatial regression methods.

## Objectives
- Perform ordinary linear regression analysis
- Evaluate spatial autocorrelation
- Perform spatial regression analysis

## Dependencies
- PySAL
- numpy


```python
!pip install pysal
```


```python
import pysal
import numpy as np
from pysal.spreg import ols
from pysal.spreg import ml_error
from pysal.spreg import ml_lag
```

The pysal package contains many sample data files that can be used to demonstrate the package's abilities. For this example we will be analyzing Columbus home values with relation to income and crime by neighborhood. First we will run an [ordinary least squares](https://en.wikipedia.org/wiki/Ordinary_least_squares) linear regression model to analyze the relationship between these variables.

This first section of code will read in the home values (dependent variable) into an array `y` and the income and crime values (independent variables) into a two dimmensional array `X`.


```python
f = pysal.open(pysal.examples.get_path("columbus.dbf"),'r')
y = np.array(f.by_col['HOVAL'])
y.shape = (len(y),1)
X= []
X.append(f.by_col['INC'])
X.append(f.by_col['CRIME'])
X = np.array(X).T
```

Now that we have stored the values we are analyzing we can perform ordinary least squares (OLS) regression. This is done with the [pysal.spreg](http://pysal.readthedocs.io/en/v1.11.0/library/spreg/index.html) module. Our instance of `OLS`, named `ls`, has many useful tools for reviewing the results of our test. In this case, we will use `ls.summary` to obtain of full summary of the results, but for more specific results you can look at some of the other options on the `pysal.spreg` page linked above.


```python
ls = ols.OLS(y, X, name_y = 'home val', name_x = ['Income', 'Crime'], name_ds = 'Columbus')
print(ls.summary)
```

    REGRESSION
    ----------
    SUMMARY OF OUTPUT: ORDINARY LEAST SQUARES
    -----------------------------------------
    Data set            :    Columbus
    Weights matrix      :        None
    Dependent Variable  :    home val                Number of Observations:          49
    Mean dependent var  :     38.4362                Number of Variables   :           3
    S.D. dependent var  :     18.4661                Degrees of Freedom    :          46
    R-squared           :      0.3495
    Adjusted R-squared  :      0.3212
    Sum squared residual:   10647.015                F-statistic           :     12.3582
    Sigma-square        :     231.457                Prob(F-statistic)     :   5.064e-05
    S.E. of regression  :      15.214                Log likelihood        :    -201.368
    Sigma-square ML     :     217.286                Akaike info criterion :     408.735
    S.E of regression ML:     14.7406                Schwarz criterion     :     414.411
    
    ------------------------------------------------------------------------------------
                Variable     Coefficient       Std.Error     t-Statistic     Probability
    ------------------------------------------------------------------------------------
                CONSTANT      46.4281827      13.1917570       3.5194844       0.0009867
                  Income       0.6289840       0.5359104       1.1736736       0.2465669
                   Crime      -0.4848885       0.1826729      -2.6544086       0.0108745
    ------------------------------------------------------------------------------------
    
    REGRESSION DIAGNOSTICS
    MULTICOLLINEARITY CONDITION NUMBER           12.538
    
    TEST ON NORMALITY OF ERRORS
    TEST                             DF        VALUE           PROB
    Jarque-Bera                       2          39.706           0.0000
    
    DIAGNOSTICS FOR HETEROSKEDASTICITY
    RANDOM COEFFICIENTS
    TEST                             DF        VALUE           PROB
    Breusch-Pagan test                2           5.767           0.0559
    Koenker-Bassett test              2           2.270           0.3214
    ================================ END OF REPORT =====================================


OLS regression assumes that each observation is independent from all others. However, in practice, locations that are near eachother are not likely to be independent. 

We can evaluate spatial autocorrelation in the residuals with [Moran's I](https://en.wikipedia.org/wiki/Moran%27s_I) test. Our first step in that process is to create a spatial weights matrix. PySAL's example data has a GAL file that we can read in directly to create this matrix.


```python
w = pysal.open(pysal.examples.get_path("columbus.gal")).read()
```

We can pass this weights matrix to the `pysal.Moran` function, along with our model residuals (`ls.u`). 

The observed value for I is much higher than the value we would expect if there was no spatial dependence. The p-value is the probability that we would observe the value of I that we did (or one greater) if there were no spatial dependence. 


```python
mi = pysal.Moran(ls.u, w, two_tailed=False)
print('Observed I:', mi.I, '\nExpected I:', mi.EI, '\n   p-value:', mi.p_norm)
```

    Observed I: 0.171310158169 
    Expected I: -0.020833333333333332 
       p-value: 0.0189304275212


We can use a spatial regression model to account for spatial non-independence. The `spreg` module has several different functions for creating a spatial regression model. In this example, we will use a spatial error model, but the implementation of a spatial lag model is similar. 


```python
spat_err = ml_error.ML_Error(y, X, w, 
                             name_y='home value', name_x=['income','crime'], 
                             name_w='columbus.gal', name_ds='columbus')
print(spat_err.summary)
```

    REGRESSION
    ----------
    SUMMARY OF OUTPUT: MAXIMUM LIKELIHOOD SPATIAL ERROR (METHOD = FULL)
    -------------------------------------------------------------------
    Data set            :    columbus
    Weights matrix      :columbus.gal
    Dependent Variable  :  home value                Number of Observations:          49
    Mean dependent var  :     38.4362                Number of Variables   :           3
    S.D. dependent var  :     18.4661                Degrees of Freedom    :          46
    Pseudo R-squared    :      0.3495
    Sigma-square ML     :     197.314                Log likelihood        :    -199.769
    S.E of regression   :      14.047                Akaike info criterion :     405.537
                                                     Schwarz criterion     :     411.213
    
    ------------------------------------------------------------------------------------
                Variable     Coefficient       Std.Error     z-Statistic     Probability
    ------------------------------------------------------------------------------------
                CONSTANT      47.8090727      12.3906790       3.8584708       0.0001141
                  income       0.7213778       0.5029284       1.4343549       0.1514710
                   crime      -0.5576102       0.1788127      -3.1184037       0.0018183
                  lambda       0.3578233       0.1705868       2.0976020       0.0359403
    ------------------------------------------------------------------------------------
    ================================ END OF REPORT =====================================


    /Users/majo3748/anaconda/lib/python3.5/site-packages/scipy/optimize/_minimize.py:596: RuntimeWarning: Method 'bounded' does not support relative tolerance in x; defaulting to absolute tolerance.
      "defaulting to absolute tolerance.", RuntimeWarning)



```python

```