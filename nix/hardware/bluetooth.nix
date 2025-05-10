# hardware/bluetooth.nix
{ config, lib, pkgs, ... }:

{
  # Enable bluetooth
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
    settings = {
      General = {
        Experimental = true;
        KernelExperimental = true;
        FastConnectable = true;
        JustWorksRepairing = "always";
        MultiProfile = "multiple";
        AutoEnable = true;
      };
      Policy = {
        AutoEnable = true;
      };
    };
  };
  
  # Install bluetooth tools
  environment.systemPackages = with pkgs; [
    bluez
    bluez-tools
    blueman
    #bluedevil
  ];
  
  # Enable bluetooth audio support
  services.blueman.enable = true;
}
