---
layout: single
title: 'Guided Activity on Git/Github.com For Collaboration'
excerpt: "This lesson teaches you how to collaborate with others in a project, including tasks such as notifying others that an assigned task has been completed."
authors: ['Jenny Palomino', 'Max Joseph', 'Leah Wasser']
category: [courses]
class-lesson: ['git-github-collaboration']
permalink: /courses/earth-analytics-bootcamp/git-github-collaboration/guided-activity-collaboration/
nav-title: "Guided Activity on Git/Github.com For Collaboration"
dateCreated: 2018-07-25
modified: 2020-12-08
module-type: 'class'
class-order: 2
course: "earth-analytics-bootcamp"
week: 9
sidebar:
  nav:
author_profile: false
comments: true
order: 2
topics:
  reproducible-science-and-programming: ['git']
---
{% include toc title="In this lesson" icon="file-text" %}

<div class='notice--success' markdown="1">

## <i class="fa fa-graduation-cap" aria-hidden="true"></i> Learning Objectives

At the end of this activity, you will be able to:

* Explain the role of issues on `Github.com`
* Use `@` tagging to communicate with others about a project
* Close issues on `Github.com` via pull request
* Pull down others' changes to the original repository (i.e. from which you forked)


## <i class="fa fa-check-square-o fa-2" aria-hidden="true"></i> What You Need

Be sure you have completed the lessons on <a href="{{ site.url }}/courses/earth-analytics-bootcamp/git-github-version-control/">Git/GitHub.com for Version Control</a>.

You will need to **`fork` and `clone` a Github repository for this activity** to your earth-analytics-bootcamp directory: 

`https://github.com/earthlab-education/ea-bootcamp-hometowns`

Be sure to check your notifications on `Github.com` to ensure that you are receiving messages through `Github.com`. 

</div>


## Guided Activity on Collaboration

You have been tagged in an issue that needs to be addressed in the `ea-bootcamp-hometowns` repository. To see the details of the issue on `Github.com`, you can click on the `view it on Github` link in bottom of the the email you received.

On `Github.com`, issues are used to notify others of work that needs to be done or problems that need to be addressed, and issues can include tags to notify and communicate with specific `Github` users.

In the issue, you have been asked to create and contribute a `Jupyter Notebook` with some facts about your hometown (or some other city of your choosing) to the `ea-bootcamp-hometowns` repository. Additional details about what to include in your notebook are provided in the issue. 

Use `git add`, `git commit`, and `git push` to send the file to your fork on `Github.com`.

When you are ready to submit a pull request to the original repository (i.e. `https://github.com/earthlab-education/ea-bootcamp-hometowns`), follow the instructions in the sections below to:

1. notify the owner of the original respository that you have addressed the issue
2. close the issue via pull request


### Notify Others of Activity and Close Issues Via Pull Request

When your `Jupyter Notebook` file on your hometown (or chosen city) is ready, you will submit a pull request from your fork to the original repository. This time, you will include some more text in the message. 

In your message for the pull request, include the following:
* @jlpalomino in the message to notify me of your pull request.
* include `Fixes #issue-number` in the message to close the issue. 

The issue number has been automatically assigned by `Github.com` and is noted in the title of the issue that you were assigned (e.g. `#1`). 

Here is an example pull request message that lets `jlpalomino` know that a pull request is ready that specifically addresses issue `#1` listed in the original repository:

`@jlpalomino I have added the notebook titled jp-houston-tx-usa.ipynb. This issue has now been addressed. Fixes #1`

This message accomplishes the goal of notifying a specific `Github` user that you have addressed an issue. Furthermore, when the owner of the repository merges your pull request, the issue that you tagged with `#` will be automatically closed.

Note that the issue for which you have been tagged was created in the original repository by the owner of the repository (in this case, your course instructor). 

This is because though you will complete work in your forked repository, recall that you will submit a pull request to the original repository. Thus, the issue will be tracked in the original repository until the work is complete. 


### Pull Down Others' Changes 

After the owner of the original repository receives pull requests, they can review them and decide to merge them. In order for you to get the updated changes, you must `git pull` down those changes from the original repository. 

In the terminal, `cd` to your directory for your cloned repository `ea-bootcamp-hometowns` and run the following commands:

* `git pull https://github.com/earthlab-education/ea-bootcamp-hometowns`: to pull down the changes that have been made to the original repository owned by earthlab-education. After this command, the changes have been made been pulled down to your local clone.  

* `git push origin master`: to send these pulled changes back to your fork on `Github.com`. 

Your fork has now been updated with any changes merged to the original repository up to that point! 

If more changes are merged later to the original repository, you can run `git pull` again. 

<div class="notice--info" markdown="1">

## Additional resources

* <a href="https://blog.github.com/2013-05-14-closing-issues-via-pull-requests/" target="_blank">Close Issue via Pull Request</a>

* <a href="https://help.github.com/articles/creating-an-issue/" target="_blank">Create Issue on Github.com</a>

</div>

