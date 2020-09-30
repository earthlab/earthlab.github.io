---
layout: single
title: 'Setup Git Locally and Get Started with Git Commands for Version Control'
excerpt: "A version control system allows you to track and manage changes to your files. Learn how to setup git locally and use some basic Git commands."
authors: ['Jenny Palomino', 'Max Joseph', 'Leah Wasser']
category: [courses]
class-lesson: ['version-control-git-github']
permalink: /courses/intro-to-earth-data-science/git-github/version-control/git-commands/
nav-title: "Git Setup & Commands"
dateCreated: 2019-09-06
modified: 2020-09-30
module-type: 'class'
course: "intro-to-earth-data-science-textbook"
week: 3
sidebar:
  nav:
author_profile: false
comments: true
order: 3
topics:
  reproducible-science-and-programming: ['git']
redirect_from:
  - "/courses/earth-analytics-bootcamp/git-github-version-control/guided-activity-version-control/"
---

{% include toc title="On This Page" icon="file-text" %}

<div class='notice--success' markdown="1">

## <i class="fa fa-graduation-cap" aria-hidden="true"></i> Learning Objectives

After completing this page, you will be able to:

* **configure** git locally with your username and email
* Use **git** to `add` and `commit` changed files to version control. 
* Use **git** to `push` changed files from your local computer to the repository on **Github.com**.
* Use **git** to `pull` changed file from your repo to your local computer.

</div>


## Git and GitHub Workflow For Version Control

Previously, you learned how to `fork` **GitHub** repositories to make copies of other users' repositories, and you also learned how to download copies of (i.e. `clone`) **GitHub** repositories to your computer. On this page, you will learn to use **git** to implement the three important steps of version control:

* `git add` changed files to version control tracking.
* `git commit` the changed files to create a unique snapshot of the local repository.
* `git push` those changed files from the local copy of a repository to the cloud (**GitHub.com**).

You will also setup your git credentials locally.


## Configure git Username and Email On Your Computer

The first time that you use **git** on a computer, you will need to configure your **GitHub.com** username and email address. This information will be used to document who made changes to files in **git**. It is important to use the same email address and username that you setup on **GitHub.com**.

You can set your **Github.com** username in the **terminal** by typing: 
 
`$ git config --global user.name "username"`.

Next, you can set the email for your **Github.com** account by typing: 

`$ git config --global user.email "email@email.com"`.

Using the `--global` configuration option, you are telling **git** to use these settings for all **git** repositories that you work with on your computer. Note that you only have to configure these settings one time on your computer.  

*****

You can check your config settings for `user.name` and `user.email` using the following commands:

`git config user.name` which returns the username that you set previously

`git config user.email` which returns the email that you set previously

These configuration settings ensure that changes you make to repositories are attributed to your username and email. 

## Setup Your Preferred Text Editor

There are many text editors available for use with Git. Some such as Nano, Sublime and Vim are fully command line based. These are useful when you are working on remote servers and Linux and are often the default text editors for most computers. You may want to switch your git default text editor to a gui based editor to make things easier when you are getting started. 

<i class="fa fa-star" aria-hidden="true"></i> **Data Tip** <a href="https://docs.github.com/en/github/using-git/associating-text-editors-with-git" target="_blank">More on setting a default text editor from GitHub.</a> If the text editors below don't work for you, you can <a href="https://help.github.jp/enterprise/2.11/user/articles/associating-text-editors-with-git/" target="_blank">visit this page to learn more about other options such as Notepad++ for windows. </a>
{: .notice--success }

### Installing Atom as a Default Text Editor 

If you aren't sure what text editor you want to use, and you are on a MAC or PC <a href="https://atom.io/" target="_blank">we suggest Atom which is a powerful and free text editor that also has git and github support!</a> If you are on a MAC, before using Atom at the command line, you will need to install the shell command line tools. To get these tools installed

1. open up Atom 
2. Go to the Atom drop down at the very top of your screen. 
3. Select "Install Shell Commands"

The steps above will allow you to run `atom file-name-here` in bash to open the Atom text editor. Once you have Atom installed, you can run the command below in bash to set **Atom** to be the default text editor:

```bash
git config --global core.editor "atom --wait"
```

This command will set atom to be your default text editor for all operations. 

### Setting Nano as a Default Text Editor  For JupyterHub Environments 

If you are using a linux based JupyterHub (similar to what we use for our earth analytics course), we suggest setting the default text editor to **Nano**:

```bash
git config --global core.editor nano
```

This command will set nano to be your default text editor for all operations. 


## Check the Status of Changes Using Git Status

Once you start working, you can use the `git status` command to check what changes are being identified by **git**. To practice working with this command, use the **terminal** to navigate to your git practice repository: 

`$ cd practice-git-skillz` 

Next, run `git status`.

```bash
$ git status 

On branch master
Your branch is up to date with 'origin/master'.

nothing to commit, working tree clean
```

Notice that when you run `git status` it returns: **working tree clean**. This 
means that there are no changes to any files in your repo - YET. 

Next, open and make a small change to the `README.md` file in a text editor. Then, run 
the command `git status` to check that changes have been made to your file(s). 

```bash
git status
On branch master
Your branch is up-to-date with 'origin/master'.
Changes not staged for commit:
  (use "git add <file>..." to update what will be committed)
  (use "git checkout -- <file>..." to discard changes in working directory)

	modified:   README.md
    
no changes added to commit (use "git add" and/or "git commit -a")
```

The output from the `git status` command above indicates that you have modified a file 
(e.g. `README.md`) that can be added to version control.

### Adding and Committing File Changes To Version Control

To keep track of changes to this file using **git**, you need to:

1. first `git add` the changes to tracking (or staging area), and then
2. `git commit` the changes to version control. 

These two commands make up the bulk of many workflows that use **git** for version control:

* `git add`: takes a modified file in your working directory and places the modified version in a staging area for review.

* `git commit`: takes everything from the staging area and makes a permanent snapshot of the current state of your repository that has a unique identifier.



<figure>
   <a href="{{ site.url }}/images/earth-analytics/git-version-control/git-add-commit.png">
   <img src="{{ site.url }}/images/earth-analytics/git-version-control/git-add-commit.png" alt="Modified files are staged using git add. Then, following git commit, all files in the staging area are included in snapshot and become part of the repository's history, receiving a unique SHA-1 hash identifier. Source: Max Joseph, adapted from Pro Git by Chacon and Straub (2014)."></a>
   <figcaption> Modified files are staged using git add. Then, following git commit, all files in the staging area are included in snapshot and become part of the repository's history, receiving a unique SHA-1 hash identifier. Source: Max Joseph, adapted from Pro Git by Chacon and Straub (2014).
   </figcaption>
</figure>

## Add Changed Files Using git add

After making changes, you can add either an individual file or groups of files 
to version control tracking. To add a single file, run the command: 

`git add file-name.extension`

For example, to add the `README.md` file, you would use: 

`git add README.md`

You can also add all of the files that you have edited at the same time using: 

`git add .`


<i class="fa fa-star" aria-hidden="true"></i> **Data Tip** **use `git add .` with caution**. Be sure to review the results from `git status` carefully before using `git add .`. You do not want to accidentally add files to version control that you do not want to change in your **GitHub** repository! 
{: .notice--success }

## Commit Changed Files Using git commit

Once you are ready to make a snapshot of the current state of your repository (i.e. move changes from staging area), you can run `git commit`. The `git commit` command requires a commit message that describes the snapshot (i.e. changes) that you made in that commit. 

A commit message should outline what changed and why. These messages:

1. help collaborators and your future self understand what was changed and why.
2. allow you and your collaborators to find (and undo if necessary) changes that were previously made.

When you are not committing a lot of changes, you can create a short one line commit message using the -m flag as follows:

`git commit -m "Update title and author name in homework for week 3"`

Each commit is provided a unique identifier (SHA-1 hash) and includes all changes to files in the staging area when the commit was created (i.e. all files that had been added to staging using `git add`). 

## Push Changed Files to GitHub.com

So far you have only modified your local copy of the repository and completed 
a local commit to the repository. To update the files on **GitHub.com**, you 
need to `push` the changed files to the repository on **GitHub.com**.

You can push your changes to **GitHub** using the command:

`git push origin master`

Depending on your settings, you may then be prompted for your **Github.com** username and password. After you have pushed your commits to **GitHub.com**, visit your repository (e.g. `https://github.com/username/repository-name`) and notice that your changes are reflected there. 

Also notice that you have access to the full commit history for your repository!

<figure>
   <a href="{{ site.url }}/images/earth-analytics/git-version-control/access-commits-on-github.png">
   <img src="{{ site.url }}/images/earth-analytics/git-version-control/access-commits-on-github.png" alt="On the GitHub page of a repository, you can click on the Commits option (as shown in the image) to see a full list of commits that have been pushed to a repository."></a>
   <figcaption> On the GitHub page of a repository, you can click on the Commits option (as shown in the image) to see a full list of commits that have been pushed to a repository.
   </figcaption>
</figure>

<figure>
   <a href="{{ site.url }}/images/earth-analytics/git-version-control/list-commits-github.png">
   <img src="{{ site.url }}/images/earth-analytics/git-version-control/list-commits-github.png" alt="The full list of commits that have been pushed to a repository are available for you to see and review as needed on GitHub.com."></a>
   <figcaption> The full list of commits that have been pushed to a repository are available for you to see and review as needed on GitHub.com.
   </figcaption>
</figure>

## Pull Changed Files from GitHub.com to Your Cloned Repo

Above, you learned how to use `git clone` to create a copy of a repo on github.com
on your local computer. Running `git clone` will make a full copy of the git repo 
from github.com to your 
local computer. It includes all of the .git history information that you will need 
to track changes in your repo. **You only need to run git clone once**. After you have 
run git clone, you can us `git pull` to upate your repo.

You also learned how to add and commit changes using `git add` and `git commit`.

The workflow above assumed that you are always making changes locally and then pushing 
those changes back up to GitHub.com. Sometimes, however, you will need to pull 
down changes that were made to your repo, locally.

Some examples of when you may need to use `git pull` include:

1. When you may want to use git pull is to retrieve the feedback `.html` file added to your GitHub repo by your instructor
2. When you are working collaboratively (covered in the next chapter) and someone else modifies some of the code in your repo using a `pull request`. 

To update your repo with changes that are on GitHub.com you can do the following:

1. Open up bash and `cd` to the location of your git repo.
2. Once you are in the repo, run `git pull`. 

In the example below, there are no changes to any files. `git pull` returns `Already 
up to date`. 

```bash
(earth-analytics-python) COMPUTERNAME:bootcamp leahwasser$ cd bootcamp-2020-03-github-lwasser/
(earth-analytics-python) COMPUTERNAME:bootcamp-2020-03-github-lwasser leahwasser$ git pull
Already up to date.
(earth-analytics-python) COMPUTERNAME:bootcamp-2020-03-github-lwasser leahwasser$ 
```

Below is an example of using `git pull` when there are changes on github.com to pull
down. Notice that it gives you a summary of what files where changed (in the example
below this is the **README.md** file) and how many changes were made. 

```bash
(earth-analytics-python) COMPUTERNAME:bootcamp leahwasser$ cd bootcamp-2020-03-github-lwasser/
(earth-analytics-python) COMPUTERNAME:bootcamp-2020-03-github-lwasser leahwasser$ git pull
remote: Enumerating objects: 5, done.
remote: Counting objects: 100% (5/5), done.
remote: Compressing objects: 100% (3/3), done.
remote: Total 3 (delta 2), reused 0 (delta 0), pack-reused 0
Unpacking objects: 100% (3/3), done.
From github.com:earthlab-education/bootcamp-2020-03-github-lwasser
   7d45e2c..675d82e  master     -> origin/master
Updating 7d45e2c..675d82e
Fast-forward
 README.md | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)
(earth-analytics-python) CIRES-EL-DM-041:bootcamp-2020-03-github-lwasser leahwasser$ 
```

All of the changes that were made to your repo, will be pulled down to your local repo.

## View All Commits to Repository Using `git log`

You can also see a list of all commits to a repository (even those that have yet not been pushed to **GitHub.com**!) when working locally with the repository on your computer. 

To see a list of all commits, you can run the command:

`git log`

Which returns something like the following:

```bash
commit 6575476476hdjig946jksg95jywkg034mk6gkro6
Author: eastudent <eastudent@email.edu>
Date:   Mon Aug 5 15:30:54 2019 -0600

    Update title and author name in homework for week 3
```

Notice that `git log` provides a lot of useful information about the commit, including the unique identifier assigned to that snapshot, the message description provided during the commit (i.e. the message after `-m`) as well as the date, time, and author of the commit. 

<i class="fa fa-star" aria-hidden="true"></i> **Data Tip** `git log` by default returns a lot of information. You can view the log as single line entries with just the commit message using `git log --pretty=oneline`. `git log --
pretty=oneline | head -n 10` will show you the most recent 10 entries. IMPORTANT: when the log results appear in bash, you can use the space bar to scroll through the results. If you want to return to the command prompt, hit the `q` key (q for quit). Try it out! 
{: .notice--success }


## Tell Git to Ignore Files Using a .gitignore file

Sometimes there are files in your git repo that you do not want to be tracked. If you are on a MAC
these may be hidden files such as 

* **_DS_STORE** or
* .ipynb checkpoint files.

Other times you have sensitive files in a repository that you never want to track with **git** such as API credentials or other files containing personal information. 
You can add any file types or names to a `.gitignore` file. **git** will then not track them. This means that when you run `git add` or `git status`, it will not track any files listed in the `.gitignore` file. These files will thus never be added to **GitHub.com**.

Let's pretend that you have a file called `social-security.txt` that contains sensitive 
information. You can add that file to a **.gitignore** file. If the **.gitignore** file 
is not already present in the repository, you can create it manually using a text, or 
using the following `bash` command:

```bash
# Comment in bash
# Create a .gitignore file if one doesn't already exist 
touch .gitignore
```

<i class="fa fa-star" aria-hidden="true"></i> **Data Tip** Above, the bash command `touch` is used to create a new .gitignore file (this is only useful if the file does not already exist.
{: .notice--success }

Open this `.gitignore` file in a text editor and add the file names (with no other information needed) that you want **git** to ignore, for example:

```
social-security.txt
```

Any files listed in the `.gitignore` file will be ignored by **git**. You can also tell **git** to ignore directories by adding the directory name to the `gitignore` file (e.g. ignore a directory called `private-directory`):

```
private-directory/
```

<i class="fa fa-star"></i> **Data tip:** Learn more about using .gitignore files to ignore files and directories in your **git** repository on the <a href="http://swcarpentry.github.io/git-novice/06-ignore/
" target="_blank">Software Carpentry Git Lessons</a>.
{: .notice--success }


<div class="notice--warning" markdown="1">

## <i class="fa fa-pencil-square-o" aria-hidden="true"></i> Challenge - Create a New Text File In Your Repo

It's time to practice your git skills! Do the following:

1. If you haven't already, fork the `https://github.com/earthlab-education/practice-git-skillz` repo. 
2. Next, clone your fork of that repo using `git clone`
3. Open up the `README.md` file and make some changes to the text
4. Use `git add` and `git commit` to add and commit those changes
5. Finally push the changes up to github.com using `git push`

Now, go to the url where the repo is on Github.com - the path to the repo likely looks something like the path below:

(replace `your-github-username`  with your real github username!)

https://github.com/your-github-username/practice-git-skillz

Do you see your changes to the `README.md` file?

</div>
