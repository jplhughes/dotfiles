#!/bin/bash
set -eoux pipefail
# brew cask install iterm2

if [ $# -ne 1 ];
   then echo "Invalid number of args, expecting only 1 (linux or mac)"
   exit 1
fi

machine=$1
if [ $machine == "linux" ]; then
    sudo apt-get install zsh
    sudo apt-get install tmux
elif [ $machine == "mac" ]; then
    brew install zsh
    brew install tmux
fi

ZSH_CUSTOM=${ZSH_CUSTOM:-~/.oh-my-zsh/custom}
( sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)" )
git clone https://github.com/romkatv/powerlevel10k.git $ZSH_CUSTOM/themes/powerlevel10k
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $ZSH_CUSTOM/plugins/zsh-syntax-highlighting
git clone https://github.com/zsh-users/zsh-autosuggestions $ZSH_CUSTOM/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-completions $ZSH_CUSTOM/plugins/zsh-completions
git clone https://github.com/zsh-users/zsh-history-substring-search $ZSH_CUSTOM/plugins/zsh-history-substring-search
git clone https://github.com/jimeh/tmux-themepack.git ~/.tmux-themepack
zsh