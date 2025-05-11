#!/usr/bin/env bash
# Enhanced Bluetooth management script for eww

check_bluetooth_status() {
    if bluetoothctl show | grep -q "Powered: yes"; then
        echo "on"
    else
        echo "off"
    fi
}

get_connected_device() {
    if [[ $(check_bluetooth_status) == "on" ]]; then
        # Get the name of the first connected device, or "No device" if none
        DEVICE_NAME=$(bluetoothctl devices Connected | head -n 1 | cut -d' ' -f3-)
        if [[ -z "$DEVICE_NAME" ]]; then
            echo "No device"
        else
            echo "$DEVICE_NAME"
        fi
    else
        echo "Bluetooth Off"
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
    device)
        get_connected_device
        ;;
    toggle)
        toggle_bluetooth
        ;;
    *)
        echo "Usage: $0 {status|device|toggle}"
        exit 1
        ;;
esac
