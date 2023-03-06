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
echo "Install Java code formatter."
brew install google-java-format
echo "Installing Java19 as it is dependency for eclipselsp."
DIR=~/lwcode/java
mkdir "$DIR"
(cd "$DIR" && \
  wget https://download.oracle.com/java/19/latest/jdk-19_linux-x64_bin.deb)
yes | sudo apt install "$DIR"/jdk-19_linux-x64_bin.deb
sudo update-alternatives --install /usr/bin/java java /usr/lib/jvm/jdk-19/bin/java 1
sudo update-alternatives --install /usr/bin/javac javac /usr/lib/jvm/jdk-19/bin/javac 1
sudo update-alternatives --install /usr/bin/jar jar /usr/lib/jvm/jdk-19/bin/jar 1
echo 2 | sudo update-alternatives --config java
echo 2 | sudo update-alternatives --config javac
echo 2 | sudo update-alternatives --config jar
export JAVA_HOME=/usr/lib/jvm/jdk-19
echo "Install eclipselsp for Java linting."
DIR=~/lwcode/eclipselsp
if [ -d "$DIR" ];
then
  echo "Eclipselsp is already installed."
else
  echo "Cloning repo..."
  git clone https://github.com/eclipse/eclipse.jdt.ls.git "$DIR"
  echo "Start the installation..."
  (cd "$DIR" && ./mvnw clean verify -DskipTests=true)
fi
echo "Install the plugins for VIM via Plug."
vim +PlugInstall +qall
echo "Update the plugins for VIM via Plug."
vim +PlugUpdate +qall
echo "Ensure that dans-playground is cloned."
# DIR=~/lwcode/dans-playground
# if [ -d "$DIR" ];
# then
#   echo "dans-playground is already cloned."
# else
#   (cd ~lwcode/ && git clone https://github.com/lacework-dev/dans-playground)
# fi
# echo "Fix timezone of machine."
# sudo apt install tzdata << EOF
#   11
#   10
#   11
# EOF
