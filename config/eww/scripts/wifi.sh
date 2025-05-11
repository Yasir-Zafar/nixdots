#!/usr/bin/env bash
# Enhanced WiFi management script for eww

check_wifi_status() {
    WIFI_STATUS=$(nmcli -t -f WIFI radio)
    if [[ "$WIFI_STATUS" == "enabled" ]]; then
        CONN_STATUS=$(nmcli -t -f STATE g)
        if [[ "$CONN_STATUS" == "connected" ]]; then
            echo "connected"
        else
            echo "disconnected"
        fi
    else
        echo "disabled"
    fi
}

get_wifi_name() {
    if [[ $(check_wifi_status) == "connected" ]]; then
        SSID=$(nmcli -t -f NAME connection show --active | head -n 1)
        if [[ -z "$SSID" ]]; then
            echo "Unknown Network"
        else
            echo "$SSID"
        fi
    else
        echo "Not connected"
    fi
}

toggle_wifi() {
    if [[ $(nmcli -t -f WIFI radio) == "enabled" ]]; then
        nmcli radio wifi off
        notify-send "WiFi" "WiFi disabled" -i network-wireless-disabled
    else
        nmcli radio wifi on
        notify-send "WiFi" "WiFi enabled" -i network-wireless
    fi
}

case "$1" in
    status)
        check_wifi_status
        ;;
    name)
        get_wifi_name
        ;;
    toggle)
        toggle_wifi
        ;;
    *)
        echo "Usage: $0 {status|name|toggle}"
        exit 1
        ;;
esac
