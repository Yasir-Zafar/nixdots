# nixos/users/default.nix
{
  config,
  pkgs,
  ...
}: {
  # Replace "username" with your actual username
  imports = [
    ./username.nix # Create this file with your username
  ];

  # User account configuration
  users.users.boi = {
    # Replace "username"
    isNormalUser = true;
    description = "Yasir Zafar"; # Replace with your name
    extraGroups = [
      "wheel" # Enable sudo
      "networkmanager" # Network management
      "audio" # Audio devices
      "video" # Video devices
      "input" # Input devices
      "storage" # Storage devices
      "gamemode" # GameMode
    ];
    shell = pkgs.zsh; # or pkgs.zsh if you prefer
  };

  programs.zsh.enable = true;
}
