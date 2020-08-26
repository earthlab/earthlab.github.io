

Earth Data scienceWebsite: [![Earth Data scienceWebsite DOI](https://zenodo.org/badge/62253359.svg)](https://zenodo.org/badge/latestdoi/62253359)
Please view our license for all courses and workshop material. Cite our materials following the license and us these DOI's as appropriate:
* Earth Analytics R Course: [![Earth Analytics R Course DOI](https://zenodo.org/badge/143348761.svg)](https://zenodo.org/badge/latestdoi/143348761)

## Contributors
Leah Wasser, Maxwell Joseph, Nathan Korinek, Lauren Herwehe

## Development -- EarthDataScience.org Website

[![Build Status](https://travis-ci.org/earthlab/earthlab.github.io.svg?branch=master)](https://travis-ci.org/earthlab/earthlab.github.io)

This site is made with Jekyll, the Minimal Mistakes theme, and hosted using
GitHub pages. To work locally on the site:


## Interactive Development: Run the Website Locally On Your Computer

You can use this repository to dynamically build and serve / view the EarthDataScience.org
Website locally using the following steps.

### 1. Fork and Clone the earthlab.github.io Repo

To begin, fork the earthlab/earthlab.github.io repo (if you are working on a fork)
If you are earth lab staff you likely want to directly clone this repo to view
updates from CI builds of lessons.

```
# clone the repository
$ git clone ${The repo's git URL}
$ cd earthlab.github.io
```

### 2. Install All Gems

The site runs on Jekyll and ruby. To build the site you first need to install
all of the needed tools. NOTE: this process can be a bit finicky for Windows
users but we did our best to document the workflow!

#### Installation for Windows Users

1. Install Ruby

If you are on windows you will need to install `ruby`

https://rubyinstaller.org/downloads/
We suggest installing ruby version `2.6.6.1+dev kit`. Other versions
may work but have not been tested.

When you install `ruby`, be sure that you also check the box to install `MSYS2`.

At the end of the `ruby` install, it will ask you if you want to install `MSYS2`.
Install the base installation of `MSYS2`.

2. Install the bundler. Run all of the following commands in Git Bash or a similar
command prompt program for Windows.

`$ gem install bundler`

Once you have completed this you can install all of the needed gems to run the
website by cd'ing into the **earthlab.github.io**:

`$ cd earthlab.github.io`

then run the code below to install the correct version of each gem that is needed
to build the site:

```
# Run this inside the cloned earthlab.github.io directory
bundle install
```

Once you have successfully installed all of the gems, you are ready to
build the website locally!

*Note:* You may need to run the above installations as an administrator on your
machine. You can do this by right clicking the program you're running the commands in
and selecting "Run as administrator"

*Note:* Currently, some of the file names that help build the website are to long
for windows machines. Thus when you clone the repo it will fail. You can get
around this issue by running the following code in bash:

```
$ git config --system core.longpaths true
```

We are working on shortening our file and directory names so these steps will not
be required in the future!

*Note:* Some users still had issues with path names after running the above code,
so as a last resort you can remove the `images` folder from the main directory
to make the website build. We are working on a fix for this!

#### Linux Installation Instructions

1. install ruby version 2.5 or 2.6

`$ sudo apt-get ruby-dev`

2. Next, install the bundler using admin permissions:

`$ sudo gem install bundler`

3. CD into the earthlab.github.io repository and run:

`$ sudo bundle install`

You are now ready to build the website locally.

####  macOS Installation Instructions

```
# install the correct version of each gem specified in the gem file. Run this IN the cloned directory
$ bundle install
```

## 3. Build the Site Locally and Start Developing

Once you have setup ruby and installed all required gemps, you can begin to
run the site locally. To run the site locally, first run the following in bash
from within the earthlab.github.io directory:

```
# run jekyll site locally
$ bundle exec jekyll serve
```

Once you have run the above, you can open up your favorite web browser and type:

`http://localhost:4000` or `http://127.0.0.1:4000/`

The site should appear in your browser. You can then begin to modify code as
needed. As you update files, the local site build will update allowing you
to interactively develop the site.



## Build Notes:

* the site requires jekyll flavored markdown. Be sure to specify that if you are knitting.
* in rmd files - be sure to specify fig.cap="text here" to add alt text to any code chunks that output a FIGURE.


## License

Please see license information, here https://github.com/earthlab/earthlab.github.io/blob/master/LICENSE
If you use our materials following license guidelines - please cite us!
