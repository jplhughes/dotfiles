# dotfiles
ZSH, Tmux, Vim and ssh setup on both local/remote machines.

## Installation

### Step 1
Install dependencies (e.g. oh-my-zsh and related plugins), you can specify options to install specific programs: tmux, zsh, note that your dev-vm will already have tmux and zsh installed so you don't need to provide any options in this case, but you may need to provide these if you are installing locally. 

Installation on a mac machine requires homebrew so install this [from here](https://brew.sh/) first if you haven't already.

```bash
# Install just the dependencies (if on dev-vm)
./install.sh
# Install dependencies + tmux & zsh (if local or on linux without tmux or zsh)
./install.sh --tmux --zsh
```

### Step 2
Deploy (e.g. source aliases for .zshrc, apply oh-my-zsh settings etc..)
```bash
# Remote linux machine
./deploy.sh  
# Local mac machine
./deploy.sh --local   
# Include simple vimrc 
./deploy.sh --vim
```

### Step 3
This set of dotfiles uses the powerlevel10k theme for zsh, this makes your terminal look better and adds lots of useful features, e.g. env indicators, git status etc...

Note that as the provided powerlevel10k config uses special icons it is *highly recommended* you install a custom font that supports these icons. A guide to do that is [here](https://github.com/romkatv/powerlevel10k#meslo-nerd-font-patched-for-powerlevel10k). Alternatively you can set up powerlevel10k to not use these icons (but it won't look as good!)

This repo comes with a preconfigured powerlevel10k theme in [`./config/p10k.zsh`](./config/p10k.zsh) but you can reconfigure this by running `p10k configure` which will launch an interactive window. 


When you get to the last two options below
```
Powerlevel10k config file already exists.
Overwrite ~/git/sm-dotfiles/config/p10k.zsh?
# Press y for YES

Apply changes to ~/.zshrc?
# Press n for NO 
```

You then will want to paste the following command into the created p10k.zsh file so that when you are in a singularity image you will have an indicator in your terminal.

```
------> Add 'singularity' to the POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS < --------
typeset -g POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(
    # =========================[ Line #1 ]=========================
    status                  # exit code of the last command
    command_execution_time  # duration of the last command
    background_jobs         # presence of background jobs
    direnv                  # direnv status (https://direnv.net/)
    asdf                    # asdf version manager (https://github.com/asdf-vm/asdf)
    virtualenv              # python virtual environment (https://docs.python.org/3/library/venv.html)
    singularity             # ADD THIS LINE HERE <-------

.......

------> # Add the prompt_singularity() function beneath the prompt example section (shown below) of p10k.zsh < --------
# Example of a user-defined prompt segment. Function prompt_example will be called on every
# prompt if `example` prompt segment is added to POWERLEVEL9K_LEFT_PROMPT_ELEMENTS or
# POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS. It displays an icon and orange text greeting the user.
#
# Type `p10k help segment` for documentation and a more sophisticated example.
function prompt_example() {
p10k segment -f 208 -i '⭐' -t 'hello, %n'
}

ADD THIS FUNCTION HERE --------> 
  function prompt_singularity() {
    if [ ! -z "$SINGULARITY_CONTAINER" ]; then
      name=$(echo ${SINGULARITY_CONTAINER} | awk -F/ '{print $(NF-0)}')
      p10k segment -f 031 -i '💫' -t "${name}"
    fi
  }
  
```

### iterm
Included in this repo are the onedark and onedarker color schemes for iterm, to use these go to import under profiles > colors > color\_presets in settings. 

