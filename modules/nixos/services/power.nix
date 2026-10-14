{
  services = {
    tuned = {
      enable = true;
      settings.daemon = true;
      # off: a polling loop tuned's own docs call resource-hungry; profiles work without it
      settings.dynamic_tuning = false;
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
