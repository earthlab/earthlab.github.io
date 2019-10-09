---
layout: single
title: 'Learn How To Use GitHub to Collaborate on Open Science Projects'
excerpt: "GitHub is a website that supports git version control and also collaborative project management. Learn how to use git and GitHub to collaborate on projects in support of reproducible open science."
authors: ['Leah Wasser', 'Jenny Palomino']
category: [courses]
class-lesson: ['git-github-collaboration-tb']
permalink: /courses/intro-to-earth-data-science/git-github/github-collaboration/
nav-title: "GitHub for Collaboration"
dateCreated: 2019-10-02
modified: 2019-10-09
module-title: 'GitHub for Collaboration'
module-nav-title: 'GitHub for Collaboration'
module-description: 'GitHub is a website that supports git version control and also collaborative project management. Learn how to use git and GitHub to collaborate on projects in support of reproducible open science.'
module-type: 'class'
chapter: 8
class-order: 2
course: "intro-to-earth-data-science-textbook"
week: 3
sidebar:
  nav:
author_profile: false
comments: true
order: 1
topics:
  reproducible-science-and-programming: ['git']
redirect_from:
  - "/courses/earth-analytics-bootcamp/git-github-collaboration/"
---
{% include toc title="In This Chapter" icon="file-text" %}

<div class='notice--success' markdown="1">

## <i class="fa fa-ship" aria-hidden="true"></i> Chapter Eight - GitHub for Collaboration

GitHub is a website that supports version control using git. In this chapter,
you will learn how to use GitHub for both version control and as a collaboration
tool. Specifically you will learn about a well-known and used collaboration model
that is used in the open software community.

After completing this chapter, you will be able to:

* Explain what a pull request (PR) is and how PR's are used on GitHub.
* Explain what a GitHub issue is and explain how issues are used on GitHub.
* Create an issue in GitHub
* Create a Pull Request in GitHub.
* Describe the open source software collaboration model as it's implemented on GitHub.
* Explain the difference between Git and GitHub

## <i class="fa fa-check-square-o fa-2" aria-hidden="true"></i> What You Need

Be sure that you have completed the instructions on <a href="{{ site.url }}/workshops/setup-earth-analytics-python/setup-git-bash-conda/">Setting up Git, Bash, and Conda on your computer</a> to install the tools for your operating system (Windows, Mac, Linux).

You will also need a web browser and your **GitHub.com** login (username and password).

</div>

## Why Use GitHub For Science Collaboration?

In the previous chapter, you learned about **git** and **GitHub**. Recall that **git** is a
tool that is used to manage version control for various files. **GitHub** is a
website that runs **git** behind the scenes. The **GitHub** website also has additional
functionality that extends the functionality of **git**. This functionality allows
you to manage projects, coordinate with others on updates to code, text files
and other files in your repo. GitHub also facilitates sharing your code with the
world (OR with specific people if you'd prefer to work with a smaller group of people privately).

In the next few lessons, you will learn more about the various GitHub tools that you
can use to collaborate on projects.

## GitHub For Project Management and Collaboration

There are several tools that GitHub offers that you can use to support
collaborating on projects.

### 1. GitHub Pull Requests

The pull request is a way that you or a colleague can suggest code changes.
The pull request allows:
   * Your collaborators to see exactly what items were changed line by line in the code.
   * A group of people working on the code to view, review and comment on the code line by line.
   * You to document changes to your project which can also be clearly linked to issues that describe the need for those changes (see below).

The pull request is a great way to ensure that everyone is on the same page with
your edits before the changes are merged or combined into a designated repository.
Pull Requests are specific to the **GitHub** website.

<figure>
 <a href="{{ site.url }}/images/earth-analytics/git-version-control/github-diff-file.png">
 <img src="{{ site.url }}/images/earth-analytics/git-version-control/github-diff-file.png" alt="This screenshot shows a diff associated with a pull request. On the LEFT you can see the text (highlighted with red) that was modified by the proposed pull request. The words that are dark red were the ones that were deleted. On the RIGHT you can see the text (in green) that represents the proposed changes. The words that are darker green were added. In this example, the word **earthpy** was replaced with **matplotcheck** in the contributing.rst file of the repo"></a>
 <figcaption>This screenshot shows a diff associated with a pull request. On the LEFT you can see the text (highlighted with red) that was modified by the proposed pull request. The words that are dark red were the ones that were deleted. On the RIGHT you can see the text (in green) that represents the proposed changes. The words that are darker green were added. In this example, the word **earthpy** was replaced with **matplotcheck** in the contributing.rst file of the repo.
 </figcaption>
</figure>


### 2. GitHub Issues

Issues in GitHub are ways to document and discuss changes needed in a repository.
Issues are also ideal for managing changes in a project.
Issues are normally text (and code) that describe something that needs to be
addressed. An issue could be related to something that needs to be fixed in your
code or text. Issues can be assigned to one or more people to work on which
makes them useful for project management. You can keep track of who is working
on what items in the repository. Once an issue that needs to be addressed with
changes to the code in your repo is defined, you can then assign it to someone. At that point you have documentation of who is working on what task. Finally,
when the person assigned submits a pull request, they can link that back to the
original issues.

If you are familiar with IT (Information Technology) groups or computer help
desks, this is similar to submitting a ticket,
except for this ticket could be created collaboratively. Linking issues to Pull
Requests is good practice and will be discussed in more detail later in this
chapter.

There are other project management tools within GitHub that you can also use to
manage your project as it becomes more complex including milestones and even Trello like project boards. These more advanced project management topics will not
be discussed in this chapter but your are encouraged to check them out if you area interested in using GitHub to manage your open science projects.

<figure>
   <a href="{{ site.url }}/images/earth-analytics/git-version-control/git-push-pull-flow-neon.png">
   <img src="{{ site.url }}/images/earth-analytics/git-version-control/git-push-pull-flow-neon.png" alt="In a GitHub workflow, there is often a central repository. This is where the code or content maintainers keep the most up to date and 'live' versions of the code. Changes are suggested by users using a pull request workflow where someone makes a bunch of changes in a fork and then suggests that the maintainers add those changes to the central repository using a pull request. Source: Colin Williams, NEON"></a>
   <figcaption>In a GitHub workflow, there is often a central repository. This is where the code or content maintainers keep the most up to date and 'live' versions of the code. Changes are suggested by users using a pull request workflow where someone makes a bunch of changes in a fork and then suggests that the maintainers add those changes to the central repository using a pull request.  Source: Colin Williams, NEON
   </figcaption>
</figure>


### 3. GitHub Project Milestones

If you are working on a large project, you can create milestones which can be
 used to group sets of related issues together. Milestones can have deadlines
 associated with them.

<figure>
   <a href="{{ site.url }}/images/earth-analytics/git-version-control/github-milestones-abc-classroom.png">
   <img src="{{ site.url }}/images/earth-analytics/git-version-control/github-milestones-abc-classroom.png" alt="GitHub milestones allow you to track smaller sets of tasks within a larger GitHub project."></a>
   <figcaption>GitHub milestones allow you to track smaller sets of tasks within a larger GitHub project.
   </figcaption>
</figure>


### 4. Github Project Management Tools

You can also use **GitHub** to manage an entire project or set of projects. You can
setup boards similar to a tool like Trello to manage pull requests and milestones,
who is working on what and associated deadlines. For the time being the **GitHub**
project management tools will not be discussed in this textbook.


<figure>
   <a href="{{ site.url }}/images/earth-analytics/git-version-control/github-project-page.png">
   <img src="{{ site.url }}/images/earth-analytics/git-version-control/github-project-page.png" alt="GitHub allows you to track projects across a single repository OR across all of the repos in your organization or account."></a>
   <figcaption>GitHub allows you to track projects across a single repository OR across all of the repos in your organization or account.
   </figcaption>
</figure>


## The GitHub Issue, Pull Request Open Source Collaboration and Project Management Model: Putting It All Together

Over the course of this chapter, you will learn how to put together all of the
pieces of the pull request workflow. To break it down, it looks something like this:

1. Individuals within your team identify issues that need to be addressed
2. Someone (likely the owners of the repository) assigns team members to specific issues to work on.
3. Team members go out and work on their individual tasks.
4. When they are ready, team members submit a pull request (PR) to the main repo. That pull request is reviewed by team leaders (or whomever is assigned to review).
5. The reviewers may suggest changes to the code. If so, the PR submitters go back and work on the code some more. This process may continue until everyone is happy with the PR.
6. When the PR is approved by the reviewers, it will be merged into the code base.

All of the above steps may be repeated over and over through time as issues are identified and contributors submit changes. This, is the open source software
workflow and a workflow that many use to manage **GitHub** projects in general.

In this chapter, you will first learn about and practice submitting pull requests.
In the second half of the chapter you will be exposed to the full open source
collaboration workflow.

> TODO Put together an overview of what a pull request workflow looks like. add graphics. Posted on slack for ally to work on - note this graphic doesn't have to be done for this page to be published.



