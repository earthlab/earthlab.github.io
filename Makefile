# makefile for the Jekyll tutorials site
TUTORIAL_FOLDER = tutorials
GIT_PATH = https://github.com/earthlab/$(TUTORIAL_FOLDER).git

build:
		# Download Jupyter notebooks from GitHub
		rm -rf $(TUTORIAL_FOLDER)
		git clone $(GIT_PATH)
		
		# convert tutorials to markdown
		Rscript --vanilla processing-code/generate_posts.R
		
		# loop over tutorials and ensure that any libraries used are listed in 
		# _data/libs.yml
		Rscript --vanilla processing-code/validate_libs.R
		
		# write author yaml and markdown files to generate pages
		Rscript --vanilla processing-code/validate_authors.R

		# clean up
		rm -rf $(TUTORIAL_FOLDER)
