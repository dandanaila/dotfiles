#!/bin/bash

install_cmd() {
  name="$1"
  cmd="$2"
  echo "---------------------------------------"
  echo "[INSTALL][START] $name"
  if ! command -v "$name" &> /dev/null; then
    $cmd
  else
    echo "[INSTALL][STATUS] $name is already installed"
  fi
  echo "[INSTALL][END] $name"
}

./set_dotfiles.sh

echo "Install Plug, a plugin manager for VIM."
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

echo "Update the package sources list with the latest versions of the packages"\
  " in the repositories."
sudo apt update

# Integrated in VIM via ALE as a bash linter.
# Extra: This is an open source static analysis tool that automatically finds
# bugs in your shell scripts.
install_cmd "shellcheck" "sudo apt install shellcheck"

# Integrated in VIM via ALE as bash formatter.
# Extra: A shell parser, formatter, and interpreter. Supports POSIX Shell,
# Bash, and mksh.
install_cmd "shfmt" "go install mvdan.cc/sh/v3/cmd/shfmt@latest"

echo "---------------------------------------"
echo "[INSTALL][START] tabname plugin."
tabname_file="$HOME/.vim/plugin/tabname.vim"
if [[ -f "$tabname_file" ]]; then
  echo "Tabname plugin already installed!"
else
  mkdir ~/.vim/plugin/
  wget -O ~/.vim/plugin/tabname.vim https://www.vim.org/scripts/download_script.php?src_id=6284
fi

install_cmd "jwt" "go install github.com/golang-jwt/jwt/cmd/jwt@latest"

install_cmd "google-java-format" "brew install google-java-format"

echo "---------------------------------------"
echo "[INSTALL][START] jdk-20."
if [[ -d "/usr/lib/jvm/jdk-20" ]]; then
  echo "jdk-20 is already installed."
else
  DIR=~/lwcode/java
  mkdir "$DIR"
  (cd "$DIR" && \
    wget https://download.oracle.com/java/20/latest/jdk-20_linux-x64_bin.deb)
  yes | sudo apt install "$DIR"/jdk-20_linux-x64_bin.deb
  sudo update-alternatives --install /usr/bin/java java /usr/lib/jvm/jdk-20/bin/java 1
  sudo update-alternatives --install /usr/bin/javac javac /usr/lib/jvm/jdk-20/bin/javac 1
  sudo update-alternatives --install /usr/bin/jar jar /usr/lib/jvm/jdk-20/bin/jar 1
  echo 2 | sudo update-alternatives --config java
  echo 2 | sudo update-alternatives --config javac
  echo 2 | sudo update-alternatives --config jar
fi
echo "[INSTALL][END] jdk-20."

echo "---------------------------------------"
echo "[INSTALL][START] Vim plugins."
echo "Install the plugins for VIM via Plug."
vim +PlugInstall +qall
echo "Update the plugins for VIM via Plug."
vim +PlugUpdate +qall
echo "[INSTALL][END] Vim plugins."

echo "Ensure that dans-playground is cloned."
DIR=~/lwcode/dans-playground
if [ -d "$DIR" ];
then
  echo "dans-playground is already cloned."
else
  (cd ~/lwcode/ && git clone https://github.com/lacework-dev/dans-playground)
fi

echo "---------------------------------------"
echo "[INSTALL][START] Timezone."
sudo apt-get install debconf-doc
sudo ln -fs /usr/share/zoneinfo/US/Pacific /etc/localtime
DEBIAN_FRONTEND=noninteractive sudo apt-get install -y --no-install-recommends tzdata
echo "[INSTALL][END] Timezone."
