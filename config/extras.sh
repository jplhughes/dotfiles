#-------------------------------------------------------------
# zsh extra settings
#-------------------------------------------------------------

setopt RM_STAR_WAIT              # Wait when typing `rm *` before being able to confirm
setopt NO_BEEP                   # Don't beep on errors in ZLE
setopt HIST_REDUCE_BLANKS        # Remove superfluous blanks before recording entry.
setopt HIST_IGNORE_SPACE         # Don't record an entry starting with a space.
setopt HIST_NO_STORE             # Remove the history (fc -l) command from the history.
setopt EXTENDED_HISTORY          # Write the history file in the ":start:elapsed;command" format.
setopt HIST_SAVE_NO_DUPS         # Don't write duplicate entries in the history file.
setopt HIST_EXPIRE_DUPS_FIRST    # Expire duplicate entries first when trimming history.
setopt HIST_FIND_NO_DUPS         # Do not display a line previously found.
setopt completealiases
setopt always_to_end
setopt list_ambiguous
export HISTSIZE=100000 # big big history
export HISTFILESIZE=100000 # big big history
unsetopt hup
unsetopt list_beep
skip_global_compinit=1
zstyle ':completion:*' hosts off

# Set Up and Down arrow keys to the (zsh-)history-substring-search plugin
# `-n` means `not empty`, equivalent to `! -z`
[[ -n "${terminfo[kcuu1]}" ]] && bindkey "${terminfo[kcuu1]}" history-substring-search-up
[[ -n "${terminfo[kcud1]}" ]] && bindkey "${terminfo[kcud1]}" history-substring-search-down

# Uncomment this to set the history search to match the prefix. It's used in the zsh-history-substring-search plugin,
# and it just checks if this variable is defined, not what the value is.
# export HISTORY_SUBSTRING_SEARCH_PREFIXED=true

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

# ls after every cd
function chpwd() {
 emulate -L zsh
 ls
}


# git add ci and push
function git_prepare() {
   if [ -n "$BUFFER" ]; then
	BUFFER="git add -u && git commit -m \"$BUFFER\" "
   fi

   if [ -z "$BUFFER" ]; then
	BUFFER="git add -u && git commit -v "
   fi

   zle accept-line
}
zle -N git_prepare
bindkey -r "^G"
bindkey "^G" git_prepare

explain () {
  if [ "$#" -eq 0 ]; then
    while read  -p "Command: " cmd; do
      curl -Gs "https://www.mankier.com/api/explain/?cols="$(tput cols) --data-urlencode "q=$cmd"
    done
    echo "Bye!"
  elif [ "$#" -eq 1 ]; then
    curl -Gs "https://www.mankier.com/api/explain/?cols="$(tput cols) --data-urlencode "q=$1"
  else
    echo "Usage"
    echo "explain                  interactive mode."
    echo "explain 'cmd -o | ...'   one quoted command to explain it."
  fi
}

extract () {
   if [ -f $1 ] ; then
       case $1 in
           *.tar.bz2)   tar xvjf $1    ;;
           *.tar.gz)    tar xvzf $1    ;;
           *.bz2)       bunzip2 $1     ;;
           *.rar)       unrar x $1       ;;
           *.gz)        gunzip $1      ;;
           *.tar)       tar xvf $1     ;;
           *.tbz2)      tar xvjf $1    ;;
           *.tgz)       tar xvzf $1    ;;
           *.zip)       unzip $1       ;;
           *.Z)         uncompress $1  ;;
           *.7z)        7z x $1        ;;
           *)           echo "don't know how to extract '$1'..." ;;
       esac
   else
       echo "'$1' is not a valid file!"
   fi
 }