# ============================================================================
# EasyEffects Audio Processing Configuration
# Location: hm/applications/easyeffects.nix
# ==========================================================================
{pkgs, ...}: {
  # ==========================================================================
  # SYSTEMD USER SERVICE
  # ==========================================================================
  # Run EasyEffects as a background service
  systemd.user.services.easyeffects = {
    Unit = {
      Description = "EasyEffects Audio Effects Daemon";
      After = ["graphical-session.target"];
      PartOf = ["graphical-session.target"];
    };

    Service = {
      Type = "dbus"; # Uses D-Bus activation
      BusName = "com.github.wwmm.easyeffects";
      ExecStart = "${pkgs.easyeffects}/bin/easyeffects --gapplication-service";
      Restart = "on-failure";
      RestartSec = 5;
    };

    Install = {
      WantedBy = ["graphical-session.target"];
    };
  };

  # ==========================================================================
  # PACKAGE INSTALLATION
  # ==========================================================================
  # Install EasyEffects and dependencies
  home.packages = with pkgs; [
    easyeffects
    lsp-plugins # Additional audio plugins
  ];
}
