#!/bin/bash

# 1) Setup linux dependencies
su -c 'apt-get update && apt-get install sudo'
sudo apt-get install less nano htop ncdu

# 2) Setup virtual environment
pip install virtualenv ipykernel
pip install simple-gpu-scheduler # very useful on runpod with multi-GPUs https://pypi.org/project/simple-gpu-scheduler/
virtualenv --python python3.11 ~/venv
source ~/venv/bin/activate
python -m ipykernel install --user --name=venv

# 3) Setup SSH key
ssh-keygen -t ed25519 -C "$email"
cat /root/.ssh/id_ed25519.pub
read -p "Have you added the SSH key to https://github.com/settings/keys? (y/Y/yes to continue): " response
while [[ ! "$response" =~ ^([yY][eE][sS]|[yY])$ ]]; do
    read -p "Please type 'y', 'Y', or 'yes' after adding the SSH key: " response
done

# 4) Setup dotfiles and ZSH
mkdir git && cd git
git clone git@github.com:jplhughes/dotfiles.git
cd dotfiles
./install --zsh --tmux
./deploy.sh
cd ..
chsh -s /usr/bin/zsh

# 5) Project specific setup (uncomment and fill out)
# git clone <github_url>
# cd <repo_name>
# git config --global user.email <email>
# git config --global user.name <name>
# pip install -r requirements.txt