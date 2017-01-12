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
      print(" dir exists") 
    }else {
      print(" dir exists & and has been cleaned ")
      unlink(file.path(path_to_check, "/*"), recursive = TRUE)
    }
    
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

##### Setup Life ####

# set data working dir
setwd(wd)

# Universal Knitr Config - set the base url for images and links in the md file
base_url="{{ site.url }}/"
opts_knit$set(base.url = base_url)



# a_dataframe <- all_rmd_files
## subset dataframe to just the files that need a build
# conditions = date modified is not the same OR there is no md file

populate_all_rmd_df <- function(a_dataframe, all=FALSE){
  all_rmd_files_bld <- a_dataframe %>%
    mutate(md_files = gsub(".Rmd$", ".md", rmd_files)) %>%
    mutate(rmd_modified = file.info(rmd_files)$mtime,
           md_modified = file.info(md_files)$mtime) %>%
    mutate(base_path = file.path(dirname(rmd_files), gsub(".Rmd$", "", basename(rmd_files))),
           code_file = gsub(".Rmd$", ".R", (basename(rmd_files))), # create the code name
           base_path = sub(".*_posts/", "", base_path),
           fig_dir = file.path("images/rfigs", base_path))

    # filter the data to just the modified files if it's not a full rebuild
  if (all== FALSE) {
    all_rmd_files_bld <- all_rmd_files_bld %>%
      filter((md_modified < rmd_modified) | is.na(md_modified) == TRUE )
  }

  return(all_rmd_files_bld)
}





# create code filename


# is it a draft or a final post
# draft_post <- c("_drafts", "_posts")

################# Check For / Set up / Clean out Code and pdf Dir  #################

# there is a possibility of duplicate code and image directories here IF there is a file name change. think about this.

#################### Set up Image Directory #############################

# in case you just want to test this function
# rmd_file_df <- all_rmd_files_bld[21, ]

create_markdown <- function(rmd_file_df, wd){
  
  current_file <- rmd_file_df$rmd_files
  # copy .Rmd file to data working directory
  file.copy(from = current_file, to=wd, overwrite = TRUE)
  
  # check for working dir image dir
  check_create_dirs(rmd_file_df$fig_dir)
  
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
    # create fig dir path
    fig_dir_path <- file.path(git_repo_base_path, rmd_file_df$fig_dir)
    # copy image directory over to git site if there are images in it
    file.copy(rmd_file_df$fig_dir, (sub("[^/]+$", "", fig_dir_path)), recursive=TRUE)
  }
  
  # check for code dir in git repo - don't clean out repo
  # code path
  code_dir <- file.path(git_repo_base_path, "code", (sub("[^/]+$", "", rmd_file_df$base_path)))
  
  check_create_dirs(code_dir, clean=F)
  # purl the code to .R format, save in "code" directory
  r_file_path <- file.path(code_dir, rmd_file_df$code_file)
  
  purl(basename(current_file), output = r_file_path)
  
  #### Time to clean house
  # remove rfigs dir from working directory
  unlink(x="images/rfigs/", recursive = T)
  # remove rmd file from working directory
  unlink(basename(current_file))
  
}

########################### end script


# create initial list of files
all_rmd_files <- as.data.frame(list.files(file.path(git_repo_base_path, repo_post_path), 
                                          pattern="\\.Rmd$", 
                                          recursive = T, full.names = T))
names(all_rmd_files) <- "rmd_files"

all_rmd_files_bld <- populate_all_rmd_df(all_rmd_files, all=T)

# just one file
# create_markdown(all_rmd_files_bld[20, ], wd)
## run the function

if ((nrow(all_rmd_files_bld)) > 0){
  pb <- txtProgressBar(min = 0, max = nrow(all_rmd_files_bld), style = 3)
 for (i in seq(from=1, to=nrow(all_rmd_files_bld))) {
  create_markdown(rmd_file_df = all_rmd_files_bld[i, ], wd)
   setTxtProgressBar(pb, i)
   print(i)
 }
}


# rebuild entire course
#do.call( function(x,y) create_markdown(all_rmd_files_bld, wd), 
#         all_rmd_files_bld)

#mapply(create_markdown, all_rmd_files_bld, wd=wd)
