<!-- start homework activity -->


<div class="notice--warning" markdown="1">

## <i class="fa fa-pencil-square-o" aria-hidden="true"></i> Homework Submission: Create A Report Using Knitr & RMarkdown

* Create a new rmarkdown `.Rmd` file in `Rstudio`. Name the file:
`yourLastName-firstInitial-week1.Rmd` example: `wasser-l-week1.Rmd`

* Add an `author:` line to the `YAML` header at the top of your `.Rmd` document.
* Give your file an appropriate title. Suggestion: `Earth Analytics Spring 2017: Homework - Week 1`
* At the top of the rmarkdown document (BELOW THE YAML HEADER), add some text
that describes:

   * What an `.Rmd` file is
   * How you can use `knitr` in `R` and what it does.
   * Why using `Rmarkdown` to create reports can be helpful to both you and your colleagues that you work with on a project.

* Create a new CODE CHUNK
* Copy and paste the code BELOW into the code chunk that you just created.
* Below the code chunk in your `rmarkdown` document, add some TEXT that describes what the plot that you created
shows - interpret what you see in the data.
* Finally, in your own words, summarize what you think the plot shows / tells us about
the flood and also how the data that produced the plot were likely collected. Use the video
about the Boulder Floods as a reference when you write this summery.

BONUS: If you know `R`, clean up the plot by adding labels and a title. Or better
yet, use `ggplot2`!

</div>


```r

# load the ggplot2 library for plotting
library(ggplot2)

# download data from figshare
# note that we are downloaded the data into your
download.file(url = "https://ndownloader.figshare.com/files/7010681",
              destfile = "data/boulder-precip.csv")

# import data
boulder.precip <- read.csv(file="data/boulder-precip.csv")

# view first few rows of the data
head(boulder.precip)

# when we download the data we create a dataframe
# view each column of the data frame using it's name (or header)
boulder.precip$DATE

# view the precip column
boulder.precip$PRECIP

# q plot stands for quick plot. Let's use it to plot our data
qplot(x=boulder.precip$DATE,
      y=boulder.precip$PRECIP)

```

<figure class="half">
<a href="/images/rfigs/course-materials/earth-analytics/week-1/intro-knitr-rmd/2016-12-06-Rmd05-knitr/render-plot-1.png">
<img src="/images/rfigs/course-materials/earth-analytics/week-1/intro-knitr-rmd/2016-12-06-Rmd05-knitr/render-plot-1.png" alt="example of the plot">
</a>
<figcaption>
If your code ran properly, the resulting plot should look like this one.
</figcaption>
</figure>


<figure>
<a href="/images/course-materials/earth-analytics/week-1/setup-r-rstudio/r-markdown-wk-1.png">
<img src="/images/course-materials/earth-analytics/week-1/setup-r-rstudio/r-markdown-wk-1.png" alt="R markdown example image.">
</a>
<figcaption>
Your rmarkdown file should look something like the one above (with your own text
added to it). Note that the imaglocalhoste above is CROPPED at the bottom. Your rmarkdown
file will have more code in it.
</figcaption>
</figure>

### Troubleshooting: missing plot

If the code above did not produce a plot, please check the following:

#### Check your working directory

If the path to your file is not correct, then the data won't load into `R`.
If the data don't load into `R`, then you can't work with it or plot it.

To figure out your current working directory use the command: `getwd()`
Next, go to your finder or file explorer on your computer. Navigate to the path
that `R` gives you when you type `getwd()` in the console. It will look something
like the path example: `/Users/your-username/documents/earth-analytics`

```r
# check your working directory
getwd()

## [1] "/Users/lewa8222/documents/earth-analytics"
```

In the example above, note that my USER directory is called `lewa8222`. Yours
is called something different. Is there a `data` directory within the earth-analytics
directory?

<figure>
<a href="/images/course-materials/earth-analytics/week-1/setup-r-rstudio/data-dir-wk-1.png">
<img src="/images/course-materials/earth-analytics/week-1/setup-r-rstudio/data-dir-wk-1.png" alt="data directory example image.">
</a>
<figcaption>
Your working directory should contain a `/data` directory.
</figcaption>
</figure>

If not, review the [working directory lesson](/course-materials/earth-analytics/week-1/setup-working-directory/)
to ensure your working directory is SETUP properly on your computer and in `RStudio`.


<!-- end homework activity -->
