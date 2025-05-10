# settings/locale.nix
{ config, lib, pkgs, ... }:

{
  # Set your time zone
  time.timeZone = "Asia/Karachi"; # Adjust according to your location
  
  # Configure locale settings
  i18n = {
    defaultLocale = "en_GB.UTF-8";
    extraLocaleSettings = {
      LC_ADDRESS = "en_GB.UTF-8";
      LC_IDENTIFICATION = "en_GB.UTF-8";
      LC_MEASUREMENT = "en_GB.UTF-8";
      LC_MONETARY = "en_GB.UTF-8";
      LC_NAME = "en_GB.UTF-8";
      LC_NUMERIC = "en_GB.UTF-8";
      LC_PAPER = "en_GB.UTF-8";
      LC_TELEPHONE = "en_GB.UTF-8";
      LC_TIME = "en_GB.UTF-8";
    };
    supportedLocales = [
      "en_GB.UTF-8/UTF-8"
      # Add other locales as needed
    ];
  };
  
  # Configure console
  console = {
    font = "Lat2-Terminus16";
    keyMap = "us";
    useXkbConfig = true;
  };
  
  # Enable NTP time synchronization
  services.timesyncd.enable = true;
  
  # Use NetworkManager to manage network interfaces
  networking.useDHCP = false;
  networking.networkmanager.enable = true;
}
