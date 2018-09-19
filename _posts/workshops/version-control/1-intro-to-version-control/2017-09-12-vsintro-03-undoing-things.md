---
layout: single
authors: ['Max Joseph', 'Leah Wasser']
category: courses
title: 'Introduction to undoing things in git'
attribution: ''
excerpt: 'Learn how to undo changes in git after they have been added or committed.'
dateCreated: 2017-09-12
modified: '2018-09-10' # will populate during knitting
nav-title: 'Undoing things'
sidebar:
  nav:
module: "intro-version-control-git"
permalink: /workshops/intro-version-control-git/undoing-things/
author_profile: false
order: 4
topics:
  reproducible-science-and-programming: ['git', 'version-control']
comments: true
---


{% include toc title="In this lesson" icon="file-text" %}

<!--  This is the top block with the learning objectives (LO) -->
<div class='notice--success' markdown="1">

## <i class="fa fa-graduation-cap" aria-hidden="true"></i> Learning objectives

At the end of this activity, you will be able to:

* Undo changes before they have been staged
* Unstage modified files after they have been staged
* Revert back to a previous commit if unwanted changes have been committed

## <i class="fa fa-check-square-o fa-2" aria-hidden="true"></i> What you need

* A GitHub user account
* A terminal running bash, and
* Git installed and configured on your computer.

Follow the setup instructions here:

* [Setup instructions]({{ site.url }}/workshops/intro-version-control-git/)


</div>

This lesson describes how to undo changes:

1. before they've been staged (you haven't used `git add` yet to add or stage them),
2. after they've been staged with `git add`, and
3. after they've been committed to git.

## Undoing unstaged changes

If a file has been changed, but these changes have not yet been staged with
`git add`, then the changes can be undone using `git checkout`. The instructions
for using git checkout to undo changes are described in the output of `git status`.

Let's look at an example. First, let's modify the readme file by adding
some text to it at the command line.


```bash
# append "Some random text" to the README file in shell
echo 'Some random text' >> README.md

```
Next, type git status to see how that change impacted git


```bash
$ git status
```

In the example above, git status was run in the command line after a file
was edited. When you run git status, git will first provide the following
output:

```
On branch master
Your branch is up-to-date with 'origin/master'.
Changes not staged for commit:
  (use "git add <file>..." to update what will be committed)
  (use "git checkout -- <file>..." to discard changes in working directory)

	modified:   README.md

no changes added to commit (use "git add" and/or "git commit -a")
```

The output from `git status` tells you that you can use `git checkout -- <file>`
to discard changes to that file in your repo. So, if you don't like the changes
made to the README.md file, you can revert back to the last committed version
using:


```bash
git checkout -- README.md

git status
```

Which returns:

```
On branch master
Your branch is up-to-date with 'origin/master'.
nothing to commit, working directory clean
```

Now, the contents of your README.md file has been reverted to the last saved or
committed version and you've discarded the most recent changes.

<figure>
 <a href="{{ site.url }}/images/workshops/version-control/git-checkout.png">
 <img src="{{ site.url }}/images/workshops/version-control/git-checkout.png" alt = "Git checkout can undo unstaged changes by pulling the previous commit's version of a file from repository's history."></a>
 <figcaption>Git checkout can undo unstaged changes by pulling the
 previous commit's version of a file from repository's history.
 Source: Maxwell Joseph, adapted from Pro Git by Chacon and Straub (2014).
 </figcaption>
</figure>


<div class="notice--warning" markdown="1">

## <i class="fa fa-pencil-square-o" aria-hidden="true"></i> Challenge - use git checkout to undo changes
Let's see how git checkout works.

1. Make a few text changes to your `README.md` file. You can make these changes in shell using the example below OR your favorite text editor. Save your changes (if you're in a text editor).
2. Now go to bash if you aren't already there. Run `git status`
3. Undo the changes that you made using `git checkout`

</div>


## Unstaging staged changes

Remember that once you add a set of changes to git using `git add`, the file is then
staged. If a file has been changed and then staged via `git add`, then you
use `git reset` to pull the most recently committed version of the file and undo
the changes that you've made.

Fortunately, the output of `git status` gives us a hint for how to undo
our staged changes:


```bash
# modify the README file
echo 'Some more changes' >> README.md

git add README.md
git status
```

```
On branch master
Your branch is up-to-date with 'origin/master'.
Changes to be committed:
  (use "git reset HEAD <file>..." to unstage)

	modified:   README.md

```

You use `git reset HEAD <file>` to unstage our changes. `HEAD` refers to the most
recently committed version of the file:


```bash
git reset HEAD README.md
```

```
Unstaged changes after reset:
M	README.md
```


<i class="fa fa-star"></i> **Data tip:** HEAD refers to the most recent version of
your file. You can also revert to an older version using HEAD~1, HEAD~2 etc.
Read more about this on the <a href="http://swcarpentry.github.io/git-novice/05-history/" target="_blank">Software Carpentry git lessons website</a>.
{: .notice--success }


When you use git reset, your changes still exist in the file, but the file has been
unstaged (the changes are not added to git, yet).


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

Now that you have changes that are not staged, you can use `git checkout` to undo
those modifications. `Git reset` is essentially the opposite of the command `git add`.
It undoes the `add`.

<div class="notice--warning" markdown="1">

## <i class="fa fa-pencil-square-o" aria-hidden="true"></i> Challenge - use git reset then checkout to undo changes

Practice using git reset and git checkout.

1. Make a few text changes to your `README.md` file. You can make these changes in shell using the example below OR your favorite text editor. Save your changes (if you're in a text editor).
1. Now go to bash if you aren't already there. Run `git status`
1. Use `git add`  to stage your changes to the README.md file.
1. Undo the commit that you made using `git reset`. Then revert back to the previously committed version using `git reset`.

</div>

## Undoing a commit

If you have modified, added and committed changes to a file, and want to undo those
changes, then you can again use `git reset HEAD~` to undo your commit. Similar to
the previous example, when you use `git reset` the modifications will be unstaged.


```bash
# create a sensitive file
echo '123-45-6789' >> social-security.txt

# add it
git add --all

# commit
git commit -m 'Accidentally including my social security number in my file'

git status
```

```
On branch master
Your branch is ahead of 'origin/master' by 1 commit.
  (use "git push" to publish your local commits)
nothing to commit, working directory clean
```

Now you can undo this commit with `git reset HEAD~`:


```bash
git reset HEAD~

git status
```

```
On branch master
Your branch is up-to-date with 'origin/master'.
Untracked files:
  (use "git add <file>..." to include in what will be committed)

	social-security.txt

nothing added to commit but untracked files present (use "git add" to track)
```

Notice that now your file is no longer being tracked!

If you inspect the output of `git log`, you will notice that your previous
commit is no longer part of the repository's history.

### Ignore sensitive files

If you do have sensitive files in a repository that you never want to track with
git, you can add those file names to a file called `.gitignore`, and git will
not track them. For instance, if you have a text file that contains sensitive information
such as a social security number called: social-secutity.txt that you don't want
to keep track of, you can add that file to a `.gitignore` file.

The .gitignore file lives in the home directory of your repo.

```
# create a .gitignore file - only do this if one doesn't already exist
touch .gitignore

```

Now open the that file in a text editor and add the following lines below:

```
# contents of the .gitignore file
social-security.txt
```
Any files listed in this file will be ignored by git. You can also tell git to
ignore entire directories.



<i class="fa fa-star"></i> **Data tip:** Learn more about using `.gitignore` files
to ignore files and directories in your git repo on the <a href="http://swcarpentry.github.io/git-novice/06-ignore/
" target="_blank">Software Carpentry git lessons website</a>.
{: .notice--success }

<div class="notice--info" markdown="1">

## Additional resources

* <a href="https://sethrobertson.github.io/GitFixUm/fixup.html" target="_blank"> On undoing, fixing, or removing commits in Git </a>
* <a href="https://git-scm.com/book/en/v2/Git-Basics-Undoing-Things" target="_blank"> Git basics - undoing things </a>

</div>
