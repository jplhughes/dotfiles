#!/bin/bash

SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)

declare -A user_uid_map=(
    [abhays]=1000
    [jonk]=1001
    [elizabethd]=1002
    [alexc]=1003
    [alexh]=1004
    [andya]=1005
    [arame]=1006
    [aryog]=1007
    [daniellee]=1008
    [haileyj]=1009
    [igors]=1010
    [jacobg]=1011
    [jeffg]=1012
    [judys]=1013
    [mateuszp]=1014
    [michaelh]=1015
    [minhl]=1016
    [nater]=1017
    [stewarts]=1018
    [thomasj]=1019
    [runjinc]=1020
    [kitf]=1021
    [aidane]=1022
    [jifanz]=1023
    [tianyiq]=1024
    [johnh]=1025
)
GROUP_NAME="slurmusers"
GROUP_GID=2000

# Ensure group exists with consistent GID
if ! getent group "$GROUP_NAME" > /dev/null; then
    groupadd -g "$GROUP_GID" "$GROUP_NAME"
else
    groupmod -g "$GROUP_GID" "$GROUP_NAME"
fi

for user in "${!user_uid_map[@]}"; do
    uid=${user_uid_map[$user]}

    if id "$user" &>/dev/null; then
        # Update existing user
        usermod -u "$uid" -g "$GROUP_GID" "$user"
        sudo chown -R "$uid:$GROUP_GID" "/home/$user"
        sudo chgrp -R "$GROUP_GID" "/home/$user"
    else
        echo "User $user not found"
    fi

    usermod -aG sudo "$user"
done
