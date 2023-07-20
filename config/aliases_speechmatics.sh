# -------------------------------------------------------------------
# General and Navigation
# -------------------------------------------------------------------

HOST_IP_ADDR=$(hostname -I | awk '{ print $1 }') # This gets the actual ip addr

# Quick navigation add more here
alias a="cd ~/git/aladdin"
alias a2="cd ~/git/aladdin2"
alias a3="cd ~/git/aladdin3"
alias a4="cd ~/git/aladdin4"
alias cde="cd /exp/$(whoami)"
alias cdt="cd ~/tb"
alias cdn="cd ~/notebooks"

# quick navigation
alias exp="cd /exp/$(whoami)"
alias data='cd /data/artefacts'
alias lm='cd /data/artefacts/lm'
alias am='cd /data/artefacts/am'
alias dg='cd /data/artefacts/decode_graph'
alias np='cd /data/artefacts/neural_punctuation'
alias kws='cd /opt/kaldi_workspace'
alias sif='cd /env'

# Perish machines
alias p1="cd /perish_aml01"
alias p2="cd /perish_aml02"
alias p3="cd /perish_aml03"
alias p4="cd /perish_aml04"
alias p5="cd /perish_aml05"
alias g1="cd /perish_g01"
alias g2="cd /perish_g02"
alias g3="cd /perish_g03"

alias b1="ssh b1"
alias b2="ssh b2"
alias b3="ssh b3"
alias b4="ssh b4"
alias b5="ssh b5"
alias b6="ssh b6"
alias b7="ssh b7"
alias b8="ssh b8"
alias b9="ssh b9"
alias b10="ssh b10"
alias b11="ssh b11"

# Change to aladdin directory and activate SIF
alias msa="make -C /home/$(whoami)/git/aladdin/ shell"
alias msa2="make -C /home/$(whoami)/git/aladdin2/ shell"
# Activate aladdin SIF in current directory
alias msad="/home/$(whoami)/git/aladdin/env/singularity.sh -c "$SHELL""
alias msad2="/home/$(whoami)/git/aladdin2/env/singularity.sh -c "$SHELL""

# Parquet printing utilities
PARQUET_ENV_ERROR_MESSAGE="ERROR: Open a singularity environment before using pcat, pless, phead or ptail"
alias pcat="[ -z '$SINGULARITY_CONTAINER' ] && echo $PARQUET_ENV_ERROR_MESSAGE || python $CODE_DIR/aladdin/utils/parquet_text_printer.py"
alias phead="[ -z '$SINGULARITY_CONTAINER' ] && echo $PARQUET_ENV_ERROR_MESSAGE || python $CODE_DIR/aladdin/utils/parquet_text_printer.py --mode head"
alias ptail="[ -z '$SINGULARITY_CONTAINER' ] && echo $PARQUET_ENV_ERROR_MESSAGE || python $CODE_DIR/aladdin/utils/parquet_text_printer.py --mode tail"
function pless () { pcat $@ | less; }

# Misc
alias jl="jupyter lab --no-browser --ip $HOST_IP_ADDR"
alias ls='ls -hF --color' # add colors for filetype recognition
alias nv='nvidia-smi'
cuda () {
  if [ "$#" -eq 1 ]; then
    export CUDA_VISIBLE_DEVICES=$1
  else
    echo "Usage: cuda <slot>" >&2
  fi
}

# Useful for finding error from an array job when you just get 
find_error () {
  for log in $1/*.log; do result=$(grep "status" $log | tail -n1 | grep -v "status 0") && [ ! -z "$result" ] && echo $log; done
}

# make file
alias m='make'
alias mc="make check"
alias ms='make shell'
alias mf="make format"
alias mtest="make test"
alias mft="make functest"
alias mut="make unittest"

# docker
alias ds='docker stats'
alias di='docker images'
alias dl='docker logs'

# -------------------------------------------------------------------
# Tensorboard
# -------------------------------------------------------------------

# tensorboard
alias tb="singularity exec -B $PWD oras://singularity-master.artifacts.speechmatics.io/tensorboard:2.6.0a20210704 tensorboard --load_fast true --host=$HOST_IP_ADDR --reload_multifile true --logdir=$PWD"
alias tbkill="ps aux | grep tensorboard | grep $(whoami) | awk '{print \$2}' | xargs kill"

tblink () {
    [ -z $SINGULARITY_CONTAINER ] && echo "must be run inside SIF" && return
    # Creates simlinks from specified folders to ~/tb/x where x is an incrmenting number
    # and luanches tensorboard
    # example: `tblink ./lm/20210824 ./lm/20210824_ablation ./lm/20210825_updated_data`
    if [ "$#" -eq 0 ]; then
        logdir=$(pwd)
    else
        # setup tensorboard directory
        tbdir="$HOME/tb"
        if [ -d "$tbdir" ]; then
            last="$(printf '%s\n' $tbdir/* | sed 's/.*\///' | sort -g -r | head -n 1)"
            new=$((last+1))
            echo "last folder $last, new folder $new"
            logdir="$tbdir/$new"
        else
            logdir="$tbdir/0"
        fi
        # softlink into tensorboard directory
        _linkdirs "$logdir" "$@"
    fi
    tensorboard \
      --host=$HOST_IP_ADDR \
      --reload_multifile true \
      --logdir="$logdir" \
      --reload_interval 8 \
      --extra_data_server_flags=--no-checksum \
      --max_reload_threads 4 \
      --window_title $PWD
}
_linkdirs() {
    logdir="$1"
    mkdir -p $logdir
    for linkdir in "${@:2}"; do
        linkdir=$(readlink -f $linkdir)
        if [ ! -d $linkdir ]; then
            echo "linkdir $linkdir does not exist"
            return
        fi
        echo "symlinked $linkdir into $logdir"
        ln -s $linkdir $logdir
    done
}
tbadd() {
    # Add experiment folder to existing tensorboard directory (see tblink)
    # example: `tbadd 25 ./lm/20210825` will symlink ./lm/20210824 to ~/tb/25
    if [ "$#" -gt 1 ]; then
        tbdir="$HOME/tb"
        logdir=$tbdir/$1
        _linkdirs $logdir "${@:2}"
    else
        echo "tbadd <tb number> <exp dirs>"
    fi
}

# -------------------------------------------------------------------
# Queue management
# -------------------------------------------------------------------

# Short aliases
full_queue='qstat -q "aml*.q@*" -f -u \*'
alias q='qstat'
alias qtop='qalter -p 1024'
alias qq=$full_queue # Display full queue
alias gq='qstat -q aml-gpu.q -f -u \*' # Display just the gpu queues
alias gqf='qstat -q aml-gpu.q -u \* -r -F gpu | egrep -v "jobname|Master|Binding|Hard|Soft|Requested|Granted"' # Display the gpu queues, including showing the preemption state of each job
alias cq='qstat -q "aml-cpu.q@gpu*" -f -u \*' # Display just the cpu queues
alias wq="watch qstat"
alias wqq="watch $full_queue"

# Queue functions
qlogin () {
  # Function to request gpu or cpu access
  # example:
  #    qlogin 2                request 2 gpus
  #    qlogin 1 cpu            request 1 cpu slot
  #    qlogin 1 aml-gpu.q@b5   request 1 gpu on b5
  if [ "$#" -eq 1 ]; then
    /usr/bin/qlogin -now n -pe smp $1 -q aml-gpu.q -l gpu=$1 -N D_$(whoami)
  elif [ "$#" -eq 2 ]; then
    gpu_args=""
    if [ "$2" = "cpu" ]; then
      queue="aml-cpu.q"
    elif  echo "$2" | grep -q "gpu" ; then
      queue="$2"
      gpu_args="gpu=$1"
    else
      queue="$2"
    fi
    /usr/bin/qlogin -now n -pe smp $1 -q $queue -l "$gpu_args" -N D_$(whoami)
  else
    echo "Usage: qlogin <num_gpus>" >&2
    echo "Usage: qlogin <num_gpus> <queue>" >&2
    echo "Usage: qlogin <num_slots> cpu" >&2
  fi
}
qtail () {
  if [ "$#" -gt 0 ]; then
    l=$(qlog $@) && tail -f $l
  else
    echo "Usage: qtail <jobid>" >&2
    echo "Usage: qtail <array_jobid> <sub_jobid>" >&2
  fi
}
qlast () {
  # Get job_id of last running job
  job_id=$(qstat | awk '$5=="r" {print $1}' | grep -E '[0-9]' | sort -r | head -n 1)
  if [ ! -z $job_id ]; then
    echo $job_id
  else
    echo "no jobs found" >&2
  fi
}
qless () {
  less $(qlog $@)
}
qcat () {
  l=$(qlog $@) && cat $l
}
echo_if_exist() {
  [ -f $1 ] && echo $1
}
qlog () {
  # Get log path of job
  if [ "$1" = "-l" ]; then
    job_id=$(qlast)
  else
    job_id=$1
  fi
  if [ "$#" -eq 1 ]; then
    echo $(qstat -j $job_id | grep stdout_path_list | cut -d ":" -f4)
  elif [ "$#" -eq 2 ]; then
    # Array jobs are a little tricky
    log_path=$(qlog $job_id)
    base_dir=$(echo $log_path | rev | cut -d "/" -f3- | rev)
    filename=$(basename $log_path)
    # Could be a number of schemes so just try them all
    echo_if_exist ${base_dir}/log/${filename} && return 0
    echo_if_exist ${base_dir}/log/${filename%.log}${2}.log && return 0
    echo_if_exist ${base_dir}/log/${filename%.log}.${2}.log && return 0
    echo_if_exist ${base_dir}/${filename%.log}.${2}.log  && return 0
    echo_if_exist ${base_dir}/${filename%.log}${2}.log && return 0
    echo "log file for job $job_id not found" >&2 && return 1
  else
    echo "Usage: qlog <jobid>" >&2
    echo "Usage: qlog <array_jobid> <sub_jobid>" >&2
  fi
}
qdesc () {
  qstat | tail -n +3 | while read line; do
  job=$(echo $line | awk '{print $1}')
  if [[ ! $(qstat -j $job | grep "job-array tasks") ]]; then
    echo $job $(qlog $job)
  else
    qq_dir=$(qlog $job)
    job_status=$(echo $line | awk '{print $5}')
    if [ $job_status = 'r' ]; then
      sub_job=$(echo $line | awk '{print $10}')
      echo $job $sub_job $(qlog $job $sub_job)
    else
      echo $job $qq_dir $job_status
    fi
  fi
done
}

qrecycle () {
  [ ! -z $SINGULARITY_CONTAINER ] && ssh localhost "qrecycle $@" || command qrecycle "$@";
}

qupdate () {
  [ ! -z $SINGULARITY_CONTAINER ] && ssh localhost "qupdate"|| command qupdate ;
}

# Only way to get a gpu is via queue
if [ -z $CUDA_VISIBLE_DEVICES ]; then
  export CUDA_VISIBLE_DEVICES=
fi

# -------------------------------------------------------------------
# Cleaning processes
# -------------------------------------------------------------------

clean_vm () {
  ps -ef | grep zsh | awk '{print $2}' | xargs sudo kill
  ps -ef | grep vscode | awk '{print $2}' | xargs sudo kill
}

