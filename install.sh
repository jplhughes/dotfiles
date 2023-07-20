#!/bin/bash
set -euo pipefail
USAGE=$(cat <<-END
    Usage: ./install.sh [OPTION]
    Install dotfile dependencies on mac or linux

    OPTIONS:
        --tmux       install tmux
        --zsh        install zsh 

    If OPTIONS are passed they will be installed
    with apt if on linux or brew if on OSX
END
)

zsh=false
tmux=false
force=false
while (( "$#" )); do
    case "$1" in
        -h|--help)
            echo "$USAGE" && exit 1 ;;
        --zsh)
            zsh=true && shift ;;
        --tmux)
            tmux=true && shift ;;
        --force)
            force=true && shift ;;
        --) # end argument parsing
            shift && break ;;
        -*|--*=) # unsupported flags
            echo "Error: Unsupported flag $1" >&2 && exit 1 ;;
    esac
done

operating_system="$(uname -s)"
case "${operating_system}" in
    Linux*)     machine=Linux;;
    Darwin*)    machine=Mac;;
    *)          machine="UNKNOWN:${operating_system}"
esac

# Installing on linux with apt
if [ $machine == "Linux" ]; then
    DOT_DIR=$(dirname $(realpath $0))
    [ $zsh == true ] && sudo apt-get install zsh
    [ $tmux == true ] && sudo apt-get install tmux 

# Installing on mac with homebrew
elif [ $machine == "Mac" ]; then
    brew install coreutils  # Mac won't have realpath before coreutils installed
    DOT_DIR=$(dirname $(realpath $0))
    [ $zsh == true ] && brew install zsh
    [ $tmux == true ] && brew install tmux
fi

# Setting up oh my zsh and oh my zsh plugins
ZSH=~/.oh-my-zsh
ZSH_CUSTOM=$ZSH/custom
if [ -d $ZSH ] && [ "$force" = "false" ]; then
    echo "Skipping download of oh-my-zsh and related plugins, pass --force to force redeownload"
else
    echo " --------- INSTALLING DEPENDENCIES ⏳ ----------- "
    rm -rf $ZSH
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended

    git clone https://github.com/romkatv/powerlevel10k.git \
        ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/themes/powerlevel10k 

    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git \
        ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting 

    git clone https://github.com/zsh-users/zsh-autosuggestions \
        ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions 

    git clone https://github.com/zsh-users/zsh-completions \
        ${ZSH_CUSTOM:=~/.oh-my-zsh/custom}/plugins/zsh-completions 

    git clone https://github.com/zsh-users/zsh-history-substring-search \
        ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-history-substring-search 
    git clone https://github.com/jimeh/tmux-themepack.git ~/.tmux-themepack
    
    echo " --------- INSTALLED SUCCESSFULLY ✅ ----------- "
    echo " --------- NOW RUN ./deploy.sh [OPTION] -------- "
fi

