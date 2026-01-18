# nixos/configuration.nix
{pkgs, ...}: {
  imports = [
    ./hardware
    ./boot
    ./desktop
    ./gaming
    ./development
    ./users
    ./security
    ./services
  ];

  environment.systemPackages = with pkgs; [
    vim

    wineWowPackages.stable

    gnome-firmware
  ];

  nix.settings.experimental-features = ["nix-command" "flakes"];

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # System state version
  system.stateVersion = "25.05";
}
