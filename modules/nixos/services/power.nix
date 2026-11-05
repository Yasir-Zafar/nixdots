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

    # Intel's thermal daemon: this laptop has the Intel DPTF tables (INT3400), so it runs
    # in adaptive mode and applies HP's own thermal/power limits. Works next to tuned
    # (tuned picks the profile, thermald keeps temperatures inside HP's limits).
    # Added 2026-11-05 as a trial; if it throttles too early, remove this line.
    thermald.enable = true;

    upower.enable = true;
    power-profiles-daemon.enable = false;
  };
}
