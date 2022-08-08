#!/bin/zsh

# env
export PATH="$HOME/.local/bin:$PATH"
export CI_TOKEN="6685acf408bb0f1eb7a87b0b931c49"
export PUBLISHER_TOKEN="4dd8710146f096f90121530d36892d"

# extra aliases
alias ls='ls -hF --color' # add colors for filetype recognition

# -------------------------------------------------------------------
# speechmatics
# -------------------------------------------------------------------

# jupyter lab
alias jl="jupyter lab --no-browser --ip johnh.dev-vms.speechmatics.io"
# virtual envs
alias ve="source venv/bin/activate"

alias b1="ssh beast1.aml.speechmatics.io"
alias b2="ssh beast2.aml.speechmatics.io"
alias b3="ssh beast3.aml.speechmatics.io"
alias b4="ssh beast4.aml.speechmatics.io"
alias b5="ssh beast5.aml.speechmatics.io"
alias b6="ssh beast6.aml.speechmatics.io"

export b1="beast1.aml.speechmatics.io"
export b2="beast2.aml.speechmatics.io"
export b3="beast3.aml.speechmatics.io"
export b4="beast4.aml.speechmatics.io"
export b5="beast5.aml.speechmatics.io"
export b6="beast6.aml.speechmatics.io"
export gb1="gpu.q@${b1}"
export gb2="gpu.q@${b2}"
export gb3="gpu.q@${b3}"
export gb4="gpu.q@${b4}"
export gb5="gpu.q@${b5}"
export gb6="gpu.q@${b6}"

# make file
alias m='make'
alias mc="make check"
alias ms="make shell"
alias me="make env"
alias mf="make format"
alias mtest="make test"
alias mft="make functest"
alias mut="make unittest"

# singularity
alias buildsb="sudo singularity build --sandbox /perish_aml04/johnh/sandbox"
alias runsb="sudo singularity shell --writable --shell /bin/zsh /perish_aml04/johnh/sandbox"
alias pipsb="sudo singularity exec --writable /perish_aml04/johnh/sandbox pip3 install"
alias aptsb="sudo singularity exec --writable /perish_aml04/johnh/sandbox apt update && apt install"
alias exportsb="export CONTAINER_IMAGE=$(readlink -f /perish_aml04/johnh/sandbox)"

# tensorboard
alias tb='singularity exec -B $PWD oras://singularity-master.artifacts.speechmatics.io/tensorboard:2.6.0a20210704 tensorboard --load_fast true --host=$(hostname -f)  --reload_multifile true --logdir=$PWD'
alias tbkill="ps aux | grep tensorboard | grep johnh | awk '{print \$2}' | xargs kill"

# Parquet printing utilities
PARQUET_ENV_ERROR_MESSAGE="ERROR: Open a singularity environment before using pcat, pless, phead or ptail"
alias pcat="[ -z '$SINGULARITY_CONTAINER' ] && echo $PARQUET_ENV_ERROR_MESSAGE || python $CODE_DIR/aladdin/utils/parquet_text_printer.py"
alias phead="[ -z '$SINGULARITY_CONTAINER' ] && echo $PARQUET_ENV_ERROR_MESSAGE || python $CODE_DIR/aladdin/utils/parquet_text_printer.py --mode head"
alias ptail="[ -z '$SINGULARITY_CONTAINER' ] && echo $PARQUET_ENV_ERROR_MESSAGE || python $CODE_DIR/aladdin/utils/parquet_text_printer.py --mode tail"
function pless () { pcat $@ | less; }

tblink () {
  if [ "$#" -eq 0 ]; then
    logdir=$(pwd)
  else
  # setup tensorboard directory
    tbdir="$HOME/tb"
    if [ -d "$tbdir" ]; then

      last=$(ls -v $tbdir | tail -1)
      new=$((last+1))
      logdir="$tbdir/$new"
    else
      logdir="$tbdir/0"
    fi
    mkdir -p $logdir
    # softlink into tensorboard directory
    for linkdir in "$@"; do
      linkdir=$(rl $linkdir)
      echo "linkdir: $linkdir"
      ln -s $linkdir $logdir
    done
  fi
  echo "logdir: $logdir"
  tensorboard --host=$(hostname) --logdir=$logdir
}

# quick navigation
alias a='cd ~/git/aladdin'
alias a2='cd ~/git/aladdin2'
alias a3='cd ~/git/aladdin3'
alias c='cd'
alias cda='cd ~/git/aladdin'
alias exp='cd /exp/johnh'
alias data='cd /data/artefacts'
alias lm='cd /data/artefacts/lm'
alias am='cd /data/artefacts/am'
alias dg='cd /data/artefacts/decode_graph'
alias np='cd /data/artefacts/neural_punctuation'
alias kws='cd /opt/kaldi_workspace'
alias sif='cd /env'

# gpu
alias qq='qstat -q "aml*.q@*" -f -u \*'  # Display full queue
alias gq='qstat -q aml-gpu.q -f -u \*'  # Display just the gpu queues
alias gqf='qstat -q aml-gpu.q -u \* -r -F gpu | egrep -v "jobname|Master|Binding|Hard|Soft|Requested|Granted"'  # Display the gpu queues, including showing the preemption state of each job
alias cq='qstat -q "aml-cpu.q@gpu*" -f -u \*'  # Display just the cpu queues
alias q='qstat'
alias qc='source ~/venv_dashboard/bin/activate && ~/git/dotfiles/scripts/qstat.py'
alias qtop='qalter -p 1024'
qwtop () {
  for id in $(qq | grep johnh | grep qw | awk '{print $1}'); do
    qalter -p 1024 $id
  done
}
# Useful for finding error from an array job when you just get 
find_error () {
  grep "status" $1/*.log | grep -v "status 0"
}

qlgn () {
  echo "$#"
  if [ "$#" -eq 1 ]; then
    qlogin -now n -pe smp $1 -q aml-gpu.q -l gpu=$1 -N D_johnh
  elif [ "$#" -eq 2 ]; then
    qlogin -now n -pe smp $1 -q $2 -l gpu=$1 -N D_johnh
  else
    echo "Usage: qlogin <num_gpus>" >&2
    echo "Usage: qlogin <num_gpus> <queue>" >&2
  fi
}

alias nv='nvidia-smi'
alias cuda0='export CUDA_VISIBLE_DEVICES=0'
alias cuda1='export CUDA_VISIBLE_DEVICES=1'
cuda () {
  if [ "$#" -eq 1 ]; then
    export CUDA_VISIBLE_DEVICES=$1
  else
    echo "Usage: cuda <slot>" >&2
  fi
}

function qrecycle() { [ ! -z $SINGULARITY_CONTAINER ] && ssh localhost "qrecycle $@" || command qrecycle "$@" ;}
function qupdate() { [ ! -z $SINGULARITY_CONTAINER ] && ssh localhost "qupdate" || command qupdate ;}
# gaurd against accidently using gpus
if [ -z $CUDA_VISIBLE_DEVICES ]; then
    export CUDA_VISIBLE_DEVICES=
fi

qtail () {
  tail -f $(qlog $@)
}
qless () {
  less $(qlog $@)
}
qcat () {
  cat $(qlog $@)
}
qlog () {
  if [ "$#" -eq 1 ]; then
    echo $(qstat -j $1 | grep stdout_path_list | cut -d ":" -f4) 
  elif [ "$#" -eq 2 ]; then
    qq_dir=$(qlog $1)
    echo $(ls ${qq_dir}/*o${1}.${2})
  else
    echo "Usage: q<command> <jobid>" >&2
    echo "Usage: q<command> <array_jobid> <sub_jobid>" >&2
  fi
}
qdesc () {
  qstat | tail -n +3 | while read line; do
    job=$(echo $line | awk '{print $1}')
    if [ -z "$(qstat -j $job | grep "job-array tasks")" ]; then
      echo $job $(qlog $job)
    else
      qq_dir=$(qlog $job)
      if [ $(echo $line | awk '{print $5}') = 'r' ]; then
        sub_job=$(echo $line | awk '{print $10}')
        qq_dir=$(qlog $job)
        log_file=$(find ${qq_dir} -name "*o${job}.${sub_job}")
        echo $job $sub_job $(grep -o -m 1 -E "expdir=[^ ]* "  $log_file | cut -d "=" -f2)
      else
        echo $job $qq_dir "qw"
      fi
    fi
  done
}

# docker
alias dsts='docker stack services demo'
alias dstr='docker stack rm demo'
alias dstd='docker stack deploy -c demo.yml demo'
alias dstp='docker stack ps demo'
alias ds='docker stats'
alias di='docker images'
alias dl='docker logs'
# stop and remove all containers
alias harpoon='(docker stop $(docker ps -a -q); docker rm -f $(docker ps -a -q))'
# remove all untagged images
alias flense='docker rmi -f $(docker images | grep "^<none>" | awk "{print $3}")'
function jonah() { docker exec -it $@ /bin/bash ;}
