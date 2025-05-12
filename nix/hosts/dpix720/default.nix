# hosts/dpix720/default.nix
{ config, pkgs, lib, inputs, ... }:

{
  imports = [
    # Import hardware configuration
    ./hardware-configuration.nix
    # Import other host-specific configurations
    ./filesystems.nix
    ./networking.nix
    ./boot.nix
  ];

  # Hostname
  networking.hostName = "dpix720";
  
  # Enable networking
  networking.networkmanager.enable = true;
  
  # Enable sound
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };
  
  # Basic system packages
  environment.systemPackages = with pkgs; [
    vim
    wget
    git
    curl
    htop
    pciutils
    usbutils
    killall
    unzip
    zip
    file
    tree
    gnumake
    cachix
  ];
  
  # Users
  users.users.boi = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "video" "audio" "input" ];
    initialPassword = "787898";
    shell = pkgs.zsh;
  };

  # Basic system configuration
  system.stateVersion = "24.11"; # Never change this value
}
