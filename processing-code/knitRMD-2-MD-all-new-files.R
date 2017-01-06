##################

# This code takes a set of Rmd files from a designated git repo and
# 1) knits them to jekyll flavored markdown
# 2) purls them to .R files
# it then cleans up all image directories, etc from the working dir!
##################

require(knitr)
library(dplyr)

# working directory
options(stringsAsFactors = F)


### Helper function ####

## Helper function - check to see if directory exists and if it doesn't, create it.
check_create_dirs <- function(path_to_check){
  if (dir.exists(path_to_check)){
    # clean out code dir to avoid the issue of duplicate files
    unlink(file.path(path_to_check, "/*"), recursive = TRUE)
    print(" dir exists & and has been cleaned ")
  } else {
    # create image directory structure
    dir.create(path_to_check, recursive=T)
    print("new sub dir created.")
  }
}

#################### Set up Input Variables #############################

# set working dir - this is where the data are located
wd <- "~/Documents/earth-analytics/"
# where the files to render are
git_repo_base_path <- "~/Documents/Github/earthlab.github.io"
repo_post_path <- "_posts/course-materials/earth-analytics"

all_rmd_files <- as.data.frame(list.files(file.path(git_repo_base_path, repo_post_path), 
                                          pattern="\\.Rmd$", 
                                          recursive = T, full.names = T))
names(all_rmd_files) <- "rmd_files"



## subset dataframe to just the files that need a build
# conditions = date modified is not the same OR there is no md file
# note: this has a lot of path redundancy in it. Not ideal. 
all_rmd_files_bld <- all_rmd_files %>%
  mutate(md_files = gsub(".Rmd$", ".md", rmd_files)) %>%
  mutate(rmd_modified = file.info(rmd_files)$mtime,
         md_modified = file.info(md_files)$mtime) %>%
  filter(!(md_modified == rmd_modified) | is.na(md_modified) == TRUE ) %>%
  mutate(base_path = file.path(dirname(rmd_files), gsub(".Rmd$", "", basename(rmd_files))),
         code_file = gsub("_posts", "code", rmd_files),
         code_file = gsub(".Rmd$", ".R", code_file), # create the code path
         base_path = sub(".*_posts/", "", base_path),
         fig_dir = file.path("images/rfigs", base_path),
         wd_image_dir = file.path("images/rfigs", base_path))


# is it a draft or a final post
# draft_post <- c("_drafts", "_posts")



################### CONFIG BELOW IS REQUIRED BY JEKYLL - DON"T CHANGE ##########

# set data working dir
setwd(wd)


# set the base url for images and links in the md file
base_url="{{ site.url }}/"
opts_knit$set(base.url = base_url)

#################### Check For / Set up Image Directories  #############################

# NOTE -- delete the image directory at the end!

################# Check For / Set up / Clean out Code and pdf Dir  #################

# there is a possibility of duplicate code and image directories here IF there is a file name change. think about this.
# also there is now a dir for each code file which isn't necessary. 


# check for image directory in WD - create it if it's not there. 
check_create_dirs(file.path(wd, all_rmd_files_bld$wd_image_dir[1]))
# check for code directory in the git repo, create it if it's not there
check_create_dirs(dirname(all_rmd_files_bld$code_file[1]))

#################### Set up Image Directory #############################

rmd_file_df <- all_rmd_files_bld[4, ]

create_markdown <- function(rmd_file_df, wd){
  
  current_file <- rmd_file_df$rmd_files
  # copy .Rmd file to data working directory
  file.copy(from = current_file, to=wd, overwrite = TRUE)
  
  # check for working dir image dir
  check_create_dirs(rmd_file_df$wd_image_dir)

  # check for image dir in git repo
  check_create_dirs(rmd_file_df$fig_dir)
  # check for code dir in git repo
  check_create_dirs(dirname(rmd_file_df$code_file))
  
  # set knitr render options.
  opts_chunk$set(fig.path = paste0(rmd_file_df$fig_dir,"/"),
                 fig.cap = " ",
                 collapse = T)
  
  # render jekyll flavor md
  render_markdown(strict = FALSE, 
                  fence_char = "`")
  
  # knit Rmd to jekyll flavored md format, knit to the git repo so don't have to 
  # move the file
  knit(input= basename(current_file), 
       output = rmd_file_df$md_files, 
       envir = parent.frame())
  
  if (length(list.files(rmd_file_df$wd_image_dir)) > 0) {
    # copy image directory over to git site if there are images in it
    file.copy(rmd_file_df$wd_image_dir, rmd_file_df$fig_dir, recursive=TRUE)
  }
  
  # purl the code to R
  r_file_path <- file.path(git_repo_base_path, "code", 
                           rmd_file_df$base_path, 
                           gsub(".Rmd$",".R", basename(current_file)))
  purl(basename(current_file), output = r_file_path)
  
}


### will delete this for loop
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
  opts_chunk$set(fig.path = fig_path,
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
  
  #pdfFile <- file.path(gitRepoPath, pdfDir, 
   #                    paste0(add.date , sub(".Rmd$", "", current_file), ".pdf"))
  
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
