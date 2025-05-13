# nixos/services/bluetooth.nix
{ pkgs, ... }:

{
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
    settings = {
      General = {
        Enable = "Source,Sink,Media,Socket";
        Experimental = true;
        KernelExperimental = true;
        FastConnectable = true;
        AutoEnable = true;
        ControllerMode = "dual";
      };
      Policy = {
        AutoEnable = true;
        ReconnectAttempts = 7;
        ReconnectIntervals = "1,2,4,8,16,32,64";
      };
    };
  };

  # Set up BlueZ for better audio quality
  systemd.packages = [ pkgs.bluez ];
  systemd.user.services.mpris-proxy = {
    description = "Mpris proxy";
    after = [ "network.target" "sound.target" ];
    wantedBy = [ "default.target" ];
    serviceConfig.ExecStart = "${pkgs.bluez}/bin/mpris-proxy";
  };

  # Enable blueman for GUI management
  services.blueman.enable = true;

  # Install helpful Bluetooth utilities
  environment.systemPackages = with pkgs; [
    bluetuith # Terminal UI for Bluetooth
    blueberry # Bluetooth management GUI
    bluez-tools # CLI tools
  ];
}
