---
layout: single
title: 'How To Review Code on GitHub'
excerpt: "Using the code review tools you can suggest changes or leave comments line by line. Learn how to build a code review on GitHub.com to suggest changes to a GitHub repository."
authors: ['Elsa Culler']
category: [courses]
class-lesson: ['git-github-collaboration-tb']
permalink: /courses/intro-to-earth-data-science/git-github/github-collaboration/how-to-review-code-on-github/
nav-title: "GitHub Code Review"
dateCreated: 2022-04-07
modified: 2022-05-20
module-type: 'class's
course: "intro-to-earth-data-science-textbook"
week: 3
sidebar:
  nav:
author_profile: false
comments: true
order: 7
topics:
  reproducible-science-and-programming: ['git']

---
---
{% include toc title="On This Page" icon="file-text" %}

<div class='notice--success' markdown="1">

## <i class="fa fa-graduation-cap" aria-hidden="true"></i> Learning Objectives

* Explain what a code review is and how it can be used.
* Add a single suggestion to a pull request
* Link suggestions together in a code review
* Compile a code review on **GitHub.com**.

</div>

## About Code Reviews

A **code review** is a way for you to suggest changes
to another person's pull request. You can send comments back and
forth referencing specific lines of code. Code
reviews are used to let contributors know what they need to do before
their pull request meets project standards and is ready to merge.

## The Code Review Workflow
As a reminder, when you open up a pull request, you will see the line by line changes or
differences between the file you submitted, compared to the file that exists
in a repository. These changes are called **diffs** (short for differences).

Pull requests show diffs of the content between (a branch on) your repository and (a
branch on) the repository that you are submitting changes to. 

The changes, additions,
and subtractions are shown in green and red. The color green represents additions
to the file whereas red represents deletions.

To leave a code review:

1. Go to the pull request page.
2. Click on the **Files Changed** tab. You should now be able to see the diff
    <figure>
       <a href="{{ site.url }}/images/earth-analytics/git-version-control/github-code-review/01-files-changed.png">
           <img src="{{ site.url }}/images/earth-analytics/git-version-control/github-code-review/01-files-changed.png" alt="To see the diff, click on the Files Changed tab.">
        </a>
       <figcaption> 
         To see the diff, click on the Files Changed tab.
       </figcaption>
    </figure>
3. Look through the changes. If you want to make a general comment you can click the green **Review changes** button and add then leave your comment as a code review.
    <figure>
       <a href="{{ site.url }}/images/earth-analytics/git-version-control/github-code-review/02-review-changes">
           <img src="{{ site.url }}/images/earth-analytics/git-version-control/github-code-review/02-review-changes.png" alt="Leave a single comment with Review Changes.">
        </a>
       <figcaption> 
         Leave a single comment with Review Changes
       </figcaption>
    </figure>
3. If there is a *particular line* you want to comment on, mouse over the left edge of the line. A blue plus sign will pop up.
    <figure>
       <a href="{{ site.url }}/images/earth-analytics/git-version-control/github-code-review/03-start-comment.png">
           <img src="{{ site.url }}/images/earth-analytics/git-version-control/github-code-review/03-start-comment.png" alt="Mouse over the left side of a line to see the blue plus sign.">
        </a>
       <figcaption> 
         Mouse over the left side of a line to see the blue plus sign.
       </figcaption>
    </figure>
4. Once you have written your comment, you can choose to **Add single comment** or **Start a review**. If you start a review, then all subsequent comments will be added to your review until you are finished.
    <figure>
       <a href="{{ site.url }}/images/earth-analytics/git-version-control/github-code-review/04-comment.png">
           <img src="{{ site.url }}/images/earth-analytics/git-version-control/github-code-review/04-comment.png" alt="Add a comment or start a review.">
        </a>
       <figcaption> 
         Add a comment or start a review.
       </figcaption>
    </figure>

    <figure>
       <a href="{{ site.url }}/images/earth-analytics/git-version-control/github-code-review/05-add-review-comment.png">
           <img src="{{ site.url }}/images/earth-analytics/git-version-control/github-code-review/05-add-review-comment.png" alt="Add a second comment to your review.">
        </a>
       <figcaption> 
         Add a second comment to your review.
       </figcaption>
    </figure>
    
5. When you are done, click **Finish your review**. You can add an overall comment and specify whether you want to **Comment**, **Approve**, or **Request changes**.
    <figure>
       <a href="{{ site.url }}/images/earth-analytics/git-version-control/github-code-review/06-finish-review.png">
           <img src="{{ site.url }}/images/earth-analytics/git-version-control/github-code-review/06-finish-review.png" alt="Finish your review.">
        </a>
       <figcaption> 
         Finish your review.
       </figcaption>
    </figure>
