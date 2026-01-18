# ===== hm/dotfiles/scripts/default.nix =====
{pkgs, ...}: let
  # Custom scripts
  rebuild-system = pkgs.writeShellScriptBin "rebuild-system" ''
    #!/bin/bash

    echo "Rebuilding NixOS system configuration..."
    sudo nixos-rebuild switch --flake ~/nix-config/nixos

    echo "Rebuilding Home Manager configuration..."
    home-manager switch --flake ~/nix-config/hm

    echo "System rebuild complete!"
  '';

  update-system = pkgs.writeShellScriptBin "update-system" ''
    #!/bin/bash

    echo "Updating flake inputs..."
    cd ~/nix-config/nixos && nix flake update
    cd ~/nix-config/hm && nix flake update

    echo "Rebuilding with updates..."
    rebuild-system
  '';

  cleanup-system = pkgs.writeShellScriptBin "cleanup-system" ''
    #!/bin/bash

    echo "Cleaning up old generations..."
    sudo nix-collect-garbage -d
    home-manager expire-generations "-30 days"

    echo "Optimizing nix store..."
    sudo nix store optimise

    echo "System cleanup complete!"
  '';

  dev-env = pkgs.writeShellScriptBin "dev-env" ''
    #!/bin/bash

    # Quick development environment setup
    PROJECT_NAME=$1

    if [ -z "$PROJECT_NAME" ]; then
        echo "Usage: dev-env <project-name>"
        exit 1
    fi

    mkdir -p ~/Projects/$PROJECT_NAME
    cd ~/Projects/$PROJECT_NAME

    # Create basic flake template
    if [ ! -f flake.nix ]; then
        nix flake init
        echo "Created basic flake template"
    fi

    # Enter development shell
    nix develop
  '';
in {
  home.packages = [
    rebuild-system
    update-system
    cleanup-system
    dev-env
  ];

  # Additional utility scripts can be added here
  home.file = {
    # Bash functions and utilities
    ".local/bin/nix-utils" = {
      text = ''
        #!/bin/bash

        # Collection of useful Nix utilities

        function nix-search-local() {
            nix search nixpkgs "$1"
        }

        function nix-info() {
            nix-shell -p nix-info --run "nix-info -m"
        }

        function hm-news() {
            home-manager news
        }

        # Show system generations
        function show-generations() {
            echo "=== NixOS Generations ==="
            sudo nix-env --list-generations --profile /nix/var/nix/profiles/system

            echo ""
            echo "=== Home Manager Generations ==="
            home-manager generations
        }
      '';
      executable = true;
    };

    ".local/bin/battery_full_notify.sh" = {
      text = ''
        #!/usr/bin/env bash

        BAT_PATH="/sys/class/power_supply/BAT1"
        LEVEL=$(cat "$BAT_PATH/capacity")
        STATUS=$(cat "$BAT_PATH/status")

        if [[ "$STATUS" == "Full" || ( "$STATUS" == "Charging" && "$LEVEL" -ge 80 ) ]]; then
            notify-send "🔋 Battery Full" "Unplug the charger to preserve battery health." \
              --urgency=critical --expire-time=0
        fi
      '';
      executable = true;
    };
  };

  imports = [
    ./battery-full-notif.nix
  ];
}
