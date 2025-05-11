#!/usr/bin/env bash

# Power menu script for eww
# This script shows a simple power menu using eww

# Create a temporary power menu widget
create_power_menu() {
    cat > /tmp/eww_power_menu.yuck << EOF
(defwindow power_menu
  :monitor 0
  :geometry (geometry :x "0%"
                      :y "0px"
                      :width "100%"
                      :height "100%"
                      :anchor "center")
  :stacking "overlay"
  (box :class "power-menu-container"
       :orientation "h"
       :space-evenly true
       :valign "center"
       :halign "center"
    (box :class "power-menu"
         :orientation "h"
         :space-evenly true
      (button :class "power-menu-btn shutdown-btn"
              :tooltip "Shutdown"
              :onclick "systemctl poweroff"
        "")
      (button :class "power-menu-btn reboot-btn"
              :tooltip "Reboot"
              :onclick "systemctl reboot"
        "")
      (button :class "power-menu-btn logout-btn"
              :tooltip "Logout"
              :onclick "hyprctl dispatch exit"
        "")
      (button :class "power-menu-btn lock-btn"
              :tooltip "Lock"
              :onclick "swaylock"
        "")
      (button :class "power-menu-btn cancel-btn"
              :tooltip "Cancel"
              :onclick "eww -c /tmp close power_menu && rm /tmp/eww_power_menu.yuck /tmp/eww_power_menu.scss"
        ""))))
EOF

    cat > /tmp/eww_power_menu.scss << EOF
.power-menu-container {
  background-color: rgba(40, 40, 40, 0.5);
}

.power-menu {
  background-color: #282828;
  border-radius: 20px;
  padding: 20px;
}

.power-menu-btn {
  font-size: 24px;
  padding: 15px;
  margin: 10px;
  border-radius: 20px;
  background-color: #3c3836;
  min-width: 60px;
  min-height: 60px;
  
  &:hover {
    background-color: #504945;
  }
  
  &:active {
    background-color: #665c54;
  }
}

.shutdown-btn {
  color: #fb4934;
}

.reboot-btn {
  color: #fabd2f;
}

.logout-btn {
  color: #b8bb26;
}

.lock-btn {
  color: #83a598;
}

.cancel-btn {
  color: #d5c4a1;
}
EOF

    # Open the power menu
    eww -c /tmp open power_menu
}

create_power_menu
