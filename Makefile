# makefile for the Jekyll tutorials site
TUTORIAL_FOLDER = tutorials
GIT_PATH = https://github.com/earthlab/$(TUTORIAL_FOLDER).git

build:
		# Download Jupyter notebooks from GitHub
		rm -rf $(TUTORIAL_FOLDER)
		git clone $(GIT_PATH)
		
		# convert tutorials to markdown
		python convert_notebooks.py $(TUTORIAL_FOLDER) _posts
		# remove duplicates
		bash delete_duplicates.sh

		# build the site
		bundle exec jekyll build

		# clean up
		rm -rf $(TUTORIAL_FOLDER)
