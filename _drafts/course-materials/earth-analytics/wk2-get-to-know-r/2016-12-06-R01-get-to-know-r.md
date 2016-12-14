---
layout: single
title: "Get to Know R & RStudio"
excerpt: "This tutorial introduces the R scientific programming language. It is
designed for someone who has not used R before. We will work with precipitation and
stream discharge data for Boulder County."
authors: ['Leah Wasser', 'Data Carpentry']
category: [course-materials]
class-lesson: ['get-to-know-r']
permalink: /course-materials/earth-analytics/get-to-know-r
nav-title: 'Intro to R'
dateCreated: 2016-12-13
lastModified: 2016-12-13
module-title: 'Get to Know The R Programming Language'
module-description: 'This tutorial introduces the R scientific programming language. It is
designed for someone who has not used R before. We will work with precipitation and
stream discharge data for Boulder County.'
sidebar:
  nav:
author_profile: false
comments: false
order: 1
---

.

<div class='notice--success' markdown="1">

# Learning Objectives
At the end of this activity, you will be able to:

* Be able to work with the 4 panes in the RStudio interface
* Understand the basic concept of a function and be able to use a function in your code.
* Know how to use key operator commands in R (<-)

## What You Need

You need R and RStudio to complete this tutorial. Also we recommend have you
have an `earth-analytics` directory setup on your computer with a `/data`
directory with it.

* [How to Setup R / R Studio](/course-materials/setup-r-rstudio)
* [Setup your working directory](/course-materials/setup-working-directory)


</div>

# Get to Know RStudio

Let's explore [RStudio](https://www.rstudio.com/), the Integrated Development
Environment (IDE) that we will use to write code, navigate files on our computer,
inspect variables and more. The RStudio IDE open source product is free under the [Affero General Public License (AGPL) v3](https://www.gnu.org/licenses/agpl-3.0.en.html).

RStudio is divided into 4 "Panes":

1. the **editor** for your scripts and documents
(top-left, in the default layout),
2. the **R console** (bottom-left),
3. your **environment/history **(top-right), and
4. your files/plots/packages/help/viewer (bottom-right).

The placement of these panes and their content can be customized
(see menu, RStudio -> Preferences -> Pane Layout). One advantage of
using `RStudio` is that it contains many shortcuts and
highlighting that speeds up coding. Also, autocomplete is avaibale to use functions
and find variables which makes typing easier and less error-prone.

<figure>
	<a href="{{ site.url }}{{ site.baseurl }}/images/course-materials/earth-analytics/wk2-get-to-know-r/rstudio-interface.png">
	<img src="{{ site.url }}{{ site.baseurl }}/images/course-materials/earth-analytics/wk2-get-to-know-r/rstudio-interface.png">
	</a>
	<figcaption>The RStudio IDE (Integrated Development Environment).
	</figcaption>
</figure>

## Interacting with R

When we program, we are writing down instructions for the computer to
follow. When we run a program, we tell the computer to follow those instructions.
We write, or *code*, instructions in `R` because it is a common language that
both the computer and we can understand.

### Definitions To Remember

* **COMMANDS**: the "instructions" that we tell the computer to follow
* **EXECUTE** a program: (also called *running*). When we execute a program, we
are telling the computer to run it.

## Scripts vs. Console vs. Rmarkdown

There are two main ways of interacting with R: using the console or by using
script files (plain text files that contain your code - note these can be `.R` files
OR `.Rmd` files).

### Benefits of Scripts
The main benefit of using scripts is it allows us to save our workflow. We want
our code and workflow to be reproducible so that anyone (including ourselves)
can easily replicate the workflow at a later time.

### Why use the console
The console pane (in `RStudio`, the bottom left panel) is the place where `R` is
waiting for you to tell it what to do, and where it will show the results of a
command that has been executed. You can type commands directly into the console
and press `Enter` to execute those commands, but they will be forgotten when you
close the session. This is a good place to TEST a line of code.

It is better to enter the commands in the script editor, and
save the script. This way, you have a complete record of what you did, you can
easily show others how you did it and you can do it again later on if needed.
When you run a script or a part of a script, it will run in the console.

### R Studio Shortcuts

* <kbd>`Ctrl`</kbd> + <kbd>`Enter`</kbd>: execute commands directly from the script editor. This shortcut will run either the line in the script that your cursor
is on or all of the commands that you have currently selected (highlighted) in
your script.
* <kbd>`Ctrl`</kbd> + <kbd>`1`</kbd> and <kbd>`Ctrl`</kbd> +
<kbd>`2`</kbd>: jump between the script and the console windows in `RStudio`.

## R Console Tricks

If R is ready to accept commands, the R console shows a `>` prompt. If it
receives a command (by typing, copy-pasting or sent from the script editor using
<kbd>`Ctrl`</kbd> + <kbd>`Enter`</kbd>), R will try to execute it, and when
ready, show the results and come back with a new `>`-prompt to wait for new
commands.

If R is still waiting for you to enter more data because it isn't complete yet,
the console will show a `+` prompt. It means that you haven't finished entering
a complete command. This is because you have not 'closed' a parenthesis or
quotation, i.e. you don't have the same number of left-parentheses as
right-parentheses, or the same number of opening and closing quotation marks. If
you're in RStudio and this happens, click inside the console window and press
`Esc`; this will cancel the incomplete command and return you to the `>` prompt.


# Seeking help

## I know the name of the function I want to use, but I'm not sure how to use it

If you need help with a specific function, let's say `barplot()`, you can type:


```r
?barplot
```

If you just need to remind yourself of the names of the arguments, you can use:


```r
args(lm)
```

## I want to use a function that does X, there must be a function for it but I don't know which one...

If you are looking for a function to do a particular task, you can use
`help.search()` function, which is called by the double question mark `??`.
However, this only looks through the installed packages for help pages with a
match to your search request


```r
??kruskal
```

If you can't find what you are looking for, you can use the
[rdocumention.org](http://www.rdocumentation.org) website that searches through
the help files across all packages available.

## I am stuck... I get an error message that I don't understand

Start by googling the error message. However, this doesn't always work very well
because often, package developers rely on the error catching provided by R. You
end up with general error messages that might not be very helpful to diagnose a
problem (e.g. "subscript out of bounds"). If the message is very generic, you might
also include the name of the function or package you're using in your query.

However, you should check StackOverflow. Search using the `[r]` tag. Most
questions have already been answered, but the challenge is to use the right
words in the search to find the answers:
[http://stackoverflow.com/questions/tagged/r](http://stackoverflow.com/questions/tagged/r)

The [Introduction to R](http://cran.r-project.org/doc/manuals/R-intro.pdf) can
also be dense for people with little programming experience but it is a good
place to understand the underpinnings of the R language.

The [R FAQ](http://cran.r-project.org/doc/FAQ/R-FAQ.html) is dense and technical
but it is full of useful information.


<div class='notice--info' markdown="1">

# Where to Get Help

* Ask your colleagues: if you know someone with more experience than you,
  they might be able to help you.
* [StackOverflow](http://stackoverflow.com/questions/tagged/r): if your question
  hasn't been answered before and is well crafted, chances are you will get an
  answer in less than 5 min. Remember to follow their guidelines on [how to ask
  a good question](http://stackoverflow.com/help/how-to-ask).
* There are also some topic-specific mailing lists (GIS, phylogenetics, etc...),
  the complete list is [here](http://www.r-project.org/mail.html).

## More resources

* The [Posting Guide](http://www.r-project.org/posting-guide.html) for the R
  mailing lists.
* [How to ask for R help](http://blog.revolutionanalytics.com/2014/01/how-to-ask-for-r-help.html)
  useful guidelines
* [This blog post by Jon Skeet](http://codeblog.jonskeet.uk/2010/08/29/writing-the-perfect-question/)
  has quite comprehensive advice on how to ask programming questions.
</div>
