#!/bin/bash
# brew cask install iterm2

if [ $# -ne 1 ];
   then echo "Invalid number of args, expecting only 1 (linux or mac)"
   exit 1
fi

machine=$1
if [ $machine == "linux" ]; then
    sudo apt-get install zsh
elif [ $machine == "mac" ]; then
    brew install zsh
fi

sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
git clone https://github.com/romkatv/powerlevel10k.git $ZSH_CUSTOM/themes/powerlevel10k
git clone https://github.com/bhilburn/powerlevel9k.git ~/.oh-my-zsh/custom/themes/powerlevel9k
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
git clone https://github.com/zsh-users/zsh-autosuggestions ~/.zsh/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-completions ${ZSH_CUSTOM:=~/.oh-my-zsh/custom}/plugins/zsh-completions
git clone https://github.com/zsh-users/zsh-history-substring-search ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-history-substring-search
git clone https://github.com/jimeh/tmux-themepack.git ~/.tmux-themepack

# ssh-keygen -t rsa
# ssh-copy-id -i ~/.ssh/id_rsa.pub johnh@code19.cantabresearch.com
