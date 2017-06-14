

# Development -- Analytics Hub Tutorial website

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
- all materials are Creative comments by attribution. If you use our materials - please cite us! 
