---
layout: single
title: 'Guided Activity on Undo Changes in Git'
excerpt: "This lesson teaches you how to undo changes in Git after they have been added or committed."
authors: ['Max Joseph', 'Leah Wasser', 'Jenny Palomino']
category: [courses]
class-lesson: ['git-github-collaboration']
permalink: /courses/earth-analytics-bootcamp/git-github-collaboration/guided-activity-undo-changes/
nav-title: "Guided Activity on Undo Changes in Git"
dateCreated: 2018-07-25
modified: 2020-12-08
module-title: 'Git/GitHub For Collaboration'
module-nav-title: 'Git/GitHub For Collaboration'
module-description: 'This tutorial teaches you how to undo changes using Git and helps you practice collaborating with others on GitHub.com.'
module-type: 'class'
class-order: 2
course: "earth-analytics-bootcamp"
week: 9
estimated-time: "1 hour"
difficulty: "beginner"
sidebar:
  nav:
author_profile: false
comments: true
order: 1
topics:
  reproducible-science-and-programming: ['git']
---
{% include toc title="In this lesson" icon="file-text" %}

<div class='notice--success' markdown="1">

## <i class="fa fa-graduation-cap" aria-hidden="true"></i> Learning Objectives

At the end of this activity, you will be able to:

* Undo changes before they have been staged (i.e. before `git add`)
* Unstage changed files after they have been staged (i.e. before `git commit`)
* Revert back to a previous commit if unwanted changes have been committed (i.e. before `git push`)


## <i class="fa fa-check-square-o fa-2" aria-hidden="true"></i> What You Need

Be sure you have completed the lessons on <a href="{{ site.url }}/courses/earth-analytics-bootcamp/git-github-version-control/">Git/GitHub.com for Version Control</a>.

You will need to **`fork` and `clone` a Github repository for this activity** to your earth-analytics-bootcamp directory: 

`https://github.com/earthlab-education/ea-bootcamp-hometowns`

</div>


This lesson walks you through how to undo changes:

1. before they've been staged (i.e. you have not yet run `git add` to add or stage them),
2. after they've been staged with `git add` (but before you run `git commit`) , and
3. after they've been committed to git (but before you have run `git push` to send your files to `Github.com`)


## Undoing Changes (Before Git Add)

If you have changed a file but have not yet run `git add`, you can undo changes very simply by running `git checkout`. 

The instructions for using git checkout to undo changes are described in the output of `git status`.

You can specify only one file to undo, for example `git checkout -- filename.ipynb`

Or you can undo all changes with:  `git checkout .`

Practice undoing changes below. 

First, modify the README.md file in your cloned repository `ea-bootcamp-hometowns`. 

You can do this by opening the file in a text editor (e.g. Sublime, Notepad, Gedit) and making/saving changes there. 

Or, you can use `bash` to add some text to the file. As always, be sure that you have `cd` to the current directory, in order to work with `git`. In this case, you are working in your cloned repository of `ea-bootcamp-hometowns` under your directory for `earth-analytics-bootcamp`.

See the example below (you do not need to type the comment after #):

```bash
# this is a comment in bash; code below will append text to the README.md file in your current working directory
echo 'Some random text for testing' >> README.md

```

After you have made an edit to the file, run `git status` in the Terminal to see that `git` has identified the change.

When you run `git status`, you will see the following output:

```
On branch master
Your branch is up-to-date with 'origin/master'.
Changes not staged for commit:
  (use "git add <file>..." to update what will be committed)
  (use "git checkout -- <file>..." to discard changes in working directory)

	modified:   README.md

no changes added to commit (use "git add" and/or "git commit -a")
```

The output from `git status` tells you that you can use `git checkout -- <file>` to discard changes to that file in your repo. 

So, if you don't like the changes made to the README.md file, you can revert back to the last committed version
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
Now, the contents of your README.md file has been reverted to the last saved or committed version. Thus, you have discarded the most recent changes. You can open the file in a text editor to confirm!

## Unstage Changes (After Git Add, But Before Git Commit)

Remember that once you add a set of changes to git using `git add`, the file has been staged. If a file has been changed and then staged via `git add`, then you need to use `git reset` to pull the most recently committed version of the file and undo the changes that you've made.

Fortunately, the output of `git status` gives us a hint for how to undo staged changes.

Make some new changes and run `git add` to stage the file (i.e. add to version control). Check the `git status` to see the status of your changes. 

See the example below (you do not need to type the comment after #):


```bash
# comment in bash; modify the README file
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

You can use `git reset HEAD filename` to unstage your changes. `HEAD` refers to the most recently committed version of the file:


```bash
git reset HEAD README.md
```

```
Unstaged changes after reset:
M	README.md
```


<i class="fa fa-star"></i> **Data tip:** HEAD refers to the most recent version of your file. You can also revert to an older version using HEAD~1, HEAD~2 etc. Read more about this on the <a href="http://swcarpentry.github.io/git-novice/05-history/" target="_blank">Software Carpentry git lessons website</a>.
{: .notice--success }


When you use `git reset`, your changes still exist in the file, but the file has been unstaged (i.e. the changes are not added to version control). 

So now, `git status` will display a message that there are changes that can be added. Thus, it is like you never ran `git add` at all.  


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

Now that you have changes that are not staged (i.e. not added), you can use `git checkout` again to undo those modifications. 

```bash
git checkout -- README.md

git status
```

Which returns that there are no changes in your repository:

```
On branch master
Your branch is up-to-date with 'origin/master'.
nothing to commit, working directory clean
```

`Git reset` is essentially the opposite of the command `git add`. It will undo the `git add`, and then you can `git checkout` again to remove the changes from the file. 

## Undo Commit (After Git Commit But Before Git Push

If you have added and committed changes to a file (i.e. `git add` and `git commit`), and want to undo those changes, then you can again use `git reset HEAD~` to undo your commit. 

Similar to the previous example, when you use `git reset`, the modifications will be unstaged.

To practice undoing commits, create a new file called `social-security.txt` either manually with a text editor, or using the `bash` command in the example below. 

See the example below (you do not need to type the comment after #):

```bash
# comment in bash; create an example file in your working directory that you would not want to push to Github.com
echo '123-45-6789' >> social-security.txt
```


Run `git add` to stage the file (i.e. add to version control) and then run `git commit` to commit the file. Check the `git status` to see the status of your changes. 

```bash
# comment in bash; add the file
git add social-security.txt

# comment in bash; commit the file
git commit -m 'New sensitive file.'

git status
```

Which returns:
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

Notice that now your file is no longer being tracked! At this point, you can decide whether to delete this file or simply leave the file as is in the repository without adding it to any future commits. 

You could also use this process to remove a commit that you decide is not complete, and then continue to modify this file and add/commit it later when you are done making changes.

Congratulations! You have now learned how to undo changes using `git` at various stages of the process before files get pushed to `Github.com`. 

### Ignore Sensitive Files

This section does not have a task, but it is a good reference for being able to choose files that you want Git to ignore (e.g. the `social-security.txt` file that you may want to keep in directory but not send to `Github.com`). 

If you do have sensitive files in a repository that you never want to track with
git, you can add those file names to a file called `.gitignore`, and git will
not track them. For instance, if you have a text file that contains sensitive information
such as a social security number called: social-secutity.txt that you don't want
to keep track of, you can add that file to a `.gitignore` file.

The .gitignore file lives in your cloned repository. If you do not already see that file in directory, you can create it manually or using the following `bash` command:

```bash
# comment in bash; create a .gitignore file if one doesn't already exist 
touch .gitignore

```

Open the this .gitignore file in a text editor and add the following lines to the file:

```
social-security.txt
```
Any files listed in this file will be ignored by git. You can also tell git to ignore entire directories by adding the directory name to the file.

<i class="fa fa-star"></i> **Data tip:** Learn more about using `.gitignore` files
to ignore files and directories in your `git` repository on the <a href="http://swcarpentry.github.io/git-novice/06-ignore/
" target="_blank">Software Carpentry Git Lessons</a>.
{: .notice--success }

<div class="notice--info" markdown="1">

## Additional Resources

* <a href="https://sethrobertson.github.io/GitFixUm/fixup.html" target="_blank"> On undoing, fixing, or removing commits in Git </a>

* <a href="https://git-scm.com/book/en/v2/Git-Basics-Undoing-Things" target="_blank"> Git basics - undoing things </a>

</div>

