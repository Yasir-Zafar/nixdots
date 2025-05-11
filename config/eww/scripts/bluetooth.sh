#!/usr/bin/env bash

# Bluetooth management script for eww

check_bluetooth_status() {
    if bluetoothctl show | grep -q "Powered: yes"; then
        echo "on"
    else
        echo "off"
    fi
}

toggle_bluetooth() {
    if [[ $(check_bluetooth_status) == "on" ]]; then
        bluetoothctl power off
        notify-send "Bluetooth" "Bluetooth disabled" -i bluetooth-disabled
    else
        bluetoothctl power on
        notify-send "Bluetooth" "Bluetooth enabled" -i bluetooth-active
    fi
}

case "$1" in
    status)
        check_bluetooth_status
        ;;
    toggle)
        toggle_bluetooth
        ;;
    *)
        echo "Usage: $0 {status|toggle}"
        exit 1
        ;;
esac
