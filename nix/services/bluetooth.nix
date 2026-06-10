{pkgs, ...}: {
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;

    settings = {
      General = {
        Experimental = true;
        ControllerMode = "dual";
        Name = "mntbnd-bt";
        Class = "0x000100";
        AutoEnable = true;
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
