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
  if [[ -f "$new_location" ]]; then
    echo "Skipping linking for '$FILE' as '$new_location' already exists."
  else
    echo "Linking $FILE to $new_location"
    ln "$FILE" "$HOME/$FILE"
  fi
done
