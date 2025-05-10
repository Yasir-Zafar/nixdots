# hosts/dpix720/networking.nix
{ config, lib, pkgs, ... }:

{
  networking = {
    # Hostname is already defined in default.nix
    
    # Enable NetworkManager
    networkmanager = {
      enable = true;
      wifi.backend = "iwd"; # Modern WiFi backend
    };
    
    # Enable Wireless
    wireless.iwd.enable = true;
    
    # DNS settings
    nameservers = [ "1.1.1.1" "1.0.0.1" ];
  };
  
  # Install network management tools
  environment.systemPackages = with pkgs; [
    iw
    wirelesstools
  ];
}
