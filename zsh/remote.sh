#!/bin/zsh

# env
export PATH="$HOME/.local/bin:$PATH"

# extra aliases
alias ls='ls -hF --color' # add colors for filetype recognition
alias deploydf="~/git/dotfiles/deploy.sh remote"

# -------------------------------------------------------------------
# speechmatics
# -------------------------------------------------------------------

# virtual envs
alias veh="source /home/willw/venv_hydra/bin/activate"
alias ve2="source ~/venv2/bin/activate"

# make file
alias m='make'
alias mc="make check"
alias mf="make format"
alias mtest="make test"
alias mft="make functest"
alias mut="make unittest"

# tensorboard
alias tbr='~/git/dotfiles/scripts/remote_tensorboard_launch.sh'
alias tbkill="ps aux | grep tensorboard | grep johnh | awk '{print \$2}' | xargs kill"

# quick navigation
alias cdc="cd ~/git/hydra"
alias dev='cd /cantab/dev/inbetweeners/hydra'
alias data='cd /cantab/data'
exp () {
  cd /cantab/exp0/inbetweeners/hydra
  ls -tcrd johnh*
}

# gpu
alias qq='qstat -f -u "*"'
alias q='qstat'
alias qcpu='qstat -f -u "*" -q cpu.q'
alias qgpu='qstat -f -u "*" -q gpu.q'
alias qtop='qalter -p 1024'
alias gpu='qlogin -q gpu.q -now n'
alias gpu980='qlogin -q gpu.q@@980'
alias titanx='qlogin -q gpu.q@@titanx'
alias nv='nvidia-smi'
alias cuda0='export CUDA_VISIBLE_DEVICES=0'
alias cuda1='export CUDA_VISIBLE_DEVICES=1'
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