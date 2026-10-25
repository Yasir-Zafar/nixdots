# files, thumbnails, monitoring, system helpers
{
  lib,
  pkgs,
  ...
}: {
  home.packages = with pkgs; [
    nautilus
    loupe
    ffmpegthumbnailer
    gnome-epub-thumbnailer

    mission-center
    warehouse # flatpak manager
    powertop

    newsflash
    # gdm-settings # only useful with the gdm greeter (modules/nixos/desktop/greeters/gdm.nix)
    impression
    theclicker
    (callPackage ../../../pkgs/way-clicker {}) # gui autoclicker; open it once, then Mod+X starts/stops
  ];

  # way-clicker clicks through dotoolc, which hands the clicks to this daemon (it owns the
  # virtual mouse on /dev/uinput, so "uinput" group, nixos/gaming). Works on niri and bspwm
  systemd.user.services.dotoold = {
    Unit.Description = "dotool daemon (way-clicker)";
    Service = {
      ExecStart = "${pkgs.dotool}/bin/dotoold";
      Environment = ["PATH=${lib.makeBinPath [pkgs.coreutils pkgs.procps]}"]; # mkfifo, rm, pkill
    };
    Install.WantedBy = ["default.target"];
  };

  # age out thumbnails nobody looked at in 30 days (systemd-tmpfiles-clean, daily)
  systemd.user.tmpfiles.rules = [
    "e %h/.cache/thumbnails - - - 30d"
  ];

  programs.btop = {
    enable = true;
    settings = {
      color_theme = "gruvbox_material_dark"; # btop's own theme, not stylix
      theme_background = true;
      truecolor = true;
      rounded_corners = true;
      update_ms = 2000;
    };
  };
}
