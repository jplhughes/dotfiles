#!/bin/bash

USAGE="Usage: ./deploy.sh local or ./deploy.sh remote"
if [ $# -eq 0 ]
  then
    echo "Error: No flags provided"
    echo $USAGE
    exit 1
fi

PARAMS=""
while (( "$#" )); do
  case "$1" in
    -h|--help)
      echo $USAGE
      exit
      ;;
    --) # end argument parsing
      shift
      break
      ;;
    -*|--*=) # unsupported flags
      echo "Error: Unsupported flag $1" >&2
      exit 1
      ;;
    *) # preserve positional arguments
      PARAMS="$PARAMS $1"
      shift
      ;;
  esac
done
# set positional arguments in their proper place
eval set -- "$PARAMS"

if [ $PARAMS == "local" ]; then
    echo "deploying on local machine..."
    echo "source $HOME/git/dotfiles/zsh/zshrc_local.sh" > $HOME/.zshrc
    echo "source $HOME/git/dotfiles/config/vimrc.vim" > $HOME/.vimrc
    echo "source $HOME/git/dotfiles/config/tmux.conf" > $HOME/.tmux.conf
    # echo "path = $HOME/git/dotfiles/ssh.config" >> $HOME/.ssh/config
    zsh
elif [ $PARAMS == "remote" ]; then
    echo "deploying on remote machine..."
    echo "source $HOME/git/dotfiles/zsh/zshrc_remote.sh" > $HOME/.zshrc
    echo "source $HOME/git/dotfiles/config/vimrc.vim" > $HOME/.vimrc
    echo "source $HOME/git/dotfiles/config/tmux.conf" > $HOME/.tmux.conf
    # echo "path = $HOME/git/dotfiles/git.config" >> $HOME/.gitconfig
    zsh
else
    echo "Error: Unsupported flags provided"
    echo $USAGE
    exit 1
fi



