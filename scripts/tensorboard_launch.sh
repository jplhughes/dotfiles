#! /bin/bash -e

port=6006
# Override port if it is given
if [[ $# -eq 1 ]]; then
    port=$1
fi
source $HOME/git/hydra/venv/bin/activate
echo "tensorboard running"
tensorboard --logdir=. --port=port
