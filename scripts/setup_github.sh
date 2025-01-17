#!/bin/bash

#!/bin/bash

# Input arguments
email=${1:-"jpl.hughes@btinternet.com"}
name=${2:-"John Hughes"}
github_url=${3:-""}

# 0) Setup git
git config --global user.email "$email"
git config --global user.name "$name"

# 1) Setup SSH key
ssh-keygen -t ed25519 -C "$email"
cat /root/.ssh/id_ed25519.pub
read -p "Have you added the SSH key to https://github.com/settings/keys? (y/Y/yes to continue): " response
while [[ ! "$response" =~ ^([yY][eE][sS]|[yY])$ ]]; do
    read -p "Please type 'y', 'Y', or 'yes' after adding the SSH key: " response
done

# 2) Project specific setup (if github_url is provided)
if [ -n "$github_url" ]; then
    git clone "$github_url"
    repo_name=$(basename "$github_url" .git)
    cd "$repo_name"
    uv pip install -r requirements.txt
fi