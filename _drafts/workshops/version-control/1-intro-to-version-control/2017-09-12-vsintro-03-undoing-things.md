---
layout: single
authors: ['Max Joseph', 'Leah Wasser']
category: courses
title: 'Introduction to undoing things in git'
attribution: ''
excerpt: 'Learn how to undo changes in git after they have been added or committed.'
dateCreated: 2017-09-12
modified: '2017-09-20' # will populate during knitting
nav-title: 'Undoing things'
sidebar:
  nav:
module: "intro-version-control-git"
permalink: /courses/intro-version-control-git/undoing-things/
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

This lesson assumes that you have a working git repository on your local workstation from the previous lesson.

* [Introduction to basic git commands]({{ site.url }}/courses/intro-version-control-git/basic-git-commands/)

</div>

This lesson describes how to undo changes before they've been staged with `git add`, after they've been staged with `git add`, and after they've been committed.

## Undoing unstaged changes

If a file has been changed, but these changes have not yet been staged with `git add`, then the modifications to the file can be undone using `git checkout`, as described in the output of `git status` following modification of an existing file (you can add some text to your README.md file):


```bash
# append "Some random text" to the README
echo 'Some random text' >> README.md

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

The output from `git status` tells us that we can use `git checkout -- <file>` to discard changes in the working directory.
So, if we don't like our changes, we can revert back to the last committed version of our README.md file via:


```bash
git checkout -- README.md

git status
```

```
On branch master
Your branch is up-to-date with 'origin/master'.
nothing to commit, working directory clean
```

Now, our README.md file is no longer modified, and we've discarded the previous changes.

![](fig/git-checkout.png)

## Unstaging staged changes

If a file has been changed and then staged via `git add`, then we must use `git reset` to pull the most recently committed version of the file.
Fortunately, the output of `git status` again gives us a hint for how to undo our staged changes:


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

So, we can use `git reset HEAD <file>` to unstage our changes:


```bash
git reset HEAD README.md
```

```
Unstaged changes after reset:
M	README.md
```

Interestingly, our changes still exist in the file, but the file has been effectively unstaged (or un-added if you prefer).

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

Now we have changes that are not staged, and you can use `git checkout` to undo those modifications.
So, `git reset` is essentially the opposite of the command `git add`.

When we specified that we wanted to reset to `HEAD`, we are saying that we want to go back to the most recent commit.
If you need to go back to a commit previous to the most recent (e.g., the second most recent), you can reference `HEAD~1` for the commit before `HEAD`, and `HEAD~2` for the commit before `HEAD~1`, and so on.

## Undoing a commit

If you have modified a file and committed, but realize later that you want to undo those committed changes (for example, if you accidentally committed your social security number), then you can again use `git reset HEAD~` to undo your commit, and your modifications will be unstaged as before:


```bash
# create a sensitive file
echo '123-45-6789' >> social-security.txt

# add it
git add --all

# commit
git commit -m 'Including my social security number on accident'

git status
```

```
On branch master
Your branch is ahead of 'origin/master' by 1 commit.
  (use "git push" to publish your local commits)
nothing to commit, working directory clean
```

Now we can undo this commit with `git reset HEAD~`:


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

And we can see that our file is no longer being tracked!
Also if you inspect the output of `git log`, you will notice that your previous commit is no longer part of the repository's history.

### Aside: ignoring sensitive files

If you do have sensitive files in a repository that you never want to track with git, you can add those file names to a file called `.gitignore`, and git will not track them.
For instance, if I didn't want to keep track of my social security number file, I could have a `.gitignore` file in the home directory of the repository such as:

```
# contents of the .gitignore file
social-security.txt
```

<div class="notice--info" markdown="1">

## Additional resources

- [On undoing, fixing, or removing commits in git](https://sethrobertson.github.io/GitFixUm/fixup.html#committed_really)
- [Git basics - undoing things](https://git-scm.com/book/en/v2/Git-Basics-Undoing-Things)

</div>
