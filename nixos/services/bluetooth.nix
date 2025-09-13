# nixos/services/bluetooth.nix
{
  config,
  pkgs,
  ...
}: {
  # Bluetooth configuration
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
    settings = {
      General = {
        Enable = "Source,Sink,Media,Socket";
        Experimental = true;
      };
    };
  };

  # Bluetooth packages
  environment.systemPackages = with pkgs; [
    bluez
    bluez-tools
  ];
}
