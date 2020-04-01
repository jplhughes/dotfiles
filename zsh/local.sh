#!/bin/zsh

# env
export LD_LIBRARY_PATH=/usr/local/lib:/usr/lib:$LD_LIBRARY_PATH
export PATH="$HOME/.local/bin:/usr/local/bin:/usr/local/sbin:$PATH"
export PATH="$(brew --prefix coreutils)/libexec/gnubin:/usr/local/bin:$PATH"

# jupyter lab
alias jl="jupyter lab"

# gitlab
alias gconfig='git config user.name "John Hughes" && git config user.email "johnh@speechmatics.com"'

# port forwarding
alias pf='~/git/dotfiles/scripts/local_port_forward.sh'
