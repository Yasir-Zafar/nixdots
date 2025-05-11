#!/usr/bin/env bash

# Volume management script for eww

get_volume() {
    pamixer --get-volume
}

is_muted() {
    pamixer --get-mute
}

case "$1" in
    get)
        if [[ $(is_muted) == "true" ]]; then
            echo "0"
        else
            get_volume
        fi
        ;;
    set)
        if [[ -n "$2" && "$2" -ge 0 && "$2" -le 101 ]]; then
            pamixer --set-volume "$2"
            get_volume
        else
            echo "Error: Invalid volume value"
            exit 1
        fi
        ;;
    toggle)
        pamixer --toggle-mute
        ;;
    *)
        echo "Usage: $0 {get|set <percentage>|toggle}"
        exit 1
        ;;
esac
