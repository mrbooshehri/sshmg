
#!/usr/bin/bash
# shellcheck disable=SC1090

# If not running interactively, don't do anything
case $- in
*i*) ;; # interactive
*) return ;; 
esac

# ---------------------- local utility functions ---------------------

_have()      { type "$1" &>/dev/null; }
_source_if() { [[ -r "$1" ]] && source "$1"; }

# ----------------------- environment variables ----------------------
#                           (also see envx)

export USER="$(whoami)"
export TERM=xterm-256color
export HRULEWIDTH=73
export EDITOR=vim
export VISUAL=vim
export EDITOR_PREFIX=vim
export LESS_TERMCAP_mb="[35m" # magenta
export LESS_TERMCAP_md="[33m" # yellow
export LESS_TERMCAP_me="" # "0m"
export LESS_TERMCAP_se="" # "0m"
export LESS_TERMCAP_so="[34m" # blue
export LESS_TERMCAP_ue="" # "0m"
export LESS_TERMCAP_us="[4m"  # underline

[[ -d /.vim/spell ]] && export VIMSPELL=("$HOME/.vim/spell/*.add")

# ------------------------ bash shell options ------------------------

shopt -s checkwinsize
shopt -s expand_aliases
shopt -s globstar
shopt -s dotglob
shopt -s extglob
shopt -s cdspell

# ------------------------------ history -----------------------------

export HISTCONTROL=ignoreboth
export HISTSIZE=5000
export HISTFILESIZE=10000

set -o vi
shopt -s histappend

# ------------------------------ aliases -----------------------------
#      (use exec scripts instead, which work from vim and subprocs)

unalias -a
alias ls='ls --color=auto --group-directories-first'
alias free='free -h'
alias df='df -h'
alias rm='rm -i'
alias mv='mv -i'
alias chmox='chmod +x'
alias temp='cd $(mktemp -d)'
alias view='vi -R' # which is usually linked to vim
alias clear='printf "\e[H\e[2J"'
alias grep="grep -P"
alias clip="xsel -bi"
alias ll="ls -l"
alias la="ls -la"

#alias autoremove="sudo pacman -Rns $(pacman -Qdtq)"
alias ..="cd .."
alias :q="exit"

_have vim && alias vi=vim

# ----------------------------- keyboard -----------------------------

_have setxkbmap && test -n "$DISPLAY" && \
  setxkbmap -option caps:escape &>/dev/null

## ----------------------------- functions ----------------------------


# ------------- colorize man page ------------------------------------
man() {
    LESS_TERMCAP_md=$'\e[01;31m' \
    LESS_TERMCAP_me=$'\e[0m' \
    LESS_TERMCAP_us=$'\e[01;32m' \
    LESS_TERMCAP_ue=$'\e[0m' \
    LESS_TERMCAP_so=$'\e[45;93m' \
    LESS_TERMCAP_se=$'\e[0m' \

    command man "$@"
}

# ------------- source external dependencies / completion ------------

owncomp=(
  fuzzy-ssh
)
