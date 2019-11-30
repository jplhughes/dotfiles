#!/bin/zsh

# env
export LD_LIBRARY_PATH=/usr/local/lib:/usr/lib:$LD_LIBRARY_PATH
export PATH="$HOME/.local/bin:/usr/local/bin:/usr/local/sbin:$PATH"
export PATH="$(brew --prefix coreutils)/libexec/gnubin:/usr/local/bin:$PATH"

# extra aliases
alias deploydf="~/git/dotfiles/deploy.sh local"

# -------------------------------------------------------------------
# speechmatics
# -------------------------------------------------------------------

# tensorboard
alias tbl='~/git/dotfiles/scripts/local_tensorboard_launch.sh'

# port forwarding
pf () {
    if [ "$#" -eq 0 ]; then
        ssh -NL localhost:8888:localhost:8888 johnh@code19.cantabresearch.com
    elif [ "$#" -eq 1 ]; then
        ssh -NL localhost:${1}:localhost:${1} johnh@code19.cantabresearch.com
    elif [ "$#" -eq 2 ]; then
        ssh -NL localhost:${1}:localhost:${1} johnh@${2}.cantabresearch.com
    else
        echo "Usage: pf <port> <codex>" >&2
    fi
}