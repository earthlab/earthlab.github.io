library(readr)
options(stringsAsFactors = FALSE)

# Helper functions for building the website -------------------------------

list_posts <- function() {
  # returns a vector with all of the markdown files in the _posts/ directory
  post_dir <- "_posts"
  md_files <- post_dir %>%
    file.path(list.files(post_dir, pattern = "\\.md",
                         recursive = TRUE, include.dirs = TRUE))
  md_files[!grepl("readme.md", md_files)]
}

yaml2df <- function(file, field) {
  # extract "element" field from yaml frontmatter
  # args:
  #   - file (string) a path to a markdown file with yaml frontmatter
  #   - field (string) a yaml field, e.g., authors, lib
  # returns:
  #   - data frame with file, field, and value (one row per element)
  
  first_n_lines <- read_lines(file, n_max = 100) # should contain frontmatter
  delims <- which(grepl(pattern = "---", x = first_n_lines))
  yaml_list <- first_n_lines[(delims[1] + 1):(delims[2] - 1)] %>%
    paste(collapse = "\n") %>%
    yaml.load()
  
  field_does_not_exist <- !(field %in% names(yaml_list))
  if (field_does_not_exist) {
    warning(paste(field, "does not exist in yaml frontmatter of", file, "\n"))
    return(data.frame(value = NULL, slug = NULL))
  }
  
  empty_field <- is.null(yaml_list[[field]]) | length(yaml_list[[field]]) == 0
  if (empty_field) {
    warning(paste(field, "has no entries in", file, "\n"))
    return(data.frame(value = NULL, slug = NULL))
  }
  
  # make a data frame with a row for each field element
  df <- yaml_list[[field]] %>%
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
