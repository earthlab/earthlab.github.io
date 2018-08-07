---
layout: single
title: "How to Use R Markdown Code Chunks"
excerpt: 'Code chunks in an R Markdown document are used to separate code from text in a Rmd file. Learn how to create reports using R Markdown.'
authors: ['Leah Wasser', 'NEON Data Skills']
category: [courses]
modified: '2018-01-10'
class-lesson: ['intro-rmarkdown-knitr']
permalink: /courses/earth-analytics/document-your-science/rmarkdown-code-chunks-comments-knitr/
nav-title: 'Code chunks'
week: 1
sidebar:
  nav:
author_profile: false
comments: true
course: "earth-analytics"
order: 4
topics:
  reproducible-science-and-programming: ['rmarkdown']
redirect_from:
   - "/course-materials/earth-analytics/week-1/rmarkdown-code-chunks-comments-knitr/"
---
{% include toc title="In This Lesson" icon="file-text" %}


Next, you will learn about code chunks in `R Markdown` files.

<div class='notice--success' markdown="1">

## <i class="fa fa-graduation-cap" aria-hidden="true"></i> Learning Objectives
At the end of this activity, you will:

* Be able to add code to a code chunk in an `.Rmd` file.
* Be able to add options to a code chunk in `RStudio`.

## <i class="fa fa-check-square-o fa-2" aria-hidden="true"></i> What You Need

You will need the most current version of `R` and, preferably, `RStudio` loaded on
your computer to complete this tutorial.

### Install R Packages

* **knitr:** `install.packages("knitr")`
* **rmarkdown:** `install.packages("rmarkdown")`

</div>

You have already learned that an `.Rmd` document contains three parts

1. A `YAML` header.
2. Text chunks in markdown syntax that describe your processing workflow or are the text for your report.
3. Code chunks that process, visualize and/or analyze your data.

Let's break down code chunks in `.Rmd` files.


<i class="fa fa-star"></i> **Data Tip**: You can add code output or an `R` object
name to markdown segments of an RMD. For more, view this
<a href="http://rmarkdown.rstudio.com/authoring_quick_tour.html#inline_r_code" target="_blank"> R Markdown documentation</a>.
{: .notice--success}

## Code Chunks

Code chunks in an `R Markdown` document contain your `R` code. All code chunks
 start and end with <code>```</code> -- three backticks or
graves. On your keyboard, the backticks can be found on the same key as the
tilde (~). Graves are not the same as an apostrophe!

A code chunk looks like this:

<div class="highlighter-rouge">
<pre class="highlight"><code>```{r chunk-name-with-no-spaces}
# code goes here
 ```</code></pre>
 </div>

The first line: <code>```{r chunk-name-with-no-spaces}</code> contains the language (`r`) in this case, and the name of the chunk. Specifying
the language is mandatory. Next to the `{r}`, there is a chunk name. The chunk
name is not necessarily required however, it is good practice to give each
chunk a unique name to support more advanced knitting approaches.

<div class="notice--warning" markdown="1">

## <i class="fa fa-pencil-square-o" aria-hidden="true"></i> Optional challenge: Add code chunks to your R Markdown file

Continue to add to the `.Rmd` document that you created in the previous lesson.
Below the last section that you've just added,
create a code chunk that performs some basic math.

<pre><code>```{r perform-math }
# perform addition
a <- 1+2

b <- 234

# subtract a from b
final_answer <- b - a

# write out the final answer variable
final_answer

```</code></pre>


Then, add another chunk. Give it a different name.

<pre><code>```{r math-part-two }

   # More math!
   a * b

   a * b / final_answer

 ```</code></pre>

Now run the code in this chunk.

You can run code chunks:

* **Line-by-line:** With cursor on current line, <kbd>Ctrl</kbd> + <kbd>Enter</kbd> (Windows/Linux) or
<kbd>Command</kbd> + <kbd>Enter</kbd> (Mac OS X).
* **By chunk:** You can run the entire chunk (or multiple chunks) by
clicking on the `Chunks` dropdown button in the upper right corner of the script
environment and choosing the appropriate option. Keyboard shortcuts are
available for these options.

<figure class="half">
	<a href="{{ site.url }}/images/courses/earth-analytics/document-your-science/intro-knitr-rmd/rmd-run.png">
	<img src="{{ site.url }}/images/courses/earth-analytics/document-your-science/intro-knitr-rmd/rmd-run.png" alt="knitr button screenshot"></a>
	<figcaption> The "run" button in RStudio allows you to run a chunk individually
  or to run all chunks at once. RStudio Version 0.99.903.
	</figcaption>
</figure>

</div>

## Comment Your Code

Notice that in each of your code chunks, you've introduced `comments`. Comments
are lines in our code that are not run by `R`. However they allow us to describe
the intent of our code. Get in the habit of adding comments as you code. You will
learn more about this when you break down scientific programming in `R` in a
later tutorial.

## Code Chunk Options

You can add options to each code chunk. These options allow you to customize
how or if you want code to be
processed or appear on the rendered output (pdf document, html document, etc).
Code chunk options are added on the first line of a code
chunk after the name, within the curly brackets.

The example below, is a code chunk that will not be "run", or evaluated, by R.
The code within the chunk will appear on the output document, however there
will be no outputs from the code.

<div class="highlighter-rouge">
<pre class="highlight"><code>```{r intro-option, eval = FALSE}
# this is a comment. text, next to a comment, is not processed by R
# comments will appear on your rendered r markdown document
1+2
 ```</code></pre></div>

One example of using `eval = FALSE` is for a code chunk that exports a file such
as a figure graphic or a text file. You may want to show or document the code that
you used to export that graphic in your `html` or `pdf` document, but you don't need to
actually export that file each time you create a revised `html` or `pdf` document.

### 3 Common Chunk Options: Eval, Echo & Results
Three common code chunk options are:

* `eval = FALSE`: Do not **eval**uate (or run) this code chunk when
knitting the RMD document. The code in this chunk will still render in our knitted
`html` output, however it will not be evaluated or run by `R`.
* `echo=FALSE`: Hide the code in the output. The code is
evaluated when the `Rmd` file is knit, however only the output is rendered on the
output document.
* `results=hide`: The code chunk will be evaluated but the results or the code
will not be rendered on the output document. This is useful if you are viewing the
structure of a large object (e.g. outputs of a large `data.frame` which is
  the equivalent of a spreadsheet in `R`).

Multiple code chunk options can be used for the same chunk.

<div class="notice--warning" markdown="1">

## <i class="fa fa-pencil-square-o" aria-hidden="true"></i> Optional Challenge: Add More Code to Your R Markdown Document

Add a new chunk with the following arguments. Then describe in your own words
when you might want to use each of these arguments. HINT: Think about creating a report
with plots where you have a lot of code generating those plots.

<pre><code>```{r testing-arguments, eval = FALSE }

   # More math!
   a * b

   a * b / final_answer

 ```</code></pre>


 <pre><code>```{r testing-arguments, echo=FALSE }

    # More math!
    a * b

    a * b / final_answer

  ```</code></pre>


  <pre><code>```{r testing-arguments, results="hide" }

     # More math!
     a * b

     a * b / final_answer

   ```</code></pre>

</div>

You will knit your `R Markdown` document to `.html` in the next lesson.

<div class="notice--info" markdown="1">

## Additional Resources

* <a href="http://rmarkdown.rstudio.com/authoring_rcodechunks.html" target="_blank"> RStudio documentation.</a>
* <a href="http://yihui.name/knitr/demo/output/" target="_blank"> Learn more about code chunk options via yihui's (knitr package author) knitr documentation.</a>

</div>
