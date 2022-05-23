---
layout: single
title: 'Track, Manage and Discuss Project Changes and Updates Using GitHub Issues'
excerpt: "An issue is a GitHub project management tool that allows anyone to identify and discuss potential changes to a repo. Learn how to create and manage GitHub issues to support collaborative open reproducible science projects."
authors: ['Leah Wasser', 'Jenny Palomino', 'Max Joseph']
category: [courses]
class-lesson: ['git-github-collaboration-tb']
permalink: /courses/intro-to-earth-data-science/git-github/github-collaboration/github-issues-to-document-and-manage-repo-changes/
nav-title: "GitHub Issues"
dateCreated: 2019-10-02
modified: 2021-01-28
module-type: 'class'
course: "intro-to-earth-data-science-textbook"
week: 3
sidebar:
  nav:
author_profile: false
comments: true
order: 4
topics:
  reproducible-science-and-programming: ['git']
redirect_from:
  - "/courses/earth-analytics-bootcamp/git-github-version-control/guided-activity-pull-request/"
---
{% include toc title="On This Page" icon="file-text" %}

<div class='notice--success' markdown="1">

## <i class="fa fa-graduation-cap" aria-hidden="true"></i> Learning Objectives

After completing this page, you will be able to:

* Describe what an issue is as used on GitHub.com to collaborate
* Open an issue in a repository on GitHub.com

</div>

In the previous lesson, you learned about how pull requests can be used to suggest
changes to a project. These pull requests not only clearly document your changes,
they also allow for collaborators to review the changes and discuss things, prior
to them being merged into the main project repo. In this lesson you will learn about issues. Issues can be used to drive or define the content of pull requests. This
type of tracking makes managing a GitHub project with multiple collaborators
easier and more efficient.

In this lesson we are using the open source model of software contribution as a
basis for the workflow that we are describing.

## What is a GitHub Issue?

Issues in GitHub are text based descriptions of things that need to be addressed,
changed or worked in a project or GitHub repo. GitHub issues can help you manage
a collaborative project that you are working on with others. All that you need to
create an issue on GitHub is a GitHub login. Issues are written in plain text
using Markdown to format the content of the issue.

GitHub issues are an
excellent way to keep track of bugs and other items that need to be addressed in a project.

GitHub issues can be used to identify and track:

1. Bugs or problems with code in your repo. For example `this thing` doesn't work as expected.  
2. Things that are missing in your repo. For example perhaps something isn't documented correctly.
3. Enhancements or new functionality that is needed in the code.
4. Documentation updates.
5. General questions and discussion points that need to be considered by all collaborators
6. and more...

<figure>
   <a href="{{ site.url }}/images/earth-analytics/git-version-control/github-issues-earthpy.png">
   <img src="{{ site.url }}/images/earth-analytics/git-version-control/github-issues-earthpy.png" alt=""></a>
   <figcaption>A list of closed issue on a working GitHub repository. Notice a few things about each issue. 1. Each issue has a clear description of what needs to be addressed. 2. Each issue also is assigned to someone to work on. Task assignment allows you to manage projects and tasks across teams using GitHub. 3. Also notice that each issue has comments associated with it. Comments allow a team to coordinate efforts and discuss tasks before implementing them.
   </figcaption>
</figure>


## GitHub Issues Can Be Used to Manage Collaborative Projects and To Allow Both Coders and Non Coders to Contribute to a Project

GitHub issues are a way that anyone can identify problems with the code in your project. Not everyone is a programmer or a coder. But sometimes people are using your code and have questions, or find bugs. Issues are a way for others to contribute, regardless of their technical expertise.

## Use GitHub Issues To Manage Contributions to Your Project Submitted Using Pull Requests

While you can submit a pull request (PR) at any time, it is best practice to first
open an issue to discuss the change before submitted the PR. Opening an issue is ideal for project management as it allows you to keep track of:

1. what needs to be implemented on the project - bugs, enhancements, fixes
2. who is going to work on that task 
3. how the task will be implemented

Finally, when the person responsible for the task submits their PR, they will 
reference the issues and associated discussions that occurred before and while the work
was being done. This becomes a great record of effort on a group project.


### Best Practices for GitHub Issues

There are many best practices to consider when submitting issues to a repository. 
A few include:

* **Make The Issue Name Descriptive**: It is helpful to have descriptive issue titles that tell the code owners what the issue is about. Descriptive titles become particularly important if there are many issues in a repo.
* **Create an Reproducible Code Example (If it is a code bug)**: If your issue is about a bug in the code, it's going to be easiest to understand if the code owners can reproduce the bug. Provide some code that someone can copy and run and see the exact bug that you are seeing.
* **Consider Your Tone as You Write**: Working with colleagues in a collaborative environment online can be tricky as you don't have the direct input of people's facial expressions and response to your comments that you may have in in-person or online meetings. As such, it's important to consider the tone of the issue as you write it. Rather than being critical and demanding fixes immediately, it is best to constructively point out what is not working and how it could be fixed or address challenges. If your input is well-received by the repo maintainers, it is more likely to be addressed more quickly.


## Mention Specific People Using @github-username-here

The last important note is that when possible, it is best to mention the collaborator
that you wish to respond to your issue in the text. You can do that by using 
`@github-username` in the text. This **mention** will draw more attention 
to the issue that you submitted and is in turn more likely to be responded to.


## Create a Pull Request to Address an Issue

Once you have submitted your issue, and everyone who needs to approve
the work has chimed in, you will likely be asked to submit a pull request.
Remember that a pull request is the way for you to suggest changes to a 
repository that can be reviewed carefully before being merged (combined into
the main code base in the repo). When you submit that PR, you will want to 
add some text to the PR that describes what the changes achieve. You will
also want to link back to the original issue that was opened. An example
of the beginning of an PR summary may look something like this:


`@lwasser this pr addresses issue #125 ... more here about what the pr does`


## Summary

Now you know the fundamentals behind creating issues using GitHub. In the next 
lesson you will see the larger picture of what a typical GitHub workflow looks like. 
