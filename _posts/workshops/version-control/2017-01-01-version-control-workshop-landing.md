---
layout: single
category: courses
title: "Version control intro and setup"
modified: '2018-09-14'
nav-title: "Workshop overview & setup"
permalink: /workshops/intro-version-control-git/
module: "intro-version-control-git"
module-type: "workshop"
module-title: "Introduction to Version Control and Git"
module-description: 'Learn about and how to use version control to back up your work.'
sidebar:
  nav:
comments: false
author_profile: false
order: 1
---

{% include toc title="This course" icon="file-text" %}

{% assign course_posts = site.posts | course: page.course %}
{% assign sorted_posts = course_posts | sort:'overview-order' %}

{% assign modules = sorted_posts | where:"module-type", 'overview' %}
{% assign modules_course = modules | where:"module", page.module %}

<div class="notice--info" markdown="1">

## <i class="fa fa-ship" aria-hidden="true"></i> Introduction to Git / Github workshop

## Key course materials

{% for post in modules_course %}
 * <a href="{{ site.url }}{{ post.permalink }}">{{ post.title }}</a>
{% endfor %}

## What you need

To participate in this workshop, you need to have Git and Bash installed on your
computer. Please follow the instructions below to install this PRIOR to showing up for the workshop.

</div>


<i class="fa fa-star"></i> **Data Tip:** Anyone with an `.edu` email affiliation can get a
free GitHub account with unlimited private repos.
<a href="https://help.github.com/articles/discounted-organization-accounts/" target="_blank" >Learn more here</a>.
{: .notice--success }


## <i class="fa fa-calendar-check-o" aria-hidden="true"></i> Workshop schedule

| time        | topic                                               | instructor |
|:------------|:----------------------------------------------------|:-----------|
| 1:00 - 2:30 | Intro to version control & Git - commit, push, pull | Max        |
| 2:30 - 2:40 | Break                                               |            |
| 2:40 - 4:00 | Pull requests and cloning + review                  | Leah       |


## Step 1. Setup Git and Bash

### Windows instructions

* <a href="https://swcarpentry.github.io/workshop-template/#shell" target="_blank">Install Bash on your computer</a>. Please note that Windows command prompt is not the same as Bash - we suggest that Windows users install Git for Windows, which also installs Bash as described in the Software Carpentry instructions.

### Mac or Linux instructions

* Bash is available by default for these *nix based systems
* <a href="https://swcarpentry.github.io/workshop-template/#git" target="_blank">Install Git on your computer.</a>

## Step 2. Sign up for GitHub

### Create a GitHub account

If you do not already have a GitHub account, go to <a href="http://github.com/join" target="_blank">GitHub </a> and sign up fora free account. Pick a username that you like!
This username is what your colleagues will see as you work with them in GitHub and Git.

Take a minute to setup your account. If you want to make your account more
recognizable, be sure to add a profile picture to your account!

If you already have a GitHub account, verify that you can sign in.

## Step 3. Configure Git on your computer

Head over to Software Carpentry and <a href = "http://swcarpentry.github.io/git-novice/02-setup/" target = "_blank"> follow the steps to configure Git on your
computer. </a>

Be sure to set up your username and e-mail from the command line.

```bash
$ git config --global user.name "Your Name"
$ git config --global user.email "your-email-used-for-github-acct@email.com"
$ git config --global color.ui "auto"
```

Please configure your text editor as well. Follow the software carpentry lessons
and if they don't make sense we can go through this together during the workshop.

If you're not sure whether you've already configured Git, you can list your configuration by executing `git config --list`.
