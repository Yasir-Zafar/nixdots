#!/usr/bin/env bash

# Script to get the status of Hyprland workspaces for EWW
# This script outputs a JSON array of workspaces with their status

# Get the active workspace ID
current=$(hyprctl monitors -j | jq '.[] | select(.focused) | .activeWorkspace.id')

# Get all occupied workspaces
occupied=$(hyprctl workspaces -j | jq '[.[].id] | sort')

# Create a JSON array with 6 workspaces (1-6)
# Each workspace has:
# - id: workspace number
# - current: whether it's the current workspace
# - occupied: whether it's occupied by any windows

echo '[' > /tmp/eww_workspaces.json
for i in {1..6}; do
  is_current=$([ "$i" -eq "$current" ] && echo "true" || echo "false")

  # Check if workspace is in occupied list
  is_occupied=$(echo "$occupied" | jq -r "contains([$i])")

  # Don't mark current workspace as just occupied
  if [ "$is_current" = "true" ]; then
    is_occupied="false"
  fi

  # Add comma for all but the last entry
  comma=""
  if [ "$i" -lt 6 ]; then
    comma=","
  fi

  echo "{\"id\": $i, \"current\": $is_current, \"occupied\": $is_occupied}$comma" >> /tmp/eww_workspaces.json
done
echo ']' >> /tmp/eww_workspaces.json

cat /tmp/eww_workspaces.json
