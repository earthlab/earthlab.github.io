library(dplyr)
library(tools)
library(nbconvertR)
library(yaml)
library(rlist)

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

files_to_convert <- find_files_to_convert("tutorials")


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
    
    # TODO: adapt Leah's code to make posts from Rmd files
    
  } else if (ext == "ipynb") {
    cmd <- paste("jupyter nbconvert --to markdown --output-dir", dir_out, file)
    # the following is a hack that I had to use to ensure 
    # that system() recognizes my PATH environmental variable
    system(paste("source ~/.bash_profile &&", cmd))
    
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

    image_dir <- gsub("\\.md", replacement = "_files", x = md_filename)
    if (dir.exists(image_dir)) {
      # # move the images to the right directory
      new_image_dir <- file.path("images", 
                                 gsub("\\.md", 
                                      replacement = "_files", 
                                      x = md_name))
      file.remove(list.files(new_image_dir, full.names = TRUE))
      file.remove(new_image_dir)
      file.rename(image_dir, new_image_dir)
      
      # fix the file paths in the actual post
      old_image_path <- unlist(strsplit(new_image_dir, split = .Platform$file.sep))[2]
      new_image_path <- paste0(.Platform$file.sep, new_image_dir)
      post_text <- gsub(old_image_path, 
                        new_image_path, 
                        post_text)
      writeLines(post_text, dated_md_filename)
    }
    
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
    file.copy(file, file.path(dest_dir, sub_dir, new_fname))
  } else {
    stop(paste("I don't know how to convert", file, "to a post!"))
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

pb <- txtProgressBar(min = 1, max = length(files_to_convert), style = 3)
for (i in seq_along(files_to_convert)) {
  make_post(files_to_convert[i])
  setTxtProgressBar(pb, i)
}
