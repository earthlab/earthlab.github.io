#!/bin/bash

# Sometimes we add or delete images on the website. these images are not tied
# To the autobuild, they are images we find and add to a page. You can directly delete
# These images with a given path. This scripts automates deleting added images

if [[ -f deleted_image_files.txt ]]
then
  echo -e "Deleting the following images:"
  cat deleted_image_files.txt | while read line
  do
    echo $line
    image_to_delete=~/earthlab.github.io/$line
    rm $image_to_delete
  done
else
  echo "There are no individual images to remove in this PR!"
fi


# When a markdown file or a post is deleted, it has an additional step that requires seeing if there are images
# associated with that post and removing those. The images have a similar path to the post however they are located in
# the images dir This handles this part of the build.

if [[ -f deleted_md_files.txt ]]
then
  echo -e "Deleting the following notebooks and their images:"
  cat deleted_md_files.txt | while read line
  do
    post_to_delete=~/earthlab.github.io/$line
    echo -e "Deleting the following post and it's associated images:"
    echo "$post_to_delete"
    rm $post_to_delete

    # Remove images dir associated with post
    image_dir_to_delete=~/earthlab.github.io/images/${line%.*}
    echo -e "I will delete the images for this post too:"
    echo "$image_dir_to_delete"
    rm -rf $image_dir_to_delete
  done
else
  echo "There are no lessons and associated lesson images to remove in this PR!"
fi