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

echo "First pass: Moving users and their groups to temporary IDs..."
temp_offset=3000
for user in "${!user_uid_map[@]}"; do
    if id "$user" &>/dev/null; then
        temp_id=$((temp_offset))
        echo "Moving $user to temporary UID $temp_id"
        usermod -u "$temp_id" "$user"
        
        if getent group "$user" &>/dev/null; then
            echo "Moving group $user to temporary GID $temp_id"
            groupmod -g "$temp_id" "$user"
        fi
        
        ((temp_offset++))
    else
        echo "User $user not found"
    fi
done

# Second pass: Set the final target UIDs and GIDs
echo "Second pass: Setting target UIDs and GIDs..."
for user in "${!user_uid_map[@]}"; do
    if id "$user" &>/dev/null; then
        uid=${user_uid_map[$user]}
        echo "Setting $user to target UID $uid and GID $GROUP_GID"
        
        # Change user's primary group to the common group first
        usermod -g "$GROUP_GID" "$user"
        
        # Update the user's UID
        usermod -u "$uid" "$user"
        
        # If user has a corresponding group, update its GID to match UID
        if getent group "$user" &>/dev/null; then
            echo "Setting group $user to GID $uid"
            groupmod -g "$uid" "$user"
        fi
        
        Update ownership of home directory
        sudo chown -R "$uid:$GROUP_GID" "/home/$user"
        sudo chgrp -R "$GROUP_GID" "/home/$user"
        
        Add to sudo group
        usermod -aG sudo "$user"
    fi
done

echo "User and group remapping completed"
