---
layout: single
authors: ['Max Joseph', 'Leah Wasser']
category: courses
title: 'First steps with git: clone, add, commit, push'
attribution: ''
excerpt: 'Learn basic git commands, including clone, add, commit, and push.'
dateCreated: 2017-09-12
modified: '2017-09-19' # will populate during knitting
nav-title: 'Basic git commands'
sidebar:
  nav:
module: "intro-version-control-git"
permalink: /courses/intro-version-control-git/basic-git-commands/
author_profile: false
order: 3
topics:
  reproducible-science-and-programming: ['git', 'version-control']
comments: true
---

<!--Including the NEON materials on git commit... colin made some nice graphics... http://neon-workwithdata.github.io/neon-data-institute-2016/tutorial-series/pre-institute2/git05 -->

{% include toc title="In this lesson" icon="file-text" %}

<!--  This is the top block with the learning objectives (LO) -->
<div class='notice--success' markdown="1">

## <i class="fa fa-graduation-cap" aria-hidden="true"></i> Learning objectives
At the end of this activity, you will be able to:

* Create a new repository on GitHub
* Clone your repository to your local workstation
* Modify your repository and track changes with git
* Push your changes back to GitHub

## <i class="fa fa-check-square-o fa-2" aria-hidden="true"></i> What you need

You'll need a GitHub user account, access to a terminal running bash, and you'll also need to have git installed and  configured.

* [Setup instructions]({{ site.url }}/courses/example-course-name/intro-to-version-control/)

</div>


## Creating a new repository on GitHub

To begin, sign in to your user account on [GitHub](https://github.com/).
In the upper right corner, click the `+` sign icon, then choose **New repository**.
This will take you to a page where you can enter a repository name (this tutorial uses `test-repo` as the repository name), description, and choose to initialize with a README (a good idea!).
It is also a good idea to add a `.gitignore` file by selecting one of the languages from the drop down menu, though for this tutorial it will not be necessary.
Similarly, in practice you should choose a license to that people know whether and how they can use your code.
Once you have entered a repository name and made your selection, select **Create repository**, and you will be taken to your new repository web page.


## Cloning your repository to your local machine

Next, we will clone your newly created repository from GitHub to your local workstation.
From your repository page on GitHub, click the green button labeled **Clone or download**, and in the "Clone with HTTPs" section, copy the URL for your repository.

Next, on your local machine, open your bash shell and change your current working directory to the location where you would like to clone your repository.
For example, on a Unix based system, if I wanted to have my repository in my `Documents` folder, I would change directories as follows:


```bash
cd Documents
```

Once you have navigated to the directory where you want to put your repository, you can use `git clone` to copy your repository from GitHub, pasing in the URL that you previously copied:


```bash
git clone https://github.com/YOUR-USERNAME/YOUR-REPOSITORY
```

You should see output like:

```
Cloning into 'test-repo'...
remote: Counting objects: 5, done.
remote: Compressing objects: 100% (4/4), done.
remote: Total 5 (delta 0), reused 0 (delta 0), pack-reused 0
Unpacking objects: 100% (5/5), done.
Checking connectivity... done.
```

Note: The repository name and output numbers that you see on your computer, representing the total file size, etc, may differ from the example provided above.

To verify that your repository now exists locally, type `ls` in your terminal and you should see a directory with the same name as the repository that you created previously on GitHub.

## Tracking changes with `git add` and `git commit`

Next use `cd` to change directories into your repository:


```bash
cd test-repo
```

If you list all the files in this directory (using `ls -a`), you should see all of the files that exist in your GitHub repository:


```bash
ls -a
```

```
.git  .gitignore  LICENSE  README.md
```

<!--- THIS IS WHERE MAX LEFT OFF --->






### View the New Repo

Next, let's make sure the repository is created on your
computer in the location where you think it is.

At the command line, type `ls` to list the contents of the current
directory.

    # view directory contents
    $ ls

Next, navigate to your copy of the  data institute repo using `cd` or change
directory:

    # navigate to the NEON participants repository
    $ cd DI16-NEON-participants

    # view repository contents
    $ ls

    404.md			_includes		code
    ISSUE_TEMPLATE.md	_layouts		images
    README.md		_posts			index.md
    _config.yml		_site			institute-materials
    _data			assets			org

Alternatively, we can view the local repo `DI16-NEON-participants` in a finder (Mac)
or Windows Explorer (Windows) window. Simply open your Documents in a window and
navigate to the new local repo.

Using either method, we can see that the file structure of our cloned repo
exactly mirrors the file structure of our forked GitHub repo.

<i class="fa fa-star"></i> **Thought Question:**
Is the cloned version of this repo that you just created on your laptop, a
direct copy of the NEON central repo -OR- of your forked version of the NEON
central repo?
{: .notice .thought}


## Summary Workflow -- Create a Local Repo

In the github.com interface:

* Copy URL of the repo you want to work on locally

In shell:

* `git clone URLhere`

Note: that you can copy the URL of your repository directly from GitHub.


<div class="notice--info" markdown="1">

- [Creating a new repository on GitHub](https://help.github.com/articles/creating-a-new-repository/)
- [Git and GitHub learning resources](https://help.github.com/articles/git-and-github-learning-resources/)

</div>
