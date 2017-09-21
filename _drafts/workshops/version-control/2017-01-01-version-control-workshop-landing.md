---
layout: single
category: courses
title: "Version control intro and setup "
modified: '2017-09-21'
nav-title: "Workshop overview & setup"
permalink: /courses/intro-version-control-git/
module: "intro-version-control-git"
module-type: 'overview'
module-title: "Introduction to version control and git"
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

To participate in this workshop, you need to have git and bash installed on your
computer. Please follow the instructions below to install this PRIOR to showing up for the workshop.

</div>


<i class="fa fa-star"></i> **Data Tip:** Anyone with an `.edu` affiliation can get a
free git account with unlimited private repos. Sign up for the
<a href="https://help.github.com/articles/discounted-organization-accounts/" target="_blank" >Learn more here</a>.
{: .notice--success }


<!-- an overview module specifies the overview content for the course including syllabus and any assignments  module-type: 'session' specified a week or a particular set of content surrounding a topic - eg internship seminar, etc -->

## <i class="fa fa-calendar-check-o" aria-hidden="true"></i> Workshop schedule

| time        | topic                                               | instructor |
|:------------|:----------------------------------------------------|:-----------|
| 1:00 - 2:30 | Intro to version control & git - commit, push, pull | Max        |
| 2:30 - 2:40 | Break                                               |            |
| 2:40 - 4:00 | Pull requests and cloning + review                  | Leah       |


## Step 1. Setup git

### Setup git for Windows

* <a href="https://swcarpentry.github.io/workshop-template/#shell" target="_blank">Install bash on your computer</a>. Please note that windows command prompt is not the same as bash or shell. Please follow the software carpentry instructions to install shell. We suggest gitbash for windows users. If you are on a mac, you can use your terminal!

### Setup git for MAC / LINUX

* Install git <a href="https://swcarpentry.github.io/workshop-template/#git" target="_blank">Install git on your computer</a> If you are on windows and
followed the bash instructions above you can skip this step! If you are on a mac or linux, please be sure to install git!

## Step 2. Sign up for github

### Create An Github Account
If you do not already have a GitHub account, go to <a href="http://github.com/join" target="_blank" >GitHub </a> and sign up for
your free account. Pick a username that you like! This username is what your
colleagues will see as you work with them in GitHub and Git.

Take a minute to setup your account. If you want to make your account more
recognizable, be sure to add a profile picture to your account!

If you already have a GitHub account, simply be sure that you can sign in.

## Step 3. Configure git on your computer
Head over to software carpentry and <a href = "http://swcarpentry.github.io/git-novice/02-setup/follow" target = "_blank">follow the steps to setup git locally on your
computer.  </a>

Specifically be sure set up your username and email using bash at the command line.

```bash
$ git config --global user.name "Your Name"
$ git config --global user.email "your-email-used-for-github-acct@email.com"
$ git config --global color.ui "auto"
```

If you don't want to use vim as your default text editor. Please configure your
text editor as well. Follow the software carpentry lessons and if they don't make
sense we can go through this together during the workshop.
