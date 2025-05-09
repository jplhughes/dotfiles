#!/bin/bash

[ -z "$1" ] && echo "Error: MUNGE_KEY_STR is not set." >&2 && exit 1
[ -z "$2" ] && echo "Error: SERVER_HOSTNAME is not set." >&2 && exit 1
[ -z "$3" ] && echo "Error: SERVER_HOSTNAME_IP is not set." >&2 && exit 1

MUNGE_KEY_STR=$1
SERVER_HOSTNAME=$2
SERVER_HOSTNAME_IP=$3
CLIENT_HOSTNAMES=${4:-""} # list of client hostnames separated by commas
CLIENT_HOSTNAMES_IP=${5:-""} # list of client hostnames separated by commas

SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)

# Install slurm
sudo apt update && sudo apt upgrade -y
sudo apt install -y slurm-wlm slurm-client munge locales

# Set locale
sudo locale-gen en_GB.UTF-8
sudo update-locale LANG=en_GB.UTF-8
export LANG=en_GB.UTF-8
export LC_ALL=en_GB.UTF-8

current_hostname=$(hostname)
# Convert comma-separated lists to arrays
if [ -n "$CLIENT_HOSTNAMES" ]; then
    IFS=',' read -ra CLIENT_HOSTNAMES_ARR <<< "$CLIENT_HOSTNAMES"
else
    CLIENT_HOSTNAMES_ARR=()
fi

if [ -n "$CLIENT_HOSTNAMES_IP" ]; then
    IFS=',' read -ra CLIENT_HOSTNAMES_IP_ARR <<< "$CLIENT_HOSTNAMES_IP"
else
    CLIENT_HOSTNAMES_IP_ARR=()
fi

# Add server hostname/IP to hosts file if not already present
if ! grep -q "$SERVER_HOSTNAME" /etc/hosts; then
    echo "$SERVER_HOSTNAME_IP $SERVER_HOSTNAME" | sudo tee -a /etc/hosts
fi

# Add all client hostnames/IPs to hosts file if not already present
for ((i=0; i<${#CLIENT_HOSTNAMES_ARR[@]}; i++)); do
    if ! grep -q "${CLIENT_HOSTNAMES_ARR[$i]}" /etc/hosts; then
        echo "${CLIENT_HOSTNAMES_IP_ARR[$i]} ${CLIENT_HOSTNAMES_ARR[$i]}" | sudo tee -a /etc/hosts
    fi
done

# ================================================
# munge setup
# ================================================

# Create munge user and group
getent passwd munge
getent group munge
sudo groupadd -r munge
sudo useradd -r -g munge -s /sbin/nologin munge
# Add slurm user to munge group
sudo usermod -aG munge slurm

# Create munge directories and set permissions
for dir in /var/log/munge /var/lib/munge /etc/munge /var/run/munge /run/munge; do
    sudo mkdir -p $dir
    sudo chown -R munge:munge $dir
    sudo chmod -R 755 $dir
done

echo -n "$MUNGE_KEY_STR" | sha256sum | awk '{print $1}' > /etc/munge/munge.key
sudo chmod 400 /etc/munge/munge.key
sudo chown munge:munge /etc/munge/munge.key

# Start munge service
sudo /usr/sbin/munged --force

# Set permissions for munge socket
if [ ! -f /run/munge/munge.socket.2 ]; then
    sudo chmod 777 /run/munge/munge.socket.2
fi

if munge -n | unmunge; then
    echo "Munge is working correctly."
else
    echo "Error: Munge is not working correctly." >&2
    exit 1
fi

# ================================================
# Slurm setup
# ================================================

# Create slurm directories and set permissions
for dir in /etc/slurm /etc/slurm-llnl /var/spool/slurm /var/log/slurm-llnl /var/spool/slurm/ctld /var/lib/slurm-llnl /var/lib/slurm-llnl/slurmctld /var/spool/slurmd /var/lib/slurm-llnl/slurmd /var/log/slurm; do
    sudo mkdir -p $dir
    sudo chown -R slurm:slurm $dir
    sudo chmod -R 755 $dir
done

# Create slurm.conf
bash $SCRIPT_DIR/create_slrum_conf.sh $SERVER_HOSTNAME $CLIENT_HOSTNAMES > /etc/slurm-llnl/slurm.conf
bash $SCRIPT_DIR/create_gres_conf.sh $current_hostname > /etc/slurm-llnl/gres.conf
sudo ln -s /etc/slurm-llnl/slurm.conf /etc/slurm/slurm.conf
sudo ln -s /etc/slurm-llnl/gres.conf /etc/slurm/gres.conf

echo "Now run the following command to start the slurm services:"
echo "sudo slurmctld -D"
echo "sudo slurmd -D"
