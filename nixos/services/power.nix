# NixOS Tuned Service Configuration
{
  services = {
    tuned = {
      enable = true;

      profile = "laptop-battery-powersave";

      ppdSupport = true;
      ppdSettings = {
        main = {
          battery_detection = true;
        };
      };
    };

    upower.enable = true;

    power-profiles-daemon.enable = false;
  };
}
