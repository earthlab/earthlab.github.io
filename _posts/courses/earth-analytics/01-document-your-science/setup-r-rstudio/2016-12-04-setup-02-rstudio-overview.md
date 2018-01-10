---
layout: single
authors: ['Leah Wasser', 'Data Carpentry', 'Software Carpentry']
category: [courses]
title: 'Get to Know RStudio'
attribution: 'These materials were adapted from Software Carpentry materials by Earth Lab.'
excerpt: 'Learn how to work with R using the RStudio application.'
dateCreated: 2016-12-12
modified: '2018-01-10'
nav-title: 'RStudio Intro'
week: 1
sidebar:
  nav:
course: 'earth-analytics'
class-lesson: ['setup-r-rstudio']
permalink: /courses/earth-analytics/document-your-science/intro-to-r-and-rstudio/
author_profile: false
comments: true
order: 2
topics:
  reproducible-science-and-programming: ['RStudio']
---


{% include toc title="In this lesson" icon="file-text" %}


<div class='notice--success' markdown="1">

## <i class="fa fa-graduation-cap" aria-hidden="true"></i> Learning Objectives
At the end of this activity, you will:

* Be able to describe the main use for each of the four main panes in the `RStudio` interface

</div>

# Get to Know RStudio

Let's explore [RStudio](https://www.rstudio.com/), the Integrated Development
Environment (IDE) that we will use to write code, navigate files on our computer,
inspect variables and more. The RStudio IDE open source product is free under the
[Affero General Public License (AGPL) v3](https://www.gnu.org/licenses/agpl-3.0.en.html).

When you first open it, the `RStudio` interface is divided into four "Panes" as
described below:

1. Top LEFT: the **editor** where you edit scripts, documents and can "send" code
to run in the console,
2. Bottom LEFT: the **R console** is where the code is run. You can type code directly
into the console OR you can send it to the console by running it from the editor,
3. Top RIGHT: your **environment/history** panes. This is where you can see variables
you've created and a full history of functions / commands you have run,
4. Bottom RIGHT: The bottom right pane by default contains several panes including:
**files/plots/packages/help/viewer**. The files pane allows you to explore files
on your computer like you would in windows explorer or finder on a mac. The plots
tab is where you will see plots that you create. We will explore these various
panes together in class.

The placement of these panes and their content can be customized using the `RStudio`
preferences: (From the RStudio drop down choose: `RStudio -> Preferences -> Pane Layout`).
You can also drag the panes using your mouse to move / resize them.

<figure>
	<a href="{{ site.url }}/images/courses/earth-analytics/week-02/get-to-know-r/rstudio-interface.png">
	<img src="{{ site.url }}/images/courses/earth-analytics/week-02/get-to-know-r/rstudio-interface.png" alt="rstudio interface">
	</a>
	<figcaption>The RStudio IDE (Integrated Development Environment) is divided into
  four panes in its default layout.
	</figcaption>
</figure>

## Advantages of an IDE like RStudio
One advantage of using `RStudio` is that it contains many shortcuts and visual cues
like code highlighting that speed up coding. Also, autocomplete is available to use
to find function names, arguments for those functions and variables that are stored
in your environment. This makes typing easier and less error-prone. We will talk
more about autocomplete in class.

## Interacting with R

When we program, we are writing down instructions for the computer to
follow. When we run a program, we tell the computer to follow those instructions.
We write, or *code*, instructions in `R` because it is a common language that
both the computer and we can understand.

### Definitions to Remember

* **COMMANDS**: the "instructions" that we tell the computer to follow
* **EXECUTE**: (also called *running*). When we execute a program, we
are telling the computer to run it.

## Scripts vs. Console vs. R Markdown

There are two main ways of interacting with `R`: using the console or by using
script files (plain text files that contain your code - note these can be `.R` files
OR `.Rmd` files).

### Benefits of Scripts
The main benefit of using scripts is it allows us to save our workflow. We want
our code and workflow to be reproducible so that anyone (including ourselves)
can easily replicate the workflow at a later time.

### Why Use the Console
The console pane (in `RStudio`, the bottom left panel) is the place where `R` is
waiting for you to tell it what to do, and where it will show the results of a
command that has been executed. You can type commands directly into the console
and press `Enter` to execute those commands, but they will be forgotten when you
close the session. This is a good place to TEST a line of code.

It is better to enter the commands in the script editor, and
save the script. This way, you have a complete record of what you did, you can
easily show others how you did it and you can do it again later on if needed.
When you run a script or a part of a script, it will run in the console.

### RStudio Shortcuts

* <kbd>`Ctrl`</kbd> + <kbd>`Enter`</kbd>: execute commands directly from the script editor. This shortcut will run either the line in the script that your cursor
is on or all of the commands that you have currently selected (highlighted) in
your script.
* <kbd>`Ctrl`</kbd> + <kbd>`1`</kbd> and <kbd>`Ctrl`</kbd> +
<kbd>`2`</kbd>: jump between the script and the console windows in `RStudio`.

## R Console Tricks

If `R` is ready to accept commands, the `R` console shows a `>` prompt. If it
receives a command (by typing, copy-pasting or sent from the script editor using
<kbd>`Ctrl`</kbd> + <kbd>`Enter`</kbd>), R will try to execute it, and when
ready, show the results and come back with a new `>`-prompt to wait for new
commands.

If `R` is still waiting for you to enter more data because it isn't complete yet,
the console will show a `+` prompt. It means that you haven't finished entering
a complete command. This is because you have not 'closed' a parenthesis or
quotation, i.e. you don't have the same number of left-parentheses as
right-parentheses, or the same number of opening and closing quotation marks. If
you're in `RStudio` and this happens, click inside the console window and press
`Esc`; this will cancel the incomplete command and return you to the `>` prompt.
