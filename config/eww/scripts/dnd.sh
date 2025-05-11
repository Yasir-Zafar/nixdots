#!/usr/bin/env bash

# Do Not Disturb management script for eww

DND_FILE="$HOME/.cache/eww/dnd_status"

# Ensure directory exists
mkdir -p "$(dirname "$DND_FILE")"

# Initialize file if it doesn't exist
if [[ ! -f "$DND_FILE" ]]; then
    echo "off" > "$DND_FILE"
fi

check_dnd_status() {
    cat "$DND_FILE"
}

toggle_dnd() {
    if [[ $(check_dnd_status) == "on" ]]; then
        # Turn off DND
        echo "off" > "$DND_FILE"
        notify-send "Do Not Disturb" "Do Not Disturb disabled" -i notifications
    else
        # Turn on DND
        echo "on" > "$DND_FILE"
        notify-send "Do Not Disturb" "Do Not Disturb enabled" -i notifications-disabled
    fi
}

case "$1" in
    status)
        check_dnd_status
        ;;
    toggle)
        toggle_dnd
        ;;
    *)
        echo "Usage: $0 {status|toggle}"
        exit 1
        ;;
esac
