---
layout: single
authors: ['author one', 'author one']
category: [courses]
title: 'Descriptive title here'
attribution: 'Any attribute text that is required'
excerpt: 'Learn how to .'
dateCreated: 2017-09-12
modified: '2017-09-20'
nav-title: 'Pull requests'
sidebar: # leave this alone!!
  nav:
module: "intro-version-control-git"
permalink: /courses/intro-version-control-git/pull-request/
author_profile: false
comments: true
order: 7
topics:
  reproducible-science-and-programming: ['git', 'version-control']
---

{% include toc title="In this lesson" icon="file-text" %}

<!--  This is the top block with the learning objectives (LO) -->
<div class='notice--success' markdown="1">

## <i class="fa fa-graduation-cap" aria-hidden="true"></i> Learning objectives
At the end of this activity, you will be able to:

* Submit a pull request to a repo suggesting changes

* Explain the concept of base fork and head fork.
* Know how to transfer changes (sync) between repos in GitHub.
* Explain why it is important to update a local repo before beginning edits.
* Update your local repository from your fork on GitHub.
* Create a Pull Request on the GitHub.com website.


## <i class="fa fa-check-square-o fa-2" aria-hidden="true"></i> What you need

Some description of what is required to complete this lesson if anything.
For lessons using git we'll link to the setup pages.

* [setup xxx]({{ site.url }}/courses/path-here/)
* [setup xxx]({{ site.url }}/courses/path-here/)

</div>

Yuu have now learned how to do the following:

1. Fork a repo in someone else's account to your github account
2. Clone this repo to your local computer
3. Edit copies of that cloned repo locally on your computer
4. Commit those edits to git and the repo
5. Push the edits or commits back to your fork


In this lesson, you'll learn how to submit a `pull request` to suggest that your
edits are included in another (the central Earth Lab) repo.


<i class="fa fa-star"></i> **Thought Question:**
Who owns the cloned version of the `14ers-git` repo on your computer??
{: .notice--success }


Once you've forked and cloned a repo, you are all setup to work on your project
locally, on your computer. You won't need to fork and clone the repo again.

<figure class="half">
	<a href="{{ site.url }}/images/workshops/version-control/git-fork-clone-flow.png">
	<img src="{{ site.url }}/images/workshops/version-control/git-fork-clone-flow.png" width="70%"></a>
	<a href="{{ site.url }}/images/workshops/version-control/git-push-pull-flow.png">
	<img src="{{ site.url }}/images/workshops/version-control/git-push-pull-flow.png" width="70%"></a>
	<figcaption>LEFT: You will fork and clone a repo <strong> ONCE </strong>. RIGHT: After you have forked
	and cloned a repo, you will update your fork from the central repository using
	a <strong> Pull Request.</strong> You will update your local copy of the repo
	(on your computer) using <code> git pull </code>. Notice that the workflow is
	similar in both images above, however the commands are different the first time
  you setup your repo in your github.com account and on your local computer!
 	Source: National Ecological Observatory Network (NEON) </a>
 </figcaption>
</figure>

In this tutorial, we will learn how to transfer or **sync** changes from your forked
repo in you github.com account to the central Earth Lab repo. **Syncing**
information between two repositories in GitHub is done using a
**pull request**.

<figure>
	<a href="{{ site.url }}/images/workshops/version-control/git-push-pr.png">
	<img src="{{ site.url }}/images/workshops/version-control/git-push-pr.png"></a>
	<figcaption>LEFT: To sync changes made and committed to the repo from your
	local computer, you will first <strong> push </strong> the changes from your
	local repo to your fork on github.com. RIGHT: Then, you will submit a
	<strong> Pull Request </strong> to update the central repository.
	Source: National Ecological Observatory Network (NEON) </a>
 </figcaption>
</figure>

The steps for syncing repos are as follows:

1. Update your fork from the central repo (`Pull Request`) on github.com.
2. Update your local copy of the repo (on your computer) from your fork (`git pull`).
3. Push changes from local repo to your fork on github.com (`git push`)
4. Suggest an update the central repo from your fork (`Pull Request`)

The order of steps above is important as it ensures that you incorporate any
changes that have been made to the Earth Lab central repository into your forked & local
repos prior to adding changes to the central repo. If you do not sync in this order,
you are at greater risk of creating a **merge conflict**.


### What's A Merge Conflict?

A merge conflict
occurs when two users edit the same part of a file at the same time. Git cannot
decide which edit was first and which was last, and therefore which edit should
be in the most current copy. Hence the conflict.

<figure>
	<a href="https://developer.atlassian.com/blog/2015/01/a-better-pull-request/merge-conflict.png">
	<img src="https://developer.atlassian.com/blog/2015/01/a-better-pull-request/merge-conflict.png"></a>
	<figcaption> Merge conflicts occur when the same part of a script or
	document has been changed simultaneously and Git can’t determine should be
	applied. Source: Atlassian
	</figcaption>
</figure>


Note: In the last tutorial, we taught you to push your edits immediately after committing changes,
so you would see those changes in your github.com repo. This workflow can work
sometimes - particularly if you are working on a new document that you know
no one else is working on. However, it is good practice to ensure your repo is
in sync with the central repo **before**, you begin editing a repo's content.

 <div class="notice" markdown="1">
 <i class="fa fa-star"></i> **Data Tip:**
 A pull request to another repo is similar to a "push". However it allows
 for a few things:

 1. It allows you to contribute to another repo without needing administrative
 privileges to make changes to the repo.
 2. It allows others to review your changes and suggest corrections, additions,
 edits, etc.
 3. It allows repo administrators control over what gets added to
 their project repo.

 The ability to suggest changes to ANY repo, without needing administrative
 privileges is a powerful feature of GitHub. In our case, you do not have privileges
 to actually make changes to the DI16-NEON-participants repo. However you can
 make as many changes
 as you want in your fork, and then suggest that NEON add those changes to their
 repo, using a pull request. Pretty cool!

 </div>

## Syncing Repos Using Pull Requests

The first step in syncing repos is to determine whether your repo is in sync with
(up to date with), behind or ahead of the central repo. If you go to your fork, in
github.com, you will notice that there is a message right below the branch
drop down that tells you the current repo's status relative to the repo from which
it was originally forked. This message does not show up on non-forked (what we
  are referring to as central) repos.


 <figure>
	<a href="{{ site.url }}/images/workshops/version-control/Git-ForkScreenshot-status.png">
	<img src="{{ site.url }}/images/workshops/version-control/Git-ForkScreenshot-status.png"></a>
	<figcaption> Screenshot of the header area on a fork of the NEON 2016
	Data Institute participants repository. Source: National Ecological Observatory
	Network (NEON)
	</figcaption>
</figure>

Notice in the screenshot above that there is a line that says:

`This branch is 2 commits behind NEON-WorkWithData:gh-pages`


**What this means:** This message tells us that this particular fork, which is located in the `mjones01/`
account, is **behind** the central institute participants repository from which
it was forked. If your repo is **behind** another repo, it means that
someone has made changes to the other repo that you do not have in your
repo. The two repos are **out of sync**.

We use a **pull request** (known as a **PR**) to sync two repos - however, a
single pull request only updates in one direction, so to fully sync two repos
which both have changes, you need to create two pull requests. We'll cover that,
next.

## Pull Requests in GitHub

### Update Your Fork from Central

*This section, with modifications, is borrowed from
<a href="https://guides.github.com/activities/hello-world/#pr" target="_blank"> the GitHub Hello World guide</a>.
They provide an animated version of these directions.*

To begin, let's ensure your forked repo is in sync with the central
**NEON-WorkWithData/DI16-NEON-participants** repo. Do this by creating a new
pull request. Pull requests are the heart of collaboration on GitHub. When you
open a pull request, you’re proposing your changes and requesting that someone
review and pull in your contribution and merge them into their project.

Pull requests show diffs, or differences, of the content from both repos.
The changes, additions, and subtractions are shown in green and red.

#### Step 1 - Start Pull Request
To start a pull request, click the pull request button on the main repo page.

 <figure>
	<a href="{{ site.url }}/images/workshops/version-control/git-fork-pr-screenshot.png">
	<img src="{{ site.url }}/images/workshops/version-control/git-fork-pr-screenshot.png"></a>
	<figcaption> Location of the Pull Request button on a fork of the NEON 2016
Data Institute participants repo. Source: National Ecological Observatory
Network (NEON)
	</figcaption>
</figure>

Alternatively, you can click the Pull requests tab, then on this new page click the
"New pull request" button.

#### Step 2 - Choose Repos to Update
Select your fork to compare with NEON central repo. Here we want to sync all changes
in the **NEON-WorkWithData/DI16-NEON-participants** repo with your fork.
You must select the correct head and base to ensure that the changes are being
added to the correct repo.

**Head vs Base**

* **Base:** the repo that will be updated, the changes will be added to this repo.
* **Head:** the repo from which the changes come.

One way to remember this is that the “head” is always a*head* of the base, so
we must add from the head to the base.

When you begin a pull request, the head and base will auto-populate as follows:

* base fork: **NEON-WorkWithData/DI16-NEON-participants**
* head fork: **YOUR-USER-NAME/DI16-NEON-participants**

The above pull request configuration tells Git to sync (or update) the NEON repo
with contents **from your repo**. However we want to first **update your repo**
with any changes from the central NEON repo.

To switch the head and base:

* Change the **base fork** to: **YOUR-USER-NAME/DI16-NEON-participants**.
* Click “compare across forks”.
* Set the **head fork** to: **NEON-WorkWithData/DI16-NEON-participants**.


 <figure>
	<a href="{{ site.url }}/images/workshops/version-control/Git-PR-compareForks.png">
	<img src="{{ site.url }}/images/workshops/version-control/Git-PR-compareForks.png"></a>
	<figcaption> To update your repo you need to set the base fork to
   `YOUR-USER-NAME/DI16-NEON-participants`. Then click the "compare across forks"
   link. This will allow you to set the head fork to `NEON-WorkWithData/DI16-NEON-participants` .
Source: National Ecological Observatory Network (NEON)
	</figcaption>
</figure>

#### Step 3 - Verify Changes
When you compare two repos in a pull request page, git will provide an overview
of the differences (diffs) between the files. Look over the changes and make sure
nothing looks surprising.

 <figure>
	<a href="{{ site.url }}/images/workshops/version-control/Git-PRscreenshot-diffs.png">
	<img src="{{ site.url }}/images/workshops/version-control/Git-PRscreenshot-diffs.png"></a>
	<figcaption> In this split view, shows the differences between the older (LEFT)
	and newer (RIGHT) document. Deletions are highlighted in red and additions
	are highlighted in green.
	Pull request diffs view can be changed between unified and split (arrow).
	Source: National Ecological Observatory Network (NEON)
	</figcaption>
</figure>

#### Step 4 - Create Pull Request
If your repo is behind the central repo, the pull request button will be available.
Click the green Create Pull Request button.


#### Step 5 - Title Pull Request
Give your pull request a title and write a brief description of your changes.
When you’re done with your message, click Create pull request!

 <figure>
	<a href="{{ site.url }}/images/workshops/version-control/Git-PRscreenshot-titlePR-fork.png">
	<img src="{{ site.url }}/images/workshops/version-control/Git-PRscreenshot-titlePR-fork.png"></a>
	<figcaption> All pull requests titles should be concise and descriptive of
	the content in the pull request. More detailed notes can be left in the comments
	box.
	Source: National Ecological Observatory Network (NEON)
	</figcaption>
</figure>

Check out the repo name up at the top (in your repo and in screenshot above)
When creating the pull request you will be automatically transferred to the base
repo. Since your fork was the base (we are updating it), github will transfer
you to your github.com fork landing page.


#### Step 6 - Merge Pull Request
In this final step, it’s time to merge changes that were in the
**NEON-WorkWithData/DI16-NEON-participants** repo, with your forked repo. NOTE:
if there were no differences when you created the pull request, then you can
skip this step!

Click the green "Merge Pull Request" button to "accept" or merge the updated commits
in the central repo into your repo. Then click **Confirm Merge**.

NOTE: You are only able to merge a pull request in a repo that you have
permissions to!

We now synced our forked repo with the central NEON Repo. The next step is to
sync the repo found on our local computer with our fork on github.com.

## Update Local Repo

Using bash, navigate to your local copy of the **DI16-NEON-participants** repo.
Use `git pull` to sync your local repo with the forked GitHub.com repo.

First, navigate to the desired directory.

    $ cd ~/Documents/GitHub/DI16-NEON-participants

Second, update local repo using `git pull`.

    $ git pull

    remote: Counting objects: 25, done.
    remote: Compressing objects: 100% (15/15), done.
    remote: Total 25 (delta 16), reused 19 (delta 10), pack-reused 0
    Unpacking objects: 100% (25/25), done.
    From https://github.com/mjones01/DI16-NEON-participants
        74d9b7b..463e6f0  gh-pages   -> origin/gh-pages
    Auto-merging _posts/institute-materials/example.md


**Understand the output:** The output will change with every update, several
things to look for in the output:

* `remote: …`: tells you how many items have changed.
* `From https:URL`: which remote repository is data being pulled from. For the
Institute, it should always be your fork of the Institute repo.
* Section with + and - : this visually shows you which documents are updated
and the types of edits (additions/deletions) that were made.

Now that you've synced your local repo, let's check the status of the repo.

    $ git status

If you've updated your bio and capstone project .md file since we did this in
the previous tutorial, you will need to add and commit those changes.
Once you've done that, you can push the changes back up to your fork on
github.com.

    $ git push origin gh-pages

Now your commits are added to your forked repo on github.com.

### Add Changes to a Central Repo

The final step in this process is to submit a pull request to update the central
NEON repo with your changes. To do this, we repeat the pull request steps
above, however, we switch the base and head so that the transfer of data
occurs in the other direction - from our fork to the central repo.


<div id="challenge" markdown="1">

## Activity: Submit Pull Request for Week 2 Assignment

Submit a pull request containing the `.md` file that you created in this
tutorial-series series. Before you submit your PR, review the
<a href="/tutorial-series/pre-institute2/git-culmination">Week 2 Assignment page</a>.
To ensure you have all of the required elements in your .md file.

To submit your PR:

Repeat the pull request steps above, with the base and head switched. Your base
will be the NEON central repo and your HEAD will be YOUR forked repo:

* base fork: **NEON-WorkWithData/DI16-NEON-participants**
* head fork: **YOUR-USER-NAME/DI16-NEON-participants**

When you get to Step 6 - Merge Pull Request (PR), are you able to merge the PR?

* Finally, go to the NEON Central Repo page in github.com. Look for the Pull Requests
link at the top of the page. How many Pull Requests are there?
* Click on the link - do you see your Pull Request?

You can only merge a PR if you have permissions in the base repo that you are
adding to. At this point you don’t have contributor permissions to the NEON repo.
Instead someone who is a contributor on the repository will need to review and
accept the request.

</div>

## Workflow Summary

### Syncing Repos with Pull Requests
On github.com

* Update Your Fork from the Central Repo
  + Button: Create New Pull Request
  + Set base: your fork, set head: central Institute repo
  + Make sure changes are what you want to sync
  + Button: Create Pull Request
  + Add Pull Request title & comments
  + Button: Create Pull Request
  + Button: Merge Pull Request

In Bash

* Update your Local Repo & Push Changes
  + `git pull` - pull down any changes and sync the local repo with your fork
  + `git push origin gh-pages` - push your changes up to your fork

On github.com

* Update from Your Fork to the Central Repo
  * Button: Create New Pull Request
  * Set base: central Institute repo, set head: your Fork
  * Make sure changes are what you want to sync
  * Button: Create Pull Request
  * Add Pull Request title & comments
  * Button: Create Pull Request
  * Button: Merge Pull Request - only if you have contributor permissions



<i class="fa fa-star"></i> **Data Tip:**
Are you a Windows user and are having a hard time copying the URL into shell?
You can copy and paste in the shell environment **after** you
have the feature turned on. Right click on your bash shell window (at the top)
and select "properties". Make sure "quick edit" is checked. You should now be
able to copy and paste within the bash environment.
{: .notice}


## Additional Resources:

* <a href="http://rogerdudler.github.io/git-guide/files/git_cheat_sheet.pdf" target="_blank"> Diagram of Git Commands </a>
-- this diagram includes more commands than we will cover in this series but
includes all that we use for our standard workflow.
* <a href="https://help.github.com/articles/good-resources-for-learning-git-and-github/" target="_blank"> GitHub Help Learning Git resources.</a>
