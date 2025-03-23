#!/bin/bash

[ -z "$1" ] && echo "Error: munge_key_str is not set." >&2 && exit 1
[ -z "$2" ] && echo "Error: hostname1 is not set." >&2 && exit 1
[ -z "$3" ] && echo "Error: hostname2 is not set." >&2 && exit 1
[ -z "$4" ] && echo "Error: hostname1_ip is not set." >&2 && exit 1
[ -z "$5" ] && echo "Error: hostname2_ip is not set." >&2 && exit 1

munge_key_str=$1
hostname1=$2
hostname2=$3
hostname1_ip=$4
hostname2_ip=$5

SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)

# Install slurm
sudo apt update && sudo apt upgrade -y
sudo apt install -y slurm-wlm slurm-client munge locales

# Set locale
sudo locale-gen en_GB.UTF-8
sudo update-locale LANG=en_GB.UTF-8
export LANG=en_GB.UTF-8
export LC_ALL=en_GB.UTF-8

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

echo -n "$munge_key_str" | sha256sum | awk '{print $1}' > /etc/munge/munge.key
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
bash $SCRIPT_DIR/create_slrum_conf.sh $hostname1 $hostname2 $hostname1_ip $hostname2_ip > /etc/slurm-llnl/slurm.conf
bash $SCRIPT_DIR/create_gres_conf.sh $(hostname) > /etc/slurm-llnl/gres.conf
sudo ln -s /etc/slurm-llnl/slurm.conf /etc/slurm/slurm.conf
sudo ln -s /etc/slurm-llnl/gres.conf /etc/slurm/gres.conf

echo "Now run the following command to start the slurm services:"
echo "sudo slurmctld -D"
echo "sudo slurmd -D"
