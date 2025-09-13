# nixos/configuration.nix
{
  config,
  pkgs,
  ...
}: {
  imports = [
    ./hardware
    ./boot
    ./desktop
    ./gaming
    ./development
  ];

  networking.hostName = "mnt_bnd"; # Define your hostname.
  networking.networkmanager.enable = true; # Easiest to use and most distros use this by default.

  time.timeZone = "Asia/Kararchi";
  environment.systemPackages = with pkgs; [
    vim
    wget
    ghostty
    unrar
  ];

  nix.settings.experimental-features = ["nix-command" "flakes"];

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # System state version
  system.stateVersion = "25.05";
}
