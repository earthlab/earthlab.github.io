

Earth Data scienceWebsite: [![Earth Data scienceWebsite DOI](https://zenodo.org/badge/62253359.svg)](https://zenodo.org/badge/latestdoi/62253359)
Please view our license for all courses and workshop material. Cite our materials following the license and us these DOI's as appropriate:
* Earth Analytics R Course: [![Earth Analytics R Course DOI](https://zenodo.org/badge/143348761.svg)](https://zenodo.org/badge/latestdoi/143348761)


## Development -- Earth Data Science Website

[![Build Status](https://travis-ci.org/earthlab/earthlab.github.io.svg?branch=master)](https://travis-ci.org/earthlab/earthlab.github.io)

This site is made with Jekyll, the Minimal Mistakes theme, and hosted via GitHub pages.
To work locally on the site:

## Contributors
Maxwell Joseph, Leah Wasser

## 1. Clone the repo
```
# clone the repository, , make the site, and serve it.
git clone $(The repo's URL)
cd $(The repo you just cloned)
```

## 2. Install all gems

```
# install the correct version of each gem specified in the gem file. Run this IN the cloned directory
bundle install
```

## If you are building tutorials from Juypter notebooks

```
make
```

## To build the site locally with the specified gems

You can view the site locally using http://localhost:4000 in your browser.
NOTE: if the config BASEURL is not correct, the site won't build locally properly.

```
# run jekyll site locally
bundle exec jekyll serve
```


## Build Notes:

* the site requires jekyll flavored markdown. Be sure to specify that if you are knitting.
* in rmd files - be sure to specify fig.cap="text here" to add alt text to any code chunks that output a FIGURE.

## CSS

Currently, we are using less. to install less

1. install nodejs (npm) https://nodejs.org/en/
2. install less : `sudo npm install less -g` NOTE: you need administration access to install

## License

Please see license information, here https://github.com/earthlab/earthlab.github.io/blob/master/LICENSE
If you use our materials following license guidelines - please cite us! 
