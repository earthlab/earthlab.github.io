##################

# This code takes a set of Rmd files from a designated git repo and
# 1) knits them to jekyll flavored markdown
# 2) purls them to .R files
# it then cleans up all image directories, etc from the working dir!
##################

require(knitr)
all_post_dirs <- list.dirs("~/Documents/Github/earthlab.github.io/_posts/course-materials/earth-analytics")

dirs <- c("course-materials/earth-analytics/week-1/co-floods-1-intro",
          "course-materials/earth-analytics/co-floods-2-data-r",
          "course-materials/earth-analytics/week-1/intro-knitr-rmd",
          "course-materials/earth-analytics/week-1/setup-r-rstudio",
          "course-materials/earth-analytics/week-2/get-to-know-r",
          "course-materials/earth-analytics/week-2/hw-plot-precip-data",
          "course-materials/earth-analytics/week-3/lidar-intro")

# is it a draft or a final
draft_post <- c("_drafts", "_posts")

the_draft_post <- draft_post[2]

#################### Set up Input Variables #############################
# set directory that  you'd like to build
subDir <- dirs[7]

# Inputs - Where the git repo is on your computer
# rmdRepoPath <-"~/Documents/github/R-Spatio-Temporal-Data-and-Management-Intro/"
gitRepoPath <-"~/Documents/github/earthlab.github.io"
#rmdRepoPath <- file.path(gitRepoPath, the_draft_post, subDir)# they are the same this time. 
# rmdRepoPath <- subDir
# jekyll will only render md posts that begin with a date. Add one.
add.date <- ""

# set working dir - this is where the data are located
wd <- "~/Documents/earth-analytics/"


################### CONFIG BELOW IS REQUIRED BY JEKYLL - DON"T CHANGE ##########

# set data working dir
setwd(wd)

# don't change - this is the posts dir location required by jekyll
postsDir <- file.path(the_draft_post, subDir)
codeDir <- file.path("code/R", subDir)
pdfDir <- file.path("pdf", subDir)

# images path
imagePath <- file.path("images/rfigs", subDir)

# set the base url for images and links in the md file
base.url="{{ site.baseurl }}/"
opts_knit$set(base.url = base.url)

#################### Check For / Set up Image Directories  #############################

# make sure image directory exists in the DATA DIR WHERE THIS RENDERS
# if it doesn't exist, create it
# note this will fail quietly if the sub dir doesn't exist
if (dir.exists(file.path(wd, imagePath))){
  print("image dir exists - all good")
} else {
  # create image directory structure
  dir.create(file.path(wd, imagePath), recursive = T)
  print("image directories created!")
}

# NOTE -- delete the image directory at the end!


################# Check For / Set up / Clean out Code and pdf Dir  #################

if (dir.exists(file.path(gitRepoPath, codeDir))){
  # clean out code dir to avoid the issue of duplicate files
  unlink(file.path(gitRepoPath, codeDir, "*"), recursive = TRUE)
  print("code dir exists & and has been cleaned ")
} else {
  # create image directory structure
  dir.create(file.path(gitRepoPath, codeDir), recursive=T)
  print("new code sub dir created.")
}


if (dir.exists(file.path(gitRepoPath, pdfDir))){
  # clean out code dir to avoid the issue of duplicate files
  unlink(file.path(gitRepoPath, pdfDir, "*"), recursive = TRUE)
  print("pdf dir exists & has been cleaned out")
} else {
  # create image directory structure
  dir.create(file.path(gitRepoPath, pdfDir), recursive=T)
  print("new pdf sub dir created.")
}
################# Clean out posts Dir  #################
# NOTE: comment this out if you just want to rebuild one lesson

# clean out posts dir to avoid the issue of duplicate files - don't do this if rmd files r here
# unlink(paste0(gitRepoPath, postsDir, "*"), recursive = TRUE)

# clean out images dir to avoid the issue of duplicate files
unlink(file.path(gitRepoPath, imagePath, "*"), recursive = TRUE)


# copy image directory over
# file.copy(paste0(wd,"/",fig_path), paste0(gitRepoPath,imagePath), recursive=TRUE)

# copy rmd file to the rmd directory on git
# file.copy(paste0(wd,"/",basename(files)), gitRepoPath, recursive=TRUE)
#################### Get List of RMD files to Render #############################


# get a list of files to knit / purl
rmd.files <- list.files(file.path(gitRepoPath, draft_post,subDir), 
                        pattern="\\.Rmd$", 
                        full.names = TRUE,
                        ignore.case = F)

#################### Set up Image Directory #############################

# just render one file
# rmd.files <- rmd.files[1]

for (files in rmd.files) {
  
  # copy .Rmd file to data working directory
  file.copy(from = files, to=wd, overwrite = TRUE)
  current_file=basename(files)
  
  # setup path to images
  # print(paste0(imagePath, sub(".Rmd$", "", basename(input)), "/"))
  # forcing the trailing "/" with paste0 so images render to the right directory
  fig_path <- paste0(file.path(imagePath, sub(".Rmd$", "", current_file)),"/")
  
  # clean out images in the working directory
  unlink(file.path(wd, imagePath, "*"))
  
  # make sure image subdir exists in the GIT REPO
  # then clean out image subdir on git if it exists
  # note this will fail if the sub dir doesn't exist
  if (dir.exists(file.path(gitRepoPath, fig_path))){
    print("image dir exists, cleaning")
    unlink(file.path(gitRepoPath, fig_path, "*"))
  } else {
    # create image directory structure
    dir.create(file.path(gitRepoPath, fig_path), recursive = T)
    print("git image directories created!")
  }
  
  # might be able to combine these into one. testing.
  opts_chunk$set(fig_path = fig_path,
                 fig.cap = " ",
                 collapse = T)
  
  # opts_chunk$set(fig_path = fig_path)
  # opts_chunk$set(fig.cap = " ")
  # opts_chunk$set(collapse = T )
  
  # render jekyll flavor md
  render_markdown(strict = FALSE, fence_char = "`")
  
  # create the markdown file name - add a date at the beginning to Jekyll 
  # recognizes it as a post
  mdFile <- file.path(gitRepoPath, postsDir, paste0(add.date , sub(".Rmd$", "", current_file), ".md"))
  
  # knit Rmd to jekyll flavored md format
  knit(current_file, 
       output = mdFile, 
       envir = parent.frame())
  
  pdfFile <- file.path(gitRepoPath, pdfDir, 
                       paste0(add.date , sub(".Rmd$", "", current_file), ".pdf"))
  
  # knit to pdf
  # render(current_file, 
  #        output_file = pdfFile,
  #        output_format = "pdf_document")
  
  # COPY image directory, rmd file OVER to the GIT SITE###
  # only copy over if there are images for the lesson
  if (dir.exists(file.path(wd, fig_path))){
    # copy image directory over
    file.copy(file.path(wd, fig_path), file.path(gitRepoPath, imagePath), recursive=TRUE)
  }
  
  # copy rmd file to the rmd directory on git
  # file.copy(paste0(wd, "/", basename(files)), gitRepoPath, recursive=TRUE)
  
  ## OUTPUT STUFF TO R ##
  # output (purl) code in .R format
  rCodeOutput <- file.path(gitRepoPath, codeDir, paste0(sub(".Rmd$", "", basename(files)), ".R"))
  
  # purl the code to R
  purl(files, output = rCodeOutput)
  
  # CLEAN UP
  # remove Rmd file from data working directory
  unlink(basename(files))
  
  # print when file is knit
  doneWith <- paste0("processed: ", files)
  print(doneWith)
  
}

###### Local image cleanup #####

# recursively clean up working directory images dir  
unlink(file.path(wd, "images"), recursive = T)

########################### end script
