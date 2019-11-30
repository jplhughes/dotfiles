# -------------------------------------------------------------------
# zsh
# -------------------------------------------------------------------

clear

export TERM="xterm-256color"

ZSH=$HOME/.oh-my-zsh
ZSH_THEME="powerlevel9k/powerlevel9k"


function sp {
  git branch > /dev/null 2>&1 || return 1
  git config user.initials
}

POWERLEVEL9K_DIR_BACKGROUND='237'
POWERLEVEL9K_CUSTOM_GIT_PAIR="echo \$(sp)"
POWERLEVEL9K_CUSTOM_GIT_PAIR_BACKGROUND="clear"
POWERLEVEL9K_CUSTOM_GIT_PAIR_FOREGROUND="blue"
POWERLEVEL9K_CUSTOM_GIT_PAIR_ICON="\uf7af"
POWERLEVEL9K_DIR_DEFAULT_BACKGROUND="clear"
POWERLEVEL9K_DIR_DEFAULT_FOREGROUND="012"
POWERLEVEL9K_DIR_FOREGROUND='010'
POWERLEVEL9K_DIR_HOME_BACKGROUND="clear"
POWERLEVEL9K_DIR_HOME_FOREGROUND="012"
POWERLEVEL9K_DIR_HOME_SUBFOLDER_BACKGROUND="clear"
POWERLEVEL9K_DIR_HOME_SUBFOLDER_FOREGROUND="012"
POWERLEVEL9K_DIR_PATH_SEPARATOR="%F{008}/%F{cyan}"

POWERLEVEL9K_DIR_ETC_BACKGROUND="clear"
POWERLEVEL9K_ETC_ICON='%F{blue}\uf423'
POWERLEVEL9K_DIR_WRITABLE_FORBIDDEN_FOREGROUND="red"
POWERLEVEL9K_DIR_WRITABLE_FORBIDDEN_BACKGROUND="clear"

POWERLEVEL9K_GO_ICON="\uf7b7"
POWERLEVEL9K_GO_VERSION_BACKGROUND='clear'
POWERLEVEL9K_GO_VERSION_FOREGROUND='081'

POWERLEVEL9K_HOME_ICON="\ufb26"

POWERLEVEL9K_INSTALLATION_PATH=$ANTIGEN_BUNDLES/bhilburn/powerlevel9k

POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(root_indicator dir dir_writable_joined custom_git_pair vcs_joined)
POWERLEVEL9K_LEFT_SUBSEGMENT_SEPARATOR='%F{008}\uf460%F{008}'

POWERLEVEL9K_LINUX_MANJARO_ICON="\uf312 "
POWERLEVEL9K_LINUX_UBUNTU_ICON="\uf31b "

POWERLEVEL9K_MODE='nerdfont-complete'

POWERLEVEL9K_MULTILINE_FIRST_PROMPT_PREFIX=""
POWERLEVEL9K_MULTILINE_LAST_PROMPT_PREFIX=" \uf101 "

POWERLEVEL9K_NVM_BACKGROUND='clear'
POWERLEVEL9K_NVM_FOREGROUND='green'

POWERLEVEL9K_OS_ICON_BACKGROUND='clear'
POWERLEVEL9K_OS_ICON_FOREGROUND='cyan'

POWERLEVEL9K_PROMPT_ADD_NEWLINE=true
POWERLEVEL9K_PROMPT_ON_NEWLINE=true

POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(status go_version nvm os_icon)
POWERLEVEL9K_RIGHT_SEGMENT_SEPARATOR=''
POWERLEVEL9K_RIGHT_SUBSEGMENT_SEPARATOR='%F{008}\uf104%F{008}'

POWERLEVEL9K_SHORTEN_DELIMITER='%F{008} …%F{008}'
POWERLEVEL9K_SHORTEN_DIR_LENGTH=3
POWERLEVEL9K_SHORTEN_STRATEGY="none"

POWERLEVEL9K_STATUS_ERROR_BACKGROUND="clear"
POWERLEVEL9K_STATUS_ERROR_FOREGROUND="001"
POWERLEVEL9K_STATUS_OK_BACKGROUND="clear"
POWERLEVEL9K_STATUS_BACKGROUND="clear"
POWERLEVEL9K_CARRIAGE_RETURN_ICON="\uf071"

POWERLEVEL9K_TIME_FORMAT="%D{%H:%M \uE868  %d.%m}"

POWERLEVEL9K_VCS_CLEAN_BACKGROUND='clear'
POWERLEVEL9K_VCS_CLEAN_FOREGROUND='green'
POWERLEVEL9K_VCS_MODIFIED_BACKGROUND='clear'
POWERLEVEL9K_VCS_MODIFIED_FOREGROUND='yellow'
POWERLEVEL9K_VCS_UNTRACKED_BACKGROUND='clear'
POWERLEVEL9K_VCS_UNTRACKED_FOREGROUND='green'


plugins=(git gitfast pip compleat zsh-syntax-highlighting zsh-autosuggestions zsh-completions history-substring-search tmux)

autoload -U compinit && compinit
source $ZSH/oh-my-zsh.sh

# -------------------------------------------------------------------
# env
# -------------------------------------------------------------------
export LD_LIBRARY_PATH=/usr/local/lib:/usr/lib:$LD_LIBRARY_PATH
export PATH="$HOME/.local/bin:/usr/local/bin:/usr/local/sbin:$PATH"

# -------------------------------------------------------------------
# aliases
# -------------------------------------------------------------------

alias zshrc="vim ~/.zshrc"
alias ohmyzsh="vim ~/.oh-my-zsh"

alias -s gz='tar -xzvf'
alias -s bz2='tar -xjvf'
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'
alias mkdir='mkdir -p'
alias h='history | grep'
alias j='jobs -l'
alias which='type -a'
alias ..='cd ..'
alias ...='cd ../../'
alias ...='cd ../../../'
alias ....='cd ../../../../'
alias .....='cd ../../../../'
alias .4='cd ../../../../'
alias .5='cd ../../../../..'
alias /='cd /'

alias d='dirs -v'
alias 1='cd -1'
alias 2='cd -2'
alias 3='cd -3'
alias 4='cd -4'
alias 5='cd -5'
alias 6='cd -6'
alias 7='cd -7'
alias 8='cd -8'
alias 9='cd -9'

alias path='echo -e ${PATH//:/\\n}'
alias du='du -kh'
alias df='df -kTh'
alias ltx='pdflatex'
alias zrc='vim ~/.zshrc'
alias m='make'
alias mb='make -B'
alias usage='du -sh * 2>/dev/null | sort -rh'
alias dus='du -sckx * | sort -nr'
alias fd='find . -type d -name'
alias ff='find . -type f -name'
alias tgz='tar -zxvf'
alias tbz='tar -jxvf'
alias psg='ps -ef | grep -i $1'
alias man="man -a"
alias busy="cat /dev/urandom | hexdump -C | grep "ca fe""
alias scumbag="ps aux  --sort=-%cpu | grep -m 11 -v `whoami`"
alias rl="readlink -f"
alias t="tail"
alias x='xclip -sel clip'

alias cdc="cd ~/git"
alias ve="source ~/venv/bin/activate"
alias jl="jupyter lab"
alias c19="ssh johnh@code19.cantabresearch.com"
alias ltb='~/git/dotfiles/scripts/local_tensorboard_launch.sh'
alias rtb='~/git/dotfiles/scripts/remote_tensorboard_launch.sh'

#-------------------------------------------------------------
# git and tmux
#-------------------------------------------------------------

alias g="git"
alias ga="git add"
alias gaa="git add ."
alias gc="git commit -m"
alias gp="git push"
alias gpf="git push -f"
alias gpo="git push origin $(current_branch)"

alias gg='git gui'
alias glog='git log --oneline --all --graph --decorate'

alias gf="git fetch"
alias gl="git pull"

alias grb="git rebase"
alias grbm="git rebase master"
alias grbc="git rebase --continue"
alias grbs="git rebase --skip"
alias grba="git rebase --abort"

alias gd="git diff"
alias gs="git status"

alias gco="git checkout"
alias gcb="git checkout -b"
alias gcm="git checkout master"

alias grh="git reset HEAD^"

alias gst="git stash"
alias gstp="git stash pop"
alias gsta="git stash apply"
alias gstd="git stash drop"
alias gstc="git stash clear"

alias ta="tmux attach"
alias taa="tmux attach -t"
alias tad="tmux attach -d -t"
alias td="tmux detach"
alias ts="tmux new-session -s"
alias tl="tmux list-sessions"
alias tkill="tmux kill-server"
alias tdel="tmux kill-session -t"


#-------------------------------------------------------------
# `ls` family
#-------------------------------------------------------------
alias l="ls -CF --color=auto"
alias ll="ls -l --group-directories-first"
alias ls='ls -hF' # add colors for filetype recognition
alias la='ls -Al'         # show hidden files
alias lx='ls -lXB'        # sort by extension
alias lk='ls -lSr'        # sort by size, biggest last
alias lc='ls -ltcr'       # sort by and show change time, most recent last
alias lu='ls -ltur'       # sort by and show access time, most recent last
alias lt='ls -ltr'        # sort by date, most recent last
alias lm='ls -al |more'   # pipe through 'more'
alias lr='ls -lR'         # recursive ls
alias tree='tree -Csu'    # nice alternative to 'recursive ls'



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
zstyle ':completion:*' hosts off


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

bindkey "^[[1~" beginning-of-line
bindkey "^[[4~" end-of-line

#source /home/johnh/git/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
