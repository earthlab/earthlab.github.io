#!/usr/bin/env bash

# This script clones the io website given a few different scenarios
# If the branch is not master, we first check to see if the branch exists on the io repo already. if it doesnt
# exist, we create it.
# 2. if the branch is master - we never want to push directly to master (that is the live site)
# in this case we create a new branch called website-autobuild on io and push there instead
# We are being careful here because we are pushing to a repo that runs a LIVE website.

branch=$(head -1 eds-lessons-website/current_branch.txt)
# Only clone eds.org if there are files to commit
if [[ -f ~/eds-lessons-website/website_files.txt ]] || [ -f ~/eds-lessons-website/deleted_files.txt ]
then
  if [ "$branch" != "master" ]
  then
      # check that branch exists on remote earthlab.github.io
      branch_status=$(git ls-remote --heads https://${EDS_LESSONS_GITHUB_TOKEN_EL}@github.com/earthlab/earthlab.github.io.git "$branch" | wc -l)
      # if branch exists, clone it
      if [ $branch_status == 1 ]
      then
        # clone the remote branch
        git clone --depth 1 https://${EDS_LESSONS_GITHUB_TOKEN_EL}@github.com/earthlab/earthlab.github.io.git -b "$branch"
        echo "Looks like the branch doesn't exist on the eds.org website, created branch for you."
      else
        # if the branch doesn't exist, clone master and checkout the branch as a new branch
        git clone --depth 1 https://${EDS_LESSONS_GITHUB_TOKEN_EL}@github.com/earthlab/earthlab.github.io.git
        cd earthlab.github.io
        git checkout -b "$branch"
      fi
  else
      # if commits are on master, push to website-autobuild to avoid direct commits to live website
      # check for autobuild branch on website remote
      branch_status=$(git ls-remote --heads https://${EDS_LESSONS_GITHUB_TOKEN_EL}@github.com/earthlab/earthlab.github.io.git "website-autobuild" | wc -l)
      # if branch exists check it out...
      if [ $branch_status == 1 ]
      then
        # clone the remote branch
        git clone -b website-autobuild --depth 1 https://${EDS_LESSONS_GITHUB_TOKEN_EL}@github.com/earthlab/earthlab.github.io.git
      else
        # if it does not, clone master and checkout a new branch
        git clone --depth 1 https://${EDS_LESSONS_GITHUB_TOKEN_EL}@github.com/earthlab/earthlab.github.io.git
        cd earthlab.github.io
        git checkout -b website-autobuild
      fi
  fi
else
  echo "Not cloning as there are no changes to push."
fi