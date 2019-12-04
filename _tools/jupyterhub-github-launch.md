---
layout: single
title: "Setup JupyterHub Using Google Cloud Through GitHub"
excerpt: "Infrastructure and operations for the Earth Lab JupyterHubs."
splash_header: "Control and Launch Multiple JupyterHubs using Google Cloud Using GitHub and Yaml Configuration Files."
tool_page_title: "Launch and Manage Multiple JupyterHub Instances From GitHub"
authors: ["Tim Head", "Leah Wasser"]
header:
  overlay_color: "#000080"
  teaser: jupyter-hub-ops.png
  image_alt: Jupyter Hub Ops Badge
published: true
documentation: https://earthlab-hub-ops.readthedocs.io/en/latest/index.html
---


Sometimes you may need different JupyterHub environments for various
courses, projects and / or workshop. The hub-ops tool, allows you to
quickly launch a JupyterHub, using Google Cloud. To launch a new hub, you need to
1. specify the docker container that you wish to use as your environment.
2. Update a yaml file on github containing the docker information and specifications for the hub including computer power needed.
3. Specify any files that you'd like to add to the hub. This uses nbgitpuller to grab files from a specific GitHub repo (of your choice!).

This tool was developed to make is easier for Earth Lab to manage their
JupyterHub environment in support of the earth analytics education program activities.

[![DOI](https://zenodo.org/badge/136452806.svg)](https://zenodo.org/badge/latestdoi/136452806)
[![Build Status](https://travis-ci.org/earthlab/hub-ops.svg?branch=master)](https://travis-ci.org/earthlab/hub-ops)
[![Docs Status](https://readthedocs.org/projects/earthlab-hub-ops/badge/?version=latest)](https://readthedocs.org/projects/earthlab-hub-ops/builds/)

[Access the JupyterHub Ops repo on GitHub.](https://github.com/earthlab/hub-ops)
