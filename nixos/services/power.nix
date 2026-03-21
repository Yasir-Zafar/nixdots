{
  services = {
    tuned = {
      enable = true;
      settings.daemon = true;
      settings.dynamic_tuning = true;
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
