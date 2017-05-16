# Verify that all topics and subtopics in posts: ------------------

# 1. Exist and are associated with the correct topic in 
#     earthlab.github.io/_data/topics.yml
# 2. Exist as markdown files in earthlab.github.io/org/topics/

library(yaml)
library(dplyr)
library(tools)
source("processing-code/helpers.R")

md_files <- list_posts()


# find topics and subtopics cited in posts
value_df <- lapply(md_files, yaml2df, "topics") %>%
  bind_rows()

values_in_posts <- distinct(value_df, value)

subvalues_in_posts <- value_df %>%
  filter(!is.na(subvalue)) %>%
  distinct(value, subvalue)


# Check that topics and subtopics are present in _data/topics.yml --------

reference_yaml_path <- "_data/topics.yml"

reference_yaml <- readLines(reference_yaml_path) %>%
  paste(collapse = "\n") %>%
  yaml.load() %>%
  lapply(unlist, use.names = TRUE)

reference_df <- tibble(value = rep(names(reference_yaml), 
                                                lapply(reference_yaml, length)), 
                              subvalue = c(unlist(reference_yaml)))



# verify that all topics cited in posts exist in the reference yaml
reference_topics <- distinct(reference_df, value) %>% unlist %>% c

values_in_reference <- values_in_posts$value %in% reference_topics
if (any(!values_in_reference)) {
  stop(paste("The following topic(s) have been referenced in a post, 
             but not in the topics.yml file:\n", 
             values_in_posts$value[!values_in_reference]))
}



# verify that all subtopics cited in posts exist in reference yaml
print_and_capture <- function(x){
  # from http://stackoverflow.com/questions/26083625/how-do-you-include-data-frame-output-inside-warnings-and-errors
  paste(capture.output(print(x)), collapse = "\n")
}

subvalues_to_flag <- setdiff(subvalues_in_posts, reference_df)
if (nrow(subvalues_to_flag) > 0) {
  stop(paste("Subtopics were used in a post, but not defined in topics.yml:\n", 
             print_and_capture(subvalues_to_flag), "\n", "\n"))
}





# Check that each subtopic and topic has md file --------------------------
topic_path <- file.path("org", "topics")

# files and directories that *should* exist
expected_topic_files <- file.path(topic_path, paste0(reference_topics, ".md"))
expected_topic_dirs <- gsub(expected_topic_files, 
                            pattern = ".md", replacement = "")
expected_subtopic_files <- reference_df %>%
  mutate(path = file.path(topic_path, value, paste0(subvalue, ".md"))) %>%
  `[[`("path")

# match directories, creating ones that don't exist yet and deleting old ones
dirs_exist <- expected_topic_dirs %in% list.dirs(topic_path, full.names = TRUE)
if (!all(dirs_exist)) {
  dirs_to_create <- expected_topic_dirs[!dirs_exist]
  sapply(dirs_to_create, dir.create)
}
extra_dirs <- list.dirs(topic_path, full.names = TRUE) %>%
  setdiff(c(topic_path, expected_topic_dirs))
any_extra_dirs <- length(extra_dirs) > 0
if (any_extra_dirs) {
  unlink(extra_dirs, recursive = TRUE)
}




# match topic markdown files, creating missing files and deleting unneeded ones
make_topic_file <- function(file) {
  # saves a markdown file for each topic or subtopic
  # args:
  #   - file (character string of files that need making)
  # returns nothing

  # main topics have three elements (e.g., org/topics/remote-sensing)  
  is_main_topic <- 3 == strsplit(file, split = .Platform$file.sep) %>%
    unlist() %>%
    length()
  
  slug <- file %>%
    gsub(pattern = paste0(topic_path, .Platform$file.sep), replacement = "") %>%
    gsub(pattern = ".md", replacement = "")
  
  pretty_name <- slug %>%
    gsub(pattern = "-", replacement = " ") %>%
    gsub(pattern = .Platform$file.sep, replacement = " - ") %>%
    tools::toTitleCase() %>%
    trimws
  
  topic_list_entry <- list(ifelse(is_main_topic, 
                                  NA, 
                                  basename(slug)))
  names(topic_list_entry) <- gsub(pattern = "\\/.*", 
                                     replacement = "", 
                                     x = slug)
  
  topic_list <- list(layout = "post-by-category",
                     title = pretty_name,
                     permalink = paste0("/tags/", slug, "/"),
                     comments = FALSE,
                     author_profile = FALSE,
                     `is-main-topic` = is_main_topic, 
                     topics = topic_list_entry)
  
  
  # convert to yaml
  topic_yaml <- as.yaml(topic_list) %>%
    fix_booleans() %>%
    gsub(pattern = "\n  ", replacement = " ") %>%
    quote_field(field = "title") %>%
    gsub(pattern = "topics:", replacement = "topics:\n ") %>%
    # dealing with case-specific case-sensitivities...
    gsub(pattern = " Gis", replacement = " GIS") %>%
    gsub(pattern = "Github", replacement = "GitHub") %>%
    gsub(pattern = "Rmarkdown", replacement = "R Markdown") %>%
    gsub(pattern = "Csv", replacement = "csv (comma separated values)") %>%
    gsub(pattern = "Geotiff", replacement = "GeoTIFF") %>%
    gsub(pattern = "Hdf5", replacement = "HDF5") %>%
    gsub(pattern = "Json", replacement = "JSON") %>%
    gsub(pattern = "Modis", replacement = "MODIS") %>%
    gsub(pattern = "Naip", replacement = "NAIP") %>%
    gsub(pattern = ".na", replacement = "", fixed = TRUE)
  
  # save md file
  cat(paste0("---\n",
             topic_yaml,
             "\n",
             "---\n"),
      file = file)
}


extant_topic_files <- list.files(topic_path, 
                                 pattern = ".md", 
                                 full.names = TRUE)
topic_files_exist <- expected_topic_files %in% extant_topic_files

files_to_make <- expected_topic_files[!topic_files_exist]
sapply(files_to_make, make_topic_file)


# remove uneeded topic files
updated_topic_files <- list.files(topic_path, 
                                 pattern = ".md", 
                                 full.names = TRUE)

setdiff(updated_topic_files, expected_topic_files) %>%
  unlink()


# check for missing subtopic files
final_topic_files <- list.files(topic_path, 
                              pattern = ".md", 
                              full.names = TRUE)

extant_subtopic_files <- list.files(topic_path, 
                                    pattern = ".md", 
                                    full.names = TRUE, 
                                    recursive = TRUE) %>%
  setdiff(final_topic_files)
subtopic_files_exist <- expected_subtopic_files %in% extant_subtopic_files

subtopic_md_to_make <- expected_subtopic_files[!subtopic_files_exist]

# create missing subtopic files
sapply(subtopic_md_to_make, make_topic_file)
