{ pkgs, ... }: {
  services.udev.extraRules = ''
    ACTION=="add", SUBSYSTEM=="backlight", KERNEL=="intel_backlight", MODE="0666", RUN+="${pkgs.coreutils}/bin/chmod a+w /sys/class/backlight/%k/brightness"
  '';

  security = {
    sudo.wheelNeedsPassword = false;
  };

  services = {
    fstrim.enable = true;
    tlp.enable = true;
    gvfs.enable = true;
  };

  location = {
    provider = "geoclue2";
  };
}
