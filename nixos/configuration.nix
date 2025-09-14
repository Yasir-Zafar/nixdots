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
    ./users
    ./security
    ./services
  ];

  environment.systemPackages = with pkgs; [
    vim
  ];

  nix.settings.experimental-features = ["nix-command" "flakes"];

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # System state version
  system.stateVersion = "25.05";
}
