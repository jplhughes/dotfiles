#!/bin/bash

# Check if both hostnames are provided
[ -z "$1" ] && echo "Error: server_hostname is not set." >&2 && exit 1

SERVER_HOSTNAME=$1
CLIENT_HOSTNAMES=${2:-""} # list of client hostnames separated by commas

if [ -n "$CLIENT_HOSTNAMES" ]; then
    IFS=',' read -ra CLIENT_HOSTNAMES_ARR <<< "$CLIENT_HOSTNAMES"
else
    CLIENT_HOSTNAMES_ARR=()
fi

num_cpus=$(nproc --all)
num_sockets=$(lscpu | grep "Socket(s):" | awk '{print $2}')
num_cores_per_socket=$(lscpu | grep "Core(s) per socket:" | awk '{print $4}')
num_threads_per_core=$(lscpu | grep "Thread(s) per core:" | awk '{print $4}')
total_memory=$(free -m | grep Mem: | awk '{print $2}')

NODE_INFO="NodeName=$SERVER_HOSTNAME CPUs=$num_cpus Boards=$num_sockets Sockets=$num_sockets CoresPerSocket=$num_cores_per_socket ThreadsPerCore=$num_threads_per_core RealMemory=$total_memory Gres=gpu:8 State=UNKNOWN
"
NODES=$SERVER_HOSTNAME
for client_hostname in "${CLIENT_HOSTNAMES_ARR[@]}"; do
    NODES+=",$client_hostname"
    NODE_INFO+="NodeName=$client_hostname CPUs=$num_cpus Boards=$num_sockets Sockets=$num_sockets CoresPerSocket=$num_cores_per_socket ThreadsPerCore=$num_threads_per_core RealMemory=$total_memory Gres=gpu:8 State=UNKNOWN
"
done

cat <<EOL
ClusterName=localcluster
SlurmctldHost=$SERVER_HOSTNAME
MpiDefault=none
ProctrackType=proctrack/linuxproc
ReturnToService=2
SlurmctldPidFile=/var/run/slurmctld.pid
SlurmctldPort=6817
SlurmdPidFile=/var/run/slurmd.pid
SlurmdPort=6818
SlurmdSpoolDir=/var/lib/slurm-llnl/slurmd
SlurmUser=slurm
StateSaveLocation=/var/lib/slurm-llnl/slurmctld
SwitchType=switch/none
TaskPlugin=task/none

# TIMERS
InactiveLimit=0
KillWait=30
MinJobAge=300
SlurmctldTimeout=120
SlurmdTimeout=300
Waittime=0
# SCHEDULING
SchedulerType=sched/backfill
SelectType=select/cons_tres
SelectTypeParameters=CR_Core

# AccountingStoragePort=
AccountingStorageType=accounting_storage/none
JobCompType=jobcomp/none
JobAcctGatherFrequency=30
JobAcctGatherType=jobacct_gather/none
SlurmctldDebug=info
SlurmctldLogFile=/var/log/slurm-llnl/slurmctld.log
SlurmdDebug=info
SlurmdLogFile=/var/log/slurm-llnl/slurmd.log

GresTypes=gpu

$NODE_INFO

PartitionName=gpupart Nodes=$NODES Default=YES MaxTime=INFINITE State=UP
EOL
