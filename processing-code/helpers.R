library(readr)
options(stringsAsFactors = FALSE)

# Helper functions for building the website -------------------------------
posts_to_ignore <- function() {
  # return a character vector of posts to ignore when building
  c("readme", 
    "README",
    "creating-animated-maps-matplotlib")
}

except <- function(files, to_ignore = posts_to_ignore()) {
  # subsets files to exclude things in "to_ignore" by partial string matching
  ignore <- posts_to_ignore() %>%
    paste(collapse = "|") %>%
    grep(files, value = TRUE) %>%
    unique()
  
  files[!(files %in% ignore)]
}

list_posts <- function() {
  # returns a vector with all of the markdown files in the _posts/ directory
  post_dir <- "."
  post_dir %>%
    file.path(list.files(post_dir, pattern = "\\.md",
                         recursive = TRUE, include.dirs = TRUE)) %>%
    except(posts_to_ignore())
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
  
  null_result <- data.frame(value = NULL, slug = NULL)
  
  if (length(delims) == 0) {
    # file does not contain yaml
    return(null_result)
  }
  yaml_list <- first_n_lines[(delims[1] + 1):(delims[2] - 1)] %>%
    paste(collapse = "\n") %>%
    yaml.load()
  
  field_does_not_exist <- !(field %in% names(yaml_list))
  if (field_does_not_exist) {
    return(null_result)
  }
  
  empty_field <- is.null(yaml_list[[field]]) | length(yaml_list[[field]]) == 0
  if (empty_field) {
    return(null_result)
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


fix_booleans <- function(x) {
  # replace yes and no with true and false in a yaml string
  x <- gsub(pattern = ": no\n", 
                    replacement = ": false\n", 
                    x = x)
  x <- gsub(pattern = ": yes\n", 
                    replacement = ": true\n", 
                    x = x)
  x
}


quote_field <- function(x, field) {
  # quotes a field in a yaml string
  # e.g., if in the input we have authors: Bob Dole
  # this should change to authors: 'Bob Dole'
  res <- x %>%
    gsub(pattern = paste0(field, ": "), 
         replacement = paste0(field, ": '")) %>%
    gsub(pattern = "\n   ", replacement = "", fixed = TRUE) %>% # rm linewraps
    gsub(pattern = "'{3}", replacement = "'") %>% # handle blank entries
    strsplit("\n") %>%
    unlist()

    which_append <- res %>%
      grep(pattern = field)
    
    res[which_append] <- paste0(res[which_append], "'")
    
    res %>%
      paste(collapse = "\n")
}
