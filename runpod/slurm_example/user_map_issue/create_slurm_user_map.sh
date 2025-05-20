#!/bin/bash

users=(abhays jonk elizabethd alexc alexh andya arame aryog daniellee haileyj igors jacobg jeffg judys mateuszp michaelh minhl nater stewarts thomasj runjinc kitf aidane jifanz tianyiq johnh)

echo 'declare -A user_uid_map=('
for user in "${users[@]}"; do
    uid=$(id -u "$user")
    echo "    [$user]=$uid"
done
echo ')'
echo 'GROUP_NAME="slurmusers"'
echo 'GROUP_GID=2000'