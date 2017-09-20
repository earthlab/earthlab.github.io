---
layout: single # the template to use to build the page
authors: ['author one', 'author one'] # add one or more authors as a list - this will populate after make builds the author files if authors don't exist in the md files it will be blank until then
category: courses # the category of choice - for now courses
title: 'Template course lessons - Descriptive title here' # title should be concise and descriptive
attribution: 'Any attribute text that is required' # if we want to provide attribution for someone's work...
excerpt: 'Learn how to .' # one to two sentence description of the lesson using a "call to action - if what someone will learn for SEO"
dateCreated: 2017-09-12  # when the lesson was built
modified: '2017-09-19' # will populate during knitting
nav-title: 'Git at the command line' # this is the text that appears on the left hand side bar describing THIS lesson 1-3 words max
sidebar: # leave this alone!!
  nav:
module: "intro-version-control-git" # this is the "Course" or module name. it needs to be the same for all lessons in the workshop
permalink: /courses/intro-version-control-git/what-is-version-control2/ # permalink needs to follow the structure coursename - lesson name using slugs
author_profile: false
order: 4 # the order in which to render the lessons on the side bar
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


This tutorial reviews how to add and commit changes to a Git repo.

<div id="objectives" markdown="1">
# Learning Objectives
At the end of this activity, you will be able to:

* Add new files or changes to existing files to your repo.
* Document changes using the `commit` command with a message describing what has changed.
* Describe the difference between `git add` and `git commit`.
* Sync changes to your local repository with the repostored on GitHub.com.
* Use and interpret the output from the following commands:
  + `git status`
  + `git add`
  + `git commit`
  + `git push`

****

#### Additional Resources:

* <a href="http://rogerdudler.github.io/git-guide/files/git_cheat_sheet.pdf" target="_blank"> Diagram of Git Commands </a>
-- this diagram includes more commands than we will
learn in this series but includes all that we use for our standard workflow.
* <a href="https://help.github.com/articles/good-resources-for-learning-git-and-github/" target="_blank"> GitHub Help Learning Git resources </a>
* <a href="https://git-scm.com/book/en/v1/Git-Branching-What-a-Branch-Is" target="_blank"> Information on branches in Git</a>
-- we do not focus on the use of branches in Git or GitHub, however, if you want
more information on this structure, this Git documentation may be of use.

</div>

In the previous lesson, we created a markdown (`.md`) file in our forked version
of the `DI16-NEON-participants` central repo. In order for Git to recognize this
new file and track it, we need to:

1. Add the file to the repository using `git add`.
2. Commit the file to the repository as a set of changes to the repo (in this case, a new
  document with some text content) using `git commit`.
3. Push or sync the changes we've made locally with our forked repo hosted on github.com
using `git push`.


<figure>
	<a href="{{ site.baseurl }}/images/pre-institute-content/pre-institute2-git/git-add-commit.png">
	<img src="{{ site.baseurl }}/images/pre-institute-content/pre-institute2-git/git-add-commit.png"></a>
	<figcaption>After a Git repo has been cloned locally, you can now work on
	any file in the repo. You use <code>git pull</code> to pull changes in your
	fork on github.com down to your computer to ensure both repos are in sync.
	Edits to a file on your computer are not recognized by Git until you
	"add" and "commit" them as tracked changes in your repo.
	Source: National Ecological Observatory Network (NEON) </a>
	</figcaption>
</figure>


## Check Repository Status -- git status

Let's first run through some basic commands to get going with Git at the command
line. First, it's always a good idea to check the status of your repository.
This allows us to see any changes that have occurred.

Do the following:

1. Open bash if it's not already open.
2. Navigate to the `DI16-NEON-participants` repository in bash.
3. Type: `git status`.

The commands that you type into bash should look like the code below:

    # Change directory
    # The directory containing the git repo that you wish to work in.
    $ cd ~/Documents/GitHub/neon-data-repository-2016

    # check the status of the repo
    $ git status

Output:

    On branch gh-pages
    Your branch is up-to-date with 'origin/gh-pages'.
    Changes not staged for commit:
     (use "git add <file>..." to update what will be committed)
     (use "git checkout -- <file>..." to discard changes in working directory)

    Untracked files:
     (use "git add <file>..." to include in what will be committed)

    _posts/ExampleFile.md


Let's make sense of the output of the `git status` command.

* `On branch gh-pages`: This tells us that we are on the gh-pages branch of the
repo. Don't worry too much about branches just yet. We will work on the gh-pages branch
throughout the Data Institute.
* `Changes not staged for commit:` This lists any file(s) that is/are currently
being tracked by Git but have new **changes** that need to be added for Git to track.
* `Untracked file:` These are all **new files** that have never been added to or
tracked by Git.

Use `git status` anytime to view any untracked changes that have occurred, what
is being tracked and what is not currently being tracked.


## Add a File - git add

Next, let's add the Markdown file containing our bio and short project summary
using the command `git add FileName.md`. Replace **FileName.md** with the name
of your markdown file.

    # add a file, so that changes are tracked
    $ git add ExampleBioFile.md

    # check status again
    $ git status

    On branch gh-pages
    Your branch is up-to-date with 'origin/gh-pages'.
    Changes to be committed:
     (use "git reset HEAD <file>..." to unstage)

    	new file:  _posts/ExampleBioFile.md


**Understand the output:**

*  `Changes to be committed:` This lists the new files or files with changes that
have been added to the Git tracking system but need to be **committed** as actual changes
in the git repository history.

<i class="fa fa-star"></i> **Data Tip:** If you want to delete a file from your
repo, you can do so using `git rm file-name-here.fileExtension`. If you delete
a file in the finder (MAC) or Windows Explorer, you will still have to use
`git add` at the command line to tell git that a file has been removed from the
repo, and to track that "change".
{: .notice }

## Commit Changes - git commit

When we add a file in the command line, we are telling Git to recognize that
a change has occurred. The file moves to a "staging" area where Git
recognizes a change has happened but the change has not yet been formally
documented. When we want to permanently document those changes, we
`commit` the change. A single commit will work for all files that are currently
added to and in the Git staging area (anything in green when we check the status).

### Commit Messages

When we commit a change to the Git version control system, we need to add a **commit
message**. This message describes the changes made in the commit. This commit
message is helpful to us when we review commit history to see what has changed
over time and when those changes occurred. Be sure that your message
covers the change.

<i class="fa fa-star"></i> **Data Tip:** It is good practice to keep commit messages to <50 characters.
{: .notice }


    # commit changes with message
    $ git commit -m “new example file for demonstration”

    [gh-pages e3cd622] new example file for demonstration
     1 file changed, 56 insertions(+), 4 deletions(-)
     create mode 100644 _posts/ExampleFile.md


**Understand the output:**
Each commit will look slightly different but the important parts include:

*  `gh-pages xxxxxxx` this is the unique identifier for this set of changes or
this commit. You will always be able to track this specific commit (this specific
 set of changes) using this identifier.
* `_ file change, _ insertions(+), _ deletion (-)` this tells us how many files
have changed and the number of type of changes made to the files including:
insertions, and deletions.

<i class="fa fa-star"></i> **Data Tip:**
It is a good idea to use `git status` frequently as you are working with Git
in the shell. This allows you to keep track of change that you've made and what
 Git is actually tracking.
{: .notice }

## Why Add, then Commit?

 <figure>
	<a href="{{ site.baseurl }}/images/pre-institute-content/pre-institute2-git/SWC_git-staging-area.svg">
	<img src="{{ site.baseurl }}/images/pre-institute-content/pre-institute2-git/SWC_git-staging-area.svg"></a>
	<figcaption> You can think of Git as taking snapshots of changes over the
life of a project. <code> git add</code> specifies what will go in a snapshot (putting things
 in the staging area), and <code> git commit </code> then actually takes the snapshot and
 makes a permanent record of it (as a commit). Image and caption source:
<a href="http://swcarpentry.github.io/git-novice/04-changes.html" target="_blank"> Software Carpentry</a>
	</figcaption>
</figure>

To understand what is going on with `git add` and `git commit` it is important
to understand that Git has a staging area that we add items to with `git add`.
Changes are not actually documented and permanently tracked until we commit them. This allows
us to commit specific groups of files at the same time if we wish. For instance,
we may decide to add and commit all R scripts together. And Markdown files in another,
separate commit.

## Transfer Changes (Commits) from a Local Repo to a GitHub Repo - git push

When we are done editing our files and have committed the changes locally, we
are ready to transfer or sync these changes to our forked repo on github.com. To
do this we need to `push` our changes from the local Git version control to the
remote GitHub repo.

To sync local changes with github.com, we can do the following:

1. Check the status of our repo using `git status`. Are all of the changes added
and committed to the repo?
2. Use `git push origin gh-pages`. `origin` tells Git to push the files to the
originating repo which in this case - is our fork on github.com which we originally
cloned to our local computer. `gh-pages` is the repo branch that you are
currently working on.

<i class="fa fa-star"></i> **Data Tip:**
Note about branches in Git: We won't cover branches in these tutorials, however,
a Git repo can consist of many branches. You can think about a branch, like
an additional copy of a repo where you can work on changes and updates. For the
 Data Institute, we will always use the gh-pages branch which allows us to quickly
 place content online (more to come about this at the Institute!). The default
  branch for a Git repo is called  "master".
{: .notice }

Let's push the changes that we made to the local version of our Git repo to our
fork, in our github.com account.

    # check the repo status
    $ git status

    On branch gh-pages
    Your branch is ahead of 'origin/gh-pages' by 1 commit.
      (use "git push" to publish your local commits)

    # transfer committed changes to the forked repo
    git push origin gh-pages

    Counting objects: 1, done.
    Delta compression using up to 4 threads.
    Compressing objects: 100% (6/6), done.
    Writing objects: 100% (6/6), 1.51 KiB | 0 bytes/s, done.
    Total 6 (delta 4), reused 0 (delta 0)
    To https://github.com/mjones01/DI16-NEON-participants.git
       5022aca..e3cd622  gh-pages -> gh-pages


NOTE: you may be asked for your username and password! This is your github.com
username and password.

**Understand the output:**

* Pay attention to the repository URL - the "origin" is the
repository that the commit was pushed to, here `https://github.com/mjones01/DI16-NEON-participants.git`.
Note that because this repo is a fork, your URL will have your GitHub username
in it instead of "mjones01".


<i class="fa fa-star"></i> **Bonus Tip:** You can use Git and connect to GitHub
directly in the RStudio interface. If interested, read
<a href="http://www.r-bloggers.com/rstudio-and-github/" target="_blank">this R-bloggers How-To</a>.
{: .notice}

## View Commits in GitHub

Let’s view our recent commit in our forked repo on GitHub.

1. Go to github.com and navigate to your forked Data Institute repo - **DI16-NEON-participants**.
2. Click on the **commits** link at the top of the page.
3. Look at the commits - do you see your recent commit message that you typed
into bash on your computer?
4. Next, click on the **<>CODE** link which is ABOVE the commits link in github.
5. Is the Markdown file that you added and committed locally at the command
line on your computer, there in the same directory (**participants/pre-institute2-git**) that you saved it on your
laptop?

 <figure>
	<a href="{{ site.baseurl }}/images/pre-institute-content/pre-institute2-git/Git-ForkScreenshot-file.png">
	<img src="{{ site.baseurl }}/images/pre-institute-content/pre-institute2-git/Git-ForkScreenshot-file.png"></a>
	<figcaption>An example .md file located within the
	<strong> participants/pre-institute2-git </strong> of a Data Institute repo fork.
Source: National Ecological Observatory Network (NEON)
	</figcaption>
</figure>

## Is Your File in the NEON Central Repo, Yet?
Next, do the following:

1. Navigate to the NEON central
<a href="https://github.com/NEON-WorkWithData/DI16-NEON-participants" target="_blank">NEON-WorkWithData/DI16-NEON-participants</a>
repo. (The easiest method to do this is to click the link at the top of the page under your repo name).
2. Look for your file in the same directory. Is your new file there? If not, why?

Remember the structure of our workflow.

We’ve added changes from our local
repo on our computer and pushed them to our fork on github.com. But this fork
is in our individual user account, not NEONS. This fork is
**separate from** the central repo. Changes to a fork in our github.com account
 do not automatically transfer to the central repo. We need to sync them! We will
 learn how to sync these two
repos in the next tutorial [Git 06: Syncing GitHub Repos with Pull Requests]({{ site.baseurl}}//tutorial-series/pre-institute2/git06).

## Summary workflow - Committing Changes

On your computer, within your local copy of the Git repo:

* Create a new markdown file and edit it in your favorite text editor.

On your computer, in shell (at the command line):

* `git status`
* `git add FileName`
* `git status` - make sure everything is added and ready for commit
* `git commit -m “messageHere”
* `git push origin gh-pages`

On the github.com website:

* Check to make sure commit is added.
* Check to see if the file that you added is visible online in your Git repo.
