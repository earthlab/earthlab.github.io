
---
layout: single
title: "ABC Classroom"
excerpt: "A suite of command-line utilities that simplify and streamline managing a class of students using GitHub classroom."
header:
  image: abc-classroom.png
  teaser: abc-classroom.png
  image_alt: ABC Classroom Badge
published: true
---

[![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.3539582.svg)](https://doi.org/10.5281/zenodo.3539582)


![PyPI](https://img.shields.io/pypi/v/abc-classroom.svg?color=purple&style=plastic)
![PyPI - Downloads](https://img.shields.io/pypi/dm/abc-classroom.svg?color=purple&label=pypi%20downloads&style=plastic)
[![codecov](https://codecov.io/gh/earthlab/abc-classroom/branch/master/graph/badge.svg)](https://codecov.io/gh/earthlab/abc-classroom)

[![Documentation Status](https://readthedocs.org/projects/abc-classroom/badge/?version=latest)](https://abc-classroom.readthedocs.io/en/latest/?badge=latest)
[![Code style: black](https://img.shields.io/badge/code%20style-black-000000.svg)](https://img.shields.io/badge/code%20style-black-000000.svg)

# Why ABC Classroom

Many of us teaching data science are using GitHub Classroom as a way to teach students
both git and GitHub skills and also potentially collaboration skills that align
with open source software development best practices. However there are many steps
associated with using GitHub classroom to manage a class.

Abc-Classroom contains a suite of command-line utilities that make it easier to
manage a class of students using GitHub classroom by:

1. Making it easier to create template assignment directories that are directly connected to your classroom organization
2. Making it easier to update those assignments and
3. (still under development) making it easier to clone all student assignments for grading.

We are currently using nbgrader in our workflow and are thus building this tool
out to support the use of nbgrader as well.

[Check it out on GitHub.](https://github.com/earthlab/abc-classroom)