library(dplyr)
library(tools)
library(yaml)
library(rlist)
library(rmarkdown)
library(lubridate)
source("processing-code/helpers.R")

# Find files that need to be converted ------------------------------------
find_files_to_convert <- function(input_dir) {
  extensions <- c("ipynb", "Rmd", "md")
  patt <- paste0("\\.(", paste(extensions, collapse = "|"), ")$")
  files <- list.files(input_dir, all.files = TRUE, recursive = TRUE, full.names = TRUE)
  files <- grep(patt, files, value = TRUE)
  
  # remove ipynb_checkpoints, templates, and things that shouldn't render
  files <- grep("\\.ipynb_checkpoints", files, value = TRUE, invert = TRUE)
  files <- grep("Template", files, value = TRUE, invert = TRUE)
  files <- grep("README", files, value = TRUE, invert = TRUE)
  files <- grep("bokeh", files, value = TRUE, invert = TRUE)
  files
}

files_to_convert <- find_files_to_convert("tutorials") %>%
  except(posts_to_ignore()) %>%
  data.frame(source_file = .)


# create a data frame with
# - does md exist?
# - date of last md change
# - date of last source file change
last_commit_date <- function(df, column) {
  file <- df[[column]]
  if (is.na(file)) {
    return(NA)
  }
  stopifnot(length(file) == 1)
  cmd_prefix <- "git log -1 --date=iso --format=%cd"
  
  if (substr(file, 1, 10) == "tutorials/") {
    cmd_prefix <- paste("cd tutorials &&", cmd_prefix)
    file <- gsub("tutorials/", "", file)
  }
  
  cmd_prefix %>%
    paste(file) %>%
    system(intern = TRUE) %>%
    strsplit(split = " -") %>%
    unlist() %>%
    `[`(1) %>%
    ymd_hms()
}

commit_df <- files_to_convert %>%
  group_by(source_file) %>%
  do(data.frame(last_src_commit = last_commit_date(., column = "source_file"))) %>%
  mutate(expected_md = sub("(.*\\/)([^.]+)(\\.[[:alnum:]]+$)", "\\2", 
                           source_file), 
         expected_md = paste0(expected_md, ".md"))

# find whether md exists
extant_md <- list_posts() %>%
  grep(pattern = "./tutorials/", fixed = TRUE, value = TRUE, invert = TRUE)

commit_df$md_exists <- NA
commit_df$md_name <- NA

for (i in 1:nrow(commit_df)) {
  commit_df$md_exists[i] <- max(grepl(x = extant_md, 
                                  pattern = commit_df$expected_md[i], 
                                  fixed = TRUE))
  stopifnot(commit_df$md_exists[i] <= 1)
  if (commit_df$md_exists[i]) {
    commit_df$md_name[i] <- grep(x = extant_md, 
                                 pattern = commit_df$expected_md[i], 
                                 fixed = TRUE, 
                                 value = TRUE)
  }
}

# identify which posts need to be rebuilt based on 
# - whether a md file has already been rendered
# - whether the source file has changed more recently than the rendered post
files_to_convert <- commit_df %>%
  group_by(source_file, last_src_commit, md_exists, md_name) %>%
  do(data.frame(last_md_commit = last_commit_date(., column = "md_name"))) %>%
  mutate(delta_t = last_src_commit - last_md_commit,   
         needs_rebuild = !md_exists | delta_t > 0) %>%
  filter(needs_rebuild) %>%
  ungroup() %>%
  select(source_file) %>%
  unlist()

# Convert the files to md posts -------------------------------------------

make_post <- function(file, dest_dir = "_posts") {
  # first, generate an output filename, e.g., _posts/R/2015-01-22-test.md
  ext <- file_ext(file)
  md_out <- gsub(paste0("\\.", ext), ".md", file)
  file_components <- unlist(strsplit(md_out, 
                                     split = .Platform$file.sep, 
                                     fixed = TRUE))
  sub_dir <- file_components[2]
  md_name <- file_components[3]
  dir_out <- file.path(dest_dir, sub_dir)

  if (ext == "Rmd") {
    rmarkdown::render(file, 
                      output_format = md_document(variant = "markdown_github", 
                                                  preserve_yaml = TRUE), 
                      output_dir = dir_out)
    
    md_filename <- file.path(dir_out, md_name)
    yaml_list <- yaml_from_md(file)
    post_date <- yaml_list$date
    
    # prepend the date to the markdown file name
    dated_md_filename <- file.path(dir_out, 
                                   paste(post_date, md_name, 
                                         sep = "-"))
    file.rename(md_filename, dated_md_filename)
    
    # add the yaml frontmatter back into the md file
    post_text <- readLines(dated_md_filename)

    # move images to right directory & update paths in post
    move_images(dated_md_filename, md_filename, md_name, post_text, Rmd = TRUE)
    
  } else if (ext == "ipynb") {
    cmd <- paste("jupyter nbconvert --to markdown --output-dir", dir_out, file)
    # the following is a hack that I had to use to ensure 
    # that system() recognizes my PATH environmental variable
    # locally on Xubuntu I appended my conda path in ~/.profile
    if (file.exists("~/.bash_profile")) {
      system(paste("source ~/.bash_profile &&", cmd))
    } else {
      # just try to run command, will raise error if Jupyter not in PATH
      system(cmd)
    }
    
    md_filename <- file.path(dir_out, md_name)
    post_text <- readLines(md_filename)

    # remove blank first line from text (y u do dis jupyter?)
    if (post_text[1] == "") {
      post_text <- post_text[-1]
      writeLines(post_text, md_filename)
    }
  
    yaml_list <- yaml_from_md(md_filename)
    post_date <- yaml_list$date
    
    # prepend the date to the markdown file name
    dated_md_filename <- file.path(dir_out, 
                                   paste(post_date, md_name, 
                                         sep = "-"))
    file.rename(md_filename, dated_md_filename)
    
    # move images to right directory & update paths in post
    move_images(dated_md_filename, md_filename, md_name, post_text)
    
  } else if (ext == "md") {
    # extract date from yaml
    yaml_list <- yaml_from_md(file)
    post_date <- yaml_list$date
    
    # move the file to the appropriate location with date prepended
    new_fname <- paste(post_date, md_name, sep = "-")
    new_prefix <- file.path(dest_dir, sub_dir)
    dir_nonexistent <- !dir.exists(new_prefix)
    if (dir_nonexistent) {
      dir.create(new_prefix, recursive = TRUE)
    }
    file.copy(file, file.path(dest_dir, sub_dir, new_fname), overwrite = TRUE)
  } else {
    stop(paste("I don't know how to convert", file, "to a post!"))
  }
}


move_images <- function(dated_md_filename, md_filename, md_name, post_text, 
                        Rmd = FALSE) {
  if (Rmd) {
    image_dir <- gsub("\\.md", replacement = "_files/figure-markdown_github", 
                      x = md_filename)
  } else {
    image_dir <- gsub("\\.md", replacement = "_files", x = md_filename)
  }
  if (dir.exists(image_dir)) {
    # move the images to the right directory
    new_image_dir <- file.path("images", 
                               gsub("\\.md", 
                                    replacement = "_files", 
                                    x = md_name))
    if (dir.exists(new_image_dir)) {
      file.remove(list.files(new_image_dir, full.names = TRUE))
      file.remove(new_image_dir)
    }
    file.rename(image_dir, new_image_dir)
    parent_img_dir <- gsub("\\.md", replacement = "_files", x = md_filename)
    if (dir.exists(parent_img_dir)) {
      file.remove(parent_img_dir)
    }
    stopifnot(!dir.exists(parent_img_dir))
    
    # fix the file paths in the actual post
    if (Rmd) {
      old_image_path <- file.path(getwd(), image_dir)
    } else {
      old_image_path <- unlist(strsplit(new_image_dir, split = .Platform$file.sep))[2]
    }
    new_image_path <- paste0(.Platform$file.sep, new_image_dir)
    post_text <- gsub(old_image_path, 
                      new_image_path, 
                      post_text)
    writeLines(post_text, dated_md_filename)
  }
}


yaml_from_md <- function(md_filename){
  # extract the yaml frontmatter from md file
  # returns an R list
  text <- readLines(md_filename)
  yaml_braces <- which(text == "---")
  stopifnot(length(yaml_braces) == 2)
  frontmatter <- text[(yaml_braces[1] + 1):(yaml_braces[2] - 1)]
  stopifnot(length(frontmatter) > 0)
  yaml_list <- list.parse(paste(frontmatter, collapse = "\n"), "yaml")
  yaml_list
}


if (length(files_to_convert) > 0) {
  pb <- txtProgressBar(min = 0, max = length(files_to_convert), style = 3)
  for (i in seq_along(files_to_convert)) {
    make_post(files_to_convert[i])
    setTxtProgressBar(pb, i)
  }
}
