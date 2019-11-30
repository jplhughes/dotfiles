#!/bin/bash

 

if (( $# > 2 ));
   then echo "invalid number of args"
   exit 1
fi

 

destination=$1
if [[ $# -eq 0 ]];
    then destination="johnh@code19.cantabresearch.com"
fi

 
if [[ $destination == "codex" ]];
    then destination="johnh@code19.cantabresearch.com"
fi
if [[ $destination == "sergei" ]];
    then destination=john@${MOWBRAY_IP}
fi
if [[ $destination == "colo" ]];
    then destination=johnh@cam2g01.farm.speechmatics.io
fi

 

port=6006
# Overwrite port if it is given
if [[ $# -eq 2 ]];
    then port=${2}
fi
echo "Running tensorboard from machine ${destination} on port ${port}"
open "http://localhost:${port}"
ssh -NL localhost:${port}:localhost:${port} $destination
