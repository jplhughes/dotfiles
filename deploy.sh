#!/bin/bash
set -euo pipefail
USAGE=$(cat <<-END
    Usage: ./deploy.sh [OPTIONS], eg. ./deploy.sh --local --vim
    Creates ~/.zshrc and ~/.tmux.conf with location
    specific config

    OPTIONS:
        --local                 deploy local config only, only common aliases are sourced
        --vim                   deploy very simple vimrc config 
END
)

export DOT_DIR=$(dirname $(realpath $0))

LOC="remote"
VIM="false"
while (( "$#" )); do
    case "$1" in
        -h|--help)
            echo "$USAGE" && exit 1 ;;
        --local)
            LOC="local" && shift ;;
        --vim)
            VIM="true" && shift ;;
        --) # end argument parsing
            shift && break ;;
        -*|--*=) # unsupported flags
            echo "Error: Unsupported flag $1" >&2 && exit 1 ;;
    esac
done


echo "deploying on $LOC machine..."

# Tmux setup
echo "source $DOT_DIR/config/tmux.conf" > $HOME/.tmux.conf

# Vimrc
if [[ $VIM == "true" ]]; then
    echo "deploying .vimrc"
    echo "source $DOT_DIR/config/vimrc" > $HOME/.vimrc
fi

# zshrc setup
echo "source $DOT_DIR/config/zshrc.sh" > $HOME/.zshrc
# conifg/aliases_speechmatics.sh adds remote specific aliases and cmds
[ $LOC = 'remote' ] &&  echo \
    "source $DOT_DIR/config/aliases_speechmatics.sh" >> $HOME/.zshrc

zsh
