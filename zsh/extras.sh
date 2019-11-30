#!/bin/zsh

#-------------------------------------------------------------
# zsh extra settings
#-------------------------------------------------------------
setopt RM_STAR_WAIT
setopt NO_BEEP
setopt HIST_REDUCE_BLANKS
setopt HIST_IGNORE_SPACE
setopt HIST_NO_STORE
setopt EXTENDED_HISTORY
setopt HIST_SAVE_NO_DUPS
setopt HIST_EXPIRE_DUPS_FIRST
setopt HIST_FIND_NO_DUPS
setopt completealiases
setopt always_to_end
setopt list_ambiguous
export HISTSIZE=100000                   # big big history
export HISTFILESIZE=100000               # big big history
unsetopt hup
unsetopt list_beep
skip_global_compinit=1
COMPLETION_WAITING_DOTS="true"
zstyle ':completion:*' hosts off

# History across tmux windows
setopt inc_append_history
setopt share_history

# ls after every cd
function chpwd() {
    emulate -L zsh
    ls
}

# cd into created directory
function mkcd () {
  case "$1" in /*) :;; *) set -- "./$1";; esac
  mkdir -p "$1" && cd "$1"
}

# alt arrow keys to move
bindkey "^[[1~" beginning-of-line
bindkey "^[[4~" end-of-line

# This speeds up pasting w/ autosuggest
# https://github.com/zsh-users/zsh-autosuggestions/issues/238
pasteinit() {
  OLD_SELF_INSERT=${${(s.:.)widgets[self-insert]}[2,3]}
  zle -N self-insert url-quote-magic # I wonder if you'd need `.url-quote-magic`?
}

pastefinish() {
  zle -N self-insert $OLD_SELF_INSERT
}
zstyle :bracketed-paste-magic paste-init pasteinit
zstyle :bracketed-paste-magic paste-finish pastefinish