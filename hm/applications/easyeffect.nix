{pkgs, ...}: {
  systemd.user.services.easyeffects = {
    Unit = {
      Description = "EasyEffects daemon";
      After = ["graphical-session.target"];
    };

    Service = {
      ExecStart = "${pkgs.easyeffects}/bin/easyeffects --gapplication-service";
      Restart = "on-failure";
    };

    Install = {
      WantedBy = ["graphical-session.target"];
    };
  };
}
