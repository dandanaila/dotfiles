#!/bin/bash

# Install Plug, a plugin manager for VIM.
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
# Update the package sources list with the latest versions of the packages in
# the repositories.
sudo apt update
# Integrated in VIM via ALE as a bash linter.
# Extra: This is an open source static analysis tool that automatically finds
# bugs in your shell scripts.
sudo apt install shellcheck
# Integrated in VIM via ALE as bash formatter.
# Extra: A shell parser, formatter, and interpreter. Supports POSIX Shell,
# Bash, and mksh.
go install mvdan.cc/sh/v3/cmd/shfmt@latest
# Install the plugins for VIM via Plug.
vim +PlugInstall +qall
# Update the plugins for VIM via Plug.
vim +PlugUpdate +qall
