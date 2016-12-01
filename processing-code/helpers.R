library(readr)
options(stringsAsFactors = FALSE)

# Helper functions for building the website -------------------------------

list_posts <- function() {
  # returns a vector with all of the markdown files in the _posts/ directory
  post_dir <- "_posts"
  md_files <- post_dir %>%
    file.path(list.files(post_dir, pattern = "\\.md",
                         recursive = TRUE, include.dirs = TRUE))
  md_files
}




yaml2df <- function(file, field) {
  # extract "element" field from yaml frontmatter
  # args:
  #   - file (string) a path to a markdown file with yaml frontmatter
  #   - field (string) a yaml field, e.g., authors, lib
  # returns:
  #   - data frame with file, field, and value (one row per element)
  
  first_n_lines <- read_lines(file, n_max = 100) # should contain frontmatter
  field_colon <- paste0(field, ":")
  field_line <- first_n_lines[grep(field_colon, first_n_lines)]
  
  field_does_not_exist <- is.na(field_line[1])
  if (field_does_not_exist) {
    warning(paste(field, "does not exist in yaml frontmatter of", file, "\n"))
    return(data.frame(value = NULL, slug = NULL))
  }
  
  field_is_empty <- field_line == field_colon
  if (field_is_empty) {
    warning(paste(field, "has no entries in", file, "\n"))
    return(data.frame(value = NULL, slug = NULL))
  }
  
  # remove "field: " and square brackets
  field_line <- gsub(pattern = paste0(field_colon, " "), 
                     x = field_line, 
                     replacement = "" )
  field_line <- gsub(pattern = "\\]|\\[", x = field_line, replacement = "" )
  
  # make a data frame with a row for each field element
  df <- field_line %>%
    strsplit(split = ",") %>%
    unlist() %>%
    data.frame()
  names(df) <- "value"
  
  # remove spaces and make lowercase: "Matt Oakley -> matt-oakley
  df %>%
    mutate(file = file, 
           field = field, 
           value = trimws(value)) %>%
    select(file, field, value)
}


firstup <- function(x) {
  # capitalize first letter of a string
  substr(x, 1, 1) <- toupper(substr(x, 1, 1))
  x
}
