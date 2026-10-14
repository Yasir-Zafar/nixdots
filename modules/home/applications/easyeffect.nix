{pkgs, ...}: {
  systemd.user.services.easyeffects = {
    Unit = {
      Description = "EasyEffects Audio Effects Daemon";
      After = ["graphical-session.target"];
      PartOf = ["graphical-session.target"];
    };

    Service = {
      Type = "dbus";
      BusName = "com.github.wwmm.easyeffects";
      ExecStart = "${pkgs.easyeffects}/bin/easyeffects --gapplication-service";
      Restart = "on-failure";
      RestartSec = 5;
    };

    Install = {
      WantedBy = ["graphical-session.target"];
    };
  };

  home.packages = with pkgs; [
    easyeffects
    lsp-plugins
  ];
}
