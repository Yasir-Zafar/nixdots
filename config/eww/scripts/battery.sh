#!/usr/bin/env bash

# Battery management script for eww

BAT=$(ls /sys/class/power_supply | grep BAT | head -n 1)

if [[ -z "$BAT" ]]; then
    echo "100"
    exit 0
fi

case "$1" in
    percentage)
        cat /sys/class/power_supply/$BAT/capacity
        ;;
    status)
        cat /sys/class/power_supply/$BAT/status
        ;;
    *)
        echo "Usage: $0 {percentage|status}"
        exit 1
        ;;
esac
