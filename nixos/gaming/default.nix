# nixos/gaming/default.nix
# Gaming setup with Steam, emulators, and performance tools
{pkgs, ...}: {
  imports = [
    ./steam.nix
    ./performance.nix
    ./retroarch.nix
  ];

  # ============================================================================
  # Gaming Applications
  # ============================================================================
  environment.systemPackages = with pkgs; [
    # ---------------------------------------------------------------------------
    # Wine & Compatibility Layers
    # ---------------------------------------------------------------------------
    bottles # Modern Wine prefix manager (GUI)
    winetricks # Wine configuration utility
    lutris # Universal game launcher

    # Proton Tools
    protonup-qt # Proton-GE installer (GUI)
    protontricks # Winetricks for Proton games

    # ---------------------------------------------------------------------------
    # Game Performance
    # ---------------------------------------------------------------------------
    gamemode # CPU governor optimization for games

    # ---------------------------------------------------------------------------
    # Game Launchers & Platforms
    # ---------------------------------------------------------------------------
    heroic # Epic Games & GOG launcher
    prismlauncher # Minecraft launcher (open-source)
    lunar-client # Minecraft PvP client
    cartridges # Game library manager

    # ---------------------------------------------------------------------------
    # Emulators
    # ---------------------------------------------------------------------------
    dolphin-emu # GameCube & Wii emulator
    # Note: Additional emulators in retroarch.nix

    # ---------------------------------------------------------------------------
    # GNOME Games (Casual Gaming)
    # ---------------------------------------------------------------------------
    gnome-mahjongg # Mahjong solitaire
    gnome-chess # Chess game
    gnome-2048 # 2048 puzzle game
    gnome-klotski # Sliding block puzzle
    gnome-nibbles # Snake game
    gnome-mines # Minesweeper
    gnome-sudoku # Sudoku puzzle
    gnome-taquin # Sliding tile puzzle
  ];

  # ============================================================================
  # Docker Configuration
  # ============================================================================
  # Used for containerized game servers and some gaming tools
  virtualisation.docker = {
    enable = true;
    # Optional: Enable automatic pruning of unused Docker resources
    autoPrune = {
      enable = true;
      dates = "weekly";
    };
  };

  # Add user to docker group for rootless docker commands
  users.users.boi.extraGroups = ["docker"];
}
