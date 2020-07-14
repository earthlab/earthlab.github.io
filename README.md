

Earth Data scienceWebsite: [![Earth Data scienceWebsite DOI](https://zenodo.org/badge/62253359.svg)](https://zenodo.org/badge/latestdoi/62253359)
Please view our license for all courses and workshop material. Cite our materials following the license and us these DOI's as appropriate:
* Earth Analytics R Course: [![Earth Analytics R Course DOI](https://zenodo.org/badge/143348761.svg)](https://zenodo.org/badge/latestdoi/143348761)


## Development -- Earth Data Science Website

[![Build Status](https://travis-ci.org/earthlab/earthlab.github.io.svg?branch=master)](https://travis-ci.org/earthlab/earthlab.github.io)

This site is made with Jekyll, the Minimal Mistakes theme, and hosted via GitHub pages.
To work locally on the site:

## Contributors
Maxwell Joseph, Leah Wasser

## Set Up to Display Site Locally

You can use this repo to display the Earth Data Science Website locally using 
the following steps.

### 1. Clone the repo
```
# clone the repository
git clone $(The repo's URL)
cd $(The repo you just cloned)
```

### 2. Install all gems

#### Installation for Windows Users

1. Install Ruby

If you are on windows you will need to install `ruby`

https://rubyinstaller.org/downloads/
We suggest installing ruby version `2.6.6.1+dev kit`. Other versions
may work but have not been tested.

When you install ruby, be sure that you also check the box to install `MSYS2`.

At the end of the `ruby` install, it will ask you if you want to install `MSYS2`.
Install the base installation.

2. Install the bundler. Run all of the following commands in Git Bash or a similar 
command prompt program for Windows. 

`gem install bundler`

Once you have completed this you can install all of the needed gems to run the
website by cd'ing into the earthlab.github.io:

`cd earthlab.github.io`

then run:

```
# install the correct version of each gem specified in the gem file.
# Run this inside the cloned earthlab.github.io directory
bundle install
```

Once you have done this, and everything installs correctly, you are ready to
build the website locally!

*Note:* You may need to run the above installations as an administrator on your
machine. You can do this by right clicking the program you're running the commands in
and selecting "Run as administrator"

*Note:* Currently, some of the file names that help build the website are to long 
for windows machines. You can get around this issue by running the following code:

```
git config --system core.longpaths true
```

*Note:* Some users still had issues with path names after running the above code,
so as a last resort you can remove the `images` folder from the main directory
to make the website build. We are working on a fix for this!

#### Linux Installation Instructions

1. install ruby version 2.5 or 2.6

`sudo apt-get ruby-dev`

2. Next, install the bundler using admin permissions:

`sudo gem install bundler`

3. CD into the earthlab.github.io repository and run:

`sudo bundle install`

You are now ready to build the website locally.

####  macOS Installation Instructions
```
# install the correct version of each gem specified in the gem file. Run this IN the cloned directory
bundle install
```

### 3. Build the site locally with the specified gems

You can view the site locally using http://localhost:4000 or http://127.0.0.1:4000/
in your browser.
NOTE: if the config BASEURL is not correct, the site won't build locally properly.

```
# run jekyll site locally
bundle exec jekyll serve
```

### Building Tutorials from Juypter notebooks

If you are building tutorials from Juypter notebooks, running the 
following command will make the website for you.

```
make
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
