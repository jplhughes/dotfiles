#!/bin/bash
[ -z "$1" ] && echo "Error: SERVER_HOSTNAME is not set." >&2 && exit 1
[ -z "$2" ] && echo "Error: SERVER_HOSTNAME_IP is not set." >&2 && exit 1

SERVER_HOSTNAME=$1
SERVER_HOSTNAME_IP=$2
CLIENT_HOSTNAMES=${3:-""} # list of client hostnames separated by commas
CLIENT_HOSTNAMES_IP=${4:-""} # list of client hostnames separated by commas

SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)

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

# Create slurm.conf
bash $SCRIPT_DIR/create_slrum_conf.sh $SERVER_HOSTNAME $CLIENT_HOSTNAMES > /etc/slurm-llnl/slurm.conf
bash $SCRIPT_DIR/create_gres_conf.sh $current_hostname > /etc/slurm-llnl/gres.conf

if [ ! -L /etc/slurm/slurm.conf ]; then
    sudo ln -s /etc/slurm-llnl/slurm.conf /etc/slurm/slurm.conf
fi
if [ ! -L /etc/slurm/gres.conf ]; then
    sudo ln -s /etc/slurm-llnl/gres.conf /etc/slurm/gres.conf
fi

echo "Now run the following command to start the slurm services:"
echo "sudo slurmctld -D"
echo "sudo slurmd -D"
