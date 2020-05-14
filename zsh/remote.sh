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
alias veh="source /cantab/dev/inbetweeners/hydra/venv_stable/bin/activate"
alias ve="source ~/venv/bin/activate"

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
alias cdh="cd ~/git/hydra"
alias dev='cd /cantab/dev/inbetweeners/hydra'
alias data='cd /cantab/data'
exp () {
  cd /cantab/exp0/inbetweeners
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
qcat () {
  if [ "$#" -eq 1 ]; then
    cat $(qstat -j $1 | grep log | grep std | cut -d ":" -f4)
  else
    echo "Usage: qcat <jobid>" >&2
  fi
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
