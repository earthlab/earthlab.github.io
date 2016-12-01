# Development -- Analytics Hub Tutorial website

This site is made with Jekyll, the Minimal Mistakes theme, and hosted via GitHub pages.
To work locally on the site:

### 1. Clone the repo
```
# clone the repository, , make the site, and serve it.
git clone $(The repo's URL)
cd $(The repo you just cloned)
```

### 2. Install all gems

```
# install the correct version of each gem specified in the gem file. Run this IN the cloned directory
bundle install
```

### If you are building tutorials from Juypter notebooks

```
make
```

### To build the site locally with the specified gems

You can view the site locally using http://localhost:4000 in your browser. 
NOTE: if the config BASEURL is not correct, the site won't build locally properly.

```
# run jekyll site locally
bundle exec jekyll serve
```
