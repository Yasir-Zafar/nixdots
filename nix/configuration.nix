{ config, lib, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  networking.hostName = "dpix720"; # Define your hostname.
  networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.

  # Set your time zone.
  time.timeZone = "Asia/Karachi";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_GB.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    keyMap = "us";
  #   useXkbConfig = true; # use xkb.options in tty.
  };

  services.flatpak.enable = true; 

  xdg.portal.enable = true;
  xdg.portal.wlr.enable = true;

  # Enable sound.
  services.pipewire = {
    enable = true;
    pulse.enable = true;
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.boi = {
    isNormalUser = true;
    extraGroups = [ "wheel" "NetworkManager" ]; # Enable ‘sudo’ for the user.
    packages = with pkgs; [
      tree
    ];
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    wget
    git
    gcc
    curl
    wget
    kitty
  ];

  fileSystems."/mnt/home/boi/Data" = {
    device = "/dev/sda1";
    fsType = "ext4";
    options = ["nofail" "noauto"];
  };

  hardware.graphics = {
    enable = true;
  };

  services.power-profiles-daemon.enable = true;
  programs.hyprland.enable = true;

  nixpkgs.config.allowUnfree = true;

  nix = {
    settings = {
      experimental-features = [ "nix-command flakes" ];
      auto-optimise-store = true;
      warn-dirty = false;
      trusted-users = ["root" "boi"];
      max-jobs = "auto";
      cores = 0;

      substituters = ["https://cache.nixos.org" "https://nix-community.cachix.org" "https://hyprland.cachix.org"];
      #trusted-public-keys = ["hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBNioiJM7ypFP8PwtkuGC="];
    };
  };

  system.stateVersion = "24.11"; # Did you read the comment?

}

