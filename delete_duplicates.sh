#! bin/bash

# generate a list of the number of occurrences for each file, ignoring date
POSTS=$(ls _posts/)

# cycle through the list
for f in $POSTS;
  do
    # replace all numbers in existing post filenames
    NO_NUMBERS=${f:11:999999}
    N_MATCHES=$(ls _posts/*$NO_NUMBERS | wc -l)

    if [ "$N_MATCHES" -gt "1" ];
      then
      echo "Duplicates found for $NO_NUMBERS";
      ls -tp _posts/*$NO_NUMBERS | grep -v '/$' | tail -n +2 | tr '\n' '\0' | xargs -0 rm --
    fi

  done
