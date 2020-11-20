#!/bin/zsh

# env
export PATH="$HOME/.local/bin:$PATH"

# extra aliases
alias ls='ls -hF --color' # add colors for filetype recognition

# -------------------------------------------------------------------
# speechmatics
# -------------------------------------------------------------------

# jupyter lab
alias jl="jupyter lab --no-browser --ip $(hostname)"
# virtual envs
alias veh="source /workspaces/hydra_venv_stable/bin/activate"
alias pth="source /workspaces/pychain_workspace_augment/path_dev.sh"
alias ve="source venv/bin/activate"

# make file
alias m='make'
alias mc="make check"
alias mf="make format"
alias mtest="make test"
alias mft="make functest"
alias mut="make unittest"

# tensorboard
alias tbr='source $HOME/venv_tb/bin/activate && tensorboard --host=$(hostname) --logdir=.'
alias tbkill="ps aux | grep tensorboard | grep johnh | awk '{print \$2}' | xargs kill"

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
alias cdh='cd ~/git/hydra'
alias dev='cd /cantab/dev/inbetweeners/hydra'
alias exp='cd /exp/asr_am/johnh'
alias hb='cd /exp/head_bench/johnh'
alias data='cd /perish_local/data'
alias ws='cd /workspaces/pychain_workspace_augment'
exp0 () {
  cd /cantab/exp0/inbetweeners/hydra
  ls -tcrd johnh*
}

# gpu
alias qq='qstat -f -u "*"'
alias q='qstat'
alias qc='source ~/venv_dashboard/bin/activate && ~/git/dotfiles/scripts/qstat.py'
alias qcpu='qstat -f -u "*" -q cpu.q'
alias qgpu='qstat -f -u "*" -q gpu.q'
alias qtop='qalter -p 1024'

alias qlogin='qlogin -q gpu.q -now n'
alias gpu980='qrsh -q gpu.q@@980 -pty no -now n'
alias titanx='qrsh -q gpu.q@@titanx -pty no -now n'
qrl () {
  if [ "$#" -eq 1 ]; then
    qrsh -q gpu.q@"$1".cantabresearch.com -pty no -now n
  else
    qrsh -q gpu.q -pty no -now n
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
