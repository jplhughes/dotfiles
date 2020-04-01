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

# gitlab
alias gconfig='git config user.name "John Hughes" && git config user.email "johnh@speechmatics.com"'

# tensorboard
alias tbl='~/git/dotfiles/scripts/local_tensorboard_launch.sh'

# port forwarding
pf () {
    if [ "$#" -eq 0 ]; then
        ssh -NL localhost:8888:localhost:8888 johnh@code19.cantabresearch.com
    elif [ "$#" -eq 1 ]; then
        ssh -NL localhost:${1}:localhost:${1} johnh@code19.cantabresearch.com
    elif [ "$#" -eq 2 ]; then
	destination=${2}
	if [[ ${2} == "codex" ]];
            then destination=johnh@code19.cantabresearch.com
	fi
	if [[ ${2} == "colo" ]];
            then destination=johnh@cam2g01.farm.speechmatics.io
	fi
	if [[ ${2} == "aml" ]];
            then destination=johnh@cam2aml01.aml.speechmatics.io
	fi
        ssh -NL localhost:${1}:localhost:${1} $destination
    else
        echo "Usage: pf <port> <codex>" >&2
    fi
}
