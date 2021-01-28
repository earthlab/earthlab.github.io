---
layout: single
title: 'An Example of a Github Collaborative Workflow for Team Science'
excerpt: "GitHub.com can be used to store and access files in the cloud using GitHub repositories. Learn how to submit pull requests on GitHub.com to suggest changes to a GitHub repository."
authors: ['Leah Wasser', 'Jenny Palomino', 'Max Joseph']
category: [courses]
class-lesson: ['git-github-collaboration-tb']
permalink: /courses/intro-to-earth-data-science/git-github/github-collaboration/github-for-collaboration-open-science-workflow/
nav-title: "GitHub Collaborative Workflow"
dateCreated: 2019-10-02
modified: 2021-01-28
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
  - "/courses/earth-analytics-bootcamp/git-github-version-control/guided-activity-pull-request/"
---
{% include toc title="On This Page" icon="file-text" %}

<div class='notice--success' markdown="1">

## <i class="fa fa-graduation-cap" aria-hidden="true"></i> Learning Objectives

After completing this page, you will be able to:

* Describe a typical workflow associated with collaborating with group using GitHub.com
* Describe how issues and pull requests are used together to collaboratively manage tasks.

</div>

In the last lessons you have learned about:

* GitHub issues as they are used to track and discussion changes to code in a GitHub repo
* GitHub pull requests as they are used to submit changes to a repo that have been discussed in an issue
* GitHub mentions to notify collaborators who you want to review an issue or pull request

In this lesson, you will see the bigger picture of what a typical GitHub collaborative 
workflow looks like. The workflow presented below is a typical Open Source 
Software workflow that can and has been successfully applied to large scientific 
collaborations on GitHub.com. 

## An Example Workflow 

In the scenario laid out below, you are collaborating with 5 other colleagues
who live in different parts of the country or world on a code base to process
some spatial data. The code base lives in a repo on GitHub.com. You do not own 
the main repo so you will be working off of a fork of the main repo.

The main repository is called:

`https://github.com/main-repo/spatial-data-project`

To begin, you look at the code and try it out for the project. You realize that 
there is a bug in the code where the output data that it processed isn't in the correct format. You know how to fix this issue but want the OK from your collaborators
before you submit any change. 

* Step 1. You <a href="https://www.earthdatascience.org/courses/intro-to-earth-data-science/git-github/github-collaboration/github-issues-to-document-and-manage-repo-changes/">submit an ISSUE to the repo</a> that states the problem and how you proposed to fix it. You also MENTION two collaborators who will likely have feedback on your proposed change. 

<i class="fa fa-star"></i> **Data Tip:** even if you didn't know how to fix the issue you could still submit and issue about the problem to simply notify your collaborators that this was a problem. 
{: .notice--success}

After you submit your issue, two of your collaborators respond. Both agree that this is a problem and one suggests a way that you could approach making the fix to the code base. 
They suggest that you submit a PULL REQUEST to address the change to the code. 

* **Step 2. Fork and Clone:** Now that you have the OK from your collaborators to submit a change to the code, your work begins. <a href="{{ site.url }}/courses/intro-to-earth-data-science/git-github/version-control/fork-clone-github-repositories/">You: FORK the repo into your account - making a copy of the repo that you own and can make changes to directly. You then CLONE the repo to your local computer so you can more easily work on the code.</a> 

Your forked repo url is called:

`https://github.com/your-user-name/spatial-data-project`


* **Step 3: Modify the code locally on your computer**. As you are working locally, you add and commit changes to the code. Once you are happy with your changes. You use <a href="{{ site.url }}/courses/intro-to-earth-data-science/git-github/version-control/git-commands/">`git push` to push the changes back to your forked repo</a>. 

* **Step 4: Submit a pull request:** When you are happy with the changes you've made, you can <a href="{{ site.url }}/courses/intro-to-earth-data-science/git-github/github-collaboration/how-to-submit-pull-requests-on-github/">submit a Pull Request</a> back to the main repo. IMPORTANT: in your pull request be sure to 1. mention the original issue where the changes were discussed and 2. to MENTION the collaborators who you want to review the PR. 

Remember that this pull request will be made to this main repo:

`https://github.com/main-repo/spatial-data-project`

from your forked repo

`https://github.com/your-user-name/spatial-data-project`

* **Step 5: Review your own pull request:** Once you have opened up your pull request, you want to closely review your own work. Make sure that the changes that you can see on Github for each file are exactly what you wish to submit to the main repo. This step is important yet often overlooked. If you see any extra files or changes that you did not intend to submit, CLEAN THOSE UP before **MENTION**ing your collaborators for a review! You don't want to waste anyones time reviewing files that are incorrect!  

* **Step 6: Feedback on your PR** Your collaborators will likely have some feedback and changes that they want on your PR. They will likely leave you some line by line feedback with specific things that should be changed. At that point you will need to go back to your local clone, and make changes as they suggest.

<i class="fa fa-star"></i> **Data Tip:** sometimes collaborators will make suggested changes to your code directly in the Pull Request. If that happens, you may need to accept those changes and then do a **Reverse Pull Request** to update your forked repo from the main repo. 
{: .notice--success}

* **Step 7: Add More Changes to your PR** After you have worked on the changes locally, you will follow the same git add, commit and push. steps that you followed to submit the original Pull Request. The big difference is that because you already have a PR open, any change that you make to your fork, will automatically be added to your open pull request! Thus, you do NOT need to submit a new pull request!

Steps 6 and 7 may take a few rounds of iterations until everyone is happy with the changes. 

* **Step 8: Your PR is Merged into the Main Repo:** After all of your hard work, your PR is accepted and approved! The owners of the **main-repo** will merge your Pull Request into the main code base!

Once your code is merged, your work is done! 

<i class="fa fa-star"></i> **Data Tip:** When you are working collaboratively on a repo using forks, it is important to always make sure that your fork is synced with the main repository. This means that you will want to submit a reverse Pull Request to update your fork, and then pull down those changes locally using `git pull`.
{: .notice--success}


