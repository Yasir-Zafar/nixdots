{config, ...}: {
  systemd.user.services.battery-full-notify = {
    Unit.Description = "Notify when battery is full";
    Service = {
      Type = "oneshot";
      ExecStart = "${config.home.homeDirectory}/.local/bin/battery_full_notify.sh";
    };
  };

  systemd.user.timers.battery-full-notify = {
    Unit.Description = "Check battery level periodically";
    Timer = {
      OnBootSec = "2min";
      OnUnitActiveSec = "5min";
      Unit = "battery-full-notify.service";
    };
    Install.WantedBy = ["timers.target"];
  };
}
