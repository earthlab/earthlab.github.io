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
check_create_dirs <- function(path_to_check, clean=T){
  if (dir.exists(path_to_check)){
    # clean out code dir to avoid the issue of duplicate files
    if(clean==F){
      unlink(file.path(path_to_check, "/*"), recursive = TRUE)
    }
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
  # filter(!(md_modified == rmd_modified) | is.na(md_modified) == TRUE ) %>%
  mutate(base_path = file.path(dirname(rmd_files), gsub(".Rmd$", "", basename(rmd_files))),
         code_file = gsub("_posts", "code", rmd_files),
         code_file = gsub(".Rmd$", ".R", code_file), # create the code path
         base_path = sub(".*_posts/", "", base_path),
         fig_dir = file.path("images/rfigs", base_path))


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
check_create_dirs(file.path(wd, all_rmd_files_bld$wd_image_dir[10]))
# check for code directory in the git repo, create it if it's not there
# this will create empty folders sometimes
check_create_dirs(dirname(all_rmd_files_bld$code_file[10]))

#################### Set up Image Directory #############################

# in case you just want to build one file
# rmd_file_df <- all_rmd_files_bld[10, ]

create_markdown <- function(rmd_file_df, wd){
  
  current_file <- rmd_file_df$rmd_files
  # copy .Rmd file to data working directory
  file.copy(from = current_file, to=wd, overwrite = TRUE)
  
  # check for working dir image dir
  check_create_dirs(rmd_file_df$fig_dir)
  # create fig dir path
  fig_dir_path <- file.path(git_repo_base_path, rmd_file_df$fig_dir)
  # check for image dir in git repo
  check_create_dirs(fig_dir_path)
  
  # check for code dir in git repo - don't clean out repo
  check_create_dirs(sub("[^/]+$", "", rmd_file_df$base_path), clean=F)
  
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
  
  if (length(list.files(rmd_file_df$fig_dir)) > 0) {
    # copy image directory over to git site if there are images in it
    file.copy(rmd_file_df$fig_dir, fig_dir_path, recursive=TRUE)
  }
  
  # purl the code to .R format, save in "code" directory
  r_file_path <- file.path(git_repo_base_path, "code", 
                           paste0(rmd_file_df$base_path, ".R"))
  
  purl(basename(current_file), output = r_file_path)
  
  #### Time to clean house
  # remove rfigs dir from working directory
  unlink(x="images/rfigs/", recursive = T)
  # remove rmd file from working directory
  unlink(basename(current_file))
  
}

########################### end script

create_markdown(rmd_file_df = all_rmd_files_bld[10, ], wd)

# rebuild entire course

apply(all_rmd_files_bld, wd, fun=create_markdown)
mapply(create_markdown, all_rmd_files_bld, wd=wd)
