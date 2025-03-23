#!/bin/bash

if [ -z "$1" ]; then
    echo "Usage: $0 <hostname>"
    exit 1
fi

HOSTNAME=$1

cat <<EOL
NodeName=$HOSTNAME Name=gpu File=/dev/nvidia[0-7]
EOL