# Generate author yaml and md files from posts ------------------
library(yaml)
library(dplyr)
source("processing-code/helpers.R")

# produce the authors.yaml file -----------------------------------------
md_files <- list_posts()

# find all unique authors in the markdown files
authors <- lapply(md_files, yaml2df, "authors") %>%
  bind_rows() %>%
  mutate(name = value,
         slug = tolower(gsub(pattern = " ", x = value, replacement = "-"))) %>%
  select(name, slug) %>%
  group_by(name, slug) %>%
  summarize(n = n()) %>%
  arrange(slug)

bios <- read.csv("org/author-bios.csv", stringsAsFactors = FALSE)

authors <- left_join(authors, bios) %>%
  mutate(bio = trimws(bio), 
         bio = ifelse(is.na(bio), "", bio)) %>%
  select(-n)

finalYAML <- yaml::as.yaml(authors, column.major = FALSE) %>%
  quote_field("bio")

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
                      author_profile = FALSE,
                      `site-map` = TRUE, 
                      bio = trimws(authors$bio[i]))
    # convert to yaml
    auth_yaml <- as.yaml(auth_list) %>%
      fix_booleans() %>%
      gsub(pattern = "\n  ", replacement = " ") %>%
      quote_field(field = "title") %>%
      quote_field(field = "bio")

    # save as md
    out_file <- paste0(paste0(authors$slug[i], ".md"))
    cat(paste0("---\n",
               auth_yaml,
               "\n",
               "---\n"),
        file = file.path(prefix, out_file))
  }
}

gen_author_profiles(authors)

# delete unused author markdown files
expected_md_files <- file.path("org", "authors", paste0(authors$slug, ".md"))
extant_md_files <- list.files(file.path("org", "authors"), full.names = TRUE)

setdiff(extant_md_files, expected_md_files) %>%
  unlink
