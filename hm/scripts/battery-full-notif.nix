{config, ...}: {
  systemd.user.services.battery-full-notify = {
    Unit.Description = "Notify when battery is full";
    Service.ExecStart = "${config.home.homeDirectory}/.local/bin/battery_full_notify.sh";
  };

  systemd.user.timers.battery-full-notify = {
    Unit.Description = "Run battery full notification every 2 minutes";
    Timer = {
      OnBootSec = "1min";
      OnUnitActiveSec = "2min";
      Unit = "battery-full-notify.service";
    };
    Install.WantedBy = ["timers.target"];
  };
}
