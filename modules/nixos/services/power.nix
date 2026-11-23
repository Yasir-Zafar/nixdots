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

    # thermald: adaptive mode with HP's DPTF limits, next to tuned (trial since 2026-11-05)
    thermald.enable = true;

    upower.enable = true;
    power-profiles-daemon.enable = false;

    # lid: suspend unless docked; then mango moves to the external screen (logind defaults, written out)
    logind.settings.Login = {
      HandleLidSwitch = "suspend";
      HandleLidSwitchExternalPower = "suspend";
      HandleLidSwitchDocked = "ignore";
    };
  };
}
