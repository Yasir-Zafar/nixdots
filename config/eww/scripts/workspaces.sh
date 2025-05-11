#!/usr/bin/env bash

# Workspace management script for eww
# This script monitors Hyprland workspaces and outputs JSON for eww

get_workspaces() {
    # Get active workspace
    active=$(hyprctl monitors -j | jq '.[0].activeWorkspace.id')
    
    # Get occupied workspaces (workspaces with windows)
    occupied=$(hyprctl workspaces -j | jq '[.[].id] | sort')
    
    # Generate JSON for all workspaces from 1 to 10
    seq 1 10 | jq --argjson active "$active" --argjson occupied "$occupied" -nc '
        {
            "id": .,
            "current": . == $active,
            "windows": $occupied | index(.) != null
        }
    ' | jq -s '.'
}

# Initial workspace state
get_workspaces

# Set up socket to listen for workspace changes
socat -u UNIX-CONNECT:/tmp/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock - | while read -r line; do
    case ${line%>>*} in
        *workspace*)
            get_workspaces
            ;;
        *createworkspace*)
            get_workspaces
            ;;
        *destroyworkspace*)
            get_workspaces
            ;;
        *moveworkspace*)
            get_workspaces
            ;;
        *openwindow*)
            get_workspaces
            ;;
        *closewindow*)
            get_workspaces
            ;;
    esac
done
