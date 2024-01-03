# If not running interactively, don't do anything
case $- in
  *i*) ;;
  *) return;;
esac

shopt -s checkwinsize

[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"


if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
  debian_chroot=$(cat /etc/debian_chroot)
fi

case "$TERM" in
  xterm-color) color_prompt=yes;;
esac

force_color_prompt=yes

parse_git_branch() {
  git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/[\1]/'
}

export PS1="\u@\h \[\e[32m\]\w \[\e[91m\]\$(parse_git_branch)\[\e[00m\]$ "

PS1='${debian_chroot:+($debian_chroot)}\[\033[1;31m\]\u\[\033[1;33m\]@\[\033[1;34m\]\h\[\033[00m\]:\[\033[1;33m$(parse_git_branch)\[\033[01;34m\]\w\[\033[01;31m\]\[\033[00m\]\n\$ '

alias ls='ls --color=auto'
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'


if [ -f ~/.bash_aliases ]; then
  . ~/.bash_aliases
fi

if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

my_start_tmux() {
  dir=${1:-~/lwcode}
  cd "$dir" && tmux new-session \; \
    split-window -v \; \
    select-pane -t 0 \; \
    resize-pane -D 20 \; \
    new-window \; \
    split-window -v \; \
    previous-window \;
}
alias start-tmux=my_start_tmux

# Make CTRL W delete previous word where word is defined to be alpha-numerical
# string (man readline).
stty werase undef
bind '\C-w:backward-kill-word'

add_to_path() {
  if ! [[ "$PATH" == *"$1"* ]]; then
    PATH+=":$1"
  fi
}

if ! [[ "$PATH" == "/usr/local/bin"* ]]; then
  PATH="/usr/local/bin:$PATH"
fi
add_to_path "$HOME/go/bin"
if [[ -n $HOMEBREW_PREFIX ]]; then
  add_to_path "$HOMEBREW_PREFIX/bin"
fi
add_to_path "/opt/pyenv/versions/3.9.16/bin"
add_to_path "~/.local/bin"
export PATH
export EDITOR='vim'
export VISUAL='vim'
export JAVA_HOME=/usr/lib/jvm/java-1.8.0-amazon-corretto/

alias lwbgs=~/lwcode/dans-playground/scripts/gh-search.sh
alias format_java="JAVA_HOME=/usr/lib/jvm/jdk-20 google-java-format -i -a"
alias git_sl="git log --graph --oneline --branches"
alias git_rebase_latest='CURRENT_BRANCH="$(git rev-parse --abbrev-ref HEAD)"; git checkout main && git pull origin main && git checkout "$CURRENT_BRANCH" && git rebase -i main'

export AWS_SDK_LOAD_CONFIG=true # Needed for some tools to use SSO auth
export LW_AWS_CREDENTIALS_FILE=~/.aws/credentials

export HOST=localhost
export WAREHOUSE=DEV_TEST
export LW_HOST_ENV_TYPE=local

# login to platform/dev
alias argologin-dev='argocd login argocd.ops.lacework.engineering  --grpc-web-root-path /platform/dev --sso'
# sync an app given environment and app name
argosync() {
    if [ $# -lt 2 ]; then
        echo "Usage: argosync env appname [other args]"
        echo "Example: argosync gdevus1 gbm-runner [--async]"
        return 1
    fi

    local env="$1"
    shift

    local appname="$1"
    shift

    echo Running: argocd app sync argocd-platform-dev/"$appname"-"$env" "$@"
    argocd app sync argocd-platform-dev/"$appname"-"$env" "$@"
}
# change target revision given environment, appname and branch
argotest() {
    if [ $# -lt 3 ]; then
        echo "Usage: argotest env appname branchname [other args]"
        echo "Example: argosync gdevus1 gbm-runner GLACE-123 [--async]"
        return 1
    fi

    local env="$1"
    shift

    local appname="$1"
    shift

    local branchname="$1"
    shift

    echo Setting targetRevision: argocd app patch argocd-platform-dev/"$appname"-"$env" --patch '[{"op": "replace", "path": "/spec/source/targetRevision", "value": "'"$branchname"'"}]'
    argocd app patch argocd-platform-dev/"$appname"-"$env" --patch '[{"op": "replace", "path": "/spec/source/targetRevision", "value": "'"$branchname"'"}]'
    argosync $env $appname
}
