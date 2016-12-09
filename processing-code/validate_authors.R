
# Script to generate author yaml and md files from posts ------------------

# First, load some libraries that we'll need to write the YAML

### This code reads through a set of files and parses out the YAML tags
### It then builds a yml list
### holy sweet awesomeness batman!
library(yaml)
library(dplyr)
source("processing-code/helpers.R")
# Then setup the code to grab all .md files in the _posts directory 
# and save the `authors.yml` file.

# produce the authors.yaml file -----------------------------------------
md_files <- list_posts()

# find all unique authors in the markdown files
authors <- lapply(md_files, yaml2df, "authors") %>%
  bind_rows() %>%
  mutate(name = value,
         slug = tolower(gsub(pattern = " ", x = value, replacement = "-"))) %>%
  select(name, slug) %>%
  unique() %>%
  arrange(slug)

finalYAML <- yaml::as.yaml(authors, column.major = FALSE)

# save output (do we need to prepend "_data/"?)
cat(finalYAML, file = "_data/authors.yml")


# Finally, for each author, save a markdown file that looks like:

# ---
# layout: post-by-author
# author: Matt Oakley
# permalink: /authors/matt-oakley/
# title: 'Matt Oakley'
# author_profile: false
# site-map: true
# ---

gen_author_profiles <- function(authors, prefix = "org/authors") {
  # saves a markdown file for each author that will list their posts
  # args:
  #   - authors (data.frame consisting of the author name and slug)
  #   - prefix (string, specifying the destination directory for md files)
  # returns nothing
  for (i in 1:nrow(authors)) {
    # make a list with the name, layout, etc.
    auth_list <- list(layout = "post-by-author",
                      author = authors$name[i],
                      permalink = paste0("/authors/", authors$slug[i], "/"),
                      title = authors$name[i],
                      author_profile = "false",
                      `site-map` = "true")
    # convert to yaml
    auth_yaml <- as.yaml(auth_list)

    # save as md
    out_file <- paste0(paste0(authors$slug[i], ".md"))
    cat(paste0("---\n",
               auth_yaml,
               "---\n"),
        file = file.path(prefix, out_file))
  }
}

gen_author_profiles(authors)
