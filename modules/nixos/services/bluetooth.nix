{
  pkgs,
  my,
  ...
}: {
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;

    settings = {
      General = {
        Experimental = true;
        ControllerMode = "dual";
        Name = "${my.host}-bt";
        Class = "0x000100";
      };

      Policy = {
        AutoEnable = true;
      };
    };
  };

  environment.systemPackages = with pkgs; [
    bluez
    bluez-tools
  ];
}
