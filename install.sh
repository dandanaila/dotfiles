#!/bin/bash

curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

sudo apt update
sudo apt install shellcheck
go install mvdan.cc/sh/v3/cmd/shfmt@latest
vim +PlugInstall +qall
vim +PlugUpdate +qall
