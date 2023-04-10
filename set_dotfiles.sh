#!/bin/bash

ignore_list=("." ".." ".git" ".gitignore")

for FILE in .*; do
  should_ignore=0
  for elem in "${ignore_list[@]}"; do
    if [[ "$FILE" = "$elem" ]]; then
      should_ignore=1
      break
    fi
  done
  if [[ $FILE =~ .*.sw[a-p] ]]; then
    should_ignore=1
  fi
  if [[ should_ignore -eq 1 ]]; then
    continue
  fi
  new_location="$HOME/$FILE"
  cur_location="$PWD/$FILE"
  if [[ -L "$new_location" ]]; then
    echo "'$new_location' is already a link!"
    continue
  fi
  if [[ -f "$new_location" ]]; then
    rm -rf "$new_location"
    echo "'$new_location' is a file (not a link). Replacing it with a symlink."
  fi
  echo "Symlinking '$cur_location' to '$new_location'"
  ln -s "$cur_location" "$new_location"
done
