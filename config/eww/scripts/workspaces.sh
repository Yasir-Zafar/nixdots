#!/usr/bin/env bash
# Enhanced workspaces script for eww

# Get active workspace
active=$(hyprctl monitors -j | jq '.[0].activeWorkspace.id')

# Get occupied workspaces - ensuring we handle empty/no workspaces case
occupied=$(hyprctl workspaces -j | jq '[.[].id]')
if [ -z "$occupied" ] || [ "$occupied" == "null" ]; then
    occupied="[]"
fi

# Define icons for each workspace
# You can customize these icons to your preference
icons=(
    '{"1": "󰎤", "2": "󰎧", "3": "󰎪", "4": "󰎭", "5": "󰎱", "6": "󰎳"}'
)

# Output wrapped in an object for Eww with proper icons
jq -n --argjson active "$active" --argjson occupied "$occupied" --argjson icons "${icons[0]}" '
{
  workspaces: [range(1; 7) | {
    id: .,
    icon: ($icons[tostring(.)]),
    current: (. == $active),
    occupied: ($occupied | contains([.]))
  }]
}
'
