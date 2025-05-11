#!/usr/bin/env bash

# Brightness management script for eww

get_brightness() {
    brightnessctl -m | awk -F, '{print $4}' | tr -d '%'
}

case "$1" in
    get)
        get_brightness
        ;;
    set)
        if [[ -n "$2" && "$2" -ge 1 && "$2" -le 101 ]]; then
            brightnessctl set "$2%"
            get_brightness
        else
            echo "Error: Invalid brightness value"
            exit 1
        fi
        ;;
    *)
        echo "Usage: $0 {get|set <percentage>}"
        exit 1
        ;;
esac
