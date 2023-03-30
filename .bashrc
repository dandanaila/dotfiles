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

export PATH="/usr/local/bin:$PATH:$HOME/go/bin"
export EDITOR='vim'
export VISUAL='vim'
export JAVA_HOME=/usr/lib/jvm/java-1.8.0-amazon-corretto/

alias lwbgs=~/lwcode/dans-playground/scripts/gh-search.sh
alias format_java="JAVA_HOME=/usr/lib/jvm/jdk-19 google-java-format -i -a"
alias git_sl="git log --graph --oneline --branches"

export AWS_SDK_LOAD_CONFIG=true # Needed for some tools to use SSO auth
export LW_AWS_CREDENTIALS_FILE=~/.aws/credentials

export HOST=localhost
export WAREHOUSE=DEV_TEST
export LW_HOST_ENV_TYPE=local
