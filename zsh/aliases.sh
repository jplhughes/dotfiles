#!/bin/zsh

# -------------------------------------------------------------------
# personal
# -------------------------------------------------------------------

alias cdg="cd ~/git"
alias ve="source ~/venv/bin/activate"
alias jl="jupyter lab"
alias spy="tail -f"
alias c19="ssh johnh@code19.cantabresearch.com"
alias zshconfig="cd ~/git/dotfiles/zsh"
alias tbl='~/git/dotfiles/scripts/local_tensorboard_launch.sh'
alias tbr='~/git/dotfiles/scripts/remote_tensorboard_launch.sh'


# -------------------------------------------------------------------
# general
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

#-------------------------------------------------------------
# git
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


#-------------------------------------------------------------
# tmux
#-------------------------------------------------------------

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
alias la='ls -Al'         # show hidden files
alias lx='ls -lXB'        # sort by extension
alias lk='ls -lSr'        # sort by size, biggest last
alias lc='ls -ltcr'       # sort by and show change time, most recent last
alias lu='ls -ltur'       # sort by and show access time, most recent last
alias lt='ls -ltr'        # sort by date, most recent last
alias lm='ls -al |more'   # pipe through 'more'
alias lr='ls -lR'         # recursive ls
alias tree='tree -Csu'    # nice alternative to 'recursive ls'