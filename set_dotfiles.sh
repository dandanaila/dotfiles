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
  echo "Copying file $FILE to ~/$FILE"
  ln "$FILE" "$HOME/$FILE"
done
