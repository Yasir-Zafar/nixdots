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

  # Basic system configuration
  system.stateVersion = "24.11"; # Never change this value
  
  # Set your time zone
  time.timeZone = "Asia/Karachi"; # Change to your timezone
  
  # Hostname
  networking.hostName = "dpix720";
  
  # Enable networking
  networking.networkmanager.enable = true;
  
  # Enable sound
  sound.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };
  
  # Configure console settings
  console = {
    font = "Lat2-Terminus16";
    keyMap = "us";
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
    gcc
    cachix
  ];
  
  # Users
  users.users.boi = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "video" "audio" "input" ];
    initialPassword = "787898";
    shell = pkgs.zsh;
  };

  security.sudo.wheelNeedsPassword = false;
}
