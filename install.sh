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

echo "Checking that latest pip version is used."
/opt/pyenv/shims/python -m pip install --upgrade pip

echo "Install flake8 for Python linting via ALE."
/opt/pyenv/shims/python -m pip install flake8

echo "Install black for Python fixing via ALE."
/opt/pyenv/shims/python -m pip install --upgrade black

# Integrated in VIM via ALE as a bash linter.
# Extra: This is an open source static analysis tool that automatically finds
# bugs in your shell scripts.
install_cmd "shellcheck" "sudo apt install shellcheck"

# Integrated in VIM via ALE as bash formatter.
# Extra: A shell parser, formatter, and interpreter. Supports POSIX Shell,
# Bash, and mksh.
install_cmd "shfmt" "/home/linuxbrew/.linuxbrew/bin/go install mvdan.cc/sh/v3/cmd/shfmt@latest"

echo "---------------------------------------"
echo "[INSTALL][START] tabname plugin."
tabname_file="$HOME/.vim/plugin/tabname.vim"
if [[ -f "$tabname_file" ]]; then
  echo "Tabname plugin already installed!"
else
  mkdir ~/.vim/plugin/
  wget -O ~/.vim/plugin/tabname.vim https://www.vim.org/scripts/download_script.php?src_id=6284
fi

install_cmd "jwt" "/home/linuxbrew/.linuxbrew/bin/go install github.com/golang-jwt/jwt/cmd/jwt@latest"

install_cmd "google-java-format" "/home/linuxbrew/.linuxbrew/bin/brew install google-java-format"

echo "---------------------------------------"
echo "[INSTALL][START] jdk-20."
if [[ -d "/usr/lib/jvm/jdk-20" ]]; then
  echo "jdk-20 is already installed."
else
  DIR=~/lwcode/java
  PKG_NAME=jdk-20_linux-x64_bin.deb
  JAVA_PKG=$DIR/$PKG_NAME
  if [[ -f "$JAVA_PKG" ]]; then
    echo "Package is already downloaded. Skipping that."
  else
    mkdir -p "$DIR"
    (cd "$DIR" && \
      wget https://download.oracle.com/java/20/latest/$PKG_NAME)
  fi
  yes | sudo apt install "$JAVA_PKG"
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

echo "---------------------------------------"
echo "[INSTALL][START] argocd cli."
curl -sSL -o argocd-linux-amd64 https://github.com/argoproj/argo-cd/releases/latest/download/argocd-linux-amd64
sudo install -m 555 argocd-linux-amd64 /usr/local/bin/argocd
rm argocd-linux-amd64
echo "[INSTALL][END] argocd cli."

echo "---------------------------------------"
echo "[INSTALL][START] k9s cli."
brew install derailed/k9s/k9s
echo "[INSTALL][END] k9s cll."
