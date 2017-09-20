---
layout: single
authors: ['Max Joseph', 'Leah Wasser']
category: courses
title: 'First steps with git: clone, add, commit, push'
attribution: ''
excerpt: 'Learn basic git commands, including clone, add, commit, and push.'
dateCreated: 2017-09-12
modified: '2017-09-20' # will populate during knitting
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


{% include toc title="In this lesson" icon="file-text" %}

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

Alternatively, we can view the local repository in a finder (Mac), a Windows Explorer (Windows) window, or GUI file browser (Linux).
Simply open your file browser and navigate to the new local repo.

#### Note

The `.git` that shows up is actually a directory which will keep track of your changes. 
**Warning:** Do not edit the files in this directory manually!

Using either method, we can see that the file structure of our cloned repo mirrors the file structure of our forked GitHub repo.

Now, introduce some changes to your README.md file using any text editor, and in your terminal execute `git status`:


```bash
git status
```

```
On branch master
Your branch is up-to-date with 'origin/master'.
Changes not staged for commit:
  (use "git add <file>..." to update what will be committed)
  (use "git checkout -- <file>..." to discard changes in working directory)

	modified:   README.md

no changes added to commit (use "git add" and/or "git commit -a")
```

The output from `git status` indicates that we have modified the file `README.md`. 
To keep track of this change to our file, we need to first **add** the changes, then **commit** the changes. 

### Adding and committing

The command `git add` takes a modified file in your working directory and places the modified version in a staging area. 
The command `git commit` takes everything from the staging area and makes a permanent snapshot of the current state of your repository that is associated with a unique identifier. 
These two commands make up the bulk of many workflows that use git for version control, so it is important that you get some practice using them.

![](fig/git-add-commit.png)

When you add files or changes, you have the option to specify the filenames exactly, e.g., 


```bash
git add README.md
```

Or, if you are positive that you want to add all files that are new or modified, you have the option to use:


```bash
git add --all
```

But, do this with caution, as you do not want to accidentally add things like credential files, `.DS_Store` files, or history files. 

Once you are ready to make a snapshot of the current state of your repository, you can use `git commit`, and you'll need to write a **commit message** that describes the snapshot that you'll make. 
Typically a commit message should outline what changed and why. 
These messages act to help collaborators and your future self understand what you were trying to accomplish.
If you are not pushing many changes, then you may want to include a short one line commit message, which you can do with the `-m` flag from the terminal, e.g.:


```bash
git commit -m "Editing the README to try out git add/commit"
```

Alternatively, if you are committing many changes, or a small number of changes that require explanation, you'll want to write a more [detailed multi-line commit message](http://tbaggery.com/2008/04/19/a-note-about-git-commit-messages.html) in a text editor. 
If you have configured git to use your favorite text editor (via `git config --global core.editor your-fav-editor-here`), then you can open it to write your commit message via: 


```bash
git commit
```

Once you save and exit, the file that you created will be your commit message.


### Your turn

Go through a few rounds of modifications to your files, using `git add` to stage, and `git commit` to take a snapshot of your repository. 
For instance, you might try the following, adding and committing after each:

- create a new file
- modify existing files
- create a subdirectory with a file in it

After you've made a few commits, check out the output of the `git log` command. 
You should see the history of your repository, including all of the commit messages!


```bash
git log
```

```
commit 778a307bcc8350bddba47e96a940acafed55f5d8
Author: Fred Flinstone <flinstone@bedrock.com>
Date:   Tue Sep 19 18:38:28 2017 -0600

    adding a file in a subdirectory

commit f2b0ff9af905fa2792bf012982e10f0214148c70
Author: Fred Flinstone <flinstone@bedrock.com>
Date:   Tue Sep 19 16:50:59 2017 -0600

    fixing typo

commit e52dceab576c3b2491af25b5774cc56e65a40635
Author: Fred Flinstone <flinstone@bedrock.com>
Date:   Tue Sep 19 10:27:05 2017 -0600

    Initial commit
```


### Pushing your changes to GitHub

So far we have only modified our local copy of the repository. 
To have our changes reflected in the version of our repository on GitHub, we need to **push** our changes to that remote location. 

You can push your changes to GitHub with:



```bash
git push
```

You will then be prompted for your GitHub user name and password.
After you've pushed your commits, visit your repository on GitHub and notice that your changes are reflected there, and also that you have access to the full commit history for your repository!

<div class="notice--info" markdown="1">

- [Creating a new repository on GitHub](https://help.github.com/articles/creating-a-new-repository/)
- [Git and GitHub learning resources](https://help.github.com/articles/git-and-github-learning-resources/)

</div>
