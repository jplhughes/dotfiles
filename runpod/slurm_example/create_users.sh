# Example usage: ./create_users.sh user1 user2 user3
users=("$@")

for user in "${users[@]}"; do 
    echo "Creating user: $user"
    # check if user already exists
    if id "$user" &>/dev/null; then
        echo "User $user already exists"
        continue
    fi
    sudo useradd -m $user
    sudo usermod -aG sudo $user
    echo "$user ALL=(ALL) NOPASSWD:ALL" | sudo tee -a /etc/sudoers
    cp -a /root/.ssh /home/$user/.ssh
    sudo chown -R $user:$user /home/$user/.ssh
    sudo chmod 700 /home/$user/.ssh
    sudo chmod 600 /home/$user/.ssh/*
    sudo chsh -s /bin/zsh $user
done 

echo "Setting up sshd config"
grep -qxF "PasswordAuthentication no" /etc/ssh/sshd_config || echo "PasswordAuthentication no" | sudo tee -a /etc/ssh/sshd_config
grep -qxF "PermitRootLogin prohibit-password" /etc/ssh/sshd_config || echo "PermitRootLogin prohibit-password" | sudo tee -a /etc/ssh/sshd_config
grep -qxF "PubkeyAuthentication yes" /etc/ssh/sshd_config || echo "PubkeyAuthentication yes" | sudo tee -a /etc/ssh/sshd_config

echo "Run to restart sshd:"
echo "pkill -HUP sshd"
