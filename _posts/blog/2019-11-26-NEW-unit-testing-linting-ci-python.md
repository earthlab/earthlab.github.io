---
title: "How Unit Testing, Linting, and Continuous Integration in Python Can Improve Open Science | Earth Lab"
header1: "How To Integrate Unit Testing, Linting, and Continuous Integration Into Your Python Projects"
authors: ["Will Norris"]
category: blog
excerpt: "Making your codebase more robust with unit tests, linting, and continuous integration improves your ability to reuse code in house and greatly reduces the effort needed to share code. In this post, you will learn how to integrate testing with pytest, linting with black and flake8, and continuous integration with Travis."
layout: single
modified: '2020-01-08'
comments: yes
permalink: blog/unit-testing-linting-ci-python/
sidebar:
  nav:
tags: 
author_profile: no
---



## Introduction

Packaging Python software that has helped improve your or your team's workflow can be very beneficial to the greater Python community; it makes your software more robust and can also improve your ability to use it in house. However, without the proper infrastructure in place, your Python package will likely either break over time or be too difficult for other users to use efficiently. Making your codebase public can also give you exposure to other great programmers working on similar problems; the more people using your code, the more likely it is to grow and improve. If you have ever helped beta test software for a colleague then you've seen first hand how quickly fresh eyes on a problem can accelerate development; the easier your software is for new users to try, and potentially integrate into their workflows, the more testers you get.

In order to make your software work in the long haul, and for a broad group of users, it is important to consider what it is meant to do, whether it achieves that goal, and if the code will be maintainable into the future. These three requirements can be addressed via three tools: unit testing, linting, and continuous integration. With these three tools you can ensure that your Python packages will function into the future and are well positioned to have new users use them or build upon them.

In this post, I will start by discussing these three tools, and what packages we have access to in Python to leverage them. Then I will do a brief walkthrough going through the setup all of these services in your own GitHub repository. There are some links to example configuration (config) files for Travis as well that some users with specific use cases may find helpful. 

## Unit Testing

### What is Unit Testing and Why is it Critical?

Testing your code is never the first thing software engineers think of, but it should be! So often we have an idea to make our workflow easier so we implement it as fast as possible. As long as it gives us the desired output it should be fine, right?

Code that we sling together often only covers the specific use cases that we were dealing with that day. This means that when you dust off that module you used to process your data last time, it may not work as you expected today.

There are several possible reasons why code works one day and not another day:
1. Not Truly Understanding What a Function is Meant To Do
2. Edge Cases That Were Not Considered
3. Updated/Out-of-Date Software or Dependencies

### Not Understanding What a Function is Meant To Do

The proper time to write your unit tests is while you are writing your code. If you want to add a new function to a Python library you have created, it makes sense to start by thinking about how you would like it to function and then writing a unit test(s) that checks if it works how you expect. You can even write the test that calls your new function before you write the function at all; if you understand how it needs to be used, you will understand how to build it.

Programmers are always surprised when they get around to finally using their new code only to realize it needs to be refactored to actually function as required. When you write unit tests, you force yourself to really consider what, why, and how your code will accomplish the desired outcomes. This process of testing code as you develop it can also help you to reduce technical debt that can accumulate over the course of a project and aid in constructing an application that flows and works cohesively.

While it may seem tedious to stop and write tests as you add functionality to your Python package, it will save you immense trouble in the long run. Writing unit tests after a program has been developed is far more difficult than writing them as you work. Once you have written 500 lines of code, you may not have the best grasp of exactly what each line in that file is supposed to do at the finer detail level. This means that going back to write your unit tests is going to require you to go step by step through your code, which can be more difficult after you have created a lot of interaction among functions. As mentioned above, writing you unit tests will help shape the finer details of how each function works; this means if you leave testing to the last minute, you may find yourself doing large overhauls to your codebase. Especially if you have a more complex library, refactoring can end up requiring a lot of time and consideration.

### Edge Cases That Were Not Considered

As you write a function think about different inputs that could cause edge cases. Ask yourself how will you handle these edge cases, and write a unit test for each one that makes sure they are covered.

It’s natural to miss edge cases in development; if you ever come upon another edge case when using your code, figure out how to solve it, then write a unit test for it. If you cannot solve this issue immediately, open an issue in the GitHub repo for the code to remind yourself to come back later and fix the issue. 

In addition to testing your own code, if you ever find yourself fixing an edge case for another repository that is owned by someone else, it is best practice to write a unit test to go along with the pull request. Adding a unit test gives the repository owner a clear sense for what use case(s) you are attempting to fix and the method you went about it. It also saves the library maintainers time to fully understand your code and write unit tests for it; maintaining open source packages is not a paid job, especially in the long term, so helping maintain packages you make use of is greatly beneficial to the Python community as a whole.

### Updated/Out-of-Date Software or Dependencies

One of the most common reasons that Python code works one day and not the next is due to the complex dependency system that Python employs. It is not at all uncommon for one of your dependencies to be updated and either alter the way you must make use of their functionality or remove it completely; occasionally updates simply break things too, and get fixed in time. If you have a robust unit testing system in place you can normally pinpoint which dependency is causing your issues, which can save massive amounts of time troubleshooting!

Dependency issues in Python warrant an entire post of their own. However, it is worth mentioning that moving all of your dependencies to one download channel can save you massive headaches in the future. This means that if you can only get a package on conda-forge, you should try to download all the packages in your environment using conda-forge. This means you ultimately should publish your package on conda-forge as well. There is debate over using pip/conda/conda-forge, but currently conda-forge is the easiest environment to get running for geospatial packages that include GDAL as a dependency. 

### What Tools Should I Use for Unit Testing?

In Python today, pytest is generally the easiest and most Pythonic way to test your code. It is easy to learn how to use, but contains a lot of customizability as your project expands and your testing demands change. Pytest is also easy to integrate into Travis-CI, which we will discuss later in this post.

## Linting

### What is Linting and Why is it Important?

Years ago a tool called “lint” was very popular in Unix for analyzing source code in C. Lint would go through your program and look for errors, bugs, stylistic issues, etc. This idea is that our “linter” would pick up the lint/dust left around our code leaving a clean and finished product. In general a linting service will simply tell you that an error exists and leave the fixing up to the programmer.  

As programmers, we write and read code every day. It helps if that code is consistent and similar from file to file or programmer to programmer. The more consistent the code, the faster someone can look past the syntax to see what is actually going on. When code is inconsistent, we have to spend time deciphering syntax before we actually get to the core of the functionality. In order to achieve consistent syntax we must embrace some form of standards when it comes to formatting. Some programming languages have built in formatters and standards (e.g. Go), but others follow community agreed standards (e.g. Python). If you have spent some time programming in Python, then you probably have heard of PEP8, which is the standard style guide that the Python community agreed to follow many years ago.

The interesting thing about PEP8 is that it is just a guide. Go has a built in tool for enforcing its formatting standards, but Python simply has a set of community established guidelines for programmers to follow. This has lead to inconsistent formatting of code from person to person, and can impact the readability of files when sharing open science.

The automatic tool that Go has access to, `gofmt`, is called a linting service. This service takes your files and checks them for style/formatting issues. It then handles any issues found and returns a formatted file. This ultimately leads to everyone's files being formatted in the same manner.

Python doesn't have an automatic tool like this built in, but in true Python fashion it does have access to some great third party libraries for performing this task.

Our first useful tool is `flake8`, which finds style errors and reads out where they are coming from for you. However, `flake8` does not fix any of these formatting issues. It just tells you where they are. You will probably end up using `flake8` manually for some things, but there are better ways to address the bulk of the issues that will come up.

This is where a tool called `black` comes in. `black` isn't a part of the standard Python library and doesn't adhere 100% to PEP8 standards; however, it does do a phenomenal job at cleaning your code into a format that is easy to read and maintain. black actually contains a few extra rules on top of PEP8 standards that its team claim make it even better for producing maintainable code, which is critical to Python programmers; maintaining Python libraries can be one of the most difficult long term challenges a programmer faces. Luckily the tools we will discuss next will further aid in keeping your projects maintained over time.

**Note**: Many of the tools we will discuss in this post are very flexible in their usage, but `black` is said to be “uncompromising”. Meaning that the `black` team feels there is not much need for customization beyond their standards. This is okay because the tool works very well, but if you want to make some large formatting adjustments, it may be the wrong tool for you. 

## Continuous Integration

### What is Continuous Integration and Why is it Important?

Note: I will be using Travis-CI as my example CI service because it is easy/free to integrate with public GitHub repositories and is very flexible to use.

Continuous integration is likely the most important tool for enabling the creation of maintainable code. With a continuous integration (CI) service, like Travis-CI, every time you push a new version of your code its unit tests get run in a fresh environment with the dependencies of your choosing. This process of building a fresh environment each iteration is a true test of what a new user will experience using the tools you have provided. If a dependency has been updated, your local environment may not reflect that, but a fresh environment built by Travis will test the newest versions of your dependencies. 

You can choose to run your continuous integration over specific intervals of time to ensure changes to your dependencies haven't broken what you are using them for. If something does break, you can go look at which test is broken and use the error messages to find out what changes have lead to new bugs.

CI services aren't just useful for running tests, they also provide the ability to deploy code and save you more time. For example, every time a tagged commit is created in the <a href="https://github.com/earthlab/earthpy/blob/master/.travis.yml" target="_blank">earthpy</a> git repo, a command is triggered to publish a new pypi version of their software. There are many different "hooks" you can add that get triggered when certain build conditions are met.

## Our Toolbox

Now that we've discussed why testing and formatting are both critical to the process of creating reliable Python code let's dig into the tools we have to implement them.

### 1. Testing Tools

* `pytest`: Pytest is a very easy to use and Pythonic testing library for Python projects. It can be easily installed into a pip or conda environment, and requires very little extra code to start working.
Pytest is also very flexible and can handle most testing requirements you could need, which makes it a great tool for new and experienced Python users alike; it also is well suited to grow with projects that start small and scale quickly.
* `codecov`: Codecov, which stands for "code coverage", is a framework that keeps track of the percentage of lines of your code that are executed by your unit tests. This helps give you an understanding of where you are testing and most importantly where your testing is lacking. It is easy to install and pairs well with pytest, so using it is a no brainer!

### 2. Linting Tools

* `flake8`
* `black`
* `pre-commit`

Since we want to run `flake8` and `black` each time we commit new code, we will take advantage of another framework called `pre-commit`, which allows us to specify an array of different tasks that we want performed any time we try to commit new code; if the tasks pass, then we can commit, if they fail then we must address them before committing.

In order to use `pre-commit`, we simply need to create a `.pre-commit-config.yaml` file and specify the desired hooks. An example that triggers black and flake8 can be seen below in the step by step guide.

### 3. Continuous Integration Tools
* `Travis-CI`

Travis-CI is my favorite CI service to teach to programmers who work with open source software because it is very well designed, free for open source projects, and easy to learn how to use while still having a high ceiling of potential customization. You can run the most basic pytest testing suite in Travis or you can build software in multiple OS's and automatically deploy your code to several sources when it's done. Many other open source projects make use of Travis as well, which means there are many examples out there to look at when customizing further. 

Travis enables a great workflow when combined with the other tools mentioned because it allows you to automate testing and deployment of your code, which removes quite a few steps to maintaining Python packages. 

### Tool Wrap Up:

To show you the flow, let’s look at the steps:

<figure>
  <a href="{{ site.url }}/images/blog/2019-11-26-unit-testing-linting-ci-python/workflow-unit-testing-linting-ci-python.jpg">
    <img src="{{ site.url }}/images/blog/2019-11-26-unit-testing-linting-ci-python/workflow-unit-testing-linting-ci-python.jpg" alt="You can integrate tools for testing, linting, and continuous integration into one workflow.">
  </a>
  <figcaption>You can integrate tools for testing, linting, and continuous integration into one workflow. Source: Will Norris
  </figcaption>
</figure>


## Okay, So What Do You Need to Add to Your Repo?

We've covered a lot of ground here, and it's totally understandable if you are struggling with where to start. Let's break down where each of these frameworks get integrated into your project.

Most of these technologies only require a simple config file to provide the functionality you need, however there is some interaction that should be made clear before you jump right in.

To start you must have a public GitHub repository that contains the code you have manually been deploying to pypi for distribution. It isn't mandatory that your code is a Python library, however some of this guide will pertain to automatic deployment, which you can just skip if you aren't deploying.

### 1. Setup your pre-commit yml file

The first step of the whole process is to begin linting your code using `flake8` and `black`. To do this we will use another framework called `pre-commit`, which lets you add all kinds of hooks that occur anytime you try to commit new code. We will add two hooks, one for `flake8` that checks our code for formatting issues, and `black` which handles most of the formatting issues that our code may contain.

To do this, we need to add our `.pre-commit-config.yaml` file to the root directory of our repo and tell it to run our linting services. Here is an example file with these two requirements:

```
repos:
-   repo: https://github.com/ambv/black
    rev: stable
    hooks:
    - id: black
      language_version: Python3.6
-   repo: https://github.com/pre-commit/pre-commit-hooks
    rev: v1.2.3
    hooks:
    - id: flake8
```

As you can see above, all we need to do in a `pre-commit` config file is specify the repos that we would like to pull our hooks from. Now when you commit code to your repo you should see the outputs from both `flake8` and `black`.

## 2. Add your flake8 config file: `.flake8`

This file is a simple config file for `flake8` that tells it to ignore some issues. It goes in the root directory of your project. There are some preset errors to ignore that `black` technically breaks, which are reflected in the example file below:

```
[flake8]
ignore = E203, E266, E501, W503, F403
max-line-length = 79
max-complexity = 18
select = B,C,E,F,W,T4,B9
```

If you decide you want to be able to break other errors that `flake8` flags, you can lookup the code for the error and add it to your `ignore` list.

### 3. Setup your Travis-CI service

In order to use Travis-CI, you need to head to the <a href="https://docs.travis-ci.com/" target="_blank">Travis-CI website</a>, where you can login with your GitHub account and connect the repository you are working from. Once you have connected your repo, the rest of the work is done by your `.travis.yml` file, which goes in the root directory of you repo.

Your `travis.yml` file is quite specific to the type of project you are testing. The example I will use below is for a simple Python library; however, continuous integration can be useful for code that is not packaged as well.

```
language: Python
Python:
  - "2.7"
  - "3.6"
# command to install dependencies
install:
  - pip install -r requirements.txt
# command to run tests
script:
  - pytest
```  
  
We can see that the travis file runs our pytest functions with a code coverage command attached. This means that everytime you push code to your repo, Travis will automatically build a fresh environment, run your unit tests, and then generate a code coverage report.

In this example we build the environment from a pip install of a text file. This works well for many simpler projects, but as things get more complicated you may want to use conda environments or virtual environments with bash scripts to aid in more complex installation. I will discuss this more below, but you can see an example <a href="https://github.com/wino6687/blogci/tree/master/travis_examples/script_install_example" target="_blank">here</a> of a repo that builds a different conda environment depending on what operating system is being run.


## Tips for Performing Various Travis Tasks

### Web Scraping

Establishing a real http connection with your tiny linux instance in Travis is slow and not reliable, so instead of pinging real servers, it is best to build a mock server script and run that within your Travis environment. There is an example `.travis.yml` file <a href="https://github.com/wino6687/blogci/blob/master/travis_examples/script_install_example/travis.yml" target="_blank">here</a>, that shows how to spin up a mock server along with the code for one. All you need to do is write a simple HTTP server using Pythons built in tools and tell it what data files to serve locally; this way, you can store a small subset of data, and never worry about pinging real servers during unit testing. 

In order for Travis to run your mock server, you will need to run it in the background of your Linux instance before your test script is run. You can do this by adding the following command to your `.travis.yml`. It is important to note the “&”, which tells your system to run this program in the background.

```
before_script:
  - mock_server.py &
```

### Testing on Multiple OS's

There are a couple different ways to test on more than one OS in Travis. The documentation for doing so is <a href="https://docs.travis-ci.com/user/multi-os/" target="_blank">here</a>; however, these docs are not a complete picture for Python projects.

The key to testing in multiple OS's is using Travis's `matrix` keyword in your yml file. You can do something like this:

```
matrix:
  include:
  - os: linux
    Python: '3.6'
    dist: xenial
  - os: linux
    Python: '3.7'
    dist: xenial
  - os: osx
    language: generic
```

Here we can see that Travis will spin up three separate instances, each running their respective OS and distributions. When you do something like this it is likely to complicate your installation process, as different operating systems have different installation processes depending on your dependencies. See the next section for advice on installing with shell scripts to accomplish this. 

### Complicated Installs

While Python is wonderful and very flexible, building a reliable environment can be quite difficult! This is especially true if you are using a particular package many of us are familiar with - `GDAL`.

If you have a more complex environment to set up, or are running your tests on multiple environments then you will likely want to setup simple shell scripts for installing and testing. Shell scripts give you far more flexibility when it comes to creating your Travis environment. They aren't quite as easy to setup as simply using Travis' built in install and test commands, however they give you a lot of control. Examples for a setup like this can be found <a href="https://github.com/wino6687/blogci/tree/master/travis_examples/script_install_example/.travis" target="_blank">here</a>.

**Note**: It is always possible to change the way you are building your Travis environments later, so there is no harm starting with one option and converting later. It is a small time investment to change your Travis configuration.

## GitHub Companion Guide 

There are several links to a GitHub repository that contains examples for this post. This repo is set up as a Python module itself called “my_module”. In the main repo, you will see this structure: 

```
.
├── README.md
├── my_module
│   ├── __init__.py
│   ├── my_module.py
│   └── tests
│       └── test_module.py
├── requirements.txt
├── setup.py
└── travis_examples
    ├── mock_server_example
    │   └── mock_server.py
    └── script_install_example
        └── travis.yml
```

### Important Notes for Repo

* Every Python module needs a `setup.py` file; our module is very basic, so it only runs `setuptools` to find the local package. 
* Your `.travis.yml` file is set to install dependencies using `pip` and a `requirements.txt` file. 
  * If you would rather use Anaconda, refer to their <a href="https://docs.conda.io/projects/conda/en/latest/user-guide/tasks/use-conda-with-travis-ci.html" target="_blank">documentation</a> for installing in Travis.
* In order to view this repo’s Travis outputs, click on the <a href="https://github.com/wino6687/blogci/commits/master" target="_blank">commits</a> tab, and click on the green check mark (which signifies passing tests) then select “details”.

## Wrap Up

You now have all of the tools to begin ensuring that your Python project will be maintainable well into the future. While we have provided several examples for you, there is no replacement for reading the documentation for each framework we are using. Below I have linked most of the relevant documentation that should help guide you through any troubleshooting you may still need after reading this article.

While it takes a decent amount of work up front, setting up a robust system for writing maintainable and deployable code will benefit you in the long run. You will thank yourself for doing it later, and each time you go through this process it will get faster to implement. 

## Documentation

* <a href="https://pytest.org/en/latest/" target="_blank">Pytest</a> 
* <a href="https://docs.codecov.io/docs" target="_blank">Codecov</a>
* <a href="https://docs.travis-ci.com/" target="_blank">Travis-CI</a> 
* <a href="https://black.readthedocs.io/en/stable/the_black_code_style.html" target="_blank">Black</a>
* <a href="http://flake8.pycqa.org/en/latest/" target="_blank">Flake8</a>
