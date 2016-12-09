# List all libs used in posts in _data/libs.yml --------
library(dplyr)
library(tidyr)
library(yaml)
source("processing-code/helpers.R")

libs_yaml <- yaml.load_file("_data/libs.yml")

# for each post, pull out the language and libraries used -----------------
posts <- list_posts()


langs <- vector(length = length(posts), mode = "list")
libs <- vector(length = length(posts), mode = "list")
for (i in seq_along(posts)) {
  langs[[i]] <- yaml2df(posts[i], "lang")
  libs[[i]] <- yaml2df(posts[i], "lib")
}

langs <- langs %>%
  bind_rows() %>%
  select(file, field, value)

libs <- libs %>%
  bind_rows() %>%
  select(file, field, value)



# Then, identify libs are used in posts but not in _data/libs.yml ---------

crossref_libs <- function(df, libs_yaml) {
  # crossreference languages and libraries used with _data/libs.yml
  # input:
  #   - df (data.frame): a data frame with file, field, and value
  # output: 
  #   - data.frame with following columns:
  #       1) file (chr): source md file for post
  #       2) lang (chr): language e.g., r, python
  #       3) missing_lib (chr): libs used in post, but not in _data/libs.yml
  lang <- df$value[df$field == "lang"]
  libs_in_post <- df$value[df$field == "lib"]
  if (length(unique(lang)) > 1) {
    stop("crossref_libs() assumes that each post has only one tagged language!")
  }
  stopifnot(length(unique(df$file)) == 1)
  
  # find which list to pull from
  which_list <- libs_yaml %>%
    lapply(FUN = function(x) x$lang == lang) %>%
    unlist() %>%
    which()
  
  libs_in_yaml <- libs_yaml[[which_list]]$libs
  missing <- !(libs_in_post %in% libs_in_yaml)
  if (any(missing)) {
    res <- data.frame(file = unique(df$file), 
               lang = lang, 
               missing_lib = libs_in_post[missing])
  } else {
    res <- data.frame(file = NULL, lang = NULL, missing_lib = NULL)
  }
  res
}

missing_df <- langs %>%
  full_join(libs) %>%
  group_by(file) %>%
  do(crossref_libs(., libs_yaml))




# Fill in any missing libs in _data/libs.yml ------------------------

sync_libs_yaml <- function(missing_df, libs_yaml) {
  # If any libs are used in posts, but not in the _data/libs.yml file, this 
  # function will add the missing libraries to the _data/libs.yml file and 
  # overwrite the old _data/libs.yml file. 
  # args: 
  #   - missing_df (data.frame) with all missing libs for each post
  #   - libs_yaml (list) the list generated from our _data/libs.yml file
  # returns: nothing
  if (nrow(missing_df) > 0) {
    
    missing_df <- missing_df %>%
      distinct(lang, missing_lib)
    
    for (i in 1:length(libs_yaml)) {
      lang_df <- subset(missing_df, lang == libs_yaml[[i]]$lang)
      any_missing <- nrow(lang_df) > 0
      
      if (any_missing) {
        libs_yaml[[i]]$libs <- c(libs_yaml[[i]]$libs, 
                                 lang_df$missing_lib) %>%
          unique()
      }
    }
    cat(as.yaml(libs_yaml), file = "_data/libs.yml")
  }
}

sync_libs_yaml(missing_df, libs_yaml)


# Last, generate the md files for each lib, so that the posts get listed ------
libs_yaml <- yaml.load_file("_data/libs.yml")

list_to_df <- function(x) {
  if (!is.null(x$libs)) {
    res <- data.frame(lang = x$lang, libs = x$libs)
  } else {
    res <- data.frame(lang = NULL, libs = NULL)
  }
  res
}

lib_md_df <- lapply(libs_yaml, list_to_df) %>%
  bind_rows() %>%
  mutate(filename = file.path("org", "lang-lib", "libs", paste0(libs, ".md")), 
         exists = file.exists(filename))

# check for libs with same name, but different languages and raise hell
# (we currently do not support this case)
n_langs <- lib_md_df %>%
  group_by(libs) %>%
  summarize(n_lang = length(unique(lang)))
if (any(n_langs$n_lang > 1)) {
  stop("At least one library has the same name for multile languages. \n
       See the 'n_langs' data frame to identify the problem!")
}


# finally, generate md files for any libs that don't already have one
generate_lib_md <- function(df) {
  stopifnot(nrow(df) == 1)
  if (!df$exists) {
    yaml <- list(layout = "post-by-category",
                 category = "tutorials", 
                 title = paste(df$libs, "-", firstup(df$lang), 
                               "Data Intensive Tutorials"),
                 permalink = paste0("/tutorials/software/", 
                                    df$lang, "/", df$libs),
                 comments = "false", 
                 author_profile = "false",
                 language = df$lang, 
                 library = df$libs, 
                 langSide = "true") %>%
      as.yaml()
    
    # save as md
    cat(paste0("---\n",
               yaml,
               "---\n"),
        file = df$filename)
  }
  return(data.frame())
}

lib_md_df %>%
  group_by(filename) %>%
  do(generate_lib_md(.))
