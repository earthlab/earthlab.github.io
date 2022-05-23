---
layout: single
title: 'Undo Local Changes With Git'
excerpt: "A version control system allows you to track and manage changes to your files. Learn how to undo changes in git after they have been added or committed to version control."
authors: ['Jenny Palomino', 'Max Joseph', 'Leah Wasser']
category: [courses]
class-lesson: ['version-control-git-github']
permalink: /courses/intro-to-earth-data-science/git-github/version-control/git-undo-local-changes/
nav-title: "Undo Local Changes"
dateCreated: 2019-09-06
modified: 2021-03-30
module-type: 'class'
course: "intro-to-earth-data-science-textbook"
week: 3
sidebar:
  nav:
author_profile: false
comments: true
order: 5
topics:
  reproducible-science-and-programming: ['git']
redirect_from:
  - "/courses/earth-analytics-bootcamp/git-github-collaboration/guided-activity-undo-changes/"
---

{% include toc title="On This Page" icon="file-text" %}

<div class='notice--success' markdown="1">

## <i class="fa fa-graduation-cap" aria-hidden="true"></i> Learning Objectives

After completing this page, you will be able to:

* Undo changes before they've been staged (i.e. you have not yet run `git add` to add or stage them).
* Undo changes after they've been staged with `git add` (but before you run `git commit`) .
* Undo changes after they've been committed to the local repository (but before you have run `git push` to send your files to **Github.com**).

</div>


## Undoing Changes (Before git add)

If you have changed a file but have not yet run `git add`, you can undo changes by running `git checkout`. 
You can specify a specific file using:

`git checkout filename.ipynb`

Or you can undo all changes (including all changes that have not been committed!) with:  

`git checkout .`

Follow the steps below to practice undoing changes that occur before `git add`. 

First, modify the **README.md** file in a repository. You can do this by opening the file in a text editor such as  Atom and making/saving changes there. Or, you can use `bash` to add some text to the file using the `echo` command, as shown below. Be sure that you have `cd` to the directory for the repository. 

See the example below (you do not need to type the comment after #):

```bash
# This is a comment in bash; code below will append text 
# to the README.md file in your current working directory
echo 'Some random text for testing' >> README.md
```

After you have made an edit to the file, run `git status` in the **terminal** to see that **git** has identified the change.

When you run `git status`, you will see the following output:

```
$ git status
On branch main
Your branch is up-to-date with 'origin/main'.
Changes not staged for commit:
  (use "git add <file>..." to update what will be committed)
  (use "git checkout -- <file>..." to discard changes in working directory)

	modified:   README.md

no changes added to commit (use "git add" and/or "git commit -a")
```

The output from `git status` also tells you that you can use `git checkout -- <file>` 
to discard changes to that file in your repo. So, if you don't like the changes made 
to the **README.md** file, you can revert back to the last committed version using:


```bash
$ git checkout README.md
```

Run `git status` to check that the changes have been undone.

```bash
$ git status
```

Which returns:

```
On branch main
Your branch is up-to-date with 'origin/main'.
nothing to commit, working directory clean
```

The contents of your **README.md** file has been reverted to the last saved or 
committed version. Thus, you have discarded the most recent changes. You can open 
the file in a text editor to confirm!

## Unstage Changes (After git add, Before git commit)

Remember that once you add a set of changes to version control using `git add`, 
the changed file has been staged. If a changed file has been staged via `git add`, 
then you need to use `git reset` to pull the most recently committed version of the 
file and undo the changes that you've made.

Follow the steps below to practice undoing changes that occur after `git add` but 
before `git commit`. First, make a new change to README.md, and run `git add` to 
stage the changed file (i.e. add to version control). Check the `git status` to 
see the status of your changes. 

See the example below to make a change to file using `bash` (you do not need to type the comment after #):

```bash
# Comment in bash; modify the README file
$ echo 'Some more changes' >> README.md
```

Then, run `git add` to stage the file (i.e. add to version control) and run `git status` again.

```bash
$ git add README.md

$ git status
```

```
On branch main
Your branch is up-to-date with 'origin/main'.
Changes to be committed:
  (use "git reset HEAD <file>..." to unstage)

	modified:   README.md

```
Fortunately, the output of `git status` again gives us a hint for how to undo 
staged changes. You can use `git reset HEAD filename` to unstage your changes. 
`HEAD` refers to the most recently committed version of the file:


```bash
$ git reset HEAD README.md
```

Which returns:

```bash
Unstaged changes after reset:
M	README.md
```

<i class="fa fa-star"></i> **Data tip:** HEAD refers to the most recent version of your file. You can also revert to an older version using HEAD~1, HEAD~2 etc. Read more about this on the <a href="http://swcarpentry.github.io/git-novice/05-history/" target="_blank">Software Carpentry git lessons website</a>.
{: .notice--success }

When you use `git reset`, your changes still exist in the file, but the file has been unstaged (i.e. the changes no longer being tracked by version control). So now, `git status` will display a message that there are changes that can be added or staged to version control. Thus, it is like you never ran `git add` at all.  


```bash
$ git status
```

```
On branch main
Your branch is up-to-date with 'origin/main'.
Changes not staged for commit:
  (use "git add <file>..." to update what will be committed)
  (use "git checkout -- <file>..." to discard changes in working directory)

	modified:   README.md

no changes added to commit (use "git add" and/or "git commit -a")

```

Now that you have changes that are not staged (i.e. not tracked in version control), you can use `git checkout` again to undo those changes. 

```bash
$ git checkout README.md

$ git status
```

Which returns that there are no changes in your repository:

```
On branch main
Your branch is up-to-date with 'origin/main'.
nothing to commit, working directory clean
```

`Git reset` is essentially the opposite of the command `git add`. It will undo the `git add` to remove the changed file from version control, and then you can `git checkout` to undo the changes from the file. 

## Undo Commit (After git commit, Before git push)

If you have committed changes to a file (i.e. you have run both `git add` and `git commit`), and want to undo those changes, then you can use `git reset HEAD~` to undo your commit. 

Similar to the previous example, when you use `git reset HEAD~`, the modifications will be unstaged, and then you can use `git checkout` to undo the changes to the file.

To practice undoing commits, make another change to the README.md.

Then, run `git add` to stage the file (i.e. add to version control) and then run `git commit` to commit the file. Check the `git status` to see the status of your changes. 

```bash
# Comment in bash; modify the README file
$ echo 'Even more changes.' >> README.md

$ git commit -m 'Update description in README.md'

$ git status
```

Which returns:
```
On branch main
Your branch is ahead of 'origin/main' by 1 commit.
  (use "git push" to publish your local commits)
nothing to commit, working directory clean
```

If you do not actually want to `git push` this change to your repository on **GitHub.com**,  you can undo this commit with `git reset HEAD~`:


```bash
$ git reset HEAD~
```

Which returns:

```bash
Unstaged changes after reset:
M	README.md
```

When you run `git status` again, you will see that the changes have been unstaged from version control. 


```
On branch main
Your branch is up-to-date with 'origin/main'.
Changes not staged for commit:
  (use "git add <file>..." to update what will be committed)
  (use "git checkout -- <file>..." to discard changes in working directory)

	modified:   README.md

no changes added to commit (use "git add" and/or "git commit -a")
```

Notice that now your file has been unstaged, and thus, is no longer being tracked! 

At this point, you can run `git checkout README.md` to undo the changes to the file if you want. 

```bash
$ git checkout README.md

$ git status
```

```
On branch main
Your branch is up-to-date with 'origin/main'.
nothing to commit, working directory clean
```

You have now learned how to undo changes using **git** at various stages of the version control process before changed files get pushed to **Github.com**. 

