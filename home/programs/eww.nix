{ config, lib, pkgs, ... }:

{
  # Enable eww
  programs.eww = {
    enable = true;
    package = pkgs.eww;
    configDir = ./../../config/eww;
  };

  # Create the configuration directory
  home.file = {
    # Main eww configuration
    ".config/eww/eww.yuck".source = ./../../config/eww/eww.yuck;
    ".config/eww/eww.scss".source = ./../../config/eww/eww.scss;
    
    # Scripts
    ".config/eww/scripts/battery.sh" = {
      source = ./../../config/eww/scripts/battery.sh;
      executable = true;
    };
    ".config/eww/scripts/brightness.sh" = {
      source = ./../../config/eww/scripts/brightness.sh;
      executable = true;
    };
    ".config/eww/scripts/volume.sh" = {
      source = ./../../config/eww/scripts/volume.sh;
      executable = true;
    };
    ".config/eww/scripts/wifi.sh" = {
      source = ./../../config/eww/scripts/wifi.sh;
      executable = true;
    };
    ".config/eww/scripts/bluetooth.sh" = {
      source = ./../../config/eww/scripts/bluetooth.sh;
      executable = true;
    };
    ".config/eww/scripts/workspaces.sh" = {
      source = ./../../config/eww/scripts/workspaces.sh;
      executable = true;
    };
    ".config/eww/scripts/dnd.sh" = {
      source = ./../../config/eww/scripts/dnd.sh;
      executable = true;
    };
  };

  # Ensure these packages are installed for our scripts
  home.packages = with pkgs; [
    bash
    brightnessctl
    pamixer
    networkmanager
    bluez
    jq
    socat
  ];
}
