---
layout: single # the template to use to build the page
authors: ['author one', 'author one'] # add one or more authors as a list - this will populate after make builds the author files if authors don't exist in the md files it will be blank until then
category: [courses] # the category of choice - for now courses
title: 'Template course lessons - Descriptive title here' # title should be concise and descriptive
attribution: 'Any attribute text that is required' # if we want to provide attribution for someone's work...
excerpt: 'Learn how to .' # one to two sentence description of the lesson using a "call to action - if what someone will learn for SEO"
dateCreated: 2017-09-12  # when the lesson was built
modified: '2017-09-13' # will populate during knitting
nav-title: 'Git at the command line' # this is the text that appears on the left hand side bar describing THIS lesson 1-3 words max
class-order: 1 # define the order that each group of lessons are rendered
week: 1 # ignore this for now. A week is a unit
sidebar: # leave this alone!!
  nav:
course: "intro-version-control-git" # this is the "Course" or module name. it needs to be the same for all lessons in the workshop
class-lesson: ['what-is-version-control'] # this is the lesson set name - it is the same for all lessons in this folder and handles the subgroups
permalink: /courses/intro-version-control-git/what-is-version-control2/ # permalink needs to follow the structure coursename - lesson name using slugs
author_profile: false
order: 2 # the order in which to render the lessons on the side bar
topics:
  reproducible-science-and-programming: ['RStudio'] # adjust based on what tags are appropriate
comments: true
---

<!--Including the NEON materials on git commit... colin made some nice graphics... http://neon-workwithdata.github.io/neon-data-institute-2016/tutorial-series/pre-institute2/git05 -->

{% include toc title="In this lesson" icon="file-text" %}

<!--  This is the top block with the learning objectives (LO) -->
<div class='notice--success' markdown="1">

## <i class="fa fa-graduation-cap" aria-hidden="true"></i> Learning objectives
At the end of this activity, you will be able to:

* Learning objective 1
* Learning objective 2
* Learning objective 3


## <i class="fa fa-check-square-o fa-2" aria-hidden="true"></i> What you need

Some description of what is required to complete this lesson if anything.
For lessons using git we'll link to the setup pages.

* [setup xxx]({{ site.url }}/courses/path-here/)
* [setup xxx]({{ site.url }}/courses/path-here/)

</div>


Start lesson....
This tutorial covers how to `clone` a github.com repo to your computer so
that you can work locally on files within the repo.

<div id="objectives" markdown="1">
# Learning Objectives
At the end of this activity, you will be able to:

* Be able to use the `git clone` command to create a local version of a GitHub
repository on your computer.

## Additional Resources:

* <a href="http://rogerdudler.github.io/git-guide/files/git_cheat_sheet.pdf" target="_blank"> Diagram of Git Commands </a>
-- this diagram includes more commands than we will cover in this series but
includes all that we use for our standard workflow.
* <a href="https://help.github.com/articles/good-resources-for-learning-git-and-github/" target="_blank"> GitHub Help Learning Git resources.</a>

</div>

## Clone - Copy Repo To Your Computer
In the previous tutorial, we used the github.com interface to fork the central NEON repo.
By forking the NEON repo, we created a copy of it in our github.com account.


<figure>
 <a href="{{ site.baseurl }}/images/pre-institute-content/pre-institute2-git/git_fork_emphasis.png">
 <img src="{{ site.baseurl }}/images/pre-institute-content/pre-institute2-git/git_fork_emphasis.png" width="70%"></a>
 <figcaption>When you fork a reposiotry on the github.com website, you are creating a
 duplicate copy of it in your github.com account. This is useful as a backup
 of the material. It also allows you to edit the material without modifying
 the original repository.
 Source: National Ecological Observatory Network (NEON) </a>
 </figcaption>
</figure>

Now we will learn how to create a local version of our forked repo on our
laptop, so that we can efficiently add to and edit repo content.

<figure>
 <a href="{{ site.baseurl }}/images/pre-institute-content/pre-institute2-git/git_clone.png">
 <img src="{{ site.baseurl }}/images/pre-institute-content/pre-institute2-git/git_clone.png" width="70%"></a>
 <figcaption>When you clone a repository to your local computer, you are creating a
 copy of that same repo <strong>locally </strong> on your computer. This
 allows you to edit files on your computer. And, of course, it is also yet another
 backup of the material!
 Source: National Ecological Observatory Network (NEON) </a>
 </figcaption>
</figure>


### Copy Repo URL

Start from the github.com interface:

1. Navigate to the repo that you want to clone (copy) to your computer --
this should be `YOUR-USER-NAME/DI16-NEON-participants`.
2. Click on the **Clone or Download** dropdown button and copy the URL of the repo.

 <figure>
	<a href="{{ site.baseurl }}/images/pre-institute-content/pre-institute2-git/Git-ForkScreenshot-clone.png">
	<img src="{{ site.baseurl }}/images/pre-institute-content/pre-institute2-git/Git-ForkScreenshot-clone.png"></a>
	<figcaption>The clone or download drop down allows you to copy the URL that
	you will need to clone a repository. Download allows you to download a .zip file
	containing all of the files in the repo.
	Source: National Ecological Observatory Network (NEON).
	</figcaption>
</figure>


Then on your local computer:

1. Your computer should already be setup with Git and a bash shell interface.
If not, please refer to the
<a href="{{ site.baseurl}}/tutorial-series/pre-institute0/ " target="_blank"> Institute setup materials </a>
before continuing.
2. Open bash on your computer and navigate to the local GitHub directory that
you created using the Set-up Materials.

To do this, at the command prompt, type:

    $ cd ~/Documents/GitHub

Note: If you have stored your GitHub directory in a location that is different
- i.e. it is not `/Documents/GitHub`, be sure to adjust the above code to
represent the actual path to the GitHub directory on your computer.

Now use `git clone` to clone, or create a copy of, the entire repo in the
GitHub directory on your computer.


    # clone the forked repo to our computer
    $ git clone https://github.com/neon/DI16-NEON-participants.git

<i class="fa fa-star"></i> **Data Tip:**
Are you a Windows user and are having a hard time copying the URL into shell?
You can copy and paste in the shell environment **after** you
have the feature turned on. Right click on your bash shell window (at the top)
and select "properties". Make sure "quick edit" is checked. You should now be
able to copy and paste within the bash environment.
{: .notice}


The output shows you what is being cloned to your computer.


    Cloning into 'DI16-NEON-participants.git'...
    remote: Counting objects: 3808, done.
    remote: Total 3808 (delta 0), reused 0 (delta 0), pack-reused 3808
    Receiving objects: 100% (3808/3808), 2.92 MiB | 2.17 MiB/s, done.
    Resolving deltas: 100% (2185/2185), done.
    Checking connectivity... done.
    $

Note: The output numbers that you see on your computer, representing the total file
size, etc, may differ from the example provided above.

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
